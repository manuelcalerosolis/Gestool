#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//----------------------------------------------------------------------------//

CLASS TComentarios FROM TMasDet

   DATA  cMru              INIT "gc_message_16"

   DATA  cBitmap           INIT clrTopArchivos

   DATA  oDetComentarios

   DATA  Codigo

   METHOD OpenFiles( lExclusive )
   METHOD CloseFiles()

   METHOD DefineFiles()

   METHOD OpenService( lExclusive )
   METHOD CloseService()

   METHOD Resource( nMode )

   METHOD lPreSave( oNom, oSec, nMode )

   METHOD DelRecComentario( oBrw )

   METHOD Reindexa()

END CLASS

//----------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive, cPath )

   local lOpen          := .t.
   local oError
   local oBlock

   DEFAULT cPath        := ::cPath
   DEFAULT lExclusive   := .f.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !lExclusive )

      ::oDetComentarios := TDetComentarios():New( ::cPath, cDriver(), Self )
      ::AddDetail( ::oDetComentarios )

      ::OpenDetails()

      ::bFirstKey       := {|| ::oDbf:cCodigo }

   RECOVER USING oError

      lOpen             := .f.

      ::CloseFiles()

      msgStop( ErrorMessage( oError ), "Imposible abrir las bases de datos de comentarios" )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD CloseFiles()

   ::CloseDetails()

   if !Empty( ::oDbf )
      ::oDbf:end()
   end if

   ::oDbf         := nil

RETURN .t.

//----------------------------------------------------------------------------//

METHOD OpenService( lExclusive, cPath )

   local lOpen          := .t.
   local oError
   local oBlock

   DEFAULT cPath        := ::cPath
   DEFAULT lExclusive   := .f.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !lExclusive )

   RECOVER USING oError

      lOpen             := .f.

      ::CloseFiles()

      msgStop( ErrorMessage( oError ), "Imposible abrir las bases de datos de comentarios" )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD CloseService()

   if !Empty( ::oDbf )
      ::oDbf:end()
   end if

   ::oDbf         := nil

RETURN .t.

//----------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE TABLE ::oDbf FILE "ComentariosT.Dbf" CLASS "Comentario" ALIAS "Coment" PATH ( cPath ) VIA ( cDriver ) COMMENT "Comentarios"

      FIELD NAME  "cCodigo"   TYPE  "C"   LEN   3  DEC 0 COMMENT  "Código"       COLSIZE  60 OF ::oDbf
      FIELD NAME  "cDescri"   TYPE  "C"   LEN 200  DEC 0 COMMENT  "Descripción"  COLSIZE 300 OF ::oDbf

      INDEX TO "ComentariosT.Cdx" TAG "cCodigo" ON "cCodigo" COMMENT "Código"       NODELETED OF ::oDbf
      INDEX TO "ComentariosT.Cdx" TAG "cDescri" ON "cDescri" COMMENT "Descripción"  NODELETED OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//----------------------------------------------------------------------------//

METHOD Resource( nMode )

	local oDlg
   local oGet
   local oNom
   local oBrw

   DEFINE DIALOG oDlg RESOURCE "Comentarios"

      REDEFINE GET oGet VAR ::oDbf:cCodigo ;
         ID       100 ;
         WHEN     ( nMode == APPD_MODE ) ;
         VALID    ( RjustObj( oGet, "0" ), .t. ) ;
			PICTURE 	"@!" ;
			OF 		oDlg

      REDEFINE GET oNom VAR ::oDbf:cDescri;
         ID       110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      /*
      Botones con acciones-----------------------------------------------------
      */

		REDEFINE BUTTON ;
			ID 		500 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::oDetComentarios:Append( oBrw ) )

		REDEFINE BUTTON ;
			ID 		501 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::oDetComentarios:Edit( oBrw ) )

		REDEFINE BUTTON ;
			ID 		502 ;
         OF       oDlg ;
         ACTION   ( ::oDetComentarios:Zoom() )

      REDEFINE BUTTON ;
         ID       503 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::DelRecComentario( oBrw ) )

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:nMarqueeStyle   := 5

      oBrw:bLDblClick      := { || ::oDetComentarios:Edit( oBrw ) }

      ::oDetComentarios:oDbfVir:SetBrowse( oBrw )

      with object ( oBrw:AddCol() )
         :cHeader          := "Descripción"
         :bEditValue       := {|| ::oDetComentarios:oDbfVir:cDescri }
      end with

      oBrw:CreateFromResource( 400 )

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( ::lPreSave( oGet, oNom, oDlg, nMode ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
			ACTION 	( oDlg:end() )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F2, {|| ::oDetComentarios:Append( oBrw ) } )
      oDlg:AddFastKey( VK_F3, {|| ::oDetComentarios:Edit( oBrw ) } )
      oDlg:AddFastKey( VK_F4, {|| ::oDetComentarios:Del( oBrw ) } )
      oDlg:AddFastKey( VK_F5, {|| ::lPreSave( oGet, oNom, oDlg, nMode ) } )
   end if

   oDlg:bStart := { || oGet:SetFocus() }

	ACTIVATE DIALOG oDlg	CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

METHOD lPreSave( oGet, oNom, oDlg, nMode )

   if ( nMode == APPD_MODE .or. nMode == DUPL_MODE )

      oGet:lValid()

      if ::oDbf:SeekInOrd( ::oDbf:cCodigo, "cCodigo" )
         MsgStop( "Código ya existe " + Rtrim( ::oDbf:cCodigo ) )
         return .f.
      end if

      if Empty( ::oDbf:cCodigo )
         MsgStop( "El código del comentario no puede estar vacío." )
         oGet:SetFocus()
         Return .f.
      end if

   end if

   if Empty( ::oDbf:cDescri )
      MsgStop( "La descripción del comentario no puede estar vacía." )
      oNom:SetFocus()
      Return .f.
   end if

Return ( oDlg:End( IDOK ) )

//--------------------------------------------------------------------------//

METHOD DelRecComentario( oBrw )

   local lDefComentario := .f.

   if ::oDetComentarios:oDbfVir:Recno() == 0
      RETURN ( Self )
   end if

   if oUser():lNotConfirmDelete() .or. ApoloMsgNoYes("¿ Desea eliminar definitivamente este registro ?", "Confirme supersión" )
      ::oDetComentarios:oDbfVir:Delete()
   end if

   oBrw:Refresh()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Reindexa()

   /*
   Definicion del master-------------------------------------------------------
   */

   if Empty( ::oDbf )
      ::oDbf   := ::DefineFiles()
   end if

   ::oDbf:IdxFDel()

   if ::OpenFiles( .t. )
      ::oDbf:Pack()
   end if

   ::CloseFiles()

RETURN ( Self )

//---------------------------------------------------------------------------//