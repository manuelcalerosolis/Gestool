#include "FiveWin.Ch"
#include "Font.ch"
#include "WebCtl.ch"
#include "Menu.ch"

static oWnd
static oMenu

//---------------------------------------------------------------------------//

function Main( uBtnBar )

   local oFnt, oIconApp, oBar, oPanel

   DEFAULT uBtnBar   := ""

	SetHandleCount(240)

   SET 3DLOOK        ON
   SET DATE FORMAT   "dd/mm/yyyy"
   SET DELETED       ON
   SET EPOCH         TO 1990
   SET RESOURCES     TO "WEBCTL.DLL"

   DEFINE ICON oIconApp RESOURCE "WDLOGO"

   DEFINE FONT oFnt NAME "MS Sans Serif" SIZE 0, -8

   DEFINE WINDOW oWnd ;
         FROM     0, 0 TO 26, 82;
         TITLE    "Web Demo" ;
         COLOR    "W+/W*" ;
         ICON     oIconApp ;
         MDI ;
         MENU     BuildMenu( oIconApp )

   DEFINE BUTTONBAR oBar OF oWnd 3D

   SET MESSAGE OF oWnd TO "(c) WebBar & WebBtn" NOINSET

   oWnd:oMsgBar:KeybOn()
   oWnd:oMsgBar:DateOn()
   oWnd:oMsgBar:ClockOn()

   ACTIVATE WINDOW oWnd MAXIMIZED

   oFnt:end()

	SET RESOURCES TO
	SET 3DLOOK OFF

RETURN NIL

//----------------------------------------------------------------------------//

FUNCTION BuildMenu( oIconApp )

	MENU oMenu

      MENUITEM       "&Test WebBar 1";
            MESSAGE  "Test WebBar 1" ;
            ACTION   ( TestWBar() )

	ENDMENU

RETURN oMenu

//----------------------------------------------------------------------------//

Static Function TestWBar()

   local oDlg, oTabs, oBar, oBmp
   local oOutLook
   local oWebBtn1
   local oWebBtn2
   local oWebBtn3
   local oWebBtn4
   local oWebBtn5
   local oWebBtn6
   local oBrw
   local oFont       := TFont():New( "Arial", 0, -12, .f., .f. )
   local oFontBrw    := TFont():New( "Arial", 0, -12, .f., .f. )
   local oFontOver   := TFont():New( "Arial", 0, -12, .f., .t., , , , , .t. )
   local aTabla      := {  { "1", "Uno" },;
                           { "2", "Dos" },;
                           { "3", "Tres" },;
                           { "4", "Cuatro" },;
                           { "5", "Cinco" } }

   DEFINE WINDOW oDlg FROM -1, -1 TO -400, -600 ;
      MDICHILD ;
      PIXEL ;
      TITLE "Test de WebBar" ;
      NO TITLE ;
      BORDER NONE ;
      COLOR Rgb( 189, 215, 255 ), Rgb( 189, 215, 255 )


   // Barra superior //
   /*
   @ 0,0 WEBBAR oBar  SIZE 0,40 ;
                      PIXEL ;
                      RESOURCE "p6" ;
                      OF oDlg
   */
   oBar := TSeekBar():New( oDlg, .f., "Clientes", -35, 40, "p6" )

   *@ 2, 2 BITMAP oBmp FILE "manos.bmp" OF oBar

   oDlg:oTop := oBar

   // Barra lateral //
   @ 0,0 WEBBAR oOutlook  SIZE 110,400 ;
                           PIXEL ;
                           RESOURCE "p6" ;
                           OF oDlg
                           //RESOURCE "Webleft" ;

