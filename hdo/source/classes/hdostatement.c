/***
 * Proyecto: Harbour Data Objects (HDO)
 * Fichero: hdostatement.c
 * Descripcion: Clase para el manejo de sentencias SQL
 * Autor: Manu Exposito 2015-17
 * Fecha: 15/01/2017
 */
//                                                                                 PONER EL CONTROL DE COLUMNAS EN LAS CLASES Y NO EN LOS RDL
/* Ficheros include */

#include "hdostatetent.h"

/* Definicion de la clase con atributos y metodos */

CREATE_CLASS( "TSTMT", TSTMT, TSTMT_IVARCOUNT )
{
	// Metodos:
	METHOD( "NEW",              TSTMT_NEW )
	METHOD( "GETQUERYSTR",		TSTMT_GETQUERYSTR )
	METHOD( "GETCOLNAME",       TSTMT_GETCOLNAME );
	METHOD( "GETCOLTYPE",       TSTMT_GETCOLTYPE );
	METHOD( "GETCOLLEN",        TSTMT_GETCOLLEN );
	METHOD( "GETCOLDEC",        TSTMT_GETCOLDEC );
	METHOD( "GETCOLPOS",        TSTMT_GETCOLPOS );
	METHOD( "LISTCOLNAMES",     TSTMT_LISTCOLNAMES );
	METHOD( "BINDCOLUMN",       TSTMT_BINDCOLUMN )
	METHOD( "BINDPARAM",        TSTMT_BINDPARAM )
	METHOD( "BINDVALUE",        TSTMT_BINDVALUE )
	METHOD( "CLOSECURSOR",      TSTMT_CLOSECURSOR )
	METHOD( "COLUMNCOUNT",      TSTMT_COLUMNCOUNT )
	METHOD( "BINDPARAMCOUNT",	TSTMT_BINDPARAMCOUNT )
	METHOD( "ERRORCODE",        TSTMT_ERRORCODE )
	METHOD( "ERRORINFO",        TSTMT_ERRORINFO )
	METHOD( "EXECUTE",          TSTMT_EXECUTE )
	METHOD( "PREPARE",          TSTMT_PREPARE )
	METHOD( "QUERY",          	TSTMT_QUERY )
	METHOD( "FETCHDIRECT",      TSTMT_FETCHDIRECT )
	METHOD( "FETCH",            TSTMT_FETCH )
	METHOD( "FETCHARRAY",       TSTMT_FETCHARRAY )
	METHOD( "GETROW",       	TSTMT_FETCHARRAY ) // Sinonimo de FETCHARRAY
	METHOD( "FETCHHASH",        TSTMT_FETCHHASH )
	METHOD( "FETCHBOUND",       TSTMT_FETCHBOUND )
	METHOD( "FETCHJSON",		TSTMT_FETCHJSON )
	METHOD( "FETCHALL",         TSTMT_FETCHALL )
	METHOD( "FETCHALLARRAY",    TSTMT_FETCHALLARRAY );
	METHOD( "FETCHALLHASH",     TSTMT_FETCHALLHASH );
	METHOD( "FETCHROWSET",      TSTMT_FETCHROWSET );
	METHOD( "FETCHCOLUMN",      TSTMT_FETCHCOLUMN )
	METHOD( "GETCOLUMN",		TSTMT_FETCHCOLUMN ) // Sinonimo de FETCHCOLUMN
	METHOD( "GETVALUE",			TSTMT_FETCHCOLUMN ) // Sinonimo de FETCHCOLUMN
	METHOD( "GETATTRIBUTE",     TSTMT_GETATTRIBUTE )
	METHOD( "GETCOLUMNMETA",    TSTMT_GETCOLUMNMETA )
	METHOD( "NEXTROWSET",       TSTMT_NEXTROWSET )
	METHOD( "ROWCOUNT",         TSTMT_ROWCOUNT )
	METHOD( "SETATTRIBUTE",     TSTMT_SETATTRIBUTE )
	METHOD( "SETFETCHMODE",     TSTMT_SETFETCHMODE )
	METHOD( "FREE",             TSTMT_FREE )
}
END_CLASS

/* Implementacion de la clase */

/***
 * Constructor de la clase
 */

HB_METHOD( TSTMT_NEW )
{
	PHB_ITEM pSelf = hb_pSelf();
	PHB_ITEM oHDO = hb_param( 1, HB_IT_OBJECT );

	if( oHDO )
	{
		PHDO hdo = ( PHDO ) hb_objGetPtr( oHDO, 1 );
		PSTMT stmt = StmtInit( hdo );

		STMT_INIT( stmt, hdo );

		/* MUY IMPORTANTE: Asigna la estructura recien creada a la clase */
		hb_objSetPtr( pSelf, IVAR_STMT, stmt );
	}
	else
	{
		hdo_throwErrOut( HDO_NOTMEMSTMT, NULL );
	}

	/* El constructor devuelve SELF */
	hb_itemReturnRelease( pSelf );
}

