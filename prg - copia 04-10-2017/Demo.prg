//
//  EJEMPLO DEL USO DE LA NUEVA CLASE TASSIST
//
//  JUAN CARLOS SALINAS OJEDA
//  jcso@hotmail.com
//
//  Minatitlan, Veracruz, MEXICO

#include "FiveWin.Ch"
#include "Colors.ch"
#include "Assist.ch"
#include "Constant.ch"

Static lSalir := .F.

//----------------------------------------------------------------------------//

Static oWnd

Function Main( )

 Local oBrush
 Local oIco
 Local oAsis1
 Local oAsis2
 Local oAsis3

 SET RESOURCES TO "DEMO.DLL"

 SET HELPFILE TO "TASSIST.HLP"

 DEFINE ASSIST oAsis1 CHARACTER OJITOS NAME CHARACTER "Ojitos" ; // definimos el asistente ojitos
 WITH MENUPOPUP  ;
 CHANGE ANIMATIONS SHOW AT 10,10

 DEFINE ASSIST oAsis2 CHARACTER TACHIDO NAME CHARACTER "T-K-es" ; //definimos el asistente mariposa
 WITH MENUPOPUP  ;
 CHANGE ANIMATIONS SHOW AT 15,10

 DEFINE ASSIST oAsis3 CHARACTER MARIPOSA ;      //definimos y personalizamos el asistente mariposa
 WITH MENUPOPUP  ;
 CHANGE ANIMATIONS SHOW AT 20,10
 oAsis3:cAyuda        := "Si das Click en mi te ayudo"
 oAsis3:cTxtHello     := "Que tal, Lindo dia no?"
 oAsis3:cMyNameIs     := "me llamo"
 oAsis3:cAssistName   := "Mari mariposa"
 oAsis3:cWhatCanIDo   := "En que puedo ayudarte ?"
 oAsis3:cShowContenid := "Ver Contenido de la ayuda"
 oAsis3:cShowIndex    := "Ver el indice"
 oAsis3:cCancela      := "Ya no necesitas ayuda"
 oAsis3:cGetMsg       := "Escribe lo que buscas....."


 DEFINE BRUSH oBrush COLOR CLR_BLUE
 DEFINE ICON oIco RESOURCE "ICONO"

 DEFINE WINDOW oWnd FROM 0,0 TO 25,75 TITLE "Nueva clase TAssist Beta 1";
 MENU  CreaMenu( oAsis1, oAsis2, oAsis3 );
 ICON  oIco ;
 BRUSH oBrush

 ACTIVATE WINDOW oWnd

 oAsis1:End()
 oAsis2:End()
 oAsis3:End()
 oBrush:End()
 oIco:End()

Return NIL

//--------------------------------------------------------------------------------------------------------------

Function CreaMenu( oAsis1, oAsis2, oAsis3 )

 Local oMenu

 MENU oMenu

      MENUITEM "&Ojitos"
      MENU
          MENUITEM "&Mostrar Asistente" RESOURCE "ASISTENTE" ;
          ACTION oAsis1:Show()
          MENUITEM "&Ocultar Asistente" RESOURCE "ASISTENTE" ;
          ACTION oAsis1:Hide()
          SEPARATOR
          MENUITEM "&Salir" RESOURCE "SALIR" ;
          ACTION oWnd:End()
      ENDMENU

      MENUITEM "&Tachido"
      MENU
          MENUITEM "&Mostrar Asistente" RESOURCE "ASISTENTE" ;
          ACTION oAsis2:Show()
          MENUITEM "&Ocultar Asistente" RESOURCE "ASISTENTE" ;
          ACTION oAsis2:Hide()
      ENDMENU

      MENUITEM "&Mariposa"
      MENU
          MENUITEM "&Mostrar Asistente" RESOURCE "ASISTENTE" ;
          ACTION oAsis3:Show()
          MENUITEM "&Ocultar Asistente" RESOURCE "ASISTENTE" ;
          ACTION oAsis3:Hide()
      ENDMENU

      MENUITEM "?"
      MENU
          MENUITEM "&Acerca de.." RESOURCE "ACERCA";
          ACTION Acercade()
      ENDMENU

 ENDMENU

Return oMenu

//-------------------------------------------------------------------------------------------------------------------

Function Acercade()
 Local oDlg
 DEFINE DIALOG oDlg RESOURCE "ACERCA"
 ACTIVATE DIALOG oDlg
Return NIL