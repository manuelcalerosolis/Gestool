#include "Factu.ch" 
#include "FiveWin.Ch"
#include "Font.ch"
#include "Report.ch"

#ifndef __PDA__
#else
#include "FWCE.ch"
REQUEST DBFCDX
#endif

FUNCTION TInfGen()

   local oInf

   oInf  := TInfDetPre():New( "Detalle de presupuestos a clientes", "01041" )

   oInf:Activate()

   oInf:End()

RETURN NIL

//---------------------------------------------------------------------------//

CLASS TInfDetPre FROM TInfGen

   DATA  lResumen    AS LOGIC INIT .f.
   DATA  lExcCero    AS LOGIC INIT .f.
   DATA  oDbfArt     AS OBJECT
   DATA  oDbfAlm     AS OBJECT
   DATA  oPreCliT    AS OBJECT
   DATA  oPreCliL    AS OBJECT

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHod lResources()

   METHOD End()

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local aDbf     := {  { "CCODART", "C", 18, 0 },;
                        { "CCODALM", "C", 16, 0 },;
                        { "CCODCLI", "C", 12, 0 },;
                        { "CNOMCLI", "C", 50, 0, "@!" },;
                        { "CNIFCLI", "C", 15, 0, "@!" },;
                        { "CDOMCLI", "C", 35, 0, "@!" },;
                        { "CPOBCLI", "C", 35, 0, "@!" },;
                        { "CPROCLI", "C", 20, 0, "@!" },;
                        { "CCDPCLI", "C",  7, 0, "@!" },;
                        { "CTLFCLI", "C", 12, 0, "@!" },;

                        { "NCAJENT", "N", 16, 6, MasUnd() },;
                        { "NCAJSAL", "N", 16, 6, MasUnd() },;
                        { "NUNTENT", "N", 16, 6, MasUnd() },;
                        { "NUNTSAL", "N", 16, 6, MasUnd() },;
                        { "CDOCMOV", "C", 14, 0 },;
								{ "DFECMOV", "D",  8, 0 } }
   local aIdx     :=    { "CCODALM + CCODART" }

   DATABASE NEW ::oDbfArt PATH cPatArt() FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   DATABASE NEW ::oDbfAlm PATH cPatAlm() FILE "ALMACEN.DBF" VIA ( cDriver() ) SHARED INDEX "ALMACEN.CDX"

   ::oPreCliT  := TDataCenter():oPreCliT()

   DATABASE NEW ::oPreCliL PATH cPatEmp() FILE "PRECLIL.DBF" VIA ( cDriver() ) SHARED INDEX "PRECLIL.CDX"

   ::oMtrInf:SetTotal( ::oPreCliT:Lastrec() )

   ::CreateTmp( aDbf, aIdx )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   ::oDbfArt:End()
   ::oDbfAlm:End()
   ::oPreCliT:End()
   ::oPreCliL:End()

   ::CloseTmp()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHod lResources()

   local oAlmOrg
   local cAlmOrg
   local oSayAlmOrg
   local cSayAlmOrg
   local oAlmDes
   local cAlmDes
   local oSayAlmDes
   local cSayAlmDes
   local oArtOrg
   local cArtOrg
   local oSayArtOrg
   local cSayArtOrg
   local oArtDes
   local cArtDes
   local oSayArtDes
   local cSayArtDes

   /*
	Obtenemos los valores del primer y ultimo codigo
	*/

   cArtOrg     := dbFirst( ::oDbfArt, 1 )
   cArtDes     := dbLast(  ::oDbfArt, 1 )

   cAlmOrg     := dbFirst( ::oDbfAlm, 1 )
   cAlmDes     := dbLast(  ::oDbfAlm, 1 )

   ::::StdResources()

   REDEFINE GET oAlmOrg VAR cAlmOrg;
      ID       70;
      VALID    cAlmacen( oAlmOrg, ::oDbfAlm:cAlias, oSayOrg ) ;
      BITMAP   "LUPA" ;
      ON HELP  BrwAlmacen( oAlmOrg, oSayOrg ) ;
		COLOR 	CLR_GET ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oSayAlmOrg VAR cSayAlmOrg ;
      ID       80 ;
      WHEN     .f.;
      COLOR    CLR_GET ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oAlmDes VAR cAlmDes;
      ID       90;
      VALID    cAlmacen( oAlmDes, ::oDbfAlm:cAlias, oSayDes ) ;
      BITMAP   "LUPA" ;
      ON HELP  BrwAlmacen( oAlmDes, oSayDes ) ;
		COLOR 	CLR_GET ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oSayAlmDes VAR cSayAlmDes ;
		WHEN 		.F.;
      ID       100 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oArtDes VAR cArtDes;
      ID       110 ;
      VALID    cArticulo( oArtDes, ::oDbfArt:cAlias, oArtDes );
      BITMAP   "LUPA" ;
      ON HELP  BrwArticulo( oArtDes, oSayArtDes );
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oSayArtDes VAR cSayArtDes ;
		WHEN 		.F.;
      ID       120 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oArtDes VAR cArtDes;
		ID 		130 ;
      VALID    cArticulo( oArtDes, ::oDbfArt:cAlias, oArtDes );
      BITMAP   "LUPA" ;
      ON HELP  BrwArticulo( oArtDes, oSayArtDes );
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oSayArt VAR cSayArt ;
		WHEN 		.F.;
		ID 		140 ;
      OF       ::oFld:aDialogs[1]

RETURN .t.

//---------------------------------------------------------------------------//
/*
Informe que presenta detallado todos los movimientos
*/


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