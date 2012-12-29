#include "FiveWin.Ch"
#include "Factu.Ch"
#include "Constant.ch"
#include "MesDbf.ch"

#define SC_MAXIMIZE           61488    // 0xF030

#define CLR_BOTON             Rgb( 0, 0, 0 ) //Rgb( 255, 154, 49 ) Rgb( 255, 255, 255 )    //  //

#define WM_ERASEBKGND         20       // 0x14
#define WM_CHILDACTIVATE      34       // 0x22
#define WM_ICONERASEBKGND     39       // 0x27

//------------------------------------------------------------------------//

CLASS TShell FROM TMdiChild

   DATA  oBrw
   DATA  oBtnBar
   DATA  oBtnTop
   DATA  oMsgBar
   DATA  oTabs
   DATA  oCombobox
   DATA  cCombobox
   DATA  oFont
   DATA  oIcon
   DATA  xAlias
   DATA  nArea
   DATA  cTitle
   DATA  cWinName
   DATA  aPrompt
   DATA  aFastKey
   DATA  aFlds       AS ARRAY    INIT {}
   DATA  aHeaders    AS ARRAY    INIT {}
   DATA  aColSizes   AS ARRAY    INIT {}
   DATA  aColSelect  AS ARRAY    INIT {}
   DATA  aColPos     AS ARRAY    INIT {}
   DATA  aJustify    AS ARRAY    INIT {}
   DATA  nLevel
   DATA  lCenter
   DATA  nSizeBtn
   DATA  aKey        AS ARRAY    INIT {}
   DATA  oTxtSea
   DATA  aLstSea     AS ARRAY    INIT {}
   DATA  oDbfUsr
   DATA  oDbfCol
   DATA  nRecno
   DATA  nTab        AS NUMERIC  INIT 1
   DATA  lMin
   DATA  lZoom
   DATA  lNoSave     AS LOGIC    INIT .f.
   DATA  aOriginal   AS ARRAY    INIT {}
   DATA  lBmpMenu    AS LOGIC    INIT .f.
   DATA  lAutoSeek   AS LOGIC    INIT .f.
   DATA  bExpFilter
   DATA  aRecFilter  AS ARRAY
   DATA  lBigStyle   AS LOGIC    INIT .f.
   DATA  lDrag       AS LOGIC
   DATA  lAutoPos    AS LOGIC    INIT .t.
   DATA  nFlds
   DATA  cHtmlHelp
   DATA  aGoTo

   METHOD New( nTop, nLeft, nBottom, nRight, cTitle, oMenu, oWnd, oIcon,;
               oCursor, lPixel, nHelpId, aFlds, xAlias, aHeaders,;
               aColSizes, aColSelect, aJustify, aPrompt, bAdd, bEdit, bDel, bDup,;
               nSizeBtn, nLevel, cMru, cInifile  ) CONSTRUCTOR

   METHOD Create() INLINE ( Self )

   METHOD Activate( cShow, bLClicked, bRClicked, bMoved, bResized, bPainted,;
                    bKeyDown, bInit, bUp, bDown, bPgUp, bPgDn,;
                    bLeft, bRight, bPgLeft, bPgRight, bValid, bDropFiles,;
                    bLButtonUp )

   /*
   METHOD Paint()
   */

	METHOD GotFocus()

	METHOD KeyChar( nKey, nFlags )

   METHOD RecAdd()
   METHOD RecEdit()
   METHOD RecDup()
   METHOD RecZoom()
   METHOD RecDel()

	METHOD CtrlKey( nKey )

   METHOD KeyDown( nKey, nFlags )

   METHOD NewAt(  cResName1, cResName2, cBmpFile1, cBmpFile2, cMsg, bAction,;
                  lGroup, lAdjust, bWhen, cToolTip, lPressed, bDrop, cAction,;
                  cPrompt, oFont, lNoBorder, bMenu, cKey, lMru, lSeaMru, lOpened )

	METHOD Search()

   METHOD AddSearch()

   METHOD ChangeSeek( oIndice )

   METHOD ChgIndex( oGet, oIndice )

   METHOD FastSeek( nKey, nFlags, oGet, oIndice )

	METHOD lCloseArea	INLINE ( ::oBrw:lCloseArea() )

   METHOD Refresh()  INLINE ( ::oBrw:Refresh(), ::oBrw:SetFocus() )
   METHOD UpStable() INLINE ( ::oBrw:UpStable(), ::oBrw:SetFocus() )

   METHOD SetFocus() INLINE ( ::oBrw:SetFocus() )

   METHOD SetIndex( nIndex )

   METHOD RButtonDown( nRow, nCol, nFlags )

   METHOD AddMru()

   METHOD SaveOriginal()

   METHOD PutOriginal()

   METHOD SelColumn( nRow, nCol )

   METHOD SetColumn()

   METHOD DlgColumn()

   METHOD ActColSizes()

   METHOD UpColumn( nPos )

   METHOD DwColumn( nPos )

   METHOD AutoButtons( oParent )

   METHOD GralButtons( oParent )

   METHOD EndButtons( oParent )

   METHOD AutoItems()

   /*
   METHOD Filter( aBase )

   METHOD BrwFilter( aBase, oBrwFilter )
   */

   METHOD End()

   METHOD Destroy()

   METHOD Maximize()

   METHOD SysCommand( nWParam, nLParam )

   METHOD Display() INLINE ::BeginPaint(), ::Paint(), ::EndPaint()

   METHOD ChgTabs()

   METHOD ChgCombo( nTab )

   METHOD AddSeaBar()

   METHOD NextTabOption()

   METHOD PrevTabOption()

   METHOD lPressCol()

   METHOD OpenData()

   METHOD CloseData()

   METHOD HelpTopic()

   METHOD AddGoTo( cCaption, bAction )

   Method SearchSetFocus()             INLINE ( if( oWndBar() != nil, oWndBar():SetGetFocus(), ::oTxtSea:SetFocus() ) )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New(  nTop, nLeft, nBottom, nRight, cTitle, oMenu, oWnd, oIcon,;
             oCursor, lPixel, nHelpId, aFlds, xAlias, aHeaders,;
             aColSizes, aColSelect, aJustify, aPrompt, bAdd, bEdit, bDel,;
             bDup, nSizeBtn, nLevel, cMru, cInifile, lBigStyle, bZoo ) CLASS TShell

   local n
   local nPos
   local aRect
   local bLine
   local aTmpFld
   local aTmpHea
   local aTmpJus

   DEFAULT nTop      := 0
   DEFAULT nLeft     := 0
   DEFAULT nBottom   := 22
   DEFAULT nRight    := 80
   DEFAULT cTitle    := "MDI Child"
   DEFAULT oWnd      := GetWndFrame()
   DEFAULT lPixel    := .f.
   DEFAULT oIcon     := TIcon():New( ,, "BROWSE",, )
   DEFAULT oCursor   := TCursor():New( , "ARROW" )
   DEFAULT aPrompt   := { "General" }
   DEFAULT nSizeBtn  := 42
   DEFAULT nLevel    := nOr( ACC_APPD, ACC_EDIT, ACC_ZOOM, ACC_DELE, ACC_IMPR )
   DEFAULT aFlds     := {}
   DEFAULT aHeaders  := {}
   DEFAULT aColSizes := {}
   DEFAULT aColSelect:= {}
   DEFAULT aJustify  := {}
   DEFAULT lBigStyle := .f.

   //Adaptamos la longitud de pantalla a la resolución

   aRect := GetWndRect( GetDeskTopWindow() )
   if aRect[4] >= 800
      nBottom        += 6
      nRight         += 20
   endif

   ::nTop            := nTop
   ::nLeft           := nLeft
   ::nBottom         := nBottom
   ::nRight          := nRight
   ::cTitle          := cTitle
	::aFastKey			:= {}
   ::aPrompt         := aPrompt
   ::oIcon           := oIcon
   ::nSizeBtn        := nSizeBtn
   ::aKey            := {}
   ::aFlds           := aFlds
   ::aHeaders        := aHeaders
   ::aColSizes       := aColSizes
   ::aColSelect      := aColSelect
   ::aJustify        := aJustify
   ::lBigStyle       := lBigStyle

   /*
   Fuentes en funcion del estilo
   */

   if ::lBigStyle
      ::oFont        := TFont():New( "Ms Sans Serif", 6, 18, .f. )
   else
      ::oFont        := TFont():New( "Ms Sans Serif", 6, 12, .f. )
   end if

   ::xAlias          := xAlias

   do case
   case Valtype( xAlias ) == "O"
      ::nArea        := xAlias:nArea
   case ValType( xAlias ) == "C"
      ::nArea        := xAlias
   end case

   /*
   Tamaño de la ventana siempre a pixels---------------------------------------
   */

   ::nTop            := nTop    * if( !lPixel, MDIC_CHARPIX_H, 1 )
   ::nLeft           := nLeft   * if( !lPixel, MDIC_CHARPIX_W, 1 )
   ::nBottom         := nBottom * if( !lPixel, MDIC_CHARPIX_H, 1 )
   ::nRight          := nRight  * if( !lPixel, MDIC_CHARPIX_W, 1 )

   ::nFlds           := len( aFlds )

   /*
   Todos deben de ser de la misma longuitud------------------------------------
   */

   if len( ::aColSelect ) < ::nFlds
      aSize( ::aColSelect, ::nFlds )
      aEval( ::aColSelect, {| x, n | if( x == nil, ::aColSelect[n] := .t., ) } )
   end if

   if len( ::aHeaders ) < ::nFlds
      aSize( ::aHeaders, ::nFlds )
      aEval( ::aHeaders, {| x, n | if( x == nil, ::aHeaders[n] := "", ) } )
   end if

   if len( ::aJustify ) < ::nFlds
      aSize( ::aJustify, ::nFlds )
      aEval( ::aJustify, {| x, n | if( x == nil, ::aJustify[n] := .f., ) } )
   end if

   if len( ::aColSizes ) < ::nFlds
      aSize( ::aColSizes, ::nFlds )
      aEval( ::aColSizes, {| x, n | if( x == nil, ::aColSizes[n] := 0, ) } )
   end if

   for n := 1 to ::nFlds
      if ::aColSizes[ n ] == 0
         ::aColSizes[ n ] := if( ValType( Eval( aFlds[ n ] ) ) != "C", 15, GetTextWidth( 0, Replicate( "B", Max( Len( aHeaders[ n ] ), Len( Eval( aFlds[ n ] ) ) + 1 ) ) ) )
      elseif ::aColSizes[ n ] == -1
         ::aColSizes[ n ]:= 0
      end if
   next

   ::aColPos         := Array( ::nFlds )

   aEval( ::aColPos, {| x, n | ::aColPos[n] := n } )

   /*
   Guadamos la situación original----------------------------------------------
   */

   ::SaveOriginal()

   /*
   Creamos el objeto ini-------------------------------------------------------
   */

   ::OpenData()

   /*
   Ultimo registro activo------------------------------------------------------
   */

   if at( ":", ::cTitle ) != 0
      ::cWinName     := Padr( SubStr( ::cTitle, 1, at( ":", ::cTitle ) ), 30 )
   else
      ::cWinName     := Padr( Rtrim( ::cTitle ), 30 )
   end if

   if ::oDbfUsr:Seek( cCurUsr() + ::cWinName )
      ::nRecNo       := ::oDbfUsr:nRecCfg
      ::nTab         := ::oDbfUsr:nTabCfg
   else
      ::nRecNo       := 1
      ::nTab         := 1
   end if

   /*
   Fin de la captura del error-------------------------------------------------
   */

   ::lAutoSeek       := .f. //::oDbfUsr:Get( ::cTitle, "ISAUTOSEEK", .t. )

   /*
   Llamada al objeto padre para que se cree------------------------------------
   */

   Super:New( 0, 0, 0, 0, cTitle, 0, oMenu, oWnd, oIcon, , , , oCursor, , .t., , nHelpId, "NONE", .f., .f., .f., .f. )

   /*
   Vamos a obtener el orden de las columnas -----------------------------------
   */

   for n := 1 to ::nFlds
      if ::oDbfCol:Seek( cCurUsr() + ::cWinName + Str( n, 2 ) ) .and. n <= len( ::aColPos )
         ::aColPos[ n ]    := ::oDbfCol:nPosCol
         ::aColSelect[ n ] := ::oDbfCol:lSelCol
         ::aColSizes[ n ]  := ::oDbfCol:nSizCol
         ::aJustify[ n ]   := ::oDbfCol:lJusCol
      end if
   next

   aTmpFld              := Array( ::nFlds )
   aTmpHea              := Array( ::nFlds )
   aTmpJus              := Array( ::nFlds )

   for n := 1 to ::nFlds
      nPos              := ::aColPos[ n ]
      if nPos > 0 .and. nPos <= len( ::aFlds )
         aTmpFld[ n ]   := ::aFlds[ nPos ]
         aTmpHea[ n ]   := ::aHeaders[ nPos ]
         aTmpJus[ n ]   := ::aJustify[ nPos ]
      end if
   next

   ::aFlds              := aTmpFld
   ::aHeaders           := aTmpHea
   ::aJustify           := aTmpJus

   /*
   Ya tenemos los datos para montar la linea-----------------------------------
   */

   bLine                := {|| _aFld( ::aFlds, ::aColSelect ) }

   /*
   Anchos automaticos----------------------------------------------------------
   */

   aColSizes            := _aColSize( ::aColSizes, ::aColSelect )

   /*
   Cabeceras segun las columnas seleccionadas----------------------------------
   */

   aHeaders             := _aColHead( ::aHeaders, ::aColSelect )

   /*
   Justificaciones segun las columnas seleccionadas----------------------------
   */

   aJustify             := _aColJustify( ::aJustify, ::aColSelect )

   /*
   Panel-----------------------------------------------------------------------
   */

   ::oClient            := TPanel():New( , , , , Self )

   /*
   Barra de botones------------------------------------------------------------
   */

   if file( 'WebTop.bmp' )

   @ 0, 0   WEBBAR      ::oBtnTop ;
            SIZE        400, 40 ;
            CTLHEIGHT   20 ;
            FONT        ( TFont():New( "Verdana", 0, -22, .f., .t. ) );
            COLOR       Rgb( 255, 255, 255 );
            BITMAP      "WebTop.Bmp" ;
            OF          Self

   else

   @ 0, 0   WEBBAR      ::oBtnTop ;
            SIZE        400, 40 ;
            CTLHEIGHT   20 ;
            FONT        ( TFont():New( "Verdana", 0, -22, .f., .t. ) );
            COLOR       Rgb( 255, 255, 255 );
            RESOURCE    "WebTop" ;
            OF          Self

   end if

   ::oBtnTop:Say( 6, 144, ::cTitle )
   ::oTop               := ::oBtnTop

   if file( 'WebLeft.bmp' )

   @ 0, 0   WEBBAR      ::oBtnBar ;
            SIZE        144, 400 ;
            CTLHEIGHT   if( ::lBigStyle, 36, 20 ) ;
            BITMAP      "WebLeft.Bmp" ;
            OF          Self

   else

   @ 0, 0   WEBBAR      ::oBtnBar ;
            SIZE        144, 400 ;
            CTLHEIGHT   if( ::lBigStyle, 36, 20 ) ;
            RESOURCE    "WebLeftGi" ;
            OF          Self

   end if

   ::oLeft              := ::oBtnBar

   /*
   Montamos el objeto browse---------------------------------------------------
   */

   do case
   case Valtype( xAlias ) == "O"
      ::oBrw            := TWBrowse():New( nSizeBtn, -1, ::nRight - ::nLeft, ::nBottom - ::nTop - 33 - 25, bLine, aHeaders, aColSizes, ::oClient,,,,,,, ::oFont,,,,, .f., ::xAlias:cAlias, .t., , .f. )
      xAlias:SetBrowse( ::oBrw, .f. )

   case ValType( xAlias ) == "C"
      ::oBrw            := TWBrowse():New( nSizeBtn, -1, ::nRight - ::nLeft, ::nBottom - ::nTop - 33 - 25, bLine, aHeaders, aColSizes, ::oClient,,,,,,, ::oFont,,,,, .f., ::xAlias, .t.,, .f. )

      if ( ::xAlias )->( OrdNumber() ) <= 0
         ::oBrw:oVScroll:SetPos( ( ::xAlias )->( OrdKeyNo() ) )
      else
         ::oBrw:oVScroll:SetPos( ( ::xAlias )->( RecNo() ) )
      end if

   case xAlias == nil
      ::oBrw            := TWBrowse():New( nSizeBtn, -1, ::nRight - ::nLeft, ::nBottom - ::nTop - 33 - 25, bLine, aHeaders, aColSizes, ::oClient,,,,,,, ::oFont,,,,, .f., ::xAlias, .t., , .f. )

   end case

   ::oBrw:Default()
   ::oBrw:aJustify      := aJustify
   ::oBrw:bKeyChar      := {|nKey| ::CtrlKey( nKey ) }

   // Enterprise---------------------------------------------------------------

   ::oBrw:lAdjLastCol      := .f.
   ::oBrw:lAdjBrowse       := .t.

   if ::lBigStyle
      ::oBrw:nLineHeight   := 36
   else
      ::oBrw:nLineHeight   := 16
   end if

   ::oBrw:nHeaderHeight    := 16
   ::oBrw:nFooterHeight    := 16

   // Colores---------------------------------------------------------------------

   ::oBrw:nClrForeFocus    := GetSysColor( 14 )
   ::oBrw:nClrBackFocus    := GetSysColor( 13 )
   ::oBrw:SetColor( CLR_BLACK, GetSysColor( 5 ) )

   /*
   do case
      case ValType( ::xAlias ) == "O"
         ::oBrw:nClrPane   := {|| ::ClrPan( ::xAlias:OrdKeyNo() ) }
      case ValType( ::xAlias ) == "C"
         ::oBrw:nClrPane   := {|| ::ClrPan( ( ::xAlias )->( OrdKeyNo() ) ) }
      case ValType( ::xAlias ) == "A"
         ::oBrw:nClrPane   := {|| ::ClrPan( ::oBrw:nAt ) }
   end case
   */

   ::oBrw:nClrBackHead  := Rgb( 239, 231, 222 )
   ::oBrw:nClrForeHead  := CLR_BLACK

   // Asignando-------------------------------------------------------------------

   ::oBrw:bAdd          := bAdd
   ::oBrw:bEdit         := bEdit
   ::oBrw:bLDblClick    := {|| ::recEdit() }
   ::oBrw:bDel          := bDel
   ::oBrw:bDup          := bDup
   ::oBrw:bZoo          := bZoo
   ::oBrw:oDragCursor   := oCursor
   ::oBrw:bRClicked     := {| nRow, nCol, nFlags | ::RButtonDown( nRow, nCol, nFlags ) }
   ::oBrw:aActions      := {| nCol | ::lPressCol( nCol ) }
   ::oBrw:setFocus()

   ::oClient:oClient    := ::oBrw

   /*
   las tabs--------------------------------------------------------------------

   if ValType( aPrompt ) == "A"
      ::oTabs           := TTabs():New( ::nBottom - ::nTop - 43, 3, aPrompt, , ::oClient, , , Rgb( 239, 231, 222 ), .T., .F., ::nRight - ::nLeft, 24 )
      ::oTabs:bAction   := {|| ::ChgTabs() }
      ::oTabs:oBrush    := TBrush():New( , GetSysColor( 15 ) )
      ::oClient:oBottom := ::oTabs
   end if
   */

   /*
   Nivel de Acceso-------------------------------------------------------------
   */

   ::nLevel             := nLevel

   /*
   Colores del browse----------------------------------------------------------

   if ::nColUno == nil
      ::nColUno  := nColUno()
   end if

   if ::nColDos == nil
      ::nColDos  := nColDos()
   end if
   */

