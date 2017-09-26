#include "FiveWin.Ch"
#include "MesDbf.ch"
#include "Factu.ch" 
#include "Report.ch"

//---------------------------------------------------------------------------//

#define ENTIDAD_JURIDICA      0
#define ENTIDAD_FISICA        1
#define ENTIDAD_OTRA          2

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
   DATA  oFormaPago

   DATA  cPorDiv
      
   DATA  cFicheroExportacion
   DATA  dExpedicionIni
   DATA  dExpedicionFin
   DATA  dVencimientoIni
   DATA  dVencimeintoFin

   DATA oSerieInicio
   DATA cSerieInicio
   DATA oSerieFin
   DATA cSerieFin

   DATA oNumeroInicio
   DATA nNumeroInicio
   DATA oNumeroFin
   DATA nNumeroFin

   DATA oSufijoInicio
   DATA cSufijoInicio
   DATA oSufijoFin
   DATA cSufijoFin

   DATA oTreeIncidencias

   DATA oNotImportCeros
   DATA lNotImportCeros

   DATA oNotImportSinCuenta
   DATA lNotImportSinCuenta

   DATA oNotImportarEsperaDocumentacion
   DATA lNotImportarEsperaDocumentacion

   DATA oClienteIni
   DATA oClienteFin
   DATA cClienteIni
   DATA cClienteFin
 
   DATA oFormaPagoIni
   DATA oFormaPagoFin
   DATA cFormaPagoIni
   DATA cFormaPagoFin

   DATA nRecAnterior
   DATA cOrdenAnterior

   DATA oSer                           INIT Array( 26 )
   DATA aSer                           INIT Afill( Array( 26 ), .t. )

   DATA  oMeter            AS OBJECT
   DATA  nMeter            AS NUMERIC  INIT  0
   DATA  bmpConta
   DATA  aMsg              AS ARRAY    INIT  {}
   DATA  lAgruparRecibos               INIT  .f.
   DATA  lUsarVencimiento              INIT  .f.
   DATA  lUsarSEPA                     INIT  .t.
   DATA  cMru                          INIT "gc_briefcase2_document_16"
   DATA  cBitmap                       INIT clrTopArchivos
   DATA  oMenu
   DATA  oGetCuentaRemesa
   DATA  oFecExp
   DATA  oExportado

   DATA  cEsquema                      INIT "CORE"
   DATA  cSequencia                    INIT "OOFF"

   DATA  oCuaderno

   DATA  cCuentaRemesaAnterior         INIT ""

   DATA  lDefCobrado

   METHOD New( cPath, oWndParent, oMenuItem )

   METHOD OpenFiles( lExclusive )
   METHOD CloseFiles()

   METHOD DefineFiles()
   METHOD DefineDetails( cPath, cVia, lUniqueName, cFileName )

   METHOD OpenService( lExclusive )
   METHOD CloseService()

   METHOD Resource( nMode )
      METHOD validCuentaRemesa( oSay )
      METHOD changeCuentaRemesa()   
   METHOD ImportResource( nMode )
   METHOD Activate()
   METHOD lSave()

   METHOD GetRecCli( oDlg )
   METHOD SetRecCli()

   /*
   Metodos redefinidos---------------------------------------------------------
   */

   METHOD AppendDet()
   METHOD EditDet()
   METHOD RollBack()
   METHOD SaveDet()                 VIRTUAL

   METHOD Del()
   METHOD DelItem()

   METHOD nTotRem( lPic )
   METHOD nTotRemVir( lPic )

   METHOD cNumRem()                 INLINE   ( alltrim( str( ::oDbf:nNumRem ) + "/" + ::oDbf:cSufRem ) )
   METHOD cTextoRemesaContable()    INLINE   ( alltrim( str( ::oDbf:nNumRem ) ) + if( empty( ::oDbf:cSufRem  ) .or. ( ::oDbf:cSufRem == "00" ), "", "/" + ::oDbf:cSufRem ) )
   
   METHOD getReciboVirtualId()      INLINE   ( ::oDbfVir:cSerie + Str( ::oDbfVir:nNumFac ) + ::oDbfVir:cSufFac + Str( ::oDbfVir:nNumRec ) )
   METHOD gotoRecibo()              INLINE   ( ::oDbfDet:seekInOrd( ::getReciboVirtualId(), "nNumFac" ) )

   /*
   Metodos para exportacion de los modelos-------------------------------------
   */

   METHOD SaveModelo()
      METHOD RunModelo( oDlg )

   METHOD InitMod19()
   
   METHOD InitSepa19( oDlg )
      METHOD InsertPresentador()
      METHOD InsertAcreedor()
      METHOD InsertDeudor()

   METHOD InitSepaXML19( oDlg )
      METHOD InsertPresentadorXml()
      METHOD InsertAcreedorXml()    
      METHOD InsertDeudorXml()      

   METHOD InitMod58()

   /*
   Otros metodos---------------------------------------------------------------
   */

   METHOD nAllRecCli()

   METHOD nTotRemesaVir()           INLINE   0

   METHOD Report()

   METHOD contabilizaRemesas()
   METHOD cambiaEstadoContabilizadoRemesas( lConta )
   METHOD lContabilizaRecibos( lConta )

   METHOD cRetCtaRem()

   METHOD cBmp()

   METHOD GetNewCount()

   METHOD lNowExist()

   METHOD SaveDetails()

   METHOD EdtRecMenu( oDlg )

   METHOD EndEdtRecMenu()

   METHOD ChangeExport()

   METHOD getSerieRecibos()

   METHOD TipoRemesa()              INLINE ( if( ::oDbf:nTipRem == 2, "Descuento", "Pago" ) )

   METHOD CuentaCliente()           INLINE ( ::oDbfDet:cPaisIBAN + ::oDbfDet:cCtrlIBAN + ::oDbfDet:cEntCli + ::oDbfDet:cSucCli + ::oDbfDet:cDigCli + ::oDbfDet:cCtaCli )
   METHOD GetValidCuentaCliente()   INLINE ( if( Empty( ::CuentaCliente() ), cClientCuenta( ::oDbfDet:cCodCli, ::oCliBnc:cAlias ), ::CuentaCliente() ) )
   
   METHOD CuentaEmpresa()           INLINE ( ::oDbfDet:cEPaisIBAN + ::oDbfDet:cECtrlIBAN + ::oDbfDet:cEntEmp + ::oDbfDet:cSucEmp + ::oDbfDet:cDigEmp + ::oDbfDet:cCtaEmp )

   METHOD EntidadCliente()          INLINE ( ::oDbfDet:cEntCli )
   METHOD GetValidEntidadCliente()  INLINE ( if( Empty( ::EntidadCliente() ), cClientEntidad( ::oDbfDet:cCodCli, ::oCliBnc:cAlias ), ::EntidadCliente() ) )

   METHOD GetBICClient()            INLINE ( GetBIC( ::GetValidEntidadCliente() ) )

   METHOD TextoDocumento()          INLINE ( ::oDbfDet:cSerie + AllTrim( Str( ::oDbfDet:nNumFac ) ) + ::oDbfDet:cSufFac )
   METHOD IdDocumento()             INLINE ( ::oDbfDet:cSerie + AllTrim( Str( ::oDbfDet:nNumFac ) ) + ::oDbfDet:cSufFac )
   METHOD ImporteDocumento()        INLINE ( ::oDbfDet:nImporte )

   METHOD bancoRemesa()             INLINE ( ::oCtaRem:oDbf:cPaisIBAN + ::oCtaRem:oDbf:cCtrlIBAN + ::oCtaRem:oDbf:cEntBan + ::oCtaRem:oDbf:cAgcBan + ::oCtaRem:oDbf:cDgcBan + ::oCtaRem:oDbf:cCtaBan )

   METHOD inicializaData()

   METHOD getFicheroExportacion()
   METHOD getDirectorioExportacion()
   METHOD setDirectorioExportacion()

   METHOD getFicheroExportacionXml()   INLINE ( getPathFileNoExt( ::cFicheroExportacion ) + ".xml" )
   METHOD getFicheroExportacionTxt()   INLINE ( getPathFileNoExt( ::cFicheroExportacion ) + ".txt" )

   METHOD getIngreso()                 INLINE ( iif( empty( ::oDbf:dIngreso ), ::oDbf:dFecRem, ::oDbf:dIngreso ) )

   METHOD setEstadosRecibos()
   METHOD setEstadoRecibo( lCobrado, lDelete )  INLINE ( iif( lCobrado,;
                                                            (  ::oDbfDet:FieldPutByName( "lCobrado", .t. ),;
                                                               ::oDbfDet:FieldPutByName( "dEntrada", ::getIngreso() ) ),;
                                                            (  ::oDbfDet:FieldPutByName( "lCobrado", .f. ),;
                                                               ::oDbfDet:FieldPutByName( "dEntrada", ctod("") ) ) ),;
                                                         iif( lDelete,;
                                                            (  ::oDbfDet:FieldPutByName( "nNumRem", 0 ),;
                                                               ::oDbfDet:FieldPutByName( "cSufRem", Space( 2 ) ),;
                                                               ::oDbfDet:FieldPutByName( "lRemesa", .f. ) ), ) )

   METHOD setCancelar()
   METHOD DeleteDet( lMessage )

   METHOD setEstadoFactura()

   METHOD SetOrdenNumeroRemesa()
   METHOD RestoreOrdenNumeroRemesa()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( cPath, oMenuItem, oWndParent )

   DEFAULT cPath           := cPatEmp()
   DEFAULT oWndParent      := GetWndFrame()
   DEFAULT oMenuItem       := "01060"

   ::nLevel                := nLevelUsr( oMenuItem )

   ::cPath                 := cPath
   ::oWndParent            := oWndParent

   ::dExpedicionIni        := boy()
   ::dExpedicionFin        := eoy()
   ::dVencimientoIni       := ::dExpedicionIni
   ::dVencimeintoFin       := date()

   ::cNumDocKey            := "nNumRem"
   ::cSufDocKey            := "cSufRem"

   ::lMoveDlgSelect        := .t.

   ::bmpConta              := LoadBitmap( GetResources(), "bConta" )

   ::bFirstKey             := {|| Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem }
   ::bWhile                := {|| Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem == Str( ::oDbfVir:nNumRem, 9 ) + ::oDbfVir:cSufRem .and. !::oDbfVir:Eof() }

   ::lDefCobrado           := ( GetPvProfString( "REMESAS", "Cobrado", .t., cIniAplication() ) == ".T." )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE DATABASE ::oDbf FILE "REMCLIT.DBF" CLASS "REMCLI" ALIAS "REMCLI" PATH ( cPath ) VIA ( cDriver ) COMMENT "Remesas bancarias"

      FIELD NAME "lConta"              TYPE "L" LEN  1  DEC 0                             DEFAULT  .f.                                                                                 HIDE            OF ::oDbf
      FIELD CALCULATE NAME "bmpConta"           LEN  1  DEC 0                             VAL {|| ::oDbf:lConta }  BITMAPS "gc_folder2_12", "Nil16"  COMMENT { "Contabilizado", "gc_folder2_16", 3 } COLSIZE 20   OF ::oDbf
      FIELD NAME "lExport"             TYPE "L" LEN  1  DEC 0                             DEFAULT  .f.                                                                                 HIDE            OF ::oDbf
      FIELD CALCULATE NAME "bmpExport"          LEN  1  DEC 0                             VAL {|| ::oDbf:lExport } BITMAPS "gc_floppy_disk_12", "Nil16"  COMMENT { "Exportado", "gc_floppy_disk_16", 3 }     COLSIZE 20  OF ::oDbf
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
      FIELD NAME "dExport"             TYPE "D" LEN  8  DEC 0                             DEFAULT  CtoD( "" )                                                                          HIDE            OF ::oDbf
      FIELD NAME "dIngreso"            TYPE "D" LEN  8  DEC 0                             DEFAULT  CtoD( "" )                                COMMENT "Ingreso"    COLSIZE 80                           OF ::oDbf
      FIELD NAME "mComent"             TYPE "M" LEN 10  DEC 0                                                                                COMMENT "Comentario" COLSIZE 280                          OF ::oDbf

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

      INDEX TO ( cFileName ) TAG "nNumFac"   ON "cSerie + Str( nNumFac ) + cSufFac + Str( nNumRec ) + cTipRec"          	NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "cCodCli"   ON "cCodCli"                                                               	NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "cNomCli"   ON "cNomCli"                                                               	NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "lCodCli"   ON "cCodCli"                                                               	NODELETED FOR "!lCobrado" OF oDbf
      INDEX TO ( cFileName ) TAG "dPreCob"   ON "dPreCob"                                                               	NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "dFecVto"   ON "dFecVto"                                                               	NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "dEntrada"  ON "dEntrada"                                                              	NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "nImporte"  ON "nImporte"                                                                 NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "nNumRem"   ON "Str( nNumRem ) + cSufRem"                                    	            NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "cCtaRem"   ON "cCtaRem"                                                               	NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "cCodAge"   ON "cCodAge"                                                               	NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "nNumCob"   ON "Str( nNumCob ) + cSufCob"                                              	NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "cTurRec"   ON "cTurRec + cSufFac + cCodCaj"                                           	NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "fNumFac"   ON "cSerie + Str( nNumFac ) + cSufFac + Str( nNumRec ) + cTipRec"          	NODELETED FOR "Empty( cTipRec )"  OF oDbf
      INDEX TO ( cFileName ) TAG "rNumFac"   ON "cSerie + Str( nNumFac ) + cSufFac + Str( nNumRec ) + cTipRec"          	NODELETED FOR "!Empty( cTipRec )" OF oDbf
      INDEX TO ( cFileName ) TAG "cRecDec"   ON "cRecDev"                                                               	NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "lCtaBnc"   ON "cEntEmp + cSucEmp + cDigEmp + cCtaEmp"                                 	NODELETED FOR "lCobrado" OF oDbf
      INDEX TO ( cFileName ) TAG "cNumMtr"   ON "cNumMtr"                                                              	 	NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "iNumFac"   ON "'21' + cSerie + str( nNumFac ) + Space( 1 ) + cSufFac + Str( nNumRec )"   NODELETED OF oDbf

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

      DEFINE BTNSHELL RESOURCE "gc_document_empty_chart_" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( if( validRunReport( "01120" ), TFastVentasRecibos():New():Play(), ) );
         TOOLTIP  "(R)eporting";
         HOTKEY   "R";
         LEVEL    ACC_IMPR

      DEFINE BTNSHELL RESOURCE "BmpExptar" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::SaveModelo() ) ;
         TOOLTIP  "E(x)portar" ;
         HOTKEY   "X";
         LEVEL    4

      DEFINE BTNSHELL RESOURCE "BmpConta" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::SetOrdenNumeroRemesa(), ::SelectRec( {|| ::contabilizaRemesas( ::lChkSelect ) }, "Contabilizar remesas", "Simular" , .f. ), ::RestoreOrdenNumeroRemesa() ) ;
         TOOLTIP  "(C)ontabilizar" ;
         HOTKEY   "C";
         LEVEL    4

      DEFINE BTNSHELL RESOURCE "CHGSTATE" OF ::oWndBrw ;
			NOBORDER ;
         ACTION   ( ::SetOrdenNumeroRemesa(), ::SelectRec( {|| ::cambiaEstadoContabilizadoRemesas( ::lChkSelect ) }, "Cambiar estado", "Contabilizado" , .f. ), ::RestoreOrdenNumeroRemesa() ) ;
         TOOLTIP  "Cambiar es(t)ado" ;
         HOTKEY   "T";
         LEVEL    4

      DEFINE BTNSHELL oRotor RESOURCE "ROTOR" GROUP OF ::oWndBrw ;
         ACTION   ( oRotor:Expand() ) ;
         TOOLTIP  "Rotor" ;

         DEFINE BTNSHELL RESOURCE "GC_DICTIONARY_" OF ::oWndBrw ;
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

      DATABASE NEW ::oDbfDet     FILE "FACCLIP.DBF"   PATH ( ::cPath )    VIA ( cDriver() ) SHARED INDEX "FACCLIP.CDX"
      ::oDbfDet:OrdSetFocus( "nNumRem" )

      ::oFacCliT        := TDataCenter():oFacCliT()

      DATABASE NEW ::oFacCliL    FILE "FACCLIL.DBF"   PATH ( ::cPath )    VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

      DATABASE NEW ::oAntCliT    FILE "AntCliT.DBF"   PATH ( ::cPath )    VIA ( cDriver() ) SHARED INDEX "AntCliT.CDX"

      DATABASE NEW ::oClientes   FILE "CLIENT.DBF"    PATH ( cPatCli() )  VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

      DATABASE NEW ::oIva        FILE "TIVA.DBF"      PATH ( cPatDat() )  VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

      DATABASE NEW ::oDivisas    FILE "DIVISAS.DBF"   PATH ( cPatDat() )  VIA ( cDriver() ) SHARED INDEX "DIVISAS.CDX"

      DATABASE NEW ::oDbfCnt     FILE "nCount.Dbf"    PATH ( cPatEmp() )  VIA ( cDriver() ) SHARED INDEX "nCount.Cdx"

      DATABASE NEW ::oFormaPago  FILE "fPago.Dbf"     PATH ( cPatEmp() )  VIA ( cDriver() ) SHARED INDEX "fPago.Cdx"

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

   if ::oFormaPago != nil .and. ::oFormaPago:Used()
      ::oFormaPago:End()
   end if 

   ::oDbf         := nil
   ::oDbfDet      := nil
   ::oDivisas     := nil
   ::oDbfCnt      := nil
   ::oClientes    := nil
   ::oDbfDet      := nil
   ::oCtaRem      := nil
   ::oCliBnc      := nil
   ::oFormaPago   := nil

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

