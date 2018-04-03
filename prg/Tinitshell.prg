#include "FiveWin.Ch"
#include "Splitter.ch"
#include "Factu.ch" 
#include "Constant.ch"

#define NUMERO_DOCUMENTOS     5

#define LINEA_HORIZONTAL      70

#define WM_ERASEBKGND         20       // 0x14
#define WM_CHILDACTIVATE      34       // 0x22
#define WM_ICONERASEBKGND     39       // 0x27

#define TVS_HASLINES          2


#define GWL_EXSTYLE           -20
#define WS_EX_LAYERED         524288

#define LWA_COLORKEY          1
#define LWA_ALPHA             2

//------------------------------------------------------------------------//

CLASS TInitShell FROM TMdiChild

   DATA  oFont
   DATA  oIcon
   DATA  cTitle

   DATA  bDestroy

   DATA  oImageList

   DATA  oBtnTop

   DATA  oTreeAccesos
   DATA  oTreeRecibosCompras
   DATA  oTreeRecibosVentas
   DATA  oTreeVentas
   DATA  oTreeDocumentos
   DATA  oTreeAgenda

   DATA  oTreeArticulos

   DATA  oVertical1Splitter
   DATA  oVertical2Splitter
   DATA  oHorizontal3Splitter
   DATA  oHorizontalSplitter
   DATA  oHorizontal1Splitter
   DATA  oHorizontal2Splitter

   DATA  nAnchoSplitter
   DATA  nAltoSplitter

   DATA  lOnProcess

   DATA  cPorDiv
   DATA  cPirDiv

   DATA  aDocuments

   DATA  oGraph

   Method New( nTop, nLeft, nBottom, nRight, cTitle, oMenu, oWnd, oIcon,;
               ocursor, lpixel, nhelpid  )

   Method Create() INLINE ( Self )

   Method Activate( cShow, bLClicked, bRClicked, bMoved, bResized, bPainted,;
                    bkeydown, binit, bup, bdown, bpgup, bpgdn,;
                    bleft, bright, bpgleft, bpgright, bvalid, bdropfiles,;
                    blbuttonup )

   Method KeyDown( nKey, nFlags )

   Method End()

   Method Destroy()

   Method Display() INLINE ::BeginPaint(), ::Paint(), ::EndPaint()

   Method HelpTopic()                  VIRTUAL

   Method ClickTree()                  VIRTUAL

   Method ClickDocuments()

   Method KillProcess()                INLINE ( ::lOnProcess := .f. )

   Method LoadAccesos()

   Method LoadRecibosProveedores()

   Method LoadRecibosClientes()

   Method LoadNotas()

   Method LoadBackup()

   Method LoadDivisa()

   Method LoadDocuments()

   Method LoadArticulos()

   Method LoadClientes()

   Method LoadProveedores()

   Method Maximize()

   Method Resize()

   Method LoadGraph()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New(  nTop, nLeft, nBottom, nRight, cTitle, oMenu, oWnd, oIcon,;
             oCursor, lPixel, nHelpId ) CLASS TInitShell



   local nScreenHorzRes    := GetSysMetrics( 0 )
   local nScreenVertRes    := GetSysMetrics( 1 )

   DEFAULT nTop            := 0
   DEFAULT nLeft           := 0
   DEFAULT nBottom         := 22
   DEFAULT nRight          := 80
   DEFAULT cTitle          := "Bienvenido, " + Capitalize( oUser():cNombre() )
   DEFAULT oWnd            := GetWndFrame()
   DEFAULT lPixel          := .f.
   DEFAULT oIcon           := TIcon():New( ,, "BROWSE",, )
   DEFAULT oCursor         := TCursor():New( , "ARROW" )

   /*
   Cerramos todas las ventanas----------------------------------------------
   */

   if oWnd() != nil
      oWnd():CloseAll()
   end if

   // Cargamos los valores de las divisas -------------------------------------

   ::LoadDivisa()

   // Adaptamos la longitud de pantalla a la resolución------------------------

   ::nTop            := nTop
   ::nLeft           := nLeft
   ::nBottom         := nBottom
   ::nRight          := nRight
   ::cTitle          := cTitle
   ::lOnProcess      := .f.

   // Tamaño de la ventana siempre a pixels------------------------------------

   ::nTop            := nTop    * if( !lPixel, MDIC_CHARPIX_H, 1 )
   ::nLeft           := nLeft   * if( !lPixel, MDIC_CHARPIX_W, 1 )
   ::nBottom         := nBottom * if( !lPixel, MDIC_CHARPIX_H, 1 )
   ::nRight          := nRight  * if( !lPixel, MDIC_CHARPIX_W, 1 )

   ::nAnchoSplitter  := Int( nScreenHorzRes / 3 )
   ::nAltoSplitter   := Int( ( nScreenVertRes - 200 - 40 ) / 2 )

   // Llamada al objeto padre para que se cree---------------------------------

   ::Super:New( 0, 0, 0, 0, cTitle, 0, oMenu, oWnd, oIcon, , , , oCursor, , .t., , nHelpId, "NONE", .f., .f., .f., .f. )

   // Imagelist----------------------------------------------------------------

   ::oImageList         := TImageList():New( 16, 16 )

   ::oImageList:AddMasked( TBitmap():Define( "gc_object_cube_16", ,                 Self ), Rgb( 255, 0, 255 ) )  // 0
   ::oImageList:AddMasked( TBitmap():Define( "gc_user_16", ,                       Self ), Rgb( 255, 0, 255 ) )  // 1
   ::oImageList:AddMasked( TBitmap():Define( "gc_businessman_16", ,                 Self ), Rgb( 255, 0, 255 ) )  // 2
   ::oImageList:AddMasked( TBitmap():Define( "gc_clipboard_empty_businessman_16", , Self ), Rgb( 255, 0, 255 ) )  // 3
   ::oImageList:AddMasked( TBitmap():Define( "gc_document_empty_businessman_16", ,  Self ), Rgb( 255, 0, 255 ) )  // 4
   ::oImageList:AddMasked( TBitmap():Define( "gc_document_text_businessman_16", ,        Self ), Rgb( 255, 0, 255 ) )  // 5
   ::oImageList:AddMasked( TBitmap():Define( "gc_briefcase2_businessman_16", ,          Self ), Rgb( 255, 0, 255 ) )  // 6
   ::oImageList:AddMasked( TBitmap():Define( "gc_notebook_user_16", ,              Self ), Rgb( 255, 0, 255 ) )  // 7
   ::oImageList:AddMasked( TBitmap():Define( "gc_clipboard_empty_user_16", ,     Self ), Rgb( 255, 0, 255 ) )  // 8
   ::oImageList:AddMasked( TBitmap():Define( "gc_document_empty_16", ,           Self ), Rgb( 255, 0, 255 ) )  // 9
   ::oImageList:AddMasked( TBitmap():Define( "gc_document_text_businessman_16", ,              Self ), Rgb( 255, 0, 255 ) )  //10
   ::oImageList:AddMasked( TBitmap():Define( "gc_document_text_money2_16", ,             Self ), Rgb( 255, 0, 255 ) )  //11
   ::oImageList:AddMasked( TBitmap():Define( "gc_document_text_delete2_16", ,             Self ), Rgb( 255, 0, 255 ) )  //12
   ::oImageList:AddMasked( TBitmap():Define( "gc_briefcase2_user_16", ,             Self ), Rgb( 255, 0, 255 ) )  //13
   ::oImageList:AddMasked( TBitmap():Define( "gc_cash_register_user_16", ,               Self ), Rgb( 255, 0, 255 ) )  //14
   ::oImageList:AddMasked( TBitmap():Define( "gc_cash_register_touch_16", ,          Self ), Rgb( 255, 0, 255 ) )  //15
   ::oImageList:AddMasked( TBitmap():Define( "gc_shield_16", ,                      Self ), Rgb( 255, 0, 255 ) )  //16
   ::oImageList:AddMasked( TBitmap():Define( "gc_satellite_dish2_16", ,              Self ), Rgb( 255, 0, 255 ) )  //17
   ::oImageList:AddMasked( TBitmap():Define( "gc_pda_16", ,                         Self ), Rgb( 255, 0, 255 ) )  //18
   ::oImageList:AddMasked( TBitmap():Define( "gc_note_16", ,                        Self ), Rgb( 255, 0, 255 ) )  //19
   ::oImageList:AddMasked( TBitmap():Define( "gc_bell_16", ,                        Self ), Rgb( 255, 0, 255 ) )  //20
   ::oImageList:AddMasked( TBitmap():Define( "gc_window_delete_16", ,               Self ), Rgb( 255, 0, 255 ) )  //21
   ::oImageList:AddMasked( TBitmap():Define( "End16", ,                          Self ), Rgb( 255, 0, 255 ) )  //22
   ::oImageList:AddMasked( TBitmap():Define( "gc_flash_16", ,                       Self ), Rgb( 255, 0, 255 ) )  //23
   ::oImageList:AddMasked( TBitmap():Define( "gc_document_text_16", ,                    Self ), Rgb( 255, 0, 255 ) )  //24

   // Barra de botones---------------------------------------------------------

