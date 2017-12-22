/***
 * Proyecto: Harbour Data Objects (HDO)
 * Fichero: hdo.c
 * Descripcion: Implementacion de la clase THDo, gestion de la conexion y BD
 * Autor: Manu Exposito 2015-17
 * Fecha: 15/01/2017
 */

/* Ficheros include */

#include "hdo.h"

/* Definicion de la clase con atributos y metodos */

CREATE_CLASS( "THDO", THDO, THDO_IVARCOUNT )
{
	/* Metodos */
	METHOD( "NEW",              THDO_NEW )
	METHOD( "CONNECT",          THDO_CONNECT )
	METHOD( "DISCONNECT",       THDO_DISCONNECT ) 	// Sinonimo de FREE
	METHOD( "FREE",          	 THDO_DISCONNECT )	// Sinonimo de DISCONNECT
	METHOD( "EXEC",             THDO_EXEC )			// Sinonimo de execDirect
	METHOD( "EXECDIRECT",       THDO_EXEC )			// Sinonimo de exec
	METHOD( "PREPARE",          THDO_PREPARE )
	METHOD( "QUERY",            THDO_QUERY )
	METHOD( "LASTINSERTID",     THDO_LASTINSERTID )
	METHOD( "BEGINTRANSACTION", THDO_BEGINTRANSACTION )
	METHOD( "COMMIT",           THDO_COMMIT )
	METHOD( "INTRANSACTION",    THDO_INTRANSACTION )
	METHOD( "ROLLBACK",         THDO_ROLLBACK )
	METHOD( "SETATTRIBUTE",     THDO_SETATTRIBUTE )
	METHOD( "GETATTRIBUTE",     THDO_GETATTRIBUTE )
	METHOD( "ERRORCODE",        THDO_ERRORCODE )
	METHOD( "ERRORINFO",        THDO_ERRORINFO )
	METHOD( "ESCAPESTR",        THDO_ESCAPESTR )
	/* Get de atributos (solo lectura) */
	METHOD( "RDLINFO",          THDO_RDLINFO )
	METHOD( "GETHANDLE",        THDO_GETHANDLE )
	METHOD( "GETRDLNAME",       THDO_GETRDLNAME )
	METHOD( "GETDBNAME",        THDO_GETDBNAME )
	METHOD( "GETHOST",          THDO_GETHOST )
	METHOD( "GETUSER",          THDO_GETUSER )
	METHOD( "GETPASSWORD",      THDO_GETPASSWORD )
}
END_CLASS

/* Implementacion de la clase */

/***
 * Metodo: NEW
 * Uso: Constructor de la clase
 * Devuelve: Self
 */

HB_METHOD( THDO_NEW )
{
	PHB_ITEM pSelf = hb_pSelf();
	PHDO hdo = HDOInit();

	if( hdo )
	{
		/* Asigna el nombre del RDL -> setRDLName( hdo, RDLName, RDLNameLen ) */
		setRDLName( hdo, hb_parc( 1 ), hb_parclen( 1 ) );
		/* Asigna los metos especificos de la RDL */
		HDO_SETFUNCMETHODS( hdo );
		/* Ejecuta el metodo init de la RDL especifica */
		HDO_INIT( hdo );
		
		/* MUY IMPORTANTE: Asigna la estructura recien creada a la clase */
		hb_arraySetPtr( pSelf, IVAR_HDO, hdo );
	}
	else
	{
		hdo_throwErrNew( HDO_NOTMEMHDO, NULL );
	}

	/* Un constructor siempre devuelve SELF */
	hb_itemReturnRelease( pSelf );
}

/***
 * Metodo: CONNECT
 * Uso: Hace la conexion con la base de datos, hay bases de datos que no
 *      necesitan todos los parametros por los que no habrá que pasarle ese
 *      parametro o sencillamente el gestor de la base de datos los marginará.
 *      por ejemplo SQLite solo necesita el nombre de la base de datos.
 * Parametros: szDbName, szHost, szUser, szPasswd, fRes
 * Devuelve:
 */

HB_METHOD( THDO_CONNECT )
{
	PHDO hdo = hb_getHDO();
	HB_BOOL fRes = HB_FALSE;

	if( hdo )
	{
		HDO_CONNECT( hdo, hb_parc( 1 ), hb_parc( 2 ), hb_parc( 3 ), hb_parc( 4 ), &fRes );
	}

	hb_retl( fRes );
}

/***
 * Metodo: DISCONNECT
 * Uso: Desconecta y libera memoria. Es una especie de destructor
 * Parametros:void
 * Devuelve: Si se consiguio la desconexion.
 */

HB_METHOD( THDO_DISCONNECT )
{
	PHDO hdo = hb_getHDO();
	HB_BOOL fRes = HB_FALSE;

	if( hdo )
	{
		HDO_DISCONNECT( hdo, &fRes );
	}

	hb_retl( fRes );
}

