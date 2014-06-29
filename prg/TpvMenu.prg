#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//----------------------------------------------------------------------------//

CLASS TpvMenu FROM TMasDet

   CLASSDATA oInstance

   DATA  cMru                                   INIT "clipboard_empty_16"

   DATA  oGetCodigo
   DATA  oGetNombre

   DATA oOrdenComandas  

   DATA oDbfArticulo

   DATA oDetMenuArticulo
   DATA oMenuOrdenes

   DATA oBrwOrdenesComanda

   DATA oSender

   METHOD New( cPath, oWndParent, oMenuItem )   CONSTRUCTOR
   METHOD Create( cPath )                       CONSTRUCTOR

   METHOD DefineFiles()

   METHOD OpenFiles( lExclusive, cPath )  

   METHOD CloseFiles( lExclusive, cPath ) 

   METHOD OpenService( lExclusive, cPath )
   METHOD CloseService( lExclusive,cPath )  

   METHOD Resource( nMode )
   METHOD   StartResource()                     VIRTUAL
   METHOD   lSaveResource()

   METHOD lIsMenuActive()
   METHOD nMenuActive()
   METHOD cMenuActive()

   METHOD cNombre( cCodMnu )
   METHOD nPrecio( cCodMnu )

   // Menu Acompañamiento-----------------------------------------------------//
   METHOD InitAcompannamiento()

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

   ::oMenuOrdenes       := TpvMenuOrdenes():New( cPath, Self )
   ::AddDetail( ::oMenuOrdenes )

   ::oDetMenuArticulo   := TpvMenuArticulo():New( cPath, Self )
   ::AddDetail( ::oDetMenuArticulo )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Create( cPath, oSender )

   DEFAULT cPath        := cPatEmp()

   ::cPath              := cPath
   ::oSender            := oSender

   ::oDbf               := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   local oDbf 

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE DATABASE oDbf FILE "TpvMenus.Dbf" CLASS "TpvMenus" ALIAS "TpvMenus" PATH ( cPath ) VIA ( cDriver ) COMMENT "Menús TPV" 

      FIELD NAME "cCodMnu"  TYPE "C" LEN  3  DEC 0  COMMENT "Código"                                                    COLSIZE 80                 OF oDbf
      FIELD NAME "cNomMnu"  TYPE "C" LEN 40  DEC 0  COMMENT "Nombre"                                                    COLSIZE 200                OF oDbf
      FIELD NAME "nImpMnu"  TYPE "N" LEN 16  DEC 6  COMMENT "Precio"                ALIGN RIGHT   PICTURE cPorDiv()     COLSIZE 80                 OF oDbf
      FIELD NAME "lObsMnu"  TYPE "L" LEN 1   DEC 0  COMMENT "Obsoleto"                                                  HIDE                       OF oDbf
      FIELD NAME "lAcomp"   TYPE "L" LEN 1   DEC 0  COMMENT "Menú acompañamiento"                                       HIDE                       OF oDbf

      INDEX TO "TpvMenus.Cdx" TAG "cCodMnu" ON "cCodMnu"   COMMENT "Código"         NODELETED                                                      OF oDbf
      INDEX TO "TpvMenus.Cdx" TAG "cNomMnu" ON "cNomMnu"   COMMENT "Nombre"         NODELETED                                                      OF oDbf
      INDEX TO "TpvMenus.Cdx" TAG "lObsMnu" ON "cCodMnu"   COMMENT ""               FOR "!Deleted() .and. !Field->lObsMnu"                         OF oDbf
      INDEX TO "TpvMenus.Cdx" TAG "lAcomp"  ON "cCodMnu"   COMMENT ""               FOR "!Deleted() .and. !Field->lAcomp"                          OF oDbf
      INDEX TO "TpvMenus.Cdx" TAG "lShwMnu" ON "cCodMnu"   COMMENT ""               FOR "!Deleted() .and. !Field->lAcomp .and. !Field->lObsMnu"    OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

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

      DATABASE NEW ::oDbfArticulo PATH ( cPatArt() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

      ::oOrdenComandas:OpenFiles()

      ::OpenDetails()

      ::bFirstKey          := {|| ::oDbf:cCodMnu }  

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir las bases de datos de TPV Menús." )

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

   if !empty( ::oOrdenComandas )
      ::oOrdenComandas:CloseFiles()
   end if 

   if !Empty( ::oDbfArticulo ) .and. ( ::oDbfArticulo:used() )
      ::oDbfArticulo:End()
   end if 

   ::CloseDetails()     

   ::oDbf      := nil

RETURN .t.

//----------------------------------------------------------------------------//

METHOD OpenService( lExclusive, cPath )

   local lOpen          := .t.
   local oError
   local oBlock         

   DEFAULT lExclusive   := .f.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf         := ::DefineFiles()
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

      ::oDetMenuArticulo   := TpvMenuArticulo():New( cPath, Self )

      if !::oDetMenuArticulo:OpenService()
         lOpen             := .f.
      end if

   RECOVER USING oError

      lOpen             := .f.

      ::CloseService()

      msgStop( ErrorMessage( oError ), "Imposible abrir las bases de datos de TpvMenus" )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseService()

   if !Empty( ::oDbf ) .and. ::oDbf:Used()
      ::oDbf:End()
   end if

   if !Empty( ::oDetMenuArticulo )
      ::oDetMenuArticulo:CloseService()
      ::oDetMenuArticulo:End()
   end if



RETURN ( .t. )

//---------------------------------------------------------------------------//

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

      REDEFINE CHECKBOX ::oDbf:lAcomp ;
         ID       140 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      // Browse de odenes de comanda------------------------------------------

      ::oBrwOrdenesComanda                := IXBrowse():New( oDlg )

      ::oBrwOrdenesComanda:bClrSel        := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrwOrdenesComanda:bClrSelFocus   := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oMenuOrdenes:oDbfVir:SetBrowse( ::oBrwOrdenesComanda ) 

      ::oBrwOrdenesComanda:nMarqueeStyle  := 6
      ::oBrwOrdenesComanda:cName          := "Lineas de ordenes de comanda"
      ::oBrwOrdenesComanda:lFooter        := .f.

      ::oBrwOrdenesComanda:bLDblClick     := {|| ::oMenuOrdenes:Edit( ::oBrwOrdenesComanda ) }

      ::oBrwOrdenesComanda:CreateFromResource( 400 )

      with object ( ::oBrwOrdenesComanda:AddCol() )
         :cHeader          := "Código"
         :bStrData         := {|| ::oMenuOrdenes:oDbfVir:FieldGetByName( "cCodOrd" ) }
         :nWidth           := 50
      end with

      with object ( ::oBrwOrdenesComanda:AddCol() )
         :cHeader          := "Orden de comanda"
         :bStrData         := {|| ::oOrdenComandas:cNombre( ::oMenuOrdenes:oDbfVir:FieldGetByName( "cCodOrd" ) ) } 
         :nWidth           := 200
      end with

      with object ( ::oBrwOrdenesComanda:AddCol() )
         :cHeader          := "Intercambiable"
         :bStrData         := {|| ::oMenuOrdenes:Intercambiable( ::oMenuOrdenes:oDbfVir:FieldGetByName( "lIntOrd" ) ) }
         :nWidth           := 100
      end with

      REDEFINE BUTTON ;
         ID       500 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::oMenuOrdenes:Append( ::oBrwOrdenesComanda ) )

      REDEFINE BUTTON ;
         ID       501 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::oMenuOrdenes:Edit( ::oBrwOrdenesComanda ) )

      REDEFINE BUTTON ;
         ID       502 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::oMenuOrdenes:Del( ::oBrwOrdenesComanda ) )

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

   oDlg:AddFastKey( VK_F2, {|| ::oMenuOrdenes:Append( ::oBrwOrdenesComanda ) } )
   oDlg:AddFastKey( VK_F3, {|| ::oMenuOrdenes:Edit( ::oBrwOrdenesComanda ) } )
   oDlg:AddFastKey( VK_F4, {|| ::oMenuOrdenes:Del( ::oBrwOrdenesComanda ) } )
   oDlg:AddFastKey( VK_F5, {|| ::lSaveResource( nMode, oDlg ) } )

   oDlg:bStart    := {|| ::StartResource() }

	ACTIVATE DIALOG oDlg	CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Method lSaveResource( nMode, oDlg )

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

   if ::oMenuOrdenes:nIntercambiables( ::oMenuOrdenes:oDbfVir:cCodMnu, ::oMenuOrdenes:oDbfVir ) == 1
      MsgStop( "Tiene que haber más de un orden intercambiable o ninguno." )
      Return ( .f. )
   end if

   // ::SaveDetails()