#ifdef __MK__

   @ 0, 0   WEBBAR      ::oBtnTop ;
            SIZE        400, LINEA_HORIZONTAL - 2 ;
            CTLHEIGHT   20 ;
            FONT        ( TFont():New( "Arial", 0, -18, .f., .f. ) );
            COLOR       Rgb( 240, 240, 240 );
            BITMAP      FullCurDir() + "Bmp\IniMicroK.bmp" ;
            OF          Self

#else

   @ 0, 0   WEBBAR      ::oBtnTop ;
            SIZE        400, LINEA_HORIZONTAL - 2 ;
            CTLHEIGHT   20 ;
            FONT        ( TFont():New( "Arial", 0, -18, .f., .f. ) );
            COLOR       Rgb( 240, 240, 240 );
            BITMAP      FullCurDir() + "Bmp\IniRotor.bmp" ;
            OF          Self

#endif
   ::oBtnTop:Say( 36, 124, ::cTitle )

   ::oTreeAccesos            := TTreeView():New( LINEA_HORIZONTAL + 1, 0, Self, Rgb( 0, 0, 0 ), Rgb( 255, 255, 255 ), .t., .f., ::nAnchoSplitter, ::nAltoSplitter )
   ::oTreeAccesos:nStyle     := nOR( ::oTreeAccesos:nStyle, TVS_HASLINES )

   ::oTreeAccesos:SetItemHeight( 20 )
   ::oTreeAccesos:OnClick    := {|| ::ClickDocuments( ::oTreeAccesos ) }

   // Recibos de compras-------------------------------------------------------

   ::oTreeRecibosCompras             := TTreeView():New( LINEA_HORIZONTAL + ::nAltoSplitter + 7, 0, Self, Rgb( 0, 0, 0 ), Rgb( 255, 255, 255 ), .t., .f., ::nAnchoSplitter, ::nAltoSplitter )
   ::oTreeRecibosCompras:SetItemHeight( 20 )
   ::oTreeRecibosCompras:OnClick     := {|| ::ClickDocuments( ::oTreeRecibosCompras ) }

   // Arbol de documentos------------------------------------------------------

   ::oTreeDocumentos          := TTreeView():New( LINEA_HORIZONTAL + 1, ::nAnchoSplitter + 5, Self, Rgb( 0, 0, 0 ), Rgb( 255, 255, 255 ), .t., .f., ::nAnchoSplitter, ::nAltoSplitter )
   ::oTreeDocumentos:SetItemHeight( 20 )
   ::oTreeDocumentos:OnClick  := {|| ::ClickDocuments( ::oTreeDocumentos ) }

   // Recibos de ventas--------------------------------------------------------

   ::oTreeRecibosVentas             := TTreeView():New( LINEA_HORIZONTAL + ::nAltoSplitter + 7, ::nAnchoSplitter + 5, Self, Rgb( 0, 0, 0 ), Rgb( 255, 255, 255 ), .t., .f., ::nAnchoSplitter, ::nAltoSplitter )
   ::oTreeRecibosVentas:SetItemHeight( 20 )
   ::oTreeRecibosVentas:OnClick     := {|| ::ClickDocuments( ::oTreeRecibosVentas ) }

   // Arbol de agenda----------------------------------------------------------

   ::oTreeAgenda              := TTreeView():New( LINEA_HORIZONTAL + 1, ( ::nAnchoSplitter * 2 ) + 11, Self, Rgb( 0, 0, 0 ), Rgb( 255, 255, 255 ), .t., .f., ::nAnchoSplitter, ::nAltoSplitter )
   ::oTreeAgenda:SetItemHeight( 20 )
   ::oTreeAgenda:OnClick      := {|| ::ClickDocuments( ::oTreeAgenda ) }

   //::oTreeAgenda              := TActiveX():New( Self, "Shell.Explorer" )
   //::oTreeAgenda:Do( "GoHome" )

   ::oGraph             := TGraph():New( LINEA_HORIZONTAL + ::nAltoSplitter + 7, ( ::nAnchoSplitter * 2 ) + 11, Self, ::nAnchoSplitter, ::nAltoSplitter )

   ::oGraph:aSeries     := {}
   ::oGraph:aData       := {}
   ::oGraph:aSTemp      := {}
   ::oGraph:aDTemp      := {}
   ::oGraph:cTitle      := "Evolución mensual de ventas"
   ::oGraph:l3D         := .f.
   ::oGraph:lcTitle     := .f.
   ::oGraph:lLegends    := .f.
   ::oGraph:lxVal       := .f.
   ::oGraph:lyVal       := .t.
   ::oGraph:lViewVal    := .t.
   ::oGraph:nClrT       := Rgb( 55, 55, 55)
   ::oGraph:nClrX       := CLR_BLUE
   ::oGraph:nClrY       := CLR_RED
   ::oGraph:cPicture    := ::cPorDiv
   ::oGraph:bRClicked   := {|| GraphPropierties( ::oGraph ) }

   /*
   Montamos el objeto browse-------------------------------------------------
   */

   @ LINEA_HORIZONTAL - 4, 0  ;
      SPLITTER          ::oHorizontalSplitter ;
      HORIZONTAL ;
      LEFT MARGIN       0 ;
      RIGHT MARGIN      0 ;
      SIZE 800, 4       PIXEL ;
      OF                Self ;
      _3DLOOK

   @ LINEA_HORIZONTAL, ::nAnchoSplitter ;
      SPLITTER          ::oVertical1Splitter ;
      VERTICAL ;
      LEFT MARGIN       80 ;
      RIGHT MARGIN      ::oVertical2Splitter:nLast + 80 ;
      SIZE              4, ::nAnchoSplitter ;
      PIXEL ;
      OF                Self ;
      _3DLOOK

   @ LINEA_HORIZONTAL + ::nAltoSplitter + 2, 0  ;
      SPLITTER          ::oHorizontal1Splitter ;
      HORIZONTAL ;
      LEFT MARGIN       0 ;
      RIGHT MARGIN      0 ;
      SIZE              ::nAnchoSplitter, 4 ;
      PIXEL ;
      OF                Self ;
      _3DLOOK

   @ LINEA_HORIZONTAL, ( ( ::nAnchoSplitter + 3 ) * 2 ) ;
      SPLITTER          ::oVertical2Splitter ;
      VERTICAL ;
      LEFT MARGIN       ::oVertical1Splitter:nFirst + 80 ;
      RIGHT MARGIN      ::oHorizontal3Splitter:nLast + 80 ;
      SIZE 4, 800       PIXEL ;
      OF                Self ;
      _3DLOOK

   @ LINEA_HORIZONTAL + ::nAltoSplitter + 2, ::nAnchoSplitter + 4 ;
      SPLITTER          ::oHorizontal2Splitter ;
      HORIZONTAL ;
      LEFT MARGIN       0 ;
      RIGHT MARGIN      0 ;
      SIZE              ::nAnchoSplitter, 4 ;
      PIXEL ;
      OF                Self ;
      _3DLOOK

   @ LINEA_HORIZONTAL + ::nAltoSplitter + 2 , ( ::nAnchoSplitter + 5 ) * 2 ;
      SPLITTER          ::oHorizontal3Splitter ;
      HORIZONTAL ;
      LEFT MARGIN       0 ;
      RIGHT MARGIN      0 ;
      SIZE              ::nAnchoSplitter, 4 ;
      PIXEL ;
      OF                Self ;
      _3DLOOK

   ::oHorizontalSplitter:lStatic       := .t.
   ::oHorizontalSplitter:aPrevCtrols   := { ::oBtnTop }
   ::oHorizontalSplitter:aHindCtrols   := { ::oTreeAccesos, ::oTreeRecibosCompras, ::oTreeVentas, ::oVertical1Splitter, ::oVertical2Splitter }

   ::oHorizontal1Splitter:lStatic      := .f.
   ::oHorizontal1Splitter:aPrevCtrols  := { ::oTreeAccesos }
   ::oHorizontal1Splitter:aHindCtrols  := { ::oTreeRecibosCompras }

   ::oVertical1Splitter:lStatic        := .f.
   ::oVertical1Splitter:aPrevCtrols    := { ::oTreeAccesos, ::oHorizontal1Splitter, ::oTreeRecibosCompras }
   ::oVertical1Splitter:aHindCtrols    := { ::oTreeDocumentos, ::oHorizontal2Splitter, ::oTreeRecibosVentas }

   ::oHorizontal2Splitter:lStatic      := .f.
   ::oHorizontal2Splitter:aPrevCtrols  := { ::oTreeDocumentos }
   ::oHorizontal2Splitter:aHindCtrols  := { ::oTreeRecibosVentas }

   ::oVertical2Splitter:lStatic        := .f.
   ::oVertical2Splitter:aPrevCtrols    := { ::oTreeDocumentos, ::oHorizontal2Splitter, ::oTreeRecibosVentas }
   ::oVertical2Splitter:aHindCtrols    := { ::oTreeAgenda, ::oHorizontal3Splitter, ::oGraph }

   ::oHorizontal3Splitter:lStatic      := .f.
   ::oHorizontal3Splitter:aPrevCtrols  := { ::oTreeAgenda }
   ::oHorizontal3Splitter:aHindCtrols  := { ::oGraph }

