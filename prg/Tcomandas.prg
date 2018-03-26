#ifndef __PDA__
#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#else
#include "FWCE.ch"
REQUEST DBFCDX
#endif

//---------------------------------------------------------------------------//

CLASS TComandas FROM TMANT

   DATA  aComandas
   DATA  cPouDiv
   DATA  cMru

   METHOD Create( cPath ) CONSTRUCTOR

   METHOD New( cPath, oWndParent, oMenuItem ) CONSTRUCTOR

   METHOD DefineFiles()

   METHOD OpenFiles( lExclusive )
   MESSAGE OpenService( lExclusive )   METHOD OpenFiles( lExclusive )

   METHOD Resource( nMode )

   METHOD lPreSave( oGet, oDlg )

   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create( cPath )

   DEFAULT cPath     := cPatEmp()

   ::cPath           := cPath
   ::oDbf            := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD New( cPath, oWndParent, oMenuItem )

   DEFAULT cPath        := cPatEmp()
   DEFAULT oWndParent   := oWnd()

   if oMenuItem != nil
      ::nLevel          := Auth():Level( oMenuItem )
   else
      ::nLevel          := 1
   end if

   /*
   Cerramos todas las ventanas
   */

   if oWndParent != nil
      oWndParent:CloseAll()
   end if

   ::cPath              := cPath
   ::oWndParent         := oWndParent
   ::oDbf               := nil

   ::lCreateShell       := .f.

   ::cMru               := "gc_document_text_check_16"

   ::cHtmlHelp          := "Tipos de comandas"

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive, cPath )

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT cPath        := ::cPath
   DEFAULT lExclusive   := .f.

   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

  RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir las bases de datos de tipos de comandas" )

      ::CloseFiles()

      lOpen             := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE DATABASE ::oDbf FILE "TComandas.Dbf" CLASS "TComandas" ALIAS "TComandas" PATH ( cPath ) VIA ( cDriver ) COMMENT "Tipos de comandas"

      FIELD NAME "cCodigo" TYPE "C" LEN  3  DEC 0 COMMENT "Código"         COLSIZE  70       OF ::oDbf
      FIELD NAME "cNombre" TYPE "C" LEN 50  DEC 0 COMMENT "Nombre"         COLSIZE 150       OF ::oDbf
      FIELD NAME "nOrden"  TYPE "N" LEN  1  DEC 0 COMMENT "Orden"          COLSIZE  70       OF ::oDbf

      INDEX TO "TComandas.Cdx" TAG "cCodigo" ON "cCodigo"            COMMENT "Código"  NODELETED OF ::oDbf
      INDEX TO "TComandas.Cdx" TAG "cNombre" ON "Upper( cNombre )"   COMMENT "Nombre"  NODELETED OF ::oDbf
      INDEX TO "TComandas.Cdx" TAG "nOrden"  ON "Str( nOrden )"      COMMENT "Orden"   NODELETED OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//----------------------------------------------------------------------------//

METHOD Resource( nMode )

	local oDlg
   local oGet, oGet2, oGet3

   DEFINE DIALOG oDlg RESOURCE "TComandas" TITLE LblTitle( nMode ) + "Tipos de comandas"

      REDEFINE GET oGet VAR ::oDbf:cCodigo ;
         ID       100 ;
         WHEN     ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) ;
         OF       oDlg

      REDEFINE GET oGet2 VAR ::oDbf:cNombre ;
         ID       90 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET oGet3 VAR ::oDbf:nOrden ;
         ID       110 ;
         SPINNER ;
         MIN      1 ;
         PICTURE  "99" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       500 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::lPreSave( oGet, oGet2, oGet3, oDlg, nMode ) )

      REDEFINE BUTTON ;
         ID       550 ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      REDEFINE BUTTON ;
         ID       9 ;
         OF       oDlg ;
         ACTION   ( msginfo( "Ayuda no definida" ) )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| ::lPreSave( oGet, oGet2, oGet3, oDlg, nMode ) } )
   end if

   oDlg:AddFastKey ( VK_F1, {|| ChmHelp( "Tipos de comandas" ) } )

   oDlg:bStart := { || oGet:SetFocus() }

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS TComandas

   if nAnd( ::nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      Return ( Self )
   end if

   ::CreateShell( ::nLevel )

   ::oWndBrw:GralButtons( Self )

   ::oWndBrw:EndButtons( Self )

   ::oWndBrw:cHtmlHelp  := "Tipos de comandas"

   ::oWndBrw:Activate(  , , , , , , , , , , , , , , , , {|| ::CloseFiles() } )

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD lPreSave( oGet, oGet2, oGet3, oDlg, nMode )

   if nMode == APPD_MODE .or. nMode == DUPL_MODE
      if Empty( ::oDbf:cCodigo )
         MsgStop( "Código de tipo de comanda no puede estar vacio" )
         oGet:SetFocus()
         Return .f.
      end if

      if ::oDbf:SeekInOrd( ::oDbf:cCodigo, "CCODIGO" )
         MsgStop( "Código ya existe " + Rtrim( ::oDbf:cCodigo ) )
         return nil
      end if

   end if

   if Empty( ::oDbf:cNombre )
      MsgStop( "Nombre de tipo de comanda no puede estar vacío." )
      oGet2:SetFocus()
      Return .f.
   end if

   if Empty( ::oDbf:cNombre )
      MsgStop( "Orden de tipo de comanda no puede estar vacío." )
      oGet3:SetFocus()
      Return .f.
   end if

RETURN ( oDlg:end( IDOK ) )

//---------------------------------------------------------------------------//