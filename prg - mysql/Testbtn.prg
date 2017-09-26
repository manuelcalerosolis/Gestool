/*

 Programa de prueba de la clase TSButton.
 Autor: Manuel Mercado
 Desarrollador independiente

 La clase TSButton fue construída tomando partes de los programas fuente de
  FiveWin y agregando un poco de mi propia cosecha.

 Puedes usar libremente TSButton con la única condición de respetar el nombre
  del autor.

 Disfrútala.

 Manuel Mercado.
 Salamanca, Gto., Mexico.

 Con mucho gusto atenderé tus observaciones y sugerencias para mejorar la
  clase, dirígete a:

 mmercadog@prodigy.net.mx
 mmercadog@hotmail.com

*/

#include "TSButton.ch"
#include "FiveWin.Ch"

Static oWnd, aChild[ 3 ]

//--------------------------------------------------------------------------//

FUNCTION Main()

   Local oBar, oFont, oIco, oBtn[ 2 ]

   DEFINE FONT oFont NAME "MS Sans Serif" SIZE 0, -6
   DEFINE ICON oIco RESOURCE "Super"

   DEFINE WINDOW oWnd FROM 100, 100 TO 490, 600 PIXEL ;
          TITLE "Super Buttons  ¡ Todos los Botones SIN DLL's !" ;
          MENU BuildMenu() ;
          COLORS CLR_BLACK, CLR_CYAN ;
          ICON oIco ;
          MDI


   ACTIVATE WINDOW oWnd VALID ( oFont:End(), oIco:End(), .T. )

Return Nil

//--------------------------------------------------------------------------//

Static Function Child1()

   Local oIco, oFont, bTColor, bBColor, oBtn[ 10 ], oBmp[ 5 ], oBar, ;
         lEnable := .F.

   // text and background colors now can be code blocks
   // here defining text and background colors for buttons 3 and 4
   bTColor := { |oBtn| If( ! oBtn:lActive, CLR_GRAY, ;
                       If( oBtn:lMouseOver, CLR_HBLUE, ;
                       If( oBtn:lPressed, CLR_HRED, CLR_BLACK ) ) ) }

   bBColor := { |oBtn| If( oBtn:lActive, CLR_HGRAY, CLR_GRAY ) }

   If aChild[ 1 ] == Nil


      DEFINE FONT oFont NAME "MS Sans Serif" SIZE 0, -6
      DEFINE ICON oIco RESOURCE "Super"

      DEFINE WINDOW aChild[ 1 ] FROM 0, 0 TO 346, 500 PIXEL OF oWnd ;
             TITLE "Super Buttons  ¡ Todos los Botones SIN DLL's !" ;
             COLORS CLR_BLACK, CLR_CYAN ICON oIco ;
             STYLE nOR( WS_DLGFRAME, WS_VISIBLE ) ;
             MDICHILD

      DEFINE BUTTONBAR oBar OF aChild[ 1 ] SIZE 25, 25 3D

      DEFINE SBUTTON oBtn[ 1 ] OF oBar ;
             RESOURCE "Super1", "Super2", "Super3", "Super2" ;
             ACTION Child2() ;
             WHEN lEnable ;
             TOOLTIP "LOOK W97" ;
             MESSAGE "Super Buttons en barras de botones" ;
             LOOK W97

      DEFINE SBUTTON oBtn[ 7 ] OF oBar ;
             RESOURCE "Super1", "Super2", "Super3", "Super2" ;
             TOOLTIP "Matrices de botones" ;
             MESSAGE "Reservaciones de asientos" ;
             LOOK W97 ;
             ACTION Child3() ;
             MENU ACTION MenuPop( oBtn[ 1 ] )

      DEFINE SBUTTON oBtn[ 8 ] OF oBar ;
             RESOURCE "Cut1", "Cut2",, "Cut2" ;
             TOOLTIP "LOOK W97" ;
             MESSAGE "Super Buttons en barras de botones" ;
             LOOK W97 ;
             GROUP

      DEFINE SBUTTON oBtn[ 9 ] OF oBar ;
             RESOURCE "Paste1", "Paste2",, "Paste2" ;
             TOOLTIP "LOOK W97" ;
             MESSAGE "Super Buttons en barras de botones" ;
             LOOK W97 ;

      DEFINE SBUTTON oBtn[ 10 ] OF oBar ;
             RESOURCE "Del1", "Del2",, "Del2" ;
             TOOLTIP "LOOK W97" ;
             MESSAGE "Super Buttons en barras de botones" ;
             LOOK W97 ;

      DEFINE SBUTTON oBtn[ 2 ] OF oBar ;
             FILENAME "Exit1", "Exit2",, "Exit2" ;
             FONT oFont ;
             CAPTION "Salir" ;
             ACTION aChild[ 1 ]:End() ;
             TOOLTIP "LOOK W97" ;
             MESSAGE "Super Buttons en barras de botones" ;
             LOOK W97 ;
             GROUP

      @60, 140  SBUTTON oBtn[ 3 ] OF aChild[ 1 ] FONT oFont ;
               SIZE 80, 30 PIXELS ;
               PROMPT "&Activar" BORDER ;
               ACTION ( lEnable := ! lEnable, oBtn[ 1 ]:Refresh(), ;
                        oBtn[ 5 ]:Refresh(), oBtn[ 6 ]:Refresh(), ;
                        ShowBitMaps( oFont, oBmp ) ) ;
               COLORS CLR_WHITE, CLR_BLUE ;
               TOOLTIP "Activar / Desactivar Botones"

      @60, 240 SBUTTON oBtn[ 4 ] OF aChild[ 1 ] FONT oFont ;
               SIZE 80, 30 PIXELS ;
               FILENAME "Exit1", "Exit2",, "Exit2" ; // bitmaps from disk
               PROMPT "&Salir" BORDER ;
               ACTION aChild[ 1 ]:End();
               COLORS CLR_WHITE, CLR_RED ;
               TOOLTIP "Finalizar el programa" ;
               TEXT ON_LEFT

      @120, 90 SBUTTON oBtn[ 5 ] OF aChild[ 1 ] FONT oFont ;
               SIZE 100, 50 PIXELS ;
               PROMPT "Botones" + CRLF + "Desde" + CRLF + "&Recursos" BORDER UPDATE;
               RESOURCE "Direc1", "Direc2", "Direc3", "Direc4" ;
               WHEN lEnable ;
               ACTION ( fResource() );
               TOOLTIP "TEXT ON RIGHT (Default)" ;
               MESSAGE "Super Buttons con texto Mulltilínea, Colores Dinámicos" ;
               COLORS bTColor, bBColor ;
               TEXT ON_RIGHT

      @120, 320 SBUTTON oBtn[ 6 ] OF aChild[ 1 ] FONT oFont ;
                SIZE 100, 50 PIXELS ;
                PROMPT "Botones" + CRLF + "Desde" + CRLF + "&Código" BORDER UPDATE;
                RESOURCE "Multi1", "Multi1", "Multi1", "Multi1" ;
                WHEN lEnable ;
                ACTION ( fCodigo() );
                TOOLTIP "TEXT ON_LEFT" ;
                MESSAGE "Super Buttons con texto Mulltilínea, Colores Dinámicos" ;
                COLORS bTColor, bBColor ;
                TEXT ON_LEFT        // will be Windows default

      SET MESSAGE OF aChild[ 1 ] TO "Super Buttons, ¡ Todos los botones en una sola " + ;
                             "clase independiente !"

      ACTIVATE WINDOW aChild[ 1 ] ON INIT oBtn [ 3 ]:SetFocus() ;
               VALID ( aChild[ 1 ] := Nil, oFont:End(), oIco:End(), ;
                       If( oBmp[ 1 ] != Nil, ;
                       AEval( oBmp, { |o| DeleteObject( o ) } ), Nil ), .T. )

   Else
      aChild[ 1 ]:SetFocus()
   EndIf

