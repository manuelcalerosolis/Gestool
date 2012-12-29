#include "FiveWin.Ch"
#include "MesDbf.ch"
#include "Factu.Ch"
#include "Report.ch"

//---------------------------------------------------------------------------//

CLASS TRemesas FROM TMasDet

   DATA  oCtaRem
   DATA  oDivisas
   DATA  oDbfCnt
   DATA  oRecibos
   DATA  oClientes
   DATA  oFacCliT
   DATA  oFacCliL
   DATA  oAntCliT
   DATA  oIva
   DATA  oBandera
   DATA  cPorDiv
   DATA  dCarCta
   DATA  cPatExp
   DATA  dFecIni
   DATA  dFecFin
   DATA  oMeter            AS OBJECT
   DATA  nMeter            AS NUMERIC  INIT  0
   DATA  bmpConta
   DATA  aMsg              AS ARRAY    INIT  {}
   DATA  lAgruparRecibos               INIT  .f.
   DATA  cMru                          INIT "Briefcase_document_16"
   DATA  cBitmap                       INIT "WebTopRed"
   DATA  oMenu
   DATA  oCodRem

   METHOD New( cPath, oWndParent, oMenuItem )

   METHOD OpenFiles( lExclusive )
   METHOD CloseFiles()

   METHOD DefineFiles()
   METHOD DefineDetails( cPath, lUniqueName, cFileName )

   METHOD OpenService( lExclusive )
   METHOD CloseService()

   METHOD Resource( nMode )
   METHOD Activate()
   METHOD lSave()

   METHOD GetRecCli( oGet, oSay, oDlg, oBrw )
   METHOD SetRecCli()

   /*
   Metodos redefinidos---------------------------------------------------------
   */

   METHOD AppendDet()
   METHOD RollBack()
   METHOD SaveDet()        VIRTUAL

   METHOD Del()
   METHOD DelItem()

   METHOD nTotRem( lPic )
   METHOD nTotRemVir( lPic )

   METHOD cNumRem()        INLINE   ::oDbf:cNumRem

   /*
   Metodos para el modelo 19---------------------------------------------------
   */

   METHOD SaveMod19()
   METHOD InitMod19()
   Method nAllRecCli()

   METHOD Report()

   METHOD Conta()
   Method ChangeConta( lConta )
   Method lContabilizaRecibos( lConta )

   METHOD cRetCtaRem()

   METHOD cBmp()

   METHOD cRetTipRem() INLINE ( if( ::oDbf:nTipRem == 2, "Descuento", "Pago" ) )

   METHOD GetNewCount()

   METHOD lNowExist()

   METHOD SaveDetails()

   METHOD EdtRecMenu( oDlg )

   METHOD EndEdtRecMenu()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( cPath, oMenuItem, oWndParent )

   DEFAULT cPath        := cPatEmp()
   DEFAULT oWndParent   := GetWndFrame()
   DEFAULT oMenuItem    := "01060"

   ::nLevel             := nLevelUsr( oMenuItem )

   ::cPath              := cPath
   ::oWndParent         := oWndParent
   ::oDbf               := nil
   ::oDbfDet            := nil
   ::oDivisas           := nil
   ::oDbfCnt            := nil
   ::oBandera           := nil

   ::dFecIni            := Ctod( "01/" + Str( Month( Date() ), 2 ) + "/" + Str( Year( Date() ), 4 ) )
   ::dFecFin            := Date()

   ::cNumDocKey         := "nNumRem"
   ::cSufDocKey         := "cSufRem"

   ::lMoveDlgSelect     := .t.

   ::bmpConta           := LoadBitmap( GetResources(), "BCONTA" )

   ::dCarCta            := Date()
   ::cPatExp            := PadR( "C:\RECIBOS.TXT", 100 )

   ::bFirstKey          := {|| Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem }
   ::bWhile             := {|| Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem == Str( ::oDbfVir:nNumRem, 9 ) + ::oDbfVir:cSufRem .and. !::oDbfVir:Eof() }

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD DefineFiles( cPath )

   DEFAULT cPath        := ::cPath

   DEFINE DATABASE ::oDbf FILE "REMCLIT.DBF" CLASS "REMCLI" ALIAS "REMCLI" PATH ( cPath ) VIA ( cDriver() ) COMMENT "Remesas bancarias"

      FIELD NAME "lConta"              TYPE "L" LEN  1  DEC 0                             DEFAULT  .f.                                                                                 HIDE          OF ::oDbf
      FIELD CALCULATE NAME "bmpConta"           LEN  1  DEC 0                             VAL {|| ::oDbf:lConta } BITMAPS "Sel16", "Nil16"   COMMENT { "Contabilizado", "bmpConta16", 3 } COLSIZE 20 OF ::oDbf
      FIELD NAME "nNumRem"             TYPE "N" LEN  9  DEC 0 PICTURE "999999999"                                                            COMMENT ""                                HIDE          OF ::oDbf
      FIELD NAME "cSufRem"             TYPE "C" LEN  2  DEC 0 PICTURE "@!"                DEFAULT  RetSufEmp()                               COMMENT ""                                HIDE          OF ::oDbf
      FIELD CALCULATE NAME "cNumRem"            LEN 12  DEC 0                             VAL      ( Str( ::oDbf:nNumRem, 9 ) + "/" + ::oDbf:cSufRem ) COMMENT "Número" COLSIZE  80          OF ::oDbf
      FIELD NAME "cCodRem"             TYPE "C" LEN  3  DEC 0 PICTURE "@!"                                                                   COMMENT "Cuenta" COLSIZE  80                    OF ::oDbf
      FIELD CALCULATE NAME "cNomRem"            LEN 60  DEC 0                             VAL      ::cRetCtaRem()                            COMMENT "Nombre" COLSIZE 200                    OF ::oDbf
      FIELD NAME "dFecRem"             TYPE "D" LEN  8  DEC 0                             DEFAULT  Date()                                    COMMENT "Fecha"  COLSIZE  80                    OF ::oDbf
      FIELD NAME "nTipRem"             TYPE "N" LEN  1  DEC 0 PICTURE "9"                 DEFAULT  1                                         COMMENT ""                                HIDE  OF ::oDbf
      FIELD CALCULATE NAME "cTipRem"            LEN 60  DEC 0                             VAL      ::cRetTipRem()                            COMMENT "Tipo"   COLSIZE  80                    OF ::oDbf
      FIELD NAME "cCodDiv"             TYPE "C" LEN  3  DEC 0 PICTURE "@!"                DEFAULT  cDivEmp()                                 COMMENT ""                                HIDE  OF ::oDbf
      FIELD NAME "nVdvDiv"             TYPE "N" LEN 16  DEC 6 PICTURE "@E 999,999.9999"   DEFAULT  1                                         COMMENT ""                                HIDE  OF ::oDbf
      FIELD CALCULATE NAME "nTotRem"            LEN 16  DEC 6                             VAL      ::nTotRem(.t.)                            COMMENT "Total"  COLSIZE 100  ALIGN RIGHT       OF ::oDbf
      FIELD CALCULATE NAME "cBmpDiv"            LEN 20  DEC 0                             VAL      ::cBmp()                                  COMMENT "Div."   COLSIZE  25                    OF ::oDbf
      FIELD NAME "dConta"              TYPE "D" LEN  8  DEC 0                                                                                COMMENT "Contab."                               OF ::oDbf

      INDEX TO "RemCliT.Cdx" TAG "cNumRem" ON "Str( nNumRem ) + cSufRem" COMMENT "Número" NODELETED OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//---------------------------------------------------------------------------//

