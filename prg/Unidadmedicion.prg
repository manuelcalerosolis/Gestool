#ifndef __PDA__
#include "FiveWin.Ch"
#else
#include "FWCE.ch"
REQUEST DBFCDX
#endif
#include "MesDbf.ch"
#include "Factu.ch" 

#ifndef __PDA__
#endif
//----------------------------------------------------------------------------//

CLASS UniMedicion FROM TMant

   DATA  cName             INIT "UnidadMedicion"

   DATA  cMru              INIT "gc_tape_measure2_16"

   DATA  oGetDimension

   DATA  oGetTextoDimension1
   DATA  oGetTextoDimension2
   DATA  oGetTextoDimension3

   METHOD Create( cPath )                       CONSTRUCTOR

   METHOD New( cPath, oWndParent, oMenuItem )   CONSTRUCTOR

   METHOD OpenFiles( lExclusive )

   METHOD OpenService( lExclusive )             INLINE ( ::OpenFiles( lExclusive ) )

   METHOD DefineFiles()

   METHOD Resource( nMode )

   METHOD lPreSave( nMode )

   Method ChangeDimension()

   Method Syncronize()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create( cPath )

   DEFAULT cPath        := cPatEmp()

   ::cPath              := cPath
   ::oDbf               := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD New( cPath, oWndParent, oMenuItem )

   DEFAULT cPath        := cPatEmp()
   DEFAULT oWndParent   := oWnd()

   if oMenuItem != nil
      ::nLevel          := nLevelUsr( oMenuItem )
   end if

   ::cPath              := cPath
   ::oWndParent         := oWndParent
   ::oDbf               := nil

   ::cBitmap            := clrTopArchivos

   ::lAutoButtons       := .t.
   ::lCreateShell       := .f.

   ::cPicUnd            := MasUnd()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive )

   local lOpen          := .t.
   local oError
   local oBlock         

   DEFAULT  lExclusive  := .f.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::DefineFiles()
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos de unidades de medición" + CRLF + ErrorMessage( oError )  )

      ::CloseFiles()

      lOpen             := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE TABLE ::oDbf FILE "UndMed.Dbf" CLASS "TUniMed" ALIAS "UndMed" PATH ( cPath ) VIA ( cDriver ) COMMENT "Unidades de medición"

      FIELD NAME "cCodMed"    TYPE "C" LEN 2   DEC 0 COMMENT "Código"         COLSIZE 50  OF ::oDbf
      FIELD NAME "cNombre"    TYPE "C" LEN 100 DEC 0 COMMENT "Nombre"         COLSIZE 200 OF ::oDbf
      FIELD NAME "nDimension" TYPE "N" LEN 1   DEC 0 COMMENT ""               HIDE        OF ::oDbf
      FIELD NAME "cAcronimo"  TYPE "C" LEN 6   DEC 0 COMMENT "Acronimo"       COLSIZE 60  OF ::oDbf
      FIELD NAME "cTextoDim1" TYPE "C" LEN 25  DEC 0 COMMENT "Dimensión 1"    COLSIZE 200 OF ::oDbf
      FIELD NAME "cTextoDim2" TYPE "C" LEN 25  DEC 0 COMMENT "Dimensión 2"    COLSIZE 200 OF ::oDbf
      FIELD NAME "cTextoDim3" TYPE "C" LEN 25  DEC 0 COMMENT "Dimensión 3"    COLSIZE 200 OF ::oDbf

      INDEX TO "UndMed.Cdx" TAG "cCodMed"    ON "cCodMed"    COMMENT "Código" NODELETED   OF ::oDbf
      INDEX TO "UndMed.Cdx" TAG "cNombre"    ON "cNombre"    COMMENT "Nombre" NODELETED   OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//----------------------------------------------------------------------------//

