#include "FiveWin.Ch"
#include "Font.ch"
#include "Report.ch"
#include "Factu.ch" 

static dbfArticulo
static dbfAlbPrvT
static dbfAlbPrvL
static dbfFacPrvT
static dbfFacPrvL
static dbfPedCliT
static dbfPedCliL
static dbfAlbCliT
static dbfAlbCliL
static dbfFacCliT
static dbfFacCliL
static dbfPreCliT
static dbfPreCliL
static dbfHisMov
static dbfFPago
static dbfAlmT
static dbfTikT
static dbfTikL
static dbfMov
static dbfTmp
static dbfIva
static dbfClient
static dbfDivisa

//---------------------------------------------------------------------------//

FUNCTION AlmValor( oMenuItem, oWnd )

	local oDlg
	local oBntPrev
	local oBtnImpr
	local oBtnCancel
	local oArticulo1, cArticulo1
	local oArticulo2, cArticulo2
	local oArtText1, cArtText1
	local oArtText2, cArtText2
	local nPrecio		:= 1
   local cTitulo     := Padr( cCodEmp() + " - " + cNbrEmp(), 100 )
   local cSubTitulo  := Padr( "Precios de artículos", 100 )

   DEFAULT oMenuitem := "01046"
   DEFAULT oWnd      := oWnd()

   if nLevelUsr( oMenuItem ) != 1
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

   USE ( cPatArt() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
   SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

   USE ( cPatEmp() + "MOVALM.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "MOVALM", @dbfMov ) )
   SET ADSINDEX TO ( cPatEmp() + "MOVALM.CDX" ) ADDITIVE

	/*
	Obtenemos los valores del primer y ultimo codigo
	*/

	cArticulo1 := (dbfArticulo)->CODIGO
	(dbfArticulo)->( dbGoBottom())
	cArticulo2 := (dbfArticulo)->CODIGO
	(dbfArticulo)->( dbGoTop())

	/*
	Caja de dialogo
	*/

	DEFINE DIALOG oDlg RESOURCE "INF_VALORACION"

	REDEFINE GET oArticulo1 VAR cArticulo1;
		ID 		110 ;
		VALID 	cArticulo( oArticulo1, dbfArticulo, oArtText1 );
      BITMAP   "LUPA" ;
		ON HELP 	BrwArticulo( oArticulo1, oArtText1 );
		OF 		oDlg

	REDEFINE GET oArtText1 VAR cArtText1 ;
		WHEN 		.F.;
		ID 		120 ;
		OF 		oDlg

	REDEFINE GET oArticulo2 VAR cArticulo2;
		ID 		130 ;
		VALID 	cArticulo( oArticulo2, dbfArticulo, oArtText2 );
      BITMAP   "LUPA" ;
		ON HELP 	BrwArticulo( oArticulo2, oArtText2 );
		OF 		oDlg

	REDEFINE GET oArtText2 VAR cArtText2 ;
		WHEN 		.F.;
		ID 		140 ;
		OF 		oDlg

	REDEFINE RADIO nPrecio ;
		ID 		150, 151 ;
		OF 		oDlg

	REDEFINE GET cTitulo ;
		ID 		170 ;
		OF 		oDlg

	REDEFINE GET cSubTitulo ;
		ID 		180 ;
		OF 		oDlg

	REDEFINE BUTTON oBtnPrev ;
      ID       508;
		OF 		oDlg ;
      ACTION ( oDlg:disable(),;
					GenAlmMov( cArticulo1, cArticulo2, nPrecio, cTitulo, cSubTitulo, 1 ),;
               oDlg:enable() )

	REDEFINE BUTTON oBtnImpr ;
		ID 		505;
		OF 		oDlg ;
      ACTION ( oDlg:disable(),;
					GenAlmMov( cArticulo1, cArticulo2, nPrecio, cTitulo, cSubTitulo, 2 ),;
               oDlg:enable() )

	REDEFINE BUTTON oBtnCancel ;
      ID       510;
		OF 		oDlg ;
		ACTION ( oDlg:end() )

   ACTIVATE DIALOG oDlg CENTER ON PAINT ( oArticulo1:lValid(), oArticulo2:lValid() )

	CLOSE ( dbfArticulo )
	CLOSE ( dbfMov )

RETURN NIL

//-------------------------------------------------------------------------//

STATIC FUNCTION GenAlmMov( cArt1, cArt2, nPrecio, cTitulo, cSubTitulo, nDevice )

	local oFont1
	local oFont2

	(dbfArticulo)->( DbSeek( cArt1 ) )

	/*
	Tipos de Letras
	*/

	DEFINE FONT oFont1 NAME "Courier New" SIZE 0,-12 BOLD
   DEFINE FONT oFont2 NAME "Courier New" SIZE 0,-10

	IF nDevice == 1

		REPORT oReport ;
			FONT   	oFont1, oFont2 ;
			TITLE  	Rtrim( cTitulo ),;
						Rtrim( cSubTitulo ) ;
			HEADER 	"Fecha : " + Dtoc( Date() ) RIGHT ;
         FOOTER   "Página : " + str( oReport:nPage, 3 ) CENTERED;
			CAPTION 	"Precios de Artículos";
			PREVIEW

	ELSE

		REPORT oReport ;
			FONT   	oFont1, oFont2 ;
			TITLE  	Rtrim( cTitulo ),;
						Rtrim( cSubTitulo ) ;
			HEADER 	"Fecha : " + Dtoc( Date() ) RIGHT ;
         FOOTER   "Página : " + str( oReport:nPage, 3 ) CENTERED;
			CAPTION 	"Precios de Artículos";
         TO PRINTER

	END IF

      COLUMN TITLE "Codigo" ;
			DATA (dbfArticulo)->CODIGO ;
			SIZE 10 ;
			FONT 2

		COLUMN TITLE "Descripción" ;
			DATA 		(dbfArticulo)->NOMBRE ;
			SIZE 		38 ;
			FONT 2

		COLUMN TITLE "Importe" ;
			DATA 		If( nPrecio == 1, (dbfArticulo)->PVENTA1, (dbfArticulo)->PVENTA3 ) ;
			PICTURE 	"@E 99,999,999";
			SIZE 		8 ;
			FONT 		2

		COLUMN TITLE "Und." ;
			DATA 		nTotStock( dbfMov, (dbfArticulo)->CODIGO ) ;
			PICTURE 	"@E 99,999,999";
			SIZE 		6 ;
			FONT 		2

		COLUMN TITLE "Total" ;
			DATA 		If( nPrecio == 1, (dbfArticulo)->PVENTA1, (dbfArticulo)->PVENTA3 ) ;
							* nTotStock( dbfMov, (dbfArticulo)->CODIGO ) ;
			PICTURE 	"@E 999,999,999";
			SIZE 		8 ;
			FONT 		2 ;
			TOTAL

	END REPORT

	IF oReport:lCreated
		oReport:Margin( 0, RPT_RIGHT, RPT_CMETERS )
		oReport:bSkip	:= {|| ( dbfArticulo )->( DbSkip( 1 ) ) }
	END IF

	ACTIVATE REPORT oReport;
		FOR 	(dbfArticulo)->CODIGO >= cArt1 .AND.;
				(dbfArticulo)->CODIGO <= cArt2 ;
		WHILE !(dbfArticulo)->(Eof())

	oFont1:end()
	oFont2:end()

RETURN NIL

//---------------------------------------------------------------------------//

/*
Informe que presenta detallado todos los movimientos
*/

FUNCTION InfDetMov( oMenuItem, oWnd )

	local oDlg
	local oBntPrev
	local oBtnImpr
	local oBtnCancel
	local oArticulo1, cArticulo1
	local oArticulo2, cArticulo2
	local oArtText1, cArtText1
	local oArtText2, cArtText2
	local oDesde
	local oHasta
   local oMtrInf
   local nMtrInf     := 0
   local cTitulo     := Padr( cCodEmp() + " - " + cNbrEmp(), 100 )
   local cSubTitulo  := Padr( "Detalle de movimientos de artículos", 100 )
	local nMeter		:= 0
	local dDesde		:= CtoD( "01/01/" + Str( Year( Date() ) ) )
	local dHasta		:= Date()
	local lResumen		:= .f.
	local lExcCero		:= .f.
   local oAlmOrg
   local cAlmOrg
   local oAlmDes
   local cAlmDes
   local oSayDes
   local cSayDes
   local cSayOrg
   local oSayOrg

   DEFAULT oMenuitem := "01043"
   DEFAULT oWnd      := oWnd()

   if nLevelUsr( oMenuItem ) != 1
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

	dbCommitAll()

   USE ( cPatArt() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
   SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

   USE ( cPatAlm() + "ALMACEN.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALMACEN", @dbfAlmT ) )
   SET ADSINDEX TO ( cPatAlm() + "ALMACEN.CDX" ) ADDITIVE

	/*
	Obtenemos los valores del primer y ultimo codigo
	*/

   cArticulo1  := dbFirst( dbfArticulo, 1 )
   cArticulo2  := dbLast( dbfArticulo, 1 )

   cAlmOrg     := dbFirst( dbfAlmT, 1 )
   cAlmDes     := dbLast( dbfAlmT, 1 )

	/*
	Caja de dialogo
	*/

	DEFINE DIALOG oDlg RESOURCE "INF_MOVIMIENTOS"

   REDEFINE GET oAlmOrg VAR cAlmOrg;
      ID       70;
      VALID    cAlmacen( oAlmOrg, dbfAlmT, oSayOrg ) ;
      BITMAP   "LUPA" ;
      ON HELP  BrwAlmacen( oAlmOrg, oSayOrg ) ;
		COLOR 	CLR_GET ;
		OF 		oDlg

   REDEFINE GET oSayOrg VAR cSayOrg ;
      ID       80 ;
      WHEN     .F.;
      COLOR    CLR_GET ;
		OF 		oDlg

   REDEFINE GET oAlmDes VAR cAlmDes;
      ID       90;
      VALID    cAlmacen( oAlmDes, dbfAlmT, oSayDes ) ;
      BITMAP   "LUPA" ;
      ON HELP  BrwAlmacen( oAlmDes, oSayDes ) ;
		COLOR 	CLR_GET ;
		OF 		oDlg

   REDEFINE GET oSayDes VAR cSayDes ;
		WHEN 		.F.;
      ID       100 ;
		OF 		oDlg

   REDEFINE GET oArticulo1 VAR cArticulo1;
      ID       110 ;
      VALID    cArticulo( oArticulo1, dbfArticulo, oArtText1 );
      BITMAP   "LUPA" ;
      ON HELP  BrwArticulo( oArticulo1, oArtText1 );
		OF 		oDlg

   REDEFINE GET oArtText1 VAR cArtText1 ;
		WHEN 		.F.;
      ID       120 ;
		OF 		oDlg

	REDEFINE GET oArticulo2 VAR cArticulo2;
		ID 		130 ;
		VALID 	cArticulo( oArticulo2, dbfArticulo, oArtText2 );
      BITMAP   "LUPA" ;
		ON HELP 	BrwArticulo( oArticulo2, oArtText2 );
		OF 		oDlg

	REDEFINE GET oArtText2 VAR cArtText2 ;
		WHEN 		.F.;
		ID 		140 ;
		OF 		oDlg

	REDEFINE GET oDesde VAR dDesde;
		SPINNER ;
		ID 		150 ;
		OF 		oDlg

	REDEFINE GET oHasta VAR dHasta;
		SPINNER ;
		ID 		160 ;
		OF 		oDlg

   REDEFINE GET cTitulo ;
		ID 		170 ;
		OF 		oDlg

	REDEFINE GET cSubTitulo ;
		ID 		180 ;
		OF 		oDlg

	REDEFINE CHECKBOX lResumen ;
		ID 		190 ;
		OF 		oDlg

	REDEFINE CHECKBOX lExcCero ;
		ID 		200 ;
		OF 		oDlg

	/*----------------------------------------------------------------------------//
REDEFINE APOLOMETER oMtrInf ;
		VAR 		nMtrInf ;
		PROMPT	"Procesando" ;
      ID       210;
		OF 		oDlg ;
      TOTAL    100

	REDEFINE BUTTON oBtnPrev ;
      ID       508;
		OF 		oDlg ;
      ACTION ( oDlg:disable(),;
               MkRptDet( cAlmOrg, cAlmDes, cArticulo1, cArticulo2, dDesde, dHasta, lResumen, lExcCero, oMtrInf, cTitulo, cSubTitulo, 1 ),;
               oDlg:enable() )

	REDEFINE BUTTON oBtnImpr ;
		ID 		505;
		OF 		oDlg ;
      ACTION ( oDlg:disable(),;
               MkRptDet( cAlmOrg, cAlmDes, cArticulo1, cArticulo2, dDesde, dHasta, lResumen, lExcCero, oMtrInf, cTitulo, cSubTitulo, 2 ),;
               oDlg:enable() )

	REDEFINE BUTTON oBtnCancel ;
      ID       510;
		OF 		oDlg ;
		ACTION ( oDlg:end() )

   ACTIVATE DIALOG oDlg CENTER ON PAINT ( oAlmOrg:lValid(), oAlmDes:lValid(), oArticulo1:lValid(), oArticulo2:lValid() )

	CLOSE ( dbfArticulo )
   CLOSE ( dbfAlmT     )

RETURN NIL

//---------------------------------------------------------------------------//

/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

STATIC FUNCTION MkRptDet( cAlm1, cAlm2, cArt1, cArt2, dDesde, dHasta, lResumen, lExcCero, oMtrInf, cTitulo, cSubTitulo, nDevice )

   local oDlg
   local dbfMov
	local dbfTmp
   local cRetCode
   local cPath    := cPatEmp()
   local aDbf     := {  { "CCODART", "C", 18, 0 },;
                        { "CCODALM", "C",  3, 0 },;
                        { "CCODCLI", "C", 12, 0 },;
								{ "CNOMCLI", "C", 50, 0 },;
                        { "NCAJENT", "N", 16, 6 },;
                        { "NCAJSAL", "N", 16, 6 },;
                        { "NUNTENT", "N", 16, 6 },;
                        { "NUNTSAL", "N", 16, 6 },;
                        { "CDOCMOV", "C", 14, 0 },;
                        { "CTIPMOV", "C", 10, 0 },;
								{ "DFECMOV", "D",  8, 0 } }

   /*
   Creamos las bases de datos temporales
   */

   if file( cPatTmp() + "INFMOV.DBF" )
      ferase( cPatTmp() + "INFMOV.DBF" )
   end if

   if file( cPatTmp() + "INFMOV.CDX" )
      ferase( cPatTmp() + "INFMOV.CDX" )
   end if

   dbCreate(   cPatTmp() + "INFMOV.DBF", aDbf, cDriver() )
   dbUseArea(  .t., cDriver(), cPatTmp() + "INFMOV.DBF", cCheckArea( "INFMOV", @dbfTmp ), .f. )
   ordCreate(  cPatTmp() + "INFMOV.CDX", "CCODART", "CCODALM + CCODART", {|| CCODALM + CCODART } )
   ordListAdd( cPatTmp() + "INFMOV.CDX" )

   /*
   Bases de datos de albaranes a proveedores
   */

   USE ( cPath + "ALBPROVT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBPROVL", @dbfAlbPrvT ) )
   SET ADSINDEX TO ( cPath + "ALBPROVT.CDX" ) ADDITIVE

   USE ( cPath + "ALBPROVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBPROVT", @dbfAlbPrvL ) )
   SET ADSINDEX TO ( cPath + "ALBPROVL.CDX" ) ADDITIVE

   oMtrInf:cText  := "Albaran de proveedores"
   oMtrInf:Set( ( dbfAlbPrvT )->( recno() ) )
   oMtrInf:SetTotal( ( dbfAlbPrvT )->( lastrec() ) )

	/*
	Nos movemos por las lineas de facturas de los proveedores
	*/

   WHILE (dbfAlbPrvT)->( !eof() )

      IF !(dbfAlbPrvT)->LFACTURADO                                                        .AND.;
         (dbfAlbPrvT)->DFECALB >= dDesde                                                  .AND.;
         (dbfAlbPrvT)->DFECALB <= dHasta                                                  .AND.;
         (dbfAlbPrvL)->( dbSeek( (dbfAlbPrvT)->CSERALB + Str( (dbfAlbPrvT)->NNUMALB ) + (dbfAlbPrvT)->CSUFALB ) ) .AND. ;
         ( (dbfAlbPrvT)->CCODALM >= cAlm1 .AND. (dbfAlbPrvT)->CCODALM <= cAlm2 )

         WHILE (dbfAlbPrvT)->CSERALB + Str( (dbfAlbPrvT)->NNUMALB ) + (dbfAlbPrvT)->CSUFALB == (dbfAlbPrvL)->CSERALB +  Str( (dbfAlbPrvL)->NNUMALB ) + (dbfAlbPrvL)->CSUFALB .AND.;
               !( dbfAlbPrvT )->( eof() )

            IF (dbfAlbPrvL)->CREF >= cArt1                     .AND.;
               (dbfAlbPrvL)->CREF <= cArt2                     .AND.;
               !( lExcCero .AND. (dbfAlbPrvL)->NPREDIV == 0 )

               (dbfTmp)->( dbAppend() )
               (dbfTmp)->CCODART := (dbfAlbPrvL)->CREF
               (dbfTmp)->CCODALM := (dbfAlbPrvT)->CCODALM
               (dbfTmp)->CCODCLI := (dbfAlbPrvT)->CCODPRV
               (dbfTmp)->CNOMCLI := (dbfAlbPrvT)->CNOMPRV
               (dbfTmp)->NCAJENT := (dbfAlbPrvL)->NCANENT
               (dbfTmp)->NUNTENT := NotCaja( (dbfAlbPrvL)->NCANENT ) * (dbfAlbPrvL)->NUNICAJA
               (dbfTmp)->CDOCMOV := (dbfAlbPrvT)->CSERALB + "/" + Str( (dbfAlbPrvT)->NNUMALB ) + "/" + (dbfAlbPrvT)->CSUFALB
               (dbfTmp)->CTIPMOV := "Albaran"
               (dbfTmp)->DFECMOV := (dbfAlbPrvT)->DFECALB

            END IF

            (dbfAlbPrvL)->( dbSkip() )

         END WHILE

      END IF

      (dbfAlbPrvT)->( dbSkip() )
      if ( dbfAlbPrvT )->( recno() ) % 10 == 0
         oMtrInf:Set( ( dbfAlbPrvT )->( recno() ) )
      end if

   END WHILE

   CLOSE ( dbfAlbPrvT )
   CLOSE ( dbfAlbPrvL )

   /*
	Nos movemos por las lineas de facturas de los proveedores
	*/

   USE ( cPath + "FACPRVT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVT", @dbfFacPrvT ) )
   SET ADSINDEX TO ( cPath + "FACPRVT.CDX" ) ADDITIVE

   USE ( cPath + "FACPRVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVL", @dbfFacPrvL ) )
   SET ADSINDEX TO ( cPath + "FACPRVL.CDX" ) ADDITIVE

   oMtrInf:cText  := "Factura de proveedores"
   oMtrInf:Set( ( dbfFacPrvT )->( recno() ) )
   oMtrInf:SetTotal( ( dbfFacPrvT )->( lastrec() ) )

   WHILE (dbfFacPrvT)->( !eof() )

      IF (dbfFacPrvT)->DFECFAC >= dDesde                                                  .AND.;
         (dbfFacPrvT)->DFECFAC <= dHasta                                                  .AND.;
         (dbfFacPrvL)->( dbSeek( (dbfFacPrvT)->CSERFAC + Str( (dbfFacPrvT)->NNUMFAC ) + (dbfFacPrvT)->CSUFFAC ) )    .AND. ;
         ( (dbfFacPrvT)->CCODALM >= cAlm1 .AND. (dbfFacPrvT)->CCODALM <= cAlm2 )


         WHILE (dbfFacPrvT)->CSERFAC + Str( (dbfFacPrvT)->NNUMFAC ) + (dbfFacPrvT)->CSUFFAC == (dbfFacPrvL)->CSERFAC + Str( (dbfFacPrvL)->NNUMFAC ) + (dbfFacPrvL)->CSUFFAC .AND.;
               !( dbfFacPrvT )->( eof() )

            IF (dbfFacPrvL)->CREF >= cArt1                                 .AND.;
               (dbfFacPrvL)->CREF <= cArt2                                 .AND.;
               !( lExcCero .AND. (dbfFacPrvL)->NPREUNIT == 0 )

               (dbfTmp)->( dbAppend() )
               (dbfTmp)->CCODART := (dbfFacPrvL)->CREF
               (dbfTmp)->CCODALM := (dbfFacPrvT)->CCODALM
               (dbfTmp)->CCODCLI := (dbfFacPrvT)->CCODPRV
               (dbfTmp)->CNOMCLI := (dbfFacPrvT)->CNOMPRV
               (dbfTmp)->NCAJENT := (dbfFacPrvL)->NCANENT
               (dbfTmp)->NUNTENT := If( (dbfFacPrvL)->NCANENT != 0, (dbfFacPrvL)->NCANENT, 1 ) * (dbfFacPrvL)->NUNICAJA
               (dbfTmp)->CDOCMOV := (dbfFacPrvT)->CSERFAC + "/" + Str( (dbfFacPrvT)->NNUMFAC ) + (dbfFacPrvT)->CSUFFAC
               (dbfTmp)->CTIPMOV := "Factura"
               (dbfTmp)->DFECMOV := (dbfFacPrvT)->DFECFAC

            END IF

            (dbfFacPrvL)->( dbSkip() )

         END WHILE

      END IF

      (dbfFacPrvT)->( dbSkip() )
      if ( dbfFacPrvT )->( recno() ) % 10 == 0
         oMtrInf:Set( ( dbfFacPrvT )->( recno() ) )
      end if

	END DO

   CLOSE ( dbfFacPrvT )
	CLOSE ( dbfFacPrvL )

   /*
   Nos movemos por los albaranes de clientes___________________________________
	*/

   USE ( cPath + "ALBCLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIT", @dbfAlbCliT ) )
   SET ADSINDEX TO ( cPath + "ALBCLIT.CDX" ) ADDITIVE

   USE ( cPath + "ALBCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIL", @dbfAlbCliL ) )
   SET ADSINDEX TO ( cPath + "ALBCLIL.CDX" ) ADDITIVE

   oMtrInf:cText  := "Albaran de clientes"
   oMtrInf:Set( ( dbfAlbCliT )->( recno() ) )
   oMtrInf:SetTotal( ( dbfAlbCliT )->( lastrec() ) )

   WHILE (dbfAlbCliT)->( !eof() )

      IF !(dbfAlbCliT)->LFACTURADO                                                        .AND.;
         (dbfAlbCliT)->DFECALB >= dDesde                                                  .AND.;
         (dbfAlbCliT)->DFECALB <= dHasta                                                  .AND.;
         (dbfAlbCliL)->( dbSeek( (dbfAlbCliT)->CSERALB + Str( (dbfAlbCliT)->NNUMALB ) + (dbfAlbCliT)->CSUFALB ) ) .AND.;
         ( (dbfAlbCliT)->CCODALM >= cAlm1 .AND. (dbfAlbCliT)->CCODALM <= cAlm2 )

         WHILE (dbfAlbCliT)->CSERALB + Str( (dbfAlbCliT)->NNUMALB ) + (dbfAlbCliT)->CSUFALB == (dbfAlbCliL)->CSERALB + Str( (dbfAlbCliL)->NNUMALB ) + (dbfAlbCliL)->CSUFALB .AND.;
               ( dbfAlbCliL )->( !eof() )

            IF (dbfAlbCliL)->CREF >= cArt1                                                .AND.;
               (dbfAlbCliL)->CREF <= cArt2                                                .AND.;
               (dbfAlbCliT)->DFECALB >= dDesde                                            .AND.;
               (dbfAlbCliT)->DFECALB <= dHasta                                            .AND.;
               !( lExcCero .AND. (dbfAlbCliL)->NPREUNIT == 0 )

                  (dbfTmp)->( DBAppend() )
                  (dbfTmp)->DFECMOV := (dbfAlbCliT)->DFECALB
                  (dbfTmp)->CCODALM := (dbfAlbCliT)->CCODALM
                  (dbfTmp)->CCODCLI := (dbfAlbCliT)->CCODCLI
                  (dbfTmp)->CNOMCLI := (dbfAlbCliT)->CNOMCLI
                  (dbfTmp)->CDOCMOV := (dbfAlbCliT)->CSERALB + "/" + Str( (dbfAlbCliT)->NNUMALB ) + "/" + (dbfAlbCliT)->CSUFALB
                  (dbfTmp)->CTIPMOV := "Albaran"
                  (dbfTmp)->CCODART := (dbfAlbCliL)->CREF
                  (dbfTmp)->NCAJSAL := (dbfAlbCliL)->NCANENT
                  (dbfTmp)->NUNTSAL := If( (dbfAlbCliL)->NCANENT != 0, (dbfAlbCliL)->NCANENT, 1 ) * (dbfAlbCliL)->NUNICAJA

            END IF

         (dbfAlbCliL)->( dbSkip() )

         END DO

       END IF

      (dbfAlbCliT)->( dbSkip() )
      if ( dbfAlbCliT )->( recno() ) % 10 == 0
         oMtrInf:Set( ( dbfAlbCliT )->( recno() ) )
      end if

   END DO

	/*
   Nos movemos por las lineas de facturas de clientes__________________________
	*/

   USE ( cPath + "FACCLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIT", @dbfFacCliT ) )
   SET ADSINDEX TO ( cPath + "FACCLIT.CDX" ) ADDITIVE

   USE ( cPath + "FACCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIL", @dbfFacCliL ) )
   SET ADSINDEX TO ( cPath + "FACCLIL.CDX" ) ADDITIVE

   oMtrInf:cText  := "Factura de clientes"
   oMtrInf:Set( ( dbfFacCliT )->( recno() ) )
   oMtrInf:SetTotal( ( dbfFacCliT )->( lastrec() ) )

   WHILE (dbfFacCliT)->( !eof() )

      IF (dbfFacCliT)->DFECFAC >= dDesde                                                  .AND.;
         (dbfFacCliT)->DFECFAC <= dHasta                                                  .AND.;
         (dbfFacCliL)->( dbSeek( (dbfFacCliT)->CSERIE + Str( (dbfFacCliT)->NNUMFAC ) + (dbfFacCliT)->CSUFFAC ) ) .AND.;
         ( (dbfFacCliT)->CCODALM >= cAlm1 .AND. (dbfFacCliT)->CCODALM <= cAlm2 )

         WHILE (dbfFacCliT)->CSERIE + Str( (dbfFacCliT)->NNUMFAC ) + (dbfFacCliT)->CSUFFAC == (dbfFacCliL)->CSERIE + Str( (dbfFacCliL)->NNUMFAC ) + (dbfFacCliL)->CSUFFAC .AND.;
               ( dbfFacCliL )->( !eof() )

            IF (dbfFacCliL)->CREF >= cArt1                                                .AND.;
               (dbfFacCliL)->CREF <= cArt2                                                .AND.;
               (dbfFacCliT)->DFECFAC >= dDesde                                            .AND.;
               (dbfFacCliT)->DFECFAC <= dHasta                                            .AND.;
               !( lExcCero .AND. (dbfFacCliL)->NPREUNIT == 0 )

                  (dbfTmp)->( DBAppend() )
                  (dbfTmp)->DFECMOV := (dbfFacCliT)->DFECFAC
                  (dbfTmp)->CCODALM := (dbfFacCliT)->CCODALM
                  (dbfTmp)->CCODCLI := (dbfFacCliT)->CCODCLI
                  (dbfTmp)->CNOMCLI := (dbfFacCliT)->CNOMCLI
                  (dbfTmp)->CDOCMOV := (dbfFacCliT)->CSERIE + "/" + Str( (dbfFacCliT)->NNUMFAC ) + "/" + (dbfFacCliT)->CSUFFAC
                  (dbfTmp)->CTIPMOV := "Factura"
                  (dbfTmp)->CCODART := (dbfFacCliL)->CREF
                  (dbfTmp)->NCAJSAL := (dbfFacCliL)->NCANENT
                  (dbfTmp)->NUNTSAL := If( (dbfFacCliL)->NCANENT != 0, (dbfFacCliL)->NCANENT, 1 ) * (dbfFacCliL)->NUNICAJA

            END IF

         (dbfFacCliL)->( dbSkip() )

         END DO

       END IF

      (dbfFacCliT)->( dbSkip() )
      if ( dbfFacCliT )->( recno() ) % 10 == 0
         oMtrInf:Set( ( dbfFacCliT )->( recno() ) )
      end if

   END DO

   /*
   Nos movemos por los tikets de cleintes______________________________________
	*/

   USE ( cPath + "TIKET.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKET", @dbfTikT ) )
   SET ADSINDEX TO ( cPath + "TIKET.CDX" ) ADDITIVE

   USE ( cPath + "TIKEL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKEL", @dbfTikL ) )
   SET ADSINDEX TO ( cPath + "TIKEL.CDX" ) ADDITIVE

   oMtrInf:cText  := "Tiket de clientes"
   oMtrInf:Set( ( dbfTikT )->( recno() ) )
   oMtrInf:SetTotal( ( dbfTikT )->( lastrec() ) )

   /*
	Nos movemos por las lineas de facturas de los proveedores
	*/

   WHILE (dbfTikT)->( !eof() )

      IF (dbfTikT)->DFECTIK >= dDesde                                                  .AND.;
         (dbfTikT)->DFECTIK <= dHasta                                                  .AND.;
         (dbfTikT)->CALMTIK >= cAlm1                                                   .AND.;
         (dbfTikT)->CALMTIK <= cAlm2                                                   .AND.;
         (dbfTikL)->( dbSeek( (dbfTikT)->CSERTIK + ( dbfTikT )->CNUMTIK + ( dbfTikT )->CSUFTIK ) )

         WHILE (dbfTikT)->CSERTIK + ( dbfTikT )->CNUMTIK + ( dbfTikT )->CSUFTIK == (dbfTikL)->CSERTIL + ( dbfTikL )->CNUMTIL + ( dbfTikL )->CSUFTIL .AND.;
               !(dbfTikL)->( eof() )

            cRetCode := retCode( (dbfTikL)->CCBATIL, dbfArticulo )

            IF !Empty( cRetCode )                               .AND.;
               ( cRetCode >= cArt1 .AND. cRetCode <= cArt2 )    .AND.;
               !( lExcCero .AND. (dbfTikL)->NPVPTIL == 0 )

               (dbfTmp)->( dbAppend() )
               (dbfTmp)->CCODCLI := (dbfTikT)->CCLITIK
               (dbfTmp)->CCODALM := (dbfTikT)->CALMTIK
               (dbfTmp)->CNOMCLI := (dbfTikT)->CNOMTIK
               (dbfTmp)->DFECMOV := (dbfTikT)->DFECTIK
               (dbfTmp)->NUNTSAL := (dbfTikL)->NUNTTIL
               (dbfTmp)->CCODART := cRetCode
               (dbfTmp)->CDOCMOV := (dbfTikT)->CSERTIK + "/" + ltrim( (dbfTikT)->CNUMTIK ) + "/" + (dbfTikT)->CSUFTIK
               (dbfTmp)->CTIPMOV := "Tiket"

            END IF

            /*
            Ahora comprobamos q no haya producto combinado
            */

            IF !Empty( (dbfTikL)->CCOMTIL )

               cRetCode := retCode( (dbfTikL)->CCOMTIL, dbfArticulo )

               IF !Empty( cRetCode )                                                   .AND.;
                  ( cRetCode >= cArt1 .AND. cRetCode <= cArt2 )                        .AND.;
                  !( lExcCero .AND. (dbfTikL)->NPVPTIL == 0 )

                  (dbfTmp)->( dbAppend() )
                  (dbfTmp)->CCODCLI := (dbfTikT)->CCLITIK
                  (dbfTmp)->CCODALM := (dbfTikT)->CALMTIK
                  (dbfTmp)->CNOMCLI := (dbfTikT)->CNOMTIK
                  (dbfTmp)->DFECMOV := (dbfTikT)->DFECTIK
                  (dbfTmp)->NUNTSAL := (dbfTikL)->NUNTTIL
                  (dbfTmp)->CCODART := cRetCode
                  (dbfTmp)->CDOCMOV := (dbfTikT)->CSERTIK + "/" + ltrim( (dbfTikT)->CNUMTIK ) + "/" + (dbfTikT)->CSUFTIK
                  (dbfTmp)->CTIPMOV := "Tiket"

               END IF

            END IF

            (dbfTikL)->( dbSkip() )

         END WHILE

      END IF

      (dbfTikT)->( dbSkip() )
      if ( dbfTikT )->( recno() ) % 10 == 0
         oMtrInf:Set( ( dbfTikT )->( recno() ) )
      end if

   END DO

   CLOSE ( dbfTikT )
   CLOSE ( dbfTikL )

   /*
   Nos movemos por los movimientos de almacen__________________________________
	*/

   USE ( cPath + "HISMOV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "HISMOV", @dbfHisMov ) )
   SET ADSINDEX TO ( cPath + "HISMOV.CDX" ) ADDITIVE

   oMtrInf:cText  := "Movimientos de almacen"
   oMtrInf:Set( ( dbfHisMov )->( recno() ) )
   oMtrInf:SetTotal( ( dbfHisMov )->( lastrec() ) )

   WHILE !( dbfHisMov )->( eof() )

      IF ( dbfHisMov )->DFECMOV >= dDesde .AND.;
         ( dbfHisMov )->DFECMOV <= dHasta .AND.;
         ( dbfHisMov )->CREFMOV >= cArt1  .AND.;
         ( dbfHisMov )->CREFMOV <= cArt2

         IF ( dbfHisMov )->nTipMov == 1

         /*
         Salidas____________________________________________________________
         */

            IF ( dbfHisMov )->CALOMOV >= cAlm1  .AND. ( dbfHisMov )->CALOMOV <= cAlm2

               (dbfTmp)->( dbAppend() )
               (dbfTmp)->CCODCLI := ""
               (dbfTmp)->CCODALM := (dbfHisMov)->CALOMOV
               (dbfTmp)->CNOMCLI := "MOVIMIENTOS ENTRE ALMACENES"
               (dbfTmp)->DFECMOV := (dbfHisMov)->DFECMOV
               (dbfTmp)->NUNTSAL := (dbfHisMov)->NUNDMOV
               (dbfTmp)->CCODART := (dbfHisMov)->CREFMOV
               (dbfTmp)->CDOCMOV := Str( ( dbfHisMov )->nNumRem ) + ( dbfHisMov )->cSufRem
               (dbfTmp)->CTIPMOV := "Mov. Almacen"

            END IF

            /*
            Entradas___________________________________________________________
            */

            IF ( dbfHisMov )->nTipMov == 1 .and. ( dbfHisMov )->CALIMOV >= cAlm1 .and. ( dbfHisMov )->CALIMOV <= cAlm2

               (dbfTmp)->( dbAppend() )
               (dbfTmp)->CCODCLI := ""
               (dbfTmp)->CCODALM := (dbfHisMov)->CALIMOV
               (dbfTmp)->CNOMCLI := "MOVIMIENTOS ENTRE ALMACENES"
               (dbfTmp)->DFECMOV := (dbfHisMov)->DFECMOV
               (dbfTmp)->NUNTENT := (dbfHisMov)->NUNDMOV
               (dbfTmp)->CCODART := (dbfHisMov)->CREFMOV
               (dbfTmp)->CDOCMOV := Str( ( dbfHisMov )->nNumRem ) + "/" + ( dbfHisMov )->cSufRem
               (dbfTmp)->CTIPMOV := "Mov. Almacen"

            END IF

         else

            /*
            Movimientos simples
            */

            IF ( dbfHisMov )->CALOMOV >= cAlm1  .AND. ( dbfHisMov )->CALOMOV <= cAlm2

               (dbfTmp)->( dbAppend() )
               (dbfTmp)->CCODCLI := ""
               (dbfTmp)->CCODALM := (dbfHisMov)->CALOMOV
               (dbfTmp)->CNOMCLI := "ENTRADA EN ALMACEN"
               (dbfTmp)->DFECMOV := (dbfHisMov)->DFECMOV
               (dbfTmp)->NUNTENT := (dbfHisMov)->NUNDMOV
               (dbfTmp)->CCODART := (dbfHisMov)->CREFMOV
               (dbfTmp)->CDOCMOV := Str( ( dbfHisMov )->nNumRem ) + "/" + ( dbfHisMov )->cSufRem
               (dbfTmp)->CTIPMOV := "Ent. Almacen"

            END IF

         end if

      END IF

      (dbfHisMov)->( dbSkip() )
      if ( dbfHisMov )->( recno() ) % 10 == 0
         oMtrInf:Set( ( dbfHisMov )->( recno() ) )
      end if

	END WHILE

   CLOSE ( dbfHisMov )

	/*
	Lanzamos la ejecici¢n del listado si estamos dentro de las condiciones solicitadas
	*/

	IF (dbfTmp)->( RecCount() ) > 0
      GenRptDet( cAlm1, cAlm2, cArt1, cArt2, dDesde, dHasta, lResumen, lExcCero, cTitulo, cSubTitulo, nDevice, dbfTmp )
	ELSE
		MsgStop( "No existen registros en las condiciones pedidas" )
	END IF

	CLOSE ( dbfFacCliT )
	CLOSE ( dbfFacCliL )
   CLOSE ( dbfTmp     )

   fErase( cPatTmp() + "INFMOV.DBF" )
   fErase( cPatTmp() + "INFMOV.CDX" )

RETURN NIL

//---------------------------------------------------------------------------//

STATIC FUNCTION GenRptDet( cAlm1, cAlm2, cArt1, cArt2, dDesde, dHasta, lResumen, lExcCero, cTitulo, cSubTitulo, nDevice, dbfTmp )

	local oFont1
	local oFont2
   local oFont3

	(dbfTmp)->( DbGoTop() )

	/*
	Tipos de Letras
	*/

	DEFINE FONT oFont1 NAME "Courier New" SIZE 0,-12 BOLD
   DEFINE FONT oFont2 NAME "Courier New" SIZE 0,-10
   DEFINE FONT oFont3 NAME "Arial" SIZE 0,-10 BOLD

	IF nDevice == 1

		REPORT oReport ;
			TITLE  	Rtrim( cTitulo ),;
						Rtrim( cSubTitulo ) ;
         FONT     oFont1, oFont2, oFont3 ;
			HEADER 	"Periodo : " + dToC( dDesde ) + " -> " + dToC( dHasta ),;
                  "Fecha   : " + Dtoc( Date() ) RIGHT ;
         FOOTER   "Página  : " + str( oReport:nPage, 3 ) CENTERED;
         CAPTION  "Detalles de artículos";
			PREVIEW

	ELSE

		REPORT oReport ;
			TITLE  	Rtrim( cTitulo ),;
						Rtrim( cSubTitulo ) ;
         FONT     oFont1, oFont2, oFont3 ;
			HEADER 	"Periodo : " + dToC( dDesde ) + " -> " + dToC( dHasta ),;
                  "Fecha   : " + Dtoc( Date() ) RIGHT ;
         FOOTER   "Página  : " + str( oReport:nPage, 3 ) CENTERED;
         TO PRINTER ;
         CAPTION  "Detalles de artículos"

	END IF


		COLUMN TITLE "Cli./Prv." ;
			DATA (dbfTmp)->CCODCLI ;
			FONT 2

		COLUMN TITLE "Nombre" ;
			DATA (dbfTmp)->CNOMCLI ;
			SIZE 34 ;
			FONT 2

      COLUMN TITLE "Alm." ;
         DATA (dbfTmp)->CCODALM ;
         SIZE 6 ;
			FONT 2

      IF lUseCaj()

         COLUMN TITLE "Caja Ent." ;
            DATA (dbfTmp)->NCAJENT ;
            PICTURE MasUnd() ;
            SIZE 8 ;
            TOTAL ;
            FONT 2

		END IF

		COLUMN TITLE "Und. Ent." ;
			DATA (dbfTmp)->NUNTENT ;
         PICTURE MasUnd();
			SIZE 8 ;
			TOTAL ;
			FONT 2

      IF lUseCaj()

         COLUMN TITLE "Caja Sal." ;
            DATA (dbfTmp)->NCAJSAL ;
            PICTURE MasUnd() ;
            SIZE 8 ;
            TOTAL ;
            FONT 2

		END IF

		COLUMN TITLE "Und. Sal." ;
			DATA (dbfTmp)->NUNTSAL ;
         PICTURE MasUnd() ;
			TOTAL ;
			SIZE 8 ;
			FONT 2

      if lUseCaj()

         COLUMN TITLE "Saldo Caja" ;
            DATA (dbfTmp)->NCAJENT - (dbfTmp)->NCAJSAL ;
            PICTURE MasUnd() ;
            SIZE 8 ;
            TOTAL ;
            FONT 2

      end if

         COLUMN TITLE "Saldo" ;
            DATA (dbfTmp)->NUNTENT - (dbfTmp)->NUNTSAL ;
            PICTURE MasUnd() ;
            TOTAL ;
            SIZE 8 ;
            FONT 2

      if !lResumen

         COLUMN TITLE "Documento" ;
            DATA (dbfTmp)->CDOCMOV ;
            SIZE 12 ;
            FONT 2

         COLUMN TITLE "Tipo" ;
            DATA (dbfTmp)->CTIPMOV ;
            SIZE 12 ;
            FONT 2

         COLUMN TITLE "Fecha" ;
            DATA (dbfTmp)->DFECMOV ;
            SIZE 8 ;
            FONT 2

      end if

      GROUP ON (dbfTmp)->CCODALM ;
         HEADER "Almacen : " + Rtrim( (dbfTmp)->CCODALM ) + " - " + retAlmacen( (dbfTmp)->CCODALM, dbfAlmT );
         FOOTER "Total movimientos artículo (" + ltrim( str( oReport:aGroups[1]:nCounter ) ) + ")" ;
         FONT 3

      GROUP ON (dbfTmp)->CCODALM + (dbfTmp)->CCODART ;
         HEADER Rtrim( (dbfTmp)->CCODART ) + " - " + retArticulo( (dbfTmp)->CCODART, dbfArticulo );
         FOOTER "Total de movimientos almacen (" + ltrim( str( oReport:aGroups[2]:nCounter ) ) + ")" ;
         FONT 3

   END REPORT

	IF oReport:lCreated
//      oReport:aGroups[1]:cOldValue  := (dbfTmp)->CCODALM
//      oReport:aGroups[2]:cOldValue  := (dbfTmp)->CCODALM + (dbfTmp)->CCODART
      oReport:Margin( 0, RPT_RIGHT, RPT_CMETERS )
      oReport:lSummary  := lResumen
		oReport:bSkip		:= {|| ( dbfTmp )->( dbSkip() ) }
	END IF

   ACTIVATE REPORT oReport ;
      FOR   (dbfTmp)->CCODART >= cArt1 .and. (dbfTmp)->CCODART <= cArt2 ;
      WHILE !(dbfTmp)->(Eof())

	oFont1:end()
	oFont2:end()
   oFont3:end()

RETURN NIL

//---------------------------------------------------------------------------//

static function RetSaldo( oReport )

   local cPictu
   local nSaldo   := 0

   if lUseCaj()
      nSaldo := oReport:aColumn[x]:nTotal - oReport:aColumn[x]:nTotal
      cPictu := oReport:aColumn[x]:cPicture
   else
      nSaldo := oReport:aColumn[x]:nTotal - oReport:aColumn[x]:nTotal
      cPictu := oReport:aColumn[x]:cPicture
   end if

return Trans( nSaldo, cPictu )

//---------------------------------------------------------------------------//

/*
Informe que presenta detallado todos los movimientos
*/

FUNCTION InfDetPedCli( oMenuItem, oWnd )

	local oDlg
	local oBntPrev
	local oBtnImpr
	local oBtnCancel
	local oArticulo1, cArticulo1
	local oArticulo2, cArticulo2
	local oArtText1, cArtText1
	local oArtText2, cArtText2
	local oDesde
	local oHasta
   local oMtrInf
   local nEstado     := 1
   local nMtrInf     := 0
   local cTitulo     := Padr( cCodEmp() + " - " + cNbrEmp(), 100 )
   local cSubTitulo  := Padr( "Detalle de movimientos de artículos", 100 )
	local nMeter		:= 0
	local dDesde		:= CtoD( "01/01/" + Str( Year( Date() ) ) )
	local dHasta		:= Date()
	local lResumen		:= .f.
	local lExcCero		:= .f.
   local oAlmOrg
   local cAlmOrg
   local oAlmDes
   local cAlmDes
   local oSayDes
   local cSayDes
   local cSayOrg
   local oSayOrg

   DEFAULT oMenuitem := "01042"
   DEFAULT oWnd      := oWnd()

   if nLevelUsr( oMenuItem ) != 1
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

	dbCommitAll()

   USE ( cPatArt() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
   SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

   USE ( cPatAlm() + "ALMACEN.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALMACEN", @dbfAlmT ) )
   SET ADSINDEX TO ( cPatAlm() + "ALMACEN.CDX" ) ADDITIVE

	/*
	Obtenemos los valores del primer y ultimo codigo
	*/

   cArticulo1  := dbFirst( dbfArticulo, 1 )
   cArticulo2  := dbLast( dbfArticulo, 1 )

   cAlmOrg     := dbFirst( dbfAlmT, 1 )
   cAlmDes     := dbLast( dbfAlmT, 1 )

	/*
	Caja de dialogo
	*/

   DEFINE DIALOG oDlg RESOURCE "INF_MOVIMIENTOS" TITLE "Informes de artículos en pedidos por clientes"

   REDEFINE GET oAlmOrg VAR cAlmOrg;
      ID       70;
      VALID    cAlmacen( oAlmOrg, dbfAlmT, oSayOrg ) ;
      BITMAP   "LUPA" ;
      ON HELP  BrwAlmacen( oAlmOrg, oSayOrg ) ;
		COLOR 	CLR_GET ;
		OF 		oDlg

   REDEFINE GET oSayOrg VAR cSayOrg ;
      ID       80 ;
      WHEN     .F.;
      COLOR    CLR_GET ;
		OF 		oDlg

   REDEFINE GET oAlmDes VAR cAlmDes;
      ID       90;
      VALID    cAlmacen( oAlmDes, dbfAlmT, oSayDes ) ;
      BITMAP   "LUPA" ;
      ON HELP  BrwAlmacen( oAlmDes, oSayDes ) ;
		COLOR 	CLR_GET ;
		OF 		oDlg

   REDEFINE GET oSayDes VAR cSayDes ;
		WHEN 		.F.;
      ID       100 ;
		OF 		oDlg

   REDEFINE GET oArticulo1 VAR cArticulo1;
      ID       110 ;
      VALID    cArticulo( oArticulo1, dbfArticulo, oArtText1 );
      BITMAP   "LUPA" ;
      ON HELP  BrwArticulo( oArticulo1, oArtText1 );
		OF 		oDlg

   REDEFINE GET oArtText1 VAR cArtText1 ;
		WHEN 		.F.;
      ID       120 ;
		OF 		oDlg

	REDEFINE GET oArticulo2 VAR cArticulo2;
		ID 		130 ;
		VALID 	cArticulo( oArticulo2, dbfArticulo, oArtText2 );
      BITMAP   "LUPA" ;
		ON HELP 	BrwArticulo( oArticulo2, oArtText2 );
		OF 		oDlg

	REDEFINE GET oArtText2 VAR cArtText2 ;
		WHEN 		.F.;
		ID 		140 ;
		OF 		oDlg

	REDEFINE GET oDesde VAR dDesde;
		SPINNER ;
		ID 		150 ;
		OF 		oDlg

	REDEFINE GET oHasta VAR dHasta;
		SPINNER ;
		ID 		160 ;
		OF 		oDlg

   REDEFINE GET cTitulo ;
		ID 		170 ;
		OF 		oDlg

	REDEFINE GET cSubTitulo ;
		ID 		180 ;
		OF 		oDlg

	REDEFINE CHECKBOX lResumen ;
		ID 		190 ;
		OF 		oDlg

	REDEFINE CHECKBOX lExcCero ;
		ID 		200 ;
		OF 		oDlg

   REDEFINE RADIO nEstado ;
      ID       201, 202, 203 ;
      OF       oDlg

	/*----------------------------------------------------------------------------//
REDEFINE APOLOMETER oMtrInf ;
		VAR 		nMtrInf ;
		PROMPT	"Procesando" ;
      ID       210;
		OF 		oDlg ;
      TOTAL    100

	REDEFINE BUTTON oBtnPrev ;
      ID       508;
		OF 		oDlg ;
      ACTION ( oDlg:disable(),;
               MkPedCliDet( cAlmOrg, cAlmDes, cArticulo1, cArticulo2, dDesde, dHasta, nEstado, lResumen, lExcCero, oMtrInf, cTitulo, cSubTitulo, 1 ),;
               oDlg:enable() )

	REDEFINE BUTTON oBtnImpr ;
		ID 		505;
		OF 		oDlg ;
      ACTION ( oDlg:disable(),;
               MkPedCliDet( cAlmOrg, cAlmDes, cArticulo1, cArticulo2, dDesde, dHasta, nEstado, lResumen, lExcCero, oMtrInf, cTitulo, cSubTitulo, 2 ),;
               oDlg:enable() )

	REDEFINE BUTTON oBtnCancel ;
      ID       510;
		OF 		oDlg ;
		ACTION ( oDlg:end() )

   ACTIVATE DIALOG oDlg CENTER ON PAINT ( oAlmOrg:lValid(), oAlmDes:lValid(), oArticulo1:lValid(), oArticulo2:lValid() )

	CLOSE ( dbfArticulo )
   CLOSE ( dbfAlmT     )

RETURN NIL


//---------------------------------------------------------------------------//

/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

STATIC FUNCTION MkPedCliDet( cAlm1, cAlm2, cArt1, cArt2, dDesde, dHasta, nEstado, lResumen, lExcCero, oMtrInf, cTitulo, cSubTitulo, nDevice )

   local oDlg
   local dbfMov
	local dbfTmp
   local cRetCode
   local cPath    := cPatEmp()
   local aDbf     := {  { "CCODART", "C", 18, 0 },;
                        { "CCODALM", "C",  3, 0 },;
                        { "CCODCLI", "C", 12, 0 },;
								{ "CNOMCLI", "C", 50, 0 },;
								{ "NCAJENT", "N", 12, 0 },;
								{ "NCAJSAL", "N", 12, 0 },;
								{ "NUNTENT", "N", 12, 0 },;
								{ "NUNTSAL", "N", 12, 0 },;
                        { "CDOCMOV", "C", 14, 0 },;
								{ "DFECMOV", "D",  8, 0 } }

   /*
   Creamos las bases de datos temporales
   */

   if file( cPatTmp() + "INFMOV.DBF" )
      ferase( cPatTmp() + "INFMOV.DBF" )
   end if

   if file( cPatTmp() + "INFMOV.CDX" )
      ferase( cPatTmp() + "INFMOV.CDX" )
   end if

   dbCreate(   cPatTmp() + "INFMOV.DBF", aDbf, cDriver() )
   dbUseArea(  .t., cDriver(), cPatTmp() + "INFMOV.DBF", cCheckArea( "INFMOV", @dbfTmp ), .f. )
   ordCreate(  cPatTmp() + "INFMOV.CDX", "CCODART", "CCODALM + CCODART", {|| CCODALM + CCODART } )
   ordListAdd( cPatTmp() + "INFMOV.CDX" )

   /*
   Bases de datos de albaranes a proveedores
   */

   USE ( cPath + "PEDCLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDCLIT", @dbfPedCliT ) )
   SET ADSINDEX TO ( cPath + "PEDCLIT.CDX" ) ADDITIVE

   USE ( cPath + "PEDCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDCLIL", @dbfPedCliL ) )
   SET ADSINDEX TO ( cPath + "PEDCLIL.CDX" ) ADDITIVE

   oMtrInf:cText  := "Pedido de clientes"
   oMtrInf:Set( ( dbfPedCliT )->( recno() ) )
   oMtrInf:SetTotal( ( dbfPedCliT )->( lastrec() ) )

   do case
      case nEstado == 1
         bValid   := {|| (dbfPedCliT)->NESTADO != 3 }
      case nEstado == 2
         bValid   := {|| (dbfPedCliT)->NESTADO == 3 }
      case nEstado == 3
         bValid   := {|| .t. }
   end case

	/*
	Nos movemos por las lineas de facturas de los proveedores
	*/

   WHILE (dbfPedCliT)->( !eof() )


      IF Eval( bValid )                                                                   .AND.;
         (dbfPedCliT)->DFECPED >= dDesde                                                  .AND.;
         (dbfPedCliT)->DFECPED <= dHasta                                                  .AND.;
         (dbfPedCliL)->( dbSeek( (dbfPedCliT)->CSERPED + Str( (dbfPedCliT)->NNUMPED ) + (dbfPedCliT)->CSUFPED ) ) .AND. ;
         ( (dbfPedCliT)->CCODALM >= cAlm1 .AND. (dbfPedCliT)->CCODALM <= cAlm2 )

         WHILE (dbfPedCliT)->CSERPED + Str( (dbfPedCliT)->NNUMPED ) + (dbfPedCliT)->CSUFPED == (dbfPedCliL)->CSERPED +  Str( (dbfPedCliL)->NNUMPED ) + (dbfPedCliL)->CSUFPED .AND.;
               !( dbfPedCliL )->( eof() )

            IF (dbfPedCliL)->CREF >= cArt1                     .AND.;
               (dbfPedCliL)->CREF <= cArt2                     .AND.;
               !( lExcCero .AND. (dbfPedCliL)->NPREDIV == 0 )

               (dbfTmp)->( dbAppend() )
               (dbfTmp)->CCODART := (dbfPedCliL)->CREF
               (dbfTmp)->CCODALM := (dbfPedCliT)->CCODALM
               (dbfTmp)->CCODCLI := (dbfPedCliT)->CCODCLI
               (dbfTmp)->CNOMCLI := (dbfPedCliT)->CNOMCLI
               (dbfTmp)->NCAJENT := (dbfPedCliL)->NCANENT
               (dbfTmp)->NUNTENT := NotCaja( (dbfPedCliL)->NCANPED ) * (dbfPedCliL)->NUNICAJA
               (dbfTmp)->CDOCMOV := (dbfPedCliL)->CSERPED + "/" + Str( (dbfPedCliL)->NNUMPED ) + "/" + (dbfPedCliL)->CSUFPED
               (dbfTmp)->DFECMOV := (dbfPedCliT)->DFECPED

            END IF

            (dbfPedCliL)->( dbSkip() )

         END WHILE

      END IF

      (dbfPedCliT)->( dbSkip() )
      oMtrInf:Set( ( dbfPedCliT )->( recno() ) )

   END WHILE

   CLOSE ( dbfPedCliT )
   CLOSE ( dbfPedCliL )

	/*
	Lanzamos la ejecici¢n del listado si estamos dentro de las condiciones solicitadas
	*/

	IF (dbfTmp)->( RecCount() ) > 0
      GnPedCliDet( cAlm1, cAlm2, cArt1, cArt2, dDesde, dHasta, lResumen, lExcCero, cTitulo, cSubTitulo, nDevice, dbfTmp )
	ELSE
		MsgStop( "No existen registros en las condiciones pedidas" )
	END IF

	CLOSE ( dbfFacCliT )
	CLOSE ( dbfFacCliL )
   CLOSE ( dbfTmp     )

   fErase( cPatTmp() + "INFMOV.DBF" )
   fErase( cPatTmp() + "INFMOV.CDX" )

