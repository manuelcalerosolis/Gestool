#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

#define __history_shell__     'tipos_impresoras_shell'
#define __history_browse__    'tipos_impresoras_browse'

//---------------------------------------------------------------------------//

CLASS TiposImpresoras FROM SQLBaseView

   METHOD   New()

   METHOD   activateShell()
      METHOD   buildSQLShell()

   METHOD   buildSQLModel()
   METHOD   destroySQLModel()                         INLINE   ( if( !empty(::oModel), ::oModel:end(), ) )
  
   METHOD   Dialog()

   METHOD   ActivateBrowse()
      METHOD   buildBrowse( oGet )
      METHOD   startBrowse( oFind, oCombobox, oBrowse )

   METHOD   destroy( cHistory )                       INLINE   ( ::saveHistory( cHistory ), ::destroySQLModel(), .t. )

   METHOD   Append()
   METHOD   Edit()

   // Events-------------------------------------------------------------------

   METHOD   clickOnHeader( oCol )
   METHOD   changeFind( oFind, oBrowse )

   METHOD   setCombo( oBrowse, oCombobox )
   METHOD   changeCombo( oBrowse, oCombobox )                   

   // Histroy------------------------------------------------------------------

   METHOD   getHistory( cHistory )
   METHOD   saveHistory( cHistory )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::keyUserMap         := "01115"

Return ( Self )

//---------------------------------------------------------------------------//

METHOD ActivateShell()

   if ::notUserAccess()
      msgStop( "Acceso no permitido." )
      Return ( Self )
   end if 

   if oWnd() != nil
      SysRefresh(); oWnd():CloseAll(); SysRefresh()
   end if

   ::buildSQLModel( __history_shell__ )

   ::buildSQLShell()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD buildSQLModel( cHistory )

   ::oModel    := TiposImpresorasModel():New()

   ::getHistory( cHistory )

   ::oModel:buildRowSetWithRecno()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD buildSQLShell()

   disableAcceso()

   ::oShell                := SQLTShell():New( 2, 10, 18, 70, "Tipos de impresoras", , oWnd(), , , .f., , , ::oModel, , , , , {}, {|| ::Edit() },, {|| ::oModel:deleteSelection() },, nil, ::nLevel, "gc_printer2_16", ( 104 + ( 0 * 256 ) + ( 63 * 65536 ) ),,, .t. )

      with object ( ::oShell:AddXCol() )
         :cHeader          := "Id"
         :cSortOrder       := "id"
         :bEditValue       := {|| ::oModel:getRowSet():fieldGet( "id" ) }
         :nWidth           := 40
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | ::clickOnHeader( oCol, ::oShell:getBrowse(), ::oShell:getCombobox() ) }
      end with

      with object ( ::oShell:AddXCol() )
         :cHeader          := "Tipo de impresora"
         :cSortOrder       := "nombre"
         :bEditValue       := {|| ::oModel:getRowSet():fieldGet( "nombre" ) }
         :nWidth           := 800
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | ::clickOnHeader( oCol, ::oShell:getBrowse(), ::oShell:getCombobox() ) }
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

   ACTIVATE WINDOW ::oShell VALID ( ::destroy( __history_shell__ ) )

   ::oShell:setComboBoxChange( {|| ::changeCombo( ::oShell:getBrowse(), ::oShell:getCombobox() ) } )

   ::setCombo( ::oShell:getBrowse(), ::oShell:getCombobox() )

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

METHOD getHistory( cHistory )

   local hFetch            := HistoricosUsuariosModel():getHistory( cHistory )

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

METHOD saveHistory( cHistory )

   HistoricosUsuariosModel():saveHistory( ::oModel:cColumnOrder, ::oModel:cOrientation, ::oModel:getKeyFieldOfRecno(), cHistory ) 

Return ( self )

//----------------------------------------------------------------------------//

METHOD clickOnHeader( oColumn, oBrowse, oCombobox )

   oBrowse:selectColumnOrder( oColumn )

   if !empty( oCombobox )
      oCombobox:set( oColumn:cHeader )
   end if 

   ::oModel:setIdForRecno( ::oModel:getKeyFieldOfRecno() )

   ::oModel:setColumnOrder( oColumn:cSortOrder )

   ::oModel:setOrientation( oColumn:cOrder )

   ::oModel:buildRowSetWithRecno()

   oBrowse:refreshCurrent()

Return ( self )

//----------------------------------------------------------------------------//

