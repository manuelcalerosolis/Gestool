#include "FiveWin.Ch"
#include "Factu.ch" 

#define __initialRow__                                   40
#define __rowDistance__                                  25

CLASS ViewBase

   DATA buttonEnd
   DATA buttonCancel
   DATA buttonOk

   DATA oSayTitle

   DATA columnLabel                                      INIT 0.2
   DATA widthLabel                                       INIT 1.8

   DATA oDlg

   DATA oBrowse

   DATA oSender

   DATA cErrorValidator                                  INIT ""

   DATA Style                                            INIT ( nOR( DS_MODALFRAME, WS_POPUP, WS_CAPTION, WS_SYSMENU, WS_MINIMIZEBOX, WS_MAXIMIZEBOX ) )
   
   DATA cTitleDocumento                                  INIT ""

   DATA nRow                                             INIT 40

   DATA bPreShowDialog
   DATA bPostDialog 

   METHOD setBrowseConfigurationName( cName )            INLINE ( if( !empty( ::oBrowse ), ::oBrowse:cName := cName, ) )
   METHOD getBrowseConfigurationName()                   INLINE ( if( !empty( ::oBrowse ), ::oBrowse:cName, "" ) )
   METHOD loadBrowseConfiguration()                      INLINE ( if( !empty( ::oBrowse ) .and. !empty( ::oBrowse:cName ), ::oBrowse:Load(), ) )

   METHOD setTitleDocumento( cTitleDocumento )           INLINE ( if( !empty( cTitleDocumento ), ::cTitleDocumento := cTitleDocumento, ) )
   METHOD getTitleDocumento()                            INLINE ( if( !empty( ::oSender:textMode() ), ::oSender:textMode() + lower( ::cTitleDocumento ), ::cTitleDocumento ) )

   METHOD setPreShowDialog( bPreShowDialog )             INLINE ( ::bPreShowDialog := bPreShowDialog )
   METHOD evalPreShowDialog()                            INLINE ( if( !empty( ::bPreShowDialog ), eval( ::bPreShowDialog, self ), ) )
   
   METHOD setPostShowDialog( bPostShowDialog )           INLINE ( ::bPostShowDialog := bPostShowDialog )
   METHOD evalPostDialog()                               INLINE ( if( !empty( ::bPostDialog ), eval( ::bPostDialog, self ), ) )

   METHOD showView()            

   METHOD Resource()
      METHOD insertControls()                            VIRTUAL

   METHOD getView()                                      INLINE ( ::oSender:nView )
   METHOD getMode()                                      INLINE ( ::oSender:nMode )
   METHOD getChangePrecio()                              INLINE ( oUser():lCambiarPrecio() )

   METHOD defineTitulo()
   METHOD defineAceptarCancelar()
   METHOD defineSalir()

   METHOD resizeDialog()
   METHOD initDialog()
   METHOD endDialog()                                    VIRTUAL
   METHOD startDialog()                                  VIRTUAL
   METHOD validDialog()                                  INLINE ( .t. )

   METHOD setDialog( oDlg )                              INLINE ( ::oDlg := oDlg )

   METHOD setGetValue( uValue, cName )                   INLINE ( iif(  isNil( uValue ),;
                                                                        hGet( ::oSender:hDictionaryMaster, cName ),;
                                                                        hSet( ::oSender:hDictionaryMaster, cName, uValue ) ) )

   METHOD getValue( cName )                              INLINE ( hGet( ::oSender:hDictionaryMaster, cName ) )
   METHOD setValue( uValue, cFieldName )                 INLINE ( hSet( ::oSender:hDictionaryMaster, cFieldName, uValue ) ) 

   METHOD setErrorValidator( cErrorText )

   METHOD errorValidator() 

   METHOD endView()                                      INLINE ( ::oDlg:goNextCtrl( GetFocus() ),;
                                                                  ::oDlg:goPrevCtrl( GetFocus() ),;
                                                                  iif( ::errorValidator(), apoloMsgStop( ::cErrorValidator ), ::oDlg:End( IDOK ) ) )
   METHOD cancelView()                                   INLINE ( if( ApoloMsgNoYes( "¿Desea terminar el proceso?", "¡Atención!", .t. ), ::oDlg:End(), ) )

   METHOD evalDialog()

   METHOD getRow()                                       INLINE ( ::nRow )
   METHOD resetRow()                                     INLINE ( ::nRow := __initialRow__ )
   METHOD nextRow()                                      INLINE ( ::nRow += __rowDistance__ )

