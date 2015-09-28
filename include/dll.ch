// Copyright FiveTech 1993-2011

#ifndef _DLL_CH
#define _DLL_CH

#ifndef _C_TYPES
   #define _C_TYPES
   #define VOID      0
   #define BYTE      1
   #define CHAR      2
   #define WORD      3

#ifdef __CLIPPER__
   #define _INT      4         // conflicts with Clipper Int()
#else
   #define _INT      7
#endif

   #define BOOL      5
   #define HDC       6
   #define LONG      7
   #define STRING    8
   #define LPSTR     9
   #define PTR      10
   #define _DOUBLE  11         // conflicts with BORDER DOUBLE
   #define DWORD    12
   
   #define LONGLONG 13
#endif

#translate NOREF([@]<x>) => <x>

#ifndef __HARBOUR__
  #ifndef __XPP__
     #ifndef __CLIPPER__
        #ifndef __C3__
           #define __CLIPPER__
        #endif
     #endif
  #endif
#endif

#ifndef __CLIPPER__
   #translate DLL32 => DLL
#endif

//----------------------------------------------------------------------------//

#xcommand DLL [<static:STATIC>] FUNCTION <FuncName>( [ <uParam1> AS <type1> ] ;
                                                     [, <uParamN> AS <typeN> ] ) ;
             AS <return> [<pascal:PASCAL>] [ FROM <SymName> ] LIB <*DllName*> ;
       => ;
          [<static>] function <FuncName>( [NOREF(<uParam1>)] [,NOREF(<uParamN>)] ) ;;
             local _hDLL := If( ValType( <DllName> ) == "N", <DllName>, LoadLibrary( <(DllName)> ) ) ;;
             local uResult ;;
             local cFarProc ;;
             if Abs( _hDLL ) > 32 ;;
                cFarProc = GetProcAdd( _hDLL,;
                If( [ Empty( <SymName> ) == ] .t., <(FuncName)>, <SymName> ),;
                [<.pascal.>], <return> [,<type1>] [,<typeN>] ) ;;
                uResult = FWCallDLL( cFarProc [,<uParam1>] [,<uParamN>] ) ;;
                If( ValType( <DllName> ) == "N",, FreeLibrary( _hDLL ) ) ;;
             else ;;
                MsgAlert( "Error code: " + LTrim( Str( _hDLL ) ) + " loading " + ;
                If( ValType( <DllName> ) == "C", <DllName>, Str( <DllName> ) ) ) ;;
             end ;;
          return uResult

//----------------------------------------------------------------------------//

#xcommand DLL32 [<static:STATIC>] FUNCTION <FuncName>( [ <uParam1> AS <type1> ] ;
                                                      [, <uParamN> AS <typeN> ] ) ;
             AS <return> [<pascal:PASCAL>] [ FROM <SymName> ] LIB <*DllName*> ;
       => ;
          [<static>] function <FuncName>( [NOREF(<uParam1>)] [,NOREF(<uParamN>)] ) ;;
             local _hDLL := If( ValType( <DllName> ) == "N", <DllName>, LoadLib32( <(DllName)> ) ) ;;
             local uResult ;;
             local cFarProc ;;
             if Abs( _hDLL ) <= 32 ;;
                MsgAlert( "Error code: " + LTrim( Str( _hDLL ) ) + " loading " + <DllName> ) ;;
             else ;;
                cFarProc = GetProc32( _hDLL,;
                If( [ Empty( <SymName> ) == ] .t., <(FuncName)>, <SymName> ),;
                [<.pascal.>], <return> [,<type1>] [,<typeN>] ) ;;
                uResult = FWCallDLL32( cFarProc [,<uParam1>] [,<uParamN>] ) ;;
                If( ValType( <DllName> ) == "N",, FreeLib32( _hDLL ) ) ;;
             end ;;
          return uResult

#endif

//----------------------------------------------------------------------------//