RETURN Self

//----------------------------------------------------------------------------//

METHOD Activate( cShow, bLClicked, bRClicked, bMoved, bResized, bPainted,;
                  bKeyDown, bInit, bUp, bDown, bPgUp, bPgDn,;
                  bLeft, bRight, bPgLeft, bPgRight, bValid, bDropFiles,;
                  bLButtonUp ) CLASS TInitShell

   DEFAULT bValid    := {|| .t. }

   ::Super:Activate( cShow, bLClicked, bRClicked, bMoved, bResized, bPainted,;
                    bKeyDown, bInit, bUp, bDown, bPgUp, bPgDn, bLeft, bRight,;
                    bPgLeft, bPgRight, bValid, bDropFiles, bLButtonUp )

   ::oTreeAccesos:SetImagelist(        ::oImageList )
   ::oTreeRecibosCompras:SetImagelist( ::oImageList )
   ::oTreeRecibosVentas:SetImagelist(  ::oImageList )
   ::oTreeDocumentos:SetImagelist(     ::oImageList )
   ::oTreeAgenda:SetImagelist(         ::oImageList )

   // ::oTreeRecibosCompras:SetBrush( TBrush():New( ,,,"Bye" ) )

   ::Maximize()

   oMsgProgress()
   oMsgProgress():SetRange( 0, 7 )

   oMsgProgress():Deltapos( 1 )

   oMsgText( "Accesos directos" )

   ::LoadAccesos()

   oMsgProgress():Deltapos( 1 )

   oMsgText( "Documentos recientes" )

   ::LoadDocuments()

   oMsgProgress():Deltapos( 1 )

   oMsgText( "Recibos proveedor" )

   ::LoadRecibosProveedores()

   oMsgProgress():Deltapos( 1 )

   oMsgText( "Recibos clientes" )

   ::LoadRecibosClientes()

   oMsgText( "Recibos clientes" )

   oMsgProgress():Deltapos( 1 )

   oMsgText( "Notas de usuario" )

   ::LoadNotas()

   oMsgText( "Backup" )

   ::LoadBackup()

   oMsgProgress():Deltapos( 1 )

   ::oTreeAgenda:Add( "No volver a mostrar página de inicio",  21, {|| SetNotIni( Auth():Codigo() ) } )
   ::oTreeAgenda:Add( "Salir de página de inicio",             22, {|| ::End() } )

   oMsgText( "Cargando gráfico" )

   ::LoadGraph()

   oMsgProgress():Deltapos( 1 )

   EndProgress()

RETURN ( Self )

//----------------------------------------------------------------------------//

Method ClickDocuments( oTree ) CLASS TInitShell

   local oItem := oTree:GetSelected()

   do case
      case !Empty( oItem ) .and. oItem:ClassName() == "TTVITEM" .and. Valtype( oItem:bAction ) == "A"
         Eval( oItem:bAction[ 1 ], oItem:bAction[ 2 ] )
      case !Empty( oItem ) .and. oItem:ClassName() == "TTVITEM" .and. Valtype( oItem:bAction ) == "B"
         Eval( oItem:bAction )
   end case

return ( Self )

//----------------------------------------------------------------------------//

METHOD KeyDown( nKey, nFlags ) CLASS TInitShell

   if ::lOnProcess
      Return 0
   end if

return ::Super:KeyDown( nKey, nFlags )

//----------------------------------------------------------------------------//

METHOD End( lForceExit ) CLASS TInitShell

   DEFAULT lForceExit   := .f.

   if ::lOnProcess .and. !lForceExit
      Return ( .f. )
   end if

   ::oWndClient:ChildClose( Self )

   memory( -1 )

RETURN ( .t. )

//----------------------------------------------------------------------------//

