#include "FiveWin.Ch"
#include "Factu.ch"
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TStock

   DATA cPath

   DATA lExclusive

   DATA cAlm
   DATA cArticulo

   DATA cSatCliT
   DATA cSatCliL

   DATA cPedCliT
   DATA cPedCliL
   DATA cPedCliR

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

   DATA cHisMovT
   DATA cHisMovS

   DATA tmpAlbCliL
   DATA tmpAlbCliS
   DATA tmpFacCliL
   DATA tmpFacCliS
   DATA tmpFacRecL
   DATA tmpFacRecS

   DATA aSeries            AS ARRAY INIT {}

   DATA aMovAlm            AS ARRAY INIT {}
   DATA aStocks            AS ARRAY INIT {}

   DATA dConsolidacion

   DATA lAlbPrv            AS LOGIC INIT .t.
   DATA lAlbCli            AS LOGIC INIT .t.

   METHOD New( cPath, lExclusive )

   METHOD Create( cPath, lExclusive )

   METHOD End()         INLINE ( ::CloseFiles() )

   METHOD lOpenFiles( lExclusive )

   METHOD CloseFiles()

   METHOD CreateFiles( cPath )

   METHOD DeleteFiles( cPath )
   METHOD Zap()

   METHOD ReindexFiles( cPath )

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

   //METHOD lAppStock( cCodArt, cCodAlm, cValPr1, cValPr2, cLote, nStkAct, nImpStk, nStkPdr, nStkPde, nStkPdc, cDoc )

   METHOD nStockActual( cCodArt, cCodAlm, cValPr1, cValPr2 )

   METHOD nTotStockAct( cCodArt, cCodAlm, cValPr1, cValPr2, cLote, lKitArt, nKitStk )

   METHOD nPutStockActual( cCodArt, cCodAlm, cValPr1, cValPr2, cLote, lKitAct, nKitStk, oSay )

   METHOD lPutStockActual( cCodArt, cCodAlm, cValPr1, cValPr2, cLote, lKitAct, nKitStk, oSay )

   METHOD Recalcula( oMeter, cPath )

   //METHOD DblChgStock( cCodArt, cCodAlmIn, cCodAlmOut, cValPr1, cValPr2, cLote, nUnits, nTipMov )

   METHOD Duplicados( oMeter, aMsg, cPath )

   METHOD StockInit( cPath, cPathOld, oMsg, lAlbPrv, lAlbCli, lGrupo )

   METHOD nGetUndRes()

   METHOD SetEstadoPedCli( cNumPed )
   METHOD SetEstadoSatCli( cNumPed )

   METHOD SetRecibidoPedCli( cNumPed )
   METHOD SetGeneradoPedCli( cNumPed )

   METHOD SetPedPrv( cNumPed )

   METHOD AppMovAlm( cRefMov, cValPr1, cValPr2, cCodAlm, cValPr1, cValPr2, nCajMov, nUndMov, lApp, cLote )

   METHOD nTotAlbPrv( cCodArt, cCodAlm, cValPr1, cValPr2, cLote, dFecha )
   METHOD nTotFacPrv( cCodArt )
   METHOD nTotRctPrv( cCodArt )
   METHOD nTotAlbCli( cCodArt )
   METHOD nTotFacCli( cCodArt, cCodAlm, cValPr1, cValPr2, cLote, dFecha )
   METHOD nTotFacRec( cCodArt, cCodAlm, cValPr1, cValPr2, cLote, dFecha )
   METHOD nTotTikCli( cCodArt )
   METHOD nTotMovAlm( cCodArt )
   METHOD nStockActualCalculado( cCodArt, cCodAlm, cValPr1, cValPr2, cLote )

   METHOD nStockAlmacen( cCodArt, cCodAlm, cValPr1, cValPr2, cLote )

   METHOD nTotalSaldo( cCodArt, cCodCli )

   METHOD nSaldoDocumento( cCodArt, cNumDoc )

   METHOD nSaldoAnterior( cCodArt, cCodCli, cNumDoc )

   METHOD nSaldoAntAlb( cCodArt, cNumDoc )

   METHOD nSaldoDocAlb( cCodArt, cNumDoc )

   METHOD nPrecioMedioCompra( cCodArt, cCodAlm, dFecIni, dFecFin, lSerie, lExcCero, lExcImp )

   METHOD aStockArticulo( cCodArt )

   METHOD nStockArticulo( cCodArt )

   METHOD nStockSerie( cCodArt, cCodAlm, uNumeroSerie )

   METHOD aStockAlmacen( oRemMov )

   METHOD Integra( sStock )

   METHOD lValidNumeroSerie( cCodArt, cCodAlm, nNumSer, lMessage )

   METHOD BrowseNumeroSerie( cCodArt, cCodAlm )

   METHOD SetTmpAlbCliL( tmpAlbCliL )        INLINE   ( ::tmpAlbCliL := tmpAlbCliL )
   METHOD SetTmpAlbCliS( tmpAlbCliS )        INLINE   ( ::tmpAlbCliS := tmpAlbCliS )

   METHOD SetTmpFacCliL( tmpFacCliL )        INLINE   ( ::tmpFacCliL := tmpFacCliL )
   METHOD SetTmpFacCliS( tmpFacCliS )        INLINE   ( ::tmpFacCliS := tmpFacCliS )

   METHOD SetTmpFacRecL( tmpFacRecL )        INLINE   ( ::tmpFacRecL := tmpFacRecL )
   METHOD SetTmpFacRecS( tmpFacRecS )        INLINE   ( ::tmpFacRecS := tmpFacRecS )

   METHOD nRiesgo( cCodigoCliente )
   METHOD SetRiesgo( cCodigoCliente, oGetRiesgo, nRiesgoCliente )

   METHOD nCostoMedio( cCodArt, cCodAlm, cCodPr1, cCodPr2, cValPr1, cValPr2 )

   METHOD lCheckConsolidacion()

   METHOD lValoracionCostoMedio( nTipMov )

   METHOD lAvisarSerieSinStock( cCodigo )    INLINE   ( RetFld( cCodigo, ::cArticulo, "lMsgSer" ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( cPath, lExclusive ) CLASS TStock

   DEFAULT cPath        := cPatGrp()
   DEFAULT lExclusive   := .f.

   ::cPath              := cPath
   ::lExclusive         := lExclusive

   ::aStocks            := { sStock():New() }

   ::lOpenFiles( cPath, lExclusive )

Return Self

//---------------------------------------------------------------------------//

METHOD Create( cPath, lExclusive ) CLASS TStock

   DEFAULT cPath        := cPatGrp()
   DEFAULT lExclusive   := .f.

   ::cPath              := cPath
   ::lExclusive         := lExclusive

   ::aStocks            := { sStock():New() }

Return Self

//---------------------------------------------------------------------------//

METHOD CreateFiles( cPath ) CLASS TStock

   DEFAULT cPath        := ::cPath

   aAdd( ::aMovAlm, { "cCodArt", "C", 18, 0, ""                                           } )
   aAdd( ::aMovAlm, { "cCodAlm", "C",  3, 0, ""                                           } )
   aAdd( ::aMovAlm, { "cCodPr1", "C", 10, 0, ""                                           } )
   aAdd( ::aMovAlm, { "cCodPr2", "C", 10, 0, ""                                           } )
   aAdd( ::aMovAlm, { "cValPr1", "C", 10, 0, ""                                           } )
   aAdd( ::aMovAlm, { "cValPr2", "C", 10, 0, ""                                           } )
   aAdd( ::aMovAlm, { "nStkAct", "N", 19, 6, "Stock actual"                               } )
   aAdd( ::aMovAlm, { "nStkIn",  "N", 19, 6, "Stock entrada"                              } )
   aAdd( ::aMovAlm, { "nStkPdr", "N", 19, 6, "Stock pendiente de recibir"                 } )
   aAdd( ::aMovAlm, { "nStkPde", "N", 19, 6, "Stock pendiente de entregar"                } )
   aAdd( ::aMovAlm, { "nStkPdc", "N", 19, 6, "Stock pendiente de entregar comprometido"   } )
   aAdd( ::aMovAlm, { "nStkEnt", "N", 19, 6, "Total de stock comprado"                    } )
   aAdd( ::aMovAlm, { "nStkSal", "N", 19, 6, "Total de stock vendido"                     } )
   aAdd( ::aMovAlm, { "nImpStk", "N", 19, 6, "Importe de stock"                           } )
   aAdd( ::aMovAlm, { "nLote"  , "N",  9, 0, "Número de lote"                             } )
   aAdd( ::aMovAlm, { "cLote"  , "C", 12, 0, "Número de lote"                             } )

   if !lExistTable( cPath + "MovAlm.Dbf" )
      dbCreate( cPath + "MovAlm.Dbf", aSqlStruct( ::aMovAlm ), cDriver() )
   end if

   ::ReindexFiles( cPath )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD DeleteFiles( cPath ) CLASS TStock

   DEFAULT cPath        := ::cPath

   dbfErase( cPath + "MovAlm" )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ReindexFiles( cPath, oMeter ) CLASS TStock

   local dbfMovAlm

   DEFAULT cPath        := ::cPath

   if !lExistTable( cPath + "MovAlm.Dbf" )
      ::CreateFiles( cPath )
   end if

   fEraseIndex( cPath + "MovAlm.Cdx" )

   dbUseArea( .t., cDriver(), cPath + "MovAlm.Dbf", cCheckArea( "MovAlm", @dbfMovAlm ), .f. )
   if !( dbfMovAlm )->( netErr() )
      ( dbfMovAlm )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfMovAlm )->( ordCreate( cPath + "MovAlm.Cdx", "Codigo", "cCodArt + cValPr1 + cValPr2 + cCodAlm + cLote", {|| Field->cCodArt + Field->cValPr1 + Field->cValPr2 + Field->cCodAlm + Field->cLote } ) )

      ( dbfMovAlm )->( dbCloseArea() )
   end if


RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lOpenFiles( cPath, lExclusive ) CLASS TStock

   local lOpen          := .t.
   local oError
   local oBlock

   DEFAULT cPath        := ::cPath
   DEFAULT lExclusive   := ::lExclusive

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

      ::cHisMovT        := cCheckArea( "HisMovT" ) 
      ::cHisMovS        := cCheckArea( "HisMovS" ) 

      ::cArticulo       := cCheckArea( "Articulo") 
      ::cKit            := cCheckArea( "Kit"     ) 

      ::nDouDiv         := nDouDiv()
      ::nDorDiv         := nRouDiv()
      ::nDinDiv         := nDinDiv() // Decimales sin redondeo
      ::nDirDiv         := nRinDiv() // Decimales con redondeo
      ::nVdvDiv         := nChgDiv()
      ::nDecIn          := nDinDiv()
      ::nDerIn          := nRinDiv()

      USE ( cPatEmp() + "SatCliT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( ::cSatCliT )
      SET ADSINDEX TO ( cPatEmp() + "SatCliT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "SatCliL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( ::cSatCliL )
      SET ADSINDEX TO ( cPatEmp() + "SatCliL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PedCliT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( ::cPedCliT )
      SET ADSINDEX TO ( cPatEmp() + "PedCliT.Cdx" ) ADDITIVE

      USE ( cPatEmp() + "PedCliL.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( ::cPedCliL )
      SET ADSINDEX TO ( cPatEmp() + "PedCliL.Cdx" ) ADDITIVE

      USE ( cPatEmp() + "PedCliR.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( ::cPedCliR )
      SET ADSINDEX TO ( cPatEmp() + "PedCliR.Cdx" ) ADDITIVE

      USE ( cPatEmp() + "AlbCliT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( ::cAlbCliT )
      SET ADSINDEX TO ( cPatEmp() + "AlbCliT.Cdx" ) ADDITIVE

      USE ( cPatEmp() + "AlbCliL.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( ::cAlbCliL )
      SET ADSINDEX TO ( cPatEmp() + "AlbCliL.Cdx" ) ADDITIVE

      USE ( cPatEmp() + "AlbCliS.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( ::cAlbCliS )
      SET ADSINDEX TO ( cPatEmp() + "AlbCliS.Cdx" ) ADDITIVE

      USE ( cPatEmp() + "FacCliT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( ::cFacCliT )
      SET ADSINDEX TO ( cPatEmp() + "FacCliT.Cdx" ) ADDITIVE

      USE ( cPatEmp() + "FacCliL.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( ::cFacCliL )
      SET ADSINDEX TO ( cPatEmp() + "FacCliL.Cdx" ) ADDITIVE

      USE ( cPatEmp() + "FacCliS.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( ::cFacCliS )
      SET ADSINDEX TO ( cPatEmp() + "FacCliS.Cdx" ) ADDITIVE

      USE ( cPatEmp() + "FacCliP.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( ::cFacCliP )
      SET ADSINDEX TO ( cPatEmp() + "FacCliP.Cdx" ) ADDITIVE

      USE ( cPatEmp() + "AntCliT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( ::cAntCliT ) 
      SET ADSINDEX TO ( cPatEmp() + "AntCliT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FacRecT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( ::cFacRecT )
      SET ADSINDEX TO ( cPatEmp() + "FacRecT.Cdx" ) ADDITIVE

      USE ( cPatEmp() + "FacRecL.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( ::cFacRecL )
      SET ADSINDEX TO ( cPatEmp() + "FacRecL.Cdx" ) ADDITIVE

      USE ( cPatEmp() + "FacRecS.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( ::cFacRecS )
      SET ADSINDEX TO ( cPatEmp() + "FacRecS.Cdx" ) ADDITIVE

      USE ( cPatEmp() + "TikeT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( ::cTikT ) 
      SET ADSINDEX TO ( cPatEmp() + "TikeT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "TikeL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( ::cTikL ) 
      SET ADSINDEX TO ( cPatEmp() + "TikeL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "TikeS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( ::cTikS ) 
      SET ADSINDEX TO ( cPatEmp() + "TikeS.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PedProvT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( ::cPedPrvT ) 
      SET ADSINDEX TO ( cPatEmp() + "PedProvT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PedProvL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( ::cPedPrvL ) 
      SET ADSINDEX TO ( cPatEmp() + "PedProvL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "AlbProvL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( ::cAlbPrvL )
      SET ADSINDEX TO ( cPatEmp() + "AlbProvL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "AlbPrvS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( ::cAlbPrvS ) 
      SET ADSINDEX TO ( cPatEmp() + "AlbPrvS.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FacPrvL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( ::cFacPrvL )
      SET ADSINDEX TO ( cPatEmp() + "FacPrvL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FacPrvS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( ::cFacPrvS ) 
      SET ADSINDEX TO ( cPatEmp() + "FacPrvS.CDX" ) ADDITIVE

      USE ( cPatEmp() + "RctPrvL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( ::cRctPrvL )
      SET ADSINDEX TO ( cPatEmp() + "RctPrvL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "RctPrvS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( ::cRctPrvS ) 
      SET ADSINDEX TO ( cPatEmp() + "RctPrvS.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ProLin.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( ::cProducL ) 
      SET ADSINDEX TO ( cPatEmp() + "ProLin.Cdx" ) ADDITIVE

      USE ( cPatEmp() + "ProMat.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( ::cProducM )
      SET ADSINDEX TO ( cPatEmp() + "ProMat.Cdx" ) ADDITIVE

      USE ( cPatEmp() + "ProSer.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( ::cProducS )
      SET ADSINDEX TO ( cPatEmp() + "ProSer.Cdx" ) ADDITIVE

      USE ( cPatEmp() + "MatSer.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( ::cProducP )
      SET ADSINDEX TO ( cPatEmp() + "MatSer.Cdx" ) ADDITIVE

      USE ( cPatEmp() + "HisMov.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( ::cHisMovT)
      SET ADSINDEX TO ( cPatEmp() + "HisMov.Cdx" ) ADDITIVE

      USE ( cPatEmp() + "MovSer.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( ::cHisMovS )
      SET ADSINDEX TO ( cPatEmp() + "MovSer.Cdx" ) ADDITIVE

      USE ( cPatArt() + "Articulo.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( ::cArticulo ) 
      SET ADSINDEX TO ( cPatArt() + "Articulo.Cdx" ) ADDITIVE

      USE ( cPatArt() + "ArtKit.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( ::cKit ) 
      SET ADSINDEX TO ( cPatArt() + "ArtKit.Cdx" ) ADDITIVE

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

   if ( !Empty( ::cSatCliT ), ( ::cSatCliT )->( dbCloseArea() ), )
   if ( !Empty( ::cSatCliL ), ( ::cSatCliL )->( dbCloseArea() ), )

   if ( !Empty( ::cPedCliT ), ( ::cPedCliT )->( dbCloseArea() ), )
   if ( !Empty( ::cPedCliL ), ( ::cPedCliL )->( dbCloseArea() ), )
   if ( !Empty( ::cPedCliR ), ( ::cPedCliR )->( dbCloseArea() ), )

   if ( !Empty( ::cAlbCliT ), ( ::cAlbCliT )->( dbCloseArea() ), )
   if ( !Empty( ::cAlbCliL ), ( ::cAlbCliL )->( dbCloseArea() ), )
   if ( !Empty( ::cAlbCliS ), ( ::cAlbCliS )->( dbCloseArea() ), )

   if ( !Empty( ::cFacCliT ), ( ::cFacCliT )->( dbCloseArea() ), )
   if ( !Empty( ::cFacCliL ), ( ::cFacCliL )->( dbCloseArea() ), )
   if ( !Empty( ::cFacCliS ), ( ::cFacCliS )->( dbCloseArea() ), )
   if ( !Empty( ::cFacCliP ), ( ::cFacCliP )->( dbCloseArea() ), )

   if ( !Empty( ::cFacRecT ), ( ::cFacRecT )->( dbCloseArea() ), )
   if ( !Empty( ::cFacRecL ), ( ::cFacRecL )->( dbCloseArea() ), )
   if ( !Empty( ::cFacRecS ), ( ::cFacRecS )->( dbCloseArea() ), )

   if ( !Empty( ::cTikT ),    ( ::cTikT )->( dbCloseArea() ), )
   if ( !Empty( ::cTikL ),    ( ::cTikL )->( dbCloseArea() ), )
   if ( !Empty( ::cTikS ),    ( ::cTikS )->( dbCloseArea() ), )

   if ( !Empty( ::cAntCliT ), ( ::cAntCliT )->( dbCloseArea() ), )

   if ( !Empty( ::cArticulo), ( ::cArticulo )->( dbCloseArea() ), )
   if ( !Empty( ::cKit ),     ( ::cKit )->( dbCloseArea() ), )

   if ( !Empty( ::cPedPrvT ), ( ::cPedPrvT )->( dbCloseArea() ), )
   if ( !Empty( ::cPedPrvL ), ( ::cPedPrvL )->( dbCloseArea() ), )

   if ( !Empty( ::cAlbPrvL ), ( ::cAlbPrvL )->( dbCloseArea() ), )
   if ( !Empty( ::cAlbPrvS ), ( ::cAlbPrvS )->( dbCloseArea() ), )

   if ( !Empty( ::cFacPrvL ), ( ::cFacPrvL )->( dbCloseArea() ), )
   if ( !Empty( ::cFacPrvS ), ( ::cFacPrvS )->( dbCloseArea() ), )

   if ( !Empty( ::cRctPrvL ), ( ::cRctPrvL )->( dbCloseArea() ), )
   if ( !Empty( ::cRctPrvS ), ( ::cRctPrvS )->( dbCloseArea() ), )

   if ( !Empty( ::cProducL ), ( ::cProducL )->( dbCloseArea() ), )   
   if ( !Empty( ::cProducM ), ( ::cProducM )->( dbCloseArea() ), )   
   if ( !Empty( ::cProducS ), ( ::cProducS )->( dbCloseArea() ), )   
   if ( !Empty( ::cProducP ), ( ::cProducP )->( dbCloseArea() ), )   

   if ( !Empty( ::cHisMovT ), ( ::cHisMovT )->( dbCloseArea() ), )   
   if ( !Empty( ::cHisMovS ), ( ::cHisMovS )->( dbCloseArea() ), )   

Return ( Self )

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
      msgAlert( "Imposible realizar la actualización de stocks.", "Atención" )
      return self
   end if

   if ( ::cPedPrvL )->( dbSeek( cNumPed ) )

      while ( ::cPedPrvL )->cSerPed + Str( ( ::cPedPrvL )->nNumPed ) + ( ::cPedPrvL )->cSufPed == cNumPed .and. ;
            !( ::cPedPrvL )->( eof() );

         if !Empty( Rtrim( ( ::cPedPrvL )->cRef ) )

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

return self

//---------------------------------------------------------------------------//

METHOD AlbPrv( cNumAlb, cCodAlm, cNumPed, lDelete, lIncremento, lIgnEstado, lActPendientes ) CLASS TStock

Return Self

//---------------------------------------------------------------------------//


METHOD SetPedPrv( cNumPed ) CLASS TStock

   local nEstPed
   local nRegAnt        
   local nOrdAnt        
   local nTotPedPrv     := 0
   local nRecPedPrv     := 0
   local nTotLineaAct   := 0

   if Empty( ::cPedPrvT ) .or. Empty( ::cPedPrvL )
      return .f.
   end if

   nRegAnt              := ( ::cPedPrvT )->( RecNo() )
   nOrdAnt              := ( ::cPedPrvT )->( OrdSetFocus( "nNumPed" ) )

   // Comprobamos como esta el pedido------------------------------------------

   if !Empty( cNumPed )                            .and.;
      ( ::cPedPrvT )->( dbSeek( cNumPed ) )        .and.;
      ( ::cPedPrvL )->( dbSeek( cNumPed ) )

      while ( ::cPedPrvL )->cSerPed + Str( ( ::cPedPrvL )->nNumPed ) + ( ::cPedPrvL )->cSufPed == cNumPed .and. !( ::cPedPrvL )->( eof() )

         if !( ::cPedPrvL )->lAnulado

            //se cuenta la linea actual, para evitar que de como valido, pedir 5 de un producto y 5 de otro
            //pero al recibir 2 de uno y 8 del otro

            nTotLineaAct:= nTotNPedPrv( ::cPedPrvL )
            nTotPedPrv  += nTotLineaAct
            nRecPedPrv  += Min( nUnidadesRecibidasPedPrv( cNumPed, ( ::cPedPrvL )->cRef, ( ::cPedPrvL )->cValPr1, ( ::cPedPrvL )->cValPr2, ( ::cPedPrvL )->cRefPrv, ( ::cPedPrvL )->cDetalle, ::cAlbPrvL ), nTotLineaAct )

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

   end if

   ( ::cPedPrvT )->( OrdSetFocus( nOrdAnt ) )
   ( ::cPedPrvT )->( DbGoTo( nRegAnt ) )

Return ( Self )

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
      msgAlert( "Imposible realizar la actualización de stocks.", "Atención" )
      return self
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

            if Empty( ( ::cFacPrvL )->cAlmLin ) .and. dbLock( ::cFacPrvL )
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

Return ( Self )

//---------------------------------------------------------------------------//

METHOD ChkFacPrv( cNumFac ) CLASS TStock

return self

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
      msgAlert( "Imposible realizar la actualización de stocks.", "Atención" )
      return self
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

            if Empty( ( ::cRctPrvL )->cAlmLin ) .and. dbLock( ::cRctPrvL )
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

Return ( Self )

//---------------------------------------------------------------------------//

METHOD ChkRctPrv( cNumFac ) CLASS TStock

return self

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

   if Empty( cNumPed ) .or. Empty( ::cPedCliL ) .or. Empty( ::cAlbCliT ) .or. Empty( ::cAlbCliL ) .or. Empty( ::cAlbPrvL )
      msgAlert( "Imposible realizar la actualización de stocks.", "Atención" )
      return self
   end if

   if ( ::cPedCliL )->( dbSeek( cNumPed ) )

      while ( ::cPedCliL )->cSerPed + Str( ( ::cPedCliL )->nNumPed ) + ( ::cPedCliL )->cSufPed == cNumPed .and. ;
            !( ::cPedCliL )->( eof() )

         if !Empty( Rtrim( ( ::cPedCliL )->cRef ) )

            nUndPed     := nTotNPedCli( ::cPedCliL )
            nUndRes     := nTotRPedCli( ( ::cPedCliL )->cSerPed + Str( ( ::cPedCliL )->nNumPed ) + ( ::cPedCliL )->cSufPed, ( ::cPedCliL )->cRef, ( ::cPedCliL )->cValPr1, ( ::cPedCliL )->cValPr2, ::cPedCliR )

            /*
            Si no tenemos almacen en linea se lo ponemos
            */

            if Empty( ( ::cPedCliL )->cAlmLin )
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

return self

//---------------------------------------------------------------------------//

METHOD SetEstadoPedCli( cNumPed, lFactura, cNumFac ) CLASS TStock

   local nEstPed        := 1
   local nTotPed        := 0
   local nTotSer        := 0
   local nTotLineaAct   := 0

   DEFAULT lFactura     := .f.

   if Empty( ::cPedCliT ) .or. Empty( ::cPedCliL )
      return .f.
   end if

   /*
   Comprobamos como esta el pedido------------------------------------------
   */

   if ( ::cPedCliT )->( dbSeek( cNumPed ) )  .and.;
      ( ::cPedCliL )->( dbSeek( cNumPed ) )

      while ( ::cPedCliL )->cSerPed + Str( ( ::cPedCliL )->nNumPed ) + ( ::cPedCliL )->cSufPed == cNumPed .and.;
            !( ::cPedCliL )->( eof() )

         if !( ::cPedCliL )->lAnulado

            //se cuenta la linea actual, para evitar que de como valido, pedir 5 de un producto y 5 de otro
            //pero al recibir 2 de uno y 8 del otro

            nTotLineaAct:= nTotNPedCli( ::cPedCliL )

            nTotPed     += nTotLineaAct

            nTotSer     += Min( nUnidadesRecibidasAlbCli( ( ::cPedCliL )->cSerPed + Str( ( ::cPedCliL )->nNumPed ) + ( ::cPedCliL )->cSufPed, ( ::cPedCliL )->cRef, ( ::cPedCliL )->cCodPr1, ( ::cPedCliL )->cCodPr2, ( ::cPedCliL )->cRefPrv, ( ::cPedCliL )->cDetalle, ::cAlbCliL ), nTotLineaAct )
            nTotSer     += Min( nUnidadesRecibidasFacCli( ( ::cPedCliL )->cSerPed + Str( ( ::cPedCliL )->nNumPed ) + ( ::cPedCliL )->cSufPed, ( ::cPedCliL )->cRef, ( ::cPedCliL )->cValPr1, ( ::cPedCliL )->cValPr2, ::cFacCliL ), nTotLineaAct )
            //nTotSer     += Min( nTotRFacCli( cNumFac, nil, ( ::cPedCliL )->cRef, ( ::cPedCliL )->cValPr1, ( ::cPedCliL )->cValPr2, ( ::cPedCliL )->cLote, ::cFacCliT, ::cFacCliL ), nTotLineaAct )

         end if

         ( ::cPedCliL )->( dbSkip() )

      end do

      /*
      En funcion de lo recibido colocamos los pedidos
      */

      do case
         case nTotSer == 0
            nEstPed     := 1
         case nTotPed > nTotSer
            nEstPed     := 2
         case nTotSer >= nTotPed
            nEstPed     := 3
      end case

      if dbLock( ::cPedCliT )
         ( ::cPedCliT )->nEstado := nEstPed
         ( ::cPedCliT )->( dbUnlock() )
      end if

   end if

Return .t.

//---------------------------------------------------------------------------//

METHOD SetEstadoSatCli( cNumSat ) CLASS TStock

   if Empty( ::cSatCliT ) 
      return .f.
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

Return .t.

//---------------------------------------------------------------------------//

METHOD SetRecibidoPedCli( cNumPed ) CLASS TStock

   local nUndPed
   local nEstPed        := 0
   local nTotRec        := 0
   local nTotPed        := 0

   /*
   Datos necesarios------------------------------------------------------------
   */

   if Empty( cNumPed ) .or. Empty( ::cPedCliT ) .or. Empty( ::cPedCliL ) .or. Empty( ::cAlbPrvL )
      // msgAlert( "Imposible actualizar el estado del pedido.", "Atención" )
      return self
   end if

   if ( ::cPedCliT )->( dbSeek( cNumPed ) )  .and.;
      ( ::cPedCliL )->( dbSeek( cNumPed ) )

      while ( ::cPedCliL )->cSerPed + Str( ( ::cPedCliL )->nNumPed ) + ( ::cPedCliL )->cSufPed == cNumPed .and. ;
            !( ::cPedCliL )->( eof() )

         if !Empty( ( ::cPedCliL )->cRef )

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

Return ( Self )

//---------------------------------------------------------------------------//

METHOD SetGeneradoPedCli( cNumPed ) CLASS TStock

   local nEstado  := 0
   local nRecCliT := ( ::cPedCliT )->( Recno() )
   local nRecCliL := ( ::cPedCliL )->( Recno() )
   local nOrdCliT := ( ::cPedCliT )->( OrdSetFocus( "nNumPed" ) )
   local nOrdCliL := ( ::cPedCliL )->( OrdSetFocus( "nNumPed" ) )

   /*
   Datos necesarios------------------------------------------------------------
   */

   if Empty( cNumPed ) .or. Empty( ::cPedCliT ) .or. Empty( ::cPedCliL ) .or. Empty( ::cPedPrvL )
      msgAlert( "Imposible actualizar el estado del pedido.", "Atención" )
      return self
   end if

   if ( ::cPedCliT )->( dbSeek( cNumPed ) )  .and. ;
      ( ::cPedCliL )->( dbSeek( cNumPed ) )

      while ( ::cPedCliL )->cSerPed + Str( ( ::cPedCliL )->nNumPed ) + ( ::cPedCliL )->cSufPed == cNumPed .and. ;
            !( ::cPedCliL )->( eof() )

         if nTotNPedCli( ::cPedCliL ) != 0

            if IsMuebles()

               if dbSeekInOrd( cNumPed + ( ::cPedCliL )->cRef + ( ::cPedCliL )->cValPr1 + ( ::cPedCliL )->cValPr2 + ( ::cPedCliL )->cRefPrv + ( ::cPedCliL )->cDetalle, "cPedCliDet", ::cPedPrvL )

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

            else

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

         end if

         ( ::cPedCliL )->( dbSkip() )

      end while

      if dbLock( ::cPedCliT )
         ( ::cPedCliT )->nGenerado  := Max( nEstado, 1 )
         ( ::cPedCliT )->( dbUnLock() )
      end if

   end if

   ( ::cPedCliT )->( OrdSetFocus( nOrdCliT ) )
   ( ::cPedCliL )->( OrdSetFocus( nOrdCliL ) )
   ( ::cPedCliT )->( dbGoTo( nRecCliT ) )
   ( ::cPedCliL )->( dbGoTo( nRecCliL ) )

Return ( Self )

//---------------------------------------------------------------------------//
//
// Devuleve las unidades reservadas
//

METHOD nGetUndRes() CLASS TStock

   local nUndRes  := nTotRPedCli( ( ::cPedCliL )->cSerPed + Str( ( ::cPedCliL )->nNumPed ) + ( ::cPedCliL )->cSufPed, ( ::cPedCliL )->cRef, ( ::cPedCliL )->cValPr1, ( ::cPedCliL )->cValPr2, ::cPedCliR )

   if nUndRes != 0

      nUndRes     -= nUnidadesRecibidasAlbCli( ( ::cPedCliL )->cSerPed + Str( ( ::cPedCliL )->nNumPed ) + ( ::cPedCliL )->cSufPed, ( ::cPedCliL )->cRef, ( ::cPedCliL )->cValPr1, ( ::cPedCliL )->cValPr2, ( ::cPedCliL )->cRefPrv, ( ::cPedCliL )->cDetalle, ::cAlbCliL )

      /*
      No se pueden dar de baja mas q los reservados
      */

      if nUndRes < 0
         nUndRes  := 0
      end if

   end if

return ( nUndRes )

//---------------------------------------------------------------------------//

METHOD AlbCli( cNumAlb, cCodAlm, lDelete, lIncremento, lIgnEstado, lChequea, lActPendientes ) CLASS TStock

   /*
   local n
   local nUnits
   local nEstPed           := 0
   local aNumPed           := {}
   local aAlbCliT          := aGetStatus( ::cAlbCliT, .t. )
   local aAlbCliL          := aGetStatus( ::cAlbCliL, .t. )
   local nStkPde           := 0

   DEFAULT cCodAlm         := oUser():cAlmacen()
   DEFAULT lDelete         := .t.
   DEFAULT lIncremento     := .t.
   DEFAULT lIgnEstado      := .f.
   DEFAULT lChequea        := .t.
   DEFAULT lActPendientes  := .t.

   if ::cAlbCliT == nil .or. ::cAlbCliL == nil .or. cNumAlb == nil
      msgAlert( "Imposible realizar la actualización de stocks.", "Atención" )
      return self
   end if

   if ( ::cAlbCliT )->( dbSeek( cNumAlb ) )

      if ( ::cAlbCliL )->( dbSeek( cNumAlb ) )

         while ( ::cAlbCliL )->cSerAlb + Str( ( ::cAlbCliL )->nNumAlb ) + ( ::cAlbCliL )->cSufAlb == cNumAlb .and. ;
               !( ::cAlbCliL )->( eof() );

            if !Empty( Rtrim( ( ::cAlbCliL )->cRef ) )

               nUnits      := nTotNAlbCli( ::cAlbCliL )

               if ( ::cAlbCliL )->nFacCnv != 0
                  nUnits   := nUnits / ( ::cAlbCliL )->nFacCnv
               end if

               if Empty( ( ::cAlbCliL )->cAlmLin )
                  if dbLock( ::cAlbCliL )
                     ( ::cAlbCliL )->cAlmLin    := ( ::cAlbCliT )->cCodAlm
                     ( ::cAlbCliL )->( dbUnLock() )
                  end if
               end if

               if lActPendientes .and. ( ::cAlbCliL )->nCtlStk <= 1 .and. nUnits != 0
                  if !Empty( ( ::cAlbCliT )->cNumPed )
                     nStkPde  := if( lIncremento, nUnits, - nUnits )
                  else
                     nStkPde  := 0
                  end if

               end if

            end if

            if aScan( aNumPed, ( ::cAlbCliL )->cNumPed ) == 0
               aAdd( aNumPed, ( ::cAlbCliL )->cNumPed )
            end if

            if lDelete .and. dbLock( ::cAlbCliL )
               ( ::cAlbCliL )->( dbDelete() )
               ( ::cAlbCliL )->( dbUnLock() )
               nEstPed++
            end if

            ( ::cAlbCliL )->( dbSkip() )

         end do

      end if

   end if

   for n := 1 to len( aNumPed )
      ::SetEstadoPedCli( aNumPed[ n ] )
   next

   SetStatus( ::cAlbCliT, aAlbCliT )
   SetStatus( ::cAlbCliL, aAlbCliL )
   */

   /*if lChequea
      ::ChkAlbCli( cNumAlb )
   end if*/

return self

//---------------------------------------------------------------------------//

METHOD ChkAlbCli( cNumAlb ) CLASS TStock

return self

//---------------------------------------------------------------------------//

METHOD AlqCli( cNumAlq, cCodAlm, lDelete, lIncremento, lIgnEstado, lChequea ) CLASS TStock

Return ( Self )

//---------------------------------------------------------------------------//

METHOD FacCli( cNumFac, cCodAlm, lDelete, lIncremento, lActPendientes ) CLASS TStock

   /*
   local nUnits
   local nPendEnt          := 0

   DEFAULT cCodAlm         := oUser():cAlmacen()
   DEFAULT lDelete         := .t.
   DEFAULT lIncremento     := .t.
   DEFAULT lActPendientes  := .f.

   if ::cFacCliL == nil .or. cNumFac == nil
      msgAlert( "Imposible realizar la actualización de stocks.", "Atención" )
      return self
   end if

   if ( ::cFacCliL )->( dbSeek( cNumFac ) )

      while ( ::cFacCliL )->cSerie + Str( ( ::cFacCliL )->nNumFac ) + ( ::cFacCliL )->cSufFac == cNumFac .and.;
            !( ::cFacCliL )->( eof() )

         if !empty( rtrim( ( ::cFacCliL )->cRef ) ) .and. !( ::cFacCliL )->lAlquiler

            nUnits      := nTotNFacCli( ::cFacCliL )

            if ( ::cFacCliL )->( fieldpos( "NFACCNV" ) ) != 0 .and. ( ::cFacCliL )->nFacCnv != 0
               nUnits   := nUnits / ( ::cFacCliL )->nFacCnv
            end if

            if !Empty( ( ::cFacCliT )->cNumPed )
               nPendEnt := if( lIncremento, nUnits, - nUnits )
            end if

            if Empty( ( ::cFacCliL )->cAlmLin )
               if dbLock( ::cFacCliL )
                  ( ::cFacCliL )->cAlmLin    := ( ::cFacCliT )->cCodAlm
                  ( ::cFacCliL )->( dbUnLock() )
               end if
            end if

         end if

         if lDelete .and. dbLock( ::cFacCliL )
            ( ::cFacCliL )->( dbDelete() )
            ( ::cFacCliL )->( dbUnLock() )
         end if

         ( ::cFacCliL )->( dbSkip() )

      end do

   end if

   if !Empty( ( ::cFacCliT )->cNumPed )
      ::SetEstadoPedCli( ( ::cFacCliT )->cNumPed, .t., cNumFac )
   end if

   //::ChkFacCli( cNumFac )
   */

return self

//---------------------------------------------------------------------------//

METHOD ChkFacCli( cNumFac ) CLASS TStock

return self

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
      msgAlert( "Imposible realizar la actualización de stocks.", "Atención" )
      return self
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

            if Empty( ( ::cFacRecL )->cAlmLin )
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


return self

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
      return self
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

         if !Empty( Rtrim( ( ::cTikL )->cCbaTil ) )

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

            if Empty( ( ::cTikL )->cAlmLin ) .and. dbLock( ::cTikL )
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

return self

//---------------------------------------------------------------------------//

METHOD ChkTikCli( cNumTik ) CLASS TStock

return self

//---------------------------------------------------------------------------//
//
// Devuelve el numero de unidades en almacen de un producto
//

METHOD nStockActual( cCodArt, cCodAlm, cValPr1, cValPr2, cLote ) CLASS TStock

   local aSta
   local nUnits   := 0

RETURN ( nUnits )

//---------------------------------------------------------------------------//
//
// Devuelve el total de stock de un articulo en un almacen
//

METHOD nTotStockAct( cCodArt, cCodAlm, cValPr1, cValPr2, cLote, lKitArt, nKitStk, nCtlStk ) CLASS TStock

   local aSta
   local nUnits         := 0
   local oError
   local oBlock

   DEFAULT lKitArt      := .t.
   DEFAULT nKitStk      := 0
   DEFAULT nCtlStk      := 1

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

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

            end do

         end if

      else

         nUnits            := ::nStockAlmacen( cCodArt, cCodAlm, cValPr1, cValPr2, cLote )

      end if

   end if

   RECOVER USING oError

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( nUnits )

//---------------------------------------------------------------------------//

METHOD nPutStockActual( cCodArt, cCodAlm, cValPr1, cValPr2, cLote, lKitArt, nKitStk, oSay ) CLASS TStock

   local cClass   := oSay:ClassName()
   local nStock   := ::nTotStockAct( cCodArt, cCodAlm, cValPr1, cValPr2, cLote, lKitArt, nKitStk, nKitStk )

   do case
      case cClass == "TGET" .or. cClass == "TGETHLP"
         oSay:cText( nStock )
      case cClass == "TSAY"
         oSay:SetText( nStock )
   end case

   /*
   if nStock > 0
      oSay:SetColor( CLR_GREEN, CLR_GREEN )
   elseif nStock < 0
      oSay:SetColor( CLR_RED, CLR_RED )
   end if
   */

return ( nStock )

//---------------------------------------------------------------------------//

METHOD lPutStockActual( cCodArt, cCodAlm, cValPr1, cValPr2, cLote, lKitArt, nKitStk, oSay ) CLASS TStock

   local cClass   := oSay:ClassName()
   local nStock   := ::nTotStockAct( cCodArt, cCodAlm, cValPr1, cValPr2, cLote, lKitArt, nKitStk )

   do case
      case cClass == "TGET" .or. cClass == "TGETHLP"
         oSay:cText( nStock )
      case cClass == "TSAY"
         oSay:SetText( nStock )
   end case

return ( .t. )

//---------------------------------------------------------------------------//

METHOD Recalcula( oMeter, cNewEmp, cPatEmp ) CLASS TStock

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Duplicados( oMeter, aMsg, cPath ) CLASS TStock

   local lDup           := .f.
   local dbf
   local cCodAnt

   DEFAULT cPath        := ::cPath
   DEFAULT aMsg         := {}

   USE ( cPatArt() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbf ) )
   SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

   if oMeter != NIL
      oMeter:nTotal := ( dbf )->( LastRec() )
      oMeter:cText  := "Artículos"
   end if

   while !( dbf )->( eof() )

      cCodAnt  := ( dbf )->Codigo
      ( dbf )->( dbSkip() )
      if cCodAnt == ( dbf )->Codigo .and. !(dbf)->(eof())
         aAdd( aMsg, { .t., "Artículo duplicado : " + cCodAnt } )
         lDup  := .t.
      end if

      if oMeter != NIL .and. Mod( ( dbf )->( OrdKeyNo() ), int( oMeter:nTotal / 10 ) ) == 0
         oMeter:Set( ( dbf )->( OrdKeyNo() ) )
      else
         SysRefresh()
      end if

   end do

   CLOSE ( dbf )

   /*
   Procesamos pedidos de proveedores-----------------------------------------
   */

   USE ( cPath + "PEDPROVT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDPROVT", @dbf ) )
   SET ADSINDEX TO ( cPath + "PEDPROVT.CDX" ) ADDITIVE

   if oMeter != NIL
      oMeter:nTotal := ( dbf )->( LastRec() )
      oMeter:cText  := "Ped. Prv."
   end if

   while !( dbf )->( eof() )

      cCodAnt  := ( dbf )->CSERPED + Str( ( dbf )->NNUMPED ) + ( dbf )->CSUFPED
      ( dbf )->( dbSkip() )
      if cCodAnt  == ( dbf )->CSERPED + Str( ( dbf )->NNUMPED ) + ( dbf )->CSUFPED .and. !(dbf)->(eof())
         aAdd( aMsg, { .t., "Pedido a proveedor duplicado : " + cCodAnt } )
         lDup  := .t.
      end if

      if oMeter != NIL .and. Mod( ( dbf )->( OrdKeyNo() ), int( oMeter:nTotal / 10 ) ) == 0
         oMeter:Set( ( dbf )->( OrdKeyNo() ) )
      end if

   end do

   CLOSE ( dbf )

   /*
   Procesamos albaranes de proveedores-----------------------------------------
   *<</

   USE ( cPath + "ALBPROVT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBPROVT", @dbf ) )
   SET ADSINDEX TO ( cPath + "ALBPROVT.CDX" ) ADDITIVE

   if oMeter != NIL
      oMeter:nTotal := ( dbf )->( LastRec() )
      oMeter:cText  := "Alb. Prv."
   end if

   while !( dbf )->( eof() )

      cCodAnt  := (dbf)->CSERALB + Str( (dbf)->NNUMALB ) + (dbf)->CSUFALB
      ( dbf )->( dbSkip() )
      if cCodAnt  == (dbf)->CSERALB + Str( (dbf)->NNUMALB ) + (dbf)->CSUFALB .and. !(dbf)->(eof())
         aAdd( aMsg, { .t., "Albaran de proveedor duplicado : " + cCodAnt } )
         lDup  := .t.
      end if

      if oMeter != NIL .and. Mod( ( dbf )->( OrdKeyNo() ), int( oMeter:nTotal / 10 ) ) == 0
         oMeter:Set( ( dbf )->( OrdKeyNo() ) )
      end if

   end do

   CLOSE ( dbf )

   /*
   Procesamos facturas de proveedores------------------------------------------
   */

   USE ( cPath + "FACPRVT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPROVT", @dbf ) )
   SET ADSINDEX TO ( cPath + "FACPRVT.CDX" ) ADDITIVE

   if oMeter != NIL
      oMeter:nTotal := ( dbf )->( LastRec() )
      oMeter:cText  := "Fac. Prv."
   end if

   while !( dbf )->( eof() )

      cCodAnt  := (dbf)->CSERFAC + Str( (dbf)->NNUMFAC ) + (dbf)->CSUFFAC
      ( dbf )->( dbSkip() )
      if cCodAnt  == (dbf)->CSERFAC + Str( (dbf)->NNUMFAC ) + (dbf)->CSUFFAC .and. !(dbf)->(eof())
         aAdd( aMsg, { .t., "Factura de proveedor duplicado : " + cCodAnt } )
         lDup  := .t.
      end if

      if oMeter != NIL .and. Mod( ( dbf )->( OrdKeyNo() ), int( oMeter:nTotal / 10 ) ) == 0
         oMeter:Set( ( dbf )->( OrdKeyNo() ) )
      end if

   end do

   CLOSE ( dbf )

   /*
   Procesamos facturas rectificativa de proveedores------------------------------------------
   */

   USE ( cPath + "RctPrvT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "RctPrvT", @dbf ) )
   SET ADSINDEX TO ( cPath + "RctPrvT.CDX" ) ADDITIVE

   if oMeter != NIL
      oMeter:nTotal  := ( dbf )->( LastRec() )
      oMeter:cText   := "Rct. Prv."
   end if

   while !( dbf )->( eof() )

      cCodAnt        := ( dbf )->cSerFac + Str( ( dbf )->nNumFac ) + ( dbf )->cSufFac
      ( dbf )->( dbSkip() )

      if cCodAnt  == ( dbf )->cSerFac + Str( ( dbf )->nNumFac ) + ( dbf )->cSufFac .and. !( dbf )->( eof() )
         aAdd( aMsg, { .t., "Factura rectificativa de proveedor duplicado : " + cCodAnt } )
         lDup  := .t.
      end if

      if oMeter != NIL .and. Mod( ( dbf )->( OrdKeyNo() ), int( oMeter:nTotal / 10 ) ) == 0
         oMeter:Set( ( dbf )->( OrdKeyNo() ) )
      end if

   end do

   CLOSE ( dbf )

   /*
   Procesamos pedidos de clientes----------------------------------------------
   */

   USE ( cPath + "PEDCLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDCLIT", @dbf ) )
   SET ADSINDEX TO ( cPath + "PEDCLIT.CDX" ) ADDITIVE

   if oMeter != NIL
      oMeter:nTotal := ( dbf )->( LastRec() )
      oMeter:cText  := "Ped. Prv."
   end if

   while !( dbf )->( eof() )

      cCodAnt  := (dbf)->CSERPED + Str( (dbf)->NNUMPED ) + (dbf)->CSUFPED
      ( dbf )->( dbSkip() )
      if cCodAnt  == (dbf)->CSERPED + Str( (dbf)->NNUMPED ) + (dbf)->CSUFPED .and. !(dbf)->(eof())
         aAdd( aMsg, { .t., "Pedido de cliente duplicado : " + cCodAnt } )
         lDup  := .t.
      end if

      if oMeter != NIL .and. Mod( ( dbf )->( OrdKeyNo() ), int( oMeter:nTotal / 10 ) ) == 0
         oMeter:Set( ( dbf )->( OrdKeyNo() ) )
      else
         SysRefresh()
      end if

   end do

   CLOSE ( dbf )

   /*
   Procesamos albaranes de Clientes--------------------------------------------
   */

   USE ( cPath + "ALBCLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIT", @dbf ) )
   SET ADSINDEX TO ( cPath + "ALBCLIT.CDX" ) ADDITIVE

   if oMeter != NIL
      oMeter:nTotal := ( dbf )->( LastRec() )
      oMeter:cText  := "Alb. Cli."
   end if

   while !( dbf )->( eof() )

      cCodAnt  := (dbf)->CSERALB + Str( (dbf)->NNUMALB ) + (dbf)->CSUFALB
      ( dbf )->( dbSkip() )
      if cCodAnt  == (dbf)->CSERALB + Str( (dbf)->NNUMALB ) + (dbf)->CSUFALB .and. !(dbf)->(eof())
         aAdd( aMsg, { .t., "Albaran de cliente duplicado : " + cCodAnt } )
         lDup  := .t.
      end if

      if oMeter != NIL .and. Mod( ( dbf )->( OrdKeyNo() ), int( oMeter:nTotal / 10 ) ) == 0
         oMeter:Set( ( dbf )->( OrdKeyNo() ) )
      end if

   end do

   CLOSE ( dbf )

   /*
   Procesamos facturas de clientes------------------------------------------
   */

   USE ( cPath + "FACCLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIT", @dbf ) )
   SET ADSINDEX TO ( cPath + "FACCLIT.CDX" ) ADDITIVE

   if oMeter != NIL
      oMeter:nTotal := ( dbf )->( LastRec() )
      oMeter:cText  := "Fac. Cli."
   end if

   while !( dbf )->( eof() )

      cCodAnt  := ( dbf )->cSerie + Str( ( dbf )->nNumFac ) + ( dbf )->cSufFac
      ( dbf )->( dbSkip() )
      if cCodAnt  == ( dbf )->cSerie + Str( ( dbf )->nNumFac ) + ( dbf )->cSufFac .and. !(dbf)->(eof())
         aAdd( aMsg, { .t., "Factura de cliente duplicado : " + cCodAnt } )
         lDup  := .t.
      end if

      if oMeter != NIL .and. Mod( ( dbf )->( OrdKeyNo() ), int( oMeter:nTotal / 10 ) ) == 0
         oMeter:Set( ( dbf )->( OrdKeyNo() ) )
      end if

   end do

   CLOSE ( dbf )

   /*
   Procesamos tikets de clientes-----------------------------------------------
   */

   USE ( cPath + "TIKET.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKET", @dbf ) )
   SET ADSINDEX TO ( cPath + "TIKET.CDX" ) ADDITIVE

   if oMeter != NIL
      oMeter:nTotal := ( dbf )->( LastRec() )
      oMeter:cText  := "Tik. Cli."
   end if

   while !( dbf )->( eof() )

      cCodAnt  := (dbf)->CSERTIK + (dbf)->CNUMTIK + (dbf)->CSUFTIK
      ( dbf )->( dbSkip() )

      if cCodAnt == (dbf)->CSERTIK + (dbf)->CNUMTIK + (dbf)->CSUFTIK .and. !(dbf)->(eof())
         aAdd( aMsg, { .t., "Ticket de cliente duplicado : " + cCodAnt } )
         lDup  := .t.
      end if

      if oMeter != NIL .and. Mod( ( dbf )->( OrdKeyNo() ), int( oMeter:nTotal / 10 ) ) == 0
         oMeter:Set( ( dbf )->( OrdKeyNo() ) )
      end if

   end do

   CLOSE ( dbf )

RETURN ( lDup )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD StockInit( cPath, cPathOld, oMsg, lAlbPrv, lAlbCli, nCalcCosto ) CLASS TStock

   local aAlm
   local sStk
   local aStk
   local dbfAlm
   local dbfCnt
   local oldArt
   local oldTikL
   local nNumDoc
   local dbfHisMov
   local dbfRemMov
   local oldHisMov
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

   DEFAULT lAlbPrv   := .t.
   DEFAULT lAlbCli   := .t.

   if Empty( cPathOld )
      Return nil
   end if

   aAlm              := {}
   aStk              := {}

   if ::lOpenFiles( cPath, .t. )

      ::lAlbPrv      := lAlbPrv
      ::lAlbCli      := lAlbCli

      USE ( cPath + "HisMov.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "HISMOV", @dbfHisMov ) )
      SET ADSINDEX TO ( cPath + "HisMov.Cdx" ) ADDITIVE

      USE ( cPath + "RemMovT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "REMMOVT", @dbfRemMov ) )
      SET ADSINDEX TO ( cPath + "RemMovT.Cdx" ) ADDITIVE

      USE ( cPath + "NCount.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "NCount", @dbfCnt ) )
      SET ADSINDEX TO ( cPath + "NCount.Cdx" ) ADDITIVE

      USE ( cPatAlm() + "Almacen.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALMACEN", @dbfAlm ) )
      SET ADSINDEX TO ( cPatAlm() + "Almacen.Cdx" ) ADDITIVE

      USE ( cPathOld + "HisMov.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "HISMOV", @oldHisMov ) )
      SET ADSINDEX TO ( cPathOld + "HisMov.Cdx" ) ADDITIVE

      USE ( cPathOld + "Articulo.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @oldArt ) )
      SET ADSINDEX TO ( cPathOld + "ARTICULO.CDX" ) ADDITIVE

      USE ( cPathOld + "PEDPROVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PedPrvL", @oldPedPrvL ) )
      SET ADSINDEX TO ( cPathOld + "PEDPROVL.CDX" ) ADDITIVE

      USE ( cPathOld + "ALBPROVL.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBPRVL", @oldAlbPrvL ) )
      SET ADSINDEX TO ( cPathOld + "ALBPROVL.CDX" ) ADDITIVE

      USE ( cPathOld + "FACPRVL.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVL", @oldFacPrvL ) )
      SET ADSINDEX TO ( cPathOld + "FACPRVL.CDX" ) ADDITIVE

      USE ( cPathOld + "RctPrvL.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "RctPrvL", @oldRctPrvL ) )
      SET ADSINDEX TO ( cPathOld + "RctPrvL.CDX" ) ADDITIVE

      USE ( cPathOld + "PEDCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PedCliL", @oldPedCliL ) )
      SET ADSINDEX TO ( cPathOld + "PEDCLIL.CDX" ) ADDITIVE

      USE ( cPathOld + "ALBCLIL.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIL", @oldAlbCliL ) )
      SET ADSINDEX TO ( cPathOld + "ALBCLIL.CDX" ) ADDITIVE

      USE ( cPathOld + "FACCLIL.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCliL", @oldFacCliL ) )
      SET ADSINDEX TO ( cPathOld + "FACCliL.CDX" ) ADDITIVE

      USE ( cPathOld + "FACRECL.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACRECL", @oldFacRecL ) )
      SET ADSINDEX TO ( cPathOld + "FACRECL.CDX" ) ADDITIVE

      USE ( cPathOld + "TIKEL.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKEL", @oldTikL ) )
      SET ADSINDEX TO ( cPathOld + "TIKEL.CDX" ) ADDITIVE

      USE ( cPathOld + "PROLIN.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROLIN", @oldProLin ) )
      SET ADSINDEX TO ( cPathOld + "PROLIN.CDX" ) ADDITIVE

      USE ( cPathOld + "PROMAT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROMAT", @oldProMat ) )
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
      ::cHisMovT                             := oldHisMov
      ::cProducL                             := oldProLin
      ::cProducM                             := oldProMat

      /*
      Rellenemaos el arry con los stocks---------------------------------------
      */

      ( oldArt )->( dbGoTop() )
      while !( oldArt )->( eof() )
         aEval( ::aStockArticulo( ( oldArt )->Codigo ), {|s| aAdd( aStk, s ) } ) //, ( dbfAlm )->cCodAlm )
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

            if dbAppe( dbfRemMov )

               nNumDoc                          := nNewDoc( nil, dbfHisMov, "nMovAlm", nil, dbfCnt )
               ( dbfRemMov )->nNumRem           := nNumDoc
               ( dbfRemMov )->cSufRem           := RetSufEmp()
               ( dbfRemMov )->nTipMov           := 4
               ( dbfRemMov )->cCodUsr           := cCurUsr()
               ( dbfRemMov )->cCodDlg           := ""
               ( dbfRemMov )->cCodAge           := ""
               ( dbfRemMov )->cCodMov           := "EI"
               ( dbfRemMov )->dFecRem           := Date()
               ( dbfRemMov )->cTimRem           := Time()
               ( dbfRemMov )->cAlmOrg           := ( dbfAlm )->cCodAlm
               ( dbfRemMov )->cAlmDes           := ( dbfAlm )->cCodAlm
               ( dbfRemMov )->cCodDiv           := cDivEmp()
               ( dbfRemMov )->nVdvDiv           := nChgDiv()
               ( dbfRemMov )->nTotRem           := 0
               ( dbfRemMov )->( dbUnLock() )

               for each sStk in aStk

                  if !Empty( sStk:cCodigo )                          .and. ;
                     !Empty( sStk:nUnidades )                        .and. ;
                     ( sStk:cCodigoAlmacen == ( dbfAlm )->cCodAlm )  .and. ;
                     dbAppe( dbfHisMov )

                     ( dbfHisMov )->nNumRem  := nNumDoc
                     ( dbfHisMov )->cSufRem  := RetSufEmp()
                     ( dbfHisMov )->nNumLin  := nLastNum( dbfHisMov )
                     ( dbfHisMov )->dFecMov  := Date()
                     ( dbfHisMov )->nTipMov  := 4
                     ( dbfHisMov )->cCodMov  := "EI"
                     ( dbfHisMov )->cRefMov  := sStk:cCodigo
                     ( dbfHisMov )->cAliMov  := sStk:cCodigoAlmacen
                     ( dbfHisMov )->cValPr1  := sStk:cValorPropiedad1
                     ( dbfHisMov )->cValPr2  := sStk:cValorPropiedad2
                     ( dbfHisMov )->cLote    := sStk:cLote
                     ( dbfHisMov )->nUndMov  := sStk:nUnidades
                     if nCalcCosto <= 1
                        ( dbfHisMov )->nPreDiv  := RetFld( sStk:cCodigo, oldArt, "pCosto", "Codigo" )
                     else
                        ( dbfHisMov )->nPreDiv  := ::nPrecioMedioCompra( sStk:cCodigo, sStk:cCodigoAlmacen )
                     end if

                     ( dbfHisMov )->( dbUnLock() )

                  end if

                  sysrefresh()

               next

            end if

         end if

         ( dbfAlm )->( dbSkip() )

      end while

      CLOSE ( dbfHisMov  )
      CLOSE ( dbfRemMov  )
      CLOSE ( dbfAlm     )
      CLOSE ( dbfCnt     )

      CLOSE ( oldArt     )
      CLOSE ( oldHisMov  )
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

METHOD AppMovAlm( cRefMov, cValPr1, cValPr2, cCodAlm, nCajMov, nUndMov, dbfHisMov, lApp, cLote ) CLASS TStock

   local nTotMov

   DEFAULT lApp      := .t.
   DEFAULT cLote     := ""

   if !Empty( nCajMov )
      nTotMov        := NotCaja( nCajMov ) * nUndMov
   else
      nTotMov        := nUndMov
   end if

   if nTotMov == 0
      Return ( Self )
   end if

   if !lApp
      nTotMov        := - nTotMov
   end if

   if !( dbfHisMov )->( dbSeek( cRefMov + cValPr1 + cValPr2 + cCodAlm + cLote ) )

      if dbAppe( dbfHisMov )
         ( dbfHisMov )->dFecMov  := Date()
         ( dbfHisMov )->nTipMov  := 2
         ( dbfHisMov )->cCodMov  := "EI"
         ( dbfHisMov )->cAliMov  := cCodAlm
         ( dbfHisMov )->cRefMov  := cRefMov
         ( dbfHisMov )->cValPr1  := cValPr1
         ( dbfHisMov )->cValPr2  := cValPr2
         ( dbfHisMov )->cLote    := cLote
         ( dbfHisMov )->nUndMov  := nTotMov
         ( dbfHisMov )->( dbUnLock() )
      end if

   else

      if dbLock( dbfHisMov )
         ( dbfHisMov )->nUndMov  += nTotMov
         ( dbfHisMov )->( dbUnLock() )
      end if

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD nTotAlbPrv( cCodArt, cCodAlm, cValPr1, cValPr2, cLote, dFecha ) CLASS TStock

   local nOrd
   local nTotal
   local cCodEmp
   local cAlbEmpT
   local cAlbEmpL

   DEFAULT cValPr1   := Space( 10 )
   DEFAULT cValPr2   := Space( 10 )
   DEFAULT cLote     := Space( 12 )

   nTotal            := 0

   if Len( aEmpGrp() ) != 0

      for each cCodEmp in aEmpGrp()

         if cCodEmp == cCodEmp()

            nOrd     := ( ::cAlbPrvL )->( OrdSetFocus( "cRef" ) )
            if ( ::cAlbPrvL )->( dbSeek( cCodArt ) )

               while ( ::cAlbPrvL )->cRef == cCodArt .and. !( ::cAlbPrvL )->( Eof() )

                  if ( ::cAlbPrvT )->( dbSeek( ( ::cAlbPrvL )->cSerAlb + Str( ( ::cAlbPrvL )->nNumAlb ) + ( ::cAlbPrvL )->cSufAlb ) )  .and.;
                     ( Empty( dFecha ) .or. ( ::cAlbPrvT )->dFecAlb <= dFecha )                                                        .and.;
                     !( ::cAlbPrvT )->lFacturado

                     if ( cCodAlm == ( ::cAlbPrvL )->cAlmLin )     .and.;
                        ( cValPr1 == ( ::cAlbPrvL )->cValPr1 )     .and.;
                        ( cValPr2 == ( ::cAlbPrvL )->cValPr2 )     .and.;
                        ( cLote   == ( ::cAlbPrvL )->cLote   )

                        nTotal += nTotNAlbPrv( ::cAlbPrvL )

                     end if


                  end if

                  ( ::cAlbPrvL )->( dbSkip() )

               end while

            end if
            ( ::cAlbPrvL )->( OrdSetFocus( nOrd ) )

         else

            USE ( cPatStk( cCodEmp ) + "ALBPROVT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBPROVT", @cAlbEmpT ) )
            SET ADSINDEX TO ( cPatStk( cCodEmp ) + "ALBPROVT.CDX" ) ADDITIVE

            USE ( cPatStk( cCodEmp ) + "ALBPROVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBPROVL", @cAlbEmpL ) )
            SET ADSINDEX TO ( cPatStk( cCodEmp ) + "ALBPROVL.CDX" ) ADDITIVE
            ( cAlbEmpL )->( ordSetFocus( "cRef" ) )

            if ( cAlbEmpL )->( dbSeek( cCodArt ) )

               while ( cAlbEmpL )->cRef == cCodArt .and. !( cAlbEmpL )->( Eof() )

                  if ( cAlbEmpT )->( dbSeek( ( cAlbEmpL )->cSerAlb + Str( ( cAlbEmpL )->nNumAlb ) + ( cAlbEmpL )->cSufAlb ) )  .and.;
                     ( Empty( dFecha ) .or. ( cAlbEmpT )->dFecAlb <= dFecha )                                                  .and.;
                     !( cAlbEmpT )->lFacturado

                     if ( cCodAlm == ( cAlbEmpL )->cAlmLin )     .and.;
                        ( cValPr1 == ( cAlbEmpL )->cValPr1 )     .and.;
                        ( cValPr2 == ( cAlbEmpL )->cValPr2 )     .and.;
                        ( cLote   == ( cAlbEmpL )->cLote   )

                        nTotal += nTotNAlbPrv( cAlbEmpL )

                     end if


                  end if

                  ( cAlbEmpL )->( dbSkip() )

               end while

            end if

            CLOSE( cAlbEmpT )
            CLOSE( cAlbEmpL )

         end if

      next

   end if

RETURN ( nTotal )

//---------------------------------------------------------------------------//

METHOD nTotFacPrv( cCodArt, cCodAlm, cValPr1, cValPr2, cLote, dFecha ) CLASS TStock

   local nOrd
   local nTotal
   local cCodEmp
   local cFacEmpT
   local cFacEmpL

   DEFAULT cValPr1   := Space( 10 )
   DEFAULT cValPr2   := Space( 10 )
   DEFAULT cLote     := Space( 12 )

   nTotal            := 0

   if Len( aEmpGrp() ) != 0

      for each cCodEmp in aEmpGrp()

         if cCodEmp == cCodEmp()

            nOrd     := ( ::cFacPrvL )->( ordSetFocus( "cRef" ) )
            if ( ::cFacPrvL )->( dbSeek( cCodArt ) )

               while ( ::cFacPrvL )->cRef == cCodArt .and. !( ::cFacPrvL )->( Eof() )

                  if ( ::cFacPrvT )->( dbSeek( ( ::cFacPrvL )->cSerFac + Str( ( ::cFacPrvL )->nNumFac ) + ( ::cFacPrvL )->cSufFac ) )  .and.;
                     ( Empty( dFecha ) .or. ( ::cFacPrvT )->dFecFac <= dFecha )

                     if ( cCodAlm == ( ::cFacPrvL )->cAlmLin )     .and.;
                        ( cValPr1 == ( ::cFacPrvL )->cValPr1 )     .and.;
                        ( cValPr2 == ( ::cFacPrvL )->cValPr2 )     .and.;
                        ( cLote   == ( ::cFacPrvL )->cLote   )

                        nTotal += nTotNFacPrv( ::cFacPrvL )

                     end if

                  end if

               ( ::cFacPrvL )->( dbSkip() )

               end while

            end if
            ( ::cFacPrvL )->( ordSetFocus( nOrd ) )

         else

            USE ( cPatStk( cCodEmp ) + "FACPRVT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVT", @cFacEmpT ) )
            SET ADSINDEX TO ( cPatStk( cCodEmp ) + "FACPRVT.CDX" ) ADDITIVE

            USE ( cPatStk( cCodEmp ) + "FACPRVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVL", @cFacEmpL ) )
            SET ADSINDEX TO ( cPatStk( cCodEmp ) + "FACPRVL.CDX" ) ADDITIVE
            ( cFacEmpL )->( ordSetFocus( "cRef" ) )

            if ( cFacEmpL )->( dbSeek( cCodArt ) )

               while ( cFacEmpL )->cRef == cCodArt .and. !( cFacEmpL )->( Eof() )

                  if ( cFacEmpT )->( dbSeek( ( cFacEmpL )->cSerFac + Str( ( cFacEmpL )->nNumFac ) + ( cFacEmpL )->cSufFac ) )  .and.;
                     ( Empty( dFecha ) .or. ( cFacEmpT )->dFecFac <= dFecha )

                     if ( cCodAlm == ( cFacEmpL )->cAlmLin )     .and.;
                        ( cValPr1 == ( cFacEmpL )->cValPr1 )     .and.;
                        ( cValPr2 == ( cFacEmpL )->cValPr2 )     .and.;
                        ( cLote   == ( cFacEmpL )->cLote   )

                        nTotal += nTotNFacPrv( cFacEmpL )

                     end if

                  end if

               ( cFacEmpL )->( dbSkip() )

               end while

            end if

            CLOSE( cFacEmpT )
            CLOSE( cFacEmpL )

         end if

      next

   end if

RETURN ( nTotal )

//---------------------------------------------------------------------------//

METHOD nTotRctPrv( cCodArt, cCodAlm, cValPr1, cValPr2, cLote, dFecha ) CLASS TStock

   local nOrd
   local nTotal
   local cCodEmp
   local cFacEmpT
   local cFacEmpL

   DEFAULT cValPr1   := Space( 10 )
   DEFAULT cValPr2   := Space( 10 )
   DEFAULT cLote     := Space( 12 )

   nTotal            := 0

   if Len( aEmpGrp() ) != 0

      for each cCodEmp in aEmpGrp()

         if cCodEmp == cCodEmp()

            nOrd     := ( ::cRctPrvL )->( ordSetFocus( "cRef" ) )
            if ( ::cRctPrvL )->( dbSeek( cCodArt ) )

               while ( ::cRctPrvL )->cRef == cCodArt .and. !( ::cRctPrvL )->( Eof() )

                  if ( ::cRctPrvT )->( dbSeek( ( ::cRctPrvL )->cSerFac + Str( ( ::cRctPrvL )->nNumFac ) + ( ::cRctPrvL )->cSufFac ) )  .and.;
                     ( Empty( dFecha ) .or. ( ::cRctPrvT )->dFecFac <= dFecha )

                     if ( cCodAlm == ( ::cRctPrvL )->cAlmLin )     .and.;
                        ( cValPr1 == ( ::cRctPrvL )->cValPr1 )     .and.;
                        ( cValPr2 == ( ::cRctPrvL )->cValPr2 )     .and.;
                        ( cLote   == ( ::cRctPrvL )->cLote   )

                        nTotal += nTotNRctPrv( ::cRctPrvL )

                     end if

                  end if

               ( ::cRctPrvL )->( dbSkip() )

               end while

            end if

            ( ::cRctPrvL )->( ordSetFocus( nOrd ) )

         else

            USE ( cPatStk( cCodEmp ) + "RctPrvT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "RctPrvT", @cFacEmpT ) )
            SET ADSINDEX TO ( cPatStk( cCodEmp ) + "RctPrvT.CDX" ) ADDITIVE

            USE ( cPatStk( cCodEmp ) + "RctPrvL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "RctPrvL", @cFacEmpL ) )
            SET ADSINDEX TO ( cPatStk( cCodEmp ) + "RctPrvL.CDX" ) ADDITIVE
            ( cFacEmpL )->( ordSetFocus( "cRef" ) )

            if ( cFacEmpL )->( dbSeek( cCodArt ) )

               while ( cFacEmpL )->cRef == cCodArt .and. !( cFacEmpL )->( Eof() )

                  if ( cFacEmpT )->( dbSeek( ( cFacEmpL )->cSerFac + Str( ( cFacEmpL )->nNumFac ) + ( cFacEmpL )->cSufFac ) )  .and.;
                     ( Empty( dFecha ) .or. ( cFacEmpT )->dFecFac <= dFecha )

                     if ( cCodAlm == ( cFacEmpL )->cAlmLin )     .and.;
                        ( cValPr1 == ( cFacEmpL )->cValPr1 )     .and.;
                        ( cValPr2 == ( cFacEmpL )->cValPr2 )     .and.;
                        ( cLote   == ( cFacEmpL )->cLote   )

                        nTotal += nTotNRctPrv( cFacEmpL )

                     end if

                  end if

               ( cFacEmpL )->( dbSkip() )

               end while

            end if

            CLOSE( cFacEmpT )
            CLOSE( cFacEmpL )

         end if

      next

   end if

RETURN ( nTotal )

//---------------------------------------------------------------------------//

METHOD nTotAlbCli( cCodArt, cCodAlm, cValPr1, cValPr2, cLote, dFecha ) CLASS TStock

   local nOrd
   local nTotal      := 0
   local cAlbEmpT
   local cAlbEmpL
   local cCodEmp

   DEFAULT cValPr1   := Space( 10 )
   DEFAULT cValPr2   := Space( 10 )
   DEFAULT cLote     := Space( 12 )

   if Len( aEmpGrp() ) != 0

      for each cCodEmp in aEmpGrp()

         if cCodEmp == cCodEmp()

            nOrd     := ( ::cAlbCliL )->( ordSetFocus( "cRef" ) )
            if ( ::cAlbCliL )->( dbSeek( cCodArt ) )

               while ( ::cAlbCliL )->cRef == cCodArt .and. !( ::cAlbCliL )->( Eof() )

                  if ( ::cAlbCliT )->( dbSeek( ( ::cAlbCliL )->cSerAlb + Str( ( ::cAlbCliL )->nNumAlb ) + ( ::cAlbCliL )->cSufAlb ) )  .and.;
                     ( Empty( dFecha ) .or. ( ::cAlbCliT )->dFecAlb <= dFecha )                                                        .and.;
                     !( ::cAlbCliT )->lFacturado

                     if ( cCodAlm == ( ::cAlbCliL )->cAlmLin )     .and.;
                        ( cValPr1 == ( ::cAlbCliL )->cValPr1 )     .and.;
                        ( cValPr2 == ( ::cAlbCliL )->cValPr2 )     .and.;
                        ( cLote   == ( ::cAlbCliL )->cLote   )

                        nTotal += nTotNAlbCli( ::cAlbCliL )

                     end if

                  end if

                  ( ::cAlbCliL )->( dbSkip() )

               end while

            end if
            ( ::cAlbCliL )->( ordSetFocus( nOrd ) )

         else

            USE ( cPatStk( cCodEmp ) + "ALBCLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIT", @cAlbEmpT ) )
            SET ADSINDEX TO ( cPatStk( cCodEmp ) + "ALBCLIT.CDX" ) ADDITIVE

            USE ( cPatStk( cCodEmp ) + "ALBCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIL", @cAlbEmpL ) )
            SET ADSINDEX TO ( cPatStk( cCodEmp ) + "ALBCLIL.CDX" ) ADDITIVE
            ( cAlbEmpL )->( ordSetFocus( "cRef" ) )

            if ( cAlbEmpL )->( dbSeek( cCodArt ) )

               while ( cAlbEmpL )->cRef == cCodArt .and. !( cAlbEmpL )->( Eof() )

                  if ( cAlbEmpT )->( dbSeek( ( cAlbEmpL )->cSerAlb + Str( ( cAlbEmpL )->nNumAlb ) + ( cAlbEmpL )->cSufAlb ) )  .and.;
                     ( Empty( dFecha ) .or. ( cAlbEmpT )->dFecAlb <= dFecha )                                                        .and.;
                     !( cAlbEmpT )->lFacturado

                     if ( cCodAlm == ( cAlbEmpL )->cAlmLin )     .and.;
                        ( cValPr1 == ( cAlbEmpL )->cValPr1 )     .and.;
                        ( cValPr2 == ( cAlbEmpL )->cValPr2 )     .and.;
                        ( cLote   == ( cAlbEmpL )->cLote   )

                        nTotal += nTotNAlbCli( cAlbEmpL )

                     end if

                  end if

                  ( cAlbEmpL )->( dbSkip() )

               end while

            end if

            CLOSE( cAlbEmpT )
            CLOSE( cAlbEmpL )

         end if

      next

   end if

RETURN ( nTotal )

//---------------------------------------------------------------------------//

METHOD nTotFacCli( cCodArt, cCodAlm, cValPr1, cValPr2, cLote, dFecha ) CLASS TStock

   local nOrd
   local nTotal      := 0
   local cCodEmp
   local cFacEmpT
   local cFacEmpL

   DEFAULT cValPr1   := Space( 10 )
   DEFAULT cValPr2   := Space( 10 )
   DEFAULT cLote     := Space( 12 )

   if Len( aEmpGrp() ) != 0

      for each cCodEmp in aEmpGrp()

         if cCodEmp == cCodEmp()

            nOrd     := ( ::cFacCliL )->( ordSetFocus( "cRef" ) )

            if ( ::cFacCliL )->( dbSeek( cCodArt ) )

               while ( ::cFacCliL )->cRef == cCodArt .and. !( ::cFacCliL )->( Eof() )

                  if ( ::cFacCliT )->( dbSeek( ( ::cFacCliL )->cSerie + Str( ( ::cFacCliL )->nNumFac ) + ( ::cFacCliL )->cSufFac ) )   .and.;
                     ( Empty( dFecha ) .or. ( ::cFacCliT )->dFecFac <= dFecha )

                     if ( cCodAlm == ( ::cFacCliL )->cAlmLin )   .and.;
                        ( cValPr1 == ( ::cFacCliL )->cValPr1 )   .and.;
                        ( cValPr2 == ( ::cFacCliL )->cValPr2 )   .and.;
                        ( cLote   == ( ::cFacCliL )->cLote   )

                        nTotal += nTotNFacCli( ::cFacCliL )

                     end if

                  end if

                  ( ::cFacCliL )->( dbSkip() )

               end while

            end if

            ( ::cFacCliL )->( ordSetFocus( nOrd ) )

         else

            USE ( cPatStk( cCodEmp ) + "FACCLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIT", @cFacEmpT ) )
            SET ADSINDEX TO ( cPatStk( cCodEmp ) + "FACCLIT.CDX" ) ADDITIVE

            USE ( cPatStk( cCodEmp ) + "FACCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIL", @cFacEmpL ) )
            SET ADSINDEX TO ( cPatStk( cCodEmp ) + "FACCLIL.CDX" ) ADDITIVE
            ( cFacEmpL )->( ordSetFocus( "cRef" ) )

            if ( cFacEmpL )->( dbSeek( cCodArt ) )

               while ( cFacEmpL )->cRef == cCodArt .and. !( cFacEmpL )->( Eof() )

                  if ( cFacEmpT )->( dbSeek( ( cFacEmpL )->cSerie + Str( ( cFacEmpL )->nNumFac ) + ( cFacEmpL )->cSufFac ) )   .and.;
                     ( Empty( dFecha ) .or. ( cFacEmpT )->dFecFac <= dFecha )

                     if ( cCodAlm == ( cFacEmpL )->cAlmLin )   .and.;
                        ( cValPr1 == ( cFacEmpL )->cValPr1 )   .and.;
                        ( cValPr2 == ( cFacEmpL )->cValPr2 )   .and.;
                        ( cLote   == ( cFacEmpL )->cLote   )

                        nTotal += nTotNFacCli( cFacEmpL )

                     end if

                  end if

                  ( cFacEmpL )->( dbSkip() )

               end while

            end if

            CLOSE( cFacEmpT )
            CLOSE( cFacEmpL )

         end if

      next

   end if

RETURN ( nTotal )

//---------------------------------------------------------------------------//

METHOD nTotFacRec( cCodArt, cCodAlm, cValPr1, cValPr2, cLote, dFecha ) CLASS TStock

   local nOrd
   local nTotal      := 0
   local cCodEmp
   local cFacRecEmpT
   local cFacRecEmpL

   DEFAULT cValPr1   := Space( 10 )
   DEFAULT cValPr2   := Space( 10 )
   DEFAULT cLote     := Space( 12 )

   if Len( aEmpGrp() ) != 0

      for each cCodEmp in aEmpGrp()

         if cCodEmp == cCodEmp()

            nOrd     := ( ::cFacRecL )->( ordSetFocus( "cRef" ) )
            if ( ::cFacRecL )->( dbSeek( cCodArt ) )

               while ( ::cFacRecL )->cRef == cCodArt .and. !( ::cFacCliL )->( Eof() )

                  if ( ::cFacRecT )->( dbSeek( ( ::cFacRecL )->cSerie + Str( ( ::cFacRecL )->nNumFac ) + ( ::cFacRecL )->cSufFac ) )   .and.;
                     ( Empty( dFecha ) .or. ( ::cFacRecT )->dFecFac <= dFecha )

                     if ( cCodAlm == ( ::cFacRecL )->cAlmLin )   .and.;
                        ( cValPr1 == ( ::cFacRecL )->cValPr1 )   .and.;
                        ( cValPr2 == ( ::cFacRecL )->cValPr2 )   .and.;
                        ( cLote   == ( ::cFacRecL )->cLote   )

                         nTotal += nTotNFacRec( ::cFacRecL )

                     end if

                  end if

                  ( ::cFacRecL )->( dbSkip() )

               end while

            end if

            ( ::cFacRecL )->( ordSetFocus( nOrd ) )

         else

            USE ( cPatStk( cCodEmp ) + "FACRECT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACRECT", @cFacRecEmpT ) )
            SET ADSINDEX TO ( cPatStk( cCodEmp ) + "FACRECT.CDX" ) ADDITIVE

            USE ( cPatStk( cCodEmp ) + "FACRECL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACRECL", @cFacRecEmpL ) )
            SET ADSINDEX TO ( cPatStk( cCodEmp ) + "FACRECL.CDX" ) ADDITIVE
            ( cFacRecEmpL )->( ordSetFocus( "cRef" ) )

            if ( cFacRecEmpL )->( dbSeek( cCodArt ) )

               while ( cFacRecEmpL )->cRef == cCodArt .and. !( cFacRecEmpL )->( Eof() )

                  if ( cFacRecEmpT )->( dbSeek( ( cFacRecEmpL )->cSerie + Str( ( cFacRecEmpL )->nNumFac ) + ( cFacRecEmpL )->cSufFac ) )   .and.;
                     ( Empty( dFecha ) .or. ( cFacRecEmpT )->dFecFac <= dFecha )

                     if ( cCodAlm == ( cFacRecEmpL )->cAlmLin )   .and.;
                        ( cValPr1 == ( cFacRecEmpL )->cValPr1 )   .and.;
                        ( cValPr2 == ( cFacRecEmpL )->cValPr2 )   .and.;
                        ( cLote   == ( cFacRecEmpL )->cLote   )

                         nTotal += nTotNFacRec( cFacRecEmpL )

                     end if

                  end if

                  ( cFacRecEmpL )->( dbSkip() )

               end while

            end if

            CLOSE( cFacRecEmpT )
            CLOSE( cFacRecEmpL )

         end if

      next

   end if

RETURN ( nTotal )

//---------------------------------------------------------------------------//

METHOD nTotTikCli( cCodArt, cCodAlm, cValPr1, cValPr2, cLote, dFecha ) CLASS TStock

   local nOrd
   local cCodEmp
   local cTikEmpT
   local cTikEmpL
   local nTotal      := 0

   DEFAULT cValPr1   := Space( 10 )
   DEFAULT cValPr2   := Space( 10 )
   DEFAULT cLote     := Space( 12 )

   if Len( aEmpGrp() ) != 0

      for each cCodEmp in aEmpGrp()

         if cCodEmp == cCodEmp()

            nOrd     := ( ::cTikL )->( OrdSetFocus( "cCbaTil" ) )

            if ( ::cTikL )->( dbSeek( cCodArt ) )

               while ( ::cTikL )->cCbaTil == cCodArt .and. !( ::cTikL )->( Eof() )

                  if ( ::cTikT )->( dbSeek( ( ::cTikL )->cSerTil + ( ::cTikL )->cNumTil + ( ::cTikL )->cSufTil ) )   .and.;
                     ( Empty( dFecha ) .or. ( ::cTikT )->dFecTik <= dFecha )

                     if ( cCodAlm == ( ::cTikL )->cAlmLin )   .and.;
                        ( cValPr1 == ( ::cTikL )->cValPr1 )   .and.;
                        ( cValPr2 == ( ::cTikL )->cValPr2 )   .and.;
                        ( cLote   == ( ::cTikL )->cLote   )

                        nTotal += ( ::cTikL )->nUntTil

                     end if

                  end if

                  ( ::cTikL )->( dbSkip() )

               end while

            end if

            ( ::cTikL )->( OrdSetFocus( "cComTil" ) )

            if ( ::cTikL )->( dbSeek( cCodArt ) )

               while ( ::cTikL )->cComTil == cCodArt .and. !( ::cTikL )->( Eof() )

                  if ( ::cTikT )->( dbSeek( ( ::cTikL )->cSerTil + ( ::cTikL )->cNumTil + ( ::cTikL )->cSufTil ) )

                     if ( cCodAlm == ( ::cTikL )->cAlmLin )   .and.;
                        ( cValPr1 == ( ::cTikL )->cValPr1 )   .and.;
                        ( cValPr2 == ( ::cTikL )->cValPr2 )   .and.;
                        ( cLote   == ( ::cTikL )->cLote   )

                        nTotal += ( ::cTikL )->nUntTil

                     end if

                  end if

                  ( ::cTikL )->( dbSkip() )

               end while

            end if

            ( ::cTikL )->( OrdSetFocus( nOrd ) )

         else

            USE ( cPatStk( cCodEmp ) + "TIKET.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKET", @cTikEmpT ) )
            SET ADSINDEX TO ( cPatStk( cCodEmp ) + "TIKET.CDX" ) ADDITIVE

            USE ( cPatStk( cCodEmp ) + "TIKEL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKEL", @cTikEmpL ) )
            SET ADSINDEX TO ( cPatStk( cCodEmp ) + "TIKEL.CDX" ) ADDITIVE
            ( cTikEmpL )->( ordSetFocus( "cCbaTil" ) )

            if ( cTikEmpL )->( dbSeek( cCodArt ) )
               while ( cTikEmpL )->cCbaTil == cCodArt .and. !( cTikEmpL )->( Eof() )

                  if ( cTikEmpT )->( dbSeek( ( cTikEmpL )->cSerTil + ( cTikEmpL )->cNumTil + ( cTikEmpL )->cSufTil ) )   .and.;
                     ( Empty( dFecha ) .or. ( cTikEmpT )->dFecTik <= dFecha )

                     if ( cCodAlm == ( cTikEmpL )->cAlmLin )   .and.;
                        ( cValPr1 == ( cTikEmpL )->cValPr1 )   .and.;
                        ( cValPr2 == ( cTikEmpL )->cValPr2 )   .and.;
                        ( cLote   == ( cTikEmpL )->cLote   )

                        nTotal += ( cTikEmpL )->nUntTil

                     end if

                  end if

                  ( cTikEmpL )->( dbSkip() )

               end while

            end if

            ( cTikEmpL )->( OrdSetFocus( "cComTil" ) )

            if ( cTikEmpL )->( dbSeek( cCodArt ) )

               while ( cTikEmpL )->cComTil == cCodArt .and. !( cTikEmpL )->( Eof() )

                  if ( cTikEmpT )->( dbSeek( ( cTikEmpL )->cSerTil + ( cTikEmpL )->cNumTil + ( cTikEmpL )->cSufTil ) )

                     if ( cCodAlm == ( cTikEmpL )->cAlmLin )   .and.;
                        ( cValPr1 == ( cTikEmpL )->cValPr1 )   .and.;
                        ( cValPr2 == ( cTikEmpL )->cValPr2 )   .and.;
                        ( cLote   == ( cTikEmpL )->cLote   )

                        nTotal += ( cTikEmpL )->nUntTil

                     end if

                  end if

                  ( cTikEmpL )->( dbSkip() )

               end while

            end if

            ( cTikEmpL )->( OrdSetFocus( "cCbaTil" ) )

            CLOSE( cTikEmpT )
            CLOSE( cTikEmpL )

         end if

      next

   end if

RETURN ( nTotal )

//---------------------------------------------------------------------------//

METHOD nTotMovAlm( cCodArt, cCodAlm, cValPr1, cValPr2, cLote, dFecha ) CLASS TStock

   local nOrd
   local nTotal      := 0

   DEFAULT cValPr1   := Space( 10 )
   DEFAULT cValPr2   := Space( 10 )
   DEFAULT cLote     := Space( 12 )

   nOrd              := ( ::cHisMovT)->( OrdSetFocus( "cRefMov" ) )
   if ( ::cHisMovT)->( dbSeek( cCodArt ) )

      while ( ::cHisMovT)->cRefMov == cCodArt .and. !( ::cHisMovT)->( Eof() )

         if ( Empty( dFecha ) .or. ( ::cHisMovT)->dFecMov <= dFecha )   .and.;
            ( cValPr1 == ( ::cHisMovT)->cValPr1 )                       .and.;
            ( cValPr2 == ( ::cHisMovT)->cValPr2 )                       .and.;
            ( cLote   == ( ::cHisMovT)->cLote   )

            if !( ::cHisMovT)->lNoStk

               if ( ::cHisMovT)->cAliMov == cCodAlm
                  nTotal   += nTotNMovAlm( ::cHisMovT)
               end if

               if ( ::cHisMovT)->cAloMov == cCodAlm
                  nTotal   -= nTotNMovAlm( ::cHisMovT)
               end if

            end if

         end if

         ( ::cHisMovT)->( dbSkip() )

      end while

   end if

   ( ::cHisMovT)->( OrdSetFocus( nOrd ) )

RETURN ( nTotal )

//---------------------------------------------------------------------------//

METHOD nStockActualCalculado( cCodArt, cCodAlm, cValPr1, cValPr2, cLote, dFecha ) CLASS TStock

   local nStkTotal   := 0

   nStkTotal         += ::nTotAlbPrv( cCodArt, cCodAlm, cValPr1, cValPr2, cLote, dFecha )

   nStkTotal         += ::nTotFacPrv( cCodArt, cCodAlm, cValPr1, cValPr2, cLote, dFecha )
   nStkTotal         += ::nTotRctPrv( cCodArt, cCodAlm, cValPr1, cValPr2, cLote, dFecha )

   nStkTotal         -= ::nTotAlbCli( cCodArt, cCodAlm, cValPr1, cValPr2, cLote, dFecha )
   nStkTotal         -= ::nTotFacCli( cCodArt, cCodAlm, cValPr1, cValPr2, cLote, dFecha )
   nStkTotal         -= ::nTotFacRec( cCodArt, cCodAlm, cValPr1, cValPr2, cLote, dFecha )
   nStkTotal         -= ::nTotTikCli( cCodArt, cCodAlm, cValPr1, cValPr2, cLote, dFecha )

   nStkTotal         += ::nTotMovAlm( cCodArt, cCodAlm, cValPr1, cValPr2, cLote, dFecha )

RETURN ( nStkTotal )

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
   nOrdLin        := ( ::cAlbCliL )->( OrdSetFocus( "cRef" ) )

   if ( ::cAlbCliL )->( dbSeek( cCodArt ) )

      while ( ::cAlbCliL )->cRef == cCodArt .and. !( ::cAlbCliL )->( Eof() )

         if dbSeekInOrd( ( ::cAlbCliL )->cSerAlb + Str( ( ::cAlbCliL )->nNumAlb ) + ( ::cAlbCliL )->cSufAlb, "nNumAlb", ::cAlbCliT )  .and.;
            ( ::cAlbCliT )->cCodCli == cCodCli .and.;
            ( ::cAlbCliT )->dFecAlb <= dFecha .and.;
            !( ::cAlbCliT )->lFacturado

            nTotal   += nTotNAlbCli( ::cAlbCliL )

         end if

         ( ::cAlbCliL )->( dbSkip() )

      end if

   end if

   ( ::cAlbCliL )->( OrdSetFocus( nOrdLin ) )
   ( ::cAlbCliL )->( dbGoTo( nRecLin ) )
   ( ::cAlbCliT )->( dbGoTo( nRecCab ) )

   /*
   Facturas de clientes--------------------------------------------------------
   */

   nRecCab        := ( ::cFacCliT )->( RecNo() )
   nRecLin        := ( ::cFacCliL )->( Recno() )
   nOrdLin        := ( ::cFacCliL )->( OrdSetFocus( "cRef" ) )

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

   ( ::cFacCliL )->( OrdSetFocus( nOrdLin ) )
   ( ::cFacCliL )->( dbGoTo( nRecLin ) )
   ( ::cFacCliT )->( dbGoTo( nRecCab ) )

   /*
   Facturas rectificativas de clientes-----------------------------------------
   */

   nRecCab        := ( ::cFacRecT )->( RecNo() )
   nRecLin        := ( ::cFacRecL )->( Recno() )
   nOrdLin        := ( ::cFacRecL )->( OrdSetFocus( "cRef" ) )

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

   ( ::cFacRecL )->( OrdSetFocus( nOrdLin ) )
   ( ::cFacRecL )->( dbGoTo( nRecLin ) )
   ( ::cFacRecT )->( dbGoTo( nRecCab ) )

   /*
   Ticktes de clientes---------------------------------------------------------
   */

   nRecCab        := ( ::cTikT )->( RecNo() )
   nRecLin        := ( ::cTikL )->( Recno() )
   nOrdLin        := ( ::cTikL )->( OrdSetFocus( "CCBATIL" ) )

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

   ( ::cTikL )->( OrdSetFocus( nOrdLin ) )
   ( ::cTikL )->( dbGoTo( nRecLin ) )
   ( ::cTikT )->( dbGoTo( nRecCab ) )

   /*
   Tickets Combinados----------------------------------------------------------
   */

   nRecCab        := ( ::cTikT )->( RecNo() )
   nRecLin        := ( ::cTikL )->( Recno() )
   nOrdLin        := ( ::cTikL )->( OrdSetFocus( "CCOMTIL" ) )

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

   ( ::cTikL )->( OrdSetFocus( nOrdLin ) )
   ( ::cTikL )->( dbGoTo( nRecLin ) )
   ( ::cTikT )->( dbGoTo( nRecCab ) )

RETURN ( nTotal)

//---------------------------------------------------------------------------//

METHOD nSaldoDocumento( cCodArt, cNumDoc ) CLASS TStock

   local nTotal   := 0
   local nRecLin  := ( ::cFacCliL )->( Recno() )
   local nOrdAnt  := ( ::cFacCliL )->( OrdSetFocus( "nNumFac" ) )

   if ( ::cFacCliL )->( dbSeek( cNumDoc ) )

      while ( ::cFacCliL )->cSerie + Str( ( ::cFacCliL )->nNumFac ) + ( ::cFacCliL )->cSufFac == cNumDoc .and. !( ::cFacCliL )->( Eof())

         if ( ::cFacCliL )->cRef == cCodArt

            nTotal   += nTotNFacCli( ::cFacCliL )

         end if

         ( ::cFacCliL )->( dbSkip() )

      end while

   end if

   ( ::cFacCliL )->( OrdSetFocus( nOrdAnt ) )
   ( ::cFacCliL )->( dbGoTo( nRecLin ) )

RETURN ( nTotal )

//---------------------------------------------------------------------------//

METHOD nSaldoAnterior( cCodArt, cNumDoc ) CLASS TStock

   local cCodCli
   local dFecha
   local nRec     := ( ::cFacCliT )->( Recno() )
   local nOrdAnt  := ( ::cFacCliT )->( OrdSetFocus( "NNUMFAC" ) )

   if ( ::cFacCliT )->( dbSeek( cNumDoc ) )
      cCodCli     := ( ::cFacCliT )->cCodCli
      dFecha      := ( ::cFacCliT )->dFecFac
   end if

   ( ::cFacCliT )->( OrdSetFocus( nOrdAnt ) )
   ( ::cFacCliT )->( dbGoTo( nRec ) )

RETURN ( ::nTotalSaldo( cCodArt, cCodCli, dFecha ) - ::nSaldoDocumento( cCodArt, cNumDoc ) )

//---------------------------------------------------------------------------//

METHOD nSaldoDocAlb( cCodArt, cNumDoc ) CLASS TStock

   local nTotal   := 0
   local nRecLin  := ( ::cAlbCliL )->( Recno() )
   local nOrdAnt  := ( ::cAlbCliL )->( OrdSetFocus( "nNumAlb" ) )

   if ( ::cAlbCliL )->( dbSeek( cNumDoc ) )

      while ( ::cAlbCliL )->cSerAlb + Str( ( ::cAlbCliL )->nNumAlb ) + ( ::cAlbCliL )->cSufAlb == cNumDoc .and. !( ::cAlbCliL )->( Eof())

         if ( ::cAlbCliL )->cRef == cCodArt

            nTotal   += nTotNAlbCli( ::cAlbCliL )

         end if

         ( ::cAlbCliL )->( dbSkip() )

      end while

   end if

   ( ::cAlbCliL )->( OrdSetFocus( nOrdAnt ) )
   ( ::cAlbCliL )->( dbGoTo( nRecLin ) )

RETURN ( nTotal )

//---------------------------------------------------------------------------//

METHOD nSaldoAntAlb( cCodArt, cNumDoc ) CLASS TStock

   local cCodCli
   local dFecha
   local nRec     := ( ::cAlbCliT )->( Recno() )
   local nOrdAnt  := ( ::cAlbCliT )->( OrdSetFocus( "NNUMALB" ) )

   if ( ::cAlbCliT )->( dbSeek( cNumDoc ) )
      cCodCli     := ( ::cAlbCliT )->cCodCli
      dFecha      := ( ::cAlbCliT )->dFecAlb
   end if

   ( ::cAlbCliT )->( OrdSetFocus( nOrdAnt ) )
   ( ::cAlbCliT )->( dbGoTo( nRec ) )

RETURN ( ::nTotalSaldo( cCodArt, cCodCli, dFecha ) - ::nSaldoDocAlb( cCodArt, cNumDoc ) )

//---------------------------------------------------------------------------//

METHOD nPrecioMedioCompra( cCodArt, cCodAlm, dFecIni, dFecFin, lSerie, lExcCero, lExcImp, aSer, oMtr ) CLASS TStock

   local nPreMed        := 0
   local aMovimientos   := {}
   local nSalAnt        := 0
   local nImpAnt        := 0
   local aMov           := {}
   local nOrdAlbPrvL    := ( ::cAlbPrvL )->( OrdSetFocus( "cStkFast") )
   local nOrdFacPrvL    := ( ::cFacPrvL )->( OrdSetFocus( "cRef"    ) )
   local nOrdRctPrvL    := ( ::cRctPrvL )->( OrdSetFocus( "cRef"    ) )
   local cHisMovT       := ( ::cHisMovT )->( OrdSetFocus( "cRefMov" ) )

   DEFAULT lExcCero     := .f.
   DEFAULT lExcImp      := .f.
   DEFAULT lSerie       := .f.

   if oMtr != nil
      oMtr:SetTotal( 8 )
   end if

   // Recorremos Albaranes de proveedores--------------------------------------

   if ( ::cAlbPrvL )->( dbSeek( cCodArt ) )

      while ( ::cAlbPrvL )->cRef == cCodArt .and. !( ::cAlbPrvL )->( eof() )

         if ( Empty( cCodAlm ) .or. ( ( ::cAlbPrvL )->cAlmLin == cCodAlm ) )           .and.;
            !( lExcCero .and. nTotNAlbPrv( ::cAlbPrvL ) == 0 )                         .and.;
            !( lExcImp .and. nTotLAlbPrv( ::cAlbPrvL, ::nDecIn, ::nDerIn ) == 0 )      .and.;
            ( Empty( dFecIni ) .or. ( ::cAlbPrvL )->dFecAlb >= dFecIni )               .and.;
            ( Empty( dFecFin ) .or. ( ::cAlbPrvL )->dFecAlb <= dFecFin )               .and.;
            ( !lSerie .or. lChkSer( ( ::cAlbPrvL )->cSerAlb, aSer ) )

            aAdd( aMovimientos, STemporal():New( ( ::cAlbPrvL )->dFecAlb, nil, nTotNAlbPrv( ::cAlbPrvL ), 0, nTotLAlbPrv( ::cAlbPrvL, ::nDecIn, ::nDerIn ), "alb prv", ( ::cAlbPrvL )->cSerAlb + Str( ( ::cAlbPrvL )->nNumAlb ) + ( ::cAlbPrvL )->cSufAlb ) )

         end if

         ( ::cAlbPrvL )->( dbSkip() )

      end while

   end if

   if oMtr != nil
      oMtr:AutoInc()
   end if

   // Recorremos Facturas de proveedores---------------------------------------

   if ( ::cFacPrvL )->( dbSeek( cCodArt ) )

      while ( ::cFacPrvL )->cRef == cCodArt .and. !( ::cFacPrvL )->( eof() )

         if ( Empty( cCodAlm ) .or. ( ( ::cFacPrvL )->cAlmLin == cCodAlm ) )           .and.;
            !( lExcCero .and. nTotNFacPrv( ::cFacPrvL ) == 0 )                         .and.;
            !( lExcImp .and. nTotLFacPrv( ::cFacPrvL, ::nDecIn, ::nDerIn ) == 0 )      .and.;
            ( Empty( dFecIni ) .or. ( ::cFacPrvL )->dFecFac >= dFecIni )               .and.;
            ( Empty( dFecFin ) .or. ( ::cFacPrvL )->dFecFac <= dFecFin )               .and.;
            ( !lSerie .or. lChkSer( ( ::cFacPrvL )->cSerFac, aSer ) )

            aAdd( aMovimientos, STemporal():New( ( ::cFacPrvL )->dFecFac, nil, nTotNFacPrv( ::cFacPrvL ), 0, nTotLFacPrv( ::cFacPrvL, ::nDecIn, ::nDerIn ), "fac prv", ( ::cFacPrvL )->cSerFac + Str( ( ::cFacPrvL )->nNumFac ) + ( ::cFacPrvL )->cSufFac ) )

         end if

         ( ::cFacPrvL )->( dbSkip() )

      end while

   end if

   if oMtr != nil
      oMtr:AutoInc()
   end if

   //Recorremos Facturas rectificativas de proveedores----------------------------------------

   if ( ::cRctPrvL )->( dbSeek( cCodArt ) )

      while ( ::cRctPrvL )->cRef == cCodArt .and. !( ::cRctPrvL )->( eof() )

         if ( Empty( cCodAlm ) .or. ( ( ::cRctPrvL )->cAlmLin == cCodAlm ) )           .and.;
            !( lExcCero .and. nTotNRctPrv( ::cRctPrvL ) == 0 )                         .and.;
            !( lExcImp .and. nTotLRctPrv( ::cRctPrvL, ::nDecIn, ::nDerIn ) == 0 )      .and.;
            ( Empty( dFecIni ) .or. ( ::cRctPrvL )->dFecFac >= dFecIni )               .and.;
            ( Empty( dFecFin ) .or. ( ::cRctPrvL )->dFecFac <= dFecFin )               .and.;
            ( !lSerie .or. lChkSer( ( ::cRctPrvL )->cSerFac, aSer ) )

            aAdd( aMovimientos, STemporal():New( ( ::cRctPrvL )->dFecFac, nil, nTotNRctPrv( ::cRctPrvL ), 0, nTotLRctPrv( ::cRctPrvL, ::nDecIn, ::nDerIn ), "fac prv", ( ::cRctPrvL )->cSerFac + Str( ( ::cRctPrvL )->nNumFac ) + ( ::cRctPrvL )->cSufFac ) )

         end if

         ( ::cRctPrvL )->( dbSkip() )

      end while

   end if

   if oMtr != nil
      oMtr:AutoInc()
   end if

   //Recorremos movimientos de almacén-----------------------------------------

   if ( ::cHisMovT)->( dbSeek( cCodArt ) )

      while ( ::cHisMovT)->cRefMov == cCodArt .and. !( ::cHisMovT)->( Eof() )

         if ( Empty( dFecIni ) .or. ( ::cHisMovT)->dFecMov >= dFecIni )                   .and.;
            ( Empty( dFecFin ) .or. ( ::cHisMovT)->dFecMov <= dFecFin )                   .and.;
            !( lExcCero .and. nTotNMovAlm( ::cHisMovT) == 0 )                             .and.;
            !( lExcImp  .and. nTotLMovAlm( ::cHisMovT) == 0 )

            // Movimiento de entrada-------------------------------------------

            if !Empty( ( ::cHisMovT)->cAliMov )                                           .and.;
               ( Empty( cCodAlm ) .or. ( ::cHisMovT)->cAliMov == cCodAlm )

               aAdd( aMovimientos, STemporal():New( ( ::cHisMovT)->dFecMov, nil, nTotNMovAlm( ::cHisMovT), 0, nTotLMovAlm( ::cHisMovT), "mov alm", dtos( ( ::cHisMovT)->dFecMov ) ) )

            end if

         end if

         ( ::cHisMovT)->( dbSkip() )

      end while

   end if

   if oMtr != nil
      oMtr:AutoInc()
   end if

   //Ordenamos el array--------------------------------------------------------

   aMovimientos            := aSort( aMovimientos,,, {|x,y| ( Dtos( x:dFecMov ) ) < ( Dtos( y:dFecMov ) ) } )

   //Calculamos el precio medio------------------------------------------------

   for each aMov in aMovimientos

      // Entradas en almcen----------------------------------------------------

      if aMov:nTotEnt != 0
         nSalAnt           += aMov:nTotEnt
         nImpAnt           += aMov:nImpEnt
         nPreMed           := nImpAnt / nSalAnt
      end if

   next

   // Estructura q devuelve----------------------------------------------------

   // Devolvemos el orden que tenian las tablas--------------------------------

   ( ::cAlbPrvL )->( OrdSetFocus( nOrdAlbPrvL ) )
   ( ::cFacPrvL )->( OrdSetFocus( nOrdFacPrvL ) )
   ( ::cRctPrvL )->( OrdSetFocus( nOrdRctPrvL ) )
   ( ::cHisMovT )->( OrdSetFocus( cHisMovT    ) )

RETURN ( nPreMed )

//---------------------------------------------------------------------------//

METHOD nCostoMedio( cCodArt, cCodAlm, cCodPr1, cCodPr2, cValPr1, cValPr2 ) CLASS TStock

   local nUnidades      := 0
   local nImporte       := 0
   local nCostoMedio    := 0
   local nOrdAlbPrvL    := ( ::cAlbPrvL )->( OrdSetFocus( "cStkRef" ) )
   local nOrdFacPrvL    := ( ::cFacPrvL )->( OrdSetFocus( "cRef" ) )
   local nOrdRctPrvL    := ( ::cRctPrvL )->( OrdSetFocus( "cRef" ) )
   local nOrdMovAlm     := ( ::cHisMovT )->( OrdSetFocus( "cRefMov" ) )

   /*
   Obtengo la fecha de consolidación-------------------------------------------
   */

   //::lCheckConsolidacion( cCodArt )

   /*
   Recorremos movimientos de almacén-------------------------------------------
   */

   if ( ::cHisMovT)->( dbSeek( cCodArt + cValPr1 + cValPr2 ) )

      while ( ::cHisMovT)->cRefMov == cCodArt .and. ( ::cHisMovT)->cValPr1 == cValPr1 .and. ( ::cHisMovT)->cValPr2 == cValPr2 .and. !( ::cHisMovT)->( Eof() )

         if ::lValoracionCostoMedio( ( ::cHisMovT)->nTipMov )

            if !Empty( ( ::cHisMovT)->cAloMov ) .and. ( Empty( cCodAlm ) .or. ( ::cHisMovT)->cAliMov == cCodAlm ) .and.;
               ::lCheckConsolidacion( ( ::cHisMovT)->cRefMov, ( ::cHisMovT)->cAloMov, ( ::cHisMovT)->cCodPr1, ( ::cHisMovT)->cCodPr2, ( ::cHisMovT)->cValPr1, ( ::cHisMovT)->cValPr2, ( ::cHisMovT)->cLote, ( ::cHisMovT)->dFecMov )

               nUnidades   += nTotNMovAlm( ::cHisMovT)
               nImporte    += nTotLMovAlm( ::cHisMovT)

            end if

            if !Empty( ( ::cHisMovT)->cAliMov ) .and. ( Empty( cCodAlm ) .or. ( ::cHisMovT)->cAliMov == cCodAlm ) .and.;
               ::lCheckConsolidacion( ( ::cHisMovT)->cRefMov, ( ::cHisMovT)->cAliMov, ( ::cHisMovT)->cCodPr1, ( ::cHisMovT)->cCodPr2, ( ::cHisMovT)->cValPr1, ( ::cHisMovT)->cValPr2, ( ::cHisMovT)->cLote, ( ::cHisMovT)->dFecMov )

               nUnidades   += nTotNMovAlm( ::cHisMovT)
               nImporte    += nTotLMovAlm( ::cHisMovT)

            end if

         end if

         ( ::cHisMovT)->( dbSkip() )

      end while

   end if

   /*
   Recorremos Albaranes de proveedores-----------------------------------------
   */

   if ( ::cAlbPrvL )->( dbSeek( cCodArt + cValPr1 + cValPr2 ) )

      while ( ::cAlbPrvL )->cRef == cCodArt .and. ( ::cAlbPrvL )->cValPr1 == cValPr1 .and. ( ::cAlbPrvL )->cValPr2 == cValPr2 .and. !( ::cAlbPrvL )->( eof() )

      if ::lCheckConsolidacion( ( ::cAlbPrvL )->cRef, ( ::cAlbPrvL )->cAlmLin, ( ::cAlbPrvL )->cCodPr1, ( ::cAlbPrvL )->cCodPr2, ( ::cAlbPrvL )->cValPr1, ( ::cAlbPrvL )->cValPr2, ( ::cAlbPrvL )->cLote, ( ::cAlbPrvL )->dFecAlb ) .and.;
            Empty( cCodAlm ) .or. ( ( ::cAlbPrvL )->cAlmLin == cCodAlm )

            nUnidades   += nTotNAlbPrv( ::cAlbPrvL )
            nImporte    += nTotLAlbPrv( ::cAlbPrvL, ::nDecIn, ::nDerIn )

         end if

         ( ::cAlbPrvL )->( dbSkip() )

      end while

   end if

   /*
   Recorremos Facturas de proveedores------------------------------------------
   */

   if ( ::cFacPrvL )->( dbSeek( cCodArt + cValPr1 + cValPr2 ) )

      while ( ::cFacPrvL )->cRef == cCodArt .and. ( ::cFacPrvL )->cValPr1 == cValPr1 .and. ( ::cFacPrvL )->cValPr2 == cValPr2 .and. !( ::cFacPrvL )->( eof() )

         if ::lCheckConsolidacion( ( ::cFacPrvL )->cRef, ( ::cFacPrvL )->cAlmLin, ( ::cFacPrvL )->cCodPr1, ( ::cFacPrvL )->cCodPr2, ( ::cFacPrvL )->cValPr1, ( ::cFacPrvL )->cValPr2, ( ::cFacPrvL )->cLote, ( ::cFacPrvL )->dFecFac )   .and.;
            Empty( cCodAlm ) .or. ( ( ::cFacPrvL )->cAlmLin == cCodAlm )

            nUnidades   += nTotNFacPrv( ::cFacPrvL )
            nImporte    += nTotLFacPrv( ::cFacPrvL, ::nDecIn, ::nDerIn )

         end if

         ( ::cFacPrvL )->( dbSkip() )

      end while

   end if

   /*
   Recorremos Facturas rectificativas de proveedores---------------------------
   */

   if ( ::cRctPrvL )->( dbSeek( cCodArt + cValPr1 + cValPr2 ) )

      while ( ::cRctPrvL )->cRef == cCodArt .and. ( ::cRctPrvL )->cValPr1 == cValPr1 .and. ( ::cRctPrvL )->cValPr2 == cValPr2 .and. !( ::cRctPrvL )->( eof() )

         if ::lCheckConsolidacion( ( ::cRctPrvL )->cRef, ( ::cRctPrvL )->cAlmLin, ( ::cRctPrvL )->cCodPr1, ( ::cRctPrvL )->cCodPr2, ( ::cRctPrvL )->cValPr1, ( ::cRctPrvL )->cValPr2, ( ::cRctPrvL )->cLote, ( ::cRctPrvL )->dFecFac )   .and.;
            Empty( cCodAlm ) .or. ( ( ::cRctPrvL )->cAlmLin == cCodAlm )

            nUnidades   += nTotNRctPrv( ::cRctPrvL )
            nImporte    += nTotLRctPrv( ::cRctPrvL, ::nDecIn, ::nDerIn )

         end if

         ( ::cRctPrvL )->( dbSkip() )

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

   if nCostoMedio == 0 .and. !Empty( ::cArticulo ) .and. !Empty( ::cKit )
      nCostoMedio       := nCosto( cCodArt, ::cArticulo, ::cKit )
   end if

   /*
   Devolvemos el orden que tenian las tablas-----------------------------------
   */

   ( ::cAlbPrvL )->( OrdSetFocus( nOrdAlbPrvL ) )
   ( ::cFacPrvL )->( OrdSetFocus( nOrdFacPrvL ) )
   ( ::cRctPrvL )->( OrdSetFocus( nOrdRctPrvL ) )
   ( ::cHisMovT )->( OrdSetFocus( nOrdMovAlm  ) )

RETURN ( nCostoMedio )

//---------------------------------------------------------------------------//

METHOD lValoracionCostoMedio( nTipMov )

RETURN ( !uFieldEmpresa( "lMovCos" ) .and. ( nTipMov == 2 .or. nTipMov == 4 ) )

//---------------------------------------------------------------------------//

METHOD Zap() CLASS TStock

   if ( ::oDbf )->( Used() )

      if !( ::oDbf )->( IsShared() )

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

METHOD nStockAlmacen( cCodArt, cCodAlm, cValPr1, cValPr2, cLote ) CLASS TStock

   local oBlock
   local oError
   local nOrdAnt
   local nStkTotal      := 0
   local nOrdHisMov
   local nOrdPedPrvL
   local nOrdAlbPrvL
   local nOrdFacPrvL
   local nOrdRctPrvL
   local nOrdPedCliL
   local nOrdAlbCliL
   local nOrdFacCliL
   local nOrdFacRecL
   local nOrdTikCliL
   local nOrdProducL
   local nOrdProducM

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   nOrdPedPrvL          := if( !Empty( ::cPedPrvL ), ( ::cPedPrvL )->( OrdSetFocus( "cRef" ) )     , "" )
   nOrdAlbPrvL          := if( !Empty( ::cAlbPrvL ), ( ::cAlbPrvL )->( OrdSetFocus( "cStkFast" ) ) , "" )
   nOrdFacPrvL          := if( !Empty( ::cFacPrvL ), ( ::cFacPrvL )->( OrdSetFocus( "cRef" ) )     , "" )
   nOrdRctPrvL          := if( !Empty( ::cRctPrvL ), ( ::cRctPrvL )->( OrdSetFocus( "cRef" ) )     , "" )
   nOrdPedCliL          := if( !Empty( ::cPedCliL ), ( ::cPedCliL )->( OrdSetFocus( "cRef" ) )     , "" )
   nOrdAlbCliL          := if( !Empty( ::cAlbCliL ), ( ::cAlbCliL )->( OrdSetFocus( "cStkFast" ) ) , "" )
   nOrdFacCliL          := if( !Empty( ::cFacCliL ), ( ::cFacCliL )->( OrdSetFocus( "cRef" ) )     , "" )
   nOrdFacRecL          := if( !Empty( ::cFacRecL ), ( ::cFacRecL )->( OrdSetFocus( "cRef" ) )     , "" )
   nOrdTikCliL          := if( !Empty( ::cTikL    ), ( ::cTikL    )->( OrdSetFocus( "cStkFast" ) ) , "" )
   nOrdProducL          := if( !Empty( ::cProducL ), ( ::cProducL )->( OrdSetFocus( "cCodArt" ) )  , "" )
   nOrdProducM          := if( !Empty( ::cProducM ), ( ::cProducM )->( OrdSetFocus( "cCodArt" ) )  , "" )
   nOrdHisMov           := if( !Empty( ::cHisMovT ), ( ::cHisMovT )->( OrdSetFocus( "cRefMov" ) )  , "" )

   if !Empty( cCodArt )

      CursorWait()

      /*
      Movimientos de almacén------------------------------------------------------
      */

      SysRefresh()

      if !Empty( ::cHisMovT)

         //::lCheckConsolidacion( cCodArt )

         if ( ::cHisMovT)->( dbSeek( cCodArt ) )

            while ( ::cHisMovT)->cRefMov == cCodArt .and. !( ::cHisMovT)->( Eof() )

               //if ( Empty( ::dConsolidacion ) .or. ( ::cHisMovT)->dFecMov >= ::dConsolidacion )

                  if !Empty( ( ::cHisMovT)->cAliMov )                               .and.;
                     ::lCheckConsolidacion( ( ::cHisMovT)->cRefMov, ( ::cHisMovT)->cAliMov, ( ::cHisMovT)->cCodPr1, ( ::cHisMovT)->cCodPr2, ( ::cHisMovT)->cValPr1, ( ::cHisMovT)->cValPr2, ( ::cHisMovT)->cLote, ( ::cHisMovT)->dFecMov ) .and.;
                     ( Empty( cCodAlm )   .or. cCodAlm == ( ::cHisMovT)->cAliMov )  .and.;
                     ( Empty( cValPr1 )   .or. cValPr1 == ( ::cHisMovT)->cValPr1 )  .and.;
                     ( Empty( cValPr2 )   .or. cValPr2 == ( ::cHisMovT)->cValPr2 )  .and.;
                     ( Empty( cLote )     .or. cLote   == ( ::cHisMovT)->cLote   )

                     nStkTotal               += nTotNMovAlm( ::cHisMovT)

                  end if

                  if !Empty( ( ::cHisMovT)->cAloMov )                               .and.;
                     ::lCheckConsolidacion( ( ::cHisMovT)->cRefMov, ( ::cHisMovT)->cAloMov, ( ::cHisMovT)->cCodPr1, ( ::cHisMovT)->cCodPr2, ( ::cHisMovT)->cValPr1, ( ::cHisMovT)->cValPr2, ( ::cHisMovT)->cLote, ( ::cHisMovT)->dFecMov ) .and.;
                     ( Empty( cCodAlm )   .or. cCodAlm == ( ::cHisMovT)->cAloMov )  .and.;
                     ( Empty( cValPr1 )   .or. cValPr1 == ( ::cHisMovT)->cValPr1 )  .and.;
                     ( Empty( cValPr2 )   .or. cValPr2 == ( ::cHisMovT)->cValPr2 )  .and.;
                     ( Empty( cLote )     .or. cLote   == ( ::cHisMovT)->cLote   )

                     nStkTotal               -= nTotNMovAlm( ::cHisMovT)

                  end if

               //end if

               ( ::cHisMovT)->( dbSkip() )

            end while

         end if

      end if

      /*
      Albaranes de proveedor------------------------------------------------------
      */

      SysRefresh()

      if !Empty( ::cAlbPrvL ) .and. ( ::cAlbPrvL )->( dbSeek( cCodArt ) )

         while ( ::cAlbPrvL )->cRef == cCodArt .and. !( ::cAlbPrvL )->( Eof() )

            if ( ::cAlbPrvL )->nCtlStk < 2                                                      .and.;
               ::lCheckConsolidacion( ( ::cAlbPrvL )->cRef, ( ::cAlbPrvL )->cAlmLin, ( ::cAlbPrvL )->cCodPr1, ( ::cAlbPrvL )->cCodPr2, ( ::cAlbPrvL )->cValPr1, ( ::cAlbPrvL )->cValPr2, ( ::cAlbPrvL )->cLote, ( ::cAlbPrvL )->dFecAlb ) .and.;
               ( Empty( cCodAlm )   .or. cCodAlm == ( ::cAlbPrvL )->cAlmLin )                   .and.;
               ( Empty( cValPr1 )   .or. cValPr1 == ( ::cAlbPrvL )->cValPr1 )                   .and.;
               ( Empty( cValPr2 )   .or. cValPr2 == ( ::cAlbPrvL )->cValPr2 )                   .and.;
               ( Empty( cLote )     .or. cLote   == ( ::cAlbPrvL )->cLote   )

               nStkTotal               += nTotNAlbPrv( ::cAlbPrvL )

            end if

            ( ::cAlbPrvL )->( dbSkip() )

         end while

      end if

      /*
      Facturas de proveedor-------------------------------------------------------
      */

      SysRefresh()

      if !Empty( ::cFacPrvL ) .and. ( ::cFacPrvL )->( dbSeek( cCodArt ) )

         while ( ::cFacPrvL )->cRef == cCodArt .and. !( ::cFacPrvL )->( Eof() )

            if ( ::cFacPrvL )->nCtlStk < 2                                                      .and.;
               ::lCheckConsolidacion( ( ::cFacPrvL )->cRef, ( ::cFacPrvL )->cAlmLin, ( ::cFacPrvL )->cCodPr1, ( ::cFacPrvL )->cCodPr2, ( ::cFacPrvL )->cValPr1, ( ::cFacPrvL )->cValPr2, ( ::cFacPrvL )->cLote, ( ::cFacPrvL )->dFecFac ) .and.;
               ( Empty( cCodAlm )   .or. cCodAlm == ( ::cFacPrvL )->cAlmLin )                   .and.;
               ( Empty( cValPr1 )   .or. cValPr1 == ( ::cFacPrvL )->cValPr1 )                   .and.;
               ( Empty( cValPr2 )   .or. cValPr2 == ( ::cFacPrvL )->cValPr2 )                   .and.;
               ( Empty( cLote )     .or. cLote   == ( ::cFacPrvL )->cLote   )

               nStkTotal               += nTotNFacPrv( ::cFacPrvL )

            end if

            ( ::cFacPrvL )->( dbSkip() )

         end while

      end if

      /*
      Facturas rectificativas de proveedor-------------------------------------
      */

      SysRefresh()

      if !Empty( ::cRctPrvL ) .and. ( ::cRctPrvL )->( dbSeek( cCodArt ) )

         while ( ::cRctPrvL )->cRef == cCodArt .and. !( ::cRctPrvL )->( Eof() )

            if ( ::cRctPrvL )->nCtlStk < 2                                                      .and.;
               ::lCheckConsolidacion( ( ::cRctPrvL )->cRef, ( ::cRctPrvL )->cAlmLin, ( ::cRctPrvL )->cCodPr1, ( ::cRctPrvL )->cCodPr2, ( ::cRctPrvL )->cValPr1, ( ::cRctPrvL )->cValPr2, ( ::cRctPrvL )->cLote, ( ::cRctPrvL )->dFecFac ) .and.;
               ( Empty( cCodAlm )   .or. cCodAlm == ( ::cRctPrvL )->cAlmLin )                   .and.;
               ( Empty( cValPr1 )   .or. cValPr1 == ( ::cRctPrvL )->cValPr1 )                   .and.;
               ( Empty( cValPr2 )   .or. cValPr2 == ( ::cRctPrvL )->cValPr2 )                   .and.;
               ( Empty( cLote )     .or. cLote   == ( ::cRctPrvL )->cLote   )

               nStkTotal               += nTotNRctPrv( ::cRctPrvL )

            end if

            ( ::cRctPrvL )->( dbSkip() )

         end while

      end if

      /*
      Albaranes de clientes----------------------------------------------------
      */

      SysRefresh()

      if !Empty( ::cAlbCliL ) .and. ( ::cAlbCliL )->( dbSeek( cCodArt ) )

         while ( ::cAlbCliL )->cRef == cCodArt .and. !( ::cAlbCliL )->( Eof() )

            if ( ::cAlbCliL )->nCtlStk < 2                                                      .and.;
            ::lCheckConsolidacion( ( ::cAlbCliL )->cRef, ( ::cAlbCliL )->cAlmLin, ( ::cAlbCliL )->cCodPr1, ( ::cAlbCliL )->cCodPr2, ( ::cAlbCliL )->cValPr1, ( ::cAlbCliL )->cValPr2, ( ::cAlbCliL )->cLote, ( ::cAlbCliL )->dFecAlb ) .and.;
               ( Empty( cCodAlm )   .or. cCodAlm == ( ::cAlbCliL )->cAlmLin )                   .and.;
               ( Empty( cValPr1 )   .or. cValPr1 == ( ::cAlbCliL )->cValPr1 )                   .and.;
               ( Empty( cValPr2 )   .or. cValPr2 == ( ::cAlbCliL )->cValPr2 )                   .and.;
               ( Empty( cLote )     .or. cLote   == ( ::cAlbCliL )->cLote   )

               nStkTotal               -= nTotVAlbCli( ::cAlbCliL )

            end if

            ( ::cAlbCliL )->( dbSkip() )

         end while

      end if

      /*
      Facturas de clientes--------------------------------------------------------
      */

      SysRefresh()

      if !Empty( ::cFacCliL ) .and. ( ::cFacCliL )->( dbSeek( cCodArt ) )

         while ( ::cFacCliL )->cRef == cCodArt .and. !( ::cFacCliL )->( Eof() )

            if ( ::cFacCliL )->nCtlStk < 2                                                      .and.;
               ::lCheckConsolidacion( ( ::cFacCliL )->cRef, ( ::cFacCliL )->cAlmLin, ( ::cFacCliL )->cCodPr1, ( ::cFacCliL )->cCodPr2, ( ::cFacCliL )->cValPr1, ( ::cFacCliL )->cValPr2, ( ::cFacCliL )->cLote, ( ::cFacCliL )->dFecFac ) .and.;
               ( Empty( cCodAlm )   .or. cCodAlm == ( ::cFacCliL )->cAlmLin )                   .and.;
               ( Empty( cValPr1 )   .or. cValPr1 == ( ::cFacCliL )->cValPr1 )                   .and.;
               ( Empty( cValPr2 )   .or. cValPr2 == ( ::cFacCliL )->cValPr2 )                   .and.;
               ( Empty( cLote )     .or. cLote   == ( ::cFacCliL )->cLote   )

               nStkTotal               -= nTotVFacCli( ::cFacCliL )

            end if

            ( ::cFacCliL )->( dbSkip() )

         end while

      end if

      /*
      Facturas rectificativas-----------------------------------------------------
      */

      SysRefresh()

      if !Empty( ::cFacRecL ) .and. ( ::cFacRecL )->( dbSeek( cCodArt ) )

         while ( ::cFacRecL )->cRef == cCodArt .and. !( ::cFacRecL )->( Eof() )

            if ( ::cFacRecL )->nCtlStk < 2                                                      .and.;
               ::lCheckConsolidacion( ( ::cFacRecL )->cRef, ( ::cFacRecL )->cAlmLin, ( ::cFacRecL )->cCodPr1, ( ::cFacRecL )->cCodPr2, ( ::cFacRecL )->cValPr1, ( ::cFacRecL )->cValPr2, ( ::cFacRecL )->cLote, ( ::cFacRecL )->dFecFac ) .and.;
               ( Empty( cCodAlm )   .or. cCodAlm == ( ::cFacRecL )->cAlmLin )                   .and.;
               ( Empty( cValPr1 )   .or. cValPr1 == ( ::cFacRecL )->cValPr1 )                   .and.;
               ( Empty( cValPr2 )   .or. cValPr2 == ( ::cFacRecL )->cValPr2 )                   .and.;
               ( Empty( cLote )     .or. cLote   == ( ::cFacRecL )->cLote   )

               nStkTotal               -= nTotVFacRec( ::cFacRecL )

            end if

            ( ::cFacRecL )->( dbSkip() )

         end while

      end if

      /*
      Tickets de clientes normales------------------------------------------------
      */

      SysRefresh()

      if !Empty( ::cTikL )

         if ( ::cTikL )->( dbSeek( cCodArt ) )

            while ( ::cTikL )->cCbaTil == cCodArt .and. !( ::cTikL )->( Eof() )

               if ( ::cTikL )->nCtlStk < 2                                                      .and.;
                  ::lCheckConsolidacion( ( ::cTikL )->cCbaTil, ( ::cTikL )->cAlmLin, ( ::cTikL )->cCodPr1, ( ::cTikL )->cCodPr2, ( ::cTikL )->cValPr1, ( ::cTikL )->cValPr2, ( ::cTikL )->cLote, ( ::cTikL )->dFecTik )  .and.;
                  ( Empty( cCodAlm )   .or. cCodAlm == ( ::cTikL )->cAlmLin )                   .and.;
                  ( Empty( cValPr1 )   .or. cValPr1 == ( ::cTikL )->cValPr1 )                   .and.;
                  ( Empty( cValPr2 )   .or. cValPr2 == ( ::cTikL )->cValPr2 )                   .and.;
                  ( Empty( cLote )     .or. cLote   == ( ::cTikL )->cLote   )

                  if ( ::cTikL )->cTipTil == SAVTIK .or. ( ::cTikL )->cTipTil == SAVAPT
                     nStkTotal               -= nTotVTikTpv( ::cTikL )
                  else
                     nStkTotal               += nTotVTikTpv( ::cTikL )
                  end if

               end if

               ( ::cTikL )->( dbSkip() )

            end while

         end if

         /*
         Tickets de clientes combinados----------------------------------------------
         */

         SysRefresh()

         nOrdAnt              := ( ::cTikL )->( OrdSetFocus( "CSTKCOM" ) )

         if ( ::cTikL )->( dbSeek( cCodArt ) )

            if !Empty( ( ::cTikL )->cComTil )

               while ( ::cTikL )->cComTil == cCodArt .and. !( ::cTikL )->( Eof() )

                  if ( ::cTikL )->nCtlStk < 2                                                      .and.;
                     ::lCheckConsolidacion( ( ::cTikL )->cComTil, ( ::cTikL )->cAlmLin, ( ::cTikL )->cCodPr1, ( ::cTikL )->cCodPr2, ( ::cTikL )->cValPr1, ( ::cTikL )->cValPr2, ( ::cTikL )->cLote, ( ::cTikL )->dFecTik )  .and.;
                     ( Empty( cCodAlm ) .or. cCodAlm == ( ::cTikL )->cAlmLin )

                     nStkTotal               -= nTotVTikTpv( ::cTikL, .t. )

                  end if

                  ( ::cTikL )->( dbSkip() )

               end while

            end if

         end if

         ( ::cTikL )->( OrdSetFocus( nOrdAnt ) )

      end if

      /*
      Materiales producidos-------------------------------------------------------
      */

      SysRefresh()

      if !Empty( ::cProducL ) .and. ( ::cProducL )->( dbSeek( cCodArt ) )

         while ( ::cProducL )->cCodArt == cCodArt .and. !( ::cProducL )->( Eof() )

            if ::lCheckConsolidacion( ( ::cProducL )->cCodArt, ( ::cProducL )->cAlmOrd, ( ::cProducL )->cCodPr1, ( ::cProducL )->cCodPr2, ( ::cProducL )->cValPr1, ( ::cProducL )->cValPr2, ( ::cProducL )->cLote, ( ::cProducL )->dFecOrd )  .and.;
               ( Empty( cCodAlm )   .or. cCodAlm == ( ::cProducL )->cAlmOrd )                   .and.;
               ( Empty( cValPr1 )   .or. cValPr1 == ( ::cProducL )->cValPr1 )                   .and.;
               ( Empty( cValPr2 )   .or. cValPr2 == ( ::cProducL )->cValPr2 )                   .and.;
               ( Empty( cLote )     .or. cLote   == ( ::cProducL )->cLote   )

               nStkTotal               += NotCaja( ( ::cProducL )->nCajOrd ) * ( ::cProducL )->nUndOrd

            end if

            ( ::cProducL )->( dbSkip() )

         end while

      end if

      /*
      Materias primas-------------------------------------------------------------
      */

      SysRefresh()

      if !Empty( ::cProducM ) .and. ( ::cProducM )->( dbSeek( cCodArt ) )

         while ( ::cProducM )->cCodArt == cCodArt .and. !( ::cProducM )->( Eof() )

            if ::lCheckConsolidacion( ( ::cProducM )->cCodArt, ( ::cProducM )->cAlmOrd, ( ::cProducM )->cCodPr1, ( ::cProducM )->cCodPr2, ( ::cProducM )->cValPr1, ( ::cProducM )->cValPr2, ( ::cProducM )->cLote, ( ::cProducM )->dFecOrd ) .and.;
               ( Empty( cCodAlm )   .or. cCodAlm == ( ::cProducM )->cAlmOrd )                   .and.;
               ( Empty( cValPr1 )   .or. cValPr1 == ( ::cProducM )->cValPr1 )                   .and.;
               ( Empty( cValPr2 )   .or. cValPr2 == ( ::cProducM )->cValPr2 )                   .and.;
               ( Empty( cLote )     .or. cLote   == ( ::cProducM )->cLote   )

               nStkTotal               -= NotCaja( ( ::cProducM )->nCajOrd ) * ( ::cProducM )->nUndOrd

            end if

            ( ::cProducM )->( dbSkip() )

         end while

      end if

      CursorWE()

   end if

   if( !Empty( ::cPedPrvL ), ( ::cPedPrvL )->( OrdSetFocus( nOrdPedPrvL ) ), )
   if( !Empty( ::cAlbPrvL ), ( ::cAlbPrvL )->( OrdSetFocus( nOrdAlbPrvL ) ), )
   if( !Empty( ::cFacPrvL ), ( ::cFacPrvL )->( OrdSetFocus( nOrdFacPrvL ) ), )
   if( !Empty( ::cRctPrvL ), ( ::cRctPrvL )->( OrdSetFocus( nOrdRctPrvL ) ), )
   if( !Empty( ::cPedCliL ), ( ::cPedCliL )->( OrdSetFocus( nOrdPedCliL ) ), )
   if( !Empty( ::cAlbCliL ), ( ::cAlbCliL )->( OrdSetFocus( nOrdAlbCliL ) ), )
   if( !Empty( ::cFacCliL ), ( ::cFacCliL )->( OrdSetFocus( nOrdFacCliL ) ), )
   if( !Empty( ::cFacRecL ), ( ::cFacRecL )->( OrdSetFocus( nOrdFacRecL ) ), )
   if( !Empty( ::cTikL    ), ( ::cTikL    )->( OrdSetFocus( nOrdTikCliL ) ), )
   if( !Empty( ::cProducL ), ( ::cProducL )->( OrdSetFocus( nOrdProducL ) ), )
   if( !Empty( ::cProducM ), ( ::cProducM )->( OrdSetFocus( nOrdProducM ) ), )
   if( !Empty( ::cHisMovT ), ( ::cHisMovT )->( OrdSetFocus( nOrdHisMov  ) ), )

   RECOVER USING oError

   END SEQUENCE

   ErrorBlock( oBlock )

return ( nStkTotal )

//---------------------------------------------------------------------------//

METHOD aStockArticulo( cCodArt, cCodAlm, oBrw, lLote, lNumeroSerie, dFecIni, dFecFin, lNotPendiente ) CLASS TStock

   local nRec
   local oBlock
   local oError
   local dFecha         := Ctod( "" )
   local cSerie
   local nTotal
   local dFecDoc
   local nOrdAnt
   local oStocks
   local nOrdPedPrvL
   local nOrdAlbPrvL
   local nOrdFacPrvL
   local nOrdRctPrvL
   local nOrdPedCliL
   local nOrdAlbCliL
   local nOrdFacCliL
   local nOrdFacRecL
   local nOrdTikCliL
   local nOrdProducL
   local nOrdProducM
   local nOrdHisMov

   DEFAULT lLote        := !uFieldEmpresa( "lCalLot" )
   DEFAULT lNotPendiente:= .f.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   nOrdPedPrvL          := ( ::cPedPrvL )->( OrdSetFocus( "cRef"     ) )
   nOrdAlbPrvL          := ( ::cAlbPrvL )->( OrdSetFocus( "cStkFast" ) )
   nOrdFacPrvL          := ( ::cFacPrvL )->( OrdSetFocus( "cRef"     ) )
   nOrdRctPrvL          := ( ::cRctPrvL )->( OrdSetFocus( "cRef"     ) )
   nOrdPedCliL          := ( ::cPedCliL )->( OrdSetFocus( "cRef"     ) )
   nOrdAlbCliL          := ( ::cAlbCliL )->( OrdSetFocus( "cStkFast" ) )
   nOrdFacCliL          := ( ::cFacCliL )->( OrdSetFocus( "cRef"     ) )
   nOrdFacRecL          := ( ::cFacRecL )->( OrdSetFocus( "cRef"     ) )
   nOrdTikCliL          := ( ::cTikL    )->( OrdSetFocus( "cStkFast" ) )
   nOrdProducL          := ( ::cProducL )->( OrdSetFocus( "cCodArt"  ) )
   nOrdProducM          := ( ::cProducM )->( OrdSetFocus( "cCodArt"  ) )
   nOrdHisMov           := ( ::cHisMovT )->( OrdSetFocus( "cRefMov"  ) )

   lNumeroSerie         := !uFieldEmpresa( "lCalSer" )

   ::aStocks            := nil
   ::aStocks            := {}

   if !Empty( oBrw )
      oBrw:aArrayData   := {}
      oBrw:Refresh()
   end if

   /*
   Movimientos de almacén------------------------------------------------------
   */

   SysRefresh()

   if ( ::cHisMovT)->( dbSeek( cCodArt ) )

      while ( ::cHisMovT)->cRefMov == cCodArt .and. !( ::cHisMovT)->( Eof() )

         if ( Empty( dFecIni ) .or. ( ( ::cHisMovT)->dFecMov >= dFecIni .and. ( ::cHisMovT)->dFecMov <= dFecFin ) )

            if ::lCheckConsolidacion( ( ::cHisMovT)->cRefMov, ( ::cHisMovT)->cAliMov, ( ::cHisMovT)->cCodPr1, ( ::cHisMovT)->cCodPr2, ( ::cHisMovT)->cValPr1, ( ::cHisMovT)->cValPr2, ( ::cHisMovT)->cLote, ( ::cHisMovT)->dFecMov ) .and.;
               ( !Empty( ( ::cHisMovT)->cAliMov ) .and. ( Empty( cCodAlm ) .or. ( ::cHisMovT)->cAliMov == cCodAlm ) )

               with object ( SStock():New() )
                  :cAlias              := ( ::cHisMovT)
                  :cCodigo             := ( ::cHisMovT)->cRefMov
                  :cCodigoAlmacen      := ( ::cHisMovT)->cAliMov
                  :cCodigoPropiedad1   := ( ::cHisMovT)->cCodPr1
                  :cCodigoPropiedad2   := ( ::cHisMovT)->cCodPr2
                  :cValorPropiedad1    := ( ::cHisMovT)->cValPr1
                  :cValorPropiedad2    := ( ::cHisMovT)->cValPr2
                  :cLote               := ( ::cHisMovT)->cLote
                  :nUnidades           := nTotNMovAlm( ::cHisMovT)
                  if !Empty( ::dConsolidacion )
                     :dConsolidacion   := ::dConsolidacion
                  end if
                  ::Integra( hb_QWith(), lLote, lNumeroSerie )
               end with

            end if

            if ::lCheckConsolidacion( ( ::cHisMovT)->cRefMov, ( ::cHisMovT)->cAloMov, ( ::cHisMovT)->cCodPr1, ( ::cHisMovT)->cCodPr2, ( ::cHisMovT)->cValPr1, ( ::cHisMovT)->cValPr2, ( ::cHisMovT)->cLote, ( ::cHisMovT)->dFecMov ) .and.;
               ( !Empty( ( ::cHisMovT)->cAloMov ) .and. ( Empty( cCodAlm ) .or. ( ::cHisMovT)->cAloMov == cCodAlm ) )

               with object ( SStock():New() )
                  :cAlias              := ( ::cHisMovT)
                  :cCodigo             := ( ::cHisMovT)->cRefMov
                  :cCodigoAlmacen      := ( ::cHisMovT)->cAloMov
                  :cCodigoPropiedad1   := ( ::cHisMovT)->cCodPr1
                  :cCodigoPropiedad2   := ( ::cHisMovT)->cCodPr2
                  :cValorPropiedad1    := ( ::cHisMovT)->cValPr1
                  :cValorPropiedad2    := ( ::cHisMovT)->cValPr2
                  :cLote               := ( ::cHisMovT)->cLote
                  :nUnidades           := - nTotNMovAlm( ::cHisMovT)
                  if !Empty( ::dConsolidacion )
                     :dConsolidacion   := ::dConsolidacion
                  end if
                  ::Integra( hb_QWith(), lLote, lNumeroSerie )
               end with

            end if

         end if

         ( ::cHisMovT)->( dbSkip() )

      end while

   end if

   /*
   Albaranes de proveedor------------------------------------------------------
   */

   if IsTrue( ::lAlbPrv ) .and. ( ::cAlbPrvL )->( dbSeek( cCodArt ) )

      while ( ::cAlbPrvL )->cRef == cCodArt .and. !( ::cAlbPrvL )->( Eof() )

         if ::lCheckConsolidacion( ( ::cAlbPrvL )->cRef, ( ::cAlbPrvL )->cAlmLin, ( ::cAlbPrvL )->cCodPr1, ( ::cAlbPrvL )->cCodPr2, ( ::cAlbPrvL )->cValPr1, ( ::cAlbPrvL )->cValPr2, ( ::cAlbPrvL )->cLote, ( ::cAlbPrvL )->dFecAlb )  .and.;
            ( Empty( dFecIni ) .or. ( ( ::cAlbPrvL )->dFecAlb >= dFecIni .and. ( ::cAlbPrvL )->dFecAlb <= dFecFin ) )   .and.;
            ( ( ( ::cAlbPrvL )->nCtlStk < 2 )                                                                           .and.;
            ( Empty( cCodAlm ) .or. ( ::cAlbPrvL )->cAlmLin == cCodAlm ) )

            with object ( SStock():New() )
               :cAlias              := ( ::cAlbPrvL )
               :cCodigo             := ( ::cAlbPrvL )->cRef
               :cCodigoAlmacen      := ( ::cAlbPrvL )->cAlmLin
               :cCodigoPropiedad1   := ( ::cAlbPrvL )->cCodPr1
               :cCodigoPropiedad2   := ( ::cAlbPrvL )->cCodPr2
               :cValorPropiedad1    := ( ::cAlbPrvL )->cValPr1
               :cValorPropiedad2    := ( ::cAlbPrvL )->cValPr2
               :cLote               := ( ::cAlbPrvL )->cLote
               :dFechaCaducidad     := ( ::cAlbPrvL )->dFecCad
               :nUnidades           := nTotNAlbPrv( ::cAlbPrvL )
               ::Integra( hb_QWith(), lLote, lNumeroSerie )
            end with

         end if

         ( ::cAlbPrvL )->( dbSkip() )

      end while

   end if

   /*
   Facturas de proveedor-------------------------------------------------------
   */

   SysRefresh()

   if ( ::cFacPrvL )->( dbSeek( cCodArt ) )

      while ( ::cFacPrvL )->cRef == cCodArt .and. !( ::cFacPrvL )->( Eof() )

         if ::lCheckConsolidacion( ( ::cFacPrvL )->cRef, ( ::cFacPrvL )->cAlmLin, ( ::cFacPrvL )->cCodPr1, ( ::cFacPrvL )->cCodPr2, ( ::cFacPrvL )->cValPr1, ( ::cFacPrvL )->cValPr2, ( ::cFacPrvL )->cLote, ( ::cFacPrvL )->dFecFac )  .and.;
            ( Empty( dFecIni ) .or. ( ( ::cFacPrvL )->dFecFac >= dFecIni .and. ( ::cFacPrvL )->dFecFac <= dFecFin ) )   .and.;
            ( ( ::cFacPrvL )->nCtlStk < 2 )                                                                             .and.;
            ( Empty( cCodAlm ) .or. ( ::cFacPrvL )->cAlmLin == cCodAlm )

            with object ( SStock():New() )
               :cAlias              := ( ::cFacPrvL )
               :cCodigo             := ( ::cFacPrvL )->cRef
               :cCodigoAlmacen      := ( ::cFacPrvL )->cAlmLin
               :cCodigoPropiedad1   := ( ::cFacPrvL )->cCodPr1
               :cCodigoPropiedad2   := ( ::cFacPrvL )->cCodPr2
               :cValorPropiedad1    := ( ::cFacPrvL )->cValPr1
               :cValorPropiedad2    := ( ::cFacPrvL )->cValPr2
               :cLote               := ( ::cFacPrvL )->cLote
               :dFechaCaducidad     := ( ::cFacPrvL )->dFecCad
               :nUnidades           := nTotNFacPrv( ::cFacPrvL )
               ::Integra( hb_QWith(), lLote, lNumeroSerie )
            end with

         end if

         ( ::cFacPrvL )->( dbSkip() )

      end while

   end if

   /*
   Facturas rectificativas de proveedor-------------------------------------------------------
   */

   SysRefresh()

   if ( ::cRctPrvL )->( dbSeek( cCodArt ) )

      while ( ::cRctPrvL )->cRef == cCodArt .and. !( ::cRctPrvL )->( Eof() )

         if ::lCheckConsolidacion( ( ::cRctPrvL )->cRef, ( ::cRctPrvL )->cAlmLin, ( ::cRctPrvL )->cCodPr1, ( ::cRctPrvL )->cCodPr2, ( ::cRctPrvL )->cValPr1, ( ::cRctPrvL )->cValPr2, ( ::cRctPrvL )->cLote, ( ::cRctPrvL )->dFecFac ) .and.;
            ( Empty( dFecIni ) .or. ( ( ::cRctPrvL )->dFecFac >= dFecIni .and. ( ::cRctPrvL )->dFecFac <= dFecFin ) )   .and.;
            ( ( ::cRctPrvL )->nCtlStk < 2 )                                                                             .and.;
            ( Empty( cCodAlm ) .or. ( ::cRctPrvL )->cAlmLin == cCodAlm )

            with object ( SStock():New() )
               :cAlias              := ( ::cRctPrvL )
               :cCodigo             := ( ::cRctPrvL )->cRef
               :cCodigoAlmacen      := ( ::cRctPrvL )->cAlmLin
               :cCodigoPropiedad1   := ( ::cRctPrvL )->cCodPr1
               :cCodigoPropiedad2   := ( ::cRctPrvL )->cCodPr2
               :cValorPropiedad1    := ( ::cRctPrvL )->cValPr1
               :cValorPropiedad2    := ( ::cRctPrvL )->cValPr2
               :cLote               := ( ::cRctPrvL )->cLote
               :dFechaCaducidad     := ( ::cRctPrvL )->dFecCad
               :nUnidades           := nTotNRctPrv( ::cRctPrvL )
               ::Integra( hb_QWith(), lLote, lNumeroSerie )
            end with

         end if

         ( ::cRctPrvL )->( dbSkip() )

      end while

   end if

   /*
   Albaranes de clientes-------------------------------------------------------
   */

   SysRefresh()

   if IsTrue( ::lAlbCli ) .and. ( ::cAlbCliL )->( dbSeek( cCodArt ) )

      while ( ::cAlbCliL )->cRef == cCodArt .and. !( ::cAlbCliL )->( Eof() )

         if ::lCheckConsolidacion( ( ::cAlbCliL )->cRef, ( ::cAlbCliL )->cAlmLin, ( ::cAlbCliL )->cCodPr1, ( ::cAlbCliL )->cCodPr2, ( ::cAlbCliL )->cValPr1, ( ::cAlbCliL )->cValPr2, ( ::cAlbCliL )->cLote, ( ::cAlbCliL )->dFecAlb ) .and.;
            ( Empty( dFecIni ) .or. ( ( ::cAlbCliL )->dFecAlb >= dFecIni .and. ( ::cAlbCliL )->dFecAlb <= dFecFin ) )   .and.;
            ( ( ( ::cAlbCliL )->nCtlStk < 2 )                                                                           .and.;
            ( Empty( cCodAlm ) .or. ( ::cAlbCliL )->cAlmLin == cCodAlm ) )

            with object ( SStock():New() )
               :cAlias              := ( ::cAlbCliL )
               :cCodigo             := ( ::cAlbCliL )->cRef
               :cCodigoAlmacen      := ( ::cAlbCliL )->cAlmLin
               :cCodigoPropiedad1   := ( ::cAlbCliL )->cCodPr1
               :cCodigoPropiedad2   := ( ::cAlbCliL )->cCodPr2
               :cValorPropiedad1    := ( ::cAlbCliL )->cValPr1
               :cValorPropiedad2    := ( ::cAlbCliL )->cValPr2
               :cLote               := ( ::cAlbCliL )->cLote
               :dFechaCaducidad     := ( ::cAlbCliL )->dFecCad
               :nUnidades           := - nTotNAlbCli( ::cAlbCliL )
               ::Integra( hb_QWith(), lLote, lNumeroSerie )
            end with

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

         if !Empty( ( ::cFacCliL )->dFecAlb )
            dFecDoc                 := ( ::cFacCliL )->dFecAlb
         else
            dFecDoc                 := ( ::cFacCliL )->dFecFac
         end if

         if ::lCheckConsolidacion( ( ::cFacCliL )->cRef, ( ::cFacCliL )->cAlmLin, ( ::cFacCliL )->cCodPr1, ( ::cFacCliL )->cCodPr2, ( ::cFacCliL )->cValPr1, ( ::cFacCliL )->cValPr2, ( ::cFacCliL )->cLote, dFecDoc )  .and.;
            ( Empty( dFecIni ) .or. ( dFecDoc >= dFecIni .and. dFecDoc <= dFecFin ) )   .and.;
            ( ( ( ::cFacCliL )->nCtlStk < 2 )                                           .and.;
            ( Empty( cCodAlm ) .or. ( ::cFacCliL )->cAlmLin == cCodAlm ) )

            with object ( SStock():New() )
               :cAlias              := ( ::cFacCliL )
               :cCodigo             := ( ::cFacCliL )->cRef
               :cCodigoAlmacen      := ( ::cFacCliL )->cAlmLin
               :cCodigoPropiedad1   := ( ::cFacCliL )->cCodPr1
               :cCodigoPropiedad2   := ( ::cFacCliL )->cCodPr2
               :cValorPropiedad1    := ( ::cFacCliL )->cValPr1
               :cValorPropiedad2    := ( ::cFacCliL )->cValPr2
               :cLote               := ( ::cFacCliL )->cLote
               :dFechaCaducidad     := ( ::cFacCliL )->dFecCad
               :nUnidades           := - nTotNFacCli( ::cFacCliL )
               ::Integra( hb_QWith(), lLote, lNumeroSerie )
            end with

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

         if ::lCheckConsolidacion( ( ::cFacRecL )->cRef, ( ::cFacRecL )->cAlmLin, ( ::cFacRecL )->cCodPr1, ( ::cFacRecL )->cCodPr2, ( ::cFacRecL )->cValPr1, ( ::cFacRecL )->cValPr2, ( ::cFacRecL )->cLote, ( ::cFacRecL )->dFecFac )  .and.;
            ( Empty( dFecIni ) .or. ( ( ::cFacRecL )->dFecFac >= dFecIni .and. ( ::cFacRecL )->dFecFac <= dFecFin ) )   .and.;
            ( ( ( ::cFacRecL )->nCtlStk < 2 )                                                                           .and.;
            ( Empty( cCodAlm ) .or. ( ::cFacRecL )->cAlmLin == cCodAlm ) )

            with object ( SStock():New() )
               :cAlias              := ( ::cFacRecL )
               :cCodigo             := ( ::cFacRecL )->cRef
               :cCodigoAlmacen      := ( ::cFacRecL )->cAlmLin
               :cCodigoPropiedad1   := ( ::cFacRecL )->cCodPr1
               :cCodigoPropiedad2   := ( ::cFacRecL )->cCodPr2
               :cValorPropiedad1    := ( ::cFacRecL )->cValPr1
               :cValorPropiedad2    := ( ::cFacRecL )->cValPr2
               :cLote               := ( ::cFacRecL )->cLote
               :nUnidades           := - nTotNFacRec( ::cFacRecL )
               ::Integra( hb_QWith(), lLote, lNumeroSerie )
            end with

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

         if ::lCheckConsolidacion( ( ::cTikL )->cCbaTil, ( ::cTikL )->cAlmLin, ( ::cTikL )->cCodPr1, ( ::cTikL )->cCodPr2, ( ::cTikL )->cValPr1, ( ::cTikL )->cValPr2, ( ::cTikL )->cLote, ( ::cTikL )->dFecTik )  .and.;
            ( Empty( dFecIni ) .or. ( ( ::cTikL )->dFecTik >= dFecIni .and. ( ::cTikL )->dFecTik <= dFecFin ) )   .and.;
            ( ( ( ::cTikL )->nCtlStk < 2 )                                                                        .and.;
            ( Empty( cCodAlm ) .or. ( ::cTikL )->cAlmLin == cCodAlm ) )

            with object ( SStock():New() )
               :cAlias              := ( ::cTikL )
               :cCodigo             := ( ::cTikL )->cCbaTil
               :cCodigoAlmacen      := ( ::cTikL )->cAlmLin
               :cCodigoPropiedad1   := ( ::cTikL )->cCodPr1
               :cCodigoPropiedad2   := ( ::cTikL )->cCodPr2
               :cValorPropiedad1    := ( ::cTikL )->cValPr1
               :cValorPropiedad2    := ( ::cTikL )->cValPr2
               :cLote               := ( ::cTikL )->cLote
               if ( ( ::cTikL )->cTipTil == SAVTIK .or. ( ::cTikL )->cTipTil == SAVAPT )
                  :nUnidades        := - nTotVTikTpv( ::cTikL )
               else
                  :nUnidades        := nTotVTikTpv( ::cTikL )
               end if
               ::Integra( hb_QWith(), lLote, lNumeroSerie )
            end with


         end if

         ( ::cTikL )->( dbSkip() )

      end while

   end if

   /*
   Tickets de clientes combinados----------------------------------------------
   */

   SysRefresh()

   ( ::cTikL )->( dbGoTop() )

   nOrdAnt              := ( ::cTikL )->( OrdSetFocus( "cStkCom" ) )

   if ( ::cTikL )->( dbSeek( cCodArt ) )

      if !Empty( ( ::cTikL )->cComTil )

         while ( ::cTikL )->cComTil == cCodArt .and. !( ::cTikL )->( Eof() )

            if ::lCheckConsolidacion( ( ::cTikL )->cCbaTil, ( ::cTikL )->cAlmLin, ( ::cTikL )->cCodPr1, ( ::cTikL )->cCodPr2, ( ::cTikL )->cValPr1, ( ::cTikL )->cValPr2, ( ::cTikL )->cLote, ( ::cTikL )->dFecTik )  .and.;
               ( Empty( dFecIni ) .or. ( ( ::cTikL )->dFecTik >= dFecIni .and. ( ::cTikL )->dFecTik <= dFecFin ) )   .and.;
               ( ( ( ::cTikL )->nCtlStk < 2 )                                                                        .and.;
               ( Empty( cCodAlm ) .or. ( ::cTikL )->cAlmLin == cCodAlm ) )

               with object ( SStock():New() )
                  :cAlias              := ( ::cTikL )
                  :cCodigo             := ( ::cTikL )->cCbaTil
                  :cCodigoAlmacen      := ( ::cTikL )->cAlmLin
                  :cCodigoPropiedad1   := ( ::cTikL )->cCodPr1
                  :cCodigoPropiedad2   := ( ::cTikL )->cCodPr2
                  :cValorPropiedad1    := ( ::cTikL )->cValPr1
                  :cValorPropiedad2    := ( ::cTikL )->cValPr2
                  :cLote               := ( ::cTikL )->cLote
                  if ( ( ::cTikL )->cTipTil == SAVTIK .or. ( ::cTikL )->cTipTil == SAVAPT )
                     :nUnidades        := - nTotVTikTpv( ::cTikL )
                  else
                     :nUnidades        := nTotVTikTpv( ::cTikL )
                  end if
                  ::Integra( hb_QWith(), lLote, lNumeroSerie )
               end with

            end if

            ( ::cTikL )->( dbSkip() )

         end while

      end if

   end if

   ( ::cTikL )->( OrdSetFocus( nOrdAnt ) )

   /*
   Materiales producidos-------------------------------------------------------
   */

   SysRefresh()

   if ( ::cProducL )->( dbSeek( cCodArt ) )

      while ( ::cProducL )->cCodArt == cCodArt .and. !( ::cProducL )->( Eof() )

         if ::lCheckConsolidacion( ( ::cProducL )->cCodArt, ( ::cProducL )->cAlmOrd, ( ::cProducL )->cCodPr1, ( ::cProducL )->cCodPr2, ( ::cProducL )->cValPr1, ( ::cProducL )->cValPr2, ( ::cProducL )->cLote, ( ::cProducL )->dFecOrd )  .and.;
            ( Empty( dFecIni ) .or. ( ( ::cProducL )->dFecOrd >= dFecIni .and. ( ::cProducL )->dFecOrd <= dFecFin ) )   .and.;
            ( Empty( cCodAlm ) .or. ( ::cProducL )->cAlmOrd == cCodAlm )

            with object ( SStock():New() )
               :cAlias              := ( ::cProducL )
               :cCodigo             := ( ::cProducL )->cCodArt
               :cCodigoAlmacen      := ( ::cProducL )->cAlmOrd
               :cCodigoPropiedad1   := ( ::cProducL )->cCodPr1
               :cCodigoPropiedad2   := ( ::cProducL )->cCodPr2
               :cValorPropiedad1    := ( ::cProducL )->cValPr1
               :cValorPropiedad2    := ( ::cProducL )->cValPr2
               :cLote               := ( ::cProducL )->cLote
               :nUnidades           := nTotNProduccion( ::cProducL )
               ::Integra( hb_QWith(), lLote, lNumeroSerie )
            end with

         end if

         ( ::cProducL )->( dbSkip() )

      end while

   end if

   /*
   Materias primas-------------------------------------------------------------
   */

   SysRefresh()

   if ( ::cProducM )->( dbSeek( cCodArt ) )

      while ( ::cProducM )->cCodArt == cCodArt .and. !( ::cProducM )->( Eof() )

         if !Empty( ::cProducT )
            ( ::cProducT )->( dbGoTop() )
            ( ::cProducT )->( dbSeek( ( ::cProducM )->cSerOrd + Str( ( ::cProducM )->nNumOrd ) + ( ::cProducM )->cSufOrd ) )
         end if

         if ::lCheckConsolidacion( ( ::cProducM )->cCodArt, ( ::cProducM )->cAlmOrd, ( ::cProducM )->cCodPr1, ( ::cProducM )->cCodPr2, ( ::cProducM )->cValPr1, ( ::cProducM )->cValPr2, ( ::cProducM )->cLote, ( ::cProducM )->dFecOrd )  .and.;
            ( Empty( dFecIni ) .or. ( ( ::cProducM )->dFecOrd >= dFecIni .and. ( ::cProducM )->dFecOrd <= dFecFin ) )   .and.;
            ( Empty( cCodAlm ) .or. ( ::cProducM )->cAlmOrd == cCodAlm )

            with object ( SStock():New() )
               :cAlias              := ( ::cProducM )
               :cCodigo             := ( ::cProducM )->cCodArt
               :cCodigoAlmacen      := ( ::cProducM )->cAlmOrd
               :cCodigoPropiedad1   := ( ::cProducM )->cCodPr1
               :cCodigoPropiedad2   := ( ::cProducM )->cCodPr2
               :cValorPropiedad1    := ( ::cProducM )->cValPr1
               :cValorPropiedad2    := ( ::cProducM )->cValPr2
               :cLote               := ( ::cProducM )->cLote
               :nUnidades           := - nTotNMaterial( ::cProducM )
               ::Integra( hb_QWith(), lLote, lNumeroSerie )
            end with

         end if

         ( ::cProducM )->( dbSkip() )

      end while

   end if

   if !lNotPendiente

      /*
      Pendientes de recibir----------------------------------------------------
      */

      SysRefresh()

      ( ::cAlbPrvL )->( OrdSetFocus( "cPedRef" ) )

      if ( ::cPedPrvL )->( dbSeek( cCodArt ) )

         while ( ::cPedPrvL )->cRef == cCodArt .and. !( ::cPedPrvL )->( Eof() )

            if Empty( cCodAlm ) .or. ( ::cPedPrvL )->cAlmLin == cCodAlm

               if ( ::cAlbPrvL )->( dbSeek( ( ::cPedPrvL )->cSerPed + Str( ( ::cPedPrvL )->nNumPed ) + ( ::cPedPrvL )->cSufPed + cCodArt ) )

                  nTotal               := nTotNPedPrv( ::cPedPrvL )

                  while ( ::cPedPrvL )->cSerPed + Str( ( ::cPedPrvL )->nNumPed ) + ( ::cPedPrvL )->cSufPed + cCodArt == ( ::cAlbPrvL )->cCodPed + ( ::cAlbPrvL )->cRef .and.;
                        !( ::cAlbPrvL )->( Eof() )

                     nTotal            -= nTotNAlbPrv( ::cAlbPrvL )

                     ( ::cAlbPrvL )->( dbSkip() )

                  end while

               else

                  nTotal               := nTotNPedPrv( ::cPedPrvL )

               end if

               with object ( SStock():New() )
                  :cCodigo             := ( ::cPedPrvL )->cRef
                  :cCodigoAlmacen      := ( ::cPedPrvL )->cAlmLin
                  :cCodigoPropiedad1   := ( ::cPedPrvL )->cCodPr1
                  :cCodigoPropiedad2   := ( ::cPedPrvL )->cCodPr2
                  :cValorPropiedad1    := ( ::cPedPrvL )->cValPr1
                  :cValorPropiedad2    := ( ::cPedPrvL )->cValPr2
                  :cLote               := ( ::cPedPrvL )->cLote
                  :nPendientesRecibir  := if( nTotal > 0, nTotal, 0 )
                  ::Integra( hb_QWith(), lLote, lNumeroSerie )
               end with

            end if

            ( ::cPedPrvL )->( dbSkip() )

         end while

      end if

      /*
      Pendientes de entregar---------------------------------------------------
      */

      SysRefresh()

      ( ::cAlbCliL )->( OrdSetFocus( "cPedRef" ) )
      ( ::cFacCliL )->( OrdSetFocus( "cNumPedRef" ) )

      if ( ::cPedCliL )->( dbSeek( cCodArt ) )

         while ( ::cPedCliL )->cRef == cCodArt .and. !( ::cPedCliL )->( Eof() )

            if Empty( cCodAlm ) .or. ( ::cPedCliL )->cAlmLin == cCodAlm

               if ( ::cAlbCliL )->( dbSeek( ( ::cPedCliL )->cSerPed + Str( ( ::cPedCliL )->nNumPed ) + ( ::cPedCliL )->cSufPed + cCodArt ) )

                  nTotal               := nTotNPedCli( ::cPedCliL )

                  while ( ::cPedCliL )->cSerPed + Str( ( ::cPedCliL )->nNumPed ) + ( ::cPedCliL )->cSufPed + cCodArt == ( ::cAlbCliL )->cNumPed + ( ::cAlbCliL )->cRef .and.;
                        !( ::cAlbCliL )->( Eof() )

                     nTotal            -= nTotNAlbCli( ::cAlbCliL )

                     ( ::cAlbCliL )->( dbSkip() )

                  end while

               elseif ( ::cFacCliL )->( dbSeek( ( ::cPedCliL )->cSerPed + Str( ( ::cPedCliL )->nNumPed ) + ( ::cPedCliL )->cSufPed + cCodArt ) )

                  nTotal               := nTotNPedCli( ::cPedCliL )

                  while ( ::cPedCliL )->cSerPed + Str( ( ::cPedCliL )->nNumPed ) + ( ::cPedCliL )->cSufPed + cCodArt == ( ::cFacCliL )->cNumPed + ( ::cFacCliL )->cRef .and.;
                        !( ::cFacCliL )->( Eof() )

                     nTotal            -= nTotNFacCli( ::cFacCliL )

                     ( ::cFacCliL )->( dbSkip() )

                  end while

               else

                  nTotal               := nTotNPedCli( ::cPedCliL )

               end if

               with object ( SStock():New() )
                  :cCodigo             := ( ::cPedCliL )->cRef
                  :cCodigoAlmacen      := ( ::cPedCliL )->cAlmLin
                  :cCodigoPropiedad1   := ( ::cPedCliL )->cCodPr1
                  :cCodigoPropiedad2   := ( ::cPedCliL )->cCodPr2
                  :cValorPropiedad1    := ( ::cPedCliL )->cValPr1
                  :cValorPropiedad2    := ( ::cPedCliL )->cValPr2
                  :cLote               := ( ::cPedCliL )->cLote
                  :nPendientesEntregar := if( nTotal > 0, nTotal, 0 )
                  ::Integra( hb_QWith(), lLote, lNumeroSerie )
               end with

               ( ::cPedCliL )->( dbSkip() )

            end if

         end while

      end if

   end if

   /*
   Comprobamos la marca de la empresa para no mostrar los valores cero --------
   */

   ( ::cPedPrvL )->( OrdSetFocus( nOrdPedPrvL ) )
   ( ::cAlbPrvL )->( OrdSetFocus( nOrdAlbPrvL ) )
   ( ::cFacPrvL )->( OrdSetFocus( nOrdFacPrvL ) )
   ( ::cRctPrvL )->( OrdSetFocus( nOrdRctPrvL ) )
   ( ::cPedCliL )->( OrdSetFocus( nOrdPedCliL ) )
   ( ::cAlbCliL )->( OrdSetFocus( nOrdAlbCliL ) )
   ( ::cFacCliL )->( OrdSetFocus( nOrdFacCliL ) )
   ( ::cFacRecL )->( OrdSetFocus( nOrdFacRecL ) )
   ( ::cTikL    )->( OrdSetFocus( nOrdTikCliL ) )
   ( ::cProducL )->( OrdSetFocus( nOrdProducL ) )
   ( ::cProducM )->( OrdSetFocus( nOrdProducM ) )
   ( ::cHisMovT )->( OrdSetFocus( nOrdHisMov  ) )

   /*
   Repasamos el valor de lo obtenido-------------------------------------------
   */

   if Empty( ::aStocks )
      ::aStocks                     := { sStock():New() }
   end if

   /*
   Pasamos por el temporal para albaranes--------------------------------------
   */

   if !Empty( ::tmpAlbCliL )

      nRec                          := ( ::tmpAlbCliL )->( Recno() )

      ( ::tmpAlbCliL )->( dbGoTop() )
      while !( ::tmpAlbCliL )->( Eof() )

         if ( ( ::tmpAlbCliL )->cRef == cCodArt ) .and. ( Empty( cCodAlm ) .or. ( ::tmpAlbCliL )->cAlmLin == cCodAlm )

            with object ( SStock():New() )
               :cCodigo             := ( ::tmpAlbCliL )->cRef
               :cCodigoAlmacen      := ( ::tmpAlbCliL )->cAlmLin
               :cCodigoPropiedad1   := ( ::tmpAlbCliL )->cCodPr1
               :cCodigoPropiedad2   := ( ::tmpAlbCliL )->cCodPr2
               :cValorPropiedad1    := ( ::tmpAlbCliL )->cValPr1
               :cValorPropiedad2    := ( ::tmpAlbCliL )->cValPr2
               :cLote               := ( ::tmpAlbCliL )->cLote
               :nUnidades           := - nTotNAlbCli( ::tmpAlbCliL )
               ::Integra( hb_QWith(), lLote, lNumeroSerie )
            end with

         end if

         ( ::tmpAlbCliL )->( dbSkip() )

      end while

      ( ::tmpAlbCliL )->( dbGoTo( nRec ) )

   end if

   /*
   Pasamos por el temporal para Facturas-------------------------------------
   */

   if !Empty( ::tmpFacCliL )

      nRec                          := ( ::tmpFacCliL )->( Recno() )

      ( ::tmpFacCliL )->( dbGoTop() )
      while !( ::tmpFacCliL )->( Eof() )

         if ( ( ::tmpFacCliL )->cRef == cCodArt ) .and. ( Empty( cCodAlm ) .or. ( ::tmpFacCliL )->cAlmLin == cCodAlm )

            with object ( SStock():New() )
               :cCodigo             := ( ::tmpFacCliL )->cRef
               :cCodigoAlmacen      := ( ::tmpFacCliL )->cAlmLin
               :cCodigoPropiedad1   := ( ::tmpFacCliL )->cCodPr1
               :cCodigoPropiedad2   := ( ::tmpFacCliL )->cCodPr2
               :cValorPropiedad1    := ( ::tmpFacCliL )->cValPr1
               :cValorPropiedad2    := ( ::tmpFacCliL )->cValPr2
               :cLote               := ( ::tmpFacCliL )->cLote
               :nUnidades           := - nTotNFacCli( ::tmpFacCliL )
               ::Integra( hb_QWith(), lLote, lNumeroSerie )
            end with

         end if

         ( ::tmpFacCliL )->( dbSkip() )

      end while

      ( ::tmpFacCliL )->( dbGoTo( nRec ) )

   end if

   /*
   Ahora vamos a ver si ya se han dado numeros de serie------------------------
   */

   for each cSerie in ::aSeries
      aScan( ::aStocks, {|o| if( o:cNumeroSerie == cSerie, o:nUnidades -= 1, ) } )
   next

   /*
   Asignamos el array al browse------------------------------------------------
   */

   if !Empty( oBrw )

      SysRefresh()

      oBrw:aArrayData               := {}

      for each oStocks in ::aStocks

         if !Empty( oStocks ) .and. ( ( Round( oStocks:nUnidades, 6 ) != 0.000000 ) .or. ( Round( oStocks:nPendientesRecibir, 6 ) != 0.000000 ) .or. ( Round( oStocks:nPendientesEntregar, 6 ) != 0.000000 ) )
            aAdd( oBrw:aArrayData, oStocks )
         end if
      next

      oBrw:Refresh()

   end if

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Calculo de stock" )

   END SEQUENCE

   ErrorBlock( oBlock )

return ( ::aStocks )

//---------------------------------------------------------------------------//

METHOD nStockArticulo( cCodArt, cCodAlm, oBrw, lLote, lNumeroSerie, dFecIni, dFecFin ) CLASS TStock

   local nStockArticulo := 0

   ::aStockArticulo( cCodArt, cCodAlm, oBrw, lLote, lNumeroSerie, dFecIni, dFecFin )

   aEval( ::aStocks, {|o| nStockArticulo += o:nUnidades } )

Return ( nStockArticulo )

//---------------------------------------------------------------------------//

METHOD nStockSerie( cCodArt, cCodAlm, cNumeroSerie ) CLASS TStock

   local nRec
   local nUnidades      := 0
   local nOrdHisMov     := ( ::cHisMovT )->( OrdSetFocus( "cRefMov" ) )
   local nOrdAlbPrvS    := ( ::cAlbPrvS )->( OrdSetFocus( "cRefSer" ) )
   local nOrdFacPrvS    := ( ::cFacPrvS )->( OrdSetFocus( "cRefSer" ) )
   local nOrdRctPrvS    := ( ::cRctPrvS )->( OrdSetFocus( "cRefSer" ) )
   local nOrdAlbCliS    := ( ::cAlbCliS )->( OrdSetFocus( "cRefSer" ) )
   local nOrdFacCliS    := ( ::cFacCliS )->( OrdSetFocus( "cRefSer" ) )
   local nOrdFacRecS    := ( ::cFacRecS )->( OrdSetFocus( "cRefSer" ) )
   local nOrdTikCliS    := ( ::cTikS    )->( OrdSetFocus( "cRefSer" ) )
   local nOrdProducS    := ( ::cProducS )->( OrdSetFocus( "cCodArt" ) )
   local nOrdProducP    := ( ::cProducP )->( OrdSetFocus( "cCodArt" ) )
   local nOrdHisMovS    := ( ::cHisMovS )->( OrdSetFocus( "cCodArt" ) )

   if !Empty( cNumeroSerie )

      ::lCheckConsolidacion( cCodArt )

      /*
      Movimientos de almacén------------------------------------------------------
      */

      if ( ::cHisMovS )->( dbSeek( cCodArt + cCodAlm + cNumeroSerie ) )

         while ( ::cHisMovS )->cCodArt == cCodArt .and. ( ::cHisMovS )->cAlmOrd == cCodAlm .and. ( ::cHisMovS )->cNumSer == cNumeroSerie .and. !( ::cHisMovS )->( Eof() )

            if ( Empty( ::dConsolidacion ) .or. ( ::cHisMovS )->dFecRem >= ::dConsolidacion )

               if ( ::cHisMovS )->lUndNeg
                  nUnidades--
               else
                  nUnidades++
               end if

            end if

            ( ::cHisMovS )->( dbSkip() )

         end while

      end if

      /*
      Albaranes de proveedor------------------------------------------------------
      */

      if ( ::cAlbPrvS )->( dbSeek( cCodArt + cCodAlm + cNumeroSerie ) )

         while ( ::cAlbPrvS )->cRef == cCodArt .and. ( ::cAlbPrvS )->cAlmLin == cCodAlm .and. ( ::cAlbPrvS )->cNumSer == cNumeroSerie .and. !( ::cAlbPrvS )->( Eof() )

            if ( Empty( ::dConsolidacion ) .or. ( ::cAlbPrvS )->dFecAlb >= ::dConsolidacion )

               if ( ::cAlbPrvS )->lUndNeg
                  nUnidades--
               else
                  nUnidades++
               end if

            end if

            ( ::cAlbPrvS )->( dbSkip() )

         end while

      end if

      /*
      Facturas de proveedor-------------------------------------------------------
      */

      if ( ::cFacPrvS )->( dbSeek( cCodArt + cCodAlm + cNumeroSerie ) )

         while ( ::cFacPrvS )->cRef == cCodArt .and. ( ::cFacPrvS )->cAlmLin == cCodAlm .and. ( ::cFacPrvS )->cNumSer == cNumeroSerie .and. !( ::cFacPrvS )->( Eof() )

            if ( Empty( ::dConsolidacion ) .or. ( ::cFacPrvS )->dFecFac >= ::dConsolidacion )

               if ( ::cFacPrvS )->lUndNeg
                  nUnidades--
               else
                  nUnidades++
               end if

            end if

            ( ::cFacPrvS )->( dbSkip() )

         end while

      end if

      /*
      Facturas rectificativas de proveedor-------------------------------------------------------
      */

      if ( ::cRctPrvS )->( dbSeek( cCodArt + cCodAlm + cNumeroSerie ) )

         while ( ::cRctPrvS )->cRef == cCodArt .and. ( ::cRctPrvS )->cAlmLin == cCodAlm .and. ( ::cRctPrvS )->cNumSer == cNumeroSerie .and. !( ::cRctPrvS )->( Eof() )

            if ( Empty( ::dConsolidacion ) .or. ( ::cFacPrvS )->dFecFac >= ::dConsolidacion )

               if ( ::cRctPrvS )->lUndNeg
                  nUnidades--
               else
                  nUnidades++
               end if

            end if

            ( ::cRctPrvS )->( dbSkip() )

         end while

      end if

      /*
      Albaranes de clientes-------------------------------------------------------
      */

      if ( ::cAlbCliS )->( dbSeek( cCodArt + cCodAlm + cNumeroSerie ) )

         while ( ::cAlbCliS )->cRef == cCodArt .and. ( ::cAlbCliS )->cAlmLin == cCodAlm .and. ( ::cAlbCliS )->cNumSer == cNumeroSerie .and. !( ::cAlbCliS )->( Eof() )

            if ( Empty( ::dConsolidacion ) .or. ( ::cAlbCliS )->dFecAlb >= ::dConsolidacion )

               if ( ::cAlbCliS )->lUndNeg
                  nUnidades++
               else
                  nUnidades--
               end if

            end if

            ( ::cAlbCliS )->( dbSkip() )

         end while

      end if

      /*
      Facturas de clientes--------------------------------------------------------
      */

      if ( ::cFacCliS )->( dbSeek( cCodArt + cCodAlm + cNumeroSerie ) )

         while ( ::cFacCliS )->cRef == cCodArt .and. ( ::cFacCliS )->cAlmLin == cCodAlm .and. ( ::cFacCliS )->cNumSer == cNumeroSerie .and. !( ::cFacCliS )->( Eof() )

            if ( Empty( ::dConsolidacion ) .or. ( ::cFacCliS )->dFecFac >= ::dConsolidacion )

               if ( ::cFacCliS )->lUndNeg
                  nUnidades++
               else
                  nUnidades--
               end if

            end if

            ( ::cFacCliS )->( dbSkip() )

         end while

      end if

      /*
      Facturas rectificativas-----------------------------------------------------
      */

      if ( ::cFacRecS )->( dbSeek( cCodArt + cCodAlm + cNumeroSerie ) )

         while ( ::cFacRecS )->cRef == cCodArt .and. ( ::cFacRecS )->cAlmLin == cCodAlm .and. ( ::cFacRecS )->cNumSer == cNumeroSerie .and. !( ::cFacRecS )->( Eof() )

            if ( Empty( ::dConsolidacion ) .or. ( ::cFacRecS )->dFecFac >= ::dConsolidacion )

               if ( ::cFacRecS )->lUndNeg
                  nUnidades++
               else
                  nUnidades--
               end if

            end if

            ( ::cFacRecS )->( dbSkip() )

         end while

      end if

      /*
      Tickets de clientes normales------------------------------------------------
      */

      if ( ::cTikS )->( dbSeek( cCodArt + cCodAlm + cNumeroSerie ) )

         while ( ::cTikS )->cCbaTil == cCodArt .and. ( ::cTikS )->cAlmLin == cCodAlm .and. ( ::cTikS )->cNumSer == cNumeroSerie .and. !( ::cTikS )->( Eof() )

            if ( Empty( ::dConsolidacion ) .or. ( ::cTikS )->dFecTik >= ::dConsolidacion )

               if ( ::cTikS )->lUndNeg
                  nUnidades++
               else
                  nUnidades--
               end if

            end if

            ( ::cTikS )->( dbSkip() )

         end while

      end if

      /*
      Materiales producidos-------------------------------------------------------
      */

      if ( ::cProducS )->( dbSeek( cCodArt + cCodAlm + cNumeroSerie ) )

         while ( ::cProducS )->cCodArt == cCodArt .and. ( ::cProducS )->cAlmOrd == cCodAlm .and. ( ::cProducS )->cNumSer == cNumeroSerie .and. !( ::cProducS )->( Eof() )

            if ( Empty( ::dConsolidacion ) .or. ( ::cProducS )->dFecOrd >= ::dConsolidacion )

               if ( ::cProducS )->lUndNeg
                  nUnidades--
               else
                  nUnidades++
               end if

            end if

            ( ::cProducS )->( dbSkip() )

         end while

      end if

      /*
      Materias primas-------------------------------------------------------------
      */

      if ( ::cProducP )->( dbSeek( cCodArt + cCodAlm + cNumeroSerie ) )

         while ( ::cProducP )->cCodArt == cCodArt .and. ( ::cProducP )->cAlmOrd == cCodAlm .and. ( ::cProducP )->cNumSer == cNumeroSerie .and. !( ::cProducP )->( Eof() )

            if ( Empty( ::dConsolidacion ) .or. ( ::cProducP )->dFecOrd >= ::dConsolidacion )

               if ( ::cProducP )->lUndNeg
                  nUnidades++
               else
                  nUnidades--
               end if

            end if

            ( ::cProducP )->( dbSkip() )

         end while

      end if

   end if

   /*
   Comprobamos la marca de la empresa para no mostrar los valores cero --------
   */

   ( ::cHisMovT )->( OrdSetFocus( nOrdHisMov  ) )
   ( ::cAlbPrvS )->( OrdSetFocus( nOrdAlbPrvS ) )
   ( ::cFacPrvS )->( OrdSetFocus( nOrdFacPrvS ) )
   ( ::cRctPrvS )->( OrdSetFocus( nOrdRctPrvS ) )
   ( ::cAlbCliS )->( OrdSetFocus( nOrdAlbCliS ) )
   ( ::cFacCliS )->( OrdSetFocus( nOrdFacCliS ) )
   ( ::cFacRecS )->( OrdSetFocus( nOrdFacRecs ) )
   ( ::cTikS    )->( OrdSetFocus( nOrdTikCliS ) )
   ( ::cProducS )->( OrdSetFocus( nOrdProducS ) )
   ( ::cProducP )->( OrdSetFocus( nOrdProducP ) )
   ( ::cHisMovS )->( OrdSetFocus( nOrdHisMovS ) )

return ( nUnidades )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD aStockAlmacen( oRemMov ) CLASS TStock

   local cCodAlm
   local nOrdAnt
   local nOrdArt        := ( ::cArticulo     )->( OrdSetFocus( "Codigo"   ) )
   local nOrdAlbPrvL    := ( ::cAlbPrvL )->( OrdSetFocus( "cStkFast" ) )
   local nOrdFacPrvL    := ( ::cFacPrvL )->( OrdSetFocus( "cRef"     ) )
   local nOrdRctPrvL    := ( ::cRctPrvL )->( OrdSetFocus( "cRef"     ) )
   local nOrdAlbCliL    := ( ::cAlbCliL )->( OrdSetFocus( "cStkFast" ) )
   local nOrdFacCliL    := ( ::cFacCliL )->( OrdSetFocus( "cRef"     ) )
   local nOrdFacRecL    := ( ::cFacRecL )->( OrdSetFocus( "cRef"     ) )
   local nOrdTikCliL    := ( ::cTikL    )->( OrdSetFocus( "cStkFast" ) )
   local nOrdProducL    := ( ::cProducL )->( OrdSetFocus( "cCodArt"  ) )
   local nOrdProducM    := ( ::cProducM )->( OrdSetFocus( "cCodArt"  ) )
   local nOrdHisMov     := ( ::cHisMovT )->( OrdSetFocus( "cRefMov"  ) )

   cCodAlm              := oRemMov:oDbf:cAlmDes

   ( ::cArticulo )->( dbGoTop() )
   while !( ::cArticulo )->( eof() )

   if ( oRemMov:lFamilia      .or. ( ( ::cArticulo )->Familia >= oRemMov:cFamiliaInicio        .and. ( ::cArticulo )->Familia <= oRemMov:cFamiliaFin ) )      .and.;
      ( oRemMov:lTipoArticulo .or. ( ( ::cArticulo )->cCodTip >= oRemMov:cTipoArticuloInicio   .and. ( ::cArticulo )->cCodTip <= oRemMov:cTipoArticuloFin ) ) .and.;
      ( oRemMov:lArticulo     .or. ( ( ::cArticulo )->Codigo >= oRemMov:cArticuloInicio        .and. ( ::cArticulo )->Codigo <= oRemMov:cArticuloFin ) )

      /*
      Albaranes de proveedor------------------------------------------------------
      */

         if ( ::cAlbPrvL )->( dbSeek( ( ::cArticulo )->Codigo ) )

            while ( ::cAlbPrvL )->cRef == ( ::cArticulo )->Codigo .and. !( ::cAlbPrvL )->( Eof() )

               if ( ::cAlbPrvL )->nCtlStk < 2            .and.;
                  ( ::cAlbPrvL )->cAlmLin == cCodAlm

                  with object ( SStock():New() )
                     :cCodigo             := ( ::cAlbPrvL )->cRef
                     :cCodigoPropiedad1   := ( ::cAlbPrvL )->cCodPr1
                     :cCodigoPropiedad2   := ( ::cAlbPrvL )->cCodPr2
                     :cValorPropiedad1    := ( ::cAlbPrvL )->cValPr1
                     :cValorPropiedad2    := ( ::cAlbPrvL )->cValPr2
                     :cLote               := ( ::cAlbPrvL )->cLote
                     :nUnidades           := nTotNAlbPrv( ::cAlbPrvL )
                     ::Integra( hb_QWith() )
                  end with

               end if

               ( ::cAlbPrvL )->( dbSkip() )

            end while

         end if

         /*
         Facturas de proveedor-------------------------------------------------------
         */

         SysRefresh()

         if ( ::cFacPrvL )->( dbSeek( ( ::cArticulo )->Codigo ) )

            while ( ::cFacPrvL )->cRef == ( ::cArticulo )->Codigo .and. !( ::cFacPrvL )->( Eof() )

               if ( ::cFacPrvL )->nCtlStk < 2            .and.;
                  ( ::cFacPrvL )->cAlmLin == cCodAlm

                  with object ( SStock():New() )
                     :cCodigo             := ( ::cFacPrvL )->cRef
                     :cCodigoPropiedad1   := ( ::cFacPrvL )->cCodPr1
                     :cCodigoPropiedad2   := ( ::cFacPrvL )->cCodPr2
                     :cValorPropiedad1    := ( ::cFacPrvL )->cValPr1
                     :cValorPropiedad2    := ( ::cFacPrvL )->cValPr2
                     :cLote               := ( ::cFacPrvL )->cLote
                     :nUnidades           := nTotNFacPrv( ::cFacPrvL )
                     ::Integra( hb_QWith() )
                  end with

               end if

               ( ::cFacPrvL )->( dbSkip() )

            end while

         end if

         /*
         Facturas rectificativas de proveedor-------------------------------------------------------
         */

         SysRefresh()

         if ( ::cRctPrvL )->( dbSeek( ( ::cArticulo )->Codigo ) )

            while ( ::cRctPrvL )->cRef == ( ::cArticulo )->Codigo .and. !( ::cRctPrvL )->( Eof() )

               if ( ::cRctPrvL )->nCtlStk < 2            .and.;
                  ( ::cRctPrvL )->cAlmLin == cCodAlm

                  with object ( SStock():New() )
                     :cCodigo             := ( ::cRctPrvL )->cRef
                     :cCodigoPropiedad1   := ( ::cRctPrvL )->cCodPr1
                     :cCodigoPropiedad2   := ( ::cRctPrvL )->cCodPr2
                     :cValorPropiedad1    := ( ::cRctPrvL )->cValPr1
                     :cValorPropiedad2    := ( ::cRctPrvL )->cValPr2
                     :cLote               := ( ::cRctPrvL )->cLote
                     :nUnidades           := nTotNRctPrv( ::cRctPrvL )
                     ::Integra( hb_QWith() )
                  end with

               end if

               ( ::cRctPrvL )->( dbSkip() )

            end while

         end if

         /*
         Albaranes de clientes-------------------------------------------------------
         */

         SysRefresh()

         if ( ::cAlbCliL )->( dbSeek( ( ::cArticulo )->Codigo ) )

            while ( ::cAlbCliL )->cRef == ( ::cArticulo )->Codigo .and. !( ::cAlbCliL )->( Eof() )

               if ( ::cAlbCliL )->nCtlStk < 2            .and.;
                  ( ::cAlbCliL )->cAlmLin == cCodAlm

                  with object ( SStock():New() )
                     :cCodigo             := ( ::cAlbCliL )->cRef
                     :cCodigoPropiedad1   := ( ::cAlbPrvL )->cCodPr1
                     :cCodigoPropiedad2   := ( ::cAlbPrvL )->cCodPr2
                     :cValorPropiedad1    := ( ::cAlbCliL )->cValPr1
                     :cValorPropiedad2    := ( ::cAlbCliL )->cValPr2
                     :cLote               := ( ::cAlbCliL )->cLote
                     :nUnidades           := - nTotVAlbCli( ::cAlbCliL )
                     ::Integra( hb_QWith() )
                  end with

               end if

               ( ::cAlbCliL )->( dbSkip() )

            end while

         end if

         /*
         Facturas de clientes--------------------------------------------------------
         */

         SysRefresh()

         if ( ::cFacCliL )->( dbSeek( ( ::cArticulo )->Codigo ) )

            while ( ::cFacCliL )->cRef == ( ::cArticulo )->Codigo .and. !( ::cFacCliL )->( Eof() )

               if ( ::cFacCliL )->nCtlStk < 2            .and.;
                  ( ::cFacCliL )->cAlmLin == cCodAlm

                  with object ( SStock():New() )
                     :cCodigo             := ( ::cFacCliL )->cRef
                     :cCodigoPropiedad1   := ( ::cFacCliL )->cCodPr1
                     :cCodigoPropiedad2   := ( ::cFacCliL )->cCodPr2
                     :cValorPropiedad1    := ( ::cFacCliL )->cValPr1
                     :cValorPropiedad2    := ( ::cFacCliL )->cValPr2
                     :cLote               := ( ::cFacCliL )->cLote
                     :nUnidades           := - nTotVFacCli( ::cFacCliL )   // - nTotNFacCli( ::cFacCliL )
                     ::Integra( hb_QWith() )
                  end with

               end if

               ( ::cFacCliL )->( dbSkip() )

            end while

         end if

         /*
         Facturas rectificativas-----------------------------------------------------
         */

         SysRefresh()

         if ( ::cFacRecL )->( dbSeek( ( ::cArticulo )->Codigo ) )

            while ( ::cFacRecL )->cRef == ( ::cArticulo )->Codigo .and. !( ::cFacRecL )->( Eof() )

               if ( ::cFacRecL )->nCtlStk < 2            .and.;
                  ( ::cFacRecL )->cAlmLin == cCodAlm

                  with object ( SStock():New() )
                     :cCodigo             := ( ::cFacRecL )->cRef
                     :cCodigoPropiedad1   := ( ::cFacRecL )->cCodPr1
                     :cCodigoPropiedad2   := ( ::cFacRecL )->cCodPr2
                     :cValorPropiedad1    := ( ::cFacRecL )->cValPr1
                     :cValorPropiedad2    := ( ::cFacRecL )->cValPr2
                     :cLote               := ( ::cFacRecL )->cLote
                     :nUnidades           := - nTotVFacRec( ::cFacRecL )
                     ::Integra( hb_QWith() )
                  end with

               end if

               ( ::cFacRecL )->( dbSkip() )

            end while

         end if

         /*
         Tickets de clientes normales------------------------------------------------
         */

         SysRefresh()

         if ( ::cTikL )->( dbSeek( ( ::cArticulo )->Codigo ) )

            while ( ::cTikL )->cCbaTil == ( ::cArticulo )->Codigo .and. !( ::cTikL )->( Eof() )

               if ( ::cTikL )->nCtlStk < 2            .and.;
                  ( ::cTikL )->cAlmLin == cCodAlm

                  if ( ::cTikL )->cTipTil == SAVTIK .or. ( ::cTikL )->cTipTil == SAVAPT

                     with object ( SStock():New() )
                        :cCodigo             := ( ::cTikL )->cCbaTil
                        :cCodigoPropiedad1   := ( ::cTikL )->cCodPr1
                        :cCodigoPropiedad2   := ( ::cTikL )->cCodPr2
                        :cValorPropiedad1    := ( ::cTikL )->cValPr1
                        :cValorPropiedad2    := ( ::cTikL )->cValPr2
                        :cLote               := ( ::cTikL )->cLote
                        :nUnidades           := - nTotVTikTpv( ::cTikL )
                        ::Integra( hb_QWith() )
                     end with

                  else

                     with object ( SStock():New() )
                        :cCodigo             := ( ::cTikL )->cCbaTil
                        :cCodigoPropiedad1   := ( ::cTikL )->cCodPr1
                        :cCodigoPropiedad2   := ( ::cTikL )->cCodPr2
                        :cValorPropiedad1    := ( ::cTikL )->cValPr1
                        :cValorPropiedad2    := ( ::cTikL )->cValPr2
                        :cLote               := ( ::cTikL )->cLote
                        :nUnidades           := nTotVTikTpv( ::cTikL )
                        ::Integra( hb_QWith() )
                     end with

                  end if

               end if

               ( ::cTikL )->( dbSkip() )

            end while

         end if

         /*
         Tickets de clientes combinados----------------------------------------------
         */

         SysRefresh()

         ( ::cTikL )->( dbGoTop() )

         nOrdAnt              := ( ::cTikL )->( OrdSetFocus( "CSTKCOM" ) )

         if ( ::cTikL )->( dbSeek( ( ::cArticulo )->Codigo ) )

            if !Empty( ( ::cTikL )->cComTil )

               while ( ::cTikL )->cComTil == ( ::cArticulo )->Codigo .and. !( ::cTikL )->( Eof() )

                  if ( ::cTikL )->nCtlStk < 2            .and.;
                     ( ::cTikL )->cAlmLim == cCodAlm

                     with object ( SStock():New() )
                        :cCodigo             := ( ::cTikL )->cCbaTil
                        :cCodigoPropiedad1   := ( ::cTikL )->cCodPr1
                        :cCodigoPropiedad2   := ( ::cTikL )->cCodPr2
                        :cValorPropiedad1    := ( ::cTikL )->cValPr1
                        :cValorPropiedad2    := ( ::cTikL )->cValPr2
                        :cLote               := ( ::cTikL )->cLote
                        :nUnidades           := - nTotVTikTpv( ::cTikL )
                        ::Integra( hb_QWith() )
                     end with

                  end if

                  ( ::cTikL )->( dbSkip() )

               end while

            end if

         end if

         ( ::cTikL )->( OrdSetFocus( nOrdAnt ) )

         /*
         Materiales producidos-------------------------------------------------------
         */

         SysRefresh()

         if ( ::cProducL )->( dbSeek( ( ::cArticulo )->Codigo ) )

            while ( ::cProducL )->cCodArt == ( ::cArticulo )->Codigo .and. !( ::cProducL )->( Eof() )

               if ( ::cProducL )->cAlmOrd == cCodAlm

                  with object ( SStock():New() )
                     :cCodigo             := ( ::cProducL )->cCodArt
                     :cCodigoPropiedad1   := ( ::cProducL )->cCodPr1
                     :cCodigoPropiedad2   := ( ::cProducL )->cCodPr2
                     :cValorPropiedad1    := ( ::cProducL )->cValPr1
                     :cValorPropiedad2    := ( ::cProducL )->cValPr2
                     :cLote               := ( ::cProducL )->cLote
                     :nUnidades           := nTotNProduccion( ::cProducL )
                     ::Integra( hb_QWith() )
                  end with

               end if

               ( ::cProducL )->( dbSkip() )

            end while

         end if

         /*
         Materias primas-------------------------------------------------------------
         */

         SysRefresh()

         if ( ::cProducM )->( dbSeek( ( ::cArticulo )->Codigo ) )

            while ( ::cProducM )->cCodArt == ( ::cArticulo )->Codigo .and. !( ::cProducM )->( Eof() )

               if ( ::cProducM )->cAlmOrd == cCodAlm

                  with object ( SStock():New() )
                     :cCodigo             := ( ::cProducM )->cCodArt
                     :cCodigoPropiedad1   := ( ::cProducM )->cCodPr1
                     :cCodigoPropiedad2   := ( ::cProducM )->cCodPr2
                     :cValorPropiedad1    := ( ::cProducM )->cValPr1
                     :cValorPropiedad2    := ( ::cProducM )->cValPr2
                     :cLote               := ( ::cProducM )->cLote
                     :nUnidades           := - nTotNMaterial( ::cProducM )
                     ::Integra( hb_QWith() )
                  end with

               end if

               ( ::cProducM )->( dbSkip() )

            end while

         end if

         /*
         Movimientos de almacén------------------------------------------------------
         */

         SysRefresh()

         if ( ::cHisMovT)->( dbSeek( ( ::cArticulo )->Codigo ) )

            while ( ::cHisMovT)->cRefMov == ( ::cArticulo )->Codigo .and. !( ::cHisMovT)->( Eof() )

               if !Empty( ( ::cHisMovT)->cAliMov ) .and. ( ::cHisMovT)->cAliMov == cCodAlm

                  with object ( SStock():New() )
                     :cCodigo             := ( ::cHisMovT)->cRefMov
                     :cCodigoPropiedad1   := ( ::cHisMovT)->cCodPr1
                     :cCodigoPropiedad2   := ( ::cHisMovT)->cCodPr2
                     :cValorPropiedad1    := ( ::cHisMovT)->cValPr1
                     :cValorPropiedad2    := ( ::cHisMovT)->cValPr2
                     :cLote               := ( ::cHisMovT)->cLote
                     :nUnidades           := nTotNMovAlm( ::cHisMovT)
                     ::Integra( hb_QWith() )
                  end with

               end if

               if !Empty( ( ::cHisMovT)->cAloMov ) .and. ( ::cHisMovT)->cAloMov == cCodAlm

                  with object ( SStock():New() )
                     :cCodigo             := ( ::cHisMovT)->cRefMov
                     :cCodigoPropiedad1   := ( ::cHisMovT)->cCodPr1
                     :cCodigoPropiedad2   := ( ::cHisMovT)->cCodPr2
                     :cValorPropiedad1    := ( ::cHisMovT)->cValPr1
                     :cValorPropiedad2    := ( ::cHisMovT)->cValPr2
                     :cLote               := ( ::cHisMovT)->cLote
                     :nUnidades           := - nTotNMovAlm( ::cHisMovT)
                     ::Integra( hb_QWith() )
                  end with

               end if

               ( ::cHisMovT)->( dbSkip() )

            end while

         end if

      end if

      ( ::cArticulo )->( dbSkip() )

      oRemMov:oMtrStock:AutoInc()

   end while

   /*
   Comprobamos la marca de la empresa para no mostrar los valores cero --------
   */

   ( ::cArticulo     )->( OrdSetFocus( nOrdArt     ) )
   ( ::cAlbPrvL )->( OrdSetFocus( nOrdAlbPrvL ) )
   ( ::cFacPrvL )->( OrdSetFocus( nOrdFacPrvL ) )
   ( ::cRctPrvL )->( OrdSetFocus( nOrdRctPrvL ) )
   ( ::cAlbCliL )->( OrdSetFocus( nOrdAlbCliL ) )
   ( ::cFacCliL )->( OrdSetFocus( nOrdFacCliL ) )
   ( ::cFacRecL )->( OrdSetFocus( nOrdFacRecL ) )
   ( ::cTikL    )->( OrdSetFocus( nOrdTikCliL ) )
   ( ::cProducL )->( OrdSetFocus( nOrdProducL ) )
   ( ::cProducM )->( OrdSetFocus( nOrdProducM ) )
   ( ::cHisMovT )->( OrdSetFocus( nOrdHisMov  ) )

return ( ::aStocks )

//---------------------------------------------------------------------------//

Method Integra( sStocks, lLote, lNumeroSerie ) CLASS TStock

   local nPos
   local cNumeroSerie
   local aNumeroSerie

   DEFAULT lLote        := .t.
   DEFAULT lNumeroSerie := .t.

   /*
   if lNumeroSerie .and. !Empty( sStocks:cNumeroSerie )

      aNumeroSerie      := hb_aTokens( sStocks:cNumeroSerie, "," )

      for each cNumeroSerie in aNumeroSerie

         if sStocks:nUnidades > 0
            sStocks:nUnidades := 1
         else
            sStocks:nUnidades := -1
         end if

         sStocks:cNumeroSerie := cNumeroSerie

         nPos           := aScan( ::aStocks, {|o| o:cCodigo == sStocks:cCodigo .and. o:cCodigoAlmacen == sStocks:cCodigoAlmacen .and. o:cValorPropiedad1 == sStocks:cValorPropiedad1 .and. o:cValorPropiedad2 == sStocks:cValorPropiedad2 .and. if( lLote, o:cLote == sStocks:cLote, .t. ) .and. if( lNumeroSerie, o:cNumeroSerie == sStocks:cNumeroSerie, .t. ) } )
         if nPos != 0
            ::aStocks[ nPos ]:nUnidades            += sStocks:nUnidades
            ::aStocks[ nPos ]:nPendientesRecibir   += sStocks:nPendientesRecibir
            ::aStocks[ nPos ]:nPendientesEntregar  += sStocks:nPendientesEntregar
         else
            aAdd( ::aStocks, oClone( sStocks ) )
         end if

      next

   else
   */

      nPos              := aScan( ::aStocks, {|o| o:cCodigo == sStocks:cCodigo .and. o:cCodigoAlmacen == sStocks:cCodigoAlmacen .and. o:cValorPropiedad1 == sStocks:cValorPropiedad1 .and. o:cValorPropiedad2 == sStocks:cValorPropiedad2 .and. if( lLote, o:cLote == sStocks:cLote, .t. ) .and. if( lNumeroSerie, o:cNumeroSerie == sStocks:cNumeroSerie, .t. ) } )
      if nPos != 0
         ::aStocks[ nPos ]:nUnidades               += sStocks:nUnidades
         ::aStocks[ nPos ]:nPendientesRecibir      += sStocks:nPendientesRecibir
         ::aStocks[ nPos ]:nPendientesEntregar     += sStocks:nPendientesEntregar
      else
         aAdd( ::aStocks, oClone( sStocks ) )
      end if

   /*
   end if
   */

Return ( nil )

//---------------------------------------------------------------------------//

METHOD lValidNumeroSerie( cCodArt, cCodAlm, uNumSer, lMessage )

   local lValid         := .f.

   DEFAULT lMessage     := .t.

   if !Empty( uNumSer )
      lValid            := ( ::nStockSerie( cCodArt, cCodAlm, uNumSer ) > 0 )
   end if

return ( lValid )

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
         :bStrData         := {|| if( !Empty( oBrw:aArrayData ), oBrw:aArrayData[ oBrw:nArrayAt ]:cNumeroSerie, "" ) }
         :nWidth           := 200
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Stock"
         :bStrData         := {|| if( !Empty( oBrw:aArrayData ), Trans( oBrw:aArrayData[ oBrw:nArrayAt ]:nUnidades, MasUnd() ), 0 ) }
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Prp. 1"
         :bStrData         := {|| if( !Empty( oBrw:aArrayData ), oBrw:aArrayData[ oBrw:nArrayAt ]:cValorPropiedad1, "" ) }
         :nWidth           := 60
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Prp. 2"
         :bStrData         := {|| if( !Empty( oBrw:aArrayData ), oBrw:aArrayData[ oBrw:nArrayAt ]:cValorPropiedad2, "" ) }
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

Return ( uRet )

//---------------------------------------------------------------------------//

Method nRiesgo( cCodigoCliente )

   local nRec
   local nOrd
   local oBlock
   local nRiesgo     := 0

   if Empty( cCodigoCliente )
      Return ( nRiesgo )
   end if

   if AllTrim( cCodigoCliente ) == AllTrim( cDefCli() )
      Return ( nRiesgo )
   end if

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   nRec              := ( ::cAlbCliT )->( Recno() )
   nOrd              := ( ::cAlbCliT )->( OrdSetFocus( "lCodCli" ) )

   if ( ::cAlbCliT )->( dbSeek( cCodigoCliente ) )

      while ( Alltrim( ( ::cAlbCliT )->cCodCli ) == Alltrim( cCodigoCliente ) ) .and. !( ::cAlbCliT )->( Eof() )

         nRiesgo     += ( ::cAlbCliT )->nTotAlb - ( ::cAlbCliT )->nTotPag

         ( ::cAlbCliT )->( dbSkip() )

         SysRefresh()

      end while

   end if

   ( ::cAlbCliT )->( OrdSetFocus( nOrd ) )
   ( ::cAlbCliT )->( dbGoTo( nRec ) )

   // Pagos no cobrados en facturas--------------------------------------------

   nRec              := ( ::cFacCliP )->( Recno() )
   nOrd              := ( ::cFacCliP )->( OrdSetFocus( "lCodCli" ) )

   if ( ::cFacCliP )->( dbSeek( cCodigoCliente ) )

      while ( Alltrim( ( ::cFacCliP )->cCodCli ) == Alltrim( cCodigoCliente ) ) .and. !( ::cFacCliP )->( Eof() )

         nRiesgo     += ( ::cFacCliP )->nImporte

         ( ::cFacCliP )->( dbSkip() )

         SysRefresh()

      end while

   end if

   ( ::cFacCliP )->( OrdSetFocus( nOrd ) )
   ( ::cFacCliP )->( dbGoTo( nRec ) )

   // Anticipos no liquidados-------------------------------------------------

   nRec              := ( ::cAntCliT )->( Recno() )
   nOrd              := ( ::cAntCliT )->( OrdSetFocus( "lCodCli" ) )

   if ( ::cAntCliT )->( dbSeek( cCodigoCliente ) )

      while ( Alltrim( ( ::cAntCliT )->cCodCli ) == Alltrim( cCodigoCliente ) ) .and. !( ::cAntCliT )->( Eof() )

         nRiesgo     -= ( ::cAntCliT )->nTotAnt

         ( ::cAntCliT )->( dbSkip() )

         SysRefresh()

      end while

   end if

   ( ::cAntCliT )->( OrdSetFocus( nOrd ) )
   ( ::cAntCliT )->( dbGoTo( nRec ) )

   // Pagos no cobrados en facturas---------------------------------------------------

   nRec              := ( ::cTikT )->( Recno() )
   nOrd              := ( ::cTikT )->( OrdSetFocus( "lCliTik" ) )

   if ( ::cTikT )->( dbSeek( cCodigoCliente ) )

      while ( Alltrim( ( ::cTikT )->cCliTik ) == Alltrim( cCodigoCliente ) ) .and. !( ::cTikT )->( Eof() )

         nRiesgo     += ( ( ::cTikT )->nTotTik - ( ::cTikT )->nCobTik )

         ( ::cTikT )->( dbSkip() )

         SysRefresh()

      end while

   end if

   ( ::cTikT )->( OrdSetFocus( nOrd ) )
   ( ::cTikT )->( dbGoTo( nRec ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( nRiesgo )

//---------------------------------------------------------------------------//

Method SetRiesgo( cCodigoCliente, oGetRiesgo, nRiesgoCliente, lAviso )

   local nRiesgo  := ::nRiesgo( cCodigoCliente )

   DEFAULT lAviso := uFieldEmpresa( "lSalPdt" , .f. )

   if IsObject( oGetRiesgo )

      oGetRiesgo:cText( nRiesgo )

      if IsNum( nRiesgoCliente )

         if ( nRiesgo > nRiesgoCliente )
            oGetRiesgo:SetColor( Rgb( 255, 255, 255 ), Rgb( 255, 0, 0 ) )
         else
            oGetRiesgo:SetColor( Rgb( 0, 0, 0 ), Rgb( 255, 255, 255 ) )
         end if

         oGetRiesgo:Refresh()

         if lAviso
            msgStop( "El riesgo alacanzado es de " + Alltrim( Trans( nRiesgo, cPorDiv() ) ) + "; sobre el establecido en su ficha " + Alltrim( Trans( nRiesgoCliente, cPorDiv() ) ) + ".",;
                     "El riesgo del cliente supera el límite establecido" )

         end if

      end if

   end if

Return ( nRiesgo )

//---------------------------------------------------------------------------//

METHOD lCheckConsolidacion( cCodArt, cCodAlm, cCodPrp1, cCodPrp2, cValPrp1, cValPrp2, cLote, dFecha )

   local lCheck         := .f.
   local nRec           := ( ::cHisMovT)->( Recno() )

   DEFAULT cCodAlm      := Space( 3 )  
   DEFAULT cCodPrp1     := Space( 10 )
   DEFAULT cCodPrp2     := Space( 10 )
   DEFAULT cValPrp1     := Space( 10 )
   DEFAULT cValPrp2     := Space( 10 )
   DEFAULT cLote        := Space( 12 )

   ::dConsolidacion     := nil

   if dbSeekInOrd( cCodArt + cCodAlm + cCodPrp1 + cCodPrp2 + cValPrp1 + cValPrp2 + cLote, "cStock", ::cHisMovT)

      while ( ::cHisMovT)->cRefMov == cCodArt .and. !( ::cHisMovT)->( Eof() )

         if ( ::cHisMovT)->nTipMov == 4

            if Empty( ::dConsolidacion )

               ::dConsolidacion     := ( ::cHisMovT)->dFecMov

            else

               if ( ::cHisMovT)->dFecMov > ::dConsolidacion
                  ::dConsolidacion  := ( ::cHisMovT)->dFecMov
               end if

            end if

         end if

         ( ::cHisMovT)->( dbSkip() )

      end while

   end if

   ( ::cHisMovT)->( dbGoTo( nRec ) )

   lCheck    := ( Empty( ::dConsolidacion ) .or. dFecha >= ::dConsolidacion )

Return ( lCheck )

//---------------------------------------------------------------------------//


Static Function SeekOnStock( cSeek, oBrw )

   local nAt

   nAt               := aScan( oBrw:aArrayData, {|o| Alltrim( Upper( cValToChar( o:cNumeroSerie ) ) ) == Alltrim( Upper( cSeek ) ) } )
   if nAt > 0
      oBrw:nArrayAt  := nAt
   endif

   oBrw:Refresh()

Return ( .t. )

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

Return ( .t. )

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
   DATA dConsolidacion        INIT Ctod( "" )
   DATA cCodigoAlmacen        INIT ""
   DATA cNombreAlmacen        INIT ""
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

   INLINE METHOD New()

      ::cCodigo               := ""
      ::cCodigoAlmacen        := ""
      ::cNombreAlmacen        := ""
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

      RETURN ( Self )

   ENDMETHOD

   INLINE METHOD Say()

      RETURN ( "Alias"                    + ::cAlias                                + "," + ;
               "Codigo"                   + ::cCodigo                               + "," + ;
               "CodigoAlmacen"            + ::cCodigoAlmacen                        + "," + ;
               "NombreAlmacen"            + ::cNombreAlmacen                        + "," + ;
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

   ENDMETHOD

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

/*
Actualiza los stocks de almacen
*/

FUNCTION putStock( cCodArt, cCodAlm, nUni, dbfMov, cTipMov )

   DEFAULT cCodAlm   := oUser():cAlmacen()
   DEFAULT cTipMov   := "MV"

	IF empty( cCodArt )
		RETURN .T.
	END IF

	IF nUni == 0
		RETURN .T.
	END IF

   /*
   Tenemos que buscar al menos un movimeinto
   */

   IF ( dbfMov )->( dbSeek( cCodArt + cCodAlm + cTipMov ) )
      IF dbLock( dbfMov )
         ( dbfMov )->nStock   += nUni
         ( dbfMov )->( dbUnlock() )
      END IF
	ELSE
		( dbfMov )->( dbAppend() )
		( dbfMov )->CCODART 	:= cCodArt
		( dbfMov )->CCODALM 	:= cCodAlm
      ( dbfMov )->CREFMOV  := cTipMov
		( dbfMov )->NSTOCK  	:= nUni
	END IF

RETURN .T.

//---------------------------------------------------------------------------//

/*
Devuelve el stock actual
*/

FUNCTION retStock( cCodArt, cCodAlm, dbfMov )

   local nRet  := 0

   DEFAULT cCodAlm   := oUser():cAlmacen()

	IF empty( cCodArt )
      nRet  := 0
	END IF

	IF ( dbfMov )->( dbSeek( cCodArt + cCodAlm ) )
      while ( dbfMov )->CCODART + ( dbfMov )->CCODALM == cCodArt + cCodAlm .AND. !( dbfMov )->( eof() )
         nRet  += ( dbfMov )->NSTOCK
         ( dbfMov )->( dbSkip() )
      end do
	END IF

RETURN nRet

//---------------------------------------------------------------------------//

FUNCTION objStock( cCodArt, cCodAlm, oGetStk, dbfMov )

	IF oGetStk != NIL
		oGetStk:cText( retStock( cCodArt, cCodAlm, dbfMov ) )
	END IF

RETURN .T.

//---------------------------------------------------------------------------//

FUNCTION ActStock( cCodAlm, dbfLine, bCondicion, lInc, lDel, dbfArticulo, dbfMov )

	local nUnits

   DEFAULT cCodAlm   := oUser():cAlmacen()
	DEFAULT lInc 		:= .T.
	DEFAULT lDel 		:= .T.

	WHILE Eval( bCondicion ) .AND. !(dbfLine)->( eof() )

      IF !empty( rtrim( (dbfLine)->CCBATIL ) ) .AND. ( dbfArticulo )->( DBSeek( (dbfLine)->CCBATIL ) )

         nUnits   := (dbfLine)->NUNTTIL

         IF !lInc
            nUnits := - nUnits
         END IF

         IF ( dbfMov )->( dbSeek( ( dbfArticulo )->CODIGO + cCodAlm + "MV" ) )
            IF dblock( dbfMov )
               ( dbfMov )->NSTOCK  += nUnits
               ( dbfMov )->( dbUnlock() )
            END IF
         ELSE
            ( dbfMov )->( dbAppend() )
            ( dbfMov )->CCODART := ( dbfArticulo )->CODIGO
				( dbfMov )->CREFMOV := "MV"
            ( dbfMov )->CCODALM := cCodAlm
            ( dbfMov )->NSTOCK  := nUnits
         END IF

      END IF

      /*
      Segunda linea de detalle para productos combinados_______________________
      */

      IF !empty( rtrim( (dbfLine)->CCOMTIL ) ) .AND. ( dbfArticulo )->( DBSeek( (dbfLine)->CCOMTIL ) )

         nUnits   := (dbfLine)->NUNTTIL

         IF !lInc
            nUnits := - nUnits
         END IF

         IF ( dbfMov )->( dbSeek( ( dbfArticulo )->CODIGO + cCodAlm + "MV" ) )
            IF dbLock( dbfMov )
               ( dbfMov )->NSTOCK  += nUnits
               ( dbfMov )->( dbUnlock() )
            END IF
         ELSE
            ( dbfMov )->( dbAppend() )
            ( dbfMov )->CCODART := ( dbfArticulo )->CODIGO
				( dbfMov )->CREFMOV := "MV"
            ( dbfMov )->CCODALM := cCodAlm
            ( dbfMov )->NSTOCK  := nUnits
         END IF

      END IF

      IF lDel .and. dbLock( dbfLine )
         ( dbfLine )->( dbDelete() )
         ( dbfLine )->( dbUnLock() )
      END IF

      ( dbfLine )->( dbSkip() )

   END DO

RETURN .T.

//---------------------------------------------------------------------------//
/*
Devuelve el total stock de almacen
*/

FUNCTION nTotStock( dbfMov, cCodArt, aGet, cCodAlm )

	local bCond
   local nUnits   := 0
   local nRecno   := ( dbfMov )->( RecNo() )

	IF !Empty( cCodAlm )
      bCond       := {|| cCodAlm == ( dbfMov )->CCODALM }
	ELSE
      bCond       := {|| .T. }
	END IF

	IF ( dbfMov )->( dbSeek( cCodArt ) )

		WHILE ( dbfMov )->CCODART == cCodArt .AND. ( dbfMov )->( !eof() )

			IF eval( bCond )
            nUnits += ( dbfMov )->NSTKACT
			END IF

			( dbfMov )->( dbSkip() )

      END DO

	END IF

	( dbfMov )->( dbGoTo( nRecno ) )

	IF aGet != NIL
		aGet:SetText( nUnits )
	END IF

RETURN ( nUnits )

//---------------------------------------------------------------------------//
//
// Funcion especial para el TPV puede traer dos articulos por linea
//

FUNCTION ActTpvStk( cCodAlm, dbfLine, bCondicion, lInc, lDel, dbfArticulo, dbfMov )

	local nUnits

   DEFAULT cCodAlm   := oUser():cAlmacen()
	DEFAULT lInc 		:= .T.
	DEFAULT lDel 		:= .T.

	WHILE Eval( bCondicion ) .AND. !(dbfLine)->( eof() )

      IF !empty( rtrim( (dbfLine)->CCBATIL ) ) .AND. ( dbfArticulo )->( DBSeek( (dbfLine)->CCBATIL ) )

         nUnits   := (dbfLine)->NUNTTIL

         IF !lInc
            nUnits := - nUnits
         END IF

         IF ( dbfMov )->( dbSeek( ( dbfArticulo )->CODIGO + cCodAlm + "MV" ) )
            IF dbLock( dbfMov )
               ( dbfMov )->NSTOCK  += nUnits
               ( dbfMov )->( dbUnlock() )
            END IF
         ELSE
            ( dbfMov )->( dbAppend() )
            ( dbfMov )->CCODART := ( dbfArticulo )->CODIGO
				( dbfMov )->CREFMOV := "MV"
            ( dbfMov )->CCODALM := cCodAlm
            ( dbfMov )->NSTOCK  := nUnits
         END IF

      END IF

      IF lDel .and. dbLock( dbfLine )
         ( dbfLine )->( dbDelete() )
         ( dbfLine )->( dbUnLock() )
      END IF

      ( dbfLine )->( dbSkip() )

   END DO

RETURN .T.

Function ScanInSerie( cMemoSerie, cNumeroSerie )

   // aScan( hb_aTokens( cMemoSerie, "," ), cNumeroSerie ) != 0 )

   ? "memo:" + ( "," + cMemoSerie )
   ? "seri:" + ( "," + Alltrim( cNumeroSerie ) + "," )
   ? At( "," + cMemoSerie, "," + Alltrim( cNumeroSerie ) + "," ) != 0

Return ( At( "," + cMemoSerie, "," + Alltrim( cNumeroSerie ) + "," ) != 0 )