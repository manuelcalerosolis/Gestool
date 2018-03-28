// Clipper DataBases management as objects

#include "FiveWin.Ch"

#ifdef __XPP__
   #include "Class.ch"
   #include "types.ch"
   #define _DbSkipper DbSkipper
#endif

//----------------------------------------------------------------------------//

CLASS TDataBase

   DATA   nArea                  AS NUMERIC INIT 0
   DATA   lBuffer
   DATA   lShared                AS LOGICAL INIT .t.
   DATA   aBuffer                AS ARRAY, NIL INIT nil
   DATA   bBoF, bEoF, bNetError  AS CODEBLOCK
   DATA   cAlias, cFile, cDriver AS CHARACTER INIT ""
   DATA   lReadOnly              AS LOGICAL INIT .f.
   DATA   lOemAnsi
   DATA   lTenChars              AS LOGICAL INIT .t.
   DATA   aFldNames              AS ARRAY

	DATA   lAppend						AS LOGICAL INIT .t.

   #ifdef __XPP__
      // CLASS VAR this
   #endif

	METHOD New( cFile, lNew, cDriver, lShared, lReadOnly, lOemToAnsi ) CONSTRUCTOR

   METHOD Activate()

   METHOD AddIndex( cFile, cTag ) INLINE ( ::nArea )->( OrdListAdd( cFile, cTag ) )
   MESSAGE AnsiToOem METHOD _AnsiToOem()
   METHOD Append()            INLINE ( ::nArea )->( DbAppend() )
   METHOD Blank( nRecNo )     INLINE ( ::nArea )->( nRecNo := RecNo(),;
                                                    DBGoBottom(), ;
                                                    DBSkip( 1 ), ;
                                                    ::Load(),;
																	 DBGoTo( nRecNo ),;
																	 ::lAppend := .t. )
   METHOD Bof()               INLINE ( ::nArea )->( BoF() )
   METHOD Close()             INLINE ( ::nArea )->( DbCloseArea() )
   METHOD CloseIndex()        INLINE ( ::nArea )->( OrdListClear() )
   METHOD Commit()            INLINE ( ::nArea )->( DBCommit() )

   METHOD Create( cFile, aStruct, cDriver ) ;
                              INLINE DbCreate( cFile, aStruct, cDriver )

   METHOD CreateIndex( cFile, cTag, cKey, bKey, lUnique) INLINE ;
          ( ::nArea )->( OrdCreate( cFile, cTag, cKey, bKey, lUnique ) )

   METHOD ClearRelation()     INLINE ( ::nArea )->( DbClearRelation() )

   METHOD DbCreate( aStruct ) INLINE DbCreate( ::cFile, aStruct, ::cDriver )

   METHOD Deactivate()        INLINE ( ::nArea )->( DbCloseArea() ), ::nArea := 0

   #ifndef __XPP__
   METHOD Eval( bBlock, bFor, bWhile, nNext, nRecord, lRest ) ;
                              INLINE ( ::nArea )->( DBEval( bBlock, bFor, ;
                                                    bWhile, nNext, nRecord, ;
                                                    lRest ) )
   #endif

   MESSAGE Delete METHOD _Delete()
   METHOD Deleted()           INLINE ( ::nArea )->( Deleted() )

   METHOD DeleteIndex( cTag, cFile ) INLINE ( ::nArea )->( OrdDestroy( cTag, cFile ) )

   METHOD Eof()               INLINE ( ::nArea )->( EoF() )

   METHOD FCount()            INLINE ( ::nArea )->( FCount() )

   MESSAGE FieldGet METHOD _FieldGet( nField )

   METHOD FieldName( nField ) INLINE ( ::nArea )->( FieldName( nField ) )

   METHOD FieldPos( cFieldName ) INLINE ( ::nArea )->( FieldPos( cFieldName ) )

   MESSAGE FieldPut METHOD _FieldPut( nField, uVal )

   METHOD Found()             INLINE ( ::nArea )->( Found() )

   METHOD GoTo( nRecNo )      INLINE ( ::nArea )->( DBGoTo( nRecNo ) ),;
                                     If( ::lBuffer, ::Load(), )

   METHOD GoTop()             INLINE ( ::nArea )->( DBGoTop() ),;
                                     If( ::lBuffer, ::Load(), )
   METHOD GoBottom()          INLINE ( ::nArea )->( DBGoBottom() ),;
                                     If( ::lBuffer, ::Load(), )

   METHOD IndexKey( ncTag, cFile )   INLINE ( ::nArea )->( OrdKey( ncTag, cFile ) )
   METHOD IndexName( nTag, cFile )   INLINE ( ::nArea )->( OrdName( nTag, cFile ) )
   METHOD IndexBagName( nInd )       INLINE ( ::nArea )->( OrdBagName( nInd ) )
   METHOD IndexOrder( cTag, cFile )  INLINE ( ::nArea )->( OrdNumber( cTag, cFile ) )

   METHOD LastRec( nRec )     INLINE ( ::nArea )->( LastRec() )

   METHOD Load()

   METHOD Lock()          LPR2", "C",  5,   0, "Valor de la segunda propiedad" } }

