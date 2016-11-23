#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS ReceiptDocumentSalesViewSearchNavigator FROM ViewSearchNavigator

   DATA oSayFilter

   METHOD getDataTable()                  INLINE ( ::oSender:getDataTable() )

   METHOD getView()                       INLINE ( ::oSender:nView )

   METHOD setItemsBusqueda()              INLINE ( ::hashItemsSearch := { "Fecha" => "dFecDes", "Número" => 1, "Código" => "cCodCli", "Nombre" => "cNomCli", "Importe" => "nImporte" } )   

   METHOD setColumns()

   METHOD getField( cField )              INLINE ( D():getFieldDictionary( cField, ::getDataTable(), ::getView() ) )

   METHOD BotonesAcciones()

   METHOD ChangeFilter()

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

      TGridImage():Build(  {  "nTop"      => 75,;
                              "nLeft"     => {|| GridWidth( 1.5, ::oDlg ) },;
                              "nWidth"    => 64,;
                              "nHeight"   => 64,;
                              "cResName"  => "gc_funnel_64",;
                              "bLClicked" => {|| ::ChangeFilter() },;
                              "oWnd"      => ::oDlg } )

      ::oSayFilter  := TGridSay():Build(  {  "nRow"      => 75,;
                                             "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                                             "bText"     => {|| "" },;
                                             "oWnd"      => ::oDlg,;
                                             "oFont"     => oGridFont(),;
                                             "lPixels"   => .t.,;
                                             "nClrText"  => Rgb( 0, 0, 0 ),;
                                             "nClrBack"  => Rgb( 255, 255, 255 ),;
                                             "nWidth"    => {|| GridWidth( 1.5, ::oDlg ) },;
                                             "nHeight"   => 23,;
                                             "lDesign"   => .f. } )

   end if 

Return ( self )

//---------------------------------------------------------------------------//

METHOD ChangeFilter() CLASS ReceiptDocumentSalesViewSearchNavigator

   do case
      case ::oSayFilter:VarGet() == ""
         ?"1"
         ::oSayFilter:SetText( "Pendientes" )
         ::oSayFilter:Refresh()

      case ::oSayFilter:VarGet() == "Cobrados"
         ?"2"
         ::oSayFilter:SetText( "Pendientes" )
         ::oSayFilter:Refresh()

      case ::oSayFilter:VarGet() == "Pendientes"
         ?"3"
         ::oSayFilter:SetText( "Cobrados" )
         ::oSayFilter:Refresh()

   end case

Return ( .t. )

//---------------------------------------------------------------------------//