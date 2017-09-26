#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Ads.ch"

//---------------------------------------------------------------------------//

CLASS SQLShellView
  
   DATA     oShell

   DATA     oController

   DATA     hTextMode                                 INIT {   __append_mode__      => "Añadiendo ",;
                                                               __edit_mode__        => "Modificando ",;
                                                               __zoom_mode__        => "Visualizando ",;
                                                               __duplicate_mode__   => "Duplicando " }

   DATA     cBrowseState

   DATA     cImageName

   METHOD   New()
   METHOD   Activate()

   METHOD   lblTitle()                                INLINE ( if( hhaskey( ::hTextMode, ::oController:getMode() ), hget( ::hTextMode, ::oController:getMode() ), "" ) )

   METHOD   AutoButtons()                             INLINE ( ::GeneralButtons(), ::EndButton() )
      METHOD   GeneralButtons()
      METHOD   insertAfterAppendButton()              VIRTUAL
      METHOD   EndButton()

   METHOD   setBrowseState( cBrowseState )            INLINE ( ::cBrowseState := cBrowseState )
   METHOD   getBrowseState()                          INLINE ( ::cBrowseState )

   METHOD   changeFind( oFind )
   METHOD   changeCombo( oCombobox )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oController           := oController

   // ::oShell                := SQLTShell():New( 2, 10, 18, 70, ::oController:cTitle, , oWnd(), , , .f., , , ::oController:oModel, , , , , {}, {|| ::oController:Edit() },, {|| ::oController:Delete() },, nil, ::oController:nLevel, ::cImageName, ( 104 + ( 0 * 256 ) + ( 63 * 65536 ) ),,, .t. )

   msgalert( ::oShell:oBrw:classname(), "TShell New" )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Activate()

   disableAcceso()

   msgalert( ::oShell:oBrw:classname(), "SQLShellView Activate" )

   msgalert( hb_valtoexp( ::oShell:classname() ), "SQLShellView Activate" )

   ::oController:generateBrowseColumns( ::oShell:getXBrowse(), ::oShell:getCombobox() )

   ::AutoButtons()

   ::oShell:setDoubleClickInData(   {|| ::oController:Edit() } )
   ::oShell:setComboBoxChange(      {|| ::changeCombo( ::oShell:getCombobox() ) } )
   ::oShell:setValid(               {|| ::oController:saveHistory( "_shell", ::oShell:getBrowse() ) } )
   ::oShell:setEnd(                 {|| ::oController:endModel() } )

   ::oShell:Activate()

   enableAcceso()

Return ( Self )

//----------------------------------------------------------------------------//

METHOD GeneralButtons()

   DEFINE BTNSHELL RESOURCE "BUS" OF ::oShell ;
      NOBORDER ;
      ACTION   ( ::oShell:SearchSetFocus() ) ;
      TOOLTIP  "(B)uscar" ;
      HOTKEY   "B"

   ::oShell:AddSeaBar()

   DEFINE BTNSHELL RESOURCE "NEW" OF ::oShell ;
      NOBORDER ;
      ACTION   ( ::oController:Append() );
      TOOLTIP  "(A)ñadir";
      BEGIN GROUP;
      HOTKEY   "A";
      LEVEL    ACC_APPD

   ::insertAfterAppendButton()

   DEFINE BTNSHELL RESOURCE "DUP" OF ::oShell ;
      NOBORDER ;
      ACTION   ( ::oController:Duplicate() );
      TOOLTIP  "(D)uplicar";
      MRU ;
      HOTKEY   "D";
      LEVEL    ACC_APPD

   DEFINE BTNSHELL RESOURCE "EDIT" OF ::oShell ;
      NOBORDER ;
      ACTION   ( ::oController:Edit() );
      TOOLTIP  "(M)odificar";
      HOTKEY   "M" ;
      LEVEL    ACC_EDIT

   DEFINE BTNSHELL RESOURCE "ZOOM" OF ::oShell ;
      NOBORDER ;
      ACTION   ( ::oController:Zoom() );
      TOOLTIP  "(Z)oom";
      MRU ;
      HOTKEY   "Z";
      LEVEL    ACC_ZOOM

   DEFINE BTNSHELL RESOURCE "DEL" OF ::oShell ;
      NOBORDER ;
      ACTION   ( ::oController:Delete() );
      TOOLTIP  "(E)liminar";
      MRU ;
      HOTKEY   "E";
      LEVEL    ACC_DELE

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD EndButton()

   DEFINE BTNSHELL RESOURCE "END" GROUP OF ::oShell ;
      NOBORDER ;
      ACTION   ( ::oShell:end() ) ;
      TOOLTIP  "(S)alir" ;
      HOTKEY   "S"

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD changeFind( oFind )

   local lFind := ::oController:findGet( oFind )

   if lFind 
      oFind:SetColor( Rgb( 0, 0, 0 ), Rgb( 255, 255, 255 ) )
   else
      oFind:SetColor( Rgb( 255, 255, 255 ), Rgb( 255, 102, 102 ) )
   end if

   ::oShell:refreshCurrent()

RETURN ( lFind )

//----------------------------------------------------------------------------//

METHOD changeCombo( oCombobox )

   local oColumn  

   if empty( oCombobox )
      RETURN ( Self )
   end if 

   oColumn           := ::oShell:getColumnByHeader( oCombobox:VarGet() )

   if !empty( oColumn )
      ::oController:clickOnHeader( oColumn, oCombobox )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

