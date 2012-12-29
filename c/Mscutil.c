//---------------------------------------------------------------------------//
//  AUTOR.....: Manuel Expósito Suárez   Soft4U 2002-2007                    //
//  eMail.....: manuexposito@gmail.com                                       //
//  CLASE.....: MSUtilC                                                      //
//  FECHA MOD.: 27/04/2007                                                   //
//  VERSION...: 1.00                                                         //
//  PROPOSITO.: Funciones de apoyo en C                                      //
//---------------------------------------------------------------------------//

#include "eagle1.h"

#define _CL_LEN_DATE     8
#define _MY_LEN_DATE    10

//---------------------------------------------------------------------------//
// Devuelve una fecha al estilo de MySQL con esta forma: "AAAA-MM-DD"

HB_FUNC( E1SQLDATE )
{
    char *szDate = _pards( 1 );

    if( strncmp( szDate, "        ", _CL_LEN_DATE ) )
    {
        char pValue[ _MY_LEN_DATE ];

        *pValue = *szDate;
        *( pValue + 1 ) = *( szDate + 1 );
        *( pValue + 2 ) = *( szDate + 2 );
        *( pValue + 3 ) = *( szDate + 3 );
        *( pValue + 4 ) = '-';
        *( pValue + 5 ) = *( szDate + 4 );
        *( pValue + 6 ) = *( szDate + 5 );
        *( pValue + 7 ) = '-';
        *( pValue + 8 ) = *( szDate + 6 );
        *( pValue + 9 ) = *( szDate + 7 );

        _retclen( pValue, _MY_LEN_DATE );
    }
    else
    {
        _retclen( "0000-00-00", _MY_LEN_DATE );
    }
}

//---------------------------------------------------------------------------//
// Saca un mensage en PRG

HB_FUNC( MYMSG )
{
   MessageBox( NULL, _parc( 1 ), "Atencin",
                         MB_OK | MB_ICONINFORMATION | MB_SYSTEMMODAL );
}

//---------------------------------------------------------------------------//
// Saca un mensage en PRG

HB_FUNC( MYMSGINFO )
{
   MessageBox( NULL, _parc( 1 ),
                         ISNIL( 2 ) ? "Atencin" : _parc( 2 ),
                         MB_OK | MB_ICONINFORMATION | MB_SYSTEMMODAL );
}

//---------------------------------------------------------------------------//
// Saca un mensaje en PRG y espera respuesta

HB_FUNC( MYMSGYESNO )
{
   _retl( MessageBox( NULL, _parc( 1 ), ISNIL( 2 ) ? "Conteste" : _parc( 2 ),
                    MB_YESNO | MB_ICONQUESTION | MB_SYSTEMMODAL ) == IDYES );
}

//----------------------------------------------------------------------------//
// Saca un mensage de error en PRG

HB_FUNC( MYMSGERROR )
{
   MessageBox( NULL, _parc( 1 ), ISNIL( 2 ) ? "Atencin" : _parc( 2 ),
                       MB_OK | MB_ICONERROR | MB_SYSTEMMODAL );
}

//----------------------------------------------------------------------------//
