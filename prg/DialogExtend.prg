#include "HbClass.ch"
#include "Fivewin.ch"
#include "Xbrowse.ch"

FUNCTION DialogExtend() 

local hClass

  hClass        := TDialog():ClassH

  __clsAddMsg( hClass, "aFastKeys", __cls_IncData( hClass ), 9, {}, 1, .f., .f. )

  __clsAddMsg( hClass, "lShowAgain", __cls_IncData( hClass ), 9, .f., 1, .f., .f. )

  __clsAddMsg( hClass, "bTmpValid", __cls_IncData( hClass ), 9, nil, 1, .f., .f. )

  __clsAddMsg( hClass, "AddFastKey", {|Self, nKey, bAction| Self, aAdd( ::aFastKeys, { nKey, bAction } ) }, 3, nil, 1, .f., .f. )

  __clsAddMsg( hClass, "Enable()", {|Self| Self, ( ::bValid := ::bTmpValid, aEval( ::aControls, { |o| if( o:ClassName <> "TSAY" .AND. o:ClassName <> "TBITMAP", o:Enable(), ) } ), CursorArrow() ) }, 3, nil, 1, .f., .f. )

  __clsAddMsg( hClass, "Disable()", {|Self| Self, ( CursorWait(), ::bTmpValid := ::bValid, ::bValid := {|| .f. }, aEval( ::aControls, { |o| if( o:ClassName <> "TSAY" .AND. o:ClassName <> "TBITMAP", o:Disable(), ) } ) ) }, 3, nil, 1, .f., .f. )

  __clsAddMsg( hClass, "aEvalValid", @DialogEvalValid(), 0, nil, 1, .f., .f. )

  __clsModMsg( hClass, "KeyDown", @DialogKeyDown(), 1 )

  hClass        := TCheckBox():ClassH

  __clsAddMsg( hClass, "bOldWhen", __cls_IncData( hClass ), 9, nil, 1, .f., .f. )

  __clsAddMsg( hClass, "HardEnable", {|Self| Self, ::bWhen := ::bOldWhen, ::Enable() }, 3, nil, 1, .f., .f. ) 

  __clsAddMsg( hClass, "HardDisable", {|Self| Self, ::bOldWhen := ::bWhen, ::bWhen := {|| .f. } }, 3, nil, 1, .f., .f. ) 

  __clsModMsg( hClass, "Click", @CheckBoxClick(), 1 ) 

  hClass        := TXBrowse():ClassH

  __clsAddMsg( hClass, "SelectOne", {|Self| Self, ::Select( 0 ), ::Select( 1 ) }, 3, nil, 1, .f., .f. ) 

  __clsModMsg( hClass, "ToExcel", @TXBrowseToExcel(), 1 )

  hClass        := TWBrowse():ClassH

  __clsAddMsg( hClass, "_lDrawHeaders", __cls_IncData( hClass ), 9, .f., 1, .f., .f. )

  hClass        := TComboBox():ClassH

  __clsAddMsg( hClass, "GetFont", {|| nil }, 3, nil, 1, .f., .f. )

  hClass        := TButton():ClassH

  __clsAddMsg( hClass, "setText", {|Self, cText| Self, SetWindowText( ::hWnd, cText ) }, 3, nil, 1, .f., .f. )

/*
  hClass        := TBtnBmp():ClassH

  __clsAddMsg( hClass, "bTop", __cls_IncData( hClass ), 9, nil, 1, .f., .f. )
  __clsAddMsg( hClass, "bLeft", __cls_IncData( hClass ), 9, nil, 1, .f., .f. )
  __clsAddMsg( hClass, "bWidth", __cls_IncData( hClass ), 9, nil, 1, .f., .f. )
  __clsAddMsg( hClass, "bHeight", __cls_IncData( hClass ), 9, nil, 1, .f., .f. )

  __clsAddMsg( hClass, "ReAdjust", @BtnBmpReAdjust(), 0, nil, 1, .f., .f. )
*/
Return nil

//----------------------------------------------------------------------------//

/*
EXTEND CLASS TDialog WITH DATA aFastKeys//  AS ARRAY INIT {} 

EXTEND CLASS TDialog WITH DATA bTmpValid

EXTEND CLASS TDialog WITH MESSAGE AddFastKey( nKey, bAction );
    INLINE (  if( isNil(::aFastKeys), ::aFastKeys := {}, ),;
              aAdd( ::aFastKeys, { nKey, bAction } ) )

EXTEND CLASS TDialog WITH MESSAGE Enable();
    INLINE (  ::bValid    := ::bTmpValid,;
              aEval( ::aControls, { |o| if( o:ClassName != "TSAY" .and. o:ClassName != "TBITMAP", o:Enable(), ) } ),;
              CursorArrow() )

EXTEND CLASS TDialog WITH MESSAGE Disable();
    INLINE (  CursorWait(),;
              ::bTmpValid := ::bValid,;
              ::bValid    := {|| .f. },;
              aEval( ::aControls, { |o| if( o:ClassName != "TSAY" .and. o:ClassName != "TBITMAP", o:Disable(), ) } ) )

EXTEND CLASS TDialog WITH MESSAGE aEvalValid METHOD DialogEvalValid

OVERRIDE METHOD KeyDown IN CLASS TDialog WITH DialogKeyDown
*/
//EXTEND CLASS HBObject WITH MESSAGE log METHOD LogData