RETURN NIL

//---------------------------------------------------------------------------//

STATIC FUNCTION GnPedCliDet( cAlm1, cAlm2, cArt1, cArt2, dDesde, dHasta, lResumen, lExcCero, cTitulo, cSubTitulo, nDevice, dbfTmp )

	local oFont1
	local oFont2
   local oFont3

	(dbfTmp)->( DbGoTop() )

	/*
	Tipos de Letras
	*/

	DEFINE FONT oFont1 NAME "Courier New" SIZE 0,-12 BOLD
   DEFINE FONT oFont2 NAME "Courier New" SIZE 0,-10
   DEFINE FONT oFont3 NAME "Arial" SIZE 0,-10 BOLD

	IF nDevice == 1

		REPORT oReport ;
			TITLE  	Rtrim( cTitulo ),;
						Rtrim( cSubTitulo ) ;
         FONT     oFont1, oFont2, oFont3 ;
			HEADER 	"Periodo : " + dToC( dDesde ) + " -> " + dToC( dHasta ),;
                  "Fecha   : " + Dtoc( Date() ) RIGHT ;
         FOOTER   "Página  : " + str( oReport:nPage, 3 ) CENTERED;
         CAPTION  "Detalles de artículos";
			PREVIEW

	ELSE

		REPORT oReport ;
			TITLE  	Rtrim( cTitulo ),;
						Rtrim( cSubTitulo ) ;
         FONT     oFont1, oFont2, oFont3 ;
			HEADER 	"Periodo : " + dToC( dDesde ) + " -> " + dToC( dHasta ),;
                  "Fecha   : " + Dtoc( Date() ) RIGHT ;
         FOOTER   "Página  : " + str( oReport:nPage, 3 ) CENTERED;
         TO PRINTER ;
         CAPTION  "Detalles de artículos"

	END IF


		COLUMN TITLE "Cli./Prv." ;
			DATA (dbfTmp)->CCODCLI ;
			FONT 2

		COLUMN TITLE "Nombre" ;
			DATA (dbfTmp)->CNOMCLI ;
			SIZE 34 ;
			FONT 2

      COLUMN TITLE "Alm." ;
         DATA (dbfTmp)->CCODALM ;
         SIZE 6 ;
			FONT 2

      IF lUseCaj()

         COLUMN TITLE "Caja Ent." ;
            DATA (dbfTmp)->NCAJENT ;
            PICTURE MasUnd() ;
            SIZE 8 ;
            TOTAL ;
            FONT 2

		END IF

		COLUMN TITLE "Und. Ent." ;
			DATA (dbfTmp)->NUNTENT ;
         PICTURE MasUnd();
			SIZE 8 ;
			TOTAL ;
			FONT 2

      IF lUseCaj()

         COLUMN TITLE "Caja Sal." ;
            DATA (dbfTmp)->NCAJSAL ;
            PICTURE MasUnd() ;
            SIZE 8 ;
            TOTAL ;
            FONT 2

		END IF

		COLUMN TITLE "Und. Sal." ;
			DATA (dbfTmp)->NUNTSAL ;
         PICTURE MasUnd() ;
			TOTAL ;
			SIZE 8 ;
			FONT 2

      if !lResumen

         COLUMN TITLE "Documento" ;
            DATA (dbfTmp)->CDOCMOV ;
            SIZE 12 ;
            FONT 2

         COLUMN TITLE "Fecha" ;
            DATA (dbfTmp)->DFECMOV ;
            SIZE 8 ;
            FONT 2

      end if

      GROUP ON (dbfTmp)->CCODALM ;
         HEADER "Almacen : " + Rtrim( (dbfTmp)->CCODALM ) + " - " + retAlmacen( (dbfTmp)->CCODALM, dbfAlmT );
         FOOTER "Total movimientos artículo (" + ltrim( str( oReport:aGroups[1]:nCounter ) ) + ")" ;
         FONT 3

      GROUP ON (dbfTmp)->CCODALM + (dbfTmp)->CCODART ;
         HEADER Rtrim( (dbfTmp)->CCODART ) + " - " + retArticulo( (dbfTmp)->CCODART, dbfArticulo );
         FOOTER "Total de movimientos (" + ltrim( str( oReport:aGroups[2]:nCounter ) ) + ")" ;
         FONT 3

   END REPORT

	IF oReport:lCreated
      oReport:Margin( 0, RPT_RIGHT, RPT_CMETERS )
      oReport:lSummary  := lResumen
		oReport:bSkip		:= {|| ( dbfTmp )->( dbSkip() ) }
	END IF

   ACTIVATE REPORT oReport ;
      ON STARTGROUP oReport:NewLine();
      FOR   (dbfTmp)->CCODART >= cArt1 .and. (dbfTmp)->CCODART <= cArt2 ;
      WHILE !(dbfTmp)->(Eof())

	oFont1:end()
	oFont2:end()
   oFont3:end()