RETURN Self

//----------------------------------------------------------------------------//

METHOD Activate( cShow, bLClicked, bRClicked, bMoved, bResized, bPainted,;
                    bKeyDown, bInit, bUp, bDown, bPgUp, bPgDn,;
                    bLeft, bRight, bPgLeft, bPgRight, bValid, bDropFiles,;
                    bLButtonUp, lCenter ) CLASS TShell

   DEFAULT lCenter   := ( ::nTop == 0 .and. ::nLeft == 0 )
   DEFAULT bValid    := {|| .t. }

   ::lCenter         := lCenter

   Super:Activate( cShow, bLClicked, bRClicked, bMoved, bResized, bPainted,;
                    bKeyDown, bInit, bUp, bDown, bPgUp, bPgDn, bLeft, bRight,;
                    bPgLeft, bPgRight, bValid, bDropFiles, bLButtonUp )

   if ::lCenter
      ::Center( ::hWnd )
   end if

   ::Maximize()

   if ::lAutoPos

      if !empty( ::nRecNo ) .AND. ::nRecNo != 0
         do case
         case ValType( ::xAlias ) == "O"
            ::xAlias:GoTo( ::nRecNo )
         case ValType( ::xAlias ) == "C"
            (::xAlias)->( dbGoTo( ::nRecNo ) )
         end case
      end if

      if !Empty( ::nTab ) .and. ::nTab != 0
         ::ChgCombo( ::nTab )
         ::oComboBox:Select( ::nTab )
      end if

   end if

