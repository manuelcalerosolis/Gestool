#include "FiveWin.Ch"
#include "Factu.ch"
#include "Report.ch"

/*
Definici¢n de la base de datos de Existencias
*/

#define _NNUMEXT                  (dbfExtAgeT)->( FieldPos( "NNUMEXT" ) )
#define _DFECEXT                  (dbfExtAgeT)->( FieldPos( "DFECEXT" ) )
#define _CCODALM                  (dbfExtAgeT)->( FieldPos( "CCODALM" ) )
#define _CNOMALM                  (dbfExtAgeT)->( FieldPos( "CNOMALM" ) )
#define _CDIRALM                  (dbfExtAgeT)->( FieldPos( "CDIRALM" ) )
#define _CPOBALM                  (dbfExtAgeT)->( FieldPos( "CPOBALM" ) )
#define _CPRVALM                  (dbfExtAgeT)->( FieldPos( "CPRVALM" ) )
#define _CPOSALM                  (dbfExtAgeT)->( FieldPos( "CPOSALM" ) )
#define _LLIQEXT                  (dbfExtAgeT)->( FieldPos( "LLIQEXT" ) )
#define _CCODPGO                  (dbfExtAgeT)->( FieldPos( "CCODPGO" ) )
#define _NBULTOS                  (dbfExtAgeT)->( FieldPos( "NBULTOS" ) )
#define _NPORTES                  (dbfExtAgeT)->( FieldPos( "NPORTES" ) )
#define _CCODTAR                  (dbfExtAgeT)->( FieldPos( "CCODTAR" ) )
#define _NDTOESP                  (dbfExtAgeT)->( FieldPos( "NDTOESP" ) )
#define _NDPP                     (dbfExtAgeT)->( FieldPos( "NDPP"    ) )
#define _NDTOCNT                  (dbfExtAgeT)->( FieldPos( "NDTOCNT" ) )
#define _NDTORAP                  (dbfExtAgeT)->( FieldPos( "NDTORAP" ) )
#define _NDTOPUB                  (dbfExtAgeT)->( FieldPos( "NDTOPUB" ) )
#define _NDTOPGO                  (dbfExtAgeT)->( FieldPos( "NDTOPGO" ) )
#define _NDTOPTF                  (dbfExtAgeT)->( FieldPos( "NDTOPTF" ) )
#define _LRECARGO                 (dbfExtAgeT)->( FieldPos( "LRECARGO") )
#define _CDIVEXT                  (dbfExtAgeT)->( FieldPos( "CDIVEXT" ) )
#define _NVDVEXT                  (dbfExtAgeT)->( FieldPos( "NVDVEXT" ) )

/*
Definici¢n de la base de datos de lineas de detalle
*/

#define _dNNUMEXT                (dbfExtAgeL)->( FieldPos( "NNUMEXT"  ) )
#define _CREF                    (dbfExtAgeL)->( FieldPos( "CREF"     ) )
#define _CDETALLE                (dbfExtAgeL)->( FieldPos( "CDETALLE" ) )
#define _NPREUNIT                (dbfExtAgeL)->( FieldPos( "NPREUNIT" ) )
#define _NDTO                    (dbfExtAgeL)->( FieldPos( "NDTO"     ) )
#define _NDTOPRM                 (dbfExtAgeL)->( FieldPos( "NDTOPRM"  ) )
#define _NIVA                    (dbfExtAgeL)->( FieldPos( "NIVA"     ) )
#define _NCANENT                 (dbfExtAgeL)->( FieldPos( "NCANENT"  ) )
#define _NPESOKG                 (dbfExtAgeL)->( FieldPos( "NPESOKG"  ) )
#define _CUNIDAD                 (dbfExtAgeL)->( FieldPos( "CUNIDAD"  ) )
#define _NUNICAJA                (dbfExtAgeL)->( FieldPos( "NUNICAJA" ) )
#define _DFECHA                  (dbfExtAgeL)->( FieldPos( "DFECHA"   ) )

/*
Definici¢n de Array para IGIC
*/

#define _NBRTIVA1						aIva[ 1, 1 ]
#define _NBASIVA1						aIva[ 1, 2 ]
#define _NPCTIVA1						aIva[ 1, 3 ]
#define _NPCTREQ1						aIva[ 1, 4 ]
#define _NBRTIVA2						aIva[ 2, 1 ]
#define _NBASIVA2						aIva[ 2, 2 ]
#define _NPCTIVA2						aIva[ 2, 3 ]
#define _NPCTREQ2						aIva[ 2, 4 ]
#define _NBRTIVA3						aIva[ 3, 1 ]
#define _NBASIVA3						aIva[ 3, 2 ]
#define _NPCTIVA3						aIva[ 3, 3 ]
#define _NPCTREQ3						aIva[ 3, 4 ]

/*
Definici¢n de Array para objetos IGIC
*/

#define _OBASIVA1						oIva[ 1, 1 ]
#define _OPCTIVA1						oIva[ 1, 2 ]
#define _OIMPIVA1						oIva[ 1, 3 ]
#define _OPCTREQ1						oIva[ 1, 4 ]
#define _OIMPREQ1						oIva[ 1, 5 ]
#define _OBASIVA2						oIva[ 2, 1 ]
#define _OPCTIVA2						oIva[ 2, 2 ]
#define _OIMPIVA2						oIva[ 2, 3 ]
#define _OPCTREQ2						oIva[ 2, 4 ]
#define _OIMPREQ2						oIva[ 2, 5 ]
#define _OBASIVA3						oIva[ 3, 1 ]
#define _OPCTIVA3						oIva[ 3, 2 ]
#define _OIMPIVA3						oIva[ 3, 3 ]
#define _OPCTREQ3						oIva[ 3, 4 ]
#define _OIMPREQ3						oIva[ 3, 5 ]

static oWndBrw
static oInf
static dbfExtAgeT
static dbfExtAgeL
static dbfDivisa
static oBandera
static dbfTmp
static cNewFile
static dbfAlmT
static dbfIva
static dbfFPago
static dbfTarPreL
static dbfArticulo
static dbfMov
static dbfPromoT
static dbfKit
static oGetTotal
static oGetTotEur
static cPinDiv
static cPicEur
static cPicUnd
static nDinDiv
static oGetNet
static oGetIva
static oGetReq
static nGetNet 	:= 0
static nGetIva 	:= 0
static nTotal 		:= 0
static nTotalImp	:= 0
static nTotalReq	:= 0
static nTotalExt  := 0
static nTotalBrt	:= 0
static nTotalArt	:= 0
static nTotalDto	:= 0
static nTotalDPP	:= 0
static nTotalCnt	:= 0
static nTotalRap	:= 0
static nTotalPub	:= 0
static nTotalPgo	:= 0
static nTotalPtf	:= 0
static nTotalIva	:= 0
static nTotalEur	:= 0
static nGetReq  	:= 0
static oIva			:= { { , , , , }, { , , , , }, { , , , , } }
static aIva 	  	:= { { 0,0,0,0 }, { 0,0,0,0 }, { 0,0,0,0 } }
static bEdit      := { |aTmp, aGet, dbfExtAgeT, oBrw, bWhen, bValid, nMode | EdtRec( aTmp, aGet, dbfExtAgeT, oBrw, bWhen, bValid, nMode ) }
static bEdit2     := { |aTmp, aGet, dbfExtAgeL, oBrw, bWhen, bValid, nMode, aTmpExt | EdtDet( aTmp, aGet, dbfExtAgeL, oBrw, bWhen, bValid, nMode, aTmpExt ) }
static aBase      := {  { "NNUMEXT"   ,"N",  9, 0, "Número del las existencias de almacen" },;
                        { "DFECEXT"   ,"D",  8, 0, "Fecha del las existencias" },;
                        { "CCODALM"   ,"C",  3, 0, "Codigo de almacen" },;
                        { "CNOMALM"   ,"C", 35, 0, "Nombre del almacen" },;
                        { "CDIRALM"   ,"C", 35, 0, "Domicilio del almacen" },;
                        { "CPOBALM"   ,"C", 25, 0, "Población del almacen" },;
                        { "CPRVALM"   ,"C", 20, 0, "Provincia del almacen" },;
                        { "CPOSALM"   ,"C",  5, 0, "Codigo Postal del almacen" },;
                        { "LLIQEXT"   ,"L",  1, 0, "Logico para liquidación" },;
                        { "CCODPGO"   ,"C",  2, 0, "Codigo del tipo de pago" },;
                        { "NBULTOS"   ,"N",  3, 0, "Número de bultos" },;
                        { "NPORTES"   ,"N",  6, 0, "Importe de los portes" },;
                        { "CCODTAR"   ,"C",  5, 0, "Codigo de tarifa" },;
                        { "NDTOESP"   ,"N",  5, 2, "Porcentaje de descuento especial" },;
                        { "NDPP"      ,"N",  5, 2, "Porcentaje de descuento por pronto pago" },;
                        { "NDTOCNT"   ,"N",  5, 2, "Porcentaje de descuento por pago de contado" },;
                        { "NDTORAP"   ,"N",  5, 2, "Porcentaje de descuento por rappel" },;
                        { "NDTOPUB"   ,"N",  5, 2, "Porcentaje de descuento por publicidad" },;
                        { "NDTOPGO"   ,"N",  5, 2, "Porcentaje de descuento por pago centralizado" },;
                        { "NDTOPTF"   ,"N",  7, 2, "Porcentaje de descuento por plataforma" },;
                        { "LRECARGO"  ,"L",  1, 0, "Logico de recargo de equivalencia" },;
                        { "CDIVEXT"   ,"C",  3, 0, "Codigo de divisa" },;
                        { "NVDVEXT"   ,"N", 10, 4, "Valor del cambio de la divisa" } }