METHOD DefineDetails( cPath, lUniqueName, cFileName, cVia )

   local oDbf

   DEFAULT cPath        := ::cPath
   DEFAULT lUniqueName  := .f.
   DEFAULT cFileName    := "FacCliP"
   DEFAULT cVia         := cDriver()

   if lUniqueName
      cFileName         := cGetNewFileName( cFileName, , , cPatTmp() )
   end if

   DEFINE TABLE oDbf FILE ( cFileName ) CLASS ( cFileName ) ALIAS ( cFileName ) PATH ( cPath ) VIA ( cVia )

      FIELD NAME "cSerie"    TYPE "C" LEN   1 DEC 0 OF oDbf
      FIELD NAME "nNumFac"   TYPE "N" LEN   9 DEC 0 OF oDbf
      FIELD NAME "cSufFac"   TYPE "C" LEN   2 DEC 0 OF oDbf
      FIELD NAME "nNumRec"   TYPE "N" LEN   2 DEC 0 OF oDbf
      FIELD NAME "cTipRec"   TYPE "C" LEN   1 DEC 0 OF oDbf
      FIELD NAME "cCodPgo"   TYPE "C" LEN   2 DEC 0 OF oDbf
      FIELD NAME "cCodCaj"   TYPE "C" LEN   3 DEC 0 OF oDbf
      FIELD NAME "cTurRec"   TYPE "C" LEN   6 DEC 0 OF oDbf
      FIELD NAME "cCodCli"   TYPE "C" LEN  12 DEC 0 OF oDbf
      FIELD NAME "cNomCli"   TYPE "C" LEN  80 DEC 0 OF oDbf
      FIELD NAME "dEntrada"  TYPE "D" LEN   8 DEC 0 OF oDbf
      FIELD NAME "nImporte"  TYPE "N" LEN  16 DEC 6 OF oDbf
      FIELD NAME "cDesCriP"  TYPE "C" LEN 100 DEC 0 OF oDbf
      FIELD NAME "dPreCob"   TYPE "D" LEN   8 DEC 0 OF oDbf
      FIELD NAME "cPgdoPor"  TYPE "C" LEN  50 DEC 0 OF oDbf
      FIELD NAME "cDocPgo"   TYPE "C" LEN  50 DEC 0 OF oDbf
      FIELD NAME "lCobrado"  TYPE "L" LEN   1 DEC 0 OF oDbf
      FIELD NAME "cDivPgo"   TYPE "C" LEN   3 DEC 0 OF oDbf
      FIELD NAME "nVdvPgo"   TYPE "N" LEN  10 DEC 6 OF oDbf
      FIELD NAME "lConPgo"   TYPE "L" LEN   1 DEC 0 OF oDbf
      FIELD NAME "cCtaRec"   TYPE "C" LEN  12 DEC 0 OF oDbf
      FIELD NAME "nImpEur"   TYPE "N" LEN  16 DEC 6 OF oDbf
      FIELD NAME "lImpEur"   TYPE "L" LEN   1 DEC 0 OF oDbf
      FIELD NAME "nNumRem"   TYPE "N" LEN   9 DEC 0 OF oDbf
      FIELD NAME "cSufRem"   TYPE "C" LEN   2 DEC 0 OF oDbf
      FIELD NAME "cCtaRem"   TYPE "C" LEN   3 DEC 0 OF oDbf
      FIELD NAME "lRecImp"   TYPE "L" LEN   1 DEC 0 OF oDbf
      FIELD NAME "lRecDto"   TYPE "L" LEN   1 DEC 0 OF oDbf
      FIELD NAME "dFecDto"   TYPE "D" LEN   8 DEC 0 OF oDbf
      FIELD NAME "dFecVto"   TYPE "D" LEN   8 DEC 0 OF oDbf
      FIELD NAME "cCodAge"   TYPE "C" LEN   3 DEC 0 OF oDbf
      FIELD NAME "nNumCob"   TYPE "N" LEN   9 DEC 0 OF oDbf
      FIELD NAME "cSufCob"   TYPE "C" LEN   2 DEC 0 OF oDbf
      FIELD NAME "nImpCob"   TYPE "N" LEN  16 DEC 6 OF oDbf
      FIELD NAME "nImpGas"   TYPE "N" LEN  16 DEC 6 OF oDbf
      FIELD NAME "cCtaGas"   TYPE "C" LEN  12 DEC 0 OF oDbf
      FIELD NAME "lEsperaDoc" TYPE "L" LEN  1 DEC 0 OF oDbf
      FIELD NAME "lCloPgo"   TYPE "L" LEN   1 DEC 0 OF oDbf
      FIELD NAME "dFecImp"   TYPE "D" LEN   8 DEC 0 OF oDbf
      FIELD NAME "cHorImp"   TYPE "C" LEN   5 DEC 0 OF oDbf
      FIELD NAME "lNotArqueo" TYPE "L" LEN  1 DEC 0 OF oDbf
      FIELD NAME "cCodBnc"   TYPE "C" LEN   4 DEC 0 OF oDbf
      FIELD NAME "dFecCre"   TYPE "D" LEN   8 DEC 0 OF oDbf
      FIELD NAME "cHorCre"   TYPE "C" LEN   5 DEC 0 OF oDbf
      FIELD NAME "cCodUsr"   TYPE "C" LEN   3 DEC 0 OF oDbf
      FIELD NAME "lDevuelto" TYPE "L" LEN   1 DEC 0 OF oDbf
      FIELD NAME "dFecDev"   TYPE "D" LEN   8 DEC 0 OF oDbf
      FIELD NAME "cMotDev"   TYPE "C" LEN 250 DEC 0 OF oDbf
      FIELD NAME "cRecDev"   TYPE "C" LEN  14 DEC 0 OF oDbf

      INDEX TO ( cFileName ) TAG "nNumFac"   ON "cSerie + Str( nNumFac ) + cSufFac + Str( nNumRec )"              NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "cCodCli"   ON "cCodCli"                                                         NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "cNomCli"   ON "cNomCli"                                                         NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "dPreCob"   ON "dPreCob"                                                         NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "fNumFac"   ON "cSerie + Str( nNumFac ) + cSufFac + Str( nNumRec ) + cTipRec"    NODELETED FOR "!lCobrado" OF oDbf
      INDEX TO ( cFileName ) TAG "lNumFac"   ON "cSerie + Str( nNumFac ) + cSufFac + Str( nNumRec ) + cTipRec"    NODELETED FOR "lCobrado"  OF oDbf
      INDEX TO ( cFileName ) TAG "dFecVto"   ON "dFecVto"                                                         NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "dEntrada"  ON "dEntrada"                                                        NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "nImporte"  ON "nImporte"                                                        NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "nNumRem"   ON "Str( nNumRem ) + cSufRem"                                        NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "cCtaRem"   ON "cCtaRem"                                                         NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "cCodAge"   ON "cCodAge"                                                         NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "nNumCob"   ON "Str( nNumCob ) + cSufCob"                                        NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "cTurRec"   ON "cTurRec + cSufFac + cCodCaj"                                     NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "rNumFac"   ON "cSerie + Str( nNumFac ) + cSufFac + Str( nNumRec ) + cTipRec"    NODELETED FOR "!Empty( cTipRec )"  OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//---------------------------------------------------------------------------//

