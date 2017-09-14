#include "FiveWin.ch"

#define WHITE_BRUSH   0
#define LTGRAY_BRUSH  1
#define GRAY_BRUSH    2
#define DKGRAY_BRUSH  3
#define BLACK_BRUSH   4
#define NULL_BRUSH    5
#define HOLLOW_BRUSH  NULL_BRUSH

//----------------------------------------------------------------------------//

CLASS TBrush

   DATA   hBrush, hBitmap, hBmpOrgl
   DATA   nBmpFormat INIT 0
   DATA   nCount, cStyle, nRGBColor, cBmpFile, cBmpRes
   DATA   lSystem
   DATA   aGrad
   DATA   uSource
   DATA   nResizeMode INIT 0
   DATA   oRect   // rect for which hBrush matches if nResizeMode > 0
   DATA   Cargo

   CLASSDATA aBrushes INIT {}

   CLASSDATA aProperties INIT { "cStyle", "cBmpFile", "cBmpRes", "nRGBColor", "lSystem" }

   METHOD New( cStyle, nRGBColor, cBmpFile, cBmpRes, nBmpHandle )
               // We don't use CONSTRUCTOR clause here as we are going to
               // change Self

   METHOD cGenPRG()

   METHOD End()

   METHOD Load( cInfo )

   METHOD Release() INLINE ::End()

   METHOD Save()

   METHOD Resized( x, y, nMode ) // returns new brush object

   METHOD Cropped( oWnd, oRect ) // returns new brush object

   METHOD SaveToText( nIndent )

   METHOD Resize( oWnd, nOrgX, nOrgY )

   METHOD Copy()

   METHOD SameAs( oBrush )

   OPERATOR "==" ARG o INLINE ::SameAs( o )

   OPERATOR "!=" ARG o INLINE .not. ::SameAs( o )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cStyle, nRGBColor, cBmpFile, cBmpRes, nBmpHandle, cResizeMode ) CLASS TBrush

   local nAt, nFormat := 0
   local aNewTypes := { "BORLAND", "BRICKS", "TILED", "TABS" }
   local aStdTypes := { "HORIZONTAL", "VERTICAL", "FDIAGONAL", "BDIAGONAL",;
                        "CROSS", "DIAGCROSS" }

   ::hBrush    = 0
   ::hBitmap   = 0
   ::cStyle    = cStyle
   ::nRGBColor = nRGBColor
   ::cBmpFile  = cBmpFile
   ::cBmpRes   = cBmpRes
   ::lSystem   = .f.

   if ValType( nBmpHandle ) == 'N'
      if IsGDIObject( nBmpHandle )
         ::cBmpFile  = LTrim( Str( nBmpHandle ) )
      else
         nBmpHandle  = nil
      endif
   elseif ValType( nBmpHandle ) == 'A'
      ::aGrad        = nBmpHandle
      ::nResizeMode  = 1
   else
      nBmpHandle     = nil
   endif

   if ! Empty( cStyle ) .and. ! Empty( IfNil( cBmpFile, cBmpRes, nBmpHandle ) ) .and. Empty( cResizeMode )
      cResizeMode    := cStyle
      cStyle         := nil
   endif

   ::uSource   = If( nRGBColor == nil, ;
                 IfNil( cStyle, cBmpFile, cBmpRes, nBmpHandle ), ;
                 cClrToCode( nRGBColor ) )


   if ! Empty( cResizeMode ) .and. ::nRGBColor == nil .and. ::uSource != nil
      if ValType( ::uSource ) == 'A'
         ::nResizeMode  := If( Left( cResizeMode, 3 ) == "HOR", 2, 1 )
      else
         ::nResizeMode  := FW_DeCode( cResizeMode, "STRETCH", 1, "RESIZE", 2, 0 )
      endif
   endif

   if ::nResizeMode == 0 .and. ;
      ( nAt := AScan( ::aBrushes, {|oBrush| Self == oBrush } ) ) > 0

      if ! Empty( ::aBrushes[ nAt ]:hBitmap ) .and. ( Empty( ::aBrushes[ nAt ]:cBmpFile ) .and. ;
                                                      Empty( ::aBrushes[ nAt ]:cBmpRes ) )
         ::aBrushes[ nAt ]:End()

      else

         Self := ::aBrushes[ nAt ] // This is not permited with XBase++
         ::nCount++
         return Self
      endif

   endif

   do case
