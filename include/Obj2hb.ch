//----------------------------------------------------------------------------//
//  AUTOR.....: Manuel Exp¢sito Su rez    Soft 4U '98                         //
//  e-Mail....: maex14@dipusevilla.es                                         //
//  CLASE.....: Obj2Hb.CH                                                     //
//  FECHA MOD.: 24/01/2002                                                    //
//  VERSION...: 11.00                                                         //
//  PROPOSITO.: Compatibiliza HARBOUR OOP con Objects                         //
//----------------------------------------------------------------------------//


#ifdef __HARBOUR__

    #xtranslate AS ALL     => AS ANYTYPE     // Compatible con OBJECTS
    #xtranslate AS BLOCK   => AS CODEBLOCK

    #xcommand DEFAULT <xVar1> := <xDefaultValue1>                                  ;
               [, <xVarN> := <xDefaultValueN> ] =>                             ;
                  <xVar1> := If( <xVar1> == nil, <xDefaultValue1>, <xVar1> );  ;
                [ <xVarN> := If( <xVarN> == nil, <xDefaultValueN>, <xVarN> );]

    // Extraido de Objects.ch

    #xtranslate BYNAME <V> [, <VN> ]     => ::<V> := <V> [; ::<VN> := <VN> ]
    #xtranslate BYNAME <V> DEFAULT <Val> => ::<V> := BYDEFAULT <V>, <Val>
    #xtranslate BYDEFAULT <V>, <Val>     => if( <V> == NIL, <Val>, <V> )
    #xtranslate BYNAME <V> IFNONIL       => if( <V> != NIL, ::<V> := <V>, )

    #include "HBClass.ch"

#else

    #include "Objects.ch"

#endif

//----------------------------------------------------------------------------//

