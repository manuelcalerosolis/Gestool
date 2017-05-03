/*
 * Proyecto: HDO_GENERAL
 * Fichero: ejXX.prg
 * Autor: Manu Exposito
 * Fecha: 15/01/2017
 * Descripcion: Traspasa clientes.dbf de los ejemplos de Harbour a SQLite.
 *              Si no existe la bases de datos "demo.db" la crea.
 *              Si no existe la tabla "clientes" la crea.
 */

#include "hdo.ch"

#define CREA_TABLE  "CREATE TABLE IF NOT EXISTS clientes ( "+ ;
							"idReg INTEGER PRIMARY KEY,"  	+ ;
							"Nombre		VARCHAR( 40 ),"     + ;
                            "Direccion 	VARCHAR( 50 ),"		+ ;
							"Telefono	VARCHAR( 12 ),"     + ;
							"Edad		INTEGER,"			+ ;
							"Productos	VARCHAR( 10 ),"		+ ;
							"Nivel		INTEGER );"

//------------------------------------------------------------------------------
// Programa principal

procedure main()

    local oDb, e, cCreaTabla
	
    oDb := THDO():new( "sqlite" )
	
	oDb:setAttribute( ATTR_ERRMODE, .t. )
	
    if oDb:connect( "HDOdemo.db" )

        MsgAlert( "HDOdemo.db abierta" )

        try
            oDb:exec( CREA_TABLE )
            MsgAlert( "Se van a importar los datos..." )
            traspasa( oDb )
			MsgAlert( "Datos importados..." )
        catch  e
            eval( errorblock(), e )
        end

    endif

    oDb:disconnect()
	MsgAlert( "HDOdemo.db cerrada" )

return

//------------------------------------------------------------------------------
// Usa sentencias preparadas en el lado del servidor y transacciones.

static procedure traspasa( oDb )

    local n := 0
    local cSentencia, oInsert
    local Nombre, Direccion, Telefono, Edad, Productos, Nivel

	cSentencia := "INSERT INTO clientes ( Nombre, Direccion, Telefono, Edad, Productos, Nivel ) VALUES ( ?, ?, ?, ?, ?, ? );"
	
    if file( "clientes.dbf" )
		
        use clientes new
		
        oInsert := oDb:prepare( cSentencia ) // Crea el objeto y prepara la sentencia

        // Vincula las variables harbour con cada una de las "?" por su posicion
        oInsert:bindParam(  1, @Nombre  )
        oInsert:bindParam(  2, @Direccion  )
        oInsert:bindParam(  3, @Telefono  )
        oInsert:bindParam(  4, @Edad )
        oInsert:bindParam(  5, @Productos )
        oInsert:bindParam(  6, @Nivel )
		
		oDb:beginTransaction()
	
        while clientes->( !eof() )
            Nombre		:= clientes->Nombre
            Direccion	:= clientes->Direccion
            Telefono	:= clientes->Telefono
            Edad		:= clientes->Edad
            Productos	:= clientes->Productos
            Nivel		:= clientes->Nivel
		
            oInsert:execute()
		
            clientes->( dbskip( 1 ) )
        end
		
        oDb:commit()
		
        oInsert:free()
    else
        msg( "Fichero no encontrado -> clientes.dbf" )
    endif

return

//------------------------------------------------------------------------------
