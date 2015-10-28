#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//----------------------------------------------------------------------------//
//Funciones del programa
//----------------------------------------------------------------------------//

CLASS CodigosPostales FROM TMant

   DATA oDlg

   DATA getCodigo
   DATA getPoblacion
   DATA getProvincia

   DATA hCodigoPostal
   DATA oldCodigoPostal

   DATA oProvincias

   METHOD New( cPath, oWndParent, oMenuItem ) CONSTRUCTOR
   METHOD Create( cPath ) CONSTRUCTOR

   METHOD OpenFiles( lExclusive )
      MESSAGE OpenService( lExclusive )               METHOD OpenFiles( lExclusive )
   METHOD CloseFiles() 
   METHOD DefineFiles()

   METHOD Resource( nMode )
      METHOD lSaveResource()
      METHOD startResource()                          INLINE ( ::getCodigo:setFocus(), ::getProvincia:lValid() )

   METHOD getCodigoPostal()                           INLINE ( if( hhaskey( ::hCodigoPostal, "CodigoPostal" ), hget( ::hCodigoPostal, "CodigoPostal" ), nil ) )

   METHOD getPoblacion()                              INLINE ( if( hhaskey( ::hCodigoPostal, "Poblacion" ), hget( ::hCodigoPostal, "Poblacion" ), nil ) 
   METHOD setPoblacion( cPoblacion )                  INLINE ( if( !empty( ::getPoblacion() ), ::getPoblacion():cText( cPoblacion ), nil ) )

   METHOD getProvincia()                              INLINE ( if( hhaskey( ::hCodigoPostal, "Provincia" ), hget( ::hCodigoPostal, "Provincia" ), nil ) 
   METHOD setProvincia( cProvincia )                  INLINE ( if( !empty( ::getProvincia() ), ::getProvincia():cText( cProvincia ), nil ) )

   METHOD setBinding( hCodigoPostal )               
   METHOD setOldValueCodigoPostal( cCodigoPostal )    INLINE ( ::oldCodigoPostal := cCodigoPostal )
   METHOD validCodigoPostal()

END CLASS

//----------------------------------------------------------------------------//

METHOD Create( cPath, cDriver ) CLASS CodigosPostales

   DEFAULT cPath     := cPatDat()
   DEFAULT cDriver   := cDriver()

   ::cPath           := cPath
   ::cDriver         := cDriver
   ::oDbf            := nil

   ::oProvincias     := Provincias():Create( cPath, cDriver )  

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD New( cPath, cDriver, oWndParent, oMenuItem ) CLASS CodigosPostales

   DEFAULT oWndParent   := GetWndFrame()

   if oMenuItem != nil
      ::nLevel          := nLevelUsr( oMenuItem )
   else
      ::nLevel          := nLevelUsr( "01011" )
   end if

   if oWndParent != nil
      oWndParent:CloseAll()
   end if

   ::oWndParent         := oWndParent

   ::lCreateShell       := .f.
   ::cMru               := "Flag_spain_16"
   ::cBitmap            := clrTopArchivos

   ::Create( cPath, cDriver )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive, cPath ) CLASS CodigosPostales

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

      if !empty( ::oProvincias )
         ::oProvincias:OpenFiles()
      end if

   RECOVER

      lOpen             := .f.
      
      msgStop( "Imposible abrir las bases de datos de codigos postales" )
      
      ::CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD CloseFiles() CLASS CodigosPostales

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:End()
      ::oDbf      := nil
   end if

   if !empty( ::oProvincias )
      ::oProvincias:End()
   end if

   ::oProvincias  := nil

RETURN .t.

//---------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver ) CLASS CodigosPostales

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := ::cDriver

   DEFINE DATABASE ::oDbf FILE "CODPOSTAL.DBF" CLASS "CODPOSTAL" ALIAS "CODPOSTAL" PATH ( cPath ) VIA ( cDriver ) COMMENT "CodigosPostales"

      FIELD NAME "cCodPos"       TYPE "C" LEN  5  DEC 0  COMMENT "Código"                             COLSIZE 80  OF ::oDbf
      FIELD NAME "cNomPos"       TYPE "C" LEN 60  DEC 0  COMMENT "Población"                          COLSIZE 200 OF ::oDbf
      FIELD NAME "cCodPrv"       TYPE "C" LEN  2  DEC 0  COMMENT "Provincia"                          COLSIZE 200 OF ::oDbf

      INDEX TO "CODPOSTAL.CDX" TAG "cCodPos" ON "cCodPos"            COMMENT "Código"     NODELETED OF ::oDbf
      INDEX TO "CODPOSTAL.CDX" TAG "cNomPos" ON "Upper( cNomPos )"   COMMENT "Población"  NODELETED OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//----------------------------------------------------------------------------//

METHOD Resource( nMode ) CLASS CodigosPostales

   DEFINE DIALOG ::oDlg RESOURCE "CodigoPostal" TITLE LblTitle( nMode ) + "codigos postales"

      REDEFINE GET ::getCodigo VAR ::oDbf:cCodPos UPDATE;
			ID 		100 ;
         WHEN     ( nMode == APPD_MODE ) ;
         PICTURE  "@!" ;
         OF       ::oDlg

      ::getCodigo:bValid         := {|| notValid( ::getCodigo, ::oDbf:cAlias ) .and. !empty( ::getCodigo:VarGet() ) }

      REDEFINE GET ::getPoblacion VAR ::oDbf:cNomPos UPDATE;
			ID 		110 ;
         PICTURE  "@!" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		::oDlg
      
      REDEFINE GET ::getProvincia VAR ::oDbf:cCodPrv ;
         ID       120 ;
         IDTEXT   121 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         OF       ::oDlg

         ::getProvincia:bHelp    := {|| ::oProvincias:Buscar( ::getProvincia ) }
         ::getProvincia:bValid   := {|| ::oProvincias:Existe( ::getProvincia, ::getProvincia:oHelpText, "cNomPrv", .t., .t., "0" ) }

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

METHOD lSaveResource( nMode ) CLASS CodigosPostales

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

   if empty( ::getPoblacion:varGet() )
      msgStop( "Nombre de provincia no puede estar vacía." )
      ::getPoblacion:setFocus()
      return .f.
   end if

RETURN ( ::oDlg:end( IDOK ) )

//---------------------------------------------------------------------------//

METHOD setBinding( hCodigoPostal )

   ::hCodigoPostal  := hCodigoPostal

   if !empty( ::getCodigoPostal() )
      ::setOldValueCodigoPostal( ::getCodigoPostal():varGet() )
   end if 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD validCodigoPostal()

   local cCodigoPostal  

   if empty( ::getCodigoPostal() )
      RETURN .t.
   end if 

   cCodigoPostal        := ::getCodigoPostal():varGet() 

   if ::oldCodigoPostal != cCodigoPostal
      
      if ::oDbf:seek( cCodigoPostal )
         ::setPoblacion( ::oDbf:cNomPos )
         ::setProvincia( ::oProvincias:getNombreProvincia( ::oDbf:cCodPrv ) )
      end if  

      ::setOldValueCodigoPostal( cCodigoPostal )

   else 
      msgAlert( "No ha cambiado el codigo")
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//