METHOD inicializaData()

   ::cSerieInicio          := "A"
   ::cSerieFin             := "Z"

   ::nNumeroInicio         := 0
   ::nNumeroFin            := 999999999

   ::cSufijoInicio         := Space( 2 )
   ::cSufijoFin            := "ZZ"

   ::lNotImportCeros                   := .t.
   ::lNotImportSinCuenta               := .t.
   ::lNotImportarEsperaDocumentacion   := .t.

   ::cClienteIni           := dbFirst( ::oClientes, 1 )
   ::cClienteFin           := dbLast ( ::oClientes, 1 )

   ::cFormaPagoIni         := dbFirst( ::oFormaPago, 1 )
   ::cFormaPagoFin         := dbLast ( ::oFormaPago, 1 )

   ::cCuentaRemesaAnterior := ::oDbf:cCodRem

return ( nil )

//---------------------------------------------------------------------------//

METHOD Resource( nMode )

   local oDlg
   local oGet     := Array( 3 )
   local oSay
   local cSay     := ::oCtaRem:cRetCtaRem( ::oDbf:cCodRem )
   local oBmpDiv
   local oBtnImportar
   local oBmpGeneral

   ::inicializaData()

   DEFINE DIALOG oDlg RESOURCE "RemCli" TITLE LblTitle( nMode ) + "remesas de recibos a clientes"

      REDEFINE BITMAP oBmpGeneral ;
         ID       990 ;
         RESOURCE "gc_briefcase2_document_48" ;
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

      REDEFINE GET ::oDbf:dIngreso ;
         ID       125 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

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

      REDEFINE GET ::oGetCuentaRemesa ;
         VAR      ::oDbf:cCodRem ;
         UPDATE ;
         ID       130 ;
         PICTURE  ::oDbf:FieldByName( "cCodRem" ):cPict ;
         BITMAP   "LUPA" ;
			OF 		oDlg

      ::oGetCuentaRemesa:bValid := {|| ::validCuentaRemesa( oSay ) }
      ::oGetCuentaRemesa:bWhen  := {|| nMode != ZOOM_MODE }
      ::oGetCuentaRemesa:bHelp  := {|| ::oCtaRem:Buscar( ::oGetCuentaRemesa ) }

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

      REDEFINE GET ::oDbf:mComent ;
         MEMO ;
         ID       180 ;
         OF       oDlg

      /*
      Botones de acceso________________________________________________________
      */

      REDEFINE BUTTON ;
			ID 		500 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::AppendDet( nMode ) )

      REDEFINE BUTTON ;
         ID       501 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::EditDet() )

		REDEFINE BUTTON ;
			ID 		502 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::MultiDeleteDet() )

      REDEFINE BUTTON oBtnImportar;
         ID       503 ;
         OF       oDlg ;
         WHEN     ( nMode == APPD_MODE ) ;
         ACTION   ( ::ImportResource( nMode ) )

      REDEFINE BUTTON ;
         ID       504 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::setEstadosRecibos( .t. ) )

      REDEFINE BUTTON ;
         ID       505 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::setEstadosRecibos( .f. ) )

      /*
      Recibos__________________________________________________________________
      */

      ::oBrwDet               := IXBrowse():New( oDlg )

      ::oBrwDet:bClrSel       := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrwDet:bClrSelFocus  := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oBrwDet:nMarqueeStyle := 6
      ::oBrwDet:cName         := "Remesas.Lineas"
      ::oBrwDet:lFooter       := .t.

      ::oDbfVir:SetBrowse( ::oBrwDet )

      with object ( ::oBrwDet:AddCol() )
         :cHeader          := "Estado"
         :nHeadBmpNo       := 3
         :bStrData         := {|| ::gotoRecibo(), ( if( ::oDbfDet:lCobrado, "Cobrado", "Pendiente" ) ) }
         :bBmpData         := {|| ::gotoRecibo(), ( if( ::oDbfDet:lCobrado, 1, 2 ) ) }
         :nWidth           := 20
         :AddResource( "bSel" )
         :AddResource( "gc_delete_16" )
         :AddResource( "gc_money2_16" )
      end with

      with object ( ::oBrwDet:AddCol() )
         :cHeader          := "Número"
         :bEditValue       := {|| ::gotoRecibo(), ::oDbfDet:cSerie + "/" + Alltrim( Str( ::oDbfDet:nNumFac ) ) + "-" + AllTrim( Str( ::oDbfDet:nNumRec ) ) }
         :nWidth           := 90
      end with

      with object ( ::oBrwDet:AddCol() )
         :cHeader          := "Delegción"
         :bEditValue       := {|| ::gotoRecibo(), ::oDbfDet:cSufFac }
         :nWidth           := 40
      end with

      with object ( ::oBrwDet:AddCol() )
         :cHeader          := "Fecha"
         :bStrData         := {|| ::gotoRecibo(), DtoC( ::oDbfDet:dPreCob ) }
         :nWidth           := 80
      end with

      with object ( ::oBrwDet:AddCol() )
         :cHeader          := "Vencimiento"
         :bStrData         := {|| ::gotoRecibo(), DtoC( ::oDbfDet:dFecVto ) }
         :nWidth           := 80
      end with

      with object ( ::oBrwDet:AddCol() )
         :cHeader          := "Cliente"
         :bStrData         := {|| ::gotoRecibo(), Rtrim( ::oDbfDet:cCodCli ) + Space( 1 ) + Rtrim( ::oDbfDet:cNomCli ) }
         :nWidth           := 146
      end with

      with object ( ::oBrwDet:AddCol() )
         :cHeader          := "Descripción"
         :bStrData         := {|| ::gotoRecibo(), ::oDbfDet:cDescrip }
         :nWidth           := 220
      end with

      with object ( ::oBrwDet:AddCol() )
         :cHeader          := "Forma pago"
         :bStrData         := {|| ::gotoRecibo(), Rtrim( ::oDbfDet:cCodPgo ) + Space( 1 ) + cNbrFPago( ::oDbfDet:cCodPgo ) }
         :nWidth           := 150
         :lHide            := .t.
      end with

      with object ( ::oBrwDet:AddCol() )
         :cHeader          := "Agente"
         :bStrData         := {|| ::gotoRecibo(), Rtrim( ::oDbfDet:cCodAge ) + Space( 1 ) + RetNbrAge( ::oDbfDet:cCodAge ) }
         :nWidth           := 150
         :lHide            := .t.
      end with

      with object ( ::oBrwDet:AddCol() )
         :cHeader          := "Importe"
         :bEditValue       := {|| ::gotoRecibo(), nTotRecCli( ::oDbfDet, ::oDivisas:cAlias, ::oDbf:cCodDiv, .t. ) }
         :nWidth           := 100
         :bFooter          := {|| ::nTotRemVir( .t. ) }
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :nFootStrAlign    := 1
      end with

      with object ( ::oBrwDet:AddCol() )
         :cHeader          := "Div."
         :bEditValue       := {|| ::gotoRecibo(), cSimDiv( ::oDbfDet:cDivPgo, ::oDivisas:cAlias ) }
         :nWidth           := 20
      end with

      with object ( ::oBrwDet:AddCol() )
         :cHeader          := "Cuenta"
         :bEditValue       := {|| ::gotoRecibo(), ::oDbfDet:cPaisIBAN + ::oDbfDet:cCtrlIBAN + "-" + ::oDbfDet:cEntCli + "-" + ::oDbfDet:cSucCli + "-" + ::oDbfDet:cDigCli + "-" + ::oDbfDet:cCtaCli }
         :nWidth           := 250
         :lHide            := .t.
      end with

      ::oBrwDet:CreateFromResource( 150 )
      ::oBrwDet:bLDblClick := {|| ::EditDet() }

      REDEFINE BUTTON ;
         ID       511 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( if( ::lSave( nMode ), oDlg:End( IDOK ), ) )

		REDEFINE BUTTON ;
         ID       510 ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( ::setCancelar( nMode ), oDlg:end() )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F2, {|| ::AppendDet( nMode ) } )
      oDlg:AddFastKey( VK_F4, {|| ::MultiDeleteDet() } )
      oDlg:AddFastKey( VK_F5, {|| if( ::lSave( nMode ), oDlg:End( IDOK ), ) } )
   end if

   oDlg:SetControlFastKey( "remesasBancarias", self )

   oDlg:AddFastKey(  VK_F1,   {|| ChmHelp( "Remesasbancarias2" ) } )

   oDlg:bStart             := {|| ::oGetCuentaRemesa:SetFocus() }

   oDlg:Activate( , , , .t., , , {|| ::EdtRecMenu( oDlg ) } )

   ::EndEdtRecMenu()

   oBmpDiv:End()
   oBmpGeneral:End()

   // Guardamos los datos del browse

   ::oBrwDet:CloseData()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD validCuentaRemesa( oSay )

   local cCuentaRemesaActual  := ::oGetCuentaRemesa:varGet()

   if !::oCtaRem:lGetCtaRem( ::oGetCuentaRemesa, oSay )
      Return ( .f. )
   end if 

   // Nos aseguramos q han cambiado la cuenta de remesa

   if ::cCuentaRemesaAnterior != cCuentaRemesaActual
      ::changeCuentaRemesa()
   end if 

