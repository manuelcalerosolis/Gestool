#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "Report.ch"

//------------------------------------------------------------------------//

/*
Genera informe diario de ventas por tikets
*/

FUNCTION RepTpv()

	local oDlg
	local cPass			:= space( 8 )
	local dFecIni		:= date()
	local dFecFin		:= date()
   local cTitulo     := Padr( cCodEmp() + " - " + cNbrEmp(), 100 )
	local cSubTitulo	:= Padr( "Diario de ventas por tickets", 100 )

   DEFINE DIALOG oDlg RESOURCE "VTADIATIK"

	REDEFINE GET dFecIni;
		SPINNER;
		ID 		100 ;
		OF 		oDlg

	REDEFINE GET dFecFin;
		SPINNER;
		ID 		110 ;
		OF 		oDlg

	REDEFINE GET cTitulo ;
      ID       140 ;
		OF 		oDlg

	REDEFINE GET cSubTitulo ;
      ID       150 ;
		OF 		oDlg

	REDEFINE BUTTON ;
		ID 		508;
		OF 		oDlg ;
      ACTION ( oDlg:disable(),;
					GenRepTpv( dFecIni, dFecFin ),;
					ScrRepTpv( dFecIni, dFecFin, cTitulo, cSubTitulo, 1 ),;
					DelRepTpv(),;
               oDlg:enable() )

	REDEFINE BUTTON ;
		ID 		505;
		OF 		oDlg ;
      ACTION ( oDlg:disable(),;
					GenRepTpv( dFecIni, dFecFin ),;
					ScrRepTpv( dFecIni, dFecFin, cTitulo, cSubTitulo, 2 ),;
					DelRepTpv(),;
               oDlg:enable() )

	REDEFINE BUTTON;
		ID 		557;
		OF 		oDlg ;
      ACTION ( oDlg:disable(),;
					GenRepTpv( dFecIni, dFecFin ),;
					PrnRepTpv( dFecIni, dFecFin ),;
					DelRepTpv(),;
               oDlg:enable() )

	REDEFINE BUTTON oBtnCan ;
      ID       IDCANCEL ;
		OF 		oDlg ;
		ACTION 	( oDlg:end() )

	ACTIVATE DIALOG oDlg	CENTER

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION GenRepTpv( dFecIni, dFecFin )

	local dbfTikT
	local dbfTikL
   local aDbf     := {  { "CCODART", "C", 18, 0 },;
								{ "CNOMART", "C", 50, 0 },;
                        { "NNUMUND", "N", 13, 6 },;
                        { "NIMPART", "N", 13, 6 } }

	/*
	Abrimos las bases de datos
	*/

   USE ( cPatEmp() + "TIKET.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKET", @dbfTikT ) )
   SET ADSINDEX TO ( cPatEmp() + "TIKET.CDX" ) ADDITIVE
	SET TAG TO "DFECTIK"

   USE ( cPatEmp() + "TIKEL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKEL", @dbfTikL ) )
   SET ADSINDEX TO ( cPatEmp() + "TIKEL.CDX" ) ADDITIVE

	/*
	Creamos una base de datos temporal
	*/

   dbCreate( cPatTmp() + "INFMOV.DBF", aDbf, cDriver() )
   dbUseArea( .t., cDriver(), cPatTmp() + "INFMOV.DBF", cCheckArea( "INFMOV", @dbfInf ), .f. )
   ordCreate( cPatTmp() + "INFMOV.CDX", "CCODART", "CCODART", {|| CCODART } )
   ordListAdd( cPatTmp() + "INFMOV.CDX" )

	/*
	Nos movemos por la base de datos de los Tikets
	*/

	/*
	Posicionamiento en el primer registro
	*/

	( dbfTikT )->( dbSeek( dFecIni, .t. ) )

	WHILE ( dbfTikT )->DFECTIK >= dFecIni .AND.;
			( dbfTikT )->DFECTIK <= dFecFin .AND.;
			( dbfTikT )->( !eof() )

		/*
		Nos posicionamos en la primera linea de detalle
		*/

		IF ( dbfTikL )->( dbSeek( ( dbfTikT )->CSERTIK + ( dbfTikT )->CNUMTIK + ( dbfTikT )->CSUFTIK ) )

         WHILE ( dbfTikL )->CSERTIL + ( dbfTikL )->CNUMTIL + ( dbfTikL )->CSUFTIL == ( dbfTikT )->CSERTIK + ( dbfTikT )->CNUMTIK + ( dbfTikT )->CSUFTIK .AND. ;
					( dbfTikL )->( !eof() )

				/*
				A¤adimos al fichero temporal si el codigo no existe
				*/

				IF ( dbfInf )->( dbSeek( ( dbfTikL )->CCBATIL ) )

					/*
					Solo aumentamos las unidades
					*/

					( dbfInf )->NNUMUND	+= ( dbfTikL )->NUNTTIL
					( dbfInf )->NIMPART	+= ( dbfTikL )->NUNTTIL * ( dbfTikL )->NPVPTIL

				ELSE

					(dbfInf)->( dbAppend() )
					( dbfInf )->CCODART	:= ( dbfTikL )->CCBATIL
					( dbfInf )->CNOMART	:= ( dbfTikL )->CNOMTIL
					( dbfInf )->NNUMUND	:= ( dbfTikL )->NUNTTIL
					( dbfInf )->NIMPART	:= ( dbfTikL )->NUNTTIL * ( dbfTikL )->NPVPTIL

				END IF

				( dbfTikL )->( dbSkip() )

			END DO

		END IF

		( dbfTikT )->( dbSkip() )

	END DO

	CLOSE ( dbfTikT )
	CLOSE ( dbfTikL )

RETURN NIL

//---------------------------------------------------------------------------//

STATIC FUNCTION DelRepTpv()

	CLOSE ( dbfInf )

   fErase( cPatTmp() + "INFMOV.DBF" )
   fErase( cPatTmp() + "INFMOV.CDX" )

RETURN NIL

//---------------------------------------------------------------------------//

STATIC FUNCTION PrnRepTpv( dFecIni, dFecFin, lScreen )

	local oPrn
	local nTotal		:= 0
	local cPort			:= aIniApp()[CPRTIMPTPV]

	DEFAULT cPort		:= "LPT1"
	DEFAULT lScreen	:= .f.

	oPrn 					:= TDosPrn():New( cPort )

	/*
	Titulo Centrado y enfatizado.
	*/

	oPrn:write( retChr( aIniApp()[CIMPNEGTPV] ) )		// +Negrita
	oPrn:write( retChr( aIniApp()[CIMPCENTPV] ) )		// +Centrado

   oPrn:write( "Resumen de ventas por tikets" + CRLF )// Titulo
	oPrn:write( CRLF )											// Linea en blanco
	oPrn:write( "Desde : " + dtoc( dFecIni ) + " Hasta : " + dtoc( dFecFin ) + CRLF )
	oPrn:write( CRLF )											// Linea en blanco

	oPrn:write( retChr( aIniApp()[CIMPNCETPV] ) )		// -Centrado
	oPrn:write( retChr( aIniApp()[CIMPNNETPV] ) )		// -Negrita

	/*
	Cabeceras
	*/

	oPrn:write( "Unds." + Space(1) + Padr( "Articulo", 25 ) + Space(1) + "Importe" + CRLF )
	oPrn:write( Replicate( "-", 40 ) + CRLF )

	( dbfInf )->( dbGoTop() )

	WHILE ( dbfInf )->( !eof() )

		cBuffer 		:= Trans( ( dbfInf )->NNUMUND, "@E 9,999" ) 	+ " " + ;
							SubStr(( dbfInf )->CNOMART, 1, 25 ) 		+ " " + ;
							Trans( ( dbfInf )->NIMPART, "@E 999,999" ) + CRLF
		nTotal  		+= ( dbfInf )->NIMPART

		oPrn:write( cBuffer )

		( dbfInf )->( dbSkip( 1 ) )

	END DO

	oPrn:write( Replicate( "-", 40 ) + CRLF )

	oPrn:write( CRLF )
	oPrn:write( "Total de Ventas...........: " + Trans( nTotal, "@ 999,999,999" ) + CRLF )

	oPrn:write( retChr( aIniApp()[CIMPEJCTPV] ) )
	oPrn:end()

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION ScrRepTpv( dFecIni, dFecFin, cTitulo, cSubTitulo, nDevice )

	local oReport
	local oFont1
	local oFont2

	DEFAULT nDevice := 1

	( dbfInf )->( dbGoTop() )

   DEFINE FONT oFont1 NAME "Arial" SIZE 0, -10 BOLD
   DEFINE FONT oFont2 NAME "Arial" SIZE 0, -10

	IF nDevice == 1

		REPORT oReport ;
				TITLE  	Rtrim( cTitulo ),	Rtrim( cSubTitulo );
				FONT   	oFont1, oFont2 ;
				HEADER 	"Fecha: " + dtoc( date() ) RIGHT ;
            FOOTER   "Página : " + str( oReport:nPage, 3 ) CENTERED;
            CAPTION  "Resumen de ventas por tikets";
				PREVIEW

	ELSE

		REPORT oReport ;
				TITLE  	Rtrim( cTitulo ),	Rtrim( cSubTitulo );
				FONT   	oFont1, oFont2 ;
				HEADER 	"Fecha: " + dtoc( date() ) RIGHT ;
            FOOTER   "Página : " + str( oReport:nPage, 3 ) CENTERED;
            CAPTION  "Resumen de ventas por tikets";
            TO PRINTER

	END IF

      COLUMN TITLE "Codigo" ;
				DATA 		( dbfInf )->CCODART ;
				SIZE 		8 ;
				FONT 		2

		COLUMN TITLE "Unds." ;
				DATA 		( dbfInf )->NNUMUND ;
				PICTURE 	"@E 99,999" ;
				SIZE 		6 ;
				FONT 		2

		COLUMN TITLE "Nombre" ;
				DATA 		( dbfInf )->CNOMART ;
				SIZE 		36 ;
				FONT 		2

		COLUMN TITLE "Importe" ;
				DATA 		( dbfInf )->NIMPART ;
				PICTURE 	"@E 999,999" ;
				SIZE 		8 ;
				FONT 		2 ;
				TOTAL

		END REPORT

      IF !Empty( oReport ) .and. oReport:lCreated
				oReport:Margin( 0, RPT_RIGHT, RPT_CMETERS )
				oReport:bSkip	:= {|| ( dbfInf )->( dbSkip() ) }
		END IF

	ACTIVATE REPORT oReport	WHILE ( !( dbfInf )->( eof() ) )

	oFont1:end()
	oFont2:end()

