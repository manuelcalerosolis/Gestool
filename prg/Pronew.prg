#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

static   nLevel

//---------------------------------------------------------------------------//

CLASS TPro FROM TMasDet

   METHOD New( cPath, oWndParent, oMenuItem )

   METHOD OpenFiles( cPath )

   METHOD CloseFiles()

   METHOD Resource( nMode )

   METHOD Detalle( nMode, cCod, oBrw )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cPath, oWndParent, oMenuItem )

   DEFAULT cPath        := cPatEmp()
   DEFAULT oWndParent   := GetWndFrame()

   if oMenuItem != nil .and. ::nLevel == nil
      ::nLevel          := Auth():Level( oMenuItem )
   else
      ::nLevel          := 1
   end if

   ::cPath              := cPath
   ::oWndParent         := oWndParent
   ::oDbf               := nil
   ::oDbfDet            := nil

   DEFINE DATABASE ::oDbf FILE "PRO.DBF" CLASS "PRO" ALIAS "PRO" PATH ( cPatEmp() ) VIA ( cDriver() ) COMMENT "Base de datos de propiedades"

   FIELD NAME "CCODPRO" TYPE "C" LEN 05  DEC 0 COMMENT "Código"      OF ::oDbf
   FIELD NAME "CDESPRO" TYPE "C" LEN 35  DEC 0 COMMENT "Propiedad"   OF ::oDbf

   INDEX TO "PRO.CDX" TAG "CCODPRO" ON "CCODPRO" NODELETED OF ::oDbf

   END DATABASE ::oDbf

   DEFINE DATABASE ::oDbfDet FILE "TBLPRO.DBF" CLASS "TBLPRO" ALIAS "TBLPRO" PATH ( cPatEmp() ) VIA cDriver() COMMENT "Tabla de propiedades"

   FIELD NAME "CCODPRO" TYPE "C" LEN 05  DEC 0 OF ::oDbfDet
   FIELD NAME "CCODTBL" TYPE "C" LEN 05  DEC 0 OF ::oDbfDet
   FIELD NAME "CDESTBL" TYPE "C" LEN 30  DEC 0 OF ::oDbfDet
   FIELD NAME "NORDTBL" TYPE "N" LEN 04  DEC 0 OF ::oDbfDet

   INDEX TO "TBLPRO.CDX" TAG "CCODPRO" ON "CCODPRO + CCODTBL" NODELETED OF ::oDbfDet

   END DATABASE ::oDbfDet

   ::cNumDocKey      := "cCodPro"

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD OpenFiles( cPath )

   DEFAULT  cPath := cPatEmp()

   /*
   Definicion del master-------------------------------------------------------
   */

   ACTIVATE DATABASE ::oDbf SHARED NORECYCLE

   /*
   Definicion del detalle------------------------------------------------------
   */

   ACTIVATE DATABASE ::oDbfDet SHARED NORECYCLE

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   ::oDbf:End()
   ::oDbfDet:End()

RETURN ( .t. )

//----------------------------------------------------------------------------//

