/*
 * Proyecto: Harbour Data Objects (HDO)
 * Fichero: extDRL.c
 * Descripcion:
 * Autor: Manu Exposito 2015-17
 * Fecha:15/08/2016
 */

#include "hdoapi.h"

/***
 * Lista de RDL disponibles.
 * Es mejor separarlo de todos los fuentes C para mayor claridad
 * Aqui se irán añadiendo los nuevos RDL
 */

PHB_ITEM hdo_listRDL()
{
	PHB_ITEM pd = hb_hashNew( NULL );
	PHB_ITEM pKey = hb_itemNew( NULL );
	PHB_ITEM pValue = hb_itemNew( NULL );

	hb_hashClearFlags( pd, HB_HASH_BINARY );
	hb_hashSetFlags( pd, HB_HASH_IGNORECASE | HB_HASH_RESORT );

	/* Estos son RDL previstos */

	/* DEFRDL */
	hb_itemPutCConst( pKey, "DEFRDL" );
	hb_itemPutCConst( pValue, "RDLDEFAULT" );
	hb_hashAdd( pd, pKey, pValue );

	/* SQLITE */
	hb_itemPutCConst( pKey, "SQLITE" );
	hb_itemPutCConst( pValue, "RDLSQLITE" );
	hb_hashAdd( pd, pKey, pValue );

	/* MYSQL/MARIADB */
	hb_itemPutCConst( pKey, "MYSQL" );
	hb_itemPutCConst( pValue, "RDLMYSQL" );
	hb_hashAdd( pd, pKey, pValue );
	
	/*

		// POSTGRESQL
	    hb_itemPutCConst( pKey, "POSTGRES" );
		hb_itemPutPtr( pValue, hdo_PGMethods );
	    hb_hashAdd( pd, pKey, pValue );

		// ODBC/iODBC/LinuxODBC
	    hb_itemPutCConst( pKey, "ODBC" );
	    hb_itemPutPtr( pValue, hdo_ODBCMethods );
	    hb_hashAdd( pd, pKey, pValue );

	    // FIREBIRD/INTERBASE
	    hb_itemPutCConst( pKey, "FIREBIRD" );
	    hb_itemPutPtr( pValue, hdo_FbMethods );
	    hb_hashAdd( pd, pKey, pValue );

	    // ORACLE (OCI/OCILib)
	    hb_itemPutCConst( pKey, "ORACLE" );
	    hb_itemPutPtr( pValue, hdo_OCIMethods );
	    hb_hashAdd( pd, pKey, pValue );
	*/

	hb_itemRelease( pKey );
	hb_itemRelease( pValue );

	return pd;
}

