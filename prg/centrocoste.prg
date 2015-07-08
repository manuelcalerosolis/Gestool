#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//----------------------------------------------------------------------------//

CLASS TCentroCoste FROM TMant

	DATA lOpenFiles
   DATA  cMru              INIT     "centro_coste_16"

   DATA aTipo              INIT {   "Clientes", "Artículos", "Proveedores" }
   DATA cTipo              INIT     "Artículos"
   DATA oTipo

   DATA cGet
   DATA oGet

   DATA hValid             INIT {=>}
   DATA hHelp              INIT {=>}

   METHOD New()

	METHOD DefineFiles( cPath, cDriver )

	METHOD Resource( nMode )

	METHOD lPreSave( oGet, oDlg, nMode )

   METHOD loadValues()

	METHOD validCodigo( oGet, cCodigo, nMode )					

	METHOD validName( cNombre )							INLINE ( iif( empty( cNombre ),;
																	( msgStop( "La descripción del centro de coste no puede estar vacía." ), .f. ),;
																	.t. ) )
   METHOD loadGet()

   METHOD clearGet()

END CLASS

//----------------------------------------------------------------------------//

METHOD New()

   ::Super:New()

   ::hValid       := {  "Clientes" => {|| cClient( ::oGet, , ::oGet:oHelpText ) } ,;
                        "Artículos" => {|| cArticulo( ::oGet, , ::oGet:oHelpText ) } ,;
                        "Proveedores" => {|| cProvee( ::oGet, , ::oGet:oHelpText ) } }

   ::hHelp        := {  "Clientes" => {|| BrwClient( ::oGet, ::oGet:oHelpText ) } ,;
                        "Artículos" => {|| BrwArticulo( ::oGet, ::oGet:oHelpText ) } ,;
                        "Proveedores" => {|| BrwProvee( ::oGet, ::oGet:oHelpText ) } }

Return ( Self )

//---------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   	DEFAULT cPath        := ::cPath
   	DEFAULT cDriver      := cDriver()

   	DEFINE DATABASE ::oDbf FILE "CENTROCOSTE.DBF" CLASS "CENTROCOSTE" PATH ( cPath ) VIA ( cDriver ) COMMENT "Centro de coste"

      	FIELD NAME "cCodigo"   TYPE "C" LEN  9  DEC 0  COMMENT "Código"  				DEFAULT Space(  9 )  					  				         COLSIZE 80  OF ::oDbf
      	FIELD NAME "cNombre"   TYPE "C" LEN 50  DEC 0  COMMENT "Nombre"  				DEFAULT Space( 50 )  					  				         COLSIZE 200 OF ::oDbf
      	FIELD NAME "nVentas"   TYPE "N" LEN 15  DEC 6  COMMENT "Objetivo de Ventas"  						   PICTURE cPorDiv()	  ALIGN RIGHT  	COLSIZE 150 OF ::oDbf
      	FIELD NAME "nCompras"  TYPE "N" LEN 15  DEC 6  COMMENT "Objetivo de compras"  						PICTURE cPirDiv()	  ALIGN RIGHT	   COLSIZE 150 OF ::oDbf
         FIELD NAME "nTipoDoc"  TYPE "N" LEN  2  DEC 0  COMMENT "Tipo documento asociado"                HIDE  OF ::oDbf
         FIELD NAME "cCodDoc"   TYPE "C" LEN 30  DEC 0  COMMENT "Documento asociado"                     HIDE  OF ::oDbf
   
      	INDEX TO "CENTROCOSTE.CDX" TAG "cCodigo" ON "cCodigo" COMMENT "Código" NODELETED OF ::oDbf
      	INDEX TO "CENTROCOSTE.CDX" TAG "cNombre" ON "cNombre" COMMENT "Nombre" NODELETED OF ::oDbf

   	END DATABASE ::oDbf

RETURN ( ::oDbf )

//----------------------------------------------------------------------------//

