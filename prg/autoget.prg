/*    
TAutoget
(c)2011 Daniel Garcia-Gil <danielgarciagil@gmail.com>
*/

#include "fivewin.ch"
#include "constant.ch"

#define CS_DROPSHADOW       0x00020000
#define GCL_STYLE           (-26)
#define DEFAULT_GUI_FONT     17
#define TME_LEAVE             2   
#define WM_MOUSELEAVE       675
#define COLOR_CAPTIONTEXT       9


#define DATATYPE_HASH 256

CLASS TAutoGet FROM TGet

   DATA aGradList   //will be custom
   DATA aGradItem       //will be custom
   DATA nClrLine    //will be custom
   DATA nClrText, nClrSel
   
   DATA uDataSource
   DATA uOrgData
   DATA nDataType
   DATA cField
   DATA oList
   DATA bCreateList
   DATA bCloseList
   DATA nLHeight

   METHOD New(nRow, nCol, bSetGet, oWnd, nWidth, nHeight, cPict, bValid,;
            nClrFore, nClrBack, oFont, lDesign, oCursor, lPixel, cMsg,;
            lUpdate, bWhen, lCenter, lRight, bChanged, lReadOnly,;
            lPassword, lNoBorder, nHelpId, lSpinner,;
            bUp, bDown, bMin, bMax, bAction, cBmpName, cVarName, cCueText,;
            uDataSrc, Flds    , nLHeight,  bCreateList,;
            aGradList, aGradItem, nClrLine) CONSTRUCTOR

   METHOD ReDefine( nId,       bSetGet,  oWnd,    nHelpId, cPict,   bValid, nClrFore,;
                   nClrBack,  oFont,    oCursor, cMsg,    lUpdate, bWhen,  bChanged,;
                   lReadOnly, lSpinner, bUp,     bDown,   bMin,    bMax,   bAction,; 
                   cBmpName,  cVarName, cCueText ) CONSTRUCTOR


   
   METHOD CloseList() INLINE  If(  ::ValidList(), ( ::oList:End(), ::oList:hWnd := nil, Eval( ::bCloseList, Self ) ), )
   
   METHOD CreateList( uDataSource ) 
   
   METHOD KeyChar( nKey, nFlags ) INLINE ::OpenList( nKey, nFlags )

   METHOD KeyDown( nKey, nFlags ) 


   METHOD OpenList()
   
   METHOD LostFocus()
   
   METHOD MouseWheel( nKeys, nDelta, nXPos, nYPos )
   
   METHOD SetList( uDataSource, cField )   INLINE  ::uDataSource := uDataSource, ::cField := cField
   
   METHOD ValidList() INLINE ( ::oList != NIL .and. ::oList:hWnd != NIL )


END CLASS

//---------------------------------------------------------------------------//

METHOD New( nRow, nCol, bSetGet, oWnd, nWidth, nHeight, cPict, bValid,;
            nClrFore, nClrBack, oFont, lDesign, oCursor, lPixel, cMsg,;
            lUpdate, bWhen, lCenter, lRight, bChanged, lReadOnly,;
            lPassword, lNoBorder, nHelpId, lSpinner,;
            bUp, bDown, bMin, bMax, bAction, cBmpName, cVarName, cCueText,;
            uDataSrc, Flds    , nLHeight,  bCreateList,;
            aGradList, aGradItem, nClrLine, nClrText, nClrSel  ) CLASS TAutoGet
   
   DEFAULT Flds     := 1
   DEFAULT nLHeight := 170
   DEFAULT          aGradItem := { { 1/2, nRGB( 253, 249, 225 ), nRGB( 253, 249, 225 ) },;
   	                           { 1/2, nRGB( 253, 245, 206 ), nRGB( 253, 249, 225 ) } },;
                    aGradList := { { 1, nRGB( 248, 248, 248 ), nRGB( 228, 228, 228 ) } },;
                    nClrLine  := nRGB( 251, 203, 9 ),;//nRGB( 184, 214, 251 )
                    nClrSel  := nRGB( 199, 116, 5 ),;
                    nClrText := GetSysColor( COLOR_CAPTIONTEXT )

   ::cField   = Flds
   ::nLHeight = nLHeight 

   ::bCloseList  = {| | ::uDataSource := ::uOrgData }
   ::uDataSource = uDataSrc
   ::bCreateList = bCreateList
   ::SetList( uDataSrc, ::cField )
   ::aGradList = aGradList
   ::aGradItem = aGradItem 
   ::nClrLine  = nClrLine
   ::nClrText  = nClrText
   ::nClrSel   = nClrSel

   ::Super:New(nRow   , nCol    , bSetGet  , oWnd     , nWidth   , nHeight,;
             cPict  , bValid  , nClrFore , nClrBack , oFont    , lDesign,;
             oCursor, lPixel  , cMsg     , lUpdate  , bWhen    , lCenter,;
             lRight , bChanged, lReadOnly, lPassword, lNoBorder, nHelpId,;
             lSpinner, bUp    , bDown    , bMin     , bMax )   
   
