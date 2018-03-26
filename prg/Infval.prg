#include "FiveWin.Ch"
#include "Font.ch"
#include "Report.ch"
#include "Factu.ch" 

static dbfArticulo
static dbfFami
static dbfAlmacen
static dbfMov
static dbfProvee

//---------------------------------------------------------------------------//

FUNCTION InfValor( oMenuItem, oWnd )

	local oDlg
	local oCodAlm
   local oMtrInf
   local oCodAlmTxt
   local cCodAlmTxt
   local oCodFamDesde
   local cCodFamDesde
   local oTxtFamDesde
   local cTxtFamDesde
   local oCodFamHasta
   local cCodFamHasta
   local oTxtFamHasta
   local cTxtFamHasta
   local cCodAlm     := oUser():cAlmacen()
	local nRadCoste	:= 1
   local nMtrInf     := 0
   local cTitulo     := Padr( cCodEmp() + " - " + cNbrEmp(), 100 )
   local cSubTitulo  := Padr( "Valoración de inventario", 100 )

   DEFAULT oMenuitem := "01045"
   DEFAULT oWnd      := oWnd()

   if Auth():Level( oMenuItem ) != 1
      msgStop( "Acceso no permitido." )
      return nil
   end if

   /*
   Cerramos todas las ventanas
   */

   if oWnd != nil
      SysRefresh(); oWnd:CloseAll(); SysRefresh()
   end if

	/*
	Bases de datos para el informe
	*/

   USE ( cPatEmp() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
   SET ADSINDEX TO ( cPatEmp() + "ARTICULO.CDX" ) ADDITIVE

   USE ( cPatEmp() + "FAMILIAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FAMILIAS", @dbfFami ) )
   SET ADSINDEX TO ( cPatEmp() + "FAMILIAS.CDX" ) ADDITIVE

	/*
	Obtenemos los valores del primer y ultimo codigo
	*/

	cCodFamDesde	:= dbFirst( dbfFami, 1 )
	cCodFamHasta	:= dbLast ( dbfFami, 1 )

	/*
	Caja de dialogo
	*/

	DEFINE DIALOG oDlg RESOURCE "INF_VALALM"

	REDEFINE GET oCodAlm VAR cCodAlm ;
		ID 		100 ;
		VALID 	cAlmacen( oCodAlm, nil, oCodAlmTxt );
      BITMAP   "LUPA" ;
      ON HELP  BrwAlmacen( oCodAlm, nil, oCodAlmTxt );
		OF 		oDlg

	REDEFINE GET oCodAlmTxt VAR cCodAlmTxt ;
		WHEN 		.F.;
		ID 		105 ;
		OF 		oDlg

	REDEFINE GET oCodFamDesde VAR cCodFamDesde;
		ID 		110 ;
		VALID 	( cFamilia( oCodFamDesde, , oTxtFamDesde ) );
      BITMAP   "LUPA" ;
      ON HELP  ( BrwFamilia( oCodFamDesde, oTxtFamDesde ) );
		OF 		oDlg

	REDEFINE GET oTxtFamDesde VAR cTxtFamDesde ;
		WHEN 		.F.;
		ID 		120 ;
		COLOR 	CLR_GET ;
		OF 		oDlg

	REDEFINE GET oCodFamHasta VAR cCodFamHasta;
		ID 		130 ;
		VALID 	( cFamilia( oCodFamHasta, , oTxtFamHasta ) );
      BITMAP   "LUPA" ;
      ON HELP  ( BrwFamilia( oCodFamHasta, oTxtFamHasta ) );
		OF 		oDlg

	REDEFINE GET oTxtFamHasta VAR cTxtFamHasta ;
		WHEN 		.F.;
		ID 		140 ;
		COLOR 	CLR_GET ;
		OF 		oDlg

	REDEFINE RADIO nRadCoste ;
      ID       150, 151, 152, 153 ;
		OF 		oDlg

	REDEFINE GET cTitulo ;
		ID 		170 ;
		OF 		oDlg

	REDEFINE GET cSubTitulo ;
		ID 		180 ;
		OF 		oDlg

	REDEFINE BUTTON ;
		ID 		508;
		OF 		oDlg ;
      ACTION ( oDlg:disable(),;
               GenRptVal( cCodAlm, cCodFamDesde, cCodFamHasta, nRadCoste, oMtrInf, cTitulo, cSubTitulo, 1 ),;
               oDlg:enable() )

	REDEFINE BUTTON ;
		ID 		505;
		OF 		oDlg ;
      ACTION ( oDlg:disable(),;
               GenRptVal( cCodAlm, cCodFamDesde, cCodFamHasta, nRadCoste, oMtrInf, cTitulo, cSubTitulo, 2 ),;
               oDlg:enable() )

   REDEFINE BUTTON oBtnCancel ;
		ID 		510;
		OF 		oDlg ;
		ACTION ( oDlg:end() )

   ACTIVATE DIALOG oDlg CENTER ON PAINT ( oCodAlm:lValid(), oCodFamDesde:lValid(), oCodFamHasta:lValid() )

	CLOSE ( dbfArticulo )
	CLOSE ( dbfFami )

