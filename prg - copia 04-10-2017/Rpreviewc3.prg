#include "FiveWin.Ch"
#include "Factu.ch" 

#define DEVICE      oWnd:cargo

#define GO_POS      0
#define GO_UP       1
#define GO_DOWN     2
#define GO_LEFT     1
#define GO_RIGHT    2
#define GO_PAGE    .T.

#define VSCROLL_RANGE  20*nZFactor
#define HSCROLL_RANGE  20*nZFactor

#define TXT_FIRST                                  "&Primera"
#define TXT_PREVIOUS                               "&Anterior" 
#define TXT_NEXT                                   "&Siguiente"
#define TXT_LAST                                   "&Ultima"
#define TXT_ZOOM                                   "&Zoom"
#define TXT_UNZOOM                                 "&Normal"
#define TXT_TWOPAGES                               "Dos pá&ginas"
#define TXT_ONEPAGE                                "Una pá&gina"
#define TXT_PRINT                                  "&Imprimir"
#define TXT_EXIT                                   "&Salir"
#define TXT_FILE                                   "&Fichero"
#define TXT_PAGE                                   "&Página"
#define TXT_PREVIEW                                "Previsualización"
#define TXT_PAGENUM                                "Número de Página: "
#define TXT_A_WINDOW_PREVIEW_IS_ALLREADY_RUNNING   "Ya existe una Ventana de Previsualización"
#define TXT_GOTO_FIRST_PAGE                        "Ir a la primera página"
#define TXT_GOTO_PREVIOUS_PAGE                     "Ir a la anterior página"
#define TXT_GOTO_NEXT_PAGE                         "Ir a la siguiente página"
#define TXT_GOTO_LAST_PAGE                         "Ir a la última página"
#define TXT_ZOOM_THE_PREVIEW                       "Zoom de la página"
#define TXT_UNZOOM_THE_PREVIEW                     "Deshacer Zoom de la página"
#define TXT_PREVIEW_ON_TWO_PAGES                   "Previsualización en dos páginas"
#define TXT_PREVIEW_ON_ONE_PAGE                    "Previsualización en una página"
#define TXT_PRINT_CURRENT_PAGE                     "Imprimir la página actual"
#define TXT_EXIT_PREVIEW                           "Salir de la previsualización"
#define TXT_ZOOM_FACTOR                            "Factor de zoom"
#define TXT_PDF                                    "Generar fichero pdf"

#define TXT_ACPLESS                                ""
#define TXT_ACPMORE                                ""
#define TXT_ACPLEFT                                ""
#define TXT_ACPRIGHT                               ""
#define TXT_ACPTOP                                 ""
#define TXT_ACPBOTTOM                              ""
#define TXT_FACTOR                                 "Factor"

#define MK_MBUTTON            16

static oWnd, oMeta1, oMeta2,;
       oPage, oTwoPages, oZoom, oMenuZoom, oMenuTwoPages,;
       oMenuUnZoom, oMenuOnePage, oFactor

static aFactor

static nPage, nZFactor

static lTwoPages, lZoom

//----------------------------------------------------------------------------//

