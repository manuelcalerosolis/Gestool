#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS Etiquetas FROM SQLBaseView

   METHOD   New()

   METHOD   buildSQLBrowse()
   
   METHOD   Dialog()

   METHOD   insertAfterAppendButton()

   METHOD   LblTitle()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oController     := oController

   ::cImageName      := "gc_bookmarks_16"

Return ( Self )

//---------------------------------------------------------------------------//

METHOD insertAfterAppendButton()

   DEFINE BTNSHELL RESOURCE "NEW" OF ::oShell ;
      NOBORDER ;
      ACTION   ( ::oController:AppendChild( ::oShell:getBrowse() ) );
      TOOLTIP  "(A)ñadir Hijos";
      BEGIN GROUP;
      HOTKEY   "H";
      LEVEL    ACC_APPD

Return ( Self )

//----------------------------------------------------------------------------//

METHOD Dialog()

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
      WHEN        ( !::oController:isZoomMode() ) ;
      VALID       ( ::oController:validNombre( oGetNombre ) ) ;
      OF          oDlg

   oTree                      := TTreeView():Redefine( 110, oDlg )
   oTree:bItemSelectChanged   := {|| ::oController:changeTree( oTree ) }
   oTree:bWhen                := {|| !::oController:isSpecialMode()  .and. !::oController:isZoomMode() }

   REDEFINE BUTTON oBtnOk ;
      ID          IDOK ;
      OF          oDlg ;
      WHEN        ( !::oController:isZoomMode() ) ;
      ACTION      ( if( validateDialog( oDlg ), oDlg:end( IDOK ), ) )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          oDlg ;
      CANCEL ;
      ACTION      ( oDlg:end() )

   // Teclas rpidas-----------------------------------------------------------

   oDlg:AddFastKey( VK_F5, {|| oBtnOk:Click() } )

   // evento bstart-----------------------------------------------------------

   oDlg:bStart       := {|| ::oController:startDialog( oTree ), oGetNombre:setFocus() }

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD LblTitle()

   if ::oController:isSpecialMode()
      RETURN ( "Añadiendo hijo a " )
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

      REDEFINE BUTTON ;
         ID          IDOK ;
         OF          oDlg ;
         ACTION      ( ::oController:validBrowse( oDlg, oTree ) )

      REDEFINE BUTTON ;
         ID          IDCANCEL ;
         OF          oDlg ;
         CANCEL ;
         ACTION      ( oDlg:end() )

      REDEFINE BUTTON ;
         ID          500 ;
         OF          oDlg ;
         ACTION      (  ::oController:appendOnBrowse( oTree, aSelectedItems ) )

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
