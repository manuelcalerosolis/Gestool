#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "XBrowse.ch"

//----------------------------------------------------------------------------//

Function StartTMaquina()

   local oMaquina := TMaquina():New( cPatEmp(), oWnd(), "maquinaria" )

   if !Empty( oMaquina )
      oMaquina:Activate()
   end if

Return nil

//----------------------------------------------------------------------------//

CLASS TMaquina FROM TMASDET

   DATA  cMru           INIT "gc_industrial_robot_16"
   DATA  cBitmap        INIT clrTopProduccion

   DATA  oMaquina

   DATA  oCostes
   DATA  oDetCostes
   DATA  oSeccion

   DATA  oGetTot
   DATA  nGetTot        INIT  0
   DATA  oGetHor
   DATA  nGetHor        INIT  0

   METHOD New( cPath, oWndParent, oMenuItem )
   METHOD CreateInit( cPath )
   METHOD Create( cPath )

   METHOD OpenFiles( lExclusive )
   METHOD OpenService( lExclusive )

   METHOD CloseFiles()

   METHOD DefineFiles()

   METHOD Resource( nMode )

   METHOD nTotalVirtual( oDbf )
   METHOD cTotalVirtual( oDbf )
   METHOD lTotalVirtual( oDbf, oGet )

   METHOD nTotalCosteDia( oDbf )
   METHOD cTotalCosteDia( oDbf )
   METHOD lTotalCosteDia( oDbf, oGet )

   METHOD nTotalCosteHora( cCod, oDbf, oDbfCos )
   METHOD cTotalCosteHora( cCod, cDiv, oDbf, oDbfCos )
   METHOD lTotalCosteHora( cCod, oDbf, oDbfCos, oGet )

   METHOD lPreSave( oGet, nMode )

END CLASS

//----------------------------------------------------------------------------//

METHOD New( cPath, oWndParent, oMenuItem )

   DEFAULT cPath        := cPatEmp()
   DEFAULT oWndParent   := GetWndFrame()

   if oMenuItem != nil .and. ::nLevel == nil
      ::nLevel          := Auth():Level( oMenuItem )
   else
      ::nLevel          := 1
   end if

   if nAnd( ::nLevel, 1 ) == 0
      msgStop( "Acceso no permitido." )
      return nil
   end if

   ::cPath              := cPath
   ::oWndParent         := oWndParent

   ::bFirstKey          := {|| ::oDbf:cCodMaq }

   ::oCostes            := TCosMaq():Create()

   ::oDetCostes         := TDetCostes():New( cPath, Self )
   ::AddDetail( ::oDetCostes )

   ::oSeccion           := TSeccion():Create()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD CreateInit( cPath )

   DEFAULT cPath        := cPatEmp()

   ::cPath              := cPath

   ::bFirstKey          := {|| ::oDbf:cCodMaq }

   ::oCostes            := TCosMaq():Create( cPath )

   ::oDetCostes         := TDetCostes():New( cPath, Self )
   ::AddDetail( ::oDetCostes )

   ::oSeccion           := TSeccion():Create( cPath )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Create( cPath )

   DEFAULT cPath        := cPatEmp()

   ::cPath              := cPath
   ::oDbf               := nil

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive )

   local lOpen          := .t.
   local oError
   local oBlock

   DEFAULT lExclusive   := .f.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf         := ::DefineFiles()
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

      DATABASE NEW ::oDbfDiv PATH ( cPatDat() ) FILE "DIVISAS.DBF" VIA ( cDriver() ) SHARED INDEX "DIVISAS.CDX"

      ::oCostes:OpenFiles()

      ::oSeccion:OpenFiles()

      ::OpenDetails()

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos" )

      ::CloseFiles()

      lOpen             := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD OpenService( lExclusive, cPath )

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lExclusive   := .f.

   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf         := ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

   RECOVER USING oError

      lOpen             := .f.

      ::CloseFiles()

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD CloseFiles()

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:End()
      ::oDbf      := nil
   end if

   if ::oCostes   != nil
      ::oCostes:End()
   end if

   if ::oSeccion != nil
      ::oSeccion:End()
   end if

   ::oCostes      := nil
   ::oSeccion     := nil

   ::CloseDetails()

RETURN .t.