static aBase2     := {  { "NNUMEXT",   "N",  9, 0, "Número del las existencias de almacen" },;
                        { "CREF",      "C", 18, 0, "Referencia de artículo" },;
                        { "CDETALLE",  "C",100, 0, "Detalle de articulo" },;
                        { "NPREUNIT",  "N", 16, 6, "Precio artículo" },;
                        { "NDTO",      "N",  6, 2, "Descuento de artículo" },;
                        { "NDTOPRM",   "N",  6, 2, "Descuento de promoción" },;
                        { "NIVA",      "N",  4, 1, cImp() + " del artículo" },;
                        { "NCANENT",   "N", 16, 6, "Cantidad entrada" },;
                        { "NPESOKG",   "N", 16, 6, "Peso en Kg. del producto" },;
								{ "CUNIDAD",   "C",  2, 0, "Unidades" },;
                        { "NUNICAJA",  "N",  6, 2, "Unidades por caja" },;
                        { "DFECHA",    "D",  8, 0, "Fecha de linea" }}

//----------------------------------------------------------------------------//

STATIC FUNCTION OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   USE ( cPatEmp() + "\EXTAGET.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "EXTAGET", @dbfExtAgeT ) )
   SET ADSINDEX TO ( cPatEmp() + "\EXTAGET.CDX" ) ADDITIVE

   USE ( cPatEmp() + "\EXTAGEL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "EXTAGEL", @dbfExtAgeL ) )
   SET ADSINDEX TO ( cPatEmp() + "\EXTAGEL.CDX" ) ADDITIVE

   USE ( cPatDat() + "\TIVA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfIva ) )
   SET ADSINDEX TO ( cPatDat() +"\TIVA.CDX" ) ADDITIVE

   USE ( cPatEmp() + "\FPAGO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FPAGO", @dbfFPago ) )
   SET ADSINDEX TO ( cPatEmp() + "\FPAGO.CDX" ) ADDITIVE

   USE ( cPatEmp() + "\ALMACEN.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALMACEN", @dbfAlmT ) )
   SET ADSINDEX TO ( cPatEmp() + "\ALMACEN.CDX" ) ADDITIVE

   USE ( cPatEmp() + "\TARPREL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TARPREL", @dbfTarPreL ) )
   SET ADSINDEX TO ( cPatEmp() + "\TARPREL.CDX" ) ADDITIVE

   USE ( cPatEmp() + "\PROMOT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROMOT", @dbfPromoT ) )
   SET ADSINDEX TO ( cPatEmp() + "\PROMOT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "\ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
   SET ADSINDEX TO ( cPatEmp() + "\ARTICULO.CDX" ) ADDITIVE

   USE ( cPatEmp() + "\MOVALM.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "MOVALM", @dbfMov ) )
   SET ADSINDEX TO ( cPatEmp() + "\MOVALM.CDX" ) ADDITIVE

   USE ( cPatEmp() + "\ARTKIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTTIK", @dbfKit ) )
   SET ADSINDEX TO ( cPatEmp() + "\ARTKIT.CDX" ) ADDITIVE

   USE ( cPatDat() + "\DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDivisa ) )
   SET ADSINDEX TO ( cPatDat() + "\DIVISAS.CDX" ) ADDITIVE

   USE ( cPatDat() + "\BANDERA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "BANDERA", @oBandera ) )
   SET ADSINDEX TO ( cPatDat() + "\BANDERA.CDX" ) ADDITIVE

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles()

	IF oWndBrw != NIL
		oWndBrw:oBrw:lCloseArea()
		oWndBrw := NIL
	ELSE
      if !Empty( dbfExtAgeT )
         ( dbfExtAgeT )->( dbCloseArea() )
      end if
	END IF

   if !Empty( dbfExtAgeL )
      ( dbfExtAgeL )->( dbCloseArea() )
   end if
   if !Empty( dbfIva )
      ( dbfIva     )->( dbCloseArea() )
   end if
   if !Empty( dbfFPago )
      ( dbfFPago   )->( dbCloseArea() )
   end if
   if !Empty( dbfAlmT )
      ( dbfAlmT    )->( dbCloseArea() )
   end if
   if !Empty( dbfTarPreL )
      ( dbfTarPreL )->( dbCloseArea() )
   end if
   if !Empty( dbfPromoT  )
      ( dbfPromoT  )->( dbCloseArea() )
   end if
   if !Empty( dbfArticulo )
      ( dbfArticulo)->( dbCloseArea() )
   end if
   if !Empty( dbfMov )
      ( dbfMov     )->( dbCloseArea() )
   end if
   if !Empty( dbfKit )
      ( dbfKit     )->( dbCloseArea() )
   end if
   if !Empty( dbfDivisa )
      ( dbfDivisa  )->( dbCloseArea() )
   end if
   if !Empty( oBandera )
      ( oBandera  )->( dbCloseArea() )
   end if

   dbfExtAgeT  := nil
   dbfExtAgeL  := nil
   dbfIva      := nil
   dbfFPago    := nil
   dbfAlmT     := nil
   dbfTarPreL  := nil
   dbfPromoT   := nil
   dbfArticulo := nil
   dbfMov      := nil
   dbfDivisa   := nil
   oBandera   := nil

RETURN .T.

//----------------------------------------------------------------------------//

FUNCTION ExtAge( oWnd )

	local oBtnEur
	local lEuro		:= .f.
	local aDbfBmp  := { 	LoadBitmap( GetResources(), "BMPESTADO1" ),;
								LoadBitmap( GetResources(), "BMPESTADO3" ) }

	cPouEur			:= cPouDiv( "EUR", dbfDivisa )				// Picture del euro
   cPicUnd        := MasUnd()                               // Picture de las unidades

	IF oWndBrw == NIL

   if !OpenFiles()
      return nil
   end if

   DEFINE SHELL oWndBrw FROM 0, 0 TO 22, 80 ;
         TITLE    "Existencias a almacenes" ;
         FIELDS   If ( (dbfExtAgeT)->LLIQEXT, aDbfBmp[1], aDbfBmp[2] ), ;
                  Str( (dbfExtAgeT)->NNUMEXT ),;
                  Dtoc( (dbfExtAgeT)->DFECEXT ),;
                  (dbfExtAgeT)->CCODALM + Space(1) + RetAlmacen( (dbfExtAgeT)->CCODALM, dbfAlmT ),;
() )
				( dbfMov )->CCODART := cCodArt
				( dbfMov )->CCODALM := cCodAlm
				( dbfMov )->CREFMOV := cTipMov
				( dbfMov )->DFECMOV := dDate
				( dbfMov )->NSTOCK  := nUnits
			END IF

			CLOSE ( dbfMov )

		END IF

		CLOSE ( dbfArticulo )

	END IF

RETURN .T.

//---------------------------------------------------------------------------//

STATIC FUNCTION DelDetalle( cCodArt )

	local oDlg
	local nWidth
	local cTitle 	:= "Espere por favor..."
	local cCaption := "Borrando proveedores asociados"
	local nOrdAnt	:= (dbfArtPrv)->(OrdSetFocus(1))

	DEFINE DIALOG oDlg ;
		FROM 0,0 TO 4, Max( Len( cCaption ), Len( cTitle ) ) + 4 ;
		TITLE cTitle ;
		STYLE DS_MODALFRAME

	nWidth 			:= oDlg:nRight - oDlg:nLeft
	oDlg:cMsg   	:= cCaption

	ACTIVATE DIALOG oDlg ;
		CENTER ;
		NOWAIT ;
		ON PAINT oDlg:Say( 1, 0, xPadC( oDlg:cMsg, nWidth ) )

	IF (dbfArtPrv)->( dbSeek( cCodArt ) )

		WHILE ( (dbfArtPrv)->CCODART == cCodArt )

         if dbLock( dbfArtPrv )
            ( dbfArtPrv )->( DbDelete() )
            ( dbfArtPrv )->( DbUnLock() )
         end if

			(dbfArtPrv)->(DbSkip(1))

		END WHILE

	END IF

	(dbfArtPrv)->( OrdSetFocus( nOrdAnt ) )

	oDlg:End()
	SysRefresh()

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION ExsArt( 	dbfArticulo,;
						dbfIva,;
						cRefArt,;
						cDetArt,;
						nUndArt,;
						nCajArt,;
						cUndArt,;
						nIvaArt,;
						lIvaInc,;
						nPreArt )

	/*
	Comprobamos si existe el articulo en la base de datos
	*/

	IF !empty( cRefArt ) .AND. !( dbfArticulo )->( dbSeek( cRefArt ) )

		/*
		Nos piden autorizaci¢n para a¤adirlo
		*/

      IF ApoloMsgNoYes(   "Articulo : " + rtrim( cDetArt ) + " no existe en su fichero." + CRLF +;
							CRLF +;
							"¿ Desea realizar el alta automática ?" + CRLF +;
							CRLF + ;
                     "( Recuerde que, debe de completar la ficha de este artículo )",;
                     "Nuevo artículo" )

			( dbfArticulo )->( dbAppend() )
			( dbfArticulo )->CODIGO		:= cRefArt
			( dbfArticulo )->NOMBRE		:= cDetArt
			( dbfArticulo )->PCOSTO		:= nPreArt
			( dbfArticulo )->NUNICAJA	:= nCajArt
			( dbfArticulo )->NACTUAL	:= nUndArt
			( dbfArticulo )->TIPOIVA	:= nCodIva( dbfIva, nIvaArt )
			( dbfArticulo )->CUNIDAD	:= cUndArt
			( dbfArticulo )->LIVAINC	:= lIvaInc

		END IF

	END IF

RETURN NIL

//--------------------------------------------------------------------------//

/*
Actualiza los precios de costo desde facturas y albaranes de proveedores
*/

FUNCTION ActCosPrv(  dbfArticulo, dbfArtPre, cCodArt, dFecha, cCodPrv, ;
                     nUniCaja, nCanEnt, cUnidad, nPreUnit, lAut, lBnd,;
                     lBnv, nBnd, nBnv, nPvd, nPvp, lIvaInc )

   DEFAULT lAut      := .t.
   DEFAULT nBnd      := 0
   DEFAULT nBnv      := 0
   DEFAULT nPvd      := 0
   DEFAULT nPvp      := 0
   DEFAULT lIvaInc   := .f.

	/*
	Si existe el articulo y la fecha del movimiento es mayor que la fecha de
	la ultima entrada
	*/

	IF ( dbfArticulo )->( dbSeek( cCodArt ) )

		/*
		Comprobamos la autorizaci¢n para el cambio de precio
		*/

		IF lAut

         ChgPre( nPreUnit, dbfArticulo, dFecha, lBnd, lBnv, nBnd, nBnv, nPvd, nPvp, lIvaInc )

		END IF

	END IF

	/*
	Anotamos los movimientos
	*/

  IF ( dbfArtPre )->( DbSeek( cCodArt + cCodPrv ) ) .AND. dFecha >= ( dbfArtPre )->DFECPRV

      dbDialogLock( dbfArtPre )
		( dbfArtPre )->DFECPRV := dFecha
		( dbfArtPre )->NUNICAJ := nUniCaja
		( dbfArtPre )->NCANENT := nCanEnt
		( dbfArtPre )->CUNIDAD := cUnidad
		( dbfArtPre )->NPRECOS := nPreUnit
		( dbfArtPre )->( dbUnLock() )

	ELSE

		( dbfArtPre )->( dbAppend() )
		( dbfArtPre )->CCODART := cCodArt
		( dbfArtPre )->CCODPRV := cCodPrv
		( dbfArtPre )->DFECPRV := dFecha
		( dbfArtPre )->NUNICAJ := nUniCaja
		( dbfArtPre )->NCANENT := nCanEnt
		( dbfArtPre )->CUNIDAD := cUnidad
		( dbfArtPre )->NPRECOS := nPreUnit

	END IF

RETURN NIL

//--------------------------------------------------------------------------//

/*
Cambia el precio
*/

STATIC FUNCTION ChgPre( nPreUnit, dbfArticulo, dFecha, lBnd, lBnv, nBnd, nBnv, nPvd,;
                        nPvp, lIvaInc )

   dbDialogLock( dbfArticulo )

   ( dbfArticulo )->PCOSTO       := nPreUnit

   IF lBnd != NIL
      ( dbfArticulo )->LBNF1     := lBnd
   END IF

   IF lBnv != NIL
      ( dbfArticulo )->LBNF3     := lBnv
   END IF

	/*
	IF lIvaInc

		IF ( dbfArticulo )->LBNF1
      	( dbfArticulo )->PVENTA1   := ( nPreUnit * (dbfArticulo)->BENEF1 / 100 ) + nPreUnit
		END IF

		IF ( dbfArticulo )->LBNF3
      	( dbfArticulo )->PVENTA3   := ( nPreUnit * (dbfArticulo)->BENEF3 / 100 ) + nPreUnit
		END IF

	ELSE

		IF ( dbfArticulo )->LBNF1
      	( dbfArticulo )->PVENTA1   := ( nPreUnit * (dbfArticulo)->BENEF1 / 100 ) + nPreUnit
		END IF

		IF ( dbfArticulo )->LBNF3
      	( dbfArticulo )->PVENTA3   := ( nPreUnit * (dbfArticulo)->BENEF3 / 100 ) + nPreUnit
		END IF

	END IF
	*/

	IF dFecha >= ( dbfArticulo )->LASTIN
      ( dbfArticulo )->LASTIN    := dFecha
	END IF

	IF nBnd != 0 .AND. ( dbfArticulo )->LBNF1
      ( dbfArticulo )->BENEF1    := nBnd
	END IF

	IF nBnv != 0 .AND. ( dbfArticulo )->LBNF3
      ( dbfArticulo )->BENEF3    := nBnv
	END IF

	IF lIvaInc != NIL
      ( dbfArticulo )->LIVAINC   := lIvaInc
	END IF

   IF lIvaInc

		IF nPvd != 0 .AND. ( dbfArticulo )->LBNF1
	      ( dbfArticulo )->PVTAIVA1   := nPvd
		END IF

		IF nPvp != 0 .AND. ( dbfArticulo )->LBNF3
			( dbfArticulo )->PVTAIVA3   := nPvp
		END IF

	ELSE

		IF nPvd != 0 .AND. ( dbfArticulo )->LBNF1
	      ( dbfArticulo )->PVENTA1   := nPvd
		END IF

		IF nPvp != 0 .AND. ( dbfArticulo )->LBNF3
			( dbfArticulo )->PVENTA3   := nPvp
		END IF

	END IF

	/*
	Marca para etiqueta
	*/

  ( dbfArticulo )->LLABEL        := .T.
  ( dbfArticulo )->NLABEL        := 1

  /*
  Marca para el cambio
  */

  ( dbfArticulo )->DFECCHG       := date()

	/*
	Desbloqueo del registro
	*/

	( dbfArticulo )->( dbUnLock() )

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION TransRef( cCodeRec, cPath )

	local dbfRefPrv
	local nOrdAnt  := (dbfArtPrv)->(OrdSetFocus(1))

	/*
	Ahora pasamos las refrencias de los proveedores
	*/

	IF (dbfArtPrv)->( DbSeek( cCodeRec ) )

      USE ( cPath + "\PROVART.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROVART", @dbfRefPrv ) )
      SET ADSINDEX TO ( cPath + "\PROVART.CDX" ) ADDITIVE

		WHILE (dbfArtPrv)->CCODART = cCodeRec .and. !(dbfArtPrv)->( eof() )

			IF (dbfRefPrv)->( dbSeek( cCodeRec ) )
            dbDialogLock( dbfRefPrv )
			ELSE
            dbDialogLock( dbfRefPrv, .t. )
			END IF
         dbPass( dbfArtPrv, dbfRefPrv )
			( dbfArtPrv )->( DbSkip() )

		END IF

		CLOSE ( dbfRefPrv )

	END IF

	(dbfArtPrv)->( OrdSetFocus( nOrdAnt ) )

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION nRetPreCosto( dbfArticulo, cCodArt )

	local nPreCos 	:= 0
	local nOrdAnt 	:= ( dbfArticulo )->( OrdSetFocus( 1 ) )
	local nRecno 	:= ( dbfArticulo )->( RecNo() )

	IF ( dbfArticulo )->( dbSeek( cCodArt ) )
		nPreCos := ( dbfArticulo )->PCOSTO
	END IF

	( dbfArticulo )->( dbGoTo( nRecno ) )
	( dbfArticulo )->( OrdSetFocus( nOrdAnt ) )

RETURN nPreCos

//---------------------------------------------------------------------------//

/*
Devuelve el precio de ventA Mayorista
*/

FUNCTION nRetPVD( cCodArt, dbfArticulo )

	local nPre	 	:= 0
	local nOrdAnt 	:= ( dbfArticulo )->( OrdSetFocus( 1 ) )
	local nRecno 	:= ( dbfArticulo )->( RecNo() )

	IF ( dbfArticulo )->( dbSeek( cCodArt ) )

      nPre := ( dbfArticulo )->PVTAIVA1

	END IF

	( dbfArticulo )->( dbGoTo( nRecno ) )
	( dbfArticulo )->( OrdSetFocus( nOrdAnt ) )

RETURN nPre

//---------------------------------------------------------------------------//

/*
Devuelve el precio de venta con " + cImp() + " si va incluido
*/

FUNCTION nRetPVP( cCodArt, dbfArticulo )

	local nPre	 	:= 0
	local nOrdAnt 	:= ( dbfArticulo )->( OrdSetFocus( 1 ) )
   local nRecno   := ( dbfArticulo )->
                  hBmpDiv( (dbfExtAgeT)->CDIVEXT, dbfDivisa, oBandera ),;
                  nTotal( (dbfExtAgeT)->NNUMEXT, dbfExtAgeT, dbfExtAgeL, dbfIva, dbfDivisa, nil, lEuro );
			HEAD 		"Liq.",;
                  "N. Existencias",;
						"Fecha",;
						"Almacen",;
						"Div.",;
						"Total";
			FIELDSIZES ;
						20,;
						80,;
						80,;
						260,;
						25,;
						100 ;
         PROMPTS  "Número",;
						"Fecha",;
						"Almacen";
         JUSTIFY  .F., .F., .F., .F., .F., .T. ;
         ALIAS    ( DBFEXTAGET );
         APPEND   ( WinAppRec( oWndBrw:oBrw, bEdit, dbfExtAgeT ) );
         DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdit, dbfExtAgeT ) );
         EDIT     ( WinEdtRec( oWndBrw:oBrw, bEdit, dbfExtAgeT ) );
         DELETE   ( dbDelRec(  oWndBrw:oBrw, dbfExtAgeT, {|| delDetalle( ( dbfExtAgeT )->NNUMEXT ) } ) ) ;
			OF 		oWnd

      DEFINE BTNSHELL RESOURCE "NEW" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( oWndBrw:RecAdd() );
			ON DROP	( oWndBrw:RecDup() );
			TOOLTIP 	"(A)ñadir";
			HOTKEY 	"A"

		DEFINE BTNSHELL RESOURCE "DUP" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( oWndBrw:RecDup() );
			TOOLTIP 	"(D)uplicar";
			HOTKEY 	"D"

		DEFINE BTNSHELL RESOURCE "EDIT" OF oWndBrw ;
			NOBORDER ;
			ACTION  	( oWndBrw:RecEdit() );
			TOOLTIP 	"(M)odificar";
			HOTKEY 	"M"

		DEFINE BTNSHELL RESOURCE "ZOOM" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( WinZooRec( oWndBrw:oBrw, bEdit, dbfExtAgeT ) );
			TOOLTIP 	"(Z)oom";
			HOTKEY 	"Z"

		DEFINE BTNSHELL RESOURCE "DEL" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( oWndBrw:RecDel() );
			TOOLTIP 	"(E)liminar";
			HOTKEY 	"E"

		DEFINE BTNSHELL RESOURCE "BUS" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( oWndBrw:Search() ) ;
			TOOLTIP 	"(B)uscar";
			HOTKEY 	"B"

		DEFINE BTNSHELL oBtnEur RESOURCE "BAL_EURO" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( lEuro := !lEuro, oBtnEur:lPressed := lEuro, oWndBrw:refresh() ) ;
			TOOLTIP 	"E(u)ros";
			HOTKEY 	"U"

      DEFINE BTNSHELL RESOURCE "IMP" GROUP OF oWndBrw ;
			NOBORDER ;
         ACTION   ( GenExtAge( .T. ) ) ;
			TOOLTIP 	"(I)mprimir";
			HOTKEY 	"I"

		DEFINE BTNSHELL RESOURCE "PREV1" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( GenExtAge( .F. ) ) ;
			TOOLTIP 	"(P)revisualizar";
			HOTKEY 	"P"

      DEFINE BTNSHELL RESOURCE "GC_PRINTER2_" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( PrnSerie() ) ;
         TOOLTIP  "Imp(r)imir series";
			HOTKEY 	"R"

      DEFINE BTNSHELL RESOURCE "END"  GROUP OF oWndBrw;
			NOBORDER ;
			ACTION 	( oWndBrw:End() ) ;
			TOOLTIP 	"Salir" ;
			HOTKEY 	"S"

		ACTIVATE WINDOW oWndBrw VALID ( CloseFiles() )

	ELSE

		oWndBrw:setFocus()

	END IF

