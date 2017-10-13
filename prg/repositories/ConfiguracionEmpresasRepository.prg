#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS ConfiguracionEmpresasRepository FROM SQLBaseRepository

   METHOD getTableName()               INLINE ( if( !empty( ::getController() ), ::getModelTableName(), SQLConfiguracionEmpresasModel():getTableName() ) )

   METHOD getValue()

   METHOD setValue()

   METHOD getChar( name, default )     INLINE ( ::getValue( name, default ) )

   METHOD getLogic()    

END CLASS

//---------------------------------------------------------------------------//

METHOD getValue( name, default )

   local cSentence   := "SELECT value FROM " + ::getTableName()            + space( 1 ) + ;
                           "WHERE empresa = " + toSQLString( cCodEmp() )   + space( 1 ) + ;
                           "AND name = " + toSQLString( name )             + space( 1 ) + ;
                           "LIMIT 1"                                         
   local aSelect     := getSQLDataBase():selectFetchHash( cSentence )

   if !empty( aSelect )
      RETURN ( hget( atail( aSelect ), "value" ) )
   end if 

RETURN ( default )

//---------------------------------------------------------------------------//

METHOD getLogic( name, default )

   local cValue

   if !hb_islogical( default )
      default  := .f.
   end if 

   cValue      := ::getValue( name )

   if !empty( cValue )
      RETURN ( ".T." $ upper( cValue ) )
   end if 

RETURN ( default )

//---------------------------------------------------------------------------//

METHOD setValue( name, value )

   local id
   local aSelect
   local cSentence

   value          := cValToStr( value )

   cSentence      := "SELECT id FROM " + ::getTableName()               + space( 1 )   + ;
                        "WHERE empresa = " + toSQLString( cCodEmp() )   + space( 1 )   + ;
                        "AND name = " + toSQLString( name )             + space( 1 )   + ;
                        "LIMIT 1"                                         

   aSelect        := getSQLDataBase():selectFetchHash( cSentence )

   if empty( aSelect )

      cSentence   := "INSERT INTO " + ::getTableName()                  + space( 1 )   + ;
                     "( empresa,"                                       + space( 1 )   + ;
                        "name,"                                         + space( 1 )   + ;
                        "value )"                                       + space( 1 )   + ;
                     "VALUES"                                           + space( 1 )   + ;
                     "( " + toSQLString( cCodEmp() ) + ","              + space( 1 )   + ;
                        toSQLString( name ) + ","                       + space( 1 )   + ;
                        toSQLString( value ) + " )" 

   else 

      id          := hget( atail( aSelect ), "id" )

      if empty( id )
         RETURN ( self )
      end if 

      cSentence   := "UPDATE " + ::getTableName()                       + space( 1 )   + ;
                     "SET"                                              + space( 1 )   + ;
                        "value = " + toSQLString( value )               + space( 1 )   + ;
                     "WHERE id = " + alltrim( str( id ) )

   end if 

   getSQLDataBase():Exec( cSentence )

RETURN ( Self )

//---------------------------------------------------------------------------//