/***
 * Metodo: EXEC
 * Uso: Ejecuta una sentencia que no devuelve un conjunto de regisatros ej.: insert
 * Parametros: Cadena con la sentencia
 * Devuelve: numero de registros afectados
 */

HB_METHOD( THDO_EXEC )
{
	PHDO hdo = hb_getHDO();
	HB_ULONG ulRes = 0;

	if( hdo )
	{
		HDO_EXEC( hdo, hb_parc( 1 ), &ulRes );
	}

	hb_retnl( ulRes );
}

/***
 * Metodo: PREPARE
 * Uso: Prepara una sentencia
 * Parametros: Cadena con la sentencia
 * Devuelve: Objeto TStmt
 */

HB_METHOD( THDO_PREPARE )
{
	PHDO hdo = hb_getHDO();
	PHB_ITEM oStmt = NULL;

	if( hdo )
	{
		HB_CREATE_OBJECT( TSTMT, oStmt ); /* Crea el objeto oStmt */
		HDO_PREPARE( hdo, hb_parc( 1 ), hb_parclen( 1 ), oStmt );
	}

	hb_itemReturnRelease( oStmt );
}

/***
 * Metodo: QUERY
 * Uso: Prepara y ejecuta una sentencia
 * Parametros: Cadena con la sentencia
 * Devuelve: Objeto TStmt
 */

HB_METHOD( THDO_QUERY )
{
	PHDO hdo = hb_getHDO();
	PHB_ITEM oStmt = NULL;

	if( hdo )
	{
		HB_CREATE_OBJECT( TSTMT, oStmt ); /* Crea el objeto oStmt */
		HDO_QUERY( hdo, hb_parc( 1 ), hb_parclen( 1 ), oStmt );
	}

	hb_itemReturnRelease( oStmt );
}

/***
 * Metodo: LASTINSERTID
 * Uso: Ultimo valor de los campos auto incrementales
 * Devuelve: Entero largo con el ultimo incremento
 */

HB_METHOD( THDO_LASTINSERTID )
{
	PHDO hdo = hb_getHDO();
	PHB_ITEM pRes = hb_itemNew( NULL );

	if( hdo )
	{
		HDO_LASTINSERTID( hdo, hb_parc( 1 ), pRes );
	}

	hb_itemReturnRelease( pRes );
}

/***
 * Metodo: BEGINTRANSACTION
 * Uso: Comienza una transaccion
 * Devuelve: Si consigue la ejecucion del comienzo de la transaccion
 */

HB_METHOD( THDO_BEGINTRANSACTION )
{
	PHDO hdo = hb_getHDO();
	HB_BOOL fRes = HB_FALSE;

	if( hdo )
	{
		HDO_BEGINTRANSACTION( hdo, &fRes );
	}

	hb_retl( fRes );
}

/***
 * Metodo: INTRANSACTION
 * Uso: Saber si existe una transaccion
 * Devuelve: Valor logico
 */

HB_METHOD( THDO_INTRANSACTION )
{
	PHDO hdo = hb_getHDO();
	HB_BOOL fRes = HB_FALSE;

	if( hdo )
	{
		HDO_INTRANSACTION( hdo, &fRes );
	}

	hb_retl( fRes );
}

/***
 * Metodo: COMMIT
 * Uso: Termina la transaccion
 * Parametros: ninguno
 * Devuelve: Valor logico si se consigio
 */

HB_METHOD( THDO_COMMIT )
{
	PHDO hdo = hb_getHDO();
	HB_BOOL fRes = HB_FALSE;

	if( hdo )
	{
		HDO_COMMIT( hdo, &fRes );
	}

	hb_retl( fRes );
}

/***
 * Metodo: ROLLBACK
 * Uso: deshace lo hecho en una transaccion
 * Parametros: no
 * Devuelve: Valor logico si se consigio
 */

HB_METHOD( THDO_ROLLBACK )
{
	PHDO hdo = hb_getHDO();
	HB_BOOL fRes = HB_FALSE;

	if( hdo )
	{
		HDO_ROLLBACK( hdo, &fRes );
	}

	hb_retl( fRes );
}

/***
 * Metodo: GETATTRIBUTE
 * Uso: Saber el valor de los atributos parametrizables
 * Parametros: el parametro
 * Devuelve: Valor del atributo
 */

HB_METHOD( THDO_GETATTRIBUTE )
{
	PHDO hdo = hb_getHDO();
	PHB_ITEM pVal = hb_itemNew( NULL );

	if( hdo )
	{
		HDO_GETATTRIBUTE( hdo, hb_parni( 1 ), pVal );
	}

	hb_itemReturnRelease( pVal );
}

/***
 * Metodo: SETATTRIBUTE
 * Uso: Actuliza un atributo
 * Parametros: el parametro
 * Devuelve: logico si se consigio o no
 */

