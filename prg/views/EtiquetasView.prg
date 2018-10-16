#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS EtiquetasView FROM SQLBaseView

   METHOD   New()

   METHOD   buildSQLBrowse()
   
   METHOD   Activate()

   METHOD   insertAfterAppendButton()

   METHOD   LblTitle()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oController     := oController

Return ( Self )

//---------------------------------------------------------------------------//

METHOD insertAfterAppendButton()

   DEFINE BTNSHELL RESOURCE "NEW" OF ::oShell ;
      NOBORDER ;
      ACTION   ( ::oController:AppendChild( ::oShell:getBrowse() ) );
      TOOLTIP  "(A)�adir Hijos";
      BEGIN GROUP;
      HOTKEY   "H";
      LEVEL    ACC_APPD

Return ( Self )

//----------------------------------------------------------------------------//

METHOD Activate()

   local oDlg
   local oBtnOk
   local oTree
   local oGetNombre
   local oBmpEtiquetas

   DEFINE DIALOG oDlg RESOURCE "ETIQUETA" TITLE ::lblTitle() + "etiqueta"

   REDEFINE BITMAP oBmpEtiquetas ;
         ID       500 ;
         RESOURCE "gc_bookmarks_48" ;
         TRANSPARENT ;
         OF       oDlg

   REDEFINE GET   oGetNombre ;
      VAR         ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          100 ;
      MEMO ;
      WHEN        ( !::oController:isZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          oDlg

   oTree                      := TTreeView():Redefine( 110, oDlg )
   // oTree:bItemSelectChanged   := {|| ::oController:changeTree( oTree ) }
   // oTree:bWhen                := {|| !::oController:isSpecialMode()  .and. !::oController:isZoomMode() }

   ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, oBtnOk:Click(), ) }

   if ::oController:isNotZoomMode() 
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5 .and. validateDialog( ::oDialog ), oBtnOk:Click(), ) }
   end if

   // evento bstart-----------------------------------------------------------

   oDlg:bStart       := {|| oGetNombre:setFocus() }

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD LblTitle()

   if ::oController:isSpecialMode()
      RETURN ( "A�adiendo hijo a " )
   end if 

RETURN( ::Super:lblTitle() )

//---------------------------------------------------------------------------//

METHOD buildSQLBrowse( title, aSelectedItems )

   local oDlg
   local oTree
   local oFind
   local cFind       := space( 200 )

   DEFINE DIALOG oDlg RESOURCE "HELP_ETIQUETAS" TITLE "Seleccionar " + lower( title )

      REDEFINE GET   oFind ; 
         VAR         cFind ;
         ID          104 ;
         BITMAP      "FIND" ;
         OF          oDlg

      oFind:bChange  := {|| ::oController:changeFindTree( oFind, oTree ) }

      oTree          := TTreeView():Redefine( 110, oDlg )

      ::oController:setAllSelectedNode( aSelectedItems ) 

      ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

      ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )
      

      REDEFINE BUTTON ;
         ID          500 ;
         OF          oDlg ;
         ACTION      ( ::oController:appendOnBrowse( oTree, aSelectedItems ) )

      REDEFINE BUTTON ;
         ID          501 ;
         OF          oDlg ;
         ACTION      (  ::oController:editOnBrowse( oTree, aSelectedItems ) )

      oDlg:AddFastKey( VK_RETURN,   {|| ::oController:validBrowse( oDlg, oTree ) } )
      oDlg:AddFastKey( VK_F5,       {|| ::oController:validBrowse( oDlg, oTree ) } )
      oDlg:AddFastKey( VK_F2,       {|| ::oController:appendOnBrowse( oTree, aSelectedItems ) } )
      oDlg:AddFastKey( VK_F3,       {|| ::oController:editOnBrowse( oTree, aSelectedItems ) } )

      oDlg:bStart    := {|| ::oController:loadTree( oTree ), ::oController:setTreeSelectedItems( oTree ) }

   oDlg:Activate( , , , .t., )

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//
