#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS PropertyControlView FROM SQLBaseView

   DATA oPage
   
   DATA oGetValorPropiedad

   METHOD createControl( nId, oDialog, cFieldCodigo, cFieldValor )

   METHOD getPage()              INLINE ( ::oPage )

   METHOD setSayText( cText )    INLINE ( ::oGetValorPropiedad:oSay:setText( cText ) )

   METHOD setHelpText( cText )   INLINE ( ::oGetValorPropiedad:oHelpText:cText( cText ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD createControl( nId, oDialog, cFieldCodigo, cFieldValor )

   local oError

   if empty( nId ) .or. empty( oDialog )
      RETURN ( Self )
   end if 

   DEFAULT cFieldCodigo := "codigo_primera_propiedad" ,;
      cFieldValor       := "valor_primera_propiedad"

   try 

   REDEFINE PAGES ::oPage ;
      ID          nId ;
      OF          oDialog ;
      DIALOGS     "PAGE_PROPERTY_GET"

   REDEFINE GET   ::oGetValorPropiedad ; 
      VAR         ::oController:oModel:hBuffer[ cFieldValor ] ;
      ID          120 ;
      IDTEXT      121 ;
      IDSAY       122 ;
      PICTURE     "@!" ;
      BITMAP      "LUPA" ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oPage:aDialogs[ 1 ]

   ::oGetValorPropiedad:bValid  := {|| ::oController:validatePropiedad( cFieldCodigo, cFieldValor, ::oGetValorPropiedad ) }
   ::oGetValorPropiedad:bHelp   := {|| brwPropiedadActual( ::oGetValorPropiedad, ::oGetValorPropiedad:oHelpText, ::oController:oModel:hBuffer[ cFieldCodigo ] ) }

   catch oError

      msgStop( "Imposible crear el control de tipos de ventas." + CRLF + ErrorMessage( oError ) )

   end

RETURN ( Self )

//---------------------------------------------------------------------------//

