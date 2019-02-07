#include "FiveWin.ch"
#include "InKey.ch"
#include "constant.ch"
#include "xbrowse.ch"
#include "Report.ch"
#include "Factu.ch" 

#define CS_DBLCLKS            8
#define GWL_STYLE             -16
#define GWL_EXSTYLE           -20   // 2009-11-11

//----------------------------------------------------------------------------//

CLASS SQLXBrowse FROM TXBrowse 

   CLASSDATA lRegistered                        AS LOGICAL

   DATA oController

   DATA aHeaders                                AS ARRAY       INIT {}

   DATA cName                                   AS CHARACTER   INIT ""

   DATA cOriginal                               AS CHARACTER   INIT ""

   DATA cViewType                               AS CHARACTER   INIT "navigator"

   DATA bCancelEdit

   DATA bOnSkip

   METHOD New( oController, oWnd ) CONSTRUCTOR

   METHOD setRowSet( oRowSet )
   METHOD setHashList( oHashList )

   METHOD selectCurrent()                       INLINE ( ::Select( 0 ), ::Select( 1 ) )

   METHOD getColumnByHeaders()
   
   METHOD changeColumnOrder( oCol )
   METHOD selectColumnOrder( oCol )             INLINE ( ::changeColumnOrder( oCol ), ::Refresh() )
   
   METHOD getColumnByHeader( cHeader )
   METHOD getColumnBySortOrder( cSortOrder ) 
     
   METHOD getColumnOrder( cSortOrder )
   METHOD getColumnOrderHeader( cSortOrder )    INLINE ( if( !empty( ::getColumnOrder( cSortOrder ) ), ::getColumnOrder( cSortOrder ):cHeader, "" ) )

   METHOD getColumnSortOrder()
   METHOD getColumnSortOrientation()

   METHOD getColumnOrderByHeader( cHeader )  

   METHOD getFirstVisibleColumn()

   METHOD setColumnOrder( cSortOrder, cColumnOrientation )

   METHOD setFirstColumnOrder()

   // Actions-------------------------------------------------------------------

   METHOD ExportToExcel()

   METHOD MakeTotals( aCols )

   // States-------------------------------------------------------------------

   METHOD setName( cName )                      INLINE ( ::cName := cName )
   METHOD getName()                             INLINE ( ::cName )

   METHOD getOriginalState()                    INLINE ( ::cOriginal := ::saveState() )
   METHOD setOriginalState()                    INLINE ( if( !empty( ::cOriginal ), ::restoreState( ::cOriginal ), ) )

   METHOD setViewType( cViewType )              INLINE ( ::cViewType := cViewType )
   METHOD getViewType()                         INLINE ( ::cViewType )

   METHOD setChange( bChange )                  INLINE ( ::bChange := bChange )
   METHOD getChange()                           INLINE ( ::bChange )

   METHOD setGotFocus( bGotFocus )              INLINE ( ::bGotFocus := bGotFocus )
   METHOD getGotFocus()                         INLINE ( ::bGotFocus )

   METHOD setFilterInRowSet( cFilterExpresion )

   METHOD getSelectedCol()                      INLINE ( ::SelectedCol() )

   METHOD CancelEdit()                    

   METHOD GoUp( n )       

   METHOD GoDown( n, nKey )

   METHOD PageUp( n )

   METHOD PageDown( n )

   METHOD GoTop()

   METHOD GoBottom()

   METHOD LButtonDown( nRow, nCol, nFlags, lTouch )

   METHOD GoRight( lOffset, lRefresh )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController, oWnd ) CLASS SQLXBrowse 

   ::oController        := oController

   ::Super:New( oWnd )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD setRowSet( oRowSet ) CLASS SQLXBrowse

   if empty( oRowSet )
      RETURN ( nil )
   end if       

   ::lAutoSort       := .f.
   ::nRowHeight      := 20

   ::nDataType       := DATATYPE_USER
   ::bGoTop          := {|| oRowSet:goTop() }
   ::bGoBottom       := {|| oRowSet:goBottom() }
   ::bSkip           := {| n | oRowSet:Skipper( n ) }
   ::bBof            := {|| oRowSet:Bof() }
   ::bEof            := {|| oRowSet:Eof() }
   ::bKeyCount       := {|| oRowSet:keyCount() }
   ::bBookMark       := {| n | oRowSet:bookMark( n ) }
   ::bKeyNo          := {| n | oRowSet:bookMark( n ) }

   if ::oVScroll() != nil
      ::oVscroll():SetRange( 1, oRowSet:keyCount() )
   endif

   ::lFastEdit       := .t.

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD setHashList( oContainer ) CLASS SQLXBrowse

   ::lAutoSort       := .f.
   ::nDataType       := DATATYPE_USER
   ::nRowHeight      := 20
   ::bGoTop          := {|| oContainer:oHashList:GoTop() }
   ::bGoBottom       := {|| oContainer:oHashList:GoBottom() }
   ::bBof            := {|| oContainer:oHashList:Bof() }
   ::bEof            := {|| oContainer:oHashList:Eof() }
   ::bKeyCount       := {|| oContainer:oHashList:RecCount() }
   ::bSkip           := {| n | oContainer:oHashList:Skipper( n ) }
   ::bKeyNo          := {| n | iif( n == nil, oContainer:oHashList:RecNo(), oContainer:oHashList:GoTo( n ) ) }
   ::bBookMark       := {| n | iif( n == nil, oContainer:oHashList:RecNo(), oContainer:oHashList:GoTo( n ) ) }

   if ::oVScroll() != nil 
      ::oVscroll():SetRange( 1, oContainer:oHashList:RecCount() )
   endif

   ::lFastEdit       := .t.

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD ExportToExcel() CLASS SQLXBrowse

   local oError
   local oBlock

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      CursorWait()

      ::ToExcel()

      CursorWe()

   RECOVER USING oError
      
      msgStop( "Error exportando a excel." + CRLF + ErrorMessage( oError ) )
   
   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD MakeTotals() CLASS SQLXBrowse

   local uBm
   local aCols    := {}

   aeval( ::aCols,;
      {|oCol| if( !empty( oCol:nFooterType ), ( oCol:nTotal := 0.0, aadd( aCols, oCol ) ), ) } )

   if empty( aCols )
      RETURN ( nil )
   end if 

   uBm            := eval( ::bBookMark )

   eval( ::bGoTop )

   do 
      aeval( aCols, {|oCol| if( hb_isnumeric( oCol:Value ), oCol:nTotal += oCol:Value, ), oCol:nCount++ } )
   until ( ::skip( 1 ) < 1 )

   eval( ::bBookMark, uBm )

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD getColumnByHeaders() CLASS SQLXBrowse

   ::aHeaders  := {}

   aeval( ::aCols, { |o| if( !empty( o:cHeader ), aadd( ::aHeaders, o:cHeader ), ) } )

