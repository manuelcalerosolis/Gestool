#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Report.ch"

/*
Definici¢n de la base de datos de Existencias
*/

#define _CSEREXT                  (dbfExtAgeT)->( FieldPos( "CSEREXT" ) )
#define _NNUMEXT                  (dbfExtAgeT)->( FieldPos( "NNUMEXT" ) )
#define _CSUFEXT                  (dbfExtAgeT)->( FieldPos( "CSUFEXT" ) )
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
Definici¢n de Array para impuestos
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
Definici¢n de Array para objetos impuestos
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
static nLevel
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
static oStock
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
static aBase      := {  { "CSEREXT"   ,"C",  1, 0, "Serie de las existencias de almacen" },;
                        { "NNUMEXT"   ,"N",  9, 0, "Número de las existencias de almacen" },;
                        { "CSUFEXT"   ,"C",  2, 0, "Sufijo de las existencias de almacen" },;
                        { "DFECEXT"   ,"D",  8, 0, "Fecha del las existencias" },;
                        { "CCODALM"   ,"C", 16, 0, "Codigo de almacen" },;
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

static aBase2     := {  { "CSEREXT"   ,"C",  1, 0, "Serie de las existencias de almacen" },;
                        { "NNUMEXT"   ,"N",  9, 0, "Número de las existencias de almacen" },;
                        { "CSUFEXT"   ,"C",  2, 0, "Sufijo de las existencias de almacen" },;
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

   local lOpen       := .t.
   local oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   USE ( cPatEmp() + "EXTAGET.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "EXTAGET", @dbfExtAgeT ) )
   SET ADSINDEX TO ( cPatEmp() + "EXTAGET.CDX" ) ADDITIVE

   USE ( cPatEmp() + "EXTAGEL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "EXTAGEL", @dbfExtAgeL ) )
   SET ADSINDEX TO ( cPatEmp() + "EXTAGEL.CDX" ) ADDITIVE

   USE ( cPatDat() + "TIVA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfIva ) )
   SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE

   USE ( cPatEmp() + "FPAGO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FPAGO", @dbfFPago ) )
   SET ADSINDEX TO ( cPatEmp() + "FPAGO.CDX" ) ADDITIVE

   USE ( cPatAlm() + "ALMACEN.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALMACEN", @dbfAlmT ) )
   SET ADSINDEX TO ( cPatAlm() + "ALMACEN.CDX" ) ADDITIVE

   USE ( cPatArt() + "TARPREL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TARPREL", @dbfTarPreL ) )
   SET ADSINDEX TO ( cPatArt() + "TARPREL.CDX" ) ADDITIVE

   USE ( cPatArt() + "PROMOT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROMOT", @dbfPromoT ) )
   SET ADSINDEX TO ( cPatArt() + "PROMOT.CDX" ) ADDITIVE

   USE ( cPatArt() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
   SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

   USE ( cPatEmp() + "MOVALM.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "MOVALM", @dbfMov ) )
   SET ADSINDEX TO ( cPatEmp() + "MOVALM.CDX" ) ADDITIVE

   USE ( cPatArt() + "ARTKIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTTIK", @dbfKit ) )
   SET ADSINDEX TO ( cPatArt() + "ARTKIT.CDX" ) ADDITIVE

   USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDivisa ) )
   SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

   oBandera             := TBandera():New()
   oStock               := TStock():Create()
   if !oStock:lOpenFiles()
      lOpen             := .f.
   else
      oStock:cExtAgeT   := dbfExtAgeT
      oStock:cExtAgeL   := dbfExtAgeL
      oStock:cKit       := dbfKit
   end if

   RECOVER

      lOpen             := .f.
      msgStop( "Imposible abrir todas las bases de datos" )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpen
      CloseFiles()
   end if

RETURN ( lOpen )

//----------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles()

   if oWndBrw != nil
		oWndBrw:oBrw:lCloseArea()
      oWndBrw     := nil
   else
      ( dbfExtAgeT )->( dbCloseArea() )
   end if

   ( dbfExtAgeL )->( dbCloseArea() )
   ( dbfIva     )->( dbCloseArea() )
	( dbfFPago   )->( dbCloseArea() )
	( dbfAlmT    )->( dbCloseArea() )
	( dbfTarPreL )->( dbCloseArea() )
   ( dbfPromoT  )->( dbCloseArea() )
	( dbfArticulo)->( dbCloseArea() )
	( dbfMov     )->( dbCloseArea() )
   ( dbfKit     )->( dbCloseArea() )
   ( dbfDivisa  )->( dbCloseArea() )

   if !Empty( oStock )
      oStock:end()
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
   oBandera    := nil
   oStock      := nil

RETURN .T.

//----------------------------------------------------------------------------//

