#include "FiveWin.ch"
#include "InKey.ch"
#include "constant.ch"
#include "xbrowse.ch"
#include "Report.ch"
#include "Factu.ch" 

//----------------------------------------------------------------------------//

CLASS SQLXBrowse FROM TXBrowse

   CLASSDATA lRegistered      AS LOGICAL

   DATA  cOriginal            AS CHARACTER   INIT ""
   DATA  cName                AS CHARACTER   INIT ""

   DATA  aHeaders             AS ARRAY       INIT {}

   DATA  lOnProcess           AS LOGIC       INIT .f.

   DATA  nVScrollPos

   ACCESS BookMark            INLINE Eval( ::bBookMark )
   ASSIGN BookMark(u)         INLINE Eval( ::bBookMark, u )

   METHOD New( oWnd )

   METHOD setModel( oModel )  

   METHOD setOriginal()       INLINE ( ::RestoreState( ::cOriginal ) )
   METHOD getOriginal()       INLINE ( ::cOriginal := ::SaveState() )

   METHOD refreshCurrent()    INLINE ( ::Refresh(), ::Select( 0 ), ::Select( 1 ) )

   METHOD getColumnHeaders()
   METHOD selectColumnOrder( oCol )
   
   METHOD getColumnHeader( cHeader )
   METHOD getColumnOrder( cSortOrder )

   METHOD RButtonDown( nRow, nCol, nFlags )

   METHOD ExportToExcel()

   METHOD MakeTotals( aCols )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oWnd ) 

   ::Super:New( oWnd )

   ::lAutoSort       := .t.
   ::l2007           := .f.
   ::bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }
   ::lSortDescend    := .f. 

RETURN ( Self )

//------------------------------------------------------------------------//
/*
Montamos el menu------------------------------------------------------------
*/

METHOD RButtonDown( nRow, nCol, nFlags )

   local oCol
   local oMenu
   local bMenuSelect

   oMenu             := MenuBegin( .t. )
   bMenuSelect       := ::bMenuSelect

   ::bMenuSelect     := nil

   MenuAddItem( "Columnas", "Columnas de la rejilla de datos", .f., .t., , , "gc_table_selection_column_16", oMenu )

      MenuBegin( .f., , , .f., .f., , , , , , , , , , , , .f., .t., .f., .t. )

         for each oCol in ::aCols
            MenuAddItem( oCol:cHeader, , !oCol:lHide, ( Len( ::aDisplay ) != 1 .or. oCol:nPos != 1 ), GenMenuBlock( oCol ) )
         next

      MenuEnd()

      MenuAddItem( "Seleccionar &todo", "Selecciona todas las filas de la rejilla", .f., .t., {|| ::SelectAll() }, , "gc_table_selection_all_16", oMenu )

      MenuAddItem( "&Quitar selección", "Quita la selección de todas las filas de la rejilla", .f., .t., {|| ::SelectNone() }, , "gc_table_16", oMenu )

      MenuAddItem()

      MenuAddItem( "Exportar a E&xcel", "Exportar rejilla de datos a Excel", .f., .t., {|| ::ExportToExcel() }, , "gc_spreadsheet_sum_16", oMenu )

   MenuEnd() 

   oMenu:Activate( nRow, nCol, Self )

   ::bMenuSelect     := bMenuSelect

   oMenu:end()

   ::SetFocus()

RETURN ( Self )

//----------------------------------------------------------------------------//

static function GenMenuBlock( oCol )

RETURN {|| iif( oCol:lHide, oCol:Show(), oCol:Hide() ) }

//----------------------------------------------------------------------------//