METHOD Activate()

   local oRotor

   if nAnd( ::nLevel, 1 ) == 0

      /*
      Cerramos todas las ventanas
      */

      if ::oWndParent != nil
         ::oWndParent:CloseAll()
      end if

      if !::OpenFiles()
         return nil
      end if

      ::CreateShell( ::nLevel )

      DEFINE BTNSHELL RESOURCE "BUS" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::oWndBrw:SearchSetFocus() ) ;
         TOOLTIP  "(B)uscar" ;
         HOTKEY   "B";

         ::oWndBrw:AddSeaBar()

      DEFINE BTNSHELL RESOURCE "NEW" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::oWndBrw:RecAdd() );
         ON DROP  ( ::oWndBrw:RecAdd() );
         TOOLTIP  "(A)ñadir";
         BEGIN GROUP ;
         HOTKEY   "A" ;
         LEVEL    ACC_APPD

      DEFINE BTNSHELL RESOURCE "EDIT" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::oWndBrw:RecEdit() );
         TOOLTIP  "(M)odificar";
         HOTKEY   "M" ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "ZOOM" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::oWndBrw:RecZoom() );
         TOOLTIP  "(Z)oom";
         HOTKEY   "Z" ;
         LEVEL    ACC_ZOOM

     DEFINE BTNSHELL RESOURCE "DEL" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::oWndBrw:RecDel() );
         TOOLTIP  "(E)liminar";
         MRU ;
         HOTKEY   "E";
         LEVEL    ACC_DELE

      DEFINE BTNSHELL RESOURCE "IMP" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::Report() ) ;
         TOOLTIP  "(L)istado" ;
         HOTKEY   "L" ;
         LEVEL    ACC_IMPR

      DEFINE BTNSHELL RESOURCE "BMPEXPTAR" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::SaveMod19() ) ;
         TOOLTIP  "E(x)portar" ;
         HOTKEY   "X";
         LEVEL    4

      DEFINE BTNSHELL RESOURCE "BMPCONTA" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::SelectRec( {|| ::Conta( ::lChkSelect ) }, "Contabilizar remesas", "Simular" , .f. ) ) ;
         TOOLTIP  "(C)ontabilizar" ;
         HOTKEY   "C";
         LEVEL    4

      DEFINE BTNSHELL RESOURCE "CHGSTATE" OF ::oWndBrw ;
			NOBORDER ;
         ACTION   ( ::SelectRec( {|| ::ChangeConta( ::lChkSelect ) }, "Cambiar estado", "Contabilizado" , .f. ) ) ;
         TOOLTIP  "Cambiar es(t)ado" ;
         HOTKEY   "T";
         LEVEL    4

      DEFINE BTNSHELL oRotor RESOURCE "ROTOR" GROUP OF ::oWndBrw ;
         ACTION   ( oRotor:Expand() ) ;
         TOOLTIP  "Rotor" ;

         DEFINE BTNSHELL RESOURCE "ADDRESS_BOOK2_" OF ::oWndBrw ;
            ACTION   ( if( !Empty( ::oDbf:cCodRem ), ::oCtaRem:Edit(), MsgStop( "Cuenta vacía" ) ) );
            TOOLTIP  "Modificar cuenta" ;
            FROM     oRotor ;

      ::oWndBrw:EndButtons( Self )

      ::oWndBrw:Activate(  nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,;
                           nil, nil, nil, nil, {|| ::CloseFiles() }, nil, nil )
   else

      msgStop( "Acceso no permitido." )

   end if

RETURN NIL

//----------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive )

   local lOpen    := .t.
   local oBlock

   DEFAULT lExclusive   := .f.

   oBlock         := ErrorBlock( { | oError | Break( oError ) } )
   BEGIN SEQUENCE

   if Empty( ::oDbf )
      ::DefineFiles()
   end if

   ::oDbf:Activate( .f., !( lExclusive ) )

   DATABASE NEW ::oDbfDet  FILE "FACCLIP.DBF" PATH ( ::cPath ) VIA ( cDriver() )SHARED INDEX "FACCLIP.CDX"
   ::oDbfDet:OrdSetFocus( "nNumRem" )

   DATABASE NEW ::oFacCliT FILE "FACCLIT.DBF" PATH ( ::cPath )    VIA ( cDriver() ) SHARED INDEX "FACCLIT.CDX"

   DATABASE NEW ::oFacCliL FILE "FACCLIL.DBF" PATH ( ::cPath )    VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oAntCliT FILE "AntCliT.DBF" PATH ( ::cPath )    VIA ( cDriver() ) SHARED INDEX "AntCliT.CDX"

   DATABASE NEW ::oClientes FILE "CLIENT.DBF" PATH ( cPatCli() )  VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

   DATABASE NEW ::oIva     FILE "TIVA.DBF"    PATH ( cPatDat() )  VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   DATABASE NEW ::oDivisas FILE "DIVISAS.DBF" PATH ( cPatDat() )  VIA ( cDriver() ) SHARED INDEX "DIVISAS.CDX"

   DATABASE NEW ::oDbfCnt  FILE "nCount.Dbf"  PATH ( cPatEmp() )  VIA ( cDriver() ) SHARED INDEX "nCount.Cdx"

   ::cPorDiv  := cPorDiv( cDivEmp(), ::oDivisas:cAlias ) // Picture de la divisa redondeada

   ::oBandera := TBandera():New()

   ::oCtaRem  := TCtaRem():Create( cPatCli() )
   ::oCtaRem:OpenFiles()

   RECOVER

         msgStop( "Imposible abrir todas las bases de datos de remes as de clientes" )
         ::CloseFiles()
         lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD OpenService( lExclusive )

   local lOpen          := .t.
   local oBlock         := ErrorBlock( { | oError | Break( oError ) } )

   DEFAULT lExclusive   := .f.

   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::DefineFiles()
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos de remesas de clientes" )
      ::CloseService()
      lOpen             := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:End()
   end if

   if ::oDbfDet != nil .and. ::oDbfDet:Used()
      ::oDbfDet:End()
   end if

   if ::oDivisas != nil .and. ::oDivisas:Used()
      ::oDivisas:End()
   end if

   if ::oDbfCnt != nil .and. ::oDbfCnt:Used()
      ::oDbfCnt:End()
   end if

   if ::oClientes != nil .and. ::oClientes:Used()
      ::oClientes:End()
   end if

   if ::oFacCliT != nil .and. ::oFacCliT:Used()
      ::oFacCliT:End()
   end if

   if ::oFacCliL != nil .and. ::oFacCliL:Used()
      ::oFacCliL:End()
   end if

   if ::oAntCliT != nil .and. ::oAntCliT:Used()
      ::oAntCliT:End()
   end if

   if ::oIva != nil .and. ::oIva:Used()
      ::oIva:End()
   end if

   if ::oCtaRem != nil
      ::oCtaRem:End()
   end if

   ::oDbf         := nil
   ::oDbfDet      := nil
   ::oDivisas     := nil
   ::oDbfCnt      := nil
   ::oClientes    := nil
   ::oDbfDet      := nil
   ::oCtaRem      := nil

   if ::bmpConta != nil
      DeleteObject( ::bmpConta )
   end if

   ::bmpConta     := nil

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD CloseService()

   if !Empty( ::oDbf )
      ::oDbf:End()
   end if

   ::oDbf   := nil

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD Resource( nMode )

   local oDlg
   local oGet     := Array( 3 )
   local oSay
   local cSay     := ::oCtaRem:cRetCtaRem( ::oDbf:cCodRem )
   local oBmpDiv
   local oBtnImportar

   DEFINE DIALOG oDlg RESOURCE "RemCli" TITLE LblTitle( nMode ) + "remesas de recibos a clientes"

      REDEFINE GET ::oDbf:nNumRem ;
			ID 		100 ;
         WHEN     ( .f. ) ;
         PICTURE  ::oDbf:FieldByName( "nNumRem" ):cPict ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cSufRem ;
			ID 		110 ;
         WHEN     ( .f. ) ;
         PICTURE  ::oDbf:FieldByName( "cSufRem" ):cPict ;
         OF       oDlg

      REDEFINE GET ::oDbf:dFecRem ;
         ID       120 ;
         SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET ::dFecIni UPDATE ;
         ID       121 ;
         SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET ::dFecFin UPDATE ;
         ID       122 ;
         SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET ::oCodRem VAR ::oDbf:cCodRem UPDATE ;
         ID       130 ;
         PICTURE  ::oDbf:FieldByName( "cCodRem" ):cPict ;
         BITMAP   "LUPA" ;
			OF 		oDlg

      ::oCodRem:bValid := {|| ::oCtaRem:lGetCtaRem( ::oCodRem, oSay ) }
      ::oCodRem:bWhen  := {|| nMode != ZOOM_MODE }
      ::oCodRem:bHelp  := {|| ::oCtaRem:Buscar( ::oCodRem ) }

      REDEFINE GET oSay VAR cSay UPDATE ;
         ID       131 ;
         WHEN     ( .f. ) ;
			OF 		oDlg

      REDEFINE GET oGet[2] VAR ::oDbf:cCodDiv UPDATE ;
         WHEN     ( nMode == APPD_MODE .or. ::oDbf:LastRec() == 0 ) ;
         PICTURE  "@!";
         ID       140 ;
         BITMAP   "LUPA" ;
         OF       oDlg

         oGet[2]:bValid := {|| cDivOut( oGet[2], oBmpDiv, oGet[3], nil, nil, nil, nil, nil, nil, nil, ::oDivisas:cAlias, ::oBandera ) }
         oGet[2]:bHelp  := {|| BrwDiv( oGet[2], oBmpDiv, oGet[3], ::oDivisas:cAlias, ::oBandera ) }

		REDEFINE BITMAP oBmpDiv ;
         RESOURCE "BAN_EURO" ;
         ID       141;
         OF       oDlg

      REDEFINE GET oGet[3] VAR ::oDbf:nVdvDiv ;
			WHEN		( .F. ) ;
         ID       142 ;
         VALID    ( ::oDbf:nVdvDiv > 0 ) ;
			PICTURE	"@E 999,999.9999" ;
         OF       oDlg

      REDEFINE RADIO ::oDbf:nTipRem ;
         ID       160, 161 ;
         WHEN     ( nMode == APPD_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oDbf:dConta ;
         ID       170 ;
         SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

       /*
       Botones de acceso________________________________________________________________
       */

		REDEFINE BUTTON ;
			ID 		500 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::AppendDet() )

		REDEFINE BUTTON ;
			ID 		502 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::DeleteDet() )

      REDEFINE BUTTON oBtnImportar;
         ID       503 ;
         OF       oDlg ;
         WHEN     ( nMode == APPD_MODE ) ;
         ACTION   ( ::GetRecCli( ::oDbf:cCodRem, oDlg, oBtnImportar, nMode ) )

      ::oBrwDet                 := IXBrowse():New( oDlg )

      ::oBrwDet:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrwDet:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oBrwDet:nMarqueeStyle   := 6
      ::oBrwDet:cName           := "Remesas.Lineas"

      ::oBrwDet:SetoDbf( ::oDbfVir )

      with object ( ::oBrwDet:AddCol() )
         :cHeader          := "Número"
         :bEditValue       := {|| ::oDbfVir:cSerie + "/" + Str( ::oDbfVir:nNumFac ) + "/" + ::oDbfVir:cSufFac + "-" + Str( ::oDbfVir:nNumRec ) }
         :nWidth           := 95
      end with

      with object ( ::oBrwDet:AddCol() )
         :cHeader          := "Fecha"
         :bStrData         := {|| DtoC( ::oDbfVir:dPreCob ) }
         :nWidth           := 80
      end with

      with object ( ::oBrwDet:AddCol() )
         :cHeader          := "Vencimiento"
         :bStrData         := {|| DtoC( ::oDbfVir:dFecVto ) }
         :nWidth           := 80
      end with

      with object ( ::oBrwDet:AddCol() )
         :cHeader          := "Cliente"
         :bStrData         := {|| Rtrim( ::oDbfVir:cCodCli ) + Space( 1 ) + Rtrim( ::oDbfVir:cNomCli ) }
         :nWidth           := 146
      end with

      with object ( ::oBrwDet:AddCol() )
         :cHeader          := "Descripción"
         :bStrData         := {|| ::oDbfVir:cDescrip }
         :nWidth           := 146
      end with

      with object ( ::oBrwDet:AddCol() )
         :cHeader          := "Importe"
         :bEditValue       := {|| nTotRecCli( ::oDbfVir, ::oDivisas:cAlias, ::oDbf:cCodDiv, .t. ) }
         :nWidth           := 100
         :bFooter          := {|| ::nTotRemVir( .t. ) }
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( ::oBrwDet:AddCol() )
         :cHeader          := "Div."
         :bEditValue       := {|| cSimDiv( ::oDbfVir:cDivPgo, ::oDivisas:cAlias ) }
         :nWidth           := 20
      end with

      ::oBrwDet:CreateFromResource( 150 )

      REDEFINE METER ::oMeter VAR ::nMeter ;
         ID       180 ;
         NOPERCENTAGE ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       511 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( if( ::lSave( nMode ), oDlg:End( IDOK ), ) )

		REDEFINE BUTTON ;
         ID       510 ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      REDEFINE BUTTON ;
         ID       559 ;
			OF 		oDlg ;
         ACTION   ( ChmHelp( "Remesasbancarias2" ) )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F2, {|| ::AppendDet() } )
      oDlg:AddFastKey( VK_F4, {|| ::DeleteDet() } )
      oDlg:AddFastKey( VK_F5, {|| if( ::lSave( nMode ), oDlg:End( IDOK ), ) } )
   end if

   oDlg:AddFastKey(  VK_F1,   {|| ChmHelp( "Remesasbancarias2" ) } )

   oDlg:bStart             := {|| ::oCodRem:SetFocus() }

   oDlg:Activate( , , , .t., , , {|| ::EdtRecMenu( oDlg ) } )

   ::EndEdtRecMenu()

   oBmpDiv:End()

   /*
   Guardamos los datos del browse
   */

   ::oBrwDet:CloseData()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD lSave( nMode )

   local lReturn  := .t.

   if nMode == APPD_MODE

      if Empty( ::oDbf:cCodRem )
         MsgStop( "El número de cuenta no puede estar vacío." )
         ::oCodRem:SetFocus()
         lReturn  := .f.
      end if

   end if

