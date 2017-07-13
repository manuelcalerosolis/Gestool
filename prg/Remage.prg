#include "FiveWin.Ch"
#include "MesDbf.ch"
#include "Factu.ch" 
#include "Report.ch"

//---------------------------------------------------------------------------//

CLASS TRemAge FROM TMasDet

   DATA  oCuentasRemesa
   DATA  oAgentes
   DATA  oFacCliT
   DATA  oFacCliL
   DATA  oRecibos
   DATA  oClientes
   DATA  oBandera
   DATA  oFPago
   DATA  cPorDiv
   DATA  bmpConta
   DATA  bmpPagado
   DATA  oMeter      AS OBJECT
   DATA  nMeter      AS NUMERIC  INIT 0
   DATA  aMsg        AS ARRAY    INIT {}

   DATA  oNumRec
   DATA  oCodCli
   DATA  oNomCli
   DATA  oDescrip
   DATA  oPgdoPor
   DATA  oImporte
   DATA  oDivPgo
   DATA  oVdvPgo
   DATA  oImpCob
   DATA  oImpGas
   DATA  oCtaRec
   DATA  oCtaGas
   DATA  oCtaRem

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

   /*
   Metodos redefinidos
   */

   METHOD SaveDetails()

   METHOD Del()
   METHOD DelItem()

   METHOD nTotRem( lPic )
   METHOD nTotRemVir( lPic )

   METHOD Report()

   METHOD GetNewCount()
   METHOD PutNewCount()

   METHOD Detalle( nMode )

   METHOD LoaRec()

   METHOD BrwRecCli()

   METHOD lNowExist()

   METHOD Conta()

   METHOD ValCobro()

   METHOD Report()         INLINE   InfRemAge( ::oDbf, ::oDbfDet, ::oClientes, ::oAgentes, ::oDbfDiv ), ::oWndBrw:Refresh()

   METHOD ChgConta( lCnt ) INLINE   ::oDbf:Load(), ::oDbf:lConta := lCnt, ::oDbf:Save(), ::oWndBrw:Refresh()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( cPath, oMenuItem, oWndParent )

   DEFAULT cPath        := cPatEmp()
   DEFAULT oWndParent   := GetWndFrame()
   DEFAULT oMenuItem    := "01037"

   ::nLevel             := nLevelUsr( oMenuItem )

   ::cPath              := cPath
   ::oWndParent         := oWndParent
   ::oDbf               := nil
   ::oDbfDet            := nil
   ::oDbfDiv            := nil
   ::oBandera           := nil
   ::bmpConta           := LoadBitmap( GetResources(), "BCONTA" )
   ::bmpPagado          := LoadBitmap( GetResources(), "BGREEN" )

   ::cNumDocKey         := "nNumCob"
   ::cSufDocKey         := "cSufCob"

   ::bFirstKey          := {|| Str( ::oDbf:nNumCob, 9 ) + ::oDbf:cSufCob }
   ::bWhile             := {|| Str( ::oDbf:nNumCob, 9 ) + ::oDbf:cSufCob == Str( ::oDbfDet:nNumCob, 9 ) + ::oDbfDet:cSufCob }

   ::oCuentasRemesa     := TCtaRem():Create( cPatCli() )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE DATABASE ::oDbf FILE "REMAGET.DBF" CLASS "COBAGE" ALIAS "COBAGE" PATH ( cPath ) VIA ( cDriver ) COMMENT  "Remesas de cobros por agentes"

   FIELD NAME "lConta"     TYPE "L" LEN   1 DEC  0                      COMMENT ""                                                                                                HIDE OF ::oDbf
   FIELD CALCULATE NAME "bmpConta"  LEN   1 DEC  0                      COMMENT "C"       VAL ( if( ::oDbf:lConta, ::bmpConta, "" ) )                                 COLSIZE  16      OF ::oDbf
   FIELD NAME "NNUMCOB"    TYPE "N" LEN   9 DEC  0 PICTURE "999999999"  COMMENT ""                                                                                                HIDE OF ::oDbf
   FIELD NAME "CSUFCOB"    TYPE "C" LEN   2 DEC  0 PICTURE "@!"         COMMENT ""                                                                                                HIDE OF ::oDbf
   FIELD CALCULATE NAME "cNumCob"   LEN  12 DEC  0                      COMMENT "Número"  VAL ( str( ::oDbf:nNumCob ) + "/" + ::oDbf:cSufCob )                        COLSIZE  80      OF ::oDbf
   FIELD NAME "DFECCOB"    TYPE "D" LEN   8 DEC  0 DEFAULT GetSysDate() COMMENT "Fecha"                                                                               COLSIZE  80      OF ::oDbf
   FIELD NAME "CCODAGE"    TYPE "C" LEN   3 DEC  0                      COMMENT "Cod."                                                                                COLSIZE  40      OF ::oDbf
   FIELD CALCULATE NAME "cNomAge"   LEN  50 DEC  0                      COMMENT "Agente"  VAL cNbrAgent( ::oDbf:cCodAge, ::oAgentes:cAlias )                          COLSIZE 350      OF ::oDbf
   FIELD NAME "CCODDIV"    TYPE "C" LEN   3 DEC  0                      COMMENT ""                                                                                                HIDE OF ::oDbf
   FIELD NAME "NVDVDIV"    TYPE "N" LEN  10 DEC  6                      COMMENT ""                                                                                                HIDE OF ::oDbf
   FIELD CALCULATE NAME "nTotCob"   LEN  16 DEC  6                      COMMENT "Importe" VAL ::nTotRem( .t. )                                         ALIGN RIGHT    COLSIZE 100      OF ::oDbf

   INDEX TO "REMAGET.Cdx" TAG "nNumCob"  ON "Str( nNumCob ) + cSufCob" COMMENT "Número"   NODELETED OF ::oDbf
   INDEX TO "REMAGET.Cdx" TAG "cCodAge"  ON "cCodAge"                  COMMENT "Agente"   NODELETED OF ::oDbf
   INDEX TO "REMAGET.Cdx" TAG "dFecCob"  ON "dFecCob"                  COMMENT "Fecha"    NODELETED OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//----------------------------------------------------------------------------//

