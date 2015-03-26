#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//--------------------------------------------------------------------------//

CLASS TpvMenuArticulo FROM TDet

   DATA oBmpImage

   METHOD DefineFiles()

   METHOD OpenFiles( lExclusive )

   METHOD CloseFiles()

   METHOD Resource( nMode, lLiteral )

   METHOD lPreSave()

   METHOD PreSaveDetails()

   METHOD ValidCodigoArticulo()

   METHOD aArticulos()

   METHOD IncrementoPrecio()

   METHOD StartResource()

END CLASS

//--------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cVia, lUniqueName, cFileName )

   local oDbf

   DEFAULT cPath        := ::cPath
   DEFAULT lUniqueName  := .f.
   DEFAULT cFileName    := "TpvMnuArt"
   DEFAULT cVia         := cDriver()

   if lUniqueName
      cFileName         := cGetNewFileName( cFileName, , , cPath )
   end if

   DEFINE TABLE oDbf FILE ( cFileName ) CLASS ( cFileName ) ALIAS ( cFileName ) PATH ( cPath ) VIA ( cVia ) COMMENT "Articulo Menú"

      FIELD NAME "cCodMnu" TYPE "C" LEN 03  DEC 0 COMMENT "Código menu"                    OF oDbf
      FIELD NAME "cCodOrd" TYPE "C" LEN 02  DEC 0 COMMENT "Código orden"                   OF oDbf
      FIELD NAME "cCodArt" TYPE "C" LEN 18  DEC 0 COMMENT "Código artículo"                OF oDbf
      FIELD NAME "nIncPre" TYPE "N" LEN 16  DEC 6 COMMENT "Incremento en el precio"        OF oDbf


      INDEX TO ( cFileName ) TAG "cCodMnu" ON "cCodMnu"                          NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "cCodOrd" ON "cCodOrd"                          NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "cCodArt" ON "cCodArt"                          NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "cOrdArt" ON "cCodOrd + cCodArt"                NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "cMnuOrd" ON "cCodMnu + cCodOrd + cCodArt"      NODELETED OF oDbf

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

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos" )

      ::CloseFiles()

      lOpen                := .f.

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

METHOD ValidCodigoArticulo( oGetCodigoArticulo )
   
   local lValid      := .f.

   if cArticulo( oGetCodigoArticulo, ::oParent:oDbfArticulo:cAlias, oGetCodigoArticulo:oHelpText )

      if !::oParent:oDbfArticulo:lIncTcl
         MsgStop( "El artículo no está incluido en el táctil" )
         Return ( lValid )
      end if

      if ::oBmpImage != nil
         ::oBmpImage:LoadBMP( cFileBmpName( ::oParent:oDbfArticulo:cImagen, .t. ) )
         ::oBmpImage:Refresh()
      end if

      lValid         := .t.

   end if

RETURN (lValid)

//--------------------------------------------------------------------------//

