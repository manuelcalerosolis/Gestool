#include "FiveWin.Ch"
#include "Font.ch"
#include "Folder.ch"
#include "Print.ch"
#include "Report.ch"
#include "Factu.ch"  

#define _NNUMFAC                   1      //   N      9     0
#define _CSUFFAC                   2      //   C      2     0
#define _DFECFAC                   3      //   D      8     0
#define _CCODPRV                   4      //   C     10     0
#define _CCODALM                   5      //   C      7     0
#define _CNOMPRV                   6      //   C     35     0
#define _CDIRPRV                   7      //   C     35     0
#define _CPOBPRV                   8      //   C     25     0
#define _CPRVPRV                   9      //   C     20     0
#define _NCODPRV                  10      //   N      2     0
#define _CPOSPRV                  11      //   C      5     0
#define _CDNIPRV                  12      //   C     15     0
#define _LLIQUIDADA               13      //   L      1     0
#define _LCONTAB                  14      //   L      1     0
#define _DFECENT                  15      //   D      8     0
#define _CSUPED                   16      //   C     10     0
#define _CCONDENT                 17      //   C     20     0
#define _CEXPED                   18      //   C     20     0
#define _COBSERV                  19      //   C     20     0
#define _CCODPAGO                 20      //   C      2     0
#define _NBULTOS                  21      //   N      3     0
#define _NPORTES                  22      //   N      6     0
#define _NTIPOFAC                 23      //   N      1     0
#define _NDTOESP                  24      //   N      4     1
#define _NDPP                     25      //   N      4     1
#define _NTIPOIVA                 26      //   N      1     0
#define _NPORCIVA                 27      //   N      4     1
#define _LRECARGO                 28      //   L      1     0
#define _NIRPF                    29      //   N      4     1
#define _CCODAGE                  30      //   C      3     0
#define _CCODRUT                  31      //   C      3     0
#define _CDIVFAC                  32      //   C      3     0
#define _NVDVFAC                  33      //   N     10     4
#define _LSNDDOC						 34      //   L      1     0

/*
Definici¢n de la base de datos de lineas de detalle
*/

#define _dNNUMFAC                  1      //   N      9     0
#define _dCSUFFAC                  2      //   C      2     0
#define _CREF                      3      //   C     10     0
#define _CDETALLE                  4      //   C     50     0
#define _MLNGDES                   5      //   M     10     0
#define _NPREUNIT                  6      //   N     13     3
#define _NDTO                      7      //   N      5     1
#define _NIVA                      8      //   N      6     2
#define _NCANENT                   9      //   N     13     3
#define _LCONTROL                 10      //   L      1     0
#define _CUNIDAD                  11      //   C      2     0
#define _NUNICAJA                 12      //   N      6     2
#define _DFECHA                   13      //   D      8     0

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

#define _OBASIVA1						aoIva[ 1, 1 ]
#define _OPCTIVA1						aoIva[ 1, 2 ]
#define _OIMPIVA1						aoIva[ 1, 3 ]
#define _OPCTREQ1						aoIva[ 1, 4 ]
#define _OIMPREQ1						aoIva[ 1, 5 ]
#define _OBASIVA2						aoIva[ 2, 1 ]
#define _OPCTIVA2						aoIva[ 2, 2 ]
#define _OIMPIVA2						aoIva[ 2, 3 ]
#define _OPCTREQ2						aoIva[ 2, 4 ]
#define _OIMPREQ2						aoIva[ 2, 5 ]
#define _OBASIVA3						aoIva[ 3, 1 ]
#define _OPCTIVA3						aoIva[ 3, 2 ]
#define _OIMPIVA3						aoIva[ 3, 3 ]
#define _OPCTREQ3						aoIva[ 3, 4 ]
#define _OIMPREQ3						aoIva[ 3, 5 ]

/*
Variables Staticas para todo el .prg logico no!
*/

static oWndBrw
static oInf
static dbfAbnPrvT
static dbfAbnPrvL
static dbfIva
static dbfPrv
static dbfFPago
static dbfTmp
static dbfDiv
static dbfMov
static dbfDivisa
static dbfBander
static dbfArticulo
static dbfArtPre
static cNewFile
static cPicEur
static cPicUnd
static cPinDiv
static nDinDiv
static oGetTotal
static oGetNeto
static oGetIva
static oGetReq
static oMetMsg
static nMetMsg
static nTotal   	:= 0
static nTotalNet	:= 0
static nTotalDto	:= 0
static nTotalBrt	:= 0
static nTotalFac	:= 0
static nTotalEur	:= 0
static nTotalIva	:= 0
static nTotalDPP	:= 0
static nTotalReq	:= 0
static nTotalImp	:= 0
static nBasIva 	:= 0
static nGetNeto 	:= 0
static nGetIva  	:= 0
static nGetPagado	:= 0
static nGetReq  	:= 0
static aImpVto	 	:= { 0,0,0,0,0 }
static aIva     	:= { { 0,0,NIL,0 }, { 0,0,NIL,0 }, { 0,0,NIL,0 } }
static aoIva	 	:= { { NIL,NIL,NIL,NIL,NIL }, { NIL,NIL,NIL,NIL,NIL }, { NIL,NIL,NIL,NIL,NIL } }
static bEdit 		:= { |aTmp, aGet, dbfAbnPrvT, oBrw, bWhen, bValid, nMode | EdtRec( aTmp, aGet, dbfAbnPrvT, oBrw, bWhen, bValid, nMode ) }
static bEdit2		:= { |aTmp, aGet, dbfAbnPrvL, oBrw, bWhen, bValid, nMode, nAbono | EdtDet( aTmp, aGet, dbfAbnPrvL, oBrw, bWhen, bValid, nMode, nAbono ) }
static aBase1     := {{"NNUMFAC"    ,"N",  9, 0, "Número del abono" },;
							{ "CSUFFAC"	   ,"C",  2, 0, "Sufijo del abono" },;
							{ "DFECFAC"    ,"D",  8, 0, "Fecha del abono" },;
                     { "CCODPRV"    ,"C", 12, 0, "Codigo del proveedor" },;
                     { "CCODALM"    ,"C",  3, 0, "Codigo de almacen" },;
							{ "CNOMPRV"    ,"C", 35, 0, "Nombre del proveedor" },;
							{ "CDIRPRV"    ,"C",200, 0, "dirección del proveedor" },;
							{ "CPOBPRV"    ,"C",200, 0, "Población del proveedor" },;
							{ "CPRVPRV"    ,"C",100, 0, "Provincia del proveedor" },;
                     { "NCODPRV"    ,"N",  2, 0, "Número de provincia proveedor" },;
                     { "CPOSPRV"    ,"C",  5, 0, "Codigo postal del proveedor" },;
                     { "CDNIPRV"    ,"C", 30, 0, "DNI/CIF del proveedor" },;
							{ "LLIQUIDADA" ,"L",  1, 0, "Lógico de la liquidación" },;
							{ "LCONTAB"    ,"L",  1, 0, "Lógico de la contabilización" },;
							{ "DFECENT"    ,"D",  8, 0, "Fecha de entrada" },;
							{ "CSUPED"     ,"C", 10, 0, "Su pedido" },;
							{ "CCONDENT"   ,"C", 20, 0, "Condición de entrada" },;
							{ "CEXPED"     ,"C", 20, 0, "Expedición" },;
							{ "COBSERV"    ,"C", 20, 0, "Observaciones" },;
                     { "CCODPAGO"   ,"C",  2, 0, "Codigo de la forma de pago" },;
                     { "NBULTOS"    ,"N",  3, 0, "Número de bultos" },;
							{ "NPORTES"    ,"N",  6, 0, "Valor de los portes" },;
                     { "NTIPOFAC"   ,"N",  1, 0, "Número del tipo de abono" },;
							{ "NDTOESP"    ,"N",  4, 1, "Porcentaje de descuento especial" },;
							{ "NDPP"       ,"N",  4, 1, "Porcentaje de descuento por pronto pago" },;
                     { "NTIPOIVA"   ,"N",  1, 0, "Número del tipo de " + cImp() },;
                     { "NPORCIVA"   ,"N",  4, 1, "Porcentaje de " + cImp() },;
							{ "LRECARGO"   ,"L",  1, 0, "Lógico para recargo" },;
							{ "NIRPF"      ,"N",  4, 1, "Porcentaje de IRPF" },;
                     { "CCODAGE"    ,"C",  3, 0, "Codigo del agente" },;
                     { "CCODRUT"    ,"C",  3, 0, "Codigo de la ruta" },;
                     { "CDIVFAC"    ,"C",  3, 0, "Codigo de divisa" },;
							{ "NVDVFAC"    ,"N", 10, 4, "Valor del cambio de la divisa" },;
							{ "LSNDDOC"    ,"L",  1, 0, "Enviar documento por internet" }}
static aBase2     := {{"NNUMFAC"   ,"N",  9, 0, "Numero del abono" },;
							{ "CSUFFAC"	  ,"C",  2, 0, "Sufijo del abono" },;
							{ "CREF"      ,"C", 10, 0, "" },;
							{ "CDETALLE"  ,"C", 50, 0, "" },;
							{ "MLNGDES"   ,"M", 10, 0, "" },;
                     { "NPREUNIT"  ,"N", 16, 6, "" },;
                     { "NDTO"      ,"N",  6, 2, "" },;
							{ "NIVA"		  ,"N",  6, 2, "" },;
                     { "NCANENT"   ,"N", 16, 6, "" },;
							{ "LCONTROL"  ,"L",  1, 0, "" },;
							{ "CUNIDAD"   ,"C",  2, 0, "" },;
							{ "NUNICAJA"  ,"N",  6, 2, "" },;
                     { "DFECHA"    ,"D",  8, 0, "" },;
                     { "NFACCNV"   ,"N", 16, 6, "Factor de conversión de la compra" } }

//----------------------------------------------------------------------------//

