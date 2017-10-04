#include "FiveWin.ch"

//----------------------------------------------------------------------------//

CLASS TMsgItem

   DATA   oMsgBar
   DATA   cMsg
   DATA   nWidth, nClrText, nClrPane, nClrDisabled
   DATA   bMsg, bAction
   DATA   oFont
   DATA   lActive, lTimer AS LOGICAL
   DATA   lWasActive
   DATA   hBitmap1, hPalette1
   DATA   hBitmap2, hPalette2
   DATA   cToolTip
   DATA   hBack
   DATA   bRClicked
   DATA   OnClick

   CLASSDATA aProperties INIT { "cMsg", "nWidth" }
   CLASSDATA aEvents INIT { { "OnClick", "oItem" } }

   METHOD New( oMsgBar, cMsg, nWidth, oFont, nClrText, nClrBack, lAdd,;
               bAction, cBmp1, cBmp2, cToolTip ) CONSTRUCTOR

   METHOD Refresh()

   METHOD SetFont( oFont ) INLINE ::oFont:End(), ::oFont := oFont
   METHOD Paint()

   METHOD SetText( cMsg ) INLINE ::cMsg := cValToChar( cMsg ), If( IsWindowVisible( ::oMsgBar:hWnd ), ::Paint(),)

   METHOD Click( nRow, nCol ) INLINE If( ::bAction != nil, Eval( ::bAction, nRow, nCol ),)

   METHOD IsOver( nRow, nCol )

   METHOD Load( cInfo )

   METHOD nLeft()

   METHOD RClick( nRow, nCol ) INLINE If( ::bRClicked != nil, Eval( ::bRClicked, nRow, nCol ), )   

   METHOD Save()
   
   METHOD End()
   
ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oMsgBar, cMsg, nWidth, oFont, nClrText, nClrBack, lAdd, bAction,;
            cBmp1, cBmp2, cToolTip ) CLASS TMsgItem

   DEFAULT oMsgBar := GetMsgBarDefault(),;
           nClrText := If( oMsgBar != nil, oMsgBar:nClrText, CLR_BLACK ),;
           nClrBack := If( oMsgBar != nil, oMsgBar:nClrPane, CLR_WHITE ),;
           lAdd := .F., cMsg := "", cToolTip := ""

   ::oMsgBar = oMsgBar
   ::cMsg    = cMsg
   ::oFont   = If( oFont != nil, oFont, If( ::oMsgBar != nil, ::oMsgBar:oFont, nil ) )
   ::bAction = bAction
   ::lActive = .T.
   ::lWasActive = .T.
   ::lTimer  = .F.
   ::cToolTip = cToolTip

   if Valtype( nClrText ) == "C"
      ::nClrText := nGetForeRGB( nClrText )
      ::nClrPane := nGetBackRGB( nClrText )
   else
      ::nClrText := nClrText
      ::nClrPane := nClrBack
   endif

   if cBmp1 != nil
      if File( cBmp1 )
         ::hBitmap1  = ReadBitmap( 0, cBmp1 )
         ::hPalette1 = 0
      else
         ::hBitmap1  = LoadBitmap( GetResources(), cBmp1 )
         ::hPalette1 = 0
      endif

      if ::hBitmap1 == 0
         ::hBitmap1 := nil
      else
         DEFAULT nWidth := nBmpWidth( ::hBitmap1 ) + 7
      endif
   endif

   if cBmp2 != nil
      if File( cBmp2 )
         ::hBitmap2  = ReadBitmap( 0, cBmp2 )
         ::hPalette2 = 0
      else
         ::hBitmap2  = LoadBitmap( GetResources(), cBmp2 )
         ::hPalette2 = 0
      endif
      if ::hBitmap2 == 0
         ::hBitmap2 := nil
      else
         DEFAULT nWidth := nBmpWidth( ::hBitmap2 ) + 7
      endif
   endif

   DEFAULT nWidth := 40

   ::nWidth = nWidth

   if ! Empty( ::cToolTip )
      ::oMsgBar:cToolTip := ""
   endif

   if lAdd
      oMsgBar:AddItem( Self )
   endif

return Self

//----------------------------------------------------------------------------//

