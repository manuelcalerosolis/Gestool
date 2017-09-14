#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//----------------------------------------------------------------------------//

CLASS TGrpCli FROM TMasDet

   DATA  cName                                           INIT "GruposClientes"

   DATA  cMru                                            INIT "gc_users3_16"

   DATA  cParentSelect                                   INIT Space( 4 )

   DATA  oGetCodigo
   DATA  oGetNombre

   DATA  oTreePadre

   DATA  oEnvases
   DATA  oDetCamposExtra

   DATA  oMenu

   METHOD New( cPath, cDriver, oWndParent, oMenuItem )   CONSTRUCTOR
   METHOD Create( cPath, cDriver )                       CONSTRUCTOR

   METHOD View()                                         INLINE ( ::nView )

   METHOD OpenFiles( lExclusive )
   METHOD CloseFiles()                          

   METHOD OpenService( lExclusive, cPath )               INLINE ( ::Super:OpenService() )
   METHOD CloseService()                                 INLINE ( ::Super:CloseService() )

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

   METHOD nombreGrupo( cCodigoGrupo )

   METHOD EdtRotorMenu( oDlg )

END CLASS

//----------------------------------------------------------------------------//

METHOD New( cPath, cDriver, oWndParent, oMenuItem )

   DEFAULT cPath        := cPatCli()
   DEFAULT cDriver      := cDriver()
   DEFAULT oWndParent   := GetWndFrame()
   DEFAULT oMenuItem    := "01030"

   if Empty( ::nLevel )
      ::nLevel          := nLevelUsr( oMenuItem )
   end if

   /*
   Cerramos todas las ventanas
   */

   if oWndParent != nil
      oWndParent:CloseAll()
   end if

   ::cPath              := cPath
   ::cDriver            := cDriver
   ::oWndParent         := oWndParent
   ::oDbf               := nil

   ::lCreateShell       := .f.
   ::cHtmlHelp          := "Grupos de clientes"

   ::bFirstKey          := {|| ::oDbf:cCodGrp }

   ::AddDetail( TAtipicas():NewInstance( ::cPath, , Self ) )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Create( cPath, cDriver )

   DEFAULT cPath        := cPatCli()
   DEFAULT cDriver      := cDriver()

   ::cPath              := cPath
   ::cDriver            := cDriver
   ::oDbf               := nil

   ::bFirstKey          := {|| ::oDbf:cCodGrp }

   ::AddDetail( TAtipicas():GetInstance( ::cPath, , Self ) )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive, cPath )

   local lOpen          := .t.
   local oError
   local oBlock

   DEFAULT lExclusive   := .f.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::nView           := D():CreateView()

      if !::Super:OpenFiles()
         lOpen          := .f.
      end if 

      if !TAtipicas():GetInstance():OpenFiles()
         lOpen             := .f.
      else 
         TAtipicas():GetInstance():oDbf:OrdSetFocus( "cCodGrp" ) 
      end if
      
      D():Get( "Articulo", ::nView )

      D():Get( "Familias", ::nView )

      D():Get( "Artkit", ::nView )

      D():Get( "Artdiv", ::nView )

      ::oEnvases           := TFrasesPublicitarias():Create( cPatArt() )
      if !::oEnvases:OpenFiles()
         lOpen             := .f.
      end if

      ::oDetCamposExtra    := TDetCamposExtra():New()
      if !::oDetCamposExtra:OpenFiles
         lOpen             := .f.
      end if

      ::oDetCamposExtra:SetTipoDocumento( "Grupos de clientes" )
      //::oDetCamposExtra:setbId( {|| ::oDbf:cCodGrp } )

   RECOVER USING oError

      MsgStop( ErrorMessage( oError ), 'Imposible abrir ficheros de grupos de clientes' )

      lOpen             := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpen
      ::CloseFiles()
   end if

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD CloseFiles()

   ::Super:CloseFiles()

   TAtipicas():GetInstance():CloseFiles()
   TAtipicas():EndInstance()

   if !Empty( ::oEnvases )
      ::oEnvases:end()
      ::oEnvases  := nil
   end if

   if !empty( ::nView )

      D():DeleteView( ::nView )
      ::nView     := nil
      
   end if   

RETURN ( .t. )

//----------------------------------------------------------------------------//
/*
METHOD End()
   
   ::CloseFiles()
   
   TAtipicas():EndInstance()

RETURN ( .t. )   
*/
//----------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   local oDbf 

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE DATABASE oDbf FILE "GRPCLI.DBF" CLASS "GRPCLI" ALIAS "GRPCLI" PATH ( cPath ) VIA ( cDriver ) COMMENT "Grupos de clientes"

      FIELD NAME "CCODGRP"    TYPE "C" LEN   4  DEC 0  COMMENT "Código"              COLSIZE 80  OF oDbf
      FIELD NAME "CNOMGRP"    TYPE "C" LEN 200  DEC 0  COMMENT "Nombre"              COLSIZE 200 OF oDbf
      FIELD NAME "CCODPDR"    TYPE "C" LEN   4  DEC 0  COMMENT "Grupo padre"         COLSIZE 80  OF oDbf

      INDEX TO "GRPCLI.CDX" TAG "CCODGRP" ON "CCODGRP"   COMMENT "Código"           NODELETED   OF oDbf
      INDEX TO "GRPCLI.CDX" TAG "CNOMGRP" ON "CNOMGRP"   COMMENT "Nombre"           NODELETED   OF oDbf
      INDEX TO "GRPCLI.CDX" TAG "CCODPDR" ON "CCODPDR"   COMMENT "Grupo padre"      NODELETED   OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//----------------------------------------------------------------------------//