Return Nil

//--------------------------------------------------------------------------//

Static Function BuildMenu()

   Local oMenu

   MENU oMenu
      MENUITEM "&TSButton" ACTION Child1()
      MENUITEM "&Salir" ACTION oWnd:End()
   ENDMENU

Return oMenu

//--------------------------------------------------------------------------//

Static Function ShowBitMaps( oFont, oBmp )

   @198, 160 SAY "Bitmaps usados en estos botones" FONT oFont ;
             COLOR CLR_BLACK, CLR_CYAN SIZE 200, 12 PIXEL OF aChild[ 1 ]

   @215, 80 BITMAP oBmp[ 1 ] RESOURCE "Direc1" OF aChild[ 1 ] PIXEL
   @215,120 BITMAP oBmp[ 2 ] RESOURCE "Direc2" OF aChild[ 1 ] PIXEL
   @215,165 BITMAP oBmp[ 3 ] RESOURCE "Direc3" OF aChild[ 1 ] PIXEL
   @215,205 BITMAP oBmp[ 4 ] RESOURCE "Direc4" OF aChild[ 1 ] PIXEL
   @215,315 BITMAP oBmp[ 5 ] RESOURCE "Multi1" OF aChild[ 1 ] PIXEL

   @247, 90 SAY "  1            2           3           4" FONT oFont ;
             COLOR CLR_BLACK, CLR_CYAN SIZE 200, 12 PIXEL OF aChild[ 1 ]

   @247, 330 SAY " 1         2         3         4" FONT oFont ;
             COLOR CLR_BLACK, CLR_CYAN SIZE 120, 12 PIXEL OF aChild[ 1 ]

   @260, 80 SAY "Normal  Pressed  Inactive  Pointed" FONT oFont ;
             COLOR CLR_BLACK, CLR_CYAN SIZE 200, 12 PIXEL OF aChild[ 1 ]

   @260, 310 SAY "Cuatro Estados en un Bitmap" FONT oFont ;
                 COLOR CLR_BLACK, CLR_CYAN SIZE 150, 12 PIXEL OF aChild[ 1 ]

