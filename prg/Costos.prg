#include "FiveWin.Ch"
#include "Report.ch"
#include "Factu.ch"

static cAlias, cAliDeta, cAliCli, cAliIva, cAliPago

//----------------------------------------------------------------------------//

FUNCTION InfPdtCob( oWnd )

   local oBlock
   local oError
	local oInf
	local oFont1, oFont2, oFont3
	local oGet1, oGet2, oGet3, oGet4, oGet5, oGet6
	local dDesde, dHasta
	local cNomAge
	local cNomRut
	local oDlg
	local cCodRut 	:= "000"
	local cCodAge 	:= "000"
	local lPdte 	:= .t.
	local nDevice 	:= 1

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatEmp() + "FACCLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIT", @cAlias ) )
   SET ADSINDEX TO ( cPatEmp() + "FACCLIT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "FACCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIL", @cAliDeta ) )
   SET ADSINDEX TO ( cPatEmp() + "FACCLIL.CDX" ) ADDITIVE

   USE ( cPatEmp() + "FACCLIP.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIP", @cAliPago ) )
   SET ADSINDEX TO ( cPatEmp() + "FACCLIP.CDX" ) ADDITIVE

   USE ( cPatEmp() + "CLIENT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIENT", @cAliCli ) )
   SET ADSINDEX TO ( cPatEmp() + "CLIENT.CDX" ) ADDITIVE

   USE "DATOS\TIVA.DBF" NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @cAliIva ) )
   SET ADSINDEX TO "DATOS\TIVA.CDX" ADDITIVE

	(cAlias)->(ordSetFocus("FACTCLIT", "DFECFAC"))
	(cAlias)->(dbGoTop())
	dDesde	:= (cAlias)->DFECFAC

	(cAlias)->(dbGoBottom())
	dHasta	:= Date()

	/*
	Caja de dialogo
	*/

	DEFINE DIALOG oDlg RESOURCE "LSTPDTCOB"

	REDEFINE GET oGet1 VAR dDesde;
		ID 101 ;
		OF oDlg

	REDEFINE GET oGet2 VAR dHasta;
		ID 102 ;
		OF oDlg

	REDEFINE GET oGet3 VAR cCodAge;
		ID 103 ;
		PICTURE "@!" ;
		VALID cAgentes( oGet3, , oGet4 );
		OF oDlg

	REDEFINE GET oGet4 VAR cNomAge;
		ID 104 ;
		WHEN .F. ;
		OF oDlg

	REDEFINE GET oGet5 VAR cCodRut;
		ID 105 ;
		PICTURE "@!" ;
		VALID cRuta( oGet5,, oGet6 ) ;
		OF oDlg

	REDEFINE GET oGet6 VAR cNomRut;
		ID 106 ;
		WHEN .F. ;
		OF oDlg

	REDEFINE CHECKBOX lPdte ;
		ID 107 ;
		OF oDlg

   REDEFINE RADIO nDevice ;
		ID 109, 110 ;
		OF oDlg

	REDEFINE BUTTON ;
      ID       1;
      OF       oDlg ;
      ACTION   ( oDlg:end( IDOK ) )

	REDEFINE BUTTON ;
      ID       2;
      OF       oDlg ;
      CANCEL ;
      ACTION   ( oDlg:end() )

	ACTIVATE DIALOG oDlg CENTER

   IF oDlg:nResult == IDOK

		Select( cAlias )