RETURN NIL

//--------------------------------------------------------------------------//

/*
Informe de Articulos por tickets
*/

FUNCTION RepArtTik( oWnd )

	local oDlg
	local dbfArticulo
	local oArtDes
	local oArtHas
	local cArtDes
	local cArtHas
	local oSayDes
	local oSayHas
	local cSayDes
	local cSayHas
   local aIva        := {}
   local cTitulo     := Padr( cCodEmp() + " - " + cNbrEmp(), 100 )
   local cSubTitulo  := Padr( "Informe de artículos por tickets", 100 )
	local dDesde		:= ctod( "01/01/" + Str( Year( Date() ) ) )
	local dHasta		:= date()

   USE ( cPatArt() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
   SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

	cArtDes	:=	dbFirst( dbfArticulo, 1 )
	cArtHas  := dbLast ( dbfArticulo, 1 )

	/*
	Llamada a la funcion que activa la caja de dialogo
	*/

	DEFINE DIALOG oDlg RESOURCE "REP_ARTTIK"

	REDEFINE GET oArtDes VAR cArtDes ;
		ID 		110 ;
		VALID 	( cArticulo( oArtDes, dbfArticulo, oSayDes ) );
      BITMAP   "LUPA" ;
      ON HELP  ( BrwArticulo( oArtDes, oSayDes ) );
		COLOR 	CLR_GET ;
		OF 		oDlg

	REDEFINE GET oSayDes VAR cSayDes ;
		ID 		120 ;
		WHEN		.F. ;
		COLOR 	CLR_GET ;
		OF 		oDlg

	REDEFINE GET oArtHas VAR cArtHas ;
		ID 		130 ;
		VALID 	( cArticulo( oArtHas, dbfArticulo, oSayHas ) );
      BITMAP   "LUPA" ;
		ON HELP 	( BrwArticulo( oArtHas, oSayHas ) );
		COLOR 	CLR_GET ;
		OF 		oDlg

	REDEFINE GET oSayHas VAR cSayHas ;
		ID 		140 ;
		WHEN		.F. ;
		COLOR 	CLR_GET ;
		OF 		oDlg

	REDEFINE GET dDesde;
		SPINNER ;
		ID 		150 ;
		OF 		oDlg

	REDEFINE GET dHasta;
		SPINNER ;
		ID 		160 ;
		OF 		oDlg

	REDEFINE GET cTitulo ;
      ID       190 ;
		OF 		oDlg

	REDEFINE GET cSubTitulo ;
      ID       200 ;
		OF 		oDlg

	REDEFINE BUTTON ;
		ID 		508;
		OF 		oDlg ;
      ACTION   (  MakArtTik( cArtDes, cArtHas, dDesde, dHasta, cTitulo, cSubTitulo, 1, dbfArticulo, aIva ),;
                  PrnArtTik( cTitulo, cSubTitulo, 1, aIva ),;
						ErsMov() )

	REDEFINE BUTTON ;
		ID 		505 ;
		OF 		oDlg ;
      ACTION   (  MakArtTik( cArtDes, cArtHas, dDesde, dHasta, cTitulo, cSubTitulo, 2, dbfArticulo, aIva ),;
                  PrnArtTik( cTitulo, cSubTitulo, 2, aIva ),;
						ErsMov() )

	REDEFINE BUTTON ;
		ID 		557 ;
		OF 		oDlg ;
      ACTION   (  MakArtTik( cArtDes, cArtHas, dDesde, dHasta, cTitulo, cSubTitulo, 2, dbfArticulo, aIva ),;
                  ErsMov() )

	REDEFINE BUTTON ;
		ID 		510;
		OF 		oDlg ;
		ACTION 	( oDlg:end() )

	ACTIVATE DIALOG oDlg CENTER ;
		ON PAINT ( oArtDes:lValid(), oArtHas:lValid() ) ;
		VALID 	( ( dbfArticulo )->( dbCloseArea() ), .t. )

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

STATIC FUNCTION MakArtTik( cArtDes, cArtHas, dDesde, dHasta, cTitulo, cSubTitulo, nDev, dbfArticulo, aIva )

	local oDlg
	local dbfTikT
	local dbfTikL
   local nPos
   local aDbf     := {  { "CCODART", "C", 18, 0 },;
								{ "CSERTIK", "C",  1, 0 },;
								{ "CNUMTIK", "C", 10, 0 },;
								{ "CSUFTIK", "C",  2, 0 },;
								{ "DFECTIK", "D",  8, 0 },;
								{ "CHORTIK", "C",  5, 0 },;
								{ "CCCJTIK", "C",  3, 0 },;
								{ "CNCJTIK", "C",  3, 0 },;
								{ "CALMTIK", "C",  3, 0 },;
                        { "NPVPTIL", "N", 13, 6 },;
                        { "NUNTTIL", "N", 13, 6 },;
								{ "NIVATIL", "N",  5, 2 },;
								{ "LOFETIL", "L",  1, 0 } }


   USE ( cPatEmp() + "TIKET.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKET", @dbfTikT ) )
   SET ADSINDEX TO ( cPatEmp() + "TIKET.CDX" ) ADDITIVE

   USE ( cPatEmp() + "TIKEL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKEL", @dbfTikL ) )
   SET ADSINDEX TO ( cPatEmp() + "TIKEL.CDX" ) ADDITIVE
   ( dbfTikL )->( ordSetFocus( "CCBATIL" ) )

	/*
	Creaci¢n de bases de datos
	*/

   dbCreate  ( cPatTmp() + "INFMOV.DBF", aDbf, cDriver() )
   dbUseArea ( .t., cDriver(), cPatTmp() + "INFMOV.DBF", cCheckArea( "INFMOV", @dbfTmp ), .f. )
   ordCreate ( cPatTmp() + "INFMOV.CDX", "CCODART", "CCODART", {|| CCODART } )
   ordListAdd( cPatTmp() + "INFMOV.CDX" )

	( dbfArticulo )->( dbSeek( cArtDes ) )

	WHILE ( dbfArticulo )->CODIGO >= cArtDes .AND. ;
			( dbfArticulo )->CODIGO <= cArtHas .AND. ;
			( dbfArticulo )->( !eof() )

		/*
		Cambiamos el codigo interno del Articulo por codigo de barra
		*/

      IF ( dbfTikL )->( dbSeek( ( dbfArticulo )->CODEBAR ) )  // .AND. ;

         WHILE ( dbfTikL )->CCBATIL == ( dbfArticulo )->CODEBAR .AND. !( dbfTikL )->( eof() )

            /*
            Posicionamiento en las base de datos de tiket
				*/

            IF ( dbfTikT )->( dbSeek( ( dbfTikL )->CSERTIL + ( dbfTikL )->CNUMTIL + ( dbfTikL )->CSUFTIL ) )

               IF ( dbfTikT )->DFECTIK >= dDesde .AND. ( dbfTikT )->DFECTIK <= dHasta

                  (dbfTmp)->( dbAppend() )
                  (dbfTmp)->CCODART := (dbfArticulo)->CODIGO
                  (dbfTmp)->CSERTIK := (dbfTikT)->CSERTIK
                  (dbfTmp)->CNUMTIK := (dbfTikT)->CNUMTIK
                  (dbfTmp)->CSUFTIK := (dbfTikT)->CSUFTIK
                  (dbfTmp)->DFECTIK := (dbfTikT)->DFECTIK
                  (dbfTmp)->CHORTIK := (dbfTikT)->CHORTIK
                  (dbfTmp)->CCCJTIK := (dbfTikT)->CCCJTIK
                  (dbfTmp)->CNCJTIK := (dbfTikT)->CNCJTIK
                  (dbfTmp)->CALMTIK := (dbfTikT)->CALMTIK
                  (dbfTmp)->NPVPTIL := (dbfTikL)->NPVPTIL
                  (dbfTmp)->NUNTTIL := (dbfTikL)->NUNTTIL
                  (dbfTmp)->NIVATIL := (dbfTikL)->NIVATIL
                  (dbfTmp)->LOFETIL := (dbfTikL)->LOFETIL

               END IF

               nPos := aScan( aIva, {|x| x[ 1 ] == (dbfTikL)->NIVATIL } )

               IF nPos == 0
                  aadd( aIva, { (dbfTikL)->NIVATIL, (dbfTmp)->NUNTTIL * (dbfTmp)->NPVPTIL } )
               ELSE
                  aIva[ nPos, 2 ] += (dbfTmp)->NUNTTIL * (dbfTmp)->NPVPTIL
               END IF

            END IF

            ( dbfTikL )->( dbSkip() )

         END DO

		END IF

      (dbfArticulo)->( dbSkip() )

	END DO

	( dbfTikT )->( dbCloseArea() )
	( dbfTikL )->( dbCloseArea() )

