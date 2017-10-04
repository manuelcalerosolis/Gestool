/*
 * Proyecto: hdo
 * Fichero: ej06.prg
 * Descripción: Uso de:
 *                - sentencias preparadas con parametros.
 *                - Consultas.
 *                - Cursores locales.
 *                - Atributos
 * Autor: Manu Exposito 2015-17
 * Fecha: 15/01/2017
*/

#include "hdo.ch"

//------------------------------------------------------------------------------

// Marcar o desmascar si se quiere usar cursor con array tradicional o una hash
// table:

#define _ARRAY_

#ifdef _ARRAY_
#define id_TIPO "ARRAY"
#else
#define id_TIPO "HASH"
#endif

procedure main06()

    local oDb, oStmt, oCur
	local aVer, n, e, cFld, h, xVal
    local cDb := "demo.db"
    local cTabla := "test"
    local cSql := "SELECT * FROM " + cTabla + " WHERE idreg BETWEEN ? AND ?;"

    cls

    oDb := THDO():new( "sqlite" )
    aVer := oDb:rdlInfo()
	AAdd( aVer, ";---oOo---;" )
	AAdd( aVer, HB_version() )
	AAdd( aVer, HB_compiler() )
	
    muestra( aVer, "Informacion del RDL" )

    ? "Estado actual de los atributos de HDO:"
    ? "------------------------------------------------------------------------"
    ? "ATTR_AUTOCOMMIT --------->", oDb:getAttribute( ATTR_AUTOCOMMIT )
    ? "ATTR_CASE --------------->", oDb:getAttribute( ATTR_CASE )
    ? "ATTR_TIMEOUT ------------>", oDb:getAttribute( ATTR_TIMEOUT )
    ? "ATTR_CONNECTION_STATUS -->", oDb:getAttribute( ATTR_CONNECTION_STATUS )
    ? "ATTR_ERRMODE ------------>", oDb:getAttribute( ATTR_ERRMODE )
    ? "ATTR_SERVER_VERSION ----->", oDb:getAttribute( ATTR_SERVER_VERSION )
    ? "ATTR_CLIENT_VERSION ----->", oDb:getAttribute( ATTR_CLIENT_VERSION )
    ? "ATTR_RDL_NAME ----------->", oDb:getAttribute( ATTR_RDL_NAME )
    ? "ATTR_SERVER_INFO -------->", oDb:getAttribute( ATTR_SERVER_INFO )
    ? "------------------------------------------------------------------------"
    espera()

    cls

    oDb:setAttribute( ATTR_ERRMODE, .t. )

    ? "Prueba con cursores basados en: " + id_TIPO
    ? "------------------------------------------------------------------------"
    ?

    if oDb:connect( cDb )

        TRY
            // Prepara la sentencia
            oStmt := oDb:prepare( cSql )
            // Enlaza valores
            oStmt:bindValue( 1, 1 )     	// Primer  ?
            oStmt:bindValue( 2, 1000000 )	// Segundo ?
            // Ejecuta la sentencia
            oStmt:execute()
			
            // Valores de los metadatos de las columnas
            for n := 1 to oStmt:columnCount()
                ? padr( oStmt:getColName( n ), 20, " " ), oStmt:getColType( n ), ;
                   oStmt:getColLen( n ), oStmt:getColDec( n ), oStmt:getColPos( oStmt:getColName( n ) )
                muestra( oStmt:getColumnMeta( n ), "METADATOS->" + hb_ntos( n ) )
            next
            espera()
            //----------------------------------------------------------------------------------------------------------------------
            // Prueba con hash
            cls
            h := oStmt:listColNames( AS_HASH )  // Con AS_HASH

            ? "Tabla hash:"
            ? "------------------------------------------------------------------------"
            for n := 1 to oStmt:columnCount()
                ? "Key...:", padr( hb_hpairat( h, n )[ 1 ], 15, " " ), "Valor...:", hb_ntos( hb_hpairat( h, n )[ 2 ] )
            next
            ?
            h := oStmt:listColNames( AS_ARRAY ) // Con AS_ARRAY
            ? "Tabla array:"
            ? "------------------------------------------------------------------------"
            for n := 1 to oStmt:columnCount()
                ? "valor...:", padr( h[ n ], 15, " " ), "posicion...:", hb_ntos( n )
            next
            espera()

			muestra( oStmt:listColNames( AS_ARRAY ) )
		
            //----------------------------------------------------------------------------------------------------------------------
            // Creamos un cursor local (navigator) como un array o hash table
#ifdef _ARRAY_
            //oCur := TMemCursor():new( oStmt:fetchAllArray(), oStmt:listColNames( AS_ARRAY ) )
            oCur := TMemCursor():new( oStmt:fetchAll( FETCH_ARRAY ), oStmt:listColNames( AS_ARRAY ) )
#else
            //oCur := THashCursor():new( oStmt:fetchAllHash() )
            oCur := THashCursor():new( oStmt:fetchAll( FETCH_HASH ) )
#endif
            // Cierra el objeto sentencia para liberar memoria
            oStmt:free()


            cFld := "street"  // first, last, street, city, state, zip, hiredate, married, age, salary, notes

			?
            ? "Usando el campo.....: " + cFld
			? "-------------------------------------------------------------------------------"
            ? "Nombre campo........: ", oCur:fieldname( oCur:fieldpos( cFld ) )
            ? "Posicion............: ", oCur:fieldpos( cFld )
            ? "Ancho...............: ", oCur:fieldlen( cFld )
            ? "Valor por fieldGet..: ", oCur:fieldget( cFld )
            ? "Valor por nombre....: ", oCur:valueByName( cFld )
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
            muestra( oDb:errorInfo(), "Error desde rdl:errorInfo()" )
            eval( errorblock(), e )
        FINALLY
            if "CURSOR" $ oCur:className()  // Es un cursor local?
                msg( "Se va la liberar el cursor local", oCur:className() )
                oCur:free()
                msg( "Se ha liberado el cursor local" )
            endif
        end
    endif

    oDb:disconnect()

return

//------------------------------------------------------------------------------