RETURN ( ::aHeaders )

//----------------------------------------------------------------------------//

METHOD changeColumnOrder( oCol ) CLASS SQLXBrowse

   if empty( oCol )
      RETURN ( Self )
   end if

   aeval( ::aCols, {|o| if( o:cSortOrder != oCol:cSortOrder, o:cOrder := "", ) } )    

   if empty( oCol:cOrder ) .or. oCol:cOrder == 'A'
      oCol:cOrder := 'D'
   else
      oCol:cOrder := 'A'
   end if 

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD getColumnByHeader( cHeader ) CLASS SQLXBrowse

   local nPosition   

   if !hb_ischar( cHeader )
      RETURN ( nil )
   end if 

   nPosition   := ascan( ::aCols, {|o| o:cHeader == cHeader } )

   if nPosition != 0
      RETURN ( ::aCols[ nPosition ] )
   end if 

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD getColumnOrder( cOrder ) CLASS SQLXBrowse

   local nPosition   

   if !empty( cOrder )
      nPosition   := ascan( ::aCols, {|o| o:cOrder == cOrder } )
   else 
      nPosition   := ascan( ::aCols, {|o| !empty( o:cOrder ) .and. !( o:lHide ) } )
   end if 

   if nPosition != 0
      RETURN ( ::aCols[ nPosition ] )
   end if 

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD getColumnSortOrder() CLASS SQLXBrowse

   local oColumnOrder   := ::getColumnOrder()

   if !empty( oColumnOrder )
      RETURN ( oColumnOrder:cSortOrder )
   end if 

RETURN ( "" )