END CLASS

//---------------------------------------------------------------------------//

METHOD showView() CLASS ViewBase

   ::evalPreShowDialog()

   ::Resource()

   ::evalPostDialog()

Return ( self )

//---------------------------------------------------------------------------//

METHOD Resource() CLASS ViewBase

   ::resetRow()

   ::oDlg                  := TDialog():New( 1, 5, 40, 100, "GESTOOL TABLET",,, .f., ::Style,, rgb( 255, 255, 255 ),,, .F.,, oGridFont(),,,, .f.,, "oDlg" )

   ::defineTitulo()

   ::defineAceptarCancelar()

   ::insertControls()

   ::oDlg:bResized         := {|| ::resizeDialog() }

   ::oDlg:bStart           := {|| ::startDialog() }

   ::oDlg:Activate( , , , .t., {|| ::validDialog() }, , {|| ::initDialog() } )

Return ( ::oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD defineTitulo() CLASS ViewBase 

   ::oSayTitle    := TGridSay():Build(    {  "nRow"      => 0,;
                                             "nCol"      => {|| GridWidth( ::columnLabel, ::oDlg ) },;
                                             "bText"     => {|| ::getTitleDocumento() },;
                                             "oWnd"      => ::oDlg,;
                                             "oFont"     => oGridFontBold(),;
                                             "lPixels"   => .t.,;
                                             "nClrText"  => Rgb( 0, 0, 0 ),;
                                             "nClrBack"  => Rgb( 255, 255, 255 ),;
                                             "nWidth"    => {|| GridWidth( 7, ::oDlg ) },;
                                             "nHeight"   => 42,;
                                             "lDesign"   => .f. } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineSalir() CLASS ViewBase

   ::buttonEnd       :=    TGridImage():Build(  {  "nTop"      => 5,;
                                                   "nLeft"     => {|| GridWidth( 10.5, ::oDlg ) },;
                                                   "nWidth"    => 64,;
                                                   "nHeight"   => 64,;
                                                   "cResName"  => "gc_door_open_64",;
                                                   "bLClicked" => {|| if ( !Empty( ::oDlg ), ::oDlg:End(), ) },;
                                                   "oWnd"      => ::oDlg } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineAceptarCancelar() CLASS ViewBase

   ::buttonCancel    :=    TGridImage():Build(  {  "nTop"      => 5,;
                                                   "nLeft"     => {|| GridWidth( 9.0, ::oDlg ) },;
                                                   "nWidth"    => 64,;
                                                   "nHeight"   => 64,;
                                                   "cResName"  => "gc_error_64",;
                                                   "bLClicked" => {|| ::cancelView() },;
                                                   "oWnd"      => ::oDlg } )

   ::buttonOk        :=    TGridImage():Build(  {  "nTop"      => 5,;
                                                   "nLeft"     => {|| GridWidth( 10.5, ::oDlg ) },;
                                                   "nWidth"    => 64,;
                                                   "nHeight"   => 64,;
                                                   "cResName"  => "gc_ok_64",;
                                                   "bLClicked" => {|| ::endView() },;
                                                   "oWnd"      => ::oDlg } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD resizeDialog() CLASS ViewBase

   gridResize( ::oDlg )

   ::loadBrowseConfiguration()

Return ( self )

//---------------------------------------------------------------------------//

METHOD initDialog() CLASS ViewBase

   GridMaximize( ::oDlg )

Return ( self )

//---------------------------------------------------------------------------//

METHOD setErrorValidator( cErrorText ) CLASS ViewBase

   ::cErrorValidator    += cErrorText + CRLF

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD errorValidator() CLASS ViewBase

   ::cErrorValidator    := ""

   ::oDlg:aEvalValid()

Return ( !empty( ::cErrorValidator ) )   

//---------------------------------------------------------------------------//

METHOD evalDialog() CLASS ViewBase

   local oControl
   local lValid      := .t.
   local aControls   := ::oDlg:aControls

   if empty( aControls )
      Return ( lValid )
   end if 

   for each oControl in aControls

      if empty( oControl:bWhen ) .or. eval( oControl:bWhen )

         if !empty( oControl:bValid ) .and. !eval( oControl:bValid )

            lValid   := .f.
            oControl:SetFocus()

         endif

      end if 
      
   next

return ( lValid )

//---------------------------------------------------------------------------//