RETURN NIL

//------------------------------------------------------------------------//

STATIC FUNCTION PrnArtTik( cTitulo, cSubTitulo, nDev, aIva )

   local n
   local oReport
	local oFont1
	local oFont2
   local cInf     := ""
	local cMasPic	:= "@E 999,999,999"
	local cMasUnd	:= RetPic( aIni()[DGTUND] , aIni()[DECUND] )

	DEFAULT nDev 	:= 1

   IF !( ( dbfTmp )->( reccount() ) > 0 )
		MsgStop( "No existen registros en las condiciones pedidas" )
		RETURN NIL
	END IF

	( dbfTmp )->( dbGoTop() )

	/*
	Tipos de Letras
	*/

   DEFINE FONT oFont1 NAME "Arial" SIZE 0, -12 BOLD
   DEFINE FONT oFont2 NAME "Arial" SIZE 0, -12

		IF nDev == 1

			REPORT oReport ;
				TITLE  	Rtrim( cTitulo ),;
							Rtrim( cSubTitulo );
				FONT   	oFont1, oFont2 ;
				HEADER 	"Fecha: " + dtoc(date()) RIGHT ;
            FOOTER   "Página : " + str( oReport:nPage, 3 ) CENTERED;
            CAPTION  "Informe de artículos por tickets";
				PREVIEW

		ELSE

			REPORT oReport ;
				TITLE  	Rtrim( cTitulo ),;
							Rtrim( cSubTitulo );
				FONT   	oFont1, oFont2 ;
				HEADER 	"Fecha: " + dtoc(date()) RIGHT ;
            FOOTER   "Página : " + str( oReport:nPage, 3 ) CENTERED;
            CAPTION  "Informe de artículos por tickets";
            TO PRINTER

		END IF

      FOR n := 1 TO len( aIva )
         cInf += "Tipo : " + Trans( aIva[ n, 1 ], "99.9" ) + "%" + " "
         cInf += "Base : " + Trans( aIva[ n, 2 ] / ( 1 + ( aIva[ n, 1 ] / 100 ) ) , "@E 999,999,999" ) + " "
         cInf += "Total: " + Trans( aIva[ n, 2 ] / ( 1 + ( aIva[ n, 1 ] / 100 ) ) * aIva[ n, 1 ] / 100, "@E 9,999,999,999" ) + " "
      NEXT

      oReport:oFooter:addLine( {|| cInf } )

		COLUMN TITLE "Ticket" ;
				DATA ( dbfTmp )->CNUMTIK ;
				SIZE 8 ;
				FONT 2

		COLUMN TITLE "Fecha" ;
				DATA (dbfTmp)->DFECTIK ;
				SIZE 8 ;
				FONT 2

		COLUMN TITLE "Hora" ;
				DATA (dbfTmp)->CHORTIK ;
				SIZE 6 ;
				FONT 2

		COLUMN TITLE "Caja" ;
				DATA (dbfTmp)->CCCJTIK ;
				SIZE 6 ;
				FONT 2

		COLUMN TITLE "Cajero" ;
				DATA (dbfTmp)->CNCJTIK ;
				SIZE 6 ;
				FONT 2

		COLUMN TITLE "Alm." ;
				DATA (dbfTmp)->CALMTIK ;
				SIZE 6 ;
				FONT 2

		COLUMN TITLE "Unidades" ;
				DATA (dbfTmp)->NUNTTIL ;
				PICTURE cMasUnd ;
				SIZE 8 ;
				TOTAL ;
				FONT 2

		COLUMN TITLE "Precio" ;
				DATA (dbfTmp)->NPVPTIL ;
				PICTURE cMasPic ;
				SIZE 10 ;
				FONT 2

		COLUMN TITLE "Total" ;
				DATA (dbfTmp)->NUNTTIL * (dbfTmp)->NPVPTIL ;
				PICTURE cMasPic ;
				SIZE 10 ;
				TOTAL ;
				FONT 2

      COLUMN TITLE cImp() ;
				DATA (dbfTmp)->NIVATIL ;
				SIZE 6 ;
				FONT 2

		COLUMN TITLE "";
				DATA If( (dbfTmp)->LOFETIL, "OFERTA", "" ) ;
				SIZE 8 ;
				FONT 2

/*
		GROUP ON ( dbfTmp )->CCODART ;
				HEADER "Articulo : " + rtrim( oReport:aGroups[1]:cValue ) + " - " + retArticulo( oReport:aGroups[1]:cValue, dbfArticulo ) ;
				FOOTER "";
				TOTAL ;
				FONT 1
 */

		END REPORT

		IF oReport:lCreated
         oReport:Margin( 0, RPT_RIGHT, RPT_CMETERS )
			oReport:bSkip	:= {|| ( dbfTmp )->( dbSkip( 1 ) ) }
		END IF

		ACTIVATE REPORT oReport WHILE !( dbfTmp )->( eof() )

	oFont1:end()
	oFont2:end()

RETURN NIL

//------------------------------------------------------------------------//

/*
Informe de Articulos por tramos horarios
*/

FUNCTION RepHorTik( oWnd )

	local oDlg
	local dbfArticulo
   local cTitulo     := Padr( cCodEmp() + " - " + cNbrEmp(), 100 )
   local cSubTitulo  := Padr( "Informe de artículos por tickets", 100 )
	local dDesde		:= ctod( "01/01/" + Str( Year( Date() ) ) )
	local dHasta		:= date()

	/*
	Llamada a la funcion que activa la caja de dialogo
	*/

	DEFINE DIALOG oDlg RESOURCE "REP_ARTHOR"

	REDEFINE GET dDesde;
		SPINNER ;
		ID 		110 ;
		OF 		oDlg

	REDEFINE GET dHasta;
		SPINNER ;
		ID 		120 ;
		OF 		oDlg

	REDEFINE GET cTitulo ;
		ID 		130 ;
		OF 		oDlg

	REDEFINE GET cSubTitulo ;
		ID 		140 ;
		OF 		oDlg

	REDEFINE BUTTON ;
		ID 		529;
		OF 		oDlg ;
		ACTION 	MakHorTik( dDesde, dHasta, cTitulo, cSubTitulo, 0 )

	REDEFINE BUTTON ;
		ID 		508;
		OF 		oDlg ;
		ACTION 	MakHorTik( dDesde, dHasta, cTitulo, cSubTitulo, 1 )

	REDEFINE BUTTON ;
		ID 		505 ;
		OF 		oDlg ;
		ACTION 	MakArtTik( dDesde, dHasta, cTitulo, cSubTitulo, 2 )

	REDEFINE BUTTON ;
		ID 		510;
		OF 		oDlg ;
		ACTION 	( oDlg:end() )

	ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

