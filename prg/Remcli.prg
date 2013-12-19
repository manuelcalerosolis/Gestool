#include "FiveWin.Ch"
#include "MesDbf.ch"
#include "Factu.ch"
#include "Report.ch"

//---------------------------------------------------------------------------//

CLASS TRemesas FROM TMasDet

   DATA  oCtaRem
   DATA  oDivisas
   DATA  oDbfCnt
   DATA  oCliBnc
   DATA  oRecibos
   DATA  oClientes
   DATA  oFacCliT
   DATA  oFacCliL
   DATA  oAntCliT
   DATA  oIva
   DATA  oBandera

   DATA  cPorDiv
      
   DATA  cFicheroExportacion
   DATA  dExpedicionIni
   DATA  dExpedicionFin
   DATA  dVencimientoIni

   DATA  dVencimeintoFin

   DATA  oMeter            AS OBJECT
   DATA  nMeter            AS NUMERIC  INIT  0
   DATA  bmpConta
   DATA  aMsg              AS ARRAY    INIT  {}
   DATA  lAgruparRecibos               INIT  .f.
   DATA  lUsarVencimiento              INIT  .f.
   DATA  cMru                          INIT "Briefcase_document_16"
   DATA  cBitmap                       INIT clrTopArchivos
   DATA  oMenu
   DATA  oCodRem
   DATA  oFecExp
   DATA  oExportado

   DATA  dVencimiento
   DATA  dAnteriorVencimiento

   DATA  oCuaderno

   METHOD New( cPath, oWndParent, oMenuItem )

   METHOD OpenFiles( lExclusive )
   METHOD CloseFiles()

   METHOD DefineFiles()
   METHOD DefineDetails( cPath, cVia, lUniqueName, cFileName )

   METHOD OpenService( lExclusive )
   METHOD CloseService()

   METHOD Resource( nMode )
   METHOD ImportResource( nMode )
   METHOD Activate()
   METHOD lSave()

   METHOD GetRecCli( oDlg )
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

   METHOD cNumRem()        INLINE   ( Alltrim( Str( ::oDbf:nNumRem ) + "/" + ::oDbf:cSufRem ) )

   /*
   Metodos para el modelo 19---------------------------------------------------
   */

   METHOD SaveModelo()
   METHOD InitMod19()
   
   METHOD InitSepa19( oDlg )
      METHOD InsertPresentador()
      METHOD InsertAcreedor()
      METHOD InsertDeudor()

   METHOD InitMod58()

   Method nAllRecCli()

   METHOD nTotRemesaVir()     INLINE   0

   METHOD Report()

   METHOD Conta()
   Method ChangeConta( lConta )
   Method lContabilizaRecibos( lConta )

   METHOD cRetCtaRem()

   METHOD cBmp()

   METHOD GetNewCount()

   METHOD lNowExist()

   METHOD SaveDetails()

   METHOD EdtRecMenu( oDlg )

   METHOD EndEdtRecMenu()

   METHOD ChangeExport()

   METHOD TipoRemesa()              INLINE ( if( ::oDbf:nTipRem == 2, "Descuento", "Pago" ) )

   METHOD FechaVencimiento()        INLINE ( if( ::lUsarVencimiento, ::oDbfDet:dFecVto, ::dVencimiento ) )
   METHOD lCambiaVencimiento()      INLINE ( if( ::dAnteriorVencimiento != ::FechaVencimiento(), ( ::dAnteriorVencimiento := ::FechaVencimiento(), .t. ), .f. ) )

   METHOD CuentaCliente()           INLINE ( ::oDbfDet:cPaisIBAN + ::oDbfDet:cCtrlIBAN + ::oDbfDet:cEntCli + ::oDbfDet:cSucCli + ::oDbfDet:cDigCli + ::oDbfDet:cCtaCli )
   METHOD GetValidCuentaCliente()   INLINE ( if( Empty( ::CuentaCliente() ), cClientCuenta( ::oDbfDet:cCodCli, ::oCliBnc:cAlias ), ::CuentaCliente() ) )
   
   METHOD CuentaEmpresa()           INLINE ( ::oDbfDet:cEPaisIBAN + ::oDbfDet:cECtrlIBAN + ::oDbfDet:cEntEmp + ::oDbfDet:cSucEmp + ::oDbfDet:cDigEmp + ::oDbfDet:cCtaEmp )

   METHOD EntidadCliente()          INLINE ( ::oDbfDet:cEntCli )
   METHOD GetValidEntidadCliente()  INLINE ( if( Empty( ::EntidadCliente() ), cClientEntidad( ::oDbfDet:cCodCli, ::oCliBnc:cAlias ), ::EntidadCliente() ) )

   METHOD GetBICClient()            INLINE ( GetBIC( ::GetValidEntidadCliente() ) )

   METHOD TextoDocumento()          INLINE ( ::oDbfDet:cSerie + "/" + AllTrim( Str( ::oDbfDet:nNumFac ) ) + "/" +  ::oDbfDet:cSufFac )

   METHOD CuentaRemesa()            INLINE ( ::oCtaRem:oDbf:cPaisIBAN + ::oCtaRem:oDbf:cCtrlIBAN + ::oCtaRem:oDbf:cEntBan + ::oCtaRem:oDbf:cAgcBan + ::oCtaRem:oDbf:cDgcBan + ::oCtaRem:oDbf:cCtaBan )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( cPath, oMenuItem, oWndParent )

   DEFAULT cPath           := cPatEmp()
   DEFAULT oWndParent      := GetWndFrame()
   DEFAULT oMenuItem       := "01060"

   ::nLevel                := nLevelUsr( oMenuItem )

   ::cPath                 := cPath
   ::oWndParent            := oWndParent

   ::dExpedicionIni        := Ctod( "01/" + Str( Month( Date() ), 2 ) + "/" + Str( Year( Date() ), 4 ) )
   ::dExpedicionFin        := Date()
   ::dVencimientoIni       := ::dExpedicionIni
   ::dVencimeintoFin       := Date()

   ::cNumDocKey            := "nNumRem"
   ::cSufDocKey            := "cSufRem"

   ::lMoveDlgSelect        := .t.

   ::bmpConta              := LoadBitmap( GetResources(), "bConta" )

   ::dVencimiento          := Date()
   ::cFicheroExportacion   := PadR( "C:\Recibos.Txt", 200 )

   ::bFirstKey             := {|| Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem }
   ::bWhile                := {|| Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem == Str( ::oDbfVir:nNumRem, 9 ) + ::oDbfVir:cSufRem .and. !::oDbfVir:Eof() }

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE DATABASE ::oDbf FILE "REMCLIT.DBF" CLASS "REMCLI" ALIAS "REMCLI" PATH ( cPath ) VIA ( cDriver ) COMMENT "Remesas bancarias"

      FIELD NAME "lConta"              TYPE "L" LEN  1  DEC 0                             DEFAULT  .f.                                                                                 HIDE            OF ::oDbf
      FIELD CALCULATE NAME "bmpConta"           LEN  1  DEC 0                             VAL {|| ::oDbf:lConta }  BITMAPS "Sel16", "Nil16"  COMMENT { "Contabilizado", "bmpConta16", 3 } COLSIZE 20   OF ::oDbf
      FIELD NAME "lExport"             TYPE "L" LEN  1  DEC 0                             DEFAULT  .f.                                                                                 HIDE            OF ::oDbf
      FIELD CALCULATE NAME "bmpExport"          LEN  1  DEC 0                             VAL {|| ::oDbf:lExport } BITMAPS "Sel16", "Nil16"  COMMENT { "Exportado", "bmpExptar16", 3 }     COLSIZE 20  OF ::oDbf
      FIELD NAME "nNumRem"             TYPE "N" LEN  9  DEC 0 PICTURE "999999999"                                                            COMMENT "Número"              ALIGN RIGHT     COLSIZE 80  OF ::oDbf
      FIELD NAME "cSufRem"             TYPE "C" LEN  2  DEC 0 PICTURE "@!"                DEFAULT  RetSufEmp()                               COMMENT "Delegación"                          COLSIZE 20  OF ::oDbf
      FIELD NAME "cCodRem"             TYPE "C" LEN  3  DEC 0 PICTURE "@!"                                                                   COMMENT "Cuenta" COLSIZE  80                              OF ::oDbf
      FIELD CALCULATE NAME "cNomRem"            LEN 60  DEC 0                             VAL      ::cRetCtaRem()                            COMMENT "Nombre" COLSIZE 200                              OF ::oDbf
      FIELD NAME "dFecRem"             TYPE "D" LEN  8  DEC 0                             DEFAULT  Date()                                    COMMENT "Fecha"  COLSIZE  80                              OF ::oDbf
      FIELD NAME "nTipRem"             TYPE "N" LEN  1  DEC 0 PICTURE "9"                 DEFAULT  1                                         COMMENT ""                                HIDE            OF ::oDbf
      FIELD CALCULATE NAME "cTipRem"            LEN 60  DEC 0                             VAL      ::TipoRemesa()                            COMMENT "Tipo"   COLSIZE  80                              OF ::oDbf
      FIELD NAME "cCodDiv"             TYPE "C" LEN  3  DEC 0 PICTURE "@!"                DEFAULT  cDivEmp()                                 COMMENT ""                                HIDE            OF ::oDbf
      FIELD NAME "nVdvDiv"             TYPE "N" LEN 16  DEC 6 PICTURE "@E 999,999.9999"   DEFAULT  1                                         COMMENT ""                                HIDE            OF ::oDbf
      FIELD CALCULATE NAME "nTotRem"            LEN 16  DEC 6                             VAL      ::nTotRem(.t.)                            COMMENT "Total"  COLSIZE 100  ALIGN RIGHT                 OF ::oDbf
      FIELD CALCULATE NAME "cBmpDiv"            LEN 20  DEC 0                             VAL      ::cBmp()                                  COMMENT "Div."   COLSIZE  25                              OF ::oDbf
      FIELD NAME "dConta"              TYPE "D" LEN  8  DEC 0                                                                                COMMENT "Contab."                                         OF ::oDbf
      FIELD NAME "dExport"             TYPE "D" LEN  8  DEC 0                             DEFAULT CtoD( "" )                                                                           HIDE            OF ::oDbf

      INDEX TO "RemCliT.Cdx" TAG "nNumRem" ON "Str( nNumRem ) + cSufRem"   COMMENT "Número" NODELETED OF ::oDbf
      INDEX TO "RemCliT.Cdx" TAG "cCodRem" ON "cCodRem"                    COMMENT "Cuenta" NODELETED OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//---------------------------------------------------------------------------//

