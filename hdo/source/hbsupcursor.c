/*
 * Proyecto: hdo
 * Fichero: hbsupcursor.c
 * Descripción:
 * Autor:
 * Fecha: 12/11/2015
 */

#include "localcurapi.h"

static PCURSUPER cur_getMethods( void );

static void     init( PLOCALCURSOR lc, PHB_ITEM pCursor );
static PHB_ITEM getCursor( PLOCALCURSOR lc );
static PHB_ITEM setCursor( PLOCALCURSOR lc, PHB_ITEM pCur );
static HB_ULONG recCount( PLOCALCURSOR lc );
static HB_ULONG recNo( PLOCALCURSOR lc );
static void     goTo( PLOCALCURSOR lc, HB_ULONG ulRecNo );
static void     goTop( PLOCALCURSOR lc );
static void     goBottom( PLOCALCURSOR lc );
static void     skip( PLOCALCURSOR lc, HB_LONG lSkip );
static HB_LONG  skipper( PLOCALCURSOR lc, HB_LONG lSkip );
static void     next( PLOCALCURSOR lc );
static void     prior( PLOCALCURSOR lc );
static HB_BOOL  eof( PLOCALCURSOR lc );
static HB_BOOL  bof( PLOCALCURSOR lc );

/*
Estos metodos se implementan en cada clase:
--------------------------------------------------------------------------------
static HB_UINT  fieldCount( PLOCALCURSOR lc, PHB_ITEM pName );
static PHB_ITEM fieldGet( PLOCALCURSOR lc, PHB_ITEM pName );
static PHB_ITEM valueByName( PLOCALCURSOR lc, char *szName );
static PHB_ITEM getValueByPos( PLOCALCURSOR lc, HB_USHORT uiPos );
static HB_ULONG fieldName( PLOCALCURSOR lc, HB_USHORT uiPos );
static HB_ULONG fieldLen( PLOCALCURSOR lc, PHB_ITEM pName );
static HB_ULONG fieldType( PLOCALCURSOR lc, PHB_ITEM pName );
static HB_ULONG fieldPos( PLOCALCURSOR lc, char *szName );
static PHB_ITEM find( PLOCALCURSOR lc, PHB_ITEM pValue, PHB_ITEM pCol );
static PHB_ITEM asArray( PLOCALCURSOR lc );
static void     free( PLOCALCURSOR lc );
*/

/***
 * Reserva memoria para la estructura y la inicailiza
 * Devuelve la estructura o NULL si no lo consigue
 */

PLOCALCURSOR CURInit( void )
{
	PLOCALCURSOR lc = ( PLOCALCURSOR ) HDO_ALLOC( sizeof( LOCALCURSOR ) );

	if( lc )
	{
		lc->pCursor = hb_itemNew( NULL );
		lc->pMethods = cur_getMethods();
		lc->ulRecNo = 0;
		lc->ulRowCount = 0;
		lc->fBof = HB_TRUE;
		lc->fEof = HB_TRUE;
	}

	return lc;
}

/***
 * Metodo:
 * Uso:
 * Parametros:
 * Devuelve:
 */

static PCURSUPER cur_getMethods( void )
{
	static CURSUPER cur_Methods =
	{
		init,
		getCursor,
		setCursor,
		recCount,
		recNo,
		goTo,
		goTop,
		goBottom,
		skip,
		skipper,
		next,
		prior,
		eof,
		bof
		/*,
			// Se definen en las clases hijas:
		    fieldCount,
		    fieldGet,
		    valueByName,
		    getValueByPos,
		    fieldName,
		    fieldLen,
		    fieldType,
		    fieldPos,
		    find,
		    asArray,
		    free
		*/
	};

	return &cur_Methods;
}

/***
 * Metodo:
 * Uso:
 * Parametros:
 * Devuelve:
 */

static void init( PLOCALCURSOR lc, PHB_ITEM pCursor )
{
	if( HB_IS_ARRAY( pCursor ) )
	{
		hb_itemMove( lc->pCursor, pCursor );
	}
	else
	{
		hb_arrayNew( lc->pCursor, 0 );
	}

	lc->ulRowCount = hb_arrayLen( lc->pCursor );

	CUR_GOTOP( lc );
}

/***
 * Metodo:
 * Uso:
 * Parametros:
 * Devuelve:
 */

static PHB_ITEM getCursor( PLOCALCURSOR lc )
{
	return lc->pCursor;
}

/***
 * Metodo:
 * Uso:
 * Parametros:
 * Devuelve:
 */

static PHB_ITEM setCursor( PLOCALCURSOR lc, PHB_ITEM paNew )
{
	PHB_ITEM pOldCursor = CUR_GETCURSOR( lc );

	if( paNew )
	{
		hb_itemMove( CUR_GETCURSOR( lc ),  paNew );
	}

	lc->ulRowCount = hb_arrayLen( lc->pCursor );

	CUR_GOTOP( lc );

	return pOldCursor;
}

