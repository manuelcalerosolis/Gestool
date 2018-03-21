#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//----------------------------------------------------------------------------//

CLASS TOperarios FROM TMasDet

   DATA  cMru        INIT "gc_worker2_16"
   DATA  cBitmap     INIT clrTopProduccion
   DATA  oSeccion
   DATA  oHoras
   DATA  oDetHoras
   DATA  oBmpSel
   DATA  cUltHora
   DATA  lUltDef     INIT .f.

   METHOD OpenFiles( lExclusive )
   METHOD CloseFiles()

   METHOD OpenService( lExclusive, cPath )
   METHOD CloseService()

   METHOD DefineFiles()

   METHOD Resource( nMode )

   METHOD lPreSave( oNom, oSec, nMode )

   METHOD nCosteOperario()

   METHOD lPostSave( oBrw )

   METHOD DelRecHora( oBrw )

END CLASS

//----------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive )

   local lOpen          := .t.
   local oBlock

   DEFAULT  lExclusive  := .f.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf         := ::DefineFiles()
      end if

      ::oDbf:Activate( .f., !lExclusive )

      ::oSeccion     := TSeccion():Create( ::cPath, ::cDriver )
      ::oSeccion:OpenFiles()

      ::oHoras       := THoras():Create( ::cPath, ::cDriver )
      ::oHoras:OpenFiles()

      ::oDetHoras    := TDetHoras():New( ::cPath, ::cDriver, Self )
      ::AddDetail( ::oDetHoras )

      ::OpenDetails()

      ::bFirstKey    := {|| ::oDbf:cCodTra }

   RECOVER

      lOpen          := .f.
      
      ::CloseFiles()
      
      msgStop( "Imposible abrir todas las bases de datos" )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD CloseFiles()

   ::CloseDetails()

   if ::oSeccion != nil
      ::oSeccion:End()
      ::oSeccion  := nil
   end if

   if ::oHoras != nil
      ::oHoras:End()
      ::oHoras    := nil
   end if

   if !Empty( ::oDbf )
      ::oDbf:end()
   end if

   ::oDbf         := nil

RETURN .t.

//----------------------------------------------------------------------------//

METHOD OpenService( lExclusive, cPath )

   local lOpen          := .t.
   local oBlock         

   DEFAULT lExclusive   := .f.
   DEFAULT cPath        := ::cPath

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf         := ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

   RECOVER

      lOpen             := .f.

      ::CloseService()

      msgStop( "Imposible abrir todas las bases de datos de detalle de operarios" )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseService()

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:End()
   end if

   ::oDbf               := nil

RETURN .t.

//--------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   local oDbf

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := ::cDriver

   DEFINE TABLE oDbf FILE "OpeT.Dbf" CLASS "Operario" ALIAS "Operario" PATH ( cPath ) VIA ( cDriver ) COMMENT "Operarios"

      FIELD NAME "cCodTra"    TYPE "C" LEN  5  DEC 0 COMMENT "Código"                  COLSIZE 60   OF oDbf
      FIELD NAME "cNomTra"    TYPE "C" LEN 35  DEC 0 COMMENT "Nombre"                  COLSIZE 300  OF oDbf
      FIELD NAME "cCodSec"    TYPE "C" LEN  3  DEC 0 COMMENT "Sección"                 COLSIZE 60   OF oDbf
      FIELD NAME "cDivTra"    TYPE "C" LEN  3  DEC 0 COMMENT "Divisa"                  HIDE         OF oDbf
      FIELD NAME "cDirTra"    TYPE "C" LEN 50  DEC 0 COMMENT "Domicilio"               HIDE         OF oDbf
      FIELD NAME "cCdpTra"    TYPE "C" LEN  7  DEC 0 COMMENT "Código postal"           HIDE         OF oDbf
      FIELD NAME "cPobTra"    TYPE "C" LEN 25  DEC 0 COMMENT "Población"               HIDE         OF oDbf
      FIELD NAME "cPrvTra"    TYPE "C" LEN 20  DEC 0 COMMENT "Provincia"               HIDE         OF oDbf
      FIELD NAME "cTlfTra"    TYPE "C" LEN 12  DEC 0 COMMENT "Teléfono"                HIDE         OF oDbf
      FIELD NAME "cMovTra"    TYPE "C" LEN 12  DEC 0 COMMENT "Móvil"                   HIDE         OF oDbf
      FIELD NAME "nCosNom"    TYPE "N" LEN 16  DEC 6 COMMENT "Nómina Mes"              HIDE         OF oDbf
      FIELD NAME "nCosSSSS"   TYPE "N" LEN 16  DEC 6 COMMENT "Seg. Social Mes"         HIDE         OF oDbf
      FIELD NAME "nPagas"     TYPE "N" LEN  3  DEC 0 COMMENT "Pagas Año"               HIDE         OF oDbf
      FIELD NAME "nDiaPro"    TYPE "N" LEN  5  DEC 0 COMMENT "Dias producctivos"       HIDE         OF oDbf
      FIELD NAME "nHorDia"    TYPE "N" LEN 16  DEC 6 COMMENT "Horas por día"           HIDE         OF oDbf
      FIELD NAME "cMeiTra"    TYPE "C" LEN 65  DEC 0 COMMENT "Email"                   HIDE         OF oDbf

      INDEX TO "OpeT.Cdx" TAG "cCodTra" ON "cCodTra" COMMENT "Código"   NODELETED OF oDbf
      INDEX TO "OpeT.Cdx" TAG "cNomTra" ON "cNomTra" COMMENT "Nombre"   NODELETED OF oDbf
      INDEX TO "OpeT.Cdx" TAG "cCodSec" ON "cCodSec" COMMENT "Sección"  NODELETED OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//----------------------------------------------------------------------------//

