#include <WinTen.h>
#include <Windows.h>
#include <ShellApi.h>
#include <ClipApi.h>

#define ALENGTH(n)   (_parinfa(n, 0))

//----------------------------------------------------------------------------//

CLIPPER DRAWSELECT( PARAMS ) //OR  hDC, nRow, nCol, nRadius, nRowPos, nColPos,
			     //    aMarks, nClrBtn, nClrMarks
{

   int   i;

   HDC   hDC          = ( HDC ) _parnl( 1 );

   int   wRow         = _parni( 2 );
   int   wCol         = _parni( 3 );

   int   wRadius      = _parni( 4 );

   WORD  wTop         = wRow - wRadius;
   WORD  wLeft        = wCol - wRadius;
   WORD  wBottom      = wRow + wRadius;
   WORD  wRight       = wCol + wRadius;

   int   wRowPos      = _parni( 5 );
   int   wColPos      = _parni( 6 );

   int   wPointer     = wRadius / 8;

   int   wMarks       = ALENGTH( 7 );

   int   wRowMark;
   int   wColMark;

   int   wRowRatio;
   int   wColRatio;

   HPEN hPUpLeft = CreatePen( PS_SOLID, 1, GetSysColor( COLOR_BTNSHADOW ) );
   HPEN hPBotRit = CreatePen( PS_SOLID, 1, GetSysColor( COLOR_BTNHIGHLIGHT ) );
   HPEN hPBlack  = CreatePen( PS_SOLID, 1, RGB( 0, 0, 0 ) );

   COLORREF nClrBtn   = _parnl( 8 );
   COLORREF nClrMarks = _parnl( 9 );

   HPEN   hPBtn   = CreatePen( PS_SOLID, 1, nClrBtn );
   HPEN   hPMarks = CreatePen( PS_SOLID, 1, nClrMarks );

   HBRUSH hBBlack = CreateSolidBrush( RGB( 0, 0, 0 ) );
   HBRUSH hBBtn   = CreateSolidBrush( nClrBtn );

   HPEN   hOldPen;
   HBRUSH hOldBrush;

   hOldPen   = SelectObject( hDC, hPBtn );
   hOldBrush = SelectObject( hDC, hBBtn );
   Ellipse( hDC, wLeft + 2, wTop + 2, wRight - 2, wBottom - 2 );

   SelectObject( hDC, hPBlack );
   SelectObject( hDC, hBBlack );
   wRowPos += ( wPointer * 2 + 2 ) * ( wRow - wRowPos ) / wRadius;
   wColPos += ( wPointer * 2 + 2 ) * ( wCol - wColPos ) / wRadius;
   Ellipse( hDC, wColPos - wPointer, wRowPos - wPointer, wColPos + wPointer, wRowPos + wPointer );

   SelectObject( hDC, hPBlack );
   Arc( hDC, wLeft, wTop, wRight, wBottom, wLeft, wBottom, wRight, wTop );

   SelectObject( hDC, hPBotRit );
   Arc( hDC, wLeft, wTop, wRight, wBottom, wRight, wTop, wLeft, wBottom );
   // SelectObject( hDC, hPBtn );
   Arc( hDC, wLeft + 1, wTop + 1, wRight - 1, wBottom - 1, wRight, wTop, wLeft, wBottom );

   SelectObject( hDC, hPUpLeft );
   Arc( hDC, wLeft + 1, wTop + 1, wRight - 1, wBottom - 1, wLeft, wBottom, wRight, wTop );
 
   SelectObject( hDC, hPMarks );

   if ( wMarks > 0 )
      {
	wRowMark = _parni( 7, 1 );
	wColMark = _parni( 7, 2 );

        wRowRatio = 6 * ( wRow - wRowMark ) / wRadius;
        wColRatio = 6 * ( wCol - wColMark ) / wRadius;

        MoveTo( hDC, wColMark, wRowMark );
        LineTo( hDC, wColMark - wColRatio, wRowMark - wRowRatio );

      }

   for ( i = 3; i < wMarks - 1 ; i += 2 )
     {
        wRowMark = _parni( 7, i );
        wColMark = _parni( 7, i + 1 );

        wRowRatio = 4 * ( wRow - wRowMark ) / wRadius;
        wColRatio = 4 * ( wCol - wColMark ) / wRadius;

        MoveTo( hDC, wColMark, wRowMark );
        LineTo( hDC, wColMark - wColRatio, wRowMark - wRowRatio );

     }

   if ( wMarks > 2 )
      {
        wRowMark = _parni( 7, wMarks - 1 );
	wColMark = _parni( 7, wMarks );

        wRowRatio = 6 * ( wRow - wRowMark ) / wRadius;
        wColRatio = 6 * ( wCol - wColMark ) / wRadius;

        MoveTo( hDC, wColMark, wRowMark );
        LineTo( hDC, wColMark - wColRatio, wRowMark - wRowRatio );

      }

   SelectObject( hDC, hOldPen );
   SelectObject( hDC, hOldBrush );

   DeleteObject( hBBtn );
   DeleteObject( hPBtn );

   DeleteObject( hPMarks );

   DeleteObject( hBBlack );
   DeleteObject( hPBlack );
     
   DeleteObject( hPUpLeft );
   DeleteObject( hPBotRit );

   _ret();
      
}

//----------------------------------------------------------------------------//