RETURN NIL

//----------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aTmp, aGet, dbfExtAgeT, oBrw, bWhen, bValid, nMode )

	local oDlg
	local oBrw2
	local oFld
	local oBtnSerie
	local oSay1, oSay2, oSay3, oSay4, oSay5
	local cSay1, cSay2, cSay3, cSay4, cSay5
   local nRecno      := (dbfExtAgeT)->( RecNo() )
   local oFont       := TFont():New( "Arial", 8, 26, .F., .T. )
	local nImpIva1		:= 0
	local nImpIva2		:= 0
	local nImpIva3		:= 0
	local nImpReq1		:= 0
	local nImpReq2		:= 0
	local nImpReq3		:= 0

	IF nMode == APPD_MODE
      aTmp[ _CCODALM ]  := oUser():cAlmacen()
      aTmp[ _CDIVEXT ]  := cDivEmp()
      aTmp[ _NVDVEXT ]  := nChgDiv( aTmp[ _CDIVEXT ], dbfDivisa )
	END

	BeginTrans( aTmp )

   cPouDiv           := cPouDiv( aTmp[ _CDIVEXT ], dbfDivisa ) // Picture de la divisa
	cPicEur				:= cPinDiv( "EUR", dbfDivisa )				// Picture del euro
	cPicUnd				:= MasUnd()
   nDinDiv           := nDinDiv( aTmp[ _CDIVEXT ], dbfDivisa )

   DEFINE DIALOG oDlg RESOURCE "DEPAGE" TITLE LblTitle( nMode ) + "Existencias de almacenes"

      REDEFINE GET aGet[_NNUMEXT] VAR aTmp[_NNUMEXT] ;
			ID 		100 ;
			PICTURE 	"999999999" ;
			WHEN  	( .F. ) ;
         COLOR    CLR_SHOW ;
			OF 		oDlg

      REDEFINE GET aGet[_DFECEXT] VAR aTmp[_DFECEXT];
			ID 		110 ;
			SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			OF 		oDlg

		REDEFINE GET aGet[_CCODALM] VAR aTmp[_CCODALM] ;
			ID 		130 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			VALID 	( LoadAlm( aGet, aTmp, oSay1 ) ) ;
         BITMAP   "LUPA" ;
			ON HELP 	( BrwAlmacen( aGet[_CCODALM], oSay1 ) ) ;
			COLOR 	CLR_GET ;
			OF 		oDlg

		REDEFINE GET aGet[_CNOMALM] VAR aTmp[_CNOMALM] ;
			WHEN 		.F. ;
			ID 		131 ;
			OF 		oDlg

		REDEFINE GET aGet[_CCODPGO] VAR aTmp[_CCODPGO] ;
			ID 		140 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			PICTURE  "@!" ;
         BITMAP   "LUPA" ;
			VALID 	( cFPago( aGet[_CCODPGO], dbfFPago, oSay2 ) ) ;
         ON HELP  ( BrwFPago( aGet[_CCODPGO], oSay2 ) ) ;
			OF 		oDlg

		REDEFINE GET oSay2 VAR cSay2 ;
			ID 		141 ;
			WHEN 		.F. ;
			COLOR 	CLR_GET ;
			OF 		oDlg

		REDEFINE GET aGet[_CCODTAR] VAR aTmp[_CCODTAR] ;
			ID 		150 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			VALID 	( cTarifa( aGet[_CCODTAR], oSay4 ) ) ;
         BITMAP   "LUPA" ;
			ON HELP 	( BrwTarifa( aGet[_CCODTAR], oSay4 ) ) ;
			COLOR 	CLR_GET ;
			OF 		oDlg

		REDEFINE GET oSay4 VAR cSay4 ;
			WHEN 		.F. ;
			ID 		151 ;
			OF 		oDlg

		/*
		Moneda__________________________________________________________________
		*/

      REDEFINE GET aGet[ _CDIVEXT ] VAR aTmp[ _CDIVEXT ];
			WHEN 		( 	nMode == APPD_MODE ) ;
         BITMAP   "LUPA" ;
         VALID    (  cDiv( aGet[ _CDIVEXT ], oBmpDiv, aGet[ _NVDVEXT ], @cPinDiv, @nDinDiv ),;
                     nTotal( 0, dbfExtAgeT, dbfTmp, dbfIva, dbfDivisa, aTmp ),;
							.t. );
			PICTURE	"@!";
			ID 		170 ;
			COLOR 	CLR_GET ;
         ON HELP  BrwDiv( aGet[ _CDIVEXT ], oBmpDiv, aGet[ _NVDVEXT ], dbfDivisa, oBandera ) ;
			OF 		oDlg

		REDEFINE BITMAP oBmpDiv ;
         RESOURCE "BAN_EURO" ;
			ID 		171;
			OF 		oDlg

      REDEFINE GET aGet[ _NVDVEXT ] VAR aTmp[ _NVDVEXT ];
			WHEN 		( nMode == APPD_MODE ) ;
			ID 		180 ;
         VALID    ( aTmp[ _NVDVEXT ] > 0 ) ;
			PICTURE	"@E 999,999.9999" ;
			COLOR 	CLR_GET ;
			OF 		oDlg

		/*
		Bitmap________________________________________________________________
		*/

		REDEFINE BITMAP ;
			FILE		bmpEmp ;
			ID 		600 ;
			OF 		oDlg ;
         TRANSPARENT;
			ADJUST

		/*
		Detalle________________________________________________________________
		*/

      REDEFINE IBROWSE oBrw2 ;
			FIELDS ;
						(dbfTmp)->CREF,;
						(dbfTmp)->CDETALLE,;
                  Transform( nUnitEnt( dbfTmp ), cPicUnd ),;
                  Transform( (dbfTmp)->NPREUNIT, cPouDiv ),;
                  Transform( (dbfTmp)->NDTO, "@E 99.99"), ;
                  Transform( (dbfTmp)->NDTOPRM, "@E 99.99"), ;
						Transform( (dbfTmp)->NIVA, "@E 99.9" ), ;
                  Transform( nTotLExtAge( dbfTmp ), cPouDiv );
			FIELDSIZES ;
						80,;
						190,;
						60,;
						60,;
						40,;
						40,;
						30,;
						100;
			HEAD;
                  "Codigo",;
						"Detalle",;
						"Unds.",;
						"Precio U.",;
						"Dto.%",;
						"Dto.P.%",;
                  cImp(),;
						"Importe";
			ID 		200 ;
			ALIAS 	( dbfTmp ) ;
			OF 		oDlg

         oBrw2:aJustify    := { .f., .f., .t., .t., .t., .t., .t., .t., .t. }

			IF nMode	!= ZOOM_MODE
				oBrw2:bLDblClick	:= {|| EdtDeta( oBrw2, bEdit2, aTmp ) }
				oBrw2:bAdd 			:= {|| AppDeta( oBrw2, bEdit2, aTmp ) }
				oBrw2:bEdit			:= {|| EdtDeta( oBrw2, bEdit2, aTmp ) }
				oBrw2:bDel 			:= {|| DelDeta( oBrw2, aTmp ) }
			END IF

		/*
		Cajas para el desglose________________________________________________
		*/

		REDEFINE GET aGet[_NDTOESP ] VAR aTmp[ _NDTOESP ] ;
			ID 		210 ;
			PICTURE 	"@E 99.99" ;
			COLOR 	CLR_GET ;
			VALID		( nRecTotal( dbfTmp, aTmp ) );
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

		REDEFINE GET aGet[ _NDPP ] VAR aTmp[ _NDPP ];
			ID 		220 ;
			PICTURE 	"@E 99.99" ;
			COLOR 	CLR_GET ;
			VALID		( nRecTotal( dbfTmp, aTmp ) );
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

		REDEFINE GET aGet[ _NDTOCNT ] VAR aTmp[ _NDTOCNT ];
			ID 		230 ;
			PICTURE 	"@E 99.99" ;
			COLORNE        TCOMBOBOX       CHGINDEX       OINDICES        TGET            FASTSEEK       TBUTTON         BLCLICKED       BMOVED          BPAINTED        BRCLICKED       BCANCEL         ACLONE          NAT             SETARRAY        EDTEXP         ODLG            SELECTALL       ASSIGN          VARGET          NPOS            DBSEEK          UPSTABLE        BMENUSELEC      _BMENUSELE      MENUBEGIN       MENUADDITE      BACTION         ACONTROLS       MENUEND         ASIZE           AINS            CMRU            ORDKEY          ADEL            ALLTRIM         NREC            BDEL            DELMRU          Ôœ ÌV œ Ì,V!ðœ Ì|V"Ÿœ ÌŒV#Žœ Ì¬V$mœ Ì¼P  yœ ÌÜV%<œ ÌìP
  Hœ ÌüV&œ Í\V'¹œ ÍŒP  ©œ ÍìV((œ Î,V)æœ Î<V*Õœ ÎlV+¤œ Î|V,“œ ÎŒV-‚œ Î¬V.aœ Î¼V/Pœ ÎÌV0?        à
  Mœ Ì T'
  TSHELL   Š  t                                                                                                                                                                                                   ey := {}
	END IF

   IF cKey != NIL .AND. aScan( ::aFastKey, {|aKey| aKey[1] == Upper( cKey ) } ) = 0
		aadd( ::aFastKey, { Upper( cKey ), bAction } )
	END IF

