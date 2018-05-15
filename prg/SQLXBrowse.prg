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
   METHOD getColumnOrder( cSortOrder )
   METHOD getColumnOrderHeader( cSortOrder )    INLINE ( if( !empty( ::getColumnOrder( cSortOrder ) ), ::getColumnOrder( cSortOrder ):cHeader, "" ) )

   METHOD getColumnOrderByHeader( cHeader )  

   METHOD getFirstVisibleColumn()

   METHOD RButtonDown( nRow, nCol, nFlags )

   METHOD ExportToExcel()

   METHOD MakeTotals( aCols )

   // States-------------------------------------------------------------------

   METHOD setName( cName )                      INLINE ( ::cName := cName )
   METHOD getName()                             INLINE ( ::cName )

   METHOD getOriginalState()                    INLINE ( ::cOriginal := ::saveState() )
   METHOD setOriginalState()                    INLINE ( if( !empty( ::cOriginal ), ::restoreState( ::cOriginal ), ) )

   METHOD setViewType( cViewType )              INLINE ( ::cViewType := cViewType )
   METHOD getViewType( )                        INLINE ( ::cViewType )

   METHOD saveStateToModel( cViewType )
   
   METHOD restoreStateFromModel( cViewType )

   METHOD setFilterInRowSet( cFilterExpresion )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController, oWnd ) 

   ::oController     := oController

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

   if hb_isnil( ::SelectedCol():Cargo )

   MenuAddItem( "Filtro rápido", "Establecer fitro rápido en columna actual", .f., .t., , , "gc_table_selection_column_16", oMenu )

      MenuBegin( .f., , , .f., .f., , , , , , , , , , , , .f., .t., .f., .t. )

         MenuAddItem( "'" + ::SelectedCol():cSortOrder + "' IN (" + toSqlString( ::SelectedCol():Value() ) + ")", "", .f., .t., {|| ::oController:buildInFilter( ::SelectedCol():cSortOrder, ::SelectedCol():Value() ) }, "gc_funnel_add_16" )
         
         MenuAddItem( "'" + ::SelectedCol():cSortOrder + "' NOT IN ('" + toSqlString( ::SelectedCol():Value() ) + "')", "", .f., .t., {|| ::oController:buildNotInFilter( ::SelectedCol():cSortOrder, ::SelectedCol():Value() ) }, "gc_funnel_add_16" )

         MenuAddItem( "'" + ::SelectedCol():cSortOrder + "' > '" + toSqlString( ::SelectedCol():Value() ) + "'", "", .f., .t., {|| ::oController:buildBiggerFilter( ::SelectedCol():cSortOrder, ::SelectedCol():Value() ) }, "gc_funnel_add_16" )

         MenuAddItem( "'" + ::SelectedCol():cSortOrder + "' < '" + toSqlString( ::SelectedCol():Value() ) + "'", "", .f., .t., {|| ::oController:buildSmallerFilter( ::SelectedCol():cSortOrder, ::SelectedCol():Value() ) }, "gc_funnel_add_16" )

         MenuAddItem( "'" + ::SelectedCol():cSortOrder + "' LIKE '" + toSqlString( ::SelectedCol():Value() ) + "%'", "", .f., .t., {|| ::oController:buildStartLikeFilter( ::SelectedCol():cSortOrder, ::SelectedCol():Value() ) }, "gc_funnel_add_16" )

         MenuAddItem( "'" + ::SelectedCol():cSortOrder + "' LIKE '%" + toSqlString( ::SelectedCol():Value() ) + "'", "", .f., .t., {|| ::oController:buildEndLikeFilter( ::SelectedCol():cSortOrder, ::SelectedCol():Value() ) }, "gc_funnel_add_16" )

         MenuAddItem( "'" + ::SelectedCol():cSortOrder + "' LIKE '%" + toSqlString( ::SelectedCol():Value() ) + "%'", "", .f., .t., {|| ::oController:buildLikeFilter( ::SelectedCol():cSortOrder, ::SelectedCol():Value() ) }, "gc_funnel_add_16" )

         MenuAddItem()

         MenuAddItem( "'" + ::SelectedCol():cSortOrder + "' IN (...)", "", .f., .t., {|| ::oController:buildCustomInFilter( ::SelectedCol():cSortOrder, ::SelectedCol():Value() ) }, "gc_funnel_add_16" )

         MenuAddItem( "'" + ::SelectedCol():cSortOrder + "' NOT IN (...)", "", .f., .t., {|| ::oController:buildCustomNotInFilter( ::SelectedCol():cSortOrder, ::SelectedCol():Value() ) }, "gc_funnel_add_16" )

         MenuAddItem( "'" + ::SelectedCol():cSortOrder + "' > '", "", .f., .t., {|| ::oController:buildCustomBiggerFilter( ::SelectedCol():cSortOrder, ::SelectedCol():Value() ) }, "gc_funnel_add_16" )

         MenuAddItem( "'" + ::SelectedCol():cSortOrder + "' < '", "", .f., .t., {|| ::oController:buildCustomSmallerFilter( ::SelectedCol():cSortOrder, ::SelectedCol():Value() ) }, "gc_funnel_add_16" )

         MenuAddItem( "'" + ::SelectedCol():cSortOrder + "' LIKE '%...%'", "", .f., .t., {|| ::oController:buildCustomLikeFilter( ::SelectedCol():cSortOrder, ::SelectedCol():Value() ) }, "gc_funnel_add_16" )
         
         MenuAddItem()

         MenuAddItem( "Limpiar filtro", "", .f., .t., {|| ::oController:clearFilter() }, "gc_funnel_broom_16" )

      MenuEnd()

   end if 

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

      MenuAddItem( "Guardar vista actual", "Guarda la vista actual de la rejilla de datos", .f., .t., {|| ::saveStateToModel() }, , "gc_table_selection_column_disk_16", oMenu )

      MenuAddItem( "Cargar vista por defecto", "Carga la vista por defecto de la rejilla de datos", .f., .t., {|| ::setOriginalState() }, , "gc_table_selection_column_refresh_16", oMenu )

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

