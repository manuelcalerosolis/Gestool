#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Xbrowse.ch"

CLASS ViewReporting FROM ViewBase

   DATA oDlg
   DATA oSender

   DATA oBtnInformesArticulos
   DATA oBtnInformesClientes
   DATA oBtnInformesEjecutar

   DATA oBrowse

   METHOD New()

   METHOD Resource()

   METHOD defineBotonSalir()

   METHOD defineBotonesGenerales()
   
   METHOD defineBrowseIva()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS ViewReporting

   ::oSender   := oSender

Return ( self )

//---------------------------------------------------------------------------//

METHOD Resource() CLASS ViewReporting

   ::resetRow()

   ::oDlg                  := TDialog():New( 1, 5, 40, 100, "GESTOOL TABLET",,, .f., ::Style,, rgb( 255, 255, 255 ),,, .F.,, oGridFont(),,,, .f.,, "oDlg" )

   ::defineTitulo()

   ::defineBotonSalir()

   ::defineBotonesGenerales()

   /*::defineBrowseIva()*/

   ::oDlg:bResized         := {|| ::resizeDialog() }

   ::oDlg:Activate( ,,,.t.,,, {|| ::InitDialog() } )

Return ( ::oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//
                  
METHOD defineBotonSalir() CLASS ViewReporting

   TGridImage():Build(  {  "nTop"      => 5,;
                           "nLeft"     => {|| GridWidth( 10.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "gc_door_open_64",;
                           "bLClicked" => {|| ::oDlg:End() },;
                           "oWnd"      => ::oDlg } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineBotonesGenerales() CLASS ViewReporting

   ::oBtnInformesArticulos := TGridImage():Build(  {  "nTop"      => ::getRow(),;
                                                      "nLeft"     => {|| GridWidth( 0.5, ::oDlg ) },;
                                                      "nWidth"    => 64,;
                                                      "nHeight"   => 64,;
                                                      "cResName"  => "gc_object_cube_printer_64",;
                                                      "bLClicked" => {|| MsgInfo( "Informes articulo" ) },;
                                                      "oWnd"      => ::oDlg } )

   ::oBtnInformesClientes  := TGridImage():Build(  {  "nTop"      => ::getRow(),;
                                                      "nLeft"     => {|| GridWidth( 2, ::oDlg ) },;
                                                      "nWidth"    => 64,;
                                                      "nHeight"   => 64,;
                                                      "cResName"  => "gc_user_printer_64",;
                                                      "bLClicked" => {|| MsgInfo( "Informes clientes" ) },;
                                                      "oWnd"      => ::oDlg } )

   ::oBtnInformesEjecutar  := TGridImage():Build(  {  "nTop"      => ::getRow(),;
                                                      "nLeft"     => {|| GridWidth( 3.5, ::oDlg ) },;
                                                      "nWidth"    => 64,;
                                                      "nHeight"   => 64,;
                                                      "cResName"  => "gc_printer_64",;
                                                      "bLClicked" => {|| MsgInfo( "Ejecuto el informe seleccionado" ) },;
                                                      "oWnd"      => ::oDlg } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineBrowseIva() CLASS ViewReporting

   ::oBrowse                  := TGridIXBrowse():New( ::oDlg )

   ::oBrowse:nTop             := ::oBrowse:EvalRow( ::getRow() )
   ::oBrowse:nLeft            := ::oBrowse:EvalCol( {|| GridWidth( 0.5, ::oDlg ) } )
   ::oBrowse:nWidth           := ::oBrowse:EvalWidth( {|| GridWidth( 11, ::oDlg ) } )
   ::oBrowse:nHeight          := ::oBrowse:EvalHeight( {|| GridHeigth( ::oDlg ) - ::oBrowse:nTop - 10 } )
   ::oBrowse:lFooter          := .t.
   ::oBrowse:nMarqueeStyle    := 6

   with object ( ::oBrowse:AddCol() )
      :cHeader             := "Base"
      :bStrData            := {|| ::oSender:oTotalDocument:showBaseIVA( ::oBrowse:nArrayAt ) }
      :nWidth              := 170
      :nDataStrAlign       := 1
      :nHeadStrAlign       := 1
      :nFootStrAlign       := 1
      :bFooter             := {|| ::oSender:oTotalDocument:transBase() }
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := "%" + cImp() + " - % RE"
      :bStrData            := {|| ::oSender:oTotalDocument:showPorcentajesIVA( ::oBrowse:nArrayAt ) }
      :nWidth              := 170
      :nDataStrAlign       := 1
      :nHeadStrAlign       := 1
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := cImp() + " - RE"
      :bStrData            := {|| ::oSender:oTotalDocument:showImportesIVA( ::oBrowse:nArrayAt ) }
      :nWidth              := 160
      :nDataStrAlign       := 1
      :nHeadStrAlign       := 1
      :nFootStrAlign       := 1
      :bFooter             := {|| ::oSender:oTotalDocument:transPrice() }
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := "Total"
      :bStrData            := {|| ::oSender:oTotalDocument:showTotalIVA( ::oBrowse:nArrayAt ) }
      :nWidth              := 170
      :nDataStrAlign       := 1
      :nHeadStrAlign       := 1
      :nFootStrAlign       := 1
      :bFooter             := {|| ::oSender:oTotalDocument:transTotalDocument() }
   end with

   ::oBrowse:nHeaderHeight    := 48
   ::oBrowse:nFooterHeight    := 48
   ::oBrowse:nRowHeight       := 96
   ::oBrowse:nDataLines       := 2

   ::oBrowse:SetArray( ::oSender:oTotalDocument:oIva:aIva, , , .f. )

   ::oBrowse:CreateFromCode()

Return ( self )

//---------------------------------------------------------------------------//