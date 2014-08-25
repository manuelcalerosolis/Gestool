#include "FiveWin.Ch"
#include "Splitter.ch"
#include "Factu.ch" 
#include "Constant.ch"
#include "MesDbf.ch"
#include "xbrowse.ch"
#include "DbInfo.ch"

#define TVS_HASBUTTONS        1
#define TVS_HASLINES          2
#define TVS_LINESATROOT       4
#define TVS_SHOWSELALWAYS     32 //  0x0020
#define TVS_DISABLEDRAGDROP   16 //  0x0010
#define TVS_CHECKBOXES        256 //  0x0100
#define TVS_TRACKSELECT       512 //   0x0200

#define dfnTreeViewWidth      200
#define dfnSplitterWidth      0
#define dfnSplitterHeight     44

#define SC_MAXIMIZE           61488    // 0xF030

#define CLR_BOTON             Rgb( 0, 0, 0 ) //Rgb( 255, 154, 49 ) Rgb( 255, 255, 255 )    //  //

#define WM_ERASEBKGND         20       // 0x14
#define WM_CHILDACTIVATE      34       // 0x22
#define WM_ICONERASEBKGND     39       // 0x27

#ifdef __HARBOUR__
   #ifndef __XHARBOUR__
      #xtranslate DbSkipper => __DbSkipper
   #endif
#endif

static oFontLittelTitle

#ifndef __PDA__

//------------------------------------------------------------------------//
//Clases/m�todos del programa
//------------------------------------------------------------------------//

CLASS TShell FROM TMdiChild

   DATA  oBrw
   DATA  oWndBar
   DATA  oBtnBar
   DATA  oBtnMain
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
   DATA  cCodigoUsuario

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
   DATA  dbfUsr
   DATA  dbfCol
   DATA  nRec        AS NUMERIC  INIT 0
   DATA  nTab        AS NUMERIC  INIT 1
   DATA  cCfg
   DATA  lMin
   DATA  lZoom
   DATA  lNoSave     AS LOGIC    INIT .f.
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

   DATA  aOriginal   

   DATA  bAdd
   DATA  bEdit
   DATA  bDel
   DATA  bDup
   DATA  bZoo

   DATA  lFastButtons   AS LOGIC    INIT .t.

   DATA  lTactil        AS LOGIC    INIT .f.

   DATA  oActiveFilter
   DATA  lActiveFilter  AS LOGIC    INIT .f.

   DATA  lChanged       AS LOGIC    INIT .f.

   DATA  bDestroy

   DATA  oImageList
   DATA  oVerticalSplitter
   DATA  oHorizontalSplitter

   DATA  lOnProcess     AS LOGIC    INIT .f.

   DATA  lOpenData      AS LOGIC    INIT .t.

   DATA  lFechado       AS LOGIC    INIT .f.

   DATA  oFilter

   DATA  bToolTip
   DATA  oToolTip
   DATA  oTimer

   DATA  bChgIndex

   DATA  bFilter

   CLASSDATA nToolTip   AS NUMERIC  INIT 900

   METHOD New( nTop, nLeft, nBottom, nRight, cTitle, oMenu, oWnd, oIcon,;
               oCursor, lPixel, nHelpId, aFlds, xAlias, aHeaders,;
               aColSizes, aColSelect, aJustify, aPrompt, bAdd, bEdit, bDel, bDup,;
               nSizeBtn, nLevel, cMru, cInifile  ) CONSTRUCTOR

   METHOD Create() INLINE ( Self )

   METHOD Activate( cShow, bLClicked, bRClicked, bMoved, bResized, bPainted,;
                    bKeyDown, bInit, bUp, bDown, bPgUp, bPgDn,;
                    bLeft, bRight, bPgLeft, bPgRight, bValid, bDropFiles,;
                    bLButtonUp )

   Method CreateXBrowse()
   Method CreateXFromCode()
   Method AddXCol()  INLINE ( ::oBrw:AddCol() )

	METHOD GotFocus()

	METHOD KeyChar( nKey, nFlags )
   METHOD KeySearch( nKey, nFlags, oWndBar )

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

   METHOD FastSeek( oGet, cText )

   METHOD lCloseArea    INLINE ( .t. ) // ::oBrw:lCloseArea() )

   METHOD Refresh()     INLINE ( if( !Empty( ::oBtnMain ), ::oBtnBar:Select( ::oBtnMain ), ), if( !Empty( ::oBrw ) .and. ( ::oBrw:lActive ), ::oBrw:Refresh(), ), if( !Empty( ::oBtnTop ), ::oBtnTop:Refresh(), ), ::Super:Refresh() )
   METHOD UpStable()    INLINE ( if( !Empty( ::oBtnMain ), ::oBtnBar:Select( ::oBtnMain ), ), if( !Empty( ::oBrw ) .and. ( ::oBrw:lActive ), ::oBrw:Refresh(), ) )
   METHOD GoUp()        INLINE ( ::oBrw:GoUp() )
   METHOD GoDown()      INLINE ( ::oBrw:GoDown() )

   METHOD Select()      INLINE ( if( !Empty( ::oBrw ) .and. ( ::oBrw:lActive ), ( ::oBrw:Refresh(), ::oBrw:Select() ), ) )
   METHOD SelectOne()   INLINE ( if( !Empty( ::oBrw ) .and. ( ::oBrw:lActive ), ( ::oBrw:SelectOne() ), ) )

   METHOD SetFocus()    INLINE ( if( !Empty( ::oBtnMain ), ::oBtnBar:Select( ::oBtnMain ), ), if( !Empty( ::oBrw ), ( ::oBrw:SetFocus(), ::oBrw:Select( 0 ), ::oBrw:Select( 1 ) ), ) )

   METHOD SetIndex( nIndex )

   METHOD RButtonDown( nRow, nCol, nFlags )

   METHOD AddMru()

   METHOD SaveOriginal()

   METHOD PutOriginal()

   METHOD SetColumn()

   //METHOD DlgColumn()

   METHOD ActColSizes()

   METHOD UpColumn( nPos )

   METHOD DwColumn( nPos )

   METHOD AutoButtons( oParent )

   METHOD GralButtons( oParent )

   METHOD EndButtons( oParent )

   METHOD End()

   METHOD Destroy()

   METHOD Maximize()

   METHOD SysCommand( nWParam, nLParam )

   METHOD Display() INLINE ::BeginPaint(), ::Paint(), ::EndPaint()

   METHOD ChgTabs()

   METHOD ChgCombo( nTab )
   METHOD ChgFilter( nTab )

   METHOD AddSeaBar()

   METHOD NextTabOption()
   METHOD PrevTabOption()

   METHOD lPressCol()
   METHOD ClickOnHeader( oCol )

   METHOD HelpTopic()

   METHOD AddGoTo( cCaption, bAction )

   Method SearchSetFocus()                   INLINE ( if( !Empty( ::oWndBar ), ::oWndBar:SetGetFocus(), ) )
   Method SetYearComboBoxChange( bBlock )    INLINE ( if( !Empty( ::oWndBar ), ::oWndBar:SetYearComboBoxChange( bBlock ), ) )

   Method SetKillFilter( bBlock )            INLINE ( if( !Empty( ::oWndBar ), ::oWndBar:SetKillFilter( bBlock ), ) )

   Method AddImageList( cImage )

   Method ClickTree()

   Method BarDisable()                       INLINE ( if( !Empty( ::oWndBar ), ::oWndBar:Disable(), ) )
   Method BarEnable()                        INLINE ( if( !Empty( ::oWndBar ), ::oWndBar:Enable(), ) )

   Method BrwDisable()                       INLINE ( if( !Empty( ::oBrw ), ::oBrw:Disable(), ) )
   Method BrwEnable()                        INLINE ( if( !Empty( ::oBrw ), ::oBrw:Enable(), ) ) //( ::oBrw:Enable(), ::oBrw:SetFocus() ), ) ) //

   Method SetOnProcess()                     INLINE ( ::BrwDisable(), ::BarDisable(), ::lOnProcess := .t., ::CheckExtendInfo() )
   Method KillProcess()                      INLINE ( ::lOnProcess := .f., ::BarEnable(), ::BrwEnable() )
   Method QuitOnProcess()                    INLINE ( ::lOnProcess := .f., ::BarEnable(), ::BrwEnable() )

   Method ShowButtonFilter()                 INLINE ( ::lActiveFilter := .t., ::oWndBar:ShowButtonFilter() )
   Method HideButtonFilter()                 INLINE ( ::lActiveFilter := .f., ::oWndBar:HideButtonFilter() )

   Method ShowAddButtonFilter()              INLINE ( ::oWndBar:ShowAddButtonFilter() )
   Method HideAddButtonFilter()              INLINE ( ::oWndBar:HideAddButtonFilter() )

   Method ShowEditButtonFilter()             INLINE ( ::oWndBar:ShowEditButtonFilter() )
   Method HideEditButtonFilter()             INLINE ( ::oWndBar:HideEditButtonFilter() )

   Method AddFilter()                        INLINE ( if(   !Empty( ::oActiveFilter ),;
                                                            ( ::oActiveFilter:AddFilter(), ::EnableComboFilter( ::oActiveFilter:FiltersName() ) ), ) )
   Method EditFilter()                       INLINE ( if(   !Empty( ::oActiveFilter ) .and. !Empty( ::oWndBar ),;
                                                            ( ::oActiveFilter:EditFilter( ::oWndBar:GetComboFilter() ), ::ChgFilter() ), ) )
   Method KillFilter()                       INLINE ( if(   !Empty( ::oActiveFilter ) .and. !Empty( ::oWndBar ),;
                                                            ( ::oActiveFilter:KillFilter(), ::oWndBar:HideButtonFilter(), ::oWndBar:HideEditButtonFilter() ), ) )

   Method CreateData()
   Method OpenData()
   Method CleanData()
   Method DeleteData()
   Method CloseData()
   Method ReindexData()
   Method LoadData()
   Method SaveData()

   Method AppendData( cPath, cPathFrom )

   Method DefControl()                       VIRTUAL

   METHOD CheckExtendInfo()
   METHOD ShowExtendInfo( nRow, nCol, cToolTip )
   METHOD DestroyToolTip()
   METHOD FastFilter()

   METHOD SetAutoFilter()

   METHOD AplyFilter()                       
   METHOD ChangeFilter( cFilter )            INLINE ( msgStop( cFilter ) )

   METHOD EnableComboFilter( aFilter )       INLINE ( ::oWndBar:EnableComboFilter( aFilter ) )
   METHOD SetDefaultComboFilter( aFilter )   INLINE ( ::oWndBar:SetDefaultComboFilter( aFilter ) )
   METHOD SetComboFilter( cItem )            INLINE ( ::oWndBar:SetComboFilter( cItem ) )

   METHOD ToExcel()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New(  nTop, nLeft, nBottom, nRight, cTitle, oMenu, oWnd, oIcon,;
             oCursor, lPixel, nHelpId, aFlds, xAlias, aHeaders,;
             aColSizes, aColSelect, aJustify, aPrompt, bAdd, bEdit, bDel,;
             bDup, nSizeBtn, nLevel, cMru, cBitmap, lBigStyle, bZoo, lXBrowse ) CLASS TShell

   local n
   local nPos
   local aRect

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
   DEFAULT cBitmap   := Rgb( 0, 0, 0 )
   DEFAULT lBigStyle := .f.

   ::oWndBar         := oWndBar()

   ::BarDisable()

   //Adaptamos la longitud de pantalla a la resoluci�n------------------------------------

   aRect             := GetWndRect( GetDeskTopWindow() )
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
   
   ::bAdd            := bAdd
   ::bEdit           := bEdit
   ::bDel            := bDel
   ::bDup            := bDup
   ::bZoo            := bZoo

   if IsObject( xAlias )
      ::xAlias       := xAlias:cAlias
   else
      ::xAlias       := xAlias
   end if

   // Fuentes en funcion del estilo

   ::setFont( oFontLittelTitle() )
   // ::oFont           := oFontLittelTitle()

   // Tama�o de la ventana siempre a pixels---------------------------------------

   ::nTop            := nTop    * if( !lPixel, MDIC_CHARPIX_H, 1 )
   ::nLeft           := nLeft   * if( !lPixel, MDIC_CHARPIX_W, 1 )
   ::nBottom         := nBottom * if( !lPixel, MDIC_CHARPIX_H, 1 )
   ::nRight          := nRight  * if( !lPixel, MDIC_CHARPIX_W, 1 )

   // Fin de la captura del error----------------------------------------------

   ::lAutoSeek       := .f.

   // Objeto de filtrado-------------------------------------------------------

   ::oActiveFilter   := TFilterCreator():Init( Self )

   /*
   Llamada al objeto padre para que se cree
   ----------------------------------------------------------------------------
   */

   ::Super:New( 0, 0, 0, 0, cTitle, 0, oMenu, oWnd, oIcon, , , , oCursor, , .t., , nHelpId, "NONE", .f., .f., .f., .f. )

   // Imagelist----------------------------------------------------------------

   if ::lBigStyle
      ::oImageList      := TImageList():New( 32, 32 )
   else
      ::oImageList      := TImageList():New( 16, 16 )
   end if

   // Barra de botones---------------------------------------------------------
   /*
   if file( cBitmap )
     ::oBtnTop          := TWebBar():New( 0, 0, 400, dfnSplitterHeight,, ( cBitmap ),, Rgb( 0, 0, 0 ), Rgb( 255, 255, 255 ),,,,,, Self )
   else
   end
   */

   if IsNum( cBitmap )
   ::oBtnTop            := TWebBar():New( 0, 0, 400, dfnSplitterHeight,,,, Rgb( 255, 255, 255 ), ( cBitmap ),,,,,, Self )
   else
   ::oBtnTop            := TWebBar():New( 0, 0, 400, dfnSplitterHeight,,,, Rgb( 255, 255, 255 ), clrTopArchivos,,,,,, Self )
   end if

   ::oBtnTop:Say( -14, dfnTreeViewWidth, ::cTitle ) // antes primera coordenada en 6

   ::oBtnBar            := TTreeView():New( dfnSplitterHeight, 0, Self, , , .t., .f., dfnTreeViewWidth, 400 ) // Rgb( 51, 51, 51 )

   ::oBtnBar:SetItemHeight( 20 )
   // ::oBtnBar:SetFont( oFontLittelTitle() )

   ::oBtnBar:OnClick    := {|| ::ClickTree() }

   if !::lBigStyle
      ::oBtnMain        := ::oBtnBar:Add( ::cTitle, ::AddImageList( cMru ) )
   end if

   // Nombre de la ventana-----------------------------------------------------

   if At( ":", ::cTitle ) != 0
      ::cWinName        := Padr( SubStr( ::cTitle, 1, At( ":", ::cTitle ) ), 30 )
   else
      ::cWinName        := Padr( Rtrim( ::cTitle ), 30 )
   end if

   // Uauario en curso---------------------------------------------------------

   ::cCodigoUsuario     := cCurUsr()

   // Nivel de Acceso----------------------------------------------------------

   ::nLevel             := nLevel

   // Montamos el objeto browse------------------------------------------------

   if !::CreateXBrowse()
      Return .f.
   end if

   ::oHorizontalSplitter         := TSplitter():New( dfnSplitterHeight , 0, .f., { ::oBtnTop }, .t., { ::oBtnBar, ::oBrw }, .t., {|| 0}, {|| 0}, Self, , 800, 0, .t., .t., Rgb( 255, 255, 255 ), .f., .f., .f. )
   ::oHorizontalSplitter:lStatic := .t.

   ::oVerticalSplitter           := TSplitter():New( dfnSplitterHeight + dfnSplitterWidth, dfnTreeViewWidth, .t., { ::oBtnBar }, .t., { ::oBrw }, .t., {|| 0}, {|| 0}, Self, , dfnSplitterWidth, 800, .t., .f., , .f., .t., .t. ) // 160

