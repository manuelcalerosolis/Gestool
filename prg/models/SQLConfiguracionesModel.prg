#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLConfiguracionesModel FROM SQLExportableModel

   DATA cTableName            INIT "configuraciones"

   DATA cConstraints          INIT "PRIMARY KEY (id)"

   DATA cColumnOrder          INIT "id"

   METHOD getColumns()

   METHOD getSQLSentenceValue( cDocumento, cClave )

   METHOD getValue( cDocumento, cClave, uDefault )

   METHOD setSQLSentenceValue( cDocumento, cClave, uValue )

   METHOD setValue( cDocumento, cClave, uValue )

   // Fachadas ---------------------------------------------------------------

   METHOD getContadoresMovimientosAlmacen( 'movimientos_almacen', 'contador', 1 )
   
END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns()

   hset( ::hColumns, "id",          {  "create"    => "INTEGER AUTO_INCREMENT"                  ,;
                                       "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "empresa",     {  "create"    => "CHAR ( 4 ) NOT NULL"                     ,;
                                       "default"   => {|| cCodEmp() } }                         )

   hset( ::hColumns, "usuario",     {  "create"    => "VARCHAR(3) NOT NULL"                     ,;
                                       "default"   => {|| space( 3 ) } }                        )

   hset( ::hColumns, "documento",   {  "create"    => "VARCHAR ( 250 )"                         ,;
                                       "default"   => {|| space( 250 ) } }                      )

   hset( ::hColumns, "clave",       {  "create"    => "VARCHAR ( 250 )"                         ,;
                                       "default"   => {|| space( 250 ) } }                      )

   hset( ::hColumns, "valor",       {  "create"    => "VARCHAR ( 250 )"                         ,;
                                       "default"   => {|| space( 250 ) } }                      )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getSQLSentenceValue( cDocumento, cClave )

   local cSentence   := "SELECT value FROM " + ::getTableName()               + space( 1 ) + ;
                           "WHERE empresa = " + toSQLString( cCodEmp() )      + space( 1 ) + ;
                              "AND documento = " + toSQLString( cDocumento )  + space( 1 ) + ;
                              "AND clave = " + toSQLString( cClave )          + space( 1 ) + ;
                           "LIMIT 1"                                         

RETURN ( cSentence )

//---------------------------------------------------------------------------//

METHOD getValue( cDocumento, cClave, uDefault )

   local cSentence   := ::getSQLSentenceValue( cDocumento, cClave )

   local aSelect     := getSQLDataBase():selectFetchHash( cSentence )

   if !empty( aSelect )
      RETURN ( hget( atail( aSelect ), "value" ) )
   end if 

RETURN ( uDefault )

//---------------------------------------------------------------------------//

METHOD getSQLSentenceInsertValue( cDocumento, cClave, uValue )

   local cSentence   := "INSERT INTO " + ::getTableName()                  + space( 1 )   + ;
                        "( empresa,"                                       + space( 1 )   + ;
                           "documento,"                                    + space( 1 )   + ;
                           "clave,"                                        + space( 1 )   + ;
                           "value )"                                       + space( 1 )   + ;
                        "VALUES"                                           + space( 1 )   + ;
                        "( " + toSQLString( cCodEmp() ) + ","              + space( 1 )   + ;
                           toSQLString( cDocumento ) + ","                 + space( 1 )   + ;
                           toSQLString( cClave ) + ","                     + space( 1 )   + ;
                           toSQLString( uValue ) + " )" 

RETURN ( cSentence )

//---------------------------------------------------------------------------//

METHOD getSQLSentenceUpdateValue( nId, uValue )

   local cSentence   := "UPDATE " + ::getTableName()                       + space( 1 )   + ;
                        "SET"                                              + space( 1 )   + ;
                           "value = " + toSQLString( uValue )              + space( 1 )   + ;
                        "WHERE id = " + alltrim( str( nId ) )

RETURN ( cSentence )

//---------------------------------------------------------------------------//

METHOD setValue( cDocumento, cClave, uValue )

   local nId
   local cSentence
   local aSelect     := getSQLDataBase():selectFetchHash( ::getSQLSentenceValue( cDocumento, cClave ) )

   if empty( aSelect )

      cSentence      := ::getSQLSentenceInsertValue()

   else 

      nId            := hget( atail( aSelect ), "id" )

      if empty( id )
         RETURN ( self )
      end if 

      cSentence      := ::getSQLSentenceUpdateValue( uValue )

   end if 

   getSQLDataBase():Exec( cSentence )

RETURN ( self )

//---------------------------------------------------------------------------//

   
