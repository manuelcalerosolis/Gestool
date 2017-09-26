#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Menu.ch"
#include "Report.ch"
#include "MesDbf.ch"

//--------------------------------------------------------------------------//

CLASS TDetHorasPersonal FROM TDet

   DATA  oGetTotalCosto
   DATA  nGetTotalCosto    INIT  0

   METHOD DefineFiles()

   METHOD OpenFiles( lExclusive )

   METHOD Resource( nMode, lLiteral )

   METHOD SaveDetails()

   METHOD lValidTipoHora( oGetTra, oGetTipoHora, oGetCos, oSayTipoHora )

   METHOD nCosteHora( cCodTra, cTipHor )

   METHOD nTotCosto( oDbf )
   METHOD lTotCosto( oDbf )

   METHOD lPreSave( oGetTipoHora, oDlg )

END CLASS

//--------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cVia, lUniqueName, cFileName )

   local oDbf

   DEFAULT cPath        := ::cPath
   DEFAULT lUniqueName  := .f.
   DEFAULT cFileName    := "ProHPer"
   DEFAULT cVia         := cDriver()

   if lUniqueName
      cFileName         := cGetNewFileName( cFileName, , , cPath )
   end if

   DEFINE TABLE oDbf FILE ( cFileName ) CLASS ( cFileName ) ALIAS ( cFileName ) PATH ( cPath ) VIA ( cVia ) COMMENT "Operarios y horas"

      FIELD NAME "cSerOrd"    TYPE "C" LEN 01  DEC 0 COMMENT "Serie"                OF oDbf
      FIELD NAME "nNumOrd"    TYPE "N" LEN 09  DEC 0 COMMENT "Número"               OF oDbf
      FIELD NAME "cSufOrd"    TYPE "C" LEN 02  DEC 0 COMMENT "Sufijo"               OF oDbf
      FIELD NAME "cCodTra"    TYPE "C" LEN 05  DEC 0 COMMENT "Código trabajador"    OF oDbf
      FIELD NAME "cCodHra"    TYPE "C" LEN 03  DEC 0 COMMENT "Tipo de hora"         OF oDbf
      FIELD NAME "nNumHra"    TYPE "N" LEN 16  DEC 6 COMMENT "Número de horas"      OF oDbf
      FIELD NAME "nCosHra"    TYPE "N" LEN 16  DEC 6 COMMENT "Coste"                OF oDbf

      INDEX TO ( cFileName )  TAG "cNumOrd" ON "cSerOrd + Str( nNumOrd, 9 ) + cSufOrd"             NODELETED OF oDbf
      INDEX TO ( cFileName )  TAG "cCodTra" ON "cCodTra"                                           NODELETED OF oDbf
      INDEX TO ( cFileName )  TAG "cNumTra" ON "cSerOrd + Str( nNumOrd, 9 ) + cSufOrd + cCodTra"   NODELETED OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//--------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive, cDriver )

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT cDriver      := cDriver

   DEFAULT lExclusive   := .f.

   ::cDriver            := cDriver

   BEGIN SEQUENCE

   if Empty( ::oDbf )
      ::oDbf            := ::DefineFiles()
   end if

   ::oDbf:Activate( .f., !lExclusive )

   ::bOnPreSaveDetail   := {|| ::SaveDetails() }

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos" )

      ::CloseFiles()

      lOpen             := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//--------------------------------------------------------------------------//

