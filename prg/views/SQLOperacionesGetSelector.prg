#include "FiveWin.Ch"
#include "Factu.ch"

CLASS OperacionesGetSelector FROM GetSelector

   DATA idGet
   DATA idText
   DATA idSay
   DATA idLink
   DATA oDlg

   METHOD Build( hBuilder )

   METHOD getDialogView()                       INLINE ( ::oController:getRectificativaDialogView() )

   METHOD Activate()

   METHOD getFields()                           INLINE ( ::uFields := ::oController:getModel():getFieldWhereSerieAndNumero( ::oGet:varGet() ) )              

   METHOD assignResults( hResult )

END CLASS

//---------------------------------------------------------------------------//

METHOD Build( hBuilder ) CLASS OperacionesGetSelector

   ::idGet           := if( hhaskey( hBuilder, "idGet" ),            hBuilder[ "idGet" ],          nil )
   ::idText          := if( hhaskey( hBuilder, "idText" ),           hBuilder[ "idText" ],         nil )
   ::idSay           := if( hhaskey( hBuilder, "idSay" ),            hBuilder[ "idSay"],           nil )
   ::idLink          := if( hhaskey( hBuilder, "idLink" ),           hBuilder[ "idLink" ],         nil )
   ::oDlg            := if( hhaskey( hBuilder, "oDialog" ),          hBuilder[ "oDialog" ],        nil )

RETURN ( ::Activate() )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS OperacionesGetSelector

   ::Super:Activate( ::idGet, ::idText, ::oDlg, ::idSay, ::idLink )

RETURN ( ::oGet )

//---------------------------------------------------------------------------//

METHOD assignResults( hResult ) CLASS OperacionesGetSelector

   if hhaskey( hResult, "numero" ) .AND. hhaskey( hResult, "serie" )
      ::cText( alltrim(hGet( hResult, "serie" ) ) + "-" + alltrim(str(hGet( hResult, "numero" ) ) ) )
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
