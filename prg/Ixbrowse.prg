#include "FiveWin.ch"
#include "InKey.ch"
#include "constant.ch"
#include "xbrowse.ch"
#include "Report.ch"
#include "Factu.ch" 

#ifdef __HARBOUR__
   #ifndef __XHARBOUR__
      #xtranslate DbSkipper => __DbSkipper
   #endif
#endif

//----------------------------------------------------------------------------//

CLASS IXBrowse FROM TXBrowse

   CLASSDATA lRegistered      AS LOGICAL

   CLASSDATA  dbfUsr
   CLASSDATA  lOpenData       AS LOGIC       INIT .f.

   DATA  cOriginal            AS CHARACTER   INIT ""
   DATA  cName                AS CHARACTER   INIT ""

   DATA  bToolTip
   DATA  oToolTip
   DATA  oTimer

   DATA  lOnProcess           AS LOGIC       INIT .f.

   DATA  nVScrollPos

   CLASSDATA nToolTip         AS NUMERIC     INIT 900

   DATA  bExportLector

   ACCESS BookMark            INLINE Eval( ::bBookMark )
   ASSIGN BookMark(u)         INLINE Eval( ::bBookMark, u )

   METHOD New( oWnd )
   METHOD setAlias( cAlias )  INLINE ( ::cAlias := cAlias, ::SetRDD() )

   METHOD GetOriginal()       INLINE ( ::cOriginal := ::SaveState() )
   METHOD SetOriginal()       INLINE ( ::RestoreState( ::cOriginal ) )

   METHOD Load()              
      METHOD LoadRecnoAndOrder()

   METHOD Save( lMessage, nBrowseRecno, nBrowseOrder )
      METHOD SaveRecnoAndOrder( nBrowseRecno, nBrowseOrder );
                              INLINE ( ColumnasUsuariosModel():set( ::cName, nil, nBrowseRecno, nBrowseOrder ) )

   METHOD SelectCurrent()     INLINE ( ::Select( 0 ), ::Select( 1 ) )

   METHOD CreateData( cPath )

   METHOD ReindexData( cPath )

   METHOD CleanData()

   METHOD DeleteData()

   METHOD CloseData()

   METHOD OpenData( cPath )

   METHOD RButtonDown( nRow, nCol, nFlags )

   METHOD CheckExtendInfo()

   METHOD ShowExtendInfo()

   METHOD SetRDD( lAddColumns, lAutoOrder, aFldNames )

   METHOD ExportToExcel()

   METHOD ExportLector()

   METHOD MakeTotals( aCols )

   METHOD ArrayIncrSeek()

/*
   METHOD Refresh( lComplete )
*/
   
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

//----------------------------------------------------------------------------//