STATIC FUNCTION MakHorTik( dDesde, dHasta, cTitulo, cSubTitulo, nDev )

	local oDlg
	local dbfTmp
	local dbfTikT
	local dbfTikL
   local dbfDivisa
	local aDbf		:= {	{ "CHORTIK", "C",  2, 0 },;
                        { "NPVPTIL", "N", 13, 6 },;
                        { "NUNTTIL", "N", 13, 6 } }

   USE ( cPatEmp() + "TIKET.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKET", @dbfTikT ) )
   SET ADSINDEX TO ( cPatEmp() + "TIKET.CDX" ) ADDITIVE

   USE ( cPatEmp() + "TIKEL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKEL", @dbfTikL ) )
   SET ADSINDEX TO ( cPatEmp() + "TIKEL.CDX" ) ADDITIVE

   USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDivisa ) )
   SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

   CursorWait()

	/*
	Creaci¢n de bases de datos
	*/

   dbCreate  ( cPatTmp() + "INFMOV.DBF", aDbf, cDriver() )
   dbUseArea ( .t., cDriver(), cPatTmp() + "INFMOV.DBF", cCheckArea( "INFMOV", @dbfTmp ), .f. )
   ordCreate ( cPatTmp() + "INFMOV.CDX", "CHORTIK", "CHORTIK", {|| CHORTIK } )
   ordListAdd( cPatTmp() + "INFMOV.CDX" )

	WHILE ( dbfTikT )->( !eof() )

		/*
		Cambiamos el codigo interno del Articulo por codigo de barra
		*/

		IF ( dbfTikT )->DFECTIK >= dDesde .AND. ;
			( dbfTikT )->DFECTIK <= dHasta

			/*
			P“sicionamiento en las base de datos de tiket
			*/

         IF (dbfTmp)->( dbSeek( SubStr( ( dbfTikT )->CHORTIK, 1, 2 ) ) )

            (dbfTmp)->NPVPTIL += nTotal( ( dbfTikT )->CNUMTIK + ( dbfTikT )->CSUFTIK, dbfTikT, dbfTikL, dbfDivisa )
            (dbfTmp)->NUNTTIL += nTotUd( ( dbfTikT )->CNUMTIK + ( dbfTikT )->CSUFTIK, dbfTikL )

			ELSE

				(dbfTmp)->( DBAppend() )
				(dbfTmp)->CHORTIK	:= SubStr( ( dbfTikT )->CHORTIK, 1, 2 )
            (dbfTmp)->NPVPTIL := nTotal( ( dbfTikT )->CSERTIK + ( dbfTikT )->CNUMTIK + ( dbfTikT )->CSUFTIK, dbfTikT, dbfTikL, dbfDivisa, nil, nil, nil )
            (dbfTmp)->NUNTTIL := nTotUd( ( dbfTikT )->CNUMTIK + ( dbfTikT )->CSUFTIK, dbfTikL )

			END IF

		END IF

		( dbfTikT )->( dbSkip() )

	END DO

   CursorWe()

	IF ( dbfTmp )->( RecCount() ) > 0
		IF nDev == 0
			Graph( cTitulo, cSubTitulo, dbfTmp )
		ELSE
			PrnHorTik( cTitulo, cSubTitulo, nDev, dbfTmp )
		END IF
	ELSE
		MsgStop( "No existen registros en las condiciones pedidas" )
	END IF

   ( dbfTikT   )->( dbCloseArea() )
   ( dbfTikL   )->( dbCloseArea() )
   ( dbfDivisa )->( dbCloseArea() )

	( dbfTmp )->( dbCloseArea() )
   fErase( cPatTmp() + "INFMOV.DBF" )
   fErase( cPatTmp() + "INFMOV.CDX" )

RETURN NIL

//------------------------------------------------------------------------//

STATIC FUNCTION PrnHorTik( cTitulo, cSubTitulo, nDev, dbfTmp)

	local oReport
	local oFont1
	local oFont2
	local cMasPic	:= "@E 999,999,999"
	local cMasUnd	:= RetPic( aIni()[DGTUND] , aIni()[DECUND] )

	DEFAULT nDev 	:= 1

	( dbfTmp )->( dbGoTop() )

	/*
	Tipos de Letras
	*/

   DEFINE FONT oFont1 NAME "Arial" SIZE 0, -12 BOLD
   DEFINE FONT oFont2 NAME "Arial" SIZE 0, -12

		IF nDev == 1

			REPORT oReport ;
				TITLE  	Rtrim( cTitulo ),;
							Rtrim( cSubTitulo );
				FONT   	oFont1, oFont2 ;
				HEADER 	"Fecha: " + dtoc(date()) RIGHT ;
				FOOTER 	OemtoAnsi( "P gina : " ) + str( oReport:nPage, 3 ) CENTERED;
				CAPTION 	"Informe por Tramos Horarios";
				PREVIEW

		ELSE

			REPORT oReport ;
				TITLE  	Rtrim( cTitulo ),;
							Rtrim( cSubTitulo );
				FONT   	oFont1, oFont2 ;
				HEADER 	"Fecha: " + dtoc(date()) RIGHT ;
				FOOTER 	OemtoAnsi("P gina : ")+str(oReport:nPage,3) CENTERED;
				CAPTION 	"Informe por Tramos Horarios";
            TO PRINTER

		END IF

		COLUMN TITLE "Hora" ;
				DATA ( dbfTmp )->CHORTIK ;
				SIZE 4 ;
				FONT 2

		COLUMN TITLE "Und." ;
				DATA ( dbfTmp )->NUNTTIL ;
				PICTURE "@E 999,999,999" ;
				SIZE 8 ;
				FONT 2

		COLUMN TITLE "Total" ;
				DATA ( dbfTmp )->NPVPTIL ;
				PICTURE "@E 999,999,999.99" ;
				SIZE 10 ;
				TOTAL ;
				FONT 2

		END REPORT

		IF oReport:lCreated
			msgWait( , , 0.1 )
			oReport:Margin(0, RPT_RIGHT, RPT_CMETERS)
			oReport:bSkip	:= {|| ( dbfTmp )->( dbSkip( 1 ) ) }
		END IF

		ACTIVATE REPORT oReport WHILE !( dbfTmp )->( eof() )

	oFont1:end()
	oFont2:end()

RETURN NIL

//------------------------------------------------------------------------//

STATIC FUNCTION Graph( cTitulo, cSubTitulo, dbfTmp )

   /*
   local oChart
	local n			:= 1
	local nRec		:= ( dbfTmp )->( recCount() )

	IF oWndGrp != NIL
		MsgStop( "Ya existe otra ventana de Graficos" )
		RETURN NIL
	ENDIF

	oChart:ToolBar 		:= .t.
	oChart:Visible 		:= .f.
	oChart:ChartType 		:= 1

	oChart:OpenData[ 2 ] := nMakeLong( 1, nRec )  // 1 series, nRec values

	oChart:Title[ 1 ] 	:= "Importes"
	oChart:Title[ 2 ] 	:= ""
	oChart:Title[ 3 ] 	:= rtrim( cSubTitulo )
	oChart:Title[ 4 ] 	:= ""

   oChart:ThisSerie     :=  0
   n                    := 1
	( dbfTmp )->( dbGoTop() )

	while !( dbfTmp )->( eof() )

      oChart:Value[ n ]    := ( dbfTmp )->nPvpTil
      oChart:Legend[ n ]   := ( dbfTmp )->cHorTik
		n++
		( dbfTmp )->( dbSkip() )

	end do

	oChart:CloseData[ 2 ] 	:= 0
	oChart:Visible   			:= .t.
	oWndGrp:bReSized 			:= { | nType, nWidth, nHeight | ;
										  oChart:SetSize( nWidth, nHeight, .t. ) }
   */

RETURN NIL

//----------------------------------------------------------------------------//
/*
Diario de Facturaci¢n por tickets
*/