RETURN NIL

//----------------------------------------------------------------------------//

METHOD GotFocus() CLASS TShell

	Super:GotFocus()

   if ::oBrw != NIL
		::oBrw:SetFocus()
   end if

return 0

//----------------------------------------------------------------------------//

METHOD KeyChar( nKey, nFlags ) CLASS TShell

   do case
   case nKey == VK_ESCAPE .and. ::oWnd != nil
      if ::oTxtSea != nil .and. GetFocus() == ::oTxtSea:hWnd
         ::oBrw:SetFocus()
      else
         ::End()
      end if
      return 0
   case nKey == VK_RETURN .and. ::oWnd != nil
      ::RecEdit()
   case nKey == VK_INSERT .and. ::oWnd != nil
      ::RecAdd()
   case nKey == VK_DELETE .and. ::oWnd != nil
      ::RecDel()
   case nKey == VK_F5
      ::Refresh()
   case nKey == VK_F9
      ::PutOriginal()
   end

return Super:KeyChar( nKey, nFlags )

//----------------------------------------------------------------------------//

METHOD NewAt(  cResName1, cResName2, cBmpFile1, cBmpFile2, cMsg, bAction,;
               lGroup, lAdjust, bWhen, cToolTip, lPressed, bDrop, cAction,;
               cPrompt, oFont, lNoBorder, bMenu, cKey, lMru, lSeaMru, nLevel,;
               lBeginGrp, oFontOver, lOpened, oGroup, lSelect ) CLASS TShell

   local oBtn
   local nClrBtn     := CLR_BOTON //nColorBoton()   //
   local nClrOvr     := CLR_BOTON //nColorBoton()   // Rgb( 255, 255, 255 ) //Rgb( 255, 154, 49 ) //Rgb( 255, 255, 255 ) //

   DEFAULT cMsg      := ""
	DEFAULT lAdjust 	:= .f.
	DEFAULT lPressed 	:= .f.
	DEFAULT bDrop		:= bAction
   DEFAULT lMru      := .f.
   DEFAULT lSeaMru   := .f.
   DEFAULT lBeginGrp := .f.
   DEFAULT lOpened   := .t.
   DEFAULT oGroup    := nil
   DEFAULT lSelect   := .f.

   if ::lBigStyle
      DEFAULT oFont     := TFont():New( "Ms Sans Serif", 6, 14, .f., .t. )
      DEFAULT oFontOver := TFont():New( "Ms Sans Serif", 6, 14, .f., .t., , , , , .t. )
   else
      DEFAULT oFont     := TFont():New( "Ms Sans Serif", 6, 12, .f., .f. )
      DEFAULT oFontOver := TFont():New( "Ms Sans Serif", 6, 12, .f., .f., , , , , .t. )
   end if

   /*
   Chequeamos los niveles de acceso si es mayor no montamos el boton
   */

   if nLevel != nil .and. nAnd( ::nLevel, nLevel ) == 0
      //msginfo( "level del shell " + cValToChar( ::nLevel ) + " level del boton " + cValToChar( nLevel ) + " operación " + cValToChar( nAnd( ::nLevel, nLevel ) ) )
      return nil
   end if

   cToolTip := StrTran( cToolTip, "(", "&" )
   cToolTip := StrTran( cToolTip, ")", ""  )

   if !Empty( cResName1 ) .and. !::lBigStyle
      cResName1 += "16"
   end if

   oBtn     := TWebBtn():NewBar( cResName1, cResName1, , , bAction, ::oBtnBar, ;
                                 cMsg, bWhen, .t., cToolTip, "LEFT", oFont,;
                                 oFontOver, , , nClrBtn, nClrOvr, , , ::lBigStyle,;
                                 if( len( cToolTip ) > 20, StrTran( cToolTip, "&", "" ), nil );
                                 , , bMenu, lBeginGrp, lOpened, oGroup, lSelect )


   if ::lBigStyle
      oBtn:nClrBTop     := Rgb( 255,255,255 )
      oBtn:nClrBBot     := Rgb( 255,154, 49 )
      oBtn:nClrBTopOver := Rgb( 255,154, 49 )
      oBtn:nClrBBotOver := Rgb( 255,255,255 )
   end if

   if ::aFastKey == nil
		::aFastKey := {}
   end if

   if cKey != NIL .and. aScan( ::aFastKey, {|aKey| aKey[1] == Upper( cKey ) } ) = 0
      aadd( ::aFastKey, { Upper( cKey ), {|| oBtn:Click() } } ) // bAction
   end if

return oBtn

//----------------------------------------------------------------------------//

METHOD CtrlKey( nKey ) CLASS TShell

	local nCont
   local nLen := len( ::aFastKey )

	for nCont := 1 TO nLen

      if nKey == Asc( Upper( ::aFastKey[ nCont, 1 ] ) ) .OR. nKey == Asc( Lower( ::aFastKey[ nCont, 1 ] ) )
         Eval( ::aFastKey[ nCont, 2 ] )
      end if

   next

   /*
   Teclas especiales para cambiar los indices sin tocar el raton
   */

   if nKey == 43
      ::NextTabOption()
   end if

   if nKey == 45
      ::PrevTabOption()
   end if

return nil

//----------------------------------------------------------------------------//

METHOD KeyDown( nKey, nFlags ) CLASS TShell

   do case
   case nKey == VK_RETURN .and. ::oWnd != nil
      ::RecEdit()
   case nKey == VK_INSERT .and. ::oWnd != nil
      ::RecAdd()
   case nKey == VK_DELETE .and. ::oWnd != nil
      ::RecDel()
   case nKey == VK_F5
      ::Refresh()
   case nKey == VK_F8
      //::Maximize()
   case nKey == VK_F9
      ::PutOriginal()
   case nKey == VK_F2
      ::NextTabOption()
   case nKey == VK_F3
      ::PrevTabOption()
   end case

