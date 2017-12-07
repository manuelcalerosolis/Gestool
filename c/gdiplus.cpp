
//----------------------------------------------------------------------------//
// GdiPlus support (c) FiveTech Software
// Author: Manuel Alvarez
//----------------------------------------------------------------------------//

//#pragma warning( disable : 4068 )

#include <hbapi.h>
#include <hbapiitm.h>
#include <windows.h>
#include <math.h>
//#include <shlwapi.h>
#include <fwh.h>
#include <gdiplus.h>

#ifndef __GNUC__
   #include <gdiplusimaging.h>
#else
   #include <gdiplus/gdiplusimaging.h>
#endif

#ifndef max
   #define max(a,b) ((a)>(b)?(a):(b))
#endif

#ifndef min
   #define min(a,b) ((a)<(b)?(a):(b))
#endif

#define PI 3.14159265359

using namespace Gdiplus;

GdiplusStartupInput gdiplusStartupInput;
ULONG_PTR   gdiplusToken;

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSNEWGRAPHICS )
{
   hb_retptr( new Graphics( ( HDC ) fw_parH( 1 ) ) );
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSNEWGRAPHICSWND )
{
   hb_retptr( new Graphics( ( HWND ) fw_parH( 1 ), hb_parl( 2 ) ) );
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSNEWGRAPHICSIMG )
{
   hb_retptr( new Graphics( ( Bitmap * ) hb_parptr( 1 ) ) );
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSGRAPHICSFROMIMG )
{
   Graphics * graphics = ( Graphics * ) hb_parptr( 2 );
   hb_retptr( graphics->FromImage( ( Bitmap * ) hb_parptr( 1 ) ) );
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSDELETEGRAPHICS )
{
   delete ( ( Graphics * ) hb_parptr( 1 ) );
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSHIGHQUALITY )
{
   Graphics * graphics = ( Graphics * ) hb_parptr( 1 );
   graphics->SetSmoothingMode( SmoothingModeHighQuality );
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSNORMALQUALITY )
{
   Graphics * graphics = ( Graphics * ) hb_parptr( 1 );
   graphics->SetSmoothingMode( SmoothingModeDefault );
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSCLEARCOLOR )
{
   Graphics * graphics = ( Graphics * ) hb_parptr( 1 );
   Color clr = Color( hb_parni( 2 ), hb_parni( 3 ), hb_parnl( 4 ), hb_parni( 5 ) );
   graphics->Clear( clr );
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSNEWPEN )
{
   Color clr = Color( hb_parnl( 1 ), hb_parnl( 2 ), hb_parnl( 3 ), hb_parnl( 4 ) );

   hb_retptr( new Pen( clr ) );
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSPENSIZE )
{
   Pen * pen   = ( Pen * ) hb_parptr( 1 );
   //float nSize = ( float ) hb_parnl( 2 );
   float nSize = ( float ) hb_parni( 2 );
   pen->SetWidth( nSize );
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSPENSETCLR )
{
   Pen * pen = ( Pen * ) hb_parptr( 1 );

   Color clr = Color( hb_parnl( 2 ), hb_parnl( 3 ), hb_parnl( 4 ), hb_parnl( 5 ) );
   hb_retni( pen->SetColor( clr ) );
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSPENSTYLE )
{
   Pen * pen = ( Pen * ) hb_parptr( 1 );

   pen->SetLineCap( ( LineCap ) hb_parnl( 2 ), ( LineCap ) hb_parnl( 2 ),
                    ( DashCap ) hb_parnl( 2 ) );
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSALIGN )
{
   Pen * pen = ( Pen * ) hb_parptr( 1 );

   pen->SetAlignment( PenAlignmentInset );
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSNOALIGN )
{
   Pen * pen = ( Pen * ) hb_parptr( 1 );

   pen->SetAlignment( PenAlignmentCenter );
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSDELETEPEN )
{
   delete ( ( Pen * ) hb_parptr( 1 ) );
}

//----------------------------------------------------------------------------//

//LineJoinMiter= 0,  LineJoinBevel= 1, LineJoinRound= 2, LineJoinMiterClipped= 3
HB_FUNC( GDIPLUSPENSETLINEJOIN )
{
   Pen * pen = ( Pen * ) hb_parptr( 1 );
   LineJoin nLJoin = ( LineJoin ) hb_parni( 2 );
   pen->SetLineJoin( nLJoin );
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSNEWSOLIDBRUSH )
{
   Color clr = Color( hb_parnl( 1 ), hb_parnl( 2 ), hb_parnl( 3 ), hb_parnl( 4 ) );

   hb_retptr( new SolidBrush( clr ) );
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSDELETEBRUSH )
{
   delete ( ( Brush * ) hb_parptr( 1 ) );
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSCREATEPATHGRADIENTBRUSH )
{
   GraphicsPath * graphicPath = ( GraphicsPath * ) hb_parptr( 1 );
   PathGradientBrush * pthGrBrush =  new PathGradientBrush( graphicPath );
   hb_retptr( pthGrBrush );
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSDRAWLINE )
{
   Graphics * graphics = ( Graphics * ) hb_parptr( 1 );

   if HB_ISPOINTER( 2 )   // if pen-object
   {
      Pen * pen = ( Pen * ) hb_parptr( 2 );
      graphics->DrawLine( pen, ( float ) hb_parnd( 3 ),
                ( float ) hb_parnd( 4 ), ( float ) hb_parnd( 5 ),
                ( float ) hb_parnd( 6 ) );
   }
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSDRAWRECT )
{
   Graphics * graphics = ( Graphics * ) hb_parptr( 1 );
   float nLeft   = hb_parnd( 4 );
   float nTop    = hb_parnd( 5 );
   float nWidth  = hb_parnd( 6 );
   float nHeight = hb_parnd( 7 );

    if HB_ISPOINTER( 3 )    // if brush-object
    {
       Brush * brush = ( Brush * ) hb_parptr( 3 );
       graphics->FillRectangle( brush, nLeft, nTop, nWidth, nHeight );
    }

    if HB_ISPOINTER( 2 )    //if pen-object
    {
       Pen * pen = ( Pen * ) hb_parptr( 2 );

       graphics->DrawRectangle( pen, nLeft, nTop, nWidth, nHeight );
    }
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSDRAWELLIPSE )
{
   Graphics * graphics = ( Graphics * ) hb_parptr( 1 );
   float nLeft   = hb_parnd( 4 );
   float nTop    = hb_parnd( 5 );
   float nWidth  = hb_parnd( 6 );
   float nHeight = hb_parnd( 7 );

   if HB_ISPOINTER( 3 )   //if brush-object
   {
      Brush * brush = ( Brush * ) hb_parptr( 3 );
      graphics->FillEllipse( brush, nLeft, nTop, nWidth, nHeight );
   }

   if HB_ISPOINTER( 2 )   //if pen-object
   {
     Pen * pen = ( Pen * ) hb_parptr( 2 );
     graphics->DrawEllipse( pen, nLeft, nTop, nWidth, nHeight );
   }
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSDRAWTEXT )
{
   Graphics * graphics = ( Graphics * ) hb_parptr( 1 );

   LPWSTR string = AnsiToWide( ( char * ) hb_parc( 2 ) );

   float nTop  = ( float ) hb_parnd( 3 );
   float nLeft = ( float ) hb_parnd( 4 );

   LPWSTR NameFont = AnsiToWide( ( char * ) hb_parc( 5 ) );

   FontFamily * fml = new FontFamily( NameFont );

   Font font( fml, hb_parnd( 6 ) );

   delete fml;

   Brush * brush = ( Brush * ) hb_parptr( 7 );

   graphics->DrawString( string, -1, &font, PointF( nLeft, nTop ), brush );

}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSDRAWTEXTFONT )
{
   Graphics * graphics = ( Graphics * ) hb_parptr( 1 );

   LPWSTR string = AnsiToWide( ( char * ) hb_parc( 2 ) );

   float nTop  = ( float ) hb_parnd( 3 );
   float nLeft = ( float ) hb_parnd( 4 );
   HFONT hFont = ( HFONT ) fw_parH( 5 );

   #ifndef _WIN64
      Font font( ( HDC ) hb_parnl( 8 ), hFont );
   #else
      Font font( ( HDC ) hb_parnll( 8 ), hFont );
   #endif
   Brush * brush = ( Brush * ) hb_parptr( 7 );

   graphics->DrawString( string, -1, &font, PointF( nLeft, nTop ), brush );

}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSDRAWTEXTLF )
{
   Graphics * graphics = ( Graphics * ) hb_parptr( 1 );
   LPWSTR string = AnsiToWide( ( char * ) hb_parc( 2 ) );

   float nTop    = hb_parnd( 3 );
   float nLeft   = hb_parnd( 4 );
   HDC hdc       = ( HDC ) fw_parH( 5 );
   HFONT hFont   = ( HFONT ) fw_parH( 6 );
   Brush * brush = ( Brush * ) hb_parptr( 7 );

   LOGFONT lf;
   GetObject( ( HFONT ) hFont, sizeof( LOGFONT ), &lf );

   if( hb_parni( 8 ) > 0 )
      lf.lfHeight   = hb_parni( 8 );

   if( hb_parl( 9 ) ) //-> bold
      lf.lfWeight   =  700;
   else
      lf.lfWeight   =  400;

   if( hb_parl( 10 ) )  //lf.lfItalic
      lf.lfItalic = TRUE;
   else
      lf.lfItalic = FALSE;

   if( hb_parl( 11 ) ) //lf.lfUnderline
      lf.lfUnderline = TRUE;
   else
      lf.lfUnderline = FALSE;

   if( hb_parl( 12 ) ) //lf.lfStrikeOut
      lf.lfStrikeOut = TRUE;
   else
      lf.lfStrikeOut = FALSE;

   if( hb_parni( 13 ) > 0 ) //lf.lfOrientation
     lf.lfOrientation = hb_parni( 13 );

   if( hb_parni( 14 ) > 0 ) //lf.lfEscapement
     lf.lfEscapement  = hb_parni( 14 );

   Font font( ( HDC ) hdc, &lf );

   graphics->DrawString(string, -1, &font, PointF( nLeft, nTop ), brush );

}
//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSFONTCREATEFROMHDC )
{
   #ifndef _WIN64
      hb_retnl( ( HB_LONG ) new Font( ( HDC ) fw_parH( 1 ) ) );
   #else
      hb_retnll( ( LONGLONG ) new Font( ( HDC ) fw_parH( 1 ) ) );
   #endif
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSCREATEPATH )
{
   hb_retptr( new GraphicsPath() );
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSPATHSTARTFIGURE )
{
    GraphicsPath * graphicPath = ( GraphicsPath * ) hb_parptr( 1 );
    graphicPath->StartFigure();
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSDELETEPATH )
{
   delete ( ( GraphicsPath * ) hb_parptr( 1 ) );
}