Return Nil

//--------------------------------------------------------------------------//

Static Function fResource()

   Local oDlg, oFont, oGet, oBrush, cVar, bColor, ;
         lEnable := .F., ;
         oBtn := Array( 9 )

   SET _3DLOOK ON

   cVar := Space( 10 )


   DEFINE BRUSH oBrush RESOURCE "Back2"
   DEFINE FONT oFont NAME "MS Sans Serif" SIZE 0,-12

   DEFINE DIALOG oDlg NAME "DIALOG_1" TITLE "Super Buttons en diálogos desde recursos";
          FONT oFont

   REDEFINE GET oGet VAR cVar ID 101 OF oDlg ;
            VALID ( If( Empty( cVar ), ( ;
                    Msginfo( "Debes escribir algo en el Get de prueba" ), .F. ), .T. ) )

   REDEFINE SBUTTON oBtn[ 8 ] ID 208 OF oDlg FONT oFont ;
            PROMPT "&Archivo" ;
            ACTION MenuArch( oBtn[ 8 ] ), oGet:SetFocus() ;
            MESSAGE "Simulando menúes en diálogos con Super Buttons" ;
            TOOLTIP "LOOK W97, CANCEL, Solo Texto" ;
            LOOK W97 CANCEL

   REDEFINE SBUTTON oBtn[ 9 ] ID 209 OF oDlg FONT oFont ;
            PROMPT "&Salir" ;
            MESSAGE "Simulando menúes en diálogos con Super Buttons" ;
            ACTION oDlg:End() ;
            TOOLTIP "LOOK W97, CANCEL, Solo Texto" ;
            LOOK W97 CANCEL

   REDEFINE SBUTTON oBtn[ 1 ] ID 201 ;
            RESOURCE "OK1","OK2","OK3", "OK4" OF oDlg FONT oFont;
            PROMPT "A&ctivar" ;
            ACTION ( lEnable := ! lEnable, oBtn[ 3 ]:Refresh(), ;
                     oBtn[ 5 ]:Refresh() );
            TOOLTIP "BRUSH, TEXT ON_TOP, BORDER" BORDER ;
            MESSAGE "Para usar este botón debes escribir algo en el Get de prueba" ;
            COLORS { |oBtn| If( oBtn:lMouseOver, CLR_WHITE, CLR_BLACK ) }, ;
                   CLR_GREEN ;
            BRUSH oBrush ;
            TEXT POSITION ON_TOP

   REDEFINE SBUTTON oBtn[ 2 ] ID 202 ;
            RESOURCE "CANCEL1", "CANCEL2", "CANCEL3", "CANCEL4" ;
            OF oDlg PROMPT "&Cancelar" FONT oFont ;
            ACTION oDlg:End() ;
            TOOLTIP "TEXT ON RIGHT (Default), MENU, CANCEL" ;
            MESSAGE "Super Buttons con menú" ;
            COLORS CLR_WHITE, ;
                   {|oB| If( oB:lMouseOver, {CLR_WHITE,CLR_BLUE }, ;
                                          {CLR_BLUE,CLR_WHITE} ) };
            BORDER;
            TEXT POSITION ON_RIGHT CANCEL ;
            MENU ACTION MenuPop( oBtn[ 2 ] )

   REDEFINE SBUTTON oBtn[ 3 ] ID 203 ;
            RESOURCE "HELP1", "HELP2", "HELP3", "HELP4" OF oDlg ;
            PROMPT "&SBUTTON" + CRLF + "Desde" + CRLF + "Codigo" ;
            FONT oFont ACTION fCodigo() ;
            MESSAGE "Super Buttons con texto multilínea, Colores dinámicos." ;
            TOOLTIP "TEXT ON RIGHT (default)" ;
            WHEN lEnable ;
            COLORS {|oBtn| If( oBtn:lActive, ;
                           If( oBtn:lMouseOver, CLR_HBLUE, CLR_BLACK), CLR_BLACK ) }, ;
                   {|oBtn| If( oBtn:lActive, {CLR_YELLOW,CLR_BLUE, .T. }, CLR_GRAY ) } ;
            TEXT POSITION ON_RIGHT

   REDEFINE SBUTTON oBtn[ 4 ] ID 204 ;
            RESOURCE "STOP1","STOP2","STOP3", "STOP4" OF oDlg FONT oFont;
            PROMPT "&Prueba" ;
            ACTION ( MsgInfo( "Ok" ) ) ;
            MESSAGE "Super Buttons con menú" ;
            TOOLTIP "TEXT ON_TOP, MENU, CANCEL" ;
            COLORS { |oBtn| If( oBtn:lMouseOver, CLR_WHITE, CLR_BLACK ) }, {CLR_GREEN,CLR_YELLOW} ;
            TEXT POSITION ON_TOP ;
            MENU ACTION MenuPop( Self )

   REDEFINE SBUTTON oBtn[ 5 ] ID 205 ;
            RESOURCE "STOP1","STOP2","STOP3", "STOP4" OF oDlg FONT oFont;
            PROMPT "P&rueba" ;
            ACTION ( MsgInfo( "Ok" ), oGet:SetFocus() ) ;
            WHEN lEnable ;
            TOOLTIP "TEXT ON_BOTTOM CANCEL" ;
            COLORS { |oBtn| If( oBtn:lMouseOver, CLR_BLUE, CLR_BLACK ) }, ;
                   { |oBtn| If( oBtn:lActive, {CLR_RED,CLR_HGRAY}, CLR_GRAY ) } ;
            CANCEL ;
            TEXT POSITION ON_BOTTOM


   REDEFINE SBUTTON oBtn[ 6 ] ID 206 ;
            RESOURCE "HELP1", "HELP2", "HELP3", "HELP4"  OF oDlg ;
            PROMPT "Pr&ueba" ;
            FONT oFont ACTION MsgInfo( "Ok");
            TOOLTIP "LOOK W97, TEXT ON_BOTTOM" ;
            MESSAGE "Para usar este botón debes escribir algo en el Get de prueba" ;
            TEXT POSITION ON_BOTTOM ;
            LOOK W97

   REDEFINE SBUTTON oBtn[ 7 ] ID 207 ;
            RESOURCE "HELP1", "HELP2", "HELP3", "HELP4"  OF oDlg ;
            PROMPT "Pr&ueba" ;
            FONT oFont ACTION MsgInfo( "Ok") ;
            MESSAGE "Super Buttons con menú y Look W97" ;
            TOOLTIP "LOOK W97, MENU, TEXT ON_TOP" ;
            TEXT POSITION ON_TOP ;
            MENU ACTION MenuPop( Self ) ;
            LOOK W97

   ACTIVATE DIALOG oDlg CENTERED ON INIT ( oGet:SetFocus(), ;
            oDlg:oMsgBar := TMsgBar():New( oDlg, "Super Buttons ¡ Todos " + ;
            "los botones en una sola clase independiente !" ) ) ;
            ON PAINT SBtnLine( oDlg:hWnd, 21, 0, 21, 500, oDlg:nClrPane )

               // La funcion SBtnLine pinta una l¡nea bicolor. La sintaxis es
               // SBtnLine( hWnd, nTop, nLeft, nBottom, nRight, nColor )
               // como no es un control, tienes que mandarlo con la clausula
               // ON PAINT del dialogo o la ventana. Para lineas
               // horizontales, nTop y nBottom deben ser iguales; para
               // lineas verticales, nLeft y nRight deben ser iguales.
               // En este ejemplo la uso para simular el menu.



   oFont:End()
   oBrush:End()

