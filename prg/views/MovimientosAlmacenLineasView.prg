#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

#define EM_LIMITTEXT             197

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenLineasView FROM SQLBaseView

   DATA oOfficeBarView

   DATA oBtnSerie

   DATA oGetLote
   DATA oGetFechaCaducidad
   DATA oGetCodigoArticulo
   DATA oGetNombreArticulo
   DATA oGetValorPrimeraPropiedad
   DATA oGetValorSegundaPropiedad
   DATA oGetBultosArticulo
   DATA oGetCajasArticulo
   DATA oGetUnidadesArticulo
   DATA oSayTotalUnidades
   DATA oGetPrecioArticulo
   DATA oSayTotalImporte

   DATA oBrowsePropertyView

   METHOD New()

   METHOD Activate()
   METHOD startActivate()
   METHOD initActivate()

   METHOD nTotalUnidadesArticulo()     

   METHOD nTotalImporteArticulo()      INLINE ( ::nTotalUnidadesArticulo() * ::oController:oModel:hBuffer[ "precio_articulo" ] )

   METHOD hideCantidadesArticulos()    INLINE ( ::oGetBultosArticulo:hide(), ::oGetCajasArticulo:hide(), ::oGetUnidadesArticulo:hide() )
   
   METHOD showCantidadesArticulos()    INLINE ( ::oGetBultosArticulo:show(), ::oGetCajasArticulo:show(), ::oGetUnidadesArticulo:show() )

   METHOD refreshUnidadesImportes()    INLINE ( ::oSayTotalUnidades():Refresh(), ::oSayTotalImporte():Refresh() )

   METHOD searchCodeGS128( nKey, cCodigoArticulo )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oController     := oController

   ::cImageName      := "gc_bookmarks_16"

Return ( Self )

//---------------------------------------------------------------------------//

