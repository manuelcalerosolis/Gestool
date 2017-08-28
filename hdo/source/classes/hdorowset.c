/*
 * Proyecto: Harbour Data Objects (HDO)
 * Fichero: hdorowset.c
 * Descripci󮺍: Gestion de conjunto de registros
 * Autor: Manu Exposito 2015-17
 * Fecha: 15/01/2017
 */

/* Ficheros include */

#include "hdorowset.h"

/* Definicion de la clase con atributos y metodos */

CREATE_CLASS( "TROWSET", TROWSET, TRS_IVARCOUNT )
{
	METHOD( "NEW",          	TROWSET_NEW )
	METHOD( "REFRESH",      	TROWSET_REFRESH )
	METHOD( "RELOAD",			TROWSET_RELOAD )
	METHOD( "FREE",         	TROWSET_FREE )
	METHOD( "RECNO",        	TROWSET_RECNO )
	METHOD( "RECCOUNT",     	TROWSET_RECCOUNT )
	METHOD( "GOTO",         	TROWSET_GOTO )
	METHOD( "GOTOP",        	TROWSET_GOTOP )
	METHOD( "FIRST",        	TROWSET_GOTOP )
	METHOD( "GOBOTTOM",     	TROWSET_GOBOTTOM )
	METHOD( "LAST",     		TROWSET_GOBOTTOM )
	METHOD( "SKIP",         	TROWSET_SKIP )
	METHOD( "NEXT",         	TROWSET_NEXT )
	METHOD( "PRIOR",         	TROWSET_PRIOR )
	METHOD( "SKIPPER",      	TROWSET_SKIPPER )
	METHOD( "EOF",          	TROWSET_EOF )
	METHOD( "BOF",          	TROWSET_BOF )
	METHOD( "FIELDCOUNT",   	TROWSET_FIELDCOUNT )
	METHOD( "COLUMNCOUNT",  	TROWSET_FIELDCOUNT )
	METHOD( "FIELDNAME",    	TROWSET_FIELDNAME )
	METHOD( "GETCOLNAME",   	TROWSET_FIELDNAME )
	METHOD( "FIELDLEN",     	TROWSET_FIELDLEN )
	METHOD( "GETCOLLEN",    	TROWSET_FIELDLEN )
	METHOD( "FIELDDEC",    		TROWSET_FIELDDEC )
	METHOD( "FIELDTYPE",    	TROWSET_FIELDTYPE )
	METHOD( "GETCOLTYPE",   	TROWSET_FIELDTYPE )
	METHOD( "FIELDPOS",     	TROWSET_FIELDPOS )
	METHOD( "GETCOLPOS",    	TROWSET_FIELDPOS )
	METHOD( "FIELDGET",     	TROWSET_FIELDGET )
	METHOD( "GETVALUEBYNAME",	TROWSET_GETVALUEBYNAME )
	METHOD( "GETVALUEBYPOS",	TROWSET_GETVALUEBYPOS )
	METHOD( "FIND",     		TROWSET_FIND )
	METHOD( "FINDNEXT",     	TROWSET_FINDNEXT )
	METHOD( "SETINSERTSTMT", 	TROWSET_SETINSERTSTMT )
	METHOD( "SETUPDATESTMT",	TROWSET_SETUPDATESTMT )
	METHOD( "SETDELETESTMT",	TROWSET_SETDELETESTMT )
	METHOD( "INSERT",			TROWSET_INSERT )
	METHOD( "UPDATE",			TROWSET_UPDATE )
	METHOD( "DELETE",			TROWSET_DELETE )
}
END_CLASS

/* Implementacion de la clase */

/***
 * Metodo:
 * Uso:
 * Parametros:
 * Devuelve:
 */

HB_METHOD( TROWSET_NEW )
{
	PHB_ITEM pSelf = hb_pSelf();
	PHB_ITEM oStmt = hb_param( 1, HB_IT_OBJECT );
	
	if( oStmt )
	{
		PSTMT stmt = ( PSTMT ) hb_objGetPtr( oStmt, POS_PSTMT );
		PROWSET rs = RowSetInit( stmt );
		
		if( rs )
		{
			RS_INIT( rs, stmt );

			hb_objSetPtr( pSelf, IVAR_RS, rs );
		}
		else
		{
			hdo_throwErrOut( HDO_NOTMEMRS, NULL );
		}
	}
	else
	{
		hdo_throwErrOut( 9999, "TODO: Error de argumento. No hay objeto TStmt" );
	}

	/* Un constructor siempre devuelve SELF */
	hb_itemReturnRelease( pSelf );
}

