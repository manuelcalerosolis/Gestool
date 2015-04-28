#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//----------------------------------------------------------------------------//

CLASS TCentroCoste FROM TMant

	DATA lOpenFiles
	DATA nView
	DATA cPouDiv		INIT ""
	DATA cPinDiv		INIT ""

	METHOD OpenFiles( lExclusive, cPath )
	METHOD CloseFiles()
	METHOD DefineFiles( cPath, cDriver )
   	METHOD Resource( nMode )
   	METHOD lPreSave( oGet, oDlg, nMode )
   	METHOD validCodigo( oGet, cCodigo, nMode )					
   	METHOD validName( cNombre )							INLINE ( iif( empty( cNombre ),;
   																	( msgStop( "La descripción del centro de coste no puede estar vacía." ), .f. ),;
   																	.t. ) )


END CLASS

//----------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   	DEFAULT cPath        := ::cPath
   	DEFAULT cDriver      := cDriver()

   	DEFINE DATABASE ::oDbf FILE "CENTROCOSTE.DBF" CLASS "CENTROCOSTE" PATH ( cPath ) VIA ( cDriver ) COMMENT "Centro de coste"

      	FIELD NAME "cCodigo"   TYPE "C" LEN  9  DEC 0  COMMENT "Código"  				DEFAULT Space(  9 )  					  				COLSIZE 80  OF ::oDbf
      	FIELD NAME "cNombre"   TYPE "C" LEN 50  DEC 0  COMMENT "Nombre"  				DEFAULT Space( 50 )  					  				COLSIZE 200 OF ::oDbf
      	FIELD NAME "nVentas"   TYPE "N" LEN 15  DEC 6  COMMENT "Objetivo de Ventas"  						 PICTURE ::cPouDiv	  ALIGN RIGHT  	COLSIZE 150 OF ::oDbf
      	FIELD NAME "nCompras"  TYPE "N" LEN 15  DEC 6  COMMENT "Objetivo de compras"  						 PICTURE ::cPinDiv	  ALIGN RIGHT	COLSIZE 150 OF ::oDbf
   
      	INDEX TO "CENTROCOSTE.CDX" TAG "cCodigo" ON "cCodigo" COMMENT "Código" NODELETED OF ::oDbf
      	INDEX TO "CENTROCOSTE.CDX" TAG "cNombre" ON "cNombre" COMMENT "Nombre" NODELETED OF ::oDbf

   	END DATABASE ::oDbf

RETURN ( ::oDbf )

//----------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive, cPath )

   	local oError
   	local oBlock         

   	DEFAULT lExclusive   	:= .f.
   
   	oBlock               	:= ErrorBlock( {| oError | ApoloBreak( oError ) } )
   	BEGIN SEQUENCE

   		::nView             := D():CreateView()

   		D():Divisas( ::nView )

   		::cPouDiv			:= cPouDiv( ,D():Divisas( ::nView ) )
   		::cPinDiv			:= cPinDiv( ,D():Divisas( ::nView ) )

      	if Empty( ::oDbf )
         	::oDbf         	:= ::DefineFiles( cPath )
      	end if

      	::oDbf:Activate( .f., !( lExclusive ) )

      	::lOpenFiles      	:= .t.

   	RECOVER USING oError

      	msgStop( ErrorMessage( oError ), "Imposible abrir las bases de datos." )

      	::CloseFiles()
      
      	::lOpenFiles      	:= .f.

   	END SEQUENCE

   	ErrorBlock( oBlock )

Return ( ::lOpenFiles )

//----------------------------------------------------------------------------//

METHOD CloseFiles()

   	if !Empty( ::oDbf ) .and. ::oDbf:Used()
      	::oDbf:End()
   	end if

   	D():DeleteView( ::nView )

   	::oDbf      			:= nil
   	::nView	   				:= nil

Return ( .t. )

//----------------------------------------------------------------------------//

METHOD Resource( nMode ) 

   	local oDlg
   	local oGet

   	DEFINE DIALOG oDlg RESOURCE "CentroCoste" TITLE LblTitle( nMode ) + "centro de coste"

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
         	PICTURE ::cPouDiv;
			OF 		oDlg

		REDEFINE GET ::oDbf:nCompras UPDATE;
			ID 		130 ;
         	WHEN     ( nMode != ZOOM_MODE ) ;
         	PICTURE ::cPinDiv;
			OF 		oDlg

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

   	oDlg:bStart    := {|| oGet:SetFocus() }

	ACTIVATE DIALOG oDlg	CENTER

RETURN ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//

METHOD lPreSave( oGet, oDlg, nMode )

	if !::validCodigo( oGet, ::oDbf:cCodigo, nMode )
		Return .f.
	endif

	if !::validName( ::oDbf:cNombre )
		Return .f.
	endif

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