METHOD Load( cInfo ) CLASS TMsgItem

   local nPos := 1, nProps, n, nLen
   local cData, cType, cBuffer

   nProps = Bin2I( SubStr( cInfo, nPos, 2 ) )
   nPos += 2

   // LogFile( "c:\load.txt", { "Props", nProps } )

   for n = 1 to nProps
      nLen  = Bin2I( SubStr( cInfo, nPos, 2 ) )
      nPos += 2
      cData = SubStr( cInfo, nPos, nLen )
      nPos += nLen
      cType = SubStr( cInfo, nPos++, 1 )
      nLen  = Bin2I( SubStr( cInfo, nPos, 2 ) )
      nPos += 2
      cBuffer = SubStr( cInfo, nPos, nLen )
      nPos += nLen

      // LogFile( "c:\load.txt", { cData, cType, Len( cBuffer ), cBuffer } )

      do case
         case cType == "A"
              OSend( Self, "_" + cData, ARead( cBuffer ) )

         case cType == "O"
              if cData == "oMenu"
                 ::SetMenu( ORead( cBuffer ) )
              else
                 OSend( Self, "_" + cData, ORead( cBuffer ) )
              endif

         case cType == "C"
              if SubStr( cData, 1, 2 ) == "On"
                 if ::oWnd == nil
                    OSend( Self, "_" + cData, { | u1, u2, u3, u4 | OSend( Self, cBuffer, u1, u2, u3, u4 ) } )
                 else
                    OSend( Self, "_" + cData, { | u1, u2, u3, u4 | OSend( Self:oWnd, cBuffer, u1, u2, u3, u4 ) } )
                 endif
              else
                 OSend( Self, "_" + cData, cBuffer )
              endif
              if cData == "cVarName" .and. ! GetWndDefault() == Self
                 OSend( GetWndDefault(), "_" + ::cVarName, Self )
              endif

         case cType == "L"
              OSend( Self, "_" + cData, cBuffer == ".T." )

         case cType == "N"
              OSend( Self, "_" + cData, Val( cBuffer ) )
      endcase
   next

   if Upper( ::ClassName() ) $ "TLISTBOX;TCOMBOBOX;TTREEVIEW"
      ::SetItems( ::aItems )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD nLeft() CLASS TMsgItem

   local n := Len( ::oMsgBar:aItems ), nPos := ::oMsgBar:nRight - ;
              If( IsAppThemed(), 13, ;
                  If( IsZoomed( ::oMsgBar:oWnd:hWnd ), 3, 13 ) )

   while n > 0 .and. ! ::oMsgBar:aItems[ n ] == Self
      nPos -= ( ::oMsgBar:aItems[ n ]:nWidth + 4 )
      n--
   end
   nPos -= ( ::nWidth - 2 )

return nPos

//----------------------------------------------------------------------------//

METHOD IsOver( nRow, nCol ) CLASS TMsgItem

   local nLeft := ::nLeft()

return nCol >= ( nLeft - 1 ) .and. ( nCol <= nLeft + ( ::nWidth - 7 ) ) .and. ;
       nRow > 5

//----------------------------------------------------------------------------//

