/*
 * Harbour 3.2.0dev (r1307082134)
 * Borland C++ 5.8.2 (32-bit)
 * Generated C source from ".\.\Prg\Dlgtools.prg"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC( CGETEXPRESSION );
HB_FUNC_EXTERN( GETRESOURCES );
HB_FUNC_EXTERN( SPACE );
HB_FUNC_EXTERN( ALIAS );
HB_FUNC_EXTERN( PADR );
HB_FUNC_EXTERN( SETRESOURCES );
HB_FUNC_EXTERN( TDIALOG );
HB_FUNC_EXTERN( TGET );
HB_FUNC_EXTERN( PCOUNT );
HB_FUNC_EXTERN( TLISTBOX );
HB_FUNC_STATIC( CHECKBTN );
HB_FUNC_STATIC( EXPRADD );
HB_FUNC_EXTERN( TBUTTON );
HB_FUNC_STATIC( GETVALUE );
HB_FUNC_STATIC( UNDO );
HB_FUNC_EXTERN( AT );
HB_FUNC_EXTERN( TYPE );
HB_FUNC_EXTERN( MSGINFO );
HB_FUNC_EXTERN( MSGSTOP );
HB_FUNC_STATIC( SHOWFIELDS );
HB_FUNC_EXTERN( ALLTRIM );
HB_FUNC_EXTERN( LEN );
HB_FUNC_EXTERN( ATAIL );
HB_FUNC_EXTERN( ASIZE );
HB_FUNC_EXTERN( TONE );
HB_FUNC_EXTERN( AADD );
HB_FUNC_EXTERN( RTRIM );
HB_FUNC( FILTERING );
HB_FUNC_EXTERN( DBSETFILTER );
HB_FUNC_EXTERN( DBCLEARFILTER );
HB_FUNC_EXTERN( DBGOTOP );
HB_FUNC( CHANGEINDX );
HB_FUNC_EXTERN( ORDNUMBER );
HB_FUNC_EXTERN( DBSETORDER );
HB_FUNC( SETREP );
HB_FUNC( DLGDATELIMIT );
HB_FUNC_EXTERN( TFONT );
HB_FUNC_EXTERN( TSAY );
HB_FUNC( HELPBROWSE );
HB_FUNC_EXTERN( ORDCLEARSCOPE );
HB_FUNC_EXTERN( AUTOSEEK );
HB_FUNC_EXTERN( TRADMENU );
HB_FUNC_EXTERN( ORDSETFOCUS );
HB_FUNC_EXTERN( TWBROWSE );
HB_FUNC_EXTERN( FIELDGET );
HB_FUNC( ERASEFILESINDIRECTORY );
HB_FUNC_EXTERN( AEVAL );
HB_FUNC_EXTERN( DIRECTORY );
HB_FUNC_EXTERN( FERASE );
HB_FUNC( MSGTIME );
HB_FUNC_EXTERN( TTIMER );
HB_FUNC_EXTERN( TMETER );
HB_FUNC_EXTERN( SYSREFRESH );
HB_FUNC( CALENDARIO );
HB_FUNC_EXTERN( DATE );
HB_FUNC_EXTERN( TCALENDAR );
HB_FUNC( ROWCOLDATE );
HB_FUNC( GETDATE );
HB_FUNC_EXTERN( DAY );
HB_FUNC_EXTERN( DOW );
HB_FUNC_EXTERN( INT );
HB_FUNC_EXTERN( EMPTY );
HB_FUNC_EXTERN( CTOD );
HB_FUNC_EXTERN( STRZERO );
HB_FUNC_EXTERN( MAX );
HB_FUNC( ASEMANAS );
HB_FUNC_EXTERN( MONTH );
HB_FUNC_EXTERN( PADL );
HB_FUNC_EXTERN( STR );
HB_FUNC( AEVALVALID );
HB_FUNC( PRINTPREVIEW );
HB_FUNC_EXTERN( CURSORWAIT );
HB_FUNC_EXTERN( STARTDOC );
HB_FUNC_EXTERN( STARTPAGE );
HB_FUNC_EXTERN( GETENHMETAFILE );
HB_FUNC_EXTERN( PLAYENHMETAFILE );
HB_FUNC_EXTERN( DELETEENHMETAFILE );
HB_FUNC_EXTERN( ENDPAGE );
HB_FUNC_EXTERN( ENDDOC );
HB_FUNC_EXTERN( CURSORARROW );
HB_FUNC( WEEK );
HB_FUNC_EXTERN( VALTYPE );
HB_FUNC_EXTERN( YEAR );
HB_FUNC( PRINTPDF );
HB_FUNC_EXTERN( I2PDF_LICENSE_XH );
HB_FUNC_EXTERN( I2PDF_ADDIMAGE_XH );
HB_FUNC_EXTERN( I2PDF_SETDPI_XH );
HB_FUNC_EXTERN( I2PDF_MAKEPDF_XH );
HB_FUNC( EXITNOSAVE );
HB_FUNC_EXTERN( LASTREC );
HB_FUNC_EXTERN( APOLOMSGNOYES );
HB_FUNC_EXTERN( FW_GT );
HB_FUNC_EXTERN( ERRORSYS );
HB_FUNC_INITSTATICS();


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_DLGTOOLS )
{ "CGETEXPRESSION", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( CGETEXPRESSION )}, NULL },
{ "GETRESOURCES", {HB_FS_PUBLIC}, {HB_FUNCNAME( GETRESOURCES )}, NULL },
{ "SPACE", {HB_FS_PUBLIC}, {HB_FUNCNAME( SPACE )}, NULL },
{ "ALIAS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ALIAS )}, NULL },
{ "PADR", {HB_FS_PUBLIC}, {HB_FUNCNAME( PADR )}, NULL },
{ "SETRESOURCES", {HB_FS_PUBLIC}, {HB_FUNCNAME( SETRESOURCES )}, NULL },
{ "NEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TDIALOG", {HB_FS_PUBLIC}, {HB_FUNCNAME( TDIALOG )}, NULL },
{ "REDEFINE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TGET", {HB_FS_PUBLIC}, {HB_FUNCNAME( TGET )}, NULL },
{ "PCOUNT", {HB_FS_PUBLIC}, {HB_FUNCNAME( PCOUNT )}, NULL },
{ "TLISTBOX", {HB_FS_PUBLIC}, {HB_FUNCNAME( TLISTBOX )}, NULL },
{ "CHECKBTN", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( CHECKBTN )}, NULL },
{ "EXPRADD", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( EXPRADD )}, NULL },
{ "TBUTTON", {HB_FS_PUBLIC}, {HB_FUNCNAME( TBUTTON )}, NULL },
{ "GETVALUE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( GETVALUE )}, NULL },
{ "UNDO", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( UNDO )}, NULL },
{ "AT", {HB_FS_PUBLIC}, {HB_FUNCNAME( AT )}, NULL },
{ "TYPE", {HB_FS_PUBLIC}, {HB_FUNCNAME( TYPE )}, NULL },
{ "MSGINFO", {HB_FS_PUBLIC}, {HB_FUNCNAME( MSGINFO )}, NULL },
{ "MSGSTOP", {HB_FS_PUBLIC}, {HB_FUNCNAME( MSGSTOP )}, NULL },
{ "ACTIVATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BLCLICKED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BMOVED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BPAINTED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SHOWFIELDS", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SHOWFIELDS )}, NULL },
{ "BRCLICKED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NRESULT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ALLTRIM", {HB_FS_PUBLIC}, {HB_FUNCNAME( ALLTRIM )}, NULL },
{ "LEN", {HB_FS_PUBLIC}, {HB_FUNCNAME( LEN )}, NULL },
{ "ATAIL", {HB_FS_PUBLIC}, {HB_FUNCNAME( ATAIL )}, NULL },
{ "REFRESH", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ASIZE", {HB_FS_PUBLIC}, {HB_FUNCNAME( ASIZE )}, NULL },
{ "TONE", {HB_FS_PUBLIC}, {HB_FUNCNAME( TONE )}, NULL },
{ "AADD", {HB_FS_PUBLIC}, {HB_FUNCNAME( AADD )}, NULL },
{ "RTRIM", {HB_FS_PUBLIC}, {HB_FUNCNAME( RTRIM )}, NULL },
{ "RESET", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GOTOP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ENABLE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DISABLE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "END", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FILTERING", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( FILTERING )}, NULL },
{ "DBSETFILTER", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBSETFILTER )}, NULL },
{ "DBCLEARFILTER", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBCLEARFILTER )}, NULL },
{ "DBGOTOP", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBGOTOP )}, NULL },
{ "CHANGEINDX", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( CHANGEINDX )}, NULL },
{ "ORDNUMBER", {HB_FS_PUBLIC}, {HB_FUNCNAME( ORDNUMBER )}, NULL },
{ "DBSETORDER", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBSETORDER )}, NULL },
{ "SETFOCUS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETREP", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( SETREP )}, NULL },
{ "DLGDATELIMIT", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( DLGDATELIMIT )}, NULL },
{ "TFONT", {HB_FS_PUBLIC}, {HB_FUNCNAME( TFONT )}, NULL },
{ "TSAY", {HB_FS_PUBLIC}, {HB_FUNCNAME( TSAY )}, NULL },
{ "HELPBROWSE", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( HELPBROWSE )}, NULL },
{ "ORDCLEARSCOPE", {HB_FS_PUBLIC}, {HB_FUNCNAME( ORDCLEARSCOPE )}, NULL },
{ "AUTOSEEK", {HB_FS_PUBLIC}, {HB_FUNCNAME( AUTOSEEK )}, NULL },
{ "TRADMENU", {HB_FS_PUBLIC}, {HB_FUNCNAME( TRADMENU )}, NULL },
{ "ORDSETFOCUS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ORDSETFOCUS )}, NULL },
{ "TWBROWSE", {HB_FS_PUBLIC}, {HB_FUNCNAME( TWBROWSE )}, NULL },
{ "FIELDGET", {HB_FS_PUBLIC}, {HB_FUNCNAME( FIELDGET )}, NULL },
{ "VARPUT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EVAL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ERASEFILESINDIRECTORY", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( ERASEFILESINDIRECTORY )}, NULL },
{ "AEVAL", {HB_FS_PUBLIC}, {HB_FUNCNAME( AEVAL )}, NULL },
{ "DIRECTORY", {HB_FS_PUBLIC}, {HB_FUNCNAME( DIRECTORY )}, NULL },
{ "FERASE", {HB_FS_PUBLIC}, {HB_FUNCNAME( FERASE )}, NULL },
{ "MSGTIME", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( MSGTIME )}, NULL },
{ "TTIMER", {HB_FS_PUBLIC}, {HB_FUNCNAME( TTIMER )}, NULL },
{ "SET", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TMETER", {HB_FS_PUBLIC}, {HB_FUNCNAME( TMETER )}, NULL },
{ "_BSTART", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BPAINTED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SYSREFRESH", {HB_FS_PUBLIC}, {HB_FUNCNAME( SYSREFRESH )}, NULL },
{ "CALENDARIO", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( CALENDARIO )}, NULL },
{ "DATE", {HB_FS_PUBLIC}, {HB_FUNCNAME( DATE )}, NULL },
{ "TCALENDAR", {HB_FS_PUBLIC}, {HB_FUNCNAME( TCALENDAR )}, NULL },
{ "GETDATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ROWCOLDATE", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( ROWCOLDATE )}, NULL },
{ "GETDATE", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( GETDATE )}, NULL },
{ "DAY", {HB_FS_PUBLIC}, {HB_FUNCNAME( DAY )}, NULL },
{ "_NCOLPOS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NCOLACT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DOW", {HB_FS_PUBLIC}, {HB_FUNCNAME( DOW )}, NULL },
{ "INT", {HB_FS_PUBLIC}, {HB_FUNCNAME( INT )}, NULL },
{ "NCOLACT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NROWPOS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EMPTY", {HB_FS_PUBLIC}, {HB_FUNCNAME( EMPTY )}, NULL },
{ "CTOD", {HB_FS_PUBLIC}, {HB_FUNCNAME( CTOD )}, NULL },
{ "STRZERO", {HB_FS_PUBLIC}, {HB_FUNCNAME( STRZERO )}, NULL },
{ "MAX", {HB_FS_PUBLIC}, {HB_FUNCNAME( MAX )}, NULL },
{ "ASEMANAS", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( ASEMANAS )}, NULL },
{ "MONTH", {HB_FS_PUBLIC}, {HB_FUNCNAME( MONTH )}, NULL },
{ "PADL", {HB_FS_PUBLIC}, {HB_FUNCNAME( PADL )}, NULL },
{ "STR", {HB_FS_PUBLIC}, {HB_FUNCNAME( STR )}, NULL },
{ "AEVALVALID", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( AEVALVALID )}, NULL },
{ "ACONTROLS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BVALID", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "PRINTPREVIEW", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( PRINTPREVIEW )}, NULL },
{ "AMETA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CURSORWAIT", {HB_FS_PUBLIC}, {HB_FUNCNAME( CURSORWAIT )}, NULL },
{ "STARTDOC", {HB_FS_PUBLIC}, {HB_FUNCNAME( STARTDOC )}, NULL },
{ "HDC", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CDOCUMENT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "STARTPAGE", {HB_FS_PUBLIC}, {HB_FUNCNAME( STARTPAGE )}, NULL },
{ "GETENHMETAFILE", {HB_FS_PUBLIC}, {HB_FUNCNAME( GETENHMETAFILE )}, NULL },
{ "PLAYENHMETAFILE", {HB_FS_PUBLIC}, {HB_FUNCNAME( PLAYENHMETAFILE )}, NULL },
{ "DELETEENHMETAFILE", {HB_FS_PUBLIC}, {HB_FUNCNAME( DELETEENHMETAFILE )}, NULL },
{ "ENDPAGE", {HB_FS_PUBLIC}, {HB_FUNCNAME( ENDPAGE )}, NULL },
{ "ENDDOC", {HB_FS_PUBLIC}, {HB_FUNCNAME( ENDDOC )}, NULL },
{ "CURSORARROW", {HB_FS_PUBLIC}, {HB_FUNCNAME( CURSORARROW )}, NULL },
{ "WEEK", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( WEEK )}, NULL },
{ "VALTYPE", {HB_FS_PUBLIC}, {HB_FUNCNAME( VALTYPE )}, NULL },
{ "YEAR", {HB_FS_PUBLIC}, {HB_FUNCNAME( YEAR )}, NULL },
{ "PRINTPDF", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( PRINTPDF )}, NULL },
{ "I2PDF_LICENSE_XH", {HB_FS_PUBLIC}, {HB_FUNCNAME( I2PDF_LICENSE_XH )}, NULL },
{ "I2PDF_ADDIMAGE_XH", {HB_FS_PUBLIC}, {HB_FUNCNAME( I2PDF_ADDIMAGE_XH )}, NULL },
{ "I2PDF_SETDPI_XH", {HB_FS_PUBLIC}, {HB_FUNCNAME( I2PDF_SETDPI_XH )}, NULL },
{ "I2PDF_MAKEPDF_XH", {HB_FS_PUBLIC}, {HB_FUNCNAME( I2PDF_MAKEPDF_XH )}, NULL },
{ "EXITNOSAVE", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( EXITNOSAVE )}, NULL },
{ "LASTREC", {HB_FS_PUBLIC}, {HB_FUNCNAME( LASTREC )}, NULL },
{ "APOLOMSGNOYES", {HB_FS_PUBLIC}, {HB_FUNCNAME( APOLOMSGNOYES )}, NULL },
{ "FW_GT", {HB_FS_PUBLIC}, {HB_FUNCNAME( FW_GT )}, NULL },
{ "ERRORSYS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORSYS )}, NULL },
{ "(_INITSTATICS00001)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITSTATICS}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_DLGTOOLS, ".\\.\\Prg\\Dlgtools.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_DLGTOOLS
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_DLGTOOLS )
   #include "hbiniseg.h"
#endif

HB_FUNC( CGETEXPRESSION )
{
	static const HB_BYTE pcode[] =
	{
		13,11,3,36,64,0,106,1,0,4,1,0,80,11,
		36,65,0,122,80,12,36,66,0,106,25,71,101,110,
		101,114,97,100,111,114,32,100,101,32,69,120,112,114,
		101,115,105,111,110,101,115,0,80,13,36,67,0,176,
		1,0,12,0,80,14,36,69,0,95,1,100,8,28,
		12,176,2,0,93,200,0,12,1,80,1,36,70,0,
		95,2,100,8,28,30,106,11,78,111,116,32,112,97,
		115,115,101,100,0,4,1,0,106,2,67,0,4,1,
		0,4,2,0,80,2,36,71,0,95,3,100,8,28,
		9,176,3,0,12,0,80,3,36,73,0,176,4,0,
		95,1,93,200,0,12,2,80,7,36,75,0,176,5,
		0,106,12,70,119,84,111,111,108,115,46,100,108,108,
		0,20,1,36,77,0,48,6,0,176,7,0,12,0,
		100,100,100,100,95,13,106,11,69,120,112,66,117,105,
		108,100,101,114,0,100,9,100,100,100,100,100,9,100,
		100,100,100,100,9,100,106,5,111,68,108,103,0,100,
		100,112,24,80,4,36,79,0,48,8,0,176,9,0,
		12,0,92,110,89,28,0,1,0,1,0,7,0,176,
		10,0,12,0,121,8,28,6,95,255,25,7,95,1,
		165,80,255,6,95,4,100,100,100,100,100,100,100,100,
		9,100,100,9,9,100,100,100,100,100,100,106,6,99,
		84,101,109,112,0,100,100,100,100,112,27,80,5,36,
		84,0,48,8,0,176,11,0,12,0,93,130,0,89,
		28,0,1,0,1,0,12,0,176,10,0,12,0,121,
		8,28,6,95,255,25,7,95,1,165,80,255,6,100,
		89,37,0,0,0,5,0,2,0,12,0,8,0,9,
		0,10,0,176,12,0,95,255,95,254,1,92,2,1,
		95,253,95,252,95,251,12,4,6,95,4,100,100,100,
		100,100,100,89,54,0,0,0,6,0,2,0,3,0,
		12,0,7,0,5,0,11,0,176,13,0,106,2,32,
		0,95,254,72,106,4,32,62,32,0,72,95,255,95,
		253,1,122,1,72,96,252,255,95,251,95,250,12,4,
		6,100,9,100,100,112,16,80,6,36,87,0,48,8,
		0,176,14,0,12,0,93,150,0,89,32,0,0,0,
		3,0,7,0,5,0,11,0,176,13,0,106,4,32,
		61,32,0,96,255,255,95,254,95,253,12,4,6,95,
		4,100,100,9,100,100,100,9,112,10,73,36,90,0,
		48,8,0,176,14,0,12,0,93,160,0,89,33,0,
		0,0,3,0,7,0,5,0,11,0,176,13,0,106,
		5,32,60,62,32,0,96,255,255,95,254,95,253,12,
		4,6,95,4,100,100,9,100,100,100,9,112,10,73,
		36,93,0,48,8,0,176,14,0,12,0,93,170,0,
		89,36,0,0,0,3,0,7,0,5,0,11,0,176,
		13,0,106,8,32,46,97,110,100,46,32,0,96,255,
		255,95,254,95,253,12,4,6,95,4,100,100,9,100,
		100,100,9,112,10,73,36,96,0,48,8,0,176,14,
		0,12,0,93,180,0,89,32,0,0,0,3,0,7,
		0,5,0,11,0,176,13,0,106,4,32,43,32,0,
		96,255,255,95,254,95,253,12,4,6,95,4,100,100,
		9,100,100,100,9,112,10,73,36,99,0,48,8,0,
		176,14,0,12,0,93,190,0,89,32,0,0,0,3,
		0,7,0,5,0,11,0,176,13,0,106,4,32,60,
		32,0,96,255,255,95,254,95,253,12,4,6,95,4,
		100,100,9,100,100,100,9,112,10,73,36,102,0,48,
		8,0,176,14,0,12,0,93,200,0,89,32,0,0,
		0,3,0,7,0,5,0,11,0,176,13,0,106,4,
		32,62,32,0,96,255,255,95,254,95,253,12,4,6,
		95,4,100,100,9,100,100,100,9,112,10,73,36,105,
		0,48,8,0,176,14,0,12,0,93,210,0,89,35,
		0,0,0,3,0,7,0,5,0,11,0,176,13,0,
		106,7,32,46,111,114,46,32,0,96,255,255,95,254,
		95,253,12,4,6,95,4,100,100,9,100,100,100,9,
		112,10,73,36,108,0,48,8,0,176,14,0,12,0,
		93,220,0,89,32,0,0,0,3,0,7,0,5,0,
		11,0,176,13,0,106,4,32,45,32,0,96,255,255,
		95,254,95,253,12,4,6,95,4,100,100,9,100,100,
		100,9,112,10,73,36,111,0,48,8,0,176,14,0,
		12,0,93,230,0,89,33,0,0,0,3,0,7,0,
		5,0,11,0,176,13,0,106,5,32,60,61,32,0,
		96,255,255,95,254,95,253,12,4,6,95,4,100,100,
		9,100,100,100,9,112,10,73,36,114,0,48,8,0,
		176,14,0,12,0,93,240,0,89,33,0,0,0,3,
		0,7,0,5,0,11,0,176,13,0,106,5,32,62,
		61,32,0,96,255,255,95,254,95,253,12,4,6,95,
		4,100,100,9,100,100,100,9,112,10,73,36,117,0,
		48,8,0,176,14,0,12,0,93,250,0,89,36,0,
		0,0,3,0,7,0,5,0,11,0,176,13,0,106,
		8,32,46,110,111,116,46,32,0,96,255,255,95,254,
		95,253,12,4,6,95,4,100,100,9,100,100,100,9,
		112,10,73,36,120,0,48,8,0,176,14,0,12,0,
		93,4,1,89,32,0,0,0,3,0,7,0,5,0,
		11,0,176,13,0,106,4,32,42,32,0,96,255,255,
		95,254,95,253,12,4,6,95,4,100,100,9,100,100,
		100,9,112,10,73,36,123,0,48,8,0,176,14,0,
		12,0,93,14,1,89,32,0,0,0,3,0,7,0,
		5,0,11,0,176,13,0,106,4,32,40,32,0,96,
		255,255,95,254,95,253,12,4,6,95,4,100,100,9,
		100,100,100,9,112,10,73,36,126,0,48,8,0,176,
		14,0,12,0,93,24,1,89,32,0,0,0,3,0,
		7,0,5,0,11,0,176,13,0,106,4,32,41,32,
		0,96,255,255,95,254,95,253,12,4,6,95,4,100,
		100,9,100,100,100,9,112,10,73,36,129,0,48,8,
		0,176,14,0,12,0,93,34,1,89,32,0,0,0,
		3,0,7,0,5,0,11,0,176,13,0,106,4,32,
		36,32,0,96,255,255,95,254,95,253,12,4,6,95,
		4,100,100,9,100,100,100,9,112,10,73,36,132,0,
		48,8,0,176,14,0,12,0,93,44,1,89,32,0,
		0,0,3,0,7,0,5,0,11,0,176,13,0,106,
		4,32,47,32,0,96,255,255,95,254,95,253,12,4,
		6,95,4,100,100,9,100,100,100,9,112,10,73,36,
		135,0,48,8,0,176,14,0,12,0,93,54,1,89,
		35,0,0,0,3,0,7,0,5,0,11,0,176,13,
		0,176,15,0,106,2,68,0,12,1,96,255,255,95,
		254,95,253,12,4,6,95,4,100,100,9,100,100,100,
		9,112,10,80,8,36,138,0,48,8,0,176,14,0,
		12,0,93,64,1,89,35,0,0,0,3,0,7,0,
		5,0,11,0,176,13,0,176,15,0,106,2,67,0,
		12,1,96,255,255,95,254,95,253,12,4,6,95,4,
		100,100,9,100,100,100,9,112,10,80,9,36,141,0,
		48,8,0,176,14,0,12,0,93,74,1,89,35,0,
		0,0,3,0,7,0,5,0,11,0,176,13,0,176,
		15,0,106,2,78,0,12,1,96,255,255,95,254,95,
		253,12,4,6,95,4,100,100,9,100,100,100,9,112,
		10,80,10,36,149,0,48,8,0,176,14,0,12,0,
		93,89,1,89,26,0,0,0,3,0,7,0,5,0,
		11,0,176,16,0,96,255,255,95,254,95,253,12,3,
		6,95,4,100,100,9,100,100,100,9,112,10,73,36,
		154,0,48,8,0,176,14,0,12,0,93,94,1,89,
		87,0,0,0,1,0,7,0,176,17,0,176,18,0,
		95,255,12,1,106,5,85,73,85,69,0,12,2,121,
		8,28,30,176,19,0,106,19,69,120,112,114,101,115,
		105,111,110,32,67,111,114,114,101,99,116,97,0,12,
		1,25,28,176,20,0,106,19,69,120,112,114,101,115,
		105,111,110,32,73,110,118,97,108,105,100,97,0,12,
		1,6,95,4,100,100,9,100,100,100,9,112,10,73,
		36,158,0,48,21,0,95,4,48,22,0,95,4,112,
		0,48,23,0,95,4,112,0,48,24,0,95,4,112,
		0,120,100,100,89,48,0,1,0,6,0,2,0,6,
		0,12,0,8,0,9,0,10,0,176,25,0,95,255,
		95,254,20,2,176,12,0,95,255,95,253,1,92,2,
		1,95,252,95,251,95,250,12,4,6,48,26,0,95,
		4,112,0,100,100,100,112,11,73,36,160,0,48,27,
		0,95,4,112,0,122,8,28,14,36,161,0,176,28,
		0,95,7,12,1,80,1,36,164,0,176,5,0,95,
		14,20,1,36,166,0,95,1,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( UNDO )
{
	static const HB_BYTE pcode[] =
	{
		13,0,3,36,176,0,176,29,0,95,3,12,1,121,
		15,28,53,36,177,0,176,4,0,176,30,0,95,3,
		12,1,92,100,12,2,80,1,36,178,0,48,31,0,
		95,2,112,0,73,36,179,0,176,32,0,95,3,176,
		29,0,95,3,12,1,122,49,20,2,25,15,36,181,
		0,176,33,0,93,132,3,92,2,20,2,36,184,0,
		100,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( EXPRADD )
{
	static const HB_BYTE pcode[] =
	{
		13,0,4,36,194,0,176,34,0,95,4,176,35,0,
		95,2,12,1,20,2,36,195,0,176,4,0,176,35,
		0,95,2,12,1,95,1,72,92,100,12,2,80,2,
		36,196,0,48,31,0,95,3,112,0,73,36,198,0,
		100,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SHOWFIELDS )
{
	static const HB_BYTE pcode[] =
	{
		13,1,2,36,210,0,48,36,0,95,2,112,0,73,
		36,212,0,122,165,80,3,25,27,36,213,0,48,37,
		0,95,2,95,1,95,3,1,92,2,1,112,1,73,
		36,212,0,175,3,0,176,29,0,95,1,12,1,15,
		28,223,36,216,0,48,38,0,95,2,112,0,73,36,
		218,0,100,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( CHECKBTN )
{
	static const HB_BYTE pcode[] =
	{
		13,0,4,36,225,0,95,1,106,2,68,0,8,28,
		37,36,226,0,48,39,0,95,2,112,0,73,36,227,
		0,48,40,0,95,3,112,0,73,36,228,0,48,40,
		0,95,4,112,0,73,25,94,36,230,0,95,1,106,
		2,67,0,8,28,37,36,231,0,48,40,0,95,2,
		112,0,73,36,232,0,48,39,0,95,3,112,0,73,
		36,233,0,48,40,0,95,4,112,0,73,25,47,36,
		235,0,95,1,106,2,78,0,8,28,35,36,236,0,
		48,40,0,95,2,112,0,73,36,237,0,48,40,0,
		95,3,112,0,73,36,238,0,48,39,0,95,4,112,
		0,73,36,242,0,120,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( GETVALUE )
{
	static const HB_BYTE pcode[] =
	{
		13,2,1,36,249,0,176,2,0,92,100,12,1,80,
		3,36,251,0,95,1,100,8,28,8,106,2,67,0,
		80,1,36,253,0,48,6,0,176,7,0,12,0,100,
		100,100,100,100,106,9,71,69,84,86,65,76,85,69,
		0,100,9,100,100,100,100,100,9,100,100,100,100,100,
		9,100,106,5,111,68,108,103,0,100,100,112,24,80,
		2,36,1,1,48,8,0,176,9,0,12,0,92,101,
		89,28,0,1,0,1,0,3,0,176,10,0,12,0,
		121,8,28,6,95,255,25,7,95,1,165,80,255,6,
		95,2,100,100,100,100,100,100,100,100,9,100,100,9,
		9,100,100,100,100,100,100,106,6,99,84,101,109,112,
		0,100,100,100,100,112,27,73,36,6,1,48,8,0,
		176,14,0,12,0,122,89,18,0,0,0,1,0,2,
		0,48,41,0,95,255,122,112,1,6,95,2,100,100,
		9,100,100,100,9,112,10,73,36,8,1,48,21,0,
		95,2,48,22,0,95,2,112,0,48,23,0,95,2,
		112,0,48,24,0,95,2,112,0,120,100,100,100,48,
		26,0,95,2,112,0,100,100,100,112,11,73,36,10,
		1,48,27,0,95,2,112,0,122,8,28,108,36,13,
		1,95,1,106,2,67,0,8,28,26,36,14,1,106,
		2,34,0,176,28,0,95,3,12,1,72,106,2,34,
		0,72,80,3,25,80,36,15,1,95,1,106,2,78,
		0,8,28,16,36,16,1,176,28,0,95,3,12,1,
		80,3,25,54,36,17,1,95,1,106,2,68,0,8,
		28,42,36,18,1,106,8,67,84,79,68,40,32,34,
		0,176,28,0,95,3,12,1,72,106,4,34,32,41,
		0,72,80,3,25,10,36,23,1,106,1,0,80,3,
		36,27,1,95,3,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( FILTERING )
{
	static const HB_BYTE pcode[] =
	{
		13,1,3,36,39,1,176,0,0,95,4,95,2,95,
		1,12,3,80,4,36,41,1,176,17,0,176,18,0,
		95,4,12,1,106,5,85,69,85,73,0,12,2,121,
		8,28,36,36,42,1,85,95,1,74,176,43,0,106,
		5,123,124,124,32,0,95,4,72,106,3,32,125,0,
		72,42,11,124,1,0,74,25,16,36,44,1,85,95,
		1,74,176,44,0,100,20,1,74,36,47,1,85,95,
		1,74,176,45,0,20,0,74,36,49,1,95,3,100,
		69,28,13,36,50,1,48,31,0,95,3,112,0,73,
		36,53,1,100,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( CHANGEINDX )
{
	static const HB_BYTE pcode[] =
	{
		13,2,3,36,62,1,95,2,100,8,28,9,176,3,
		0,12,0,80,2,36,64,1,85,95,2,74,176,47,
		0,12,0,119,80,5,36,66,1,48,6,0,176,7,
		0,12,0,100,100,100,100,100,106,11,67,104,97,110,
		103,101,73,110,100,120,0,100,9,100,100,100,100,100,
		9,100,100,100,100,100,9,100,106,5,111,68,108,103,
		0,100,100,112,24,80,4,36,71,1,48,8,0,176,
		11,0,12,0,92,110,89,28,0,1,0,1,0,5,
		0,176,10,0,12,0,121,8,28,6,95,255,25,7,
		95,1,165,80,255,6,95,1,100,95,4,100,100,100,
		100,100,100,100,100,9,100,100,112,16,73,36,74,1,
		48,8,0,176,14,0,12,0,122,89,18,0,0,0,
		1,0,4,0,48,41,0,95,255,122,112,1,6,95,
		4,100,100,9,100,100,100,9,112,10,73,36,77,1,
		48,8,0,176,14,0,12,0,92,2,89,17,0,0,
		0,1,0,4,0,48,41,0,95,255,112,0,6,95,
		4,100,100,9,100,100,100,9,112,10,73,36,79,1,
		48,21,0,95,4,48,22,0,95,4,112,0,48,23,
		0,95,4,112,0,48,24,0,95,4,112,0,120,100,
		100,100,48,26,0,95,4,112,0,100,100,100,112,11,
		73,36,81,1,48,27,0,95,4,112,0,122,8,28,
		17,36,82,1,85,95,2,74,176,48,0,95,5,20,
		1,74,36,85,1,95,3,100,69,28,24,36,86,1,
		48,31,0,95,3,112,0,73,36,87,1,48,49,0,
		95,3,112,0,73,36,91,1,100,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( SETREP )
{
	static const HB_BYTE pcode[] =
	{
		13,1,3,36,99,1,95,1,100,8,28,11,176,2,
		0,92,100,12,1,80,1,36,100,1,95,2,100,8,
		28,11,176,2,0,92,100,12,1,80,2,36,101,1,
		95,3,100,8,28,5,122,80,3,36,103,1,48,6,
		0,176,7,0,12,0,100,100,100,100,100,106,7,83,
		69,84,82,69,80,0,100,9,100,100,100,100,100,9,
		100,100,100,100,100,9,100,106,5,111,68,108,103,0,
		100,100,112,24,80,4,36,107,1,48,8,0,176,9,
		0,12,0,92,100,89,28,0,1,0,1,0,1,0,
		176,10,0,12,0,121,8,28,6,95,255,25,7,95,
		1,165,80,255,6,95,4,100,100,100,100,100,100,100,
		100,9,100,100,9,9,100,100,100,100,100,100,106,8,
		99,84,105,116,117,108,111,0,100,100,100,100,112,27,
		73,36,111,1,48,8,0,176,9,0,12,0,92,110,
		89,28,0,1,0,1,0,2,0,176,10,0,12,0,
		121,8,28,6,95,255,25,7,95,1,165,80,255,6,
		95,4,100,100,100,100,100,100,100,100,9,100,100,9,
		9,100,100,100,100,100,100,106,11,99,83,117,98,84,
		105,116,117,108,111,0,100,100,100,100,112,27,73,36,
		116,1,48,8,0,176,14,0,12,0,93,250,1,89,
		23,0,0,0,2,0,3,0,4,0,122,80,255,48,
		41,0,95,254,122,112,1,6,95,4,100,100,9,100,
		100,100,9,112,10,73,36,121,1,48,8,0,176,14,
		0,12,0,93,249,1,89,24,0,0,0,2,0,3,
		0,4,0,92,2,80,255,48,41,0,95,254,122,112,
		1,6,95,4,100,100,9,100,100,100,9,112,10,73,
		36,126,1,48,8,0,176,14,0,12,0,93,254,1,
		89,17,0,0,0,1,0,4,0,48,41,0,95,255,
		112,0,6,95,4,100,100,9,100,100,100,9,112,10,
		73,36,128,1,48,21,0,95,4,48,22,0,95,4,
		112,0,48,23,0,95,4,112,0,48,24,0,95,4,
		112,0,120,100,100,100,48,26,0,95,4,112,0,100,
		100,100,112,11,73,36,130,1,48,27,0,95,4,112,
		0,122,8,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( DLGDATELIMIT )
{
	static const HB_BYTE pcode[] =
	{
		13,3,0,36,143,1,176,1,0,12,0,80,3,36,
		145,1,48,6,0,176,52,0,12,0,106,6,65,114,
		105,97,108,0,121,92,242,100,120,100,100,100,100,100,
		100,100,100,100,100,100,100,112,17,80,2,36,147,1,
		176,5,0,106,12,70,119,84,111,111,108,115,46,100,
		108,108,0,20,1,36,149,1,48,6,0,176,7,0,
		12,0,100,100,100,100,100,106,9,82,69,71,73,83,
		84,69,82,0,100,9,100,100,100,100,100,9,100,100,
		100,100,100,9,100,106,5,111,68,108,103,0,100,100,
		112,24,80,1,36,155,1,48,8,0,176,53,0,12,
		0,92,10,90,40,106,35,76,97,32,97,112,108,105,
		99,97,99,105,243,110,32,104,97,32,69,120,99,101,
		100,105,100,111,32,108,97,32,102,101,99,104,97,0,
		6,95,1,100,106,4,82,47,87,0,100,9,95,2,
		9,9,100,112,11,73,36,161,1,48,8,0,176,53,
		0,12,0,92,11,90,29,106,24,112,114,111,103,114,
		97,109,97,100,97,32,112,97,114,97,32,115,117,32,
		117,115,111,46,0,6,95,1,100,106,4,82,47,87,
		0,100,9,95,2,9,9,100,112,11,73,36,166,1,
		48,8,0,176,14,0,12,0,122,89,17,0,0,0,
		1,0,1,0,48,41,0,95,255,112,0,6,95,1,
		100,100,9,100,100,100,9,112,10,73,36,168,1,48,
		21,0,95,1,48,22,0,95,1,112,0,48,23,0,
		95,1,112,0,48,24,0,95,1,112,0,120,100,100,
		100,48,26,0,95,1,112,0,100,100,100,112,11,73,
		36,170,1,48,41,0,95,2,112,0,73,100,80,2,
		36,172,1,176,5,0,95,3,20,1,36,174,1,100,
		110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( HELPBROWSE )
{
	static const HB_BYTE pcode[] =
	{
		13,5,5,36,182,1,122,80,9,36,185,1,95,2,
		100,8,28,9,176,3,0,12,0,80,2,36,186,1,
		95,3,100,8,28,25,106,19,65,121,117,100,97,32,
		97,32,108,97,32,69,110,116,114,97,100,97,0,80,
		3,36,187,1,95,4,100,8,28,20,176,19,0,106,
		9,65,112,112,101,110,100,32,33,0,12,1,80,4,
		36,188,1,95,5,100,8,28,18,176,19,0,106,7,
		69,100,105,116,32,33,0,12,1,80,5,36,190,1,
		85,95,2,74,176,45,0,20,0,74,36,194,1,48,
		6,0,176,7,0,12,0,100,100,100,100,95,3,106,
		10,72,69,76,80,69,78,84,82,89,0,100,9,100,
		100,100,100,100,9,100,100,100,100,100,9,100,106,5,
		111,68,108,103,0,100,100,112,24,80,6,36,201,1,
		48,8,0,176,9,0,12,0,92,104,89,28,0,1,
		0,1,0,8,0,176,10,0,12,0,121,8,28,6,
		95,255,25,7,95,1,165,80,255,6,95,6,100,100,
		89,21,0,0,0,2,0,10,0,2,0,176,55,0,
		95,255,95,254,12,2,6,100,100,100,100,100,9,100,
		89,27,0,3,0,2,0,10,0,2,0,176,56,0,
		95,1,95,2,95,3,95,255,95,254,12,5,6,9,
		9,100,100,100,100,100,106,5,70,73,78,68,0,106,
		6,99,71,101,116,49,0,100,100,100,100,112,27,80,
		7,36,206,1,48,8,0,176,57,0,12,0,89,28,
		0,1,0,1,0,9,0,176,10,0,12,0,121,8,
		28,6,95,255,25,7,95,1,165,80,255,6,95,6,
		100,92,102,92,103,4,2,0,89,33,0,0,0,3,
		0,2,0,9,0,10,0,85,95,255,74,176,58,0,
		95,254,20,1,74,48,31,0,95,253,112,0,6,100,
		100,100,9,100,100,112,11,73,36,211,1,48,8,0,
		176,59,0,12,0,92,105,89,36,0,0,0,1,0,
		2,0,85,95,255,74,176,60,0,122,12,1,119,85,
		95,255,74,176,60,0,92,2,12,1,119,4,2,0,
		6,95,6,100,100,100,100,100,100,100,100,100,100,100,
		100,100,9,100,100,100,100,100,112,22,80,10,36,216,
		1,48,8,0,176,14,0,12,0,122,89,41,0,0,
		0,3,0,1,0,2,0,6,0,48,61,0,95,255,
		85,95,254,74,176,60,0,122,12,1,119,112,1,73,
		48,41,0,95,253,122,112,1,6,95,6,100,100,9,
		100,100,100,9,112,10,73,36,221,1,48,8,0,176,
		14,0,12,0,92,2,89,17,0,0,0,1,0,6,
		0,48,41,0,95,255,112,0,6,95,6,100,100,9,
		100,100,100,9,112,10,73,36,226,1,48,8,0,176,
		14,0,12,0,92,110,89,25,0,0,0,3,0,4,
		0,10,0,2,0,48,62,0,95,255,95,254,95,253,
		112,2,6,95,6,100,100,9,100,100,100,9,112,10,
		73,36,231,1,48,8,0,176,14,0,12,0,92,120,
		89,25,0,0,0,3,0,5,0,10,0,2,0,48,
		62,0,95,255,95,254,95,253,112,2,6,95,6,100,
		100,9,100,100,100,9,112,10,73,36,233,1,48,21,
		0,95,6,48,22,0,95,6,112,0,48,23,0,95,
		6,112,0,48,24,0,95,6,112,0,9,100,100,100,
		48,26,0,95,6,112,0,100,100,100,112,11,73,36,
		235,1,48,27,0,95,6,112,0,122,8,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( ERASEFILESINDIRECTORY )
{
	static const HB_BYTE pcode[] =
	{
		13,0,2,36,245,1,95,2,100,8,28,10,106,4,
		42,46,42,0,80,2,36,247,1,176,64,0,176,65,
		0,95,1,95,2,72,12,1,89,22,0,1,0,1,
		0,1,0,176,66,0,95,255,95,1,122,1,72,12,
		1,6,20,2,36,251,1,100,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( MSGTIME )
{
	static const HB_BYTE pcode[] =
	{
		13,6,3,36,6,2,121,80,8,36,9,2,95,1,
		100,8,28,20,106,14,80,114,111,99,101,115,115,105,
		110,103,46,46,46,0,80,1,95,2,100,8,28,17,
		106,11,87,97,105,116,105,110,103,46,46,46,0,80,
		2,95,3,100,8,28,6,92,4,80,3,36,11,2,
		48,6,0,176,7,0,12,0,92,5,92,5,101,205,
		204,204,204,204,204,36,64,10,1,92,45,95,2,100,
		100,9,100,100,100,100,100,9,100,100,100,100,100,9,
		100,106,5,111,68,108,103,0,100,100,112,24,80,4,
		36,14,2,48,6,0,176,68,0,12,0,92,100,89,
		58,0,0,0,4,0,8,0,5,0,3,0,4,0,
		96,255,255,101,154,153,153,153,153,153,185,63,10,1,
		135,48,69,0,95,254,95,255,112,1,73,95,255,95,
		253,8,28,11,48,41,0,95,252,112,0,25,3,100,
		6,100,112,3,80,9,36,16,2,48,6,0,176,53,
		0,12,0,101,154,153,153,153,153,153,201,63,10,1,
		101,0,0,0,0,0,0,224,63,10,1,89,12,0,
		0,0,1,0,1,0,95,255,6,95,4,100,100,9,
		9,9,9,100,100,93,130,0,92,10,9,9,9,9,
		9,9,9,106,6,111,84,101,120,116,0,100,9,112,
		24,80,6,36,22,2,48,6,0,176,70,0,12,0,
		101,51,51,51,51,51,51,243,63,10,1,101,0,0,
		0,0,0,0,224,63,10,1,89,28,0,1,0,1,
		0,8,0,176,10,0,12,0,121,8,28,6,95,255,
		25,7,95,1,165,80,255,6,95,3,95,4,93,150,
		0,92,5,9,9,100,106,1,0,120,100,100,100,100,
		9,112,17,80,5,36,25,2,48,6,0,176,14,0,
		12,0,101,102,102,102,102,102,102,6,64,10,1,92,
		18,106,9,38,65,99,101,112,116,97,114,0,47,95,
		4,89,17,0,0,0,1,0,4,0,48,41,0,95,
		255,112,0,6,92,32,92,11,100,100,9,9,9,100,
		9,100,100,9,106,5,111,66,116,110,0,9,112,19,
		80,7,36,27,2,48,71,0,95,4,89,17,0,0,
		0,1,0,9,0,48,21,0,95,255,112,0,6,112,
		1,73,36,31,2,48,21,0,95,4,48,22,0,95,
		4,112,0,48,23,0,95,4,112,0,48,72,0,95,
		4,89,13,0,2,0,0,0,176,73,0,12,0,6,
		112,1,120,89,19,0,1,0,1,0,9,0,48,41,
		0,95,255,112,0,73,120,6,100,100,48,26,0,95,
		4,112,0,100,100,100,112,11,73,36,33,2,100,110,
		7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( CALENDARIO )
{
	static const HB_BYTE pcode[] =
	{
		13,2,2,36,121,2,95,1,100,8,28,9,176,75,
		0,12,0,80,1,36,122,2,95,2,100,8,28,17,
		106,11,67,97,108,101,110,100,97,114,105,111,0,80,
		2,36,124,2,48,6,0,176,7,0,12,0,100,100,
		100,100,95,2,106,9,67,97,108,101,110,100,97,114,
		0,100,9,100,100,100,100,100,9,100,100,100,100,100,
		9,100,106,5,111,68,108,103,0,100,100,112,24,80,
		3,36,126,2,48,8,0,176,76,0,12,0,92,100,
		89,28,0,1,0,1,0,1,0,176,10,0,12,0,
		121,8,28,6,95,255,25,7,95,1,165,80,255,6,
		100,95,3,100,100,100,100,100,100,100,100,100,100,100,
		89,18,0,0,0,1,0,3,0,48,41,0,95,255,
		122,112,1,6,89,18,0,0,0,1,0,3,0,48,
		41,0,95,255,122,112,1,6,112,17,80,4,36,128,
		2,48,21,0,95,3,48,22,0,95,3,112,0,48,
		23,0,95,3,112,0,48,24,0,95,3,112,0,120,
		100,100,100,48,26,0,95,3,112,0,100,100,100,112,
		11,73,36,130,2,48,27,0,95,3,112,0,122,8,
		28,14,36,131,2,48,77,0,95,4,112,0,80,1,
		36,134,2,95,1,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( ROWCOLDATE )
{
	static const HB_BYTE pcode[] =
	{
		13,2,5,36,141,2,176,79,0,95,1,95,2,95,
		3,12,3,80,6,36,142,2,95,6,176,80,0,95,
		6,12,1,49,80,7,36,144,2,48,38,0,95,4,
		112,0,73,36,145,2,48,81,0,95,4,122,112,1,
		73,36,146,2,48,82,0,95,4,176,83,0,95,6,
		12,1,122,5,28,6,92,7,25,11,176,83,0,95,
		6,12,1,122,49,112,1,73,36,147,2,176,84,0,
		176,80,0,95,6,12,1,176,83,0,95,7,12,1,
		72,122,49,48,85,0,95,4,112,0,49,92,7,72,
		92,7,18,12,1,80,5,36,148,2,48,86,0,95,
		4,95,5,112,1,73,36,149,2,48,31,0,95,4,
		112,0,73,36,151,2,95,6,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( GETDATE )
{
	static const HB_BYTE pcode[] =
	{
		13,1,3,36,159,2,176,87,0,176,88,0,176,89,
		0,95,1,92,2,12,2,106,2,47,0,72,176,89,
		0,95,2,92,2,12,2,72,106,2,47,0,72,176,
		89,0,95,3,92,4,12,2,72,12,1,165,80,4,
		12,1,28,23,36,160,2,173,1,0,36,161,2,176,
		90,0,95,1,122,12,2,80,1,25,180,36,164,2,
		95,4,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( ASEMANAS )
{
	static const HB_BYTE pcode[] =
	{
		13,4,2,36,170,2,106,1,0,106,1,0,106,1,
		0,106,1,0,106,1,0,106,1,0,106,1,0,4,
		7,0,4,1,0,80,3,36,171,2,176,88,0,106,
		4,48,49,47,0,176,89,0,95,1,92,2,12,2,
		72,106,2,47,0,72,176,89,0,95,2,92,4,12,
		2,72,12,1,80,4,36,172,2,176,83,0,95,4,
		12,1,122,5,28,6,92,7,25,11,176,83,0,95,
		4,12,1,122,49,80,5,36,173,2,122,80,6,36,
		175,2,176,92,0,95,4,12,1,95,1,5,28,102,
		36,176,2,95,5,92,7,15,28,48,36,177,2,122,
		80,5,36,178,2,174,6,0,36,179,2,176,34,0,
		95,3,106,1,0,106,1,0,106,1,0,106,1,0,
		106,1,0,106,1,0,106,1,0,4,7,0,20,2,
		36,181,2,176,93,0,176,94,0,176,80,0,95,4,
		12,1,12,1,92,4,12,2,95,3,95,6,1,95,
		5,2,36,182,2,174,4,0,36,183,2,174,5,0,
		25,143,36,186,2,95,3,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( AEVALVALID )
{
	static const HB_BYTE pcode[] =
	{
		13,2,1,36,193,2,48,96,0,95,1,112,0,80,
		3,36,195,2,95,3,100,69,28,101,176,87,0,95,
		3,12,1,31,92,36,196,2,122,165,80,2,25,73,
		36,197,2,95,3,95,2,1,100,69,28,55,48,97,
		0,95,3,95,2,1,112,0,100,69,28,41,36,198,
		2,48,62,0,48,97,0,95,3,95,2,1,112,0,
		112,0,31,21,36,199,2,48,49,0,48,96,0,95,
		1,112,0,95,2,1,112,0,73,36,196,2,175,2,
		0,176,29,0,95,3,12,1,15,28,177,36,205,2,
		100,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( PRINTPREVIEW )
{
	static const HB_BYTE pcode[] =
	{
		13,3,1,36,213,2,48,99,0,95,1,112,0,80,
		4,36,215,2,176,100,0,20,0,36,217,2,176,101,
		0,48,102,0,95,1,112,0,48,103,0,95,1,112,
		0,20,2,36,219,2,122,165,80,2,25,82,36,220,
		2,176,104,0,48,102,0,95,1,112,0,20,1,36,
		221,2,176,105,0,95,4,95,2,1,12,1,80,3,
		36,222,2,176,106,0,48,102,0,95,1,112,0,95,
		3,100,120,20,4,36,223,2,176,107,0,95,3,20,
		1,36,224,2,176,108,0,48,102,0,95,1,112,0,
		20,1,36,219,2,175,2,0,176,29,0,95,4,12,
		1,15,28,168,36,227,2,176,109,0,48,102,0,95,
		1,112,0,20,1,36,229,2,176,110,0,20,0,36,
		231,2,100,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( WEEK )
{
	static const HB_BYTE pcode[] =
	{
		13,5,1,36,243,2,176,112,0,95,1,12,1,106,
		2,68,0,8,28,17,176,87,0,95,1,12,1,28,
		8,36,244,2,121,110,7,36,247,2,176,87,0,95,
		1,12,1,28,12,36,248,2,176,75,0,12,0,80,
		1,36,251,2,176,92,0,95,1,12,1,80,2,36,
		252,2,176,80,0,95,1,12,1,80,3,36,253,2,
		176,113,0,95,1,12,1,80,4,36,255,2,95,1,
		92,3,72,176,83,0,95,1,12,1,92,5,72,92,
		7,50,49,80,6,36,0,3,122,176,84,0,95,6,
		176,88,0,106,7,48,49,47,48,49,47,0,176,94,
		0,176,113,0,95,6,12,1,12,1,72,12,1,49,
		92,7,18,12,1,72,80,5,36,2,3,95,5,110,
		7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( PRINTPDF )
{
	static const HB_BYTE pcode[] =
	{
		13,0,1,36,36,3,176,100,0,20,0,36,38,3,
		176,115,0,20,0,36,40,3,176,64,0,48,99,0,
		95,1,112,0,89,15,0,1,0,0,0,176,116,0,
		95,1,12,1,6,20,2,36,42,3,176,117,0,92,
		96,20,1,36,44,3,176,118,0,48,103,0,95,1,
		112,0,20,1,36,46,3,176,110,0,20,0,36,48,
		3,100,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( EXITNOSAVE )
{
	static const HB_BYTE pcode[] =
	{
		13,0,2,36,63,3,95,2,100,69,28,22,85,95,
		2,74,176,120,0,12,0,119,121,8,28,8,36,64,
		3,120,110,7,36,67,3,95,1,122,8,28,50,36,
		68,3,176,121,0,106,21,191,32,83,97,108,105,114,
		32,115,105,110,32,103,114,97,98,97,114,32,63,0,
		106,14,33,33,32,65,116,101,110,99,105,243,110,33,
		33,0,20,2,7,36,71,3,120,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_INITSTATICS()
{
	static const HB_BYTE pcode[] =
	{
		117,124,0,1,0,116,124,0,4,0,0,82,1,0,
		7
	};

	hb_vmExecute( pcode, symbols );
}