/*
      case ::aGrad != nil
         ::hBmpOrgl  := ::hBitmap := GradientBmp( nil, nil, nil, ::aGrad, ::nResizeMode == 1 )
         ::hBrush    := CreatePatternBrush( ::hBitmap )
*/
      case cStyle == nil .and. nRGBColor != nil
           if nRGBColor == CLR_WHITE
              ::hBrush  = GetStockObject( WHITE_BRUSH )
              ::lSystem = .t.

           elseif nRGBColor == CLR_BLACK
              ::hBrush  = GetStockObject( BLACK_BRUSH )
              ::lSystem = .t.

            elseif nRGBColor == CLR_LIGHTGRAY
              ::hBrush  = GetStockObject( LTGRAY_BRUSH )
              ::lSystem = .t.

            elseif nRGBColor == CLR_GRAY
              ::hBrush  = GetStockObject( GRAY_BRUSH )
              ::lSystem = .t.

            elseif nRGBColor == RGB( 64, 64, 64 )
              ::hBrush  = GetStockObject( DKGRAY_BRUSH )
              ::lSystem = .t.

           else
              ::hBrush := CreateSolidBrush( nRGBColor )
           endif

      case cStyle != nil
           do case
              case cStyle == "NULL"
                   ::hBrush = GetStockObject( NULL_BRUSH )
                   ::lSystem = .t.

              case ( nAt := AScan( aNewTypes, cStyle ) ) != 0
                   ::hBitmap = FWBrushes( nAt )

                   ::hBrush = If( ::hBitmap != 0,;
                                  CreatePatternBrush( ::hBitmap ), )

              case ( nAt := AScan( aStdTypes, cStyle ) ) != 0
                   ::hBrush = CreateHatchBrush( nAt - 1, nRGBColor )

              otherwise
                 if File( cBmpFile )
                    ::hBitMap = ReadBitmap( 0, cBmpFile )
                    ::hBrush = If( ::hBitmap != 0,;
                                   CreatePatternBrush( ::hBitmap ), )
                 endif
           endcase

      case ValType( nBmpHandle ) == 'N'
           ::hBitmap = nBmpHandle
           ::hBrush  = CreatePatternBrush( ::hBitmap )

      case cBmpFile != nil
           if File( cBmpFile )
               if Lower( cFileExt( cBmpFile ) ) == 'bmp'
                  ::hBitMap = ReadBitmap( 0, cBmpFile )
               else
                  ::hBitmap = FILoadImg( cBmpFile, @nFormat )
                  ::nBmpFormat = nFormat
               endif
               ::hBrush = If( ::hBitmap != 0, CreatePatternBrush( ::hBitmap ), )
           endif

      case cBmpRes != nil
           ::hBitmap = LoadBitmap( GetResources(), cBmpRes )
           ::hBrush  = If( ::hBitmap != 0, CreatePatternBrush( ::hBitmap ),)

   endcase

   ::nCount    := 1
   DEFAULT ::hBmpOrgl  := ::hBitmap

   AAdd( ::aBrushes, Self )

return Self

//----------------------------------------------------------------------------//

METHOD cGenPRG( cVar ) CLASS TBrush

   local cPrg := ""

   DEFAULT cVar   := 'oBrush'

   cPrg     := '   DEFINE BRUSH ' + cVar

   if ! Empty( ::cStyle )
      cPrg  += " STYLE '" + ::cStyle + "'"
   endif

   if ! Empty( ::nRGBColor )
      cPrg  += " COLOR " + cClrToCode( ::nRGBColor )
   endif

   if ! Empty( ::cBmpFile )
      cPrg  += " FILE '" + ::cBmpFile + "'"
   elseif ! Empty( ::cBmpRes )
      cPrg  += " RESOURCE '" + ::cBmpRes + "'"
   endif

