#ifndef __PDA__
#include "FiveWin.Ch"
#else
#include "FWCE.ch"
REQUEST DBFCDX
#endif
#include "Factu.ch" 
#include "MesDbf.ch"

#ifndef __PDA__ 

//----------------------------------------------------------------------------//
//Funciones del programa
//----------------------------------------------------------------------------//

CLASS Provincias FROM TMant

   DATA oDlg

   DATA getCodigo
   DATA getProvincia

   METHOD New( cPath, oWndParent, oMenuItem ) CONSTRUCTOR
   METHOD Create( cPath ) CONSTRUCTOR

   METHOD OpenFiles( lExclusive )
   MESSAGE OpenService( lExclusive )               METHOD OpenFiles( lExclusive )

   METHOD DefineFiles()

   METHOD Resource( nMode )
      METHOD lSaveResource()
      METHOD startResource()                       INLINE ( ::getCodigo:setFocus() )

   METHOD getNombreProvincia( cCodigoProvincia )   INLINE ( oRetFld( cCodigoProvincia, ::oDbf, "cNomPrv", 1 ) )

END CLASS

//----------------------------------------------------------------------------//

METHOD Create( cPath, cDriver ) CLASS Provincias

   DEFAULT cPath     := cPatDat()
   DEFAULT cDriver   := cDriver()

   ::cPath           := cPath
   ::cDriver         := cDriver

   ::oDbf            := nil

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD New( cPath, cDriver, oWndParent, oMenuItem ) CLASS Provincias

   DEFAULT oWndParent   := GetWndFrame()

   if oMenuItem != nil
      ::nLevel          := Auth():Level( oMenuItem )
   else
      ::nLevel          := Auth():Level( "01011" )
   end if

   if oWndParent != nil
      oWndParent:CloseAll()
   end if

   ::Create()

   ::oWndParent         := oWndParent
   
   ::lCreateShell       := .f.

   ::cMru               := "gc_flag_spain_16"

   ::cBitmap            := clrTopArchivos

   ::cHtmlHelp          := "Provincias"

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive, cPath ) CLASS Provincias

   local lOpen          := .t.
   local oError
   local oBlock         

   DEFAULT lExclusive   := .f.
   DEFAULT cPath        := ::cPath

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

   RECOVER USING oError

      lOpen             := .f.
      
      msgStop( ErrorMessage( oError ), "Imposible abrir las bases de datos de provincias" )
      
      ::CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver ) CLASS Provincias

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := ::cDriver

   DEFINE DATABASE ::oDbf FILE "Provincia.DBF" CLASS "PROVINCIA" ALIAS "PROVINCIA" PATH ( cPath ) VIA ( cDriver ) COMMENT "Provincias"

      FIELD NAME "cCodPrv"       TYPE "C" LEN  2  DEC 0  COMMENT "Código"                 COLSIZE 80  OF ::oDbf
      FIELD NAME "cNomPrv"       TYPE "C" LEN 30  DEC 0  COMMENT "Provincia"              COLSIZE 200 OF ::oDbf

      INDEX TO "Provincia.CDX" TAG "cCodPrv" ON "cCodPrv"            COMMENT "Código"     NODELETED OF ::oDbf
      INDEX TO "Provincia.CDX" TAG "cNomPrv" ON "Upper( cNomPrv )"   COMMENT "Provincia"  NODELETED OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//----------------------------------------------------------------------------//

METHOD Resource( nMode ) CLASS Provincias

   DEFINE DIALOG ::oDlg RESOURCE "Provincia" TITLE LblTitle( nMode ) + "provincia"

      REDEFINE GET ::getCodigo VAR ::oDbf:cCodPrv UPDATE;
			ID 		100 ;
         WHEN     ( nMode == APPD_MODE ) ;
         PICTURE  "@!" ;
         OF       ::oDlg

      ::getCodigo:bValid := {|| notValid( ::getCodigo, ::oDbf:cAlias ) .and. !empty( ::getCodigo:VarGet() ) }

      REDEFINE GET ::getProvincia VAR ::oDbf:cNomPrv UPDATE;
			ID 		110 ;
         PICTURE  "@!" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		::oDlg
      
      REDEFINE BUTTON;
         ID       IDOK ;
			OF 		::oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( ::lSaveResource( nMode ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		::oDlg ;
         CANCEL ;
			ACTION 	( ::oDlg:end() )

   if nMode != ZOOM_MODE
      ::oDlg:AddFastKey( VK_F5, {|| ::lSaveResource( nMode ) } )
   end if

   ::oDlg:bStart  := { || ::StartResource() }

   ACTIVATE DIALOG ::oDlg CENTER

RETURN ( ::oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

METHOD lSaveResource( nMode ) CLASS Provincias

   if nMode == APPD_MODE .or. nMode == DUPL_MODE
      
      if empty( ::getCodigo:varGet() )
         msgStop( "Código de grupo de família no puede estar vacío." )
         ::getCodigo:setFocus()
         return .f.
      end if

      if ::oDbf:seekInOrd( ::getCodigo:varGet(), "cCodPrv" )
         msgStop( "Código ya existe."  )
         return .f.
      end if

   end if

   if empty( ::getProvincia:varGet() )
      msgStop( "Nombre de provincia no puede estar vacía." )
      ::getProvincia:setFocus()
      return .f.
   end if

RETURN ( ::oDlg:end( IDOK ) )

//---------------------------------------------------------------------------//