RETURN .t.

//---------------------------------------------------------------------------//

METHOD changeCuentaRemesa()

   if !::oCtaRem:oDbf:Seek( ::oDbf:cCodRem )   
      msgStop( "Cuenta de remesa no encontrada." )
      Return .f.
   end if 

   ::oDbfVir:GoTop()
   while !::oDbfVir:Eof()

      if ::gotoRecibo()
         ::oDbfDet:Load()
         ::oDbfDet:cBncEmp    := ::oCtaRem:oDbf:cBanco
         ::oDbfDet:cEPaisIBAN := ::oCtaRem:oDbf:cPaisIBAN
         ::oDbfDet:cECtrlIBAN := ::oCtaRem:oDbf:cCtrlIBAN
         ::oDbfDet:cEntEmp    := ::oCtaRem:oDbf:cEntBan
         ::oDbfDet:cSucEmp    := ::oCtaRem:oDbf:cAgcBan
         ::oDbfDet:cDigEmp    := ::oCtaRem:oDbf:cDgcBan
         ::oDbfDet:cCtaEmp    := ::oCtaRem:oDbf:cCtaBan
         ::oDbfDet:Save()
      end if 

      ::oDbfVir:Skip()

      sysrefresh()

   end while

   ::oDbfVir:GoTop()

   ::oBrwDet:Refresh()

