#include <Windows.h>
#include "Clipapi.h"
#include "Item.api"

#define S_ANY               0xFFFF
#define S_ARRAY             0x8000

#define UNDEF        0
#define CHARACTER    1
#define NUMERIC      2
#define LOGICAL      4
#define DATE         8
#define ALIAS       16
#define MPTR        32      /* or'ed with type when passed by reference */
#define MEMO        64
#define ARRAY      512
#define BLOCK     1024
#define DOUBLE    2048

#define CLIPPER void pascal

extern short _parinfo( short );
extern ULONG _parinfa( short, USHORT );
extern char * _parc( short, ... );
extern ULONG _parcsiz( short, ... );
extern ULONG _parclen( short, ... );
extern short _parni( short, ... );
extern LONG  _parnl( short, ... );
extern double _parnd( short, ... );
extern short _parl( short, ... );
extern char * _pards( short, ... );
extern void _retc( char * );
extern void _retclen( char *, ULONG );
extern void _retni( short );
extern void _retnl( LONG );
extern void _retnd( double );
extern void _retl( short );
extern void _retds( char * );
extern void _ret( void );
extern short _storc( char *, short, ... );
extern short _storclen( char *, ULONG, short, ... );
extern short _storni( short, short, ... );
extern short _stornl( LONG, short, ... );
extern short _stornd( double, short, ... );
extern short _storl( short, short, ... );
extern short _stords( char *, short, ... );


//---------------------------------------------------------------------------//

CLIPPER SCANCHAR( void )
{
    char * szText;
    char * szPos;
    char cChar;
    unsigned long ulPos;

    szText = _parc( 1 );
    cChar = * _parc( 2 );
    szPos = szText;
    ulPos = 1;

    while ( * szPos != NULL )
    {
        if( * szPos == cChar )
        {
            _retnl( ulPos );
            return;
        }
        ulPos++;
        szPos++;
    }

    _retnl( 0 );

}

//---------------------------------------------------------------------------//

CLIPPER CODIGOC( void )
{
    CLIPSYMBOL *pSymbol;

    pSymbol = _get_sym( "MSGINFO" );

    if( pSymbol == NULL )
            return;

    _putsym( pSymbol );
    _put();
    _putc( "HOLA MUNDO DESDE C" );
    _xdo( 1 );

}

//---------------------------------------------------------------------------//

CLIPPER MESSAGEBEEP( void )
{
    MessageBeep( _parnl( 1 ) );
}

CLIPPER MESSAGEBOX( void )
{
    MessageBox( 0, _parc( 1 ), _parc( 2 ), MB_ABORTRETRYIGNORE | MB_ICONASTERISK );

}

CLIPPER MYCGETFILE32( void )
{
    char szFile[256];
    BOOL bMultiselect;
    OPENFILENAME stOf;                                      // Definicion de la estuctura

    szFile[0] = NULL;

    bMultiselect = ( PCOUNT() > 0 ? _parl( 1 ) : 1 );

    _bset( ( char * ) &stOf, 0, sizeof( OPENFILENAME ) );   // Esto se usa para limpiar la estructura
    stOf.lStructSize = sizeof( OPENFILENAME );              // Vamos rellenando la estructura con el tamaño
    stOf.lpstrFile = szFile;
    stOf.nMaxFile = 256;
    stOf.Flags = ( bMultiselect ? OFN_ALLOWMULTISELECT : 0 ) | OFN_EXPLORER | OFN_SHOWHELP;
    stOf.lpstrFilter = "Ficheros dbase\0*.prg;*.c;*.h;*.api\0";

    if( GetOpenFileName( &stOf ) );
    {
         _retc( stOf.lpstrFile );
    }

}

//---------------------------------------------------------------------------//
/*
CLIPPER ISAPPTHEMED( void )
{
    HINSTANCE hDll;
    BOOL CALLBACK ( * pFunction )( void );

    hDll = LoadLibrary( "uxtheme.dll" );
    if ( hDll != NULL )
    {
        pFunction = GetProcAddress( hDll, "IsThemeActive" );
        if ( pFunction != NULL )
        {
            _retl( pFunction() );
            FreeLibrary( hDll );
            return;
        }
    }
    FreeLibrary( hDll );
    _retl( FALSE );

}
*/
//---------------------------------------------------------------------------//

CLIPPER FREELIBRARY( void )
{
    _retl( ( short ) ( FreeLibrary( ( HINSTANCE ) _parnl( 1 ) ) ) );
}

//---------------------------------------------------------------------------//

CLIPPER TIPOC( void )
{
    _retnl( _itemType( _param( 1, S_ANY ) ) );
}

//---------------------------------------------------------------------------//

































































