//----------------------------------------------------------------------------//

static Bitmap * BitmapFromAlphaBmp( Bitmap * original )  // trabajo para no perder el alpha ....
{

    int nWidth  = original->GetWidth()  ;
    int nHeight = original->GetHeight() ;

    Rect rect(0, 0, nWidth, nHeight);

    BitmapData bmpData;

    original->LockBits(&rect, ImageLockModeRead, original->GetPixelFormat(), &bmpData );

    byte* imgPtr = (byte*)(bmpData.Scan0) ;

    int bheight = bmpData.Height;
    int bwidth  = bmpData.Width;
    int bstride = bmpData.Stride;

    Bitmap * newImage = new Bitmap( bwidth, bheight, bstride, PixelFormat32bppARGB, imgPtr );

    nWidth  = newImage->GetWidth()  ;
    nHeight = newImage->GetHeight() ;

    Bitmap* result  = new Bitmap( nWidth, nHeight, newImage->GetPixelFormat() );
    Graphics * graphics = new Graphics( result );
    graphics->DrawImage( newImage ,0, 0, nWidth, nHeight);

    original->UnlockBits( &bmpData ) ;

    delete original ;
    delete newImage ;
    delete graphics ;

  return result ;

}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSPATHADDLINE )
{
   GraphicsPath * graphicPath = ( GraphicsPath * ) hb_parptr( 1 );

   int nLeft   = hb_parni( 2 );
   int nTop    = hb_parni( 3 );
   int nRight  = hb_parni( 4 );
   int nBottom = hb_parni( 5 );

   graphicPath->AddLine(  nLeft, nTop, nRight, nBottom ) ;
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSPATHADDRECTANGLE )
{
   GraphicsPath * graphicPath = ( GraphicsPath * ) hb_parptr( 1 );
   int nLeft   = hb_parni( 2 );
   int nTop    = hb_parni( 3 );
   int nRight  = hb_parni( 4 );
   int nBottom = hb_parni( 5 );

   Rect pathRect = Rect( nLeft, nTop, nRight, nBottom );
   graphicPath->AddRectangle( pathRect ) ;
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSPATHADDARC )
{
   GraphicsPath * graphicPath = ( GraphicsPath * ) hb_parptr( 1 );
   int nLeft   = hb_parni( 2 );
   int nTop    = hb_parni( 3 );
   int nRight  = hb_parni( 4 );
   int nBottom = hb_parni( 5 );
   float startAngle =  ( float ) hb_parnd( 6 );
   float sweepAngle =  ( float ) hb_parnd( 7 );

   Rect pathRect = Rect( nLeft, nTop, nRight, nBottom );
   graphicPath->AddArc( pathRect, startAngle, sweepAngle ) ;
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSPATHADDELLIPSE )
{
   #ifndef _WIN64
      GraphicsPath * graphicPath = ( GraphicsPath * ) hb_parnl( 1 );
   #else
      GraphicsPath * graphicPath = ( GraphicsPath * ) hb_parnll( 1 );
   #endif

   int nLeft   = hb_parni( 2 );
   int nTop    = hb_parni( 3 );
   int nWidth  = hb_parni( 4 );
   int nHeight = hb_parni( 5 );

   graphicPath->AddEllipse( nLeft, nTop, nWidth, nHeight );

}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSPATHCLOSEFIGURE )
{
   GraphicsPath * graphicPath = ( GraphicsPath * ) hb_parptr( 1 );
   graphicPath->CloseFigure();
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSDRAWPATH )
{
   Graphics * graphics = ( Graphics * ) hb_parptr( 1 );
   Pen * pen = ( Pen * ) hb_parptr( 2 );
   GraphicsPath * graphicPath = ( GraphicsPath * ) hb_parptr( 3 );

   graphics->DrawPath( pen, graphicPath );
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSFILLPATH )
{
   Graphics * graphics = ( Graphics * ) hb_parptr( 1 );
   Brush * brush = ( Brush * ) hb_parptr( 2 );
   GraphicsPath * graphicPath = ( GraphicsPath * ) hb_parptr( 3 );

   graphics->FillPath( brush, graphicPath );
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPGRADIENTBRUSHSETCENTER )
{
   PathGradientBrush * pthGrBrush = ( PathGradientBrush * ) hb_parptr( 1 );
   Color clr =  Color( hb_parni( 2 ), hb_parni( 3 ), hb_parni( 4 ), hb_parni( 5 ) ) ;
   pthGrBrush->SetCenterColor( clr );

}


//------------------------------------------------------------------------------

HB_FUNC( GDIPGRADIENTBRUSHSETSURROUND )
{
   PathGradientBrush * pthGrBrush = ( PathGradientBrush * ) hb_parptr( 1 );
   Color clr =  Color( hb_parni( 2 ), hb_parni( 3 ), hb_parni( 4 ), hb_parni( 5 ) ) ;
   Color clr2 =  Color( hb_parni( 6 ), hb_parni( 7 ), hb_parni( 8 ), hb_parni( 9 ) ) ;

   int nAlpha =  clr.GetAlpha() - 80 ;

  int blue1  =  clr.GetB()  ;
  int green1 =  clr.GetG()  ;
  int red1   =  clr.GetR()  ;

  int blue2  =  clr2.GetB()  ;
  int green2 =  clr2.GetG()  ;
  int red2   =  clr2.GetR()  ;

  int blue3 = ( blue1 * nAlpha + blue2 * (255 - nAlpha )) / 255 ;
  int green3 = ( green1 * nAlpha + green2 * (255 - nAlpha )) / 255 ;
  int red3 = ( red1 * nAlpha + red2 * (255 - nAlpha)) / 255 ;

  Color clrFore = Color( nAlpha ,red3, green3, blue3 );

  int nLen = 1 ;
  Color cols[ ] = { clrFore  } ;

  pthGrBrush->SetSurroundColors( cols, &nLen );

   pthGrBrush->SetCenterColor( clr );

}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSCREATEREGIONFROMGPATH )
{

   GraphicsPath * graphicPath = ( GraphicsPath * ) hb_parptr( 1 );
   Region * NewRegion  =  new Region ( graphicPath ) ;
   hb_retptr( NewRegion ) ;
}


//------------------------------------------------------------------------------

HB_FUNC( GDIPLUSROTATEPATH )
{

   GraphicsPath * graphicPath = ( GraphicsPath * ) hb_parptr( 1 );
   Matrix * transformMatrix = new Matrix();

   float angle =  hb_parnd( 4 ) ; //180.0f

   transformMatrix->Reset();
   transformMatrix->RotateAt( angle , PointF( hb_parni( 2 ), hb_parni( 3 )) );

   graphicPath->Transform(transformMatrix);

}

//------------------------------------------------------------------------------

HB_FUNC( GDIPLUSROTATECENTERPATH )
{

   GraphicsPath * graphicPath = ( GraphicsPath * ) hb_parptr( 1 );
   Matrix * transformMatrix = new Matrix();

   float angle =  hb_parnd( 2 ) ; //180.0f

   transformMatrix->Reset();
   transformMatrix->Rotate( angle );

   graphicPath->Transform(transformMatrix);

}


HB_FUNC( GDIPLUSSCALEPATH )
{

   GraphicsPath * graphicPath = ( GraphicsPath * ) hb_parptr( 1 );
   Matrix * transformMatrix = new Matrix();

   float scaleX =  hb_parnd( 2 )/100.0f ;
   float scaleY =  hb_parnd( 3 )/100.0f  ;

   transformMatrix->Reset();
   transformMatrix->Scale( scaleX, scaleY, MatrixOrderPrepend );

   graphicPath->Transform(transformMatrix);

}


HB_FUNC( GDIPLUSTRANSLATEPATH )
{

   GraphicsPath * graphicPath = ( GraphicsPath * ) hb_parptr( 1 );
   Matrix * transformMatrix = new Matrix();

   float offsetX =  hb_parnd( 2 ) ;
   float offsetY =  hb_parnd( 3 ) ;

   transformMatrix->Reset();
   transformMatrix->Translate( offsetX, offsetY, MatrixOrderPrepend );

   graphicPath->Transform(transformMatrix);

}

//------------------------------------------------------------------------------

HB_FUNC( GDIPLUSCLONEPATH )
{

   GraphicsPath * graphicPath = ( GraphicsPath * ) hb_parptr( 1 );
   GraphicsPath * NewPath =graphicPath->Clone();
   hb_retptr( NewPath ) ;
}

//------------------------------------------------------------------------------

 HB_FUNC( GDIPLUSISINREGION )
{
  //  GraphicsPath * graphicPath = ( GraphicsPath * ) hb_parptr( 1 );
   Region * NewRegion  =  ( Region * )  hb_parptr( 1 );
   Graphics * graphics = ( Graphics * )  hb_parptr( 2 );
   int x = hb_parni( 3 );
   int y = hb_parni( 4 );

 //  Region region( graphicPath );
   Point point( y,x );

   bool lVisible =  NewRegion->IsVisible( point, graphics ) ;

   hb_retl( ( BOOL ) lVisible ) ;

}

//------------------------------------------------------------------------------

HB_FUNC( GDIPLUSTEXTTOBMP )
{
   Bitmap * original   = ( Bitmap * ) hb_parptr( 1 );

   int nWidth  = original->GetWidth()  ;
   int nHeight = original->GetHeight() ;
   Bitmap * newImage   = new Bitmap( nWidth, nHeight );

   Graphics * graphics = new Graphics( newImage );
   LPWSTR string       = AnsiToWide( ( char * ) hb_parc( 2 ) );
   LPWSTR NameFont     = AnsiToWide( ( char * ) hb_parc( 5 ) );
   //  LPWSTR string = UTF8toUTF16( hb_parc( 2 ) );

   float nLeft = hb_parnd( 4 );
   float nTop  = hb_parnd( 3 );

   FontFamily * fml = new FontFamily( NameFont );

   Font font( fml, hb_parni( 6 ) );

   delete fml;

   Brush * brush = ( Brush * ) hb_parptr( 7 ) ;

   graphics->DrawImage( original ,0, 0, nWidth, nHeight );
   graphics->SetSmoothingMode( SmoothingModeAntiAlias );

   TextRenderingHint hint = TextRenderingHintAntiAlias    ;
   graphics->SetTextRenderingHint( hint );
   graphics->DrawString( string, -1, &font, PointF( nLeft, nTop ), brush );

   delete graphics ;
   delete original ;

   hb_retptr( newImage );
}

