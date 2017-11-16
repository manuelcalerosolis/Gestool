#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

#define EM_LIMITTEXT             197

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenLineasView FROM SQLBaseView
      
   DATA oPagePropertyControls
   DATA oPageUnitsControls

   DATA oPrimeraPropiedadControlView
   DATA oSegundaPropiedadControlView

   DATA oLoteCaducidadControlView

   DATA oOfficeBarView

   DATA oBtnSerie

   DATA oGetLote
   DATA oSayLote

   DATA oGetFechaCaducidad
   DATA oGetCodigoArticulo
   DATA oGetNombreArticulo
   DATA oGetValorPrimeraPropiedad
   DATA oGetValorSegundaPropiedad
   DATA oGetBultosArticulo
   DATA oGetCajasArticulo
   DATA oGetUnidadesArticulo
   DATA oSayTotalUnidades
   DATA oSayTextUnidades
   DATA oGetPrecioArticulo
   DATA oSayTextImporte
   DATA oSayTotalImporte
   DATA oSayBultosArticulo
   DATA oSayCajasArticulo
   DATA oSayUnidadesArticulo
   DATA oSayPrecioArticulo

   DATA oBrowsePropertyView

   METHOD New()

   METHOD Activate()
      METHOD pagePropertyControls()
      METHOD pageUnitsControls()

   METHOD startActivate()
   METHOD initActivate()

   METHOD nTotalUnidadesArticulo()     
   METHOD nTotalImporteArticulo()         

   METHOD refreshUnidadesImportes()       

   METHOD hidePropertyControls()          
   METHOD showPropertyControls( nPage )   

   METHOD hideLoteCaducidadControls()  INLINE ( ::verticalHide( ::oLoteCaducidadControlView:getPage() ) )          
   METHOD showLoteCaducidadControls()  INLINE ( ::verticalShow( ::oLoteCaducidadControlView:getPage() ) )

   METHOD hideUnitsControls()             
   METHOD showUnitsControls()             

   METHOD hidePrimeraPropiedad()       INLINE ( ::verticalHide( ::oPrimeraPropiedadControlView:getPage() ) )
   METHOD showPrimeraPropiedad()       INLINE ( ::verticalShow( ::oPrimeraPropiedadControlView:getPage() ) )

   METHOD hideSegundaPropiedad()       INLINE ( ::verticalHide( ::oSegundaPropiedadControlView:getPage() ) )
   METHOD showSegundaPropiedad()       INLINE ( ::verticalShow( ::oSegundaPropiedadControlView:getPage() ) )

   METHOD searchCodeGS128( nKey, cCodigoArticulo )

   METHOD verticalHide()

   METHOD verticalShow()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oController                    := oController

   ::oPrimeraPropiedadControlView   := PropertyControlView():New( oController )

   ::oSegundaPropiedadControlView   := PropertyControlView():New( oController )

   ::oLoteCaducidadControlView      := LoteCaducidadControlView():New( oController )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Activate()

   DEFINE DIALOG ::oDialog RESOURCE "MOVIMIENTOS_ALMACEN_LINEAS";
      TITLE ::lblTitle() + ::oController:getTitle()

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

      ::oLoteCaducidadControlView:createControl( 120, ::oDialog )

      ::oPrimeraPropiedadControlView:createControl( 121, ::oDialog, "codigo_primera_propiedad", "valor_primera_propiedad" )

      ::oSegundaPropiedadControlView:createControl( 122, ::oDialog, "codigo_segunda_propiedad", "valor_segunda_propiedad" )

      ::pagePropertyControls()

      ::pageUnitsControls()

      // Total Unidades--------------------------------------------------------

      REDEFINE SAY   ::oSayTotalUnidades ;
         PROMPT      ::nTotalUnidadesArticulo() ;
         ID          160 ;
         PICTURE     MasUnd() ;
         OF          ::oDialog

      REDEFINE SAY   ::oSayTextUnidades ;
         ID          161 ;
         OF          ::oDialog

      // Importe---------------------------------------------------------------

      REDEFINE GET   ::oGetPrecioArticulo ;
         VAR         ::oController:oModel:hBuffer[ "precio_articulo" ] ;
         ID          170 ;
         SPINNER ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         PICTURE     cPinDiv() ;
         OF          ::oDialog

      REDEFINE SAY   ::oSayPrecioArticulo ;
         ID          171 ;
         OF          ::oDialog

      ::oGetPrecioArticulo:bChange     := {|| ::refreshUnidadesImportes() }
      ::oGetPrecioArticulo:bValid      := {|| ::oGetCodigoArticulo:setFocus(), .t. }

      // Total Importe---------------------------------------------------------

      REDEFINE SAY   ::oSayTotalImporte ;
         PROMPT      ::nTotalImporteArticulo() ;
         ID          180 ;
         FONT        getBoldFont() ;
         PICTURE     cPirDiv() ;
         OF          ::oDialog

      REDEFINE SAY   ::oSayTextImporte ;
         ID          181 ;
         FONT        getBoldFont() ;
         OF          ::oDialog

      ::oDialog:bStart    := {|| ::startActivate() }

   ::oDialog:Activate( , , , .t., , , {|| ::initActivate() } ) 

   ::oOfficeBar:End()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD pagePropertyControls()

   REDEFINE PAGES ::oPagePropertyControls ;
      ID          140 ;
      OF          ::oDialog ;
      DIALOGS     "PAGE_PROPERTY_CONTROLS_BROWSE"

   ::oPagePropertyControls:lVisible    := .t.                  

   ::oBrowsePropertyView               := SQLPropertyBrowseView():New( 600, ::oPagePropertyControls:aDialogs[ 1 ] )
   ::oBrowsePropertyView:bOnPostEdit   := {|| ::oSayTotalUnidades:Refresh(), ::oSayTotalImporte:Refresh() }

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD pageUnitsControls()

   REDEFINE PAGES ::oPageUnitsControls ;
      ID          150 ;
      OF          ::oDialog ;
      DIALOGS     "PAGE_UNITS_CONTROLS"

   ::oPageUnitsControls:lVisible    := .t.

   REDEFINE SAY   ::oSayBultosArticulo ;
      ID          431 ;
      OF          ::oPageUnitsControls:aDialogs[ 1 ]

   REDEFINE GET   ::oGetBultosArticulo ;
      VAR         ::oController:oModel:hBuffer[ "bultos_articulo" ] ;
      ID          430 ;
      SPINNER ;
      WHEN        ( uFieldEmpresa( "lUseBultos" ) .and. ::oController:isNotZoomMode() ) ;
      PICTURE     MasUnd() ;
      OF          ::oPageUnitsControls:aDialogs[ 1 ]

   ::oGetBultosArticulo:bChange     := {|| ::refreshUnidadesImportes() }

   // Cajas-----------------------------------------------------------------

   REDEFINE SAY   ::oSayCajasArticulo ;
      ID          141 ;
      OF          ::oPageUnitsControls:aDialogs[ 1 ]

   REDEFINE GET   ::oGetCajasArticulo ;
      VAR         ::oController:oModel:hBuffer[ "cajas_articulo" ] ;
      ID          140 ;
      SPINNER ;
      WHEN        ( uFieldEmpresa( "lUseCaj" ) .and. ::oController:isNotZoomMode() ) ;
      PICTURE     MasUnd() ;
      OF          ::oPageUnitsControls:aDialogs[ 1 ]

   ::oGetCajasArticulo:bChange      := {|| ::refreshUnidadesImportes() }

   // Unidades--------------------------------------------------------------

   REDEFINE SAY   ::oSayUnidadesArticulo ;
      ID          151 ;
      OF          ::oPageUnitsControls:aDialogs[ 1 ]

   REDEFINE GET   ::oGetUnidadesArticulo ;
      VAR         ::oController:oModel:hBuffer[ "unidades_articulo" ] ;
      ID          150 ;
      SPINNER ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      PICTURE     MasUnd() ;
      OF          ::oPageUnitsControls:aDialogs[ 1 ]

   ::oGetUnidadesArticulo:bChange   := {|| ::refreshUnidadesImportes() }

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD startActivate()

   if ::oController:isAppendMode()
      
      ::oController:setModelBuffer( "codigo_articulo", space( 200 ) )
      
      ::oGetCodigoArticulo:Refresh()
      
      ::hideLoteCaducidadControls()

      ::hidePrimeraPropiedad()

      ::hideSegundaPropiedad()

   end if 

   if ::oController:isNotAppendMode()
   
      ::oController:validateCodigoArticulo()
   
      ::oController:validatePrimeraPropiedad()
   
      ::oController:validateSegundaPropiedad()      
   
   end if 

   if !( uFieldEmpresa( "lUseBultos" ) )

      ::oSayBultosArticulo:Hide()

      ::oGetBultosArticulo:Hide()

   end if 

   ::oSayTotalUnidades:Refresh()

   ::oSayTotalImporte:Refresh()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD initActivate()

   local oGrupo
   
   ::oOfficeBar      := OfficeBarView():New( Self )

   ::oOfficeBar:createButtonsDialog()

   oGrupo            := TDotNetGroup():New( ::oOfficeBar:oOfficeBarFolder, 66, "Series", .f. )
      ::oBtnSerie    := TDotNetButton():New( 60, oGrupo, "gc_barcode_scanner_32", "Series [F7]", 1, {|| ::oController:runDialogSeries() }, , , .f., .f., .f. )

   ::oDialog:AddFastKey( VK_F7, {|| ::oBtnSerie:Action() } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD nTotalUnidadesArticulo()

   if hb_isobject( ::oBrowsePropertyView ) .and. ::oBrowsePropertyView:lVisible
      RETURN ( ::oBrowsePropertyView:nTotalUnits() )
   end if

RETURN ( notCaja( ::oController:oModel:hBuffer[ "cajas_articulo" ] ) * ::oController:oModel:hBuffer[ "unidades_articulo" ] )

//---------------------------------------------------------------------------//

METHOD nTotalImporteArticulo()         

RETURN ( ::nTotalUnidadesArticulo() * ::oController:oModel:hBuffer[ "precio_articulo" ] )

//---------------------------------------------------------------------------//

METHOD hidePropertyControls()

   ::verticalHide( ::oPagePropertyControls )
   
   aeval( ::oPagePropertyControls:aDialogs, {| oDialog | aeval( oDialog:aControls, {| oControl | oControl:lVisible := .f. } ) } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD showPropertyControls( nPage )   

   aeval( ::oPagePropertyControls:aDialogs, {|oDialog| aeval( oDialog:aControls, {| oControl | oControl:lVisible := .t. } ) } )

   ::verticalShow( ::oPagePropertyControls )

   ::oPagePropertyControls:setOption( nPage )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD hideUnitsControls()

   ::verticalHide( ::oPageUnitsControls )   
   
   aeval( ::oPageUnitsControls:aDialogs, {| oDialog | aeval( oDialog:aControls, {| oControl | oControl:lVisible := .f. } ) } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD showUnitsControls()      

   ::verticalShow( ::oPageUnitsControls ) 
   
   aeval( ::oPageUnitsControls:aDialogs, {| oDialog | aeval( oDialog:aControls, {| oControl | oControl:lVisible := .t. } ) } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD refreshUnidadesImportes()       

RETURN ( ::oSayTotalUnidades():Refresh(), ::oSayTotalImporte():Refresh() )

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

METHOD verticalHide( oControl )

   local nId     
   local oRect    
   local nHeight  

   if !( oControl:lVisible )
      RETURN ( .f. )
   end if  

   oRect          := ::oDialog:getRect()
   nId            := oControl:nId
   nHeight        := oControl:nHeight + 2

   oControl:Hide()

   aeval( ::oDialog:aControls,;
      {|oControl| if( oControl:nId > nId,;
         oControl:move( oControl:nTop - nHeight, oControl:nLeft, oControl:nWidth, oControl:nHeight ), ) } )

   ::oDialog:move( oRect:nTop, oRect:nLeft, ::oDialog:nWidth, ::oDialog:nHeight - nHeight )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD verticalShow( oControl )

   local nId     
   local oRect    
   local nHeight 

   if oControl:lVisible
      RETURN ( .f. )
   end if  

   oRect          := ::oDialog:getRect()
   nId            := oControl:nId
   nHeight        := oControl:nHeight + 2

   oControl:Show()

   aeval( ::oDialog:aControls,;
      {|oControl| if( oControl:nId > nId,;
         oControl:move( oControl:nTop + nHeight, oControl:nLeft, oControl:nWidth, oControl:nHeight ), ) } )

   ::oDialog:move( oRect:nTop, oRect:nLeft, ::oDialog:nWidth, ::oDialog:nHeight + nHeight )

RETURN ( .t. )

//---------------------------------------------------------------------------//