return Super:KeyDown( nKey, nFlags )

//----------------------------------------------------------------------------//

METHOD End( lForceExit ) CLASS TShell

   local n
   local nCols

   DEFAULT lForceExit   := .f.

   if !lForceExit .and. ::oBtnBar:lOnProcess()
      return .f.
   end if

   nCols       := Len( ::aFlds )

   if !::lNoSave

      // Tamaño de las columnas

      ::ActColSizes()

      // Orden de las columnas

      for n := 1 to nCols

         if ::oDbfCol:Seek( cCurUsr() + ::cWinName + Str( n, 2 ) )
            ::oDbfCol:Load()
         else
            ::oDbfCol:Append()
         end if

         ::oDbfCol:cCodUse    := cCurUsr()
         ::oDbfCol:cNomCfg    := ::cWinName
         ::oDbfCol:nNumCol    := n
         ::oDbfCol:nPosCol    := ::aColPos[ n ]
         ::oDbfCol:lSelCol    := ::aColSelect[ n ]
         ::oDbfCol:nSizCol    := ::aColSizes[ n ]
         ::oDbfCol:lJusCol    := ::aJustify[ n ]

         ::oDbfCol:Save()

      next

      // Guardamos la pos actual -------------------------------------------------

      do case
         case ValType( ::xAlias ) == "O"
            ::nRecno          := ::xAlias:RecNo()
         case  ValType( ::xAlias ) == "C"
            ::nRecno          := ( ::xAlias )->( RecNo() )
      end case

      ::nTab                  := ::oComboBox:nAt

      if ::oDbfUsr:Seek( cCurUsr() + ::cWinName )
         ::oDbfUsr:Load()
      else
         ::oDbfUsr:Append()
      end if

         ::oDbfUsr:cCodUse    := cCurUsr()
         ::oDbfUsr:cNomCfg    := ::cWinName
         ::oDbfUsr:nRecCfg    := ::nRecno
         ::oDbfUsr:nTabCfg    := ::nTab

         ::oDbfUsr:Save()

   end if

   ::CloseData()

   /*
   Evaluamos el bValid---------------------------------------------------------
   */

   if ::bValid != nil
      if !Eval( ::bValid )
         Return .f.
      end if
   end if

   ::oWndClient:ChildClose( Self )

   memory( -1 )

RETURN ( .t. )

//----------------------------------------------------------------------------//

METHOD Search() CLASS TShell

	local oDlg
   local oIndice
   local cIndice
   local oAutoSeek
   local oThis    := Self
   local xCadena  := Space( 100 )

   if len( ::aPrompt ) == 0
      msgAlert( "No hay indices definidos" )
      return nil
   end if

   do case
   case ValType( ::xAlias ) == "0"
      cIndice  := ::aPrompt[ ::xAlias:OrdNumber() ]
   case ValType( ::xAlias ) == "C"
      cIndice  := ::aPrompt[ ( ::xAlias )->( OrdNumber() ) ]
   end case

   DEFINE DIALOG oDlg RESOURCE "SEARCH"

   REDEFINE COMBOBOX ::oTxtSea VAR xCadena;
      ITEMS    ::aLstSea ;
      ID       100 ;
      OF       oDlg ;
      STYLE    CBS_DROPDOWN

      ::oTxtSea:bValid        := {|| ::AddSearch() }
      ::oTxtSea:bChange       := {|| ::ChangeSeek( oIndice ) }
      ::oTxtSea:oGet:bChange  := {| nKey, nFlags | ::FastSeek( nKey, nFlags, oIndice ) }

   REDEFINE COMBOBOX oIndice VAR cIndice ;
      ID       101 ;
      ITEMS    ::aPrompt ;
      OF       oDlg

      oIndice:bChange := {|| ::ChgIndex( oIndice ) }

   REDEFINE CHECKBOX oAutoSeek VAR ::lAutoSeek ;
      ID       102 ;
      OF       oDlg ;

   REDEFINE BUTTON ;
      ID       510 ;
      OF       oDlg ;
      ACTION   ( oDlg:end() )

   ACTIVATE DIALOG oDlg CENTER VALID ( oThis:AddSearch() )

RETURN NIL

//--------------------------------------------------------------------------//
/*
Suma la ultima busqueda
*/

METHOD AddSearch() CLASS TShell

   local nRec

   do case
   case ValType( ::xAlias ) == "O" .and. ::xAlias:Used()

      nRec  := ::xAlias:Recno()
      ::xAlias:OrdClearScope()
      ::xAlias:GoTo( nRec )

      ::oBrw:Refresh()

   case ValType( ::xAlias ) == "C" .and. ( ::xAlias )->( Used() )

      nRec  := ( ::xAlias )->( Recno() )
      ( ::xAlias )->( OrdScope( 0, nil ) )
      ( ::xAlias )->( OrdScope( 1, nil ) )
      ( ::xAlias )->( dbGoTo( nRec ) )

      ::oBrw:Refresh()

   end case

RETURN .t.

//----------------------------------------------------------------------------//

/*
Cambia el indice actual
*/

METHOD ChgIndex( oIndice ) CLASS TShell

   do case
   case ValType( ::xAlias ) == "O"
      ::xAlias:OrdSetFocus( oIndice:nAt )
   case ValType( ::xAlias ) == "C"
      ( ::xAlias )->( OrdSetFocus( oIndice:nAt ) )
   end case

   ::oComboBox:Select( oIndice:nAt )

   ::oBrw:Refresh()

   ::oTxtSea:setFocus()
   ::oTxtSea:SelectAll()

RETURN NIL

//----------------------------------------------------------------------------//
/*
Realiza busquedas despues de asignar un campo del combobox
*/

METHOD ChangeSeek( oIndice ) CLASS TShell

   local n
   local xCadena
   local cType
   local oGet     := ::oTxtSea:oGet
   local nOrd     := if( SubStr( oGet:varGet(), 1, 1 ) $ "0123456789", 1, 2 )

   do case
   case ValType( ::xAlias ) == "O"
      ::xAlias:OrdSetFocus( n )
      cType := ValType( ::xAlias:OrdKey() )
   case ValType( ::xAlias ) == "C"
      ( ::xAlias )->( OrdSetFocus( n ) )
      cType := ValType( ( ::xAlias )->( OrdKey() ) )
   end case

   oIndice:Set( nOrd )

   ::oComboBox:Select( nOrd )

   if cType == "C"
      xCadena  := Rtrim( oGet:GetText() )
   elseif cType == "N"
      xCadena  := Val( Rtrim( oGet:GetText() ) )
   end if

   do case
   case ValType( ::xAlias ) == "O"
      ::xAlias:Seek( xCadena )
   case ValType( ::xAlias ) == "C"
      ( ::xAlias )->( dbSeek( xCadena ) )
   end case

   ::oBrw:Refresh()

RETURN .T.

//--------------------------------------------------------------------------//

/*
Realiza busquedas de manera progresiva
*/

METHOD FastSeek( nKey, nFlags, oIndice ) CLASS TShell

   local cType
   local xCadena
   local nRecNo
   local lSeek
   local oGet     := ::oTxtSea

   DEFAULT nKey   := 0

   do case
      case ValType( ::xAlias ) == "O"
         nRecNo   := ::xAlias:RecNo()
      case ValType( ::xAlias ) == "C"
         nRecNo   := ( ::xAlias )->( RecNo() )
      case ValType( ::xAlias ) == "A"
         nRecNo   := ::oBrw:nAt
   end case

   // oGet:Assign()

   xCadena        := Upper( SubStr( oGet:varGet(), 1, oGet:nPos - 1 ) )
   xCadena        += Upper( Chr( nKey ) )

   if ValType( ::xAlias ) == "O"
      cType       := ValType( ::xAlias:OrdKeyVal() )
   else
      cType       := ValType( ( ::xAlias )->( OrdKeyVal() ) )
   end if

   lSeek          := lBigSeek( nil, xCadena, ::xAlias, cType, ::oComboBox )

   if lSeek
      do case
         case ValType( ::xAlias ) == "O"
            ::xAlias:GoTo( nRecNo )
         case ValType( ::xAlias ) == "C"
            ( ::xAlias )->( dbGoTo( nRecNo ) )
      end case
   end if

   ::oBrw:Refresh()

Return ( lSeek )

//--------------------------------------------------------------------------//

METHOD RButtonDown( nRow, nCol, nFlags ) CLASS TShell

