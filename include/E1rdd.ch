//---------------------------------------------------------------------------//
//  AUTOR.....: Manuel Expósito Suárez   Soft4U 2002-2010                    //
//  eMail.....: manuexposito@gmail.com                                       //
//  CLASE.....: e1rdd.ch                                                     //
//  FECHA MOD.: 15/11/2010                                                   //
//  VERSION...: 6.00                                                         //
//  PROPOSITO.: Fichero include para E1RDD                                   //
//---------------------------------------------------------------------------//

#ifndef _E1RDD_CH
#define _E1RDD_CH

//-----------------------------------------------------------------------------

#ifndef __XHARBOUR__

    //-------------------------------------------------------------------------
    // Solo Harbour
    #include "hbusrrdd.ch"
#else

    //------------------------------------------------------------------------
    // Solo xHarbour
   #include "usrrdd.ch"

   #ifndef HB_SYMBOL_UNUSED
      #define HB_SYMBOL_UNUSED( symbol )  ( ( symbol ) )
   #endif

#endif

#ifndef HB_SUCCESS
    #define HB_SUCCESS            0
    #define HB_FAILURE            1
#endif

//-----------------------------------------------------------------------------
// Definiciones de E1RDD

#define WAD_OTB         1   // Objeto TMSTable
#define WAD_RECLOAD     2   // Verdad si necesita cargar el registro
#define WAD_APPEND      3   // Esta en modo añadir?

#define WAD_SIZE        3

//-----------------------------------------------------------------------------

#endif

//-----------------------------------------------------------------------------