METHOD DefineDetails( cPath, cVia, lUniqueName, cFileName )

   local oDbf

   DEFAULT cPath        := ::cPath
   DEFAULT cVia         := cDriver()
   DEFAULT lUniqueName  := .f.
   DEFAULT cFileName    := "FacCliP"

   if lUniqueName
      cFileName         := cGetNewFileName( cFileName, , , cPatTmp() )
   end if

   DEFINE TABLE oDbf FILE ( cFileName ) CLASS ( cFileName ) ALIAS ( cFileName ) PATH ( cPath ) VIA ( cVia )

      FIELD NAME "cSerie"    TYPE "C" LEN   1 DEC 0 OF oDbf
      FIELD NAME "nNumFac"   TYPE "N" LEN   9 DEC 0 OF oDbf
      FIELD NAME "cSufFac"   TYPE "C" LEN   2 DEC 0 OF oDbf
      FIELD NAME "nNumRec"   TYPE "N" LEN   2 DEC 0 OF oDbf
      FIELD NAME "cCodCaj"   TYPE "C" LEN   3 DEC 0 OF oDbf
      FIELD NAME "cTurRec"   TYPE "C" LEN   6 DEC 0 OF oDbf
      FIELD NAME "cCodCli"   TYPE "C" LEN  12 DEC 0 OF oDbf
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

      INDEX TO ( cFileName ) TAG "nNumFac"   ON "cSerie + Str( nNumFac ) + cSufFac + Str( nNumRec )"  NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "cCodCli"   ON "cCodCli"                                             NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "dEntrada"  ON "dEntrada"                                            NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "lNumFac"   ON "cSerie + Str( nNumFac ) + cSufFac + Str( nNumRec )"  NODELETED FOR "!lCobrado" OF oDbf
      INDEX TO ( cFileName ) TAG "nImporte"  ON "nImporte"                                            NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "nNumRem"   ON "Str( nNumRem ) + cSufRem + cCodCli"                  NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "cCtaRem"   ON "cCtaRem"                                             NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "cCodAge"   ON "cCodAge"                                             NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "nNumCob"   ON "Str( nNumCob ) + cSufCob"                            NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "cTurRec"   ON "cTurRec + cSufFac + cCodCaj"                         NODELETED OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//---------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive )

   local lOpen    := .t.
   local oBlock   := ErrorBlock( { | oError | Break( oError ) } )

   DEFAULT lExclusive   := .f.

   BEGIN SEQUENCE

   if Empty( ::oDbf )
      ::DefineFiles()
   end if

   ::oDbf:Activate( .f., !( lExclusive ), .f., .f. )

   if Empty( ::oDbfDet )
      ::oDbfDet         := ::DefineDetails()
   end if

   ::oDbfDet:Activate( .f., !( lExclusive ) )
   ::oDbfDet:OrdSetFocus( "nNumCob" )

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL    FILE "FACCLIL.DBF"   PATH ( ::cPath ) VIA ( cDriver() )SHARED INDEX  "FACCLIL.CDX"

   DATABASE NEW ::oDbfDiv     FILE "DIVISAS.DBF"   PATH (cPatDat()) VIA ( cDriver() )SHARED INDEX "DIVISAS.CDX"

   DATABASE NEW ::oClientes   FILE "CLIENT.DBF"    PATH ( cPatCli() ) VIA ( cDriver() )SHARED INDEX "CLIENT.CDX"

   DATABASE NEW ::oAgentes    FILE "AGENTES.DBF"   PATH ( cPatCli() ) VIA ( cDriver() )SHARED INDEX "AGENTES.CDX"

   DATABASE NEW ::oFPago      FILE "FPAGO.DBF"     PATH ( cPatEmp() ) VIA ( cDriver() )SHARED INDEX "FPAGO.CDX"

   ::oCuentasRemesa:OpenFiles()

   ::oBandera           := TBandera():New

   /*
   Definicion del master-------------------------------------------------------
   */

   ::oDbf:bOpenError    := { || ::OpenError() }

   ::lLoadDivisa()

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oDbf ) .and. ::oDbf:Used()
      ::oDbf:End()
   end if

   if !Empty( ::oDbfDet ) .and. ::oDbfDet:Used()
      ::oDbfDet:End()
   end if

   if ::oAgentes != nil .and. ::oAgentes:Used()
      ::oAgentes:End()
   end if

   if ::oFacCliT != nil .and. ::oFacCliT:Used()
      ::oFacCliT:End()
   end if

   if ::oFacCliL != nil .and. ::oFacCliL:Used()
      ::oFacCliL:End()
   end if

   if ::oDbfDiv != nil .and. ::oDbfDiv:Used()
      ::oDbfDiv:End()
   end if

   if ::oClientes != nil .and. ::oClientes:Used()
      ::oClientes:End()
   end if

   if ::oFPago != nil .and. ::oFPago:Used()
      ::oFPago:End()
   end if

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:End()
   end if

   if ::oCuentasRemesa != nil
      ::oCuentasRemesa:End()
   end if

   ::oAgentes        := nil
   ::oFacCliT        := nil
   ::oFacCliL        := nil
   ::oDbfDet         := nil
   ::oDbfDiv         := nil
   ::oClientes       := nil
   ::oFPago          := nil
   ::oDbf            := nil
   ::oCuentasRemesa  := nil

   DeleteObject( ::bmpConta  )
   DeleteObject( ::bmpPagado )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD Activate()

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

      ::oWndBrw:GralButtons( Self )

      DEFINE BTNSHELL RESOURCE "CHGSTATE" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::SelectRec( {|| ::ChgConta( ::lChkSelect ) }, "Cambiar estado", "Contabilizado" , .f. ) ) ;
         TOOLTIP  "Ca(m)biar estado" ;
         HOTKEY   "M";
         LEVEL    4

      DEFINE BTNSHELL RESOURCE "BMPCONTA" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::SelectRec( {|| ::Conta( ::lChkSelect ) }, "Contabilizar remesas", "Simular" , .f. ) ) ;
         TOOLTIP  "(C)ontabilizar" ;
         HOTKEY   "C";
         LEVEL    4

      ::oWndBrw:EndButtons( ::oWndBrw )

      ::oWndBrw:Activate(  nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,;
                           nil, nil, nil, nil, {|| ::CloseFiles() }, nil, nil )

   else

      msgStop( "Acceso no permitido." )

   end if

