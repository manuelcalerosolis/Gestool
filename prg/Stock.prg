#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TStock

   CLASSDATA aStocks
   CLASSDATA cCodigoAlmacen
   CLASSDATA cCodigoArticulo

   CLASSDATA dConsolidacion

   CLASSDATA aCacheStockActual      INIT {}                
   CLASSDATA aConsolidacion         INIT {}

   DATA cPath
   DATA cDriver

   DATA cName                       INIT "Stocks"

   DATA lNotPendiente               INIT .f.

   DATA lStockInit                  INIT .f.

   DATA uCodigoAlmacen  

   DATA cAlm
   DATA cArticulo

   DATA cSatCliT
   DATA cSatCliL

   DATA cPedCliT
   DATA cPedCliL
   DATA cPedCliR
   DATA cPedCliS

   DATA cAlbCliT
   DATA cAlbCliL
   DATA cAlbCliS

   DATA cAlqCliT
   DATA cAlqCliL

   DATA cFacCliT
   DATA cFacCliL
   DATA cFacCliP
   DATA cFacCliS

   DATA cFacRecT
   DATA cFacRecL
   DATA cFacRecS

   DATA cAntCliT

   DATA cPedPrvT
   DATA cPedPrvL

   DATA cAlbPrvT
   DATA cAlbPrvL
   DATA cAlbPrvS

   DATA cFacPrvT
   DATA cFacPrvL
   DATA cFacPrvS

   DATA cRctPrvT
   DATA cRctPrvL
   DATA cRctPrvS

   DATA cProducT
   DATA cProducL
   DATA cProducM
   DATA cProducS
   DATA cProducP

   DATA cDbfIva
   DATA cDbfDiv
   DATA cDbfFPago

   DATA nDouDiv
   DATA nDorDiv
   DATA nDinDiv
   DATA nDirDiv
   DATA cPicUnd
   DATA nVdvDiv
   DATA nDecIn
   DATA nDerIn

   DATA cKit

   DATA cTikT
   DATA cTikL
   DATA cTikP
   DATA cTikS

   DATA tmpAlbCliL
   DATA tmpAlbCliS
   DATA tmpFacCliL
   DATA tmpFacCliS
   DATA tmpFacRecL
   DATA tmpFacRecS

   DATA aSeries                              AS ARRAY INIT {}

   DATA oTree  

   DATA dFechaInicio
   DATA tHoraInicio
   DATA dFechaFin
   DATA tHoraFin

   DATA aMovAlm                              AS ARRAY INIT {}

   DATA lAlbPrv                              AS LOGIC INIT .t.
   DATA lAlbCli                              AS LOGIC INIT .t.

   DATA lIntegra                             AS LOGIC INIT .t.

   DATA lLote                                AS LOGIC INIT .f.
   DATA lNumeroSerie                         AS LOGIC INIT .f.

   DATA oDbfStock
   DATA cDbfStock
   DATA cCdxStock

   DATA aAlmacenes                           AS ARRAY INIT {}

   DATA lCalculateUnidadesPendientesRecibir  AS LOGIC INIT .f.

   METHOD New( cPath, cDriver )
   METHOD Create( cPath, cDriver )
   METHOD End()                              INLINE ( if( !empty( ::oTree ), ::oTree:End(), ), ::CloseFiles() )

   METHOD Reset()                            INLINE ( ::aStocks := {}, ::aConsolidacion := {} )

   METHOD setNotPendiente( lNotPendiente)    INLINE ( ::lNotPendiente := lNotPendiente )
   METHOD getNotPendiente()                  INLINE ( ::lNotPendiente )

   METHOD lOpenFiles()
   METHOD CloseFiles()

   METHOD OpenService()                      INLINE ( ::lOpenFiles() )
   METHOD CloseService()                     INLINE ( ::CloseFiles() )

   METHOD CreateTemporalFiles( cPath )
   METHOD DeleteTemporalFiles( cPath )
   METHOD Zap()

   METHOD PedPrv( cNumPed, cCodAlm, lDelete, lIncremento )

   METHOD AlbPrv( cNumAlb, cCodAlm, cNumPed, lDelete, lIncremento, lIgnEstado )

   METHOD FacPrv( cNumFac, cCodAlm, lDelete, lIncremento )
   METHOD ChkFacPrv( cNumFac )

   METHOD RctPrv( cNumFac, cCodAlm, lDelete, lIncremento )
   METHOD ChkRctPrv( cNumFac )

   METHOD PedCli( cNumPed, cCodAlm, lDelete, lIncremento )

   METHOD AlbCli( cNumAlb, cCodAlm, lDelete, lIncremento, lIgnEstado, lChequea )
   METHOD ChkAlbCli( cNumAlb )

   METHOD AlqCli( cNumAlq, cCodAlm, lDelete, lIncremento, lIgnEstado, lChequea )

   METHOD FacCli( cNumFac, cCodAlm, lDelete, lIncremento )
   METHOD ChkFacCli( cNumFac )

   METHOD FacRec( cNumFac, cCodAlm, lDelete, lIncremento )

   METHOD TpvCli( cNumFac, cCodAlm, lIncremento )
   METHOD ChkTikCli( cNumTik )

   METHOD nSQLStockActual( cCodArt, cCodAlm, cValPr1, cValPr2 )
      METHOD nSQLGlobalStockActual( cCodArt, cCodAlm )

   METHOD nTotStockAct()
      METHOD nCacheStockActual() 
      METHOD addCacheStockActual()
      METHOD scanCacheStockActual()
      METHOD getCacheStockActual()
      METHOD deleteCacheStockActual()
      METHOD recalculateCacheStockActual()

   METHOD nPutStockActual( cCodArt, cCodAlm, cValPr1, cValPr2, cLote, lKitAct, nKitStk, oSay )

   METHOD lPutStockActual( cCodArt, cCodAlm, cValPr1, cValPr2, cLote, lKitAct, nKitStk, oSay )

   METHOD Recalcula( oMeter, cPath )

   METHOD StockInit( cPath, cPathOld, oMsg, lGrupo )

   METHOD nStockReservado( cCodArt, cValPr1, cValPr2 )

   METHOD SetEstadoPedCli( cNumPed )
   METHOD SetEstadoSatCli( cNumPed )

   METHOD SetRecibidoPedCli( cNumPed )
   METHOD SetGeneradoPedCli( cNumPed )

   METHOD SetPedPrv( cNumPed )

   METHOD nStockAlmacen( cCodArt, cCodAlm, cValPr1, cValPr2, cLote )

   METHOD nTotalSaldo( cCodArt, cCodCli )

   METHOD nSaldoDocumento( cCodArt, cNumDoc )

   METHOD nSaldoAnterior( cCodArt, cCodCli, cNumDoc )

   METHOD nSaldoAntAlb( cCodArt, cNumDoc )

   METHOD nSaldoDocAlb( cCodArt, cNumDoc )

   METHOD Almacenes()

   METHOD aStockArticulo( cCodArt )
      METHOD nStockArticulo( cCodArt )
      METHOD nBultosArticulo( cCodArt )

      METHOD aStockMovimientosAlmacen()
      METHOD aStockAlbaranProveedor()
      METHOD aStockFacturaProveedor()
      METHOD aStockRectificativaProveedor()

      METHOD aStockPedidoCliente()

      METHOD aStockAlbaranCliente()
      METHOD aStockFacturaCliente()
      METHOD aStockRectificativaCliente()
      METHOD aStockTicketsCliente()
      METHOD aStockProduccion()
      METHOD aStockMateriaPrima()
      METHOD aStockPendiente()
   
      METHOD Integra( sStock )

   METHOD nOperacionesCliente(idCliente, lRiesgo)
   METHOD nPedidoCliente( idCliente )
   METHOD nConsumoArticulo( cCodArt, cCodAlm, cLote, dFecIni, dFecFin )

   METHOD lValidNumeroSerie( cCodArt, cCodAlm, nNumSer, lMessage ) INLINE ( .t. )

   METHOD BrowseNumeroSerie( cCodArt, cCodAlm )

   METHOD SetTmpAlbCliL( tmpAlbCliL )        INLINE   ( ::tmpAlbCliL := tmpAlbCliL )
   METHOD SetTmpAlbCliS( tmpAlbCliS )        INLINE   ( ::tmpAlbCliS := tmpAlbCliS )

   METHOD SetTmpFacCliL( tmpFacCliL )        INLINE   ( ::tmpFacCliL := tmpFacCliL )
   METHOD SetTmpFacCliS( tmpFacCliS )        INLINE   ( ::tmpFacCliS := tmpFacCliS )

   METHOD SetTmpFacRecL( tmpFacRecL )        INLINE   ( ::tmpFacRecL := tmpFacRecL )
   METHOD SetTmpFacRecS( tmpFacRecS )        INLINE   ( ::tmpFacRecS := tmpFacRecS )

   METHOD nRiesgo( idCliente )          // INLINE   ( ::nOperacionesCliente( idCliente, .t. ) )
   METHOD nFacturado( idCliente )            INLINE   ( ::nOperacionesCliente( idCliente, .f. ) )

   METHOD SetRiesgo( idCliente, oGetRiesgo, nRiesgoCliente )

   METHOD nCostoMedio( cCodArt, cCodAlm, cCodPr1, cCodPr2, cValPr1, cValPr2, cLote )

   METHOD lCheckConsolidacion()

   METHOD lValoracionCostoMedio( nTipMov )

   METHOD lAvisarSerieSinStock( cCodigo )    INLINE   ( RetFld( cCodigo, ::cArticulo, "lMsgSer" ) )

   METHOD oTreeStocks()

   //---------------------------------------------------------------------------//

   METHOD InsertStockMovimientosAlmacenRowset( oRowSet, lDestino )

   METHOD InsertStockAlbaranProveedores( lNumeroSerie )
   METHOD DeleteStockAlbaranProveedores( lNumeroSerie )

   METHOD InsertStockFacturaProveedores( lNumeroSerie )
   METHOD DeleteStockFacturaProveedores( lNumeroSerie )

   METHOD InsertStockRectificativaProveedores( lNumeroSerie )
   METHOD DeleteStockRectificativaProveedores( lNumeroSerie )

   METHOD InsertStockPedidoClientes( lNumeroSerie )
   METHOD InsertStockAlbaranClientes( lNumeroSerie )
   METHOD InsertStockFacturaClientes( lNumeroSerie )
   METHOD InsertStockRectificativaClientes( lNumeroSerie )
   METHOD InsertStockTiketsClientes( lNumeroSerie, lCombinado )
   METHOD InsertStockMaterialesProducidos( lNumeroSerie )
   METHOD InsertStockMateriasPrimas( lNumeroSerie )
   METHOD InsertStockPendiente()

   METHOD nUnidadesInStock()  
   METHOD nPendientesRecibirInStock()  
   METHOD nPendientesEntregarInStock()  

   METHOD setCodigoAlmacen( cCodigoAlmacen )
   METHOD lCodigoAlmacen( cCodigoAlmacen )

   METHOD getFechaHoraConsolidacion()

   METHOD validateDateTime( dFecMov, tTimMov )

   METHOD nFacturacionPendiente( idCliente )

   METHOD nPagadoCliente( idCliente )

   METHOD nFacturacionCliente( idCliente )

   METHOD aStockArticuloEmpresa( cCodArt, cCodEmp ) INLINE ( ::aStockArticulo( cCodArt,,,,,,,,, cCodEmp ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD Create( cPath, cDriver ) CLASS TStock

   DEFAULT cPath        := cPatEmp()
   DEFAULT cDriver      := cDriver()

   ::cPath              := cPath
   ::cDriver            := cDriver

   ::Reset()

RETURN Self

//---------------------------------------------------------------------------//

METHOD New( cPath, cDriver ) CLASS TStock

   ::Create( cPath, cDriver )

   ::lOpenFiles()

RETURN Self

//---------------------------------------------------------------------------//

METHOD lOpenFiles() CLASS TStock

   local lOpen          := .t.
   local oError
   local oBlock

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      /*
      Pedidos de clientes------------------------------------------------------
      */

      ::cSatCliT        := cCheckArea( "SatCliT" )
      ::cSatCliL        := cCheckArea( "SatCliL" )

      ::cPedCliT        := cCheckArea( "PedCliT" )
      ::cPedCliL        := cCheckArea( "PedCliL" )
      ::cPedCliR        := cCheckArea( "PedCliR" )

      ::cAlbCliT        := cCheckArea( "AlbCliT" )
      ::cAlbCliL        := cCheckArea( "AlbCliL" )
      ::cAlbCliS        := cCheckArea( "AlbCliS" )

      ::cFacCliT        := cCheckArea( "FacCliT" ) 
      ::cFacCliL        := cCheckArea( "FacCliL" ) 
      ::cFacCliS        := cCheckArea( "FacCliS" ) 

      ::cFacCliP        := cCheckArea( "FacCliP" ) 

      ::cFacRecT        := cCheckArea( "FacRecT" ) 
      ::cFacRecL        := cCheckArea( "FacRecL" ) 
      ::cFacRecS        := cCheckArea( "FacRecS" ) 

      ::cAntCliT        := cCheckArea( "AntCliT" )
      
      ::cTikT           := cCheckArea( "TikT"    ) 
      ::cTikL           := cCheckArea( "TikL"    ) 
      ::cTikS           := cCheckArea( "TikS"    ) 

      ::cPedPrvT        := cCheckArea( "PedPrvT" ) 
      ::cPedPrvL        := cCheckArea( "PedPrvL" ) 

      ::cAlbPrvL        := cCheckArea( "AlbPrvL" ) 
      ::cAlbPrvS        := cCheckArea( "AlbPrvS" ) 

      ::cFacPrvL        := cCheckArea( "FacPrvL" ) 
      ::cFacPrvS        := cCheckArea( "FacPrvS" ) 

      ::cRctPrvL        := cCheckArea( "RctPrvL" ) 
      ::cRctPrvS        := cCheckArea( "RctPrvS" ) 

      ::cProducL        := cCheckArea( "ProducL" ) 
      ::cProducM        := cCheckArea( "ProducM" ) 
      ::cProducS        := cCheckArea( "ProducS" ) 
      ::cProducP        := cCheckArea( "ProducP" ) 

      ::cArticulo       := cCheckArea( "Articulo") 
      ::cKit            := cCheckArea( "Kit"     ) 

      ::cAlm            := cCheckArea( "Almacen" )

      ::cDbfIva         := cCheckArea( "TIva" )
      ::cDbfDiv         := cCheckArea( "Divisas" )
      ::cDbfFPago       := cCheckArea( "FPAGO" )

      ::nDouDiv         := nDouDiv()
      ::nDorDiv         := nRouDiv()
      ::nDinDiv         := nDinDiv() // Decimales sin redondeo
      ::nDirDiv         := nRinDiv() // Decimales con redondeo
      ::nVdvDiv         := nChgDiv()
      ::nDecIn          := nDinDiv()
      ::nDerIn          := nRinDiv()

      USE ( cPatEmp() + "SatCliT.DBF" ) NEW VIA ( ::cDriver ) SHARED ALIAS ( ::cSatCliT )
      SET ADSINDEX TO ( cPatEmp() + "SatCliT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "SatCliL.DBF" ) NEW VIA ( ::cDriver ) SHARED ALIAS ( ::cSatCliL )
      SET ADSINDEX TO ( cPatEmp() + "SatCliL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PedCliT.Dbf" ) NEW VIA ( ::cDriver ) SHARED ALIAS ( ::cPedCliT )
      SET ADSINDEX TO ( cPatEmp() + "PedCliT.Cdx" ) ADDITIVE

      USE ( cPatEmp() + "PedCliL.Dbf" ) NEW VIA ( ::cDriver ) SHARED ALIAS ( ::cPedCliL )
      SET ADSINDEX TO ( cPatEmp() + "PedCliL.Cdx" ) ADDITIVE

      USE ( cPatEmp() + "PedCliR.Dbf" ) NEW VIA ( ::cDriver ) SHARED ALIAS ( ::cPedCliR )
      SET ADSINDEX TO ( cPatEmp() + "PedCliR.Cdx" ) ADDITIVE

      USE ( cPatEmp() + "AlbCliT.Dbf" ) NEW VIA ( ::cDriver ) SHARED ALIAS ( ::cAlbCliT )
      SET ADSINDEX TO ( cPatEmp() + "AlbCliT.Cdx" ) ADDITIVE

      USE ( cPatEmp() + "AlbCliL.Dbf" ) NEW VIA ( ::cDriver ) SHARED ALIAS ( ::cAlbCliL )
      SET ADSINDEX TO ( cPatEmp() + "AlbCliL.Cdx" ) ADDITIVE

      USE ( cPatEmp() + "AlbCliS.Dbf" ) NEW VIA ( ::cDriver ) SHARED ALIAS ( ::cAlbCliS )
      SET ADSINDEX TO ( cPatEmp() + "AlbCliS.Cdx" ) ADDITIVE

      USE ( cPatEmp() + "FacCliT.Dbf" ) NEW VIA ( ::cDriver ) SHARED ALIAS ( ::cFacCliT )
      SET ADSINDEX TO ( cPatEmp() + "FacCliT.Cdx" ) ADDITIVE

      USE ( cPatEmp() + "FacCliL.Dbf" ) NEW VIA ( ::cDriver ) SHARED ALIAS ( ::cFacCliL )
      SET ADSINDEX TO ( cPatEmp() + "FacCliL.Cdx" ) ADDITIVE

      USE ( cPatEmp() + "FacCliS.Dbf" ) NEW VIA ( ::cDriver ) SHARED ALIAS ( ::cFacCliS )
      SET ADSINDEX TO ( cPatEmp() + "FacCliS.Cdx" ) ADDITIVE

      USE ( cPatEmp() + "FacCliP.Dbf" ) NEW VIA ( ::cDriver ) SHARED ALIAS ( ::cFacCliP )
      SET ADSINDEX TO ( cPatEmp() + "FacCliP.Cdx" ) ADDITIVE

      USE ( cPatEmp() + "AntCliT.DBF" ) NEW VIA ( ::cDriver ) SHARED ALIAS ( ::cAntCliT ) 
      SET ADSINDEX TO ( cPatEmp() + "AntCliT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FacRecT.Dbf" ) NEW VIA ( ::cDriver ) SHARED ALIAS ( ::cFacRecT )
      SET ADSINDEX TO ( cPatEmp() + "FacRecT.Cdx" ) ADDITIVE

      USE ( cPatEmp() + "FacRecL.Dbf" ) NEW VIA ( ::cDriver ) SHARED ALIAS ( ::cFacRecL )
      SET ADSINDEX TO ( cPatEmp() + "FacRecL.Cdx" ) ADDITIVE

      USE ( cPatEmp() + "FacRecS.Dbf" ) NEW VIA ( ::cDriver ) SHARED ALIAS ( ::cFacRecS )
      SET ADSINDEX TO ( cPatEmp() + "FacRecS.Cdx" ) ADDITIVE

      USE ( cPatEmp() + "TikeT.DBF" ) NEW VIA ( ::cDriver ) SHARED ALIAS ( ::cTikT ) 
      SET ADSINDEX TO ( cPatEmp() + "TikeT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "TikeL.DBF" ) NEW VIA ( ::cDriver ) SHARED ALIAS ( ::cTikL ) 
      SET ADSINDEX TO ( cPatEmp() + "TikeL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "TikeS.DBF" ) NEW VIA ( ::cDriver ) SHARED ALIAS ( ::cTikS ) 
      SET ADSINDEX TO ( cPatEmp() + "TikeS.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PedProvT.DBF" ) NEW VIA ( ::cDriver ) SHARED ALIAS ( ::cPedPrvT ) 
      SET ADSINDEX TO ( cPatEmp() + "PedProvT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PedProvL.DBF" ) NEW VIA ( ::cDriver ) SHARED ALIAS ( ::cPedPrvL ) 
      SET ADSINDEX TO ( cPatEmp() + "PedProvL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "AlbProvL.DBF" ) NEW VIA ( ::cDriver ) SHARED ALIAS ( ::cAlbPrvL )
      SET ADSINDEX TO ( cPatEmp() + "AlbProvL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "AlbPrvS.DBF" ) NEW VIA ( ::cDriver ) SHARED ALIAS ( ::cAlbPrvS ) 
      SET ADSINDEX TO ( cPatEmp() + "AlbPrvS.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FacPrvL.DBF" ) NEW VIA ( ::cDriver ) SHARED ALIAS ( ::cFacPrvL )
      SET ADSINDEX TO ( cPatEmp() + "FacPrvL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FacPrvS.DBF" ) NEW VIA ( ::cDriver ) SHARED ALIAS ( ::cFacPrvS ) 
      SET ADSINDEX TO ( cPatEmp() + "FacPrvS.CDX" ) ADDITIVE

      USE ( cPatEmp() + "RctPrvL.DBF" ) NEW VIA ( ::cDriver ) SHARED ALIAS ( ::cRctPrvL )
      SET ADSINDEX TO ( cPatEmp() + "RctPrvL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "RctPrvS.DBF" ) NEW VIA ( ::cDriver ) SHARED ALIAS ( ::cRctPrvS ) 
      SET ADSINDEX TO ( cPatEmp() + "RctPrvS.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ProLin.Dbf" ) NEW VIA ( ::cDriver ) SHARED ALIAS ( ::cProducL ) 
      SET ADSINDEX TO ( cPatEmp() + "ProLin.Cdx" ) ADDITIVE

      USE ( cPatEmp() + "ProMat.Dbf" ) NEW VIA ( ::cDriver ) SHARED ALIAS ( ::cProducM )
      SET ADSINDEX TO ( cPatEmp() + "ProMat.Cdx" ) ADDITIVE

      USE ( cPatEmp() + "ProSer.Dbf" ) NEW VIA ( ::cDriver ) SHARED ALIAS ( ::cProducS )
      SET ADSINDEX TO ( cPatEmp() + "ProSer.Cdx" ) ADDITIVE

      USE ( cPatEmp() + "MatSer.Dbf" ) NEW VIA ( ::cDriver ) SHARED ALIAS ( ::cProducP )
      SET ADSINDEX TO ( cPatEmp() + "MatSer.Cdx" ) ADDITIVE

      USE ( cPatArt() + "Articulo.Dbf" ) NEW VIA ( ::cDriver ) SHARED ALIAS ( ::cArticulo ) 
      SET ADSINDEX TO ( cPatArt() + "Articulo.Cdx" ) ADDITIVE

      USE ( cPatArt() + "ArtKit.Dbf" ) NEW VIA ( ::cDriver ) SHARED ALIAS ( ::cKit ) 
      SET ADSINDEX TO ( cPatArt() + "ArtKit.Cdx" ) ADDITIVE

      USE ( cPatAlm() + "ALMACEN.DBF" ) NEW VIA ( ::cDriver ) SHARED ALIAS ( ::cAlm ) 
      SET ADSINDEX TO ( cPatAlm() + "ALMACEN.CDX" ) ADDITIVE

      USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( ::cDriver ) SHARED ALIAS ( ::cDbfDiv )
      SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

      USE ( cPatDat() + "TIVA.DBF" ) NEW VIA ( ::cDriver ) SHARED ALIAS ( ::cDbfIva )
      SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FPAGO.DBF" ) NEW VIA ( ::cDriver ) SHARED ALIAS ( ::cDbfFPago )
      SET ADSINDEX TO ( cPatEmp() + "FPAGO.CDX" ) ADDITIVE

      // Cargamos los almacenes------------------------------------------------

      ::Almacenes()

   RECOVER USING oError

      lOpen             := .f.

      MsgStop( ErrorMessage( oError ), "Imposible abrir las bases de datos de stocks" )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpen
      ::CloseFiles()
   end if

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TStock

   if ( !empty( ::cSatCliT ), ( ::cSatCliT )->( dbCloseArea() ), )
   if ( !empty( ::cSatCliL ), ( ::cSatCliL )->( dbCloseArea() ), )

   if ( !empty( ::cPedCliT ), ( ::cPedCliT )->( dbCloseArea() ), )
   if ( !empty( ::cPedCliL ), ( ::cPedCliL )->( dbCloseArea() ), )
   if ( !empty( ::cPedCliR ), ( ::cPedCliR )->( dbCloseArea() ), )

   if ( !empty( ::cAlbCliT ), ( ::cAlbCliT )->( dbCloseArea() ), )
   if ( !empty( ::cAlbCliL ), ( ::cAlbCliL )->( dbCloseArea() ), )
   if ( !empty( ::cAlbCliS ), ( ::cAlbCliS )->( dbCloseArea() ), )

   if ( !empty( ::cFacCliT ), ( ::cFacCliT )->( dbCloseArea() ), )
   if ( !empty( ::cFacCliL ), ( ::cFacCliL )->( dbCloseArea() ), )
   if ( !empty( ::cFacCliS ), ( ::cFacCliS )->( dbCloseArea() ), )
   if ( !empty( ::cFacCliP ), ( ::cFacCliP )->( dbCloseArea() ), )

   if ( !empty( ::cFacRecT ), ( ::cFacRecT )->( dbCloseArea() ), )
   if ( !empty( ::cFacRecL ), ( ::cFacRecL )->( dbCloseArea() ), )
   if ( !empty( ::cFacRecS ), ( ::cFacRecS )->( dbCloseArea() ), )

   if ( !empty( ::cTikT ),    ( ::cTikT )->( dbCloseArea() ), )
   if ( !empty( ::cTikL ),    ( ::cTikL )->( dbCloseArea() ), )
   if ( !empty( ::cTikS ),    ( ::cTikS )->( dbCloseArea() ), )

   if ( !empty( ::cAntCliT ), ( ::cAntCliT )->( dbCloseArea() ), )

   if ( !empty( ::cArticulo), ( ::cArticulo )->( dbCloseArea() ), )
   if ( !empty( ::cKit ),     ( ::cKit )->( dbCloseArea() ), )

   if ( !empty( ::cPedPrvT ), ( ::cPedPrvT )->( dbCloseArea() ), )
   if ( !empty( ::cPedPrvL ), ( ::cPedPrvL )->( dbCloseArea() ), )

   if ( !empty( ::cAlbPrvL ), ( ::cAlbPrvL )->( dbCloseArea() ), )
   if ( !empty( ::cAlbPrvS ), ( ::cAlbPrvS )->( dbCloseArea() ), )

   if ( !empty( ::cFacPrvL ), ( ::cFacPrvL )->( dbCloseArea() ), )
   if ( !empty( ::cFacPrvS ), ( ::cFacPrvS )->( dbCloseArea() ), )

   if ( !empty( ::cRctPrvL ), ( ::cRctPrvL )->( dbCloseArea() ), )
   if ( !empty( ::cRctPrvS ), ( ::cRctPrvS )->( dbCloseArea() ), )

   if ( !empty( ::cProducL ), ( ::cProducL )->( dbCloseArea() ), )   
   if ( !empty( ::cProducM ), ( ::cProducM )->( dbCloseArea() ), )   
   if ( !empty( ::cProducS ), ( ::cProducS )->( dbCloseArea() ), )   
   if ( !empty( ::cProducP ), ( ::cProducP )->( dbCloseArea() ), )   

   if ( !empty( ::cAlm ),     ( ::cAlm )->( dbCloseArea() ), )

   if ( !empty( ::cDbfDiv ),  ( ::cDbfDiv )->( dbCloseArea() ), )
   if ( !empty( ::cDbfIva ),  ( ::cDbfIva )->( dbCloseArea() ), )
   if ( !empty( ::cDbfFPago ),( ::cDbfFPago )->( dbCloseArea() ), )

RETURN ( Self )

//---------------------------------------------------------------------------//
//
// Este metodo añade y elimina stock pendiente de recibir por los pedidos a proveedores
//

METHOD PedPrv( cNumPed, cCodAlm, lDelete, lIncremento ) CLASS TStock

   local nUnits

   DEFAULT cCodAlm      := oUser():cAlmacen()
   DEFAULT lDelete      := .t.
   DEFAULT lIncremento  := .t.

   /*
   datos necesarios------------------------------------------------------------
   */

   if ::cPedPrvL == nil .or. cNumPed == nil
      msgStop( "Imposible realizar la actualización de stocks.", "Atención" )
      RETURN self
   end if

   if ( ::cPedPrvL )->( dbSeek( cNumPed ) )

      while ( ::cPedPrvL )->cSerPed + Str( ( ::cPedPrvL )->nNumPed ) + ( ::cPedPrvL )->cSufPed == cNumPed .and. ;
            !( ::cPedPrvL )->( eof() );

         if !empty( Rtrim( ( ::cPedPrvL )->cRef ) )

            nUnits      := nTotNPedPrv( ::cPedPrvL ) - ( ::cPedPrvL )->nUniEnt

            /*
            mult. las unidades por su factor de conversión
            */

            if ( ::cPedPrvL )->nFacCnv != 0
               nUnits   := nUnits * ( ::cPedPrvL )->nFacCnv
            end if

         end if

         /*
         Borramos los registros esto es para hacer rollback
         */

         if lDelete .and. dbLock( ::cPedPrvL )
            ( ::cPedPrvL )->( dbDelete() )
            ( ::cPedPrvL )->( dbUnLock() )
         end if

         ( ::cPedPrvL )->( dbSkip() )

      end do

   end if

RETURN self

//---------------------------------------------------------------------------//

METHOD AlbPrv( cNumAlb, cCodAlm, cNumPed, lDelete, lIncremento, lIgnEstado, lActPendientes ) CLASS TStock

RETURN Self

//---------------------------------------------------------------------------//

METHOD SetPedPrv( cNumPed ) CLASS TStock

   local nEstPed
   local nRegAnt        
   local nOrdAnt        
   local nTotPedPrv     := 0
   local nRecPedPrv     := 0
   local nTotLineaAct   := 0

   if empty( ::cPedPrvT ) .or. empty( ::cPedPrvL )
      RETURN .f.
   end if

   nRegAnt              := ( ::cPedPrvT )->( RecNo() )
   nOrdAnt              := ( ::cPedPrvT )->( ordsetfocus( "nNumPed" ) )

   // Comprobamos como esta el pedido------------------------------------------

   if !empty( cNumPed )                            .and.;
      ( ::cPedPrvT )->( dbSeek( cNumPed ) )        .and.;
      ( ::cPedPrvL )->( dbSeek( cNumPed ) )

      while ( ::cPedPrvL )->cSerPed + Str( ( ::cPedPrvL )->nNumPed ) + ( ::cPedPrvL )->cSufPed == cNumPed .and. !( ::cPedPrvL )->( eof() )

         if !( ::cPedPrvL )->lAnulado

            //se cuenta la linea actual, para evitar que de como valido, pedir 5 de un producto y 5 de otro
            //pero al recibir 2 de uno y 8 del otro

            nTotLineaAct:= nTotNPedPrv( ::cPedPrvL )
            nTotPedPrv  += nTotLineaAct
            nRecPedPrv  += Min( nUnidadesRecibidasPedPrv( cNumPed, ( ::cPedPrvL )->cRef, ( ::cPedPrvL )->cValPr1, ( ::cPedPrvL )->cValPr2, ( ::cPedPrvL )->cRefPrv, ::cAlbPrvL ), nTotLineaAct )

         end if

         ( ::cPedPrvL )->( dbSkip() )

      end do

      do case
         case nRecPedPrv == 0
            nEstPed  := 1

         case nTotPedPrv > nRecPedPrv
            nEstPed  := 2

         case nRecPedPrv >= nTotPedPrv
            nEstPed  := 3

      end case

      if dbLock( ::cPedPrvT )
         ( ::cPedPrvT )->nEstado := nEstPed
         ( ::cPedPrvT )->( dbUnLock() )
      end if

      if ( ::cPedPrvL )->( dbSeek( cNumPed ) )

         while ( ::cPedPrvL )->cSerPed + Str( ( ::cPedPrvL )->nNumPed ) + ( ::cPedPrvL )->cSufPed == cNumPed .and. !( ::cPedPrvL )->( eof() )

            if dbLock( ::cPedPrvL )
               ( ::cPedPrvL )->nEstado := nEstPed
               ( ::cPedPrvL )->( dbUnLock() )
            end if

         ( ::cPedPrvL )->( dbSkip() )

         end while

      end if   

   end if

   ( ::cPedPrvT )->( ordsetfocus( nOrdAnt ) )
   ( ::cPedPrvT )->( DbGoTo( nRegAnt ) )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD FacPrv( cNumFac, cCodAlm, lDelete, lIncremento ) CLASS TStock

   local nUnits

   DEFAULT cCodAlm      := oUser():cAlmacen()
   DEFAULT lDelete      := .t.
   DEFAULT lIncremento  := .t.

   /*
   datos necesarios------------------------------------------------------------
   */

   if ::cFacPrvL == nil .or. cNumFac == nil
      msgStop( "Imposible realizar la actualización de stocks.", "Atención" )
      RETURN self
   end if

   if ( ::cFacPrvL )->( dbSeek( cNumFac ) )

      while ( ::cFacPrvL )->cSerFac + Str( ( ::cFacPrvL )->nNumFac ) + ( ::cFacPrvL )->cSufFac == cNumFac .and. ;
            !( ::cFacPrvL )->( eof() );

         if !empty( rtrim( ( ::cFacPrvL )->cRef ) )

            nUnits      := nTotNFacPrv( ::cFacPrvL )

            /*
            mult. las unidades por su factor de conversión
            */

            if ( ::cFacPrvL )->nFacCnv != 0
               nUnits   := nUnits * ( ::cFacPrvL )->nFacCnv
            end if

            //Si no tenemos almacen en linea se lo ponemos

            if empty( ( ::cFacPrvL )->cAlmLin ) .and. dbLock( ::cFacPrvL )
               ( ::cFacPrvL )->cAlmLin    := ( ::cFacPrvT )->cCodAlm
               ( ::cFacPrvL )->( dbUnLock() )
            end if

         end if

         //Borramos los registros esto es para hacer rollback

         if lDelete .and. dbLock( ::cFacPrvL )
            ( ::cFacPrvL )->( dbDelete() )
            ( ::cFacPrvL )->( dbUnLock() )
         end if

         ( ::cFacPrvL )->( dbSkip() )

      end do

   end if

   //::ChkFacPrv( cNumFac )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ChkFacPrv( cNumFac ) CLASS TStock

RETURN self

//---------------------------------------------------------------------------//

METHOD RctPrv( cNumFac, cCodAlm, lDelete, lIncremento ) CLASS TStock

   local nUnits

   DEFAULT cCodAlm      := oUser():cAlmacen()
   DEFAULT lDelete      := .t.
   DEFAULT lIncremento  := .t.

   /*
   datos necesarios------------------------------------------------------------
   */

   if ::cRctPrvL == nil .or. cNumFac == nil
      msgStop( "Imposible realizar la actualización de stocks.", "Atención" )
      RETURN self
   end if

   if ( ::cRctPrvL )->( dbSeek( cNumFac ) )

      while ( ::cRctPrvL )->cSerFac + Str( ( ::cRctPrvL )->nNumFac ) + ( ::cRctPrvL )->cSufFac == cNumFac .and. ;
            !( ::cRctPrvL )->( eof() );

         if !empty( rtrim( ( ::cRctPrvL )->cRef ) )

            nUnits      := nTotNRctPrv( ::cRctPrvL )

            /*
            mult. las unidades por su factor de conversión
            */

            if ( ::cRctPrvL )->nFacCnv != 0
               nUnits   := nUnits * ( ::cRctPrvL )->nFacCnv
            end if

            //Si no tenemos almacen en linea se lo ponemos

            if empty( ( ::cRctPrvL )->cAlmLin ) .and. dbLock( ::cRctPrvL )
               ( ::cRctPrvL )->cAlmLin    := ( ::cRctPrvT )->cCodAlm
               ( ::cRctPrvL )->( dbUnLock() )
            end if

         end if

         //Borramos los registros esto es para hacer rollback

         if lDelete .and. dbLock( ::cRctPrvL )
            ( ::cRctPrvL )->( dbDelete() )
            ( ::cRctPrvL )->( dbUnLock() )
         end if

         ( ::cRctPrvL )->( dbSkip() )

      end do

   end if

   //::ChkRctPrv( cNumFac )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ChkRctPrv( cNumFac ) CLASS TStock

RETURN self

//---------------------------------------------------------------------------//

METHOD PedCli( cNumPed, cCodAlm, lDelete, lIncremento ) CLASS TStock

   local nUndPed
   local nUndRes

   DEFAULT cCodAlm      := oUser():cAlmacen()
   DEFAULT lDelete      := .t.
   DEFAULT lIncremento  := .t.

   /*
   datos necesarios------------------------------------------------------------
   */

   if empty( cNumPed ) .or. empty( ::cPedCliL ) .or. empty( ::cAlbCliT ) .or. empty( ::cAlbCliL ) .or. empty( ::cAlbPrvL )
      msgStop( "Imposible realizar la actualización de stocks.", "Atención" )
      RETURN self
   end if

   if ( ::cPedCliL )->( dbSeek( cNumPed ) )

      while ( ::cPedCliL )->cSerPed + Str( ( ::cPedCliL )->nNumPed ) + ( ::cPedCliL )->cSufPed == cNumPed .and. ;
            !( ::cPedCliL )->( eof() )

         if !empty( Rtrim( ( ::cPedCliL )->cRef ) )

            nUndPed     := nTotNPedCli( ::cPedCliL )
            nUndRes     := nUnidadesReservadasEnPedidosCliente( ( ::cPedCliL )->cSerPed + Str( ( ::cPedCliL )->nNumPed ) + ( ::cPedCliL )->cSufPed, ( ::cPedCliL )->cRef, ( ::cPedCliL )->cValPr1, ( ::cPedCliL )->cValPr2, ::cPedCliR )

            /*
            Si no tenemos almacen en linea se lo ponemos
            */

            if empty( ( ::cPedCliL )->cAlmLin )
               if dbLock( ::cPedCliL )
                  ( ::cPedCliL )->cAlmLin    := ( ::cPedCliT )->cCodAlm
                  ( ::cPedCliL )->( dbUnLock() )
               end if
            end if

         end if

         /*
         Borramos los registros esto es para hacer rollback--------------------
         */

         if lDelete .and. dbLock( ::cPedCliL )
            ( ::cPedCliL )->( dbDelete() )
            ( ::cPedCliL )->( dbUnLock() )
         end if

         ( ::cPedCliL )->( dbSkip() )

      end do

   end if

   /*
   Necesitamos borrar los apuntes de reservas----------------------------------
   */

   if ::cPedCliR != nil .and. lDelete .and. ( ::cPedCliR )->( dbSeek( cNumPed ) )

      while ( ::cPedCliR )->cSerPed + Str( ( ::cPedCliR )->nNumPed ) + ( ::cPedCliR )->cSufPed == cNumPed .and. ;
            !( ::cPedCliR )->( eof() )

         if dbLock( ::cPedCliR )
            ( ::cPedCliR )->( dbDelete() )
            ( ::cPedCliR )->( dbUnLock() )
         end if

         ( ::cPedCliR )->( dbSkip() )

      end do

   end if

RETURN self

//---------------------------------------------------------------------------//

METHOD SetEstadoPedCli( cNumPed ) CLASS TStock

   local nEstadoPedido              := 1
   local nTotalUnidadesPedidas      := 0
   local nLineasUnidadesRecibidas   := 0
   local nLineasUnidadesPedidas     := 0
   local nTotalUnidadesRecibidas    := 0

   if empty( ::cPedCliT ) .or. empty( ::cPedCliL )
      RETURN .f.
   end if

   /*
   Comprobamos como esta el pedido------------------------------------------
   */

   if !( ::cPedCliL )->( dbSeek( cNumPed ) )
      RETURN .f.
   end if
   
   while ( ::cPedCliL )->cSerPed + Str( ( ::cPedCliL )->nNumPed ) + ( ::cPedCliL )->cSufPed == cNumPed .and. !( ::cPedCliL )->( eof() )

      if !( ::cPedCliL )->lAnulado

         //se cuenta la linea actual, para evitar que de como valido, pedir 5 de un producto y 5 de otro
         //pero al recibir 2 de uno y 8 del otro

         nLineasUnidadesPedidas     := nTotNPedCli( ::cPedCliL )

         nTotalUnidadesPedidas      += nLineasUnidadesPedidas

         nLineasUnidadesRecibidas   := nUnidadesRecibidasAlbaranesClientesNoFacturados( ( ::cPedCliL )->cSerPed + Str( ( ::cPedCliL )->nNumPed ) + ( ::cPedCliL )->cSufPed, ( ::cPedCliL )->cRef, ( ::cPedCliL )->cValPr1, ( ::cPedCliL )->cValPr2, ::cAlbCliL )
         nLineasUnidadesRecibidas   += nUnidadesRecibidasFacturasClientes( ( ::cPedCliL )->cSerPed + Str( ( ::cPedCliL )->nNumPed ) + ( ::cPedCliL )->cSufPed, ( ::cPedCliL )->cRef, ( ::cPedCliL )->cValPr1, ( ::cPedCliL )->cValPr2, ::cFacCliL )
         nLineasUnidadesRecibidas   := Min( nLineasUnidadesRecibidas, nLineasUnidadesPedidas )     

         nTotalUnidadesRecibidas    += nLineasUnidadesRecibidas

      end if

      ( ::cPedCliL )->( dbSkip() )

   end do

   /*
   En funcion de lo recibido colocamos los pedidos-----------------------------
   */

   do case
      case nTotalUnidadesRecibidas == 0
         nEstadoPedido        := 1
      case nTotalUnidadesPedidas > nTotalUnidadesRecibidas
         nEstadoPedido        := 2
      case nTotalUnidadesRecibidas >= nTotalUnidadesPedidas
         nEstadoPedido        := 3
   end case

   if !( ::cPedCliT )->( dbSeek( cNumPed ) )
      RETURN .f.
   end if 

   if ( ::cPedCliT )->nEstado == nEstadoPedido
      RETURN .f.
   end if 

   if dblock( ::cPedCliT )
      ( ::cPedCliT )->nEstado    := nEstadoPedido
      ( ::cPedCliT )->lSndDoc    := .t.
      ( ::cPedCliT )->dFecCre    := Date()
      ( ::cPedCliT )->cTimCre    := Time()
      ( ::cPedCliT )->( dbUnlock() )
   end if

RETURN .t.

//---------------------------------------------------------------------------//

METHOD SetEstadoSatCli( cNumSat ) CLASS TStock

   if empty( ::cSatCliT ) 
      RETURN .f.
   end if

   /*
   Comprobamos como esta el SAT------------------------------------------
   */

   if ( ::cSatCliT )->( dbSeek( cNumSat ) )  

      while ( ::cSatCliT )->cSerSat + Str( ( ::cSatCliT )->nNumSat ) + ( ::cSatCliT )->cSufSat == cNumSat .and. !( ::cSatCliT )->( eof() )

         if dbLock( ::cSatCliT )
            ( ::cSatCliT )->lEstado := .f.
            ( ::cSatCliT )->( dbUnlock() )
         end if

         ( ::cSatCliT )->( dbSkip() )

      end do

   end if

RETURN .t.

//---------------------------------------------------------------------------//

METHOD SetRecibidoPedCli( cNumPed ) CLASS TStock

   local nUndPed
   local nEstPed        := 0
   local nTotRec        := 0
   local nTotPed        := 0

   /*
   Datos necesarios------------------------------------------------------------
   */

   if empty( cNumPed ) .or. empty( ::cPedCliT ) .or. empty( ::cPedCliL ) .or. empty( ::cAlbPrvL )
      RETURN self
   end if

   if ( ::cPedCliT )->( dbSeek( cNumPed ) ) .and. ( ::cPedCliL )->( dbSeek( cNumPed ) )

      while ( ::cPedCliL )->cSerPed + Str( ( ::cPedCliL )->nNumPed ) + ( ::cPedCliL )->cSufPed == cNumPed .and. !( ::cPedCliL )->( eof() )

         if !empty( ( ::cPedCliL )->cRef )

            nUndPed     := nTotNPedCli( ::cPedCliL )
            nTotPed     += nUndPed
            nTotRec     += Min( nUnidadesRecibidasPedCli( ( ::cPedCliL )->cSerPed + Str( ( ::cPedCliL )->nNumPed ) + ( ::cPedCliL )->cSufPed, ( ::cPedCliL )->cRef, ( ::cPedCliL )->cValPr1, ( ::cPedCliL )->cValPr2,  ( ::cPedCliL )->cRefPrv, ( ::cPedCliL )->cDetalle, ::cAlbPrvL ), nUndPed )

         end if

         ( ::cPedCliL )->( dbSkip() )

      end do

      /*
      Actualiza el valor de recibido----------------------------------------------
      */

      do case
         case nTotRec == 0
            nEstPed  := 1
         case nTotRec < nTotPed
            nEstPed  := 2
         case nTotRec >= nTotPed
            nEstPed  := 3
      end case

      if dbLock( ::cPedCliT )
         ( ::cPedCliT )->nRecibido  := Max( nEstPed, 1 )
         ( ::cPedCliT )->( dbUnLock() )
      end if

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD SetGeneradoPedCli( cNumPed ) CLASS TStock

   local nEstado  := 0
   local nRecCliT := ( ::cPedCliT )->( Recno() )
   local nRecCliL := ( ::cPedCliL )->( Recno() )
   local nOrdCliT := ( ::cPedCliT )->( ordsetfocus( "nNumPed" ) )
   local nOrdCliL := ( ::cPedCliL )->( ordsetfocus( "nNumPed" ) )

   /*
   Datos necesarios------------------------------------------------------------
   */

   if empty( cNumPed ) .or. empty( ::cPedCliT ) .or. empty( ::cPedCliL ) .or. empty( ::cPedPrvL )
      msgStop( "Imposible actualizar el estado del pedido.", "Atención" )
      RETURN self
   end if

   if ( ::cPedCliT )->( dbSeek( cNumPed ) )  .and. ;
      ( ::cPedCliL )->( dbSeek( cNumPed ) )

      while ( ::cPedCliL )->cSerPed + Str( ( ::cPedCliL )->nNumPed ) + ( ::cPedCliL )->cSufPed == cNumPed .and. ;
            !( ::cPedCliL )->( eof() )

         if nTotNPedCli( ::cPedCliL ) != 0

            if dbSeekInOrd( cNumPed + ( ::cPedCliL )->cRef + ( ::cPedCliL )->cValPr1 + ( ::cPedCliL )->cValPr2, "cPedCliRef", ::cPedPrvL )

               do case
                  case nEstado == 0 .or. nEstado == 3
                     nEstado := 3
                  case nEstado == 1
                     nEstado := 2
               end case

            else

               do case
                  case nEstado == 0
                     nEstado := 1
                  case nEstado == 3
                     nEstado := 2
               end case

            end if

         end if

         ( ::cPedCliL )->( dbSkip() )

      end while

      if dbLock( ::cPedCliT )
         ( ::cPedCliT )->nGenerado  := Max( nEstado, 1 )
         ( ::cPedCliT )->( dbUnLock() )
      end if

   end if

   ( ::cPedCliT )->( ordsetfocus( nOrdCliT ) )
   ( ::cPedCliL )->( ordsetfocus( nOrdCliL ) )
   ( ::cPedCliT )->( dbGoTo( nRecCliT ) )
   ( ::cPedCliL )->( dbGoTo( nRecCliL ) )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD nStockReservado( cCodArt, cValPr1, cValPr2 ) CLASS TStock

   local nTotal         := 0
   local nOrdPedCliR    := ( ::cPedCliR )->( ordsetfocus( "cRef" ) )

   if ( ::cPedCliR )->( dbSeek( cCodArt ) )

      while ( ::cPedCliR )->cRef == cCodArt .and. !( ::cPedCliR )->( Eof() )

         nTotal         += nUnidadesReservadasEnPedidosCliente( ( ::cPedCliR )->cSerPed + Str( ( ::cPedCliR )->nNumPed ) + ( ::cPedCliR )->cSufPed, ( ::cPedCliR )->cRef, ( ::cPedCliR )->cValPr1, ( ::cPedCliR )->cValPr2, ::cPedCliR )

         ( ::cPedCliR )->( dbSkip() )

      end while

   end if

   ( ::cPedCliR )->( ordsetfocus( nOrdPedCliR ) )

RETURN ( nTotal )

//---------------------------------------------------------------------------//

METHOD AlbCli( cNumAlb, cCodAlm, lDelete, lIncremento, lIgnEstado, lChequea, lActPendientes ) CLASS TStock

RETURN self

//---------------------------------------------------------------------------//

METHOD ChkAlbCli( cNumAlb ) CLASS TStock

RETURN self

//---------------------------------------------------------------------------//

METHOD AlqCli( cNumAlq, cCodAlm, lDelete, lIncremento, lIgnEstado, lChequea ) CLASS TStock

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD FacCli( cNumFac, cCodAlm, lDelete, lIncremento, lActPendientes ) CLASS TStock

RETURN self

//---------------------------------------------------------------------------//

METHOD ChkFacCli( cNumFac ) CLASS TStock

RETURN self

//---------------------------------------------------------------------------//

METHOD FacRec( cNumFac, cCodAlm, lDelete, lIncremento, lActPendientes ) CLASS TStock

   local nUnits
   local nPendEnt          := 0

   DEFAULT cCodAlm         := oUser():cAlmacen()
   DEFAULT lDelete         := .t.
   DEFAULT lIncremento     := .t.
   DEFAULT lActPendientes  := .f.

   /*
   datos necesarios------------------------------------------------------------
   */

   if ::cFacRecL == nil .or. cNumFac == nil
      msgStop( "Imposible realizar la actualización de stocks.", "Atención" )
      RETURN self
   end if

   if ( ::cFacRecL )->( dbSeek( cNumFac ) )

      while ( ::cFacRecL )->cSerie + Str( ( ::cFacRecL )->nNumFac ) + ( ::cFacRecL )->cSufFac == cNumFac .and.;
            !( ::cFacRecL )->( eof() )

         if !empty( rtrim( ( ::cFacRecL )->cRef ) ) // .and. !( ::cFacRecT )->lImpAlb

            nUnits      := nTotNFacRec( ::cFacRecL )

            /*
            mult. las unidades por su factor de conversión
            */

            if ( ::cFacRecL )->nFacCnv != 0
               nUnits   := nUnits * ( ::cFacRecL )->nFacCnv
            end if

            /*
            Si no tenemos almacen en linea se lo ponemos
            */

            if empty( ( ::cFacRecL )->cAlmLin )
               if dbLock( ::cFacRecL )
                  ( ::cFacRecL )->cAlmLin    := ( ::cFacRecT )->cCodAlm
                  ( ::cFacRecL )->( dbUnLock() )
               end if
            end if

         end if

         /*
         Borramos los registros esto es para hacer rollback
         */

         if lDelete .and. dbLock( ::cFacRecL )
            ( ::cFacRecL )->( dbDelete() )
            ( ::cFacRecL )->( dbUnLock() )
         end if

         ( ::cFacRecL )->( dbSkip() )

      end do

   end if


RETURN self

//---------------------------------------------------------------------------//

METHOD TpvCli( cNumTik, cCodAlm, lIncremento, lDevolucion, lChequea ) CLASS TStock

   local nRec
   local nUnits

   DEFAULT cCodAlm      := oUser():cAlmacen()
   DEFAULT lIncremento  := .t.
   DEFAULT lDevolucion  := ( ( ::cTikT )->cTipTik == SAVDEV .or. ( ::cTikT )->cTipTik == SAVVAL )
   DEFAULT lChequea     := .t.

   /*
   datos necesarios------------------------------------------------------------
   */

   if ::cTikL == nil .or. cNumTik == nil
      RETURN self
   end if

   if lDevolucion
      lIncremento       := !lIncremento
   end if

   nRec                 := ( ::cTikL )->( Recno() )

   /*
   Devoluciones ---------------------------------------------------------------
   */

   if ( ::cTikL )->( dbSeek( cNumTik ) )

      while ( ::cTikL )->cSerTil + ( ::cTikL )->cNumTil + ( ::cTikL )->cSufTil == cNumTik .and. ;
            !( ::cTikL )->( eof() );

         if !empty( Rtrim( ( ::cTikL )->cCbaTil ) )

            nUnits      := ( ::cTikL )->nUntTil

            /*
            mult. las unidades por su Tiktor de conversión
            */

            if ( ::cTikL )->nFacCnv != 0
               nUnits   := ( ::cTikL )->nUntTil * ( ::cTikL )->nFacCnv
            end if

            /*
            Si no tenemos almacen en linea se lo ponemos
            */

            if empty( ( ::cTikL )->cAlmLin ) .and. dbLock( ::cTikL )
               ( ::cTikL )->cAlmLin    := cCodAlm
               ( ::cTikL )->( dbUnLock() )
            end if

            /*
            Devoluciones, vales
            */

            if lDevolucion
               nUnits   := Abs( nUnits )
            end if

         end if

         ( ::cTikL )->( dbSkip() )

      end do

   end if

   ( ::cTikL )->( dbGoTo( nRec ) )

   /*if lChequea
      ::ChkTikCli( cNumTik )
   end if*/

RETURN self

//---------------------------------------------------------------------------//

METHOD ChkTikCli( cNumTik ) CLASS TStock

RETURN self

//---------------------------------------------------------------------------//
//
// Devuelve el numero de unidades en almacen de un producto
//

METHOD nSQLStockActual( cCodArt, cCodAlm, cValPr1, cValPr2, cLote ) CLASS TStock

   local nSQLStockActual         := 0
   local tHoraConsolidacion
   local dFechaConsolidacion
   local hFechaHoraConsolidacion
   local tFechaHoraConsolidacion

   if empty( cCodArt )
      RETURN ( nSQLStockActual )
   end if 

   cCodArt                       := padr( cCodArt, 18 )

   // Almacenes----------------------------------------------------------------

   ::setCodigoAlmacen( cCodAlm )   

   for each cCodAlm in ::uCodigoAlmacen

      // Obtenermos el dato de la consolidacion--------------------------------

      // hFechaHoraConsolidacion    := MovimientosAlmacenesLineasModel():getFechaHoraConsolidacion( cCodArt, cCodAlm, cValPr1, cValPr2, cLote )

      hFechaHoraConsolidacion    := MovimientosAlmacenLineasRepository():getHashFechaHoraConsolidacion( cCodArt, cCodAlm, cValPr1, cValPr2, cLote )

      if !empty( hFechaHoraConsolidacion )
         
         dFechaConsolidacion     := hGet( hFechaHoraConsolidacion, "fecha" )
         tHoraConsolidacion      := hGet( hFechaHoraConsolidacion, "hora" )
         
         if hHasKey( hFechaHoraConsolidacion, "fecha_hora" )
            tFechaHoraConsolidacion := hGet( hFechaHoraConsolidacion, "fecha_hora" )
         end if

      else

         dFechaConsolidacion     := nil
         tHoraConsolidacion      := nil
         tFechaHoraConsolidacion := nil

      end if 

      // Entradas--------------------------------------------------------------

      nSQLStockActual            += StocksModel():getTotalUnidadesStockEntradas( cCodArt, dFechaConsolidacion, tHoraConsolidacion, cCodAlm, cValPr1, cValPr2, cLote )

      // Salidas----------------------------------------------------------------

      nSQLStockActual            -= StocksModel():getTotalUnidadesStockSalidas( cCodArt, dFechaConsolidacion, tHoraConsolidacion, cCodAlm, cValPr1, cValPr2, cLote )

      // Almacen

      //nSQLStockActual            += MovimientosAlmacenLineasRepository():getTotalUnidadesStock( tFechaHoraConsolidacion, cCodArt, cCodAlm, cValPr1, cValPr2, cLote )

   next 

RETURN ( nSQLStockActual )

//---------------------------------------------------------------------------//

METHOD nSQLGlobalStockActual( cCodArt, cCodAlm ) CLASS TStock

   local nSeconds                := seconds()
   local cStm
   local nSQLStockActual         := 0

   if empty( cCodArt )
      RETURN ( nSQLStockActual )
   end if 

   cCodArt                       := padr( cCodArt, 18 )

   // Almacenes----------------------------------------------------------------

   ::setCodigoAlmacen( cCodAlm )   
   for each cCodAlm in ::uCodigoAlmacen

      cStm                       := StocksModel():getLineasAgrupadas( cCodArt, cCodAlm )

      ( cStm )->( dbgotop() )
      while !( cStm )->( eof() )

         nSQLStockActual         += ::nSQLStockActual( ( cStm )->cCodigoArticulo, ( cStm )->cCodigoAlmacen, ( cStm )->cValorPropiedad1, ( cStm )->cValorPropiedad2, ( cStm )->cLote )

         ( cStm )->( dbskip() )

      end while

      StocksModel():closeAreaLineasAgrupadas()

   next 

RETURN ( nSQLStockActual )

//---------------------------------------------------------------------------//


METHOD nCacheStockActual( cCodArt, cCodAlm, cValPrp1, cValPrp2, cLote, lKitArt, nKitStk, nCtlStk ) CLASS TStock
   
   local nCacheStockActual    := ::getCacheStockActual( cCodArt, cCodAlm, cValPrp1, cValPrp2, cLote, lKitArt, nKitStk, nCtlStk )

   if isNum( nCacheStockActual )
      RETURN ( nCacheStockActual )      
   end if 

   nCacheStockActual          := ::nTotStockAct( cCodArt, cCodAlm, cValPrp1, cValPrp2, cLote, lKitArt, nKitStk, nCtlStk )

   ::addCacheStockActual( cCodArt, cCodAlm, cValPrp1, cValPrp2, cLote, lKitArt, nKitStk, nCtlStk, nCacheStockActual )

RETURN ( nCacheStockActual )

//---------------------------------------------------------------------------//

METHOD getCacheStockActual( cCodArt, cCodAlm, cValPrp1, cValPrp2, cLote, lKitArt, nKitStk, nCtlStk ) CLASS TStock

   local nPos  := ::scanCacheStockActual( cCodArt, cCodAlm, cValPrp1, cValPrp2, cLote, lKitArt, nKitStk, nCtlStk )

   if nPos != 0
      RETURN ( hget( ::aCacheStockActual[nPos], "stock" ) )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD scanCacheStockActual( cCodArt, cCodAlm, cValPrp1, cValPrp2, cLote, lKitArt, nKitStk, nCtlStk ) CLASS TStock

   local nPos  := ascan(   ::aCacheStockActual                       ,; 
                           {|h|  h["codigo"] == cCodArt        .and. ;
                                 h["almacen"] == cCodAlm       .and. ;
                                 h["propiedad1"] == cValPrp1   .and. ;
                                 h["propiedad2"] == cValPrp2   .and. ;
                                 h["lote"] == cLote            .and. ;
                                 h["articuloKit"] == lKitArt   .and. ;
                                 h["stockKit"] == nKitStk      .and. ;
                                 h["controlStock"] == nCtlStk } )

RETURN ( nPos )

//---------------------------------------------------------------------------//

METHOD addCacheStockActual( cCodArt, cCodAlm, cValPrp1, cValPrp2, cLote, lKitArt, nKitStk, nCtlStk, nStock ) CLASS TStock

   aadd( ::aCacheStockActual, {  "codigo" => cCodArt        ,;
                                 "almacen" => cCodAlm       ,;
                                 "propiedad1" => cValPrp1   ,;
                                 "propiedad2" => cValPrp2   ,;
                                 "lote" => cLote            ,;
                                 "articuloKit" => lKitArt   ,;
                                 "stockKit" => nKitStk      ,;
                                 "controlStock" => nCtlStk  ,;
                                 "stock" => nStock } )

RETURN ( nStock )

//---------------------------------------------------------------------------//

METHOD deleteCacheStockActual( cCodArt, cCodAlm, cValPrp1, cValPrp2, cLote, lKitArt, nKitStk, nCtlStk ) CLASS TStock

   local nPos  := ::scanCacheStockActual( cCodArt, cCodAlm, cValPrp1, cValPrp2, cLote, lKitArt, nKitStk, nCtlStk )

   if nPos != 0
      adel( ::aCacheStockActual, nPos, .t. )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD recalculateCacheStockActual( cCodArt, cCodAlm, cValPrp1, cValPrp2, cLote, lKitArt, nKitStk, nCtlStk ) CLASS TStock

   ::deleteCacheStockActual( cCodArt, cCodAlm, cValPrp1, cValPrp2, cLote, lKitArt, nKitStk, nCtlStk )

   ::nCacheStockActual( cCodArt, cCodAlm, cValPrp1, cValPrp2, cLote, lKitArt, nKitStk, nCtlStk ) 

RETURN ( nil )

//---------------------------------------------------------------------------//
//
// Devuelve el total de stock de un articulo en un almacen
//

METHOD nTotStockAct( cCodArt, cCodAlm, cValPr1, cValPr2, cLote, lKitArt, nKitStk, nCtlStk ) CLASS TStock

   local nUnits         := 0

   DEFAULT lKitArt      := .t.
   DEFAULT nKitStk      := 0
   DEFAULT nCtlStk      := 1

   if empty( cCodArt )
      RETURN ( nUnits )
   end if 

   if nCtlStk <= 1

      if lKitArt .and. nKitStk == 3

         if ( ::cKit )->( dbSeek( cCodArt ) )

            while ( ::cKit )->cCodKit == cCodArt .and. !( ::cKit )->( eof() )

               if nUnits == nil
                  nUnits   := Int( ::nStockAlmacen( ( ::cKit )->cRefKit, cCodAlm, cValPr1, cValPr2, cLote ) / ( ::cKit )->nUndKit )
               else
                  nUnits   := Min( nUnits, Int( ::nStockAlmacen( ( ::cKit )->cRefKit, cCodAlm, cValPr1, cValPr2, cLote ) / ( ::cKit )->nUndKit ) )
               end if

               ( ::cKit )->( dbSkip() )

            end while

         end if

      else

         nUnits            := ::nStockAlmacen( cCodArt, cCodAlm, cValPr1, cValPr2, cLote )

      end if

   end if

RETURN ( nUnits )

//---------------------------------------------------------------------------//

METHOD nPutStockActual( cCodArt, cCodAlm, cValPr1, cValPr2, cLote, lKitArt, nCtlStk, oSay ) CLASS TStock

   local cClass   
   local nStock   := 0

   if !uFieldEmpresa( "lNStkAct" )
      nStock      := ::nTotStockAct( cCodArt, cCodAlm, cValPr1, cValPr2, cLote, lKitArt, nil, nCtlStk )
   end if

   if !empty( oSay )

      cClass      := oSay:ClassName()

      do case
         case cClass == "TGET" .or. cClass == "TGETHLP" .or. cClass == "TGRIDGET"
            oSay:cText( nStock )
         case cClass == "TSAY"
            oSay:SetText( nStock )
      end case

   end if

RETURN ( nStock )

//---------------------------------------------------------------------------//

METHOD lPutStockActual( cCodArt, cCodAlm, cValPr1, cValPr2, cLote, lKitArt, nKitStk, oSay ) CLASS TStock

   ::nPutStockActual( cCodArt, cCodAlm, cValPr1, cValPr2, cLote, lKitArt, nKitStk, oSay )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD Recalcula( oMeter, cNewEmp, cPatEmp ) CLASS TStock

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD InsertStockMovimientosAlmacenRowset( oRowSet, lDestino )

   with object ( SStock():New() )

      :cTipoDocumento      := MOV_ALM

      :cNumeroDocumento    := oRowSet:fieldget( 'numero' ) 
      :cDelegacion         := oRowSet:fieldget( 'delegacion' )
      :dFechaDocumento     := oRowSet:fieldget( 'fecha' )
      :tFechaDocumento     := strtran( oRowSet:fieldget( 'hora' ), ":", "" )
      :cCodigo             := Padr( oRowSet:fieldget( 'codigo_articulo' ), 18 )
      :cCodigoPropiedad1   := Padr( oRowSet:fieldget( 'codigo_primera_propiedad' ), 20 )
      :cCodigoPropiedad2   := Padr( oRowSet:fieldget( 'codigo_segunda_propiedad' ), 20 )
      :cValorPropiedad1    := Padr( oRowSet:fieldget( 'valor_primera_propiedad' ), 20 )
      :cValorPropiedad2    := Padr( oRowSet:fieldget( 'valor_segunda_propiedad' ), 20 )
      :cLote               := Padr( oRowSet:fieldget( 'lote' ), 14 )
      :dConsolidacion      := if( !empty( ::dConsolidacion ), ::dConsolidacion, ctod( "" ) )

      if IsTrue( lDestino )

         :cCodigoAlmacen   := Padr( oRowSet:fieldget( 'almacen_destino' ), 16 )
         :nUnidades        := oRowSet:fieldget( 'total_unidades' )
         :nBultos          := oRowSet:fieldget( 'bultos_articulo' )
         :nCajas           := oRowSet:fieldget( 'cajas_articulo' )
         
      else 

         :cCodigoAlmacen   := Padr( oRowSet:fieldget( 'almacen_origen' ), 16 )
         :nUnidades        := -oRowSet:fieldget( 'total_unidades' )
         :nBultos          := -oRowSet:fieldget( 'bultos_articulo' )
         :nCajas           := -oRowSet:fieldget( 'cajas_articulo' )

      end if

      ::Integra( hb_QWith() )

   end with

RETURN nil

//---------------------------------------------------------------------------//

METHOD DeleteStockAlbaranProveedores( lNumeroSerie )

   local nUnidades         := nTotNAlbPrv( ::cAlbPrvL )

   with object ( SStock():New() )
   
      :cTipoDocumento      := ALB_PRV
      :cAlias              := ( ::cAlbPrvL )
      :cNumeroDocumento    := ( ::cAlbPrvL )->cSerAlb + "/" + alltrim( Str( ( ::cAlbPrvL )->nNumAlb ) )
      :cDelegacion         := ( ::cAlbPrvL )->cSufAlb
      :dFechaDocumento     := ( ::cAlbPrvL )->dFecAlb
      :tFechaDocumento     := ( ::cAlbPrvL )->tFecAlb
      :cCodigo             := ( ::cAlbPrvL )->cRef
      :cCodigoAlmacen      := ( ::cAlbPrvL )->cAlmOrigen
      :cCodigoPropiedad1   := ( ::cAlbPrvL )->cCodPr1
      :cCodigoPropiedad2   := ( ::cAlbPrvL )->cCodPr2
      :cValorPropiedad1    := ( ::cAlbPrvL )->cValPr1
      :cValorPropiedad2    := ( ::cAlbPrvL )->cValPr2
      :cLote               := ( ::cAlbPrvL )->cLote
      :dFechaCaducidad     := ( ::cAlbPrvL )->dFecCad
      :nBultos             := -( ::cAlbPrvL )->nBultos
      :nCajas              := -( ::cAlbPrvL )->nCanEnt

      if IsTrue( lNumeroSerie )
         :nUnidades        := if( nUnidades > 0, -1, 1 )
         :cNumeroSerie     := ( ::cAlbPrvS )->cNumSer
      else
         :nUnidades        := -nUnidades
      end if
      
      ::Integra( hb_QWith() )

   end with

RETURN nil

//---------------------------------------------------------------------------//

METHOD InsertStockAlbaranProveedores( lNumeroSerie )

   local nUnidades         := nTotNAlbPrv( ::cAlbPrvL )

   with object ( SStock():New() )
   
      :cTipoDocumento      := ALB_PRV
      :cAlias              := ( ::cAlbPrvL )
      :cNumeroDocumento    := ( ::cAlbPrvL )->cSerAlb + "/" + alltrim( Str( ( ::cAlbPrvL )->nNumAlb ) )
      :cDelegacion         := ( ::cAlbPrvL )->cSufAlb
      :dFechaDocumento     := ( ::cAlbPrvL )->dFecAlb
      :tFechaDocumento     := ( ::cAlbPrvL )->tFecAlb
      :cCodigo             := ( ::cAlbPrvL )->cRef
      :cCodigoAlmacen      := ( ::cAlbPrvL )->cAlmLin
      :cCodigoPropiedad1   := ( ::cAlbPrvL )->cCodPr1
      :cCodigoPropiedad2   := ( ::cAlbPrvL )->cCodPr2
      :cValorPropiedad1    := ( ::cAlbPrvL )->cValPr1
      :cValorPropiedad2    := ( ::cAlbPrvL )->cValPr2
      :cLote               := ( ::cAlbPrvL )->cLote
      :dFechaCaducidad     := ( ::cAlbPrvL )->dFecCad
      :nBultos             := ( ::cAlbPrvL )->nBultos
      :nCajas              := ( ::cAlbPrvL )->nCanEnt

      if IsTrue( lNumeroSerie )
         :nUnidades        := if( nUnidades > 0, 1, -1 )
         :cNumeroSerie     := ( ::cAlbPrvS )->cNumSer
      else
         :nUnidades        :=  nUnidades
      end if
      
      ::Integra( hb_QWith() )

   end with

RETURN nil

//---------------------------------------------------------------------------//

   METHOD DeleteStockFacturaProveedores( lNumeroSerie )

   local nUnidades         := nTotNFacPrv( ::cFacPrvL )

   with object ( SStock():New() )
   
      :cTipoDocumento      := FAC_PRV
      :cAlias              := ( ::cFacPrvL )
      :cNumeroDocumento    := ( ::cFacPrvL )->cSerFac + "/" + alltrim( Str( ( ::cFacPrvL )->nNumFac ) )
      :cDelegacion         := ( ::cFacPrvL )->cSufFac
      :dFechaDocumento     := ( ::cFacPrvL )->dFecFac
      :tFechaDocumento     := ( ::cFacPrvL )->tFecFac
      :cCodigo             := ( ::cFacPrvL )->cRef
      :cCodigoAlmacen      := ( ::cFacPrvL )->cAlmOrigen
      :cCodigoPropiedad1   := ( ::cFacPrvL )->cCodPr1
      :cCodigoPropiedad2   := ( ::cFacPrvL )->cCodPr2
      :cValorPropiedad1    := ( ::cFacPrvL )->cValPr1
      :cValorPropiedad2    := ( ::cFacPrvL )->cValPr2
      :cLote               := ( ::cFacPrvL )->cLote
      :dFechaCaducidad     := ( ::cFacPrvL )->dFecCad
      :nBultos             := -( ::cFacPrvL )->nBultos
      :nCajas              := -( ::cFacPrvL )->nCanEnt

      if IsTrue( lNumeroSerie )
         :nUnidades        := if( nUnidades > 0, -1, 1 )
         :cNumeroSerie     := ( ::cFacPrvS )->cNumSer
      else
         :nUnidades        := -nUnidades
      end if
      
      ::Integra( hb_QWith() )

   end with

RETURN nil 

//---------------------------------------------------------------------------//

METHOD InsertStockFacturaProveedores( lNumeroSerie )

   local nUnidades         := nTotNFacPrv( ::cFacPrvL )

   with object ( SStock():New() )
   
      :cTipoDocumento      := FAC_PRV
      :cAlias              := ( ::cFacPrvL )
      :cNumeroDocumento    := ( ::cFacPrvL )->cSerFac + "/" + alltrim( Str( ( ::cFacPrvL )->nNumFac ) )
      :cDelegacion         := ( ::cFacPrvL )->cSufFac
      :dFechaDocumento     := ( ::cFacPrvL )->dFecFac
      :tFechaDocumento     := ( ::cFacPrvL )->tFecFac
      :cCodigo             := ( ::cFacPrvL )->cRef
      :cCodigoAlmacen      := ( ::cFacPrvL )->cAlmLin
      :cCodigoPropiedad1   := ( ::cFacPrvL )->cCodPr1
      :cCodigoPropiedad2   := ( ::cFacPrvL )->cCodPr2
      :cValorPropiedad1    := ( ::cFacPrvL )->cValPr1
      :cValorPropiedad2    := ( ::cFacPrvL )->cValPr2
      :cLote               := ( ::cFacPrvL )->cLote
      :dFechaCaducidad     := ( ::cFacPrvL )->dFecCad
      :nBultos             := ( ::cFacPrvL )->nBultos
      :nCajas              := ( ::cFacPrvL )->nCanEnt

      if IsTrue( lNumeroSerie )
         :nUnidades        := if( nUnidades > 0, 1, -1 )
         :cNumeroSerie     := ( ::cFacPrvS )->cNumSer
      else
         :nUnidades        := nUnidades
      end if
      
      ::Integra( hb_QWith() )

   end with

RETURN nil 

//---------------------------------------------------------------------------//

METHOD InsertStockRectificativaProveedores( lNumeroSerie )

   local nUnidades         := nTotNRctPrv( ::cRctPrvL )

   with object ( SStock():New() )

      :cTipoDocumento      := RCT_PRV
      :cAlias              := ( ::cRctPrvL )
      :cNumeroDocumento    := ( ::cRctPrvL )->cSerFac + "/" + alltrim( Str( ( ::cRctPrvL )->nNumFac ) )
      :cDelegacion         := ( ::cRctPrvL )->cSufFac
      :dFechaDocumento     := ( ::cRctPrvL )->dFecFac
      :tFechaDocumento     := ( ::cRctPrvL )->tFecFac
      :cCodigo             := ( ::cRctPrvL )->cRef
      :cCodigoAlmacen      := ( ::cRctPrvL )->cAlmLin
      :cCodigoPropiedad1   := ( ::cRctPrvL )->cCodPr1
      :cCodigoPropiedad2   := ( ::cRctPrvL )->cCodPr2
      :cValorPropiedad1    := ( ::cRctPrvL )->cValPr1
      :cValorPropiedad2    := ( ::cRctPrvL )->cValPr2
      :cLote               := ( ::cRctPrvL )->cLote
      :dFechaCaducidad     := ( ::cRctPrvL )->dFecCad
      :nBultos             := ( ::cRctPrvL )->nBultos
      :nCajas              := ( ::cRctPrvL )->nCanEnt

      if IsTrue( lNumeroSerie )
         :nUnidades        := if( nUnidades > 0, 1, -1 )
         :cNumeroSerie     := ( ::cRctPrvS )->cNumSer
      else
         :nUnidades        := nUnidades
      end if
      
      ::Integra( hb_QWith() )

   end with

RETURN nil

//---------------------------------------------------------------------------//

METHOD DeleteStockRectificativaProveedores( lNumeroSerie )

   local nUnidades         := nTotNRctPrv( ::cRctPrvL )

   with object ( SStock():New() )

      :cTipoDocumento      := RCT_PRV
      :cAlias              := ( ::cRctPrvL )
      :cNumeroDocumento    := ( ::cRctPrvL )->cSerFac + "/" + alltrim( Str( ( ::cRctPrvL )->nNumFac ) )
      :cDelegacion         := ( ::cRctPrvL )->cSufFac
      :dFechaDocumento     := ( ::cRctPrvL )->dFecFac
      :tFechaDocumento     := ( ::cRctPrvL )->tFecFac
      :cCodigo             := ( ::cRctPrvL )->cRef
      :cCodigoAlmacen      := ( ::cRctPrvL )->cAlmOrigen
      :cCodigoPropiedad1   := ( ::cRctPrvL )->cCodPr1
      :cCodigoPropiedad2   := ( ::cRctPrvL )->cCodPr2
      :cValorPropiedad1    := ( ::cRctPrvL )->cValPr1
      :cValorPropiedad2    := ( ::cRctPrvL )->cValPr2
      :cLote               := ( ::cRctPrvL )->cLote
      :dFechaCaducidad     := ( ::cRctPrvL )->dFecCad
      :nBultos             := ( ::cRctPrvL )->nBultos
      :nCajas              := ( ::cRctPrvL )->nCanEnt

      if IsTrue( lNumeroSerie )
         :nUnidades        := if( nUnidades > 0, -1, 1 )
         :cNumeroSerie     := ( ::cRctPrvS )->cNumSer
      else
         :nUnidades        := -nUnidades
      end if
      
      ::Integra( hb_QWith() )

   end with

RETURN nil

//---------------------------------------------------------------------------//

METHOD InsertStockPedidoClientes()

   local nPendientesEntregar  := nTotNPedCli( ::cPedCliL )
   local nUnidadesEntregadas  := nUnidadesRecibidasAlbaranesClientesNoFacturados( ( ::cPedCliL )->cSerPed + str( ( ::cPedCliL )->nNumPed ) + ( ::cPedCliL )->cSufPed, ( ::cPedCliL )->cRef, ( ::cPedCliL )->cValPr1, ( ::cPedCliL )->cValPr2, ::cAlbCliL )
   nUnidadesEntregadas        += nUnidadesRecibidasFacturasClientes( ( ::cPedCliL )->cSerPed + str( ( ::cPedCliL )->nNumPed ) + ( ::cPedCliL )->cSufPed, ( ::cPedCliL )->cRef, ( ::cPedCliL )->cValPr1, ( ::cPedCliL )->cValPr2, ::cFacCliL )

   nPendientesEntregar        -= nUnidadesEntregadas

   with object ( SStock():New() )
   
      :cTipoDocumento         := PED_CLI
      :dFechaDocumento        := ( ::cPedCliT )->dFecPed
      :tFechaDocumento        := "000000"
      :cAlias                 := ( ::cPedCliL )
      :cNumeroDocumento       := ( ::cPedCliL )->cSerPed + "/" + alltrim( Str( ( ::cPedCliL )->nNumPed ) )
      :cDelegacion            := ( ::cPedCliL )->cSufPed
      :cCodigo                := ( ::cPedCliL )->cRef
      :cCodigoAlmacen         := ( ::cPedCliL )->cAlmLin
      :cCodigoPropiedad1      := ( ::cPedCliL )->cCodPr1
      :cCodigoPropiedad2      := ( ::cPedCliL )->cCodPr2
      :cValorPropiedad1       := ( ::cPedCliL )->cValPr1
      :cValorPropiedad2       := ( ::cPedCliL )->cValPr2
      :cLote                  := ( ::cPedCliL )->cLote
      :dFechaCaducidad        := ( ::cPedCliL )->dFecCad
      :nPendientesEntregar    := nPendientesEntregar
      :nUnidadesEntregadas    := nUnidadesEntregadas
      
      ::Integra( hb_QWith() )

   end with

RETURN ( nPendientesEntregar )

//---------------------------------------------------------------------------//

METHOD InsertStockAlbaranClientes( lNumeroSerie )

   local nUnidades         := nTotNAlbCli( ::cAlbCliL )

   with object ( SStock():New() )
   
      :cTipoDocumento      := ALB_CLI
      :cAlias              := ( ::cAlbCliL )
      :cNumeroDocumento    := ( ::cAlbCliL )->cSerAlb + "/" + alltrim( Str( ( ::cAlbCliL )->nNumAlb ) )
      :cDelegacion         := ( ::cAlbCliL )->cSufAlb
      :dFechaDocumento     := ( ::cAlbCliL )->dFecAlb
      :tFechaDocumento     := ( ::cAlbCliL )->tFecAlb
      :cCodigo             := ( ::cAlbCliL )->cRef
      :cCodigoAlmacen      := ( ::cAlbCliL )->cAlmLin
      :cCodigoPropiedad1   := ( ::cAlbCliL )->cCodPr1
      :cCodigoPropiedad2   := ( ::cAlbCliL )->cCodPr2
      :cValorPropiedad1    := ( ::cAlbCliL )->cValPr1
      :cValorPropiedad2    := ( ::cAlbCliL )->cValPr2
      :cLote               := ( ::cAlbCliL )->cLote
      :dFechaCaducidad     := ( ::cAlbCliL )->dFecCad
      :nBultos             := -( ::cAlbCliL )->nBultos
      :nCajas              := -( ::cAlbCliL )->nCanEnt

      if IsTrue( lNumeroSerie )
         :nUnidades        := if( nUnidades > 0, -1, 1 )
         :cNumeroSerie     := ( ::cAlbCliS )->cNumSer
      else
         :nUnidades        := -nUnidades
      end if
      
      ::Integra( hb_QWith() )

   end with

RETURN ( nUnidades )

//---------------------------------------------------------------------------//

METHOD InsertStockFacturaClientes( lNumeroSerie )

   local nUnidades         := nTotNFacCli( ::cFacCliL )

   with object ( SStock():New() )
   
      :cTipoDocumento      := FAC_CLI
      :cAlias              := ( ::cFacCliL )
      :cNumeroDocumento    := ( ::cFacCliL )->cSerie + "/" + alltrim( Str( ( ::cFacCliL )->nNumFac ) )
      :cDelegacion         := ( ::cFacCliL )->cSufFac
      :dFechaDocumento     := ( ::cFacCliL )->dFecFac
      :tFechaDocumento     := ( ::cFacCliL )->tFecFac
      :cCodigo             := ( ::cFacCliL )->cRef
      :cCodigoAlmacen      := ( ::cFacCliL )->cAlmLin
      :cCodigoPropiedad1   := ( ::cFacCliL )->cCodPr1
      :cCodigoPropiedad2   := ( ::cFacCliL )->cCodPr2
      :cValorPropiedad1    := ( ::cFacCliL )->cValPr1
      :cValorPropiedad2    := ( ::cFacCliL )->cValPr2
      :cLote               := ( ::cFacCliL )->cLote
      :dFechaCaducidad     := ( ::cFacCliL )->dFecCad
      :nBultos             := -( ::cFacCliL )->nBultos
      :nCajas              := -( ::cFacCliL )->nCanEnt

      if IsTrue( lNumeroSerie )
         :nUnidades        := if( nUnidades > 0, -1, 1 )
         :cNumeroSerie     := ( ::cFacCliS )->cNumSer
      else
         :nUnidades        := -nUnidades
      end if
      
      ::Integra( hb_QWith() )

   end with

   RETURN nil


//---------------------------------------------------------------------------//

METHOD InsertStockRectificativaClientes( lNumeroSerie )

   local nUnidades         := nTotNFacRec( ::cFacRecL )

   with object ( SStock():New() )
   
      :cTipoDocumento      := FAC_REC
      :cAlias              := ( ::cFacRecL )
      :cNumeroDocumento    := ( ::cFacRecL )->cSerie + "/" + alltrim( Str( ( ::cFacRecL )->nNumFac ) )
      :cDelegacion         := ( ::cFacRecL )->cSufFac
      :dFechaDocumento     := ( ::cFacRecL )->dFecFac
      :tFechaDocumento     := ( ::cFacRecL )->tFecFac
      :cCodigo             := ( ::cFacRecL )->cRef
      :cCodigoAlmacen      := ( ::cFacRecL )->cAlmLin
      :cCodigoPropiedad1   := ( ::cFacRecL )->cCodPr1
      :cCodigoPropiedad2   := ( ::cFacRecL )->cCodPr2
      :cValorPropiedad1    := ( ::cFacRecL )->cValPr1
      :cValorPropiedad2    := ( ::cFacRecL )->cValPr2
      :cLote               := ( ::cFacRecL )->cLote
      :dFechaCaducidad     := ( ::cFacRecL )->dFecCad
      :nBultos             := -( ::cFacRecL )->nBultos
      :nCajas              := -( ::cFacRecL )->nCanEnt

      if IsTrue( lNumeroSerie )
         :nUnidades        := if( nUnidades > 0, -1, 1 )
         :cNumeroSerie     := ( ::cFacRecS )->cNumSer
      else
         :nUnidades        := - nUnidades
      end if
      
      ::Integra( hb_QWith() )

   end with

   RETURN nil


//---------------------------------------------------------------------------//

METHOD InsertStockTiketsClientes( lNumeroSerie, lCombinado )

   local nUnidades            := nTotVTikTpv( ::cTikL )

   with object ( SStock():New() )

      do case
      case ( ::cTikL )->cTipTil == SAVTIK
         :cTipoDocumento      := TIK_CLI

      case ( ::cTikL )->cTipTil == SAVDEV
         :cTipoDocumento      := DEV_CLI

      case ( ::cTikL )->cTipTil == SAVVAL
         :cTipoDocumento      := VAL_CLI

      case ( ::cTikL )->cTipTil == SAVAPT
         :cTipoDocumento      := APT_CLI

      end case

      :cAlias                 := ( ::cTikL )
      :cNumeroDocumento       := ( ::cTikL )->cSerTil + "/" + alltrim( ( ::cTikL )->cNumTil )
      :cDelegacion            := ( ::cTikL )->cSufTil
      :dFechaDocumento        := ( ::cTikL )->dFecTik
      :tFechaDocumento        := ( ::cTikL )->tFecTik

      if IsTrue( lCombinado)
         :cCodigo             := ( ::cTikL )->cComTil
      else
         :cCodigo             := ( ::cTikL )->cCbaTil
      end if

      :cCodigoAlmacen         := ( ::cTikL )->cAlmLin
      :cCodigoPropiedad1      := ( ::cTikL )->cCodPr1
      :cCodigoPropiedad2      := ( ::cTikL )->cCodPr2
      :cValorPropiedad1       := ( ::cTikL )->cValPr1
      :cValorPropiedad2       := ( ::cTikL )->cValPr2
      :cLote                  := ( ::cTikL )->cLote

      if IsTrue( lNumeroSerie )

         if ( ( ::cTikL )->cTipTil == SAVTIK .or. ( ::cTikL )->cTipTil == SAVAPT )
            :nUnidades        := if( nUnidades > 0, -1, 1 )
         else
            :nUnidades        := if( nUnidades > 0, 1, -1 )
         end if

         :cNumeroSerie        := ( ::cTikS )->cNumSer

      else
         
         :nUnidades           := - nTotNTickets( ::cTikL )

      end if

      ::Integra( hb_QWith() )

   end with

RETURN nil

//---------------------------------------------------------------------------//

METHOD InsertStockMaterialesProducidos( lNumeroSerie )

   local nUnidades         := nTotNProduccion( ::cProducL )

   with object ( SStock():New() )

      :cTipoDocumento      := PRO_LIN
      :cAlias              := ( ::cProducL )
      :cNumeroDocumento    := ( ::cProducL )->cSerOrd + "/" + alltrim( Str( ( ::cProducL )->nNumOrd ) )
      :cDelegacion         := ( ::cProducL )->cSufOrd
      :dFechaDocumento     := ( ::cProducL )->dFecOrd
      :tFechaDocumento     := ( ::cProducL )->cHorIni
      :cCodigo             := ( ::cProducL )->cCodArt
      :cCodigoAlmacen      := ( ::cProducL )->cAlmOrd
      :cCodigoPropiedad1   := ( ::cProducL )->cCodPr1
      :cCodigoPropiedad2   := ( ::cProducL )->cCodPr2
      :cValorPropiedad1    := ( ::cProducL )->cValPr1
      :cValorPropiedad2    := ( ::cProducL )->cValPr2
      :cLote               := ( ::cProducL )->cLote
      :dFechaCaducidad     := ( ::cProducL )->dFecCad
      :nCajas              := ( ::cProducL )->nCajOrd
      :nBultos             := ( ::cProducL )->nBultos

      if isTrue( lNumeroSerie )
         :nUnidades        := if( nUnidades > 0, 1, -1 )
         :cNumeroSerie     := ( ::cProducS )->cNumSer
      else
         :nUnidades        := nUnidades
      end if

      ::Integra( hb_QWith() )

   end with

   RETURN nil

//---------------------------------------------------------------------------//

METHOD InsertStockMateriasPrimas( lNumeroSerie )


   local nUnidades         := nTotNMaterial( ::cProducM )

   with object ( SStock():New() )

      :cTipoDocumento      := PRO_MAT
      :cAlias              := ( ::cProducM )
      :cNumeroDocumento    := ( ::cProducM )->cSerOrd + "/" + alltrim( Str( ( ::cProducM )->nNumOrd ) )
      :cDelegacion         := ( ::cProducM )->cSufOrd
      :dFechaDocumento     := ( ::cProducM )->dFecOrd
      :tFechaDocumento     := ( ::cProducM )->cHorIni
      :cCodigo             := ( ::cProducM )->cCodArt
      :cCodigoAlmacen      := ( ::cProducM )->cAlmOrd
      :cCodigoPropiedad1   := ( ::cProducM )->cCodPr1
      :cCodigoPropiedad2   := ( ::cProducM )->cCodPr2
      :cValorPropiedad1    := ( ::cProducM )->cValPr1
      :cValorPropiedad2    := ( ::cProducM )->cValPr2
      :cLote               := ( ::cProducM )->cLote
      :nCajas              := -( ::cProducM )->nCajOrd
      :nBultos             := -( ::cProducM )->nBultos

      if IsTrue( lNumeroSerie )
         :nUnidades        := if( nUnidades > 0, -1, 1 )
         :cNumeroSerie     := ( ::cProducP )->cNumSer
      else
         :nUnidades        := - nUnidades
      end if

         ::Integra( hb_QWith() )

   end with

   RETURN nil

//---------------------------------------------------------------------------//

METHOD nUnidadesInStock()  
      
   local o
   local nStockArticulo := 0

   for each o in ::aStocks
      nStockArticulo    += o:nUnidades 
   next

RETURN ( nStockArticulo )

//---------------------------------------------------------------------------//

METHOD nPendientesRecibirInStock()  
   
   local o
   local nStockArticulo := 0

   for each o in ::aStocks
      nStockArticulo    += o:nPendientesRecibir
   next 

RETURN ( nStockArticulo )

//---------------------------------------------------------------------------//

METHOD nPendientesEntregarInStock()  
   
   local o
   local nStockArticulo := 0

   for each o in ::aStocks
      nStockArticulo    += o:nPendientesEntregar
   next 

RETURN ( nStockArticulo )

//---------------------------------------------------------------------------//

METHOD StockInit( cPath, cPathOld, oMsg, nCalcCosto, cCodEmpOld, cCodEmpNew ) CLASS TStock

   local aAlm
   local sStk
   local aStk
   local dbfAlm
   local dbfCnt
   local oldArt
   local oldTikL
   local nNumDoc
   local oldProLin
   local oldProMat
   local oldPedPrvL
   local oldAlbPrvL
   local oldFacPrvL
   local oldRctPrvL
   local oldPedCliL
   local oldAlbCliL
   local oldFacCliL
   local oldFacRecL
   local hCampos
   local hLines
   local parentId

   if empty( cPathOld )
      RETURN nil
   end if

   aAlm              := {}
   aStk              := {}

   if ::lOpenFiles( cPath, .t. )

      ::lStockInit   := .t.

      ::lAlbPrv      := .t.
      ::lAlbCli      := .t.

      USE ( cPath + "NCount.Dbf" ) NEW VIA ( ::cDriver ) SHARED ALIAS ( cCheckArea( "NCount", @dbfCnt ) )
      SET ADSINDEX TO ( cPath + "NCount.Cdx" ) ADDITIVE

      USE ( cPatAlm() + "Almacen.Dbf" ) NEW VIA ( ::cDriver ) SHARED ALIAS ( cCheckArea( "ALMACEN", @dbfAlm ) )
      SET ADSINDEX TO ( cPatAlm() + "Almacen.Cdx" ) ADDITIVE

      USE ( cPathOld + "Articulo.Dbf" ) NEW VIA ( ::cDriver ) SHARED ALIAS ( cCheckArea( "ARTICULO", @oldArt ) )
      SET ADSINDEX TO ( cPathOld + "ARTICULO.CDX" ) ADDITIVE

      USE ( cPathOld + "PEDPROVL.DBF" ) NEW VIA ( ::cDriver ) SHARED ALIAS ( cCheckArea( "PedPrvL", @oldPedPrvL ) )
      SET ADSINDEX TO ( cPathOld + "PEDPROVL.CDX" ) ADDITIVE

      USE ( cPathOld + "ALBPROVL.Dbf" ) NEW VIA ( ::cDriver ) SHARED ALIAS ( cCheckArea( "ALBPRVL", @oldAlbPrvL ) )
      SET ADSINDEX TO ( cPathOld + "ALBPROVL.CDX" ) ADDITIVE

      USE ( cPathOld + "FACPRVL.Dbf" ) NEW VIA ( ::cDriver ) SHARED ALIAS ( cCheckArea( "FACPRVL", @oldFacPrvL ) )
      SET ADSINDEX TO ( cPathOld + "FACPRVL.CDX" ) ADDITIVE

      USE ( cPathOld + "RctPrvL.Dbf" ) NEW VIA ( ::cDriver ) SHARED ALIAS ( cCheckArea( "RctPrvL", @oldRctPrvL ) )
      SET ADSINDEX TO ( cPathOld + "RctPrvL.CDX" ) ADDITIVE

      USE ( cPathOld + "PEDCLIL.DBF" ) NEW VIA ( ::cDriver ) SHARED ALIAS ( cCheckArea( "PedCliL", @oldPedCliL ) )
      SET ADSINDEX TO ( cPathOld + "PEDCLIL.CDX" ) ADDITIVE

      USE ( cPathOld + "ALBCLIL.Dbf" ) NEW VIA ( ::cDriver ) SHARED ALIAS ( cCheckArea( "ALBCLIL", @oldAlbCliL ) )
      SET ADSINDEX TO ( cPathOld + "ALBCLIL.CDX" ) ADDITIVE

      USE ( cPathOld + "FACCLIL.Dbf" ) NEW VIA ( ::cDriver ) SHARED ALIAS ( cCheckArea( "FACCliL", @oldFacCliL ) )
      SET ADSINDEX TO ( cPathOld + "FACCliL.CDX" ) ADDITIVE

      USE ( cPathOld + "FACRECL.Dbf" ) NEW VIA ( ::cDriver ) SHARED ALIAS ( cCheckArea( "FACRECL", @oldFacRecL ) )
      SET ADSINDEX TO ( cPathOld + "FACRECL.CDX" ) ADDITIVE

      USE ( cPathOld + "TIKEL.Dbf" ) NEW VIA ( ::cDriver ) SHARED ALIAS ( cCheckArea( "TIKEL", @oldTikL ) )
      SET ADSINDEX TO ( cPathOld + "TIKEL.CDX" ) ADDITIVE

      USE ( cPathOld + "PROLIN.DBF" ) NEW VIA ( ::cDriver ) SHARED ALIAS ( cCheckArea( "PROLIN", @oldProLin ) )
      SET ADSINDEX TO ( cPathOld + "PROLIN.CDX" ) ADDITIVE

      USE ( cPathOld + "PROMAT.DBF" ) NEW VIA ( ::cDriver ) SHARED ALIAS ( cCheckArea( "PROMAT", @oldProMat ) )
      SET ADSINDEX TO ( cPathOld + "PROMAT.CDX" ) ADDITIVE

      ::cPedPrvL                             := oldPedPrvL
      ::cAlbPrvL                             := oldAlbPrvL
      ::cFacPrvL                             := oldFacPrvL
      ::cRctPrvL                             := oldRctPrvL
      ::cPedCliL                             := oldPedCliL
      ::cAlbCliL                             := oldAlbCliL
      ::cFacCliL                             := oldFacCliL
      ::cFacRecL                             := oldFacRecL
      ::cTikL                                := oldTikL
      ::cProducL                             := oldProLin
      ::cProducM                             := oldProMat

      /*
      Rellenemaos el arry con los stocks---------------------------------------
      */

      ( oldArt )->( dbGoTop() )
      while !( oldArt )->( eof() )
         aEval( ::aStockArticuloEmpresa( ( oldArt )->Codigo, cCodEmpOld ), {|s| aAdd( aStk, s ) } ) //, ( dbfAlm )->cCodAlm )
         sysrefresh()
         ( oldArt )->( dbSkip() )
      end while

      /*
      Recorrremos los almacenes------------------------------------------------
      */

      ( dbfAlm )->( dbGoTop() )
      while !( dbfAlm )->( eof() )

         if aScan( aAlm, ( dbfAlm )->cCodAlm ) == 0

            aAdd( aAlm, ( dbfAlm )->cCodAlm )

            /*
            Creo la cabecera de los movimientos de traspaso--------------------
            */

            hCampos        := SQLMovimientosAlmacenModel():loadBlankBuffer()

            hset( hCampos, "almacen_destino", ( dbfAlm )->cCodAlm )
            hset( hCampos, "tipo_movimiento", 4 )
            hset( hCampos, "empresa", cCodEmpNew )

            parentId       := hGet( hCampos, "uuid" )

            SQLMovimientosAlmacenModel():Insertbuffer( hCampos )

            /*
            Creo las líneas de los movimientos de traspaso---------------------
            */            

            for each sStk in aStk

               if !empty( sStk:cCodigo )                          .and. ;
                  !empty( sStk:nUnidades )                        .and. ;
                  ( sStk:cCodigoAlmacen == ( dbfAlm )->cCodAlm )

                  hLines   := SQLMovimientosAlmacenLineasModel():loadBlankBuffer()

                  hset( hLines, "parent_uuid", parentId )
                  hset( hLines, "codigo_articulo", sStk:cCodigo )
                  hset( hLines, "nombre_articulo", RetFld( sStk:cCodigo, oldArt, "Nombre", "Codigo" ) )
                  hset( hLines, "codigo_primera_propiedad", sStk:cCodigoPropiedad1 )
                  hset( hLines, "valor_primera_propiedad", sStk:cValorPropiedad1 )
                  hset( hLines, "codigo_segunda_propiedad", sStk:cCodigoPropiedad2 )
                  hset( hLines, "valor_segunda_propiedad", sStk:cValorPropiedad2 )
                  hset( hLines, "fecha_caducidad", sStk:dFechaCaducidad )
                  hset( hLines, "lote", sStk:cLote )
                  hset( hLines, "bultos_articulo", sStk:nBultos )
                  hset( hLines, "cajas_articulo", sStk:nCajas )
                  hset( hLines, "unidades_articulo", sStk:nUnidades )
                  hset( hLines, "precio_articulo", RetFld( sStk:cCodigo, oldArt, "pCosto", "Codigo" ) )

                  SQLMovimientosAlmacenLineasModel():Insertbuffer( hLines )

               end if

               sysrefresh()

            next

         end if

         ( dbfAlm )->( dbSkip() )

      end while

      CLOSE ( dbfAlm     )
      CLOSE ( dbfCnt     )

      CLOSE ( oldArt     )
      CLOSE ( oldPedCliL )
      CLOSE ( oldAlbCliL )
      CLOSE ( oldFacCliL )
      CLOSE ( oldFacRecL )
      CLOSE ( oldTikL    )
      CLOSE ( oldPedPrvL )
      CLOSE ( oldAlbPrvL )
      CLOSE ( oldFacPrvL )
      CLOSE ( oldRctPrvL )
      CLOSE ( oldProLin  )
      CLOSE ( oldProMat  )

      ::CloseFiles()

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD nTotalSaldo( cCodArt, cCodCli, dFecha ) CLASS TStock

   local nTotal   := 0
   local nOrdLin
   local nRecCab
   local nRecLin

   /*
   Albaranes de clientes-------------------------------------------------------
   */

   nRecCab        := ( ::cAlbCliT )->( RecNo() )
   nRecLin        := ( ::cAlbCliL )->( Recno() )
   nOrdLin        := ( ::cAlbCliL )->( ordsetfocus( "cRef" ) )

   if ( ::cAlbCliL )->( dbSeek( cCodArt ) )

      while ( ::cAlbCliL )->cRef == cCodArt .and. !( ::cAlbCliL )->( Eof() )

         if dbSeekInOrd( ( ::cAlbCliL )->cSerAlb + Str( ( ::cAlbCliL )->nNumAlb ) + ( ::cAlbCliL )->cSufAlb, "nNumAlb", ::cAlbCliT )  .and.;
            ( ::cAlbCliT )->cCodCli == cCodCli .and.;
            ( ::cAlbCliT )->dFecAlb <= dFecha .and.;
            !lFacturado( ::cAlbCliT )

            nTotal   += nTotNAlbCli( ::cAlbCliL )

         end if

         ( ::cAlbCliL )->( dbSkip() )

      end if

   end if

   ( ::cAlbCliL )->( ordsetfocus( nOrdLin ) )
   ( ::cAlbCliL )->( dbGoTo( nRecLin ) )
   ( ::cAlbCliT )->( dbGoTo( nRecCab ) )

   /*
   Facturas de clientes--------------------------------------------------------
   */

   nRecCab        := ( ::cFacCliT )->( RecNo() )
   nRecLin        := ( ::cFacCliL )->( Recno() )
   nOrdLin        := ( ::cFacCliL )->( ordsetfocus( "cRef" ) )

   if ( ::cFacCliL )->( dbSeek( cCodArt ) )

      while ( ::cFacCliL )->cRef == cCodArt .and. !( ::cFacCliL )->( Eof() )

         if dbSeekInOrd( ( ::cFacCliL )->cSerie + Str( ( ::cFacCliL )->nNumFac ) + ( ::cFacCliL )->cSufFac, "NNUMFAC", ::cFacCliT ) .and.;
            ( ::cFacCliT )->cCodCli == cCodCli .and.;
            ( ::cFacCliT )->dFecFac <= dFecha

            nTotal   += nTotNFacCli( ::cFacCliL )

         end if

         ( ::cFacCliL )->( dbSkip() )

      end if

   end if

   ( ::cFacCliL )->( ordsetfocus( nOrdLin ) )
   ( ::cFacCliL )->( dbGoTo( nRecLin ) )
   ( ::cFacCliT )->( dbGoTo( nRecCab ) )

   /*
   Facturas rectificativas de clientes-----------------------------------------
   */

   nRecCab        := ( ::cFacRecT )->( RecNo() )
   nRecLin        := ( ::cFacRecL )->( Recno() )
   nOrdLin        := ( ::cFacRecL )->( ordsetfocus( "cRef" ) )

   if ( ::cFacRecL )->( dbSeek( cCodArt ) )

      while ( ::cFacRecL )->cRef == cCodArt .and. !( ::cFacRecL )->( Eof() )

         if dbSeekInOrd( ( ::cFacRecL )->cSerie + Str( ( ::cFacRecL )->nNumFac ) + ( ::cFacRecL )->cSufFac, "NNUMFAC", ::cFacRecT ) .and.;
            ( ::cFacRecT )->cCodCli == cCodCli .and.;
            ( ::cFacRecT )->dFecFac <= dFecha

            nTotal   += nTotNFacRec( ::cFacRecL )

         end if

         ( ::cFacRecL )->( dbSkip() )

      end if

   end if

   ( ::cFacRecL )->( ordsetfocus( nOrdLin ) )
   ( ::cFacRecL )->( dbGoTo( nRecLin ) )
   ( ::cFacRecT )->( dbGoTo( nRecCab ) )

   /*
   Ticktes de clientes---------------------------------------------------------
   */

   nRecCab        := ( ::cTikT )->( RecNo() )
   nRecLin        := ( ::cTikL )->( Recno() )
   nOrdLin        := ( ::cTikL )->( ordsetfocus( "CCBATIL" ) )

   if ( ::cTikL )->( dbSeek( cCodArt ) )

      while ( ::cTikL )->cCbaTil == cCodArt .and. !( ::cTikL )->( Eof() )

         if dbSeekInOrd( ( ::cTikL )->cSerTil + ( ::cTikL )->cNumTil + ( ::cTikL )->cSufTil, "CNUMTIK", ::cTikT ) .and.;
            ( ::cTikT )->cCliTik == cCodCli .and.;
            ( ::cTikT )->dFecTik <= dFecha

            nTotal   += ( ::cTikL )->nUntTil

         end if

         ( ::cTikL )->( dbSkip() )

      end if

   end if

   ( ::cTikL )->( ordsetfocus( nOrdLin ) )
   ( ::cTikL )->( dbGoTo( nRecLin ) )
   ( ::cTikT )->( dbGoTo( nRecCab ) )

   /*
   Tickets Combinados----------------------------------------------------------
   */

   nRecCab        := ( ::cTikT )->( RecNo() )
   nRecLin        := ( ::cTikL )->( Recno() )
   nOrdLin        := ( ::cTikL )->( ordsetfocus( "CCOMTIL" ) )

   if ( ::cTikL )->( dbSeek( cCodArt ) )

      while ( ::cTikL )->cComTil == cCodArt .and. !( ::cTikL )->( Eof() )

         if dbSeekInOrd( ( ::cTikL )->cSerTil + ( ::cTikL )->cNumTil + ( ::cTikL )->cSufTil, "CNUMTIK", ::cTikT ) .and.;
            ( ::cTikT )->cCliTik == cCodCli .and.;
            ( ::cTikT )->dFecTik <= dFecha

            nTotal   += ( ::cTikL )->nUntTil

         end if

         ( ::cTikL )->( dbSkip() )

      end if

   end if

   ( ::cTikL )->( ordsetfocus( nOrdLin ) )
   ( ::cTikL )->( dbGoTo( nRecLin ) )
   ( ::cTikT )->( dbGoTo( nRecCab ) )

RETURN ( nTotal)

//---------------------------------------------------------------------------//

METHOD nSaldoDocumento( cCodArt, cNumDoc ) CLASS TStock

   local nTotal   := 0
   local nRecLin  := ( ::cFacCliL )->( Recno() )
   local nOrdAnt  := ( ::cFacCliL )->( ordsetfocus( "nNumFac" ) )

   if ( ::cFacCliL )->( dbSeek( cNumDoc ) )

      while ( ::cFacCliL )->cSerie + Str( ( ::cFacCliL )->nNumFac ) + ( ::cFacCliL )->cSufFac == cNumDoc .and. !( ::cFacCliL )->( Eof())

         if ( ::cFacCliL )->cRef == cCodArt

            nTotal   += nTotNFacCli( ::cFacCliL )

         end if

         ( ::cFacCliL )->( dbSkip() )

      end while

   end if

   ( ::cFacCliL )->( ordsetfocus( nOrdAnt ) )
   ( ::cFacCliL )->( dbGoTo( nRecLin ) )

RETURN ( nTotal )

//---------------------------------------------------------------------------//

METHOD nSaldoAnterior( cCodArt, cNumDoc ) CLASS TStock

   local cCodCli
   local dFecha
   local nRec     := ( ::cFacCliT )->( Recno() )
   local nOrdAnt  := ( ::cFacCliT )->( ordsetfocus( "NNUMFAC" ) )

   if ( ::cFacCliT )->( dbSeek( cNumDoc ) )
      cCodCli     := ( ::cFacCliT )->cCodCli
      dFecha      := ( ::cFacCliT )->dFecFac
   end if

   ( ::cFacCliT )->( ordsetfocus( nOrdAnt ) )
   ( ::cFacCliT )->( dbGoTo( nRec ) )

RETURN ( ::nTotalSaldo( cCodArt, cCodCli, dFecha ) - ::nSaldoDocumento( cCodArt, cNumDoc ) )

//---------------------------------------------------------------------------//

METHOD nSaldoDocAlb( cCodArt, cNumDoc ) CLASS TStock

   local nTotal   := 0
   local nRecLin  := ( ::cAlbCliL )->( Recno() )
   local nOrdAnt  := ( ::cAlbCliL )->( ordsetfocus( "nNumAlb" ) )

   if ( ::cAlbCliL )->( dbSeek( cNumDoc ) )

      while ( ::cAlbCliL )->cSerAlb + Str( ( ::cAlbCliL )->nNumAlb ) + ( ::cAlbCliL )->cSufAlb == cNumDoc .and. !( ::cAlbCliL )->( Eof())

         if ( ::cAlbCliL )->cRef == cCodArt

            nTotal   += nTotNAlbCli( ::cAlbCliL )

         end if

         ( ::cAlbCliL )->( dbSkip() )

      end while

   end if

   ( ::cAlbCliL )->( ordsetfocus( nOrdAnt ) )
   ( ::cAlbCliL )->( dbGoTo( nRecLin ) )

RETURN ( nTotal )

//---------------------------------------------------------------------------//

METHOD nSaldoAntAlb( cCodArt, cNumDoc ) CLASS TStock

   local cCodCli
   local dFecha
   local nRec     := ( ::cAlbCliT )->( Recno() )
   local nOrdAnt  := ( ::cAlbCliT )->( ordsetfocus( "NNUMALB" ) )

   if ( ::cAlbCliT )->( dbSeek( cNumDoc ) )
      cCodCli     := ( ::cAlbCliT )->cCodCli
      dFecha      := ( ::cAlbCliT )->dFecAlb
   end if

   ( ::cAlbCliT )->( ordsetfocus( nOrdAnt ) )
   ( ::cAlbCliT )->( dbGoTo( nRec ) )

RETURN ( ::nTotalSaldo( cCodArt, cCodCli, dFecha ) - ::nSaldoDocAlb( cCodArt, cNumDoc ) )

//---------------------------------------------------------------------------//

METHOD nCostoMedio( cCodArt, cCodAlm, cCodPr1, cCodPr2, cValPr1, cValPr2, cLote ) CLASS TStock
   
   local oRowSet
   local nUnidades      := 0
   local nImporte       := 0
   local nCostoMedio    := 0
   local nOrdAlbPrvL    := ( ::cAlbPrvL )->( ordsetfocus( "cStkRef" ) )
   local nOrdFacPrvL    := ( ::cFacPrvL )->( ordsetfocus( "cRefLote" ) )
   local nOrdRctPrvL    := ( ::cRctPrvL )->( ordsetfocus( "cRef" ) )
   local nOrdProducL    := ( ::cProducL )->( ordsetfocus( "cArtLot" ) )

   DEFAULT cCodPr1      := Space( 20 )
   DEFAULT cCodPr2      := Space( 20 )
   DEFAULT cValPr1      := Space( 40 )
   DEFAULT cValPr2      := Space( 40 )
   DEFAULT cLote        := Space( 12 )

   
   oRowSet              := MovimientosAlmacenLineasRepository();
                              :getRowSetMovimientosForArticulo( { "codigo_articulo"          => cCodArt,;
                                                                  "almacen"                  => cCodAlm,;
                                                                  "codigo_primera_propiedad" => cCodPr1,;
                                                                  "codigo_segunda_propiedad" => cCodPr2,;
                                                                  "valor_primera_propiedad"  => cValPr1,;
                                                                  "valor_segunda_propiedad"  => cValPr2,;
                                                                  "lote"                     => cLote } )

   /*
   Recorremos movimientos de almacén-------------------------------------------
   */

   if !empty( oRowSet )

      oRowSet:goTop()
      while !( oRowSet:Eof() )

         nUnidades   += oRowSet:fieldget( 'total_unidades' )
         nImporte    += oRowSet:fieldget( 'precio_articulo' )

         oRowSet:skip()

      end while

   end if 

   /*
   Recorremos Albaranes de proveedores-----------------------------------------
   */

   if ( ::cAlbPrvL )->( dbSeek( cCodArt + cValPr1 + cValPr2 + cLote ) )

      while ( ::cAlbPrvL )->cRef == cCodArt                             .and.;
         ( empty( cValPr1 ) .or. ( ::cAlbPrvL )->cValPr1 == cValPr1 )   .and.;
         ( empty( cValPr2 ) .or. ( ::cAlbPrvL )->cValPr2 == cValPr2 )   .and.;
         ( empty( cLote )   .or. ( ::cAlbPrvL )->cLote == cLote )       .and.;
         !( ::cAlbPrvL )->( eof() )

         nUnidades   += nTotNAlbPrv( ::cAlbPrvL )
         nImporte    += nTotLAlbPrv( ::cAlbPrvL, ::nDecIn, ::nDerIn )

         ( ::cAlbPrvL )->( dbSkip() )

      end while

   end if

   /*
   Recorremos Facturas de proveedores------------------------------------------
   */

   if ( ::cFacPrvL )->( dbSeek( cCodArt + cValPr1 + cValPr2 + cLote ) )

      while ( ::cFacPrvL )->cRef == cCodArt                         .and.;
      ( empty( cValPr1 ) .or. ( ::cFacPrvL )->cValPr1 == cValPr1 )  .and.;
      ( empty( cValPr2 ) .or. ( ::cFacPrvL )->cValPr2 == cValPr2 )  .and.;
      ( empty( cLote )   .or. ( ::cFacPrvL )->cLote == cLote )      .and.;
      !( ::cFacPrvL )->( eof() )

         nUnidades   += nTotNFacPrv( ::cFacPrvL )
         nImporte    += nTotLFacPrv( ::cFacPrvL, ::nDecIn, ::nDerIn )

         ( ::cFacPrvL )->( dbSkip() )

      end while

   else 

   end if

   /*
   Recorremos Facturas rectificativas de proveedores---------------------------
   */

   if ( ::cRctPrvL )->( dbSeek( cCodArt + cValPr1 + cValPr2 + cLote ) )

      while ( ::cRctPrvL )->cRef == cCodArt                          .and.;
      ( empty ( cValPr1 ) .or. ( ::cRctPrvL )->cValPr1 == cValPr1 )  .and.;
      ( empty ( cValPr2 ) .or. ( ::cRctPrvL )->cValPr2 == cValPr2 )  .and.;
      ( empty( cLote )    .or. ( ::cRctPrvL )->cLote == cLote )      .and.;
      !( ::cRctPrvL )->( eof() )

         nUnidades   += nTotNRctPrv( ::cRctPrvL )
         nImporte    += nTotLRctPrv( ::cRctPrvL, ::nDecIn, ::nDerIn )

         ( ::cRctPrvL )->( dbSkip() )

      end while

   end if

   /*
   Recorremos partes de producción---------------------------
   */

   if ( ::cProducL )->( dbSeek( cCodArt + cValPr1 + cValPr2 + cLote ) )

      while ( ::cProducL )->cCodArt == cCodArt                          .and.;
         ( empty( cValPr1 ) .or. ( ::cProducL )->cValPr1 == cValPr1 )   .and.;
         ( empty( cValPr2 ) .or. ( ::cProducL )->cValPr2 == cValPr2 )   .and.;
         ( empty( cLote )    .or. ( ::cProducL )->cLote == cLote )      .and.;
         !( ::cProducL )->( eof() )
      
         nUnidades   += ( NotCaja( ( ::cProducL )->nCajOrd ) * ( ::cProducL )->nUndOrd )
         nImporte    += ( NotCaja( ( ::cProducL )->nCajOrd ) * ( ::cProducL )->nUndOrd ) * ( ( ::cProducL )->nImpOrd )

         ( ::cProducL )->( dbSkip() )

      end while

   end if

   /*
   Calculo del costo medio-----------------------------------------------------
   */

   if nImporte != 0 .and. nUnidades != 0
      nCostoMedio       := ( nImporte / nUnidades )
   end if

   /*
   Si el costo medio es 0, devolvemos el costo de la ficha---------------------
   */

   if nCostoMedio == 0 .and. !empty( ::cArticulo ) .and. !empty( ::cKit )
      nCostoMedio       := nCosto( cCodArt, ::cArticulo, ::cKit )
   end if

   /*
   Devolvemos el orden que tenian las tablas-----------------------------------
   */

   ( ::cAlbPrvL )->( ordsetfocus( nOrdAlbPrvL ) )
   ( ::cFacPrvL )->( ordsetfocus( nOrdFacPrvL ) )
   ( ::cRctPrvL )->( ordsetfocus( nOrdRctPrvL ) )
   ( ::cProducL )->( ordsetfocus( nOrdProducL ) )

RETURN ( nCostoMedio )

//---------------------------------------------------------------------------//

METHOD lValoracionCostoMedio( nTipMov )

RETURN ( !uFieldEmpresa( "lMovCos" ) .and. ( nTipMov == 2 .or. nTipMov == 4 .or. ntipMov == 1 )  )

//---------------------------------------------------------------------------//

METHOD Almacenes()

   ::aAlmacenes   := {}

   ( ::cAlm )->( dbGoTop() )
   while !( ::cAlm )->( eof() )

      if ascan( ::aAlmacenes, ( ::cAlm )->cCodAlm ) == 0
         aadd( ::aAlmacenes, ( ::cAlm )->cCodAlm )
      end if 

      ( ::cAlm )->( dbSkip() )
   end while

RETURN ( ::aAlmacenes )

//---------------------------------------------------------------------------//

METHOD aStockArticulo( cCodArt, cCodAlm, oBrw, lLote, lNumeroSerie, dFecIni, dFecFin, tHorIni, tHorFin, cCodEmp ) CLASS TStock

   local nRec
   local oBlock
   local oError 
   local dFecha         := Ctod( "" )
   local cSerie
   local nTotal
   local dFecDoc
   local nOrdAnt
   local oStocks
   local aAlmacenes
   local nSeconds       := seconds()

   DEFAULT lLote        := !uFieldEmpresa( "lCalLot" )
   DEFAULT lNumeroSerie := !uFieldEmpresa( "lCalSer" )

   cCodArt              := padr( cCodArt, 18 )
   cCodAlm              := padr( cCodAlm, 16 )

   ::Reset()

   if empty( cCodArt )
      RETURN ( ::aStocks )
   else
      cCodArt           := left( cCodArt, 18 )
   end if

   lNumeroSerie         := !uFieldEmpresa( "lCalSer" )

   ::cCodigoArticulo    := cCodArt
   ::cCodigoAlmacen     := cCodAlm
   ::lLote              := lLote
   ::lNumeroSerie       := lNumeroSerie
   ::dFechaInicio       := dFecIni
   ::dFechaFin          := dFecFin
   ::tHoraInicio        := tHorIni
   ::tHoraFin           := tHorFin 

   // Almacenes----------------------------------------------------------------

   if empty( cCodAlm )
      aAlmacenes        := ::aAlmacenes
   else 
      aAlmacenes        := { padr( cCodAlm, 16 ) }
   end if 

   // Browse-------------------------------------------------------------------

   if !empty( oBrw )
      oBrw:aArrayData   := {}
      oBrw:Refresh()
   end if

   // Proceso------------------------------------------------------------------

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   for each cCodAlm in aAlmacenes

      // Colocamos el codigo de almacen-----------------------------------------" )

      ::SetCodigoAlmacen( cCodAlm )
      SysRefresh()

      // Movimientos de almacén------------------------------------------------" )

      ::aStockMovimientosAlmacen( cCodArt, cCodAlm, cCodEmp )
      SysRefresh()

      // Albaranes de proveedor------------------------------------------------------" )

      ::aStockAlbaranProveedor( cCodArt, cCodAlm, lLote, lNumeroSerie )
      SysRefresh()

      // Facturas proveedor----------------------------------------------------" )

      ::aStockFacturaProveedor( cCodArt, cCodAlm, lLote, lNumeroSerie )
      SysRefresh()

      // Rectificativas de provedor--------------------------------------------" )

      ::aStockRectificativaProveedor( cCodArt, cCodAlm, lLote, lNumeroSerie )
      SysRefresh()

      // Pedidos de clientes-------------------------------------------------" )

      if ::lCalculateUnidadesPendientesRecibir
         ::aStockPedidoCliente( cCodArt, cCodAlm, lLote )
         SysRefresh()
      end if 

      // Albaranes de clientes-------------------------------------------------" )

      ::aStockAlbaranCliente( cCodArt, cCodAlm, lLote, lNumeroSerie )
      SysRefresh()

      // Factura de clientes--------------------------------------------------" )

      ::aStockFacturaCliente( cCodArt, cCodAlm, lLote, lNumeroSerie )
      SysRefresh()

      // Rectificativas de clientes--------------------------------------------" )

      ::aStockRectificativaCliente( cCodArt, cCodAlm, lLote, lNumeroSerie )
      SysRefresh()

      // Tickets de clientes---------------------------------------------------" )

      ::aStockTicketsCliente( cCodArt, cCodAlm, lLote, lNumeroSerie )
      SysRefresh()

      // Produccion------------------------------------------------------------" )

      ::aStockProduccion( cCodArt, cCodAlm, lLote, lNumeroSerie )
      SysRefresh()

      // Materia prima---------------------------------------------------------" )

      ::aStockMateriaPrima( cCodArt, cCodAlm, lLote, lNumeroSerie )
      SysRefresh()

      // Stock pendiente de entregar-------------------------------------------" )

      if !( ::getNotPendiente() )
         ::aStockPendiente( cCodArt, cCodAlm, lLote, lNumeroSerie )
         SysRefresh()
      end if 

   next 

   // Ahora vamos a ver si ya se han dado numeros de serie------------------------" )

   for each cSerie in ::aSeries
      aScan( ::aStocks, {|o| if( o:cNumeroSerie == cSerie, o:nUnidades -= 1, ) } )
   next

   // Asignamos el array al browse------------------------------------------------" )

   if empty( ::aStocks )
      ::Reset()
   end if

   // Colorcamos la informacion en el browse------------------------------------------------" )

   if !empty( oBrw )

      oBrw:aArrayData   := {}

      for each oStocks in ::aStocks

         if !empty( oStocks ) 
         
            if ( ::lStockInit ) .or. ;
               ( ( ( Round( oStocks:nUnidades, 6 ) != 0.000000 ) .or. ( Round( oStocks:nPendientesRecibir, 6 ) != 0.000000 ) .or. ( Round( oStocks:nPendientesEntregar, 6 ) != 0.000000 ) ) )

               aAdd( oBrw:aArrayData, oStocks )

            end if

         end if

      next

      oBrw:Refresh()

   end if

   // Control de erroress-------------------------------------------------------

   RECOVER USING oError
      msgStop( ErrorMessage( oError ), "Calculo de stock" )
   END SEQUENCE
   ErrorBlock( oBlock )

RETURN ( ::aStocks )

//---------------------------------------------------------------------------//

METHOD nStockArticulo( cCodArt, cCodAlm, oBrw, lLote, lNumeroSerie, dFecIni, dFecFin, tHorIni, tHorFin ) CLASS TStock

   local nStockArticulo := 0

   ::aStockArticulo( cCodArt, cCodAlm, oBrw, lLote, lNumeroSerie, dFecIni, dFecFin, tHorIni, tHorFin )

   aEval( ::aStocks, {|o| nStockArticulo += o:nUnidades } )

RETURN ( nStockArticulo )

//---------------------------------------------------------------------------//

METHOD nBultosArticulo( cCodArt, cCodAlm, oBrw, lLote, lNumeroSerie, dFecIni, dFecFin, tHorIni, tHorFin ) CLASS TStock

   local nBultosArticulo := 0

   ::aStockArticulo( cCodArt, cCodAlm, oBrw, lLote, lNumeroSerie, dFecIni, dFecFin, tHorIni, tHorFin )

   aEval( ::aStocks, {|o| nBultosArticulo += o:nBultos } )

RETURN ( nBultosArticulo )

//---------------------------------------------------------------------------//

METHOD nStockAlmacen( cCodArt, cCodAlm, cValPr1, cValPr2, cLote, dFecIni, dFecFin, tHorIni, tHorFin ) CLASS TStock

   local nStockArticulo := 0

   ::aStockArticulo( cCodArt, cCodAlm, nil, nil, nil, dFecIni, dFecFin, tHorIni, tHorFin )

   aEval( ::aStocks, {|o| if( ( empty( cCodAlm ) .or. alltrim( cCodAlm ) == alltrim( o:cCodigoAlmacen ) )   .and.;
                              ( empty( cValPr1 ) .or. alltrim( cValPr1 ) == alltrim( o:cValorPropiedad1 ) ) .and.;
                              ( empty( cValPr2 ) .or. alltrim( cValPr2 ) == alltrim( o:cValorPropiedad2 ) ) .and.;                  
                              ( empty( cLote   ) .or. alltrim( cLote   ) == alltrim( o:cLote )   ),;
                              nStockArticulo += o:nUnidades, ) } )

RETURN ( nStockArticulo )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

Method Integra( sStocks ) CLASS TStock

   local nPos

   if ::lIntegra

      nPos              := aScan( ::aStocks, {|o|  rtrim( o:cCodigo ) == rtrim( sStocks:cCodigo )                    .and.;
                                                   rtrim( o:cCodigoAlmacen ) == rtrim( sStocks:cCodigoAlmacen )      .and.;
                                                   rtrim( o:cValorPropiedad1 ) == rtrim( sStocks:cValorPropiedad1 )  .and.;
                                                   rtrim( o:cValorPropiedad2 ) == rtrim( sStocks:cValorPropiedad2 )  .and.;
                                                   if( ::lLote, rtrim( o:cLote ) == rtrim( sStocks:cLote ), .t. )    .and.;
                                                   if( ::lNumeroSerie, rtrim( o:cNumeroSerie ) == rtrim( sStocks:cNumeroSerie ), .t. ) } )
      if nPos != 0
         ::aStocks[ nPos ]:nUnidades               += sStocks:nUnidades
         ::aStocks[ nPos ]:nBultos                 += sStocks:nBultos
         ::aStocks[ nPos ]:nCajas                  += sStocks:nCajas
         ::aStocks[ nPos ]:nPendientesRecibir      += sStocks:nPendientesRecibir
         ::aStocks[ nPos ]:nPendientesEntregar     += sStocks:nPendientesEntregar
         ::aStocks[ nPos ]:nUnidadesEntregadas     += sStocks:nUnidadesEntregadas
         ::aStocks[ nPos ]:nUnidadesRecibidas      += sStocks:nUnidadesRecibidas
      else
         aAdd( ::aStocks, oClone( sStocks ) )
      end if

   else

      aAdd( ::aStocks, oClone( sStocks ) )

   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD oTreeStocks( cCodArt, cCodAlm )

   local x
   local cValue

   ::aStockArticulo( cCodArt, cCodAlm )

   if empty( ::aStocks )
      ::aStocks   := { sStock():New() }
   end if

   aSort( ::aStocks, , , {|x,y| x:cCodigo + x:cCodigoAlmacen + x:cValorPropiedad1 + x:cValorPropiedad2 + x:cLote + dtos( x:dFechaDocumento ) + x:tFechaDocumento < y:cCodigo + y:cCodigoAlmacen + y:cValorPropiedad1 + y:cValorPropiedad2 + y:cLote + dtos( y:dFechaDocumento ) + y:tFechaDocumento } )

   ::oTree        := TreeBegin()

   for each x in ::aStocks

      if cValue != x:cCodigo + x:cCodigoAlmacen + x:cValorPropiedad1 + x:cValorPropiedad2 + x:cLote

         if cValue != nil
            TreeEnd()
         end if 

         TreeAddItem( alltrim( x:cCodigoAlmacen ) + Space(1) + retAlmacen( x:cCodigoAlmacen, ::cAlm ) )

         TreeBegin()

      end if 

      TreeAddItem( x:Documento() ):Cargo := oClone( x )
         
      cValue      := x:cCodigo + x:cCodigoAlmacen + x:cValorPropiedad1 + x:cValorPropiedad2 + x:cLote
      
   next 

   if cValue != nil 
      TreeEnd()
   end if

   TreeEnd()

RETURN ( ::oTree )

//---------------------------------------------------------------------------//

METHOD BrowseNumeroSerie( oCol, cCodArt, cCodAlm, aNumSer, oBrwSer )

   local oDlg
   local oGet
   local cGet
	local oBrw
   local uRet              := ""
   local oBrwCol
   local aStocks

   DEFAULT aNumSer         := {}

   ::aSeries               := aNumSer

   DEFINE DIALOG oDlg RESOURCE "BrowseNumeroSerie"  TITLE "Seleccionar número de serie"

      REDEFINE GET         oGet ;
         VAR               cGet ;
         ID                104 ;
         ON CHANGE         ( SeekOnStock( cGet, oBrw ) ) ;
         OF                oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:SetArray( ::aStocks, , , .f. )

      oBrw:nMarqueeStyle   := 5
      oBrw:lRecordSelector := .f.
      oBrw:lHScroll        := .f.
      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }
      oBrw:cName           := "Browse.NumSer"
      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }

      oBrw:CreateFromResource( 105 )

      with object ( oBrw:AddCol() )
         :cHeader          := "Número de serie"
         :bStrData         := {|| if( !empty( oBrw:aArrayData ), oBrw:aArrayData[ oBrw:nArrayAt ]:cNumeroSerie, "" ) }
         :nWidth           := 200
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Stock"
         :bStrData         := {|| if( !empty( oBrw:aArrayData ), Trans( oBrw:aArrayData[ oBrw:nArrayAt ]:nUnidades, MasUnd() ), 0 ) }
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Prp. 1"
         :bStrData         := {|| if( !empty( oBrw:aArrayData ), oBrw:aArrayData[ oBrw:nArrayAt ]:cValorPropiedad1, "" ) }
         :nWidth           := 60
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Prp. 2"
         :bStrData         := {|| if( !empty( oBrw:aArrayData ), oBrw:aArrayData[ oBrw:nArrayAt ]:cValorPropiedad2, "" ) }
         :nWidth           := 60
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Lote"
         :bStrData         := {|| oBrw:aArrayData[ oBrw:nArrayAt ]:cLote }
         :nWidth           := 140
      end with

      REDEFINE BUTTON ;
         ID       500 ;
         OF       oDlg ;
         ACTION   ( InsertOnStock( oCol, oBrw, oDlg, oBrwSer ) )

		REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )
      oDlg:AddFastKey( VK_F4,       {|| oDlg:end( IDOK ) } )
      oDlg:AddFastKey( VK_F5,       {|| InsertOnStock( oCol, oBrw, oDlg, oBrwSer ) } )

      oDlg:bStart          := {|| ::aStockArticulo( cCodArt, cCodAlm, oBrw ) }

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK
      uRet                 := oBrw:aArrayData[ oBrw:nArrayAt ]:cNumeroSerie
   end if

RETURN ( uRet )

//---------------------------------------------------------------------------//

METHOD nPedidoCliente( cCodCli )

   local nTotal      := 0
   local nRec        := ( ::cPedCliT )->( Recno() )
   local nOrdAnt     := ( ::cPedCliT )->( ordsetfocus( "cCodCli" ) )

   if empty( cCodCli )
      RETURN nTotal
   end if

   if ( ::cPedCliT )->( dbSeek( cCodCli ) )

      while ( ::cPedCliT )->cCodCli == cCodCli .and. !( ::cPedCliT )->( Eof() )

         nTotal   += nTotPedCli( ( ::cPedCliT )->cSerPed + Str( ( ::cPedCliT )->nNumPed ) + ( ::cPedCliT )->cSufPed, ::cPedCliT, ::cPedCliL, ::cDbfIva, ::cDbfDiv, ::cDbfFPago, nil, cDivEmp(), .f. )

         ( ::cPedCliT )->( dbSkip() )

      end while

   end if

   ( ::cPedCliT )->( ordsetfocus( nOrdAnt ) )
   ( ::cPedCliT )->( dbGoTo( nRec ) )

RETURN ( nTotal )

//---------------------------------------------------------------------------//

Method nOperacionesCliente( idCliente, lRiesgo )

RETURN ( 0 )

//---------------------------------------------------------------------------//

Method nFacturacionPendiente( idCliente )

RETURN ( 0 )

//---------------------------------------------------------------------------//

METHOD nPagadoCliente( idCliente )

RETURN ( 0 )

//---------------------------------------------------------------------------//

METHOD nFacturacionCliente( idCliente )

RETURN ( 0 )

//---------------------------------------------------------------------------//

Method nConsumoArticulo( cCodArt, cCodAlm, cValPr1, cValPr2, cLote, dFecIni, dFecFin ) CLASS TStock

   local dFecDoc
   local nUnidades         := 0
   local nOrdAlbCliL       := ( ::cAlbCliL )->( ordsetfocus( "cStkFast" ) )
   local nOrdFacCliL       := ( ::cFacCliL )->( ordsetfocus( "cRef"     ) )
   local nOrdFacRecL       := ( ::cFacRecL )->( ordsetfocus( "cRef"     ) )
   local nOrdTikCliL       := ( ::cTikL    )->( ordsetfocus( "cStkFast" ) )

   /*
   Albaranes de clientes-------------------------------------------------------
   */

   SysRefresh()

   if IsTrue( ::lAlbCli ) .and. ( ::cAlbCliL )->( dbSeek( cCodArt ) )

      while ( ::cAlbCliL )->cRef == cCodArt .and. !( ::cAlbCliL )->( Eof() )

         if ( empty( dFecIni ) .or. ( ::cAlbCliL )->dFecAlb >= dFecIni )   .and. ;
            ( empty( dFecFin ) .or. ( ::cAlbCliL )->dFecAlb <= dFecFin )   .and. ;
            ( empty( cValPr1 ) .or. ( ::cAlbCliL )->cValPr1 == cValPr1 )   .and. ;
            ( empty( cValPr2 ) .or. ( ::cAlbCliL )->cValPr2 == cValPr2 )   .and. ;
            ( empty( cCodAlm ) .or. ( ::cAlbCliL )->cAlmLin == cCodAlm ) 

            nUnidades      += nTotNAlbCli( ::cAlbCliL )

         end if

         ( ::cAlbCliL )->( dbSkip() )

      end while

   end if

   /*
   Facturas de clientes--------------------------------------------------------
   */

   SysRefresh()

   if ( ::cFacCliL )->( dbSeek( cCodArt ) )

      while ( ::cFacCliL )->cRef == cCodArt .and. !( ::cFacCliL )->( Eof() )

         if !empty( ( ::cFacCliL )->dFecAlb )
            dFecDoc        := ( ::cFacCliL )->dFecAlb
         else
            dFecDoc        := ( ::cFacCliL )->dFecFac
         end if

         if ( empty( dFecIni ) .or. dFecDoc >= dFecIni )    .and. ;
            ( empty( dFecFin ) .or. dFecDoc <= dFecFin )    .and. ;
            ( empty( cValPr1 ) .or. ( ::cFacCliL )->cValPr1 == cValPr1 )   .and. ;
            ( empty( cValPr2 ) .or. ( ::cFacCliL )->cValPr2 == cValPr2 )   .and. ;
            ( empty( cCodAlm ) .or. ( ::cFacCliL )->cAlmLin == cCodAlm )

            nUnidades      += nTotNFacCli( ::cFacCliL )

         end if

         ( ::cFacCliL )->( dbSkip() )

      end while

   end if

   /*
   Facturas rectificativas-----------------------------------------------------
   */

   SysRefresh()

   if ( ::cFacRecL )->( dbSeek( cCodArt ) )

      while ( ::cFacRecL )->cRef == cCodArt .and. !( ::cFacRecL )->( Eof() )

         if ( empty( dFecIni ) .or. ( ::cFacRecL )->dFecFac >= dFecIni )   .and. ;
            ( empty( dFecFin ) .or. ( ::cFacRecL )->dFecFac <= dFecFin )   .and. ;
            ( empty( cValPr1 ) .or. ( ::cFacRecL )->cValPr1 == cValPr1 )   .and. ;
            ( empty( cValPr2 ) .or. ( ::cFacRecL )->cValPr2 == cValPr2 )   .and. ;
            ( empty( cCodAlm ) .or. ( ::cFacRecL )->cAlmLin == cCodAlm )

            nUnidades      += nTotNFacRec( ::cFacRecL )

         end if

         ( ::cFacRecL )->( dbSkip() )

      end while

   end if

   /*
   Tickets de clientes normales------------------------------------------------
   */

   SysRefresh()

   if ( ::cTikL )->( dbSeek( cCodArt ) )

      while ( ::cTikL )->cCbaTil == cCodArt .and. !( ::cTikL )->( Eof() )

         if ( empty( dFecIni ) .or. ( ::cTikL )->dFecTik >= dFecIni )   .and. ;
            ( empty( dFecFin ) .or. ( ::cTikL )->dFecTik <= dFecFin )   .and. ;
            ( empty( cValPr1 ) .or. ( ::cTikL )->cValPr1 == cValPr1 )   .and. ;
            ( empty( cValPr2 ) .or. ( ::cTikL )->cValPr2 == cValPr2 )   .and. ;
            ( empty( cCodAlm ) .or. ( ::cTikL )->cAlmLin == cCodAlm ) 

            nUnidades   += nTotNTickets( ::cTikL )

         end if

         ( ::cTikL )->( dbSkip() )

      end while

   end if

   /*
   Tickets de clientes combinados----------------------------------------------
   */

   SysRefresh()

   ( ::cTikL )->( ordsetfocus( "cStkComb" ) )

   if ( ::cTikL )->( dbSeek( cCodArt ) )

      if !empty( ( ::cTikL )->cComTil )

         while ( ::cTikL )->cComTil == cCodArt .and. !( ::cTikL )->( Eof() )

            if ( empty( dFecIni ) .or. ( ::cTikL )->dFecTik >= dFecIni )   .and. ;
               ( empty( dFecFin ) .or. ( ::cTikL )->dFecTik <= dFecFin )   .and. ;
               ( empty( cValPr1 ) .or. ( ::cTikL )->cValPr1 == cValPr1 )   .and. ;
               ( empty( cValPr2 ) .or. ( ::cTikL )->cValPr2 == cValPr2 )   .and. ;
               ( empty( cCodAlm ) .or. ( ::cTikL )->cAlmLin == cCodAlm )

               nUnidades   += nTotNTickets( ::cTikL ) 

            end if 

            ( ::cTikL )->( dbSkip() )

         end while

      end if

   end if

   ( ::cAlbCliL )->( ordsetfocus( nOrdAlbCliL ) )
   ( ::cFacCliL )->( ordsetfocus( nOrdFacCliL ) )
   ( ::cFacRecL )->( ordsetfocus( nOrdFacRecL ) )
   ( ::cTikL    )->( ordsetfocus( nOrdTikCliL ) )

RETURN ( nUnidades )

//---------------------------------------------------------------------------//

METHOD setRiesgo( idCliente, oGetRiesgo, nRiesgoCliente, lAviso )

   local nRiesgo  := ::nRiesgo( idCliente )

   DEFAULT lAviso := uFieldEmpresa( "lSalPdt" , .f. )

   if isObject( oGetRiesgo )

      oGetRiesgo:cText( nRiesgo )

      if isNum( nRiesgoCliente )

         if ( nRiesgo > nRiesgoCliente )
            oGetRiesgo:setColor( Rgb( 255, 255, 255 ), Rgb( 255, 0, 0 ) )
         else
            oGetRiesgo:setColor( Rgb( 0, 0, 0 ), Rgb( 255, 255, 255 ) )
         end if

         oGetRiesgo:Refresh()

         if lAviso
            msgStop( "El riesgo alacanzado es de " + alltrim( Trans( nRiesgo, cPorDiv() ) ) + "; sobre el establecido en su ficha " + alltrim( Trans( nRiesgoCliente, cPorDiv() ) ) + ".",;
                     "El riesgo del cliente supera el límite establecido" )
         end if

      end if

   end if

RETURN ( nRiesgo )

//---------------------------------------------------------------------------//

METHOD lCheckConsolidacion( cCodigoArticulo, cCodigoAlmacen, cCodigoPrimeraPropiedad, cCodigoSegundaPropiedad, cValorPrimeraPropiedad, cValorSegundaPropiedad, cLote, dFecha, tHora )

   local dConsolidacion 

   dConsolidacion       := MovimientosAlmacenLineasRepository():getFechaHoraConsolidacion( cCodigoArticulo, cCodigoAlmacen, cCodigoPrimeraPropiedad, cCodigoSegundaPropiedad, cValorPrimeraPropiedad, cValorSegundaPropiedad, cLote, dFecha, tHora )

RETURN ( empty( dConsolidacion ) .or. dateTimeToTimeStamp( dFecha, tHora ) >= dConsolidacion )
   
//---------------------------------------------------------------------------//

METHOD SetCodigoAlmacen( cCodigoAlmacen )

   if empty( cCodigoAlmacen )
      aAllAlmacen( cCodigoAlmacen, ::uCodigoAlmacen, ::cAlm )
   else
      ::uCodigoAlmacen  := { cCodigoAlmacen }
      aChildAlmacen( cCodigoAlmacen, ::uCodigoAlmacen, ::cAlm )
   end if 

RETURN ( ::uCodigoAlmacen )

//---------------------------------------------------------------------------//

METHOD lCodigoAlmacen( cCodigoAlmacen )

   if empty( cCodigoAlmacen )
      RETURN .t.
   end if 

   if empty( ::uCodigoAlmacen )
      RETURN .t.
   end if

RETURN ( aScan( ::uCodigoAlmacen, cCodigoAlmacen ) != 0 )

//---------------------------------------------------------------------------//
//
// Movimientos de almacén------------------------------------------------------
//

METHOD aStockMovimientosAlmacen( cCodArt, cCodAlm, cCodEmp )

   local oRowSet     := MovimientosAlmacenLineasRepository();
                           :getRowSetMovimientosForArticulo( { "codigo_articulo" => cCodArt,;
                                                               "almacen" => cCodAlm,;
                                                               "empresa" => cCodEmp } )

   SysRefresh()

   oRowSet:goTop()

   while !( oRowSet:Eof() )

      if AllTrim( oRowSet:fieldget( 'almacen_destino' ) ) == AllTrim( cCodAlm )

         if ::validateDateTime( oRowSet:fieldget( 'fecha' ), oRowSet:fieldget( 'hora' ) )

            if ::lCheckConsolidacion( oRowSet:fieldget( 'codigo_articulo' ),;
                                      oRowSet:fieldget( 'almacen_destino' ),;
                                      oRowSet:fieldget( 'codigo_primera_propiedad' ),;
                                      oRowSet:fieldget( 'codigo_segunda_propiedad' ),;
                                      oRowSet:fieldget( 'valor_primera_propiedad' ),;
                                      oRowSet:fieldget( 'valor_segunda_propiedad' ),;
                                      oRowSet:fieldget( 'lote' ),;
                                      oRowSet:fieldget( 'fecha' ),;
                                      oRowSet:fieldget( 'hora' ) )

               ::InsertStockMovimientosAlmacenRowset( oRowSet , .t. )

            end if

         end if

      end if

      if AllTrim( oRowSet:fieldget( 'almacen_origen' ) ) == AllTrim( cCodAlm )

         if ::validateDateTime( oRowSet:fieldget( 'fecha' ), oRowSet:fieldget( 'hora' ) )

            if ::lCheckConsolidacion( oRowSet:fieldget( 'codigo_articulo' ),;
                                      oRowSet:fieldget( 'almacen_origen' ),;
                                      oRowSet:fieldget( 'codigo_primera_propiedad' ),;
                                      oRowSet:fieldget( 'codigo_segunda_propiedad' ),;
                                      oRowSet:fieldget( 'valor_primera_propiedad' ),;
                                      oRowSet:fieldget( 'valor_segunda_propiedad' ),;
                                      oRowSet:fieldget( 'lote' ),;
                                      oRowSet:fieldget( 'fecha' ),;
                                      oRowSet:fieldget( 'hora' ) )

               ::InsertStockMovimientosAlmacenRowset( oRowSet , .f. )

            end if

         end if

      end if

      oRowSet:skip()

   end while

RETURN ( nil )

//---------------------------------------------------------------------------//
//
// Albaran Proveedores---------------------------------------------------------
//

METHOD aStockAlbaranProveedor( cCodArt, cCodAlm, lLote, lNumeroSerie )

   local cCodigoArticulo      := ""
   local nOrdAlbPrvL          := ( ::cAlbPrvL )->( ordsetfocus( "cStkFastIn" ) )
   local nOrdAlbPrvS          := ( ::cAlbPrvS )->( ordsetfocus( "nNumAlb"  ) )

   if ( ::cAlbPrvL )->( dbSeek( cCodArt + cCodAlm ) )

      while ( ::cAlbPrvL )->cRef == cCodArt .and. ( ::cAlbPrvL )->cAlmLin == cCodAlm .and. !( ::cAlbPrvL )->( eof() )

         if cCodigoArticulo != ( ::cAlbPrvL )->cRef + ( ::cAlbPrvL )->cAlmLin + ( ::cAlbPrvL )->cCodPr1 + ( ::cAlbPrvL )->cCodPr2 + ( ::cAlbPrvL )->cValPr1 + ( ::cAlbPrvL )->cValPr2 + ( ::cAlbPrvL )->cLote

            if ( ::lCheckConsolidacion( ( ::cAlbPrvL )->cRef, ( ::cAlbPrvL )->cAlmLin, ( ::cAlbPrvL )->cCodPr1, ( ::cAlbPrvL )->cCodPr2, ( ::cAlbPrvL )->cValPr1, ( ::cAlbPrvL )->cValPr2, ( ::cAlbPrvL )->cLote, ( ::cAlbPrvL )->dFecAlb, ( ::cAlbPrvL )->tFecAlb ) ) 

               if ::validateDateTime( ( ::cAlbPrvL )->dFecAlb, ( ::cAlbPrvL )->tFecAlb )
               
                  // Buscamos el numero de serie----------------------------------------

                  if lNumeroSerie .and. ( ::cAlbPrvS )->( dbSeek( ( ::cAlbPrvL )->cSerAlb + Str( ( ::cAlbPrvL )->nNumAlb ) + ( ::cAlbPrvL )->cSufAlb + Str( ( ::cAlbPrvL )->nNumLin ) ) )
                     
                     while ( ::cAlbPrvS )->cSerAlb + Str( ( ::cAlbPrvS )->nNumAlb ) + ( ::cAlbPrvS )->cSufAlb + Str( ( ::cAlbPrvS )->nNumLin ) == ( ::cAlbPrvL )->cSerAlb + Str( ( ::cAlbPrvL )->nNumAlb ) + ( ::cAlbPrvL )->cSufAlb + Str( ( ::cAlbPrvL )->nNumLin ) .and. !( ::cAlbPrvS )->( eof() )

                        ::InsertStockAlbaranProveedores( .t. )

                        ( ::cAlbPrvS )->( dbSkip() )

                     end while

                  else 

                     ::InsertStockAlbaranProveedores()

                  end if 

               end if

            else 

               cCodigoArticulo   := ( ::cAlbPrvL )->cRef + ( ::cAlbPrvL )->cAlmLin + ( ::cAlbPrvL )->cCodPr1 + ( ::cAlbPrvL )->cCodPr2 + ( ::cAlbPrvL )->cValPr1 + ( ::cAlbPrvL )->cValPr2 + ( ::cAlbPrvL )->cLote

            end if

         end if 

         ( ::cAlbPrvL )->( dbSkip() )

      end while

   end if

   // Albaranes con doble almacen----------------------------------------------

   cCodigoArticulo            := ""

   ( ::cAlbPrvL )->( ordsetfocus( "cStkFastOu" ) )

   if ( ::cAlbPrvL )->( dbSeek( cCodArt + cCodAlm ) )

      while ( ::cAlbPrvL )->cRef == cCodArt .and. ( ::cAlbPrvL )->cAlmOrigen == cCodAlm .and. !( ::cAlbPrvL )->( eof() )

         if cCodigoArticulo != ( ::cAlbPrvL )->cRef + ( ::cAlbPrvL )->cAlmOrigen + ( ::cAlbPrvL )->cCodPr1 + ( ::cAlbPrvL )->cCodPr2 + ( ::cAlbPrvL )->cValPr1 + ( ::cAlbPrvL )->cValPr2 + ( ::cAlbPrvL )->cLote

            if ( ::lCheckConsolidacion( ( ::cAlbPrvL )->cRef, ( ::cAlbPrvL )->cAlmOrigen, ( ::cAlbPrvL )->cCodPr1, ( ::cAlbPrvL )->cCodPr2, ( ::cAlbPrvL )->cValPr1, ( ::cAlbPrvL )->cValPr2, ( ::cAlbPrvL )->cLote, ( ::cAlbPrvL )->dFecAlb, ( ::cAlbPrvL )->tFecAlb ) ) 

               if ::validateDateTime( ( ::cAlbPrvL )->dFecAlb, ( ::cAlbPrvL )->tFecAlb )

                  // Buscamos el numero de serie----------------------------------------

                  if lNumeroSerie .and. ( ::cAlbPrvS )->( dbSeek( ( ::cAlbPrvL )->cSerAlb + Str( ( ::cAlbPrvL )->nNumAlb ) + ( ::cAlbPrvL )->cSufAlb + Str( ( ::cAlbPrvL )->nNumLin ) ) )

                     while ( ::cAlbPrvS )->cSerAlb + Str( ( ::cAlbPrvS )->nNumAlb ) + ( ::cAlbPrvS )->cSufAlb + Str( ( ::cAlbPrvS )->nNumLin ) == ( ::cAlbPrvL )->cSerAlb + Str( ( ::cAlbPrvL )->nNumAlb ) + ( ::cAlbPrvL )->cSufAlb + Str( ( ::cAlbPrvL )->nNumLin ) .and. !( ::cAlbPrvS )->( eof() )
                     
                        ::DeleteStockAlbaranProveedores( .t. )

                        ( ::cAlbPrvS )->( dbSkip() )

                     end while

                  else 

                     ::DeleteStockAlbaranProveedores()

                  end if 

               end if 

            else 

               cCodigoArticulo := ( ::cAlbPrvL )->cRef + ( ::cAlbPrvL )->cAlmOrigen + ( ::cAlbPrvL )->cCodPr1 + ( ::cAlbPrvL )->cCodPr2 + ( ::cAlbPrvL )->cValPr1 + ( ::cAlbPrvL )->cValPr2 + ( ::cAlbPrvL )->cLote

            end if 

         end if

         ( ::cAlbPrvL )->( dbSkip() )

      end while

   end if

   ( ::cAlbPrvL )->( ordsetfocus( nOrdAlbPrvL ) )
   ( ::cAlbPrvS )->( ordsetfocus( nOrdAlbPrvS ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD aStockFacturaProveedor( cCodArt, cCodAlm, lLote, lNumeroSerie )

   local cCodigoArticulo      := ""
   local nOrdFacPrvL          := ( ::cFacPrvL )->( ordsetfocus( "cStkFast" ) )
   local nOrdFacPrvS          := ( ::cFacPrvS )->( ordsetfocus( "nNumFac"  ) )

   if ( ::cFacPrvL )->( dbSeek( cCodArt + cCodAlm ) )

      while ( ::cFacPrvL )->cRef == cCodArt .and. ( ::cFacPrvL )->cAlmLin == cCodAlm .and. !( ::cFacPrvL )->( Eof() )

         if cCodigoArticulo != ( ::cFacPrvL )->cRef + ( ::cFacPrvL )->cAlmLin + ( ::cFacPrvL )->cCodPr1 + ( ::cFacPrvL )->cCodPr2 + ( ::cFacPrvL )->cValPr1 + ( ::cFacPrvL )->cValPr2 + ( ::cFacPrvL )->cLote

            if ( ::lCheckConsolidacion( ( ::cFacPrvL )->cRef, ( ::cFacPrvL )->cAlmLin, ( ::cFacPrvL )->cCodPr1, ( ::cFacPrvL )->cCodPr2, ( ::cFacPrvL )->cValPr1, ( ::cFacPrvL )->cValPr2, ( ::cFacPrvL )->cLote, ( ::cFacPrvL )->dFecFac, ( ::cFacPrvL )->tFecFac ) )

               if ::validateDateTime( ( ::cFacPrvL )->dFecFac, ( ::cFacPrvL )->tFecFac )
                  
                  // Buscamos el numero de serie----------------------------------

                  if lNumeroSerie .and. ( ::cFacPrvS )->( dbSeek( ( ::cFacPrvL )->cSerFac + Str( ( ::cFacPrvL )->nNumFac ) + ( ::cFacPrvL )->cSufFac + Str( ( ::cFacPrvL )->nNumLin ) ) )

                     while ( ::cFacPrvS )->cSerFac + Str( ( ::cFacPrvS )->nNumFac ) + ( ::cFacPrvS )->cSufFac + Str( ( ::cFacPrvS )->nNumLin ) == ( ::cFacPrvL )->cSerFac + Str( ( ::cFacPrvL )->nNumFac ) + ( ::cFacPrvL )->cSufFac + Str( ( ::cFacPrvL )->nNumLin ) .and. !( ::cFacPrvS )->( eof() )

                        ::InsertStockFacturaProveedores( .t. )

                        ( ::cFacPrvS )->( dbSkip() )

                     end while

                  else 

                     ::InsertStockFacturaProveedores()

                  end if 

               end if 

            else 

               cCodigoArticulo := ( ::cFacPrvL )->cRef + ( ::cFacPrvL )->cAlmLin + ( ::cFacPrvL )->cCodPr1 + ( ::cFacPrvL )->cCodPr2 + ( ::cFacPrvL )->cValPr1 + ( ::cFacPrvL )->cValPr2 + ( ::cFacPrvL )->cLote

            end if

         end if 

         ( ::cFacPrvL )->( dbSkip() )

      end while

   end if

   //Facturas con doble almacen

   cCodigoArticulo            := ""

   ( ::cFacPrvL )->( ordsetfocus( "cStkFastOu" ) )   

   if ( ::cFacPrvL )->( dbSeek( cCodArt + cCodAlm ) )

      while ( ::cFacPrvL )->cRef == cCodArt .and. ( ::cFacPrvL )->cAlmOrigen == cCodAlm .and. !( ::cFacPrvL )->( Eof() )

         if cCodigoArticulo != ( ::cFacPrvL )->cRef + ( ::cFacPrvL )->cAlmOrigen + ( ::cFacPrvL )->cCodPr1 + ( ::cFacPrvL )->cCodPr2 + ( ::cFacPrvL )->cValPr1 + ( ::cFacPrvL )->cValPr2 + ( ::cFacPrvL )->cLote

            if ( ::lCheckConsolidacion( ( ::cFacPrvL )->cRef, ( ::cFacPrvL )->cAlmOrigen, ( ::cFacPrvL )->cCodPr1, ( ::cFacPrvL )->cCodPr2, ( ::cFacPrvL )->cValPr1, ( ::cFacPrvL )->cValPr2, ( ::cFacPrvL )->cLote, ( ::cFacPrvL )->dFecFac, ( ::cFacPrvL )->tFecFac ) )

               if ::validateDateTime( ( ::cFacPrvL )->dFecFac, ( ::cFacPrvL )->tFecFac )
                  
                  // Buscamos el numero de serie----------------------------------

                  if lNumeroSerie .and. ( ::cFacPrvS )->( dbSeek( ( ::cFacPrvL )->cSerFac + Str( ( ::cFacPrvL )->nNumFac ) + ( ::cFacPrvL )->cSufFac + Str( ( ::cFacPrvL )->nNumLin ) ) )

                     while ( ::cFacPrvS )->cSerFac + Str( ( ::cFacPrvS )->nNumFac ) + ( ::cFacPrvS )->cSufFac + Str( ( ::cFacPrvS )->nNumLin ) == ( ::cFacPrvL )->cSerFac + Str( ( ::cFacPrvL )->nNumFac ) + ( ::cFacPrvL )->cSufFac + Str( ( ::cFacPrvL )->nNumLin ) .and. !( ::cFacPrvS )->( eof() )

                        ::DeleteStockFacturaProveedores( .t. )

                        ( ::cFacPrvS )->( dbSkip() )

                     end while

                  else 

                     ::DeleteStockFacturaProveedores()

                  end if 

               end if 

            else 

               cCodigoArticulo := ( ::cFacPrvL )->cRef + ( ::cFacPrvL )->cAlmOrigen + ( ::cFacPrvL )->cCodPr1 + ( ::cFacPrvL )->cCodPr2 + ( ::cFacPrvL )->cValPr1 + ( ::cFacPrvL )->cValPr2 + ( ::cFacPrvL )->cLote

            end if

         end if 

         ( ::cFacPrvL )->( dbSkip() )

      end while

   end if

   ( ::cFacPrvL )->( ordsetfocus( nOrdFacPrvL ) )
   ( ::cFacPrvS )->( ordsetfocus( nOrdFacPrvS ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD aStockRectificativaProveedor( cCodArt, cCodAlm, lLote, lNumeroSerie )

   local cCodigoArticulo      := ""
   local nOrdRctPrvL          := ( ::cRctPrvL )->( ordsetfocus( "cStkFast" ) )
   local nOrdRctPrvS          := ( ::cRctPrvS )->( ordsetfocus( "nNumFac"  ) )

   if ( ::cRctPrvL )->( dbSeek( cCodArt + cCodAlm ) )

      while ( ::cRctPrvL )->cRef == cCodArt  .and. ( ::cRctPrvL )->cAlmLin == cCodAlm .and. !( ::cRctPrvL )->( Eof() )

         if cCodigoArticulo != ( ::cRctPrvL )->cRef + ( ::cRctPrvL )->cAlmLin + ( ::cRctPrvL )->cCodPr1 + ( ::cRctPrvL )->cCodPr2 + ( ::cRctPrvL )->cValPr1 + ( ::cRctPrvL )->cValPr2 + ( ::cRctPrvL )->cLote

            if ::lCheckConsolidacion( ( ::cRctPrvL )->cRef, ( ::cRctPrvL )->cAlmLin, ( ::cRctPrvL )->cCodPr1, ( ::cRctPrvL )->cCodPr2, ( ::cRctPrvL )->cValPr1, ( ::cRctPrvL )->cValPr2, ( ::cRctPrvL )->cLote, ( ::cRctPrvL )->dFecFac, ( ::cRctPrvL )->tFecFac ) 

               if ::validateDateTime( ( ::cRctPrvL )->dFecFac, ( ::cRctPrvL )->tFecFac )

                  // Buscamos el numero de serie-------------------------------------

                  if lNumeroSerie .and. ( ::cRctPrvS )->( dbSeek( ( ::cRctPrvL )->cSerFac + Str( ( ::cRctPrvL )->nNumFac ) + ( ::cRctPrvL )->cSufFac + Str( ( ::cRctPrvL )->nNumLin ) ) )

                    while ( ::cRctPrvS )->cSerFac + Str( ( ::cRctPrvS )->nNumFac ) + ( ::cRctPrvS )->cSufFac + Str( ( ::cRctPrvS )->nNumLin ) == ( ::cRctPrvL )->cSerFac + Str( ( ::cRctPrvL )->nNumFac ) + ( ::cRctPrvL )->cSufFac + Str( ( ::cRctPrvL )->nNumLin ) .and. !( ::cRctPrvS )->( eof() )

                        ::InsertStockRectificativaProveedores( .t. )

                        ( ::cRctPrvS )->( dbSkip() )

                     end while

                  else 

                     ::InsertStockRectificativaProveedores()

                  end if 

               end if

            else 

               cCodigoArticulo   := ( ::cRctPrvL )->cRef + ( ::cRctPrvL )->cAlmLin + ( ::cRctPrvL )->cCodPr1 + ( ::cRctPrvL )->cCodPr2 + ( ::cRctPrvL )->cValPr1 + ( ::cRctPrvL )->cValPr2 + ( ::cRctPrvL )->cLote

            end if 

         end if 

         ( ::cRctPrvL )->( dbSkip() )

      end while

   end if

   //Rectificativas con doble almacen

   cCodigoArticulo         := ""

   ( ::cRctPrvL )->( ordsetfocus( "cStkFastOu" ) )

   if ( ::cRctPrvL )->( dbSeek( cCodArt + cCodAlm ) )

      while ( ::cRctPrvL )->cRef == cCodArt  .and. ( ::cRctPrvL )->cAlmOrigen == cCodAlm .and. !( ::cRctPrvL )->( Eof() )

         if cCodigoArticulo != ( ::cRctPrvL )->cRef + ( ::cRctPrvL )->cAlmOrigen + ( ::cRctPrvL )->cCodPr1 + ( ::cRctPrvL )->cCodPr2 + ( ::cRctPrvL )->cValPr1 + ( ::cRctPrvL )->cValPr2 + ( ::cRctPrvL )->cLote

            if ::lCheckConsolidacion( ( ::cRctPrvL )->cRef, ( ::cRctPrvL )->cAlmOrigen, ( ::cRctPrvL )->cCodPr1, ( ::cRctPrvL )->cCodPr2, ( ::cRctPrvL )->cValPr1, ( ::cRctPrvL )->cValPr2, ( ::cRctPrvL )->cLote, ( ::cRctPrvL )->dFecFac, ( ::cRctPrvL )->tFecFac ) 

               if ::validateDateTime( ( ::cRctPrvL )->dFecFac, ( ::cRctPrvL )->tFecFac )

                  // Buscamos el numero de serie-------------------------------------

                  if lNumeroSerie .and. ( ::cRctPrvS )->( dbSeek( ( ::cRctPrvL )->cSerFac + Str( ( ::cRctPrvL )->nNumFac ) + ( ::cRctPrvL )->cSufFac + Str( ( ::cRctPrvL )->nNumLin ) ) )

                    while ( ::cRctPrvS )->cSerFac + Str( ( ::cRctPrvS )->nNumFac ) + ( ::cRctPrvS )->cSufFac + Str( ( ::cRctPrvS )->nNumLin ) == ( ::cRctPrvL )->cSerFac + Str( ( ::cRctPrvL )->nNumFac ) + ( ::cRctPrvL )->cSufFac + Str( ( ::cRctPrvL )->nNumLin ) .and. !( ::cRctPrvS )->( eof() )

                        ::DeleteStockRectificativaProveedores( .t. )

                        ( ::cRctPrvS )->( dbSkip() )

                     end while

                  else 

                     ::DeleteStockRectificativaProveedores()

                  end if 

               end if

            else 

               cCodigoArticulo   := ( ::cRctPrvL )->cRef + ( ::cRctPrvL )->cAlmOrigen + ( ::cRctPrvL )->cCodPr1 + ( ::cRctPrvL )->cCodPr2 + ( ::cRctPrvL )->cValPr1 + ( ::cRctPrvL )->cValPr2 + ( ::cRctPrvL )->cLote

            end if 

         end if 

         ( ::cRctPrvL )->( dbSkip() )

      end while

   end if 

   ( ::cRctPrvL )->( ordsetfocus( nOrdRctPrvL ) )
   ( ::cRctPrvS )->( ordsetfocus( nOrdRctPrvS ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD aStockPedidoCliente( cCodArt, cCodAlm, lLote, dFecIni, dFecFin )

   local nOrdPedCliT          := ( ::cPedCliT )->( ordsetfocus( "nNumPed"  ) )
   local nOrdPedCliL          := ( ::cPedCliL )->( ordsetfocus( "cStkFast" ) )

   if ( ::cPedCliL )->( dbSeek( cCodArt + cCodAlm ) )

      while ( ::cPedCliL )->cRef == cCodArt .and. ( ::cPedCliL )->cAlmLin == cCodAlm .and.  !( ::cPedCliL )->( eof() )

         if ( ::cPedCliT )->( dbseek( ( ::cPedCliL )->cSerPed + str( ( ::cPedCliL )->nNumPed ) + ( ::cPedCliL )->cSufPed ) )

            if ( ( ::cPedCliT )->nEstado != 3 .and. !( ::cPedCliT )->lCancel ) .and.;
               ( ( empty( dFecIni ) .or. ( ::cPedCliT )->dFecPed >= dFecIni ) .and. ( empty( dFecFin ) .or. ( ::cPedCliT )->dFecPed <= dFecFin ) )  

               ::InsertStockPedidoClientes()

            end if 

         end if

         ( ::cPedCliL )->( dbSkip() )

      end while

   end if

   ( ::cPedCliL )->( ordsetfocus( nOrdPedCliL ) )
   ( ::cPedCliT )->( ordsetfocus( nOrdPedCliT ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD aStockAlbaranCliente( cCodArt, cCodAlm, lLote, lNumeroSerie )

   local cCodigoArticulo      := ""
   local nOrdAlbCliL          := ( ::cAlbCliL )->( ordsetfocus( "cStkFast" ) )
   local cSentence            := AlbaranesClientesLineasModel():getSQLAdsStockSalida( cCodArt, , , cCodAlm )

   if ( ::cAlbCliL )->( dbSeek( cCodArt + cCodAlm ) )

      while ( ::cAlbCliL )->cRef == cCodArt .and. ( ::cAlbCliL )->cAlmLin == cCodAlm .and. !( ::cAlbCliL )->( eof() )

         if cCodigoArticulo != ( ::cAlbCliL )->cRef + ( ::cAlbCliL )->cAlmLin + ( ::cAlbCliL )->cCodPr1 + ( ::cAlbCliL )->cCodPr2 + ( ::cAlbCliL )->cValPr1 + ( ::cAlbCliL )->cValPr2 + ( ::cAlbCliL )->cLote

            if ::lCheckConsolidacion( ( ::cAlbCliL )->cRef, ( ::cAlbCliL )->cAlmLin, ( ::cAlbCliL )->cCodPr1, ( ::cAlbCliL )->cCodPr2, ( ::cAlbCliL )->cValPr1, ( ::cAlbCliL )->cValPr2, ( ::cAlbCliL )->cLote, ( ::cAlbCliL )->dFecAlb, ( ::cAlbCliL )->tFecAlb ) 

               if ::validateDateTime( ( ::cAlbCliL )->dFecAlb, ( ::cAlbCliL )->tFecAlb )

                  ::InsertStockAlbaranClientes()

               end if 

            else 

               cCodigoArticulo   := ( ::cAlbCliL )->cRef + ( ::cAlbCliL )->cAlmLin + ( ::cAlbCliL )->cCodPr1 + ( ::cAlbCliL )->cCodPr2 + ( ::cAlbCliL )->cValPr1 + ( ::cAlbCliL )->cValPr2 + ( ::cAlbCliL )->cLote

            end if

         end if

         ( ::cAlbCliL )->( dbSkip() )

      end while

   end if

   ( ::cAlbCliL )->( ordsetfocus( nOrdAlbCliL ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD aStockFacturaCliente( cCodArt, cCodAlm, lLote, lNumeroSerie )

   local cCodigoArticulo      := ""
   local nOrdFacCliL          := ( ::cFacCliL )->( ordsetfocus( "cStkFast" ) )
   local nOrdFacCliS          := ( ::cFacCliS )->( ordsetfocus( "nNumFac"  ) )

   if ( ::cFacCliL )->( dbSeek( cCodArt + cCodAlm ) )

      while ( ::cFacCliL )->cRef == cCodArt .and. ( ::cFacCliL )->cAlmLin == cCodAlm .and. !( ::cFacCliL )->( Eof() )

         if cCodigoArticulo != ( ::cFacCliL )->cRef + ( ::cFacCliL )->cAlmLin + ( ::cFacCliL )->cCodPr1 + ( ::cFacCliL )->cCodPr2 + ( ::cFacCliL )->cValPr1 + ( ::cFacCliL )->cValPr2 + ( ::cFacCliL )->cLote

            if ::lCheckConsolidacion( ( ::cFacCliL )->cRef, ( ::cFacCliL )->cAlmLin, ( ::cFacCliL )->cCodPr1, ( ::cFacCliL )->cCodPr2, ( ::cFacCliL )->cValPr1, ( ::cFacCliL )->cValPr2, ( ::cFacCliL )->cLote, ( ::cFacCliL )->dFecFac, ( ::cFacCliL )->tFecFac ) 
         
               if ::validateDateTime( ( ::cFacCliL )->dFecFac, ( ::cFacCliL )->tFecFac )

                  if lNumeroSerie .and. ( ::cFacCliS )->( dbSeek( ( ::cFacCliL )->cSerie + Str( ( ::cFacCliL )->nNumFac ) + ( ::cFacCliL )->cSufFac + Str( ( ::cFacCliL )->nNumLin ) ) )

                     while ( ::cFacCliS )->cSerFac + Str( ( ::cFacCliS )->nNumFac ) + ( ::cFacCliS )->cSufFac + Str( ( ::cFacCliS )->nNumLin ) == ( ::cFacCliL )->cSerie + Str( ( ::cFacCliL )->nNumFac ) + ( ::cFacCliL )->cSufFac + Str( ( ::cFacCliL )->nNumLin ) .and. !( ::cFacCliS )->( eof() )

                        ::InsertStockFacturaClientes( .t. )

                        ( ::cFacCliS )->( dbSkip() )

                     end while

                  else 

                     ::InsertStockFacturaClientes()

                  end if

               end if 

            else  

               cCodigoArticulo   := ( ::cFacCliL )->cRef + ( ::cFacCliL )->cAlmLin + ( ::cFacCliL )->cCodPr1 + ( ::cFacCliL )->cCodPr2 + ( ::cFacCliL )->cValPr1 + ( ::cFacCliL )->cValPr2 + ( ::cFacCliL )->cLote

            end if

         end if

         ( ::cFacCliL )->( dbSkip() )

      end while

   end if

   ( ::cFacCliL )->( ordsetfocus( nOrdFacCliL ) )
   ( ::cFacCliS )->( ordsetfocus( nOrdFacCliS ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD aStockRectificativaCliente( cCodArt, cCodAlm, lLote, lNumeroSerie )

   local cCodigoArticulo      := ""
   local nOrdFacRecL          := ( ::cFacRecL )->( ordsetfocus( "cStkFast" ) )
   local nOrdFacRecS          := ( ::cFacRecS )->( ordsetfocus( "nNumFac"  ) )

   if ( ::cFacRecL )->( dbSeek( cCodArt + cCodAlm ) )

      while ( ::cFacRecL )->cRef == cCodArt .and. ( ::cFacRecL )->cAlmLin == cCodAlm .and. !( ::cFacRecL )->( Eof() )

         if cCodigoArticulo != ( ::cFacRecL )->cRef + ( ::cFacRecL )->cAlmLin + ( ::cFacRecL )->cCodPr1 + ( ::cFacRecL )->cCodPr2 + ( ::cFacRecL )->cValPr1 + ( ::cFacRecL )->cValPr2 + ( ::cFacRecL )->cLote

            if ::lCheckConsolidacion( ( ::cFacRecL )->cRef, ( ::cFacRecL )->cAlmLin, ( ::cFacRecL )->cCodPr1, ( ::cFacRecL )->cCodPr2, ( ::cFacRecL )->cValPr1, ( ::cFacRecL )->cValPr2, ( ::cFacRecL )->cLote, ( ::cFacRecL )->dFecFac, ( ::cFacRecL )->tFecFac )

               if ::validateDateTime( ( ::cFacRecL )->dFecFac, ( ::cFacRecL )->tFecFac )

                  if lNumeroSerie .and. ( ::cFacRecS )->( dbSeek( ( ::cFacRecL )->cSerie + Str( ( ::cFacRecL )->nNumFac ) + ( ::cFacRecL )->cSufFac + Str( ( ::cFacRecL )->nNumLin ) ) )

                     while ( ::cFacRecS )->cSerFac + Str( ( ::cFacRecS )->nNumFac ) + ( ::cFacRecS )->cSufFac + Str( ( ::cFacRecS )->nNumLin ) == ( ::cFacRecL )->cSerie + Str( ( ::cFacRecL )->nNumFac ) + ( ::cFacRecL )->cSufFac + Str( ( ::cFacRecL )->nNumLin ) .and. !( ::cFacRecS )->( eof() )

                        ::InsertStockRectificativaClientes( .t. )

                        ( ::cFacRecS )->( dbSkip() )

                     end while

                  else 

                     ::InsertStockRectificativaClientes()

                  end if 

               end if 

            else 

               cCodigoArticulo   := ( ::cFacRecL )->cRef + ( ::cFacRecL )->cAlmLin + ( ::cFacRecL )->cCodPr1 + ( ::cFacRecL )->cCodPr2 + ( ::cFacRecL )->cValPr1 + ( ::cFacRecL )->cValPr2 + ( ::cFacRecL )->cLote

            end if

         end if  

         ( ::cFacRecL )->( dbSkip() )

      end while

   end if

   ( ::cFacRecL )->( ordsetfocus( nOrdFacRecL ) )
   ( ::cFacRecS )->( ordsetfocus( nOrdFacRecS ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD aStockTicketsCliente( cCodArt, cCodAlm, lLote, lNumeroSerie )

   local cCodigoArticulo   := ""
   local nOrdTikL          := ( ::cTikL )->( ordsetfocus( "cStkFast" ) )
   local nOrdTikS          := ( ::cTikS )->( ordsetfocus( "nNumTik" ) )

   if ( ::cTikL )->( dbSeek( cCodArt + cCodAlm ) )

      while ( ::cTikL )->cCbaTil == cCodArt .and. ( ::cTikL )->cAlmLin == cCodAlm .and. !( ::cTikL )->( Eof() )

         if cCodigoArticulo != ( ::cTikL )->cCbaTil + ( ::cTikL )->cAlmLin + ( ::cTikL )->cCodPr1 + ( ::cTikL )->cCodPr2 + ( ::cTikL )->cValPr1 + ( ::cTikL )->cValPr2 + ( ::cTikL )->cLote

            if ::lCheckConsolidacion( ( ::cTikL )->cCbaTil, ( ::cTikL )->cAlmLin, ( ::cTikL )->cCodPr1, ( ::cTikL )->cCodPr2, ( ::cTikL )->cValPr1, ( ::cTikL )->cValPr2, ( ::cTikL )->cLote, ( ::cTikL )->dFecTik, ( ::cTikL )->tFecTik ) 

               if ::validateDateTime( ( ::cTikL )->dFecTik, ( ::cTikL )->tFecTik )

                  if lNumeroSerie .and. ( ::cTikS )->( dbSeek( ( ::cTikL )->cSerTil + ( ::cTikL )->cNumTil + ( ::cTikL )->cSufTil + Str( ( ::cTikl )->nNumLin ) ) )

                     while ( ::cTikS )->cSerTiK + ( ::cTiks )->cNumTik + ( ::cTikS )->CSUFTIK + Str( ( ::cTikS )->nNumLin ) == ( ::cTikl )->cSerTil + ( ::cTikL )->cNumTil + ( ::cTikL )->cSufTil + Str( ( ::cTikL )->nNumLin ) .and. !( ::cTikS )->( eof() )

                        ::InsertStockTiketsClientes( .t. )

                        ( ::cTikS )->( dbSkip() )

                     end while

                  else 

                     ::InsertStockTiketsClientes()

                  end if 

               end if 

            else

               cCodigoArticulo := ( ::cTikL )->cCbaTil + ( ::cTikL )->cAlmLin + ( ::cTikL )->cCodPr1 + ( ::cTikL )->cCodPr2 + ( ::cTikL )->cValPr1 + ( ::cTikL )->cValPr2 + ( ::cTikL )->cLote

            end if

         end if 

         ( ::cTikL )->( dbSkip() )

      end while

   end if

   // Tickets de clientes combinados----------------------------------------------

   cCodigoArticulo   := ""

   ( ::cTikL )->( ordsetfocus( "cStkComb" ) )

   if ( ::cTikL )->( dbSeek( cCodArt + cCodAlm ) )

      while ( ::cTikL )->cComTil == cCodArt .and. ( ::cTikL )->cAlmLin == cCodAlm .and. !( ::cTikL )->( eof() )

         if cCodigoArticulo != ( ::cTikL )->cCbaTil + ( ::cTikL )->cAlmLin + ( ::cTikL )->cCodPr1 + ( ::cTikL )->cCodPr2 + ( ::cTikL )->cValPr1 + ( ::cTikL )->cValPr2 + ( ::cTikL )->cLote

            if ::lCheckConsolidacion( ( ::cTikL )->cComTil, ( ::cTikL )->cAlmLin, ( ::cTikL )->cCodPr1, ( ::cTikL )->cCodPr2, ( ::cTikL )->cValPr1, ( ::cTikL )->cValPr2, ( ::cTikL )->cLote, ( ::cTikL )->dFecTik, ( ::cTikL )->tFecTik ) 

               if ::validateDateTime( ( ::cTikL )->dFecTik, ( ::cTikL )->tFecTik )

                  ::InsertStockTiketsClientes( .f. , .t. )

               end if 

            else 

               cCodigoArticulo := ( ::cTikL )->cCbaTil + ( ::cTikL )->cAlmLin + ( ::cTikL )->cCodPr1 + ( ::cTikL )->cCodPr2 + ( ::cTikL )->cValPr1 + ( ::cTikL )->cValPr2 + ( ::cTikL )->cLote

            end if 

         end if 

         ( ::cTikL )->( dbSkip() )

      end while

   end if

   ( ::cTikL )->( ordsetfocus( nOrdTikL ) )
   ( ::cTikS )->( ordsetfocus( nOrdTikS ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD aStockProduccion( cCodArt, cCodAlm, lLote, lNumeroSerie )

   local cCodigoArticulo   := ""
   local nOrdProL          := ( ::cProducL )->( ordsetfocus( "cStkFast" ) )
   local nOrdProS          := ( ::cProducS )->( ordsetfocus( "cNumOrd" ) )

   if ( ::cProducL )->( dbSeek( cCodArt + cCodAlm ) )

      while ( ::cProducL )->cCodArt == cCodArt .and. ( ::cProducL )->cAlmOrd == cCodAlm .and. !( ::cProducL )->( Eof() )

         if cCodigoArticulo != ( ::cProducL )->cCodArt + ( ::cProducL )->cAlmOrd + ( ::cProducL )->cCodPr1 + ( ::cProducL )->cCodPr2 + ( ::cProducL )->cValPr1 + ( ::cProducL )->cValPr2 + ( ::cProducL )->cLote

            if ::lCheckConsolidacion( ( ::cProducL )->cCodArt, ( ::cProducL )->cAlmOrd, ( ::cProducL )->cCodPr1, ( ::cProducL )->cCodPr2, ( ::cProducL )->cValPr1, ( ::cProducL )->cValPr2, ( ::cProducL )->cLote, ( ::cProducL )->dFecOrd, ( ::cProducL )->cHorIni )

               if ::validateDateTime( ( ::cProducL )->dFecOrd, ( ::cProducL )->cHorIni )

                  if lNumeroSerie .and. ( ::cProducS )->( dbSeek( ( ::cProducL )->cSerOrd + Str( ( ::cProducL )->nNumOrd ) + ( ::cProducL )->cSufOrd + Str( ( ::cProducL )->nNumLin ) ) )

                     while ( ::cProducS )->cSerOrd + Str( ( ::cProducS )->nNumOrd ) + ( ::cProducS )->cSufOrd + Str( ( ::cProducS )->nNumLin ) == ( ::cProducL )->cSerOrd + Str( ( ::cProducL )->nNumOrd ) + ( ::cProducL )->cSufOrd + Str( ( ::cProducL )->nNumLin ) .and. !( ::cProducS )->( eof() )

                        ::InsertStockMaterialesProducidos( .t. )

                        ( ::cProducS )->( dbSkip() )

                     end while

                  else 

                     ::InsertStockMaterialesProducidos()

                  end if

               end if 

            else 

               cCodigoArticulo   := ( ::cProducL )->cCodArt + ( ::cProducL )->cAlmOrd + ( ::cProducL )->cCodPr1 + ( ::cProducL )->cCodPr2 + ( ::cProducL )->cValPr1 + ( ::cProducL )->cValPr2 + ( ::cProducL )->cLote

            end if  

         end if 

         ( ::cProducL )->( dbSkip() )

      end while

   end if

   ( ::cProducL )->( ordsetfocus( nOrdProL ) )
   ( ::cProducS )->( ordsetfocus( nOrdProS ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD aStockMateriaPrima( cCodArt, cCodAlm, lLote, lNumeroSerie )

   local cCodigoArticulo   := ""
   local nOrdProM          := ( ::cProducM )->( ordsetfocus( "cStkFast" ) )
   local nOrdProP          := ( ::cProducP )->( ordsetfocus( "cNumOrd" ) )

   if ( ::cProducM )->( dbSeek( cCodArt + cCodAlm ) )

      while ( ::cProducM )->cCodArt == cCodArt .and. ( ::cProducM )->cAlmOrd == cCodAlm .and. !( ::cProducM )->( eof() )

         if cCodigoArticulo != ( ::cProducM )->cCodArt + ( ::cProducM )->cAlmOrd + ( ::cProducM )->cCodPr1 + ( ::cProducM )->cCodPr2 + ( ::cProducM )->cValPr1 + ( ::cProducM )->cValPr2 + ( ::cProducM )->cLote

            if ::lCheckConsolidacion( ( ::cProducM )->cCodArt, ( ::cProducM )->cAlmOrd, ( ::cProducM )->cCodPr1, ( ::cProducM )->cCodPr2, ( ::cProducM )->cValPr1, ( ::cProducM )->cValPr2, ( ::cProducM )->cLote, ( ::cProducM )->dFecOrd, ( ::cProducM )->cHorIni ) 

               if ::validateDateTime( ( ::cProducM )->dFecOrd, ( ::cProducM )->cHorIni )

                  if lNumeroSerie .and. ( ::cProducP )->( dbSeek( ( ::cProducM )->cSerOrd + Str( ( ::cProducM )->nNumOrd ) + ( ::cProducM )->cSufOrd + Str( ( ::cProducM )->nNumLin ) ) )

                     while ( ::cProducP )->cSerOrd + Str( ( ::cProducP )->nNumOrd ) + ( ::cProducP )->cSufOrd + Str( ( ::cProducP )->nNumLin ) == ( ::cProducM )->cSerOrd + Str( ( ::cProducM )->nNumOrd ) + ( ::cProducM )->cSufOrd + Str( ( ::cProducM )->nNumLin ) .and. !( ::cProducP )->( eof() )

                        ::InsertStockMateriasPrimas( .t. )

                        ( ::cProducP )->( dbSkip() )

                     end while

                  else 
                     
                     ::InsertStockMateriasPrimas()

                  end if 

               end if 

            else 

               cCodigoArticulo   := ( ::cProducM )->cCodArt + ( ::cProducM )->cAlmOrd + ( ::cProducM )->cCodPr1 + ( ::cProducM )->cCodPr2 + ( ::cProducM )->cValPr1 + ( ::cProducM )->cValPr2 + ( ::cProducM )->cLote

            end if  

         end if

         ( ::cProducM )->( dbSkip() )

      end while

   end if

   ( ::cProducM )->( ordsetfocus( nOrdProM ) )  
   ( ::cProducP )->( ordsetfocus( nOrdProP ) ) 

RETURN ( nil )

//---------------------------------------------------------------------------//
//
// Pendientes de recibir-------------------------------------------------------
//

METHOD aStockPendiente( cCodArt, cCodAlm, lLote, lNumeroSerie )

   local nTotal            := 0
   local nTotalRecibido    := 0
   local nOrdPedPrvL       := ( ::cPedPrvL )->( ordsetfocus( "cStkFast" ) )
   local nOrdAlbPrvL       := ( ::cAlbPrvL )->( ordsetfocus( "cPedRef" ) )

   if ( ::cPedPrvL )->( dbSeek( cCodArt + cCodAlm ) )

      while ( ::cPedPrvL )->cRef == cCodArt .and. ( ::cPedPrvL )->cAlmLin == cCodAlm .and. !( ::cPedPrvL )->( eof() )

         nTotal            := nTotNPedPrv( ::cPedPrvL )
                  
         // Quitamos a las unidades lo ya albaranado---------------------------

         if ( ::cAlbPrvL )->( dbSeek( ( ::cPedPrvL )->cSerPed + Str( ( ::cPedPrvL )->nNumPed ) + ( ::cPedPrvL )->cSufPed + cCodArt ) )

            while ( ::cPedPrvL )->cSerPed + Str( ( ::cPedPrvL )->nNumPed ) + ( ::cPedPrvL )->cSufPed + cCodArt == ( ::cAlbPrvL )->cCodPed + ( ::cAlbPrvL )->cRef .and. !( ::cAlbPrvL )->( eof() )

               if ( ::cAlbPrvL )->cAlmLin == cCodAlm
                  nTotal            -= nTotNAlbPrv( ::cAlbPrvL )
                  nTotalRecibido    += nTotNAlbPrv( ::cAlbPrvL )
               end if 

               ( ::cAlbPrvL )->( dbSkip() )

            end while

         end if

         // realizamos el apunte en stock-------------------------------------

         ::InsertStockPendiente( nTotal, lLote, lNumeroSerie, nTotalRecibido )

         ( ::cPedPrvL )->( dbSkip() )

      end while

   end if

   ( ::cPedPrvL )->( ordsetfocus( nOrdPedPrvL ) )
   ( ::cAlbPrvL )->( ordsetfocus( nOrdAlbPrvL ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD InsertStockPendiente( nTotal, lLote, lNumeroSerie, nTotalRecibido )

   with object ( SStock():New() )

      :cTipoDocumento            := PED_PRV
      :cCodigo                   := ( ::cPedPrvL )->cRef
      :cNumeroDocumento          := ( ::cPedPrvL )->cSerPed + "/" + alltrim( Str( ( ::cPedPrvL )->nNumPed ) )
      :cDelegacion               := ( ::cPedPrvL )->cSufPed
      :dFechaDocumento           := dFecPedPrv( ( ::cPedPrvL )->cSerPed + Str( ( ::cPedPrvL )->nNumPed ) + ( ::cPedPrvL )->cSufPed, ::cPedPrvT )
      :tFechaDocumento           := ""
      :cCodigoAlmacen            := ( ::cPedPrvL )->cAlmLin
      :cCodigoPropiedad1         := ( ::cPedPrvL )->cCodPr1
      :cCodigoPropiedad2         := ( ::cPedPrvL )->cCodPr2
      :cValorPropiedad1          := ( ::cPedPrvL )->cValPr1
      :cValorPropiedad2          := ( ::cPedPrvL )->cValPr2
      :cLote                     := ( ::cPedPrvL )->cLote
      :nPendientesRecibir        := if( nTotal > 0, nTotal, 0 )
      :nUnidadesRecibidas        := nTotalRecibido

      ::Integra( hb_QWith(), lLote, lNumeroSerie )

   end with

RETURN ( nil )

//---------------------------------------------------------------------------//

Static Function SeekOnStock( cSeek, oBrw )

   local nAt

   nAt               := aScan( oBrw:aArrayData, {|o| alltrim( Upper( cValToChar( o:cNumeroSerie ) ) ) == alltrim( Upper( cSeek ) ) } )
   if nAt > 0
      oBrw:nArrayAt  := nAt
   endif

   oBrw:Refresh()

RETURN ( .t. )

//---------------------------------------------------------------------------//

Static Function InsertOnStock( oCol, oBrw, oDlg, oBrwSer )

   if ( oBrwSer:nArrayAt == Len( oBrwSer:aArrayData ) )

      oDlg:End( IDOK )

   else


      Eval( oCol:bOnPostEdit, oCol, oBrw:aArrayData[ oBrw:nArrayAt ]:cNumeroSerie )

      oBrwSer:GoDown()

      oBrw:aArrayData[ oBrw:nArrayAt ]:nUnidades--

      if ( oBrw:aArrayData[ oBrw:nArrayAt ]:nUnidades == 0 )

         aDel( oBrw:aArrayData, oBrw:nArrayAt, .t. )

         oBrw:Refresh()

      end if

   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS STemporal

   DATA dFecMov
   DATA cTimMov
   DATA nTotEnt
   DATA nTotSal
   DATA nImpEnt
   DATA cTipo
   DATA cNumero

   METHOD New( dFecMov, cTimMov, nTotEnt, nTotSal, nImpEnt, cTipo, cNumero )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( dFecMov, cTimMov, nTotEnt, nTotSal, nImpEnt, cTipo, cNumero ) CLASS STemporal

   DEFAULT cTipo     := ""
   DEFAULT cNumero   := ""

   ::dFecMov         := dFecMov
   ::cTimMov         := cTimMov
   ::nTotEnt         := Abs( nTotEnt )
   ::nTotSal         := Abs( nTotSal )
   ::nImpEnt         := Abs( nImpEnt )
   ::cTipo           := cTipo
   ::cNumero         := cNumero

RETURN ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SStock

   DATA cAlias                INIT ""
   DATA cCodigo               INIT ""
   DATA cDelegacion           INIT ""
   DATA dFechaDocumento       INIT Ctod( "" )
   DATA tFechaDocumento       INIT ""
   DATA dConsolidacion        INIT Ctod( "" )
   DATA cCodigoAlmacen        INIT ""
   DATA cCodigoPropiedad1     INIT ""
   DATA cCodigoPropiedad2     INIT ""
   DATA cValorPropiedad1      INIT ""
   DATA cValorPropiedad2      INIT ""
   DATA cLote                 INIT ""
   DATA dFechaCaducidad       INIT Ctod( "" )
   DATA cNumeroSerie          INIT ""
   DATA nUnidades             INIT 0
   DATA nPendientesRecibir    INIT 0
   DATA nPendientesEntregar   INIT 0
   DATA cNumeroDocumento      INIT ""
   DATA cTipoDocumento        INIT ""
   DATA nBultos               INIT 0
   DATA nCajas                INIT 0
   DATA nUnidadesEntregadas   INIT 0
   DATA nUnidadesRecibidas    INIT 0

   //------------------------------------------------------------------------//
   
   METHOD New()

   METHOD Documento()         INLINE ( cTextDocument( ::cTipoDocumento ) + space(1) + ;
                                       alltrim( ::cNumeroDocumento ) + space(1) + ;
                                       "de fecha " + dtoc( ::dFechaDocumento ) + ;
                                       if( empty(::tFechaDocumento), "", " a las " + trans( ::tFechaDocumento, "@R 99:99:99" ) ) )

   METHOD Say()

   METHOD Save( oDbfStock )

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS SStock

   ::cCodigo               := ""
   ::cDelegacion           := ""
   ::dFechaDocumento       := Ctod("")
   ::cCodigoAlmacen        := ""
   ::cCodigoPropiedad1     := ""
   ::cCodigoPropiedad2     := ""
   ::cValorPropiedad1      := ""
   ::cValorPropiedad2      := ""
   ::cLote                 := ""
   ::cNumeroSerie          := ""
   ::dFechaCaducidad       := Ctod( "" )
   ::nUnidades             := 0
   ::nPendientesRecibir    := 0
   ::nPendientesEntregar   := 0
   ::cNumeroDocumento      := ""
   ::cTipoDocumento        := ""
   ::nBultos               := 0
   ::nCajas                := 0
   ::nUnidadesEntregadas   := 0
   ::nUnidadesRecibidas    := 0

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD Say() CLASS SStock

   RETURN ( "Alias"                    + ::cAlias                                + "," + ;
            "Codigo"                   + ::cCodigo                               + "," + ;
            "CodigoAlmacen"            + ::cCodigoAlmacen                        + "," + ;
            "CodigoPropiedad1"         + ::cCodigoPropiedad1                     + "," + ;
            "CodigoPropiedad2"         + ::cCodigoPropiedad2                     + "," + ;
            "ValorPropiedad1"          + ::cValorPropiedad1                      + "," + ;
            "ValorPropiedad2"          + ::cValorPropiedad2                      + "," + ;
            "Lote"                     + ::cLote                                 + "," + ;
            "NumeroSerie"              + ::cNumeroSerie                          + "," + ;
            "Unidades"                 + Str( ::nUnidades )                      + "," + ;
            "PendientesRecibir"        + Str( ::nPendientesRecibir )             + "," + ;
            "PendientesEntregar"       + Str( ::nPendientesEntregar )            + "," + ;
            "Unidades != 0"            + cValToChar( ::nUnidades != 0 )          + "," + ;
            "PendientesRecibir != 0"   + cValToChar( ::nPendientesRecibir != 0 ) + "," + ;
            "PendientesEntregar != 0"  + cValToChar( ::nPendientesEntregar != 0 ) )

//------------------------------------------------------------------------//

METHOD Save( oDbfStock ) CLASS SStock

   oDbfStock:Append()

   oDbfStock:cCodigo    := ::cCodigo               
   oDbfStock:cDelega    := ::cDelegacion           
   oDbfStock:dFecDoc    := ::dFechaDocumento       
   oDbfStock:cAlmacen   := ::cCodigoAlmacen        
   oDbfStock:cCodPrp1   := ::cCodigoPropiedad1     
   oDbfStock:cCodPrp2   := ::cCodigoPropiedad2     
   oDbfStock:cValPrp1   := ::cValorPropiedad1      
   oDbfStock:cValPrp2   := ::cValorPropiedad2      
   oDbfStock:cLote      := ::cLote                 
   oDbfStock:cNumSer    := ::cNumeroSerie          
   oDbfStock:dFecCad    := ::dFechaCaducidad       
   oDbfStock:nUnd       := ::nUnidades             
   oDbfStock:nPdtRec    := ::nPendientesRecibir    
   oDbfStock:nPdtEnt    := ::nPendientesEntregar   
   oDbfStock:nEntreg    := ::nUnidadesEntregadas   
   oDbfStock:nRecibi    := ::nUnidadesRecibidas
   oDbfStock:cNumDoc    := ::cNumeroDocumento      
   oDbfStock:cTipDoc    := ::cTipoDocumento        

   oDbfStock:Save()

RETURN (  Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//


CLASS TSqlStock

   DATA nView
   
   DATA nStock

   DATA consolidationDate
   DATA consolidationTime
   DATA consolidationCajas
   DATA consolidationUnidades

   METHOD new()

   METHOD calculateStock()

   METHOD consolidationDateTime()

END CLASS

//---------------------------------------------------------------------------//

METHOD new( nView ) CLASS TSqlStock

   ::nView              := nView
   ::consolidationDate  := cTod( "" )
   ::consolidationTime  := ""

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD calculateStock( cCodArt ) CLASS TSqlStock

   ::consolidationDateTime( cCodArt )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD consolidationDateTime( cCodArt ) CLASS TSqlStock

   local cSentencia  := ""
   local aPruebas

   cSentencia        += "SELECT lineasMov.cRefMov, "
   cSentencia        +=        "lineasMov.dFecMov, "
   cSentencia        +=        "lineasMov.cTimMov, "
   cSentencia        +=        "lineasMov.nCajMov, "
   cSentencia        +=        "lineasMov.nUndMov "
   cSentencia        += "FROM " + cPatEmp() + "HisMov lineasMov "
   cSentencia        += "JOIN ( SELECT cRefMov, MAX( dFecMov ) AS dFecMov, MAX( cTimMov ) AS cTimMov FROM " + cPatEmp() + "HisMov GROUP BY cRefMov WHERE cTipMov='4' ) AS lineasMovFecha "
   cSentencia        += "ON lineasMovFecha.cRefMov = lineasMov.cRefMov AND lineasMovFecha.dFecMov >= lineasMov.dFecMov AND lineasMovFecha.cTimMov >= lineasMov.cTimMov "
   cSentencia        += "WHERE lineasMov.cRefMov='" + cCodArt + "' "

   if TDataCenter():ExecuteSqlStatement( cSentencia, "resultado" )
      
      resultado->( dbGoTop() )

      aPruebas       :=  dbScatter( "resultado" )
         
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD CreateTemporalFiles( cPath ) CLASS TStock

   local cFile 
   local aStock

   DEFAULT cPath        := cPatTmp()

   cFile                := "Stock" + strtran( alltrim( str( seconds() ) ), ".", "" )

   ::cDbfStock          := cFile + ".dbf"
   ::cCdxStock          := cFile + ".cdx"

   ::DeleteTemporalFiles( cPath )

   DEFINE DATABASE ::oDbfStock FILE ( ::cDbfStock ) CLASS "StockDbf" ALIAS "StockDbf" PATH ( cPath ) VIA ( cLocalDriver() ) 

   FIELD NAME "cCodigo"    TYPE "C" LEN 18 DEC 0 COMMENT "Código de artículo"                    OF ::oDbfStock
   FIELD NAME "cDelega"    TYPE "C" LEN  3 DEC 0 COMMENT "Delegación"                            OF ::oDbfStock
   FIELD NAME "dFecDoc"    TYPE "D" LEN  8 DEC 0 COMMENT "Fecha del documento"                   OF ::oDbfStock
   FIELD NAME "cAlmacen"   TYPE "C" LEN 16 DEC 0 COMMENT "Código del almacen"                    OF ::oDbfStock
   FIELD NAME "cCodPrp1"   TYPE "C" LEN 20 DEC 0 COMMENT "Código de la primera propiedad"        OF ::oDbfStock
   FIELD NAME "cCodPrp2"   TYPE "C" LEN 20 DEC 0 COMMENT "Código de la segunda propiedad"        OF ::oDbfStock
   FIELD NAME "cValPrp1"   TYPE "C" LEN 20 DEC 0 COMMENT "Valor de la primera propiedad"         OF ::oDbfStock 
   FIELD NAME "cValPrp2"   TYPE "C" LEN 20 DEC 0 COMMENT "Valor de la segunda propiedad"         OF ::oDbfStock
   FIELD NAME "cLote"      TYPE "C" LEN 14 DEC 0 COMMENT "Número de lote"                        OF ::oDbfStock
   FIELD NAME "cNumSer"    TYPE "C" LEN 30 DEC 0 COMMENT "Número de serie"                       OF ::oDbfStock
   FIELD NAME "dFecCad"    TYPE "D" LEN  8 DEC 0 COMMENT "Fecha de caducidad"                    OF ::oDbfStock
   FIELD NAME "nUnd"       TYPE "N" LEN 16 DEC 6 COMMENT "Total unidades"                        OF ::oDbfStock
   FIELD NAME "nPdtRec"    TYPE "N" LEN 16 DEC 6 COMMENT "Total unidades pendientes de recibir"  OF ::oDbfStock
   FIELD NAME "nPdtEnt"    TYPE "N" LEN 16 DEC 6 COMMENT "Total unidades pendientes de entregar" OF ::oDbfStock
   FIELD NAME "nEntreg"    TYPE "N" LEN 16 DEC 6 COMMENT "Total unidades entregadas"             OF ::oDbfStock
   FIELD NAME "nRecibi"    TYPE "N" LEN 16 DEC 6 COMMENT "Total unidades recibidas"              OF ::oDbfStock
   FIELD NAME "cNumDoc"    TYPE "C" LEN 13 DEC 0 COMMENT "Número del documento lote"             OF ::oDbfStock
   FIELD NAME "cTipDoc"    TYPE "C" LEN 12 DEC 0 COMMENT "Tipo del documento"                    OF ::oDbfStock

   INDEX TO ( ::cCdxStock ) TAG "cCodArt"  ON "cCodigo + cAlmacen + cValPrp1 + cValPrp2 + cLote"  COMMENT "Código"           FOR "!Deleted()" OF ::oDbfStock
   INDEX TO ( ::cCdxStock ) TAG "cCodAlm"  ON "cAlmacen + cCodigo + cValPrp1 + cValPrp2 + cLote"  COMMENT "Almacen"          FOR "!Deleted()" OF ::oDbfStock
   INDEX TO ( ::cCdxStock ) TAG "dFecCad"  ON "Dtos( dFecCad ) + cLote"                           COMMENT "Fecha caducidad"  FOR "!Deleted()" OF ::oDbfStock

   END DATABASE ::oDbfStock

   ::oDbfStock:Activate( .f., .f. )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD DeleteTemporalFiles( cPath ) CLASS TStock

   DEFAULT cPath        := cPatTmp()

   if !Empty( ::oDbfStock ) .and. ::oDbfStock:Used()
      ::oDbfStock:Close()
   end if      

   dbfErase( ::cDbfStock )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Zap() CLASS TStock

   if ( ::oDbf )->( Used() )

      if !( ::oDbf )->( isShared() )
         ( ::oDbf )->( __dbZap() )
      else

         ( ::oDbf )->( dbGoTop() )
         while !( ::oDbf )->( eof() )

            if dbLock( ::oDbf )
               ( ::oDbf )->( dbDelete() )
               ( ::oDbf )->( dbUnLock() )
            end if

            ( ::oDbf )->( dbSkip( 0 ) )

         end while

      end if

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD validateDateTime( dFecMov, tTimMov ) CLASS TStock

   if !empty( ::dFechaInicio ) .and. dFecMov < ::dFechaInicio
      RETURN .f.
   end if 

   if !empty( ::dFechaInicio ) .and. !empty( ::tHoraInicio ) .and. dtos( dFecMov ) + tTimMov < dtos( ::dFechaInicio ) + ::tHoraInicio
      RETURN .f.
   end if 

   if !empty( ::dFechaFin ) .and. dFecMov > ::dFechaFin
      RETURN .f.
   end if 

   if !empty( ::dFechaFin ) .and. !empty( ::tHoraFin ) .and. dtos( dFecMov ) + tTimMov > dtos( ::dFechaFin ) + ::tHoraFin
      RETURN .f.
   end if 

RETURN .t.

//---------------------------------------------------------------------------//

METHOD getFechaHoraConsolidacion( dFechaMovimiento, cHoraMovimiento ) CLASS TStock

   if !empty( ::dFechaFin ) .and. dFechaMovimiento > ::dFechaFin
      RETURN ( nil )
   end if 

   if !empty( ::dFechaFin ) .and. !empty( ::tHoraFin ) .and. dtos( dFechaMovimiento ) + cHoraMovimiento > dtos( ::dFechaFin ) + ::tHoraFin
      RETURN ( nil )
   end if 

RETURN ( dtos( dFechaMovimiento ) + cHoraMovimiento )

//---------------------------------------------------------------------------//

METHOD nRiesgo( idCliente ) CLASS TStock

RETURN ( ClientesModel():Riesgo( idCliente ) )

//---------------------------------------------------------------------------//
