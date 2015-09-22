#include "c:\fw195\gestool\bin\include\Factu.ch"

static nView
static lOpenFiles       := .f.
static cSerieImportar   := "C"

//---------------------------------------------------------------------------//

function InicioHRB()

   /*
   Abrimos los ficheros necesarios---------------------------------------------
   */

   if !OpenFiles( .f. )
      return .f.
   end if

   CursorWait()
   
   ImportaAlbaranes()

   EliminaFacturas()

   Msginfo( "Importación realizada con éxito" )

   CursorWe()

   /*
   Cerramos los ficheros abiertos anteriormente--------------------------------
   */

   CloseFiles()

return .t.

//---------------------------------------------------------------------------//

static function OpenFiles()

   local oError
   local oBlock

   if lOpenFiles
      MsgStop( 'Imposible abrir ficheros' )
      Return ( .f. )
   end if

   CursorWait()

   oBlock               := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      lOpenFiles        := .t.

      nView             := D():CreateView()

      D():AlbaranesClientes( nView )
      D():AlbaranesClientesLineas( nView )
      D():FacturasClientes( nView )
      D():FacturasClientesLineas( nView )
      D():FacturasClientesCobros( nView )

   RECOVER USING oError

      lOpenFiles           := .f.

      msgStop( ErrorMessage( oError ), 'Imposible abrir las bases de datos' )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpenFiles
      CloseFiles()
   end if

   CursorWE()

return ( lOpenFiles )

//---------------------------------------------------------------------------//

static function CloseFiles()

   D():DeleteView( nView )

   lOpenFiles     := .f.

RETURN ( .t. )

//----------------------------------------------------------------------------//

