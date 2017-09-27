/*
 * Harbour 3.2.0dev (r1307082134)
 * Borland C++ 5.8.2 (32-bit)
 * Generated C source from ".\Prg\tablet\view\ViewEdit.prg"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC( VIEWEDIT );
HB_FUNC_EXTERN( __CLSLOCKDEF );
HB_FUNC_EXTERN( HBCLASS );
HB_FUNC_EXTERN( VIEWBASE );
HB_FUNC_EXTERN( SPACE );
HB_FUNC_STATIC( VIEWEDIT_NEW );
HB_FUNC_STATIC( VIEWEDIT_STARTDIALOG );
HB_FUNC_STATIC( VIEWEDIT_DEFINEACEPTARCANCELAR );
HB_FUNC_STATIC( VIEWEDIT_DEFINESERIE );
HB_FUNC_STATIC( VIEWEDIT_DEFINERUTA );
HB_FUNC_STATIC( VIEWEDIT_DEFINECLIENTE );
HB_FUNC_STATIC( VIEWEDIT_DEFINEESTABLECIMIENTO );
HB_FUNC_STATIC( VIEWEDIT_DEFINEDIRECCION );
HB_FUNC_STATIC( VIEWEDIT_DEFINEBOTONESACCIONES );
HB_FUNC_STATIC( VIEWEDIT_DEFINEBROWSELINEAS );
HB_FUNC_STATIC( VIEWEDIT_DEFINEBOTONESMOVIMIENTO );
HB_FUNC_EXTERN( LBLTITLE );
HB_FUNC_EXTERN( __CLSUNLOCKDEF );
HB_FUNC_EXTERN( __OBJHASMSG );
HB_FUNC_EXTERN( TGRIDIMAGE );
HB_FUNC_EXTERN( GRIDWIDTH );
HB_FUNC_EXTERN( TGRIDURLLINK );
HB_FUNC_EXTERN( OGRIDFONT );
HB_FUNC_EXTERN( NGRIDCOLOR );
HB_FUNC_EXTERN( TGRIDGET );
HB_FUNC_EXTERN( GETPVPROFSTRING );
HB_FUNC_EXTERN( CINIAPLICATION );
HB_FUNC_EXTERN( DOW );
HB_FUNC_EXTERN( GETSYSDATE );
HB_FUNC_EXTERN( TGRIDSAY );
HB_FUNC_EXTERN( TGRIDCOMBOBOX );
HB_FUNC_EXTERN( PCOUNT );
HB_FUNC_EXTERN( TGRIDIXBROWSE );
HB_FUNC_EXTERN( GRIDHEIGTH );
HB_FUNC_EXTERN( FW_GT );
HB_FUNC_EXTERN( ERRORSYS );
HB_FUNC_INITSTATICS();


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_VIEWEDIT )
{ "VIEWEDIT", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( VIEWEDIT )}, NULL },
{ "__CLSLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSLOCKDEF )}, NULL },
{ "NEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBCLASS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBCLASS )}, NULL },
{ "VIEWBASE", {HB_FS_PUBLIC}, {HB_FUNCNAME( VIEWBASE )}, NULL },
{ "ADDMULTIDATA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SPACE", {HB_FS_PUBLIC}, {HB_FUNCNAME( SPACE )}, NULL },
{ "ADDMETHOD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "VIEWEDIT_NEW", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( VIEWEDIT_NEW )}, NULL },
{ "VIEWEDIT_STARTDIALOG", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( VIEWEDIT_STARTDIALOG )}, NULL },
{ "VIEWEDIT_DEFINEACEPTARCANCELAR", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( VIEWEDIT_DEFINEACEPTARCANCELAR )}, NULL },
{ "VIEWEDIT_DEFINESERIE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( VIEWEDIT_DEFINESERIE )}, NULL },
{ "ADDINLINE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "REFRESH", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETSERIE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "VIEWEDIT_DEFINERUTA", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( VIEWEDIT_DEFINERUTA )}, NULL },
{ "VIEWEDIT_DEFINECLIENTE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( VIEWEDIT_DEFINECLIENTE )}, NULL },
{ "GETCODIGOCLIENTE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ONOMBRECLIENTE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "VIEWEDIT_DEFINEESTABLECIMIENTO", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( VIEWEDIT_DEFINEESTABLECIMIENTO )}, NULL },
{ "VIEWEDIT_DEFINEDIRECCION", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( VIEWEDIT_DEFINEDIRECCION )}, NULL },
{ "VIEWEDIT_DEFINEBOTONESACCIONES", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( VIEWEDIT_DEFINEBOTONESACCIONES )}, NULL },
{ "VIEWEDIT_DEFINEBROWSELINEAS", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( VIEWEDIT_DEFINEBROWSELINEAS )}, NULL },
{ "GOTOP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OBROWSE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SELECT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "VIEWEDIT_DEFINEBOTONESMOVIMIENTO", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( VIEWEDIT_DEFINEBOTONESMOVIMIENTO )}, NULL },
{ "MAKETOTALS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LBLTITLE", {HB_FS_PUBLIC}, {HB_FUNCNAME( LBLTITLE )}, NULL },
{ "GETMODE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETTEXTOTIPODOCUMENTO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDVIRTUAL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CREATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__CLSUNLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSUNLOCKDEF )}, NULL },
{ "INSTANCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__OBJHASMSG", {HB_FS_PUBLIC}, {HB_FUNCNAME( __OBJHASMSG )}, NULL },
{ "INITCLASS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_OSENDER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CGETESTABLECIMIENTO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CHANGERUTA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OSENDER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NMODE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LOADNEXTCLIENT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GOTOPBROWSELINEAS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "REFRESHBROWSE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BUILD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TGRIDIMAGE", {HB_FS_PUBLIC}, {HB_FUNCNAME( TGRIDIMAGE )}, NULL },
{ "GRIDWIDTH", {HB_FS_PUBLIC}, {HB_FUNCNAME( GRIDWIDTH )}, NULL },
{ "ODLG", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ONVIEWCANCEL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ONVIEWSAVE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TGRIDURLLINK", {HB_FS_PUBLIC}, {HB_FUNCNAME( TGRIDURLLINK )}, NULL },
{ "OGRIDFONT", {HB_FS_PUBLIC}, {HB_FUNCNAME( OGRIDFONT )}, NULL },
{ "NGRIDCOLOR", {HB_FS_PUBLIC}, {HB_FUNCNAME( NGRIDCOLOR )}, NULL },
{ "ISCHANGESERIETABLET", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_GETSERIE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TGRIDGET", {HB_FS_PUBLIC}, {HB_FUNCNAME( TGRIDGET )}, NULL },
{ "SETGETVALUE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETPVPROFSTRING", {HB_FS_PUBLIC}, {HB_FUNCNAME( GETPVPROFSTRING )}, NULL },
{ "CINIAPLICATION", {HB_FS_PUBLIC}, {HB_FUNCNAME( CINIAPLICATION )}, NULL },
{ "LNOTZOOMMODE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DOW", {HB_FS_PUBLIC}, {HB_FUNCNAME( DOW )}, NULL },
{ "GETSYSDATE", {HB_FS_PUBLIC}, {HB_FUNCNAME( GETSYSDATE )}, NULL },
{ "TGRIDSAY", {HB_FS_PUBLIC}, {HB_FUNCNAME( TGRIDSAY )}, NULL },
{ "_OCBXRUTA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TGRIDCOMBOBOX", {HB_FS_PUBLIC}, {HB_FUNCNAME( TGRIDCOMBOBOX )}, NULL },
{ "PCOUNT", {HB_FS_PUBLIC}, {HB_FUNCNAME( PCOUNT )}, NULL },
{ "_GETRUTA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "PRIORCLIENT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NEXTCLIENT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "RUNGRIDCUSTOMER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_GETCODIGOCLIENTE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LVALIDCLIENTE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_ONOMBRECLIENTE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ONCLICKCLIENTEDIT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ONCLICKCLIENTSALES", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_OGETESTABLECIMIENTO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CGETESTABLECIMIENTO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "RUNGRIDDIRECTIONS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_GETCODIGODIRECCION", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LVALIDDIRECCION", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_GETNOMBREDIRECCION", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TEXTNOMBREDIRECCION", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_TEXTNOMBREDIRECCION", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "APPENDDETAIL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "APPENDBUTTONMODE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EDITBUTTONMODE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EDITDETAIL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NARRAYAT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DELETEBUTTONMODE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DELETEDETAIL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "PAGEUP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GOUP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GODOWN", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "PAGEDOWN", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DEFINEBOTONESACCIONES", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DEFINEBOTONESMOVIMIENTO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_OBROWSE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TGRIDIXBROWSE", {HB_FS_PUBLIC}, {HB_FUNCNAME( TGRIDIXBROWSE )}, NULL },
{ "_NTOP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EVALROW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NLEFT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EVALCOL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NWIDTH", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EVALWIDTH", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NHEIGHT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EVALHEIGHT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GRIDHEIGTH", {HB_FS_PUBLIC}, {HB_FUNCNAME( GRIDHEIGTH )}, NULL },
{ "NTOP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_LFOOTER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NMARQUEESTYLE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NHEADERHEIGHT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NFOOTERHEIGHT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NROWHEIGHT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NDATALINES", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETARRAY", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETLINES", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BLDBLCLICK", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CREATEFROMCODE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FW_GT", {HB_FS_PUBLIC}, {HB_FUNCNAME( FW_GT )}, NULL },
{ "ERRORSYS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORSYS )}, NULL },
{ "(_INITSTATICS00002)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITSTATICS}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_VIEWEDIT, ".\\Prg\\tablet\\view\\ViewEdit.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_VIEWEDIT
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_VIEWEDIT )
   #include "hbiniseg.h"
#endif

HB_FUNC( VIEWEDIT )
{
	static const HB_BYTE pcode[] =
	{
		149,3,0,116,121,0,36,5,0,103,2,0,100,8,
		29,150,5,176,1,0,104,2,0,12,1,29,139,5,
		166,77,5,0,122,80,1,48,2,0,176,3,0,12,
		0,106,9,86,105,101,119,69,100,105,116,0,108,4,
		4,1,0,108,0,112,3,80,2,36,7,0,48,5,
		0,95,2,100,100,95,1,121,72,121,72,121,72,106,
		6,110,77,111,100,101,0,4,1,0,9,112,5,73,
		36,9,0,48,5,0,95,2,100,100,95,1,121,72,
		121,72,121,72,106,17,103,101,116,67,111,100,105,103,
		111,67,108,105,101,110,116,101,0,4,1,0,9,112,
		5,73,36,10,0,48,5,0,95,2,100,100,95,1,
		121,72,121,72,121,72,106,15,111,78,111,109,98,114,
		101,67,108,105,101,110,116,101,0,4,1,0,9,112,
		5,73,36,12,0,48,5,0,95,2,100,100,95,1,
		121,72,121,72,121,72,106,19,103,101,116,67,111,100,
		105,103,111,68,105,114,101,99,99,105,111,110,0,4,
		1,0,9,112,5,73,36,13,0,48,5,0,95,2,
		100,100,95,1,121,72,121,72,121,72,106,19,103,101,
		116,78,111,109,98,114,101,68,105,114,101,99,99,105,
		111,110,0,4,1,0,9,112,5,73,36,14,0,48,
		5,0,95,2,100,176,6,0,93,200,0,12,1,95,
		1,121,72,121,72,121,72,106,20,116,101,120,116,78,
		111,109,98,114,101,68,105,114,101,99,99,105,111,110,
		0,4,1,0,9,112,5,73,36,16,0,48,5,0,
		95,2,100,100,95,1,121,72,121,72,121,72,106,20,
		111,71,101,116,69,115,116,97,98,108,101,99,105,109,
		105,101,110,116,111,0,4,1,0,9,112,5,73,36,
		17,0,48,5,0,95,2,100,100,95,1,121,72,121,
		72,121,72,106,20,99,71,101,116,69,115,116,97,98,
		108,101,99,105,109,105,101,110,116,111,0,4,1,0,
		9,112,5,73,36,19,0,48,5,0,95,2,100,100,
		95,1,121,72,121,72,121,72,106,9,111,67,98,120,
		82,117,116,97,0,4,1,0,9,112,5,73,36,20,
		0,48,5,0,95,2,100,100,95,1,121,72,121,72,
		121,72,106,8,103,101,116,82,117,116,97,0,4,1,
		0,9,112,5,73,36,22,0,48,5,0,95,2,100,
		100,95,1,121,72,121,72,121,72,106,9,103,101,116,
		83,101,114,105,101,0,4,1,0,9,112,5,73,36,
		24,0,48,7,0,95,2,106,4,78,101,119,0,108,
		8,95,1,121,72,121,72,121,72,112,3,73,36,26,
		0,48,7,0,95,2,106,12,115,116,97,114,116,68,
		105,97,108,111,103,0,108,9,95,1,121,72,121,72,
		121,72,112,3,73,36,28,0,48,7,0,95,2,106,
		22,100,101,102,105,110,101,65,99,101,112,116,97,114,
		67,97,110,99,101,108,97,114,0,108,10,95,1,121,
		72,121,72,121,72,112,3,73,36,30,0,48,7,0,
		95,2,106,12,100,101,102,105,110,101,83,101,114,105,
		101,0,108,11,95,1,121,72,121,72,121,72,112,3,
		73,36,31,0,48,12,0,95,2,106,13,114,101,102,
		114,101,115,104,83,101,114,105,101,0,89,20,0,1,
		0,0,0,48,13,0,48,14,0,95,1,112,0,112,
		0,6,95,1,121,72,121,72,121,72,112,3,73,36,
		33,0,48,7,0,95,2,106,11,100,101,102,105,110,
		101,82,117,116,97,0,108,15,95,1,121,72,121,72,
		121,72,112,3,73,36,35,0,48,7,0,95,2,106,
		14,100,101,102,105,110,101,67,108,105,101,110,116,101,
		0,108,16,95,1,121,72,121,72,121,72,112,3,73,
		36,36,0,48,12,0,95,2,106,15,114,101,102,114,
		101,115,104,67,108,105,101,110,116,101,0,89,33,0,
		1,0,0,0,48,13,0,48,17,0,95,1,112,0,
		112,0,73,48,13,0,48,18,0,95,1,112,0,112,
		0,6,95,1,121,72,121,72,121,72,112,3,73,36,
		38,0,48,7,0,95,2,106,22,100,101,102,105,110,
		101,69,115,116,97,98,108,101,99,105,109,105,101,110,
		116,111,0,108,19,95,1,121,72,121,72,121,72,112,
		3,73,36,40,0,48,7,0,95,2,106,16,100,101,
		102,105,110,101,68,105,114,101,99,99,105,111,110,0,
		108,20,95,1,121,72,121,72,121,72,112,3,73,36,
		42,0,48,7,0,95,2,106,22,100,101,102,105,110,
		101,66,111,116,111,110,101,115,65,99,99,105,111,110,
		101,115,0,108,21,95,1,121,72,121,72,121,72,112,
		3,73,36,44,0,48,7,0,95,2,106,19,100,101,
		102,105,110,101,66,114,111,119,115,101,76,105,110,101,
		97,115,0,108,22,95,1,121,72,121,72,121,72,112,
		3,73,36,46,0,48,12,0,95,2,106,18,103,111,
		116,111,112,66,114,111,119,115,101,76,105,110,101,97,
		115,0,89,48,0,1,0,0,0,48,23,0,48,24,
		0,95,1,112,0,112,0,73,48,25,0,48,24,0,
		95,1,112,0,121,112,1,73,48,25,0,48,24,0,
		95,1,112,0,122,112,1,6,95,1,121,72,121,72,
		121,72,112,3,73,36,48,0,48,7,0,95,2,106,
		24,100,101,102,105,110,101,66,111,116,111,110,101,115,
		77,111,118,105,109,105,101,110,116,111,0,108,26,95,
		1,121,72,121,72,121,72,112,3,73,36,50,0,48,
		12,0,95,2,106,14,114,101,102,114,101,115,104,66,
		114,111,119,115,101,0,89,33,0,1,0,0,0,48,
		27,0,48,24,0,95,1,112,0,112,0,73,48,13,
		0,48,24,0,95,1,112,0,112,0,6,95,1,121,
		72,121,72,121,72,112,3,73,36,52,0,48,12,0,
		95,2,106,22,103,101,116,84,105,116,108,101,84,105,
		112,111,68,111,99,117,109,101,110,116,111,0,89,28,
		0,1,0,0,0,176,28,0,48,29,0,95,1,112,
		0,12,1,48,30,0,95,1,112,0,72,6,95,1,
		121,72,121,72,121,72,112,3,73,36,54,0,48,31,
		0,95,2,106,18,111,110,99,108,105,99,107,67,108,
		105,101,110,116,69,100,105,116,0,112,1,73,36,55,
		0,48,31,0,95,2,106,19,111,110,99,108,105,99,
		107,67,108,105,101,110,116,83,97,108,101,115,0,112,
		1,73,36,57,0,48,32,0,95,2,112,0,73,167,
		14,0,0,176,33,0,104,2,0,95,2,20,2,168,
		48,34,0,95,2,112,0,80,3,176,35,0,95,3,
		106,10,73,110,105,116,67,108,97,115,115,0,12,2,
		28,12,48,36,0,95,3,164,146,1,0,73,95,3,
		110,7,48,34,0,103,2,0,112,0,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( VIEWEDIT_NEW )
{
	static const HB_BYTE pcode[] =
	{
		13,0,1,36,63,0,48,37,0,102,95,1,112,1,
		73,36,64,0,48,38,0,102,106,1,0,112,1,73,
		36,66,0,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( VIEWEDIT_STARTDIALOG )
{
	static const HB_BYTE pcode[] =
	{
		36,74,0,48,39,0,48,40,0,102,112,0,112,0,
		73,36,76,0,48,41,0,48,40,0,102,112,0,112,
		0,122,8,28,25,36,77,0,48,42,0,48,40,0,
		102,112,0,48,41,0,102,112,0,112,1,73,25,12,
		36,79,0,48,43,0,102,112,0,73,36,82,0,48,
		44,0,102,112,0,73,36,84,0,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( VIEWEDIT_DEFINEACEPTARCANCELAR )
{
	static const HB_BYTE pcode[] =
	{
		13,1,0,36,88,0,102,80,1,36,96,0,48,45,
		0,176,46,0,12,0,106,5,110,84,111,112,0,92,
		5,106,6,110,76,101,102,116,0,89,33,0,0,0,
		1,0,1,0,176,47,0,101,0,0,0,0,0,0,
		34,64,10,1,48,48,0,95,255,112,0,12,2,6,
		106,7,110,87,105,100,116,104,0,92,64,106,8,110,
		72,101,105,103,104,116,0,92,64,106,9,99,82,101,
		115,78,97,109,101,0,106,12,103,99,95,101,114,114,
		111,114,95,54,52,0,106,10,98,76,67,108,105,99,
		107,101,100,0,89,22,0,0,0,1,0,1,0,48,
		49,0,48,40,0,95,255,112,0,112,0,6,106,5,
		111,87,110,100,0,48,48,0,95,1,112,0,177,7,
		0,112,1,73,36,104,0,48,45,0,176,46,0,12,
		0,106,5,110,84,111,112,0,92,5,106,6,110,76,
		101,102,116,0,89,33,0,0,0,1,0,1,0,176,
		47,0,101,0,0,0,0,0,0,37,64,10,1,48,
		48,0,95,255,112,0,12,2,6,106,7,110,87,105,
		100,116,104,0,92,64,106,8,110,72,101,105,103,104,
		116,0,92,64,106,9,99,82,101,115,78,97,109,101,
		0,106,9,103,99,95,111,107,95,54,52,0,106,10,
		98,76,67,108,105,99,107,101,100,0,89,22,0,0,
		0,1,0,1,0,48,50,0,48,40,0,95,255,112,
		0,112,0,6,106,5,111,87,110,100,0,48,48,0,
		95,1,112,0,177,7,0,112,1,73,36,106,0,95,
		1,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( VIEWEDIT_DEFINESERIE )
{
	static const HB_BYTE pcode[] =
	{
		13,1,0,36,110,0,102,80,1,36,121,0,48,45,
		0,176,51,0,12,0,106,5,110,84,111,112,0,92,
		40,106,6,110,76,101,102,116,0,89,33,0,0,0,
		1,0,1,0,176,47,0,101,0,0,0,0,0,0,
		224,63,10,1,48,48,0,95,255,112,0,12,2,6,
		106,5,99,85,82,76,0,106,6,83,101,114,105,101,
		0,106,5,111,87,110,100,0,48,48,0,95,1,112,
		0,106,6,111,70,111,110,116,0,176,52,0,12,0,
		106,7,108,80,105,120,101,108,0,120,106,9,110,67,
		108,114,73,110,105,116,0,176,53,0,12,0,106,9,
		110,67,108,114,79,118,101,114,0,176,53,0,12,0,
		106,10,110,67,108,114,86,105,115,105,116,0,176,53,
		0,12,0,106,8,98,65,99,116,105,111,110,0,89,
		22,0,0,0,1,0,1,0,48,54,0,48,40,0,
		95,255,112,0,112,0,6,177,10,0,112,1,73,36,
		131,0,48,55,0,95,1,48,45,0,176,56,0,12,
		0,106,5,110,82,111,119,0,92,40,106,5,110,67,
		111,108,0,89,33,0,0,0,1,0,1,0,176,47,
		0,101,0,0,0,0,0,0,4,64,10,1,48,48,
		0,95,255,112,0,12,2,6,106,8,98,83,101,116,
		71,101,116,0,89,27,0,1,0,1,0,1,0,48,
		57,0,95,255,95,1,106,6,83,101,114,105,101,0,
		112,2,6,106,5,111,87,110,100,0,48,48,0,95,
		1,112,0,106,7,110,87,105,100,116,104,0,89,24,
		0,0,0,1,0,1,0,176,47,0,92,2,48,48,
		0,95,255,112,0,12,2,6,106,8,110,72,101,105,
		103,104,116,0,92,23,106,6,99,80,105,99,116,0,
		106,3,64,33,0,106,6,98,87,104,101,110,0,89,
		73,0,0,0,1,0,1,0,176,58,0,106,7,84,
		97,98,108,101,116,0,106,13,66,108,111,113,117,101,
		111,83,101,114,105,101,0,106,4,46,70,46,0,176,
		59,0,12,0,12,4,106,4,46,70,46,0,8,21,
		28,15,73,48,60,0,48,40,0,95,255,112,0,112,
		0,6,106,8,108,80,105,120,101,108,115,0,120,177,
		9,0,112,1,112,1,73,36,133,0,95,1,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( VIEWEDIT_DEFINERUTA )
{
	static const HB_BYTE pcode[] =
	{
		13,4,1,36,137,0,102,80,2,36,139,0,106,8,
		68,111,109,105,110,103,111,0,106,6,76,117,110,101,
		115,0,106,7,77,97,114,116,101,115,0,106,10,77,
		105,233,114,99,111,108,101,115,0,106,7,74,117,101,
		118,101,115,0,106,8,86,105,101,114,110,101,115,0,
		106,7,83,225,98,97,100,111,0,106,6,84,111,100,
		111,115,0,4,8,0,80,3,36,140,0,95,3,176,
		61,0,176,62,0,12,0,12,1,1,80,4,36,143,
		0,95,1,100,8,28,6,92,67,80,1,36,155,0,
		48,45,0,176,63,0,12,0,106,5,110,82,111,119,
		0,95,1,106,5,110,67,111,108,0,89,33,0,0,
		0,1,0,2,0,176,47,0,101,0,0,0,0,0,
		0,224,63,10,1,48,48,0,95,255,112,0,12,2,
		6,106,6,98,84,101,120,116,0,90,10,106,5,82,
		117,116,97,0,6,106,5,111,87,110,100,0,48,48,
		0,95,2,112,0,106,6,111,70,111,110,116,0,176,
		52,0,12,0,106,8,108,80,105,120,101,108,115,0,
		120,106,9,110,67,108,114,84,101,120,116,0,121,106,
		9,110,67,108,114,66,97,99,107,0,97,255,255,255,
		0,106,7,110,87,105,100,116,104,0,89,23,0,0,
		0,1,0,2,0,176,47,0,122,48,48,0,95,255,
		112,0,12,2,6,106,8,110,72,101,105,103,104,116,
		0,92,23,106,8,108,68,101,115,105,103,110,0,9,
		177,11,0,112,1,73,36,165,0,48,64,0,95,2,
		48,45,0,176,65,0,12,0,106,5,110,82,111,119,
		0,95,1,106,5,110,67,111,108,0,89,33,0,0,
		0,1,0,2,0,176,47,0,101,0,0,0,0,0,
		0,4,64,10,1,48,48,0,95,255,112,0,12,2,
		6,106,8,98,83,101,116,71,101,116,0,89,28,0,
		1,0,1,0,4,0,176,66,0,12,0,121,8,28,
		6,95,255,25,7,95,1,165,80,255,6,106,5,111,
		87,110,100,0,48,48,0,95,2,112,0,106,7,110,
		87,105,100,116,104,0,89,24,0,0,0,1,0,2,
		0,176,47,0,92,2,48,48,0,95,255,112,0,12,
		2,6,106,8,110,72,101,105,103,104,116,0,92,25,
		106,7,97,73,116,101,109,115,0,95,3,106,6,98,
		87,104,101,110,0,89,22,0,0,0,1,0,2,0,
		48,60,0,48,40,0,95,255,112,0,112,0,6,106,
		8,98,67,104,97,110,103,101,0,89,22,0,0,0,
		1,0,2,0,48,39,0,48,40,0,95,255,112,0,
		112,0,6,177,9,0,112,1,112,1,73,36,174,0,
		48,67,0,95,2,48,45,0,176,56,0,12,0,106,
		5,110,82,111,119,0,95,1,106,5,110,67,111,108,
		0,89,33,0,0,0,1,0,2,0,176,47,0,101,
		102,102,102,102,102,102,18,64,10,1,48,48,0,95,
		255,112,0,12,2,6,106,8,98,83,101,116,71,101,
		116,0,89,28,0,1,0,1,0,5,0,176,66,0,
		12,0,121,8,28,6,95,255,25,7,95,1,165,80,
		255,6,106,5,111,87,110,100,0,48,48,0,95,2,
		112,0,106,7,110,87,105,100,116,104,0,89,24,0,
		0,0,1,0,2,0,176,47,0,92,5,48,48,0,
		95,255,112,0,12,2,6,106,8,110,72,101,105,103,
		104,116,0,92,23,106,6,98,87,104,101,110,0,90,
		4,9,6,106,8,108,80,105,120,101,108,115,0,120,
		177,8,0,112,1,112,1,73,36,183,0,48,45,0,
		176,46,0,12,0,106,5,110,84,111,112,0,95,1,
		92,5,49,106,6,110,76,101,102,116,0,89,24,0,
		0,0,1,0,2,0,176,47,0,92,10,48,48,0,
		95,255,112,0,12,2,6,106,7,110,87,105,100,116,
		104,0,92,64,106,8,110,72,101,105,103,104,116,0,
		92,64,106,9,99,82,101,115,78,97,109,101,0,106,
		20,103,99,95,110,97,118,105,103,97,116,101,95,108,
		101,102,116,95,53,54,0,106,10,98,76,67,108,105,
		99,107,101,100,0,89,22,0,0,0,1,0,2,0,
		48,68,0,48,40,0,95,255,112,0,112,0,6,106,
		6,98,87,104,101,110,0,89,22,0,0,0,1,0,
		2,0,48,60,0,48,40,0,95,255,112,0,112,0,
		6,106,5,111,87,110,100,0,48,48,0,95,2,112,
		0,177,8,0,112,1,73,36,192,0,48,45,0,176,
		46,0,12,0,106,5,110,84,111,112,0,95,1,92,
		5,49,106,6,110,76,101,102,116,0,89,24,0,0,
		0,1,0,2,0,176,47,0,92,11,48,48,0,95,
		255,112,0,12,2,6,106,7,110,87,105,100,116,104,
		0,92,64,106,8,110,72,101,105,103,104,116,0,92,
		64,106,9,99,82,101,115,78,97,109,101,0,106,21,
		103,99,95,110,97,118,105,103,97,116,101,95,114,105,
		103,104,116,95,53,54,0,106,10,98,76,67,108,105,
		99,107,101,100,0,89,22,0,0,0,1,0,2,0,
		48,69,0,48,40,0,95,255,112,0,112,0,6,106,
		6,98,87,104,101,110,0,89,22,0,0,0,1,0,
		2,0,48,60,0,48,40,0,95,255,112,0,112,0,
		6,106,5,111,87,110,100,0,48,48,0,95,2,112,
		0,177,8,0,112,1,73,36,194,0,95,2,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( VIEWEDIT_DEFINECLIENTE )
{
	static const HB_BYTE pcode[] =
	{
		13,1,1,36,198,0,102,80,2,36,200,0,95,1,
		100,8,28,6,92,95,80,1,36,211,0,48,45,0,
		176,51,0,12,0,106,5,110,84,111,112,0,95,1,
		106,6,110,76,101,102,116,0,89,33,0,0,0,1,
		0,2,0,176,47,0,101,0,0,0,0,0,0,224,
		63,10,1,48,48,0,95,255,112,0,12,2,6,106,
		5,99,85,82,76,0,106,8,67,108,105,101,110,116,
		101,0,106,5,111,87,110,100,0,48,48,0,95,2,
		112,0,106,6,111,70,111,110,116,0,176,52,0,12,
		0,106,7,108,80,105,120,101,108,0,120,106,9,110,
		67,108,114,73,110,105,116,0,176,53,0,12,0,106,
		9,110,67,108,114,79,118,101,114,0,176,53,0,12,
		0,106,10,110,67,108,114,86,105,115,105,116,0,176,
		53,0,12,0,106,8,98,65,99,116,105,111,110,0,
		89,22,0,0,0,1,0,2,0,48,70,0,48,40,
		0,95,255,112,0,112,0,6,177,10,0,112,1,73,
		36,221,0,48,71,0,95,2,48,45,0,176,56,0,
		12,0,106,5,110,82,111,119,0,95,1,106,5,110,
		67,111,108,0,89,33,0,0,0,1,0,2,0,176,
		47,0,101,0,0,0,0,0,0,4,64,10,1,48,
		48,0,95,255,112,0,12,2,6,106,8,98,83,101,
		116,71,101,116,0,89,29,0,1,0,1,0,2,0,
		48,57,0,95,255,95,1,106,8,67,108,105,101,110,
		116,101,0,112,2,6,106,5,111,87,110,100,0,48,
		48,0,95,2,112,0,106,7,110,87,105,100,116,104,
		0,89,24,0,0,0,1,0,2,0,176,47,0,92,
		2,48,48,0,95,255,112,0,12,2,6,106,8,110,
		72,101,105,103,104,116,0,92,23,106,8,108,80,105,
		120,101,108,115,0,120,106,6,98,87,104,101,110,0,
		89,22,0,0,0,1,0,2,0,48,60,0,48,40,
		0,95,255,112,0,112,0,6,106,7,98,86,97,108,
		105,100,0,89,22,0,0,0,1,0,2,0,48,72,
		0,48,40,0,95,255,112,0,112,0,6,177,9,0,
		112,1,112,1,73,36,230,0,48,73,0,95,2,48,
		45,0,176,56,0,12,0,106,5,110,82,111,119,0,
		95,1,106,5,110,67,111,108,0,89,33,0,0,0,
		1,0,2,0,176,47,0,101,102,102,102,102,102,102,
		18,64,10,1,48,48,0,95,255,112,0,12,2,6,
		106,8,98,83,101,116,71,101,116,0,89,35,0,1,
		0,1,0,2,0,48,57,0,95,255,95,1,106,14,
		78,111,109,98,114,101,67,108,105,101,110,116,101,0,
		112,2,6,106,5,111,87,110,100,0,48,48,0,95,
		2,112,0,106,8,108,80,105,120,101,108,115,0,120,
		106,7,110,87,105,100,116,104,0,89,24,0,0,0,
		1,0,2,0,176,47,0,92,5,48,48,0,95,255,
		112,0,12,2,6,106,8,110,72,101,105,103,104,116,
		0,92,23,106,6,98,87,104,101,110,0,89,22,0,
		0,0,1,0,2,0,48,60,0,48,40,0,95,255,
		112,0,112,0,6,177,8,0,112,1,112,1,73,36,
		239,0,48,45,0,176,46,0,12,0,106,5,110,84,
		111,112,0,95,1,106,6,110,76,101,102,116,0,89,
		24,0,0,0,1,0,2,0,176,47,0,92,10,48,
		48,0,95,255,112,0,12,2,6,106,7,110,87,105,
		100,116,104,0,92,64,106,8,110,72,101,105,103,104,
		116,0,92,64,106,9,99,82,101,115,78,97,109,101,
		0,106,11,103,99,95,101,100,105,116,95,52,56,0,
		106,10,98,76,67,108,105,99,107,101,100,0,89,22,
		0,0,0,1,0,2,0,48,74,0,48,40,0,95,
		255,112,0,112,0,6,106,6,98,87,104,101,110,0,
		89,22,0,0,0,1,0,2,0,48,60,0,48,40,
		0,95,255,112,0,112,0,6,106,5,111,87,110,100,
		0,48,48,0,95,2,112,0,177,8,0,112,1,73,
		36,248,0,48,45,0,176,46,0,12,0,106,5,110,
		84,111,112,0,95,1,106,6,110,76,101,102,116,0,
		89,24,0,0,0,1,0,2,0,176,47,0,92,11,
		48,48,0,95,255,112,0,12,2,6,106,7,110,87,
		105,100,116,104,0,92,64,106,8,110,72,101,105,103,
		104,116,0,92,64,106,9,99,82,101,115,78,97,109,
		101,0,106,25,103,99,95,100,111,99,117,109,101,110,
		116,95,116,101,120,116,95,117,115,101,114,95,52,56,
		0,106,10,98,76,67,108,105,99,107,101,100,0,89,
		22,0,0,0,1,0,2,0,48,75,0,48,40,0,
		95,255,112,0,112,0,6,106,6,98,87,104,101,110,
		0,89,22,0,0,0,1,0,2,0,48,60,0,48,
		40,0,95,255,112,0,112,0,6,106,5,111,87,110,
		100,0,48,48,0,95,2,112,0,177,8,0,112,1,
		73,36,250,0,95,2,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( VIEWEDIT_DEFINEESTABLECIMIENTO )
{
	static const HB_BYTE pcode[] =
	{
		13,1,0,36,254,0,102,80,1,36,10,1,48,45,
		0,176,63,0,12,0,106,5,110,82,111,119,0,92,
		120,106,5,110,67,111,108,0,89,33,0,0,0,1,
		0,1,0,176,47,0,101,0,0,0,0,0,0,224,
		63,10,1,48,48,0,95,255,112,0,12,2,6,106,
		6,98,84,101,120,116,0,90,21,106,16,69,115,116,
		97,98,108,101,99,105,109,105,101,110,116,111,0,6,
		106,5,111,87,110,100,0,48,48,0,95,1,112,0,
		106,6,111,70,111,110,116,0,176,52,0,12,0,106,
		8,108,80,105,120,101,108,115,0,120,106,9,110,67,
		108,114,84,101,120,116,0,121,106,9,110,67,108,114,
		66,97,99,107,0,97,255,255,255,0,106,7,110,87,
		105,100,116,104,0,89,33,0,0,0,1,0,1,0,
		176,47,0,101,0,0,0,0,0,0,248,63,10,1,
		48,48,0,95,255,112,0,12,2,6,106,8,110,72,
		101,105,103,104,116,0,92,23,106,8,108,68,101,115,
		105,103,110,0,9,177,11,0,112,1,73,36,20,1,
		48,76,0,95,1,48,45,0,176,56,0,12,0,106,
		5,110,82,111,119,0,92,120,106,5,110,67,111,108,
		0,89,33,0,0,0,1,0,1,0,176,47,0,101,
		0,0,0,0,0,0,4,64,10,1,48,48,0,95,
		255,112,0,12,2,6,106,8,98,83,101,116,71,101,
		116,0,89,31,0,1,0,1,0,1,0,48,57,0,
		95,255,95,1,106,10,68,105,114,101,99,99,105,111,
		110,0,112,2,6,106,8,98,83,101,116,71,101,116,
		0,89,37,0,1,0,1,0,1,0,176,66,0,12,
		0,121,8,28,11,48,77,0,95,255,112,0,25,11,
		48,38,0,95,255,95,1,112,1,6,106,5,111,87,
		110,100,0,48,48,0,95,1,112,0,106,7,110,87,
		105,100,116,104,0,89,33,0,0,0,1,0,1,0,
		176,47,0,101,102,102,102,102,102,102,28,64,10,1,
		48,48,0,95,255,112,0,12,2,6,106,8,110,72,
		101,105,103,104,116,0,92,23,106,8,108,80,105,120,
		101,108,115,0,120,106,6,98,87,104,101,110,0,90,
		4,9,6,177,9,0,112,1,112,1,73,36,22,1,
		95,1,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( VIEWEDIT_DEFINEDIRECCION )
{
	static const HB_BYTE pcode[] =
	{
		13,1,0,36,26,1,102,80,1,36,38,1,48,45,
		0,176,51,0,12,0,106,5,110,84,111,112,0,92,
		120,106,6,110,76,101,102,116,0,89,33,0,0,0,
		1,0,1,0,176,47,0,101,0,0,0,0,0,0,
		224,63,10,1,48,48,0,95,255,112,0,12,2,6,
		106,5,99,85,82,76,0,106,10,68,105,114,101,99,
		99,105,243,110,0,106,5,111,87,110,100,0,48,48,
		0,95,1,112,0,106,6,111,70,111,110,116,0,176,
		52,0,12,0,106,7,108,80,105,120,101,108,0,120,
		106,9,110,67,108,114,73,110,105,116,0,176,53,0,
		12,0,106,9,110,67,108,114,79,118,101,114,0,176,
		53,0,12,0,106,10,110,67,108,114,86,105,115,105,
		116,0,176,53,0,12,0,106,6,98,87,104,101,110,
		0,89,22,0,0,0,1,0,1,0,48,60,0,48,
		40,0,95,255,112,0,112,0,6,106,8,98,65,99,
		116,105,111,110,0,89,22,0,0,0,1,0,1,0,
		48,78,0,48,40,0,95,255,112,0,112,0,6,177,
		11,0,112,1,73,36,48,1,48,79,0,95,1,48,
		45,0,176,56,0,12,0,106,5,110,82,111,119,0,
		92,120,106,5,110,67,111,108,0,89,33,0,0,0,
		1,0,1,0,176,47,0,101,0,0,0,0,0,0,
		4,64,10,1,48,48,0,95,255,112,0,12,2,6,
		106,8,98,83,101,116,71,101,116,0,89,31,0,1,
		0,1,0,1,0,48,57,0,95,255,95,1,106,10,
		68,105,114,101,99,99,105,111,110,0,112,2,6,106,
		5,111,87,110,100,0,48,48,0,95,1,112,0,106,
		7,110,87,105,100,116,104,0,89,24,0,0,0,1,
		0,1,0,176,47,0,92,2,48,48,0,95,255,112,
		0,12,2,6,106,8,110,72,101,105,103,104,116,0,
		92,23,106,8,108,80,105,120,101,108,115,0,120,106,
		6,98,87,104,101,110,0,89,22,0,0,0,1,0,
		1,0,48,60,0,48,40,0,95,255,112,0,112,0,
		6,106,7,98,86,97,108,105,100,0,89,22,0,0,
		0,1,0,1,0,48,80,0,48,40,0,95,255,112,
		0,112,0,6,177,9,0,112,1,112,1,73,36,57,
		1,48,81,0,95,1,48,45,0,176,56,0,12,0,
		106,5,110,82,111,119,0,92,120,106,5,110,67,111,
		108,0,89,33,0,0,0,1,0,1,0,176,47,0,
		101,102,102,102,102,102,102,18,64,10,1,48,48,0,
		95,255,112,0,12,2,6,106,8,98,83,101,116,71,
		101,116,0,89,37,0,1,0,1,0,1,0,176,66,
		0,12,0,121,8,28,11,48,82,0,95,255,112,0,
		25,11,48,83,0,95,255,95,1,112,1,6,106,5,
		111,87,110,100,0,48,48,0,95,1,112,0,106,7,
		110,87,105,100,116,104,0,89,24,0,0,0,1,0,
		1,0,176,47,0,92,7,48,48,0,95,255,112,0,
		12,2,6,106,8,108,80,105,120,101,108,115,0,120,
		106,6,98,87,104,101,110,0,89,22,0,0,0,1,
		0,1,0,48,60,0,48,40,0,95,255,112,0,112,
		0,6,106,8,110,72,101,105,103,104,116,0,92,23,
		177,8,0,112,1,112,1,73,36,59,1,95,1,110,
		7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( VIEWEDIT_DEFINEBOTONESACCIONES )
{
	static const HB_BYTE pcode[] =
	{
		13,1,0,36,63,1,102,80,1,36,72,1,48,45,
		0,176,46,0,12,0,106,5,110,84,111,112,0,93,
		145,0,106,6,110,76,101,102,116,0,89,33,0,0,
		0,1,0,1,0,176,47,0,101,0,0,0,0,0,
		0,224,63,10,1,48,48,0,95,255,112,0,12,2,
		6,106,7,110,87,105,100,116,104,0,92,64,106,8,
		110,72,101,105,103,104,116,0,92,64,106,9,99,82,
		101,115,78,97,109,101,0,106,11,103,99,95,112,108,
		117,115,95,54,52,0,106,10,98,76,67,108,105,99,
		107,101,100,0,89,30,0,0,0,1,0,1,0,48,
		84,0,48,40,0,95,255,112,0,112,0,73,48,44,
		0,95,255,112,0,6,106,6,98,87,104,101,110,0,
		89,22,0,0,0,1,0,1,0,48,85,0,48,40,
		0,95,255,112,0,112,0,6,106,5,111,87,110,100,
		0,48,48,0,95,1,112,0,177,8,0,112,1,73,
		36,81,1,48,45,0,176,46,0,12,0,106,5,110,
		84,111,112,0,93,145,0,106,6,110,76,101,102,116,
		0,89,24,0,0,0,1,0,1,0,176,47,0,92,
		2,48,48,0,95,255,112,0,12,2,6,106,7,110,
		87,105,100,116,104,0,92,64,106,8,110,72,101,105,
		103,104,116,0,92,64,106,9,99,82,101,115,78,97,
		109,101,0,106,13,103,99,95,112,101,110,99,105,108,
		95,54,52,0,106,6,98,87,104,101,110,0,89,22,
		0,0,0,1,0,1,0,48,86,0,48,40,0,95,
		255,112,0,112,0,6,106,10,98,76,67,108,105,99,
		107,101,100,0,89,42,0,0,0,1,0,1,0,48,
		87,0,48,40,0,95,255,112,0,48,88,0,48,24,
		0,95,255,112,0,112,0,112,1,73,48,44,0,95,
		255,112,0,6,106,5,111,87,110,100,0,48,48,0,
		95,1,112,0,177,8,0,112,1,73,36,90,1,48,
		45,0,176,46,0,12,0,106,5,110,84,111,112,0,
		93,145,0,106,6,110,76,101,102,116,0,89,33,0,
		0,0,1,0,1,0,176,47,0,101,0,0,0,0,
		0,0,12,64,10,1,48,48,0,95,255,112,0,12,
		2,6,106,7,110,87,105,100,116,104,0,92,64,106,
		8,110,72,101,105,103,104,116,0,92,64,106,9,99,
		82,101,115,78,97,109,101,0,106,13,103,99,95,100,
		101,108,101,116,101,95,54,52,0,106,6,98,87,104,
		101,110,0,89,22,0,0,0,1,0,1,0,48,89,
		0,48,40,0,95,255,112,0,112,0,6,106,10,98,
		76,67,108,105,99,107,101,100,0,89,42,0,0,0,
		1,0,1,0,48,90,0,48,40,0,95,255,112,0,
		48,88,0,48,24,0,95,255,112,0,112,0,112,1,
		73,48,44,0,95,255,112,0,6,106,5,111,87,110,
		100,0,48,48,0,95,1,112,0,177,8,0,112,1,
		73,36,92,1,95,1,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( VIEWEDIT_DEFINEBOTONESMOVIMIENTO )
{
	static const HB_BYTE pcode[] =
	{
		13,1,0,36,96,1,102,80,1,36,104,1,48,45,
		0,176,46,0,12,0,106,5,110,84,111,112,0,93,
		145,0,106,6,110,76,101,102,116,0,89,33,0,0,
		0,1,0,1,0,176,47,0,101,0,0,0,0,0,
		0,30,64,10,1,48,48,0,95,255,112,0,12,2,
		6,106,7,110,87,105,100,116,104,0,92,64,106,8,
		110,72,101,105,103,104,116,0,92,64,106,9,99,82,
		101,115,78,97,109,101,0,106,19,103,99,95,110,97,
		118,105,103,97,116,101,95,117,112,50,95,54,52,0,
		106,10,98,76,67,108,105,99,107,101,100,0,89,63,
		0,0,0,1,0,1,0,48,91,0,48,24,0,95,
		255,112,0,112,0,73,48,25,0,48,24,0,95,255,
		112,0,121,112,1,73,48,25,0,48,24,0,95,255,
		112,0,122,112,1,73,48,13,0,48,24,0,95,255,
		112,0,112,0,6,106,5,111,87,110,100,0,48,48,
		0,95,1,112,0,177,7,0,112,1,73,36,112,1,
		48,45,0,176,46,0,12,0,106,5,110,84,111,112,
		0,93,145,0,106,6,110,76,101,102,116,0,89,33,
		0,0,0,1,0,1,0,176,47,0,101,0,0,0,
		0,0,0,33,64,10,1,48,48,0,95,255,112,0,
		12,2,6,106,7,110,87,105,100,116,104,0,92,64,
		106,8,110,72,101,105,103,104,116,0,92,64,106,9,
		99,82,101,115,78,97,109,101,0,106,18,103,99,95,
		110,97,118,105,103,97,116,101,95,117,112,95,54,52,
		0,106,10,98,76,67,108,105,99,107,101,100,0,89,
		63,0,0,0,1,0,1,0,48,92,0,48,24,0,
		95,255,112,0,112,0,73,48,25,0,48,24,0,95,
		255,112,0,121,112,1,73,48,25,0,48,24,0,95,
		255,112,0,122,112,1,73,48,13,0,48,24,0,95,
		255,112,0,112,0,6,106,5,111,87,110,100,0,48,
		48,0,95,1,112,0,177,7,0,112,1,73,36,120,
		1,48,45,0,176,46,0,12,0,106,5,110,84,111,
		112,0,93,145,0,106,6,110,76,101,102,116,0,89,
		33,0,0,0,1,0,1,0,176,47,0,101,0,0,
		0,0,0,0,35,64,10,1,48,48,0,95,255,112,
		0,12,2,6,106,7,110,87,105,100,116,104,0,92,
		64,106,8,110,72,101,105,103,104,116,0,92,64,106,
		9,99,82,101,115,78,97,109,101,0,106,20,103,99,
		95,110,97,118,105,103,97,116,101,95,100,111,119,110,
		95,54,52,0,106,10,98,76,67,108,105,99,107,101,
		100,0,89,63,0,0,0,1,0,1,0,48,93,0,
		48,24,0,95,255,112,0,112,0,73,48,25,0,48,
		24,0,95,255,112,0,121,112,1,73,48,25,0,48,
		24,0,95,255,112,0,122,112,1,73,48,13,0,48,
		24,0,95,255,112,0,112,0,6,106,5,111,87,110,
		100,0,48,48,0,95,1,112,0,177,7,0,112,1,
		73,36,128,1,48,45,0,176,46,0,12,0,106,5,
		110,84,111,112,0,93,145,0,106,6,110,76,101,102,
		116,0,89,33,0,0,0,1,0,1,0,176,47,0,
		101,0,0,0,0,0,0,37,64,10,1,48,48,0,
		95,255,112,0,12,2,6,106,7,110,87,105,100,116,
		104,0,92,64,106,8,110,72,101,105,103,104,116,0,
		92,64,106,9,99,82,101,115,78,97,109,101,0,106,
		21,103,99,95,110,97,118,105,103,97,116,101,95,100,
		111,119,110,50,95,54,52,0,106,10,98,76,67,108,
		105,99,107,101,100,0,89,63,0,0,0,1,0,1,
		0,48,94,0,48,24,0,95,255,112,0,112,0,73,
		48,25,0,48,24,0,95,255,112,0,121,112,1,73,
		48,25,0,48,24,0,95,255,112,0,122,112,1,73,
		48,13,0,48,24,0,95,255,112,0,112,0,6,106,
		5,111,87,110,100,0,48,48,0,95,1,112,0,177,
		7,0,112,1,73,36,130,1,95,1,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( VIEWEDIT_DEFINEBROWSELINEAS )
{
	static const HB_BYTE pcode[] =
	{
		13,1,0,36,134,1,102,80,1,36,136,1,48,95,
		0,95,1,112,0,73,36,138,1,48,96,0,95,1,
		112,0,73,36,140,1,48,97,0,95,1,48,2,0,
		176,98,0,12,0,48,48,0,95,1,112,0,112,1,
		112,1,73,36,142,1,48,99,0,48,24,0,95,1,
		112,0,48,100,0,48,24,0,95,1,112,0,93,180,
		0,112,1,112,1,73,36,143,1,48,101,0,48,24,
		0,95,1,112,0,48,102,0,48,24,0,95,1,112,
		0,89,33,0,0,0,1,0,1,0,176,47,0,101,
		0,0,0,0,0,0,224,63,10,1,48,48,0,95,
		255,112,0,12,2,6,112,1,112,1,73,36,144,1,
		48,103,0,48,24,0,95,1,112,0,48,104,0,48,
		24,0,95,1,112,0,89,24,0,0,0,1,0,1,
		0,176,47,0,92,11,48,48,0,95,255,112,0,12,
		2,6,112,1,112,1,73,36,145,1,48,105,0,48,
		24,0,95,1,112,0,48,106,0,48,24,0,95,1,
		112,0,89,38,0,0,0,1,0,1,0,176,107,0,
		48,48,0,95,255,112,0,12,1,48,108,0,48,24,
		0,95,255,112,0,112,0,49,92,10,49,6,112,1,
		112,1,73,36,146,1,48,109,0,48,24,0,95,1,
		112,0,120,112,1,73,36,147,1,48,110,0,48,24,
		0,95,1,112,0,92,6,112,1,73,36,149,1,48,
		111,0,48,24,0,95,1,112,0,92,48,112,1,73,
		36,150,1,48,112,0,48,24,0,95,1,112,0,92,
		48,112,1,73,36,151,1,48,113,0,48,24,0,95,
		1,112,0,92,48,112,1,73,36,152,1,48,114,0,
		48,24,0,95,1,112,0,92,2,112,1,73,36,154,
		1,48,115,0,48,24,0,95,1,112,0,48,116,0,
		48,40,0,95,1,112,0,112,0,100,100,9,112,4,
		73,36,156,1,48,60,0,48,40,0,95,1,112,0,
		112,0,28,60,36,157,1,48,117,0,48,24,0,95,
		1,112,0,89,42,0,0,0,1,0,1,0,48,87,
		0,48,40,0,95,255,112,0,48,88,0,48,24,0,
		95,255,112,0,112,0,112,1,73,48,44,0,95,255,
		112,0,6,112,1,73,36,160,1,48,118,0,48,24,
		0,95,1,112,0,112,0,73,36,162,1,95,1,110,
		7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_INITSTATICS()
{
	static const HB_BYTE pcode[] =
	{
		117,121,0,2,0,116,121,0,4,0,0,82,1,0,
		7
	};

	hb_vmExecute( pcode, symbols );
}