RETURN Self

//---------------------------------------------------------------------------//

METHOD ReDefine( nId,       bSetGet,  oWnd,    nHelpId, cPict,   bValid, nClrFore,;
                 nClrBack,  oFont,    oCursor, cMsg,    lUpdate, bWhen,  bChanged,;
                 lReadOnly, lSpinner, bUp,     bDown,   bMin,    bMax,   bAction,; 
                 cBmpName,  cVarName, cCueText,;
                 uDataSrc, Flds    , nLHeight,  bCreateList,;
                 aGradList, aGradItem, nClrLine, nClrText, nClrSel ) CLASS TAutoGet

   DEFAULT Flds     := 1
   DEFAULT nLHeight := 170
   DEFAULT          aGradItem := { { 1/2, nRGB( 253, 249, 225 ), nRGB( 253, 249, 225 ) },;
   	                           { 1/2, nRGB( 253, 245, 206 ), nRGB( 253, 249, 225 ) } },;
                    aGradList := { { 1, nRGB( 248, 248, 248 ), nRGB( 228, 228, 228 ) } },;
                    nClrLine  := nRGB( 251, 203, 9 ),;//nRGB( 184, 214, 251 )
                    nClrSel   := nRGB( 199, 116, 5 ),;
                    nClrText  := GetSysColor( COLOR_CAPTIONTEXT )
                    
   ::cField   = Flds
   ::nLHeight = nLHeight 

   ::bCloseList  = {| | ::uDataSource := ::uOrgData }
   ::uDataSource = uDataSrc
   ::bCreateList := bCreateList
   ::SetList( uDataSrc, ::cField )
   ::aGradList = aGradList
   ::aGradItem = aGradItem 
   ::nClrLine  = nClrLine
   ::nClrText  = nClrText
   ::nClrSel   = nClrSel
   
   ::Super:ReDefine( nId,       bSetGet,  oWnd,    nHelpId, cPict,   bValid, nClrFore,;
                   nClrBack,  oFont,    oCursor, cMsg,    lUpdate, bWhen,  bChanged,;
                   lReadOnly, lSpinner, bUp,     bDown,   bMin,    bMax,   bAction,;
                   cBmpName,  cVarName, cCueText ) 
                 
RETURN Self                 

//---------------------------------------------------------------------------//

METHOD CreateList() CLASS TAutoGet

   if ! ::ValidList()
      ::oList := TGetList():New( ::nTop + ::nHeight + 1, ::nLeft, ::oWnd, ::nWidth, ;
                                 ::nLHeight, Self, ::aGradItem, ::aGradList, ::nClrLine,;
                                 ::nClrText, ::nClrSel )      
      ::oList:SetList( ::uDataSource, ::cField )
      if ::oList:KeyCount() == 0
         ::uDataSource := ::uOrgData
         ::oList:end()
         ::oList := NIL
      else
         ::oList:Adjust()
 //        ShowWindow( ::oList:hWnd, 8 )
//         SetWindowPos( ::oList:hWnd, -1, ::oList:nLeft, ::oList:nTop, ::oList:nWidth, ::oList:nHeight, 0x0080 )
      endif 
   else 
      if ::oList != NIL
         ::uDataSource := Eval( ::bCreateList, ::uDataSource, AllTrim( ::oGet:Buffer ), Self )  
         ::oList:SetList( ::uDataSource, ::cField )
         if ::oList:KeyCount() == 0 
            ::uDataSource := ::uOrgData
            ::oList:end()
            ::oList = NIL
         else         
            ::oList:Adjust()
            ::oList:Refresh()
         endif
      endif
   endif

RETURN NIL

//---------------------------------------------------------------------------//

METHOD LostFocus( hWndLost ) CLASS TAutoGet

   ::CloseList()
   
RETURN ::Super:LostFocus( hWndLost )