RETURN Self

//----------------------------------------------------------------------------//

METHOD Activate(  cShow, bLClicked, bRClicked, bMoved, bResized, bPainted,;
                  bKeyDown, bInit, bUp, bDown, bPgUp, bPgDn,;
                  bLeft, bRight, bPgLeft, bPgRight, bValid, bDropFiles,;
                  bLButtonUp, lCenter ) CLASS TShell

   local oError
   local oBlock

   DEFAULT lCenter   := ( ::nTop == 0 .and. ::nLeft == 0 )

   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   CursorWait()

   if Empty( bValid )
      bValid         := {|| ::oBrw:Hide() }
   end if

   ::lCenter         := lCenter

   ::Super:Activate(    cShow, bLClicked, bRClicked, bMoved, bResized, bPainted,;
                        bKeyDown, bInit, bUp, bDown, bPgUp, bPgDn, bLeft, bRight,;
                        bPgLeft, bPgRight, bValid, bDropFiles, bLButtonUp )

   ::Maximize()

   if !::lBigStyle
      ::oHorizontalSplitter:AdjRight()
   end if

   ::oVerticalSplitter:AdjBottom()

   ::oBtnBar:SetImagelist( ::oImageList )

   ::oBtnBar:Select( ::oBtnMain )

   ::oBtnMain:Expand()

   // Seleccion de oden de la columna------------------------------------------

   if ( ::xAlias )->( Used() ) .and. !Empty( ::oBrw )
      aEval( ::oBrw:aCols, {|oCol| if( oCol:cSortOrder == ( ::xAlias )->( OrdSetFocus() ), ( oCol:SetOrder(), oCol:Adjust() ), ) } )
   end if

   // Filtro por defecto----------------------------------------------------

   ::oActiveFilter:FiltersName() 

   // Preparamos la ventana principal---------------------------------------

   if !Empty( ::oWndBar )

      ::oWndBar:EnableComboBox( ::aPrompt )

      if !Empty( ::oActiveFilter:Ready() )
         ::EnableComboFilter( ::oActiveFilter:aFiltersName )
         ::SetDefaultComboFilter()
         ::ShowAddButtonFilter()
      end if 

      ::oWndBar:EnableGet()

      if ::lFechado
         ::oWndBar:ShowYearCombobox()
      end if

      if !Empty( ::nTab ) 
         ::ChgCombo( ::nTab )
      end if

   end if

   CursorWE()

   RECOVER USING oError

      msgStop( "Error al iniciar al abrir las bases de datos" + CRLF + ErrorMessage( oError ) )

      ::End()

   END SEQUENCE

   ErrorBlock( oBlock )

   ::BarEnable()

