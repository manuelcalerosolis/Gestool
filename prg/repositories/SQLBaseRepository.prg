#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLBaseRepository

   DATA oDatabase

   DATA oController

   METHOD New()
   METHOD End()                                 VIRTUAL

   METHOD getController()                       INLINE ( ::oController )

   METHOD setDatabase( oDb )                    INLINE ( ::oDatabase := oDb )
   METHOD getDatabase()                         INLINE ( if( empty( ::oDatabase ), getSQLDatabase(), ::oDatabase ) )

   METHOD getModel()                            INLINE ( ::getController():getModel() )
   METHOD getModelTableName()                   INLINE ( ::getController():getModelTableName()  )
   
   METHOD getAll()
   
   METHOD getColumnWhereId( id, cColumn )
   METHOD getNombreWhereId( id )                INLINE ( ::getColumnWhereId( id, 'nombre' ) )

   METHOD getColumnWhereUuid( uuid, cColumn ) 
   METHOD getNombreWhereUuid( uuid )            INLINE ( ::getColumnWhereUuid( uuid, 'nombre' ) )

   METHOD getUuidWhereColumn( uValue, cColumn, uDefault ) 
   METHOD getUuidWhereNombre( uValue )          INLINE ( ::getUuidWhereColumn( uValue, 'nombre', '' ) )

   METHOD getColumns( cColumn )
   METHOD getNombres()                          INLINE ( ::getColumns( 'nombre' ) )

   METHOD getColumnsWithBlank( cColumn )
   METHOD getNombresWithBlank()                 INLINE ( ::getColumnsWithBlank( 'nombre' ) )

   METHOD getWhereUuid( Uuid )

   METHOD getWhereCodigo( cCodigo )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oController  := oController

Return ( Self )

//---------------------------------------------------------------------------//

METHOD getAll() 

   local cSQL     := "SELECT * FROM " + ::getTableName()
   local hResult  := ::getDatabase():selectFetchHash( cSQL )

RETURN ( hResult )

//---------------------------------------------------------------------------//

METHOD getColumnWhereId( id, cColumn ) 

   local cSQL     := "SELECT " + cColumn + " FROM " + ::getTableName()  + " " + ;
                        "WHERE id = " + quoted( id )                    + " " + ;
                        "LIMIT 1"

RETURN ( ::getDatabase():getValue( cSQL ) )

//---------------------------------------------------------------------------//

METHOD getColumnWhereUuid( uuid, cColumn ) 

   local cSQL     := "SELECT " + cColumn + " FROM " + ::getTableName()  + " " + ;
                        "WHERE uuid = " + quoted( uuid )                + " " + ;
                        "LIMIT 1"

RETURN ( ::getDatabase():getValue( cSQL ) )

//---------------------------------------------------------------------------//

METHOD getColumns( cColumn ) 

   local cSQL     := "SELECT " + cColumn + "  FROM " + ::getTableName()
   
RETURN ( ::getDatabase():selectFetchArrayOneColumn( cSQL ) )

//---------------------------------------------------------------------------//

METHOD getColumnsWithBlank( cColumn ) 

   local aColumns                
   local cSQL     := "SELECT " + cColumn + "  FROM " + ::getTableName()
   
   aColumns       := ::getDatabase():selectFetchArrayOneColumn( cSQL )

   ains( aColumns, 1, "", .t. )
   
RETURN ( aColumns )

//---------------------------------------------------------------------------//

METHOD getUuidWhereColumn( uValue, cColumn, uDefault ) 

   local uuid
   local cSQL  := "SELECT uuid FROM " + ::getTableName()                + " " + ;
                     "WHERE " + cColumn + " = " + toSqlString( uValue ) + " " + ;
                     "LIMIT 1"

   uuid        := ::getDatabase():getValue( cSQL )
   if !empty( uuid )
      RETURN ( uuid )
   end if 

RETURN ( uDefault )

//---------------------------------------------------------------------------//

METHOD getWhereUuid( Uuid )

   local cSQL  := "SELECT * FROM " + ::getTableName()                         + " "    
   cSQL        +=    "WHERE uuid = " + quoted( uuid )                         + " "    
   cSQL        +=    "LIMIT 1"

RETURN ( ::getDatabase():firstTrimedFetchHash( cSQL ) )

//---------------------------------------------------------------------------//

METHOD getWhereCodigo( cCodigo )

   local cSQL  := "SELECT * FROM " + ::getTableName()                         + " "    
   cSQL        +=    "WHERE codigo = " + quoted( cCodigo )                    + " "    
   cSQL        +=    "LIMIT 1"

RETURN ( ::getDatabase():firstTrimedFetchHash( cSQL ) )

//---------------------------------------------------------------------------//