RETURN NIL

//----------------------------------------------------------------------------//

METHOD OpenService( lExclusive, cPath )

   local lOpen          := .t.
   local oBlock

   DEFAULT lExclusive   := .f.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

   RECOVER

      lOpen             := .f.

      ::CloseFiles()

      msgStop( "Imposible abrir todas las bases de datos de remesas." )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseService()

   if !Empt( ::oDbf )
      ::oDbf:End()
   endif

   ::oDbf   := nil

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD Resource( nMode )

   local oDlg
   local oSay
   local This        := Self
   local cSay        := ""
   local oCodAge
   local oBmpDiv

   ::oDbf:GetStatus()

   if nMode == APPD_MODE
      ::oDbf:cCodDiv := cDivEmp()
      ::oDbf:nVdvDiv := nChgDiv( cDivEmp(), ::oDbfDiv )
   end if

   DEFINE DIALOG oDlg RESOURCE "CobAge" TITLE LblTitle( nMode ) + "cobros de agentes"

      REDEFINE GET ::oDbf:nNumCob ;
			ID 		100 ;
         WHEN     ( .f. ) ;
         PICTURE  ::oDbf:FieldByName( "nNumCob" ):cPict ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cSufCob ;
			ID 		110 ;
         WHEN     ( .f. ) ;
         PICTURE  ::oDbf:FieldByName( "cSufCob" ):cPict ;
         OF       oDlg

      REDEFINE GET ::oDbf:dFecCob ;
         ID       120 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET oCodAge VAR ::oDbf:cCodAge UPDATE ;
         ID       130 ;
         WHEN     ( nMode == APPD_MODE ) ;
         VALID    ( cAgentes( oCodAge, This:oAgentes:cAlias, oSay ) );
         PICTURE  ::oDbf:FieldByName( "cCodAge" ):cPict ;
         ON HELP  ( BrwAgentes( oCodAge, oSay ), .t. );
         BITMAP   "LUPA" ;
			OF 		oDlg

      REDEFINE GET oSay VAR cSay UPDATE ;
         ID       131 ;
         WHEN     ( .f. ) ;
			OF 		oDlg

      ::oDefDiv( 140, 141, 142, oDlg, nMode )

       /*
       Botones de acceso________________________________________________________________
       */

      REDEFINE BUTTON ;
			ID 		500 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::AppendDet() )

      REDEFINE BUTTON ;
         ID       501 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::EditDet() )

		REDEFINE BUTTON ;
			ID 		502 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::DeleteDet() )

      REDEFINE IBROWSE ::oBrwDet ;
			FIELDS ;
                  ::oDbfVir:cSerie + "/" + Alltrim( Str( ::oDbfVir:nNumFac ) ) + "/" + ::oDbfVir:cSufFac + "-" + Str( ::oDbfVir:nNumRec ),;
                  DtoC( ::oDbfVir:dPreCob ),;
                  ::oDbfVir:cCodCli + Space( 1 ) + RetClient( ::oDbfVir:cCodCli, ::oClientes:cAlias ),;
                  hBmpDiv( ::oDbfVir:cDivPgo, ::oDbfDiv:cAlias, ::oBandera ),;
                  Trans( nTotRecCli( ::oDbfVir, ::oDbfDiv:cAlias, cDivEmp() ), ::cPorDiv ) ;
         FIELDSIZES ;
                  100,;
                  70,;
                  240,;
                  25,;
                  90 ;
         HEAD ;
                  "Número",;
                  "Exped.",;
                  "Cliente",;
                  "Div.",;
                  "Importe" ;
         JUSTIFY  .f., .f., .f., .f., .t. ;
         ID       150 ;
         OF       oDlg

         ::oBrwDet:bGoTop        := { || ::oDbfVir:GoTop() }
         ::oBrwDet:bGoBottom     := { || ::oDbfVir:GoBottom() }
         ::oBrwDet:bSkip         := { | n | ::oDbfVir:Skipper( n ) }
         ::oBrwDet:bLogicLen     := { || ::oDbfVir:LastRec() }

         ::oBrwDet:bLDblClick    := {|| ::EditDet() }
         ::oBrwDet:aIntColFoot   := { "", "" , "", "", {|| ::nTotRemVir( .t. ) } }
         ::oBrwDet:lDrawFooters  := .t.

         if nMode != ZOOM_MODE
            ::oBrwDet:bAdd       := {|| ::AppendDet() }
            ::oBrwDet:bMod       := {|| ::EditDet() }
            ::oBrwDet:bDel       := {|| ::DeleteDet() }
         end if

         ::oBrwDet:cWndName      := "Linea de cobro agente detalle"

         ::oBrwDet:LoadData()

