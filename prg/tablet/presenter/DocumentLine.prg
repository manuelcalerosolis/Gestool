#include "FiveWin.Ch"
#include "Factu.ch" 
 
CLASS DocumentLine 

   DATA oSender
   DATA hDictionary

   METHOD new( hDictionary )

   METHOD getDictionaryMaster()                                INLINE ( ::oSender:hDictionaryMaster )

   METHOD hSetMaster( key, value )                             INLINE ( hSet( ::getDictionaryMaster(), key, value ) )
   METHOD hGetMaster( key )                                    INLINE ( hGet( ::getDictionaryMaster(), key ) )

   METHOD getValue( key )                                      INLINE ( hGet( ::hDictionary, key ) )
   METHOD setValue( key, value )                               INLINE ( hSet( ::hDictionary, key, value ) )

   METHOD hSetDetail( key, value )                             INLINE ( hSet( ::oSender:oDocumentLineTemporal:hDictionary, key, value ) )
   METHOD hGetDetail( key )                                    INLINE ( hGet( ::oSender:oDocumentLineTemporal:hDictionary, key ) )

   METHOD totalUnidades()
   METHOD Total()
   METHOD Impuesto()  
   METHOD Importe()

   METHOD getDivisa()                                          INLINE ( hGet( ::getDictionaryMaster(), "Divisa" ) ) 

   METHOD getSerie()                                           INLINE ( ::getValue(  "Serie" ) )
   METHOD setSerieMaster()                                     INLINE ( hSet( ::hDictionary, "Serie", ::oSender:getSerie() ) )

   METHOD getNumero()                                          INLINE ( ::getValue( "Numero" ) )
   METHOD setNumeroMaster()                                    INLINE ( ::setValue( "Numero", ::oSender:getNumero() ) )

   METHOD getSufijo()                                          INLINE ( ::getValue( "Sufijo" ) )
   METHOD setSufijoMaster()                                    INLINE ( ::setValue( "Sufijo", ::oSender:getSufijo() ) )

   METHOD getAlmacen()                                         INLINE ( ::getValue( "Almacen" ) )
   METHOD setAlmacen( cAlmacen )                               INLINE ( ::setValue( "Almacen", cAlmacen ) )
   METHOD setAlmacenMaster()                                   INLINE ( if( empty( ::getAlmacen() ), ::setAlmacen( ::oSender:getAlmacen() ), ) )

   METHOD getNumeroLinea()                                     INLINE ( ::getValue( "NumeroLinea" ) )
   METHOD setNumeroLinea( NumeroLinea )                        INLINE ( ::setValue( "NumeroLinea", NumeroLinea ) )
   METHOD setPosicionImpresion( PosicionImpresion)             INLINE ( ::setValue( "PosicionImpresion", PosicionImpresion ) )

   METHOD getArticulo()                                        INLINE ( ::getValue( "Articulo" ) )
   METHOD getDescripcionArticulo()                             INLINE ( ::getValue( "DescripcionArticulo" ) )
   METHOD getPorcentajeImpuesto()                              INLINE ( ::getValue( "PorcentajeImpuesto" ) )

   METHOD getTipoIva()                                         INLINE ( ::getValue( "TipoIva" ) )
   METHOD getDescuentoLineal()                                 INLINE ( ::getValue( "DescuentoLineal" ) )
   METHOD getPrecioVenta()                                     INLINE ( Round( ::getValue(  "PrecioVenta" ), nDouDiv() ) )
   METHOD getPortes()                                          INLINE ( ::getValue( "Portes" ) )
   METHOD getCajas()                                           INLINE ( ::getValue( "Cajas" ) )
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

METHOD new( hDictionary, oSender ) CLASS DocumentLine

   ::hDictionary        := hDictionary
   ::oSender            := oSender

Return ( Self )

//---------------------------------------------------------------------------//

METHOD totalUnidades() CLASS DocumentLine

   local totalUnidades  := 0

   totalUnidades        := notCaja( ::getCajas() )
   totalUnidades        *= ::getUnidades()
   totalUnidades        *= notCero( ::getValue( "UnidadesKit" ) )
   totalUnidades        *= notCero( ::getValue( "Medicion1" ) )
   totalUnidades        *= notCero( ::getValue( "Medicion2" ) )
   totalUnidades        *= notCero( ::getValue( "Medicion3" ) )

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
   
   METHOD new()

   METHOD setAlias( cAlias )                                   INLINE ( ::cAlias := cAlias )
   METHOD getAlias()                                           INLINE ( ::cAlias )

   METHOD getDictionary()                                      INLINE ( ::hDictionary )
   METHOD setDictionary( hDictionary )                         INLINE ( ::hDictionary := hDictionary )

   METHOD getValue( key )                                      INLINE ( D():getFieldFromAliasDictionary( key, ::getAlias(), ::getDictionary() ) )
   METHOD setValue( key, value )                               INLINE ( hSet( ::hDictionary, key, value ) )

   METHOD getCode()                                            INLINE ( ::getValue( "Articulo" ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD new( oSender, hDictionary, cAlias ) CLASS AliasDocumentLine

   ::oSender            := oSender
   ::hDictionary        := hDictionary
   ::cAlias             := cAlias

Return ( Self )

//---------------------------------------------------------------------------//

