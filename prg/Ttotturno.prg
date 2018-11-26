#include "FiveWin.Ch"
#include "Factu.ch" 

static hBmpOpen
static hBmpClose
static aTrees     := {}
static nLevel     := 0

//----------------------------------------------------------------------------//

CLASS TTotalTurno

   DATA  hBmpDoc

   DATA  oTurno

   DATA  aTotAlbCliContadores    AS ARRAY    INIT {}
   DATA  aTotAlbCliVentas        AS ARRAY    INIT {}

   DATA  aTotPedCliEntregas      AS ARRAY    INIT {}
   DATA  aTotAlbCliEntregas      AS ARRAY    INIT {}
   DATA  aTotEntregas            AS ARRAY    INIT {}

   DATA  aTotFacCliContadores    AS ARRAY    INIT {}
   DATA  aTotFacCliVentas        AS ARRAY    INIT {}

   DATA  aTotRctCliContadores    AS ARRAY    INIT {}
   DATA  aTotRctCliVentas        AS ARRAY    INIT {}

   DATA  aTotTikCliContadores    AS ARRAY    INIT {}
   DATA  aTotTikCliVentas        AS ARRAY    INIT {}

   DATA  aTotDevCliContadores    AS ARRAY    INIT {}
   DATA  aTotDevCliVentas        AS ARRAY    INIT {}

   DATA  aTotTikCliCheques       AS ARRAY    INIT {}

   DATA  aTotAntCliVentas        AS ARRAY    INIT {}
   DATA  aTotAntCliLiquidados    AS ARRAY    INIT {}

   DATA  aTotValCliContadores    AS ARRAY    INIT {}
   DATA  aTotValCliVentas        AS ARRAY    INIT {}
   DATA  aTotValCliLiquidados    AS ARRAY    INIT {}

   DATA  aTotChkCliContadores    AS ARRAY    INIT {}
   DATA  aTotChkCliVentas        AS ARRAY    INIT {}
   DATA  aTotChkCliLiquidados    AS ARRAY    INIT {}
   DATA  aTotChkCliCobros        AS ARRAY    INIT {}

   DATA  aTotFacPrvCompras       AS ARRAY    INIT {}
   DATA  aTotRctPrvCompras       AS ARRAY    INIT {}

   DATA  aTotAlbPrvCompras       AS ARRAY    INIT {}
   DATA  aTotFacPrvCompras       AS ARRAY    INIT {}

   DATA  aTotTikCliCobros        AS ARRAY    INIT {}
   DATA  aTotFacCliCobros        AS ARRAY    INIT {}
   DATA  aTotRctCliCobros        AS ARRAY    INIT {}
   DATA  aTotValCliCobros        AS ARRAY    INIT {}
   DATA  aTotDevCliCobros        AS ARRAY    INIT {}

   DATA  aTotFacPrvPagos         AS ARRAY    INIT {}
   DATA  aTotRctPrvPagos         AS ARRAY    INIT {}

   DATA  aTotCobroEfectivo       AS ARRAY    INIT {}
   DATA  aTotCobroNoEfectivo     AS ARRAY    INIT {}
   DATA  aTotCobroTarjeta        AS ARRAY    INIT {}

   DATA  aTotCajaEfectivo        AS ARRAY    INIT {}
   DATA  aTotCajaNoEfectivo      AS ARRAY    INIT {}
   DATA  aTotCajaTarjeta         AS ARRAY    INIT {}
   DATA  aTotCajaObjetivo        AS ARRAY    INIT {}

   DATA  aTotPagoEfectivo        AS ARRAY    INIT {}
   DATA  aTotPagoNoEfectivo      AS ARRAY    INIT {}
   DATA  aTotPagoTarjeta         AS ARRAY    INIT {}

   DATA  aTotFormaPago           AS ARRAY    INIT {}

   DATA  aTotEntradas            AS ARRAY    INIT {}

   // Datas para numeros de documentos

   DATA  aTotNumeroAlbaranes     AS ARRAY    INIT {}
   DATA  aTotNumeroFacturas      AS ARRAY    INIT {}
   DATA  aTotNumeroTikets        AS ARRAY    INIT {}
   DATA  aTotNumeroVales         AS ARRAY    INIT {}
   DATA  aTotNumeroDevoluciones  AS ARRAY    INIT {}
   DATA  aTotNumeroCheques       AS ARRAY    INIT {}

   DATA  aTotBancos              AS ARRAY    INIT {}

   // Datas para detalles

   DATA  aDatAlbCliContadores    AS ARRAY    INIT {}
   DATA  aDatAlbCliVentas        AS ARRAY    INIT {}

   DATA  aDatPedCliEntregas      AS ARRAY    INIT {}
   DATA  aDatAlbCliEntregas      AS ARRAY    INIT {}
   DATA  aDatEntregas            AS ARRAY    INIT {}

   DATA  aDatFacCliContadores    AS ARRAY    INIT {}
   DATA  aDatFacCliVentas        AS ARRAY    INIT {}
   DATA  aDatRctCliContadores    AS ARRAY    INIT {}
   DATA  aDatRctCliVentas        AS ARRAY    INIT {}
   DATA  aDatTikCliContadores    AS ARRAY    INIT {}
   DATA  aDatTikCliVentas        AS ARRAY    INIT {}
   DATA  aDatDevCliContadores    AS ARRAY    INIT {}
   DATA  aDatDevCliVentas        AS ARRAY    INIT {}

   DATA  aDatValCliContadores    AS ARRAY    INIT {}
   DATA  aDatValCliVentas        AS ARRAY    INIT {}
   DATA  aDatValCliLiquidados    AS ARRAY    INIT {}

   DATA  aDatAntCliVentas        AS ARRAY    INIT {}
   DATA  aDatAntCliLiquidados    AS ARRAY    INIT {}

   DATA  aDatChkCliContadores    AS ARRAY    INIT {}
   DATA  aDatChkCliVentas        AS ARRAY    INIT {}

   DATA  aDatAlbPrvCompras       AS ARRAY    INIT {}
   DATA  aDatFacPrvCompras       AS ARRAY    INIT {}
   DATA  aDatRctPrvCompras       AS ARRAY    INIT {}

   DATA  aDatTikCliCobros        AS ARRAY    INIT {}
   DATA  aDatFacCliCobros        AS ARRAY    INIT {}
   DATA  aDatRctCliCobros        AS ARRAY    INIT {}
   DATA  aDatValCliCobros        AS ARRAY    INIT {}
   DATA  aDatChkCliCobros        AS ARRAY    INIT {}

   DATA  aDatFacPrvPagos         AS ARRAY    INIT {}

   DATA  aDatCobroEfectivo       AS ARRAY    INIT {}
   DATA  aDatCobroNoEfectivo     AS ARRAY    INIT {}
   DATA  aDatCobroTarjeta        AS ARRAY    INIT {}

   DATA  aDatPagoEfectivo        AS ARRAY    INIT {}
   DATA  aDatPagoNoEfectivo      AS ARRAY    INIT {}
   DATA  aDatPagoTarjeta         AS ARRAY    INIT {}

   DATA  aDatCajaEfectivo        AS ARRAY    INIT {}
   DATA  aDatCajaNoEfectivo      AS ARRAY    INIT {}
   DATA  aDatCajaTarjeta         AS ARRAY    INIT {}
   DATA  aDatCajaObjetivo        AS ARRAY    INIT {}

   DATA  aDatFormaPago           AS ARRAY    INIT {}

   DATA  aDatEntradas            AS ARRAY    INIT {}

   DATA  aDatNumeroAlbaranes     AS ARRAY    INIT {}
   DATA  aDatNumeroFacturas      AS ARRAY    INIT {}
   DATA  aDatNumeroTikets        AS ARRAY    INIT {}
   DATA  aDatNumeroVales         AS ARRAY    INIT {}
   DATA  aDatNumeroDevoluciones  AS ARRAY    INIT {}
   DATA  aDatNumeroCheques       AS ARRAY    INIT {}

   DATA  aDatBancos              AS ARRAY    INIT {}

   // Otras datas

   DATA  nContadores             AS NUMERIC  INIT 0
   DATA  oTree

   Method New()                  CONSTRUCTOR
   Method Initiate()

   Method addImporte( cCaja, cSerie, aData, bEdit )

   Method addTotAlbCliContadores( cCaja, cSerie, nImporte, cData, bEdit )     INLINE   ::addImporte( cCaja, cSerie, nImporte, ::aTotAlbCliContadores, cData, ::aDatAlbCliContadores, bEdit, ::hBmpDoc[ "AlbaranCliente" ] )
   Method addTotAlbCliVentas( cCaja, cSerie, nImporte, cData, bEdit )         INLINE   ::addImporte( cCaja, cSerie, nImporte, ::aTotAlbCliVentas, cData, ::aDatAlbCliVentas, bEdit, ::hBmpDoc[ "AlbaranCliente" ] )
   Method addTotAlbCliEntregas( cCaja, cSerie, nImporte, cData, bEdit )       INLINE   ::addImporte( cCaja, cSerie, nImporte, ::aTotAlbCliEntregas, cData, ::aDatAlbCliEntregas, bEdit, ::hBmpDoc[ "AlbaranCliente" ] )

   Method addTotPedCliEntregas( cCaja, cSerie, nImporte, cData, bEdit )       INLINE   ::addImporte( cCaja, cSerie, nImporte, ::aTotPedCliEntregas, cData, ::aDatPedCliEntregas, bEdit, ::hBmpDoc[ "PedidoCliente" ] )

   Method addTotFacCliContadores( cCaja, cSerie, nImporte, cData, bEdit )     INLINE   ::addImporte( cCaja, cSerie, nImporte, ::aTotFacCliContadores, cData, ::aDatFacCliContadores, bEdit, ::hBmpDoc[ "FacturaCliente" ] )
   Method addTotFacCliVentas( cCaja, cSerie, nImporte, cData, bEdit )         INLINE   ::addImporte( cCaja, cSerie, nImporte, ::aTotFacCliVentas, cData, ::aDatFacCliVentas, bEdit, ::hBmpDoc[ "FacturaCliente" ] )

   Method addTotRctCliContadores( cCaja, cSerie, nImporte, cData, bEdit )     INLINE   ::addImporte( cCaja, cSerie, nImporte, ::aTotRctCliContadores, cData, ::aDatRctCliContadores, bEdit, ::hBmpDoc[ "RectificativaCliente" ] )
   Method addTotRctCliVentas( cCaja, cSerie, nImporte, cData, bEdit )         INLINE   ::addImporte( cCaja, cSerie, nImporte, ::aTotRctCliVentas, cData, ::aDatRctCliVentas, bEdit, ::hBmpDoc[ "RectificativaCliente" ] )

   Method addTotTikCliContadores( cCaja, cSerie, nImporte, cData, bEdit )     INLINE   ::addImporte( cCaja, cSerie, nImporte, ::aTotTikCliContadores, cData, ::aDatTikCliContadores, bEdit, ::hBmpDoc[ "TiketCliente" ] )
   Method addTotTikCliVentas( cCaja, cSerie, nImporte, cData, bEdit )         INLINE   ::addImporte( cCaja, cSerie, nImporte, ::aTotTikCliVentas, cData, ::aDatTikCliVentas, bEdit, ::hBmpDoc[ "TiketCliente" ] )

   Method addTotDevCliContadores( cCaja, cSerie, nImporte, cData, bEdit )     INLINE   ::addImporte( cCaja, cSerie, nImporte, ::aTotDevCliContadores, cData, ::aDatDevCliContadores, bEdit, ::hBmpDoc[ "TiketCliente" ] )
   Method addTotDevCliVentas( cCaja, cSerie, nImporte, cData, bEdit )         INLINE   ::addImporte( cCaja, cSerie, nImporte, ::aTotDevCliVentas, cData, ::aDatDevCliVentas, bEdit, ::hBmpDoc[ "TiketCliente" ] )

   Method addTotValCliContadores( cCaja, cSerie, nImporte, cData, bEdit )     INLINE   ::addImporte( cCaja, cSerie, nImporte, ::aTotValCliContadores, cData, ::aDatValCliContadores, bEdit, ::hBmpDoc[ "TiketCliente" ] )
   Method addTotValCliVentas( cCaja, cSerie, nImporte, cData, bEdit )         INLINE   ::addImporte( cCaja, cSerie, nImporte, ::aTotValCliVentas, cData, ::aDatValCliVentas, bEdit, ::hBmpDoc[ "TiketCliente" ] )
   Method addTotValCliLiquidados( cCaja, cSerie, nImporte, cData, bEdit )     INLINE   ::addImporte( cCaja, cSerie, nImporte, ::aTotValCliLiquidados, cData, ::aDatValCliLiquidados, bEdit, ::hBmpDoc[ "TiketCliente" ] )

   Method addTotChkCliContadores( cCaja, cSerie, nImporte, cData, bEdit )     INLINE   ::addImporte( cCaja, cSerie, nImporte, ::aTotChkCliContadores, cData, ::aDatChkCliContadores, bEdit, ::hBmpDoc[ "TiketCliente" ] )
   Method addTotChkCliVentas( cCaja, cSerie, nImporte, cData, bEdit )         INLINE   ::addImporte( cCaja, cSerie, nImporte, ::aTotChkCliVentas, cData, ::aDatChkCliVentas, bEdit, ::hBmpDoc[ "TiketCliente" ] )

   Method addTotAlbPrvCompras( cCaja, cSerie, nImporte, cData, bEdit )        INLINE   ::addImporte( cCaja, cSerie, nImporte, ::aTotAlbPrvCompras, cData, ::aDatAlbPrvCompras, bEdit, ::hBmpDoc[ "AlbaranProveedor" ] )

   Method addTotFacPrvCompras( cCaja, cSerie, nImporte, cData, bEdit )        INLINE   ::addImporte( cCaja, cSerie, nImporte, ::aTotFacPrvCompras, cData, ::aDatFacPrvCompras, bEdit, ::hBmpDoc[ "FacturaProveedor" ] )
   Method addTotRctPrvCompras( cCaja, cSerie, nImporte, cData, bEdit )        INLINE   ::addImporte( cCaja, cSerie, nImporte, ::aTotRctPrvCompras, cData, ::aDatRctPrvCompras, bEdit, ::hBmpDoc[ "RectificativaProveedor" ] )

   Method addTotTikCliCobros( cCaja, cSerie, nImporte, cData, bEdit )         INLINE   ::addImporte( cCaja, cSerie, nImporte, ::aTotTikCliCobros, cData, ::aDatTikCliCobros, bEdit, ::hBmpDoc[ "TiketCliente" ] )
   Method addTotFacCliCobros( cCaja, cSerie, nImporte, cData, bEdit )         INLINE   ::addImporte( cCaja, cSerie, nImporte, ::aTotFacCliCobros, cData, ::aDatFacCliCobros, bEdit, ::hBmpDoc[ "ReciboClientes" ] )
   Method addTotRctCliCobros( cCaja, cSerie, nImporte, cData, bEdit )         INLINE   ::addImporte( cCaja, cSerie, nImporte, ::aTotFacCliCobros, cData, ::aDatFacCliCobros, bEdit, ::hBmpDoc[ "ReciboClientes" ] )
   Method addTotValCliCobros( cCaja, cSerie, nImporte, cData, bEdit )         INLINE   ::addImporte( cCaja, cSerie, nImporte, ::aTotValCliCobros, cData, ::aDatValCliCobros, bEdit, ::hBmpDoc[ "TiketCliente" ] )
   Method addTotChkCliCobros( cCaja, cSerie, nImporte, cData, bEdit )         INLINE   ::addImporte( cCaja, cSerie, nImporte, ::aTotChkCliCobros, cData, ::aDatChkCliCobros, bEdit, ::hBmpDoc[ "TiketCliente" ] )

   Method addTotAntCliVentas( cCaja, cSerie, nImporte, cData, bEdit )         INLINE   ::addImporte( cCaja, cSerie, nImporte, ::aTotAntCliVentas, cData, ::aDatAntCliVentas, bEdit, ::hBmpDoc[ "FacturaAnticipo" ] )
   Method addTotAntCliLiquidados( cCaja, cSerie, nImporte, cData, bEdit )     INLINE   ::addImporte( cCaja, cSerie, nImporte, ::aTotAntCliLiquidados, cData, ::aDatAntCliLiquidados, bEdit, ::hBmpDoc[ "FacturaAnticipo" ] )

   Method addTotCobroEfectivo( cCaja, cSerie, nImporte, cData, bEdit, hBmp )  INLINE   ::addImporte( cCaja, cSerie, nImporte, ::aTotCobroEfectivo, cData, ::aDatCobroEfectivo, bEdit, hBmp )
   Method addTotCobroNoEfectivo( cCaja, cSerie, nImporte, cData, bEdit, hBmp )INLINE   ::addImporte( cCaja, cSerie, nImporte, ::aTotCobroNoEfectivo, cData, ::aDatCobroNoEfectivo, bEdit, hBmp )
   Method addTotCobroTarjeta( cCaja, cSerie, nImporte, cData, bEdit, hBmp )   INLINE   ::addImporte( cCaja, cSerie, nImporte, ::aTotCobroTarjeta, cData, ::aDatCobroTarjeta, bEdit, hBmp )

   Method addTotPagoEfectivo( cCaja, cSerie, nImporte, cData, bEdit )         INLINE   ::addImporte( cCaja, cSerie, nImporte, ::aTotPagoEfectivo, cData, ::aDatPagoEfectivo, bEdit, ::hBmpDoc[ "PagoProveedor" ] )
   Method addTotPagoNoEfectivo( cCaja, cSerie, nImporte, cData, bEdit )       INLINE   ::addImporte( cCaja, cSerie, nImporte, ::aTotPagoNoEfectivo, cData, ::aDatPagoNoEfectivo, bEdit, ::hBmpDoc[ "PagoProveedor" ] )
   Method addTotPagoTarjeta( cCaja, cSerie, nImporte, cData, bEdit )          INLINE   ::addImporte( cCaja, cSerie, nImporte, ::aTotPagoTarjeta, cData, ::aDatPagoTarjeta, bEdit, ::hBmpDoc[ "PagoProveedor" ] )

   Method addTotFacPrvPagos( cCaja, cSerie, nImporte, cData, bEdit )          INLINE   ::addImporte( cCaja, cSerie, nImporte, ::aTotFacPrvPagos, cData, ::aDatFacPrvPagos, bEdit, ::hBmpDoc[ "PagoProveedor" ] )

   Method addTotCajaEfectivo( cCaja, nImporte, cData, bEdit )                 INLINE   ::addImporte( cCaja, "A", nImporte, ::aTotCajaEfectivo, cData, ::aDatCajaEfectivo, bEdit )
   Method addTotCajaNoEfectivo( cCaja, nImporte, cData, bEdit )               INLINE   ::addImporte( cCaja, "A", nImporte, ::aTotCajaNoEfectivo, cData, ::aDatCajaNoEfectivo, bEdit )
   Method addTotCajaTarjeta( cCaja, nImporte, cData, bEdit )                  INLINE   ::addImporte( cCaja, "A", nImporte, ::aTotCajaTarjeta, cData, ::aDatCajaTarjeta, bEdit )
   Method addTotCajaObjetivo( cCaja, nImporte, cData, bEdit )                 INLINE   ::addImporte( cCaja, "A", nImporte, ::aTotCajaObjetivo, cData, ::aDatCajaObjetivo, bEdit )

   Method addTotEntradas( cCaja, nImporte, cData, bEdit )                     INLINE   ::addImporte( cCaja, "A", nImporte, ::aTotEntradas, cData, ::aDatEntradas, bEdit, ::hBmpDoc[ "EntradaSalida" ] )

   Method addTotBancos( cCaja, cCuenta, nImporte, cData, bEdit, hBmp )        INLINE   ::addImporte( cCaja, cCuenta, nImporte, ::aTotBancos, cData, ::aDatBancos, bEdit, hBmp )

   Method initContadores( nImporte )                           INLINE   ( ::nContadores := 0 )
   Method addContadores( nImporte )                            INLINE   ( ::nContadores += nImporte )

   Method nTotAlbCliContadores( cCaja, cSerie )                INLINE   nImporte( cCaja, cSerie, ::aTotAlbCliContadores )
   Method nTotAlbCliVentas( cCaja, cSerie )                    INLINE   nImporte( cCaja, cSerie, ::aTotAlbCliVentas )

   Method nTotPedCliEntregas( cCaja, cSerie )                  INLINE   nImporte( cCaja, cSerie, ::aTotPedCliEntregas )
   Method nTotAlbCliEntregas( cCaja, cSerie )                  INLINE   nImporte( cCaja, cSerie, ::aTotAlbCliEntregas )

   Method nTotEntregas( cCaja, cSerie )                        INLINE   ( ::nTotPedCliEntregas( cCaja, cSerie ) + ::nTotAlbCliEntregas( cCaja, cSerie ) )

   Method nTotFacCliContadores( cCaja, cSerie )                INLINE   nImporte( cCaja, cSerie, ::aTotFacCliContadores )
   Method nTotFacCliVentas( cCaja, cSerie )                    INLINE   nImporte( cCaja, cSerie, ::aTotFacCliVentas )

   Method nTotRctCliContadores( cCaja, cSerie )                INLINE   nImporte( cCaja, cSerie, ::aTotRctCliContadores )
   Method nTotRctCliVentas( cCaja, cSerie )                    INLINE   nImporte( cCaja, cSerie, ::aTotRctCliVentas )

   Method nTotTikCliContadores( cCaja, cSerie )                INLINE   nImporte( cCaja, cSerie, ::aTotTikCliContadores )
   Method nTotTikCliVentas( cCaja, cSerie )                    INLINE   nImporte( cCaja, cSerie, ::aTotTikCliVentas )
   Method nTotTikCliCheques( cCaja, cSerie )                   INLINE   nImporte( cCaja, cSerie, ::aTotChkCliVentas )

   Method nTotDevCliContadores( cCaja, cSerie )                INLINE   nImporte( cCaja, cSerie, ::aTotDevCliContadores, .t. )
   Method nTotDevCliVentas( cCaja, cSerie )                    INLINE   nImporte( cCaja, cSerie, ::aTotDevCliVentas, .t. )

   Method nTotValCliContadores( cCaja, cSerie )                INLINE   nImporte( cCaja, cSerie, ::aTotValCliContadores, .t. )
   
   Method nTotValCliVentas( cCaja, cSerie )                    INLINE   nImporte( cCaja, cSerie, ::aTotValCliVentas, .t. )

   Method nTotValCliLiquidados( cCaja, cSerie )                INLINE   nImporte( cCaja, cSerie, ::aTotValCliLiquidados, .t. )

   Method nTotChkCliContadores( cCaja, cSerie )                INLINE   nImporte( cCaja, cSerie, ::aTotChkCliContadores, .t. )
   Method nTotChkCliVentas( cCaja, cSerie )                    INLINE   nImporte( cCaja, cSerie, ::aTotChkCliVentas, .t. )
   Method nTotChkCliLiquidados( cCaja, cSerie )                INLINE   nImporte( cCaja, cSerie, ::aTotChkCliLiquidados, .t. )

   Method nTotAlbPrvCompras( cCaja, cSerie )                   INLINE   nImporte( cCaja, cSerie, ::aTotAlbPrvCompras )
   Method nTotFacPrvCompras( cCaja, cSerie )                   INLINE   nImporte( cCaja, cSerie, ::aTotFacPrvCompras )
   Method nTotRctPrvCompras( cCaja, cSerie )                   INLINE   nImporte( cCaja, cSerie, ::aTotRctPrvCompras )

   Method nTotAntCliVentas( cCaja, cSerie )                    INLINE   nImporte( cCaja, cSerie, ::aTotAntCliVentas )
   Method nTotAntCliLiquidados( cCaja, cSerie )                INLINE   nImporte( cCaja, cSerie, ::aTotAntCliLiquidados )

   Method nTotFacPrvPagos( cCaja, cSerie )                     INLINE   nImporte( cCaja, cSerie, ::aTotFacPrvPagos )
   Method nTotRctPrvPagos( cCaja, cSerie )                     INLINE   nImporte( cCaja, cSerie, ::aTotRctPrvPagos )

   Method nTotEntradas( cCaja )                                INLINE   nImporte( cCaja, "A", ::aTotEntradas )

   Method nTotVentas( cCaja, cSerie )
   Method nTotContadores( cCaja, cSerie )
   Method nTotVentaCredito( cCaja, cSerie )
   Method nTotVentaContado( cCaja, cSerie )

   Method nTotCompras( cCaja, cSerie )

   Method nTotTikCliCobros( cCaja, cSerie )                    INLINE   nImporte( cCaja, cSerie, ::aTotTikCliCobros )
   Method nTotFacCliCobros( cCaja, cSerie )                    INLINE   nImporte( cCaja, cSerie, ::aTotFacCliCobros )
   Method nTotRctCliCobros( cCaja, cSerie )                    INLINE   nImporte( cCaja, cSerie, ::aTotRctCliCobros )
   Method nTotValCliCobros( cCaja, cSerie )                    INLINE   nImporte( cCaja, cSerie, ::aTotValCliCobros )
   Method nTotChkCliCobros( cCaja, cSerie )                    INLINE   nImporte( cCaja, cSerie, ::aTotChkCliCobros )

   Method nTotCobroEfectivo( cCaja, cSerie )                   INLINE   nImporte( cCaja, cSerie, ::aTotCobroEfectivo )
   Method nTotCobroNoEfectivo( cCaja, cSerie )                 INLINE   nImporte( cCaja, cSerie, ::aTotCobroNoEfectivo )
   Method nTotCobroTarjeta( cCaja, cSerie )                    INLINE   nImporte( cCaja, cSerie, ::aTotCobroTarjeta )

   Method nTotCajaEfectivo( cCaja, cSerie )                    INLINE   nImporte( cCaja, "A", ::aTotCajaEfectivo )
   Method nTotCajaNoEfectivo( cCaja, cSerie )                  INLINE   nImporte( cCaja, "A", ::aTotCajaNoEfectivo )
   Method nTotCajaTarjeta( cCaja, cSerie )                     INLINE   nImporte( cCaja, "A", ::aTotCajaTarjeta )
   Method nTotCajaObjetivo( cCaja, cSerie )                    INLINE   nImporte( cCaja, "A", ::aTotCajaObjetivo )

   Method nTotCobroMedios( cCaja, cSerie )                     INLINE   ( ::nTotCobroEfectivo( cCaja, cSerie ) + ::nTotEntradas( cCaja, "A" ) )

   Method nTotPagoEfectivo( cCaja, cSerie )                    INLINE   nImporte( cCaja, cSerie, ::aTotPagoEfectivo )
   Method nTotPagoNoEfectivo( cCaja, cSerie )                  INLINE   nImporte( cCaja, cSerie, ::aTotPagoNoEfectivo )
   Method nTotPagoTarjeta( cCaja, cSerie )                     INLINE   nImporte( cCaja, cSerie, ::aTotPagoTarjeta )

   Method nTotSaldoEfectivo( cCaja, cSerie )                   INLINE   ( ::nTotCobroEfectivo( cCaja, cSerie ) - ::nTotPagoEfectivo( cCaja, cSerie ) + ::nTotEntradas( cCaja, "A" ) )
   Method nTotSaldoNoEfectivo( cCaja, cSerie )                 INLINE   ( ::nTotCobroNoEfectivo( cCaja, cSerie ) - ::nTotPagoNoEfectivo( cCaja, cSerie ) )
   Method nTotSaldoTarjeta( cCaja, cSerie )                    INLINE   ( ::nTotCobroTarjeta( cCaja, cSerie ) - ::nTotPagoTarjeta( cCaja, cSerie ) )

   Method nTotPagoMedios( cCaja, cSerie )                      INLINE   ( ::nTotPagoEfectivo( cCaja, cSerie ) + ::nTotEntradas( cCaja, "A" ) )

   Method nTotCobros( cCaja, cSerie )
   Method nDifCobros( cCaja, cSerie )

   Method nDifTotal( cCaja, cSerie )

   Method nTotVentaSesion( cCaja, cSerie )
   Method nTotCobroSesion( cCaja, cSerie )

   Method nTotCaja( cCaja, cSerie )

   Method nTotBancos( cCaja, cCuenta )                         INLINE   nImporte( cCaja, cCuenta, ::aTotBancos )

   Method addNumero( cCaja, aData )

   Method addNumeroAlbaranes( cCaja )                          INLINE   ::addNumero( cCaja, ::aTotNumeroAlbaranes )
   Method addNumeroFacturas( cCaja )                           INLINE   ::addNumero( cCaja, ::aTotNumeroFacturas )
   Method addNumeroTikets( cCaja )                             INLINE   ::addNumero( cCaja, ::aTotNumeroTikets )
   Method addNumeroVales( cCaja )                              INLINE   ::addNumero( cCaja, ::aTotNumeroVales )
   Method addNumeroDevoluciones( cCaja )                       INLINE   ::addNumero( cCaja, ::aTotNumeroDevoluciones )
   Method addNumeroCheques( cCaja )                            INLINE   ::addNumero( cCaja, ::aTotNumeroCheques )

   Method nTotNumeroAlbaranes( cCaja )                         INLINE   nNumero( cCaja, ::aTotNumeroAlbaranes )
   Method nTotNumeroFacturas( cCaja )                          INLINE   nNumero( cCaja, ::aTotNumeroFacturas )
   Method nTotNumeroTikets( cCaja )                            INLINE   nNumero( cCaja, ::aTotNumeroTikets )
   Method nTotNumeroVales( cCaja )                             INLINE   nNumero( cCaja, ::aTotNumeroVales )
   Method nTotNumeroDevoluciones( cCaja )                      INLINE   nNumero( cCaja, ::aTotNumeroDevoluciones )
   Method nTotNumeroCheques( cCaja )                           INLINE   nNumero( cCaja, ::aTotNumeroCheques )
   Method nTotNumeroAptCajon( cTurno, cCaja )

   Method nTiketMedio( cCaja, cSerie )                         INLINE   ( ::nTotTikCliVentas( cCaja, cSerie ) / NotCero( ::nTotNumeroTikets( cCaja ) ) )

   Method CreateTree( cCaja, cTurno )

   Method lArqueoCiego()                                       INLINE   ( if( !Empty( ::oTurno ), ::oTurno:lArqueoCiego, .f. ) )

   Method End()                                                INLINE   ( HEval( ::hBmpDoc, { | xKey, hBmp | DeleteObject( hBmp ) } ) )