//		(cAlias)->(ordSetFocus("CPOBCLI", "FACCLIT"))
		(cAlias)->(dbGoTop())

      DEFINE FONT oFont1 NAME "Arial" SIZE 0,-12 BOLD
      DEFINE FONT oFont2 NAME "Arial" SIZE 0,-12
      DEFINE FONT oFont3 NAME "Arial" SIZE 0,-10

		IF nDevice == 1
			REPORT oInf ;
			FONT   oFont1, oFont2, oFont3 ;
			HEADER "Listado de Facturas Pendientes de Cobro", "" CENTER ;
			TITLE xPadr( "Agente ", 60 ) + ":" + cCodAge + " " + cNomAge,;
					xPadr( "Ruta", 60 ) + ":" + cCodRut + " " + cNomRut,;
					"" LEFT ;
			CAPTION "Facturas Pendientes" ;
			PREVIEW

		ELSE

			REPORT oInf ;
			FONT   oFont1, oFont2, oFont3 ;
			HEADER "Listado de Facturas Pendientes de Cobro",;
					"Fecha del Listado : " + DtoC( Date() ) CENTER ;
			TITLE xPadr( "Agente ", 60 ) + ":" + cCodAge + " " + cNomAge,;
					xPadr( "Ruta", 60 ) + ":" + cCodRut + " " + cNomRut,;
					"" LEFT ;
			CAPTION "Facturas Pendientes" ;
         TO PRINTER

		END IF

		COLUMN TITLE "N. Factura" ;
			DATA (cAlias)->CSERIE + "/" + Str( (cAlias)->NNUMFAC );
			SIZE 7 ;
			FONT 2

		COLUMN TITLE "F. Factura" ;
			DATA (cAlias)->DFECFAC ;
			SIZE 6 ;
			FONT 2

		COLUMN TITLE " Cliente";
			DATA (cAlias)->CNOMCLI ;
			SIZE 30 ;
			FONT 2
	/*
		COLUMN TITLE OemToAnsi("Poblaci¢n") ;
			DATA (cAlias)->CPOBCLI;
			SIZE 14 ;
			FONT 2
	*/

		COLUMN TITLE "Importe" ;
         DATA nTotFacCli( (cAlias)->CSERIE + Str( (cAlias)->NNUMFAC ), cAlias, cAliDeta, cAliIva ) - nTotPagado();
			PICTURE "@E 99,999,999" ;
			TOTAL ;
			FONT 2

		END REPORT

      IF !Empty( oInf ) .and. oInf:lCreated
			oInf:bSkip := {|n| ( cAlias )->(dbSkip(n)) }
			oInf:Margin(0, RPT_LEFT, RPT_CMETERS)
			oInf:Margin(0, RPT_RIGHT, RPT_CMETERS)
		END IF

		ACTIVATE REPORT oInf ;
			FOR ( (cAlias)->DFECFAC >= dDesde ;
				.and. (cAlias)->DFECFAC <= dHasta ;
				.and. IF ( Empty(RTrim( cCodAge ) ), .T., (cAlias)->CCODAGE == cCodAge );
				.and. IF ( Empty(RTrim( cCodRut ) ), .T., (cAlias)->CCODRUT == cCodRut );
				.and. (cAlias)->LLIQUIDADA != lPdte )

		oFont1:end()
		oFont2:end()
		oFont3:end()

	END IF

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

	CLOSE (cAlias)
	CLOSE (cAliDeta)
	CLOSE (cAliCli)
	CLOSE (cAliIva)
	CLOSE (cAliPago)

RETURN NIL

//---------------------------------------------------------------------------//

STATIC FUNCTION nTotal( cFactura )

	local nIva
	local nTotalArt
	local nTotalDtoArt:= 0
	local nTotalIva 	:= 0
	local nTotalImp   := 0
	local nRecno    	:= (cAliDeta)->(RECNO())
	local nTotalFac 	:= 0
	local nTotalDto 	:= 0
	local nTotalNet 	:= 0

	DEFAULT cFactura	:= (cAlias)->CSERIE + Str( (cAlias)->NNUMFAC )

	IF cFactura != NIL

		IF (cAliDeta)->(DbSeek( cFactura, .t. ) )

			WHILE ( (cAliDeta)->CSERIE + Str( (cAliDeta)->NNUMFAC ) = cFactura )

			#ifndef CAMERO
				nTotalArt    = (cAliDeta)->NPREUNIT * (cAliDeta)->NUNICAJA
			#else
				nTotalArt    = (cAliDeta)->NPREUNIT * (cAliDeta)->NUNICAJA * (cAliDeta)->NCANENT
			#endif

				nTotalDtoArt = 0
				nTotalImp    = 0

				IF (cAliDeta)->NDTO != 0
					nTotalArt  -= Round( nTotalArt * (cAliDeta)->NDTO / 100 , 0)
				END IF

				nTotalNet += nTotalArt

				/*
				Descuentos
				*/

				IF (cAlias)->NDTOESP != 0
					nTotalDtoArt += Round( nTotalArt * (cAlias)->NDTOESP / 100, 0 )
				END IF

				IF (cAlias)->NDPP  != 0
					nTotalDtoArt += Round( nTotalArt * (cAlias)->NDPP / 100, 0 )
				END IF

				nTotalArt -= nTotalDtoArt

				nTotalIva += Round( nTotalArt * nIva( cAliIva, (cAliDeta)->NIVA ) / 100, 0 )

				nTotalImp += Round( nTotalArt * nIva( cAliIva, (cAliDeta)->NIVA ) / 100, 0 )

				IF (cAlias)->LRECARGO
					nTotalImp += Round( nTotalArt * nPReq( cAliIva, (cAliDeta)->NIVA ) / 100, 0 )
				END IF

				nTotalArt += nTotalImp

				(cAliDeta)->(DBSKIP())

				nTotalFac += nTotalArt

			END WHILE

		END IF

		(cAliDeta)->(DBGOTO(nRecno))

		nTotalFac += (cAlias)->NPORTES

	END IF

RETURN ( nTotalFac )

//--------------------------------------------------------------------------//

STATIC FUNCTION nTotPagado( cFactura )

	local nRecno			:= (cAliPago)->(RecNo())
	local nTotalPagado	:= 0

	DEFAULT cFactura		:= (cAlias)->CSERIE + Str( (cAlias)->NNUMFAC )

	IF (cAliPago)->( DbSeek( cFactura, .t. ) )

		WHILE ( (cAliPago)->CSERIE + Str((cAliPago)->NNUMFAC ) = cFactura )

			nTotalPagado += (cAliPago)->NIMPORTE
			(cAliPago)->(DbSkip())

		END WHILE

	END IF

	(cAliPago)->( DbGoTo( nRecNo ) )