//----------------------------------------------------------------------------//

STATIC FUNCTION OpenFiles()

	IF dbfPedPrvT == NIL

      USE ( cPatEmp() + "PEDPROVT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDPROVT", @dbfPedPrvT ) )
      SET ADSINDEX TO ( cPatEmp() + "PEDPROVT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PEDPROVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDPROVL", @dbfPedPrvL ) )
      SET ADSINDEX TO ( cPatEmp() + "PEDPROVL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PROVEE.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROVEE", @dbfPrv ) )
      SET ADSINDEX TO ( cPatEmp() + "PROVEE.CDX" ) ADDITIVE

      USE ( cPatDat() + "TIVA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfIva ) )
      SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FPAGO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FPAGO", @dbfFPago ) )
      SET ADSINDEX TO ( cPatEmp() + "FPAGO.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ARTDIV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTDIV", @dbfDiv ) )
      SET ADSINDEX TO ( cPatEmp() + "ARTDIV.CDX" ) ADDITIVE

      USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDivisa ) )
      SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

      USE ( cPatDat() + "BANDERA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "BANDERA", @dbfBander ) )
      SET ADSINDEX TO ( cPatDat() + "BANDERA.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PROVART.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROVART", @dbfArtPrv ) )
      SET ADSINDEX TO ( cPatEmp() + "PROVART.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
      SET ADSINDEX TO ( cPatEmp() + "ARTICULO.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FAMILIAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FAMILIAS", @dbfFamilia ) )
      SET ADSINDEX TO ( cPatEmp() + "FAMILIAS.CDX" ) ADDITIVE

   END IF

RETURN .t.

//----------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles( aDbfBmp )

	IF aDbfBmp != NIL
      aEval( aDbfBmp, { | hBmp | DeleteObject( hBmp ) } )
	END IF

	dbCommitAll()

	( dbfPedPrvL  )->( dbCloseArea() )
	( dbfPrv      )->( dbCloseArea() )
	( dbfIva      )->( dbCloseArea() )
	( dbfFPago    )->( dbCloseArea() )
	( dbfDiv      )->( dbCloseArea() )
	( dbfDivisa   )->( dbCloseArea() )
	( dbfArtPrv   )->( dbCloseArea() )
	( dbfBander   )->( dbCloseArea() )
	( dbfArticulo )->( dbCloseArea() )
   ( dbfFamilia  )->( dbCloseArea() )

	IF oWndBrw != NIL
		oWndBrw:oBrw:lCloseArea()
		oWndBrw 	:= NIL
	ELSE
		( dbfPedPrvT )->( dbCloseArea() )
	END IF

	dbfPedPrvT 	:= NIL
	dbfPedPrvL	:= NIL
	dbfPrv		:= NIL
	dbfIva		:= NIL
	dbfFPago		:= NIL
	dbfDiv		:= NIL
	dbfDivisa   := NIL
	dbfBander   := NIL
	dbfArticulo	:= NIL
   dbfFamilia  := NIL

RETURN .t.

//----------------------------------------------------------------------------//

