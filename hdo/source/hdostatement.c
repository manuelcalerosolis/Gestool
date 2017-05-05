/***
 * Proyecto: Harbour Data Objects (HDO)
 * Fichero: hdostatement.c
 * Descripcion: Clase para el manejo de sentencias SQL
 * Autor: Manu Exposito 2015-17
 * Fecha: 15/01/2017
 */

/* Ficheros include */

#include "hdostatetent.h"

/* Definicion de la clase con atributos y metodos */

CREATE_CLASS( "TSTMT", TSTMT, TSTMT_IVARCOUNT )
{
	// Metodos:
	METHOD( "NEW",              TSTMT_NEW )
	METHOD( "GETQUERYSTR",      TSTMT_GETQUERYSTR )
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
	METHOD( "PARAMCOUNT",		TSTMT_PARAMCOUNT )
	METHOD( "ERRORCODE",        TSTMT_ERRORCODE )
	METHOD( "ERRORINFO",        TSTMT_ERRORINFO )
	METHOD( "EXECUTE",          TSTMT_EXECUTE )
	METHOD( "FETCHDIRECT",      TSTMT_FETCHDIRECT )
	METHOD( "FETCH",            TSTMT_FETCH )
	METHOD( "FETCHARRAY",       TSTMT_FETCHARRAY )
	METHOD( "GETROW",       	TSTMT_FETCHARRAY ) // Sinonimo de FETCHARRAY
	METHOD( "FETCHHASH",        TSTMT_FETCHHASH )
	METHOD( "FETCHBOUND",       TSTMT_FETCHBOUND )
	METHOD( "FETCHALL",         TSTMT_FETCHALL )
	METHOD( "FETCHALLARRAY",    TSTMT_FETCHALLARRAY );
	METHOD( "FETCHALLHASH",     TSTMT_FETCHALLHASH );
	METHOD( "FETCHROWSET",      TSTMT_FETCHROWSET );
	METHOD( "FETCHCOLUMN",      TSTMT_FETCHCOLUMN )
	METHOD( "GETATTRIBUTE",     TSTMT_GETATTRIBUTE )
	METHOD( "GETCOLUMNMETA",    TSTMT_GETCOLUMNMETA )
	METHOD( "NEXTROWSET",       TSTMT_NEXTROWSET )
	METHOD( "ROWCOUNT",         TSTMT_ROWCOUNT )
	METHOD( "SETATTRIBUTE",     TSTMT_SETATTRIBUTE )
	METHOD( "SETFETCHMODE",     TSTMT_SETFETCHMODE )
	METHOD( "FREE",             TSTMT_FREE )
	METHOD( "GETBYTE",          TSTMT_GETBYTE )
	METHOD( "GETSHORT",         TSTMT_GETSHORT )
	METHOD( "GETINT",           TSTMT_GETINT )
	METHOD( "GETLONG",          TSTMT_GETLONG )
	METHOD( "GETFLOAT",         TSTMT_GETFLOAT )
	METHOD( "GETDOUBLE",        TSTMT_GETDOUBLE )
	METHOD( "GETBOOLEAN",       TSTMT_GETBOOLEAN )
	METHOD( "GETSTRING",        TSTMT_GETSTRING )
	METHOD( "GETBYTES",         TSTMT_GETBYTES )
	METHOD( "GETDATE",          TSTMT_GETDATE )
	METHOD( "GETTIME",          TSTMT_GETTIME )
	METHOD( "GETTIMESTAMP",     TSTMT_GETTIMESTAMP )
	METHOD( "PUTNULL",          TSTMT_PUTNULL )
	METHOD( "PUTBYTE",          TSTMT_PUTBYTE )
	METHOD( "PUTSHORT",         TSTMT_PUTSHORT )
	METHOD( "PUTINT",           TSTMT_PUTINT )
	METHOD( "PUTLONG",          TSTMT_PUTLONG )
	METHOD( "PUTFLOAT",         TSTMT_PUTFLOAT )
	METHOD( "PUTDOUBLE",        TSTMT_PUTDOUBLE )
	METHOD( "PUTBOOLEAN",       TSTMT_PUTBOOLEAN )
	METHOD( "PUTSTRING",        TSTMT_PUTSTRING )
	METHOD( "PUTBYTES",         TSTMT_PUTBYTES )
	METHOD( "PUTDATE",          TSTMT_PUTDATE )
	METHOD( "PUTTIME",          TSTMT_PUTTIME )
	METHOD( "PUTTIMESTAMP",     TSTMT_PUTTIMESTAMP )
}
END_CLASS

