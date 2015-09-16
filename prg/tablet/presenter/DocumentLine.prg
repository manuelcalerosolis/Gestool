#include "FiveWin.Ch"
#include "Factu.ch" 
 
CLASS DocumentLine 

   DATA hDictionary
   DATA hDictionaryMaster

   DATA oSender

   METHOD new( hDictionary )

   METHOD hSetMaster( cField, uValue ) INLINE ( hSet( ::oSender:hDictionaryMaster, cField, uValue ) )
   METHOD hGetMaster( cField )         INLINE ( hGet( ::oSender:hDictionaryMaster, cField ) )

   METHOD hSetDetail( cField, uValue ) INLINE ( hSet( ::oSender:oDocumentLineTemporal:hDictionary, cField, uValue ) )
   METHOD hGetDetail( cField )         INLINE ( hGet( ::oSender:oDocumentLineTemporal:hDictionary, cField ) )

   METHOD totalUnidades()
   METHOD Total()
   METHOD Impuesto()  
   METHOD Importe()

   METHOD getSerie()                                           INLINE ( hGet( ::hDictionary, "Serie" ) )
   METHOD setSerieMaster()                                     INLINE ( hSet( ::hDictionary, "Serie", ::oSender:getSerie() ) )

   METHOD getNumero()                                          INLINE ( hGet( ::hDictionary, "Numero" ) )
   METHOD setNumeroMaster()                                    INLINE ( hSet( ::hDictionary, "Numero", ::oSender:getNumero() ) )

   METHOD getSufijo()                                          INLINE ( hGet( ::hDictionary, "Sufijo" ) )
   METHOD setSufijoMaster()                                    INLINE ( hSet( ::hDictionary, "Sufijo", ::oSender:getSufijo() ) )

   METHOD getAlmacen()                                         INLINE ( hGet( ::hDictionary, "Almacen" ) )
   METHOD setAlmacenMaster()                                   INLINE ( hSet( ::hDictionary, "Almacen", ::oSender:getAlmacen() ) )

   METHOD getNumeroLinea()                                     INLINE ( hGet( ::hDictionary, "NumeroLinea" ) )
   METHOD setNumeroLinea( NumeroLinea )                        INLINE ( hSet( ::hDictionary, "NumeroLinea", NumeroLinea ) )

   METHOD getArticulo()                                        INLINE ( hGet( ::hDictionary, "Articulo" ) )
   METHOD getDescripcionArticulo()                             INLINE ( hGet( ::hDictionary, "DescripcionArticulo" ) )
   METHOD getPorcentajeImpuesto()                              INLINE ( hGet( ::hDictionary, "PorcentajeImpuesto" ) )

   METHOD getTipoIva()                                         INLINE ( hGet( ::hDictionary, "TipoIva" ) )
   METHOD getDescuentoLineal()                                 INLINE ( hGet( ::hDictionary, "DescuentoLineal" ) )
   METHOD getPrecioVenta()                                     INLINE ( Round( hGet( ::hDictionary, "PrecioVenta" ), nDouDiv() ) )
   METHOD getPortes()                                          INLINE ( hGet( ::hDictionary, "Portes" ) )
   METHOD getCajas()                                           INLINE ( hGet( ::hDictionary, "Cajas" ) )
   METHOD getUnidades()                                        INLINE ( hGet( ::hDictionary, "Unidades" ) )
   METHOD getDescuento()                                       INLINE ( hGet( ::hDictionary, "Descuento" ) )
   METHOD getRecargoEquivalencia()                             INLINE ( hGet( ::hDictionary, "RecargoEquivalencia" ) )
   METHOD getDivisa()                                          INLINE ( hGet( ::hDictionaryMaster, "Divisa" ) ) 


   METHOD getDescuentoPorcentual()                             INLINE ( hGet( ::hDictionary, "DescuentoPorcentual" ) )
   METHOD getDescuentoPromocion()                              INLINE ( hGet( ::hDictionary, "DescuentoPromocion" ) )

   METHOD isLineaImpuestoIncluido()                            INLINE ( hGet( ::hDictionary, "LineaImpuestoIncluido" ) )
   METHOD isVolumenImpuestosEspeciales()                       INLINE ( hGet( ::hDictionary, "VolumenImpuestosEspeciales" ) )

   METHOD getImporteImpuestoEspecial()                         INLINE ( hGet( ::hDictionary, "ImporteImpuestoEspecial" ) )
   METHOD getVolumen()                                         INLINE ( hGet( ::hDictionary, "Volumen" ) )
   METHOD getPuntoVerde()                                      INLINE ( hGet( ::hDictionary, "PuntoVerde" ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD new( hDictionary, oSender ) CLASS DocumentLine

   ::oSender            := oSender

   ::hDictionary        := hDictionary
   ::hDictionaryMaster  := oSender:hDictionaryMaster

Return ( Self )

//---------------------------------------------------------------------------//

METHOD totalUnidades() CLASS DocumentLine

   local totalUnidades  := 0

   totalUnidades        := notCaja( ::getCajas() )
   totalUnidades        *= ::getUnidades()
   totalUnidades        *= notCero( hGet( ::hDictionary, "UnidadesKit" ) )
   totalUnidades        *= notCero( hGet( ::hDictionary, "Medicion1" ) )
   totalUnidades        *= notCero( hGet( ::hDictionary, "Medicion2" ) )
   totalUnidades        *= notCero( hGet( ::hDictionary, "Medicion3" ) )

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

Return( Impuesto )

//---------------------------------------------------------------------------//

//---------------------------------------------------------------------------//