return cPrg

//----------------------------------------------------------------------------//

METHOD End() CLASS TBrush

   local nAt

   // Now different objects may use the same brush!!!
   if ::nCount == nil
      ::nCount := 1
   endif

   if --::nCount < 1
      nAt := AScan( ::aBrushes, { | oBrush | oBrush:hBrush = ::hBrush } )
      if nAt > 0
         ADel( ::aBrushes, nAt )
         ASize( ::aBrushes, Len( ::aBrushes ) - 1 )
      endif
   else
      return nil
   endif

   if ::hBrush != nil .and. ::hBrush != 0
      if ! ::lSystem
         if ! DeleteObject( ::hBrush )
            LogFile( "resources.txt",;
                     { "DeleteObject( ::hBrush ) failed from TBrush:End()", ::hBrush } )
         endif
      endif
   endif

   if ! Empty( ::hBmpOrgl ) .and. ::hBmpOrgl != ::hBitmap
      DeleteObject( ::hBmpOrgl )
   endif

   if ::hBitmap != nil .and. ::hBitmap != 0
      DeleteObject( ::hBitmap )
   endif

   ::hBrush  = 0
   ::hBitmap = 0

return nil

//----------------------------------------------------------------------------//

METHOD Load( cInfo ) CLASS TBrush

   local nPos := 1, nProps, n, nLen
   local cData, cType, cBuffer

   nProps = Bin2I( SubStr( cInfo, nPos, 2 ) )
   nPos += 2

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

      do case
         case cType == "A"
              OSend( Self, "_" + cData, ARead( cBuffer ) )

         case cType == "O"
              OSend( Self, "_" + cData, ORead( cBuffer ) )

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

         case cType == "L"
              OSend( Self, "_" + cData, cBuffer == ".T." )

         case cType == "N"
              OSend( Self, "_" + cData, Val( cBuffer ) )
      endcase
   next

return nil

//----------------------------------------------------------------------------//

METHOD Resized( x, y, nMode ) CLASS TBrush

   local hBmp     := ResizeBitmap( ::hBitmap, x, y, nMode )

return TBrush():New( ,,,, hBmp )

//------------------------------------------------------------------//

METHOD Cropped( oWnd, oChildRect ) CLASS TBrush

   local hBmp, hDC
   local oBrush, hCrop, oRect

   oBrush      := oWnd:oBrush
   if oBrush:nResizeMode > 0 .and. oBrush:aGrad == nil
      oRect       := DataRect( oWnd )
      if oBrush:aGrad == nil
         hBmp     := ResizeBitmap( oBrush:hBmpOrgl, oRect:nWidth, oRect:nHeight, oBrush:nResizeMode )
      else
         hDC      := oWnd:GetDC()
         hBmp     := GradientBmp( hDC, oRect:nWidth, oRect:nHeight, ;
                                  oBrush:aGrad, oBrush:nResizeMode == 1 )
         oWnd:ReleaseDC()
      endif
      hCrop       := CropBmp( hBmp, oChildRect )
      DeleteObject( hBmp )
   else
      return oBrush:Copy()
   endif

return TBrush():New( nil, nil, nil, nil, hCrop )

//------------------------------------------------------------------//

METHOD Save() CLASS TBrush

   local n
   local cType, cInfo := "", cMethod
   local oBrush := &( ::ClassName() + "()" )
   local uData, nProps := 0

   oBrush = oBrush:New()

   for n = 1 to Len( ::aProperties )
       if ! ( uData := OSend( Self, ::aProperties[ n ] ) ) == ;
          OSend( oBrush, ::aProperties[ n ] )
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

   oBrush:End()

return "O" + I2Bin( 2 + Len( ::ClassName() ) + 2 + Len( cInfo ) ) + ;
       I2Bin( Len( ::ClassName() ) ) + ;
       ::ClassName() + I2Bin( nProps ) + cInfo