return oBtnBmp

//----------------------------------------------------------------------------//

METHOD CtrlKey( nKey ) CLASS TShell

	local nCont
   local nLen := len( ::aFastKey )

	for nCont := 1 TO nLen

      if nKey == Asc( Upper( ::aFastKey[ nCont, 1 ] ) ) .OR. nKey == Asc( Lower( ::aFastKey[ nCont, 1 ] ) )
         eval( ::aFastKey[ nCont, 2 ] )
      end if

	next nCont

	/*
	teclas rapidas
	*/

	do case
	case nKey == VK_ESCAPE .and. ::oWnd != nil
		Self:end()
		return 0
	case nKey == VK_RETURN .and. ::oWnd != nil
		eval( ::oBrw:bEdit )
	end

return nil

//----------------------------------------------------------------------------//

METHOD End()

   ::oIni:Set( ::cTitle, "recno", Str( (::cAlias)->( RecNo() ) ) )
   ::oIni:Set( ::cTitle, "MRU1", ::aMru[ 1 ] )
   ::oIni:Set( ::cTitle, "MRU2", ::aMru[ 2 ] )
   ::oIni:Set( ::cTitle, "MRU3", ::aMru[ 3 ] )
   ::oIni:Set( ::cTitle, "MRU4", ::aMru[ 4 ] )
   ::oIni:Set( ::cTitle, "MRU5", ::aMru[ 5 ] )

   ::oIni:Set( ::cTitle, "KEY1", ::aKey[ 1 ] )
   ::oIni:Set( ::cTitle, "KEY2", ::aKey[ 2 ] )
   ::oIni:Set( ::cTitle, "KEY3", ::aKey[ 3 ] )
   ::oIni:Set( ::cTitle, "KEY4", ::aKey[ 4 ] )
   ::oIni:Set( ::cTitle, "KEY5", ::aKey[ 5 ] )