METHOD Activate()

   DEFINE DIALOG ::oDialog RESOURCE "MOVIMIENTOS_ALMACEN_LINEAS" TITLE ::lblTitle() + ::oController:getTitle()

      REDEFINE GET   ::oGetCodigoArticulo ;
         VAR         ::oController:oModel:hBuffer[ "codigo_articulo" ] ;
         ID          100 ;
         WHEN        ( ::oController:isAppendMode() ) ;
         PICTURE     "@!" ;
         BITMAP      "Lupa" ;
         OF          ::oDialog

      ::oGetCodigoArticulo:bKeyDown := {|nKey| ::searchCodeGS128( nKey ) }
      ::oGetCodigoArticulo:bValid   := {|| ::oController:validateCodigoArticulo() }
      ::oGetCodigoArticulo:bHelp    := {|| brwArticulo( ::oGetCodigoArticulo ) }

      REDEFINE GET   ::oGetNombreArticulo ;
         VAR         ::oController:oModel:hBuffer[ "nombre_articulo" ] ;
         ID          110 ;
         WHEN        ( .f. ) ;
         OF          ::oDialog

      REDEFINE GET   ::oGetLote ;
         VAR         ::oController:oModel:hBuffer[ "lote" ] ;
         ID          155 ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         OF          ::oDialog

      ::oGetLote:bValid   := {|| ::oController:validateLote() }

      // Fecha de caducidad----------------------------------------------------

      REDEFINE GET   ::oGetFechaCaducidad ;
         VAR         ::oController:oModel:hBuffer[ "fecha_caducidad" ] ;
         ID          340 ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         OF          ::oDialog

      // Valor de primera propiedad--------------------------------------------

      REDEFINE GET   ::oGetValorPrimeraPropiedad ; 
         VAR         ::oController:oModel:hBuffer[ "valor_primera_propiedad" ] ;
         ID          120 ;
         IDTEXT      121 ;
         IDSAY       122 ;
         PICTURE     "@!" ;
         BITMAP      "LUPA" ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         OF          ::oDialog

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
         OF          ::oDialog

      ::oGetValorSegundaPropiedad:bValid  := {|| ::oController:validateSegundaPropiedad() }
      ::oGetValorSegundaPropiedad:bHelp   := {|| brwPropiedadActual( ::oGetValorSegundaPropiedad, ::oGetValorSegundaPropiedad:oHelpText, ::oController:oModel:hBuffer[ "codigo_segunda_propiedad" ] ) }

      // Property browse-------------------------------------------------------

      ::oBrowsePropertyView               := SQLPropertyBrowseView():New( 600, ::oDialog )
      ::oBrowsePropertyView:bOnPostEdit   := {|| ::oSayTotalUnidades:Refresh(), ::oSayTotalImporte:Refresh() }

      // Bultos----------------------------------------------------------------

      REDEFINE GET   ::oGetBultosArticulo ;
         VAR         ::oController:oModel:hBuffer[ "bultos_articulo" ] ;
         ID          430 ;
         IDSAY       431 ;
         SPINNER ;
         WHEN        ( uFieldEmpresa( "lUseBultos" ) .and. ::oController:isNotZoomMode() ) ;
         PICTURE     MasUnd() ;
         OF          ::oDialog

      ::oGetBultosArticulo:bChange        := {|| ::refreshUnidadesImportes() }

      // Cajas-----------------------------------------------------------------

      REDEFINE GET   ::oGetCajasArticulo ;
         VAR         ::oController:oModel:hBuffer[ "cajas_articulo" ] ;
         ID          140 ;
         IDSAY       142 ;
         SPINNER ;
         WHEN        ( uFieldEmpresa( "lUseCaj" ) .and. ::oController:isNotZoomMode() ) ;
         PICTURE     MasUnd() ;
         OF          ::oDialog

      ::oGetCajasArticulo:bChange      := {|| ::refreshUnidadesImportes() }

      // Unidades--------------------------------------------------------------

      REDEFINE GET   ::oGetUnidadesArticulo ;
         VAR         ::oController:oModel:hBuffer[ "unidades_articulo" ] ;
         ID          150 ;
         IDSAY       152 ;
         SPINNER ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         PICTURE     MasUnd() ;
         OF          ::oDialog

      ::oGetUnidadesArticulo:bChange   := {|| ::refreshUnidadesImportes() }

      // Total Unidades--------------------------------------------------------

      REDEFINE SAY   ::oSayTotalUnidades ;
         PROMPT      ::nTotalUnidadesArticulo() ;
         ID          160;
         PICTURE     MasUnd() ;
         OF          ::oDialog

      // Importe---------------------------------------------------------------

      REDEFINE GET   ::oGetPrecioArticulo ;
         VAR         ::oController:oModel:hBuffer[ "precio_articulo" ] ;
         ID          180 ;
         IDSAY       181 ;
         SPINNER ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         PICTURE     cPinDiv() ;
         OF          ::oDialog

      ::oGetPrecioArticulo:bChange     := {|| ::refreshUnidadesImportes() }
      ::oGetPrecioArticulo:bValid      := {|| ::oGetCodigoArticulo:setFocus(), .t. }

      // Total Importe---------------------------------------------------------

      REDEFINE SAY   ::oSayTotalImporte ;
         PROMPT      ::nTotalImporteArticulo() ;
         ID          190;
         PICTURE     cPirDiv() ;
         OF          ::oDialog

      ::oDialog:bStart    := {|| ::startActivate() }

   ::oDialog:Activate( , , , .t., , , {|| ::initActivate() } ) 

   ::oOfficeBar:End()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD startActivate()

   if ::oController:isAppendMode()
      ::oController:setModelBuffer( "codigo_articulo", space( 200 ) )
      ::oGetCodigoArticulo:Refresh()
   end if 

   if ::oController:isNotAppendMode()
      ::oController:validateCodigoArticulo()
      ::oController:validatePrimeraPropiedad()
      ::oController:validateSegundaPropiedad()      
   end if 

   ::oSayTotalUnidades:Refresh()

   ::oSayTotalImporte:Refresh()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD initActivate()

   local oGrupo
   
   ::oOfficeBar               := OfficeBarView():New( Self )

   ::oOfficeBar:createButtonsDialog()

   oGrupo                     := TDotNetGroup():New( ::oOfficeBar:oOfficeBarFolder, 66, "Series", .f. )
      ::oBtnSerie             := TDotNetButton():New( 60, oGrupo, "gc_barcode_scanner_32", "Series [F7]", 1, {|| ::oController:runDialogSeries() }, , , .f., .f., .f. )

   ::oDialog:AddFastKey( VK_F7, {|| ::oBtnSerie:Action() } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD nTotalUnidadesArticulo()

   if hb_isobject( ::oBrowsePropertyView ) .and. ::oBrowsePropertyView:lVisible
      RETURN ( ::oBrowsePropertyView:nTotalUnits() )
   end if

RETURN ( notCaja( ::oController:oModel:hBuffer[ "cajas_articulo" ] ) * ::oController:oModel:hBuffer[ "unidades_articulo" ] )

//---------------------------------------------------------------------------//

METHOD searchCodeGS128( nKey )

   static cChar   := ""

   cChar          += chr( nKey )

   logwrite( cChar )

   if nKey == 16 
      ::oGetCodigoArticulo:oGet:Insert( '@' )
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//