METHOD Resource( nMode )

	local oDlg
	local oBrw

   ::oDbf:GetStatus()

   ::Load( {|| ::oDbf:cCodPro == ::oDbfDet:cCodPro } )

   DEFINE DIALOG oDlg RESOURCE "PROP" TITLE LblTitle( nMode ) + "propiedades"

      REDEFINE GET ::oDbf:CCODPRO UPDATE;
			ID 		100 ;
         WHEN     ( nMode == APPD_MODE ) ;
			PICTURE 	"@!" ;
			OF 		oDlg

      REDEFINE GET ::oDbf:CDESPRO UPDATE;
			ID 		110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

		REDEFINE LISTBOX oBrw ;
			FIELDS ;
                  ::oDbfVir:cCodTbl,;
                  ::oDbfVir:cDesTbl ;
			HEAD ;
                  "Código",;
                  "Descripción";
			FIELDSIZES;
                  60,;
                  200;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ID       120 ;
			OF 		oDlg

      ::oDbfVir:SetBrowse( oBrw, .f. )

		REDEFINE BUTTON ;
			ID 		500 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( ::AppendDet() )

		REDEFINE BUTTON ;
			ID 		501 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( ::EditDet() )

		REDEFINE BUTTON ;
			ID 		502 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( ::DeleteDet() )

		REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( ::lSave(), oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         ACTION   ( oDlg:end() )

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

METHOD Detalle( nMode, cCod, oBrw )

	local oDlg

   DEFINE DIALOG oDlg RESOURCE "PRODET" TITLE LblTitle( nMode ) + "propiedad"

      REDEFINE GET ::oDbfVir:CCODTBL UPDATE;
			ID 		100 ;
         WHEN     ( nMode == APPD_MODE ) ;
			PICTURE 	"@!" ;
			OF 		oDlg

      REDEFINE GET ::oDbfVir:CDESTBL UPDATE;
			ID 		110 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			PICTURE 	"@!" ;
			OF 		oDlg

      /*
      REDEFINE GET ::oDbfVir:NORDTBL UPDATE;
         ID       120 ;
         PICTURE  "9999";
         SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg
      */

		REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

	ACTIVATE DIALOG oDlg	CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

FUNCTION mkPro( cPath, lAppend, cPathOld, oMeter )

   local oPro
   local oTbl

   DEFAULT cPath     := cPatEmp()
	DEFAULT lAppend	:= .F.

   DEFINE DATABASE oPro ;
         FILE    "\PRO.DBF" ;
         PATH    ( cPath );
         ALIAS   "PRO" ;
         VIA     cDriver() ;
         COMMENT "Base de datos de propiedades"

         FIELD NAME "CCODPRO" TYPE "C" LEN 05  DEC 0 COMMENT "" OF oPro
         FIELD NAME "CDESPRO" TYPE "C" LEN 35  DEC 0 COMMENT "" OF oPro

         INDEX TO "PRO.CDX" TAG CCODPRO ON CCODPRO OF oPro

   END DATABASE oPro

   oPro:Create()

   DEFINE DATABASE oTbl;
         FILE    "\TBLPRO.DBF";
         PATH    ( cPath );
         ALIAS   "TBLPRO" ;
         VIA     cDriver() ;
         COMMENT "Tabla de propiedades"

         FIELD NAME "CCODPRO" TYPE "C" LEN 05  DEC 0 OF oTbl
         FIELD NAME "CCODTBL" TYPE "C" LEN 05  DEC 0 OF oTbl
         FIELD NAME "CDESTBL" TYPE "C" LEN 30  DEC 0 OF oTbL
         FIELD NAME "NORDTBL" TYPE "N" LEN 04  DEC 0 OF oTbL

         INDEX TO "TBLPRO.CDX" TAG CCODPRO ON "CCODPRO + CCODTBL" OF oTbl

   END DATABASE oTbl

   oTbl:Create()

   IF lAppend .and. lIsDir( cPathOld ) .and. .f.

      IF file( cPathOld + "PRO.DBF" )
         oPro:activate()
         oPro:AppendFrom( cPathOld + "PRO.DBF" )
         oPro:end()
      END IF

      IF file( cPathOld + "TBLPRO.DBF" )
         oTbl:activate()
         oTbl:AppendFrom( cPathOld + "TBLPRO.DBF" )
         oTbl:end()
      END IF

	END IF

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION rxPro( cPath, oMeter )

   local dbfPro

   DEFAULT cPath := cPatEmp()

   IF !file( cPath + "PRO.DBF" )
      mkPro( cPath )
   END IF

   IF file( cPath + "PRO.CDX" )
      fErase( cPath + "PRO.CDX" )
   END IF

   IF file( cPath + "TBLPRO.CDX" )
      fErase( cPath + "TBLPRO.CDX" )
   END IF

   if file( cPath + "PRO.DBF" )
      dbUseArea( .t., cDriver(), cPath + "PRO.DBF", cCheckArea( "PRO", @dbfPro ), .f. )
   end if
   if !( dbfPro )->( neterr() )
      ( dbfPro )->( __dbPack() )

      ( dbfPro )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPro )->( ordCreate( cPath + "PRO.CDX", "CCODPRO", "CCODPRO", {|| CCODPRO } ) )

      ( dbfPro )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de propiedades de artículos" )
   end if

   dbUseArea( .t., cDriver(), cPath + "TBLPRO.DBF", cCheckArea( "TBLPRO", @dbfPro ), .f. )
   if !( dbfPro )->( neterr() )
      ( dbfPro )->( __dbPack() )

      ( dbfPro )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPro )->( ordCreate( cPath + "TBLPRO.CDX", "CCODPRO", "CCODPRO + CCODTBL", {|| CCODPRO + CCODTBL } ) )

      ( dbfPro )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de propiedades de artículos" )
   end if

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION cProp( oGet, oSay )

   local oPro
   local lValid   := .f.
   local cCodPrp  := oGet:varget()

   IF empty( cCodPrp )
      RETURN .t.
   END IF

   DEFINE DATABASE oPro ;
         FILE    "\PRO.DBF" ;
         PATH    ( cPatEmp() );
         ALIAS   "PRO" ;
         VIA     cDriver() ;
         COMMENT "Base de datos de propiedades"

         FIELD NAME "CCODPRO" TYPE "C" LEN 05  DEC 0 COMMENT "" OF oPro
         FIELD NAME "CDESPRO" TYPE "C" LEN 35  DEC 0 COMMENT "" OF oPro

         INDEX TO "PRO.CDX" TAG CCODPRO ON CCODPRO OF oPro

   END DATABASE oPro

   ACTIVATE DATABASE oPro SHARED // NOBUFFER

   IF oPro:Seek( cCodPrp )

      IF ValType( oSay ) == "O"
         oSay:SetText( oPro:CDESPRO )
		END IF

		lValid	:= .T.

	END IF

   oPro:end()

