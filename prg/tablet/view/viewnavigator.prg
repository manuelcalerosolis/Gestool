#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS ViewNavigator FROM ViewBase

   METHOD New()

   METHOD Resource()

   METHOD getView()                          INLINE ( ::oSender:nView )
   METHOD getWorkArea()                      INLINE ( ::oSender:getWorkArea() )
   METHOD getWorkArray()                     INLINE ( ::oSender:getDataArray() )

   METHOD botonesAcciones()

   METHOD botonesMovimientoBrowse()

   METHOD browseGeneral()
   METHOD browseArray( oDlg )

   METHOD insertControls()                   INLINE ( ::BrowseGeneral() )

   METHOD setColumns()                       VIRTUAL
      METHOD addColumn()                     INLINE ( ::oBrowse:addCol() )

   METHOD refreshBrowse()                    INLINE ( iif(  !empty( ::oBrowse),;
                                                            ( ::oBrowse:Select( 0 ), ::oBrowse:Select( 1 ), ::oBrowse:Refresh() ),;
                                                         ) )

   DATA bDblClickBrowseGeneral
   METHOD setDblClickBrowseGeneral( block )  INLINE ( ::bDblClickBrowseGeneral := block )
   METHOD getDblClickBrowseGeneral()         INLINE ( ::bDblClickBrowseGeneral )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS ViewNavigator

   ::oSender               := oSender

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
                           "cResName"  => "gc_plus_64",;
                           "bLClicked" => {|| if( ::oSender:Append(), ::refreshBrowse(), ) },;
                           "oWnd"      => ::oDlg } )

   if ::oSender:lAlowEdit

   TGridImage():Build(  {  "nTop"      => 75,;
                           "nLeft"     => {|| GridWidth( 2, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "gc_pencil_64",;
                           "bLClicked" => {|| if( ::oSender:Edit(), ::refreshBrowse(), ) },;
                           "oWnd"      => ::oDlg } )

   TGridImage():Build(  {  "nTop"      => 75,;
                           "nLeft"     => {|| GridWidth( 3.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "gc_delete_64",;
                           "bLClicked" => {|| if( ::oSender:Delete(), ::refreshBrowse(), ) },;
                           "oWnd"      => ::oDlg } )

   else

   TGridImage():Build(  {  "nTop"      => 75,;
                           "nLeft"     => {|| GridWidth( 2, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "gc_binocular_64",;
                           "bLClicked" => {|| if( ::oSender:Zoom(), ::refreshBrowse(), ) },;
                           "oWnd"      => ::oDlg } )

   end if 

Return ( self )

//---------------------------------------------------------------------------//

METHOD BotonesMovimientoBrowse() CLASS ViewNavigator

   TGridImage():Build(  {  "nTop"      => 75,;
                           "nLeft"     => {|| GridWidth( 7.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "gc_navigate_up2_64",;
                           "bLClicked" => {|| ::oBrowse:GoTop(), ::refreshBrowse()  },;
                           "oWnd"      => ::oDlg } )

   TGridImage():Build(  {  "nTop"      => 75,;
                           "nLeft"     => {|| GridWidth( 8.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "gc_navigate_up_64",;
                           "bLClicked" => {|| ::oBrowse:PageUp(), ::refreshBrowse()  },;
                           "oWnd"      => ::oDlg } )

   TGridImage():Build(  {  "nTop"      => 75,;
                           "nLeft"     => {|| GridWidth( 9.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "gc_navigate_down_64",;
                           "bLClicked" => {|| ::oBrowse:PageDown(), ::refreshBrowse() },;
                           "oWnd"      => ::oDlg } )

   TGridImage():Build(  {  "nTop"      => 75,;
                           "nLeft"     => {|| GridWidth( 10.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "gc_navigate_down2_64",;
                           "bLClicked" => {|| ::oBrowse:GoBottom(), ::refreshBrowse() },;
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

   ::oBrowse:bLDblClick       := ::getDblClickBrowseGeneral()

   ::oBrowse:CreateFromCode()  

Return ( self )

//---------------------------------------------------------------------------//

METHOD BrowseArray( oDlg ) CLASS ViewNavigator

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

   ::oBrowse:SetArray( ::getWorkArray(), , , .f. )

   ::setColumns()

   ::oBrowse:bLDblClick       := ::getDblClickBrowseGeneral()

   ::oBrowse:CreateFromCode()  

Return ( self )

//---------------------------------------------------------------------------//