//---------------------------------------------------------------------------//

METHOD MouseWheel( nKeys, nDelta, nXPos, nYPos ) CLASS TAutoGet

   local aPos := { nYPos, nXPos }
   
   if ::ValidList()
      if nDelta < 0 
         ::oList:GoDown()
      else 
         ::oList:GoUp()
      endif
   endif

return nil

//---------------------------------------------------------------------------//

METHOD KeyDown( nKey, nFlags ) CLASS TAutoGet


   if ::ValidList()
      switch nKey
         case VK_BACK
            ::CreateList()
            return ::Super:KeyDown( nKey, nFlags )
         case VK_LEFT
         case VK_RIGHT
            
            return ::Super:KeyDown( nKey, nFlags )
            EXIT
         case VK_DOWN
            ::oList:GoDown()
            EXIT
         case VK_UP
            ::oList:GoUp()            
      endswitch
   else 
      return ::Super:KeyDown( nKey, nFlags )
   endif

RETURN 0

//---------------------------------------------------------------------------//

METHOD OpenList( nKey, nFlags ) CLASS TAutoGet

   local nTop   := ::nBottom //* WIN_CHARPIX_H
   local nLeft  := ::nLeft //* WIN_CHARPIX_W
   local aPoint := { nTop, nLeft }
   local nBottom, nRight
   local nRet

   switch nKey
      case VK_ESCAPE         
         ::CloseList()
         return ::Super:KeyChar( nKey, nFlags )
      case VK_BACK
         nRet = ::Super:KeyChar( nKey, nFlags )
         
         if Len( AllTrim( ::oGet:Buffer ) ) == 0 
            ::CloseList()
         else
            ::uDataSource := Eval( ::bCreateList, ::uDataSource, AllTrim( ::oGet:Buffer ), Self )    
            ::CreateList()
         endif
         return nRet
      case VK_RETURN         
      case VK_DOWN
         return ::Super:KeyChar( nKey, nFlags )
   end switch
   
   nret = ::Super:KeyChar( nKey, nFlags )
   
   if ::oGet:Buffer != nil .and. len( alltrim( ::oGet:Buffer ) ) > 0
      // msgWait( ::oGet:Buffer, , 0.000001 )
      if empty( ::uOrgData ) //? ( hb_valToExp( ::uDataSource ) )
         ::uOrgData = ::uDataSource
      endif
      ::uDataSource := Eval( ::bCreateList, ::uDataSource, AllTrim( ::oGet:Buffer ), Self )
      ::CreateList()
   endif
 
RETURN  nRet

//---------------------------------------------------------------------------//


CLASS TGetList FROM TControl

   CLASSDATA lRegistered AS LOGICAL
  
   DATA aGradList   //will be custom
   DATA aGradItem       //will be custom
   DATA nClrLine    //will be custom
   DATA nClrText, nClrSel
   
   
   DATA uOrgValue
   
   DATA bKeyCount
  
   DATA bData

   DATA lSBVisible

   DATA nDataType
   DATA nRowHeight
   DATA nMaxHeight
   
   DATA oGet
   
   DATA nFirstRow
   DATA nRecNo 

   DATA nRowAt
   
   METHOD New( nTop, nLeft, oWnd, nWidth, nHeight )

   METHOD Adjust()

   METHOD KeyCount() INLINE Eval( ::bKeyCount )

   METHOD Display() INLINE ::BeginPaint(), ::Paint(), ::EndPaint(), 0   
   METHOD EraseBkGnd( hDC ) INLINE 1
   
   METHOD GetRowAt( nRow ) INLINE Min( ::RowCount(),  Int( nRow / ::nRowHeight ) + 1 )
   
   METHOD GoDown()
   METHOD GoUp()
   
   METHOD HandleEvent( nMsg, nWParam, nLParam ) 
   
   METHOD LButtonUp( nRow, nCol )
   
   METHOD MouseLeave()
   
   METHOD MouseMove( nRow, nCol, nFlags )
   
   METHOD Paint()
   METHOD PaintData( hDC )

   METHOD SetList( uDataSource, cField )

   METHOD RowCount()     INLINE Int( ::nHeight  / ::nRowHeight )


END CLASS

//---------------------------------------------------------------------------//

