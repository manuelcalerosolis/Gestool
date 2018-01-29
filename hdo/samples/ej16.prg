/*
 * Proyecto: HDO_GENERAL
 * Fichero: ej16.prg
 * Descripci󮺠Manteniento simple de una tabla
 * Autor: Manu Exposito
 * Fecha: 20/01/2018
 */

//------------------------------------------------------------------------------

#include "hdo.ch"
#include "inkey.ch"

//------------------------------------------------------------------------------

#define SQLITE
//#define MYSQL

#ifdef SQLITE
	REQUEST RDLSQLITE
	#define _DBMS	"sqlite"
	#define _DB 	"hdodemo.db"
	#define _CONN
#else
	#ifdef MYSQL
		REQUEST RDLMYSQL
		#define _DBMS	"mysql"
		#define _DB		"hdodemo"
		#define _CONN 	"127.0.0.1", "root", "root"
	#endif
#endif

//------------------------------------------------------------------------------
// Definiciones

#define B_BOX ( CHR( 218 ) + CHR( 196 ) + CHR( 191 ) + CHR( 179 ) + ;
                CHR( 217 ) + CHR( 196 ) + CHR( 192 ) + CHR( 179 ) + " " )

// Nombre de la base de datos:
#define DB_NAME  "hdodemo.db"

// Sentencias precompiladas:
#define STMT_SEL "SELECT * FROM test WHERE idreg BETWEEN ? AND ?;"
#define STMT_INS "INSERT INTO test ( first, last, street, city, state, zip, hiredate, married, age, salary, notes ) VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? );"
#define STMT_UPD "UPDATE test set first = ?, last = ?, street = ?, city = ?, state = ?, zip = ?, hiredate = ?, married = ?, age = ?, salary = ?, notes = ? WHERE idreg = ?;"
#define STMT_DEL "DELETE FROM test WHERE idreg = ?;"

//------------------------------------------------------------------------------
// Variables estaticas que se van a usar en varias funciones

static oDb  								// Conexion con base de datos
static oRS                                  // Cursor local basado en un RowSet
static oSelect, oInsert, oUpdate, oDelete	// Objetos sentencias (statemet)
static idreg, first, last, street, city, ;
       state, zip, hiredate, married, ;
	   age, salary, notes 					// Variables de campos

static nRecIni := 1, nRecEnd := 100000

//------------------------------------------------------------------------------
// Procedimiento principal

procedure main16()

    local e, getlist := {}

	set date format to "dd-mm-yyyy"

	oDb := THDO():new( _DBMS )

    if oDb:connect( _DB, _CONN )
        try
            preparaStmt()

            // Creamos un RowSet que automaticamente hace un oSelect:execute()
            oRS := oSelect:fetchRowSet()

	        nRecIni := 0
            nRecEnd := 9999999

            menu()

            while inkey( 0 ) != 27

                cls

                @ 02, 02 SAY "Entrada de datos:"
                @ 04, 02 SAY "Entre rango inicial..................:" GET nRecIni PICTURE "@K 99999999"
                @ 05, 02 SAY "Entre rango final....................:" GET nRecEnd PICTURE "@K 99999999" VALID validaRango( nRecIni, nRecEnd )

				READ
				
                oRS:refresh()

                cabecera()
				
				Pie()
                miBrw()
                menu()
           end
        catch e
            eval( errorBlock(), e )
        finally
            oRS:free()
			liberaStmt()
            msg( "--- < FIN > ---" )
        end

    endif

    oDb:disconnect()

return

//------------------------------------------------------------------------------
// Browse para el objeto RowSet

static procedure miBrw()

    local i, oBrw := tbrowsenew( 2, 1, maxrow() -1 , maxcol() - 1 )

    hb_dispbox( 1, 0, maxrow() - 1, maxcol(), hb_utf8tostrbox( "┌─┐│┘─└│ " ), "W+/B, N/BG" )

    oBrw:colorSpec     := "W+/B, N/BG"
    oBrw:ColSep        := hb_utf8tostrbox( "│" )
    oBrw:HeadSep       := hb_utf8tostrbox( "┼─" )
    oBrw:FootSep       := hb_utf8tostrbox( "┴─" )
    oBrw:GoTopBlock    := {|| oRS:goTop() }
    oBrw:GoBottomBlock := {|| oRS:goBottom() }
    oBrw:SkipBlock     := {| nSkip | oRS:skipper( nSkip ) }
	
	genColumn( oBrw )
	
	frontControl( oBrw )