Return Nil

//--------------------------------------------------------------------------//

Static Function MenuPop( oBtn )

   Local oMenu, aRect

   aRect := GetClientRect( oBtn:hWnd )

   MENU oMenu POPUP
      MENUITEM "&Deshacer" RESOURCE "Deshacer"
      SEPARATOR
      MENUITEM "Co&rtar"  RESOURCE "Cortar"
      MENUITEM "&Copiar" RESOURCE "Copiar"
      MENUITEM "&Pegar" RESOURCE "Pegar"
      MENUITEM "&Eliminar" RESOURCE "Borrar"
      SEPARATOR
      MENUITEM "Seleccion&ar todo"
   ENDMENU

   ACTIVATE POPUP oMenu AT aRect[ 3 ] + 1, aRect[ 2 ] OF oBtn

Return Nil

//--------------------------------------------------------------------------//

Static Function MenuArch( oBtn )

   Local oMenu, aRect

   aRect := GetClientRect( oBtn:hWnd )

   MENU oMenu POPUP
      MENUITEM "&Nuevo"
      MENUITEM "&Abrir"
      SEPARATOR
      MENUITEM "&Guardar"
      MENUITEM "Guardar &Como"
      MENUITEM "&Cerrar"
      MENUITEM "&Imprimir"
      SEPARATOR
      MENUITEM "&Preparar Impresora"
   ENDMENU

   ACTIVATE POPUP oMenu AT aRect[ 3 ] + 1, aRect[ 2 ] OF oBtn

Return Nil

//--------------------------------------------------------------------------//