RETURN lValid

//---------------------------------------------------------------------------//

FUNCTION retProp( cCodPrp, dbfPro )

   local oBlock
   local oError
   local lClo     := .f.
   local cPrp     := ""

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if dbfPro != nil
      USE ( cPatEmp() + "PRO.DBF" ) NEW VIA ( cDriver() ) SHARED   ALIAS ( cCheckArea( "PRO", @dbfPro ) )
      SET ADSINDEX TO ( cPatEmp() + "PRO.CDX" ) ADDITIVE
      lClo  := .t.
   end if

   IF ( dbfPro )->( dbSeek( cCodPrp ) )
      cPrp := ( dbfPro )->CDESPRO
   END IF

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if lClo
      CLOSE ( dbfPro )
   end if

RETURN ( cPrp )

//---------------------------------------------------------------------------//

FUNCTION brwProp( oGet, oSay )

	local oDlg
   local oGetNbr
   local cGetNbr
   local oBrw
   local oCbxOrd
   local cCbxOrd  := "Código"
   local cCodPrp  := oGet:varget()

   /*
   Obtenemos el nivel de acceso

   if nLevel == nil
      nLevel := Auth():Level( "01016" )
   end if

   OpenFiles()

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Seleccione la propiedad"

      REDEFINE GET oGetNbr VAR cGetNbr ;
			ID 		104 ;
         ON CHANGE AutoSeek( nKey, nFlags, Self, oBrw, oPro:nArea ) ;
			OF 		oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    { "Código" } ;
			OF 		oDlg

		REDEFINE LISTBOX oBrw ;
         FIELDS   ( oPro:cAlias )->CCODPRO,;
                  ( oPro:cAlias )->CDESPRO;
         HEAD     "Codigo",;
                  "Descripción";
         ALIAS    ( oPro:cAlias );
         ON DBLCLICK ( oDlg:end( IDOK ) );
			ID 		105 ;
			OF 		oDlg

      oBrw:bLDblClick   := {|| oDlg:end( IDOK ) }
      oBrw:bKeyDown     := {|nKey, nFalg| if( nKey == VK_RETURN, oDlg:end( IDOK ), ) }

		REDEFINE BUTTON ;
			ID 		500 ;
			OF 		oDlg ;
         ACTION   edtrec( APPD_MODE )

		REDEFINE BUTTON ;
			ID 		501 ;
			OF 		oDlg ;
         ACTION   edtrec( EDIT_MODE )

		REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         ACTION   ( oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

	ACTIVATE DIALOG oDlg

   IF oDlg:nResult == IDOK

      oGet:cText( oPro:CCODPRO )

      IF ValType( oSay ) == "O"
         oSay:SetText( oPro:CDESPRO )
		END IF

	END IF

	oGet:setFocus()

   CloseFiles()
   */

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