static function ImportaAlbaranes()

   while !( D():FacturasClientes( nView ) )->( Eof() )

      if ( D():FacturasClientes( nView ) )->cSerie == cSerieImportar .and.;
         !( D():AlbaranesClientes( nView ) )->( dbSeek( ( D():FacturasClientes( nView ) )->cSerie + Str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac ) )

            ( D():AlbaranesClientes( nView ) )->( dbAppend() )

            ( D():AlbaranesClientes( nView ) )->CSERALB        := ( D():FacturasClientes( nView ) )->cSerie
            ( D():AlbaranesClientes( nView ) )->NNUMALB        := ( D():FacturasClientes( nView ) )->nNumFac
            ( D():AlbaranesClientes( nView ) )->CSUFALB        := ( D():FacturasClientes( nView ) )->cSufFac
            ( D():AlbaranesClientes( nView ) )->CTURALB        := ( D():FacturasClientes( nView ) )->cTurFac
            ( D():AlbaranesClientes( nView ) )->DFECALB        := ( D():FacturasClientes( nView ) )->dFecFac
            ( D():AlbaranesClientes( nView ) )->CCODCLI        := ( D():FacturasClientes( nView ) )->cCodCli
            ( D():AlbaranesClientes( nView ) )->CCODALM        := ( D():FacturasClientes( nView ) )->cCodAlm
            ( D():AlbaranesClientes( nView ) )->CCODCAJ        := ( D():FacturasClientes( nView ) )->cCodCaj
            ( D():AlbaranesClientes( nView ) )->CNOMCLI        := ( D():FacturasClientes( nView ) )->cNomCli
            ( D():AlbaranesClientes( nView ) )->CDIRCLI        := ( D():FacturasClientes( nView ) )->cDirCli
            ( D():AlbaranesClientes( nView ) )->CPOBCLI        := ( D():FacturasClientes( nView ) )->cPobCli
            ( D():AlbaranesClientes( nView ) )->CPRVCLI        := ( D():FacturasClientes( nView ) )->cPrvCli
            ( D():AlbaranesClientes( nView ) )->CPOSCLI        := ( D():FacturasClientes( nView ) )->cPosCli
            ( D():AlbaranesClientes( nView ) )->CDNICLI        := ( D():FacturasClientes( nView ) )->cDniCli
            ( D():AlbaranesClientes( nView ) )->LMODCLI        := ( D():FacturasClientes( nView ) )->lModCli
            ( D():AlbaranesClientes( nView ) )->LFACTURADO     := .f.
            ( D():AlbaranesClientes( nView ) )->lEntregado     := .f.
            ( D():AlbaranesClientes( nView ) )->CCONDENT       := ( D():FacturasClientes( nView ) )->cCondent
            ( D():AlbaranesClientes( nView ) )->MCOMENT        := ( D():FacturasClientes( nView ) )->mComent
            ( D():AlbaranesClientes( nView ) )->MOBSERV        := ( D():FacturasClientes( nView ) )->mObserv
            ( D():AlbaranesClientes( nView ) )->CCODPAGO       := ( D():FacturasClientes( nView ) )->cCodPago
            ( D():AlbaranesClientes( nView ) )->NBULTOS        := ( D():FacturasClientes( nView ) )->nBultos
            ( D():AlbaranesClientes( nView ) )->NPORTES        := ( D():FacturasClientes( nView ) )->nPortes
            ( D():AlbaranesClientes( nView ) )->CCODAGE        := ( D():FacturasClientes( nView ) )->cCodAge
            ( D():AlbaranesClientes( nView ) )->CCODOBR        := ( D():FacturasClientes( nView ) )->cCodObr
            ( D():AlbaranesClientes( nView ) )->CCODTAR        := ( D():FacturasClientes( nView ) )->cCodTar
            ( D():AlbaranesClientes( nView ) )->CCODRUT        := ( D():FacturasClientes( nView ) )->cCodRut
            ( D():AlbaranesClientes( nView ) )->NTARIFA        := ( D():FacturasClientes( nView ) )->nTarifa
            ( D():AlbaranesClientes( nView ) )->CDTOESP        := ( D():FacturasClientes( nView ) )->cDtoEsp
            ( D():AlbaranesClientes( nView ) )->NDTOESP        := ( D():FacturasClientes( nView ) )->nDtoEsp
            ( D():AlbaranesClientes( nView ) )->CDPP           := ( D():FacturasClientes( nView ) )->cDpp
            ( D():AlbaranesClientes( nView ) )->NDPP           := ( D():FacturasClientes( nView ) )->nDpp
            ( D():AlbaranesClientes( nView ) )->CDTOUNO        := ( D():FacturasClientes( nView ) )->cDtoUno
            ( D():AlbaranesClientes( nView ) )->NDTOUNO        := ( D():FacturasClientes( nView ) )->nDtoUno
            ( D():AlbaranesClientes( nView ) )->CDTODOS        := ( D():FacturasClientes( nView ) )->cDtoDos
            ( D():AlbaranesClientes( nView ) )->NDTODOS        := ( D():FacturasClientes( nView ) )->nDtoDos
            ( D():AlbaranesClientes( nView ) )->LRECARGO       := ( D():FacturasClientes( nView ) )->lRecargo
            ( D():AlbaranesClientes( nView ) )->CDIVALB        := ( D():FacturasClientes( nView ) )->cDivFac
            ( D():AlbaranesClientes( nView ) )->NVDVALB        := ( D():FacturasClientes( nView ) )->nVdvFac
            ( D():AlbaranesClientes( nView ) )->CRETPOR        := ( D():FacturasClientes( nView ) )->cRetPor
            ( D():AlbaranesClientes( nView ) )->CRETMAT        := ( D():FacturasClientes( nView ) )->cRetMat
            ( D():AlbaranesClientes( nView ) )->LIVAINC        := ( D():FacturasClientes( nView ) )->lIvaInc
            ( D():AlbaranesClientes( nView ) )->NREGIVA        := ( D():FacturasClientes( nView ) )->nRegIva
            ( D():AlbaranesClientes( nView ) )->NIVAMAN        := ( D():FacturasClientes( nView ) )->nIvaMan
            ( D():AlbaranesClientes( nView ) )->NMANOBR        := ( D():FacturasClientes( nView ) )->nManObr
            ( D():AlbaranesClientes( nView ) )->cCodTrn        := ( D():FacturasClientes( nView ) )->cCodTrn
            ( D():AlbaranesClientes( nView ) )->nKgsTrn        := ( D():FacturasClientes( nView ) )->nKgsTrn
            ( D():AlbaranesClientes( nView ) )->cCodUsr        := ( D():FacturasClientes( nView ) )->cCodUsr
            ( D():AlbaranesClientes( nView ) )->dFecCre        := ( D():FacturasClientes( nView ) )->dFecCre
            ( D():AlbaranesClientes( nView ) )->cTimCre        := ( D():FacturasClientes( nView ) )->cTimCre
            ( D():AlbaranesClientes( nView ) )->cCodGrp        := ( D():FacturasClientes( nView ) )->cCodGrp
            ( D():AlbaranesClientes( nView ) )->lImprimido     := ( D():FacturasClientes( nView ) )->lImprimido
            ( D():AlbaranesClientes( nView ) )->dFecImp        := ( D():FacturasClientes( nView ) )->dFecImp
            ( D():AlbaranesClientes( nView ) )->cHorImp        := ( D():FacturasClientes( nView ) )->cHorImp
            ( D():AlbaranesClientes( nView ) )->cCodDlg        := ( D():FacturasClientes( nView ) )->cCodDlg
            ( D():AlbaranesClientes( nView ) )->nDtoAtp        := ( D():FacturasClientes( nView ) )->nDtoAtp
            ( D():AlbaranesClientes( nView ) )->nSbrAtp        := ( D():FacturasClientes( nView ) )->nSbrAtp
            ( D():AlbaranesClientes( nView ) )->cManObr        := ( D():FacturasClientes( nView ) )->cManObr
            ( D():AlbaranesClientes( nView ) )->cTlfCli        := ( D():FacturasClientes( nView ) )->cTlfCli
            ( D():AlbaranesClientes( nView ) )->nTotNet        := ( D():FacturasClientes( nView ) )->nTotNet
            ( D():AlbaranesClientes( nView ) )->nTotIva        := ( D():FacturasClientes( nView ) )->nTotIva
            ( D():AlbaranesClientes( nView ) )->nTotReq        := ( D():FacturasClientes( nView ) )->nTotReq
            ( D():AlbaranesClientes( nView ) )->nTotAlb        := ( D():FacturasClientes( nView ) )->nTotFac
            ( D():AlbaranesClientes( nView ) )->lOperPV        := ( D():FacturasClientes( nView ) )->lOperPv
            ( D():AlbaranesClientes( nView ) )->cBanco         := ( D():FacturasClientes( nView ) )->cBanco
            ( D():AlbaranesClientes( nView ) )->cPaisIBAN      := ( D():FacturasClientes( nView ) )->cPaisIBAN
            ( D():AlbaranesClientes( nView ) )->cCtrlIBAN      := ( D():FacturasClientes( nView ) )->cCtrlIBAN
            ( D():AlbaranesClientes( nView ) )->cEntBnc        := ( D():FacturasClientes( nView ) )->cEntBnc
            ( D():AlbaranesClientes( nView ) )->cSucBnc        := ( D():FacturasClientes( nView ) )->cSucBnc
            ( D():AlbaranesClientes( nView ) )->cDigBnc        := ( D():FacturasClientes( nView ) )->cDigBnc
            ( D():AlbaranesClientes( nView ) )->cCtaBnc        := ( D():FacturasClientes( nView ) )->cCtaBnc
            ( D():AlbaranesClientes( nView ) )->nDtoTarifa     := ( D():FacturasClientes( nView ) )->nDtoTarifa
            ( D():AlbaranesClientes( nView ) )->nFacturado     := 1

            ( D():AlbaranesClientes( nView ) )->( dbUnlock() )

            /*
            Añadimos ahora las lineas------------------------------------------
            */

            if ( D():FacturasClientesLineas( nView ) )->( dbSeek( ( D():FacturasClientes( nView ) )->cSerie + Str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac ) )

               while ( D():FacturasClientes( nView ) )->cSerie + Str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac == ( D():FacturasClientesLineas( nView ) )->cSerie + Str( ( D():FacturasClientesLineas( nView ) )->nNumFac ) + ( D():FacturasClientesLineas( nView ) )->cSufFac .and.;
                     !( D():FacturasClientesLineas( nView ) )->( Eof() )

                     ( D():AlbaranesClientesLineas( nView ) )->( dbAppend() )

                     ( D():AlbaranesClientesLineas( nView ) )->cSerAlb     := ( D():FacturasClientesLineas( nView ) )->cSerie
                     ( D():AlbaranesClientesLineas( nView ) )->nNumAlb     := ( D():FacturasClientesLineas( nView ) )->nNumFac
                     ( D():AlbaranesClientesLineas( nView ) )->cSufAlb     := ( D():FacturasClientesLineas( nView ) )->cSufFac
                     ( D():AlbaranesClientesLineas( nView ) )->cRef        := ( D():FacturasClientesLineas( nView ) )->cRef
                     ( D():AlbaranesClientesLineas( nView ) )->cDetalle    := ( D():FacturasClientesLineas( nView ) )->cDetalle
                     ( D():AlbaranesClientesLineas( nView ) )->nPreUnit    := ( D():FacturasClientesLineas( nView ) )->nPreUnit
                     ( D():AlbaranesClientesLineas( nView ) )->nPntVer     := ( D():FacturasClientesLineas( nView ) )->nPntVer
                     ( D():AlbaranesClientesLineas( nView ) )->nImpTrn     := ( D():FacturasClientesLineas( nView ) )->nImpTrn
                     ( D():AlbaranesClientesLineas( nView ) )->nDto        := ( D():FacturasClientesLineas( nView ) )->nDto
                     ( D():AlbaranesClientesLineas( nView ) )->nDtoPrm     := ( D():FacturasClientesLineas( nView ) )->nDtoPrm
                     ( D():AlbaranesClientesLineas( nView ) )->nIva        := ( D():FacturasClientesLineas( nView ) )->nIva
                     ( D():AlbaranesClientesLineas( nView ) )->lControl    := ( D():FacturasClientesLineas( nView ) )->lControl
                     ( D():AlbaranesClientesLineas( nView ) )->nPesoKg     := ( D():FacturasClientesLineas( nView ) )->nPesoKg
                     ( D():AlbaranesClientesLineas( nView ) )->cPesoKg     := ( D():FacturasClientesLineas( nView ) )->cPesoKg
                     ( D():AlbaranesClientesLineas( nView ) )->cUnidad     := ( D():FacturasClientesLineas( nView ) )->cUnidad
                     ( D():AlbaranesClientesLineas( nView ) )->nComAge     := ( D():FacturasClientesLineas( nView ) )->nComAge
                     ( D():AlbaranesClientesLineas( nView ) )->nUniCaja    := ( D():FacturasClientesLineas( nView ) )->nUniCaja
                     ( D():AlbaranesClientesLineas( nView ) )->nUndKit     := ( D():FacturasClientesLineas( nView ) )->nUndKit
                     ( D():AlbaranesClientesLineas( nView ) )->dFecha      := ( D():FacturasClientesLineas( nView ) )->dFecha
                     ( D():AlbaranesClientesLineas( nView ) )->cTipMov     := ( D():FacturasClientesLineas( nView ) )->cTipMov
                     ( D():AlbaranesClientesLineas( nView ) )->mLngDes     := ( D():FacturasClientesLineas( nView ) )->mLngDes
                     ( D():AlbaranesClientesLineas( nView ) )->lTotLin     := ( D():FacturasClientesLineas( nView ) )->lTotLin
                     ( D():AlbaranesClientesLineas( nView ) )->lImpLin     := ( D():FacturasClientesLineas( nView ) )->lImpLin
                     ( D():AlbaranesClientesLineas( nView ) )->cCodPr1     := ( D():FacturasClientesLineas( nView ) )->cCodPr1
                     ( D():AlbaranesClientesLineas( nView ) )->cCodPr2     := ( D():FacturasClientesLineas( nView ) )->cCodPr2
                     ( D():AlbaranesClientesLineas( nView ) )->cValPr1     := ( D():FacturasClientesLineas( nView ) )->cValPr1
                     ( D():AlbaranesClientesLineas( nView ) )->cValPr2     := ( D():FacturasClientesLineas( nView ) )->cValPr2
                     ( D():AlbaranesClientesLineas( nView ) )->nFacCnv     := ( D():FacturasClientesLineas( nView ) )->nFacCnv
                     ( D():AlbaranesClientesLineas( nView ) )->nDtoDiv     := ( D():FacturasClientesLineas( nView ) )->nDtoDiv
                     ( D():AlbaranesClientesLineas( nView ) )->nNumLin     := ( D():FacturasClientesLineas( nView ) )->nNumLin
                     ( D():AlbaranesClientesLineas( nView ) )->nCtlStk     := ( D():FacturasClientesLineas( nView ) )->nCtlStk
                     ( D():AlbaranesClientesLineas( nView ) )->nCosDiv     := ( D():FacturasClientesLineas( nView ) )->nCosDiv
                     ( D():AlbaranesClientesLineas( nView ) )->nPvpRec     := ( D():FacturasClientesLineas( nView ) )->nPvpRec
                     ( D():AlbaranesClientesLineas( nView ) )->cAlmLin     := ( D():FacturasClientesLineas( nView ) )->cAlmLin 
                     ( D():AlbaranesClientesLineas( nView ) )->lIvaLin     := ( D():FacturasClientesLineas( nView ) )->lIvaLin
                     ( D():AlbaranesClientesLineas( nView ) )->nValImp     := ( D():FacturasClientesLineas( nView ) )->nValImp
                     ( D():AlbaranesClientesLineas( nView ) )->cCodImp     := ( D():FacturasClientesLineas( nView ) )->cCodImp
                     ( D():AlbaranesClientesLineas( nView ) )->lLote       := ( D():FacturasClientesLineas( nView ) )->lLote
                     ( D():AlbaranesClientesLineas( nView ) )->nLote       := ( D():FacturasClientesLineas( nView ) )->nLote
                     ( D():AlbaranesClientesLineas( nView ) )->cLote       := ( D():FacturasClientesLineas( nView ) )->cLote
                     ( D():AlbaranesClientesLineas( nView ) )->dFecCad     := ( D():FacturasClientesLineas( nView ) )->dFecCad
                     ( D():AlbaranesClientesLineas( nView ) )->lKitArt     := ( D():FacturasClientesLineas( nView ) )->lKitArt
                     ( D():AlbaranesClientesLineas( nView ) )->lKitChl     := ( D():FacturasClientesLineas( nView ) )->lKitChl
                     ( D():AlbaranesClientesLineas( nView ) )->lKitPrc     := ( D():FacturasClientesLineas( nView ) )->lKitPrc
                     ( D():AlbaranesClientesLineas( nView ) )->nMesGrt     := ( D():FacturasClientesLineas( nView ) )->nMesGrt
                     ( D():AlbaranesClientesLineas( nView ) )->lMsgVta     := ( D():FacturasClientesLineas( nView ) )->lMsgVta
                     ( D():AlbaranesClientesLineas( nView ) )->lNotVta     := ( D():FacturasClientesLineas( nView ) )->lNotVta
                     ( D():AlbaranesClientesLineas( nView ) )->cCodTip     := ( D():FacturasClientesLineas( nView ) )->cCodTip
                     ( D():AlbaranesClientesLineas( nView ) )->cCodFam     := ( D():FacturasClientesLineas( nView ) )->cCodFam
                     ( D():AlbaranesClientesLineas( nView ) )->cGrpFam     := ( D():FacturasClientesLineas( nView ) )->cGrpFam
                     ( D():AlbaranesClientesLineas( nView ) )->nReq        := ( D():FacturasClientesLineas( nView ) )->nReq
                     ( D():AlbaranesClientesLineas( nView ) )->mObsLin     := ( D():FacturasClientesLineas( nView ) )->mObsLin
                     ( D():AlbaranesClientesLineas( nView ) )->cCodPrv     := ( D():FacturasClientesLineas( nView ) )->cCodPrv
                     ( D():AlbaranesClientesLineas( nView ) )->cNomPrv     := ( D():FacturasClientesLineas( nView ) )->cNomPrv
                     ( D():AlbaranesClientesLineas( nView ) )->cImagen     := ( D():FacturasClientesLineas( nView ) )->cImagen
                     ( D():AlbaranesClientesLineas( nView ) )->cRefPrv     := ( D():FacturasClientesLineas( nView ) )->cRefPrv
                     ( D():AlbaranesClientesLineas( nView ) )->nVolumen    := ( D():FacturasClientesLineas( nView ) )->nVolumen
                     ( D():AlbaranesClientesLineas( nView ) )->cVolumen    := ( D():FacturasClientesLineas( nView ) )->cVolumen
                     ( D():AlbaranesClientesLineas( nView ) )->nNumMed     := ( D():FacturasClientesLineas( nView ) )->nNumMed
                     ( D():AlbaranesClientesLineas( nView ) )->nMedUno     := ( D():FacturasClientesLineas( nView ) )->nMedUno
                     ( D():AlbaranesClientesLineas( nView ) )->nMedDos     := ( D():FacturasClientesLineas( nView ) )->nMedDos
                     ( D():AlbaranesClientesLineas( nView ) )->nMedTre     := ( D():FacturasClientesLineas( nView ) )->nMedTre
                     ( D():AlbaranesClientesLineas( nView ) )->nTarLin     := ( D():FacturasClientesLineas( nView ) )->nTarLin
                     ( D():AlbaranesClientesLineas( nView ) )->Descrip     := ( D():FacturasClientesLineas( nView ) )->Descrip
                     ( D():AlbaranesClientesLineas( nView ) )->LFACTURADO  := .f.

                     ( D():AlbaranesClientesLineas( nView ) )->( dbUnlock() )

                     ( D():FacturasClientesLineas( nView ) )->( dbSkip() )

               end while

            end if

      end if

      ( D():FacturasClientes( nView ) )->( dbSkip() )

   end while