RETURN ( nil )

//----------------------------------------------------------------------------//

STATIC FUNCTION DialogEvalValid() 

   local n
   local lValid     := .t.
   local Self       := HB_QSelf()
   local aControls  := Self:aControls

   if aControls != nil .and. !Empty( aControls )
      for n = 1 to Len( aControls )
          if aControls[ n ] != nil .and. aControls[ n ]:bValid != nil
             if !Eval( aControls[ n ]:bValid )
                lValid  := .f.
                aControls[ n ]:SetFocus()  // keep this as ::
             endif
         endif
      next
   endif

return ( lValid )

//----------------------------------------------------------------------------//

STATIC FUNCTION DialogKeyDown( nKey, nFlags ) 

   local Self       := HB_QSelf()

   if nKey == VK_ESCAPE

      if ::oWnd == nil
         if SetDialogEsc()
            ::End()
         endif
      else
         if ::oWnd:IsKindOf( "TMDICHILD" )
            if SetDialogEsc()
               ::End()
            endif
         else
            if ::oWnd:IsKindOf( "TDIALOG" )
               if SetDialogEsc()
                  ::End()
               endif
            elseif Upper( ::oWnd:ClassName() ) == "TMDIFRAME"
               if SetDialogEsc() // To avoid ESC being ignored
                  ::End()
               endif
            else
               return ::Super:KeyDown( nKey, nFlags )
            endif
         endif
      endif

   else

      aEval( ::aFastKeys, {|aKey| if( nKey == aKey[1], Eval( aKey[2] ), ) } )

      return ::Super:KeyDown( nKey, nFlags )

   endif

Return ( nil )

//----------------------------------------------------------------------------//

Static Function BtnBmpReAdjust() 

   local Self     := HB_QSelf()
   local nRow     := if( !empty( Self:bRow ),     eval( Self:bRow ),    Self:nTop   )
   local nLeft    := if( !empty( Self:bCol ),     eval( Self:bCol ),    Self:nLeft  )
   local nWidth   := if( !empty( Self:bWidth ),   eval( Self:bWidth ),  Self:nWidth )
   local nHeight  := if( !empty( Self:bHeight ),  eval( Self:bHeight ), Self:nHeight )

   Self:Move( nRow, nLeft, nWidth, nHeight )  

Return ( Self )

//----------------------------------------------------------------------------//

Static Function CheckBoxClick( lValue )

   local Self       := HB_QSelf()

   DEFAULT lValue   := !Eval( ::bSetGet )

   if ::bSetGet != nil
      Eval( ::bSetGet, lValue )
      ::Refresh()
   endif

   if ::bChange != nil
      Eval( ::bChange, Eval( ::bSetGet ), Self )
   endif

   ::Super:Click()           // keep it here, the latest !!!

Return ( Self )

//----------------------------------------------------------------------------//