//----------------------------------------------------------------------------//

HB_FUNC ( GDIPLUSCREASPHERA )
{

   float nLeft = ( float )hb_parnd( 2 );
   float nTop = ( float ) hb_parnd( 3 );
   float nWidth =  ( float ) hb_parnd( 4 );
   float nHeight = ( float ) hb_parnd( 5 );

   int nW = (int) nWidth ;
   int nH = (int) nHeight ;

  bool lImage = hb_parl( 11 ) ;

  Graphics * graphics ;
   Bitmap* newImage ;

  if ( lImage == TRUE )
     {
        newImage  = new Bitmap( nW, nH );
        graphics = new Graphics( newImage );

        nLeft = 1 ;
        nTop  = 1 ;
        nWidth = nWidth-2 ;
        nHeight = nHeight-2  ;
     }
     else
     {
        graphics = new Graphics( ( HDC ) hb_parnl( 1 )  );
     }

// Graphics * graphics = new Graphics( ( HDC ) hb_parnl( 1 )  );

  graphics->SetSmoothingMode(  SmoothingModeAntiAlias );

  GraphicsPath * graphicPath = new GraphicsPath() ;

  Color clr =  Color( hb_parni( 6 ), hb_parni( 7 ), hb_parni( 8 ), hb_parni( 9 ) ) ;

  graphicPath->AddEllipse( nLeft-( nHeight / 2) , nTop -( nWidth / 1.75), nWidth*2, nHeight*2 );
  PathGradientBrush * Brush = new PathGradientBrush( graphicPath ) ;

  Brush->SetCenterColor( clr );

  Color clr2 = Color( 255,0,0,0 );

  int nAlpha =  clr.GetAlpha() - 80 ;


  int blue1  =  clr.GetB()  ;
  int green1 =  clr.GetG()  ;
  int red1   =  clr.GetR()  ;

  int blue2  =  clr2.GetB()  ;
  int green2 =  clr2.GetG()  ;
  int red2   =  clr2.GetR()  ;


  int blue3 = ( blue1 * nAlpha + blue2 * (255 - nAlpha )) / 255 ;
  int green3 = ( green1 * nAlpha + green2 * (255 - nAlpha )) / 255 ;
  int red3 = ( red1 * nAlpha + red2 * (255 - nAlpha)) / 255 ;

  Color clrFore = Color( nAlpha ,red3, green3, blue3 );

  int nLen = 1 ;
  Color cols[ ] = { clrFore  } ;

  Brush->SetSurroundColors( cols, &nLen );

  graphics->FillEllipse( Brush, nLeft, nTop, nWidth, nHeight );
  graphics->DrawEllipse( new Pen( clrFore ), nLeft, nTop, nWidth, nHeight );

 bool lLight = hb_parl( 10 ) ;

 if ( lLight == TRUE )
    {

       //  MessageBox( GetActiveWindow(), "fallo", "No carga la imagen", 0x30 );

       Rect mRect = Rect(  nLeft+ nHeight / 50 , nTop+ nWidth / 10 , nWidth - nWidth / 5, nHeight / 1.5  );

       clr = Color( 0, 255, 255, 255 ) ;
       clr2 = Color( 204, 255, 255, 255 ) ;

       LinearGradientBrush * LBrush = new LinearGradientBrush( mRect, clr, clr2, LinearGradientModeVertical ) ;
       LBrush->SetWrapMode( WrapModeTileFlipXY ) ;


      REAL factors[3] = { 1.0f, 0.0f, 0.0f };
      REAL positions[3] = {0.0f, 0.6f, 1.0f};
      LBrush->SetBlend(factors, positions, 3);

      graphics->FillEllipse( LBrush, nLeft+ nWidth / 10 ,nTop+ nHeight / 50, nWidth - nWidth / 5, (nHeight / 1.5) - 1 );

      delete LBrush ;


 }

     delete Brush ;
     delete graphicPath ;

    if ( lImage == TRUE )
     {
       delete graphics ;
       hb_retptr( newImage );
    }
   else
     {
       hb_retptr( graphics );
    }

}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSBMPFROMTXTCENTER )
{
   int nWidth      = hb_parni(1)  ;
   int nHeight     = hb_parni(2)  ;

   Bitmap* fake    = new Bitmap( 1, 1, PixelFormat32bppPARGB ) ;
   Graphics * g    = new Graphics( fake );

   LPWSTR string   = AnsiToWide( ( char * ) hb_parc( 3 ) );
   LPWSTR NameFont = AnsiToWide( ( char * ) hb_parc( 4 ) );
   // LPWSTR string = UTF8toUTF16( hb_parc( 3 ) );

   FontFamily * fml = new FontFamily( NameFont );

   Font font( fml, hb_parni(5 ), FontStyleRegular, UnitPixel );

   delete fml;

   const StringFormat* pStringFormat = StringFormat::GenericTypographic();
   RectF boundRect;

   //  grabamos la medida del string
   g->MeasureString(string, -1, &font,PointF( 0, 0 ), pStringFormat, &boundRect);

   delete fake ;
   delete g ;

   int nwidth  = boundRect.Width ;
   int nheight = boundRect.Height ;

   Bitmap* newImage = new Bitmap( nWidth, nHeight, PixelFormat32bppPARGB ) ;

   Graphics * graphics = new Graphics( newImage );
   graphics->Clear( Color( 0, 255, 255, 255 ) ) ;

   Brush * brush = ( Brush * ) hb_parptr( 6 ) ;

   graphics->SetSmoothingMode( SmoothingModeAntiAlias );
   TextRenderingHint hint = TextRenderingHintAntiAlias    ;

   graphics->SetTextRenderingHint( hint ); //TextRenderingHint hint = TextRenderingHintAntiAlias    ;
   graphics->DrawString( string,-1, &font, RectF(((nWidth-nwidth)/2),
              ((nHeight-nheight)/2), nWidth, nHeight ), pStringFormat, brush  );

   // Pen pen(Color(255, 255, 0, 0));
   // graphics->DrawRectangle( &pen, RectF( ((nWidth-nwidth)/2), ((nHeight-nheight)/2), nwidth-1, nheight-1 ) );

   delete graphics ;
   hb_retptr( newImage );
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSNEWGRADIENTBRUSH )
{
   float nLeft   = hb_parnd( 1 );
   float nTop    = hb_parnd( 2 );
   float nWidth  = hb_parnd( 3 );
   float nHeight = hb_parnd( 4 );
   int   nType   = hb_parni( 13 );
   Rect  rect    = Rect( nTop, nLeft, nWidth, nHeight);

   Color clr1 = Color( hb_parnl( 5 ), hb_parnl( 6 ), hb_parnl( 7 ), hb_parnl( 8 ) );
   Color clr2 = Color( hb_parnl( 9 ), hb_parnl( 10 ), hb_parnl( 11), hb_parnl( 12 ) );

   if ( nType == 0 )
      hb_retptr( new LinearGradientBrush( rect, clr1, clr2, LinearGradientModeHorizontal ) ) ;

   if ( nType == 1 )
      hb_retptr( new LinearGradientBrush( rect, clr1, clr2, LinearGradientModeVertical ) ) ;

   if ( nType == 2 )
      hb_retptr( new LinearGradientBrush( rect, clr1, clr2, LinearGradientModeForwardDiagonal ) ) ;

   if ( nType == 3 )
      hb_retptr( new LinearGradientBrush( rect, clr1, clr2, LinearGradientModeBackwardDiagonal ) ) ;

 }

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSPATHADDSTRING )
{
   GraphicsPath * graphicPath = ( GraphicsPath * ) hb_parptr( 1 );
   const WCHAR * string =  AnsiToWide( ( char * ) hb_parc( 2 ) ) ;
   //const WCHAR *  string = UTF8toUTF16( hb_parc( 2 ) );
   LPWSTR NameFont =  AnsiToWide( ( char * ) hb_parc( 3 ) );

   int style     = hb_parni( 4 );
   float emSize  = ( float ) hb_parnd( 5 ) ;

    int nLeft    = hb_parni( 6 );
    int nTop     = hb_parni( 7 );
    int nRight   = hb_parni( 8 );
    int nBottom  = hb_parni( 9 );

   Rect pathRect = Rect( nLeft, nTop, nRight, nBottom );

   FontFamily * fml = new FontFamily( NameFont );

   graphicPath->AddString( string, -1, fml, style, emSize, pathRect, NULL ) ;

   delete fml;
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSCREATEPOINTF )
{
   float nLeft = hb_parnd( 1 );
   float nTop = hb_parnd( 2 );
   hb_retptr( new PointF( nLeft , nTop ) );
}


//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSDRAWARC )
{
   Graphics * graphics = ( Graphics * ) hb_parptr( 1 );
   Pen * pen = ( Pen * ) hb_parptr( 2 );

   float nLeft = hb_parnd( 3 );
   float nTop = hb_parnd( 4 );
   float nWidth =  hb_parnd( 5 );
   float nHeight = hb_parnd( 6 );
   float startAngle =  hb_parnd( 7 );
   float sweepAngle = hb_parnd( 8 );

   graphics->DrawArc( pen, nLeft, nTop, nWidth, nHeight, startAngle, sweepAngle);
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSSTARTUP )
{
   hb_retl( GdiplusStartup( &gdiplusToken, &gdiplusStartupInput, NULL ) );
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSSHUTDOWN )
{
   GdiplusShutdown( gdiplusToken );
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSISEMPTYGRAPHICS)
{
   Graphics * graphics = ( Graphics * ) hb_parptr( 1 );

   hb_retl( ( BOOL )   graphics->IsClipEmpty() ) ;
}

//----------------------------------------------------------------------------//

HB_FUNC( SETPAGEUNIT2PIXEL )
{
   Graphics * graphics = ( Graphics * ) hb_parptr( 1 );
   graphics->SetPageUnit( UnitPixel ); // Unit to Pixel
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSSETSMOOTHINGGRAPHICS )
{
   Graphics * graphics = ( Graphics * ) hb_parptr( 1 );
   int nType =  hb_parni( 2 );

   switch ( nType ){

      case 1:
         graphics->SetSmoothingMode( SmoothingModeNone ) ;
      case 2:
         graphics->SetSmoothingMode( SmoothingModeDefault );
      case 3:
         graphics->SetSmoothingMode(  SmoothingModeHighSpeed );
      case 4:
         graphics->SetSmoothingMode(  SmoothingModeHighQuality );
      case 5:
         graphics->SetSmoothingMode(  SmoothingModeAntiAlias );

    }
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSCREATEIMAGEFROMFILE )
{
   Bitmap * newImage =  new Bitmap( ( LPCWSTR ) hb_parc(1) );
   hb_retptr( newImage );
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSCREATEIMAGE32FORMAT )
{
   int width  =  hb_parni( 1 );
   int height =  hb_parni( 2 );

   Bitmap * newImage = new Bitmap( width, height, PixelFormat32bppARGB );
   hb_retptr( newImage );
}