/***
 * Metodo:
 * Uso:
 * Parametros:
 * Devuelve:
 */

static HB_ULONG recCount( PLOCALCURSOR lc )
{
	return lc->ulRowCount;
}

/***
 * Metodo:
 * Uso:
 * Parametros:
 * Devuelve:
 */

static HB_ULONG recNo( PLOCALCURSOR lc )
{
	return lc->ulRecNo;
}

/***
 * Metodo:
 * Uso:
 * Parametros:
 * Devuelve:
 */

static void goTo( PLOCALCURSOR lc, HB_ULONG ulRecNo )
{
	if( lc->ulRowCount > 0 )
	{
		lc->fBof = lc->fEof = HB_FALSE;

		if( ( HB_LONG ) ulRecNo < 1 )
		{
			lc->ulRecNo = 1;
		}
		else
		{
			lc->ulRecNo = ( ulRecNo <= lc->ulRowCount ) ? ulRecNo : lc->ulRowCount;
		}
	}
	else
	{
		lc->fBof = lc->fEof = HB_TRUE;
		lc->ulRecNo = 0;
	}
}

/***
 * Metodo:
 * Uso:
 * Parametros:
 * Devuelve:
 */

static void goTop( PLOCALCURSOR lc )
{
	CUR_GOTO( lc, 1 );
}

/***
 * Metodo:
 * Uso:
 * Parametros:
 * Devuelve:
 */

static void goBottom( PLOCALCURSOR lc )
{
	CUR_GOTO( lc, recCount( lc ) );
}

/***
 * Metodo: skip
 * Uso: Mueve el cursor en saltos absolutos
 * Parametros: PLOCALCURSOR lc, HB_LONG lSkip
 * Devuelve: void
 */

static void skip( PLOCALCURSOR lc, HB_LONG lSkip )
{
	lc->ulRecNo += lSkip;

	if( RCHK( lc->ulRecNo, lc->ulRowCount ) )
	{
		lc->fBof = lc->fEof = HB_FALSE;
	}
	else
	{
		if( ( HB_LONG ) lc->ulRowCount > 0 )
		{
			if( lc->ulRecNo > lc->ulRowCount )
			{
				lc->ulRecNo = lc->ulRowCount;
				lc->fBof = HB_FALSE;
				lc->fEof = HB_TRUE;
			}
			else
			{
				lc->ulRecNo = 1;
				lc->fBof = HB_TRUE;
				lc->fEof = HB_FALSE;
			}
		}
		else
		{
			lc->ulRecNo = lc->ulRowCount;
			lc->fBof = lc->fEof = HB_TRUE;
		}
	}
}

/***
 * Metodo: skipper
 * Uso: Mueve el cursor y de vuelve el numero de registros saltados
 * Parametros:  PLOCALCURSOR lc, HB_LONG lSkip
 * Devuelve: El numero de registros saltados
 */

static HB_LONG skipper( PLOCALCURSOR lc, HB_LONG lSkip )
{
	HB_LONG lSkipped = HB_MIN( HB_MAX( lSkip, 1 - ( HB_LONG ) lc->ulRecNo ),
							   ( HB_LONG ) lc->ulRowCount - ( HB_LONG ) lc->ulRecNo );

	lc->ulRecNo = lc->ulRecNo + lSkipped;

	return lSkipped;
}

/***
 * Metodo: next
 * Uso: Mueve el cursor a la siguiente tupla
 * Parametros: PLOCALCURSOR lc
 * Devuelve: void
 */

static void next( PLOCALCURSOR lc )
{
	++lc->ulRecNo;

	if( lc->ulRecNo <= lc->ulRowCount )
	{
		lc->fBof = lc->fEof = HB_FALSE;
	}
	else
	{
		lc->ulRecNo = lc->ulRowCount;
		lc->fBof = ( lc->ulRowCount == 0 );
		lc->fEof = HB_TRUE;
	}
}

/***
 * Metodo: prior
 * Uso: Mueve el cursor a la tupla anterior
 * Parametros: PLOCALCURSOR lc
 * Devuelve: void
 */

static void prior( PLOCALCURSOR lc )
{
	if( lc->ulRowCount > 0 )
	{
		--lc->ulRecNo;

		if( lc->ulRecNo > 0 )
		{
			lc->fBof = lc->fEof = HB_FALSE;
		}
		else
		{
			lc->ulRecNo = 1;
			lc->fBof = HB_TRUE;
		}
	}
	else
	{
		lc->ulRecNo = 0;
		lc->fBof = lc->fEof = HB_TRUE;
	}
}

/***
 * Metodo:
 * Uso:
 * Parametros:
 * Devuelve:
 */

static HB_BOOL eof( PLOCALCURSOR lc )
{
	return lc->fEof;
}

/***
 * Metodo:
 * Uso:
 * Parametros:
 * Devuelve:
 */

static HB_BOOL bof( PLOCALCURSOR lc )
{
	return lc->fBof;
}

