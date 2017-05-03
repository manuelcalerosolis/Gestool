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

      METHOD editLenguajes()
      METHOD saveLenguajes()
      METHOD deleteLenguajes()

END CLASS

//----------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE DATABASE ::oDbf FILE "LENGUAJE.DBF" CLASS "LENGUAJE" PATH ( cPath ) VIA ( cDriver ) COMMENT "Lenguajes"

      FIELD NAME "cCodLen"    TYPE "C" LEN   4  DEC 0  COMMENT "Código"  DEFAULT Space( 4 )     COLSIZE 80  OF ::oDbf
      FIELD NAME "cNomLen"    TYPE "C" LEN  50  DEC 0  COMMENT "Nombre"  DEFAULT Space( 200 )   COLSIZE 200 OF ::oDbf
      FIELD NAME "mPrsLen"    TYPE "M" LEN  10  DEC 0  HIDE                                                 OF ::oDbf

      INDEX TO "LENGUAJE.CDX" TAG "CCODLEN" ON "CCODLEN" COMMENT "Código" NODELETED OF ::oDbf
      INDEX TO "LENGUAJE.CDX" TAG "CNOMLEN" ON "CNOMLEN" COMMENT "Nombre" NODELETED OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//----------------------------------------------------------------------------//

METHOD Resource( nMode ) 

   local oDlg
   local oGet

   DEFINE DIALOG oDlg RESOURCE "Lenguajes" TITLE LblTitle( nMode ) + "lenguajes"

      REDEFINE GET oGet VAR ::oDbf:cCodLen UPDATE;
			ID 		100 ;
         WHEN     ( nMode == APPD_MODE ) ;
			PICTURE 	"@!" ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cNomLen UPDATE;
			ID 		110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      // Relaciones con prestashop---------------------------------------------

      REDEFINE BUTTON ;
         ID       500;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::editLenguajes( APPD_MODE ), ::oBrwDialog:Refresh() )

      REDEFINE BUTTON ;
         ID       501;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::editLenguajes( EDIT_MODE ), ::oBrwDialog:Refresh() )

      REDEFINE BUTTON ;
         ID       502;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::deleteLenguajes(), ::oBrwDialog:Refresh() )

      ::oBrwDialog                        := IXBrowse():New( oDlg )

      ::oBrwDialog:bClrSel                := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrwDialog:bClrSelFocus           := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oBrwDialog:SetArray( ::aLenguajesPrestashop, , , .f. )

      ::oBrwDialog:nMarqueeStyle          := 5

      ::oBrwDialog:CreateFromResource( 600 )

      with object ( ::oBrwDialog:AddCol() )
         :cHeader          := "Web"
         :bStrData         := {||   if (  !empty( ::aLenguajesPrestashop ) .and. isHash( ::aLenguajesPrestashop[ ::oBrwDialog:nArrayAt ] ),;
                                          hget( ::aLenguajesPrestashop[ ::oBrwDialog:nArrayAt ], "Web" ), "" ) }
         :nWidth           := 250
      end with

      with object ( ::oBrwDialog:AddCol() )
         :cHeader          := "Id Prestashop"
         :bStrData         := {||   if (  !empty( ::aLenguajesPrestashop ) .and. isHash( ::aLenguajesPrestashop[ ::oBrwDialog:nArrayAt ] ),;
                                          hget( ::aLenguajesPrestashop[ ::oBrwDialog:nArrayAt ], "Id" ), "" ) }
         :nWidth           := 130
      end with

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
         msgStop( "Código ya existe " + Rtrim( ::oDbf:cCodLen ) )
         oGet:GetFocus()
         return .f.
      end if

   end if

   if empty( ::oDbf:cNomLen )
      msgStop( "La descripción del lenguaje no puede estar vacía." )
      Return .f.
   end if

RETURN ( oDlg:end( IDOK ) )

//---------------------------------------------------------------------------//

METHOD editLenguajes( nMode )

   local oDlg
   local oWeb
   local cWeb     := ""
   local oId      
   local nId      := 0

   msgalert( "editLenguajes" )

   if nMode == EDIT_MODE 
      if !empty( ::aLenguajesPrestashop ) .and. isHash( ::aLenguajesPrestashop[ ::oBrwDialog:nArrayAt ] )
         cWeb     := hget( ::aLenguajesPrestashop[ ::oBrwDialog:nArrayAt ], "Web" )
         nId      := hget( ::aLenguajesPrestashop[ ::oBrwDialog:nArrayAt ], "Id" )
      end if 
   end if 

   DEFINE DIALOG oDlg RESOURCE "LENGUAJE_PRESTASHOP" TITLE LblTitle( nMode ) + "Relaciones con prestashop"

      REDEFINE COMBOBOX oWeb ;
         VAR      cWeb ;
         ITEMS    TComercioConfig():getInstance():getWebsNames() ;
         ID       100 ;
         OF       oDlg

      REDEFINE GET oId ;
         VAR      nId ;
         ID       110 ;
         PICTURE  "999" ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( ::saveLenguajes( nMode, cWeb, nId, oDlg ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      oDlg:AddFastKey( VK_F5, {|| ::saveLenguajes( nMode, cWeb, nId, oDlg ) } )

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD saveLenguajes( nMode, cWeb, nId, oDlg )

   msgalert( len( ::aLenguajesPrestashop ), "len antes" )

   if nMode == APPD_MODE
      aadd(::aLenguajesPrestashop, { "Web" => cWeb, "Id" => nId } )
   end if 

   if nMode == EDIT_MODE
      hset( ::aLenguajesPrestashop[ ::oBrwDialog:nArrayAt ], cWeb )
      hset( ::aLenguajesPrestashop[ ::oBrwDialog:nArrayAt ], nId )
   end if 

   msgalert( len( ::aLenguajesPrestashop ), "len despues" )

RETURN ( oDlg:end( IDOK ) )


METHOD deleteLenguajes()

RETURN ( Self )

//---------------------------------------------------------------------------//