REDEFINE APOLOMETER ::oMeter VAR ::nMeter ;
         ID       160 ;
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
         ACTION   ( HtmlHelp( "Cobros de agentes" ) )

   ACTIVATE DIALOG oDlg CENTER

   ::oDbf:SetStatus()

   /*
    Guardamos los datos del browse
   */

   ::oBrwDet:CloseData()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD lSave( nMode )

   local lReturn  := .t.

   if nMode == APPD_MODE

      if Empty( ::oDbf:cCodAge )
         MsgStop( "El código de agente no puede estar vacio." )
         lReturn  := .f.
      end if

   end if

RETURN ( lReturn )

//---------------------------------------------------------------------------//

METHOD LoaRec( cNumRec )

   local lLoaRec

   if Empty( SubStr( cNumRec, 1, 1 ) )
      return .f.
   end if

   if ::lNowExist( cNumRec )
      msgStop( "Recibo ya incluido en remesa." )
      return ( .f. )
   end if

   ::oDbfDet:GetStatus()
   ::oDbfDet:OrdSetFocus( "nNumFac" )

   if ::oDbfDet:Seek( cNumRec )

      if !Empty( ::oDbfDet:nNumCob )

         msgStop( "Recibo ya incluido en remesa nº " + alltrim( str( ::oDbfDet:nNumCob ) ) )
         lLoaRec              := .f.

      else

         ::oDbfVir:cSerie     := ::oDbfDet:cSerie
         ::oDbfVir:nNumFac    := ::oDbfDet:nNumFac
         ::oDbfVir:cSufFac    := ::oDbfDet:cSufFac
         ::oDbfVir:nNumRec    := ::oDbfDet:nNumRec
         ::oDbfVir:dPreCob    := ::oDbfDet:dPreCob

         ::oCodCli:cText( ::oDbfDet:cCodCli )
         ::oNomCli:cText( RetClient( ::oDbfVir:cCodCli, ::oClientes:cAlias ) )
         ::oDescrip:cText( ::oDbfDet:cDescrip )
         ::oPgdoPor:cText( ::oDbfDet:cPgdoPor )
         ::oImporte:cText( ::oDbfDet:nImporte )
         ::oDivPgo:cText( ::oDbfDet:cDivPgo )
         ::oVdvPgo:cText( ::oDbfDet:nVdvPgo )
         ::oImpCob:cText( ::oDbfDet:nImpCob )
         ::oImpGas:cText( ::oDbfDet:nImpGas )

         lLoaRec              := .t.

      end if

   else

      MsgStop( "Número de recibo no encontrado." )
      lLoaRec              := .f.

   end if

   ::oDbfDet:SetStatus()

   msgStop( ::oDbfDet:OrdSetFocus(), "despues" )

RETURN ( lLoaRec )

//--------------------------------------------------------------------------//

