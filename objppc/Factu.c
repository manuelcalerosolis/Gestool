/*
 * Harbour devel build 1.1-1 Intl.
 * Borland C++ 5.5.1 (32 bit)
 * Generated C source from ".\Prg\Factu.prg"
 */
#include "hbvmpub.h"
#include "hbpcode.h"
#include "hbinit.h"


HB_FUNC( MAIN );
HB_FUNC_INITSTATICS();
HB_FUNC_EXTERN( SET );
HB_FUNC_EXTERN( MSGINFO );
HB_FUNC_EXTERN( ERRORSYS );


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_FACTU )
{ "MAIN", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( MAIN )}, NULL },
{ "SET", {HB_FS_PUBLIC}, {HB_FUNCNAME( SET )}, NULL },
{ "MSGINFO", {HB_FS_PUBLIC}, {HB_FUNCNAME( MSGINFO )}, NULL },
{ "ERRORSYS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORSYS )}, NULL },
{ "(_INITSTATICS00021)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITSTATICS}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_FACTU, ".\\Prg\\Factu.prg", 0x0, 0x0002 )

#if defined(HB_PRAGMA_STARTUP)
   #pragma startup hb_vm_SymbolInit_FACTU
#elif defined(HB_MSC_STARTUP)
   #if _MSC_VER >= 1010
      #pragma data_seg( ".CRT$XIY" )
      #pragma comment( linker, "/Merge:.CRT=.data" )
   #else
      #pragma data_seg( "XIY" )
   #endif
   static HB_$INITSYM hb_vm_auto_SymbolInit_FACTU = hb_vm_SymbolInit_FACTU;
   #pragma data_seg()
#endif

HB_FUNC( MAIN )
{
   static const BYTE pcode[] =
   {
/* 00000 */ HB_P_LINE, 251, 22,	/* 5883 */
	HB_P_PUSHFUNCSYM, 1, 0,	/* SET */
	HB_P_PUSHBYTE, 4,	/* 4 */
	HB_P_PUSHSTRSHORT, 11,	/* 11 */
	'd', 'd', '/', 'm', 'm', '/', 'y', 'y', 'y', 'y', 0, 
	HB_P_DOSHORT, 2,
/* 00023 */ HB_P_LINE, 252, 22,	/* 5884 */
	HB_P_PUSHFUNCSYM, 1, 0,	/* SET */
	HB_P_PUSHBYTE, 11,	/* 11 */
	HB_P_PUSHSTRSHORT, 3,	/* 3 */
	'O', 'N', 0, 
	HB_P_DOSHORT, 2,
/* 00038 */ HB_P_LINE, 253, 22,	/* 5885 */
	HB_P_PUSHFUNCSYM, 1, 0,	/* SET */
	HB_P_PUSHBYTE, 5,	/* 5 */
	HB_P_PUSHINT, 208, 7,	/* 2000 */
	HB_P_DOSHORT, 2,
/* 00051 */ HB_P_LINE, 254, 22,	/* 5886 */
	HB_P_PUSHFUNCSYM, 1, 0,	/* SET */
	HB_P_PUSHBYTE, 44,	/* 44 */
	HB_P_PUSHSTRSHORT, 3,	/* 3 */
	'O', 'N', 0, 
	HB_P_DOSHORT, 2,
/* 00066 */ HB_P_LINE, 255, 22,	/* 5887 */
	HB_P_PUSHFUNCSYM, 1, 0,	/* SET */
	HB_P_ONE,
	HB_P_PUSHSTRSHORT, 3,	/* 3 */
	'O', 'N', 0, 
	HB_P_DOSHORT, 2,
/* 00080 */ HB_P_LINE, 1, 23,	/* 5889 */
	HB_P_PUSHFUNCSYM, 2, 0,	/* MSGINFO */
	HB_P_PUSHSTRSHORT, 32,	/* 32 */
	'P', 'u', 'e', 'b', 'a', ' ', 'p', 'a', 'r', 'a', ' ', 'a', 'p', 'l', 'i', 'c', 'a', 'c', 'i', 'o', 'n', ' ', 'p', 'd', 'a', ' ', 'R', 'O', 'C', 'I', 'O', 0, 
	HB_P_DOSHORT, 1,
/* 00122 */ HB_P_LINE, 3, 23,	/* 5891 */
	HB_P_PUSHNIL,
	HB_P_RETVALUE,
	HB_P_ENDPROC
/* 00128 */
   };

   hb_vmExecute( pcode, symbols );
}

HB_FUNC_INITSTATICS()
{
   static const BYTE pcode[] =
   {
	HB_P_STATICS, 4, 0, 21, 0,	/* symbol (_INITSTATICS), 21 statics */
	HB_P_SFRAME, 4, 0,	/* symbol (_INITSTATICS) */
	HB_P_TRUE,
	HB_P_POPSTATIC, 15, 0,	/* LDEMOMODE */
	HB_P_PUSHSTRSHORT, 1,	/* 1 */
	0, 
	HB_P_POPSTATIC, 21, 0,	/* CTYPEVERSION */
	HB_P_ENDPROC
/* 00019 */
   };

   hb_vmExecute( pcode, symbols );
}