Return .t.

//---------------------------------------------------------------------------//

static function EliminaFacturas()

   ( D():FacturasClientes( nView ) )->( dbGoTop() )

   while !( D():FacturasClientes( nView ) )->( Eof() )

      if ( D():FacturasClientes( nView ) )->cSerie == cSerieImportar

         if dbLock( D():FacturasClientes( nView ) )
            ( D():FacturasClientes( nView ) )->( dbDelete() )
            ( D():FacturasClientes( nView ) )->( dbUnLock() )
         end if

      end if

      ( D():FacturasClientes( nView ) )->( dbSkip() )

   end while

   ( D():FacturasClientesLineas( nView ) )->( dbGoTop() )

   while !( D():FacturasClientesLineas( nView ) )->( Eof() )

      if ( D():FacturasClientesLineas( nView ) )->cSerie == cSerieImportar

         if dbLock( D():FacturasClientesLineas( nView ) )
            ( D():FacturasClientesLineas( nView ) )->( dbDelete() )
            ( D():FacturasClientesLineas( nView ) )->( dbUnLock() )
         end if

      end if

      ( D():FacturasClientesLineas( nView ) )->( dbSkip() )

   end while

   ( D():FacturasClientesCobros( nView ) )->( dbGoTop() )

   while !( D():FacturasClientesCobros( nView ) )->( Eof() )

      if ( D():FacturasClientesCobros( nView ) )->cSerie == cSerieImportar

         if dbLock( D():FacturasClientesCobros( nView ) )
            ( D():FacturasClientesCobros( nView ) )->( dbDelete() )
            ( D():FacturasClientesCobros( nView ) )->( dbUnLock() )
         end if

      end if

      ( D():FacturasClientesCobros( nView ) )->( dbSkip() )

   end while

Return .t.

//---------------------------------------------------------------------------//