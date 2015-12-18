#include "FiveWin.Ch"
#include "Factu.ch" 
 
CLASS DocumentLines 

   DATA oSender

   DATA aLines                                              INIT {}

   METHOD new( oSender )
   METHOD getView()                                         INLINE ( ::oSender:getView() )

   METHOD reset()
   
   METHOD addLines( oLine )
   METHOD addLinesObjects( oLine )

   METHOD getLines()                                        INLINE ( ::aLines )
      METHOD getCloneLine()                                 INLINE ( oClone( ::getLine() ) )

   METHOD getLine( nPosition )                              INLINE ( ::aLines[ nPosition  ] )
   METHOD getLineDetail( nPosition )                        INLINE ( ::getLine( nPosition  ) )
      METHOD getCloneLineDetail( nPosition )                INLINE ( oClone( ::getLineDetail( nPosition  ) ) )
      
   METHOD appendLineDetail( oDocumentLine )                 INLINE ( aadd( ::aLines, oDocumentLine ) )
   METHOD saveLineDetail( nPosition, oDocumentLine )        INLINE ( ::aLines[ nPosition  ] := oDocumentLine )

   METHOD getTotal()

   METHOD selectAll()                                       INLINE ( aeval( ::aLines, {|oLine| oLine:select() } ) )
   METHOD unselectAll()                                     INLINE ( aeval( ::aLines, {|oLine| oLine:unSelect() } ) )

   METHOD getHeaderAlias()                                  INLINE ( ::oSender:getHeaderAlias() )
   METHOD getHeaderDictionary()                             INLINE ( ::oSender:getHeaderDictionary() )

   METHOD getLineAlias()                                    INLINE ( ::oSender:getLineAlias() )
   METHOD getLineDictionary()                               INLINE ( ::oSender:getLineDictionary() )

   METHOD sortBy( expresion )

END CLASS

//---------------------------------------------------------------------------//

METHOD new( oSender )

   ::oSender      := oSender

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

METHOD addLinesObjects()

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

METHOD sortBy( expresion )

   asort( ::aLines, , , {|x,y| x:getCode() < y:getCode() } )

Return (  Self )

//---------------------------------------------------------------------------//