METHOD changeCombo( oBrowse, oCombobox )

   local oColumn  := oBrowse:getColumnHeader( oCombobox:VarGet() )

   if !empty( oColumn )
      ::clickOnHeader( oColumn, oBrowse )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD SetCombo( oBrowse, oCombobox )

   local oColumn 

   oColumn  := oBrowse:getColumnOrder( ::oModel:cColumnOrder )

   if !empty( oColumn )
      ::clickOnHeader( oColumn, oBrowse, oCombobox )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ActivateBrowse( oGet )

   ::buildSQLModel( __history_browse__ )

   if ::buildBrowse() .and. !empty( oGet )
      oGet:cText( ::oModel:getRowSet():fieldGet( "nombre" ) )
   end if

   ::destroy( __history_browse__ )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD buildBrowse()

   local oDlg
   local oBrowse
   local oFind
   local cFind       := space( 200 )
   local oCombobox
   local cOrder
   local aOrden      := { "Tipo" }

   DEFINE DIALOG oDlg RESOURCE "HELP_BROWSE_SQL" TITLE "Seleccionar tipo de impresora"

      REDEFINE GET   oFind ; 
         VAR         cFind ;
         ID          104 ;
         BITMAP      "FIND" ;
         OF          oDlg

      oFind:bChange       := {|| ::changeFind( oFind, oBrowse ) }

      REDEFINE COMBOBOX oCombobox ;
         VAR         cOrder ;
         ID          102 ;
         ITEMS       aOrden ;
         OF          oDlg

      oCombobox:bChange       := {|| ::changeCombo( oBrowse, oCombobox ) }

      oBrowse                 := SQLXBrowse():New( oDlg )

      oBrowse:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrowse:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrowse:lHScroll        := .f.
      oBrowse:nMarqueeStyle   := 5
      oBrowse:cName           := "Browse.TipoImpresora"

      oBrowse:setModel( ::oModel )

      with object ( oBrowse:AddCol() )
         :cHeader             := "Id"
         :cSortOrder          := "id"
         :bEditValue          := {|| ::oModel:getRowSet():fieldGet( "id" ) }
         :nWidth              := 40
         :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | ::clickOnHeader( oCol, oBrowse, oCombobox ) }
      end with

      with object ( oBrowse:AddCol() )
         :cHeader             := "Tipo de impresora"
         :cSortOrder          := "nombre"
         :bEditValue          := {|| ::oModel:getRowSet():fieldGet( "nombre" ) }
         :nWidth              := 300
         :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | ::clickOnHeader( oCol, oBrowse, oCombobox ) }
      end with

      oBrowse:bLDblClick      := {|| oDlg:end( IDOK ) }
      oBrowse:bRClicked       := {| nRow, nCol, nFlags | oBrowse:RButtonDown( nRow, nCol, nFlags ) }

      oBrowse:CreateFromResource( 105 )

      REDEFINE BUTTON ;
         ID          IDOK ;
         OF          oDlg ;
         ACTION      ( oDlg:end( IDOK ) )

      REDEFINE BUTTON ;
         ID          IDCANCEL ;
         OF          oDlg ;
         CANCEL ;
         ACTION      ( oDlg:end() )

      REDEFINE BUTTON ;
         ID          500 ;
         OF          oDlg ;
         ACTION      ( ::Append() )

      REDEFINE BUTTON ;
         ID          501 ;
         OF          oDlg ;
         ACTION      ( ::Edit() )

      oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )
      oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )

      oDlg:bStart    := {|| ::startBrowse( oFind, oCombobox, oBrowse ) }

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD startBrowse( oFind, oCombobox, oBrowse )

   local oColumn

   oCombobox:SetItems( oBrowse:getColumnHeaders() )

   oColumn     := oBrowse:getColumnOrder( ::oModel:cColumnOrder )
   if empty( oColumn )
      Return ( Self )
   end if 
   
   oCombobox:set( oColumn:cHeader )

   oBrowse:selectColumnOrder( oColumn, ::oModel:cOrientation )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD changeFind( oFind, oBrowse )

   local lFind
   local xValueToSearch

   // Estudiamos la cadena de busqueda-------------------------------------------

   xValueToSearch    := oFind:oGet:Buffer()
   xValueToSearch    := alltrim( upper( cvaltochar( xValueToSearch ) ) )
   xValueToSearch    := strtran( xValueToSearch, chr( 8 ), "" )

   // Guradamos valores iniciales-------------------------------------------------

   lFind             := ::oModel:find( xValueToSearch )

   // color para el get informar al cliente de busqueda erronea----------------

   if lFind .or. empty( xValueToSearch ) 
      oFind:SetColor( Rgb( 0, 0, 0 ), Rgb( 255, 255, 255 ) )
   else
      oFind:SetColor( Rgb( 255, 255, 255 ), Rgb( 255, 102, 102 ) )
   end if

   oBrowse:refreshCurrent()

Return ( lFind )

//--------------------------------------------------------------------------//


