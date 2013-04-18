#ifndef __PDA__
   #include "FiveWin.Ch"
   #include "TDbfVirt.ch"
   #include "Xbrowse.ch"
#else
   #include "FWCE.ch"
   REQUEST DBFCDX
#endif

#include "Factu.ch"
#include "MesDbf.ch"

static dbfAlbCliT
static dbfAlbCliL
static dbfFacCliT
static dbfFacCliL
static dbfOrdCarT
static dbfOrdCarL
static dbfHisMov
static dbfTransport
static dbfArticulo
static dbfTmpEstado
static cTmpEstado
static oBrwEstado
static oPgrEstado
static oSayProgress
static cSayProgress   := "Procesando"

//---------------------------------------------------------------------------//

CLASS TOrdCarga FROM TMasDet

   DATA  oCtaRem
   DATA  oDbfCnt
   DATA  oRecibos
   DATA  oAlbCliT
   DATA  oAlbCliL
   DATA  oAlbCliP
   DATA  oClientes
   DATA  oDbfIva
   DATA  oTrans
   DATA  oDbfAge
   DATA  oDbfArt
   DATA  oTblPro
   DATA  oDbfPro
   DATA  oDbfFam
   DATA  cPatExp
   DATA  dFecIni
   DATA  dFecFin
   DATA  aMsg           AS ARRAY    INIT {}
   DATA  oSer                       INIT Array( 26 )
   DATA  aSer                       INIT Afill( Array( 26 ), .t. )
   DATA  oBmp
   DATA  aDbfVir        AS ARRAY    INIT { { .f., "", 0, "", Ctod( "" ), "", "",  "", 0 } }
   DATA  oBrwDet
   DATA  cMru                       INIT "Truck_blue_document_16"
   DATA  cBitmap                    INIT clrTopArchivos

   DATA  oFecAlb
   DATA  oCodCli
   DATA  oNomCli
   DATA  oComent

   DATA  oPeso
   DATA  nPeso          AS NUMERIC  INIT 0

   DATA  oDiferencias
   DATA  nDiferencias   AS NUMERIC  INIT 0

   DATA  oMenu

   DATA  oDetOrdCar
   DATA  aAlbaranes     AS ARRAY    INIT {}

   METHOD New( cPath, oWndParent, oMenuItem )

   METHOD DefineFiles()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD OpenService( lExclusive )

   METHOD Resource( nMode )

   METHOD Activate()

#ifndef __PDA__

   METHOD Report()         INLINE   TInfOrdCar():New( "Ordenes de carga", , , , , , { ::oDbf, ::oDetOrdCar:oDbf } ):Play()

   METHOD EdtRotor( oDlg )

   METHOD ImpAlbCli()

#else

   METHOD PdaActivate()

#endif

   METHOD OpenError()      INLINE   ( MsgStop( "Proceso en uso por otro usuario", "Abrir fichero" ), .f. )

   METHOD LoadTrans()

   METHOD CalculaDiferencias()

   METHOD lSave( nMode, oDlg )

   METHOD GetNewCount()

   METHOD nPesOrdVir( lPic )

   METHOD StartImpAlbCli( oDlg )

   METHOD RollBackAlbCli()

   METHOD Enviar( aSelected )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( cPath, oMenuItem, oWndParent )

   DEFAULT cPath           := cPatEmp()
   DEFAULT oWndParent      := oWnd()

   ::nLevel                := nLevelUsr( oMenuItem )

   ::cPath                 := cPath
   ::oWndParent            := oWndParent
   ::oDbf                  := nil

#ifndef __PDA__
   ::oTrans                := TTrans():New( cPath )
#else
   ::oTrans                := TTrans():New( cPatCli() )
#endif

   ::oBmp                  := LoadBitmap( 0, 32760 )
   ::dFecIni               := Ctod( "01/" + Str( Month( Date() ), 2 ) + "/" + Str( Year( Date() ), 4 ) )
   ::dFecFin               := Date()

   ::cNumDocKey            := "nNumOrd"
   ::cSufDocKey            := "cSufOrd"

   ::bFirstKey             := {|| Str( ::oDbf:nNumOrd ) + ::oDbf:cSufOrd }

   ::bOnPreDelete          := {|| ::RollBackAlbCli()  }

#ifndef __PDA__
   ::bOnPostAppendDetail   := {|| ::oBrwDet:Refresh(), ::nPesOrdVir() }
   ::bOnPostEditDetail     := {|| ::oBrwDet:Refresh(), ::nPesOrdVir() }
   ::bOnPostDeleteDetail   := {|| ::oBrwDet:Refresh(), ::nPesOrdVir() }
#else
   ::bOnPostAppendDetail   := {|| ::oBrwDet:Refresh() }
   ::bOnPostEditDetail     := {|| ::oBrwDet:Refresh() }
   ::bOnPostDeleteDetail   := {|| ::oBrwDet:Refresh() }
#endif

   ::oDetOrdCar            := TDetOrdCar():New( cPath, Self )

   ::AddDetail( ::oDetOrdCar )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Activate()

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

      ::oWndBrw:bDup    := nil

      ::oWndBrw:GralButtons( Self )

      DEFINE BTNSHELL RESOURCE "Lbl" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::Enviar() ) ;
         TOOLTIP  "En(v)iar" ;
         HOTKEY   "V" ;
         LEVEL    ACC_EDIT

      ::oWndBrw:EndButtons( Self )

      ::oWndBrw:Activate(  nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, {|| ::CloseFiles() }, nil, nil )

   else

      msgStop( "Acceso no permitido." )

   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

#ifdef __PDA__

METHOD PdaActivate()

   local oBrw
   local oDlg
   local oFont
   local oBtn
   local oSayTit
   local uGet1
   local cGet1       := ""
   local nOrdAnt     := GetBrwOpt( "BrwOrdCar" )
   local oCbxOrd
   local aCbxOrd     := { "Número", "Fecha", "Transportista" }
   local cCbxOrd     := "Número"
   local oThis       := Self

   nOrdAnt           := Min( Max( nOrdAnt, 1 ), len( aCbxOrd ) )
   cCbxOrd           := aCbxOrd[ nOrdAnt ]

   if nAnd( ::nLevel, 1 ) == 0

      if !::OpenFiles()
         return nil
      end if

      DEFINE FONT oFont NAME "Verdana" SIZE 0, -14

      DEFINE DIALOG oDlg RESOURCE "HELPENTRY_PDA"  TITLE "Seleccionar clientes"

         REDEFINE SAY oSayTit ;
            VAR      "Órdenes de carga" ;
            ID       110 ;
            COLOR    "N/W*" ;
            FONT     oFont ;
            OF       oDlg

         REDEFINE BTNBMP oBtn ;
            ID       100 ;
            OF       oDlg ;
            FILE     ( cPatBmp() + "truck_blue_16.bmp" ) ;
            NOBORDER ;
            ACTION   ( nil )

         oBtn:SetColor( 0, nRGB( 255, 255, 255 )  )

         REDEFINE GET uGet1 VAR cGet1;
            ID       104 ;
            BITMAP   "FIND" ;
            OF       oDlg

            uGet1:bChange   := {|nKey, nFlags| AutoSeek( nKey, nFlags, uGet1, oBrw, ::oDbf:cAlias, .t. ) }
            uGet1:bValid    := {|| OrdClearScope( oBrw, ::oDbf:cAlias ), oBrw:Refresh(), .t. }

         REDEFINE COMBOBOX oCbxOrd ;
            VAR      cCbxOrd ;
            ID       102 ;
            ITEMS    aCbxOrd ;
            OF       oDlg

            oCbxOrd:bChange := {|| ::oDbf:OrdSetFocus( oCbxOrd:nAt ), ::oDbf:GoTop(), oBrw:refresh(), uGet1:SetFocus(), oCbxOrd:refresh() }

         REDEFINE IBROWSE oBrw ;
            FIELDS   AllTrim( Str( ::oDbf:nNumOrd ) ) + "/" + ::oDbf:cSufOrd + CRLF + Dtoc( ::oDbf:dFecOrd ),;
                     ::oDbf:cCodTrn + CRLF + ::oTrans:cNombre( ::oDbf:cCodTrn ) ,;
                     ::oDbf:cCodAge + CRLF + AllTrim( oRetFld( ::oDbf:cCodAge, ::oDbfAge, "cNbrAge" ) ) + Space(1) + AllTrim( oRetFld( ::oDbf:cCodAge, ::oDbfAge, "cApeAge" ) ) ;
            HEAD     "Número" + CRLF + "Fecha",;
                     "Transportista",;
                     "Agente" ;
            FIELDSIZES ;
                     100,;
                     200,;
                     200 ;
            JUSTIFY  .f.,;
                     .f.,;
                     .f. ;
            ALIAS    ( ::oDbf:cAlias ) ;
            ID       105 ;
            OF       oDlg

      ACTIVATE DIALOG oDlg ;
         ON INIT ( oDlg:SetMenu( PdaBuildMenu( oDlg, oThis, oBrw ) ) )

      /*
      Guardo los campos del browse
      */

      oBrw:CloseData()
      ::CloseFiles()

      //Restauramos la ventana---------------------------------------------------

      oWnd():Show()

   else

      msgStop( "Acceso no permitido." )

   end if