METHOD Resource( nMode ) 

   	local oDlg
   	local oGet
      local oBmp

      ::loadValues()

   	DEFINE DIALOG oDlg RESOURCE "CentroCoste" TITLE LblTitle( nMode ) + "centro de coste"

         REDEFINE BITMAP oBmp ;
            RESOURCE "centro_coste_48" ;
            ID       800 ;
            TRANSPARENT ;
            OF       oDlg ;

      	REDEFINE GET oGet VAR ::oDbf:cCodigo UPDATE;
            ID 		100 ;
            WHEN     ( nMode == APPD_MODE ) ;
            PICTURE 	"@!" ;
            OF 		oDlg

      	REDEFINE GET ::oDbf:cNombre UPDATE;
            ID 		110 ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            OF 		oDlg

         REDEFINE GET ::oDbf:nVentas UPDATE;
            ID 		120 ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            PICTURE  ( cPorDiv() );
            OF 		oDlg

         REDEFINE GET ::oDbf:nCompras UPDATE;
            ID 		130 ;
            WHEN     ( nMode != ZOOM_MODE ) ; 
            PICTURE  ( cPirDiv() );
            OF 		oDlg

         REDEFINE COMBOBOX ::oTipo ;
            VAR      ::cTipo ;
            ID       140 ;
            ITEMS    ::aTipo ;
            WHEN     ( nMode != ZOOM_MODE ) ; 
            OF       oDlg

            ::oTipo:bChange   := {|| ::clearGet(), ::LoadGet() }

         REDEFINE GET ::oGet VAR ::cGet ;
            ID       150 ;
            IDTEXT   160 ;
            BITMAP   "LUPA" ;
            WHEN     ( nMode != ZOOM_MODE ) ; 
            OF       oDlg

      	REDEFINE BUTTON ;
            ID       IDOK ;
            OF 		oDlg ;
         	WHEN     (  nMode != ZOOM_MODE ) ;
         	ACTION   (  ::lPreSave( oGet, oDlg, nMode ) )

      	REDEFINE BUTTON ;
            ID       IDCANCEL ;
            OF 		oDlg ;
            CANCEL ;
            ACTION 	( oDlg:end() )

   	if nMode != ZOOM_MODE
      	oDlg:AddFastKey( VK_F5, {|| ::lPreSave( oGet, oDlg, nMode ) } )
   	end if

   	oDlg:bStart    := {|| ::LoadGet(), ::oGet:lValid(), oGet:SetFocus() }

	ACTIVATE DIALOG oDlg	CENTER

   if !Empty( oBmp )
      oBmp:End()
   end if

RETURN ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//

METHOD lPreSave( oGet, oDlg, nMode )

	if !::validCodigo( oGet, ::oDbf:cCodigo, nMode )
		Return .f.
	endif

	if !::validName( ::oDbf:cNombre )
		Return .f.
	endif

   if !::oGet:lValid()
      Return .f.
   end if

   ::oDbf:nTipoDoc   := ::oTipo:nAt
   ::oDbf:cCodDoc    := ::oGet:VarGet

Return ( oDlg:end( IDOK ) )

//---------------------------------------------------------------------------//

METHOD validCodigo( oGet, cCodigo, nMode )

	if nMode == APPD_MODE .or. nMode == DUPL_MODE

   	if ::oDbf:SeekInOrd( cCodigo, "cCodigo" )
      	MsgStop( "El código introducido ya existe: " + ::oDbf:cCodigo )
      	Return .f.
      	oGet:SetFocus()
   	end if

	end if

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD loadValues()

   ::cTipo  := ::aTipo[ Max( ::oDbf:nTipoDoc, 1 ) ]
   ::cGet   := ::oDbf:cCodDoc

Return .t.

//---------------------------------------------------------------------------//

METHOD loadGet()

   ::oGet:bValid     := hGet( ::hValid, ::cTipo )
   ::oGet:bHelp      := hGet( ::hHelp, ::cTipo )

Return .t.

//---------------------------------------------------------------------------//

METHOD clearGet()

   ::oGet:cText( Space( 30 ) )
   ::oGet:oHelpText:cText( Space( 200 ) )

Return .t.

//---------------------------------------------------------------------------//