FUNCTION ExtAge( oMenuItem, oWnd )

	local oBtnEur
	local lEuro		:= .f.
	local aDbfBmp  := { 	LoadBitmap( GetResources(), "BMPESTADO1" ),;
								LoadBitmap( GetResources(), "BMPESTADO3" ) }

   DEFAULT  oMenuItem   := "01029"
   DEFAULT  oWnd        := oWnd()

   if oWndBrw == nil

      /*
      Obtenemos el nivel de acceso
      */

      if nLevel == nil
         nLevel := nLevelUsr( oMenuItem )
      end if

      if nAnd( nLevel, 1 ) != 0
         msgStop( "Acceso no permitido." )
         return nil
      end if

      /*
      Cerramos todas las ventanas
      */

      if oWnd != nil
         SysRefresh(); oWnd:CloseAll(); SysRefresh()
      end if

      if !OpenFiles()
         return nil
      end if

      /*
      Anotamos el movimiento para el navegador
      */

      AddMnuNext( "Estado de depositos", ProcName() )

      cPouEur     := cPouDiv( "EUR", dbfDivisa )            // Picture del euro
      cPicUnd     := MasUnd()                               // Picture de las unidades

      DEFINE SHELL oWndBrw FROM 0, 0 TO 22, 80 ;
         TITLE    "Estado de depositos" ;
         FIELDS   If ( (dbfExtAgeT)->LLIQEXT, aDbfBmp[1], aDbfBmp[2] ), ;
                  (dbfExtAgeT)->CSEREXT + "/" + Str( (dbfExtAgeT)->NNUMEXT ) + "/" + (dbfExtAgeT)->CSUFEXT,;
                  Dtoc( (dbfExtAgeT)->DFECEXT ),;
                  (dbfExtAgeT)->CCODALM + Space(1) + RetAlmacen( (dbfExtAgeT)->CCODALM, dbfAlmT ),;
                  hBmpDiv( (dbfExtAgeT)->CDIVEXT, dbfDivisa, oBandera ),;
                  nTotal( (dbfExtAgeT)->CSEREXT + Str( (dbfExtAgeT)->NNUMEXT ) + (dbfExtAgeT)->CSUFEXT, dbfExtAgeT, dbfExtAgeL, dbfIva, dbfDivisa, nil, lEuro );
			HEAD 		"Liq.",;
                  "Número",;
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
         JUSTIFY  .F., .F., .F., .F., .F., .T.;
         PROMPTS  "Número",;
						"Fecha",;
						"Almacen";
         ALIAS    ( dbfExtAgeT );
         APPEND   ( WinAppRec( oWndBrw:oBrw, bEdit, dbfExtAgeT ) );
         DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdit, dbfExtAgeT ) );
         EDIT     ( WinEdtRec( oWndBrw:oBrw, bEdit, dbfExtAgeT ) );
         DELETE   ( dbDelRec(  oWndBrw:oBrw, dbfExtAgeT, {|| delDetalle( (dbfExtAgeT)->CSEREXT + Str( (dbfExtAgeT)->NNUMEXT ) + (dbfExtAgeT)->CSUFEXT ) } ) ) ;
         LEVEL    nLevel ;
         OF       oWnd

         oWndBrw:lAutoSeek := .f.

      DEFINE BTNSHELL RESOURCE "BUS" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:SearchSetFocus() ) ;
         TOOLTIP  "(B)uscar";
			HOTKEY 	"B"

      oWndBrw:AddSeaBar()

		DEFINE BTNSHELL RESOURCE "NEW" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( oWndBrw:RecAdd() );
			ON DROP	( oWndBrw:RecDup() );
			TOOLTIP 	"(A)ñadir";
         HOTKEY   "A";
         BEGIN GROUP ;
         LEVEL    ACC_APPD

		DEFINE BTNSHELL RESOURCE "DUP" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( oWndBrw:RecDup() );
			TOOLTIP 	"(D)uplicar";
         HOTKEY   "D";
         LEVEL    ACC_APPD

		DEFINE BTNSHELL RESOURCE "EDIT" OF oWndBrw ;
			NOBORDER ;
			ACTION  	( oWndBrw:RecEdit() );
			TOOLTIP 	"(M)odificar";
         HOTKEY   "M";
         LEVEL    ACC_EDIT

		DEFINE BTNSHELL RESOURCE "ZOOM" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( WinZooRec( oWndBrw:oBrw, bEdit, dbfExtAgeT ) );
			TOOLTIP 	"(Z)oom";
         HOTKEY   "Z";
         LEVEL    ACC_ZOOM

		DEFINE BTNSHELL RESOURCE "DEL" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( oWndBrw:RecDel() );
			TOOLTIP 	"(E)liminar";
         HOTKEY   "E";
         LEVEL    ACC_DELE

      DEFINE BTNSHELL RESOURCE "CHGSTATE" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( ChgState( oWndBrw:oBrw ) ) ;
			TOOLTIP 	"Cambiar Es(t)ado" ;
         HOTKEY   "T";
         LEVEL    ACC_EDIT

		DEFINE BTNSHELL oBtnEur RESOURCE "gc_currency_euro_" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( lEuro := !lEuro, oBtnEur:lPressed := lEuro, oWndBrw:refresh() ) ;
			TOOLTIP 	"E(u)ros";
         HOTKEY   "U";
         LEVEL    ACC_ZOOM

      DEFINE BTNSHELL RESOURCE "IMP" GROUP OF oWndBrw ;
			NOBORDER ;
         ACTION   ( GenExtAge( .T. ) ) ;
			TOOLTIP 	"(I)mprimir";
         HOTKEY   "I";
         LEVEL    ACC_ZOOM

		DEFINE BTNSHELL RESOURCE "PREV1" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( GenExtAge( .F. ) ) ;
			TOOLTIP 	"(P)revisualizar";
         HOTKEY   "P";
         LEVEL    ACC_ZOOM

      DEFINE BTNSHELL RESOURCE "GC_PRINTER2_" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( PrnSerie() ) ;
         TOOLTIP  "Imp(r)imir series";
         HOTKEY   "R";
         LEVEL    ACC_ZOOM

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
      aTmp[ _CSEREXT ]  := "A"
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
			COLOR 	CLR_SHOW ;
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
         VALID    (  cDiv( aGet[ _CDIVEXT ], oBmpDiv, aGet[ _NVDVEXT ], @cPinDiv, @nDinDiv, dbfDivisa, oBandera ),;
                     nTotal( nil, dbfExtAgeT, dbfTmp, dbfIva, dbfDivisa, aTmp ),;
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

		REDEFINE LISTBOX oBrw2 ;
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
                  "Codigoqwew",;
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

			oBrw2:aJustify := { .F., .F., .T., .T., .T., .T., .T., .T., .T. }

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
			COLOR 	CLR_GET ;
			VALID		( nRecTotal( dbfTmp, aTmp ) );
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

		REDEFINE GET aGet[ _NDTORAP ] VAR aTmp[ _NDTORAP ];
			ID 		240 ;
			PICTURE 	"@E 99.99" ;
			COLOR 	CLR_GET ;
			VALID		( nRecTotal( dbfTmp, aTmp ) );
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

		REDEFINE GET aGet[ _NDTOPUB ] VAR aTmp[ _NDTOPUB ];
			ID 		250 ;
			PICTURE 	"@E 99.99" ;
			COLOR 	CLR_GET ;
			VALID		( nRecTotal( dbfTmp, aTmp ) );
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

		REDEFINE GET aGet[ _NDTOPGO ] VAR aTmp[ _NDTOPGO ];
			ID 		260 ;
			PICTURE 	"@E 99.99" ;
			COLOR 	CLR_GET ;
			VALID		( nRecTotal( dbfTmp, aTmp ) );
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

		/*
		Caja de Totales_________________________________________________________
		*/

		REDEFINE SAY _OBASIVA1 VAR _NBASIVA1 ;
			ID 		270;
			PICTURE 	cPinDiv ;
			OF 		oDlg

		REDEFINE SAY _OBASIVA2 VAR _NBASIVA2 ;
			ID 		280 ;
			PICTURE 	cPinDiv ;
			OF 		oDlg

		REDEFINE SAY _OBASIVA3 VAR _NBASIVA3 ;
			ID 		290;
			PICTURE 	cPinDiv ;
			OF 		oDlg

		REDEFINE SAY _OPCTIVA1 VAR _NPCTIVA1 ;
			ID 		300;
			PICTURE 	"@E 99.99" ;
			OF 		oDlg

		REDEFINE SAY _OPCTIVA2 VAR _NPCTIVA2 ;
			ID 		310 ;
			PICTURE 	"@E 99.99" ;
			OF 		oDlg

		REDEFINE SAY _OPCTIVA3 VAR _NPCTIVA3 ;
			ID 		320 ;
			PICTURE 	"@E 99.99" ;
			OF 		oDlg

		REDEFINE SAY _OIMPIVA1 VAR nImpIva1 ;
			ID 		330 ;
			PICTURE 	cPinDiv ;
			OF 		oDlg

		REDEFINE SAY _OIMPIVA2 VAR nImpIva2 ;
			ID 		340 ;
			PICTURE 	cPinDiv ;
			OF 		oDlg

		REDEFINE SAY _OIMPIVA3 VAR nImpIva3 ;
			ID 		350 ;
			PICTURE 	cPinDiv ;
			OF 		oDlg

		/*
		Cajas Bases de los R.E.-------------------------------------------------------
		*/

		REDEFINE SAY _OPCTREQ1 VAR _NPCTREQ1 ;
			ID 		360;
			PICTURE 	"@E 99.99" ;
			OF 		oDlg

		REDEFINE SAY _OPCTREQ2 VAR _NPCTREQ2 ;
			ID 		370;
			PICTURE 	"@E 99.99" ;
			OF 		oDlg

		REDEFINE SAY _OPCTREQ3 VAR _NPCTREQ3 ;
			ID 		380;
			PICTURE 	"@E 99.99" ;
			OF 		oDlg

		REDEFINE SAY _OIMPREQ1 VAR nImpReq1 ;
			ID 		390 ;
			PICTURE 	cPinDiv ;
			OF 		oDlg

		REDEFINE SAY _OIMPREQ2 VAR nImpReq2 ;
			ID 		400 ;
			PICTURE 	cPinDiv ;
			OF 		oDlg

		REDEFINE SAY _OIMPREQ3 VAR nImpReq3 ;
			ID 		410 ;
			PICTURE 	cPinDiv ;
			OF 		oDlg

		/*
		Cajas de Totales
		------------------------------------------------------------------------
		*/

		REDEFINE SAY oGetNet VAR nGetNet ;
			ID 		420 ;
			PICTURE	cPinDiv ;
			OF 		oDlg

		REDEFINE SAY oGetIva VAR nGetIva ;
			ID 		430 ;
			PICTURE	cPinDiv ;
			OF 		oDlg

		REDEFINE SAY oGetReq VAR nGetReq ;
			ID 		440 ;
			PICTURE	cPinDiv ;
			OF 		oDlg

		REDEFINE CHECKBOX aGet[_LRECARGO] VAR aTmp[_LRECARGO] ;
			ID 		450 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ON CHANGE( nTotal( nil, dbfExtAgeT, dbfTmp, dbfIva, dbfDivisa, aTmp ) );
			OF 		oDlg

		REDEFINE SAY oGetTotal VAR nTotal;
			ID 		460 ;
			PICTURE 	cPinDiv ;
			FONT 		oFont ;
			OF 		oDlg

		REDEFINE SAY oGetTotEur VAR nTotalEur;
			ID 		470 ;
			PICTURE 	cPicEur ;
			OF 		oDlg

		REDEFINE BUTTON ;
			ID 		500 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			ACTION 	( AppDeta( oBrw2, bEdit2, aTmp ) )

		REDEFINE BUTTON ;
			ID 		501 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			ACTION 	( EdtDeta( oBrw2, bEdit2, aTmp ) )

		REDEFINE BUTTON ;
			ID 		502 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			ACTION 	( DelDeta( oBrw2, aTmp ) )

		REDEFINE BUTTON ;
			ID 		503 ;
			OF 		oDlg ;
			ACTION 	( EdtZoom( oBrw2, bEdit2, aTmp ) )

		REDEFINE BUTTON ;
			ID 		524 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			ACTION 	( DbSwapUp( dbfTmp, oBrw2 ) )

		REDEFINE BUTTON ;
			ID 		525 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			ACTION 	( DbSwapDown( dbfTmp, oBrw2 ) )

		REDEFINE BUTTON ;
			ID 		511 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			ACTION 	( EndTrans( aTmp, oBrw2, nMode ),;
                  WinGather( aTmp, , dbfExtAgeT, oBrw, @nMode ),;
                  oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
			ID 		510 ;
         CANCEL ;
			OF 		oDlg ;
         ACTION   ( If  ( ExitNoSave( nMode, dbfTmp ),;
								( KillTrans(), oDlg:end() ), ) )

	ACTIVATE DIALOG oDlg	;
		ON PAINT 	( EvalGet( aGet, nMode ) );
		ON INIT		( nRecTotal( dbfTmp, aTmp ) );
		VALID 		( oFont:end(), .T. );
		CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

/*
Edita las lineas de Detalle
*/

STATIC FUNCTION EdtDet( aTmp, aGet, dbfExtAgeL, oBrw, bWhen, bValid, nMode, aTmpExT )

   local oBtn
	local oDlg2
	local oTotal
	local nTotal 			:= 0

	IF nMode	== APPD_MODE
      aTmp[_CSEREXT ]  := aTmpExt[_CSEREXT]
      aTmp[_NNUMEXT ]  := aTmpExt[_NNUMEXT]
      aTmp[_CSUFEXT ]  := aTmpExt[_CSUFEXT]
      aTmp[_NCANENT ]  := 1
		aTmp[_NUNICAJA]  := 1
      aTmp[_DFECHA  ]  := Date()
	END CASE

   DEFINE DIALOG oDlg2 RESOURCE "LDEPAGE" TITLE lblTitle( nMode ) + "lineas de introducción depósitos de almacén"

		REDEFINE GET aGet[_CREF] VAR aTmp[_CREF];
			ID 		100 ;
			WHEN 		( nMode == APPD_MODE ) ;
         VALID    ( LoadArt( aGet, aTmpExt ) ) ;
			ON HELP 	( BrwArticulo( aGet[_CREF], aGet[_CDETALLE] ) );
         BITMAP   "LUPA" ;
         COLOR    CLR_GET ;
			OF 		oDlg2

		REDEFINE GET aGet[_CDETALLE] VAR aTmp[_CDETALLE] ;
			ID 		110 ;
         WHEN     ( lModDes() .AND. nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			OF 		oDlg2

		REDEFINE GET aGet[_NIVA] VAR aTmp[_NIVA] ;
			ID 		120 ;
			COLOR 	CLR_GET ;
			PICTURE 	"@E 99.9" ;
         WHEN     ( lModIva() .AND. nMode != ZOOM_MODE ) ;
         VALID    ( lTiva( dbfIva, aTmp[ _NIVA ] ) );
         ON HELP  ( BrwIva( aGet[ _NIVA ], dbfIva, , .t. ) ) ;
         BITMAP   "LUPA" ;
			OF 		oDlg2

		REDEFINE GET aGet[_NCANENT] VAR aTmp[_NCANENT];
			ID 		130;
			SPINNER ;
         WHEN     ( lUseCaj() .AND. nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
         PICTURE  cPicUnd ;
			ON CHANGE( lCalcDeta( aTmp, oTotal ) );
			OF 		oDlg2

		REDEFINE GET aGet[_NUNICAJA] VAR aTmp[_NUNICAJA] ;
			ID 		140;
			SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			ON CHANGE( lCalcDeta( aTmp, oTotal ) );
         PICTURE  cPicUnd ;
			OF 		oDlg2

      REDEFINE GET aGet[ _NPESOKG ] VAR aTmp[ _NPESOKG ] ;
			ID 		145 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999,999.999999";
         OF       oDlg2

		REDEFINE GET aGet[_CUNIDAD] VAR aTmp[_CUNIDAD] ;
			ID 		150;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			OF 		oDlg2

		REDEFINE GET aGet[_NPREUNIT] VAR aTmp[_NPREUNIT];
			ID 		160 ;
			SPINNER ;
			COLOR 	CLR_GET ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			ON CHANGE( lCalcDeta( aTmp, oTotal ) );
         PICTURE  cPinDiv ;
			OF 		oDlg2

		REDEFINE GET aGet[_NDTO] VAR aTmp[_NDTO] ;
			ID 		170 ;
			SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			PICTURE 	"@E 999.9";
			ON CHANGE( lCalcDeta( aTmp, oTotal ) );
			OF 		oDlg2

		REDEFINE GET aGet[_NDTOPRM] VAR aTmp[_NDTOPRM] ;
			ID 		175 ;
			SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			PICTURE 	"@E 999.9";
			ON CHANGE( lCalcDeta( aTmp, oTotal ) );
			OF 		oDlg2

		REDEFINE GET aGet[_DFECHA] VAR aTmp[_DFECHA] ;
			ID 		180 ;
			SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			OF 		oDlg2

		REDEFINE GET oTotal VAR nTotal ;
			ID 		190 ;
			COLOR 	CLR_SHOW ;
         PICTURE  cPinDiv ;
			WHEN 		.F. ;
			OF 		oDlg2

      REDEFINE BUTTON oBtn;
         ID       IDOK ;
			OF 		oDlg2 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   SaveDeta( aTmp, aGet, oBrw, oDlg2, nMode, oTotal, oBtn )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg2 ;
			ACTION 	( oDlg2:end() )

   oDlg2:bStart := {|| if( !lUseCaj(), aGet[_NCANENT]:hide(), ) }

   ACTIVATE DIALOG oDlg2 CENTER ON PAINT ( lCalcDeta( aTmp, oTotal ) )

RETURN ( oDlg2:nResult == IDOK )

//--------------------------------------------------------------------------//

/*
Funcion Auxiliar para A¤adir lineas de detalle a un albaran
*/

STATIC FUNCTION AppDeta(oBrw2, bEdit2, aTmp)

	WinAppRec( oBrw2, bEdit2, dbfTmp, , , aTmp )

RETURN ( nTotal( nil, nil, dbfTmp, dbfIva, dbfDivisa, aTmp ) )

//--------------------------------------------------------------------------//
/*
Funcion Auxiliar para la Edici¢n de Lineas de Detalle en un albaran
*/

STATIC FUNCTION EdtDeta(oBrw2, bEdit2, aTmp )

	WinEdtRec( oBrw2, bEdit2, dbfTmp, , , aTmp )

RETURN ( nTotal( nil, nil, dbfTmp, dbfIva, dbfDivisa, aTmp ) )

//--------------------------------------------------------------------------//

/*
Funcion Auxiliar para borrar las Lineas de Detalle en un albaran
*/

STATIC FUNCTION DelDeta( oBrw2, aTmp )

	dbDelRec( oBrw2, dbfTmp )

RETURN ( nTotal( nil, nil, dbfTmp, dbfIva, dbfDivisa, aTmp ) )

//--------------------------------------------------------------------------//

/*
Funcion Auxiliar para la Visualizaci¢n de Lineas de Detalle en una Abono
*/

STATIC FUNCTION EdtZoom( oBrw2, bEdit2, aTmp )

	WinZooRec( oBrw2, bEdit2, dbfTmp )

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION SaveDeta( aTmp, aGet, oBrw, oDlg2, nMode, oTotal, oBtn )

   oBtn:SetFocus()

	WinGather( aTmp, aGet, dbfTmp, oBrw, nMode )

   IF nMode == APPD_MODE .AND. lEntCon()
		aGet[_NCANENT]:cText( 1 )
      aGet[_CREF   ]:setFocus()
		oTotal:cText( 0 )
	ELSE
      oDlg2:end( IDOK )
	END IF

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION PrnSerie()

	local oDlg
	local oDocIni
	local oDocFin
	local oBtnOk
	local oBtnCancel
   local nRecno   := (dbfExtAgeT)->(RecNo())
   local nOrdAnt  := (dbfExtAgeT)->(OrdSetFocus(1))
   local nDocIni  := (dbfExtAgeT)->NNUMEXT
   local nDocFin  := (dbfExtAgeT)->NNUMEXT

   DEFINE DIALOG oDlg RESOURCE "PRNSERIES" TITLE "Imprimir series de existencias"

	REDEFINE GET oDocIni VAR nDocIni;
		ID 		110 ;
		PICTURE 	"999999999" ;
		OF 		oDlg

	REDEFINE GET oDocFin VAR nDocFin;
		ID 		120 ;
		PICTURE 	"999999999" ;
		OF 		oDlg

	REDEFINE BUTTON oBtnOk ;
		ID 		505 ;
		OF 		oDlg ;
      ACTION   ( StartPrint( nDocIni, nDocFin, oBtnOk, oBtnCancel ), oDlg:end( IDOK ) )

	REDEFINE BUTTON oBtnCancel ;
      ID       IDCANCEL ;
		OF 		oDlg ;
		ACTION 	( oDlg:end() )

	ACTIVATE DIALOG oDlg CENTER

   ( dbfExtAgeT )->( dbGoTo( nRecNo ) )
   ( dbfExtAgeT )->( ordSetFocus( nOrdAnt ) )

	oWndBrw:refresh()

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION StartPrint( nDocIni, nDocFin, oBtnOk, oBtnCancel )

	oBtnOk:disable()
	oBtnCancel:disable()

   ( dbfExtAgeT )->( dbSeek( nDocIni, .t. ) )

   WHILE (dbfExtAgeT)->CSERDEP + Str( (dbfExtAgeT)->NNUMDEP ) + (dbfExtAgeT)->CSUFDEP >= nDocIni .AND.;
         (dbfExtAgeT)->CSERDEP + Str( (dbfExtAgeT)->NNUMDEP ) + (dbfExtAgeT)->CSUFDEP <= nDocFin

      GenExtAge( .T., "Imprimiendo documento : " +  (dbfExtAgeT)->CSERDEP + Str( (dbfExtAgeT)->NNUMDEP ) + (dbfExtAgeT)->CSUFDEP )
      ( dbfExtAgeT )->( dbSkip() )

	END WHILE

	oBtnOk:enable()
	oBtnCancel:enable()

RETURN NIL

//--------------------------------------------------------------------------//
/*
Calcula el Total del albaran
*/

STATIC FUNCTION nTotal( nNumExt, dbfMaster, dbfLine, dbfIva, dbfDivisa, aTmp, lEuro )

	local nRecno
	local bCondition
	local cCodDiv
	local nNumArt		:= 0
	local aTotalDto	:= { 0, 0, 0 }
	local aTotalDPP	:= { 0, 0, 0 }
	local aTotalCnt	:= { 0, 0, 0 }
	local aTotalRap   := { 0, 0, 0 }
	local aTotalPub   := { 0, 0, 0 }
	local aTotalPgo   := { 0, 0, 0 }

	DEFAULT lEuro		:= .f.
   DEFAULT dbfMaster := dbfExtAgeT
   DEFAULT dbfLine   := dbfExtAgeL

   nTotalExt         := 0
	nTotalDPP 			:= 0
	nTotalNet 			:= 0
	nTotalIva 			:= 0
	nTotalAge			:= 0
	nTotalReq			:= 0
	nRecno 				:= (dbfLine)->(RecNo())
	aIva      			:= { { 0,0,0,0 }, { 0,0,0,0 }, { 0,0,0,0 } }

	IF aTmp != NIL
		lRecargo			:= aTmp[ _LRECARGO]
		nDtoEsp			:= aTmp[ _NDTOESP ]
		nDtoPP			:= aTmp[ _NDPP    ]
		nDtoCnt			:= aTmp[ _NDTOCNT ]
		nDtoRap     	:= aTmp[ _NDTORAP ]
		nDtoPub     	:= aTmp[ _NDTOPUB ]
		nDtoPgo     	:= aTmp[ _NDTOPGO ]
		nDtoPtf			:= aTmp[ _NDTOPTF ]
      cCodDiv        := aTmp[ _CDIVEXT ]
		bCondition		:= {|| (dbfLine)->(!eof() ) }
		(dbfLine)->( DbGoTop() )
	ELSE
		lRecargo			:= (dbfMaster)->LRECARGO
		nDtoEsp			:= (dbfMaster)->NDTOESP
		nDtoPP			:= (dbfMaster)->NDPP
		nDtoCnt			:= (dbfMaster)->NDTOCNT
		nDtoRap     	:= (dbfMaster)->NDTORAP
		nDtoPub     	:= (dbfMaster)->NDTOPUB
		nDtoPgo     	:= (dbfMaster)->NDTOPGO
		nDtoPtf			:= (dbfMaster)->NDTOPTF
      cCodDiv        := (dbfMaster)->CDIVEXT
      bCondition     := {|| (dbfMaster)->CSERExt + Str( (dbfMaster)->NNUMExt ) + (dbfMaster)->CSUFExt = nNumExt .AND. (dbfLine)->( !eof() ) }
      (dbfLine)->( DbSeek( NNUMEXT ) )
	END IF

	IF lEuro
		cPinDiv			:= cPinDiv( "EUR", dbfDivisa )
		nDinDiv			:= nDinDiv( "EUR", dbfDivisa )
	ELSE
		cPinDiv			:= cPinDiv( cCodDiv, dbfDivisa )
		nDinDiv			:= nDinDiv( cCodDiv, dbfDivisa )
	END IF

	WHILE Eval( bCondition )

      nTotalArt      := nTotLExtAge( dbfLine )
		nNumArt			+= nTotLNumArt( dbfLine )

		/*
      Estudio de impuestos
		*/

		DO CASE
		CASE _NPCTIVA1 == 0 .OR. _NPCTIVA1 == (dbfLine)->NIVA
			_NPCTIVA1 	:= (dbfLine)->NIVA
			_NPCTREQ1 	:= If ( lRecargo, nPReq( dbfIva, _NPCTIVA1 ), 0 )
			_NBRTIVA1 	+= nTotalArt

		CASE _NPCTIVA2 == 0 .OR. _NPCTIVA2 == (dbfLine)->NIVA
			_NPCTIVA2 	:= (dbfLine)->NIVA
			_NPCTREQ2 	:= If ( lRecargo, nPReq( dbfIva, _NPCTIVA2 ), 0 )
			_NBRTIVA2 	+= nTotalArt

		CASE _NPCTIVA3 == 0 .OR. _NPCTIVA3 == (dbfLine)->NIVA
			_NPCTIVA3 	:= (dbfLine)->NIVA
			_NPCTREQ3 	:= If ( lRecargo, nPReq( dbfIva, _NPCTIVA3 ), 0 )
			_NBRTIVA3 	+= nTotalArt

		END CASE

		(dbfLine)->(DbSkip())

	END WHILE

	( dbfLine )->( DbGoto( nRecno ) )

	/*
   Ordenamos los impuestosS de menor a mayor
	*/

   aIva        := aSort( aIva,,, {|x,y| abs( x[1] ) > abs( y[1] ) } )
	nTotalBrt	:= _NBRTIVA1 + _NBRTIVA2 + _NBRTIVA3

	_NBASIVA1	:= _NBRTIVA1
	_NBASIVA2	:= _NBRTIVA2
	_NBASIVA3	:= _NBRTIVA3

	/*
	Descuentos Especiales
	*/

	IF nDtoEsp 	!= 0
		aTotalDto[1]	:= Round( _NBASIVA1 * nDtoEsp / 100, nDinDiv )
		aTotalDto[2]	:= Round( _NBASIVA2 * nDtoEsp / 100, nDinDiv )
		aTotalDto[3]	:= Round( _NBASIVA3 * nDtoEsp / 100, nDinDiv )

		nTotalDto		:= aTotalDto[1] + aTotalDto[2] + aTotalDto[3]

		_NBASIVA1		-= aTotalDto[1]
		_NBASIVA2		-= aTotalDto[2]
		_NBASIVA3		-= aTotalDto[3]
	END IF

	/*
	Descuentos por Pronto Pago estos son los buenos
	*/

	IF nDtoPP	!= 0
		aTotalDPP[1]	:= Round( _NBASIVA1 * nDtoPP / 100, nDinDiv )
		aTotalDPP[2]	:= Round( _NBASIVA2 * nDtoPP / 100, nDinDiv )
		aTotalDPP[3]	:= Round( _NBASIVA3 * nDtoPP / 100, nDinDiv )

		nTotalDPP		:= aTotalDPP[1] + aTotalDPP[2] + aTotalDPP[3]

		_NBASIVA1		-= aTotalDPP[1]
		_NBASIVA2		-= aTotalDPP[2]
		_NBASIVA3		-= aTotalDPP[3]
	END IF

   /*
	Contado
	*/

	IF nDtoCnt != 0
		aTotalCnt[1]	:= Round( _NBASIVA1 * nDtoCnt / 100, nDinDiv )
		aTotalCnt[2]	:= Round( _NBASIVA2 * nDtoCnt / 100, nDinDiv )
		aTotalCnt[3]	:= Round( _NBASIVA3 * nDtoCnt / 100, nDinDiv )

		nTotalCnt		:= aTotalCnt[1] + aTotalCnt[2] + aTotalCnt[3]

		_NBASIVA1		-= aTotalCnt[1]
		_NBASIVA2		-= aTotalCnt[2]
		_NBASIVA3		-= aTotalCnt[3]
	END IF

	/*
	Rappels
	*/

	IF nDtoRap != 0
		aTotalRap[1]	:= Round( _NBASIVA1 * nDtoRap / 100, nDinDiv )
		aTotalRap[2]	:= Round( _NBASIVA2 * nDtoRap / 100, nDinDiv )
		aTotalRap[3]	:= Round( _NBASIVA3 * nDtoRap / 100, nDinDiv )

		nTotalRap		:= aTotalRap[1] + aTotalRap[2] + aTotalRap[3]

		_NBASIVA1		-= aTotalRap[1]
		_NBASIVA2		-= aTotalRap[2]
		_NBASIVA3		-= aTotalRap[3]
	END IF

	/*
	Publicidad
	*/

	IF nDtoPub != 0
		aTotalPub[1]	:= Round( _NBASIVA1 * nDtoPub / 100, nDinDiv )
		aTotalPub[2]	:= Round( _NBASIVA2 * nDtoPub / 100, nDinDiv )
		aTotalPub[3]	:= Round( _NBASIVA3 * nDtoPub / 100, nDinDiv )

		nTotalPub		:= aTotalPub[1] + aTotalPub[2] + aTotalPub[3]

		_NBASIVA1		-= aTotalPub[1]
		_NBASIVA2		-= aTotalPub[2]
		_NBASIVA3		-= aTotalPub[3]
	END IF

	/*
	Pago Centralizado
	*/

	IF nDtoPgo != 0
		aTotalPgo[1]	:= Round( _NBASIVA1 * nDtoPgo / 100, nDinDiv )
		aTotalPgo[2]	:= Round( _NBASIVA2 * nDtoPgo / 100, nDinDiv )
		aTotalPgo[3]	:= Round( _NBASIVA3 * nDtoPgo / 100, nDinDiv )

		nTotalPgo		:= aTotalPgo[1] + aTotalPgo[2] + aTotalPgo[3]

		_NBASIVA1		-= aTotalPgo[1]
		_NBASIVA2		-= aTotalPgo[2]
		_NBASIVA3		-= aTotalPgo[3]
	END IF

	nTotalNet			:= _NBASIVA1 + _NBASIVA2 + _NBASIVA3

	/*
	Descuento por plataforma
	*/

	IF nDtoPtf != 0
		nTotalPtf		:= nDtoPtf * nNumArt
		nTotalNet		-= nTotalPtf
	END IF

	/*
   Calculos de impuestos
	*/

	nTotalIva := Round( _NBASIVA1 * _NPCTIVA1 / 100, nDinDiv )
	nTotalIva += Round( _NBASIVA2 * _NPCTIVA2 / 100, nDinDiv )
	nTotalIva += Round( _NBASIVA3 * _NPCTIVA3 / 100, nDinDiv )

	/*
	Calculo de recargo
	*/

	nTotalReq := Round( _NBASIVA1 * _NPCTREQ1 / 100, nDinDiv )
	nTotalReq += Round( _NBASIVA2 * _NPCTREQ2 / 100, nDinDiv )
	nTotalReq += Round( _NBASIVA3 * _NPCTREQ3 / 100, nDinDiv )

	/*
	Total de impuestos
	*/

	nTotalImp := nTotalIva + nTotalReq

	/*
	Total facturas
	*/

	nTotalFac := nTotalNet + nTotalImp

	/*
	Guardamos el valor en euros________________________________________________
	*/

   nTotalEur      := nTotalFac / nChgDiv( cCodDiv, dbfDivisa )

	/*
	Si nos solicitan en euros hacemos la factura igual al Euro_________________
	*/

	IF lEuro
		nTotalFac	:= nTotalEur
	END IF

	/*
	Refrescos en Pantalla____________________________________________________
	*/

   IF nNumExt != nil

		IF _OIMPIVA1 != NIL
			_OIMPIVA1:SetText( Round( _NBASIVA1 * _NPCTIVA1 / 100, nDinDiv ) )
		END IF

		IF _OIMPIVA2 != NIL
			_OIMPIVA2:SetText( Round( _NBASIVA2 * _NPCTIVA2 / 100, nDinDiv ) )
		END IF

		IF _OIMPIVA3 != NIL
			_OIMPIVA3:SetText( Round( _NBASIVA3 * _NPCTIVA3 / 100, nDinDiv ) )
		END IF

		/*
      Refrescamos los impuestosS
		*/

		IF _OBASIVA1 != NIL
			_OBASIVA1:SetText( _NBASIVA1 )
		END IF

		IF _OBASIVA2 != NIL
			_OBASIVA2:SetText( _NBASIVA2)
		END IF

		IF _OBASIVA3 != NIL
			_OBASIVA3:SetText( _NBASIVA3 )
		END IF

		/*
		Refresco de Porcentajes
		*/

		IF _OPCTIVA1 != NIL
			_OPCTIVA1:refresh()
		END IF

		IF _OPCTIVA2 != NIL
			_OPCTIVA2:refresh()
		END IF

		IF _OPCTIVA3 != NIL
			_OPCTIVA3:refresh()
		END IF

		/*
		Estudio de Recargos de Equivalencia
		*/

		IF _OIMPREQ1 != NIL
			_OIMPREQ1:SetText( If( lRecargo, Round( _NBASIVA1 * _NPCTREQ1 / 100, nDinDiv ), 0 ) )
		END IF

		IF _OIMPREQ2 != NIL
			_OIMPREQ2:SetText( If( lRecargo, Round( _NBASIVA2 * _NPCTREQ2 / 100, nDinDiv ), 0 ) )
		END IF

		IF _OIMPREQ3 != NIL
			_OIMPREQ3:SetText( If( lRecargo, Round( _NBASIVA3 * _NPCTREQ3 / 100, nDinDiv ), 0 ) )
		END IF

		/*
		Refresco de Porcentajes de los Recargos de Equialencia
		*/

		IF _OPCTREQ1 != NIL
			_OPCTREQ1:refresh()
		END IF

		IF _OPCTREQ2 != NIL
			_OPCTREQ2:refresh()
		END IF

		IF _OPCTREQ3 != NIL
			_OPCTREQ3:refresh()
		END IF

		/*
		Base de la Factura
		*/

		IF oGetNet != NIL
			oGetNet:SetText( nTotalNet )
		END IF

		IF oGetIva != NIL
			oGetIva:SetText( nTotalIva )
		END IF

		IF oGetReq != NIL
			oGetReq:SetText( nTotalReq )
		END IF

		IF oGetTotal != NIL
			oGetTotal:SetText( nTotalFac )
		END IF

		IF oGetTotEur != NIL
			oGetTotEur:SetText( nTotalEur )
		END IF

		IF oGetTotal != NIL
			oGetTotal:SetText( nTotalFac )
		END IF

	END IF

RETURN ( Trans( nTotalFac, cPinDiv ) )

//--------------------------------------------------------------------------//

STATIC FUNCTION nRecTotal( dbfLine, aTmp )

RETURN ( nTotal( nil, nil, dbfLine, dbfIva, dbfDivisa, aTmp ), .T. )

//--------------------------------------------------------------------------//

FUNCTION nTotExtAge( nExtAge, dbfMaster, dbfLine, dbfIva )

RETURN nTotal( nExtAge, dbfMaster, dbfLine, dbfIva )

//--------------------------------------------------------------------------//

/*
Borra todas las lineas de detalle de un Albaran
*/

STATIC FUNCTION DelDetalle( cNumExt )

   CursorWait()

   oStock:ExtAge( cNumExt, ( dbfExtAgeT )->cCodAlm, .t., .f. )

   CursorWe()

RETURN NIL

//--------------------------------------------------------------------------//
/*
Calcula totales en las lineas de Detalle
*/

STATIC FUNCTION lCalcDeta( aTmp, oTotal )

	local nCalculo := aTmp[_NPREUNIT] * aTmp[_NUNICAJA]

   IF lCalCaj()
		nCalculo *= If( aTmp[_NCANENT] != 0, aTmp[_NCANENT], 1 )
	END IF

	IF aTmp[_NDTO] != 0
		nCalculo -= nCalculo * aTmp[_NDTO] / 100
	END IF

	IF aTmp[_NDTOPRM] != 0
		nCalculo -= nCalculo * aTmp[_NDTOPRM] / 100
	END IF

	IF oTotal != NIL
		oTotal:varPut( nCalculo )
		oTotal:refresh()
	END IF

RETURN .T.

//--------------------------------------------------------------------------//

STATIC FUNCTION LoadAlm( aGet, aTmp, nMode )

	local cAreaAnt := Alias()
	local lValid 	:= .F.
	local xValor 	:= aGet[_CCODALM]:varGet()

	IF Empty( Rtrim( xValor ) )
		RETURN .T.
	END IF

	xValor 			:= Rjust( xValor, "0" )

	IF (dbfAlmT)->( DbSeek( xValor ) )

		/*
		Si estamos a¤adiendo cargamos todos los datos del Agente
		*/

		aGet[_CCODALM]:cText( (dbfAlmT)->CCODALM )
		aGet[_CNOMALM]:cText( (dbfAlmT)->CNOMALM )
		aTmp[_CDIRALM]	:= (dbfAlmT)->CDIRALM
		aTmp[_CPOBALM]	:= (dbfAlmT)->CPOBALM
		aTmp[_CPRVALM]	:= (dbfAlmT)->CPROALM
		aTmp[_CPOSALM]	:= (dbfAlmT)->CPOSALM

		lValid	:= .T.

	ELSE

      msgStop( "Almacén no encontrado." )

	END IF

	IF ( cAreaAnt != "",	SELECT( cAreaAnt ), )

RETURN lValid

//----------------------------------------------------------------------------//

STATIC FUNCTION LoadArt( aGet, aTmpExt )

	local cAreaAnt := Alias()
	local lValid   := .F.
	local xValor   := aGet[_CREF]:varGet()

	IF Empty( xValor )

		aGet[_NIVA]:varPut( 0 )
		aGet[_NIVA]:bWhen		:= {|| .T. }
		aGet[_NIVA]:refresh()

		aGet[_CDETALLE]:varPut( Space( 50 ) )
		aGet[_CDETALLE]:bWhen	:= {|| .T. }
		aGet[_CDETALLE]:refresh()

		RETURN .T.

	END IF

	IF (dbfArticulo)->( DbSeek( xValor ) )

		aGet[_CREF]:cText( (dbfArticulo)->CODIGO )
		aGet[_NUNICAJA]:cText( (dbfArticulo)->NUNICAJA )
		aGet[_CUNIDAD]:cText( (dbfArticulo)->CUNIDAD )

		/*
		Chequeamos situaciones especiales y comprobamos las fechas
		*/

      IF !Empty( aTmpExt[_CCODTAR] ) .and. RetPrcTar( ( dbfArticulo )->Codigo, aTmpExt[_CCODTAR], dbfTarPreL ) != 0
         aGet[_NPREUNIT]:cText( RetPrcTar( ( dbfArticulo )->Codigo, aTmpExt[_CCODTAR], dbfTarPreL ) )
         aGet[_NDTO    ]:cText( RetPctTar( ( dbfArticulo )->Codigo, ( dbfArticulo )->Familia, aTmpExt[_CCODTAR], dbfTarPreL ) )
         aGet[_NDTOPRM ]:cText( RetDtoPrm( xValor, aTmpExt[_CCODTAR], aTmpExt[_DFECEXT], dbfPromoT ) )
		ELSE
			aGet[_NPREUNIT]:cText( (dbfArticulo)->PVENTA1 )
		END IF

		aGet[_CDETALLE]:cText( (dbfArticulo)->NOMBRE )
		aGet[_CDETALLE]:bWhen	:= {|| .F. }

		IF aGet[_NIVA] != NIL
			aGet[_NIVA]:cText( nIva( dbfIva, (dbfArticulo)->TIPOIVA ) )
			aGet[_NIVA]:bWhen	:= {|| .F. }
		END IF

		lValid	:= .T.

	ELSE

		MsgStop( "Articulo no encontrado" )
		lValid := .F.

	END IF

	IF cAreaAnt != ""
		SELECT( cAreaAnt )
	END IF

RETURN lValid

//--------------------------------------------------------------------------//

STATIC FUNCTION EPage( oInf )

   private cDbf         := dbfExtAgeT
   private cDetalle     := dbfExtAgeL
	private cIva			:= dbfIva
	private cFPago			:= dbfFPago
	private aTotIva		:= aIva
	private nTotBrt		:= nTotalBrt
	private nTotDto		:= nTotalDto
	private nTotDpp		:= nTotalDpp
	private nTotCnt		:= nTotalCnt
	private nTotRap		:= nTotalRap
	private nTotPub		:= nTotalPub
	private nTotPgo		:= nTotalPgo
	private nTotPtf		:= nTotalPtf
	private nTotIva		:= nTotalIva
	private nTotReq		:= nTotalReq
   private nTotExt      := nTotal
	private nTotEur		:= nTotalEur
   private cPinDivExt   := cPinDiv
   private cPicEurExt   := cPicEur
   private nDinDivExt   := nDinDiv
	private nPagina		:= oInf:nPage
	private lEnd			:= oInf:lFinish

	/*
	Ahora montamos los Items
	*/

   PrintItems( "EA1", oInf )

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION nTotLExtAge( dbfLine )

	local nCalculo := (dbfLine)->NUNICAJA * (dbfLine)->NPREUNIT

   IF lCalCaj()
		nCalculo *= If( (dbfLine)->NCANENT != 0, (dbfLine)->NCANENT, 1 )
	END IF

	IF (dbfLine)->NDTO != 0
		nCalculo -= nCalculo * (dbfLine)->NDTO / 100
	END IF

	IF (dbfLine)->NDTOPRM != 0
		nCalculo -= nCalculo * (dbfLine)->NDTOPRM / 100
	END IF

RETURN ( nCalculo )

//---------------------------------------------------------------------------//

FUNCTION mkExtAge( cPath, lAppend, cPathOld, oMeter )

   local dbfExtAgeT

	IF oMeter != NIL
		oMeter:cText	:= "Generando Bases"
		sysrefresh()
	END IF

	CreateFiles( cPath )

	IF lAppend .and. lIsDir( cPathOld )

      dbUseArea( .t., cDriver(), cPath + "ExtAgeT.DBF", cCheckArea( "ExtAgeT", @dbfExtAgeT ), .f. )
      if !( dbfExtAgeT )->( neterr() )
         ( dbfExtAgeT )->( __dbApp( cPathOld + "ExtAgeT.DBF" ) )
         (   dbfExtAgeT )->( dbCloseArea() )
      end if

      dbUseArea( .t., cDriver(), cPath + "ExtAgeL.DBF", cCheckArea( "ExtAgeL", @dbfExtAgeT ), .f. )
      if !( dbfExtAgeT )->( neterr() )
         ( dbfExtAgeT )->( __dbApp( cPathOld + "ExtAgeL.DBF" ) )
         ( dbfExtAgeT )->( dbCloseArea() )
      end if
	END IF

   rxExtAge( cPath, oMeter )

RETURN NIL

//---------------------------------------------------------------------------//

FUNCTION rxExtAge( cPath, oMeter )

   local dbfExtAgeT
	local nEvery

   DEFAULT cPath  := cPatEmp()

   IF !File( cPath + "EXTAGET.DBF" ) .OR. !File( cPath + "EXTAGEL.DBF" )
		CreateFiles( cPath )
	END IF

   fErase( cPath + "ExtAgeT.CDX" )
   fErase( cPath + "ExtAgeL.CDX" )

   dbUseArea( .t., cDriver(), cPath + "EXTAGET.DBF", cCheckArea( "EXTAGET", @dbfExtAgeT ), .f. )
   if !( dbfExtAgeT )->( neterr() )
      ( dbfExtAgeT)->( __dbPack() )

      ( dbfExtAgeT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfExtAgeT)->( ordCreate( cPath + "EXTAGET.CDX", "NNUMEXT", "CSEREXT + Str( NNUMEXT ) + CSUFEXT", {|| CSEREXT + Str( NNUMEXT ) + CSUFEXT } ) )

      ( dbfExtAgeT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfExtAgeT)->( ordCreate( cPath + "EXTAGET.CDX", "DFECEXT", "DFECEXT", {|| DFECEXT } ) )

      ( dbfExtAgeT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfExtAgeT)->( ordCreate( cPath + "EXTAGET.CDX", "CCODALM", "CCODALM", {|| CCODALM } ) )

      ( dbfExtAgeT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de existencias de agantes" )
   end if

   dbUseArea( .t., cDriver(), cPath + "EXTAGEL.DBF", cCheckArea( "EXTAGEL", @dbfExtAgeL ), .f. )
   if !( dbfExtAgeL )->( neterr() )
      ( dbfExtAgeL)->( __dbPack() )

      ( dbfExtAgeL)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfExtAgeL)->( ordCreate( cPath + "EXTAGEL.CDX", "NNUMEXT", "CSEREXT + Str( NNUMEXT ) + CSUFEXT", {|| CSEREXT + Str( NNUMEXT ) + CSUFEXT } ) )

      ( dbfExtAgeL)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfExtAgeL)->( ordCreate( cPath + "EXTAGEL.CDX", "CREF", "CREF", {|| CREF } ) )

      ( dbfExtAgeL )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de existencias de agentes" )
   end if

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION BeginTrans( aTmp )

	local aField
   local cDbf     := "EAgeL"
   local cExt     := aTmp[_CSEREXT] + Str( aTmp[_NNUMEXT] ) + aTmp[_CSUFEXT]

   cNewFile       := cGetNewFileName( cPatTmp() + cDbf )

	/*
	Primero Crear la base de datos local
	*/

   dbCreate( cNewFile, aBase2, cDriver() )
   dbUseArea( .t., cDriver(), cNewFile, cCheckArea( cDbf, @dbfTmp ), .f. )
    if !( dbfTmp )->( neterr() )
      ( dbfTmp )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmp )->( OrdCreate( cNewFile, "Recno", "Str( Recno() )", {|| Str( Recno() ) } ) )
    end if

	/*
	A¤adimos desde el fichero de lineas
	*/

   IF ( dbfExtAgeL )->( DbSeek( cExt ) )

      DO WHILE ( (dbfExtAgeL)->CSEREXT + Str( (dbfExtAgeL)->NNUMEXT ) + (dbfExtAgeL)->CSUFEXT == cExt .AND. !( dbfExtAgeL )->( Eof() ) )

			( dbfTmp )->( dbAppend() )
         dbPass( dbfExtAgeL, dbfTmp )
         ( dbfExtAgeL )->( DbSkip() )

		END WHILE

	END IF

	( dbfTmp )->( dbGoTop() )

RETURN NIL

//-----------------------------------------------------------------------//

STATIC FUNCTION EndTrans( aTmp, oBrw, nMode )

	local oDlg
	local nWidth
	local oMeter
	local nMeter
	local aTabla
   local cExt     := aTmp[_CSEREXT] + Str( aTmp[_NNUMEXT] ) + aTmp[_CSUFEXT]

	/*
	Primero hacer el RollBack
	*/
   CursorWait( "Actualizando fichero de trabajo", "Espere por favor...", dbfExtAgeL )

	DO CASE
   CASE nMode == EDIT_MODE .AND. (dbfExtAgeL)->( DbSeek( cExt ) )

      /*
      Rollback de stocks y pedidos
      */

      oStock:DelResExtAge( cExt, ( dbfExtAgeT )->cCodAlm )

	CASE nMode == APPD_MODE

      aTmp[_CSEREXT] := "A"
      aTmp[_NNUMEXT] := nNewDoc( "A", dbfExtAgeT, "NEXTAGE" )
      aTmp[_CSUFEXT] := RetSufEmp()

	END CASE

	( dbfTmp )->( DbGoTop() )

   DO WHILE !( dbfTmp )->( eof() )

		aTabla 				:= DBScatter( dbfTmp )
      aTabla[_CSEREXT]  := aTmp[_CSEREXT]
      aTabla[_NNUMEXT]  := aTmp[_NNUMEXT]
      aTabla[_CSUFEXT]  := aTmp[_CSUFEXT]
      DbGather( aTabla, dbfExtAgeL, .t. )
		( dbfTmp )->( dbSkip() )

	END WHILE

	/*
	Actualizamos los Stocks
	*/

   oStock:ExtAge( cExt, ( dbfExtAgeT )->cCodAlm, .f., .t. )

	/*
	Borramos los ficheros
	*/

	oBrw:lCloseArea()
   dbfErase( cNewFile )

   /*
   Escribe los datos pendientes------------------------------------------------
   */

   dbCommitAll()

   CursorWe()

RETURN .T.

//------------------------------------------------------------------------//

STATIC FUNCTION KillTrans()

	/*
	Borramos los ficheros
	*/

	( dbfTmp )->( dbCloseArea() )
   dbfErase( cNewFile )

RETURN NIL

//------------------------------------------------------------------------//

STATIC FUNCTION CreateFiles( cPath )

   dbCreate( cPath + "EXTAGET.DBF", aBase, cDriver() )
   dbCreate( cPath + "EXTAGEL.DBF", aBase2,cDriver())

RETURN NIL

//--------------------------------------------------------------------//

/*
Devuelve en numero de articulos en una linea de detalle
*/

STATIC FUNCTION nTotLNumArt( dbfDetalle )

	local nCalculo := 0

   IF lCalCaj() .AND. (dbfDetalle)->NCANENT != 0 .AND. (dbfDetalle)->NPREUNIT != 0
		nCalculo := (dbfDetalle)->NCANENT
	END IF

RETURN ( nCalculo )

//---------------------------------------------------------------------------//

STATIC FUNCTION GenExtAge( lPrinter, cCaption, cDiv, nVdv )

   local nNumExt     := ( dbfExtAgeT )->CSEREXT + Str( ( dbfExtAgeT )->NNUMEXT ) + ( dbfExtAgeT )->CSUFEXT
   local nCodAlm     := ( dbfExtAgeT )->CCODALM
   local nOldRecno   := ( dbfExtAgeL )->( recno() )

	DEFAULT lPrinter 	:= .F.
   DEFAULT cCaption  := "Imprimiendo Existencias."

   private cDbfCol   := dbfExtAgeL

   ( dbfAlmT    )->( dbSeek( nCodAlm ) )
   ( dbfExtAgeL )->( dbSeek( nNumExt ) )

	IF lPrinter

		REPORT oInf ;
			CAPTION cCaption ;
         TO PRINTER

	ELSE

		REPORT oInf ;
			CAPTION cCaption ;
			PREVIEW

	END IF

   if !Empty( oInf ) .and. oInf:lCreated

      oInf:lFinish      := .t.
      oInf:lNoCancel    := .t.
      oInf:bSkip        := {|| ( dbfExtAgeL )->( dbSkip() ) }

      SetMargin( "EA1", oInf )
      PrintColum( "EA1", oInf )

   end if

	END REPORT

   if !Empty( oInf )
      ACTIVATE REPORT oInf ;
         WHILE          ( ( dbfExtAgeL )->NNUMEXT == nNumExt );
         ON ENDPAGE     ( EPage( oInf ) )
   end if

   ( dbfExtAgeL )->( dbGoto( nOldRecno ) )

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION ChgState( oBrw )

   dbDialogLock( dbfExtAgeT )
   ( dbfExtAgeT )->lLiqExt := ! (dbfExtAgeT)->lLiqExt
   ( dbfExtAgeT )->( dbUnlock() )

   oBrw:DrawSelect()

RETURN NIL

//--------------------------------------------------------------------------//