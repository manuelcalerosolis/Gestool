/*
 * Proyecto: hdo
 * Fichero: hdocommon.ch
 * Descripci�n: Fichero usado tanto para definiciones en harbour como en C
 * Autor: Manu Exposito 2014-18
 * Fecha: 10/09/2018
 */

#ifndef HDOCOMMON_CH_
#define HDOCOMMON_CH_

/* Definicion de Constantes */
#define HDO_VERSION             "2018.02"

#define HDO_MSG_CONNECTED       "Connected"
#define HDO_MSG_NOTCONNECTED    "Not connected"
#define HDO_MSG_DEF_SERVER      "SQLDefault Server"
#define HDO_MSG_SERVER_VER      "SQLDefault Server 2018.02"
#define HDO_MSG_CLIENT_VER      "SQLDefault Client 2018.02"

/* Para el metodo rdlInfo */
#define RDL_NAME                1   /* Nombre */
#define RDL_VER                 2   /* Version */
#define RDL_DES                 3   /* Pequeña descripcion */
#define RDL_OBS                 4   /* Observaciones */

#define RDL_INFO_SIZE           4   /* Total valores devueltos por rdlInfo() */

/* Para el metodo errorInfo */
#define ERR_SQLSTATE            1   /* Status standard */
#define ERR_CODE                2   /* Codigo SQL nativo */
#define ERR_MSG                 3   /* Mensaje del error SQL nativo */

#define ERR_INFO_SIZE           3   /* Mensaje del error SQL nativo */

/* Para metacolumn */
#define HDO_META_COL_NAME           1   /* Nombre de la columna*/
#define HDO_META_COL_TYPE           2   /* Tipo xBase */
#define HDO_META_COL_LEN            3   /* Precision o ancho máximo */
#define HDO_META_COL_DEC            4   /* Escala o numero de decimales */
#define HDO_META_COL_TABLE          5   /* Tabla a la que pertenece */
#define HDO_META_COL_NATTYPE        6   /* Tipo SQL nativo */
#define HDO_META_COL_AUTOINC        7   /* Verdad si es autoincremental */
#define HDO_META_COL_NOTNULL        8   /* Verdad si no puede ser nulo */
#define HDO_META_COL_PK             9	/* Verdad si forma parte de la primary key */

#define HDO_META_COL_SIZE           9	/* Numero de elementos del array de MetaDatos */

/* Tipo array de nombres de campo */
#define AS_ARRAY_MODE                0	/* Basado en array */
#define AS_HASH_MODE                 1  /* Basado en tabla hash (por defecto) */

/* Para los atributos HDO */
#define HDO_ATTR_AUTOCOMMIT         	100001  /* Establece el autocommit */
#define HDO_ATTR_CASE               	100002  /* getColName y getColMeta: 0 -> natural | 1 -> mayuscula | 2 -> minuscula */
#define HDO_ATTR_TIMEOUT            	100003  /* Tiempo de espera  */
#define HDO_ATTR_CONNECTION_STATUS  	100004  /* Estado de la conexion */
#define HDO_ATTR_ERRMODE            	100005  /* Control de errores: False -> SILENT | True -> WARNING / EXCEPTION */
#define HDO_ATTR_SERVER_VERSION     	100006  /* Version servidor */
#define HDO_ATTR_CLIENT_VERSION     	100007  /* Version cliente */
#define HDO_ATTR_RDL_NAME           	100008  /* Nombre del RDL */
#define HDO_ATTR_SERVER_INFO        	100009  /* Informacion del servidor */
#define HDO_ATTR_CLIENT_INFO        	100010	/* Informacion del cliente */
#define HDO_ATTR_DEFAULT_FETCH_MODE 	100011	/* Tipo de fetch por defecto en statement */
#define HDO_ATTR_DEFAULT_STR_PAD 		100012	/* PAD por defecto */
#define HDO_ATTR_DEFAULT_TINY_AS_BOOL 	100013	/* Tiny as bool por defecto */
#define HDO_ATTR_STR_TO_NULLS       	100014  /* Cambia nulos a cadena vacia, este ser� el valor por defecto de STMT_ATTR_STR_TO_NULLS de STMT **Falta por implementar**  **IMPORTANTE** <========== */

/* Valores para HDO_ATTR_CASE */
#define CASE_LOWER              0   /* Fuerza a los nombres de columnas a minúsculas */
#define CASE_NATURAL            1 	/* Deja los nombres de columnas como son devueltas por el driver de la base de datos */
#define CASE_UPPER              2 	/* Fuerza a los nombres de columnas a mayúsculas */

#define ERRMODE_SILENT			0   /* Silencia los warming */
#define ERRMODE_THROW           1   /* Lanza execepciones con tambien con los warning */

/* Para los atributos STMT */
#define STMT_ATTR_FETCHMODE     100001	/* Tipo de relleno por defecto de los fetch */
#define STMT_ATTR_STR_PAD		100002	/* En MySQL hace que se rellene el resto de la columna con ' ' */
#define STMT_ATTR_TINY_AS_BOOL	100003	/* En MySQL hace que los TINY se comporten como BOOL */
#define STMT_ATTR_STR_TO_NULLS  100004  /* Cambia nulos a cadena vacia          **Falta por implementar** **IMPORTANTE**  */
/* ------------------------------- Internos ----------------------------------*/
#define STMT_ATTR_NEEDFETCH     100101	/* **INTERNO** Es necesario hacer el fetch? */
#define STMT_ATTR_NEDCOLINFO    100102	/* **INTERNO** Se recarga tabla de estructura columna? */

/* Menor numero atributo para HDO y STMT */
#define HDO_MIN_ATTRIBUTES		100001

/* Tipos de fetch de fila */
#define FETCH_ARRAY             1   /* Basado en tabla en memoria */
#define FETCH_HASH              2   /* Basado en tabla hash en memoria */
#define FETCH_BOUND             3   /* Actualiza variables xbase definidas */

/* Tipos de datos basicos solo para traspaso SQL <--> Harbour */
#define HDO_TYPE_UNDEF			0
#define HDO_TYPE_NULL			1
#define HDO_TYPE_BIT			2	/* 4 */
#define HDO_TYPE_BOOL			3	/* 1 */
#define HDO_TYPE_TINY		    4	/* 1 */
#define HDO_TYPE_SHORT			5	/* 2 */
#define HDO_TYPE_INTEGER		6	/* 4 */
#define HDO_TYPE_LONG			7	/* 4 */
#define HDO_TYPE_LONGLONG		8	/* 8 */
#define HDO_TYPE_FLOAT			9	/* 4 */
#define HDO_TYPE_DOUBLE			10	/* 8 */
#define HDO_TYPE_DECIMAL		11
#define HDO_TYPE_STRING			12
#define HDO_TYPE_BLOB			13
#define HDO_TYPE_DATE			14
#define HDO_TYPE_TIMESTAMP		15
#define HDO_TYPE_TIME			16

#endif /* fin de HDOCOMMON_CH_ */