//----------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   local oDbf

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE TABLE oDbf FILE "MaqCosT.Dbf" CLASS "MaqCosT" ALIAS "MaqCosT" PATH ( cPath ) VIA ( cDriver ) COMMENT "Maquinaria"

      FIELD NAME "cCodMaq"    TYPE "C" LEN  3  DEC 0 COMMENT "Código"      COLSIZE 100    OF oDbf
      FIELD NAME "cDesMaq"    TYPE "C" LEN 35  DEC 0 COMMENT "Nombre"      COLSIZE 400    OF oDbf
      FIELD NAME "cCodSec"    TYPE "C" LEN 03  DEC 0 COMMENT "Sección"     COLSIZE 100    OF oDbf
      FIELD NAME "cCodDiv"    TYPE "C" LEN 03  DEC 0 COMMENT "Divisa"      HIDE           OF oDbf
      FIELD NAME "nVdvDiv"    TYPE "N" LEN 16  DEC 6 COMMENT "Valor divisa"HIDE           OF oDbf
      FIELD NAME "nHorDia"    TYPE "N" LEN 16  DEC 6 COMMENT "Horas dia"   HIDE           OF oDbf
      FIELD CALCULATE NAME "nTotCos"   LEN 16  DEC 6 COMMENT "Coste dia"   COLSIZE 100    VAL ::cTotalCosteDia()  ALIGN RIGHT OF oDbf
      FIELD CALCULATE NAME "nHorCos"   LEN 16  DEC 6 COMMENT "Coste hora"  COLSIZE 100    VAL ::cTotalCosteHora() ALIGN RIGHT OF oDbf

      INDEX TO "MaqCosT.Cdx" TAG "cCodMaq" ON "cCodMaq" COMMENT "Código"   NODELETED      OF oDbf
      INDEX TO "MaqCosT.Cdx" TAG "cDesMaq" ON "cDesMaq" COMMENT "Nombre"   NODELETED      OF oDbf
      INDEX TO "MaqCosT.Cdx" TAG "cCodSec" ON "cCodSec" COMMENT "Sección"  NODELETED      OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//----------------------------------------------------------------------------//