END CLASS

//----------------------------------------------------------------------------//

METHOD New( oTurno )

   ::Initiate()

   ::oTurno                   := oTurno

   ::hBmpDoc                  := {=>}

   HSet( ::hBmpDoc, "AlbaranProveedor",      LoadBitmap( GetResources(), "gc_document_empty_businessman_16" ) )
   HSet( ::hBmpDoc, "FacturaProveedor",      LoadBitmap( GetResources(), "gc_document_text_businessman_16" ) )
   HSet( ::hBmpDoc, "RectificativaProveedor",LoadBitmap( GetResources(), "gc_document_text_delete2_16" ) )
   HSet( ::hBmpDoc, "PagoProveedor",         LoadBitmap( GetResources(), "gc_briefcase2_businessman_16" ) )
   HSet( ::hBmpDoc, "PedidoCliente",         LoadBitmap( GetResources(), "gc_clipboard_empty_user_16" ) )
   HSet( ::hBmpDoc, "AlbaranCliente",        LoadBitmap( GetResources(), "gc_document_empty_16" ) )
   HSet( ::hBmpDoc, "FacturaCliente",        LoadBitmap( GetResources(), "gc_document_text_businessman_16" ) )
   HSet( ::hBmpDoc, "RectificativaCliente",  LoadBitmap( GetResources(), "gc_document_text_delete2_16" ) )
   HSet( ::hBmpDoc, "FacturaAnticipo",       LoadBitmap( GetResources(), "gc_document_text_money2_16" ) )
   HSet( ::hBmpDoc, "ReciboClientes",        LoadBitmap( GetResources(), "gc_briefcase2_user_16" ) )
   HSet( ::hBmpDoc, "TiketCliente",          LoadBitmap( GetResources(), "gc_cash_register_user_16" ) )
   HSet( ::hBmpDoc, "EntradaSalida",         LoadBitmap( GetResources(), "gc_cash_register_refresh_16" ) )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Initiate()

   ::aTotAlbCliContadores     := {}
   ::aTotAlbCliVentas         := {}
   ::aTotPedCliEntregas       := {}
   ::aTotAlbCliEntregas       := {}
   ::aTotEntregas             := {}
   ::aTotFacCliContadores     := {}
   ::aTotFacCliVentas         := {}
   ::aTotRctCliContadores     := {}
   ::aTotRctCliVentas         := {}
   ::aTotTikCliContadores     := {}
   ::aTotTikCliVentas         := {}
   ::aTotDevCliContadores     := {}
   ::aTotDevCliVentas         := {}
   ::aTotValCliContadores     := {}
   ::aTotValCliVentas         := {}
   ::aTotChkCliContadores     := {}
   ::aTotChkCliVentas         := {}
   ::aTotAntCliVentas         := {}
   ::aTotAntCliLiquidados     := {}
   ::aTotValCliLiquidados     := {}
   ::aTotChkCliLiquidados     := {}
   ::aTotFacPrvCompras        := {}
   ::aTotAlbPrvCompras        := {}
   ::aTotFacPrvCompras        := {}
   ::aTotTikCliCobros         := {}
   ::aTotFacCliCobros         := {}
   ::aTotRctCliCobros         := {}
   ::aTotValCliCobros         := {}
   ::aTotChkCliCobros         := {}
   ::aTotFacPrvPagos          := {}
   ::aTotCobroEfectivo        := {}
   ::aTotCobroNoEfectivo      := {}
   ::aTotCobroTarjeta         := {}
   ::aTotPagoEfectivo         := {}
   ::aTotPagoNoEfectivo       := {}
   ::aTotPagoTarjeta          := {}
   ::aTotFormaPago            := {}
   ::aTotEntradas             := {}
   ::aTotNumeroAlbaranes      := {}
   ::aTotNumeroFacturas       := {}
   ::aTotNumeroTikets         := {}
   ::aTotNumeroVales          := {}
   ::aTotNumeroCheques        := {}
   ::aTotNumeroDevoluciones   := {}
   ::aTotCajaEfectivo         := {}
   ::aTotCajaNoEfectivo       := {}
   ::aTotCajaTarjeta          := {}
   ::aTotCajaObjetivo         := {}
   ::aTotBancos               := {}

   ::aDatAlbCliContadores     := {}
   ::aDatAlbCliVentas         := {}
   ::aDatPedCliEntregas       := {}
   ::aDatAlbCliEntregas       := {}
   ::aDatEntregas             := {}
   ::aDatFacCliContadores     := {}
   ::aDatFacCliVentas         := {}
   ::aDatRctCliContadores     := {}
   ::aDatRctCliVentas         := {}
   ::aDatTikCliContadores     := {}
   ::aDatTikCliVentas         := {}
   ::aDatDevCliContadores     := {}
   ::aDatDevCliVentas         := {}
   ::aDatValCliContadores     := {}
   ::aDatValCliVentas         := {}
   ::aDatChkCliContadores     := {}
   ::aDatChkCliVentas         := {}
   ::aDatAntCliVentas         := {}
   ::aDatAntCliLiquidados     := {}
   ::aDatValCliLiquidados     := {}
   ::aDatAlbPrvCompras        := {}
   ::aDatFacPrvCompras        := {}
   ::aDatTikCliCobros         := {}
   ::aDatFacCliCobros         := {}
   ::aDatRctCliCobros         := {}
   ::aDatValCliCobros         := {}
   ::aDatChkCliCobros         := {}
   ::aDatFacPrvPagos          := {}
   ::aDatCobroEfectivo        := {}
   ::aDatCobroNoEfectivo      := {}
   ::aDatCobroTarjeta         := {}
   ::aDatPagoEfectivo         := {}
   ::aDatPagoNoEfectivo       := {}
   ::aDatPagoTarjeta          := {}
   ::aDatCajaEfectivo         := {}
   ::aDatCajaNoEfectivo       := {}
   ::aDatCajaTarjeta          := {}
   ::aDatCajaObjetivo         := {}
   ::aDatFormaPago            := {}
   ::aDatEntradas             := {}
   ::aDatNumeroAlbaranes      := {}
   ::aDatNumeroFacturas       := {}
   ::aDatNumeroTikets         := {}
   ::aDatNumeroVales          := {}
   ::aDatNumeroDevoluciones   := {}
   ::aDatNumeroCheques        := {}
   ::aDatBancos               := {}

   ::nContadores              := 0