FUNCTION PedPrv( oWnd )

	local oBtnEur
	local lEuro		:= .f.
   local bIntBmp  := LoadBitmap( GetResources(), "BSEL" )
	local aDbfBmp  := {  LoadBitmap( GetResources(), "BGREEN" ),;
								LoadBitmap( GetResources(), "BRED"   ) }

	IF oWndBrw == NIL

   IF !OpenFiles()
      RETURN NIL
   END IF

   DEFINE SHELL oWndBrw FROM 0, 0 TO 22, 80 ;
		TITLE 	"Pedidos a Proveedores" ;
		FIELDS 	If( (dbfPedPrvT)->LESTADO, aDbfBmp[1], aDbfBmp[2] ),;
					If( (dbfPedPrvT)->LSNDDOC, bIntBmp, "" ),;
               (dbfPedPrvT)->CSERPED + "/" + Str( (dbfPedPrvT)->NNUMPED ) + "/" + (dbfPedPrvT)->CSUFPED,;
					Dtoc( (dbfPedPrvT)->DFECPED ),;
					Dtoc( (dbfPedPrvT)->DFECENT ),;
					(dbfPedPrvT)->CCODPRV + SPACE(1) + (dbfPedPrvT)->CNOMPRV,;
               hBmpDiv( (dbfPedPrvT)->CDIVPED, dbfDivisa, dbfBander ),;
               nTotal( (dbfPedPrvT)->CSERPED + Str( (dbfPedPrvT)->NNUMPED ) + (dbfPedPrvT)->CSUFPED, dbfPedPrvT, dbfPedPrvL, dbfIva, dbfDivisa, dbfFPago, nil, lEuro ) ;
		HEAD	 	"Est",;
					"Int",;
					"N. Pedido",;
					"F. Pedido",;
					"F. Entrada",;
					"Proveedor",;
					"Div.",;
               "Importe";
		SIZES 	17,;
					17,;
					80,;
					70,;
					70,;
					260,;
					25,;
					100;
      JUSTIFY  .F., .F., .F., .F., .F., .F., .F., .T.;
      PROMPT   "Número",;
					"Fecha",;
					"Cod. Proveedor",;
					"Nom. Proveedor";
		ALIAS 	( dbfPedPrvT );
		APPEND	( WinAppRec( oWndBrw:oBrw, bEdit, dbfPedPrvT, , , dbfPedPrvL ) );
		DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdit, dbfPedPrvT, , , dbfPedPrvL ) );
		EDIT 		( WinEdtRec( oWndBrw:oBrw, bEdit, dbfPedPrvT, , , dbfPedPrvL ) ) ;
      DELETE   ( DBDelRec(  oWndBrw:oBrw, dbfPedPrvT, {|| DelDetalle( (dbfPedPrvT)->CSERPED + str( (dbfPedPrvT)->NNUMPED ) + (dbfPedPrvT)->CSUFPED ) } ) ) ;
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
			TOOLTIP 	"(M)odifica";
			HOTKEY 	"M"

		DEFINE BTNSHELL RESOURCE "ZOOM" OF oWndBrw ;
			NOBORDER ;
			ACTION  	( WinZooRec( oWndBrw:oBrw, bEdit, dbfPedPrvT ) );
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

		DEFINE BTNSHELL RESOURCE "CHGSTATE" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( ChgState( oWndBrw:oBrw ) ) ;
			TOOLTIP 	"Cambiar Es(t)ado" ;
			HOTKEY 	"T"

		DEFINE BTNSHELL oBtnEur RESOURCE "gc_currency_euro_" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( lEuro := !lEuro, oBtnEur:lPressed := lEuro, oWndBrw:refresh() ) ;
			TOOLTIP 	"E(u)ros";
			HOTKEY 	"U"

      DEFINE BUTTON RESOURCE "SNDINT" GROUP OF oWndBrw:oBar ;
         NOBORDER ;
         MENU     lSel( oWndBrw:oBrw, dbfPedPrvT, this ) ;
         MESSAGE  "Enviar pedidos" ;
         ACTION   lSnd( oWndBrw, dbfPedPrvT ) ;
         TOOLTIP  "Seleccionar pedidos para ser enviados"

      DEFINE BTNSHELL RESOURCE "IMP" GROUP OF oWndBrw ;
			NOBORDER ;
			ACTION 	(	GenPedido( .T. ) ) ;
			TOOLTIP 	"(I)mprimir";
			HOTKEY 	"I"

		DEFINE BTNSHELL RESOURCE "PREV1" OF oWndBrw ;
			NOBORDER ;
			ACTION 	(	GenPedido() ) ;
			TOOLTIP 	"(P)revisualizar";
			HOTKEY 	"P"

      DEFINE BTNSHELL RESOURCE "GC_PRINTER2_" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( PrnSerie( oWndBrw:oBrw) ) ;
         TOOLTIP  "Imp(r)imir series";
			HOTKEY 	"R"

      DEFINE BTNSHELL RESOURCE "END" GROUP OF oWndBrw ;
			NOBORDER ;
			ACTION 	( oWndBrw:End() ) ;
			TOOLTIP 	"(S)alir";
			HOTKEY 	"S"

		ACTIVATE WINDOW oWndBrw VALID ( CloseFiles( aDbfBmp ) )

	ELSE

		oWndBrw:SetFocus()

	END IF

