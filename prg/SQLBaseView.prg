#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Ads.ch"

//---------------------------------------------------------------------------//

CLASS SQLBaseView
  
   DATA     oShell

   DATA     oController

   DATA     oBrowse

   DATA     hTextMode                                 INIT {   __append_mode__      => "Añadiendo ",;
                                                               __edit_mode__        => "Modificando ",;
                                                               __zoom_mode__        => "Visualizando ",;
                                                               __duplicate_mode__   => "Duplicando " }

   DATA     cBrowseState

   DATA     cImageName

   METHOD   New()

   METHOD   buildSQLShell()

   METHOD   buildSQLBrowse()

   METHOD   setoBrowse( oBrowse )                     INLINE   ( ::oBrowse := oBrowse )
   METHOD   getoBrowse()                              INLINE   ( ::oBrowse )

   METHOD   buildSQLNuclearBrowse()
   
   METHOD   lblTitle()                                INLINE ( if( hhaskey( ::hTextMode, ::oController:getMode() ), hget( ::hTextMode, ::oController:getMode() ), "" ) )

   METHOD   AutoButtons()                             INLINE ( ::GeneralButtons(), ::EndButton() )
      METHOD   GeneralButtons()
      METHOD   insertAfterAppendButton()              VIRTUAL
      METHOD   EndButton()

   METHOD   setBrowseState( cBrowseState )            INLINE ( ::cBrowseState := cBrowseState )
   METHOD   getBrowseState()                          INLINE ( ::cBrowseState )

   METHOD   changeFind( oFind )
   METHOD   changeCombo( oCombobox )

   METHOD   saveHistoryOfShell()                      INLINE ( ::oController:saveHistory( "_shell", ::oBrowse ) )

   METHOD   saveHistoryOfBrowse()                     INLINE ( ::oController:saveHistory( "_browse", ::oBrowse ) )   

   METHOD   getModel()                                INLINE ( ::oController:oModel )              

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

   ::oBrowse:refreshCurrent()

RETURN ( lFind )

//----------------------------------------------------------------------------//

METHOD changeCombo( oCombobox )

   local oColumn  

   if empty( ::oBrowse )
      RETURN ( Self )
   end if 

   if empty( oCombobox )
      RETURN ( Self )
   end if 

   oColumn           := ::oBrowse:getColumnHeader( oCombobox:VarGet() )

   if !empty( oColumn )
      ::oController:clickOnHeader( oColumn, oCombobox )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD buildSQLShell()

   disableAcceso()

   ::oShell                := SQLTShell():New( 2, 10, 18, 70, ::oController:cTitle, , oWnd(), , , .f., , , ::getModel(), , , , , {}, {|| ::oController:Edit() },, {|| ::oController:Delete() },, nil, ::oController:nLevel, ::cImageName, ( 104 + ( 0 * 256 ) + ( 63 * 65536 ) ),,, .t. )

   ::setoBrowse( ::oShell:getBrowse() )

      ::oController:generateColumnsForBrowse( ::oShell:getCombobox() )

      ::oShell:createXFromCode()

      ::oShell:setDClickData( {|| ::oController:Edit() } )

      ::AutoButtons()

   ACTIVATE WINDOW ::oShell

   ::oShell:bValid         := {|| ::saveHistoryOfShell(), .t. }
   ::oShell:bEnd           := {|| ::oController:destroySQLModel() }

   ::oShell:setComboBoxChange( {|| ::changeCombo( ::oShell:getCombobox() ) } )

   enableAcceso()

Return ( Self )

//----------------------------------------------------------------------------//

METHOD buildSQLBrowse( title )

   local oDlg
   local oFind
   local cFind       := space( 200 )
   local oCombobox
   local cOrder
   local aOrden      := { title }
 
   DEFINE DIALOG oDlg RESOURCE "HELP_BROWSE_SQL" TITLE "Seleccionar " + lower( title )

      REDEFINE GET   oFind ; 
         VAR         cFind ;
         ID          104 ;
         BITMAP      "FIND" ;
         OF          oDlg

      oFind:bChange       := {|| ::changeFind( oFind ) }

      REDEFINE COMBOBOX oCombobox ;
         VAR         cOrder ;
         ID          102 ;
         ITEMS       aOrden ;
         OF          oDlg

      oCombobox:bChange       := {|| ::changeCombo( oCombobox ) }

      ::buildSQLNuclearBrowse( 105 , oDlg, oCombobox )

      ::oBrowse:bLDblClick      := {|| oDlg:end( IDOK ) }

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
         ACTION      ( ::oController:Append() )

      REDEFINE BUTTON ;
         ID          501 ;
         OF          oDlg ;
         ACTION      ( ::oController:Edit() )

      oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )
      oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )
      oDlg:AddFastKey( VK_F2,       {|| ::oController:Append() } )
      oDlg:AddFastKey( VK_F3,       {|| ::oController:Edit() } )

   oDlg:Activate( , , , .t., {|| ::saveHistoryOfBrowse() } )

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD buildSQLNuclearBrowse( idResource, oDlg, oCombobox )

   ::setoBrowse( SQLXBrowse():New( oDlg ) )

   ::oBrowse:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrowse:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   ::oBrowse:lHScroll         := .f.
   ::oBrowse:nMarqueeStyle    := 6

   ::oBrowse:setModel( ::getModel() )

   ::oController:generateColumnsForBrowse( oCombobox )

   ::oBrowse:bLDblClick       := {|| ::oController:Edit() }
   ::oBrowse:bRClicked        := {| nRow, nCol, nFlags | ::oBrowse:RButtonDown( nRow, nCol, nFlags ) }

   ::oBrowse:createFromResource( idResource )

   ::oController:startBrowse( oCombobox )

RETURN ( self )

   //---------------------------------------------------------------------------//