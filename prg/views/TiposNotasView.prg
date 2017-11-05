#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TiposNotasView FROM SQLBaseView

   DATA oEditControl

   DATA cEditControl 

   METHOD Activate()
   
   METHOD createEditControl( hControl )
      METHOD selectorEditControl()
      METHOD assertEditControl()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate()

   local oDlg
   local oBtnOk
   local oGetCodigo
   local oGetNombre

   DEFINE DIALOG oDlg RESOURCE "TIPO_GENERAL" TITLE ::lblTitle() + "tipo de nota"

   REDEFINE GET   oGetNombre ;
      VAR         ::getModel():hBuffer[ "nombre" ] ;
      ID          100 ;
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

METHOD createEditControl( hControl, uValue )

   local oError

   if !hhaskey( hControl, "idGet" )    .or.  ;
      !hhaskey( hControl, "idSay" )    .or.  ;
      !hhaskey( hControl, "idText" )   .or.  ;
      !hhaskey( hControl, "dialog" )   .or.  ;
      !hhaskey( hControl, "when" )
      RETURN ( Self )
   end if 

   if hb_isnil( uValue )
      RETURN ( Self )
   end if 

   try 

      REDEFINE GET   ::oEditControl ;
         VAR         uValue ;
         BITMAP      "Lupa" ;
         ID          ( hGet( hControl, "idGet" ) ) ;
         IDSAY       ( hGet( hControl, "idSay" ) ) ;
         IDTEXT      ( hGet( hControl, "idText" ) ) ;
         OF          ( hGet( hControl, "dialog" ) )

      ::oEditControl:bWhen    := hGet( hControl, "when" ) 
      ::oEditControl:bHelp    := {|| ::selectorEditControl() }
      ::oEditControl:bValid   := {|| ::assertEditControl() }

      ::oEditControl:oHelpText:cText( ::getController():getRepository():getColumnWhereId( uValue ) )


   catch oError

      msgStop( "Imposible crear el control de tipos de ventas." + CRLF + ErrorMessage( oError ) )

   end

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD selectorEditControl()

   local hBuffer     := ::oController:activateSelectorView()

   if !empty( hBuffer )
      ::oEditControl:cText( hget( hBuffer, "id" ) )
      ::oEditControl:oHelpText:cText( hget( hBuffer, "nombre" ) )
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD assertEditControl()

   local uValue      := ::oEditControl:VarGet()
   local lAssert     := ::oController:assert( "id", uValue )

   if lAssert 
      ::oEditControl:oHelpText:cText( ::getController():getRepository():getColumnWhereId( uValue ) )
   end if 

RETURN ( lAssert )

//---------------------------------------------------------------------------//


