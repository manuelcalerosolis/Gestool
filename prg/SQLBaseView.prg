#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Ads.ch"

//---------------------------------------------------------------------------//

CLASS SQLBaseView
  
   DATA     oShell

   DATA     nLevel

   DATA     idUserMap      

   DATA     oModel

   DATA     nMode                                     AS NUMERIC

   DATA     cBrowseState 

   DATA     hTextMode                                 INIT {   __append_mode__      => "Añadiendo ",;
                                                               __edit_mode__        => "Modificando ",;
                                                               __zoom_mode__        => "Visualizando ",;
                                                               __duplicate_mode__   => "Duplicando " }
 
   METHOD   New()
   
   METHOD   isUserAccess()                            INLINE ( nAnd( ::nLevel, ACC_ACCE ) == 0 )
   METHOD   notUserAccess()                           INLINE ( !::isUserAccess() )
   METHOD   isUserAppend()                            INLINE ( nAnd( ::nLevel, ACC_APPD ) != 0 )
   METHOD   notUserAppend()                           INLINE ( !::isUserAppend() )
   METHOD   isUserDuplicate()                         INLINE ( nAnd( ::nLevel, ACC_APPD ) != 0 )
   METHOD   notUserDuplicate()                        INLINE ( !::isUserDuplicate() )
   METHOD   isUserEdit()                              INLINE ( nAnd( ::nLevel, ACC_EDIT ) != 0 )
   METHOD   notUserEdit()                             INLINE ( !::isUserEdit() )
   METHOD   isUserDelete()                            INLINE ( nAnd( ::nLevel, ACC_DELE ) != 0 )
   METHOD   notUserDelete()                           INLINE ( !::isUserDelete() )
   METHOD   isUserZoom()                              INLINE ( nAnd( ::nLevel, ACC_ZOOM ) != 0 )
   METHOD   notUserZoom()                             INLINE ( !::isUserZoom() )

   METHOD   setMode( nMode )                          INLINE ( ::nMode := nMode )
   METHOD   getMode()                                 INLINE ( ::nMode )

   METHOD   destroySQLModel()                         INLINE ( if( !empty(::oModel), ::oModel:end(), ) )

   METHOD   ActivateShell()
  
   METHOD   ActivateBrowse()
      METHOD   startBrowse( oCombobox, oBrowse )

   METHOD   LblTitle()                                INLINE ( if( hhaskey( ::hTextMode, ::getMode() ), hget( ::hTextMode, ::getMode() ), "" ) )

   METHOD   AutoButtons()                             INLINE ( ::GeneralButtons(), ::EndButton() )
      METHOD   GeneralButtons()
      METHOD   insertAfterAppendButton()              VIRTUAL
      METHOD   EndButton()

   METHOD   setBrowseState( cBrowseState )            INLINE ( ::cBrowseState := cBrowseState )
   METHOD   getBrowseState()                          INLINE ( ::cBrowseState )
   METHOD   restoreBrowseState( oBrowse )
 
   METHOD   Append( oBrowse )
      METHOD setAppendMode()                          INLINE ( ::setMode( __append_mode__ ) )
      METHOD isAppendMode()                           INLINE ( ::nMode == __append_mode__ )

   METHOD Duplicate( oBrowse )
      METHOD setDuplicateMode()                       INLINE ( ::nMode := __duplicate_mode__ )
      METHOD isDuplicateMode()                        INLINE ( ::nMode == __duplicate_mode__ )

   METHOD   Edit( oBrowse )
     METHOD setEditMode()                             INLINE ( ::nMode := __edit_mode__ )
      METHOD isEditMode()                             INLINE ( ::nMode == __edit_mode__ )

   METHOD   Zoom( oBrowse )
      METHOD setZoomMode()                            INLINE ( ::nMode := __zoom_mode__ )
      METHOD isZoomMode()                             INLINE ( ::nMode == __zoom_mode__ )

   METHOD   Delete( oBrowse )       

   // Events-------------------------------------------------------------------

   METHOD   clickOnHeader( oColumn, oBrowse, oCombobox )
   METHOD   changeFind( oFind, oBrowse )

   METHOD   setCombo( oBrowse, oCombobox )
   METHOD   changeCombo( oBrowse, oCombobox )                   

   // Histroy------------------------------------------------------------------

   METHOD   getHistory( cHistory )
   METHOD   saveHistory( cHistory, oBrowse )

   METHOD   getHistoryNameShell()                     INLINE ( ::oModel:cTableName + "_shell" )
   METHOD   getHistoryNameBrowse()                    INLINE ( ::oModel:cTableName + "_browse" )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::nLevel                                           := nLevelUsr( ::idUserMap )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ActivateShell()

   if ::notUserAccess()
      msgStop( "Acceso no permitido." )
      RETURN ( Self )
   end if

   if oWnd() != nil
      SysRefresh(); oWnd():CloseAll(); SysRefresh()
   end if

   ::oModel    := ::buildSQLModel()

   ::getHistory( ::getHistoryNameShell() )

   ::oModel:buildRowSetWithRecno()

   ::buildSQLShell()

   ::startBrowse( ::oShell:getCombobox(), ::oShell:getBrowse() )



RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ActivateBrowse( aSelectedItems )

   local uReturn

   ::oModel       := ::buildSQLModel()

   ::getHistory( ::getHistoryNameBrowse() )

   ::oModel:buildRowSetWithRecno()

   if ::buildSQLBrowse( aSelectedItems )
      uReturn     := ::getFieldFromBrowse() 
   end if

   ::destroySQLModel()

RETURN ( uReturn )

//---------------------------------------------------------------------------//

METHOD GeneralButtons()

   DEFINE BTNSHELL RESOURCE "BUS" OF ::oShell ;
      NOBORDER ;
      ACTION   ( ::oShell:SearchSetFocus() ) ;
      TOOLTIP  "(B)uscar" ;
      HOTKEY   "B"

   ::oShell:AddSeaBar()

   DEFINE BTNSHELL RESOURCE "NEW" OF ::oShell ;
      NOBORDER ;
      ACTION   ( ::Append( ::oShell:getBrowse() ) );
      TOOLTIP  "(A)ñadir";
      BEGIN GROUP;
      HOTKEY   "A";
      LEVEL    ACC_APPD

   ::insertAfterAppendButton()

   DEFINE BTNSHELL RESOURCE "DUP" OF ::oShell ;
      NOBORDER ;
      ACTION   ( ::Duplicate( ::oShell:getBrowse() ) );
      TOOLTIP  "(D)uplicar";
      MRU ;
      HOTKEY   "D";
      LEVEL    ACC_APPD

   DEFINE BTNSHELL RESOURCE "EDIT" OF ::oShell ;
      NOBORDER ;
      ACTION   ( ::Edit( ::oShell:getBrowse() ) );
      TOOLTIP  "(M)odificar";
      HOTKEY   "M" ;
      LEVEL    ACC_EDIT

   DEFINE BTNSHELL RESOURCE "ZOOM" OF ::oShell ;
      NOBORDER ;
      ACTION   ( ::Zoom( ::oShell:getBrowse() ) );
      TOOLTIP  "(Z)oom";
      MRU ;
      HOTKEY   "Z";
      LEVEL    ACC_ZOOM

   DEFINE BTNSHELL RESOURCE "DEL" OF ::oShell ;
      NOBORDER ;
      ACTION   ( ::Delete( ::oShell:getBrowse() ) );
      TOOLTIP  "(E)liminar";
      MRU ;
      HOTKEY   "E";
      LEVEL    ACC_DELE

rETURN ( Self )

//---------------------------------------------------------------------------//

