#include "FiveWin.ch"
#include "Folder.ch"
#include "Factu.ch" 
#include "Ini.ch"

#define SAVTIK                   "1"      // Salvar como tiket
#define SAVALB                   "2"      // Salvar como albaran
#define SAVFAC                   "3"      // Salvar como factura
#define SAVDEV                   "4"      // Salvar como devolución
#define SAVAPT                   "5"      // Salvar como apartado

static nLevel

static nView

static dbfTikT
static dbfTikL
static dbfTikP
static dbfEntT
static dbfDiv
static oBandera
static dbfFam
static dbfTmp
static dbfAlbCliT
static dbfAlbCliL
static dbfFacCliT
static dbfFacCliL
static dbfFacCliP
static dbfAntCliT
static dbfFPago
static dbfClient
static dbfIva
static dbfArqTmp
static dbfArt
static oTurno
static dFecEnt
static aTipPag
static aTipIva
static aTipFam
static aTipDiv
static aTotSay
static cCurTur
static oPrnTik
static nTotCnt    := 0
static nTotCrd    := 0
static nTotES     := 0
static nTotTik    := 0
static nTotAlb    := 0
static nTotAlc    := 0
static nTotFac    := 0
static nTotAbn    := 0
static nTotSal    := 0
static nTotCaj    := 0
static nTotCob    := 0
static nDifCob    := 0
static nDifTot    := 0
static nTotMet    := 0
static nPriTik    := "0"
static nLstTik    := "0"
static cCajTur
static dFecTur
static cHorTur
static cPicUnd
static cPouDiv
static cPorDiv
static nDouDiv
static nRouDiv
static aOpcImp     := { .t., .t., .t., .t., .t., .t. }

//Definición de la base de datos

static aBase1     := {  {"NNUMTUR"     ,"N",  4, 0, "Número del Turno" },;
                        {"DFECTUR"     ,"D",  8, 0, "Fecha del Cierre"},;
                        {"THORTUR"     ,"D",  8, 0, "Hora del cierre" },;
                        {"CCODCAJ"     ,"C",  3, 0, "Codigo del Cajero" } }

//----------------------------------------------------------------------------//

STATIC FUNCTION OpenFiles( lZoom )

   local aDbfTmp  := { {"CCODART"     ,"C", 18, 0, "Código del artículo" },;
                       {"CNOMART"     ,"C",100, 0, "Nombre del artículo"},;
                       {"NCANANT"     ,"N", 10, 1, "Cantidad anterior del artículo" },;
                       {"NCANACT"     ,"N", 10, 1, "Cantidad actual del artículo" },;
                       {"NPVPART"     ,"N", 16, 6, "Importe del artículo" } }

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lZoom  := .f.

   BEGIN SEQUENCE

   nView          := D():CreateView()

   