METHOD CreateData( cPath )

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD ReindexData( cPath )

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD Load()

   local cBrowseState

   ::getOriginal()

   cBrowseState         := SQLConfiguracionVistasModel():getStateNavigator( ::cName )

   if !empty( cBrowseState )
      ::restoreState( cBrowseState )
   end if 

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD LoadRecnoAndOrder()

   local nRecno
   local nOrder
   local hBrowseInformation

   hBrowseInformation   := SQLConfiguracionVistasModel():getNavigator( ::cName )

   if empty( hBrowseInformation )
      RETURN ( Self )
   end if 

   nRecno               := max( hget( hBrowseInformation, "Recno" ), 1 )
   nOrder               := max( hget( hBrowseInformation, "Order" ), 1 )

   if ( ::cAlias )->( used() )

      ( ::cAlias )->( dbgoto( nRecno ) )

      if ( ::cAlias )->( recno() ) != nRecno .or. nRecno > ( ::cAlias )->( lastrec() )
         ( ::cAlias )->( dbgotop() )
      end if

      ( ::cAlias )->( ordsetfocus( nOrder ) )

   end if 

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD Save( lMessage, nBrowseRecno, nBrowseOrder )

   local oError
   local oBlock

   DEFAULT lMessage         := .t.

   oBlock                   := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      SQLConfiguracionVistasModel():setNavigator( ::cName, ::saveState() ) //, nBrowseRecno, nBrowseOrder )

      if lMessage
         msgInfo( "Configuración de columnas guardadas.", "Información" )
      end if

   RECOVER USING oError

      msgStop( "Imposible salvar las configuraciones de columnas" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD CleanData( lMessage )

   DEFAULT lMessage     := .t.

   SQLConfiguracionVistasModel():delete( ::cName )

   if lMessage
      msgInfo( "Configuración de columnas eliminada", "Información" )
   end if

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD DeleteData()

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD CloseData()

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD OpenData( cPath )

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD RButtonDown( nRow, nCol, nFlags )

   local oCol
   local oMenu
   local bMenuSelect

   /*
   Montamos el menu------------------------------------------------------------
   */

   oMenu             := MenuBegin( .t. )
   bMenuSelect       := ::bMenuSelect

   ::bMenuSelect     := nil

   MenuAddItem( "Columnas", "Columnas de la rejilla de datos", .f., .t., , , "gc_table_selection_column_16", oMenu )

   MenuBegin( .f., , , .f., .f., , , , , , , , , , , , .f., .t., .f., .t. )

      for each oCol in ::aCols
         MenuAddItem( oCol:cHeader, , !oCol:lHide, ( Len( ::aDisplay ) != 1 .or. oCol:nPos != 1 ), GenMenuBlock( oCol ) )
      next

      MenuEnd()

      if !Empty( ::cName )

         MenuAddItem( "Guardar vista actual", "Guarda la vista actual de la rejilla de datos", .f., .t., {|| ::Save( .t. ) }, , "gc_table_selection_column_disk_16", oMenu )

         MenuAddItem( "Cargar vista por defecto", "Carga la vista por defecto de la rejilla de datos", .f., .t., {|| ::SetOriginal() }, , "gc_table_selection_column_refresh_16", oMenu )

      end if

      MenuAddItem( "Seleccionar &todo", "Selecciona todas las filas de la rejilla", .f., .t., {|| ::SelectAll() }, , "gc_table_selection_all_16", oMenu )

      MenuAddItem( "&Quitar selección", "Quita la selección de todas las filas de la rejilla", .f., .t., {|| ::SelectNone() }, , "gc_table_16", oMenu )

      MenuAddItem()

      MenuAddItem( "Exportar a E&xcel", "Exportar rejilla de datos a Excel", .f., .t., {|| ::ExportToExcel() }, , "gc_spreadsheet_sum_16", oMenu )

      if !empty( ::bExportLector )
         MenuAddItem( "Exportar códigos y unidades", "Exportar códigos y unidades", .f., .t., {|| ::ExportLector() }, , "gc_spreadsheet_sum_16", oMenu )
      end if

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

METHOD CheckExtendInfo()

   if Empty( ::bToolTip )
      RETURN ( Self )
   endif

   if !Empty( ::oToolTip )
      ::oToolTip:End()
      ::oToolTip  := nil
   endif

   if !Empty( ::oTimer )
      ::oTimer:End()
      ::oTimer    := nil
   endif

   if !::lOnProcess
      ::oTimer             := TTimer():New( ::nToolTip, {|| ::ShowExtendInfo(), if( ::oTimer != nil, ::oTimer:End(), nil ), ::oTimer := nil }, )
      ::oTimer:hWndOwner   := GetActiveWindow()
      ::oTimer:Activate()
   end if

   /*
   Me cargo el objeto tooltip
   */

   if !Empty( ::oToolTip )
      ::oToolTip:End()
   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD ShowExtendInfo()

   local nRow
   local oBlock

   ::lOnProcess      := .t.

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if ::oToolTip == nil

      ::oToolTip     := CheckEval( ::bToolTip )

      if Valtype( ::oToolTip ) == "O"

         nRow           := ( ::nRowSel * ::DataHeight ) + ::HeaderHeight()

         if ( nRow + ::oToolTip:nHeight() ) >= ( ::BrwHeight() - 100 )
            nRow     -= ( ::oToolTip:nHeight() + ::DataHeight + 108 ) // + 100
         else
            nRow     += 4
         end if

         ::oToolTip:Activate( , , , .f., , .f., {|o| o:Move( nRow, ( ::BrwWidth() - ::oToolTip:nWidth() - 4 ), ::oToolTip:nWidth(), ::oToolTip:nHeight() ) } )

         ::SetFocus()

         if !Empty( ::oTimer )
            ::oTimer:End()
            ::oTimer := nil
         endif

      end if

   end if

   END SEQUENCE

   ErrorBlock( oBlock )

   ::lOnProcess      := .f.

RETURN ( Self )

//----------------------------------------------------------------------------//
/*
METHOD Refresh( lComplete )

   if ::lFooter
   ::Super:MakeTotals()
   end if 

RETURN ( ::Super:Refresh( lComplete ) )
*/
//----------------------------------------------------------------------------//

METHOD SetRDD( lAddColumns, lAutoOrder, aFldNames ) CLASS IXBrowse

   local oCol, aStruct
   local cAlias
   local nFields, nFor
   local bOnSkip

   if Empty( ::cAlias )
      ::cAlias 		  		:= Alias()
      if Empty( ::cAlias )
         RETURN nil
      endif
   endif

   cAlias      				:= ::cAlias
   ::nDataType 				:= DATATYPE_RDD

   DEFAULT lAddColumns     := .f.
   DEFAULT lAutoOrder      := .f. // ::lAutoSort

   ::bGoTop                := {|| if( ( cAlias )->( Used() ), ( cAlias )->( DbGoTop() ), ) }
   ::bGoBottom             := {|| if( ( cAlias )->( Used() ), ( cAlias )->( DbGoBottom() ), ) }
   ::bSkip                 := {| n | iif( n == nil, n := 1, ),;
                                       iif( ( cAlias )->( Used() ),;
                                          ( cAlias )->( DbSkipper( n ) ),;
                                          0 ) }
   ::bBof                  := {|| if( ( cAlias )->( Used() ), ( cAlias )->( Bof() ), .t. ) }
   ::bEof                  := {|| if( ( cAlias )->( Used() ), ( cAlias )->( Eof() ), .t. ) }
   ::bBookMark             := {| n | iif( ( cAlias )->( Used() ),;
                                          iif( n == nil,;
                                             ( cAlias )->( RecNo() ),;
                                             ( cAlias )->( DbGoto( n ) ) ), ) }
   ::bKeyNo                := {| n | iif( ( cAlias )->( Used() ),;
                                          iif( n == nil,;
                                             ( cAlias )->( OrdKeyNo() ),;
                                             ( cAlias )->( OrdKeyGoto( n ) ) ), ) }
   ::bKeyCount             := {|| if( ( cAlias )->( Used() ), ( cAlias )->( OrdKeyCount() ), 0 ) }
   ::bLock                 := {|| if( ( cAlias )->( Used() ), ( cAlias )->( DbrLock() ), .f. ) }
   ::bUnlock               := {|| if( ( cAlias )->( Used() ), ( cAlias )->( DbrUnlock() ), .f. ) }

   if lAutoOrder
      for nFor := 1 to Len( ::aCols )
         if ( ::cAlias )->( OrdNumber( ::aCols[ nFor ]:cHeader ) ) > 0
            ::aCols[nFor]:cSortOrder := ::aCols[ nFor ]:cHeader
         else
            ::aCols[nFor]:cSortOrder := ( cAlias )->( FindTag( ::aCols[ nFor ]:cHeader ) )
         endif
      next nFor
   endif

   if ::lCreated
      ::Adjust()
      ::Refresh()
   endif

RETURN nil

//----------------------------------------------------------------------------//

METHOD ExportToExcel()

   local oError
   local oBlock
   local oWaitMeter

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      CursorWait()

      oWaitMeter     := TWaitMeter():New( "Exportando a excel", "Espere por favor..." )
      oWaitMeter:run()
      oWaitMeter:setTotal( eval( ::bKeyCount ) ) 

      ::ToExcel( {|| oWaitMeter:autoInc() } )

      CursorWe()

   RECOVER USING oError
      
      msgStop( "Error exportando a excel." + CRLF + ErrorMessage( oError ) )
   
   END SEQUENCE

   ErrorBlock( oBlock )

   oWaitMeter:end()

RETURN nil

//----------------------------------------------------------------------------//

METHOD ExportLector()

   local nRow
   local nRows
   local oClip
   local cText
   local oError
   local oBlock

   nRows             := eval( ::bKeyCount )
   if ( nRows == 0 )
      RETURN ( Self )
   endif

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      CursorWait()

      nRow           := 1
      cText          := ""

      eval( ::bGoTop )
      while ( nRow <= nRows )

         cText       += eval( ::bExportLector )
      
         ::skip( 1 ); ( nRow++ )

      end while
      eval( ::bGoTop )

      oClip          := TClipBoard():New( 1, ::oWnd )
      if oClip:Open()
         oClip:SetText( cText )
      end if 
      oClip:Close()

      msgInfo( "Contenido exportado al portapapeles" )

      CursorWe()

   RECOVER USING oError
      msgStop( "Error exportando a excel." + CRLF + ErrorMessage( oError ) )
   END SEQUENCE
   ErrorBlock( oBlock )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD MakeTotals( aCols ) CLASS IXBrowse

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

RETURN Self

//----------------------------------------------------------------------------//

METHOD ArrayIncrSeek( cSeek, nGoTo ) CLASS IXBrowse

   local nAt, nBrwCol, nSortCol, nRow, uVal
   local lExact

   if ::lIncrFilter
      RETURN ::ArrayIncrFilter( cSeek, @nGoTo )
   endif

   if ( nBrwCol := AScan( ::aCols, { |o| !Empty( o:cOrder ) } ) ) > 0

      nSortCol := ::aCols[ nBrwCol ]:cSortOrder

      if !empty( nSortCol := ::aCols[ nBrwCol ]:cSortOrder ) .and. valtype( nSortCol ) == 'N'
         if ! ::aCols[ nBrwCol ]:lCaseSensitive
            cSeek    := Upper( cSeek )
         endif
         for nRow := 1 to ::nLen
            uVal  := ::ArrCell( nRow, nSortCol )
            if ValType( uVal ) $ 'CDLN'
               uVal     := cValToChar( uVal )
               if ! ::aCols[ nBrwCol ]:lCaseSensitive
                  uVal  := Upper( uVal )
               endif
               if ::lSeekWild
                  if hb_WildMatch( '*' + cSeek, uVal )
                     nAt   := nRow
                  endif
               else
                  lExact := Set( _SET_EXACT, .f. )
                  if uVal = cSeek
                     nAt   := nRow
                  endif
                  Set( _SET_EXACT, lExact )
               endif
               if ! Empty( nAt )
                  ::nArrayAt  := nAt
                  RETURN .t.
               endif
            endif
         next nRow
      endif
   endif

RETURN .f.

//----------------------------------------------------------------------------//

static function FindTag( cFld, nOrder )

   local nOrders  := OrdCount()
   local cTag, nAt, cKey, n, nLen, aOrders := {}

   cFld     := Upper( Trim( cFld ) )
   nLen     := Len( cFld )

   for n := 1 to nOrders
      cKey  := OrdKey( n )
      cKey  := Upper( StrTran( cKey, ' ','' ) )
      if Left( cKey, nLen ) == cFld
         nOrder   := n
         cTag     := OrdName( n )
         exit
      endif
   next
   if Empty( cTag )
      for n := 1 to nOrders
         cKey  := OrdKey( n )
         cKey  := Upper( StrTran( cKey, ' ','' ) )
         if ( nAt := At( "(", cKey ) ) > 0
            cKey  := SubStr( cKey, nAt + 1 )
            if Left( cKey, nLen ) == cFld
               nOrder   := n
               cTag     := OrdName( n )
               exit
            endif
         endif
      next
   endif

RETURN cTag

//------------------------------------------------------------------//

CLASS TOkButton FROM TBtnBmp

   METHOD ReDefine( nId, cResName1, cResName2, cBmpFile1, cBmpFile2, cMsg, bAction, oBar, lAdjust, bWhen, lUpdate, cToolTip, cPrompt, oFont, cResName3, cBmpFile3, lBorder, cLayout, l2007, cResName4, cBmpFile4, lTransparent, lRound, bGradColors ) 

END CLASS

//----------------------------------------------------------------------------//

METHOD ReDefine( nId, cResName1, cResName2, cBmpFile1, cBmpFile2, cMsg, bAction, oBar, lAdjust, bWhen, lUpdate, cToolTip, cPrompt, oFont, cResName3, cBmpFile3, lBorder, cLayout, l2007, cResName4, cBmpFile4, lTransparent, lRound, bGradColors ) CLASS TOkButton

   bGradColors    := { | lInvert | if( lInvert, ;
                                       { { 1/3, nRGB( 0, 0, 0 ), nRGB( 255, 231, 151 ) }, ;
                                         { 2/3, nRGB( 255, 215,  84 ), nRGB( 255, 233, 162 ) }  ;
                                       }, ;
                                       { { 1/2, nRGB( 219, 230, 244 ), nRGB( 207-50, 221-25, 255 ) }, ;
                                         { 1/2, nRGB( 201-50, 217-25, 255 ), nRGB( 231, 242, 255 ) }  ;
                                       } ) }

   ::Super:ReDefine( nId, cResName1, cResName2, cBmpFile1, cBmpFile2, cMsg, bAction, oBar, lAdjust, bWhen, lUpdate, cToolTip, cPrompt, oFont, cResName3, cBmpFile3, lBorder, cLayout, l2007, cResName4, cBmpFile4, lTransparent, lRound, bGradColors )

   // ::setColor( rgb( 0, 0, 0 ), rgb( 118, 216, 38 ) )

RETURN ( Self )

//----------------------------------------------------------------------------//
