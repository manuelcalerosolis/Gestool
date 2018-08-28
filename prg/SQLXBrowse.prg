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

   METHOD New( oController, oWnd )

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

   METHOD getSelectedCol()                      INLINE ::SelectedCol()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController, oWnd ) 

   ::oController     := oController

   ::Super:New( oWnd )

   ::lAutoSort       := .t.
   ::l2007           := .f.
   ::bClrSel         := {|| { CLR_BLACK, Rgb( 221, 221, 221 ) } }
   ::bClrSelFocus    := {|| { CLR_BLACK, Rgb( 221, 221, 221 ) } }
   ::lSortDescend    := .f. 

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD setRowSet( oRowSet )

   if empty( oRowSet )
      RETURN ( nil )
   end if       

   ::lAutoSort       := .f.
   ::nDataType       := DATATYPE_USER
   ::nRowHeight      := 20
   ::bGoTop          := {|| oRowSet:Get():GoTop() }
   ::bGoBottom       := {|| oRowSet:Get():GoBottom() }
   ::bBof            := {|| oRowSet:Get():Bof() }
   ::bEof            := {|| oRowSet:Get():Eof() }
   ::bKeyCount       := {|| oRowSet:Get():RecCount() }
   ::bSkip           := {| n | oRowSet:Get():Skipper( n ) }
   ::bKeyNo          := {| n | oRowSet:Get():RecNo() }
   ::bBookMark       := {| n | iif( n == nil, oRowSet:Get():RecNo(), oRowSet:Get():GoTo( n ) ) }

   if ::oVScroll() != nil
      ::oVscroll():SetRange( 1, oRowSet:Get():RecCount() )
   endif

   ::lFastEdit       := .t.

RETURN nil

//----------------------------------------------------------------------------//

METHOD setHashList( oContainer )

   ::lAutoSort       := .f.
   ::nDataType       := DATATYPE_USER
   ::nRowHeight      := 20
   ::bGoTop          := {|| oContainer:oHashList:GoTop() }
   ::bGoBottom       := {|| oContainer:oHashList:GoBottom() }
   ::bBof            := {|| oContainer:oHashList:Bof() }
   ::bEof            := {|| oContainer:oHashList:Eof() }
   ::bKeyCount       := {|| oContainer:oHashList:RecCount() }
   ::bSkip           := {| n | oContainer:oHashList:Skipper( n ) }
   ::bKeyNo          := {| n | oContainer:oHashList:RecNo() }
   ::bBookMark       := {| n | iif( n == nil, oContainer:oHashList:RecNo(), oContainer:oHashList:GoTo( n ) ) }

   if ::oVScroll() != nil 
      ::oVscroll():SetRange( 1, oContainer:oHashList:RecCount() )
   endif

   ::lFastEdit       := .t.

RETURN nil

//----------------------------------------------------------------------------//

METHOD ExportToExcel()

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

RETURN nil

//----------------------------------------------------------------------------//

METHOD MakeTotals() 

   local uBm
   local aCols    := {}

   aeval( ::aCols,;
      {|oCol| if( !empty( oCol:nFooterType ), ( oCol:nTotal := 0.0, aadd( aCols, oCol ) ), ) } )

   if empty( aCols )
      RETURN ( Self )
   end if 

   uBm            := eval( ::bBookMark )

   eval( ::bGoTop )

   do 
      aeval( aCols, {|oCol| oCol:nTotal  += oCol:Value, oCol:nCount++ } )
   until ( ::skip( 1 ) < 1 )

   eval( ::bBookMark, uBm )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD getColumnByHeaders()

   ::aHeaders  := {}

   aeval( ::aCols, { |o| if( !empty( o:cHeader ), aadd( ::aHeaders, o:cHeader ), ) } )

RETURN ( ::aHeaders )

//----------------------------------------------------------------------------//

METHOD changeColumnOrder( oCol )

   if empty( oCol )
      RETURN ( Self )
   end if

   aeval( ::aCols, {|o| if( o:cSortOrder != oCol:cSortOrder, o:cOrder := "", ) } )    

   if empty( oCol:cOrder ) .or. oCol:cOrder == 'A'
      oCol:cOrder := 'D'
   else
      oCol:cOrder := 'A'
   end if 

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD getColumnByHeader( cHeader )

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

METHOD getColumnOrder( cOrder )

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

METHOD getColumnSortOrder()

   local oColumnOrder   := ::getColumnOrder()

   if !empty( oColumnOrder )
      RETURN ( oColumnOrder:cSortOrder )
   end if 

RETURN ( "" )

//------------------------------------------------------------------------//

METHOD getColumnSortOrientation()

   local oColumnOrder   := ::getColumnOrder()

   if !empty( oColumnOrder )
      RETURN ( oColumnOrder:cOrder )
   end if 

RETURN ( "" )

//------------------------------------------------------------------------//

METHOD getColumnBySortOrder( cSortOrder )

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

METHOD getColumnOrderByHeader( cHeader )

   local oCol     := ::getColumnByHeader( cHeader )

   if !empty( oCol )
      RETURN ( oCol:cSortOrder )
   end if 

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD getFirstVisibleColumn()

   local oCol

   for each oCol in ::aCols
      if !empty( oCol:cHeader ) .and. !( oCol:lHide )
         RETURN ( oCol )
      end if 
   next

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD setFilterInRowSet( cFilterExpresion )

   ::oRowSet:setFilter( { || ::oRowSet:fieldGet( 1 ) == 1 } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD setColumnOrder( cSortOrder, cColumnOrientation )

   local oColumn

   oColumn                    := ::getColumnBySortOrder( cSortOrder )

   if empty( oColumn )
      RETURN ( Self )
   end if 

   if !empty( cColumnOrientation )
      oColumn:cOrder          := cColumnOrientation
   end if 

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD setFirstColumnOrder()

   local oColumn

   oColumn                    := ::getFirstVisibleColumn()

   if empty( oColumn )
      RETURN ( Self )
   end if 

   oColumn:cOrder             := 'D'

RETURN ( Self )

//------------------------------------------------------------------------//