FUNCTION InfDiaTik()

	local oDlg
	local oBntPrev
	local oBtnImpr
	local oBtnCancel
	local oCliDesde
	local oCliHasta
	local cCliDesde
	local cCliHasta
	local oNomCliDesde
	local oNomCliHasta
	local cNomCliDesde
	local cNomCliHasta
	local dbfTikT
	local dbfTikL
	local dbfClient
   local dbfDivisa
   local dbfIva
   local lSerieA     := .T.
	local lSerieB		:= .T.
	local lAgrupa		:= .T.
	local lSalto		:= .F.
	local lEuro			:= .F.
	local dInfDesde	:= CtoD( "01/01/" + Str( Year( Date() ) ) )
	local dInfHasta	:= Date()
   local cTitulo     := Padr( cCodEmp() + " - " + cNbrEmp(), 100 )
   local cSubTitulo  := Padr( "Diario de ventas por tickets", 100 )

	/*
	Bases de datos para el informe
	*/

	dbCommitAll()

   USE ( cPatEmp() + "TIKET.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKET", @dbfTikT ) )
   SET ADSINDEX TO ( cPatEmp() + "TIKET.CDX" ) ADDITIVE

   USE ( cPatEmp() + "TIKEL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKEL", @dbfTikL ) )
   SET ADSINDEX TO ( cPatEmp() + "TIKEL.CDX" ) ADDITIVE

   USE ( cPatCli() + "CLIENT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIENT", @dbfClient ) )
   SET ADSINDEX TO ( cPatCli() + "CLIENT.CDX" ) ADDITIVE

   USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDivisa ) )
   SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

	/*
	Obtenemos los valores del primer y ultimo codigo
	*/

	(dbfClient)->(dbGoTop())
	cCliDesde	:= (dbfClient)->COD
	(dbfClient)->(dbGoBottom())
	cCliHasta	:= (dbfClient)->COD
	(dbfClient)->(dbGoTop())

	/*
	Caja de dialogo
	*/

	DEFINE DIALOG oDlg RESOURCE "INF_DIATIK"

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

	REDEFINE GET oCliDesde VAR cCliDesde;
		ID 		120 ;
		COLOR 	CLR_GET ;
		VALID 	( cClient( oCliDesde, dbfClient, oNomCliDesde ) ) ;
      BITMAP   "LUPA" ;
		ON HELP 	( BrwClient( oCliDesde, oNomCliDesde ) ) ;
		OF 		oDlg

	REDEFINE GET oNomCliDesde VAR cNomCliDesde ;
		WHEN 		.F. ;
		COLOR 	CLR_GET ;
		ID 		121 ;
		OF 		oDlg

	REDEFINE GET oCliHasta VAR cCliHasta;
		ID 		130 ;
		COLOR 	CLR_GET ;
		VALID 	( cClient( oCliHasta, dbfClient, oNomCliHasta ) ) ;
      BITMAP   "LUPA" ;
      ON HELP  ( BrwClient( oCliHasta, oNomCliHasta ) ) ;
		OF 		oDlg

	REDEFINE GET oNomCliHasta VAR cNomCliHasta ;
		WHEN 		.F. ;
		COLOR 	CLR_GET ;
		ID 		131 ;
		OF 		oDlg

	REDEFINE CHECKBOX lAgrupa ;
		ID 		150 ;
		OF 		oDlg

	REDEFINE CHECKBOX lSalto ;
		WHEN 		lAgrupa ;
		ID 		151 ;
		OF 		oDlg

   REDEFINE CHECKBOX lSerieA ;
      ID       152 ;
		OF 		oDlg

   REDEFINE CHECKBOX lSerieB ;
      ID       153 ;
		OF 		oDlg

	REDEFINE GET cTitulo ;
      ID       160 ;
		OF 		oDlg

	REDEFINE GET cSubTitulo ;
      ID       170 ;
		OF 		oDlg

	REDEFINE BUTTON ;
		ID 		508 ;
		OF 		oDlg ;
		ACTION ( AEval( oDlg:aControls, { | oCtrl | oCtrl:disable() } ),;
               GenDiaTik( dInfDesde, dInfHasta, cCliDesde, cCliHasta, lAgrupa, lSalto, lSerieA, lSerieB, lEuro, 1, cTitulo, cSubTitulo, dbfTikT, dbfTikL, dbfClient, dbfIva ),;
					AEval( oDlg:aControls, { | oCtrl | oCtrl:enable() } ) )

	REDEFINE BUTTON ;
		ID 		505;
		OF 		oDlg ;
		ACTION ( AEval( oDlg:aControls, { | oCtrl | oCtrl:disable() } ),;
               GenDiaTik( dInfDesde, dInfHasta, cCliDesde, cCliHasta, lAgrupa, lSalto, lSerieA, lSerieB, lEuro, 2, cTitulo, cSubTitulo, dbfTikT, dbfTikL, dbfClient, dbfIva ),;
					AEval( oDlg:aControls, { | oCtrl | oCtrl:enable() } ) )

	REDEFINE BUTTON ;
		ID 		557;
		OF 		oDlg ;
		ACTION ( AEval( oDlg:aControls, { | oCtrl | oCtrl:disable() } ),;
               TikDiaTik( dInfDesde, dInfHasta, cTitulo, cSubTitulo, dbfTikT, dbfTikL, lSerieA, lSerieB, lEuro ),;
					AEval( oDlg:aControls, { | oCtrl | oCtrl:enable() } ) )

	REDEFINE BUTTON oBtnCancel ;
      ID       IDOK ;
		OF 		oDlg ;
		ACTION 	( oDlg:end() )

	ACTIVATE DIALOG oDlg CENTER;
		ON PAINT ( oCliDesde:lValid(), oCliHasta:lValid() )

	CLOSE ( dbfTikT )
	CLOSE ( dbfTikL )
	CLOSE ( dbfClient )
	CLOSE ( dbfDivisa )
   CLOSE ( dbfIva )

RETURN NIL

//---------------------------------------------------------------------------//