Static Function fCodigo()

   Local oDlg, oFont, oGet, oBrush, cVar, bColor, ;
         lEnable := .F., ;
         oBtn := Array( 9 )

   SET _3DLOOK ON

   cVar := Space( 10 )

   DEFINE BRUSH oBrush RESOURCE "Back1"
   DEFINE FONT oFont NAME "MS Sans Serif" SIZE 0, -8

   DEFINE DIALOG oDlg FROM 0, 0 TO 316, 360 FONT oFont PIXEL ;
          TITLE "Super Buttons en diálogos desde código"

   @0, 1 SBUTTON oBtn[ 8 ] OF oDlg FONT oFont ;
            SIZE 24, 8 PIXELS ;
            PROMPT "&Archivo" ;
            ACTION MenuArch( oBtn[ 8 ] ), oGet:SetFocus() ;
            MESSAGE "Simulando menúes en diálogos con Super Buttons" ;
            TOOLTIP "LOOK W97, CANCEL, Solo Texto" ;
            LOOK W97 CANCEL
   oBtn[ 8 ]:nStyle := nAnd( oBtn[ 8 ]:nStyle, nNot( WS_TABSTOP ) )

   @0, 25 SBUTTON oBtn[ 9 ] OF oDlg FONT oFont ;
            SIZE 16, 8 PIXELS ;
            PROMPT "&Salir" ;
            MESSAGE "Simulando menúes en diálogos con Super Buttons" ;
            ACTION oDlg:End() ;
            TOOLTIP "LOOK W97, CANCEL, Solo Texto" ;
            LOOK W97 CANCEL
   oBtn[ 9 ]:nStyle := nAnd( oBtn[ 9 ]:nStyle, nNot( WS_TABSTOP ) )

   @ 31, 62 GET oGet VAR cVar OF oDlg SIZE 51, 11 PIXEL;
            VALID ( If( Empty( cVar ), ( ;
                    Msginfo( "Debes escribir algo en el Get de prueba" ), .F. ), .T. ) )

   @59, 1 SBUTTON oBtn[ 1 ] FONT oFont ;
            SIZE 50, 25 PIXELS ;
            RESOURCE "OK1", "OK2", "OK3", "OK4" OF oDlg ;
            PROMPT "A&ctivar" ;
            ACTION ( lEnable := ! lEnable, oBtn[ 3 ]:Refresh(), ;
                     oBtn[ 5 ]:Refresh() );
            TOOLTIP "BRUSH, TEXT ON_TOP" ;
            MESSAGE "Para usar este botón debes escribir algo en el Get de prueba" ;
            COLORS { |oBtn| If( oBtn:lMouseOver, CLR_WHITE, CLR_BLACK ) }, ;
                   CLR_HGRAY ;
            BRUSH oBrush ;
            TEXT POSITION ON_TOP

   @59, 61 SBUTTON oBtn[ 2 ] FONT oFont ;
            SIZE 50, 25 PIXELS ;
            RESOURCE "CANCEL1", "CANCEL2", "CANCEL3", "CANCEL4" ;
            OF oDlg PROMPT "&Cancelar" ;
            ACTION oDlg:End() ;
            TOOLTIP "TEXT ON RIGHT (Default), MENU, CANCEL" ;
            MESSAGE "Super Buttons con menú" ;
            COLORS CLR_WHITE, CLR_BLUE ;
            TEXT POSITION ON_RIGHT CANCEL ;
            MENU ACTION MenuPop( oBtn[ 2 ] )

   @59, 121 SBUTTON oBtn[ 3 ] FONT oFont ;
            SIZE 50, 25 PIXELS ;
            RESOURCE "HELP1", "HELP2", "HELP3", "HELP4" OF oDlg ;
            PROMPT "&SBUTTON" + CRLF + "Desde" + CRLF + "Codigo" ;
            ACTION fCodigo() ;
            MESSAGE "Super Buttons con texto Mulltilínea, Colores Dinámicos" ;
            TOOLTIP "TEXT ON RIGHT, Texto multilínea" ;
            WHEN lEnable ;
            TEXT POSITION ON_RIGHT ;
            COLORS {|oBtn| If( oBtn:lActive, ;
                           If( oBtn:lMouseOver, CLR_YELLOW, CLR_HBLUE), ;
                           CLR_BLACK ) }, ;
                   {|oBtn| If( oBtn:lActive, CLR_GREEN, CLR_GRAY ) }

   @98, 7 SBUTTON oBtn[ 4 ] FONT oFont ;
            SIZE 28, 28 PIXELS ;
            RESOURCE "STOP1","STOP2","STOP3", "STOP4" OF oDlg ;
            PROMPT "&Prueba" ;
            ACTION ( MsgInfo( "Ok" ), oGet:SetFocus() ) ;
            MESSAGE "Super Buttons con menú" ;
            TOOLTIP "TEXT ON_TOP, BITMAP OPAQUE, MENU, CANCEL, NOBORDER" ;
            NOBORDER ;
            COLORS { |oBtn| If( oBtn:lMouseOver, CLR_WHITE, CLR_BLACK ) }, ;
                   CLR_GREEN ;
            BITMAP OPAQUE CANCEL;
            TEXT POSITION ON_TOP ;
            MENU ACTION MenuPop( Self )

   @98, 52 SBUTTON oBtn[ 5 ] FONT oFont ;
            SIZE 27, 28 PIXELS ;
            RESOURCE "STOP1", "STOP2", "STOP3", "STOP4" OF oDlg ;
            PROMPT "P&rueba" ;
            ACTION ( MsgInfo( "Ok" ), oGet:SetFocus() ) ;
            WHEN lEnable ;
            TOOLTIP "TEXT ON_BOTTOM CANCEL, NOBORDER" ;
            COLORS { |oBtn| If( oBtn:lMouseOver, CLR_BLUE, CLR_BLACK ) }, ;
                   { |oBtn| If( oBtn:lActive, CLR_RED, CLR_GRAY ) } ;
            CANCEL ;
            NOBORDER ;
            TEXT POSITION ON_BOTTOM


   @98, 95 SBUTTON oBtn[ 6 ] FONT oFont ;
            SIZE 27, 28 PIXELS ;
            RESOURCE "HELP1", "HELP2", "HELP3", "HELP4"  OF oDlg ;
            PROMPT "Pr&ueba" ;
            ACTION MsgInfo( "Ok") ;
            TOOLTIP "LOOK W97, TEXT ON_BOTTOM" ;
            MESSAGE "Para usar este botón debes escribir algo en el Get de prueba" ;
            TEXT POSITION ON_BOTTOM ;
            LOOK W97

   @98, 138 SBUTTON oBtn[ 7 ] FONT oFont ;
            SIZE 27, 28 PIXELS ;
            RESOURCE "HELP1", "HELP2", "HELP3", "HELP4"  OF oDlg ;
            PROMPT "Pr&ueba" ;
            ACTION MsgInfo( "Ok") ;
            MESSAGE "Super Buttons con menú y Look W97" ;
            TOOLTIP "LOOK W97, MENU, TEXT ON_TOP" ;
            TEXT POSITION ON_TOP ;
            MENU ACTION MenuPop( Self ) ;
            LOOK W97
      oGet:bPainted := {|| SBtnLine( oGet:hWnd, 3, 0, 3, 10, CLR_RED )}

   ACTIVATE DIALOG oDlg CENTERED ON INIT ( oGet:SetFocus(), ;
            oDlg:oMsgBar := TMsgBar():New( oDlg, "Super Buttons ¡ Todos " + ;
            "los botones en una sola clase independiente !" ) ) ;
            ON PAINT SBtnLine( oDlg:hWnd, 20, 0, 20, 400, oDlg:nClrPane )

               // La funcion SBtnLine pinta una l¡nea bicolor. La sintaxis es
               // SBtnLine( hWnd, nTop, nLeft, nBottom, nRight, nColor )
               // como no es un control, tienes que mandarlo con la clausula
               // ON PAINT del dialogo o la ventana. Para lineas
               // horizontales, nTop y nBottom deben ser iguales; para
               // lineas verticales, nLeft y nRight deben ser iguales.
               // En este ejemplo la uso para simular el menu.

   oFont:End()
   oBrush:End()

