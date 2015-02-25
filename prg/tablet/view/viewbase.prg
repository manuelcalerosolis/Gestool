#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS ViewBase

   DATA oDlg

   DATA oBrowse

   DATA oSender

   DATA Style                          INIT ( nOR( DS_MODALFRAME, WS_POPUP, WS_CAPTION, WS_SYSMENU, WS_MINIMIZEBOX, WS_MAXIMIZEBOX ) )

   DATA cTextoTipoDocumento

   METHOD setTextoTipoDocumento( cTextoTipoDocumento );
                                       INLINE ( ::cTextoTipoDocumento := cTextoTipoDocumento )
   METHOD getTextoTipoDocumento()      INLINE ( ::cTextoTipoDocumento )

   DATA bPreShowDialog
   METHOD setPreShowDialog( bPreShowDialog );
                                       INLINE ( ::bPreShowDialog := bPreShowDialog )
   METHOD evalPreShowDialog()          INLINE ( if( !empty( ::bPreShowDialog ), eval( ::bPreShowDialog, self ), ) )
   
   DATA bPostDialog 
   METHOD setPostShowDialog( bPostShowDialog );
                                       INLINE ( ::bPostShowDialog := bPostShowDialog )
   METHOD evalPostDialog()             INLINE ( if( !empty( ::bPostDialog ), eval( ::bPostDialog, self ), ) )

   METHOD showView()            

   METHOD Resource()
      METHOD insertControls()          VIRTUAL

   METHOD getView()                    INLINE ( ::oSender:nView )
   METHOD getMode()                    INLINE ( ::oSender:nMode )

   METHOD defineTitulo()
   METHOD defineAceptarCancelar()
   METHOD defineSalir()

   METHOD resizeDialog()
   METHOD initDialog()
   METHOD startDialog()                VIRTUAL

   METHOD setDialog( oDlg )            INLINE ( ::oDlg := oDlg )

   METHOD setGetValue( uValue, cName ) INLINE ( iif(  empty( uValue ),;
                                                      hGet( ::oSender:hDictionaryMaster, cName ),;
                                                      hSet( ::oSender:hDictionaryMaster, cName, uValue ) ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD showView() CLASS ViewBase

   ::evalPreShowDialog()

   ::Resource()

   ::evalPostDialog()

Return ( self )

//---------------------------------------------------------------------------//

METHOD Resource() CLASS ViewBase

   ::oDlg                  := TDialog():New( 1, 5, 40, 100, "GESTOOL TABLET",,, .f., ::Style,, rgb( 255, 255, 255 ),,, .F.,, oGridFont(),,,, .f.,, "oDlg" )

   ::defineTitulo()

   ::defineAceptarCancelar()

   ::insertControls()

   ::oDlg:bResized         := {|| ::resizeDialog() }

   ::oDlg:bStart           := {|| ::startDialog() }

   ::oDlg:Activate( ,,,.t.,,, {|| ::initDialog() } )

Return ( ::oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD defineTitulo() CLASS ViewBase 

   TGridSay():Build(    {  "nRow"      => 0,;
                           "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                           "bText"     => {|| ::getTextoTipoDocumento() },;
                           "oWnd"      => ::oDlg,;
                           "oFont"     => oGridFontBold(),;
                           "lPixels"   => .t.,;
                           "nClrText"  => Rgb( 0, 0, 0 ),;
                           "nClrBack"  => Rgb( 255, 255, 255 ),;
                           "nWidth"    => {|| GridWidth( 7, ::oDlg ) },;
                           "nHeight"   => 32,;
                           "lDesign"   => .f. } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineSalir() CLASS ViewBase

   TGridImage():Build(  {  "nTop"      => 5,;
                           "nLeft"     => {|| GridWidth( 10.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_end_64",;
                           "bLClicked" => {|| ::oDlg:End() },;
                           "oWnd"      => ::oDlg } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineAceptarCancelar() CLASS ViewBase

   TGridImage():Build(  {  "nTop"      => 5,;
                           "nLeft"     => {|| GridWidth( 9.0, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_del_64",;
                           "bLClicked" => {|| ::oDlg:End() },;
                           "oWnd"      => ::oDlg } )

   TGridImage():Build(  {  "nTop"      => 5,;
                           "nLeft"     => {|| GridWidth( 10.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_check_64",;
                           "bLClicked" => {|| ::oDlg:End( IDOK ) },;
                           "oWnd"      => ::oDlg } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD resizeDialog() CLASS ViewBase

   GridResize( ::oDlg )

Return ( self )

//---------------------------------------------------------------------------//

METHOD initDialog() CLASS ViewBase

   GridMaximize( ::oDlg )

Return ( self )

//---------------------------------------------------------------------------//