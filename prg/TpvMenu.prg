#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//----------------------------------------------------------------------------//

CLASS TpvMenu FROM TMasDet

   CLASSDATA oInstance

   DATA  cMru                                   INIT "Led_Red_16"

   DATA  oGetCodigo
   DATA  oGetNombre

   DATA oOrdenComandas  

   DATA oDetOrdenesMenu   

   DATA oBrwOrdenesComanda

   METHOD New( cPath, oWndParent, oMenuItem )   CONSTRUCTOR
   METHOD Create( cPath )                       CONSTRUCTOR

   METHOD DefineFiles()

   METHOD OpenFiles( lExclusive, cPath )   
   METHOD CloseFiles( lExclusive, cPath )   

   METHOD Resource( nMode )
   METHOD   StartResource()                     VIRTUAL
   METHOD   lSaveResource()

END CLASS

//----------------------------------------------------------------------------//

METHOD New( cPath, oWndParent, nLevel )

   DEFAULT oWndParent   := GetWndFrame()
   DEFAULT nLevel       := "01200"

   ::Create( cPath )

   if Empty( ::nLevel )
      ::nLevel          := nLevelUsr( nLevel )
   end if

   /*
   Cerramos todas las ventanas-------------------------------------------------
   */

   if oWndParent != nil
      oWndParent:CloseAll()
   end if

   ::cPath              := cPath
   ::oWndParent         := oWndParent

   ::lAutoButtons       := .t.
   ::lCreateShell       := .f.

   ::oOrdenComandas     := TOrdenComanda():Create()

   ::oDetOrdenesMenu    := TpvOrdenesMenu():New( cPath, Self )
   ::AddDetail( ::oDetOrdenesMenu )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Create( cPath )

   DEFAULT cPath        := cPatEmp()

   ::cPath              := cPath
   ::oDbf               := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE DATABASE ::oDbf FILE "TpvMenus.Dbf" CLASS "TpvMenus" ALIAS "TpvMenus" PATH ( cPath ) VIA ( cDriver ) COMMENT "Menús TPV" 

      FIELD NAME "cCodMnu"  TYPE "C" LEN  3  DEC 0  COMMENT "Código"                               COLSIZE 80  OF ::oDbf
      FIELD NAME "cNomMnu"  TYPE "C" LEN 40  DEC 0  COMMENT "Nombre"                               COLSIZE 200 OF ::oDbf
      FIELD NAME "nImpMnu"  TYPE "N" LEN 16  DEC 6  COMMENT "Precio"          PICTURE cPorDiv()    COLSIZE 80  OF ::oDbf
      FIELD NAME "lObsMnu"  TYPE "L" LEN 1   DEC 0  COMMENT "Obsoleto"                             HIDE        OF ::oDbf

      INDEX TO "TpvMenus.Cdx" TAG "cCodMnu" ON "cCodMnu"   COMMENT "Código"        NODELETED                   OF ::oDbf
      INDEX TO "TpvMenus.Cdx" TAG "cNomMnu" ON "cNomMnu"   COMMENT "Nombre"        NODELETED                   OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//----------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive, cPath )

   local oError
   local oBlock         

   DEFAULT lExclusive   := .f.

   ::lOpenFiles         := .t.
   
   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf         := ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

      if !::oOrdenComandas:OpenFiles()
         ::lOpenFiles   := .f.
      end if      

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir las bases de datos." )

      ::CloseFiles()
      
      ::lOpenFiles      := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( ::lOpenFiles )

//----------------------------------------------------------------------------//

METHOD CloseFiles() 

   if !Empty( ::oDbf ) .and. ::oDbf:Used()
      ::oDbf:End()
   end if

   if !Empty( ::oOrdenComandas )
      ::oOrdenComandas:End()
   end if      

   ::oDbf      := nil

RETURN .t.

//----------------------------------------------------------------------------//

METHOD Resource( nMode )

	local oDlg

   DEFINE DIALOG oDlg RESOURCE "TpvMenus" TITLE LblTitle( nMode ) + "Ménus"

      REDEFINE GET ::oGetCodigo ;
         VAR      ::oDbf:cCodMnu ;
			ID 		100 ;
         WHEN     ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) ;
         VALID    NotValid( ::oGetCodigo, ::oDbf:cAlias, .t., "0" ) ;
			PICTURE 	"@!" ;
			OF 		oDlg

      REDEFINE GET ::oGetNombre ;
         VAR      ::oDbf:cNomMnu ;
			ID 		110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET ::oDbf:nImpMnu ;
         ID       120 ;
         PICTURE  ( cPorDiv() ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE CHECKBOX ::oDbf:lObsMnu ;
         ID       130 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      // Browse de odenes de comanda------------------------------------------

      ::oBrwOrdenesComanda                := IXBrowse():New( oDlg )

      ::oBrwOrdenesComanda:bClrSel        := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrwOrdenesComanda:bClrSelFocus   := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oDetOrdenesMenu:oDbfVir:SetBrowse( ::oBrwOrdenesComanda ) 

      ::oBrwOrdenesComanda:nMarqueeStyle  := 6
      ::oBrwOrdenesComanda:cName          := "Lineas de ordenes de comanda"
      ::oBrwOrdenesComanda:lFooter        := .t.

      ::oBrwOrdenesComanda:CreateFromResource( 400 )

      with object ( ::oBrwOrdenesComanda:AddCol() )
         :cHeader          := "Código orden comanda"
         :bStrData         := {|| ::oDetOrdenesMenu:oDbfVir:FieldGetByName( "cCodOrd" )  }
         :nWidth           := 60
      end with

      REDEFINE BUTTON ;
         ID       500 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::oDetOrdenesMenu:Append( ::oBrwOrdenesComanda ) )

      REDEFINE BUTTON ;
         ID       501 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::oDetOrdenesMenu:Del( ::oBrwOrdenesComanda ) )

      /*
      Creamos los botones------------------------------------------------------
      */

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( ::lSaveResource( nMode, oDlg ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
			ACTION 	( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| ::lSaveResource( nMode, oDlg ) } )

   oDlg:bStart          := {|| ::StartResource() }

	ACTIVATE DIALOG oDlg	CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Method lSaveResource( nMode, oDlg )

   local aGrp

   if ( nMode == APPD_MODE .or. nMode == DUPL_MODE )

      if Empty( ::oDbf:cCodMnu )
         MsgStop( "Código de menú no puede estar vacío" )
         ::oGetCodigo:SetFocus()
         Return nil
      end if

      if ::oDbf:SeekInOrd( ::oDbf:cCodMnu, "cCodMnu" )
         msgStop( "Código existente" )
         ::oGetCodigo:SetFocus()
         Return nil
      end if

   end if

   if Empty( ::oDbf:cNomMnu )
      MsgStop( "Nombre de menú no puede estar vacío" )
      ::oGetNombre:SetFocus()
      Return nil
   end if

Return oDlg:end( IDOK )

//---------------------------------------------------------------------------//