METHOD Resource( nMode )

	local oDlg
   local oGet
   local oSec
   local oSay
   local oNom
   local oBrwHor
   local cSay        := RetFld( ::oDbf:cCodSec, ::oSeccion:GetAlias() )
   local oTotCosOpe
   local oBmpGeneral

   if nMode == APPD_MODE .or. Empty( ::oDbf:cDivTra )
      ::oDbf:cDivTra := cDivEmp()
   end if

   ::lLoadDivisa( ::oDbf:cDivTra )

   DEFINE DIALOG oDlg RESOURCE "Trabajador" TITLE LblTitle( nMode ) + "operario"

      REDEFINE BITMAP oBmpGeneral ;
        ID       990 ;
        RESOURCE "gc_worker2_48" ;
        TRANSPARENT ;
        OF       oDlg

      REDEFINE GET oGet VAR ::oDbf:cCodTra;
         ID       100 ;
         WHEN     ( nMode == APPD_MODE ) ;
         VALID    ( RjustObj( oGet, "0" ), .t. ) ;
			PICTURE 	"@!" ;
			OF 		oDlg

      REDEFINE GET oNom VAR ::oDbf:cNomTra;
         ID       110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET oSec VAR ::oDbf:cCodSec;
         ID       120 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         OF       oDlg
      oSec:bValid := {|| ::oSeccion:Existe( oSec, oSay, "cDesSec", .t., .t., "0" ) }
      oSec:bHelp  := {|| ::oSeccion:Buscar( oSec ) }

      REDEFINE GET oSay VAR cSay;
         ID       121 ;
         WHEN     ( .f. ) ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cDirTra;
         ID       140 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cCdpTra;
         ID       150 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cPobTra;
         ID       160 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cPrvTra;
         ID       170 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cTlfTra;
         ID       180 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cMovTra;
         ID       190 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cMeiTra;
         ID       260 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      /*
      Datos del trabajador para sacar el coste del mismo-----------------------
      */

      REDEFINE GET ::oDbf:nCosNom ;
         ID       200 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( oTotCosOpe:Refresh(), .t. );
         PICTURE  ::cPouDiv ;
         OF       oDlg

      REDEFINE GET ::oDbf:nCosSSSS ;
         ID       210 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( oTotCosOpe:Refresh(), .t. );
         PICTURE  ::cPouDiv ;
         OF       oDlg

      REDEFINE GET ::oDbf:nDiaPro ;
         ID       220 ;
         SPINNER;
         MIN      0 ;
         MAX      365 ;
         PICTURE  "999" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( oTotCosOpe:Refresh(), .t. );
         OF       oDlg

      REDEFINE GET ::oDbf:nPagas ;
         ID       230 ;
         SPINNER;
         MIN      0 ;
         MAX      99 ;
         PICTURE  "99" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( oTotCosOpe:Refresh(), .t. );
         OF       oDlg

      REDEFINE GET ::oDbf:nHorDia ;
         ID       240 ;
         SPINNER;
         MIN      0 ;
         MAX      24 ;
         PICTURE  "99" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( oTotCosOpe:Refresh(), .t. );
         OF       oDlg

      REDEFINE SAY oTotCosOpe PROMPT ::nCosteOperario() ;
         ID       250 ;
         PICTURE  ::cPouDiv ;
         COLOR    CLR_GET ;
         OF       oDlg

      /*
      Precios por horas-------------------------------------------------------
      */

		REDEFINE BUTTON ;
			ID 		500 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::oDetHoras:Append( oBrwHor ), ::lPostSave( oBrwHor ) )

		REDEFINE BUTTON ;
			ID 		501 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::oDetHoras:Edit( oBrwHor ), ::lPostSave( oBrwHor ) )

		REDEFINE BUTTON ;
			ID 		502 ;
         OF       oDlg ;
         ACTION   ( ::oDetHoras:Zoom() )

      REDEFINE BUTTON ;
         ID       503 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::DelRecHora( oBrwHor ) )

      oBrwHor                 := IXBrowse():New( oDlg )

      oBrwHor:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwHor:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwHor:nMarqueeStyle   := 5

      oBrwHor:bLDblClick      := { || ::oDetHoras:Edit( oBrwHor ), ::lPostSave( oBrwHor ) }

      ::oDetHoras:oDbfVir:SetBrowse( oBrwHor )

      with object ( oBrwHor:AddCol() )
         :cHeader          := "Defecto"
         :bEditValue       := {|| ::oDetHoras:oDbfVir:lDefHor }
         :nWidth           := 65
         :SetCheck( { "Sel16", "Nil16" } )
      end with

      with object ( oBrwHor:AddCol() )
         :cHeader          := "Código"
         :bEditValue       := {|| ::oDetHoras:oDbfVir:cCodHra }
         :nWidth           := 65
      end with

      with object ( oBrwHor:AddCol() )
         :cHeader          := "Tipo de hora"
         :bEditValue       := {|| RetFld( ::oDetHoras:oDbfVir:cCodHra, ::oHoras:oDbf:cAlias, "cDesHra" ) }
         :nWidth           := 485
      end with

      with object ( oBrwHor:AddCol() )
         :cHeader          := "Precio"
         :bEditValue       := {|| Trans( ::oDetHoras:oDbfVir:nCosHra, ::cPouDiv ) }
         :nWidth           := 90
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      oBrwHor:CreateFromResource( 400 )

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( ::lPreSave( oGet, oNom, oSec, oDlg, nMode ) )

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
      oDlg:AddFastKey( VK_F2, {|| ::oDetHoras:Append( oBrwHor ) } )
      oDlg:AddFastKey( VK_F3, {|| ::oDetHoras:Edit( oBrwHor ) } )
      oDlg:AddFastKey( VK_F4, {|| ::oDetHoras:Del( oBrwHor ) } )
      oDlg:AddFastKey( VK_F5, {|| ::lPreSave( oGet, oNom, oSec, oDlg, nMode ) } )
   end if

   oDlg:bStart := { || oGet:SetFocus() }

	ACTIVATE DIALOG oDlg	CENTER

   oBmpGeneral:End()

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

