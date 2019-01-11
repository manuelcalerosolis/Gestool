/*
 * Proyecto: HDO_GENERAL
 * Fichero: ej12.prg
 * Descripción:  Mantenimiento simple. Demo de sentencias preparadas.
 * Autor: Manu Exposito
 * Fecha: 15/01/2017
 */

//------------------------------------------------------------------------------
// Includes
// Para el usos de HDO
#include "hdo.ch"
#include "InKey.ch"

// Nombre de la base de datos:
#define DB_NAME  "demo.db"

//------------------------------------------------------------------------------
// Defines
// Sentencias para compilar:
#define STMT_SEL "SELECT * FROM test WHERE idreg BETWEEN ? AND ?;"
#define STMT_INS "INSERT INTO test ( first, last, street, city, state, zip, hiredate, married, age, salary, notes ) VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? );"
#define STMT_UPD "UPDATE test set first = ?, last = ?, street = ?, city = ?, state = ?, zip = ?, hiredate = ?, married = ?, age = ?, salary = ?, notes = ? WHERE idreg = ?;"
#define STMT_DEL "DELETE FROM test WHERE idreg = ?;"

//------------------------------------------------------------------------------
// Variables estaticas para uso en todo el programa

// Conexion con base de datos
static oDb
// Objetos sentencias
static oSelect, oInsert, oUpdate, oDelete
// Rango de consultas
static nRegIni, nRegFin, nOrden := 1
// Variables de enlace con las columnas I/O
static idreg, first, last, street, city, state, zip, hiredate, married, age, salary, notes

//------------------------------------------------------------------------------
// Procedimiento principal

procedure main12()

    if dbInit()
		set date format to "dd-mm-yyyy"
        ejecutaMenu()
    else
        msg( "Error al inicializar la BBDD" )
    endif
	
    dbEnd()

return

//------------------------------------------------------------------------------
// Inicia el objeto conexion con la db y crea y prepara las sentencias

static function dbInit

    local lRet

    oDb := THDO():new( "sqlite" )
    oDb:setAttribute( ATTR_ERRMODE, .t. )
	
    lRet := oDb:connect( DB_NAME )
	
    if lRet
        preparaStmt()
    endif

return lRet

//------------------------------------------------------------------------------
// Funciones generales

static procedure dbEnd

    liberaStmt()
    oDb:disconnect()

return

//------------------------------------------------------------------------------
// Bucle principal de gestion del menu

static procedure ejecutaMenu()

    local getlist := {}
    local nOp
	
    while nOp != '0'
		nOp := ' '
        muestraMenu()
        @ 18, 38 GET nOp picture "@K 9"
        read
		
        switch nOp
        case '1'
            altas()
            exit
        case '2'
            modificaciones()
            exit
        case '3'
            bajas()
            exit
        case '4'
            consultaTodo()
            exit
        case '5'
            consultaRango()
            exit
        case '6'
            consultaCursor()
            exit
        case '7'
            muestra( oDb:rdlInfo() )
            exit
        case '0'
            salir()
        end switch
    end while

return

//------------------------------------------------------------------------------
// Muestra el menu principal en la pantalla

static procedure muestraMenu()

    cls
	
    @ 05, 10 SAY "Menu Principal de la demo de HDO"
    @ 06, 10 SAY "--------------------------------"
    @ 08, 10 SAY "1.- Altas"
    @ 09, 10 SAY "2.- Modificaciones"
    @ 10, 10 SAY "3.- Bajas"
    @ 11, 10 SAY "4.- Listado general"
    @ 12, 10 SAY "5.- Listado limitado"
    @ 13, 10 SAY "6.- Consultas"
    @ 14, 10 SAY "7.- Acerca de HDO RDL"
    @ 16, 10 SAY "0.- Salir"
    @ 18, 10 SAY "Elija una opcion (0-7)...: ( )"

return

//------------------------------------------------------------------------------
// Inserta registros en la tabla

