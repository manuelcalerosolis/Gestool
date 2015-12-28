#include "FiveWin.Ch"
#include "Factu.ch" 
 
CLASS DocumentLine 

   DATA oSender
   DATA hDictionary

   DATA selectLine                                             INIT .f.

   METHOD new()
   METHOD newFromDictionary()
   METHOD getView()                                            INLINE ( ::oSender:getView() )

   METHOD getDictionary()                                      INLINE ( ::hDictionary )
   METHOD setDictionary( hDictionary )                         INLINE ( ::hDictionary := hDictionary )

   METHOD getValue( key, uDefault )                            INLINE ( hGetDefault( ::hDictionary, key, uDefault ) )
   METHOD setValue( key, value )                               INLINE ( hSet( ::hDictionary, key, value ) )

   METHOD select()                                             INLINE ( ::selectLine   := .t. )                           
   METHOD unSelect()                                           INLINE ( ::selectLine   := .f. )                           
   METHOD toogleSelect()                                       INLINE ( ::selectLine   := !::selectLine )                           

   METHOD isSelect()                                           INLINE ( ::selectLine )

   METHOD getDivisa()                                          INLINE ( hGet( ::getValueMaster(), "Divisa" ) ) 

   METHOD getSerie()                                           INLINE ( ::getValue( "Serie" ) )
   METHOD setSerieMaster()                                     INLINE ( hSet( ::hDictionary, "Serie", ::oSender:getSerie() ) )

   METHOD getNumero()                                          INLINE ( ::getValue( "Numero" ) )
   METHOD setNumeroMaster()                                    INLINE ( ::setValue( "Numero", ::oSender:getNumero() ) )

   METHOD getSufijo()                                          INLINE ( ::getValue( "Sufijo" ) )
   METHOD setSufijoMaster()                                    INLINE ( ::setValue( "Sufijo", ::oSender:getSufijo() ) )

   METHOD getDocumentId()                                      INLINE ( ::getValue( "Serie" ) + str( ::getValue( "Numero" ) ) + ::getValue( "Sufijo" ) )
   METHOD getNumeroDocumento()                                 INLINE ( ::getValue( "Serie" ) + alltrim( str( ::getValue( "Numero" ) ) ) )

   METHOD getCode()                                            INLINE ( ::getValue( "Articulo" ) )

   METHOD getStore()                                           INLINE ( ::getValue( "Almacen" ) )
   METHOD setStore( cStore )                                   INLINE ( ::setValue( "Almacen", cStore ) )
   METHOD setStoreMaster()                                     INLINE ( if( empty( ::getStore() ), ::setStore( ::oSender:getStore() ), ) )

   METHOD getNumeroLinea()                                     INLINE ( ::getValue( "NumeroLinea" ) )
   METHOD setNumeroLinea( NumeroLinea )                        INLINE ( ::setValue( "NumeroLinea", NumeroLinea ) )
   METHOD setPosicionImpresion( PosicionImpresion)             INLINE ( ::setValue( "PosicionImpresion", PosicionImpresion ) )

   METHOD getProductId()                                       INLINE ( ::getValue( "Articulo" ) )
   METHOD getDescription()                                     INLINE ( if(   !empty( ::getCode() ),;
                                                                              ::getValue( "DescripcionArticulo" ),;
                                                                              ::getValue( "DescripcionAmpliada" ) ) )
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

END CLASS

//---------------------------------------------------------------------------//

METHOD new( oSender ) CLASS DocumentLine

   ::oSender            := oSender

Return ( Self )

//---------------------------------------------------------------------------//

METHOD newFromDictionary( oSender, hDictionary ) CLASS DocumentLine

   ::new( oSender )

   ::setDictionary( hDictionary )

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

   local Total       := ::getNetPrice()
   Total             *= ::getTotalUnits()
   Total             += ::getTotalSpecialTax()

   if ::getPortes() != 0
      Total          += ::getPortes() * ::getTotalUnits()
   endif
/*
   if ::oSender:isPuntoVerde()    
      Total          += ::getPuntoVerde() * ::getTotalUnits()
   end if 
*/
Return ( Total )

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

CLASS supplierDeliveryNoteDocumentLine FROM DocumentLine

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

   DATA cAlias
   
   METHOD getAlias()                                           INLINE ( ::oSender:getLineAlias() )
   METHOD getDictionary()                                      INLINE ( ::oSender:getLineDictionary() )

   METHOD getValue( key, uDefault )                            INLINE ( D():getFieldFromAliasDictionary( key, ::getAlias(), ::getDictionary(), uDefault ) )
   METHOD setValue( key, value )                               INLINE ( hSet( ::hDictionary, key, value ) )

   METHOD getRecno()                                           INLINE ( ( ::getAlias() )->( recno() ) )
   METHOD eof()                                                INLINE ( ( ::getAlias() )->( eof() ) )

   METHOD setLinesScope( Id )                                  INLINE ( ( ::getAlias() )->( ordscope( 0, Id ) ),;
                                                                        ( ::getAlias() )->( ordscope( 1, Id ) ),;
                                                                        ( ::getAlias() )->( dbgotop() ) ) 
   METHOD quitLinesScope()                                     INLINE ( ::setLinesScope( nil ) )

END CLASS

//---------------------------------------------------------------------------//

