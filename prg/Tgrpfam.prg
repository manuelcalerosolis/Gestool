#ifndef __PDA__
#include "FiveWin.Ch"
#else
#include "FWCE.ch"
REQUEST DBFCDX
#endif
#include "Factu.ch" 
#include "MesDbf.ch"

#ifndef __PDA__ 

//----------------------------------------------------------------------------//
//Funciones del programa
//----------------------------------------------------------------------------//

CLASS TGrpFam FROM TMant

   DATA cCodWebPreDel
   DATA oBotonAceptarWeb
   DATA lActualizaWeb         INIT .f.

   METHOD Create( cPath ) CONSTRUCTOR

   METHOD New( cPath, oWndParent, oMenuItem ) CONSTRUCTOR

   METHOD OpenFiles( lExclusive )
   MESSAGE OpenService( lExclusive )   METHOD OpenFiles( lExclusive )

   METHOD DefineFiles()

   METHOD Resource( nMode )

   METHOD Activate()

   METHOD Publicar()

   METHOD Enviar()

   METHOD lPreSave( oGet, oDlg )

   METHOD Actualizaweb()

   METHOD lPubGrp()

   METHOD StartResource( oGet )

END CLASS

//----------------------------------------------------------------------------//

METHOD Create( cPath ) CLASS TGrpFam

   DEFAULT cPath     := cPatEmp()

   ::cPath           := cPath
   ::oDbf            := nil

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD New( cPath, oWndParent, oMenuItem ) CLASS TGrpFam

   DEFAULT cPath        := cPatEmp()
   DEFAULT oWndParent   := GetWndFrame()

   if oMenuItem != nil
      ::nLevel          := Auth():Level( oMenuItem )
   else
      ::nLevel          := Auth():Level( "01011" )
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

   ::cMru               := "gc_folder_cubes_16"

   ::cBitmap            := clrTopArchivos

   ::cHtmlHelp          := "Grupos de familias"

   ::bOnPostSave        := {|| ::Actualizaweb() }
   ::bOnPreDelete       := {|| ::cCodWebPreDel  := ::oDbf:cCodWeb  }
   ::bOnPostDelete      := {|| ::Actualizaweb( ::cCodWebPreDel, .t. )  }

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive, cPath ) CLASS TGrpFam

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

   RECOVER

      lOpen             := .f.
      
      msgStop( "Imposible abrir las bases de datos de grupos de famílias" )
      
      ::CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver ) CLASS TGrpFam

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE DATABASE ::oDbf FILE "GRPFAM.DBF" CLASS "GRPFAM" ALIAS "GRPFAM" PATH ( cPath ) VIA ( cDriver ) COMMENT "Grupos de familias"

      FIELD CALCULATE NAME "bSndDoc"      LEN 14  DEC 0  COMMENT { "Enviar", "gc_mail2_16" , 3 }      VAL {|| ::oDbf:lSndDoc} BITMAPS "gc_mail2_12", "Nil16" COLSIZE 20 OF ::oDbf
      FIELD CALCULATE NAME "bPubInt"      LEN 14  DEC 0  COMMENT { "Publicar", "gc_earth_16" , 3 } VAL {|| ::oDbf:lPubInt} BITMAPS "gc_earth_12", "Nil16" COLSIZE 20 OF ::oDbf
      FIELD NAME "cCodGrp"       TYPE "C" LEN  3  DEC 0  COMMENT "Código"                             COLSIZE 80  OF ::oDbf
      FIELD NAME "cNomGrp"       TYPE "C" LEN 30  DEC 0  COMMENT "Nombre"                             COLSIZE 200 OF ::oDbf
      FIELD NAME "lPubInt"       TYPE "L" LEN  1  DEC 0  HIDE                                                     OF ::oDbf
      FIELD NAME "cCodWeb"       TYPE "N" LEN 11  DEC 0  HIDE                                                     OF ::oDbf
      FIELD NAME "lSndDoc"       TYPE "L" LEN  1  DEC 0  HIDE                                                     OF ::oDbf
      FIELD NAME "CIMGGRP"       TYPE "C" LEN 250 DEC 0  HIDE                                                     OF ::oDbf

      INDEX TO "GRPFAM.CDX" TAG "CCODGRP" ON "CCODGRP"            COMMENT "Código"     NODELETED OF ::oDbf
      INDEX TO "GRPFAM.CDX" TAG "CNOMGRP" ON "UPPER( CNOMGRP )"   COMMENT "Nombre"     NODELETED OF ::oDbf
      INDEX TO "GRPFAM.CDX" TAG "cCodWeb" ON "Str( cCodWeb, 11 )" COMMENT "CódigoWeb"  NODELETED OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//----------------------------------------------------------------------------//

