//---------------------------------------------------------------------------//
//  AUTOR.....: Manuel Expósito Suárez   Soft4U 2002-2010                    //
//  eMail.....: manuexposito@gmail.com                                       //
//  CLASE.....: e1struct.h                                                   //
//  FECHA MOD.: 15/11/2010                                                   //
//  VERSION...: 6.00                                                         //
//  PROPOSITO.: Estructura de las tablas en E1                               //
//				Ojo!!! Se usa en C y  en PRG	     						 //
//---------------------------------------------------------------------------//

#ifndef _E1STRUCT_H
#define _E1STRUCT_H

//---------------------------------------------------------------------------//
// Identificadores de conexion:

#define ID_HOST     1
#define ID_USER     2
#define ID_PASSWD   3
#define ID_DB       4
#define ID_PORT     5
#define ID_SOCKET   6
#define ID_FLAG     7

//---------------------------------------------------------------------------//
// Informacion de campos al estilo de MySQL:

#define MY_NAME         1
#define MY_TABLE        2
#define MY_DEF          3
#define MY_LENGTH       4
#define MY_MAX_LENGTH   5
#define MY_FLAGS        6
#define MY_DECIMALS     7
#define MY_TYPE         8

//--------------------------------------------
// Valores extendidos en la estructura E1:

#define E1_DBS_NAME     1
#define E1_DBS_TYPE     2
#define E1_DBS_LEN      3
#define E1_DBS_DEC      4
#define E1_DBS_AUTOINC  5
//-- Hasta aqui para crear tablas en MySQL
#define E1_DBS_UITYPE   6

#define E1_DBS_SIZE     6


//--------------------------------------------
// Ancho por defecto en asignacion de Blank:

#define E1_MEMO_LEN		256

//---------------------------------------------------------------------------//

#endif

//---------------------------------------------------------------------------//