METHOD Resource( nMode )

	local oDlg
   local oFld
   local oBmpGeneral
   local oBmpTarifa

   ::oDetCamposExtra:SetTemporal( ::oDbf:cCodGrp, "", nMode )

   DEFINE DIALOG     oDlg ;
      RESOURCE       "GRPCLI" ;
      TITLE          LblTitle( nMode ) + "Grupos de clientes"

      REDEFINE FOLDER oFld ;
         ID          500 ;
         OF          oDlg ;
         PROMPT      "&General",;
                     "&Tarifas" ;
         DIALOGS     "GRPCLI_01" ,;
                     "GRPCLI_02"

      REDEFINE BITMAP oBmpGeneral ;
         ID          600 ;
         RESOURCE    "gc_users3_48" ;
         TRANSPARENT ;
         OF          oFld:aDialogs[ 1 ]

      REDEFINE GET   ::oGetCodigo ;
         VAR         ::oDbf:cCodGrp ;
			ID          100 ;
         WHEN        ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) ;
         VALID       NotValid( ::oGetCodigo, ::oDbf:cAlias, .t., "0" ) ;
			PICTURE 	   "@!" ;
			OF          oFld:aDialogs[ 1 ]

      REDEFINE GET   ::oGetNombre ;
         VAR         ::oDbf:cNomGrp ;
			ID          110 ;
         WHEN        ( nMode != ZOOM_MODE ) ;
			OF          oFld:aDialogs[ 1 ]

      ::oTreePadre                     := TTreeView():Redefine( 130, oFld:aDialogs[ 1 ] )
      ::oTreePadre:bItemSelectChanged  := {|| ::ChangeTreeState() }

      /*
      Browse para atipicas-----------------------------------------------------
      */

      REDEFINE BITMAP oBmpTarifa ;
         ID          600 ;
         RESOURCE    "gc_symbol_euro_48" ;
         TRANSPARENT ;
         OF          oFld:aDialogs[ 2 ]

      TAtipicas():GetInstance():ButtonAppend( 110, oFld:aDialogs[ 2 ] )

      TAtipicas():GetInstance():ButtonEdit( 120, oFld:aDialogs[ 2 ] )

      TAtipicas():GetInstance():ButtonDel( 130, oFld:aDialogs[ 2 ] )

      TAtipicas():GetInstance():Browse( 100, oFld:aDialogs[ 2 ] )

      /*
      Botones generales--------------------------------------------------------
      */

      REDEFINE BUTTON ;
         ID          IDOK ;
			OF          oDlg ;
			WHEN        ( nMode != ZOOM_MODE ) ;
         ACTION      ( ::lSaveResource( nMode, oDlg ) )

		REDEFINE BUTTON ;
         ID          IDCANCEL ; 
			OF          oDlg ;
         CANCEL ;
			ACTION      ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| ::lSaveResource( nMode, oDlg ) } )
   oDlg:AddFastKey( VK_F9, {|| ::oDetCamposExtra:Play( Space(1) ) } )

   oDlg:bStart       := {|| ::StartResource(), ::EdtRotorMenu( oDlg ) }

	ACTIVATE DIALOG oDlg CENTER

   if !Empty( ::oMenu )
      ::oMenu:End()
   end if

   if !Empty( oBmpTarifa )
      oBmpTarifa:End()
   end if

   if !Empty( oBmpGeneral )
      oBmpGeneral:End()
   end if

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

METHOD EdtRotorMenu( oDlg )

   MENU ::oMenu

      MENUITEM       "&1. Rotor"

      MENU

         MENUITEM    "&1. Campos extra [F9]";
            MESSAGE  "Mostramos y rellenamos los campos extra para el grupo cliente" ;
            RESOURCE "gc_form_plus2_16" ;
            ACTION   ( ::oDetCamposExtra:Play( Space(1) ) )

      ENDMENU

   ENDMENU

   oDlg:SetMenu( ::oMenu )

Return ( ::oMenu )

//---------------------------------------------------------------------------//

Method lSaveResource( nMode, oDlg )

   local aGrp

   ::oDbf:cCodPdr    := Space( 4 )

   if ( nMode == APPD_MODE .or. nMode == DUPL_MODE )

      if Empty( ::oDbf:cCodGrp )
         MsgStop( "Código de grupo de clientes no puede estar vacío" )
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
      MsgStop( "Nombre de grupo de clientes no puede estar vacío" ) 
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

   ::oDetCamposExtra:saveExtraField( ::oDbf:cCodGrp, "" )

Return ( oDlg:end( IDOK ) )

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

      //tvSetCheckState( oTree:hWnd, oItem:hItem, .f. )
      
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

METHOD nombreGrupo( cCodigoGrupo )

   local nombreGrupo := ""

   if ::oDbf:seekinord( cCodigoGrupo, "cCodGrp" )
      nombreGrupo    := ::oDbf:cNomGrp
   end if

RETURN ( alltrim( nombreGrupo ) )

//---------------------------------------------------------------------------//

function cGruCli( cCodCli, oDbfCli )

   local cCodGrp  := ""

   if oDbfCli:Seek( cCodCli )
      cCodGrp     := oDbfCli:cCodGrp
   end if

return( cCodGrp )

//---------------------------------------------------------------------------//

