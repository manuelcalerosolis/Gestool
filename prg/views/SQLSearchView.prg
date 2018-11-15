#include "FiveWin.Ch"
#include "Factu.Ch"

//------------------------------------------------------------------------//

CLASS SQLSearchView FROM SQLBaseView 

   DATA oDialog

   DATA oGetSearch
   DATA cGetSearch                        INIT space( 200 )

   DATA oComboBoxOrder
   DATA cComboBoxOrder

   METHOD New( oController )

   METHOD Activate()

   METHOD Start()

   METHOD onChangeCombo() 
   METHOD onChangeSearch() 

   METHOD getBrowse()                     INLINE ( ::oController:oBrowseView )
   METHOD getGetSearch()                  INLINE ( ::oGetSearch )
   METHOD getComboBoxOrder()              INLINE ( ::oComboBoxOrder )
   METHOD getWindow()                     INLINE ( ::oDialog )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oController )

   ::oController           := oController

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Activate()

   DEFINE DIALOG ::oDialog RESOURCE "sSearch"

      REDEFINE GET         ::oGetSearch;
         VAR               ::cGetSearch;
         ID                100 ;
         PICTURE           "@!" ;
         BITMAP            "FIND" ;
         OF                ::oDialog

      REDEFINE COMBOBOX    ::oComboBoxOrder ;
         VAR               ::cComboBoxOrder ;
         ID                101 ;
         ITEMS             ::getModel():getHeadersForBrowse() ;
         OF                ::oDialog

      REDEFINE BUTTON ;
         ID                510 ;
         OF                ::oDialog ;
         ACTION            ( ::oDialog:end() )

      // Eventos---------------------------------------------------------------

      ::oDialog:bStart           := {|| ::Start() }

      ::oComboBoxOrder:bChange   := {|| ::onChangeCombo() } 

      ::oGetSearch:bChange       := {|| ::onChangeSearch() } 

   ACTIVATE DIALOG ::oDialog CENTER

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD Start()

   local oColumn  

   ::oComboBoxOrder:setItems( ::getBrowse():getVisibleColumnsHeaders() )

   oColumn        := ::getBrowse():getColumnOrder()

   if !empty( oColumn )
      ::oComboBoxOrder:set( oColumn:cHeader ) 
   end if 

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD onChangeCombo( oColumn )

   if empty( oColumn )
      oColumn        := ::getBrowse():getColumnByHeader( ::oComboBoxOrder:VarGet() )
   end if 

   if empty( oColumn )
      RETURN ( nil )
   end if 

   ::oController:changeModelOrderAndOrientation( oColumn:cSortOrder, oColumn:cOrder )

   ::getBrowse():selectColumnOrder( oColumn )

   ::getBrowse():refreshCurrent()

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD onChangeSearch( oColumn ) 

   if empty( oColumn )
      oColumn        := ::getBrowse():getColumnByHeader( ::oComboBoxOrder:VarGet() )
   end if 

   if empty( oColumn )
      RETURN ( nil )
   end if 

   ::oController:findInRowSet( alltrim( ::cGetSearch ), oColumn:cSortOrder )                  

   ::getBrowse():refreshCurrent()

RETURN ( nil )

//----------------------------------------------------------------------------//
