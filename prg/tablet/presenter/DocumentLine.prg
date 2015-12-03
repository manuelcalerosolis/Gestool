#include "FiveWin.Ch"
#include "Factu.ch" 
 
CLASS DocumentLine 

   DATA oSender
   DATA hDictionary

   METHOD new( hDictionary )

   METHOD getDictionaryMaster()                                INLINE ( ::oSender:hDictionaryMaster )

   METHOD hSetMaster( key, value )                             INLINE ( hSet( ::getDictionaryMaster(), key, value ) )
   METHOD hGetMaster( key )                                    INLINE ( hGet( ::getDictionaryMaster(), key ) )

   METHOD getDictionary( key )                                 INLINE ( hGet( ::hDictionary, key ) )
   METHOD setDictionary( key, value )                          INLINE ( hSet( ::hDictionary, key, value ) )

   METHOD hSetDetail( key, value )                             INLINE ( hSet( ::oSender:oDocumentLineTemporal:hDictionary, key, value ) )
   METHOD hGetDetail( key )                                    INLINE ( hGet( ::oSender:oDocumentLineTemporal:hDictionary, key ) )

   METHOD totalUnidades()
   METHOD Total()
   METHOD Impuesto()  
   METHOD Importe()

   METHOD getDivisa()                                          INLINE ( hGet( ::getDictionaryMaster(), "Divisa" ) ) 

   METHOD getSerie()                                           INLINE ( ::getDictionary(  "Serie" ) )
   METHOD setSerieMaster()                                     INLINE ( hSet( ::hDictionary, "Serie", ::oSender:getSerie() ) )

   METHOD getNumero()                                          INLINE ( ::getDictionary( "Numero" ) )
   METHOD setNumeroMaster()                                    INLINE ( ::setDictionary( "Numero", ::oSender:getNumero() ) )

   METHOD getSufijo()                                          INLINE ( ::getDictionary( "Sufijo" ) )
   METHOD setSufijoMaster()                                    INLINE ( ::setDictionary( "Sufijo", ::oSender:getSufijo() ) )

   METHOD getAlmacen()                                         INLINE ( ::getDictionary( "Almacen" ) )
   METHOD setAlmacen( cAlmacen )                               INLINE ( ::setDictionary( "Almacen", cAlmacen ) )
   METHOD setAlmacenMaster()                                   INLINE ( if( empty( ::getAlmacen() ), ::setAlmacen( ::oSender:getAlmacen() ), ) )

   METHOD getNumeroLinea()                                     INLINE ( ::getDictionary( "NumeroLinea" ) )
   METHOD setNumeroLinea( NumeroLinea )                        INLINE ( ::setDictionary( "NumeroLinea", NumeroLinea ) )
   METHOD setPosicionImpresion( PosicionImpresion)             INLINE ( ::setDictionary( "PosicionImpresion", PosicionImpresion ) )

   METHOD getArticulo()                                        INLINE ( ::getDictionary( "Articulo" ) )
   METHOD getDescripcionArticulo()                             INLINE ( ::getDictionary( "DescripcionArticulo" ) )
   METHOD getPorcentajeImpuesto()                              INLINE ( ::getDictionary( "PorcentajeImpuesto" ) )

   METHOD getTipoIva()                                         INLINE ( ::getDictionary( "TipoIva" ) )
   METHOD getDescuentoLineal()                                 INLINE ( ::getDictionary( "DescuentoLineal" ) )
   METHOD getPrecioVenta()                                     INLINE ( Round( ::getDictionary(  "PrecioVenta" ), nDouDiv() ) )
   METHOD getPortes()                                          INLINE ( ::getDictionary( "Portes" ) )
   METHOD getCajas()                                           INLINE ( ::getDictionary( "Cajas" ) )
   METHOD getUnidades()                                        INLINE ( ::getDictionary( "Unidades" ) )
   METHOD getDescuento()                                       INLINE ( ::getDictionary( "Descuento" ) )
   METHOD getRecargoEquivalencia()                             INLINE ( ::getDictionary( "RecargoEquivalencia" ) )

   METHOD getDescuentoPorcentual()                             INLINE ( ::getDictionary( "DescuentoPorcentual" ) )
   METHOD getDescuentoPromocion()                              INLINE ( ::getDictionary( "DescuentoPromocion" ) )

   METHOD isLineaImpuestoIncluido()                            INLINE ( ::getDictionary( "LineaImpuestoIncluido" ) )
   METHOD isVolumenImpuestosEspeciales()                       INLINE ( ::getDictionary( "VolumenImpuestosEspeciales" ) )

   METHOD getImporteImpuestoEspecial()                         INLINE ( ::getDictionary( "ImporteImpuestoEspecial" ) )
   METHOD getVolumen()                                         INLINE ( ::getDictionary( "Volumen" ) )
   METHOD getPuntoVerde()                                      INLINE ( ::getDictionary( "PuntoVerde" ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD new( hDictionary, oSender ) CLASS DocumentLine

   ::hDictionary        := hDictionary
   ::oSender            := oSender

Return ( Self )

//---------------------------------------------------------------------------//

METHOD totalUnidades() CLASS DocumentLine

   local totalUnidades  := 0

   totalUnidades        := notCaja( ::getCajas() )
   totalUnidades        *= ::getUnidades()
   totalUnidades        *= notCero( ::getDictionary( "UnidadesKit" ) )
   totalUnidades        *= notCero( ::getDictionary( "Medicion1" ) )
   totalUnidades        *= notCero( ::getDictionary( "Medicion2" ) )
   totalUnidades        *= notCero( ::getDictionary( "Medicion3" ) )

Return ( totalUnidades )

//---------------------------------------------------------------------------//

METHOD Total()   CLASS DocumentLine

   local Total          := ::Importe() * ::totalUnidades()

   Total                += ::Impuesto()

   if ::oSender:isPuntoVerde()    
      Total             += ::getPuntoVerde() * ::totalUnidades()
   end if 

   if ::getPortes()  != 0
      Total             += ::getPortes() * ::totalUnidades
   endif

Return ( Total )

//---------------------------------------------------------------------------//

METHOD Importe() CLASS DocumentLine

   local totalImporte   := ::getPrecioVenta()
   totalImporte         -= ::getDescuentoLineal()

   if ::getDescuentoPorcentual() != 0
      totalImporte      -= totalImporte * ::getDescuentoPorcentual() / 100
   end if 

   if ::getDescuentoPromocion() != 0
      totalImporte      -= totalImporte * ::getDescuentoPromocion() / 100
   end if 

Return ( totalImporte )

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


CLASS AliasDocumentLine 

   DATA oSender
   DATA hDictionary
   DATA cAlias

   METHOD setAlias( cAlias )                                   INLINE ( ::cAlias := cAlias )
   METHOD getAlias()                                           INLINE ( ::cAlias )

   METHOD getDictionary()                                      INLINE ( ::hDictionary )
   METHOD setDictionary( hDictionary )                         INLINE ( ::hDictionary := hDictionary )

   METHOD new( hDictionary, cAlias )

   METHOD getDictionary( key )                                 INLINE ( D():getFieldFromAliasDictionary( key, ::getAlias(), ::getDictionary() ) ) )
   METHOD setDictionary( key, value )                          INLINE ( hSet( ::hDictionary, key, value ) )

   METHOD getCode()                                            INLINE ( ::getDictionary( "Articulo" ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD new( oSender, hDictionary, cAlias ) CLASS AliasDocumentLine

   ::oSender            := oSender
   ::hDictionary        := hDictionary
   ::cAlias             := cAlias

Return ( Self )

//---------------------------------------------------------------------------//