RETURN nTotalPagado

//---------------------------------------------------------------------------//

FUNCTION InfFacCli( oWnd )

   local oBlock
   local oError
	local oInf
	local oDlg
	local oFont1, oFont2, oFont3
	local dDesde, dHasta
	local nBaseI, nReq, nBaseR
	local oIva, nIva
	local cTIva, cTReq
	local nDevice	:= 1
	local nPctIva	:= 0

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE "DATOS\FACCLIT" NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIT", @cAlias ) )
   SET ADSINDEX TO DATOS\FACCLIT ADDITIVE

   USE "DATOS\FACCLIL" NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIL", @cAliDeta ) )
   SET ADSINDEX TO DATOS\FACCLIL ADDITIVE

   USE "DATOS\TIVA" NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @cAliIva ) )
   SET ADSINDEX TO DATOS\TIVA ADDITIVE

	dDesde	:= CtoD( "01/01/" + Str( Year( Date() ) ) )
	dHasta	:= Date()

	DEFINE DIALOG oDlg ;
		RESOURCE "LSTFACIVA";
		TITLE "Listado de Facturas Emitidas"

	REDEFINE GET dDesde ;
		ID 110 ;
		OF oDlg

	REDEFINE GET dHasta ;
		ID 120 ;
		OF oDlg

	REDEFINE GET oIva VAR nPctIva ;
		VALID ( lTiva( cAliIva, nPctIva ) ) ;
		PICTURE "@E 99.9" ;
		ID 130 ;
		OF oDlg

	REDEFINE RADIO nDevice ;
		ID 140, 141 ;
		OF oDlg

	REDEFINE BUTTON ;
		ID 1 ;
		OF oDlg ;
      ACTION ( oDlg:end( IDOK ) )

	REDEFINE BUTTON ;
		ID 2 ;
		OF oDlg ;
		ACTION ( oDlg:end() )

	ACTIVATE DIALOG oDlg CENTER

   IF oDlg:nResult == IDOK

		cTIva	:= Trans( nPctIva, "@E 99.99" ) + "%"
		cTReq := Trans( nPReq( cAliIva, nPctIva ), "@E 99.99" ) + "%"

		SELECT ( cAlias )
		( cAlias )->(dbGoTop())

      DEFINE FONT oFont1 NAME "Arial" SIZE 0,-12 BOLD
      DEFINE FONT oFont2 NAME "Arial" SIZE 0,-12

		IF nDevice == 1

			REPORT oInf ;
			FONT   oFont1, oFont2 ;
			HEADER "Informe de Facturas Emitidas",;
                "Desglosadas por Tipos de " + cImp() + " " + cTIva ;
					 CENTER ;
			TITLE  xPadr( "Desde Fecha ", 80 ) + ":" + DtoC( dDesde ) ,;
					 xPadr( "Hasta Fecha ", 80 ) + ":" + DtoC( dHasta ) ,;
					 "" LEFT ;
			CAPTION "Estudios de Impuestos" ;
         TO PRINTER

		ELSE

			REPORT oInf ;
			FONT   oFont1, oFont2 ;
			HEADER "Informe de Facturas Emitidas",;
                "Desglosadas por Tipos de " + cImp() + " " + cTIva ;
					 CENTER ;
			TITLE  xPadr( "Desde Fecha ", 80 ) + ":" + DtoC( dDesde ),;
					 xPadr( "Hasta Fecha ", 80 ) + ":" + DtoC( dHasta ),;
					 "" LEFT ;
			CAPTION "Estudios de Impuestos" ;
			PREVIEW

		END IF

		COLUMN TITLE "N. Factura" ;
			DATA (cAlias)->CSERIE + "/" + Str( (cAlias)->NNUMFAC );
			SIZE 7 ;
			FONT 2

      COLUMN TITLE "Base al " + cImp() + " " + cTIva;
			DATA CalcBase( @nBaseI, @nIva, @nBaseR, @nReq, nPctIva ) ;
			PICTURE "@E 99,999,999,999" ;
			TOTAL ;
			SIZE 15 ;
			FONT 2

      COLUMN TITLE cImp() ;
			DATA nIva ;
			PICTURE "@E 99,999,999,999" ;
			TOTAL ;
			SIZE 15 ;
			FONT 2

		COLUMN TITLE "Base al R.E. " + cTReq  ;
			DATA nBaseR ;
			PICTURE "@E 99,999,999,999" ;
			TOTAL ;
			SIZE 15 ;
			FONT 2

		COLUMN TITLE "R.E." ;
			DATA nReq ;
			PICTURE "@E 99,999,999,999" ;
			TOTAL ;
			SIZE 15 ;
			FONT 2

		END REPORT

		IF oInf:lCreated
			oInf:bSkip 	:= {|| Skipper( cAlias, cAliDeta, nPctIva ) }
			oInf:bWhile	:= {|| ( cAlias )->( !Eof() ) }
			oInf:Margin( 0, RPT_LEFT, RPT_CMETERS )
			oInf:Margin( 0, RPT_RIGHT, RPT_CMETERS )
		END IF

		ACTIVATE REPORT oInf ;
			FOR ( (cAlias)->DFECFAC >= dDesde .AND. (cAlias)->DFECFAC <= dHasta )

		oFont1:end()
		oFont2:end()

	END IF

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

	CLOSE ( cAlias )
	CLOSE ( cAliDeta )
	CLOSE ( cAliIva )

