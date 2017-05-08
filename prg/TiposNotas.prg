#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TiposNotas FROM SQLBaseView

   METHOD   New()

   METHOD   buildSQLShell()

   METHOD   buildSQLModel()               INLINE ( TiposNotasModel():New() )

   METHOD   getFieldFromBrowse()          INLINE ( ::oModel:getRowSet():fieldGet( "tipo" ) )
 
   METHOD   Dialog()

   METHOD   validDialog( oDlg, oGetNombre )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::idUserMap            := "01097"

   ::Super:New()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD buildSQLShell()

   disableAcceso()

   ::oShell                := SQLTShell():New( 2, 10, 18, 70, "Tipos de notas", , oWnd(), , , .f., , , ::oModel, , , , , {}, {|| ::Edit() },, {|| ::Delete() },, nil, ::nLevel, "gc_folder2_16", ( 104 + ( 0 * 256 ) + ( 63 * 65536 ) ),,, .t. )

   	with object ( ::oShell:AddCol() )
        :cHeader          := "Id"
        :cSortOrder       := "id"
        :bEditValue       := {|| ::oModel:getRowSet():fieldGet( "id" ) }
        :nWidth           := 40
        :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | ::clickOnHeader( oCol, ::oShell:getBrowse(), ::oShell:getCombobox() ) }
    	end with

   	with object ( ::oShell:AddCol() )
        :cHeader          := "Tipo"
        :cSortOrder       := "tipo"
        :bEditValue       := {|| ::oModel:getRowSet():fieldGet( "tipo" ) }
        :nWidth           := 800
        :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | ::clickOnHeader( oCol, ::oShell:getBrowse(), ::oShell:getCombobox() ) }
    	end with

		::oShell:createXFromCode()

      ::oShell:setDClickData( {|| ::Edit( ::oShell:getBrowse() ) } )

      ::AutoButtons()

   ACTIVATE WINDOW ::oShell

   ::oShell:bValid   := {|| ::saveHistory( ::getHistoryNameShell() , ::oShell:getBrowse() ), .t. }
   ::oShell:bEnd     := {|| ::destroySQLModel() }

   ::oShell:setComboBoxChange( {|| ::changeCombo( ::oShell:getBrowse(), ::oShell:getCombobox() ) } )

   enableAcceso()

Return ( Self )

//----------------------------------------------------------------------------//

METHOD Dialog( lZoom )

   local oDlg
   local oGetNombre

   DEFINE DIALOG oDlg RESOURCE "TiposNotas" TITLE ::lblTitle() + "tipo de nota"

   REDEFINE GET   oGetNombre ;
      VAR         ::oModel:hBuffer[ "tipo" ] ;
      MEMO ;
      ID          100 ;
      WHEN        ( ! ::isZoomMode() ) ;
      OF          oDlg

   REDEFINE BUTTON ;
      ID          IDOK ;
      OF          oDlg ;
      WHEN        ( ! ::isZoomMode() ) ;
      ACTION      ( ::validDialog( oDlg, oGetNombre ) )

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

METHOD validDialog( oDlg, oGetNombre )

   if empty( ::oModel:hBuffer[ "tipo" ] )
      msgStop( "El nombre de la nota no puede estar vacío." )
      oGetNombre:setFocus()
      RETURN ( .f. )
   end if

   if ::oModel:getRowSet():find( ::oModel:hBuffer[ "tipo" ], "tipo" ) != 0
      msgStop( "Esta nota ya existe" )
      oGetNombre:setFocus()
      RETURN ( .f. )
   end if

RETURN ( oDlg:end( IDOK ) )

//----------------------------------------------------------------------------//