/***
 * Devuelve la sentencia SQL
 */

HB_METHOD( TSTMT_GETQUERYSTR )
{
	PSTMT stmt = stmt_getStmt();
	char *szStmt = NULL;

	if( stmt )
	{
		STMT_GETQUERYSTR( stmt, &szStmt );
	}

	hb_retc_buffer( szStmt );
}
/***
 * Devuelve el nombre de la columna
 */

HB_METHOD( TSTMT_GETCOLNAME )
{
	PSTMT stmt = stmt_getStmt();
	char *szName = NULL;

	if( stmt )
	{
		HB_INT uiCol = hb_parni( 1 ) - 1;

		if( RCHKCOL( stmt, uiCol ) )
		{
			STMT_GETCOLNAME( stmt, uiCol, &szName );
		}
		else
		{
			hdo_throwException( stmt->hdo, HDO_NUMCOLERR, NULL );
		}
	}

	hb_retc_buffer( szName );
}

/***
 * Devuelve el typo dato de la columna
 */

HB_METHOD( TSTMT_GETCOLTYPE )
{
	PSTMT stmt = stmt_getStmt();
	char *szColType = NULL;

	if( stmt )
	{
		HB_INT uiCol = hb_parni( 1 ) - 1;

		if( RCHKCOL( stmt, uiCol ) )
		{
			STMT_GETCOLTYPE( stmt, uiCol, &szColType );
		}
		else
		{
			hdo_throwException( stmt->hdo, HDO_NUMCOLERR, NULL );
		}
	}

	hb_retc_buffer( szColType );
}

/***
 * Devuelve el ancho de la columna
 */

HB_METHOD( TSTMT_GETCOLLEN )
{
	PSTMT stmt = stmt_getStmt();
	HB_USHORT uiColLen = 0;

	if( stmt )
	{
		HB_INT uiCol = hb_parni( 1 ) - 1;

		if( RCHKCOL( stmt, uiCol ) )
		{
			STMT_GETCOLLEN( stmt, uiCol, &uiColLen );
		}
		else
		{
			hdo_throwException( stmt->hdo, HDO_NUMCOLERR, NULL );
		}
	}

	hb_retni( uiColLen );
}

/***
 * Devuelve el numero de decimales en caso de un numero real
 */

HB_METHOD( TSTMT_GETCOLDEC )
{
	PSTMT stmt = stmt_getStmt();
	HB_USHORT uiColDec = 0;

	if( stmt )
	{
		HB_INT uiCol = hb_parni( 1 ) - 1;

		if( RCHKCOL( stmt, uiCol ) )
		{
			STMT_GETCOLDEC( stmt, uiCol, &uiColDec );
		}
		else
		{
			hdo_throwException( stmt->hdo, HDO_NUMCOLERR, NULL );
		}
	}

	hb_retni( uiColDec );
}

/***
 * Devuelve el la posicion de una columna por su nombre
 */

HB_METHOD( TSTMT_GETCOLPOS )
{
	PSTMT stmt = stmt_getStmt();
	HB_USHORT uiCol = 0;

	if( stmt )
	{
		const char *szName = hb_parc( 1 );

		if( szName )
		{
			STMT_GETCOLPOS( stmt, szName, &uiCol );
		}
	}

	hb_retni( uiCol );
}


/***
 * Array con el nombre de lo campos de una sentencia
 */

HB_METHOD( TSTMT_LISTCOLNAMES )
{
	PSTMT stmt = stmt_getStmt();
	PHB_ITEM paRes = hb_itemNew( NULL );

	if( stmt )
	{
		HB_USHORT uiArray = hb_parni( 1 );

		STMT_LISTCOLNAMES( stmt, uiArray, paRes );
	}

	hb_itemReturnRelease( paRes );
}


/***
 * Vincula una columna a una variable de Harbour
 */

HB_METHOD( TSTMT_BINDCOLUMN )
{
	PSTMT stmt = stmt_getStmt();

	if( stmt )
	{
		HDO_RET_SUCCEED( STMT_BINDCOLUMN( stmt, hb_param( 1, HB_IT_NUMERIC | HB_IT_STRING ),
										  hb_param( 2, HB_IT_ANY ), hb_parni( 3 ), hb_parni( 4 ) ) );
	}
	else
	{
		hb_retl( HB_FALSE );
	}
}

