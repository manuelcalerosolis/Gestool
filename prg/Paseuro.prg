
function PasEuro( oWndBrw, oWnd )

   local oDlg
   local oPag
   local oBtnPrv
   local oBtnNxt
   local aoMeter  := Array( 7 )
   local anMeter  := Array( 7 )

   /*
   Seleccionamos la empresa
   */

   SetEmpresa( (dbfEmp)->CodEmp, oWndBrw:oBrw )

   if ( dbfEmp )->cDivEmp == "EUR"
      MsgStop( "Empresa ya convertida" )
      return .f.
   end if

   /*
   Dialogo---------------------------------------------------------------------
   */

   DEFINE DIALOG oDlg RESOURCE "ASS_EURO"

   REDEFINE PAGES oPag ID 110 OF oDlg ;
      DIALOGS "ASS_EURO01", "ASS_EURO02"

   /*
   Segunda caja de dialogo-----------------------------------------------------
   */

 REDEFINE APOLOMETER aoMeter[ 1 ] VAR anMeter[ 1 ] ;
         ID       100 ;
         OF       oPag:aDialogs[ 2 ]

 REDEFINE APOLOMETER aoMeter[ 2 ] VAR anMeter[ 2 ] ;
         ID       110 ;
         OF       oPag:aDialogs[ 2 ]

 REDEFINE APOLOMETER aoMeter[ 3 ] VAR anMeter[ 3 ] ;
         ID       120 ;
         OF       oPag:aDialogs[ 2 ]

 REDEFINE APOLOMETER aoMeter[ 4 ] VAR anMeter[ 4 ] ;
         ID       130 ;
         OF       oPag:aDialogs[ 2 ]

 REDEFINE APOLOMETER aoMeter[ 5 ] VAR anMeter[ 5 ] ;
         ID       140 ;
         OF       oPag:aDialogs[ 2 ]

 REDEFINE APOLOMETER aoMeter[ 6 ] VAR anMeter[ 6 ] ;
         ID       150 ;
         OF       oPag:aDialogs[ 2 ]

 REDEFINE APOLOMETER aoMeter[ 7 ] VAR anMeter[ 7 ] ;
         ID       160 ;
         OF       oPag:aDialogs[ 2 ]

   /*
   Botones caja de dialogo-----------------------------------------------------
   */

   REDEFINE BUTTON oBtnPrv ;                         // Boton de Anterior
         ID       401 ;
         OF       oDlg ;
         ACTION   ( IntBtnPrv( oPag, oBtnPrv, oBtnNxt, aoMeter, oDlg ) )

   REDEFINE BUTTON oBtnNxt ;                         // Boton de Siguiente
         ID       402 ;
         OF       oDlg ;
         ACTION   ( IntBtnNxt( oPag, oBtnPrv, oBtnNxt, aoMeter, oDlg ) )

   REDEFINE BUTTON ;                         // Boton de salida
         ID       403 ;
         OF       oDlg ;
         ACTION   ( oDlg:end() )

   ACTIVATE DIALOG oDlg CENTER ON INIT ( oBtnPrv:Hide() )

   /*
   Cerramos los temporales
   */

return nil

//---------------------------------------------------------------------------//

static function IntBtnPrv( oPag, oBtnPrv, oBtnNxt, aoMeter, oDlg )

   oPag:GoPrev()
   SetWindowText( oBtnNxt:hWnd, "Siguien&te" )

return nil

//---------------------------------------------------------------------------//

static function IntBtnNxt( oPag, oBtnPrv, oBtnNxt, aoMeter, oDlg )

   do case
      case oPag:nOption == 1
         oPag:GoNext()
         oBtnPrv:Show()
         SetWindowText( oBtnNxt:hWnd, "&Proceder" )
      case oPag:nOption == 2
         CnvEuro( aoMeter )
         msgInfo( "Proceso finalizado con exito." + CRLF + ;
                  "Bienvenido a la moneda unica.",;
                  "Pasaporte al Euro" )
         oDlg:End()
   end case