Return ( oDlg:end( IDOK ) )

//---------------------------------------------------------------------------//

METHOD lIsMenuActive()

Return ( ::nMenuActive() > 0 )

//---------------------------------------------------------------------------//

METHOD nMenuActive()

   local nMenuActive := 0

   ::oDbf:getStatus()
   ::oDbf:ordsetfocus( "lShwMnu" )

   nMenuActive       := ::oDbf:ordKeyCount()

   ::oDbf:setStatus()

Return ( nMenuActive )

//---------------------------------------------------------------------------//

METHOD cMenuActive()

   local cMenuActive := ""

   ::oDbf:getStatus()
   ::oDbf:ordSetfocus( "lShwMnu" )
   ::oDbf:goTop()
   
   cMenuActive       := ::oDbf:cCodMnu

   ::oDbf:setStatus()

Return ( cMenuActive )

//---------------------------------------------------------------------------//

METHOD cNombre( cCodMnu )

   local cNombre        := ""

   ::oDbf:GetStatus()

   if ::oDbf:SeekInOrd( cCodMnu, "cCodMnu" )
      cNombre           := ::oDbf:cNomMnu
   end if

   ::oDbf:SetStatus()

RETURN ( cNombre )

//---------------------------------------------------------------------------//

METHOD nPrecio( cCodMnu )

   local nPrecio        := 0

   ::oDbf:GetStatus()

   if ::oDbf:SeekInOrd( cCodMnu, "cCodMnu" )
      nPrecio           := ::oDbf:nImpMnu
   end if

   ::oDbf:SetStatus()