METHOD Detalle( nMode )

   local oDlg
   local cNumRec
   local oNomCli
   local cNomCli        := ""
   local oBmpDiv
   local oGetSubGas
   local cGetSubGas
   local oGetCtaRem
   local cGetCtaRem
   local oGetSubCta
   local cGetSubCta

   local This           := Self

   if nMode == APPD_MODE
      ::oDbfVir:nNumCob := ::oDbf:nNumCob
      ::oDbfVir:cSufCob := ::oDbf:cSufCob
      ::oDbfVir:cCodAge := ::oDbf:cCodAge
   end if

   cNumRec              := ::oDbfVir:cSerie + Str( ::oDbfVir:nNumFac ) + ::oDbfVir:cSufFac + Str( ::oDbfVir:nNumRec )

   DEFINE DIALOG oDlg RESOURCE "LCOBREC" TITLE lblTitle( nMode ) + "recibos de facturas"

      REDEFINE GET ::oNumRec VAR cNumRec ;
			ID 		100 ;
         PICTURE  "@R! A/#########/##-##" ;
			WHEN 		( nMode == APPD_MODE ) ;
         BITMAP   "LUPA" ;
         OF       oDlg
      ::oNumRec:bValid  := {|| ::LoaRec( cNumRec ) }
      ::oNumRec:bHelp   := {|| ::BrwRecCli() }

      REDEFINE GET ::oCodCli VAR ::oDbfVir:cCodCli ;
         ID       110 ;
         UPDATE ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE GET ::oNomCli VAR cNomCli ;
         ID       111 ;
         WHEN     ( .f. ) ;
         UPDATE ;
         OF       oDlg

      REDEFINE GET ::oDescrip VAR ::oDbfVir:cDescrip ;
         ID       130 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         UPDATE ;
         OF       oDlg

      REDEFINE GET ::oPgdoPor VAR ::oDbfVir:cPgdoPor ;
         ID       140 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         UPDATE ;
         OF       oDlg

      REDEFINE GET ::oImporte VAR ::oDbfVir:nImporte ;
         ID       150 ;
         WHEN     ( .f. ) ;
         PICTURE  ( ::cPorDiv ) ;
         UPDATE ;
         OF       oDlg

      REDEFINE GET ::oDivPgo VAR ::oDbfVir:cDivPgo;
         WHEN     ( .f. ) ;
         PICTURE  "@!";
         ID       151 ;
         BITMAP   "LUPA" ;
         OF       oDlg
      ::oDivPgo:bValid  := {|| cDivOut( ::oDivPgo, oBmpDiv, ::oVdvPgo, nil, nil, nil, nil, nil, nil, nil, ::oDbfDiv:cAlias, ::oBandera ), .t. }
      ::oDivPgo:bHelp   := {|| BrwDiv( ::oDivPgo, oBmpDiv, ::oVdvPgo, ::oDbfDiv:cAlias, ::oBandera ) }

      REDEFINE BITMAP oBmpDiv ;
         RESOURCE "BAN_EURO" ;
         ID       152;
         OF       oDlg

      REDEFINE GET ::oVdvPgo VAR ::oDbfVir:nVdvPgo;
         WHEN     ( .f. ) ;
         ID       153 ;
         PICTURE  "@E 999,999.9999" ;
         UPDATE ;
         OF       oDlg

      REDEFINE GET ::oImpCob VAR ::oDbfVir:nImpCob ;
         ID       160 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( ::ValCobro() ) ;
         PICTURE  ( ::cPorDiv ) ;
         UPDATE ;
         OF       oDlg

      REDEFINE GET ::oImpGas VAR ::oDbfVir:nImpGas ;
         ID       170 ;
         WHEN     ( .f. ) ;
         PICTURE  ( ::cPorDiv ) ;
         UPDATE ;
         OF       oDlg

      REDEFINE GET ::oCtaRec VAR ::oDbfVir:cCtaRec ;
         ID       240 ;
         PICTURE  ( Replicate( "X", RetLenSubCta() + 3 ) ) ;
			WHEN 		( RetLenSubCta() != 0 .AND. nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         OF       oDlg
      ::oCtaRec:bHelp    := {|| BrwChkSubcuenta( ::oCtaRec, oGetSubCta ) }
      ::oCtaRec:bValid   := {|| MkSubcuenta( ::oCtaRec, nil, oGetSubCta ) }

      REDEFINE GET oGetSubCta VAR cGetSubCta ;
         ID       241 ;
         WHEN     .f. ;
         OF       oDlg

      REDEFINE GET ::oCtaGas VAR ::oDbfVir:cCtaGas ;
         ID       270 ;
         PICTURE  ( Replicate( "X", RetLenSubCta() + 3 ) ) ;
			WHEN 		( RetLenSubCta() != 0 .AND. nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         OF       oDlg
      ::oCtaGas:bHelp      := {|| BrwChkSubcuenta( ::oCtaGas, oGetSubGas ) }
      ::oCtaGas:bValid     := {|| MkSubcuenta( ::oCtaGas, nil, oGetSubGas ) }

      REDEFINE GET oGetSubGas VAR cGetSubGas ;
         ID       271 ;
         WHEN     .f. ;
         OF       oDlg

      REDEFINE GET ::oCtaRem VAR ::oDbfVir:cCtaRem ;
         ID       250 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         OF       oDlg
      ::oCtaRem:bValid     := {|| oGetCtaRem:cText( RetFld( ::oDbfVir:cCtaRem, ::oCuentasRemesa:GetAlias() ) ), .t. }
      ::oCtaRem:bHelp      := {|| ::oCuentasRemesa:Buscar( ::oCtaRem ) }

      REDEFINE GET oGetCtaRem VAR cGetCtaRem ;
         ID       251 ;
         WHEN     .f. ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
			ACTION 	( oDlg:end() )

   oDlg:bStart    := {|| ::oCtaRec:lValid(), ::oCtaGas:lValid(), ::oCtaRem:lValid() }

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

METHOD SaveDetails()

   ::oDbfDet:OrdSetFocus( "nNumFac" )

   /*
   Ponemos todos los recibos con su cuenta de remesa
   */

   ::oDbfVir:GoTop()
   while !::oDbfVir:Eof()

      if ::oDbfDet:Seek( ::oDbfVir:cSerie + Str( ::oDbfVir:nNumFac, 9 ) + ::oDbfVir:cSufFac + Str( ::oDbfVir:nNumRec, 2 ) )

         ::oDbfDet:Load()

         ::oDbfDet:cCodAge    := ::oDbf:cCodAge
         ::oDbfDet:nNumCob    := ::oDbf:nNumCob
         ::oDbfDet:cSufCob    := ::oDbf:cSufCob
         ::oDbfDet:dEntrada   := ::oDbf:dFecCob
         ::oDbfDet:nImpCob    := ::oDbfVir:nImpCob
         ::oDbfDet:nImpGas    := ::oDbfVir:nImpGas
         ::oDbfDet:cCtaRec    := ::oDbfVir:cCtaRec
         ::oDbfDet:cCtaGas    := ::oDbfVir:cCtaGas
         ::oDbfDet:cCtaRem    := ::oDbfVir:cCtaRem
         ::oDbfDet:lCobrado   := .t.

         ::oDbfDet:Save()

      end if

      ::oDbfVir:Skip()

   end while

   ::oDbfDet:OrdSetFocus( "nNumCob" )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD BrwRecCli()

	local oDlg
   local oBrw
   local oFlt
   local oGet1
   local cGet1
   local nOrd        := GetBrwOpt( "BrwRecCli" )
   local oCbxOrd
   local aCbxOrd     := { "Número", "Cliente", "Fecha", "Cobrado", "Importe", "Remesa", "Cuenta remesa", "Agente" }
   local cCbxOrd
   local This        := Self

   nOrd              := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd           := aCbxOrd[ nOrd ]

   msgStop( ::oDbfDet:OrdSetFocus(), "antes brwreccli" )

   ::oDbfDet:GetStatus()
   ::oDbfDet:OrdSetFocus( "NNUMFAC" )

   oFlt              := TFilter():New( ::oDbfDet, "Filter", {|| ::oDbfDet:nNumCob == 0 .and. !::oDbfDet:lCobrado }, "::oDbfDet:nNumCob == 0 .and. !::oDbfDet:lCobrado" )

   ::oDbfDet:SetFilter( oFlt )
   ::oDbfDet:GoTop()

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Recibos de clientes"

		REDEFINE GET oGet1 VAR cGet1;
			ID 		104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, This:oDbfDet:cAlias ) );
         VALID    ( OrdClearScope( oBrw, This:oDbfDet:cAlias ) );
         BITMAP   "FIND" ;
         OF       oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( This:oDbfDet:OrdSetFocus( oCbxOrd:nAt ), oBrw:refresh(), oGet1:SetFocus() ) ;
			OF 		oDlg

      REDEFINE LISTBOX oBrw ;
          FIELDS;
                  If( ::oDbfDet:lCobrado, ::bmpPagado, "" ) ,;
                  ::oDbfDet:cSerie + "/" + Str( ::oDbfDet:nNumFac ) + "/" + ::oDbfDet:cSufFac + "-" + Str( ::oDbfDet:nNumRec ),;
                  Dtoc( ::oDbfDet:dPreCob ),;
                  ::oDbfDet:cCodCli + Space( 1 ) + RetClient( ::oDbfDet:cCodCli, ::oClientes:cAlias ),;
                  ::oDbfDet:cCodAge ,;
                  hBmpDiv( ::oDbfDet:cDivPgo, ::oDbfDiv:cAlias, ::oBandera ),;
                  nTotRecCli( ::oDbfDet, ::oDbfDiv:cAlias, cDivEmp(), .t. ) ;
         HEAD;
                  "P",;
                  "Número",;
                  "Fecha",;
                  "Cliente",;
                  "Agente",;
                  "Div",;
                  "Importe" ;
         FIELDSIZES;
                  14 ,;
                  100 ,;
                  80 ,;
                  200,;
                  40 ,;
                  25 ,;
                  80  ;
         ID       105 ;
			OF 		oDlg

      ::oDbfDet:SetBrowse( oBrw )

      oBrw:aJustify        := { .f., .f., .f., .f., .f., .f., .t. }
      oBrw:aActions        := {| nCol | lPressCol( nCol, oBrw, oCbxOrd, aCbxOrd, ::oDbfDet:cAlias ) }
      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }

      REDEFINE BUTTON ID 500 OF oDlg WHEN .f.

      REDEFINE BUTTON ID 501 OF oDlg ACTION ( EdtRecCli( ::oDbfDet:cSerie + Str( ::oDbfDet:nNumFac ) + ::oDbfDet:cSufFac + Str( ::oDbfDet:nNumRec ), oBrw ) )

      REDEFINE BUTTON ID IDOK OF oDlg ACTION ( oDlg:end( IDOK ) )

      REDEFINE BUTTON ID 551 OF oDlg ACTION ( oDlg:end() )

   ACTIVATE DIALOG oDlg CENTER

   DestroyFastFilter( ::oDbfDet:cAlias )

   SetBrwOpt( "BrwRecCli", ::oDbfDet:OrdNumber() )

   if oDlg:nResult == IDOK
      ::oNumRec:cText( ::oDbfDet:cSerie + Str( ::oDbfDet:nNumFac ) + ::oDbfDet:cSufFac + Str( ::oDbfDet:nNumRec ) )
   end if

   ::oDbfDet:KillFilter()
   ::oDbfDet:SetStatus()

   msgStop( ::oDbfDet:OrdSetFocus(), "despues brwreccli" )

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

