#include "FiveWin.ch"

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
   DATA   bAction
   DATA   Cargo

   METHOD New( cPrompt, nLevel, hBmpOpen, hBmpClose ) CONSTRUCTOR

   METHOD Open() INLINE ;
                  If( ! ::lOpened .and. ::oTree != nil, ::lOpened := .t.,)

   METHOD Close() INLINE  If( ::lOpened, ::lOpened := .f.,)

   METHOD Skip( @n )
   METHOD ItemNo()

   METHOD GetNext() INLINE If( ::lOpened, ::oTree:oFirst, ::oNext )
   METHOD GetPrev()

   METHOD GetText() INLINE If( ::oTree != nil .and. ::lOpened, " - ", ;
                           If( ::oTree != nil, " + ", "   " ) ) + ::cDraw + ::cPrompt

   METHOD GetLabel()

   METHOD Draw( cPrevDraw )

   METHOD SetNext( oItem ) INLINE ::oNext := oItem,;
          If( ::oTree != nil, ::oTree:oLast:SetNext( oItem ),)

   METHOD SetTree( oTree ) INLINE   If( oTree:nCount() > 0, ;
                                       ( oTree:oFirst:oPrev   := Self, ;
                                         oTree:oLast:SetNext( ::oNext ), ;
                                         oTree:SetLevel( ::nLevel + 1 ), ;
                                         ::oTree  := oTree, ;
                                         .t. ), .f. )

   METHOD Toggle() INLINE If( ::lOpened, ::Close(), ::Open() )

   METHOD ColSizes()

   METHOD Delete( oRoot ) //INLINE ( ::oPrev:oNext := ::oNext, ::oNext:oPrev := ::oPrev )

   METHOD Add( cPrompt )  // cPrompt can be oItem also

   METHOD AddChild( ocItem )

   METHOD SetText( cPrompt ) INLINE ::cPrompt := cPrompt

   METHOD MoveUp( oRoot )
   METHOD MoveDown( oRoot )
   METHOD Promote()
   METHOD Demote()
   METHOD Sort( oRoot )
   METHOD Parent()
   METHOD EvalParents( bAction )

   METHOD End()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cPrompt, nLevel, hBmpOpen, hBmpClose, bAction, uCargo ) CLASS TTreeItem

   DEFAULT aLines := aTreeBmps()

   ::cDraw     = ""
   ::cPrompt   = cPrompt
   ::lOpened   = .f.
   ::nLevel    = nLevel
   ::hBmpOpen  = hBmpOpen
   ::hBmpClose = hBmpClose
   ::bAction   = bAction
   ::Cargo     = uCargo

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

METHOD ItemNo() CLASS TTreeItem

   local nRec  := - 10000

   ::Skip( @nRec )

return -nRec + 1

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
   AAdd( aCols, 300 )

return aCols

//----------------------------------------------------------------------------//

METHOD Delete( oRoot ) CLASS TTreeItem

   local oParent  := ::Parent()
   local oTree    := If( oParent == nil, oRoot, oParent:oTree )

   if ( ::oPrev == nil .or. ::oNext == nil ) .and. oRoot == nil
      return .f.
   endif

   if ( ::oPrev == nil .or. ::oPrev:nLevel < ::nLevel ) .and. ;
      ( ::oNext == nil .or. ::oNext:nLevel < ::nLevel )
      // only one item in the parent's tree
      if oParent == nil
         oRoot:oFirst := oRoot:oLast := nil
         return .t.
      else
         oParent:Close()
         oParent:oTree  := nil
         return .t.
      endif
   endif

   if ::oPrev == nil .or. ::oPrev:nLevel < ::nLevel
      ::oNext:oPrev     := oParent
      oTree:oFirst      := ::oNext
   else
      ::oPrev:SetNext( ::oNext )
   endif

   if ::oNext == nil .or. ::oNext:nLevel < ::nLevel
      oTree:oLast       := ::oPrev
   else
      ::oNext:oPrev     := ::oPrev
   endif

   if ::oTree != nil
      ::oTree:oLast:oNext  := nil
   endif

return .t.

//----------------------------------------------------------------------------//

