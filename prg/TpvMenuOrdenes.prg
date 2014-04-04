#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//--------------------------------------------------------------------------//

CLASS TpvMenuOrdenes FROM TDet

   DATA oBrwArticulosOrden

   DATA cScopeValue

   DATA oGetOrdenComanda

   METHOD DefineFiles()

   METHOD OpenFiles( lExclusive )

   METHOD CloseFiles()

   METHOD Resource( nMode, lLiteral )

   METHOD lPreSave()

   METHOD PreSaveDetails()

   METHOD PreEdit()
   METHOD PostEdit()

   METHOD PreDelete()

   METHOD ValidOrden( cGetOrd )

   METHOD StartResource()

END CLASS

//--------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cVia, lUniqueName, cFileName )

   local oDbf

   DEFAULT cPath        := ::cPath
   DEFAULT lUniqueName  := .f.
   DEFAULT cFileName    := "TpvMnuOrd"
   DEFAULT cVia         := cDriver()

   if lUniqueName
      cFileName         := cGetNewFileName( cFileName, , , cPath )
   end if

   DEFINE TABLE oDbf FILE ( cFileName ) CLASS ( cFileName ) ALIAS ( cFileName ) PATH ( cPath ) VIA ( cVia ) COMMENT "Ordenes menú"

      FIELD NAME "cCodMnu" TYPE "C" LEN 03  DEC 0 COMMENT "CÃ³digo menu"                    OF oDbf
      FIELD NAME "cCodOrd" TYPE "C" LEN 02  DEC 0 COMMENT "CÃ³digo orden"                   OF oDbf

      INDEX TO ( cFileName ) TAG "cCodMnu" ON "cCodMnu"                          NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "cCodOrd" ON "cCodOrd"                          NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "cMnuOrd" ON "cCodMnu + cCodOrd"                NODELETED OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//--------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive )

   local lOpen             := .t.
   local oError
   local oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT  lExclusive     := .f.

   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf            := ::DefineFiles()
      end if

      ::oDbf:Activate( .f., !lExclusive )

      ::bOnPreSaveDetail   := {|| ::PreSaveDetails() }
      
      ::bOnPreAppend       := {|| ::PreEdit() }
      ::bOnPreEdit         := {|| ::PreEdit() }

      ::bOnPostAppend      := {|| ::PostEdit() }
      ::bOnPostEdit        := {|| ::PostEdit() }

      ::bOnPreDelete       := {|| ::PreDelete() }

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos" )

      ::CloseFiles()

      lOpen             := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//--------------------------------------------------------------------------//

METHOD CloseFiles()

   if !empty( ::oDbf ) .and. ::oDbf:Used()
      ::oDbf:End()
      ::oDbf            := nil
   end if

RETURN .t.

//--------------------------------------------------------------------------//

METHOD PreEdit()

   ::cScopeValue        := ::oDbfVir:cCodOrd

   ::oParent:oDetMenuArticulo:oDbfVir:OrdSetFocus( "cCodOrd" )
   ::oParent:oDetMenuArticulo:oDbfVir:SetScope( ::cScopeValue )
   ::oParent:oDetMenuArticulo:oDbfVir:GoTop()

RETURN .t.

//--------------------------------------------------------------------------//

METHOD PostEdit()

   ::oParent:oDetMenuArticulo:oDbfVir:ClearScope()
   ::oParent:oDetMenuArticulo:oDbfVir:OrdSetFocus( "cCodMnu" )

RETURN .t.

//--------------------------------------------------------------------------//

METHOD PreDelete()

   msgAlert( "voy a borrar " + ::oDbfVir:cCodOrd )
   while ( ::oParent:oDetMenuArticulo:oDbfVir:SeekInOrd( ::oDbfVir:cCodOrd, "cCodOrd" ) )
      ::oParent:oDetMenuArticulo:oDbfVir:Delete()
   end while 

RETURN .t.

//--------------------------------------------------------------------------//

METHOD ValidOrden()
   
   local lValid      := .t.

   if ::nMode == APPD_MODE

      if ::oParent:oOrdenComandas:Existe( ::oGetOrdenComanda, ::oGetOrdenComanda:oHelpText )

         ::oDbfVir:GetStatus()

         if ::oDbfVir:SeekInOrd( ::oGetOrdenComanda:varGet(), "cCodOrd" )
            lValid      := .f.
            msgStop( "El orden ya esta agregado" )
         end if

         ::oDbfVir:SetStatus()

      else

         lValid         := .f.

      end if

   end if

RETURN ( lValid )   

//--------------------------------------------------------------------------//