RETURN NIL

//---------------------------------------------------------------------------//

/*
Informe que presenta detallado todos los movimientos
*/

FUNCTION InfDetPreCli( oMenuItem, oWnd )

	local oDlg
	local oBntPrev
	local oBtnImpr
	local oBtnCancel
	local oArticulo1, cArticulo1
	local oArticulo2, cArticulo2
	local oArtText1, cArtText1
	local oArtText2, cArtText2
	local oDesde
	local oHasta
   local oMtrInf
   local nMtrInf     := 0
   local nEstado     := 1
   local cTitulo     := Padr( cCodEmp() + " - " + cNbrEmp(), 100 )
   local cSubTitulo  := Padr( "Detalle de movimientos de artículos", 100 )
	local nMeter		:= 0
	local dDesde		:= CtoD( "01/01/" + Str( Year( Date() ) ) )
	local dHasta		:= Date()
	local lResumen		:= .f.
	local lExcCero		:= .f.
   local oAlmOrg
   local cAlmOrg
   local oAlmDes
   local cAlmDes
   local oSayDes
   local cSayDes
   local cSayOrg
   local oSayOrg
   local oDivInf
   local cDivInf     := cDivEmp()
   local nVdvInf
   local cPouDiv
   local nDouDiv
   local cPorDiv
   local nRouDiv
   local cPpvDiv
   local nDpvDiv
   local oSer        := Array( 27 )
   local aSer        := { .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t. }
   local oBandera    := TBandera():New

   DEFAULT oMenuitem := "01041"
   DEFAULT oWnd      := oWnd()

   if nLevelUsr( oMenuItem ) != 1
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

	dbCommitAll()

   USE ( cPatArt() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
   SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

   USE ( cPatAlm() + "ALMACEN.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALMACEN", @dbfAlmT ) )
   SET ADSINDEX TO ( cPatAlm() + "ALMACEN.CDX" ) ADDITIVE

   USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDivisa ) )
   SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

	/*
	Obtenemos los valores del primer y ultimo codigo
	*/

   cArticulo1  := dbFirst( dbfArticulo, 1 )
   cArticulo2  := dbLast( dbfArticulo, 1 )

   cAlmOrg     := dbFirst( dbfAlmT, 1 )
   cAlmDes     := dbLast( dbfAlmT, 1 )

	/*
	Caja de dialogo
	*/

   DEFINE DIALOG oDlg RESOURCE "INF_MOVIMIENTOS" TITLE "Informes de artículos en presupuestos por clientes"

   REDEFINE GET oAlmOrg VAR cAlmOrg;
      ID       70;
      VALID    cAlmacen( oAlmOrg, dbfAlmT, oSayOrg ) ;
      BITMAP   "LUPA" ;
      ON HELP  BrwAlmacen( oAlmOrg, oSayOrg ) ;
		COLOR 	CLR_GET ;
		OF 		oDlg

   REDEFINE GET oSayOrg VAR cSayOrg ;
      ID       80 ;
      WHEN     .F.;
      COLOR    CLR_GET ;
		OF 		oDlg

   REDEFINE GET oAlmDes VAR cAlmDes;
      ID       90;
      VALID    cAlmacen( oAlmDes, dbfAlmT, oSayDes ) ;
      BITMAP   "LUPA" ;
      ON HELP  BrwAlmacen( oAlmDes, oSayDes ) ;
		COLOR 	CLR_GET ;
		OF 		oDlg

   REDEFINE GET oSayDes VAR cSayDes ;
		WHEN 		.F.;
      ID       100 ;
		OF 		oDlg

   REDEFINE GET oArticulo1 VAR cArticulo1;
      ID       110 ;
      VALID    cArticulo( oArticulo1, dbfArticulo, oArtText1 );
      BITMAP   "LUPA" ;
      ON HELP  BrwArticulo( oArticulo1, oArtText1 );
		OF 		oDlg

   REDEFINE GET oArtText1 VAR cArtText1 ;
		WHEN 		.F.;
      ID       120 ;
		OF 		oDlg

	REDEFINE GET oArticulo2 VAR cArticulo2;
		ID 		130 ;
		VALID 	cArticulo( oArticulo2, dbfArticulo, oArtText2 );
      BITMAP   "LUPA" ;
		ON HELP 	BrwArticulo( oArticulo2, oArtText2 );
		OF 		oDlg

	REDEFINE GET oArtText2 VAR cArtText2 ;
		WHEN 		.F.;
		ID 		140 ;
		OF 		oDlg

	REDEFINE GET oDesde VAR dDesde;
		SPINNER ;
		ID 		150 ;
		OF 		oDlg

	REDEFINE GET oHasta VAR dHasta;
		SPINNER ;
		ID 		160 ;
		OF 		oDlg

   REDEFINE GET oDivInf VAR cDivInf ;
      VALID    cDivOut( oDivInf, oBmpDiv, @nVdvInf, @cPouDiv, @nDouDiv, @cPorDiv, @nRouDiv, @cPpvDiv, @nDpvDiv, nil, dbfDivisa, oBandera );
		PICTURE  "@!";
      ID       220 ;
		COLOR 	CLR_GET ;
      BITMAP   "LUPA" ;
      ON HELP  BrwDiv( oDivInf, oBmpDiv, @nVdvInf, dbfDivisa, oBandera ) ;
		OF 		oDlg

	REDEFINE BITMAP oBmpDiv ;
      RESOURCE "BAN_EURO" ;
      ID       221;
		OF 		oDlg

   REDEFINE GET cTitulo ;
		ID 		170 ;
		OF 		oDlg

	REDEFINE GET cSubTitulo ;
		ID 		180 ;
		OF 		oDlg

	REDEFINE CHECKBOX lResumen ;
		ID 		190 ;
		OF 		oDlg

	REDEFINE CHECKBOX lExcCero ;
		ID 		200 ;
		OF 		oDlg

   REDEFINE RADIO nEstado ;
      ID       201, 202, 203 ;
      OF       oDlg

	/*----------------------------------------------------------------------------//
REDEFINE APOLOMETER oMtrInf ;
		VAR 		nMtrInf ;
		PROMPT	"Procesando" ;
      ID       210;
		OF 		oDlg ;
      TOTAL    100

   TWebBtn():Redefine(310,,,,, {|This| ( aEval( oSer, {|o| Eval( o:bSetGet, .T. ), o:refresh() } ) ) }, oDlg,,,,, "LEFT",,,,, ( 0 + ( 0 * 256 ) + ( 255 * 65536 ) ), ( 0 + ( 0 * 256 ) + ( 255 * 65536 ) ),,,, "Seleccionar todas las series",,,, )

   TWebBtn():Redefine(320,,,,, {|This| ( aEval( oSer, {|o| Eval( o:bSetGet, .F. ), o:refresh() } ) ) }, oDlg,,,,, "LEFT",,,,, ( 0 + ( 0 * 256 ) + ( 255 * 65536 ) ), ( 0 + ( 0 * 256 ) + ( 255 * 65536 ) ),,,, "Deseleccionar todas las series",,,, )

   REDEFINE CHECKBOX oSer[  1 ] VAR aSer[  1 ] ID 370 OF oDlg
   REDEFINE CHECKBOX oSer[  2 ] VAR aSer[  2 ] ID 371 OF oDlg
   REDEFINE CHECKBOX oSer[  3 ] VAR aSer[  3 ] ID 372 OF oDlg
   REDEFINE CHECKBOX oSer[  4 ] VAR aSer[  4 ] ID 373 OF oDlg
   REDEFINE CHECKBOX oSer[  5 ] VAR aSer[  5 ] ID 374 OF oDlg
   REDEFINE CHECKBOX oSer[  6 ] VAR aSer[  6 ] ID 375 OF oDlg
   REDEFINE CHECKBOX oSer[  7 ] VAR aSer[  7 ] ID 376 OF oDlg
   REDEFINE CHECKBOX oSer[  8 ] VAR aSer[  8 ] ID 377 OF oDlg
   REDEFINE CHECKBOX oSer[  9 ] VAR aSer[  9 ] ID 378 OF oDlg
   REDEFINE CHECKBOX oSer[ 10 ] VAR aSer[ 10 ] ID 379 OF oDlg
   REDEFINE CHECKBOX oSer[ 11 ] VAR aSer[ 11 ] ID 380 OF oDlg
   REDEFINE CHECKBOX oSer[ 12 ] VAR aSer[ 12 ] ID 381 OF oDlg
   REDEFINE CHECKBOX oSer[ 13 ] VAR aSer[ 13 ] ID 382 OF oDlg
   REDEFINE CHECKBOX oSer[ 14 ] VAR aSer[ 14 ] ID 383 OF oDlg
   REDEFINE CHECKBOX oSer[ 15 ] VAR aSer[ 15 ] ID 384 OF oDlg
   REDEFINE CHECKBOX oSer[ 16 ] VAR aSer[ 16 ] ID 385 OF oDlg
   REDEFINE CHECKBOX oSer[ 17 ] VAR aSer[ 17 ] ID 386 OF oDlg
   REDEFINE CHECKBOX oSer[ 18 ] VAR aSer[ 18 ] ID 387 OF oDlg
   REDEFINE CHECKBOX oSer[ 19 ] VAR aSer[ 19 ] ID 388 OF oDlg
   REDEFINE CHECKBOX oSer[ 20 ] VAR aSer[ 20 ] ID 389 OF oDlg
   REDEFINE CHECKBOX oSer[ 21 ] VAR aSer[ 21 ] ID 390 OF oDlg
   REDEFINE CHECKBOX oSer[ 22 ] VAR aSer[ 22 ] ID 391 OF oDlg
   REDEFINE CHECKBOX oSer[ 23 ] VAR aSer[ 23 ] ID 392 OF oDlg
   REDEFINE CHECKBOX oSer[ 24 ] VAR aSer[ 24 ] ID 393 OF oDlg
   REDEFINE CHECKBOX oSer[ 25 ] VAR aSer[ 25 ] ID 394 OF oDlg
   REDEFINE CHECKBOX oSer[ 26 ] VAR aSer[ 26 ] ID 395 OF oDlg
   REDEFINE CHECKBOX oSer[ 27 ] VAR aSer[ 27 ] ID 396 OF oDlg

	REDEFINE BUTTON oBtnPrev ;
      ID       508;
		OF 		oDlg ;
      ACTION ( oDlg:disable(),;
               MkPreCliDet( cAlmOrg, cAlmDes, cArticulo1, cArticulo2, dDesde, dHasta, nEstado, lResumen, lExcCero, oMtrInf, cDivInf, aSer, cTitulo, cSubTitulo, 1 ),;
               oDlg:enable() )

	REDEFINE BUTTON oBtnImpr ;
		ID 		505;
		OF 		oDlg ;
      ACTION ( oDlg:disable(),;
               MkPreCliDet( cAlmOrg, cAlmDes, cArticulo1, cArticulo2, dDesde, dHasta, nEstado, lResumen, lExcCero, oMtrInf, cDivInf, aSer, cTitulo, cSubTitulo, 2 ),;
               oDlg:enable() )

	REDEFINE BUTTON oBtnCancel ;
      ID       510;
		OF 		oDlg ;
		ACTION ( oDlg:end() )

   ACTIVATE DIALOG oDlg CENTER ON PAINT ( oAlmOrg:lValid(), oAlmDes:lValid(), oArticulo1:lValid(), oArticulo2:lValid() )

	CLOSE ( dbfArticulo )
   CLOSE ( dbfAlmT     )
   CLOSE ( dbfDivisa   )


RETURN NIL

//---------------------------------------------------------------------------//

/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

STATIC FUNCTION MkPreCliDet( cAlm1, cAlm2, cArt1, cArt2, dDesde, dHasta, nEstado, lResumen, lExcCero, oMtrInf, cDivInf, aSer, cTitulo, cSubTitulo, nDevice )

   local oDlg
   local bValid
   local dbfMov
	local dbfTmp
   local cRetCode
   local cPath    := cPatEmp()
   local aDbf     := {  { "CCODART", "C", 18, 0 },;
                        { "CCODALM", "C",  3, 0 },;
                        { "CCODCLI", "C", 12, 0 },;
								{ "CNOMCLI", "C", 50, 0 },;
								{ "NCAJENT", "N", 12, 0 },;
								{ "NCAJSAL", "N", 12, 0 },;
								{ "NUNTENT", "N", 12, 0 },;
								{ "NUNTSAL", "N", 12, 0 },;
                        { "CDOCMOV", "C", 14, 0 },;
								{ "DFECMOV", "D",  8, 0 } }

   do case
      case nEstado == 1
         bValid   := {|| (dbfPreCliT)->LESTADO }
      case nEstado == 2
         bValid   := {|| !(dbfPreCliT)->LESTADO }
      case nEstado == 3
         bValid   := {|| .t. }
   end case

   /*
   Creamos las bases de datos temporales
   */

   if file( cPatTmp() + "INFMOV.DBF" )
      ferase( cPatTmp() + "INFMOV.DBF" )
   end if

   if file( cPatTmp() + "INFMOV.CDX" )
      ferase( cPatTmp() + "INFMOV.CDX" )
   end if

   dbCreate(   cPatTmp() + "INFMOV.DBF", aDbf, cDriver() )
   dbUseArea(  .t., cDriver(), cPatTmp() + "INFMOV.DBF", cCheckArea( "INFMOV", @dbfTmp ), .f. )
   ordCreate(  cPatTmp() + "INFMOV.CDX", "CCODART", "CCODALM + CCODART", {|| CCODALM + CCODART } )
   ordListAdd( cPatTmp() + "INFMOV.CDX" )

   /*
   Bases de datos de albaranes a proveedores
   */

   USE ( cPath + "PreCliT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PreCliT", @dbfPreCliT ) )
   SET ADSINDEX TO ( cPath + "PreCliT.CDX" ) ADDITIVE

   USE ( cPath + "PreCliL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PreCliL", @dbfPreCliL ) )
   SET ADSINDEX TO ( cPath + "PreCliL.CDX" ) ADDITIVE

   oMtrInf:cText  := "Presupuesto de clientes"
   oMtrInf:Set( ( dbfPreCliT )->( recno() ) )
   oMtrInf:SetTotal( ( dbfPreCliT )->( lastrec() ) )

	/*
	Nos movemos por las lineas de facturas de los proveedores
	*/

   WHILE (dbfPreCliT)->( !eof() )

      IF Eval( bValid )                                                                   .AND.;
         (dbfPreCliT)->DFECPRE >= dDesde                                                  .AND.;
         (dbfPreCliT)->DFECPRE <= dHasta                                                  .AND.;
         (dbfPreCliT)->CCODALM >= cAlm1                                                   .AND.;
         (dbfPreCliT)->CCODALM <= cAlm2                                                   .AND.;
         lChkSer( (dbfPreCliT)->CSERPRE, aSer )                                           .AND.;
         (dbfPreCliL)->( dbSeek( (dbfPreCliT)->CSERPRE + Str( (dbfPreCliT)->NNUMPRE ) + (dbfPreCliT)->CSUFPRE ) )

         WHILE (dbfPreCliT)->CSERPRE + Str( (dbfPreCliT)->NNUMPRE ) + (dbfPreCliT)->CSUFPRE == (dbfPreCliL)->CSERPRE + Str( (dbfPreCliL)->NNUMPRE ) + (dbfPreCliL)->CSUFPRE .AND.;
               !( dbfPreCliL )->( eof() )

            IF (dbfPreCliL)->CREF >= cArt1                     .AND.;
               (dbfPreCliL)->CREF <= cArt2                     .AND.;
               !( lExcCero .AND. (dbfPreCliL)->NPREDIV == 0 )

               (dbfTmp)->( dbAppend() )

               (dbfTmp)->CCODALM := (dbfPreCliT)->CCODALM
               (dbfTmp)->CCODCLI := (dbfPreCliT)->CCODCLI
               (dbfTmp)->CNOMCLI := (dbfPreCliT)->CNOMCLI
               (dbfTmp)->DFECMOV := (dbfPreCliT)->DFECPRE

               (dbfTmp)->CCODART := (dbfPreCliL)->CREF
               (dbfTmp)->NCAJENT := (dbfPreCliL)->NCANENT
               (dbfTmp)->NUNTENT := NotCaja( (dbfPreCliL)->NCANPRE ) * (dbfPreCliL)->NUNICAJA
               (dbfTmp)->CDOCMOV := (dbfPreCliL)->CSERPRE + "/" + Str( (dbfPreCliL)->NNUMPRE ) + "/" + (dbfPreCliL)->CSUFPRE

            END IF

            (dbfPreCliL)->( dbSkip() )

         END WHILE

      END IF

      (dbfPreCliT)->( dbSkip() )

      oMtrInf:Set( ( dbfPreCliT )->( recno() ) )

   END WHILE

   CLOSE ( dbfPreCliT )
   CLOSE ( dbfPreCliL )

	/*
	Lanzamos la ejecici¢n del listado si estamos dentro de las condiciones solicitadas
	*/

	IF (dbfTmp)->( RecCount() ) > 0
      GnPreCliDet( cAlm1, cAlm2, cArt1, cArt2, dDesde, dHasta, lResumen, lExcCero, cTitulo, cSubTitulo, nDevice, dbfTmp )
	ELSE
		MsgStop( "No existen registros en las condiciones pedidas" )
	END IF

	CLOSE ( dbfFacCliT )
	CLOSE ( dbfFacCliL )
   CLOSE ( dbfTmp     )

   fErase( cPatTmp() + "INFMOV.DBF" )
   fErase( cPatTmp() + "INFMOV.CDX" )