METHOD nTotRem( lPic )

   local nTot     := 0

   DEFAULT lPic   := .f.

   if ::oDbfDet != nil

      ::oDbfDet:GetStatus()
      ::oDbfDet:OrdSetFocus( "nNumCob" )

      if ::oDbfDet:Seek( Str( ::oDbf:nNumCob, 9 ) + ::oDbf:cSufCob )
         while Str( ::oDbf:nNumCob, 9 ) + ::oDbf:cSufCob == Str( ::oDbfDet:nNumCob, 9 ) + ::oDbfDet:cSufCob .and. !::oDbfDet:eof()
            nTot  += nTotRecCli( ::oDbfDet, ::oDbfDiv:cAlias, ::oDbf:cCodDiv, .f. )
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

   if ::oDbfVir != nil

      ::oDbfVir:GetStatus()
      ::oDbfVir:GoTop()

         while !::oDbfVir:eof()
            nTot  += nTotRecCli( ::oDbfVir, ::oDbfDiv:cAlias, ::oDbf:cCodDiv, .f. )
            ::oDbfVir:Skip()
         end while

      ::oDbfVir:SetStatus()

   end if

RETURN ( if( lPic, Trans( nTot, ::cPorDiv ), nTot ) )

//---------------------------------------------------------------------------//

