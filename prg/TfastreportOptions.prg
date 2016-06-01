#include "FiveWin.ch"  
#include "Factu.ch" 
#include "Report.ch"
#include "MesDbf.ch"

// #include "FastRepH.ch"

//---------------------------------------------------------------------------//

CLASS TFastreportOptions 

	DATA hOptions

	METHOD setOptions()
	METHOD getOptions()
	METHOD Dialog()

END CLASS

//---------------------------------------------------------------------------//

METHOD setOptions( hOptions ) CLASS TFastReportOptions

   ::hOptions 		:= hOptions

RETURN ( hOptions )

//---------------------------------------------------------------------------//

METHOD getOptions( key ) CLASS TFastReportOptions
		
	local cValor

	if hhaskey( ::hOptions, key ) 
      cValor         := hget( ::hOptions, key ) 
   end if 

RETURN ( cValor )

//---------------------------------------------------------------------------//

METHOD Dialog( nMode ) CLASS TFastReportOptions
   
   local oDlg

   DEFINE DIALOG oDlg RESOURCE "Options"

   REDEFINE BUTTON ;
      ID       IDOK ;
		OF 		oDlg ;
		WHEN 		( nMode != ZOOM_MODE ) ;
      ACTION   ( oDlg:end( IDOK ) )

 	REDEFINE BUTTON ;
      ID       IDCANCEL ;
		OF 		oDlg ;
      CANCEL ;
		ACTION 	( oDlg:end() )

   ACTIVATE DIALOG oDlg CENTER

Return ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//