RETURN Super:end()

//----------------------------------------------------------------------------//

METHOD Search() CLASS TShell

	local oDlg
	local oCadena
	local xCadena
	local oInidice
	local cInidice := ::aPrompt[ ( ::cAlias )->( OrdNumber() ) ]
	local nRad		:= ( ::cAlias )->( OrdNumber() )
	local cAlias 	:= ::cAlias
	local oBrw     := ::oBrw
	local oTabs		:= ::oTabs

	DEFINE DIALOG oDlg RESOURCE "SEARCH"

	REDEFINE COMBOBOX oIndices VAR cInidice ;
		ITEMS    ::aPrompt ;
		ID 		100 ;
		ON CHANGE( ChgIndex( oCadena, oIndices, cAlias, oBrw, oTabs ) ) ;
		OF 		oDlg

	REDEFINE GET oCadena VAR xCadena ;
		ID 		110 ;
		PICTURE 	"@!" ;
      ON CHANGE( FastSeek( nKey, nFlags, oCadena, cAlias, oBrw ) ) ;
		OF 		oDlg

	REDEFINE BUTTON ;
		ID 		510 ;
		OF 		oDlg ;
		ACTION 	( oDlg:end() )

	ACTIVATE DIALOG oDlg CENTER

RETURN NIL

//--------------------------------------------------------------------------//

METHOD Export( aBase ) CLASS TShell

	local oDlg
   local oBrw
   local aExp

   IF aBase == nil
      RETURN NIL
   END IF

   aExp  := aClone( aBase )

   DEFINE DIALOG oDlg RESOURCE "EXPFIL"

      REDEFINE LISTBOX oBrw ;
			FIELDS ;
                  aExp[ oBrw:nAt, 5 ],;
                  aExp[ oBrw:nAt, 1 ],;
                  aExp[ oBrw:nAt, 2 ],;
                  Trans( aExp[ oBrw:nAt, 3 ], "999" ),;
                  Trans( aExp[ oBrw:nAt, 4 ], "9" ) ;
			HEAD ;
                  "Nombre",;
                  "Campo" ,;
                  "Tipo" ,;
                  "Len" ,;
                  "Dec" ;
         FIELDSIZES ;
                  200,;
( RecNo() )

	IF ( dbfArticulo )->( dbSeek( cCodArt ) )

      nPre := ( dbfArticulo )->PVTAIVA3

	END IF

	( dbfArticulo )->( dbGoTo( nRecno ) )
	( dbfArticulo )->( OrdSetFocus( nOrdAnt ) )

RETURN nPre

//---------------------------------------------------------------------------//

FUNCTION nUnitEnt( dbfLine )

	local nUnits
	local nCajas := (dbfLine)->NCANENT

	IF nCajas == 0
		nCajas := 1
	END IF

   IF lCalCaj()
		nUnits := nCajas * (dbfLine)->NUNICAJA
	ELSE
		nUnits := (dbfLine)->NUNICAJA
	END IF

RETURN ( nUnits )

//--------------------------------------------------------------------------//

/*
Cambia de pesetas a Euros
*/