RETURN ( Self )

//--------------------------------------------------------------------------//

static function PdaBuildMenu( oDlg, oThis, oBrw )

   local oMenu

   DEFINE MENU oMenu ;
      RESOURCE 500 ;
      BITMAPS  60 ; // bitmaps resoruces ID
      IMAGES   6    // number of images in the bitmap

      REDEFINE MENUITEM ID 510 OF oMenu ACTION ( oThis:Append( oBrw ) )

      REDEFINE MENUITEM ID 520 OF oMenu ACTION ( oThis:Edit( oBrw ) )

      REDEFINE MENUITEM ID 530 OF oMenu ACTION ( oThis:Del( oBrw ) )

      REDEFINE MENUITEM ID 540 OF oMenu ACTION ( oThis:Zoom( oBrw ) )

      REDEFINE MENUITEM ID 550 OF oMenu ACTION ( msginfo( "Imprimir" ), oBrw:Refresh() )

      REDEFINE MENUITEM ID 560 OF oMenu ACTION ( oDlg:End() )

RETURN oMenu

#endif

//----------------------------------------------------------------------------//

#ifndef __PDA__

METHOD DefineFiles( cPath, cDriver )

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE DATABASE ::oDbf FILE "ORDCARP.DBF" CLASS "ORDCARP" ALIAS "ORDCARP" PATH ( cPath ) VIA ( cDriver ) COMMENT  "Ordenes de carga"

   FIELD CALCULATE NAME "bSndInt"   LEN  14 DEC  0                      COMMENT { "Enviar", "Lbl16" , 3 }        VAL {|| ::oDbf:lSndInt } BITMAPS "Sel16", "Nil16"          COLSIZE 20       OF ::oDbf
   FIELD NAME "nNumOrd"    TYPE "N" LEN   9 DEC  0 PICTURE "999999999"  COMMENT ""                                                                                     HIDE OF ::oDbf
   FIELD NAME "cSufOrd"    TYPE "C" LEN   2 DEC  0 PICTURE "@!"         COMMENT ""                                                                                     HIDE OF ::oDbf
   FIELD CALCULATE NAME "cNumOrd"   LEN  12 DEC  0                      COMMENT "Número"        VAL ( Str( ::oDbf:nNumOrd ) + "/" + ::oDbf:cSufOrd )       COLSIZE  80      OF ::oDbf
   FIELD NAME "dFecOrd"    TYPE "D" LEN   8 DEC  0                      COMMENT "Fecha"                                                                    COLSIZE  80      OF ::oDbf
   FIELD NAME "cCodTrn"    TYPE "C" LEN   9 DEC  0 PICTURE "@!"         COMMENT "Código"                                                                   COLSIZE  60      OF ::oDbf
   FIELD CALCULATE NAME "cNomTrn"   LEN  50 DEC  0                      COMMENT "Transportista" VAL ( if( !Empty( ::oTrans ), ::oTrans:cNombre( ::oDbf:cCodTrn ), "" ) ) COLSIZE 200 OF ::oDbf
   FIELD NAME "nKgsTrn"    TYPE "N" LEN  16 DEC  6 PICTURE MasUnd()     COMMENT "TARA"          ALIGN RIGHT                                                COLSIZE  80      OF ::oDbf
   FIELD NAME "cRetPor"    TYPE "C" LEN 100 DEC  0                      COMMENT "Retirado por"                                                             COLSIZE 120      OF ::oDbf
   FIELD NAME "cRetMat"    TYPE "C" LEN  20 DEC  0 PICTURE "@!"         COMMENT "Matrícula"                                                                COLSIZE 100      OF ::oDbf
   FIELD NAME "nBultos"    TYPE "N" LEN   3 DEC  0 PICTURE "999"        COMMENT "Bultos"        ALIGN RIGHT                                                COLSIZE  50      OF ::oDbf
   FIELD NAME "cCodAge"    TYPE "C" LEN   3 DEC  0 PICTURE "@!"         COMMENT "Cod. agente"                                                              COLSIZE  50 HIDE OF ::oDbf
   FIELD NAME "lSndInt"    TYPE "L" LEN   1 DEC  0                      COMMENT ""                                                                                     HIDE OF ::oDbf
   FIELD NAME "lRegula"    TYPE "L" LEN   1 DEC  0                      COMMENT ""                                                                                     HIDE OF ::oDbf

   INDEX TO "OrdCarP.Cdx" TAG "nNumOrd"  ON "Str( nNumOrd ) + cSufOrd"  COMMENT "Número"        NODELETED OF ::oDbf
   INDEX TO "OrdCarP.Cdx" TAG "dFecOrd"  ON "dFecOrd"                   COMMENT "Fecha"         NODELETED OF ::oDbf
   INDEX TO "OrdCarP.Cdx" TAG "cCodTrn"  ON "cCodTrn"                   COMMENT "Transportista" NODELETED OF ::oDbf

   END DATABASE ::oDbf

   ::oDbf:bOpenError := { || ::OpenError() }

RETURN ( ::oDbf )

#else

//---------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   DEFAULT cPath        := ::cPath

   DEFINE DATABASE ::oDbf FILE "ORDCARP.DBF" CLASS "ORDCARP" ALIAS "ORDCARP" PATH ( cPath ) VIA ( cDriver() ) COMMENT  "Ordenes de carga"

   FIELD NAME "nNumOrd"    TYPE "N" LEN   9 DEC  0 PICTURE "999999999"  COMMENT ""                                                                                     HIDE OF ::oDbf
   FIELD NAME "cSufOrd"    TYPE "C" LEN   2 DEC  0 PICTURE "@!"         COMMENT ""                                                                                     HIDE OF ::oDbf
   FIELD NAME "dFecOrd"    TYPE "D" LEN   8 DEC  0                      COMMENT "Fecha"                                                                    COLSIZE  80      OF ::oDbf
   FIELD NAME "cCodTrn"    TYPE "C" LEN   9 DEC  0 PICTURE "@!"         COMMENT "Código"                                                                   COLSIZE  60      OF ::oDbf
   FIELD NAME "nKgsTrn"    TYPE "N" LEN  16 DEC  6 PICTURE MasUnd()     COMMENT "TARA"          ALIGN RIGHT                                                COLSIZE  80      OF ::oDbf
   FIELD NAME "cRetPor"    TYPE "C" LEN 100 DEC  0                      COMMENT "Retirado por"                                                             COLSIZE 120      OF ::oDbf
   FIELD NAME "cRetMat"    TYPE "C" LEN  20 DEC  0 PICTURE "@!"         COMMENT "Matrícula"                                                                COLSIZE 100      OF ::oDbf
   FIELD NAME "nBultos"    TYPE "N" LEN   3 DEC  0 PICTURE "999"        COMMENT "Bultos"        ALIGN RIGHT                                                COLSIZE  50      OF ::oDbf
   FIELD NAME "cCodAge"    TYPE "C" LEN   3 DEC  0 PICTURE "@!"         COMMENT "Cod. agente"                                                              COLSIZE  50 HIDE OF ::oDbf
   FIELD NAME "lSndInt"    TYPE "L" LEN   1 DEC  0                      COMMENT ""                                                                                     HIDE OF ::oDbf
   FIELD NAME "lRegula"    TYPE "L" LEN   1 DEC  0                      COMMENT ""                                                                                     HIDE OF ::oDbf

   INDEX TO "OrdCarP.Cdx" TAG "nNumOrd"  ON "Str( nNumOrd ) + cSufOrd"  COMMENT "Número"        NODELETED OF ::oDbf
   INDEX TO "OrdCarP.Cdx" TAG "dFecOrd"  ON "dFecOrd"                   COMMENT "Fecha"         NODELETED OF ::oDbf
   INDEX TO "OrdCarP.Cdx" TAG "cCodTrn"  ON "cCodTrn"                   COMMENT "Transportista" NODELETED OF ::oDbf

   END DATABASE ::oDbf

   ::oDbf:bOpenError := { || ::OpenError() }

RETURN ( ::oDbf )


#endif

