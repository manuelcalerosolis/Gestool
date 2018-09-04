#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS ClientGetSelector FROM GetSelector

   DATA idGet          
   DATA idText         
   DATA idSay          
   DATA idNif          
   DATA idDireccion    
   DATA idCodigoPostal 
   DATA idPoblacion    
   DATA idProvincia    
   DATA idPais    
   DATA idTelefono     
   DATA idTarifa       
   DATA idLink         

   DATA oDlg

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

   DATA oGetPais
   DATA cGetPais                    INIT ""


   DATA oGetTelefono
   DATA cGetTelefono                INIT ""

   DATA oGetTarifa
   DATA cGetTarifa                  INIT ""

   METHOD Build( hBuilder ) 

   METHOD Activate()

   METHOD getFields()               INLINE ( ::uFields   := ::oController:oModel:getClienteDireccionPrincipal( ::getKey(), ::oGet:varGet() ) )

   METHOD cleanHelpText()    

   METHOD setHelpText( value )      

END CLASS

//---------------------------------------------------------------------------//

METHOD Build( hBuilder ) CLASS ClientGetSelector

   ::idGet           := if( hhaskey( hBuilder, "idGet" ),            hBuilder[ "idGet" ],          nil )
   ::idText          := if( hhaskey( hBuilder, "idText" ),           hBuilder[ "idText" ],         nil )
   ::idSay           := if( hhaskey( hBuilder, "idSay" ),            hBuilder[ "idSay"],           nil )
   ::idNif           := if( hhaskey( hBuilder, "idNif" ),            hBuilder[ "idNif" ],          nil )
   ::idDireccion     := if( hhaskey( hBuilder, "idDireccion" ),      hBuilder[ "idDireccion" ],    nil )
   ::idCodigoPostal  := if( hhaskey( hBuilder, "idCodigoPostal" ),   hBuilder[ "idCodigoPostal" ], nil )
   ::idPoblacion     := if( hhaskey( hBuilder, "idPoblacion" ),      hBuilder[ "idPoblacion" ],    nil )
   ::idProvincia     := if( hhaskey( hBuilder, "idProvincia" ),      hBuilder[ "idProvincia" ],    nil )
   ::idPais          := if( hhaskey( hBuilder, "idPais" ),           hBuilder[ "idPais" ],         nil )
   ::idTelefono      := if( hhaskey( hBuilder, "idTelefono" ),       hBuilder[ "idTelefono" ],     nil )
   ::idTarifa        := if( hhaskey( hBuilder, "idTarifa" ),         hBuilder[ "idTarifa" ],       nil )
   ::idLink          := if( hhaskey( hBuilder, "idLink" ),           hBuilder[ "idLink" ],         nil )

   ::oDlg            := if( hhaskey( hBuilder, "oDialog" ),          hBuilder[ "oDialog" ],        nil )

RETURN ( ::Activate() )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS ClientGetSelector

   ::Super:Activate( ::idGet, ::idText, ::oDlg, ::idSay, ::idLink )

   if !empty( ::idNif )

      REDEFINE GET   ::oGetNif ;
         VAR         ::cGetNif ;
         ID          ::idNif ;
         WHEN        ( .f. ) ;
         OF          ::oDlg

   end if 

   if !empty( ::idDireccion )

      REDEFINE GET   ::oGetDireccion ;
         VAR         ::cGetDireccion ;
         ID          ::idDireccion ;
         WHEN        ( .f. ) ;
         OF          ::oDlg

   end if 

   if !empty( ::idCodigoPostal )

      REDEFINE GET   ::oGetCodigoPostal ;
         VAR         ::cGetCodigoPostal ;
         ID          ::idCodigoPostal ;
         WHEN        ( .f. ) ;
         OF          ::oDlg

   end if 

   if !empty( ::idPoblacion )

      REDEFINE GET   ::oGetPoblacion ;
         VAR         ::cGetPoblacion ;
         ID          ::idPoblacion ;
         WHEN        ( .f. ) ;
         OF          ::oDlg

   end if 

   if !empty( ::idProvincia )

      REDEFINE GET   ::oGetProvincia ;
         VAR         ::cGetProvincia ;
         ID          ::idProvincia ;
         WHEN        ( .f. ) ;
         OF          ::oDlg

   end if 

   if !empty( ::idPais )

      REDEFINE GET   ::oGetPais ;
         VAR         ::cGetPais ;
         ID          ::idPais ;
         WHEN        ( .f. ) ;
         OF          ::oDlg

   end if 

   if !empty( ::idTelefono )

      REDEFINE GET   ::oGetTelefono ;
         VAR         ::cGetTelefono ;
         ID          ::idTelefono ;
         WHEN        ( .f. ) ;
         OF          ::oDlg

   end if 

   if !empty( ::idTarifa )

      REDEFINE GET   ::oGetTarifa ;
         VAR         ::cGetTarifa ;
         ID          ::idTarifa ;
         WHEN        ( .f. ) ;
         OF          ::oDlg

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

   if( !empty( ::oGetPais ),           ::oGetPais:cText( "" ), )

   if( !empty( ::oGetTelefono ),       ::oGetTelefono:cText( "" ), )

   if( !empty( ::oGetTarifa ),         ::oGetTarifa:cText( "" ), )

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

   if( !empty( ::oGetPais ),           ::oGetPais:cText( value[ "nombre_pais" ] ), ) 

   if( !empty( ::oGetTelefono ),       ::oGetTelefono:cText( value[ "telefono" ] ), ) 

   if( !empty( ::oGetTarifa ),         ::oGetTarifa:cText( value[ "tarifa_codigo" ] ), ) 

RETURN ( nil )

//---------------------------------------------------------------------------//


