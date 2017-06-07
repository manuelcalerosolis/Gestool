/*
 * Harbour 3.2.0dev (r1307082134)
 * Borland C++ 5.8.2 (32-bit)
 * Generated C source from ".\.\Prg\Tvta.prg"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC_STATIC( EDTREC );
HB_FUNC( AITMTVTA );
HB_FUNC_EXTERN( AADD );
HB_FUNC( TVTA );
HB_FUNC_EXTERN( OWND );
HB_FUNC_EXTERN( NLEVELUSR );
HB_FUNC_EXTERN( NAND );
HB_FUNC_EXTERN( MSGSTOP );
HB_FUNC_EXTERN( SYSREFRESH );
HB_FUNC_STATIC( OPENFILES );
HB_FUNC_EXTERN( ADDMNUNEXT );
HB_FUNC_EXTERN( PROCNAME );
HB_FUNC_EXTERN( TSHELL );
HB_FUNC_EXTERN( WINAPPREC );
HB_FUNC_EXTERN( WINEDTREC );
HB_FUNC_EXTERN( WINDELREC );
HB_FUNC_EXTERN( WINDUPREC );
HB_FUNC_EXTERN( WINZOOREC );
HB_FUNC_EXTERN( INFTVTA );
HB_FUNC_STATIC( CLOSEFILES );
HB_FUNC_EXTERN( TDIALOG );
HB_FUNC_EXTERN( LBLTITLE );
HB_FUNC_EXTERN( TGETHLP );
HB_FUNC_EXTERN( PCOUNT );
HB_FUNC_EXTERN( NOTVALID );
HB_FUNC_EXTERN( TRADMENU );
HB_FUNC_EXTERN( TBUTTON );
HB_FUNC_STATIC( LPRESAVE );
HB_FUNC_EXTERN( GOHELP );
HB_FUNC_EXTERN( DBSEEKINORD );
HB_FUNC_EXTERN( RTRIM );
HB_FUNC_EXTERN( EMPTY );
HB_FUNC_EXTERN( WINGATHER );
HB_FUNC_STATIC( GENREPORT );
HB_FUNC_EXTERN( RECNO );
HB_FUNC_EXTERN( PADR );
HB_FUNC_EXTERN( CCODEMP );
HB_FUNC_EXTERN( CNBREMP );
HB_FUNC_EXTERN( SETREP );
HB_FUNC_EXTERN( DBGOTOP );
HB_FUNC_EXTERN( TFONT );
HB_FUNC_EXTERN( RPTBEGIN );
HB_FUNC_EXTERN( DTOC );
HB_FUNC_EXTERN( DATE );
HB_FUNC_EXTERN( STR );
HB_FUNC_EXTERN( RPTADDCOLUMN );
HB_FUNC_EXTERN( RPTEND );
HB_FUNC_EXTERN( DBSKIP );
HB_FUNC_EXTERN( EOF );
HB_FUNC_EXTERN( DBGOTO );
HB_FUNC( CTVTA );
HB_FUNC_EXTERN( RJUSTOBJ );
HB_FUNC_EXTERN( DBSEEK );
HB_FUNC( RETTVTA );
HB_FUNC_EXTERN( CPATDAT );
HB_FUNC_EXTERN( ERRORBLOCK );
HB_FUNC_EXTERN( APOLOBREAK );
HB_FUNC_EXTERN( DBUSEAREA );
HB_FUNC_EXTERN( CDRIVER );
HB_FUNC_EXTERN( CCHECKAREA );
HB_FUNC_EXTERN( LAIS );
HB_FUNC_EXTERN( ORDLISTADD );
HB_FUNC_EXTERN( ORDSETFOCUS );
HB_FUNC_EXTERN( DBCLOSEAREA );
HB_FUNC_EXTERN( ERRORMESSAGE );
HB_FUNC( BRWTVTA );
HB_FUNC_EXTERN( GETBRWOPT );
HB_FUNC_EXTERN( MIN );
HB_FUNC_EXTERN( MAX );
HB_FUNC_EXTERN( LEN );
HB_FUNC_EXTERN( ORDCLEARSCOPE );
HB_FUNC_EXTERN( AUTOSEEK );
HB_FUNC_EXTERN( TCOMBOBOX );
HB_FUNC_EXTERN( IXBROWSE );
HB_FUNC_EXTERN( ISREPORT );
HB_FUNC_EXTERN( VALTYPE );
HB_FUNC_EXTERN( DESTROYFASTFILTER );
HB_FUNC_EXTERN( SETBRWOPT );
HB_FUNC_EXTERN( ORDNUMBER );
HB_FUNC( LTVTA );
HB_FUNC_EXTERN( LEXISTTABLE );
HB_FUNC( MKTVTA );
HB_FUNC_EXTERN( LEXISTINDEX );
HB_FUNC( RXTVTA );
HB_FUNC_EXTERN( DBCREATE );
HB_FUNC_EXTERN( ASQLSTRUCT );
HB_FUNC_EXTERN( FERASE );
HB_FUNC_EXTERN( NETERR );
HB_FUNC_EXTERN( __DBPACK );
HB_FUNC_EXTERN( ORDCONDSET );
HB_FUNC_EXTERN( DELETED );
HB_FUNC_EXTERN( ORDCREATE );
HB_FUNC( NVTAUND );
HB_FUNC( NVTAIMP );
HB_FUNC( ISTIPOVENTAS );
HB_FUNC_EXTERN( __DBLOCATE );
HB_FUNC_EXTERN( FOUND );
HB_FUNC_EXTERN( DBGATHER );
HB_FUNC_EXTERN( FW_GT );
HB_FUNC_EXTERN( ERRORSYS );
HB_FUNC_INITSTATICS();


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_TVTA )
{ "EDTREC", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( EDTREC )}, NULL },
{ "AITMTVTA", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( AITMTVTA )}, NULL },
{ "AADD", {HB_FS_PUBLIC}, {HB_FUNCNAME( AADD )}, NULL },
{ "TVTA", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( TVTA )}, NULL },
{ "OWND", {HB_FS_PUBLIC}, {HB_FUNCNAME( OWND )}, NULL },
{ "NLEVELUSR", {HB_FS_PUBLIC}, {HB_FUNCNAME( NLEVELUSR )}, NULL },
{ "NAND", {HB_FS_PUBLIC}, {HB_FUNCNAME( NAND )}, NULL },
{ "MSGSTOP", {HB_FS_PUBLIC}, {HB_FUNCNAME( MSGSTOP )}, NULL },
{ "SYSREFRESH", {HB_FS_PUBLIC}, {HB_FUNCNAME( SYSREFRESH )}, NULL },
{ "CLOSEALL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OPENFILES", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( OPENFILES )}, NULL },
{ "ADDMNUNEXT", {HB_FS_PUBLIC}, {HB_FUNCNAME( ADDMNUNEXT )}, NULL },
{ "PROCNAME", {HB_FS_PUBLIC}, {HB_FUNCNAME( PROCNAME )}, NULL },
{ "NEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TSHELL", {HB_FS_PUBLIC}, {HB_FUNCNAME( TSHELL )}, NULL },
{ "WINAPPREC", {HB_FS_PUBLIC}, {HB_FUNCNAME( WINAPPREC )}, NULL },
{ "OBRW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "WINEDTREC", {HB_FS_PUBLIC}, {HB_FUNCNAME( WINEDTREC )}, NULL },
{ "WINDELREC", {HB_FS_PUBLIC}, {HB_FUNCNAME( WINDELREC )}, NULL },
{ "WINDUPREC", {HB_FS_PUBLIC}, {HB_FUNCNAME( WINDUPREC )}, NULL },
{ "ADDXCOL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CHEADER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CSORTORDER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BEDITVALUE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CCODMOV", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "_NWIDTH", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BLCLICKHEADER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CLICKONHEADER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CDESMOV", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "_CHTMLHELP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CREATEXFROMCODE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NEWAT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SEARCHSETFOCUS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDSEABAR", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "RECADD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "RECDUP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "RECEDIT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "WINZOOREC", {HB_FS_PUBLIC}, {HB_FUNCNAME( WINZOOREC )}, NULL },
{ "RECDEL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "PLAY", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "INFTVTA", {HB_FS_PUBLIC}, {HB_FUNCNAME( INFTVTA )}, NULL },
{ "END", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ACTIVATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BLCLICKED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BRCLICKED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BMOVED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BRESIZED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BPAINTED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BKEYDOWN", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BINIT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CLOSEFILES", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( CLOSEFILES )}, NULL },
{ "BLBUTTONUP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETFOCUS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TDIALOG", {HB_FS_PUBLIC}, {HB_FUNCNAME( TDIALOG )}, NULL },
{ "LBLTITLE", {HB_FS_PUBLIC}, {HB_FUNCNAME( LBLTITLE )}, NULL },
{ "REDEFINE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TGETHLP", {HB_FS_PUBLIC}, {HB_FUNCNAME( TGETHLP )}, NULL },
{ "PCOUNT", {HB_FS_PUBLIC}, {HB_FUNCNAME( PCOUNT )}, NULL },
{ "NOTVALID", {HB_FS_PUBLIC}, {HB_FUNCNAME( NOTVALID )}, NULL },
{ "TRADMENU", {HB_FS_PUBLIC}, {HB_FUNCNAME( TRADMENU )}, NULL },
{ "TBUTTON", {HB_FS_PUBLIC}, {HB_FUNCNAME( TBUTTON )}, NULL },
{ "LVALID", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LPRESAVE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( LPRESAVE )}, NULL },
{ "GOHELP", {HB_FS_PUBLIC}, {HB_FUNCNAME( GOHELP )}, NULL },
{ "ADDFASTKEY", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BSTART", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NRESULT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DBSEEKINORD", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBSEEKINORD )}, NULL },
{ "RTRIM", {HB_FS_PUBLIC}, {HB_FUNCNAME( RTRIM )}, NULL },
{ "EMPTY", {HB_FS_PUBLIC}, {HB_FUNCNAME( EMPTY )}, NULL },
{ "WINGATHER", {HB_FS_PUBLIC}, {HB_FUNCNAME( WINGATHER )}, NULL },
{ "GENREPORT", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( GENREPORT )}, NULL },
{ "RECNO", {HB_FS_PUBLIC}, {HB_FUNCNAME( RECNO )}, NULL },
{ "PADR", {HB_FS_PUBLIC}, {HB_FUNCNAME( PADR )}, NULL },
{ "CCODEMP", {HB_FS_PUBLIC}, {HB_FUNCNAME( CCODEMP )}, NULL },
{ "CNBREMP", {HB_FS_PUBLIC}, {HB_FUNCNAME( CNBREMP )}, NULL },
{ "SETREP", {HB_FS_PUBLIC}, {HB_FUNCNAME( SETREP )}, NULL },
{ "DBGOTOP", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBGOTOP )}, NULL },
{ "TFONT", {HB_FS_PUBLIC}, {HB_FUNCNAME( TFONT )}, NULL },
{ "RPTBEGIN", {HB_FS_PUBLIC}, {HB_FUNCNAME( RPTBEGIN )}, NULL },
{ "DTOC", {HB_FS_PUBLIC}, {HB_FUNCNAME( DTOC )}, NULL },
{ "DATE", {HB_FS_PUBLIC}, {HB_FUNCNAME( DATE )}, NULL },
{ "STR", {HB_FS_PUBLIC}, {HB_FUNCNAME( STR )}, NULL },
{ "NPAGE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "RPTADDCOLUMN", {HB_FS_PUBLIC}, {HB_FUNCNAME( RPTADDCOLUMN )}, NULL },
{ "RPTEND", {HB_FS_PUBLIC}, {HB_FUNCNAME( RPTEND )}, NULL },
{ "LCREATED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "MARGIN", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BSKIP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DBSKIP", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBSKIP )}, NULL },
{ "EOF", {HB_FS_PUBLIC}, {HB_FUNCNAME( EOF )}, NULL },
{ "DBGOTO", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBGOTO )}, NULL },
{ "CTVTA", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( CTVTA )}, NULL },
{ "VARGET", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CTEXT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "RJUSTOBJ", {HB_FS_PUBLIC}, {HB_FUNCNAME( RJUSTOBJ )}, NULL },
{ "DBSEEK", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBSEEK )}, NULL },
{ "RETTVTA", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( RETTVTA )}, NULL },
{ "CPATDAT", {HB_FS_PUBLIC}, {HB_FUNCNAME( CPATDAT )}, NULL },
{ "ERRORBLOCK", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORBLOCK )}, NULL },
{ "APOLOBREAK", {HB_FS_PUBLIC}, {HB_FUNCNAME( APOLOBREAK )}, NULL },
{ "DBUSEAREA", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBUSEAREA )}, NULL },
{ "CDRIVER", {HB_FS_PUBLIC}, {HB_FUNCNAME( CDRIVER )}, NULL },
{ "CCHECKAREA", {HB_FS_PUBLIC}, {HB_FUNCNAME( CCHECKAREA )}, NULL },
{ "LAIS", {HB_FS_PUBLIC}, {HB_FUNCNAME( LAIS )}, NULL },
{ "ORDLISTADD", {HB_FS_PUBLIC}, {HB_FUNCNAME( ORDLISTADD )}, NULL },
{ "ORDSETFOCUS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ORDSETFOCUS )}, NULL },
{ "DBCLOSEAREA", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBCLOSEAREA )}, NULL },
{ "ERRORMESSAGE", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORMESSAGE )}, NULL },
{ "BRWTVTA", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( BRWTVTA )}, NULL },
{ "GETBRWOPT", {HB_FS_PUBLIC}, {HB_FUNCNAME( GETBRWOPT )}, NULL },
{ "MIN", {HB_FS_PUBLIC}, {HB_FUNCNAME( MIN )}, NULL },
{ "MAX", {HB_FS_PUBLIC}, {HB_FUNCNAME( MAX )}, NULL },
{ "LEN", {HB_FS_PUBLIC}, {HB_FUNCNAME( LEN )}, NULL },
{ "ORDCLEARSCOPE", {HB_FS_PUBLIC}, {HB_FUNCNAME( ORDCLEARSCOPE )}, NULL },
{ "AUTOSEEK", {HB_FS_PUBLIC}, {HB_FUNCNAME( AUTOSEEK )}, NULL },
{ "TCOMBOBOX", {HB_FS_PUBLIC}, {HB_FUNCNAME( TCOMBOBOX )}, NULL },
{ "NAT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "REFRESH", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "IXBROWSE", {HB_FS_PUBLIC}, {HB_FUNCNAME( IXBROWSE )}, NULL },
{ "_BCLRSEL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BCLRSELFOCUS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CALIAS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NMARQUEESTYLE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CNAME", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDCOL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SET", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CHEADER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BLDBLCLICK", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BRCLICKED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "RBUTTONDOWN", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CREATEFROMRESOURCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ISREPORT", {HB_FS_PUBLIC}, {HB_FUNCNAME( ISREPORT )}, NULL },
{ "VALTYPE", {HB_FS_PUBLIC}, {HB_FUNCNAME( VALTYPE )}, NULL },
{ "DESTROYFASTFILTER", {HB_FS_PUBLIC}, {HB_FUNCNAME( DESTROYFASTFILTER )}, NULL },
{ "SETBRWOPT", {HB_FS_PUBLIC}, {HB_FUNCNAME( SETBRWOPT )}, NULL },
{ "ORDNUMBER", {HB_FS_PUBLIC}, {HB_FUNCNAME( ORDNUMBER )}, NULL },
{ "LTVTA", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( LTVTA )}, NULL },
{ "LEXISTTABLE", {HB_FS_PUBLIC}, {HB_FUNCNAME( LEXISTTABLE )}, NULL },
{ "MKTVTA", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( MKTVTA )}, NULL },
{ "LEXISTINDEX", {HB_FS_PUBLIC}, {HB_FUNCNAME( LEXISTINDEX )}, NULL },
{ "RXTVTA", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( RXTVTA )}, NULL },
{ "DBCREATE", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBCREATE )}, NULL },
{ "ASQLSTRUCT", {HB_FS_PUBLIC}, {HB_FUNCNAME( ASQLSTRUCT )}, NULL },
{ "FERASE", {HB_FS_PUBLIC}, {HB_FUNCNAME( FERASE )}, NULL },
{ "NETERR", {HB_FS_PUBLIC}, {HB_FUNCNAME( NETERR )}, NULL },
{ "__DBPACK", {HB_FS_PUBLIC}, {HB_FUNCNAME( __DBPACK )}, NULL },
{ "ORDCONDSET", {HB_FS_PUBLIC}, {HB_FUNCNAME( ORDCONDSET )}, NULL },
{ "DELETED", {HB_FS_PUBLIC}, {HB_FUNCNAME( DELETED )}, NULL },
{ "ORDCREATE", {HB_FS_PUBLIC}, {HB_FUNCNAME( ORDCREATE )}, NULL },
{ "NVTAUND", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( NVTAUND )}, NULL },
{ "NUNDMOV", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "NVTAIMP", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( NVTAIMP )}, NULL },
{ "NIMPMOV", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "ISTIPOVENTAS", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( ISTIPOVENTAS )}, NULL },
{ "__DBLOCATE", {HB_FS_PUBLIC}, {HB_FUNCNAME( __DBLOCATE )}, NULL },
{ "FOUND", {HB_FS_PUBLIC}, {HB_FUNCNAME( FOUND )}, NULL },
{ "DBGATHER", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBGATHER )}, NULL },
{ "FW_GT", {HB_FS_PUBLIC}, {HB_FUNCNAME( FW_GT )}, NULL },
{ "ERRORSYS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORSYS )}, NULL },
{ "(_INITSTATICS00005)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITSTATICS}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_TVTA, ".\\.\\Prg\\Tvta.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_TVTA
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_TVTA )
   #include "hbiniseg.h"
#endif

HB_FUNC( AITMTVTA )
{
	static const HB_BYTE pcode[] =
	{
		13,1,0,36,23,0,4,0,0,80,1,36,25,0,
		176,2,0,95,1,106,8,67,67,79,68,77,79,86,
		0,106,2,67,0,92,2,121,106,19,84,105,112,111,
		32,100,101,32,109,111,118,105,109,105,101,110,116,111,
		0,106,1,0,106,1,0,106,9,40,32,99,68,98,
		102,32,41,0,4,8,0,20,2,36,26,0,176,2,
		0,95,1,106,8,67,68,69,83,77,79,86,0,106,
		2,67,0,92,20,121,106,35,68,101,115,99,114,105,
		112,99,105,243,110,32,100,101,108,32,116,105,112,111,
		32,100,101,32,109,111,118,105,109,105,101,110,116,111,
		0,106,1,0,106,1,0,106,9,40,32,99,68,98,
		102,32,41,0,4,8,0,20,2,36,27,0,176,2,
		0,95,1,106,8,78,85,78,68,77,79,86,0,106,
		2,78,0,122,121,106,27,67,111,109,112,111,114,116,
		97,109,105,101,110,116,111,32,101,110,32,117,110,105,
		100,97,100,101,115,0,106,1,0,106,1,0,106,9,
		40,32,99,68,98,102,32,41,0,4,8,0,20,2,
		36,28,0,176,2,0,95,1,106,8,78,73,77,80,
		77,79,86,0,106,2,78,0,122,121,106,25,67,111,
		109,112,111,114,116,97,109,105,101,110,116,111,32,101,
		110,32,112,114,101,99,105,111,0,106,1,0,106,1,
		0,106,9,40,32,99,68,98,102,32,41,0,4,8,
		0,20,2,36,30,0,95,1,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( TVTA )
{
	static const HB_BYTE pcode[] =
	{
		13,1,2,116,160,0,36,38,0,95,1,100,8,28,
		12,106,6,48,49,48,52,51,0,80,1,36,39,0,
		95,2,100,8,28,9,176,4,0,12,0,80,2,36,
		41,0,103,2,0,100,8,29,149,4,36,47,0,176,
		5,0,95,1,12,1,80,3,36,49,0,176,6,0,
		95,3,122,12,2,121,69,28,39,36,50,0,176,7,
		0,106,21,65,99,99,101,115,111,32,110,111,32,112,
		101,114,109,105,116,105,100,111,46,0,20,1,36,51,
		0,100,110,7,36,58,0,95,2,100,69,28,23,36,
		59,0,176,8,0,20,0,48,9,0,95,2,112,0,
		73,176,8,0,20,0,36,66,0,176,10,0,12,0,
		31,8,36,67,0,100,110,7,36,74,0,176,11,0,
		106,15,84,105,112,111,115,32,100,101,32,118,101,110,
		116,97,0,176,12,0,12,0,20,2,36,89,0,48,
		13,0,176,14,0,12,0,92,2,92,10,92,18,92,
		70,106,15,84,105,112,111,115,32,100,101,32,118,101,
		110,116,97,0,100,95,2,100,100,9,100,100,103,3,
		0,100,100,100,100,106,7,67,243,100,105,103,111,0,
		106,7,78,111,109,98,114,101,0,4,2,0,90,22,
		176,15,0,48,16,0,103,2,0,112,0,103,4,0,
		103,3,0,12,3,6,90,22,176,17,0,48,16,0,
		103,2,0,112,0,103,4,0,103,3,0,12,3,6,
		90,19,176,18,0,48,16,0,103,2,0,112,0,103,
		3,0,12,2,6,90,22,176,19,0,48,16,0,103,
		2,0,112,0,103,4,0,103,3,0,12,3,6,100,
		95,3,106,13,103,99,95,119,97,108,108,101,116,95,
		49,54,0,97,104,0,63,0,100,100,120,112,29,82,
		2,0,36,91,0,48,20,0,103,2,0,112,0,143,
		36,92,0,144,21,0,106,7,67,243,100,105,103,111,
		0,112,1,73,36,93,0,144,22,0,106,8,99,67,
		111,100,77,111,118,0,112,1,73,36,94,0,144,23,
		0,90,9,103,3,0,88,24,0,6,112,1,73,36,
		95,0,144,25,0,92,80,112,1,73,36,96,0,144,
		26,0,89,18,0,4,0,0,0,48,27,0,103,2,
		0,95,4,112,1,6,112,1,73,145,36,99,0,48,
		20,0,103,2,0,112,0,143,36,100,0,144,21,0,
		106,7,78,111,109,98,114,101,0,112,1,73,36,101,
		0,144,22,0,106,8,99,68,101,115,77,111,118,0,
		112,1,73,36,102,0,144,23,0,90,9,103,3,0,
		88,28,0,6,112,1,73,36,103,0,144,25,0,93,
		200,0,112,1,73,36,104,0,144,26,0,89,18,0,
		4,0,0,0,48,27,0,103,2,0,95,4,112,1,
		6,112,1,73,145,36,107,0,48,29,0,103,2,0,
		106,22,77,111,118,105,109,105,101,110,116,111,115,32,
		100,101,32,118,101,110,116,97,115,0,112,1,73,36,
		109,0,48,30,0,103,2,0,112,0,73,36,115,0,
		48,31,0,103,2,0,106,4,66,85,83,0,100,100,
		90,11,48,32,0,103,2,0,112,0,6,106,9,40,
		66,41,117,115,99,97,114,0,106,2,66,0,100,100,
		100,100,9,112,11,73,36,117,0,48,33,0,103,2,
		0,112,0,73,36,126,0,48,31,0,103,2,0,106,
		4,78,69,87,0,100,100,90,11,48,34,0,103,2,
		0,112,0,6,106,9,40,65,41,241,97,100,105,114,
		0,106,2,65,0,100,100,92,2,100,9,112,11,73,
		36,134,0,48,31,0,103,2,0,106,4,68,85,80,
		0,100,100,90,11,48,35,0,103,2,0,112,0,6,
		106,11,40,68,41,117,112,108,105,99,97,114,0,106,
		2,68,0,100,100,92,2,100,9,112,11,73,36,142,
		0,48,31,0,103,2,0,106,5,69,68,73,84,0,
		100,100,90,11,48,36,0,103,2,0,112,0,6,106,
		12,40,77,41,111,100,105,102,105,99,97,114,0,106,
		2,77,0,100,100,92,4,100,9,112,11,73,36,150,
		0,48,31,0,103,2,0,106,5,90,79,79,77,0,
		100,100,90,22,176,37,0,48,16,0,103,2,0,112,
		0,103,4,0,103,3,0,12,3,6,106,7,40,90,
		41,111,111,109,0,106,2,90,0,100,100,92,8,100,
		9,112,11,73,36,158,0,48,31,0,103,2,0,106,
		4,68,69,76,0,100,100,90,11,48,38,0,103,2,
		0,112,0,6,106,11,40,69,41,108,105,109,105,110,
		97,114,0,106,2,69,0,100,100,92,16,100,9,112,
		11,73,36,167,0,48,31,0,103,2,0,106,4,73,
		77,80,0,100,100,90,51,48,39,0,48,13,0,176,
		40,0,12,0,106,31,76,105,115,116,97,100,111,32,
		100,101,32,116,105,112,111,115,32,100,101,32,109,111,
		118,105,109,105,101,110,116,111,0,112,1,112,0,6,
		106,10,40,76,41,105,115,116,97,100,111,0,106,2,
		76,0,100,100,92,8,100,9,112,11,73,36,175,0,
		48,31,0,103,2,0,106,4,69,78,68,0,100,100,
		90,11,48,41,0,103,2,0,112,0,6,106,8,40,
		83,41,97,108,105,114,0,106,2,83,0,100,100,100,
		100,9,112,11,73,36,177,0,48,42,0,103,2,0,
		100,48,43,0,103,2,0,112,0,48,44,0,103,2,
		0,112,0,48,45,0,103,2,0,112,0,48,46,0,
		103,2,0,112,0,48,47,0,103,2,0,112,0,48,
		48,0,103,2,0,112,0,48,49,0,103,2,0,112,
		0,100,100,100,100,100,100,100,100,90,8,176,50,0,
		12,0,6,100,48,51,0,103,2,0,112,0,9,112,
		20,73,25,14,36,181,0,48,52,0,103,2,0,112,
		0,73,36,185,0,100,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( EDTREC )
{
	static const HB_BYTE pcode[] =
	{
		13,2,7,36,194,0,48,13,0,176,53,0,12,0,
		100,100,100,100,176,54,0,95,7,12,1,106,15,84,
		105,112,111,115,32,100,101,32,86,101,110,116,97,0,
		72,106,5,84,86,84,65,0,100,9,100,100,100,100,
		100,9,100,100,100,100,100,9,100,106,5,111,68,108,
		103,0,100,100,112,24,80,8,36,202,0,48,55,0,
		176,56,0,12,0,92,110,89,32,0,1,0,1,0,
		1,0,176,57,0,12,0,121,8,28,8,95,255,122,
		1,25,9,95,1,165,95,255,122,2,6,95,8,100,
		106,3,64,33,0,89,26,0,0,0,2,0,9,0,
		3,0,176,58,0,95,255,95,254,120,106,2,48,0,
		12,4,6,106,5,78,47,87,42,0,100,100,100,100,
		9,89,23,0,0,0,1,0,7,0,95,255,122,8,
		21,31,8,73,95,255,92,4,8,6,100,9,9,100,
		100,100,100,100,100,100,100,100,112,25,80,9,36,208,
		0,48,55,0,176,56,0,12,0,92,120,89,34,0,
		1,0,1,0,1,0,176,57,0,12,0,121,8,28,
		9,95,255,92,2,1,25,10,95,1,165,95,255,92,
		2,2,6,95,8,100,100,100,106,5,78,47,87,42,
		0,100,100,100,100,9,89,15,0,0,0,1,0,7,
		0,95,255,92,3,69,6,100,9,9,100,100,100,100,
		100,100,100,100,100,112,25,73,36,213,0,48,55,0,
		176,59,0,12,0,89,34,0,1,0,1,0,1,0,
		176,57,0,12,0,121,8,28,9,95,255,92,3,1,
		25,10,95,1,165,95,255,92,3,2,6,95,8,100,
		93,130,0,93,131,0,93,132,0,4,3,0,100,100,
		100,100,9,89,15,0,0,0,1,0,7,0,95,255,
		92,3,69,6,100,112,11,73,36,218,0,48,55,0,
		176,59,0,12,0,89,34,0,1,0,1,0,1,0,
		176,57,0,12,0,121,8,28,9,95,255,92,4,1,
		25,10,95,1,165,95,255,92,4,2,6,95,8,100,
		93,140,0,93,141,0,93,142,0,4,3,0,100,100,
		100,100,9,89,15,0,0,0,1,0,7,0,95,255,
		92,3,69,6,100,112,11,73,36,224,0,48,55,0,
		176,60,0,12,0,122,89,77,0,0,0,7,0,7,
		0,9,0,1,0,2,0,3,0,4,0,8,0,95,
		255,92,4,8,28,33,48,61,0,95,254,112,0,28,
		21,176,62,0,95,253,95,252,95,251,95,250,95,255,
		95,249,12,6,25,22,100,25,19,176,62,0,95,253,
		95,252,95,251,95,250,95,255,95,249,12,6,6,95,
		8,100,100,9,89,15,0,0,0,1,0,7,0,95,
		255,92,3,69,6,100,100,9,112,10,73,36,230,0,
		48,55,0,176,60,0,12,0,92,2,89,17,0,0,
		0,1,0,8,0,48,41,0,95,255,112,0,6,95,
		8,100,100,9,100,100,100,120,112,10,73,36,235,0,
		48,55,0,176,60,0,12,0,93,47,2,90,8,176,
		63,0,12,0,6,95,8,100,100,9,100,100,100,9,
		112,10,73,36,237,0,95,7,92,3,69,28,92,36,
		240,0,48,64,0,95,8,92,116,89,77,0,0,0,
		7,0,7,0,9,0,1,0,2,0,3,0,4,0,
		8,0,95,255,92,4,8,28,33,48,61,0,95,254,
		112,0,28,21,176,62,0,95,253,95,252,95,251,95,
		250,95,255,95,249,12,6,25,22,100,25,19,176,62,
		0,95,253,95,252,95,251,95,250,95,255,95,249,12,
		6,6,112,2,73,36,243,0,48,64,0,95,8,92,
		112,90,8,176,63,0,12,0,6,112,2,73,36,245,
		0,48,65,0,95,8,89,17,0,0,0,1,0,9,
		0,48,52,0,95,255,112,0,6,112,1,73,36,247,
		0,48,42,0,95,8,48,43,0,95,8,112,0,48,
		45,0,95,8,112,0,48,47,0,95,8,112,0,120,
		100,100,100,48,44,0,95,8,112,0,100,100,100,112,
		11,73,36,249,0,48,66,0,95,8,112,0,122,8,
		110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( LPRESAVE )
{
	static const HB_BYTE pcode[] =
	{
		13,0,6,36,255,0,95,5,122,8,31,9,95,5,
		92,4,8,28,74,36,1,1,176,67,0,95,1,92,
		2,1,106,8,67,67,79,68,77,79,86,0,95,3,
		12,3,28,47,36,2,1,176,7,0,106,18,67,243,
		100,105,103,111,32,121,97,32,101,120,105,115,116,101,
		32,0,176,68,0,95,1,92,2,1,12,1,72,20,
		1,36,3,1,100,110,7,36,8,1,176,69,0,95,
		1,92,2,1,12,1,28,73,36,9,1,176,7,0,
		106,55,76,97,32,100,101,115,99,114,105,112,99,105,
		243,110,32,100,101,108,32,116,105,112,111,32,100,101,
		32,118,101,110,116,97,32,110,111,32,112,117,101,100,
		101,32,101,115,116,97,114,32,118,97,99,237,97,46,
		0,20,1,36,10,1,9,110,7,36,13,1,176,70,
		0,95,1,95,2,95,3,95,4,95,5,20,5,36,
		15,1,48,41,0,95,6,122,112,1,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( GENREPORT )
{
	static const HB_BYTE pcode[] =
	{
		13,7,1,36,24,1,85,95,1,74,176,72,0,12,
		0,119,80,5,36,25,1,176,73,0,176,74,0,12,
		0,106,4,32,45,32,0,72,176,75,0,12,0,72,
		92,50,12,2,80,6,36,26,1,176,73,0,106,27,
		76,105,115,116,97,100,111,32,100,101,32,116,105,112,
		111,115,32,100,101,32,118,101,110,116,97,115,0,92,
		50,12,2,80,7,36,27,1,122,80,8,36,33,1,
		176,76,0,96,6,0,96,7,0,96,8,0,12,3,
		29,1,3,36,35,1,85,95,1,74,176,77,0,20,
		0,74,36,41,1,48,13,0,176,78,0,12,0,106,
		12,67,111,117,114,105,101,114,32,78,101,119,0,121,
		92,246,100,120,100,100,100,100,100,100,100,100,100,100,
		100,100,112,17,80,3,36,42,1,48,13,0,176,78,
		0,12,0,106,12,67,111,117,114,105,101,114,32,78,
		101,119,0,121,92,246,100,100,100,100,100,100,100,100,
		100,100,100,100,100,100,112,17,80,4,36,44,1,95,
		8,122,8,29,184,0,36,53,1,176,79,0,89,17,
		0,0,0,1,0,6,0,176,68,0,95,255,12,1,
		6,89,17,0,0,0,1,0,7,0,176,68,0,95,
		255,12,1,6,4,2,0,90,24,106,8,70,101,99,
		104,97,58,32,0,176,80,0,176,81,0,12,0,12,
		1,72,6,4,1,0,89,37,0,0,0,1,0,2,
		0,106,10,80,225,103,105,110,97,32,58,32,0,176,
		82,0,48,83,0,95,255,112,0,92,3,12,2,72,
		6,4,1,0,95,3,95,4,4,2,0,4,0,0,
		9,100,100,100,120,100,100,106,25,76,105,115,116,97,
		110,100,111,32,84,105,112,111,115,32,100,101,32,86,
		101,110,116,97,115,0,100,106,6,82,73,71,72,84,
		0,106,9,67,69,78,84,69,82,69,68,0,12,16,
		80,2,26,181,0,36,64,1,176,79,0,89,17,0,
		0,0,1,0,6,0,176,68,0,95,255,12,1,6,
		89,17,0,0,0,1,0,7,0,176,68,0,95,255,
		12,1,6,4,2,0,90,24,106,8,70,101,99,104,
		97,58,32,0,176,80,0,176,81,0,12,0,12,1,
		72,6,4,1,0,89,37,0,0,0,1,0,2,0,
		106,10,80,225,103,105,110,97,32,58,32,0,176,82,
		0,48,83,0,95,255,112,0,92,3,12,2,72,6,
		4,1,0,95,3,95,4,4,2,0,4,0,0,9,
		100,100,120,9,100,100,106,25,76,105,115,116,97,110,
		100,111,32,84,105,112,111,115,32,100,101,32,86,101,
		110,116,97,115,0,100,106,6,82,73,71,72,84,0,
		106,9,67,69,78,84,69,82,69,68,0,12,16,80,
		2,36,70,1,176,84,0,90,10,106,5,84,105,112,
		111,0,6,4,1,0,100,89,15,0,0,0,1,0,
		1,0,95,255,88,24,0,6,4,1,0,100,4,0,
		0,90,5,92,2,6,9,100,100,9,9,100,9,9,
		100,100,9,100,9,100,100,9,100,4,0,0,100,100,
		20,26,36,74,1,176,84,0,90,17,106,12,68,101,
		115,99,114,105,112,99,105,243,110,0,6,4,1,0,
		100,89,15,0,0,0,1,0,1,0,95,255,88,28,
		0,6,4,1,0,100,4,0,0,90,5,92,2,6,
		9,100,100,9,9,100,9,9,100,100,9,100,9,100,
		100,9,100,4,0,0,100,100,20,26,36,76,1,176,
		85,0,20,0,36,78,1,176,69,0,95,2,12,1,
		31,58,48,86,0,95,2,112,0,28,49,36,79,1,
		48,87,0,95,2,121,92,2,92,2,112,3,73,36,
		80,1,48,88,0,95,2,89,20,0,0,0,1,0,
		1,0,85,95,255,74,176,89,0,12,0,119,6,112,
		1,73,36,83,1,48,42,0,95,2,100,89,21,0,
		0,0,1,0,1,0,85,95,255,74,176,90,0,12,
		0,119,68,6,100,100,100,100,100,100,100,100,100,100,
		100,100,112,14,73,36,85,1,48,41,0,95,3,112,
		0,73,36,86,1,48,41,0,95,4,112,0,73,36,
		90,1,85,95,1,74,176,91,0,95,5,20,1,74,
		36,92,1,100,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( CTVTA )
{
	static const HB_BYTE pcode[] =
	{
		13,2,3,36,99,1,9,80,4,36,100,1,48,93,
		0,95,1,112,0,80,5,36,102,1,176,69,0,95,
		5,12,1,28,28,36,103,1,95,3,100,69,28,13,
		48,94,0,95,3,106,1,0,112,1,73,36,104,1,
		120,110,7,36,106,1,176,95,0,95,1,106,2,48,
		0,12,2,80,5,36,109,1,85,95,2,74,176,96,
		0,95,5,12,1,119,28,51,36,111,1,48,94,0,
		95,1,95,2,88,24,0,112,1,73,36,113,1,95,
		3,100,69,28,18,36,114,1,48,94,0,95,3,95,
		2,88,28,0,112,1,73,36,117,1,120,80,4,25,
		45,36,121,1,176,7,0,106,33,84,105,112,111,32,
		100,101,32,109,111,118,105,109,105,101,110,116,111,32,
		110,111,32,101,110,99,111,110,116,114,97,100,111,0,
		20,1,36,125,1,95,4,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( RETTVTA )
{
	static const HB_BYTE pcode[] =
	{
		13,5,2,36,133,1,106,1,0,80,5,36,134,1,
		9,80,6,36,135,1,176,98,0,12,0,80,7,36,
		137,1,176,99,0,89,15,0,1,0,0,0,176,100,
		0,95,1,12,1,6,12,1,80,4,36,138,1,113,
		158,0,0,36,140,1,176,69,0,95,1,12,1,31,
		90,36,141,1,176,101,0,120,176,102,0,12,0,95,
		7,106,9,84,86,84,65,46,68,66,70,0,72,176,
		103,0,106,5,84,86,116,97,0,96,1,0,12,2,
		120,9,20,6,36,142,1,176,104,0,12,0,31,23,
		176,105,0,95,7,106,9,84,86,84,65,46,67,68,
		88,0,72,20,1,25,8,176,106,0,122,20,1,36,
		143,1,120,80,6,36,146,1,85,95,1,74,176,96,
		0,95,2,12,1,119,28,12,36,147,1,95,1,88,
		28,0,80,5,36,150,1,95,6,28,15,36,151,1,
		85,95,1,74,176,107,0,20,0,74,36,152,1,114,
		86,0,0,36,154,1,115,80,3,36,156,1,176,7,
		0,106,58,73,109,112,111,115,105,98,108,101,32,97,
		98,114,105,114,32,116,111,100,97,115,32,108,97,115,
		32,98,97,115,101,115,32,100,101,32,100,97,116,111,
		115,32,100,101,32,109,111,118,105,109,105,101,110,116,
		111,115,13,10,0,176,108,0,95,3,12,1,72,20,
		1,36,160,1,176,99,0,95,4,20,1,36,162,1,
		95,5,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( BRWTVTA )
{
	static const HB_BYTE pcode[] =
	{
		13,13,3,116,160,0,36,174,1,176,110,0,106,8,
		66,114,119,84,86,116,97,0,12,1,80,10,36,176,
		1,106,7,67,243,100,105,103,111,0,106,7,78,111,
		109,98,114,101,0,4,2,0,80,12,36,178,1,9,
		80,14,36,179,1,176,98,0,12,0,80,15,36,180,
		1,176,5,0,106,6,48,49,48,52,50,0,12,1,
		80,16,36,182,1,176,111,0,176,112,0,95,10,122,
		12,2,176,113,0,95,12,12,1,12,2,80,10,36,
		183,1,95,12,95,10,1,80,13,36,185,1,176,99,
		0,89,15,0,1,0,0,0,176,100,0,95,1,12,
		1,6,12,1,80,9,36,186,1,113,203,5,0,36,
		188,1,176,69,0,95,2,12,1,31,90,36,189,1,
		176,101,0,120,176,102,0,12,0,95,15,106,9,84,
		86,84,65,46,68,66,70,0,72,176,103,0,106,5,
		84,86,116,97,0,96,2,0,12,2,120,9,20,6,
		36,190,1,176,104,0,12,0,31,23,176,105,0,95,
		15,106,9,84,86,84,65,46,67,68,88,0,72,20,
		1,25,8,176,106,0,122,20,1,36,192,1,120,80,
		14,36,195,1,85,95,2,74,176,77,0,20,0,74,
		36,197,1,48,13,0,176,53,0,12,0,100,100,100,
		100,106,15,84,105,112,111,115,32,100,101,32,118,101,
		110,116,97,0,106,10,72,69,76,80,69,78,84,82,
		89,0,100,9,100,100,100,100,100,9,100,100,100,100,
		100,9,100,106,5,111,68,108,103,0,100,100,112,24,
		80,4,36,204,1,48,55,0,176,56,0,12,0,92,
		104,89,28,0,1,0,1,0,6,0,176,57,0,12,
		0,121,8,28,6,95,255,25,7,95,1,165,80,255,
		6,95,4,100,100,89,21,0,0,0,2,0,7,0,
		2,0,176,114,0,95,255,95,254,12,2,6,100,100,
		100,100,100,9,100,89,27,0,3,0,2,0,7,0,
		2,0,176,115,0,95,1,95,2,95,3,95,255,95,
		254,12,5,6,9,9,100,100,100,100,100,100,106,5,
		70,73,78,68,0,100,100,112,25,80,5,36,211,1,
		48,55,0,176,116,0,12,0,92,102,89,28,0,1,
		0,1,0,13,0,176,57,0,12,0,121,8,28,6,
		95,255,25,7,95,1,165,80,255,6,95,12,95,4,
		100,100,89,48,0,1,0,4,0,2,0,11,0,7,
		0,5,0,85,95,255,74,176,106,0,48,117,0,95,
		254,112,0,20,1,74,48,118,0,95,253,112,0,73,
		48,52,0,95,252,112,0,6,100,100,100,9,100,100,
		100,100,100,100,112,17,80,11,36,213,1,48,13,0,
		176,119,0,12,0,95,4,112,1,80,7,36,215,1,
		48,120,0,95,7,90,12,121,97,229,229,229,0,4,
		2,0,6,112,1,73,36,216,1,48,121,0,95,7,
		90,12,121,97,167,205,240,0,4,2,0,6,112,1,
		73,36,218,1,48,122,0,95,7,95,2,112,1,73,
		36,220,1,48,123,0,95,7,92,5,112,1,73,36,
		221,1,48,124,0,95,7,106,29,66,114,111,119,115,
		101,46,77,111,118,105,109,105,101,110,116,111,115,32,
		100,101,32,118,101,110,116,97,115,0,112,1,73,36,
		223,1,48,125,0,95,7,112,0,143,36,224,1,144,
		21,0,106,7,67,243,100,105,103,111,0,112,1,73,
		36,225,1,144,22,0,106,8,99,67,111,100,77,111,
		118,0,112,1,73,36,226,1,144,23,0,89,15,0,
		0,0,1,0,2,0,95,255,88,24,0,6,112,1,
		73,36,227,1,144,25,0,92,80,112,1,73,36,228,
		1,144,26,0,89,24,0,4,0,1,0,11,0,48,
		126,0,95,255,48,127,0,95,4,112,0,112,1,6,
		112,1,73,145,36,231,1,48,125,0,95,7,112,0,
		143,36,232,1,144,21,0,106,7,78,111,109,98,114,
		101,0,112,1,73,36,233,1,144,22,0,106,8,99,
		68,101,115,77,111,118,0,112,1,73,36,234,1,144,
		23,0,89,15,0,0,0,1,0,2,0,95,255,88,
		28,0,6,112,1,73,36,235,1,144,25,0,93,200,
		0,112,1,73,36,236,1,144,26,0,89,24,0,4,
		0,1,0,11,0,48,126,0,95,255,48,127,0,95,
		4,112,0,112,1,6,112,1,73,145,36,239,1,48,
		128,0,95,7,89,18,0,0,0,1,0,4,0,48,
		41,0,95,255,122,112,1,6,112,1,73,36,240,1,
		48,129,0,95,7,89,23,0,3,0,1,0,7,0,
		48,130,0,95,255,95,1,95,2,95,3,112,3,6,
		112,1,73,36,242,1,48,131,0,95,7,92,105,112,
		1,73,36,247,1,48,55,0,176,60,0,12,0,122,
		89,18,0,0,0,1,0,4,0,48,41,0,95,255,
		122,112,1,6,95,4,100,100,9,100,100,100,9,112,
		10,73,36,252,1,48,55,0,176,60,0,12,0,92,
		2,89,17,0,0,0,1,0,4,0,48,41,0,95,
		255,112,0,6,95,4,100,100,9,100,100,100,9,112,
		10,73,36,3,2,48,55,0,176,60,0,12,0,93,
		244,1,89,24,0,0,0,2,0,7,0,2,0,176,
		15,0,95,255,103,4,0,95,254,12,3,6,95,4,
		100,100,9,89,31,0,0,0,1,0,16,0,176,6,
		0,95,255,92,2,12,2,121,69,21,28,9,73,176,
		132,0,12,0,68,6,100,100,9,112,10,73,36,8,
		2,48,55,0,176,60,0,12,0,93,245,1,89,24,
		0,0,0,2,0,7,0,2,0,176,17,0,95,255,
		103,4,0,95,254,12,3,6,95,4,100,100,9,89,
		31,0,0,0,1,0,16,0,176,6,0,95,255,92,
		4,12,2,121,69,21,28,9,73,176,132,0,12,0,
		68,6,100,100,9,112,10,73,36,11,2,176,6,0,
		95,16,92,2,12,2,121,69,28,46,176,132,0,12,
		0,31,39,36,12,2,48,64,0,95,4,92,113,89,
		24,0,0,0,2,0,7,0,2,0,176,15,0,95,
		255,103,4,0,95,254,12,3,6,112,2,73,36,15,
		2,176,6,0,95,16,92,4,12,2,121,69,28,46,
		176,132,0,12,0,31,39,36,16,2,48,64,0,95,
		4,92,114,89,24,0,0,0,2,0,7,0,2,0,
		176,17,0,95,255,103,4,0,95,254,12,3,6,112,
		2,73,36,19,2,48,64,0,95,4,92,116,89,18,
		0,0,0,1,0,4,0,48,41,0,95,255,122,112,
		1,6,112,2,73,36,20,2,48,64,0,95,4,92,
		13,89,18,0,0,0,1,0,4,0,48,41,0,95,
		255,122,112,1,6,112,2,73,36,22,2,48,42,0,
		95,4,48,43,0,95,4,112,0,48,45,0,95,4,
		112,0,48,47,0,95,4,112,0,120,100,100,100,48,
		44,0,95,4,112,0,100,100,100,112,11,73,36,24,
		2,48,66,0,95,4,112,0,122,8,28,62,36,26,
		2,48,94,0,95,1,95,2,88,24,0,112,1,73,
		36,27,2,48,61,0,95,1,112,0,73,36,29,2,
		176,133,0,95,3,12,1,106,2,79,0,8,28,18,
		36,30,2,48,94,0,95,3,95,2,88,28,0,112,
		1,73,36,35,2,176,134,0,95,2,20,1,36,37,
		2,176,135,0,106,8,66,114,119,84,86,116,97,0,
		85,95,2,74,176,136,0,12,0,119,20,2,36,39,
		2,48,52,0,95,1,112,0,73,36,41,2,95,14,
		28,15,36,42,2,85,95,2,74,176,107,0,20,0,
		74,36,43,2,114,87,0,0,36,45,2,115,80,8,
		36,47,2,176,7,0,176,108,0,95,8,12,1,106,
		60,73,109,112,111,115,105,98,108,101,32,97,98,114,
		105,114,32,116,111,100,97,115,32,108,97,115,32,98,
		97,115,101,115,32,100,101,32,100,97,116,111,115,32,
		100,101,32,116,105,112,111,115,32,100,101,32,118,101,
		110,116,97,115,0,20,2,36,51,2,176,99,0,95,
		9,20,1,36,53,2,48,66,0,95,4,112,0,122,
		8,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( LTVTA )
{
	static const HB_BYTE pcode[] =
	{
		13,5,2,36,61,2,9,80,5,36,62,2,9,80,
		6,36,63,2,176,98,0,12,0,80,7,36,65,2,
		176,99,0,89,15,0,1,0,0,0,176,100,0,95,
		1,12,1,6,12,1,80,4,36,66,2,113,203,0,
		0,36,68,2,176,69,0,95,1,12,1,31,90,36,
		69,2,176,101,0,120,176,102,0,12,0,95,7,106,
		9,84,86,84,65,46,68,66,70,0,72,176,103,0,
		106,5,84,86,116,97,0,96,1,0,12,2,120,9,
		20,6,36,70,2,176,104,0,12,0,31,23,176,105,
		0,95,7,106,9,84,86,84,65,46,67,68,88,0,
		72,20,1,25,8,176,106,0,122,20,1,36,71,2,
		120,80,6,36,74,2,85,95,1,74,176,96,0,95,
		2,12,1,119,28,10,36,75,2,120,80,5,25,49,
		36,77,2,176,7,0,106,31,84,105,112,111,32,100,
		101,32,109,111,118,105,109,105,101,110,116,111,32,105,
		110,101,120,105,115,116,101,110,116,101,0,20,1,36,
		78,2,9,80,5,36,81,2,95,6,28,15,36,82,
		2,85,95,1,74,176,107,0,20,0,74,36,83,2,
		114,87,0,0,36,85,2,115,80,3,36,87,2,176,
		7,0,176,108,0,95,3,12,1,106,60,73,109,112,
		111,115,105,98,108,101,32,97,98,114,105,114,32,116,
		111,100,97,115,32,108,97,115,32,98,97,115,101,115,
		32,100,101,32,100,97,116,111,115,32,100,101,32,116,
		105,112,111,115,32,100,101,32,118,101,110,116,97,115,
		0,20,2,36,91,2,176,99,0,95,4,20,1,36,
		93,2,95,5,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( OPENFILES )
{
	static const HB_BYTE pcode[] =
	{
		13,4,1,116,160,0,36,99,2,176,98,0,12,0,
		80,2,36,100,2,120,80,3,36,104,2,176,138,0,
		95,2,106,9,84,86,116,97,46,68,98,102,0,72,
		12,1,31,12,36,105,2,176,139,0,95,2,20,1,
		36,108,2,176,140,0,95,2,106,9,84,86,116,97,
		46,67,100,120,0,72,12,1,31,12,36,109,2,176,
		141,0,95,2,20,1,36,112,2,176,99,0,89,15,
		0,1,0,0,0,176,100,0,95,1,12,1,6,12,
		1,80,5,36,113,2,113,90,0,0,36,115,2,176,
		101,0,120,176,102,0,12,0,95,2,106,9,84,86,
		116,97,46,68,98,102,0,72,176,103,0,106,5,84,
		86,84,65,0,104,3,0,12,2,120,9,20,6,36,
		116,2,176,104,0,12,0,31,23,176,105,0,95,2,
		106,9,84,86,116,97,46,67,100,120,0,72,20,1,
		25,8,176,106,0,122,20,1,114,103,0,0,36,118,
		2,115,73,36,120,2,176,50,0,20,0,36,122,2,
		9,80,3,36,124,2,176,7,0,106,62,73,109,112,
		111,115,105,98,108,101,32,97,98,114,105,114,32,116,
		111,100,97,115,32,108,97,115,32,98,97,115,101,115,
		32,100,101,32,100,97,116,111,115,32,100,101,32,116,
		105,112,111,115,32,100,101,32,118,101,110,116,97,115,
		13,10,0,176,108,0,95,4,12,1,72,20,1,36,
		128,2,176,99,0,95,5,20,1,36,130,2,95,3,
		110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( CLOSEFILES )
{
	static const HB_BYTE pcode[] =
	{
		116,160,0,36,136,2,85,103,3,0,74,176,107,0,
		20,0,74,36,138,2,100,82,2,0,36,140,2,120,
		110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( MKTVTA )
{
	static const HB_BYTE pcode[] =
	{
		13,0,2,36,149,2,95,2,100,8,28,5,9,80,
		2,36,151,2,176,138,0,95,1,106,9,84,86,116,
		97,46,68,98,102,0,72,12,1,31,39,36,153,2,
		176,142,0,95,1,106,9,84,86,116,97,46,68,98,
		102,0,72,176,143,0,176,1,0,12,0,12,1,176,
		102,0,12,0,20,3,36,169,2,176,141,0,95,1,
		20,1,36,171,2,100,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( RXTVTA )
{
	static const HB_BYTE pcode[] =
	{
		13,1,2,36,179,2,95,1,100,8,28,9,176,98,
		0,12,0,80,1,36,181,2,176,138,0,95,1,106,
		9,84,86,116,97,46,68,98,102,0,72,12,1,31,
		12,36,182,2,176,139,0,95,1,20,1,36,185,2,
		176,140,0,95,1,106,9,84,86,116,97,46,67,100,
		120,0,72,12,1,28,24,36,186,2,176,144,0,95,
		1,106,9,84,86,116,97,46,67,100,120,0,72,20,
		1,36,189,2,176,101,0,120,176,102,0,12,0,95,
		1,106,9,84,86,84,65,46,68,66,70,0,72,176,
		103,0,106,5,84,86,116,97,0,96,3,0,12,2,
		9,20,5,36,190,2,85,95,3,74,176,145,0,12,
		0,119,32,222,0,36,191,2,85,95,3,74,176,146,
		0,20,0,74,36,193,2,85,95,3,74,176,147,0,
		106,11,33,68,101,108,101,116,101,100,40,41,0,90,
		9,176,148,0,12,0,68,6,20,2,74,36,194,2,
		85,95,3,74,176,149,0,95,1,106,9,84,86,84,
		65,46,67,68,88,0,72,106,8,67,67,79,68,77,
		79,86,0,106,15,70,105,101,108,100,45,62,67,67,
		79,68,77,79,86,0,90,6,91,24,0,6,100,20,
		5,74,36,196,2,85,95,3,74,176,147,0,106,11,
		33,68,101,108,101,116,101,100,40,41,0,90,9,176,
		148,0,12,0,68,6,20,2,74,36,197,2,85,95,
		3,74,176,149,0,95,1,106,9,84,86,84,65,46,
		67,68,88,0,72,106,8,67,68,69,83,77,79,86,
		0,106,15,70,105,101,108,100,45,62,67,68,69,83,
		77,79,86,0,90,6,91,28,0,6,20,4,74,36,
		199,2,85,95,3,74,176,107,0,20,0,74,25,74,
		36,201,2,176,7,0,106,62,73,109,112,111,115,105,
		98,108,101,32,97,98,114,105,114,32,101,110,32,109,
		111,100,111,32,101,120,99,108,117,115,105,118,111,32,
		108,97,32,116,97,98,108,97,32,100,101,32,116,105,
		112,111,115,32,100,101,32,118,101,110,116,97,115,0,
		20,1,36,204,2,100,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( NVTAUND )
{
	static const HB_BYTE pcode[] =
	{
		13,1,2,36,214,2,122,80,3,36,216,2,85,95,
		2,74,176,96,0,95,1,12,1,119,28,63,36,219,
		2,95,2,88,151,0,122,8,28,10,36,220,2,122,
		80,3,25,43,36,221,2,95,2,88,151,0,92,2,
		8,28,11,36,222,2,92,255,80,3,25,21,36,223,
		2,95,2,88,151,0,92,3,8,28,8,36,224,2,
		121,80,3,36,229,2,95,3,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( NVTAIMP )
{
	static const HB_BYTE pcode[] =
	{
		13,1,2,36,239,2,122,80,3,36,241,2,85,95,
		2,74,176,96,0,95,1,12,1,119,28,63,36,244,
		2,95,2,88,153,0,122,8,28,10,36,245,2,122,
		80,3,25,43,36,246,2,95,2,88,153,0,92,2,
		8,28,11,36,247,2,92,255,80,3,25,21,36,248,
		2,95,2,88,153,0,92,3,8,28,8,36,249,2,
		121,80,3,36,254,2,95,3,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( ISTIPOVENTAS )
{
	static const HB_BYTE pcode[] =
	{
		13,1,0,116,160,0,36,6,3,176,10,0,12,0,
		28,109,36,8,3,122,165,80,1,25,81,36,9,3,
		85,103,3,0,74,176,155,0,89,25,0,0,0,1,
		0,1,0,103,3,0,88,24,0,103,5,0,95,255,
		1,122,1,8,6,20,1,74,36,10,3,85,103,3,
		0,74,176,156,0,12,0,119,31,20,36,11,3,176,
		157,0,103,5,0,95,1,1,103,3,0,120,20,3,
		36,8,3,175,1,0,176,113,0,103,5,0,12,1,
		15,28,168,36,15,3,176,50,0,20,0,36,19,3,
		120,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_INITSTATICS()
{
	static const HB_BYTE pcode[] =
	{
		117,160,0,5,0,116,160,0,4,0,0,82,1,0,
		89,27,0,7,0,0,0,176,0,0,95,1,95,2,
		95,3,95,4,95,5,95,6,95,7,12,7,6,82,
		4,0,106,3,48,48,0,106,7,86,101,110,116,97,
		115,0,122,122,4,4,0,106,3,48,49,0,106,18,
		86,101,110,116,97,115,32,101,115,112,101,99,105,97,
		108,101,115,0,122,122,4,4,0,106,3,48,50,0,
		106,13,68,101,118,111,108,117,99,105,111,110,101,115,
		0,122,122,4,4,0,106,3,48,51,0,106,8,67,
		97,110,106,101,111,115,0,122,122,4,4,0,4,4,
		0,82,5,0,7
	};

	hb_vmExecute( pcode, symbols );
}