RETURN NIL

//----------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aTmp, aGet, dbfPedPrvT, oBrw, bWhen, bValid, nMode )

	local oDlg
	local oBrw2
	local oFont
	local oSay1, cSay1
	local oSay2, cSay2
	local oSay3, cSay3
	local nImpIva1	:= 0
	local nImpIva2	:= 0
	local nImpIva3	:= 0
	local nImpReq1	:= 0
	local nImpReq2	:= 0
	local nImpReq3	:= 0

   nMetMsg        := 0

	DO CASE
	CASE nMode 	== APPD_MODE
      aTmp[ _CSERPED ]  := "A"
      aTmp[ _CCODALM ]  := Application():codigoAlmacen()
      aTmp[ _CDIVPED ]  := cDivEmp()
      aTmp[ _NVDVPED ]  := nChgDiv( aTmp[ _CDIVPED ], dbfDivisa )
		aTmp[ _CSUFPED ]	:= retSufEmp()
      aTmp[ _LSNDDOC ]  := .t.
	CASE nMode == EDIT_MODE .AND. aTmp[ _LESTADO ]
      msgStop( "El pedido ya fue recibido" )
		RETURN .T.
	END

	BeginTrans( aTmp, nMode )

	cPinDiv	:= cPinDiv( aTmp[ _CDIVPED ], dbfDivisa )	// Picture de la divisa
	cPicEur	:= cPinDiv( "EUR", dbfDivisa )				// Picture del euro
   cPicUnd  := masUnd()
	nDinDiv	:= nDinDiv( aTmp[ _CDIVPED ], dbfDivisa )
   oFont    := TFont():New( "Arial", 8, 26, .F., .T. )

   DEFINE DIALOG oDlg RESOURCE "PEDPRV" TITLE LblTitle( nMode ) + " pedidos a proveedores"

		REDEFINE FOLDER oFld ID 400 OF oDlg ;
         PROMPT   "&Pedido",  "Mas Da&tos" ;
			DIALOGS 	"PEDPRV_1", "PEDPRV_2"

      REDEFINE GET aGet[_CSERPED] VAR aTmp[_CSERPED] ;
         ID       90 ;
         PICTURE  "@!" ;
         WHEN     ( nMode == APPD_MODE ) ;
         VALID    ( aTmp[_CSERPED] $ "AB" );
         BITMAP   "AORB" ;
         ON HELP  ( ChgSerie( aGet[ _CSERPED ] ) ) ;
			OF 		oFld:aDialogs[1]

		REDEFINE GET aGet[_NNUMPED] VAR aTmp[_NNUMPED];
			ID 		100 ;
			PICTURE 	"999999999" ;
			WHEN 		.F. ;
			COLOR 	CLR_SHOW ;
			OF 		oFld:aDialogs[1]

		REDEFINE GET aGet[_CSUFPED] VAR aTmp[_CSUFPED];
			ID 		105 ;
			WHEN 		.F. ;
			COLOR 	CLR_SHOW ;
			OF 		oFld:aDialogs[1]

		REDEFINE GET aGet[_DFECPED] VAR aTmp[_DFECPED];
			ID 		110 ;
			SPINNER;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[1]

		REDEFINE CHECKBOX aGet[_LESTADO] VAR aTmp[_LESTADO];
			ID 		120 ;
			WHEN 		( .F. ) ;
			OF 		oFld:aDialogs[1]

		REDEFINE GET aGet[_CCODPRV] VAR aTmp[_CCODPRV] ;
			ID 		140 ;
			COLOR 	CLR_GET ;
			PICTURE	( RetPicCodPrvEmp() ) ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( LoaPrv( aGet, dbfPrv, nMode ) ) ;
         ON HELP  ( BrwProvee( aGet[_CCODPRV] ) ) ;
         BITMAP   "LUPA" ;
         OF       oFld:aDialogs[1]

		REDEFINE GET aGet[_CNOMPRV] VAR aTmp[ _CNOM