//----------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive )

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lExclusive   := .f.

   BEGIN SEQUENCE

      TDataCenter():oAlbCliT()

      DATABASE NEW ::oAlbCliL    FILE "ALBCLIL.DBF"   PATH ( ::cPath )     VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

      DATABASE NEW ::oAlbCliP    FILE "ALBCLIP.DBF"   PATH ( ::cPath )     VIA ( cDriver() ) SHARED INDEX "ALBCLIP.CDX"

      DATABASE NEW ::oClientes   FILE "CLIENT.DBF"    PATH ( cPatCli() )   VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

      DATABASE NEW ::oDbfIva     FILE "TIVA.DBF"      PATH ( cPatDat() )   VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

      DATABASE NEW ::oDbfCnt     FILE "NCOUNT.DBF"    PATH ( cPatEmp() )   VIA ( cDriver() ) SHARED INDEX "NCOUNT.CDX"

      DATABASE NEW ::oDbfAge     FILE "AGENTES.DBF"   PATH ( cPatCli() )   VIA ( cDriver() ) SHARED INDEX "AGENTES.CDX"

      DATABASE NEW ::oDbfArt     FILE "ARTICULO.DBF"  PATH ( cPatArt() )   VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

      DATABASE NEW ::oTblPro     FILE "TBLPRO.DBF"    PATH ( cPatArt() )   VIA ( cDriver() ) SHARED INDEX "TBLPRO.CDX"

      DATABASE NEW ::oDbfPro     FILE "PRO.DBF"       PATH ( cPatArt() )   VIA ( cDriver() ) SHARED INDEX "PRO.CDX"

      DATABASE NEW ::oDbfFam     FILE "FAMILIAS.DBF"  PATH ( cPatArt() )   VIA ( cDriver() ) SHARED INDEX "FAMILIAS.CDX"

      ::lLoadDivisa()

      ::oTrans:OpenFiles()

      if Empty( ::oDbf )
         ::DefineFiles()
      end if

      ::oDbf:Activate( .f., !( lExclusive ), .f., .f. )

      ::oDetOrdCar:Openfiles()

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos" )

      lOpen             := .f.

      ::CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oDbf ) .and. ::oDbf:Used()
      ::oDbf:End()
   end if

   if !Empty( ::oAlbCliT ) .and. ::oAlbCliT:Used()
      ::oAlbCliT:End()
   end if

   if !Empty( ::oAlbCliL ) .and. ::oAlbCliL:Used()
      ::oAlbCliL:End()
   end if

   if !Empty( ::oAlbCliP ) .and. ::oAlbCliP:Used()
      ::oAlbCliP:End()
   end if

   if !Empty( ::oDbfIva ) .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if

   if !Empty( ::oClientes ) .and. ::oClientes:Used()
      ::oClientes:End()
   end if

   if !Empty( ::oDbfCnt ) .and. ::oDbfCnt:Used()
      ::oDbfCnt:End()
   end if

   if !Empty( ::oDbfAge ) .and. ::oDbfAge:Used()
      ::oDbfAge:End()
   end if

   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if

   if !Empty( ::oTblPro ) .and. ::oTblPro:Used()
      ::oTblPro:End()
   end if

   if !Empty( ::oDbfPro ) .and. ::oDbfPro:Used()
      ::oDbfPro:End()
   end if

   if !Empty( ::oDbfFam ) .and. ::oDbfFam:Used()
      ::oDbfFam:End()
   end if

   if !Empty( ::oTrans )
      ::oTrans:End()
   end if

   if !Empty( ::oDetOrdCar )
      ::oDetOrdCar:End()
   end if

   ::oAlbCliT     := nil
   ::oAlbCliL     := nil
   ::oAlbCliP     := nil
   ::oDbfIva      := nil
   ::oClientes    := nil
   ::oDbf         := nil
   ::oDbfCnt      := nil
   ::oTrans       := nil
   ::oDbfAge      := nil
   ::oDbfArt      := nil
   ::oTblPro      := nil
   ::oDbfPro      := nil
   ::oDbfFam      := nil
   ::oDetOrdCar   := nil

   DeleteObject( ::oBmp )

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD OpenService( lExclusive )

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lExclusive   := .f.

   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::DefineFiles()
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos" )

      lOpen             := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpen
      ::CloseService()
   end if

RETURN ( lOpen )

//---------------------------------------------------------------------------//

#ifndef __PDA__

METHOD Resource( nMode )

   local oDlg
   local oGet
   local oSay
   local cSay           := ::oTrans:cNombre( ::oDbf:cCodTrn )
   local oGetKgs
   local oGetAge
   local oSayAge
   local cSayAge
   local oBmpGeneral

   ::aAlbaranes         := {}

   if nMode == APPD_MODE
      ::oDbf:dFecOrd    := Date()
      ::oDbf:cSufOrd    := RetSufEmp()
      ::nDiferencias    := 0
   end if

   DEFINE DIALOG oDlg RESOURCE "ORDCAR" TITLE LblTitle( nMode ) + "ordenes de carga"

      REDEFINE BITMAP oBmpGeneral ;
        ID       990 ;
        RESOURCE "ordenes_carga_48_alpha" ;
        TRANSPARENT ;
        OF       oDlg

      REDEFINE GET ::oDbf:nNumOrd ;
			ID 		100 ;
         WHEN     ( .f. ) ;
         PICTURE  ::oDbf:FieldByName( "nNumOrd" ):cPict ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cSufOrd ;
			ID 		110 ;
         WHEN     ( .f. ) ;
         PICTURE  ::oDbf:FieldByName( "cSufOrd" ):cPict ;
         OF       oDlg

      REDEFINE GET ::oDbf:dFecOrd ;
         ID       120 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET oGetAge VAR ::oDbf:cCodAge UPDATE ;
         ID       340 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
			OF 		oDlg

      oGetAge:bValid := {|| cAgentes( oGetAge, ::oDbfAge:cAlias, oSayAge ) }
      oGetAge:bHelp  := {|| BrwAgentes( oGetAge, oSayAge ) }

      REDEFINE GET oSayAge VAR cSayAge ;
         ID       341 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE GET oGet VAR ::oDbf:cCodTrn UPDATE ;
         ID       130 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
			OF 		oDlg

      oGet:bValid := {|| ::oTrans:Existe( oGet, oSay, "cNomTrn" ), ::LoadTrans( oGet, oGetKgs ) }
      oGet:bHelp  := {|| ::oTrans:Buscar( oGet, "cCodTrn" ) }

      REDEFINE GET oSay VAR cSay UPDATE ;
         ID       131 ;
         WHEN     ( .f. ) ;
			OF 		oDlg

      REDEFINE GET oGetKgs VAR ::oDbf:nKgsTrn UPDATE ;
         ID       190 ;
         WHEN     ( .f. ) ;
         PICTURE  ( MasUnd() ) ;
			OF 		oDlg

      REDEFINE GET ::oPeso VAR ::nPeso UPDATE ;
         ID       200 ;
         WHEN     ( .f. ) ;
         PICTURE  ( MasUnd() ) ;
			OF 		oDlg

      REDEFINE GET ::oDiferencias VAR ::nDiferencias UPDATE ;
         ID       210 ;
         WHEN     ( .f. ) ;
         PICTURE  ( MasUnd() ) ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cRetPor UPDATE ;
         ID       140 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cRetMat UPDATE ;
         ID       170 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET ::oDbf:nBultos UPDATE ;
         ID       180 ;
         SPINNER;
         PICTURE  "999" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

       /*
       Botones de acceso________________________________________________________________
       */

		REDEFINE BUTTON ;
         ID       300 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::oDetOrdCar:Append( ::oBrwDet ) )

      REDEFINE BUTTON ;
         ID       310 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::oDetOrdCar:Edit( ::oBrwDet ) )

      REDEFINE BUTTON ;
         ID       320 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::oDetOrdCar:Del( ::oBrwDet ) )

      REDEFINE BUTTON ;
         ID       330 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::ImpAlbCli() )

      ::oBrwDet                     := IXBrowse():New( oDlg )

      ::oBrwDet:SetoDbf( ::oDetOrdCar:oDbfVir )
      ::oBrwDet:nMarqueeStyle       := 5
      ::oBrwDet:cName               := "Lineas de ordenes de carga"
      ::oBrwDet:lRecordSelector     := .f.
      ::oBrwDet:CreateFromResource( 150 )

      with object ( ::oBrwDet:AddCol() )
         :cHeader                   := "Código"
         :bStrData                  := {|| ::oDetOrdCAr:oDbfVir:cRef }
         :nWidth                    := 100
      end with

      with object ( ::oBrwDet:AddCol() )
         :cHeader                   := "Descripción"
         :bStrData                  := {|| ::oDetOrdCAr:oDbfVir:cDetalle }
         :nWidth                    := 540
      end with

      with object ( ::oBrwDet:AddCol() )
         :cHeader                   := "Prp. 1"
         :bStrData                  := {|| ::oDetOrdCAr:oDbfVir:cValPr1 }
         :nWidth                    := 30
         :lHide                     := .t.
      end with

      with object ( ::oBrwDet:AddCol() )
         :cHeader                   := "Prp. 2"
         :bStrData                  := {|| ::oDetOrdCAr:oDbfVir:cValPr2 }
         :nWidth                    := 30
         :lHide                     := .t.
      end with

      with object ( ::oBrwDet:AddCol() )
         :cHeader                   := "Lote"
         :bStrData                  := {|| ::oDetOrdCAr:oDbfVir:cLote }
         :nWidth                    := 40
         :lHide                     := .t.
      end with

      with object ( ::oBrwDet:AddCol() )
         :cHeader                   := "Cajas"
         :bEditValue                := {|| ::oDetOrdCAr:oDbfVir:nCajOrd }
         :nWidth                    := 50
         :cEditPicture              := MasUnd()
         :nDataStrAlign             := AL_RIGHT
         :nHeadStrAlign             := AL_RIGHT
         :lHide                     := .t.
      end with

      with object ( ::oBrwDet:AddCol() )
         :cHeader                   := "Unidades"
         :bEditValue                := {|| ::oDetOrdCAr:oDbfVir:nUniOrd }
         :nWidth                    := 50
         :cEditPicture              := MasUnd()
         :nDataStrAlign             := AL_RIGHT
         :nHeadStrAlign             := AL_RIGHT
         :lHide                     := .t.
      end with

      with object ( ::oBrwDet:AddCol() )
         :cHeader                   := "Total unidades"
         :bEditValue                := {|| ::oDetOrdCar:nTotUnidades( ::oDetOrdCAr:oDbfVir ) }
         :nWidth                    := 95
         :cEditPicture              := MasUnd()
         :nDataStrAlign             := AL_RIGHT
         :nHeadStrAlign             := AL_RIGHT
      end with

      with object ( ::oBrwDet:AddCol() )
         :cHeader                   := "Peso"
         :bEditValue                := {|| ::oDetOrdCAr:oDbfVir:nPeso }
         :nWidth                    := 50
         :cEditPicture              := MasUnd()
         :nDataStrAlign             := AL_RIGHT
         :nHeadStrAlign             := AL_RIGHT
         :lHide                     := .t.
      end with

      with object ( ::oBrwDet:AddCol() )
         :cHeader                   := "Total peso"
         :bEditValue                := {|| ::oDetOrdCar:nTotPeso( ::oDetOrdCAr:oDbfVir ) }
         :nWidth                    := 95
         :cEditPicture              := MasUnd()
         :nDataStrAlign             := AL_RIGHT
         :nHeadStrAlign             := AL_RIGHT
      end with

      if nMode != ZOOM_MODE
         ::oBrwDet:bLDblClick       := {|| ::oDetOrdCar:Edit( ::oBrwDet ) }
      end if

      REDEFINE BUTTON ;
         ID       500 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( ::lSave( nMode, oDlg ) )

		REDEFINE BUTTON ;
         ID       550 ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F2, {|| ::oDetOrdCar:Append( ::oBrwDet ) } )
      oDlg:AddFastKey( VK_F3, {|| ::oDetOrdCar:Edit( ::oBrwDet ) } )
      oDlg:AddFastKey( VK_F4, {|| ::oDetOrdCar:Del( ::oBrwDet ) } )
      oDlg:AddFastKey( VK_F5, {|| ::lSave( nMode, oDlg ) } )
   end if

   oDlg:bStart    := {|| if( nMode != APPD_MODE, ( oGet:lValid(), oGetAge:lValid() ), ), oGetAge:SetFocus(), ::EdtRotor( oDlg ), ::nPesOrdVir() }

   ACTIVATE DIALOG oDlg CENTER

   ::oMenu:End()
   oBmpGeneral:End()

