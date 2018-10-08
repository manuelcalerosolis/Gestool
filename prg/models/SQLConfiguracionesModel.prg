#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"


//---------------------------------------------------------------------------//

CLASS SQLConfiguracionesCompanyModel FROM SQLConfiguracionesModel

   METHOD getTableName()   INLINE ( Company():getTableName( ::cTableName ) )

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLConfiguracionesModel FROM SQLCompanyModel

   DATA aItems                                     INIT {}

   DATA cTableName                                 INIT "configuraciones"

   DATA cConstraints                               INIT "PRIMARY KEY ( id ), UNIQUE KEY ( documento, clave )"

   DATA cColumnOrder                               INIT "id"

   METHOD getColumns()

   METHOD getSQLSentenceValue( cDocumento, cClave )

   METHOD getSQLSentenceId( cDocumento, cClave )

   METHOD getValue( cDocumento, cClave, uDefault )

   METHOD getNumeric( cDocumento, cClave, uDefault )

   METHOD getSQLSentenceInsertValue( cDocumento, cClave, uValue )

   METHOD getSQLSentenceUpdateValue( nId, uValue )

   METHOD setValue( cDocumento, cClave, uValue )

   METHOD getAndIncValue( cDocumento, cClave, uDefault )

   METHOD getAndIncContadorMovimientoAlmacen()     INLINE ( ::getAndIncValue( 'movimientos_almacen', 'contador', 1 ) )

   METHOD isSerie( cName, cSerie )                 INLINE ( !empty( ::getValue( cName, 'serie', cSerie ) ) )
   METHOD setSerie( cName, cSerie )                INLINE ( ::setValue( cName, 'serie', cSerie ) )
   
END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns()

   hset( ::hColumns, "id",             {  "create"    => "INTEGER AUTO_INCREMENT"                  ,;
                                          "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "documento",      {  "create"    => "VARCHAR ( 250 )"                         ,;
                                          "default"   => {|| space( 250 ) } }                      )

   hset( ::hColumns, "clave",          {  "create"    => "VARCHAR ( 250 )"                         ,;
                                          "default"   => {|| space( 250 ) } }                      )

   hset( ::hColumns, "valor",          {  "create"    => "VARCHAR ( 250 )"                         ,;
                                          "default"   => {|| space( 250 ) } }                      )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getSQLSentenceValue( cDocumento, cClave )

   local cSentence   := "SELECT valor FROM " + ::getTableName()                  + space( 1 ) 

   cSentence         +=    "WHERE documento = " + toSQLString( cDocumento )      + space( 1 ) 

   cSentence         +=       "AND clave = " + toSQLString( cClave )             + space( 1 ) 

   cSentence         +=    "LIMIT 1"                                         

RETURN ( cSentence )

//---------------------------------------------------------------------------//

METHOD getSQLSentenceId( cDocumento, cClave, uValor )

   local cSentence   := "SELECT id FROM " + ::getTableName()                     + space( 1 ) 

   if !empty( cDocumento )
      cSentence      +=       "AND documento = " + toSQLString( cDocumento )     + space( 1 ) 
   end if 

   if !empty( cClave )
      cSentence      +=       "AND clave = " + toSQLString( cClave )             + space( 1 ) 
   end if 

   if !empty( uValor )
      cSentence      +=       "AND valor = " + toSQLString( uValor )             + space( 1 ) 
   end if 

   cSentence         +=    "LIMIT 1"                                         

RETURN ( cSentence )

//---------------------------------------------------------------------------//

METHOD getValue( cDocumento, cClave, uDefault )

   local valor

   valor             := getSQLDataBase():getValue( ::getSQLSentenceValue( cDocumento, cClave ) )

   if !empty( valor )
      RETURN ( valor )
   end if 

RETURN ( uDefault )

//---------------------------------------------------------------------------//

METHOD getNumeric( cDocumento, cClave, uDefault )

   local uValue      := ::getValue( cDocumento, cClave, uDefault ) 

   if hb_isstring( uValue )
      RETURN ( val( uValue ) )
   end if

RETURN ( uValue )
       
//---------------------------------------------------------------------------//

METHOD getSQLSentenceInsertValue( cDocumento, cClave, uValor )

   local cSentence   := "INSERT INTO " + ::getTableName()                  + space( 1 )   + ;
                        "( documento,"                                     + space( 1 )   + ;
                           "clave,"                                        + space( 1 )   + ;
                           "valor )"                                       + space( 1 )   + ;
                        "VALUES"                                           + space( 1 )   + ;
                        "( " + toSQLString( cDocumento ) + ","             + space( 1 )   + ;
                           toSQLString( cClave ) + ","                     + space( 1 )   + ;
                           toSQLString( uValor ) + " )" 

RETURN ( cSentence )

//---------------------------------------------------------------------------//

METHOD getSQLSentenceUpdateValue( nId, uValue )

   local cSentence   := "UPDATE " + ::getTableName()                       + space( 1 )   + ;
                        "SET"                                              + space( 1 )   + ;
                           "valor = " + toSQLString( uValue )              + space( 1 )   + ;
                        "WHERE id = " + alltrim( str( nId ) )

RETURN ( cSentence )

//---------------------------------------------------------------------------//

METHOD setValue( cDocumento, cClave, uValor )

   local nId     
   local cSentence   

   uValor            := alltrim( cvaltostr( uValor ) )

   cSentence         := ::getSQLSentenceId( cDocumento, cClave, uValor )

   nId               := getSQLDataBase():getValue( cSentence )

   if empty( nId )

      cSentence      := ::getSQLSentenceInsertValue( cDocumento, cClave, uValor )

   else 

      cSentence      := ::getSQLSentenceUpdateValue( nId, uValor )

   end if 

   getSQLDataBase():TransactionalExec( cSentence )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getAndIncValue( cDocumento, cClave, uDefault )

   local nValue   := ::getNumeric( cDocumento, cClave, uDefault )

   if !empty( nValue )
      ::setValue( cDocumento, cClave, nValue + 1 )
   end if

RETURN ( nValue )

//---------------------------------------------------------------------------//