RETURN ( .t. )

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

      REDEFINE GET ::oSerieInicio VAR ::cSerieInicio ;
         ID       190 ;
         SPINNER ;
         ON UP    ( UpSerie( ::oSerieInicio ) );
         ON DOWN  ( DwSerie( ::oSerieInicio ) );
         PICTURE  "@!" ;
         COLOR    CLR_GET ;
         VALID    ( ::cSerieInicio >= "A" .and. ::cSerieInicio <= "Z"  );
         OF       oDlg

      REDEFINE GET ::oSerieFin VAR ::cSerieFin ;
         ID       200 ;
         SPINNER ;
         ON UP    ( UpSerie( ::oSerieFin ) );
         ON DOWN  ( DwSerie( ::oSerieFin ) );
         PICTURE  "@!" ;
         COLOR    CLR_GET ;
         VALID    ( ::cSerieFin >= "A" .and. ::cSerieFin <= "Z"  );
         OF       oDlg

      REDEFINE GET ::oNumeroInicio VAR ::nNumeroInicio ;
         ID       210 ;
         SPINNER ;
         OF       oDlg

      REDEFINE GET ::oNumeroFin VAR ::nNumeroFin ;
         ID       220 ;
         SPINNER ;
         OF       oDlg

      REDEFINE GET ::oSufijoInicio VAR ::cSufijoInicio ;
         ID       230 ;
         PICTURE  "@!" ;
         OF       oDlg

      REDEFINE GET ::oSufijoFin VAR ::cSufijoFin ;
         ID       240 ;
         PICTURE  "@!" ;
         OF       oDlg

      REDEFINE GET ::oClienteIni VAR ::cClienteIni;
         ID       150 ;
         IDTEXT   151 ;
         BITMAP   "LUPA" ;
         OF       oDlg

         ::oClienteIni:bValid    := {|| cClient( ::oClienteIni, ::oClientes:cAlias, ::oClienteIni:oHelpText ) }
         ::oClienteIni:bHelp     := {|| BrwClient( ::oClienteIni, ::oClienteIni:oHelpText ) }

      REDEFINE GET ::oClienteFin VAR ::cClienteFin;
         ID       160 ;
         IDTEXT   161 ;
         BITMAP   "LUPA" ;
         OF       oDlg

         ::oClienteFin:bValid    := {|| cClient( ::oClienteFin, ::oClientes:cAlias, ::oClienteFin:oHelpText ) }
         ::oClienteFin:bHelp     := {|| BrwClient( ::oClienteFin, ::oClienteFin:oHelpText ) }

      REDEFINE GET ::oFormaPagoIni VAR ::cFormaPagoIni;
         ID       170 ;
         IDTEXT   171 ;
         BITMAP   "LUPA" ;
         OF       oDlg

         ::oFormaPagoIni:bValid    := {|| cFpago( ::oFormaPagoIni, ::oFormaPago:cAlias, ::oFormaPagoIni:oHelpText ) }
         ::oFormaPagoIni:bHelp     := {|| BrwFPago( ::oFormaPagoIni, ::oFormaPagoIni:oHelpText ) }

      REDEFINE GET ::oFormaPagoFin VAR ::cFormaPagoFin;
         ID       180 ;
         IDTEXT   181 ;
         BITMAP   "LUPA" ;
         OF       oDlg

         ::oFormaPagoFin:bValid    := {|| cFpago( ::oFormaPagoFin, ::oFormaPago:cAlias, ::oFormaPagoFin:oHelpText ) }
         ::oFormaPagoFin:bHelp     := {|| BrwFPago( ::oFormaPagoFin, ::oFormaPagoFin:oHelpText ) }

      REDEFINE CHECKBOX ::oNotImportCeros ;
         VAR      ::lNotImportCeros ;
         ID       250 ;
         OF       oDlg

      REDEFINE CHECKBOX ::oNotImportSinCuenta ;
         VAR      ::lNotImportSinCuenta ;
         ID       260 ;
         OF       oDlg

      REDEFINE CHECKBOX ::oNotImportarEsperaDocumentacion ;
         VAR      ::lNotImportarEsperaDocumentacion ;
         ID       270 ;
         OF       oDlg

      /*
      Filtros de series--------------------------------------------------------
      */

      TWebBtn():Redefine( 1170,,,,, {|This| ( aEval( ::oSer, {|o| Eval( o:bSetGet, .T. ), o:refresh() } ) ) }, oDlg,,,,, "LEFT",,,,, ( 0 + ( 0 * 256 ) + ( 255 * 65536 ) ), ( 0 + ( 0 * 256 ) + ( 255 * 65536 ) ) ):SetTransparent()

      TWebBtn():Redefine( 1180,,,,, {|This| ( aEval( ::oSer, {|o| Eval( o:bSetGet, .F. ), o:refresh() } ) ) }, oDlg,,,,, "LEFT",,,,, ( 0 + ( 0 * 256 ) + ( 255 * 65536 ) ), ( 0 + ( 0 * 256 ) + ( 255 * 65536 ) ) ):SetTransparent()

      REDEFINE CHECKBOX ::oSer[  1 ] VAR ::aSer[  1 ] ID 1190 OF oDlg //A
      REDEFINE CHECKBOX ::oSer[  2 ] VAR ::aSer[  2 ] ID 1200 OF oDlg //B
      REDEFINE CHECKBOX ::oSer[  3 ] VAR ::aSer[  3 ] ID 1210 OF oDlg //C
      REDEFINE CHECKBOX ::oSer[  4 ] VAR ::aSer[  4 ] ID 1220 OF oDlg //D
      REDEFINE CHECKBOX ::oSer[  5 ] VAR ::aSer[  5 ] ID 1230 OF oDlg //E
      REDEFINE CHECKBOX ::oSer[  6 ] VAR ::aSer[  6 ] ID 1240 OF oDlg //F
      REDEFINE CHECKBOX ::oSer[  7 ] VAR ::aSer[  7 ] ID 1250 OF oDlg //G
      REDEFINE CHECKBOX ::oSer[  8 ] VAR ::aSer[  8 ] ID 1260 OF oDlg //H
      REDEFINE CHECKBOX ::oSer[  9 ] VAR ::aSer[  9 ] ID 1270 OF oDlg //I
      REDEFINE CHECKBOX ::oSer[ 10 ] VAR ::aSer[ 10 ] ID 1280 OF oDlg //J
      REDEFINE CHECKBOX ::oSer[ 11 ] VAR ::aSer[ 11 ] ID 1290 OF oDlg //K
      REDEFINE CHECKBOX ::oSer[ 12 ] VAR ::aSer[ 12 ] ID 1300 OF oDlg //L
      REDEFINE CHECKBOX ::oSer[ 13 ] VAR ::aSer[ 13 ] ID 1310 OF oDlg //M
      REDEFINE CHECKBOX ::oSer[ 14 ] VAR ::aSer[ 14 ] ID 1320 OF oDlg //N
      REDEFINE CHECKBOX ::oSer[ 15 ] VAR ::aSer[ 15 ] ID 1330 OF oDlg //O
      REDEFINE CHECKBOX ::oSer[ 16 ] VAR ::aSer[ 16 ] ID 1340 OF oDlg //P
      REDEFINE CHECKBOX ::oSer[ 17 ] VAR ::aSer[ 17 ] ID 1350 OF oDlg //Q
      REDEFINE CHECKBOX ::oSer[ 18 ] VAR ::aSer[ 18 ] ID 1360 OF oDlg //R
      REDEFINE CHECKBOX ::oSer[ 19 ] VAR ::aSer[ 19 ] ID 1370 OF oDlg //S
      REDEFINE CHECKBOX ::oSer[ 20 ] VAR ::aSer[ 20 ] ID 1380 OF oDlg //T
      REDEFINE CHECKBOX ::oSer[ 21 ] VAR ::aSer[ 21 ] ID 1390 OF oDlg //U
      REDEFINE CHECKBOX ::oSer[ 22 ] VAR ::aSer[ 22 ] ID 1400 OF oDlg //V
      REDEFINE CHECKBOX ::oSer[ 23 ] VAR ::aSer[ 23 ] ID 1410 OF oDlg //W
      REDEFINE CHECKBOX ::oSer[ 24 ] VAR ::aSer[ 24 ] ID 1420 OF oDlg //X
      REDEFINE CHECKBOX ::oSer[ 25 ] VAR ::aSer[ 25 ] ID 1430 OF oDlg //Y
      REDEFINE CHECKBOX ::oSer[ 26 ] VAR ::aSer[ 26 ] ID 1440 OF oDlg //Z

      ::oMeter    := TApoloMeter():ReDefine( 140, { | u | if( pCount() == 0, ::nMeter, ::nMeter := u ) }, 140, oDlg, .f., , , .t., rgb( 255,255,255 ), , rgb( 128,255,0 ) )

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

      oDlg:bStart    := {|| ::oClienteIni:lValid(), ::oClienteFin:lValid(), ::oFormaPagoIni:lValid(), ::oFormaPagoFin:lValid() }

   oDlg:Activate( , , , .t. )

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD lSave( nMode )

   local lReturn  := .t.

   if nMode == APPD_MODE

      if empty( ::oDbf:cCodRem )
         msgStop( "El número de cuenta no puede estar vacío." )
         ::oGetCuentaRemesa:SetFocus()
         lReturn  := .f.
      end if

   end if

RETURN ( lReturn )

//---------------------------------------------------------------------------//

