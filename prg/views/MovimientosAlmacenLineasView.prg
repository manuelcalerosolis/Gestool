#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenLineasView FROM SQLBaseView

   DATA oGetLote
   DATA oGetCodigoArticulo
   DATA oGetNombreArticulo
   DATA oGetValorPrimeraPropiedad
   DATA oGetValorSegundaPropiedad

   METHOD New()

   METHOD Dialog()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oController     := oController

   ::cImageName      := "gc_bookmarks_16"

Return ( Self )

//---------------------------------------------------------------------------//

METHOD Dialog()

   local oDlg
   local oBtn

   DEFINE DIALOG oDlg RESOURCE "LMovAlm" TITLE ::lblTitle() + "lineas de movimientos de almacén"

      REDEFINE GET   ::oGetCodigoArticulo ;
         VAR         ::oController:oModel:hBuffer[ "codigo_articulo" ] ;
         ID          100 ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         PICTURE     "@!" ;
         BITMAP      "Lupa" ;
         OF          oDlg

      ::oGetCodigoArticulo:bValid   := {|| ::oController:validateCodigoArticulo() }
      ::oGetCodigoArticulo:bHelp    := {|| brwArticulo( ::oGetCodigoArticulo ) }

      REDEFINE GET   ::oGetNombreArticulo ;
         VAR         ::oController:oModel:hBuffer[ "nombre_articulo" ] ;
         ID          110 ;
         WHEN        ( .f. ) ;
         OF          oDlg

      REDEFINE GET   ::oGetLote ;
         VAR         ::oController:oModel:hBuffer[ "lote" ] ;
         ID          155 ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         OF          oDlg

      // Valor de primera propiedad--------------------------------------------

      REDEFINE GET   ::oGetValorPrimeraPropiedad ; 
         VAR         ::oController:oModel:hBuffer[ "valor_primera_propiedad" ] ;
         ID          120 ;
         IDTEXT      121 ;
         IDSAY       122 ;
         PICTURE     "@!" ;
         BITMAP      "LUPA" ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         OF          oDlg

      ::oGetValorPrimeraPropiedad:bValid  := {|| ::oController:validatePrimeraPropiedad() }
      ::oGetValorPrimeraPropiedad:bHelp   := {|| brwPropiedadActual( ::oGetValorPrimeraPropiedad, ::oGetValorPrimeraPropiedad:oHelpText, ::oController:oModel:hBuffer[ "codigo_primera_propiedad" ] ) }

      // Valor de segunda propiedad--------------------------------------------

      REDEFINE GET   ::oGetValorSegundaPropiedad ; 
         VAR         ::oController:oModel:hBuffer[ "valor_segunda_propiedad" ] ;
         ID          130 ;
         IDTEXT      131 ;
         IDSAY       132 ;
         PICTURE     "@!" ;
         BITMAP      "LUPA" ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         OF          oDlg

      ::oGetValorSegundaPropiedad:bValid  := {|| ::oController:validateSegundaPropiedad() }
      ::oGetValorSegundaPropiedad:bHelp   := {|| brwPropiedadActual( ::oGetValorSegundaPropiedad, ::oGetValorSegundaPropiedad:oHelpText, ::oController:oModel:hBuffer[ "codigo_segunda_propiedad" ] ) }

      REDEFINE BUTTON oBtn;
         ID          510 ;
         OF          oDlg ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         ACTION      ( if( validateDialog( oDlg ), oDlg:end( IDOK ), ) )

      REDEFINE BUTTON ;
         ID          520 ;
         OF          oDlg ;
         ACTION      ( oDlg:end() )

      if ::oController:isNotZoomMode()
         oDlg:AddFastKey( VK_F5, {|| oBtn:Click() } )
      end if

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

