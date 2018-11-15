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
      FONT           oFontBold() ;
      OF             ::oDialog

   REDEFINE GET      ::oGetSearch ;
      VAR            ::cGetSearch ; 
      ID             100 ;
      PICTURE        "@!" ;
      BITMAP         "Find" ;
      OF             ::oDialog

   ::oGetSearch:bChange          := {|| ::onChangeSearch() }

   ::oController:Activate( 120, ::oDialog )

   // Botones Articulos -------------------------------------------------------

   ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   if ::oController:isNotZoomMode() 
      ::oDialog:bKeyDown         := {| nKey | if( nKey == VK_F5 .and. validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }
   end if

   ::oDialog:bStart              := {|| ::startActivate() }

   ACTIVATE DIALOG ::oDialog CENTER

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD startActivate() CLASS ArticulosPreciosView

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD setComboColumn( oColumn )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getTarifaName()

   if empty( ::oController:oController )
      RETURN ( "" )
   end if 

   if empty( ::oController:oController:oModel )
      RETURN ( "" )
   end if 

RETURN ( ::oController:oController:oModel:getBuffer( 'nombre' ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
