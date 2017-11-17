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

   DATA oGetCaducidad
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

   DATA oPropertyBrowseView

   DATA oBultosControlView

   DATA oCajasControlView

   DATA oUnidadesControlView

   METHOD New()

   METHOD Activate()
      METHOD pageUnitsControls()

   METHOD startActivate()
   METHOD initActivate()

   METHOD nTotalUnidadesArticulo()     
   METHOD nTotalImporteArticulo()         

   METHOD refreshUnidadesImportes()       

   METHOD hidePropertyBrowseView()                 INLINE ( ::verticalHide( ::oPropertyBrowseView:getPage() ) )         
   METHOD showPropertyBrowseView()                 INLINE ( ::verticalShow( ::oPropertyBrowseView:getPage() ) )
   METHOD buildPropertyBrowseView()                INLINE ( ::verticalShow( ::oPropertyBrowseView:Build() ) )

   METHOD setPropertyOneBrowseView( cProperty )    INLINE ( ::oPropertyBrowseView:setPropertyOne( cProperty ) )
   METHOD setPropertyTwoBrowseView( cProperty )    INLINE ( ::oPropertyBrowseView:setPropertyTwo( cProperty ) )

   METHOD setOnPostEditBrowseView( bOnPostEdit )   INLINE ( ::oPropertyBrowseView:setOnPostEdit( bOnPostEdit ) )

   METHOD hideLoteCaducidadControls()              INLINE ( ::verticalHide( ::oGetLote ), ::verticalHide( ::oGetCaducidad ) )          
   METHOD showLoteCaducidadControls()              INLINE ( ::verticalShow( ::oGetLote ), ::verticalShow( ::oGetCaducidad ) )

   METHOD hideUnitsControls()             
   METHOD showUnitsControls()             

   METHOD hidePrimeraPropiedad()                   INLINE ( ::verticalHide( ::oPrimeraPropiedadControlView:getPage() ) )
   METHOD showPrimeraPropiedad()                   INLINE ( ::verticalShow( ::oPrimeraPropiedadControlView:getPage() ) )

   METHOD hideSegundaPropiedad()                   INLINE ( ::verticalHide( ::oSegundaPropiedadControlView:getPage() ) )
   METHOD showSegundaPropiedad()                   INLINE ( ::verticalShow( ::oSegundaPropiedadControlView:getPage() ) )

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

   ::oPropertyBrowseView            := SQLPropertyBrowseView():New( oController )

   ::oBultosControlView             := NumericControlView():New( oController )
   ::oBultosControlView:setFieldName( "bultos_articulo" )
   ::oBultosControlView:setText( "Bultos" )
   ::oBultosControlView:setOnChange( {|| ::refreshUnidadesImportes() } )

   ::oCajasControlView              := NumericControlView():New( oController )
   ::oCajasControlView:setFieldName( "cajas_articulo" )
   ::oCajasControlView:setText( "Cajas" )
   ::oCajasControlView:setOnChange( {|| ::refreshUnidadesImportes() } )

   ::oUnidadesControlView           := NumericControlView():New( oController )
   ::oUnidadesControlView:setFieldName( "unidades_articulo" )
   ::oUnidadesControlView:setText( "Unidades" )
   ::oUnidadesControlView:setOnChange( {|| ::refreshUnidadesImportes() } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Activate()

   DEFINE DIALOG     ::oDialog ;
      RESOURCE       "MOVIMIENTOS_ALMACEN_LINEAS";
      TITLE          ::lblTitle() + ::oController:getTitle()

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
         ID          111 ;
         IDSAY       113 ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         OF          ::oDialog

      ::oGetLote:bValid   := {|| ::oController:validateLote() }

      REDEFINE GET   ::oGetCaducidad ;
         VAR         ::oController:oModel:hBuffer[ "fecha_caducidad" ] ;
         ID          112 ;
         IDSAY       114 ;
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
      ::oBrowsePropertyView:bOnPostEdit   := {|| ::refreshUnidadesImportes() }

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

METHOD pageUnitsControls()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD startActivate()
/*
   if ::oController:isAppendMode()
      
      ::oController:setModelBuffer( "codigo_articulo", space( 200 ) )
      
      ::oGetCodigoArticulo:Refresh()
      
      ::hideLoteCaducidadControls()

      ::hidePrimeraPropiedad()

      ::hideSegundaPropiedad()

      ::hidePropertyBrowseView()

   end if 

   if ::oController:isNotAppendMode()
   
      ::oController:validateCodigoArticulo()
   
      ::oController:validatePrimeraPropiedad()
   
      ::oController:validateSegundaPropiedad()      
   
   end if 

   if !( uFieldEmpresa( "lUseBultos" ) )
      ::verticalHide( ::oBultosControlView:getPage() )
   end if 

   if !( uFieldEmpresa( "lUseCaj" ) )
      ::verticalHide( ::oCajasControlView:getPage() )
   end if 

   ::oSayTotalUnidades:Refresh()

   ::oSayTotalImporte:Refresh()
*/
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

   logwrite( ::oPropertyBrowseView:lVisible, "::oPropertyBrowseView:lVisible" )

   if hb_isobject( ::oPropertyBrowseView ) .and. ::oPropertyBrowseView:lVisible
      RETURN ( ::oPropertyBrowseView:nTotalUnits() )
   end if

RETURN ( notCaja( ::oController:oModel:hBuffer[ "cajas_articulo" ] ) * ::oController:oModel:hBuffer[ "unidades_articulo" ] )

//---------------------------------------------------------------------------//

METHOD nTotalImporteArticulo()         

RETURN ( ::nTotalUnidadesArticulo() * ::oController:oModel:hBuffer[ "precio_articulo" ] )

//---------------------------------------------------------------------------//

METHOD hideUnitsControls()

   ::verticalHide( ::oBultosControlView:getPage() )   
   
   ::verticalHide( ::oCajasControlView:getPage() )   

   ::verticalHide( ::oUnidadesControlView:getPage() )   

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