METHOD Resource()

   local oDlg

   // Caja de dialogo-------------------------------------------------------------

   DEFINE DIALOG oDlg RESOURCE "TpvMenuOrdenes" TITLE LblTitle( ::nMode ) + "orden de comanda"

      REDEFINE GET   ::oGetOrdenComanda ;
         VAR         ::oDbfVir:cCodOrd ;
         BITMAP      "Lupa" ;
         ID          100 ;
         IDTEXT      101 ;
         OF          oDlg

      ::oGetOrdenComanda:bWhen     := {|| ::nMode == APPD_MODE }
      ::oGetOrdenComanda:bValid    := {|| ::ValidOrden() }
      ::oGetOrdenComanda:bHelp     := {|| ::oParent:oOrdenComandas:Buscar( ::oGetOrdenComanda ) }

      // Browse de odenes de comanda------------------------------------------

      ::oBrwArticulosOrden                := IXBrowse():New( oDlg )

      ::oBrwArticulosOrden:bClrSel        := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrwArticulosOrden:bClrSelFocus   := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oParent:oDetMenuArticulo:oDbfVir:SetBrowse( ::oBrwArticulosOrden ) 

      ::oBrwArticulosOrden:nMarqueeStyle  := 6
      ::oBrwArticulosOrden:cName          := "Lineas de menus de articulos"
      ::oBrwArticulosOrden:lFooter        := .f.

      ::oBrwArticulosOrden:CreateFromResource( 400 )

      with object ( ::oBrwArticulosOrden:AddCol() )
         :cHeader          := "Código"
         :bStrData         := {|| ::oParent:oDetMenuArticulo:oDbfVir:cCodArt }
         :bStrData         := {|| ::oParent:oDetArticuloMenu:oDbfVir:cCodArt }
         :nWidth           := 100
      end with

      with object ( ::oBrwArticulosOrden:AddCol() )
         :cHeader          := "Artículo"
         :bStrData         := {|| retArticulo( ::oParent:oDetMenuArticulo:oDbfVir:cCodArt, ::oParent:oDbfArticulo:cAlias ) }
         :nWidth           := 240
      end with

      REDEFINE BUTTON ;
         ID       500 ;
         OF       oDlg ;
         WHEN     ( ::nMode != ZOOM_MODE ) ;
         ACTION   ( ::oParent:oDetMenuArticulo:Append( ::oBrwArticulosOrden ) )

      REDEFINE BUTTON ;
         ID       501 ;
         OF       oDlg ;
         WHEN     ( ::nMode != ZOOM_MODE ) ;
         ACTION   ( ::oParent:oDetMenuArticulo:Del( ::oBrwArticulosOrden ) )

      // Botones------------------------------------------------------------------

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         WHEN     ( ::nMode != ZOOM_MODE ) ;
         ACTION   ( ::lPreSave( oDlg ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         ACTION   ( oDlg:end() )

      if ::nMode != ZOOM_MODE
         oDlg:AddFastKey( VK_F2, {|| ::oParent:oDetMenuArticulo:Append( ::oBrwArticulosOrden ) } )
         oDlg:AddFastKey( VK_F4, {|| ::oParent:oDetMenuArticulo:Del( ::oBrwArticulosOrden ) } )
         oDlg:AddFastKey( VK_F5, {|| ::lPreSave( oDlg ) } )
      end if

      oDlg:bStart    := {|| ::StartResource() }

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//

METHOD StartResource()

   if ( ::nMode != APPD_MODE )
      ::oParent:oOrdenComandas:Existe( ::oGetOrdenComanda, ::oGetOrdenComanda:oHelpText )
   end if

RETURN (Self)

//--------------------------------------------------------------------------//

METHOD lPreSave( oDlg )

   if Empty( ::oDbfVir:cCodOrd )
      MsgStop( "Código del orden no puede estar vacio" )
      Return ( .f. )
   end if

   if !::oGetOrdenComanda:lValid()
      Return ( .f. )
   end if 

   ::oParent:oDetMenuArticulo:oDbfVir:GoTop()
   while !::oParent:oDetMenuArticulo:oDbfVir:eof()

      ::oParent:oDetMenuArticulo:oDbfVir:cCodOrd   := ::oDbfVir:cCodOrd

      if ::nMode == APPD_MODE
         ::oParent:oDetMenuArticulo:oDbfVir:GoTop()
      else
         ::oParent:oDetMenuArticulo:oDbfVir:skip()
      end if 

   end while

RETURN ( oDlg:End( IDOK ) )

//----------------------------------------------------------------------------//

METHOD PreSaveDetails()

   ::oDbfVir:cCodMnu                               := ::oParent:oDbf:cCodMnu

RETURN ( Self )

//--------------------------------------------------------------------------//

