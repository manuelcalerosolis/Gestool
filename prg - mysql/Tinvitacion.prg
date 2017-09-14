#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//----------------------------------------------------------------------------//

CLASS TInvitacion FROM TMANT

   DATA  cMru INIT "gc_masks_16"

   CLASSDATA aResource  AS ARRAY    INIT {   "gc_cocktail_16"        ,;
                                             "gc_user_16"            ,;
                                             "gc_security_agent_16"  ,;
                                             "gc_user_headphones_16" ,;
                                             "gc_woman2_16"          ,;
                                             "gc_ticket_blue_16"     ,;
                                             "gc_ticket_red_16"       }

   CLASSDATA aBigResource  AS ARRAY INIT {   "gc_cocktail_48"           ,;
                                             "gc_user2_48"           ,;
                                             "gc_security_agent_48"  ,;
                                             "gc_user_headphones_48" ,;
                                             "gc_woman2_48"          ,;
                                             "gc_ticket_blue_48"     ,;
                                             "gc_ticket_red_48"       }


   CLASSDATA aImagen    AS ARRAY    INIT {   "Copas"              ,;
                                             "Cliente"            ,;
                                             "Seguridad"          ,;
                                             "Deejay"             ,;
                                             "Camarera"           ,;
                                             "Entrada tipo 1"     ,;
                                             "Entrada tipo 2"      }

   METHOD Create( cPath ) CONSTRUCTOR

   METHOD New( cPath, oWndParent, oMenuItem ) CONSTRUCTOR

   METHOD OpenFiles( lExclusive )
   MESSAGE OpenService( lExclusive )   METHOD OpenFiles( lExclusive )

   METHOD DefineFiles()

   METHOD Resource( nMode )

   METHOD lPreSave()
   METHOD cImagen()              INLINE ( ::aImagen[ Min( Max( ::oDbf:nImgInv, 1 ), len( ::aImagen ) ) ] )
   METHOD cBigResource()         INLINE ( ::aBigResource[ Min( Max( ::oDbf:nImgInv, 1 ), len( ::aBigResource ) ) ] )

   METHOD nPrecioInvitacion( cCodigoInvitacion )

END CLASS

//----------------------------------------------------------------------------//

METHOD New( cPath, oWndParent, oMenuItem )

   DEFAULT cPath        := cPatEmp()
   DEFAULT oWndParent   := GetWndFrame()

   if oMenuItem != nil .and. ::nLevel == nil
      ::nLevel          := nLevelUsr( oMenuItem )
   else
      ::nLevel          := 0
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
   ::cHtmlHelp          := "Invitaciones"

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
   DEFAULT cPath        := ::cPath

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

   RECOVER USING oError

      lOpen             := .f.

      ::CloseFiles()

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos de invitaciones" )

   END SEQUENCE
   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE DATABASE ::oDbf FILE "Invita.Dbf" CLASS "INVITA" ALIAS "INVITA" PATH ( cPath ) VIA ( cDriver ) COMMENT "Invitaciones"

      FIELD NAME "cCodInv"    TYPE "C" LEN   2  DEC 0  COMMENT "Código"         COLSIZE  80 OF ::oDbf
      FIELD NAME "cNomInv"    TYPE "C" LEN  30  DEC 0  COMMENT "Nombre"         COLSIZE 200 OF ::oDbf
      FIELD NAME "nImgInv"    TYPE "N" LEN   2  DEC 0  COMMENT ""        HIDE   COLSIZE   0 OF ::oDbf
      FIELD NAME "lPreInv"    TYPE "L" LEN   1  DEC 0  COMMENT ""        HIDE   COLSIZE   0 OF ::oDbf
      FIELD NAME "nPreInv"    TYPE "N" LEN  16  DEC 6  COMMENT ""        HIDE   COLSIZE   0 OF ::oDbf

      INDEX TO "Invita.Cdx" TAG "cCodInv" ON "CCODINV" COMMENT "Código" NODELETED OF ::oDbf
      INDEX TO "Invita.Cdx" TAG "cNomInv" ON "CNOMINV" COMMENT "Nombre" NODELETED OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//----------------------------------------------------------------------------//

METHOD Resource( nMode )

   local oDlg
   local oGet
   local oGet2
   local oChkPre
   local oGetPre
   local oCmbImg
   local cCmbImg     := ::cImagen()

   ::lLoadDivisa()

   DEFINE DIALOG oDlg RESOURCE "INVITACIONES" TITLE LblTitle( nMode ) + "invitaciones"

      REDEFINE GET oGet VAR ::oDbf:cCodInv UPDATE;
			ID 		100 ;
         WHEN     ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) ;
         VALID    NotValid( oGet, ::oDbf:cAlias, .t., "0" ) ;
			PICTURE 	"@!" ;
			OF 		oDlg

      REDEFINE GET oGet2 VAR ::oDbf:cNomInv UPDATE;
			ID 		110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE COMBOBOX oCmbImg VAR cCmbImg ;
         ID       120;
			OF 		oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ITEMS    ::aImagen ;
         BITMAPS  ::aResource

      REDEFINE CHECKBOX ::oDbf:lPreInv ;
         ID       130 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET oGetPre VAR ::oDbf:nPreInv UPDATE;
         ID       140 ;
         PICTURE  ::cPorDiv ;
         WHEN     ( ::oDbf:lPreInv .and. ::oDbf:nPreInv >= 0 .and. nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       500 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( ::lPreSave( oGet, oGet2, nMode, oDlg, oCmbImg ) )

		REDEFINE BUTTON ;
         ID       550 ;
			OF 		oDlg ;
         CANCEL ;
			ACTION 	( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| if( nMode == DUPL_MODE, if( oGet:lValid(), ::lPreSave( oGet, oGet2, nMode, oDlg, oCmbImg ), ), ::lPreSave( oGet, oGet2, nMode, oDlg, oCmbImg ) ) } )

   oDlg:bStart := {|| oGet:SetFocus() }

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Method lPreSave( oGet, oGet2, nMode, oDlg, oCmbImg )

   local nRecAnt

   if nMode == APPD_MODE .or. nMode == DUPL_MODE
      if Empty( ::oDbf:cCodInv )
         MsgStop( "Código de la invitación no puede estar vacío" )
         oGet:SetFocus()
         Return nil
      end if

      if ::oDbf:SeekInOrd( ::oDbf:cCodInv, "cCodInv" )
         msgStop( "Código existente" )
         oGet:SetFocus()
         return nil
      end if

   end if

   if Empty( ::oDbf:cNomInv )
      MsgStop( "Nombre de la invitación no puede estar vacío" )
      oGet2:SetFocus()
      Return nil
   end if

   ::oDbf:nImgInv := oCmbImg:nAt

Return ( oDlg:end( IDOK ) )

//---------------------------------------------------------------------------//

METHOD nPrecioInvitacion( cCodigoInvitacion )

   local nPrecioInvitacion    := 0

   ::oDbf:GetStatus()

   ::oDbf:OrdSetFocus( "cCodInv" )

   if ::oDbf:Seek( cCodigoInvitacion ) 
      if ::oDbf:lPreInv
         nPrecioInvitacion    := ::oDbf:nPreInv
      end if 
   end if 

   ::oDbf:SetStatus()

Return ( nPrecioInvitacion )

//---------------------------------------------------------------------------//