static procedure altas()

    local getlist

    cls
	
	blanquea()
	
	@ 04, 03 SAY "Alta de nuevo socio"
	getlist := muestraGet()
	
	read	
	
	if lastkey() != K_ESC .and. updated()
		married := if( married $ 'Ss', 1, 0 )
		hiredate := HB_DToC( hiredate, "yyyy-mm-dd" )
        if oInsert:execute()
            msg( "Registro insertado" )
        else
            msg( "No se ha podido insertar el registro", "Lo siento" )
        endif
    endif
	
return

//------------------------------------------------------------------------------
// Limpia las variables

static procedure blanquea()

	first 	 := space( 20 )
	last 	 := space( 20 )
	street 	 := space( 30 )
	city 	 := space( 30 )
	state 	 := space( 2 )
	zip 	 := space( 20 )
	hiredate := HB_CToD( "", "yyyy-mm-dd" )
	married  := 'N'
	age 	 := 0
	salary 	 := 0.00
	notes 	 := space( 70 )
	
return

//------------------------------------------------------------------------------
// Modifica un registro

static procedure modificaciones()

    local getList
	local lSigue := .f.
	
    if pideClave()
		
        nRegFin := nRegIni  // Selecciona un unico registro
	
        if oSelect:execute() .and. oSelect:rowCount() > 0
			oSelect:fetchBound()
			lSigue := .t.

			cls

			hiredate := HB_CToD( hiredate, "yyyy-mm-dd" )
			married  := if( married == 1, 'S', 'N' )
	
			@ 04, 03 SAY "Modificacion de socio"
			getList := muestraGet()
	
			read	
		endif
	endif
	
	if lSigue .and. lastkey() != K_ESC .and. updated()
		married := if( married $ 'Ss', 1, 0 )
		hiredate := HB_DToC( hiredate, "yyyy-mm-dd" )
		if oUpdate:execute()
			msg( "Registro modificado" )
		else
			msg( "No se ha podido modificar el registro", "Lo siento" )
		endif
	else
		msg( "No se ha hecho nada..." )
	endif
	
return

//------------------------------------------------------------------------------
// Borra registros en la tabla

static procedure bajas()

    local getlist := {}
	local lSigue := .f.
	
    if pideClave()
		
        nRegFin := nRegIni  // Selecciona un unico registro
		
        if oSelect:execute() .and. oSelect:rowCount() > 0
			lSigue := .t.
            oSelect:fetchBound()
			
            cls
            @ 04, 01 SAY "Modificacion de registros  -> clave usuario: " + HB_NToS( nRegFin )

			@ 06, 03 SAY "First....: " + first
			@ 07, 03 SAY "Last.....: " + last
			@ 08, 03 SAY "Street...: " + street
			@ 09, 03 SAY "City.....: " + city
			@ 10, 03 SAY "State....: " + state
			@ 11, 03 SAY "Zip......: " + zip
			@ 12, 03 SAY "Hiredate.: " + HB_DToC( HB_CToD( hiredate, "yyyy-mm-dd" ), "dd-mm-yyyy" )
			@ 13, 03 SAY "Married..: " + if( married == 1, 'S', 'N' )
			@ 14, 03 SAY "Age......: " + HB_NToS( age )
			@ 15, 03 SAY "Salary...: " + HB_NToS( salary )
			@ 16, 03 SAY "Notes:"
			@ 17, 03 SAY  notes
		else			
			msg( "No hay ningun usuario con esa clave" )
        endif
		
    endif

    if lSigue .and. msgSN( "Estas seguro de querer borrar este registor?" )
        if oDelete:execute()
            msg( "Registro borrado" )
        else
            msg( "No se ha podido borrar el registro", "Lo siento" )
        endif
    else
        msg( "No se ha hecho nada..." )
    endif
return

//------------------------------------------------------------------------------
// Consulta todos los registros en la tabla

static procedure consultaTodo()
	
	nRegIni := 0            	// Desde la clave mas pequeÃ±a posible
	nRegFin := 99999999999		// Hasya la mas alta para usar en el BETWEEN
	
	oSelect:execute()
	
	recorre()

return

//------------------------------------------------------------------------------
// Recorre la tabla y muestra las columnas deseadas