/* Implementacion de la clase */

/***
 * Constructor de la clase
 */

HB_METHOD( TSTMT_NEW )
{
	PHB_ITEM pSelf = hb_pSelf();
	PSTMT stmt = StmtInit();

	if( stmt )
	{
		PHB_ITEM oHDO = hb_param( 1, HB_IT_OBJECT );
		PHDO hdo = ( PHDO ) hb_arrayGetPtr( oHDO, POS_PHDO );

        if( setStmtRDL( stmt, hdo ) == HB_FAILURE )
        {
            hdo_throwErrNew( HDO_NOTMEMRS, NULL );
        }

		setStmtString( stmt, hb_parc( 2 ) );
		
		STMT_INIT( stmt );

		/* MUY IMPORTANTE: Asigna la estructura recien creada a la clase */
		hb_arraySetPtr( pSelf, IVAR_STMT, stmt );
	}
	else
	{
		hdo_throwErrNew( HDO_NOTMEMSTMT, NULL );
	}

	/* El constructor devuelve SELF */
	hb_itemReturnRelease( pSelf );
}

/***
 * Devuelve la sentencia SQL
 */

HB_METHOD( TSTMT_GETQUERYSTR )
{
	PSTMT stmt = hb_getStmt();
	char *szQuery = NULL;

	if( stmt )
	{
		STMT_GETQUERYSTR( stmt, &szQuery );
	}

	hb_retc_buffer( szQuery );
}
/***
 * Devuelve el nombre de la columna
 */

HB_METHOD( TSTMT_GETCOLNAME )
{
	PSTMT stmt = hb_getStmt();
	char *szName = NULL;

	if( stmt )
	{
		HB_USHORT uiCol = hb_parni( 1 );

		if( uiCol > 0 )
		{
			STMT_GETCOLNAME( stmt, uiCol, &szName );
		}
	}

	hb_retc_buffer( szName );
}

/***
 * Devuelve el typo dato de la columna
 */

HB_METHOD( TSTMT_GETCOLTYPE )
{
	PSTMT stmt = hb_getStmt();
	char *szColType = NULL;

	if( stmt )
	{
		HB_USHORT uiCol = hb_parni( 1 );

		if( uiCol > 0 )
		{
			STMT_GETCOLTYPE( stmt, uiCol, &szColType );
		}
	}

	hb_retc_buffer( szColType );
}

/***
 * Devuelve el ancho de la columna
 */

HB_METHOD( TSTMT_GETCOLLEN )
{
	PSTMT stmt = hb_getStmt();
	HB_USHORT uiColLen = 0;

	if( stmt )
	{
		HB_USHORT uiCol = hb_parni( 1 );

		if( uiCol > 0 )
		{
			STMT_GETCOLLEN( stmt, uiCol, &uiColLen );
		}
	}

	hb_retni( uiColLen );
}

/***
 * Devuelve el numero de decimales en caso de un numero real
 */

HB_METHOD( TSTMT_GETCOLDEC )
{
	PSTMT stmt = hb_getStmt();
	HB_USHORT uiColDec = 0;

	if( stmt )
	{
		HB_USHORT uiCol = hb_parni( 1 );

		if( uiCol > 0 )
		{
			STMT_GETCOLDEC( stmt, uiCol, &uiColDec );
		}
	}

	hb_retni( uiColDec );
}