//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSCREATEIMAGEFROMRES )
{
   Bitmap * newImage = new Bitmap( ( HBITMAP ) fw_parH( 1 ), ( HPALETTE ) fw_parH( 2 ) );
   hb_retptr( newImage );
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSBITMAPFROMRESOURCE )
{
   const WCHAR *bitmapName = ( LPCWSTR ) hb_parc( 1 );
   Bitmap * newImage =  new Bitmap( GetModuleHandle( 0 ), bitmapName );
   hb_retptr( newImage );
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSIMAGECLONE )
{
   int nLeft   = hb_parni( 3 );
   int nTop    = hb_parni( 2 );
   int nWidth  = hb_parni( 4 );
   int nHeight = hb_parni( 5 );
   int nPixelFormat    = hb_parni( 6 );
   Bitmap * newImage   = ( Bitmap * ) hb_parptr( 1 );
   Bitmap * cloneImage = newImage->Clone( nTop, nLeft, nWidth, nHeight, nPixelFormat );

   hb_retptr( cloneImage );
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSDRAWIMAGE )
{
   int iParams = hb_pcount();

   Graphics * graphics = ( Graphics * ) hb_parptr( 1 );
   Bitmap * newImage   = ( Bitmap * ) hb_parptr( 2 );
   int nLeft;
   int nTop;
   int nWidth;
   int nHeight;

   switch (iParams){

    case 4:
      nLeft  = hb_parni( 3 );
      nTop   = hb_parni( 4 );

    graphics->DrawImage( newImage, nLeft, nTop );

   case 6:
     nLeft   = hb_parni( 3 );
     nTop    = hb_parni( 4 );
     nWidth  = hb_parni( 5 );
     nHeight = hb_parni( 6 );

    graphics->DrawImage( newImage, nLeft, nTop, nWidth, nHeight );
  }
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSIMAGERESIZE )
{
   int nWidth  = hb_parni( 2 );
   int nHeight = hb_parni( 3 );
   Bitmap * original   = ( Bitmap * ) hb_parptr( 1 );

   Bitmap* newImage    = new Bitmap( nWidth, nHeight);
   Graphics * graphics = new Graphics( newImage );
   graphics->DrawImage( original ,0, 0, nWidth, nHeight);

   delete graphics ;

   hb_retptr( newImage );
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSIMAGESAVE )
{

   Bitmap * newImage = ( Bitmap * ) hb_parptr( 1 );
   CLSID cClsid ;
   //LPWSTR file = ( LPWSTR ) hb_parc( 2 );
   LPWSTR file = AnsiToWide( ( char * ) hb_parc( 2 ) );
   //LPWSTR identificador =  ( LPWSTR ) hb_parc( 3 );
   LPWSTR identificador =   AnsiToWide( ( char * ) hb_parc( 3 ) );
   int nStatus;

   CLSIDFromString( identificador, &cClsid ) ;
   nStatus = newImage->Save( file, &cClsid, NULL );
   hb_retl( ( nStatus != 0 ? FALSE : TRUE ) );
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSIMAGESAVEQUALITY )
{

   long quality =  hb_parnl(4) ;
   CLSID  EncoderQuality ;
   int nStatus;

   CLSIDFromString( L"{1D5BE4B5-FA4A-452D-9CDD-5DB35105E7EB}", &EncoderQuality ) ;
   EncoderParameters encoderParameters;

   encoderParameters.Count = 1;
   encoderParameters.Parameter[ 0 ].Guid = EncoderQuality ;
   encoderParameters.Parameter[ 0 ].Type = EncoderParameterValueTypeLong;
   encoderParameters.Parameter[ 0 ].NumberOfValues = 1;
   encoderParameters.Parameter[ 0 ].Value = &quality ;

   Bitmap * newImage = ( Bitmap * ) hb_parptr( 1 );
   CLSID cClsid ;
   LPWSTR file = ( LPWSTR ) hb_parc( 2 );
   LPWSTR identificador =  ( LPWSTR ) hb_parc( 3 );

   CLSIDFromString( identificador, &cClsid ) ;
   nStatus = newImage->Save( file , &cClsid, &encoderParameters );
   hb_retl( ( nStatus != 0 ? FALSE : TRUE ) );
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSIMAGECREATETHUMB )
{
  Bitmap * newImage = ( Bitmap * ) hb_parptr( 1 );
  int nWidth =  hb_parni( 2 );
  int nHeight = hb_parni( 3 );

  Image * hThumb = newImage->GetThumbnailImage( nWidth , nHeight, NULL, NULL );

  hb_retptr( hThumb );
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSCREATEHBITMAPIMAGE )
{
   HBITMAP   handle;
   int       error;

   Bitmap * newImage = ( Bitmap * ) hb_parptr( 1 );
   error =  newImage->GetHBITMAP( Color( 0, 0, 0 ), &handle );

   if ( error == 0 ) fw_retnll( ( HBITMAP) handle );
   else fw_retnll( 0 );
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSGETWIDTHBITMAP)
{
  Bitmap * newImage = ( Bitmap * ) hb_parptr( 1 );
  hb_retnl( ( HB_LONG ) newImage->GetWidth() );
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSGETHEIGHTBITMAP)
{
  Bitmap * newImage = ( Bitmap * ) hb_parptr( 1 );
  hb_retnl( ( HB_LONG ) newImage->GetHeight() );
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSIMAGEDISPOSE )
{
  Bitmap * newImage = ( Bitmap * ) hb_parptr( 1 );
  delete newImage;
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSIMAGEROTATEFLIP )
{
   Bitmap * newImage = ( Bitmap * ) hb_parptr( 1 );
   int nType =  hb_parni( 2 );

   switch ( nType ){
      case 1:
         newImage->RotateFlip( Rotate90FlipNone  ) ; break ;
      case 2:
         newImage->RotateFlip( Rotate180FlipNone ) ; break ;
      case 3:
         newImage->RotateFlip( Rotate270FlipNone ) ; break ;
      case 4:
         newImage->RotateFlip( RotateNoneFlipX   ) ; break ;
      case 5:
         newImage->RotateFlip( Rotate90FlipX     ) ; break ;
      case 6:
         newImage->RotateFlip( Rotate180FlipX    ) ; break ;
      case 7:
         newImage->RotateFlip( Rotate270FlipX    ) ; break ;
  }
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSIMAGESETPIXCOLOR )
{
   Bitmap * newImage = ( Bitmap * ) hb_parptr( 1 );

   int nX =  hb_parni( 2 );
   int nY =  hb_parni( 3 );
   Color clr = Color( hb_parnl( 4 ), hb_parnl( 5 ), hb_parnl( 6 ), hb_parnl( 7 ) );
   newImage->SetPixel(nX, nY, clr );
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSIMAGESETPIXHCOLOR )
{
   Bitmap * newImage = ( Bitmap * ) hb_parptr( 1 );
   int nX =  hb_parni( 2 );
   int nY =  hb_parni( 3 );
   Color clr = Color( hb_parnl( 4 ) );
   newImage->SetPixel(nX, nY, clr );
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSIMAGEGETPIXFORMAT )
{
   Bitmap * newImage = ( Bitmap * ) hb_parptr( 1 );
   int nFormato = newImage->GetPixelFormat();
   hb_retni( nFormato );
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSIMAGEIS32BITS )
{
   Bitmap * newImage = ( Bitmap * ) hb_parptr( 1 );

   if ( newImage->GetPixelFormat() ==  PixelFormat32bppARGB )
          hb_retl( (bool) true );
       else
          {
   if (newImage->GetPixelFormat() ==  PixelFormat32bppPARGB )
          hb_retl( (bool) true );
        else
   hb_retl( (bool) false );
  }
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSIMAGESET32BITS )
{
   Bitmap * original = ( Bitmap * ) hb_parptr( 1 );
   bool lPremulti    = hb_parl( 2 ) ;
   int nWidth        = original->GetWidth() ;
   int nHeight       = original->GetHeight() ;
   int nFormato ;
   if( lPremulti ){
       nFormato =  PixelFormat32bppPARGB ;
     }
   else
     {
       nFormato =  PixelFormat32bppARGB ;
     }
   Bitmap * newImage =  new Bitmap( nWidth, nHeight, nFormato ) ;

   Graphics * graphics = new Graphics( newImage ) ;
   graphics->DrawImage( original ,0, 0, nWidth, nHeight);

   delete graphics ;
   delete original ;
   hb_retptr( newImage );
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSIMAGEGETPIXCOLOR )
{
   Bitmap * newImage = ( Bitmap * ) hb_parptr( 1 );
   int nX =  hb_parni( 2 );
   int nY =  hb_parni( 3 );
   Color pixelColor;
   newImage->GetPixel(nX, nY, &pixelColor );
   ARGB argb = pixelColor.GetValue();
   hb_retnl( argb );
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSCREATECOLOR )
{
   Color clr = Color( hb_parnl( 1 ), hb_parnl( 2 ), hb_parnl( 3 ), hb_parnl( 4 ) );
   ARGB argb = clr.GetValue();
   hb_retnl( argb );
}

//----------------------------------------------------------------------------//


HB_FUNC( GDIPLUSIMAGEPIXTOGRAYCOLOR )
{
   Bitmap * newImage = ( Bitmap * ) hb_parptr( 1 );
   int nX =  hb_parni( 2 );
   int nY =  hb_parni( 3 );

   Color pixelColor;
   Color newColor ;

   newImage->GetPixel( nX, nY, &pixelColor );
   int nAlpha = pixelColor.GetAlpha();
   int ret = ( pixelColor.GetR() + pixelColor.GetG() + pixelColor.GetB() ) / 3 ;

   newColor = Color( nAlpha, ret, ret, ret ) ;
   newImage->SetPixel( nX, nY, newColor );
}


