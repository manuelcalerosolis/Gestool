#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Xbrowse.ch"

CLASS ViewEditResumen FROM ViewBase

   DATA oDlg
   DATA oSender
   DATA oBrowse
   DATA oCbxImpresora
   DATA aCbxImpresora         INIT {}
   DATA cCbxImpresora
   DATA cCodigoCliente        INIT ""
   DATA cNombreCliente        INIT ""
   DATA oCodigoFormaPago
   DATA cCodigoFormaPago      INIT ""
   DATA oNombreFormaPago
   DATA cNombreFormaPago      INIT ""
   DATA hTotalIva             INIT {=>}

   METHOD New()

   METHOD Resource()

   METHOD defineBotonesGenerales()
   
   METHOD SetCodigoCliente( cCodCli )           INLINE ( if ( !Empty( cCodCli ), ::cCodigoCliente := cCodCli, ::cCodigoCliente := "" ) )
   METHOD SetNombreCliente( cNomCli )           INLINE ( if ( !Empty( cNomCli ), ::cNombreCliente := cNomCli, ::cNombreCliente := "" ) )

   METHOD defineCliente()

   METHOD SetCodigoFormaPago( cCodPgo )         INLINE ( if ( !Empty( cCodPgo ), ::cCodigoFormaPago := cCodPgo, ::cCodigoFormaPago := "" ) )
   METHOD SetNombreFormaPago( cNomPgo )         INLINE ( if ( !Empty( cNomPgo ), ::cNombreFormaPago := cNomPgo, ::cNombreFormaPago := "" ) )

   METHOD defineFormaPago()

   METHOD SetImpresoras( aImpresoras )          INLINE ( if ( !Empty( aImpresoras ), ::aCbxImpresora  := aImpresoras, ::aCbxImpresora := {} ) )
   METHOD SetImpresoraDefecto( cImpresora )     INLINE ( if ( !Empty( cImpresora ), ::cCbxImpresora   := cImpresora, ::cCbxImpresora := {} ) )

   METHOD defineBrowseIva()

   METHOD defineComboImpresion()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS ViewEditResumen

   ::oSender   := oSender

Return ( self )

//---------------------------------------------------------------------------//

METHOD Resource() CLASS ViewEditResumen

   ::oDlg   := TDialog():New( 1, 5, 40, 100, "GESTOOL TABLET",,, .f., ::Style,, rgb( 255, 255, 255 ),,, .F.,, oGridFont(),,,, .f.,, "oDlg" )

   ::defineTitulo()

   ::defineBotonesGenerales()

   ::defineCliente()

   ::defineFormaPago()

   ::defineComboImpresion()

   ::defineBrowseIva()

   ::oDlg:bResized         := {|| ::resizeDialog() }

   ::oDlg:Activate( ,,,.t.,,, {|| ::InitDialog() } )