/***
 * Metodo:
 * Uso: Refrescar el conjunto de resultado
 * Parametros:
 * Devuelve:
 */

HB_METHOD( TROWSET_REFRESH )
{
	PROWSET rs = hb_getRS();
	HB_BOOL fRes = HB_FALSE;

	if( rs )
	{
		RS_REFRESH( rs, &fRes );
	}

	hb_retl( fRes );
}

/***
 * Metodo: reload()
 * Uso: De momento es sinonimo de refresh()
 * Parametros:
 * Devuelve:
 */

HB_METHOD( TROWSET_RELOAD )
{
	PROWSET rs = hb_getRS();
	HB_BOOL fRes = HB_FALSE;

	if( rs )
	{
		PHB_ITEM pReload = hb_param( 1, HB_IT_LOGICAL );
		HB_BOOL fReload = pReload ? hb_itemGetL( pReload ) : HB_TRUE;
		
		if( fReload )
		{
			RS_RELOAD( rs, &fRes );
		}
		else
		{
			RS_REFRESH( rs, &fRes );
		}
	}

	hb_retl( fRes );
}

/***
 * Metodo:
 * Uso:
 * Parametros:
 * Devuelve:
 */

HB_METHOD( TROWSET_FREE )
{
	PROWSET rs = hb_getRS();

	if( rs )
	{
		RS_FREE( rs );
	}
}

/***
 * Metodo:
 * Uso:
 * Parametros:
 * Devuelve:
 */

HB_METHOD( TROWSET_RECNO )
{
	PROWSET rs = hb_getRS();
	HB_ULONG ulRecNo = 0;

	if( rs )
	{
		RS_RECNO( rs, &ulRecNo );
	}

	hb_retnl( ulRecNo );
}

/***
 * Metodo:
 * Uso:
 * Parametros:
 * Devuelve:
 */

HB_METHOD( TROWSET_RECCOUNT )
{
	PROWSET rs = hb_getRS();
	HB_ULONG ulRowCount = 0;

	if( rs )
	{
		RS_RECCOUNT( rs, &ulRowCount );
	}

	hb_retnl( ulRowCount );
}

/***
 * Metodo:
 * Uso:
 * Parametros:
 * Devuelve:
 */

HB_METHOD( TROWSET_GOTO )
{
	PROWSET rs = hb_getRS();

	if( rs )
	{
		PHB_ITEM pRec = hb_param( 1, HB_IT_NUMINT );

		if( pRec )
		{
			RS_GOTO( rs, hb_itemGetNL( pRec ) );
		}
		else
		{
			hdo_throwErrOut( 9999, "TODO: Error de falta de argumento" );
		}
	}
}

/***
 * Metodo:
 * Uso:
 * Parametros:
 * Devuelve:
 */

HB_METHOD( TROWSET_GOTOP )
{
	PROWSET rs = hb_getRS();

	if( rs )
	{
		RS_GOTOP( rs );
	}
}

/***
 * Metodo:
 * Uso:
 * Parametros:
 * Devuelve:
 */

HB_METHOD( TROWSET_GOBOTTOM )
{
	PROWSET rs = hb_getRS();

	if( rs )
	{
		RS_GOBOTTOM( rs );
	}
}

/***
 * Metodo:
 * Uso:
 * Parametros:
 * Devuelve:
 */

HB_METHOD( TROWSET_SKIP )
{
	PROWSET rs = hb_getRS();
	HB_LONG lSkip = hb_parnldef( 1, 1 );

	if( rs )
	{
		RS_SKIP( rs, lSkip );
	}
}

/***
 * Metodo:
 * Uso:
 * Parametros:
 * Devuelve:
 */

HB_METHOD( TROWSET_NEXT )
{
	PROWSET rs = hb_getRS();

	if( rs )
	{
		RS_SKIP( rs, 1 );
	}
}

/***
 * Metodo:
 * Uso:
 * Parametros:
 * Devuelve:
 */

HB_METHOD( TROWSET_PRIOR )
{
	PROWSET rs = hb_getRS();

	if( rs )
	{
		RS_SKIP( rs, -1 );
	}
}

/***
 * Metodo:
 * Uso:
 * Parametros:
 * Devuelve:
 */

HB_METHOD( TROWSET_SKIPPER )
{
	PROWSET rs = hb_getRS();
	HB_LONG lSkipped = 0;

	if( rs )
	{
		HB_LONG lSkip = hb_parnldef( 1, 1 );

		RS_SKIPPER( rs, lSkip, &lSkipped );
	}

	hb_retnl( lSkipped );
}

