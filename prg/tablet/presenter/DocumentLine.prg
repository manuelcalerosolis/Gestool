#include "FiveWin.Ch"
#include "Factu.ch" 
 
CLASS DocumentLine 

   DATA oSender
   DATA hDictionary

   METHOD new()

   METHOD getDictionary()                                      INLINE ( ::hDictionary )
   METHOD setDictionary( hDictionary )                         INLINE ( ::hDictionary := hDictionary )

   METHOD getValue( key )                                      VIRTUAL
   METHOD setValue( key, value )                               VIRTUAL

   METHOD getTotalUnits()
   METHOD getTotal()
   METHOD Impuesto()  
   METHOD getPrice()

   METHOD getDivisa()                                          INLINE ( hGet( ::getValueMaster(), "Divisa" ) ) 

   METHOD getSerie()                                           INLINE ( ::getValue(  "Serie" ) )
   METHOD setSerieMaster()                                     INLINE ( hSet( ::hDictionary, "Serie", ::oSender:getSerie() ) )

   METHOD getNumero()                                          INLINE ( ::getValue( "Numero" ) )
   METHOD setNumeroMaster()                                    INLINE ( ::setValue( "Numero", ::oSender:getNumero() ) )

   METHOD getSufijo()                                          INLINE ( ::getValue( "Sufijo" ) )
   METHOD setSufijoMaster()                                    INLINE ( ::setValue( "Sufijo", ::oSender:getSufijo() ) )

   METHOD getCode()                                            INLINE ( ::getValue( "Articulo" ) )

   METHOD getStore()                                           INLINE ( ::getValue( "Almacen" ) )
   METHOD setStore( cStore )                                   INLINE ( ::setValue( "Almacen", cStore ) )
   METHOD setStoreMaster()                                     INLINE ( if( empty( ::getStore() ), ::setStore( ::oSender:getStore() ), ) )

   METHOD getNumeroLinea()                                     INLINE ( ::getValue( "NumeroLinea" ) )
   METHOD setNumeroLinea( NumeroLinea )                        INLINE ( ::setValue( "NumeroLinea", NumeroLinea ) )
   METHOD setPosicionImpresion( PosicionImpresion)             INLINE ( ::setValue( "PosicionImpresion", PosicionImpresion ) )

   METHOD getArticulo()                                        INLINE ( ::getValue( "Articulo" ) )
   METHOD getDescription()                                     INLINE ( if(   !empty( ::getCode() ),;
                                                                              ::getValue( "DescripcionArticulo" ),;
                                                                              ::getValue( "DescripcionAmpliada" ) ) )
   METHOD getCodeFirstProperty()                               INLINE ( ::getValue( "CodigoPropiedad1" ) )
   METHOD getCodeFirstProperty()                               INLINE ( ::getValue( "CodigoPropiedad1" ) )
   METHOD getCodeSecondProperty()                              INLINE ( ::getValue( "CodigoPropiedad2" ) )
   METHOD getValueFirstProperty()                              INLINE ( ::getValue( "ValorPropiedad1" ) )
   METHOD getValueSecondProperty()                             INLINE ( ::getValue( "ValorPropiedad2" ) )
   METHOD getNameFirstProperty()                               INLINE ( nombrePropiedad( ::getCodeFirstProperty(), ::getValueFirstProperty(), ::oSender:nView ) )
   METHOD getNameSecondProperty()                              INLINE ( nombrePropiedad( ::getCodeSecondProperty(), ::getValueSecondProperty(), ::oSender:nView ) )
   METHOD getLote()                                            INLINE ( ::getValue( "Lote" ) )
  
   METHOD getBoxes()                                           INLINE ( ::getValue( "Cajas" ) )
   METHOD getUnits()                                           INLINE ( ::getValue( "Unidades" ) )
   METHOD getTotalUnits()
   METHOD getMeasurementUnit()                                 INLINE ( ::getValue( "UnidadMedicion" ) )

   METHOD getPercentageDiscount()                              INLINE ( ::getValue( "DescuentoPorcentual" ) )
   METHOD getPercentagePromotion()                             INLINE ( ::getValue( "DescuentoPromocion" ) )
   METHOD getPercentageTax()                                   INLINE ( ::getValue( "PorcentajeImpuesto" ) )
   METHOD getMonetaryDiscount()                                INLINE ( ::getValue( "DescuentoLineal" ) )

   METHOD getTipoIva()                                         INLINE ( ::getValue( "TipoIva" ) )
   METHOD getPrecioVenta()                                     INLINE ( Round( ::getValue(  "PrecioVenta" ), nDouDiv() ) )
   METHOD getPortes()                                          INLINE ( ::getValue( "Portes" ) )
   METHOD getUnidades()                                        INLINE ( ::getValue( "Unidades" ) )
   METHOD getDescuento()                                       INLINE ( ::getValue( "Descuento" ) )
   METHOD getRecargoEquivalencia()                             INLINE ( ::getValue( "RecargoEquivalencia" ) )

   METHOD getDescuentoPorcentual()                             INLINE ( ::getValue( "DescuentoPorcentual" ) )
   METHOD getDescuentoPromocion()                              INLINE ( ::getValue( "DescuentoPromocion" ) )

   METHOD isLineaImpuestoIncluido()                            INLINE ( ::getValue( "LineaImpuestoIncluido" ) )
   METHOD isVolumenImpuestosEspeciales()                       INLINE ( ::getValue( "VolumenImpuestosEspeciales" ) )

   METHOD getImporteImpuestoEspecial()                         INLINE ( ::getValue( "ImporteImpuestoEspecial" ) )
   METHOD getVolumen()                                         INLINE ( ::getValue( "Volumen" ) )
   METHOD getPuntoVerde()                                      INLINE ( ::getValue( "PuntoVerde" ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD new( oSender ) CLASS DocumentLine

   ::oSender            := oSender

Return ( Self )

//---------------------------------------------------------------------------//

METHOD getTotalUnits() CLASS DocumentLine

   local totalUnidades  

   totalUnidades        := notCaja( ::getBoxes() )
   totalUnidades        *= notCero( ::getUnidades() )
   totalUnidades        *= notCero( ::getValue( "UnidadesKit" ) )
   totalUnidades        *= notCero( ::getValue( "Medicion1" ) )
   totalUnidades        *= notCero( ::getValue( "Medicion2" ) )
   totalUnidades        *= notCero( ::getValue( "Medicion3" ) )

Return ( totalUnidades )

//---------------------------------------------------------------------------//

METHOD getTotal()   CLASS DocumentLine

   local Total          := ::getPrice()

   Total                *= ::getTotalUnits()

   Total                += ::Impuesto()

   if ::oSender:isPuntoVerde()    
      Total             += ::getPuntoVerde() * ::getTotalUnits()
   end if 

   if ::getPortes()  != 0
      Total             += ::getPortes() * ::getTotalUnits()
   endif

Return ( Total )

//---------------------------------------------------------------------------//

METHOD getPrice() CLASS DocumentLine

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

METHOD Impuesto() CLASS DocumentLine
   
   Local Impuesto := 0

   if !( ::isLineaImpuestoIncluido() )

      if ::isVolumenImpuestosEspeciales()
         Return ( ::getImporteImpuestoEspecial * NotCero( ::getVolumen ) )
      else
         Return ( ::getImporteImpuestoEspecial )
      endif

   endif

Return ( Impuesto )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS DictionaryDocumentLine FROM DocumentLine

   METHOD new( oSender, hDictionary )

   METHOD getValueMaster()                                     INLINE ( ::oSender:hDictionaryMaster )

   METHOD hSetMaster( key, value )                             INLINE ( hSet( ::getValueMaster(), key, value ) )
   METHOD hGetMaster( key )                                    INLINE ( hGet( ::getValueMaster(), key ) )

   METHOD getValue( key )                                      INLINE ( hGet( ::hDictionary, key ) )
   METHOD setValue( key, value )                               INLINE ( hSet( ::hDictionary, key, value ) )

   METHOD hSetDetail( key, value )                             INLINE ( hSet( ::oSender:oDocumentLineTemporal:hDictionary, key, value ) )
   METHOD hGetDetail( key )                                    INLINE ( hGet( ::oSender:oDocumentLineTemporal:hDictionary, key ) )

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
   
   METHOD setAlias( cAlias )                                   INLINE ( ::cAlias := cAlias )
   METHOD getAlias()                                           INLINE ( ::cAlias )

   METHOD getValue( key )                                      INLINE ( D():getFieldFromAliasDictionary( key, ::getAlias(), ::getDictionary() ) )
   METHOD setValue( key, value )                               INLINE ( hSet( ::hDictionary, key, value ) )

END CLASS

//---------------------------------------------------------------------------//