Return Nil

//--------------------------------------------------------------------------//

Static Function Child2()

   Local oFont, oBtn[ 6 ], oBrush, nEle, ;
         aVisit := Array( 5 )

   If aChild[ 2 ] == Nil

      AFill( aVisit, .F. )

      DEFINE FONT oFont NAME "MS Sans Serif" SIZE 0, -10 BOLD UNDERLINE ITALIC
      DEFINE BRUSH oBrush RESOURCE "Back1"

      DEFINE WINDOW aChild[ 2 ] FROM 0, 0 TO 346, 400 PIXEL OF oWnd ;
             TITLE "Super Buttons  ¡ Todos los Botones SIN DLL's !" ;
             COLORS CLR_BLACK, CLR_CYAN ;
             STYLE nOR( WS_DLGFRAME, WS_VISIBLE ) ;
             BRUSH oBrush ;
             MDICHILD

      @20, 30 SBUTTON oBtn[ 1 ] OF aChild[ 2 ] FONT oFont PIXEL ;
              CAPTION "Products" SIZE 75, 20 ;
              COLORS  { |oBtn| If( aVisit[ 1 ], CLR_HGREEN, CLR_YELLOW ) }, ;
                      CLR_BLACK ;
              ACTION ( oBtn[ 1 ]:SetText( "Productos" ), ;
                       oBtn[ 1 ]:SetColor( CLR_HRED, CLR_BLACK ), ;
                       oBtn[ 1 ]:Refresh() ) ;
              MESSAGE "http://www.superbuttons.com/products.html" ;
              TOOLTIP "NOBOX" ;
              NOBOX

      @20,110 SBUTTON oBtn[ 2 ] OF aChild[ 2 ] FONT oFont PIXEL ;
              PROMPT "Downloads" SIZE 75, 20 ;
              COLORS  { |oBtn| If( aVisit[ 2 ], CLR_HGREEN, CLR_YELLOW ) }, ;
                      CLR_BLACK ;
              ACTION ( aVisit[ 2 ] := ! aVisit[ 2 ], oBtn[ 2 ]:Refresh() ) ;
              MESSAGE "http://www.superbuttons.com/Dowloads.html" ;
              TOOLTIP "NOBOX" ;
              NOBOX

      @20,190 SBUTTON oBtn[ 3 ] OF aChild[ 2 ] FONT oFont PIXEL ;
              CAPTION "Shopping" SIZE 75, 20 ;
              COLORS  { |oBtn| If( aVisit[ 3 ], CLR_HGREEN, CLR_YELLOW ) }, ;
                      CLR_BLACK ;
              ACTION ( aVisit[ 3 ] := ! aVisit[ 3 ], oBtn[ 3 ]:Refresh() ) ;
              MESSAGE "http://www.superbuttons.com/Shopping.html" ;
              TOOLTIP "NOBOX" ;
              NOBOX

      @20,270 SBUTTON oBtn[ 4 ] OF aChild[ 2 ] FONT oFont PIXEL ;
              CAPTION "Links" SIZE 75, 20 ;
              COLORS  { |oBtn| If( aVisit[ 4 ], CLR_HGREEN, CLR_YELLOW ) }, ;
                      CLR_BLACK ;
              ACTION ( aVisit[ 4 ] := ! aVisit[ 4 ], oBtn[ 4 ]:Refresh() ) ;
              MESSAGE "http://www.superbuttons.com/links.html" ;
              TOOLTIP "NOBOX" ;
              NOBOX

      @250,20 SBUTTON oBtn[ 5 ] OF aChild[ 2 ] FONT oFont PIXEL ;
              CAPTION "Start Page" SIZE 75, 15 ;
              COLORS  { |oBtn| If( oBtn:lMouseOver, CLR_YELLOW, CLR_BLACK ) }, ;
                      CLR_HGRAY ;
              ACTION aChild[ 2 ]:End() ;
              MESSAGE "http://www.superbuttons.com" ;
              TOOLTIP "BRUSH, NOBOX" ;
              BRUSH oBrush ;
              NOBOX

      @270,50 SBUTTON oBtn[ 6 ] OF aChild[ 2 ] FONT oFont PIXEL ;
              CAPTION "Web Master:   Manuel Mercado" SIZE 200, 15 ;
              COLORS  { |oBtn| If( oBtn:lMouseOver, CLR_YELLOW, CLR_BLACK ) } ;
              ACTION aChild[ 2 ]:End() ;
              MESSAGE "mmercadog@prodigy.net.mx" ;
              TOOLTIP "BRUSH, NOBOX" ;
              BRUSH oBrush ;
              NOBOX

      // no quiero el rectangulo puteado del foco
      For nEle := 1 To 6
         oBtn[ nEle ]:nStyle := nAnd( oBtn[ nEle ]:nStyle, nNot( WS_TABSTOP ) )
      Next

      ACTIVATE WINDOW aChild[ 2 ] ;
               VALID ( aChild[ 2 ] := Nil, oFont:End(), oBrush:End(), .T. )

      SET MESSAGE OF aChild[ 2 ] TO "Super Buttons, ¡ Simulando Hipervínculos !"

   Else
      aChild[ 2 ]:SetFocus()
   EndIf