return

//------------------------------------------------------------------------------
// Controlador frontal

static procedure frontControl( oBrw )

	while .t.

        oBrw:forceStable()

        switch inkey()

        case K_ESC             	// Salir
            setpos( maxrow(), 0 )
			return

        case K_DOWN            	// Fila siguiente
            oBrw:Down()
            exit

        case K_UP              	// Fila anterior
            oBrw:Up()
            exit

        case K_LEFT            	// Va a la columna antrior
            oBrw:left()
            exit

        case K_RIGHT           	// Va a la columna siguiente
            oBrw:right()
            exit

        case K_PGDN             // Va a la pagina siguiente
            oBrw:pageDown()
            exit

        case K_PGUP             // Va a la pagina antrior
            oBrw:pageUp()
            exit

        case K_CTRL_PGUP        // Va al principio
            oBrw:goTop()
            exit

        case K_CTRL_PGDN        // Va al final
            oBrw:goBottom()
            exit

        case K_HOME             // Va a la primera columna visible
            oBrw:home()
            exit

        case K_END              // Va a la ultima columna visible
            oBrw:end()
            exit

        case K_CTRL_LEFT        // Va a la primera columna
            oBrw:panLeft()
            exit

        case K_CTRL_RIGHT       // Va a la ultima columna
            oBrw:panRight()
            exit

        case K_CTRL_HOME        // Va a la primera página
            oBrw:panHome()
            exit

        case K_CTRL_END         // Va a la última página
            oBrw:panEnd()
            exit

        case K_DEL              // Borra fila
            Borrar( oBrw )
			cabecera()
			oBrw:refreshAll()
			exit

        case K_INS              // Inserta columna
            Insertar( oBrw )
			cabecera()
			oBrw:refreshAll()
            exit

        case K_ENTER            // Modifica columna
            Modificar()
			cabecera()
			oBrw:refreshAll()
            exit

        case K_F1
            ayuda()
            exit

		case K_F2
            consultar()
            exit

        case K_F9
            ListarRS()
            exit

        end switch
    end

return

//==============================================================================
// Funciones del browse

//------------------------------------------------------------------------------
// Genera las columnad del browse

static procedure genColumn( oBrw )

	oBrw:AddColumn( tbcolumnnew( "#Reg.",    { || oRS:fieldget( 1 ) } ) )
	oBrw:AddColumn( tbcolumnnew( "First",    { || oRS:fieldget( 2 ) } ) )
	oBrw:AddColumn( tbcolumnnew( "Last",     { || oRS:fieldget( 3 ) } ) )
	oBrw:AddColumn( tbcolumnnew( "Street",   { || oRS:fieldget( 4 ) } ) )
	oBrw:AddColumn( tbcolumnnew( "City",     { || oRS:fieldget( 5 ) } ) )
	oBrw:AddColumn( tbcolumnnew( "State",    { || oRS:fieldget( 6 ) } ) )
	oBrw:AddColumn( tbcolumnnew( "Zip",      { || oRS:fieldget( 7 ) } ) )
	oBrw:AddColumn( tbcolumnnew( "Hiredate", { || oRS:fieldget( 8 ) } ) )
#ifdef SQLITE
	oBrw:AddColumn( tbcolumnnew( "Married",  { || if( oRS:fieldGet( 9 ) == 1, 'S', 'N' ) } ) )
#else
	oBrw:AddColumn( tbcolumnnew( "Married",  { || if( oRS:fieldGet( 9 ), 'S', 'N' ) } ) )
