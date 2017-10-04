#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//--------------------------------------------------------------------------//

CLASS TDetActuacion FROM TDet

   METHOD DefineFiles()

   METHOD OpenFiles( lExclusive )

   METHOD CloseFiles()

   METHOD Resource( nMode, lLiteral )

   METHOD lPreSave()

   METHOD PreSaveDetails()

END CLASS

//--------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cVia, lUniqueName, cFileName )

   local oDbf

   DEFAULT cPath        := ::cPath
   DEFAULT lUniqueName  := .f.
   DEFAULT cFileName    := "ExpDet"
   DEFAULT cVia         := cDriver()

   if lUniqueName
      cFileName         := cGetNewFileName( cFileName, , , cPath )
   end if

   DEFINE TABLE oDbf FILE ( cFileName ) CLASS ( cFileName ) ALIAS ( cFileName ) PATH ( cPath ) VIA ( cVia ) COMMENT "personal"

      FIELD NAME "cSerExp" TYPE "C" LEN 01  DEC 0 COMMENT "Serie"                         OF oDbf
      FIELD NAME "nNumExp" TYPE "N" LEN 09  DEC 0 COMMENT "Número"                        OF oDbf
      FIELD NAME "cSufExp" TYPE "C" LEN 02  DEC 0 COMMENT "Sufijo"                        OF oDbf
      FIELD NAME "cCodTra" TYPE "C" LEN 05  DEC 0 COMMENT "Trabajador"                    OF oDbf
      FIELD NAME "cCodAct" TYPE "C" LEN 03  DEC 0 COMMENT "Actuación"                     OF oDbf
      FIELD NAME "dFecIni" TYPE "D" LEN 08  DEC 0 COMMENT "Fecha inicio"                  OF oDbf
      FIELD NAME "cHorIni" TYPE "C" LEN 05  DEC 0 COMMENT "Hora inicio"                   OF oDbf
      FIELD NAME "dFecFin" TYPE "D" LEN 08  DEC 0 COMMENT "Fecha fin"                     OF oDbf
      FIELD NAME "cHorFin" TYPE "C" LEN 05  DEC 0 COMMENT "Hora fin"                      OF oDbf
      FIELD NAME "mMemAct" TYPE "M" LEN 10  DEC 0 COMMENT "Descripción de la actuación"   OF oDbf
      FIELD NAME "lActEnd" TYPE "L" LEN 01  DEC 0 COMMENT "Tarea finalizada"              OF oDbf

      INDEX TO ( cFileName ) TAG "cNumExp" ON "cSerExp + Str( nNumExp, 9 ) + cSufExp"   NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "cCodTra" ON "cCodTra"                                 NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "cCodAct" ON "cCodAct"                                 NODELETED OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//--------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive )

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT  lExclusive  := .f.

   BEGIN SEQUENCE

   if Empty( ::oDbf )
      ::oDbf            := ::DefineFiles()
   end if

   ::oDbf:Activate( .f., !lExclusive )

   ::bOnPreSaveDetail   := {|| ::PreSaveDetails() }

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos" )

      ::CloseFiles()

      lOpen             := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//--------------------------------------------------------------------------//

METHOD CloseFiles()

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:End()
      ::oDbf            := nil
   end if

RETURN .t.

//--------------------------------------------------------------------------//