/***
 * Metodo:
 * Uso:
 * Parametros:
 * Devuelve:
 */

HB_METHOD( TROWSET_EOF )
{
	PROWSET rs = hb_getRS();
	HB_BOOL fRes = HB_FALSE;

	if( rs )
	{
		RS_EOF( rs, &fRes );
	}

	hb_retl( fRes );
}

/***
 * Metodo:
 * Uso:
 * Parametros:
 * Devuelve:
 */

HB_METHOD( TROWSET_BOF )
{
	PROWSET rs = hb_getRS();
	HB_BOOL fRes = HB_FALSE;

	if( rs )
	{
		RS_BOF( rs, &fRes );
	}

	hb_retl( fRes );
}

/***
 * Metodo:
 * Uso:
 * Parametros:
 * Devuelve:
 */

HB_METHOD( TROWSET_FIELDCOUNT )
{
	PROWSET rs = hb_getRS();
	HB_USHORT ulCol = 0;

	if( rs )
	{
		RS_FIELDCOUNT( rs, &ulCol );
	}

	hb_retni( ulCol );
}

/***
 * Metodo:
 * Uso:
 * Parametros:
 * Devuelve:
 */

HB_METHOD( TROWSET_FIELDNAME )
{
	PROWSET rs = hb_getRS();
	char *szName = NULL;

	if( rs )
	{
		RS_FIELDNAME( rs, hb_parni( 1 ), &szName );
	}

	hb_retc_buffer( szName );
}

/***
 * Metodo:
 * Uso:
 * Parametros:
 * Devuelve:
 */

HB_METHOD( TROWSET_FIELDLEN )
{
	PROWSET rs = hb_getRS();
	HB_USHORT uiLen = 0;

	if( rs )
	{
		RS_FIELDLEN( rs, hb_parni( 1 ), &uiLen );
	}

	hb_retni( uiLen );
}

/***
 * Metodo:
 * Uso:
 * Parametros:
 * Devuelve:
 */

HB_METHOD( TROWSET_FIELDDEC )
{
	PROWSET rs = hb_getRS();
	HB_USHORT uiDec = 0;

	if( rs )
	{
		RS_FIELDDEC( rs, hb_parni( 1 ), &uiDec );
	}

	hb_retni( uiDec );
}

/***
 * Metodo:
 * Uso:
 * Parametros:
 * Devuelve:
 */

HB_METHOD( TROWSET_FIELDTYPE )
{
	PROWSET rs = hb_getRS();
	char *szType = NULL;

	if( rs )
	{
		RS_FIELDTYPE( rs, hb_parni( 1 ), &szType );
	}

	hb_retc_buffer( szType );
}

/***
 * Metodo:
 * Uso:
 * Parametros:
 * Devuelve:
 */

HB_METHOD( TROWSET_FIELDPOS )
{
	PROWSET rs = hb_getRS();
	HB_USHORT uiCol = 0;

	if( rs )
	{
		RS_FIELDPOS( rs, hb_parc( 1 ), &uiCol );
	}

	hb_retni( uiCol );
}

/***
 * Metodo:
 * Uso:
 * Parametros:
 * Devuelve:
 */

HB_METHOD( TROWSET_FIELDGET )
{
	PROWSET rs = hb_getRS();

	if( rs )
	{
		PHB_ITEM pCol = hb_param( 1, HB_IT_STRING | HB_IT_NUMINT );

		if( pCol )
		{
			if( HB_IS_STRING( pCol ) )
			{
				RS_GETVALUEBYNAME( rs, hb_itemGetCPtr( pCol ), hb_stackReturnItem() );
			}
			else
			{
				RS_GETVALUEBYPOS( rs, hb_itemGetNInt( pCol ), hb_stackReturnItem() );
			}
		}
		else
		{
			hdo_throwErrOut( 9999, "TODO: Error de argumento" );
		}
	}
	else
	{
		hb_itemReturn( NULL );
	}
}

/***
 * Metodo:
 * Uso:
 * Parametros:
 * Devuelve:
 */

HB_METHOD( TROWSET_GETVALUEBYNAME )
{
	PROWSET rs = hb_getRS();

	if( rs )
	{
		PHB_ITEM pCol = hb_param( 1, HB_IT_STRING );

		if( pCol )
		{
			RS_GETVALUEBYNAME( rs, hb_itemGetCPtr( pCol ), hb_stackReturnItem() );
		}
	}
	else
	{
		hb_itemReturn( NULL );
	}
}

/***
 * Metodo:
 * Uso:
 * Parametros:
 * Devuelve:
 */