RETURN ( lReturn )

//---------------------------------------------------------------------------//

METHOD RollBack()

   ::GetFirstKey()

   if ::cFirstKey != nil
      while ::oDbfDet:Seek( ::cFirstKey )
         ::DelItem()
      end while
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD SaveDetails()

   local cNumRec
   local cNumFac

   ::RollBack()

   /*
   Ponemos todos los recibos con su cuenta de remesa
   */

   ::oDbfVir:GoTop()
   while !::oDbfVir:Eof()

      SysRefresh()

      cNumFac     := ::oDbfVir:cSerie + Str( ::oDbfVir:nNumFac, 9 ) + ::oDbfVir:cSufFac
      cNumRec     := cNumFac + Str( ::oDbfVir:nNumRec, 2 ) + ::oDbfVir:cTipRec

      if ::oDbfDet:SeekInOrd( cNumRec, "nNumFac" )

         ::oDbfDet:Load()

         ::oDbfDet:lCobrado   := .t.
         ::oDbfDet:dEntrada   := ::oDbf:dFecRem

         if ::oDbf:nTipRem == 2 //Remesa por descuentos

            ::oDbfDet:lRecDto    := .t.
            ::oDbfDet:dFecDto    := ::oDbf:dFecRem

         end if

         ::oDbfDet:cCtaRem       := ::oDbf:cCodRem
         ::oDbfDet:nNumRem       := ::oDbf:nNumRem
         ::oDbfDet:cSufRem       := ::oDbf:cSufRem

         ::oDbfDet:Save()

      end if

      /*
      Estado de las facturas---------------------------------------------------
      */

      if ::oFacCliT:Seek( cNumFac )
         ChkLqdFacCli( nil, ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::oDbfDet:cAlias, ::oAntCliT:cAlias, ::oIva:cAlias, ::oDivisas:cAlias )
      end if

      ::oDbfVir:Skip()

   end while

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD SaveMod19()

   local oDlg
   local oGet

   DEFINE DIALOG oDlg RESOURCE "Modelo19"

      REDEFINE GET      ::dCarCta ;
               ID       120 ;
               OF       oDlg ;
               SPINNER

      REDEFINE GET      oGet ;
               VAR      ::cPatExp ;
               ID       130 ;
               BITMAP   "FOLDER" ;
               ON HELP  ( oGet:cText( cGetFile( "*.txt", "Selección de fichero" ) ) ) ;
               OF       oDlg

      REDEFINE CHECKBOX ::lAgruparRecibos ;
               ID       100 ;
               OF       oDlg

      REDEFINE BUTTON   ;
               ID       550 ;
               OF       oDlg ;
               ACTION   ( ::InitMod19( oDlg ) )

      REDEFINE BUTTON   ;
               ID       551 ;
               OF       oDlg ;
               ACTION   ( oDlg:End() )

      oDlg:AddFastKey( VK_F5, {|| ::InitMod19( oDlg ) } )

   ACTIVATE DIALOG oDlg CENTER

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD InitMod19( oDlg )

   local nHandle
   local cBuffer
   local cHeader
   local cBanCli
   local nImpRec
   local cCodCli
   local nTotImp  := 0
   local nTotRec  := 0
   local nTotLin  := 0
   local cPreMon  := if( cDivEmp() == "EUR", "5", "0" )

   oDlg:Disable()

   if file( Rtrim( ::cPatExp ) )
      fErase( Rtrim( ::cPatExp ) )
   end if

   nHandle        := fCreate( Rtrim( ::cPatExp ) )

   if nHandle > 0

      /*
      Cabecera de registro--------------------------------------------------------
      */

      cHeader  := ::oCtaRem:oDbf:cNifPre     // Nif del presentador
      cHeader  += ::oCtaRem:oDbf:cSufCta     // SubClave

      /*
      Datos del presentador-------------------------------------------------------
      */

      cBuffer  := cPreMon
      cBuffer  += "1"
      cBuffer  += "8"                        // Constante para el modelo 19
      cBuffer  += "0"                        // Numero de linea
      cBuffer  += cHeader                    // Cabecera
      cBuffer  += Left( Dtoc( ::dCarCta ), 2) + SubStr( Dtoc( ::dCarCta ), 4, 2 ) + Right( Dtoc( ::dCarCta ), 2 )
      cBuffer  += Space( 6 )                 // Libre
      cBuffer  += ::oCtaRem:oDbf:cNomPre     // Nombre
      cBuffer  += Space( 20 )                // Libre
      cBuffer  += ::oCtaRem:oDbf:cEntPre     // Entidad
      cBuffer  += ::oCtaRem:oDbf:cAgcPre     // Agencia
      cBuffer  := Padr( cBuffer, 162 )       // Para q llege a los 162 caracteres
      cBuffer  += CRLF

      fWrite( nHandle, cBuffer )
      nTotLin  ++

      /*
      Datos del propietario-------------------------------------------------------
      */

      cBuffer  := cPreMon
      cBuffer  += "3"                        // Cte para la empresa
      cBuffer  += "8"                        // Constante para el modelo 19
      cBuffer  += "0"                        // Numero de linea
      cBuffer  += cHeader                    // Cabecera
      cBuffer  += Left( Dtoc( ::dCarCta ), 2) + SubStr( Dtoc( ::dCarCta ), 4, 2 ) + Right( Dtoc( ::dCarCta ), 2 )
      cBuffer  += Left( Dtoc( ::dCarCta ), 2) + SubStr( Dtoc( ::dCarCta ), 4, 2 ) + Right( Dtoc( ::dCarCta ), 2 )
      cBuffer  += ::oCtaRem:oDbf:cNomPre     // Nombre de la empresa igual a del presentador
      cBuffer  += ::oCtaRem:oDbf:cEntBan     // Entidad
      cBuffer  += ::oCtaRem:oDbf:cAgcBan     // Agencia
      cBuffer  += ::oCtaRem:oDbf:cDgcBan     // Digito de control
      cBuffer  += ::oCtaRem:oDbf:cCtaBan     // Cuenta
      cBuffer  += Space( 8 )                 // Libre
      cBuffer  += "01"                       // Para la 19
      cBuffer  := Padr( cBuffer, 162 )       // Para q llege a los 162 caracteres
      cBuffer  += CRLF

      fWrite( nHandle, cBuffer )
      nTotLin  ++

      /*
      Traspaso de recibos------------------------------------------------------
      */

      if ::oDbfDet:Seek( Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem )

         while Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem == Str( ::oDbfDet:nNumRem ) + ::oDbfDet:cSufRem

            cCodCli        := ::oDbfDet:cCodCli

            if ::oClientes:Seek( cCodCli )
               cBanCli     := ::oClientes:Cuenta
            else
               cBanCli     := ""
            end if

            if !Empty( cBanCli )

               if ::lAgruparRecibos
                  nImpRec  := ::nAllRecCli( cCodCli )
               else
                  nImpRec  := nTotRecCli( ::oDbfDet, ::oDivisas:cAlias, cDivEmp() )
               end if

               nTotImp     += nImpRec
               nTotRec     ++

               cBuffer     := cPreMon
               cBuffer     += "6"                        // Constante para las lineas de recibos
               cBuffer     += "8"                        // Constante para el modelo 19
               cBuffer     += "0"                        // Numero de linea
               cBuffer     += cHeader                    // Cabecera
               cBuffer     += Right( AllTrim( ::oDbfDet:cCodCli ), 6 )  // Codigo del cliente
               cBuffer     += Space( 6 )
               cBuffer     += Left( ::oClientes:Titulo, 40 )   // Nombre del cliente
               cBuffer     += cBanCli                          // Banco del cliente
               cBuffer     += cToCeros( nImpRec, ::cPorDiv )   // Importe del recibo
               cBuffer     += Space( 6 )
               cBuffer     += ::oDbfDet:cSerie + cToCeros( ::oDbfDet:nNumFac, "99999", 5 ) // Numero del recibo
               cBuffer     := Padr( cBuffer, 162 )       // Para q llege a los 162 caracteres
               cBuffer     += CRLF

               fWrite( nHandle, cBuffer )
               nTotLin     ++

               /*
               Detalles de la factura------------------------------------------
               */

               cBuffer     := cPreMon
               cBuffer     += "6"                        // Constante para las lineas de recibos
               cBuffer     += "8"                        // Constante para el modelo 19
               cBuffer     += "1"                        // Numero de linea
               cBuffer     += cHeader                    // Cabecera
               cBuffer     += Right( AllTrim( ::oDbfDet:cCodCli ), 6 )  // Codigo del cliente
               cBuffer     += Space( 6 )
               cBuffer     += "Factura Nº" + ::oDbfDet:cSerie + "/" + AllTrim( Str( ::oDbfDet:nNumFac ) ) + "/" +  ::oDbfDet:cSufFac + " de " + Dtoc( ::oDbfDet:dEntrada )
               cBuffer     += Space( 2 )                       // Para q llege a los 162 caracteres
               cBuffer     := Padr( cBuffer, 162 )       // Para q llege a los 162 caracteres
               cBuffer     += CRLF

               fWrite( nHandle, cBuffer )
               nTotLin     ++

               /*
               Detalles del cliente--------------------------------------------
               */

               cBuffer     := cPreMon
               cBuffer     += "6"                        // Constante para las lineas de recibos
               cBuffer     += "8"                        // Constante para el modelo 19
               cBuffer     += "2"                        // Numero de linea
               cBuffer     += cHeader                    // Cabecera
               cBuffer     += Right( AllTrim( ::oDbfDet:cCodCli ), 6 )  // Codigo del cliente
               cBuffer     += Space( 6 )
               cBuffer     += Left( ::oClientes:Titulo, 40 )   // Nombre del cliente
               cBuffer     += Left( ::oClientes:Domicilio, 40 )// Domicilio del cliente
               cBuffer     += ::oClientes:CodPostal            // Codigo postal
               cBuffer     += Space( 1 )
               cBuffer     += ::oClientes:Poblacion            // Población
               cBuffer     := Padr( cBuffer, 162 )             // Para q llege a los 162 caracteres
               cBuffer     += CRLF

               fWrite( nHandle, cBuffer )
               nTotLin     ++

            end if

            if ::lAgruparRecibos
               while cCodCli == ::oDbfDet:cCodCli .and. !::oDbfDet:Eof()
                  ::oDbfDet:Skip()
               end while
            else
               ::oDbfDet:Skip()
            end if

         end while

      end if

      /*
      Total de presentador-----------------------------------------------------
      */

      cBuffer  := cPreMon
      cBuffer  += "8"                              // Constante para las lineas de recibos
      cBuffer  += "8"                              // Constante para el modelo 19
      cBuffer  += "0"                              // Numero de linea
      cBuffer  += cHeader                          // Cabecera
      cBuffer  += Space( 72 )
      cBuffer  += cToCeros( nTotImp, ::cPorDiv )   // Importe total del Recibos
      cBuffer  += Space( 6 )
      cBuffer  += cToCeros( nTotRec )              // Numero de recibos por ordenante
      cBuffer  += cToCeros( nTotLin )              // Numero Total de lineas
      cBuffer  := Padr( cBuffer, 162 )       // Para q llege a los 162 caracteres
      cBuffer  += CRLF

      fWrite( nHandle, cBuffer )
      nTotLin  ++

      /*
      Total de archivo---------------------------------------------------------
      */

      cBuffer  := cPreMon
      cBuffer  += "9"                              // Constante para las lineas de recibos
      cBuffer  += "8"                              // Constante para el modelo 19
      cBuffer  += "0"                              // Numero de linea
      cBuffer  += cHeader                          // Cabecera
      cBuffer  += Space( 52 )
      cBuffer  += "0001"                           // Modificación para BCH internet
      cBuffer  += Space( 16 )
      cBuffer  += cToCeros( nTotImp, ::cPorDiv )   // Importe total del Recibos
      cBuffer  += Space( 6 )
      cBuffer  += cToCeros( nTotRec )              // Numero de recibos por ordenante
      cBuffer  += cToCeros( ++nTotLin )            // Numero Total de lineas del fichero
      cBuffer  := Padr( cBuffer, 162 )       // Para q llege a los 162 caracteres
      cBuffer  += CRLF
      fWrite( nHandle, cBuffer )

   end if

   fClose( nHandle )

   oDlg:Enable()
   oDlg:End()

   if MsgYesNo( "Proceso de exportación realizado con éxito" + CRLF + ;
                "¿ Desea abrir el fichero resultante ?", "Elija una opción." )
      ShellExecute( 0, "open", ::cPatExp, , , 1 )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD GetRecCli( cCodRem, oDlg, oBtnImportar, nMode )

   local n           := 0

   if Empty( cCodRem )
      return .t.
   end if

   oDlg:Disable()

   ::oMeter:nTotal   := ::oDbfDet:OrdKeyCount()

   if nMode == APPD_MODE

      ::oDbfDet:OrdSetFocus( "CCTAREM" )

      if ::oDbfDet:Seek( cCodRem )

         while ::oDbfDet:cCtaRem == cCodRem .and. !::oDbfDet:Eof()

            if !::oDbfDet:lCobrado                                            .and. ;
               Empty( ::oDbfDet:nNumRem )                                     .and. ;
               !Empty( ::oDbfDet:dPreCob )                                    .and. ;
               ::oDbfDet:dPreCob >= ::dFecIni                                 .and. ;
               ::oDbfDet:dPreCob <= ::dFecFin                                 .and. ;
               ::oDbfDet:nImporte > 0

               if ::oDbfVir:Append()
                  aEval( ::oDbfVir:aTField, {| oFld, n | ::oDbfVir:FldPut( n, ::oDbfDet:FieldGet( n ) ) } )
                  ::oDbfVir:Save()
               end if

               n++

            end if

            ::oDbfDet:Skip()

            ::oMeter:Set( ::oDbfDet:OrdKeyNo() )

         end while

         oBtnImportar:bWhen   := {|| .f. }

         MsgInfo( Ltrim( Trans( n, "999999999" ) ) + " recibos importados, en la cuenta " + cCodRem )
         if n == 0
            oBtnImportar:bWhen   := {|| .t. }
         end if

      else

         MsgStop( "No se encuentran recibos, en la cuenta " + cCodRem )

      end if

      ::oMeter:Set( 0 )
      ::oMeter:Refresh()

      ::oDbfDet:OrdSetFocus( "NNUMREM" )

      ::oDbfVir:GoTop()
      ::oBrwDet:Refresh()

   end if

   oDlg:Enable()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD nTotRem( lPic )

   local nTot     := 0

   DEFAULT lPic   := .f.

   if ::oDbfDet != nil .and. ::oDbf:nNumRem != 0

      ::oDbfDet:GetStatus()

      if ::oDbfDet:Seek( Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem )
         while Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem == Str( ::oDbfDet:nNumRem, 9 ) + ::oDbfDet:cSufRem .and. !::oDbfDet:eof()
            nTot  += nTotRecCli( ::oDbfDet, ::oDivisas:cAlias, ::oDbf:cCodDiv, .f. )
            ::oDbfDet:Skip()
         end while
      end if

      ::oDbfDet:SetStatus()

   end if