function RPreview( oDevice )

     local aFiles
     local oSay
     local oWndMain, oIcon, oBar, oFont
     local lExit
     local oHand, cPageNum
     local oError
     local oBlock

     if oWnd != nil
          MsgStop(TXT_A_WINDOW_PREVIEW_IS_ALLREADY_RUNNING)
          RETU nil
     endif

     oBlock    := ErrorBlock( {| oError | ApoloBreak( oError ) } )
     BEGIN SEQUENCE

     aFiles    := oDevice:aMeta
     lExit     := .f.

     if oWndMain != nil
        oIcon  := oWndMain:oIcon
     endif

     if oDevice:lPrvModal .and. oWndMain != nil
        oWndMain:Hide()
     else
        lExit  := .t.
     endif

     DEFINE FONT oFont NAME GetSysFont() SIZE 0,-12

     DEFINE WINDOW oWnd FROM 0, 0 TO 24, 80  ;
          TITLE oDevice:cDocument            ;
          MENU BuildMenu()                   ;
          COLOR CLR_BLACK, CLR_LIGHTGRAY     ;
          ICON oIcon                         ;
          VSCROLL HSCROLL

     oWnd:SetFont(oFont)

     oWnd:oVScroll:SetRange(0,0)
     oWnd:oHScroll:SetRange(0,0)

     DEFINE CURSOR oHand HAND

     DEFINE BUTTONBAR oBar _3D SIZE 26, iif( LargeFonts(), 30, 26) OF oWnd

     oBar:bRClicked := {|| nil }

     DEFINE BUTTON RESOURCE "Top" OF oBar ;
          MESSAGE TXT_GOTO_FIRST_PAGE     ;
          ACTION TopPage()                ;
          TOOLTIP Strtran(TXT_FIRST,"&","") NOBORDER

     DEFINE BUTTON RESOURCE "Previous" OF oBar ;
          MESSAGE TXT_GOTO_PREVIOUS_PAGE       ;
          ACTION PrevPage()                    ;
          TOOLTIP Strtran(TXT_PREVIOUS,"&","") NOBORDER

     DEFINE BUTTON RESOURCE "Next" OF oBar ;
          MESSAGE TXT_GOTO_NEXT_PAGE       ;
          ACTION NextPage()                ;
          TOOLTIP Strtran(TXT_NEXT,"&","") NOBORDER

     DEFINE BUTTON RESOURCE "Bottom" OF oBar ;
          MESSAGE TXT_GOTO_LAST_PAGE         ;
          ACTION BottomPage()                ;
          TOOLTIP Strtran(TXT_LAST,"&","") NOBORDER

     DEFINE BUTTON oZoom RESOURCE "Zoom16" OF oBar GROUP ;
          MESSAGE TXT_ZOOM_THE_PREVIEW                 ;
          ACTION Zoom()                                ;
          TOOLTIP Strtran(TXT_ZOOM,"&","") NOBORDER

     DEFINE BUTTON oTwoPages RESOURCE "gc_copy_16" OF oBar  ; 
          MESSAGE TXT_PREVIEW_ON_TWO_PAGES       ;
          ACTION TwoPages()                      ;
          TOOLTIP Strtran(TXT_TWOPAGES,"&","") NOBORDER

     DEFINE BUTTON RESOURCE "Imp16" OF oBar GROUP ;
          MESSAGE TXT_PRINT_CURRENT_PAGE            ;
          ACTION PrintPage()                        ;
          TOOLTIP Strtran(TXT_PRINT,"&","") NOBORDER

     DEFINE BUTTON RESOURCE "Pdf_16" OF oBar GROUP ;
          MESSAGE TXT_PDF                          ;
          ACTION PrintPdf( DEVICE )                ;
          TOOLTIP Strtran(TXT_PDF,"&","") NOBORDER

     DEFINE BUTTON RESOURCE "Exit" OF oBar GROUP ;
          MESSAGE TXT_EXIT_PREVIEW               ;
          ACTION oWnd:End()                      ;
          TOOLTIP Strtran(TXT_EXIT,"&","") NOBORDER

     AEval( oBar:aControls, { | o | o:oCursor := oHand } )

     #ifdef __CLIPPER__
        SET MESSAGE OF oWnd TO TXT_PREVIEW CENTERED ;
           NOINSET CLOCK DATE KEYBOARD
     #else
        DEFINE STATUSBAR OF oWnd PROMPT "  " + TXT_PREVIEW // CLOCK
     #endif

     oMeta1 := TMetaFile():New( 0, 0, 0, 0,;
                                aFiles[ 1 ],;
                                oWnd,;
                                CLR_BLACK,;
                                CLR_WHITE,;
                                oDevice:nHorzRes(),;
                                oDevice:nVertRes() )

     // oMeta1:oCursor := oCursor

     oMeta1:blDblClick := { |nRow, nCol, nKeyFlags| ;
                            SetOrg1( nCol, nRow, nKeyFlags ) }

     oMeta1:bKeyDown := {|nKey,nFlags| CheckKey(nKey,nFlags)}
     oMeta1:bMouseWheel := { | nKeys, nDelta, nXPos, nYPos | ;
                             CheckMouseWheel( nKeys, nDelta, nXPos, nYPos ) }

     oMeta2    := TMetaFile():New( 0,0,0,0,"",;
                  oWnd,CLR_BLACK,CLR_WHITE,oDevice:nHorzRes(),;
                  oDevice:nVertRes() )

     oMeta2:blDblClick := {|nRow, nCol, nKeyFlags| SetOrg2( nCol, nRow, nKeyFlags ) }

     oMeta2:hide()

     nPage     := 1
     nZFactor  := 1
     lTwoPages := .F.
     lZoom     := .F.

     @ 7, 285 SAY oSay PROMPT TXT_FACTOR ;
          SIZE 60, 15 PIXEL OF oBar FONT oFont

     @ 3, 335 COMBOBOX oFactor VAR nZFactor ;
          ITEMS {"1","2","3","4","5","6","7","8","9"} ;
          OF oBar FONT oFont PIXEL SIZE 35,200 ;
          ON CHANGE SetFactor(nZFactor)

     if Len( aFiles ) > 1
        cPageNum = TXT_PAGENUM+ltrim(str(nPage,4,0)) + " / " + ltrim(str(len(aFiles)))
     else
        cPageNum = TXT_PAGENUM+ltrim(str(nPage,4,0))
     endif

     @ 7, 380 SAY oPAGE PROMPT cPageNum ;
          SIZE 180, 15 PIXEL OF oBar FONT oFont

     oWnd:cargo := oDevice

     WndCenter(oWnd:hWnd)

     SysRefresh()

     oWnd:oHScroll:bPos := {|nPos| hScroll(GO_POS, .f., nPos)}
     oWnd:oVScroll:bPos := {|nPos| vScroll(GO_POS, .f., nPos)}

     SetFactor()

     ACTIVATE WINDOW   oWnd                      ;
          MAXIMIZED                              ;
          ON RESIZE    PaintMeta()               ;
          ON UP        vScroll(GO_UP)            ;
          ON DOWN      vScroll(GO_DOWN)          ;
          ON PAGEUP    vScroll(GO_UP,GO_PAGE)    ;
          ON PAGEDOWN  vScroll(GO_DOWN,GO_PAGE)  ;
          ON LEFT      hScroll(GO_LEFT)          ;
          ON RIGHT     hScroll(GO_RIGHT)         ;
          ON PAGELEFT  hScroll(GO_LEFT,GO_PAGE)  ;
          ON PAGERIGHT hScroll(GO_RIGHT,GO_PAGE) ;
          VALID        (oWnd:oIcon := nil       ,;
                        oFont:End()             ,;
                        oMeta1:End()            ,;
                        oMeta2:End()            ,;
                        oDevice:End()           ,;
                        oHand:End()             ,;
                        oWnd := nil             ,;
                        lExit := .T.            ,;
                        .T.)

     StopUntil( {|| lExit} )

     RECOVER USING oError

         msgStop( ErrorMessage( oError ), "Imposible abrir ventana de previsualización" )

     END SEQUENCE

     ErrorBlock( oBlock )

