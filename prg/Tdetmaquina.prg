#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//--------------------------------------------------------------------------//

CLASS TDetMaquina FROM TDet

   DATA  oGetTotalCosto
   DATA  cTmpEmp
   DATA  oTmpEmp
   DATA  oTotHoras
   DATA  nTotHoras      INIT 0

   METHOD New( cPath, oParent ) 

   METHOD DefineFiles()

   METHOD OpenFiles( lExclusive )
   MESSAGE OpenService( lExclusive )   METHOD OpenFiles( lExclusive )

   METHOD CloseFiles()

   METHOD Resource( nMode, lLiteral )

   METHOD lValidMaquina( oGetMaq, oGetSec, oGetCostoHora )

   METHOD SaveDetails()

   METHOD nTotCosto( oDbf )

   METHOD nTotal( oDbf )
   METHOD cTotal( oDbf )               INLINE ( Trans( ::nTotal( oDbf ), ::oParent:cPorDiv ) )

   METHOD lTiempoEmpleado()

   METHOD lPreSave( oGet, oDlg )

END CLASS

//--------------------------------------------------------------------------//

METHOD New( cPath, oParent ) 

   DEFAULT cPath        := cPatEmp()

   ::cPath              := cPath
   ::oParent            := oParent

   ::bOnPreSaveDetail   := {|| ::SaveDetails() }

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cVia, lUniqueName, cFileName )

   local oDbf

   DEFAULT cPath        := ::cPath
   DEFAULT lUniqueName  := .f.
   DEFAULT cFileName    := "ProMaq"
   DEFAULT cVia         := cDriver()

   if lUniqueName
      cFileName         := cGetNewFileName( cFileName, , , cPath )
   end if

   DEFINE TABLE oDbf FILE ( cFileName ) CLASS ( cFileName ) ALIAS ( cFileName ) PATH ( cPath ) VIA ( cVia )COMMENT "lineas de maquinaria"

      FIELD NAME "cSerOrd" TYPE "C" LEN 01  DEC 0 COMMENT "Código"      HIDE        OF oDbf
      FIELD NAME "nNumOrd" TYPE "N" LEN 09  DEC 0 COMMENT "Número"      HIDE        OF oDbf
      FIELD NAME "cSufOrd" TYPE "C" LEN 02  DEC 0 COMMENT "Sufijo"      HIDE        OF oDbf
      FIELD NAME "cCodSec" TYPE "C" LEN 03  DEC 0 COMMENT "Sección"                 OF oDbf
      FIELD NAME "cCodMaq" TYPE "C" LEN 03  DEC 0 COMMENT "Maquina"                 OF oDbf
      FIELD NAME "dFecIni" TYPE "D" LEN 08  DEC 0 COMMENT "Fecha inicio"            OF oDbf
      FIELD NAME "dFecFin" TYPE "D" LEN 08  DEC 0 COMMENT "Fecha fin"               OF oDbf
      FIELD NAME "cIniMaq" TYPE "C" LEN 05  DEC 0 COMMENT "Hora de inicio"          OF oDbf
      FIELD NAME "cFinMaq" TYPE "C" LEN 05  DEC 0 COMMENT "Hora de fin"             OF oDbf
      FIELD NAME "nCosHra" TYPE "N" LEN 16  DEC 6 COMMENT "Coste por horas"         OF oDbf
      FIELD NAME "nTotHra" TYPE "N" LEN 16  DEC 6 COMMENT "Total horas" HIDE        OF oDbf

      INDEX TO ( cFileName ) TAG "cNumOrd" ON "cSerOrd + Str( nNumOrd, 9 ) + cSufOrd"   NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "cCodSec" ON "cCodSec"                                 NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "cCodMaq" ON "cCodMaq"                                 NODELETED OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//--------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive, cPath )

   local lOpen          := .t.
   local oBlock         

   DEFAULT lExclusive   := .f.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf         := ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !lExclusive )

   RECOVER

      lOpen             := .f.
      
      ::CloseFiles()
      
      msgStop( "Imposible abrir todas las bases de datos" )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//--------------------------------------------------------------------------//

METHOD CloseFiles()

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:End()
   end if

   ::oDbf               := nil

RETURN .t.

//--------------------------------------------------------------------------//

