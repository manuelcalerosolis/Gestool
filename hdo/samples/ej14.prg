/*
 * Proyecto: HDO_GENERAL
 * Fichero: ej14.prg
 * Descripcion: Ejemplo de la clase RowSet
 * Autor: Manu Expsito
 * Fecha: 20/01/2018
 */

//------------------------------------------------------------------------------

#define SQLITE
//#define MYSQL

//------------------------------------------------------------------------------

#include "hdo.ch"
#include "inkey.ch"

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

#define STMT_SEL "SELECT * FROM test;"

//------------------------------------------------------------------------------
// Procedimiento principal

procedure main14()

    local n  // Varios usos
    local oDb, oSelect, oRS, oBrw
	
    cls
     oDb := THDO():new( _DBMS )

    if oDb:connect( _DB, _CONN )
        oSelect := oDb:prepare( STMT_SEL )
		oSelect:execute()
		muestra( oDb:rdlInfo() )
		n := Seconds()
		
        // Con este metodo se deberia ejecutar siempre el metodo ::execute
        oRS := oSelect:fetchRowSet()
		
        muestra( Seconds() - n, "Tiempo de carga de registros en segundos" )
		
        //oRS:goBottom()
        //oRS:skip()
		oRS:GoTo( 0 )
		
        ? "-------------------------------------------------------------------------------"
		? "Registro fantasma:"
        ? "-------------------------------------------------------------------------------"
		?
		
		for n := 1 to oRS:fieldCount()
			?? oRS:getValueByPos( n )
		next
		
        ? "-------------------------------------------------------------------------------"

		espera()
		
		cls

        ? "-------------------------------------------------------------------------------"
		? "Pruebas de movimiento:"
        ? "-------------------------------------------------------------------------------"
		? "# Prueba  ", "                recNo()", "  getValueByPos( 1 )", "    eof()", "      bof()"
        ? "-------------------------------------------------------------------------------"
        oRS:goTo( 10 );		myInfo( oRS, " 1", "oRS:goTo( 10 ) " )
        oRS:goTop();   		myInfo( oRS, " 2", "oRS:goTop()    " )
        oRS:skip( -1 ); 	myInfo( oRS, " 3", "oRS:skip( -1 ) " )
        oRS:goTo( 1 );  	myInfo( oRS, " 4", "oRS:goTo( 1 )  " )
        oRS:skip( -1 ); 	myInfo( oRS, " 5", "oRS:skip( -1 ) " )
        oRS:goBottom(); 	myInfo( oRS, " 6", "oRS:goBottom() " )
        ? "-------------------------------------------------------------------------------"
        oRS:skip( 1 );  	myInfo( oRS, " 7", "oRS:skip( 1 )  " )
        oRS:goTo( 0 );  	myInfo( oRS, " 8", "oRS:goTo( 0 )  " )
        oRS:goTo( -10 );	myInfo( oRS, " 9", "oRS:goTo( -10 )" )
        oRS:goTo( 100 );	myInfo( oRS, "10", "oRS:goTo( 100 )" )
        ? "-------------------------------------------------------------------------------"

        espera()

        ? "-------------------------------------------------------------------------------"
        ? oRS:className()
        ? "-------------------------------------------------------------------------------"
        ? "Pruebas con:      oRS:recNo(), oRS:recCount(), oRS:bof(), oRS:eof()"
        oRS:skip( 100 )
        ? "oRS:skip(  100 )", oRS:RecNo(), "   ", oRS:RecCount(), "     ", oRS:Bof(), "      ", oRS:Eof()
        oRS:skip( -100 )
        ? "oRS:skip( -100 )", oRS:RecNo(), "   ", oRS:RecCount(), "     ", oRS:Bof(), "      ", oRS:Eof()
        oRS:goTo( 8 )
        ? "-------------------------------------------------------------------------------"
        ? "Nombre                   ", "Tipo", "  Ancho", " Decimales", "  Posicion", "  Valor"
        ? "-------------------------------------------------------------------------------"

        for n = 1 to oRS:fieldCount()
            ? PadR( oRS:FieldName( n ), 20, " " ), oRS:FieldType( n ), ;
                oRS:FieldLen( n ), oRS:FieldDec( n ), oRS:FieldPos( oRS:FieldName( n ) ), oRS:fieldGet( n )
				
        next

        ? "-------------------------------------------------------------------------------"
		? "FIELDGET por nombre( 'AgE' ) ------------------------->", oRS:fieldGet( "AgE" )

        espera()

		oBrw := miBrwCursor( oRS, 0, 0, maxrow(), maxcol() )

        oRS:free()

        oSelect:free()
		
    endif

    oDb:disconnect()

    muestra( "---->[ FIN ]<----" )

return

static procedure myInfo( oRS, x, y )

    ? x, y, " ", oRS:recNo(), " ", oRS:getValueByPos( 1 ), "               ", oRS:eof(), "       ", oRS:bof()

return

//------------------------------------------------------------------------------
