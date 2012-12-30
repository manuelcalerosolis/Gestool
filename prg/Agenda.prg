#include "FiveWin.Ch"
#include "Factu.ch"
#include "MesDbf.ch" 

//----------------------------------------------------------------------------//

CLASS TAgenda FROM TMANT

   METHOD Create( cPath )

   METHOD OpenFiles()
   MESSAGE OpenService()   METHOD OpenFiles()

   METHOD DefineFiles()
   /*
   METHOD Activate( oWnd )
   */
   METHOD Resource( nMode )

END CLASS

//----------------------------------------------------------------------------//

METHOD Create( cPath )

   DEFAULT cPath     := cPatDat()

   ::cPath           := cPath
   ::oDbf            := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive )

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lExclusive   := .f.

   BEGIN SEQUENCE

   if Empty( ::oDbf )
      ::DefineFiles()
   end if

   ::oDbf:Activate( .f., !( lExclusive ), .f., .f. )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos" )

      ::CloseFiles()

      lOpen             := .f.

   END SEQUENCE
   ErrorBlock( oBlock )

RETURN lOpen

//----------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   DEFAULT cPath     := ::cPath
   DEFAULT cDriver   := cDriver()

   DEFINE TABLE ::oDbf FILE "Agenda.Dbf" CLASS "Agenda" PATH ( cPath ) ALIAS "Agenda" VIA ( cDriver ) COMMENT "Listín telefónico"

      FIELD NAME "CAPELLIDOS"   TYPE "C" LEN 200  DEC 0 COMMENT "Nombre"          DEFAULT "Nombre completo" COLSIZE 200 OF ::oDbf
      FIELD NAME "CNIF"         TYPE "C" LEN  15  DEC 0 COMMENT "Nif"             DEFAULT "NIF"             COLSIZE  80 OF ::oDbf
      FIELD NAME "CDOMICILIO"   TYPE "C" LEN 200  DEC 0 COMMENT "Domicilio"       DEFAULT "Domicilio"       COLSIZE 200 OF ::oDbf
      FIELD NAME "CCODPOSTAL"   TYPE "C" LEN   5  DEC 0 COMMENT "Código postal"                             COLSIZE  50 OF ::oDbf
      FIELD NAME "CPOBLACION"   TYPE "C" LEN 100  DEC 0 COMMENT "Población"       DEFAULT "Población"       COLSIZE 100 OF ::oDbf
      FIELD NAME "CPROVINCIA"   TYPE "C" LEN  60  DEC 0 COMMENT "Provincia"       DEFAULT "Provincia"       COLSIZE  60 OF ::oDbf
      FIELD NAME "CTEL"         TYPE "C" LEN  12  DEC 0 COMMENT "Teléfono"                                  COLSIZE  60 OF ::oDbf
      FIELD NAME "CDESTEL"      TYPE "C" LEN  20  DEC 0 COMMENT "Nombre teléfono"                           COLSIZE 100 OF ::oDbf
      FIELD NAME "CMOV"         TYPE "C" LEN  12  DEC 0 COMMENT "Móvil"                                     COLSIZE  60 OF ::oDbf
      FIELD NAME "CDESMOV"      TYPE "C" LEN  20  DEC 0 COMMENT "Nombre móvil"                              COLSIZE 100 OF ::oDbf
      FIELD NAME "CFAX"         TYPE "C" LEN  12  DEC 0 COMMENT "Fax"                                       COLSIZE  60 OF ::oDbf
      FIELD NAME "CDESFAX"      TYPE "C" LEN  20  DEC 0 COMMENT "Nombre fax"                                COLSIZE 100 OF ::oDbf
      FIELD NAME "MOBSERVA"     TYPE "M" LEN  10  DEC 0 COMMENT "Observaciones"   DEFAULT "Observaciones"   HIDE        OF ::oDbf
      FIELD NAME "LSELECT"      TYPE "L" LEN   1  DEC 0 COMMENT ""                                          HIDE        OF ::oDbf

      INDEX TO "AGENDA.CDX" TAG "CAPELLIDOS" ON "UPPER( CAPELLIDOS )" NODELETED COMMENT "Nombre"         OF ::oDbf
      INDEX TO "AGENDA.CDX" TAG "CNIF"       ON "CNIF"                NODELETED COMMENT "Nif"            OF ::oDbf
      INDEX TO "AGENDA.CDX" TAG "CCODPOSTAL" ON "CCODPOSTAL"          NODELETED COMMENT "Código postal"  OF ::oDbf
      INDEX TO "AGENDA.CDX" TAG "CPOBLACION" ON "CPOBLACION"          NODELETED COMMENT "Población"      OF ::oDbf
      INDEX TO "AGENDA.CDX" TAG "CPROVINCIA" ON "CPROVINCIA"          NODELETED COMMENT "Provincia"      OF ::oDbf
      INDEX TO "AGENDA.CDX" TAG "CTEL"       ON "CTEL"                NODELETED COMMENT "Teléfono"       OF ::oDbf
      INDEX TO "AGENDA.CDX" TAG "CMOV"       ON "CMOV"                NODELETED COMMENT "Móvil"          OF ::oDbf
      INDEX TO "AGENDA.CDX" TAG "CFAX"       ON "CFAX"                NODELETED COMMENT "Fax"            OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//----------------------------------------------------------------------------//
