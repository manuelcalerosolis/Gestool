#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TiposVentasView FROM SQLBaseView

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

   DEFINE DIALOG oDlg RESOURCE "TIPO_GENERAL" TITLE ::lblTitle() + "tipo de venta"

   REDEFINE GET   oGetNombre ;
      VAR         ::getModel():hBuffer[ "nombre" ] ;
      ID          100 ;
      MEMO ;
      WHEN        ( !::oController:isZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          oDlg

   ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   if ::oController:isNotZoomMode() 
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5 .and. validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }
   end if

   /*oDlg:AddFastKey( VK_F5, {|| oBtnOk:Click() } )*/

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


