#include "Factu.ch" 
#include "Fivewin.ch"
 
CLASS DocumentLine FROM DocumentBase

   DATA oDocumentHeader

   METHOD newBuildDictionary( oSender )

   METHOD getClone()                                           INLINE ( oClone( Self ) )

   METHOD setSerieMaster( hDictionary )                        INLINE ( ::setValueFromDictionary( hDictionary, "Serie" ) )
   METHOD setNumeroMaster( hDictionary )                       INLINE ( ::setValueFromDictionary( hDictionary, "Numero" ) )
   METHOD setSufijoMaster( hDictionary )                       INLINE ( ::setValueFromDictionary( hDictionary, "Sufijo" ) )
   METHOD setAlmacenMaster( hDictionary )                      

   METHOD setFechaMaster( hDictionary )                        INLINE ( ::setValueFromDictionary( hDictionary, "Fecha" ) ) 
   METHOD setHoraMaster( hDictionary )                         INLINE ( ::setValueFromDictionary( hDictionary, "Hora" ) ) 

   METHOD setClient( Client )                                  INLINE ( ::setValue( "Cliente", Client ) )
   METHOD getClient()                                          INLINE ( ::getValue( "Cliente" ) )

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
   
   METHOD getCajas()                                           INLINE ( ::getValue( "Cajas" ) )

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

   local totalUnidades  := 0

   if empty( ::getDictionary() )
      Return ( totalUnidades )
   end if 

   totalUnidades        := notCaja( ::getBoxes() )
   totalUnidades        *= notCero( ::getUnidades() )
   totalUnidades        *= notCero( ::getValue( "UnidadesKit" ) )
   totalUnidades        *= notCero( ::getValue( "Medicion1" ) )
   totalUnidades        *= notCero( ::getValue( "Medicion2" ) )
   totalUnidades        *= notCero( ::getValue( "Medicion3" ) )

Return ( totalUnidades )

//---------------------------------------------------------------------------//

METHOD getBruto() CLASS DocumentLine

   local Bruto       := 0

   if empty( ::getDictionary() )
      Return ( Bruto )
   end if 

   Bruto             := ::getNetPrice() * ::getTotalUnits()

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

   local Price       := 0

   if empty( ::getDictionary() )
      Return ( Price )
   end if 

   Price             := ::getPrice()

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

   local Base        := 0

   if empty( ::getDictionary() )
      Return ( Base )
   end if 

   Base              := ::getNetPrice()

   if !empty( ::oSender ) .and. ( __objHasMethod( ::oSender, "hGetMaster" ) ) .and. ( ::oSender:hGetMaster( "PorcentajeDescuento1" ) != 0 )
      Base           -= Base * ::oSender:hGetMaster( "PorcentajeDescuento1" ) / 100
   end if 

   Base              *= ::getTotalUnits()

Return ( Base )

//---------------------------------------------------------------------------//

METHOD getTotalSpecialTax() CLASS DocumentLine
   
   Local specialTax  := 0

   if empty( ::getDictionary() )
      Return ( specialTax )
   end if 

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

METHOD setAlmacenMaster( hDictionary )

   if empty( ::getValueFromDictionary( hDictionary, "Almacen" ) )
      Return ( ::setValueFromDictionary( hDictionary, "Almacen" ) )
   end if 

Return ( nil )

//---------------------------------------------------------------------------//
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

CLASS CustomerOrderDocumentLine FROM DocumentLine

   METHOD new( oSender )   CONSTRUCTOR

   METHOD setUnitsReceived()
   METHOD getUnitsReceived()
   METHOD getUnitsAwaitingReception()

   METHOD setCustomerNumberId()

END CLASS

//---------------------------------------------------------------------------//

METHOD new( oSender ) CLASS CustomerOrderDocumentLine

   local hDictionary

   ::Super:new( oSender )

   ::oDocumentHeader    := DocumentHeader():newBuildDictionary( oSender )
   
   hDictionary          := D():getHashFromAlias( oSender:getLineAlias(), oSender:getLineDictionary() )

   ::setDictionary( hDictionary )

   ::setUnitsReceived()

   ::setCustomerNumberId()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD getUnitsReceived() CLASS CustomerOrderDocumentLine

Return ( ::getValue( "UnitsReceived" ) )

//---------------------------------------------------------------------------//

METHOD getUnitsAwaitingReception() CLASS CustomerOrderDocumentLine

Return ( ::getTotalUnits() - ::getUnitsReceived() )

//---------------------------------------------------------------------------//

METHOD setUnitsReceived() CLASS CustomerOrderDocumentLine

   local nUnitsRecived     := nUnidadesRecibidasAlbaranesClientesNoFacturados( ::getDocumentId(), ::getCode(), ::getValueFirstProperty(), ::getValueSecondProperty(), D():AlbaranesClientesLineas( ::getView() ) )
   nUnitsRecived           += nUnidadesRecibidasFacturasClientes( ::getDocumentId(), ::getCode(), ::getValueFirstProperty(), ::getValueSecondProperty(), D():FacturasClientesLineas( ::getView() ) )

   ::setValue( "UnitsReceived", nUnitsRecived )

Return ( nUnitsRecived )

//---------------------------------------------------------------------------//

METHOD setCustomerNumberId() CLASS CustomerOrderDocumentLine

   ::setValue( "NumeroPedido", ::getDocumentId() )

Return ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS DeliveryNoteDocumentLine FROM DocumentLine
   
   METHOD new( oSender )
   
   METHOD setUnitsProvided()

END CLASS

//---------------------------------------------------------------------------//

METHOD new( oSender ) CLASS DeliveryNoteDocumentLine

   local hDictionary

   ::Super:new( oSender )

   ::oDocumentHeader    := DocumentHeader():newBuildDictionary( oSender )
   
   hDictionary          := D():getHashBlankAlbaranesClientesLineas( oSender:nView )

   ::setDictionary( hDictionary )

   ::setUnitsProvided()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD setUnitsProvided() CLASS DeliveryNoteDocumentLine

   local nUnitsProvided    := 0
   
   if ( __objHasMethod( Self, "getView()" ) )

      nUnitsProvided       := nUnidadesRecibidasAlbaranesClientesNoFacturados( ::getDocumentId(), ::getCode(), ::getValueFirstProperty(), ::getValueSecondProperty(), D():AlbaranesClientesLineas( ::getView() ) )
      nUnitsProvided       += nUnidadesRecibidasFacturasClientes( ::getDocumentId(), ::getCode(), ::getValueFirstProperty(), ::getValueSecondProperty(), D():FacturasClientesLineas( ::getView() ) )

      ::setValue( "UnitsProvided", nUnitsProvided )

   end if 

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

   METHOD getValueMaster()                                     INLINE ( ::hDictionaryMaster )

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

