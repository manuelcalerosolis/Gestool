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

   DATA  aHeaders                               AS ARRAY       INIT {}

   DATA  lOnProcess                             AS LOGIC       INIT .f.

   DATA  nVScrollPos

   METHOD New( oWnd )

   METHOD setRowSet( oModel )
   METHOD runBookMark(n, oModel )

   METHOD refreshCurrent()                      INLINE ( ::Refresh(), ::Select( 0 ), ::Select( 1 ) )

   METHOD getColumnByHeaders()
   METHOD selectColumnOrder( oCol )
   
   METHOD selectColumnOrderByHeader( cHeader )  INLINE ( ::selectColumnOrder( ::getColumnByHeader( cHeader ) ) )

   METHOD getColumnByHeader( cHeader )
   METHOD getColumnOrder( cSortOrder )
   METHOD getColumnOrderByHeader( cHeader )  

   METHOD getFirstVisibleColumn()

   METHOD RButtonDown( nRow, nCol, nFlags )

   METHOD ExportToExcel()

   METHOD MakeTotals( aCols )

   // States-------------------------------------------------------------------

   DATA  cName                                  AS CHARACTER   INIT ""

   METHOD setName( cName )                      INLINE ( ::cName := cName )
   METHOD getName( cName )                      INLINE ( ::cName )

   DATA  cOriginal                              AS CHARACTER   INIT ""

   METHOD getOriginalView()                     INLINE ( ::cOriginal := ::SaveState() )
   METHOD setOriginalView()                     INLINE ( if( !empty( ::cOriginal ), ::restoreState( ::cOriginal ), ) )

   METHOD saveView()
   METHOD setView()

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

      MenuAddItem()

      MenuAddItem( "Guardar vista actual", "Guarda la vista actual de la rejilla de datos", .f., .t., {|| ::saveView() }, , "gc_table_selection_column_disk_16", oMenu )

      MenuAddItem( "Cargar vista por defecto", "Carga la vista por defecto de la rejilla de datos", .f., .t., {|| ::setOriginalView() }, , "gc_table_selection_column_refresh_16", oMenu )

   MenuEnd() 

   oMenu:Activate( nRow, nCol, Self )

   ::bMenuSelect     := bMenuSelect

   oMenu:end()

   ::SetFocus()

RETURN ( Self )

//----------------------------------------------------------------------------//

STATIC FUNCTION GenMenuBlock( oCol )

RETURN {|| iif( oCol:lHide, oCol:Show(), oCol:Hide() ) }

//----------------------------------------------------------------------------//

METHOD setRowSet( oModel )

   ::lAutoSort       := .f.
   ::nDataType       := DATATYPE_USER
   ::nRowHeight      := 20
   ::bGoTop          := {|| oModel:getRowSet():GoTop() }
   ::bGoBottom       := {|| oModel:getRowSet():GoBottom() }
   ::bBof            := {|| oModel:getRowSet():Bof() }
   ::bEof            := {|| oModel:getRowSet():Eof() }
   ::bSkip           := {| n | oModel:getRowSet():Skipper( n ) }
   ::bKeyNo          := {| n | oModel:getRowSet():RecNo() }
   ::bKeyCount       := {|| oModel:getRowSet():RecCount() }
   ::bBookMark       := {| n | iif( n == nil,;
                                    oModel:getRowSet():RecNo(),;
                                    ( oModel:getRowSet():GoTo( n ), logwrite( n ) ) ) }
   // ::bBookMark       := {| n | ::runBookMark( n, oModel ) } // iif( n == nil, oModel:getRowSet():RecNo(), oModel:getRowSet():GoTo( n ) ) }

   if ::oVScroll() != nil
      ::oVscroll():SetRange( 1, oModel:getRowSet():RecCount() )
   endif

   ::lFastEdit       := .t.

RETURN nil

//----------------------------------------------------------------------------//

METHOD runBookMark(n, oModel )

   if n == nil
      oModel:getRowSet():RecNo()
   else
      oModel:getRowSet():GoTo( n )
   end if 

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

   aeval( ::aCols, {|oCol| if( !empty( oCol:nFooterType ), aadd( aCols, oCol ), ) } )

   if empty( aCols )
      RETURN ( Self )
   end if 

   aeval( aCols, {|oCol| oCol:nTotal := 0.0 } )
   
   uBm            := eval( ::bBookMark )

   eval( ::bGoTop )
   do 
      aeval( aCols, {|oCol| oCol:nTotal  += oCol:Value, oCol:nCount++ } )
   until ( ::skip( 1 ) < 1 )

   eval( ::bBookMark, uBm )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD getColumnByHeaders()

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

METHOD getColumnOrder( cSortOrder )

   local nPosition   

   if !hb_ischar( cSortOrder )
      RETURN ( nil )
   end if 

   nPosition   := ascan( ::aCols, {|o| o:cSortOrder == cSortOrder } )

   if nPosition != 0
      RETURN ( ::aCols[ nPosition ] )
   end if 

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD getColumnOrderByHeader( cHeader )

   local oCol        := ::getColumnByHeader( cHeader )

   if !empty( oCol )
      RETURN ( oCol:cSortOrder )
   end if 

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD getFirstVisibleColumn()

   local oCol

   for each oCol in ::aCols
      if !oCol:lHide
         RETURN ( oCol )
      end if 
   next

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD SaveView()

   local oConfiguracionColumnasUsuariosModel

   oConfiguracionColumnasUsuariosModel    := SQLConfiguracionColumnasUsuariosModel()

   if !empty( oConfiguracionColumnasUsuariosModel )
      oConfiguracionColumnasUsuariosModel:set( ::getName(), ::saveState() )
   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD SetView()

   local hBrowseState
   local oConfiguracionColumnasUsuariosModel

   ::getOriginalView()

   oConfiguracionColumnasUsuariosModel := SQLConfiguracionColumnasUsuariosModel()

   if !Empty( oConfiguracionColumnasUsuariosModel )
      hBrowseState                     := oConfiguracionColumnasUsuariosModel:get( ::getName() )
   end if

   if hb_ishash( hBrowseState ) .and. hhaskey( hBrowseState, "browse_state" )
      ::restoreState( hget( hBrowseState, "browse_state" ) )
   end if 

RETURN ( Self )

//------------------------------------------------------------------------//