RETURN NIL

//----------------------------------------------------------------------------//

METHOD GotFocus() CLASS TShell

	::Super:GotFocus()

   if ::oBrw != nil
		::oBrw:SetFocus()
   end if

return 0

//----------------------------------------------------------------------------//

METHOD KeyChar( nKey, nFlags ) CLASS TShell

   do case
   case nKey == VK_ESCAPE .and. ::oWnd != nil
      if ( ::oTxtSea != nil .and. GetFocus() == ::oTxtSea:hWnd ) 
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
   case nKey == VK_F9
      ::oBrw:Refresh()
   end

return ::Super:KeyChar( nKey, nFlags )

//----------------------------------------------------------------------------//

Method KeySearch( nKey, nFlags, oWndBar )

   if ( nKey == VK_ESCAPE .or. nKey == VK_RETURN )
      ::BrwEnable()
      ::GotFocus()
      Return ( 0 )
   end if

Return ( 1 )

//----------------------------------------------------------------------------//

METHOD NewAt( cResName1, cResName2, cMsg, bAction, cToolTip, cKey, cPrompt, bMenu, nLevel, oGroup, lAllowExit ) CLASS TShell

   local oBtn

   DEFAULT cMsg         := ""
   DEFAULT oGroup       := nil
   DEFAULT cToolTip     := ""
   DEFAULT lAllowExit   := .f.

   // Chequeamos los niveles de acceso si es mayor no montamos el boton

   if nLevel != nil .and. nAnd( ::nLevel, nLevel ) == 0
      return nil
   end if

   if !Empty( cResName1 )
      if ::lBigStyle
         cResName1   += "32"
      else
         cResName1   += "16"
      end if
   end if

   cToolTip          := StrTran( cToolTip, "(", "" )
   cToolTip          := StrTran( cToolTip, ")", ""  )

   if Empty( oGroup )
      if ::lBigStyle
         oBtn        := ::oBtnBar:Add( cTooltip, ::AddImageList( cResName1 ), bAction )
      else
         oBtn        := ::oBtnMain:Add( cTooltip, ::AddImageList( cResName1 ), bAction )
      end if
   else
      if Empty( cResName1 )
         oBtn        := oGroup:Add( cTooltip, nil, bAction )
      else
         oBtn        := oGroup:Add( cTooltip, ::AddImageList( cResName1 ), bAction )
      end if
   end if

   oBtn:Cargo        := lAllowExit

   if cKey != nil

      if Valtype( cKey ) == "C"
         cKey        := Upper( cKey )
      end if

      aAdd( ::aFastKey, { cKey, bAction } )

   end if

return oBtn

//----------------------------------------------------------------------------//

METHOD CtrlKey( nKey ) CLASS TShell

   local nLen
   local nCont

   if !::lOnProcess

      nLen        := len( ::aFastKey )

      for nCont   := 1 to nLen

         if ( IsChar( ::aFastKey[ nCont, 1 ] ) .and. ( nKey == Asc( Upper( ::aFastKey[ nCont, 1 ] ) ) .or. nKey == Asc( Lower( ::aFastKey[ nCont, 1 ] ) ) ) ) .or. ;
            ( IsNum( ::aFastKey[ nCont, 1 ] ) .and. nKey == ::aFastKey[ nCont, 1 ] )

            if ( nCont != 1 ) .and. ( nCont != nLen )
               ::SetOnProcess()
            end if

            Eval( ::aFastKey[ nCont, 2 ] )

            SysRefresh()

            ::QuitOnProcess()

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
/*
      if nKey == VK_ESCAPE
         ::End()
      end if
*/
   end if

return ( 0 )

//----------------------------------------------------------------------------//

METHOD KeyDown( nKey, nFlags ) CLASS TShell

   if ::lOnProcess
      Return 0
   end if

   if !( ::oBrw:lEditMode )
   
      do case
         case nKey == VK_ESCAPE
            ::End()
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
         case nKey == VK_F2
            ::NextTabOption()
         case nKey == VK_F3
            ::PrevTabOption()
      end case

   end if 

return ::Super:KeyDown( nKey, nFlags )

//---------------------------------------------------------------------------//

METHOD End( lForceExit ) CLASS TShell

   DEFAULT lForceExit         := .f.

   if ::lOnProcess .and. !lForceExit
      Return ( .f. )
   end if

   CursorWait()

   if !Empty( ::oToolTip )
      ::oToolTip:End()
   end if

   // Matamos los filtros por si los hubiera-----------------------------------

   ::KillFilter()

   ::oActiveFilter:End()

   if ::lOpenData

      // Guardamos la pos actual ----------------------------------------------

      if ( ::xAlias )->( Used() )
         ::nRec               := ( ::xAlias )->( RecNo() )
      end if 

      if !::lBigStyle .and. !Empty( ::oWndBar )
         ::nTab               := ::oWndBar:GetComboBoxAt( .t. )
      end if

      // Ventanas--------------------------------------------------------------

      ::SaveData( .f. )

      ::CloseData()

   end if

   // Barra de busqueda--------------------------------------------------------

   if !::lBigStyle .and. !Empty( ::oWndBar )

      ::oWndBar:DisableGet()

      ::oWndBar:DisableComboBox()

      ::oWndBar:DisableComboFilter()

      ::HideButtonFilter()
      ::HideAddButtonFilter()
      ::HideEditButtonFilter()

      if ::lFechado
         ::oWndBar:HideYearCombobox()
      end if

   end if

   // Cerramos el browse ------------------------------------------------------

   if !Empty( ::oBrw )
      ::oBrw:End()
      ::oBrw   := nil
   end if

   // Evaluamos el bValid------------------------------------------------------
/*
   if ::bValid != nil
      Eval( ::bValid )
   end if
*/
   ::oWndClient:ChildClose( Self )

   ::Super:End()

   ::Super:Destroy()

   CursorWE()

Return ( .t. )

//----------------------------------------------------------------------------//

METHOD Search() CLASS TShell

	local oDlg
   local oIndice
   local cIndice
   local oAutoSeek
   local oThis    := Self
   local xCadena  := Space( 100 )

   if len( ::aPrompt ) == 0
      msgStop( "No hay indices definidos" )
      return nil
   end if

   if ( ::xAlias )->( Used() )
      cIndice     := ::aPrompt[ ( ::xAlias )->( OrdNumber() ) ]
   end if 

   DEFINE DIALOG oDlg RESOURCE "SEARCH"

   REDEFINE COMBOBOX ::oTxtSea VAR xCadena;
      ITEMS       ::aLstSea ;
      ID          100 ;
      OF          oDlg ;
      STYLE       CBS_DROPDOWN

      ::oTxtSea:bValid        := {|| ::AddSearch() }
      ::oTxtSea:bChange       := {|| ::ChangeSeek( oIndice ) }

      ::oTxtSea:oGet:bChange  := {| nKey, nFlags | ::FastSeek( nKey, nFlags, ::oTxtSea ) }

   REDEFINE COMBOBOX oIndice VAR cIndice ;
      ID          101 ;
      ITEMS       ::aPrompt ;
      OF          oDlg

      oIndice:bChange         := {|| ::ChgIndex( oIndice ) }

   REDEFINE CHECKBOX oAutoSeek VAR ::lAutoSeek ;
      ID          102 ;
      OF          oDlg ;

   REDEFINE BUTTON ;
      ID          510 ;
      OF          oDlg ;
      ACTION      ( oDlg:end() )

   ACTIVATE DIALOG oDlg CENTER VALID ( oThis:AddSearch() )

RETURN NIL

//--------------------------------------------------------------------------//
/*
Suma la ultima busqueda
*/

METHOD AddSearch() CLASS TShell

   local nRec

   CursorWait()

   ::oWndBar:CleanGet()

   if ( ::xAlias )->( Used() )

      nRec  := ( ::xAlias )->( Recno() )

      ( ::xAlias )->( OrdScope( 0, nil ) )
      ( ::xAlias )->( OrdScope( 1, nil ) )

      ( ::xAlias )->( dbGoTo( nRec ) )

   end if 

   // ::oBrw:Refresh()

   CursorWE()

RETURN .t.

//----------------------------------------------------------------------------//

/*
Cambia el indice actual
*/