RETURN NIL

//---------------------------------------------------------------------------//

STATIC FUNCTION GnPreCliDet( cAlm1, cAlm2, cArt1, cArt2, dDesde, dHasta, lResumen, lExcCero, cTitulo, cSubTitulo, nDevice, dbfTmp )

	local oFont1
	local oFont2
   local oFont3

	(dbfTmp)->( DbGoTop() )

	/*
	Tipos de Letras
	*/

	DEFINE FONT oFont1 NAME "Courier New" SIZE 0,-12 BOLD
   DEFINE FONT oFont2 NAME "Courier New" SIZE 0,-10
   DEFINE FONT oFont3 NAME "Arial" SIZE 0,-10 BOLD

	IF nDevice == 1

		REPORT oReport ;
			TITLE  	Rtrim( cTitulo ),;
						Rtrim( cSubTitulo ) ;
         FONT     oFont1, oFont2, oFont3 ;
			HEADER 	"Periodo : " + dToC( dDesde ) + " -> " + dToC( dHasta ),;
                  "Fecha   : " + Dtoc( Date() ) RIGHT ;
         FOOTER   "Página  : " + str( oReport:nPage, 3 ) CENTERED;
         CAPTION  "Detalles de artículos";
			PREVIEW

	ELSE

		REPORT oReport ;
			TITLE  	Rtrim( cTitulo ),;
						Rtrim( cSubTitulo ) ;
         FONT     oFont1, oFont2, oFont3 ;
			HEADER 	"Periodo : " + dToC( dDesde ) + " -> " + dToC( dHasta ),;
                  "Fecha   : " + Dtoc( Date() ) RIGHT ;
         FOOTER   "Página  : " + str( oReport:nPage, 3 ) CENTERED;
         TO PRINTER ;
         CAPTION  "Detalles de artículos"

	END IF


      COLUMN TITLE "Cliente" ;
			DATA (dbfTmp)->CCODCLI ;
			FONT 2

		COLUMN TITLE "Nombre" ;
			DATA (dbfTmp)->CNOMCLI ;
			SIZE 34 ;
			FONT 2

      COLUMN TITLE "Alm." ;
         DATA (dbfTmp)->CCODALM ;
         SIZE 6 ;
			FONT 2

      IF lUseCaj()

         COLUMN TITLE "Caja Ent." ;
            DATA (dbfTmp)->NCAJENT ;
            PICTURE MasUnd() ;
            SIZE 8 ;
            TOTAL ;
            FONT 2

		END IF

		COLUMN TITLE "Und. Ent." ;
			DATA (dbfTmp)->NUNTENT ;
         PICTURE MasUnd();
			SIZE 8 ;
			TOTAL ;
			FONT 2

      IF lUseCaj()

         COLUMN TITLE "Caja Sal." ;
            DATA (dbfTmp)->NCAJSAL ;
            PICTURE MasUnd() ;
            SIZE 8 ;
            TOTAL ;
            FONT 2

		END IF

		COLUMN TITLE "Und. Sal." ;
			DATA (dbfTmp)->NUNTSAL ;
         PICTURE MasUnd() ;
			TOTAL ;
			SIZE 8 ;
			FONT 2

      if !lResumen

         COLUMN TITLE "Documento" ;
            DATA (dbfTmp)->CDOCMOV ;
            SIZE 12 ;
            FONT 2

         COLUMN TITLE "Fecha" ;
            DATA (dbfTmp)->DFECMOV ;
            SIZE 8 ;
            FONT 2

      end if

      GROUP ON (dbfTmp)->CCODALM ;
         HEADER "Almacen : " + Rtrim( (dbfTmp)->CCODALM ) + " - " + retAlmacen( (dbfTmp)->CCODALM, dbfAlmT );
         FOOTER "Total movimientos artículo (" + ltrim( str( oReport:aGroups[1]:nCounter ) ) + ")" ;
         FONT 3

      GROUP ON (dbfTmp)->CCODALM + (dbfTmp)->CCODART ;
         HEADER Rtrim( (dbfTmp)->CCODART ) + " - " + retArticulo( (dbfTmp)->CCODART, dbfArticulo );
         FOOTER "Total de movimientos almacen (" + ltrim( str( oReport:aGroups[2]:nCounter ) ) + ")" ;
         FONT 3

   END REPORT

	IF oReport:lCreated
      oReport:Margin( 0, RPT_RIGHT, RPT_CMETERS )
      oReport:lSummary  := lResumen
		oReport:bSkip		:= {|| ( dbfTmp )->( dbSkip() ) }
	END IF

   ACTIVATE REPORT oReport ;
      FOR   (dbfTmp)->CCODART >= cArt1 .and. (dbfTmp)->CCODART <= cArt2 ;
      WHILE !(dbfTmp)->(Eof())

	oFont1:end()
	oFont2:end()
   oFont3:end()