/***
 * Devuelve el la posicion de una columna por su nombre
 */

HB_METHOD( TSTMT_GETCOLPOS )
{
	PSTMT stmt = hb_getStmt();
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
	PSTMT stmt = hb_getStmt();
	PHB_ITEM paRes = hb_itemNew( NULL );

	if( stmt )
	{
		HB_TYPE xType = hb_parni( 1 );

		STMT_LISTCOLNAMES( stmt, xType, paRes );
	}

	hb_itemReturnRelease( paRes );
}


/***
 * Vincula una columna a una variable de Harbour
 */

HB_METHOD( TSTMT_BINDCOLUMN )
{
	PSTMT stmt = hb_getStmt();

	if( stmt )
	{
		STMT_BINDCOLUMN( stmt, hb_param( 1, HB_IT_NUMERIC | HB_IT_STRING ),
						 hb_param( 2, HB_IT_BYREF ), hb_parni( 3 ), hb_parni( 4 ) );
	}
}

/***
 * Vincula un parámetro al nombre de variable especificado
 */

HB_METHOD( TSTMT_BINDPARAM )
{
	PSTMT stmt = hb_getStmt();

	if( stmt )
	{
		STMT_BINDPARAM( stmt, hb_param( 1, HB_IT_NUMERIC | HB_IT_STRING ),
						hb_param( 2, HB_IT_BYREF ), hb_parni( 3 ), hb_parni( 4 ) );
	}
}

/***
 * Vincula un valor a un parámetro para una sentencia SQL
 */

HB_METHOD( TSTMT_BINDVALUE )
{
	PSTMT stmt = hb_getStmt();

	if( stmt )
	{
		STMT_BINDVALUE( stmt, hb_param( 1, HB_IT_NUMERIC | HB_IT_STRING ), hb_param( 2, HB_IT_ANY ) );
	}
}

/***
 * Cierra un cursor, habilitando a la sentencia para que sea ejecutada otra vez
 */

HB_METHOD( TSTMT_CLOSECURSOR )
{
	PSTMT stmt = hb_getStmt();
	HB_BOOL fRes = HB_FALSE;

	if( stmt )
	{
		STMT_CLOSECURSOR( stmt, &fRes ) ;
	}

	hb_retl( fRes );
}

/***
 * Devuelve el número de columnas de un conjunto de resultados
 */

HB_METHOD( TSTMT_COLUMNCOUNT )
{
	PSTMT stmt = hb_getStmt();
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
	PSTMT stmt = hb_getStmt();
	HB_USHORT nCount = 0;

	if( stmt )
	{
		STMT_BINDPARAMCOUNT( stmt, &nCount );
	}

	hb_retni( nCount );
}

/***
 * Devuelve el numero de parametros en la sentencia preparada
 */

HB_METHOD( TSTMT_PARAMCOUNT )
{
	PSTMT stmt = hb_getStmt();
	HB_USHORT nCount = 0;

	if( stmt )
	{
		STMT_PARAMCOUNT( stmt, &nCount );
	}

	hb_retni( nCount );
}

/***
 * Ejecuta una sentencia preparada
 */

HB_METHOD( TSTMT_EXECUTE )
{
	PSTMT stmt = hb_getStmt();
	HB_BOOL fRes = HB_FALSE;

	if( stmt )
	{
		STMT_EXECUTE( stmt, &fRes ) ;
	}

	hb_retl( fRes );
}

/***
 * Obtiene el SQLSTATE asociado con la última operación del gestor de sentencia
 */

HB_METHOD( TSTMT_ERRORCODE )
{
	PSTMT stmt = hb_getStmt();
	char *szRes = NULL;

	if( stmt )
	{
		STMT_ERRORCODE( stmt, &szRes );
	}

	hb_retc_buffer(  szRes );
}

