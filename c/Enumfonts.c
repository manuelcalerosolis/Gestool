#include <windows.h>

#define S_BLOCK 0x1000
#define CLIPPER void pascal

/*
 * Tipos de datos.
 */
typedef void * ITEM;
typedef unsigned char BYTE;
typedef unsigned short USHORT;
typedef unsigned long ULONG;
typedef signed long LONG;
typedef double XDOUBLE;
typedef USHORT ERRCODE;

/*
 * Variables públicas.
 */
extern ITEM _tos;
extern ITEM _eval;

/*
 * Declaración de funciones.
 */
extern void _putc( char * );
extern ERRCODE _xpopm( ITEM );
extern ITEM _param( USHORT, USHORT );
extern ERRCODE _cEval1( ITEM, ITEM );
extern void * _xgrab( ULONG );
extern void _xfree( void * );
extern BYTE * __pascal _ARRAYNEW( ULONG );
extern USHORT _cAtPutStr( ITEM, ULONG, BYTE *, ULONG );

/*
 * Función que procesa las fuentes.
 */
static int CALLBACK EnumFontProc( const LOGFONT * pLogFont, const TEXTMETRIC * pTextMetric,
                                  ULONG ulFontType, LPARAM lParam )
{
   ( void ) pTextMetric;
   ( void ) ulFontType;
   _putc( ( char * ) pLogFont->lfFaceName );
   _cEval1( ( ITEM ) lParam, _tos );
   _xpopm( _tos );

   return 1;
}

/*
 * Enumera las fuentes del sistema.
 */
CLIPPER ENUMFONTS( void )
{
   HDC hDC;
   ITEM pItem;

   pItem = _param( 1, S_BLOCK );

   if( pItem != NULL )
   {
      hDC = GetDC( NULL );
      EnumFontFamilies( hDC, NULL, ( FONTENUMPROC ) EnumFontProc, ( LPARAM ) pItem );
      ReleaseDC( NULL, hDC );
   }
}
