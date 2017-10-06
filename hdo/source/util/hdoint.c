/*
 * Proyecto: Harbour Data Objects (HDO)
 * Fichero: hdoint.c
 * Descripcion: Funciones la gestion de los metodos de las clases del proyecto
 * Autor: Manu Exposito 2015-17
 * Fecha: 15/01/2017
 */

#include "hdoapi.h"
#include "hbvm.h"

/***
 * Uso: Hereda los miembros de la tabla de metodos nulos o sea, no sobreescritos
 * con los metodos por defecto de la clase superior.
 */

void hdo_inheritMethods( void *self_vtbl, void *super_vtbl, HB_UINT uiCount )
{
	HB_UINT uiCounter;
	HDOMETHOD *pSelfMethod  = ( HDOMETHOD * ) self_vtbl;
	HDOMETHOD *pSuperMethod = ( HDOMETHOD * ) super_vtbl;

	for( uiCounter = 0; uiCounter < uiCount; uiCounter++, pSelfMethod++, pSuperMethod++ )
	{
		if( *pSelfMethod == NULL )
		{
			*pSelfMethod = *pSuperMethod;
		}
	}
}

/***
 * Carga los metodos del RDL a partir del parametro con el nombre de DBMS
 */

HB_ERRCODE hdo_setMethod( PHDO hdo, const char *szDBMS, HB_USHORT uiLen )
{
	PHB_ITEM pd = hdo_listRDL();

	if( pd && szDBMS && uiLen )
	{
		PHB_ITEM pDBMS = hb_itemNew( NULL );
		char *szUpperDBMS = ( char * ) HDO_ALLOC( uiLen + 1 );

		hb_strncpyUpperTrim( szUpperDBMS, szDBMS, uiLen );
		hb_itemPutCConst( pDBMS, szUpperDBMS );

		hdo->pAttrib->szRDLName = hb_strdup( hb_itemGetCPtr( hb_hashGetItemPtr( pd, pDBMS, HB_HASH_AUTOADD_ACCESS ) ) );

		HDO_FREE( szUpperDBMS );
		HDO_ITEM_FREE( pDBMS );
	}
	else
	{
		/* Ojo se asigna el RDLDEFAULT */
		hdo->pAttrib->szRDLName = hb_strndup( "RDLDEFAULT", 10 );
	}

	HDO_ITEM_FREE( pd );

	hdo->methods = ( PRDL_METHOD ) HDO_ALLOC( sizeof( RDL_METHOD ) );

	if( hdo->methods )
	{
		PHB_DYNS s_pSymRDL = hb_dynsymFind( hdo->pAttrib->szRDLName );

		hdo->methods->mthdHDO = NULL;
		hdo->methods->mthdStmt = NULL;
		hdo->methods->mthdRS = NULL;

		if( s_pSymRDL )
		{
			hb_vmPushDynSym( s_pSymRDL );
			hb_vmPushNil();
			hb_vmFunction( 0 );

			hdo->methods->mthdHDO = hb_itemGetPtr( hb_stackReturnItem() );
		}
		else
		{
			/* Ojo se asigna el RDLDEFAULT */
			hdo->methods->mthdHDO = hdo_getDefMethods();
			hdo_throwError( hdo, 999, "RDL no existe, cargada RDLDEFAULT" );
		}

		/* Asigna los metodos especificos de la RDL */
		HDO_SETFUNCMETHODS( hdo );

		return HB_SUCCESS;
	}

	hdo_throwError( hdo, 999, "No se ha creado la estructura RDL_METHODS" );
	
	return HB_FAILURE;
}

//==============================================================================
// Inicializa los simbolos de las clase en la tabla de simbolos de harbour para
// que las clases en C puedan ser usadas en la herencia desde PRG
//

HB_INIT_SYMBOLS_BEGIN( HDO__InitSymbols )
{ "TRDL",    { HB_FS_PUBLIC | HB_FS_LOCAL }, { HB_FUNCNAME( TRDL ) },    NULL },
{ "THDO",    { HB_FS_PUBLIC | HB_FS_LOCAL }, { HB_FUNCNAME( THDO ) },    NULL },
{ "TSTMT",   { HB_FS_PUBLIC | HB_FS_LOCAL }, { HB_FUNCNAME( TSTMT ) },   NULL },
{ "TROWSET", { HB_FS_PUBLIC | HB_FS_LOCAL }, { HB_FUNCNAME( TROWSET ) }, NULL }
HB_INIT_SYMBOLS_END( HDO__InitSymbols )

#if defined( HB_PRAGMA_STARTUP )
	#pragma startup HDO__InitSymbols
#elif defined( HB_DATASEG_STARTUP )
	#define HB_DATASEG_BODY HB_DATASEG_FUNC( HDO__InitSymbols )
	#include "hbiniseg.h"
#endif

//==============================================================================