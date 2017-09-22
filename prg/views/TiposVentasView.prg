#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TiposVentasView FROM SQLBaseView

   DATA oEditControl

   DATA cEditControl 

   METHOD New()
 
   METHOD Dialog()
   
   METHOD createEditControl( hControl )
      METHOD selectorEditControl()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oController           := oController

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
      VALID       ( ::oController:validate( "codigo" ) ) ;
      OF          oDlg

   REDEFINE GET   oGetNombre ;
      VAR         ::getModel():hBuffer[ "nombre" ] ;
      ID          110 ;
      WHEN        ( !::oController:isZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
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

   local oError

   if !hhaskey( hControl, "idGet" )    .or.  ;
      !hhaskey( hControl, "idSay" )    .or.  ;
      !hhaskey( hControl, "idText" )   .or.  ;
      !hhaskey( hControl, "dialog" )   .or.  ;
      !hhaskey( hControl, "value" )    .or.  ; 
      !hhaskey( hControl, "when" )
      RETURN ( Self )
   end if 

   try 

      ::cEditControl := ::getModel():getCodigoFromId( hGet( hControl, "value" ) ) 

      REDEFINE GET   ::oEditControl ;
         VAR         ::cEditControl ;
         BITMAP      "Lupa" ;
         ID          ( hGet( hControl, "idGet" ) ) ;
         IDSAY       ( hGet( hControl, "idSay" ) ) ;
         IDTEXT      ( hGet( hControl, "idText" ) ) ;
         OF          ( hGet( hControl, "dialog" ) )

      ::oEditControl:bWhen    := hGet( hControl, "when" ) 
      ::oEditControl:bHelp    := {|| ::selectorEditControl() }
      ::oEditControl:bValid   := {|| ::oController:assert( "codigo", ::cEditControl ) }

   catch oError

      msgStop( "Imposible crear el control de tipos de ventas." + CRLF + ErrorMessage( oError ) )

   end

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD selectorEditControl()

   local hBuffer  := ::oController:activateSelectorView()

   if !empty( hBuffer )
      ::oEditControl:cText( hget( hBuffer, "codigo" ) )
      ::oEditControl:oHelpText:cText( hget( hBuffer, "nombre" ) )
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//