METHOD DefineDetails( cPath, cVia, lUniqueName, cFileName )

   local oDbf

   DEFAULT cPath        := ::cPath
   DEFAULT lUniqueName  := .f.
   DEFAULT cFileName    := "FacCliP"
   DEFAULT cVia         := cDriver()

   if lUniqueName
      cFileName         := cGetNewFileName( cFileName, , , cPatTmp() )
   end if

   DEFINE TABLE oDbf FILE ( cFileName ) CLASS ( cFileName ) ALIAS ( cFileName ) PATH ( cPath ) VIA ( cVia )

      FIELD NAME "cSerie"     TYPE "C" LEN   1 DEC 0 OF oDbf           
      FIELD NAME "nNumFac"    TYPE "N" LEN   9 DEC 0 OF oDbf     
      FIELD NAME "cSufFac"    TYPE "C" LEN   2 DEC 0 OF oDbf     
      FIELD NAME "nNumRec"    TYPE "N" LEN   2 DEC 0 OF oDbf     
      FIELD NAME "cTipRec"    TYPE "C" LEN   1 DEC 0 OF oDbf     
      FIELD NAME "cCodPgo"    TYPE "C" LEN   2 DEC 0 OF oDbf     
      FIELD NAME "cCodCaj"    TYPE "C" LEN   3 DEC 0 OF oDbf     
      FIELD NAME "cTurRec"    TYPE "C" LEN   6 DEC 0 OF oDbf     
      FIELD NAME "cCodCli"    TYPE "C" LEN  12 DEC 0 OF oDbf     
      FIELD NAME "cNomCli"    TYPE "C" LEN  80 DEC 0 OF oDbf     
      FIELD NAME "dEntrada"   TYPE "D" LEN   8 DEC 0 OF oDbf     
      FIELD NAME "nImporte"   TYPE "N" LEN  16 DEC 6 OF oDbf     
      FIELD NAME "cDesCriP"   TYPE "C" LEN 100 DEC 0 OF oDbf     
      FIELD NAME "dPreCob"    TYPE "D" LEN   8 DEC 0 OF oDbf     
      FIELD NAME "cPgdoPor"   TYPE "C" LEN  50 DEC 0 OF oDbf     
      FIELD NAME "cDocPgo"    TYPE "C" LEN  50 DEC 0 OF oDbf     
      FIELD NAME "lCobrado"   TYPE "L" LEN   1 DEC 0 OF oDbf     
      FIELD NAME "cDivPgo"    TYPE "C" LEN   3 DEC 0 OF oDbf     
      FIELD NAME "nVdvPgo"    TYPE "N" LEN  10 DEC 6 OF oDbf     
      FIELD NAME "lConPgo"    TYPE "L" LEN   1 DEC 0 OF oDbf     
      FIELD NAME "cCtaRec"    TYPE "C" LEN  12 DEC 0 OF oDbf     
      FIELD NAME "nImpEur"    TYPE "N" LEN  16 DEC 6 OF oDbf     
      FIELD NAME "lImpEur"    TYPE "L" LEN   1 DEC 0 OF oDbf     
      FIELD NAME "nNumRem"    TYPE "N" LEN   9 DEC 0 OF oDbf     
      FIELD NAME "cSufRem"    TYPE "C" LEN   2 DEC 0 OF oDbf     
      FIELD NAME "cCtaRem"    TYPE "C" LEN   3 DEC 0 OF oDbf     
      FIELD NAME "lRecImp"    TYPE "L" LEN   1 DEC 0 OF oDbf     
      FIELD NAME "lRecDto"    TYPE "L" LEN   1 DEC 0 OF oDbf     
      FIELD NAME "dFecDto"    TYPE "D" LEN   8 DEC 0 OF oDbf     
      FIELD NAME "dFecVto"    TYPE "D" LEN   8 DEC 0 OF oDbf     
      FIELD NAME "cCodAge"    TYPE "C" LEN   3 DEC 0 OF oDbf     
      FIELD NAME "nNumCob"    TYPE "N" LEN   9 DEC 0 OF oDbf     
      FIELD NAME "cSufCob"    TYPE "C" LEN   2 DEC 0 OF oDbf     
      FIELD NAME "nImpCob"    TYPE "N" LEN  16 DEC 6 OF oDbf     
      FIELD NAME "nImpGas"    TYPE "N" LEN  16 DEC 6 OF oDbf     
      FIELD NAME "cCtaGas"    TYPE "C" LEN  12 DEC 0 OF oDbf     
      FIELD NAME "lEsperaDoc" TYPE "L" LEN   1 DEC 0 OF oDbf     
      FIELD NAME "lCloPgo"    TYPE "L" LEN   1 DEC 0 OF oDbf     
      FIELD NAME "dFecImp"    TYPE "D" LEN   8 DEC 0 OF oDbf     
      FIELD NAME "cHorImp"    TYPE "C" LEN   5 DEC 0 OF oDbf     
      FIELD NAME "lNotArqueo" TYPE "L" LEN   1 DEC 0 OF oDbf     
      FIELD NAME "cCodBnc"    TYPE "C" LEN   4 DEC 0 OF oDbf     
      FIELD NAME "dFecCre"    TYPE "D" LEN   8 DEC 0 OF oDbf     
      FIELD NAME "cHorCre"    TYPE "C" LEN   5 DEC 0 OF oDbf     
      FIELD NAME "cCodUsr"    TYPE "C" LEN   3 DEC 0 OF oDbf     
      FIELD NAME "lDevuelto"  TYPE "L" LEN   1 DEC 0 OF oDbf     
      FIELD NAME "dFecDev"    TYPE "D" LEN   8 DEC 0 OF oDbf     
      FIELD NAME "cMotDev"    TYPE "C" LEN 250 DEC 0 OF oDbf     
      FIELD NAME "cRecDev"    TYPE "C" LEN  14 DEC 0 OF oDbf     
      FIELD NAME "lSndDoc"    TYPE "L" LEN   1 DEC 0 OF oDbf     
      FIELD NAME "cBncEmp"    TYPE "C" LEN  50 DEC 0 OF oDbf     
      FIELD NAME "cBncCli"    TYPE "C" LEN  50 DEC 0 OF oDbf     
      FIELD NAME "cEPaisIBAN" TYPE "C" LEN   2 DEC 0 OF oDbf     
      FIELD NAME "cECtrlIBAN" TYPE "C" LEN   2 DEC 0 OF oDbf     
      FIELD NAME "cEntEmp"    TYPE "C" LEN   4 DEC 0 OF oDbf     
      FIELD NAME "cSucEmp"    TYPE "C" LEN   4 DEC 0 OF oDbf     
      FIELD NAME "cDigEmp"    TYPE "C" LEN   2 DEC 0 OF oDbf     
      FIELD NAME "cCtaEmp"    TYPE "C" LEN  10 DEC 0 OF oDbf     
      FIELD NAME "cPaisIBAN"  TYPE "C" LEN   2 DEC 0 OF oDbf     
      FIELD NAME "cCtrlIBAN"  TYPE "C" LEN   2 DEC 0 OF oDbf     
      FIELD NAME "cEntCli"    TYPE "C" LEN   4 DEC 0 OF oDbf     
      FIELD NAME "cSucCli"    TYPE "c" LEN   4 DEC 0 OF oDbf     
      FIELD NAME "cDigCli"    TYPE "C" LEN   2 DEC 0 OF oDbf     
      FIELD NAME "cCtaCli"    TYPE "C" LEN  10 DEC 0 OF oDbf     
      FIELD NAME "lRemesa"    TYPE "L" LEN   1 DEC 0 OF oDbf     
      FIELD NAME "cNumMtr"    TYPE "C" LEN  15 DEC 0 OF oDbf

      INDEX TO ( cFileName ) TAG "nNumFac"   ON "cSerie + Str( nNumFac ) + cSufFac + Str( nNumRec ) + cTipRec"          NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "cCodCli"   ON "cCodCli"                                                               NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "cNomCli"   ON "cNomCli"                                                               NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "lCodCli"   ON "cCodCli"                                                               NODELETED FOR "!lCobrado" OF oDbf
      INDEX TO ( cFileName ) TAG "dPreCob"   ON "dPreCob"                                                               NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "dFecVto"   ON "dFecVto"                                                               NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "dEntrada"  ON "dEntrada"                                                              NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "nImporte"  ON "nImporte"                                                              NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "pNumFac"   ON "cSerie + Str( nNumFac ) + cSufFac + Str( nNumRec ) + cTipRec"          NODELETED FOR "!lCobrado" OF oDbf
      INDEX TO ( cFileName ) TAG "tNumFac"   ON "cSerie + Str( nNumFac ) + cSufFac + Str( nNumRec ) + cTipRec"          NODELETED FOR "lCobrado"  OF oDbf
      INDEX TO ( cFileName ) TAG "nNumRem"   ON "Str( nNumRem ) + cSufRem"                                              NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "nNumCli"   ON "Str( nNumRem ) + cSufRem + cCodCli"                                    NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "cCtaRem"   ON "cCtaRem"                                                               NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "cCodAge"   ON "cCodAge"                                                               NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "nNumCob"   ON "Str( nNumCob ) + cSufCob"                                              NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "cTurRec"   ON "cTurRec + cSufFac + cCodCaj"                                           NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "fNumFac"   ON "cSerie + Str( nNumFac ) + cSufFac + Str( nNumRec ) + cTipRec"          NODELETED FOR "Empty( cTipRec )"  OF oDbf
      INDEX TO ( cFileName ) TAG "rNumFac"   ON "cSerie + Str( nNumFac ) + cSufFac + Str( nNumRec ) + cTipRec"          NODELETED FOR "!Empty( cTipRec )" OF oDbf
      INDEX TO ( cFileName ) TAG "cRecDec"   ON "cRecDev"                                                               NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "lCtaBnc"   ON "cEntEmp + cSucEmp + cDigEmp + cCtaEmp"                                 NODELETED FOR "lCobrado" OF oDbf
      INDEX TO ( cFileName ) TAG "cNumMtr"   ON "cNumMtr"                                                               NODELETED OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//---------------------------------------------------------------------------//