STATIC FUNCTION OpenFiles()

	IF dbfAbnPrvT == NIL

      USE ( cPatEmp() + "ABNPRVT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ABNPRVT", @dbfAbnPrvT ) )
      SET ADSINDEX TO ( cPatEmp() + "ABNPRVT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ABNPRVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ABNPRVL", @dbfAbnPrvL ) )
      SET ADSINDEX TO ( cPatEmp() + "ABNPRVL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PROVEE.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROVEE", @dbfPrv ) )
      SET ADSINDEX TO ( cPatEmp() + "PROVEE.CDX" ) ADDITIVE

      USE ( cPatDat() + "TIVA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfIva ) )
      SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FPAGO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FPAGO", @dbfFPago ) )
      SET ADSINDEX TO ( cPatEmp() + "FPAGO.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
      SET ADSINDEX TO ( cPatEmp() + "ARTICULO.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ARTPRECI.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTPRECIO", @dbfArtPre ) )
      SET ADSINDEX TO ( cPatEmp() + "ARTPRECI.CDX" ) ADDITIVE

      USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDivisa ) )
      SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

      USE ( cPatDat() + "BANDERA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "BANDERA", @dbfBander ) )
      SET ADSINDEX TO ( cPatDat() + "BANDERA.CDX" ) ADDITIVE

      USE ( cPatEmp() + "MOVALM.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "MOVALM", @dbfMov ) )
      SET ADSINDEX TO ( cPatEmp() + "MOVALM.CDX" ) ADDITIVE

	END IF

RETURN NIL

//----------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles( aDbfBmp )

	AEval( aDbfBmp, { | hBmp | DeleteObject( hBmp ) } )

	dbCommitAll()

		( dbfIva     )->( dbCloseArea() )
		( dbfFPago   )->( dbCloseArea() )
		( dbfPrv     )->( dbCloseArea() )
		( dbfAbnPrvL )->( dbCloseArea() )
		( dbfDivisa  )->( dbCloseArea() )
		( dbfBander  )->( dbCloseArea() )
		( dbfMov     )->( dbCloseArea() )
		( dbfArticulo)->( dbCloseArea() )
		( dbfArtPre  )->( dbCloseArea() )

		IF oWndBrw != NIL
			oWndBrw:oBrw:lCloseArea()
			oWndBrw 	:= NIL
		ELSE
			( dbfAbnPrvT )->( dbCloseArea() )
		END IF

		dbfIva		:= NIL
		dbfFPago    := NIL
		dbfPrv 		:= NIL
		dbfAbnPrvL  := NIL
		dbfAbnPrvT  := NIL
		dbfDivisa	:= NIL
		dbfBander   := NIL
		dbfMov      := NIL
		dbfArticulo	:= NIL
		dbfArtPre   := NIL
		oWndBrw 		:= NIL

RETURN .T.

//----------------------------------------------------------------------------//

FUNCTION AbnPrv( oWnd )

	local lEur		:= .f.
	local	aDbfBmp  := {  LoadBitmap( GetResources(), "BGREEN" ),;
								LoadBitmap( GetResources(), "BRED"   ) }

	IF oWndBrw == NIL

	OpenFiles()

   DEFINE SHELL oWndBrw FROM 0, 0 TO 22, 80 ;
		TITLE 	"Abonos a Proveedores" ;
		FIELDS ;
					If( (dbfAbnPrvT)->LCONTAB, aDbfBmp[1], aDbfBmp[2] ),;
					Str( (dbfAbnPrvT)->NNUMFAC ) + "/" + (dbfAbnPrvT)->CSUFFAC,;
					Dtoc( (dbfAbnPrvT)->DFECFAC ),;
					(dbfAbnPrvT)->CCODPRV + Space(1) + RetProvee( (dbfAbnPrvT)->CCODPRV, dbfPrv ),;
					nTotal( Str( (dbfAbnPrvT)->NNUMFAC ) + (dbfAbnPrvT)->CSUFFAC, dbfAbnPrvT, dbfAbnPrvL, dbfIva, dbfDivisa, nil, lEur, .t. ) ;
		HEAD;
					"Est",;
					"N. Abono",;
					"Fecha",;
					"Proveedor",;
					"Importe";
		FIELDSIZES ;
					20,;
					80,;
					80,;
					300,;
					120 ;
      JUSTIFY  .F., .F., .F., .F., .T. ;
      ALIAS    ( dbfAbnPrvT );
      PROMPTS  "Número",;
					"Fecha",;
					"Proveedor";
		APPEND	( WinAppRec( oWndBrw:oBrw, bEdit, dbfAbnPrvT ) );
		DUPLICAT	( WinDupRec( oWndBrw:oBrw, bEdit, dbfAbnPrvT ) );
		DELETE   ( DBDelRec(  oWndBrw:oBrw, dbfAbnPrvT, {|| DelDetalle( (dbfAbnPrvT)->NNUMFAC ) } ) );
		EDIT 		( WinEdtRec( oWndBrw:oBrw, bEdit, dbfAbnPrvT ) );
      OF oWnd


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
         HOTKEY   "M";
         MRU

		DEFINE BTNSHELL RESOURCE "ZOOM" OF oWndBrw ;
			NOBORDER ;
			ACTION  	( WinZooRec( oWndBrw:oBrw, bEdit, dbfAbnPrvT ) );
			TOOLTIP 	"(Z)oom";
         HOTKEY   "Z";
         MRU

		DEFINE BTNSHELL RESOURCE "DEL" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( oWndBrw:RecDel() );
			TOOLTIP 	"(E)liminar";
			HOTKEY 	"E"

		DEFINE BTNSHELL RESOURCE "BUS" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( oWndBrw:Search() ) ;
			TOOLTIP 	"(B)uscar" ;
			HOTKEY 	"B"

		DEFINE BTNSHELL RESOURCE "CHGSTATE" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( ChgState( oWndBrw:oBrw ) ) ;
			TOOLTIP 	"Cambiar Es(t)ado" ;
			HOTKEY 	"T"

      DEFINE BTNSHELL RESOURCE "IMP" GROUP OF oWndBrw ;
			NOBORDER ;
			ACTION 	( GenAbono( .T. ) ) ;
			TOOLTIP 	"(I)mprimir";
			HOTKEY 	"I"

		DEFINE BTNSHELL RESOURCE "PREV1" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( GenAbono() ) ;
			TOOLTIP 	"(P)revisualizar";
			HOTKEY 	"P"

		DEFINE BTNSHELL RESOURCE "BMPCONTA" OF oWndBrw ;
			NOBORDER ;
			ACTION  	( TransAbono( oWndBrw:oBrw ) ) ;
			TOOLTIP 	"(C)ontabilizar" ;
			HOTKEY 	"C"

      DEFINE BTNSHELL RESOURCE "END"  GROUP OF oWndBrw ;
			NOBORDER ;
			ACTION 	( oWndBrw:End() ) ;
			TOOLTIP 	"(S)alir";
			HOTKEY   "S"

		ACTIVATE WINDOW oWndBrw VALID ( CloseFiles( aDbfBmp ) )

	ELSE

		oWndBrw:setFocus()

	END IF

RETURN NIL

//----------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aTmp, aGet, dbfAbnPrvT, oBrw, bWhen, bValid, nMode )

	local oDlg
	local oFld
	local oBrw2, oBrw3
	local oFont
	local oGet1, oGet2, oGet3, oGet4
	local cGet1, cGet2, cGet3, cGet4
	local nImpIva1	:= 0
	local nImpIva2	:= 0
	local nImpIva3	:= 0
	local nImpReq1	:= 0
	local nImpReq2	:= 0
	local nImpReq3	:= 0
	local oBtnHelp
	local nRecno	:= (dbfAbnPrvT)->( RecNo() )
	local bmpEmp	:= bmpEmp()

   oFont := TFont():New( "Arial", 8, 26, .F., .T. )

	IF nMode == APPD_MODE
      aTmp[ _CDIVFAC ]  := cDivEmp()
      aTmp[ _CCODALM ]  := oUser():cAlmacen()
      aTmp[ _NVDVFAC ]  := nChgDiv( aTmp[ _CDIVFAC ], dbfDivisa )
		aTmp[ _CSUFFAC ]	:= retSufEmp()
	END IF

	BeginTrans( aTmp )

	cPicUnd	:= masUnd()
	cPinDiv	:= cPinDiv( aTmp[ _CDIVFAC ], dbfDivisa )
	cPicEur	:= cPinDiv( "EUR", dbfDivisa )				// Picture del euro
	nDinDiv	:= nDinDiv( aTmp[ _CDIVFAC ], dbfDivisa )
   oFont    := TFont():New( "Arial", 8, 26, .F., .T. )

	DEFINE DIALOG oDlg RESOURCE "ABNPRV" TITLE LblTitle( nMode ) + " Abonos a Proveedores"

		REDEFINE FOLDER oFld ID 400 OF oDlg ;
			PROMPT 	"&Abono", 	"&Mas Datos" ;
			DIALOGS 	"ABNPRV_1", "ABNPRV_2"

		REDEFINE GET aGet[_NNUMFAC] VAR aTmp[_NNUMFAC] ;
			ID 		100 ;
			PICTURE 	"999999999";
			WHEN		.F. ;
			COLOR 	CLR_SHOW ;
			OF 		oFld:aDialogs[1]

		REDEFINE GET aGet[_CSUFFAC] VAR aTmp[_CSUFFAC];
			ID 		105 ;
			WHEN 		.F. ;
			COLOR 	CLR_SHOW ;
			OF 		oFld:aDialogs[1]

		REDEFINE GET aGet[_DFECFAC] VAR aTmp[_DFECFAC] ;
			ID 		110 ;
			SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[1]

		REDEFINE GET aGet[ _CCODPRV ] VAR aTmp[ _CCODPRV ] ;
			ID 		140 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
         VALID    LoaPrv( aGet ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwProvee( aGet[ _CCODPRV ], aGet[_CNOMPRV] ) );
			OF 		oFld:aDialogs[1]

		REDEFINE GET aGet[_CNOMPRV] VAR aTmp[ _CNOMPRV ];
			ID 		141 ;
			WHEN 		( .F. ) ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[1]

		REDEFINE GET aGet[_CCODALM] VAR aTmp[_CCODALM] ;
			ID 		150 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			VALID 	cAlmacen( aGet[_CCODALM], , oGet1 );
         BITMAP   "LUPA" ;
			ON HELP 	brwAlmacen( aGet[ _CCODALM ], oGet1 );
			OF 		oFld:aDialogs[1]

		REDEFINE GET oGet1 VAR cGet1 ;
			ID 		151 ;
			WHEN 		( .F. );
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[1]

		REDEFINE GET aGet[_CCODPAGO] VAR aTmp[_CCODPAGO];
			ID 		160 ;
			PICTURE 	"@!" ;
			COLOR 	CLR_GET ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			VALID 	cFPago( aGet[_CCODPAGO], dbfFPago, oGet3 ) ;
         BITMAP   "LUPA" ;
			ON HELP 	BrwFPago( aGet[_CCODPAGO ], dbfFPago, oGet3 ) ;
			OF 		oFld:aDialogs[1]

		REDEFINE GET oGet3 VAR cGet3;
			ID 		161 ;
			WHEN 		.F. ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[1]

		/*
		Moneda__________________________________________________________________
		*/

		REDEFINE GET aGet[ _CDIVFAC ] VAR aTmp[ _CDIVFAC ];
			WHEN 		( 	nMode != ZOOM_MODE ) ;
			VALID		( 	cDiv( aGet[ _CDIVFAC ], oBmpDiv, aGet[ _NVDVFAC ], @cPinDiv, @nDinDiv, dbfDivisa, dbfBander ),;
							nTotal( nil, dbfAbnPrvT, dbfTmp, dbfIva, dbfDivisa, aTmp ),;
							oBrw2:refresh(),;
							.t. );
			PICTURE	"@!";
			ID 		170 ;
			COLOR 	CLR_GET ;
         BITMAP   "LUPA" ;
         ON HELP  BrwDiv( aGet[ _CDIVFAC ], oBmpDiv, aGet[ _NVDVFAC ], dbfDivisa, oBandera ) ;
			OF 		oFld:aDialogs[1]

		REDEFINE BITMAP oBmpDiv ;
         RESOURCE "BAN_EURO" ;
			ID 		171;
			OF 		oFld:aDialogs[1]

		REDEFINE GET aGet[ _NVDVFAC ] VAR aTmp[ _NVDVFAC ];
			WHEN		( .F. ) ;
			ID 		180 ;
			PICTURE	"@E 999,999.9999" ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[1]

		/*
		Bitmap________________________________________________________________
		*/

		REDEFINE BITMAP ;
			FILE		bmpEmp ;
			ID 		600 ;
			OF 		oFld:aDialogs[1] ;
         TRANSPARENT;
			ADJUST

		/*
		Detalle________________________________________________________________
		*/

      REDEFINE IBROWSE oBrw2 ;
			FIELDS ;
						(dbfTmp)->CREF, ;
						(dbfTmp)->CDETALLE, ;
						Trans( nUnitEnt( dbfTmp ), "@E 999,999.999" ), ;
						Trans( nTotUAbnPrv( dbfTmp, nDinDiv, aTmp[ _NVDVFAC ] ), cPinDiv ),;
						Trans( (dbfTmp)->NDTO, "@E 999.999"), ;
						Trans( (dbfTmp)->NIVA, "@E 99.999" ), ;
						Trans( nTotLAbnPrv( dbfTmp, nDinDiv, aTmp[ _NVDVFAC ] ), cPinDiv );
			FIELDSIZES ;
						80,;
						160,;
						80,;
						80,;
						40,;
						40,;
						100;
			HEAD ;
                  "Codigo",;
						"Detalle",;
						"Unds.",;
						"Precio U.",;
						"Dto.",;
                  cImp(),;
						"Importe";
         JUSTIFY  .f., .f., .t., .t., .t., .t., .t. ;
         ALIAS    ( dbfTmp ) ;
			ID 		190 ;
			OF 		oFld:aDialogs[1]

         oBrw2:cWndName       := "Linea de albarán proveedor detalle"

         oBrw2:Load()

			IF nMode	!= ZOOM_MODE
				oBrw2:bLDblClick	= {|| EdtDeta( oBrw2, bEdit2, aTmp ) }
				oBrw2:bAdd  		= {|| AppDeta( oBrw2, bEdit2, aTmp ) }
				oBrw2:bEdit 		= {|| EdtDeta( oBrw2, bEdit2, aTmp ) }
				oBrw2:bDel  		= {|| DelDeta( oBrw2, aTmp ) }
			END IF

		REDEFINE GET aGet[ _NDTOESP ] VAR aTmp[ _NDTOESP ] ;
			ID 		200 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			PICTURE 	"@E 99.9" ;
			COLOR 	CLR_GET ;
			ON CHANGE( nTotal( nil, dbfAbnPrvT, dbfTmp, dbfIva, dbfDivisa, aTmp ), .T. );
			OF 		oFld:aDialogs[1]

		REDEFINE GET aGet[ _NDPP ] VAR aTmp[ _NDPP ];
			ID 		210 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			PICTURE 	"@E 99.9" ;
			COLOR 	CLR_GET ;
			ON CHANGE( nTotal( nil, dbfAbnPrvT, dbfTmp, dbfIva, dbfDivisa, aTmp ), .T. );
			OF 		oFld:aDialogs[1]

		/*
      Desglose del impuestos
		________________________________________________________________________
		*/

		REDEFINE SAY _OBASIVA1 _NBASIVA1 ;
			ID 		220;
			WHEN		_NPCTIVA1 != NIL ;
			OF 		oFld:aDialogs[1]

		REDEFINE SAY _OBASIVA2 VAR _NBASIVA2 ;
			ID 		230 ;
			WHEN		_NPCTIVA2 != NIL ;
			OF 		oFld:aDialogs[1]

		REDEFINE SAY _OBASIVA3 VAR _NBASIVA3 ;
			ID 		240;
			WHEN		_NPCTIVA3 != NIL ;
			OF 		oFld:aDialogs[1]

		REDEFINE SAY _OPCTIVA1 VAR _NPCTIVA1 ;
			ID 		250;
			PICTURE 	"@E 99.99" ;
			WHEN		_NPCTIVA1 != NIL ;
			OF 		oFld:aDialogs[1]

		REDEFINE SAY _OPCTIVA2 VAR _NPCTIVA2 ;
			ID 		260 ;
			PICTURE 	"@E 99.99" ;
			WHEN		_NPCTIVA2 != NIL ;
			OF 		oFld:aDialogs[1]

		REDEFINE SAY _OPCTIVA3 VAR _NPCTIVA3 ;
			ID 		270 ;
			PICTURE 	"@E 99.99" ;
			WHEN		_NPCTIVA3 != NIL ;
			OF 		oFld:aDialogs[1]

		REDEFINE SAY _OIMPIVA1 VAR nImpIva1 ;
			ID 		280 ;
			WHEN		_NPCTIVA1 != NIL ;
			OF 		oFld:aDialogs[1]

		REDEFINE SAY _OIMPIVA2 VAR nImpIva2 ;
			ID 		290 ;
			WHEN		_NPCTIVA2 != NIL ;
			OF 		oFld:aDialogs[1]

		REDEFINE SAY _OIMPIVA3 VAR nImpIva3 ;
			ID 		300 ;
			WHEN		_NPCTIVA3 != NIL ;
			OF 		oFld:aDialogs[1]

		/*
		Cajas Bases de los R.E.
		------------------------------------------------------------------------
		*/

		REDEFINE SAY _OPCTREQ1 VAR _NPCTREQ1 ;
			ID 		310;
			PICTURE 	"@E 99.99" ;
			WHEN		_NPCTIVA1 != NIL ;
			OF 		oFld:aDialogs[1]

		REDEFINE SAY _OPCTREQ2 VAR _NPCTREQ2 ;
			ID 		320;
			PICTURE 	"@E 99.99" ;
			WHEN		_NPCTIVA2 != NIL ;
			OF 		oFld:aDialogs[1]

		REDEFINE SAY _OPCTREQ3 VAR _NPCTREQ3 ;
			ID 		330;
			PICTURE 	"@E 99.99" ;
			WHEN		_NPCTIVA3 != NIL ;
			OF 		oFld:aDialogs[1]

		REDEFINE SAY _OIMPREQ1 VAR nImpReq1 ;
			ID 		340 ;
			WHEN		_NPCTIVA1 != NIL ;
			OF 		oFld:aDialogs[1]

		REDEFINE SAY _OIMPREQ2 VAR nImpReq2 ;
			ID 		350 ;
			WHEN		_NPCTIVA2 != NIL ;
			OF 		oFld:aDialogs[1]

		REDEFINE SAY _OIMPREQ3 VAR nImpReq3 ;
			ID 		360 ;
			WHEN		_NPCTIVA3 != NIL ;
			OF 		oFld:aDialogs[1]

		/*
		Cajas de Totales
		------------------------------------------------------------------------
		*/

		REDEFINE SAY oGetNet VAR nGetNeto ;
			ID 		370 ;
			OF 		oFld:aDialogs[1]

		REDEFINE SAY oGetIva VAR nGetIva ;
			ID 		380 ;
			OF 		oFld:aDialogs[1]

		REDEFINE SAY oGetReq VAR nGetReq ;
			ID 		390 ;
			OF 		oFld:aDialogs[1]

		REDEFINE CHECKBOX aGet[_LRECARGO] VAR aTmp[_LRECARGO] ;
			ID 		400 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			ON CHANGE( nTotal( nil, dbfAbnPrvT, dbfTmp, dbfIva, dbfDivisa, aTmp ) );
			OF 		oFld:aDialogs[1]

		REDEFINE SAY oGetTotal VAR nTotalFac ;
			ID 		410 ;
			FONT 		oFont ;
			OF 		oFld:aDialogs[1]

		REDEFINE SAY oGetTotEur VAR nTotalEur;
			ID 		420 ;
			PICTURE 	cPicEur ;
			OF 		oFld:aDialogs[1]

		/*
		Botones_________________________________________________________________
		*/

		REDEFINE BUTTON ;
			ID 		500 ;
			OF 		oFld:aDialogs[1] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			ACTION 	( AppDeta( oBrw2, bEdit2, aTmp) )

		REDEFINE BUTTON ;
			ID 		501 ;
			OF 		oFld:aDialogs[1] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			ACTION 	( EdtDeta( oBrw2, bEdit2, aTmp ) )

		REDEFINE BUTTON ;
			ID 		502 ;
			OF 		oFld:aDialogs[1] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			ACTION 	( DelDeta( oBrw2, aTmp ) )

		REDEFINE BUTTON ;
			ID 		503 ;
			OF 		oFld:aDialogs[1] ;
			ACTION 	( ZoomDeta( oBrw2, bEdit2, aTmp ) )

		REDEFINE BUTTON ;
			ID 		524 ;
			OF 		oFld:aDialogs[1] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			ACTION 	( DbSwapUp( dbfTmp, oBrw2 ) )

		REDEFINE BUTTON ;
			ID 		525 ;
			OF 		oFld:aDialogs[1] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			ACTION 	( DbSwapDown( dbfTmp, oBrw2 ) )

		/*
		Redefinición de la segunda caja de dialogo
		------------------------------------------------------------------------
		*/

		REDEFINE GET aTmp[_CNOMPRV] ;
			ID 		100 ;
			COLOR 	CLR_GET ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oFld:aDialogs[2]

		REDEFINE GET aGet[_CPRVPRV] VAR aTmp[_CPRVPRV] ;
			ID 		110 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[2]

		REDEFINE GET aGet[_CDIRPRV] VAR aTmp[_CDIRPRV] ;
			ID 		120 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[2]

		REDEFINE GET aGet[_CPOBPRV] VAR aTmp[_CPOBPRV] ;
			ID 		140 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[2]

		REDEFINE GET aGet[_CPOSPRV] VAR aTmp[_CPOSPRV] ;
			ID 		130 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[2]

		REDEFINE GET aGet[_CDNIPRV] VAR aTmp[_CDNIPRV] ;
			ID 		150 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[2]

		REDEFINE GET aGet[_DFECENT] VAR aTmp[_DFECENT] ;
			ID 		160 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[2]

		REDEFINE GET aGet[_NBULTOS] VAR aTmp[_NBULTOS] ;
			ID 		200 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			PICTURE 	"999" ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[2]

		REDEFINE GET aGet[_NPORTES] VAR aTmp[_NPORTES] ;
			ID 		190 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			PICTURE 	"@E 999,999" ;
			ON CHANGE( nTotal( nil, dbfAbnPrvT, dbfTmp, dbfIva, dbfDivisa, aTmp ) ) ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[2]

		REDEFINE GET aGet[_CEXPED] VAR aTmp[_CEXPED] ;
			ID 		180 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[2]

		/*
		Botones comunes a ambas cajas de Dialogo_______________________________
		*/

		REDEFINE APOLOMETER oMetMsg VAR nMetMsg ;
			ID 		100 ;
			NOPERCENTAGE ;
			OF 		oDlg

		REDEFINE BUTTON ;
			ID 		511 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			ACTION 	( 	EndTrans( aTmp, oBrw2, nMode ) ,;
							WinGather( aTmp, , dbfAbnPrvT, oBrw, nMode ),;
                     oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
			ID 		510 ;
			OF 		oDlg ;
			ACTION 	( If 	( ExitNoSave( nMode ),;
                        ( KillTrans( oBrw2 ), oDlg:end() ), ) )

		REDEFINE BUTTON ;
			ID 		535 ;
			OF 		oDlg ;
			WHEN 		( .F. )

	ACTIVATE DIALOG oDlg	;
		ON INIT		( nTotal( nil, dbfAbnPrvT, dbfTmp, dbfIva, dbfDivisa, aTmp ), .T. );
		ON PAINT 	( evalGet( aGet, nMode ) ) ;
      ON CANCEL   ( KillTrans( oBrw2 ) ) ;
		CENTER

	oFont:end()

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

/*
Edita las lineas de Detalle
*/

STATIC FUNCTION EdtDet( aTmp, aGet, dbfAbnPrvL, oBrw, bWhen, bValid, nMode, nAbono )

	local oDlg
	local oFld
	local oTotal
	local oGet
	local cTitle
	local nPreCosto	:= 0
	local nTotal 		:= 0

	IF nMode 	== APPD_MODE
		aTmp[_dNNUMFAC] := nAbono
		aTmp[_NCANENT ] := 1
      If( lUseCaj(), aTmp[_NCANENT] := 1, )
	END IF

	DEFINE DIALOG oDlg RESOURCE "LFACPRV" TITLE LblTitle( nMode ) + "Lineas a Facturas de Proveedores"

		REDEFINE FOLDER oFld ID 400 OF oDlg ;
			PROMPT 	"&General" ;
			DIALOGS 	"LFACPRV_1"

		REDEFINE GET aGet[_CREF] VAR aTmp[_CREF];
			ID 		110 ;
			WHEN  	( nMode != ZOOM_MODE );
			VALID 	( LoadArt( aGet ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwArticulo( Self, aGet[_CDETALLE] ) );
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[1]

		REDEFINE GET aGet[_CDETALLE] VAR aTmp[_CDETALLE] ;
			ID 		120 ;
         WHEN     ( lModDes() .AND. nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[1]

		REDEFINE GET aGet[_MLNGDES] VAR aTmp[_MLNGDES] ;
			MEMO ;
			ID 		121 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[1]

		REDEFINE GET aGet[_NIVA] VAR aTmp[_NIVA] ;
			ID 		130 ;
         WHEN     ( lModIva() .AND. nMode != ZOOM_MODE ) ;
			VALID 	( lTiva( dbfIva, aTmp[_NIVA] ) );
			PICTURE 	"@E 99.99" ;
         COLOR    CLR_GET ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwTipoIva( aGet[_NIVA], dbfIva ) ) ;
			OF 		oFld:aDialogs[1]

		REDEFINE GET aTmp[_NCANENT] ;
			ID 		140 ;
			SPINNER ;
         WHEN     ( lUseCaj() .AND. nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			ON CHANGE( lCalcDeta( aTmp, oTotal ) ) ;
			PICTURE 	cPicUnd ;
			OF 		oFld:aDialogs[1]

		REDEFINE GET aGet[_NUNICAJA] VAR aTmp[_NUNICAJA] ;
			ID 		150 ;
			SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			ON CHANGE( lCalcDeta( aTmp, oTotal ) );
			PICTURE 	cPicUnd;
			OF 		oFld:aDialogs[1]

		REDEFINE GET aGet[_NPREUNIT] VAR aTmp[_NPREUNIT] ;
			ID 		160 ;
			SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			VALID 	( aTmp[_NPREUNIT] != 0 );
			COLOR 	CLR_GET ;
			ON CHANGE( lCalcDeta( aTmp, oTotal ) );
			PICTURE 	cPinDiv ;
			OF 		oFld:aDialogs[1]

		REDEFINE GET aGet[_CUNIDAD] VAR aTmp[_CUNIDAD] ;
			ID 		170 ;
			SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			ON CHANGE( lCalcDeta( aTmp, oTotal ) );
			OF 		oFld:aDialogs[1]

		REDEFINE GET aTmp[_NDTO] ;
			ID 		180 ;
			SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			ON CHANGE( lCalcDeta( aTmp, oTotal ) );
			PICTURE 	"@E 999,999,999.999";
			OF 		oFld:aDialogs[1]

		REDEFINE GET oTotal VAR nTotal ;
			ID 		210 ;
			COLOR 	CLR_SHOW ;
			PICTURE 	cPinDiv ;
			WHEN 		.F. ;
			OF 		oFld:aDialogs[1]

		REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			ACTION 	SaveDeta( aTmp, aGet, oBrw, oDlg, nMode, oTotal )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

	oDlg:bStart := {|| SetDlgMode( aGet, nMode ) }

	ACTIVATE DIALOG oDlg CENTER ON INIT lCalcDeta( aTmp, oTotal )

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

STATIC FUNCTION SetDlgMode( aGet, nMode )

	local cCodArt	:= aGet[_CREF]:varGet()

	DO CASE
	CASE nMode == APPD_MODE
		aGet[_CREF    ]:show()
		aGet[_CDETALLE]:show()
		aGet[_MLNGDES ]:hide()
	CASE nMode != APPD_MODE .AND. empty( cCodArt )
		aGet[_CREF    ]:hide()
		aGet[_CDETALLE]:hide()
		aGet[_MLNGDES ]:show()
	CASE nMode != APPD_MODE .AND. !empty( cCodArt )
		aGet[_CREF    ]:show()
		aGet[_CDETALLE]:show()
		aGet[_MLNGDES ]:hide()
	END CASE

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION SaveDeta( aTmp, aGet, oBrw, oDlg, nMode, oTotal )

	IF lMoreIva( aTmp[_NIVA] )

		WinGather( aTmp, aGet, dbfTmp, oBrw, nMode )

      IF nMode == APPD_MODE .AND. lEntCon()

			IF aGet[_NCANENT] != NIL
				aGet[_NCANENT]:cText(1)
			END IF

         IF lUseCaj()
				aGet[_NUNICAJA]:cText( 1 )
			END IF

			aGet[_CREF]:setFocus()
			oTotal:cText( 0 )

		ELSE

         oDlg:end( IDOK )

		END IF

		oTotal:cText( 0 )

	END IF

RETURN NIL

//--------------------------------------------------------------------------//
/*
Funcion Auxiliar para A¤adir lineas de detalle a una Abono
*/

STATIC FUNCTION AppDeta( oBrw2, bEdit2, aTmp )

	WinAppRec( oBrw2, bEdit2, dbfTmp, , , aTmp[_NNUMFAC] )

RETURN nTotal( nil, dbfAbnPrvT, dbfTmp, dbfIva, dbfDivisa, aTmp )

//--------------------------------------------------------------------------//
/*
Funcion Auxiliar para la Edici¢n de Lineas de Detalle en una Abono
*/

STATIC FUNCTION EdtDeta( oBrw2, bEdit2, aTmp )

	WinEdtRec( oBrw2, bEdit2, dbfTmp, , , aTmp[_NNUMFAC] )

RETURN nTotal( nil, dbfAbnPrvT, dbfTmp, dbfIva, dbfDivisa, aTmp )

//--------------------------------------------------------------------------//
/*
Funcion Auxiliar para la Visualizaci¢n de Lineas de Detalle en una Abono
*/

STATIC FUNCTION EdtZoom( oBrw2, bEdit2, aTmp )

	WinZooRec( oBrw2, bEdit2, dbfAbnPrvL, , , aTmp[_NNUMFAC] )

RETURN nTotal( nil, dbfAbnPrvT, dbfTmp, dbfIva, dbfDivisa, aTmp )

//--------------------------------------------------------------------------//
/*
Funcion Auxiliar para borrar las Lineas de Detalle en una Abono
*/

STATIC FUNCTION DelDeta( oBrw2, aTmp )

	DbDelRec( oBrw2, dbfTmp )

RETURN nTotal( nil, dbfAbnPrvT, dbfTmp, dbfIva, dbfDivisa, aTmp )

//--------------------------------------------------------------------------//

/*
Funcion Auxiliar para la Visualizaci¢n de Lineas de Detalle en una Abono
*/

STATIC FUNCTION ZoomDeta( oBrw2, bEdit2, aTmp )

	IF !(dbfTmp)->LCONTROL
		WinZooRec( oBrw2, bEdit2, dbfTmp, , , aTmp[_dNNUMFAC] )
	END IF

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION NewAbnPrv()

	local dbfCount
	local cNewAbn

	WHILE .T.
      USE ( cPatEmp() + "COUNT.DBF" ) NEW VIA ( cDriver() )ALIAS ( cCheckArea( "COUNT", @dbfCount ) )
		IF !netErr()
			EXIT
		END IF
	END

	cNewAbn 	:= ( dbfCount )->NABNPRV
	( dbfCount )->NABNPRV++

	CLOSE ( dbfCount )

RETURN ( cNewAbn )

//--------------------------------------------------------------------------//

STATIC FUNCTION PrnSerie()

	local oDlg
	local oDocIni
	local oDocFin
	local oRadSerie
	local oBtnOk
	local oBtnCancel
	local nSerie
	local cSerie
	local nRecno	:= (dbfAbnPrvT)->( RecNo() )
	local nOrdAnt	:= (dbfAbnPrvT)->( OrdSetFocus( 1 ) )
	local nDocIni	:= Str( (dbfAbnPrvT)->NNUMFAC ) + (dbfAbnPrvT)->CSUFFAC
	local nDocFin	:= Str( (dbfAbnPrvT)->NNUMFAC ) + (dbfAbnPrvT)->CSUFFAC

	DEFINE DIALOG oDlg RESOURCE "PRNSERIES" TITLE "Imprimir series de abonos"

	REDEFINE GET oDocIni VAR nDocIni;
		ID 		110 ;
		PICTURE 	"@R 999999999/XX" ;
		VALID 	( If ( !(dbfAbnPrvT)->( DbSeek( nDocIni ) ),;
					( msgStop( "Documento no valido" ), .F. ),;
					( .T. ) ) );
		COLOR 	CLR_GET ;
		OF 		oDlg

	REDEFINE GET oDocFin VAR nDocFin;
		ID 		120 ;
		PICTURE 	"@R 999999999/XX" ;
		VALID 	( If ( !(dbfAbnPrvT)->( DbSeek( nDocFin ) ),;
					( msgStop( "Documento no valido" ), .F. ),;
					( .T. ) ) );
		COLOR 	CLR_GET ;
		OF 		oDlg

	REDEFINE BUTTON oBtnOk ;
		ID 		505 ;
		OF 		oDlg ;
      ACTION   ( StartPrint( nDocIni, nDocFin, oBtnOk, oBtnCancel ), oDlg:end( IDOK ) )

	REDEFINE BUTTON oBtnCancel ;
		ID 		IDCANCEL ;
		OF 		oDlg ;
		ACTION 	( oDlg:end() )

	ACTIVATE DIALOG oDlg CENTER

	(dbfAbnPrvT)->( dbGoTo( nRecNo ))
	(dbfAbnPrvT)->( OrdSetFocus( nOrdAnt ))

	oBrw:refresh()

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION StartPrint( nDocIni, nDocFin, oBtnOk, oBtnCancel )

	oBtnOk:disable()
	oBtnCancel:disable()

	(dbfAbnPrvT)->(DbSeek( nDocIni ) )

	WHILE Str( (dbfAbnPrvT)->NNUMFAC ) + ( dbfAbnPrvT )->CSUFFAC >= nDocIni .AND.;
			Str( (dbfAbnPrvT)->NNUMFAC ) + ( dbfAbnPrvT )->CSUFFAC <= nDocFin

		GenAbono( .T., "Imprimiendo Series" )
		(dbfAbnPrvT)->(DbSkip(1))

	END WHILE

	oBtnOk:enable()
	oBtnCancel:enable()

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

	IF aTmp[ _NDTO ] != 0
		nCalculo -= nCalculo * aTmp[ _NDTO ] / 100
	END IF

	oTotal:cText( nCalculo )

RETURN .T.

//---------------------------------------------------------------------------//

STATIC FUNCTION nTotUAbnPrv( dbfAbnPrvL, nDec, nVdv )

	local nCalculo

	DEFAULT nDec	:= nDinDiv( ( dbfAbnPrvT )->CDIVFAC, dbfDivisa )
	DEFAULT nVdv	:= ( dbfAbnPrvT )->NVDVFAC

	IF nVdv != 0
		nCalculo		:= ( dbfAbnPrvL )->NPREUNIT / nVdv
	END IF

RETURN ( round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//

FUNCTION nTotLAbnPrv( dbfDetalle, nDec, nVdv )

	local nCalculo := (dbfDetalle)->NPREUNIT * (dbfDetalle)->NUNICAJA

   IF lCalCaj()
		nCalculo *= If( (dbfDetalle)->NCANENT != 0, (dbfDetalle)->NCANENT, 1 )
	END IF

	IF (dbfDetalle)->NDTO != 0
		nCalculo -= nCalculo * (dbfDetalle)->NDTO / 100
	END IF

	IF nVdv != 0
		nCalculo := nCalculo / nVdv
	END IF

RETURN ( round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//

STATIC FUNCTION GenAbono( lPrinter, cCaption )

	local oFont1, oFont2, oFont3, oFont4
	local oPrn
	local nTipo			:= 8
	local nOldRecno 	:= (dbfAbnPrvL)->( RecNo() )
	local nAbono 		:= (dbfAbnPrvT)->NNUMFAC

	private cDbfCol	:= dbfAbnPrvL

	DEFAULT lPrinter	:= .F.
	DEFAULT cCaption  := "Imprimiendo Abonos"

	/*
	Recalculamos la factura
	*/

	nTotal( nil, dbfAbnPrvT, dbfTmp, dbfIva, dbfDivisa, aTmp )

	/*
	Buscamos el primer registro
	*/

	(dbfAbnPrvL)->( dbSeek( nAbono ) )

	/*
	Definimos la impresora y tomamos su tipo de letra
	*/

   DEFINE FONT oFont1 NAME "Arial" SIZE 0,-10
   DEFINE FONT oFont2 NAME "Courier New" SIZE 0,-10 BOLD
   DEFINE FONT oFont3 NAME "Arial" SIZE 0,-20 BOLD
   DEFINE FONT oFont4 NAME "Arial" SIZE 0,-12 BOLD

	IF lPrinter

		PRINTER oPrn

		REPORT oInf ;
		FONT oFont1, oFont2, oFont3, oFont4 ;
		CAPTION cCaption ;
		TO DEVICE oPrn

	ELSE

		PRINTER oPrn PREVIEW

		REPORT oInf ;
		FONT   oFont1, oFont2, oFont3, oFont4 ;
		CAPTION cCaption ;
		TO DEVICE oPrn

	END IF

	/*
	Cabeceras del listado
	*/

	IF oInf:lCreated

		oInf:lFinish	:= .F.
		oInf:bSkip 		:= {|| (dbfAbnPrvL)->( DbSkip() ) }
		SetMargin(  "NP1", oInf )
		PrintColum( "NP1", oInf )

	END IF

	END REPORT

	ACTIVATE REPORT oInf ;
		WHILE ( (dbfAbnPrvL)->NNUMFAC = nAbono ) ;
		ON ENDPAGE ( EPage( oInf ) )

	(dbfAbnPrvL)->(DbGoto( nOldRecno ))

	oFont1:end()
	oFont2:end()
	oFont3:end()
	oFont4:end()

   oInf:End()
   oPrn:End()

   oInf  := nil
   oPrn  := nil

RETURN NIL

//--------------------------------------------------------------------------//

/*
Borra todas las lineas de detalle de una Abono.
Esta funci¢n es usada al borrar toda una Abono.
*/

STATIC FUNCTION DelDetalle( nAbono )

   CursorWait()

	IF ( dbfAbnPrvL )->( dbSeek( nAbono ) )

		BackStock( 	(dbfAbnPrvT)->CCODALM,;
						dbfAbnPrvL,;
						{|| Str( ( dbfAbnPrvL )->NNUMFAC ) + ( dbfAbnPrvL )->CSUFFAC == nAbono },;
						_SUMA,;
						_ELIMINA,;
						dbfArticulo,;
						dbfMov )

	END IF

   CursorWe()

RETURN NIL

//--------------------------------------------------------------------------//

/*
Esta funci¢n hace los calculos de los totales en la Abono
*/

STATIC FUNCTION nTotal( nFactura, dbfAbnPrvT, dbfLine, dbfIva, dbfDivisa, aTmp, lEur, lPic )

	local bCondition
	local nTotalArt
	local dFecFac
	local lRecargo
	local nDtoEsp
	local nDtoPP
	local nPorte
	local nRecno
	local cCodDiv
	local cCodPgo
	local nVdvDiv
	local aTotalDto	:= { 0, 0, 0 }
	local aTotalDPP	:= { 0, 0, 0 }

	DEFAULT lEur		:= .f.
	DEFAULT lPic		:= .t.
	DEFAULT dbfLine 	:= dbfAbnPrvL

	nTotalFac 			:= 0
	nTotalBrt 			:= 0
	nTotalDto 			:= 0
	nTotalDPP 			:= 0
	nTotalNet 			:= 0
	nTotalIva 			:= 0
	nTotalReq 			:= 0
	nRecno    			:= ( dbfLine )->( recno() )
	aImpVto	 			:= { 0,0,0,0,0 }
	aIva      			:= { { 0,0,NIL,0 }, { 0,0,NIL,0 }, { 0,0,NIL,0 } }

	IF aTmp != NIL
		dFecFac			:= aTmp[ _DFECFAC ]
		lRecargo			:= aTmp[ _LRECARGO]
		nDtoEsp			:= aTmp[ _NDTOESP ]
		nDtoPP			:= aTmp[ _NDPP    ]
		nPorte			:= aTmp[ _NPORTES ]
		cCodDiv			:= aTmp[ _CDIVFAC ]
		nVdvDiv			:= aTmp[ _NVDVFAC ]
		cCodPgo			:= aTmp[ _CCODPAGO]
		bCondition		:= {|| ( dbfLine )->( !eof() ) }
		(dbfLine)->( dbGoTop() )
	ELSE
		dFecFac			:= (dbfAbnPrvT)->DFECFAC
		lRecargo			:= (dbfAbnPrvT)->LRECARGO
		nDtoEsp			:= (dbfAbnPrvT)->NDTOESP
		nDtoPP			:= (dbfAbnPrvT)->NDPP
		nPorte			:= (dbfAbnPrvT)->NPORTES
		cCodDiv			:= (dbfAbnPrvT)->CDIVFAC
		nVdvDiv			:= (dbfAbnPrvT)->NVDVFAC
		cCodPgo			:= (dbfAbnPrvT)->CCODPAGO
		bCondition		:= {|| Str( ( dbfLine )->NNUMFAC ) + ( dbfLine )->CSUFFAC == nFactura .AND. ( dbfLine )->( !eof() ) }
		( dbfLine )->( dbSeek( nFactura ) )
	END IF

	/*
	Cargamos los pictures dependiendo de la moneda
	*/

	IF lEur
		cPinDiv	:= cPinDiv( "EUR", dbfDivisa )
		nDinDiv	:= nDinDiv( "EUR", dbfDivisa )
	ELSE
		cPinDiv	:= cPinDiv( cCodDiv, dbfDivisa )
		nDinDiv	:= nDinDiv( cCodDiv, dbfDivisa )
	END IF

	WHILE Eval( bCondition )

		nTotalArt := nTotLAbnPrv( dbfLine, nDinDiv, nVdvDiv )

		/*
      Estudio de impuestos
		*/

		DO CASE

		CASE _NPCTIVA1 == NIL .OR. _NPCTIVA1 == (dbfLine)->NIVA
			_NPCTIVA1 	:= (dbfLine)->NIVA
			_NPCTREQ1 	:= If ( lRecargo, nPReq( dbfIva, _NPCTIVA1 ), 0 )
			_NBRTIVA1 	+= nTotalArt

		CASE _NPCTIVA2 == NIL .OR._NPCTIVA2 == (dbfLine)->NIVA
			_NPCTIVA2 	:= (dbfLine)->NIVA
			_NPCTREQ2 	:= If ( lRecargo, nPReq( dbfIva, _NPCTIVA2 ), 0 )
			_NBRTIVA2 	+= nTotalArt

		CASE _NPCTIVA3 == NIL .OR. _NPCTIVA3 == (dbfLine)->NIVA
			_NPCTIVA3 	:= (dbfLine)->NIVA
			_NPCTREQ3 	:= If ( lRecargo, nPReq( dbfIva, _NPCTIVA3 ), 0 )
			_NBRTIVA3 	+= nTotalArt

		END CASE

		(dbfLine)->( dbSkip())

	END WHILE

	( dbfLine )->( dbGoTo( nRecno) )

	/*
   Ordenamos los impuestosS de menor a mayor
	*/

	nTotalBrt	:= _NBRTIVA1 + _NBRTIVA2 + _NBRTIVA3

	/*
	Portes de la Factura
	*/

	nTotalBrt 	+= nPorte

	_NBASIVA1	:= _NBRTIVA1
	_NBASIVA2	:= _NBRTIVA2
	_NBASIVA3	:= _NBRTIVA3

	/*
	Descuentos de la Facturas
	*/

	IF nDtoEsp != 0

		aTotalDto[1]	:= Round( _NBASIVA1 * nDtoEsp / 100, 0 )
		aTotalDto[2]	:= Round( _NBASIVA2 * nDtoEsp / 100, 0 )
		aTotalDto[3]	:= Round( _NBASIVA3 * nDtoEsp / 100, 0 )

		nTotalDto		:= aTotalDto[1] + aTotalDto[2] + aTotalDto[3]

		_NBASIVA1		-= aTotalDto[1]
		_NBASIVA2		-= aTotalDto[2]
		_NBASIVA3		-= aTotalDto[3]

	END IF

	IF nDtoPP != 0

		aTotalDPP[1]	:= Round( _NBASIVA1 * nDtoPP / 100, 0 )
		aTotalDPP[2]	:= Round( _NBASIVA2 * nDtoPP / 100, 0 )
		aTotalDPP[3]	:= Round( _NBASIVA3 * nDtoPP / 100, 0 )

		nTotalDPP		:= aTotalDPP[1] + aTotalDPP[2] + aTotalDPP[3]

		_NBASIVA1		-= aTotalDPP[1]
		_NBASIVA2		-= aTotalDPP[2]
		_NBASIVA3		-= aTotalDPP[3]

	END IF

	nTotalNet			:= _NBASIVA1 + _NBASIVA2 + _NBASIVA3

	/*
   Calculos de impuestos
	*/

	nTotalIva += if ( _NPCTIVA1 != NIL, Round( _NBASIVA1 * _NPCTIVA1 / 100, nDinDiv ), 0 )
	nTotalIva += if ( _NPCTIVA2 != NIL, Round( _NBASIVA2 * _NPCTIVA2 / 100, nDinDiv ), 0 )
	nTotalIva += if ( _NPCTIVA3 != NIL, Round( _NBASIVA3 * _NPCTIVA3 / 100, nDinDiv ), 0 )

	/*
	Calculo de recargo
	*/

	nTotalReq += if ( _NPCTIVA1 != NIL, Round( _NBASIVA1 * _NPCTREQ1 / 100, nDinDiv ), 0 )
	nTotalReq += if ( _NPCTIVA2 != NIL, Round( _NBASIVA2 * _NPCTREQ2 / 100, nDinDiv ), 0 )
	nTotalReq += if ( _NPCTIVA3 != NIL, Round( _NBASIVA3 * _NPCTREQ3 / 100, nDinDiv ), 0 )

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

   nTotalEur   := nTotalFac / nChgDiv( cCodDiv, dbfDivisa )

	/*
	Si nos solicitan en euros hacemos la factura igual al Euro_________________
	*/

	IF lEur
		nTotalFac	:= nTotalEur
	END IF

	/*
	Refrescos en Pantalla____________________________________________________
	*/

	IF nFactura == nil

		IF _OIMPIVA1 != NIL .AND. _NPCTIVA1 != NIL
			_OIMPIVA1:SetText( Trans( round( _NBASIVA1 * _NPCTIVA1 / 100, nDinDiv ), cPinDiv ) )
		END IF

		IF _OIMPIVA2 != NIL .AND. _NPCTIVA2 != NIL
			_OIMPIVA2:SetText( Trans( round( _NBASIVA2 * _NPCTIVA2 / 100, nDinDiv ), cPinDiv ) )
		END IF

		IF _OIMPIVA3 != NIL .AND. _NPCTIVA3 != NIL
			_OIMPIVA3:SetText( Trans( round( _NBASIVA3 * _NPCTIVA3 / 100, nDinDiv ), cPinDiv ) )
		END IF

		/*
      Refrescamos los impuestosS
		*/

		IF _OBASIVA1 != NIL
			_OBASIVA1:SetText( Trans( _NBASIVA1, cPinDiv ) )
		END IF

		IF _OBASIVA2 != NIL
			_OBASIVA2:SetText( Trans( _NBASIVA2, cPinDiv ) )
		END IF

		IF _OBASIVA3 != NIL
			_OBASIVA3:SetText( Trans( _NBASIVA3, cPinDiv ) )
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

		IF _OIMPREQ1 != NIL .AND. lRecargo
			_OIMPREQ1:SetText( Trans( round( _NBASIVA1 * _NPCTREQ1 / 100, nDinDiv ), cPinDiv ) )
		ELSE
			_OIMPREQ1:SetText( 0 )
		END IF

		IF _OIMPREQ2 != NIL .AND. lRecargo
			_OIMPREQ2:SetText( Trans( round( _NBASIVA2 * _NPCTREQ2 / 100, nDinDiv ), cPinDiv ) )
		ELSE
			_OIMPREQ2:SetText( 0 )
		END IF

		IF _OIMPREQ3 != NIL .AND. lRecargo
			_OIMPREQ3:SetText( Trans( round( _NBASIVA3 * _NPCTREQ3 / 100, nDinDiv ), cPinDiv ) )
		ELSE
			_OIMPREQ3:SetText( 0 )
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
			oGetNet:SetText( Trans( nTotalNet, cPinDiv ) )
		END IF

		IF oGetIva != NIL
			oGetIva:SetText( Trans( nTotalIva, cPinDiv ) )
		END IF

		IF oGetReq != NIL
			oGetReq:SetText( Trans( nTotalReq, cPinDiv ) )
		END IF

		IF oGetTotal != NIL
			oGetTotal:SetText( Trans( nTotalFac, cPinDiv ) )
		END IF

		IF oGetTotEur != NIL
			oGetTotEur:SetText( nTotalEur )
		END IF

		IF oGetTotal != NIL
			oGetTotal:SetText( Trans( nTotalFac, cPinDiv ) )
		END IF

	END IF

RETURN ( if( lPic, Trans( nTotalFac, cPinDiv ), nTotalFac ) )

//--------------------------------------------------------------------------//

FUNCTION nTotAbnPrv( nAbono, dbfAbnPrvT, dbfLine, dbfIva, dbfDivisa, aTmp, lEur, lPic )

RETURN nTotal( nAbono, dbfAbnPrvT, dbfLine, dbfIva, dbfDivisa, aTmp, lEur, lPic )

//--------------------------------------------------------------------------//

STATIC FUNCTION lMoreIva( nCodIva )

	/*
	Si no esta dentro de los porcentajes anteriores
	*/

	IF _NPCTIVA1 == NIL .OR. _NPCTIVA2 == NIL .OR. _NPCTIVA3 == NIL
		RETURN .T.
	END IF

	IF _NPCTIVA1 == nCodIva .OR. _NPCTIVA2 == nCodIva .OR. _NPCTIVA3 == nCodIva
		RETURN .T.
	END IF

   MsgStop( "Abono con mas de 3 tipos de " + cImp(), "Imposible añadir" )

RETURN .F.

//---------------------------------------------------------------------------//

STATIC FUNCTION lStudyIva( nPctIva, nPctReq, NBASIva )

	/*
	Si no esta dentro de los porcentajes anteriores
	*/

	DO CASE
		CASE _NPCTIVA1 == 0 .OR. _NPCTIVA1 == nPctIva
			_OPCTIVA1:cText( nPctIva )
			_NPCTREQ1 = nPctReq

			IF NBASIva != NIL
				_NBASIVA1 += NBASIva
			END IF

		CASE _NPCTIVA2 == 0 .OR. _NPCTIVA2 == nPctIva
			_OPCTIVA2:cText( nPctIva )
			_NPCTREQ2 = nPctReq

			IF NBASIva != NIL
				_NBASIVA2 += NBASIva
			END IF

		CASE _NPCTIVA3 == 0 .OR. _NPCTIVA3 == nPctIva
			_OPCTIVA3:cText( nPctIva )
			_NPCTREQ3 = nPctReq

			IF NBASIva != NIL
				_NBASIVA3 += NBASIva
			END IF

		OTHERWISE
         MsgStop( "Abono con mas de 3 Tipos de " + cImp(), "Imposible Añadir")
			RETURN .F.

	END CASE

RETURN .T.

//---------------------------------------------------------------------------//

STATIC FUNCTION LoaPrv( aGet, aTmp )

	local cAreaAnt := Alias()
	local lValid 	:= .F.
	local xValor 	:= aGet[_CCODPRV]:varGet()

	IF empty( xValor )
		RETURN .T.
	ELSEIF At( ".", xValor ) != 0
		xValor := PntReplace( aGet[_CCODPRV], "0", RetNumCodPrvEmp() )
	ELSE
		xValor := Rjust( xValor, "0", RetNumCodPrvEmp() )
	END IF

	IF ( dbfPrv )->( dbSeek( xValor ) )

		aGet[_CCODPRV]:cText( ( dbfPrv )->COD )
		aGet[_CNOMPRV]:cText( ( dbfPrv )->TITULO )
      aGet[_CCODPAGO]:cText( (dbfPrv)->FPAGO  )

		if Empty( aGet[_CDIRPRV]:varGet() )
			aGet[_CDIRPRV]:cText( ( dbfPrv )->DOMICILIO )
		endif

		if Empty( aGet[_CPOBPRV]:varGet() )
			aGet[_CPOBPRV]:cText( ( dbfPrv )->POBLACION )
		endif

		if Empty( aGet[_CPRVPRV]:varGet() )
			aGet[_CPRVPRV]:cText( ( dbfPrv )->PROVINCIA )
		endif

		if Empty( aGet[_CPOSPRV]:varGet() )
			aGet[_CPOSPRV]:cText( ( dbfPrv )->CODPOSTAL )
		endif

		if Empty( aGet[_CDNIPRV]:varGet() )
			aGet[_CDNIPRV]:cText( ( dbfPrv )->NIF )
		endif

		lValid	:= .T.

	ELSE

		msgStop( "Proveedor no encontrado" )

	END IF

	IF ( cAreaAnt != "",	SELECT( cAreaAnt ), )

RETURN lValid

//----------------------------------------------------------------------------//

STATIC FUNCTION LoadArt( aGet, oGet )

	local cAreaAnt := Alias()
	local lValid   := .F.
	local xValor   := aGet[_CREF]:varGet()

	IF Empty( xValor )

		aGet[_NIVA    ]:cText( 0 )
		aGet[_NIVA    ]:bWhen	:= {|| .t. }
		aGet[_CREF    ]:hide()
		aGet[_CDETALLE]:hide()
		aGet[_MLNGDES ]:show()

		lValid := .T.

	ELSE

      IF lModIva()
			aGet[_NIVA ]:bWhen	:= {|| .t. }
		ELSE
			aGet[_NIVA ]:bWhen	:= {|| .f. }
		END IF
		aGet[_CREF    ]:show()
		aGet[_CDETALLE]:show()
		aGet[_MLNGDES ]:hide()

		IF ( dbfArticulo )->( dbSeek( xValor ) )

			aGet[_CREF]:cText( (dbfArticulo)->CODIGO )

			IF aGet[_NUNICAJA] != NIL
				aGet[_NUNICAJA]:cText( (dbfArticulo)->NUNICAJA )
			END IF

			IF aGet[_CUNIDAD] != NIL
				aGet[_CUNIDAD]:cText( (dbfArticulo)->CUNIDAD )
			END IF

			IF aGet[_NPREUNIT] != NIL
				aGet[_NPREUNIT]:cText( (dbfArticulo)->PVENTA1 )
			END IF

			IF aGet[_NIVA] != NIL
				aGet[_NIVA]:cText( nIva( dbfIva, (dbfArticulo)->TIPOIVA ) )
			END IF

			aGet[_CDETALLE]:cText( (dbfArticulo)->NOMBRE )
			aGet[_CDETALLE]:bWhen	:= {|| .F. }

			IF oGet != NIL
				oGet:cText( (dbfArticulo )->PCOSTO )
			END IF

			lValid	:= .T.

		ELSE

			MsgStop( "Articulo no encontrado" )
			lValid 	:= .F.

		END IF

	END IF

	IF cAreaAnt != ""
		SELECT( cAreaAnt )
	END IF

RETURN lValid

//--------------------------------------------------------------------------//

STATIC FUNCTION SaveAbnPrv( aTmp, nMode )

	local cAliCount

	IF nMode == APPD_MODE

      USE ( cPatEmp() + "COUNT.DBF" ) NEW VIA ( cDriver() )ALIAS ( cCheckArea( "COUNT", @cAliCount ) )
		(cAliCount)->NABNPRV := aTmp[_NNUMFAC] + 1
		CLOSE ( cAliCount )

	END IF

RETURN .T.

//--------------------------------------------------------------------------//

STATIC FUNCTION EPage( oInf )

	local cAliColum
	local cAliBmp
	local cText
	local nRow
	local nCol
	local bCondition

	private cDbf			:= dbfAbnPrvT
	private cDetalle  	:= dbfAbnPrvL
	private cProvee		:= dbfPrv
	private cFPago			:= dbfFPago
	private cIva			:= dbfIva
	private aImpVcto		:= aImpVto
	private aTotIva		:= aIva
	private nTotBrt		:= nTotalBrt
	private nTotDto		:= nTotalDto
	private nTotDpp		:= nTotalDpp
	private nTotNet		:= nTotalNet
	private nTotIva		:= nTotalIva
	private nTotReq		:= nTotalReq
	private nTotFac		:= nTotalFac
	private nTotImp		:= nTotalImp
	private nPagina		:= oInf:nPage
	private lEnd			:= oInf:lFinish

	/*
	Ahora montamos los Items
	-------------------------------------------------------------------------
	*/

	PrintItems( "NP1", oInf )

RETURN NIL

//--------------------------------------------------------------------------//

/*
Realiza asientos en Contaplus, partiendo de la factura
*/

STATIC FUNCTION TransAbono( oBrw )

	local n
	local nIva
	local nReq
	local nAsiento
	local cCtaVent
	local nPosicion
	local nPosIva
	local dFecha
	local ptaDebe
	local cConcepto
	local cPago
	local nFactura
	local cArea
	local cSubCtaIva
	local cSubCtaReq
	local aIva			:= {}
	local aReq			:= {}
	local aVentas		:= {}
	local aDtos			:= {}
	local cCtaPrv		:= cPRVCta( (dbfAbnPrvT)->CCODPRV )
	local cCtaPrvVta	:= aIni()[CTAABNPROVEEDOR]	// cPRVCtaVta( (dbfAbnPrvT)->CCODPRV )
	local cFactura		:= (dbfAbnPrvT)->NNUMFAC

	/*
	Chequando antes de pasar a Contaplus
	--------------------------------------------------------------------------
	*/

	IF (dbfAbnPrvT)->LCONTAB
		MsgStop( "Abono Contabilizado" )
		RETURN .F.
	END IF

	/*
	Chequeamos todos los valores
	--------------------------------------------------------------------------
	*/

   IF !ChkSubcuenta( cRutCnt(), aIni()[CODEMPRESA], cCtaPRV, , .F. )
		MsgStop( "SubCuenta " + cCtaPRV + " no encontada", "Contaplus" )
		RETURN .F.
	END IF

	/*
	Estudio de los Articulos de una factura
	--------------------------------------------------------------------------
	*/

   USE ( cPatEmp() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @cArea ) )
   SET ADSINDEX TO ( cPatEmp() + "ARTICULO.CDX" ) ADDITIVE

	IF (dbfAbnPrvL)->( DbSeek( cFactura ) )

		WHILE ( (dbfAbnPrvL)->NNUMFAC = cFactura )

         cCtaVent    := RetGrpVta( (dbfAbnPrvL)->CREF, cArea )
			nPosicion 	:= aScan( aVentas, {|x| x[1] == cCtaPrvVta + cCtaVent } )
			nImpDeta		:= nCalcDeta( dbfAbnPrvL )

			IF nPosicion == 0
				aadd( aVentas, { cCtaPrvVta + cCtaVent, nImpDeta } )
			ELSE
				aVentas[ nPosicion, 2 ] += nImpDeta
			END IF

			/*
         Construimos las bases de los impuestosS
			--------------------------------------------------------------------
			*/

			nPosIva	:= aScan( aIva, {|x| x[1] == (dbfAbnPrvL)->NIVA } )

			IF nPosIva == 0
				aadd( aIva, { (dbfAbnPrvL)->NIVA, nImpDeta } )
			ELSE
				aIva[ nPosIva, 2 ] += nImpDeta
			END IF

			(dbfAbnPrvL)->(DbSkip())

		END WHILE

		CLOSE ( cArea )

	ELSE

		MsgStop( "Abono sin Articulos", "Contaplus" )
		CLOSE ( cArea )
		RETURN .F.

	END IF

   /*
	Descuentos sobres grupos de Venta
	--------------------------------------------------------------------------
	*/

	IF (dbfAbnPrvT)->NDTOESP != 0

		FOR n := 1 TO Len( aVentas )
			aVentas[ n, 2 ] -= Round( aVentas[ n, 2 ] * (dbfAbnPrvT)->NDTOESP / 100, 0 )
			IF (dbfAbnPrvT)->NDPP != 0
				aVentas[ n, 2 ] -= Round( aVentas[ n, 2 ] * (dbfAbnPrvT)->NDPP / 100, 0 )
			END IF
		NEXT

	END IF

   /*
   Descuentos sobres grupos de impuestos
	--------------------------------------------------------------------------
	*/

	IF (dbfAbnPrvT)->NDTOESP != 0
		FOR n := 1 TO Len( aIva )
			aIva[ n, 2 ] -= Round( aIva[ n, 2 ] * (dbfAbnPrvT)->NDTOESP / 100, 0 )

			IF (dbfAbnPrvT)->NDPP != 0
				aIva[ n, 2 ]	-= Round( aIva[ n, 2 ] * (dbfAbnPrvT)->NDPP / 100, 0 )
			END IF

		NEXT
	END IF

	/*
	Chequeo de Cuentas de Ventas
	--------------------------------------------------------------------------
	*/

	FOR n := 1 TO len( aVentas )
      IF !ChkSubcuenta( cRutCnt(), aIni()[CODEMPRESA], aVentas[n,1], , .F. )
			MsgStop( "SubCuenta " + aVentas[n,1] + " no encontada", "Contaplus" )
			RETURN .F.
		END IF
	NEXT

	/*
   Chequeo de Cuentas de impuestos
	--------------------------------------------------------------------------
	*/

	FOR n := 1 TO len( aIva )

		cSubCtaIva	:= RetCtaEsp( 2 ) + RJust( aIva[ n, 1 ], "0", 2 )

		IF (dbfAbnPrvT)->LRECARGO
			nReq		:= nPReq( dbfIva, aIva[ n, 1 ] )

			IF nReq	< 1
				nReq	:= nReq * 10
			END IF

			cSubCtaIva	+= RJust( nReq, "0", 2 )

		ELSE
			cSubCtaIva	+= "00"

		END IF

		IF !ChkSubcuenta( , , cSubCtaIva, , .F. )
			MsgStop( "SubCuenta " + cSubCtaIva + " no encontada", "Contaplus" )
			RETURN .F.
		END IF
	NEXT

	/*
	Chequeo de Cuentas de Recargo de Eqivalencia
	--------------------------------------------------------------------------
	*/

	IF (dbfAbnPrvT)->LRECARGO

		FOR n := 1 TO len( aIva )

			cSubCtaReq	:= RetCtaEsp( 3 ) + RJust( nReq, "0", 4 )

         IF !ChkSubcuenta( , , cSubCtaReq, , .f. )
				MsgStop( "SubCuenta " + RTrim( cSubCtaReq ) + " no encontada", "Contaplus" )
				RETURN .F.
			END IF
		NEXT

   END IF

	/*
	Datos comunes a todos los Asientos
	--------------------------------------------------------------------------
	*/

	dFecha	:= (dbfAbnPrvT)->DFECFAC
	ptaDebe	:= nTotAbnPrv( dbfAbnPrvT, dbfAbnPrvL, dbfIva, nFactura )
	cConcepto:= "Ntro. Abono N." + AllTrim( Str( (dbfAbnPrvT)->NNUMFAC ) )
	nFactura	:= (dbfAbnPrvT)->NNUMFAC

	/*
	Realizaci¢n de Asientos
	--------------------------------------------------------------------------
	==========================================================================
	*/

	OpenDiario()

	nAsiento	:= contaplusUltimoAsiento()

	MkAsiento( nAsiento,;
               cCodDiv,;
					dFecha,;
					cCtaPrv,;
					,;
					ptaDebe,;
					cConcepto,;
					,;
					nFactura )

	/*
	Asientos de Ventas
	-------------------------------------------------------------------------
	*/

	FOR n := 1 TO len( aVentas )
		MkAsiento( nAsiento, ;
                  cCodDiv,;
						dFecha, ;
						aVentas[n,1],;
						,;
						,;
						cConcepto,;
						aVentas[n,2],;
						nFactura )
	NEXT

	/*
   Asientos de impuestos
	--------------------------------------------------------------------------
	*/

	FOR n := 1 TO len( aIva )
		nIva 			:= Round( aIva[n,1] * aIva[n,2] / 100, 0 )
		cSubCtaIva	:= RetCtaEsp( 2 ) + RJust( aIva[ n, 1 ], "0", 2 )

		IF (dbfAbnPrvT)->LRECARGO
			nReq		:= nPReq( dbfIva, aIva[ n, 1 ] )

			IF nReq	< 1
				nReq	:= nReq * 10
			END IF

			cSubCtaIva	+= RJust( nReq, "0", 2 )

		ELSE
			cSubCtaIva	+= "00"

		END IF

      MkAsiento(  nAsiento, ;
                  cCodDiv,;
						dFecha, ;
                  cSubCtaIva,;   // Cuenta de impuestos
						cCtaPrv,;		// Contrapartida
						,; 				// Ptas. Debe
						cConcepto,;
						nIva,;			// Ptas. Haber
						nFactura,;
						aIva[n,2],;
						aIva[n,1],;
						If( (dbfAbnPrvT)->LRECARGO, nPReq( dbfIva, aIva[n,1] ), 0 ) )
	NEXT

	/*
	Asientos del Recargo
	-------------------------------------------------------------------------
	*/

	IF (dbfAbnPrvT)->LRECARGO

		FOR n := 1 TO len( aIva )

			cSubCtaReq	:= RetCtaEsp( 3 )
			nReq			:= nPReq( dbfIva, aIva[ n, 1 ] )

			IF nReq	< 1
				nReq	:= nReq * 10
			END IF

			cSubCtaReq	+=	RJust( nReq, "0", 4 )

         MkAsiento(  nAsiento,;
                     cCodDiv,;
							dFecha,;
							cSubCtaReq,;
							,;
							,;
							cConcepto,;
							nReq,;
							nFactura )
		NEXT

	END IF

	/*
	Ponemos la factura como Contabilizada
	--------------------------------------------------------------------------
	*/

   dbDialogLock(dbfAbnPrvT)
	(dbfAbnPrvT)->LCONTAB	:= .T.

   msgStop(   "Asiento Satisfactiriamente Generado" + CRLF + CRLF +;
               "Número de Asiento : " + Str( nAsiento ),;
					"Contaplus" )
	oBrw:refresh()

	CloseDiario()

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION mkAbnPrv( cPath, oMeter, nLenCodPrv )

	IF oMeter != NIL
		oMeter:cText	:= "Generando Bases"
		sysrefresh()
	END IF

	CreateFiles( cPath, nLenCodPrv )

	rxAbnPrv( cPath, oMeter )

RETURN NIL

//---------------------------------------------------------------------------//

FUNCTION rxAbnPrv( cPath, oMeter )

	local dbfAbnPrvT
	local nEvery

   DEFAULT cPath  := cPatEmp()

   IF !File( cPath + "ABNPRVT.DBF" ) .OR. ;
      !File( cPath + "ABNPRVL.DBF" )
		CreateFiles( cPath, RetNumCodPrvEmp() )
	END IF

	/*
	Eliminamos los indices
	*/

   fErase( cPath + "ABNPRVT.CDX" )
   fErase( cPath + "ABNPRVL.CDX" )

   dbUseArea( .t., cDriver(), cPath + "ABNPRVT.DBF", cCheckArea( "ABNPRVT", @dbfAbnPrvT ) )

	IF oMeter != NIL
		oMeter:nTotal 	:= ( dbfAbnPrvT )->( LastRec() ) + 1
		nEvery         := Int( oMeter:nTotal / 10 )
      oMeter:cText  := "1 Abn. Prov."
      ordCondSet( "!Deleted()", {||!Deleted()},,, {|| oMeter:Set( ( dbfAbnPrvT )->( RecNo() ) ), sysrefresh() }, nEvery, ( dbfAbnPrvT )->( RecNo() ), )
   ELSE
      ordCondSet( "!Deleted()", {||!Deleted()} )
	END IF

   ordCreate( cPath + "ABNPRVT.CDX", "NNUMFAC", "STR( NNUMFAC ) + CSUFFAC", {|| STR( NNUMFAC ) + CSUFFAC } )

	IF oMeter != NIL
      oMeter:cText  := "2 Abn. Prov."
      ordCondSet( "!Deleted()", {||!Deleted()},,, {|| oMeter:Set( ( dbfAbnPrvT )->( RecNo() ) ), sysrefresh() }, nEvery, ( dbfAbnPrvT )->( RecNo() ), )
   ELSE
      ordCondSet( "!Deleted()", {||!Deleted()} )
   END IF

   ordCreate( cPath + "ABNPRVT.CDX", "DFECFAC", "DFECFAC", {|| DFECFAC } )

	IF oMeter != NIL
      oMeter:cText  := "3 Abn. Prov."
      ordCondSet( "!Deleted()", {||!Deleted()},,, {|| oMeter:Set( ( dbfAbnPrvT )->( RecNo() ) ), sysrefresh() }, nEvery, ( dbfAbnPrvT )->( RecNo() ), )
   ELSE
      ordCondSet( "!Deleted()", {||!Deleted()} )
   END IF

   ordCreate( cPath + "ABNPRVT.CDX", "CCODPRV", "CCODPRV", {|| CCODPRV } )

	( dbfAbnPrvT )->( ordListRebuild() )
	( dbfAbnPrvT )->( dbCloseArea() )

   dbUseArea( .t., cDriver(), cPath + "ABNPRVL.DBF", cCheckArea( "ABNPRVL", @dbfAbnPrvT ) )

	IF oMeter != NIL
		oMeter:nTotal 	:= ( dbfAbnPrvT )->( LastRec() ) + 1
		nEvery         := Int( oMeter:nTotal / 10 )
      oMeter:cText  := "4 Abn. Prov."
      ordCondSet( "!Deleted()", {||!Deleted()},,, {|| oMeter:Set( ( dbfAbnPrvT )->( RecNo() ) ), sysrefresh() }, nEvery, ( dbfAbnPrvT )->( RecNo() ), )
   ELSE
      ordCondSet( "!Deleted()", {||!Deleted()} )
   END IF

   ordCreate( cPath + "ABNPRVL.CDX", "NNUMFAC", "STR( NNUMFAC ) + CSUFFAC", {|| STR( NNUMFAC ) + CSUFFAC }, )

	( dbfAbnPrvT )->( ordListRebuild() )
	( dbfAbnPrvT )->( dbCloseArea() )

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION nCalcDeta( dbfDetalle )

	local nCalculo

	nCalculo := (dbfDetalle)->NPREUNIT ;
					* (dbfDetalle)->NUNICAJA ;
					* If( (dbfDetalle)->NCANENT != 0, (dbfDetalle)->NCANENT, 1 )

	IF (dbfDetalle)->NDTO != 0
		nCalculo -= nCalculo * (dbfDetalle)->NDTO / 100
	END IF

RETURN ( nCalculo )

//---------------------------------------------------------------------------//

STATIC FUNCTION BeginTrans( aTmp )

   local cDbf     := "FABNL"
	local nFactura	:= Str( aTmp[_NNUMFAC] ) + aTmp[_CSUFFAC]

   cNewFile       := cGetNewFileName( cPatTmp() + cDbf )

	/*
	Primero Crear la base de datos local
	*/

   dbCreate( cNewFile, aBase2, cDriver() )
   dbUseArea( .t., cDriver(), cNewFile, cCheckArea( cDbf, @dbfTmp ), .f. )

	/*
	A¤adimos desde el fichero de lineas
	*/

	IF ( dbfAbnPrvL )->( DbSeek( nFactura ) )

		DO WHILE ( Str( ( dbfAbnPrvL )->NNUMFAC ) + ( dbfAbnPrvL )->CSUFFAC == nFactura .AND. !( dbfAbnPrvL )->( eof() ) )

			( dbfTmp )->( dbAppend() )
         dbPass( dbfAbnPrvL, dbfTmp )
			( dbfAbnPrvL )->( DbSkip() )

		END WHILE

	END IF

	( dbfTmp )->( dbGoTop() )

RETURN NIL

//-----------------------------------------------------------------------//

STATIC FUNCTION EndTrans( aTmp, oBrw, nMode )

	local nItem
	local aTabla
	local cAlmacen
	local nFactura		:= aTmp[_NNUMFAC]
	local cSufFac		:= aTmp[_CSUFFAC]

	/*
	Primero hacer el RollBack
	*/

	WatMet( oMetMsg, dbfTmp, "Archivando" )

	/*
	RollBack en edici¢n de registros
	*/

	IF nMode == EDIT_MODE

		IF ( dbfAbnPrvL )->( dbSeek( Str( nFactura ) + cSufFac ) )

			BackStock( 	(dbfAbnPrvT)->CCODALM,;
							dbfAbnPrvL,;
							{|| Str( ( dbfAbnPrvL )->NNUMFAC ) + ( dbfAbnPrvL )->CSUFFAC == Str( nFactura ) + cSufFac },;
							_SUMA,;
							_ELIMINA,;
							dbfArticulo,;
							dbfMov )

		END IF

	END IF

	/*
	Ahora escribimos en el fichero definitivo
	*/

	IF nMode == APPD_MODE
		nFactura := aTmp[_dNNUMFAC] := NewAbnPrv()
	END IF

	( dbfTmp )->( DbGoTop() )

   do while !( dbfTmp )->( eof() )

		aTabla 				:= dbScatter( dbfTmp )
		aTabla[_dNNUMFAC] := nFactura
		aTabla[_dCSUFFAC] := cSufFac

		( dbfAbnPrvL )->( dbAppend() )
		dbGather( aTabla, dbfAbnPrvL )
		( dbfTmp )->( dbSkip() )

   end while

	IF (dbfAbnPrvL)->( DbSeek( Str( nFactura ) + cSufFac ) )

		BackStock( 	(dbfAbnPrvT)->CCODALM,;
						dbfAbnPrvL,;
						{|| Str( ( dbfAbnPrvL )->NNUMFAC ) + ( dbfAbnPrvL )->CSUFFAC == Str( nFactura ) + cSufFac },;
						_RESTA,;
						_NOELIMINA,;
						dbfArticulo,;
						dbfMov )
	END IF

	/*
	Borramos los ficheros
	*/

	oBrw:lCloseArea()
   dbfErase( cNewFile )

	endMet( oMetMsg )

RETURN .T.

//------------------------------------------------------------------------//

STATIC FUNCTION KillTrans( oBrw2 )

	( dbfTmp )->( dbCloseArea() )
   dbfErase( cNewFile )

   oBrw2:CloseData()

RETURN NIL

//------------------------------------------------------------------------//

FUNCTION AppAbnPrv( dbfAbnPro, dbfAbnProDet, dbfPro, dbfPago, dbfTIva, oBrw )

	local cAreaAnt
	local cAreaPro
	local oldAbnPrvT	:= dbfAbnPrvT
	local oldAbnPrvL	:= dbfAbnPrvL
	local oldPrv		:= dbfPrv
	local oldIva		:= dbfIva
	local oldFPago		:= dbfFPago

	dbfAbnPrvT			:= dbfAbnPro
	dbfAbnPrvL			:= dbfAbnProDet
	dbfPrv				:= dbfPro
	dbfFPago				:= dbfPago
	dbfIva				:= dbfTIva

	cAreaPro				:= ( dbfPrv )->( OrdSetFocus( 1 ) )
	cAreaAnt				:= ( dbfAbnPrvT )->( OrdSetFocus( 1 ) )

	WinAppRec( nil, bEdit, dbfAbnPrvT, nil , nil, dbfAbnPrvL )

	( dbfAbnPrvT )->( OrdSetFocus( cAreaAnt ) )
	( dbfPrv )->( OrdSetFocus( cAreaPro ) )

	IF oBrw != NIL
		oBrw:refresh()
	END IF

	dbfAbnPrvT 		:= oldAbnPrvT
	dbfAbnPrvL 		:= oldAbnPrvL
	dbfPrv 			:= oldPrv
	dbfIva 			:= oldIva
	dbfFPago 		:=	oldFPago

RETURN NIL

//----------------------------------------------------------------------------//

FUNCTION EdtAbnPrv( dbfAbnPro, dbfAbnProDet, dbfPro, dbfPago, dbfTIva, oBrw )

	local cAreaAnt
	local cAreaPro
	local oldAbnPrvT	:= dbfAbnPrvT
	local oldAbnPrvL	:= dbfAbnPrvL
	local oldPrv		:= dbfPrv
	local oldIva		:= dbfIva
	local oldFPago		:= dbfFPago

	dbfAbnPrvT			:= dbfAbnPro
	dbfAbnPrvL			:= dbfAbnProDet
	dbfPrv				:= dbfPro
	dbfFPago				:= dbfPago
	dbfIva				:= dbfTIva

	cAreaPro				:= ( dbfPrv )->( OrdSetFocus( 1 ) )
	cAreaAnt				:= ( dbfAbnPrvT )->( OrdSetFocus( 1 ) )

	WinEdtRec( nil, bEdit, dbfAbnPrvT, nil , nil, dbfAbnPrvL )

	( dbfAbnPrvT )->( OrdSetFocus( cAreaAnt ) )
	( dbfPrv )->( OrdSetFocus( cAreaPro ) )

	IF oBrw != NIL
		oBrw:refresh()
	END IF

	dbfAbnPrvT 		:= oldAbnPrvT
	dbfAbnPrvL 		:= oldAbnPrvL
	dbfPrv 			:= oldPrv
	dbfIva 			:= oldIva
	dbfFPago 		:=	oldFPago

RETURN NIL

//----------------------------------------------------------------------------//

FUNCTION ZooAbnPrv( dbfAbnPro, dbfAbnProDet, dbfPro, dbfPago, dbfTIva, oBrw )

	local cAreaAnt
	local cAreaPro
	local oldAbnPrvT	:= dbfAbnPrvT
	local oldAbnPrvL	:= dbfAbnPrvL
	local oldPrv		:= dbfPrv
	local oldIva		:= dbfIva
	local oldFPago		:= dbfFPago

	dbfAbnPrvT			:= dbfAbnPro
	dbfAbnPrvL			:= dbfAbnProDet
	dbfPrv				:= dbfPro
	dbfFPago				:= dbfPago
	dbfIva				:= dbfTIva

	cAreaPro				:= ( dbfPrv )->( OrdSetFocus( 1 ) )
	cAreaAnt				:= ( dbfAbnPrvT )->( OrdSetFocus( 1 ) )

	WinZooRec( nil, bEdit, dbfAbnPrvT, nil , nil, dbfAbnPrvL )

	( dbfAbnPrvT )->( OrdSetFocus( cAreaAnt ) )
	( dbfPrv )->( OrdSetFocus( cAreaPro ) )

	IF oBrw != NIL
		oBrw:refresh()
	END IF

	dbfAbnPrvT 		:= oldAbnPrvT
	dbfAbnPrvL 		:= oldAbnPrvL
	dbfPrv 			:= oldPrv
	dbfIva 			:= oldIva
	dbfFPago 		:=	oldFPago

RETURN NIL

//----------------------------------------------------------------------------//

FUNCTION DelAbnPrv( dbfAbnPro, dbfAbnProDet, dbfPro, dbfPago, dbfTIva, oBrw )

	local cAreaAnt
	local cAreaPro
	local oldAbnPrvT	:= dbfAbnPrvT
	local oldAbnPrvL	:= dbfAbnPrvL
	local oldPrv		:= dbfPrv
	local oldIva		:= dbfIva
	local oldFPago		:= dbfFPago

	dbfAbnPrvT			:= dbfAbnPro
	dbfAbnPrvL			:= dbfAbnProDet
	dbfPrv				:= dbfPro
	dbfFPago				:= dbfPago
	dbfIva				:= dbfTIva

	cAreaPro				:= ( dbfPrv )->( OrdSetFocus( 1 ) )
	cAreaAnt				:= ( dbfAbnPrvT )->( OrdSetFocus( 1 ) )

	DBDelRec(  nil, dbfAbnPrvT, {|| DelDetalle( (dbfAbnPrvT)->NNUMABN ) } )

	( dbfAbnPrvT )->( OrdSetFocus( cAreaAnt ) )
	( dbfPrv )->( OrdSetFocus( cAreaPro ) )

	IF oBrw != NIL
		oBrw:refresh()
	END IF

	dbfAbnPrvT 		:= oldAbnPrvT
	dbfAbnPrvL 		:= oldAbnPrvL
	dbfPrv 			:= oldPrv
	dbfIva 			:= oldIva
	dbfFPago 		:=	oldFPago

RETURN NIL

//----------------------------------------------------------------------------//

FUNCTION PrnAbnPrv( dbfAbnPro, dbfAbnProDet, dbfPro, dbfPago, dbfTIva, oBrw )

	local cAreaAnt
	local cAreaPro
	local oldAbnPrvT	:= dbfAbnPrvT
	local oldAbnPrvL	:= dbfAbnPrvL
	local oldPrv		:= dbfPrv
	local oldIva		:= dbfIva
	local oldFPago		:= dbfFPago

	dbfAbnPrvT			:= dbfAbnPro
	dbfAbnPrvL			:= dbfAbnProDet
	dbfPrv				:= dbfPro
	dbfFPago				:= dbfPago
	dbfIva				:= dbfTIva

	cAreaPro				:= ( dbfPrv )->( OrdSetFocus( 1 ) )
	cAreaAnt				:= ( dbfAbnPrvT )->( OrdSetFocus( 1 ) )

	GenAbono()

	( dbfAbnPrvT )->( OrdSetFocus( cAreaAnt ) )
	( dbfPrv )->( OrdSetFocus( cAreaPro ) )

	IF oBrw != NIL
		oBrw:refresh()
	END IF

	dbfAbnPrvT 		:= oldAbnPrvT
	dbfAbnPrvL 		:= oldAbnPrvL
	dbfPrv	 		:= oldPrv
	dbfIva 			:= oldIva
	dbfFPago 		:=	oldFPago

RETURN NIL

//----------------------------------------------------------------------------//

STATIC FUNCTION CreateFiles( cPath )

   dbCreate( cPath + "ABNPRVT.DBF", aBase1, cDriver() )
   dbCreate( cPath + "ABNPRVL.DBF", aBase2, cDriver() )

RETURN NIL

//----------------------------------------------------------------------------//


/*
Cambia el estado de un pedido
*/

STATIC FUNCTION ChgState( oBrw )

   dbDialogLock( dbfAbnPrvT )
	( dbfAbnPrvT )->LCONTAB := !( dbfAbnPrvT )->LCONTAB
	( dbfAbnPrvT )->( dbUnlock() )
	oBrw:setFocus()

RETURN NIL

//-------------------------------------------------------------------------//