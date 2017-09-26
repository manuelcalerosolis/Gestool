#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Font.ch"
#include "..\..\clipper5\include\RddSys.ch"
#include "Menu.ch"

static oWnd
static oMenu

//---------------------------------------------------------------------------//

function Main( uBtnBar )

   local oOut
   local oTab
   local aTab
   local oIconApp
	local oBmp
	local oBrush
	local oBtnHlp

   DEFAULT uBtnBar   := ""

	SetHandleCount(240)

   /*
   Controlling possible GPFs !!!
   */

   InterruptRegister( { || ControlGPF() } )

   /*
   Set de la aplicacion
   */

   SET 3DLOOK        ON
   SET DATE FORMAT   "dd/mm/yyyy"
   SET DELETED       ON
   SET EPOCH         TO 1990

   DEFINE ICON oIconApp RESOURCE "WDLOGO"

   DEFINE FONT oFnt NAME "MS Sans Serif" SIZE 0, -8


   DEFINE WINDOW oWnd ;
         FROM     0, 0 TO 26, 82;
         TITLE    "Web Demo" ;
         COLOR    "W+/W*" ;
         ICON     oIconApp ;
         MDI ;
         MENU     BuildMenu( oIconApp )


   SET MESSAGE OF oWnd TO "(c) Fran Martinez Romero 2001" NOINSET

   oWnd:oMsgBar:KeybOn()
   oWnd:oMsgBar:DateOn()
   oWnd:oMsgBar:ClockOn()

   ACTIVATE WINDOW oWnd MAXIMIZED

	SET RESOURCES TO
	SET 3DLOOK OFF

RETURN NIL

//----------------------------------------------------------------------------//

FUNCTION BuildMenu( oIconApp )

	MENU oMenu

      MENUITEM       "&Test 1";
            MESSAGE  "Test 1" ;
            ACTION   ( MsgInfo( "Test 1" ) );

	ENDMENU

RETURN oMenu

//----------------------------------------------------------------------------//