/*
METHOD Activate( oWnd )

   // Nivel de usuario------------------------------------------------------------

   if nAnd( ::nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      Return ( Self )
   end if

   // Cerramos todas las ventanas-------------------------------------------------

   if ::oWndParent != nil
      ::oWndParent:CloseAll()
   end if

   if !::OpenFiles()
      return nil
   end if

   DEFINE SHELL ::oWndBrw FROM 2, 10 TO 18, 70 ;
      TITLE    "Listín telefónico" ;
      FIELDS   ::oDbf:cApellidos,;
               ::oDbf:cNif,;
               ::oDbf:cTel + Space( 1 ) + ::oDbf:cDesTel,;
               ::oDbf:cMov + Space( 1 ) + ::oDbf:cDesMov,;
               ::oDbf:cFax + Space( 1 ) + ::oDbf:cDesFax ;
      HEAD     "Nombre",;
               "Nif",;
               "Teléfono",;
               "Móvil",;
               "Fax" ;
      PROMPT   "Nombre",;
               "Nif",;
               "Teléfono",;
               "Móvil",;
               "Fax" ;
      FIELDSIZES 200,;
               80,;
               120,;
               120,;
               120 ;
      JUSTIFY  .f., .f., .f., .f., .f. ;
      MRU      "Telephone_16" ;
      BITMAP   "WebTopGreen" ;
      ALIAS    ( ::oDbf ) ;
      APPEND   ::Append() ;
      EDIT     ::Edit() ;
      DELETE   ::Del() ;
      DUPLICAT ::Dup() ;
      OF       ::oWndParent

      ::oWndBrw:AutoButtons( Self )

      ACTIVATE WINDOW ::oWndBrw VALID ( ::CloseFiles() )

RETURN ( Self )
*/
//----------------------------------------------------------------------------//

METHOD Resource( nMode )

	local oDlg

   DEFINE DIALOG oDlg RESOURCE "AGENDA" TITLE LblTitle( nMode ) + "Ficha"

      REDEFINE GET ::oDbf:cNif;
			ID 		100 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			PICTURE 	"@!" ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cApellidos ;
			ID 		110 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cDomicilio ;
			ID 		130 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cPoblacion ;
			ID 		140 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cProvincia ;
			ID 		150 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cCodPostal ;
			ID 		160 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cTel ;
         ID       170 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cDesTel ;
         ID       171 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cMov ;
         ID       180 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cDesMov ;
         ID       181 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cFax ;
         ID       190 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cDesFax ;
         ID       191 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET ::oDbf:mObserva ;
         MEMO ;
			ID 		210;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

		REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| oDlg:end( IDOK ) } )
   end if

	ACTIVATE DIALOG oDlg	CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//