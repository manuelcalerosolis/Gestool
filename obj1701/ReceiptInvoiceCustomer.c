/*
 * Harbour 3.2.0dev (r1307082134)
 * Borland C++ 5.8.2 (32-bit)
 * Generated C source from ".\Prg\tablet\presenter\documentos\ventas\ReceiptInvoiceCustomer.prg"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC( RECEIPTINVOICECUSTOMER );
HB_FUNC_EXTERN( __CLSLOCKDEF );
HB_FUNC_EXTERN( HBCLASS );
HB_FUNC_EXTERN( DOCUMENTSSALES );
HB_FUNC_STATIC( RECEIPTINVOICECUSTOMER_NEW );
HB_FUNC_STATIC( RECEIPTINVOICECUSTOMER_PLAY );
HB_FUNC_STATIC( RECEIPTINVOICECUSTOMER_GETEDITDOCUMENTO );
HB_FUNC_STATIC( RECEIPTINVOICECUSTOMER_ONPREEND );
HB_FUNC_STATIC( RECEIPTINVOICECUSTOMER_ONPOSTGETDOCUMENTO );
HB_FUNC_STATIC( RECEIPTINVOICECUSTOMER_ONVIEWSAVE );
HB_FUNC_STATIC( RECEIPTINVOICECUSTOMER_ONPRESAVEEDIT );
HB_FUNC_STATIC( RECEIPTINVOICECUSTOMER_ONPREEDITDOCUMENTO );
HB_FUNC_STATIC( RECEIPTINVOICECUSTOMER_ADDRECIBODIFERENCIA );
HB_FUNC_STATIC( RECEIPTINVOICECUSTOMER_FILTERTABLE );
HB_FUNC_STATIC( RECEIPTINVOICECUSTOMER_ONPRERUNNAVIGATOR );
HB_FUNC_STATIC( RECEIPTINVOICECUSTOMER_ONPOSTSAVEEDIT );
HB_FUNC_EXTERN( PRNRECCLI );
HB_FUNC_EXTERN( STR );
HB_FUNC_EXTERN( __CLSUNLOCKDEF );
HB_FUNC_EXTERN( __OBJHASMSG );
HB_FUNC_EXTERN( EMPTY );
HB_FUNC_EXTERN( RECEIPTDOCUMENTSALESVIEWSEARCHNAVIGATOR );
HB_FUNC_EXTERN( RECEIPTDOCUMENTSALESVIEWEDIT );
HB_FUNC_EXTERN( D );
HB_FUNC_EXTERN( HSET );
HB_FUNC_EXTERN( DATE );
HB_FUNC_EXTERN( TIME );
HB_FUNC_EXTERN( HGET );
HB_FUNC_EXTERN( RECNO );
HB_FUNC_EXTERN( ORDSETFOCUS );
HB_FUNC_EXTERN( DBSEEK );
HB_FUNC_EXTERN( DBLOCK );
HB_FUNC_EXTERN( DBUNLOCK );
HB_FUNC_EXTERN( CHKLQDFACCLI );
HB_FUNC_EXTERN( DBGOTO );
HB_FUNC_EXTERN( DBSCATTER );
HB_FUNC_EXTERN( FIELDPOS );
HB_FUNC_EXTERN( DBCLEARFILTER );
HB_FUNC_EXTERN( NNEWRECIBOCLIENTE );
HB_FUNC_EXTERN( DBAPPEND );
HB_FUNC_EXTERN( CCURSESION );
HB_FUNC_EXTERN( ALLTRIM );
HB_FUNC_EXTERN( DFECFACCLI );
HB_FUNC_EXTERN( GETSYSDATE );
HB_FUNC_EXTERN( SUBSTR );
HB_FUNC_EXTERN( ADSSETAOF );
HB_FUNC_EXTERN( OUSER );
HB_FUNC_EXTERN( ADSCLEARAOF );
HB_FUNC_EXTERN( DBGOTOP );
HB_FUNC_EXTERN( ACCESSCODE );
HB_FUNC_EXTERN( FW_GT );
HB_FUNC_EXTERN( ERRORSYS );
HB_FUNC_INITSTATICS();


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_RECEIPTINVOICECUSTOMER )
{ "RECEIPTINVOICECUSTOMER", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( RECEIPTINVOICECUSTOMER )}, NULL },
{ "__CLSLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSLOCKDEF )}, NULL },
{ "NEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBCLASS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBCLASS )}, NULL },
{ "DOCUMENTSSALES", {HB_FS_PUBLIC}, {HB_FUNCNAME( DOCUMENTSSALES )}, NULL },
{ "ADDMULTIDATA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDMETHOD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "RECEIPTINVOICECUSTOMER_NEW", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( RECEIPTINVOICECUSTOMER_NEW )}, NULL },
{ "RECEIPTINVOICECUSTOMER_PLAY", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( RECEIPTINVOICECUSTOMER_PLAY )}, NULL },
{ "RECEIPTINVOICECUSTOMER_GETEDITDOCUMENTO", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( RECEIPTINVOICECUSTOMER_GETEDITDOCUMENTO )}, NULL },
{ "RECEIPTINVOICECUSTOMER_ONPREEND", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( RECEIPTINVOICECUSTOMER_ONPREEND )}, NULL },
{ "RECEIPTINVOICECUSTOMER_ONPOSTGETDOCUMENTO", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( RECEIPTINVOICECUSTOMER_ONPOSTGETDOCUMENTO )}, NULL },
{ "RECEIPTINVOICECUSTOMER_ONVIEWSAVE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( RECEIPTINVOICECUSTOMER_ONVIEWSAVE )}, NULL },
{ "RECEIPTINVOICECUSTOMER_ONPRESAVEEDIT", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( RECEIPTINVOICECUSTOMER_ONPRESAVEEDIT )}, NULL },
{ "ADDINLINE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "RECEIPTINVOICECUSTOMER_ONPREEDITDOCUMENTO", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( RECEIPTINVOICECUSTOMER_ONPREEDITDOCUMENTO )}, NULL },
{ "RECEIPTINVOICECUSTOMER_ADDRECIBODIFERENCIA", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( RECEIPTINVOICECUSTOMER_ADDRECIBODIFERENCIA )}, NULL },
{ "RECEIPTINVOICECUSTOMER_FILTERTABLE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( RECEIPTINVOICECUSTOMER_FILTERTABLE )}, NULL },
{ "RECEIPTINVOICECUSTOMER_ONPRERUNNAVIGATOR", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( RECEIPTINVOICECUSTOMER_ONPRERUNNAVIGATOR )}, NULL },
{ "RECEIPTINVOICECUSTOMER_ONPOSTSAVEEDIT", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( RECEIPTINVOICECUSTOMER_ONPOSTSAVEEDIT )}, NULL },
{ "PRNRECCLI", {HB_FS_PUBLIC}, {HB_FUNCNAME( PRNRECCLI )}, NULL },
{ "GETDATATABLE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CSERIE", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "STR", {HB_FS_PUBLIC}, {HB_FUNCNAME( STR )}, NULL },
{ "NNUMFAC", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "CSUFFAC", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "NNUMREC", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "_LACEPTARIMPRIMIR", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CREATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__CLSUNLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSUNLOCKDEF )}, NULL },
{ "INSTANCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__OBJHASMSG", {HB_FS_PUBLIC}, {HB_FUNCNAME( __OBJHASMSG )}, NULL },
{ "INITCLASS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_OSENDER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SUPER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EMPTY", {HB_FS_PUBLIC}, {HB_FUNCNAME( EMPTY )}, NULL },
{ "OPENFILES", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_LCLOSEFILES", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NVIEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NVIEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CNUMEROFACTURA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETID", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_LSHOWFILTERCOBRADO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_OVIEWSEARCHNAVIGATOR", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "RECEIPTDOCUMENTSALESVIEWSEARCHNAVIGATOR", {HB_FS_PUBLIC}, {HB_FUNCNAME( RECEIPTDOCUMENTSALESVIEWSEARCHNAVIGATOR )}, NULL },
{ "SETTITLEDOCUMENTO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OVIEWSEARCHNAVIGATOR", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_OVIEWEDIT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "RECEIPTDOCUMENTSALESVIEWEDIT", {HB_FS_PUBLIC}, {HB_FUNCNAME( RECEIPTDOCUMENTSALESVIEWEDIT )}, NULL },
{ "OVIEWEDIT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETTYPEPRINTDOCUMENTS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETCOUNTERDOCUMENTS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETDATATABLE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ONPRERUNNAVIGATOR", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "RUNNAVIGATOR", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LCLOSEFILES", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CLOSEFILES", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FACTURASCLIENTESCOBROSID", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "D", {HB_FS_PUBLIC}, {HB_FUNCNAME( D )}, NULL },
{ "_HDICTIONARYMASTER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETFACTURACLIENTECOBROS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HDICTIONARYMASTER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "END", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ODLG", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HSET", {HB_FS_PUBLIC}, {HB_FUNCNAME( HSET )}, NULL },
{ "OSENDER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CCBXESTADO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DATE", {HB_FS_PUBLIC}, {HB_FUNCNAME( DATE )}, NULL },
{ "TIME", {HB_FS_PUBLIC}, {HB_FUNCNAME( TIME )}, NULL },
{ "HGET", {HB_FS_PUBLIC}, {HB_FUNCNAME( HGET )}, NULL },
{ "NIMPORTEANTERIOR", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDRECIBODIFERENCIA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FACTURASCLIENTES", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "RECNO", {HB_FS_PUBLIC}, {HB_FUNCNAME( RECNO )}, NULL },
{ "ORDSETFOCUS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ORDSETFOCUS )}, NULL },
{ "LACEPTARIMPRIMIR", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "PRINTRECEIPT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETFALSEACEPTARIMPRIMIR", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DBSEEK", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBSEEK )}, NULL },
{ "DBLOCK", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBLOCK )}, NULL },
{ "LSNDDOC", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "DFECCRE", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "CTIMCRE", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "DBUNLOCK", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBUNLOCK )}, NULL },
{ "CHKLQDFACCLI", {HB_FS_PUBLIC}, {HB_FUNCNAME( CHKLQDFACCLI )}, NULL },
{ "FACTURASCLIENTESLINEAS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FACTURASCLIENTESCOBROS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ANTICIPOSCLIENTES", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TIPOSIVA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DIVISAS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DBGOTO", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBGOTO )}, NULL },
{ "CHANGECOMBOBOXSEARCH", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FILTERTABLE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CCOMBOBOXFILTER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_OLDSERIE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETSERIE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NIMPORTEANTERIOR", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NORDENANTERIOR", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NORDENANTERIOR", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DBSCATTER", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBSCATTER )}, NULL },
{ "FIELDPOS", {HB_FS_PUBLIC}, {HB_FUNCNAME( FIELDPOS )}, NULL },
{ "DBCLEARFILTER", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBCLEARFILTER )}, NULL },
{ "NNEWRECIBOCLIENTE", {HB_FS_PUBLIC}, {HB_FUNCNAME( NNEWRECIBOCLIENTE )}, NULL },
{ "DBAPPEND", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBAPPEND )}, NULL },
{ "CCURSESION", {HB_FS_PUBLIC}, {HB_FUNCNAME( CCURSESION )}, NULL },
{ "CTURREC", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "CTIPREC", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "CCODCAJ", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "CCODCLI", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "CNOMCLI", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "CCODAGE", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "NIMPORTE", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "NIMPCOB", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "ALLTRIM", {HB_FS_PUBLIC}, {HB_FUNCNAME( ALLTRIM )}, NULL },
{ "CDESCRIP", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "DFECFACCLI", {HB_FS_PUBLIC}, {HB_FUNCNAME( DFECFACCLI )}, NULL },
{ "DPRECOB", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "CPGDOPOR", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "LCOBRADO", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "CDIVPGO", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "NVDVPGO", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "CCODPGO", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "LCONPGO", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "GETSYSDATE", {HB_FS_PUBLIC}, {HB_FUNCNAME( GETSYSDATE )}, NULL },
{ "SUBSTR", {HB_FS_PUBLIC}, {HB_FUNCNAME( SUBSTR )}, NULL },
{ "CHORCRE", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "ADSSETAOF", {HB_FS_PUBLIC}, {HB_FUNCNAME( ADSSETAOF )}, NULL },
{ "CDELEGACION", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OUSER", {HB_FS_PUBLIC}, {HB_FUNCNAME( OUSER )}, NULL },
{ "ADSCLEARAOF", {HB_FS_PUBLIC}, {HB_FUNCNAME( ADSCLEARAOF )}, NULL },
{ "DBGOTOP", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBGOTOP )}, NULL },
{ "SELECTCURRENT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OBROWSE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "REFRESH", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETWORKAREA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CNUMEROFACTURA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LFILTERBYAGENT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ACCESSCODE", {HB_FS_PUBLIC}, {HB_FUNCNAME( ACCESSCODE )}, NULL },
{ "CAGENTE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CLIENTES", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FW_GT", {HB_FS_PUBLIC}, {HB_FUNCNAME( FW_GT )}, NULL },
{ "ERRORSYS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORSYS )}, NULL },
{ "(_INITSTATICS00002)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITSTATICS}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_RECEIPTINVOICECUSTOMER, ".\\Prg\\tablet\\presenter\\documentos\\ventas\\ReceiptInvoiceCustomer.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_RECEIPTINVOICECUSTOMER
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_RECEIPTINVOICECUSTOMER )
   #include "hbiniseg.h"
#endif

HB_FUNC( RECEIPTINVOICECUSTOMER )
{
	static const HB_BYTE pcode[] =
	{
		149,3,0,116,142,0,36,5,0,103,2,0,100,8,
		29,135,4,176,1,0,104,2,0,12,1,29,124,4,
		166,62,4,0,122,80,1,48,2,0,176,3,0,12,
		0,106,23,82,101,99,101,105,112,116,73,110,118,111,
		105,99,101,67,117,115,116,111,109,101,114,0,108,4,
		4,1,0,108,0,112,3,80,2,36,7,0,48,5,
		0,95,2,100,106,1,0,95,1,121,72,121,72,121,
		72,106,15,99,78,117,109,101,114,111,70,97,99,116,
		117,114,97,0,4,1,0,9,112,5,73,36,8,0,
		48,5,0,95,2,100,121,95,1,121,72,121,72,121,
		72,106,17,110,73,109,112,111,114,116,101,65,110,116,
		101,114,105,111,114,0,4,1,0,9,112,5,73,36,
		9,0,48,5,0,95,2,100,120,95,1,121,72,121,
		72,121,72,106,19,108,83,104,111,119,70,105,108,116,
		101,114,67,111,98,114,97,100,111,0,4,1,0,9,
		112,5,73,36,10,0,48,5,0,95,2,100,120,95,
		1,121,72,121,72,121,72,106,12,108,67,108,111,115,
		101,70,105,108,101,115,0,4,1,0,9,112,5,73,
		36,12,0,48,5,0,95,2,100,9,95,1,121,72,
		121,72,121,72,106,17,108,65,99,101,112,116,97,114,
		73,109,112,114,105,109,105,114,0,4,1,0,9,112,
		5,73,36,14,0,48,6,0,95,2,106,4,78,101,
		119,0,108,7,95,1,121,72,121,72,121,72,112,3,
		73,36,16,0,48,6,0,95,2,106,5,80,108,97,
		121,0,108,8,95,1,121,72,121,72,121,72,112,3,
		73,36,18,0,48,6,0,95,2,106,17,103,101,116,
		69,100,105,116,68,111,99,117,109,101,110,116,111,0,
		108,9,95,1,121,72,121,72,121,72,112,3,73,36,
		20,0,48,6,0,95,2,106,9,111,110,80,114,101,
		69,110,100,0,108,10,95,1,121,72,121,72,121,72,
		112,3,73,36,22,0,48,6,0,95,2,106,19,111,
		110,80,111,115,116,71,101,116,68,111,99,117,109,101,
		110,116,111,0,108,11,95,1,121,72,121,72,121,72,
		112,3,73,36,24,0,48,6,0,95,2,106,11,111,
		110,86,105,101,119,83,97,118,101,0,108,12,95,1,
		121,72,121,72,121,72,112,3,73,36,26,0,48,6,
		0,95,2,106,14,111,110,80,114,101,83,97,118,101,
		69,100,105,116,0,108,13,95,1,121,72,121,72,121,
		72,112,3,73,36,28,0,48,14,0,95,2,106,20,
		100,101,108,101,116,101,76,105,110,101,115,68,111,99,
		117,109,101,110,116,0,89,9,0,1,0,0,0,120,
		6,95,1,121,72,121,72,121,72,112,3,73,36,30,
		0,48,14,0,95,2,106,20,97,115,115,105,103,110,
		76,105,110,101,115,68,111,99,117,109,101,110,116,0,
		89,9,0,1,0,0,0,120,6,95,1,121,72,121,
		72,121,72,112,3,73,36,32,0,48,14,0,95,2,
		106,17,115,101,116,76,105,110,101,115,68,111,99,117,
		109,101,110,116,0,89,9,0,1,0,0,0,120,6,
		95,1,121,72,121,72,121,72,112,3,73,36,34,0,
		48,6,0,95,2,106,19,111,110,80,114,101,69,100,
		105,116,68,111,99,117,109,101,110,116,111,0,108,15,
		95,1,121,72,121,72,121,72,112,3,73,36,36,0,
		48,6,0,95,2,106,20,97,100,100,82,101,99,105,
		98,111,68,105,102,101,114,101,110,99,105,97,0,108,
		16,95,1,121,72,121,72,121,72,112,3,73,36,38,
		0,48,6,0,95,2,106,12,70,105,108,116,101,114,
		84,97,98,108,101,0,108,17,95,1,121,72,121,72,
		121,72,112,3,73,36,40,0,48,6,0,95,2,106,
		18,111,110,80,114,101,82,117,110,78,97,118,105,103,
		97,116,111,114,0,108,18,95,1,121,72,121,72,121,
		72,112,3,73,36,42,0,48,6,0,95,2,106,15,
		111,110,80,111,115,116,83,97,118,101,69,100,105,116,
		0,108,19,95,1,121,72,121,72,121,72,112,3,73,
		36,44,0,48,14,0,95,2,106,13,112,114,105,110,
		116,82,101,99,101,105,112,116,0,89,66,0,1,0,
		0,0,176,20,0,48,21,0,95,1,112,0,88,22,
		0,176,23,0,48,21,0,95,1,112,0,88,24,0,
		12,1,72,48,21,0,95,1,112,0,88,25,0,72,
		176,23,0,48,21,0,95,1,112,0,88,26,0,12,
		1,72,12,1,6,95,1,121,72,121,72,121,72,112,
		3,73,36,46,0,48,14,0,95,2,106,23,115,101,
		116,84,114,117,101,65,99,101,112,116,97,114,73,109,
		112,114,105,109,105,114,0,89,16,0,1,0,0,0,
		48,27,0,95,1,120,112,1,6,95,1,121,72,121,
		72,121,72,112,3,73,36,47,0,48,14,0,95,2,
		106,24,115,101,116,70,97,108,115,101,65,99,101,112,
		116,97,114,73,109,112,114,105,109,105,114,0,89,16,
		0,1,0,0,0,48,27,0,95,1,120,112,1,6,
		95,1,121,72,121,72,121,72,112,3,73,36,49,0,
		48,28,0,95,2,112,0,73,167,14,0,0,176,29,
		0,104,2,0,95,2,20,2,168,48,30,0,95,2,
		112,0,80,3,176,31,0,95,3,106,10,73,110,105,
		116,67,108,97,115,115,0,12,2,28,12,48,32,0,
		95,3,164,146,1,0,73,95,3,110,7,48,30,0,
		103,2,0,112,0,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( RECEIPTINVOICECUSTOMER_NEW )
{
	static const HB_BYTE pcode[] =
	{
		13,0,1,36,55,0,48,33,0,48,34,0,102,112,
		0,102,112,1,73,36,57,0,176,35,0,95,1,12,
		1,28,19,36,59,0,48,36,0,102,112,0,31,75,
		36,60,0,102,110,7,36,65,0,48,37,0,102,9,
		112,1,73,36,66,0,48,38,0,102,48,39,0,95,
		1,112,0,112,1,73,36,67,0,48,40,0,102,48,
		41,0,95,1,112,0,112,1,73,36,68,0,48,42,
		0,102,176,35,0,48,41,0,95,1,112,0,12,1,
		112,1,73,36,72,0,48,43,0,102,48,2,0,176,
		44,0,12,0,102,112,1,112,1,73,36,73,0,48,
		45,0,48,46,0,102,112,0,106,20,82,101,99,105,
		98,111,115,32,100,101,32,99,108,105,101,110,116,101,
		115,0,112,1,73,36,75,0,48,47,0,102,48,2,
		0,176,48,0,12,0,102,112,1,112,1,73,36,76,
		0,48,45,0,48,49,0,102,112,0,106,15,82,101,
		99,105,98,111,32,99,108,105,101,110,116,101,0,112,
		1,73,36,78,0,48,50,0,102,106,3,82,70,0,
		112,1,73,36,80,0,48,51,0,102,106,8,78,82,
		69,67,67,76,73,0,112,1,73,36,84,0,48,52,
		0,102,106,8,70,97,99,67,108,105,80,0,112,1,
		73,36,86,0,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( RECEIPTINVOICECUSTOMER_PLAY )
{
	static const HB_BYTE pcode[] =
	{
		36,92,0,48,53,0,102,112,0,28,12,36,93,0,
		48,54,0,102,112,0,73,36,96,0,48,55,0,102,
		112,0,28,12,36,97,0,48,56,0,102,112,0,73,
		36,100,0,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( RECEIPTINVOICECUSTOMER_GETEDITDOCUMENTO )
{
	static const HB_BYTE pcode[] =
	{
		13,1,0,36,106,0,48,57,0,176,58,0,12,0,
		48,39,0,102,112,0,112,1,80,1,36,108,0,176,
		35,0,95,1,12,1,28,8,36,109,0,9,110,7,
		36,112,0,48,59,0,102,48,60,0,176,58,0,12,
		0,48,39,0,102,112,0,112,1,112,1,73,36,114,
		0,176,35,0,48,61,0,102,112,0,12,1,28,8,
		36,115,0,9,110,7,36,118,0,120,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( RECEIPTINVOICECUSTOMER_ONVIEWSAVE )
{
	static const HB_BYTE pcode[] =
	{
		36,124,0,48,62,0,48,63,0,48,49,0,102,112,
		0,112,0,122,112,1,73,36,126,0,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( RECEIPTINVOICECUSTOMER_ONPRESAVEEDIT )
{
	static const HB_BYTE pcode[] =
	{
		13,2,0,36,132,0,121,80,1,36,133,0,121,80,
		2,36,139,0,176,64,0,48,61,0,48,65,0,102,
		112,0,112,0,106,14,76,111,103,105,99,111,67,111,
		98,114,97,100,111,0,48,66,0,48,49,0,102,112,
		0,112,0,106,8,67,111,98,114,97,100,111,0,8,
		20,3,36,140,0,176,64,0,48,61,0,48,65,0,
		102,112,0,112,0,106,11,70,101,99,104,97,67,111,
		98,114,111,0,48,66,0,48,49,0,102,112,0,112,
		0,106,8,67,111,98,114,97,100,111,0,8,28,9,
		176,67,0,12,0,25,7,134,0,0,0,0,20,3,
		36,142,0,176,64,0,48,61,0,48,65,0,102,112,
		0,112,0,106,14,70,101,99,104,97,67,114,101,97,
		99,105,111,110,0,176,67,0,12,0,20,3,36,143,
		0,176,64,0,48,61,0,48,65,0,102,112,0,112,
		0,106,13,72,111,114,97,67,114,101,97,99,105,111,
		110,0,176,68,0,12,0,20,3,36,149,0,176,69,
		0,48,61,0,48,65,0,102,112,0,112,0,106,15,
		84,111,116,97,108,68,111,99,117,109,101,110,116,111,
		0,12,2,80,1,36,151,0,95,1,48,70,0,102,
		112,0,69,28,44,36,153,0,48,70,0,102,112,0,
		95,1,49,48,70,0,102,112,0,121,35,28,6,92,
		255,25,3,122,65,80,2,36,155,0,48,71,0,102,
		95,2,112,1,73,36,159,0,120,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( RECEIPTINVOICECUSTOMER_ONPOSTSAVEEDIT )
{
	static const HB_BYTE pcode[] =
	{
		13,2,0,36,165,0,85,48,72,0,176,58,0,12,
		0,48,39,0,102,112,0,112,1,74,176,73,0,12,
		0,119,80,1,36,166,0,85,48,72,0,176,58,0,
		12,0,48,39,0,102,112,0,112,1,74,176,74,0,
		106,8,78,78,85,77,70,65,67,0,12,1,119,80,
		2,36,168,0,48,75,0,102,112,0,28,22,36,169,
		0,48,76,0,102,112,0,73,36,170,0,48,77,0,
		102,112,0,73,36,173,0,85,48,72,0,176,58,0,
		12,0,48,39,0,102,112,0,112,1,74,176,78,0,
		48,21,0,102,112,0,88,22,0,176,23,0,48,21,
		0,102,112,0,88,24,0,12,1,72,48,21,0,102,
		112,0,88,25,0,72,12,1,119,29,239,0,36,175,
		0,176,79,0,48,72,0,176,58,0,12,0,48,39,
		0,102,112,0,112,1,12,1,28,106,36,176,0,120,
		48,72,0,176,58,0,12,0,48,39,0,102,112,0,
		112,1,77,80,0,36,177,0,176,67,0,12,0,48,
		72,0,176,58,0,12,0,48,39,0,102,112,0,112,
		1,77,81,0,36,178,0,176,68,0,12,0,48,72,
		0,176,58,0,12,0,48,39,0,102,112,0,112,1,
		77,82,0,36,179,0,85,48,72,0,176,58,0,12,
		0,48,39,0,102,112,0,112,1,74,176,83,0,20,
		0,74,36,182,0,176,84,0,100,48,72,0,176,58,
		0,12,0,48,39,0,102,112,0,112,1,48,85,0,
		176,58,0,12,0,48,39,0,102,112,0,112,1,48,
		86,0,176,58,0,12,0,48,39,0,102,112,0,112,
		1,48,87,0,176,58,0,12,0,48,39,0,102,112,
		0,112,1,48,88,0,176,58,0,12,0,48,39,0,
		102,112,0,112,1,48,89,0,176,58,0,12,0,48,
		39,0,102,112,0,112,1,9,20,8,36,186,0,85,
		48,72,0,176,58,0,12,0,48,39,0,102,112,0,
		112,1,74,176,74,0,95,2,20,1,74,36,187,0,
		85,48,72,0,176,58,0,12,0,48,39,0,102,112,
		0,112,1,74,176,90,0,95,1,20,1,74,36,189,
		0,48,91,0,48,46,0,102,112,0,112,0,73,36,
		191,0,48,92,0,102,48,93,0,48,46,0,102,112,
		0,112,0,112,1,73,36,193,0,120,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( RECEIPTINVOICECUSTOMER_ONPOSTGETDOCUMENTO )
{
	static const HB_BYTE pcode[] =
	{
		36,199,0,48,94,0,102,48,95,0,102,112,0,112,
		1,73,36,201,0,48,96,0,102,176,69,0,48,61,
		0,48,65,0,102,112,0,112,0,106,15,84,111,116,
		97,108,68,111,99,117,109,101,110,116,111,0,12,2,
		112,1,73,36,203,0,120,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( RECEIPTINVOICECUSTOMER_ONPREEDITDOCUMENTO )
{
	static const HB_BYTE pcode[] =
	{
		36,209,0,48,97,0,102,85,48,21,0,102,112,0,
		74,176,74,0,12,0,119,112,1,73,36,211,0,120,
		110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( RECEIPTINVOICECUSTOMER_ONPREEND )
{
	static const HB_BYTE pcode[] =
	{
		13,1,0,36,217,0,48,21,0,102,112,0,88,22,
		0,176,23,0,48,21,0,102,112,0,88,24,0,12,
		1,72,48,21,0,102,112,0,88,25,0,72,80,1,
		36,223,0,85,48,72,0,176,58,0,12,0,48,39,
		0,102,112,0,112,1,74,176,78,0,95,1,12,1,
		119,28,108,36,224,0,176,84,0,100,48,72,0,176,
		58,0,12,0,48,39,0,102,112,0,112,1,48,85,
		0,176,58,0,12,0,48,39,0,102,112,0,112,1,
		48,86,0,176,58,0,12,0,48,39,0,102,112,0,
		112,1,48,87,0,176,58,0,12,0,48,39,0,102,
		112,0,112,1,48,88,0,176,58,0,12,0,48,39,
		0,102,112,0,112,1,48,89,0,176,58,0,12,0,
		48,39,0,102,112,0,112,1,9,20,8,36,227,0,
		85,48,21,0,102,112,0,74,176,74,0,48,98,0,
		102,112,0,20,1,74,36,229,0,120,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( RECEIPTINVOICECUSTOMER_ADDRECIBODIFERENCIA )
{
	static const HB_BYTE pcode[] =
	{
		13,4,1,36,235,0,85,48,21,0,102,112,0,74,
		176,73,0,12,0,119,80,2,36,238,0,106,1,0,
		80,5,36,240,0,176,99,0,48,21,0,102,112,0,
		12,1,80,3,36,242,0,96,5,0,95,3,85,48,
		21,0,102,112,0,74,176,100,0,106,7,99,83,101,
		114,105,101,0,12,1,119,1,135,36,243,0,96,5,
		0,176,23,0,95,3,85,48,21,0,102,112,0,74,
		176,100,0,106,8,110,78,117,109,70,97,99,0,12,
		1,119,1,12,1,135,36,244,0,96,5,0,95,3,
		85,48,21,0,102,112,0,74,176,100,0,106,8,99,
		83,117,102,70,97,99,0,12,1,119,1,135,36,246,
		0,85,48,21,0,102,112,0,74,176,101,0,20,0,
		74,36,248,0,176,102,0,95,5,95,3,85,48,21,
		0,102,112,0,74,176,100,0,106,8,99,84,105,112,
		82,101,99,0,12,1,119,1,48,21,0,102,112,0,
		12,3,80,4,36,254,0,85,48,21,0,102,112,0,
		74,176,103,0,20,0,74,36,0,1,176,104,0,12,
		0,48,21,0,102,112,0,77,105,0,36,1,1,95,
		3,85,48,21,0,102,112,0,74,176,100,0,106,8,
		99,84,105,112,82,101,99,0,12,1,119,1,48,21,
		0,102,112,0,77,106,0,36,2,1,95,3,85,48,
		21,0,102,112,0,74,176,100,0,106,7,99,83,101,
		114,105,101,0,12,1,119,1,48,21,0,102,112,0,
		77,22,0,36,3,1,95,3,85,48,21,0,102,112,
		0,74,176,100,0,106,8,110,78,117,109,70,97,99,
		0,12,1,119,1,48,21,0,102,112,0,77,24,0,
		36,4,1,95,3,85,48,21,0,102,112,0,74,176,
		100,0,106,8,99,83,117,102,70,97,99,0,12,1,
		119,1,48,21,0,102,112,0,77,25,0,36,5,1,
		95,4,48,21,0,102,112,0,77,26,0,36,6,1,
		95,3,85,48,21,0,102,112,0,74,176,100,0,106,
		8,99,67,111,100,67,97,106,0,12,1,119,1,48,
		21,0,102,112,0,77,107,0,36,7,1,95,3,85,
		48,21,0,102,112,0,74,176,100,0,106,8,99,67,
		111,100,67,108,105,0,12,1,119,1,48,21,0,102,
		112,0,77,108,0,36,8,1,95,3,85,48,21,0,
		102,112,0,74,176,100,0,106,8,99,78,111,109,67,
		108,105,0,12,1,119,1,48,21,0,102,112,0,77,
		109,0,36,9,1,95,3,85,48,21,0,102,112,0,
		74,176,100,0,106,8,99,67,111,100,65,103,101,0,
		12,1,119,1,48,21,0,102,112,0,77,110,0,36,
		10,1,95,1,48,21,0,102,112,0,77,111,0,36,
		11,1,95,1,48,21,0,102,112,0,77,112,0,36,
		12,1,106,10,82,101,99,105,98,111,32,110,186,0,
		176,113,0,176,23,0,95,4,12,1,12,1,72,106,
		13,32,100,101,32,102,97,99,116,117,114,97,32,0,
		72,176,35,0,95,3,85,48,21,0,102,112,0,74,
		176,100,0,106,8,99,84,105,112,82,101,99,0,12,
		1,119,1,12,1,31,21,106,15,114,101,99,116,105,
		102,105,99,97,116,105,118,97,32,0,25,5,106,1,
		0,72,95,3,85,48,21,0,102,112,0,74,176,100,
		0,106,7,99,83,101,114,105,101,0,12,1,119,1,
		72,106,2,47,0,72,176,113,0,176,23,0,95,3,
		85,48,21,0,102,112,0,74,176,100,0,106,8,110,
		78,117,109,70,97,99,0,12,1,119,1,12,1,12,
		1,72,106,2,47,0,72,95,3,85,48,21,0,102,
		112,0,74,176,100,0,106,8,99,83,117,102,70,97,
		99,0,12,1,119,1,72,48,21,0,102,112,0,77,
		114,0,36,13,1,176,115,0,95,5,48,72,0,176,
		58,0,12,0,48,39,0,102,112,0,112,1,12,2,
		48,21,0,102,112,0,77,116,0,36,14,1,106,1,
		0,48,21,0,102,112,0,77,117,0,36,15,1,9,
		48,21,0,102,112,0,77,118,0,36,16,1,95,3,
		85,48,21,0,102,112,0,74,176,100,0,106,8,99,
		68,105,118,80,103,111,0,12,1,119,1,48,21,0,
		102,112,0,77,119,0,36,17,1,95,3,85,48,21,
		0,102,112,0,74,176,100,0,106,8,110,86,100,118,
		80,103,111,0,12,1,119,1,48,21,0,102,112,0,
		77,120,0,36,18,1,95,3,85,48,21,0,102,112,
		0,74,176,100,0,106,8,99,67,111,100,80,103,111,
		0,12,1,119,1,48,21,0,102,112,0,77,121,0,
		36,19,1,9,48,21,0,102,112,0,77,122,0,36,
		20,1,176,123,0,12,0,48,21,0,102,112,0,77,
		81,0,36,21,1,176,124,0,176,68,0,12,0,122,
		92,5,12,3,48,21,0,102,112,0,77,125,0,36,
		23,1,85,48,21,0,102,112,0,74,176,83,0,20,
		0,74,36,25,1,85,48,21,0,102,112,0,74,176,
		90,0,95,2,20,1,74,36,27,1,120,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( RECEIPTINVOICECUSTOMER_FILTERTABLE )
{
	static const HB_BYTE pcode[] =
	{
		13,0,1,36,34,1,95,1,106,17,84,111,100,111,
		115,32,100,101,108,101,103,97,99,105,243,110,0,8,
		28,60,36,36,1,85,48,21,0,102,112,0,74,176,
		126,0,106,20,70,105,101,108,100,45,62,99,83,117,
		102,70,97,99,32,61,61,32,39,0,48,127,0,176,
		128,0,12,0,112,0,72,106,2,39,0,72,20,1,
		74,26,117,1,36,38,1,95,1,106,22,80,101,110,
		100,105,101,110,116,101,115,32,100,101,108,101,103,97,
		99,105,243,110,0,8,28,83,36,40,1,85,48,21,
		0,102,112,0,74,176,126,0,106,43,33,70,105,101,
		108,100,45,62,108,67,111,98,114,97,100,111,32,46,
		97,110,100,46,32,70,105,101,108,100,45,62,99,83,
		117,102,70,97,99,32,61,61,32,39,0,48,127,0,
		176,128,0,12,0,112,0,72,106,2,39,0,72,20,
		1,74,26,4,1,36,42,1,95,1,106,20,67,111,
		98,114,97,100,111,115,32,100,101,108,101,103,97,99,
		105,243,110,0,8,28,81,36,44,1,85,48,21,0,
		102,112,0,74,176,126,0,106,41,70,105,101,108,100,
		45,62,108,67,111,98,114,97,100,111,32,46,97,110,
		100,46,32,70,105,101,108,100,45,62,99,83,117,102,
		70,97,99,32,61,32,39,0,48,127,0,176,128,0,
		12,0,112,0,72,106,2,39,0,72,20,1,74,26,
		151,0,36,46,1,95,1,106,11,80,101,110,100,105,
		101,110,116,101,115,0,8,28,40,36,48,1,85,48,
		21,0,102,112,0,74,176,126,0,106,17,33,70,105,
		101,108,100,45,62,108,67,111,98,114,97,100,111,0,
		20,1,74,25,91,36,50,1,95,1,106,9,67,111,
		98,114,97,100,111,115,0,8,28,39,36,52,1,85,
		48,21,0,102,112,0,74,176,126,0,106,16,70,105,
		101,108,100,45,62,108,67,111,98,114,97,100,111,0,
		20,1,74,25,35,36,54,1,95,1,106,6,84,111,
		100,111,115,0,8,28,19,36,56,1,85,48,21,0,
		102,112,0,74,176,129,0,20,0,74,36,60,1,85,
		48,21,0,102,112,0,74,176,130,0,20,0,74,36,
		62,1,48,131,0,48,132,0,48,46,0,102,112,0,
		112,0,112,0,73,36,63,1,48,133,0,48,132,0,
		48,46,0,102,112,0,112,0,112,0,73,36,65,1,
		120,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( RECEIPTINVOICECUSTOMER_ONPRERUNNAVIGATOR )
{
	static const HB_BYTE pcode[] =
	{
		36,71,1,176,35,0,48,134,0,102,112,0,12,1,
		28,8,36,72,1,120,110,7,36,75,1,176,35,0,
		48,135,0,102,112,0,12,1,31,43,36,77,1,85,
		48,72,0,176,58,0,12,0,48,39,0,102,112,0,
		112,1,74,176,78,0,48,135,0,102,112,0,12,1,
		119,31,8,36,78,1,9,110,7,36,83,1,85,48,
		134,0,102,112,0,74,176,74,0,106,8,100,70,101,
		99,68,101,115,0,20,1,74,36,84,1,85,48,134,
		0,102,112,0,74,176,130,0,20,0,74,36,86,1,
		176,35,0,48,135,0,102,112,0,12,1,31,113,36,
		88,1,85,48,134,0,102,112,0,74,176,126,0,106,
		60,70,105,101,108,100,45,62,99,83,101,114,105,101,
		32,43,32,83,116,114,40,32,70,105,101,108,100,45,
		62,110,78,117,109,70,97,99,32,41,32,43,32,70,
		105,101,108,100,45,62,99,83,117,102,70,97,99,32,
		61,61,32,39,0,48,135,0,102,112,0,72,106,2,
		39,0,72,20,1,74,36,89,1,85,48,134,0,102,
		112,0,74,176,130,0,20,0,74,26,201,0,36,93,
		1,48,136,0,176,137,0,12,0,112,0,29,185,0,
		176,35,0,48,138,0,176,137,0,12,0,112,0,12,
		1,32,167,0,36,95,1,85,48,134,0,102,112,0,
		74,176,126,0,106,20,70,105,101,108,100,45,62,99,
		67,111,100,65,103,101,32,61,61,32,39,0,48,138,
		0,176,137,0,12,0,112,0,72,106,2,39,0,72,
		20,1,74,36,96,1,85,48,134,0,102,112,0,74,
		176,130,0,20,0,74,36,98,1,85,48,139,0,176,
		58,0,12,0,48,39,0,102,112,0,112,1,74,176,
		126,0,106,20,70,105,101,108,100,45,62,99,67,111,
		100,65,103,101,32,61,61,32,39,0,48,138,0,176,
		137,0,12,0,112,0,72,106,2,39,0,72,20,1,
		74,36,99,1,85,48,139,0,176,58,0,12,0,48,
		39,0,102,112,0,112,1,74,176,130,0,20,0,74,
		36,105,1,120,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_INITSTATICS()
{
	static const HB_BYTE pcode[] =
	{
		117,142,0,2,0,116,142,0,4,0,0,82,1,0,
		7
	};

	hb_vmExecute( pcode, symbols );
}