METHOD New( nTop, nLeft, oWnd, nWidth, nHeight, oGet, aGradItem, aGradList, nClrLine, nClrText, nClrSel ) CLASS TGetList

   local n

   DEFAULT nTop     := 0, nLeft := 0,;
           oWnd     := GetWndDefault()
   
   ::nStyle    = nOR( WS_CHILD, WS_BORDER, WS_VISIBLE )
   ::nId       = ::GetNewId()
   ::oWnd      = oWnd
   ::nTop      = nTop
   ::nLeft     = nLeft
   ::nBottom   = ::nTop + nHeight - 1
   ::nRight    = ::nLeft + nWidth - 1
   ::lDrag     = .F.
   ::lCaptured = .f.
   ::oGet      = oGet
   ::Register()
   ::aGradItem     = aGradItem
   ::aGradList = aGradList
   ::nClrLine  = nClrLine
   ::nClrText  = nClrText
   ::nClrSel   = nClrSel
   
   ::oBrush = TBrush():New( , CLR_WHITE )   
   
   if ::oFont != nil
      ::oFont:End()
      ::oFont = NIL
   endif

   ::oFont := TFont():New()
   ::oFont:hFont := GetStockObject( DEFAULT_GUI_FONT )

   
   ::nFirstRow = 1
   
   ::Create()
   ::nMaxHeight := ::nHeight

return Self

//---------------------------------------------------------------------------//

METHOD SetList( uDataSource, cField ) CLASS TGetList

   local cType := ValType( uDataSource )
   local bExpr
   
   DEFAULT cField := 1
   
    
   if cType == "A"
      ::nDataType = DATATYPE_ARRAY
      ::bKeyCount = { || Len( ::oGet:uDataSource ) }   
      ::bData     = { | nRow | ::oGet:uDataSource[ nRow ][ cField ] }  
   elseif cType == "H"    
      ::nDataType = DATATYPE_HASH
      ::bKeyCount = { || Len( ::oGet:uDataSource ) }   
      ::bData     = { | nRow | ::oGet:uDataSource[ nRow ][ cField ] } 
   endif


return NIL

//---------------------------------------------------------------------------//

METHOD Adjust() CLASS TGetList
   
   local nVHeight
   local nFlags := 0x0200
   
   ::nRowHeight = FontHeight( Self, ::oFont ) + 6
   
   nVHeight := Min( ::nMaxHeight, ::KeyCount() * ::nRowHeight )
   
   ::nRowAt = 0
   ::nFirstRow = 1
   
   if ::nMaxHeight > nVHeight
      ::Move( , , , nVHeight + 2 )
   else 
      ::Move( , , , Int( ::nMaxHeight / ::nRowHeight ) * ::nRowHeight + 2 )
   endif

RETURN NIL

//---------------------------------------------------------------------------//

METHOD GoDown() CLASS TGetList
   
   local nMaxRow := ::RowCount()
   
   if ::nRowAt == 0
      ::uOrgValue = ::oGet:oGet:Buffer
   endif
   
   if ::nFirstRow + ::nRowAt - 1 < ::KeyCount()
      ::nRowAt++
      if ::nRowAt > nMaxRow
         ::nFirstRow++
      endif
      ::nRowAt = Min( nMaxRow, ::nRowAt )
      ::oGet:cText = Eval( ::bData, ::nFirstRow + ::nRowAt - 1 )
      ::oGet:setPos( Len( AllTrim( ::oGet:cText ) ) + 1 )
      ::refresh()
   endif

RETURN NIL

//----------------------------------------------------------------------------//

METHOD GoUp() CLASS TGetList

   local nMaxRow := ::RowCount()
   
   if ::nFirstRow + ::nRowAt - 1 > 1
      ::nRowAt--
      if ::nRowAt < 1
         ::nFirstRow--
      endif
      ::nRowAt = Max( 1, ::nRowAt )
      ::oGet:cText = Eval( ::bData, ::nFirstRow + ::nRowAt - 1 )
      ::oGet:setPos( Len( AllTrim( ::oGet:cText ) ) + 1 )
      ::refresh()
   else 
      if ::uOrgValue != NIL
         ::oGet:cText = ::uOrgValue
         ::oGet:setPos( Len( AllTrim( ::uOrgValue ) ) + 1 )
      endif
      ::oGet:CloseList()
   endif   

RETURN NIL
//----------------------------------------------------------------------------//

METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TGetList

   switch nMsg 
      case WM_MOUSELEAVE
         return ::MouseLeave( nHiWord( nLParam ), nLoWord( nLParam ), nWParam )
         exit
   endswitch

return ::Super:HandleEvent( nMsg, nWParam, nLParam )

