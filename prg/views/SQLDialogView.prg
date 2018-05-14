#include "FiveWin.Ch"
#include "Factu.Ch"

//------------------------------------------------------------------------//

CLASS SQLDialogView FROM SQLBrowseableView 

   DATA oDialog
   DATA oMessage

   DATA oBitmap

   DATA oGetSearch
   DATA cGetSearch                        INIT space( 200 )

   DATA oComboBoxOrder
   DATA cComboBoxOrder

   DATA bInitActivate

   METHOD End()

   METHOD Activate( bInitActivate )
      METHOD ActivateMoved()              INLINE ( ::Activate( .f. ) )
      METHOD initActivate()               INLINE ( .t. )

   METHOD isActive()                      INLINE ( ::oDialog != nil )

   METHOD Start()

   METHOD getGetSearch()                  INLINE ( ::oGetSearch )
   METHOD getComboBoxOrder()              INLINE ( ::oComboBoxOrder )
   METHOD getWindow()                     INLINE ( ::oDialog )

   METHOD getSelectedBuffer()             INLINE ( ::hSelectedBuffer )

   METHOD Tittle()                        INLINE ( ::oController:cTitle + " de " + ;
                                                   lower( ::oController:oSenderController:cTitle ) + ": " +;
                                                   AllTrim( ::oController:oSenderController:oModel:hBuffer[ "codigo" ] ) + " - " + ;
                                                   ::oController:oSenderController:oModel:hBuffer[ "nombre" ] )

   METHOD Select()                        INLINE ( nil )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD Activate()

   DEFINE DIALOG           ::oDialog ;
      RESOURCE             "SELECTOR_DIALOG" ;
      TITLE                ::oController:getTitle()

      REDEFINE BITMAP ::oBitmap ;
         ID          900 ;
         RESOURCE    hGet( ::oController:hImage, "48" ) ;
         TRANSPARENT ;
         OF          ::oDialog

      REDEFINE SAY   ::oMessage ;
         PROMPT      ::Tittle() ;
         ID          800 ;
         FONT        getBoldFont() ;
         OF          ::oDialog

      REDEFINE GET         ::oGetSearch ;
         VAR               ::cGetSearch ; 
         ID                100 ;
         PICTURE           "@!" ;
         BITMAP            "FIND" ;
         OF                ::oDialog

      REDEFINE COMBOBOX    ::oComboBoxOrder ;
         VAR               ::cComboBoxOrder ;
         ID                110 ;
         OF                ::oDialog

      ::oComboBoxOrder:bChange      := {|| ::onChangeCombo() } 

      // Menu------------------------------------------------------------------

      ::oMenuTreeView:ActivateDialog( ::oDialog, 120 )

      // Browse-----------------------------------------------------------------

      ::getBrowseView():ActivateDialog( ::oDialog, 130 )

      ::getBrowseView():restoreStateFromModel() 

      ::getBrowseView():gotoIdFromModel()

      ::getBrowseView():setColumnOrder( ::getModel():getOrderBy(), ::getModel():getOrientation() ) 

      /*
      Botones generales-----------------------------------------------------------
      */

      REDEFINE BUTTON ;
         ID          IDOK ;
         OF          ::oDialog ;
         ACTION      ( ::oDialog:end( IDOK ) )

      REDEFINE BUTTON ;
         ID          IDCANCEL ;
         OF          ::oDialog ;
         CANCEL ;
         ACTION      ( ::oDialog:end() )

      // Eventos---------------------------------------------------------------

      ::oDialog:bStart              := {|| ::Start() }

      ::getGetSearch():bChange      := {|| ::onChangeSearch() }

   ACTIVATE DIALOG ::oDialog CENTER

   ::oBitmap:End()

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD End()

   if !empty( ::oDialog )
      ::oDialog:End()
   end if 

   ::oDialog            := nil

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD Start()

   ::oMenuTreeView:Default()

   ::oMenuTreeView:addDialogButtons()

   ::oComboBoxOrder:SetItems( ::getBrowseView():getColumnsHeaders() )

   ::oComboBoxOrder:Set( ::getBrowseView():getColumnOrderHeader() )

   ::oGetSearch:setFocus()

RETURN ( Self )

//----------------------------------------------------------------------------//