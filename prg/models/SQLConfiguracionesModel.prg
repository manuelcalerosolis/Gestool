#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLConfiguracionesModel FROM SQLExportableModel

   DATA aItems                                     INIT {}

   DATA cTableName                                 INIT "configuraciones"

   DATA cConstraints                               INIT "PRIMARY KEY (id)"

   DATA cColumnOrder                               INIT "id"

   METHOD getColumns()

   METHOD getSQLSentenceValue( cDocumento, cClave )

   METHOD getValue( cDocumento, cClave, uDefault )

   METHOD getNumeric( cDocumento, cClave, uDefault );

   METHOD getSQLSentenceInsertValue( cDocumento, cClave, uValue )

   METHOD getSQLSentenceUpdateValue( nId, uValue )

   METHOD setValue( cDocumento, cClave, uValue )

   METHOD getAndIncValue( cDocumento, cClave, uDefault )

   METHOD getItemsMovimientosAlmacen()           
   METHOD setItemsMovimientosAlmacen()     
   METHOD getAndIncContadorMovimientoAlmacen()     INLINE ( ::getAndIncValue( 'movimientos_almacen', 'contador', 1 ) )

   METHOD isSerie( cName, cSerie )                 INLINE ( !empty( ::getValue( cName, 'serie', cSerie ) ) )
   METHOD setSerie( cName, cSerie )                INLINE ( ::setValue( cName, 'serie', cSerie ) )
   
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

   local cSentence   := "SELECT id, valor FROM " + ::getTableName()           + space( 1 ) 

   cSentence         +=    "WHERE empresa = " + toSQLString( cCodEmp() )      + space( 1 )

   if !empty( cDocumento )
      cSentence      +=       "AND documento = " + toSQLString( cDocumento )  + space( 1 ) 
   end if 

   if !empty( cClave )
      cSentence      +=       "AND clave = " + toSQLString( cClave )          + space( 1 ) 
   end if 

   cSentence         +=    "LIMIT 1"                                         

RETURN ( cSentence )

//---------------------------------------------------------------------------//

METHOD getValue( cDocumento, cClave, uDefault )

   local cSentence   := ::getSQLSentenceValue( cDocumento, cClave )

   local aSelect     := getSQLDataBase():selectFetchHash( cSentence )

   if !empty( aSelect )
      RETURN ( hget( atail( aSelect ), "valor" ) )
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

METHOD getSQLSentenceInsertValue( cDocumento, cClave, uValue )

   local cSentence   := "INSERT INTO " + ::getTableName()                  + space( 1 )   + ;
                        "( empresa,"                                       + space( 1 )   + ;
                           "documento,"                                    + space( 1 )   + ;
                           "clave,"                                        + space( 1 )   + ;
                           "valor )"                                       + space( 1 )   + ;
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
                           "valor = " + toSQLString( uValue )              + space( 1 )   + ;
                        "WHERE id = " + alltrim( str( nId ) )

RETURN ( cSentence )

//---------------------------------------------------------------------------//

METHOD setValue( cDocumento, cClave, uValue )

   local nId
   local aSelect     
   local cSentence   

   uValue            := cvaltostr( uValue )

   cSentence         := ::getSQLSentenceValue( cDocumento, cClave )

   aSelect           := getSQLDataBase():selectFetchHash( cSentence )

   if empty( aSelect )

      cSentence      := ::getSQLSentenceInsertValue( cDocumento, cClave, uValue )

   else 

      nId            := hget( atail( aSelect ), "id" )

      if empty( nId )
         RETURN ( self )
      end if 

      cSentence      := ::getSQLSentenceUpdateValue( nId, uValue )

   end if 

   getSQLDataBase():TransactionalExec( cSentence )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD getItemsMovimientosAlmacen()           

   ::aItems    := {}

   aadd( ::aItems, { 'clave'  => 'documento',;
                     'valor'  => ::getValue( 'movimientos_almacen', 'documento', '' ),;
                     'tipo'   => "B",;
                     'lista'  => ::oController:oSenderController:aDocuments } )

   aadd( ::aItems, { 'clave'  => 'copias',;
                     'valor'  => ::getValue( 'movimientos_almacen', 'copias', 1 ),;
                     'tipo'   => "N" } )

RETURN ( ::aItems )
   
//---------------------------------------------------------------------------//

METHOD setItemsMovimientosAlmacen()           

   local hItem

   for each hItem in ::aItems
      ::setValue( 'movimientos_almacen', hget( hItem, 'clave' ), hget( hItem, 'valor' ) )
   next

RETURN ( nil )
   
//---------------------------------------------------------------------------//

METHOD getAndIncValue( cDocumento, cClave, uDefault )

   local nValue   := ::getNumeric( cDocumento, cClave, uDefault )

   if !empty( nValue )
      ::setValue( cDocumento, cClave, nValue + 1 )
   end if

RETURN ( nValue )

//---------------------------------------------------------------------------//


