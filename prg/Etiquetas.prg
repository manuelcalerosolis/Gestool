#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS Etiquetas FROM SQLBaseView

   DATA     oController

   METHOD   New()

   METHOD   buildSQLShell()

   METHOD   buildSQLBrowse()
   
   METHOD   Dialog()

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
      TOOLTIP  "(A)ñadir Hijos";
      BEGIN GROUP;
      HOTKEY   "H";
      LEVEL    ACC_APPD

Return ( Self )

//---------------------------------------------------------------------------//

METHOD buildSQLShell()

   disableAcceso()

   ::oShell                := SQLTShell():New( 2, 10, 18, 70, "Etiquetas", , oWnd(), , , .f., , , ::oController:oModel, , , , , {}, {|| ::oController:Edit( ::oShell:getBrowse() ) },, {|| ::oController:Delete( ::oShell:getBrowse() ) },, nil, ::oController:nLevel, "gc_bookmarks_16", ( 104 + ( 0 * 256 ) + ( 63 * 65536 ) ),,, .t. )

      with object ( ::oShell:AddCol() )
         :cHeader          := "ID de etiqueta"
         :cSortOrder       := "id"
         :bStrData         := {|| ::oController:getRowSet():fieldGet( "id" ) }
         :nWidth           := 100
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | ::oController:clickOnHeader( oCol, ::oShell:getBrowse(), ::oShell:getCombobox() ) }
      end with

      with object ( ::oShell:AddCol() )
         :cHeader          := "Nombre de la etiqueta"
         :cSortOrder       := "nombre"
         :bStrData         := {|| ::oController:getRowSet():fieldGet( "nombre" ) }
         :nWidth           := 400
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | ::oController:clickOnHeader( oCol, ::oShell:getBrowse(), ::oShell:getCombobox() ) }
      end with

      with object ( ::oShell:AddCol() )
         :cHeader          := "Nombre del Padre"
         :cSortOrder       := "nombre_padre"
         :bStrData         := {|| ::oController:getRowSet():fieldGet( "nombre_padre" ) }
         :nWidth           := 100
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | ::oController:clickOnHeader( oCol, ::oShell:getBrowse(), ::oShell:getCombobox() ) }
      end with

      ::oShell:createXFromCode()

      ::oShell:setDClickData( {|| ::oController:Edit( ::oShell:getBrowse() ) } )

      ::AutoButtons()

   ACTIVATE WINDOW ::oShell

   ::oShell:bValid         := {|| ::saveHistoryOfShell( ::oShell:getBrowse() ), .t. }
   ::oShell:bEnd           := {|| ::oController:destroySQLModel() }

   ::oShell:setComboBoxChange( {|| ::changeCombo( ::oShell:getBrowse(), ::oShell:getCombobox() ) } )

   enableAcceso()

Return ( Self )

//----------------------------------------------------------------------------//

METHOD Dialog( lZoom )

   local oDlg
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
      MEMO ;
      ID          100 ;
      WHEN        ( !::oController:isZoomMode() ) ;
      OF          oDlg

   oTree                      := TTreeView():Redefine( 110, oDlg )
   oTree:bItemSelectChanged   := {|| ::oController:changeTree( oTree ) }
   oTree:bWhen                := {|| !::oController:isSpecialMode()  .and. !::oController:isZoomMode() }

   REDEFINE BUTTON ;
      ID          IDOK ;
      OF          oDlg ;
      WHEN        ( !::oController:isZoomMode() ) ;
      ACTION      ( ::oController:validDialog( oDlg, oTree, oGetNombre ) )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          oDlg ;
      CANCEL ;
      ACTION      ( oDlg:end() )

   // Teclas rpidas-----------------------------------------------------------

   oDlg:AddFastKey( VK_F5, {|| ::oController:validDialog( oDlg, oTree, oGetNombre ) } )

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

METHOD buildSQLBrowse( aSelectedItems )

   local oDlg
   local oTree
   local oFind
   local cFind       := space( 200 )

   msgalert( hb_valtoexp( aSelectedItems ) )

   DEFINE DIALOG oDlg RESOURCE "HELP_ETIQUETAS" TITLE "Seleccionar etiquetas"

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