//----------------------------------------------------------------------------//
/*
HB_FUNC( GDIPLUSIMAGEBRIGHTCONTRAS)
{

   typedef struct {
  INT brightnessLevel;
  INT contrastLevel;
} BrightnessContrastParams;



 Bitmap * newImage = ( Bitmap * ) hb_parnl( 1 );
 int bright = hb_parnl( 2 );
 int Contrast = hb_parnl( 3 );
 UINT srcWidth = newImage->GetWidth();
 UINT srcHeight = newImage->GetHeight();

 BrightnessContrast bricon = BrightnessContrast();

 BrightnessContrastParams briConParams;

 briConParams.brightnessLevel = bright ;
 briConParams.contrastLevel = Contrast ;

 bricon->SetParameters( briConParams );

// newImage->ApplyEffect(&briCon, &rectOfInterest);

}
*/

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSIMAGEGETHICON )
{
   Bitmap * newImage = ( Bitmap * ) hb_parptr( 1 );
   HICON hIcon ;
   newImage->GetHICON( &hIcon );
   fw_retnll( ( HICON ) hIcon );
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSIMAGELOADFROMMEMORY )
{
   void const *lpData = hb_parc( 1 ) ;
   DWORD dwSize       = hb_parni( 2 ) ;
   HGLOBAL hgImage;
   IStream *isImage   = NULL;
   Bitmap *pbmImage   = NULL;
   //HBITMAP hbmpImage;

   hgImage = GlobalAlloc( GMEM_MOVEABLE, dwSize );
   if( hgImage )
   {
      CopyMemory( GlobalLock( hgImage ), lpData, dwSize );
      GlobalUnlock( hgImage );
      CreateStreamOnHGlobal( hgImage, FALSE, &isImage );
      if( isImage )
      {
         pbmImage = Bitmap::FromStream( isImage );
         isImage->Release();
      }
      GlobalFree( hgImage );
   }

   hb_retptr( pbmImage );
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSIMAGELOADPNGFROMSTR )
{
   void const *lpData = hb_parc( 1 ) ;
   DWORD dwSize       = hb_parni( 2 ) ;
   HGLOBAL hgImage;
   IStream *isImage  = NULL;
   Bitmap  *pbmImage = NULL;

   //HBITMAP hbmpImage;
   hgImage = GlobalAlloc( GMEM_FIXED, dwSize);
   if( hgImage )
   {
      CopyMemory(GlobalLock( hgImage ), lpData, dwSize );
      GlobalUnlock( hgImage );
      CreateStreamOnHGlobal( hgImage, FALSE, &isImage );
      if( isImage )
      {
         pbmImage = new Bitmap( isImage );
         isImage->Release();
      }
      GlobalFree( hgImage );
   }

   hb_retptr( pbmImage );
}

 //----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSIMAGELOADPNGFROMRESOURCES )
{
   void const *lpData ; // = hb_parc(1) ;
   DWORD dwSize    ;  //=  hb_parni(2) ;
   HGLOBAL hgImage;
   IStream *isImage  = NULL;
   Bitmap  *pbmImage = NULL;

   //HBITMAP hbmpImage;

   LPCTSTR pName = ( LPCTSTR ) hb_parc( 2 ) ;
   LPCTSTR pType = MAKEINTRESOURCE( hb_parni( 3 ) ) ;
//   HMODULE hInst = ( HINSTANCE ) hb_parnl( 1 ) ;
   HMODULE hInst = ( HINSTANCE ) fw_parH( 1 ) ;
   // LPCTSTR pType =  ( LPCTSTR ) hb_parc( 3 )  ;

   HRSRC hResource = FindResource( hInst, pName, pType );

    if (!hResource)
         hb_retl( FALSE );

   dwSize = SizeofResource(hInst, hResource);

   if ( !dwSize )
      hb_retl( FALSE );

   lpData = LockResource(  LoadResource (hInst, hResource ) );
   if ( !lpData )
      hb_retl( FALSE );

   hgImage = GlobalAlloc( GMEM_ZEROINIT | GMEM_FIXED, dwSize );
   //  hgImage = GlobalAlloc( GMEM_FIXED, dwSize);
   //  hgImage = GlobalAlloc(GMEM_MOVEABLE,dwSize );

   if( hgImage )
   {
   // CopyMemory (LPVOID (hgImage), lpData, dwSize);
      CopyMemory( GlobalLock( hgImage ), lpData, dwSize );
      GlobalUnlock( hgImage );

      CreateStreamOnHGlobal( hgImage, FALSE, &isImage );
      if( isImage )
      {
         pbmImage = Bitmap::FromStream( isImage );
         isImage->Release();
      }
      GlobalFree( hgImage );
   }

//   hb_retnl( ( HB_LONG ) pbmImage );
   hb_retptr( pbmImage );

}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSIMAGELOADFROMSTREAM )
{
   IStream *isImage  = ( IStream * ) hb_parptr( 1 ) ;

   Bitmap  *pbmImage =  new  Bitmap( isImage );
   isImage->Release();

   hb_retptr( pbmImage );
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSEMFTOJPG )
{

   void const *lpData = hb_parc( 1 ) ;
   DWORD dwSize       = hb_parni( 2 ) ;
   HGLOBAL hgImage;
   IStream *isImage = NULL;
   Bitmap *original = NULL;
   //HBITMAP hbmpImage;
   hgImage = GlobalAlloc( GMEM_MOVEABLE, dwSize );
   if(hgImage)
   {
      CopyMemory( GlobalLock( hgImage ), lpData, dwSize );
      GlobalUnlock( hgImage );
      CreateStreamOnHGlobal( hgImage, FALSE, &isImage );
      if( isImage )
      {
        original = Bitmap::FromStream( isImage );
        isImage->Release();
      }
      GlobalFree( hgImage );
   }


   LPWSTR filefin = ( LPWSTR ) hb_parc( 3 );

   long quality =  hb_parnl( 4 ) ;
   int nWidth ;
   int nHeight ;
   CLSID EncoderQuality;

   Brush * brush =  new SolidBrush( Color( 255, 255, 255, 255 ) ) ;
   nWidth  = original->GetWidth() ;
   nHeight = original->GetHeight() ;

   Bitmap * newImage = new Bitmap( nWidth, nHeight );
   Graphics * g =  new Graphics( newImage );
   g->FillRectangle( brush , 0,0, nWidth, nHeight ) ;
   g->DrawImage( original, 0, 0, nWidth, nHeight);

   CLSIDFromString( L"{1D5BE4B5-FA4A-452D-9CDD-5DB35105E7EB}", &EncoderQuality ) ;
   EncoderParameters encoderParameters;

   encoderParameters.Count = 1;
   encoderParameters.Parameter[0].Guid = EncoderQuality ;
   encoderParameters.Parameter[0].Type = EncoderParameterValueTypeLong;
   encoderParameters.Parameter[0].NumberOfValues = 1;

   encoderParameters.Parameter[0].Value = &quality ;

   CLSID cClsid ;

   CLSIDFromString( L"{557CF401-1A04-11D3-9A73-0000F81EF32E}" , &cClsid ) ;
   newImage->Save( filefin , &cClsid, &encoderParameters );

   delete newImage ;
   delete brush ;
   delete g ;
   delete original ;

}

//----------------------------------------------------------------------------//

// #define EncoderQuality  0x1d5be4b5,0xfa4a,0x452d,0x9c,0xdd,0x5d,0xb3,0x51,0x05,0xe7,0xeb
/*
HB_FUNC( GDIPLUSIMAGESETQUALITYPARAM )
{

   //_GUID EncoderQuality = {  0x1d5be4b5,0xfa4a,0x452d,0x9c,0xdd,0x5d,0xb3,0x51,0x05,0xe7,0xeb } ;

   long quality =  hb_parnl( 1 ) ;
   GUID EncoderQuality ;
  LPWSTR identificador =  (LPWSTR) hb_parc(2);
   CLSIDFromString( identificador, &EncoderQuality ) ;

   EncoderParameters encoderParameters;

    encoderParameters.Count = 1;
   encoderParameters.Parameter[0].Guid = EncoderQuality ;
   encoderParameters.Parameter[0].Type = EncoderParameterValueTypeLong;
   encoderParameters.Parameter[0].NumberOfValues = 1;

  encoderParameters.Parameter[0].Value = &quality ;

  EncoderParameters* pParameters = &encoderParameters ;

  hb_retnl( ( HB_LONG ) pParameters  );

}
*/
//----------------------------------------------------------------------------//


