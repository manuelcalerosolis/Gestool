#include "FiveWin.Ch"
#include "Factu.ch" 
 
CLASS DocumentLine FROM DocumentBase

   DATA oDocumentHeader

   METHOD newBuildDictionary( oSender )

   METHOD setSerieMaster( hDictionary )                        INLINE ( ::setValueFromDictionary( hDictionary, "Serie" ) )
   METHOD setNumeroMaster( hDictionary )                       INLINE ( ::setValueFromDictionary( hDictionary, "Numero" ) )
   METHOD setSufijoMaster( hDictionary )                       INLINE ( ::setValueFromDictionary( hDictionary, "Sufijo" ) )
   METHOD setAlmacenMaster( hDictionary )                      INLINE ( ::setValueFromDictionary( hDictionary, "Almacen" ) )

   METHOD getNumeroLinea()                                     INLINE ( ::getValue( "NumeroLinea" ) )
   METHOD setNumeroLinea( NumeroLinea )                        INLINE ( ::setValue( "NumeroLinea", NumeroLinea ) )
   METHOD setPosicionImpresion( PosicionImpresion)             INLINE ( ::setValue( "PosicionImpresion", PosicionImpresion ) )

   METHOD getCode()                                            INLINE ( ::getValue( "Articulo" ) )
   METHOD getProductId()                                       INLINE ( ::getValue( "Articulo" ) )
   METHOD getDescription()                                     INLINE ( if(   !empty( ::getCode() ),;
                                                                              ::getValue( "DescripcionArticulo" ),;
                                                                              ::getValue( "DescripcionAmpliada" ) ) )
   METHOD getAlmacen()                                         INLINE ( ::getValue( "Almacen") )
   METHOD getCodeFirstProperty()                               INLINE ( ::getValue( "CodigoPropiedad1" ) )
   METHOD getCodeSecondProperty()                              INLINE ( ::getValue( "CodigoPropiedad2" ) )
   METHOD getValueFirstProperty()                              INLINE ( ::getValue( "ValorPropiedad1" ) )
   METHOD getValueSecondProperty()                             INLINE ( ::getValue( "ValorPropiedad2" ) )
   METHOD getNameFirstProperty()                               INLINE ( nombrePropiedad( ::getCodeFirstProperty(), ::getValueFirstProperty(), ::getView() ) )
   METHOD getNameSecondProperty()                              INLINE ( nombrePropiedad( ::getCodeSecondProperty(), ::getValueSecondProperty(), ::getView() ) )
   METHOD getLote()                                            INLINE ( ::getValue( "Lote" ) )
   METHOD getCodeProvider()                                    INLINE ( ::getValue( "CodigoArticuloProveedor" ) ) 
  
   METHOD getBoxes()                                           INLINE ( ::getValue( "Cajas" ) )
   METHOD setBoxes( Boxes )                                    INLINE ( ::setValue( "Cajas", Boxes ) )
   METHOD getUnits()                                           INLINE ( ::getValue( "Unidades" ) )
   METHOD setUnits( Units )                                    INLINE ( ::setValue( "Unidades", Units ) )

   METHOD getTotalUnits()
   METHOD getMeasurementUnit()                                 INLINE ( ::getValue( "UnidadMedicion" ) )
   METHOD getPrice()                                           INLINE ( ::getValue( "PrecioVenta" ) )
   METHOD getNetPrice()

   METHOD getPercentageDiscount()                              INLINE ( ::getValue( "DescuentoPorcentual" ) )
   METHOD getPercentagePromotion()                             INLINE ( ::getValue( "DescuentoPromocion" ) )
   METHOD getPercentageTax()                                   INLINE ( ::getValue( "PorcentajeImpuesto" ) )
   METHOD getMonetaryDiscount()                                INLINE ( ::getValue( "DescuentoLineal", 0 ) )

   METHOD getTipoIva()                                         INLINE ( ::getValue( "TipoIva" ) )
   METHOD getPrecioVenta()                                     INLINE ( round( ::getValue(  "PrecioVenta" ), nDouDiv() ) )
   METHOD getPortes()                                          INLINE ( ::getValue( "Portes", 0 ) )
   
   METHOD getUnidades()                                        INLINE ( ::getValue( "Unidades" ) )
   METHOD setUnidades( nUnidades )                             INLINE ( ::setValue( "Unidades", nUnidades ) )

   METHOD getDescuento()                                       INLINE ( ::getValue( "Descuento" ) )
   METHOD getRecargoEquivalencia()                             INLINE ( ::getValue( "RecargoEquivalencia" ) )

   METHOD getDescuentoPorcentual()                             INLINE ( ::getValue( "DescuentoPorcentual", 0 ) )
   METHOD getDescuentoPromocion()                              INLINE ( ::getValue( "DescuentoPromocion", 0 ) )

   METHOD isSpecialTaxInclude()                                INLINE ( ::getValue( "LineaImpuestoIncluido", .f. ) )
   METHOD isVolumenSpecialTax()                                INLINE ( ::getValue( "VolumenImpuestosEspeciales", .f. ) )
   METHOD getSpecialTax()                                      INLINE ( ::getValue( "ImporteImpuestoEspecial", 0 ) )

   METHOD getBruto()
   METHOD getBase() 
   METHOD getTotalSpecialTax()  

   METHOD getVolumen()                                         INLINE ( ::getValue( "Volumen", 0 ) )
   METHOD getPuntoVerde()                                      INLINE ( ::getValue( "PuntoVerde", 0 ) )

   METHOD getHeaderClient()                                    INLINE ( ::oDocumentHeader:getClient() )
   METHOD getHeaderClientName()                                INLINE ( ::oDocumentHeader:getClientName() )
   METHOD getHeaderDate()                                      INLINE ( ::oDocumentHeader:getDate() )

