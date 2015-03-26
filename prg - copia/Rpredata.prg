#include "FiveWin.Ch"
#include "Menu.ch"

#define BAR_TOP             1
#define BAR_LEFT            2
#define BAR_RIGHT           3
#define BAR_DOWN            4
#define BAR_FLOAT           5

//----------------------------------------------------------------------------//

CLASS RPreData

   DATA        oMenu
   CLASSDATA   oWnd
   DATA        oDbf
   DATA        oBrw
   DATA        oBar

   METHOD New()

   METHOD BuildMenu()

   METHOD PaintBrowse()

END CLASS

//----------------------------------------------------------------------------//

METHOD New( aoCols, oDbf, cTitle )

     local n
     local oIcon
     local bLine
     local oFont     := TFont():New( "Ms Sans Serif", 6, 12, .f. )
     local aLine     := {}
     local aSizes    := {}
     local aHeaders  := {}

     DEFAULT cTitle  := "Previsulización de datos"

     IF ::oWnd != NIL
        MsgStop(TXT_A_WINDOW_PREVIEW_IS_ALLREADY_RUNNING)
        Return ( Self )
     ENDIF

     ::oDbf            := oDbf

     DEFINE ICON oIcon RESOURCE "Prever"

     DEFINE WINDOW ::oWnd FROM 0, 0 TO 24, 80  ;
          TITLE   cTitle ;
          MENU    ::BuildMenu() ;
          ICON    oIcon ;
          COLOR   CLR_BLACK, GetSysColor( 15 )

     DEFINE BUTTONBAR ::oBar _3D SIZE 27, 27 OF ::oWnd

     DEFINE BUTTON RESOURCE "Primero" OF ::oBar   NOBORDER ACTION ::oDbf:GoTop()

     DEFINE BUTTON RESOURCE "RegAnt" OF ::oBar    NOBORDER ACTION ::oDbf:Prior()

     DEFINE BUTTON RESOURCE "RegSig" OF ::oBar    NOBORDER ACTION ::oDbf:Next()

     DEFINE BUTTON RESOURCE "Ultimo" OF ::oBar    NOBORDER ACTION ::oDbf:GoBottom()

     DEFINE BUTTON RESOURCE "Exit" OF ::oBar GROUP NOBORDER ACTION ::oWnd:End()

     SET MESSAGE OF ::oWnd TO "Informe" NOINSET

     /*
     Creamos el browse
     */

     bLine                 := {|| _aFld( aoCols ) }
     aHeaders              := _aHeaders( aoCols )
     aSizes                := _aSizes( aoCols )

     ::oBrw                := TWBrowse():New( 0, 0, 100, 100, bLine, aHeaders, aSizes , ::oWnd,,,,,,, oFont,,,,, .f., ::oDbf:cAlias, .t., , .f. )
     ::oBrw:aJustify       := _aJustify( aoCols )
     ::oBrw:aHJustify      := _aJustify( aoCols )
     ::oBrw:nHeaderHeight  := 16
     ::oBrw:nFooterHeight  := 16
     ::oBrw:nLineHeight    := 16
     ::oBrw:lAdjLastCol    := .f.
     ::oBrw:lAdjBrowse     := .t.
     ::oBrw:bLogicLen      := {|| ::oDbf:Count() }
     ::oBrw:nClrBackHead   := Rgb( 239, 231, 222 )
     ::oDbf:SetBrowse( ::oBrw )

     WndCenter( ::oWnd:hWnd )

     ACTIVATE WINDOW   ::oWnd ;
          MAXIMIZED ;
          ON RESIZE  ( ::oBrw:Hide(), ::PaintBrowse() ) ;
          VALID      ( SysRefresh(), oFont:End(), ::oWnd := NIL, .t.)

Return ( Self )

//----------------------------------------------------------------------------//