RETURN ( Self )

//---------------------------------------------------------------------------//

Method addImporte( cCaja, cSerie, nImporte, aImporte, cData, aData, bEdit, nBmp )

   local n

   DEFAULT nBmp         := 0

   if ( n := aScan( aImporte, {|a| a[ 1 ] == cCaja .and. a[ 2 ] == cSerie } ) ) != 0
      aImporte[ n, 3 ]  += nImporte
   else
      aAdd( aImporte, { cCaja, cSerie, nImporte } )
   end if

   if !Empty( cData )
      aAdd( aData, { cCaja, cSerie, cData, nImporte, bEdit, nBmp } )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

Method addNumero( cCaja, aData )

   local n

   if ( n := aScan( aData, {|a| a[ 1 ] == cCaja } ) ) != 0
      aData[ n, 2 ]++
   else
      aAdd( aData, { cCaja, 1 } )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Method addTotEntradas( cCaja, nImporte, cData )

   local n

   if ( n := aScan( ::aTotEntradas, {|a| a[1] == cCaja } ) ) != 0
      ::aTotEntradas[n,2]  += nImporte
   else
      aAdd( ::aTotEntradas, { cCaja, nImporte } )
   end if

  if !Empty( cData )
      aAdd( ::aDatEntradas, { cCaja, cData, nImporte } )
   end if