STATIC FUNCTION GenDiaTik( dInfDesde, dInfHasta, cCliDesde, cCliHasta, lAgrupa, lSalto, lSerieA, lSerieB,  lEuro, nDevice, cTitulo, cSubTitulo, dbfTikT, dbfTikL, dbfClient, dbfIva )

	local oFont1
	local oFont2
	local oFont3
	local nRecno1	:= ( dbfClient )->( RecNo() )
	local nRecno2	:= ( dbfTikT )->( RecNo() )
   local dbfDivisa

	/*
	Posicionamiento en el registro inicial
	*/

	IF lAgrupa
		(dbfTikT)->( OrdSetFocus( "CCLITIK" ) )
	ELSE
		(dbfTikT)->( OrdSetFocus( "DFECTIK" ) )
	END IF

	(dbfTikT)->( dbGoTop() )

	DEFINE FONT oFont1 NAME "Courier New" SIZE 0,-12 BOLD
   DEFINE FONT oFont2 NAME "Courier New" SIZE 0,-10
   DEFINE FONT oFont3 NAME "Arial" SIZE 0,-10 BOLD

	IF nDevice == 1

		REPORT oReport ;
			TITLE 	Rtrim( cTitulo), Rtrim( cSubTitulo ), "" ;
			FONT   	oFont1, oFont2, oFont3 ;
			HEADER 	"Periodo : " + dToC( dInfDesde ) + " -> " + dToC( dInfHasta ),;
						"Cliente : " + cCliDesde + " -> " + cCliHasta,;
						"Fecha : " + Dtoc( Date() ) RIGHT ;
			FOOTER 	"Página : " + str( oReport:nPage, 3 ) CENTERED;
         CAPTION  "Diario de tikets";
			PREVIEW

	ELSE

		REPORT oReport ;
			TITLE 	Rtrim( cTitulo), Rtrim( cSubTitulo ), "" ;
			FONT   	oFont1, oFont2, oFont3 ;
			HEADER 	"Periodo : " + dToC( dInfDesde ) + " -> " + dToC( dInfHasta ),;
						"Cliente : " + cCliDesde + " -> " + cCliHasta,;
						"Fecha : " + Dtoc( Date() ) RIGHT ;
			FOOTER 	"Página : " + str( oReport:nPage, 3 ) CENTERED;
         CAPTION  "Diario de tikets";
         TO PRINTER

	END IF

	COLUMN TITLE "N. Ticket" ;
         DATA ( dbfTikT )->CSERTIK + "/" + ltrim( ( dbfTikT )->CNUMTIK ) + "/" + ( dbfTikT )->CSUFTIK ;
         SIZE 10 ;
			FONT 2

	COLUMN TITLE "Fecha" ;
			DATA ( dbfTikT )->DFECTIK;
			SIZE 8 ;
			FONT 2

	COLUMN TITLE "Hora" ;
			DATA ( dbfTikT )->CHORTIK;
			SIZE 8 ;
			FONT 2

	IF !lAgrupa
	COLUMN TITLE "Cod. Cliente" ;
			DATA ( dbfTikT )->CCLITIK;
			SIZE 10 ;
			FONT 2

	COLUMN TITLE "Cliente" ;
			DATA RetClient( ( dbfTikT )->CCLITIK, dbfClient );
			SIZE 30 ;
			FONT 2

	END IF

	COLUMN TITLE 	"Total " + if( lEuro, "Euros", "" ) ;
         DATA     nTotal( (dbfTikT)->CSERTIK + (dbfTikT)->CNUMTIK + (dbfTikT)->CSUFTIK, dbfTikT, dbfTikL, dbfDivisa, nil, if( lEuro, "EUR", nil ), .f. ) ;
         PICTURE  ( if( lEuro, cPorDiv( "EUR", dbfDivisa ), cPorDiv( ( dbfTikT )->CDIVTIK, dbfDivisa ) ) ) ;
			SIZE 		10 ;
			TOTAL ;
			FONT 		2

	IF lAgrupa
		GROUP ON (dbfTikT)->CCLITIK ;
			HEADER 	"Cliente : " + oReport:aGroups[1]:cValue + " - " + ;
						RetClient( oReport:aGroups[1]:cValue, dbfClient ) + " - " + ;
						"N.I.F. : " + RetCifCli( ( dbfTikT )->CCLITIK, dbfClient ) ;
			EJECT ;
			FONT 3
	END IF

	END REPORT

	IF oReport:lCreated

		oReport:Margin( 0, RPT_RIGHT, RPT_CMETERS )
		oReport:bSkip := {|| (dbfTikT)->( dbSkip() ) }

		IF lAgrupa
			oReport:aGroups[1]:cValue := cCliDesde
			oReport:aGroups[1]:lEject := lSalto
		END IF

	END IF

	ACTIVATE REPORT oReport	;
      FOR   (dbfTikT)->DFECTIK >= dInfDesde                 .AND. ;
            (dbfTikT)->DFECTIK <= dInfHasta                 .AND. ;
            (dbfTikT)->CCLITIK >= cCliDesde                 .AND. ;
            (dbfTikT)->CCLITIK <= cCliHasta                 .AND. ;
            ( (dbfTikT)->CSERTIK == "A" .AND. lSerieA .OR. (dbfTikT)->CSERTIK == "B" .AND. lSerieB );
      WHILE !(dbfTikT)->( eof() )

	oFont1:end()
	oFont2:end()
	oFont3:end()

	( dbfClient )->( dbGoTo( nRecNo1 ) )
	( dbfTikT )->( dbGoTo( nRecNo2 ) )

RETURN NIL

//---------------------------------------------------------------------------//

STATIC FUNCTION TikDiaTik( dInfDesde, dInfHasta, cTitulo, cSubTitulo, dbfTikT, dbfTikL, lSerieA, lSerieB, lEuro )

	local oPrn
	local nLinTot
	local nTotEnd	:= 0
	local cPort		:= aIniApp()[CPRTIMPTPV]

	( dbfTikT )->( OrdSetFocus( "DFECTIK" ) )
	( dbfTikT )->( dbSeek( dInfDesde ), .t. )

	/*
   Creaci¢n del objeTO PRINTER
	*/

	oPrn := TDosPrn():New( cPort )

	/*
	Impresi¢n de Tiket. Titulo Centrado y enfatizado.
	*/

	oPrn:write( retChr( aIniApp()[CIMPCENTPV] ) )					// +Centrado
	oPrn:write( retChr( aIniApp()[CIMPNEGTPV] ) )					// +Negrita

	oPrn:write( Rtrim( cTitulo ) + CRLF )								// Titulo
	oPrn:write( Rtrim( cSubTitulo ) + CRLF )							// SubTitulo

	oPrn:write( retChr( aIniApp()[CIMPNNETPV] ) )					// -Negrita
	oPrn:write( retChr( aIniApp()[CIMPNCETPV] ) )					// -Centrado

	oPrn:write( CRLF )														// Linea en blanco

	/*
	Fechas
	*/

	oPrn:write( "Desde " + dtoc( dInfDesde ) + " hasta " + dtoc( dInfHasta ) + CRLF )

	oPrn:write( CRLF )														// Linea en blanco

	/*
	Cabecera
	*/

	oPrn:write( padr( "Tiket", 12)	+ " " + ;
					padr( "Fecha", 8 )	+ " " + ;
					padr( "Hora",  5 )	+ " " + ;
					padl( "Total", 12) 	+ CRLF )

	oPrn:write( Replicate( "-", 40 ) + CRLF )

   WHILE ( dbfTikT )->DFECTIK <= dInfHasta      .AND.;
         ( (dbfTikT)->CSERTIK == "A" .AND. lSerieA .OR. (dbfTikT)->CSERTIK == "B" .AND. lSerieB ) .AND.;
         !( dbfTikT )->( eof() )


      nLinTot  := nTotal( (dbfTikT)->CNUMTIK + (dbfTikT)->CSUFTIK, dbfTikT, dbfTikL, dbfDivisa, nil, if( lEuro, "EUR", nil ), .t. )
		nTotEnd 	+= nLinTot

		oPrn:write( padr( ( dbfTikT )->CNUMTIK, 12)	+ " " + ;
						padr( ( dbfTikT )->DFECTIK, 8 )	+ " " + ;
						padr( ( dbfTikT )->CHORTIK, 5 )	+ " " + ;
                  padl( nLinTot, 12) + CRLF )

		( dbfTikT )->( dbSkip( 1 ) )

	END DO

	oPrn:write( Replicate( "-", 40 ) + CRLF )

	oPrn:write( padr( "Total Final", 20 )	+ " " + ;
					padl( Trans( nTotEnd, "@E 9,999,999,999"), 19)	+ CRLF )

	/*
	Eject
	*/

	oPrn:write( retChr( aIniApp()[CIMPEJCTPV] ) )
	oPrn:end()

RETURN NIL

/*
Diario de Ventas por cajero
*/