return (nil)

//----------------------------------------------------------------------------//

static function BuildMenu()

     local nFor, oMenu

     aFactor := Array(9)

     MENU oMenu
          MENUITEM TXT_FILE
          MENU
               MENUITEM TXT_PRINT ACTION PrintPage() ;
                    MESSAGE TXT_PRINT_CURRENT_PAGE RESOURCE "Printer"

               SEPARATOR

               MENUITEM TXT_EXIT ACTION oWnd:End() ;
                    MESSAGE TXT_EXIT_PREVIEW RESOURCE "Exit"
          ENDMENU

          MENUITEM TXT_PAGE
          MENU
               MENUITEM TXT_FIRST ACTION TopPage() ;
                    MESSAGE TXT_GOTO_FIRST_PAGE RESOURCE "Top"

               MENUITEM TXT_PREVIOUS ACTION PrevPage() ;
                    MESSAGE TXT_GOTO_PREVIOUS_PAGE RESOURCE "Previous"

               MENUITEM TXT_NEXT ACTION NextPage() ;
                    MESSAGE TXT_GOTO_NEXT_PAGE RESOURCE "Next"

               MENUITEM TXT_LAST ACTION BottomPage() ;
                    MESSAGE TXT_GOTO_LAST_PAGE RESOURCE "Bottom"

               SEPARATOR

               MENUITEM  oMenuZoom PROMPT TXT_ZOOM ACTION Zoom(.T.) ;
                    ENABLED ;
                    MESSAGE TXT_ZOOM_THE_PREVIEW RESOURCE "PrvZoom"
               MENUITEM  oMenuUnZoom PROMPT TXT_UNZOOM ACTION Zoom(.T.) ;
                    DISABLED ;
                    MESSAGE TXT_UNZOOM_THE_PREVIEW RESOURCE "UnZoom"
               MENUITEM  "&Factor"  MESSAGE TXT_ZOOM_FACTOR
               MENU
               FOR nFor := 1 TO len(aFactor)

                    MENUITEM aFactor[nFor]                        ;
                         PROMPT "&"+ltrim(str(nFor))              ;
                         MESSAGE "Factor "+ltrim(str(nFor))       ;
                         ACTION ( oFactor:Set(oMenuItem:nHelpId ),;
                                  Eval( oFactor:bChange ) )

               NEXT
               ENDMENU
               SEPARATOR

               MENUITEM oMenuTwoPages PROMPT TXT_TWOPAGES ACTION TwoPages(.T.) ;
                    ENABLED ;
                    MESSAGE TXT_PREVIEW_ON_TWO_PAGES RESOURCE "gc_copy_16"
               MENUITEM oMenuOnePage PROMPT TXT_ONEPAGE ACTION TwoPages(.T.) ;
                    DISABLED ;
                    MESSAGE TXT_PREVIEW_ON_ONE_PAGE RESOURCE "gc_document_white_16"
          ENDMENU
   ENDMENU

