#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ConversorDocumentosController FROM SQLNavigatorController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD Run()

   DATA aDocumentosDestino       // INIT  {  "Albarán de compras"             => {|| AlbaranesComprasController():New( ::getController() ):Append() },;
                                 //          "Albarán de ventas"              => {|| msgalert( "albaran de ventas" ) },;
                                 //          "Factura de compras"             => {|| msgalert( "albaran de ventas" ) },;
                                 //          "Factura de ventas"              => {|| msgalert( "albaran de ventas" ) },;
                                 //          "Factura de ventas simplificada" => {|| msgalert( "albaran de ventas" ) },;
                                 //          "Pedido de compras"              => {|| msgalert( "albaran de ventas" ) },;
                                 //          "Pedido de ventas"               => {|| msgalert( "albaran de ventas" ) },;
                                 //          "Presupuesto de ventas"          => {|| msgalert( "albaran de ventas" ) } }

   //Construcciones tardias----------------------------------------------------

   METHOD getModel()             INLINE ( if( empty( ::oModel ), ::oModel := SQLConversorDocumentosModel():New( self ), ), ::oModel ) 

   METHOD getDialogView()        INLINE ( if( empty( ::oDialogView ), ::oDialogView := ConversorDocumentoView():New( self ), ), ::oDialogView )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS ConversorDocumentosController

   ::aDocumentosDestino := {  "Albarán de compras"             => {|| AlbaranesComprasController():New( ::getController() ):Append() },;
                              "Albarán de ventas"              => {|| msgalert( "Albarán de ventas" ) },;
                              "Factura de compras"             => {|| msgalert( "Factura de compras" ) },;
                              "Factura de ventas"              => {|| msgalert( "Factura de ventas" ) },;
                              "Factura de ventas simplificada" => {|| msgalert( "Factura de ventas simplificada" ) },;
                              "Pedido de compras"              => {|| msgalert( "Pedido de compras" ) },;
                              "Pedido de ventas"               => {|| msgalert( "Pedido de ventas" ) },;
                              "Presupuesto de ventas"          => {|| msgalert( "Presupuesto de ventas" ) } }

   ::Super:New( oController )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS ConversorDocumentosController

   if !empty( ::oModel )
      ::oModel:End()
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Run() CLASS ConversorDocumentosController

   if ::getDialogView():Activate() != IDOK
      RETURN ( nil )
   end if 

   msgalert( ::getDialogView():getDocumentoDestino(), "getDocumentoDestino" )

   if hhaskey( ::aDocumentosDestino, ::getDialogView():getDocumentoDestino() )
      eval( hget( ::aDocumentosDestino, ::getDialogView():getDocumentoDestino() ) )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ConversorDocumentoView FROM SQLBaseView

   DATA cDocumentoDestino

   DATA oComboDocumentoDestino
                                          
   METHOD Activate()
      METHOD Activating()

   METHOD getDocumentoDestino()        INLINE ( alltrim( ::cDocumentoDestino ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS ConversorDocumentoView

   DEFINE DIALOG  ::oDialog;
      RESOURCE    "CONVERTIR_DOCUMENTO"; 
      TITLE       "Convertir documento a ..."

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    "gc_tags_48" ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      PROMPT      "Convertir documento" ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog

   REDEFINE COMBOBOX ::oComboDocumentoDestino ;
      VAR         ::cDocumentoDestino ;
      ITEMS       ( hgetkeys( ::getController():aDocumentosDestino ) ) ;
      ID          100 ;
      OF          ::oDialog

   // Botones------------------------------------------------------------------

   ApoloBtnFlat():Redefine( IDOK, {|| ::oDialog:end( IDOK ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, ::oDialog:end( IDOK ), ) }
   
   ::oDialog:Activate( , , , .t. )

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD Activating() CLASS ConversorDocumentoView

   ::cDocumentoDestino  := ""

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLConversorDocumentosModel FROM SQLCompanyModel

   DATA cTableName               INIT "documentos_conversion"

   //DATA cConstraints             INIT "PRIMARY KEY ( pago_uuid, recibo_uuid )"

   METHOD getColumns()

   METHOD InsertDocumentoConversion()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLConversorDocumentosModel

   hset( ::hColumns, "id",                         {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"              ,;                          
                                                      "default"   => {|| 0 } }                                    )

   hset( ::hColumns, "uuid",                       {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"              ,;                                  
                                                      "default"   => {|| win_uuidcreatestring() } }               )

   hset( ::hColumns, "documento_origen_tabla",     {  "create"    => "VARCHAR( 200 )"                              ,;
                                                      "default"   => {|| space( 200 ) } }                          )

   hset( ::hColumns, "documento_origen_uuid",      {  "create"    => "VARCHAR( 40 )"                              ,;
                                                      "default"   => {|| space( 40 ) } }                          )

   hset( ::hColumns, "documento_destino_tabla",     {  "create"    => "VARCHAR( 200 )"                              ,;
                                                      "default"   => {|| space( 200 ) } }                          )

   hset( ::hColumns, "documento_destino_uuid",      {  "create"    => "VARCHAR( 40 )"                              ,;
                                                      "default"   => {|| space( 40 ) } }                          )



RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD InsertDocumentoConversion( uuidOrigen, cTableOrigen, cTableDestino ) CLASS SQLConversorDocumentosModel

   local cSql

   TEXT INTO cSql

   INSERT  INTO %1$s
      ( uuid, documento_origen_tabla, documento_origen_uuid, documento_destino_tabla, documento_destino_uuid ) 

   VALUES
   ( UUID(), %2$s, %3$s, ::getEntidadWhereNombre(::cDocumentoDestino), %4$s, UUID() )
      
   ENDTEXT

   cSql  := hb_strformat(  cSql, ::getTableName(),;
                                 quoted( cTableOrigen ),;
                                 quoted( uuidOrigen ),;
                                 quoted( cTableDestino ) )
                                 
RETURN ( getSQLDatabase():Exec ( cSql ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