METHOD BuildMenu()

     MENU ::oMenu
          MENUITEM "&Movimientos"
          MENU
               MENUITEM "&Primero" ACTION ::oDbf:GoTop() ;
                    RESOURCE "Primero"

               MENUITEM "&Anterior" ACTION ::oDbf:Prior() ;
                    RESOURCE "RegAnt"

               MENUITEM "&Siguiente" ACTION ::oDbf:Next() ;
                    RESOURCE "RegSig"

               MENUITEM "&Ultimo" ACTION ::oDbf:GoBottom() ;
                    RESOURCE "Ultimo"

          ENDMENU

          MENUITEM "Salir" ACTION ::oWnd:End() ;
                    RESOURCE "Exit" ;

   ENDMENU

return ( ::oMenu )

//----------------------------------------------------------------------------//

METHOD PaintBrowse()

     LOCAL oCoors1
     LOCAL nWidth
     LOCAL nHeight
     LOCAL nTop     := 0
     LOCAL nLeft    := 0

     IF IsIconic( ::oWnd:hWnd )
          RETU NIL
     ENDIF

     nWidth  := ::oWnd:GetCliRect():nRight - ::oWnd:GetCliRect():nLeft
     nHeight := ::oWnd:GetCliRect():nBottom - ::oWnd:GetCliRect():nTop

     IF ::oWnd:oMsgBar != nil
        nHeight -= ::oWnd:oMsgBar:Height()
     ENDIF

     if ::oWnd:oBar != nil
        do case
           case ::oWnd:oBar:nMode == BAR_TOP
                nTop     += ::oWnd:oBar:nBtnHeight
                nHeight  -= ::oWnd:oBar:nBtnHeight
           case oWnd:oBar:nMode == BAR_LEFT
                nLeft    += ::oWnd:oBar:nBtnWidth
                nWidth   -= ::oWnd:oBar:nBtnWidth
           case oWnd:oBar:nMode == BAR_RIGHT
                nWidth   -= ::oWnd:oBar:nBtnWidth
           case oWnd:oBar:nMode == BAR_DOWN
                nHeight  -= ::oWnd:oBar:nBtnHeight
        endcase
     endif

     nTop         += 10
     nLeft        += 10
     nWidth       -= 20
     nHeight      -= 20
     nTop         += ( nHeight - nHeight ) / 2
     oCoors1      := TRect():New( nTop, nLeft, nTop + nHeight, nLeft + nWidth )

     ::oBrw:SetCoors( oCoors1 )
     ::oBrw:Show()
     ::oBrw:SetFocus()

     ::oWnd:Paint()

RETURN NIL

//----------------------------------------------------------------------------//

static function _aFld( aoCols )

   local nFor
   local aFld  := {}

   for nFor = 1 to Len( aoCols )
      if aoCols[ nFor ]:lSelect
         if Empty( aoCols[ nFor ]:bPict )
            aAdd( aFld, Eval( aoCols[ nFor ]:bFld ) )
         else
            aAdd( aFld, Trans( Eval( aoCols[ nFor ]:bFld ), Eval( aoCols[ nFor ]:bPict ) ) )
         end if
      end if
   next

return aFld

//----------------------------------------------------------------------------//

static function _aSizes( aoCols )

   local nFor
   local aCol  := {}

   for nFor := 1 to len( aoCols )
      if aoCols[nFor]:lSelect
         aAdd( aCol, aoCols[nFor]:nSize * 5 )
      end if
   next

return ( aCol )

//----------------------------------------------------------------------------//

static function _aHeaders( aoCols )

   local nFor
   local aHea  := {}

   for nFor := 1 to len( aoCols )
      if aoCols[nFor]:lSelect
         aAdd( aHea, aoCols[nFor]:cTitle )
      end if
   next

return ( aHea )

//----------------------------------------------------------------------------//

static function _aJustify( aoCols )

   local nFor
   local aJus  := {}

   for nFor := 1 to len( aoCols )
      if aoCols[nFor]:lSelect
         aAdd( aJus, aoCols[nFor]:nPad == 2 )
      end if
   next

return ( aJus )

//----------------------------------------------------------------------------//