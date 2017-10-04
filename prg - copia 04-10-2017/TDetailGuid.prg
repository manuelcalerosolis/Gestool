#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Font.ch"

//---------------------------------------------------------------------------//

CLASS TDetailGuid FROM TDet

   METHOD Load( lAppend )

END CLASS

//---------------------------------------------------------------------------//

METHOD Load() CLASS TDetailGuid

   if empty( ::oParent )
      RETURN ( Self )
   end if 

   if !empty( ::oParent:getGuid() )
      ::oDbf:adsSetAOF( "cGuid = " + quoted( ::oParent:getGuid() ) )
      ::oDbf:goTop()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