/*
   local n
   local oMenu
   local oMenuItem
   local bMenuSelect
   local cCaption*/

   if ::oBrw:IsOverHeader( nRow, nCol )

      ::SelColumn( nRow, nCol )

   else

      ::oBrw:RightButtonDown( nRow, nCol, nFlags )

      /*
      oMenu          := MenuBegin( .t. )
      bMenuSelect    := ::bMenuSelect

      ::bMenuSelect  := nil

      for n := 1 to len( ::oBtnBar:aControls )

         if ::oBtnBar:aControls[ n ]:ClassName() == "TWEBBTN"

            if ::oBtnBar:aControls[ n ]:lBeginGrp
               MenuAddItem()
            end if

            cCaption          := StrTran( ::oBtnBar:aControls[ n ]:cCaption, "(", "&" )
            cCaption          := Space( 1 ) + StrTran( cCaption, ")", "" )

            oMenuItem         := MenuAddItem( cCaption, cCaption, .f., .t., by( ::oBtnBar:aControls[ n ]:bAction ), , oMenu )

         end if

      next

      MenuEnd()

      oMenu:Activate( nRow - 60, nCol, ::oBrw )

      ::bMenuSelect  := bMenuSelect
      */

   end if

RETURN NIL

//----------------------------------------------------------------------------//

METHOD AddMru() CLASS TShell

   local cAlias

   if ValType( ::xAlias ) == "O"
      cAlias   := ::xAlias:nArea
   else
      cAlias   := ::xAlias
   end if

   if Empty( ( cAlias )->( OrdSetFocus() ) )
      MsgInfo( LoadString( GetResources(), 15 ) )
      RETURN nil
   end if

RETURN NIL

//----------------------------------------------------------------------------//

METHOD RecDel() CLASS TShell

   if nAnd( ::nLevel, ACC_DELE ) != 0 .AND. ::oBrw:bDel != nil
      if eval( ::oBrw:bDel )
         ::oBrw:refresh()
      end if
   end if

RETURN NIL

//----------------------------------------------------------------------------//

METHOD RecAdd() CLASS TShell

   if nAnd( ::nLevel, ACC_APPD ) != 0 .AND. ::oBrw:bAdd != nil
      ::Disable()
      if Eval( ::oBrw:bAdd )
         ::oBrw:UpStable()
      end if
      ::Enable()
      ::SetFocus()
   else
      msgStop( "Acceso no permitido" )
   end if

RETURN NIL

//----------------------------------------------------------------------------//

METHOD RecEdit()

   if nAnd( ::nLevel, ACC_EDIT ) != 0 .AND. ::oBrw:bEdit != nil
      ::Disable()
      if Eval( ::oBrw:bEdit )
         ::oBrw:refresh()
      end if
      ::Enable()
      ::SetFocus()
   else
      msgStop( "Acceso no permitido" )
   end if

RETURN NIL

//----------------------------------------------------------------------------//

METHOD RecDup()

   if nAnd( ::nLevel, ACC_APPD ) != 0 .AND. ::oBrw:bDup != nil
      ::Disable()
      if Eval( ::oBrw:bDup )
         ::oBrw:refresh()
      end if
      ::Enable()
      ::SetFocus()
   else
      msgStop( "Acceso no permitido" )
   end if

RETURN NIL

//----------------------------------------------------------------------------//

METHOD RecZoom()

   if nAnd( ::nLevel, ACC_ZOOM ) != 0 .AND. ::oBrw:bZoo != nil
      ::Disable()
      if Eval( ::oBrw:bZoo )
         ::oBrw:refresh()
      end if
      ::Enable()
      ::SetFocus()
   else
      msgStop( "Acceso no permitido" )
   end if

RETURN NIL

//----------------------------------------------------------------------------//

static function MruSeek( nKey, oBtn, Self )

   local nOrd
   local nRec
   local cKey := ::aKey[ nKey ]

   if ValType( ::xAlias ) == "O"
      nOrd := ::xAlias:OrdSetFous()
      nRec := ( ::xAlias:Recno() )
      ::xAlias:SetOrder( 1 )
   else
      nOrd := ( ::xAlias )->( OrdSetFocus() )
      nRec := ( ::xAlias )->( Recno() )
      ( ::xAlias )->( dbSetOrder() )
   end if

   ::oBrw:GoTop()

   if ValType( ::xAlias ) == "O"
      if ::xAlias:Seek( cKey, .f. )
         eval( oBtn:bAction )
      else
         ::xAlias:GoTo( nRec )
      end if
      ::xAlias:SetOrder( nOrd )
   else
      if ( ::xAlias )->( dbSeek( cKey, .f. ) )
         eval( oBtn:bAction )
      else
         ( ::xAlias )->( dbGoTo( nRec ) )
      end if
      ( ::xAlias )->( dbSetOrder( nOrd ) )
   end if

   ::oBrw:refresh()

return nil

//----------------------------------------------------------------------------//

static function bMruSeek( n, oBtn, Self )
return {|| MruSeek( n, oBtn, Self ) }

//----------------------------------------------------------------------------//
// Busquedas desde el MRU
//

static function SeaSeek( nKey, Self )

   local xKey
   local nOrd
   local cType

   if nKey > 0 .AND. nKey <= 10

      /*
      Cambio automatico de indice
      */

      nOrd     := if( SubStr( ::aLstSea[ nKey ], 1, 1 ) $ "0123456789", 1, 2 )

      if ValType( ::xAlias ) == "O"
         nOrd  := ::xAlias:OrdSetFocus( nOrd )
         cType := ValType( ::xAlias:OrdKey() )
      else
         nOrd  := ( ::xAlias )->( OrdSetFocus( nOrd ) )
         cType := ValType( ( ::xAlias )->( OrdKey() ) )
      end if

      ::oBrw:GoTop()

      if cType == "C"
         xKey  := ::aLstSea[ nKey ]
      elseif cType == "N"
         xKey  := Val( ::aLstSea[ nKey ] )
      end if

      if ValType( ::xAlias ) == "O"
         ::xAlias:Seek( xKey )
         ::xAlias:OrdSetFocus( nOrd )
      else
         ( ::xAlias )->( dbSeek( ::aLstSea[ nKey ] ) )
         ( ::xAlias )->( OrdSetFocus( nOrd ) )
      end if

      ::oBrw:SetFocus()
      ::oBrw:Refresh()

   end if

return  nil

//----------------------------------------------------------------------------//

static function bSeaSeek( n, Self )
return {|| SeaSeek( n, Self ) }

//----------------------------------------------------------------------------//

METHOD SaveOriginal() CLASS TShell

   ::aOriginal := {}
   aAdd( ::aOriginal, { ::nTop, ::nLeft, ::nBottom, ::nRight } )
   aAdd( ::aOriginal, aClone( ::aColSelect ) )
   aAdd( ::aOriginal, aClone( ::aFlds      ) )
   aAdd( ::aOriginal, aClone( ::aHeaders   ) )
   aAdd( ::aOriginal, aClone( ::aColSizes  ) )
   aAdd( ::aOriginal, aClone( ::aColPos    ) )
   aAdd( ::aOriginal, aClone( ::aJustify   ) )

return nil

//----------------------------------------------------------------------------//

METHOD PutOriginal() CLASS TShell

   local n

   /*
   Tamaño de las columnas
   */

   ::aColSelect   := aClone( ::aOriginal[2] )
   ::aFlds        := aClone( ::aOriginal[3] )
   ::aHeaders     := aClone( ::aOriginal[4] )
   ::aColSizes    := aClone( ::aOriginal[5] )
   ::aColPos      := aClone( ::aOriginal[6] )
   ::aJustify     := aClone( ::aOriginal[7] )

   ::SetColumn()

   if ::oBrw:oHScroll != nil
      ::oBrw:oHScroll:nMax := ::oBrw:GetColSizes()
   endif

   if ::oDbfUsr:Seek( cCurUsr() + ::cWinName )
      ::oDbfUsr:Delete()
   end if

   /*
   Vamos a borrar las columnas -----------------------------------
   */

   for n := 1 to ::nFlds
      if ::oDbfCol:Seek( cCurUsr() + ::cWinName + Str( n, 2 ) )
         ::oDbfCol:Delete()
      end if
   next

return nil

//----------------------------------------------------------------------------//

METHOD SelColumn( nRow, nCol ) CLASS TShell

   local nFor
   local oMenuItem
   local nLen        := Len( ::aFlds )
   local oMenu       := MenuBegin( .t. )
   local bMenuSelect := ::bMenuSelect

   ::ActColSizes()

   /*
   Montamos el menu------------------------------------------------------------
   */

   ::bMenuSelect := nil

   for nFor := 1 to nLen
      if ValType( ::aHeaders[nFor] ) == "C"
         oMenuItem   := MenuAddItem( ::aHeaders[nFor], ::aHeaders[nFor], ::aColSelect[ nFor ], .t., bSelColumn( nFor, Self ), , , oMenu )
      end if
   next

   oMenuItem   := MenuAddItem()
   oMenuItem   := MenuAddItem( "Más...", "Más...", .f., .t., {|| ::DlgColumn() }, , , oMenu )

   MenuEnd()

   oMenu:Activate( nRow - 60, nCol, ::oBrw )

   ::bMenuSelect := bMenuSelect

   oMenu:end()

   ::oBrw:SetFocus()

return nil

//----------------------------------------------------------------------------//

static function bSelColumn( nFor, Self )
return {|| ::aColSelect[ nFor ] := !::aColSelect[ nFor ], ::SetColumn() }

//----------------------------------------------------------------------------//