METHOD Resource( nMode )

   local oDlg
   local oGetTra
   local oSayTra
   local cSayTra
   local oGetAct
   local oSayAct
   local cSayAct
   local oFecIni
   local oFecFin
   local oHorIni
   local oHorFin

   if nMode == APPD_MODE

      ::oDbfVir:dFecIni := ::oParent:oDbf:dFecOrd
      ::oDbfVir:cHorIni := ::oParent:oDbf:cHorOrd
      ::oDbfVir:cCodTra := ::oParent:oDbf:cCodTra

   end if

   /*
   Etiquetas-------------------------------------------------------------------
   */

   cSayAct              := oRetFld( ::oDbfVir:cCodAct, ::oParent:oActuaciones:oDbf, "cDesAct" )
   cSayTra              := oRetFld( ::oDbfVir:cCodTra, ::oParent:oOperario:oDbf, "cNomTra" )

   /*
   Caja de dialogo-------------------------------------------------------------
   */

   DEFINE DIALOG oDlg RESOURCE "lExpediente" TITLE LblTitle( nMode ) + "actuaciones"

      /*
      Código de personal-------------------------------------------------------
      */

      REDEFINE GET oGetAct VAR ::oDbfVir:cCodAct;
         ID       110 ;
         WHEN     ( nMode != ZOOM_MODE );
         BITMAP   "LUPA" ;
         OF       oDlg
      oGetAct:bHelp  := {|| ::oParent:oActuaciones:Buscar( oGetAct ) }
      oGetAct:bValid := {|| ::oParent:oActuaciones:Existe( oGetAct, oSayAct, "cDesAct", .t., .t., "0" ) }

      REDEFINE GET oSayAct VAR cSayAct ;
         ID       111 ;
         WHEN     ( .f. ) ;
			OF 		oDlg

      /*
      Código de personal-------------------------------------------------------
      */

      REDEFINE GET oGetTra VAR ::oDbfVir:cCodTra;
         ID       120 ;
         WHEN     ( nMode != ZOOM_MODE );
         BITMAP   "LUPA" ;
         OF       oDlg
      oGetTra:bHelp  := {|| ::oParent:oOperario:Buscar( oGetTra ) }
      oGetTra:bValid := {|| ::oParent:oOperario:Existe( oGetTra, oSayTra, "cNomTra", .t., .t., "0" ) }

      REDEFINE GET oSayTra VAR cSayTra ;
         ID       121 ;
         WHEN     ( .f. ) ;
			OF 		oDlg

      /*
      Fechas y Horas-----------------------------------------------------------
      */

      REDEFINE GET oFecIni VAR ::oDbfVir:dFecIni ;
         ID       140 ;
			SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET oHorIni ;
         VAR      ::oDbfVir:cHorIni ;
         PICTURE  "@R 99:99" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         SPINNER ;
         ON UP    ( UpTime( oHorIni ) );
         ON DOWN  ( DwTime( oHorIni ) );
         ID       141 ;
         OF       oDlg

      REDEFINE GET oFecFin VAR ::oDbfVir:dFecFin ;
         ID       150 ;
			SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( Empty( ::oDbfVir:dFecIni ) .or. ( ::oDbfVir:dFecIni >= ::oDbfVir:dFecIni ) ) ;
         OF       oDlg

      REDEFINE GET oHorFin ;
         VAR      ::oDbfVir:cHorFin ;
         PICTURE  "@R 99:99" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         SPINNER ;
         ON UP    ( UpTime( oHorFin ) );
         ON DOWN  ( DwTime( oHorFin ) );
         ID       151 ;
         OF       oDlg

      /*
      Comentarios--------------------------------------------------------------
      */

      REDEFINE GET ::oDbfVir:mMemAct ;
         MEMO ;
         ID       130;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      /*
      Finalizado---------------------------------------------------------------
      */

      REDEFINE CHECKBOX ::oDbfVir:lActEnd ;
         ID       160 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      /*
      Botones------------------------------------------------------------------
      */

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::lPreSave( oDlg ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

      if nMode != ZOOM_MODE
         oDlg:AddFastKey( VK_F5, {|| ::lPreSave( oDlg ) } )
      end if

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//

METHOD lPreSave( oDlg )

   if Empty( ::oDbfVir:cCodAct )
      MsgStop( "Código de la actuación no puede estar vacio" )
      Return ( .f. )
   end if

   if Empty( ::oDbfVir:cCodTra )
      MsgStop( "Código del operario no puede estar vacio" )
      Return ( .f. )
   end if

RETURN ( oDlg:end( IDOK ) )

//----------------------------------------------------------------------------//

METHOD PreSaveDetails()

   ::oDbfVir:cSerExp  := ::oParent:oDbf:cSerExp
   ::oDbfVir:nNumExp  := ::oParent:oDbf:nNumExp
   ::oDbfVir:cSufExp  := ::oParent:oDbf:cSufExp

RETURN ( Self )

//--------------------------------------------------------------------------//

function aItmActua()

   local aBasActua  := {}

   aAdd( aBasActua, { "cSerExp", "C",  1, 0, "Serie",                        "", "", "" } )
   aAdd( aBasActua, { "nNumExp", "N",  9, 0, "Número",                       "", "", "" } )
   aAdd( aBasActua, { "cSufExp", "C",  2, 0, "Sufijo",                       "", "", "" } )
   aAdd( aBasActua, { "cCodTra", "C",  5, 0, "Trabajador",                   "", "", "" } )
   aAdd( aBasActua, { "cCodAct", "C",  3, 0, "Actuación",                    "", "", "" } )
   aAdd( aBasActua, { "dFecIni", "D",  8, 0, "Fecha inicio",                 "", "", "" } )
   aAdd( aBasActua, { "cHorIni", "C",  5, 0, "Hora inicio",                  "", "", "" } )
   aAdd( aBasActua, { "dFecFin", "D",  8, 0, "Fecha fin",                    "", "", "" } )
   aAdd( aBasActua, { "cHorFin", "C",  5, 0, "Hora fin",                     "", "", "" } )
   aAdd( aBasActua, { "mMemAct", "M", 10, 0, "Descripción de la actuación",  "", "", "" } )
   aAdd( aBasActua, { "lActEnd", "L",  1, 0, "Lógico finalizado",            "", "", "" } )

return ( aBasActua )

//---------------------------------------------------------------------------//


