#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Ads.ch"

//---------------------------------------------------------------------------//

CLASS SQLBaseView
  
   DATA     oShell

   DATA     oController

   DATA     hTextMode                                 INIT {   __append_mode__      => "Añadiendo ",;
                                                               __edit_mode__        => "Modificando ",;
                                                               __zoom_mode__        => "Visualizando ",;
                                                               __duplicate_mode__   => "Duplicando " }

   DATA     cBrowseState


   METHOD   New()
   
   METHOD   lblTitle()                                INLINE ( if( hhaskey( ::hTextMode, ::oController:getMode() ), hget( ::hTextMode, ::oController:getMode() ), "" ) )

   METHOD   AutoButtons()                             INLINE ( ::GeneralButtons(), ::EndButton() )
      METHOD   GeneralButtons()
      METHOD   insertAfterAppendButton()              VIRTUAL
      METHOD   EndButton()

   METHOD   setBrowseState( cBrowseState )            INLINE ( ::cBrowseState := cBrowseState )
   METHOD   getBrowseState()                          INLINE ( ::cBrowseState )

   METHOD   changeFind( oFind, oBrowse )
   METHOD   changeCombo( oBrowse, oCombobox )

   METHOD   saveHistoryOfShell( oBrowse )             INLINE ( ::oController:saveHistory( "_shell", oBrowse ) )

   METHOD   saveHistoryOfBrowse( oBrowse )            INLINE ( ::oController:saveHistory( "_browse", oBrowse ) )                 

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

RETURN ( Self )

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
      ACTION   ( ::oController:Append( ::oShell:getBrowse() ) );
      TOOLTIP  "(A)ñadir";
      BEGIN GROUP;
      HOTKEY   "A";
      LEVEL    ACC_APPD

   ::insertAfterAppendButton()

   DEFINE BTNSHELL RESOURCE "DUP" OF ::oShell ;
      NOBORDER ;
      ACTION   ( ::oController:Duplicate( ::oShell:getBrowse() ) );
      TOOLTIP  "(D)uplicar";
      MRU ;
      HOTKEY   "D";
      LEVEL    ACC_APPD

   DEFINE BTNSHELL RESOURCE "EDIT" OF ::oShell ;
      NOBORDER ;
      ACTION   ( ::oController:Edit( ::oShell:getBrowse() ) );
      TOOLTIP  "(M)odificar";
      HOTKEY   "M" ;
      LEVEL    ACC_EDIT

   DEFINE BTNSHELL RESOURCE "ZOOM" OF ::oShell ;
      NOBORDER ;
      ACTION   ( ::oController:Zoom( ::oShell:getBrowse() ) );
      TOOLTIP  "(Z)oom";
      MRU ;
      HOTKEY   "Z";
      LEVEL    ACC_ZOOM

   DEFINE BTNSHELL RESOURCE "DEL" OF ::oShell ;
      NOBORDER ;
      ACTION   ( ::oController:Delete( ::oShell:getBrowse() ) );
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

METHOD changeFind( oFind, oBrowse )

   local lFind := ::oController:find( oFind )

   if lFind 
      oFind:SetColor( Rgb( 0, 0, 0 ), Rgb( 255, 255, 255 ) )
   else
      oFind:SetColor( Rgb( 255, 255, 255 ), Rgb( 255, 102, 102 ) )
   end if

   oBrowse:refreshCurrent()

Return ( lFind )

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
      ::oController:clickOnHeader( oColumn, oBrowse )
   end if

RETURN ( Self )