STATIC FUNCTION SetPtsEur( oWndBrw, oBtnEur )

	lEuro	:= !lEuro

	oBtnEur:lPressed := lEuro
	oBtnEur:refresh()

	oWndBrw:oBrw:refresh()
	oWndBrw:setfocus()

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION ImpDatos( oBrw, aTmp )

	local cSep
	local oText
	local cFileName
	local cCodBar
	local nPreArt
	local nDesMay
	local nDesVen
	local nOrdAnt	:= ( dbfArticulo )->( ordSetFocus( "CODEBAR" ) )

	msgAlert("El fichero debe de poseer la siguiente estructura : " + CRLF + ;
					"Cabecera : "								+ CRLF + ;
					"   06- Cod. Interno" 					+ CRLF + ;
					"   30- Descripción"						+ CRLF + ;
               "   02- " + cImp()                     + CRLF + ;
																	+ CRLF + ;
					"De lo contrario los resultados pueden ser insopechados" )

   cFileName   := cGetFile( "*.dat", "Seleccione el fichero de Articulos" )

	IF	File( cFileName )

		oText 		:= TTxtFile():New( cFileName )
		oText:Open()

		/*
		Cabeceras de la factura
		*/

		while !oText:lEof()

			cCodBar	:= oText:cGetStr( 13 )
			oText:cGetStr( 44 )
			nPreArt 	:= Val( oText:cGetStr( 4 ) )
			oText:cGetStr( 2 )

			IF ( dbfArticulo )->( dbseek( cCodBar ) )

            dbDialogLock( dbfArticulo )
				( dbfArticulo )->NUNICAJA	:= nPreArt

			END IF

			msgWait( cCodBar, str( nPreArt ) , 0.1 )

		end while

		oText:Close()

	END IF

	( dbfArticulo )->( ordSetFocus( nOrdAnt ) )

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION retTipIva( nCodIva )

	local nOrdAnt
	local cTemp
	local dbfTIva
	local dbfTIvaAnt 	:= Alias()

   USE ( cPatDat() + "\TIVA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfTIva ) )
   SET ADSINDEX TO ( cPatDat() + "\TIVA.CDX" ) ADDITIVE
	nOrdAnt := (dbfTIva)->( OrdSetFocus( "TPIVA" ) )

	IF (dbfTIva)->( DbSeek( nCodIva ) )
		cTemp := (dbfTIva)->TIPO
	END IF

	(dbfTIva)->( OrdSetFocus( nOrdAnt ) )

	CLOSE ( dbfTIva )

	IF dbfTIvaAnt != ""
		SELECT( dbfTIvaAnt )
	END IF

RETURN cTemp

//---------------------------------------------------------------------------//

/*
Selecciona el fichero de un grafico
*/

STATIC FUNCTION GetBmp( aGet, bmpFile )

   local cFile := rTrim( cGetFile( "*.bmp", "Seleccion de Fichero" ) )

	aGet:SetText( cFile )
	bmpFile:LoadBmp( 	cFile )

RETURN ( cFile )

//---------------------------------------------------------------------------//

/*
Devuelve el precio de distribución de un articulo
*/

FUNCTION retPvd( cCodArt, cCodDiv, nChgDiv, dbfArt, dbfDiv )

	local nPvp			:= 0

	DEFAULT nChgDiv	:= 0

	IF ( dbfArt )->( dbSeek( cCodArt ) )

    nPvp  := ( dbfArt )->PVTAIVA1

		/*
		Buscamos la divisa pasada
		*/

		IF ( dbfDiv )->( dbSeek( ( dbfArt )->CODIGO + cCodDiv ) )

      nPvp  := ( dbfDiv )->NPVDDIV

		ELSE

			/*
			Aplicamos el cambio
			*/

			IF nChgDiv != 0
				nPvp := nPvp / nChgDiv
			END IF

		END IF

	END IF

RETURN ( nPvp )

//---------------------------------------------------------------------------//

/*
Devuelve el precio de venta de un articulo
*/

FUNCTION retPvp( cCodArt, cCodDiv, nChgDiv, dbfArt, dbfDiv )

	local nPvp			:= 0

	DEFAULT nChgDiv	:= 0

	IF ( dbfArt )->( dbSeek( cCodArt ) )

		nPvp	:= ( dbfArt )->PVTAIVA3

		/*
		Buscamos la divisa pasada
		*/

		IF ( dbfDiv )->( dbSeek( ( dbfArt )->CODIGO + cCodDiv ) )

			nPvp	:= ( dbfDiv )->NPVPDIV

		ELSE

			/*
			Aplicamos el cambio
			*/

			IF nChgDiv != 0
				nPvp := nPvp / nChgDiv
			END IF

		END IF

	END IF

RETURN ( nPvp )

//---------------------------------------------------------------------------//

STATIC FUNCTION ChgPrc( dbfArticulo, oWndBrw )

	local oDlg
	local cFam		:= Space( 5 )
	local oFam
	local cTxtFam
	local oTxtFam
	local cTipIva	:= Space( 1 )
	local oTipIva
	local cTxtIva
	local oTxtIva
	local cDiv		:= Space( 3 )
	local oDiv
	local cBmpDiv
	local oBmpDiv
	local lPvd		:= .f.
	local lPvp		:= .f.
	local lPcs		:= .f.
	local oRad
	local nRad		:= 1
	local nPctInc	:= 0
	local nUndInc	:= 0
	local lRnd		:= .f.
	local nDec		:= 0

	/*
	Llamada a la funcion que activa la caja de dialogo
	*/

	DEFINE DIALOG oDlg RESOURCE "CHGPRE"

	REDEFINE GET oFam VAR cFam ;
		ID 		100 ;
		VALID 	( cFamilia( oFam, , oTxtFam ) );
      BITMAP   "LUPA" ;
      ON HELP  ( BrwFamilia( oFam, oTxtFam ) );
		COLOR 	CLR_GET ;
		OF 		oDlg

	REDEFINE GET oTxtFam VAR cTxtFam ;
		ID 		110 ;
		WHEN		.F. ;
		COLOR 	CLR_GET ;
		OF 		oDlg

	REDEFINE GET oTipIva VAR cTipIva ;
		ID 		120 ;
		VALID 	( cTiva( oTipIva, dbfIva , oTxtIva ) );
      BITMAP   "LUPA" ;
		ON HELP 	( BrwIva( oTipIva, dbfIva, oTxtIva ) );
		COLOR 	CLR_GET ;
		OF 		oDlg

	REDEFINE GET oTxtIva VAR cTxtIva ;
		ID 		130 ;
		WHEN		.F. ;
		COLOR 	CLR_GET ;
		OF 		oDlg

	REDEFINE GET oDiv VAR cDiv;
		PICTURE	"@!";
		VALID		cDiv( oDiv, oBmpDiv );
		ID 		140 ;
		COLOR 	CLR_GET ;
      BITMAP   "LUPA" ;
      ON HELP  BrwDiv( oDiv, oBmpDiv, , dbfDivisa, oBandera ) ;
		OF 		oDlg

	REDEFINE BITMAP oBmpDiv ;
		ID 		150;
		OF 		oDlg

	REDEFINE CHECKBOX lPVD ;
		ID 		161 ;
		OF 		oDlg

	REDEFINE CHECKBOX lPVP ;
		ID 		162 ;
		OF 		oDlg

	REDEFINE CHECKBOX lPcs ;
		ID 		163 ;
		OF 		oDlg

	REDEFINE RADIO oRad VAR nRad ;
		ID 		170, 172 ;
		OF 		oDlg

	REDEFINE GET nPctInc ;
		WHEN		( nRad == 1 ) ;
		PICTURE	"@E 999.99" ;
		SPINNER ;
		ID 		171 ;
		OF 		oDlg

	REDEFINE GET nUndInc ;
		WHEN		( nRad == 2 ) ;
		PICTURE	"@E 9,999,999.99" ;
		ID 		173 ;
		OF 		oDlg

	REDEFINE CHECKBOX lRnd ;
		ID 		180 ;
		OF 		oDlg

	REDEFINE GET nDec ;
		PICTURE	"@E 9" ;
		SPINNER ;
		ID 		190 ;
		OF 		oDlg

	REDEFINE BUTTON ;
      ID       IDOK ;
		OF 		oDlg ;
		ACTION 	( mkChgPrc( cFam, cTipIva, cDiv, lPvd, lPvp, lPcs, nRad, nPctInc, nUndInc, lRnd, nDec, dbfArticulo ),;
					oDlg:end() ,;
					oWndBrw:refresh() )

	REDEFINE BUTTON ;
      ID       IDCANCEL ;
		OF 		oDlg ;
		ACTION	( oDlg:end() )

	ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

STATIC FUNCTION mkChgPrc( cFam, cIva, cDiv, lPvd, lPvp, lPcs, nRad, nPctInc, nUndInc, lRnd, nDec, dbfArticulo )

	local nRecAct	:= ( dbfArticulo )->( RecNo() )

	( dbfArticulo )->( dbGoTop() )

	WHILE !( dbfArticulo )->( eof() )

      dbDialogLock( dbfArticulo )

		/*
      Vemos si cumplimos las condiciones de familia y tipo de IGIC
		*/

		IF ( empty( cFam ) .OR. ( dbfArticulo )->FAMILIA == cFam ) .AND. ;
			( empty( cIva ) .OR. ( dbfArticulo )->TIPOIVA == cIva )

			/*
			Esta vacia la divisa
			*/

			IF !empty( cDiv )

				/*
				Comprobamos si existe un precio para esta divisa
				*/

				IF !( dbfDiv )->( dbSeek( ( dbfArticulo )->CODIGO + cDiv ) )

					/*
					Alta a la divisa
					*/

					( dbfDiv )->( dbAppend() )
					( dbfDiv )->CCODART	:= ( dbfArticulo )->CODIGO
					( dbfDiv )->CCODDIV	:= cDiv
					( dbfDiv )->NPVDDIV	:= ( dbfArticulo )->PVENTA1 / nChgDiv( cDiv )
					( dbfDiv )->NPVPDIV	:= ( dbfArticulo )->PVENTA3 / nChgDiv( cDiv )

				END IF

				/*
				Aplicamos el cambio si esta marcado el precio venta p£blico
				*/

            dbDialogLock( dbfDiv )

					IF lPvp
						IF nRad == 1
							( dbfDiv )->NPVPDIV	+= ( dbfDiv )->NPVPDIV * nPctInc / 100
						ELSE
							( dbfDiv )->NPVPDIV	+= nUndInc
						END IF
					END IF

)[PATHEMPRESA] + "\PROVEE.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROVEE", @dbfProvee ) )
      SET ADSINDEX TO ( cPatEmp() + "\PROVEE.CDX" ) ADDITIVE

      USE ( cPatEmp() +"\PEDPROVT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDPROVT", @dbfPedPrvT ) )
      SET ADSINDEX TO ( cPatEmp() + "\PEDPROVT.CDX" ) ADDITIVE
		SET TAG TO CCODPRV

      USE ( cPatEmp() + "\PEDPROVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDPROVL", @dbfPedPrvL ) )
      SET ADSINDEX TO ( cPatEmp() + "\PEDPROVL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "\ALBPROVT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBPROVT", @dbfAlbPrvT ) )
      SET ADSINDEX TO ( cPatEmp() + "\ALBPROVT.CDX" ) ADDITIVE
		SET TAG TO CCODPRV

      USE ( cPatEmp() + "\ALBPROVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBPROVL", @dbfAlbPrvL ) )
      SET ADSINDEX TO ( cPatEmp() + "\ALBPROVL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "\FACPRVT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVT", @dbfFacPrvT ) )
      SET ADSINDEX TO ( cPatEmp() + "\FACPRVT.CDX" ) ADDITIVE
		SET TAG TO CCODPRV

      USE ( cPatEmp() + "\FACPRVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVL", @dbfFacPrvL ) )
      SET ADSINDEX TO ( cPatEmp() + "\FACPRVL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "\FPAGO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FPAGO", @dbfFPago ) )
      SET ADSINDEX TO ( cPatEmp() + "\FPAGO.CDX" ) ADDITIVE

      USE ( cPatEmp() + "\PROVART.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROVART", @dbfArtPrv ) )
      SET ADSINDEX TO ( cPatEmp() + "\PROVART.CDX" ) ADDITIVE

      USE ( cPatDat() + "\TIVA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfIva ) )
      SET ADSINDEX TO ( cPatDat() + "\TIVA.CDX" ) ADDITIVE

      USE ( cPatEmp() + "\ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
      SET ADSINDEX TO ( cPatEmp() + "\ARTICULO.CDX" ) ADDITIVE

      USE ( cPatEmp() + "\ARTPRECI.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTPRECIO", @dbfArtPre ) )
      SET ADSINDEX TO ( cPatEmp() + "\ARTPRECI.CDX" ) ADDITIVE

      USE ( cPatDat() + "\DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDivisa ) )
      SET ADSINDEX TO ( cPatDat() + "\DIVISAS.CDX" ) ADDITIVE

      USE ( cPatDat() + "\BANDERA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "BANDERA", @oBandera ) )
      SET ADSINDEX TO ( cPatDat() + "\BANDERA.CDX" ) ADDITIVE

      RECOVER

         CloseFiles()
         RETURN .f.

      BREAK

      END SEQUENCE

	END IF

RETURN .t.

//----------------------------------------------------------------------------//

FUNCTION Provee( oWnd )

	IF oWndBrw == NIL

      IF !OpenFiles()
         RETURN NIL
      END IF

      DEFINE SHELL oWndBrw FROM 0, 0 TO 22, 80 ;
			TITLE 	"Proveedores" ;
			FIELDS 	(dbfProvee)->COD,;
						(dbfProvee)->TITULO,;
						(dbfProvee)->NIF,;
						(dbfProvee)->DOMICILIO,;
						(dbfProvee)->POBLACION,;
						(dbfProvee)->PROVINCIA,;
						(dbfProvee)->CODPOSTAL;
			HEAD 		"Codg.",;
						"Nombre",;
						"Nif",;
						"Domicilio",;
						OemToAnsi("Poblaci¢n"),;
						"Provincia",;
						"Cod. Postal";
         PROMPT   "Codigo",;
						"Nombre";
			ALIAS		( dbfProvee ) ;
			APPEND	( WinAppRec( oWndBrw:oBrw, bEdit, dbfProvee, , {|oGet| NotValid( oGet, dbfProvee, .T., "0" ) } ) );
			DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdit, dbfProvee, , {|oGet| NotValid( oGet, dbfProvee, .T., "0" ) } ) );
			EDIT 		( WinEdtRec( oWndBrw:oBrw, bEdit, dbfProvee ) ) ;
			DELETE   ( DBDelRec(  oWndBrw:oBrw, dbfProvee ) ) ;
			OF 		oWnd

		DEFINE BTNSHELL RESOURCE "NEW" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( oWndBrw:RecAdd() );
			ON DROP	( oWndBrw:RecDup() );
			TOOLTIP 	"(A)ñadir";
			HOTKEY 	"A"

		DEFINE BTNSHELL RESOURCE "DUP" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( oWndBrw:RecDup() );
			TOOLTIP 	"(D)uplicar";
			HOTKEY 	"D"

		DEFINE BTNSHELL RESOURCE "EDIT" OF oWndBrw ;
			NOBORDER ;
			ACTION  	( oWndBrw:RecEdit() );
			TOOLTIP 	"(M)odificar";
			HOTKEY 	"M"

		DEFINE BTNSHELL RESOURCE "ZOOM" OF oWndBrw ;
			NOBORDER ;
			ACTION  	( WinZooRec( oWndBrw:oBrw, bEdit, dbfProvee ) );
			TOOLTIP 	"(Z)oom";
			HOTKEY 	"Z"

		DEFINE BTNSHELL RESOURCE "DEL" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( oWndBrw:RecDel() );
			TOOLTIP 	"(E)liminar";
			HOTKEY 	"E"

      DEFINE BTNSHELL RESOURCE "BUS" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:Search() ) ;
			TOOLTIP 	"(B)uscar" ;
			HOTKEY 	"B"

		DEFINE BTNSHELL RESOURCE "IMP" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( GenReport( dbfProvee ) ) ;
			TOOLTIP 	"(L)istado";
			HOTKEY 	"L"

		DEFINE BTNSHELL RESOURCE "LBL" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( GenLabels( dbfProvee ) ) ;
         TOOLTIP  "Eti(q)uetas" ;
         HOTKEY   "Q"

      DEFINE BTNSHELL RESOURCE "END" GROUP OF oWndBrw ;
			NOBORDER ;
			ACTION 	( oWndBrw:End() ) ;
			TOOLTIP 	"(S)alir" ;
			HOTKEY 	"S"

		ACTIVATE WINDOW oWndBrw VALID ( CloseFiles( .t. ) )

	ELSE

		oWndBrw:SetFocus()

	END IF