FUNCTION InfDiaCaj()

	local oDlg
	local oBntPrev
	local oBtnImpr
	local oBtnCancel
   local oCajDesde
   local oCajHasta
   local cCajDesde
   local cCajHasta
   local oNomCajDesde
   local oNomCajHasta
   local cNomCajDesde
   local cNomCajHasta
	local dbfTikT
	local dbfTikL
   local dbfCajero
   local dbfDivisa
   local dInfDesde   := Date()
	local dInfHasta	:= Date()
   local cTitulo     := Padr( cCodEmp() + " - " + cNbrEmp(), 100 )
   local cSubTitulo  := Padr( "Diario de ventas por cajero", 100 )

	/*
	Bases de datos para el informe
	*/

	dbCommitAll()

   USE ( cPatEmp() + "TIKET.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKET", @dbfTikT ) )
   SET ADSINDEX TO ( cPatEmp() + "TIKET.CDX" ) ADDITIVE
   SET TAG TO "CCCJTIK"

   USE ( cPatEmp() + "TIKEL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKEL", @dbfTikL ) )
   SET ADSINDEX TO ( cPatEmp() + "TIKEL.CDX" ) ADDITIVE

   USE ( cPatEmp() + "CAJERO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CAJERO", @dbfCajero ) )
   SET ADSINDEX TO ( cPatEmp() + "CAJERO.CDX" ) ADDITIVE

   USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDivisa ) )
   SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

	/*
	Obtenemos los valores del primer y ultimo codigo
	*/

   cCajDesde   := (dbfCajero)->CCODCAJ
   (dbfCajero)->(dbGoBottom())
   cCajHasta   := (dbfCajero)->CCODCAJ
   (dbfCajero)->(dbGoTop())

	/*
	Caja de dialogo
	*/

   DEFINE DIALOG oDlg RESOURCE "INF_DIACAJ"

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

   REDEFINE GET oCajDesde VAR cCajDesde;
		ID 		120 ;
		COLOR 	CLR_GET ;
      VALID    ( cUser( oCajDesde, dbfCajero, oNomCajDesde ) ) ;
      BITMAP   "LUPA" ;
      ON HELP  ( BrwUser( oCajDesde, dbfCajero, oNomCajDesde ) ) ;
		OF 		oDlg

   REDEFINE GET oNomCajDesde VAR cNomCajDesde ;
		WHEN 		.F. ;
		COLOR 	CLR_GET ;
		ID 		121 ;
		OF 		oDlg

   REDEFINE GET oCajHasta VAR cCajHasta;
		ID 		130 ;
		COLOR 	CLR_GET ;
      VALID    ( cUser( oCajHasta, dbfCajero, oNomCajHasta ) ) ;
      BITMAP   "LUPA" ;
      ON HELP  ( BrwUser( oCajHasta, dbfCajero, oNomCajHasta ) ) ;
		OF 		oDlg

   REDEFINE GET oNomCajHasta VAR cNomCajHasta ;
		WHEN 		.F. ;
		COLOR 	CLR_GET ;
		ID 		131 ;
		OF 		oDlg

	REDEFINE GET cTitulo ;
      ID       160 ;
		OF 		oDlg

	REDEFINE GET cSubTitulo ;
      ID       170 ;
		OF 		oDlg

	REDEFINE BUTTON ;
		ID 		508 ;
		OF 		oDlg ;
      ACTION ( aEval( oDlg:aControls, { | oCtrl | oCtrl:disable() } ),;
               GenDiaCaj( dInfDesde, dInfHasta, cCajDesde, cCajHasta, 1, cTitulo, cSubTitulo, dbfTikT, dbfTikL, dbfCajero, dbfDivisa ),;
               aEval( oDlg:aControls, { | oCtrl | oCtrl:enable() } ) )

	REDEFINE BUTTON ;
		ID 		505;
		OF 		oDlg ;
      ACTION ( aEval( oDlg:aControls, { | oCtrl | oCtrl:disable() } ),;
               GenDiaCaj( dInfDesde, dInfHasta, cCajDesde, cCajHasta, 2, cTitulo, cSubTitulo, dbfTikT, dbfTikL, dbfCajero, dbfDivisa ),;
					AEval( oDlg:aControls, { | oCtrl | oCtrl:enable() } ) )

	REDEFINE BUTTON ;
		ID 		557;
		OF 		oDlg ;
      ACTION ( aEval( oDlg:aControls, { | oCtrl | oCtrl:disable() } ),;
               TikDiaCaj( dInfDesde, dInfHasta, cCajDesde, cCajHasta, cTitulo, cSubTitulo, dbfTikT, dbfTikL, dbfCajero, dbfDivisa ),;
               aEval( oDlg:aControls, { | oCtrl | oCtrl:enable() } ) )

	REDEFINE BUTTON oBtnCancel ;
      ID       IDOK ;
		OF 		oDlg ;
		ACTION 	( oDlg:end() )

	ACTIVATE DIALOG oDlg CENTER;
      ON PAINT ( oCajDesde:lValid(), oCajHasta:lValid() )

	CLOSE ( dbfTikT )
	CLOSE ( dbfTikL )
   CLOSE ( dbfCajero )

RETURN NIL

//---------------------------------------------------------------------------//

STATIC FUNCTION GenDiaCaj( dInfDesde, dInfHasta, cCajDesde, cCajHasta, nDevice, cTitulo, cSubTitulo, dbfTikT, dbfTikL, dbfCajero, dbfDivisa )

	local oFont1
	local oFont2
	local oFont3
   local nRecno1  := ( dbfCajero )->( RecNo() )
   local nRecno2  := ( dbfTikT   )->( RecNo() )

	/*
	Posicionamiento en el registro inicial
	*/

   ( dbfTikT )->( dbSeek( cCajDesde ) )

   /*
   Comienza el listado
   */

	DEFINE FONT oFont1 NAME "Courier New" SIZE 0,-12 BOLD
   DEFINE FONT oFont2 NAME "Courier New" SIZE 0,-10
   DEFINE FONT oFont3 NAME "Arial" SIZE 0,-10 BOLD

	IF nDevice == 1

		REPORT oReport ;
			TITLE 	Rtrim( cTitulo), Rtrim( cSubTitulo ), "" ;
			FONT   	oFont1, oFont2, oFont3 ;
			HEADER 	"Periodo : " + dToC( dInfDesde ) + " -> " + dToC( dInfHasta ),;
                  "Cajero : " + cCajDesde + " -> " + cCajHasta,;
						"Fecha : " + Dtoc( Date() ) RIGHT ;
			FOOTER 	"Página : " + str( oReport:nPage, 3 ) CENTERED;
         CAPTION  "Diario de ventas por cajeros";
			PREVIEW

	ELSE

      REPORT oReport ;
			TITLE 	Rtrim( cTitulo), Rtrim( cSubTitulo ), "" ;
			FONT   	oFont1, oFont2, oFont3 ;
			HEADER 	"Periodo : " + dToC( dInfDesde ) + " -> " + dToC( dInfHasta ),;
                  "Cajero : " + cCajDesde + " -> " + cCajHasta,;
						"Fecha : " + Dtoc( Date() ) RIGHT ;
			FOOTER 	"Página : " + str( oReport:nPage, 3 ) CENTERED;
         CAPTION  "Diario de ventas por cajeros";
         TO PRINTER

	END IF

	COLUMN TITLE "N. Ticket" ;
			DATA ( dbfTikT )->CNUMTIK ;
			SIZE 10 ;
			FONT 2

	COLUMN TITLE "Fecha" ;
			DATA ( dbfTikT )->DFECTIK;
			SIZE 8 ;
			FONT 2

	COLUMN TITLE "Hora" ;
			DATA ( dbfTikT )->CHORTIK;
			SIZE 8 ;
			FONT 2

   COLUMN TITLE   "Total" ;
         DATA     nTotal( (dbfTikT)->CSERTIK + (dbfTikT)->CNUMTIK + (dbfTikT)->CSUFTIK, dbfTikT, dbfTikL, dbfDivisa, nil, nil, .f. ) ;
         PICTURE  ( cPouDiv( ( dbfTikT )->CDIVTIK, dbfDivisa ) ) ;
			SIZE 		10 ;
			TOTAL ;
			FONT 		2

   GROUP ON (dbfTikT)->CCCJTIK ;
         HEADER   "Cajero : " + oReport:aGroups[1]:cValue + " - " + ;
                  RetUser( oReport:aGroups[1]:cValue, dbfCajero ) ;
         EJECT ;
			FONT 3

	END REPORT

	IF oReport:lCreated
		oReport:Margin( 0, RPT_RIGHT, RPT_CMETERS )
		oReport:bSkip := {|| (dbfTikT)->( dbSkip() ) }
   END IF

	ACTIVATE REPORT oReport	;
		FOR 	(dbfTikT)->DFECTIK >= dInfDesde .AND. ;
				(dbfTikT)->DFECTIK <= dInfHasta .AND. ;
            (dbfTikT)->CCCJTIK >= cCajDesde .AND. ;
            (dbfTikT)->CCCJTIK <= cCajHasta ;
		WHILE !(dbfTikT)->( eof() )

	oFont1:end()
	oFont2:end()
	oFont3:end()

   ( dbfCajero )->( dbGoTo( nRecNo1 ) )
   ( dbfTikT   )->( dbGoTo( nRecNo2 ) )

RETURN NIL

//---------------------------------------------------------------------------//