HB_METHOD( TROWSET_GETVALUEBYPOS )
{
	PROWSET rs = hb_getRS();

	if( rs )
	{
		PHB_ITEM pCol = hb_param( 1, HB_IT_NUMINT );
		
		if( pCol )
		{
			RS_GETVALUEBYPOS( rs, hb_itemGetNI( pCol ), hb_stackReturnItem() );
		}
	}
	else
	{
		hb_itemReturn( NULL );
	}
}

/***
 * Metodo: find
 * Uso: Buscar valores
 * Parametros: (1) Valor buscado, (2) Numero o Campo por el que buscar, (3) Empieza desde el principio?
 * Devuelve:
 */

HB_METHOD( TROWSET_FIND )
{
	PROWSET rs = hb_getRS();
	HB_ULONG ulRec = 0;
	
	if( rs )
	{
		PHB_ITEM pFind = hb_param( 1, HB_IT_ANY );
		
		if( pFind )
		{
			PHB_ITEM pxCol = hb_param( 2, HB_IT_NUMINT | HB_IT_STRING );
			HB_BOOL fBOL = hb_parldef( 3, HB_TRUE );
			
			RS_FIND( rs, pFind, pxCol, fBOL, &ulRec );	
			
			if( ulRec == 0 )
			{
				RS_GOTO( rs, 0 );
			}
		}
	}
	
	hb_retnl( ulRec );
}

/***
 * Metodo: findNext
 * Uso: Buscar valores
 * Parametros: (1) Valor buscado, (2) Numero o Campo por el que buscar
 * Devuelve:
 */

HB_METHOD( TROWSET_FINDNEXT )
{
	PROWSET rs = hb_getRS();
	HB_ULONG ulRec = 0;
	
	if( rs )
	{
		RS_FINDNEXT( rs, &ulRec );	
	}
	
	hb_retnl( ulRec );
}

/***
 * Metodo: setInsertStmt
 * Uso:
 * Parametros:
 * Devuelve:
 */

HB_METHOD( TROWSET_SETINSERTSTMT )
{
	PROWSET rs = hb_getRS();

	if( rs )
	{
		PHB_ITEM pStmt = hb_param( 1, HB_IT_STRING );
		
		if( pStmt )
		{
			RS_SETINSERTSTMT( rs, hb_itemGetCPtr( pStmt ), hb_itemGetCLen( pStmt ) );	
		}
	}
}

/***
 * Metodo: setUpdateStmt
 * Uso:
 * Parametros:
 * Devuelve:
 */

HB_METHOD( TROWSET_SETUPDATESTMT )
{
	PROWSET rs = hb_getRS();
	
	if( rs )
	{
		PHB_ITEM pStmt = hb_param( 1, HB_IT_STRING );
		
		if( pStmt )
		{
			RS_SETUPDATESTMT( rs, hb_itemGetCPtr( pStmt ), hb_itemGetCLen( pStmt ) );	
		}
	}
}

/***
 * Metodo: setDeleteStmt
 * Uso:
 * Parametros:
 * Devuelve:
 */

HB_METHOD( TROWSET_SETDELETESTMT )
{
	PROWSET rs = hb_getRS();
	
	if( rs )
	{
		PHB_ITEM pStmt = hb_param( 1, HB_IT_STRING );
		
		if( pStmt )
		{
			RS_SETDELETESTMT( rs, hb_itemGetCPtr( pStmt ), hb_itemGetCLen( pStmt ) );	
		}
	}
}

HB_METHOD( TROWSET_INSERT )
{
	PROWSET rs = hb_getRS();
	
	if( rs )
	{
		PHB_ITEM paVal = hb_param( 1, HB_IT_ARRAY );
		
		if( paVal )
		{
			HB_BOOL fRes = hb_parl( 2 );

			RS_INSERT( rs, paVal, fRes );	
		}
	}
}

HB_METHOD( TROWSET_UPDATE )
{
	PROWSET rs = hb_getRS();
	
	if( rs )
	{
		PHB_ITEM paVal = hb_param( 1, HB_IT_ARRAY );
		
		if( paVal )
		{
			HB_BOOL fRes = hb_parl( 2 );

			RS_UPDATE( rs, paVal, fRes );	
		}
	}
}

HB_METHOD( TROWSET_DELETE )
{
	PROWSET rs = hb_getRS();
	
	if( rs )
	{
		PHB_ITEM paVal = hb_param( 1, HB_IT_ARRAY );
		
		if( paVal )
		{
			HB_BOOL fRes = hb_parl( 2 );

			RS_DELETE( rs, paVal, fRes );	
		}
	}
}