RETURN ( oDlg:nResult == IDOK )

#else

//---------------------------------------------------------------------------//

METHOD Resource( nMode )

   local oDlg
   local oFld
   local oThis          := Self
   local oGetAge
   local oGetTrn
   local oSayAge
   local oSatTrn
   local cSayAge
   local cSayTrn
   local aBtn           := array(4)

   if nMode == APPD_MODE
      ::oDbf:dFecOrd    := Date()
      ::oDbf:cSufOrd    := cSufPda()
      ::oDbf:nBultos    := 0
      ::oDbf:cCodAge    := Padr( cCodAge(), 3, Space( 1 ) )
      ::oDbf:cCodTrn    := Padr( cCodTra(), 9, Space( 1 ) )
      ::oDbf:lRegula    := .t.
   end if

   cSayAge              := cNbrAgent( ::oDbf:cCodAge, ::oDbfAge:cAlias )
   cSayTrn              := ::oTrans:cNombre( ::oDbf:cCodTrn )

   DEFINE DIALOG oDlg RESOURCE "ORDCAR_PDA"

   REDEFINE FOLDER oFld ;
      ID          100 ;
      OF          oDlg ;
      PROMPT      "Orden",           "Líneas" ;
      DIALOGS     "ORDCAR_PDA1",     "ORDCAR_PDA2"

      REDEFINE GET ::oDbf:nNumOrd ;
         ID       110 ;
         WHEN     ( .f. ) ;
         PICTURE  "999999999" ;
         OF       oFld:aDialogs[1]

      REDEFINE GET ::oDbf:cSufOrd ;
         ID       111 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET ::oDbf:dFecOrd ;
         ID       120 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oGetAge VAR ::oDbf:cCodAge ;
         ID       130 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oSayAge VAR cSayAge ;
         ID       131 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oGetTrn VAR ::oDbf:cCodTrn ;
         ID       140 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oSayTrn VAR cSayTrn ;
         ID       141 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET ::oDbf:nBultos ;
         ID       150 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "999.99" ;
         OF       oFld:aDialogs[1]

      /*
      Detalle------------------------------------------------------------------
      */

      REDEFINE BTNBMP aBtn[1];
         ID       100 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 2 ] ;
         RESOURCE "New16" ;
         NOBORDER

         aBtn[1]:SetColor( 0, nRGB( 255, 255, 255 )  )
         aBtn[1]:bAction   := {|| ::oDetOrdCar:Append( oBrw ) }

      REDEFINE BTNBMP aBtn[2];
         ID       110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 2 ] ;
         RESOURCE "Edit16" ;
         NOBORDER

         aBtn[2]:SetColor( 0, nRGB( 255, 255, 255 )  )
         aBtn[2]:bAction   := {|| ::oDetOrdCar:Edit( oBrw ) }

      REDEFINE BTNBMP aBtn[3];
         ID       120 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 2 ] ;
         RESOURCE "Del16" ;
         NOBORDER

         aBtn[3]:SetColor( 0, nRGB( 255, 255, 255 )  )
         aBtn[3]:bAction   := {|| ::oDetOrdCar:Del( oBrw ) }

      REDEFINE BTNBMP aBtn[4];
         ID       130 ;
         OF       oFld:aDialogs[ 2 ] ;
         RESOURCE "Zoom16" ;
         NOBORDER

         aBtn[4]:SetColor( 0, nRGB( 255, 255, 255 )  )
         aBtn[4]:bAction   := {|| ::oDetOrdCar:Zoom( oBrw ) }

      REDEFINE IBROWSE oBrw ;
         FIELDS   AllTrim( ::oDetOrdCar:oDbfVir:cRef ) + CRLF + Alltrim( ::oDetOrdCar:oDbfVir:cDetalle ),;
                  Trans( ::oDetOrdCar:oDbfVir:nUniOrd, MasUnd() );
         HEAD     "Artículo",;
                  "Und.";
         FIELDSIZES ;
                  170,;
                  30 ;
         JUSTIFY  .f.,;
                  .t. ;
         ALIAS    ( ::oDetOrdCar:oDbfVir:cAlias ) ;
         ID       200 ;
         OF       oFld:aDialogs[ 2 ]

   ACTIVATE DIALOG oDlg ON INIT( oDlg:SetMenu( pdaMenuLinea( oDlg ) ) )

   // Restauramos la ventana---------------------------------------------------

   oWnd():Show()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

static function pdaMenuLinea( oDlg, oThis )

   local oMenu

   DEFINE MENU oMenu ;
      RESOURCE 100 ;
      BITMAPS  10 ; // bitmaps resoruces ID
      IMAGES   3     // number of images in the bitmap

      REDEFINE MENUITEM ID 110 OF oMenu ACTION ( oDlg:End( IDOK ) )

      REDEFINE MENUITEM ID 120 OF oMenu ACTION ( oDlg:End( IDCANCEL ) )

   oDlg:SetMenu( oMenu )

Return oMenu

#endif

//---------------------------------------------------------------------------//

#ifndef __PDA__

METHOD EdtRotor( oDlg )

   MENU ::oMenu

      MENUITEM    "&1. Rotor"

         MENU

            MENUITEM    "&1. Modificar agente";
               MESSAGE  "Modificar la ficha del Agente" ;
               RESOURCE "Security_Agent_16";
               ACTION   ( if( !Empty( ::oDbf:cCodAge ), EdtAge( ::oDbf:cCodAge ), MsgStop( "Debe que seleccionar un agente" ) ) );

            MENUITEM    "&2. Modificar transportista";
               MESSAGE  "Modificar la ficha del transportista" ;
               RESOURCE "Truck_Blue_16";
               ACTION   ( if( !Empty( ::oDbf:cCodTrn ), EdtTrans( ::oDbf:cCodTrn ), MsgStop( "Debe de seleccionar un transportista" ) ) );

         ENDMENU

   ENDMENU

   oDlg:SetMenu( ::oMenu )

RETURN ( ::oMenu )

#endif

//---------------------------------------------------------------------------//

Method LoadTrans( oGet, oGetKgs )

   if ::oTrans:oDbf:SeekInOrd( oGet:VarGet(), "cCodTrn" )
      oGetKgs:cText( ::oTrans:oDbf:nKgsTrn )
   end if

   ::CalculaDiferencias()

Return .t.

//---------------------------------------------------------------------------//

METHOD CalculaDiferencias()

   if ::oDbf:nKgsTrn != 0
      ::oDiferencias:cText( ::oDbf:nKgsTrn - ::nPeso )
   else
      ::oDiferencias:cText( 0 )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