return oMenu

//----------------------------------------------------------------------------//

static function PaintMeta()

     local oCoors1, oCoors2
     local aFiles := DEVICE:aMeta
     local nWidth, nHeight, nFactor, nMetaWidth

     if IsIconic(oWnd:hWnd)
          RETU nil
     endif

     DO case
        case ! lTwoPages

          if ! lZoom

             if DEVICE:nHorzSize() >= ;        // Apaisado
                DEVICE:nVertSize()
                nFactor := .4
             else
                nFactor := .40 // .25
             endif

          else
             nFactor := .47
          endif

          nWidth  = oWnd:nWidth() - If( lZoom, 20, 0 )
          nHeight = oWnd:nHeight() - If( lZoom .and. nZFactor > 1, 20, 0 ) - 10 - ;
                    If( LargeFonts(), 100, 80 )

          if ! lZoom
             nMetaWidth = ( nHeight - 40 ) * nFactor
          else
             nMetaWidth = nWidth * nFactor
          endif

          oCoors1 := TRect():New( 40,;
                                  ( nWidth / 2 ) - nMetaWidth,;
                                  nHeight,;
                                  ( nWidth / 2 ) + nMetaWidth )

          oMeta2:Hide()
          oMeta1:SetCoors( oCoors1 )
          oMeta1:Refresh()

     case lTwoPages

          nFactor := .4
          aFiles  := DEVICE:aMeta

          nWidth  := oWnd:nWidth()
          nHeight := oWnd:nHeight() - 10 - If( LargeFonts(), 100, 80 )

          nMetaWidth = ( nHeight - 40 ) * nFactor

          oCoors1 := TRect():New(40,;
                                ( nWidth / 4 ) - nMetaWidth,;
                                nHeight,;
                                ( nWidth / 4 ) + nMetaWidth )
          oCoors2 := TRect():New(40,;
                                ( nWidth / 4 ) - nMetaWidth + ( nWidth / 2 ),;
                                nHeight,;
                                ( nWidth / 4 ) + nMetaWidth + ( nWidth / 2 ) )

          if nPage == Len(aFiles)
               oMeta2:SetFile("")
          else
               oMeta2:SetFile(aFiles[nPage+1])
          endif

          oMeta1:SetCoors(oCoors1)
          oMeta2:SetCoors(oCoors2)
          oMeta1:Refresh()
          oMeta2:Show()

     endcase

     oMeta1:SetFocus()

return nil

//----------------------------------------------------------------------------//

static function NextPage()

     /* local hOldRes := GetResources() */
     local aFiles := DEVICE:aMeta

     if nPage == len(aFiles)
          MessageBeep()
          RETU nil
     endif

     nPage++

     /* SET RESOURCES TO cResFile */

     oMeta1:SetFile(aFiles[nPage])
     oPage:SetText(TXT_PAGENUM+ltrim(str(nPage,4,0))+" / "+ltrim(str(len(aFiles))))

     oMeta1:Refresh()

     if lTwoPages
          if len(aFiles) >= (nPage+1)
               oMeta2:SetFile(aFiles[nPage+1])
          else
               oMeta2:SetFile("")
          endif
          oMeta2:Refresh()
     endif

     oMeta1:SetFocus()

     /*SetResources(hOldRes) */

return nil

//----------------------------------------------------------------------------//

static function PrevPage()

     /* local hOldRes := GetResources() */
     local aFiles := DEVICE:aMeta

     if nPage == 1
          MessageBeep()
          RETU nil
     endif

     nPage--

     /* SET RESOURCES TO cResFile */

     oMeta1:SetFile(aFiles[nPage])
     oPage:SetText(TXT_PAGENUM+ltrim(str(nPage,4,0))+" / "+ltrim(str(len(aFiles))))
     oMeta1:Refresh()

     if lTwoPages
          if len(aFiles) >= nPage+1
               oMeta2:SetFile(aFiles[nPage+1])
          else
               oMeta2:SetFile("")
          endif
          oMeta2:Refresh()
     endif

     oMeta1:SetFocus()

     /*SetResources(hOldRes) */

