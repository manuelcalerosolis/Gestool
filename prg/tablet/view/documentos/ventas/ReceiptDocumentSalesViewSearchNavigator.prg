#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS ReceiptDocumentSalesViewSearchNavigator FROM ViewSearchNavigator

   METHOD getDataTable()                  INLINE ( ::oSender:getDataTable() )

   METHOD getView()                       INLINE ( ::oSender:nView )

   METHOD setItemsBusqueda()              INLINE ( ::hashItemsSearch := { "Fecha" => "dFecDes", "Número" => 1, "Código" => "cCodCli", "Nombre" => "cNomCli", "Importe" => "nImporte" } )   

   METHOD setColumns()

   METHOD getField( cField )              INLINE ( D():getFieldDictionary( cField, ::getDataTable(), ::getView() ) )

   METHOD BotonesAcciones()

END CLASS

//---------------------------------------------------------------------------//

METHOD setColumns() CLASS ReceiptDocumentSalesViewSearchNavigator

   ::setBrowseConfigurationName( "grid_recibos" )

   ::oBrowse:bClrSel         := {|| { if( !::getField( "LogicoCobrado" ), Rgb( 255, 0, 0 ), CLR_BLACK ), Rgb( 229, 229, 229 ) } }
   ::oBrowse:bClrSelFocus    := {|| { if( !::getField( "LogicoCobrado" ), Rgb( 255, 0, 0 ), CLR_BLACK ), Rgb( 167, 205, 240 ) } }
   ::oBrowse:bClrStd         := {|| { if( !::getField( "LogicoCobrado" ), Rgb( 255, 0, 0 ), CLR_BLACK ), GetSysColor( COLOR_WINDOW ) } }

   with object ( ::addColumn() )
      :cHeader           := "Id"
      :bEditValue        := {|| ::getField( "Serie" ) + "/" + alltrim( str( ::getField( "Numero" ) ) ) + "-" + alltrim( str( ::getField( "NumeroRecibo" ) ) ) }
      :nWidth            := 150
   end with

   with object ( ::addColumn() )
      :cHeader           := "Exp./Vto."
      :bEditValue        := {|| dtoc( ::getField( "FechaExpedicion" ) ) + CRLF + dtoc( ::getField( "FechaVencimiento" ) ) }
      :nWidth            := 160
   end with

   with object ( ::addColumn() )
      :cHeader           := "Cliente"
      :bEditValue        := {|| alltrim( ::getField( "Cliente" ) ) + CRLF + alltrim( ::getField( "NombreCliente" ) ) }
      :nWidth            := 200
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
                              "bLClicked" => {|| ::oSender:Edit() },;
                              "oWnd"      => ::oDlg } )

   end if 

Return ( self )

//---------------------------------------------------------------------------//