#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Menu.ch"
#include "Report.ch"
#include "MesDbf.ch"

//--------------------------------------------------------------------------//

CLASS TDetCostes FROM TDet

   DATA  oGetTotalCosto
   DATA  nGetTotalCosto    INIT  0

   DATA  oCostesMaquina

   METHOD New( cPath, oParent ) 

   METHOD DefineFiles()

   METHOD OpenFiles( lExclusive )

   METHOD Resource( nMode, lLiteral )

   METHOD SaveLines()

   METHOD LoadCostes( oGetCos, oSayCos, oSayImp )

   METHOD nTotalLinea( oDbf )
   METHOD cTotalLinea( oDbf )
   METHOD lTotalLinea( oDbf )

   METHOD lPreSave()

END CLASS

//--------------------------------------------------------------------------//

METHOD New( cPath, oParent ) 

   DEFAULT cPath        := cPatEmp()

   ::cPath              := cPath
   ::oParent            := oParent

   ::bOnPreSaveDetail   := {|| ::SaveLines() }

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver, lUniqueName, cFileName )

   local oDbf

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()
   DEFAULT lUniqueName  := .f.
   DEFAULT cFileName    := "MaqCosL"

   if lUniqueName
      cFileName         := cGetNewFileName( cFileName, , , cPatTmp() )
   end if

   DEFINE TABLE oDbf FILE ( cFileName ) CLASS ( cFileName ) ALIAS ( cFileName ) PATH ( cPath ) VIA ( cDriver ) COMMENT "Lineas de coste de maquinaria"

      FIELD NAME "cCodMaq" TYPE "C" LEN  3  DEC 0 COMMENT "Máquina"     OF oDbf
      FIELD NAME "cCodCos" TYPE "C" LEN 12  DEC 0 COMMENT "Cód. cos."   OF oDbf
      FIELD NAME "nPctCos" TYPE "N" LEN  3  DEC 0 COMMENT "%Aplicación" OF oDbf

      INDEX TO ( cFileName ) TAG "cCosMaq" ON "cCodMaq" NODELETED       OF oDbf
      INDEX TO ( cFileName ) TAG "cCodCos" ON "cCodCos" NODELETED       OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//--------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive, cPath )

   local lOpen             := .t.
   local oError
   local oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lExclusive      := .f.

   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf            := ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !lExclusive )


   RECOVER USING oError

      lOpen                := .f.
      
      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos" )

      ::CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//--------------------------------------------------------------------------//

METHOD Resource( nMode )

   local oDlg
   local oGetCos
   local oGetPct
   local oSayCos
   local cSayCos
   local oSayImp
   local nSayImp  := 0
   local oSayApl
   local nSayApl  := 0

   /*
   Etiquetas-------------------------------------------------------------------
   */

   DEFINE DIALOG oDlg RESOURCE "LCosteMaquina" TITLE LblTitle( nMode ) + "coste de maquinaria"

      /*
      Código de maquinaria-------------------------------------------------------
      */

      REDEFINE GET oGetCos VAR ::oDbfVir:cCodCos;
         ID       110 ;
         WHEN     ( nMode == APPD_MODE ) ;
         BITMAP   "LUPA" ;
         OF       oDlg

      oGetCos:bHelp     := {|| ::oParent:oCostes:Buscar( oGetCos ) }
      oGetCos:bValid    := {|| ::loadCostes( oGetCos, oSayCos, oSayImp ) }

      REDEFINE GET oSayCos VAR cSayCos ;
         ID       111 ;
         WHEN     .f. ;
			OF 		oDlg

      /*
      Importe de coste---------------------------------------------------------
      */

      REDEFINE GET oSayImp VAR nSayImp ;
         ID       120 ;
         WHEN     .f. ;
         PICTURE  ::oParent:cPouDiv ;
         OF       oDlg

      /*
      Hora de inicio-----------------------------------------------------------
      */

      REDEFINE GET oGetPct VAR ::oDbfVir:nPctCos ;
         ID       130 ;
         PICTURE  "@E 999.99";
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE );
         OF       oDlg

      oGetPct:bChange   := {|| ::lTotalLinea( ::oDbfVir, oSayApl ) }

      /*
      Importe de coste---------------------------------------------------------
      */

      REDEFINE GET oSayApl VAR nSayApl ;
         ID       140 ;
         WHEN     .f. ;
         PICTURE  ::oParent:cPouDiv ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( if( ::lPresave( oGetCos, nMode ), oDlg:end( IDOK ), ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

      REDEFINE BUTTON ;
         ID       9 ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( MsgInfo( "Ayuda no definida" ) )

      if nMode != ZOOM_MODE
         oDlg:AddFastKey( VK_F5, {|| if( ::lPresave( oGetCos, nMode ), oDlg:end( IDOK ), ) } )
      end if

      oDlg:bStart := {||   ::loadCostes( oGetCos, oSayCos, oSayImp ),;
                           ::lTotalLinea( ::oDbfVir, oSayApl ) }

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//

METHOD SaveLines()

   ::oDbfVir:cCodMaq  := ::oParent:oDbf:cCodMaq

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD nTotalLinea( oDbf )

   local nTotal   := 0

   DEFAULT oDbf   := ::oDbf

   if ::oParent:oCostes:oDbf:SeekInOrd( oDbf:cCodCos, "cCodCos" )
      nTotal      := ::oParent:oCostes:oDbf:nImpCos * oDbf:nPctCos / 100
   end if

RETURN ( nTotal )

//---------------------------------------------------------------------------//

METHOD cTotalLinea( oDbf )

   DEFAULT oDbf   := ::oDbf

RETURN ( Trans( ::nTotalLinea( oDbf ), ::oParent:cPorDiv ) )

//--------------------------------------------------------------------------//

METHOD lTotalLinea( oDbf, oGet )

   DEFAULT oDbf   := ::oDbf

RETURN ( oGet:cText( ::nTotalLinea( oDbf ) ), .t. )

//---------------------------------------------------------------------------//

METHOD LoadCostes( oGetCos, oSayCos, oSayImp )

   local cCodCos  := oGetCos:VarGet()

   if !Empty( cCodCos )

      if ::oParent:oCostes:oDbf:SeekInOrd( cCodCos, "cCodCos" )

         oSayCos:cText( ::oParent:oCostes:oDbf:cDesCos )

         oSayImp:cText( ::oParent:oCostes:oDbf:nImpCos )

         return .t.

      else

         MsgStop( "Costes no encontrado" )

         return .f.

      end if

   end if

Return .t.

//---------------------------------------------------------------------------//

METHOD lPresave( oGetCod, nMode )

   local nOrdAnt  := ::oDbfVir:OrdSetFocus( "CCODCOS" )

   if nMode == APPD_MODE

      if Empty( ::oDbfVir:cCodCos )
         msgStop( "Código no puede estar vacio" )
         oGetCod:SetFocus()
         return .f.
      end if

      if ::oDbfVir:Seek( ::oDbfVir:cCodCos )
         msgStop( "Código existente" )
         oGetCod:SetFocus()
         return .f.
      end if

   end if

   ::oDbfVir:OrdSetFocus( nOrdAnt )

RETURN ( .t. )

//---------------------------------------------------------------------------//