RETURN NIL

//---------------------------------------------------------------------------//

FUNCTION InfDiario()

	local oDlg
   local lPreCli     := .T.
   local lPedCli     := .T.
   local lAlbCli     := .T.
   local lFacCli     := .T.
   local lTpvCli     := .T.
   local dInfDesde   := Date()
	local dInfHasta	:= Date()
   local cTitulo     := Padr( cCodEmp() + " - " + cNbrEmp(), 100 )
   local cSubTitulo  := Padr( "Diario de operaciones a clientes", 100 )

	/*
	Bases de datos para el informe
	*/

	dbCommitAll()

	/*
	Caja de dialogo
	*/

   DEFINE DIALOG oDlg RESOURCE "INF_DIARIO"

	REDEFINE GET dInfDesde;
		ID 		100 ;
		SPINNER ;
		COLOR 	CLR_GET ;
		OF 		oDlg

	REDEFINE GET dInfHasta;
		ID 		110 ;
		SPINNER ;
		COLOR 	CLR_GET ;
		OF 		oDlg

   REDEFINE CHECKBOX lPreCli ;
      ID       120 ;
		OF 		oDlg

   REDEFINE CHECKBOX lPedCli ;
      ID       130 ;
		OF 		oDlg

   REDEFINE CHECKBOX lAlbCli ;
      ID       140 ;
		OF 		oDlg

   REDEFINE CHECKBOX lFacCli ;
      ID       150 ;
		OF 		oDlg

   REDEFINE CHECKBOX lTpvCli ;
      ID       160 ;
		OF 		oDlg

	REDEFINE GET cTitulo ;
		ID 		170 ;
		OF 		oDlg

	REDEFINE GET cSubTitulo ;
		ID 		180 ;
		OF 		oDlg

	REDEFINE BUTTON oBtnPrev ;
		ID 		508 ;
		OF 		oDlg ;
      ACTION ( oDlg:disable(),;
               GenDiario( dInfDesde, dInfHasta, lPreCli, lPedCli, lAlbCli, lFacCli, lTpvCli, cTitulo, cSubTitulo, 1 ),;
               oDlg:enable() )

	REDEFINE BUTTON oBtnImpr ;
      ID       IDOK ;
		OF 		oDlg ;
      ACTION ( oDlg:disable(),;
               GenDiario( dInfDesde, dInfHasta, lPreCli, lPedCli, lAlbCli, lFacCli, lTpvCli, cTitulo, cSubTitulo, 2 ),;
               oDlg:enable() )

	REDEFINE BUTTON oBtnCancel ;
      ID       IDCANCEL ;
		OF 		oDlg ;
		ACTION 	( oDlg:end() )

   ACTIVATE DIALOG oDlg CENTER

