#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//----------------------------------------------------------------------------//

CLASS TLenguaje FROM TMant

   DATA cMru                  INIT "gc_user_message_16"

   DATA oBrwDialog

   DATA aLenguajesPrestashop  INIT {}

   METHOD DefineFiles()

   METHOD Resource( nMode )
      METHOD lValidResource()

   METHOD Syncronize()

END CLASS

//----------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   DEFAULT cPath        := cPatDat()
   DEFAULT cDriver      := cDriver()

   DEFINE DATABASE ::oDbf FILE "LENGUAJE.DBF" CLASS "LENGUAJE" PATH ( cPath ) VIA ( cDriver ) COMMENT "Lenguajes"

      FIELD NAME "cCodLen"    TYPE "C" LEN   4  DEC 0  COMMENT "C�digo"  DEFAULT Space( 4 )     COLSIZE 80  OF ::oDbf
      FIELD NAME "cNomLen"    TYPE "C" LEN  50  DEC 0  COMMENT "Nombre"  DEFAULT Space( 200 )   COLSIZE 200 OF ::oDbf
      FIELD NAME "uuid"       TYPE "C" LEN  40  DEC 0  COMMENT "Uuid"    HIDE                               OF ::oDbf

      INDEX TO "LENGUAJE.CDX" TAG "CCODLEN" ON "CCODLEN" COMMENT "C�digo" NODELETED OF ::oDbf
      INDEX TO "LENGUAJE.CDX" TAG "CNOMLEN" ON "CNOMLEN" COMMENT "Nombre" NODELETED OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//----------------------------------------------------------------------------//

METHOD Resource( nMode ) 

   local oDlg
   local oGet

   DEFINE DIALOG oDlg RESOURCE "Lenguajes" TITLE LblTitle( nMode ) + "lenguajes"

      REDEFINE GET oGet ;
         VAR      ::oDbf:cCodLen UPDATE;
			ID 		100 ;
         WHEN     ( nMode == APPD_MODE ) ;
			PICTURE 	"@!" ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cNomLen UPDATE;
			ID 		110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::lValidResource( oGet, oDlg, nMode ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
			ACTION 	( oDlg:end() )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| ::lValidResource( oGet, oDlg, nMode ) } )
   end if

   oDlg:bStart    := {|| oGet:SetFocus() }

	ACTIVATE DIALOG oDlg	CENTER

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD lValidResource( oGet, oDlg, nMode )

   if nMode == APPD_MODE .or. nMode == DUPL_MODE

      if ::oDbf:SeekInOrd( ::oDbf:cCodLen, "cCodLen" )
         msgStop( "C�digo ya existe " + Rtrim( ::oDbf:cCodLen ) )
         oGet:GetFocus()
         return .f.
      end if

   end if

   if empty( ::oDbf:cNomLen )
      msgStop( "La descripci�n del lenguaje no puede estar vac�a." )
      Return .f.
   end if

RETURN ( oDlg:end( IDOK ) )

//---------------------------------------------------------------------------//

METHOD Syncronize()

   if ::OpenService()

      while !::oDbf:Eof()

         if empty( ::oDbf:uuid )
            ::oDbf:FieldPutByName( "uuid", win_uuidcreatestring() )
         end if

         ::oDbf:Skip()

      end while

      ::CloseService()

   end if

RETURN .t.

//---------------------------------------------------------------------------//