STATIC FUNCTION TikDiaCaj( dInfDesde, dInfHasta, cCajDesde, cCajHasta, cTitulo, cSubTitulo, dbfTikT, dbfTikL, dbfCajero, dbfDivisa )

	local oPrn
   local cCodCaj
	local nLinTot
	local nTotEnd	:= 0
	local cPort		:= aIniApp()[CPRTIMPTPV]
   local nRecno1  := ( dbfCajero )->( RecNo() )
   local nRecno2  := ( dbfTikT   )->( RecNo() )

   ( dbfTikT )->( dbSeek( cCajDesde ) )

	/*
   Creaci¢n del objeTO PRINTER
	*/

	oPrn := TDosPrn():New( cPort )

	/*
	Impresi¢n de Tiket. Titulo Centrado y enfatizado.
	*/

	oPrn:write( retChr( aIniApp()[CIMPCENTPV] ) )					// +Centrado
	oPrn:write( retChr( aIniApp()[CIMPNEGTPV] ) )					// +Negrita

   oPrn:write( Rtrim( cTitulo    ) + CRLF )                    // Titulo
	oPrn:write( Rtrim( cSubTitulo ) + CRLF )							// SubTitulo

	oPrn:write( retChr( aIniApp()[CIMPNNETPV] ) )					// -Negrita
	oPrn:write( retChr( aIniApp()[CIMPNCETPV] ) )					// -Centrado

	oPrn:write( CRLF )														// Linea en blanco

	/*
	Fechas
	*/

	oPrn:write( "Desde " + dtoc( dInfDesde ) + " hasta " + dtoc( dInfHasta ) + CRLF )
	oPrn:write( CRLF )														// Linea en blanco

   /*
   Grupo
   */

   oPrn:write( "Cajero : " + (dbfTikT)->CCCJTIK + RetUser( (dbfTikT)->CCCJTIK, dbfCajero ) + CRLF )
   cCodCaj := (dbfTikT)->CCCJTIK

	/*
	Cabecera
	*/

	oPrn:write( padr( "Tiket", 12)	+ " " + ;
					padr( "Fecha", 8 )	+ " " + ;
					padr( "Hora",  5 )	+ " " + ;
					padl( "Total", 12) 	+ CRLF )

	oPrn:write( Replicate( "-", 40 ) + CRLF )

   /*
   Posicionamos en el primer registro
   */

   ( dbfTikT )->( __dbLocate( {|| ( dbfTikT )->DFECTIK >= dInfDesde } ) )

	WHILE ( dbfTikT )->DFECTIK <= dInfHasta .AND. !( dbfTikT )->( eof() )

      nLinTot  := nTotal( (dbfTikT)->CSERTIK + (dbfTikT)->CNUMTIK + (dbfTikT)->CSUFTIK, dbfTikT, dbfTikL, dbfDivisa, nil, nil, .f. )
      nTotEnd  += nLinTot

		oPrn:write( padr( ( dbfTikT )->CNUMTIK, 12)	+ " " + ;
						padr( ( dbfTikT )->DFECTIK, 8 )	+ " " + ;
						padr( ( dbfTikT )->CHORTIK, 5 )	+ " " + ;
                  padl( Trans( nLinTot, "@E 999,999,999"), 12) + CRLF )

		( dbfTikT )->( dbSkip( 1 ) )

      /*
      Grupo
      */

      if cCodCaj != (dbfTikT)->CCCJTIK .AND. !( dbfTikT )->( eof() )

         oPrn:write( Replicate( "-", 40 ) + CRLF )
         oPrn:write( padr( "Total", 20 ) + " " + padl( Trans( nTotEnd, "@E 9,999,999,999"), 19)  + CRLF )
         oPrn:write( Replicate( "-", 40 ) + CRLF )
         nTotEnd := 0

         oPrn:write( CRLF )
         oPrn:write( "Cajero : " + (dbfTikT)->CCCJTIK + RetUser( (dbfTikT)->CCCJTIK, dbfCajero ) + CRLF )
         oPrn:write( Replicate( "-", 40 ) + CRLF )

      end if

      cCodCaj := (dbfTikT)->CCCJTIK

	END DO

	oPrn:write( Replicate( "-", 40 ) + CRLF )
   oPrn:write( padr( "Total", 20 )  + " " + padl( Trans( nTotEnd, "@E 9,999,999,999"), 19) + CRLF )

	/*
	Eject
	*/

	oPrn:write( retChr( aIniApp()[CIMPEJCTPV] ) )
	oPrn:end()

   ( dbfCajero )->( dbGoTo( nRecNo1 ) )
   ( dbfTikT   )->( dbGoTo( nRecNo2 ) )

RETURN NIL

//------------------------------------------------------------------------//

STATIC FUNCTION ErsMov()

	( dbfTmp )->( dbCloseArea() )
   fErase( cPatTmp() + "INFMOV.DBF" )
   fErase( cPatTmp() + "INFMOV.CDX" )

RETURN NIL

//------------------------------------------------------------------------//
STATIC FUNCTION nTotal( cNumTik, dbfTikT, dbfTikL, dbfDivisa, aTmp, cDiv, lPic )

   local cPouDiv
   local nDouDiv
   local bCond
   local nChgDiv
   local cCodDiv
   local nVdvDiv
	local nTotal 		:= 0
	local nRecno 		:= ( dbfTikL )->( recNo() )

   DEFAULT lPic      := .f.

   IF aTmp != nil
      cCodDiv        := aTmp[ _CDIVTIK ]
      nVdvDiv        := aTmp[ _NVDVTIK ]
      bCond          := {|| ( dbfTikL )->( !eof() ) }
      ( dbfTikL )->( dbGoTop() )
   ELSE
      cCodDiv        := ( dbfTikT )->CDIVTIK
      nVdvDiv        := ( dbfTikT )->NVDVTIK
      bCond          := {|| ( dbfTikT )->CSERTIK + ( dbfTikL )->CNUMTIL + ( dbfTikL )->CSUFTIL == cNumTik .AND. !( dbfTikL )->( eof() ) }
      ( dbfTikL )->( dbSeek( cNumTik ) )
   END IF

   IF cDiv != NIL
      cPouDiv        := cPouDiv( cDiv, dbfDivisa )
      cPorDiv        := cPorDiv( cDiv, dbfDivisa ) // Picture de la divisa redondeada
      nDouDiv        := nDouDiv( cDiv, dbfDivisa )
      nDorDiv        := nRouDiv( cDiv, dbfDivisa ) // Decimales de redondeo
      nVdvDiv        := nValDiv( cDiv, dbfDivisa )
   ELSE
      cPouDiv        := cPouDiv( cCodDiv, dbfDivisa )
      cPorDiv        := cPorDiv( cCodDiv, dbfDivisa ) // Picture de la divisa redondeada
      nDouDiv        := nDouDiv( cCodDiv, dbfDivisa )
      nDorDiv        := nRouDiv( cCodDiv, dbfDivisa ) // Decimales de redondeo
   END IF

   WHILE eval( bCond )

      IF !( dbfTikL )->LFRETIL
         nTotal += nTotLTpv( dbfTikL, nDouDiv, nDorDiv, nVdvDiv )
         nTotal += ( dbfTikL )->NPCMTIL * ( dbfTikL )->NUNTTIL
      END IF
		( dbfTikL )->( dbSkip(1) )

	END WHILE

	( dbfTikL )->( dbGoTo( nRecno ) )

   nTotal      := Round( nTotal, nDorDiv )

	/*
	Guardamos el valor en Euros

   nTotalEur   := nTotal / nChgDiv( cCodDiv, .t., dbfDivisa )
   */

RETURN ( if( lPic, Trans( nTotal, cPorDiv ), nTotal ) )

//----------------------------------------------------------------------------//

/*
Devuelve el precio unitario
*/

STATIC FUNCTION nTotUTpv( dbfTmp, nDec, nVdv )

   local nCalculo := ( dbfTmp )->NPVPTIL
   nCalculo       += ( dbfTmp )->NPCMTIL     // Precio combinado
   nCalculo       -= ( dbfTmp )->NDTODIV     // Descuentos unitarios

   IF nVdv != 0
      nCalculo    := nCalculo / nVdv
	END IF

RETURN ( round( nCalculo, nDec ) )

//--------------------------------------------------------------------------//

STATIC FUNCTION nTotUd( cNumTik, dbfTikL )

	local nTotal 		:= 0
	local nRecno 		:= ( dbfTikL )->( recNo() )

	( dbfTikL )->( dbSeek( cNumTik ) )

   WHILE ( dbfTikL )->CSERTIL +( dbfTikL )->CNUMTIL + ( dbfTikL )->CSUFTIL == cNumTik .AND. !( dbfTikL )->( eof() )

		nTotal += ( dbfTikL )->NUNTTIL
		( dbfTikL )->( dbSkip(1) )

	END WHILE

	( dbfTikL )->( dbGoTo( nRecno ) )

Return ( nTotal )

//----------------------------------------------------------------------------//

STATIC FUNCTION nTotLTpv( dbfTmp, nDec, nRouDec, nVdv )

   local nCalculo := 0

   DEFAULT nDec   := nDouDiv( ( dbfTmp )->CDIVTIK, dbfDivisa )
   DEFAULT nVdv   := ( dbfTmp )->NVDVTIK

   IF !( dbfTmp )->LFRETIL

      nCalculo := ( dbfTmp )->NPVPTIL                       // Precio
      nCalculo -= ( dbfTmp )->nDtoDiv                       // Dto Lineal
      nCalculo -= ( dbfTmp )->nDtoLin * nCalculo / 100      // Dto porcentual
      nCalculo += ( dbfTmp )->NPCMTIL                       // Precio de combinado
      nCalculo *= ( dbfTmp )->NUNTTIL                       // Unidades

      IF nVdv != 0
         nCalculo    := Round( nCalculo / nVdv, nDec )
      END IF

   END IF

RETURN ( round( nCalculo, nRouDec ) )

//--------------------------------------------------------------------------//