METHOD Del()

   if oUser():lNotConfirmDelete() .or. ApoloMsgNoYes("¿Desea eliminar el registro en curso?", "Confirme supresión" )
      while ::oDbfDet:Seek( Str( ::oDbf:nNumCob, 9 ) + ::oDbf:cSufCob )
         ::DelItem()
      end while
      ::oDbf:Delete()
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD DelItem()

   ::oDbfDet:GetStatus()

   ::oDbfDet:Load()
   ::oDbfDet:nNumCob    := 0
   ::oDbfDet:cSufCob    := ""
   ::oDbfDet:lCobrado   := .f.
   ::oDbfDet:dEntrada   := Ctod( "" )
   ::oDbfDet:nImpCob    := 0
   ::oDbfDet:nImpGas    := 0
   ::oDbfDet:Save()

   ::oDbfDet:SetStatus()

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD GetNewCount()

   ::oDbf:nNumCob    := nCurCob()
   while ( ::oDbf:nArea )->( dbSeek( Str( ::oDbf:nNumCob, 9 ) + ::oDbf:cSufCob ) ) .or. ::oDbf:nNumCob == 0
      SetFieldEmpresa( nCurCob() + 1, "nNumCob" )
      ::oDbf:nNumCob := nCurCob()
   end while
   SetFieldEmpresa( nCurCob() + 1, "nNumCob" )

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD PutNewCount()

   nCurCob( ::oDbf:nNumCob )

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD lNowExist( cNumRec )

   local lRet  := .f.

   ::oDbfVir:GetStatus()

   ::oDbfVir:GoTop()
   while !::oDbfVir:eof()
      if ::oDbfVir:cSerie + Str( ::oDbfVir:nNumFac, 9 ) + ::oDbfVir:cSufFac + Str( ::oDbfVir:nNumRec ) == cNumRec
         lRet  := .t.
      end if
      ::oDbfVir:Skip()
   end while

   ::oDbfVir:SetStatus()

RETURN ( lRet )

//--------------------------------------------------------------------------//