METHOD SetColumn() CLASS TShell

   local aData       := _aData( ::aFlds, ::aColSelect )
   local aHeaders    := _aColHead( ::aHeaders, ::aColSelect )
   local aColSizes   := _aColSize( ::aColSizes, ::aColSelect )
   local aJustify    := _aColJustify( ::aJustify, ::aColSelect )

   ::oBrw:SetCols( aData, aHeaders, aColSizes )
   ::oBrw:aJustify   := aJustify
   ::oBrw:Refresh()

return nil

//----------------------------------------------------------------------------//

METHOD DlgColumn() CLASS TShell

   local oDlg
   local oGet
   local oBrwCol
   local aFlds       := aClone( ::aFlds      )
   local aHeaders    := aClone( ::aHeaders   )
   local aColSizes   := aClone( ::aColSizes  )
   local aColSelect  := aClone( ::aColSelect )
   local aColPos     := aClone( ::aColPos    )
   local aJustify    := aClone( ::aJustify   )

   local hBmp        := LoadBitmap( 0, 32760 )

   DEFINE DIALOG oDlg RESOURCE "DLGCOLUM"

   REDEFINE LISTBOX oBrwCol;
      FIELDS   if( aColSelect[ oBrwCol:nAt ], hBmp, "" ) ,;
               aHeaders[ oBrwCol:nAt ] ;
      FIELDSIZES ;
               14,;
               40 ;
      HEAD     "S",;
               "Columna" ;
      ID       100 ;
      ON CHANGE( oGet:Refresh() ) ;
      OF       oDlg

      oBrwCol:nLineStyle := 10
      oBrwCol:SetArray( aHeaders )

   REDEFINE GET oGet VAR aColSizes[ oBrwCol:nAt ] ;
      ID       101 ;
      SPINNER ;
      MIN      1 ;
      MAX      999 ;
      PICTURE  "999" ;
      VALID    ::aColSizes[ oBrwCol:nAt ] > 0 ;
      OF       oDlg

   REDEFINE BUTTON ;
      ID       400 ;
      OF       oDlg ;
      ACTION   ( if( CheckOne( aColSelect ), oDlg:end( IDOK ), ) )

   REDEFINE BUTTON ;
      ID       401 ;
      OF       oDlg ;
      ACTION   ( oDlg:end() )

   REDEFINE BUTTON ;
      ID       402 ;
      OF       oDlg ;
      ACTION   ( aColSelect[ oBrwCol:nAt ] := .t., oBrwCol:SetFocus(), oBrwCol:Refresh() )

   REDEFINE BUTTON ;
      ID       403 ;
      OF       oDlg ;
      ACTION   ( aColSelect[ oBrwCol:nAt ] := .f., oBrwCol:SetFocus(), oBrwCol:Refresh() )

   REDEFINE BUTTON ;
      ID       404 ;
      OF       oDlg ;
      ACTION   ( ::UpColumn( oBrwCol, aFlds, aHeaders, aColSizes, aColSelect, aColPos, aJustify ) )

   REDEFINE BUTTON ;
      ID       405 ;
      OF       oDlg ;
      ACTION   ( ::DwColumn( oBrwCol, aFlds, aHeaders, aColSizes, aColSelect, aColPos, aJustify ) )

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK
      ::aFlds        := aFlds
      ::aHeaders     := aHeaders
      ::aColSizes    := aColSizes
      ::aColSelect   := aColSelect
      ::aColPos      := aColPos
      ::aJustify     := aJustify
      ::SetColumn()
   end if

   PalBmpFree( hBmp )
   hBmp              := 0

return nil

//----------------------------------------------------------------------------//
//
// Actualiza los anchos de columnas
//

METHOD ActColSizes() CLASS TShell

   local nFor
   local n     := 1
   local nLen  := len( ::aFlds )

   /*
   Reescribimos los valores actuales del ancho de columna----------------------
   */

   for nFor := 1 to nLen
      if ::aColSelect[ nFor ]
         ::aColSizes[ nFor ]  := ::oBrw:aColSizes[n]
         n++
      end if
   next

return nil

//----------------------------------------------------------------------------//

METHOD UpColumn( oBrw, aFlds, aHeaders, aColSizes, aColSelect, aColPos, aJustify ) CLASS TShell

   local nPos  := oBrw:nAt

   if nPos <= len( aFlds ) .and. nPos > 1

      SwapUpArray( aFlds,      nPos )
      SwapUpArray( aHeaders,   nPos )
      SwapUpArray( aColSizes,  nPos )
      SwapUpArray( aColSelect, nPos )
      SwapUpArray( aColPos,    nPos )
      SwapUpArray( aJustify,   nPos )

      oBrw:GoUp()
      oBrw:Refresh()
      oBrw:SetFocus()

   end if

return ( Self )

//----------------------------------------------------------------------------//

METHOD DwColumn( oBrw, aFlds, aHeaders, aColSizes, aColSelect, aColPos, aJustify ) CLASS TShell

   local nPos  := oBrw:nAt

   if nPos < len( aFlds ) .and. nPos > 0

      SwapDwArray( aFlds,      nPos )
      SwapDwArray( aHeaders,   nPos )
      SwapDwArray( aColSizes,  nPos )
      SwapDwArray( aColSelect, nPos )
      SwapDwArray( aColPos,    nPos )
      SwapDwArray( aJustify,   nPos )

      oBrw:GoDown()
      oBrw:Refresh()
      oBrw:SetFocus()

   end if

return ( Self )

//----------------------------------------------------------------------------//

static function _aFld( aFields, aColSel )

   local nFor
   local nLen  := Len( aFields )
   local aFld  := {}

   for nFor = 1 to nLen
      if aColSel[ nFor ]
         aAdd( aFld, Eval( aFields[ nFor ] ) )
      end if
   next

return aFld

//----------------------------------------------------------------------------//

static function _aData( aFields, aColSel )

   local nFor
   local nLen  := Len( aFields )
   local aFld  := {}

   for nFor = 1 to nLen
      if aColSel[ nFor ]
         aAdd( aFld, aFields[ nFor ] )
      end if
   next

return aFld

//----------------------------------------------------------------------------//

static function _aColHead( aHeaders, aColSel )

   local nFor
   local nLen  := Len( aHeaders )
   local aHea  := {}

   for nFor = 1 to nLen
      if aColSel[ nFor ]
         aAdd( aHea, aHeaders[ nFor ] )
      end if
   next

return aHea

//----------------------------------------------------------------------------//

static function _aColSize( aColSizes, aColSel, oBrw )

   local nFor
   local nLen  := Len( aColSizes )
   local aSiz  := {}

   for nFor = 1 to nLen
      if aColSel[ nFor ]
         aAdd( aSiz, aColSizes[ nFor ] )
      end if
   next

return aSiz

//----------------------------------------------------------------------------//

static function _aColJustify( aColJustify, aColSel, oBrw )

   local nFor
   local nLen  := Len( aColJustify )
   local aJus  := {}

   for nFor = 1 to nLen
      if aColSel[ nFor ]
         aAdd( aJus, aColJustify[ nFor ] )
      end if
   next

return aJus

//----------------------------------------------------------------------------//

function SwapUpArray( aArray, nPos )

   local uTmp

   DEFAULT nPos   := len( aArray )

   if nPos <= len( aArray ) .and. nPos > 1
      uTmp              := aArray[nPos]
      aArray[nPos]      := aArray[nPos - 1 ]
      aArray[nPos - 1 ] := uTmp
   end if

return nil

//----------------------------------------------------------------------------//

function SwapDwArray( aArray, nPos )

   local uTmp

   DEFAULT nPos   := len( aArray )

   if nPos < len( aArray ) .and. nPos > 0
      uTmp              := aArray[nPos]
      aArray[nPos]      := aArray[nPos + 1 ]
      aArray[nPos + 1 ] := uTmp
   end if

return nil

//----------------------------------------------------------------------------//
//
// Color para las lineas
//
/*
METHOD ClrPan( nAt ) CLASS TShell
   DEFAULT nAt := 1
return ( if( Mod( nAt, 2 ) == 0, ::nColUno, ::nColDos ) )
*/
//----------------------------------------------------------------------------//
//
// Chequea que almenos una columna este marcada
//

static function CheckOne( aColSelect )

   local lOne  := .f.

   aEval( aColSelect, {|x| if( x, lOne := .t., ) } )

   if !lOne
      msgAlert( "La ventana debe de contener al menos una columna seleccionada" )
   end if

return ( lOne )

//---------------------------------------------------------------------------//

METHOD AutoButtons( oParent ) CLASS TShell

   ::GralButtons( oParent )

   ::EndButtons( oParent )

return nil

//----------------------------------------------------------------------------//

