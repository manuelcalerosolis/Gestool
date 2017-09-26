#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//----------------------------------------------------------------------------//

CLASS TDepAge FROM TMASDET

   DATA  oBan
   DATA  oDbfIva
   DATA  oDbfFPgo
   DATA  oDbfAlm
   DATA  oDbfTarPreL
   DATA  oDbfPrmT
   DATA  oDbfArt
   DATA  oDbfArt
   DATA  oDbfKit

   DATA  lEuro

   DATA  aoIva
   DATA  anIva

   METHOD OpenFiles()

   METHOD Resource( nMode )

   METHOD Detalle( nMode )

   METHOD CloseFiles()

   METHOD nTotUndLin( oDbf )     INLINE   ( NotCaja( oDbf:nCanEnt ) * oDbf:nUniCaja )

   METHOD nTotLin( oDbf )

END CLASS

//----------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive )

   DEFAULT  lExclusive  := .f.

   ::oDbf:Activate( .f., !( lExclusive ), .f., .f. )

   ::oDbfDetalle:Activate( .f., !( lExclusive ), .f., .f. )

   DATABASE NEW ::oDbfIva  PATH ( cPatEmp() ) FILE "TIVA.DBF"  VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   DATABASE NEW ::oDbfFPgo PATH ( cPatEmp() ) FILE "FPAGO.DBF" VIA ( cDriver() ) SHARED INDEX "FPAGO.CDX"

   DATABASE NEW ::oDbfAlm  PATH ( cPatAlm() ) FILE "ALMACEN.DBF" VIA ( cDriver() ) SHARED INDEX "ALMACEN.CDX"

   DATABASE NEW ::oDbfTarPreL PATH ( cPatArt() ) FILE "TARPREL.DBF" VIA ( cDriver() ) SHARED INDEX "TARPREL.CDX"

   DATABASE NEW ::oDbfPrmT PATH ( cPatArt() ) FILE "PROMOT.DBF" VIA ( cDriver() ) SHARED INDEX "PROMOT.CDX"

   DATABASE NEW ::oDbfArt  PATH ( cPatArt() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   DATABASE NEW ::oDbfDiv  PATH ( cPatEmp() ) FILE "DIVISAS.DBF" VIA ( cDriver() ) SHARED INDEX "DIVISAS.CDX"

   DATABASE NEW ::oDbfKit  PATH ( cPatArt() ) FILE "ARTKIT.DBF"  VIA ( cDriver() ) SHARED INDEX "ARTKIT.CDX"

   /*
   Objetos --------------------------------------------------------------------
   */

   ::oBan            := TBandera():New

   ::oStock          := TStock():Create()
   if !::oStock:lOpenFiles()
      lOpen          := .f.
   else
   ::oStock:cDepAgeT := ::oDbf:cAlias
   ::oStock:cDepAgeL := ::oDbfDetalle:cAlias
   ::oStock:cKit     := ::oDbfKit:cAlias
   end if

   ::lEuro           := .f.

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD CloseFiles()

   ::oDbf:End()
   ::oDbfDetalle:End()
   ::oDbfIva:End()
   ::oDbfFPgo:End()
   ::oDbfAlm:End()
   ::oDbfTarPreL:End()
   ::oDbfPrmT:End()
   ::oDbfArt:End()
   ::oDbfArt:End()
   ::oDbfDiv:End()
   ::oDbfKit:End()
   ::oBan:End()
   ::oStock:End()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Activate()

   local oBtnEur

   ::CreateShell( nLevel )

   ::oWndBrw:GralButtons( Self )

   DEFINE BTNSHELL RESOURCE "CHGSTATE" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::ChgState( oWndBrw:oBrw ) ) ;
      TOOLTIP  "Cambiar Es(t)ado" ;
      HOTKEY   "T";
      LEVEL    2

   DEFINE BTNSHELL oBtnEur RESOURCE "gc_currency_euro_" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::lEuro := !::lEuro, oBtnEur:lPressed := ::lEuro, ::oWndBrw:refresh() ) ;
      TOOLTIP  "E(u)ros";
      HOTKEY   "U";
      LEVEL    3

   DEFINE BTNSHELL RESOURCE "IMP" GROUP OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( msginfo( "GenDeposito( .T. )" ) ) ;
      TOOLTIP  "(I)mprimir";
      HOTKEY   "I";
      LEVEL    3

   DEFINE BTNSHELL RESOURCE "PREV1" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( msginfo( "GenDeposito( .F. )" ) ) ;
      TOOLTIP  "(P)revisualizar";
      HOTKEY   "P";
      LEVEL    3

   DEFINE BTNSHELL RESOURCE "GC_PRINTER2_" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( msginfo( "PrnSerie()" ) ) ;
      TOOLTIP  "Imp(r)imir series";
      HOTKEY   "R";
      LEVEL    3

   ::oWndBrw:EndButtons( Self )

   ::oWndBrw:Activate(  nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,;
                        nil, nil, nil, nil, {|| ::CloseFiles() }, nil, nil )

