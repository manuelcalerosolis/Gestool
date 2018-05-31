#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS ClientGetSelector FROM GetSelector

   DATA oGetNif
   DATA cGetNif                     INIT ""

   DATA oGetDireccion
   DATA cGetDireccion               INIT ""

   DATA oGetCodigoPostal
   DATA cGetCodigoPostal            INIT ""

   DATA oGetPoblacion
   DATA cGetPoblacion               INIT ""

   DATA oGetProvincia
   DATA cGetProvincia               INIT ""

   DATA oGetTelefono
   DATA cGetTelefono                INIT ""

   METHOD Build( hBuilder ) 

   METHOD Activate()

   METHOD getFields()               INLINE ( ::uFields   := ::oController:oModel:getClienteDireccionPrincipal( ::getKey(), ::oGet:varGet() ) )

   METHOD cleanHelpText()    

   METHOD setHelpText( value )      

END CLASS

//---------------------------------------------------------------------------//

METHOD Build( hBuilder ) CLASS ClientGetSelector

   local idGet          := if( hhaskey( hBuilder, "idGet" ),            hBuilder[ "idGet" ],          nil )
   local idText         := if( hhaskey( hBuilder, "idText" ),           hBuilder[ "idText" ],         nil )
   local idSay          := if( hhaskey( hBuilder, "idSay" ),            hBuilder[ "idSay"],           nil )
   local idNif          := if( hhaskey( hBuilder, "idNif" ),            hBuilder[ "idNif" ],          nil )
   local idDireccion    := if( hhaskey( hBuilder, "idDireccion" ),      hBuilder[ "idDireccion" ],    nil )
   local idCodigoPostal := if( hhaskey( hBuilder, "idCodigoPostal" ),   hBuilder[ "idCodigoPostal" ], nil )
   local idPoblacion    := if( hhaskey( hBuilder, "idPoblacion" ),      hBuilder[ "idPoblacion" ],    nil )
   local idProvincia    := if( hhaskey( hBuilder, "idProvincia" ),      hBuilder[ "idProvincia" ],    nil )
   local idTelefono     := if( hhaskey( hBuilder, "idTelefono" ),       hBuilder[ "idTelefono" ],     nil )

   local oDlg           := if( hhaskey( hBuilder, "oDialog" ),          hBuilder[ "oDialog" ],        nil )

RETURN ( ::Activate( idGet, idText, idSay, idNif, idDireccion, idCodigoPostal, idPoblacion, idProvincia, idTelefono, oDlg ) )

//---------------------------------------------------------------------------//

METHOD Activate( idGet, idText, idSay, idNif, idDireccion, idCodigoPostal, idPoblacion, idProvincia, idTelefono, oDlg ) CLASS ClientGetSelector

   ::Super:Activate( idGet, idText, oDlg, idSay )

   if !empty( idNif )

      REDEFINE GET   ::oGetNif ;
         VAR         ::cGetNif ;
         ID          idNif ;
         WHEN        ( .f. ) ;
         OF          oDlg

   end if 

   if !empty( idDireccion )

      REDEFINE GET   ::oGetDireccion ;
         VAR         ::cGetDireccion ;
         ID          idDireccion ;
         WHEN        ( .f. ) ;
         OF          oDlg

   end if 

   if !empty( idCodigoPostal )

      REDEFINE GET   ::oGetCodigoPostal ;
         VAR         ::cGetCodigoPostal ;
         ID          idCodigoPostal ;
         WHEN        ( .f. ) ;
         OF          oDlg

   end if 

   if !empty( idPoblacion )

      REDEFINE GET   ::oGetPoblacion ;
         VAR         ::cGetPoblacion ;
         ID          idPoblacion ;
         WHEN        ( .f. ) ;
         OF          oDlg

   end if 

   if !empty( idProvincia )

      REDEFINE GET   ::oGetProvincia ;
         VAR         ::cGetProvincia ;
         ID          idProvincia ;
         WHEN        ( .f. ) ;
         OF          oDlg

   end if 

   if !empty( idTelefono )

      REDEFINE GET   ::oGetTelefono ;
         VAR         ::cGetTelefono ;
         ID          idTelefono ;
         WHEN        ( .f. ) ;
         OF          oDlg

   end if 

RETURN ( ::oGet )

//---------------------------------------------------------------------------//

METHOD cleanHelpText()
   
   ::Super():cleanHelpText()

   if( !empty( ::oGetNif ),            ::oGetNif:cText( "" ), ) 

   if( !empty( ::oGetDireccion ),      ::oGetDireccion:cText( "" ), )

   if( !empty( ::oGetCodigoPostal ),   ::oGetCodigoPostal:cText( "" ), )

   if( !empty( ::oGetPoblacion ),      ::oGetPoblacion:cText( "" ), )

   if( !empty( ::oGetProvincia ),      ::oGetProvincia:cText( "" ), )

   if( !empty( ::oGetTelefono ),       ::oGetTelefono:cText( "" ), )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD setHelpText( value )

   if !( hb_ishash( value ) )
      RETURN ( nil )
   end if 

   ::Super():setHelpText( value[ "nombre" ] )

   if( !empty( ::oGetNif ),            ::oGetNif:cText( value[ "dni" ] ), ) 

   if( !empty( ::oGetDireccion ),      ::oGetDireccion:cText( value[ "direccion" ] ), ) 

   if( !empty( ::oGetCodigoPostal ),   ::oGetCodigoPostal:cText( value[ "codigo_postal" ] ), ) 

   if( !empty( ::oGetPoblacion ),      ::oGetPoblacion:cText( value[ "poblacion" ] ), ) 

   if( !empty( ::oGetProvincia ),      ::oGetProvincia:cText( value[ "provincia" ] ), ) 

   if( !empty( ::oGetTelefono ),       ::oGetTelefono:cText( value[ "telefono" ] ), ) 

RETURN ( nil )

//---------------------------------------------------------------------------//


