/*
 * Proyecto: hdo
 * Fichero: hdocommon.ch
 * Descripci�n: Fichero usado tanto para definiciones en harbour como en C
 * Autor:
 * Fecha: 05/12/2015
 */

#ifndef HDOCOMMON_CH_
#define HDOCOMMON_CH_

/* Definicion de Constantes */
#define HDO_VERSION             "2017.03"

#define HDO_MSG_CONNECTED       "Connected"
#define HDO_MSG_NOTCONNECTED    "Not connected"
#define HDO_MSG_DEF_SERVER      "SQLDefault Server"
#define HDO_MSG_SERVER_VER      "SQLDefault Server 2017.03"
#define HDO_MSG_CLIENT_VER      "SQLDefault Client 2017.03"

/* Para el metodo rdlInfo */
#define RDL_NAME                1   /* Nombre */
#define RDL_VER                 2   /* Version */
#define RDL_DES                 3   /* Pequeña descripcion */
#define RDL_OBS                 4   /* Observaciones */

#define RDL_INFO_SIZE           4   /* Observaciones */

/* Para el metodo errorInfo */
#define ERR_SQLSTATE            1   /* Status standard */
#define ERR_CODE                2   /* Codigo SQL nativo */
#define ERR_MSG                 3   /* Mensaje del error SQL nativo */

#define ERR_INFO_SIZE           3   /* Mensaje del error SQL nativo */

/* Para metacolumn */
#define META_COL_NAME           1   /* Nombre de la columna*/
#define META_COL_TYPE           2   /* Tipo xBase */
#define META_COL_LEN            3   /* Precision o ancho máximo */
#define META_COL_DEC            4   /* Escala o numero de decimales */
#define META_COL_INDEX          5   /* Orden en el resultado */
#define META_COL_TABLE          6   /* Tabla a la que pertenece */
#define META_COL_NATTYPE        7   /* Tipo SQL nativo */
#define META_COL_AUTOINC        8   /* Verdad si es autoincremental */
#define META_COL_NOTNULL        9   /* Verdad si no puede ser nulo */
#define META_COL_PK             10  /* Verdad si forma parte de la primary key */

#define META_COL_SIZE           10  /* Numero de elementos del array de MetaDatos */

/* Tipo array de nombres de campo */
#define AS_ARRAY                1   /* Basado en array */
#define AS_HASH                 2   /* Basado en tabla hash (por defecto) */

/* Para los atributos HDO */
#define ATTR_AUTOCOMMIT         1   /* Establece el autocommit */
#define ATTR_CASE               2   /* getColName y getColMeta: 0 -> natural | 1 -> mayuscula | 2 -> minuscula */
#define ATTR_TIMEOUT            3   /* Tiempo de espera  */
#define ATTR_CONNECTION_STATUS  4   /* Estado de la conexion */
#define ATTR_ERRMODE            5   /* Control de errores: False -> SILENT | True -> WARNING / EXCEPTION */
#define ATTR_SERVER_VERSION     6   /* Version servidor */
#define ATTR_CLIENT_VERSION     7   /* Version cliente */
#define ATTR_RDL_NAME           8   /* Nombre del RDL */
#define ATTR_SERVER_INFO        9   /* Informacion del servidor */
/* Por implementar:
#define ATTR_STR_TO_NULLS
#define ATTR_PERSISTENT
#define ATTR_PREFETCH
*/
/* Valores para ATTR_CASE */
#define CASE_LOWER              0   /* Fuerza a los nombres de columnas a minúsculas */
#define CASE_NATURAL            1 	/* Deja los nombres de columnas como son devueltas por el driver de la base de datos */
#define CASE_UPPER              2 	/* Fuerza a los nombres de columnas a mayúsculas */

/* Para los atributos STMT */
#define ATTR_FETCHTYPE          1   /* Tipo de relleno por defecto de los fetch */
#define ATTR_NEEDFETCH          2   /* Es necesario hacer el fetch? */
#define ATTR_LOADCOLINFO        3   /* Se recarga tabla de estructura columna? */

/* Tipos de fetch */
#define FETCH_ARRAY             1   /* Basado en tabla en memoria */
#define FETCH_HASH              2   /* Basado en tabla hash en memoria */
#define FETCH_BOUND             3   /* Actualiza variables xbase definidas */

#endif /* fin de HDOCOMMON_CH_ */