Static Function TXBrowseToExcel( bProgress, nGroupBy, aCols )

   local oExcel, oBook, oSheet, oWin
   local nCol, nXCol, oCol, cType, uValue, nAt, cxlAggr
   local uBookMark, nRow
   local nDataRows
   local oClip, cText, nPasteRow, nStep, cFormat
   local aTotals     := {}
   local lAnyTotals  := .f.
   local aWidths     := {}
   local lContinue   := .t.
   local oBlock
   local oError

   local Self        := HB_QSelf()

   nDataRows   := EVAL( ::bKeyCount )
   if nDataRows == 0
      return Self
   endif

   DEFAULT aCols         := ::GetVisibleCols()

   if Empty( aCols )
      return Self
   endif

   if ( oExcel := ExcelObj() ) == nil
      msgStop( "Excel not installed" )
      return Self
   endif

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   oExcel:ScreenUpdating := .f.

   oBook          := oExcel:WorkBooks:Add()
   oSheet         := oExcel:ActiveSheet

   uBookMark      := EVAL( ::bBookMark )

   nRow     := 1
   nCol     := 0
   aWidths  := Array( Len( aCols ) )

   for nXCol := 1 TO Len( aCols )
      oCol   := aCols[ nXCol ]

      nCol ++

      oSheet:Cells( nRow, nCol ):Value   := oCol:cHeader
      cType      := oCol:cDataType

      if ::nDataType != DATATYPE_ARRAY
         DO CASE
         CASE Empty( cType )
            // no action
         CASE cType == 'N'
            cFormat                                      := Clp2xlNumPic( oCol:cEditPicture )
            oSheet:Columns( nCol ):NumberFormat          := cFormat
            oSheet:Columns( nCol ):HorizontalAlignment   := - 4152 //xlRight

         CASE cType == 'D'
              if ValType( oCol:cEditPicture ) == 'C' .and. Left( oCol:cEditPicture, 1 ) != '@'
                 oSheet:Columns( nCol ):NumberFormat := Lower( oCol:cEditPicture )
              else
                 oSheet:Columns( nCol ):NumberFormat := Lower( Set( _SET_DATEFORMAT ) )
              endif
              oSheet:Columns( nCol ):HorizontalAlignment := - 4152 //xlRight
         CASE cType $ 'LPFM'
            // leave as general format
         OTHERWISE
            oSheet:Columns( nCol ):NumberFormat := "@"
            if ! Empty( oCol:nDataStrAlign )
               oSheet:Columns( nCol ):HorizontalAlignment := If( oCol:nDataStrAlign == AL_CENTER, -4108, -4152 )
            endif
         ENDCASE
      endif

      if cType != nil .and. cType $ 'PFM' // Picture or memo
         aWidths[ nCol ]                     := oCol:nWidth / 7.5
         oSheet:Columns( nCol ):ColumnWidth  := aWidths[ nCol ]
         oSheet:Rows( "2:" + LTrim(Str( ::nLen + 1 )) ):RowHeight := ::nRowHeight
         if cType == 'M'
            oSheet:Columns( nCol ):WrapText  := .t.
         endif
      endif

   next nXCol

   oSheet:Range( oSheet:Cells( 1, 1 ), oSheet:Cells( 1, Len( aCols ) ) ):Select()
   oExcel:Selection:Borders(9):LineStyle := 1   // xlContinuous = 1
   oExcel:Selection:Borders(9):Weight    := -4138   // xlThin = 2, xlHairLine = 1, xlThick = 4, xlMedium = -4138

   if Empty( ::aSelected ) .or. Len( ::aSelected ) == 1

      Eval( ::bGoTop )

      if bProgress == nil
         if ::oWnd:oMsgBar == nil
            bProgress := { || nil }
         else
            bProgress := { | n, t | ::oWnd:SetMsg( "To Excel : " + Ltrim( Str( n ) ) + "/" + Ltrim( Str( t ) ) ) }
         endif
      endif

      nRow      := 2
      nStep     := Max( 1, Min( 100, Int( nDataRows / 100 ) ) )

      while nRow <= ( nDataRows + 1 ) .and. lContinue

         nCol        := 0
         for nxCol   := 1 to Len( aCols )
            oCol     := aCols[ nXCol ]
            nCol++
            oCol:ToExcel( oSheet, nRow, nCol )
         next nCol

         lContinue := ( ::Skip( 1 ) == 1 )
         nRow ++
         If ( nRow - 2 ) % nStep == 0
            if Eval( bProgress, nRow - 2, nDataRows ) == .f.
               Exit
            endif
            SysRefresh()
         endif

      enddo

   else
      
      ::Copy()
      oSheet:Cells( 2, 1 ):Select()
      oSheet:Paste()
      nRow := Len( ::aSelected ) + 2
   
   endif

   oSheet:Cells( 1, 1 ):Select()

   // Totals, if needed

   oSheet:Rows(    1 ):Font:Bold   := .T.
   oSheet:Rows( nRow ):Font:Bold   := .T.

   if ValType( nGroupBy ) == 'N'
      for nxCol := 1 TO Len( aCols )
         if aCols[ nxCol ]:lTotal
            AAdd( aTotals, nxCol )
         endif
      next
      if ! Empty( aTotals )
         oSheet:Activate()
         oExcel:Selection:Subtotal( nGroupBy , -4157,  ;    // xlSum = -4157
                                    aTotals, ;
                                    .t., ;    // Replace .t. or .f.
                                    .f., ;    // PageBreaks
                                    .t. )       // SummaryBelowData

      endif
   else
      nCol   := 0
      oSheet:Range( oSheet:Cells( nRow, 1 ), oSheet:Cells( nRow, Len( aCols ) ) ):Select()
      oExcel:Selection:Borders(8):LineStyle := 1   // xlContinuous = 1
      oExcel:Selection:Borders(8):Weight    := -4138   // xlThin = 2, xlHairLine = 1, xlThick = 4, xlMedium = -4138

      for nXCol := 1 TO Len ( aCols )
         oCol   := aCols[ nXCol ]
         nCol ++
      next nXCol
   endif

   for nCol := 1 to Len( aCols )
      if aWidths[ nCol ] == nil
         oSheet:Columns( nCol ):AutoFit()
      endif
      oSheet:Columns( nCol ):VerticalAlignment := -4108  // xlCenter
   next

   oSheet:Cells(1,1):Select()
   oWin   := oExcel:ActiveWindow
   oWin:SplitRow := 1
   oWin:FreezePanes := .t.

   Eval( ::bBookMark, uBookMark )
   ::Refresh()
   ::SetFocus()

   oExcel:ScreenUpdating   := .t.
   oExcel:visible          := .T.
   ShowWindow( oExcel:hWnd, 3 )
   BringWindowToTop( oExcel:hWnd )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible establecer lenguaje de Excel" )

   END SEQUENCE

   ErrorBlock( oBlock )

return oSheet

//----------------------------------------------------------------------------//


