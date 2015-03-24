#include "Inkey.ch"

//--------------------------------------------------------------------------//

Function VtaEdit( oLbx, oDbf, oDbfArt )

	local oDlg
	local oTotal
	local Codebase
	local GetList:= {}
	local nTotal := 0
	local nRow   := oLbx:BrwRow() + 7

	putHotKey(.f.)
	oDbf:setBuffer( .t. )
	setCursor(1)

	@ nRow, 3 GET oDbf:Unidades ;
				PICTURE "@E 99,999" ;
				WHEN nTotDeta( oDbf, GetList ) ;
				VALID nTotDeta( oDbf, GetList ) ;
				COLOR "w/b, w+/r"

	@ nRow,10 GET oDbf:CodeBase ;
				PICTURE "###############" ;
				VALID oNomArt( oDbf, oDbfArt ) ;
				COLOR "w/b, w+/r"

	@ nRow,26 GET oDbf:Nombre ;
				PICTURE "@S29" ;
				COLOR "w/b, w+/r"

	@ nRow,56 GET oDbf:PVenta ;
				PICTURE "@E 9,999,999" ;
				VALID nTotDeta( oDbf, GetList ) ;
				COLOR "w/b, w+/r"

	@ nRow,66 GET nTotal ;
				WHEN .F. ;
				PICTURE "@E 99,999,999" ;
				COLOR "w/b, w+/r"

	READ

	setCursor(0)

	IF lastKey() == K_ENTER .OR. lastKey() == K_PGDN
		oDbf:Save()
		BigNum( Trans( nTotal( oDbf ), "@E 999,999" ) )
	END IF

	oLbx:Refresh()
	oDbf:setBuffer( .f. )
	putHotKey(.t.)

return nil

//----------------------------------------------------------------------------//

static function nTotDeta( oDbf, aGetList )

	aGetList[5]:varPut( oDbf:PVenta * oDbf:Unidades )
	aGetList[5]:reset()

return .t.

//----------------------------------------------------------------------------//