METHOD RollBack()
/*
   ::GetFirstKey()

   if ::cFirstKey != nil
      while ::oDbfDet:Seek( ::cFirstKey )
         ::DelItem()
      end while
   end if
*/
RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD SaveDetails()

   local cNumRec
   local cNumFac

   ::RollBack()

   // Ponemos todos los recibos con su cuenta de remesa------------------------

   ::oDbfVir:GoTop()
   while !::oDbfVir:Eof()

      SysRefresh()

      cNumFac                    := ::oDbfVir:cSerie + str( ::oDbfVir:nNumFac, 9 ) + ::oDbfVir:cSufFac
      cNumRec                    := cNumFac + str( ::oDbfVir:nNumRec, 2 ) + ::oDbfVir:cTipRec

      if ::oDbfDet:SeekInOrd( cNumRec, "nNumFac" )

         ::oDbfDet:Load()

         if ::oDbf:nTipRem == 2  //Remesa por descuentos
            ::oDbfDet:lRecDto    := .t.
            ::oDbfDet:dFecDto    := ::getIngreso()
         end if

         ::oDbfDet:cCtaRem       := ::oDbf:cCodRem
         ::oDbfDet:nNumRem       := ::oDbf:nNumRem
         ::oDbfDet:cSufRem       := ::oDbf:cSufRem
         ::oDbfDet:lRemesa       := .t.

         if empty( ::oDbfDet:cEPaisIBAN ) .or.;
            empty( ::oDbfDet:cECtrlIBAN ) .or.;
            empty( ::oDbfDet:cBncEmp )    .or.;
            empty( ::oDbfDet:cEntEmp )    .or.;
            empty( ::oDbfDet:cSucEmp )    .or.;
            empty( ::oDbfDet:cDigEmp )    .or.;
            empty( ::oDbfDet:cCtaEmp )

            ::oDbfDet:cEPaisIBAN := oRetFld( ::oDbf:cCodRem, ::oCtaRem:oDbf, "cPaisIBAN" )
            ::oDbfDet:cECtrlIBAN := oRetFld( ::oDbf:cCodRem, ::oCtaRem:oDbf, "cCtrlIBAN" )
            ::oDbfDet:cBncEmp    := oRetFld( ::oDbf:cCodRem, ::oCtaRem:oDbf, "cBanco" )
            ::oDbfDet:cEntEmp    := oRetFld( ::oDbf:cCodRem, ::oCtaRem:oDbf, "cEntBan" )
            ::oDbfDet:cSucEmp    := oRetFld( ::oDbf:cCodRem, ::oCtaRem:oDbf, "cAgcBan" )
            ::oDbfDet:cDigEmp    := oRetFld( ::oDbf:cCodRem, ::oCtaRem:oDbf, "cDgcBan" )
            ::oDbfDet:cCtaEmp    := oRetFld( ::oDbf:cCodRem, ::oCtaRem:oDbf, "cCtaBan" )

         end if

         ::oDbfDet:Save()

      end if

      // Estado de las facturas------------------------------------------------

      if ::oFacCliT:Seek( cNumFac )
         chkLqdFacCli( nil, ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::oDbfDet:cAlias, ::oAntCliT:cAlias, ::oIva:cAlias, ::oDivisas:cAlias )
      end if

      ::oDbfVir:Skip()

   end while

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD SaveModelo()

   local oDlg
   local oBmpGeneral
   local oComboEsquema
   local oComboSequencia
   local oGetFicheroExportacion

   if ::oDbf:Recno() == 0
      Return ( Self )
   end if

   ::cFicheroExportacion   := ::getFicheroExportacion()

   ::cEsquema              := getConfigUser( 'Esquema',           ::cEsquema )
   ::cSequencia            := getConfigUser( 'Sequencia',         ::cSequencia )
   ::lAgruparRecibos       := getConfigUser( 'AgruparRecibos',    ::lAgruparRecibos )
   ::lUsarVencimiento      := getConfigUser( 'UsarVencimiento',   ::lUsarVencimiento )

   DEFINE DIALOG  oDlg ;
      RESOURCE    "Modelo19" ; 
      TITLE       "Remesa de recibos a soporte magnéticos según norma " + ( if( ::oDbf:nTipRem == 2, "58", "19" ) )

      REDEFINE BITMAP oBmpGeneral ;
         ID       500 ;
         RESOURCE "gc_floppy_disk_48" ;
         TRANSPARENT ;
         OF       oDlg

      REDEFINE CHECKBOX ::lUsarVencimiento ;
         ID       140 ;
         WHEN     ( ::oDbf:nTipRem != 2 ) ;
         OF       oDlg

      REDEFINE GET oGetFicheroExportacion ;
         VAR      ::cFicheroExportacion ;
         ID       130 ;
         BITMAP   "FOLDER" ;
         ON HELP  ( oGetFicheroExportacion:cText( cGetFile( "*.xml", "Selección de fichero" ) ) ) ;
         OF       oDlg

      REDEFINE CHECKBOX ::lAgruparRecibos ;
         ID       100 ;
         WHEN     ( ::oDbf:nTipRem != 2 ) ;
         OF       oDlg

      REDEFINE COMBOBOX oComboEsquema ;
         VAR      ::cEsquema ;
         ID       160 ;
         ITEMS    { "CORE", "COR1" } ;
         OF       oDlg

      REDEFINE COMBOBOX oComboSequencia ;
         VAR      ::cSequencia ;
         ID       170 ;
         ITEMS    { "OOFF", "FRST", "FNAL", "RCUR" } ;
         OF       oDlg

      ::oTreeIncidencias   := TTreeView():Redefine( 150, oDlg )

      REDEFINE BUTTON   ;
         ID       550 ;
         OF       oDlg ;
         ACTION   ( ::RunModelo( oDlg ) )

      REDEFINE BUTTON   ;
         ID       551 ;
         OF       oDlg ;
         ACTION   ( oDlg:End() )

      oDlg:AddFastKey( VK_F5, {|| ::RunModelo( oDlg ) } )

   ACTIVATE DIALOG oDlg CENTER

   setConfigUser( 'Esquema',           ::cEsquema )
   setConfigUser( 'Sequencia',         ::cSequencia )
   setConfigUser( 'AgruparRecibos',    ::lAgruparRecibos )
   setConfigUser( 'UsarVencimiento',   ::lUsarVencimiento )

   if !Empty( oBmpGeneral )
      oBmpGeneral:End()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD RunModelo( oDlg )

   oDlg:Disable()

   ::InitSepaXML19( oDlg )

   ::oDbf:FieldPutByName( "lExport", .t. )
   ::oDbf:FieldPutByName( "dExport",  GetSysDate() )

   ::setDirectorioExportacion()

   oDlg:Enable()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD InitMod58( oDlg )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD GetRecCli( oDlg, nMode )

   local n           := 0
   local cCodRem     := ::oDbf:cCodRem

   if Empty( cCodRem )
      msgStop( "Debe introducir un codigo de remesa" )
      return .t.
   end if

   if ( nMode != APPD_MODE )
      msgStop( "Solo se puede importar recibos añadiendo" )
      return .t.
   end if

   oDlg:Disable()

   ::oMeter:nTotal   := ::oDbfDet:OrdKeyCount()

   ::oDbfDet:GoTop()
   while !::oDbfDet:Eof()

      /*
      logwrite( "1" )
      logwrite( ::oDbfDet:cSerie >= ::cSerieInicio .and. ::oDbfDet:cSerie <= ::cSerieFin                                   )
      logwrite( "2" )
      logwrite( ::oDbfDet:nNumFac >= ::nNumeroInicio .and. ::oDbfDet:nNumFac <= ::nNumeroFin                               )
      logwrite( "3" )
      logwrite( ::oDbfDet:cSufFac >= ::cSufijoInicio .and. ::oDbfDet:cSufFac <= ::cSufijoFin                               )
      logwrite( "4" )
      logwrite( lChkSer( ::oDbfDet:cSerie, ::aSer )                                                                        )
      logwrite( "5" )
      logwrite( !::lNowExist( ::oDbfDet:cSerie + Str( ::oDbfDet:nNumFac ) + ::oDbfDet:cSufFac + Str( ::oDbfDet:nNumRec ) ) )
      logwrite( "6" )
      logwrite( !::oDbfDet:lCobrado                                                                                        )
      logwrite( "7" )
      logwrite( !Empty( ::oDbfDet:dPreCob )                                                                                )
      logwrite( "9" )
      logwrite( Empty( ::oDbfDet:nNumRem )                                                                                 )
      logwrite( "9" )
      logwrite( ::oDbfDet:dPreCob >= ::dExpedicionIni                                                                      )
      logwrite( "10" )
      logwrite( ::oDbfDet:dPreCob <= ::dExpedicionFin                                                                      )
      logwrite( "11" )
      logwrite( ::oDbfDet:dFecVto >= ::dVencimientoIni                                                                     )
      logwrite( "12" )
      logwrite( ::oDbfDet:dFecVto <= ::dVencimeintoFin                                                                     )
      logwrite( "13" )
      logwrite( ::oDbfDet:cCodCli >= ::cClienteIni                                                                         )
      logwrite( "14" )
      logwrite( ::oDbfDet:cCodCli <= ::cClienteFin                                                                         )
      logwrite( "15" )
      logwrite( ::oDbfDet:cCodPgo >= ::cFormaPagoIni                                                                       )
      logwrite( "16" )
      logwrite( ::oDbfDet:cCodPgo <= ::cFormaPagoFin                                                                       )
      logwrite( "17" )
      logwrite( ( !::lNotImportCeros .or. ::oDbfDet:nImporte > 0 )                                                         )
      logwrite( "18" )
      logwrite( ( !::lNotImportSinCuenta .or. !Empty( ::oDbfDet:cCtaCli ) )                                                )
      logwrite( "19" )
      logwrite( ( !::lNotImportarEsperaDocumentacion .or. !::oDbfDet:lEsperaDoc )                                          )
      */
      
      if ::oDbfDet:cSerie >= ::cSerieInicio .and. ::oDbfDet:cSerie <= ::cSerieFin                                    .and.;
         ::oDbfDet:nNumFac >= ::nNumeroInicio .and. ::oDbfDet:nNumFac <= ::nNumeroFin                                .and.;
         ::oDbfDet:cSufFac >= ::cSufijoInicio .and. ::oDbfDet:cSufFac <= ::cSufijoFin                                .and.;
         lChkSer( ::oDbfDet:cSerie, ::aSer )                                                                         .and.;
         !::lNowExist( ::oDbfDet:cSerie + Str( ::oDbfDet:nNumFac ) + ::oDbfDet:cSufFac + Str( ::oDbfDet:nNumRec ) )  .and.;
         !::oDbfDet:lCobrado                                                                                         .and.;
         !Empty( ::oDbfDet:dPreCob )                                                                                 .and.;
         Empty( ::oDbfDet:nNumRem )                                                                                  .and.;
         ::oDbfDet:dPreCob >= ::dExpedicionIni                                                                       .and.;
         ::oDbfDet:dPreCob <= ::dExpedicionFin                                                                       .and.;
         ::oDbfDet:dFecVto >= ::dVencimientoIni                                                                      .and.;
         ::oDbfDet:dFecVto <= ::dVencimeintoFin                                                                      .and.;
         ::oDbfDet:cCodCli >= ::cClienteIni                                                                          .and.;
         ::oDbfDet:cCodCli <= ::cClienteFin                                                                          .and.;
         ::oDbfDet:cCodPgo >= ::cFormaPagoIni                                                                        .and.;
         ::oDbfDet:cCodPgo <= ::cFormaPagoFin                                                                        .and.;
         ( !::lNotImportCeros .or. ::oDbfDet:nImporte > 0 )                                                          .and.;
         ( !::lNotImportSinCuenta .or. !Empty( ::oDbfDet:cCtaCli ) )                                                 .and.;
         ( !::lNotImportarEsperaDocumentacion .or. !::oDbfDet:lEsperaDoc )

         if ::oDbfVir:Append()
            aEval( ::oDbfVir:aTField, {| oFld, n | ::oDbfVir:FldPut( n, ::oDbfDet:FieldGet( n ) ) } )

            if ::gotoRecibo()
               ::setEstadoRecibo( ::lDefCobrado, .f. )
            end if

            ::oDbfVir:Save()
         end if

         n++

      end if

      ::oDbfDet:Skip()

      ::oMeter:Set( ::oDbfDet:OrdKeyNo() )

   end while

   ::oMeter:Set( 0 )
   ::oMeter:Refresh()

   ::oDbfVir:GoTop()

   ::oBrwDet:Refresh()

   oDlg:Enable()
   oDlg:End()

   msgInfo( Ltrim( Trans( n, "999999999" ) ) + " recibos importados, en la cuenta " + cCodRem )

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

