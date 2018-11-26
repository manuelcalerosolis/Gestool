#include "HbClass.ch"
#include "Fivewin.ch"
#include "Xbrowse.ch"

FUNCTION appDialogExtend() 

   local hClass

   hClass        := TDialog():ClassH

   __clsAddMsg( hClass, "aErrors", __cls_IncData( hClass ), 9, {}, 1, .f., .f. )

   __clsAddMsg( hClass, "Enable", @DialogEnable(), 0, nil, 1, .f., .f. )

   __clsAddMsg( hClass, "Disable", @DialogDisable(), 0, nil, 1, .f., .f. )

   __clsAddMsg( hClass, "hasErrors", @DialogHasError(), 0, nil, 1, .f., .f. )

   __clsAddMsg( hClass, "aEvalValid", @DialogEvalValid(), 0, nil, 1, .f., .f. )

  //----------------------------------------------------------------------------//

  hClass        := TCheckBox():ClassH

  __clsAddMsg( hClass, "HardEnable", {|Self| Self, ::bWhen := ::Cargo, ::Enable() }, 3, nil, 1, .f., .f. ) 

  __clsAddMsg( hClass, "HardDisable", {|Self| Self, ::Cargo := ::bWhen, ::bWhen := {|| .f. } }, 3, nil, 1, .f., .f. ) 

  __clsModMsg( hClass, "Click", @CheckBoxClick(), 1 ) 

  //----------------------------------------------------------------------------//

  hClass        := TXBrowse():ClassH

  __clsAddMsg( hClass, "SelectOne", {|Self| Self, ::Select( 0 ), ::Select( 1 ) }, 3, nil, 1, .f., .f. ) 

  __clsModMsg( hClass, "ToExcel", @TXBrowseToExcel(), 1 )
  
  //----------------------------------------------------------------------------//

  hClass        := TWBrowse():ClassH

  __clsAddMsg( hClass, "_lDrawHeaders", __cls_IncData( hClass ), 9, .f., 1, .f., .f. )

  //----------------------------------------------------------------------------//

  hClass        := TComboBox():ClassH

  __clsAddMsg( hClass, "GetFont", {|| nil }, 3, nil, 1, .f., .f. )

  //----------------------------------------------------------------------------//

  hClass        := TButton():ClassH

  __clsAddMsg( hClass, "setText", {|Self, cCaption| Self, ::cCaption := cCaption, SetWindowText( ::hWnd, cCaption ) }, 3, nil, 1, .f., .f. )

RETURN nil

//----------------------------------------------------------------------------//

STATIC FUNCTION DialogHasError() 

   local Self        
   local oControl

   Self              := HB_QSelf()
   Self:Cargo        := {}

   for each oControl in Self:aControls
      if ( oControl:ClassName() == "TGETHLP" ) .and. !empty( oControl:cError )
         aadd( Self:Cargo, oControl:cError )
      end if 
   next

RETURN ( !empty( Self:Cargo ) )

//----------------------------------------------------------------------------//

STATIC FUNCTION DialogDisable() 

   local Self         
   local oControl

   Self              := HB_QSelf()

   CursorWait()

   Self:Cargo        := Self:bValid
   Self:bValid       := {|| .f. }

   for each oControl in Self:aControls
      if oControl:ClassName() <> "TSAY" .AND. oControl:ClassName() <> "TBITMAP"
         oControl:Disable()
      end if 
   next

RETURN ( .t. )

//----------------------------------------------------------------------------//

STATIC FUNCTION DialogEnable() 

   local oControl
   local Self       := HB_QSelf()

   for each oControl in Self:aControls
      if oControl:ClassName() <> "TSAY" .AND. oControl:ClassName() <> "TBITMAP"
         oControl:Enable()
      end if 
   next

   Self:bValid      := Self:Cargo

   CursorArrow()

RETURN ( .t. )

//----------------------------------------------------------------------------//

STATIC FUNCTION DialogEvalValid() 

   local oControl
   local aControls

   aControls   := hb_qself():aControls

   if empty( aControls )
      RETURN ( .t. )
   end if 

   for each oControl in aControls

      if empty( oControl:bWhen ) .or. eval( oControl:bWhen )

         if empty( oControl:bValid ) .or. !eval( oControl:bValid )

            oControl:SetFocus()

            RETURN ( .f. )

         endif

      end if 
      
   next

