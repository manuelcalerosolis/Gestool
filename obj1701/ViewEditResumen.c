/*
 * Harbour 3.2.0dev (r1307082134)
 * Borland C++ 5.8.2 (32-bit)
 * Generated C source from ".\Prg\tablet\view\ViewEditResumen.prg"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC( VIEWEDITRESUMEN );
HB_FUNC_EXTERN( __CLSLOCKDEF );
HB_FUNC_EXTERN( HBCLASS );
HB_FUNC_EXTERN( VIEWBASE );
HB_FUNC_STATIC( VIEWEDITRESUMEN_NEW );
HB_FUNC_STATIC( VIEWEDITRESUMEN_RESOURCE );
HB_FUNC_STATIC( VIEWEDITRESUMEN_DEFINEBOTONESGENERALES );
HB_FUNC_EXTERN( EMPTY );
HB_FUNC_STATIC( VIEWEDITRESUMEN_DEFINECLIENTE );
HB_FUNC_STATIC( VIEWEDITRESUMEN_DEFINEFORMAPAGO );
HB_FUNC_STATIC( VIEWEDITRESUMEN_DEFINEBROWSEIVA );
HB_FUNC_STATIC( VIEWEDITRESUMEN_DEFINECOMBOIMPRESION );
HB_FUNC_STATIC( VIEWEDITRESUMEN_DEFINECHECKRECARGO );
HB_FUNC_STATIC( VIEWEDITRESUMEN_DEFINEPORCENTAJE );
HB_FUNC_EXTERN( HSET );
HB_FUNC_EXTERN( __CLSUNLOCKDEF );
HB_FUNC_EXTERN( __OBJHASMSG );
HB_FUNC_EXTERN( TDIALOG );
HB_FUNC_EXTERN( OGRIDFONT );
HB_FUNC_EXTERN( TGRIDIMAGE );
HB_FUNC_EXTERN( GRIDWIDTH );
HB_FUNC_EXTERN( TGRIDSAY );
HB_FUNC_EXTERN( TGRIDGET );
HB_FUNC_EXTERN( HGET );
HB_FUNC_EXTERN( TGRIDURLLINK );
HB_FUNC_EXTERN( NGRIDCOLOR );
HB_FUNC_EXTERN( TGRIDCOMBOBOX );
HB_FUNC_EXTERN( PCOUNT );
HB_FUNC_EXTERN( TGRIDCHECKBOX );
HB_FUNC_EXTERN( TGRIDIXBROWSE );
HB_FUNC_EXTERN( GRIDHEIGTH );
HB_FUNC_EXTERN( CIMP );
HB_FUNC_EXTERN( FW_GT );
HB_FUNC_EXTERN( ERRORSYS );
HB_FUNC_INITSTATICS();


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_VIEWEDITRESUMEN )
{ "VIEWEDITRESUMEN", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( VIEWEDITRESUMEN )}, NULL },
{ "__CLSLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSLOCKDEF )}, NULL },
{ "NEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBCLASS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBCLASS )}, NULL },
{ "VIEWBASE", {HB_FS_PUBLIC}, {HB_FUNCNAME( VIEWBASE )}, NULL },
{ "ADDMULTIDATA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDMETHOD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "VIEWEDITRESUMEN_NEW", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( VIEWEDITRESUMEN_NEW )}, NULL },
{ "VIEWEDITRESUMEN_RESOURCE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( VIEWEDITRESUMEN_RESOURCE )}, NULL },
{ "VIEWEDITRESUMEN_DEFINEBOTONESGENERALES", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( VIEWEDITRESUMEN_DEFINEBOTONESGENERALES )}, NULL },
{ "ADDINLINE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EMPTY", {HB_FS_PUBLIC}, {HB_FUNCNAME( EMPTY )}, NULL },
{ "_CCODIGOCLIENTE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CNOMBRECLIENTE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "VIEWEDITRESUMEN_DEFINECLIENTE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( VIEWEDITRESUMEN_DEFINECLIENTE )}, NULL },
{ "_CCODIGOFORMAPAGO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CNOMBREFORMAPAGO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "VIEWEDITRESUMEN_DEFINEFORMAPAGO", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( VIEWEDITRESUMEN_DEFINEFORMAPAGO )}, NULL },
{ "_ACBXIMPRESORA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CCBXIMPRESORA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "VIEWEDITRESUMEN_DEFINEBROWSEIVA", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( VIEWEDITRESUMEN_DEFINEBROWSEIVA )}, NULL },
{ "VIEWEDITRESUMEN_DEFINECOMBOIMPRESION", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( VIEWEDITRESUMEN_DEFINECOMBOIMPRESION )}, NULL },
{ "VIEWEDITRESUMEN_DEFINECHECKRECARGO", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( VIEWEDITRESUMEN_DEFINECHECKRECARGO )}, NULL },
{ "VIEWEDITRESUMEN_DEFINEPORCENTAJE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( VIEWEDITRESUMEN_DEFINEPORCENTAJE )}, NULL },
{ "HSET", {HB_FS_PUBLIC}, {HB_FUNCNAME( HSET )}, NULL },
{ "HDICTIONARYMASTER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OSENDER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CREATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__CLSUNLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSUNLOCKDEF )}, NULL },
{ "INSTANCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__OBJHASMSG", {HB_FS_PUBLIC}, {HB_FUNCNAME( __OBJHASMSG )}, NULL },
{ "INITCLASS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_OSENDER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "RESETROW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_ODLG", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TDIALOG", {HB_FS_PUBLIC}, {HB_FUNCNAME( TDIALOG )}, NULL },
{ "STYLE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OGRIDFONT", {HB_FS_PUBLIC}, {HB_FUNCNAME( OGRIDFONT )}, NULL },
{ "DEFINETITULO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DEFINEBOTONESGENERALES", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DEFINECLIENTE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DEFINEFORMAPAGO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DEFINECOMBOIMPRESION", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DEFINEPORCENTAJE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DEFINECHECKRECARGO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DEFINEBROWSEIVA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BRESIZED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ODLG", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "RESIZEDIALOG", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BSTART", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LVALIDPAYMENT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ACTIVATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "INITDIALOG", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NRESULT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BUILD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TGRIDIMAGE", {HB_FS_PUBLIC}, {HB_FUNCNAME( TGRIDIMAGE )}, NULL },
{ "GRIDWIDTH", {HB_FS_PUBLIC}, {HB_FUNCNAME( GRIDWIDTH )}, NULL },
{ "END", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETFORMATTOPRINT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CCBXIMPRESORA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TGRIDSAY", {HB_FS_PUBLIC}, {HB_FUNCNAME( TGRIDSAY )}, NULL },
{ "GETROW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TGRIDGET", {HB_FS_PUBLIC}, {HB_FUNCNAME( TGRIDGET )}, NULL },
{ "HGET", {HB_FS_PUBLIC}, {HB_FUNCNAME( HGET )}, NULL },
{ "NEXTROW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TGRIDURLLINK", {HB_FS_PUBLIC}, {HB_FUNCNAME( TGRIDURLLINK )}, NULL },
{ "NGRIDCOLOR", {HB_FS_PUBLIC}, {HB_FUNCNAME( NGRIDCOLOR )}, NULL },
{ "RUNGRIDPAYMENT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_OCODIGOFORMAPAGO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETGETVALUE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LNOTZOOMMODE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_ONOMBREFORMAPAGO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETDOCUMENTS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_OCBXIMPRESORA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TGRIDCOMBOBOX", {HB_FS_PUBLIC}, {HB_FUNCNAME( TGRIDCOMBOBOX )}, NULL },
{ "PCOUNT", {HB_FS_PUBLIC}, {HB_FUNCNAME( PCOUNT )}, NULL },
{ "ACBXIMPRESORA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_OPORCENTAJEDESCUENTO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "RECALCULARTOTAL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_OCHECKBOXRECARGO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TGRIDCHECKBOX", {HB_FS_PUBLIC}, {HB_FUNCNAME( TGRIDCHECKBOX )}, NULL },
{ "REFRESH", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OBROWSE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
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
{ "ADDCOL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CHEADER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BSTRDATA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SHOWBASEIVA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OTOTALDOCUMENT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NARRAYAT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NDATASTRALIGN", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NHEADSTRALIGN", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NFOOTSTRALIGN", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BFOOTER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TRANSBASE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CIMP", {HB_FS_PUBLIC}, {HB_FUNCNAME( CIMP )}, NULL },
{ "SHOWPORCENTAJESIVA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SHOWIMPORTESIVA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TRANSPRICE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SHOWTOTALIVA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TRANSTOTALDOCUMENT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NHEADERHEIGHT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NFOOTERHEIGHT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NROWHEIGHT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NDATALINES", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETARRAY", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "AIVA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OIVA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CREATEFROMCODE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FW_GT", {HB_FS_PUBLIC}, {HB_FUNCNAME( FW_GT )}, NULL },
{ "ERRORSYS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORSYS )}, NULL },
{ "(_INITSTATICS00002)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITSTATICS}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_VIEWEDITRESUMEN, ".\\Prg\\tablet\\view\\ViewEditResumen.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_VIEWEDITRESUMEN
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_VIEWEDITRESUMEN )
   #include "hbiniseg.h"
#endif

HB_FUNC( VIEWEDITRESUMEN )
{
	static const HB_BYTE pcode[] =
	{
		149,3,0,116,124,0,36,5,0,103,2,0,100,8,
		29,241,6,176,1,0,104,2,0,12,1,29,230,6,
		166,168,6,0,122,80,1,48,2,0,176,3,0,12,
		0,106,16,86,105,101,119,69,100,105,116,82,101,115,
		117,109,101,110,0,108,4,4,1,0,108,0,112,3,
		80,2,36,7,0,48,5,0,95,2,100,100,95,1,
		121,72,121,72,121,72,106,5,111,68,108,103,0,4,
		1,0,9,112,5,73,36,8,0,48,5,0,95,2,
		100,100,95,1,121,72,121,72,121,72,106,8,111,83,
		101,110,100,101,114,0,4,1,0,9,112,5,73,36,
		9,0,48,5,0,95,2,100,100,95,1,121,72,121,
		72,121,72,106,8,111,66,114,111,119,115,101,0,4,
		1,0,9,112,5,73,36,10,0,48,5,0,95,2,
		100,100,95,1,121,72,121,72,121,72,106,17,111,67,
		104,101,99,107,66,111,120,82,101,99,97,114,103,111,
		0,4,1,0,9,112,5,73,36,11,0,48,5,0,
		95,2,100,100,95,1,121,72,121,72,121,72,106,14,
		111,67,111,109,98,111,82,101,99,97,114,103,111,0,
		4,1,0,9,112,5,73,36,12,0,48,5,0,95,
		2,100,106,25,67,111,110,32,114,101,99,97,114,103,
		111,32,69,113,117,105,118,97,108,101,110,99,105,97,
		0,106,25,83,105,110,32,82,101,99,97,114,103,111,
		32,69,113,117,105,118,97,108,101,110,99,105,97,0,
		4,2,0,95,1,121,72,121,72,121,72,106,14,97,
		67,111,109,98,111,82,101,99,97,114,103,111,0,4,
		1,0,9,112,5,73,36,13,0,48,5,0,95,2,
		100,100,95,1,121,72,121,72,121,72,106,14,99,67,
		111,109,98,111,82,101,99,97,114,103,111,0,4,1,
		0,9,112,5,73,36,14,0,48,5,0,95,2,100,
		100,95,1,121,72,121,72,121,72,106,14,111,67,98,
		120,73,109,112,114,101,115,111,114,97,0,4,1,0,
		9,112,5,73,36,15,0,48,5,0,95,2,100,4,
		0,0,95,1,121,72,121,72,121,72,106,14,97,67,
		98,120,73,109,112,114,101,115,111,114,97,0,4,1,
		0,9,112,5,73,36,16,0,48,5,0,95,2,100,
		100,95,1,121,72,121,72,121,72,106,14,99,67,98,
		120,73,109,112,114,101,115,111,114,97,0,4,1,0,
		9,112,5,73,36,17,0,48,5,0,95,2,100,106,
		1,0,95,1,121,72,121,72,121,72,106,15,99,67,
		111,100,105,103,111,67,108,105,101,110,116,101,0,4,
		1,0,9,112,5,73,36,18,0,48,5,0,95,2,
		100,106,1,0,95,1,121,72,121,72,121,72,106,15,
		99,78,111,109,98,114,101,67,108,105,101,110,116,101,
		0,4,1,0,9,112,5,73,36,19,0,48,5,0,
		95,2,100,100,95,1,121,72,121,72,121,72,106,17,
		111,67,111,100,105,103,111,70,111,114,109,97,80,97,
		103,111,0,4,1,0,9,112,5,73,36,20,0,48,
		5,0,95,2,100,106,1,0,95,1,121,72,121,72,
		121,72,106,17,99,67,111,100,105,103,111,70,111,114,
		109,97,80,97,103,111,0,4,1,0,9,112,5,73,
		36,21,0,48,5,0,95,2,100,100,95,1,121,72,
		121,72,121,72,106,17,111,78,111,109,98,114,101,70,
		111,114,109,97,80,97,103,111,0,4,1,0,9,112,
		5,73,36,22,0,48,5,0,95,2,100,106,1,0,
		95,1,121,72,121,72,121,72,106,17,99,78,111,109,
		98,114,101,70,111,114,109,97,80,97,103,111,0,4,
		1,0,9,112,5,73,36,23,0,48,5,0,95,2,
		100,100,95,1,121,72,121,72,121,72,106,21,111,80,
		111,114,99,101,110,116,97,106,101,68,101,115,99,117,
		101,110,116,111,0,4,1,0,9,112,5,73,36,25,
		0,48,6,0,95,2,106,4,78,101,119,0,108,7,
		95,1,121,72,121,72,121,72,112,3,73,36,27,0,
		48,6,0,95,2,106,9,82,101,115,111,117,114,99,
		101,0,108,8,95,1,121,72,121,72,121,72,112,3,
		73,36,29,0,48,6,0,95,2,106,23,100,101,102,
		105,110,101,66,111,116,111,110,101,115,71,101,110,101,
		114,97,108,101,115,0,108,9,95,1,121,72,121,72,
		121,72,112,3,73,36,31,0,48,10,0,95,2,106,
		17,83,101,116,67,111,100,105,103,111,67,108,105,101,
		110,116,101,0,89,38,0,2,0,0,0,176,11,0,
		95,2,12,1,31,13,48,12,0,95,1,95,2,112,
		1,25,12,48,12,0,95,1,106,1,0,112,1,6,
		95,1,121,72,121,72,121,72,112,3,73,36,32,0,
		48,10,0,95,2,106,17,83,101,116,78,111,109,98,
		114,101,67,108,105,101,110,116,101,0,89,38,0,2,
		0,0,0,176,11,0,95,2,12,1,31,13,48,13,
		0,95,1,95,2,112,1,25,12,48,13,0,95,1,
		106,1,0,112,1,6,95,1,121,72,121,72,121,72,
		112,3,73,36,34,0,48,6,0,95,2,106,14,100,
		101,102,105,110,101,67,108,105,101,110,116,101,0,108,
		14,95,1,121,72,121,72,121,72,112,3,73,36,36,
		0,48,10,0,95,2,106,19,83,101,116,67,111,100,
		105,103,111,70,111,114,109,97,80,97,103,111,0,89,
		38,0,2,0,0,0,176,11,0,95,2,12,1,31,
		13,48,15,0,95,1,95,2,112,1,25,12,48,15,
		0,95,1,106,1,0,112,1,6,95,1,121,72,121,
		72,121,72,112,3,73,36,37,0,48,10,0,95,2,
		106,19,83,101,116,78,111,109,98,114,101,70,111,114,
		109,97,80,97,103,111,0,89,38,0,2,0,0,0,
		176,11,0,95,2,12,1,31,13,48,16,0,95,1,
		95,2,112,1,25,12,48,16,0,95,1,106,1,0,
		112,1,6,95,1,121,72,121,72,121,72,112,3,73,
		36,39,0,48,6,0,95,2,106,16,100,101,102,105,
		110,101,70,111,114,109,97,80,97,103,111,0,108,17,
		95,1,121,72,121,72,121,72,112,3,73,36,41,0,
		48,10,0,95,2,106,14,83,101,116,73,109,112,114,
		101,115,111,114,97,115,0,89,38,0,2,0,0,0,
		176,11,0,95,2,12,1,31,13,48,18,0,95,1,
		95,2,112,1,25,12,48,18,0,95,1,4,0,0,
		112,1,6,95,1,121,72,121,72,121,72,112,3,73,
		36,42,0,48,10,0,95,2,106,20,83,101,116,73,
		109,112,114,101,115,111,114,97,68,101,102,101,99,116,
		111,0,89,38,0,2,0,0,0,176,11,0,95,2,
		12,1,31,13,48,19,0,95,1,95,2,112,1,25,
		12,48,19,0,95,1,4,0,0,112,1,6,95,1,
		121,72,121,72,121,72,112,3,73,36,44,0,48,6,
		0,95,2,106,16,100,101,102,105,110,101,66,114,111,
		119,115,101,73,118,97,0,108,20,95,1,121,72,121,
		72,121,72,112,3,73,36,46,0,48,6,0,95,2,
		106,21,100,101,102,105,110,101,67,111,109,98,111,73,
		109,112,114,101,115,105,111,110,0,108,21,95,1,121,
		72,121,72,121,72,112,3,73,36,48,0,48,6,0,
		95,2,106,19,100,101,102,105,110,101,67,104,101,99,
		107,82,101,99,97,114,103,111,0,108,22,95,1,121,
		72,121,72,121,72,112,3,73,36,50,0,48,6,0,
		95,2,106,17,100,101,102,105,110,101,80,111,114,99,
		101,110,116,97,106,101,0,108,23,95,1,121,72,121,
		72,121,72,112,3,73,36,52,0,48,10,0,95,2,
		106,7,83,101,116,71,101,116,0,89,49,0,2,0,
		0,0,176,24,0,48,25,0,48,26,0,95,1,112,
		0,112,0,106,20,82,101,99,97,114,103,111,69,113,
		117,105,118,97,108,101,110,99,105,97,0,95,2,12,
		3,6,95,1,121,72,121,72,121,72,112,3,73,36,
		54,0,48,27,0,95,2,112,0,73,167,14,0,0,
		176,28,0,104,2,0,95,2,20,2,168,48,29,0,
		95,2,112,0,80,3,176,30,0,95,3,106,10,73,
		110,105,116,67,108,97,115,115,0,12,2,28,12,48,
		31,0,95,3,164,146,1,0,73,95,3,110,7,48,
		29,0,103,2,0,112,0,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( VIEWEDITRESUMEN_NEW )
{
	static const HB_BYTE pcode[] =
	{
		13,0,1,36,60,0,48,32,0,102,95,1,112,1,
		73,36,62,0,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( VIEWEDITRESUMEN_RESOURCE )
{
	static const HB_BYTE pcode[] =
	{
		13,1,0,36,66,0,102,80,1,36,68,0,48,33,
		0,95,1,112,0,73,36,70,0,48,34,0,95,1,
		48,2,0,176,35,0,12,0,122,92,5,92,40,92,
		100,106,15,71,69,83,84,79,79,76,32,84,65,66,
		76,69,84,0,100,100,9,48,36,0,95,1,112,0,
		100,97,255,255,255,0,100,100,9,100,176,37,0,12,
		0,100,100,100,9,100,106,5,111,68,108,103,0,112,
		22,112,1,73,36,72,0,48,38,0,95,1,112,0,
		73,36,74,0,48,39,0,95,1,112,0,73,36,76,
		0,48,40,0,95,1,112,0,73,36,78,0,48,41,
		0,95,1,112,0,73,36,80,0,48,42,0,95,1,
		112,0,73,36,82,0,48,43,0,95,1,112,0,73,
		36,84,0,48,44,0,95,1,112,0,73,36,86,0,
		48,45,0,95,1,112,0,73,36,88,0,48,46,0,
		48,47,0,95,1,112,0,89,17,0,0,0,1,0,
		1,0,48,48,0,95,255,112,0,6,112,1,73,36,
		90,0,48,49,0,48,47,0,95,1,112,0,89,22,
		0,0,0,1,0,1,0,48,50,0,48,26,0,95,
		255,112,0,112,0,6,112,1,73,36,92,0,48,51,
		0,48,47,0,95,1,112,0,100,100,100,120,100,100,
		89,17,0,0,0,1,0,1,0,48,52,0,95,255,
		112,0,6,112,7,73,36,94,0,48,53,0,48,47,
		0,95,1,112,0,112,0,122,8,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( VIEWEDITRESUMEN_DEFINEBOTONESGENERALES )
{
	static const HB_BYTE pcode[] =
	{
		13,1,0,36,98,0,102,80,1,36,107,0,48,54,
		0,176,55,0,12,0,106,5,110,84,111,112,0,92,
		5,106,6,110,76,101,102,116,0,89,33,0,0,0,
		1,0,1,0,176,56,0,101,0,0,0,0,0,0,
		30,64,10,1,48,47,0,95,255,112,0,12,2,6,
		106,7,110,87,105,100,116,104,0,92,64,106,8,110,
		72,101,105,103,104,116,0,92,64,106,9,99,82,101,
		115,78,97,109,101,0,106,12,103,99,95,101,114,114,
		111,114,95,54,52,0,106,10,98,76,67,108,105,99,
		107,101,100,0,89,22,0,0,0,1,0,1,0,48,
		57,0,48,47,0,95,255,112,0,112,0,6,106,5,
		111,87,110,100,0,48,47,0,95,1,112,0,177,7,
		0,112,1,73,36,115,0,48,54,0,176,55,0,12,
		0,106,5,110,84,111,112,0,92,5,106,6,110,76,
		101,102,116,0,89,24,0,0,0,1,0,1,0,176,
		56,0,92,9,48,47,0,95,255,112,0,12,2,6,
		106,7,110,87,105,100,116,104,0,92,64,106,8,110,
		72,101,105,103,104,116,0,92,64,106,9,99,82,101,
		115,78,97,109,101,0,106,14,103,99,95,112,114,105,
		110,116,101,114,95,54,52,0,106,10,98,76,67,108,
		105,99,107,101,100,0,89,43,0,0,0,1,0,1,
		0,48,58,0,48,26,0,95,255,112,0,48,59,0,
		95,255,112,0,112,1,73,48,57,0,48,47,0,95,
		255,112,0,122,112,1,6,106,5,111,87,110,100,0,
		48,47,0,95,1,112,0,177,7,0,112,1,73,36,
		123,0,48,54,0,176,55,0,12,0,106,5,110,84,
		111,112,0,92,5,106,6,110,76,101,102,116,0,89,
		33,0,0,0,1,0,1,0,176,56,0,101,0,0,
		0,0,0,0,37,64,10,1,48,47,0,95,255,112,
		0,12,2,6,106,7,110,87,105,100,116,104,0,92,
		64,106,8,110,72,101,105,103,104,116,0,92,64,106,
		9,99,82,101,115,78,97,109,101,0,106,9,103,99,
		95,111,107,95,54,52,0,106,10,98,76,67,108,105,
		99,107,101,100,0,89,23,0,0,0,1,0,1,0,
		48,57,0,48,47,0,95,255,112,0,122,112,1,6,
		106,5,111,87,110,100,0,48,47,0,95,1,112,0,
		177,7,0,112,1,73,36,125,0,95,1,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( VIEWEDITRESUMEN_DEFINECLIENTE )
{
	static const HB_BYTE pcode[] =
	{
		13,1,0,36,129,0,102,80,1,36,141,0,48,54,
		0,176,60,0,12,0,106,5,110,82,111,119,0,48,
		61,0,95,1,112,0,106,5,110,67,111,108,0,89,
		33,0,0,0,1,0,1,0,176,56,0,101,0,0,
		0,0,0,0,224,63,10,1,48,47,0,95,255,112,
		0,12,2,6,106,6,98,84,101,120,116,0,90,15,
		106,10,67,108,105,101,110,116,101,58,32,0,6,106,
		5,111,87,110,100,0,48,47,0,95,1,112,0,106,
		6,111,70,111,110,116,0,176,37,0,12,0,106,8,
		108,80,105,120,101,108,115,0,120,106,9,110,67,108,
		114,84,101,120,116,0,121,106,9,110,67,108,114,66,
		97,99,107,0,97,255,255,255,0,106,7,110,87,105,
		100,116,104,0,89,24,0,0,0,1,0,1,0,176,
		56,0,92,2,48,47,0,95,255,112,0,12,2,6,
		106,8,110,72,101,105,103,104,116,0,92,23,106,8,
		108,68,101,115,105,103,110,0,9,177,11,0,112,1,
		73,36,150,0,48,54,0,176,62,0,12,0,106,5,
		110,82,111,119,0,48,61,0,95,1,112,0,106,5,
		110,67,111,108,0,89,33,0,0,0,1,0,1,0,
		176,56,0,101,0,0,0,0,0,0,4,64,10,1,
		48,47,0,95,255,112,0,12,2,6,106,5,111,87,
		110,100,0,48,47,0,95,1,112,0,106,8,98,83,
		101,116,71,101,116,0,89,37,0,1,0,1,0,1,
		0,176,63,0,48,25,0,48,26,0,95,255,112,0,
		112,0,106,8,67,108,105,101,110,116,101,0,12,2,
		6,106,7,110,87,105,100,116,104,0,89,24,0,0,
		0,1,0,1,0,176,56,0,92,2,48,47,0,95,
		255,112,0,12,2,6,106,8,110,72,101,105,103,104,
		116,0,92,23,106,6,98,87,104,101,110,0,90,4,
		9,6,106,8,108,80,105,120,101,108,115,0,120,177,
		8,0,112,1,73,36,159,0,48,54,0,176,62,0,
		12,0,106,5,110,82,111,119,0,48,61,0,95,1,
		112,0,106,5,110,67,111,108,0,89,33,0,0,0,
		1,0,1,0,176,56,0,101,0,0,0,0,0,0,
		18,64,10,1,48,47,0,95,255,112,0,12,2,6,
		106,5,111,87,110,100,0,48,47,0,95,1,112,0,
		106,8,98,83,101,116,71,101,116,0,89,43,0,1,
		0,1,0,1,0,176,63,0,48,25,0,48,26,0,
		95,255,112,0,112,0,106,14,78,111,109,98,114,101,
		67,108,105,101,110,116,101,0,12,2,6,106,8,108,
		80,105,120,101,108,115,0,120,106,7,110,87,105,100,
		116,104,0,89,24,0,0,0,1,0,1,0,176,56,
		0,92,7,48,47,0,95,255,112,0,12,2,6,106,
		6,98,87,104,101,110,0,90,4,9,6,106,8,110,
		72,101,105,103,104,116,0,92,23,177,8,0,112,1,
		73,36,161,0,48,64,0,95,1,112,0,73,36,163,
		0,95,1,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( VIEWEDITRESUMEN_DEFINEFORMAPAGO )
{
	static const HB_BYTE pcode[] =
	{
		13,1,0,36,167,0,102,80,1,36,178,0,48,54,
		0,176,65,0,12,0,106,5,110,84,111,112,0,48,
		61,0,95,1,112,0,106,6,110,76,101,102,116,0,
		89,33,0,0,0,1,0,1,0,176,56,0,101,0,
		0,0,0,0,0,224,63,10,1,48,47,0,95,255,
		112,0,12,2,6,106,5,99,85,82,76,0,106,8,
		70,46,32,112,97,103,111,0,106,5,111,87,110,100,
		0,48,47,0,95,1,112,0,106,6,111,70,111,110,
		116,0,176,37,0,12,0,106,7,108,80,105,120,101,
		108,0,120,106,9,110,67,108,114,73,110,105,116,0,
		176,66,0,12,0,106,9,110,67,108,114,79,118,101,
		114,0,176,66,0,12,0,106,10,110,67,108,114,86,
		105,115,105,116,0,176,66,0,12,0,106,8,98,65,
		99,116,105,111,110,0,89,22,0,0,0,1,0,1,
		0,48,67,0,48,26,0,95,255,112,0,112,0,6,
		177,10,0,112,1,73,36,188,0,48,68,0,95,1,
		48,54,0,176,62,0,12,0,106,5,110,82,111,119,
		0,48,61,0,95,1,112,0,106,5,110,67,111,108,
		0,89,33,0,0,0,1,0,1,0,176,56,0,101,
		0,0,0,0,0,0,4,64,10,1,48,47,0,95,
		255,112,0,12,2,6,106,8,98,83,101,116,71,101,
		116,0,89,26,0,1,0,1,0,1,0,48,69,0,
		95,255,95,1,106,5,80,97,103,111,0,112,2,6,
		106,5,111,87,110,100,0,48,47,0,95,1,112,0,
		106,7,110,87,105,100,116,104,0,89,24,0,0,0,
		1,0,1,0,176,56,0,92,2,48,47,0,95,255,
		112,0,12,2,6,106,8,110,72,101,105,103,104,116,
		0,92,23,106,8,108,80,105,120,101,108,115,0,120,
		106,6,98,87,104,101,110,0,89,22,0,0,0,1,
		0,1,0,48,70,0,48,26,0,95,255,112,0,112,
		0,6,106,7,98,86,97,108,105,100,0,89,22,0,
		0,0,1,0,1,0,48,50,0,48,26,0,95,255,
		112,0,112,0,6,177,9,0,112,1,112,1,73,36,
		196,0,48,71,0,95,1,48,54,0,176,62,0,12,
		0,106,5,110,82,111,119,0,48,61,0,95,1,112,
		0,106,5,110,67,111,108,0,89,33,0,0,0,1,
		0,1,0,176,56,0,101,0,0,0,0,0,0,18,
		64,10,1,48,47,0,95,255,112,0,12,2,6,106,
		5,111,87,110,100,0,48,47,0,95,1,112,0,106,
		7,110,87,105,100,116,104,0,89,24,0,0,0,1,
		0,1,0,176,56,0,92,7,48,47,0,95,255,112,
		0,12,2,6,106,8,108,80,105,120,101,108,115,0,
		120,106,6,98,87,104,101,110,0,90,4,9,6,106,
		8,110,72,101,105,103,104,116,0,92,23,177,7,0,
		112,1,112,1,73,36,198,0,48,64,0,95,1,112,
		0,73,36,200,0,95,1,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( VIEWEDITRESUMEN_DEFINECOMBOIMPRESION )
{
	static const HB_BYTE pcode[] =
	{
		13,1,0,36,204,0,102,80,1,36,206,0,48,72,
		0,48,26,0,95,1,112,0,112,0,73,36,218,0,
		48,54,0,176,60,0,12,0,106,5,110,82,111,119,
		0,48,61,0,95,1,112,0,106,5,110,67,111,108,
		0,89,33,0,0,0,1,0,1,0,176,56,0,101,
		0,0,0,0,0,0,224,63,10,1,48,47,0,95,
		255,112,0,12,2,6,106,6,98,84,101,120,116,0,
		90,16,106,11,73,109,112,114,101,115,105,243,110,58,
		0,6,106,5,111,87,110,100,0,48,47,0,95,1,
		112,0,106,6,111,70,111,110,116,0,176,37,0,12,
		0,106,8,108,80,105,120,101,108,115,0,120,106,9,
		110,67,108,114,84,101,120,116,0,121,106,9,110,67,
		108,114,66,97,99,107,0,97,255,255,255,0,106,7,
		110,87,105,100,116,104,0,89,24,0,0,0,1,0,
		1,0,176,56,0,92,2,48,47,0,95,255,112,0,
		12,2,6,106,8,110,72,101,105,103,104,116,0,92,
		25,106,8,108,68,101,115,105,103,110,0,9,177,11,
		0,112,1,73,36,226,0,48,73,0,95,1,48,54,
		0,176,74,0,12,0,106,5,110,82,111,119,0,48,
		61,0,95,1,112,0,106,5,110,67,111,108,0,89,
		33,0,0,0,1,0,1,0,176,56,0,101,0,0,
		0,0,0,0,4,64,10,1,48,47,0,95,255,112,
		0,12,2,6,106,8,98,83,101,116,71,101,116,0,
		89,37,0,1,0,1,0,1,0,176,75,0,12,0,
		121,8,28,11,48,59,0,95,255,112,0,25,11,48,
		19,0,95,255,95,1,112,1,6,106,5,111,87,110,
		100,0,48,47,0,95,1,112,0,106,7,110,87,105,
		100,116,104,0,89,24,0,0,0,1,0,1,0,176,
		56,0,92,9,48,47,0,95,255,112,0,12,2,6,
		106,8,110,72,101,105,103,104,116,0,92,25,106,7,
		97,73,116,101,109,115,0,48,76,0,95,1,112,0,
		177,7,0,112,1,112,1,73,36,228,0,48,64,0,
		95,1,112,0,73,36,230,0,95,1,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( VIEWEDITRESUMEN_DEFINEPORCENTAJE )
{
	static const HB_BYTE pcode[] =
	{
		13,1,0,36,234,0,102,80,1,36,246,0,48,54,
		0,176,60,0,12,0,106,5,110,82,111,119,0,48,
		61,0,95,1,112,0,106,5,110,67,111,108,0,89,
		33,0,0,0,1,0,1,0,176,56,0,101,0,0,
		0,0,0,0,224,63,10,1,48,47,0,95,255,112,
		0,12,2,6,106,6,98,84,101,120,116,0,90,26,
		106,21,80,111,114,99,101,110,116,97,106,101,32,100,
		101,115,99,117,101,110,116,111,0,6,106,5,111,87,
		110,100,0,48,47,0,95,1,112,0,106,6,111,70,
		111,110,116,0,176,37,0,12,0,106,8,108,80,105,
		120,101,108,115,0,120,106,9,110,67,108,114,84,101,
		120,116,0,121,106,9,110,67,108,114,66,97,99,107,
		0,97,255,255,255,0,106,7,110,87,105,100,116,104,
		0,89,24,0,0,0,1,0,1,0,176,56,0,92,
		2,48,47,0,95,255,112,0,12,2,6,106,8,110,
		72,101,105,103,104,116,0,92,23,106,8,108,68,101,
		115,105,103,110,0,9,177,11,0,112,1,73,36,2,
		1,48,77,0,95,1,48,54,0,176,62,0,12,0,
		106,5,110,82,111,119,0,48,61,0,95,1,112,0,
		106,5,110,67,111,108,0,89,33,0,0,0,1,0,
		1,0,176,56,0,101,0,0,0,0,0,0,4,64,
		10,1,48,47,0,95,255,112,0,12,2,6,106,8,
		98,83,101,116,71,101,116,0,89,42,0,1,0,1,
		0,1,0,48,69,0,95,255,95,1,106,21,80,111,
		114,99,101,110,116,97,106,101,68,101,115,99,117,101,
		110,116,111,49,0,112,2,6,106,5,111,87,110,100,
		0,48,47,0,95,1,112,0,106,8,108,80,105,120,
		101,108,115,0,120,106,7,110,87,105,100,116,104,0,
		89,24,0,0,0,1,0,1,0,176,56,0,92,2,
		48,47,0,95,255,112,0,12,2,6,106,6,99,80,
		105,99,116,0,106,10,64,69,32,57,57,57,46,57,
		57,0,106,7,108,82,105,103,104,116,0,120,106,8,
		110,72,101,105,103,104,116,0,92,23,106,6,98,87,
		104,101,110,0,89,22,0,0,0,1,0,1,0,48,
		70,0,48,26,0,95,255,112,0,112,0,6,106,7,
		98,86,97,108,105,100,0,89,22,0,0,0,1,0,
		1,0,48,78,0,48,26,0,95,255,112,0,112,0,
		6,177,11,0,112,1,112,1,73,36,4,1,48,64,
		0,95,1,112,0,73,36,6,1,95,1,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( VIEWEDITRESUMEN_DEFINECHECKRECARGO )
{
	static const HB_BYTE pcode[] =
	{
		13,1,0,36,10,1,102,80,1,36,22,1,48,79,
		0,95,1,48,54,0,176,80,0,12,0,106,5,110,
		82,111,119,0,48,61,0,95,1,112,0,106,5,110,
		67,111,108,0,89,33,0,0,0,1,0,1,0,176,
		56,0,101,0,0,0,0,0,0,224,63,10,1,48,
		47,0,95,255,112,0,12,2,6,106,9,99,67,97,
		112,116,105,111,110,0,106,21,82,101,99,97,114,103,
		111,32,69,113,117,105,118,97,108,101,110,99,105,97,
		0,106,8,98,83,101,116,71,101,116,0,89,41,0,
		1,0,1,0,1,0,48,69,0,95,255,95,1,106,
		20,82,101,99,97,114,103,111,69,113,117,105,118,97,
		108,101,110,99,105,97,0,112,2,6,106,5,111,87,
		110,100,0,48,47,0,95,1,112,0,106,7,110,87,
		105,100,116,104,0,89,24,0,0,0,1,0,1,0,
		176,56,0,92,7,48,47,0,95,255,112,0,12,2,
		6,106,8,110,72,101,105,103,104,116,0,92,23,106,
		6,111,70,111,110,116,0,176,37,0,12,0,106,8,
		108,80,105,120,101,108,115,0,120,106,6,98,87,104,
		101,110,0,89,22,0,0,0,1,0,1,0,48,70,
		0,48,26,0,95,255,112,0,112,0,6,106,8,98,
		67,104,97,110,103,101,0,89,22,0,0,0,1,0,
		1,0,48,81,0,48,82,0,95,255,112,0,112,0,
		6,177,11,0,112,1,112,1,73,36,24,1,48,64,
		0,95,1,112,0,73,36,26,1,95,1,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( VIEWEDITRESUMEN_DEFINEBROWSEIVA )
{
	static const HB_BYTE pcode[] =
	{
		13,1,0,36,30,1,102,80,1,36,32,1,48,83,
		0,95,1,48,2,0,176,84,0,12,0,48,47,0,
		95,1,112,0,112,1,112,1,73,36,34,1,48,85,
		0,48,82,0,95,1,112,0,48,86,0,48,82,0,
		95,1,112,0,48,61,0,95,1,112,0,112,1,112,
		1,73,36,35,1,48,87,0,48,82,0,95,1,112,
		0,48,88,0,48,82,0,95,1,112,0,89,33,0,
		0,0,1,0,1,0,176,56,0,101,0,0,0,0,
		0,0,224,63,10,1,48,47,0,95,255,112,0,12,
		2,6,112,1,112,1,73,36,36,1,48,89,0,48,
		82,0,95,1,112,0,48,90,0,48,82,0,95,1,
		112,0,89,24,0,0,0,1,0,1,0,176,56,0,
		92,11,48,47,0,95,255,112,0,12,2,6,112,1,
		112,1,73,36,37,1,48,91,0,48,82,0,95,1,
		112,0,48,92,0,48,82,0,95,1,112,0,89,38,
		0,0,0,1,0,1,0,176,93,0,48,47,0,95,
		255,112,0,12,1,48,94,0,48,82,0,95,255,112,
		0,112,0,49,92,10,49,6,112,1,112,1,73,36,
		38,1,48,95,0,48,82,0,95,1,112,0,120,112,
		1,73,36,39,1,48,96,0,48,82,0,95,1,112,
		0,92,6,112,1,73,36,41,1,48,97,0,48,82,
		0,95,1,112,0,112,0,143,36,42,1,144,98,0,
		106,5,66,97,115,101,0,112,1,73,36,43,1,144,
		99,0,89,39,0,0,0,1,0,1,0,48,100,0,
		48,101,0,48,26,0,95,255,112,0,112,0,48,102,
		0,48,82,0,95,255,112,0,112,0,112,1,6,112,
		1,73,36,44,1,144,89,0,93,170,0,112,1,73,
		36,45,1,144,103,0,122,112,1,73,36,46,1,144,
		104,0,122,112,1,73,36,47,1,144,105,0,122,112,
		1,73,36,48,1,144,106,0,89,27,0,0,0,1,
		0,1,0,48,107,0,48,101,0,48,26,0,95,255,
		112,0,112,0,112,0,6,112,1,73,145,36,51,1,
		48,97,0,48,82,0,95,1,112,0,112,0,143,36,
		52,1,144,98,0,106,2,37,0,176,108,0,12,0,
		72,106,8,32,45,32,37,32,82,69,0,72,112,1,
		73,36,53,1,144,99,0,89,39,0,0,0,1,0,
		1,0,48,109,0,48,101,0,48,26,0,95,255,112,
		0,112,0,48,102,0,48,82,0,95,255,112,0,112,
		0,112,1,6,112,1,73,36,54,1,144,89,0,93,
		170,0,112,1,73,36,55,1,144,103,0,122,112,1,
		73,36,56,1,144,104,0,122,112,1,73,145,36,59,
		1,48,97,0,48,82,0,95,1,112,0,112,0,143,
		36,60,1,144,98,0,176,108,0,12,0,106,6,32,
		45,32,82,69,0,72,112,1,73,36,61,1,144,99,
		0,89,39,0,0,0,1,0,1,0,48,110,0,48,
		101,0,48,26,0,95,255,112,0,112,0,48,102,0,
		48,82,0,95,255,112,0,112,0,112,1,6,112,1,
		73,36,62,1,144,89,0,93,160,0,112,1,73,36,
		63,1,144,103,0,122,112,1,73,36,64,1,144,104,
		0,122,112,1,73,36,65,1,144,105,0,122,112,1,
		73,36,66,1,144,106,0,89,27,0,0,0,1,0,
		1,0,48,111,0,48,101,0,48,26,0,95,255,112,
		0,112,0,112,0,6,112,1,73,145,36,69,1,48,
		97,0,48,82,0,95,1,112,0,112,0,143,36,70,
		1,144,98,0,106,6,84,111,116,97,108,0,112,1,
		73,36,71,1,144,99,0,89,39,0,0,0,1,0,
		1,0,48,112,0,48,101,0,48,26,0,95,255,112,
		0,112,0,48,102,0,48,82,0,95,255,112,0,112,
		0,112,1,6,112,1,73,36,72,1,144,89,0,93,
		170,0,112,1,73,36,73,1,144,103,0,122,112,1,
		73,36,74,1,144,104,0,122,112,1,73,36,75,1,
		144,105,0,122,112,1,73,36,76,1,144,106,0,89,
		27,0,0,0,1,0,1,0,48,113,0,48,101,0,
		48,26,0,95,255,112,0,112,0,112,0,6,112,1,
		73,145,36,79,1,48,114,0,48,82,0,95,1,112,
		0,92,48,112,1,73,36,80,1,48,115,0,48,82,
		0,95,1,112,0,92,48,112,1,73,36,81,1,48,
		116,0,48,82,0,95,1,112,0,92,96,112,1,73,
		36,82,1,48,117,0,48,82,0,95,1,112,0,92,
		2,112,1,73,36,84,1,48,118,0,48,82,0,95,
		1,112,0,48,119,0,48,120,0,48,101,0,48,26,
		0,95,1,112,0,112,0,112,0,112,0,100,100,9,
		112,4,73,36,86,1,48,121,0,48,82,0,95,1,
		112,0,112,0,73,36,88,1,95,1,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_INITSTATICS()
{
	static const HB_BYTE pcode[] =
	{
		117,124,0,2,0,116,124,0,4,0,0,82,1,0,
		7
	};

	hb_vmExecute( pcode, symbols );
}
