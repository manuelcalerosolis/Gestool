#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS ConfiguracionesRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( if( !empty( ::getController() ), ::getModelTableName(), SQLConfiguracionesModel():getTableName() ) )

   METHOD getMovimientoAlmacen()          INLINE ( ::getValue( "movimientos_almacen", "" ) )

   METHOD setMovimientoAlmacen( nValue )  INLINE ( ::setValue( "movimientos_almacen", "", nValue ) )

   METHOD getAndIncMovimientoAlmacen()    INLINE ( ::getAndIncValue( "movimientos_almacen", "" ) )

   METHOD getId( tabla, serie )

   METHOD getValue( tabla, serie, default )

   METHOD setValue( tabla, serie, nValue )

   METHOD getAndIncValue( tabla, serie )

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

   cSentence         := "SELECT id FROM " + ::getTableName()               + space( 1 ) + ;
                           "WHERE empresa = " + toSQLString( cCodEmp() )   + space( 1 ) + ;
                              "AND tabla = " + toSQLString( tabla )        + space( 1 ) + ;
                              "AND serie = " + toSQLString( serie )        + space( 1 ) + ;
                           "LIMIT 1"                                         
   
   aSelect           := getSQLDataBase():selectFetchHash( cSentence )

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

      id             := hget( atail( aSelect ), "id" )

      if empty( id )
         RETURN ( self )
      end if 

      cSentence      := "UPDATE " + ::getTableName()                       + space( 1 )   + ;
                        "SET"                                              + space( 1 )   + ;
                           "value = " + toSQLString( value )               + space( 1 )   + ;
                        "WHERE id = " + alltrim( str( id ) )

   end if 

   getSQLDataBase():Exec( cSentence )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD getAndIncValue( tabla, serie )

   local value    := ::getValue( tabla, serie )

   if !empty( value )
      ::setValue( tabla, serie, value + 1 )
   end if

RETURN ( value )

//---------------------------------------------------------------------------//