METHOD GralButtons( oParent ) CLASS TShell

   DEFINE BTNSHELL RESOURCE "BUS" OF Self ;
      NOBORDER ;
      ACTION   ( ::oTxtSea:SetFocus() ) ;
      TOOLTIP  "(B)uscar" ;
      HOTKEY   "B";

      ::AddSeaBar()

   if ::oBrw:bAdd != nil

   DEFINE BTNSHELL RESOURCE "NEW" OF Self ;
      NOBORDER ;
      ACTION   ( ::RecAdd() );
      ON DROP  ( ::RecAdd() );
      TOOLTIP  "(A)ñadir";
      BEGIN GROUP ;
      HOTKEY   "A" ;
      LEVEL    ACC_APPD

   end if

   if ::oBrw:bDup != nil

   DEFINE BTNSHELL RESOURCE "DUP" OF Self ;
      NOBORDER ;
      ACTION   ( ::RecDup() );
      TOOLTIP  "(D)uplicar";
      HOTKEY   "D" ;
      LEVEL    ACC_APPD

   end if

   if ::oBrw:bEdit != nil

   DEFINE BTNSHELL RESOURCE "EDIT" OF Self ;
      NOBORDER ;
      ACTION   ( ::RecEdit() );
      TOOLTIP  "(M)odificar";
      HOTKEY   "M" ;
      LEVEL    ACC_EDIT

   end if

   if ::oBrw:bZoo != nil

   DEFINE BTNSHELL RESOURCE "ZOOM" OF Self ;
      NOBORDER ;
      ACTION   ( ::RecZoom() );
      TOOLTIP  "(Z)oom";
      HOTKEY   "Z" ;
      LEVEL    ACC_ZOOM

   end if

   DEFINE BTNSHELL RESOURCE "DEL" OF Self ;
      NOBORDER ;
      ACTION   ( ::RecDel() );
      TOOLTIP  "(E)liminar";
      MRU ;
      HOTKEY   "E";
      LEVEL    ACC_DELE

   DEFINE BTNSHELL RESOURCE "IMP" OF Self ;
      NOBORDER ;
      ACTION   ( oParent:Report() ) ;
      TOOLTIP  "(L)istado" ;
      HOTKEY   "L" ;
      LEVEL    ACC_IMPR

return nil

//----------------------------------------------------------------------------//

METHOD EndButtons( oParent ) CLASS TShell

   if oParent != nil

   DEFINE BTNSHELL RESOURCE "END1" GROUP OF Self ;
      NOBORDER ;
      ACTION   ( oParent:end() ) ;
      TOOLTIP  "(S)alir" ;
      HOTKEY   "S"

   end if

return nil

//----------------------------------------------------------------------------//

STATIC FUNCTION ChgGet( cType, nLen, nDec, oVal )

	oVal:bValid			:= {|| .T. }
	oVal:oGet:Picture := ""

	DO CASE
	CASE cType == "L"
		oVal:bValid	:= {| oVal | oVal:varGet() $ "SN" }
		oVal:cText( "Si" )
	CASE cType == "N"
		oVal:oGet:Picture := retPic( nLen, nDec, .t. )
	END IF

	oVal:cText( retGet( cType, nLen, nDec ) )
	oVal:refresh()

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION retGet( cType, nLen, nDec )

	local cRet	:= ""

	DO CASE
	CASE cType == "L"
		cRet	:= "S"
	CASE cType == "C"
		cRet	:= Space( nLen )
	CASE cType == "N"
		cRet	:= 0
	CASE cType == "D"
		cRet	:= date()
	END IF

RETURN cRet

//--------------------------------------------------------------------------//

STATIC FUNCTION mkExpSea( aTblFld, oFld, oCon, aVal, oNex )

	local n			:= 1
	local cExp		:= ""
	local aNex		:= { 	" .AND. ", " .OR. " }
	local aTblCon	:= { 	" == ",;
								" != ",;
								" > ",;
								" < ",;
								" >= ",;
								" <= ",;
								" $ " }

	WHILE n <= len( aVal )

		IF aTblCon[ oCon[n]:nAt ] == " $ "

			cExp	+= cGetVal( aVal[n] ) + ;
						aTblCon[ oCon[n]:nAt ] + ;
						rtrim( aTblFld[ oFld[n]:nAt ] )

		ELSE

			cExp	+= rtrim( aTblFld[ oFld[n]:nAt ] ) + ;
						aTblCon[ oCon[n]:nAt ] + ;
						cGetVal( aVal[n] )

		END IF

		IF oNex[n]:nAt != 1
			cExp 	+= aNex[ oNex[n]:nAt - 1 ]
		ELSE
			EXIT
		END IF

		n++

	END DO

	IF At( Type( cExp ), "UEUI" ) != 0
      msgAlert( "Expresión " + rtrim( cExp ) + " no valida" )
		cExp	:= NIL
   ELSE
      cExp  := &( "{|| " + cExp + " }" )
   END IF

RETURN cExp

//--------------------------------------------------------------------------//

STATIC FUNCTION cGetVal( xVal )

	local cTemp
	local cType := valtype( xVal )

	DO CASE
	CASE cType == "C"

		IF Upper( xVal ) 		== "S"
			cTemp := ".T."
		ELSEIF Upper( xVal ) == "N"
			cTemp := ".F."
		ELSE
			xVal	:= rtrim( xVal )
			cTemp := '"' + cValToChar( xVal ) + '"'
		END IF

	CASE cType == "N"

		cTemp := cValToChar( xVal )

	CASE cType == "D"

		cTemp := 'CTOD( "' + cValToChar( xVal ) + '" )'

	END CASE

RETURN ( cTemp )

//---------------------------------------------------------------------------//

METHOD Maximize() CLASS TShell

   local oWnd  := GetWndFrame()

   ::Restore()

   ::nTop      := 0 // -4
   ::nLeft     := 0
   ::nBottom   := oWnd:oWndClient:nHeight() //+ 4
   ::nRight    := oWnd:oWndClient:nWidth()

   ::Move( ::nTop, ::nLeft, ::nRight, ::nBottom,  .t. )

return nil

//----------------------------------------------------------------------------//

METHOD SysCommand( nWParam, nLParam ) CLASS TShell

   if nWParam == SC_MAXIMIZE
      ::Maximize()
      return 0
   else
      Super:SysCommand( nWParam, nLParam )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD AutoItems( oParent ) CLASS TShell

   local nClrBtn  := CLR_BOTON //nColorBoton()
   local nClrOvr  := CLR_BOTON //nColorBoton()

   if ::oBrw:bAdd != nil

      ::oBtnBar:AddItem(   nil, nil, nil, nil,;
                           {|| ::RecAdd() },;
                           ::oBtnBar,;
                           "Añadir un registro", ;
                           nil,;
                           .t.,;
                           "&Añadir",;
                           "RIGHT",;
                           ,;
                           ,;
                           nClrBtn,;
                           nClrOvr,;
                           Rgb( 0, 0, 0 ),;
                           Rgb( 0, 0, 0 ),;
                           .f. )

   end if

   if ::oBrw:bDup != nil

      ::oBtnBar:AddItem(   nil, nil, nil, nil,;
                           {|| ::RecDup() },;
                           ::oBtnBar,;
                           "Duplica el registro en curso", ;
                           nil,;
                           .t.,;
                           "&Duplicar",;
                           "RIGHT",;
                           ,;
                           ,;
                           nClrBtn,;
                           nClrOvr,;
                           Rgb( 0, 0, 0 ),;
                           Rgb( 0, 0, 0 ),;
                           .f. )

   end if

   if ::oBrw:bEdit != nil

      ::oBtnBar:AddItem(   nil, nil, nil, nil,;
                           {|| ::RecEdit() },;
                           ::oBtnBar,;
                           "Modificar el registro en curso", ;
                           nil,;
                           .t.,;
                           "&Modificar",;
                           "RIGHT",;
                           ,;
                           ,;
                           nClrBtn,;
                           nClrOvr,;
                           Rgb( 0, 0, 0 ),;
                           Rgb( 0, 0, 0 ),;
                           .f. )

   end if

      ::oBtnBar:AddItem(   nil, nil, nil, nil,;
                           {|| ::RecDel() },;
                           ::oBtnBar,;
                           "Eliminar el registro en curso", ;
                           nil,;
                           .t.,;
                           "&Eliminar",;
                           "RIGHT",;
                           ,;
                           ,;
                           nClrBtn,;
                           nClrOvr,;
                           Rgb( 0, 0, 0 ),;
                           Rgb( 0, 0, 0 ),;
                           .f. )

      ::oBtnBar:AddItem(   nil, nil, nil, nil,;
                           {|| ::Search() },;
                           ::oBtnBar,;
                           "Buscar en la tabla", ;
                           nil,;
                           .t.,;
                           "&Buscar",;
                           "RIGHT",;
                           ,;
                           ,;
                           nClrBtn,;
                           nClrOvr,;
                           Rgb( 0, 0, 0 ),;
                           Rgb( 0, 0, 0 ),;
                           .f. )

      ::oBtnBar:AddItem(   nil, nil, nil, nil,;
                           {|| oParent:Report() },;
                           ::oBtnBar,;
                           "Imprimir", ;
                           nil,;
                           .t.,;
                           "&Imprimir",;
                           "RIGHT",;
                           ,;
                           ,;
                           nClrBtn,;
                           nClrOvr,;
                           Rgb( 0, 0, 0 ),;
                           Rgb( 0, 0, 0 ),;
                           .f. )

   if oParent != nil

      ::oBtnBar:AddItem(   nil, nil, nil, nil,;
                           {|| oParent:End() },;
                           ::oBtnBar,;
                           "Cerrar la ventana actual", ;
                           nil,;
                           .t.,;
                           "&Salir",;
                           "RIGHT",;
                           ,;
                           ,;
                           nClrBtn,;
                           nClrOvr,;
                           Rgb( 0, 0, 0 ),;
                           Rgb( 0, 0, 0 ),;
                           .f. )

   end if

