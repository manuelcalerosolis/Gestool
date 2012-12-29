#include "FiveWin.Ch"

#define ID_EMPTY      Chr( 0 )
#define ID_VERTLINE   Chr( 1 )
#define ID_VERTHORZ   Chr( 2 )
#define ID_CORNLINE   Chr( 3 )
#define ID_VERTHORZP  Chr( 4 )
#define ID_VERTHORZM  Chr( 5 )
#define ID_CORNLINEP  Chr( 6 )
#define ID_CORNLINEM  Chr( 7 )

static aLines

//----------------------------------------------------------------------------//

CLASS TTreeItem

   DATA   cDraw, cPrompt
   DATA   oPrev, oNext
   DATA   oTree
   DATA   lOpened
   DATA   nLevel
   DATA   hBmpOpen, hBmpClose
   DATA   Cargo

   METHOD New( cPrompt, nLevel, hBmpOpen, hBmpClose ) CONSTRUCTOR

   METHOD Open() INLINE ;
                  If( ! ::lOpened .and. ::oTree != nil, ::lOpened := .t.,)

   METHOD Close() INLINE  If( ::lOpened, ::lOpened := .f.,)

   METHOD Skip( @n )

   METHOD GetNext() INLINE If( ::lOpened, ::oTree:oFirst, ::oNext )
   METHOD GetPrev()

   METHOD GetText() INLINE If( ::oTree != nil .and. ::lOpened, " - ", ;
                           If( ::oTree != nil, " + ", "   " ) ) + ::cDraw + ::cPrompt

   METHOD GetLabel()

   METHOD Draw( cPrevDraw )

   METHOD SetNext( oItem ) INLINE ::oNext := oItem,;
          If( ::oTree != nil, ::oTree:oLast:SetNext( oItem ),)

   METHOD Toggle() INLINE If( ::lOpened, ::Close(), ::Open() )

   METHOD ColSizes()

   METHOD Add( cPrompt )

   METHOD Delete() INLINE ::oPrev:oNext := ::oNext

   METHOD SetText( cPrompt ) INLINE ::cPrompt := cPrompt

   METHOD End()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cPrompt, nLevel, hBmpOpen, hBmpClose ) CLASS TTreeItem

   DEFAULT aLines := aTreeBmps()

   ::cDraw     = ""
   ::cPrompt   = cPrompt
   ::lOpened   = .f.
   ::nLevel    = nLevel
   ::hBmpOpen  = hBmpOpen
   ::hBmpClose = hBmpClose

return Self

//----------------------------------------------------------------------------//

METHOD Skip( n ) CLASS TTreeItem

   local nCount := 0
   local oItem  := Self

   if n > 0
      while nCount < n .and. oItem:GetNext() != nil
          oItem = oItem:GetNext()
          nCount++
      end
      n = nCount
   endif

   if n < 0
      while nCount < -n .and. oItem:GetPrev() != nil
         oItem = oItem:GetPrev()
         nCount++
      end
      n = -nCount
   endif

return oItem

//----------------------------------------------------------------------------//

METHOD GetPrev() CLASS TTreeItem

   if ::oPrev != nil
      if ::oPrev:nLevel < ::nLevel
         return ::oPrev
      else
         if ::oPrev:lOpened
            return ::oPrev:oTree:GetLast()
         else
            return ::oPrev
         endif
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Draw( cPrevDraw ) CLASS TTreeItem

   DEFAULT cPrevDraw := ""

   ::cDraw = cPrevDraw + ;
             If( ::oPrev != nil,;
             If( ::oNext != nil .and. ::oNext:nLevel == ::nLevel,;
             If( ::oTree != nil,;
             If( ::lOpened, ID_VERTHORZM, ID_VERTHORZP ), ID_VERTHORZ ),;
             If( ::oTree != nil,;
             If( ::lOpened, ID_CORNLINEM, ID_CORNLINEP ), ID_CORNLINE ) ),;
             ID_VERTHORZ )

   If ::oTree != nil
      ::oTree:Draw( cPrevDraw + If( ::oNext != nil,;
                    If( ::oNext:nLevel < ::nLevel, ;
                    if( ::lOpened, ID_VERTLINE, ID_EMPTY), ID_VERTLINE ),;
                        ID_EMPTY ) )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD GetLabel() CLASS TTreeItem

   local aLabel := Array( ::nLevel + 1 )
   local n, nLine

   AFill( aLabel, 0 )
   AAdd( aLabel, ::cPrompt )

   for n = 1 to Len( ::cDraw )
       nLine = Asc( SubStr( ::cDraw, n, 1 ) )
       if nLine != 0
          aLabel[ n ] = aLines[ nLine ]
       endif
   next

   if ::oTree != nil
      if ::oNext != nil
         if ::oNext:nLevel < ::nLevel
            aLabel[ ::nLevel ] = If( ::lOpened, aLines[ 7 ], aLines[ 6 ] )
         else
            aLabel[ ::nLevel ] = If( ::lOpened, aLines[ 5 ], aLines[ 4 ] )
         endif
      else
         aLabel[ ::nLevel ] = If( ::lOpened, aLines[ 7 ], aLines[ 6 ] )
      endif
   endif

   aLabel[ ::nLevel + 1 ] = If( ::lOpened,;
                                If( ::hBmpClose != nil, ::hBmpClose, 0 ),;
                                If( ::hBmpOpen != nil, ::hBmpOpen, 0 ) )

return aLabel

//----------------------------------------------------------------------------//

METHOD ColSizes() CLASS TTreeItem

   local aCols := Array( ::nLevel + 1 )

   AFill( aCols, 16 )
   AAdd( aCols, 400 )

return aCols

//----------------------------------------------------------------------------//

METHOD Add( cPrompt ) CLASS TTreeItem

   local oItem := TTreeItem():New( cPrompt, ::nLevel )
   local oPrev

   oItem:oPrev   = Self
   oItem:oNext   = ::oNext
   if ::oTree != nil
      ::oTree:oLast:oNext = oItem
   endif
   ::oNext = oItem

   while ( oPrev := ::GetPrev() ):nLevel >= ::nLevel
      // MsgInfo( oPrev:cPrompt )
   end

   oPrev:oTree:oLast = oItem

return oItem

//----------------------------------------------------------------------------//

METHOD End() CLASS TTreeItem

   if ! Empty( ::hBmpOpen )
      DeleteObject( ::hBmpOpen )
      ::hBmpOpen = 0
   endif

   if ! Empty( ::hBmpClose )
      DeleteObject( ::hBmpClose )
      ::hBmpClose = 0
   endif

return nil

//----------------------------------------------------------------------------//

function GetTreeBmps()

return aLines

//----------------------------------------------------------------------------//