//----------------------------------------------------------------------------//

METHOD SaveToText( nIndent ) CLASS TBrush

   local n, m, cType, cInfo
   local cMethod, uData, nProps := 0
   local oBrush := &( ::ClassName() + "()" )
   local cParams1, cParams2

   DEFAULT nIndent := 0

   cInfo := Space( nIndent ) + "OBJECT " + If( nIndent > 0, "::", "" ) + ;
            "oBrush AS " + ;
            If( nIndent > 0, Upper( Left( ::ClassName(), 2 ) ) + ;
            Lower( SubStr( ::ClassName(), 3 ) ), If( ::IsDerivedFrom( "TFORM" ), ::cClassName, ::ClassName() ) ) + ;
            CRLF + CRLF

   oBrush = oBrush:New()

   for n = 1 to Len( ::aProperties )
       if ! ( uData := OSend( Self, ::aProperties[ n ] ) ) == ;
          OSend( oBrush, ::aProperties[ n ] )
          nProps++
          cType = ValType( uData )
          do case
             case cType == "C"
                  cInfo += Space( nIndent ) + "   ::" + ::aProperties[ n ] + " = "
                  cInfo += '"' + uData + '"' + CRLF

             case cType == "A"
                  cInfo += Space( nIndent + 3 ) + "::" + ::aProperties[ n ] + ;
                           " = Array( " + AllTrim( Str( Len( uData ) ) ) + " )" + CRLF + CRLF
                  cInfo += AToText( uData, ::aProperties[ n ], nIndent + 3 )

             case cType == "O"
                  cInfo += CRLF + uData:SaveToText( nIndent + 3 )

             otherwise
                  cInfo += Space( nIndent ) + "   ::" + ::aProperties[ n ] + " = "
                  cInfo += cValToChar( uData ) + CRLF
          endcase
       endif
   next

   cInfo += CRLF + Space( nIndent ) + "ENDOBJECT" + If( nIndent > 0, CRLF, "" )

   oBrush:End()

return cInfo

//----------------------------------------------------------------------------//

METHOD Copy() CLASS TBrush

   local oBrush

   if Empty( ::nResizeMode )
      oBrush   := Self
   else
      oBrush   := TBrush():New()
      WITH OBJECT oBrush
         :cBmpFile      := ::cBmpFile
         :cBmpRes       := ::cBmpRes
         :hBitmap       := ;
         :hBmpOrgl      := ResizeBitmap( ::hBmpOrgl )
         :nBmpFormat    := ::nBmpFormat
         :lSystem       := ::lSystem
         :aGrad         := ::aGrad     // not AClone()
         :uSource       := ::uSource
         :nResizeMode   := ::nResizeMode
      END
      // When tested this copied brush will be == Self
   endif

return oBrush

//----------------------------------------------------------------------------//

METHOD SameAs( oBrush ) CLASS TBrush

   return ;
   ValType( oBrush ) == 'O'                           .and. ;
   oBrush:IsKindOf( 'TBRUSH' )                        .and. ;
   ! Empty( oBrush:uSource )                          .and. ;
   ValType( oBrush:uSource )  == ValType( ::uSource ) .and. ;
   oBrush:uSource             == ::uSource            .and. ;
   oBrush:nResizeMode         == ::nResizeMode

//----------------------------------------------------------------------------//