D():Get( "LogPorta", nView )

   USE ( cPatEmp() + "ENTSAL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ENTSAL", @dbfEntT ) )
   SET ADSINDEX TO ( cPatEmp() + "ENTSAL.CDX" ) ADDITIVE
   SET TAG TO "CTURENT"

   USE ( cPatEmp() + "TIKET.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKET", @dbfTikT ) )
   SET ADSINDEX TO ( cPatEmp() + "TIKET.CDX" ) ADDITIVE
   SET TAG TO "CTURTIK"

   USE ( cPatEmp() + "TIKEL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKEL", @dbfTikL ) )
   SET ADSINDEX TO ( cPatEmp() + "TIKEL.CDX" ) ADDITIVE

   USE ( cPatEmp() + "TIKEP.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKEP", @dbfTikP ) )
   SET ADSINDEX TO ( cPatEmp() + "TIKEP.CDX" ) ADDITIVE
   SET TAG TO "CTURPGO"

   USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDiv ) )
   SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

   USE ( cPatArt() + "FAMILIAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FAMILIAS", @dbfFam ) )
   SET ADSINDEX TO ( cPatArt() + "FAMILIAS.CDX" ) ADDITIVE

   USE ( cPatArt() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArt ) )
   SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

   USE ( cPatEmp() + "ALBCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIL", @dbfAlbCliL ) )
   SET ADSINDEX TO ( cPatEmp() + "ALBCLIL.CDX" ) ADDITIVE

   USE ( cPatEmp() + "FACCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIL", @dbfFacCliL ) )
   SET ADSINDEX TO ( cPatEmp() + "FACCLIL.CDX" ) ADDITIVE

   USE ( cPatEmp() + "AntCliT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AntCliT", @dbfAntCliT ) )
   SET ADSINDEX TO ( cPatEmp() + "AntCliT.CDX" ) ADDITIVE

   USE ( cPatCli() + "CLIENT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIENT", @dbfClient ) )
   SET ADSINDEX TO ( cPatCli() + "CLIENT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "FPAGO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FPAGO", @dbfFPago ) )
   SET ADSINDEX TO ( cPatEmp() + "FPAGO.CDX" ) ADDITIVE

   USE ( cPatDat() + "TIVA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfIva ) )
   SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE

   if !TDataCenter():OpenAlbCliT( @dbfAlbCliT )
      lOpenFiles     := .f.
   end if

   if !TDataCenter():OpenFacCliT( @dbfFacCliT )
      lOpen       := .f.
   end if

   if !TDataCenter():OpenFacCliP( @dbfFacCliP )
      lOpen       := .f.
   end if

   oBandera       := TBandera():New

   oTurno         := TTurno():New( cPatEmp() )
   oTurno:OpenFiles()

   if lExistTable( cPatTmp() + "ARQCON.DBF" )
      fEraseTable( cPatTmp() + "ARQCON.DBF" )
   end if

   if lExistTable( cPatTmp() + "ARQCON.CDX" )
      fEraseTable( cPatTmp() + "ARQCON.CDX" )
   end if

   /*
   Creamos el temporal---------------------------------------------------------
   */

   dbCreate  ( cPatTmp() + "ARQCON.DBF", aDbfTmp, cLocalDriver() )

   dbUseArea ( .t., cDriver(), cPatTmp() + "ARQCON.DBF", cCheckArea ("ARQCON", @dbfTmp ), .f. )
   ordCreate ( cPatTmp() + "ARQCON.CDX", "CCODART", "CCODART", {|| CCODART } )
   ordListAdd( cPatTmp() + "ARQCON.CDX" )

   if !lZoom

      ( dbfArt )->( dbGoTop() )
      while !( dbfArt )->( eof() )

         if ( ( dbfArt )->NCTLSTOCK ) == 2

            ( dbfTmp )->( dbAppend() )
            ( dbfTmp )->CCODART  := ( dbfArt )->CODIGO
            ( dbfTmp )->CNOMART  := ( dbfArt )->NOMBRE
            ( dbfTmp )->NCANANT  := ( dbfArt )->NCNTACT
            ( dbfTmp )->NCANACT  := ( dbfArt )->NCNTACT
            ( dbfTmp )->NPVPART  := ( dbfArt )->PVTAIVA1

         end if

         ( dbfArt )->( dbSkip() )

      end do

   end if

   ( dbfTmp )->( dbGoTop() )

   cPicUnd  := MasUnd()
   cPouDiv  := cPouDiv( cDivEmp(), dbfDiv )
   cPorDiv  := cPorDiv( cDivEmp(), dbfDiv )
   nDouDiv  := nDouDiv( cDivEmp(), dbfDiv )
   nRouDiv  := nRouDiv( cDivEmp(), dbfDiv )

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN lOpen

//----------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles( lDel )

   DEFAULT lDel      := .t.

   CLOSE ( dbfTikT    )
   CLOSE ( dbfTikL    )
   CLOSE ( dbfTikP    )
   CLOSE ( dbfEntT    )
   CLOSE ( dbfDiv     )
   CLOSE ( dbfFam     )
   CLOSE ( dbfArt     )
   CLOSE ( dbfTmp     )
   CLOSE ( dbfAlbCliT )
   CLOSE ( dbfAlbCliL )
   CLOSE ( dbfFacCliT )
   CLOSE ( dbfFacCliL )
   CLOSE ( dbfFacCliP )
   CLOSE ( dbfAntCliT )
   CLOSE ( dbfClient  )
   CLOSE ( dbfFPago   )
   CLOSE ( dbfIva     )

   oTurno:CloseFiles()
   oTurno:end()

   D():DeleteView( nView )

   dbfTikT     := NIL
   dbfTikL     := NIL
   dbfTikT     := NIL
   dbfEntT     := NIL
   dbfDiv      := NIL
   oBandera    := NIL
   dbfFam      := NIL
   dbfArt      := NIL
   dbfAlbCliT  := NIL
   dbfAlbCliL  := NIL
   dbfAntCliT  := NIL
   dbfClient   := NIL
   dbfFPago    := NIL
   dbfIva      := NIL
   dbfTmp      := NIL
   oTurno      := NIL

   if lDel
      if lExistTable( cPatTmp() + "ARQCON.DBF" )
         fEraseTable( cPatTmp() + "ARQCON.DBF" )
      end if

      if lExistTable( cPatTmp() + "ARQCON.CDX" )
         fEraseTable( cPatTmp() + "ARQCON.CDX" )
      end if
   end if

RETURN .T.

//----------------------------------------------------------------------------//

STATIC FUNCTION lCalcVta()

   local lRet  := .f.

   if Empty( cCajTur )
      MsgStop( "Debe de cumplimentar el nombre del cajero", "Imposible realizar cierre" )
      return .f.
   end if

	CursorWait()

   /*
	Inicializamos
	*/

   nTotTikCnt()
   nTotTikArt()
   nTotEntDia()

   nTotSal     := nTotCnt + nTotTik + nTotAlb + nTotAbn + nTotES + nTotFac

   nDifTot     := nTotAlc + nDifCob

   nTotMet     := nTotSal - nDifTot

   aTipPag     := { { "", 0 } }
   aTipDiv     := { { "", 0 } }
   aTipIva     := { { "", 0, 0, 0 } }
   aTipFam     := { { "", 0 } }

   aEval( aTotSay, {|o| o:Refresh() } )

RETURN ( .t. )

//----------------------------------------------------------------------------//

/*
Selecciona la fecha del Arqueo
*/

FUNCTION Arqueo( oMenuItem, oWnd )

   local lCloTur  := .f.

   dFecTur        := Date()
   cHorTur        := Substr( Time(), 1, 5 )
   cCajTur        := cCurUsr()

   if nLevel == nil
      nLevel      := nLevelUsr( oMenuItem )
   end if

   if nLevel != 1
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
   Apertura de ficheros________________________________________________________
   */

   if !OpenFiles()
      return nil
   end if

   /*
   Compruebo si hay turnos abiertos--------------------------------------------
   */

   if !oTurno:lOpenTurno()
      MsgInfo( "No hay turnos abiertos para cerrar." )
      CloseFiles()
      return .f.
   end if

   cCurTur        := oTurno:GetCurrentTurno()

   /*
   Datos para el arqueo--------------------------------------------------------
   */

   lCloTru        := lGetArqueo()

   CloseFiles( lCloTur )

RETURN NIL

//---------------------------------------------------------------------------//

function ZoomArqueo( oDbf, oDbfLin )

   /*
   Apertura de ficheros________________________________________________________
   */

   OpenFiles( .t. )

   cCurTur  := oDbf:cNumTur
   dFecTur  := oDbf:dOpnTur
   cHorTur  := oDbf:cHorOpn
   cCajTur  := oDbf:cCajTur

   if oDbfLin:Seek( cCurTur )

      while oDbfLin:cNumTur == cCurTur .and. !oDbfLin:Eof()
         ( dbfTmp )->( dbAppend() )
         ( dbfTmp )->cCodArt  := oDbfLin:cCodArt
         ( dbfTmp )->cNomArt  := oDbfLin:cNomArt
         ( dbfTmp )->nCanAnt  := oDbfLin:nCanAnt
         ( dbfTmp )->nCanAct  := oDbfLin:nCanAct
         ( dbfTmp )->nPvpArt  := oDbfLin:nPvpArt
         oDbfLin:Skip()
      end while

   end if

   ( dbfTmp )->( dbGoTop() )

   /*
   Datos para el arqueo--------------------------------------------------------
   */

   lGetArqueo( .t. )

   CloseFiles()

RETURN NIL

//---------------------------------------------------------------------------//

STATIC FUNCTION lGetArqueo( lZoom )

   local oDlg
   local oFld
   local oCajTur
   local oNomCaj
   local cNomCaj
   local oBrw
	local oBrw2
   local oBrwIva
   local oBrwDiv
	local oTotVta
	local oTotDia
   local oBtnMod
   local cLasTur

   DEFAULT lZoom  := .f.

   if !lZoom
      cLasTur     := oTurno:GetLastOpen()

      if Empty( cLasTur )
         MsgStop( "No hay turnos para cerrar" )
         return .f.
      end if

   else

      cLasTur     := oTurno:oDbf:cNumTur

   end if

   cCajTur        := if( Empty( cCurUsr() ), oTurno:oDbf:cCajTur, cCurUsr() )
   aTotSay        := Array( 20 )

   GetDlg()

   DEFINE DIALOG oDlg RESOURCE "ARQUEO";
      TITLE "Arqueo de caja, turno : " + Trans( cLasTur, "######" )

   REDEFINE PAGES oFld ID 200 OF oDlg ;
      DIALOGS "ARQUEO_1", "ARQUEO_2"

		/*
		Primera caja de dialogo_______________________________________________
		*/

      REDEFINE GET dFecTur ;
			ID 		100 ;
         WHEN     .f. ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET cHorTur ;
         ID       110 ;
         WHEN     .f. ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oCajTur VAR cCajTur;
         ID       120 ;
         WHEN     ( !lZoom ) ;
         VALID    cUser( oCajTur, nil, oNomCaj ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwUser( oCajTur, nil, oNomCaj ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oNomCaj VAR cNomCaj ;
         ID       130 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[1]

      REDEFINE BUTTON oBtnMod ;
         ID       501;
			OF 		oFld:aDialogs[1] ;
         ACTION   ( EdtCol( dbfTmp, oBrw ) )

      REDEFINE LISTBOX oBrw;
        FIELDS ;
                  (dbfTmp)->CCODART ,;
                  (dbfTmp)->CNOMART  ,;
                  Trans( (dbfTmp)->NCANANT, cPicUnd ) ,;
                  Trans( (dbfTmp)->NCANACT, cPicUnd ) ,;
                  Trans( (dbfTmp)->NCANACT - (dbfTmp)->NCANANT, cPicUnd ) ,;
                  Trans( (dbfTmp)->NPVPART, cPouDiv ) ,;
                  Trans( (dbfTmp)->NPVPART * ( (dbfTmp)->NCANACT - (dbfTmp)->NCANANT ), cPorDiv );
        HEAD;
                  "Codigo" ,;
                  "Nombre" ,;
                  "Nº Anterior" ,;
                  "Nº Actual" ,;
                  "Und. Vta." ,;
                  "Precio" ,;
                  "Tot. Vta.";
        FIELDSIZES ;
                  50 ,;
                  150,;
                  80 ,;
                  80 ,;
                  80 ,;
                  80 ,;
                  80  ;
        ALIAS     ( dbfTmp ) ;
        ID        140 ;
        OF        oFld:aDialogs[1]

      oBrw:aJustify     := { .f., .f., .t., .t., .t., .t., .t. }
      if !lZoom
      oBrw:bLDblClick   := {|| EdtCol( dbfTmp, oBrw ) }
      oBrw:bKeyDown     := {| nKey | If( nKey == VK_RETURN, EdtCol( dbfTmp, oBrw ), ) }
      end if
      oBrw:aFooters     := {||{"", "" , "" , "" , "", "", Trans( nTotTikCnt(), cPorDiv ) } }
      oBrw:lDrawFooters := .t.

		/*
      Segunda Caja de Dialogo_______________________________________________

		REDEFINE LISTBOX oBrw ;
			FIELDS ;
                  aTipPag[ oBrw:nAt, 1 ],;
                  Trans( aTipPag[ oBrw:nAt, 2 ], PicOut() );
			HEAD ;
                  "Serie",;
                  "Importe";
			FIELDSIZES ;
                  200,;
                  100 ;
         ID       100 ;
         OF       oFld:aDialogs[2]

			oBrw:aJustify := { .F., .T. }
			oBrw:setArray( aTipPag )

		REDEFINE LISTBOX oBrw2 ;
			FIELDS ;
						If( (dbfEntT)->NTIPENT == 1, "Entrada", "Salida" ),;
						(dbfEntT)->CDESENT,;
                  nTotES( nil, dbfEntT, dbfDiv, cDivEmp(), .t. ) ;
			HEAD 	;
						"Tipo",;
						"Descripción",;
						"Importe";
			FIELDSIZES;
						80,;
                  120,;
						80;
			ALIAS		( dbfEntT ) ;
         ID       110 ;
         SELECT   "CTURENT" FOR cLasTur ;
			OF 		oFld:aDialogs[2]

		oBrw2:aJustify := { .f., .f., .t. }

      REDEFINE LISTBOX oBrwDiv ;
			FIELDS ;
                  aTipDiv[ oBrwDiv:nAt, 1 ] + Space( 1 ) + cNomDiv( aTipDiv[ oBrwDiv:nAt, 1 ], dbfDiv ),;
                  hBmpDiv( aTipDiv[ oBrwDiv:nAt, 1 ], dbfDiv, oBandera ),;
                  Trans( aTipDiv[ oBrwDiv:nAt, 2 ], cPorDiv( aTipDiv[ oBrwDiv:nAt, 1 ], dbfDiv ) );
			HEAD ;
                  "Divisa",;
                  "Ban.",;
                  "Importe";
			FIELDSIZES ;
                  180,;
                  25,;
                  100;
         ID       120 ;
         OF       oFld:aDialogs[2]

			oBrwDiv:aJustify := { .f., .f., .t. }
			oBrwDiv:setArray( aTipDiv )

      REDEFINE LISTBOX oBrwIva ;
			FIELDS ;
                  Trans( aTipIva[ oBrwIva:nAt, 1 ], "@E 99.99 %" ),;
                  Trans( aTipIva[ oBrwIva:nAt, 2 ], PicOut() ),;
                  Trans( aTipIva[ oBrwIva:nAt, 3 ], PicOut() ),;
                  Trans( aTipIva[ oBrwIva:nAt, 4 ], PicOut() );
			HEAD ;
                  "%" + cImp(),;
                  "Base",;
                  cImp(),;
                  "Importe";
			FIELDSIZES ;
                  40,;
                  80,;
                  80,;
                  100 ;
         ID       130 ;
         WHEN     ( nTotTik != 0 ) ;
         OF       oFld:aDialogs[2]

			oBrwIva:aJustify := { .f., .t., .t., .t. }
			oBrwIva:setArray( aTipIva )

      REDEFINE LISTBOX oBrwFam ;
			FIELDS ;
                  aTipFam[ oBrwFam:nAt, 1 ] ,;
                  retFamilia( aTipFam[ oBrwFam:nAt, 1 ], dbfFam ) ,;
                  Trans( aTipFam[ oBrwFam:nAt, 2 ], PicOut() );
			HEAD ;
                  "Codigo",;
                  "Familia",;
                  "Importe";
			FIELDSIZES ;
                  50,;
                  150,;
                  80;
         ID       140 ;
         OF       oFld:aDialogs[2]

			oBrwFam:aJustify := { .f., .f., .t. }
			oBrwFam:setArray( aTipFam )
      */

      REDEFINE SAY aTotSay[ 15 ] VAR oTurno:oDbf:cCajTur ;
         ID       100 ;
         UPDATE ;
			OF 		oFld:aDialogs[2]

      REDEFINE SAY aTotSay[ 16 ] VAR oTurno:cNombreCajero() ;
         ID       101 ;
         UPDATE ;
			OF 		oFld:aDialogs[2]

      REDEFINE SAY aTotSay[ 17 ] VAR oTurno:oDbf:dOpnTur ;
         ID       110 ;
         UPDATE ;
			OF 		oFld:aDialogs[2]

      REDEFINE SAY aTotSay[ 18 ] VAR oTurno:oDbf:cHorOpn ;
         ID       120 ;
         UPDATE ;
			OF 		oFld:aDialogs[2]

      REDEFINE SAY aTotSay[ 19 ] VAR dFecTur ;
         ID       130 ;
         UPDATE ;
         OF       oFld:aDialogs[2]

      REDEFINE SAY aTotSay[ 20 ] VAR cHorTur ;
         ID       140 ;
         UPDATE ;
         OF       oFld:aDialogs[2]

      REDEFINE SAY aTotSay[ 1 ] VAR Val( nPriTik ) ;
         ID       150 ;
         UPDATE ;
			OF 		oFld:aDialogs[2]

      REDEFINE SAY aTotSay[ 2 ] VAR Val( nLstTik );
         ID       160 ;
         UPDATE ;
         OF       oFld:aDialogs[2]

      REDEFINE SAY aTotSay[ 3 ] VAR Val( nLstTik ) - Val( nPriTik ) + 1 ;
         ID       170 ;
         UPDATE ;
         OF       oFld:aDialogs[2]

      REDEFINE SAY aTotSay[ 4 ] VAR nTotCnt ;
         ID       180 ;
         PICTURE  cPorDiv ;
         UPDATE ;
         OF       oFld:aDialogs[2]

      REDEFINE SAY aTotSay[ 5 ] VAR nTotTik ;
         ID       190 ;
         PICTURE  cPorDiv ;
         UPDATE ;
         OF       oFld:aDialogs[2]

      REDEFINE SAY aTotSay[ 6 ] VAR nTotFac ;
         ID       200 ;
         PICTURE  cPorDiv ;
         UPDATE ;
         OF       oFld:aDialogs[2]

      REDEFINE SAY aTotSay[ 7 ] VAR nTotAlb ;
         ID       210 ;
         PICTURE  cPorDiv ;
         UPDATE ;
         OF       oFld:aDialogs[2]

      REDEFINE SAY aTotSay[ 8 ] VAR nTotAbn ;
         ID       220 ;
         PICTURE  cPorDiv ;
         UPDATE ;
         OF       oFld:aDialogs[2]

      REDEFINE SAY aTotSay[ 9 ] VAR nTotES ;
         ID       230 ;
         PICTURE  cPorDiv ;
         UPDATE ;
         OF       oFld:aDialogs[2]

      REDEFINE SAY aTotSay[ 10 ] VAR nTotSal ;
         ID       240 ;
         PICTURE  cPorDiv ;
         UPDATE ;
         OF       oFld:aDialogs[2]

      /*
      Cobros-------------------------------------------------------------------
      */

      REDEFINE SAY aTotSay[ 11 ] VAR nTotAlc ;
         ID       290 ;
         COLOR    CLR_RED ;
         PICTURE  cPorDiv ;
         UPDATE ;
         OF       oFld:aDialogs[2]

      REDEFINE SAY aTotSay[ 12 ] VAR nDifCob ;
         ID       300 ;
         COLOR    CLR_RED ;
         PICTURE  cPorDiv ;
         UPDATE ;
         OF       oFld:aDialogs[2]

      REDEFINE SAY aTotSay[ 13 ] VAR nDifTot ;
         ID       310 ;
         COLOR    CLR_RED ;
         PICTURE  cPorDiv ;
         UPDATE ;
         OF       oFld:aDialogs[2]

      REDEFINE SAY aTotSay[ 14 ] VAR nTotMet ;
         ID       320 ;
         PICTURE  cPorDiv ;
         UPDATE ;
         OF       oFld:aDialogs[2]

      REDEFINE BUTTON ;
         ID       280;
			OF 		oFld:aDialogs[2] ;
         ACTION   ( PrnArqueo( .f. ) )

      REDEFINE BUTTON ;
         ID       330;
			OF 		oFld:aDialogs[2] ;
         ACTION   ( PrnArqueo( .t. ) )

      REDEFINE CHECKBOX aOpcImp[1] ;
         ID       340;
         OF       oFld:aDialogs[2]

      REDEFINE CHECKBOX aOpcImp[2] ;
         ID       350;
         OF       oFld:aDialogs[2]

      REDEFINE CHECKBOX aOpcImp[3] ;
         ID       360;
         OF       oFld:aDialogs[2]

      REDEFINE CHECKBOX aOpcImp[4] ;
         ID       370;
         OF       oFld:aDialogs[2]

      REDEFINE CHECKBOX aOpcImp[5] ;
         ID       380;
         OF       oFld:aDialogs[2]

      REDEFINE CHECKBOX aOpcImp[6] ;
         ID       390;
         OF       oFld:aDialogs[2]

      /*
      Botones generales--------------------------------------------------------
      */

      REDEFINE BUTTON oBtnPrv ;
         ID       100 ;
         OF       oDlg ;
         ACTION   GoPrev( cLasTur, oFld, oBtnPrv, oBtnNxt, lZoom )

      REDEFINE BUTTON oBtnNxt ;
         ID       110 ;
         OF       oDlg ;
         ACTION   GoNext( cLasTur, oFld, oBtnPrv, oBtnNxt, cCajTur, oDlg, lZoom )

      REDEFINE BUTTON ;
         ID       120 ;
         OF       oDlg ;
         ACTION   oDlg:End()

   if lZoom
      oDlg:bStart := {|| lCalcVta( cCajTur, oDlg ), oFld:SetOption( 1 ), oCajTur:lValid(), oBtnMod:Hide() }
   else
      oDlg:bStart := {|| oCajTur:lValid() }
   end if

   ACTIVATE DIALOG oDlg CENTERED

   SetDlg()

RETURN ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//

static function SetDlg()

   local oIniApp
   local cIniApp  := cPatEmp() + "Empresa.Ini"

   INI oIniApp FILE cIniApp
      SET SECTION  "Arqueo" ENTRY "Opcion 1" TO aOpcImp[ 1 ] OF oIniApp
      SET SECTION  "Arqueo" ENTRY "Opcion 2" TO aOpcImp[ 2 ] OF oIniApp
      SET SECTION  "Arqueo" ENTRY "Opcion 3" TO aOpcImp[ 3 ] OF oIniApp
      SET SECTION  "Arqueo" ENTRY "Opcion 4" TO aOpcImp[ 4 ] OF oIniApp
      SET SECTION  "Arqueo" ENTRY "Opcion 5" TO aOpcImp[ 5 ] OF oIniApp
      SET SECTION  "Arqueo" ENTRY "Opcion 6" TO aOpcImp[ 6 ] OF oIniApp
   ENDINI

return nil

//----------------------------------------------------------------------------//

static function GetDlg()

   local oIniApp
   local cIniApp  := cPatEmp() + "Empresa.Ini"

   INI oIniApp FILE cIniApp

      GET aOpcImp[ 1 ] SECTION  "Arqueo" ENTRY "Opcion 1" OF oIniApp DEFAULT .t.
      GET aOpcImp[ 2 ] SECTION  "Arqueo" ENTRY "Opcion 2" OF oIniApp DEFAULT .t.
      GET aOpcImp[ 3 ] SECTION  "Arqueo" ENTRY "Opcion 3" OF oIniApp DEFAULT .t.
      GET aOpcImp[ 4 ] SECTION  "Arqueo" ENTRY "Opcion 4" OF oIniApp DEFAULT .t.
      GET aOpcImp[ 5 ] SECTION  "Arqueo" ENTRY "Opcion 5" OF oIniApp DEFAULT .t.
      GET aOpcImp[ 6 ] SECTION  "Arqueo" ENTRY "Opcion 6" OF oIniApp DEFAULT .t.

   ENDINI

return nil

//---------------------------------------------------------------------------//

static function GoPrev( cLasTur, oFld, oBtnPrv, oBtnNxt, lZoom )

   DEFAULT lZoom  := .f.

   do case
   case oFld:nOption == 2
      SetWindowText( oBtnNxt:hWnd, "S&iguiente >" )
   end case

   oFld:GoPrev()

return nil

//----------------------------------------------------------------------------//

static function GoNext( cLasTur, oFld, oBtnPrv, oBtnNxt, cCajTur, oDlg, lZoom )

   DEFAULT lZoom  := .f.

   do case
   case oFld:nOption == 1
      if !lCalcVta( cCajTur, oDlg )
         return nil
      end if
      SetWindowText( oBtnNxt:hWnd, "&Terminar" )
   case oFld:nOption == 2
      if !lZoom
         if lCloseTurno( cLasTur )
            oDlg:end( IDOK )
         else
            oDlg:end()
         end if
      else
         oDlg:end()
      end if

   end case

   oFld:GoNext()

return nil

//--------------------------------------------------------------------------//
/*
Calcula el total de una venta por articulos
*/

STATIC FUNCTION nTotTikArt()

   nTotTik  := 0
   nTotAlb  := 0
   nTotAlc  := 0
   nTotFac  := 0
   nTotAbn  := 0

   /*
   Cerrar por turnos__________________________________________________________________
   */

   if ( dbfTikT )->( dbSeek( cCurTur ) )

      nPriTik           := ( dbfTikT )->CNUMTIK

      while ( dbfTikT )->cTurTik == cCurTur .and. !( dbfTikT )->( eof() )

         do case
         case ( dbfTikT )->cTipTik == SAVTIK // Como tiket
            nTotTik  += nTotTik( ( dbfTikT )->CSERTIK + ( dbfTikT )->CNUMTIK + ( dbfTikT )->CSUFTIK, dbfTikT, dbfTikL, dbfDiv, nil, cDivEmp(), .f., .t. )
         case ( dbfTikT )->cTipTik == SAVALB // Como albaran
            if ( dbfAlbCliT )->( dbSeek( ( dbfTikT )->CNUMDOC ) )
               nTotAlb  += nTotAlbCli( ( dbfTikT )->CNUMDOC, dbfAlbCliT, dbfAlbCliL, dbfIva, dbfDiv, nil, cDivEmp(), .f., .t. )
               nTotAlc  += nTotAlbCli( ( dbfTikT )->CNUMDOC, dbfAlbCliT, dbfAlbCliL, dbfIva, dbfDiv, nil, cDivEmp(), .f., .f. )
            end if
         case ( dbfTikT )->cTipTik == SAVFAC // Como factura
            if ( dbfFacCliT )->( dbSeek( ( dbfTikT )->CNUMDOC ) )
               nTotFac  += nTotFacCli( ( dbfTikT )->CNUMDOC, dbfFacCliT, dbfFacCliL, dbfIva, dbfDiv, dbfFacCliP, dbfAntCliT, nil, cDivEmp(), .f., .t. )
            end if
         case ( dbfTikT )->cTipTik == SAVDEV // Como devolucion
            nTotAbn  -= nTotTik( ( dbfTikT )->CSERTIK + ( dbfTikT )->CNUMTIK + ( dbfTikT )->CSUFTIK, dbfTikT, dbfTikL, dbfDiv, nil, cDivEmp(), .f. )
         end case

         nLstTik        := ( dbfTikT )->CNUMTIK

         ( dbfTikT )->( dbSkip() )

      end do

   end if

RETURN ( nil )

//--------------------------------------------------------------------------//

STATIC FUNCTION nDifCobTik( )

   local nTmp  := 0

   nDifCob     := 0

   /*
   Cerrar por turnos__________________________________________________________________
   */

   if ( dbfTikT )->( dbSeek( cCurTur ) )

      while ( dbfTikT )->cTurTik == cCurTur .and. !( dbfTikT )->( eof() )

         do case
         case ( dbfTikT )->cTipTik == SAVTIK // Como tiket
            nTmp     := nTotTik( ( dbfTikT )->CSERTIK + ( dbfTikT )->CNUMTIK + ( dbfTikT )->CSUFTIK, dbfTikT, dbfTikL, dbfDiv, nil, cDivEmp(), .f. )
            nTmp     -= nTotCobTik( ( dbfTikT )->CSERTIK + ( dbfTikT )->CNUMTIK + ( dbfTikT )->CSUFTIK, dbfTikT, dbfTikP, dbfDiv, nil, cDivEmp(), .f. )
         case ( dbfTikT )->cTipTik == SAVFAC // Como factura
            if ( dbfFacCliT )->( dbSeek( ( dbfTikT )->CNUMDOC ) )
               nTmp     := nTotFacCli( ( dbfTikT )->CNUMDOC, dbfFacCliT, dbfFacCliL, dbfIva, dbfDiv, dbfFacCliP, dbfAntCliT, nil, cDivEmp(), .f. )
               nTmp     -= nPagFacCli( ( dbfTikT )->CNUMDOC, dbfFacCliT, dbfFacCliP, dbfIva, dbfDiv, cDivEmp(), dbfDiv )
            end if
         case ( dbfTikT )->cTipTik == SAVDEV // Como devolucion
            nTmp     := nTotTik( ( dbfTikT )->CSERTIK + ( dbfTikT )->CNUMTIK + ( dbfTikT )->CSUFTIK, dbfTikT, dbfTikL, dbfDiv, nil, cDivEmp(), .f. )
            nTmp     -= nTotCobTik( ( dbfTikT )->CSERTIK + ( dbfTikT )->CNUMTIK + ( dbfTikT )->CSUFTIK, dbfTikT, dbfTikP, dbfDiv, nil, cDivEmp(), .f. )
         end case

         nDifCob     += nTmp

         ( dbfTikT )->( dbSkip() )

      end do

   end if

RETURN ( nDifCob )

//--------------------------------------------------------------------------//

STATIC FUNCTION nTotCobDia()

   local nCob  := 0

   /*
   Cerrar por turnos__________________________________________________________________
   */

   if ( dbfTikP )->( dbSeek( cCurTur ) )

      WHILE ( dbfTikP )->cTurPgo == cCurTur .AND. !( dbfTikP )->( eof() )

         IF !( dbfTikP )->lCloPgo

            nCob  += ( ( dbfTikP )->nImpTik - ( dbfTikP )->nDevTik ) * ( dbfTikP )->nVdvPgo

            /*
            Estudios de las distintas formas de Pago
            */

         END IF

         ( dbfTikP )->( dbSkip() )

      END DO

   end if

RETURN ( nCob )

//------------------------------------------------------------------------//
/*
Calcula el total de movimientos de entradas y salidas por caja
*/

STATIC FUNCTION nTotEntDia( dFecha, lTur )

	local nRecno	:= ( dbfEntT )->( recNo() )

   nTotES         := 0

   /*
   Entradas y salidas_________________________________________________________
   */

   if ( dbfEntT )->( dbSeek( cCurTur ) )

      WHILE ( dbfEntT )->cTurEnt == cCurTur .and. !( dbfEntT )->( eof() )

         IF !( dbfEntT )->LCLOENT

            IF ( dbfEntT )->NTIPENT == 1
               nTotES   += nTotES( nil, dbfEntT, dbfDiv, cDivEmp(), .f. )
            ELSE
               nTotES   -= nTotES( nil, dbfEntT, dbfDiv, cDivEmp(), .f. )
            END IF

         END IF

         ( dbfEntT )->( dbSkip() )

      END DO

   end if

	( dbfEntT )->( dbGoTo( nRecno ) )

RETURN ( nTotCaj )

//------------------------------------------------------------------------//

/*
Devuelve el total de una linea
*/

STATIC FUNCTION nTotLinTik( cNumTik, dbfTikL )

	local nPos		:= 0
	local nTotLin	:= 0
	local nTotDet	:= 0
	local nBasLin	:= 0
	local nIvaLin	:= 0

	/*
	Inicializaci¢n
	*/

	IF ( dbfTikL )->( dbSeek( cNumTik ) )

		WHILE ( dbfTikL )->CSERTIL + ( dbfTikL )->CNUMTIL + ( dbfTikL )->CSUFTIL == cNumTik .AND. !( dbfTikL )->( eof() )

			/*
         Desglose de impuestos siempre trabajamos con impuestos Incluido
			*/

         nTotLin  := ( dbfTikL )->NUNTTIL * ( dbfTikL )->NPVPTIL
			nBasLin	:= Round( nTotLin / ( 1 + ( dbfTikL )->NIVATIL / 100 ), 0 )
			nIvaLin	:= Round( nBasLin * ( dbfTikL )->NIVATIL / 100, 0 )
			nTotDet 	+= nTotLin

			/*
         Estudios de los distintos tipos de impuestos
			*/

			nPos		:= aScan( aTipIva, {|x| x[1] == ( dbfTikL )->NIVATIL } )

			IF nPos 	!= 0
				aTipIva[ nPos, 2 ] += nBasLin
				aTipIva[ nPos, 3 ] += nIvaLin
				aTipIva[ nPos, 4 ] += nTotLin
			ELSE
				aAdd( aTipIva, { ( dbfTikL )->NIVATIL, nBasLin, nIvaLin, nTotLin } )
			END IF

			/*
			Estudios de las distintas Familias
			*/

			nPos		:= aScan( aTipFam, {|x| x[1] == ( dbfTikL )->CFAMTIL } )

			IF nPos 	!= 0
				aTipFam[ nPos, 2 ] += nTotLin
			ELSE
				aAdd( aTipFam, { ( dbfTikL )->CFAMTIL, nTotLin } )
			END IF

         /*
         Producto combinado____________________________________________________
         */

         IF !empty( ( dbfTikL )->CCOMTIL )

            /*
            Desglose de impuestos siempre trabajamos con impuestos Incluido
            */

            nTotLin  := ( dbfTikL )->NUNTTIL * ( dbfTikL )->NPCMTIL
            nBasLin  := Round( nTotLin / ( 1 + ( dbfTikL )->NIVATIL / 100 ), 0 )
            nIvaLin  := Round( nBasLin * ( dbfTikL )->NIVATIL / 100, 0 )
            nTotDet  += nTotLin

            /*
            Estudios de los distintos tipos de impuestos
            */

            nPos     := aScan( aTipIva, {|x| x[1] == ( dbfTikL )->NIVATIL } )

            IF nPos  != 0
               aTipIva[ nPos, 2 ] += nBasLin
               aTipIva[ nPos, 3 ] += nIvaLin
               aTipIva[ nPos, 4 ] += nTotLin
            ELSE
               aAdd( aTipIva, { ( dbfTikL )->NIVATIL, nBasLin, nIvaLin, nTotLin } )
            END IF

            /*
            Estudios de las distintas Familias
            */

            nPos     := aScan( aTipFam, {|x| x[1] == ( dbfTikL )->CFCMTIL } )

            IF nPos  != 0
               aTipFam[ nPos, 2 ] += nTotLin
            ELSE
               aAdd( aTipFam, { ( dbfTikL )->CFCMTIL, nTotLin } )
            END IF

         END IF

			/*
			Salto
			*/

			( dbfTikL )->( dbSkip() )

		END DO

	END IF

RETURN ( nTotDet )

//------------------------------------------------------------------------//

STATIC FUNCTION PrnArqueo( lPrev )

   local oBlock
   local oError
	local n
	local oPrn
   local cPort
   local nTotBas  := 0
	local nTotIva	:= 0
	local nTotImp	:= 0
   local nTotLin  := 0
   local nTotTot  := 0
   local cDbfTmp
   local aDbfTmp  := {  {"CCODART", "C", 18, 0, "Codigo de artículo" },;
                        {"CNOMART", "C", 50, 0, "Nombre de artículo" },;
                        {"NUNDART", "N", 19, 6, "Número de artículo" },;
                        {"NPVPART", "N", 19, 6, "Precio de artículo" },;
                        {"NIMPART", "N", 19, 6, "Importe total"      } }

   DEFAULT lPrev  := .t.

   /*
   Creamos el temporal---------------------------------------------------------
   */

   if file( cPatTmp() + "ARTTMP.DBF" )
      ferase( cPatTmp() + "ARTTMP.DBF" )
   end if

   if file( cPatTmp() + "ARTTMP.CDX" )
      ferase( cPatTmp() + "ARTTMP.CDX" )
   end if

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   dbCreate  ( cPatTmp() + "ARTTMP.DBF", aDbfTmp, cDriver() )
   dbUseArea ( .t., cDriver(), cPatTmp() + "ARTTMP.DBF", cCheckArea ("ARTTMP", @cDbfTmp ), .f. )
   ordCreate ( cPatTmp() + "ARTTMP.CDX", "CCODART", "CCODART", {|| CCODART } )
   ordListAdd( cPatTmp() + "ARTTMP.CDX" )

   /*
   Comprobamo si hay preview---------------------------------------------------------
   */

   if lPrev
      cPort          := "Print.prn"
   else

      if oPrnTik == nil
         oPrnTik     := TImpTik():New()
         oPrnTik:lBuildComm()
      end if
      cPort          := oPrnTik:cPort
   end if

   /*
   Si el puerto esta vacio taluegolucas
   */

   if empty( cPort )
      return nil
   end if

   oPrn              := TDosPrn():New( cPort )

   /*
   Nombre de la empresa--------------------------------------------------------
   */

   if !lPrev
      oPrn:write( RetChr( retChr( oPrnTik:cActCentrado ) ) )              // +Centrado
   end if

   oPrn:write( Padr( cCodEmp() + " - " + cNbrEmp(), 40 ) + CRLF )

   if !lPrev
      oPrn:write( retChr( retChr( oPrnTik:cActNegrita  ) ) )              // +Negrita
   end if

   oPrn:write( "A R Q U E O   D E   C A J A : " + cCurTur         + CRLF )  // Titulo
   oPrn:write( CRLF )

   oPrn:write( "Cajero: " + Rtrim( oTurno:cNombreCajero() )      + CRLF )  // Titulo
   oPrn:write( "Desde : " + oTurno:oDbf:cHorOpn + " - " + dToc( oTurno:oDbf:dOpnTur ) + CRLF )  // Titulo
   oPrn:write( "Hasta : " + cHorTur + " - " + Dtoc( dFecTur )     + CRLF )  // Titulo

	oPrn:write( CRLF )

   if !lPrev
      oPrn:write( retChr( retChr( oPrnTik:cDesCentrado ) ) )              // +Centrado
      oPrn:write( retChr( retChr( oPrnTik:cDesNegrita  ) ) )              // +Negrita
   end if

	/*
	Informaci¢n General________________________________________________________
	*/

   if !lPrev
      oPrn:write( retChr( retChr( oPrnTik:cActCentrado ) ) )              // +Centrado
   end if

   oPrn:write( "TICKETS EMITIDOS" + CRLF )
   oPrn:write( "----------------" + CRLF )

   if !lPrev
      oPrn:write( retChr( retChr( oPrnTik:cDesCentrado ) ) )              // +Centrado
   end if

	oPrn:write( "Primer Tiket : " + nPriTik + CRLF )
	oPrn:write( "Ultimo Tiket : " + nLstTik + CRLF )
	oPrn:write( "Total Tikets : " + Trans( Val( nLstTik ) - Val( nPriTik ) + 1, "9999999999" ) + CRLF )
	oPrn:write( CRLF )

   if !lPrev
      oPrn:write( retChr( retChr( oPrnTik:cActCentrado ) ) )              // +Centrado
   end if

   oPrn:write( "V E N T A S    T U R N O" + CRLF )
   oPrn:write( Replicate( "-", 40 )       + CRLF )
   oPrn:write( "Contadores   : "          + Trans( nTotCnt, cPorDiv )   + CRLF )
   oPrn:write( "Tickets      : "          + Trans( nTotTik, cPorDiv )   + CRLF )
   oPrn:write( "Facturas     : "          + Trans( nTotFac, cPorDiv )   + CRLF )
   oPrn:write( "Albaranes    : "          + Trans( nTotAlb, cPorDiv )   + CRLF )
   oPrn:write( "Devoluciones : "          + Trans( nTotAbn, cPorDiv )   + CRLF )
   oPrn:write( "E/S Caja     : "          + Trans( nTotES , cPorDiv )   + CRLF )
   oPrn:write( Replicate( "-", 40 )                                     + CRLF )
   oPrn:write( "Venta turno          : "  + Trans( nTotSal, cPorDiv )   + CRLF )
   oPrn:write( CRLF )
   oPrn:write( "Albaranes    : "          + Trans( nTotAlc, cPorDiv )   + CRLF )
   oPrn:write( "Pdte. Cobro  : "          + Trans( nDifCob, cPorDiv )   + CRLF )
   oPrn:write( Replicate( "-", 40 )                                     + CRLF )
   oPrn:write( "Crédito              : "  + Trans( nDifTot, cPorDiv )   + CRLF )
   oPrn:write( CRLF )
   oPrn:write( Replicate( "=", 40 ) + CRLF )
   oPrn:write( "M E T A L I C O      : "  + Trans( nTotMet, cPorDiv )   + CRLF )
   oPrn:write( Replicate( "=", 40 ) + CRLF )
   oPrn:write( CRLF )

   if !lPrev
      oPrn:write( retChr( retChr( oPrnTik:cDesCentrado ) ) )              // +Centrado
   end if

   /*
   Ventas por contadores-------------------------------------------------------
   */

   if aOpcImp[1]

   oPrn:write( "V E N T A    C O N T A D O R E S" + CRLF )
   oPrn:write( Replicate( "-",   40 )     + CRLF )
   oPrn:write( Padl( "Ant.",     7 ) + Space( 1 ) + ;
               Padl( "Act.",     7 ) + Space( 1 ) + ;
               Padl( "Salida",   7 ) + Space( 1 ) + ;
               Padl( "P.V.P.",   7 ) + Space( 1 ) + ;
               Padl( "Importe",  8 ) + CRLF )
   oPrn:write( Replicate( "-",   40 ) + CRLF )

   ( dbfTmp )->( dbGoTop() )
   while !( dbfTmp )->(eof() )

      oPrn:write( ( dbfTmp )->cCodArt + "-" + Padr( ( dbfTmp )->cNomArt, 25 ) + CRLF )

      nTotLin     := ( ( dbfTmp )->nCanAct - ( dbfTmp )->nCanAnt ) * ( dbfTmp )->nPvpArt
      nTotTot     += nTotLin

      oPrn:write( Trans( ( dbfTmp )->nCanAnt, "9999999" )                        + Space( 1 ) + ;
                  Trans( ( dbfTmp )->nCanAct, "9999999" )                        + Space( 1 ) + ;
                  Trans( ( dbfTmp )->nCanAct - ( dbfTmp )->nCanAnt, "9999999" )  + Space( 1 ) + ;
                  Right( Trans( ( dbfTmp )->nPvpArt, cPouDiv ), 7 )              + Space( 1 ) + ;
                  Right( Trans( nTotLin, cPorDiv ), 8 )                          + CRLF )

      ( dbfTmp )->( dbSkip() )

   end while

   oPrn:write( Replicate( "=", 40 ) + CRLF )
   oPrn:write( Padr( "Total Contadores : ", 32 ) + Right( Trans( nTotTot, cPorDiv ), 8 ) + CRLF )
   oPrn:write( CRLF )

   end if

   /*
   Ventas por tikets-------------------------------------------------------
   */

   if aOpcImp[2]

   nTotTot        := 0
   oPrn:write( "V E N T A    T  I  K  E  T  S" + CRLF )
   oPrn:write( Replicate( "-", 40 )  + CRLF )
   oPrn:Write( Padr( "Tik",      7 ) + Space( 1 ) + ;
               Padr( "Cod",      7 ) + Space( 1 ) + ;
               Padr( "Cliente",  15) + Space( 1 ) + ;
               Padl( "Importe",  8 ) + CRLF )
   oPrn:write( Replicate( "-", 40 )  + CRLF )

   if ( dbfTikT )->( dbSeek( cCurTur ) )

      while ( dbfTikT )->cTurTik == cCurTur .and. !( dbfTikT )->( eof() )

         if ( dbfTikT )->cTipTik == SAVTIK

            nTotLin     := nTotTik( ( dbfTikT )->CSERTIK + ( dbfTikT )->CNUMTIK + ( dbfTikT )->CSUFTIK, dbfTikT, dbfTikL, dbfDiv, nil, cDivEmp(), .f., .t. )

            nTotTot     += nTotLin

            oPrn:Write( Left( Padr( ( dbfTikT )->CSERTIK + AllTrim( ( dbfTikT )->CNUMTIK ) + ( dbfTikT )->CSUFTIK, 7 ) , 7 )  + Space( 1 ) + ;
                        Left( ( dbfTikT )->cCliTik, 7 )                                                                       + Space( 1 ) + ;
                        Left( ( dbfTikT )->cNomTik, 15)                                                                       + Space( 1 ) + ;
                        Right( Trans( nTotLin, cPorDiv ), 8 )                                                                 + CRLF )

         end if

         ( dbfTikT )->( dbSkip() )

      end while

   end if

   oPrn:write( Replicate( "=", 40 ) + CRLF )
   oPrn:write( Padr( "Total Tikets : ", 32 ) + Right( Trans( nTotTot, cPorDiv ), 8 ) + CRLF )
   oPrn:write( CRLF )

   end if

   /*
   Ventas por facturas-------------------------------------------------------
   */

   if aOpcImp[3]

   nTotTot        := 0

   oPrn:write( "V E N T A    F A C T U R A S" + CRLF )
   oPrn:write( Replicate( "-",  40 ) + CRLF )
   oPrn:Write( Padr( "Fac",      7 ) + Space( 1 ) + ;
               Padr( "Cod",      7 ) + Space( 1 ) + ;
               Padr( "Cliente", 15 ) + Space( 1 ) + ;
               Padl( "Importe",  8 ) + CRLF )
   oPrn:write( Replicate( "-",  40 ) + CRLF )

   if ( dbfTikT )->( dbSeek( cCurTur ) )

      while ( dbfTikT )->cTurTik == cCurTur .and. !( dbfTikT )->( eof() )

         if ( dbfTikT )->cTipTik == SAVFAC
            if ( dbfFacCliT )->( dbSeek( ( dbfTikT )->CNUMDOC ) )
               nTotLin  := nTotFacCli( ( dbfTikT )->CNUMDOC, dbfFacCliT, dbfFacCliL, dbfIva, dbfDiv, dbfFacCliP, dbfAntCliT, nil, cDivEmp(), .f. )
               nTotTot  += nTotLin
            end if

            oPrn:Write( Left( Padr( StrTran( ( dbfTikT )->CNUMDOC, " ", "" ), 7 ) , 7 )  + Space( 1 ) + ;
                        Left( ( dbfTikT )->cCliTik, 7 )                                                                       + Space( 1 ) + ;
                        Left( ( dbfTikT )->cNomTik, 15)                                                                       + Space( 1 ) + ;
                        Right( Trans( nTotLin, cPorDiv ), 8 )                                                                 + CRLF )

         end if

         ( dbfTikT )->( dbSkip() )

      end while

   end if

   oPrn:write( Replicate( "=", 40 ) + CRLF )
   oPrn:write( Padr( "Total Facturas : ", 32 ) + Right( Trans( nTotTot, cPorDiv ), 8 ) + CRLF )
   oPrn:write( CRLF )

   end if

   /*
   Ventas por albaranes-------------------------------------------------------
   */

   if aOpcImp[4]

   nTotTot        := 0

   oPrn:write( "V E N T A    A L B A R A N E S" + CRLF )
   oPrn:write( Replicate( "-",  40 ) + CRLF )
   oPrn:Write( Padr( "Alb",      7 ) + Space( 1 ) + ;
               Padr( "Cod",      7 ) + Space( 1 ) + ;
               Padr( "Cliente", 15 ) + Space( 1 ) + ;
               Padl( "Importe",  8 ) + CRLF )
   oPrn:write( Replicate( "-",  40 ) + CRLF )

   if ( dbfTikT )->( dbSeek( cCurTur ) )

      while ( dbfTikT )->cTurTik == cCurTur .and. !( dbfTikT )->( eof() )

         if ( dbfTikT )->cTipTik == SAVALB
            if ( dbfAlbCliT )->( dbSeek( ( dbfTikT )->CNUMDOC ) )
               nTotLin  := nTotAlbCli( ( dbfTikT )->CNUMDOC, dbfAlbCliT, dbfAlbCliL, dbfIva, dbfDiv, nil, cDivEmp(), .f. )
               nTotTot  += nTotLin
            end if

            oPrn:Write( Left( Padr( StrTran( ( dbfTikT )->CNUMDOC, " ", "" ), 7 ) , 7 )  + Space( 1 ) + ;
                        Left( ( dbfTikT )->cCliTik, 7 )                                                                       + Space( 1 ) + ;
                        Left( ( dbfTikT )->cNomTik, 15)                                                                       + Space( 1 ) + ;
                        Right( Trans( nTotLin, cPorDiv ), 8 )                                                                 + CRLF )

         end if

         ( dbfTikT )->( dbSkip() )

      end while

   end if

   oPrn:write( Replicate( "=", 40 ) + CRLF )
   oPrn:write( Padr( "Total Albaranes : ", 32 ) + Right( Trans( nTotTot, cPorDiv ), 8 ) + CRLF )
   oPrn:write( CRLF )

   end if

   /*
   Devoluciones-------------------------------------------------------
   */

   if aOpcImp[5]

   nTotTot        := 0

   oPrn:write( "D E V O L U C I O N E S" + CRLF )
   oPrn:write( Replicate( "-", 40 )  + CRLF )
   oPrn:Write( Padr( "Tik",      7 ) + Space( 1 ) + ;
               Padr( "Cod",      7 ) + Space( 1 ) + ;
               Padr( "Cliente",  15) + Space( 1 ) + ;
               Padl( "Importe",  8 ) + CRLF )
   oPrn:write( Replicate( "-", 40 )  + CRLF )

   if ( dbfTikT )->( dbSeek( cCurTur ) )

      while ( dbfTikT )->cTurTik == cCurTur .and. !( dbfTikT )->( eof() )

         if ( dbfTikT )->cTipTik == SAVDEV

            nTotLin     := nTotTik( ( dbfTikT )->CSERTIK + ( dbfTikT )->CNUMTIK + ( dbfTikT )->CSUFTIK, dbfTikT, dbfTikL, dbfDiv, nil, cDivEmp(), .f., .t. )
            nTotTot     += nTotLin

            oPrn:Write( Left( Padr( ( dbfTikT )->CSERTIK + AllTrim( ( dbfTikT )->CNUMTIK ) + ( dbfTikT )->CSUFTIK, 7 ) , 7 )  + Space( 1 ) + ;
                        Left( ( dbfTikT )->cCliTik, 7 )                                                                       + Space( 1 ) + ;
                        Left( ( dbfTikT )->cNomTik, 15)                                                                       + Space( 1 ) + ;
                        Right( Trans( nTotLin, cPorDiv ), 8 )                                                                 + CRLF )

         end if

         ( dbfTikT )->( dbSkip() )

      end while

   end if

   oPrn:write( Replicate( "=", 40 ) + CRLF )
   oPrn:write( Padr( "Total Devoluciones : ", 32 ) + Right( Trans( nTotTot, cPorDiv ), 8 ) + CRLF )
   oPrn:write( CRLF )

   end if

   /*
   Desglose de Articulos-------------------------------------------------------
   */

   if aOpcImp[6]

   nTotTot        := 0

   oPrn:write( "V E N T A    A R T I C U L O S" + CRLF )
   oPrn:write( Replicate( "-", 40 )    + CRLF )
   oPrn:Write( Padr( "Artículo",21 )   + Space( 1 ) + ;
               Padl( "Unds",     8 )   + Space( 1 ) + ;
               Padl( "Importe",  9 )   + CRLF )
   oPrn:write( Replicate( "-", 40 )    + CRLF )

   if ( dbfTikT )->( dbSeek( cCurTur ) )

      while ( dbfTikT )->cTurTik == cCurTur .and. !( dbfTikT )->( eof() )

         do case
            case ( dbfTikT )->cTipTik == SAVTIK .or. ( dbfTikT )->cTipTik == SAVDEV

               if ( dbfTikL )->( dbSeek( ( dbfTikT )->CSERTIK + ( dbfTikT )->CNUMTIK + ( dbfTikT )->CSUFTIK ) )

                  while ( dbfTikL )->CSERTIL + ( dbfTikL )->CNUMTIL + ( dbfTikL )->CSUFTIL == ( dbfTikT )->CSERTIK + ( dbfTikT )->CNUMTIK + ( dbfTikT )->CSUFTIK .and. !( dbfTikL )->( eof() )

                     if ( dbfTikL )->nCtlStk == 1

                        if ( cDbfTmp )->( dbSeek( ( dbfTikL )->CCBATIL ) )
                           ( cDbfTmp )->( dbRLock() )
                           ( cDbfTmp )->nUndArt += ( dbfTikL )->nUntTil
                           ( cDbfTmp )->nImpArt += nTotLTpv( dbfTikL, nDouDiv, nRouDiv )
                        else
                           ( cDbfTmp )->( dbAppend() )
                           ( cDbfTmp )->cCodArt := ( dbfTikL )->cCbaTil
                           ( cDbfTmp )->cNomArt := ( dbfTikL )->cNomTil
                           ( cDbfTmp )->nUndArt := ( dbfTikL )->nUntTil
                           ( cDbfTmp )->nPvpArt := nTotUTpv( dbfTikL, nDouDiv )
                           ( cDbfTmp )->nImpArt := nTotLTpv( dbfTikL, nDouDiv, nRouDiv )
                        end if

                     end if

                     ( dbfTikL )->( dbSkip() )

                  end while

               end if

            case ( dbfTikT )->cTipTik == SAVFAC

               if ( dbfFacCliL )->( dbSeek( ( dbfTikT )->cNumDoc ) )

                  while ( dbfFacCliL )->CSERIE + Str( ( dbfFacCliL )->NNUMFAC ) + ( dbfFacCliL )->CSUFFAC = ( dbfTikT )->cNumDoc  .AND. ( dbfFacCliL )->( !eof() )

                     if ( dbfFacCliL )->nCtlStk == 1

                        if ( cDbfTmp )->( dbSeek( ( dbfFacCliL )->cRef ) )
                           ( cDbfTmp )->( dbRLock() )
                           ( cDbfTmp )->nUndArt += nTotNFacCli( dbfFacCliL )
                           ( cDbfTmp )->nImpArt += nIncLFacCli( dbfFacCliL, nDouDiv, nRouDiv )
                        else
                           ( cDbfTmp )->( dbAppend() )
                           ( cDbfTmp )->cCodArt := ( dbfFacCliL )->cRef
                           ( cDbfTmp )->cNomArt := ( dbfFacCliL )->cDetalle
                           ( cDbfTmp )->nUndArt := nTotNFacCli( dbfFacCliL )
                           ( cDbfTmp )->nPvpArt := nImpUFacCli( dbfFacCliT, dbfFacCliL, nDouDiv )
                           ( cDbfTmp )->nImpArt := nIncLFacCli( dbfFacCliL, nDouDiv, nRouDiv )
                        end if

                     end if

                     ( dbfFacCliL )->( dbSkip() )

                  end while

               end if

            case ( dbfTikT )->cTipTik == SAVALB

               if ( dbfAlbCliL )->( dbSeek( ( dbfTikT )->cNumDoc ) )

                  while ( dbfAlbCliL )->cSerAlb + Str( ( dbfAlbCliL )->nNumAlb ) + ( dbfAlbCliL )->cSufAlb = ( dbfTikT )->cNumDoc  .AND. ( dbfAlbCliL )->( !eof() )

                     if ( dbfAlbCliL )->nCtlStk == 1

                        if ( cDbfTmp )->( dbSeek( ( dbfAlbCliL )->cRef ) )
                           ( cDbfTmp )->( dbRLock() )
                           ( cDbfTmp )->nUndArt += nTotNAlbCli( dbfAlbCliL )
                           ( cDbfTmp )->nImpArt += nIncLAlbCli( dbfAlbCliL, nDouDiv, nRouDiv )
                        else
                           ( cDbfTmp )->( dbAppend() )
                           ( cDbfTmp )->cCodArt := ( dbfAlbCliL )->cRef
                           ( cDbfTmp )->cNomArt := ( dbfAlbCliL )->cDetalle
                           ( cDbfTmp )->nUndArt := nTotNAlbCli( dbfAlbCliL )
                           ( cDbfTmp )->nPvpArt := nIncUAlbCli( dbfAlbCliL, nDouDiv )
                           ( cDbfTmp )->nImpArt := nIncLAlbCli( dbfAlbCliL, nDouDiv, nRouDiv )
                        end if

                     end if

                     ( dbfAlbCliL )->( dbSkip() )

                  end while

               end if

         end case

         ( dbfTikT )->( dbSkip() )

      end while

   end if

   /*
   Impresion-------------------------------------------------------------------
   */

   ( cDbfTmp )->( dbGoTop() )
   while !( cDbfTmp )->( eof() )

      msginfo( cPicUnd )

      oPrn:Write( Left( ( cDbfTmp )->cNomArt, 21 )                      + Space( 1 ) + ;
                  Right( Trans( ( cDbfTmp )->nUndArt, cPicUnd ), 8 )    + Space( 1 ) + ;
                  Right( Trans( ( cDbfTmp )->nImpArt, cPorDiv ), 9 )    + CRLF )

      nTotTot  += ( cDbfTmp )->nImpArt

      ( cDbfTmp )->( dbSkip() )

   end while

   oPrn:write( Replicate( "=", 40 ) + CRLF )
   oPrn:write( Padr( "Total artículos : ", 30 ) + Right( Trans( nTotTot, cPorDiv ), 10 ) + CRLF )
   oPrn:write( CRLF )

   end if

   /*
   Compras por albaranes-------------------------------------------------------

   if aOpcImp[4]

   nTotTot        := 0

   oPrn:write( "C O M P R A S    A L B A R A N E S" + CRLF )
   oPrn:write( Replicate( "-",  40 ) + CRLF )
   oPrn:Write( Padr( "Alb",      7 ) + Space( 1 ) + ;
               Padr( "Cod",      7 ) + Space( 1 ) + ;
               Padr( "Cliente", 15 ) + Space( 1 ) + ;
               Padl( "Importe",  8 ) + CRLF )
   oPrn:write( Replicate( "-",  40 ) + CRLF )

   if ( dbfAlbPrvT )->( dbSeek( cCurTur ) )

      while ( dbfAlbPrvT )->cTurTik == cCurTur .and. !( dbfTikT )->( eof() )

         if ( dbfTikT )->cTipTik == SAVALB
            if ( dbfAlbCliT )->( dbSeek( ( dbfTikT )->CNUMDOC ) )
               nTotLin  := nTotAlbCli( ( dbfTikT )->CNUMDOC, dbfAlbCliT, dbfAlbCliL, dbfIva, dbfDiv, nil, cDivEmp(), .f. )
               nTotTot  += nTotLin
            end if

            oPrn:Write( Left( Padr( StrTran( ( dbfTikT )->CNUMDOC, " ", "" ), 7 ) , 7 )  + Space( 1 ) + ;
                        Left( ( dbfTikT )->cCliTik, 7 )                                                                       + Space( 1 ) + ;
                        Left( ( dbfTikT )->cNomTik, 15)                                                                       + Space( 1 ) + ;
                        Right( Trans( nTotLin, cPorDiv ), 8 )                                                                 + CRLF )

         end if

         ( dbfTikT )->( dbSkip() )

      end while

   end if

   oPrn:write( Replicate( "=", 40 ) + CRLF )
   oPrn:write( Padr( "Total Albaranes : ", 32 ) + Right( Trans( nTotTot, cPorDiv ), 8 ) + CRLF )
   oPrn:write( CRLF )

   end if
   */

   /*
	Familias__________________________________________________________________

   if aOpcImp[7]

   if Len( aTipFam ) >= 1

		oPrn:write( retChr( aIniApp()[CIMPCENTPV] ) )					// +Centrado
		oPrn:write( "FAMILIAS DE ARTICULOS" + CRLF )
		oPrn:write( "---------------------" + CRLF )
		oPrn:write( retChr( aIniApp()[CIMPNCETPV] ) )					// -Centrado

      oPrn:write( Padr( "Familia", 28 ) + Space( 1 ) + Padl( "Importe", 11 ) + CRLF )
      oPrn:write( replicate( "-", 40 ) + CRLF )

		FOR n := 1 TO len( aTipFam )

			oPrn:write( aTipFam[ n, 1 ] + " - " + ;
							padr( retFamilia( aTipFam[ n, 1 ], dbfFam ), 19 ) + ;
							Trans( aTipFam[ n, 2 ], "@E 999,999,999" ) + CRLF )

		NEXT n

		oPrn:write( 	replicate( "-", 38 ) + CRLF )

	END IF

   end if

   */

   /*
	Formas de Pago_____________________________________________________________

	IF Len( aTipPag ) >= 1

		oPrn:write( retChr( aIniApp()[CIMPCENTPV] ) )					// +Centrado
		oPrn:write( "FORMAS DE PAGO" + CRLF )
		oPrn:write( "--------------" + CRLF )
		oPrn:write( retChr( aIniApp()[CIMPNCETPV] ) )					// -Centrado

		oPrn:write( Padr( "Tipo", 23 ) + Padl( "Importe", 15 ) + CRLF )
		oPrn:write( replicate( "-", 38 ) + CRLF )

		FOR n := 1 TO len( aTipPag )

			oPrn:write( Padr( aTipPag[ n, 1 ] + " - " + retFPago( aTipPag[ n, 1 ] ), 24 ) + ;
                     Trans( aTipPag[ n, 2 ], "@E 99,999,999,999" ) + CRLF )

		NEXT n

		oPrn:write( replicate( "-", 38 ) + CRLF )
		oPrn:write( CRLF )

	END IF
   */

	/*
   Tipos de impuestos____________________________________________________________

	IF Len( aTipIva ) >= 1

		oPrn:write( retChr( aIniApp()[CIMPCENTPV] ) )					// +Centrado
      oPrn:write( "TIPOS DE " + cImp() + CRLF )
		oPrn:write( "---------------" + CRLF )
		oPrn:write( retChr( aIniApp()[CIMPNCETPV] ) )					// -Centrado

      oPrn:write( Padl( "Tipo", 5 ) + Padl( "Base", 11 ) + Padl( cImp(), 11 ) + Padl( "Importe", 11 ) + CRLF )
		oPrn:write( replicate( "-", 38 ) + CRLF )

		FOR n := 1 TO len( aTipIva )

			oPrn:write( Trans( aTipIva[ n, 1 ], "@E 99.9%" ) + ;
							Trans( aTipIva[ n, 2 ], "@E 999,999,999" ) + ;
							Trans( aTipIva[ n, 3 ], "@E 999,999,999" ) + ;
							Trans( aTipIva[ n, 4 ], "@E 999,999,999" ) + CRLF )

			nTotBas	+= aTipIva[ n, 2 ]
			nTotIva	+= aTipIva[ n, 3 ]
			nTotImp	+= aTipIva[ n, 4 ]

		NEXT n

		oPrn:write( 	replicate( "-", 38 ) + CRLF )
		oPrn:write( 	Space( 5 ) + ;
							Trans( nTotBas, "@E 999,999,999" ) + ;
							Trans( nTotIva, "@E 999,999,999" ) + ;
							Trans( nTotImp, "@E 999,999,999" ) + CRLF )

		oPrn:write( CRLF )

	END IF
   */


	/*
	Eject______________________________________________________________________
	*/

   if !lPrev
      oPrn:write( retChr( oPrnTik:cSalto ) )                   // Salto
      oPrn:write( retChr( oPrnTik:cCorte ) )                   // Corte
   end if

	oPrn:End()

	/*
	Apertura de Cajón-----------------------------------------------------------
	*/

   oUser():OpenCajonDirect( nView ) //OpnCaj()

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos de agentes" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE ( cDbfTmp )

   /*
   Eliminamos los ficheros
   */

   if file( cPatTmp() + "ARTTMP.DBF" )
      ferase( cPatTmp() + "ARTTMP.DBF" )
   end if

   if file( cPatTmp() + "ARTTMP.CDX" )
      ferase( cPatTmp() + "ARTTMP.CDX" )
   end if

   /*
   Visualizamos el ticket
   */

   if lPrev
      VisTik( cPort )
   end if

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION EdtCol( dbfTmp, oLbx )

   local uVar     := ( dbfTmp )->NCANACT
   local cPic     := "@E 999,999.99"
	local bValid	:= { || .T. }

	IF oLbx:lEditCol( 4, @uVar, cPic, bValid )

         IF uVar > 0 .AND. dbDialogLock( dbfTmp )

            ( dbfTmp )->NCANACT := uVar
            ( dbfTmp )->( dbUnlock() )

			END IF

         oLbx:Refresh() //DrawSelect()

	 END IF

RETURN NIL

//--------------------------------------------------------------------------//
/*
Cierra el turno
*/

STATIC FUNCTION lCloseTurno( cLasTur )

   if Empty( cLasTur )
      MsgStop( "No hay turnos abiertos" )
      return .f.
   end if

   /*
   Cerrar por turnos__________________________________________________________________
   */

   if !ApoloMsgNoYes(  "¿Desea realmente a proceder a cerrar el turno en curso?"   + CRLF + ;
                  "El proceso de cierre no podra ser invertido,"              + CRLF + ;
                  "sin autorización expresa.",                                         ;
                  "Cierre de turno : " + Trans( cLasTur, "######" ) )
      return .f.
   end if

   CursorWait()

   if ( dbfTikT )->( dbSeek( cLasTur ) )

      WHILE ( dbfTikT )->cTurTik == cLasTur .and. !( dbfTikT )->( eof() )

         IF !( dbfTikT )->LCLOTIK

            /*
            Cerramos el Ticket_________________________________________________
            */

            dbDialogLock( dbfTikT )
            ( dbfTikT )->LCLOTIK := .t.
            ( dbfTikT )->( dbRUnLock() )

         END IF

         ( dbfTikT )->( dbSkip() )

		END DO

   end if

   /*
   Entradas y salidas de cajas por turnos___________________________________
   */

   if ( dbfEntT )->( dbSeek( cLasTur ) )

      WHILE ( dbfEntT )->cTurEnt == cLasTur .and. !( dbfEntT )->( eof() )

         IF !( dbfEntT )->LCLOENT

            /*
            Entrada ya utilizada____________________________________________
            */

            dbDialogLock( dbfEntT )
            ( dbfEntT )->LCLOENT := .t.
            ( dbfEntT )->( dbUnLock() )

         END IF

         ( dbfEntT )->( dbSkip() )

      END DO

   end if

   /*
   Cerrar los pagos __________________________________________________________________
   */

   if ( dbfTikP )->( dbSeek( cLasTur ) )

      WHILE ( dbfTikP )->cTurPgo == cLasTur .AND. !( dbfTikP )->( eof() )

         IF !( dbfTikP )->lCloPgo

            dbDialogLock( dbfTikP )
            ( dbfTikP )->lCloPgo := .t.
            ( dbfTikP )->( dbUnLock() )

            /*
            Estudios de las distintas formas de Pago
            */

         END IF

         ( dbfTikP )->( dbSkip() )

      END DO

   end if

   /*
   Metemos los nuevos valores en el articulo---------------------------------
   */

   ( dbfTmp )->( dbGoTop() )
   while !( dbfTmp )->( eof() )

      if ( dbfArt )->( dbSeek( ( dbfTmp )->CCODART ) ) .and. dbDialogLock( dbfArt )

         ( dbfArt )->nCntAct  := ( dbfTmp )->nCanAct
         ( dbfArt )->( dbUnlock() )

      end if

      ( dbfTmp )->( dbSkip() )

   end while

   /*
   Cerrar el turno-------------------------------------------------------------
   */

   if oTurno:lCloseTurno( cLasTur, dFecTur, cHorTur, cCajTur, dbfTmp )
      MsgInfo( "Sesión cerrado satisfactoriamente.", "Cierre de turno : " + Trans( cLasTur, "######" ) )
   end if

   CursorWe()

RETURN .t.

//------------------------------------------------------------------------//
/*
Devuelve el total de las vetnas por contadores
*/

static function nTotTikCnt()

   local nRecno   := ( dbfTmp )->( Recno() )

   nTotCnt        := 0

   ( dbfTmp )->( dbGoTop() )
   while !( dbfTmp )->( eof() )

      nTotCnt   += ( dbfTmp )->NPVPART * ( ( dbfTmp )->NCANACT - ( dbfTmp )->NCANANT )
      ( dbfTmp )->( dbSkip() )

   end do

   ( dbfTmp )->( dbGoto( nRecno ) )

return ( nTotCnt )

//------------------------------------------------------------------------//
/*
Invierte el proceso de cierre
*/

STATIC FUNCTION OpenTurno( cCurTur, dFecha )

   DEFAULT dFecha    := date()

   if !ApoloMsgNoYes(  "¿Desea realmente a proceder a invertir el cierre?."        + CRLF + ;
                                                                              + CRLF + ;
                  "El proceso de cierre no podra ser invertido,"              + CRLF + ;
                  "sin autorización expresa.",                                         ;
                  "Invertir cierre de turno." + Trans( cCurTur, "######" ) )
      return .f.
   end if

   /*
   Cerrar por turnos__________________________________________________________________
   */

   ( dbfTikT )->( dbGoTop() )

   WHILE !( dbfTikT )->( eof() )

      IF ( dbfTikT )->CTURTIK == cCurTur

         /*
         Ticket abierto
         */

         dbDialogLock( dbfTikT )
         ( dbfTikT )->LCLOTIK := .f.
         ( dbfTikT )->CTURTIK := Space( 6 )

      END IF

      ( dbfTikT )->( dbSkip() )

   END DO

   /*
   Entradas y salidas de cajas por turnos___________________________________
   */

   ( dbfEntT )->( dbGoTop() )

   WHILE !( dbfEntT )->( eof() )

      IF ( dbfTikT )->CTURTIK == cCurTur

         /*
         Ticket abierto
         */

         dbDialogLock( dbfTikT )
         ( dbfTikT )->LCLOTIK := .f.
         ( dbfTikT )->CTURTIK := Space( 6 )

      END IF

      IF !( dbfEntT )->LCLOENT

         /*
         Entrada ya utilizada____________________________________________
         */

         dbDialogLock( dbfEntT )
         ( dbfEntT )->LCLOENT := .t.
         ( dbfEntT )->CTURTIK := cCurTur

      END IF

      ( dbfEntT )->( dbSkip() )

   END DO

RETURN .t.

//------------------------------------------------------------------------//