RETURN NIL

//---------------------------------------------------------------------------//

STATIC FUNCTION GenRptVal( cCodAlm, cFamOrg, cFamDes, nRadCoste, oMtrInf, cTitulo, cSubTitulo, nDevice )

	local dbfMov
	local DbfFacPrvL
	local oFont1
	local oFont2
	local oFont3
   local cText    := ""
	local nOrdAnt	:= ( dbfArticulo )->( OrdSetFocus( "CFAMCOD" ) )
	local nRecNo	:= ( dbfArticulo )->( RecNo() )

   do case
      case nRadCoste == 1
         cText := "Coste medio"
      case nRadCoste == 2
         cText := "Ultimo coste"
      case nRadCoste == 3
         cText := "P.V.P."
      case nRadCoste == 4
         cText := "P.V.P."
   end do

   ( dbfArticulo )->( dbGoTop() )

   USE ( cPatEmp() + "FACPRVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVL", @dbfFacPrvL ) )
   SET ADSINDEX TO ( cPatEmp() + "FACPRVL.CDX" ) ADDITIVE
	( DbfFacPrvL )->( OrdSetFocus( 2 ) )

   USE ( cPatEmp() + "MOVALM.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "MOVALM", @dbfMov ) )
   SET ADSINDEX TO ( cPatEmp() + "MOVALM.CDX" ) ADDITIVE

	/*
	Tipos de Letras
	*/

	DEFINE FONT oFont1 NAME "Courier New" SIZE 0,-12 BOLD
   DEFINE FONT oFont2 NAME "Courier New" SIZE 0,-10
   DEFINE FONT oFont3 NAME "Arial" SIZE 0,-10 BOLD

	IF nDevice == 1

		REPORT oReport ;
			TITLE  	Rtrim( cTitulo ),;
						Rtrim( cSubTitulo ),;
                  "Almacen : " + cCodAlm,;
                  "Utilizando " + cText ;
			HEADER 	"Fecha : " + Dtoc( Date() ) RIGHT ;
			FONT   	oFont1, oFont2, oFont3 ;
         FOOTER   "Página : " + str( oReport:nPage, 3 ) CENTERED;
         CAPTION  "Valoración de almacen";
			PREVIEW

	ELSE

		REPORT oReport ;
			TITLE  	Rtrim( cTitulo ),;
						Rtrim( cSubTitulo ),;
						"Almacen : " + cCodAlm ;
			HEADER 	"Fecha : " + Dtoc( Date() ) RIGHT ;
			FONT   	oFont1, oFont2, oFont3 ;
         FOOTER   "Página : " + str( oReport:nPage, 3 ) CENTERED;
         CAPTION  "Valoración de almacen";
         TO PRINTER

	END IF

         COLUMN TITLE "Codigo" ;
				DATA 		(dbfArticulo)->CODIGO ;
				SIZE 		12 ;
				FONT 		2

			COLUMN TITLE "Descripción" ;
				DATA 		(dbfArticulo)->NOMBRE ;
				SIZE 		34 ;
				FONT 		2

         COLUMN TITLE cText;
				DATA 		nRetPrecio( (dbfArticulo)->CODIGO, DbfFacPrvL, nRadCoste );
            PICTURE  PicOut();
				SIZE 		8 ;
				FONT 		2

			COLUMN TITLE "Stock" ;
				DATA 		nTotStock( dbfMov, (dbfArticulo)->CODIGO, nil, cCodAlm );
            PICTURE  MasUnd();
				SIZE 		8 ;
				TOTAL ;
				FONT 		2

			COLUMN TITLE "Und." ;
				DATA 		(dbfArticulo)->CUNIDAD ;
            PICTURE  MasUnd();
				SIZE 		3 ;
				FONT 		2

			COLUMN TITLE "Valor Stock." ;
				DATA 		nRetPrecio( (dbfArticulo)->CODIGO, DbfFacPrvL, nRadCoste ) * nTotStock( dbfMov, (dbfArticulo)->CODIGO, nil, cCodAlm ) ;
            PICTURE  PicOut() ;
				SIZE 		10 ;
				TOTAL ;
				FONT 		2

         COLUMN TITLE "%Bnf. PVD" ;
            DATA     (dbfArticulo)->BENEF1 ;
            PICTURE  "@E 99,99" ;
            SIZE     8 ;
				FONT 		2

         COLUMN TITLE "%Bnf. PVP" ;
            DATA     (dbfArticulo)->BENEF3 ;
            PICTURE  "@E 99,99" ;
            SIZE     8 ;
				FONT 		2

		GROUP ON ( dbfArticulo )->FAMILIA ;
				HEADER	"Familia : " + oReport:aGroups[1]:cValue + "-" + ;
							retFamilia( oReport:aGroups[1]:cValue, dbfFami ) ;
            FOOTER   "Total de artículos en familia " + ;
							"(" + ltrim( str( oReport:aGroups[1]:nCounter ) ) + ")" ;
				FONT 3

	END REPORT

	IF oReport:lCreated
		oReport:Margin( 0, RPT_RIGHT, RPT_CMETERS )
		oReport:bSkip	:= {|| (dbfArticulo)->(DbSkip( 1 )) }
	END IF

	ACTIVATE REPORT oReport;
      FOR   ( dbfArticulo )->( &( OrdKey() ) ) >= cFamOrg .AND. ;
            ( dbfArticulo )->( &( OrdKey() ) ) <= cFamDes .AND. ;
				nTotStock( dbfMov, (dbfArticulo)->CODIGO, nil, cCodAlm ) != 0 ;
		WHILE !(dbfArticulo)->( eof() )

	( dbfArticulo )->( OrdSetFocus( nOrdAnt ) )
	( dbfArticulo )->( dbGoto( nRecNo ) )

	CLOSE ( DbfFacPrvL )
	CLOSE ( dbfMov )

	oFont1:end()
	oFont2:end()
	oFont3:end()

RETURN NIL

//---------------------------------------------------------------------------//

STATIC FUNCTION nRetPrecio( cCodArt, DbfFacPrvL, nTipPrecio )

	local nPreMed 	:= 0

	IF nTipPrecio == 1	// Precio Medio
		nPreMed := nRetPreMed( DbfFacPrvL, cCodArt )
   ELSEIF nTipPrecio == 2    // Precio de Costo
		nPreMed := nRetPreCosto( dbfArticulo, cCodArt )
   ELSEIF nTipPrecio == 3    // Precio de Distribución
      nPreMed := ( dbfArticulo )->PVENTA1
   ELSEIF nTipPrecio == 4    // Precio de Público
      nPreMed := ( dbfArticulo )->PVENTA3
	END IF

RETURN ( nPreMed )

//---------------------------------------------------------------------------//

/*
Devuelve el coste promedio de un articulo
*/

FUNCTION nRetPreMed( DbfFacPrvL, cCodArt )

	local nPreMed 	:= 0
	local nUnits	:= 0

	IF ( DbfFacPrvL )->( dbSeek( cCodArt ) )

		WHILE	( DbfFacPrvL )->CREF == cCodArt .AND. !( DbfFacPrvL )->( Eof() )

			nPreMed += nUnitEnt( DbfFacPrvL ) * ( DbfFacPrvL )->NPREUNIT
			nUnits  += nUnitEnt( DbfFacPrvL )

			( DbfFacPrvL )->( DbSkip() )

		END WHILE

		nPreMed := nPreMed / nUnits

	END IF

RETURN nPreMed

//---------------------------------------------------------------------------//

FUNCTION InfStocks( oMenuItem, oWnd )

	local oDlg
   local oMtrInf
   local oAlmDes
   local cAlmHas
   local oAlmDesTxt
   local cAlmDesTxt
   local oAlmHasTxt
   local cAlmHasTxt
   local oFamDesde
   local cFamOrg
   local oTxtFamDesde
   local cTxtFamDesde
   local oFamHasta
   local cFamDes
   local oTxtFamHasta
   local cTxtFamHasta
   local cPrvDesde
   local cPrvHasta
   local oPrvDesde
   local oPrvHasta
   local cNomPrvDesde
   local cNomPrvHasta
   local oNomPrvDesde
   local oNomPrvHasta
   local oRadOrd
   local nRadOrd     := 1
   local nMtrInf     := 0
   local cTitulo     := Padr( cCodEmp() + " - " + cNbrEmp(), 50 )
   local cSubTitulo  := Padr( "Artículos bajo minimo", 50 )

   DEFAULT oMenuitem := "01044"
   DEFAULT oWnd      := oWnd()

   if Auth():Level( oMenuItem ) != 1
      msgStop( "Acceso no permitido." )
      return nil
   end if

   /*
   Cerramos todas las ventanas
   */

   if oWnd != nil
      SysRefresh(); oWnd:CloseAll(); SysRefresh()
   end if

	/*
	Bases de datos para el informe
	*/

   USE ( cPatEmp() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
   SET ADSINDEX TO ( cPatEmp() + "ARTICULO.CDX" ) ADDITIVE
   ( dbfArticulo )->( ordSetFocus( "CFAMCOD" ) )

   USE ( cPatEmp() + "FAMILIAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FAMILIAS", @dbfFami ) )
   SET ADSINDEX TO ( cPatEmp() + "FAMILIAS.CDX" ) ADDITIVE

   USE ( cPatEmp() + "ALMACEN.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALMACEN", @dbfAlmacen ) )
   SET ADSINDEX TO ( cPatEmp() + "ALMACEN.CDX" ) ADDITIVE

   USE ( cPatEmp() + "PROVEE.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROVEE", @dbfProvee ) )
   SET ADSINDEX TO ( cPatEmp() + "PROVEE.CDX" ) ADDITIVE

   USE ( cPatEmp() + "MOVALM.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "MOVALM", @dbfMov ) )
   SET ADSINDEX TO ( cPatEmp() + "MOVALM.CDX" ) ADDITIVE

	/*
   Obtenemos los valores del primer y ultimo igo
	*/

   cFamOrg   := dbFirst( dbfFami, 1 )
   cFamDes   := dbLast ( dbfFami, 1 )

   cAlmDes     := dbFirst( dbfAlmacen, 1 )
   cAlmHas     := dbLast ( dbfAlmacen, 1 )

   cPrvDesde   := dbFirst( dbfProvee, 1 )
   cPrvHasta   := dbLast( dbfProvee, 1 )

   /*
	Caja de dialogo
	*/

   DEFINE DIALOG oDlg RESOURCE "INF_STOCK"

   REDEFINE GET oAlmDes VAR cAlmDes ;
		ID 		100 ;
      VALID    cAlmacen( oAlmDes, dbfAlmacen, oAlmDesTxt );
      BITMAP   "LUPA" ;
      ON HELP  BrwAlmacen( oAlmDes, dbfAlmacen, oAlmDesTxt );
		OF 		oDlg

   REDEFINE GET oAlmDesTxt VAR cAlmDesTxt ;
		WHEN 		.F.;
      ID       101 ;
		OF 		oDlg

   REDEFINE GET oAlmHas VAR cAlmHas ;
      ID       110 ;
      VALID    cAlmacen( oAlmHas, dbfAlmacen, oAlmHasTxt );
      BITMAP   "LUPA" ;
      ON HELP  BrwAlmacen( oAlmHas, dbfAlmacen, oAlmHasTxt );
		OF 		oDlg

   REDEFINE GET oAlmHasTxt VAR cAlmHasTxt ;
		WHEN 		.F.;
      ID       111 ;
		OF 		oDlg

   REDEFINE GET oPrvDesde VAR cPrvDesde;
      ID       170 ;
		COLOR 	CLR_GET ;
      VALID    ( cProvee( oPrvDesde, dbfProvee, oNomPrvDesde ) ) ;
      BITMAP   "LUPA" ;
      ON HELP  ( BrwProvee( oPrvDesde, oNomPrvDesde ) ) ;
		OF 		oDlg

   REDEFINE GET oNomPrvDesde VAR cNomPrvDesde ;
		WHEN 		.F. ;
		COLOR 	CLR_GET ;
      ID       171 ;
		OF 		oDlg

   REDEFINE GET oPrvHasta VAR cPrvHasta;
      ID       180 ;
		COLOR 	CLR_GET ;
      VALID    ( cProvee( oPrvHasta, dbfProvee, oNomPrvHasta ) ) ;
      BITMAP   "LUPA" ;
      ON HELP  ( BrwProvee( oPrvHasta, oNomPrvHasta ) ) ;
		OF 		oDlg

   REDEFINE GET oNomPrvHasta VAR cNomPrvHasta ;
		WHEN 		.F. ;
		COLOR 	CLR_GET ;
      ID       181 ;
		OF 		oDlg

   REDEFINE GET oFamDesde VAR cFamOrg;
      ID       120 ;
      VALID    ( cFamilia( oFamDesde, dbfFami, oTxtFamDesde ) );
      BITMAP   "LUPA" ;
      ON HELP  ( BrwFamilia( oFamDesde, oTxtFamDesde ) );
		OF 		oDlg

	REDEFINE GET oTxtFamDesde VAR cTxtFamDesde ;
		WHEN 		.F.;
      ID       121 ;
		COLOR 	CLR_GET ;
		OF 		oDlg

   REDEFINE GET oFamHasta VAR cFamDes;
		ID 		130 ;
      VALID    ( cFamilia( oFamHasta, dbfFami, oTxtFamHasta ) );
      BITMAP   "LUPA" ;
      ON HELP  ( BrwFamilia( oFamHasta, oTxtFamHasta ) );
		OF 		oDlg

	REDEFINE GET oTxtFamHasta VAR cTxtFamHasta ;
      WHEN     .F.;
      ID       131 ;
		COLOR 	CLR_GET ;
		OF 		oDlg

	REDEFINE GET cTitulo ;
      ID       140 ;
		OF 		oDlg

	REDEFINE GET cSubTitulo ;
      ID       150 ;
		OF 		oDlg

   REDEFINE RADIO oRadOrd VAR nRadOrd ;
      ID       160, 161 ;
      OF       oDlg ;

	REDEFINE APOLOMETER oMtrInf ;
		VAR 	nMtrInf ;
		PROMPT	"Procesando" ;
      	ID       400;
		OF 		oDlg ;
      	TOTAL    100

	REDEFINE BUTTON ;
		ID 		508;
		OF 		oDlg ;
      ACTION ( oDlg:disable(),;
               GenInfStk( cAlmDes, cAlmHas, cPrvDesde, cPrvHasta, cFamOrg, cFamDes, oMtrInf, nRadOrd, cTitulo, cSubTitulo, 1 ),;
               oDlg:enable() )

	REDEFINE BUTTON ;
		ID 		505;
		OF 		oDlg ;
      ACTION ( oDlg:disable(),;
               GenInfStk( cAlmDes, cAlmHas, cPrvDesde, cPrvHasta, cFamOrg, cFamDes, oMtrInf,  nRadOrd, cTitulo, cSubTitulo, 2 ),;
               oDlg:enable() )

   REDEFINE BUTTON oBtnCancel ;
		ID 		510;
		OF 		oDlg ;
		ACTION ( oDlg:end() )

   ACTIVATE DIALOG oDlg CENTER ;
      ON PAINT ( oAlmDes:lValid(), oAlmHas:lValid(), oPrvDesde:lValid(), oPrvHasta:lValid(), oFamDesde:lValid(), oFamHasta:lValid() )

	CLOSE ( dbfArticulo )
   CLOSE ( dbfFami     )
   CLOSE ( dbfAlmacen  )
   CLOSE ( dbfMov      )
   CLOSE ( dbfProvee   )

RETURN NIL

//---------------------------------------------------------------------------//

STATIC FUNCTION GenInfStk( cAlmDes, cAlmHas, cPrvDesde, cPrvHasta, cFamDes, cFamHas, oMtrInf, nRadOrd, cTitulo, cSubTitulo, nDevice )

   local dbfTmp
	local oFont1
	local oFont2
	local oFont3
   local nMet     := 0
   local nRecno   := ( dbfArticulo )->( recno() )
	local nOrdAnt	:= ( dbfArticulo )->( OrdSetFocus( "CFAMCOD" ) )
   local aDbf     := {  { "CCODALM", "C",  3, 0 },;
                        { "CCODPRV", "C", 12, 0 },;
                        { "CFAMART", "C",  5, 0 },;
                        { "CCODART", "C", 18, 0 },;
                        { "CNOMART", "C",100, 0 },;
                        { "NNUMUND", "N", 16, 6 },;
                        { "NUNDMIN", "N", 16, 6 } }

   IF file( cPatTmp() + "INFMOV.DBF" )
      ferase( cPatTmp() + "INFMOV.DBF" )
   END IF

   dbCreate( cPatTmp() + "INFMOV.DBF", aDbf, cDriver() )
   dbUseArea( .t., cDriver(), cPatTmp() + "INFMOV.DBF", cCheckArea( "INFMOV", @dbfTmp ), .f. )
   ordCreate( cPatTmp() + "INFMOV.CDX", "CCODALM", "CCODALM + CCODPRV + CFAMART", {|| CCODALM + CCODPRV + CFAMART } )
   ordListAdd( cPatTmp() + "INFMOV.CDX" )

   oMtrInf:SetTotal( ( dbfArticulo )->( lastrec() ) )

   ( dbfAlmacen )->( dbSeek( cAlmDes ) )

   WHILE ( dbfAlmacen )->CCODALM >= cAlmDes .AND. ( dbfAlmacen )->CCODALM <= cAlmHas .AND. !( dbfAlmacen )->( eof() )

      ( dbfArticulo )->( dbGoTop() )

      WHILE !( dbfArticulo )->( eof() )

         IF ( dbfArticulo )->NCTLSTOCK == 1     .AND. ;
            ( dbfArticulo )->FAMILIA >= cFamDes .AND.;
            ( dbfArticulo )->FAMILIA <= cFamHas .AND.;
            ( if( nRadOrd == 1, ( dbfArticulo )->NMINIMO > retStock( ( dbfArticulo )->CODIGO, ( dbfAlmacen )->CCODALM, dbfMov ), .t. ) )

            ( dbfTmp )->( dbAppend() )
            ( dbfTmp )->CCODALM := ( dbfAlmacen  )->CCODALM
            ( dbfTmp )->CFAMART := ( dbfArticulo )->FAMILIA
            ( dbfTmp )->CCODART := ( dbfArticulo )->CODIGO
            ( dbfTmp )->CNOMART := ( dbfArticulo )->NOMBRE
            ( dbfTmp )->NNUMUND := retStock( ( dbfArticulo )->CODIGO, ( dbfAlmacen )->CCODALM, dbfMov )
            ( dbfTmp )->NUNDMIN := ( dbfArticulo )->NMINIMO
            ( dbfTmp )->CCODPRV := ( dbfArticulo )->CPRVHAB

         END IF

         ( dbfArticulo )->( dbSkip() )
         oMtrInf:Set( ++nMet )

      END DO

      ( dbfAlmacen )->( dbSkip() )

   END DO

	/*
   Comienza el listado _________________________________________________________
	*/

   ( dbfTmp )->( dbGoTop() )

	/*
   Tipos de Letras_____________________________________________________________
	*/

	DEFINE FONT oFont1 NAME "Courier New" SIZE 0,-12 BOLD
   DEFINE FONT oFont2 NAME "Courier New" SIZE 0,-10
   DEFINE FONT oFont3 NAME "Arial" SIZE 0,-10 BOLD

	IF nDevice == 1

		REPORT oReport ;
			TITLE  	Rtrim( cTitulo ),;
                  Rtrim( cSubTitulo );
			HEADER 	"Fecha : " + Dtoc( Date() ) RIGHT ;
			FONT   	oFont1, oFont2, oFont3 ;
         FOOTER   "Página : " + str( oReport:nPage, 3 ) CENTERED;
         CAPTION  "Informe de stocks bajo minimos";
			PREVIEW

	ELSE

		REPORT oReport ;
			TITLE  	Rtrim( cTitulo ),;
                  Rtrim( cSubTitulo );
			HEADER 	"Fecha : " + Dtoc( Date() ) RIGHT ;
			FONT   	oFont1, oFont2, oFont3 ;
         FOOTER   "Página : " + str( oReport:nPage, 3 ) CENTERED;
         CAPTION  "Informe de stocks bajo minimos";
         TO PRINTER

	END IF

         COLUMN TITLE "Codigo" ;
            DATA     ( dbfTmp )->CCODART ;
				SIZE 		12 ;
				FONT 		2

			COLUMN TITLE "Descripción" ;
            DATA     ( dbfTmp )->CNOMART ;
				SIZE 		34 ;
				FONT 		2

         COLUMN TITLE "Und.";
            DATA     ( dbfTmp )->NNUMUND ;
				PICTURE 	"@E 999,999,999";
				SIZE 		8 ;
				TOTAL ;
				FONT 		2

         COLUMN TITLE "Stock Min." ;
            DATA     ( dbfTmp )->NUNDMIN ;
            PICTURE  "@E 999,999,999";
				SIZE 		8 ;
				FONT 		2


      GROUP ON ( dbfTmp )->CCODALM ;
            HEADER   "Almacen : " + oReport:aGroups[1]:cValue + "-" + ;
                     retAlmacen( oReport:aGroups[1]:cValue, dbfAlmacen ) ;
            FOOTER   "Total de artículos en almacen " + ;
							"(" + ltrim( str( oReport:aGroups[1]:nCounter ) ) + ")" ;
            EJECT ;
				FONT 3

      GROUP ON ( dbfTmp )->CCODALM + ( dbfTmp )->CCODPRV ;
            HEADER   "Proveedor : " + ( dbfTmp )->CCODPRV + "-" + ;
                     retProvee( ( dbfTmp )->CCODPRV ) ;
            FOOTER   "Total de artículos proveedor " + ;
                     "(" + ltrim( str( oReport:aGroups[2]:nCounter ) ) + ")" ;
				FONT 3

	END REPORT

	IF oReport:lCreated
		oReport:Margin( 0, RPT_RIGHT, RPT_CMETERS )
      oReport:bSkip  := {|| ( dbfTmp )->( dbSkip( 1 ) ) }
	END IF

   ACTIVATE REPORT oReport  WHILE !( dbfTmp )->( eof() )

   CLOSE ( dbfTmp )
   ferase( cPatTmp() + "INFMOV.DBF" )

   oMtrInf:Set( 0 )

	oFont1:end()
	oFont2:end()
	oFont3:end()

RETURN NIL

//---------------------------------------------------------------------------//





































