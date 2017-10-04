#include "FiveWin.Ch"
#include "Report.ch"
#include "Factu.ch" 

static dbfTpvT
static dbfTpvL

//----------------------------------------------------------------------------//

FUNCTION Mostrador( oWnd )

	local oDlg

	DEFINE DIALOG oDlg RESOURCE "FRONTPV"

		REDEFINE BUTTON ;
         ID IDCANCEL ;
			OF oDlg ;
			ACTION ( oDlg:end() )

	ACTIVATE DIALOG oDlg	CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//