METHOD ChgIndex( oIndice ) CLASS TShell

   if ( ::xAlias )->( Used() )
      ( ::xAlias )->( OrdSetFocus( oIndice:nAt ) )
   end if

   if !Empty( ::oWndBar )
      ::oWndBar:SetComboBoxSelect( oIndice:nAt )
   end if

   ::oComboBox:Select( oIndice:nAt )

   // Evento de cambio de indices----------------------------------------------

   if !Empty( ::bChgIndex )
      Eval( ::bChgIndex )
   end if

   ::oBrw:SetOrder()

   ::oTxtSea:SetFocus()
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

   if ( ::xAlias )->( Used() )
      ( ::xAlias )->( OrdSetFocus( n ) )
      cType       := ValType( ( ::xAlias )->( OrdKey() ) )
   end if

   oIndice:Set( nOrd )

   if !Empty( ::oWndBar )
      ::oWndBar:SetComboBoxSelect( nOrd )
   end if

   ::oComboBox:Select( nOrd )

   do case
   case IsChar( cType )
      xCadena     := Rtrim( oGet:GetText() )
   case IsNum( cType )
      xCadena     := Val( Rtrim( oGet:GetText() ) )
   end case 

   if ( ::xAlias )->( Used() )
      ( ::xAlias )->( dbSeek( xCadena ) )
   end case

   ::oBrw:Refresh()

RETURN .T.

//--------------------------------------------------------------------------//
/*
Realiza busquedas de manera progresiva
*/

METHOD FastSeek( oGet, xCadena ) CLASS TShell

   local nRec
   local cOrd
   local oCol
   local lSeek
   local cAlias

   cAlias            := ::xAlias

   if Empty( cAlias ) .or. !( cAlias )->( Used() )
      Return .f.
   end if

   CursorWait()

   /*
   Estudiamos la cadena de busqueda
   */

   xCadena           := Alltrim( Upper( cValToChar( xCadena ) ) )
   xCadena           := StrTran( xCadena, Chr( 8 ), "" )

/*
   if Empty( xCadena )
      Return .f.
   end if*/

   /*
   Guradamos valores iniciales-------------------------------------------------
   */

   nRec              := ( cAlias )->( RecNo() )
   cOrd              := ( cAlias )->( OrdSetFocus() )

   /*
   Comenzamos la busqueda------------------------------------------------------
   */

   lSeek             := ::FastFilter( xCadena, cAlias ) // 

   if !lSeek

      lSeek          := lMiniSeek( nil, xCadena, cAlias )

      // Si no conseguimos encontrarla en el orden actial nos movemos por todos los posibles ordendenes del browse

      if !lSeek .and. uFieldEmpresa( "lBusCir" )

         for each oCol in ::oBrw:aCols

            if isChar( oCol:cSortOrder ) .and. !Empty( oCol:cSortOrder )

               ( cAlias )->( OrdSetFocus( oCol:cSortOrder ) )

               lSeek := lMiniSeek( nil, xCadena, cAlias )

               if lSeek
                  ::ClickOnHeader( oCol )
                  exit
               end if

            end if

         next

      end if

   end if

   if lSeek .or. !Empty( xCadena )

      oGet:SetColor( Rgb( 0, 0, 0 ), Rgb( 255, 255, 255 ) )

   else

      oGet:SetColor( Rgb( 255, 255, 255 ), Rgb( 255, 102, 102 ) )

   end if

   ::oBrw:Select( 0 )
   ::oBrw:Select( 1 )
   ::oBrw:Refresh( .t. )

   CursorWE()

Return ( lSeek )

//--------------------------------------------------------------------------//

METHOD FastFilter( xCadena, cAlias )

   DestroyFastFilter( cAlias, .f., .f. )

   CreateFastFilter( "", cAlias, .f. )

   if Left( xCadena, 1 ) == "*"

      if Right( xCadena, 1 ) == "*" .and. len( Rtrim( xCadena ) ) > 1

         CreateFastFilter( SubStr( xCadena, 2, len( xCadena ) - 2 ), cAlias, .t. )

         ::SetKillFilter( {|| DestroyFastFilter( cAlias ), ::HideButtonFilter() } )

         ::ShowButtonFilter()
         ::ShowAddButtonFilter()
         ::ShowEditButtonFilter()

      else

         ::HideButtonFilter()
         ::HideAddButtonFilter()
         ::HideEditButtonFilter()

      end if

      Return .t.

   end if

Return .f.

//----------------------------------------------------------------------------//

METHOD RButtonDown( nRow, nCol, nFlags ) CLASS TShell

   local nFor
   local nLen
   local oCol
   local oMenuItem
   local oMenu       := MenuBegin( .t. )
   local bMenuSelect := ::bMenuSelect

   /*
   Montamos el menu------------------------------------------------------------
   */

   ::bMenuSelect     := nil

   MenuAddItem( "Columnas", "Columnas de la rejilla de datos", .f., .t., , , "Column_16", oMenu )

   MenuBegin( .f.,,, .f. )

   for each oCol in ::oBrw:aCols
      MenuAddItem( oCol:cHeader, , !oCol:lHide, ( Len( ::oBrw:aDisplay ) != 1 .or. oCol:nPos != 1 ), GenMenuBlock( oCol ) )
   next

   MenuEnd()

   MenuAddItem( "Guardar vista actual", "Guarda la vista actual de la rejilla de datos", .f., .t., {|| ::SaveData() }, , "Column_Disk_16", oMenu )

   MenuAddItem( "Cargar vista por defecto", "Carga la vista por defecto de la rejilla de datos", .f., .t., {|| ::PutOriginal() }, , "Column_Refresh_16", oMenu )

   MenuAddItem()

   MenuAddItem( "Seleccionar &todo", "Selecciona todas las filas de la rejilla", .f., .t., {|| ::oBrw:SelectAll() }, , "Table_Selection_All_16", oMenu )

   MenuAddItem( "&Quitar selecci�n", "Quita la selecci�n de todas las filas de la rejilla", .f., .t., {|| ::oBrw:SelectNone() }, , "Table_Sql_16", oMenu )

   MenuAddItem()

   MenuAddItem( "Exportar a E&xcel", "Exportar rejilla de datos a Excel", .f., .t., {|| ::ToExcel() }, , "Text_Sum_16", oMenu )

   MenuEnd()

   oMenu:Activate( nRow, nCol, ::oBrw )

   ::bMenuSelect := bMenuSelect

   oMenu:end() 

   if !Empty( ::oBrw )
      ::oBrw:SetFocus()
   end if

Return nil

//---------------------------------------------------------------------------//

static function GenMenuBlock( oCol )

return {|| iif( oCol:lHide, oCol:Show(), oCol:Hide() ) }

//----------------------------------------------------------------------------//

METHOD AddMru() CLASS TShell

   if Empty( ( ::xAlias )->( OrdSetFocus() ) )
      MsgInfo( LoadString( GetResources(), 15 ) )
      Return nil
   end if

RETURN NIL

//---------------------------------------------------------------------------//

METHOD RecDel() CLASS TShell

   if nAnd( ::nLevel, ACC_DELE ) != 0 .and. !Empty( ::bDel )

      ::SetOnProcess()

      Eval( ::bDel )

      ::QuitOnProcess()

      ::Refresh()

      ::SetFocus()

   end if

RETURN NIL

//----------------------------------------------------------------------------//

METHOD RecAdd() CLASS TShell

   if nAnd( ::nLevel, ACC_APPD ) != 0 .and. !Empty( ::bAdd )

      ::SetOnProcess()

      Eval( ::bAdd )

      ::QuitOnProcess()

      ::Refresh()

      ::SetFocus()

   else

      msgStop( "Acceso no permitido" )

   end if

RETURN NIL

//----------------------------------------------------------------------------//

METHOD RecEdit()

   if nAnd( ::nLevel, ACC_EDIT ) != 0 .and. !Empty( ::bEdit )

      ::SetOnProcess()

      Eval( ::bEdit )

      if !Empty( ::oBrw )
         ::oBrw:Refresh()
      end if

      ::QuitOnProcess()

      ::SetFocus()

   else

      msgStop( "Acceso no permitido" )

   end if

RETURN NIL

//----------------------------------------------------------------------------//

METHOD RecDup()

   if nAnd( ::nLevel, ACC_APPD ) != 0 .and. !Empty( ::bDup )

      ::SetOnProcess()

      Eval( ::bDup )

      ::QuitOnProcess()

      ::Refresh()

      ::SetFocus()

   else

      msgStop( "Acceso no permitido" )

   end if

RETURN NIL

//----------------------------------------------------------------------------//

METHOD RecZoom()

   if nAnd( ::nLevel, ACC_ZOOM ) != 0 .AND. !Empty( ::bZoo )

      ::SetOnProcess()

      Eval( ::bZoo )

      ::QuitOnProcess()

      ::SetFocus()

   else

      msgStop( "Acceso no permitido" )

   end if

RETURN NIL

//----------------------------------------------------------------------------//
//
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
      nOrd     := ( ::xAlias )->( OrdSetFocus( nOrd ) )
      cType    := ValType( ( ::xAlias )->( OrdKey() ) )

      ::oBrw:GoTop()

      if cType == "C"
         xKey  := ::aLstSea[ nKey ]
      elseif cType == "N"
         xKey  := Val( ::aLstSea[ nKey ] )
      end if

      ( ::xAlias )->( dbSeek( ::aLstSea[ nKey ] ) )
      ( ::xAlias )->( OrdSetFocus( nOrd ) )

      ::oBrw:SetFocus()
      ::oBrw:Refresh()

   end if