static procedure recorre()
	
    local i := 1
    local cSs := savescreen( 0, 0, maxrow(), maxcol() )
		
    cls
	
    while oSelect:fetchBound()
	
        ? HB_NToS( idreg ), first, last, street//, city, state, zip, hiredate, married, age, salary, notes
	
        if( i > 22, ( espera(), Scroll(), SetPos( 0, 0 ), i := 1 ), i++ )
	
    end while
	
    msg( "Se termino..." )
	
    restscreen( 0, 0, maxrow(), maxcol(), cSs )
	
return

//------------------------------------------------------------------------------
// Seleciona rango y orden

static function eligeRango()

    local getlist := {}
	local lRet := .f.
	
	nRegIni := nRegFin := 0
	
	cls

	@ 02, 02 SAY "Entrada de datos:"
	@ 04, 02 SAY "Entre rango inicial..................:" GET nRegIni PICTURE "@K 9999999"
	@ 05, 02 SAY "Entre rango final....................:" GET nRegFin PICTURE "@K 9999999" VALID validaRango( nRegIni, nRegFin )

	READ

	if lastkey() != K_ESC .and. updated()
		oSelect:execute() // Ejecuta la sentencia
		lRet := .t.
	endif
	
return lRet

//------------------------------------------------------------------------------
// Consulta la tabla y mete el resultado en un cursor local

static procedure consultaCursor()

	local oCur                                 // Cursor local

	if eligeRango()
		// Creamos un cursor local (navigator) como un hash table
		oCur := THashCursor():new( oSelect:fetchAll( FETCH_HASH ) )

		cls
		@ 00, 00 SAY "Resultado de la consulta -> " + hb_ntos( oSelect:rowCount() ) + " registros:" color "W+/R"
		@ maxrow(), 00 SAY "<ESC> para volver al menu..." color "W+/R"

		if oCur:reccount() > 0
			miBrwCursor( oCur, 1, 0, maxrow() - 1, maxcol() )
		else
			msg( "No hay registros en ese rango" )
		endif

		oCur:free()
	endif

return

//------------------------------------------------------------------------------

static procedure salir()

    msg( "Fin de la demostracion de uso de HDO" )

return

//------------------------------------------------------------------------------

static procedure consultaRango()

	if eligeRango()
		recorre()
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
    @ 11, 03 SAY "Zip......:" GET zip      PICTURE "@K"
    @ 12, 03 SAY "Hiredate.:" GET hiredate PICTURE "@KD"
    @ 13, 03 SAY "Married..:" GET married  PICTURE "@K"
    @ 14, 03 SAY "Age......:" GET age      PICTURE "@K 999"
    @ 15, 03 SAY "Salary...:" GET salary   PICTURE "@K 999999.99"
    @ 16, 03 SAY "Notes:"
    @ 17, 03                  GET notes    PICTURE "@K"

return getList

//------------------------------------------------------------------------------
// Pide una clave

static function pideClave()

    local getlist := {}
	
	cls
	
	blanquea()
	
    nRegIni := 0
	
    @ 04, 01 SAY "Entre una clave de usuario valeda o ESC"	
    @ 06, 01 SAY "Dame una clave de usuario:" GET nRegIni
	
    read
	
return( lastkey() != K_ESC .and. updated() )

//------------------------------------------------------------------------------
// Valida rango >

static function validaRango( r1, r2 )

    local lRet := ( r2 > r1 )

    if !lRet
        msg( "El primer rango debe ser menor que segundo:; "  + ;
           hb_ntos( r1 ) + " > " + ;
           hb_ntos( r2 ), "Error en rangos" )
    endif

return lRet

//------------------------------------------------------------------------------
// Prepara todas las sentencias en el lado del servidor
// Observa la diferencia entre los metodos bindColumn para obtener informacion y
// bindParam para pasar valores a la sentencia preparada

static procedure preparaStmt()
	
	// Prepara la sentencia y crea el objeto oSelect y vincula variables
	oSelect := oDb:prepare( STMT_SEL )
	// Parametros de entrada
	oSelect:bindParam( 1, @nRegIni )
	oSelect:bindParam( 2, @nRegFin )
	// Parametros de salida
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
// Finaliza

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