METHOD AppendDet( nMode )

   local nRec
   local aCodRec  := {}
   local cCodRec

   if BrwRecCli( @aCodRec, ::oDbfDet:cAlias, ::oClientes:cAlias, ::oDivisas:cAlias, ::oBandera )

      for each nRec in aCodRec

         ::oDbfDet:Goto( nRec )

         cCodRec  := ::oDbfDet:cSerie + Str( ::oDbfDet:nNumFac ) + ::oDbfDet:cSufFac + Str( ::oDbfDet:nNumRec ) + ::oDbfDet:cTipRec

         if ::lNowExist( cCodRec )
            msgStop( "Recibo ya incluido en remesa." )
            return ( .f. )
         end if

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

            if ::gotoRecibo()
               ::setEstadoRecibo( ::lDefCobrado, .f. )
            end if
            
            ::oDbfVir:Save()

         end if

      next

      ::oBrwDet:Refresh()

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD EditDet()

   local cNumeroRecibo  := ::oDbfVir:cSerie + Str( ::oDbfVir:nNumFac ) + ::oDbfVir:cSufFac + Str( ::oDbfVir:nNumRec )

   if edtRecCli( cNumeroRecibo )

      if ::oDbfDet:Seek( cNumeroRecibo )
         ::oDbfVir:Load()
         aeval( ::oDbfVir:aTField, {| oFld, n | ::oDbfVir:FldPut( n, ::oDbfDet:FieldGet( n ) ) } )
         ::oDbfVir:Save()
      end if 

   end if 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD Del()

   local lEstadoAnterior   := .f.

   if oUser():lNotConfirmDelete() .or. ApoloMsgNoYes("¿ Desea eliminar el registro en curso ?", "Confirme supresión" )

      lEstadoAnterior   := ApoloMsgNoYes("¿ Desea volver los recibos a su estado original ?", "Confirmación" )

      ::GetFirstKey()

      if !Empty( ::cFirstKey )
         while ::oDbfDet:Seek( ::cFirstKey )
            ::DelItem( lEstadoAnterior )
         end while
      end if

      ::oDbf:Delete()

   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD DelItem( lEstadoAnterior )

   local cNumFac              := ::oDbfDet:cSerie + Str( ::oDbfDet:nNumFac ) + ::oDbfDet:cSufFac

   DEFAULT  lEstadoAnterior   := .f.

   ::oDbfDet:FieldPutByName( "nNumRem", 0 )     
   ::oDbfDet:FieldPutByName( "cSufRem", "" )
   ::oDbfDet:FieldPutByName( "lRemesa", .f. )

   if lEstadoAnterior
      ::oDbfDet:FieldPutByName( "lCobrado", .f. )
   end if

   if ::oFacCliT:Seek( cNumFac )
      chkLqdFacCli( nil, ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::oDbfDet:cAlias, ::oAntCliT:cAlias, ::oIva:cAlias, ::oDivisas:cAlias )
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