return nil

//----------------------------------------------------------------------------//

METHOD Destroy() CLASS TShell

   if ::oBrw != nil
      ::oBrw:end()
   end if

   if ::oBtnBar != nil
      ::oBtnBar:end()
   end if

   if ::oBtnTop != nil
      ::oBtnTop:end()
   end if

   if ::oMsgBar != nil
      ::oMsgBar:end()
   end if

   if ::oComboBox != nil
      ::oComboBox:end()
   end if

   if ::oFont != nil
      ::oFont:end()
   end if

   if ::oIcon != nil
      ::oIcon:end()
   end if

   if ::oCursor != nil
      ::oCursor:end()
   end if

   if ::oTop != nil
      ::oTop:end()
   end if

   if ::oLeft != nil
      ::oLeft:end()
   end if

   if ::oRight != nil
      ::oRight:end()
   end if

   if ::oClient != nil
      ::oClient:end()
   end if

   if ::oTxtSea != nil
      ::oTxtSea:end()
   end if

   if ::hWnd != 0
      Super:Destroy()
   endif

return ( Self )

//----------------------------------------------------------------------------//

METHOD ChgTabs( nTab ) CLASS TShell

   DEFAULT nTab   := ::oTabs:nOption

   do case
      case ValType( ::xAlias ) == "O"
         ::xAlias:SetOrder( nTab )
      case ValType( ::xAlias ) == "C"
         (::xAlias)->( dbSetOrder( nTab ) )
   end case

   ::oBrw:Refresh()

   if ::oTxtSea != nil .and. ::oTxtSea:ClassName() == "TGET"

      ::oTxtSea:oGet:Home()
      ::oTxtSea:cText( Space( 100 ) )

      #ifdef __CLIPPER__
      ::oTxtSea:EditUpdate()
      #endif

   end if

return ( Self )

//----------------------------------------------------------------------------//

METHOD ChgCombo( nTab ) CLASS TShell

   do case
      case ValType( ::xAlias ) == "O"
         ::xAlias:SetOrder( nTab )
      case ValType( ::xAlias ) == "C"
         ( ::xAlias )->( dbSetOrder( nTab ) )
   end case

   ::oBrw:Refresh()

   if ::oTxtSea != nil .and. ::oTxtSea:ClassName() == "TGET"
      ::oTxtSea:oGet:Home()
      ::oTxtSea:cText( Space( 100 ) )
   end if

return ( Self )

//----------------------------------------------------------------------------//

METHOD AddSeaBar() CLASS TShell

   local cSea  := Space( 100 )

   @  0, 0 GET ::oTxtSea VAR cSea ;
      OF       ::oBtnBar ;
      SIZE     120, 20 ;
      FONT     ::oFont ;
      PIXEL

   ::oTxtSea:bValid     := {|| ::AddSearch() }
   ::oTxtSea:bChange    := {| nKey, nFlags | ::FastSeek( nKey, nFlags ) }
   ::oTxtSea:bKeyDown   := {| nKey, nFlags | iif( nKey == 114, ::NextTabOption(),;
                                             iif( nKey == 113, ::PrevTabOption(), ) ) }

   @  0, 0 COMBOBOX ::oComboBox VAR ::cComboBox ;
      OF       ::oBtnBar ;
      ITEMS    ::aPrompt ;
      SIZE     120, 100 ;
      FONT     ::oFont ;
      PIXEL

   ::oComboBox:bChange  := {|| ::ChgCombo( ::oComboBox:nAt ) }

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD SetIndex( nIndex ) CLASS TShell

   do case
   case ValType( ::xAlias ) == "O"
      ::xAlias:SetOrder( nIndex )
   case ValType( ::xAlias ) == "C"
      ( ::xAlias )->( dbSetOrder( nIndex ) )
   end case

   ::oComboBox:Select( nIndex )

   ::oBrw:Refresh()

RETURN nil

//----------------------------------------------------------------------------//

METHOD NextTabOption() CLASS TShell

   local nOpt  := ::oComboBox:nAt

   if nOpt < len( ::aPrompt )
      nOpt++
      ::oComboBox:Select( nOpt )
      ::ChgCombo( nOpt )
   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD PrevTabOption() CLASS TShell

   local nOpt  := ::oComboBox:nAt

   if nOpt > 1
      nOpt--
      ::oComboBox:Select( nOpt )
      ::ChgCombo( nOpt )
   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD lPressCol( nCol ) CLASS TShell

   local nPos
   local cHeader

   if !Empty( nCol ) .and. nCol <= len( ::oBrw:aHeaders )
      cHeader     := ::oBrw:aHeaders[ nCol ]
      nPos        := aScan( ::aPrompt, cHeader )
      if nPos != 0
         ::oComboBox:Set( cHeader )
         do case
            case ValType( ::xAlias ) == "O"
               ::xAlias:OrdSetFocus( ::oComboBox:nAt )
            case ValType( ::xAlias ) == "C"
               ( ::xAlias )->( OrdSetFocus( ::oComboBox:nAt ) )
         end case
         ::oBrw:Refresh()
      end if
   end if

return nil

//---------------------------------------------------------------------------//

METHOD OpenData( lExclusive ) CLASS TShell

   DEFAULT lExclusive   := .f.

   DEFINE TABLE ::oDbfUsr FILE "CfgUse.Dbf" CLASS "CfgUseEmp" PATH ( cPatEmp() ) VIA ( cDriver() )COMMENT "Configuración de usuarios"

      FIELD NAME "cCodUse" TYPE "C" LEN  3  DEC 0 COMMENT "Código usuario"          OF ::oDbfUsr
      FIELD NAME "cNomCfg" TYPE "C" LEN 30  DEC 0 COMMENT "Nombre ventana"          OF ::oDbfUsr
      FIELD NAME "nRecCfg" TYPE "N" LEN 10  DEC 0 COMMENT "Recno de la ventana"     OF ::oDbfUsr
      FIELD NAME "nTabCfg" TYPE "N" LEN 10  DEC 0 COMMENT "Orden de la ventana"     OF ::oDbfUsr

      INDEX TO "CfgUse.Cdx" TAG "cCodUse" ON "cCodUse + cNomCfg" COMMENT "Código" NODELETED OF ::oDbfUsr

   END DATABASE ::oDbfUsr

   ::oDbfUsr:Activate( .f., !( lExclusive ) )

   /*
   Base de datos de usuarios conf de columnas de pantallas---------------------
   */

   DEFINE TABLE ::oDbfCol FILE "CfgCol.Dbf" CLASS "CfgColEmp"  PATH ( cPatEmp() ) VIA ( cDriver() )COMMENT "Configuracion de columnas de usuarios"

      FIELD NAME "cCodUse"    TYPE "C" LEN  3  DEC 0 COMMENT "Código usuario"             OF ::oDbfCol
      FIELD NAME "cNomCfg"    TYPE "C" LEN 30  DEC 0 COMMENT "Nombre ventana"             OF ::oDbfCol
      FIELD NAME "nNumCol"    TYPE "N" LEN  2  DEC 0 COMMENT "Número de la columna"       OF ::oDbfCol
      FIELD NAME "lSelCol"    TYPE "L" LEN  1  DEC 0 COMMENT "Columna seleccionada"       OF ::oDbfCol
      FIELD NAME "nPosCol"    TYPE "N" LEN  2  DEC 0 COMMENT "Posicición de la columna"   OF ::oDbfCol
      FIELD NAME "nSizCol"    TYPE "N" LEN  6  DEC 0 COMMENT "Tamaño de la columna"       OF ::oDbfCol
      FIELD NAME "lJusCol"    TYPE "L" LEN  1  DEC 0 COMMENT "Columna a la derecha"       OF ::oDbfCol

      INDEX TO "CfgCol.Cdx" TAG "cCodUse" ON "cCodUse + cNomCfg + Str( nNumCol )" COMMENT "Código" NODELETED OF ::oDbfCol

   END DATABASE ::oDbfCol

   ::oDbfCol:Activate( .f., !( lExclusive ) )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CloseData() CLASS TShell

   ::oDbfUsr:End()
   ::oDbfCol:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD HelpTopic() CLASS TShell

   if !Empty( ::cHtmlHelp )
      HtmlHelp( ::cHtmlHelp )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddGoTo( cCaption, bAction )

   aAdd( ::aGoTo, { cCaption, bAction } )

RETURN ( Self )

//---------------------------------------------------------------------------//

Function GetFreeSystemResources()

Return ( 0 )