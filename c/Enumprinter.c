#include <windows.h>

#define S_BLOCK 0x1000
#define CLIPPER void pascal

/*
 * BOOL GetDefaultPrinterA( LPTSTR pszBuffer, LPDWORD pcchBuffer );
 */

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
 * Variables p�blicas.
 */
extern ITEM _tos;
extern ITEM _eval;

/*
 * Declaraci�n de funciones.
 */
extern void _putc( char * );
extern ERRCODE _xpopm( ITEM );
extern ITEM _param( USHORT, USHORT );
extern ERRCODE _cEval1( ITEM, ITEM );
extern void * _xgrab( ULONG );
extern void _xfree( void * );
extern BYTE * __pascal _ARRAYNEW( ULONG );
extern USHORT _cAtPutStr( ITEM, ULONG, BYTE *, ULONG );
extern void _retc( char * );

/*
 * Enumera las impresoras del sistema.
 */
CLIPPER ENUMPRINTERS( void )
{
   ULONG ulNeeded;
   ULONG ulPrinters;
   ULONG ulCount;
   DWORD dwFlags;
   DWORD dwLevel;
   BYTE * pBuffer;
   BYTE * pPrinterInfo;
   OSVERSIONINFO stOsVersionInfo;

   stOsVersionInfo.dwOSVersionInfoSize = sizeof( OSVERSIONINFO );
   GetVersionEx( &stOsVersionInfo );

   /* Si es un sistema de 32 bits nativo. */
   if( stOsVersionInfo.dwPlatformId == VER_PLATFORM_WIN32_NT )
   {
      dwFlags = PRINTER_ENUM_LOCAL | PRINTER_ENUM_CONNECTIONS;
      dwLevel = 4;
   }
   else
   {
      dwFlags = PRINTER_ENUM_LOCAL;
      dwLevel = 5;
   }

   /* Obtenemos el n�mero de bytes necesarios. */
   EnumPrinters( dwFlags, NULL, dwLevel, NULL, 0, &ulNeeded, &ulPrinters );

   if( ulNeeded > 0 )
   {
      /* Memoria en un buffer gen�rico, luego casteamos a PRINTER_INFO_4 o PRINTER_INFO_5. */
      pBuffer = ( BYTE * ) _xgrab( ulNeeded );

      if( EnumPrinters( dwFlags, NULL, dwLevel, pBuffer, ulNeeded, &ulNeeded, &ulPrinters ) )
      {
         /* Creamos el array y lo dejamos en _eval. */
         _ARRAYNEW( ulPrinters );
         pPrinterInfo = pBuffer;

         for( ulCount = 1; ulCount <= ulPrinters; ulCount++ )
         {
            /* Sistema de 32 bits nativo. */
            if( dwLevel == 4 )
            {
               _cAtPutStr( _eval, ulCount, ( BYTE * ) ( ( PRINTER_INFO_4 * ) pPrinterInfo )->pPrinterName,
                           lstrlen( ( ( PRINTER_INFO_4 * ) pPrinterInfo )->pPrinterName ) );
               pPrinterInfo += sizeof( PRINTER_INFO_4 );
            }
            else
            {
               _cAtPutStr( _eval, ulCount, ( BYTE * ) ( ( PRINTER_INFO_5 * ) pPrinterInfo )->pPrinterName,
                           lstrlen( ( ( PRINTER_INFO_5 * ) pPrinterInfo )->pPrinterName ) );
               pPrinterInfo += sizeof( PRINTER_INFO_5 );
            }
         }
      }

      _xfree( pBuffer );
   }
}

#define MAXBUFFERSIZE 255    // 7/10/2003 12:51p.m.