/***
 * Vincula un parámetro al nombre de variable especificado
 */

HB_METHOD( TSTMT_BINDPARAM )
{
	PSTMT stmt = stmt_getStmt();

	if( stmt )
	{
		HDO_RET_SUCCEED( STMT_BINDPARAM( stmt, hb_param( 1, HB_IT_NUMERIC | HB_IT_STRING ),
										 hb_param( 2, HB_IT_BYREF ), hb_parni( 3 ), hb_parni( 4 ) ) );
	}
	else
	{
		hb_retl( HB_FALSE );
	}
}

/***
 * Vincula un valor a un parámetro para una sentencia SQL
 */

HB_METHOD( TSTMT_BINDVALUE )
{
	PSTMT stmt = stmt_getStmt();

	if( stmt )
	{
		HDO_RET_SUCCEED( STMT_BINDVALUE( stmt, hb_param( 1, HB_IT_NUMERIC | HB_IT_STRING ), hb_param( 2, HB_IT_ANY ) ) );
	}
	else
	{
		hb_retl( HB_FALSE );
	}
}

/***
 * Cierra un cursor, habilitando a la sentencia para que sea ejecutada otra vez
 */

HB_METHOD( TSTMT_CLOSECURSOR )
{
	PSTMT stmt = stmt_getStmt();

	if( stmt )
	{
		HDO_RET_SUCCEED( STMT_CLOSECURSOR( stmt ) );
	}
	else
	{
		hb_retl( HB_FALSE );
	}
}

/***
 * Devuelve el número de columnas de un conjunto de resultados
 */

HB_METHOD( TSTMT_COLUMNCOUNT )
{
	PSTMT stmt = stmt_getStmt();
	HB_USHORT nCount = 0;

	if( stmt )
	{
		STMT_COLUMNCOUNT( stmt, &nCount );
	}

	hb_retni( nCount );
}

/***
 * Devuelve el numero de parametros enlazados
 */

HB_METHOD( TSTMT_BINDPARAMCOUNT )
{
	PSTMT stmt = stmt_getStmt();
	HB_USHORT nCount = 0;

	if( stmt )
	{
		STMT_BINDPARAMCOUNT( stmt, &nCount );
	}

	hb_retni( nCount );
}

/***
 * Ejecuta una sentencia preparada
 */

HB_METHOD( TSTMT_EXECUTE )
{
	PSTMT stmt = stmt_getStmt();

	if( stmt )
	{
		HDO_RET_SUCCEED( STMT_EXECUTE( stmt ) );
	}
	else
	{
		hb_retl( HB_FALSE );
	}
}

/***
 * Metodo: PREPARE
 * Uso: Prepara una sentencia
 * Parametros: Cadena con la sentencia
 * Devuelve:
 */

HB_METHOD( TSTMT_PREPARE )
{
	PSTMT stmt = stmt_getStmt();
	HB_BOOL fRes = HB_FALSE;

	if( stmt )
	{
		PHB_ITEM pStmt = hb_param( 1, HB_IT_STRING );

		if( pStmt )
		{
			fRes = HDO_SUCCEED( STMT_PREPARE( stmt, hb_itemGetCPtr( pStmt ), hb_itemGetCLen( pStmt ) ) );
		}
	}

	hb_retl( fRes );
}

/***
 * Metodo: QUERY
 * Uso: Prepara una sentencia
 * Parametros: Cadena con la sentencia
 * Devuelve:
 */

HB_METHOD( TSTMT_QUERY )
{
	PSTMT stmt = stmt_getStmt();
	HB_BOOL fRes = HB_FALSE;

	if( stmt )
	{
		PHB_ITEM pStmt = hb_param( 1, HB_IT_STRING );

		if( pStmt )
		{
			fRes = HDO_SUCCEED( STMT_QUERY( stmt, hb_itemGetCPtr( pStmt ), hb_itemGetCLen( pStmt ) ) );
		}
	}

	hb_retl( fRes );
}

/***
 * Obtiene el SQLSTATE asociado con la última operación del gestor de sentencia
 */

HB_METHOD( TSTMT_ERRORCODE )
{
	PSTMT stmt = stmt_getStmt();
	char *szRes = NULL;

	if( stmt )
	{
		STMT_ERRORCODE( stmt, &szRes );
	}

	hb_retc_buffer( szRes );
}

/***
 * Obtiene información ampliada del error asociado con la última operación del
 * gestor de sentencia
 */