RETURN NIL

//----------------------------------------------------------------------------//

METHOD Resource( nMode )

	local oDlg
	local oBrw2
	local oFld
   local aoGet       := Array( 5 )
   local aoSay       := Array( 5 )
   local acSay       := aFill( Array( 5 ), "" )
   local oFont       := TFont():New( "Arial", 8, 26, .F., .T. )
   local oBmpDiv

   ::lLoadDivisa( ::oDbf:cDivPed )

   DEFINE DIALOG oDlg RESOURCE "DEPAGE" TITLE LblTitle( nMode ) + "depositos a almacenes"

      REDEFINE GET ::aGet:nNumDep VAR ::oDbf:nNumDep ;
			ID 		100 ;
			PICTURE 	"999999999" ;
			WHEN  	( .F. ) ;
			COLOR 	CLR_SHOW ;
			OF 		oDlg

      REDEFINE GET ::aGet:dFecDep VAR ::oDbf:dFecDep ;
			ID 		110 ;
			SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			OF 		oDlg

      REDEFINE GET ::aGet:cCodAlm VAR ::oDbf:cCodAlm ;
			ID 		130 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( ::LoadAlm() ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAlmacen( ::aGet:cCodAlm, ::aGet:cNomAlm ) ) ;
			COLOR 	CLR_GET ;
			OF 		oDlg

      REDEFINE GET ::aGet:cNomAlm VAR ::oDbf:cNomAlm ;
			WHEN 		.F. ;
			ID 		131 ;
			OF 		oDlg

      REDEFINE GET ::aGet:cCodPgo VAR ::oDbf:cCodPgo ;
			ID 		140 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			PICTURE  "@!" ;
         BITMAP   "LUPA" ;
         VALID    ( cFPago( ::aGet:cCodPgo, dbfFPago, aoSay[1] ) ) ;
         ON HELP  ( BrwFPago( ::aGet:cCodPgo, aoSay[1] ) ) ;
			OF 		oDlg

      REDEFINE GET aoSay[1] VAR acSay[1] ;
			ID 		141 ;
			WHEN 		.F. ;
			COLOR 	CLR_GET ;
			OF 		oDlg

      REDEFINE GET ::aGet:CCODTAR VAR ::oDbf:CCODTAR ;
			ID 		150 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( cTarifa( ::aGet:CCODTAR, aoSay[2] ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwTarifa( ::aGet:CCODTAR, aoSay[2] ) ) ;
			COLOR 	CLR_GET ;
			OF 		oDlg

      REDEFINE GET aoSay[2] VAR acSay[2] ;
			WHEN 		.F. ;
			ID 		151 ;
			OF 		oDlg

		/*
		Moneda__________________________________________________________________
		*/

      REDEFINE GET ::aGet:cDivDep VAR ::oDbf:cDivPed ;
			WHEN 		( 	nMode == APPD_MODE ) ;
         BITMAP   "LUPA" ;
         VALID    (  cDiv( ::aGet:cDivDep, oBmpDiv, ::aGet:nVdvDep, @cPinDiv, @nDinDiv, dbfDivisa, ::oBan ),;
                     ::nTotal( 0, dbfDepAgeT, dbfTmp, dbfIva, dbfDivisa, aTmp ),;
							.t. );
			PICTURE	"@!";
			ID 		170 ;
			COLOR 	CLR_GET ;
         ON HELP  BrwDiv( ::aGet:cDivDep, oBmpDiv, ::aGet:nVdvDep, dbfDivisa, ::oBan ) ;
			OF 		oDlg

		REDEFINE BITMAP oBmpDiv ;
         RESOURCE "BAN_EURO" ;
			ID 		171;
			OF 		oDlg

      REDEFINE GET ::aGet:nVdvDep VAR ::oDbf:nVdvDep ;
			WHEN 		( nMode == APPD_MODE ) ;
			ID 		180 ;
         VALID    ( ::oDbf:nVdvDep > 0 ) ;
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
                  ::oDbfVir:cRef,;
                  ::oDbfVir:cDetalle,;
                  Transform( ::nTotUndLin( ::oDbfVir ), ::cPicUnd ),;
                  Transform( ::oDbfVir:nPreUnit, ::cPouDiv ),;
                  Transform( ::oDbfVir:nDto, "@E 99.99"),;
                  Transform( ::oDbfVir:nDtoPrm, "@E 99.99"),;
                  Transform( ::oDbfVir:nIva, "@E 99.9" ),;
                  Transform( ::nTotLin( ::oDbfVir  ), ::cPorDiv );
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
                  "Código",;
						"Detalle",;
						"Unds.",;
                  "Precio",;
						"Dto.%",;
						"Dto.P.%",;
                  cImp(),;
						"Importe";
			ID 		200 ;
			ALIAS 	( dbfTmp ) ;
			OF 		oDlg

			oBrw2:aJustify := { .F., .F., .T., .T., .T., .T., .T., .T., .T. }

         oDbfVir:SetBrowse( oBrw2 )

         /*
			IF nMode	!= ZOOM_MODE
				oBrw2:bLDblClick	:= {|| EdtDeta( oBrw2, bEdit2, aTmp ) }
				oBrw2:bAdd 			:= {|| AppDeta( oBrw2, bEdit2, aTmp ) }
				oBrw2:bEdit			:= {|| EdtDeta( oBrw2, bEdit2, aTmp ) }
				oBrw2:bDel 			:= {|| DelDeta( oBrw2, aTmp ) }
			END IF
         */

		/*
		Cajas para el desglose________________________________________________
		*/

      REDEFINE GET ::aGet:nDtoEsp VAR ::oDbf:nDtoEsp ;
			ID 		210 ;
			PICTURE 	"@E 99.99" ;
			COLOR 	CLR_GET ;
         VALID    ( ::lRecTotal() );
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET ::aGet:nDtoPp VAR ::oDbf:nDtoPp ;
			ID 		220 ;
			PICTURE 	"@E 99.99" ;
			COLOR 	CLR_GET ;
         VALID    ( ::lRecTotal() );
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET ::aGet:nDtoUno VAR ::oDbf:nDtoUno;
			ID 		230 ;
			PICTURE 	"@E 99.99" ;
			COLOR 	CLR_GET ;
         VALID    ( ::lRecTotal() );
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET ::aGet:nDtoDos VAR ::oDbf:nDtoDos;
         ID       240 ;
			PICTURE 	"@E 99.99" ;
			COLOR 	CLR_GET ;
         VALID    ( ::lRecTotal() );
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      /*
      Cajas Bases de los impuestosS____________________________________________________________
		*/

      REDEFINE LISTBOX oBrwIva ;
			FIELDS ;
                  if( ::aIva[ oBrwIva:nAt, 3 ] != nil, Trans( ::aIva[ oBrwIva:nAt, 1 ], ::cPorDiv ), "" ),;
                  if( ::aIva[ oBrwIva:nAt, 3 ] != nil, Trans( ::aIva[ oBrwIva:nAt, 2 ], ::cPorDiv ), "" ),;
                  if( ::aIva[ oBrwIva:nAt, 3 ] != nil, Trans( ::aIva[ oBrwIva:nAt, 3 ], "@E 99.9"), "" ),;
                  if( ::aIva[ oBrwIva:nAt, 3 ] != nil, Trans( ::aIva[ oBrwIva:nAt, 3 ] * ::aIva[ oBrwIva:nAt, 2 ] / 100, ::cPorDiv ), "" ),;
                  if( ::aIva[ oBrwIva:nAt, 3 ] != nil, Trans( ::aIva[ oBrwIva:nAt, 4 ], "@E 99.9"), "" ),;
                  if( ::aIva[ oBrwIva:nAt, 3 ] != nil, Trans( ::aIva[ oBrwIva:nAt, 4 ] * ::aIva[ oBrwIva:nAt, 2 ] / 100, ::cPorDiv ), "" ) ;
         FIELDSIZES ;
                  75,;
                  75,;
                  40,;
                  70,;
                  40,;
                  70 ;
         HEAD ;
                  "Bruto",;
                  "Base",;
                  "%" + cImp(),;
                  cImp(),;
                  "%R.E.",;
                  "R.E." ;
         ID       310 ;
         OF       oDlg

      oBrwIva:SetArray( ::aIva )
      oBrwIva:aJustify     := { .t., .t., .t., .t., .t., .t. }
      oBrwIva:aFooters     := {||{ Trans( ::nTotalBrt, cPorDiv ), Trans( ::nTotalNet, ::cPorDiv ), "" , Trans( ::nTotalIva, ::cPorDiv ) , "" , Trans( ::nTotalReq, ::cPorDiv ) } }
      oBrwIva:lDrawFooters := .t.

      /*
      Totales
		------------------------------------------------------------------------
		*/

      REDEFINE SAY ::oTotalNet VAR ::nTotalNet ;
			ID 		420 ;
         PICTURE  ::cPirDiv ;
			OF 		oDlg

      REDEFINE SAY ::oTotalIva VAR ::nTotalIva ;
         ID       430 ;
         PICTURE  ::cPirDiv ;
			OF 		oDlg

      REDEFINE SAY ::oTotalReq VAR ::nTotalReq ;
         ID       440 ;
         PICTURE  ::cPirDiv ;
			OF 		oDlg

      REDEFINE CHECKBOX ::aGet:lRecargo VAR ::oDbf:lRecargo ;
			ID 		450 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ON CHANGE( ::lRecTotal() );
			OF 		oDlg

      REDEFINE SAY ::oTotalDoc VAR ::nTotalDoc;
			ID 		460 ;
         PICTURE  ::cPirDiv ;
			FONT 		oFont ;
			OF 		oDlg

      REDEFINE BUTTON ;
			ID 		500 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( ::AppDeta( oBrw2, bEdit2, aTmp ) )

		REDEFINE BUTTON ;
			ID 		501 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( ::EdtDeta( oBrw2, bEdit2, aTmp ) )

		REDEFINE BUTTON ;
			ID 		502 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( ::DelDeta( oBrw2, aTmp ) )

		REDEFINE BUTTON ;
			ID 		503 ;
			OF 		oDlg ;
         ACTION   ( ::EdtZoom( oBrw2, bEdit2, aTmp ) )

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
         ACTION   ( ::EndTrans(), oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
			ID 		510 ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( ::KillTrans(), oDlg:end() )

   ACTIVATE DIALOG oDlg ON PAINT ( EvalGet( ::aGet, nMode ) ) ON INIT ( ::lRecTotal() ) CENTER

   oFont:end()


RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

/*
Edita las lineas de Detalle
*/

METHOD Detalle( nMode )

   local oDlg2
	local oTotal
	local nTotal 			:= 0

	IF nMode	== APPD_MODE
      oDbfVir:cSerDep   := cSerDoc
      oDbfVir:nNumDep   := nNumDoc
      oDbfVir:cSufDep   := cSufDoc
	END CASE

   DEFINE DIALOG oDlg2 RESOURCE "LDEPAGE" TITLE lblTitle( nMode ) + "Lineas de depósitos a almacen"

      REDEFINE GET ::aGetVir:cRef VAR ::oDbfVir:cRef ;
			ID 		100 ;
			WHEN 		( nMode == APPD_MODE ) ;
         VALID    ( ::LoadArt() ) ;
         ON HELP  ( BrwArticulo( ::aGetVir:cRef, ::aGetVir:cDetalle ) );
         BITMAP   "LUPA" ;
         COLOR    CLR_GET ;
			OF 		oDlg2

      REDEFINE GET ::aGetVir:cDetalle VAR ::oDbfVir:cDetalle ;
			ID 		110 ;
         WHEN     ( lModDes() .AND. nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			OF 		oDlg2

      REDEFINE GET ::aGetVir:nIva VAR ::oDbfVir:nIva ;
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
         ON CHANGE( ::lCalcDeta( aTmp, oTotal ) );
			OF 		oDlg2

		REDEFINE GET aGet[_NUNICAJA] VAR aTmp[_NUNICAJA] ;
			ID 		140;
			SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
         ON CHANGE( ::lCalcDeta( aTmp, oTotal ) );
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
         ON CHANGE( ::lCalcDeta( aTmp, oTotal ) );
         PICTURE  cPinDiv ;
			OF 		oDlg2

		REDEFINE GET aGet[_NDTO] VAR aTmp[_NDTO] ;
			ID 		170 ;
			SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			PICTURE 	"@E 999.9";
         ON CHANGE( ::lCalcDeta( aTmp, oTotal ) );
			OF 		oDlg2

		REDEFINE GET aGet[_NDTOPRM] VAR aTmp[_NDTOPRM] ;
			ID 		175 ;
			SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			PICTURE 	"@E 999.9";
         ON CHANGE( ::lCalcDeta( aTmp, oTotal ) );
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

		REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg2 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ::SaveDeta( aTmp, aGet, oBrw, oDlg2, nMode, oTotal )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg2 ;
			ACTION 	( oDlg2:end() )

   oDlg2:bStart := {|| if( !lUseCaj(), aGet[_NCANENT]:hide(), ) }

   ACTIVATE DIALOG oDlg2 CENTER ON PAINT ( ::lCalcDeta( aTmp, oTotal ) )

RETURN ( oDlg2:nResult == IDOK )

//--------------------------------------------------------------------------//

METHOD nTotLin( oDbf )

   local nCalculo := ::nTotUndLin( oDbf )

   if oDbf:nDto != 0
      nCalculo -= nCalculo * oDbf:nDto / 100
   end if

   if oDbf:nDtoPrm != 0
      nCalculo -= nCalculo * oDbf:nDtoPrm / 100
   end if

RETURN ( nCalculo )

//--------------------------------------------------------------------------//