return nil

//---------------------------------------------------------------------------//

static function CnvEuro( aoMeter )

   local dbfTmp
   local nDec     := nDouDiv( ( dbfEmp )->cDivChg, dbfDiv )
   local nChg     := nChgDiv( ( dbfEmp )->cDivEmp, dbfDiv )

   USE ( cPatEmp() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfTmp ) )
   SET ADSINDEX TO ( cPatEmp() + "ARTICULO.CDX" ) ADDITIVE

   aoMeter[ 1 ]:nTotal  := ( dbfTmp )->( LastRec() )

   while !( dbfTmp )->( eof() )

      if dbDialogLock( dbfTmp )
         ( dbfTmp )->PCOSTO    := Round( ( dbfTmp )->PCOSTO   / nChg, nDec )
         ( dbfTmp )->PVENTA1   := Round( ( dbfTmp )->PVENTA1  / nChg, nDec )
         ( dbfTmp )->PVENTA2   := Round( ( dbfTmp )->PVENTA2  / nChg, nDec )
         ( dbfTmp )->PVENTA3   := Round( ( dbfTmp )->PVENTA3  / nChg, nDec )
         ( dbfTmp )->PVENTA4   := Round( ( dbfTmp )->PVENTA4  / nChg, nDec )
         ( dbfTmp )->PVENTA5   := Round( ( dbfTmp )->PVENTA5  / nChg, nDec )
         ( dbfTmp )->PVENTA6   := Round( ( dbfTmp )->PVENTA6  / nChg, nDec )
         ( dbfTmp )->PVTAIVA1  := Round( ( dbfTmp )->PVTAIVA1 / nChg, nDec )
         ( dbfTmp )->PVTAIVA2  := Round( ( dbfTmp )->PVTAIVA2 / nChg, nDec )
         ( dbfTmp )->PVTAIVA3  := Round( ( dbfTmp )->PVTAIVA3 / nChg, nDec )
         ( dbfTmp )->PVTAIVA4  := Round( ( dbfTmp )->PVTAIVA4 / nChg, nDec )
         ( dbfTmp )->PVTAIVA5  := Round( ( dbfTmp )->PVTAIVA5 / nChg, nDec )
         ( dbfTmp )->PVTAIVA6  := Round( ( dbfTmp )->PVTAIVA6 / nChg, nDec )
         ( dbfTmp )->NPNTVER1  := Round( ( dbfTmp )->NPNTVER1 / nChg, nDec )
         ( dbfTmp )->NPNVIVA1  := Round( ( dbfTmp )->NPNVIVA1 / nChg, nDec )
         ( dbfTmp )->PVPREC    := Round( ( dbfTmp )->PVPREC   / nChg, nDec )
      end if

      aoMeter[ 1 ]:Set( ( dbfTmp )->( OrdKeyNo() ) )

      ( dbfTmp )->( dbSkip() )

   end while

   CLOSE ( dbfTmp )

   /*
   Cambiamos los precios por propiedades---------------------------------------
   */

   USE ( cPatEmp() + "ARTDIV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTDIV", @dbfTmp ) )
   SET ADSINDEX TO ( cPatEmp() + "ARTDIV.CDX" ) ADDITIVE

   aoMeter[ 2 ]:nTotal  := ( dbfTmp )->( LastRec() )

   while !( dbfTmp )->( eof() )

      if dbDialogLock( dbfTmp )
         ( dbfTmp )->nPreVta1  := Round( ( dbfTmp )->nPreVta1 / nChg, nDec )
         ( dbfTmp )->nPreVta2  := Round( ( dbfTmp )->nPreVta2 / nChg, nDec )
         ( dbfTmp )->nPreVta3  := Round( ( dbfTmp )->nPreVta3 / nChg, nDec )
         ( dbfTmp )->nPreVta4  := Round( ( dbfTmp )->nPreVta4 / nChg, nDec )
         ( dbfTmp )->nPreVta5  := Round( ( dbfTmp )->nPreVta5 / nChg, nDec )
         ( dbfTmp )->nPreVta6  := Round( ( dbfTmp )->nPreVta6 / nChg, nDec )
         ( dbfTmp )->nPreIva1  := Round( ( dbfTmp )->nPreIva1 / nChg, nDec )
         ( dbfTmp )->nPreIva2  := Round( ( dbfTmp )->nPreIva2 / nChg, nDec )
         ( dbfTmp )->nPreIva3  := Round( ( dbfTmp )->nPreIva3 / nChg, nDec )
         ( dbfTmp )->nPreIva4  := Round( ( dbfTmp )->nPreIva4 / nChg, nDec )
         ( dbfTmp )->nPreIva5  := Round( ( dbfTmp )->nPreIva5 / nChg, nDec )
         ( dbfTmp )->nPreIva6  := Round( ( dbfTmp )->nPreIva6 / nChg, nDec )
      end if

      aoMeter[ 2 ]:Set( ( dbfTmp )->( OrdKeyNo() ) )

      ( dbfTmp )->( dbSkip() )

   end while

   CLOSE ( dbfTmp )

   /*
   Cambiamos los precios en tarifas personalizadas-----------------------------
   */

   USE ( cPatEmp() + "TARPREL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TARPREL", @dbfTmp ) )
   SET ADSINDEX TO ( cPatEmp() + "TARPREL.CDX" ) ADDITIVE

   aoMeter[ 3 ]:nTotal  := ( dbfTmp )->( LastRec() )

   while !( dbfTmp )->( eof() )

      if dbDialogLock( dbfTmp )
         ( dbfTmp )->nPrcTar1  := Round( ( dbfTmp )->nPrcTar1 / nChg, nDec )
         ( dbfTmp )->nPrcTar2  := Round( ( dbfTmp )->nPrcTar2 / nChg, nDec )
         ( dbfTmp )->nPrcTar3  := Round( ( dbfTmp )->nPrcTar3 / nChg, nDec )
         ( dbfTmp )->nPrcTar4  := Round( ( dbfTmp )->nPrcTar4 / nChg, nDec )
         ( dbfTmp )->nPrcTar5  := Round( ( dbfTmp )->nPrcTar5 / nChg, nDec )
         ( dbfTmp )->nPrcTar6  := Round( ( dbfTmp )->nPrcTar6 / nChg, nDec )
         ( dbfTmp )->nPntArt   := Round( ( dbfTmp )->nPntArt  / nChg, nDec )
      end if

      aoMeter[ 3 ]:Set( ( dbfTmp )->( OrdKeyNo() ) )

      ( dbfTmp )->( dbSkip() )

   end while

   CLOSE ( dbfTmp )

   /*
   Cambio de los datos en la empresa-------------------------------------------
   */

   USE ( cPatEmp() + "CLIATP.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIATP", @dbfTmp ) )
   SET ADSINDEX TO ( cPatEmp() + "CLIATP.CDX" ) ADDITIVE

   aoMeter[ 4 ]:nTotal  := ( dbfTmp )->( LastRec() )

   while !( dbfTmp )->( eof() )

      if dbDialogLock( dbfTmp )
         ( dbfTmp )->nPrcArt   := Round( ( dbfTmp )->nPrcArt / nChg, nDec )
      end if

      aoMeter[ 4 ]:Set( ( dbfTmp )->( OrdKeyNo() ) )

      ( dbfTmp )->( dbSkip() )

   end while

   CLOSE ( dbfTmp )

   /*
   Cambio de los datos en la empresa-------------------------------------------
   */

   USE ( cPatEmp() + "FPAGO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FPAGO", @dbfTmp ) )
   SET ADSINDEX TO ( cPatEmp() + "FPAGO.CDX" ) ADDITIVE

   aoMeter[ 5 ]:nTotal  := ( dbfTmp )->( LastRec() )

   while !( dbfTmp )->( eof() )

      if dbDialogLock( dbfTmp )
         ( dbfTmp )->nImpApl  := Round( ( dbfTmp )->nImpApl / nChg, nDec )
      end if

      aoMeter[ 5 ]:Set( ( dbfTmp )->( OrdKeyNo() ) )

      ( dbfTmp )->( dbSkip() )

   end while

   CLOSE ( dbfTmp )

   /*
   Cambio de los datos en la empresa-------------------------------------------
   */

   USE ( cPatEmp() + "OFERTA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "OFERTA", @dbfTmp ) )
   SET ADSINDEX TO ( cPatEmp() + "OFERTA.CDX" ) ADDITIVE

   aoMeter[ 6 ]:nTotal  := ( dbfTmp )->( LastRec() )

   while !( dbfTmp )->( eof() )

      if dbDialogLock( dbfTmp )
         ( dbfTmp )->nPreOfe1  := Round( ( dbfTmp )->nPreOfe1 / nChg, nDec )
         ( dbfTmp )->nPreOfe2  := Round( ( dbfTmp )->nPreOfe2 / nChg, nDec )
         ( dbfTmp )->nPreOfe3  := Round( ( dbfTmp )->nPreOfe3 / nChg, nDec )
         ( dbfTmp )->nPreOfe4  := Round( ( dbfTmp )->nPreOfe4 / nChg, nDec )
         ( dbfTmp )->nPreOfe5  := Round( ( dbfTmp )->nPreOfe5 / nChg, nDec )
         ( dbfTmp )->nPreOfe6  := Round( ( dbfTmp )->nPreOfe6 / nChg, nDec )
         ( dbfTmp )->nPreIva1  := Round( ( dbfTmp )->nPreIva1 / nChg, nDec )
         ( dbfTmp )->nPreIva2  := Round( ( dbfTmp )->nPreIva2 / nChg, nDec )
         ( dbfTmp )->nPreIva3  := Round( ( dbfTmp )->nPreIva3 / nChg, nDec )
         ( dbfTmp )->nPreIva4  := Round( ( dbfTmp )->nPreIva4 / nChg, nDec )
         ( dbfTmp )->nPreIva5  := Round( ( dbfTmp )->nPreIva5 / nChg, nDec )
         ( dbfTmp )->nPreIva6  := Round( ( dbfTmp )->nPreIva6 / nChg, nDec )
      end if

      aoMeter[ 6 ]:Set( ( dbfTmp )->( OrdKeyNo() ) )

      ( dbfTmp )->( dbSkip() )

   end while

   CLOSE ( dbfTmp )

   /*
   Cambio de los datos en la empresa-------------------------------------------
   */

   USE ( cPatEmp() + "PROVART.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROVART", @dbfTmp ) )
   SET ADSINDEX TO ( cPatEmp() + "PROVART.CDX" ) ADDITIVE

   aoMeter[ 7 ]:nTotal  := ( dbfTmp )->( LastRec() )

   while !( dbfTmp )->( eof() )

      if dbDialogLock( dbfTmp )
         ( dbfTmp )->nImpPrv   := Round( ( dbfTmp )->nImpPrv / nChg, nDec )
      end if

      aoMeter[ 7 ]:Set( ( dbfTmp )->( OrdKeyNo() ) )

      ( dbfTmp )->( dbSkip() )

   end while

   CLOSE ( dbfTmp )

   /*
   Cambio de los datos en la empresa-------------------------------------------
   */

   if dbDialogLock( dbfEmp )
      ( dbfEmp )->cDivEmp := "EUR"
      ( dbfEmp )->cDivChg := "PTS"
      cDivEmp( ( dbfEmp )->cDivEmp )
      cDivChg( ( dbfEmp )->cDivChg )
   end if

return nil

//---------------------------------------------------------------------------//