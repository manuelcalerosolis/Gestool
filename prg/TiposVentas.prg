#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TiposVentas FROM SQLBaseView

   DATA     oEditControl

   DATA     cEditControl 

   METHOD   New()
 
   METHOD   Dialog()
   
   METHOD   createEditControl( hControl )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oController           := oController

   ::cImageName            := "gc_wallet_16"

Return ( Self )

//---------------------------------------------------------------------------//

METHOD Dialog()

   local oDlg
   local oBtnOk
   local oGetCodigo
   local oGetNombre

   DEFINE DIALOG oDlg RESOURCE "TIPO_VENTA" TITLE ::lblTitle() + "tipo de venta"

   REDEFINE GET   oGetCodigo ;
      VAR         ::getModel():hBuffer[ "codigo" ] ;
      ID          100 ;
      WHEN        ( !::oController:isZoomMode() ) ;
      VALID       ( ::oController:validCodigo( oGetCodigo ) ) ;
      OF          oDlg

   REDEFINE GET   oGetNombre ;
      VAR         ::getModel():hBuffer[ "nombre" ] ;
      ID          110 ;
      WHEN        ( !::oController:isZoomMode() ) ;
      VALID       ( ::oController:validNombre( oGetNombre ) ) ;
      OF          oDlg

   REDEFINE BUTTON oBtnOk ;
      ID          IDOK ;
      OF          oDlg ;
      WHEN        ( !::oController:isZoomMode() ) ;   
      ACTION      ( if( validateDialog( oDlg ), oDlg:end( IDOK ), ) )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          oDlg ;
      CANCEL ;
      ACTION      ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| oBtnOk:Click() } )

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD createEditControl( hControl )

   if !hhaskey( hControl, "idGet" )
      RETURN ( Self )
   end if 

   if !hhaskey( hControl, "idSay" )
      RETURN ( Self )
   end if 

   if !hhaskey( hControl, "idText" )
      RETURN ( Self )
   end if 

   if !hhaskey( hControl, "dialog" )
      RETURN ( Self )
   end if 

   if !hhaskey( hControl, "value" )
      RETURN ( Self )
   end if 

   if !hhaskey( hControl, "when" )
      RETURN ( Self )
   end if 

   msgalert( hb_valtoexp( hControl ) )

   ::cEditControl := ::getModel():getCodigoFromId( hGet( hControl, "value" ) ) 

   ? ::cEditControl

   REDEFINE GET   ::oEditControl ;
      VAR         ::cEditControl ;
      BITMAP      "Lupa" ;
      ID          ( hGet( hControl, "idGet" ) ) ;
      IDSAY       ( hGet( hControl, "idSay" ) ) ;
      IDTEXT      ( hGet( hControl, "idText" ) ) ;
      OF          ( hGet( hControl, "dialog" ) )

   ? "objeto creado"

   ::oEditControl:bWhen    := hGet( hControl, "when" ) 
   ::oEditControl:bHelp    := {|| ::oController:assignBrowse( ::oEditControl ) }
   ::oEditControl:bValid   := {|| ::oController:isValidCodigo( ::oEditControl ) }

   ? "valores"

RETURN ( Self )

//---------------------------------------------------------------------------//

