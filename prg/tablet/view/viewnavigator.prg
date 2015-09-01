#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS ViewNavigator FROM ViewBase

   METHOD New()

   METHOD Resource()

   METHOD getWorkArea()                      INLINE ( ::oSender:getWorkArea() )

   METHOD setBrowseConfigurationName( cName ) ;
                                             INLINE ( if( !empty( ::oBrowse ), ::oBrowse:cName := cName, ) )

   METHOD BotonesAcciones()

   METHOD BotonesMovimientoBrowse()

   METHOD BrowseGeneral()

   METHOD insertControls()                   INLINE ( ::BrowseGeneral() )

   METHOD setColumns()                       VIRTUAL
      METHOD addColumn()                     INLINE ( ::oBrowse:addCol() )

   METHOD refreshBrowse()                    INLINE ( iif(  !empty( ::oBrowse),;
                                                      ( ::oBrowse:Select( 0 ), ::oBrowse:Select( 1 ), ::oBrowse:Refresh() ),;
                                                      ) )

   METHOD onDblClickBrowseGeneral()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS ViewNavigator

   ::oSender                     := oSender

Return ( self )

//---------------------------------------------------------------------------//

METHOD Resource() CLASS ViewNavigator

   ::oDlg                  := TDialog():New( 1, 5, 40, 100, "GESTOOL TABLET",,, .f., ::Style,, rgb( 255, 255, 255 ),,, .F.,, oGridFont(),,,, .f.,, "oDlg" )

   ::defineTitulo()

   ::defineSalir()

   ::BotonesAcciones()

   ::BotonesMovimientoBrowse()

   ::BrowseGeneral()

   ::oDlg:bResized         := {|| ::resizeDialog() }

   ::oDlg:Activate( ,,,.t.,,, {|| ::InitDialog() } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD BotonesAcciones() CLASS ViewNavigator

   TGridImage():Build(  {  "nTop"      => 75,;
                           "nLeft"     => {|| GridWidth( 0.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_add_64",;
                           "bLClicked" => {|| if( ::oSender:Append(), ::refreshBrowse(), ) },;
                           "oWnd"      => ::oDlg } )

   TGridImage():Build(  {  "nTop"      => 75,;
                           "nLeft"     => {|| GridWidth( 2, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_edit_64",;
                           "bLClicked" => {|| if( ::oSender:Edit(), ::refreshBrowse(), ) },;
                           "oWnd"      => ::oDlg } )

   TGridImage():Build(  {  "nTop"      => 75,;
                           "nLeft"     => {|| GridWidth( 3.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_minus_64",;
                           "bLClicked" => {|| if( ::oSender:Delete(), ::refreshBrowse(), ) },;
                           "oWnd"      => ::oDlg } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD BotonesMovimientoBrowse() CLASS ViewNavigator

   TGridImage():Build(  {  "nTop"      => 75,;
                           "nLeft"     => {|| GridWidth( 7.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_page_up_64",;
                           "bLClicked" => {|| ::oBrowse:PageUp(), ::refreshBrowse()  },;
                           "oWnd"      => ::oDlg } )

   TGridImage():Build(  {  "nTop"      => 75,;
                           "nLeft"     => {|| GridWidth( 8.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_up_64",;
                           "bLClicked" => {|| ::oBrowse:GoUp(), ::refreshBrowse()  },;
                           "oWnd"      => ::oDlg } )

   TGridImage():Build(  {  "nTop"      => 75,;
                           "nLeft"     => {|| GridWidth( 9.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_down_64",;
                           "bLClicked" => {|| ::oBrowse:GoDown(), ::refreshBrowse() },;
                           "oWnd"      => ::oDlg } )

   TGridImage():Build(  {  "nTop"      => 75,;
                           "nLeft"     => {|| GridWidth( 10.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_page_down_64",;
                           "bLClicked" => {|| ::oBrowse:PageDown(), ::refreshBrowse() },;
                           "oWnd"      => ::oDlg } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD BrowseGeneral( oDlg ) CLASS ViewNavigator

   DEFAULT oDlg               := ::oDlg

   ::oBrowse                  := TGridIXBrowse():New( oDlg )

   ::oBrowse:nTop             := ::oBrowse:EvalRow( 115 )
   ::oBrowse:nLeft            := ::oBrowse:EvalCol( {|| GridWidth( 0.5, oDlg ) } )
   ::oBrowse:nWidth           := ::oBrowse:EvalWidth( {|| GridWidth( 11, oDlg ) } )
   ::oBrowse:nHeight          := ::oBrowse:EvalHeight( {|| GridHeigth( oDlg ) - ::oBrowse:nTop - 10 } )
   ::oBrowse:nMarqueeStyle    := 6

   ::oBrowse:nHeaderHeight    := 48
   ::oBrowse:nFooterHeight    := 48
   ::oBrowse:nRowHeight       := 96
   ::oBrowse:nDataLines       := 2

   ::oBrowse:cAlias           := ::getWorkArea()

   ::setColumns()

   ::oBrowse:bLDblClick       := {|| ::onDblClickBrowseGeneral() }

   ::oBrowse:CreateFromCode()  

Return ( self )

//---------------------------------------------------------------------------//

METHOD onDblClickBrowseGeneral() CLASS ViewNavigator

   ::oSender:Edit()
   ::refreshBrowse()

Return ( self )

//---------------------------------------------------------------------------//