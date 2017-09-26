#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Menu.ch"
#include "Report.ch"
#include "MesDbf.ch"

//--------------------------------------------------------------------------//

CLASS TDetHoras FROM TDet

   METHOD New( cPath, cDriver, oParent )

   METHOD DefineFiles()

   METHOD OpenFiles( lExclusive )

   METHOD Resource( nMode, lLiteral )

   METHOD SaveDetails()

   METHOD nCosteHora( cCodTra, cTipHor )

   METHOD lPresave( oGetCod, nMode )

END CLASS

//--------------------------------------------------------------------------//

METHOD New( cPath, cDriver, oParent ) 

   DEFAULT cPath        := cPatEmp()
   DEFAULT cDriver      := cDriver()

   ::cPath              := cPath
   ::cDriver            := cDriver
   ::oParent            := oParent

   ::bOnPreSaveDetail   := {|| ::SaveDetails() }

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver, lUniqueName, cFileName )

   local oDbf

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := ::cDriver
   DEFAULT lUniqueName  := .f.
   DEFAULT cFileName    := "OpeL"

   if lUniqueName
      cFileName         := cGetNewFileName( cFileName, , , cPath )
   end if

   DEFINE TABLE oDbf FILE ( cFileName ) CLASS ( cFileName ) ALIAS ( cFileName ) PATH ( cPath ) VIA ( cDriver ) COMMENT "Operarios y horas"

      FIELD NAME "cCodTra"    TYPE "C" LEN  5  DEC 0 COMMENT "Cód. Trabajador"   COLSIZE 60                                   OF oDbf
      FIELD NAME "cCodHra"    TYPE "C" LEN  3  DEC 0 COMMENT "Cód. Hora"         COLSIZE 100                                  OF oDbf
      FIELD NAME "nCosHra"    TYPE "N" LEN 16  DEC 6 COMMENT "Importe"           COLSIZE 140 ALIGN RIGHT PICTURE cPouDiv()    OF oDbf
      FIELD NAME "lDefHor"    TYPE "L" LEN  1  DEC 0 COMMENT ""                  HIDE                                         OF oDbf

      INDEX TO ( cFileName ) TAG "cCodTra" ON "cCodTra"                          NODELETED                                    OF oDbf
      INDEX TO ( cFileName ) TAG "cCodHra" ON "cCodHra"                          NODELETED                                    OF oDbf
      INDEX TO ( cFileName ) TAG "cTraHra" ON "cCodTra + cCodHra"                NODELETED                                    OF oDbf

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

METHOD Resource( nMode )

   local oDlg
   local oGetCod
   local oGetCos
   local oSayCos
   local cSayCos
   local lDis              := .f.

   if nMode == APPD_MODE

      ::oDbfVir:GoTop()

      if ::oDbfVir:OrdKeyCount() == 0
         ::oDbfVir:lDefHor := .t.
         lDis              := .t.
      end if

      ::oDbfVir:nCosHra   := ::oParent:nCosteOperario()

   end if

   /*
   Etiquetas-------------------------------------------------------------------
   */

   cSayCos                 := oRetFld( ::oDbfVir:cCodHra, ::oParent:oHoras:oDbf, "cDesHra" )

   /*
   Caja de dialogo-------------------------------------------------------------
   */

   DEFINE DIALOG oDlg RESOURCE "LOperariosHoras" TITLE LblTitle( nMode ) + "tipos de horas"

      /*
      Código de maquinaria-------------------------------------------------------
      */

      REDEFINE GET oGetCod VAR ::oDbfVir:cCodHra ;
         ID       100 ;
         WHEN     ( nMode == APPD_MODE ) ;
         BITMAP   "LUPA" ;
         OF       oDlg

      oGetCod:bHelp     := {|| ::oParent:oHoras:Buscar( oGetCod ) }
      oGetCod:bValid    := {|| ::oParent:oHoras:Existe( oGetCod, oSayCos, "cDesHra", .t., .t., "0" ) }

      REDEFINE GET oSayCos VAR cSayCos ;
         ID       101 ;
         WHEN     .f. ;
			OF 		oDlg

      /*
      Hora de inicio-----------------------------------------------------------
      */

      REDEFINE GET oGetCos VAR ::oDbfVir:nCosHra ;
         ID       110 ;
         PICTURE  ::oParent:cPouDiv ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE );
         OF       oDlg

      REDEFINE CHECKBOX ::oDbfVir:lDefHor ;
         ID       290 ;
         WHEN     ( nMode != ZOOM_MODE .and. !lDis );
         OF       oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         WHEN     ( nMode != ZOOM_MODE );
         ACTION   ( if( ::lPresave( oGetCod, nMode ), oDlg:end( IDOK ), ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      REDEFINE BUTTON ;
         ID       998 ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( MsgInfo( "Ayuda no definida" ) )

      oDlg:bStart    := {|| oGetCod:lValid() }

      if nMode != ZOOM_MODE
         oDlg:AddFastKey( VK_F5, {|| if( ::lPresave( oGetCod, nMode ), oDlg:end( IDOK ), ) } )
      end if

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//

METHOD SaveDetails()

   ::oDbfVir:cCodTra    := ::oParent:oDbf:cCodTra

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD nCosteHora( cCodTra, cTipHor )

   local nCosteHora     := 0

   if ::oDbf:SeekInOrd( cCodTra + cTipHor, "cTraHra" )
      nCosteHora        := ::oDbf:nCosHra
   end if

RETURN ( nCosteHora )

//---------------------------------------------------------------------------//

METHOD lPreSave( oGetCod, nMode )

   if nMode == APPD_MODE

      if ::oDbfVir:SeekInOrd( ::oDbfVir:cCodHra, "cCodHra" )
         msgStop( "Código existente" )
         oGetCod:SetFocus()
         Return ( .f. )
      end if

      if Empty( ::oDbfVir:cCodHra )
         msgStop( "Código de hora vacío" )
         oGetCod:SetFocus()
         Return ( .f. )
      end if

   end if

   ::oParent:cUltHora   := ::oDbfVir:cCodHra
   ::oParent:lUltDef    := ::oDbfVir:lDefHor

return ( .t. )

//---------------------------------------------------------------------------//