HB_METHOD( TSTMT_ERRORINFO )
{
	PSTMT stmt = stmt_getStmt();
	PHB_ITEM paRes = hb_itemArrayNew( ERR_INFO_SIZE );

	if( stmt )
	{
		STMT_ERRORINFO( stmt, paRes );
	}

	hb_itemReturnRelease( paRes );
}

/***
 * Obtiene la siguiente fila sin tener en cuenta el tipo de FETCH
 */

HB_METHOD( TSTMT_FETCHDIRECT )
{
	PSTMT stmt = stmt_getStmt();
	HB_BOOL fRes = HB_FALSE;

	if( stmt )
	{
		STMT_FETCHDIRECT( stmt, &fRes );
	}

	hb_retl( fRes );
}

/***
 * Obtiene la siguiente fila de un conjunto de resultados como un:
 * FETCH_ARRAY: array
 * FETCH_HASH: hash table
 * FETCH_BOUND: actualiza variables xbase
 */

HB_METHOD( TSTMT_FETCH )
{
	PSTMT stmt = stmt_getStmt();
	PHB_ITEM pResult = hb_itemNew( NULL );

	if( stmt )
	{
		HB_USHORT uiFetchMode = hb_parni( 1 );

		STMT_FETCH( stmt, pResult, uiFetchMode );
	}

	hb_itemReturnRelease( pResult );
}

/***
 * Obtiene la siguiente fila de un conjunto de resultados como un:
 * FETCH_ARRAY: array
 */

HB_METHOD( TSTMT_FETCHARRAY )
{
	PSTMT stmt = stmt_getStmt();
	PHB_ITEM pResult = hb_itemNew( NULL );

	if( stmt )
	{
		STMT_FETCHARRAY( stmt, pResult );
	}

	hb_itemReturnRelease( pResult );
}

/***
 * Obtiene la siguiente fila de un conjunto de resultados como un:
 * FETCH_HASH: hash table
 */

HB_METHOD( TSTMT_FETCHHASH )
{
	PSTMT stmt = stmt_getStmt();
	PHB_ITEM pResult = hb_itemNew( NULL );

	if( stmt )
	{
		STMT_FETCHHASH( stmt, pResult );
	}

	hb_itemReturnRelease( pResult );
}

/***
 * Obtiene la siguiente fila de un conjunto de resultados como un:
 * FETCH_BOUND: actualiza variables xbase
 */

HB_METHOD( TSTMT_FETCHBOUND )
{
	PSTMT stmt = stmt_getStmt();

	if( stmt )
	{
		HDO_RET_SUCCEED( STMT_FETCHBOUND( stmt ) );
	}
	else
	{
		hb_retl( HB_FALSE );
	}
}

/***
 * Obtiene la siguiente fila de un conjunto de resultados como un:
 * FETCH_HASH: hash table
 */

HB_METHOD( TSTMT_FETCHJSON )
{
	PSTMT stmt = stmt_getStmt();

	if( stmt )
	{		
		STMT_FETCHJSON( stmt );
	}
	else
	{
		hb_retc_null();
	}
}

/***
 * Devuelve un array que contiene todas las filas del conjunto de resultados como:
 * FETCH_ARRAY: array
 * FETCH_HASH: hash table
 */

HB_METHOD( TSTMT_FETCHALL )
{
	PSTMT stmt = stmt_getStmt();
	PHB_ITEM pResult = hb_itemNew( NULL );

	if( stmt )
	{
		HB_USHORT uiFetchMode = hb_parni( 1 );

		STMT_FETCHALL( stmt, pResult, uiFetchMode );
	}

	hb_itemReturnRelease( pResult );
}

/***
 * Devuelve un array que contiene todas las filas del conjunto de resultados como:
 * FETCH_ARRAY: array
 */

HB_METHOD( TSTMT_FETCHALLARRAY )
{
	PSTMT stmt = stmt_getStmt();
	PHB_ITEM pResult = hb_itemNew( NULL );

	if( stmt )
	{
		STMT_FETCHALLARRAY( stmt, pResult );
	}

	hb_itemReturnRelease( pResult );
}

/***
 * Devuelve un array que contiene todas las filas del conjunto de resultados como:
 * FETCH_HASH: hash table
 */

HB_METHOD( TSTMT_FETCHALLHASH )
{
	PSTMT stmt = stmt_getStmt();
	PHB_ITEM pResult = hb_itemNew( NULL );

	if( stmt )
	{
		STMT_FETCHALLHASH( stmt, pResult );
	}

	hb_itemReturnRelease( pResult );
}

/***
 * Devuelve objeto TRowSet con todas las filas del conjunto de resultados como:
 */

