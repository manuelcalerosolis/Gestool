#include "FiveWin.Ch"
#include "Font.ch"
#include "Report.ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS TInfDetPed FROM TInfGen

   METHOD New( cTitle, oMenuItem, oWnd, cIniFile ) CONSTRUCTOR

   METHOD End()

END CLASS

//---------------------------------------------------------------------------//

/*
Informe que presenta detallado todos los movimientos
*/

FUNCTION InfDetPreCli( oMenuItem, oWnd )

   local oBlock
   local oError
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

	dbCommitAll()

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

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

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos de agentes" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

	CLOSE ( dbfArticulo )
   CLOSE ( dbfAlmT     )
   CLOSE ( dbfDivisa   )


RETURN NIL

//---------------------------------------------------------------------------//

/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

STATIC FUNCTION MkPreCliDet( cAlm1, cAlm2, cArt1, cArt2, dDesde, dHasta, nEstado, lResumen, lExcCero, oMtrInf, cDivInf, aSer, cTitulo, cSubTitulo, nDevice )

   local oBlock
   local oError
   local oDlg
   local bValid
   local dbfMov
	local dbfTmp
   local cRetCode
   local cPath    := cPatEmp()
   local aDbf     := {  { "CCODART", "C", 18, 0 },;
                        { "CCODALM", "C", 16, 0 },;
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
   if !( dbfTmp )->( neterr() )
      ordCreate(  cPatTmp() + "INFMOV.CDX", "CCODART", "CCODALM + CCODART", {|| CCODALM + CCODART } )
      ordListAdd( cPatTmp() + "INFMOV.CDX" )
   end if

   /*
   Bases de datos de albaranes a proveedores
   */

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

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

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

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

   IF !Empty( oReport ) .and. oReport:lCreated
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