RETURN ( Self )
*/
//---------------------------------------------------------------------------//
/*
Method nTotEntradas( cCaja )

   local nImporte    := 0

   aEval( ::aTotEntradas, {|a| if( Empty( cCaja ) .or. a[1] == cCaja, nImporte += a[2], ) } )

Return ( nImporte )
*/
//---------------------------------------------------------------------------//

Method nTotVentas( cCaja, cSerie )

   local nTotVentas

   nTotVentas  := ::nContadores
   nTotVentas  += ::nTotAlbCliVentas( cCaja, cSerie )
   nTotVentas  += ::nTotFacCliVentas( cCaja, cSerie )
   nTotVentas  += ::nTotRctCliVentas( cCaja, cSerie )
   nTotVentas  += ::nTotTikCliVentas( cCaja, cSerie )
   nTotVentas  += ::nTotAntCliVentas( cCaja, cSerie )
   nTotVentas  += ::nTotChkCliVentas( cCaja, cSerie )
   nTotVentas  -= ::nTotDevCliVentas( cCaja, cSerie )
   /*
   nTotVentas  -= ::nTotAntCliLiquidados( cCaja, cSerie )
   */

   /*
   logwrite( "::nContadores                          "+ Str( ::nContadores                            ) )
   logwrite( "::nTotAlbCliVentas( cCaja, cSerie )    "+ Str( ::nTotAlbCliVentas( cCaja, cSerie )      ) )
   logwrite( "::nTotFacCliVentas( cCaja, cSerie )    "+ Str( ::nTotFacCliVentas( cCaja, cSerie )      ) )
   logwrite( "::nTotTikCliVentas( cCaja, cSerie )    "+ Str( ::nTotTikCliVentas( cCaja, cSerie )      ) )
   logwrite( "::nTotAntCliVentas( cCaja, cSerie )    "+ Str( ::nTotAntCliVentas( cCaja, cSerie )      ) )
   logwrite( "::nTotChkCliVentas( cCaja, cSerie )    "+ Str( ::nTotChkCliVentas( cCaja, cSerie )      ) )
   logwrite( "::nTotDevCliVentas( cCaja, cSerie )    "+ Str( ::nTotDevCliVentas( cCaja, cSerie )      ) )
   logwrite( "::nTotAntCliLiquidados( cCaja, cSerie )"+ Str( ::nTotAntCliLiquidados( cCaja, cSerie )  ) )
   */

