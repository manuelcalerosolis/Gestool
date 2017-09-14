#include "FiveWin.Ch"
#include "button.ch"

// Ejemplo de BTNBMP con Texto y Menus

STATIC oWnd

FUNCTION Main()

   LOCAL oBarra

   SET RESOURCES TO "Button.dll"

   DEFINE WINDOW oWnd FROM 0,0 TO 400,600 PIXEL ;
          TITLE "TreeNew" MDI

       DEFINE BUTTONBAR oBarra OF oWnd SIZE 30,30 LABELS _3D

       DEFINE BUTTON RESOURCE "Database_u","Database" OF oBarra ;
              PROMPT "Trabajar" MENU MenuDatabase(This) ;
              MESSAGE "Trabajar con bases de datos ..." ACTION Database() ;
              NOBORDER TOOLTIP "Trabajar con bases de datos ..."

       SET MESSAGE OF oWnd KEYBOARD NOINSET

       ACTIVATE WINDOW oWnd

RETURN nil

FUNCTION Database()

   USE Clientes NEW
   browse()
   USE

RETURN NIL

FUNCTION MenuDatabase(oControl)

   LOCAL oMenu

   MENU oMenu POPUP
        MENUITEM "&Database" ACTION Database() ;
                 RESOURCE "Database" ;
                 MESSAGE "Trabajar con la base de datos ..."
        MENUITEM "&Salir" ACTION oWnd:End() ;
                 RESOURCE "Salir" ;
                 MESSAGE "Salir del programa ..."
   ENDMENU

   ACTIVATE POPUP oMenu AT oControl:nBottom - 1 , 0 OF oControl

RETURN nil