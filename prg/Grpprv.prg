#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//----------------------------------------------------------------------------//

CLASS TGrpPrv FROM TMant

   DATA  cName          INIT "GruposProveedores"

   DATA  cMru           INIT "gc_businessmen2_16"

   DATA  cParentSelect  INIT Space( 4 )

   DATA  oGetCodigo
   DATA  oGetNombre

   DATA  oTreePadre

   METHOD New( cPath, oWndParent, oMenuItem )   CONSTRUCTOR
   METHOD Create( cPath )                       CONSTRUCTOR

   METHOD OpenFiles( lExclusive )
   
   METHOD DefineFiles()

   METHOD Resource( nMode )
   METHOD lSaveResource()
   METHOD StartResource( oGet )

   METHOD aChild( cCodGrupo )
   METHOD IsPadreMayor( cCodGrupo, cCodDesde )
   METHOD IsPadreMenor( cCodGrupo, cCodDesde )

   METHOD Tree( oGet )

   METHOD LoadTree( cCodGrupo )
   METHOD ChangeTreeState( oTree, aItems )
   METHOD GetTreeState( oTree, aItems )
   METHOD SetTreeState( oTree, aItems )

END CLASS

//----------------------------------------------------------------------------//

METHOD New( cPath, oWndParent, oMenuItem )

   DEFAULT cPath        := cPatEmp()
   DEFAULT oWndParent   := GetWndFrame()
   DEFAULT oMenuItem    := "01030"

   if Empty( ::nLevel )
      ::nLevel          := Auth():Level( oMenuItem )
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
   ::cHtmlHelp          := "Grupos de proveedores"

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Create( cPath )

   DEFAULT cPath        := cPatEmp()

   ::cPath              := cPath
   ::oDbf               := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive, cPath )

   local lOpen          := .t.
   local oError
   local oBlock

   DEFAULT lExclusive   := .f.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

   RECOVER USING oError

      lOpen             := .f.
      
      ::CloseFiles()
      
      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos de grupos de proveedores" )

   END SEQUENCE
   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE DATABASE ::oDbf FILE "GrpPrv.DBF" CLASS "GrpPrv" ALIAS "GrpPrv" PATH ( cPath ) VIA ( cDriver ) COMMENT "Grupos de proveedores"

      FIELD NAME "CCODGRP"    TYPE "C" LEN  4  DEC 0  COMMENT "Código"              COLSIZE 80  OF ::oDbf
      FIELD NAME "CNOMGRP"    TYPE "C" LEN 30  DEC 0  COMMENT "Nombre"              COLSIZE 200 OF ::oDbf
      FIELD NAME "CCODPDR"    TYPE "C" LEN  4  DEC 0  COMMENT "Grupo padre"         COLSIZE 80  OF ::oDbf

      INDEX TO "GrpPrv.CDX" TAG "CCODGRP" ON "CCODGRP"   COMMENT "Código"           NODELETED   OF ::oDbf
      INDEX TO "GrpPrv.CDX" TAG "CNOMGRP" ON "CNOMGRP"   COMMENT "Nombre"           NODELETED   OF ::oDbf
      INDEX TO "GrpPrv.CDX" TAG "CCODPDR" ON "CCODPDR"   COMMENT "Grupo padre"      NODELETED   OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//----------------------------------------------------------------------------//

