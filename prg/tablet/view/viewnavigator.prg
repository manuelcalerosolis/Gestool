#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS ViewNavigator FROM ViewBase

   DATA oDlg
   DATA oBrowse
   DATA oSender

   METHOD New()

   METHOD Resource()

   METHOD SetDialog( oDlg )            INLINE ( ::oDlg := oDlg )
   
   METHOD getWorkArea()                INLINE ( ::oSender:getWorkArea() )

   METHOD setBrowseConfigurationName( cName ) ;
                                       INLINE ( if( !empty( ::oBrowse ), ::oBrowse:cName := cName, ) )

   METHOD BotonesAcciones()

   METHOD BotonesMovimientoBrowse()

   METHOD BrowseGeneral()

   METHOD setColumns()                 VIRTUAL
      METHOD addColumn()               INLINE ( ::oBrowse:addCol() )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS ViewNavigator

   ::oSender   := oSender

Return ( self )

//---------------------------------------------------------------------------//

METHOD Resource() CLASS ViewNavigator

   ::BotonesAcciones()

   ::BotonesMovimientoBrowse()

   ::BrowseGeneral()

Return ( self )

//---------------------------------------------------------------------------//

METHOD BotonesAcciones() CLASS ViewNavigator

   TGridImage():Build(  {  "nTop"      => 75,;
                           "nLeft"     => {|| GridWidth( 0.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_add_64",;
                           "bLClicked" => {|| ::oSender:Append() },;
                           "oWnd"      => ::oDlg } )

   TGridImage():Build(  {  "nTop"      => 75,;
                           "nLeft"     => {|| GridWidth( 2, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_edit_64",;
                           "bLClicked" => {|| ::oSender:Edit() },;
                           "oWnd"      => ::oDlg } )

   TGridImage():Build(  {  "nTop"      => 75,;
                           "nLeft"     => {|| GridWidth( 3.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_minus_64",;
                           "bLClicked" => {|| ::oSender:Delete() },;
                           "oWnd"      => ::oDlg } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD BotonesMovimientoBrowse() CLASS ViewNavigator

   TGridImage():Build(  {  "nTop"      => 75,;
                           "nLeft"     => {|| GridWidth( 7.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_page_up_64",;
                           "bLClicked" => {|| ::oBrowse:PageUp(), ::oBrowse:Select( 0 ), ::oBrowse:Select( 1 ), ::oBrowse:Refresh()  },;
                           "oWnd"      => ::oDlg } )

   TGridImage():Build(  {  "nTop"      => 75,;
                           "nLeft"     => {|| GridWidth( 8.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_up_64",;
                           "bLClicked" => {|| ::oBrowse:GoUp(), ::oBrowse:Select( 0 ), ::oBrowse:Select( 1 ), ::oBrowse:Refresh()  },;
                           "oWnd"      => ::oDlg } )

   TGridImage():Build(  {  "nTop"      => 75,;
                           "nLeft"     => {|| GridWidth( 9.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_down_64",;
                           "bLClicked" => {|| ::oBrowse:GoDown(), ::oBrowse:Select( 0 ), ::oBrowse:Select( 1 ), ::oBrowse:Refresh() },;
                           "oWnd"      => ::oDlg } )

   TGridImage():Build(  {  "nTop"      => 75,;
                           "nLeft"     => {|| GridWidth( 10.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_page_down_64",;
                           "bLClicked" => {|| ::oBrowse:PageDown(), ::oBrowse:Select( 0 ), ::oBrowse:Select( 1 ), ::oBrowse:Refresh() },;
                           "oWnd"      => ::oDlg } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD BrowseGeneral() CLASS ViewNavigator

   ::oBrowse                  := TGridIXBrowse():New( ::oDlg )

   ::oBrowse:nTop             := ::oBrowse:EvalRow( 115 )
   ::oBrowse:nLeft            := ::oBrowse:EvalCol( {|| GridWidth( 0.5, ::oDlg ) } )
   ::oBrowse:nWidth           := ::oBrowse:EvalWidth( {|| GridWidth( 11, ::oDlg ) } )
   ::oBrowse:nHeight          := ::oBrowse:EvalHeight( {|| GridHeigth( ::oDlg ) - ::oBrowse:nTop - 10 } )
   ::oBrowse:nMarqueeStyle    := 6

   ::oBrowse:nHeaderHeight    := 48
   ::oBrowse:nFooterHeight    := 48
   ::oBrowse:nRowHeight       := 96
   ::oBrowse:nDataLines       := 2

   ::oBrowse:cAlias           := ::getWorkArea()

   ::setColumns()

   ::oBrowse:bLDblClick       := {|| ::oSender:Edit() }

   ::oBrowse:CreateFromCode()

Return ( self )

//---------------------------------------------------------------------------//