//                           CTLHEIGHT 18 ;

   oOutLook:lSepLine := .f.

   DEFINE WEBBTN  oWebBtn1 ;
         PROMPT   "Añadir" ;
         RESNAME  "MEN", "MEN" ;
         ACTION   MsgInfo("1") ;
         OF       oOutLook ;
         MENU     lSelArt( this ) ;
         MESSAGE  "Acceso a menu" ;
         ALIGN    LEFT ;
         FONT     oFont, oFontOver ;
         COLORTEXT( CLR_BLACK, CLR_WHITE )

   DEFINE WEBBTN  oWebBtn2 ;
         PROMPT   "Modificar" ;
         RESNAME  "MEN", "MEN" ;
         ACTION   MsgInfo("1") ;
         OF       oOutLook ;
         ALIGN    LEFT ;
         FONT     oFont, oFontOver ;
         COLORTEXT( CLR_RED, CLR_WHITE )

   DEFINE WEBBTN  oWebBtn3 ;
         PROMPT   "Borrar" ;
         RESNAME  "MEN", "MEN" ;
         ACTION   MsgInfo("1") ;
         OF       oOutLook ;
         ALIGN    LEFT ;
         FONT     oFont, oFontOver ;
         COLORTEXT( CLR_RED, CLR_WHITE )

   DEFINE WEBBTN  oWebBtn4 ;
         PROMPT   "Imprimir" ;
         RESNAME  "MEN", "MEN" ;
         ACTION   MsgInfo("1") ;
         OF       oOutLook ;
         MENU     lSelArt( this ) ;
         MESSAGE  "Acceso a menu" ;
         ALIGN    LEFT ;
         FONT     oFont, oFontOver ;
         COLORTEXT( CLR_RED, CLR_WHITE )

   DEFINE WEBBTN  oWebBtn5 ;
         PROMPT   "Compactar" ;
         RESNAME  "MEN", "MEN" ;
         ACTION   MsgInfo("1") ;
         OF       oOutLook ;
         ALIGN    LEFT ;
         FONT     oFont, oFontOver ;
         COLORTEXT( CLR_RED, CLR_WHITE )

   DEFINE WEBBTN  oWebBtn6 ;
         PROMPT   "Salir" ;
         RESNAME  "EXIT", "EXIT" ;
         ACTION   oDlg:End() ;
         OF       oOutLook ;
         GROUP ;
         ALIGN    LEFT ;
         FONT     oFont, oFontOver ;
         COLORTEXT( CLR_RED, CLR_WHITE )

   oPanel := TPanel():New()
   oDlg:oClient:= oPanel

   oPanel:oTop   := TSeekBar():New( oPanel, .t., "Buscar :",,, "p5" )

   @ 0, 0 LISTBOX oBrw ;
            FIELDS      "" ;
            HEADERS     "Num", "Text" ;
            COLSIZES    150, 150;
            SIZE        400, 400;
            FONT oFontBrw ;
            OF          oPanel

      oBrw:bLine = { || { aTabla[ oBrw:nAt, 1 ],;
                          aTabla[ oBrw:nAt, 2 ] } }

      oBrw:SetArray( aTabla )
      oBrw:aJustify     := { .t., .f. }
      oBrw:lCellStyle   := .T.
      oBrw:nLineStyle   := 10
      oBrw:nLineHeight  := 30
      oBrw:nHeaderHeight  := 20
      oBrw:nClrBackHead := CLR_BLUE
      oBrw:nClrForeHead :=  Rgb( 189, 215, 255 )
      oBrw:aHJustify    := { 2, 2 }
      *Rgb( 189, 215, 255 )
      oBrw:bBkColor :=  {|| Rgb( 239, 231, 222 ) }
      *oBrw:bTextColor :=  // Color del texto
      *oBrw:nClrLine := // Color de la linea de separacion de columna

   @ 8, 0 TABS oTabs PROMPTS "&Uno", "&Dos", "T&res", "&Cuatro" OF oPanel ;
      ACTION oDlg:Say( 5, 5, oTabs:nOption )

   oPanel:oClient := oBrw
   oDlg:oLeft     := oOutLook
   oPanel:oBottom := oTabs
   oDlg:oControl  := oBrw // La MdiChild siempre tiene el foco en el browse !


   ACTIVATE WINDOW oDlg

   oDlg:nTop      := -4
   oDlg:nLeft     := 0
   oDlg:nBottom   := oWnd:oWndClient:nHeight() + 4
   oDlg:nRight    := oWnd:oWndClient:nWidth()
   oDlg:Move( oDlg:nTop, oDlg:nLeft, oDlg:nRight, oDlg:nBottom,  .t. )

return ( oDlg )

//--------------------------------------------------------------------------//

STATIC FUNCTION lSelArt( oBtn )

   local oMenu := MenuBegin( .T. )

      MenuAddItem( "&1. Item",, .F.,,;
                   {|oMenuItem|( MsgInfo( "Item") )},,,,,,, .F.,,, .F. )

      MenuAddItem( "&2. Item",, .F.,,;
                   {|oMenuItem|( MsgInfo( "Item") )},,,,,,, .F.,,, .F. )

      MenuAddItem( "&3. Item",, .F.,,;
                   {|oMenuItem|( MsgInfo( "Item") )},,,,,,, .F.,,, .F. )

      MenuAddItem( "&Al fin funciona :)",, .f.,,;
                   {|oMenuItem|( MsgInfo( "Item") )},,,,,,, .F.,,, .F. )

   MenuEnd()

   oMenu:Activate( 0, oBtn:nRight, oBtn )

RETURN NIL

//--------------------------------------------------------------------------//