//------------------------------------------------------------------------//

METHOD getColumnSortOrientation() CLASS SQLXBrowse

   local oColumnOrder   := ::getColumnOrder()

   if !empty( oColumnOrder )
      RETURN ( oColumnOrder:cOrder )
   end if 

RETURN ( "" )

//------------------------------------------------------------------------//

METHOD getColumnBySortOrder( cSortOrder ) CLASS SQLXBrowse

   local nPosition   

   if empty( cSortOrder )
      RETURN ( nil )
   end if 

   nPosition      := ascan( ::aCols, {|o| ( o:cSortOrder == cSortOrder ) .and. !( o:lHide ) } )
   if nPosition != 0
      RETURN ( ::aCols[ nPosition ] )
   end if 

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD getColumnOrderByHeader( cHeader ) CLASS SQLXBrowse

   local oCol     := ::getColumnByHeader( cHeader )

   if !empty( oCol )
      RETURN ( oCol:cSortOrder )
   end if 

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD getFirstVisibleColumn() CLASS SQLXBrowse

   local oCol

   for each oCol in ::aCols
      if !empty( oCol:cHeader ) .and. !( oCol:lHide )
         RETURN ( oCol )
      end if 
   next

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD setFilterInRowSet( cFilterExpresion ) CLASS SQLXBrowse

   ::oRowSet:setFilter( { || ::oRowSet:fieldGet( 1 ) == 1 } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD setColumnOrder( cSortOrder, cColumnOrientation ) CLASS SQLXBrowse

   local oColumn

   oColumn                    := ::getColumnBySortOrder( cSortOrder )

   if empty( oColumn )
      RETURN ( Self )
   end if 

   if !empty( cColumnOrientation )
      oColumn:cOrder          := cColumnOrientation
   end if 

RETURN ( nil )

//------------------------------------------------------------------------//

METHOD setFirstColumnOrder() CLASS SQLXBrowse

   local oColumn

   oColumn                    := ::getFirstVisibleColumn()

   if empty( oColumn )
      RETURN ( Self )
   end if 

   oColumn:cOrder             := 'D'

RETURN ( nil )

//------------------------------------------------------------------------//

METHOD CancelEdit() CLASS SQLXBrowse

   if !empty( ::bCancelEdit )
      eval( ::bCancelEdit, Self )
   end if 

RETURN ( ::Super():CancelEdit() )

//------------------------------------------------------------------------//

METHOD GoUp( n ) CLASS SQLXBrowse

   if !empty( ::bOnSkip ) .and. !eval( ::bOnSkip, Self )
      RETURN ( nil )
   end if 

RETURN ( ::Super:GoUp( n ) )

//------------------------------------------------------------------------//

METHOD GoDown( n, nKey ) CLASS SQLXBrowse

   if !empty( ::bOnSkip ) .and. !eval( ::bOnSkip, Self )
      RETURN ( nil )
   end if 

RETURN ( ::Super:GoDown( n, nKey ) )

//------------------------------------------------------------------------//

METHOD PageUp( n ) CLASS SQLXBrowse

   if !empty( ::bOnSkip ) .and. !eval( ::bOnSkip, Self )
      RETURN ( nil )
   end if 

RETURN ( ::Super:PageUp( n ) )

//------------------------------------------------------------------------//

METHOD PageDown( n ) CLASS SQLXBrowse

   if !empty( ::bOnSkip ) .and. !eval( ::bOnSkip, Self )
      RETURN ( nil )
   end if 

RETURN ( ::Super:PageDown( n ) )

//------------------------------------------------------------------------//

METHOD GoTop() CLASS SQLXBrowse

   if !empty( ::bOnSkip ) .and. !eval( ::bOnSkip, Self )
      RETURN ( nil )
   end if 

RETURN ( ::Super:GoTop() )

//------------------------------------------------------------------------//

METHOD GoBottom() CLASS SQLXBrowse

   if !empty( ::bOnSkip ) .and. !eval( ::bOnSkip, Self )
      RETURN ( nil )
   end if 

RETURN ( ::Super:GoBottom() )

//------------------------------------------------------------------------//

METHOD LButtonDown( nRow, nCol, nFlags, lTouch ) CLASS SQLXBrowse

   local nRowPos

   if !empty( ::bOnSkip )
   
      nRowPos     := int( ( nRow - ::FirstRow() ) / ::nRowHeight ) + 1

      if ( nRowPos != ::nRowSel ) .and. !eval( ::bOnSkip, Self )
         RETURN ( nil )
      end if 
      
   end if 

RETURN ( ::Super:LButtonDown( nRow, nCol, nFlags, lTouch ) )

//------------------------------------------------------------------------//

METHOD GoRight( lOffset, lRefresh ) CLASS SQLXBrowse

   local nLen
   local oCol
   local lColSel
   local oSelCol
   local oLastCol
   local oNextCol

   ::CancelEdit()

   oLastcol    := ::aCols[ ATail( ::aDisplay ) ]

   oSelCol     := ::SelectedCol()
   if oSelCol == ::hRightCol
      RETURN ( nil )
   end if 

   if oSelCol == oLastCol
      if ::hRightCol != nil
         ::nColSel   := ::hRightCol:nPos
         ::GetDisplayCols()
         ::DrawLine( .t. )
      endif
      RETURN ( nil )
   endif

   DEFAULT lOffset  := .f.,;
           lRefresh := .t.

   lColSel  := .t.
   nLen     := len( ::aDisplay )

   logwrite( if( lOffset, "lOffset = .t.", "lOffset = .f." ) )

   if lOffSet

      if ::IsDisplayPosVisible( oLastCol:nPos, .t. )
         ::nColSel++
         if lRefresh
            ::Super:Refresh( .t. )
         endif
      else
         if ::nColOffSet < ( nLen - ::nFreeze )
            ::nColOffSet++
            ::GetDisplayCols()
            if lRefresh
               ::Super:Refresh( ::FullPaint() )
            endif
         endif
      endif

   else

      ::nColSel++

      logwrite( "suma nColSel" + str( ::nColSel ) )

      ::GetDisplayCols()

      oCol     := ::SelectedCol()

      logwrite( "oCol:nPos" + str( oCol:nPos ) )

      do while ! ::IsDisplayPosVisible( oCol:nPos, .t. ) .and. ::nColSel > ( ::nFreeze + 1 )
         ::nColOffSet++
         ::nColSel--
         ::GetDisplayCols()
      enddo

      if lRefresh
         ::Super:Refresh( ::FullPaint() )
      endif

   endif

   if ::oHScroll != nil
      ::oHScroll:GoDown()
   endif

   ::Change( .f. )

RETURN ( nil )

//----------------------------------------------------------------------------//

FUNCTION EditGetkeyDown( Self, nKey ) 

   local lExit       
   local lMultiGet   

   if !hb_isobject( ::oEditGet )
      RETURN nil
   end if

   lExit          := .f.
   lMultiGet      := ::oEditGet:IsKindOf( "TMULTIGET" )

   do case
      case nKey == VK_ESCAPE

           lExit              := .t.
           ::oEditGet:bValid  := nil

      case nKey == VK_RETURN

           if lMultiGet    //Empty( ::cEditPicture ) .and. ::oBrw:nDataLines > 1
              if ! GetKeyState( VK_CONTROL )
                 lExit        := .t.
              endif
           else
              lExit           := .t.
           endif

      case nKey == VK_TAB

           lExit  := .t.

      case nKey == VK_DOWN .or. nKey == VK_UP

           if !lMultiGet      
              lExit := .t.
           endif

      case ::oBrw:lExitGetOnTypeOut .and. ;
           ( nKey == VK_SPACE .or. ( nKey > 47 .and. nKey < 96 ) ) .and. ;
           ::oEditGet:oGet:TypeOut .and. !Set( _SET_CONFIRM )

           lExit    := .t.
           ::oEditGet:nLastKey := VK_RETURN
           ::oEditGet:End()
           ::PostEdit()
           if ::oBrw:lFastEdit
              PostMessage( ::oBrw:hWnd, WM_KEYDOWN, nKey )
           endif

           return nil

   endcase

   If lExit .and. ::nEditType != EDIT_DATE
      if ::oEditGet != nil     // AL 2007-07-10
         ::oEditGet:nLastKey := nKey
         ::oEditGet:End()
      endif
   else
      if lExit
         ::PostEdit()
      endif
   Endif

return nil

//----------------------------------------------------------------------------//