return nil

//----------------------------------------------------------------------------//

static function TopPage()

     /* local hOldRes := GetResources() */
     local aFiles := DEVICE:aMeta

     if nPage == 1
          MessageBeep()
          RETU nil
     endif

     nPage   := 1

     /* SET RESOURCES TO cResFile */

     oMeta1:SetFile(aFiles[nPage])
     oPage:SetText(TXT_PAGENUM+ltrim(str(nPage,4,0))+" / "+ltrim(str(len(aFiles))))

     oMeta1:Refresh()

     if lTwoPages
          if len(aFiles) >= nPage+1
               oMeta2:SetFile(aFiles[nPage+1])
          else
               oMeta2:SetFile("")
          endif
          oMeta2:Refresh()
     endif

     oMeta1:SetFocus()

     /*SetResources(hOldRes) */

return nil

//----------------------------------------------------------------------------//

static function BottomPage()

     /* local hOldRes := GetResources() */
     local aFiles := DEVICE:aMeta

     if nPage == len(aFiles)
          MessageBeep()
          RETU nil
     endif

     nPage   := len(aFiles)

     /* SET RESOURCES TO cResFile */

     oMeta1:SetFile(aFiles[nPage])
     oPage:SetText(TXT_PAGENUM+ltrim(str(nPage,4,0))+" / "+ltrim(str(len(aFiles))))

     oMeta1:Refresh()

     if lTwoPages
          oMeta2:SetFile("")
          oMeta2:Refresh()
     endif

     oMeta1:SetFocus()
     /*SetResources(hOldRes) */

return nil

//----------------------------------------------------------------------------//

static function TwoPages(lMenu)

     /* local hOldRes := GetResources() */

     /* SET RESOURCES TO cResFile */

     DEFAULT lMenu := .F.

     lTwoPages := !lTwoPages

     if lTwoPages

          if len(DEVICE:aMeta) == 1 // solo hay una pagina
               lTwoPages := !lTwoPages
               MessageBeep()
               /*SetResources(hOldRes) */
               RETU nil
          endif

          if DEVICE:nHorzSize() >= ;        // Apaisado
             DEVICE:nVertSize()
               lTwoPages := !lTwoPages
               MessageBeep()
               /*SetResources(hOldRes) */
               RETU nil
          endif

          if lZoom
               Zoom(.T.)
          endif

          oTwoPages:FreeBitmaps()
          oTwoPages:LoadBitmaps("gc_document_white_16")
          oTwoPages:cMsg      := TXT_PREVIEW_ON_ONE_PAGE
          oTwoPages:cTooltip  := StrTran(TXT_ONEPAGE,"&","")
          oMenuTwoPages:disable()
          oMenuOnePage:enable()

     else

          oTwoPages:FreeBitmaps()
          oTwoPages:LoadBitmaps("gc_copy_16")
          oTwoPages:cMsg     := TXT_PREVIEW_ON_TWO_PAGES
          oTwoPages:cTooltip := StrTran(TXT_TWOPAGES,"&","")
          oMenuTwoPages:enable()
          oMenuOnePage:disable()

     endif

     if lMenu
          oTwoPages:Refresh()
     endif

     oWnd:Refresh()
     PaintMeta()
     /*SetResources(hOldRes) */

return nil

//----------------------------------------------------------------------------//

static function Zoom(lMenu)

     /* local hOldRes := GetResources() */

     /* SET RESOURCES TO cResFile */

     DEFAULT lMenu := .F.

     lZoom := !lZoom

     if lZoom

          if lTwoPages
               TwoPages(.T.)
          endif

          oZoom:FreeBitmaps()
          oZoom:LoadBitmaps("Unzoom")
          oZoom:cMsg       := TXT_UNZOOM_THE_PREVIEW
          oZoom:cTooltip   := StrTran(TXT_UNZOOM,"&","")
          oMenuZoom:disable()
          oMenuUnZoom:enable()

          oWnd:oVScroll:SetRange(1,VSCROLL_RANGE)
          if nZFactor > 1
             oWnd:oHScroll:SetRange(1,HSCROLL_RANGE)
          endif

          oMeta1:ZoomIn()

     else

          oZoom:FreeBitmaps()
          oZoom:LoadBitmaps("PrvZoom")
          oZoom:cMsg := TXT_ZOOM_THE_PREVIEW
          oZoom:cTooltip := StrTran(TXT_ZOOM,"&","")
          oMenuZoom:enable()
          oMenuUnZoom:disable()

          oWnd:oVScroll:SetRange(0,0)
          oWnd:oHScroll:SetRange(0,0)

          oMeta1:ZoomOut()
          nZFactor = 1

     endif

     if lMenu
          oZoom:Refresh()
     endif

     PaintMeta()
     /*SetResources(hOldRes) */