METHOD getColumnOrder( cSortOrder )

   local nPosition   

   if !empty( cSortOrder )
      nPosition   := ascan( ::aCols, {|o| o:cSortOrder == cSortOrder } )
   else 
      nPosition   := ascan( ::aCols, {|o| !empty( o:cSortOrder ) .and. !( o:lHide ) } )
   end if 

   nPosition      := max( nPosition, 1 )

RETURN ( ::aCols[ nPosition ] )

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

METHOD saveStateToModel( cViewType )

   DEFAULT cViewType    := ::getViewType()

   SQLConfiguracionVistasModel():set( cViewType, ::getName(), ::saveState() )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD restoreStateFromModel( cViewType )

   local cBrowseState

   DEFAULT cViewType    := ::getViewType()

   ::getOriginalState()

   cBrowseState         := SQLConfiguracionVistasModel():getState( cViewType, ::getName() )

   if !empty( cBrowseState )
      ::restoreState( cBrowseState )
   end if 

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD setFilterInRowSet( cFilterExpresion )

   msgalert( ::SelectedCol():cSortOrder + cFilterExpresion + " ('" + alltrim( cvaltostr( ::SelectedCol():Value() ) ) + "' )" )
   //msgalert( alltrim( ::SelectedCol():cSortOrder ) ) == alltrim( cvaltostr( ::SelectedCol():Value() ) ) )

   // msgalert( ::oRowSet:fieldGet( ::SelectedCol():cSortOrder ) ) // + " == " + quoted( alltrim( cvaltostr( ::SelectedCol():Value() ) ) ) )
   ::oRowSet:setFilter( { || ::oRowSet:fieldGet( 1 ) == 1 } )

RETURN ( Self )

//------------------------------------------------------------------------//

