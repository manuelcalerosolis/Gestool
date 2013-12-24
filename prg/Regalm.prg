#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "Report.ch"

#define _DFECMOV                   1      //   D      8     0
#define _CHORMOV                   2      //   C      5     0
#define _CALIMOV                   3      //   C      3     0
#define _CALOMOV                   4      //   C      3     0
#define _CREFMOV                   5      //   C     14     0
#define _CCODPR1                   6      //
#define _CCODPR2                   7      //
#define _CVALPR1                   8      //
#define _CVALPR2                   9      //
#define _NUNDMOV                  10      //   C     20     0
#define _CUSRMOV                  11      //   C     12     0
#define _LKITART                  12
#define _NCTLSTK                  13

static oWndBrw
static dbfHisMov
static dbfMov
static dbfArticulo
static dbfCodebar
static dbfIva
static dbfTblPro
static dbfFamilia
static dbfAlmT
static oStock
static cPicUnd
static bEdit   := { |aTmp, aGet, dbfHisMov, oBrw, bWhen, bValid, nMode | EdtRec( aTmp, aGet, dbfHisMov, oBrw, bWhen, bValid, nMode ) }

//----------------------------------------------------------------------------//

FUNCTION RegMovAlm( oWnd )

   IF oWndBrw == NIL

   IF !OpenFiles()
      RETURN NIL
   END IF

   DEFINE SHELL oWndBrw FROM 0, 0 TO 22, 80;
      TITLE    "Regularización de almacenes" ;
		FIELDS 	dtoc( (dbfHisMov)->DFECMOV ),;
               (dbfHisMov)->CALIMOV + Space(1) + RetAlmacen( (dbfHisMov)->CALIMOV, dbfAlmT ),;
               (dbfHisMov)->CREFMOV,;
               (dbfHisMov)->CVALPR1 ,;
               (dbfHisMov)->CVALPR2 ,;
               retArticulo( (dbfHisMov)->CREFMOV, dbfArticulo ),;
               Trans( (dbfHisMov)->NUNDMOV, cPicUnd );
		FIELDSIZES ;
					80,;
               180,;
               80,;
               40 ,;
               40 ,;
               220,;
					80;
		HEAD 		"Fecha",;
               "Almacén",;
               "Codigo",;
               "Prop. 1" ,;
               "Prop. 2" ,;
               "Artículo",;
					"Unidades";
      JUSTIFY  .F., .F., .F., .F., .F., .F., .T. ;
      PROMPT   "Fecha",;
               "Articulo",;
               "Almacen" ;
      ALIAS    ( dbfHisMov ) ;
      APPEND   ( WinAppRec( oWndBrw:oBrw, bEdit, dbfHisMov ) );
      DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdit, dbfHisMov ) );
      EDIT     ( WinEdtRec( oWndBrw:oBrw, bEdit, dbfHisMov ) ) ;
      DELETE   ( DelDet( oWndBrw:oBrw, dbfHisMov ) ) ;
		OF 		oWnd

      DEFINE BTNSHELL RESOURCE "NEW" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:RecAdd() );
         ON DROP  ( oWndBrw:RecDup() );
			TOOLTIP 	"(A)ñadir";
			HOTKEY 	"A"

      DEFINE BTNSHELL RESOURCE "DUP" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:RecDup() );
			TOOLTIP 	"(D)uplicar";
			HOTKEY 	"D"

      DEFINE BTNSHELL RESOURCE "EDIT" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:RecEdit() );
			TOOLTIP 	"(M)odifica";
			HOTKEY 	"M"

      DEFINE BTNSHELL RESOURCE "ZOOM" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( WinZooRec( oWndBrw:oBrw, bEdit, dbfAlmT ) );
			TOOLTIP 	"(Z)oom";
			HOTKEY 	"Z"

      DEFINE BTNSHELL RESOURCE "DEL" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( delDet( oWndBrw:oBrw, dbfHisMov ) );
			TOOLTIP 	"(E)liminar";
			HOTKEY 	"E"

      DEFINE BTNSHELL RESOURCE "BUS" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:search() ) ;
			TOOLTIP 	"(B)uscar" ;
			HOTKEY 	"B"

      DEFINE BTNSHELL RESOURCE "IMP" OF oWndBrw ;
			NOBORDER ;
			ACTION ( GenReport( dbfHisMov ) ) ;
			TOOLTIP "(L)istado" ;
			HOTKEY 	"L"

      DEFINE BTNSHELL RESOURCE "END" GROUP OF oWndBrw ;
			NOBORDER ;
         ACTION ( oWndBrw:End() ) ;
			TOOLTIP "(S)alir" ;
			HOTKEY 	"S"

      ACTIVATE WINDOW oWndBrw VALID ( CloseFiles() )

	ELSE

      oWndBrw:SetFocus()

	END IF

