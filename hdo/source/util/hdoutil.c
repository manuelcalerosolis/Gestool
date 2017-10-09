/***
 * Proyecto: Harbour Data Objects (HDO)
 * Fichero: hdoutil.c
 * Descripcion: Funciones la gestion de los metodos de las clases del proyecto
 * Autor: Manu Exposito 2015-17
 * Fecha: 15/01/2017
 */

#include "hdoapi.h"
#include "hbvm.h"

/*** ------------------ GESTION DE ERRORES Y EXCEPCIONES -------------------- */

/***
 * Devuelve el literal del error, estarara basado en un array de cadenas
 *
 */

static const char *hdo_descExcept( HB_ERRCODE errSubCode )
{
	static const char *aszMsg[] =
	{
		/* HDO_NOTERR       */  "No hay errores en HDO",
		/* HDO_NOTDB        */  "No existe la base de datos",
		/* HDO_NOTTB        */  "No exite la tabla",
		/* HDO_NOTMEMHDO    */  "No se ha podido crear la estructura HDO",
		/* HDO_NOTMEMSTMT   */  "No se ha podido crear la estructura STMT",
		/* HDO_NOTMEMRS     */  "No se ha podido crear la estructura RS",
		/* HDO_NOTMEMLC     */  "No se pudo crear estructura para el Cursor",
		/* HDO_NOTMEMATT    */  "No se pudo crear estructura para los atributos",
		/* HDO_NOTMEMPAR    */  "No se pudo crear estructura para los parametros",
		/* HDO_NUMCOLERR    */  "Numero de columna incorrecto",
		/* HDO_TYPEDATPAR   */  "Tipo de dato incorrecto en el parametro columna",
		/* HDO_NOTREFER     */  "Variable no pasada por referencia",
		/* HDO_NOTINTORSTR  */  "Parametro debe ser entero o cadena",
		/* HDO_NOTMEMORY    */  "No se ha podido reservar memoria",
		/* HDO_NOTCREAROW	*/	"No se ha creado el objeto RowSet. No hay conjunto de datos"
	};

	return errSubCode < HDO_LASTNUMERROR ? aszMsg[ errSubCode ] : "MSG UNDEFINED";
}

/***
 * Lanza excepciones en THDO
 * Esta basado en la clase nativa error de harbour ,
 */

static HB_ERRCODE hdo_throwGen( PHB_ITEM pError, const char *szSubSystem, HB_INT errSubCode, const char *szDesc )
{
	hb_errPutSubSystem( pError, szSubSystem ? szSubSystem : "SOFT4U" );
	hb_errPutSeverity( pError, ES_WARNING );
	hb_errPutSubCode( pError, errSubCode );
	hb_errPutDescription( pError, szDesc ? szDesc : hdo_descExcept( errSubCode ) );
	hb_errPutGenCode( pError, EG_NUMERR );
	hb_errPutOperation( pError, HB_ERR_FUNCNAME );
	hb_errPutOsCode( pError, 0 );
	hb_errPutFlags( pError, EF_CANDEFAULT );

	return hb_errLaunch( pError );
}

/***
 * Lanza excepciones en THDO si esta activa
 */

HB_ERRCODE hdo_throwException( PHDO hdo, HB_INT errSubCode, const char *szDes )
{
	if( hdo->pAttrib->uiErrMode == ERRMODE_THROW )
	{
		return hdo_throwGen( hdo->pError, "HDO", errSubCode, szDes );
	}

	return HB_SUCCESS;
}

/***
 * Lanza un error en THDO
 */

HB_ERRCODE hdo_throwError( PHDO hdo, HB_INT errSubCode, const char *szDes )
{
	return hdo_throwGen( hdo->pError, "HDO", errSubCode, szDes );
}

/***
 * Lanza un error fuera de THDO
 */

HB_ERRCODE hdo_throwErrOut( HB_INT errSubCode, const char *szDes )
{
	HB_ERRCODE ec;
	PHB_ITEM pError = hb_errNew();

	ec = hdo_throwGen( pError, NULL, errSubCode, szDes );

	hb_itemRelease( pError );

	return ec;
}

/*
 *  Pone en la variable szColType como caracter el tipo numerico al estilo de ITEM API
 */
HB_ERRCODE hdo_getTypeStr( HB_TYPE xType, char **szColType )
{
	switch( xType )
	{
		case HB_IT_STRING:
			*szColType = hb_strndup( "C", 1 );
			break;

		case HB_IT_LONG:
		case HB_IT_INTEGER:
		case HB_IT_DOUBLE:
			*szColType = hb_strndup( "N", 1 );
			break;

		case HB_IT_LOGICAL:
			*szColType = hb_strndup( "L", 1 );
			break;

		case HB_IT_DATE:
			*szColType = hb_strndup( "D", 1 );
			break;

		case HB_IT_TIMESTAMP:
			*szColType = hb_strndup( "T", 1 );
			break;

		case HB_IT_MEMO:
			*szColType = hb_strndup( "M", 1 );
			break;

		default:
			*szColType = hb_strndup( "U", 1 );
			return HB_FAILURE;
	}

	return HB_SUCCESS;
}

/*
 * Basado en ALLTRIM de Harbour
 */

HB_ERRCODE hdo_allTrim2( PHB_ITEM pText, PHB_ITEM pAllTrimText )
{
	HB_SIZE nLen, nSrc;
	const char *szText = hb_itemGetCPtr( pText );

	nSrc = hb_itemGetCLen( pText );
	nLen = hb_strRTrimLen( szText, nSrc, HB_FALSE );
	szText = hb_strLTrim( szText, &nLen );

	if( nLen == nSrc )
	{
		hb_itemCopy( pAllTrimText, pText );
	}
	else
	{
		hb_itemPutCL( pAllTrimText, szText, nLen );
	}

	return HB_SUCCESS;
}

/*
 * Basado en ALLTRIM de Harbour
 */

HB_ERRCODE hdo_allTrim( PHB_ITEM pText )
{
	HB_SIZE nLen, nSrc;
	const char *szText = hb_itemGetCPtr( pText );

	nSrc = hb_itemGetCLen( pText );
	nLen = hb_strRTrimLen( szText, nSrc, HB_FALSE );
	szText = hb_strLTrim( szText, &nLen );

	if( nLen != nSrc )
	{
		hb_itemPutCL( pText, szText, nLen );
	}

	return HB_SUCCESS;
}

/*
 * Devuelve un item nulo
 * En versiones viejas de Harbour no estaba implementado, en las recientes si,
 * es esta: PHB_ITEM hb_itemPutNil( PHB_ITEM pItem )
 */

PHB_ITEM hdo_itemPutNil( PHB_ITEM pItem )
{
	if( pItem )
	{
		hb_itemSetNil( pItem );
	}
	else
	{
		pItem = hb_itemNew( NULL );
	}

	return pItem;
}

/*
 * Devuelve un objeto JSon a partir de un Hash table pasado
 */
void hdo_jsonEncode( PHB_ITEM pHash )
{
	static PHB_DYNS s_pSymJSon;

	if( !s_pSymJSon )
	{
		s_pSymJSon = hb_dynsymFind( "HB_JSONENCODE" );
	}

	if( pHash )
	{
		if( s_pSymJSon )
		{
			hb_vmPushDynSym( s_pSymJSon );
			hb_vmPushNil();
			hb_vmPush( pHash );

			hb_vmFunction( 1 );
		}
	}
}

/*
 * Reasigma la memoria
 */
void *hdo_reGrab( void *p, HB_ULONG ulSize )
{
	if( p )
	{
		hb_xfree( p );
	}

	return hb_xgrab( ulSize );
}