METHOD Activate()

   local oRotor

   if nAnd( ::nLevel, 1 ) == 0

      /*
      Cerramos todas las ventanas----------------------------------------------
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

      DEFINE BTNSHELL RESOURCE "BmpExptar" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::SaveModelo() ) ;
         TOOLTIP  "E(x)portar" ;
         HOTKEY   "X";
         LEVEL    4

      DEFINE BTNSHELL RESOURCE "BmpConta" OF ::oWndBrw ;
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

      ::oWndBrw:Activate( , , , , , , , , , , , , , , , , {|| ::CloseFiles() } )

   else

      msgStop( "Acceso no permitido." )

   end if

RETURN NIL

//----------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive )

   local lOpen          := .t.
   local oError
   local oBlock

   DEFAULT lExclusive   := .f.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::DefineFiles()
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

      DATABASE NEW ::oDbfDet  FILE "FACCLIP.DBF" PATH ( ::cPath )    VIA ( cDriver() ) SHARED INDEX "FACCLIP.CDX"
      ::oDbfDet:OrdSetFocus( "nNumRem" )

      ::oFacCliT        := TDataCenter():oFacCliT()

      DATABASE NEW ::oFacCliL FILE "FACCLIL.DBF" PATH ( ::cPath )    VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

      DATABASE NEW ::oAntCliT FILE "AntCliT.DBF" PATH ( ::cPath )    VIA ( cDriver() ) SHARED INDEX "AntCliT.CDX"

      DATABASE NEW ::oClientes FILE "CLIENT.DBF" PATH ( cPatCli() )  VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

      DATABASE NEW ::oIva     FILE "TIVA.DBF"    PATH ( cPatDat() )  VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

      DATABASE NEW ::oDivisas FILE "DIVISAS.DBF" PATH ( cPatDat() )  VIA ( cDriver() ) SHARED INDEX "DIVISAS.CDX"

      DATABASE NEW ::oDbfCnt  FILE "nCount.Dbf"  PATH ( cPatEmp() )  VIA ( cDriver() ) SHARED INDEX "nCount.Cdx"

      ::oCliBnc         := TDataCenter():oCliBnc()

      ::cPorDiv         := cPorDiv( cDivEmp(), ::oDivisas:cAlias ) // Picture de la divisa redondeada

      ::oBandera        := TBandera():New()

      ::oCtaRem         := TCtaRem():Create( cPatCli() )
      ::oCtaRem:OpenFiles()

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos de remesas de clientes" )

      ::CloseFiles()

      lOpen             := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD OpenService( lExclusive, cPath )

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lExclusive   := .f.
   DEFAULT cPath        := ::cPath

   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos de remesas de clientes" )

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

   if ::oCliBnc != nil .and. ::oCliBnc:Used()
      ::oCliBnc:End()
   end if 

   ::oDbf         := nil
   ::oDbfDet      := nil
   ::oDivisas     := nil
   ::oDbfCnt      := nil
   ::oClientes    := nil
   ::oDbfDet      := nil
   ::oCtaRem      := nil
   ::oCliBnc      := nil

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

   ::oDbf         := nil

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD Resource( nMode )

   local oDlg
   local oGet     := Array( 3 )
   local oSay
   local cSay     := ::oCtaRem:cRetCtaRem( ::oDbf:cCodRem )
   local oBmpDiv
   local oBtnImportar
   local oBmpGeneral

   DEFINE DIALOG oDlg RESOURCE "RemCli" TITLE LblTitle( nMode ) + "remesas de recibos a clientes"

      REDEFINE BITMAP oBmpGeneral ;
         ID       990 ;
         RESOURCE "Remesas_bancarias_48_alpha" ;
         TRANSPARENT ;
         OF       oDlg

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

      REDEFINE CHECKBOX ::oExportado ;
         VAR      ::oDbf:lExport ;
         ID       200 ;
         ON CHANGE( ::ChangeExport() ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oFecExp VAR ::oDbf:dExport ;
         ID       201 ;
         SPINNER ;
         WHEN     ( ::oDbf:lExport .and. nMode != ZOOM_MODE ) ;
         OF       oDlg

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

      REDEFINE GET oGet[ 2 ] ;
         VAR      ::oDbf:cCodDiv ;
         UPDATE ;
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

      REDEFINE GET oGet[3] ;
         VAR      ::oDbf:nVdvDiv ;
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
      Botones de acceso________________________________________________________
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
         ACTION   ( ::ImportResource( nMode ) )

      /*
      Recibos__________________________________________________________________
      */

      ::oBrwDet               := IXBrowse():New( oDlg )

      ::oBrwDet:bClrSel       := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrwDet:bClrSelFocus  := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oBrwDet:nMarqueeStyle := 6
      ::oBrwDet:cName         := "Remesas.Lineas"
      ::oBrwDet:lFooter       := .t.

      ::oBrwDet:SetoDbf( ::oDbfVir )

      with object ( ::oBrwDet:AddCol() )
         :cHeader          := "Número"
         :bEditValue       := {|| ::oDbfVir:cSerie + "/" + Alltrim( Str( ::oDbfVir:nNumFac ) ) + "-" + AllTrim( Str( ::oDbfVir:nNumRec ) ) }
         :nWidth           := 90
      end with

      with object ( ::oBrwDet:AddCol() )
         :cHeader          := "Delegción"
         :bEditValue       := {|| ::oDbfVir:cSufFac }
         :nWidth           := 40
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
         :nWidth           := 220
      end with

      with object ( ::oBrwDet:AddCol() )
         :cHeader          := "Importe"
         :bEditValue       := {|| nTotRecCli( ::oDbfVir, ::oDivisas:cAlias, ::oDbf:cCodDiv, .t. ) }
         :nWidth           := 100
         :bFooter          := {|| ::nTotRemVir( .t. ) }
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :nFootStrAlign    := 1
      end with

      with object ( ::oBrwDet:AddCol() )
         :cHeader          := "Div."
         :bEditValue       := {|| cSimDiv( ::oDbfVir:cDivPgo, ::oDivisas:cAlias ) }
         :nWidth           := 20
      end with

      ::oBrwDet:CreateFromResource( 150 )

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
   oBmpGeneral:End()

   /*
   Guardamos los datos del browse
   */

   ::oBrwDet:CloseData()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD ImportResource( nMode )

   local oDlg

   DEFINE DIALOG oDlg RESOURCE "ImpRemCli"

      REDEFINE GET ::dExpedicionIni UPDATE ;
         ID       100;
         SPINNER ;
         OF       oDlg

      REDEFINE GET ::dExpedicionFin UPDATE ;
         ID       110 ;
         SPINNER ;
         OF       oDlg

      REDEFINE GET ::dVencimientoIni UPDATE ;
         ID       120;
         SPINNER ;
         OF       oDlg

      REDEFINE GET ::dVencimeintoFin UPDATE ;
         ID       130 ;
         SPINNER ;
         OF       oDlg

      ::oMeter    := TMeter():ReDefine( 140, { | u | if( pCount() == 0, ::nMeter, ::nMeter := u ) }, 140, oDlg, .f., , , .t., rgb( 255,255,255 ), , rgb( 128,255,0 ) )

      /*
      Botones de acceso________________________________________________________
      */

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( ::GetRecCli( oDlg, nMode )  )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:End() )

   oDlg:Activate( , , , .t. )

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
         ::oDbfDet:lRemesa       := .t.

         if Empty( ::oDbfDet:cEntEmp ) .or.;
            Empty( ::oDbfDet:cSucEmp ) .or.;
            Empty( ::oDbfDet:cDigEmp ) .or.;
            Empty( ::oDbfDet:cCtaEmp )

            ::oDbfDet:cBncEmp    := oRetFld( ::oDbf:cCodRem, ::oCtaRem:oDbf, "cBanco" )
            ::oDbfDet:cEntEmp    := oRetFld( ::oDbf:cCodRem, ::oCtaRem:oDbf, "cEntBan" )
            ::oDbfDet:cSucEmp    := oRetFld( ::oDbf:cCodRem, ::oCtaRem:oDbf, "cAgcBan" )
            ::oDbfDet:cDigEmp    := oRetFld( ::oDbf:cCodRem, ::oCtaRem:oDbf, "cDgcBan" )
            ::oDbfDet:cCtaEmp    := oRetFld( ::oDbf:cCodRem, ::oCtaRem:oDbf, "cCtaBan" )

         end if

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