RETURN ( if( lPic, Trans( nTot, ::cPorDiv ), nTot ) )

//---------------------------------------------------------------------------//

METHOD nTotRemVir( lPic )

   local nTot     := 0

   DEFAULT lPic   := .f.

   ::oDbfVir:GetStatus()

   ::oDbfVir:GoTop()
   while !::oDbfVir:eof()
      nTot        += nTotRecCli( ::oDbfVir, ::oDivisas:cAlias, ::oDbf:cCodDiv, .f. )
      ::oDbfVir:Skip()
   end while

   ::oDbfVir:SetStatus()

RETURN ( if( lPic, Trans( nTot, ::cPorDiv ), nTot ) )

//---------------------------------------------------------------------------//

METHOD AppendDet()

   local cCodRec  := ""

   if BrwRecCli( @cCodRec, ::oDbfDet:cAlias, ::oClientes:cAlias, ::oDivisas:cAlias, ::oBandera )

      if ::oDbfDet:lCobrado
         msgStop( "Recibo ya cobrado." )
         return ( .f. )
      end if

      if !Empty( ::oDbfDet:nNumRem )
         msgStop( "Recibo ya remesado." )
         return ( .f. )
      end if

      if ::lNowExist( cCodRec )
         msgStop( "Recibo ya incluido en remesa." )
         return ( .f. )
      end if

      if ::oDbfDet:SeekInOrd( cCodRec, "nNumFac" )
         if ::oDbfVir:Append()
            aEval( ::oDbfVir:aTField, {| oFld, n | ::oDbfVir:FldPut( n, ::oDbfDet:FieldGet( n ) ) } )
            ::oDbfVir:Save()
         end if
      end if

      ::oBrwDet:Refresh()

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Del()

   if oUser():lNotConfirmDelete() .or. msgNoYes( "¿ Desea eliminar el registro en curso ?", "Confirme supresión" )

      ::GetFirstKey()

      if !Empty( ::cFirstKey )
         while ::oDbfDet:Seek( ::cFirstKey )
            ::DelItem()
         end while
      end if

      ::oDbf:Delete()

   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD DelItem()

   local cNumFac        := ::oDbfDet:cSerie + Str( ::oDbfDet:nNumFac ) + ::oDbfDet:cSufFac

   ::oDbfDet:Load()
   ::oDbfDet:nNumRem    := 0
   ::oDbfDet:cSufRem    := ""
   ::oDbfDet:lCobrado   := .f.
   ::oDbfDet:dEntrada   := Ctod( "" )
   ::oDbfDet:Save()

   /*
   Revisamos el estado de la factura-------------------------------------------
   */

   if ::oFacCliT:Seek( cNumFac )
      ChkLqdFacCli( nil, ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::oDbfDet:cAlias, ::oAntCliT:cAlias, ::oIva:cAlias, ::oDivisas:cAlias )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