METHOD Resource( nMode ) CLASS TGrpFam

	local oDlg
   local oGet, oGet2
   local oGetImage
   local bmpImage

   if nMode == DUPL_MODE
      ::oDbf:cCodGrp := NextKey( ::oDbf:cCodGrp, ::oDbf )
   end if

   DEFINE DIALOG oDlg RESOURCE "GrpFam" TITLE LblTitle( nMode ) + "grupos de familias"

      REDEFINE GET oGet VAR ::oDbf:cCodGrp UPDATE;
			ID 		100 ;
         WHEN     ( nMode == APPD_MODE ) ;
         PICTURE  "@!" ;
         OF       oDlg

      oGet:bHelp  := {|| oGet:cText( NextKey( ::oDbf:cCodGrp, ::oDbf ) ) }
      oGet:cBmp   := "BOT"
      oGet:bValid := {|| NotValid( oGet, ::oDbf:cAlias ) .and. !Empty( oGet:VarGet() ) }

      REDEFINE GET oGet2 VAR ::oDbf:cNomGrp UPDATE;
			ID 		110 ;
         PICTURE  ::oDbf:FieldByName( "cNomGrp" ):cPict ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg
      
      REDEFINE GET oGetImage VAR ::oDbf:cImgGrp ;
         BITMAP   "FOLDER" ;
         ON HELP  ( GetBmp( oGetImage, bmpImage ) ) ;
         ON CHANGE( ChgBmp( oGetImage, bmpImage ) ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ID       130 ;
         OF       oDlg

      REDEFINE CHECKBOX ::oDbf:lPubInt ;
         ID       120 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( ::Publicar() ) ;
			OF 		oDlg

      REDEFINE IMAGE bmpImage ;
         ID       600 ;
         OF       oDlg ;
         FILE     cFileBmpName( ::oDbf:cImgGrp )

      bmpImage:SetColor( , GetSysColor( 15 ) )
      bmpImage:bLClicked   := {|| ShowImage( bmpImage ) }
      bmpImage:bRClicked   := {|| ShowImage( bmpImage ) }   

      REDEFINE BUTTON ::oBotonAceptarWeb;
         ID       500 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::lPreSave( oGet, oGet2, oDlg, nMode ), ::lActualizaWeb := .t. )

      REDEFINE BUTTON;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( ::lPreSave( oGet, oGet2, oDlg, nMode ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
			ACTION 	( oDlg:end() )

   if nMode != ZOOM_MODE
      
      oDlg:AddFastKey( VK_F5, {|| ::lPreSave( oGet, oGet2, oDlg, nMode ) } )

      if uFieldEmpresa( "lRealWeb" )
         oDlg:AddFastKey( VK_F6, {|| ::lPreSave( oGet, oGet2, oDlg, nMode ), ::lActualizaWeb := .t. } )
      end if

   end if

   oDlg:AddFastKey ( VK_F1, {|| ChmHelp( "Grupos_de_familias" ) } )

   oDlg:bStart := { || ::StartResource( oGet ) }

   ACTIVATE DIALOG oDlg ;
      ON INIT     ( ChgBmp( oGetImage, bmpImage ) ) ;
   CENTER

   if !Empty( bmpImage )
      bmpImage:End()
   end if

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

METHOD StartResource( oGet )

   oGet:SetFocus()

   if uFieldEmpresa( "lRealWeb" )
      ::oBotonAceptarWeb:Show()
   else
      ::oBotonAceptarWeb:Hide()
   end if   

Return .t.

//--------------------------------------------------------------------------//

METHOD lPreSave( oGet, oGet2, oDlg, nMode )

   if nMode == APPD_MODE .or. nMode == DUPL_MODE
      
      if Empty( ::oDbf:cCodGrp )
         MsgStop( "Código de grupo de família no puede estar vacío." )
         oGet:SetFocus()
         Return .f.
      end if

      if ::oDbf:SeekInOrd( ::oDbf:cCodGrp, "CCODGRP" )
         MsgStop( "Código ya existe " + Rtrim( ::oDbf:cCodGrp ) )
         return nil
      end if

   end if

   if Empty( ::oDbf:cNomGrp )
      MsgStop( "Nombre de grupo de família no puede estar vacío." )
      oGet2:SetFocus()
      Return .f.
   end if

   ::oDbf:lSndDoc    := .t.

RETURN ( oDlg:end( IDOK ) )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS TGrpFam

   if nAnd( ::nLevel, 1 ) == 0
      msgStop( "Acceso no permitido." )
      Return ( Self )
   end if

   ::CreateShell( ::nLevel )

   ::oWndBrw:GralButtons( Self )

   DEFINE BTNSHELL RESOURCE "Lbl" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::Enviar( .t. ) ) ;
      TOOLTIP  "En(v)iar" ;
      HOTKEY   "V";
      LEVEL    ACC_EDIT

   DEFINE BTNSHELL RESOURCE "SNDINT" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::Publicar( .t. ) ) ;
      TOOLTIP  "(P)ublicar" ;
      HOTKEY   "P";
      LEVEL    ACC_EDIT

   ::oWndBrw:EndButtons( Self )

   ::oWndBrw:cHtmlHelp  := "Grupos de familias"

   ::oWndBrw:Activate(  , , , , , , , , , , , , , , , , {|| ::CloseFiles() } )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Publicar( lLoad ) CLASS TGrpFam

   DEFAULT lLoad     := .f.

   if lLoad
      ::oDbf:Load()
      ::oDbf:lPubInt := !::oDbf:lPubInt
      ::oDbf:lSndDoc := ::oDbf:lPubInt
   end if

   if lLoad
      ::oDbf:Save()
      ::oWndBrw:Refresh()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Enviar( lLoad ) CLASS TGrpFam

   DEFAULT lLoad     := .f.

   if lLoad
      ::oDbf:Load()
      ::oDbf:lSndDoc := !::oDbf:lSndDoc
   end if

   if lLoad
      ::oDbf:Save()
      ::oWndBrw:Refresh()
   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Actualizaweb( cCodWeb, lDel ) Class TGrpFam

   /*DEFAULT lDel      := .f.

   if ::lActualizaWeb .and. uFieldEmpresa( "lRealWeb" )

      if ::lPubGrp() .or. lDel
         with object ( TComercio():New())
            :ActualizaGrupoCategoriesPrestashop( ::oDbf:cCodGrp, lDel, cCodWeb )
         end with
      end if
      
   end if

   ::lActualizaWeb   := .f.*/
      