METHOD lPreSave( oGet, oNom, oSec, oDlg, nMode )

   if ( nMode == APPD_MODE .or. nMode == DUPL_MODE )

      oGet:lValid()

      if ::oDbf:SeekInOrd( ::oDbf:cCodTra, "CCODTRA" )
         MsgStop( "Código ya existe " + Rtrim( ::oDbf:cCodTra ) )
         return .f.
      end if

      if Empty( ::oDbf:cCodTra )
         MsgStop( "El código del operario no puede estar vacío." )
         oGet:SetFocus()
         Return .f.
      end if

   end if

   if Empty( ::oDbf:cNomTra )
      MsgStop( "La descripción del operario no puede estar vacío." )
      oNom:SetFocus()
      Return .f.
   end if

Return ( oDlg:End( IDOK ) )

//--------------------------------------------------------------------------//

METHOD nCosteOperario()

   local nCosteOperario := 0

   nCosteOperario := ( ::oDbf:nCosNom + ::oDbf:nCosSSSS ) * ::oDbf:nPagas

   nCosteOperario := nCosteOperario / ::oDbf:nDiaPro

   nCosteOperario := nCosteOperario / ::oDbf:nHorDia

RETURN nCosteOperario

//--------------------------------------------------------------------------//

METHOD lPostSave( oBrw )

   if ::lUltDef

      ::oDetHoras:oDbfVir:GoTop()

      while !::oDetHoras:oDbfVir:Eof()

         if ::oDetHoras:oDbfVir:cCodHra  != ::cUltHora

            ::oDetHoras:oDbfVir:Load()
            ::oDetHoras:oDbfVir:lDefHor   := .f.
            ::oDetHoras:oDbfVir:Save()

         end if

         ::oDetHoras:oDbfVir:Skip()

      end while

   end if

   ::oDetHoras:oDbfVir:GoTop()

   oBrw:Refresh()

RETURN .t.

//--------------------------------------------------------------------------//

METHOD DelRecHora( oBrw )

   local lDefHora := .f.

   if ::oDetHoras:oDbfVir:Recno() == 0
      RETURN ( Self )
   end if

   if SQLAjustableModel():getRolNoConfirmacionEliminacion( Auth():rolUuid() ) .or. ApoloMsgNoYes("¿ Desea eliminar definitivamente este registro ?", "Confirme supersión" )

      if ::oDetHoras:oDbfVir:lDefHor
         lDefHora := .t.
      end if

      ::oDetHoras:oDbfVir:Delete()

   end if

   if lDefHora

      ::oDetHoras:oDbfVir:GoTop()

      if !::oDetHoras:oDbfVir:Eof()
         ::oDetHoras:oDbfVir:Load()
         ::oDetHoras:oDbfVir:lDefHor   := .t.
         ::oDetHoras:oDbfVir:Save()
      end if

   end if

   oBrw:Refresh()

RETURN ( Self )

//--------------------------------------------------------------------------//