FUNCTION Remesas( oMenuItem, oWnd )

   local nLevel
   local oRemesas

   DEFAULT  oMenuItem   := "01060"
   DEFAULT  oWnd        := oWnd()

   nLevel               := nLevelUsr( oMenuItem )
   if nAnd( nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      return nil
   end if

   /*
   Cerramos todas las ventanas------------------------------------------------
   */

   if oWnd != nil
      SysRefresh(); oWnd:CloseAll(); SysRefresh()
   end if

   /*
   Anotamos el movimiento para el navegador------------------------------------
   */

   AddMnuNext( "Remesas de recibos", ProcName() )

   oRemesas  := TRemesas():New( cPatEmp() )
   oRemesas:Activate( nLevel )

RETURN NIL

//---------------------------------------------------------------------------//

static function cToCeros( nImporte, cPicture, nLen )

   local cImporte

   DEFAULT cPicture  := "9999999999"
   DEFAULT nLen      := 10

   cImporte          := Trans( nImporte, cPicture )
   cImporte          := StrTran( cImporte, ",", "" )
   cImporte          := StrTran( cImporte, ".", "" )
   cImporte          := StrTran( Right( cImporte, 10 ), " ", "0" )

return ( cImporte )

//--------------------------------------------------------------------------//
/*
Si deciden cancelar tenemos q poner los recibos como estaban
*/

METHOD SetRecCli()

   if Empty( ::oDbf:cCodRem )
      return ( Self )
   end if

   ::oDbfDet:OrdSetFocus( "CCTAREM" )

   while ::oDbfDet:Seek( ::oDbf:cCodRem ) .and. ::oDbfDet:cCtaRem == ::oDbf:cCodRem .and. !::oDbfDet:Eof()

      ::oDbfDet:Load()
      ::oDbfDet:lCobrado  := .f.
      ::oDbfDet:nNumRem   := 0
      ::oDbfDet:cSufRem   := ""
      ::oDbfDet:dEntrada  := Ctod( "" )
      ::oDbfDet:Save()

      ::oDbfDet:Skip()

   end while

   ::oDbfDet:OrdSetFocus( "NNUMREM" )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Conta( lSimula )

   local cCtaCli     := ""
   local cCtaCliCta
   local cCtaCliDto  := ""
   local aSimula     := {}
   local cCodPro     := cProCnt()
   local cRuta       := cRutCnt()
   local cCodEmp     := cCodEmpCnt( "A" )
   local cCtaCon     := ::oCtaRem:cRetCtaCon( ::oDbf:cCodRem )
   local cCtaBcoDto  := ::oCtaRem:cRetCtaDto( ::oDbf:cCodRem )
   local nAsiento
   local cTerNif     := Space(1)
   local cTerNom     := Space(1)
   local lErrorFound := .f.

   /*
	Chequando antes de pasar a Contaplus
	--------------------------------------------------------------------------
	*/

   if ::oDbf:lConta
      if !msgYesNo(  "Remesa : " + ::oDbf:cNumRem + " contabilizada." + CRLF + ;
                     "¿ Desea contabilizarla de nuevo ?" )
         return .f.
      end if
   end if

   if !::lChkSelect .AND. !ChkRuta( cRutCnt() )
      ::oTreeSelect:Add( "Remesa : " + Alltrim( ::oDbf:cNumRem ) + " ruta no valida.", 0 )
      lErrorFound    := .t.
   end if

   /*
   Seleccionamos las empresa dependiendo de la serie de factura
	--------------------------------------------------------------------------
	*/

   if empty( cCodEmp ) .AND. !::lChkSelect
      ::oTreeSelect:Add( "Remesa : " + Alltrim( ::oDbf:cNumRem ) + " no se definierón empresas asociadas.", 0 )
      lErrorFound    := .t.
   end if

	/*
   Chequeamos los valores de cuentas de banco
	--------------------------------------------------------------------------
	*/

   if !::lChkSelect .and. !ChkSubCta( cRuta, cCodEmp, cCtaCon, , .f., .f. )
      ::oTreeSelect:Add( "Remesa : " + Alltrim( ::oDbf:cNumRem ) + " subcuenta " + cCtaCon + " no encontada.", 0 )
      lErrorFound    := .t.
   end if

	/*
	Estudio de los Articulos de una factura
	--------------------------------------------------------------------------
	*/


   if !ChkSubCta( cRuta, cCodEmp, cCtaCon, , .f., .f. )
      ::oTreeSelect:Add( "Cuenta : " + rtrim( cCtaCon ) + " banco no existe.", 0 )
      lErrorFound    := .t.
   end if

   if ::oDbf:nTipRem == 2 .and. !ChkSubCta( cRuta, cCodEmp, cCtaBcoDto, , .f., .f. )
      ::oTreeSelect:Add( "Cuenta : " + rtrim( cCtaBcoDto ) + " de descuento banco no existe.", 0 )
      lErrorFound    := .t.
   end if

   if ::oDbfDet:Seek( Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem )

      while Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem == Str( ::oDbfDet:nNumRem ) + ::oDbfDet:cSufRem .and. !::oDbfDet:eof()

         if ::oClientes:Seek( ::oDbfDet:cCodCli )
            cCtaCli        := ::oClientes:SubCta
            cCtaCliCta     := ::oClientes:SubCtaDto
         else
            cCtaCli        := ""
            cCtaCliCta     := ""
         end if

         if !ChkSubCta( cRuta, cCodEmp, cCtaCli, , .f., .f. )
            ::oTreeSelect:Add( "Cliente : " + rtrim( ::oClientes:Titulo ) + " cuenta contable no existe.", 0 )
            lErrorFound    := .t.
         end if

         /*
         Chequear en caso de remesas de descuento
         */

         if ::oDbf:nTipRem == 2 .and. !ChkSubCta( cRuta, cCodEmp, cCtaCliDto, , .f., .f. )
            ::oTreeSelect:Add( "Cliente : " + rtrim( ::oClientes:Titulo ) + " cuenta descuento no existe.", 0 )
            lErrorFound    := .t.
         end if

         ::oDbfDet:Skip()

      end while

   else

      ::oTreeSelect:Add( "Remesa : " + Alltrim( ::oDbf:cNumRem )  + " remesa sin recibos.", 0 )

      lErrorFound          := .t.

   end if

   /*
   Comporbamos fechas
   ----------------------------------------------------------------------------
   */

   if Empty( ::oDbf:dConta )
      ::oTreeSelect:Add( "Remesa : " + Alltrim( ::oDbf:cNumRem ) + " sin fecha de contabilización", 0 )
      lErrorFound    := .t.
   end if

   if !ChkFecha( , , ::oDbf:dConta, .f. )
      ::oTreeSelect:Add( "Remesa : " + Alltrim( ::oDbf:cNumRem ) + " asiento fuera de fechas", 0 )
      lErrorFound    := .t.
   end if

	/*
   Realización de Asientos
	--------------------------------------------------------------------------
   */

   if OpenDiario( , cCodEmp )
      nAsiento := RetLastAsi()
   else
      ::oTreeSelect:Add( "Remesa : " + Alltrim( ::oDbf:cNumRem ) + " imposible abrir ficheros.", 0 )
      lErrorFound    := .t.
   end if

   if ::oDbf:nTipRem == 2

   aadd( aSimula, MkAsiento(  nAsiento, ;
                              ::oDbf:cCodDiv,;
                              ::oDbf:dConta,;
                              cCtaBcoDto,;
                              ,;
                              ::nTotRem( .f. ),;
                              "Abono facturas",;
                              ,;
                              ,;
                              ,;
                              ,;
                              ,;
                              ,;
                              cCodPro,;
                              ,;
                              ,;
                              ,;
                              ,;
                              lSimula,;
                              cTerNif,;
                              cTerNom ) )

   else

   aadd( aSimula, MkAsiento(  nAsiento, ;
                              ::oDbf:cCodDiv,;
                              ::oDbf:dConta,;
                              cCtaCon,;
                              ,;
                              ::nTotRem( .f. ),;
                              "Abono facturas",;
                              ,;
                              ,;
                              ,;
                              ,;
                              ,;
                              ,;
                              cCodPro,;
                              ,;
                              ,;
                              ,;
                              ,;
                              lSimula,;
                              cTerNif,;
                              cTerNom ) )

   end if

	/*
	Asientos de Ventas
	-------------------------------------------------------------------------
	*/

   if ::oDbfDet:Seek( Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem )

      while Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem == Str( ::oDbfDet:nNumRem ) + ::oDbfDet:cSufRem .and. !::oDbf:Eof()

         if ::oClientes:Seek( ::oDbfDet:cCodCli )
            cCtaCli        := ::oClientes:SubCta
         else
            cCtaCli        := ""
         end if

         aadd( aSimula, MkAsiento(  nAsiento, ;
                                    ::oDbf:cCodDiv,;
                                    ::oDbf:dConta,;
                                    cCtaCli,;
                                    ,;
                                    ,;
                                    "Abono factura " + AllTrim( ::oDbfDet:cSerie + "/" + Str( ::oDbfDet:nNumFac ) + "/" + ::oDbfDet:cSufFac ),;
                                    nTotRecCli( ::oDbfDet:cAlias, ::oDivisas:cAlias, ::oDbf:cCodDiv, .f. ),;
                                    ::oDbfDet:cSerie + Str( ::oDbfDet:nNumFac ) + ::oDbfDet:cSufFac,;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    cCodPro,;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    lSimula,;
                                    cTerNif,;
                                    cTerNom ) )

         ::oDbfDet:Skip()

      end while

   end if

   if ::oDbf:nTipRem == 2

      if ::oDbfDet:Seek( Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem )

         while Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem == Str( ::oDbfDet:nNumRem ) + ::oDbfDet:cSufRem .and. !::oDbf:Eof()

            if ::oClientes:Seek( ::oDbfDet:cCodCli )
               cCtaCli        := ::oClientes:SubCtaDto
            else
               cCtaCli        := ""
            end if

            aadd( aSimula, MkAsiento(  nAsiento, ;
                                       ::oDbf:cCodDiv,;
                                       ::oDbf:dConta,;
                                       cCtaCli,;
                                       ,;
                                       nTotRecCli( ::oDbfDet:cAlias, ::oDivisas:cAlias, ::oDbf:cCodDiv, .f. ),;
                                       "Abono factura " + AllTrim( ::oDbfDet:cSerie + "/" + Str( ::oDbfDet:nNumFac ) + "/" + ::oDbfDet:cSufFac ),;
                                       ,;
                                       ::oDbfDet:cSerie + Str( ::oDbfDet:nNumFac ) + ::oDbfDet:cSufFac,;
                                       ,;
                                       ,;
                                       ,;
                                       ,;
                                       cCodPro,;
                                       ,;
                                       ,;
                                       ,;
                                       ,;
                                       lSimula,;
                                       cTerNif,;
                                       cTerNom ) )

            ::oDbfDet:Skip()

         end while

      end if

      aadd( aSimula, MkAsiento(  nAsiento, ;
                                 ::oDbf:cCodDiv,;
                                 ::oDbf:dConta,;
                                 cCtaBcoDto,;
                                 ,;
                                 ,;
                                 "Abono facturas",;
                                 ::nTotRem( .f. ),;
                                 ,;
                                 ,;
                                 ,;
                                 ,;
                                 ,;
                                 cCodPro,;
                                 ,;
                                 ,;
                                 ,;
                                 ,;
                                 lSimula,;
                                 cTerNif,;
                                 cTerNom ) )

   end if

   /*
   Ponemos la remesa como Contabilizada
	--------------------------------------------------------------------------
	*/

   if !lSimula .and. !lErrorFound

      ::ChangeConta( .t. )

      ::oTreeSelect:Add( "Remesa : " + Alltrim( ::oDbf:cNumRem ) + " asiento generado num. " + Rtrim( Str( nAsiento ) ), 0 )

   else

      msgTblCon( aSimula, ::oDbf:cCodDiv, ::oDivisas:cAlias, !lErrorFound, Alltrim( ::oDbf:cNumRem ), {|| aWriteAsiento( aSimula, ::oDbf:cCodDiv, .t., ::oTreeSelect, Alltrim( ::oDbf:cNumRem ), nAsiento ), ::ChangeConta( .t. ) } )

   end if

   CloseDiario()

RETURN NIL

//---------------------------------------------------------------------------//

METHOD cRetCtaRem()

   local cCtaRem  := ""

   if ::oCtaRem != nil
      cCtaRem     := ::oCtaRem:cRetCtaRem( ::oDbf:cCodRem )
   end if

RETURN ( cCtaRem )

//---------------------------------------------------------------------------//

METHOD cBmp()

   local cBmpDiv  := ""

   if ::oDivisas != nil .and. ::oBandera != nil
      cBmpDiv     := cSimDiv( ::oDbf:cCodDiv, ::oDivisas:cAlias )
   end if

return ( cBmpDiv )

//---------------------------------------------------------------------------//

METHOD GetNewCount()

   ::oDbf:nNumRem       := nNewDoc( nil, ::oDbf:nArea, "NREMESA", nil, ::oDbfCnt:nArea )

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD lNowExist( cCodRec )

   local lRet  := .f.

   ::oDbfVir:GetStatus()

   ::oDbfVir:GoTop()
   while !::oDbfVir:eof()
      if ::oDbfVir:cSerie + Str( ::oDbfVir:nNumFac, 9 ) + ::oDbfVir:cSufFac + Str( ::oDbfVir:nNumRec ) == cCodRec
         lRet  := .t.
      end if
      ::oDbfVir:Skip()
   end while

   ::oDbfVir:SetStatus()

RETURN ( lRet )

//--------------------------------------------------------------------------//

Method lContabilizaRecibos( lConta )

   DEFAULT lConta := .t.

   if ::oDbfDet != nil

      ::oDbfDet:GetStatus()

      if ::oDbfDet:Seek( Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem )
         while Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem == Str( ::oDbfDet:nNumRem, 9 ) + ::oDbfDet:cSufRem .and. !::oDbfDet:eof()

            ::oDbfDet:FieldPutByName( "lConPgo", lConta )

            ::oDbfDet:Skip()

         end while
      end if

      ::oDbfDet:SetStatus()

   end if

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD ChangeConta( lConta )

   ::oDbf:FieldPutByName( "lConta", lConta )

   /*
   Ponemos todos los recibos como contabilizado
   */

   ::lContabilizaRecibos( lConta )

   ::oWndBrw:Refresh()

RETURN Self

//---------------------------------------------------------------------------//

Method nAllRecCli( cCodigoCliente )

   local nTotRecCli  := 0
   local nRecno      := ::oDbfDet:Recno()

   while Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem + cCodigoCliente == Str( ::oDbfDet:nNumRem ) + ::oDbfDet:cSufRem + ::oDbfDet:cCodCli .and. !::oDbfDet:Eof()

      nTotRecCli     += nTotRecCli( ::oDbfDet, ::oDivisas:cAlias, cDivEmp() )

      ::oDbfDet:Skip()

   end while

   ::oDbfDet:GoTo( nRecno )

RETURN nTotRecCli

//---------------------------------------------------------------------------//

METHOD EdtRecMenu( oDlg )

   MENU ::oMenu

      MENUITEM    "&1. Rotor"

         MENU

            MENUITEM    "&1. Modificar cuenta";
               MESSAGE  "Modificar cuenta" ;
               RESOURCE "Address_book2_16" ;
               ACTION   ( if( !Empty( ::oDbf:cCodRem ), ::oCtaRem:Edit(), MsgStop( "Cuenta vacía" ) ) )

            MENUITEM    "&2. Visualizar recibo";
               MESSAGE  "Visualiza el recibo seleccionado" ;
               RESOURCE "Briefcase_user1_16" ;
               ACTION   ( ZooRecCli( ::oDbfVir:cSerie + Str( ::oDbfVir:nNumFac ) + ::oDbfVir:cSufFac + Str( ::oDbfVir:nNumRec ) ) );

         ENDMENU

   ENDMENU

   oDlg:SetMenu( ::oMenu )

   ::oBrwDet:Load()

RETURN ( ::oMenu )

//---------------------------------------------------------------------------//

METHOD EndEdtRecMenu()

RETURN ( ::oMenu:End() )

//---------------------------------------------------------------------------//

METHOD Report()

#ifndef __TACTIL__

   ListRem():New( "Listado de remesas de clientes" ):Play()

#endif

RETURN ( self )

//---------------------------------------------------------------------------//