METHOD Destroy() CLASS TInitShell

   if ::oTreeAccesos != nil
      ::oTreeAccesos:end()
   end if

   if ::oTreeRecibosCompras != nil
      ::oTreeRecibosCompras:end()
   end if

   if ::oTreeVentas != nil
      ::oTreeVentas:end()
   end if

   if ::oTreeAgenda != nil
      ::oTreeAgenda:end()
   end if

   if ::oTreeArticulos != nil
      ::oTreeArticulos:end()
   end if

   if ::oBtnTop != nil
      ::oBtnTop:end()
   end if

   if ::oMsgBar != nil
      ::oMsgBar:end()
   end if

   if ::oIcon != nil
      ::oIcon:end()
   end if

   if ::oCursor != nil
      ::oCursor:end()
   end if

   if ::oImageList != nil
      ::oImageList:End()
   end if

   if ::hWnd != 0
      ::Super:Destroy()
   endif

   if ::bDestroy != nil
      Eval( ::bDestroy )
   end if

return ( Self )

//----------------------------------------------------------------------------//

METHOD Maximize() CLASS TInitShell

   local oWnd  := GetWndFrame()

   ::nTop      := 0 // -4
   ::nLeft     := 0
   ::nBottom   := oWnd:oWndClient:nHeight() //+ 4
   ::nRight    := oWnd:oWndClient:nWidth()

   ::Move( ::nTop, ::nLeft, ::nRight, ::nBottom,  .t. )

return nil

//----------------------------------------------------------------------------//

Method ReSize() CLASS TInitShell

   ::oHorizontalSplitter:Adjust( .t., .t., .f., .t. )
//   ::oHorizontal1Splitter:Adjust( .t., .t., .f., .f. )    // AdjBottom()
   ::oVertical1Splitter:Adjust( .f., .t., .t., .f. )    // AdjBottom()
   ::oVertical2Splitter:Adjust( .f., .t., .f., .f. )     // AdjBottom()
   ::oHorizontal3Splitter:Adjust( .f., .t., .f., .t. )     // AdjBottom()

Return ( Self )

//----------------------------------------------------------------------------//