METHOD Resource( nMode )

   local oDlg
   local oGet

   if nMode == APPD_MODE
      ::oDbf:nDimension := 0
   end if

   DEFINE DIALOG oDlg RESOURCE "UND_MEDICION" TITLE LblTitle( nMode ) + "unidades de medición"

      REDEFINE GET oGet VAR ::oDbf:cCodMed;
         ID       110 ;
         WHEN     ( nMode == APPD_MODE ) ;
         VALID    NotValid( oGet, ::oDbf:cAlias ) ;
			PICTURE 	"@!" ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cNombre;
         ID       120 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET ::oGetDimension VAR ::oDbf:nDimension;
         ID       130 ;
         SPINNER;
         MIN      0;
         MAX      3;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( ::oDbf:nDimension >= 0 .and. ::oDbf:nDimension <= 3 ) ;
         PICTURE  "9" ;
         OF       oDlg

      ::oGetDimension:bChange := {|| ::ChangeDimension() }

      REDEFINE GET ::oDbf:cAcronimo;
         ID       140 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			PICTURE 	"@!" ;
         OF       oDlg

      REDEFINE GET ::oGetTextoDimension1 VAR ::oDbf:cTextoDim1;
         ID       150 ;
         IDSAY    151 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oGetTextoDimension2 VAR::oDbf:cTextoDim2;
         ID       160 ;
         IDSAY    161 ;
         WHEN     ( nMode != ZOOM_MODE .and. ::oDbf:nDimension >= 2 ) ;
         OF       oDlg

      REDEFINE GET ::oGetTextoDimension3 VAR::oDbf:cTextoDim3;
         ID       170 ;
         IDSAY    171 ;
         WHEN     ( nMode != ZOOM_MODE .and. ::oDbf:nDimension == 3 ) ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( if( ::lPreSave( nMode ), oDlg:end( IDOK ), ) )

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
      oDlg:AddFastKey( VK_F5, {|| if( ::lPreSave( nMode ), oDlg:end( IDOK ), ) } )
   end if

   oDlg:bStart    := {|| ::ChangeDimension(), oGet:SetFocus() }

	ACTIVATE DIALOG oDlg	CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

METHOD lPreSave( nMode )

   if nMode == APPD_MODE .or. nMode == DUPL_MODE

      if ::oDbf:SeekInOrd( ::oDbf:cCodMed, "CCODMED" )
         MsgStop( "Código ya existe " + Rtrim( ::oDbf:cCodMed ) )
         return .f.
      end if

   end if

   if Empty( ::oDbf:cNombre )
      MsgStop( "El campo nombre de medición no puede estar vacio." )
      Return .f.
   end if

   if ::oDbf:nDimension > 0 .and. Empty( ::oDbf:cTextoDim1)
      MsgStop( "El campo dimensión 1 no puede estar vacio." )
      return .f.
   end if

   if ::oDbf:nDimension > 1 .and. Empty( ::oDbf:cTextoDim2 )
      MsgStop( "El campo dimensión 2 no puede estar vacio." )
      return .f.
   end if

   if ::oDbf:nDimension > 2 .and. Empty( ::oDbf:cTextoDim3 )
      MsgStop( "El campo dimensión 3 no puede estar vacio." )
      return .f.
   end if

   if ::oDbf:nDimension < 1
      ::oDbf:cTextoDim1 := Space( 25 )
   end if

   if ::oDbf:nDimension < 2
      ::oDbf:cTextoDim2 := Space( 25 )
   end if

   if ::oDbf:nDimension < 3
      ::oDbf:cTextoDim3 := Space( 25 )
   end if

RETURN .t.

//--------------------------------------------------------------------------//

Method ChangeDimension()

   local nDimension  := ::oGetDimension:VarGet()

   do case
      case nDimension == 0
         ::oGetTextoDimension1:Hide()
         ::oGetTextoDimension2:Hide()
         ::oGetTextoDimension3:Hide()

      case nDimension == 1
         ::oGetTextoDimension1:Show()
         ::oGetTextoDimension2:Hide()
         ::oGetTextoDimension3:Hide()

      case nDimension == 2
         ::oGetTextoDimension1:Show()
         ::oGetTextoDimension2:Show()
         ::oGetTextoDimension3:Hide()

      case nDimension == 3
         ::oGetTextoDimension1:Show()
         ::oGetTextoDimension2:Show()
         ::oGetTextoDimension3:Show()

   end case

Return .t.

//--------------------------------------------------------------------------//

Method Syncronize()

   if ::OpenService( .t. )

      if !::oDbf:Seek( "UD" )

         ::oDbf:Append()
         ::oDbf:cCodMed    := "UD"
         ::oDbf:cNombre    := "Unidades"
         ::oDbf:cAcronimo  := "UD"
         ::oDbf:Save()

      end if

      ::CloseService()

   end if

Return .t.

//--------------------------------------------------------------------------//