RETURN NIL

//---------------------------------------------------------------------------//

STATIC FUNCTION CalcBase( nBaseI, nIva, nBaseR, nReq, nPctIva, cFactura )

	local nTotDto	:= 0
	local nImporte	:= 0

	nBaseI			:= 0
	nBaseR			:= 0
	nIva				:= 0
	nReq				:= 0

	DEFAULT cFactura	:= (cAlias)->CSERIE + Str( (cAlias)->NNUMFAC )

	IF (cAliDeta)->( DbSeek( cFactura, .t. ) )

		WHILE (cAliDeta)->CSERIE + Str( (cAliDeta)->NNUMFAC ) == cFactura

			IF (cAliDeta)->NIVA == nPctIva

				#ifndef CAMERO
				nImporte	= Round( (cAliDeta)->NPREUNIT * (cAliDeta)->NUNICAJA , 0 )
				#else
				nImporte	= Round( (cAliDeta)->NPREUNIT * (cAliDeta)->NUNICAJA * (cAliDeta)->NCANENT, 0 )
				#endif

				IF (cAliDeta)->NDTO != 0
					nImporte -= Round( nImporte * (cAliDeta)->NDTO / 100, 0 )
				END IF

				nBaseI	+=	nImporte

			END IF

		(cAliDeta)->( DbSkip() )

		END DO

		/*
		Descuentos
		*/

		IF (cAlias)->NDTOESP != 0
			nTotDto += Round( nBaseI * (cAlias)->NDTOESP / 100, 0 )
		END IF

		IF (cAlias)->NDPP  != 0
			nTotDto += Round( nBaseI * (cAlias)->NDPP / 100, 0 )
		END IF

		nBaseI	-= nTotDto

		nIva 		:= Round( nBaseI * nPctIva / 100, 0 )

		IF (cAlias)->LRECARGO
			nBaseR	:= nBaseI
			nReq 		:= Round( nBaseR * nPReq( cAliIva, nPctIva ) / 100, 0 )
		END IF

	END IF

RETURN nBaseI

//---------------------------------------------------------------------------//

STATIC FUNCTION Skipper( cAlias, cAliDeta, nPctIva )

	local cFactura

	WHILE ( cAlias )->( !Eof() )

		(cAlias)->(DbSkip())

		cFactura := (cAlias)->CSERIE + Str( (cAlias)->NNUMFAC )

		IF (cAliDeta)->( DbSeek( cFactura, .t. ) )

			WHILE (cAliDeta)->CSERIE + Str( (cAliDeta)->NNUMFAC ) == cFactura

				IF (cAliDeta)->NIVA == nPctIva
					RETURN NIL
				END IF

				( cAliDeta )->( DbSkip() )

			END WHILE

		END IF

	END WHILE

RETURN NIL