METHOD Resize( oWnd, nOrgX, nOrgY ) CLASS TBrush

   local hDC, oRect

   DEFAULT nOrgX := 0, nOrgY := 0

   oRect    := DataRect( oWnd )
   if ::nResizeMode == 0
      ::oRect  := oRect
      if ! Empty( ::hBmpOrgl )
         if ! Empty( ::hBitmap ) .and. ::hBitmap != ::hBmpOrgl
            DeleteObject( ::hBitmap )
            DeleteObject( ::hBrush )
            ::hBitmap := ::hBrush := nil
         endif
         DEFAULT ::hBitmap := ::hBmpOrgl, ;
                 ::hBrush  := CreatePatternBrush( ::hBitmap )

      endif
   else
      if ::oRect == nil .or. !( ::oRect == oRect ) .or. ::hBrush == nil
         if ::hBrush != nil
            DeleteObject( ::hBrush )
            ::hBrush      := nil
         endif
         if ::hBitmap != ::hBmpOrgl
            DeleteObject( ::hBitmap )
         endif
         if Empty( ::aGrad )
            if ! Empty( ::hBmpOrgl )
               ::hBitmap   := ResizeBitmap( ::hBmpOrgl, oRect:nWidth, oRect:nHeight, ::nResizeMode )
            endif
         else
            hDC         := oWnd:GetDC()
            ::hBitmap   := GradientBmp( hDC, oRect:nWidth, oRect:nHeight, ::aGrad, ::nResizeMode == 1 )
            DEFAULT ::hBmpOrgl := ::hBitmap
            oWnd:ReleaseDC()
         endif
         ::oRect     := oRect
         DEFAULT ::hBrush  := CreatePatternBrush( ::hBitmap )
      endif
   endif

   nOrgX    += ::oRect:nLeft
   nOrgY    += ::oRect:nTop

return oRect

//----------------------------------------------------------------------------//

function ResizeBitmap( hBmp, nWndW, nWndH, nMode )

   local hBmpNew
   local nWidth, nHeight
   local nBmpW       := nBmpWidth(  hBmp )
   local nBmpH       := nBmpHeight( hBmp )

   if Empty( nWndW ) .and. Empty( nWndH )
      nMode          := 0
   else
      DEFAULT nMode  := 1      // 0 = no resize, 1 = Stretch, 2 := FitOutside, 3 := Fitinside
      DEFAULT nWndW  := nWndH * nBmpW / nBmpH
      DEFAULT nWndH  := nWndW * nBmpH / nBmpW
   endif

   if nMode == 0
      nWidth := nBmpW; nHeight := nBmpH
   elseif nMode == 1
      nWidth := nWndW; nHeight := nWndH
   elseif ( nMode == 3 .and. ( nWndW / nBmpW ) < ( nWndH / nBmpH ) ) .or. ;
          ( nMode == 2 .and. ( nWndW / nBmpW ) > ( nWndH / nBmpH ) )
      nWidth := nWndW; nHeight := nBmpH * ( nWndW / nBmpW )
   else
      nHeight := nWndH; nWidth := nBmpW * ( nWndH / nBmpH )
   endif

   hBmpNew     := ResizeImg( hBmp, nWidth, nHeight )

return hBmpNew

//------------------------------------------------------------------//

static function GradientBmp( hDC, nWidth, nHeight, aColors, lVert )

   local hDC2, hBmp, hBmpOld
   local lDC := .f.

   DEFAULT lVert := .t., nWidth := 319, nHeight := 153

   if hDC == nil
      hDC   := GetDC( 0 )
      lDC   :=.t.
   endif
   hDC2     := CreateCompatibleDC( hDC )
   hBmp     := CreateCompatibleBitMap( hDC, nWidth, nHeight )
   hBmpOld  := SelectObject( hDC2, hBmp )
   GradientFill( hDC2, 0, 0, nHeight, nWidth, aColors,lVert )

   SelectObject( hDC2, hBmpOld )
   DeleteDC( hDC2 )
   if lDC
      ReleaseDC( 0, hDC )
   endif

return hBmp

//----------------------------------------------------------------------------//

static function CropBmp( hBmp, oRect )
return CropImage( hBmp, oRect:nTop, oRect:nLeft, oRect:nBottom, oRect:nRight )

//----------------------------------------------------------------------------//

function GradientBrush( hDC, nTop, nLeft, nWidth, nHeight, aColors, lVert )

   local hDC2, hBmp, hBmpOld , hBrush

   DEFAULT lVert := .t.

   if lVert
      nWidth   := 1
   else
      nHeight  := 1
   endif

   hDC2     := CreateCompatibleDC( hDC )
   hBmp     := CreateCompatibleBitMap( hDC, nWidth, nHeight )
   hBmpOld  := SelectObject( hDC2, hBmp )
   GradientFill( hDC2, 0, 0, nHeight, nWidth, aColors,lVert )

   hBrush = CreatePatternBrush( hBmp )
   SelectObject( hDC2, hBmpOld )
   DeleteObject( hBmp )
   DeleteDC( hDC2 )