Return .t.

//----------------------------------------------------------------------------//

METHOD lPubGrp() Class TGrpFam

   local lPub  := .f.

   if ::oDbf:lPubInt

      lPub     := .t.

   else

      if ::oDbf:cCodWeb != 0

         lPub  := .t.

      end if

   end if

Return lPub

//----------------------------------------------------------------------------//

FUNCTION retGruFam( cCodGrf, oDbfGrf )

   local cNombre  := ""

   if oDbfGrf:oDbf:Seek( cCodGrf )
      cNombre     := oDbfGrf:oDbf:cNomGrp
   end if

RETURN ( cNombre )

//---------------------------------------------------------------------------//

FUNCTION cCodGruFam( cCodArt, oDbfArt, oDbfFam )

   local cCodGrf  := ""

   if oDbfArt:Seek( cCodArt )

      if oDbfFam:Seek( oDbfArt:Familia )
         cCodGrf  := oDbfFam:cCodGrp
      end if

   end if

RETURN ( cCodGrf )

//---------------------------------------------------------------------------//

#endif

//---------------------------------------------------------------------------//
//Funciones comunes del programa y pda
//---------------------------------------------------------------------------//


FUNCTION cGruFam( cCodFam, oDbfFam )

   local cCodGrf  := ""

   if ValType( oDbfFam ) == "O"
      if oDbfFam:Seek( cCodFam )
         cCodGrf  := oDbfFam:cCodGrp
      end if
   else
      if ( oDbfFam )->( dbSeek( cCodFam ) )
         cCodGrf  := ( oDbfFam )->cCodGrp
      end if
   end if

RETURN ( cCodGrf )

//---------------------------------------------------------------------------//