METHOD Resource( nMode )

   local oDlg
   local oGetCos
   local oIniOpe
   local oGetTipoHora
   local oSayTipoHora
   local cSayTipoHora

   /*
   Etiquetas-------------------------------------------------------------------
   */

   if Empty( ::oParent:oDetPersonal:oDbfVir:cCodTra )
      msgStop( "Es necesario codificar un trabajador" )
      Return .f.
   end if

   if nMode == APPD_MODE
      ::oDbfVir:nNumHra    := ::oParent:oDetPersonal:cTiempoEmpleado
   end if

   cSayTipoHora            := oRetFld( ::oDbfVir:cCodHra, ::oParent:oHoras:oDbf )

   /*
   Etiquetas-------------------------------------------------------------------
   */

   ::nGetTotalCosto        := ::nTotCosto( ::oDbfVir )

   /*
   Caja de dialogo-------------------------------------------------------------
   */

   DEFINE DIALOG oDlg RESOURCE "LHorasPersonal" TITLE LblTitle( nMode ) + "horas de operarios"

      /*
      Código de la operacion a la q pertenece----------------------------------
      */

      REDEFINE GET oGetTipoHora VAR ::oDbfVir:cCodHra;
         ID       100 ;
         WHEN     ( nMode != ZOOM_MODE );
         BITMAP   "LUPA" ;
         OF       oDlg
      oGetTipoHora:bHelp   := {|| ::oParent:oHoras:Buscar( oGetTipoHora ) }
      oGetTipoHora:bValid  := {|| ::oParent:oHoras:Existe( oGetTipoHora, oSayTipoHora, "cDesHra", .t., .t., "0" ), ::lValidTipoHora( oGetTipoHora, oGetCos, oSayTipoHora ) }

      REDEFINE GET oSayTipoHora VAR cSayTipoHora ;
         ID       101 ;
         WHEN     ( .f. ) ;
			OF 		oDlg

      /*
      Numero de horas-----------------------------------------------------------
      */

      REDEFINE GET oIniOpe VAR ::oDbfVir:nNumHra;
         ID       110 ;
         PICTURE  "99.99";
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE );
         OF       oDlg
      oIniOpe:bChange      := {|| ::lTotCosto( ::oDbfVir ) }
      oIniOpe:bValid       := {|| ::lTotCosto( ::oDbfVir ) }

      REDEFINE GET oGetCos VAR ::oDbfVir:nCosHra;
         ID       120 ;
         PICTURE  ::oParent:cPouDiv ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE );
         OF       oDlg
      oGetCos:bChange      := {|| ::lTotCosto( ::oDbfVir ) }
      oGetCos:bValid       := {|| ::lTotCosto( ::oDbfVir ) }

      REDEFINE GET ::oGetTotalCosto VAR ::nGetTotalCosto;
         ID       130 ;
         PICTURE  ::oParent:cPorDiv;
         WHEN     ( .f. );
         OF       oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::lPreSave( oGetTipoHora, oDlg ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| ::lPreSave( oGetTipoHora, oDlg ) } )
   end if

   oDlg:bStart := { || oGetTipoHora:SetFocus() }

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//

METHOD SaveDetails()

   ::oDbfVir:cSerOrd    := ::oParent:oDbf:cSerOrd
   ::oDbfVir:nNumOrd    := ::oParent:oDbf:nNumOrd
   ::oDbfVir:cSufOrd    := ::oParent:oDbf:cSufOrd

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD nCosteHora( cCodTra, cTipHor )

   local nCosteHora     := 0
   local nOrdenAnterior := ::oDbf:OrdSetFocus( "cCodHra" )

   if ::oDbf:Seek( cCodTra + cTipHor )
      nCosteHora        := ::oDbf:nCosHra
   end if

   ::oDbf:OrdSetFocus( nOrdenAnterior )

RETURN ( nCosteHora )

//---------------------------------------------------------------------------//

METHOD lValidTipoHora( oGetTipoHora, oGetCos, oSayTipoHora )

   local nCosteHora  := 0
   local cTipoHora   := oGetTipoHora:VarGet()
   local cTrabajador := ::oParent:oDetPersonal:oDbfVir:cCodTra

   if Empty( cTipoHora )

      Return .t.
   end if

   if ::oParent:oHoras:lValid( oGetTipoHora, oSayTipoHora )

      if !Empty( cTrabajador )

         nCosteHora  := ::oParent:oDetHoras:nCosteHora( cTrabajador, cTipoHora )

         if nCosteHora != 0
            oGetCos:cText( nCosteHora )
         end if

      end if

   else

      MsgStop( "Código no encontrado" )
      Return .f.

   end if

   ::lTotCosto( ::oDbfVir )

RETURN ( .t. )

//----------------------------------------------------------------------------//

METHOD nTotCosto( oDbf )

   local nTotalImporte

   DEFAULT oDbf   := ::oDbf

   nTotalImporte  := oDbf:nNumHra * oDbf:nCosHra

RETURN ( nTotalImporte )

//---------------------------------------------------------------------------//

METHOD lTotCosto( oDbf )

   DEFAULT oDbf   := ::oDbf

RETURN ( ::oGetTotalCosto:cText( ::nTotCosto( oDbf ) ), .t. )

//---------------------------------------------------------------------------//

METHOD lPreSave( oGetTipoHora, oDlg )

   if Empty( ::oDbfVir:cCodHra )
      MsgStop( "Tiene que seleccionar un tipo de hora." )
      oGetTipoHora:SetFocus()
      Return .f.
   end if

   ::oDbfVir:cCodTra := ::oParent:oDetPersonal:oDbfVir:cCodTra

RETURN ( oDlg:end( IDOK ) )

//---------------------------------------------------------------------------//