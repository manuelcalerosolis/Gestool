#include "fivewin.ch"

CLASS TDotNetColumn

      DATA oGrupo
      DATA oCarpeta
      DATA oParent
      DATA aItems AS ARRAY INIT {}

      METHOD New( oGrupo ) CONSTRUCTOR
      METHOD AddItem( oItem ) INLINE aadd( ::aItems, oItem )
      METHOD Paint( hDC )
      METHOD MaxWidthOfCol()

ENDCLASS

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   METHOD New( oGrupo ) CLASS TDotNetColumn
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

   ::oGrupo      := oGrupo
   ::oCarpeta    := oGrupo:oCarpeta
   ::oParent     := oGrupo:oCarpeta:oParent

   aadd( ::oGrupo:aColumns, self )

return self

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   METHOD Paint( hDC ) CLASS TDotNetColumn
////////////////////////////////////////////////////////////////////////////////////////////////////////////////



return 0

***********************************************************************************************************************
   METHOD MaxWidthOfCol() CLASS TDotNetColumn
***********************************************************************************************************************
local nMax := 0
local n

 for n := 1 to len( ::aItems )
     nMax := max( nMax, ::aItems[ n ]:nWidth )
 next

return nMax