/*
HB_FUNC( GDIPLUSIMAGEGETRAWFORMAT)
{
   GUID guid;
   WCHAR strGuid[39];
  Image * newImage = ( Image * ) hb_parnl( 1 );
  newImage->GetRawFormat(&guid ) ;

  if(guid == ImageFormatJPEG )
       hb_retc( "JPG" );


//  StringFromGUID2(guid, strGuid, 39);
//  hb_retc( str( strGuid ) );
}
 */

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSIMAGELOADCACHEDFILE )
{

  FILE * fil = fopen (  hb_parc(1) , "rb" ) ;
  fseek ( fil , 0 , SEEK_END ) ;
  int filesize = ftell ( fil ) ;

  fseek ( fil , 0 , SEEK_SET ) ;
  HGLOBAL hglobal = GlobalAlloc ( GMEM_MOVEABLE , filesize ) ;

  char * adr = (char *)GlobalLock ( hglobal ) ;
  int nbytes = fread ( adr , 1 , filesize , fil ) ;
  fclose ( fil ) ;

  if ( nbytes != filesize )
      {
       MessageBox( GetActiveWindow(), "fallo", "No carga la imagen", 0x30 );
      } ;

 LPSTREAM pstm = NULL ;
 GlobalUnlock ( hglobal ) ;

 CreateStreamOnHGlobal ( hglobal, TRUE, &pstm ) ;

 Bitmap *original = new  Bitmap( pstm,FALSE );

 int nWidth  = original->GetWidth()  ;
 int nHeight = original->GetHeight() ;

 Bitmap * result ;
 Graphics * graphics ;

 PixelFormat pf = original->GetPixelFormat();  // anotamos original

 if ( pf == PixelFormat32bppRGB  )            // si es alpha32 resolvemos
     result = BitmapFromAlphaBmp( original ) ;
 else
 {                                           // sino
      if ( ( pf & PixelFormatIndexed ) != 0 )  // si es indexado asigamos PARGB
            pf = PixelFormat32bppPARGB ;

      result  = new Bitmap( nWidth, nHeight, pf );   // y creamos el nuevo bitmap


      graphics = new Graphics( result );
      graphics->DrawImage( original ,0, 0, nWidth, nHeight);

      delete graphics ;
      delete original ;
 }

 GlobalFree( hglobal );
 pstm->Release();

 hb_retptr( result );

}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSIMAGEPIXGETALPHA )
{
   Bitmap * newImage = ( Bitmap * ) hb_parptr( 1 );
   int nX =  hb_parni( 2 );
   int nY =  hb_parni( 3 );
   Color pixelColor;

   newImage->GetPixel(nX, nY, &pixelColor );
   long nAlpha = pixelColor.GetAlpha();
   hb_retnl( nAlpha );
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSIMAGEMATRIXCUSTOM )
{

 Bitmap * original = ( Bitmap * ) hb_parptr( 1 );

#ifdef __XHARBOUR__

 float m1 =  (float) hb_parnd( 2, 1 ) ;
 float m2 =  (float) hb_parnd( 2, 2 ) ;
 float m3 =  (float) hb_parnd( 2, 3 ) ;
 float m4 =  (float) hb_parnd( 2, 4 ) ;
 float m5 =  (float) hb_parnd( 2, 5 ) ;

 float m6 =  (float) hb_parnd( 2, 6 ) ;
 float m7 =  (float) hb_parnd( 2, 7 ) ;
 float m8 =  (float) hb_parnd( 2, 8 ) ;
 float m9 =  (float) hb_parnd( 2, 9 ) ;
 float m10 = (float) hb_parnd( 2, 10 ) ;

 float m11 = (float) hb_parnd( 2, 11 ) ;
 float m12 = (float) hb_parnd( 2, 12 ) ;
 float m13 = (float) hb_parnd( 2, 13 ) ;
 float m14 = (float) hb_parnd( 2, 14 ) ;
 float m15 = (float) hb_parnd( 2, 15 ) ;

 float m16 = (float) hb_parnd( 2, 16 ) ;
 float m17 = (float) hb_parnd( 2, 17 ) ;
 float m18 = (float) hb_parnd( 2, 18 ) ;
 float m19 = (float) hb_parnd( 2, 19 ) ;
 float m20 = (float) hb_parnd( 2, 20 ) ;

 float m21 = (float) hb_parnd( 2, 21 ) ;
 float m22 = (float) hb_parnd( 2, 22 ) ;
 float m23 = (float) hb_parnd( 2, 23 ) ;
 float m24 = (float) hb_parnd( 2, 24 ) ;
 float m25 = (float) hb_parnd( 2, 25 ) ;

#else

 float m1 =  (float) hb_parvnd( 2, 1 ) ;
 float m2 =  (float) hb_parvnd( 2, 2 ) ;
 float m3 =  (float) hb_parvnd( 2, 3 ) ;
 float m4 =  (float) hb_parvnd( 2, 4 ) ;
 float m5 =  (float) hb_parvnd( 2, 5 ) ;

 float m6 =  (float) hb_parvnd( 2, 6 ) ;
 float m7 =  (float) hb_parvnd( 2, 7 ) ;
 float m8 =  (float) hb_parvnd( 2, 8 ) ;
 float m9 =  (float) hb_parvnd( 2, 9 ) ;
 float m10 = (float) hb_parvnd( 2, 10 ) ;

 float m11 = (float) hb_parvnd( 2, 11 ) ;
 float m12 = (float) hb_parvnd( 2, 12 ) ;
 float m13 = (float) hb_parvnd( 2, 13 ) ;
 float m14 = (float) hb_parvnd( 2, 14 ) ;
 float m15 = (float) hb_parvnd( 2, 15 ) ;

 float m16 = (float) hb_parvnd( 2, 16 ) ;
 float m17 = (float) hb_parvnd( 2, 17 ) ;
 float m18 = (float) hb_parvnd( 2, 18 ) ;
 float m19 = (float) hb_parvnd( 2, 19 ) ;
 float m20 = (float) hb_parvnd( 2, 20 ) ;

 float m21 = (float) hb_parvnd( 2, 21 ) ;
 float m22 = (float) hb_parvnd( 2, 22 ) ;
 float m23 = (float) hb_parvnd( 2, 23 ) ;
 float m24 = (float) hb_parvnd( 2, 24 ) ;
 float m25 = (float) hb_parvnd( 2, 25 ) ;

#endif

 ColorMatrix newMatrix = {
            m1 , m2, m3, m4, m5 ,
            m6, m7, m8 , m9, m10,
            m11 , m12, m13, m14, m15 ,
            m16, m17, m18 , m19, m20,
            m21 , m22, m23, m24, m25 } ;


 ColorMatrix * colorMatrix = new ColorMatrix( newMatrix );

 int nWidth  =  original->GetWidth() ;
 int nHeight =  original->GetHeight() ;

  //      ColorMatrix matrix = GetMatrix(percent); // returns a variation of the above.

  Bitmap * newImage = new Bitmap( nWidth, nHeight  );
  Graphics * gr = new Graphics( newImage );

        //create some image attributes
  ImageAttributes  imageAttributes ;

  imageAttributes.SetColorMatrix( colorMatrix, ColorMatrixFlagsDefault,
                                    ColorAdjustTypeBitmap);


  gr->DrawImage(original, Rect(0, 0, nWidth, nHeight),
           0, 0, nWidth, nHeight, UnitPixel, &imageAttributes );

        //dispose the Graphics object
  delete gr  ;
  delete original ;
  delete colorMatrix ;

  hb_retptr( newImage );

}

//----------------------------------------------------------------------------//

static Bitmap * BitmapSetPixtoAlpha( Bitmap * original, int nX, int nY  )
{
  Color pixelColor;
  original->GetPixel(nX, nY, &pixelColor );

  int blue  =  pixelColor.GetB()  ;
  int green =  pixelColor.GetG()  ;
  int red   =  pixelColor.GetR()  ;

  Color newcolor =  Color( 0 , red, green, blue ) ;

 int nWidth  =  original->GetWidth() ;
 int nHeight =  original->GetHeight() ;

  Bitmap * newImage = new Bitmap( nWidth, nHeight  );
  Graphics * gr = new Graphics( newImage );

  //create some image attributes
  ImageAttributes  imageAttributes ;

  ColorMap  colorMap[1];

  colorMap[0].oldColor = pixelColor ;
  colorMap[0].newColor = newcolor ;

  imageAttributes.SetRemapTable( 1, colorMap, ColorAdjustTypeBitmap );

  gr->SetSmoothingMode( SmoothingModeHighQuality );

  gr->DrawImage(original, Rect(0, 0, nWidth, nHeight),
           0, 0, nWidth, nHeight, UnitPixel, &imageAttributes );

        //dispose the Graphics object
  delete gr  ;
  delete original ;

return newImage ;

 }

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSPIXELCOLORTOALPHA )
{
  hb_retptr( BitmapSetPixtoAlpha( ( Bitmap * ) hb_parptr( 1 ),  hb_parni(2), hb_parni(3) ) );
 }

//----------------------------------------------------------------------------//


HB_FUNC( GDIPLUSIMAGEPIXGETRED )
{
   Bitmap * newImage = ( Bitmap * ) hb_parptr( 1 );
   int nX =  hb_parni( 2 );
   int nY =  hb_parni( 3 );
   Color pixelColor;
   newImage->GetPixel(nX, nY, &pixelColor );
   long nR = pixelColor.GetR();
   hb_retnl( nR );
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSIMAGEPIXGETBLUE )
{
   Bitmap * newImage = ( Bitmap * ) hb_parptr( 1 );
   int nX =  hb_parni( 2 );
   int nY =  hb_parni( 3 );
   Color pixelColor;
   newImage->GetPixel(nX, nY, &pixelColor );
   long nB = pixelColor.GetB();
   hb_retnl( nB );
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSIMAGEPIXGETGREEN )
{
   Bitmap * newImage = ( Bitmap * ) hb_parptr( 1 );
   int nX =  hb_parni( 2 );
   int nY =  hb_parni( 3 );
   Color pixelColor;
   newImage->GetPixel(nX, nY, &pixelColor );
   long nG = pixelColor.GetG();
   hb_retnl( nG );
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSIMAGECROP )
{
   int nTop =  hb_parni( 2 );
   int nLeft = hb_parni( 3 );
   int nWidth =  hb_parni( 4 );
   int nHeight = hb_parni( 5 );
   Bitmap * original = ( Bitmap * )  hb_parptr( 1 );

   Bitmap* newImage  = new Bitmap( nWidth, nHeight);
   Graphics * graphics = new Graphics( newImage );

   Rect destino ( 0 , 0 , nWidth, nHeight );

   graphics->DrawImage( original, destino , nTop , nLeft , nWidth, nHeight, UnitPixel );

   delete graphics ;

   hb_retptr( newImage );

}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSIMAGEMATRIXTOGRAY )
{

   Bitmap * original = ( Bitmap * ) hb_parptr( 1 );

   ColorMatrix MatrixGray = {
                            .3f, .3f, .3f, 0, 0,
                            .59f, .59f, .59f, 0, 0,
                            .11f, .11f, .11f, 0, 0,
                            0, 0, 0, 1, 0,
                            0, 0, 0, 0, 1 };


   ColorMatrix * GrayMatrix = new ColorMatrix( MatrixGray );

   int nWidth  = original->GetWidth()  ;
   int nHeight = original->GetHeight() ;

   Bitmap * newImage = new Bitmap( nWidth, nHeight );
   Graphics * g = new Graphics( newImage );
        //create some image attributes
   ImageAttributes imageAttributes ;

   imageAttributes.SetColorMatrix( GrayMatrix, ColorMatrixFlagsDefault,
                                    ColorAdjustTypeBitmap);


   g->DrawImage(original, Rect(0, 0, nWidth, nHeight),
           0, 0, nWidth, nHeight, UnitPixel, &imageAttributes );

   delete g   ;
   delete original ;
   delete GrayMatrix ;

   hb_retptr( newImage );

}

