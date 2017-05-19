#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TiposNotas FROM SQLBaseView

   METHOD   New()

   METHOD   buildSQLShell()

   METHOD   getFieldFromBrowse()          INLINE ( ::oController:getRowSet():fieldGet( "tipo" ) )
 
   METHOD   Dialog()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oController      := oController

Return ( Self )

//---------------------------------------------------------------------------//

METHOD buildSQLShell()

   disableAcceso()

   ::oShell                := SQLTShell():New( 2, 10, 18, 70, "Tipos de notas", , oWnd(), , , .f., , , ::oController:oModel, , , , , {}, {|| ::oController:Edit( ::oShell:getBrowse() ) },, {|| ::oController:Delete( ::oShell:getBrowse() ) },, nil, ::oController:nLevel, "gc_folder2_16", ( 104 + ( 0 * 256 ) + ( 63 * 65536 ) ),,, .t. )

   	with object ( ::oShell:AddCol() )
        :cHeader          := "Id"
        :cSortOrder       := "id"
        :bEditValue       := {|| ::oController:getRowSet():fieldGet( "id" ) }
        :nWidth           := 40
        :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | ::oController:clickOnHeader( oCol, ::oShell:getBrowse(), ::oShell:getCombobox() ) }
    	end with

   	with object ( ::oShell:AddCol() )
        :cHeader          := "Tipo"
        :cSortOrder       := "tipo"
        :bEditValue       := {|| ::oController:getRowSet():fieldGet( "tipo" ) }
        :nWidth           := 800
        :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | ::oController:clickOnHeader( oCol, ::oShell:getBrowse(), ::oShell:getCombobox() ) }
    	end with

		::oShell:createXFromCode()

      ::oShell:setDClickData( {|| ::oController:Edit( ::oShell:getBrowse() ) } )

      ::AutoButtons()

   ACTIVATE WINDOW ::oShell

   ::oShell:bValid   := {|| ::saveHistoryOfShell( ::oShell:getBrowse() ), .t. }
   ::oShell:bEnd     := {|| ::oController:destroySQLModel() }

   ::oShell:setComboBoxChange( {|| ::changeCombo( ::oShell:getBrowse(), ::oShell:getCombobox() ) } )

   enableAcceso()

Return ( Self )

//----------------------------------------------------------------------------//

METHOD Dialog( lZoom )

   local oDlg
   local oGetNombre

   DEFINE DIALOG oDlg RESOURCE "TiposNotas" TITLE ::lblTitle() + "tipo de nota"

   REDEFINE GET   oGetNombre ;
      VAR         ::oController:oModel:hBuffer[ "tipo" ] ;
      MEMO ;
      ID          100 ;
      WHEN        ( !::oController:isZoomMode() ) ;
      OF          oDlg

   REDEFINE BUTTON ;
      ID          IDOK ;
      OF          oDlg ;
      WHEN        ( !::oController:isZoomMode() ) ;
      ACTION      ( ::oController:validDialog( oDlg, oGetNombre ) )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          oDlg ;
      CANCEL ;
      ACTION      ( oDlg:end() )

   // Teclas rpidas-----------------------------------------------------------

   oDlg:AddFastKey( VK_F5, {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//

