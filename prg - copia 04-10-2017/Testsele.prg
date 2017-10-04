// Testing FiveWin selector controls
// Ramón Avendaño 1998

#include "FiveWin.Ch"
#include "Selector.ch"


static oWnd

static oGet, oBtn, oSbr

static oSelec, oSelec1, oSelec2

//----------------------------------------------------------------------------//

function Main()

   local cTitle := "Testing the Selector controls"

   local oSay1, cSay1 := "Test"
   local oSay2, cSay2 := Space( 8 )

   local nVar1 := 130, nVar2, nVar3

   DEFINE WINDOW oWnd FROM 1, 1 TO 400, 600 PIXEL ;
      COLOR CLR_BLACK, CLR_HGRAY ;
      TITLE cTitle

   SET MESSAGE OF oWnd TO cTitle KEYBOARD CLOCK DATE NOINSET

   @ 20, 75 SAY oSay1 VAR cSay1 SIZE 80,18 PIXEL BORDER COLOR CLR_RED OF oWnd CENTERED
   @ 40, 75 SAY oSay2 VAR cSay2 SIZE 80,18 PIXEL BORDER COLOR CLR_RED OF oWnd

   @ 65, 20 SELECTOR oSelec VAR nVar1 OF oWnd ;
            ORIGIN ANGLE 240 ;     // en grados sexagésimales
            LAST ANGLE 120 ;       // estando el origen cero en el punto superior
            RANGE 100, 200 ;
            MARKS 11;
            SIZE 200, 150 PIXEL ;
            ON CHANGE oSay2:SetText( STR( nVar ) )
            // ON THUMBPOS oSay2:SetText( STR( nVar ) );


   @ 180, 30  SAY "Min." PIXEL OF oWnd
   @ 180, 180 SAY "Max." PIXEL OF oWnd

   @ 225, 70 BUTTON oBtn PROMPT "&Punto medio" SIZE 102,20 PIXEL ACTION oSelec:Set(150) OF oWnd

   @ 65, 240 SELECTOR oSelec1 VAR nVar2 OF oWnd ;
            RANGE 0, 10 ;
            MARKS 11;
            EXACT;
            SIZE 80, 80 PIXEL ;
            COLORS CLR_RED ;

  @ 140, 240 SELECTOR oSelec2 VAR nVar3 OF oWnd ;
            ORIGIN ANGLE 270 ;
            LAST ANGLE 90 ;
            RANGE 100, 0 ;  // Escala en el sentido contrario a la agujas del reloj
            MARKS 21;
            EXACT;
            ON CHANGE oSbr:SetPos( nVar ) ;
            ON THUMBPOS oSbr:SetPos( nVar ) ;
            SIZE 80, 80 PIXEL ;
            COLORS CLR_CYAN ;

  @ 260, 30 SCROLLBAR oSbr PIXEL OF oWnd;
            HORIZONTAL ;
            SIZE 300, 18 ;
            RANGE 0,100

   oSbr:SetPos( 100 )

   @ 120, 360 BUTTON "&Dialog" SIZE 92,22 PIXEL ACTION Test_Dialog() OF oWnd
   @ 160, 360 BUTTON "&Resource" SIZE 92,22 PIXEL ACTION Test_Resource() OF oWnd

   ACTIVATE WINDOW oWnd

return nil

//----------------------------------------------------------------------------//

Function Test_Dialog()

  local oDlg, oBmp

  local oSelecH, oSelecV
  local nVarH := 0, nVarV := 0;

  DEFINE DIALOG oDlg WINDOW oWnd TITLE "Test Selector control" ;
    FROM 50, 50 TO 400, 500 PIXEL

  @ 40, 40 BITMAP oBmp OF oDlg ;
           FILE "FiveWin.bmp" ;
           NO BORDER ;
           PIXEL ;
           ADJUST

  nVarH := 120
  nVarV := 115

  @ 5, 60 SELECTOR oSelecH VAR nVarH OF oDlg ;
               RANGE 50, 250 ;
               MARKS 15;
               ON CHANGE WndSetSize( oBmp:hWnd, nVar, nVarV, .t. ) ;
               ON THUMBPOS WndSetSize( oBmp:hWnd, nVar, nVarV, .t. ) ;
               SIZE 30, 30 PIXEL

  @ 60, 5 SELECTOR oSelecV VAR nVarV OF oDlg ;
                 RANGE 50, 250 ;
               MARKS 15;
               ON CHANGE WndSetSize( oBmp:hWnd, nVarH, nVar, .t. ) ;
               ON THUMBPOS WndSetSize( oBmp:hWnd, nVarH, nVar, .t. ) ;
               SIZE 30, 30 PIXEL

  ACTIVATE DIALOG oDlg ;
    ON INIT MoveWindow( oBmp:hWnd, 80, 80, nVarH, nVarV, .t. ) ;

return nil

//----------------------------------------------------------------------------//

Function Test_Resource()

  local oDlg

  local oSelec1, nVar1
  local oSelec2, nVar2
  local oSelec3, nVar3
  local oSelec4, nVar4

  DEFINE DIALOG oDlg RESOURCE "TEST_SELECTOR" WINDOW oWnd

  REDEFINE SELECTOR oSelec1 VAR nVar1 OF oDlg ID 101 ;
     MARKS 1

  REDEFINE SELECTOR oSelec2 VAR nVar2 OF oDlg ID 102 ;
     MARKS 9 ;
     EXACT ;
     COLOR CLR_BLACK, CLR_HGRAY, CLR_CYAN

  REDEFINE SELECTOR oSelec3 VAR nVar3 OF oDlg ID 103 ;
     MARKS 15 ;
     COLOR CLR_BLACK, CLR_HGRAY, CLR_YELLOW

  REDEFINE SELECTOR oSelec4 VAR nVar4 OF oDlg ID 104 ;
     MARKS 5 ;
     COLOR CLR_BLACK, CLR_HGRAY, CLR_GREEN

  ACTIVATE DIALOG oDlg

return nil