#endif
	oBrw:AddColumn( tbcolumnnew( "Age",      { || oRS:fieldget( 10 ) } ) )
	oBrw:AddColumn( tbcolumnnew( "Salary",   { || oRS:fieldget( 11 ) } ) )
	oBrw:AddColumn( tbcolumnnew( "Notes",    { || oRS:fieldget( 12 ) } ) )

return

//------------------------------------------------------------------------------
// Muestra una peque񡠡yuda de uso de teclas por la la pantalla

static procedure ayuda()

    msg( "F1 ...... Ayuda      ;" + ;
         "F2 ...... Consulta   ;" + ;
         "F9 ...... Listar     ;" + ;
         "Intro ... Modifica   ;" + ;
         "Insert .. Inserta    ;" + ;
         "Supr .... Borra      "  ,  "AYUDA" )

return

//------------------------------------------------------------------------------
// Opcion para modificar un registro

static procedure modificar()

    local getList
    local cSs := savescreen( 0, 0, maxrow(), maxcol() )

    cls
	
    DispBox( 3, 2, 18, 74, B_BOX )

	cargaReg()
	
	@ 04, 03 SAY "Modificacion del socio: " + hb_ntos( idreg )
	getList := muestraGet()
	
	read	
	
	if lastkey() != K_ESC .and. Updated()
		married := if( married $ 'Ss', .t., .f. )
		msgEspera()
		oUpdate:execute()
		oRS:refresh()
    endif

    restscreen( 0, 0, maxrow(), maxcol(), cSs )
	
return

//------------------------------------------------------------------------------
// Inserta un nuevo registro

static procedure Insertar( oBrw )

    local getlist
    local cSs := savescreen( 0, 0, maxrow(), maxcol() )

    cls
	
	DispBox( 3, 2, 18, 74, B_BOX )
	
	oRS:goTo( 0 )
	cargaReg()
	
	@ 04, 03 SAY "Alta de nuevo socio"
	getlist := muestraGet()
	
	read	
	
	if lastkey() != K_ESC .and. updated()
		married := if( married $ 'Ss', 1, 0 )
		msgEspera()
		oInsert:execute()
        oRS:refresh()
    endif
	
    restscreen( 0, 0, maxrow(), maxcol(), cSs )
	
return

//------------------------------------------------------------------------------
// Borra un registro

static procedure Borrar( oBrw )
	
    local lContinue := msgSN( "el socio: " + oRS:fieldGet( 2 ), ;
                              "Realmente esta seguro de borrar" )

	if lContinue
		idreg := oRS:fieldGet( 1 )
		msgEspera()
		oDelete:execute()
		oRS:refresh()
	endif
	
return

//------------------------------------------------------------------------------
// Consulta directamente a la tabla con variables xbase vinculadas

static procedure ListarRS()
	
    local i := 1
    local cSs := savescreen( 0, 0, maxrow(), maxcol() )
	local nRec := oRS:recNo()
	
	oRS:goTop()
	
    cls

	? "Registros desde la tabla:"
	
    while !oRS:eof()
	
        ? HB_NToS( oRS:fieldGet( 1 ) ), oRS:fieldGet( 2 ), oRS:fieldGet( 3 ), oRS:fieldGet( 4 )
		
	    oRS:next()

		if( i > 20, ( espera(), Scroll(), SetPos( 0, 0 ), i := 1 ), i++ )
	
    end while
	
	oRS:goTo( nRec )
	
    msg( "Se termino..." )
	
    restscreen( 0, 0, maxrow(), maxcol(), cSs )
	
return

//------------------------------------------------------------------------------

static procedure menu()
	
    cls

    @ maxrow(), 00 SAY "Presiona <INTRO> para selecionar rangos o <ESC> para salir..."

return

//------------------------------------------------------------------------------
// Muestra cabecera

static procedure cabecera()

    @ 00, 00 SAY PadR( "Resultado de la consulta -> " + hb_ntos( oSelect:rowCount() ) + ;
                " registros:", MaxCol() + 1, " " ) color "W+/R"
return

//------------------------------------------------------------------------------
// Muestra pie

static procedure pie()

    @ maxrow(), 00 SAY PadR( "<F1> Ayuda  -  <ESC> para ir al menu inicial...", ;
                            MaxCol() + 1, " " ) color "W+/R"
