#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLBaseRepository

   DATA oDatabase

   DATA oController

   METHOD New()
   METHOD End()                                 

   METHOD getController()                       INLINE ( ::oController )

   METHOD setDatabase( oDb )                    INLINE ( ::oDatabase := oDb )
   METHOD getDatabase()                         INLINE ( if( empty( ::oDatabase ), getSQLDatabase(), ::oDatabase ) )

   METHOD getModel()                            INLINE ( ::getController():getModel() )
   METHOD getModelTableName()                   INLINE ( ::getController():getModelTableName()  )
   
   METHOD getAll()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oController                                := oController

Return ( Self )

//---------------------------------------------------------------------------//

METHOD End()

   ::oController                                := nil

Return ( Self )

//---------------------------------------------------------------------------//


METHOD getAll() 

   local cSQL     := "SELECT * FROM " + ::getTableName()
   local hResult  := ::getDatabase():selectFetchHash( cSQL )

RETURN ( hResult )

//---------------------------------------------------------------------------//

/*
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

METHOD getWhereNombre( cNombre )

   local cSQL  := "SELECT * FROM " + ::getTableName()                         + " "    
   cSQL        +=    "WHERE nombre = " + quoted( cNombre )                    + " "    
   cSQL        +=    "LIMIT 1"

RETURN ( ::getDatabase():firstTrimedFetchHash( cSQL ) )

//---------------------------------------------------------------------------//
*/