RETURN NIL

//----------------------------------------------------------------------------//

STATIC FUNCTION OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   IF dbfHisMov == NIL

      IF !File( cPatEmp() + "HISMOV.DBF" )
			mkHisMov()
		END IF

      USE ( cPatEmp() + "HISMOV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "HISMOV", @dbfHisMov ) )
      SET ADSINDEX TO ( cPatEmp() + "HISMOV.CDX" ) ADDITIVE
      SET FILTER TO Empty( Field->CALOMOV )

      USE ( cPatEmp() + "MOVALM.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "MOVALM", @dbfMov ) )
      SET ADSINDEX TO ( cPatEmp() + "MOVALM.CDX" ) ADDITIVE

      USE ( cPatArt() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
      SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

      USE ( cPatArt() + "ArtCodebar.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CODEBAR", @dbfCodebar ) )
      SET ADSINDEX TO ( cPatArt() + "ArtCodebar.Cdx" ) ADDITIVE

      USE ( cPatArt() + "FAMILIAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FAMILIAS", @dbfFamilia ) )
      SET ADSINDEX TO ( cPatArt() + "FAMILIAS.CDX" ) ADDITIVE

      USE ( cPatArt() + "TBLPRO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TBLPRO", @dbfTblPro ) )
      SET ADSINDEX TO ( cPatArt() + "TBLPRO.CDX" ) ADDITIVE

      USE ( cPatAlm() + "ALMACEN.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALMACEN", @dbfAlmT ) )
      SET ADSINDEX TO ( cPatAlm() + "ALMACEN.CDX" ) ADDITIVE

      USE ( cPatDat() + "TIVA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfIva ) )
      SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE

      oStock   := TStock():Create( cPatGrp())
      if !oStock:lOpenFiles()
         lOpen := .f.
      end if

      cPicUnd  := MasUnd()

   END IF

   RECOVER

      lOpen    := .f.
      msgStop( "Imposible abrir todas las bases de datos" )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpen
      CloseFiles()
   end if

RETURN ( lOpen )

//----------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles()

	IF oWndBrw 	!= NIL
		oWndBrw:oBrw:lCloseArea()
		oWndBrw 	:= NIL
	ELSE
      CLOSE ( dbfHisMov )
	END IF

   CLOSE ( dbfMov      )
   CLOSE ( dbfArticulo )
   CLOSE ( dbfCodebar  )
   CLOSE ( dbfTblPro   )
   CLOSE ( dbfFamilia  )
   CLOSE ( dbfAlmT     )
   CLOSE ( dbfIva      )

   if !Empty( oStock )
      oStock:end()
   end if

	dbfHisMov 	:= NIL
	dbfMov 		:= NIL
   dbfArticulo := NIL
   dbfCodebar  := NIL
   dbfTblPro   := NIL
   dbfFamilia  := NIL
   dbfAlmT     := NIL
   oStock      := NIL
   dbfIva      := NIL

RETURN .T.

//----------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aTmp, aGet, dbfHisMov, oBrw, bWhen, bValid, nMode )

	local oDlg
	local oSayAli
	local cSayAli
	local oSayArt
	local cSayArt
   local oSayPr1
   local oSayPr2
   local cSayPr1  := ""
   local cSayPr2  := ""
   local oSayVp1
   local oSayVp2
   local cSayVp1  := ""
   local cSayVp2  := ""
   local oGetStk
	local nGetStk	:= 0
	local aOld		:= aClone( aTmp )

	IF nMode == APPD_MODE
		aTmp[ _DFECMOV ] 	:= date()
		aTmp[ _CHORMOV ]	:= substr( time(), 1, 5 )
	END IF

   DEFINE DIALOG oDlg RESOURCE "REGALM" TITLE LblTitle( nMode ) + "movimientos de almacen"

      REDEFINE GET aGet[ _DFECMOV ] VAR aTmp[ _DFECMOV ];
         ID       100 ;
         SPINNER ;
         COLOR    CLR_GET ;
			OF 		oDlg

		REDEFINE GET aGet[ _CALIMOV ] VAR aTmp[ _CALIMOV ];
         ID       110 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( cAlmacen( aGet[ _CALIMOV ], dbfAlmT, oSayAli ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAlmacen( aGet[ _CALIMOV ], oSayAli ) ) ;
			COLOR 	CLR_GET ;
			OF 		oDlg

		REDEFINE GET oSayAli VAR cSayAli ;
			WHEN 		.F. ;
         ID       111 ;
			OF 		oDlg

		REDEFINE GET aGet[ _CREFMOV ] VAR aTmp[ _CREFMOV ];
         ID       120 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( LoaArt( aGet, aTmp, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oSayArt, oGetStk ) ) ;
         BITMAP   "LUPA" ;
			ON HELP 	( BrwArticulo( aGet[ _CREFMOV ], oSayArt ) ) ;
			COLOR 	CLR_GET ;
			OF 		oDlg

		REDEFINE GET oSayArt VAR cSayArt ;
			WHEN 		.F. ;
         ID       121 ;
			OF 		oDlg

      /*
      Propiedades
      -------------------------------------------------------------------------
      */

      REDEFINE GET aGet[_CVALPR1] VAR aTmp[_CVALPR1];
         ID       220 ;
			COLOR 	CLR_GET ;
         BITMAP   "LUPA" ;
         VALID    ( lPrpAct(     aGet[ _CVALPR1 ], oSayVp1, aTmp[ _CCODPR1 ], dbfTblPro ) ) ;
         ON HELP  ( brwPrpAct(   aGet[ _CVALPR1 ], oSayVp1, aTmp[ _CCODPR1 ] ) ) ;
         OF       oDlg

      REDEFINE SAY oSayPr1 VAR cSayPr1;
         ID       221 ;
         OF       oDlg

      REDEFINE GET oSayVp1 VAR cSayVp1;
         ID       222 ;
         WHEN     .f. ;
         COLOR    CLR_GET ;
         OF       oDlg

      REDEFINE GET aGet[_CVALPR2] VAR aTmp[_CVALPR2];
         ID       230 ;
			COLOR 	CLR_GET ;
         BITMAP   "LUPA" ;
         VALID    ( lPrpAct(     aGet[ _CVALPR2 ], oSayVp2, aTmp[ _CCODPR2 ], dbfTblPro ) ) ;
         ON HELP  ( brwPrpAct(   aGet[ _CVALPR2 ], oSayVp2, aTmp[ _CCODPR2 ] ) ) ;
         OF       oDlg

      REDEFINE SAY oSayPr2 VAR cSayPr2;
         ID       231 ;
         OF       oDlg

      REDEFINE GET oSayVp2 VAR cSayVp2;
         ID       232 ;
         WHEN     .f. ;
         COLOR    CLR_GET ;
         OF       oDlg

      /*
      fin de propiedades
      -------------------------------------------------------------------------
      */

      REDEFINE SAY oGetStk VAR nGetStk ;
         ID       130 ;
         COLOR    CLR_GET ;
         PICTURE  cPicUnd ;
			OF 		oDlg

		REDEFINE GET aGet[ _NUNDMOV ] VAR aTmp[ _NUNDMOV ];
         ID       140 ;
			SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
         PICTURE  cPicUnd ;
			OF 		oDlg

		REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			ACTION 	( ChkCodAlm( aTmp, aOld, aGet, nGetStk, dbfHisMov, oBrw, nMode, oDlg ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

      if nMode != APPD_MODE
         oDlg:bStart := {|| EvalGet( aGet ) }
      end if

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

STATIC FUNCTION ChkCodAlm( aTmp, aOld, aGet, nGetStk, dbfHisMov, oBrw, nMode, oDlg )

   IF empty( aTmp[ _CALIMOV ] )
      msgStop( "El almacen no puede estar vacio." )
		RETURN .F.
	END IF

	IF empty( aTmp[ _CREFMOV ] )
		msgStop( "Articulo no encontrado" )
		RETURN .F.
	END IF

   IF aTmp[ _NUNDMOV ] == 0
		msgStop( "Cantidad no valida" )
		RETURN .F.
	END IF

	/*
	rollback
	*/

	IF nMode == EDIT_MODE
      oStock:lAppStock( aOld[ _CREFMOV ], aOld[ _CALIMOV ], aOld[ _CVALPR1 ], aOld[ _CVALPR2 ], - aOld[ _NUNDMOV ] )
   END IF

	/*
   actualizamos el nuevo
	*/

   oStock:lAppStock( aTmp[ _CREFMOV ], aTmp[ _CALIMOV ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _NUNDMOV ] )

   /*
   Grabamos el apunte
   */

	WinGather( aTmp, aGet, dbfHisMov, oBrw, nMode )

   oDlg:end( IDOK )

RETURN .T.

//--------------------------------------------------------------------------//

/*
Funcion Auxiliar para borrar las Lineas de Detalle
*/

STATIC FUNCTION delDet( oBrw, dbfHisMov )

   IF oUser():lNotConfirmDelete() .or.  ApoloMsgNoYes( "¿ Desea eliminar definitivamente este registro ?" )

		putStock( ( dbfHisMov )->CREFMOV, ( dbfHisMov )->CALIMOV, - ( dbfHisMov )->NUNDMOV, dbfMov )

		delRecno( dbfHisMov, oBrw )

	END IF

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION GenReport( dbfHisMov )

   local oAlmOrg
   local cAlmOrg     := space( 3 )
   local oAlmDes
   local cAlmDes     := space( 3 )
   local oSayOrg
   local cSayOrg     := ""
   local oSayDes
   local cSayDes     := ""
   local dFecOrg     := date()
   local dFecDes     := date()
   local cTitulo     := Padr( cCodEmp() + " - " + cNbrEmp(), 100 )
   local cSubTitulo  := Padr( "Listado de regularización de almacenes", 100 )
   local oDlg

	/*
	Llamada a la funcion que activa la caja de dialogo
	*/

   DEFINE DIALOG oDlg RESOURCE "REP_MOVALM"

   REDEFINE GET oAlmOrg VAR cAlmOrg;
      ID       100;
      VALID    cAlmacen( oAlmOrg, , oSayOrg ) ;
      BITMAP   "LUPA" ;
      ON HELP  BrwAlmacen( oAlmOrg, oSayOrg ) ;
		COLOR 	CLR_GET ;
		OF 		oDlg

   REDEFINE GET oSayOrg VAR cSayOrg ;
      ID       110 ;
      WHEN     ( if( empty( cAlmOrg ), ( oSayOrg:ctext( "TODOS LOS ALMACENES" ), .f. ), .f. ) );
		COLOR 	CLR_GET ;
		OF 		oDlg

   REDEFINE GET oAlmDes VAR cAlmDes;
      ID       120;
      VALID    cAlmacen( oAlmDes, , oSayDes ) ;
      BITMAP   "LUPA" ;
      ON HELP  BrwAlmacen( oAlmDes, oSayDes ) ;
		COLOR 	CLR_GET ;
		OF 		oDlg

   REDEFINE GET oSayDes VAR cSayDes ;
      ID       130 ;
      WHEN     ( if( empty( cAlmDes ), ( oSayDes:ctext( "TODOS LOS ALMACENES" ), .f. ), .f. ) );
		COLOR 	CLR_GET ;
		OF 		oDlg

   REDEFINE GET dFecOrg ;
      ID       140 ;
      SPINNER ;
		OF 		oDlg

   REDEFINE GET dFecDes ;
      ID       150 ;
      SPINNER ;
		OF 		oDlg

	REDEFINE GET cTitulo ;
      ID       160 ;
		OF 		oDlg

	REDEFINE GET cSubTitulo ;
      ID       170 ;
		OF 		oDlg

	REDEFINE BUTTON ;
      ID       506;
		OF 		oDlg ;
      ACTION   ( PrnReport( cAlmOrg, cAlmDes, dFecOrg, dFecDes, cTitulo, cSubTitulo, 1 ) )

	REDEFINE BUTTON ;
		ID 		505;
		OF 		oDlg ;
      ACTION   ( PrnReport( cAlmOrg, cAlmDes, dFecOrg, dFecDes, cTitulo, cSubTitulo, 2 ) )

	REDEFINE BUTTON ;
		ID 		510;
		OF 		oDlg ;
		ACTION 	( oDlg:end() )

   ACTIVATE DIALOG oDlg CENTER ON PAINT ( oAlmOrg:lValid(), oAlmDes:lValid() )

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

STATIC FUNCTION PrnReport( cAlmOrg, cAlmDes, dFecOrg, dFecDes, cTitulo, cSubTitulo, nDevice )

   local oReport
   local oFont1
   local oFont2
	local nRecno 		:= ( dbfHisMov )->( recno() )

   ( dbfHisMov )->( dbGoTop() )

   /*
   Tipos de Letras
   */

   DEFINE FONT oFont1 NAME "Courier New" SIZE 0,-10 BOLD
   DEFINE FONT oFont2 NAME "Courier New" SIZE 0,-10

   IF nDevice == 1

      REPORT oReport ;
         TITLE    Rtrim( cTitulo ),;
                  Rtrim( cSubTitulo ) ;
         FONT     oFont1, oFont2 ;
         HEADER   "Fecha: " + dtoc( date() ) RIGHT ;
         FOOTER   "Página : " + str( oReport:nPage, 3 ) CENTERED;
         CAPTION  "Listado movimientos de almacen";
         PREVIEW

   ELSE

      REPORT oReport ;
         TITLE    Rtrim( cTitulo ),;
                  Rtrim( cSubTitulo ) ;
         FONT     oFont1, oFont2 ;
         HEADER   "Fecha: " + dtoc(date()) RIGHT ;
         FOOTER   "Página : " + str( oReport:nPage, 3) CENTERED;
         CAPTION  "Listado movimientos de almacen";
         TO PRINTER

   END IF

      COLUMN TITLE "Fecha" ;
         DATA ( dbfHisMov )->DFECMOV ;
         FONT 2

      COLUMN TITLE "Hora" ;
         DATA ( dbfHisMov )->CHORMOV ;
         FONT 2

      COLUMN TITLE "Alm. Org." ;
         DATA ( dbfHisMov )->CALOMOV ;
         FONT 2

      COLUMN TITLE "Alm. Des." ;
         DATA ( dbfHisMov )->CALIMOV ;
         FONT 2

      COLUMN TITLE "Ref." ;
         DATA ( dbfHisMov )->CREFMOV + retArticulo(  ( dbfHisMov )->CREFMOV, dbfArticulo ) ;
         FONT 2

      COLUMN TITLE "Und." ;
         DATA ( dbfHisMov)->NUNDMOV ;
         PICTURE cPicUnd ;
         TOTAL ;
         FONT 2

   END REPORT

   IF !Empty( oReport ) .and.  oReport:lCreated
      oReport:Margin(0, RPT_RIGHT, RPT_CMETERS)
      oReport:bSkip := {|| ( dbfHisMov )->( dbSkip() ) }
   END IF

   ACTIVATE REPORT oReport ;
      FOR   ( dbfHisMov )->DFECMOV >= dFecOrg .AND.;
            ( dbfHisMov )->DFECMOV <= dFecDes .AND.;
            ( ( dbfHisMov )->CALOMOV == cAlmOrg .OR. empty( cAlmOrg ) ) .AND.;
            ( ( dbfHisMov )->CALIMOV == cAlmDes .OR. empty( cAlmDes ) ) ;
      WHILE !( dbfHisMov )->( eof() )

   oFont1:end()
   oFont2:end()

   ( dbfHisMov )->( dbGoTo( nRecno ) )

RETURN NIL

//---------------------------------------------------------------------------//

static function lNotOpen()

   if NetErr()
      msgStop( "Imposible abrir ficheros." )
      CloseFiles()
      return .t.
   end if

return .f.

//---------------------------------------------------------------------------//

static function LoaArt( aGet, aTmp, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oSayArt, oGetStk )

   local lValid   := .f.
   local xValor   := aGet[_CREFMOV]:varGet()

   /*
   Primero buscamos por codigos de barra
   */

   xValor         := cSeekCodebar( xValor, dbfCodebar, dbfArticulo )

   /*
   Ahora buscamos por el codigo interno
   */

   IF ( dbfArticulo )->( dbSeek( xValor ) )

      aGet[ _CREFMOV ]:cText( ( dbfArticulo )->Codigo )

      oSayArt:cText( ( dbfArticulo )->Nombre )

      /*
      Buscamos la familia del articulo y anotamos las propiedades
      */

      aTmp[_CCODPR1 ] := ( dbfArticulo )->cCodPrp1
      aTmp[_CCODPR2 ] := ( dbfArticulo )->cCodPrp2

      IF !empty( aTmp[_CCODPR1 ] )
         aGet[_CVALPR1 ]:show()
         oSayPr1:SetText( retProp( ( dbfArticulo )->cCodPrp1 ) )
         oSayPr1:show()
         oSayVp1:Show()
      ELSE
         aGet[_CVALPR1 ]:hide()
         oSayPr1:hide()
         oSayVp1:hide()
      END IF

      IF !empty( aTmp[_CCODPR2 ] )
         aGet[_CVALPR2 ]:show()
         oSayPr2:SetText( retProp( ( dbfArticulo )->cCodPrp2 ) )
         oSayPr2:show()
         oSayVp2:Show()
      ELSE
         aGet[_CVALPR2 ]:hide()
         oSayPr2:hide()
         oSayVp2:hide()
      END IF

      /*
      Ponemos el stock
      */

      oStock:nPutStockActual( aTmp[ _CREFMOV ], aTmp[ _CALIMOV ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], nil, aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oGetStk )

      lValid   := .t.

   ELSE

      msgStop( "Artículo no encontrado" )
      lValid   := .f.

   END IF

return lValid

//---------------------------------------------------------------------------//