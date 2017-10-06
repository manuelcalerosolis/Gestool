/*
 * Proyecto: Harbour Data Objects (HDO)
 * Fichero: dbg.c
 * Descripción:
 * Autor: Manu Exposito 2015-17
 * Fecha: 15/08/2016
 * Notas: Funciones utiles para 'debugear' solo para SO Windows
 */

//----------------------------------------------------------------------------//

#include "dbg.h"

#define FILE_LOG "HDO.LOG"  // Nombre log file

//----------------------------------------------------------------------------//
// Log manager desde C
// IMPORTANTE: el ultimo argumento tiene que ser NULL
// Ejemplo:
// writeLog( "Prueba ", "de ", "LOGMANAGER", NULL );

void writeLog( const char *zStr, ... )
{
	if( zStr )
	{
		HB_FHANDLE hFic = hb_fsOpen( FILE_LOG, 2 );

		if( hFic < 1 )
		{
			hFic = hb_fsCreate( FILE_LOG, 0 );
		}

		if( hFic > 0 && zStr )
		{
			static const char szCRLF[ 2 ] = { HB_CHAR_CR, HB_CHAR_LF };
			va_list ap;

			va_start( ap, zStr );

			hb_fsSeek( hFic, 0, 2 );

			do
			{
				hb_fsWriteLarge( hFic, zStr, strlen( zStr ) );
			}
			while( ( zStr = va_arg( ap, char * ) ) != NULL );

			va_end( ap );

			hb_fsWrite( hFic, szCRLF, 2 );
			hb_fsClose( hFic );
		}
	}
}

void outLog( const char *zStr, HB_BOOL iCrLf )
{
	if( zStr )
	{
		HB_FHANDLE hFic = hb_fsOpen( FILE_LOG, 2 );

		if( hFic < 1 )
		{
			hFic = hb_fsCreate( FILE_LOG, 0 );
		}

		if( hFic > 0 )
		{
			hb_fsSeek( hFic, 0, 2 );
			hb_fsWriteLarge( hFic, zStr, strlen( zStr ) );

			if( iCrLf )
			{
				static const char szCRLF[ 2 ] = { HB_CHAR_CR, HB_CHAR_LF };

				hb_fsWrite( hFic, szCRLF, 2 );
			}

			hb_fsClose( hFic );
		}
	}
}

// Log manager desde PRG

HB_FUNC( OUTLOG )
{
	outLog( hb_parc( 1 ), hb_parl( 2 ) );
}

/////////////////// SOLO PARA OS WINDOWS ///////////////////////////////////////

#if defined( HB_OS_WIN )

//----------------------------------------------------------------------------//

void OutStr( char *szTxt )
{
	OutputDebugString( szTxt );
}

//----------------------------------------------------------------------------//

void OutNum( HB_LONG lNum )
{
	char szBuffer[ 80 ];

	hb_snprintf( szBuffer, 80, "%ld", lNum );

	OutputDebugString( szBuffer );
}

//---------------------------------------------------------------------------//
// Saca mensajes en un depurador

HB_FUNC( DBGOUT )
{
	PHB_ITEM pItem = hb_param( 1, HB_IT_ANY );

	if( pItem )
	{
		HB_SIZE uiLen;
		HB_BOOL bFreeReq;
		char *buffer = hb_itemString( pItem, &uiLen, &bFreeReq );

		OutputDebugString( buffer );

		if( bFreeReq )
		{
			hb_xfree( buffer );
		}
	}
}

#else

HB_INT MessageBox( HB_LONG hWnd, const char *szMsg, const char *szCaption, HB_UINT uType )
{
	static PHB_DYNS s_pSymMsg;

	HB_SYMBOL_UNUSED( hWnd );
	HB_SYMBOL_UNUSED( uType );

	if( !s_pSymMsg )
	{
		s_pSymMsg = hb_dynsymFind( "MSG" );
	}

	if( szMsg )
	{
		if( s_pSymMsg )
		{
			hb_vmPushDynSym( s_pSymMsg );
			hb_vmPushNil();
			hb_vmPushString( szMsg, strlen( szMsg ) );

			if( szCaption )
			{
				hb_vmPushString( szCaption, strlen( szCaption ) );
				hb_vmProc( 2 );
			}
			else
			{
				hb_vmProc( 1 );
			}
		}
	}

	return 0;
}

#endif

//----------------------------------------------------------------------------//
// Saca un mensaje de una cadena en C

void DimeC( const char *cText )
{
	MessageBox( 0, cText, "Depuracion", MB_ICONINFORMATION | MB_SYSTEMMODAL );
}

//---------------------------------------------------------------------------//
// Saca un mensaje de un numero en C

void DimeN( HB_LONG lNum )
{
	char szBuffer[ 80 ];

	hb_snprintf( szBuffer, 80, "%ld", lNum );
	
	DimeC( szBuffer );
}

//---------------------------------------------------------------------------//
// Saca un mensage en PRG

HB_FUNC( MYMSG )
{
	MessageBox( 0, hb_parc( 1 ), "Atencion",
				MB_OK | MB_ICONINFORMATION | MB_SYSTEMMODAL );
}

//---------------------------------------------------------------------------//
// Saca un mensage en PRG

HB_FUNC( MYMSGINFO )
{
	MessageBox( 0, hb_parc( 1 ),
				HB_ISNIL( 2 ) ? "Atencion" : hb_parc( 2 ),
				MB_OK | MB_ICONINFORMATION | MB_SYSTEMMODAL );
}

//---------------------------------------------------------------------------//
// Saca un mensaje en PRG y espera respuesta

HB_FUNC( MYMSGYESNO )
{
	hb_retl( MessageBox( 0, hb_parc( 1 ), HB_ISNIL( 2 ) ? "Conteste" : hb_parc( 2 ),
						 MB_YESNO | MB_ICONQUESTION | MB_SYSTEMMODAL ) == IDYES );
}

//----------------------------------------------------------------------------//
// Saca un mensage de error en PRG

HB_FUNC( MYMSGERROR )
{
	MessageBox( 0, hb_parc( 1 ), HB_ISNIL( 2 ) ? "Atencion" : hb_parc( 2 ),
				MB_OK | MB_ICONERROR | MB_SYSTEMMODAL );
}

//----------------------------------------------------------------------------//