//-------------------------------------------------  {% 7 <  <
 v*¥ 9 ~& )  v*µ 9 ~& )  v*∂ 9 ~& )  v*∑ 9 ~& )  v*∏ 9	 ~& )  v*∫ {y  `‡†⁄  ∏ ª  Sª  SPö    ÉƒÀ*  ( *¡ |/
 *… CCODART C ; |, CNOMART C ;2 |, CFAMART C ; |, NNUMCAJ N ;
 ; , NNUMUND N ;
 ; , NIMPART N ;
 ; , NPRDMED N ;
 ; , NIVAART N ;
 ; , , / *À ' TMP\INFMOV.DBF 7 DBFCDX ' *Ã 	 zDBFCDX TMP\INFMOV.DBF  INFMOV 8	 ) d' *Õ ( TMP\INFMOV.CDX CFAMART CFAMART # *Õ ) _' *Œ  TMP\INFMOV.CDX ' *– * 7 9 ~ã< v*— + 7 9 ~â< v*◊ 9 ~, )  v*Ÿ c9 ~Çpä*‹ 9 FAMILIA ô7 eK9 FAMILIA ô7 h6*‚ 7	 ~- )  v*„ 9 CODIGO ô7	 CCODART ò*‰ 9 NOMBRE ô7	 CNOMART ò*Â 9 FAMILIA ô7	 CFAMART ò*Ê . 9 CODIGO ô7 7 7 7 7 ) 7	 NNUMCAJ ò*Á / 9 CODIGO ô7 7 7 7 7 ) 7	 NNUMUND ò*Ë 0 nú ƒTDú »T%ú ƒT%ú ÃV:ı†£ ÷9 CODIGO ô7 7 7 7 7 ) 7	 NIMPART ò*È 1 9 CODIGO ô7 7 7 7 7 ) 7	 NIVAART ò*Ì 9 ~2 )  v*Ô * 7 7
 g]/
 < vk˛*Û 7	 ~& )  v*ı {y  `Œ†Z  ∏ ª  Sª  SPö    ÉƒÀ*  ( *ˇ |/ *9 ~3 7 ) *c9 CREF ô7 b˚ 9 ~ÇpÒ *	9 ~3 9 CSERIE ô9 NNUMFAC ô∫u9 CSUFFAC ôu) ° *9 DFECFAC ô7 eâ 9 DFECFAC ô7 ht 7  9 CSERIE ôA ^ d! 7  9 CSERIE ôB ^ d6 7  9 NPREUNIT ô|l z *7 9 NCANENT ôu/ *9 ~2 r) vÚ˛* 7 y  `ãú ƒTCú »T%ú ƒT%ú ÃV:ı†U  ∏ ª  Sª  SPö    ÉƒÀ*  ( **|/ *,9 ~3 7 ) *.c9 CREF ô7 bˆ 9 ~ÇpÏ *49 ~3 9 CSERIE ô9 NNUMFAC ô∫u9 CSUFFAC ôu) ú *=9 DFECFAC ô7 eÑ 9 DFECFAC ô7 ho 7  9 CSERIE ôA ^ d! 7  9 CSERIE ôB ^ d1 7  9 NPREUNIT ô|l z *?7 4 9 ) u/ *E9 ~2 r) v˜˛*K7 y  `êú ƒTBú »T%ú ƒT%ú ÃV:ı†X  ∏ ª  Sª  SPö    ÉƒÀ*  ( *U|/ *W9 ~3 7 ) *Yc9 CREF ô7 b˘ 9 ~ÇpÔ *_9 ~3 9 CSERIE ô9 NNUMFAC ô∫u9 CSUFFAC ôu) ü *h9 DFECFAC ô7 eá 9 DFECFAC ô7 hr 7  9 CSERIE ôA ^ d! 7  9 CSERIE ôB ^ d4 7  9 NPREUNIT ô|l z *j7 5 9 9 ) u/ *p9 ~2 r) vÙ˛*v7 y  `‡ú ƒTAú »T%ú ƒT%ú ÃV:ı†j  ∏ ª  Sª  SPö    ÉƒÀ*  ( *Ä|/ *Ç9 ~3 7 ) !*Ñc9 CREF ô7 b9 ~Çp*ä9 ~3 9 CSERIE ô9 NNUMFAC ô∫u9 CSUFFAC ôu) ± *ì9 DFECFAC ô7 eô 9 DFECFAC ô7 hÑ 7  9 CSERIE ôA ^ d! 7  9 CSERIE ôB ^ dF 7  9 NPREUNIT ô|l z( *ï7 5 9 9 ) 9 NIVA ôk;d \|∂u/ *õ9 ~2 r) v‚˛*°7 y  `Sú ƒT@ú »T%ú ƒT%ú ÃV:ı†Ÿ  ∏ ª  Sª  SPö    ÉƒÀ*  ( *¨ 6 )  Courier New |6Ùˇ{z{{{{{{{{{{{< / *≠ 6 )  Arial |6ˆˇ{{{{{{{{{{{{{< / *Æ 6 )  Arial |6ˆˇ{z{{{{{{{{{{{< / *∞	 zDBFCDX TMP\INFMOV.DBF  INFMOV 8
 ) d' *± TMP\INFMOV.CDX ' *≥7
 ~3 7 ) v*µ7 r– *ø7 # *ø4
 ¿_}# *ø4 ¿_}, ## *ø
Periodo :  4 •u ->  u4 •u_}# *ø
Fecha   :  ¢•u_, # *ø
P·gina  :  8 9 <  ; ªu_, 7 7 7 , ,  d{{dz{{Informe de familias {RIGHT CENTERED ) 9 › * 7 # * 4
 ¿_}# * 4 ¿_}# * q_, ## * 
Periodo :  4 •u ->  u4 •u_}# * 
Fecha   :  ¢•u_, # * 
P·gina  :  8 9 <  ; ªu_, 7 7 7 , ,  d{{dd{{Informe de familias {RIGHT CENTERED ) ]: ]; 9 *–< #
 *–Codigo ìú ƒT?ú »T%ú ƒT%ú ÃV:ı†Ÿ’_, {# *–4
 CCODART ô_}, {,  # *–; _d{{dd{' *‘< #
 *‘Nombre _, {# *‘4
 CNOMART ô_}, {,  # *‘; _d{{dd{' *÷7 \ *›< # *›Cajas _, {# *›4
 NNUMCAJ ô_}, ; @E 999,999,999 , # *›; _z{{dd{' *Â< # *ÂUnd. _, {# *Â4
 NNUMUND ô_}, ; @E 999,999,999 , # *Â; _z{{dd{' oo*Ï< # *ÏImporte _, {# *Ï4
 NIMPART ô_}, ; @E 999,999,999 , # *Ï; _z{{dd{' *Û< #
 *ÛIGIC _, {# *Û4
 NIVAART ô_}, ; @E 999,999,999 , # *Û; _z{{dd{' *ı7 n *¸< # *¸P. Medio _, {#! *¸4
 NIMPART ô4
 NNUMUND ô\_}, ; @E 999,999,999 , # *¸; _z{{dd{' *= # *4
 CFAMART ô_}#E *
Familia :  > ? 9 <  $ <  u- u@ > ? 9 <  $ <  9 ) *†j™u_#7 *Total de Movimiento--------------------------//

FUNCTION InfFacPrv( oWnd )

   local oBlock
   local oError
	local oInf
	local oDlg
	local oFont1, oFont2, oFont3
	local dDesde, dHasta
	local nBaseI, nReq, nBaseR
	local oIva, nIva
	local cTIva, cTReq
	local nDevice	:= 1
	local nPctIva	:= 0

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE "DATOS\FACPRVT" NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVT", @cAlias ) )
   SET ADSINDEX TO DATOS\FACPRVT ADDITIVE

   USE "DATOS\FACPRVL" NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVL", @cAliDeta ) )
   SET ADSINDEX TO DATOS\FACPRVL ADDITIVE

   USE "DATOS\TIVA" NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @cAliIva ) )
   SET ADSINDEX TO DATOS\TIVA ADDITIVE

	dDesde	:= CtoD( "01/01/" + Str( Year( Date() ) ) )
	dHasta	:= Date()

	DEFINE DIALOG oDlg RESOURCE "LSTFACIVA";
		TITLE "Listado de Facturas Recibidas"

	REDEFINE GET dDesde ;
		ID 110 ;
		OF oDlg

	REDEFINE GET dHasta ;
		ID 120 ;
		OF oDlg

	REDEFINE GET oIva VAR nPctIva ;
		VALID ( lTiva( cAliIva, nPctIva ) );
		PICTURE "@E 99.99";
		ID 130 ;
		OF oDlg

	REDEFINE RADIO nDevice ;
		ID 140, 141 ;
		OF oDlg

	REDEFINE BUTTON ;
		ID 1 ;
		OF oDlg ;
      ACTION ( oDlg:end( IDOK ) )

	REDEFINE BUTTON ;
		ID 2 ;
		OF oDlg ;
		ACTION ( oDlg:end() )

	ACTIVATE DIALOG oDlg CENTER

   IF oDlg:nResult == IDOK

		cTIva	:= Trans( nPctIva, "@E 99.99" ) + "%"
		cTReq := Trans( nPReq( cAliIva, nPctIva ), "@E 99.99" ) + "%"

		SELECT ( cAlias )

      DEFINE FONT oFont1 NAME "Arial" SIZE 0,-12 BOLD
      DEFINE FONT oFont2 NAME "Arial" SIZE 0,-12

		IF nDevice == 1

			REPORT oInf ;
			FONT   oFont1, oFont2 ;
			HEADER "Informe de Facturas Recibidas",;
                "Desglosadas por Tipos de " + cImp() + " " + cTIva ;
					 CENTER ;
			TITLE  xPadr( "Desde Fecha ", 80 ) + ":" + DtoC( dDesde ) ,;
					 xPadr( "Hasta Fecha ", 80 ) + ":" + DtoC( dHasta ) ,;
					 "" LEFT ;
			CAPTION "Estudios de Impuestos" ;
         TO PRINTER

		ELSE

			REPORT oInf ;
			FONT   oFont1, oFont2 ;
			HEADER "Informe de Facturas Recibidas",;
                "Desglosadas por Tipos de " + cImp() + " " + cTIva ;
					 CENTER ;
			TITLE  xPadr( "Desde Fecha ", 80 ) + ":" + DtoC( dDesde ),;
					 xPadr( "Hasta Fecha ", 80 ) + ":" + DtoC( dHasta ),;
					 "" LEFT ;
			CAPTION "Estudios de Impuestos" ;
			PREVIEW

		END IF

		COLUMN TITLE "N. Factura" ;
			DATA Str( (cAlias)->NNUMFAC );
			SIZE 7 ;
			FONT 2

      COLUMN TITLE "Base al " + cImp() + " " + cTIva;
			DATA CalcBase2( @nBaseI, @nIva, @nBaseR, @nReq, nPctIva ) ;
			PICTURE "@E 99,999,999,999" ;
			TOTAL ;
			SIZE 15 ;
			FONT 2

      COLUMN TITLE cImp() ;
			DATA nIva ;
			PICTURE "@E 99,999,999,999" ;
			TOTAL ;
			SIZE 15 ;
			FONT 2

		COLUMN TITLE "Base al R.E. " + cTReq  ;
			DATA nBaseR ;
			PICTURE "@E 99,999,999,999" ;
			TOTAL ;
			SIZE 15 ;
			FONT 2

		COLUMN TITLE "R.E." ;
			DATA nReq ;
			PICTURE "@E 99,999,999,999" ;
			TOTAL ;
			SIZE 15 ;
			FONT 2

		END REPORT

		IF oInf:lCreated
			oInf:bSkip 	:= {|| Skipper2( cAlias, cAliDeta, nPctIva ) }
			oInf:bWhile	:= {|| ( cAlias )->(!eof()) }
			oInf:Margin( 0, RPT_LEFT, RPT_CMETERS )
			oInf:Margin( 0, RPT_RIGHT, RPT_CMETERS )
		END IF

		ACTIVATE REPORT oInf ;
			FOR ((cAlias)->DFECFAC >= dDesde .AND. (cAlias)->DFECFAC <= dHasta)

		oFont1:end()
		oFont2:end()

	END IF

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

	CLOSE ( cAlias )
	CLOSE ( cAliDeta )
	CLOSE ( cAliIva )

RETURN NIL

//---------------------------------------------------------------------------//

STATIC FUNCTION Skipper2( cAlias, cAliDeta, nPctIva )

	local cFactura

	WHILE ( cAlias )->( !Eof() )

		(cAlias)->(DbSkip())

		cFactura := (cAlias)->NNUMFAC

		IF (cAliDeta)->( DbSeek( cFactura, .t. ) )

			WHILE (cAliDeta)->NNUMFAC == cFactura

				IF (cAliDeta)->NIVA == nPctIva
					RETURN NIL
				END IF

				( cAliDeta )->( DbSkip() )

			END WHILE

		END IF

	END WHILE

RETURN NIL

//---------------------------------------------------------------------------//

STATIC FUNCTION CalcBase2( nBaseI, nIva, nBaseR, nReq, nPctIva, cFactura )

	local nTotDto	:= 0
	local nImporte	:= 0

	nBaseI			:= 0
	nBaseR			:Ä
 REINDEXAñ˙  REINDEXACODEINDEXOCODE	SELECTITMCODESTATICS$CODEC_ETEXTENDCODE	_SYMSTARTSYMSTARTSYMBOLSSYMBOLS_SYMENDSYMENDNULLBEGDATA_DATADATA_SYMPBDATA_SYMPDATA_SYMPEDATA_CONSTCONST_MSGMSG_BEGBSSBEGBSS_BSSBSS_ENDBSSENDBSSDGROUPêò @–2ò @ ò @Æbò @ƒ 	Kò H  
ò h  
ﬂò `¿ò h  ◊ò h  ”ò H  Ôò H  Îò H ﬂò H  „ò H  ﬂò (  ˚ò H   !◊ò H  "#”ò H  $%œà ¿ P   óö &ˇˇ
åWERRORSYS MSGSTOP 
DBCLOSEALL AINIAPP AINI TDIALOG 	TCHECKBOX TMETER TBUTTON MSGALERT 	RXEMPRESA RXTIVA 	RXFAMILIA 
RXGRPVENTA RXFPAGO RXDOCS RXLBL RXAGENDA RXTMOV RXNOTAS RXTARIFA RXPROMO RXOFERTA RXPRO 
RXARTICULO RXTBLCNV RXCLIENT RXPROVEE 	RXAGENTES RXRUTA 	RXALMACEN RXHISMOV 
RXPERSONAL 	RXSECCION 	RXOPERACI RXOBRAS RXDIV RXPEDPRV RXALBPRV RXFACPRV RXABNPRV RXPLTCLI RXPRECLI RXPEDCLI RXALBCLI RXFACCLI RXABNCLI RXDEPAGE RXEXTAGE RXTPV RXCAJERO RXCAJAS RXENTSAL RXTURNO 
CLEANSTOCK INOUTSTK __ltable 
__PLANKTON 
__acrtused 	DISPBEGIN 
CLIPPER530 /à
 ÄüCLIPPER@à	 ÄüEXTENDàà ÄüTERMINALÚà	 ÄüDBFNTXä†ÿ  ∏ ª  Sª  SPö    ÉƒÀ*  ( *î   7 <  <  {lO *ï  Imposible realizar reindexaciÛn Existen procesos abiertos ' *ñ {yJ*ù  '  *ü  )  $ 0{ *† 	 )  $ 0| *¢ 
  )  {{{{{NEW_REINDEX {d;Ä {{{{d{{{{{< / *¶  
 )  ;_ # ( *¶ t|^ 9R  7 ]0R _7 {{{{{{d{< 0* *¨   )  ;d # ( *¨ t|^ 4  7 ]. _}{7 d{Empresas d
    ‡ˇˇoA|{{< 0 *∞  
 )  ;i # ( *∞ t|^ 9S  7 ]0S _7 {{{{{{d{< 0+ *∂   )  ;n # ( *∂ t|^ 4  7 ]. _}{7 d{   Tipos IGIC d
    ‡ˇˇoA|{{< 0 *∫  
 )  ;s # ( *∫ t|^ 9T  7 ]0T _7 {{{{{{d{< 0, *¿   )  ;x # ( *¿ t|^ 4  7 ]. _}{7 d{Familias d
    ‡ˇˇoA|{{< 0 *ƒ  
 )  ;} # ( *ƒ t|^ 9U  7 ]0U _7 {{{{{{d{< 0- *   ƒú ƒTEú »T8ú ƒT8ú ÃV:ı†ÿ‘ )  ;Ç # ( *  t|^ 4  7 ]. _}{7 d{Grupos Vta. d
    ‡ˇˇoA|{{< 0 *Œ  
 )  ;á # ( *Œ t|^ 9V  7 ]0V _7 {{{{{{d{< 0. *‘   )  ;å # ( *‘ t|^ 4  7 ]. _}{7 d{Formas Pago d
    ‡ˇˇoA|{{< 0 *ÿ  
 )  ;ë # ( *ÿ t|^ 9W  7 ]0W _7 {{{{{{d{< 0/ *ﬁ   )  ;ñ # ( *ﬁ t|^ 4 o 7 ]. _}{7 d{
Documentos d
    ‡ˇˇoA|{{< 0 *‚  
 )  ;õ # ( *‚ t|^ 9^  7 ]0^ _7 {{{{{{d{< 06 *Ë   )  ;† # ( *Ë t|^ 4  7 ]. _}{7 d{Agenda d
    ‡ˇˇoA|{{< 0
 *Ï  
 )  ;• # ( *Ï t|^ 9Y  7 ]0Y _7 {{{{{{d{< 01 *Ú   )  ;™ # ( *Ú t|^ 4  7 ]. _}{7 d{Movimientos d
    ‡ˇˇoA|{{< 0 *ˆ  
 )  ;Ø # ( *ˆ t|^ 9Z  7 ]0Z _7 {{{{{{d{< 02 Ó†⁄®*¸   )  ;¥ # ( *¸ t|^ 4  7 ]. _}{7 d{Notas d
    ‡ˇˇoA|{{< 0	 *  
 )  ;π # ( * t|^ 9d  7 ]0d _7 {{{{{{d{< 0< *  )  ;æ # ( *t|^ 4  7 ]. _}{7 d{Tarifas d
    ‡ˇˇoA|{{< 0 *
 
 )  ;√ # ( *
t|^ 9e  7 ]0e _7 {{{{{{d{< 0= *  )  ;» # ( *t|^ 4  7 ]. _}{7 d{Promociones d
    ‡ˇˇoA|{{< 0 * 
 )  ;Õ # ( *t|^ 9y  7 ]0y _7 {{{{{{d{< 0P *  )  ;“ # ( *t|^ 4  7 ]. _}{7 d{Ofertas d
    ‡ˇˇoA|{{< 0( * 
 )  ;◊ # ( *t|^ 9z  7 ]0z _7 {{{{{{d{< 0Q *$  )  ;‹ # ( *$t|^ 4  7 ]. _}{oo7 d{Propiedades d
    ‡ˇˇoA|{{< 0) *, 
 )  ;· # ( *,t|^ 9[  7 ]0[ _7 {{{{{{d{< 03 *2G†⁄~  )  ;Ê # ( *2t|^ 4  7 ]. _}{7 d{	Articulos d
    ‡ˇˇoA|{{< 0
 *6 
 )  ;Î # ( *6t|^ 9\  7 ]0\ _7 {{{{{{d{< 04 *<  )  ; # ( *<t|^ 4  7 ]. _}{7 d{Clientes d
    ‡ˇˇoA|{{< 0 *@ 
 )  ;ı # ( *@t|^ 9]  7 ]0] _7 {{{{{{d{< 05 *F  )  ;˙ # ( *Ft|^ 4  7 ]. _}{7 d{Proveedores d
    ‡ˇˇoA|{{< 0 *J 
 )  ;ˇ # ( *Jt|^ 9X  7 ]0X _7 {{{{{{d{< 00 *P  )  ;# ( *Pt|^ 4  7 ]. _}{7 d{Agentes d
    ‡ˇˇoA|{{< 0 *T 
 )  ;	# ( *Tt|^ 9_  7 ]0_ _7 {{{{{{d{< 07 *Z  )  ;# ( *Zt|^ 4  7 ]. _}{7 d{Rutas d
    ‡ˇˇoA|{{< 0 *^ 
 )  ;# ( *^t|^ 9`  7 ]0` _7 {{{{{{d{< 08 *d  }†⁄T)  ;# ( *dt|^ 4  7 ]. _}{7 d{Almacen d
    ‡ˇˇoA|{{< 0 *h 
 )  ;# ( *ht|^ 9a  7 ]0a _7 {{{{{{d{< 09 *n  )  ;"# ( *nt|^ 4  7 ]. _}{7 d{Personal d
    ‡ˇˇoA|{{< 0 *r 
 )  ;'# ( *rt|^ 9c  7 ]0c _7 {{{{{{d{< 0; *x  )  ;,# ( *xt|^ 4  7 ]. _}{7 d{	Secciones d
    ‡ˇˇoA|{{< 0 *| 
 )  ;1# ( *|t|^ 9b  7 ]0b _7 {{{{{{d{< 0: *Ç  )  ;6# ( *Çt|^ 4  7 ]. _}{7 d{Operaciones d
    ‡ˇˇoA|{{< 0 *Ü 
 )  ;;# ( *Üt|^ 9f  7 ]0f _7 {{{{{{d{< 0> *å  )  ;@# ( *åt|^ 4  7 ]. _}{7 d{Obras d
    ‡ˇˇoA|{{< 0 *ê 
 )  ;E# ( *ê