END CLASS

//---------------------------------------------------------------------------//

METHOD newBuildDictionary( oSender ) CLASS DocumentLine

   ::new( oSender )

   ::setDictionary( D():getHashFromAlias( oSender:getLineAlias(), oSender:getLineDictionary() ) )

   ::oDocumentHeader    := DocumentHeader():newBuildDictionary( oSender )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD getTotalUnits() CLASS DocumentLine

   local totalUnidades  := notCaja( ::getBoxes() )
   totalUnidades        *= notCero( ::getUnidades() )
   totalUnidades        *= notCero( ::getValue( "UnidadesKit" ) )
   totalUnidades        *= notCero( ::getValue( "Medicion1" ) )
   totalUnidades        *= notCero( ::getValue( "Medicion2" ) )
   totalUnidades        *= notCero( ::getValue( "Medicion3" ) )

Return ( totalUnidades )

//---------------------------------------------------------------------------//

METHOD getBruto() CLASS DocumentLine

   local Bruto       := ::getNetPrice() * ::getTotalUnits()

   if ::getPortes() != 0
      Bruto          += ::getPortes() * ::getTotalUnits()
   endif

   Bruto             += ::getTotalSpecialTax()

   /*
   if ::oSender:isPuntoVerde()    
      Total          += ::getPuntoVerde() * ::getTotalUnits()
   end if 
   */

Return ( Bruto )

//---------------------------------------------------------------------------//

METHOD getNetPrice() CLASS DocumentLine

   local Price       := ::getPrice()

   Price             -= ::getMonetaryDiscount()

   if ::getPercentageDiscount() != 0
      Price          -= Price * ::getPercentageDiscount() / 100
   end if 

   if ::getPercentagePromotion() != 0
      Price          -= Price * ::getPercentagePromotion() / 100
   end if 

Return ( Price )

//---------------------------------------------------------------------------//

METHOD getBase() CLASS DocumentLine

   local Base        := ::getNetPrice()

   if !empty( ::oSender ) .and. ( ::oSender:hGetMaster( "PorcentajeDescuento1" ) != 0 )
      Base           -= Base * ::oSender:hGetMaster( "PorcentajeDescuento1" ) / 100
   end if 

   Base              *= ::getTotalUnits()

Return ( Base )

//---------------------------------------------------------------------------//