/***
 * Obtiene información ampliada del error asociado con la última operación del
 * gestor de sentencia
 */

HB_METHOD( TSTMT_ERRORINFO )
{
	PSTMT stmt = hb_getStmt();
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
	PSTMT stmt = hb_getStmt();
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
	PSTMT stmt = hb_getStmt();

	if( stmt )
	{
		PHB_ITEM pResult = hb_itemNew( NULL );
		HB_USHORT uiFetchType = hb_parni( 1 );

		STMT_FETCH( stmt, pResult, uiFetchType );

		hb_itemReturnRelease( pResult );
	}
}

/***
 * Obtiene la siguiente fila de un conjunto de resultados como un:
 * FETCH_ARRAY: array
 */

HB_METHOD( TSTMT_FETCHARRAY )
{
	PSTMT stmt = hb_getStmt();

	if( stmt )
	{
		PHB_ITEM pResult = hb_itemNew( NULL );

		STMT_FETCHARRAY( stmt, pResult );

		hb_itemReturnRelease( pResult );
	}
}

/***
 * Obtiene la siguiente fila de un conjunto de resultados como un:
 * FETCH_HASH: hash table
 */

HB_METHOD( TSTMT_FETCHHASH )
{
	PSTMT stmt = hb_getStmt();

	if( stmt )
	{
		PHB_ITEM pResult = hb_itemNew( NULL );

		STMT_FETCHHASH( stmt, pResult );

		hb_itemReturnRelease( pResult );
	}
}

/***
 * Obtiene la siguiente fila de un conjunto de resultados como un:
 * FETCH_BOUND: actualiza variables xbase
 */

HB_METHOD( TSTMT_FETCHBOUND )
{
	PSTMT stmt = hb_getStmt();

	if( stmt )
	{
		hb_retl( STMT_FETCHBOUND( stmt ) == HB_SUCCESS ? HB_TRUE : HB_FALSE );
	}
	else
	{
		hb_retl( HB_FALSE );
	}
}

/***
 * Devuelve un array que contiene todas las filas del conjunto de resultados como:
 * FETCH_ARRAY: array
 * FETCH_HASH: hash table
 */

HB_METHOD( TSTMT_FETCHALL )
{
	PSTMT stmt = hb_getStmt();


	if( stmt )
	{
		HB_USHORT uiFetchType = hb_parni( 1 );
		PHB_ITEM pResult = hb_itemNew( NULL );

		STMT_FETCHALL( stmt, pResult, uiFetchType );

		hb_itemReturnRelease( pResult );
	}
}

/***
 * Devuelve un array que contiene todas las filas del conjunto de resultados como:
 * FETCH_ARRAY: array
 */

HB_METHOD( TSTMT_FETCHALLARRAY )
{
	PSTMT stmt = hb_getStmt();

	if( stmt )
	{
		PHB_ITEM pResult = hb_itemNew( NULL );

		STMT_FETCHALLARRAY( stmt, pResult );

		hb_itemReturnRelease( pResult );
	}
}

/***
 * Devuelve un array que contiene todas las filas del conjunto de resultados como:
 * FETCH_HASH: hash table
 */

HB_METHOD( TSTMT_FETCHALLHASH )
{
	PSTMT stmt = hb_getStmt();

	if( stmt )
	{
		PHB_ITEM pResult = hb_itemNew( NULL );

		STMT_FETCHALLHASH( stmt, pResult );

		hb_itemReturnRelease( pResult );
	}
}

/***
 * Devuelve objeto TRowSet con todas las filas del conjunto de resultados como:
 */

