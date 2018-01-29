/*
 * Proyecto: hdo
 * Fichero: ej06.prg
 * Descripción: Uso de:
 *                - sentencias preparadas con parametros.
 *                - Consultas.
 *                - Cursores locales.
 *                - Atributos
 * Autor: Manu Exposito 2015-18
 * Fecha: 20/01/2018
*/

//------------------------------------------------------------------------------

#define SQLITE
//#define MYSQL

//------------------------------------------------------------------------------

#include "hdo.ch"

#ifdef SQLITE
	REQUEST RDLSQLITE
	#define _DBMS "sqlite"
	#define _DB  "hdodemo.db"
	#define _CONN
#else
	#ifdef MYSQL
		REQUEST RDLMYSQL
		#define _DBMS "mysql"
		#define _DB  "hdodemo"
		#define _CONN  "127.0.0.1", "root", "root"
	#endif
#endif

//------------------------------------------------------------------------------

// Marcar o desmascar si se quiere usar cursor con array tradicional o una hash
// table:

//#define _ARRAY_

#ifdef _ARRAY_
	#define id_TIPO "ARRAY"
#else
	#define id_TIPO "HASH"
#endif

procedure main06()

    local oDb, oStmt, oCur
	local aVer, n, e, cFld, h, xVal
    local cTabla := "test"
    local cSql := "SELECT * FROM " + cTabla + " WHERE idreg BETWEEN ? AND ?;"

    cls

    oDb := THDO():new( _DBMS )
	oDb:setAttribute( ATTR_ERRMODE, ERRMODE_SILENT )
    aVer := oDb:rdlInfo()
	AAdd( aVer, ";---oOo---;" )
	AAdd( aVer, HB_version() )
	AAdd( aVer, HB_compiler() )
	
    muestra( aVer, "Informacion del RDL" )

    ? "Estado actual de los atributos de HDO:"
    ? "------------------------------------------------------------------------"
    ? "ATTR_RDL_NAME ----------->", oDb:getAttribute( ATTR_RDL_NAME )
    ? "ATTR_AUTOCOMMIT --------->", oDb:getAttribute( ATTR_AUTOCOMMIT )
    ? "ATTR_CASE --------------->", oDb:getAttribute( ATTR_CASE )
    ? "ATTR_TIMEOUT ------------>", oDb:getAttribute( ATTR_TIMEOUT )
    ? "ATTR_CONNECTION_STATUS -->", oDb:getAttribute( ATTR_CONNECTION_STATUS )
    ? "ATTR_ERRMODE ------------>", oDb:getAttribute( ATTR_ERRMODE )
    ? "ATTR_SERVER_VERSION ----->", oDb:getAttribute( ATTR_SERVER_VERSION )
    ? "ATTR_CLIENT_VERSION ----->", oDb:getAttribute( ATTR_CLIENT_VERSION )
    ? "ATTR_SERVER_INFO -------->", oDb:getAttribute( ATTR_SERVER_INFO )
    ? "ATTR_CLIENT_INFO -------->", oDb:getAttribute( ATTR_CLIENT_INFO )
    ? "------------------------------------------------------------------------"
    espera()

    cls

    ? "Prueba con cursores basados en: " + id_TIPO
    ? "------------------------------------------------------------------------"
    ?

    if oDb:connect( _DB, _CONN )

        TRY
            // Prepara la sentencia
            oStmt := oDb:prepare( cSql )

			// Enlaza valores
            oStmt:bindValue( 1, 1 )     	// Primer  ?
            oStmt:bindValue( 2, 100000 )	// Segundo ?

            // Ejecuta la sentencia
            oStmt:execute()
			
            // Valores de los metadatos de las columnas
            for n := 1 to oStmt:columnCount()
                ? padr( oStmt:getColName( n ), 20, " " ), oStmt:getColType( n ), ;
                   oStmt:getColLen( n ), oStmt:getColDec( n ), oStmt:getColPos( oStmt:getColName( n ) )
                //muestra( oStmt:getColumnMeta( n ), "METADATOS->" + hb_ntos( n ) )
            next
			muestra( oStmt:getColumnMeta(  2 ), "METADATOS->" + hb_ntos(  2 ) )
			muestra( oStmt:getColumnMeta( 12 ), "METADATOS->" + hb_ntos( 12 ) )
            espera()
            //----------------------------------------------------------------------------------------------------------------------
            // Prueba con hash
            cls
            h := oStmt:listColNames( AS_HASH_TYPE )  // Con AS_HASH_TYPE

            ? "Tabla hash:"
            ? "------------------------------------------------------------------------"
            for n := 1 to oStmt:columnCount()
                ? "Key...:", padr( hb_hpairat( h, n )[ 1 ], 15, " " ), "Valor...:", hb_ntos( hb_hpairat( h, n )[ 2 ] )
            next
            ?
            h := oStmt:listColNames() // Con AS_ARRAY_TYPE por defecto
            ? "Tabla array:"
            ? "------------------------------------------------------------------------"
            for n := 1 to oStmt:columnCount()
                ? "valor...:", padr( h[ n ], 15, " " ), "posicion...:", hb_ntos( n )
            next
            espera()

			muestra( oStmt:listColNames() )

            //----------------------------------------------------------------------------------------------------------------------
            // Creamos un cursor local (navigator) como un array o hash table
#ifdef _ARRAY_
            //oCur := TMemList():new( oStmt:fetchAllArray(), oStmt:listColNames() )
            oCur := TMemList():new( oStmt:fetchAll( FETCH_ARRAY ), oStmt:listColNames() )
#else
            //oCur := THashList():new( oStmt:fetchAllHash() )
            oCur := THashList():new( oStmt:fetchAll( FETCH_HASH ) )
#endif
			// Cierra el objeto sentencia para liberar memoria, el resultado ya esta en el cursor local
            oStmt:free()

            cFld := "street"  // first, last, street, city, state, zip, hiredate, married, age, salary, notes

			?
            ? "Usando el campo.....: " + cFld
			? "-------------------------------------------------------------------------------"
            ? "Nombre campo........: ", oCur:fieldname( oCur:fieldpos( cFld ) )
            ? "Posicion............: ", oCur:fieldpos( cFld )
            ? "Ancho...............: ", oCur:fieldlen( cFld )
            ? "Valor por fieldGet..: ", oCur:fieldget( cFld )
            ? "Valor por nombre....: ", oCur:getValueByName( cFld )
            ? "Valor por posicion..: ", oCur:getValueByPos( oCur:fieldpos( cFld ) )
			? "-------------------------------------------------------------------------------"
            espera()

            muestra( oCur:asArray(), "oCur:asArray()" )

			miBrwCursor( oCur )

            cls

			xVal := "Homer"
			
			n := oCur:find( xVal, 2, .f. )
			
			if n > 0
				? "Encontrado el valor de (first):", xVal, "en el recno:", n, oCur:find( xVal, "first", .f. )
			else
				? xVal, "no encontrado..."
			endif
			
            espera( 15 )

        CATCH e
            eval( errorblock(), e )
        FINALLY
            if "LIST" $ oCur:className()  // Es un cursor local?
                msg( "Se va la liberar el cursor local", oCur:className() )
                oCur:free()
                msg( "Se ha liberado el cursor local" )
            endif
        end
    endif

    oDb:disconnect()

return

//------------------------------------------------------------------------------
