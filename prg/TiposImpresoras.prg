#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TiposImpresoras FROM SQLBaseView

   METHOD   New()

   METHOD   Activate()

   METHOD   buildSQLModel()

   METHOD   buildSQLShell()

   METHOD   destroySQLModel()                         INLINE   ( if( !empty(::oModel), ::oModel:end(), ) )

   METHOD   Destroy()                                 INLINE   ( ::saveHistory(), ::destroySQLModel(), .t. )

   METHOD   clickOnHeader( oCol )

   METHOD   setCombo()
   METHOD   chgCombo()                   

   METHOD   Append()
   METHOD   Edit()
   METHOD   Dialog()

   METHOD   getHistory()
   METHOD   saveHistory()

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::keyUserMap         := "01115"

Return ( Self )

//---------------------------------------------------------------------------//

METHOD Activate()

   if ::notUserAccess()
      msgStop( "Acceso no permitido." )
      Return ( Self )
   end if 

   if oWnd() != nil
      SysRefresh(); oWnd():CloseAll(); SysRefresh()
   end if

   ::buildSQLModel()

   ::buildSQLShell()

   // ::destroySQLModel()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD buildSQLModel()

   ::oModel    := TiposImpresorasModel():New()

   ::getHistory()

   ::oModel:buildRowSetWithRecno()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD buildSQLShell()

   disableAcceso()

   ::oShell                := TShellSQL():New( 2, 10, 18, 70, "Tipos de impresoras", , oWnd(), , , .f., , , ::oModel, , , , , {}, {|| ::Edit() },, {|| ::oModel:deleteSelection() },, nil, ::nLevel, "gc_printer2_16", ( 104 + ( 0 * 256 ) + ( 63 * 65536 ) ),,, .t. )


      with object ( ::oShell:AddXCol() )
         :cHeader          := "Id"
         :cSortOrder       := "id"
         :bEditValue       := {|| ::oModel:getRowSet():fieldGet( "id" ) }
         :nWidth           := 40
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | ::clickOnHeader( oCol ) }
      end with

      with object ( ::oShell:AddXCol() )
         :cHeader          := "Tipo de impresora"
         :cSortOrder       := "nombre"
         :bEditValue       := {|| ::oModel:getRowSet():fieldGet( "nombre" ) }
         :nWidth           := 800
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | ::clickOnHeader( oCol ) }
      end with

      ::oShell:CreateXFromCode()

      DEFINE BTNSHELL RESOURCE "BUS" OF ::oShell ;
         NOBORDER ;
         ACTION   ( ::oShell:SearchSetFocus() ) ;
         TOOLTIP  "(B)uscar" ;
         HOTKEY   "B"

      ::oShell:AddSeaBar()

      DEFINE BTNSHELL RESOURCE "NEW" OF ::oShell ;
         NOBORDER ;
         ACTION   ( ::Append() );
         TOOLTIP  "(A)ñadir";
         BEGIN GROUP;
         HOTKEY   "A";
         LEVEL    ACC_APPD

      DEFINE BTNSHELL RESOURCE "EDIT" OF ::oShell ;
         NOBORDER ;
         ACTION   ( ::Edit() );
         TOOLTIP  "(M)odificar";
         HOTKEY   "M" ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "ZOOM" OF ::oShell ;
         NOBORDER ;
         ACTION   ( msgalert( "zoom" ) );
         TOOLTIP  "(Z)oom";
         MRU ;
         HOTKEY   "Z";
         LEVEL    ACC_ZOOM

      DEFINE BTNSHELL RESOURCE "DEL" OF ::oShell ;
         NOBORDER ;
         ACTION   ::oModel:deleteSelection();
         TOOLTIP  "(E)liminar";
         MRU ;
         HOTKEY   "E";
         LEVEL    ACC_DELE

      DEFINE BTNSHELL RESOURCE "END" GROUP OF ::oShell ;
         NOBORDER ;
         ACTION   ( ::oShell:end() ) ;
         TOOLTIP  "(S)alir" ;
         HOTKEY   "S"

   ACTIVATE WINDOW ::oShell VALID ( ::Destroy() )

   ::oShell:setComboBoxChange( {|| ::ChgCombo() } )

   ::SetCombo()

   enableAcceso()

RETURN NIL

//----------------------------------------------------------------------------//

METHOD Append()

   local nRecno   := ::oModel:getRowSetRecno()

   ::oModel:loadBlankBuffer()

   if ::Dialog()
      ::oModel:insertBuffer()
   else 
      ::oModel:setRowSetRecno( nRecno ) 
   end if

RETURN NIL

//----------------------------------------------------------------------------//
/*
Monta el dialogo para añadir, editar,... registros
*/

METHOD Edit()

   local nRecno   := ::oModel:getRowSetRecno()

   ::oModel:loadCurrentBuffer()

   if ::Dialog()
      ::oModel:updateCurrentBuffer()
      ::oModel:setRowSetRecno( nRecno )
   end if 

RETURN NIL

//----------------------------------------------------------------------------//

METHOD Dialog()

   local oDlg
   local oGetNombre

   DEFINE DIALOG oDlg RESOURCE "TIPO_IMPRESORA" TITLE "Tipos de impresoras"

   REDEFINE GET   oGetNombre ;
      VAR         ::oModel:hBuffer[ "nombre" ] ;
      MEMO ;
      ID          100 ;
      OF          oDlg

   REDEFINE BUTTON ;
      ID          IDOK ;
      OF          oDlg ;
      ACTION      ( oDlg:end( IDOK ) )

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

METHOD getHistory()

   local hFetch            := HistoricosUsuariosModel():getHistory( ::oModel:getTableName() )

   if empty( hFetch )
      Return ( Self )
   end if

   if hhaskey( hFetch, "cColumnOrder" )
      ::oModel:setColumnOrder( hFetch[ "cColumnOrder" ] )
   end if 

   if hhaskey( hFetch, "cOrientation" )
      ::oModel:setOrientation( hFetch[ "cOrientation" ] )
   end if 

   if hhaskey( hFetch, "nIdForRecno" ) 
      ::oModel:setIdForRecno( hFetch[ "nIdForRecno" ] )
   end if
   
Return ( self )

//----------------------------------------------------------------------------//

METHOD saveHistory()

   HistoricosUsuariosModel():saveHistory( ::oModel:cColumnOrder, ::oModel:cOrientation, ::oModel:getKeyFieldOfRecno(), ::oModel:getTableName() ) 

Return ( self )

//----------------------------------------------------------------------------//

METHOD clickOnHeader( oColumn )

   ::oShell:selectColumnOrder( oColumn )

   ::oModel:setIdForRecno( ::oModel:getKeyFieldOfRecno() )

   ::oModel:setColumnOrder( oColumn:cSortOrder )

   ::oModel:setOrientation( oColumn:cOrder )

   ::oModel:buildRowSetWithRecno()

   ::oShell:Refresh()

Return ( self )

//----------------------------------------------------------------------------//

METHOD ChgCombo()

   local oColumn  := ::oShell:getColumnBrowse( ::oShell:oWndBar:GetComboBox() )

   if !empty( oColumn )
      ::clickOnHeader( oColumn )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD SetCombo()

   local oColumn  := ::oShell:getColumnBrowse( ::oModel:cColumnOrder )

   if !empty( oColumn )
      ::clickOnHeader( oColumn )
   end if


RETURN ( Self )

//---------------------------------------------------------------------------//

