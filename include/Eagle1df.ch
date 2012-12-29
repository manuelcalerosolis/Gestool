//---------------------------------------------------------------------------//
//  AUTOR.....: Manuel Expósito Suárez   Soft4U 2002-2006                    //
//  eMail.....: manuexposito@gmail.com                                       //
//  CLASE.....: Eagle1Df                                                     //
//  FECHA MOD.: 11/12/2006                                                   //
//  VERSION...: 5.02                                                         //
//  PROPOSITO.: Definiciones para las clases de Eagle1                       //
//---------------------------------------------------------------------------//

#ifndef _EAGLE1DF_CH
#define _EAGLE1DF_CH

//---------------------------------------------------------------------------//


// Identificadores de conexion:

#define ID_HOST     1
#define ID_USER     2
#define ID_PASSWD   3
#define ID_DB       4
#define ID_PORT     5
#define ID_SOCKET   6
#define ID_FLAG     7


// Identificadores de informacion de campos al estilo de MySQL:

#define MY_NAME         1
#define MY_TABLE        2
#define MY_DEF          3
#define MY_LENGTH       4
#define MY_MAX_LENGTH   5
#define MY_FLAGS        6
#define MY_DECIMALS     7
#define MY_TYPE         8

#ifndef DBS_NAME            // En C3 no esta definido el DbStruct.ch
    #define DBS_NAME    1
    #define DBS_TYPE    2
    #define DBS_LEN     3
    #define DBS_DEC     4
#endif

#define DBS_AUTO        5   // Indica si es auto incremental

//---------------------------------------------------------------------------//

#endif

//---------------------------------------------------------------------------//

