#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS ReceiptDocumentSalesViewSearchNavigator FROM ViewSearchNavigator

   METHOD getDataTable()                  INLINE ( ::oSender:getDataTable() )

   METHOD getView()                       INLINE ( ::oSender:nView )

   METHOD setItemsBusqueda()              INLINE ( ::hashItemsSearch := { "Número" => 1, "Código" => "cCodCli", "Nombre" => "cNomCli" } )   

   METHOD setColumns()

   METHOD getField( cField )              INLINE ( D():getFieldDictionary( cField, ::getDataTable(), ::getView() ) )

   METHOD BotonesAcciones()

END CLASS

//---------------------------------------------------------------------------//

METHOD setColumns() CLASS ReceiptDocumentSalesViewSearchNavigator

   ::setBrowseConfigurationName( "grid_recibos" )

   with object ( ::addColumn() )
      :cHeader           := "Id"
      :bEditValue        := {|| ::getField( "Serie" ) + "/" + alltrim( str( ::getField( "Numero" ) ) ) + "-" + alltrim( str( ::getField( "NumeroRecibo" ) ) ) }
      :nWidth            := 180
   end with

   with object ( ::addColumn() )
      :cHeader           := "Exp./Vto."
      :bEditValue        := {|| dtoc( ::getField( "FechaExpedicion" ) ) + CRLF + dtoc( ::getField( "FechaVencimiento" ) ) }
      :nWidth            := 170
   end with

   with object ( ::addColumn() )
      :cHeader           := "Cliente"
      :bEditValue        := {|| alltrim( ::getField( "Cliente" ) ) + CRLF + alltrim( ::getField( "NombreCliente" ) ) }
      :nWidth            := 320
   end with

   with object ( ::addColumn() )
      :cHeader           := "Importe"
      :bEditValue        := {|| ::getField( "TotalDocumento" ) }
      :cEditPicture      := cPorDiv()
      :nWidth            := 155
      :nDataStrAlign     := 1
      :nHeadStrAlign     := 1
   end with

Return ( self )

//---------------------------------------------------------------------------//

METHOD BotonesAcciones() CLASS ReceiptDocumentSalesViewSearchNavigator

   if ::oSender:lAlowEdit

      TGridImage():Build(  {  "nTop"      => 75,;
                              "nLeft"     => {|| GridWidth( 0.5, ::oDlg ) },;
                              "nWidth"    => 64,;
                              "nHeight"   => 64,;
                              "cResName"  => "gc_pencil_64",;
                              "bLClicked" => {|| if( ::oSender:Edit(), ::refreshBrowse(), ) },;
                              "oWnd"      => ::oDlg } )

   end if 

Return ( self )

//---------------------------------------------------------------------------//