Return ( nTotVentas )

//---------------------------------------------------------------------------//

Method nTotContadores( cCaja, cSerie )

   local nTotVentas

   nTotVentas  := ::nContadores

Return ( nTotVentas )

//---------------------------------------------------------------------------//

Method nTotCompras( cCaja, cSerie )

   local nTotCompras

   nTotCompras := ::nTotAlbPrvCompras( cCaja, cSerie )
   nTotCompras += ::nTotFacPrvCompras( cCaja, cSerie )
   nTotCompras += ::nTotRctPrvCompras( cCaja, cSerie )

Return ( nTotCompras )

//---------------------------------------------------------------------------//
/*
Cobros totales, son los contadores + los tikets + las facturas
*/

Method nTotCobros( cCaja, cSerie )

   local nTotCobros

   nTotCobros  := ::nTotContadores( cCaja, cSerie )
   nTotCobros  += ::nTotTikCliCobros( cCaja, cSerie )
   nTotCobros  += ::nTotChkCliCobros( cCaja, cSerie )
   nTotCobros  += ::nTotFacCliCobros( cCaja, cSerie )
   nTotCobros  += ::nTotRctCliCobros( cCaja, cSerie )
   nTotCobros  += ::nTotAntCliVentas( cCaja, cSerie )
   nTotCobros  -= ::nTotTikCliContadores( cCaja, cSerie )
   nTotCobros  -= ::nTotFacCliContadores( cCaja, cSerie )
   nTotCobros  -= ::nTotRctCliContadores( cCaja, cSerie )

Return ( nTotCobros )

//---------------------------------------------------------------------------//

Method nTotCobroSesion( cCaja, cSerie, lIncluirEntregas )

   local nTotCobro

   DEFAULT lIncluirEntregas   := .t.

   nTotCobro                  := ::nTotCobros( cCaja, cSerie )
   nTotCobro                  += ::nTotAntCliVentas( cCaja, cSerie )
   if lIncluirEntregas
      nTotCobro               += ::nTotEntregas( cCaja, cSerie )
   end if

Return ( nTotCobro )

//---------------------------------------------------------------------------//

Method nDifCobros( cCaja, cSerie )

   local nDifCobros

   nDifCobros  := ::nTotVentaContado( cCaja, cSerie )
   nDifCobros  -= ::nTotCobroSesion( cCaja, cSerie, .f. )
   nDifCobros  -= ::nTotEntradas( cCaja, cSerie )

Return ( nDifCobros )

//---------------------------------------------------------------------------//

Method nDifTotal( cCaja, cSerie )

   local nDifCobros

   nDifCobros  := ::nTotVentaCredito( cCaja, cSerie )

Return ( nDifCobros )

//---------------------------------------------------------------------------//

Method nTotVentaContado( cCaja, cSerie )

   local nTotVentas

   nTotVentas  := ::nContadores

   nTotVentas  -= ::nTotAlbCliContadores( cCaja, cSerie )
   nTotVentas  += ::nTotTikCliVentas( cCaja, cSerie )
   nTotVentas  += ::nTotFacCliVentas( cCaja, cSerie )
   nTotVentas  += ::nTotRctCliVentas( cCaja, cSerie )
   nTotVentas  += ::nTotEntradas( cCaja, cSerie )
   nTotVentas  += ::nTotAntCliVentas( cCaja, cSerie )
   nTotVentas  += ::nTotChkCliVentas( cCaja, cSerie )
   nTotVentas  -= ::nTotDevCliVentas( cCaja, cSerie )

Return ( nTotVentas )

//---------------------------------------------------------------------------//

Method nTotVentaCredito( cCaja, cSerie )

   local nTotVenta

   nTotVenta   := ::nTotAlbCliContadores( cCaja, cSerie )
   nTotVenta   += ::nTotAlbCliVentas( cCaja, cSerie )

Return ( nTotVenta )

//---------------------------------------------------------------------------//

Method nTotVentaSesion( cCaja, cSerie )

   local nTotMetalico

   nTotMetalico      := ::nTotVentas( cCaja, cSerie )
   nTotMetalico      -= ::nTotVentaCredito( cCaja, cSerie )
   nTotMetalico      -= ::nDifCobros( cCaja, cSerie )
   nTotMetalico      += ::nTotEntregas( cCaja, cSerie )
   nTotMetalico      += ::nTotEntradas( cCaja, cSerie )

Return ( nTotMetalico )

//---------------------------------------------------------------------------//

Method nTotCaja( cCaja, cSerie )

   local nTotCaja    := 0

   if !::lArqueoCiego()

      nTotCaja       := ::nTotTikCliCobros( cCaja, cSerie )
      nTotCaja       += ::nTotFacCliCobros( cCaja, cSerie )
      nTotCaja       += ::nTotRctCliCobros( cCaja, cSerie )
      nTotCaja       += ::nTotEntregas( cCaja, cSerie )
      nTotCaja       += ::nTotEntradas( cCaja, cSerie )
      nTotCaja       += ::nTotAntCliVentas( cCaja, cSerie )
      nTotCaja       -= ::nTotFacPrvPagos( cCaja, cSerie )
      nTotCaja       -= ::nTotRctPrvPagos( cCaja, cSerie )
      nTotCaja       += ::nContadores
      nTotCaja       -= ::nTotAlbCliContadores( cCaja, cSerie )
      nTotCaja       -= ::nTotFacCliContadores( cCaja, cSerie )
      nTotCaja       -= ::nTotRctCliContadores( cCaja, cSerie )
      nTotCaja       -= ::nTotTikCliContadores( cCaja, cSerie )

   end if