METHOD Add( cPrompt ) CLASS TTreeItem  // cPrompt can be oItem aso

   local oItem := TTreeItem():New( cPrompt, ::nLevel )
   local oParent  := ::Parent()

   if ValType( cPrompt ) == 'O'
      if cPrompt:IsKindOf( 'TTREEITEM' )
         oItem          := cPrompt
         oItem:nLevel   := ::nLevel
         if oItem:oTree != nil
            oItem:oTree:SetLevel( ::nLevel + 1 )
         endif
      else
         return nil
      endif
   else
      oItem := TTreeItem():New( cPrompt, ::nLevel )
   endif

   oItem:oPrev   = Self
   oItem:SetNext( ::oNext )
   ::SetNext( oItem )

   if oItem:oNext != nil
      if oItem:oNext:nLevel == ::nLevel
         oItem:oNext:oPrev       = oItem
      elseif oItem:oNext:nLevel < ::nLevel
         oParent:oTree:oLast     = oItem
      endif
   endif

return oItem

//----------------------------------------------------------------------------//

METHOD AddChild( ocItem, lFirst ) CLASS TTreeItem

   local oItem, oTree

   if ValType( ocItem ) == 'O'
      if ocItem:IsKindOf( "TTREEITEM" )
         oItem          := ocItem
         oItem:nLevel   := ::nLevel + 1
         if oItem:oTree != nil
            oItem:oTree:SetLevel( ::nLevel + 2 )
         endif
      else
         return nil
      endif
   else
      oItem := TTreeItem():New( ocItem, ::nLevel + 1 )
   endif

   if ::oTree == nil
      oTree          := TLinkList():New()
      oTree:oFirst   := oItem
      oTree:oLast    := oItem
      ::SetTree( oTree )
   else
      if lFirst == .t.
         oItem:oPrev             := ::oTree:oFirst:oPrev
         oItem:SetNext( ::oTree:oFirst )
         ::oTree:oFirst:oPrev    := oItem
         ::oTree:oFirst          := oItem
      else
         ::oTree:oLast:Add( oItem )
      endif
   endif

return oItem

//----------------------------------------------------------------------------//

METHOD MoveUp( oRoot ) CLASS TTreeItem

   local oAfter

   if ::oPrev != nil .and. ::oPrev:nLevel == ::nLevel
      oAfter      := ::oPrev:oPrev
      if oAfter == nil
         if oRoot != nil
            ::Delete( oRoot )
            ::SetNext( ::oPrev )
            ::oPrev:oPrev  := Self
            ::oPrev        := nil
            oRoot:oFirst   := Self
            return .t.
         endif
      else
         ::Delete( oRoot )
         if oAfter:nLevel == ::nLevel
            oAfter:Add( Self )
         else
            oAfter:AddChild( Self, .t. )
         endif
         return .t.
      endif
   endif

return .f.

//----------------------------------------------------------------------------//

METHOD MoveDown( oRoot ) CLASS TTreeItem

   local oAfter   := ::oNext

   if oAfter != nil .and. oAfter:nLevel == ::nLevel
      if ::Delete( oRoot )
         oAfter:Add( Self )
         return .t.
      endif
   endif

return .f.

//----------------------------------------------------------------------------//

METHOD Promote() CLASS TTreeItem

   local oParent  := ::Parent()

   if oParent != nil
      ::Delete()
      oParent:Add( Self )
      return .t.
   endif

return .f.

//----------------------------------------------------------------------------//

METHOD  Demote() CLASS TTreeItem

   local oPrev := ::oPrev

   if ::oPrev != nil .and. ::oPrev:nLevel == ::nLevel
      ::Delete()
      oPrev:AddChild( Self )
      oPrev:Open()
      return .t.
   endif

return .f.

//----------------------------------------------------------------------------//

METHOD Sort( oRoot ) CLASS TTreeItem

   local oParent  := ::Parent()
   local oTree    := If( oParent == nil, oRoot, oParent:oTree )

   if oTree != nil
      oTree:Sort()
   endif

return Self

//----------------------------------------------------------------------------//

METHOD Parent( nParent ) CLASS TTreeItem

   local oItem

   if ::nLevel > 1
      DEFAULT nParent   := ::nLevel - 1
      if nParent < 0
         nParent        := ::nLevel + nParent
      endif
      nParent           := Max( 1, Min( nParent, ::nLevel - 1 ) )
      oItem             := Self
      do while ( oItem := oItem:GetPrev() ):nLevel > nParent
      enddo
   endif

return oItem

//----------------------------------------------------------------------------//

METHOD EvalParents( bAction ) CLASS TTreeItem

   local oParent := ::Parent()

   do while oParent != nil
      Eval( bAction, oParent, Self )
      oParent  := oParent:Parent()
   enddo

return Self

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

   local aTemp := aLines

   aLines = nil

return aTemp

//----------------------------------------------------------------------------//