FUNCTION OrdCar( oMenuItem, oWnd )

   local oOrdCar
   local nLevel

   DEFAULT  oMenuItem   := "01039"
   DEFAULT  oWnd        := oWnd()

   nLevel               := nLevelUsr( oMenuItem )
   if nAnd( nLevel, 1 ) != 0
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
   Anotamos el movimiento para el navegador
   */

   AddMnuNext( "Ordenes de carga", ProcName() )

   oOrdCar  := TOrdCarga():New( cPatEmp() )
   oOrdCar:Activate( nLevel )

RETURN NIL

//--------------------------------------------------------------------------//

METHOD lSave( nMode, oDlg )

   local cNumAlb

   if nMode == APPD_MODE

      if Empty( ::oDbf:cCodAge )
         MsgStop( "El código de agente no puede estar vacío." )
         Return .f.
      end if

      if Empty( ::oDbf:cCodTrn )
         MsgStop( "El código de transportista no puede estar vacío." )
         Return .f.
      end if

      if ::oDetOrdCar:oDbfVir:Lastrec() == 0
         MsgStop( "No se puede almacenar un documento sin líneas." )
         Return .f.
      end if

   end if

   if ::nDiferencias < 0
      MsgStop( "La carga excede la capacidad del medio de transporte." )
   end if

   /*
   Marcamos los albaranes importados-------------------------------------------
   */

   for each cNumAlb in ::aAlbaranes

      if ::oAlbCliT:SeekInOrd( cNumAlb, "nNumAlb" )
         ::oAlbCliT:fieldPutByName( "lOrdCar", .t. )
      end if

   next

   /*
   Marcamos la orden para envio a la pda---------------------------------------
   */

   if nMode != ZOOM_MODE
      ::oDbf:lSndInt := .t.
   end if

   /*
   Cerramos la ventana---------------------------------------------------------
   */

   if !Empty( oDlg )
      oDlg:End( IDOK )
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD GetNewCount()

   ::oDbf:nNumOrd    := nNewDoc( nil, ::oDbf:nArea, "NORDCAR", nil, ::oDbfCnt:nArea )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD nPesOrdVir( lPic )

   local nPeso  := 0

   DEFAULT lPic   := .f.

   ::oDetOrdCar:oDbfVir:GetStatus()

   ::oDetOrdCar:oDbfVir:GoTop()

   while !::oDetOrdCar:oDbfVir:Eof()

      nPeso     += ::oDetOrdCar:nTotPeso( ::oDetOrdCar:oDbfVir )

      ::oDetOrdCar:oDbfVir:Skip()

   end while

   ::oDetOrdCar:oDbfVir:SetStatus()

   ::oPeso:cText( nPeso )

   ::oPeso:Refresh()

   ::CalculaDiferencias()

RETURN ( if( lPic, Trans( nPeso, MasUnd() ), nPeso ) )

//----------------------------------------------------------------------------//

#ifndef __PDA__