//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSIMAGEROTATEANGLE )
{
  Bitmap * original = ( Bitmap * ) hb_parptr( 1 );
  float nAngle = hb_parnl( 2 );
  bool lAdjust = hb_parl( 3 );
  int interpolation = hb_parni( 4 );

  int nWidth  = original->GetWidth()  ;
  int nHeight = original->GetHeight() ;

  float radians = ( PI * nAngle ) / 180;

  float cosine = cos(radians);
  float sine   = sin(radians);
  if ( cosine < 0.0F )
     cosine =  - cosine ;

  if ( sine < 0.0F )
     sine =  - sine ;


  float Point1x = ( - nHeight*sine );
  float Point1y = ( nHeight*cosine );
  float Point2x = ( nWidth*cosine - nHeight*sine );
  float Point2y = ( nHeight*cosine + nWidth*sine );
  float Point3x = ( nWidth*cosine );
  float Point3y = ( nWidth*sine );

  float minx = min( Point1x, min( Point2x, Point3x ) );
  float miny = min( Point1y, min( Point2y, Point3y ) );

  minx = min( ( float )0, minx );
  miny = min( ( float )0, miny );

  float maxx = max( Point1x, max( Point2x, Point3x ) );
  float maxy = max( Point1y, max( Point2y, Point3y ) );

  int nNewWidth  = ( int ) ceil( fabs( maxx ) - minx )  ;
  int nNewHeight = ( int ) ceil( fabs( maxy ) - miny )  ;

  float nDif1 =  nNewWidth / 2  - nWidth / 2 ;
  float nDif2 =  nNewHeight / 2 - nHeight / 2 ;

  float scaleX = ( float )  nWidth / nNewWidth  ;
  float scaleY = ( float )  nHeight / nNewHeight ;

  Bitmap* newImage ;

  if ( lAdjust )
  	  newImage  = new Bitmap( nWidth , nHeight , original->GetPixelFormat() );
  else	
      newImage  = new Bitmap( nNewWidth , nNewHeight , original->GetPixelFormat() );   // recorta algo la imagen

  Graphics * graphics = new Graphics( newImage );

 // graphics->Clear(Color::Blue ) ;

  switch ( interpolation ){
      case 0:
        graphics->SetInterpolationMode( InterpolationModeDefault );
      case 1:
        graphics->SetInterpolationMode( InterpolationModeLowQuality );
      case 2:
        graphics->SetInterpolationMode( InterpolationModeHighQuality );
      case 3:
        graphics->SetInterpolationMode( InterpolationModeBilinear );
      case 4:
        graphics->SetInterpolationMode( InterpolationModeBicubic );
      case 5:
        graphics->SetInterpolationMode( InterpolationModeNearestNeighbor );
      case 6:
        graphics->SetInterpolationMode( InterpolationModeHighQualityBilinear );
      case 7:
        graphics->SetInterpolationMode( InterpolationModeHighQualityBicubic );
      default:
        graphics->SetInterpolationMode( InterpolationModeHighQualityBicubic );
  }

  graphics->TranslateTransform( (float)newImage->GetWidth() / 2, (float)newImage->GetHeight() / 2);
  graphics->RotateTransform( nAngle );
  graphics->TranslateTransform(-(float)newImage->GetWidth()/ 2, -(float)newImage->GetHeight() / 2);

  if ( lAdjust )
  	 graphics->ScaleTransform(scaleX, scaleY ) ;

  Rect recorte (  nDif1 , nDif2,  nWidth,  nHeight );	
  graphics->DrawImage(original, recorte );

   delete original ;
   delete graphics ;

hb_retptr( newImage );

 }

//----------------------------------------------------------------------------/

HB_FUNC( GDIPLUSGRAPHROTATETRANSFORM )
{
	Graphics * graphics = ( Graphics * ) hb_parptr( 1 );
   float nAngle =  ( float ) hb_parni( 2 );
   graphics->RotateTransform( nAngle ) ;
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSGRAPHTRASLATETRANSFORM )
{
   Graphics * graphics = ( Graphics * ) hb_parptr( 1 );
   int nTop  =  hb_parni( 2 );
   int nLeft =  hb_parni( 3 );
   graphics->TranslateTransform( nTop, nLeft ) ;
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSGRAPHRESETTRANSFORM)
{
	Graphics * graphics = ( Graphics * ) hb_parptr( 1 );
   graphics->ResetTransform();
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSCREATEIMAGEFROMHBITMAP )
{
   Bitmap * original =  new Bitmap(  (HBITMAP) fw_parH( 1 ), (HPALETTE) fw_parH( 2 )  );
   if ( original->GetPixelFormat() == PixelFormat32bppRGB  ) // si es Alphabmp
   {
      Bitmap* newImage =  BitmapFromAlphaBmp( original ) ;
      hb_retptr( newImage );
   }
   else
   {
     hb_retptr( original );
    }
}

//----------------------------------------------------------------------------//

HB_FUNC( GDIP_EMFTOJPG )
{

  FILE * fil = fopen (  hb_parc(1) , "rb" ) ;
  fseek ( fil , 0 , SEEK_END ) ;
  int filesize = ftell ( fil ) ;

  fseek ( fil , 0 , SEEK_SET ) ;
  HGLOBAL hglobal = GlobalAlloc ( GMEM_MOVEABLE , filesize ) ;

  char * adr = (char *)GlobalLock ( hglobal ) ;
  int nbytes = fread ( adr , 1 , filesize , fil ) ;
  fclose ( fil ) ;

  if ( nbytes != filesize )
      {
       MessageBox( GetActiveWindow(), "fallo", "No carga la imagen", 0x30 );
      } ;

  LPSTREAM pstm = NULL ;
  GlobalUnlock ( hglobal ) ;

 CreateStreamOnHGlobal ( hglobal, TRUE, &pstm ) ;

 Metafile * original  = new Metafile( pstm ) ;

 LPWSTR filefin =   AnsiToWide( ( char * ) hb_parc( 2 ) );

 long quality  =  hb_parnl(3) ;
 double nDensity =  hb_parnl(4) ;

 int nWidth  =  original->GetWidth()  ;
 int nHeight =  original->GetHeight() ;

 CLSID  EncoderQuality ;

  double nAlto ;
  double nAncho ;

  if ( nWidth > nHeight )
     {
       nAlto  = ( 210 * nDensity ) / 25.4  ;
       nAncho = ( 297 * nDensity ) / 25.4  ;
     }
  else
     {
       nAncho =  ( 210 * nDensity) / 25.4  ;
       nAlto  =  ( 297 * nDensity ) / 25.4  ;
     }

  nHeight  = (int) nAlto ;
  nWidth   = (int) nAncho ;


  Bitmap * newImage = new Bitmap(nWidth, nHeight );
           newImage->SetResolution( nDensity, nDensity );

  Graphics * g =  new Graphics( newImage );
  g->Clear( Color::White ) ;
  g->SetSmoothingMode( SmoothingModeAntiAlias );

  g->DrawImage( original,0, 0, nWidth, nHeight);

  CLSIDFromString( L"{1D5BE4B5-FA4A-452D-9CDD-5DB35105E7EB}", &EncoderQuality ) ;
  EncoderParameters encoderParameters;

   encoderParameters.Count = 1;
   encoderParameters.Parameter[0].Guid = EncoderQuality ;
   encoderParameters.Parameter[0].Type = EncoderParameterValueTypeLong;
   encoderParameters.Parameter[0].NumberOfValues = 1;

  encoderParameters.Parameter[0].Value = &quality ;

  CLSID cClsid ;

  CLSIDFromString( L"{557CF401-1A04-11D3-9A73-0000F81EF32E}" , &cClsid ) ;

   newImage->Save( filefin , &cClsid, &encoderParameters );

  delete newImage ;
  delete g ;
  delete original ;
  pstm->Release();

}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSIMAGEFILETOCLIPBOARD )
{

   FILE * fil = fopen (  hb_parc(1) , "rb" ) ;
   fseek ( fil , 0 , SEEK_END ) ;
   int filesize = ftell ( fil ) ;

   fseek ( fil , 0 , SEEK_SET ) ;
   HGLOBAL hglobal = GlobalAlloc ( GMEM_MOVEABLE , filesize ) ;

   char * adr = (char *)GlobalLock ( hglobal ) ;
   int nbytes = fread ( adr , 1 , filesize , fil ) ;
   fclose ( fil ) ;

   if ( nbytes != filesize )
      {
       MessageBox( GetActiveWindow(), "fallo", "No carga la imagen", 0x30 );
      } ;

   LPSTREAM pstm = NULL ;
   GlobalUnlock ( hglobal ) ;

   CreateStreamOnHGlobal ( hglobal, TRUE, &pstm ) ;

   Bitmap *original = new  Bitmap( pstm,FALSE );

   Bitmap * result ;
   Graphics * graphics ;

   int nWidth  = original->GetWidth()  ;
   int nHeight = original->GetHeight() ;

   PixelFormat pf = original->GetPixelFormat();

   if ( pf == PixelFormat32bppRGB  )
      result = BitmapFromAlphaBmp( original ) ;
   else
    {

    if ( ( pf & PixelFormatIndexed ) != 0 )
     {
      if ( ( pf & PixelFormatAlpha ) != 0 )
         {
      pf = PixelFormat32bppPARGB ;
     // MessageBox( GetActiveWindow(), "alfa" ,"alfa", 0x30 );
     }
    else
     {
     //   MessageBox( GetActiveWindow(), "index" ,"index", 0x30 );
     pf= PixelFormat32bppRGB ;
     }
    }

   result  = new Bitmap( nWidth, nHeight, pf );

   graphics = new Graphics( result );
   graphics->DrawImage( original ,0, 0, nWidth, nHeight);

   delete graphics ;
   delete original ;

 }

   GlobalFree( hglobal );
   pstm->Release();

// hb_retptr( result );
//Gdiplus::Bitmap *gdibmp = Gdiplus::Bitmap::FromFile(L"c:\\test\\test.bmp");

  HBITMAP hbitmap;

  result->GetHBITMAP(0, &hbitmap);


  if ( OpenClipboard(  ( HWND ) fw_parH( 2 ) ) )
  {
    EmptyClipboard();

    DIBSECTION ds;
    GetObject(hbitmap, sizeof(DIBSECTION), &ds);

    //make sure compression is BI_RGB
    ds.dsBmih.biCompression = BI_RGB;

    //Convert DIB to DDB
    HDC hdc = GetDC(NULL);
    HBITMAP hbitmap_ddb = CreateDIBitmap(hdc, &ds.dsBmih, CBM_INIT,
            ds.dsBm.bmBits, (BITMAPINFO*)&ds.dsBmih, DIB_RGB_COLORS);
    ReleaseDC(NULL, hdc);

    SetClipboardData(CF_BITMAP, hbitmap_ddb);
    CloseClipboard();
    DeleteObject(hbitmap_ddb);

  }

}

//----------------------------------------------------------------------------//

HB_FUNC( GDIPLUSIMAGETOCLIPBOARD )
{

  Bitmap * newImage = ( Bitmap * ) hb_parptr( 1 );
  HBITMAP hbitmap;

  newImage->GetHBITMAP(0, &hbitmap);


if ( OpenClipboard(  ( HWND ) fw_parH( 2 ) ) )
   {
    EmptyClipboard();

    DIBSECTION ds;
    GetObject(hbitmap, sizeof(DIBSECTION), &ds);


    //make sure compression is BI_RGB
    ds.dsBmih.biCompression = BI_RGB;

    //Convert DIB to DDB
    HDC hdc = GetDC(NULL);
    HBITMAP hbitmap_ddb = CreateDIBitmap(hdc, &ds.dsBmih, CBM_INIT,
            ds.dsBm.bmBits, (BITMAPINFO*)&ds.dsBmih, DIB_RGB_COLORS);
    ReleaseDC(NULL, hdc);

    SetClipboardData(CF_BITMAP, hbitmap_ddb);
    CloseClipboard();
    DeleteObject(hbitmap_ddb);

   }

}