return

//------------------------------------------------------------------------------
//

static procedure msgEspera()

	@ MaxRow() - 1, 01 SAY "Actualizando la tabla con los cambios. Espere un momento..."
	
return

//------------------------------------------------------------------------------
// Opcion para consultar un registro

static procedure consultar()

    local getList
    local cSs := savescreen( 0, 0, maxrow(), maxcol() )

    cls
	
    DispBox( 3, 2, 18, 74, B_BOX )
	
	@ 04, 03 SAY "Consulta del socio [" + hb_ntos( oRS:fieldGet( 1 ) ) + "]"
    @ 06, 03 SAY "First....: " + oRS:fieldGet( 2 )
    @ 07, 03 SAY "Last.....: " + oRS:fieldGet( 3 )
    @ 08, 03 SAY "Street...: " + oRS:fieldGet( 4 )
    @ 09, 03 SAY "City.....: " + oRS:fieldGet( 5 )
    @ 10, 03 SAY "State....: " + oRS:fieldGet( 6 )
    @ 11, 03 SAY "Zip......: " + oRS:fieldGet( 7 )
#ifdef SQLITE
    @ 12, 03 SAY "Hiredate.: " + HB_DToC( HB_CToD( oRS:fieldGet( 8 ), "yyyy-mm-dd" ), "dd-mm-yyyy" )
    @ 13, 03 SAY "Married..: " + if( oRS:fieldGet( 9 ) == 1, 'S', 'N' )
#else
    @ 12, 03 SAY "Hiredate.: " + DToC( oRS:fieldGet( 8 ) )
    @ 13, 03 SAY "Married..: " + if( oRS:fieldGet( 9 ), 'S', 'N' )
#endif
    @ 14, 03 SAY "Age......: " + HB_NToS( oRS:fieldGet( 10 ) )
    @ 15, 03 SAY "Salary...: " + HB_NToS( oRS:fieldGet( 11 ) )
    @ 16, 03 SAY "Notes:"
    @ 17, 03 SAY  oRS:fieldGet( 12 )
	
	espera()
	
    restscreen( 0, 0, maxrow(), maxcol(), cSs )
	
return

//==============================================================================
// Otras funciones

//------------------------------------------------------------------------------
// Prepara todas las sentencias en el lado del servidor
// Observa la diferencia entre los metodos bindColumn para obtener informacion y
// bindParam para pasar valores a la sentencia preparada

static procedure preparaStmt()
	
	// Prepara la sentencia y crea el objeto oSelect y vincula variables
	oSelect := oDb:prepare( STMT_SEL )
	// Variables de salida
	oSelect:bindColumn(  1, @idreg )
    oSelect:bindColumn(  2, @first )
    oSelect:bindColumn(  3, @last )
    oSelect:bindColumn(  4, @street )
    oSelect:bindColumn(  5, @city )
    oSelect:bindColumn(  6, @state )
	oSelect:bindColumn(  7, @zip )
    oSelect:bindColumn(  8, @hiredate )
    oSelect:bindColumn(  9, @married )
    oSelect:bindColumn( 10, @age )
    oSelect:bindColumn( 11, @salary )
    oSelect:bindColumn( 12, @notes )
	// Variables de entrada		
	oSelect:bindParam( 1, @nRecIni )
	oSelect:bindParam( 2, @nRecEnd )

	// Prepara la sentencia y crea el objeto oInsert y vincula variables
    oInsert := oDb:prepare( STMT_INS )
    oInsert:bindParam(  1, @first  )
    oInsert:bindParam(  2, @last  )
    oInsert:bindParam(  3, @street )
    oInsert:bindParam(  4, @city )
    oInsert:bindParam(  5, @state )
    oInsert:bindParam(  6, @zip )
    oInsert:bindParam(  7, @hiredate )
    oInsert:bindParam(  8, @married )
    oInsert:bindParam(  9, @age )
    oInsert:bindParam( 10, @salary )
    oInsert:bindParam( 11, @notes )

	// Prepara la sentencia y crea el objeto oUpdate y vincula variables
    oUpdate := oDb:prepare( STMT_UPD )
    oUpdate:bindParam(  1, @first  )
    oUpdate:bindParam(  2, @last  )
    oUpdate:bindParam(  3, @street )
    oUpdate:bindParam(  4, @city )
    oUpdate:bindParam(  5, @state )
    oUpdate:bindParam(  6, @zip )
    oUpdate:bindParam(  7, @hiredate )
    oUpdate:bindParam(  8, @married )
    oUpdate:bindParam(  9, @age )
    oUpdate:bindParam( 10, @salary )
    oUpdate:bindParam( 11, @notes )
    oUpdate:bindParam( 12, @idreg )

	// Prepara la sentencia y crea el objeto oDelete y vincula variables
    oDelete := oDb:prepare( STMT_DEL )
	oDelete:bindParam( 1, @idreg )