return nil

//----------------------------------------------------------------------------//

static function VScroll(nType,lPage, nSteps)

     local nYfactor, nYorig, nStep

     DEFAULT lPage := .F.

     if nType == GO_UP
        if oWnd:oVScroll:GetPos() <= oWnd:oVScroll:nMin
           return nil
        endif
     else
        if oWnd:oVScroll:GetPos() > oWnd:oVScroll:nMax
           return nil
        endif
     endif

     nYfactor := Int(DEVICE:nVertRes()/oWnd:oVScroll:nMax)

     if nSteps != nil
          nStep := nSteps
     elseif lPage
          nStep := oWnd:oVScroll:nMax/10
     else
          nStep := 1
     endif

     if nType == GO_UP
          nStep := -(nStep)
     elseif nType == GO_POS
          oWnd:oVscroll:SetPos(nSteps)
          nStep := 0
     endif

     nYorig := nYfactor * (oWnd:oVScroll:GetPos() + nStep - 1)

     if nYorig > DEVICE:nVertRes()
          nYorig := DEVICE:nVertRes()
     endif

     if nYorig < 0
          nYorig := 0
     endif

     #ifdef __CLIPPER__
        oMeta1:SetOrg( nil, nYorig )
     #else
        oMeta1:SetOrg( nil, nYorig / DEVICE:nVertRes() * 10 )
     #endif

     oMeta1:Refresh()

return nil

//----------------------------------------------------------------------------//

static function HScroll(nType,lPage, nSteps)

     local nXfactor, nXorig, nStep

     DEFAULT lPage := .F.

     if nType == GO_UP
        if oWnd:oHScroll:GetPos() <= oWnd:oHScroll:nMin
           return nil
        endif
     else
        if oWnd:oHScroll:GetPos() > oWnd:oHScroll:nMax
           return nil
        endif
     endif

     nXfactor := Int(DEVICE:nHorzRes()/oWnd:oHScroll:nMax)

     if nSteps != nil
          nStep := nSteps
     elseif lPage
          nStep := oWnd:oHScroll:nMax/10
     else
          nStep := 1
     endif

     if nType == GO_LEFT
          nStep := -(nStep)
     elseif nType == GO_POS
          oWnd:oHscroll:SetPos(nSteps)
          nStep := 0
     endif

     nXorig := nXfactor * (oWnd:oHScroll:GetPos() + nStep - 1)

     if nXorig > DEVICE:nHorzRes()
          nXorig := DEVICE:nHorzRes()
     endif

     if nXorig < 0
          nXorig := 0
     endif

     #ifdef __CLIPPER__
        oMeta1:SetOrg(nXorig, nil )
     #else
        oMeta1:SetOrg( nXorig / DEVICE:nHorzRes() * 10, nil )
     #endif

     oMeta1:Refresh()

return nil

//----------------------------------------------------------------------------//

static function SetOrg1(nX, nY)

     local oCoors
     local nXStep, nYStep, nXFactor, nYFactor,;
           nWidth, nHeight

     if lZoom
          Zoom(.T.)
          RETU nil
     endif

     oCoors   := oMeta1:GetRect()
     nWidth   := oCoors:nRight - oCoors:nLeft + 1
     nHeight  := oCoors:nBottom - oCoors:nTop + 1
     if .f.
        nXStep   := Max(Int(nX/nWidth*HSCROLL_RANGE) - 9, 0)
        nXFactor := Int(DEVICE:nHorzRes()/HSCROLL_RANGE)
     endif
     if .f.
        nYStep   := Max(Int(nY/nHeight*VSCROLL_RANGE) - 9, 0)
        nYFactor := Int(DEVICE:nVertRes()/VSCROLL_RANGE)
     endif

     Zoom(.T.)

     if !empty(nXStep)
          HScroll(2,,nxStep)
          oWnd:oHScroll:SetPos(nxStep)
     endif

     if !empty(nYStep)
          VScroll(2,,nyStep)
          oWnd:oVScroll:SetPos(nyStep)
     endif

