#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLContadoresModel FROM SQLCompanyModel

   DATA cTableName                     INIT "contadores"

   DATA cConstraints                   INIT "PRIMARY KEY ( id ), UNIQUE KEY ( documento, serie )"

   METHOD getColumns()

   METHOD isSerie( cDocument, cSerial )
   METHOD assertSerie( cDocument )
   METHOD insertSerie( cDocument, cSerial, nCounter )

   METHOD getLastSerie( cDocument )
   METHOD getLastCounter( cDocument )                          

   METHOD incrementCounter( cDocument, cSerial )

   METHOD getCounterAndIncrement( cDocument, cSerial )

   METHOD isWhereSerie()

   METHOD setDocumentoAttribute( uValue )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLContadoresModel

   hset( ::hColumns, "id",             {  "create"    => "INTEGER AUTO_INCREMENT"                  ,;
                                          "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "usuario_codigo", {  "create"    => "VARCHAR ( 20 )"                          ,;
                                          "text"      => "Usuario"                                 ,;
                                          "default"   => {|| Auth():Codigo() } }                   )

   hset( ::hColumns, "documento",      {  "create"    => "VARCHAR ( 250 )"                         ,;
                                          "text"      => "Documento"                               ,;
                                          "default"   => {|| space( 250 ) } }                      )

   hset( ::hColumns, "serie",          {  "create"    => "VARCHAR ( 20 )"                          ,;
                                          "text"      => "Serie"                                   ,;
                                          "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "contador",       {  "create"    => "INT UNSIGNED"                            ,;
                                          "text"      => "Contador"                                ,;
                                          "default"   => {|| 0 } }                                 )

   ::getTimeStampColumns()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD insertSerie( cDocument, cSerial, nCounter ) CLASS SQLContadoresModel

   local hBuffer        := ::loadBlankBuffer()

   DEFAULT cSerial      := 'A'
   DEFAULT nCounter     := 1

   hset( hBuffer, "documento", cDocument )
   hset( hBuffer, "serie", cSerial )
   hset( hBuffer, "contador", nCounter )

RETURN ( ::insertIgnoreTransactional( hBuffer ) )   

//---------------------------------------------------------------------------//

METHOD isSerie( cDocument, cSerial ) CLASS SQLContadoresModel

RETURN ( !empty( ::getFieldWhere( 'id', { 'documento' => cDocument, 'serie' => cSerial } ) ) ) 

//---------------------------------------------------------------------------//

METHOD assertSerie( cDocument ) CLASS SQLContadoresModel

   if empty( ::getFieldWhere( 'serie', { 'documento' => cDocument } ) )
      RETURN ( ::insertSerie( cDocument ) )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getLastSerie( cDocument ) CLASS SQLContadoresModel

   local cSerie

   cSerie      := ::getFieldWhere( 'serie',;
                                    {  'documento' => cDocument, 'usuario_codigo' => Auth():Codigo() },;
                                    {  'updated_at' => 'DESC' } )

   if empty( cSerie )   
      cSerie   := ::getFieldWhere( 'serie',;
                                    {  'documento' => cDocument },;
                                    {  'updated_at' => 'DESC' } )
   end if 

RETURN ( cSerie )

//---------------------------------------------------------------------------//

METHOD getLastCounter( cDocument, cSerial ) CLASS SQLContadoresModel

RETURN ( ::getFieldWhere(  'contador',;
                           { 'documento' => cDocument, 'serie' => cSerial },;
                           { 'updated_at' => 'DESC' }, 1 ) ) 

//---------------------------------------------------------------------------//
   
METHOD incrementCounter( cDocument, cSerial ) CLASS SQLContadoresModel

RETURN ( ::updateFieldsWhere( { 'contador' => 'contador + 1', 'updated_at' => 'NOW()' },;
                              { 'documento' => cDocument, 'serie' => cSerial } ) )

//---------------------------------------------------------------------------//

METHOD getCounterAndIncrement( cDocument, cSerial ) CLASS SQLContadoresModel

   local nCounter    := ::getLastCounter( cDocument, cSerial )

   msgalert( nCounter, "getCounterAndIncrement" )

   ::incrementCounter( cDocument, cSerial )

RETURN ( nCounter )

//---------------------------------------------------------------------------//

METHOD isWhereSerie( cSerial, cDocumento ) CLASS SQLContadoresModel

   local cSQL
   local nCount 

   cSQL              := "SELECT COUNT(*) FROM " + ::getTableName()   + " "    
   cSQL              +=    "WHERE serie = " + quoted( cSerial )      + " "
   
   if !empty( cDocumento )
      cSQL           +=    "AND documento = " + quoted( cDocumento )
   end if 

   nCount            := ::getDatabase():getValue( cSQL )

RETURN ( hb_isnumeric( nCount ) .and. nCount > 0 )

//---------------------------------------------------------------------------//

METHOD setDocumentoAttribute() CLASS SQLContadoresModel

   if empty( ::oController )
      RETURN ( nil )
   end if

RETURN ( ::oController:getTableName() )

//---------------------------------------------------------------------------//