Return ( ::oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//
                  
METHOD defineBotonesGenerales() CLASS ViewEditResumen


   TGridImage():Build(  {  "nTop"      => 5,;
                           "nLeft"     => {|| GridWidth( 7.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_del_64",;
                           "bLClicked" => {|| MsgInfo( "Cancelamos" ), ::oDlg:End() },;
                           "oWnd"      => ::oDlg } )

   TGridImage():Build(  {  "nTop"      => 5,;
                           "nLeft"     => {|| GridWidth( 9, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_printer_64",;
                           "bLClicked" => {|| ::oDlg:End() },;
                           "oWnd"      => ::oDlg } )

   TGridImage():Build(  {  "nTop"      => 5,;
                           "nLeft"     => {|| GridWidth( 10.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_check_64",;
<<<<<<< HEAD
                           "bLClicked" => {|| ::oDlg:End() },;
=======
                           "bLClicked" => {|| MsgInfo( "Aceptamos sin imprimir" ), ::oDlg:End( IDOK ) },;
>>>>>>> origin/master
                           "oWnd"      => ::oDlg } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineCliente() CLASS ViewEditResumen

   TGridSay():Build( {  "nRow"      => 40,;
                        "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                        "bText"     => {|| "Cliente: " },;
                        "oWnd"      => ::oDlg,;
                        "oFont"     => oGridFont(),;
                        "lPixels"   => .t.,;
                        "nClrText"  => Rgb( 0, 0, 0 ),;
                        "nClrBack"  => Rgb( 255, 255, 255 ),;
                        "nWidth"    => {|| GridWidth( 2, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "lDesign"   => .f. } )

   TGridGet():Build( {  "nRow"      => 40,;
                        "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                        "oWnd"      => ::oDlg,;
                        "bSetGet"   => {|u| hGet( ::oSender:hDictionaryMaster, "Cliente" ) },;
                        "nWidth"    => {|| GridWidth( 2, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "bWhen"     => {|| .f. },;
                        "lPixels"   => .t. } )
   
   TGridGet():Build( {  "nRow"      => 40,;
                        "nCol"      => {|| GridWidth( 4.5, ::oDlg ) },;
                        "oWnd"      => ::oDlg,;
                        "bSetGet"   => {|u| hGet( ::oSender:hDictionaryMaster, "NombreCliente" )  },;
                        "lPixels"   => .t.,;
                        "nWidth"    => {|| GridWidth( 7, ::oDlg ) },;
                        "bWhen"     => {|| .f.},;
                        "nHeight"   => 23 } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineFormaPago() CLASS ViewEditResumen

   TGridUrllink():Build({  "nTop"      => 65,;
                           "nLeft"     => {|| GridWidth( 0.5, ::oDlg ) },;
                           "cURL"      => "F. pago",;
                           "oWnd"      => ::oDlg,;
                           "oFont"     => oGridFont(),;
                           "lPixel"    => .t.,;
                           "nClrInit"  => nGridColor(),;
                           "nClrOver"  => nGridColor(),;
                           "nClrVisit" => nGridColor(),;
                           "bAction"   => {|| GridBrwfPago( ::oCodigoFormaPago, ::oNombreFormaPago ) } } )

   ::oCodigoFormaPago  := TGridGet():Build( {   "nRow"      => 65,;
                                                "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                                                "bSetGet"   => {|u| hGet( ::oSender:hDictionaryMaster, "Pago" ) },;
                                                "oWnd"      => ::oDlg,;
                                                "nWidth"    => {|| GridWidth( 2, ::oDlg ) },;
                                                "nHeight"   => 23,;
                                                "lPixels"   => .t.,;
                                                "bValid"    => {|| cFpago( ::oCodigoFormaPago, D():FormasPago( ::oSender:nView ), ::oNombreFormaPago ) } } )

   ::oNombreFormaPago  := TGridGet():Build(  {  "nRow"      => 65,;
                                                "nCol"      => {|| GridWidth( 4.5, ::oDlg ) },;
                                                "bSetGet"   => {|u| cNbrFPago( hGet( ::oSender:hDictionaryMaster, "Pago" ), D():FormasPago( ::oSender:nView ) ) },;
                                                "oWnd"      => ::oDlg,;
                                                "nWidth"    => {|| GridWidth( 7, ::oDlg ) },;
                                                "lPixels"   => .t.,;
                                                "nHeight"   => 23 } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineComboImpresion() CLASS ViewEditResumen

   ::oSender:SetDocuments()

   TGridSay():Build(    {     "nRow"      => 90,;
                              "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                              "bText"     => {|| "Impresión:" },;
                              "oWnd"      => ::oDlg,;
                              "oFont"     => oGridFont(),;
                              "lPixels"   => .t.,;
                              "nClrText"  => Rgb( 0, 0, 0 ),;
                              "nClrBack"  => Rgb( 255, 255, 255 ),;
                              "nWidth"    => {|| GridWidth( 2, ::oDlg ) },;
                              "nHeight"   => 25,;
                              "lDesign"   => .f. } )

   ::oCbxImpresora  := TGridComboBox():Build(  {   "nRow"      => 90,;
                                                   "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                                                   "bSetGet"   => {|u| if( PCount() == 0, ::cCbxImpresora, ::cCbxImpresora := u ) },;
                                                   "oWnd"      => ::oDlg,;
                                                   "nWidth"    => {|| GridWidth( 9, ::oDlg ) },;
                                                   "nHeight"   => 25,;
                                                   "aItems"    => ::aCbxImpresora } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineBrowseIva() CLASS ViewEditResumen

   ::oSender:CalculaIVA()

   ::oBrowse                  := TGridIXBrowse():New( ::oDlg )

   ::oBrowse:nTop             := ::oBrowse:EvalRow( 125 )
   ::oBrowse:nLeft            := ::oBrowse:EvalCol( {|| GridWidth( 0.5, ::oDlg ) } )
   ::oBrowse:nWidth           := ::oBrowse:EvalWidth( {|| GridWidth( 11, ::oDlg ) } )
   ::oBrowse:nHeight          := ::oBrowse:EvalHeight( {|| GridHeigth( ::oDlg ) - ::oBrowse:nTop - 10 } )
   ::oBrowse:lFooter          := .t.
   ::oBrowse:nMarqueeStyle    := 6

   with object ( ::oBrowse:AddCol() )
      :cHeader             := "Base"
      :bStrData            := {|| ::oSender:oIva:ShowBase( ::oBrowse:nArrayAt ) }
      :nWidth              := 170
      :nDataStrAlign       := 1
      :nHeadStrAlign       := 1
      :nFootStrAlign       := 1
      :bFooter             := {|| ::oSender:oIva:TotalBase() }
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := "%" + cImp() + " - % RE"
      :bStrData            := {|| ::oSender:oIva:ShowPorcentajes( ::oBrowse:nArrayAt ) }
      :nWidth              := 170
      :nDataStrAlign       := 1
      :nHeadStrAlign       := 1
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := cImp() + " - RE"
      :bStrData            := {|| ::oSender:oIva:ShowImportes( ::oBrowse:nArrayAt ) }
      :nWidth              := 160
      :nDataStrAlign       := 1
      :nHeadStrAlign       := 1
      :nFootStrAlign       := 1
      :bFooter             := {|| ::oSender:oIva:transTotalImporte() }
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := "Total"
      :bStrData            := {|| ::oSender:oIva:ShowTotal( ::oBrowse:nArrayAt ) }
      :nWidth              := 170
      :nDataStrAlign       := 1
      :nHeadStrAlign       := 1
      :nFootStrAlign       := 1
      :bFooter             := {|| ::oSender:oIva:transTotalTotales() }
   end with

   ::oBrowse:nHeaderHeight    := 48
   ::oBrowse:nFooterHeight    := 48
   ::oBrowse:nRowHeight       := 96
   ::oBrowse:nDataLines       := 2

   ::oBrowse:SetArray( ::oSender:oIva:aIva, , , .f. )

   ::oBrowse:CreateFromCode()

Return ( self )

//---------------------------------------------------------------------------//