METHOD Conta( lSimula )

   local nDebe       := 0
   local nHaber      := 0
   local cCtaCli     := ""
   local cCtaPgo     := ""
   local cCtaCliDto  := ""
   local cPago       := ""
   local cRemesa     := ""
   local aSimula     := {}
   local nImpCob     := 0
   local nImpGas     := 0
   local cCodCli     := ""
   local cCodPgo     := ""
   local cCodPro     := cProCnt()
   local cRuta       := cRutCnt()
   local cCodEmp     := cCodEmpCnt( "A" )
   local cCtaGas
   local nAsiento

   /*
	Chequando antes de pasar a Contaplus
	--------------------------------------------------------------------------
	*/

   if !lSimula .AND. ::oDbf:lConta
      if !ApoloMsgNoYes( "Remesa : " + Str( ::oDbf:nNumCob ) + " contabilizada." + CRLF + "¿ Desea contabilizarla de nuevo ?" )
         return .f.
      end if
   end if

   if !::lChkSelect .AND. !ChkRuta( cRutCnt() )
      aAdd( ::aMsg, { .f., "Ruta no valida." } )
      return .f.
   end if

   /*
   Seleccionamos las empresa dependiendo de la serie de factura
	--------------------------------------------------------------------------
	*/

   if Empty( cCodEmp ) .AND. !::lChkSelect
      aAdd( ::aMsg, { .f., "Remesa : " + Str( ::oDbf:nNumCob ) + " no se definierón empresas asociadas." } )
      return .f.
   end if


   /*
   Comporbamos fechas
   ----------------------------------------------------------------------------
   */

   if !lSimula .and. !ChkFecha( , , ::oDbf:dFecCob, .f. )
      aadd( ::aMsg, { .f., "Remesa : " + Str( ::oDbf:nNumCob, 9 ) + " asiento fuera de fechas" } )
      return .f.
   end if

   /*
   Estudio de los Articulos de una factura
   --------------------------------------------------------------------------
   */

   if ::oDbfDet:Seek( Str( ::oDbf:nNumCob, 9 ) + ::oDbf:cSufCob )

      while Str( ::oDbf:nNumCob, 9 ) + ::oDbf:cSufCob == Str( ::oDbfDet:nNumCob, 9 ) + ::oDbfDet:cSufCob .and. ;
         !::oDbfDet:eof()

         if ::oClientes:Seek( ::oDbfDet:cCodCli )
            cCtaCli     := ::oClientes:SubCta
         else
            cCtaCli     := ""
         end if

         if !ChkSubcuenta( cRuta, cCodEmp, cCtaCli, , .f., .f. )
            aadd( ::aMsg, { .f., "Cliente : " + rtrim( ::oClientes:Titulo ) + " cuenta contable no existe." } )
            return .f.
         end if

         cCodCli        := cCliFacCli( ::oDbfDet:cSerie + Str( ::oDbfDet:NNUMFAC, 9 ) + ::oDbfDet:CSUFFAC, ::oFacCliT:cAlias )
         cCodPgo        := cPgoFacCli( ::oDbfDet:cSerie + Str( ::oDbfDet:NNUMFAC, 9 ) + ::oDbfDet:CSUFFAC, ::oFacCliT:cAlias )

         if nImpGas != 0

            if Empty( ::oDbfDet:cCtaGas )
               cCtaGas  := cCtaFGas( cCodPgo, ::oFPago:cAlias )
            else
               cCtaGas  := ::oDbfDet:cCtaGas
            end if

            if !lSimula .and. Empty( cCtaGas )
               aAdd( ::aMsg, { .f., "Recibo : " + rtrim( ::cRecibo ) + " no existe cuenta de gastos." } )
               return .f.
            end if

            if !lSimula .and. !ChkSubcuenta( cRutCnt(), cCodEmp, cCtaGas, , .f., .f. )
               aAdd( ::aMsg, { .f., "Recibo : " + rtrim( ::cRecibo ) + " subcuenta " + rtrim( cCtaGas ) + " no encontada." } )
               return .f.
            end if

         end if

         ::oDbfDet:Skip()

      end while

   else

      aadd( ::aMsg, { .f., "Remesa : " + Str( ::oDbf:nNumCob, 9 )  + " remesa sin recibos." } )
      return .f.

   end if

	/*
   Realización de Asientos
	--------------------------------------------------------------------------
   */

   if OpenDiario( , cCodEmp )
      nAsiento := contaplusUltimoAsiento()
   else
      aadd( ::amsg, { .f., "Remesa : " + Str( ::oDbf:nNumCob, 9 ) + " imposible abrir ficheros." } )
      return .f.
   end if

   if ::oDbfDet:Seek( Str( ::oDbf:nNumCob, 9 ) + ::oDbf:cSufCob )

      while Str( ::oDbf:nNumCob, 9 ) + ::oDbf:cSufCob == Str( ::oDbfDet:nNumCob, 9 ) + ::oDbfDet:cSufCob .and. ;
         !::oDbfDet:eof()

         /*
         Recogemos los datos para hacer los apuntes----------------------------
         */

         if !Empty( ::oDbfDet:cCtaRec )
            cCtaPgo  := ::oDbfDet:cCtaRec
         end if

         if ::oFacCliT:Seek( ::oDbfDet:cSerie + Str( ::oDbfDet:nNumFac ) + ::oDbfDet:cSufFac )
            cCodPro  := ::oFacCliT:cCodPro
         end if

         nImpCob     := nTotCobCli( ::oDbfDet, ::oDbfDiv )
         nImpGas     := nTotGasCli( ::oDbfDet, ::oDbfDiv )

         cCodCli     := cCliFacCli( ::oDbfDet:cSerie + Str( ::oDbfDet:nNumFac, 9 ) + ::oDbfDet:cSufFac, ::oFacCliT:cAlias )
         cCodPgo     := cPgoFacCli( ::oDbfDet:cSerie + Str( ::oDbfDet:nNumFac, 9 ) + ::oDbfDet:cSufFac, ::oFacCliT:cAlias )

         if ::oClientes:Seek( cCodCli )
            cCtaCli  := ::oClientes:SubCta
         else
            cCtaCli  := ""
         end if

         if nImpGas != 0

            if Empty( ::oDbfDet:cCtaGas )
               cCtaGas  := cCtaFGas( cCodPgo, ::oFPago:cAlias )
            else
               cCtaGas  := ::oDbfDet:cCtaGas
            end if

         end if

         cPago       := "C/Remesa N. " + AllTrim( Str( ::oDbf:nNumCob, 9 ) )
         cRemesa     := "C/Recibo N. " + ::oDbfDet:cSerie + "/" + AllTrim( Str( ::oDbfDet:nNumFac ) ) + "/" + ::oDbfDet:cSufFac

         /*
         Cliente_______________________________________________________________
         */

         aadd( aSimula, MkAsiento( nAsiento,;
                                   ::oDbf:cCodDiv,;
                                   ::oDbf:dFecCob,;
                                   cCtaCli,;
                                   ,;
                                   ,;
                                   cRemesa,;
                                   Round( ::oDbfDet:nImporte, ::nDorDiv ),;
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
                                   lSimula ) )

         /*
         Cobro_________________________________________________________________
         */

         aadd( aSimula, MkAsiento( nAsiento,;
                                   ::oDbf:cCodDiv,;
                                   ::oDbf:dFecCob,;
                                   cCtaPgo,;
                                   ,;
                                   nImpCob,;
                                   cPago,;
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
                                   lSimula ) )


         /*
         Gastos___________________________________________________________________
         */

         if nImpGas != 0

         aadd( aSimula, MkAsiento( nAsiento,;
                                   ::oDbf:cCodDiv,;
                                   ::oDbf:dFecCob,;
                                   cCtaGas,;
                                   ,;
                                   nImpGas,;
                                   cRemesa,;
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
                                   lSimula ) )

         end if

         if !lSimula
            ::oDbfDet:Load()
            ::oDbfDet:lConPgo  := .t.
            ::oDbfDet:Save()
         end if

         ::oDbfDet:Skip()

      end while

   end if

   if !lSimula

      ::oDbf:Load()
      ::oDbf:lConta  := .t.
      ::oDbf:Save()

      aadd( ::aMsg, { .t., "Remesa : " + rtrim( ::oDbf:cNumCob ) + " asiento generado num. " + Alltrim( Str( nAsiento ) ) } )

   else

      msgTblCon( aSimula, ::oDbf:cCodDiv, ::oDbfDiv:cAlias )

   end if

   CloseDiario()

   ::oWndBrw:Refresh()

RETURN NIL

//---------------------------------------------------------------------------//

METHOD ValCobro()

   if ::oDbfVir:nImpCob <= ::oDbfVir:nImporte
      ::oImpGas:cText( ::oDbfVir:nImporte - ::oDbfVir:nImpCob )
      return .t.
   else
      msgStop( "El importe del cobro excede al importe del recibo" )
   end if

return .f.

//---------------------------------------------------------------------------//