return  nil

//----------------------------------------------------------------------------//

static function bSeaSeek( n, Self )
return {|| SeaSeek( n, Self ) }

//----------------------------------------------------------------------------//

METHOD SaveOriginal() CLASS TShell

   ::aOriginal := ::oBrw:SaveState()

return nil

//----------------------------------------------------------------------------//

METHOD PutOriginal() CLASS TShell

   ::oBrw:RestoreState( ::aOriginal )

   /*
   Vamos al principio----------------------------------------------------------
   */

   if ( ::xAlias )->( Used() )
      ( ::xAlias )->( dbGoTop() )
   end if 

return nil

//----------------------------------------------------------------------------//

static function bSelColumn( nFor, Self )
return {|| ::aColSelect[ nFor ] := !::aColSelect[ nFor ], ::SetColumn() }

//----------------------------------------------------------------------------//

METHOD SetColumn( lChanged ) CLASS TShell

   local aData       := _aData( ::aFlds, ::aColSelect )
   local aHeaders    := _aColHead( ::aHeaders, ::aColSelect )
   local aColSizes   := _aColSize( ::aColSizes, ::aColSelect )
   local aJustify    := _aColJustify( ::aJustify, ::aColSelect )

   if lChanged != nil
      ::lChanged     := lChanged
   end if

   ::oBrw:SetCols( aData, aHeaders, aColSizes )
   ::oBrw:aJustify   := aJustify
   ::oBrw:Refresh()

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

METHOD AutoButtons( oParent ) CLASS TShell

   ::GralButtons( oParent )

   ::EndButtons( oParent )

return nil

//----------------------------------------------------------------------------//

METHOD GralButtons( oParent ) CLASS TShell

   DEFINE BTNSHELL RESOURCE "BUS" OF Self ;
      NOBORDER ;
      ACTION   ( ::SearchSetFocus() ) ;
      TOOLTIP  "(B)uscar" ;
      HOTKEY   "B";

      ::AddSeaBar()

   if !Empty( ::bAdd )

   DEFINE BTNSHELL RESOURCE "NEW" OF Self ;
      NOBORDER ;
      ACTION   ( ::RecAdd() );
      ON DROP  ( ::RecAdd() );
      TOOLTIP  "(A)�adir";
      BEGIN GROUP ;
      HOTKEY   "A" ;
      LEVEL    ACC_APPD

   end if

   if !Empty( ::bDup )

   DEFINE BTNSHELL RESOURCE "DUP" OF Self ;
      NOBORDER ;
      ACTION   ( ::RecDup() );
      TOOLTIP  "(D)uplicar";
      HOTKEY   "D" ;
      LEVEL    ACC_APPD

   end if

   if !Empty( ::bEdit )

   DEFINE BTNSHELL RESOURCE "EDIT" OF Self ;
      NOBORDER ;
      ACTION   ( ::RecEdit() );
      TOOLTIP  "(M)odificar";
      HOTKEY   "M" ;
      LEVEL    ACC_EDIT

   end if

   if !Empty( ::bZoo )

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

   if oParent:lReport

   DEFINE BTNSHELL RESOURCE "IMP" OF Self ;
      NOBORDER ;
      ACTION   ( oParent:Report() ) ;
      TOOLTIP  "(L)istado" ;
      HOTKEY   "L" ;
      LEVEL    ACC_IMPR

   end if

return nil

//----------------------------------------------------------------------------//

METHOD EndButtons( oParent ) CLASS TShell

   if oParent != nil

   DEFINE BTNSHELL RESOURCE "END" GROUP OF Self ;
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
      cRet     := "S"
	CASE cType == "C"
      cRet     := Space( nLen )
	CASE cType == "N"
      cRet     := 0
	CASE cType == "D"
      cRet     := date()
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
      msgStop( "Expresi�n " + rtrim( cExp ) + " no valida" )
		cExp	:= NIL
   ELSE
      cExp  := &( "{|| " + cExp + " }" )
   END IF

RETURN cExp

//--------------------------------------------------------------------------//

STATIC FUNCTION cGetVal( xVal )

	local cTemp
   local cType := Valtype( xVal )

   do case
   case cType == "C"

		IF Upper( xVal ) 		== "S"
			cTemp := ".T."
		ELSEIF Upper( xVal ) == "N"
			cTemp := ".F."
		ELSE
			xVal	:= rtrim( xVal )
			cTemp := '"' + cValToChar( xVal ) + '"'
		END IF

   case cType == "N"

		cTemp := cValToChar( xVal )

   case cType == "D"

		cTemp := 'CTOD( "' + cValToChar( xVal ) + '" )'

   end case

RETURN ( cTemp )

//---------------------------------------------------------------------------//

METHOD Maximize() CLASS TShell

   local oWnd

   oWnd        := GetWndFrame()

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
      ::Super:SysCommand( nWParam, nLParam )
   endif

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

   if ::oImageList != nil
      ::oImageList:End()
   end if

   if ::oHorizontalSplitter != nil
      ::oHorizontalSplitter:End()
   end if

   if ::oVerticalSplitter != nil
      ::oVerticalSplitter:End()
   end if

   if ::hWnd != 0
      ::Super:Destroy()
   endif

   if ::bDestroy != nil
      Eval( ::bDestroy )
   end if

return ( Self )

//----------------------------------------------------------------------------//

METHOD ChgTabs( nTab ) CLASS TShell

   DEFAULT nTab   := ::oTabs:nOption

   if ( ::xAlias )->( Used() )
      (::xAlias)->( dbSetOrder( nTab ) )
   end if

   // Evento de cambio de indices----------------------------------------------

   if !Empty( ::bChgIndex )
      Eval( ::bChgIndex )
   end if

   // Refresco del browse------------------------------------------------------

   ::oBrw:Refresh()

   if ::oTxtSea != nil .and. ::oTxtSea:ClassName() == "TGET"
      ::oTxtSea:oGet:Home()
      ::oTxtSea:cText( Space( 100 ) )
   end if

return ( Self )

//----------------------------------------------------------------------------//

METHOD ChgCombo( nTab ) CLASS TShell

   local oCol
   local cOrd                 := ""

   if Empty( nTab ) .and. !Empty( ::oWndBar )
      nTab                    := ::oWndBar:GetComboBoxAt( .t. )
   end if

   nTab                       := Max( nTab, 1 )

   if !Empty( ::oWndBar )
      ::oWndBar:SetComboBoxSelect( nTab )
   end if

   // Evento de cambio de indices----------------------------------------------

   if !Empty( ::bChgIndex )
      Eval( ::bChgIndex )
   end if

   // Orden actual ------------------------------------------------------------

   if !Empty( ::oWndBar )
      cOrd                    := ::oWndBar:GetComboBox()
   end if

   // Refresco-----------------------------------------------------------------

   if !Empty( ::oBrw ) .and. !Empty( cOrd )

      with object ::oBrw

         if ( ::xAlias )->( Used() )

            for each oCol in :aCols

               if Equal( cOrd, oCol:cHeader )
                  oCol:cOrder       := "A"
                  oCol:SetOrder()
               else
                  oCol:cOrder       := " "
               end if

            next

         end if 

      end with

      // Aplicamos el filtro---------------------------------------------------

      ::AplyFilter()

      // Refresco--------------------------------------------------------------

      ::oBrw:Refresh()

   end if

return ( Self )

//----------------------------------------------------------------------------//

METHOD AddSeaBar() CLASS TShell

   if !Empty( ::oWndBar )

      ::oWndBar:SetComboBoxChange(     {|| ::ChgCombo() } )
      ::oWndBar:SetComboFilterChange(  {|| ::ChgFilter() } )

      ::oWndBar:SetGetLostFocus(       {|| ::AddSearch() } )
      ::oWndBar:SetKillFilter(         {|| ::KillFilter() } )

      ::oWndBar:SetAddButtonFilter(    {|| ::AddFilter() } )
      ::oWndBar:SetEditButtonFilter(   {|| ::EditFilter() } )

      ::oWndBar:SetGetPostKey(         {| oGet, cText  | ::FastSeek( oGet, cText ) } )
      ::oWndBar:SetGetKeyDown(         {| nKey, nFlags | ::KeySearch( nKey ) } )

   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD SetIndex( nOrd ) CLASS TShell

   if ( ::xAlias )->( Used() )
      ( ::xAlias )->( dbSetOrder( nOrd ) )
   end if 

   if !Empty( ::oWndBar )
      ::oWndBar:SetComboBoxSelect( nOrd )
   end if

   ::oComboBox:Select( nOrd )

   ::oBrw:Refresh()

RETURN nil

//----------------------------------------------------------------------------//

