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

   METHOD getLine( nPosition )                              INLINE ( if( !empty( ::aLines ), ::aLines[ nPosition ], nil ) )
   METHOD getLineDetail( nPosition )                        INLINE ( ::getLine( nPosition  ) )
      METHOD getCloneLineDetail( nPosition )                INLINE ( oClone( ::getLineDetail( nPosition  ) ) )
      
   METHOD appendLineDetail( oDocumentLine )                 INLINE ( aadd( ::aLines, oDocumentLine ) )
   METHOD saveLineDetail( nPosition, oDocumentLine )        INLINE ( ::aLines[ nPosition  ] := oDocumentLine )

   METHOD getBruto()
   METHOD getBase()

   METHOD selectAll()                                       INLINE ( aeval( ::aLines, {|oLine| oLine:selectLine() } ) )
   METHOD unselectAll()                                     INLINE ( aeval( ::aLines, {|oLine| oLine:unSelectLine() } ) )
   METHOD anySelect()                                 

   METHOD getHeaderAlias()                                  INLINE ( ::oSender:getHeaderAlias() )
   METHOD getHeaderDictionary()                             INLINE ( ::oSender:getHeaderDictionary() )

   METHOD getLineAlias()                                    INLINE ( ::oSender:getLineAlias() )
   METHOD getLineDictionary()                               INLINE ( ::oSender:getLineDictionary() )

   METHOD sortingPleaseWait( expresion )   
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

METHOD addLines( oLine ) CLASS DocumentLines

   aAdd( ::aLines, oLine )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD addLinesObjects()

   ::addLines( DocumentLine():New() )

Return (  Self )

//---------------------------------------------------------------------------//

METHOD getBruto() CLASS DocumentLines

   local oLine
   local Bruto    := 0

   for each oLine in ::aLines
      Bruto       += oLine:getBruto()
   next

Return ( Bruto )

//---------------------------------------------------------------------------//

METHOD getBase() CLASS DocumentLines

   local oLine
   local Base     := 0

   for each oLine in ::aLines
      Base        += oLine:getBase()
   next

Return ( Base )

//---------------------------------------------------------------------------//

METHOD sortingPleaseWait( expresion, oColumn, oBrowse )

   msgRun( "Ordenando columna", "Espere por favor...", {|| ::sortBy( expresion ) } )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD sortBy( expresion )

   DEFAULT expresion    := "getCode"

   asort( ::aLines, , , {|x,y| oSend( x, expresion ) <= oSend( y, expresion ) } )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD anySelect()

   local anySelect   := .f.

   aeval( ::aLines, {|oLine| if( oLine:isSelectLine(), anySelect := .t., ) } )

Return ( anySelect )

//---------------------------------------------------------------------------//