Method LoadNotas() CLASS TInitShell

   local dbf
   local oTree
   local oError
   local oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      USE ( cPatDat() + "AgendaUsr.dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "Notes", @dbf ) )
      SET ADSINDEX TO ( cPatDat() + "AgendaUsr.Cdx" ) ADDITIVE
      ( dbf )->( OrdSetFocus( "dFecNot" ) )

      oMsgText( "Notas" )

      /*
      Añadimos la rama principal -------------------------------------------------
      */

      oTree             := ::oTreeAgenda:Add( "Añadir nota", 19, {|| AppendNotas() } )

      if ( dbf )->( dbSeek( Auth():Codigo(), .f., .t. ) )
         while ( dbf )->cUsrNot == Auth():Codigo() .and. !( dbf )->( bof() )
            if !( dbf )->lVisNot
               oTree:Add( Dtoc( ( dbf )->dFecNot ) + Space( 1 ) + Rtrim( ( dbf )->cTexNot ), if( ( dbf )->lAlrNot, 20, 19 ), { {| x | EditNotas( x ) }, ( dbf )->( Recno() ) } )
            end if
            ( dbf )->( dbSkip( 1 ) )
         end while
      end if

      if !Empty( dbf )
         ( dbf )->( dbCloseArea() )
      end if

      oTree:Expand()

   RECOVER USING oError

      oMsgText( ErrorMessage( oError ), 'Imposible abrir las bases de notas' )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( Self )

//----------------------------------------------------------------------------//

Method LoadBackup() CLASS TInitShell

   local dbf
   local oTree
   local oError
   local oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      if file( cPatDat() + "BackUp.Dbf" )

         USE ( cPatDat() + "BackUp.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "BackUp", @dbf ) )
         SET ADSINDEX TO ( cPatDat() + "BackUp.Cdx" ) ADDITIVE
         ( dbf )->( OrdSetFocus( "dFecha" ) )
         ( dbf )->( dbGoBottom() )

         oMsgText( "Copia de seguridad" )

         /*
         Añadimos la rama principal -------------------------------------------------
         */

         oTree             := ::oTreeAgenda:Add( "Realizar nueva copia de seguridad [" + Dtoc( ( dbf )->Fecha ) + "]", 16, {|| TBackup():New( "01076", oWnd() ) } )

         if !Empty( dbf )
            ( dbf )->( dbCloseArea() )
         end if

      end if

   RECOVER USING oError

      oMsgText( ErrorMessage( oError ), 'Imposible abrir las bases copias de seguridad' )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( Self )

//----------------------------------------------------------------------------//

Method LoadAccesos() CLASS TInitShell

   local oTree

   // Añadimos la rama principal -------------------------------------------------

   oMsgText( "Accesos directos" )

   oTree    := ::oTreeAccesos:Add( "Accesos directos", 23 )

   oTree:Add( "Añadir artículo",               0, {|| AppArticulo( .t. ) }   )
   oTree:Add( "Añadir cliente",                1, {|| AppCli( .t. ) }        )
   oTree:Add( "Añadir proveedor",              2, {|| AppPrv( .t. ) }        )
   oTree:Add( "Añadir pedido de proveedor",    3, {|| AppPedPrv( nil, nil, .t. ) })
   oTree:Add( "Añadir albaran de proveedor",   4, {|| AppAlbPrv( nil, nil, .t. ) })
   oTree:Add( "Añadir factura de proveedor",   5, {|| AppFacPrv( nil, nil, .t. ) })
   oTree:Add( "Añadir presupuesto a cliente",  7, {|| AppPreCli( nil, nil, .t. ) })
   oTree:Add( "Añadir pedido a cliente",       8, {|| AppPedCli( nil, nil, .t. ) })
   oTree:Add( "Añadir albaran a cliente",      9, {|| AppAlbCli( nil, .t. ) } )
   oTree:Add( "Añadir factura a cliente",      10,{|| AppFacCli( nil, nil, .t. ) })
   oTree:Add( "Añadir anticipos a cliente",    11,{|| AppAntCli( nil, .t. ) })
   oTree:Add( "Añadir factura rectificativa",  12,{|| AppFacCli( nil, nil, .t. ) })
   oTree:Add( "Añadir ticket a cliente",       14,{|| AppTikCli( nil, nil, .t. ) })

   oTree:Expand()

Return ( Self )

//----------------------------------------------------------------------------//

Method LoadRecibosProveedores() CLASS TInitShell

   local dbf
   local dbfPrv
   local dbfDiv
   local oTree
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   local nTotRecibos    := 0
   local nTotVencidos   := 0

   BEGIN SEQUENCE

      USE ( cPatEmp() + "FacPrvP.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacPrv", @dbf ) )
      SET ADSINDEX TO ( cPatEmp() + "FacPrvP.Cdx" ) ADDITIVE
      ( dbf )->( OrdSetFocus( "lCobrado" ) )

      USE ( cPatEmp() + "Provee.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "Provee", @dbfPrv ) )
      SET ADSINDEX TO ( cPatEmp() + "Provee.Cdx" ) ADDITIVE

      USE ( cPatDat() + "Divisas.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "Divisas", @dbfDiv ) )
      SET ADSINDEX TO ( cPatDat() + "Divisas.Cdx" ) ADDITIVE

      ( dbf )->( dbGoTop() )
      while !( dbf )->( eof() )

         nTotRecibos       += nTotRecPrv( dbf, dbfDiv, cDivEmp(), .f. )

         if ( dbf )->dFecVto <= GetSysDate()
            nTotVencidos   += nTotRecPrv( dbf, dbfDiv, cDivEmp(), .f. )
         end if

         ( dbf )->( dbSkip() )

      end while

      /*
      Añadimos la rama principal -------------------------------------------------
      */

      oTree                := ::oTreeRecibosCompras:Add( "Pagos vencidos [" + Trans( nTotVencidos, ::cPirDiv ) + "]", 6 )

      ( dbf )->( dbGoTop() )
      while !( dbf )->( eof() )
         if ( dbf )->dFecVto <= GetSysDate()
            oTree:Add( ( dbf )->cSerFac + "/" + Alltrim( Str( ( dbf )->nNumFac ) ) + "/" + Rtrim( ( dbf )->cSufFac ) + "-" + Str( ( dbf )->nNumRec ) + Space( 1 ) + Rtrim( ( dbf )->cCodPrv ) + Space( 1 ) + Rtrim( RetProvee( ( dbf )->cCodPrv, dbfPrv ) ) + "[" + nTotRecPrv( dbf, dbfDiv, cDivEmp(), .t. ) + "]", 6, { {| x | EdtRecPrv( x, .t. ) }, ( dbf )->cSerFac + Str( ( dbf )->nNumFac ) + ( dbf )->cSufFac + Str( ( dbf )->nNumRec ) } )
         end if
         ( dbf )->( dbSkip() )
      end while

      oTree:Expand()

      oTree                := ::oTreeRecibosCompras:Add( "Total pagos [" + Trans( nTotRecibos, ::cPirDiv ) + "]", 6 )

      ( dbf )->( dbGoTop() )
      while !( dbf )->( eof() )
         oTree:Add( ( dbf )->cSerFac + "/" + Alltrim( Str( ( dbf )->nNumFac ) ) + "/" + Rtrim( ( dbf )->cSufFac ) + "-" + Str( ( dbf )->nNumRec ) + Space( 1 ) + Rtrim( ( dbf )->cCodPrv ) + Space( 1 ) + Rtrim( RetProvee( ( dbf )->cCodPrv, dbfPrv ) ) + "[" + nTotRecPrv( dbf, dbfDiv, cDivEmp(), .t. ) + "]", 6, { {| x | EdtRecPrv( x, .t. ) }, ( dbf )->cSerFac + Str( ( dbf )->nNumFac ) + ( dbf )->cSufFac + Str( ( dbf )->nNumRec ) } )
         ( dbf )->( dbSkip() )
      end while

      if !Empty( dbf )
         ( dbf )->( dbCloseArea() )
      end if

      if !Empty( dbfPrv )
         ( dbfPrv )->( dbCloseArea() )
      end if

      if !Empty( dbfDiv )
         ( dbfDiv )->( dbCloseArea() )
      end if

   RECOVER USING oError

      oMsgText( ErrorMessage( oError ), 'Imposible abrir las bases de datos de recibos de proveedor' )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( Self )

//----------------------------------------------------------------------------//

Method LoadDivisa() CLASS TInitShell

   local dbfDiv
   local oBlock

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      USE ( cPatDat() + "Divisas.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "Divisas", @dbfDiv ) )
      SET ADSINDEX TO ( cPatDat() + "Divisas.Cdx" ) ADDITIVE

      ::cPorDiv         := cPorDiv( cDivEmp(), dbfDiv )
      ::cPirDiv         := cPirDiv( cDivEmp(), dbfDiv )

      CLOSE ( dbfDiv )

   RECOVER

      ::cPorDiv         := "@E 999.999.999,99"
      ::cPirDiv         := "@E 999.999.999,99"

      oMsgText( "Imposible abrir todas las bases de datos de divisas" )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( Self )

//----------------------------------------------------------------------------//

Method LoadDocuments() CLASS TInitShell

   local dbf
   local oTree
   local oError
   local oBlock
   local nDocumentos 

   ::aDocuments      := {}

   ::LoadArticulos()

   ::LoadClientes()

   ::LoadProveedores()

   /*
   Cargamos los pedidos a proveedores------------------------------------------
   */

   nDocumentos       := 1
   
   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      USE ( cPatEmp() + "PedProvT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PedPrv", @dbf ) )
      SET ADSINDEX TO ( cPatEmp() + "PedProvT.Cdx" ) ADDITIVE
      ( dbf )->( OrdSetFocus( "cCodUsr" ) )

      oMsgText( "Pedidos de proveedor" )

      /*
      Añadimos la rama principal -------------------------------------------------
      */

      if ( dbf )->( dbSeek( Auth():Codigo(), .f., .t. ) )
         while ( dbf )->cCodUsr == Auth():Codigo() .and. nDocumentos <= NUMERO_DOCUMENTOS .and.!( dbf )->( bof() )
            nDocumentos ++
            aAdd( ::aDocuments, { ( dbf )->cSerPed + "/" + Alltrim( Str( ( dbf )->nNumPed ) ) + "/" + ( dbf )->cSufPed + " - " + Alltrim( ( dbf )->cCodPrv ) + " - " + Alltrim( ( dbf )->cNomPrv ), Dtos( ( dbf )->dFecChg ) + ( dbf )->cTimChg, 3, { {| x | EdtPedPrv( x, .t. ) }, ( dbf )->cSerPed + Str( ( dbf )->nNumPed ) + ( dbf )->cSufPed } } )
            ( dbf )->( dbSkip( -1 ) )
         end while
      end if

      if !Empty( dbf )
         ( dbf )->( dbCloseArea() )
      end if

   RECOVER USING oError

      oMsgText( ErrorMessage( oError ), 'Imposible abrir las bases de datos de pedidos de proveedor' )

   END SEQUENCE

   ErrorBlock( oBlock )

   /*
   Albaranes de proveedores ---------------------------------------------------
   */

   nDocumentos       := 1
   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      USE ( cPatEmp() + "AlbProvT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbPrv", @dbf ) )
      SET ADSINDEX TO ( cPatEmp() + "AlbProvT.Cdx" ) ADDITIVE
      ( dbf )->( OrdSetFocus( "cCodUsr" ) )

      oMsgText( "Albaranes de proveedor" )

      if ( dbf )->( dbSeek( Auth():Codigo(), .f., .t. ) )
         while ( dbf )->cCodUsr == Auth():Codigo() .and. nDocumentos <= NUMERO_DOCUMENTOS .and.!( dbf )->( bof() )
            nDocumentos ++
            aAdd( ::aDocuments, { ( dbf )->cSerAlb + "/" + Alltrim( Str( ( dbf )->nNumAlb ) ) + "/" + ( dbf )->cSufAlb + " - " + Alltrim( ( dbf )->cCodPrv ) + " - " + Alltrim( ( dbf )->cNomPrv ), Dtos( ( dbf )->dFecChg ) + ( dbf )->cTimChg, 4, { {| x | EdtAlbPrv( x, .t. ) }, ( dbf )->cSerAlb + Str( ( dbf )->nNumAlb ) + ( dbf )->cSufAlb } } )
            ( dbf )->( dbSkip( -1 ) )
         end while
      end if

      if !Empty( dbf )
         ( dbf )->( dbCloseArea() )
      end if

   RECOVER USING oError

      oMsgText( ErrorMessage( oError ), 'Imposible abrir las bases de datos de albaranes de proveedor' )

   END SEQUENCE

   ErrorBlock( oBlock )

   /*
   Facturas de proveedores-----------------------------------------------------
   */

   nDocumentos       := 1
   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      USE ( cPatEmp() + "FacPrvT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacPrv", @dbf ) )
      SET ADSINDEX TO ( cPatEmp() + "FacPrvT.Cdx" ) ADDITIVE
      ( dbf )->( OrdSetFocus( "cCodUsr" ) )

      oMsgText( "Facturas de proveedor" )

      if ( dbf )->( dbSeek( Auth():Codigo(), .f., .t. ) )
         while ( dbf )->cCodUsr == Auth():Codigo() .and. nDocumentos <= NUMERO_DOCUMENTOS .and.!( dbf )->( bof() )
            nDocumentos ++
            aAdd( ::aDocuments, { ( dbf )->cSerFac + "/" + Alltrim( Str( ( dbf )->nNumFac ) ) + "/" + ( dbf )->cSufFac + " - " + Alltrim( ( dbf )->cCodPrv ) + " - " + Alltrim( ( dbf )->cNomPrv ), Dtos( ( dbf )->dFecChg ) + ( dbf )->cTimChg, 5, { {| x | EdtFacPrv( x, .t. ) }, ( dbf )->cSerFac + Str( ( dbf )->nNumFac ) + ( dbf )->cSufFac } } )
            ( dbf )->( dbSkip( -1 ) )
         end while
      end if

      if !Empty( dbf )
         ( dbf )->( dbCloseArea() )
      end if

   RECOVER USING oError

      oMsgText( ErrorMessage( oError ), 'Imposible abrir las bases de datos de facturas de proveedor' )

   END SEQUENCE

   ErrorBlock( oBlock )

   /*
   Presupuestos a clientes-----------------------------------------------------
   */

   nDocumentos       := 1
   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      USE ( cPatEmp() + "PreCliT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PreCli", @dbf ) )
      SET ADSINDEX TO ( cPatEmp() + "PreCliT.Cdx" ) ADDITIVE
      ( dbf )->( OrdSetFocus( "cCodUsr" ) )

      oMsgText( "Presupuestos a clientes" )

      if ( dbf )->( dbSeek( Auth():Codigo(), .f., .t. ) )
         while ( dbf )->cCodUsr == Auth():Codigo() .and. nDocumentos <= NUMERO_DOCUMENTOS .and.!( dbf )->( bof() )
            nDocumentos ++
            aAdd( ::aDocuments, { ( dbf )->cSerPre + "/" + Alltrim( Str( ( dbf )->nNumPre ) ) + "/" + ( dbf )->cSufPre + " - " + Alltrim( ( dbf )->cCodCli ) + " - " + Alltrim( ( dbf )->cNomCli ), Dtos( ( dbf )->dFecCre ) + ( dbf )->cTimCre, 7, { {| x | EdtPreCli( x, .t. ) }, ( dbf )->cSerPre + Str( ( dbf )->nNumPre ) + ( dbf )->cSufPre } } )
            ( dbf )->( dbSkip( -1 ) )
         end while
      end if

      if !Empty( dbf )
         ( dbf )->( dbCloseArea() )
      end if

   RECOVER USING oError

      oMsgText( ErrorMessage( oError ), 'Imposible abrir las bases de datos de presupuestos a clientes' )

   END SEQUENCE

   ErrorBlock( oBlock )

   /*
   Pedidos a clientes----------------------------------------------------------
   */

   nDocumentos       := 1
   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      USE ( cPatEmp() + "PedCliT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PedCli", @dbf ) )
      SET ADSINDEX TO ( cPatEmp() + "PedCliT.Cdx" ) ADDITIVE
      ( dbf )->( OrdSetFocus( "cCodUsr" ) )

      oMsgText( "Pedido a clientes" )

      if ( dbf )->( dbSeek( Auth():Codigo(), .f., .t. ) )
         while ( dbf )->cCodUsr == Auth():Codigo() .and. nDocumentos <= NUMERO_DOCUMENTOS .and.!( dbf )->( bof() )
            nDocumentos ++
            aAdd( ::aDocuments, { ( dbf )->cSerPed + "/" + Alltrim( Str( ( dbf )->nNumPed ) ) + "/" + ( dbf )->cSufPed + " - " + Alltrim( ( dbf )->cCodCli ) + " - " + Alltrim( ( dbf )->cNomCli ), Dtos( ( dbf )->dFecCre ) + ( dbf )->cTimCre, 8, { {| x | EdtPedCli( x, .t. ) }, ( dbf )->cSerPed + Str( ( dbf )->nNumPed ) + ( dbf )->cSufPed } } )
            ( dbf )->( dbSkip( -1 ) )
         end while
      end if

      if !Empty( dbf )
         ( dbf )->( dbCloseArea() )
      end if

   RECOVER USING oError

      oMsgText( ErrorMessage( oError ), 'Imposible abrir las bases de datos de pedidos a clientes' )

   END SEQUENCE

   ErrorBlock( oBlock )

   /*
   Albaranes a clientes--------------------------------------------------------
   */

   nDocumentos       := 1
   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      USE ( cPatEmp() + "AlbCliT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbCli", @dbf ) )
      SET ADSINDEX TO ( cPatEmp() + "AlbCliT.Cdx" ) ADDITIVE
      ( dbf )->( OrdSetFocus( "cCodUsr" ) )

      oMsgText( "Albaranes a clientes" )

      /*
      Añadimos la rama principal -------------------------------------------------
      */

      if ( dbf )->( dbSeek( Auth():Codigo(), .f., .t. ) )
         while ( dbf )->cCodUsr == Auth():Codigo() .and. nDocumentos <= NUMERO_DOCUMENTOS .and.!( dbf )->( bof() )
            nDocumentos ++
            aAdd( ::aDocuments, { ( dbf )->cSerAlb + "/" + Alltrim( Str( ( dbf )->nNumAlb ) ) + "/" + ( dbf )->cSufAlb + " - " + Alltrim( ( dbf )->cCodCli ) + " - " + Alltrim( ( dbf )->cNomCli ), Dtos( ( dbf )->dFecCre ) + ( dbf )->cTimCre, 9, { {| x | EdtAlbCli( x, .t. ) }, ( dbf )->cSerAlb + Str( ( dbf )->nNumAlb ) + ( dbf )->cSufAlb } } )
            ( dbf )->( dbSkip( -1 ) )
         end while
      end if

      if !Empty( dbf )
         ( dbf )->( dbCloseArea() )
      end if

   RECOVER USING oError

      oMsgText( ErrorMessage( oError ), 'Imposible abrir las bases de datos de albaranes a clientes' )

   END SEQUENCE

   ErrorBlock( oBlock )

   /*
   Facturas a clientes---------------------------------------------------------
   */

   nDocumentos       := 1
   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      TDataCenter():OpenFacCliT( @dbf )
      
      ( dbf )->( OrdSetFocus( "cCodUsr" ) )

      oMsgText( "Facturas a clientes" )

      if ( dbf )->( dbSeek( Auth():Codigo(), .f., .t. ) )
         while ( dbf )->cCodUsr == Auth():Codigo() .and. nDocumentos <= NUMERO_DOCUMENTOS .and. !( dbf )->( bof() )
            nDocumentos ++
            aAdd( ::aDocuments, { ( dbf )->cSerie + "/" + Alltrim( Str( ( dbf )->nNumFac ) ) + "/" + ( dbf )->cSufFac + " - " + Alltrim( ( dbf )->cCodCli ) + " - " + Alltrim( ( dbf )->cNomCli ), Dtos( ( dbf )->dFecCre ) + ( dbf )->cTimCre, 10, { {| x | EdtFacCli( x, .t. ) }, ( dbf )->cSerie + Str( ( dbf )->nNumFac ) + ( dbf )->cSufFac } } )
            ( dbf )->( dbSkip( -1 ) )
         end while
      end if

      if !Empty( dbf )
         ( dbf )->( dbCloseArea() )
      end if

   RECOVER USING oError

      oMsgText( ErrorMessage( oError ), 'Imposible abrir las bases de datos de facturas a clientes' )

   END SEQUENCE

   ErrorBlock( oBlock )

   /*
   Anticipos a clientes---------------------------------------------------------
   */

   nDocumentos       := 1
   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      USE ( cPatEmp() + "AntCliT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AntCliT", @dbf ) )
      SET ADSINDEX TO ( cPatEmp() + "AntCliT.Cdx" ) ADDITIVE
      ( dbf )->( OrdSetFocus( "cCodUsr" ) )

      oMsgText( "Anticipos a clientes" )

      if ( dbf )->( dbSeek( Auth():Codigo(), .f., .t. ) )
         while ( dbf )->cCodUsr == Auth():Codigo() .and. nDocumentos <= NUMERO_DOCUMENTOS .and. !( dbf )->( bof() )
            nDocumentos ++
            aAdd( ::aDocuments, { ( dbf )->cSerAnt + "/" + Alltrim( Str( ( dbf )->nNumAnt ) ) + "/" + ( dbf )->cSufAnt + " - " + Alltrim( ( dbf )->cCodCli ) + " - " + Alltrim( ( dbf )->cNomCli ), Dtos( ( dbf )->dFecCre ) + ( dbf )->cTimCre, 11, { {| x | EdtAntCli( x, .t. ) }, ( dbf )->cSerAnt + Str( ( dbf )->nNumAnt ) + ( dbf )->cSufAnt } } )
            ( dbf )->( dbSkip( -1 ) )
         end while
      end if

      if !Empty( dbf )
         ( dbf )->( dbCloseArea() )
      end if

   RECOVER USING oError

      oMsgText( ErrorMessage( oError ), 'Imposible abrir las bases de datos de anticipos a clientes' )

   END SEQUENCE

   ErrorBlock( oBlock )

   /*
   Rectificativas a clientes---------------------------------------------------
   */

   nDocumentos       := 1
   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      USE ( cPatEmp() + "FacRecT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacRecT", @dbf ) )
      SET ADSINDEX TO ( cPatEmp() + "FacRecT.Cdx" ) ADDITIVE
      ( dbf )->( OrdSetFocus( "cCodUsr" ) )

      oMsgText( "Rectificativas a clientes" )

      if ( dbf )->( dbSeek( Auth():Codigo(), .f., .t. ) )
         while ( dbf )->cCodUsr == Auth():Codigo() .and. nDocumentos <= NUMERO_DOCUMENTOS .and. !( dbf )->( bof() )
            nDocumentos ++
            aAdd( ::aDocuments, { ( dbf )->cSerie + "/" + Alltrim( Str( ( dbf )->nNumFac ) ) + "/" + ( dbf )->cSufFac + " - " + Alltrim( ( dbf )->cCodCli ) + " - " + Alltrim( ( dbf )->cNomCli ), Dtos( ( dbf )->dFecCre ) + ( dbf )->cTimCre, 12, { {| x | EdtFacRec( x, .t. ) }, ( dbf )->cSerie + Str( ( dbf )->nNumFac ) + ( dbf )->cSufFac } } )
            ( dbf )->( dbSkip( -1 ) )
         end while
      end if

      if !Empty( dbf )
         ( dbf )->( dbCloseArea() )
      end if

   RECOVER USING oError

      oMsgText( ErrorMessage( oError ), 'Imposible abrir las bases de datos de facturas rectificativas' )

   END SEQUENCE

   ErrorBlock( oBlock )

   /*
   Tickets a clientes----------------------------------------------------------
   */

   nDocumentos       := 1
   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      USE ( cPatEmp() + "Tiket.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "Tiket", @dbf ) )
      SET ADSINDEX TO ( cPatEmp() + "Tiket.Cdx" ) ADDITIVE
      ( dbf )->( OrdSetFocus( "cCodUsr" ) )

      oMsgText( "Rectificativas a clientes" )

      if ( dbf )->( dbSeek( Auth():Codigo(), .f., .t. ) )
         while ( dbf )->cCcjTik == Auth():Codigo() .and. nDocumentos <= NUMERO_DOCUMENTOS .and. !( dbf )->( bof() )
            nDocumentos ++
            aAdd( ::aDocuments, { ( dbf )->cSerTik + "/" + AllTrim( ( dbf )->cNumTik ) + "/" + ( dbf )->cSufTik + " - " + Alltrim( ( dbf )->cCliTik ) + " - " + Alltrim( ( dbf )->cNomTik ), Dtos( ( dbf )->dFecCre ) + ( dbf )->cTimCre, 14, { {| x | EdtTikCli( x, .t. ) }, ( dbf )->cSerTik + ( dbf )->cNumTik + ( dbf )->cSufTik } } )
            ( dbf )->( dbSkip( -1 ) )
         end while
      end if

      if !Empty( dbf )
         ( dbf )->( dbCloseArea() )
      end if

   RECOVER USING oError

      oMsgText( ErrorMessage( oError ), 'Imposible abrir las bases de datos de facturas rectificativas' )

   END SEQUENCE

   ErrorBlock( oBlock )

   /*
   Ordenamos el array con los documentos---------------------------------------
   */

   if !Empty( ::aDocuments )

      aSort( ::aDocuments, , , {|x,y| x[2] > y[2] } )

      oTree    := ::oTreeDocumentos:Add( "Documentos recientes", 24 )

      aEval( ::aDocuments, {|a| oTree:Add( a[1], a[3], a[4]  ) } )

      oTree:Expand()

   end if

Return ( Self )

//----------------------------------------------------------------------------//

Method LoadRecibosClientes() CLASS TInitShell

   local dbf
   local dbfCli
   local dbfDiv
   local oTree
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   local nTotRecibos    := 0
   local nTotVencidos   := 0

   BEGIN SEQUENCE

      USE ( cPatEmp() + "FacCliP.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacCli", @dbf ) )
      SET ADSINDEX TO ( cPatEmp() + "FacCliP.Cdx" ) ADDITIVE
      ( dbf )->( OrdSetFocus( "fNumFac" ) )

      USE ( cPatEmp() + "CLIENT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "Client", @dbfCli ) )
      SET ADSINDEX TO ( cPatEmp() + "CLIENT.CDX" ) ADDITIVE

      USE ( cPatDat() + "Divisas.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "Divisas", @dbfDiv ) )
      SET ADSINDEX TO ( cPatDat() + "Divisas.Cdx" ) ADDITIVE

      ( dbf )->( dbGoTop() )
      while !( dbf )->( eof() )

         nTotRecibos       += nTotRecCli( dbf, dbfDiv, cDivEmp(), .f. )

         if !( dbf )->lCobrado .and. ( dbf )->dFecVto <= GetSysDate()
            nTotVencidos   += nTotRecCli( dbf, dbfDiv, cDivEmp(), .f. )
         end if

         ( dbf )->( dbSkip() )

      end while

      oMsgText( "Recibos de clientes" )

      /*
      Añadimos la rama principal -------------------------------------------------
      */

      oTree                := ::oTreeRecibosVentas:Add( "Cobros a clientes vencidos [" + Trans( nTotVencidos, ::cPorDiv ) + "]", 13 )

      ( dbf )->( dbGoTop() )
      while !( dbf )->( eof() )
         if !( dbf )->lCobrado .and. ( dbf )->dFecVto <= GetSysDate()
            oTree:Add( ( dbf )->cSerie + "/" + Alltrim( Str( ( dbf )->nNumFac ) ) + "/" + Rtrim( ( dbf )->cSufFac ) + "-" + Str( ( dbf )->nNumRec ) + Space( 1 ) + Rtrim( ( dbf )->cCodCli ) + Space( 1 ) + Rtrim( RetClient( ( dbf )->cCodCli, dbfCli ) ) + "[" + nTotRecCli( dbf, dbfDiv, cDivEmp(), .t. ) + "]", 13, { {| x | EdtRecCli( x, .t. ) }, ( dbf )->cSerie + Str( ( dbf )->nNumFac ) + ( dbf )->cSufFac + Str( ( dbf )->nNumRec ) } )
         end if
         ( dbf )->( dbSkip() )
      end while

      oTree:Expand()

      oTree                := ::oTreeRecibosVentas:Add( "Total cobros a clientes [" + Trans( nTotRecibos, ::cPorDiv ) + "]", 13 )

      /*( dbf )->( dbGoTop() )
      while !( dbf )->( eof() )
         oTree:Add( ( dbf )->cSerie + "/" + Alltrim( Str( ( dbf )->nNumFac ) ) + "/" + Rtrim( ( dbf )->cSufFac ) + "-" + Str( ( dbf )->nNumRec ) + Space( 1 ) + Rtrim( ( dbf )->cCodCli ) + Space( 1 ) + Rtrim( RetClient( ( dbf )->cCodCli, dbfCli ) ) + "[" + nTotRecCli( dbf, dbfDiv, cDivEmp(), .t. ) + "]", 13, { {| x | EdtRecCli( x, .t. ) }, ( dbf )->cSerie + Str( ( dbf )->nNumFac ) + ( dbf )->cSufFac + Str( ( dbf )->nNumRec ) } )
         ( dbf )->( dbSkip() )
      end while*/

      if !Empty( dbf )
         ( dbf )->( dbCloseArea() )
      end if

      if !Empty( dbfCli )
         ( dbfCli )->( dbCloseArea() )
      end if

      if !Empty( dbfDiv )
         ( dbfDiv )->( dbCloseArea() )
      end if

   RECOVER USING oError

      oMsgText( ErrorMessage( oError ), 'Imposible abrir las bases de datos de recibos de clientes' )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( Self )

//----------------------------------------------------------------------------//

Method LoadGraph() CLASS TInitShell

   local aVta        := aTotVentasCliente( nil, Year( GetSysDate() ), .f. )

   ::oGraph:AddSerie( { aVta[ 1, 3 ], aVta[ 2, 3 ], aVta[ 3, 3 ], aVta[ 4, 3 ], aVta[ 5, 3 ], aVta[ 6, 3 ], aVta[ 7, 3 ], aVta[ 8, 3 ], aVta[ 9, 3 ], aVta[ 10, 3 ], aVta[ 11, 3 ], aVta[ 12, 3 ] }, "", Rgb( 255, 171, 63 ) )
   ::oGraph:SetYVals( { 'E', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D' } )

Return ( Self )

//----------------------------------------------------------------------------//

Method LoadArticulos() CLASS TInitShell

   local dbf
   local oError
   local oBlock
   local nDocumentos := 1

   oMsgText( "Artículos recientes" )

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      USE ( cPatEmp() + "Articulo.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "Articulo", @dbf ) )
      SET ADSINDEX TO ( cPatEmp() + "Articulo.Cdx" ) ADDITIVE
      ( dbf )->( OrdSetFocus( "cCodUsr" ) )

      if ( dbf )->( dbSeek( Auth():Codigo(), .f., .t. ) )
         while ( dbf )->cCodUsr == Auth():Codigo() .and. nDocumentos <= NUMERO_DOCUMENTOS .and.!( dbf )->( bof() )
            nDocumentos ++
            aAdd( ::aDocuments, { Alltrim( ( dbf )->Codigo ) + " - " + Alltrim( ( dbf )->Nombre ), Dtos( ( dbf )->dFecChg ) + ( dbf )->cTimChg, 0, { {| x | EdtArticulo( x, .t. ) }, ( dbf )->Codigo } } )
            ( dbf )->( dbSkip( -1 ) )
         end while
      end if

      if !Empty( dbf )
         ( dbf )->( dbCloseArea() )
      end if

   RECOVER USING oError

      oMsgText( 'Imposible abrir las bases de datos de artículos' )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( Self )

//---------------------------------------------------------------------------//

Method LoadClientes() CLASS TInitShell

   local dbf
   local oError
   local oBlock
   local nDocumentos := 1

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      USE ( cPatEmp() + "CLIENT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "Client", @dbf ) )
      SET ADSINDEX TO ( cPatEmp() + "CLIENT.CDX" ) ADDITIVE
      ( dbf )->( OrdSetFocus( "cCodUsr" ) )

      oMsgText( "Clientes recientes" )

      if ( dbf )->( dbSeek( Auth():Codigo(), .f., .t. ) )
         while ( dbf )->cCodUsr == Auth():Codigo() .and. nDocumentos <= NUMERO_DOCUMENTOS .and.!( dbf )->( bof() )
            nDocumentos ++
            aAdd( ::aDocuments, { Alltrim( ( dbf )->Cod ) + " - " + Alltrim( ( dbf )->Titulo ), Dtos( ( dbf )->dFecChg ) + ( dbf )->cTimChg, 1, { {| x | EdtCli( x, .t. ) }, ( dbf )->Cod } } )
            ( dbf )->( dbSkip( -1 ) )
         end while
      end if

      if !Empty( dbf )
         ( dbf )->( dbCloseArea() )
      end if

   RECOVER USING oError

      oMsgText( 'Imposible abrir las bases de datos de clientes' )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( Self )

//---------------------------------------------------------------------------//

Method LoadProveedores() CLASS TInitShell

   local dbf
   local oError
   local oBlock
   local nDocumentos := 1

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      USE ( cPatEmp() + "Provee.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "Provee", @dbf ) )
      SET ADSINDEX TO ( cPatEmp() + "Provee.Cdx" ) ADDITIVE
      ( dbf )->( OrdSetFocus( "cCodUsr" ) )

      oMsgText( "Proveedor recientes" )

      if ( dbf )->( dbSeek( Auth():Codigo(), .f., .t. ) )
         while ( dbf )->cCodUsr == Auth():Codigo() .and. nDocumentos <= NUMERO_DOCUMENTOS .and.!( dbf )->( bof() )
            nDocumentos ++
            aAdd( ::aDocuments, { Alltrim( ( dbf )->Cod ) + " - " + Alltrim( ( dbf )->Titulo ), Dtos( ( dbf )->dFecChg ) + ( dbf )->cTimChg, 2, { {| x | EdtPrv( x, .t. ) }, ( dbf )->Cod } } )
            ( dbf )->( dbSkip( -1 ) )
         end while
      end if

      if !Empty( dbf )
         ( dbf )->( dbCloseArea() )
      end if

   RECOVER USING oError

      oMsgText( 'Imposible abrir las bases de datos de proveedores' )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( Self )

//---------------------------------------------------------------------------//

FUNCTION TranspColor( oWnd, nRGB )

   DEFAULT nRGB   := Rgb( 0, 0, 0 )

   SetWindowLong( oWnd:hWnd, GWL_EXSTYLE, WS_BORDER )
   SetWindowLong( oWnd:hWnd, GWL_EXSTYLE, WS_EX_LAYERED )
   SetLayeredWindowAttributes( oWnd:hWnd, nRgb, 125, LWA_ALPHA )

RETURN NIL