METHOD Resource( nMode )

   local oDlg
   local oFld

   DEFINE DIALOG oDlg RESOURCE "GRPCLI" TITLE LblTitle( nMode ) + "Grupos de proveedores"

      REDEFINE FOLDER oFld ;
         ID          500 ;
         OF          oDlg ;
         PROMPT      "&General" ;
         DIALOGS     "GRPCLI_01"

      REDEFINE GET   ::oGetCodigo ;
         VAR         ::oDbf:cCodGrp ;
         ID          100 ;
         WHEN        ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) ;
         VALID       NotValid( ::oGetCodigo, ::oDbf:cAlias, .t., "0" ) ;
         PICTURE     "@!" ;
         OF          oFld:aDialogs[ 1 ]


      REDEFINE GET   ::oGetNombre ;
         VAR         ::oDbf:cNomGrp ;
         ID          110 ;
         WHEN        ( nMode != ZOOM_MODE ) ;
         OF          oFld:aDialogs[ 1 ]

      ::oTreePadre                     := TTreeView():Redefine( 130, oFld:aDialogs[ 1 ] )
      ::oTreePadre:bItemSelectChanged  := {|| ::ChangeTreeState() }

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::lSaveResource( nMode, oDlg ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| ::lSaveResource( nMode, oDlg ) } )

   oDlg:bStart          := {|| ::StartResource() }

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Method lSaveResource( nMode, oDlg )

   local aGrp

   ::oDbf:cCodPdr    := Space( 4 )

   if ( nMode == APPD_MODE .or. nMode == DUPL_MODE )

      if Empty( ::oDbf:cCodGrp )
         MsgStop( "Código de grupo de proveedores no puede estar vacío" )
         ::oGetCodigo:SetFocus()
         Return nil
      end if

      if ::oDbf:SeekInOrd( ::oDbf:cCodGrp, "cCodGrp" )
         msgStop( "Código existente" )
         ::oGetCodigo:SetFocus()
         Return nil
      end if

   end if

   if Empty( ::oDbf:cNomGrp )
      MsgStop( "Nombre de grupo de proveedores no puede estar vacío" )
      ::oGetNombre:SetFocus()
      Return nil
   end if

   ::GetTreeState( ::oTreePadre )

   if ( ::oDbf:cCodGrp == ::oDbf:cCodPdr )
      MsgStop( "Grupo padre no puede ser el mismo" )
      ::oTreePadre:SetFocus()
      Return nil
   end if

   aGrp  := ::aChild( ::oDbf:cCodGrp )
   if aScan( aGrp, ::oDbf:cCodPdr ) != 0
      MsgStop( "Grupo padre contiene referencia circular" )
      ::oTreePadre:SetFocus()
      Return nil
   end if

Return oDlg:end( IDOK ) 

//---------------------------------------------------------------------------//

METHOD StartResource()

   ::LoadTree()

   ::SetTreeState()

   ::oGetCodigo:SetFocus()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD aChild( cCodGrupo, aChild )

   local nRec
   local nOrd

   if Empty( aChild )
      aChild   := {}
   end if

   CursorWait()

   nRec        := ( ::oDbf:cAlias )->( Recno() )
   nOrd        := ( ::oDbf:cAlias )->( OrdSetFocus( "cCodPdr" ) )

   if ( ::oDbf:cAlias )->( dbSeek( cCodGrupo ) )

      while ( ( ::oDbf:cAlias )->cCodPdr == cCodGrupo .and. !( ::oDbf:cAlias )->( Eof() ) )

         aAdd( aChild, ( ::oDbf:cAlias )->cCodGrp )

         ::aChild( ( ::oDbf:cAlias )->cCodGrp, aChild )

         ( ::oDbf:cAlias )->( dbSkip() )

      end while

   end if

   ( ::oDbf:cAlias )->( OrdSetFocus( nOrd ) )
   ( ::oDbf:cAlias )->( dbGoTo( nRec ) )

   CursorWE()

Return ( aChild )

//---------------------------------------------------------------------------//

METHOD IsPadreMayor( cCodGrupo, cCodDesde )

   local cPadre
   local aPadre

   if cCodGrupo >= cCodDesde
      Return .t.
   end if

   if !Empty( cCodGrupo )

      aPadre         := ::aChild( cCodGrupo )

      for each cPadre in aPadre
         if cPadre >= cCodDesde
            Return .t.
         end if
      next

   end if

Return ( .f. )

//---------------------------------------------------------------------------//

METHOD IsPadreMenor( cCodGrupo, cCodHasta )

   local cPadre
   local aPadre

   if cCodGrupo <= cCodHasta
      Return .t.
   end if

   if !Empty( cCodGrupo )

      aPadre         := ::aChild( cCodGrupo )

      for each cPadre in aPadre
         if cPadre <= cCodHasta
            Return .t.
         end if
      next

   end if

Return ( .f. )

//---------------------------------------------------------------------------//

