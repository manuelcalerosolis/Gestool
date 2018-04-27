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
#define HDO_VERSION             "2017.06"

#define HDO_MSG_CONNECTED       "Connected"
#define HDO_MSG_NOTCONNECTED    "Not connected"
#define HDO_MSG_DEF_SERVER      "SQLDefault Server"
#define HDO_MSG_SERVER_VER      "SQLDefault Server 2017.06"
#define HDO_MSG_CLIENT_VER      "SQLDefault Client 2017.06"

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
#define META_COL_TABLE          5   /* Tabla a la que pertenece */
#define META_COL_NATTYPE        6   /* Tipo SQL nativo */
#define META_COL_AUTOINC        7   /* Verdad si es autoincremental */
#define META_COL_NOTNULL        8   /* Verdad si no puede ser nulo */
#define META_COL_PK             9	/* Verdad si forma parte de la primary key */

#define META_COL_SIZE           9	/* Numero de elementos del array de MetaDatos */

/* Tipo array de nombres de campo */
#define AS_ARRAY_TYPE                1	/* Basado en array */
#define AS_HASH_TYPE                 2  /* Basado en tabla hash (por defecto) */

/* Para los atributos HDO */
#define ATTR_AUTOCOMMIT         100001  /* Establece el autocommit */
#define ATTR_CASE               100002  /* getColName y getColMeta: 0 -> natural | 1 -> mayuscula | 2 -> minuscula */
#define ATTR_TIMEOUT            100003  /* Tiempo de espera  */
#define ATTR_CONNECTION_STATUS  100004  /* Estado de la conexion */
#define ATTR_ERRMODE            100005  /* Control de errores: False -> SILENT | True -> WARNING / EXCEPTION */
#define ATTR_SERVER_VERSION     100006  /* Version servidor */
#define ATTR_CLIENT_VERSION     100007  /* Version cliente */
#define ATTR_RDL_NAME           100008  /* Nombre del RDL */
#define ATTR_SERVER_INFO        100009  /* Informacion del servidor */
#define ATTR_CLIENT_INFO        100010	/* Informacion del cliente */
#define ATTR_DEFAULT_FETCH_MODE	100011	/* Tipo de fetch por defecto en statement */
/* Por implementar:
#define ATTR_STR_TO_NULLS
#define ATTR_PERSISTENT
#define ATTR_PREFETCH
*/
/* Valores para ATTR_CASE */
#define CASE_LOWER              0   /* Fuerza a los nombres de columnas a minúsculas */
#define CASE_NATURAL            1 	/* Deja los nombres de columnas como son devueltas por el driver de la base de datos */
#define CASE_UPPER              2 	/* Fuerza a los nombres de columnas a mayúsculas */

#define ERRMODE_SILENT			0
#define ERRMODE_THROW           1

/* Para los atributos STMT */
#define ATTR_FETCHTYPE          100001	/* Tipo de relleno por defecto de los fetch */
#define ATTR_NEEDFETCH          100002	/* Es necesario hacer el fetch? */
#define ATTR_NEDCOLINFO			100003	/* Se recarga tabla de estructura columna? */
#define ATTR_STR_PAD			100004	/* En MySQL hace que se rellene el resto de la columna con ' '

/* Menor numero atributo para HDO y STMT */
#define ATTR_HDO_RDL			100001

/* Tipos de fetch de fila */
#define FETCH_ARRAY             1   /* Basado en tabla en memoria */
#define FETCH_HASH              2   /* Basado en tabla hash en memoria */
#define FETCH_BOUND             3   /* Actualiza variables xbase definidas */

/* Tipos de datos basicos solo para traspaso SQL <--> Harbour */
#define HDO_TYPE_UNDEF			0
#define HDO_TYPE_NULL			1
#define HDO_TYPE_BIT			2		
#define HDO_TYPE_SHORT			3
#define HDO_TYPE_INTEGER		4
#define HDO_TYPE_LONG			6
#define HDO_TYPE_LONGLONG		7
#define HDO_TYPE_FLOAT			8
#define HDO_TYPE_DOUBLE			9
#define HDO_TYPE_DECIMAL		10
#define HDO_TYPE_STRING			11
#define HDO_TYPE_BLOB			12
#define HDO_TYPE_DATE			13
#define HDO_TYPE_TIMESTAMP		14
#define HDO_TYPE_DATETIME		15
#define HDO_TYPE_TIME			16

#endif /* fin de HDOCOMMON_CH_ */