//----------------------------------------------------------------------------//

METHOD LButtonUp( nRow, nCol ) CLASS TGetList

   local nRowAt := ::GetRowAt( nRow )
   
   ::oGet:cText = Eval( ::bData, ::nFirstRow + ::nRowAt - 1 )
   ::oGet:setPos( Len( AllTrim( ::oGet:cText ) ) + 1 )   

   ::oGet:CloseList()

RETURN NIL

//----------------------------------------------------------------------------//

METHOD MouseLeave() CLASS TGetList

   ::nRowAt = 0
   
   ::Refresh()

RETURN nil

//---------------------------------------------------------------------------//

METHOD MouseMove( nRow, nCol, nFlags ) CLASS TGetList

   local nRowAt := ::GetRowAt( nRow )

   ::nRowAt = nRowAt
   
   ::Refresh()
   
   TrackMouseEvent( ::hWnd, TME_LEAVE )

return ::Super:MouseMove( nRow, nCol, nFlags )

//---------------------------------------------------------------------------//

METHOD Paint() CLASS TGetList

   local aInfo 
   local aRect  := GetClientRect( ::hWnd )
   local n, nRowPos
   local nMaxRow := ::RowCount()
   local aBack := ::aGradList 
   
   aInfo   = ::DispBegin()
   
   GradientFill( ::hDC, aRect[ 1 ], aRect[ 2 ], aRect[ 3 ], aRect[ 4 ], aBack )  
   nRowPos = 1

   while nRowPos <= nMaxRow 
      ::PaintData( ::hDC, nRowPos )   
      nRowPos ++  
      
   end

   ::DispEnd( aInfo )

RETURN NIL

//---------------------------------------------------------------------------//

METHOD PaintData( hDC, nAtItem ) CLASS TGetList

   local aRect := { ( nAtItem - 1 ) * ::nRowHeight , 1, nAtItem * ::nRowHeight, ::nWidth-1 }
   local hBrush
   local hOldBrush
   local nRound := 3
   local aGrad := ::aGradItem
   local nClrOut := ::nClrLine
   local nRecNo := Min( ::KeyCount(), ::nFirstRow + nAtItem - 1 )
   local hOldFonf
   local nOldColor 
   local nColorTxt := ::nClrText//GetSysColor( COLOR_CAPTIONTEXT )

   if ::nRowAt == nAtItem
      if aGrad != nil
         hBrush = GradientBrush( hDC, 0, 0, ::nWidth, ::nRowHeight, aGrad )
         hOldBrush = SelectObject( hDC, hBrush )
         
         Roundrect( hDC, aRect[ 2 ], ;
                   aRect[ 1 ], ;
                   aRect[ 4 ]-2, ;
                   aRect[ 3 ], nRound, nRound )
      
         //Bourder Out
         RoundBox( hDC, aRect[ 2 ], ;
                   aRect[ 1 ], ;
                   aRect[ 4 ]-2, ;
                   aRect[ 3 ], nRound, nRound, nClrOut )   
            
         SelectObject( hDC, hOldBrush )
            
         DeleteObject( hBrush )
      endif
      nColorTxt = ::nClrSel
   endif      
   
   hOldFonf = SelectObject( hDC, ::oFont:hFont )
   nOldColor = SetTextColor( hDC, nColorTxt )
   DrawTextTransparent( hDC, Eval( ::bData, nRecNo ), { aRect[ 1 ] + 2, aRect[ 2 ] + 2, aRect[ 3 ], aRect[ 4 ] - 2 } , 0 )
   SelectObject( hDC, hOldFonf )
   SetTextColor( hDC, nOldColor )

RETURN NIL

//---------------------------------------------------------------------------//

static function FontHeight( oObj, oFont )

   local hDC
   local nHeight

   hDC := oObj:GetDC()
   oFont:Activate( hDC )
   nHeight := GetTextHeight( oObj:hWnd, hDC )
   oObj:ReleaseDC()

return nHeight

//-----------------------------------------//

static function IsRecordSet( o )

   local lRecSet  := .f.

#ifdef __XHARBOUR__
   lRecSet  := ( o:IsDerivedFrom( "TOLEAUTO" ) .and. "RECORDSET" $ Upper( o:cClassName ) )
#else
   local u

   TRY
      u  := o:Fields:Count()
      lRecSet  := .t.
   CATCH
   END
#endif

return lRecSet

//-----------------------------------------//