HB_METHOD( TSTMT_FETCHROWSET )
{
	PSTMT stmt = hb_getStmt();
	PHB_ITEM oRS = hb_itemNew( NULL );

	if( stmt )
	{
		if( STMT_FETCHROWSET( stmt, oRS ) != HB_SUCCESS )
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
	PSTMT stmt = hb_getStmt();

	if( stmt )
	{
		PHB_ITEM pRes = hb_itemNew( NULL );

		STMT_FETCHCOLUMN( stmt, hb_parni( 1 ), pRes );

		hb_itemReturnRelease( pRes );
	}
}

/***
 * Recupera un atributo de sentencia
 */

HB_METHOD( TSTMT_GETATTRIBUTE )
{
	PSTMT stmt = hb_getStmt();
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
	PSTMT stmt = hb_getStmt();
	PHB_ITEM aColMeta = hb_itemArrayNew( META_COL_SIZE );

	if( stmt )
	{
		PHB_ITEM pCol = hb_param( 1, HB_IT_INTEGER | HB_IT_STRING );

		switch( HB_ITEM_TYPE( pCol ) )
		{
			case HB_IT_INTEGER:
			{
				HB_INT nCol = hb_itemGetNI( pCol );

				if( nCol > 0 )
				{
					STMT_GETCOLUMNMETABYPOS( stmt, nCol, aColMeta );
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
	PSTMT stmt = hb_getStmt();
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
	PSTMT stmt = hb_getStmt();
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
	PSTMT stmt = hb_getStmt();
	HB_BOOL fRes = HB_FALSE;

	if( stmt )
	{
		STMT_SETATTRIBUTE( stmt, hb_parni( 1 ), hb_param( 2, HB_IT_ANY ), &fRes );
	}

	hb_retl( fRes );

}

/***
 * Establece el modo de obtención para esta sentencia
 */

HB_METHOD( TSTMT_SETFETCHMODE )
{
	PSTMT stmt = hb_getStmt();

	if( stmt )
	{
		hb_retl( STMT_SETFETCHMODE( stmt, hb_parni( 1 ) ) == HB_SUCCESS ? HB_TRUE : HB_FALSE );
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
	PSTMT stmt = hb_getStmt();

	if( stmt )
	{
		STMT_FREE( stmt );
	}
}

/***
 * Devuelve una única columna de la siguiente fila de un conjunto de resultados
 */

HB_METHOD( TSTMT_GETBYTE )
{
	PSTMT stmt = hb_getStmt();
	PHB_ITEM pRes = hb_itemNew( NULL );

	if( stmt )
	{
		STMT_GETBYTE( stmt, hb_parni( 1 ), pRes );
	}

	hb_itemReturnRelease( pRes );
}


/***
 * Devuelve una única columna de la siguiente fila de un conjunto de resultados
 */

HB_METHOD( TSTMT_GETSHORT )
{
	PSTMT stmt = hb_getStmt();
	PHB_ITEM pRes = hb_itemNew( NULL );

	if( stmt )
	{
		STMT_GETSHORT( stmt, hb_parni( 1 ), pRes );
	}

	hb_itemReturnRelease( pRes );
}


/***
 * Devuelve una única columna de la siguiente fila de un conjunto de resultados
 */

HB_METHOD( TSTMT_GETINT )
{
	PSTMT stmt = hb_getStmt();
	PHB_ITEM pRes = hb_itemNew( NULL );

	if( stmt )
	{
		STMT_GETINT( stmt, hb_parni( 1 ), pRes );
	}

	hb_itemReturnRelease( pRes );
}


/***
 * Devuelve una única columna de la siguiente fila de un conjunto de resultados
 */

HB_METHOD( TSTMT_GETLONG )
{
	PSTMT stmt = hb_getStmt();
	PHB_ITEM pRes = hb_itemNew( NULL );

	if( stmt )
	{
		STMT_GETLONG( stmt, hb_parni( 1 ), pRes );
	}

	hb_itemReturnRelease( pRes );
}


/***
 * Devuelve una única columna de la siguiente fila de un conjunto de resultados
 */

HB_METHOD( TSTMT_GETFLOAT )
{
	PSTMT stmt = hb_getStmt();
	PHB_ITEM pRes = hb_itemNew( NULL );

	if( stmt )
	{
		STMT_GETFLOAT( stmt, hb_parni( 1 ), pRes );
	}

	hb_itemReturnRelease( pRes );
}


/***
 * Devuelve una única columna de la siguiente fila de un conjunto de resultados
 */

HB_METHOD( TSTMT_GETDOUBLE )
{
	PSTMT stmt = hb_getStmt();
	PHB_ITEM pRes = hb_itemNew( NULL );

	if( stmt )
	{
		STMT_GETDOUBLE( stmt, hb_parni( 1 ), pRes );
	}

	hb_itemReturnRelease( pRes );
}


/***
 * Devuelve una única columna de la siguiente fila de un conjunto de resultados
 */

HB_METHOD( TSTMT_GETBOOLEAN )
{
	PSTMT stmt = hb_getStmt();
	PHB_ITEM pRes = hb_itemNew( NULL );

	if( stmt )
	{
		STMT_GETBOOLEAN( stmt, hb_parni( 1 ), pRes );
	}

	hb_itemReturnRelease( pRes );
}


/***
 * Devuelve una única columna de la siguiente fila de un conjunto de resultados
 */

HB_METHOD( TSTMT_GETSTRING )
{
	PSTMT stmt = hb_getStmt();
	PHB_ITEM pRes = hb_itemNew( NULL );

	if( stmt )
	{
		STMT_GETSTRING( stmt, hb_parni( 1 ), pRes );
	}

	hb_itemReturnRelease( pRes );
}


/***
 * Devuelve una única columna de la siguiente fila de un conjunto de resultados
 */

HB_METHOD( TSTMT_GETBYTES )
{
	PSTMT stmt = hb_getStmt();
	PHB_ITEM pRes = hb_itemNew( NULL );

	if( stmt )
	{
		STMT_GETBYTES( stmt, hb_parni( 1 ), pRes );
	}

	hb_itemReturnRelease( pRes );
}


/***
 * Devuelve una única columna de la siguiente fila de un conjunto de resultados
 */

HB_METHOD( TSTMT_GETDATE )
{
	PSTMT stmt = hb_getStmt();
	PHB_ITEM pRes = hb_itemNew( NULL );

	if( stmt )
	{
		STMT_GETDATE( stmt, hb_parni( 1 ), pRes );
	}

	hb_itemReturnRelease( pRes );
}


/***
 * Devuelve una única columna de la siguiente fila de un conjunto de resultados
 */

HB_METHOD( TSTMT_GETTIME )
{
	PSTMT stmt = hb_getStmt();
	PHB_ITEM pRes = hb_itemNew( NULL );

	if( stmt )
	{
		STMT_GETTIME( stmt, hb_parni( 1 ), pRes );
	}

	hb_itemReturnRelease( pRes );
}

/***
 * Devuelve una única columna de la siguiente fila de un conjunto de resultados
 */

HB_METHOD( TSTMT_GETTIMESTAMP )
{
	PSTMT stmt = hb_getStmt();
	PHB_ITEM pRes = hb_itemNew( NULL );

	if( stmt )
	{
		STMT_GETTIMESTAMP( stmt, hb_parni( 1 ), pRes );
	}

	hb_itemReturnRelease( pRes );
}

HB_METHOD( TSTMT_PUTNULL )
{
	PSTMT stmt = hb_getStmt();

	if( stmt )
	{
		STMT_PUTNULL( stmt, hb_param( 1, HB_IT_NUMERIC | HB_IT_STRING ) );
	}
}


HB_METHOD( TSTMT_PUTBYTE )
{
	PSTMT stmt = hb_getStmt();

	if( stmt )
	{
		STMT_PUTBYTE( stmt, hb_param( 1, HB_IT_NUMERIC | HB_IT_STRING ),
					  hb_param( 2, HB_IT_STRING ) );
	}
}


HB_METHOD( TSTMT_PUTSHORT )
{
	PSTMT stmt = hb_getStmt();

	if( stmt )
	{
		STMT_PUTSHORT( stmt, hb_param( 1, HB_IT_NUMERIC | HB_IT_STRING ),
					   hb_param( 2, HB_IT_NUMERIC ) );
	}
}


HB_METHOD( TSTMT_PUTINT )
{
	PSTMT stmt = hb_getStmt();

	if( stmt )
	{
		STMT_PUTINT( stmt, hb_param( 1, HB_IT_NUMERIC | HB_IT_STRING ),
					 hb_param( 2, HB_IT_NUMERIC ) );
	}
}


HB_METHOD( TSTMT_PUTLONG )
{
	PSTMT stmt = hb_getStmt();

	if( stmt )
	{
		STMT_PUTLONG( stmt, hb_param( 1, HB_IT_NUMERIC | HB_IT_STRING ),
					  hb_param( 2, HB_IT_NUMERIC ) );
	}
}


HB_METHOD( TSTMT_PUTFLOAT )
{
	PSTMT stmt = hb_getStmt();

	if( stmt )
	{
		STMT_PUTFLOAT( stmt, hb_param( 1, HB_IT_NUMERIC | HB_IT_STRING ),
					   hb_param( 2, HB_IT_NUMERIC ) );
	}
}


HB_METHOD( TSTMT_PUTDOUBLE )
{
	PSTMT stmt = hb_getStmt();

	if( stmt )
	{
		STMT_PUTDOUBLE( stmt, hb_param( 1, HB_IT_NUMERIC | HB_IT_STRING ),
						hb_param( 2, HB_IT_NUMERIC ) );
	}
}


HB_METHOD( TSTMT_PUTBOOLEAN )
{
	PSTMT stmt = hb_getStmt();

	if( stmt )
	{
		STMT_PUTBOOLEAN( stmt, hb_param( 1, HB_IT_NUMERIC | HB_IT_STRING ),
						 hb_param( 2, HB_IT_LOGICAL ) );
	}
}


HB_METHOD( TSTMT_PUTSTRING )
{
	PSTMT stmt = hb_getStmt();

	if( stmt )
	{
		STMT_PUTSTRING( stmt, hb_param( 1, HB_IT_NUMERIC | HB_IT_STRING ),
						hb_param( 2, HB_IT_STRING ) );
	}
}


HB_METHOD( TSTMT_PUTBYTES )
{
	PSTMT stmt = hb_getStmt();

	if( stmt )
	{
		STMT_PUTBYTES( stmt, hb_param( 1, HB_IT_NUMERIC | HB_IT_STRING ),
					   hb_param( 2, HB_IT_STRING ) );
	}
}


HB_METHOD( TSTMT_PUTDATE )
{
	PSTMT stmt = hb_getStmt();

	if( stmt )
	{
		STMT_PUTDATE( stmt, hb_param( 1, HB_IT_NUMERIC | HB_IT_STRING ),
					  hb_param( 2, HB_IT_DATE ) );
	}
}


HB_METHOD( TSTMT_PUTTIME )
{
	PSTMT stmt = hb_getStmt();

	if( stmt )
	{
		STMT_PUTTIME( stmt, hb_param( 1, HB_IT_NUMERIC | HB_IT_STRING ),
					  hb_param( 2, HB_IT_DATETIME ) );
	}
}


HB_METHOD( TSTMT_PUTTIMESTAMP )
{
	PSTMT stmt = hb_getStmt();

	if( stmt )
	{
		STMT_PUTTIMESTAMP( stmt, hb_param( 1, HB_IT_NUMERIC | HB_IT_STRING ),
						   hb_param( 2, HB_IT_TIMESTAMP ) );
	}
}