RETURN ( .t. )

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
               RETURN ::Super:KeyDown( nKey, nFlags )
            endif
         endif
      endif

   else

        if GetKeyState( VK_CONTROL )

          if isArray( ::aControlKeys ) .and. len( ::aControlKeys ) > 0
            aEval( ::aControlKeys, {|aKey| if( nKey == aKey[1] , Eval( aKey[2] ), ) } )
          end if

        else

          if isArray( ::aFastKeys ) .and. len( ::aFastKeys ) > 0
            aEval( ::aFastKeys, {|aKey| if( nKey == aKey[1] , Eval( aKey[2] ), ) } )
          end if

        end if

      RETURN ::Super:KeyDown( nKey, nFlags )

   endif

RETURN ( nil )

//----------------------------------------------------------------------------//

STATIC FUNCTION BtnBmpReAdjust() 

   local Self     := HB_QSelf()
   local nRow     := if( !empty( Self:bRow ),     eval( Self:bRow ),    Self:nTop   )
   local nLeft    := if( !empty( Self:bCol ),     eval( Self:bCol ),    Self:nLeft  )
   local nWidth   := if( !empty( Self:bWidth ),   eval( Self:bWidth ),  Self:nWidth )
   local nHeight  := if( !empty( Self:bHeight ),  eval( Self:bHeight ), Self:nHeight )

   Self:Move( nRow, nLeft, nWidth, nHeight )  

RETURN ( Self )

//----------------------------------------------------------------------------//

STATIC FUNCTION CheckBoxClick( lValue )

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

RETURN ( Self )

//----------------------------------------------------------------------------//

STATIC FUNCTION TXBrowseToExcel( bProgress, nGroupBy, aCols )

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
      RETURN Self
   endif

   DEFAULT aCols         := ::GetVisibleCols()

   if Empty( aCols )
      RETURN Self
   endif

   if ( oExcel := ExcelObj() ) == nil
      msgStop( "Excel not installed" )
      RETURN Self
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

RETURN oSheet

//----------------------------------------------------------------------------//

FUNCTION notValidateDialog( uDialogs ) 

RETURN ( !validateDialog( uDialogs ) ) 

//----------------------------------------------------------------------------//

FUNCTION validateDialog( uDialogs ) 

   local oDialog

   if hb_isobject( uDialogs )
      RETURN ( validateControls( uDialogs ) )
   end if 

   if hb_isarray( uDialogs )
      for each oDialog in uDialogs 
         if !( validateControls( oDialog ) )
            RETURN ( .f. )
         end if 
      next
   end if 

RETURN ( .t. )

//----------------------------------------------------------------------------//

FUNCTION validateControls( oDialog ) 

   local oControl
   local aControls   := oDialog:aControls

   if empty( aControls )
      RETURN ( .t. )
   end if 

   for each oControl in aControls

      if empty( oControl:bWhen ) .or. eval( oControl:bWhen )

         if !empty( oControl:bValid ) .and. !eval( oControl:bValid )

            oControl:SetFocus()

            RETURN ( .f. )

         endif

      end if 

   next

RETURN ( .t. )

//----------------------------------------------------------------------------//

FUNCTION clp2xlnumpic( cPic, lEnglish )

   local c 
   local aPic 
   local cFormat

   DEFAULT lEnglish  := .f.

   if cPic == nil
      cFormat  := if( lEnglish, "#,##0", "#.##0" )
   else
      cPic     := strtran( cPic, "#", "9" )
      aPic     := hb_atokens( cPic, " " )

      cFormat  := ""
      for each c in aPic
         if Left( c, 1 ) != "@"
            if "9" $ c
               if Left( c, 1 ) == '$'
                  cFormat  += '$'
               endif
               cFormat  += if( ",9" $ cPic, if( lEnglish, "#,##0", "#.##0" ), "0" )
               if ".9" $ c
                  cFormat  += if( lEnglish, ".", "," )
                  cFormat  += StrTran( SubStr( c, At( ".", c ) + 1 ), "9", "0" )
               endif
               cFormat  += " "
            else
               cFormat  += ( '"' + c + '" ' )
            endif
         endif
      next
   endif

RETURN trim( cFormat )

//------------------------------------------------------------------//
