/***
 * Proyecto: Harbour Data Objects (HDO)
 * Fichero: hdoRDL.c
 * Descripcion: Gestion de de RDLs
 * Autor: Manu ExGETPOSito 2015-17
 * Fecha: 15/01/2017
 */

/*
 * Notas:
 * Actualmente solo tiene una DATA de solo lectura con una tabla Hash
 * { NOMBRE_RDL => PUNTERO_FUNCION_METODOS }
 *
 * Al registrar el nodo deberian quedar resueltas las tablas virtuales de metodos
 *
 * Para el nuevo sistema se usara una estructura NODO -> LISTRDLNODE y NODOS -> RDLNODE
 * Crear por getNode o findRDL
 * Quitar METHOD( "GETPFUNCBYNAME",   TRDL_GETPFUNCBYNAME )
 * Crear getHDOMethods, getSTMTMethods y getRSMethods
 */

#include "hdordl.h"

/***
 * Definicion de la clase con atributos y metodos
 */

CREATE_CLASS( "TRDL", TRDL, TRDL_IVARCOUNT )
{
	/* Metodos */
	METHOD( "NEW",              TRDL_NEW )
	METHOD( "REGISTER",         TRDL_REGISTER )
	METHOD( "LIST",             TRDL_LIST )
	METHOD( "ISREGISTERED",     TRDL_ISREGISTERED )
	METHOD( "GETPOS",           TRDL_GETPOS )
	METHOD( "GETNAME",          TRDL_GETNAME )
	METHOD( "GETPFUNCBYNAME",   TRDL_GETPFUNCBYNAME )							
}
END_CLASS

/***
 * Metodo: NEW
 * Uso: Constructor de la clase
 * Parametros: Ninguno
 * Devuelve: Self, un objeto inicializado
 */

HB_METHOD( TRDL_NEW )
{
	PHB_ITEM pSelf = hb_pSelf();
	PHB_ITEM pd = hdo_listRDL();

	hb_arraySetForward( pSelf, IVAR_HASHRDL, pd );
	hb_itemRelease( pd );

	/* Devuelve SELF */
	hb_itemReturnRelease( pSelf );
}

/***
 * Metodo: LIST
 * Uso: Consulta de RDL registrados
 * Parametros: Ninguno
 * Devuelve: Array con los RDLs registrados
 */

HB_METHOD( TRDL_LIST )
{
	PHB_ITEM pd = hb_getHRDL();

	if( pd )
	{
		hb_itemReturnRelease( hb_hashGetValues( pd ) );
	}
	else
	{
		hb_reta( 0 );
	}
}

/***
 * Metodo: REGISTER
 * Uso: Registra un RDL si no existe
 * Parametros: El nombre del RDL y un puntero a la funcion del RDL
 * Devuelve: Nada
 */

HB_METHOD( TRDL_REGISTER )
{
	PHB_ITEM pd = hb_getHRDL();

	if( pd )
	{
		PHB_ITEM pKey = hb_param( 1, HB_IT_STRING );
		PHB_ITEM pValue = hb_param( 2, HB_IT_POINTER );

		if( pKey )
		{
			hb_hashAdd( pd, pKey, pValue );
		}
	}
}

/***
 * Metodo: ISREGISTERED
 * Uso: Comprueba si un RDL esta registrado
 * Parametros: Nombre del RDL
 * Devuelve: Valor logico indicando si existe o no
 */

HB_METHOD( TRDL_ISREGISTERED )
{
	PHB_ITEM pd = hb_getHRDL();
	HB_BOOL bRet = HB_FALSE;

	if( pd )
	{
		PHB_ITEM pKey = hb_param( 1, HB_IT_STRING );

		if( pKey )
		{
			bRet = ( hb_hashGetCItemPos( pd, pKey ) != 0 );
		}
	}

	hb_retl( bRet );
}

/***
 * Metodo: GETPOS
 * Uso: Comprueba la posicion que ocupa un RDL
 * Parametros: Nombre del RDL
 * Devuelve: La posicion o 0 encaso de no estar registrado
 */

HB_METHOD( TRDL_GETPOS )
{
	PHB_ITEM pd = hb_getHRDL();
	HB_SIZE nRet = 0;

	if( pd )
	{
		PHB_ITEM pKey = hb_param( 1, HB_IT_STRING );

		if( pKey )
		{
			nRet = hb_hashGetCItemPos( pd, pKey );
		}
	}

	hb_retni( nRet );
}

/***
 * Metodo: GETNAME
 * Uso: Consultar el nombre de un RDL por la posicion que ocupa
 * Parametros: Entero positivo
 * Devuelve: El nombre del RDL si esta registrado o NULL si no lo esta
 */

HB_METHOD( TRDL_GETNAME )
{
	PHB_ITEM pd = hb_getHRDL();
	PHB_ITEM pRet = NULL;

	if( pd )
	{
		HB_USHORT nPos = hb_parni( 1 );

		if( nPos >= 1 )          /* Controlar el LEN del array */
		{
			pRet = hb_hashGetKeyAt( pd, nPos );
		}
	}

	if( pRet )
	{
		hb_itemReturn( pRet );
	}
	else
	{
		hb_retc_null();
	}
}

/***
 * Metodo: GETPFUNCBYNAME
 * Uso: Comprueba la posicion que ocupa un RDL
 * Parametros: Nombre del RDL
 * Devuelve: La posicion o NULL encaso de no estar registrado
 */

HB_METHOD( TRDL_GETPFUNCBYNAME )
{
	PHB_ITEM pd = hb_getHRDL();
	PHB_ITEM pValue = NULL;

	if( pd )
	{
		PHB_ITEM pKey = hb_param( 1, HB_IT_STRING );

		if( pKey )
		{
			pValue = hb_hashGetItemPtr( pd, pKey, HB_HASH_AUTOADD_ACCESS );
		}
	}

	if( pValue )
	{
		hb_itemReturn( pValue );
	}
	else
	{
		hb_retc_null();
	}
}