Return ( nTotCaja )

//---------------------------------------------------------------------------//

Method nTotNumeroAptCajon( cTurno, cCaja )

   local oBlock
   local oError
   local nTotal         := 0

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if !Empty( ::oTurno )

         ::oTurno:oLogPorta:GetStatus()
         ::oTurno:oLogPorta:ordsetfocus( "cTurCaj" )

         if ::oTurno:oLogPorta:Seek( cTurno + cCaja )

            while ::oTurno:oLogPorta:cNumTur + ::oTurno:oLogPorta:cSufTur + ::oTurno:oLogPorta:cCodCaj == cTurno + cCaja .and. ! ::oTurno:oLogPorta:eof()

               nTotal++

               ::oTurno:oLogPorta:Skip()

            end while

         end if

         ::oTurno:oLogPorta:SetStatus()


      end if

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Error apertura log de cajón portamonedas" )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( nTotal )

//---------------------------------------------------------------------------//

Method CreateTree( cCaja, cTurno )

   local aItem
   local oTree
   local aSubItem
   local oTreeBancos
   local nCont          := 0
   local nSaldoTotal    := 0
   local nSaldoActual   := 0

   oTree                := TreeBegin( "gc_navigate_minus_16", "gc_navigate_plus_16" )

   /*
   Contadores------------------------------------------------------------------
   */

   if ::nContadores != 0
      TreeAddItem( "Total contadores" ):Cargo := { "Total contadores", ::nContadores }
   end if

   /*
   Albaranes----------------------------------------------------------------
   */

   if ::nTotAlbCliVentas( cCaja ) != 0

      TreeAddItem( "Total albaranes" ):Cargo := { "Total albaranes", ::nTotAlbCliVentas( cCaja ) }

      if !Empty( ::aDatAlbCliVentas )
         TreeBegin()
         for each aItem in ::aDatAlbCliVentas
            if ( Empty( cCaja ) .or. aItem[ 1 ] == cCaja )
               TreeAddItem( AllTrim( aItem[ 3 ] ), "Detalles", , , , .f. ):Cargo := { aItem[ 3 ], aItem[ 4 ], aItem[ 5 ], aItem[ 6 ] }
            end if
         next
         TreeEnd()
      end if

   end if

   /*
   Facturas-----------------------------------------------------------------
   */

   if ::nTotFacCliVentas( cCaja ) != 0

      TreeAddItem( "Total facturas" ):Cargo := { "Total facturas", ::nTotFacCliVentas( cCaja ) }

      if !Empty( ::aDatFacCliVentas )
         TreeBegin()
         for each aItem in ::aDatFacCliVentas
            if ( Empty( cCaja ) .or. aItem[ 1 ] == cCaja )
               TreeAddItem( AllTrim( aItem[ 3 ] ), "Detalles", , , , .f. ):Cargo := { aItem[ 3 ], aItem[ 4 ], aItem[ 5 ], aItem[ 6 ] }
            end if
         next
         TreeEnd()
      end if

   end if

   /*
   Facturas rectificativas-----------------------------------------------------
   */

   if ::nTotRctCliVentas( cCaja ) != 0

      TreeAddItem( "Total facturas rectificativas" ):Cargo := { "Total facturas rectificativas", ::nTotRctCliVentas( cCaja ) }

      if !Empty( ::aDatRctCliVentas )
         TreeBegin()
         for each aItem in ::aDatRctCliVentas
            if ( Empty( cCaja ) .or. aItem[ 1 ] == cCaja )
               TreeAddItem( AllTrim( aItem[ 3 ] ), "Detalles", , , , .f. ):Cargo := { aItem[ 3 ], aItem[ 4 ], aItem[ 5 ], aItem[ 6 ] }
            end if
         next
         TreeEnd()
      end if

   end if

   /*
   Anticipos-------------------------------------------------------------------
   */

   if ::nTotAntCliVentas( cCaja ) != 0
      TreeAddItem( "Total anticipos" ):Cargo := { "Total anticipos", ::nTotAntCliVentas( cCaja ) }

      if !Empty( ::aDatAntCliVentas )
         TreeBegin()
         for each aItem in ::aDatAntCliVentas
            if ( Empty( cCaja ) .or. aItem[ 1 ] == cCaja )
               TreeAddItem( AllTrim( aItem[ 3 ] ), "Detalles", , , , .f. ):Cargo := { aItem[ 3 ], aItem[ 4 ], aItem[ 5 ], aItem[ 6 ] }
            end if
         next
         TreeEnd()
      end if
   end if

   /*
   Tickets-----------------------------------------------------------------
   */

   if ::nTotTikCliVentas( cCaja ) != 0

      TreeAddItem( "Total tickets" ):Cargo := { "Total tickets", ::nTotTikCliVentas( cCaja ) }

      if !Empty( ::aDatTikCliVentas )
         TreeBegin()
         for each aItem in ::aDatTikCliVentas
            if ( Empty( cCaja ) .or. aItem[ 1 ] == cCaja )
               TreeAddItem( AllTrim( aItem[ 3 ] ), "Detalles", , , , .f. ):Cargo := { aItem[ 3 ], aItem[ 4 ], aItem[ 5 ], aItem[ 6 ] }
            end if
         next
         TreeEnd()
      end if

   end if

   /*
   Cheques---------------------------------------------------------------------
   */

   if ::nTotTikCliCheques( cCaja ) != 0

      TreeAddItem( "Total cheques regalo" ):Cargo := { "Total cheques regalo", ::nTotTikCliCheques( cCaja ) }

      if !Empty( ::aDatChkCliVentas )
         TreeBegin()
         for each aItem in ::aDatChkCliVentas
            if ( Empty( cCaja ) .or. aItem[ 1 ] == cCaja )
               TreeAddItem( AllTrim( aItem[ 3 ] ), "Detalles", , , , .f. ):Cargo := { aItem[ 3 ], aItem[ 4 ], aItem[ 5 ], aItem[ 6 ] }
            end if
         next
         TreeEnd()
      end if

   end if

   /*
   Devoluciones-------------------------------------------------------------
   */

   if ::nTotDevCliVentas( cCaja ) != 0
      TreeAddItem( "Total devoluciones" ):Cargo := { "Total devoluciones", ::nTotDevCliVentas( cCaja ) }

      if !Empty( ::aDatDevCliVentas )
         TreeBegin()
         for each aItem in ::aDatDevCliVentas
            if ( Empty( cCaja ) .or. aItem[ 1 ] == cCaja )
               TreeAddItem( AllTrim( aItem[ 3 ] ), "Detalles", , , , .f. ):Cargo := { aItem[ 3 ], aItem[ 4 ], aItem[ 5 ], aItem[ 6 ] }
            end if
         next
         TreeEnd()
      end if
   end if

   /*
   Total ventas-------------------------------------------------------------
   */

   TreeAddItem( "" ):Cargo := { Space( 3 ) + "TOTAL VENTAS" + Replicate( ".", 200 ), ::nTotVentas( cCaja ) }

   /*
   Total objetivos de ventas---------------------------------------------------
   */

   if ::nTotCajaObjetivo( cCaja ) != 0

      TreeAddItem( "Total objetivo" ):Cargo        := { Space( 3 ) + "TOTAL OBJETIVO" + Replicate( ".", 200 ), ::nTotCajaObjetivo( cCaja ) }
      TreeAddItem( "Diferencia objetivo" ):Cargo   := { Space( 3 ) + "Diferencia objetivo" + Replicate( ".", 200 ), ::nTotVentas( cCaja ) - ::nTotCajaObjetivo( cCaja ) }

   end if

   /*
   Espacio---------------------------------------------------------------------
   */

   TreeAddItem( "Espacio" ):Cargo := { "", 0 }

   /*
   Albaranes de compras--------------------------------------------------------
   */

   if ::nTotAlbPrvCompras( cCaja ) != 0
      TreeAddItem( "Total albaranes" ):Cargo := { "Total albaranes", ::nTotAlbPrvCompras( cCaja ) }

      if !Empty( ::aDatAlbPrvCompras )
         TreeBegin()
         for each aItem in ::aDatAlbPrvCompras
            if ( Empty( cCaja ) .or. aItem[ 1 ] == cCaja )
               TreeAddItem( AllTrim( aItem[ 3 ] ), "Detalles", , , , .f. ):Cargo := { aItem[ 3 ], aItem[ 4 ], aItem[ 5 ], aItem[ 6 ] }
            end if
         next
         TreeEnd()
      end if

   end if

   /*
   Facturas-----------------------------------------------------------------
   */

   if ::nTotFacPrvCompras( cCaja ) != 0
      TreeAddItem( "Total facturas" ):Cargo := { "Total facturas", ::nTotFacPrvCompras( cCaja ) }

      if !Empty( ::aDatFacPrvCompras )
         TreeBegin()
         for each aItem in ::aDatFacPrvCompras
            if ( Empty( cCaja ) .or. aItem[ 1 ] == cCaja )
               TreeAddItem( AllTrim( aItem[ 3 ] ), "Detalles", , , , .f. ):Cargo := { aItem[ 3 ], aItem[ 4 ], aItem[ 5 ], aItem[ 6 ] }
            end if
         next
         TreeEnd()
      end if

   end if

   /*
   Facturas rectificativas-----------------------------------------------------------------
   */

   if ::nTotRctPrvCompras( cCaja ) != 0
      TreeAddItem( "Total facturas rectificativas" ):Cargo := { "Total facturas rectificativas", ::nTotRctPrvCompras( cCaja ) }

      if !Empty( ::aDatRctPrvCompras )
         TreeBegin()
         for each aItem in ::aDatRctPrvCompras
            if ( Empty( cCaja ) .or. aItem[ 1 ] == cCaja )
               TreeAddItem( AllTrim( aItem[ 3 ] ), "Detalles", , , , .f. ):Cargo := { aItem[ 3 ], aItem[ 4 ], aItem[ 5 ], aItem[ 6 ] }
            end if
         next
         TreeEnd()
      end if

   end if

   /*
   Total compras-------------------------------------------------------------
   */

   TreeAddItem( "" ):Cargo := { Space( 3 ) + "TOTAL COMPRAS" + Replicate( ".", 200 ), ::nTotCompras( cCaja ) }

   /*
   Espacio---------------------------------------------------------------------
   */

   TreeAddItem( "Espacio" ):Cargo := { "", 0 }

   /*
   Entregas a cuenta pedidos-----------------------------------------------------------
   */

   if ::nTotPedCliEntregas( cCaja ) != 0
      TreeAddItem( "Total entregas en pedidos" ):Cargo := { "Entregas pedidos", ::nTotPedCliEntregas( cCaja ) }

      if !Empty( ::aDatPedCliEntregas )
         TreeBegin()
         for each aItem in ::aDatPedCliEntregas
            if ( Empty( cCaja ) .or. aItem[ 1 ] == cCaja )
               TreeAddItem( AllTrim( aItem[ 3 ] ), "Detalles", , , , .f. ):Cargo := { aItem[ 3 ], aItem[ 4 ], aItem[ 5 ], aItem[ 6 ] }
            end if
         next
         TreeEnd()
      end if
   end if

   /*
   Entregas a cuenta albaranes-----------------------------------------------------------
   */

   if ::nTotAlbCliEntregas( cCaja ) != 0

      TreeAddItem( "Total entregas en albaranes" ):Cargo := { "Entregas albaranes", ::nTotAlbCliEntregas( cCaja ) }

      if !Empty( ::aDatAlbCliEntregas )
         TreeBegin()
         for each aItem in ::aDatAlbCliEntregas
            if ( Empty( cCaja ) .or. aItem[ 1 ] == cCaja )
               TreeAddItem( AllTrim( aItem[ 3 ] ), "Detalles", , , , .f. ):Cargo := { aItem[ 3 ], aItem[ 4 ], aItem[ 5 ], aItem[ 6 ] }
            end if
         next
         TreeEnd()
      end if

   end if


   /*
   Pagos en tickets------------------------------------------------------------
   */

   if ::nTotTikCliCobros( cCaja ) != 0

      TreeAddItem( "Total tickets" ):Cargo := { "Cobros tickets", ::nTotTikCliCobros( cCaja ) }

      if !Empty( ::aDatTikCliCobros )
         TreeBegin()
         for each aItem in ::aDatTikCliCobros
            if ( Empty( cCaja ) .or. aItem[ 1 ] == cCaja )
               TreeAddItem( AllTrim( aItem[ 3 ] ), "Detalles", , , , .f. ):Cargo := { aItem[ 3 ], aItem[ 4 ], aItem[ 5 ], aItem[ 6 ] }
            end if
         next
         TreeEnd()
      end if

   end if

   /*
   Pagos en facturas-----------------------------------------------------------
   */

   if ::nTotFacCliCobros( cCaja ) != 0
      TreeAddItem( "Total Facturas" ):Cargo := { "Cobros facturas", ::nTotFacCliCobros( cCaja ) }

      if !Empty( ::aDatFacCliCobros )
         TreeBegin()
         for each aItem in ::aDatFacCliCobros
            if ( Empty( cCaja ) .or. aItem[ 1 ] == cCaja )
               TreeAddItem( AllTrim( aItem[ 3 ] ), "Detalles", , , , .f. ):Cargo := { aItem[ 3 ], aItem[ 4 ], aItem[ 5 ], aItem[ 6 ] }
            end if
         next
         TreeEnd()
      end if
   end if

   /*
   Contadores------------------------------------------------------------------
   */

   nCont       := ::nContadores
   nCont       -= ::nTotAlbCliContadores( cCaja )
   nCont       -= ::nTotFacCliContadores( cCaja )
   nCont       -= ::nTotTikCliContadores( cCaja )

   if nCont > 0
      TreeAddItem( "Contadores" ):Cargo := { "Total contadores", nCont }
   end if

   /*
   Entradas y salidas-----------------------------------------------------------
   */

   if ::nTotEntradas( cCaja ) != 0

      TreeAddItem( "Total Entradas" ):Cargo := { "Entradas y salidas", ::nTotEntradas( cCaja ) }

      if !Empty( ::aDatEntradas )
         TreeBegin()
         for each aItem in ::aDatEntradas
            if ( Empty( cCaja ) .or. aItem[ 1 ] == cCaja )
               TreeAddItem( AllTrim( aItem[ 3 ] ), "Detalles", , , , .f. ):Cargo := { aItem[ 3 ], aItem[ 4 ], aItem[ 5 ], aItem[ 6 ] }
            end if
         next
         TreeEnd()
      end if

   end if

   /*
   Entradas y salidas-----------------------------------------------------------
   */

   if ::nTotFacPrvPagos( cCaja ) != 0

      TreeAddItem( "Total Pagos" ):Cargo := { "Pagos facturas", ::nTotFacPrvPagos( cCaja ) }

      if !Empty( ::aDatFacPrvPagos )
         TreeBegin()
         for each aItem in ::aDatFacPrvPagos
            if ( Empty( cCaja ) .or. aItem[ 1 ] == cCaja )
               TreeAddItem( AllTrim( aItem[ 3 ] ), "Detalles", , , , .f. ):Cargo := { aItem[ 3 ], aItem[ 4 ], aItem[ 5 ], aItem[ 6 ] }
            end if
         next
         TreeEnd()
      end if

   end if

   /*
   Total cobros----------------------------------------------------------------
   */

   TreeAddItem( "" ):Cargo := { Space( 3 ) + "TOTAL OPERACIONES DE CAJA" + Replicate( ".", 200 ), ::nTotCaja( cCaja ) }

   /*
   Espacio---------------------------------------------------------------------
   */

   if ::nTotCobroEfectivo( cCaja ) != 0 .or. ::nTotPagoEfectivo( cCaja ) != 0
      TreeAddItem( "Espacio" ):Cargo := { "", 0 }
   end if

   /*
   Total cobros esfectivos-----------------------------------------------------------
   */

   if ::nTotCobroEfectivo( cCaja ) != 0

      TreeAddItem( "Total cobros efectivo" ):Cargo := { "Total cobros efectivo", ::nTotCobroEfectivo( cCaja ) + nCont }

      if !Empty( ::aDatCobroEfectivo )

         TreeBegin()

         for each aItem in ::aDatCobroEfectivo
            if ( Empty( cCaja ) .or. aItem[ 1 ] == cCaja )
               TreeAddItem( AllTrim( aItem[ 3 ] ), "Detalles", , , , .f. ):Cargo := { aItem[ 3 ], aItem[ 4 ], aItem[ 5 ], aItem[ 6 ] }
            end if
         next

         if nCont > 0
            TreeAddItem( "Contadores", "Detalles", , , , .f. ):Cargo := { "Contadores", nCont }
         end if

         TreeEnd()

      end if

   end if

   /*
   Total pagos efectivos------------------------------------------------------------
   */

   if ::nTotPagoEfectivo( cCaja ) != 0

      TreeAddItem( "Total pagos efectivo" ):Cargo := { "Total pagos efectivo", ::nTotPagoEfectivo( cCaja ) }

      if !Empty( ::aDatpagoEfectivo )

         TreeBegin()

         for each aItem in ::aDatPagoEfectivo
            if ( Empty( cCaja ) .or. aItem[ 1 ] == cCaja )
               TreeAddItem( AllTrim( aItem[ 3 ] ), "Detalles", , , , .f. ):Cargo := { aItem[ 3 ], aItem[ 4 ], aItem[ 5 ], aItem[ 6 ] }
            end if
         next

         TreeEnd()

      end if

   end if

   /*
   Saldo en efectivo-----------------------------------------------------------
   */

   if ::nTotCobroEfectivo( cCaja ) != 0 .or. ::nTotPagoEfectivo( cCaja ) != 0
      TreeAddItem( "Total saldo efectivo" ):Cargo := { "Total saldo efectivo", ::nTotSaldoEfectivo( cCaja ) }
   end if

   /*
   Espacio---------------------------------------------------------------------
   */

   if ::nTotCobroNoEfectivo( cCaja ) != 0 .or. ::nTotPagoNoEfectivo( cCaja ) != 0
      TreeAddItem( "Espacio" ):Cargo := { "", 0 }
   end if

   /*
   Cobro no efectivo-----------------------------------------------------------
   */

   if ::nTotCobroNoEfectivo( cCaja ) != 0

      TreeAddItem( "Total cobros no efectivo" ):Cargo := { "Total cobros no efectivo", ::nTotCobroNoEfectivo( cCaja ) + nCont }

      if !Empty( ::aDatCobroNoEfectivo )

         TreeBegin()

         for each aItem in ::aDatCobroNoEfectivo
            if ( Empty( cCaja ) .or. aItem[ 1 ] == cCaja )
               TreeAddItem( AllTrim( aItem[ 3 ] ), "Detalles", , , , .f. ):Cargo := { aItem[ 3 ], aItem[ 4 ], aItem[ 5 ], aItem[ 6 ] }
            end if
         next

         TreeEnd()

      end if

   end if

   /*
   Cobro por bancos------------------------------------------------------------
   */

   if ::nTotBancos( cCaja ) != 0

      TreeAddItem( "Total operaciones cuentas bancarias", , , , , .t. ):Cargo := { "Total operaciones cuentas bancarias", ::nTotBancos( cCaja ) + nCont }

      if !Empty( ::aTotBancos )

         TreeBegin()

         for each aItem in ::aTotBancos

            if ( Empty( cCaja ) .or. aItem[ 1 ] == cCaja )

               TreeAddItem( aItem[ 2 ] ):Cargo := { Space( 3 ) + "Operaciones cuenta bancaria : " + Alltrim( aItem[ 2 ] ), aItem[ 3 ], "", "" }

               if !Empty( ::aDatBancos )

                  TreeBegin()

                  for each aSubItem in ::aDatBancos

                     if ( ( Empty( cCaja ) .or. aSubItem[ 1 ] == cCaja ) .and. ( aSubItem[ 2 ] == aItem[ 2 ] ) )

                        TreeAddItem( AllTrim( aSubItem[ 3 ] ), "Detalles", , , , .f. ):Cargo := { aSubItem[ 3 ], aSubItem[ 4 ], aSubItem[ 5 ], aSubItem[ 6 ] }

                     end if

                  next

                  TreeEnd()

               end if

               if !Empty( ::oTurno )
                  nSaldoActual   := ::oTurno:oCuentasBancarias:nSaldoActual( aItem[ 2 ] )
                  nSaldoTotal    += nSaldoActual
               end if

               TreeAddItem( aItem[ 2 ] ):Cargo := { Space( 3 ) + "Saldo actual cuenta bancaria " + Alltrim( aItem[ 2 ] ), nSaldoActual, "", "" }

            end if

         next

         TreeEnd()

      end if

      TreeAddItem( "Total saldos cuentas bancarias" ):Cargo := { "Total saldos cuentas bancarias", nSaldoTotal }

   end if

   /*
   Total pagos no efectivos----------------------------------------------------
   */

   if ::nTotPagoNoEfectivo( cCaja ) != 0

      TreeAddItem( "Total pagos no efectivo" ):Cargo := { "Total pagos no efectivo", ::nTotPagoNoEfectivo( cCaja ) }

      if !Empty( ::aDatPagoNoEfectivo )

         TreeBegin()

         for each aItem in ::aDatPagoNoEfectivo
            if ( Empty( cCaja ) .or. aItem[ 1 ] == cCaja )
               TreeAddItem( AllTrim( aItem[ 3 ] ), "Detalles", , , , .f. ):Cargo := { aItem[ 3 ], aItem[ 4 ], aItem[ 5 ], aItem[ 6 ] }
            end if
         next

         TreeEnd()

      end if

   end if

   /*
   Saldo no efectivo-----------------------------------------------------------
   */

   if ::nTotCobroNoEfectivo( cCaja ) != 0 .or. ::nTotPagoNoEfectivo( cCaja ) != 0
      TreeAddItem( "Total saldo no efectivo" ):Cargo := { "Total saldo no efectivo", ::nTotSaldoNoEfectivo( cCaja ) }
   end if

   /*
   Espacio---------------------------------------------------------------------
   */

   if ::nTotCobroTarjeta( cCaja ) != 0 .or. ::nTotPagoTarjeta( cCaja ) != 0
      TreeAddItem( "Espacio" ):Cargo := { "", 0 }
   end if

   /*
   Cobro con tarjetas----------------------------------------------------------
   */

   if ::nTotCobroTarjeta( cCaja ) != 0

      TreeAddItem( "Total cobros tarjeta" ):Cargo := { "Total cobros tarjeta", ::nTotCobrotarjeta( cCaja ) }

      if !Empty( ::aDatCobroTarjeta )
         TreeBegin()
         for each aItem in ::aDatCobroTarjeta
            if ( Empty( cCaja ) .or. aItem[ 1 ] == cCaja )
               TreeAddItem( AllTrim( aItem[ 3 ] ), "Detalles", , , , .f. ):Cargo := { aItem[ 3 ], aItem[ 4 ], aItem[ 5 ], aItem[ 6 ] }
            end if
         next
         TreeEnd()
      end if

   end if

   /*
   Pago con tarjetas----------------------------------------------------------
   */

   if ::nTotPagoTarjeta( cCaja ) != 0

      TreeAddItem( "Total pagos tarjeta" ):Cargo := { "Total pagos tarjeta", ::nTotPagotarjeta( cCaja ) }

      if !Empty( ::aDatPagoTarjeta )
         TreeBegin()
         for each aItem in ::aDatPagoTarjeta
            if ( Empty( cCaja ) .or. aItem[ 1 ] == cCaja )
               TreeAddItem( AllTrim( aItem[ 3 ] ), "Detalles", , , , .f. ):Cargo := { aItem[ 3 ], aItem[ 4 ], aItem[ 5 ], aItem[ 6 ] }
            end if
         next
         TreeEnd()
      end if
   end if

   /*
   Saldo no efectivo-----------------------------------------------------------
   */

   if ::nTotCobroTarjeta( cCaja ) != 0 .or. ::nTotPagoTarjeta( cCaja ) != 0
      TreeAddItem( "Total saldo tarjeta" ):Cargo := { "Total saldo tarjeta", ::nTotSaldoTarjeta( cCaja ) }
   end if

   /*
   Espacio---------------------------------------------------------------------
   */

   TreeAddItem( "Espacio" ):Cargo := { "", 0 }

   if ::nTotNumeroAlbaranes( cCaja ) != 0
      TreeAddItem( "Número de albaranes" ):Cargo := { "Número de albaranes", ::nTotNumeroAlbaranes( cCaja )  }
   end if

   if ::nTotNumeroFacturas( cCaja ) != 0
      TreeAddItem( "Número de facturas" ):Cargo := { "Número de facturas", ::nTotNumeroFacturas( cCaja )  }
   end if

   if ::nTotNumeroTikets( cCaja ) != 0
      TreeAddItem( "Número de tickets" ):Cargo := { "Número de tickets", ::nTotNumeroTikets( cCaja )  }
   end if

   if ::nTotNumeroCheques( cCaja ) != 0
      TreeAddItem( "Número de cheques regalo" ):Cargo := { "Número de cheques regalo", ::nTotNumeroCheques( cCaja )  }
   end if

   if ::nTotNumeroVales( cCaja ) != 0
      TreeAddItem( "Número de vales" ):Cargo := { "Número de vales", ::nTotNumeroVales( cCaja )  }
   end if

   if ::nTotNumeroDevoluciones( cCaja ) != 0
      TreeAddItem( "Número de devoluciones" ):Cargo := { "Número de devoluciones", ::nTotNumeroDevoluciones( cCaja )  }
   end if

   if ::nTotNumeroAptCajon( cTurno, cCaja ) != 0
      TreeAddItem( "Número de aperturas de cajón" ):Cargo := { "Número de apertura de cajón :" + cTurno, ::nTotNumeroAptCajon( cTurno, cCaja )  }
   end if

   TreeEnd()