RETURN ( nPrecio )

//---------------------------------------------------------------------------//

METHOD InitAcompannamiento( cCodigoMenu )

   local oBrwAcompannamiento
   local oDlgAcompannamiento
   local cCodigoArticulo
   

   ::oDetMenuArticulo:oDbf:SetFilter( "Field->cCodMnu == '" +  cCodigoMenu + "'" )
   ::oDetMenuArticulo:oDbf:GoTop()

   // Definimos el dialogo para el menú de acompañamiento-----------------------

   DEFINE DIALOG oDlgAcompannamiento RESOURCE "TPVMenuAcomp"

      REDEFINE BUTTONBMP ;
         ID       110 ;
         OF       oDlgAcompannamiento ;
         BITMAP   "Navigate_up2" ;
         ACTION   ( oBrwAcompannamiento:Select( 0 ), oBrwAcompannamiento:PageUp(), oBrwAcompannamiento:Select( 1 ) )

      REDEFINE BUTTONBMP ;
         ID       111 ;
         OF       oDlgAcompannamiento ;
         BITMAP   "Navigate_down2" ;
         ACTION   ( oBrwAcompannamiento:Select( 0 ), oBrwAcompannamiento:PageDown(), oBrwAcompannamiento:Select( 1 ) )

      REDEFINE BUTTONBMP ;
         BITMAP   "Check_32" ;
         ID       IDOK ;
         OF       oDlgAcompannamiento ;
         ACTION   ( oDlgAcompannamiento:End( IDOK ) )

      REDEFINE BUTTONBMP ;
         BITMAP   "Delete_32" ;
         ID       IDCANCEL ;
         OF       oDlgAcompannamiento ;
         ACTION   ( oDlgAcompannamiento:End() )

      oBrwAcompannamiento                  := IXBrowse():New( oDlgAcompannamiento )

      oBrwAcompannamiento:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwAcompannamiento:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }
      oBrwAcompannamiento:nMarqueeStyle    := 3
      oBrwAcompannamiento:cName            := "Acompañamiento de artículo"
      oBrwAcompannamiento:lHeader          := .f.
      oBrwAcompannamiento:lHScroll         := .f.
      oBrwAcompannamiento:nRowHeight       := 50
      
      oBrwAcompannamiento:CreateFromResource( 100 )

      oBrwAcompannamiento:SetFont( ::oSender:oFntBrw )

      ::oDetMenuArticulo:oDbf:SetBrowse( oBrwAcompannamiento )

      with object ( oBrwAcompannamiento:AddCol() )
         :bEditValue                         := {|| Alltrim( oRetFld( ::oDetMenuArticulo:oDbf:cCodArt, ::oSender:oArticulo )) }
      end with

      oDlgAcompannamiento:bStart             := {|| ::oSender:SeleccionarDefecto( oBrwAcompannamiento ) }

   ACTIVATE DIALOG oDlgAcompannamiento CENTER

   if oDlgAcompannamiento:nResult ==IDOK
      cCodigoArticulo         := ::oDetMenuArticulo:oDbf:cCodArt
   else 
      cCodigoArticulo         := nil
   end if

   ::oDetMenuArticulo:oDbf:SetFilter()

   ::oSender:oBrwLineas:Refresh()

Return ( cCodigoArticulo )

//---------------------------------------------------------------------------//

/*
METHOD SaveDetails()

   msgAlert( ::oDbf:cCodMnu, "::oDbf:cCodMnu" )

   while !::oDetMenuArticulo:oDbfVir:eof()
      ::oDetMenuArticulo:oDbfVir:cCodMnu     := ::oDbf:cCodMnu
      ::oDetMenuArticulo:oDbfVir:skip()
   end while

   while !::oDetMenuOrdenes:oDbfVir:eof()
      ::oDetMenuOrdenes:oDbfVir:cCodMnu      := ::oDbf:cCodMnu
      ::oDetMenuOrdenes:oDbfVir:skip()
   end while

RETURN ( Self )
*/
//--------------------------------------------------------------------------//