METHOD Resource( nMode )

   local oDlg
   local oGetMaq
   local oGetSec
   local oGetCostoHora
   local oSayMaq
   local cSayMaq
   local oSaySec
   local cSaySec
   local oFecIni
   local oFecFin
   local oHorIni
   local oHorFin

   if nMode == APPD_MODE
      ::oDbfVir:dFecIni := ::oParent:oDbf:dFecOrd
      ::oDbfVir:dFecFin := ::oParent:oDbf:dFecFin
      ::oDbfVir:cIniMaq := ::oParent:oDbf:cHorIni
      ::oDbfVir:cFinMaq := ::oParent:oDbf:cHorFin
   end if

   ::lTiempoEmpleado()

   cSayMaq              := oRetFld( ::oDbfVir:cCodMaq, ::oParent:oMaquina:oDbf )
   cSaySec              := oRetFld( ::oDbfVir:cCodSec, ::oParent:oSeccion:oDbf )

   /*
   Caja de dialogo-------------------------------------------------------------
   */

   DEFINE DIALOG oDlg RESOURCE "lMaquinaria" TITLE LblTitle( nMode ) + "maquinaria"

      REDEFINE GET oGetMaq VAR ::oDbfVir:cCodMaq;
         ID       110 ;
         WHEN     ( nMode != ZOOM_MODE );
         BITMAP   "LUPA" ;
         OF       oDlg
      oGetMaq:bHelp     := {|| ::oParent:oMaquina:Buscar( oGetMaq ) }
      oGetMaq:bValid    := {|| ::oParent:oMaquina:Existe( oGetMaq, oSayMaq, "cDesMaq", .t., .t., "0" ), ::lValidMaquina( oGetMaq, oGetSec, oGetCostoHora ) }

      REDEFINE GET oSayMaq VAR cSayMaq ;
         ID       111 ;
         WHEN     ( .f. ) ;
			OF 		oDlg

      REDEFINE GET oGetSec VAR ::oDbfVir:cCodSec;
         ID       120 ;
         WHEN     ( nMode != ZOOM_MODE );
         BITMAP   "LUPA" ;
         OF       oDlg
      oGetSec:bHelp  := {|| ::oParent:oSeccion:Buscar( oGetSec ) }
      oGetSec:bValid := {|| ::oParent:oSeccion:Existe( oGetSec, oSaySec, "cDesSec", .t., .t., "0" ) }

      REDEFINE GET oSaySec VAR cSaySec ;
         ID       121 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      /*
      Fechas y Horas-----------------------------------------------------------
      */

      REDEFINE GET oFecIni VAR ::oDbfVir:dFecIni ;
         ID       130 ;
			SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

         oFecIni:bChange   := {|| ::lTiempoEmpleado(), ::oGetTotalCosto:Refresh() }
         oFecIni:bValid    := {|| ::lTiempoEmpleado(), ::oGetTotalCosto:Refresh(), .t. }

      REDEFINE GET oHorIni ;
         VAR      ::oDbfVir:cIniMaq ;
         PICTURE  "@R 99:99" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         SPINNER ;
         ON UP    ( UpTime( oHorIni ) );
         ON DOWN  ( DwTime( oHorIni ) );
         ID       140 ;
         OF       oDlg

         oHorIni:bValid    := {|| if( validHourMinutes( oHorIni ), ( ::lTiempoEmpleado(), ::oGetTotalCosto:Refresh(), .t. ), .f. ) }
         oHorIni:bChange   := {|| ::lTiempoEmpleado(), ::oGetTotalCosto:Refresh() }

      REDEFINE GET oFecFin VAR ::oDbfVir:dFecFin ;
         ID       150 ;
			SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

         oFecFin:bChange   := {|| ::lTiempoEmpleado(), ::oGetTotalCosto:Refresh() }
         oFecFin:bValid    := {|| ::lTiempoEmpleado(), ::oGetTotalCosto:Refresh(), .t. }

      REDEFINE GET oHorFin ;
         VAR      ::oDbfVir:cFinMaq ;
         PICTURE  "@R 99:99" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         SPINNER ;
         ON UP    ( UpTime( oHorFin ) );
         ON DOWN  ( DwTime( oHorFin ) );
         ID       160 ;
         OF       oDlg

         oHorFin:bValid    := {|| if( validHourMinutes( oHorFin ), ( ::lTiempoEmpleado(), ::oGetTotalCosto:Refresh(), .t. ), .f. ) }
         oHorFin:bChange   := {|| ::lTiempoEmpleado(), ::oGetTotalCosto:Refresh() }

      REDEFINE SAY ::oTmpEmp VAR ::cTmpEmp ;
         ID       170 ;
         COLOR    CLR_GET ;
         OF       oDlg

      REDEFINE SAY ::oTotHoras VAR ::oDbfVir:nTotHra ;
         ID       180 ;
         COLOR    CLR_GET ;
         PICTURE  "@E 9999.99";
         OF       oDlg

      REDEFINE GET oGetCostoHora VAR ::oDbfVir:nCosHra;
         ID       190 ;
         PICTURE  ::oParent:cPouDiv ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE );
         OF       oDlg

      oGetCostoHora:bChange   := {|| ::oGetTotalCosto:Refresh() }
      oGetCostoHora:bValid    := {|| ::oGetTotalCosto:Refresh(), .t. }

      REDEFINE SAY ::oGetTotalCosto PROMPT ::nTotCosto( ::oDbfVir );
         ID       200 ;
         COLOR    CLR_GET ;
         PICTURE  ::oParent:cPorDiv;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         WHEN     ( nMode != ZOOM_MODE );
         ACTION   ( ::lPreSave( oGetMaq, oDlg ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

      REDEFINE BUTTON ;
         ID       9 ;
			OF 		oDlg ;
         ACTION   ( MsgInfo( "Ayuda no definida", "Perdonen las molestias" ) )

      if nMode != ZOOM_MODE
         oDlg:AddFastKey( VK_F5, {|| ::lPreSave( oGetMaq, oDlg ) } )
      end if

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//

METHOD nTotCosto( oDbf )

   DEFAULT oDbf      := ::oDbf

RETURN ( ::oDbfVir:nTotHra * oDbf:nCosHra )

//---------------------------------------------------------------------------//

METHOD nTotal( oDbf )

   local nTotal   := 0

   DEFAULT oDbf   := ::oDbf

   oDbf:GetStatus()

   while !oDbf:Eof()
      nTotal      += ::nTotCosto( oDbf )
      oDbf:Skip()
   end while

   oDbf:SetStatus()

RETURN ( Round( nTotal, ::oParent:nDorDiv ) )

//---------------------------------------------------------------------------//

METHOD SaveDetails()

   ::oDbfVir:cSerOrd  := ::oParent:oDbf:cSerOrd
   ::oDbfVir:nNumOrd  := ::oParent:oDbf:nNumOrd
   ::oDbfVir:cSufOrd  := ::oParent:oDbf:cSufOrd

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD lValidMaquina( oGetMaq, oGetSec, oGetCostoHora )

   local cCodigoMaquina := oGetMaq:VarGet()

   ::oParent:oMaquina:oDbf:GetStatus()

   if ::oParent:oMaquina:oDbf:Seek( cCodigoMaquina )

      if !Empty( oGetSec )
         oGetSec:cText( ::oParent:oMaquina:oDbf:cCodSec )
         oGetSec:lValid()
      end if

      if !Empty( oGetCostoHora )
         oGetCostoHora:cText( ::oParent:oMaquina:nTotalCosteHora( cCodigoMaquina ) )
         oGetCostoHora:lValid()
      end if

   end if

   ::oParent:oMaquina:oDbf:SetStatus()

RETURN ( .t. )

//----------------------------------------------------------------------------//

METHOD lPreSave( oGet, oDlg )

   if Empty( ::oDbfVir:cCodMaq )
      MsgStop( "Código de la máquina no puede estar vacío." )
      oGet:SetFocus()
      Return .f.
   end if

RETURN oDlg:end( IDOK )

//---------------------------------------------------------------------------//

METHOD lTiempoEmpleado()

   ::oDbfVir:nTotHra    := nTiempoEntreFechas( ::oDbfVir:dFecIni, ::oDbfVir:dFecFin, ::oDbfVir:cIniMaq, ::oDbfVir:cFinMaq )
   ::cTmpEmp            := cFormatoDDHHMM( ::oDbfVir:nTotHra )

   if ::oTmpEmp != nil
      ::oTmpEmp:SetText( ::cTmpEmp )
      ::oTmpEmp:Refresh()
   end if

   if ::oTotHoras != nil
      ::oTotHoras:Refresh()
   end if

RETURN .t.

//---------------------------------------------------------------------------//