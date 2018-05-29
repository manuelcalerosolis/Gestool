#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS ClientGetSelector FROM GetSelector

   DATA oGetNif

   DATA cGetNif                     INIT ""

   METHOD Build( hBuilder ) 

   METHOD Activate( idGet, idText, idNif, oDlg, idSay )

   METHOD getFields()               INLINE ( ::uFields   := ::oController:oModel:getHash( ::getKey(), ::oGet:varGet() ) )

   METHOD cleanHelpText()           
   METHOD setHelpText( value )      

END CLASS

//---------------------------------------------------------------------------//

METHOD Build( hBuilder ) CLASS ClientGetSelector

   local idGet    := if( hhaskey( hBuilder, "idGet" ),   hBuilder[ "idGet" ],    nil )
   local idText   := if( hhaskey( hBuilder, "idText" ),  hBuilder[ "idText" ],   nil )
   local idNif    := if( hhaskey( hBuilder, "idNif" ),   hBuilder[ "idNif" ],    nil )
   local idSay    := if( hhaskey( hBuilder, "idSay" ),   hBuilder[ "idSay"],     nil )
   local oDlg     := if( hhaskey( hBuilder, "oDialog" ), hBuilder[ "oDialog" ],  nil )

RETURN ( ::Activate( idGet, idText, idNif, oDlg, idSay ) )

//---------------------------------------------------------------------------//

METHOD Activate( idGet, idText, idNif, oDlg, idSay ) CLASS ClientGetSelector

   ::Super:Activate( idGet, idText, oDlg, idSay )

   if !empty( idNif )

      REDEFINE GET   ::oGetNif ;
         VAR         ::cGetNif ;
         ID          idNif ;
         WHEN        ( .f. ) ;
         OF          oDlg

   end if 

RETURN ( ::oGet )

//---------------------------------------------------------------------------//

METHOD cleanHelpText()
   
   ::Super():cleanHelpText()

   if !empty( ::oGetNif )
      ::oGetNif:cText( "" ) 
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD setHelpText( value )

   msgalert( valtype( value ) )

   if empty( value )
      RETURN ( nil )
   end if 

   ::Super():setHelpText( value[ "nombre" ] )

   ::oGetNif:cText( value[ "dni" ] ) 

RETURN ( nil )

//---------------------------------------------------------------------------//