METHOD setModel( oModel )

   ::lAutoSort        := .f.
   ::nDataType        := DATATYPE_USER
   ::bGoTop           := {|| oModel:oRowSet:GoTop() }
   ::bGoBottom        := {|| oModel:oRowSet:GoBottom() }
   ::bBof             := {|| oModel:oRowSet:Bof() }
   ::bEof             := {|| oModel:oRowSet:Eof() }
   ::bSkip            := {| n | iif( n == nil, n := 1, ), oModel:oRowSet:Skipper( n ) }
   ::bKeyNo           := {| n | oModel:oRowSet:RecNo() }
   ::bBookMark        := {| n | iif( n == nil, oModel:oRowSet:RecNo(), oModel:oRowSet:GoTo( n ) ) }
   ::bKeyNo           := {| n | iif( n == nil, oModel:oRowSet:RecNo(), oModel:oRowSet:GoTo( n ) ) }
   ::bKeyCount        := {|| oModel:oRowSet:RecCount() }

   if ::oVScroll() != nil
      ::oVscroll():SetRange( 1, oModel:oRowSet:RecCount() )
   endif

   ::lFastEdit        := .t.

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

METHOD MakeTotals( aCols ) 

   local uBm, n, nCols, oCol, nValue
   local bCond    := { |u,o| u != nil }

   if aCols == nil
      aCols    := {}
      for each oCol in ::aCols
         WITH OBJECT oCol
            if ValType( :nTotal ) == 'N' .or. ! Empty( :nFooterType )
               AAdd( aCols, oCol )
            endif
         END
      next
   else
      if ValType( aCols ) == 'O'
         aCols := { aCols }
      endif
      for n := 1 to Len( aCols )
         if Empty( aCols[ n ]:nFooterType )
            ADel( aCols, n )
            ASize( aCols, Len( aCols ) - 1 )
         endif
      next
   endif

   if ! Empty( aCols )

      for each oCol in aCols
         WITH OBJECT oCol
            DEFAULT :nFooterType := AGGR_SUM
            :nTotal := :nTotalSq := 0.0
            :nCount := 0
            if :nFooterType == AGGR_MIN .or. :nFooterType == AGGR_MAX
               :nTotal := nil
            endif
         END
      next

      nCols    := Len( aCols )

      uBm      := (::cAlias)->(Recno()) // ::BookMark()

      Eval( ::bGoTop )
      do
         for each oCol in aCols
            WITH OBJECT oCol
               nValue   := :Value
               if Eval( IfNil( :bSumCondition, bCond ), nValue, oCol )
                  if :nFooterType == AGGR_COUNT
                     :nCount++
                  elseif ValType( nValue ) == 'N'
                     if :nFooterType == AGGR_MIN
                        :nTotal  := If( :nTotal == nil, nValue, Min( nValue, :nTotal ) )
                     elseif :nFooterType == AGGR_MAX
                        :nTotal  := If( :nTotal == nil, nvalue, Max( nValue, :nTotal ) )
                     else
                        :nTotal  += nValue
                        :nCount++
                        if lAnd( :nFooterType, AGGR_STD )
                           :nTotalSq   += ( nValue * nValue )
                        endif
                     endif
                  endif
               endif
            END
         next n
      until ( ::Skip( 1 ) < 1 )

      if !Empty( ::cAlias )
         (::cAlias)->(dbGoTo( uBm )) // ::BookMark( uBm )
      end if

   endif

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD getColumnHeaders()

   ::aHeaders := {}

   aeval( ::aCols, { |o| if( !empty( o:cHeader ), aadd( ::aHeaders, o:cHeader ), ) } )

RETURN ( ::aHeaders )

//----------------------------------------------------------------------------//

METHOD selectColumnOrder( oCol, cOrder )

   if empty( oCol )
      RETURN ( Self )
   end if

   aeval( ::aCols, {|o| if( o:cSortOrder != oCol:cSortOrder, o:cOrder := "", ) } )    

   if empty( cOrder )
      if oCol:cOrder == 'D' .or. empty( oCol:cOrder )
         oCol:cOrder    := 'A'
      else
         oCol:cOrder    := 'D'
      end if 
   else
      oCol:cOrder       := cOrder
   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD getColumnHeader( cHeader )

   local nPosition   := ascan( ::aCols, {|o| o:cHeader == cHeader } )

   if nPosition != 0
      RETURN ( ::aCols[ nPosition ] )
   end if 

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD getColumnOrder( cSortOrder )

   local nPosition   := ascan( ::aCols, {|o| o:cSortOrder == cSortOrder } )

   if nPosition != 0
      RETURN ( ::aCols[ nPosition ] )
   end if 

RETURN ( nil )

//----------------------------------------------------------------------------//