return nil

//----------------------------------------------------------------------------//

static function SetOrg2(nX, nY)

     local oCoors
     local aFiles
     local nXStep, nYStep, nXFactor, nYFactor,;
           nWidth, nHeight

     if oMeta2:cCaption == ""
          RETU nil
     endif

     if lZoom
          Zoom(.T.)
          RETU nil
     endif

     oCoors   := oMeta2:GetRect()
     nWidth   := oCoors:nRight - oCoors:nLeft + 1
     nHeight  := oCoors:nBottom - oCoors:nTop + 1
     if .f.
        nXStep   := Max(Int(nX/nWidth*HSCROLL_RANGE) - 9, 0)
        nXFactor := Int(DEVICE:nHorzRes()/HSCROLL_RANGE)
     endif
     if .f.
        nYStep   := Max(Int(nY/nHeight*VSCROLL_RANGE) - 9, 0)
        nYFactor := Int(DEVICE:nVertRes()/VSCROLL_RANGE)
     endif

     oMeta1:SetFile(oMeta2:cCaption)

     aFiles := DEVICE:aMeta

     if nPage = len(aFiles)
          oMeta2:SetFile("")
     else
          oMeta2:SetFile(aFiles[++nPage])
     endif

     oPage:Refresh()

     Zoom(.T.)

     if !empty(nXStep)
          HScroll(2,,nxStep)
          oWnd:oHScroll:SetPos(nxStep)
     endif

     if !empty(nYStep)
          VScroll(2,,nyStep)
          oWnd:oVScroll:SetPos(nyStep)
     endif

return nil

//----------------------------------------------------------------------------//

static function CheckKey (nKey,nFlags) // Thanks to Joerg K.

     if !lZoom
          DO case
             case nKey == VK_HOME
                  TopPage()
             case nKey == VK_END
                  BottomPage()
             case nKey == VK_PRIOR
                  PrevPage()
             case nKey == VK_NEXT
                  NextPage()
          endcase
     else
          DO case
             case nKey == VK_UP
                  oWnd:oVScroll:GoUp()
             case nKey == VK_PRIOR
                  oWnd:oVScroll:PageUp()
             case nKey == VK_DOWN
                  oWnd:oVScroll:GoDown()
             case nKey == VK_NEXT
                  oWnd:oVScroll:PageDown()
             case nKey == VK_LEFT
                  oWnd:oHScroll:GoUp()
             case nKey == VK_RIGHT
                  oWnd:oHScroll:GoDown()
             case nKey == VK_HOME
                  oWnd:oVScroll:GoTop()
                  oWnd:oHScroll:GoTop()
                  oMeta1:SetOrg(0,0)
                  oMeta1:Refresh()
             case nKey == VK_END
                  oWnd:oVScroll:GoBottom()
                  oWnd:oHScroll:GoBottom()
                  oMeta1:SetOrg(.8*DEVICE:nHorzRes(),.8*DEVICE:nVertRes())
                  oMeta1:Refresh()
          endcase
     endif

return nil

//----------------------------------------------------------------------------//

static function CheckMouseWheel( nKeys, nDelta, nXPos, nYPos )

   if !lZoom
      if lAnd( nKeys, MK_MBUTTON )
         if nDelta > 0
            TopPage()
         else
            BottomPage()
         endif
      else
         if nDelta > 0
            PrevPage()
         else
            NextPage()
         endif
      endif
   else
      if lAnd( nKeys, MK_MBUTTON )
         if nDelta > 0
            if oWnd:oVScroll:GetPos() > oWnd:oVScroll:nMin
               oWnd:oVScroll:PageUp()
            endif
         else
            if oWnd:oVScroll:GetPos() < oWnd:oVScroll:nMax
               oWnd:oVScroll:PageDown()
            endif
         endif
      else
         if nDelta > 0
            if oWnd:oVScroll:GetPos() > oWnd:oVScroll:nMin
               oWnd:oVScroll:GoUp()
            endif
         else
            if oWnd:oVScroll:GetPos() < oWnd:oVScroll:nMax
               oWnd:oVScroll:GoDown()
            endif
         endif
      endif
   endif

return nil

//----------------------------------------------------------------------------//

