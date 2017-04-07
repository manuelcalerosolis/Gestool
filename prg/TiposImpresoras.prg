#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

static oWndBrw
static oTiposImpresorasModel

//---------------------------------------------------------------------------//

/*
Monto el Browse principal
*/

FUNCTION TiposImpresoras( oMenuItem, oWnd )

   local nLevel

   DEFAULT  oMenuItem   := "01115"
   DEFAULT  oWnd        := oWnd()

   /*
   Obtenemos el nivel de acceso-----------------------------------------------
   */

   nLevel               := nLevelUsr( oMenuItem )

   if nAnd( nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      return nil
   end if

   /*
   Cerramos todas las ventanas-------------------------------------------------
   */

   if oWnd != nil
      SysRefresh(); oWnd:CloseAll(); SysRefresh()
   end if

   disableAcceso()

   oTiposImpresorasModel   := TiposImpresorasModel():New()
   oTiposImpresorasModel:getOrderRowSet()

   oWndBrw                 := TShellSQL():New( 2, 10, 18, 70, "Tipos de impresoras", , oWnd, , , .f., , , oTiposImpresorasModel, , , , , {}, {|| EditTiposImpresoras() },, {|| msgalert( "delete") },, nil, nLevel, "gc_printer2_16", ( 104 + ( 0 * 256 ) + ( 63 * 65536 ) ),,, .t. )

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Id"
         :cSortOrder       := "id"
         :bEditValue       := {|| oTiposImpresorasModel:getOrderRowSet():fieldGet( "id" ) }
         :nWidth           := 40
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:clickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Tipo de impresora"
         :cSortOrder       := "nombre"
         :bEditValue       := {|| oTiposImpresorasModel:getOrderRowSet():fieldGet( "nombre" ) }
         :nWidth           := 800
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:clickOnHeader( oCol ) }
      end with

      oWndBrw:CreateXFromCode()

      DEFINE BTNSHELL RESOURCE "BUS" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( oWndBrw:SearchSetFocus() ) ;
         TOOLTIP  "(B)uscar" ;
         HOTKEY   "B"

      oWndBrw:AddSeaBar()

      DEFINE BTNSHELL RESOURCE "NEW" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( oWndBrw:RecAdd() );
         ON DROP  ( oWndBrw:RecDup() );
         TOOLTIP  "(A)ñadir";
         BEGIN GROUP;
         HOTKEY   "A";
         LEVEL    ACC_APPD

      DEFINE BTNSHELL RESOURCE "ZOOM" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( msgalert( "zoom" ) );
         TOOLTIP  "(Z)oom";
         MRU ;
         HOTKEY   "Z";
         LEVEL    ACC_ZOOM

      DEFINE BTNSHELL RESOURCE "DEL" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( oWndBrw:RecDel() );
         TOOLTIP  "(E)liminar";
         MRU ;
         HOTKEY   "E";
         LEVEL    ACC_DELE

      DEFINE BTNSHELL RESOURCE "END" GROUP OF oWndBrw ;
         NOBORDER ;
         ACTION   ( oWndBrw:end() ) ;
         TOOLTIP  "(S)alir" ;
         HOTKEY   "S"

   ACTIVATE WINDOW oWndBrw VALID ( oTiposImpresorasModel:End(), .f. )

   EnableAcceso()

RETURN NIL

//----------------------------------------------------------------------------//

/*
Monta el dialogo para añadir, editar,... registros
*/

STATIC FUNCTION EditTiposImpresoras( id )

   local oDlg

   oTiposImpresorasModel:loadCurrent( id )

   DEFINE DIALOG oDlg RESOURCE "TIPO_IMPRESORA" TITLE LblTitle( nMode ) + "tipos de impresoras"

   REDEFINE GET oGetNombre ;
      VAR      oTiposImpresorasModel:get( "nombre" ) ;
      ID       100 ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      OF       oDlg

   REDEFINE BUTTON ;
      ID       IDOK ;
      OF       oDlg ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      ACTION   ( oTiposImpresorasModel:Save() )

   REDEFINE BUTTON ;
      ID       IDCANCEL ;
      OF       oDlg ;
      CANCEL ;
      ACTION   ( oDlg:end() )

   // Teclas r�pidas-----------------------------------------------------------

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| oTiposImpresorasModel:Save() } )
   end if

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//

