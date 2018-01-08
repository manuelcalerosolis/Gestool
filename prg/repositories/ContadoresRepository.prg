#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS ContadoresRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( if( !empty( ::getController() ), ::getModelTableName(), SQLContadoresModel():getTableName() ) )

   METHOD getMovimientoAlmacen()          INLINE ( ::getValue( "movimientos_almacen", "" ) )

   METHOD setMovimientoAlmacen( nValue )  INLINE ( ::setValue( "movimientos_almacen", "", nValue ) )

   METHOD getId( tabla, serie )

   METHOD getValue( tabla, serie, default )

   METHOD setValue( tabla, serie, nValue )

END CLASS

//---------------------------------------------------------------------------//

METHOD getId( tabla, serie )

   local cSentence   := "SELECT id FROM " + ::getTableName()               + space( 1 ) + ;
                           "WHERE empresa = " + toSQLString( cCodEmp() )   + space( 1 ) + ;
                              "AND tabla = " + toSQLString( tabla )        + space( 1 ) + ;
                              "AND serie = " + toSQLString( serie )        + space( 1 ) + ;
                           "LIMIT 1"                                         
   local aSelect     := getSQLDataBase():selectFetchHash( cSentence )

   if !empty( aSelect )
      RETURN ( hget( atail( aSelect ), "id" ) )
   end if 

RETURN ( 0 )

//---------------------------------------------------------------------------//

METHOD getValue( tabla, serie, default )

   local cSentence   := "SELECT value FROM " + ::getTableName()            + space( 1 ) + ;
                           "WHERE empresa = " + toSQLString( cCodEmp() )   + space( 1 ) + ;
                              "AND tabla = " + toSQLString( tabla )        + space( 1 ) + ;
                              "AND serie = " + toSQLString( serie )        + space( 1 ) + ;
                           "LIMIT 1"                                         
   local aSelect     := getSQLDataBase():selectFetchHash( cSentence )

   if !empty( aSelect )
      RETURN ( hget( atail( aSelect ), "value" ) )
   end if 

RETURN ( default )

//---------------------------------------------------------------------------//

METHOD setValue( tabla, serie, value )

   local id
   local aSelect
   local cSentence

   value             := cValToStr( value )

   cSentence         := "SELECT id FROM " + ::getTableName()               + space( 1 ) + ;
                           "WHERE empresa = " + toSQLString( cCodEmp() )   + space( 1 ) + ;
                              "AND tabla = " + toSQLString( tabla )        + space( 1 ) + ;
                              "AND serie = " + toSQLString( serie )        + space( 1 ) + ;
                           "LIMIT 1"                                         
   
   aSelect           := getSQLDataBase():selectFetchArray( cSentence )

   if empty( aSelect )

      cSentence      := "INSERT INTO " + ::getTableName()                  + space( 1 )   + ;
                        "( empresa,"                                       + space( 1 )   + ;
                           "tabla,"                                        + space( 1 )   + ;
                           "serie,"                                        + space( 1 )   + ;
                           "value )"                                       + space( 1 )   + ;
                        "VALUES"                                           + space( 1 )   + ;
                        "( " + toSQLString( cCodEmp() ) + ","              + space( 1 )   + ;
                           toSQLString( tabla ) + ","                      + space( 1 )   + ;
                           toSQLString( serie ) + ","                      + space( 1 )   + ;
                           toSQLString( value ) + " )" 

   else 

      id             := atail( aSelect )

      if empty( id )
         RETURN ( self )
      end if 

      cSentence      := "UPDATE " + ::getTableName()                       + space( 1 )   + ;
                        "SET"                                              + space( 1 )   + ;
                           "tabla = " + toSQLString( tabla )               + space( 1 )   + ;
                           "serie = " + toSQLString( serie )               + space( 1 )   + ;
                           "value = " + toSQLString( value )               + space( 1 )   + ;
                        "WHERE id = " + alltrim( str( id ) )

   end if 

   getSQLDataBase():Exec( cSentence )

RETURN ( Self )

//---------------------------------------------------------------------------//