FUNCTION brwPropiedadActual( oGet, oSay, cPrp )

	local oDlg
   local oGetNbr
   local cGetNbr
   local oBrw
   local oCbxOrd
   local cCbxOrd  := "Codigo"

   OpenFiles()

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Seleccione la propiedad"

      REDEFINE GET oGetNbr VAR cGetNbr ;
			ID 		104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, oTbl:nArea ) );
         VALID    ( OrdClearScope( oBrw, oTbl:nArea ) );
         BITMAP   "FIND" ;
         OF       oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    { "Codigo" } ;
			OF 		oDlg

		REDEFINE LISTBOX oBrw ;
         FIELDS   oTbl:CCODTBL,;
                  oTbl:CDESTBL ;
         HEAD     "Codigo",;
                  "Descripción";
         ON DBLCLICK ( oDlg:end( IDOK ) );
			ID 		105 ;
			OF 		oDlg

      oTbl:OrdScope( cPrp )
      oTbl:SetBrowse( oBrw )

      oBrw:bLDblClick   := {|| oDlg:end( IDOK ) }
      oBrw:bKeyDown     := {|nKey, nFalg| if( nKey == VK_RETURN, oDlg:end( IDOK ), ) }

		REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         ACTION   ( oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

	ACTIVATE DIALOG oDlg

   IF oDlg:nResult == IDOK

      oGet:cText( oTbl:CCODTBL )

      IF valtype( oSay ) == "O"
         oSay:SetText( oTbl:CDESTBL )
		END IF

	END IF

	oGet:setFocus()

   CloseFiles()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

FUNCTION lPrpAct( oGet, oSay, cPrp, dbfTblPro )

   local lRet     := .f.
   local xValor   := oGet:varGet()

   if Empty( cPrp )
      return .f.
   end if

   if ( dbfTblPro )->( dbSeek( cPrp + xValor ) )
      if oSay != nil
         oSay:SetText( ( dbfTblPro )->CDESTBL )
      end if
      lRet  := .t.
   else
      if oSay != nil
         oSay:SetText( "" )
      end if
   end if

RETURN ( lRet )

//---------------------------------------------------------------------------//

function lIsProp1( cCodArt, dbfFamilia, dbfArticulo )

   local lIsPro   := .f.

   if ( dbfArticulo )->( dbSeek( cCodArt ) )
      lIsPro      := Empty( ( dbfArticulo )->CCODPRP1 )
   end if

return ( lIsPro )

//---------------------------------------------------------------------------//

function lIsProp2( cCodArt, dbfFamilia, dbfArticulo )

   local lIsPro   := .f.

   if ( dbfArticulo )->( dbSeek( cCodArt ) )
      lIsPro      := Empty( ( dbfArticulo )->CCODPRP2 )
   end if

return ( lIsPro )

//---------------------------------------------------------------------------//

FUNCTION Prop( oMenuItem, oWnd )

   local oProp

   DEFAULT  oMenuItem   := "01015"
   DEFAULT  oWnd        := oWnd()

   if nLevel == nil
      nLevel := Auth():Level( oMenuItem )
   end if

   if nAnd( nLevel, 1 ) == 0
      msgStop( "Acceso no permitido." )
      return nil
   end if

   /*
   Cerramos todas las ventanas
   */

   if oWnd != nil
      SysRefresh(); oWnd:CloseAll(); SysRefresh()
   end if

   /*
   Anotamos el movimiento para el navegador
   */

   AddMnuNext( "Propiedades de artículos", ProcName() )

   oProp  := TPro():New( cPatEmp() )
   oProp:Activate( nLevel )

RETURN NIL

//--------------------------------------------------------------------------//