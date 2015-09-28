#ifndef __FWCE
#define __FWCE

LPWSTR AnsiToWide( LPSTR );
LPSTR  WideToAnsi( LPWSTR );

#ifndef UNDER_CE
   #define GlobalAlloc LocalAlloc
   #define GlobalUnlock LocalUnlock
   #define GlobalFree LocalFree
   #define GlobalLock LocalLock
   #define GlobalSize LocalSize
#endif

UINT GlobalGetAtomName( ATOM nAtom,	// atom identifier 
                        LPTSTR lpBuffer,	// pointer to the buffer for the atom string  
                        int nSize 	// size of the buffer 
                      );

HBITMAP CreateBitmapIndirect( CONST BITMAP *lpbm );	// pointer to the bitmap data 

/* constants for CreateDIBitmap */
#define CBM_INIT        0x04L   /* initialize bitmap */

HBITMAP CreateDIBitmap(
    HDC hdc,	// handle to device context 
    CONST BITMAPINFOHEADER *lpbmih,	// pointer to bitmap size and format data 
    DWORD fdwInit,	// initialization flag 
    CONST VOID *lpbInit,	// pointer to initialization data 
    CONST BITMAPINFO *lpbmi,	// pointer to bitmap color-format data 
    UINT fuUsage 	// color-data usage 
   );

HBRUSH CreateHatchBrush(
    int fnStyle,	// hatch style  
    COLORREF clrref 	// color value  
   );
   
HFILE _lclose(
    HFILE hFile 	// handle to file to close  
   );

HFILE _lopen( LPCSTR lpPathName,	// pointer to name of file to open  
              int iReadWrite 	// file access mode 
            );
      
LONG _llseek( HFILE hFile,	// handle to file 
              LONG lOffset,	// number of bytes to move  
              int iOrigin 	// position to move from 
            );            

UINT _lread(
    HFILE hFile,	// handle to file 
    LPVOID lpBuffer,	// pointer to buffer for read data 
    UINT uBytes 	// length, in bytes, of data buffer 
   );
   
long _hread(
    HFILE hFile,	// handle to file 
    LPVOID lpBuffer,	// pointer to buffer for read data 
    long lBytes 	// length, in bytes, of data buffer 
   );   
   
// #define GlobalReAlloc LocalReAlloc   
   
#endif
