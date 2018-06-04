#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"
#include "HdoCommon.ch"

//---------------------------------------------------------------------------//

CLASS SQLCompanyModel FROM SQLBaseModel
  
   METHOD getField( cField, cBy, cId )

   METHOD getUuidWhereColumn( uValue, cColumn, uDefault ) 

   METHOD getWhereUuid( Uuid )

   METHOD getWhereCodigo( cCodigo )

   METHOD getWhereNombre( cNombre )

   METHOD getArrayColumns( cColumn ) 

   METHOD getArrayColumnsWithBlank( cColumn ) 

ENDCLASS

//---------------------------------------------------------------------------//

METHOD getField( cField, cBy, cId )

   local cSql  := "SELECT " + cField                                    + " "                              
   cSql        +=    "FROM " + ::cTableName                             + " "
   cSql        +=    "WHERE " + cBy + " = " + quoted( cId )             + " "
   cSQL        +=    "AND empresa_codigo = " + quoted( Company():Codigo() ) + " " 

Return ( ::getDatabase():getValue( cSql ) )

//----------------------------------------------------------------------------//

METHOD getUuidWhereColumn( uValue, cColumn, uDefault ) 

   local uuid
   local cSQL  := "SELECT uuid FROM " + ::getTableName()                + " " 
   cSQL        +=    "WHERE " + cColumn + " = " + toSqlString( uValue ) + " " 
   cSQL        +=    "AND empresa_codigo = " + quoted( Company():Codigo() ) + " " 
   cSQL        +=    "LIMIT 1"

   uuid        := ::getDatabase():getValue( cSQL )
   if !empty( uuid )
      RETURN ( uuid )
   end if 

RETURN ( uDefault )

//---------------------------------------------------------------------------//

METHOD getWhereUuid( Uuid )

   local cSQL  := "SELECT * FROM " + ::getTableName()                   + " "    
   cSQL        +=    "WHERE uuid = " + quoted( uuid )                   + " "    
   cSQL        +=    "AND empresa_codigo = " + quoted( Company():Codigo() ) + " " 
   cSQL        +=    "LIMIT 1"

RETURN ( ::getDatabase():firstTrimedFetchHash( cSQL ) )

//---------------------------------------------------------------------------//

METHOD getWhereCodigo( cCodigo )

   local cSQL  := "SELECT * FROM " + ::getTableName()                   + " "    
   cSQL        +=    "WHERE codigo = " + quoted( cCodigo )              + " " 
   cSQL        +=    "AND empresa_codigo = " + quoted( Company():Codigo() ) + " " 
   cSQL        +=    "LIMIT 1"

RETURN ( ::getDatabase():firstTrimedFetchHash( cSQL ) )

//---------------------------------------------------------------------------//

METHOD getWhereNombre( cNombre )

   local cSQL  := "SELECT * FROM " + ::getTableName()                   + " "    
   cSQL        +=    "WHERE nombre = " + quoted( cNombre )              + " "    
   cSQL        +=    "AND empresa_codigo = " + quoted( Company():Codigo() ) + " " 
   cSQL        +=    "LIMIT 1"

RETURN ( ::getDatabase():firstTrimedFetchHash( cSQL ) )

//---------------------------------------------------------------------------//

METHOD getArrayColumns( cColumn ) 

   local cSQL  := "SELECT " + cColumn + "  FROM " + ::getTableName()    + " "
   cSQL        +=    "AND empresa_codigo = " + quoted( Company():Codigo() ) + " " 
   
RETURN ( ::getDatabase():selectFetchArrayOneColumn( cSQL ) )

//---------------------------------------------------------------------------//

METHOD getArrayColumnsWithBlank( cColumn ) 

   local aColumns                
   local cSQL     := "SELECT " + cColumn + "  FROM " + ::getTableName()
   cSQL           +=    "AND empresa_codigo = " + quoted( Company():Codigo() ) + " " 
   
   aColumns       := ::getDatabase():selectFetchArrayOneColumn( cSQL )

   ains( aColumns, 1, "", .t. )
   
RETURN ( aColumns )

//---------------------------------------------------------------------------//