static function SetFactor(nValue)

     local lInit := .F.

     if nValue == nil
          Aeval(aFactor, {|v,e| v:nHelpId := e})
          nValue := nZFactor
          lInit  := .T.
     endif

     Aeval(aFactor, {|val,elem| val:SetCheck( (elem == nZFactor) ) })

     oMeta1:SetZoomFactor(nZFactor, nZFactor*2)


     if !lZoom .AND. !lInit
          Zoom(.T.)
     endif

     if lZoom
          oWnd:oVScroll:SetRange( 1, VSCROLL_RANGE )
          if nZFactor > 1
             oWnd:oHScroll:SetRange( 1, HSCROLL_RANGE )
          else
             oWnd:oHScroll:SetRange( 0, 0 )
          endif
     endif

     oMeta1:SetFocus()

return nil

//----------------------------------------------------------------------------//

static function PrintPage()

     /* local hOldRes := GetResources()
     local hMeta   := oMeta1:hMeta */

     local oDlg, oRad, oPageIni, oPageFin

     local nOption := 1 ,;
           nFirst  := 1 ,;
           nLast   := len(DEVICE:aMeta)

     if nLast == 1
          PrintPrv(nil, nOption, nFirst, nLast)
          RETU nil
     endif

     /* SET RESOURCES TO cResFile */

     DEFINE DIALOG oDlg RESOURCE "PRINT"

     REDEFINE BUTTON ID 101 OF oDlg ;
          ACTION PrintPrv(oDlg, nOption, nFirst, nLast)

     REDEFINE BUTTON ID 102 OF oDlg ACTION oDlg:End()

     REDEFINE RADIO oRad VAR nOption ID 103,104,105 OF oDlg ;
          ON CHANGE iif(nOption==3 ,;
                       (oPageIni:Enable(),oPageFin:Enable()) ,;
                       (oPageIni:Disable(),oPageFin:Disable()) )

     REDEFINE GET oPageIni ;
          VAR nFirst ;
          ID 106 ;
          PICTURE "@K 99999" ;
          VALID iif(nFirst<1 .OR. nFirst>nLast,(MessageBeep(),.F.),.T.) ;
          OF oDlg

     REDEFINE GET oPageFin ;
          VAR nLast ;
          ID 107 ;
          PICTURE "@K 99999" ;
          VALID iif(nLast<nFirst .OR. nLast>len(DEVICE:aMeta), ;
                    (MessageBeep(),.F.),.T.) ;
          OF oDlg

     oPageIni:Disable()
     oPageFin:Disable()

     /* SetResources(hOldRes ) */

     ACTIVATE DIALOG oDlg

return nil

//----------------------------------------------------------------------------//

static function PrintPrv(oDlg, nOption, nPageIni, nPageEnd)

     local oDevice := DEVICE
     local aFiles := oDevice:aMeta
     local hMeta := oMeta1:hMeta
     local nFor

     CursorWait()

     StartDoc(oDevice:hDC, oDevice:cDocument )

     DO case

     case nOption == 1                           // All

          FOR nFor := 1 TO len(aFiles)
             #ifdef __CLIPPER__
                StartPage(oDevice:hDC)
                hMeta := GetMetaFile(aFiles[nFor])
                PlayMetaFile( oDevice:hDC, hMeta )
                DeleteMetafile(hMeta)
                EndPage(oDevice:hDC)
            #else
                StartPage(oDevice:hDC)
                hMeta := GetEnhMetaFile(aFiles[nFor])
                PlayEnhMetaFile( oDevice:hDC, hMeta,, .t. )
                DeleteEnhMetafile(hMeta)
                EndPage(oDevice:hDC)
             #endif
          NEXT

     case nOption == 2                           // Current page

          StartPage(oDevice:hDC)
          hMeta := oMeta1:hMeta
          #ifdef __CLIPPER__
             PlayMetaFile( oDevice:hDC, hMeta )
          #else
             PlayEnhMetaFile( oDevice:hDC, hMeta,, .t. )
          #endif
          EndPage(oDevice:hDC)

     case nOption == 3                           // Range

          FOR nFor := nPageIni TO nPageEnd
               StartPage(oDevice:hDC)
               #ifdef __CLIPPER__
                  hMeta := GetMetaFile(aFiles[nFor])
                  PlayMetaFile( oDevice:hDC, hMeta )
                  DeleteMetafile(hMeta)
               #else
                  hMeta := GetEnhMetaFile(aFiles[nFor])
                  PlayEnhMetaFile( oDevice:hDC, hMeta,, .t. )
                  DeleteEnhMetafile(hMeta)
               #endif
               EndPage(oDevice:hDC)
          NEXT

     endcase

     EndDoc(oDevice:hDC)

     CursorArrow()

     if oDlg != nil
          oDlg:End()
     endif

return nil

//----------------------------------------------------------------------------//