METHOD Resource( nMode )

   local oDlg
   local oGetCodigoArticulo

   if ::nMode == APPD_MODE
      ::oDbfVir:cCodOrd := ::oParent:oMenuOrdenes:cScopeValue
   end if

   // Caja de dialogo-------------------------------------------------------------

   DEFINE DIALOG oDlg RESOURCE "TpvMenuArticulo" TITLE LblTitle( nMode ) + "artículo"

      REDEFINE GET   oGetCodigoArticulo ;
         VAR         ::oDbfVir:cCodArt ;
         BITMAP      "Lupa" ;
         ID          100 ;
         IDTEXT      101 ;
         OF          oDlg

      oGetCodigoArticulo:bWhen   := {|| nMode == APPD_MODE }
      oGetCodigoArticulo:bValid  := {|| ::ValidCodigoArticulo(oGetCodigoArticulo) }
      oGetCodigoArticulo:bHelp   := {|| BrwArticulo( oGetCodigoArticulo, oGetCodigoArticulo:oHelpText ) }

      // Imagen-------------------------------------------------------------------

      REDEFINE IMAGE ::oBmpImage ;
         ID          102 ;
         OF          oDlg

      ::oBmpImage:SetColor( , GetSysColor( 15 ) )

      ::oBmpImage:bLClicked  := {|| ShowImage( ::oBmpImage ) }
      ::oBmpImage:bRClicked  := {|| ShowImage( ::oBmpImage ) }

      // Incremento en el precio--------------------------------------------------

      REDEFINE GET ::oDbfVir:nIncPre ;
         ID          120 ;
         PICTURE     ( cPorDiv() ) ;
         WHEN        ( nMode != ZOOM_MODE ) ;
         OF          oDlg

      // Botones------------------------------------------------------------------

      REDEFINE BUTTON ;
         ID          IDOK ;
			OF          oDlg ;
         WHEN        ( nMode != ZOOM_MODE ) ;
         ACTION      ( ::lPreSave( nMode, oDlg ) )

		REDEFINE BUTTON ;
         ID          IDCANCEL ;
			OF          oDlg ;
			ACTION      ( oDlg:end() )

      if nMode != ZOOM_MODE
         oDlg:AddFastKey( VK_F5, {|| ::lPreSave( nMode, oDlg ) } )
      end if

      oDlg:bStart    := {|| ::StartResource( nMode, oGetCodigoArticulo ) }

   ACTIVATE DIALOG oDlg CENTER

   ::oBmpImage:End()

RETURN ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//

METHOD lPreSave( nMode, oDlg )
   
   if ( nMode == APPD_MODE .or. nMode == DUPL_MODE )

      if Empty( ::oDbfVir:cCodArt )
         MsgStop( "Código del artículo no puede estar vacio" )
         Return ( .f. )
      end if

      if ::oDbfVir:SeekInOrd( ( ::oDbfVir:cCodOrd + ::oDbfVir:cCodArt ), "cOrdArt" )
         MsgStop( "El artículo ya esta añadido" )
         Return ( .f. )
      end if

   end if

RETURN ( oDlg:End( IDOK ) )

//----------------------------------------------------------------------------//

METHOD PreSaveDetails()

   ::oDbfVir:cCodMnu                               := ::oParent:oDbf:cCodMnu

   // ::oDbfVir:cCodMnu    := ::oDbf:cCodMnu
   // ::oDbfVir:cCodOrd    := ::oParent:oDetOrdenesMenu:oDbfVir:cCodOrd

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD aArticulos( cCodMnu, cCodOrd )

   local aArticulos     := {}

   ::oDbf:GetStatus()

   ::oDbf:OrdSetFocus( "cMnuOrd" )

   if ::oDbf:Seek( cCodMnu + cCodOrd )

      while ( cCodMnu + cCodOrd == ::oDbf:cCodMnu + ::oDbf:cCodOrd ) .and. !::oDbf:eof() 

         aAdd( aArticulos, ::oDbf:cCodArt )

         ::oDbf:skip()

      end while

   end if 

   ::oDbf:SetStatus()

RETURN (aArticulos)

//--------------------------------------------------------------------------//

METHOD IncrementoPrecio( cCodigoArticulo, cCodigoMenu, cCodigoOrden )

   local nPrecio     := 0

   ::oDbf:GetStatus()

   ::oDbf:OrdSetFocus( "cMnuOrd" )

   if ::oDbf:Seek( cCodigoMenu + cCodigoOrden + cCodigoArticulo)

      nPrecio        := ::oDbf:nIncPre

   end if

   ::oDbf:SetStatus()

RETURN ( nPrecio )

//---------------------------------------------------------------------------//

METHOD StartResource( nMode, oGetCodigoArticulo)

   if ( nMode != APPD_MODE )
      cArticulo( oGetCodigoArticulo, ::oParent:oDbfArticulo:cAlias, oGetCodigoArticulo:oHelpText )
   end if

RETURN (Self)

//--------------------------------------------------------------------------//
