#include "FiveWin.Ch"
#include "Factu.ch" 
 
CLASS DocumentLines 

   DATA oSender

   DATA aLines                                              INIT {}
   DATA aSelectedLines                                      INIT {}

   METHOD new( oSender )

   METHOD reset()
   
   METHOD addLines( oLine )
   METHOD addLinesObjects( oLine )

   METHOD getLines()                                        INLINE ( ::aLines )
      METHOD getCloneLine()                                 INLINE ( oClone( ::getLine() ) )

   METHOD getLine( nPosDetail )                             INLINE ( ::aLines[ nPosDetail ] )
   METHOD getLineDetail( nPosDetail )                       INLINE ( ::getLine( nPosDetail ) )
      METHOD getCloneLineDetail( nPosDetail )               INLINE ( oClone( ::getLineDetail( nPosDetail ) ) )
      
   METHOD appendLineDetail( oDocumentLine )                 INLINE ( aadd( ::aLines, oDocumentLine ) )
   METHOD saveLineDetail( nPosDetail, oDocumentLine )       INLINE ( ::aLines[ nPosDetail ] := oDocumentLine )

   METHOD getTotal()

   METHOD selectAllLine()                                   INLINE ( aeval( ::aSelectedLines, {|oLine| oLine:select() } ) )
   METHOD unselectAllLine()                                 INLINE ( aeval( ::aSelectedLines, {|oLine| oLine:unSelect() } ) )
 
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

METHOD addLines( hLine ) CLASS DocumentLines

   aAdd( ::aLines, hLine )
  
Return ( Self )

//---------------------------------------------------------------------------//

METHOD addLinesObjects( )

   ::addLines( DocumentLine():New() )

Return (  Self )

//---------------------------------------------------------------------------//

METHOD getTotal() CLASS DocumentLines

   local oLine
   local Total  := 0

   for each oLine in ::aLines
      Total     += oLine:getTotal()
   next

Return ( Total )

//---------------------------------------------------------------------------//