METHOD Paint() CLASS TMsgItem

   local nCount, nClrBack
   local nLeft := ::nLeft()
   local hBmp, nBmpWidth := 0
   local hDC := ::oMsgBar:GetDC()
   local hDCMem, hOld
   
   if ::oMsgBar:l2007 .or. ::oMsgBar:l2010
      ::oMsgBar:PaintBar( nLeft - 2, ::nWidth + 2 )
      hDCMem = CreateCompatibleDC( hDC )
      If ::hBack == NIL
         ::hBack  = CreateCompatibleBitmap( hDC, ::nWidth + 4, ::oMsgBar:nHeight )
         hOld = SelectObject( hDCMem, ::hBack )
         BitBlt( hDCMem, 0, 0, ::nWidth + 4, ::oMsgBar:nHeight, hDC, ::nLeft() - 4, 0, 0xCC0020 )
         SelectObject( hDCMem, hOld )
      endif
      hOld = SelectObject( hDCMem, ::hBack )
      BitBlt( hDC, ::nLeft() - 4, 0, ::nWidth + 4, ::oMsgBar:nHeight, hDCMem, 0, 0, 0xCC0020 )
      DeleteDC( hDCMem )
   endif

   if ::hBitmap1 != nil
      hBmp = If( ::lActive, ::hBitmap1, ;
                 If( ::hBitmap2 != nil, ::hBitmap2, ::hBitmap1 ) )
      nBmpWidth  = nBmpWidth( hBmp )
      DrawMasked( hDC, hBmp, 2, nLeft + 1 )
   endif

   if ::oMsgBar:l2007 .or. ::oMsgBar:l2010
      ::oMsgBar:Say( ::oMsgBar:nHeight / 4 - 2,;
             nLeft - 1 + ( ::nWidth / 2 ) - ( GetTextWidth( hDC, AllTrim( ::cMsg ), ::oFont:hFont ) / 2 ),;
             AllTrim( ::cMsg ), If( ::lActive, ::nClrText, ::nClrDisabled ),;
             ::nClrPane, ::oFont, .T., .T. )
      WndBoxIn( hDC, 2, nLeft - 4, ::oMsgBar:nHeight - 2, nLeft - 3 )
   else
      DrawMsgItem( hDC, ::cMsg,;
                   { 5, nLeft + nBmpWidth, ::oMsgBar:nHeight - 6,;
                   	 nLeft + ( ::nWidth - 4 ) },;
                   	 If( ::lActive, ::nClrText, ::nClrDisabled ),;
                     ::nClrPane, ::oFont:hFont )

      WndBoxIn( hDC, 0, nLeft - 4, ::oMsgBar:nHeight - 1, nLeft - 3 ) // Statusbar Parts look
      if ::oMsgBar:lInset
         WndBoxIn( hDC, 3, nLeft + 1, ::oMsgBar:nHeight - 5, nLeft + ::nWidth - 4 ) // Original Depressed Look
      endif         

   endif

   ::oMsgBar:ReleaseDC()

return nil

//----------------------------------------------------------------------------//

METHOD Refresh() CLASS TMsgItem

   local cMsg

   if ::bMsg != nil
      cMsg = cValToChar( Eval( ::bMsg ) )
      if cMsg != ::cMsg .or. ::lActive != ::lWasActive
         ::cMsg = cMsg
         if IsWindowVisible( ::oMsgBar:hWnd )
            ::Paint()
         endif   
         ::lWasActive = ::lActive
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Save() CLASS TMsgItem

   local n
   local cType, cInfo := "", cMethod
   local o := &( ::ClassName() + "()" )
   local uData, nProps := 0

   o = o:New()

   for n = 1 to Len( ::aProperties )
       if ! ( uData := OSend( Self, ::aProperties[ n ] ) ) == ;
          OSend( o, ::aProperties[ n ] )
          cInfo += ( I2Bin( Len( ::aProperties[ n ] ) ) + ;
                     ::aProperties[ n ] )
          nProps++
          cType = ValType( uData )
          do case
             case cType == "A"
                  cInfo += ASave( uData )

             case cType == "O"
                  cInfo += uData:Save()

             otherwise
                  cInfo += ( cType + I2Bin( Len( uData := cValToChar( uData ) ) ) + ;
                             uData )
          endcase
       endif
   next

   if ::aEvents != nil
      for n = 1 to Len( ::aEvents )
         if ( cMethod := OSend( Self, ::aEvents[ n ][ 1 ] ) ) != nil
            cInfo += ( I2Bin( Len( ::aEvents[ n ][ 1 ] ) ) + ;
                       ::aEvents[ n ][ 1 ] )
            nProps++
            cInfo += ( "C" + I2Bin( Len( cMethod ) ) + cMethod )
         endif
      next
   endif

   o:End()

return "O" + I2Bin( 2 + Len( ::ClassName() ) + 2 + Len( cInfo ) ) + ;
       I2Bin( Len( ::ClassName() ) ) + ;
       ::ClassName() + I2Bin( nProps ) + cInfo
       
//----------------------------------------------------------------------------//

METHOD End() CLASS TMsgItem

   if ! Empty( ::hBitmap1 )
      DeleteObject( ::hBitmap1 )
      ::hBitmap1 = nil
   endif  
   
   if ! Empty( ::hBitmap2 )
      DeleteObject( ::hBitmap2 )
      ::hBitmap2 = nil
   endif  
           
   if ! Empty( ::oFont )
      ::oFont:End()
   endif
   
return nil

//----------------------------------------------------------------------------//              