METHOD EndButton()

   DEFINE BTNSHELL RESOURCE "END" GROUP OF ::oShell ;
      NOBORDER ;
      ACTION   ( ::oShell:end() ) ;
      TOOLTIP  "(S)alir" ;
      HOTKEY   "S"

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD startBrowse( oCombobox, oBrowse )

   local oColumn

   if empty( oBrowse )
      RETURN ( Self )
   end if 

   oCombobox:SetItems( oBrowse:getColumnHeaders() )

   ::restoreBrowseState( oBrowse )

   oColumn     := oBrowse:getColumnOrder( ::oModel:cColumnOrder )
   if empty( oColumn )
      RETURN ( Self )
   end if 
   
   oCombobox:set( oColumn:cHeader )

   oBrowse:selectColumnOrder( oColumn, ::oModel:cOrientation )

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD restoreBrowseState( oBrowse )

   if empty(oBrowse)
      RETURN ( Self )
   end if 

   if empty( ::getBrowseState() )
      RETURN ( Self )
   end if 

   oBrowse:restoreState( ::getBrowseState() )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Append( oBrowse )

   local nRecno   

   if ::notUserAppend()
      msgStop( "Acceso no permitido." )
      RETURN ( Self )
   end if 

   ::setAppendMode()

   nRecno         := ::oModel:getRowSetRecno()

   ::oModel:loadBlankBuffer()

   if ::Dialog()
      ::oModel:insertBuffer()
   else 
      ::oModel:setRowSetRecno( nRecno ) 
   end if

   if !empty( oBrowse )
      oBrowse:refreshCurrent()
      oBrowse:setFocus()
   end if 

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Duplicate( oBrowse )

   local nRecno   

   if ::notUserDuplicate()
      msgStop( "Acceso no permitido." )
      RETURN ( Self )
   end if 

   ::setDuplicateMode()

   nRecno         := ::oModel:getRowSetRecno()

   ::oModel:loadCurrentBuffer()

   if ::Dialog()
      ::oModel:insertBuffer()
   else 
      ::oModel:setRowSetRecno( nRecno ) 
   end if

   if !empty( oBrowse )
      oBrowse:refreshCurrent()
      oBrowse:setFocus()
   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Edit( oBrowse )  

   if ::notUserEdit()
      msgStop( "Acceso no permitido." )
      RETURN ( Self )
   end if 

   ::setEditMode()

   ::oModel:setIdForRecno( ::oModel:getKeyFieldOfRecno() )

   ::oModel:loadCurrentBuffer()

   if ::Dialog()
      
      ::oModel:updateCurrentBuffer()

   end if 

   if !empty( oBrowse )
      oBrowse:refreshCurrent()
      oBrowse:setFocus()
   end if 

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Zoom( oBrowse )

   if ::notUserZoom()
      msgStop( "Acceso no permitido." )
      RETURN ( Self )
   end if 

   ::setZoomMode()

   ::oModel:loadCurrentBuffer()

   ::Dialog()

   if !empty( oBrowse )
      oBrowse:setFocus()
   end if 

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Delete( oBrowse )

   local nSelected
   local cNumbersOfDeletes

   if ::notUserDelete()
      msgStop( "Acceso no permitido." )
      RETURN ( Self )
   end if 

   nSelected            := len( oBrowse:aSelected )

   if nSelected > 1
      cNumbersOfDeletes := alltrim( str( nSelected, 3 ) ) + " registros?"
   else
      cNumbersOfDeletes := "el registro en curso?"
   end if

      if oUser():lNotConfirmDelete() .or. msgNoYes( "¿Desea eliminar " + cNumbersOfDeletes, "Confirme eliminación" )
         ::oModel:deleteSelection( oBrowse:aSelected )
      end if 

   if !empty( oBrowse )
      oBrowse:refreshCurrent()
      oBrowse:setFocus()
   end if 

RETURN ( Self )

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

RETURN ( self )

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

//---------------------------------------------------------------------------//

METHOD SetCombo( oBrowse, oCombobox )

   local oColumn

   oColumn  := oBrowse:getColumnOrder( ::oModel:cColumnOrder )

   if !empty( oColumn )
      ::clickOnHeader( oColumn, oBrowse, oCombobox )
   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD changeCombo( oBrowse, oCombobox )

   local oColumn  

   if empty( oBrowse )
      RETURN ( Self )
   end if 

   if empty( oCombobox )
      RETURN ( Self )
   end if 

   oColumn           := oBrowse:getColumnHeader( oCombobox:VarGet() )

   if !empty( oColumn )
      ::clickOnHeader( oColumn, oBrowse )
   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD getHistory( cHistory )

   local hFetch            := HistoricosUsuariosModel():New():getHistory( cHistory )

   if empty( hFetch )
      RETURN ( Self )
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

   if hhaskey( hFetch, "cBrowseState" )
      ::setBrowseState( hFetch[ "cBrowseState" ] )
   endif
   
RETURN ( self )

//----------------------------------------------------------------------------//

METHOD saveHistory( cHistory, oBrowse )

   local cBrowseState   := "null"

   if !empty( oBrowse ) 
      cBrowseState      := quoted( oBrowse:saveState() )
   end if

   HistoricosUsuariosModel():New():saveHistory( cHistory, cBrowseState, ::oModel:cColumnOrder, ::oModel:cOrientation, ::oModel:getKeyFieldOfRecno() ) 

Return ( .t. )

//----------------------------------------------------------------------------//