METHOD ImpAlbCli()

	local oDlg
   local oBrw
   local oGet1
   local cGet1
   local This        := Self
   local nOrd        := GetBrwOpt( "BrwAlbCli" )
   local oCbxOrd
   local aCbxOrd     := { "Número", "Fecha", "Cliente", "Nombre" }
   local cCbxOrd

   nOrd              := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd           := aCbxOrd[ nOrd ]

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Albaranes de clientes"

		REDEFINE GET oGet1 VAR cGet1;
			ID 		104 ;
         BITMAP   "FIND" ;
         OF       oDlg

      oGet1:bChange  := {| nKey, nFlags, Self | AutoSeek( nKey, nFlags, Self, oBrw, This:oAlbCliT:cAlias ) }

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( This:oAlbCliT:OrdSetFocus( oCbxOrd:nAt ), oBrw:refresh(), oGet1:SetFocus() ) ;
			OF 		oDlg

      oBrw                    := IXBrowse():New( oDlg )

      oBrw:SetoDbf( ::oAlbCliT )
      oBrw:nMarqueeStyle      := 6
      oBrw:cName              := "Albaranes de clientes"
      oBrw:bClrSel            := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus       := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }
      oBrw:CreateFromResource( 105 )

      with object ( oBrw:AddCol() )
         :cHeader             := "Or. Orden de carga"
         :bStrData            := {|| "" }
         :bEditValue          := {|| ::oAlbCliT:lOrdCar }
         :nWidth              := 20
         :SetCheck( { "Cnt16", "Nil16" } )
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Número"
         :bStrData            := {|| ::oAlbCliT:cSerAlb + "/" + AllTrim( Str( ::oAlbCliT:nNumAlb ) ) + "/" + ::oAlbCliT:cSufAlb }
         :nWidth              := 70
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Fecha"
         :bStrData            := {|| DtoC( ::oAlbCliT:dFecAlb ) }
         :nWidth              := 70
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Cliente"
         :bStrData            := {|| ::oAlbCliT:cCodCli }
         :nWidth              := 70
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Nombre"
         :bStrData            := {|| ::oAlbCliT:cNomCli }
         :nWidth              := 275
      end with

      oBrw:bLDblClick         := {|| ::StartImpAlbCli( oBrw:aSelected, oDlg ) }

		REDEFINE BUTTON ;
			ID 		500 ;
			OF 		oDlg ;
			WHEN 		.F.

		REDEFINE BUTTON ;
			ID 		501 ;
			OF 		oDlg ;
			WHEN 		.F.

		REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         ACTION   ( ::StartImpAlbCli( oBrw:aSelected, oDlg ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

   ACTIVATE DIALOG oDlg CENTER

   SetBrwOpt( "BrwAlbCli", ::oAlbCliT:OrdNumber() )

   ::nPesOrdVir()

RETURN ( .t. )

#endif

//--------------------------------------------------------------------------//

METHOD StartImpAlbCli( aSelected, oDlg )

   local nRec
   local nRecAlbCliT    := ::oAlbCliT:Recno()
   local nRecAlbCliL    := ::oAlbCliL:Recno()
   local nOrdAlbCliL    := ::oAlbCliL:OrdSetFocus( "nNumAlb" )
   local nPos

   for each nRec in aSelected

      ::oAlbCliT:GoTo( nRec )

      if ( nPos := aScan( ::aAlbaranes, ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb ) ) == 0 .and.;
         !::oAlbCliT:lOrdCar

         /*
         Guardamos el numero del albarán para despues marcarlo-----------------
         */

         aAdd( ::aAlbaranes, ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb )

         /*
         Insertamos las lineas----------------------------------------------------
         */

         if ::oAlbCliL:Seek( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb )

            while ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb == ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb .and.;
                  !::oAlbCliL:Eof()

                  ::oDetOrdCar:oDbfVir:Append()

                  ::oDetOrdCar:oDbfVir:nNumOrd     := ::oDbf:nNumOrd
                  ::oDetOrdCar:oDbfVir:cSufOrd     := ::oDbf:cSufOrd
                  ::oDetOrdCar:oDbfVir:cRef        := ::oAlbCliL:cRef
                  ::oDetOrdCar:oDbfVir:cDetalle    := ::oAlbCliL:cDetalle
                  ::oDetOrdCar:oDbfVir:cCodPr1     := ::oAlbCliL:cCodPr1
                  ::oDetOrdCar:oDbfVir:cCodPr2     := ::oAlbCliL:cCodPr2
                  ::oDetOrdCar:oDbfVir:cValPr1     := ::oAlbCliL:cValPr1
                  ::oDetOrdCar:oDbfVir:cValPr2     := ::oAlbCliL:cValPr2
                  ::oDetOrdCar:oDbfVir:lLote       := ::oAlbCliL:lLote
                  ::oDetOrdCar:oDbfVir:cLote       := ::oAlbCliL:cLote
                  ::oDetOrdCar:oDbfVir:nCajOrd     := ::oAlbCliL:nCanEnt
                  ::oDetOrdCar:oDbfVir:nUniOrd     := ::oAlbCliL:nUniCaja
                  ::oDetOrdCar:oDbfVir:nPeso       := ::oAlbCliL:nPesoKg
                  ::oDetOrdCar:oDbfVir:cUndPes     := ::oAlbCliL:cPesoKg
                  ::oDetOrdCar:oDbfVir:cNumAlb     := ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb

                  ::oDetOrdCar:oDbfVir:Save()

               ::oAlbCliL:Skip()

            end if

         end if

      else

         msgStop( "El albarán " + ::oAlbCliT:cSerAlb + "/" + AllTrim( Str( ::oAlbCliL:nNumAlb ) ) + "/" + ::oAlbCliL:cSufAlb + " ya ha sido insertado en un orden de carga." )

      end if

   next

   /*
   Dejamos las tablas en la posisión y orden que estaban-----------------------
   */

   ::oAlbCliL:OrdSetFocus( nOrdAlbCliL )

   ::oAlbCliL:GoTo( nRecAlbCliL )

   ::oAlbCliT:GoTo( nRecAlbCliT )

   /*
   Refrescamos el browse y cerramos el diálogo---------------------------------
   */

   ::oBrwDet:Refresh()

   oDlg:End( IDOK )

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD RollBackAlbCli()

   local aAlbCliT    := {}
   local cNumAlb
   local nPos

   ::oDetOrdCar:oDbf:GoTop()

   while !::oDetOrdCar:oDbf:Eof()

      if ( nPos := aScan( aAlbCliT, ::oDetOrdCar:oDbf:cNumAlb ) ) == 0
         aAdd( aAlbCliT, ::oDetOrdCar:oDbf:cNumAlb )
      end if

      ::oDetOrdCar:oDbf:Skip()

   end while

   for each cNumAlb in aAlbCliT

      if ::oAlbCliT:SeekInOrd( cNumAlb, "nNumAlb" )

         ::oAlbCliT:fieldPutByName( "lOrdCar", .f. )

      end if

   next

RETURN ( Self )

//---------------------------------------------------------------------------//

function SynOrdCar( cPath )

   local dbfOrdCarT
   local dbfOrdCarL
   local dbfAlbCliT
   local dbfAlbCliL
   local oError
   local oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT cPath  := cPatEmp()

   BEGIN SEQUENCE

   dbUseArea( .t., cDriver(), cPath + "ORDCARP.DBF", cCheckArea( "ORDCARP", @dbfOrdCarT ), .f. )
   if !lAIS(); ordListAdd( cPath + "ORDCARP.CDX" ); else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., cDriver(), cPath + "ORDCARL.DBF", cCheckArea( "ORDCARL", @dbfOrdCarL ), .f. )
   if !lAIS(); ordListAdd( cPath + "ORDCARL.CDX" ); else ; ordSetFocus( 0 ) ; end

   dbUseArea( .t., cDriver(), cPath + "ALBCLIT.DBF", cCheckArea( "ALBCLIT", @dbfAlbCliT ), .f. )
   if !lAIS(); ordListAdd( cPath + "ALBCLIT.CDX" ); else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., cDriver(), cPath + "ALBCLIL.DBF", cCheckArea( "ALBCLIL", @dbfAlbCliL ), .f. )
   if !lAIS(); ordListAdd( cPath + "ALBCLIL.CDX" ); else ; ordSetFocus( 1 ) ; end

   /*
   Eliminamos lineas huerfanas-------------------------------------------------
   */

   ( dbfOrdCarL )->( dbGoTop() )
   while !( dbfOrdCarL )->( eof() )
      if !( dbfOrdCarT )->( dbSeek( Str( ( dbfOrdCarL )->nNumOrd ) + ( dbfOrdCarL )->cSufOrd ) )
         ( dbfOrdCarL )->( dbDelete() )
      end if
      ( dbfOrdCarL )->( dbSkip() )
   end while

   /*
   Sincronizamos albaranes añadidos a ordenes de carga antiguos----------------
   */

   ( dbfAlbCliT )->( dbGoTop() )

   while !( dbfAlbCliT )->( Eof() )

      if ( dbfAlbCliT )->nNumOrd != 0

         if ( dbfOrdCarT )->( dbSeek( Str( ( dbfAlbCliT )->nNumOrd ) + ( dbfAlbCliT )->cSufOrd ) )

            if ( dbfAlbCliL )->( dbSeek( ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb ) )

               while ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb == ( dbfAlbCliL )->cSerAlb + Str( ( dbfAlbCliL )->nNumAlb ) + ( dbfAlbCliL )->cSufAlb .and.;
                     !( dbfAlbCliL )->( Eof() )

                     ( dbfOrdCarL )->( dbAppend() )

                     ( dbfOrdCarL )->nNumOrd    := ( dbfAlbCliT )->nNumOrd
                     ( dbfOrdCarL )->cSufOrd    := ( dbfAlbCliT )->cSufOrd
                     ( dbfOrdCarL )->cRef       := ( dbfAlbCliL )->cRef
                     ( dbfOrdCarL )->cDetalle   := ( dbfAlbCliL )->cDetalle
                     ( dbfOrdCarL )->cCodPr1    := ( dbfAlbCliL )->cCodPr1
                     ( dbfOrdCarL )->cCodPr2    := ( dbfAlbCliL )->cCodPr2
                     ( dbfOrdCarL )->cValPr1    := ( dbfAlbCliL )->cValPr1
                     ( dbfOrdCarL )->cValPr2    := ( dbfAlbCliL )->cValPr2
                     ( dbfOrdCarL )->lLote      := ( dbfAlbCliL )->lLote
                     ( dbfOrdCarL )->cLote      := ( dbfAlbCliL )->cLote
                     ( dbfOrdCarL )->nCajOrd    := ( dbfAlbCliL )->nCanEnt
                     ( dbfOrdCarL )->nUniOrd    := ( dbfAlbCliL )->nUniCaja
                     ( dbfOrdCarL )->nPeso      := ( dbfAlbCliL )->nPesoKg
                     ( dbfOrdCarL )->cUndPes    := ( dbfAlbCliL )->cPesoKg
                     ( dbfOrdCarL )->cNumAlb    := ( dbfAlbCliL )->cSerAlb + Str( ( dbfAlbCliL )->nNumAlb ) + ( dbfAlbCliL )->cSufAlb

                  ( dbfAlbCliL )->( dbSkip() )

               end while

            end if

            ( dbfAlbCliT )->lOrdCar                   := .t.

         else

            ( dbfAlbCliT )->lOrdCar                   := .f.

         end if

      /*
      Quitamos los valores para que no entre mas en el sincronizar-------------
      */

      ( dbfAlbCliT )->nNumOrd                   := 0
      ( dbfAlbCliT )->cSufOrd                   := Space(1)

      end if

      ( dbfAlbCliT )->( dbSkip() )

   end while

   RECOVER USING oError

      msgStop( "Imposible sincronizar ordenes de carga" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !Empty( dbfOrdCarT ) .and. ( dbfOrdCarT )->( Used() )
      ( dbfOrdCarT )->( dbCloseArea() )
   end if

   if !Empty( dbfOrdCarL ) .and. ( dbfOrdCarL )->( Used() )
      ( dbfOrdCarL )->( dbCloseArea() )
   end if

   if !Empty( dbfAlbCliT ) .and. ( dbfAlbCliT )->( Used() )
      ( dbfAlbCliT )->( dbCloseArea() )
   end if

   if !Empty( dbfAlbCliL ) .and. ( dbfAlbCliL )->( Used() )
      ( dbfAlbCliL )->( dbCloseArea() )
   end if

return nil

//---------------------------------------------------------------------------//

function isOrdCar()

   with object ( TOrdCarga():Create() )

      :DefineFiles()

      if !lExistTable( :oDbf:cFile )

         :oDbf:Create()
         :oDbf:Activate( .f., .f. )
         :oDbf:IdxFCheck()

      endif

      :End()

   end with

   with object ( TDetOrdCar():Create() )

      :OpenFiles()

      if !lExistTable( :oDbf:cFile )

         :oDbf:Create()
         :oDbf:Activate( .f., .f. )
         :oDbf:IdxFCheck()

      endif

      :End()

   end with

return nil

//---------------------------------------------------------------------------//

#ifdef __PDA__

CLASS pdaOrdCarSenderReciver

   Method CreateData()

END CLASS

//----------------------------------------------------------------------------//

Method CreateData( oPgrActual, oSayStatus ) CLASS pdaOrdCarSenderReciver

   local pdaOrdCarT
   local pdaOrdCarL
   local pcOrdCarT
   local pcOrdCarL
   local lExist      := .f.
   local cFileName

   USE ( cPatEmp() + "OrdCarP.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "OrdCarP", @pdaOrdCarT ) )
   SET ADSINDEX TO ( cPatEmp() + "OrdCarP.Cdx" ) ADDITIVE

   USE ( cPatEmp() + "OrdCarL.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "OrdCarL", @pdaOrdCarL ) )
   SET ADSINDEX TO ( cPatEmp() + "OrdCarL.Cdx" ) ADDITIVE

   dbUseArea( .t., cDriver(), cPatPc() + "OrdCarP.Dbf", cCheckArea( "OrdCarP", @pcOrdCarT ), .t. )
   ( pcOrdCarT )->( ordListAdd( cPatPc() + "OrdCarP.Cdx" ) )

   dbUseArea( .t., cDriver(), cPatPc() + "OrdCarL.Dbf", cCheckArea( "OrdCarL", @pcOrdCarL ), .t. )
   ( pcOrdCarL )->( ordListAdd( cPatPc() + "OrdCarL.Cdx" ) )

   if !Empty( oPgrActual )
      oPgrActual:SetRange( 0, ( pcOrdCarT )->( OrdKeyCount() ) )
   end if

   ( pcOrdCarT )->( dbGoTop() )

   while !( pcOrdCarT )->( eof() )

      if( pcOrdCarT )->lSndInt

         if dbLock( pcOrdCarT )
            ( pcOrdCarT )->lSndInt := .f.
            ( pcOrdCarT )->( dbUnLock() )
         end if

         if ( pdaOrdCarT )->( dbSeek( Str( ( pcOrdCarT )->nNumOrd ) + ( pcOrdCarT )->cSufOrd ) )
            dbPass( pcOrdCarT, pdaOrdCarT, .f. )
         else
            dbPass( pcOrdCarT, pdaOrdCarT, .t. )
         end if

         while ( pdaOrdCarL )->( dbSeek( Str( ( pcOrdCarT )->nNumOrd ) + ( pcOrdCarT )->cSufOrd ) )
            if dbLock( pdaOrdCarL )
               ( pdaOrdCarL )->( dbDelete() )
               ( pdaOrdCarL )->( dbUnLock() )
            endif
         end while

         if ( pcOrdCarL )->( dbSeek( Str( ( pcOrdCarT )->nNumOrd ) + ( pcOrdCarT )->cSufOrd ) )

            while Str( ( pcOrdCarT )->nNumOrd ) + ( pcOrdCarT )->cSufOrd == Str( ( pcOrdCarL )->nNumOrd ) + ( pcOrdCarL )->cSufOrd .and. !( pcOrdCarL )->( eof() )

               dbPass( pcOrdCarL, pdaOrdCarL, .t. )

               ( pcOrdCarL )->( dbSkip() )

            end while

         end if

      end if

      ( pcOrdCarT )->( dbSkip() )

      if !Empty( oSayStatus )
         oSayStatus:SetText( "Sincronizando cabecera de órdenes de carga " + Alltrim( Str( ( pcOrdCarT )->( OrdKeyNo() ) ) ) + " de " + Alltrim( Str( ( pcOrdCarT )->( OrdKeyCount() ) ) ) )
      end if

      SysRefresh()

      if !Empty( oPgrActual )
         oPgrActual:SetPos( ( pcOrdCarT )->( OrdKeyNo() ) )
      end if

      SysRefresh()

   end while

   CLOSE ( pdaOrdCarT )
   CLOSE ( pdaOrdCarL )
   CLOSE ( pcOrdCarT  )
   CLOSE ( pcOrdCarL  )

Return ( Self )

#endif

//---------------------------------------------------------------------------//

METHOD Enviar() CLASS TOrdCarga

   local nOrdCar
   local nRec     := ::oDbf:Recno()

   for each nOrdCar in ( ::oWndBrw:oBrw:aSelected )
      ::oDbf:GoTo( nOrdCar )
      ::oDbf:FieldPutByName( "lSndInt", !::oDbf:lSndInt )
   next

   ::oDbf:GoTo( nRec )

   ::oWndBrw:Refresh()

RETURN ( Self )

//---------------------------------------------------------------------------//

#ifdef __PDA__

static function pdaOpenFiles()

   local lOpen       := .t.
   local oError
   local oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   /*
   Bases de datos necesarias para imprimir liquidaciones-----------------------
   */

      if !TDataCenter():OpenAlbCliT( @dbfAlbCliT )
         lOpen       := .f.
      else 
         ( dbfAlbCliT )->( OrdSetFocus( "nNumAlb" ) )      
      end if

      USE ( cPatEmp() + "ALBCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIL", @dbfAlbCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBCLIL.CDX" ) ADDITIVE
      ( dbfAlbCliL )->( OrdSetFocus( "nNumAlb" ) )

      if !TDataCenter():OpenFacCliT( @dbfFacCliT )
         lOpen       := .f.
      else 
         ( dbfFacCliT )->( OrdSetFocus( "nNumFac" ) )
      end if

      USE ( cPatEmp() + "FACCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIL", @dbfFacCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "FACCLIL.CDX" ) ADDITIVE
      ( dbfFacCliL )->( OrdSetFocus( "nNumFac" ) )

      USE ( cPatGrp() + "TRANSPOR.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "Transpor", @dbfTransport ) )
      SET ADSINDEX TO ( cPatGrp() + "TRANSPOR.CDX" ) ADDITIVE

      USE ( cPatArt() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "Articulo", @dbfArticulo ) )
      SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

      USE ( cPatEmp() + "HISMOV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "HISMOV", @dbfHisMov ) )
      SET ADSINDEX TO ( cPatEmp() + "HISMOV.CDX" ) ADDITIVE

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )
      pdaCloseFiles()

      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

return ( lOpen )

//---------------------------------------------------------------------------//

static function pdaCloseFiles()

   CLOSE( dbfAlbCliT   )
   CLOSE( dbfAlbCliL   )
   CLOSE( dbfFacCliT   )
   CLOSE( dbfFacCliL   )
   CLOSE( dbfTransport )
   CLOSE( dbfArticulo  )
   CLOSE( dbfHisMov    )

   dbfAlbCliT     := nil
   dbfAlbCliL     := nil
   dbfFacCliT     := nil
   dbfFacCliL     := nil
   dbfTransport   := nil
   dbfArticulo    := nil
   dbfHisMov      := nil

return .t.

//---------------------------------------------------------------------------//

function pdaEstado()

   local oDlg
   local oSayTit
   local oBtn
   local oFont

   /*
   Abrimos las tablas necesarias-----------------------------------------------
   */

   if !pdaOpenFiles()
      Return ( .f. )
   end if

   /*
   Comprobamos que el transportista no esté vacío------------------------------
   */

   if Empty( cCodTra() )
      MsgStop( 'Transportista en cofiguración no puede estar vacío' )
      Return ( .f. )
   end if

   /*
   Creamos una tabla temporal--------------------------------------------------
   */

   if CreaTemporal()
      Return( .f. )
   end if

   /*
   Distintas cajas de dialogo--------------------------------------------------
   */

   DEFINE FONT oFont NAME "Verdana" SIZE 0, -14

   DEFINE DIALOG oDlg RESOURCE "ESTADO_PDA"

      REDEFINE BTNBMP oBtn ;
         ID       100 ;
         OF       oDlg ;
         FILE     ( cPatBmp() + "preferences_16.bmp" ) ;
         NOBORDER ;
         ACTION      ( nil )

      oBtn:SetColor( 0, nRGB( 255, 255, 255 )  )

      REDEFINE SAY oSayTit ;
         VAR      "Estado del camión" ;
         ID       110 ;
         COLOR    "N/W*" ;
         FONT     oFont ;
         OF       oDlg

      REDEFINE SAY oSayProgress ;
         VAR      cSayProgress ;
         ID       120 ;
         COLOR    "N/W*" ;
         FONT     oFont ;
         OF       oDlg

      oPgrEstado   := TProgress():Redefine( 130, oDlg )
      oPgrEstado:SetPos( 0 )
      oPgrEstado:SetRange( 0, 3 )

      REDEFINE IBROWSE oBrwEstado;
         FIELDS   AllTrim( ( dbfTmpEstado )->cCodArt ) + CRLF + AllTrim( ( dbfTmpEstado )->cNomArt ),;
                  Trans( ( dbfTmpEstado )->nStkArt, MasUnd() ),;
                  "";
         HEAD     "Artículo",;
                  "Und.",;
                  "";
         FIELDSIZES ;
                  187,;
                  30,;
                  0;
         JUSTIFY  .f.,;
                  .t.,;
                  .f. ;
         ALIAS    ( dbfTmpEstado ) ;
         ID       140 ;
         OF       oDlg

   oDlg:bStart                := {|| CalculoEstado() }

   ACTIVATE DIALOG oDlg ;
      ON INIT ( oDlg:SetMenu( pdaEstadoMenu( oDlg, oBrwEstado ) ) )

   /*
   Cerramos las tablas y temporales--------------------------------------------
   */

   KillTemporal()

   pdaCloseFiles()

   //Restauramos la ventana---------------------------------------------------

   oWnd():Show()

return .t.

//---------------------------------------------------------------------------//

static function pdaEstadoMenu( oDlg, oBrw )

  local oMenu

   DEFINE MENU oMenu ;
      RESOURCE 190 ;
      BITMAPS  70 ; // bitmaps resoruces ID
      IMAGES   2     // number of images in the bitmap

      REDEFINE MENUITEM ID 191 OF oMenu ACTION ( ImprimirEstado(), oBrw:Refresh() )

      REDEFINE MENUITEM ID 192 OF oMenu ACTION ( oDlg:End() )

Return oMenu

//---------------------------------------------------------------------------//

static function CreaTemporal()

   local oError
   local oBlock
   local lErrors  := .f.

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   cTmpEstado  := cGetNewFileName( cPatTmp() + "TmpEst" )

   dbCreate( cTmpEstado, aSqlStruct( aItmTmpEst() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cTmpEstado, cCheckArea( "TmpEst", @dbfTmpEstado ), .f. )

   ( dbfTmpEstado )->( OrdCondSet( "!Deleted()", {|| !Deleted() } ) )
   ( dbfTmpEstado )->( OrdCreate( cTmpEstado, "cCodArt", "cCodArt", {|| Field->cCodArt } ) )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible crear tablas temporales." )

      KillTemporal()

      lErrors     := .t.

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lErrors )

//---------------------------------------------------------------------------//

static function aItmTmpEst()

   local aItmTmpEst  := {}

   aAdd( aItmTmpEst, {"cCodArt"     ,"C",  18,  0, "Código del procucto" } )
   aAdd( aItmTmpEst, {"cNomArt"     ,"C", 100 , 0, "Nombre del producto" } )
   aAdd( aItmTmpEst, {"nStkArt"     ,"N",  16 , 6, "Stock del producto" } )

return ( aItmTmpEst )

//---------------------------------------------------------------------------//

static function KillTemporal()

   if !Empty( dbfTmpEstado ) .and. ( dbfTmpEstado )->( Used() )
      ( dbfTmpEstado )->( dbCloseArea() )
   end if

   dbfTmpEstado   := nil

   dbfErase( cTmpEstado )

return .t.

//---------------------------------------------------------------------------//

static function CalculoEstado()

   local cAlmacen    := cDefAlm()

   oSayProgress:SetText( "Procesando ordenes de carga" )
   oPgrEstado:SetPos( 0 )
   oPgrEstado:SetRange( 0, ( dbfHisMov )->( LastRec() ) )

   /*
   Movimientos de almacen------------------------------------------------------
   */

   while !( dbfHisMov )->( eof() )

      if !Empty( ( dbfHisMov )->cAliMov ) .and. ( dbfHisMov )->cAliMov == cAlmacen

         if !( dbfTmpEstado )->( dbSeek( ( dbfHisMov )->cRefMov ) )

            ( dbfTmpEstado )->( dbAppend() )

            ( dbfTmpEstado )->cCodArt     := ( dbfHisMov )->cRefMov
            ( dbfTmpEstado )->cNomArt     := RetFld( ( dbfHisMov )->cRefMov, dbfArticulo, "Nombre" )
            ( dbfTmpEstado )->nStkArt     := nTotNMovAlm( dbfHisMov )

            ( dbfTmpEstado )->( dbUnLock() )

         else

            if dbLock( dbfTmpEstado )
               ( dbfTmpEstado )->nStkArt  += nTotNMovAlm( dbfHisMov )
               ( dbfTmpEstado )->( dbUnLock() )
            end if

         end if

      end if

      if !Empty( ( dbfHisMov )->cAloMov ) .and. ( dbfHisMov )->cAloMov == cAlmacen

         if !( dbfTmpEstado )->( dbSeek( ( dbfHisMov )->cRefMov ) )

            ( dbfTmpEstado )->( dbAppend() )

            ( dbfTmpEstado )->cCodArt     := ( dbfHisMov )->cRefMov
            ( dbfTmpEstado )->cNomArt     := RetFld( ( dbfHisMov )->cRefMov, dbfArticulo, "Nombre" )
            ( dbfTmpEstado )->nStkArt     := -( nTotNMovAlm( dbfHisMov ) )

            ( dbfTmpEstado )->( dbUnLock() )

         else

            if dbLock( dbfTmpEstado )
               ( dbfTmpEstado )->nStkArt  -= nTotNMovAlm( dbfHisMov )
               ( dbfTmpEstado )->( dbUnLock() )
            end if

         end if

      end if

      oPgrEstado:SetPos( ( dbfHisMov )->( Recno() ) )

      ( dbfHisMov )->( dbSkip() )

   end while

   /*
   ALBARANES-------------------------------------------------------------------
   */

   oSayProgress:SetText( "Procesando albaranes" )
   oPgrEstado:SetPos( 0 )
   oPgrEstado:SetRange( 0, ( dbfAlbCliT )->( LastRec() ) )

   while !( dbfAlbCliT )->( eof() )

      if !( dbfAlbCliT )->lFacturado                                 .and.;
         ( dbfAlbCliL )->( dbSeek( ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb ) )

         while ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb == ( dbfAlbCliL )->cSerAlb + Str( ( dbfAlbCliL )->nNumAlb ) + ( dbfAlbCliL )->cSufAlb .and. !( dbfAlbCliL )->( eof() )

            if ( dbfAlbCliL )->cAlmLin == cAlmacen

               if !( dbfTmpEstado )->( dbSeek( ( dbfAlbCliL )->cRef ) )

                  ( dbfTmpEstado )->( dbAppend() )

                  ( dbfTmpEstado )->cCodArt     := ( dbfAlbCliL )->cRef
                  ( dbfTmpEstado )->cNomArt     := ( dbfAlbCliL )->cDetalle
                  ( dbfTmpEstado )->nStkArt     := -( nTotNAlbCli( dbfAlbCliL ) )

                  ( dbfTmpEstado )->( dbUnLock() )

               else

                  if dbLock( dbfTmpEstado )
                     ( dbfTmpEstado )->nStkArt  -= nTotNAlbCli( dbfAlbCliL )
                     ( dbfTmpEstado )->( dbUnLock() )
                  end if

               end if

            end if

            ( dbfAlbCliL )->( dbSkip() )

         end while

      end if

      oPgrEstado:SetPos( ( dbfAlbCliT )->( Recno() ) )

      ( dbfAlbCliT )->( dbSkip() )

   end while

   /*
   FACTURAS--------------------------------------------------------------------
   */

   oSayProgress:SetText( "Procesando facturas" )
   oPgrEstado:SetPos( 0 )
   oPgrEstado:SetRange( 0, ( dbfFacCliT )->( LastRec() ) )

   while !( dbfFacCliT )->( eof() )

      if ( dbfFacCliL )->( dbSeek( ( dbfFacCliT )->cSerie + Str( ( dbfFacCliT )->nNumFac ) + ( dbfFacCliT )->cSufFac ) )

         while ( dbfFacCliT )->cSerie + Str( ( dbfFacCliT )->nNumFac ) + ( dbfFacCliT )->cSufFac == ( dbfFacCliL )->cSerie + Str( ( dbfFacCliL )->nNumFac ) + ( dbfFacCliL )->cSufFac .and. !( dbfFacCliL )->( eof() )

            if ( dbfFacCliL )->cAlmLin == cAlmacen

               if !( dbfTmpEstado )->( dbSeek( ( dbfFacCliL )->cRef ) )

                  ( dbfTmpEstado )->( dbAppend() )

                  ( dbfTmpEstado )->cCodArt     := ( dbfFacCliL )->cRef
                  ( dbfTmpEstado )->cNomArt     := ( dbfFacCliL )->cDetalle
                  ( dbfTmpEstado )->nStkArt     := -( nTotNFacCli( dbfFacCliL ) )

                  ( dbfTmpEstado )->( dbUnLock() )

               else

                  if dbLock( dbfTmpEstado )
                     ( dbfTmpEstado )->nStkArt  -= nTotNFacCli( dbfFacCliL )
                     ( dbfTmpEstado )->( dbUnLock() )
                  end if

               end if

            end if

            ( dbfFacCliL )->( dbSkip() )

         end while

      end if

      oPgrEstado:SetPos( ( dbfFacCliT )->( Recno() ) )

      ( dbfFacCliT )->( dbSkip() )

   end while

   ( dbfTmpEstado )->( dbGoTop() )

   oPgrEstado:SetPos( ( dbfFacCliT )->( LastRec() ) )
   oSayProgress:SetText( "Proceso finalizado" )

   if !Empty( oBrwEstado )
      oBrwEstado:Refresh()
   end if

return .t.

//---------------------------------------------------------------------------//

static function ImprimirEstado()

   local oError
   local oBlock
   local nRec           := ( dbfTmpEstado )->( Recno() )
   local cTextToPrint   := ""
   local nTotalPeso     := 0

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   /*
   Cabecera de la impresión----------------------------------------------------
   */

   cTextToPrint         += CRLF + CRLF + REPLICATE( "-", 60 ) + CRLF
   cTextToPrint         += "               INFORME DEL ESTADO DEL CAMION                " + CRLF
   cTextToPrint         += "Transportista: " + PadR( RetFld( cCodTra(), dbfTransport, "cNomTrn" ), 45, Space( 1 ) ) + CRLF
   cTextToPrint         += REPLICATE( "-", 60 ) + CRLF
   cTextToPrint         += "Codigo    Nombre                                    Unidades" + CRLF

   cTextToPrint         += "--------- --------------------------------------- ----------" + CRLF

   /*
   Lineas de la impresión------------------------------------------------------
   */

   ( dbfTmpEstado )->( dbGoTop() )

   while !( dbfTmpEstado )->( Eof() )

      cTextToPrint      += PadR( ( dbfTmpEstado )->cCodArt, 9, Space( 1 ) ) + Space( 1 )
      cTextToPrint      += PadR( ( dbfTmpEstado )->cNomArt, 39, Space( 1 ) ) + Space( 1 )
      cTextToPrint      += PadL( Trans( ( dbfTmpEstado )->nStkArt, "@E 9999999.99" ), 10, Space( 1 ) ) + CRLF

      if ( dbfTmpEstado )->nStkArt > 0
         nTotalPeso     += ( ( dbfTmpEstado )->nStkArt * RetFld( ( dbfTmpEstado )->cCodArt, dbfArticulo, "NPESOKG" ) )
      end if

      ( dbfTmpEstado )->( dbSkip() )

   end while

   /*
   Fin de la impresión----------------------------------------------------
   */

   cTextToPrint   += REPLICATE( "-", 60 ) + CRLF

   msginfo( "Compruebe si la impresora está en línea y si tiene papel suficiente", "¡Atención!" )

   SendText( cTextToPrint )

   ( dbfTmpEstado )->( dbGoTo( nRec ) )

   RECOVER

      msgStop( "Ocurrió un error a la hora de imprimir el estado" )

   END SEQUENCE

   ErrorBlock( oBlock )

return .t.

//---------------------------------------------------------------------------//
#endif










































































































































































































































































































































































































































































































































































































































































































































































































































