METHOD LoadTree( oTree, cCodGrupo )

   local nRec
   local nOrd
   local oNode

   DEFAULT oTree     := ::oTreePadre

   if Empty( cCodGrupo )
      cCodGrupo      := Space( 4 )
   end if

   CursorWait()

   nRec              := ( ::oDbf:cAlias )->( Recno() )
   nOrd              := ( ::oDbf:cAlias )->( OrdSetFocus( "cCodPdr" ) )

   if ( ::oDbf:cAlias )->( dbSeek( cCodGrupo ) )

      while ( ( ::oDbf:cAlias )->cCodPdr == cCodGrupo .and. !( ::oDbf:cAlias )->( Eof() ) )

         oNode       := oTree:Add( Alltrim( ( ::oDbf:cAlias )->cNomGrp ) )
         oNode:Cargo := ( ::oDbf:cAlias )->cCodGrp

         ::LoadTree( oNode, ( ::oDbf:cAlias )->cCodGrp )

         ( ::oDbf:cAlias )->( dbSkip() )

      end while

   end if

   ( ::oDbf:cAlias )->( OrdSetFocus( nOrd ) )
   ( ::oDbf:cAlias )->( dbGoTo( nRec ) )

   CursorWE()

   oTree:Expand()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD ChangeTreeState( oTree, aItems )

   local oItem

   DEFAULT oTree  := ::oTreePadre

   if Empty( aItems )
      aItems      := oTree:aItems
   end if

   for each oItem in aItems

      SysRefresh()

      // tvSetCheckState( oTree:hWnd, oItem:hItem, .f. )

      oTree:SetCheck( oItem, .f. )

      if len( oItem:aItems ) > 0
         ::ChangeTreeState( oTree, oItem:aItems )
      end if

   next

Return ( Self )

//------------------------------------------------------------------------//

METHOD GetTreeState( oTree, aItems )

   local oItem

   DEFAULT oTree  := ::oTreePadre

   if Empty( aItems )
      aItems      := oTree:aItems
   end if

   for each oItem in aItems

      // if tvGetCheckState( oTree:hWnd, oItem:hItem )
      if oTree:GetCheck( oItem )      
         ::oDbf:cCodPdr    := oItem:Cargo
      end if

      if len( oItem:aItems ) > 0
         ::GetTreeState( oTree, oItem:aItems )
      end if

   next

Return ( Self )

//------------------------------------------------------------------------//

METHOD SetTreeState( oTree, aItems )

   local oItem

   DEFAULT oTree  := ::oTreePadre

   if Empty( aItems )
      aItems      := oTree:aItems
   end if

   for each oItem in aItems

      if ( ::oDbf:cCodPdr == oItem:Cargo )

         // MsgWait( "", "", .0001 )

         oTree:Select( oItem )

         // tvSetCheckState( oTree:hWnd, oItem:hItem, .t. )

         oTree:SetCheck( oItem, .t. )

      end if

      if len( oItem:aItems ) > 0
         ::SetTreeState( oTree, oItem:aItems )
      end if

   next

Return ( Self )

//------------------------------------------------------------------------//

METHOD Tree( oGet )

   local oDlg
   local uVal
   local oTree

   uVal                    := oGet:VarGet()

   /*
   Creamos el dialogo----------------------------------------------------------
   */

   oDlg                    := TDialog():New( , , , , "cDlgName", "TreeGruposCliente" )

   oTree                   := TTreeView():Redefine( 100, oDlg  )

   TButton():ReDefine( IDOK, {|| oDlg:end( IDOK ) }, oDlg, , , .f. )

   TButton():ReDefine( IDCANCEL, {|| oDlg:end() }, oDlg, , , .f. )

   oDlg:bStart             := {|| ::StartTree( nil, oTree ) }

   oDlg:AddFastKey( VK_F5, {|| oDlg:end( IDOK ) } )

   oDlg:Activate( , , , .t. )

   /*
   Resultados------------------------------------------------------------------
   */

   if oDlg:nResult == IDOK
      msgStop( "valor" )
   end if

RETURN ( uVal )

//----------------------------------------------------------------------------//

function cGruPrv( cCodPrv, oDbfPrv )

   local cCodGrP  := ""

   if oDbfPrv:Seek( cCodPrv )
      cCodGrP := oDbfPrv:cCodGrp
   end if

return( cCodGrP )

//---------------------------------------------------------------------------//

function cNomGrp( cCodGrc, oDbfGprPrv )

   local cNomGrP  := ""

   if oDbfGprPrv:Seek( cCodGrC )
      cNomGrP := oDbfGprPrv:cNomGrp
   end if

return( cNomGrP )

//---------------------------------------------------------------------------//

