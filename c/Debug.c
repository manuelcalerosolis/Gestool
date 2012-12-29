//---------------------------------------------------------------------------//
//  AUTOR.....: Manuel Expósito Suárez   Soft4U 2002-2007                    //
//  eMail.....: manuexposito@gmail.com                                       //
//  CLASE.....: Debug                                                        //
//  FECHA MOD.: 09/12/2007                                                   //
//  VERSION...: 1.00                                                         //
//  PROPOSITO.: Funciones utiles para 'debugear' solo para SO Windows        //
//---------------------------------------------------------------------------//

//---------------------------------------------------------------------------//
// Para windows

#if defined( HB_OS_WIN_32_USED )

#include  <windows.h>

#define _CLIPDEFS_H     // Para evitar las redefiniciones en windows

#include "extend.h"

//---------------------------------------------------------------------------//
// Saca un mensaje de una cadena en C

void DimeC( char *cText )
{
    MessageBox( NULL, cText, "Depuracin", MB_ICONINFORMATION|MB_SYSTEMMODAL );
}

//---------------------------------------------------------------------------//
// Saca un mensaje de un numero en C

void DimeN( LONG Num )
{
    char szBuffer[ 80 ];
    wsprintf( szBuffer, "%ld", Num );

    DimeC( szBuffer );
}

//---------------------------------------------------------------------------//
// Saca mensajes en un depurador

HB_FUNC( DOUT )
{
   OutputDebugString( (LPCSTR) _parc( 1 ) );
}

//---------------------------------------------------------------------------//

void OutStr( LPCSTR szTxt )
{
    OutputDebugString( szTxt );
}

//---------------------------------------------------------------------------//

void OutNum( LONG lNum )
{
    char szBuffer[ 80 ];

    wsprintf( szBuffer, "%ld", lNum );

    OutputDebugString( szBuffer );
}

//----------------------------------------------------------------------------//

#endif

//---------------------------------------------------------------------------//

