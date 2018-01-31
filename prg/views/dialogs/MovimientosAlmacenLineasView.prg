#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

#define EM_LIMITTEXT             197

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenLineasView FROM SQLBaseView
      
   DATA oBtnSerie
   DATA oBtnOk
   DATA oBtnOkAndNew

   DATA oGetCodigoArticulo
   DATA oGetNombreArticulo

   DATA oGetLote

   DATA oGetCaducidad
   
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
      METHOD initActivate()

   METHOD nTotalUnidadesArticulo()     
   METHOD nTotalImporteArticulo()         

   METHOD refreshUnidadesImportes()       

   METHOD hidePropertyBrowseView()                 INLINE ( ::verticalHide( ::oBrowsePropertyView:getBrowse() ) )         
   METHOD showPropertyBrowseView()                 INLINE ( ::verticalShow( ::oBrowsePropertyView:getBrowse() ) )
   METHOD buildPropertyBrowseView()                INLINE ( ::oBrowsePropertyView:Build() )

   METHOD setPropertyOneBrowseView( cProperty )    INLINE ( ::oBrowsePropertyView:setPropertyOne( cProperty ) )
   METHOD setPropertyTwoBrowseView( cProperty )    INLINE ( ::oBrowsePropertyView:setPropertyTwo( cProperty ) )

   METHOD hideLoteCaducidadControls()              INLINE ( ::verticalHide( ::oGetLote ), ::verticalHide( ::oGetCaducidad ) )          
   METHOD showLoteCaducidadControls()              INLINE ( ::verticalShow( ::oGetLote ), ::verticalShow( ::oGetCaducidad ) )

   METHOD hideUnitsControls()             

   METHOD hidePrimeraPropiedad()                   INLINE ( ::verticalHide( ::oGetValorPrimeraPropiedad ) )
   METHOD showPrimeraPropiedad()                   INLINE ( ::verticalShow( ::oGetValorPrimeraPropiedad ) )

   METHOD hideSegundaPropiedad()                   INLINE ( ::verticalHide( ::oGetValorSegundaPropiedad ) )
   METHOD showSegundaPropiedad()                   INLINE ( ::verticalShow( ::oGetValorSegundaPropiedad ) )

   METHOD hideBultos()                             INLINE ( iif( !uFieldEmpresa( "lUseBultos" ), ::verticalHide( ::oGetBultosArticulo ), ) )
   METHOD hideCajas()                              INLINE ( iif( !uFieldEmpresa( "lUseCaj" ),    ::verticalHide( ::oGetCajasArticulo ), ) )
   METHOD hidePrecios()

   METHOD searchCodeGS128( nKey, cCodigoArticulo )

   METHOD verticalHide()

   METHOD verticalShow()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oController     := oController

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
         ID          101 ;
         WHEN        ( .f. ) ;
         OF          ::oDialog

      REDEFINE GET   ::oGetLote ;
         VAR         ::oController:oModel:hBuffer[ "lote" ] ;
         ID          110 ;
         IDSAY       111 ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         OF          ::oDialog

      ::oGetLote:bValid   := {|| ::oController:validateLote() }

      REDEFINE GET   ::oGetCaducidad ;
         VAR         ::oController:oModel:hBuffer[ "fecha_caducidad" ] ;
         ID          120 ;
         IDSAY       121 ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         OF          ::oDialog

      // Valor de primera propiedad--------------------------------------------      
    
      REDEFINE GET   ::oGetValorPrimeraPropiedad ;     
         VAR         ::oController:oModel:hBuffer[ "valor_primera_propiedad" ] ;     
         ID          130 ;     
         IDTEXT      131 ;     
         IDSAY       132 ;     
         PICTURE     "@!" ;    
         BITMAP      "LUPA" ;     
         WHEN        ( ::oController:isNotZoomMode() ) ;     
         OF          ::oDialog    
     
      ::oGetValorPrimeraPropiedad:bValid  := {|| ::oController:validatePrimeraPropiedad() }      
      ::oGetValorPrimeraPropiedad:bHelp   := {|| brwPropiedadActual( ::oGetValorPrimeraPropiedad, ::oGetValorPrimeraPropiedad:oHelpText, ::oController:oModel:hBuffer[ "codigo_primera_propiedad" ] ) }      

      REDEFINE GET   ::oGetValorSegundaPropiedad ; 
         VAR         ::oController:oModel:hBuffer[ "valor_segunda_propiedad" ] ;     
         ID          140 ;     
         IDTEXT      141 ;     
         IDSAY       142 ;     
         PICTURE     "@!" ;    
         BITMAP      "LUPA" ;     
         WHEN        ( ::oController:isNotZoomMode() ) ;     
         OF          ::oDialog    
    
      ::oGetValorSegundaPropiedad:bValid  := {|| ::oController:validateSegundaPropiedad() }      
      ::oGetValorSegundaPropiedad:bHelp   := {|| brwPropiedadActual( ::oGetValorSegundaPropiedad, ::oGetValorSegundaPropiedad:oHelpText, ::oController:oModel:hBuffer[ "codigo_segunda_propiedad" ] ) }

      // Property browse-------------------------------------------------------

      ::oBrowsePropertyView               := SQLPropertyBrowseView():CreateControl( 150, ::oDialog )
      ::oBrowsePropertyView:setOnPostEdit( {|| ::refreshUnidadesImportes() } )

      // Bultos----------------------------------------------------------------

      REDEFINE GET   ::oGetBultosArticulo ;      
         VAR         ::oController:oModel:hBuffer[ "bultos_articulo" ] ;    
         ID          160 ;     
         IDSAY       161 ;     
         SPINNER ;    
         WHEN        ( uFieldEmpresa( "lUseBultos" ) .and. ::oController:isNotZoomMode() ) ;     
         PICTURE     MasUnd() ;      
         OF          ::oDialog    
    
      ::oGetBultosArticulo:bChange        := {|| ::refreshUnidadesImportes() }    
    
      // Cajas-----------------------------------------------------------------      
    
      REDEFINE GET   ::oGetCajasArticulo ;    
         VAR         ::oController:oModel:hBuffer[ "cajas_articulo" ] ;     
         ID          170 ;     
         IDSAY       171 ;     
         SPINNER ;    
         WHEN        ( uFieldEmpresa( "lUseCaj" ) .and. ::oController:isNotZoomMode() ) ;     
         PICTURE     MasUnd() ;      
         OF          ::oDialog    
    
      ::oGetCajasArticulo:bChange      := {|| ::refreshUnidadesImportes() }    
    
      // Unidades--------------------------------------------------------------      
    
      REDEFINE GET   ::oGetUnidadesArticulo ;    
         VAR         ::oController:oModel:hBuffer[ "unidades_articulo" ] ;     
         ID          180 ;     
         IDSAY       181 ;     
         SPINNER ;    
         WHEN        ( ::oController:isNotZoomMode() ) ;     
         PICTURE     MasUnd() ;      
         OF          ::oDialog    
    
      ::oGetUnidadesArticulo:bChange   := {|| ::refreshUnidadesImportes() }

      // Total Unidades--------------------------------------------------------

      REDEFINE SAY   ::oSayTotalUnidades ;
         PROMPT      ::nTotalUnidadesArticulo() ;
         ID          190 ;
         PICTURE     MasUnd() ;
         OF          ::oDialog

      REDEFINE SAY   ::oSayTextUnidades ;
         ID          191 ;
         OF          ::oDialog

      // Importe---------------------------------------------------------------

      REDEFINE GET   ::oGetPrecioArticulo ;
         VAR         ::oController:oModel:hBuffer[ "precio_articulo" ] ;
         ID          200 ;
         IDSAY       201 ;
         SPINNER ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         PICTURE     cPinDiv() ;
         OF          ::oDialog

      ::oGetPrecioArticulo:bChange     := {|| ::refreshUnidadesImportes() }

      // Total Importe---------------------------------------------------------

      REDEFINE SAY   ::oSayTotalImporte ;
         PROMPT      ::nTotalImporteArticulo() ;
         ID          210 ;
         FONT        getBoldFont() ;
         PICTURE     cPirDiv() ;
         OF          ::oDialog

      ::oSayTotalImporte:lVisible      := .t.

      REDEFINE SAY   ::oSayTextImporte ;
         ID          211 ;
         FONT        getBoldFont() ;
         OF          ::oDialog

      ::oSayTextImporte:lVisible       := .t.

      REDEFINE BUTTON ::oBtnSerie ;
         ID          4 ;
         OF          ::oDialog ;
         WHEN        ( ::getController():isEditMode() ) ;
         ACTION      ( ::oController:runDialogSeries() )

      REDEFINE BUTTON ::oBtnOk ; 
         ID          9 ; 
         OF          ::oDialog ;
         WHEN        ( ::getController():isNotZoomMode() ) ;
         ACTION      ( if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) )

      REDEFINE BUTTON ::oBtnOkAndNew ;
         ID          3 ;
         OF          ::oDialog ;
         WHEN        ( ::getController():isAppendMode() ) ;
         ACTION      ( if( validateDialog( ::oDialog ), ::oDialog:end( IDOKANDNEW ), ) )

      REDEFINE BUTTON ;
         CANCEL ;
         ID          IDCANCEL ;
         OF          ::oDialog ;
         ACTION      ( ::oDialog:end() )

   ::oDialog:bStart  := {|| ::oController:onActivateDialog() }

   ::oDialog:Activate( , , , .t., , , {|| ::initActivate() } ) 

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD initActivate()

   ::oDialog:AddFastKey( VK_F5, {|| eval( ::oBtnOk:bAction ) } )

   ::oDialog:AddFastKey( VK_F6, {|| eval( ::oBtnOkAndNew:bAction ) } )

   ::oDialog:AddFastKey( VK_F7, {|| eval( ::oBtnSerie:bAction ) } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD nTotalUnidadesArticulo()

   if hb_isobject( ::oBrowsePropertyView ) .and. ::oBrowsePropertyView:lVisible()
      RETURN ( ::oBrowsePropertyView:nTotalUnits() )
   end if

RETURN ( notCaja( ::oController:oModel:hBuffer[ "cajas_articulo" ] ) * ::oController:oModel:hBuffer[ "unidades_articulo" ] )

//---------------------------------------------------------------------------//

METHOD nTotalImporteArticulo()         

RETURN ( ::nTotalUnidadesArticulo() * ::oController:oModel:hBuffer[ "precio_articulo" ] )

//---------------------------------------------------------------------------//

METHOD hideUnitsControls()

   ::verticalHide( ::oGetBultosArticulo )   
   
   ::verticalHide( ::oGetCajasArticulo )   

   ::verticalHide( ::oGetUnidadesArticulo )   

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD refreshUnidadesImportes()       

RETURN ( ::oSayTotalUnidades():Refresh(), ::oSayTotalImporte():Refresh() )

//---------------------------------------------------------------------------//

METHOD searchCodeGS128( nKey ) 

   static cChar   := ""

   cChar          += chr( nKey ) 

   if nKey == 16 
      ::oGetCodigoArticulo:oGet:Insert( '@' )
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD hidePrecios()
   
   if oUser():lNotCostos()

      ::verticalHide( ::oGetPrecioArticulo )
      
      ::verticalHide( ::oSayTotalImporte )
      
      ::verticalHide( ::oSayTextImporte )

   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD verticalHide( oControl )

   local nId     
   local nHeight  

   if !( oControl:lVisible )
      RETURN ( .f. )
   end if  

   nId            := oControl:nId
   nHeight        := oControl:nHeight + 1

   oControl:Hide()

   aeval( ::oDialog:aControls,;
      {|oControl| if( oControl:nId >= 100 .and. oControl:nId > nId,;
         oControl:move( oControl:nTop - nHeight, oControl:nLeft, oControl:nWidth, oControl:nHeight ), ) } )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD verticalShow( oControl )

   local nId     
   local nHeight 

   if oControl:lVisible
      RETURN ( .f. )
   end if  

   nId            := oControl:nId
   nHeight        := oControl:nHeight + 1

   oControl:Show()

   aeval( ::oDialog:aControls,;
      {|oControl| if( oControl:nId >= 100 .and. oControl:nId > nId,;
         oControl:move( oControl:nTop + nHeight, oControl:nLeft, oControl:nWidth, oControl:nHeight ), ) } )

RETURN ( .t. )

//---------------------------------------------------------------------------//