METHOD getTotalSpecialTax() CLASS DocumentLine
   
   Local specialTax  := 0

   if ::isSpecialTaxInclude()
      Return ( specialTax )
   end if 

   if ::isVolumenSpecialTax()
      specialTax     := ::getSpecialTax() * notCero( ::getVolumen() )
   else
      specialTax     := ::getSpecialTax()
   end if

Return ( specialTax )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SupplierDeliveryNoteDocumentLine FROM DocumentLine

   METHOD newFromDictionary( oSender, hDictionary )

   METHOD setUnitsReceived()                                   INLINE ( ::setValue( "UnitsReceived", nUnidadesRecibidasPedPrv( ::getDocumentId(), ::getCode(), ::getValueFirstProperty(), ::getValueSecondProperty(), ::getCodeProvider(), D():AlbaranesProveedoresLineas( ::getView() ) ) ) )
   METHOD getUnitsReceived()                                   INLINE ( ::getValue( "UnitsReceived" ) )
   METHOD getUnitsAwaitingReception()                          INLINE ( ::getTotalUnits() - ::getUnitsReceived() )

END CLASS

//---------------------------------------------------------------------------//

METHOD newFromDictionary( oSender, hDictionary ) CLASS supplierDeliveryNoteDocumentLine

   ::Super():newFromDictionary( oSender, hDictionary )

   ::setUnitsReceived()

Return ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ClientDeliveryNoteDocumentLine FROM DocumentLine

   METHOD newBuildDictionary( oSender )

   METHOD setUnitsProvided()            
   METHOD getUnitsProvided()           INLINE ( ::getValue( "UnitsProvided" ) )
   METHOD getUnitsAwaitingProvided()   INLINE ( ::getTotalUnits() - ::getUnitsProvided() )

END CLASS

//---------------------------------------------------------------------------//

METHOD newBuildDictionary( oSender ) CLASS ClientDeliveryNoteDocumentLine

   ::Super():newBuildDictionary( oSender )

   ::setUnitsProvided()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD setUnitsProvided()

   local nUnitsProvided    := nUnidadesRecibidasAlbaranesClientesNoFacturados( ::getDocumentId(), ::getCode(), ::getCodeFirstProperty(), ::getCodeSecondProperty(), ::getValueFirstProperty(), ::getValueSecondProperty(), D():AlbaranesClientesLineas( ::getView() ) )
   nUnitsProvided          += nUnidadesRecibidasFacturasClientes( ::getDocumentId(), ::getCode(), ::getCodeFirstProperty(), ::getCodeSecondProperty(), ::getValueFirstProperty(), ::getValueSecondProperty(), D():FacturasClientesLineas( ::getView() ) )

   ::setValue( "UnitsProvided", nUnitsProvided )

Return ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS DictionaryDocumentLine FROM DocumentLine

   METHOD new( oSender, hDictionary )

   METHOD getRecno()                                           INLINE ( 0 )

   METHOD getValueMaster()                                     INLINE ( ::oSender:hDictionaryMaster )

   METHOD hGetMaster( key )                                    INLINE ( hGet( ::getValueMaster(), key ) )
   METHOD hSetMaster( key, value )                             INLINE ( hSet( ::getValueMaster(), key, value ) )

   METHOD hGetDetail( key )                                    INLINE ( hGet( ::oSender:oDocumentLineTemporal:hDictionary, key ) )
   METHOD hSetDetail( key, value )                             INLINE ( hSet( ::oSender:oDocumentLineTemporal:hDictionary, key, value ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD new( oSender, hDictionary ) CLASS DictionaryDocumentLine

   ::oSender            := oSender

   ::setDictionary( hDictionary )

Return ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS AliasDocumentLine FROM DocumentLine

   METHOD getAlias()                                           INLINE ( ::oSender:getLineAlias() )
   METHOD getDictionary()                                      INLINE ( ::oSender:getLineDictionary() )

   METHOD getValue( key, uDefault )                            INLINE ( D():getFieldFromAliasDictionary( key, ::getAlias(), ::getDictionary(), uDefault ) )
   METHOD setValue( key, value )                               INLINE ( hSet( ::hDictionary, key, value ) )

END CLASS

//---------------------------------------------------------------------------//

