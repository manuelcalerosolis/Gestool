#include "FiveWin.Ch"
#include "Factu.ch" 
 
CLASS DocumentLines 

   DATA oSender

   DATA aLines                                              INIT {}

   METHOD new( oSender )

   METHOD reset()
   
   METHOD addLines( oLine )

   METHOD getLines()                                        INLINE ( ::aLines )
      METHOD getCloneLine()                                 INLINE ( oClone( ::getLine() ) )

   METHOD getLineDetail( nPosDetail )                       INLINE ( ::aLines[ nPosDetail ] )
      METHOD getCloneLineDetail( nPosDetail )               INLINE ( oClone( ::getLineDetail( nPosDetail ) ) )
      
   METHOD appendLineDetail( oDocumentLine )                 INLINE ( aadd( ::aLines, oDocumentLine ) )
   METHOD saveLineDetail( nPosDetail, oDocumentLine )       INLINE ( ::aLines[ nPosDetail ] := oDocumentLine )

   METHOD Total()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD new( oSender )

   oSender        := oSender

Return ( Self )

//---------------------------------------------------------------------------//

METHOD reset() CLASS DocumentLines

   ::aLines       := {}

Return ( Self )

//---------------------------------------------------------------------------//

METHOD addLines( oLine ) CLASS DocumentLines

   aAdd( ::aLines, oLine )
  
Return ( Self )

//---------------------------------------------------------------------------//

METHOD Total() CLASS DocumentLines

   local oLine
   local Total  := 0

   for each oLine in ::aLines

      Total     += oLine:Total()

   next

Return ( Total )

//---------------------------------------------------------------------------//