HB_METHOD( THDO_SETATTRIBUTE )
{
	PHDO hdo = hb_getHDO();
	HB_BOOL fRes = HB_FALSE;

	if( hdo )
	{
		HDO_SETATTRIBUTE( hdo, hb_parni( 1 ), hb_param( 2, HB_IT_ANY ), &fRes );
	}

	hb_retl( fRes );
}

/***
 * Metodo: ERRORCODE
 * Uso: Saber si ha habido algún error
 * Parametros: no
 * Devuelve: Codigo del error o "000" si no hay
 */

HB_METHOD( THDO_ERRORCODE )
{
	PHDO hdo = hb_getHDO();
	char *szRes = NULL;

	if( hdo )
	{
		HDO_ERRORCODE( hdo, &szRes );
	}

	hb_retc_buffer( szRes );
}

/***
 * Metodo: ERRORINFO
 * Uso: Informacion con el error si lo hay
 * Parametros: no
 * Devuelve: Array con la informacion sobre el error
 */

HB_METHOD( THDO_ERRORINFO )
{
	PHDO hdo = hb_getHDO();
	PHB_ITEM paRes = hb_itemArrayNew( ERR_INFO_SIZE );

	if( hdo )
	{
		HDO_ERRORINFO( hdo, paRes );
	}

	hb_itemReturnRelease( paRes );
}

/***
 * Metodo: ESCAPESTR
 * Uso: Garantiza que el gestor entienda el valor que se quiere actualizar quitando secuencias de escape
 * Parametros: Cadena sin escapar
 * Devuelve: Cadena escapa
 */

HB_METHOD( THDO_ESCAPESTR )
{
	PHB_ITEM pStr = hb_param( 1, HB_IT_STRING );

	if( pStr )
	{
		PHDO hdo = hb_getHDO();

		if( hdo )
		{
			HB_USHORT uiLen = hb_itemGetCLen( pStr );
			char *szRet = ( char * ) HDO_ALLOC( ( uiLen * 2 ) + 1 );

            if( szRet )
            {
                HDO_ESCAPESTR( hdo, hb_itemGetCPtr( pStr ), uiLen, szRet );

                hb_retc_buffer( szRet );
            }
            else
            {
                hdo_throwError( hdo, HDO_NOTMEMORY, NULL );
            }
		}
	}
	else
	{
		hb_retc_null();
	}
}

/***
 * Metodo: RDLINFO
 * Uso: Informa del RDL
 * Parametros: no
 * Devuelve: Array con al informacion del RDL
 */

HB_METHOD( THDO_RDLINFO )
{
	PHDO hdo = hb_getHDO();
	PHB_ITEM paRDLInfo = hb_itemArrayNew( RDL_INFO_SIZE );

	if( hdo )
	{
		HDO_RDLINFO( hdo, paRDLInfo );
	}

	hb_itemReturnRelease( paRDLInfo );
}

/***
 * Metodo:
 * Uso:
 * Parametros:
 * Devuelve:
 */

HB_METHOD( THDO_GETHANDLE )
{
	PHDO hdo = hb_getHDO();
	void *hConn = NULL;

	if( hdo )
	{
		HDO_GETHANDLE( hdo, &hConn );
	}

	hb_retptr( hConn );
}

/***
 * Metodo:
 * Uso:
 * Parametros:
 * Devuelve:
 */

HB_METHOD( THDO_GETRDLNAME )
{
	PHDO hdo = hb_getHDO();
	char *szDrName = NULL;

	if( hdo )
	{
		HDO_GETRDLNAME( hdo, &szDrName );
	}

	hb_retc_buffer( szDrName );
}

/***
 * Metodo:
 * Uso:
 * Parametros:
 * Devuelve:
 */

HB_METHOD( THDO_GETDBNAME )
{
	PHDO hdo = hb_getHDO();
	char *szDbName = NULL;

	if( hdo )
	{
		HDO_GETDBNAME( hdo, &szDbName );
	}

	hb_retc_buffer( szDbName );
}

/***
 * Metodo:
 * Uso:
 * Parametros:
 * Devuelve:
 */

HB_METHOD( THDO_GETHOST )
{
	PHDO hdo = hb_getHDO();
	char *szHost = NULL;

	if( hdo )
	{
		HDO_GETHOST( hdo, &szHost );
	}

	hb_retc_buffer( szHost );
}

/***
 * Metodo:
 * Uso:
 * Parametros:
 * Devuelve:
 */

HB_METHOD( THDO_GETUSER )
{
	PHDO hdo = hb_getHDO();
	char *szUser = NULL;

	if( hdo )
	{
		HDO_GETUSER( hdo, &szUser );
	}

	hb_retc_buffer( szUser );
}

/***
 * Metodo:
 * Uso:
 * Parametros:
 * Devuelve:
 */

HB_METHOD( THDO_GETPASSWORD )
{
	PHDO hdo = hb_getHDO();
	char *szPsswd = NULL;

	if( hdo )
	{
		HDO_GETPASSWORD( hdo, &szPsswd );
	}

	hb_retc_buffer( szPsswd );
}

