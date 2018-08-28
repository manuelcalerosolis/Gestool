#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ArticulosPreciosView FROM SQLDialogView

   METHOD Activate()

   METHOD startActivate()

   METHOD setComboColumn( oColumn )

   METHOD getTarifaName()  

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD Activate() CLASS ArticulosPreciosView

   DEFINE DIALOG     ::oDialog ;
      RESOURCE       "ARTICULO_TARIFA_PRECIOS" ;
      TITLE          ::LblTitle() + "tarifas"

   REDEFINE BITMAP   ::oBitmap ;
      ID             900 ;
      RESOURCE       ::oController:getimage( "48" ) ;
      TRANSPARENT    ;
      OF             ::oDialog

   REDEFINE SAY      ::oMessage ;
      PROMPT         "Tarifa : " + ::getTarifaName() ;
      ID             800 ;
      FONT           getBoldFont() ;
      OF             ::oDialog

   REDEFINE GET      ::oGetSearch ;
      VAR            ::cGetSearch ; 
      ID             100 ;
      PICTURE        "@!" ;
      BITMAP         "Find" ;
      OF             ::oDialog

   ::oGetSearch:bChange          := {|| ::onChangeSearch() }

   REDEFINE COMBOBOX ::oComboBoxOrder ;
      VAR            ::cComboBoxOrder ;
      ID             110 ;
      OF             ::oDialog

   ::oComboBoxOrder:bChange      := {|| ::onChangeCombo() } 

   ::oController:Activate( 120, ::oDialog )

   // Botones Articulos -------------------------------------------------------

   REDEFINE BUTTON ;
      ID             IDOK ;
      OF             ::oDialog ;
      WHEN           ( ::oController:isNotZoomMode() ) ;
      ACTION         ( if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) )

   REDEFINE BUTTON ;
      ID             IDCANCEL ;
      OF             ::oDialog ;
      CANCEL ;
      ACTION         ( ::oDialog:end() )

   if ::oController:isNotZoomMode() 
      ::oDialog:AddFastKey( VK_F5, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) } )
   end if

   ::oDialog:bStart  := {|| ::startActivate() }

   ACTIVATE DIALOG ::oDialog CENTER

   ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD startActivate() CLASS ArticulosPreciosView

   ::oComboBoxOrder:SetItems( ::getBrowseView():getColumnsHeaders() )

   ::setComboColumn( ::getBrowseView():getFirstVisibleColumn() )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD setComboColumn( oColumn )

   ::oComboBoxOrder:Set( oColumn:cHeader )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getTarifaName()

   if empty( ::oController:oSenderController )
      RETURN ( "" )
   end if 

   if empty( ::oController:oSenderController:oModel )
      RETURN ( "" )
   end if 

RETURN ( ::oController:oSenderController:oModel:getBuffer( 'nombre' ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