RETURN NIL

//---------------------------------------------------------------------------//

STATIC FUNCTION GenDiario( dInfDesde, dInfHasta, lPreCli, lPedCli, lAlbCli, lFacCli, lTpvCli, cTitulo, cSubTitulo, nDevice )

   local aTotal
   local cPorDiv
   local oFont1   := TFont():New( "Courier New", 0, -12, .F., .T. )
   local oFont2   := TFont():New( "Arial", 0, -10, .F., .T. )
   local oFont3   := TFont():New( "Arial", 0, -10, .F., .F. )
   local aDbf     := {  { "CTIPDOC", "C", 40, 0 },;
                        { "CNUMDOC", "C", 14, 0 },;
                        { "DFECDOC", "D",  8, 0 },;
                        { "CCODCLI", "C", 12, 0 },;
								{ "CNOMCLI", "C", 50, 0 },;
                        { "NBASDOC", "N", 16, 6 },;
                        { "NPTVDOC", "N", 16, 6 },;
                        { "NIVADOC", "N", 16, 6 },;
                        { "NRECDOC", "N", 16, 0 },;
                        { "NTOTDOC", "N", 16, 0 },;
                        { "NPGDDOC", "N", 16, 0 } }

   /*
   Bases de datos comunes
   */

   USE ( cPatDat() + "TIVA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfIva ) )
   SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE

   USE ( cPatCli() + "CLIENT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIENT", @dbfClient ) )
   SET ADSINDEX TO ( cPatCli() + "CLIENT.CDX" ) ADDITIVE

   USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDivisa ) )
   SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

   USE ( cPatEmp() + "FPAGO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FPAGO", @dbfFPago ) )
   SET ADSINDEX TO ( cPatEmp() + "FPAGO.CDX" ) ADDITIVE

   cPorDiv     := cPorDiv( cDivEmp(), dbfDivisa ) // Picture de la divisa redondeada


   /*
   Creamos las bases de datos temporales
   */

   if file( cPatTmp() + "INFMOV.DBF" )
      ferase( cPatTmp() + "INFMOV.DBF" )
   end if

   if file( cPatTmp() + "INFMOV.CDX" )
      ferase( cPatTmp() + "INFMOV.CDX" )
   end if

   dbCreate ( cPatTmp() + "INFMOV.DBF", aDbf, cDriver() )
   dbUseArea( .t., cDriver(), cPatTmp() + "INFMOV.DBF", cCheckArea( "INFMOV", @dbfTmp ), .f. )
   ordCreate( cPatTmp() + "INFMOV.CDX", "CTIPDOC", "CTIPDOC", {|| CTIPDOC } )

   /*
   Pesupuestos a clientes------------------------------------------------------
   */

   if lPreCli

      if TDataCenter():OpenPreCliT( @dbfPreCliT )
         ( dbfPreCliT )->( OrdSetFocus( "dFecPre" ) )
      end if 

      USE ( cPatEmp() + "PRECLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PRECLIL", @dbfPreCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "PRECLIL.CDX" ) ADDITIVE

      /*
      Posicionamiento en el registro inicial
      */

      while ( dbfPreCliT )->dFecPre >= dInfDesde .and. ( dbfPreCliT )->dFecPre <= dInfHasta .and. !( dbfPreCliT )->( eof() )

         ( dbfTmp )->( dbAppend() )
         ( dbfTmp )->CTIPDOC  := "Presupuestos a clientes"
         ( dbfTmp )->CNUMDOC  := ( dbfPreCliT )->CSERPRE + "/" + Ltrim( Str( ( dbfPreCliT )->NNUMPRE ) ) + "/" + ( dbfPreCliT )->CSUFPRE
         ( dbfTmp )->DFECDOC  := ( dbfPreCliT )->DFECPRE
         ( dbfTmp )->CCODCLI  := ( dbfPreCliT )->CCODCLI
         ( dbfTmp )->CNOMCLI  := ( dbfPreCliT )->CNOMCLI

         aTotal   := aTotPreCli( ( dbfPreCliT )->CSERPRE + Str( ( dbfPreCliT )->NNUMPRE ) + ( dbfPreCliT )->CSUFPRE, dbfPreCliT, dbfPreCliL, dbfIva, dbfDivisa, dbfFPago, cDivEmp() )

         ( dbfTmp )->NBASDOC  := aTotal[ 1 ]
         ( dbfTmp )->NIVADOC  := aTotal[ 2 ]
         ( dbfTmp )->NRECDOC  := aTotal[ 3 ]
         ( dbfTmp )->NTOTDOC  := aTotal[ 4 ]

         ( dbfPreCliT )->( dbSkip() )

      end do

      CLOSE ( dbfPreCliT )
      CLOSE ( dbfPreCliL )

   end if

   /*
   Pedidos a clientes----------------------------------------------------------
   */

   if lPedCli

      if !TDataCenter():OpenPedCliT( @dbfPedCliT )
         lOpenFiles     := .f.
      else 
         ( dbfPedCliT )->( OrdSetFocus( "DFECPRE" ) ) 
      end if 

      USE ( cPatEmp() + "PEDCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PedCliL", @dbfPedCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "PEDCLIL.CDX" ) ADDITIVE

      /*
      Posicionamiento en el registro inicial
      */

      while ( dbfPedCliT )->dFecPed >= dInfDesde .and. ( dbfPedCliT )->dFecPed <= dInfHasta .and. !( dbfPedCliT )->( eof() )

         ( dbfTmp )->( dbAppend() )
         ( dbfTmp )->CTIPDOC  := getConfigTraslation("Pedidos de clientes")
         ( dbfTmp )->CNUMDOC  := ( dbfPedCliT )->CSERPED + "/" + Ltrim( Str( ( dbfPedCliT )->NNUMPED ) ) + "/" + ( dbfPedCliT )->CSUFPED
         ( dbfTmp )->DFECDOC  := ( dbfPedCliT )->DFECPED
         ( dbfTmp )->CCODCLI  := ( dbfPedCliT )->CCODCLI
         ( dbfTmp )->CNOMCLI  := ( dbfPedCliT )->CNOMCLI

         aTotal               := aTotPedCli( ( dbfPedCliT )->CSERPED + Str( ( dbfPedCliT )->NNUMPED ) + ( dbfPedCliT )->CSUFPED, dbfPedCliT, dbfPedCliL, dbfIva, dbfDivisa, dbfFPago, cDivEmp() )

         ( dbfTmp )->NBASDOC  := aTotal[ 1 ]
         ( dbfTmp )->NIVADOC  := aTotal[ 2 ]
         ( dbfTmp )->NRECDOC  := aTotal[ 3 ]
         ( dbfTmp )->NTOTDOC  := aTotal[ 4 ]

         ( dbfPedCliT )->( dbSkip() )

      end do

      CLOSE ( dbfPedCliT )
      CLOSE ( dbfPedCliL )

   end if

   /*
   Albaranes a clientes----------------------------------------------------------
   */

   if lAlbCli

      TDataCenter():OpenAlbCliT( @dbfAlbCliT )
      ( dbfAlbCliT )->( OrdSetFocus( "dFecAlb" ) )

      USE ( cPatEmp() + "ALBCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIL", @dbfAlbCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBCLIL.CDX" ) ADDITIVE

      /*
      Posicionamiento en el registro inicial
      */

      while ( dbfAlbCliT )->dFecAlb >= dInfDesde .and. ( dbfAlbCliT )->dFecAlb <= dInfHasta .and. !( dbfAlbCliT )->( eof() )

         ( dbfTmp )->( dbAppend() )
         ( dbfTmp )->CTIPDOC  := "Albraranes de clientes"
         ( dbfTmp )->CNUMDOC  := ( dbfAlbCliT )->CSERALB + "/" + Ltrim( Str( ( dbfAlbCliT )->NNUMALB ) ) + "/" + ( dbfAlbCliT )->CSUFALB
         ( dbfTmp )->DFECDOC  := ( dbfAlbCliT )->DFECALB
         ( dbfTmp )->CCODCLI  := ( dbfAlbCliT )->CCODCLI
         ( dbfTmp )->CNOMCLI  := ( dbfAlbCliT )->CNOMCLI

         aTotal               := aTotAlbCli( ( dbfAlbCliT )->CSERALB + Str( ( dbfAlbCliT )->NNUMALB ) + ( dbfAlbCliT )->CSUFALB, dbfAlbCliT, dbfAlbCliL, dbfIva, dbfDivisa, cDivEmp() )

         ( dbfTmp )->NBASDOC  := aTotal[ 1 ] - aTotal[ 5 ] - aTotal[ 6 ]
         ( dbfTmp )->NIVADOC  := aTotal[ 2 ]
         ( dbfTmp )->NRECDOC  := aTotal[ 3 ]
         ( dbfTmp )->NTOTDOC  := aTotal[ 4 ]

         ( dbfAlbCliT )->( dbSkip() )

      end do

      CLOSE ( dbfAlbCliT )
      CLOSE ( dbfAlbCliL )

   end if

   /*
   Facturas a clientes----------------------------------------------------------
   */

   if lFacCli

      TDataCenter():OpenFacCliT( @dbfFacCliT )
      ( dbfFacCliT )->( OrdSetFocus( "DFECFAC" ) )

      USE ( cPatEmp() + "FACCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( CCHECKAREA( "FACCLIL", @dbfFacCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "FACCLIL.CDX" ) ADDITIVE

      /*
      Posicionamiento en el registro inicial
      */

      while ( dbfFacCliT )->dFecFac >= dInfDesde .and. ( dbfFacCliT )->dFecFac <= dInfHasta .and. !( dbfFacCliT )->( eof() )

         ( dbfTmp )->( dbAppend() )
         ( dbfTmp )->CTIPDOC  := "Facturas de clientes"
         ( dbfTmp )->CNUMDOC  := ( dbfFacCliT )->cSerie + "/" + Ltrim( Str( ( dbfFacCliT )->nNumFac ) ) + "/" + ( dbfFacCliT )->cSufFac
         ( dbfTmp )->DFECDOC  := ( dbfFacCliT )->dFecFac
         ( dbfTmp )->CCODCLI  := ( dbfFacCliT )->CCODCLI
         ( dbfTmp )->CNOMCLI  := ( dbfFacCliT )->CNOMCLI

         aTotal               := aTotFacCli( ( dbfFacCliT )->cSerie + Str( ( dbfFacCliT )->NNUMFac ) + ( dbfFacCliT )->CSUFFac, dbfFacCliT, dbfFacCliL, dbfIva, dbfDivisa, nil, nil, cDivEmp() )

         ( dbfTmp )->NBASDOC  := aTotal[ 1 ] - aTotal[ 5 ] - aTotal[ 6 ]
         ( dbfTmp )->NIVADOC  := aTotal[ 2 ]
         ( dbfTmp )->NRECDOC  := aTotal[ 3 ]
         ( dbfTmp )->NTOTDOC  := aTotal[ 4 ]

         ( dbfFacCliT )->( dbSkip() )

      end do

      CLOSE ( dbfFacCliT )
      CLOSE ( dbfFacCliL )

   end if

   /*
   Creacion del informe--------------------------------------------------------
   */

   ( dbfTmp )->( dbGoTop() )

	IF nDevice == 1

		REPORT oReport ;
			TITLE 	Rtrim( cTitulo), Rtrim( cSubTitulo ), "" ;
			FONT   	oFont1, oFont2, oFont3 ;
			HEADER 	"Periodo : " + dToC( dInfDesde ) + " -> " + dToC( dInfHasta ),;
                  "Fecha   : " + dToc( Date() ) RIGHT ;
         FOOTER   "Página  : " + str( oReport:nPage, 3 ) CENTERED;
         CAPTION  "Diario de operaciones";
			PREVIEW

	ELSE

		REPORT oReport ;
			TITLE 	Rtrim( cTitulo), Rtrim( cSubTitulo ), "" ;
			FONT   	oFont1, oFont2, oFont3 ;
			HEADER 	"Periodo : " + dToC( dInfDesde ) + " -> " + dToC( dInfHasta ),;
                  "Fecha   : " + dToc( Date() ) RIGHT ;
         FOOTER   "Página  : " + str( oReport:nPage, 3 ) CENTERED;
         CAPTION  "Diario de operaciones";
         TO PRINTER

	END IF

   COLUMN TITLE "Número" ;
         DATA     ( dbfTmp )->CNUMDOC;
         SIZE     10 ;
         FONT     2

   COLUMN TITLE "Fecha" ;
         DATA     ( dbfTmp )->DFECDOC;
         SIZE     8 ;
         FONT     2

   COLUMN TITLE "Cliente" ;
         DATA     ( dbfTmp )->CCODCLI + ( dbfTmp )->CNOMCLI;
         SIZE     40 ;
         FONT     2

   COLUMN TITLE "Base" ;
         DATA     ( dbfTmp )->nBasDoc ;
         PICTURE  cPorDiv ;
         SIZE     10 ;
         TOTAL ;
         FONT     2

   COLUMN TITLE cImp() ;
         DATA     ( dbfTmp )->nIvaDoc ;
         PICTURE  cPorDiv ;
         SIZE     10 ;
         TOTAL ;
         FONT     2

   COLUMN TITLE "R.E." ;
         DATA     ( dbfTmp )->nRecDoc ;
         PICTURE  cPorDiv ;
         SIZE     10 ;
         TOTAL ;
         FONT     2

   COLUMN TITLE "Total" ;
         DATA     ( dbfTmp )->nTotDoc ;
         PICTURE  cPorDiv ;
         SIZE     10 ;
         TOTAL ;
         FONT     2

   GROUP ON ( dbfTmp )->CTIPDOC ;
         HEADER   "Documento : " + rtrim( oReport:aGroups[1]:cValue  );
			FONT 3

	END REPORT

	IF oReport:lCreated
      oReport:Margin( 0, RPT_RIGHT, RPT_CMETERS )
      oReport:bSkip        := {|| ( dbfTmp )->( dbSkip() ) }
   END IF

   ACTIVATE REPORT oReport ;
      ON STARTGROUP  ( oReport:NewLine() ) ;
      WHILE          !( dbfTmp )->( eof() )

	oFont1:end()
	oFont2:end()
	oFont3:end()

   CLOSE ( dbfTmp    )
   CLOSE ( dbfIva    )
   CLOSE ( dbfClient )
   CLOSE ( dbfDivisa )

return nil

//---------------------------------------------------------------------------//