METHOD NextTabOption() CLASS TShell

   local nOpt

   if !Empty( ::oWndBar )

      nOpt        := ::oWndBar:GetComboBoxAt( .t. )

      if nOpt < len( ::aPrompt )
         nOpt++
         ::ChgCombo( nOpt )
      end if

   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD PrevTabOption() CLASS TShell

   local nOpt

   if !Empty( ::oWndBar )

      nOpt  := ::oWndBar:GetComboBoxAt( .t. )

      if nOpt > 1
         nOpt--
         ::ChgCombo( nOpt )
      end if

   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD lPressCol( nCol ) CLASS TShell

   local nPos
   local cHeader

   if !Empty( nCol ) .and. nCol <= len( ::oBrw:aHeaders )

      cHeader     := ::oBrw:aHeaders[ nCol ]

      nPos        := aScan( ::aPrompt, cHeader )
      if nPos     != 0

         ::oWndBar:SetComboBoxSet( cHeader )

         if ( ::xAlias )->( Used() )
            ( ::xAlias )->( OrdSetFocus( ::oWndBar:GetComboBoxAt() ) )
         end if 

         ::oBrw:Refresh()

      end if

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ClickOnHeader( oCol ) CLASS TShell

   if !Empty( oCol )
      if aScan( ::aPrompt, oCol:cHeader ) != 0
         ::oWndBar:SetComboBoxSet( oCol:cHeader )
         oCol:SetOrder()
      end if
   end if

   ::AplyFilter()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD HelpTopic() CLASS TShell

   if !Empty( ::cHtmlHelp )
      HtmlHelp( ::cHtmlHelp )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

Method AddGoTo( cCaption, bAction )

   aAdd( ::aGoTo, { cCaption, bAction } )

Return ( Self )

//---------------------------------------------------------------------------//

Method AddImageList( cImage )

   local oImage
   local nImageList     := 0

   if !Empty( cImage )
      oImage            := TBitmap():Define( cImage )
      oImage:cResName   := cImage
      ::oImageList:AddMasked( oImage, Rgb( 255, 0, 255 ) )
      nImageList        := len( ::oImageList:aBitmaps ) - 1
   end if

Return ( nImageList )

//---------------------------------------------------------------------------//

Method ClickTree()

   local oItem       := ::oBtnBar:GetSelected()

   if !Empty( oItem ) .and. oItem:ClassName() == "TTVITEM" .and. Valtype( oItem:bAction ) == "B"

      if !::lOnProcess

         if !( oItem:cPrompt $ "Salir" ) .and. !oItem:Cargo
            ::SetOnProcess()
         end if

         Eval( oItem:bAction )

         if ::oBtnMain != nil
            ::oBtnBar:Select( ::oBtnMain )
         end if

         ::QuitOnProcess()

      end if

      if !( oItem:cPrompt $ "Buscar" )
         if !Empty( ::oBrw )
            ::oBrw:SetFocus()
         end if
      end if

   end if

Return ( Self )

//---------------------------------------------------------------------------//

Method OpenData( cPath )

   local oBlock
   local oError

   DEFAULT cPath        := cPatEmp()

   if !lExistTable( cPath + "CfgUse.Dbf" ) .or. !lExistTable( cPatEmp() + "CfgCol.Dbf" )
      ::CreateData( cPath )
   end if

   if !lExistIndex( cPath + "CfgUse.Cdx" ) .or. !lExistIndex( cPatEmp() + "CfgCol.Cdx" )
      ::ReindexData( cPath )
   end if

   oBlock               := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      dbUseArea( .t., cDriver(), ( cPath + "CfgUse.Dbf" ), ( ::dbfUsr := cCheckArea( "CfgUse" ) ), .t. )
      if ( !lAIS(), ( ::dbfUsr )->( OrdListAdd( cPath + "CfgUse.Cdx" ) ), ( ::dbfUsr )->( OrdSetFocus( 1 ) ) ) 

      dbUseArea( .t., cDriver(), ( cPath + "CfgCol.Dbf" ), ( ::dbfCol := cCheckArea( "CfgCol" ) ), .t. )
      if ( !lAIS(), ( ::dbfCol )->( OrdListAdd( cPath + "CfgCol.Cdx" ) ), ( ::dbfCol )->( OrdSetFocus( 1 ) ) )

   RECOVER USING oError

      ::lOpenData       := .f.
      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( Self )

//---------------------------------------------------------------------------//

Method CreateData( cPath )

   DEFAULT cPath  := cPatEmp()

   if !lExistTable( cPath + "CfgUse.Dbf" )
      dbCreate( cPath + "CfgUse.Dbf", aSqlStruct( aItmHea() ), cDriver() )
   end if

   if !lExistTable( cPath + "CfgCol.Dbf" )
      dbCreate( cPath + "CfgCol.Dbf", aSqlStruct( aItmCol() ), cDriver() )
   end if

   ::ReindexData( cPath )

Return ( Self )

//---------------------------------------------------------------------------//

Method ReindexData( cPath )

   local dbfUse
   local dbfCol

   DEFAULT cPath  := cPatEmp()

   if !lExistTable( cPath + "CfgUse.Dbf" ) .or. !lExistTable( cPath + "CfgCol.Dbf" )
      ::CreateData( cPath )
   end if

   dbUseArea( .t., cDriver(), cPath + "CfgUse.Dbf", cCheckArea( "CfgUse", @dbfUse ), .f. )

   if !( dbfUse )->( neterr() )

      ( dbfUse )->( __dbPack() )

      ( dbfUse )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfUse )->( ordCreate( cPath + "CfgUse.Cdx", "cCodUse", "cCodUse + cNomCfg", {|| Field->cCodUse + Field->cNomCfg } ) )

      ( dbfUse )->( dbCloseArea() )

   else

      msgStop( "Imposible abrir en modo exclusivo la tabla de ventanas" )

   end if

   dbUseArea( .t., cDriver(), cPath + "CfgCol.Dbf", cCheckArea( "CfgCol", @dbfCol ), .f. )

   if !( dbfCol )->( neterr() )

      ( dbfCol )->( __dbPack() )

      ( dbfCol )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfCol )->( ordCreate( cPath + "CfgCol.Cdx", "cCodUse", "cCodUse + cNomCfg + Str( nNumCol )", {|| Field->cCodUse + Field->cNomCfg + Str( Field->nNumCol ) } ) )

      ( dbfCol )->( dbCloseArea() )

   else

      msgStop( "Imposible abrir en modo exclusivo la tabla de configuraci�n de ventanas" )

   end if

Return ( self )

//---------------------------------------------------------------------------//

Method AppendData( cPath, cPathFrom )

   ::OpenData( cPath )

   if ::lOpenData

      if file( cPathFrom + "CfgCol.Dbf" )
         ( ::dbfCol )->( __dbApp( cPathFrom + "CfgCol.Dbf" ) )
      end if

      ::CloseData()

   end if

Return ( self )

//---------------------------------------------------------------------------//