HB_METHOD( TSTMT_FETCHROWSET )
{
	PSTMT stmt = stmt_getStmt();
	PHB_ITEM oRS = hb_itemNew( NULL );

	if( stmt )
	{
		if( !HDO_SUCCEED( STMT_FETCHROWSET( stmt, oRS ) ) )
		{
			hdo_throwException( stmt->hdo, HDO_NOTCREAROW, NULL );
		}
	}

	hb_itemReturnRelease( oRS );
}

/***
 * Devuelve una única columna de la siguiente fila de un conjunto de resultados
 */

HB_METHOD( TSTMT_FETCHCOLUMN )
{
	PSTMT stmt = stmt_getStmt();
	PHB_ITEM pRes = hb_itemNew( NULL );

	if( stmt )
	{
		HB_INT uiCol = hb_parni( 1 ) - 1;

		if( RCHKCOL( stmt, uiCol ) )
		{
			STMT_FETCHCOLUMN( stmt, uiCol, pRes );
		}
		else
		{
			hdo_throwException( stmt->hdo, HDO_NUMCOLERR, NULL );
		}
	}

	hb_itemReturnRelease( pRes );
}

/***
 * Recupera un atributo de sentencia
 */

HB_METHOD( TSTMT_GETATTRIBUTE )
{
	PSTMT stmt = stmt_getStmt();
	PHB_ITEM pVal = hb_itemNew( NULL );

	if( stmt )
	{
		STMT_GETATTRIBUTE( stmt, hb_parni( 1 ), pVal );
	}

	hb_itemReturnRelease( pVal );
}

/***
 * Devuelve metadatos de una columna de un conjunto de resultados
 */

HB_METHOD( TSTMT_GETCOLUMNMETA )
{
	PSTMT stmt = stmt_getStmt();
	PHB_ITEM aColMeta = hb_itemArrayNew( META_COL_SIZE );

	if( stmt )
	{
		PHB_ITEM pCol = hb_param( 1, HB_IT_INTEGER | HB_IT_STRING );

		switch( HB_ITEM_TYPE( pCol ) )
		{
			case HB_IT_INTEGER:
				{
					HB_INT uiCol = hb_itemGetNI( pCol ) - 1;

					if( RCHKCOL( stmt, uiCol ) )
					{
						STMT_GETCOLUMNMETABYPOS( stmt, uiCol, aColMeta );
					}
					else
					{
						hdo_throwException( stmt->hdo, HDO_NUMCOLERR, NULL );
					}

					break;
				}

			case HB_IT_STRING:
				STMT_GETCOLUMNMETABYNAME( stmt, hb_itemGetCPtr( pCol ), aColMeta );
				break;

			default:
				hdo_throwException( stmt->hdo, HDO_TYPEDATPAR, NULL );
		}
	}

	hb_itemReturnRelease( aColMeta );
}

/***
 * Avanza hasta el siguiente conjunto de filas de un gestor de sentencia
 * multiconjunto de filas
 */

HB_METHOD( TSTMT_NEXTROWSET )
{
	PSTMT stmt = stmt_getStmt();
	HB_BOOL fRes = HB_FALSE;

	if( stmt )
	{
		STMT_NEXTROWSET( stmt, &fRes );
	}

	hb_retl( fRes );
}

/***
 * Devuelve el número de filas afectadas por la última sentencia SQL
 */

HB_METHOD( TSTMT_ROWCOUNT )
{
	PSTMT stmt = stmt_getStmt();
	HB_ULONG ulRowCount = 0;

	if( stmt )
	{
		STMT_ROWCOUNT( stmt, &ulRowCount );
	}

	hb_retnl( ulRowCount );
}

/***
 * Establece un atributo de sentencia
 */

HB_METHOD( TSTMT_SETATTRIBUTE )
{
	PSTMT stmt = stmt_getStmt();

	if( stmt )
	{
		HDO_RET_SUCCEED( STMT_SETATTRIBUTE( stmt, hb_parni( 1 ), hb_param( 2, HB_IT_ANY ) ) );
	}
	else
	{
		hb_retl( HB_FALSE );
	}
}

/***
 * Establece el modo de obtención para esta sentencia
 */

HB_METHOD( TSTMT_SETFETCHMODE )
{
	PSTMT stmt = stmt_getStmt();

	if( stmt )
	{
		HDO_RET_SUCCEED( STMT_SETFETCHMODE( stmt, hb_parni( 1 ) ) );
	}
	else
	{
		hb_retl( HB_FALSE );
	}
}

/***
 * Libera la memoria ocupada por el objeto
 */

HB_METHOD( TSTMT_FREE )
{
	PSTMT stmt = stmt_getStmt();

	if( stmt )
	{
		STMT_FREE( stmt );
	}
}