METHOD Resource( nMode )

	local oDlg
   local oGet
   local oBrwCos
   local oGetSec
   local oGetHor
   local oBmpGeneral

   if nMode == APPD_MODE
      ::oDbf:cCodDiv       := cDivEmp()
      ::oDbf:nVdvDiv       := nChgDiv( cDivEmp() )
   end if

   ::lLoadDivisa( ::oDbf:cCodDiv )

   DEFINE DIALOG oDlg RESOURCE "Maquina" TITLE LblTitle( nMode ) + "maquinaria"

      REDEFINE BITMAP oBmpGeneral ;
        ID       990 ;
        RESOURCE "gc_industrial_robot_48" ;
        TRANSPARENT ;
        OF       oDlg

      REDEFINE GET oGet VAR ::oDbf:cCodMaq;
         ID       110 ;
         WHEN     ( nMode == APPD_MODE ) ;
         VALID    NotValid( oGet, ::oDbf:cAlias, .t., "0" ) ;
			PICTURE 	"@!" ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cDesMaq;
         ID       120 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET oGetHor VAR ::oDbf:nHorDia;
         ID       130 ;
         PICTURE  "@E 99.99";
         SPINNER ;
         MIN      0 MAX 24;
         VALID    ( ::oDbf:nHorDia >= 0 .and. ::oDbf:nHorDia <= 24 );
         WHEN     ( nMode != ZOOM_MODE );
         OF       oDlg

         oGetHor:bChange := {|| ::lTotalVirtual() }

      REDEFINE GET oGetSec VAR ::oDbf:cCodSec ;
         ID       140 ;
         IDTEXT   141 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         OF       oDlg

         oGetSec:bHelp     := {|| ::oSeccion:Buscar( oGetSec ) }
         oGetSec:bValid    := {|| ::oSeccion:Existe( oGetSec, oGetSec:oHelpText, "cDesSec", .t., .t., "0" ) }

      /*
      Costes de maquinaria-----------------------------------------------------
      */

		REDEFINE BUTTON ;
			ID 		500 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( ::oDetCostes:Append( oBrwCos ), ::lTotalVirtual() )

		REDEFINE BUTTON ;
			ID 		501 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( ::oDetCostes:Edit( oBrwCos ), ::lTotalVirtual() )

		REDEFINE BUTTON ;
			ID 		502 ;
			OF 		oDlg ;
         ACTION   ( ::oDetCostes:Zoom() )

      REDEFINE BUTTON ;
         ID       503 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( ::oDetCostes:Del( oBrwCos ), ::lTotalVirtual() )

      oBrwCos                    := IXBrowse():New( oDlg )

      oBrwCos:bClrSel            := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwCos:bClrSelFocus       := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oDetCostes:oDbfVir:SetBrowse( oBrwCos ) 

      oBrwCos:nMarqueeStyle      := 5

      oBrwCos:bLDblClick         := { || ::oDetCostes:Edit( oBrwCos ), ::lTotalVirtual() }

      oBrwCos:CreateFromResource( 200 )

      with object ( oBrwCos:AddCol() )
         :cHeader                := "Código"
         :bStrData               := {|| ::oDetCostes:oDbfVir:cCodCos }
         :nWidth                 := 70
      end with

      with object ( oBrwCos:AddCol() )
         :cHeader                := "Descripción"
         :bStrData               := {|| RetFld( ::oDetCostes:oDbfVir:cCodCos, ::oCostes:oDbf:cAlias , "cDesCos" ) }
         :nWidth                 := 400
      end with

      with object ( oBrwCos:AddCol() )
         :cHeader                := "Importe"
         :bStrData               := {|| Trans( oRetFld( ::oDetCostes:oDbfVir:cCodCos, ::oCostes:oDbf, "nImpCos" ), ::cPorDiv ) }
         :nWidth                 := 100
         :nDataStrAlign          := AL_RIGHT
         :nHeadStrAlign          := AL_RIGHT
      end with

      with object ( oBrwCos:AddCol() )
         :cHeader                := "%Pct."
         :bStrData               := {|| Trans( ::oDetCostes:oDbfVir:nPctCos, "@E 999.99" ) }
         :nWidth                 := 90
         :nDataStrAlign          := AL_RIGHT
         :nHeadStrAlign          := AL_RIGHT
      end with

      with object ( oBrwCos:AddCol() )
         :cHeader                := "Total"
         :bStrData               := {|| ::oDetCostes:cTotalLinea( ::oDetCostes:oDbfVir ) }
         :nWidth                 := 100
         :nDataStrAlign          := AL_RIGHT
         :nHeadStrAlign          := AL_RIGHT
      end with

      REDEFINE GET ::oGetTot VAR ::nGetTot;
         ID       300 ;
         WHEN     ( .f. );
         COLOR    CLR_GET ;
         PICTURE  ::cPorDiv ;
			OF 		oDlg

      REDEFINE GET ::oGetHor VAR ::nGetHor;
         ID       310 ;
         WHEN     ( .f. );
         COLOR    CLR_GET ;
         PICTURE  ::cPorDiv ;
			OF 		oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( if( ::lPreSave( oGet, nMode ), oDlg:end( IDOK ), ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
			ACTION 	( oDlg:end() )

      REDEFINE BUTTON ;
         ID       559 ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( MsgInfo( "Ayuda no definida" ) )

      if nMode != ZOOM_MODE
         oDlg:AddFastKey( VK_F2, {|| ::oDetCostes:Append( oBrwCos ), ::lTotalVirtual() } )
         oDlg:AddFastKey( VK_F3, {|| ::oDetCostes:Edit( oBrwCos ), ::lTotalVirtual() } )
         oDlg:AddFastKey( VK_F4, {|| ::oDetCostes:Del( oBrwCos ), ::lTotalVirtual() } )
         oDlg:AddFastKey( VK_F5, {|| if( ::lPreSave( oGet, nMode ), oDlg:end( IDOK ), ) } )
      end if

      oDlg:bStart          := {|| oGet:SetFocus(), oGetSec:lValid(), ::lTotalVirtual() }

	ACTIVATE DIALOG oDlg	CENTER

   oBmpGeneral:End()

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

METHOD nTotalVirtual( oDbf )

   local nTotal   := 0

   DEFAULT oDbf   := ::oDetCostes:oDbfVir

   oDbf:GetStatus()

   oDbf:GoTop()
   while !oDbf:Eof()
      nTotal      += ::oDetCostes:nTotalLinea( oDbf )
      oDbf:Skip()
   end while

   oDbf:SetStatus()

RETURN ( nTotal )

//---------------------------------------------------------------------------//

METHOD cTotalVirtual( oDbf )

   DEFAULT oDbf   := ::oDetCostes:oDbfVir

RETURN ( Trans( ::nTotalVirtual( oDbf ), ::cPorDiv ) )

//---------------------------------------------------------------------------//

METHOD lTotalVirtual()

   local nTotal   := ::nTotalVirtual( ::oDetCostes:oDbfVir )

   ::oGetTot:cText( nTotal )
   ::oGetHor:cText( nTotal / ::oDbf:nHorDia )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD nTotalCosteDia( cCod, oDbf )

   local nTotal   := 0

   if Empty( ::oDetCostes )
      Return ( nTotal )
   end if

   DEFAULT cCod   := ::oDbf:cCodMaq
   DEFAULT oDbf   := ::oDetCostes:oDbf

   oDbf:GetStatus()

   if oDbf:Seek( cCod )
      while oDbf:cCodMaq == cCod .and. !oDbf:Eof()
         nTotal   += ::oDetCostes:nTotalLinea( oDbf )
         oDbf:Skip()
      end while
   end if

   oDbf:SetStatus()

RETURN ( nTotal )

//---------------------------------------------------------------------------//

METHOD cTotalCosteDia( cCod, cDiv, oDbf )

   local cPorDiv
   local nTotCos  := "0"

   if Empty( ::oDetCostes )
      Return ( nTotCos )
   end if

   DEFAULT cCod   := ::oDbf:cCodMaq
   DEFAULT cDiv   := ::oDbf:cCodDiv
   DEFAULT oDbf   := ::oDetCostes:oDbf

   nTotCos        := ::nTotalCosteDia( cCod, oDbf )

   cPorDiv        := cPorDiv( cDiv, ::oDbfDiv )

   if cDiv != ::oDbf:cCodDiv
      nTotCos     := nCnv2Div( nTotCos, ::oDbf:cCodDiv, cDiv, )
   end if

RETURN ( Trans( nTotCos, cPorDiv ) )

//---------------------------------------------------------------------------//

METHOD lTotalCosteDia( cCod, oDbf, oGet )

   DEFAULT cCod   := ::oDbf:cCodMaq
   DEFAULT oDbf   := ::oDetCostes:oDbf
   DEFAULT oGet   := ::oGetTot

RETURN ( oGet:SetText( ::nTotalCosteDia( cCod, oDbf ) ), .t. )

//---------------------------------------------------------------------------//

METHOD nTotalCosteHora( cCod, oDbf, oDbfCos )

   local nTotal   := 0

   DEFAULT cCod   := ::oDbf:cCodMaq
   DEFAULT oDbf   := ::oDbf
   DEFAULT oDbfCos:= ::oDetCostes:oDbf

   nTotal         := ::nTotalCosteDia( cCod, oDbfCos ) / oDbf:nHorDia

RETURN ( nTotal )

//---------------------------------------------------------------------------//

METHOD cTotalCosteHora( cCod, cDiv, oDbf, oDbfCos )

   local cPorDiv
   local nTotCos  := "0"

   if Empty( ::oDetCostes )
      Return ( nTotCos )
   end if

   DEFAULT cCod   := ::oDbf:cCodMaq
   DEFAULT cDiv   := ::oDbf:cCodDiv
   DEFAULT oDbf   := ::oDbf
   DEFAULT oDbfCos:= ::oDetCostes:oDbf

   nTotCos        := ::nTotalCosteHora( cCod, oDbf, oDbfCos )

   cPorDiv        := cPorDiv( cDiv, ::oDbfDiv )

   if cDiv != ::oDbf:cCodDiv
      nTotCos     := nCnv2Div( nTotCos, ::oDbf:cCodDiv, cDiv )
   end if

Return ( Trans( nTotCos, cPorDiv ) )

//---------------------------------------------------------------------------//

METHOD lTotalCosteHora( cCod, oDbf, oDbfCos, oGet )

   DEFAULT cCod   := ::oDbf:cCodMaq
   DEFAULT oDbf   := ::oDbf
   DEFAULT oDbfCos:= ::oDetCostes:oDbf
   DEFAULT oGet   := ::oGetTot

RETURN ( oGet:SetText( ::nTotalCosteHora( cCod, oDbf, oDbfCos ) ), .t. )

//---------------------------------------------------------------------------//

METHOD lPreSave( oGet, nMode )

   if nMode == APPD_MODE .or. nMode == DUPL_MODE

      if Empty( ::oDbf:cCodMaq )
         MsgStop( "Código de la máquina no puede estar vacío" )
         oGet:SetFocus()
         Return .f.
      end if

      if ::oDbf:SeekInOrd( ::oDbf:cCodMaq, "CCODMAQ" )
         msgStop( "Código existente" )
         oGet:SetFocus()
         return .f.
      end if

   end if

   if Empty( ::oDbf:cDesMaq )
      MsgStop( "La descripción de la máquina no puede estar vacía." )
      Return .f.
   end if

RETURN .t.

//---------------------------------------------------------------------------//