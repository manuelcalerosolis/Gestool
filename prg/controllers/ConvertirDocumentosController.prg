#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ConvertirDocumentosController FROM SQLNavigatorController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD Run()

   DATA aComboDocumentoDestino   INIT  {  "Albarán de compras"             => {|| AlbaranesComprasController():New( ::getSuperController() ) },;
                                          "Albarán de ventas"              => {|| AlbaranesComprasController():New( ::getSuperController() ) },;
                                          "Factura de compras"             => {|| AlbaranesComprasController():New( ::getSuperController() ) },;
                                          "Factura de ventas"              => {|| AlbaranesComprasController():New( ::getSuperController() ) },;
                                          "Factura de ventas simplificada" => {|| AlbaranesComprasController():New( ::getSuperController() ) },;
                                          "Pedido de compras"              => {|| AlbaranesComprasController():New( ::getSuperController() ) },;
                                          "Pedido de ventas"               => {|| AlbaranesComprasController():New( ::getSuperController() ) },;
                                          "Presupuesto de ventas"          => {|| AlbaranesComprasController():New( ::getSuperController() ) } }

   //Construcciones tardias----------------------------------------------------

   METHOD getModel()             INLINE( if( empty( ::oModel ), ::oModel := SQLConvertirDocumentosModel():New( self ), ), ::oModel ) 

   METHOD getDialogView()        INLINE( if( empty( ::oDialogView ), ::oDialogView := ConvertirDocumentoView():New( self ), ), ::oDialogView )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS ConvertirDocumentosController
   
   ::Super:New( oController )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS ConvertirDocumentosController

   if !empty( ::oModel )
      ::oModel:End()
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Run()

   if ::getDialogView():Activate() == IDOK
      msgalert( ::getDialogView():cDocumentoDestino )
      do case 
         case ::getDialogView():cDocumentoDestino == ""

      end case
   end if 


//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ConvertirDocumentoView FROM SQLBaseView

   DATA oComboDocumentoDestino
   DATA cDocumentoDestino

                                          
   METHOD Activate()
      METHOD Activating()

   METHOD getNombresDocumentos()

   METHOD getNombreWhereDocumento( cEntidad )

   METHOD getControllerWhereNombre( cNombre )

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS ConvertirDocumentoView

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
      ITEMS       ( ::getController():getNombresDocumentos() ) ;
      ID          100 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   // Botones------------------------------------------------------------------

   ApoloBtnFlat():Redefine( IDOK, {|| ::oDialog:end( IDOK ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, ::oDialog:end( IDOK ), ) }
   
   ::oDialog:Activate( , , , .t. )

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD Activating() CLASS ConvertirDocumentoView

   ::cDocumentoDestino := ""

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getNombreWhereDocumento( cDocumento ) CLASS ConvertirDocumentoView

   local cNombre     := ""

   heval( ::aComboDocumentoDestino, {|k,v| iif( k == alltrim( cDocumento ), cNombre := hget( v, "nombre" ), ) } )

RETURN ( cNombre )
   
//---------------------------------------------------------------------------//

METHOD getNombresDocumentos() CLASS ConvertirDocumentoView

   local aNombres    := {}

   heval( ::aComboDocumentoDestino, {|k,v| aadd( aNombres, hget( v, "nombre" ) ) } )

RETURN ( aNombres )

//---------------------------------------------------------------------------//

METHOD getControllerWhereNombre( cNombre ) CLASS ConvertirDocumentoView

   local cDocumento    := ""

   heval( ::aComboDocumentoDestino, {|k,v| iif( hget( v, "nombre" ) == cNombre, cDocumento := k, ) } )
   
RETURN ( cDocumento )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLConvertirDocumentosModel FROM SQLCompanyModel

   DATA cTableName               INIT "documentos_conversion"

   //DATA cConstraints             INIT "PRIMARY KEY ( pago_uuid, recibo_uuid )"

   METHOD getColumns()

   METHOD InsertDocumentoConversion()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLConvertirDocumentosModel

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

METHOD InsertDocumentoConversion( uuidOrigen, cTableOrigen, cTableDestino ) CLASS SQLConvertirDocumentosModel

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