METHOD SaveModelo()

   local oDlg
   local oGet
   local cTitle
   local bAction
   local oBmpGeneral

   if ::oDbf:Recno() == 0
      RETURN ( Self )
   end if

   if ::oDbf:nTipRem == 2
      cTitle      := "Remesa de recibos a soporte magnéticos según norma 58"
      bAction     := {|| ::InitMod58( oDlg ) }
   else
      cTitle      := "Remesa de recibos a soporte magnéticos según norma 19"
      bAction     := {|| ::InitSepa19( oDlg ) }
   end if

   DEFINE DIALOG oDlg RESOURCE "Modelo19" TITLE cTitle

      REDEFINE BITMAP oBmpGeneral ;
         ID       500 ;
         RESOURCE "Courthouse_Alpla_48" ;
         TRANSPARENT ;
         OF       oDlg

      REDEFINE CHECKBOX ::lUsarVencimiento ;
         ID       140 ;
         WHEN     ( ::oDbf:nTipRem != 2 ) ;
         OF       oDlg

      REDEFINE GET ::dVencimiento ;
         ID       120 ;
         WHEN     ( !::lUsarVencimiento ) ;
         OF       oDlg ;
         SPINNER

      REDEFINE GET oGet ;
         VAR      ::cFicheroExportacion ;
         ID       130 ;
         BITMAP   "FOLDER" ;
         ON HELP  ( oGet:cText( cGetFile( "*.txt", "Selección de fichero" ) ) ) ;
         OF       oDlg

      REDEFINE CHECKBOX ::lAgruparRecibos ;
         ID       100 ;
         WHEN     ( ::oDbf:nTipRem != 2 ) ;
         OF       oDlg

      REDEFINE BUTTON   ;
         ID       550 ;
         OF       oDlg ;
         ACTION   ( oDlg:Disable(), Eval( bAction ), oDlg:Enable(), oDlg:End( IDOK ) )

      REDEFINE BUTTON   ;
         ID       551 ;
         OF       oDlg ;
         ACTION   ( oDlg:End() )

      oDlg:AddFastKey( VK_F5, bAction )

   ACTIVATE DIALOG oDlg CENTER

   /*
   Marcamos la remesa para saber que la hemos exportado------------------------
   */

   if ( oDlg:nResult == IDOK )

      ::oDbf:Load()

      ::oDbf:lExport := .t.
      ::oDbf:dExport := GetSysDate()

      ::oDbf:Save()

   end if

   if !Empty( oBmpGeneral )
      oBmpGeneral:End()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD InitMod58( oDlg )

   local oBlock
   local oError
   local nHandle
   local cBuffer
   local cHeader
   local cBanCli
   local nImpRec
   local cCodCli
   local cPreMon
   local nTotImp  := 0
   local nTotRec  := 0
   local nTotLin  := 0

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   cPreMon        := if( cDivEmp() == "EUR", "5", "0" )

   if file( Rtrim( ::cFicheroExportacion ) )
      fErase( Rtrim( ::cFicheroExportacion ) )
   end if

   nHandle        := fCreate( Rtrim( ::cFicheroExportacion ) )

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
      cBuffer  += "7"                        // Constante para el modelo 58
      cBuffer  += "0"                        // Numero de linea
      cBuffer  += cHeader                    // Cabecera
      cBuffer  += Left( Dtoc( ::oDbf:dFecRem ), 2) + SubStr( Dtoc( ::oDbf:dFecRem ), 4, 2 ) + Right( Dtoc( ::oDbf:dFecRem ), 2 )
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
      cBuffer  += "7"                        // Constante para el modelo 19
      cBuffer  += "0"                        // Numero de linea
      cBuffer  += cHeader                    // Cabecera
      cBuffer  += Left( Dtoc( ::oDbf:dFecRem ), 2) + SubStr( Dtoc( ::oDbf:dFecRem ), 4, 2 ) + Right( Dtoc( ::oDbf:dFecRem ), 2 )
      cBuffer  += Left( Dtoc( ::dVencimiento ), 2) + SubStr( Dtoc( ::dVencimiento ), 4, 2 ) + Right( Dtoc( ::dVencimiento ), 2 )
      cBuffer  += ::oCtaRem:oDbf:cNomPre     // Nombre de la empresa igual a del presentador
      cBuffer  += ::oCtaRem:oDbf:cEntBan     // Entidad
      cBuffer  += ::oCtaRem:oDbf:cAgcBan     // Agencia
      cBuffer  += ::oCtaRem:oDbf:cDgcBan     // Digito de control
      cBuffer  += ::oCtaRem:oDbf:cCtaBan     // Cuenta
      cBuffer  += Space( 8 )                 // Libre
      cBuffer  += "06"                       // Para la 58
      cBuffer  += Space( 10 )                // Libre
      cBuffer  += Space( 40 )                // Libre
      cBuffer  += Space( 2 )                 // Libre
      cBuffer  += ::oCtaRem:oDbf:cCodIne     // Codigo del INE
      cBuffer  := Padr( cBuffer, 162 )       // Para q llege a los 162 caracteres
      cBuffer  += CRLF

      fWrite( nHandle, cBuffer )
      nTotLin  ++

      /*
      Traspaso de recibos------------------------------------------------------
      */

      if ::oDbfDet:Seek( Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem )

         while Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem == Str( ::oDbfDet:nNumRem ) + ::oDbfDet:cSufRem .and. !::oDbfDet:eof()

            cCodCli           := ::oDbfDet:cCodCli

            if ::oClientes:Seek( cCodCli )

               cBanCli        := ::oDbfDet:cEntCli + ::oDbfDet:cSucCli + ::oDbfDet:cDigCli + ::oDbfDet:cCtaCli

               if Empty( cBanCli )
                  cBanCli     := cClientCuenta( cCodCli )
               end if

               if !Empty( cBanCli )

                  nImpRec     := nTotRecCli( ::oDbfDet, ::oDivisas:cAlias, cDivEmp() )

                  nTotImp     += nImpRec
                  nTotRec     ++

                  cBuffer     := cPreMon
                  cBuffer     += "6"                        // Constante para las lineas de recibos
                  cBuffer     += "7"                        // Constante para el modelo 58
                  cBuffer     += "0"                        // Numero de linea
                  cBuffer     += cHeader                    // Cabecera
                  cBuffer     += Right( AllTrim( ::oDbfDet:cCodCli ), 6 )  // Codigo del cliente
                  cBuffer     += Space( 6 )
                  cBuffer     += Left( ::oClientes:Titulo, 40 )   // Nombre del cliente
                  cBuffer     += Padr( cBanCli, 20 )              // Banco del cliente
                  cBuffer     += cToCeros( nImpRec, ::cPorDiv )   // Importe del recibo
                  cBuffer     += Space( 6 )                       // Código para devoluciones
                  cBuffer     += ::oDbfDet:cSerie + cToCeros( ::oDbfDet:nNumFac, "999999999", 9 ) // Numero del recibo
                  cBuffer     += Padr( "Recibo Nº" + ::oDbfDet:cSerie + "/" + AllTrim( Str( ::oDbfDet:nNumFac ) ) + "/" +  Alltrim( ::oDbfDet:cSufFac ) + "-" + Alltrim( Str( ::oDbfDet:nNumRec ) ) + " de " + Dtoc( ::oDbfDet:dEntrada ), 40 )
                  cBuffer     += Left( Dtoc( ::oDbfDet:dFecVto ), 2 ) + SubStr( Dtoc( ::oDbfDet:dFecVto ), 4, 2 ) + Right( Dtoc( ::oDbfDet:dFecVto ), 2 )
                  cBuffer     := Padr( cBuffer, 162 )       // Para q llege a los 162 caracteres
                  cBuffer     += CRLF

                  fWrite( nHandle, cBuffer )
                  nTotLin     ++

                  /*
                  Detalles de la factura------------------------------------------
                  */

                  cBuffer     := cPreMon
                  cBuffer     += "6"                        // Constante para las lineas de recibos
                  cBuffer     += "7"                        // Constante para el modelo 58
                  cBuffer     += "1"                        // Numero de linea
                  cBuffer     += cHeader                    // Cabecera
                  cBuffer     += Right( AllTrim( ::oDbfDet:cCodCli ), 6 )  // Codigo del cliente
                  cBuffer     += Space( 6 )
                  cBuffer     += "Factura Nº" + ::oDbfDet:cSerie + "/" + AllTrim( Str( ::oDbfDet:nNumFac ) ) + "/" +  ::oDbfDet:cSufFac + " de " + Dtoc( ::oDbfDet:dEntrada )
                  cBuffer     += Space( 2 )                 // Para q llege a los 162 caracteres
                  cBuffer     := Padr( cBuffer, 162 )       // Para q llege a los 162 caracteres
                  cBuffer     += CRLF

                  fWrite( nHandle, cBuffer )
                  nTotLin     ++

                  /*
                  Detalles del cliente--------------------------------------------
                  */

                  cBuffer     := cPreMon
                  cBuffer     += "6"                                       // Constante para las lineas de recibos
                  cBuffer     += "7"                                       // Constante para el modelo 58
                  cBuffer     += "2"                                       // Numero de linea
                  cBuffer     += cHeader                                   // Cabecera
                  cBuffer     += Right( AllTrim( ::oDbfDet:cCodCli ), 6 )  // Codigo del cliente
                  cBuffer     += Space( 6 )
                  cBuffer     += Left( ::oClientes:Titulo, 40 )            // Nombre del cliente
                  cBuffer     += Left( ::oClientes:Domicilio, 40 )         // Domicilio del cliente
                  cBuffer     += ::oClientes:CodPostal                     // Codigo postal
                  cBuffer     += Space( 1 )
                  cBuffer     += ::oClientes:Poblacion                     // Población
                  cBuffer     := Padr( cBuffer, 162 )                      // Para q llege a los 162 caracteres
                  cBuffer     += CRLF

                  fWrite( nHandle, cBuffer )
                  nTotLin     ++

               else

                  MsgStop( "No se puede localizar una cuenta bancaria valida, para el cliente " + Rtrim( cCodCli ) + "." )

               end if

            else

               MsgStop( "Cliente " + Rtrim( cCodCli ) + " no encontrado." )

            end if

            ::oDbfDet:Skip()

         end while

      end if

      /*
      Total de presentador-----------------------------------------------------
      */

      cBuffer  := cPreMon
      cBuffer  += "8"                              // Constante para las lineas de recibos
      cBuffer  += "7"                              // Constante para el modelo 58
      cBuffer  += "0"                              // Numero de linea
      cBuffer  += cHeader                          // Cabecera
      cBuffer  += Space( 72 )
      cBuffer  += cToCeros( nTotImp, ::cPorDiv )   // Importe total del Recibos
      cBuffer  += Space( 6 )
      cBuffer  += cToCeros( nTotRec )              // Numero de recibos por ordenante
      cBuffer  += cToCeros( nTotLin )              // Numero Total de lineas
      cBuffer  := Padr( cBuffer, 162 )             // Para q llege a los 162 caracteres
      cBuffer  += CRLF

      fWrite( nHandle, cBuffer )
      nTotLin  ++

      /*
      Total de archivo---------------------------------------------------------
      */

      cBuffer  := cPreMon
      cBuffer  += "9"                              // Constante para las lineas de recibos
      cBuffer  += "7"                              // Constante para el modelo 19
      cBuffer  += "0"                              // Numero de linea
      cBuffer  += cHeader                          // Cabecera
      cBuffer  += Space( 52 )
      cBuffer  += "0001"                           // Modificación para BCH internet
      cBuffer  += Space( 16 )
      cBuffer  += cToCeros( nTotImp, ::cPorDiv )   // Importe total del Recibos
      cBuffer  += Space( 6 )
      cBuffer  += cToCeros( nTotRec )              // Numero de recibos por ordenante
      cBuffer  += cToCeros( ++nTotLin )            // Numero Total de lineas del fichero
      cBuffer  := Padr( cBuffer, 162 )             // Para q llege a los 162 caracteres
      cBuffer  += CRLF
      fWrite( nHandle, cBuffer )

   end if

   if ApoloMsgNoYes( "Proceso de exportación realizado con éxito" + CRLF + ;
                     "¿ Desea abrir el fichero resultante ?", "Elija una opción." )
      ShellExecute( 0, "open", ::cFicheroExportacion, , , 1 )
   end if

   RECOVER USING oError

      msgStop( "Imposible exportar  filtros " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !Empty( nHandle )
      fClose( nHandle )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD GetRecCli( oDlg, nMode )

   local n           := 0
   local cCodRem     := ::oDbf:cCodRem

   if Empty( cCodRem )
      return .t.
   end if

   oDlg:Disable()

   ::oMeter:nTotal   := ::oDbfDet:OrdKeyCount()

   if nMode == APPD_MODE

      ::oDbfDet:OrdSetFocus( "cCtaRem" )

      if ::oDbfDet:Seek( cCodRem )

         while ::oDbfDet:cCtaRem == cCodRem .and. !::oDbfDet:Eof()

            if !::lNowExist( ::oDbfDet:cSerie + Str( ::oDbfDet:nNumFac ) + ::oDbfDet:cSufFac + Str( ::oDbfDet:nNumRec ) )  .and.;
               !::oDbfDet:lCobrado                                                                                         .and.;
               !Empty( ::oDbfDet:dPreCob )                                                                                 .and.;
               Empty( ::oDbfDet:nNumRem )                                                                                  .and.;
               ::oDbfDet:dPreCob >= ::dExpedicionIni                                                                       .and.;
               ::oDbfDet:dPreCob <= ::dExpedicionFin                                                                       .and.;
               ::oDbfDet:dFecVto >= ::dVencimientoIni                                                                      .and.;
               ::oDbfDet:dFecVto <= ::dVencimeintoFin                                                                      .and.;
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

      else

         MsgStop( "No se encuentran recibos, en la cuenta " + cCodRem )

      end if

      ::oMeter:Set( 0 )
      ::oMeter:Refresh()

      ::oDbfDet:OrdSetFocus( "nNumRem" )

      ::oDbfVir:GoTop()

      ::oBrwDet:Refresh()

   end if

   oDlg:Enable()
   oDlg:End()

   MsgInfo( Ltrim( Trans( n, "999999999" ) ) + " recibos importados, en la cuenta " + cCodRem )

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

      if ::lNowExist( cCodRec )
         msgStop( "Recibo ya incluido en remesa." )
         return ( .f. )
      end if

      if ::oDbfDet:SeekInOrd( cCodRec, "nNumFac" )

         if ::oDbfDet:lCobrado
            msgStop( "Recibo ya cobrado." )
            return ( .f. )
         end if

         if !Empty( ::oDbfDet:nNumRem )
            msgStop( "Recibo ya remesado." )
            return ( .f. )
         end if

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

   if oUser():lNotConfirmDelete() .or. ApoloMsgNoYes("¿ Desea eliminar el registro en curso ?", "Confirme supresión" )

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
   cImporte          := StrTran( Right( cImporte, nLen ), " ", "0" )

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
      if !ApoloMsgNoYes(  "Remesa : " + ::cNumRem() + " contabilizada." + CRLF + "¿ Desea contabilizarla de nuevo ?" )
         return .f.
      end if
   end if

   if !::lChkSelect .AND. !ChkRuta( cRutCnt() )
      ::oTreeSelect:Add( "Remesa : " + ::cNumRem() + " ruta no valida.", 0 )
      lErrorFound    := .t.
   end if

   /*
   Seleccionamos las empresa dependiendo de la serie de factura
	--------------------------------------------------------------------------
	*/

   if empty( cCodEmp ) .AND. !::lChkSelect
      ::oTreeSelect:Add( "Remesa : " + ::cNumRem() + " no se definierón empresas asociadas.", 0 )
      lErrorFound          := .t.
   end if

	/*
   Chequeamos los valores de cuentas de banco
	--------------------------------------------------------------------------
	*/

   if !::lChkSelect .and. !ChkSubCta( cRuta, cCodEmp, cCtaCon, , .f., .f. )
      ::oTreeSelect:Add( "Remesa : " + ::cNumRem() + " subcuenta " + cCtaCon + " no encontada.", 0 )
      lErrorFound          := .t.
   end if

	/*
	Estudio de los Articulos de una factura
	--------------------------------------------------------------------------
	*/


   if !ChkSubCta( cRuta, cCodEmp, cCtaCon, , .f., .f. )
      ::oTreeSelect:Add( "Cuenta : " + rtrim( cCtaCon ) + " banco no existe.", 0 )
      lErrorFound          := .t.
   end if

   if ::oDbf:nTipRem == 2 .and. !ChkSubCta( cRuta, cCodEmp, cCtaBcoDto, , .f., .f. )
      ::oTreeSelect:Add( "Cuenta : " + rtrim( cCtaBcoDto ) + " de descuento banco no existe.", 0 )
      lErrorFound          := .t.
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
            ::oTreeSelect:Add( "Cliente : " + Rtrim( ::oClientes:Titulo ) + " cuenta descuento no existe.", 0 )
            lErrorFound    := .t.
         end if

         ::oDbfDet:Skip()

      end while

   else

      ::oTreeSelect:Add( "Remesa : " + ::cNumRem() + " remesa sin recibos.", 0 )

      lErrorFound          := .t.

   end if

   /*
   Comporbamos fechas
   ----------------------------------------------------------------------------
   */

   if Empty( ::oDbf:dConta )
      ::oTreeSelect:Add( "Remesa : " + ::cNumRem() + " sin fecha de contabilización", 0 )
      lErrorFound          := .t.
   end if

   if !ChkFecha( , , ::oDbf:dConta, .f., ::oTreeSelect )
      lErrorFound          := .t.
   end if

	/*
   Realización de Asientos
	--------------------------------------------------------------------------
   */

   if OpenDiario( , cCodEmp )
      nAsiento             := RetLastAsi()
   else
      ::oTreeSelect:Add( "Remesa : " + ::cNumRem() + " imposible abrir ficheros.", 0 )
      Return .f.
   end if

   if ::oDbf:nTipRem == 2

   aadd( aSimula, MkAsiento(  nAsiento, ;
                              ::oDbf:cCodDiv,;
                              ::oDbf:dConta,;
                              cCtaBcoDto,;
                              ,;
                              ::nTotRem( .f. ),;
                              "Pago remesa",;
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
                              "Pago remesa",;
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
                                    "Pago remesa " + AllTrim( ::oDbfDet:cSerie + "/" + Str( ::oDbfDet:nNumFac ) + "/" + ::oDbfDet:cSufFac ),;
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
                                       "Pago remesa " + AllTrim( ::oDbfDet:cSerie + "/" + Str( ::oDbfDet:nNumFac ) + "/" + ::oDbfDet:cSufFac ),;
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
                                 "Pago remesa",;
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

      ::oTreeSelect:Add( "Remesa : " + ::cNumRem() + " asiento generado num. " + Alltrim( Str( nAsiento ) ), 0 )

   else

      msgTblCon( aSimula, ::oDbf:cCodDiv, ::oDivisas:cAlias, !lErrorFound, ::cNumRem(), {|| aWriteAsiento( aSimula, ::oDbf:cCodDiv, .t., ::oTreeSelect, ::cNumRem(), nAsiento ), ::ChangeConta( .t. ) } )

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
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD InitMod19( oDlg )

   local oBlock
   local oError
   local nHandle
   local cBuffer
   local cHeader
   local cBanCli
   local cCodCli
   local cPreMon
   local dOldVto
   local dFecVto
   local nTotFec     := 0
   local nImpRec     := 0
   local nTotImp     := 0
   local nTotRec     := 0
   local nTotLin     := 0
   local nTotPre     := 0
   local nLinRec     := 0
   local nRecFec     := 0

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   cPreMon           := if( cDivEmp() == "EUR", "5", "0" )

   if file( Rtrim( ::cFicheroExportacion ) )
      fErase( Rtrim( ::cFicheroExportacion ) )
   end if

   if ::lAgruparRecibos
      ::oDbfDet:OrdSetFocus( "nNumCli" )
   end if

   nHandle           := fCreate( Rtrim( ::cFicheroExportacion ) )

   if nHandle > 0

      /*
      Cabecera de registro--------------------------------------------------------
      */

      cHeader        := ::oCtaRem:oDbf:cNifPre     // Nif del presentador
      cHeader        += ::oCtaRem:oDbf:cSufCta     // SubClave

      /*
      Datos del presentador-------------------------------------------------------
      */

      cBuffer        := cPreMon
      cBuffer        += "1"
      cBuffer        += "8"                                 // Constante para el modelo 19
      cBuffer        += "0"                                 // Numero de linea
      cBuffer        += cHeader                             // Cabecera
      cBuffer        += Left( Dtoc( ::oDbf:dFecRem ), 2) + SubStr( Dtoc( ::oDbf:dFecRem ), 4, 2 ) + Right( Dtoc( ::oDbf:dFecRem ), 2 )
      cBuffer        += Space( 6 )                          // Libre
      cBuffer        += Left( ::oCtaRem:oDbf:cNomPre, 40 )  // Nombre
      cBuffer        += Space( 20 )                         // Libre
      cBuffer        += ::oCtaRem:oDbf:cEntPre              // Entidad
      cBuffer        += ::oCtaRem:oDbf:cAgcPre              // Agencia
      cBuffer        := Padr( cBuffer, 162 )                // Para q llege a los 162 caracteres
      cBuffer        += CRLF

      fWrite( nHandle, cBuffer )
      nTotLin++

      /*
      Traspaso de recibos------------------------------------------------------
      */

      if ::oDbfDet:Seek( Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem )

         while Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem == Str( ::oDbfDet:nNumRem ) + ::oDbfDet:cSufRem .and. !::oDbfDet:eof()

            cCodCli           := ::oDbfDet:cCodCli

            if ::oClientes:Seek( cCodCli )

               // Fecha de vencimiento-----------------------------------------

               if Empty( dFecVto )
                  if ::lUsarVencimiento
                     dFecVto  := ::oDbfDet:dFecVto // Left( Dtoc( ::oDbfDet:dFecVto ), 2) + SubStr( Dtoc( ::oDbfDet:dFecVto ), 4, 2 ) + Right( Dtoc( ::oDbfDet:dFecVto ), 2 )
                  else
                     dFecVto  := ::dVencimiento         // Left( Dtoc( ::dVencimiento ), 2) + SubStr( Dtoc( ::dVencimiento ), 4, 2 ) + Right( Dtoc( ::dVencimiento ), 2 )
                  end if
               end if

               // Banco de cliente---------------------------------------------

               cBanCli        := ::oDbfDet:cEntCli + ::oDbfDet:cSucCli + ::oDbfDet:cDigCli + ::oDbfDet:cCtaCli

               if Empty( cBanCli ) .or. Len( AllTrim( cBanCli ) ) != 20
                  cBanCli     := cClientCuenta( cCodCli )
               end if

               if !Empty( cBanCli )

                  if ( dFecVto != dOldVto )

                     nLinRec  := 1
                     nTotPre  ++

                     /*
                     Datos del propietario-------------------------------------------------------
                     */

                     cBuffer     := cPreMon
                     cBuffer     += "3"                        // Cte para la empresa
                     cBuffer     += "8"                        // Constante para el modelo 19
                     cBuffer     += "0"                        // Numero de linea
                     cBuffer     += cHeader                    // Cabecera
                     cBuffer     += Left( Dtoc( ::oDbf:dFecRem ), 2) + SubStr( Dtoc( ::oDbf:dFecRem ), 4, 2 ) + Right( Dtoc( ::oDbf:dFecRem ), 2 )
                     cBuffer     += Left( Dtoc( dFecVto ), 2) + SubStr( Dtoc( dFecVto ), 4, 2 ) + Right( Dtoc( dFecVto ), 2 )
                     cBuffer     += ::oCtaRem:oDbf:cNomPre     // Nombre de la empresa igual a del presentador
                     cBuffer     += ::oCtaRem:oDbf:cEntBan     // Entidad
                     cBuffer     += ::oCtaRem:oDbf:cAgcBan     // Agencia
                     cBuffer     += ::oCtaRem:oDbf:cDgcBan     // Digito de control
                     cBuffer     += ::oCtaRem:oDbf:cCtaBan     // Cuenta
                     cBuffer     += Space( 8 )                 // Libre
                     cBuffer     += "01"                       // Para la 19
                     cBuffer     := Padr( cBuffer, 162 )       // Para q llege a los 162 caracteres
                     cBuffer     += CRLF

                     fWrite( nHandle, cBuffer )

                     nTotLin++
                     nLinRec++

                  end if

                  /*
                  Detalle recibos--------------------------------------------------------
                  */

                  if ::lAgruparRecibos
                     nImpRec     := ::nAllRecCli( cCodCli )
                  else
                     nImpRec     := nTotRecCli( ::oDbfDet, ::oDivisas:cAlias, cDivEmp() )
                  end if

                  nTotImp        += nImpRec
                  nTotFec        += nImpRec

                  nRecFec++
                  nTotRec++

                  cBuffer        := cPreMon
                  cBuffer        += "6"                                       // Constante para las lineas de recibos
                  cBuffer        += "8"                                       // Constante para el modelo 19
                  cBuffer        += "0"                                       // Numero de linea
                  cBuffer        += cHeader                                   // Cabecera
                  cBuffer        += Right( AllTrim( ::oDbfDet:cCodCli ), 6 )  // Codigo del cliente
                  cBuffer        += Space( 6 )
                  cBuffer        += Left( ::oClientes:Titulo, 40 )            // Nombre del cliente
                  cBuffer        += Padr( cBanCli, 20 )                       // Banco del cliente
                  cBuffer        += cToCeros( nImpRec, ::cPorDiv )            // Importe del recibo
                  cBuffer        += Space( 6 )
                  cBuffer        += Left( AllTrim( ::oDbfDet:cSerie ) + "/" + AllTrim( Str( ::oDbfDet:nNumFac ) ) + if( Empty( ::oDbfDet:cSufFac ), "", "/" ) + AllTrim( ::oDbfDet:cSufFac ) + "-" + AllTrim( Str( ::oDbfDet:nNumRec ) ), 40 ) // Numero del recibo
                  cBuffer        := Padr( cBuffer, 162 )                      // Para q llege a los 162 caracteres
                  cBuffer        += CRLF

                  fWrite( nHandle, cBuffer )

                  nTotLin++
                  nLinRec++

                  /*
                  Detalles de la factura------------------------------------------
                  */

                  cBuffer        := cPreMon
                  cBuffer        += "6"                        // Constante para las lineas de recibos
                  cBuffer        += "8"                        // Constante para el modelo 19
                  cBuffer        += "1"                        // Numero de linea
                  cBuffer        += cHeader                    // Cabecera
                  cBuffer        += Right( AllTrim( ::oDbfDet:cCodCli ), 6 )  // Codigo del cliente
                  cBuffer        += Space( 6 )
                  cBuffer        += "Factura Nº" + ::oDbfDet:cSerie + "/" + AllTrim( Str( ::oDbfDet:nNumFac ) ) + "/" +  ::oDbfDet:cSufFac + " de " + Dtoc( ::oDbfDet:dEntrada )
                  cBuffer        += Space( 2 )                 // Para q llege a los 162 caracteres
                  cBuffer        := Padr( cBuffer, 162 )       // Para q llege a los 162 caracteres
                  cBuffer        += CRLF

                  fWrite( nHandle, cBuffer )

                  nTotLin++
                  nLinRec++

                  /*
                  Detalles del cliente--------------------------------------------
                  */

                  cBuffer        := cPreMon
                  cBuffer        += "6"                              // Constante para las lineas de recibos
                  cBuffer        += "8"                              // Constante para el modelo 19
                  cBuffer        += "2"                              // Numero de linea
                  cBuffer        += cHeader                          // Cabecera
                  cBuffer        += Right( AllTrim( ::oDbfDet:cCodCli ), 6 )  // Codigo del cliente
                  cBuffer        += Space( 6 )
                  cBuffer        += Left( ::oClientes:Titulo, 40 )   // Nombre del cliente
                  cBuffer        += Left( ::oClientes:Domicilio, 40 )// Domicilio del cliente
                  cBuffer        += ::oClientes:CodPostal            // Codigo postal
                  cBuffer        += Space( 1 )
                  cBuffer        += ::oClientes:Poblacion            // Población
                  cBuffer        := Padr( cBuffer, 162 )             // Para q llege a los 162 caracteres
                  cBuffer        += CRLF

                  fWrite( nHandle, cBuffer )

                  nTotLin++
                  nLinRec++

               else

                  MsgStop( "No se puede localizar una cuenta bancaria valida, para el cliente " + Rtrim( cCodCli ) + "." )

               end if

            else

               MsgStop( "Cliente " + Rtrim( cCodCli ) + " no encontrado." )

            end if

            /*
            Saltamos al siguiente registro----------------------------------
            */

            dOldVto              := dFecVto

            if ::lAgruparRecibos
               while cCodCli == ::oDbfDet:cCodCli .and. !::oDbfDet:Eof()
                  ::oDbfDet:Skip()
               end while
            else
               ::oDbfDet:Skip()
            end if

            /*
            Guardamos la fecha de vencimiento-------------------------------
            */

            if ::lUsarVencimiento
               dFecVto     := ::oDbfDet:dFecVto // Left( Dtoc( ::oDbfDet:dFecVto ), 2) + SubStr( Dtoc( ::oDbfDet:dFecVto ), 4, 2 ) + Right( Dtoc( ::oDbfDet:dFecVto ), 2 )
            else
               dFecVto     := ::dVencimiento         // Left( Dtoc( ::dVencimiento ), 2) + SubStr( Dtoc( ::dVencimiento ), 4, 2 ) + Right( Dtoc( ::dVencimiento ), 2 )
            end if

            /*
            Total de presentador--------------------------------------------
            */

            if ( !Empty( cBanCli ) .and. ( dFecVto != dOldVto ) ) .or. ( Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem != Str( ::oDbfDet:nNumRem ) + ::oDbfDet:cSufRem .or. ::oDbfDet:eof() )

               cBuffer     := cPreMon
               cBuffer     += "8"                              // Constante para las lineas de recibos
               cBuffer     += "8"                              // Constante para el modelo 19
               cBuffer     += "0"                              // Numero de linea
               cBuffer     += cHeader                          // Cabecera
               cBuffer     += Space( 72 )
               cBuffer     += cToCeros( nTotFec, ::cPorDiv )   // Importe total del Recibos
               cBuffer     += Space( 6 )
               cBuffer     += cToCeros( nRecFec )              // Numero de recibos por ordenante
               cBuffer     += cToCeros( nLinRec )              // Numero Total de lineas
               cBuffer     := Padr( cBuffer, 162 )             // Para q llege a los 162 caracteres

               cBuffer     += CRLF

               nTotFec     := 0
               nLinRec     := 0
               nRecFec     := 0

               fWrite( nHandle, cBuffer )

               nTotLin++

            end if

         end while

      end if

      /*
      Total de archivo---------------------------------------------------------
      */

      cBuffer  := cPreMon
      cBuffer  += "9"                              // Constante para las lineas de recibos
      cBuffer  += "8"                              // Constante para el modelo 19
      cBuffer  += "0"                              // Numero de linea
      cBuffer  += cHeader                          // Cabecera
      cBuffer  += Space( 52 )
      cBuffer  += cToCeros( nTotPre, "9999", 4 )   // Modificación para BCH internet
      cBuffer  += Space( 16 )
      cBuffer  += cToCeros( nTotImp, ::cPorDiv )   // Importe total del Recibos
      cBuffer  += Space( 6 )
      cBuffer  += cToCeros( nTotRec )              // Numero de recibos por ordenante
      cBuffer  += cToCeros( ++nTotLin )            // Numero Total de lineas del fichero
      cBuffer  := Padr( cBuffer, 162 )             // Para q llege a los 162 caracteres
      cBuffer  += CRLF

      fWrite( nHandle, cBuffer )

   end if

   if ApoloMsgNoYes( "Proceso de exportación realizado con éxito" + CRLF + "¿ Desea abrir el fichero resultante ?", "Elija una opción." )
      ShellExecute( 0, "open", ::cFicheroExportacion, , , 1 )
   end if

   if ::lAgruparRecibos
      ::oDbfDet:OrdSetFocus( "nNumRem" )
   end if

   RECOVER USING oError

      msgStop( "Imposible exportar  filtros " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !Empty( nHandle )
      fClose( nHandle )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD InitSepa19( oDlg )

   local oBlock
   local oError
   local dOldVto
/*
   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE
*/
   if ::lAgruparRecibos
      ::oDbfDet:OrdSetFocus( "nNumCli" )
   end if

   ::dAnteriorVencimiento  := nil

   ::oCuaderno             := Cuaderno1914():New()
   ::oCuaderno:Fichero( ::cFicheroExportacion )

   // Presentador--------------------------------------------------------------

   ::InsertPresentador()

   // Recibos------------------------------------------------------------------

   if ::oDbfDet:Seek( Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem )

      while Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem == Str( ::oDbfDet:nNumRem, 9 ) + ::oDbfDet:cSufRem .and. !::oDbfDet:eof()

         if ::oClientes:Seek( ::oDbfDet:cCodCli )

            if !Empty( ::GetValidCuentaCliente() )

               // Acreedores---------------------------------------------------

               if ::lCambiaVencimiento()
                  ::InsertAcreedor()
               end if

               // Deudores-----------------------------------------------------

               ::InsertDeudor()

            else 

               MsgStop( "No se puede localizar una cuenta bancaria valida, para el cliente " + Rtrim( ::oDbfDet:cCodCli ) + "." )                

            end if

         end if 

         ::oDbfDet:Skip()
/*
         if !Empty( dOldVto )
            dOldVto     := ::FechaVencimiento()
         end if
*/
      end while

   end if

   ::oCuaderno:SerializeASCII()

   if ApoloMsgNoYes( "Proceso de exportación realizado con éxito" + CRLF + "¿ Desea abrir el fichero resultante ?", "Elija una opción." )
      ::oCuaderno:Visualizar()
   end if

   if ::lAgruparRecibos
      ::oDbfDet:OrdSetFocus( "nNumRem" )
   end if
/*
   RECOVER USING oError

      msgStop( "Imposible exportar  filtros " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )
*/
RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD InsertPresentador()

   with object ( ::oCuaderno:GetPresentador() )
      :Nombre( ::oCtaRem:oDbf:cNomPre )
      :Referencia( ::cNumRem() )            
      :Nif( ::oCtaRem:oDbf:cNifPre )
      :Entidad( ::oCtaRem:oDbf:cEntPre )
      :Oficina( ::oCtaRem:oDbf:cAgcPre )
   end with

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD InsertAcreedor()

   with object ( ::oCuaderno:InsertAcreedor() )
      :FechaCobro( Date() )
      :Nombre( ::oCtaRem:oDbf:cNomAcr )
      :Direccion( ::oCtaRem:oDbf:cDirAcr )
      :CodigoPostal( ::oCtaRem:oDbf:cPosAcr )
      :Poblacion( ::oCtaRem:oDbf:cPobAcr )
      :Provincia( ::oCtaRem:oDbf:cProAcr )
      :Pais( ::oCtaRem:oDbf:cPaiAcr )
      :Nif( ::oCtaRem:oDbf:cNifPre )
      :CuentaIBAN( ::CuentaRemesa() )   
   end with

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD InsertDeudor()

   with object ( ::oCuaderno:InsertDeudor() )
      :Referencia( "Recibo" + ::TextoDocumento() )
      :ReferenciaMandato( ::oDbfDet:cCodCli )
      :Importe( nTotRecCli( ::oDbfDet, ::oDivisas:cAlias, cDivEmp() ) )
      :EntidadBIC( ::GetBICClient() )
      :Nombre( ::oClientes:Titulo )
      :Direccion( ::oClientes:Domicilio )
      :CodigoPostal( ::oClientes:CodPostal )
      :Poblacion( ::oClientes:Poblacion )
      :Provincia( ::oClientes:Provincia )
      :Nif( ::oClientes:Provincia )
      :CuentaIBAN( ::GetValidCuentaCliente() )
      :Concepto( "Factura Nº" + ::TextoDocumento() )
   end with

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ChangeExport()

   if ::oDbf:lExport
      ::oDbf:dExport    := GetSysDate()
   else
      ::oDbf:dExport    := Ctod( "" )
   end if

   ::oFecExp:Refresh()

Return .t.

//---------------------------------------------------------------------------//