METHOD contabilizaRemesas( lSimula )

   local nAsiento
   local cCuentaPago    := ""
   local cCuentaCliente := ""
   local cNombreCliente := ""
   local cTextoRemesa   := ""
   local aSimula        := {}
   local cCodPro        := cProCnt()
   local cRuta          := cRutCnt()
   local cTerNif        := Space(1)
   local cTerNom        := Space(1)
   local lErrorFound    := .f.
   local cCodEmp        := cCodEmpCnt( "A" )

	// Chequando antes de pasar a Contaplus-------------------------------------

   if ::oDbf:lConta
      if !ApoloMsgNoYes( "Remesa : " + ::cNumRem() + " contabilizada." + CRLF + "¿ Desea contabilizarla de nuevo ?" )
         return .f.
      end if
   end if

   if !::lChkSelect .and. !ChkRuta( cRutCnt() )
      ::oTreeSelect:Add( "Remesa : " + ::cNumRem() + " ruta no valida.", 0 )
      lErrorFound          := .t.
   end if

   // Seleccionamos las empresa dependiendo de la serie de factura-------------

   if empty( cCodEmp ) .and. !::lChkSelect
      ::oTreeSelect:Add( "Remesa : " + ::cNumRem() + " no se definierón empresas asociadas.", 0 )
      lErrorFound          := .t.
   end if

	// Estudio si existe cuenta pago--------------------------------------------

   if ::oDbf:nTipRem == 2
      cCuentaPago          := ::oCtaRem:cRetCtaDto( ::oDbf:cCodRem )
   else
      cCuentaPago          := ::oCtaRem:cRetCtaCon( ::oDbf:cCodRem )
   end if 

   if ::oDbf:nTipRem == 2 .and. !ChkSubcuenta( cRuta, cCodEmp, cCuentaPago, , .f., .f. )
      ::oTreeSelect:Add( "Cuenta : " + rtrim( cCuentaPago ) + " de pago remesa no existe.", 0 )
      lErrorFound          := .t.
   end if

   // Procesamos todos los recibos---------------------------------------------

   if ::oDbfDet:Seek( Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem )

      while Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem == Str( ::oDbfDet:nNumRem ) + ::oDbfDet:cSufRem .and. !::oDbfDet:eof()

         // Chequeo de cuentas de clientes-------------------------------------

         cCuentaCliente          := ""
         if ::oClientes:Seek( ::oDbfDet:cCodCli )
            if ::oDbf:nTipRem == 2
               cCuentaCliente    := ::oClientes:SubCtaDto
            else
               cCuentaCliente    := ::oClientes:SubCta
            end if
         end if 

         if !ChkSubcuenta( cRuta, cCodEmp, cCuentaCliente, , .f., .f. )
            ::oTreeSelect:Add( "Cliente : " + Rtrim( ::oClientes:Titulo ) + " cuenta cliente no existe.", 0 )
            lErrorFound    := .t.
         end if 

         ::oDbfDet:Skip()

      end while

   else

      ::oTreeSelect:Add( "Remesa : " + ::cNumRem() + " remesa sin recibos.", 0 )

      lErrorFound          := .t.

   end if

   // Comporbamos fechas-------------------------------------------------------

   if Empty( ::oDbf:dConta )
      ::oTreeSelect:Add( "Remesa : " + ::cNumRem() + " sin fecha de contabilización", 0 )
      lErrorFound          := .t.
   end if

   if !ChkFecha( , , ::oDbf:dConta, .f., ::oTreeSelect )
      lErrorFound          := .t.
   end if

   // Realización de Asientos--------------------------------------------------

   if OpenDiario( , cCodEmp )
      nAsiento             := contaplusUltimoAsiento()
   else
      ::oTreeSelect:Add( "Remesa : " + ::cNumRem() + " imposible abrir ficheros.", 0 )
      RETURN .F.
   end if

   if lAplicacionContaplus()

      aadd( aSimula, MkAsiento(  nAsiento, ;
                                 ::oDbf:cCodDiv,;
                                 ::oDbf:dConta,;
                                 cCuentaPago,;
                                 ,;
                                 ::nTotRem( .f. ),;
                                 "Remesa " + ::cNumRem(),;
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

      EnlaceA3():getInstance():Add( {  "Empresa"               => cCodEmp,;
                                       "Fecha"                 => ::oDbf:dConta,;
                                       "TipoRegistro"          => '0',; 
                                       "Cuenta"                => cCuentaPago,;
                                       "DescripcionCuenta"     => "Cobro remesa " + ::cNumRem(),;
                                       "TipoImporte"           => 'D',; 
                                       "ReferenciaDocumento"   => ::cNumRem(),;
                                       "DescripcionApunte"     => "Cobro remesa " + ::cNumRem(),;
                                       "Importe"               => ::nTotRem( .f. ),;
                                       "Moneda"                => 'E',; 
                                       "Render"                => 'ApuntesSinIVA' } )

   end if 

	// Asientos de Ventas-------------------------------------------------------

   if ::oDbfDet:Seek( Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem )

      while Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem == Str( ::oDbfDet:nNumRem ) + ::oDbfDet:cSufRem .and. !::oDbf:Eof()

         cCuentaCliente          := ""
         cNombreCliente          := ""

         if ::oClientes:Seek( ::oDbfDet:cCodCli )
            if ::oDbf:nTipRem == 2
               cCuentaCliente    := ::oClientes:SubCtaDto
            else
               cCuentaCliente    := ::oClientes:SubCta
            end if 
            cNombreCliente       := ::oClientes:Titulo
         end if

         if lAplicacionContaplus()

            aadd( aSimula, MkAsiento(  nAsiento, ;
                                       ::oDbf:cCodDiv,;
                                       ::oDbf:dConta,;
                                       cCuentaCliente,;
                                       ,;
                                       ,;
                                       "Remesa " + alltrim( ::cTextoRemesaContable() ) + ", Recibo " + ::oDbfDet:cSerie + "/" + alltrim( str( ::oDbfDet:nNumFac ) ) + "/" + ::oDbfDet:cSufFac + "-" + alltrim( str( ::oDbfDet:nNumRec ) ),;
                                       nTotRecCli( ::oDbfDet:cAlias, ::oDivisas:cAlias, ::oDbf:cCodDiv, .f. ),;
                                       ::oDbfDet:cSerie + str( ::oDbfDet:nNumFac ) + ::oDbfDet:cSufFac,;
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
      
            EnlaceA3():getInstance():Add( {  "Empresa"               => cCodEmp,;
                                             "Fecha"                 => ::oDbf:dConta,;
                                             "TipoRegistro"          => '0',; 
                                             "Cuenta"                => cCuentaCliente,;
                                             "DescripcionCuenta"     => cNombreCliente,;
                                             "TipoImporte"           => 'H',; 
                                             "ReferenciaDocumento"   => ::oDbfDet:cSerie + alltrim( str( ::oDbfDet:nNumFac ) ) ,; //::cNumRem(),;
                                             "DescripcionApunte"     => "Remesa " + alltrim( ::cNumRem() ) + ", Recibo " + ::oDbfDet:cSerie + "/" + alltrim( str( ::oDbfDet:nNumFac ) ) + "/" + ::oDbfDet:cSufFac + "-" + alltrim( str( ::oDbfDet:nNumRec ) ),;
                                             "Importe"               => nTotRecCli( ::oDbfDet:cAlias, ::oDivisas:cAlias, ::oDbf:cCodDiv, .f. ),;
                                             "Moneda"                => 'E',; 
                                             "Render"                => 'ApuntesSinIVA' } )

         end if 

         ::oDbfDet:Skip()

      end while

   end if

   // Ponemos la remesa como Contabilizada-------------------------------------

   if !lSimula .and. !lErrorFound

      ::cambiaEstadoContabilizadoRemesas( .t. )

      if lAplicacionA3()

         if EnlaceA3():getInstance():Render():writeASCII()
            ::oTreeSelect:Add( "Fichero " + ( EnlaceA3():getInstance():cDirectory + "\" + EnlaceA3():getInstance():cFile ) + " exportado con exito.", 1 )
         end if 
         
         EnlaceA3():getInstance():destroyInstance() 

      else
         
         ::oTreeSelect:Add( "Remesa : " + ::cNumRem() + " asiento generado num. " + alltrim( str( nAsiento ) ), 1 )

      end if 

   else

      msgTblCon( aSimula, ::oDbf:cCodDiv, ::oDivisas:cAlias, !lErrorFound, ::cNumRem(), {|| aWriteAsiento( aSimula, ::oDbf:cCodDiv, .t., ::oTreeSelect, ::cNumRem(), nAsiento ), ::cambiaEstadoContabilizadoRemesas( .t. ) } )

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

METHOD cambiaEstadoContabilizadoRemesas( lConta )

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
               RESOURCE "gc_book_telephone_16" ;
               ACTION   ( if( !Empty( ::oDbf:cCodRem ), ::oCtaRem:Edit(), MsgStop( "Cuenta vacía" ) ) )

            MENUITEM    "&2. Modificar recibo";
               MESSAGE  "Modificar el recibo seleccionado" ;
               RESOURCE "gc_briefcase2_user_16" ;
               ACTION   ( EdtRecCli( ::oDbfVir:cSerie + Str( ::oDbfVir:nNumFac ) + ::oDbfVir:cSufFac + Str( ::oDbfVir:nNumRec ) ) );

            MENUITEM    "&3. Visualizar recibo";
               MESSAGE  "Visualiza el recibo seleccionado" ;
               RESOURCE "gc_briefcase2_user_16" ;
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

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD InitSepa19( oDlg )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD InitSepaXML19( oDlg )

   local oBlock
   local oError

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::oTreeIncidencias:deleteAll()

      if ::lAgruparRecibos
         ::oDbfDet:OrdSetFocus( "nNumRem" )
      end if

      ::oCuaderno             := SepaXml():New( ::getFicheroExportacionXml() )

      ::oCuaderno:setScheme( ::cEsquema )
      ::oCuaderno:setSeqTp( ::cSequencia )
      ::oCuaderno:setOriginalMessageIdentification( id_File( 'REMESA' + alltrim( str( ::oDbf:nNumRem ) ) ) )
      ::oCuaderno:setPaymentInformationIdentification( alltrim( ::oCtaRem:oDbf:cNifPre ) + "." + ttos( datetime() ) )
      ::oCuaderno:setRequestedCollectionDate( sDate( ::getIngreso() ) )                  // Fecha de cobro (Vencimiento)

      // Presentador--------------------------------------------------------------

      ::InsertPresentadorXml()

      // Acreedor-----------------------------------------------------------------

      ::InsertAcreedorXml()

      // Recibos------------------------------------------------------------------
      
      if ::oDbfDet:Seek( Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem )

         while ( str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem == str( ::oDbfDet:nNumRem, 9 ) + ::oDbfDet:cSufRem ) .and. !( ::oDbfDet:eof() )

            ::InsertDeudorXml()

            ::oDbfDet:Skip()
            
         end while

      end if

      // Generacion------------------------------------------------------------
      
      ::oCuaderno:Activate()

      if !empty( ::oCuaderno:aErrors )
         aeval( ::oCuaderno:aErrors, {|error| ::oTreeIncidencias:add( error ) } )
      else 
         if file( ::oCuaderno:cFileOut ) .and. apoloMsgNoYes( "Proceso de exportación realizado." + CRLF + "¿ Desea abrir el fichero resultante ?", "Elija una opción." )
            shellExecute( 0, "open", ::oCuaderno:cFileOut, , , 1 )
         end if 
      end if 

      // Abrir fichero resultante----------------------------------------------

      if ::lAgruparRecibos
         ::oDbfDet:OrdSetFocus( "nNumRem" )
      end if

   RECOVER USING oError

      msgStop( "Error al generar remesa de recibos." + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD InsertPresentador()

   with object ( ::oCuaderno:GetPresentador() )
      :Sufijo(       ::oCtaRem:oDbf:cSufCta )
      :Nombre(       ::oCtaRem:oDbf:cNomPre )
      :Referencia(   ::cNumRem() )            
      :Nif(          ::oCtaRem:oDbf:cNifPre )
      :Entidad(      ::oCtaRem:oDbf:cEntPre )
      :Oficina(      ::oCtaRem:oDbf:cAgcPre )
   end with

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD InsertPresentadorXml()

   with object ( ::oCuaderno:oInitPart )
      :nEntity    := ENTIDAD_JURIDICA
      :Nm         := ::oCtaRem:oDbf:cNomPre
      :IBAN       := ::oCtaRem:oDbf:cPaisIBAN + ::oCtaRem:oDbf:cCtrlIBAN + ::oCtaRem:oDbf:cEntBan + ::oCtaRem:oDbf:cAgcBan + ::oCtaRem:oDbf:cDgcBan + ::oCtaRem:oDbf:cCtaBan
      :BICOrBEI   := getBIC( ::oCtaRem:oDbf:cEntPre )
      :id         := id_Name( ::oCtaRem:oDbf:cPaiPre, ::oCtaRem:oDbf:cSufCta, ::oCtaRem:oDbf:cNifPre )
      :Prtry      := "SEPA"
   end with

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD InsertAcreedor()

   with object ( ::oCuaderno:InsertAcreedor() )
      :FechaCobro(   ::oDbfDet:dFecVto )
      :Sufijo(       ::oCtaRem:oDbf:cSufCta )
      :Nombre(       ::oCtaRem:oDbf:cNomAcr )
      :Direccion(    ::oCtaRem:oDbf:cDirAcr )
      :CodigoPostal( ::oCtaRem:oDbf:cPosAcr )
      :Poblacion(    ::oCtaRem:oDbf:cPobAcr )
      :Provincia(    ::oCtaRem:oDbf:cProAcr )
      :Pais(         ::oCtaRem:oDbf:cPaiAcr )
      :Nif(          ::oCtaRem:oDbf:cNifPre )
      :CuentaIBAN(   ::bancoRemesa() )    
   end with

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD InsertAcreedorXml()

   with object ( ::oCuaderno:oCreditor )
      :nEntity    := ENTIDAD_JURIDICA
      :Nm         := ::oCtaRem:oDbf:cNomAcr
      :BICOrBEI   := getBIC( ::oCtaRem:oDbf:cEntPre )
      :Id         := id_Name( ::oCtaRem:oDbf:cPaiPre, ::oCtaRem:oDbf:cSufCta, ::oCtaRem:oDbf:cNifAcr )
   end with

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD InsertDeudor()

   with object ( ::oCuaderno:InsertDeudor() )
      :Sufijo(             ::oCtaRem:oDbf:cSufCta )
      :Referencia(         "RECIBO" + ::TextoDocumento() )
      :ReferenciaMandato(  ::IdDocumento() ) 
      :Importe(            ::ImporteDocumento() )
      :EntidadBIC(         ::GetBICClient() )
      :Nombre(             ::oClientes:Titulo )
      :Direccion(          ::oClientes:Domicilio )
      :CodigoPostal(       ::oClientes:CodPostal )
      :Poblacion(          ::oClientes:Poblacion )
      :Provincia(          ::oClientes:Provincia )
      :Nif(                ::oClientes:Nif )
      :CuentaIBAN(         ::GetValidCuentaCliente() )
      :Concepto(           "FACTURA Nº" + ::TextoDocumento() ) 
   end with

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD InsertDeudorXml()

   local oDebtor     

   if !::oClientes:Seek( ::oDbfDet:cCodCli )
      ::oCuaderno:addError( "Código del cliente " + rtrim( ::oDbfDet:cCodCli ) + ", no existe." )
      RETURN ( Self )
   end if 

   if empty( ::GetValidCuentaCliente() )
      ::oCuaderno:addError( "Cuenta bancaria invalida, para el cliente " + rtrim( ::oDbfDet:cCodCli ) + ", en el recibo " + ::oDbfDet:cSerie + "/" + alltrim( str( ::oDbfDet:nNumFac ) ) + "-" + alltrim( str( ::oDbfDet:nNumRec ) ) )
      RETURN ( Self )
   end if 

   if empty( ::oCtaRem:dFechaFirma( ::oDbf:cCodRem ) )
      ::oCuaderno:addError( "Fecha de firma esta vacía en cuenta de remesa" )
      RETURN ( Self )
   end if 

   oDebtor              := SepaDebitActor():New( ::oCuaderno, "Dbtr" )
   oDebtor:nEntity      := ENTIDAD_JURIDICA
   oDebtor:Nm           := ::oClientes:Titulo 
   oDebtor:Id           := ::oClientes:Nif 
   oDebtor:InstdAmt     := ::ImporteDocumento()                                        // Importe
   oDebtor:ReqdColltnDt := sDate( ::oDbf:dExport )                                     // Fecha de cobro (Vencimiento)
   oDebtor:IBAN         := ::GetValidCuentaCliente()
   oDebtor:BICOrBEI     := ::GetBICClient()
   oDebtor:MndtId       := hb_md5( alltrim( ::oClientes:Nif ) + ttos( datetime() ) )   // hb_md5( ::oCuaderno:oCreditor:Id + :id )  // Identificación del mandato, idea: Utilizar NIF Acreedor + NIF Deudor 
   oDebtor:DtOfSgntr    := sDate( ::oCtaRem:dFechaFirma( ::oDbf:cCodRem ) )            // Fecha de firma 
   oDebtor:EndToEndId   := "Recibo " + ::TextoDocumento()

   ::oCuaderno:addDebtor( oDebtor )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ChangeExport()

   if ::oDbf:lExport
      ::oDbf:dExport    := GetSysDate()
   else
      ::oDbf:dExport    := Ctod( "" )
   end if

   ::oFecExp:Refresh()

RETURN .t.

//---------------------------------------------------------------------------//

METHOD getSerieRecibos()

   local cSerieRecibo   := ''

   if ::oDbfDet:Seek( Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem )
      cSerieRecibo      := ::oDbfDet:cSerie
   end if 

RETURN ( cSerieRecibo )   

//---------------------------------------------------------------------------//

METHOD getFicheroExportacion()

   local cFicheroExportacion  := ::getDirectorioExportacion()

   if ( rat( "\", cFicheroExportacion ) == 0 )
      cFicheroExportacion     += "\"
   end if 

   cFicheroExportacion        += "Remesa" + alltrim( str( ::oDbf:nNumRem, 9 ) ) + "-" + ::oDbf:cSufRem 
   cFicheroExportacion        := padr( cFicheroExportacion, 200 )

Return ( cFicheroExportacion )

//---------------------------------------------------------------------------//

METHOD getDirectorioExportacion()

   local cDirectory  := getPvProfString( "main", "Directorio SEPA", "", cIniAplication() )

   if empty( cDirectory )  
      cDirectory     := "C:\Sepa"
   end if 

   cDirectory        := cpath( cDirectory )

RETURN ( cDirectory ) 

//---------------------------------------------------------------------------//

METHOD setDirectorioExportacion()

   local cDirectory  := cOnlyPath( ::cFicheroExportacion )

   if !empty( cDirectory )
      writePProString( "main", "Directorio SEPA", cDirectory, cIniAplication() )   
   end if 

RETURN ( cDirectory )   

//---------------------------------------------------------------------------//

METHOD setEstadosRecibos( lCobrado )

   local nSelect

   for each nSelect in ::oBrwDet:aSelected
      
      ::oDbfVir:goto( nSelect )
      
      if ::gotoRecibo()
         ::setEstadoRecibo( lCobrado, .f. )
         ::oBrwDet:Refresh()
      end if 

   next

RETURN ( nil )   

//---------------------------------------------------------------------------//

METHOD setCancelar( nMode )

   ::oDbfVir:gotop()

   while !::oDbfVir:Eof()

      if ::gotoRecibo()
         ::setEstadoRecibo( ::oDbfVir:lCobrado, .f., .t. )
      end if

      ::oDbfVir:Skip()

   end while

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD DeleteDet( lMessage )

   DEFAULT lMessage  := .t.

   if ::oDbfVir:Recno() == 0
      RETURN ( Self )
   end if

   if oUser():lNotConfirmDelete() .or. if( lMessage, ApoloMsgNoYes("¿ Desea eliminar definitivamente este registro ?", "Confirme supersión" ), .t. )

      if ::gotoRecibo()
         ::setEstadoRecibo( .f., .t. )
         ::setEstadoFactura()
      end if

      ::oDbfVir:Delete( .t. )

      if ::bOnPostDeleteDetail != nil
         Eval( ::bOnPostDeleteDetail, Self )
      end if

      if( ::oBrwDet != nil, ::oBrwDet:Refresh(), )

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD setEstadoFactura()

   local nNumFac     
   local nOrdFac
   local nRecFac
   local nRecRec

   nNumFac        := ::oDbfDet:cSerie + Str( ::oDbfDet:nNumFac ) + ::oDbfDet:cSufFac

   nRecRec        := ::oDbfDet:Recno()

   nRecFac        := ::oFacCliT:Recno()
   nOrdFac        := ::oFacCliT:OrdSetFocus( "nNumFac" )

   if ::oFacCliT:Seek( nNumFac )
      ChkLqdFacCli( nil, ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::oDbfDet:cAlias, ::oAntCliT:cAlias, ::oIva:cAlias, ::oDivisas:cAlias )
   end if

   ::oFacCliT:OrdSetFocus( nOrdFac )
   ::oFacCliT:GoTo( nRecFac )
   ::oDbfDet:GoTo( nRecRec )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD SetOrdenNumeroRemesa()

   ::nRecAnterior       := ::oDbf:Recno()
   ::cOrdenAnterior     := ::oDbf:OrdSetFocus( "nNumRem" )

Return ( self )

//---------------------------------------------------------------------------//

METHOD RestoreOrdenNumeroRemesa()

   ::oDbf:OrdSetFocus( ::cOrdenAnterior )
   ::oDbf:GoTo( ::nRecAnterior )

Return ( self )

//---------------------------------------------------------------------------//

FUNCTION lValidRemesaCliente( oGetRemesaCliente, oDbfRemesaCliente )

   local lValid   := .f.
   local xValor   := oGetRemesaCliente:varGet()

   if empty( xValor )
      return .t.
   end if

   if oDbfRemesaCliente:SeekInOrd( xValor, "nNumRem" )
      lValid      := .t.
   else
      msgStop( "Remesa no encontrada" )
   end if

RETURN lValid

//---------------------------------------------------------------------------//