Return ( oTree )

//---------------------------------------------------------------------------//

Static Function nImporte( cCaja, cSerie, aData, lAbs )

   local nImporte    := 0

   DEFAULT lAbs      := .f.

   aEval( aData, {|a| if( ( Empty( cCaja ) .or. a[ 1 ] == cCaja ) .and. ( Empty( cSerie ) .or. a[ 2 ] == cSerie ), if( IsNum( a[ 3 ] ), nImporte += a[ 3 ], ), ) } )

Return ( if( lAbs, Abs( nImporte ), nImporte ) )

//---------------------------------------------------------------------------//

Static Function nNumero( cCaja, aData )

   local nContador   := 0

   aEval( aData, {|a| if( Empty( cCaja ) .or. a[ 1 ] == cCaja, nContador += a[ 2 ], ) } )

Return ( nContador )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//----------------------------------------------------------------------------//

function TreeInit()

   aTrees   := {}
   nLevel   := 0

return nil

//----------------------------------------------------------------------------//

function TreeBegin( cBmpOpen, cBmpClose )

   local oTree    := TLinkList()

   if ! Empty( cBmpOpen )
      hBmpOpen    := LoadBitmap( GetResources(), cBmpOpen )
   endif

   if ! Empty( cBmpClose )
      hBmpClose   := LoadBitmap( GetResources(), cBmpClose )
   endif

   AAdd( aTrees, oTree )

   nLevel++

return oTree

//----------------------------------------------------------------------------//

