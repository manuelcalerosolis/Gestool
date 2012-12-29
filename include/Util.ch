//---------------------------------------------------------------------------//
//  AUTOR.....: Manuel Expósito Suárez   Soft4U 2002-2010                    //
//  eMail.....: manuexposito@gmail.com                                       //
//  CLASE.....: Util.ch                                                      //
//  FECHA MOD.: 15/11/2010                                                   //
//  VERSION...: 6.00                                                         //
//  PROPOSITO.: Compatibilizacion de compiladores                            //
//---------------------------------------------------------------------------//

#ifndef _UTIL_CH
#define _UTIL_CH

//---------------------------------------------------------------------------//

#include "hbclass.ch"
#include "dbstruct.ch"
#include "e1def.ch"

//---------------------------------------------------------------------------//

#ifndef __XHARBOUR__        /* Solo para Harbour */
   #include "hbcompat.ch"
#endif

//---------------------------------------------------------------------------//
// Comunes a todos los compiladores:

//--------------------------------------------
// Definicion de valor por defecto:

#xcommand DEFAULT <Var1> := <DefVal1> [, <VarN> := <DefValN> ] =>;
                 if <Var1> == nil; <Var1> := <DefVal1>; endif;
                 [; if <VarN> == nil; <VarN> := <DefValN>; endif ]

#xcommand DEFAULT <Var> := <DefVal> TYPE <Type> => ;
                  if ValType(<Var>) != <Type>; <Var> := <DefVal>; endif

//--------------------------------------------
// Definicion de valor por defecto de DATAs:

#xcommand BYNAME <V> [, <VN> ] => ::<V> := <V> [; ::<VN> := <VN> ]
#xcommand BYNAME <V> IFNONIL => if <V> != NIL; ::<V> := <V>; endif
#xcommand BYNAME <V> TYPE <T> => if ValType( <V> ) == <T>; ::<V> := <V>; endif
#xcommand BYNAME <V> ALLTRIM => if ValType( <V> ) == "C"; ::<V> := AllTrim( <V> ); endif
#xcommand BYNAME <V> UPPER => if ValType( <V> ) == "C"; ::<V> := Upper( <V> ); endif

//--------------------------------------------
// Definiciones de pseudoFunciones:

#xtranslate StrNum( <n> ) => LTrim( str( <n> ) )

//--------------------------------------------
// Otras definiciones:

#ifndef CRLF
    #define CRLF chr( 13 ) + chr( 10 )
#endif

//---------------------------------------------------------------------------//

#endif

//---------------------------------------------------------------------------//