return

//------------------------------------------------------------------------------
// Prepara todas las sentencias en el lado del servidor

static procedure liberaStmt()

	if oSelect:className() == "TSTMT"
        oSelect:free()
    endif

	if oDelete:className() == "TSTMT"
        oDelete:free()
    endif

	if oInsert:className() == "TSTMT"
        oInsert:free()
    endif

	if oUpdate:className() == "TSTMT"
        oUpdate:free()
    endif
	
return

//------------------------------------------------------------------------------
// Muestra los GET por pantalla  y devuelve el array getList

static function muestraGet()

	local getList := {}
	
    @ 06, 03 SAY "First....:" GET first    PICTURE "@K"
    @ 07, 03 SAY "Last.....:" GET last     PICTURE "@K"
    @ 08, 03 SAY "Street...:" GET street   PICTURE "@K"
    @ 09, 03 SAY "City.....:" GET city     PICTURE "@K"
    @ 10, 03 SAY "State....:" GET state    PICTURE "@K"
    @ 11, 03 SAY "Zip......:" GET zip      PICTURE "@K 99999-9999"
    @ 12, 03 SAY "Hiredate.:" GET hiredate PICTURE "@KD"
    @ 13, 03 SAY "Married..:" GET married  PICTURE "@K"
    @ 14, 03 SAY "Age......:" GET age      PICTURE "@K 999"
    @ 15, 03 SAY "Salary...:" GET salary   PICTURE "@K 999999.99"
    @ 16, 03 SAY "Notes:"
    @ 17, 03                  GET notes    PICTURE "@K"

return getList

//------------------------------------------------------------------------------
// Carga el actual registro del actual del cursor a las variables de campos

static procedure cargaReg()
// Se puede usar tambien con la posicion: idreg := oRS:fieldGet( 1 )
	idreg 	 := oRS:fieldGet( "idreg" )
	first 	 := oRS:fieldGet( "first" )
	last 	 := oRS:fieldGet( "last" )
	street 	 := oRS:fieldGet( "street" )
	city 	 := oRS:fieldGet( "city" )
	state 	 := oRS:fieldGet( "state" )
	zip 	 := oRS:fieldGet( "zip" )
#ifdef SQLITE
	hiredate := oRS:fieldGet( "hiredate" )
	married  := if( oRS:fieldGet( "married" ) == 1, 'S', 'N' )
#else
	hiredate := HB_CToD( oRS:fieldGet( "hiredate" ), "yyyy-mm-dd" )
	married  := if( oRS:fieldGet( "married" ), 'S', 'N' )
#endif
	age 	 := oRS:fieldGet( "age" )
	salary 	 := oRS:fieldGet( "salary" )
	notes 	 := oRS:fieldGet( "notes" )

return

//------------------------------------------------------------------------------
// Valida el rango entre dos valores

static function validaRango( r1, r2 )

    local lRet := ( r2 >= r1 )

    if !lRet
        msg( "El riemer rango debe ser mayor que segundo:; "  + ;
           hb_ntos( r1 ) + " > " + ;
           hb_ntos( r2 ), "Error en rangos" )
    endif

return lRet

//------------------------------------------------------------------------------