Method LoadData()

   local n
   local oError
   local oBlock   := ErrorBlock( { | oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   if ( ::dbfUsr )->( dbSeek( ::cCodigoUsuario + ::cWinName ) )

      ::cCfg      := ( ::dbfUsr )->cBrwCfg
      ::nRec      := Max( ( ::dbfUsr )->nRecCfg, 1 )
      ::nTab      := Max( ( ::dbfUsr )->nTabCfg, 1 )

      if ::lAutoPos

         if ( ::xAlias )->( Used() )

            ( ::xAlias )->( dbGoTo( ::nRec ) )

            if ( ::xAlias )->( Recno() ) != ::nRec .or. ::nRec > ( ::xAlias )->( Lastrec() )
               ( ::xAlias )->( dbGoTop() )
            end if

         end if 

      end if

   end if

   // Vamos a obtener el orden de las columnas --------------------------------

   RECOVER USING oError

      msgStop( "Establecer la configuraci�n de columnas.", "Error" )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( Self )

//---------------------------------------------------------------------------//

Method SaveData( lSaveBrowseState )

   local n
   local nCols
   local oError
   local oBlock

   DEFAULT lSaveBrowseState      := .t.

   oBlock                        := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   // Datos del browse --------------------------------------------------------

   if !Empty( ::dbfUsr ) .and. ( ::dbfUsr )->( Used() )

      if ( ::dbfUsr )->( dbSeek( ::cCodigoUsuario + ::cWinName ) )

         if ( ::dbfUsr )->( dbRLock() )
            ( ::dbfUsr )->nRecCfg   := ::nRec
            ( ::dbfUsr )->nTabCfg   := ::nTab

            if lSaveBrowseState
            ( ::dbfUsr )->cBrwCfg   := ::oBrw:SaveState()
            end if
            ( ::dbfUsr )->( dbRUnLock() )
         end if

      else

         ( ::dbfUsr )->( dbAppend() )
         if !( ::dbfUsr )->( neterr() )
            ( ::dbfUsr )->cCodUse   := ::cCodigoUsuario
            ( ::dbfUsr )->cNomCfg   := ::cWinName
            ( ::dbfUsr )->nRecCfg   := ::nRec
            ( ::dbfUsr )->nTabCfg   := ::nTab
            if lSaveBrowseState
            ( ::dbfUsr )->cBrwCfg   := ::oBrw:SaveState()
            end if
            ( ::dbfUsr )->( dbRUnLock() )
         end if

      end if

      if lSaveBrowseState
         msgInfo( "Configuraci�n de columnas guardada." )
      end if

   end if

   RECOVER USING oError

      msgStop( "Imposible salvar las configuraciones de columnas" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( Self )

//---------------------------------------------------------------------------//

Method CleanData() CLASS TShell

   // Limpiar las configuraciones----------------------------------------------

   while ( ::dbfCol )->( dbSeek( ::cCodigoUsuario + ::cWinName ) )
      dbDel( ::dbfCol )
   end while

Return ( Self )

//---------------------------------------------------------------------------//

METHOD DeleteData() CLASS TShell

   if File( cPatEmp() + "CfgUse.Dbf" )
      fErase( cPatEmp() + "CfgUse.Dbf" )
   end if

   if File( cPatEmp() + "CfgUse.Cdx" )
      fErase( cPatEmp() + "CfgUse.Cdx" )
   end if

   if File( cPatEmp() + "CfgCol.Dbf" )
      fErase( cPatEmp() + "CfgCol.Dbf" )
   end if

   if File( cPatEmp() + "CfgCol.Cdx" )
      fErase( cPatEmp() + "CfgCol.Cdx" )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CloseData() CLASS TShell

   if !Empty( ::dbfUsr ) .and. ( ::dbfUsr )->( Used() )
      ( ::dbfUsr )->( dbCloseArea() )
   end if

   if !Empty( ::dbfCol ) .and. ( ::dbfCol )->( Used() )
      ( ::dbfCol )->( dbCloseArea() )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

Method CreateXBrowse() CLASS TShell

   local oError
   local oBlock
   local lCreateXBrowse    := .t.

   oBlock                  := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::oBrw                  := TXBrowse():New( Self )
      ::oBrw:nStyle           := nOr( WS_CHILD, WS_VISIBLE, WS_TABSTOP )
      ::oBrw:l2007            := .f.

      ::oBrw:lRecordSelector  := .f.

      // Propiedades del control ----------------------------------------------

      ::oBrw:nMarqueeStyle    := MARQSTYLE_HIGHLROWMS

      ::oBrw:bClrStd          := {|| { CLR_BLACK, CLR_WHITE } }
      ::oBrw:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrw:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oBrw:bRClicked        := {| nRow, nCol, nFlags | ::RButtonDown( nRow, nCol, nFlags ) }

/*
      if ( ::xAlias )->( Used() )

         ::oBrw:nDataType  := 0 // DATATYPE_RDD
         ::oBrw:cAlias     := ::xAlias
         ::oBrw:bGoTop     := {|| ( ::xAlias )->( dbGoTop() ) }
         ::oBrw:bGoBottom  := {|| ( ::xAlias )->( dbGoBottom() ) }
         ::oBrw:bSkip      := {| n | iif( n == nil, n := 1, ), ( ( ::xAlias )->( dbSkipper( n ) ), ) }
         ::oBrw:bBof       := {|| ( ::xAlias )->( Bof() ) }
         ::oBrw:bEof       := {|| ( ::xAlias )->( Eof() ) }
         ::oBrw:bBookMark  := {| n | iif( n == nil, ( ::xAlias )->( RecNo() ), ( ( ::xAlias )->( dbGoto( n ) ), ) ) }
         ::oBrw:bLock      := {|| ( ::xAlias )->( dbrLock() ) }
         ::oBrw:bUnlock    := {|| ( ::xAlias )->( dbrUnlock() ) }

         if lAIS()
         ::oBrw:bKeyNo     := {| n | iif( n == nil, Round( ( ::xAlias )->( ADSGetRelKeyPos() ) * ::oBrw:nLen, 0 ), ( ::xAlias )->( ADSSetRelKeyPos( n / ::oBrw:nLen ) ) ) }
         ::oBrw:bKeyCount  := {|| ( ::xAlias )->( ADSKeyCount(,,1) ) }
         else
         ::oBrw:bKeyNo     := {| n | iif( n == nil, ( ::xAlias )->( OrdKeyNo() ), ( ::xAlias )->( OrdKeyGoto( n ) ) ) }
         ::oBrw:bKeyCount  := {|| ( ::xAlias )->( OrdKeyCount() ) }
         end if

         ::oBrw:lFastEdit  := .t.

      end if 
*/

      ::oBrw:nDataType     := 0 // DATATYPE_RDD
      ::oBrw:cAlias        := ::xAlias
      ::oBrw:bGoTop        := {|| if( ( ::xAlias )->( Used() ), ( ::xAlias )->( dbGoTop() ), ) }
      ::oBrw:bGoBottom     := {|| if( ( ::xAlias )->( Used() ), ( ::xAlias )->( dbGoBottom() ), ) }
      ::oBrw:bBof          := {|| if( ( ::xAlias )->( Used() ), ( ::xAlias )->( Bof() ), ) }
      ::oBrw:bEof          := {|| if( ( ::xAlias )->( Used() ), ( ::xAlias )->( Eof() ), ) }
      ::oBrw:bLock         := {|| if( ( ::xAlias )->( Used() ), ( ::xAlias )->( dbrLock() ), ) }
      ::oBrw:bUnlock       := {|| if( ( ::xAlias )->( Used() ), ( ::xAlias )->( dbrUnlock() ), ) }
      
      ::oBrw:bBookMark     := {| n | iif( n == nil, ( ::xAlias )->( recno() ), ( if( ( ::xAlias )->( Used() ), ( ::xAlias )->( dbGoto( n ) ), ) ) ) }
      ::oBrw:bSkip         := {| n | iif( n == nil, n := 1, ), ( if( ( ::xAlias )->( Used() ), ( ::xAlias )->( dbSkipper( n ) ), ) ) }

      if lAIS()
      ::oBrw:bKeyNo        := {| n | iif( n == nil,;
                                       ( if( ( ::xAlias )->( Used() ), Round( ( ::xAlias )->( ADSGetRelKeyPos() ) * ::oBrw:nLen, 0 ), ) ),;
                                       ( if( ( ::xAlias )->( Used() ), ( ::xAlias )->( ADSSetRelKeyPos( n / ::oBrw:nLen ) ), ) ) ) }
      ::oBrw:bKeyCount     := {|| if( ( ::xAlias )->( Used() ), ( ::xAlias )->( ADSKeyCount(,,1) ), ) }
      else
      ::oBrw:bKeyNo        := {| n | iif( n == nil,;
                                       ( if( ( ::xAlias )->( Used() ), ( ::xAlias )->( OrdKeyNo() ), ) ),;
                                       ( if( ( ::xAlias )->( Used() ), ( ::xAlias )->( OrdKeyGoto( n ) ), ) ) ) }
      ::oBrw:bKeyCount     := {|| if( ( ::xAlias )->( Used() ), ( ::xAlias )->( OrdKeyCount() ), 0 ) }
      end if

      ::oBrw:lFastEdit     := .t.
      
      ::oBrw:bKeyChar      := {|nKey| ::CtrlKey( nKey ) }

      // Dimensiones del control -------------------------------------------------

      if !::lBigStyle
         ::oBrw:nTop       := dfnSplitterHeight + dfnSplitterWidth
      else
         ::oBrw:nTop       := 0
         ::oBrw:nRowHeight := 36
      endif

      ::oBrw:nLeft         := dfnTreeViewWidth + dfnSplitterWidth // 1
      ::oBrw:nRight        := ::nRight - ::nLeft
      ::oBrw:nBottom       := ::nBottom - ::nTop

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible crear rejilla de datos" )

      lCreateXBrowse       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lCreateXBrowse )

//---------------------------------------------------------------------------//

Method CreateXFromCode()

   local oCol

   // Apertura de configuraciones----------------------------------------------

   ::OpenData()

   if ::lOpenData
      ::LoadData()
   end if

   // Insertamos el action por columnas----------------------------------------

   for each oCol in ::oBrw:aCols
      if Empty( oCol:bLDClickData ) .and. !( oCol:lEditable )
         oCol:bLDClickData    := {|| ::RecEdit() }
      end if 
   next

   // Insertamos los fastbuttons-----------------------------------------------
   /*
   if ::lFastButtons 

      with object ( ::oBrw:AddCol() )
         :cHeader             := "Restar unidades"
         :bStrData            := {|| "" }
         :bOnPreEdit          := {|| msgStop( "preedit") }
         :bOnPostEdit         := {|| .t. }
         :bEditBlock          := {|| ::RecEdit() }
         :bBmpData            := {|| 1 }
         :nEditType           := 3
         :nWidth              := 20
         :nHeadBmpNo          := 1
         :nBtnBmp             := 1
         :nHeadBmpAlign       := 1
         :AddResource( "Edit_16" )
      end with

   end if
   */
   // Creamos el objeto -------------------------------------------------------

   ::oBrw:CreateFromCode()

   // Guadamos la situaci�n original-------------------------------------------

   ::SaveOriginal()

   // Restaura el estado-------------------------------------------------------

   if !Empty( ::cCfg )
      ::oBrw:RestoreState( ::cCfg )
   end if

   // Enterprise---------------------------------------------------------------

   ::oBrw:SetFocus()

Return ( Self )

//---------------------------------------------------------------------------//

Method CheckExtendInfo()

   if Empty( ::bToolTip )
      Return ( Self )
   endif

   if !Empty( ::oToolTip )
      ::oToolTip:End()
      ::oToolTip  := nil
   endif

   if !Empty( ::oTimer )
      ::oTimer:End()
      ::oTimer    := nil
   endif

   if !::lOnProcess .and. !::oBrw:lEditMode
      ::oTimer             := TTimer():New( ::nToolTip, {|| ::ShowExtendInfo(), if( ::oTimer != nil, ::oTimer:End(), nil ), ::oTimer := nil }, )
      ::oTimer:hWndOwner   := GetActiveWindow()
      ::oTimer:Activate()
   end if

Return ( Self )

//----------------------------------------------------------------------------//

METHOD ShowExtendInfo()

   local nRow
   local oBlock

   ::lOnProcess      := .t.

   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if ::oToolTip == nil

      ::oToolTip     := CheckEval( ::bToolTip )

      if Valtype( ::oToolTip ) == "O"

         nRow        := ( ::oBrw:nRowSel * ::oBrw:DataHeight ) + ::oBrw:HeaderHeight()

         if ( nRow + ::oToolTip:nHeight() ) >= ( ::oBrw:BrwHeight() - 100 )
            nRow     -= ( ::oToolTip:nHeight() + ::oBrw:DataHeight + 108 ) // + 100
            nRow     := Max( nRow, 0 )
         else
            nRow     += 4
         end if

         ::oToolTip:Activate( , , , .f., , .f., {|o| o:Move( nRow, ( ::oBrw:BrwWidth() - ::oToolTip:nWidth() - 4 ), ::oToolTip:nWidth(), ::oToolTip:nHeight() ) } )

         ::oBrw:SetFocus()
         ::oBrw:Select()

         if !Empty( ::oTimer )
            ::oTimer:End()
            ::oTimer := nil
         endif

      end if

   end if

   END SEQUENCE

   ErrorBlock( oBlock )

   ::lOnProcess     := .f.

return nil

//----------------------------------------------------------------------------//

METHOD DestroyToolTip()

  if !Empty( ::oToolTip )

     ::oToolTip:End()
     ::oToolTip  	:= nil

  	 ::oBrw:SetFocus()

  endif

  // ::oBrw:Select()

return nil

//----------------------------------------------------------------------------//

METHOD SetAutoFilter( cFilter )

   if Empty( ::bFilter ) .and. !Empty( cFilter )

      if ( ::xAlias )->( Used() )
         Select( ::xAlias )->( Used() )
      end case

      if Empty( cFilter ) .or. At( Type( cFilter ), "UEUI" ) != 0
         ::bFilter   := nil
      else
         ::bFilter   := Compile( cFilter )
      end if

   end if

Return ( Self )

//----------------------------------------------------------------------------//

METHOD ChgFilter() CLASS TShell

   local cFilter              := ""
   local cFilterExpresion     := ""

   CursorWait()

   if !Empty( ::oWndBar )
      cFilter                 := ::oWndBar:GetComboFilter()
   end if

   if !Empty( cFilter )

      if cFilter != txtFilters 
         
         cFilterExpresion     := ::oActiveFilter:ExpresionFilter( cFilter )
         if !Empty ( cFilterExpresion )
            CreateFastFilter( cFilterExpresion, ::xAlias, .f. )
         endif

         ::ShowButtonFilter()
         ::ShowEditButtonFilter()

      else 

         DestroyFastFilter( ::xAlias )

         ::HideButtonFilter()
         ::HideEditButtonFilter()

      end if 

      ::Refresh() 

   end if

   CursorWE()

   ::SetFocus()

Return ( Self )

//----------------------------------------------------------------------------//

METHOD ToExcel()

   CreateWaitMeter( "Exportando a excel", "Espere por favor...", Eval( ::oBrw:bKeyCount ) ) 

   ::oBrw:ToExcel( {|n| RefreshWaitMeter( n ) } )

   EndWaitMeter()

Return ( Self )

//----------------------------------------------------------------------------//

METHOD AplyFilter()

   if !Empty( ::oActiveFilter )
      ::ChgFilter()
   end if

Return ( Self )

//----------------------------------------------------------------------------//

Function aItmHea()

   local aBase := {}

   aAdd( aBase, { "cCodUse",  "C",  3, 0, "C�digo usuario"           } )
   aAdd( aBase, { "cNomCfg",  "C", 30, 0, "Nombre ventana"           } )
   aAdd( aBase, { "nRecCfg",  "N", 10, 0, "Recno de la ventana"      } )
   aAdd( aBase, { "nTabCfg",  "N", 10, 0, "Orden de la ventana"      } )
   aAdd( aBase, { "cOrdCfg",  "C", 60, 0, "Tag de la ventana"        } )
   aAdd( aBase, { "cBrwCfg",  "M", 10, 0, "Configuraci�n del browse" } )

Return ( aBase )

//---------------------------------------------------------------------------//

Static Function aItmCol()

   local aBase := {}

   aAdd( aBase, { "cCodUse",  "C",  3, 0, "C�digo usuario"           } )
   aAdd( aBase, { "cNomCfg",  "C", 30, 0, "Nombre ventana"           } )
   aAdd( aBase, { "nNumCol",  "N",  2, 0, "N�mero de la columna"     } )
   aAdd( aBase, { "lSelCol",  "L",  1, 0, "Columna seleccionada"     } )
   aAdd( aBase, { "nPosCol",  "N",  2, 0, "Posicici�n de la columna" } )
   aAdd( aBase, { "nSizCol",  "N",  6, 0, "Tama�o de la columna"     } )
   aAdd( aBase, { "lJusCol",  "L",  1, 0, "Columna a la derecha"     } )

Return ( aBase )

#endif

//------------------------------------------------------------------------//
//Clases/m�todos del programa
//------------------------------------------------------------------------//

//
// Chequea que almenos una columna este marcada
//

function CheckOne( aColSelect )

   local lOne  := .f.

   aEval( aColSelect, {|x| if( x, lOne := .t., ) } )

   if !lOne
      msgStop( "La ventana debe de contener al menos una columna seleccionada" )
   end if

return ( lOne )

//---------------------------------------------------------------------------//

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

Function _aColFoot( aColFoot, aColSel )

   local nFor
   local nLen  := Len( aColFoot )
   local aFoo  := {}

   for nFor = 1 to nLen
      if aColSel[ nFor ]
         aAdd( aFoo, aColFoot[ nFor ] )
      end if
   next

return ( aFoo )

//----------------------------------------------------------------------------//

Function _aData( aFields, aColSel )

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

Function _aColHead( aHeaders, aColSel )

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

Function _aColSize( aColSizes, aColSel, oBrw )

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

Function _aColJustify( aColJustify, aColSel, oBrw )

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

Function _aFld( aFields, aColSel )

   local nFor
   local nLen  := Len( aFields )
   local aFld  := {}

   for nFor := 1 to nLen
      if aColSel[ nFor ] .and. !Empty( aFields[ nFor ] )
         aAdd( aFld, Eval( aFields[ nFor ] ) )
      end if
   next

return aFld

//---------------------------------------------------------------------------//
//----------------------------------------------------------------------------//

Function Equal( uFirst, uSecond, lExact )

   local c

   DEFAULT lExact := .t.

   if ( c := Valtype( uFirst ) ) == Valtype( uSecond )
      if c == 'C'
         if lExact
            if Upper( AllTrim( uFirst ) ) == Upper( AllTrim( uSecond ) )
               return .t.
            endif
         else
            if Upper( AllTrim( uFirst ) ) = Upper( AllTrim( uSecond ) )
               return .t.
            endif
         endif
      else
         if uFirst == uSecond
            return .t.
         endif
      endif
   endif

return .f.

//----------------------------------------------------------------------------//

Function oFontLittelTitle()

   if Empty( oFontLittelTitle )
      oFontLittelTitle  := TFont():New( "Ms Sans Serif", 6, 12, .f. )
      // oFontLittelTitle  := TFont():New( "Segoe UI Light", 0, -12, .f., .f. )
   end if

Return ( oFontLittelTitle )

//----------------------------------------------------------------------------//

/*
#ifndef __PDA__

#pragma BEGINDUMP

#include "Windows.h"
#include "hbapi.h"

//----------------------------------------------------------------------------//

HB_FUNC ( CREATEROUNDRECTRGN )
{

   HWND hWnd = ( HWND ) hb_parnl( 1 ) ;
   HRGN hRgn;
   RECT rct;

   GetClientRect( hWnd, &rct ) ;

   hRgn = CreateRoundRectRgn( rct.left, rct.top,
   rct.right - rct.left + 1,
   rct.bottom - rct.top + 1, hb_parnl( 2 ), hb_parnl( 3 ) ) ;

hb_retnl ( (long) hRgn);

}

//----------------------------------------------------------------------------//

HB_FUNC( SETWINDOWRGN )
{
   hb_retni( SetWindowRgn( ( HWND ) hb_parnl( 1 ), ( HRGN ) hb_parnl( 2 ), hb_parl( 3 ) ) );
}

//----------------------------------------------------------------------------//

#pragma ENDDUMP

//----------------------------------------------------------------------------//

#endif
*/