RETURN NIL

//----------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aTmp, aGet, dbfProvee, oBrw, bWhen, bValid, nMode )

	local oGet
	local oDlg
	local oFld
	local oSay1
	local cSay1
	local oGetSubCta
	local cGetSubCta
	local oGetCta
	local cGetCta
	local oBrwPed
	local oBrwAlb
	local oBrwFac
	local oBrwAbn
	local aDbfBmp  := { 	LoadBitmap( GetResources(), "BGREEN" ),;
								LoadBitmap( GetResources(), "BRED" ) }

	#ifdef __VAL
	IF nMode == APPD_MODE
      MsgStop( "Imposible añadir proveedores en esta versión" )
		RETURN .F.
	END IF
	#endif

	DEFINE DIALOG oDlg RESOURCE "PROVEEDOR" TITLE lblTitle( nMode ) + "Proveedores : " + Rtrim( aTmp[_TITULO] )

	REDEFINE FOLDER oFld;
			ID 		300 ;
			OF 		oDlg ;
			PROMPT 	"&General", "&Bancos-Cuentas", "Pedidos-Albaranes", "Facturas-Abonos" ;
			DIALOGS 	"PROVEEDOR_1", "PROVEEDOR_2", "PROVEEDOR_3", "PROVEEDOR_4"

			oFld:aEnable	:= { .t., .t., nMode != APPD_MODE, nMode != APPD_MODE }

		/*
		Redefinici¢n de la primera caja de Dialogo_____________________________
		*/

		REDEFINE GET oGet VAR aTmp[_COD] ;
			ID 		110 ;
			WHEN 		( nMode == APPD_MODE ) ;
         PICTURE  ( replicate( "X", RetNumCodPrvEmp() ) );
			VALID 	( NotValid( oGet, dbfProvee, .T., "0", 1, RetNumCodCliEmp() ) ) ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[1]

		REDEFINE GET aGet[_TITULO] VAR aTmp[_TITULO];
         ID       120 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@!" ;
			ON CHANGE( ActTitle( nKey, nFlags, Self, nMode, oDlg ) );
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

		REDEFINE GET aGet[_NIF] VAR aTmp[_NIF];
         ID       130 ;
         VALID    ( CheckCif( aGet[_NIF] ) );
         WHEN     ( nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

		REDEFINE GET aGet[_DOMICILIO] VAR aTmp[_DOMICILIO];
         ID       140 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

		REDEFINE GET aGet[_POBLACION] VAR aTmp[_POBLACION];
         ID       150 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

		REDEFINE GET aGet[_CODPOSTAL] VAR aTmp[_CODPOSTAL] ;
         ID       160 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

		REDEFINE GET aGet[_PROVINCIA] VAR aTmp[_PROVINCIA] ;
         ID       170 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

		REDEFINE GET aGet[_TELEFONO] VAR aTmp[_TELEFONO] ;
         ID       180 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

		REDEFINE GET aGet[_FAX] VAR aTmp[_FAX] ;
         ID       190 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

		REDEFINE GET aGet[_DTOPP] VAR aTmp[_DTOPP] ;
         ID       200 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
         PICTURE  "@E 999.9" ;
         OF       oFld:aDialogs[1]

		REDEFINE GET aGet[_FPAGO] VAR aTmp[_FPAGO] ;
			ID 		210 ;
			PICTURE 	"@!" ;
			COLOR 	CLR_GET ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			VALID 	( cFpago( aGet[_FPAGO], dbfFPago, oSay1 ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwFpago( aGet[_FPAGO], oSay1 ) ) ;
			OF 		oFld:aDialogs[1]

		REDEFINE GET oSay1 VAR cSay1;
			ID 		330 ;
			WHEN 		.F. ;
			COLOR		CLR_GET ;
			OF 		oFld:aDialogs[1]

		REDEFINE GET aGet[_DIAPAGO] VAR aTmp[_DIAPAGO] ;
			ID 		220 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			PICTURE 	"99" ;
			OF 		oFld:aDialogs[1]

		REDEFINE GET aGet[_CCODSND] VAR aTmp[_CCODSND] ;
			ID 		230 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[1]

		REDEFINE GET aGet[_CMEIINT] VAR aTmp[_CMEIINT] ;
			ID 		240 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[1]

		REDEFINE GET aGet[_CWEBINT] VAR aTmp[_CWEBINT] ;
			ID 		250 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[1]

		/*
		Segunda caja de Dialogo________________________________________________
		*/

		REDEFINE GET aGet[_BANCO] VAR aTmp[_BANCO];
			ID 		230 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[2]

		REDEFINE GET aGet[_DIRBANCO] VAR aTmp[_DIRBANCO];
			ID 		240 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[2]

		REDEFINE GET aGet[_POBBANCO] VAR aTmp[_POBBANCO] ;
			ID 		250 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[2]

		REDEFINE GET aGet[_CPROBANCO] VAR aTmp[_CPROBANCO] ;
			ID 		260 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[2]

		REDEFINE GET aGet[_CUENTA] VAR aTmp[_CUENTA] ;
			ID 		270 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( CalcDigit( aTmp[_CUENTA], aGet[_CUENTA] ), .t. ) ;
			PICTURE 	"@R ####-####-##-##########" ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[2]

		REDEFINE GET aGet[_SUBCTA] VAR aTmp[_SUBCTA] ;
			ID 		310 ;
			COLOR 	CLR_GET ;
         PICTURE  ( Replicate( "X", nLenSubcuentaContaplus() ) ) ;
         WHEN     ( nLenCuentaContaplus() != 0 .AND. nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwChkSubcuenta( aGet[_SUBCTA], oGetSubCta ) ) ;
			VALID 	( MkSubcuenta( aGet[_SUBCTA],;
                              {  aTmp[ _SUBCTA    ],;
                                 aTmp[ _TITULO    ],;
                                 aTmp[ _NIF       ],;
											aTmp[ _DOMICILIO ],;
											aTmp[ _POBLACION ],;
											aTmp[ _PROVINCIA ],;
											aTmp[ _CODPOSTAL ] },;
										oGetSubCta );
						);
			OF oFld:aDialogs[2]

		REDEFINE GET oGetSubCta VAR cGetSubCta ;
			ID 		311 ;
			WHEN 		.F. ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[2]

		REDEFINE GET aGet[_CTAVENTA] VAR aTmp[_CTAVENTA] ;
			ID 		320 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( ChkCta( aTmp[_CTAVENTA], oGetCta, .t. ) ) ;
			COLOR 	CLR_GET ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwChkCta( aGet[_CTAVENTA], oGetCta ) ) ;
			OF 		oFld:aDialogs[2]

		REDEFINE GET oGetCta VAR cGetCta ;
			ID 		321 ;
			WHEN 		.F. ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[2]

		/*
		Tercera caja de dialogo_________________________________					IF lPvd
						IF nRad == 1
							( dbfDiv )->NPVDDIV	+= ( dbfDiv )->NPVDDIV * nPctInc / 100
						ELSE
							( dbfDiv )->NPVDDIV	+= nUndInc
						END IF
					END IF

					IF lRnd
						( dbfDiv )->NPVDDIV	:= Round( ( dbfDiv )->NPVDDIV, nDec )
						( dbfDiv )->NPVPDIV	:= Round( ( dbfDiv )->NPVPDIV, nDec )
					END IF

					( dbfDiv )->( dbUnlock() )

			ELSE

				/*
				Si nos dejan el campo de la divisa vacio
				*/

				/*
				Estudio de precios
				*/

				IF lPvp
					IF nRad == 1
						( dbfArticulo )->PVENTA3	+= ( dbfArticulo )->PVENTA3 * nPctInc / 100
					ELSE
						( dbfArticulo )->PVENTA3	+= nUndInc
					END IF
				END IF

				IF lPvd
					IF nRad == 1
						( dbfArticulo )->PVENTA1	+= ( dbfArticulo )->PVENTA1 * nPctInc / 100
					ELSE
						( dbfArticulo )->PVENTA1	+= nUndInc
					END IF
				END IF

				IF lPcs
					IF nRad == 1
						( dbfArticulo )->PCOSTO	+= ( dbfArticulo )->PCOSTO * nPctInc / 100
					ELSE
						( dbfArticulo )->PCOSTO	+= nUndInc
					END IF
				END IF

				/*
				Redondeamos si no lo piden
				*/

				IF lRnd
					( dbfArticulo )->PVENTA1	:= Round( ( dbfArticulo )->PVENTA1, nDec )
					( dbfArticulo )->PVENTA3	:= Round( ( dbfArticulo )->PVENTA3, nDec )
					( dbfArticulo )->PCOSTO		:= Round( ( dbfArticulo )->PCOSTO, nDec )
				END IF

			END IF

		END IF

      IF ( dbfArticulo )->LBNF1 .AND. ( dbfArticulo )->BENEF1 != 0 .AND. ( dbfArticulo )->PCOSTO != 0
         ( dbfArticulo )->PVENTA1   := ( ( dbfArticulo )->PCOSTO * ( dbfArticulo )->BENEF1 / 100 ) + ( dbfArticulo )->PCOSTO
         ( dbfArticulo )->PVTAIVA1  := ( ( dbfArticulo )->PVENTA1 * nIva( dbfIva, ( dbfArticulo )->TIPOIVA ) / 100 ) + ( dbfArticulo )->PVENTA1
      END IF

      IF ( dbfArticulo )->LBNF3 .AND. ( dbfArticulo )->BENEF3 != 0 .AND. ( dbfArticulo )->PCOSTO != 0
         ( dbfArticulo )->PVENTA3   := ( ( dbfArticulo )->PCOSTO * ( dbfArticulo )->BENEF3 / 100 ) + ( dbfArticulo )->PCOSTO
         ( dbfArticulo )->PVTAIVA3  := ( ( dbfArticulo )->PVENTA3 * nIva( dbfIva, ( dbfArticulo )->TIPOIVA ) / 100 ) + ( dbfArticulo )->PVENTA3
      END IF

	( dbfArticulo )->( dbUnlock() )
	( dbfArticulo )->( dbSkip() )

	END DO

	( dbfArticulo )->( dbGoto( nRecAct ) )

RETURN NIL

//---------------------------------------------------------------------------//

FUNCTION Filter( dbfArticulo, aBase, oBrw, cExp )

	local oDlg
	local oFld		:= array( 5 )
	local aFld		:= { "", "", "", "", "" }
	local oCon		:= array( 5 )
	local aCon		:= { "", "", "", "", "" }
	local oVal		:= array( 5 )
	local aVal		:= { Space( 100 ), Space( 100 ), Space( 100 ),  Space( 100 ), Space( 100 ) }
	local oNex  	:= array( 4 )
	local aNex		:= { "", "", "", "" }
	local aTblMas	:= {}				// Muestra las mascaras
	local aTblFld	:= {}				// Muestra las campos
	local aTblTip	:= {}				// Tipos de campo
	local aTblLen	:= {}				// Len del campo
	local aTblDec	:= {}				// Decimales del campo
	local aTblPic	:= {}				// Muestra las pictures
   local aTblNex  := {  "", "Y", "O" }
   local aTblCon  := {  "Igual",;
								"Distinto",;
								"Mayor",;
								"Menor",;
								"Mayor igual",;
								"Menor igual",;
								"Contenga" }

	DEFAULT cExp	:= ""

	FOR n := 1