//----------------------------------------------------------------------------//


HB_FUNC( GDIPLUSHBITMAPTOCLIPBOARD )
{

if ( OpenClipboard(  ( HWND ) fw_parH( 2 ) ) )
{
    EmptyClipboard();

    DIBSECTION ds;
    GetObject( (HBITMAP) fw_parH( 1 ), sizeof(DIBSECTION), &ds);

    //make sure compression is BI_RGB
    ds.dsBmih.biCompression = BI_RGB;

    //Convert DIB to DDB
    HDC hdc = GetDC(NULL);
    HBITMAP hbitmap_ddb = CreateDIBitmap(hdc, &ds.dsBmih, CBM_INIT,
            ds.dsBm.bmBits, (BITMAPINFO*)&ds.dsBmih, DIB_RGB_COLORS);
    ReleaseDC(NULL, hdc);

    SetClipboardData(CF_BITMAP, hbitmap_ddb);
    CloseClipboard();
    DeleteObject(hbitmap_ddb);

}

}

//----------------------------------------------------------------------------//

HB_FUNC( GDIP_SETWRAPTEXTUREBRUSH )
{
   TextureBrush * Brush = ( TextureBrush * ) hb_parptr( 1 );
   int ntype = hb_parni( 2 )  ;

   if ( ntype == 0 )
        Brush->SetWrapMode( WrapModeTile ) ;
   if ( ntype == 1 )
        Brush->SetWrapMode( WrapModeTileFlipX ) ;
   if ( ntype == 2 )
        Brush->SetWrapMode( WrapModeTileFlipY ) ;
   if ( ntype == 3 )
        Brush->SetWrapMode( WrapModeTileFlipXY ) ;
   if ( ntype == 4 )
        Brush->SetWrapMode( WrapModeClamp ) ;

}

//----------------------------------------------------------------------------//



/*
HB_FUNC( GDIPLUSSAVEOCTREEGIF )
{

std::string str = hb_parc( 2 ) ;
std::wstring wstr (str.begin(), str.end());

 LPWSTR filefin = (LPWSTR) wstr.c_str();

 CLSID cClsid ;
 CLSIDFromString( L"{557CF402-1A04-11D3-9A73-0000F81EF32E}" , &cClsid ) ;

  Bitmap * original = ( Bitmap * ) hb_parnl( 1 );
 	Bitmap  *	m_pGif = CreateGif( original ) ;

  m_pGif->Save( filefin , &cClsid );	

  delete m_pGif ;
}
*/

//----------------------------------------------------------------------------//
/*
HB_FUNC( GDIPLUSIMAGELOADNEWFROMRESOURCES )
{

   void const *lpData ;
   DWORD dwSize    ;
   HGLOBAL hgImage;
   IStream *isImage  = NULL;

   HBITMAP hbmpImage;

   LPCTSTR pName = ( LPCTSTR ) hb_parc( 2 ) ;
   LPCTSTR pType = MAKEINTRESOURCE( hb_parni( 3 ) ) ;
   HMODULE hInst = ( HINSTANCE ) hb_parnl( 1 ) ;


   HRSRC hResource = FindResource( hInst, pName, pType );
   if (!hResource)  // no consigue encontrar el recurso
     hb_retptr( NULL );
   else
   {

    if ( hb_parni( 3 ) == 2 )   // para tipo 2
     {

      hbmpImage = (HBITMAP) LoadImage( hInst,  hb_parc( 2 ), IMAGE_BITMAP, 0, 0, LR_CREATEDIBSECTION );

      if ( HB_ISLOG( 4 ) && hb_parl( 4 ) )  // si queremos hbitmap
        hb_retnl( hbmpImage );
      else                                // si queremos puntero gdi+
      {
       if( hbmpImage == 0 )
         hb_retptr( NULL );     // si devuelve 0 devolvemos un puntero NULL
       else
       {
        Bitmap * original =  new Bitmap( hbmpImage, NULL  );

        if ( original->GetPixelFormat() ==  PixelFormat32bppRGB  )   // si es un AlphaBmp recuperamos la mascara
        {
          int nWidth  = original->GetWidth()  ;
          int nHeight = original->GetHeight() ;

          Rect rect(0, 0, nWidth, nHeight);

          BitmapData bmpData;

          original->LockBits(&rect, ImageLockModeRead, original->GetPixelFormat(), &bmpData );

          byte* imgPtr = (byte*)(bmpData.Scan0) ;

          int bheight = bmpData.Height;
          int bwidth  = bmpData.Width;
          int bstride = bmpData.Stride;

          Bitmap * newImage = new Bitmap( bwidth, bheight, bstride, PixelFormat32bppARGB, imgPtr );

          nWidth  = newImage->GetWidth()  ;
          nHeight = newImage->GetHeight() ;

          Bitmap* result  = new Bitmap( nWidth, nHeight, newImage->GetPixelFormat() );
          Graphics * graphics = new Graphics( result );
          graphics->DrawImage( newImage ,0, 0, nWidth, nHeight);

          original->UnlockBits( &bmpData ) ;

          delete original ;
          delete newImage ;
          delete graphics ;

          hb_retptr( result );
        }
        else                                      // si en Bmp con Fondo asignamos alpha al pix 0,0
        {
          Bitmap * newImage = BitmapSetPixtoAlpha( original, 0, 0 ) ;  // la funcion ya mata original
          hb_retptr( newImage );
        }
       }
      }
   }
   else    //  para el tipo 10 ( stream )
   {
    dwSize = SizeofResource(hInst, hResource);
    if (!dwSize) hb_retptr( NULL );      // si no consigue determinar el tamaño

    lpData = LockResource(  LoadResource (hInst, hResource ) );
    if (!lpData) hb_retptr( NULL );

    hgImage = GlobalAlloc( GMEM_ZEROINIT | GMEM_FIXED, dwSize);

    CopyMemory(GlobalLock(hgImage), lpData, dwSize );
    GlobalUnlock(hgImage);
    CreateStreamOnHGlobal(hgImage, FALSE, &isImage );

    Bitmap  *original = new  Bitmap( isImage ,FALSE );
    int nWidth  = original->GetWidth()  ;
    int nHeight = original->GetHeight() ;

    Bitmap *result ;

    if ( original->GetPixelFormat() ==  PixelFormat32bppRGB  )  // para imagenes con Alpha recupera la mascara
    {
       result = new Bitmap( nWidth, nHeight, PixelFormat32bppARGB );

       Rect rect(0, 0, nWidth, nHeight);

       BitmapData srcData;
       BitmapData resData;

       original->LockBits(&rect, ImageLockModeRead, original->GetPixelFormat(), &srcData);
       result->LockBits(&rect, ImageLockModeWrite, result->GetPixelFormat(), &resData);

       int* srcScan0 = (int*)srcData.Scan0;
       int* resScan0 = (int*)resData.Scan0;
       int numPixels = srcData.Stride / 4 * srcData.Height;

       for (int p = 0; p < numPixels; p++)
         {
            resScan0[p] = srcScan0[p];
         }

      original->UnlockBits( &srcData ) ;
      result->UnlockBits( &resData ) ;

      delete original ;

      isImage->Release();
      GlobalFree(hgImage);

    }
    else                                                 // si no tiene alpha lo genera desde el pixel 0,0
      result =  BitmapSetPixtoAlpha( original, 0, 0 ) ;


    if ( HB_ISLOG( 4 ) && hb_parl( 4 ) )
      {
         HBITMAP  hBitmap  = 0L;
         if ( result )
         {
            if ( result->GetHBITMAP( Color( 0,0,0 ), &hBitmap ) != 0 ) hBitmap = 0L;
             delete result;
         }
         hb_retnl( hBitmap );
      }
      else
       hb_retptr( result );
   }
 }
}
*/

HB_FUNC( GDIPLUSIMAGEFROMICO )
{
 HICON hIcon = ( HICON ) fw_parH( 1 ) ;

 ICONINFO ii ;
 GetIconInfo(hIcon, &ii);
 BITMAP bmp;
 //GetObject(ii.hbmColor, sizeof(bmp), &bmp);
 //GetObject(ii.hbmMask, sizeof(bmp), &bmp);

 //Bitmap * temp = new Bitmap(ii.hbmColor, NULL);
 Bitmap * temp = new Bitmap(ii.hbmMask, NULL);

 DeleteObject(ii.hbmColor);
 DeleteObject(ii.hbmMask);

 Bitmap* newImage =  BitmapFromAlphaBmp( temp ) ;

 hb_retptr( newImage );

}


#ifndef CAPTUREBLT
#define CAPTUREBLT 0x40000000
#endif


HB_FUNC( GDIPLUSCAPTURERECTWND )
{

   HWND hWnd = ( HWND ) fw_parH( 1 )  ;
   int nTop  = hb_parni( 2 );
   int nLeft = hb_parni( 3 );
   int nWidth  = hb_parni( 4 );
   int nHeight = hb_parni( 5 );

   HDC hWndDC = GetDC( hWnd );
   HDC hCaptureDC = CreateCompatibleDC( hWndDC );
   RECT rcClient;
   GetClientRect(hWnd, &rcClient);
   HBITMAP hCaptureBitmap = CreateCompatibleBitmap( hWndDC, rcClient.right-rcClient.left, rcClient.bottom-rcClient.top );

   SelectObject( hCaptureDC, hCaptureBitmap );
   BitBlt( hCaptureDC, 0, 0, rcClient.right-rcClient.left, rcClient.bottom-rcClient.top,
           hWndDC,0, 0, SRCCOPY | CAPTUREBLT );

   Bitmap * original =  new Bitmap( hCaptureBitmap, NULL );

   ReleaseDC( hWnd, hWndDC );
   DeleteDC( hCaptureDC );
   DeleteObject( hCaptureBitmap );

   Bitmap* newImage  = new Bitmap( nWidth, nHeight);

   Graphics * graphics = new Graphics( newImage );

   Rect destino ( 0 , 0 , nWidth, nHeight );
   graphics->DrawImage( original, destino , nTop , nLeft , nWidth, nHeight, UnitPixel );

   delete graphics ;
   delete original ;

   hb_retnl( ( HB_LONG ) newImage );

}

//----------------------------------------------------------------------------//

//#pragma warning( default : 4068 )