Return Nil

//--------------------------------------------------------------------------//

Static Function Child3()

   // usando matrices de botones

   Local oWnd, oFont, oFont1, nEle, bAction, oBut, nAct, nSub, ;
         aBtn1, aBtn2, aCapt1, aCapt2, aAct1, aAct2

   If aChild[ 3 ] == Nil

      // el metodo Disable() permite un desactivado virtual que puede
      // deshacerse con la tecla que se pasa como parametro (en su caso)
      // para usar esta facilidad es necesario haber definido el bitmap 3
      // ( estado inactivo ) o un bitmap multiple
      bAction := {|oBtn| oBtn:cCaption := "", oBtn:Disable( VK_RBUTTON ), ;
                         oBtn:Refresh() }

      DEFINE FONT oFont NAME "Arial" SIZE 0, -12
      DEFINE FONT oFont1 NAME "Arial" SIZE 0, -8

      DEFINE WINDOW aChild[ 3 ] OF oWnd FROM 0, 0 TO 250, 500 PIXEL ;
             TITLE "Super Buttons  Matrices de Botones. " + ;
                   "  Reservaciones de asientos" ;
             COLOR CLR_BLACK, CLR_CYAN ;
             MDICHILD

      // jugando con las barras de botones vacias solo para apariencia
      DEFINE BUTTONBAR oBar OF aChild[ 3 ] SIZE 10, 10 LEFT
      DEFINE BUTTONBAR oBar1 OF aChild[ 3 ] SIZE 20, 20 RIGHT

      // un array para los objetos TSButton
      // para matrices de botones, el array debe ser bidimensional
      aBtn1 := { Array( 10 ), Array( 10 ) } // matriz de botones

      // las acciones de los botones deben ser bloques de codigo que se pasan
      // en un array unidimensional
      aAct1 := Array( 20 )
      AFill( aAct1, bAction )

      // los textos (captions) deben pasarse en un array unidimensional
      // con el total de elementos de la matriz
      aCapt1 := { "1", "5", "9", "13", "17", "21", "25", "29", "33", "37", ;
                  "2", "6", "10", "14", "18", "22", "26", "30", "34", "38" }

      // creando la matriz
      @10,90 SBGROUP aBtn1 OF aChild[ 3 ] ;
             CAPTION aCapt1 ;
             SIZE 34, 34 PIXELS ;
             FONT oFont ;
             ACTION aAct1 ;
             RESOURCE "Seatm", "Seatm", "Seatm", "Seatm" ; // multi bitmap
             MESSAGE "Click izquierdo: Reservar Asientos.  " + ;
                     "Click derecho: Cancelar Reservación." ;
             COLORS CLR_WHITE, CLR_CYAN ;
             TEXT ON_CENTER ;
             LOOK W97
      // para usar un bitmap multiple ( 4 en 1 ) debes definir el mismo
      // bitmap para los cuatro estados

      nAct := 1

      // Aqui estoy usando la variable "Cargo" para guardar el texto (caption)
      // del boton y poder restaurarlo cuando se reactive.
      // El desactivado virtual me permite usar el click derecho del mouse
      // para restablecer un botón , cosa que no se puede hacer con el
      // "Disable()" normal.
      For nEle := 1 To Len( aBtn1 )
         For nSub := 1 To Len( aBtn1[ nEle ] )
            aBtn1[ nEle, nSub ]:Cargo := aCapt1[ nAct++ ]
            aBtn1[ nEle, nSub ]:bRClicked := {|oBtn| fCancel( oBtn ) }
         Next
      Next

      // ahora vamos a definir otra matriz de botones (solo 4 instrucciones):
      aBtn2 := { Array( 10 ), Array( 10 ) }
      AFill( aAct2 := Array( 20 ), bAction )
      aCapt2 := { "3", "7", "11", "15", "19", "23", "27", "31", "35", "39", ;
                  "4", "8", "12", "16", "20", "24", "28", "32", "36", "40" }

      @108,90 SBGROUP aBtn2 ;
              PROMPT aCapt2 OF aChild[ 3 ] ;
              SIZE 34, 34 PIXELS ;
              FONT oFont ;
              ACTION aAct2 ;
              RESOURCE "Seatm", "Seatm", "Seatm", "Seatm" ; // multi bitmap
              MESSAGE "Click izquierdo: Reservar Asientos.  " + ;
                      "Click derecho: Cancelar Reservación." ;
              COLORS CLR_WHITE, CLR_CYAN ;
              TEXT ON_CENTER ;
              LOOK W97

      nAct := 1

      For nEle := 1 To Len( aBtn2 )
         For nSub := 1 To Len( aBtn2[ nEle ] )
            aBtn2[ nEle, nSub ]:Cargo := aCapt2[ nAct++ ]
            aBtn2[ nEle, nSub ]:bRClicked := {|oBtn| fCancel( oBtn ) }
         Next
      Next

      // los siguientes son Super Buttons individuales
      @10, 20 SBUTTON oBut PROMPT "Salida" OF aChild[ 3 ] FONT oFont ;
              SIZE 60,20 PIXEL ACTION aChild[ 3 ]:End() ;
              COLORS CLR_WHITE, CLR_BLUE

      @128, 20 SBUTTON OF aChild[ 3 ] RESOURCE "Driver" PIXEL ; // FONT oFont ;
               MESSAGE "No distraga al conductor" ;
               COLOR , CLR_CYAN ;
               NOBOX

      @176, 60 SBUTTON RESOURCE "TV" OF aChild[ 3 ] PIXEL ;
               FONT oFont1 ;
               CAPTION "TV" ;
               COLOR CLR_WHITE, CLR_CYAN ;
               TEXT ON_CENTER ;
               NOBOX

      @176,200 SBUTTON RESOURCE "TV" OF aChild[ 3 ] PIXEL ;
               FONT oFont1 ;
               CAPTION "TV" ;
               COLOR CLR_WHITE, CLR_CYAN ;
               TEXT ON_CENTER ;
               NOBOX

      @176,310 SBUTTON RESOURCE "TV" OF aChild[ 3 ] PIXEL ;
               FONT oFont1 ;
               CAPTION "TV" ;
               COLOR CLR_WHITE, CLR_CYAN ;
               TEXT ON_CENTER ;
               NOBOX

      SET MESSAGE OF aChild[ 3 ] TO "Super Buttons, ¡ Matrices de Botones !"

      ACTIVATE WINDOW aChild[ 3 ] ;
               VALID ( aChild[ 3 ] := Nil, oFont:End(), oFont1:End(), .T. )

   Else
      aChild[ 3 ]:SetFocus()
   EndIf

Return Nil

//--------------------------------------------------------------------------//

Static Function fCancel( oBtn )

   MsgInfo( "Reservación Cancelada" )
   oBtn:Enable()
   oBtn:cCaption := oBtn:Cargo
   oBtn:Refresh()

Return Nil