return hBrush

//----------------------------------------------------------------------------//

static function DataRect( oWnd )

   local oRect

   if __ObjHasMethod( oWnd, "DATARECT" )
      oRect    := oWnd:DataRect()
      if ValType( oRect ) == 'A'
         oRect := TRect():New( oRect )
      endif
   else
      oRect    := oWnd:GetCliRect()
/*
      if oWnd:oTop != nil
         oRect:nTop     += oWnd:oTop:nHeight - 1
      endif
      if oWnd:oBottom != nil
         oRect:nBottom  -= oWnd:oBottom:nHeight
      elseif oWnd:oMsgBar != nil
         oRect:nBottom  -= oWnd:oMsgBar:nHeight
      endif
      if oWnd:oLeft != nil
         oRect:nLeft    += oWnd:oLeft:nWidth
      endif
      if oWnd:oRight != nil
         oRect:nRight   -= oWnd:oRight:nWidth
      endif
*/
   endif

return oRect

//----------------------------------------------------------------------------//

static function ContainerWnd( oWnd, nTop, nLeft )

   local oRet     := oWnd

   DEFAULT nTop := 0, nLeft := 0

   do while lAnd( oRet:nStyle, WS_CHILD ) .and. ;
            ( oRet:IsKindOf( "TCONTROL" ) .or.  ;
            oRet:IsKindOf( "TDIALOG" )  ) .and. ;
            oWnd:oBrush == oRet:oBrush    .and. ;
            oRet:oWnd:lTransparent == .t.

      nTop     += oRet:nTop
      nLeft    += oRet:nLeft
      oRet     := oRet:oWnd
   enddo

return oRet

//----------------------------------------------------------------------------//

#pragma BEGINDUMP

#include "windows.h"
#include "hbapi.h"

HB_FUNC( CROPIMAGE ) //hOriginalBmp, nTop, nLeft, nBottom, nRight --> hCroppedBmp
{
   HDC hdc1, hdcSrc, hdcDest;
   HBITMAP hbmpSrc  = ( HBITMAP ) hb_parnl( 1 );
   HBITMAP hbmpDest, hold1, hold2;
   RECT rct;
   BITMAP bm;

   GetObject( ( HGDIOBJ ) hbmpSrc, sizeof( BITMAP ), ( LPSTR ) &bm );

   rct.top    = hb_pcount() > 1 ? hb_parnl( 2 ) : 0;
   rct.left   = hb_pcount() > 2 ? hb_parnl( 3 ) : 0;
   rct.bottom = hb_pcount() > 3 ? hb_parnl( 4 ) : bm.bmHeight;
   rct.right  = hb_pcount() > 4 ? hb_parnl( 5 ) : bm.bmWidth;


   hdc1 = GetDC( GetDesktopWindow() );
   hdcSrc = CreateCompatibleDC( hdc1 );
   hdcDest = CreateCompatibleDC( hdc1 );

   hbmpDest = CreateCompatibleBitmap( hdc1, rct.right - rct.left, rct.bottom - rct.top );

   ReleaseDC( GetDesktopWindow(), hdc1 );

   hold1 = ( HBITMAP ) SelectObject( hdcSrc, hbmpSrc );
   hold2 = ( HBITMAP ) SelectObject( hdcDest, hbmpDest );

   BitBlt( hdcDest, 0, 0, rct.right, rct.bottom, hdcSrc, rct.left, rct.top, SRCCOPY );

   SelectObject( hdcSrc, hold1 );
   SelectObject( hdcDest, hold2 );

   DeleteDC( hdcSrc );
   DeleteDC( hdcDest );

   hb_retnl( ( LONG ) hbmpDest );

}

#pragma ENDDUMP
