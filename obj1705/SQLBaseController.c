/*
 * Harbour 3.2.0dev (r1307082134)
 * Borland C++ 5.8.2 (32-bit)
 * Generated C source from ".\Prg\Controllers\SQLBaseController.prg"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC( SQLBASECONTROLLER );
HB_FUNC_EXTERN( __CLSLOCKDEF );
HB_FUNC_EXTERN( HBCLASS );
HB_FUNC_EXTERN( HBOBJECT );
HB_FUNC_STATIC( SQLBASECONTROLLER_NEW );
HB_FUNC_EXTERN( EMPTY );
HB_FUNC_STATIC( SQLBASECONTROLLER_END );
HB_FUNC_STATIC( SQLBASECONTROLLER_GETMODELBUFFER );
HB_FUNC_STATIC( SQLBASECONTROLLER_ACTIVATENAVIGATORVIEW );
HB_FUNC_STATIC( SQLBASECONTROLLER_ACTIVATESELECTORVIEW );
HB_FUNC_EXTERN( NAND );
HB_FUNC_STATIC( SQLBASECONTROLLER_APPEND );
HB_FUNC_STATIC( SQLBASECONTROLLER_DUPLICATE );
HB_FUNC_STATIC( SQLBASECONTROLLER_EDIT );
HB_FUNC_STATIC( SQLBASECONTROLLER_ZOOM );
HB_FUNC_STATIC( SQLBASECONTROLLER_DELETE );
HB_FUNC_STATIC( SQLBASECONTROLLER_CHANGEMODELORDERANDORIENTATION );
HB_FUNC_STATIC( SQLBASECONTROLLER_STARTBROWSE );
HB_FUNC_STATIC( SQLBASECONTROLLER_RESTOREBROWSESTATE );
HB_FUNC_STATIC( SQLBASECONTROLLER_GETROWSET );
HB_FUNC_EXTERN( GETSQLDATABASE );
HB_FUNC_STATIC( SQLBASECONTROLLER_SETFASTREPORT );
HB_FUNC_STATIC( SQLBASECONTROLLER_ADDFASTKEY );
HB_FUNC_STATIC( SQLBASECONTROLLER_ONKEYCHAR );
HB_FUNC_EXTERN( __CLSUNLOCKDEF );
HB_FUNC_EXTERN( __OBJHASMSG );
HB_FUNC_EXTERN( EVENTS );
HB_FUNC_EXTERN( CONTROLLERCONTAINER );
HB_FUNC_EXTERN( SQLNAVIGATORVIEW );
HB_FUNC_EXTERN( SQLSELECTORVIEW );
HB_FUNC_EXTERN( MSGSTOP );
HB_FUNC_EXTERN( OWND );
HB_FUNC_EXTERN( SYSREFRESH );
HB_FUNC_EXTERN( HB_ISARRAY );
HB_FUNC_EXTERN( LEN );
HB_FUNC_EXTERN( ALLTRIM );
HB_FUNC_EXTERN( STR );
HB_FUNC_EXTERN( OUSER );
HB_FUNC_EXTERN( MSGNOYES );
HB_FUNC_EXTERN( HHASKEY );
HB_FUNC_EXTERN( HGET );
HB_FUNC_EXTERN( HB_ISCHAR );
HB_FUNC_EXTERN( HSET );
HB_FUNC_EXTERN( ASC );
HB_FUNC_EXTERN( UPPER );
HB_FUNC_EXTERN( LOWER );
HB_FUNC_EXTERN( HB_ISNUMERIC );
HB_FUNC_EXTERN( HEVAL );
HB_FUNC_EXTERN( FW_GT );
HB_FUNC_EXTERN( ERRORSYS );
HB_FUNC_INITSTATICS();


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_SQLBASECONTROLLER )
{ "SQLBASECONTROLLER", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( SQLBASECONTROLLER )}, NULL },
{ "__CLSLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSLOCKDEF )}, NULL },
{ "NEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBCLASS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBCLASS )}, NULL },
{ "HBOBJECT", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBOBJECT )}, NULL },
{ "ADDMULTICLSDATA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDMULTIDATA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDMETHOD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SQLBASECONTROLLER_NEW", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLBASECONTROLLER_NEW )}, NULL },
{ "ADDINLINE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EMPTY", {HB_FS_PUBLIC}, {HB_FUNCNAME( EMPTY )}, NULL },
{ "OINSTANCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_OINSTANCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SQLBASECONTROLLER_END", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLBASECONTROLLER_END )}, NULL },
{ "OMODEL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CCOLUMNKEY", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CTABLENAME", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HCOLUMNS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HEXTRACOLUMNS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SQLBASECONTROLLER_GETMODELBUFFER", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLBASECONTROLLER_GETMODELBUFFER )}, NULL },
{ "GETMODELBUFFER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SELECTVALUE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "END", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OSENDERCONTROLLER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ODIALOGVIEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OREPOSITORY", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GET", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CONTROLLERCONTAINER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OVALIDATOR", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "VALIDATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ASSERT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SQLBASECONTROLLER_ACTIVATENAVIGATORVIEW", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLBASECONTROLLER_ACTIVATENAVIGATORVIEW )}, NULL },
{ "SQLBASECONTROLLER_ACTIVATESELECTORVIEW", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLBASECONTROLLER_ACTIVATESELECTORVIEW )}, NULL },
{ "NAND", {HB_FS_PUBLIC}, {HB_FUNCNAME( NAND )}, NULL },
{ "NLEVEL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ISUSERACCESS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ISUSERAPPEND", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ISUSERDUPLICATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ISUSEREDIT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ISUSERDELETE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ISUSERZOOM", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NMODE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NMODE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CTITLE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CTITLE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SQLBASECONTROLLER_APPEND", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLBASECONTROLLER_APPEND )}, NULL },
{ "SETMODE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SQLBASECONTROLLER_DUPLICATE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLBASECONTROLLER_DUPLICATE )}, NULL },
{ "SQLBASECONTROLLER_EDIT", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLBASECONTROLLER_EDIT )}, NULL },
{ "SQLBASECONTROLLER_ZOOM", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLBASECONTROLLER_ZOOM )}, NULL },
{ "SQLBASECONTROLLER_DELETE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLBASECONTROLLER_DELETE )}, NULL },
{ "GETROWSET", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FIELDGET", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SQLBASECONTROLLER_CHANGEMODELORDERANDORIENTATION", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLBASECONTROLLER_CHANGEMODELORDERANDORIENTATION )}, NULL },
{ "FIND", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SQLBASECONTROLLER_STARTBROWSE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLBASECONTROLLER_STARTBROWSE )}, NULL },
{ "SQLBASECONTROLLER_RESTOREBROWSESTATE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLBASECONTROLLER_RESTOREBROWSESTATE )}, NULL },
{ "SQLBASECONTROLLER_GETROWSET", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLBASECONTROLLER_GETROWSET )}, NULL },
{ "LTRANSACTIONAL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BEGINTRANSACTION", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETSQLDATABASE", {HB_FS_PUBLIC}, {HB_FUNCNAME( GETSQLDATABASE )}, NULL },
{ "COMMIT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ROLLBACK", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SQLBASECONTROLLER_SETFASTREPORT", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLBASECONTROLLER_SETFASTREPORT )}, NULL },
{ "SQLBASECONTROLLER_ADDFASTKEY", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLBASECONTROLLER_ADDFASTKEY )}, NULL },
{ "SQLBASECONTROLLER_ONKEYCHAR", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLBASECONTROLLER_ONKEYCHAR )}, NULL },
{ "OEVENTS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SET", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FIRE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CREATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__CLSUNLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSUNLOCKDEF )}, NULL },
{ "INSTANCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__OBJHASMSG", {HB_FS_PUBLIC}, {HB_FUNCNAME( __OBJHASMSG )}, NULL },
{ "INITCLASS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_OSENDERCONTROLLER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_OEVENTS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EVENTS", {HB_FS_PUBLIC}, {HB_FUNCNAME( EVENTS )}, NULL },
{ "_CONTROLLERCONTAINER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CONTROLLERCONTAINER", {HB_FS_PUBLIC}, {HB_FUNCNAME( CONTROLLERCONTAINER )}, NULL },
{ "_ONAVIGATORVIEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SQLNAVIGATORVIEW", {HB_FS_PUBLIC}, {HB_FUNCNAME( SQLNAVIGATORVIEW )}, NULL },
{ "_OSELECTORVIEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SQLSELECTORVIEW", {HB_FS_PUBLIC}, {HB_FUNCNAME( SQLSELECTORVIEW )}, NULL },
{ "ENDMODEL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ONAVIGATORVIEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NOTUSERACCESS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "MSGSTOP", {HB_FS_PUBLIC}, {HB_FUNCNAME( MSGSTOP )}, NULL },
{ "OWND", {HB_FS_PUBLIC}, {HB_FUNCNAME( OWND )}, NULL },
{ "SYSREFRESH", {HB_FS_PUBLIC}, {HB_FUNCNAME( SYSREFRESH )}, NULL },
{ "CLOSEALL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BUILDROWSET", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ACTIVATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OSELECTORVIEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETOBROWSE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETITEMS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETCOLUMNHEADERS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "RESTOREBROWSESTATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETCOLUMNORDER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CCOLUMNORDER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CHEADER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SELECTCOLUMNORDER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CORIENTATION", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETBROWSESTATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "RESTORESTATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SAVEIDTOFIND", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETCOLUMNORDER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETCOLUMNORIENTATION", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BUILDROWSETANDFIND", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NOTUSERAPPEND", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FIREEVENT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETAPPENDMODE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BEGINTRANSACTIONALMODE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETROWSETRECNO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LOADBLANKBUFFER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DIALOG", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "INSERTBUFFER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "COMMITTRANSACTIONALMODE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETROWSETRECNO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ROLLBACKTRANSACTIONALMODE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NOTUSERDUPLICATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETDUPLICATEMODE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LOADDUPLICATEBUFFER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NOTUSEREDIT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETEDITMODE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETIDTOFIND", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETIDFROMROWSET", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LOADCURRENTBUFFER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "UPDATECURRENTBUFFER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NOTUSERZOOM", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETZOOMMODE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NOTUSERDELETE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HB_ISARRAY", {HB_FS_PUBLIC}, {HB_FUNCNAME( HB_ISARRAY )}, NULL },
{ "LEN", {HB_FS_PUBLIC}, {HB_FUNCNAME( LEN )}, NULL },
{ "ALLTRIM", {HB_FS_PUBLIC}, {HB_FUNCNAME( ALLTRIM )}, NULL },
{ "STR", {HB_FS_PUBLIC}, {HB_FUNCNAME( STR )}, NULL },
{ "LNOTCONFIRMDELETE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OUSER", {HB_FS_PUBLIC}, {HB_FUNCNAME( OUSER )}, NULL },
{ "MSGNOYES", {HB_FS_PUBLIC}, {HB_FUNCNAME( MSGNOYES )}, NULL },
{ "DELETESELECTION", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBUFFER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HHASKEY", {HB_FS_PUBLIC}, {HB_FUNCNAME( HHASKEY )}, NULL },
{ "HGET", {HB_FS_PUBLIC}, {HB_FUNCNAME( HGET )}, NULL },
{ "OROWSET", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HB_ISCHAR", {HB_FS_PUBLIC}, {HB_FUNCNAME( HB_ISCHAR )}, NULL },
{ "HSET", {HB_FS_PUBLIC}, {HB_FUNCNAME( HSET )}, NULL },
{ "HFASTKEY", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ASC", {HB_FS_PUBLIC}, {HB_FUNCNAME( ASC )}, NULL },
{ "UPPER", {HB_FS_PUBLIC}, {HB_FUNCNAME( UPPER )}, NULL },
{ "LOWER", {HB_FS_PUBLIC}, {HB_FUNCNAME( LOWER )}, NULL },
{ "HB_ISNUMERIC", {HB_FS_PUBLIC}, {HB_FUNCNAME( HB_ISNUMERIC )}, NULL },
{ "HEVAL", {HB_FS_PUBLIC}, {HB_FUNCNAME( HEVAL )}, NULL },
{ "EVAL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SERIALIZECOLUMNS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETUSERDATASET", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETTITLE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GOTOP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SKIP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EOF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FW_GT", {HB_FS_PUBLIC}, {HB_FUNCNAME( FW_GT )}, NULL },
{ "ERRORSYS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORSYS )}, NULL },
{ "(_INITSTATICS00002)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITSTATICS}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_SQLBASECONTROLLER, ".\\Prg\\Controllers\\SQLBaseController.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_SQLBASECONTROLLER
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_SQLBASECONTROLLER )
   #include "hbiniseg.h"
#endif

HB_FUNC( SQLBASECONTROLLER )
{
	static const HB_BYTE pcode[] =
	{
		149,3,0,116,160,0,36,6,0,103,2,0,100,8,
		29,0,17,176,1,0,104,2,0,12,1,29,245,16,
		166,183,16,0,122,80,1,48,2,0,176,3,0,12,
		0,106,18,83,81,76,66,97,115,101,67,111,110,116,
		114,111,108,108,101,114,0,108,4,4,1,0,108,0,
		112,3,80,2,36,8,0,48,5,0,95,2,100,100,
		95,1,121,72,92,32,72,121,72,121,72,106,10,111,
		73,110,115,116,97,110,99,101,0,4,1,0,9,112,
		5,73,36,10,0,48,6,0,95,2,100,100,95,1,
		121,72,121,72,121,72,106,18,111,83,101,110,100,101,
		114,67,111,110,116,114,111,108,108,101,114,0,4,1,
		0,9,112,5,73,36,12,0,48,6,0,95,2,100,
		100,95,1,121,72,121,72,121,72,106,20,67,111,110,
		116,114,111,108,108,101,114,67,111,110,116,97,105,110,
		101,114,0,4,1,0,9,112,5,73,36,14,0,48,
		6,0,95,2,100,100,95,1,121,72,121,72,121,72,
		106,8,111,69,118,101,110,116,115,0,4,1,0,9,
		112,5,73,36,16,0,48,6,0,95,2,100,100,95,
		1,121,72,121,72,121,72,106,7,111,77,111,100,101,
		108,0,4,1,0,9,112,5,73,36,18,0,48,6,
		0,95,2,100,100,95,1,121,72,121,72,121,72,106,
		14,111,83,101,108,101,99,116,111,114,86,105,101,119,
		0,4,1,0,9,112,5,73,36,20,0,48,6,0,
		95,2,100,100,95,1,121,72,121,72,121,72,106,15,
		111,78,97,118,105,103,97,116,111,114,86,105,101,119,
		0,4,1,0,9,112,5,73,36,22,0,48,6,0,
		95,2,100,100,95,1,121,72,121,72,121,72,106,12,
		111,68,105,97,108,111,103,86,105,101,119,0,4,1,
		0,9,112,5,73,36,24,0,48,6,0,95,2,100,
		100,95,1,121,72,121,72,121,72,106,11,111,86,97,
		108,105,100,97,116,111,114,0,4,1,0,9,112,5,
		73,36,26,0,48,6,0,95,2,100,100,95,1,121,
		72,121,72,121,72,106,12,111,82,101,112,111,115,105,
		116,111,114,121,0,4,1,0,9,112,5,73,36,28,
		0,48,6,0,95,2,100,9,95,1,121,72,121,72,
		121,72,106,15,108,84,114,97,110,115,97,99,116,105,
		111,110,97,108,0,4,1,0,9,112,5,73,36,30,
		0,48,6,0,95,2,100,100,95,1,121,72,121,72,
		121,72,106,7,110,76,101,118,101,108,0,4,1,0,
		9,112,5,73,36,32,0,48,6,0,95,2,106,8,
		78,85,77,69,82,73,67,0,100,95,1,121,72,121,
		72,121,72,106,6,110,77,111,100,101,0,4,1,0,
		9,112,5,73,36,34,0,48,6,0,95,2,100,100,
		95,1,121,72,121,72,121,72,106,13,98,79,110,80,
		114,101,65,112,112,101,110,100,0,4,1,0,9,112,
		5,73,36,35,0,48,6,0,95,2,100,100,95,1,
		121,72,121,72,121,72,106,14,98,79,110,80,111,115,
		116,65,112,112,101,110,100,0,4,1,0,9,112,5,
		73,36,37,0,48,6,0,95,2,100,106,1,0,95,
		1,121,72,121,72,121,72,106,7,99,84,105,116,108,
		101,0,4,1,0,9,112,5,73,36,39,0,48,6,
		0,95,2,100,106,1,0,95,1,121,72,121,72,121,
		72,106,7,99,73,109,97,103,101,0,4,1,0,9,
		112,5,73,36,41,0,48,7,0,95,2,106,4,78,
		101,119,0,108,8,95,1,121,72,121,72,121,72,112,
		3,73,36,42,0,48,9,0,95,2,106,9,73,110,
		115,116,97,110,99,101,0,89,44,0,1,0,0,0,
		176,10,0,48,11,0,95,1,112,0,12,1,28,17,
		48,12,0,95,1,48,2,0,95,1,112,0,112,1,
		73,48,11,0,95,1,112,0,6,95,1,121,72,121,
		72,121,72,112,3,73,36,43,0,48,7,0,95,2,
		106,4,69,110,100,0,108,13,95,1,121,72,121,72,
		121,72,112,3,73,36,47,0,48,9,0,95,2,106,
		9,103,101,116,77,111,100,101,108,0,89,15,0,1,
		0,0,0,48,14,0,95,1,112,0,6,95,1,121,
		72,121,72,121,72,112,3,73,36,48,0,48,9,0,
		95,2,106,18,103,101,116,77,111,100,101,108,67,111,
		108,117,109,110,75,101,121,0,89,37,0,1,0,0,
		0,176,10,0,48,14,0,95,1,112,0,12,1,31,
		16,48,15,0,48,14,0,95,1,112,0,112,0,25,
		3,100,6,95,1,121,72,121,72,121,72,112,3,73,
		36,49,0,48,9,0,95,2,106,18,103,101,116,77,
		111,100,101,108,84,97,98,108,101,78,97,109,101,0,
		89,37,0,1,0,0,0,176,10,0,48,14,0,95,
		1,112,0,12,1,31,16,48,16,0,48,14,0,95,
		1,112,0,112,0,25,3,100,6,95,1,121,72,121,
		72,121,72,112,3,73,36,50,0,48,9,0,95,2,
		106,16,103,101,116,77,111,100,101,108,67,111,108,117,
		109,110,115,0,89,56,0,1,0,0,0,176,10,0,
		48,14,0,95,1,112,0,12,1,31,35,176,10,0,
		48,17,0,48,14,0,95,1,112,0,112,0,12,1,
		31,16,48,17,0,48,14,0,95,1,112,0,112,0,
		25,3,100,6,95,1,121,72,121,72,121,72,112,3,
		73,36,51,0,48,9,0,95,2,106,21,103,101,116,
		77,111,100,101,108,69,120,116,114,97,67,111,108,117,
		109,110,115,0,89,56,0,1,0,0,0,176,10,0,
		48,14,0,95,1,112,0,12,1,31,35,176,10,0,
		48,18,0,48,14,0,95,1,112,0,112,0,12,1,
		31,16,48,18,0,48,14,0,95,1,112,0,112,0,
		25,3,100,6,95,1,121,72,121,72,121,72,112,3,
		73,36,53,0,48,7,0,95,2,106,15,103,101,116,
		77,111,100,101,108,66,117,102,102,101,114,0,108,19,
		95,1,121,72,121,72,121,72,112,3,73,36,54,0,
		48,9,0,95,2,106,24,103,101,116,77,111,100,101,
		108,66,117,102,102,101,114,67,111,108,117,109,110,75,
		101,121,0,89,27,0,1,0,0,0,48,20,0,95,
		1,48,15,0,48,14,0,95,1,112,0,112,0,112,
		1,6,95,1,121,72,121,72,121,72,112,3,73,36,
		56,0,48,9,0,95,2,106,20,103,101,116,77,111,
		100,101,108,83,101,108,101,99,116,86,97,108,117,101,
		0,89,39,0,2,0,0,0,176,10,0,48,14,0,
		95,1,112,0,12,1,31,18,48,21,0,48,14,0,
		95,1,112,0,95,2,112,1,25,3,100,6,95,1,
		121,72,121,72,121,72,112,3,73,36,58,0,48,9,
		0,95,2,106,9,101,110,100,77,111,100,101,108,0,
		89,37,0,1,0,0,0,176,10,0,48,14,0,95,
		1,112,0,12,1,31,16,48,22,0,48,14,0,95,
		1,112,0,112,0,25,3,100,6,95,1,121,72,121,
		72,121,72,112,3,73,36,60,0,48,9,0,95,2,
		106,20,103,101,116,83,101,110,100,101,114,67,111,110,
		116,114,111,108,108,101,114,0,89,15,0,1,0,0,
		0,48,23,0,95,1,112,0,6,95,1,121,72,121,
		72,121,72,112,3,73,36,62,0,48,9,0,95,2,
		106,14,103,101,116,68,105,97,108,111,103,86,105,101,
		119,0,89,15,0,1,0,0,0,48,24,0,95,1,
		112,0,6,95,1,121,72,121,72,121,72,112,3,73,
		36,64,0,48,9,0,95,2,106,14,103,101,116,82,
		101,112,111,115,105,116,111,114,121,0,89,15,0,1,
		0,0,0,48,25,0,95,1,112,0,6,95,1,121,
		72,121,72,121,72,112,3,73,36,66,0,48,9,0,
		95,2,106,13,103,101,116,67,111,110,116,97,105,110,
		101,114,0,89,22,0,2,0,0,0,48,26,0,48,
		27,0,95,1,112,0,95,2,112,1,6,95,1,121,
		72,121,72,121,72,112,3,73,36,68,0,48,9,0,
		95,2,106,9,86,97,108,105,100,97,116,101,0,89,
		39,0,2,0,0,0,176,10,0,48,28,0,95,1,
		112,0,12,1,31,18,48,29,0,48,28,0,95,1,
		112,0,95,2,112,1,25,3,100,6,95,1,121,72,
		121,72,121,72,112,3,73,36,69,0,48,9,0,95,
		2,106,7,65,115,115,101,114,116,0,89,41,0,3,
		0,0,0,176,10,0,48,28,0,95,1,112,0,12,
		1,31,20,48,30,0,48,28,0,95,1,112,0,95,
		2,95,3,112,2,25,3,100,6,95,1,121,72,121,
		72,121,72,112,3,73,36,73,0,48,7,0,95,2,
		106,22,65,99,116,105,118,97,116,101,78,97,118,105,
		103,97,116,111,114,86,105,101,119,0,108,31,95,1,
		121,72,121,72,121,72,112,3,73,36,74,0,48,7,
		0,95,2,106,21,65,99,116,105,118,97,116,101,83,
		101,108,101,99,116,111,114,86,105,101,119,0,108,32,
		95,1,121,72,121,72,121,72,112,3,73,36,76,0,
		48,9,0,95,2,106,13,105,115,85,115,101,114,65,
		99,99,101,115,115,0,89,23,0,1,0,0,0,176,
		33,0,48,34,0,95,1,112,0,122,12,2,121,8,
		6,95,1,121,72,121,72,121,72,112,3,73,36,77,
		0,48,9,0,95,2,106,14,110,111,116,85,115,101,
		114,65,99,99,101,115,115,0,89,16,0,1,0,0,
		0,48,35,0,95,1,112,0,68,6,95,1,121,72,
		121,72,121,72,112,3,73,36,78,0,48,9,0,95,
		2,106,13,105,115,85,115,101,114,65,112,112,101,110,
		100,0,89,24,0,1,0,0,0,176,33,0,48,34,
		0,95,1,112,0,92,2,12,2,121,69,6,95,1,
		121,72,121,72,121,72,112,3,73,36,79,0,48,9,
		0,95,2,106,14,110,111,116,85,115,101,114,65,112,
		112,101,110,100,0,89,16,0,1,0,0,0,48,36,
		0,95,1,112,0,68,6,95,1,121,72,121,72,121,
		72,112,3,73,36,80,0,48,9,0,95,2,106,16,
		105,115,85,115,101,114,68,117,112,108,105,99,97,116,
		101,0,89,24,0,1,0,0,0,176,33,0,48,34,
		0,95,1,112,0,92,2,12,2,121,69,6,95,1,
		121,72,121,72,121,72,112,3,73,36,81,0,48,9,
		0,95,2,106,17,110,111,116,85,115,101,114,68,117,
		112,108,105,99,97,116,101,0,89,16,0,1,0,0,
		0,48,37,0,95,1,112,0,68,6,95,1,121,72,
		121,72,121,72,112,3,73,36,82,0,48,9,0,95,
		2,106,11,105,115,85,115,101,114,69,100,105,116,0,
		89,24,0,1,0,0,0,176,33,0,48,34,0,95,
		1,112,0,92,4,12,2,121,69,6,95,1,121,72,
		121,72,121,72,112,3,73,36,83,0,48,9,0,95,
		2,106,12,110,111,116,85,115,101,114,69,100,105,116,
		0,89,16,0,1,0,0,0,48,38,0,95,1,112,
		0,68,6,95,1,121,72,121,72,121,72,112,3,73,
		36,84,0,48,9,0,95,2,106,13,105,115,85,115,
		101,114,68,101,108,101,116,101,0,89,24,0,1,0,
		0,0,176,33,0,48,34,0,95,1,112,0,92,16,
		12,2,121,69,6,95,1,121,72,121,72,121,72,112,
		3,73,36,85,0,48,9,0,95,2,106,14,110,111,
		116,85,115,101,114,68,101,108,101,116,101,0,89,16,
		0,1,0,0,0,48,39,0,95,1,112,0,68,6,
		95,1,121,72,121,72,121,72,112,3,73,36,86,0,
		48,9,0,95,2,106,11,105,115,85,115,101,114,90,
		111,111,109,0,89,24,0,1,0,0,0,176,33,0,
		48,34,0,95,1,112,0,92,8,12,2,121,69,6,
		95,1,121,72,121,72,121,72,112,3,73,36,87,0,
		48,9,0,95,2,106,12,110,111,116,85,115,101,114,
		90,111,111,109,0,89,16,0,1,0,0,0,48,40,
		0,95,1,112,0,68,6,95,1,121,72,121,72,121,
		72,112,3,73,36,89,0,48,9,0,95,2,106,8,
		115,101,116,77,111,100,101,0,89,17,0,2,0,0,
		0,48,41,0,95,1,95,2,112,1,6,95,1,121,
		72,121,72,121,72,112,3,73,36,90,0,48,9,0,
		95,2,106,8,103,101,116,77,111,100,101,0,89,15,
		0,1,0,0,0,48,42,0,95,1,112,0,6,95,
		1,121,72,121,72,121,72,112,3,73,36,92,0,48,
		9,0,95,2,106,9,115,101,116,84,105,116,108,101,
		0,89,17,0,2,0,0,0,48,43,0,95,1,95,
		2,112,1,6,95,1,121,72,121,72,121,72,112,3,
		73,36,93,0,48,9,0,95,2,106,9,103,101,116,
		84,105,116,108,101,0,89,15,0,1,0,0,0,48,
		44,0,95,1,112,0,6,95,1,121,72,121,72,121,
		72,112,3,73,36,95,0,48,7,0,95,2,106,7,
		65,112,112,101,110,100,0,108,45,95,1,121,72,121,
		72,121,72,112,3,73,36,96,0,48,9,0,95,2,
		106,14,115,101,116,65,112,112,101,110,100,77,111,100,
		101,0,89,16,0,1,0,0,0,48,46,0,95,1,
		122,112,1,6,95,1,121,72,121,72,121,72,112,3,
		73,36,97,0,48,9,0,95,2,106,13,105,115,65,
		112,112,101,110,100,77,111,100,101,0,89,17,0,1,
		0,0,0,48,42,0,95,1,112,0,122,8,6,95,
		1,121,72,121,72,121,72,112,3,73,36,99,0,48,
		7,0,95,2,106,10,68,117,112,108,105,99,97,116,
		101,0,108,47,95,1,121,72,121,72,121,72,112,3,
		73,36,100,0,48,9,0,95,2,106,17,115,101,116,
		68,117,112,108,105,99,97,116,101,77,111,100,101,0,
		89,17,0,1,0,0,0,48,46,0,95,1,92,4,
		112,1,6,95,1,121,72,121,72,121,72,112,3,73,
		36,101,0,48,9,0,95,2,106,16,105,115,68,117,
		112,108,105,99,97,116,101,77,111,100,101,0,89,18,
		0,1,0,0,0,48,42,0,95,1,112,0,92,4,
		8,6,95,1,121,72,121,72,121,72,112,3,73,36,
		103,0,48,7,0,95,2,106,5,69,100,105,116,0,
		108,48,95,1,121,72,121,72,121,72,112,3,73,36,
		104,0,48,9,0,95,2,106,12,115,101,116,69,100,
		105,116,77,111,100,101,0,89,17,0,1,0,0,0,
		48,46,0,95,1,92,2,112,1,6,95,1,121,72,
		121,72,121,72,112,3,73,36,105,0,48,9,0,95,
		2,106,11,105,115,69,100,105,116,77,111,100,101,0,
		89,18,0,1,0,0,0,48,42,0,95,1,112,0,
		92,2,8,6,95,1,121,72,121,72,121,72,112,3,
		73,36,107,0,48,7,0,95,2,106,5,90,111,111,
		109,0,108,49,95,1,121,72,121,72,121,72,112,3,
		73,36,108,0,48,9,0,95,2,106,12,115,101,116,
		90,111,111,109,77,111,100,101,0,89,17,0,1,0,
		0,0,48,46,0,95,1,92,3,112,1,6,95,1,
		121,72,121,72,121,72,112,3,73,36,109,0,48,9,
		0,95,2,106,11,105,115,90,111,111,109,77,111,100,
		101,0,89,18,0,1,0,0,0,48,42,0,95,1,
		112,0,92,3,8,6,95,1,121,72,121,72,121,72,
		112,3,73,36,110,0,48,9,0,95,2,106,14,105,
		115,78,111,116,90,111,111,109,77,111,100,101,0,89,
		18,0,1,0,0,0,48,42,0,95,1,112,0,92,
		3,69,6,95,1,121,72,121,72,121,72,112,3,73,
		36,112,0,48,7,0,95,2,106,7,68,101,108,101,
		116,101,0,108,50,95,1,121,72,121,72,121,72,112,
		3,73,36,114,0,48,9,0,95,2,106,16,103,101,
		116,73,100,70,114,111,109,82,111,119,83,101,116,0,
		89,49,0,1,0,0,0,176,10,0,48,51,0,95,
		1,112,0,12,1,31,28,48,52,0,48,51,0,95,
		1,112,0,48,15,0,48,14,0,95,1,112,0,112,
		0,112,1,25,3,100,6,95,1,121,72,121,72,121,
		72,112,3,73,36,116,0,48,7,0,95,2,106,31,
		99,104,97,110,103,101,77,111,100,101,108,79,114,100,
		101,114,65,110,100,79,114,105,101,110,116,97,116,105,
		111,110,0,108,53,95,1,121,72,121,72,121,72,112,
		3,73,36,118,0,48,9,0,95,2,106,5,102,105,
		110,100,0,89,24,0,3,0,0,0,48,54,0,48,
		14,0,95,1,112,0,95,2,95,3,112,2,6,95,
		1,121,72,121,72,121,72,112,3,73,36,119,0,48,
		9,0,95,2,106,17,102,105,110,100,66,121,73,100,
		73,110,82,111,119,83,101,116,0,89,45,0,2,0,
		0,0,176,10,0,48,51,0,95,1,112,0,12,1,
		31,24,48,54,0,48,51,0,95,1,112,0,95,2,
		106,3,105,100,0,120,112,3,25,3,100,6,95,1,
		121,72,121,72,121,72,112,3,73,36,121,0,48,7,
		0,95,2,106,12,115,116,97,114,116,66,114,111,119,
		115,101,0,108,55,95,1,121,72,121,72,121,72,112,
		3,73,36,122,0,48,7,0,95,2,106,19,114,101,
		115,116,111,114,101,66,114,111,119,115,101,83,116,97,
		116,101,0,108,56,95,1,121,72,121,72,121,72,112,
		3,73,36,124,0,48,7,0,95,2,106,10,103,101,
		116,82,111,119,83,101,116,0,108,57,95,1,121,72,
		121,72,121,72,112,3,73,36,128,0,48,9,0,95,
		2,106,23,98,101,103,105,110,84,114,97,110,115,97,
		99,116,105,111,110,97,108,77,111,100,101,0,89,30,
		0,1,0,0,0,48,58,0,95,1,112,0,28,14,
		48,59,0,176,60,0,12,0,112,0,25,3,100,6,
		95,1,121,72,121,72,121,72,112,3,73,36,129,0,
		48,9,0,95,2,106,24,99,111,109,109,105,116,84,
		114,97,110,115,97,99,116,105,111,110,97,108,77,111,
		100,101,0,89,30,0,1,0,0,0,48,58,0,95,
		1,112,0,28,14,48,61,0,176,60,0,12,0,112,
		0,25,3,100,6,95,1,121,72,121,72,121,72,112,
		3,73,36,130,0,48,9,0,95,2,106,26,114,111,
		108,108,98,97,99,107,84,114,97,110,115,97,99,116,
		105,111,110,97,108,77,111,100,101,0,89,30,0,1,
		0,0,0,48,58,0,95,1,112,0,28,14,48,62,
		0,176,60,0,12,0,112,0,25,3,100,6,95,1,
		121,72,121,72,121,72,112,3,73,36,132,0,48,7,
		0,95,2,106,14,115,101,116,70,97,115,116,82,101,
		112,111,114,116,0,108,63,95,1,121,72,121,72,121,
		72,112,3,73,36,136,0,48,6,0,95,2,100,177,
		0,0,95,1,121,72,121,72,121,72,106,9,104,70,
		97,115,116,75,101,121,0,4,1,0,9,112,5,73,
		36,138,0,48,7,0,95,2,106,11,97,100,100,70,
		97,115,116,75,101,121,0,108,64,95,1,121,72,121,
		72,121,72,112,3,73,36,139,0,48,7,0,95,2,
		106,10,111,110,75,101,121,67,104,97,114,0,108,65,
		95,1,121,72,121,72,121,72,112,3,73,36,143,0,
		48,9,0,95,2,106,9,115,101,116,69,118,101,110,
		116,0,89,41,0,3,0,0,0,176,10,0,48,66,
		0,95,1,112,0,12,1,31,20,48,67,0,48,66,
		0,95,1,112,0,95,2,95,3,112,2,25,3,100,
		6,95,1,121,72,121,72,121,72,112,3,73,36,144,
		0,48,9,0,95,2,106,10,102,105,114,101,69,118,
		101,110,116,0,89,39,0,2,0,0,0,176,10,0,
		48,66,0,95,1,112,0,12,1,31,18,48,68,0,
		48,66,0,95,1,112,0,95,2,112,1,25,3,100,
		6,95,1,121,72,121,72,121,72,112,3,73,36,148,
		0,48,69,0,95,2,112,0,73,167,14,0,0,176,
		70,0,104,2,0,95,2,20,2,168,48,71,0,95,
		2,112,0,80,3,176,72,0,95,3,106,10,73,110,
		105,116,67,108,97,115,115,0,12,2,28,12,48,73,
		0,95,3,164,146,1,0,73,95,3,110,7,48,71,
		0,103,2,0,112,0,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLBASECONTROLLER_NEW )
{
	static const HB_BYTE pcode[] =
	{
		13,0,1,36,154,0,48,74,0,102,95,1,112,1,
		73,36,156,0,48,75,0,102,48,2,0,176,76,0,
		12,0,112,0,112,1,73,36,158,0,48,77,0,102,
		48,2,0,176,78,0,12,0,112,0,112,1,73,36,
		160,0,48,79,0,102,48,2,0,176,80,0,12,0,
		102,112,1,112,1,73,36,162,0,48,81,0,102,48,
		2,0,176,82,0,12,0,102,112,1,112,1,73,36,
		164,0,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLBASECONTROLLER_END )
{
	static const HB_BYTE pcode[] =
	{
		36,170,0,48,83,0,102,112,0,73,36,172,0,100,
		110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLBASECONTROLLER_ACTIVATENAVIGATORVIEW )
{
	static const HB_BYTE pcode[] =
	{
		36,178,0,176,10,0,48,84,0,102,112,0,12,1,
		28,8,36,179,0,102,110,7,36,182,0,48,85,0,
		102,112,0,28,39,36,183,0,176,86,0,106,21,65,
		99,99,101,115,111,32,110,111,32,112,101,114,109,105,
		116,105,100,111,46,0,20,1,36,184,0,102,110,7,
		36,187,0,176,87,0,12,0,100,69,28,26,36,188,
		0,176,88,0,20,0,48,89,0,176,87,0,12,0,
		112,0,73,176,88,0,20,0,36,191,0,48,90,0,
		48,14,0,102,112,0,112,0,73,36,193,0,48,91,
		0,48,84,0,102,112,0,112,0,73,36,195,0,102,
		110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLBASECONTROLLER_ACTIVATESELECTORVIEW )
{
	static const HB_BYTE pcode[] =
	{
		36,201,0,176,10,0,48,92,0,102,112,0,12,1,
		28,8,36,202,0,100,110,7,36,205,0,48,85,0,
		102,112,0,28,39,36,206,0,176,86,0,106,21,65,
		99,99,101,115,111,32,110,111,32,112,101,114,109,105,
		116,105,100,111,46,0,20,1,36,207,0,100,110,7,
		36,210,0,48,90,0,48,14,0,102,112,0,112,0,
		73,36,212,0,48,91,0,48,92,0,102,112,0,112,
		0,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLBASECONTROLLER_STARTBROWSE )
{
	static const HB_BYTE pcode[] =
	{
		13,1,1,36,220,0,176,10,0,48,93,0,48,24,
		0,102,112,0,112,0,12,1,28,8,36,221,0,102,
		110,7,36,224,0,176,10,0,95,1,12,1,31,29,
		36,225,0,48,94,0,95,1,48,95,0,48,93,0,
		48,24,0,102,112,0,112,0,112,0,112,1,73,36,
		228,0,48,96,0,102,112,0,73,36,230,0,48,97,
		0,48,93,0,48,24,0,102,112,0,112,0,48,98,
		0,48,14,0,102,112,0,112,0,112,1,80,2,36,
		231,0,176,10,0,95,2,12,1,28,8,36,232,0,
		102,110,7,36,235,0,176,10,0,95,1,12,1,31,
		20,36,236,0,48,67,0,95,1,48,99,0,95,2,
		112,0,112,1,73,36,239,0,48,100,0,48,93,0,
		48,24,0,102,112,0,112,0,95,2,48,101,0,48,
		14,0,102,112,0,112,0,112,2,73,36,241,0,102,
		110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLBASECONTROLLER_RESTOREBROWSESTATE )
{
	static const HB_BYTE pcode[] =
	{
		36,247,0,176,10,0,48,93,0,48,24,0,102,112,
		0,112,0,12,1,28,8,36,248,0,102,110,7,36,
		251,0,176,10,0,48,102,0,48,24,0,102,112,0,
		112,0,12,1,28,8,36,252,0,102,110,7,36,255,
		0,48,103,0,48,93,0,48,24,0,102,112,0,112,
		0,48,102,0,48,24,0,102,112,0,112,0,112,1,
		73,36,1,1,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLBASECONTROLLER_CHANGEMODELORDERANDORIENTATION )
{
	static const HB_BYTE pcode[] =
	{
		13,0,2,36,7,1,48,104,0,48,14,0,102,112,
		0,112,0,73,36,9,1,48,105,0,48,14,0,102,
		112,0,95,1,112,1,73,36,11,1,48,106,0,48,
		14,0,102,112,0,95,2,112,1,73,36,13,1,48,
		107,0,48,14,0,102,112,0,112,0,73,36,15,1,
		102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLBASECONTROLLER_APPEND )
{
	static const HB_BYTE pcode[] =
	{
		13,2,0,36,22,1,120,80,2,36,24,1,48,108,
		0,102,112,0,28,39,36,25,1,176,86,0,106,21,
		65,99,99,101,115,111,32,110,111,32,112,101,114,109,
		105,116,105,100,111,46,0,20,1,36,26,1,9,110,
		7,36,29,1,48,109,0,102,106,10,97,112,112,101,
		110,100,105,110,103,0,112,1,31,8,36,30,1,9,
		110,7,36,33,1,48,110,0,102,112,0,73,36,35,
		1,48,111,0,102,112,0,73,36,37,1,48,112,0,
		48,14,0,102,112,0,112,0,80,1,36,39,1,48,
		113,0,48,14,0,102,112,0,112,0,73,36,41,1,
		48,109,0,102,106,14,111,112,101,110,105,110,103,68,
		105,97,108,111,103,0,112,1,73,36,43,1,48,114,
		0,48,24,0,102,112,0,112,0,28,50,36,45,1,
		48,115,0,48,14,0,102,112,0,112,0,73,36,47,
		1,48,109,0,102,106,9,97,112,112,101,110,100,101,
		100,0,112,1,73,36,49,1,48,116,0,102,112,0,
		73,25,62,36,53,1,9,80,2,36,55,1,48,109,
		0,102,106,15,99,97,110,99,101,108,65,112,112,101,
		110,100,101,100,0,112,1,73,36,57,1,48,117,0,
		48,14,0,102,112,0,95,1,112,1,73,36,59,1,
		48,118,0,102,112,0,73,36,63,1,48,109,0,102,
		106,13,101,120,105,116,65,112,112,101,110,100,101,100,
		0,112,1,73,36,65,1,95,2,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLBASECONTROLLER_DUPLICATE )
{
	static const HB_BYTE pcode[] =
	{
		13,2,0,36,72,1,120,80,2,36,74,1,48,119,
		0,102,112,0,28,39,36,75,1,176,86,0,106,21,
		65,99,99,101,115,111,32,110,111,32,112,101,114,109,
		105,116,105,100,111,46,0,20,1,36,76,1,9,110,
		7,36,79,1,48,109,0,102,106,12,100,117,112,108,
		105,99,97,116,105,110,103,0,112,1,31,8,36,80,
		1,9,110,7,36,83,1,48,120,0,102,112,0,73,
		36,85,1,48,111,0,102,112,0,73,36,87,1,48,
		112,0,48,14,0,102,112,0,112,0,80,1,36,89,
		1,48,121,0,48,14,0,102,112,0,112,0,73,36,
		91,1,48,109,0,102,106,14,111,112,101,110,105,110,
		103,68,105,97,108,111,103,0,112,1,73,36,93,1,
		48,114,0,48,24,0,102,112,0,112,0,28,52,36,
		95,1,48,115,0,48,14,0,102,112,0,112,0,73,
		36,97,1,48,109,0,102,106,11,100,117,112,108,105,
		99,97,116,101,100,0,112,1,73,36,99,1,48,116,
		0,102,112,0,73,25,64,36,103,1,9,80,2,36,
		105,1,48,117,0,48,14,0,102,112,0,95,1,112,
		1,73,36,107,1,48,109,0,102,106,17,99,97,110,
		99,101,108,68,117,112,108,105,99,97,116,101,100,0,
		112,1,73,36,109,1,48,118,0,102,112,0,73,36,
		113,1,48,109,0,102,106,15,101,120,105,116,68,117,
		112,108,105,99,97,116,101,100,0,112,1,73,36,115,
		1,95,2,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLBASECONTROLLER_EDIT )
{
	static const HB_BYTE pcode[] =
	{
		13,1,0,36,121,1,120,80,1,36,123,1,48,122,
		0,102,112,0,28,39,36,124,1,176,86,0,106,21,
		65,99,99,101,115,111,32,110,111,32,112,101,114,109,
		105,116,105,100,111,46,0,20,1,36,125,1,9,110,
		7,36,128,1,48,109,0,102,106,8,101,100,105,116,
		105,110,103,0,112,1,31,8,36,129,1,9,110,7,
		36,132,1,48,123,0,102,112,0,73,36,134,1,48,
		111,0,102,112,0,73,36,136,1,48,124,0,48,14,
		0,102,112,0,48,125,0,102,112,0,112,1,73,36,
		138,1,48,126,0,48,14,0,102,112,0,112,0,73,
		36,140,1,48,109,0,102,106,14,111,112,101,110,105,
		110,103,68,105,97,108,111,103,0,112,1,73,36,142,
		1,48,114,0,48,24,0,102,112,0,112,0,28,51,
		36,144,1,48,127,0,48,14,0,102,112,0,112,0,
		73,36,146,1,48,109,0,102,106,10,101,100,105,116,
		101,100,116,101,100,0,112,1,73,36,148,1,48,116,
		0,102,112,0,73,25,43,36,152,1,9,80,1,36,
		154,1,48,109,0,102,106,13,99,97,110,99,101,108,
		69,100,105,116,101,100,0,112,1,73,36,156,1,48,
		118,0,102,112,0,73,36,160,1,48,109,0,102,106,
		11,101,120,105,116,69,100,105,116,101,100,0,112,1,
		73,36,162,1,95,1,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLBASECONTROLLER_ZOOM )
{
	static const HB_BYTE pcode[] =
	{
		36,168,1,48,128,0,102,112,0,28,39,36,169,1,
		176,86,0,106,21,65,99,99,101,115,111,32,110,111,
		32,112,101,114,109,105,116,105,100,111,46,0,20,1,
		36,170,1,102,110,7,36,173,1,48,109,0,102,106,
		8,122,111,111,109,105,110,103,0,112,1,31,8,36,
		174,1,9,110,7,36,177,1,48,129,0,102,112,0,
		73,36,179,1,48,126,0,48,14,0,102,112,0,112,
		0,73,36,181,1,48,109,0,102,106,14,111,112,101,
		110,105,110,103,68,105,97,108,111,103,0,112,1,73,
		36,183,1,48,114,0,48,24,0,102,112,0,112,0,
		73,36,185,1,48,109,0,102,106,11,101,120,105,116,
		90,111,111,109,101,100,0,112,1,73,36,187,1,120,
		110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLBASECONTROLLER_DELETE )
{
	static const HB_BYTE pcode[] =
	{
		13,3,1,36,197,1,48,130,0,102,112,0,28,38,
		36,198,1,176,86,0,106,20,65,99,99,101,115,111,
		32,110,111,32,112,101,114,109,105,116,105,100,111,0,
		20,1,36,199,1,9,110,7,36,202,1,176,131,0,
		95,1,12,1,31,63,36,203,1,176,86,0,106,45,
		78,111,32,115,101,32,101,115,112,101,99,105,102,105,
		99,97,114,111,110,32,108,111,115,32,114,101,103,105,
		115,116,114,111,115,32,97,32,101,108,105,109,105,110,
		97,114,0,20,1,36,204,1,9,110,7,36,207,1,
		48,109,0,102,106,9,100,101,108,101,116,105,110,103,
		0,112,1,31,8,36,208,1,9,110,7,36,211,1,
		9,80,2,36,213,1,176,132,0,95,1,12,1,80,
		3,36,215,1,95,3,122,15,28,38,36,216,1,176,
		133,0,176,134,0,95,3,92,3,12,2,12,1,106,
		12,32,114,101,103,105,115,116,114,111,115,63,0,72,
		80,4,25,31,36,218,1,106,22,101,108,32,114,101,
		103,105,115,116,114,111,32,101,110,32,99,117,114,115,
		111,63,0,80,4,36,221,1,48,109,0,102,106,21,
		111,112,101,110,105,110,103,67,111,110,102,105,114,109,
		68,101,108,101,116,101,0,112,1,73,36,223,1,48,
		135,0,176,136,0,12,0,112,0,31,54,176,137,0,
		106,17,191,68,101,115,101,97,32,101,108,105,109,105,
		110,97,114,32,0,95,4,72,106,21,67,111,110,102,
		105,114,109,101,32,101,108,105,109,105,110,97,99,105,
		243,110,0,12,2,28,41,36,225,1,48,109,0,102,
		106,8,100,101,108,101,116,101,100,0,112,1,73,36,
		227,1,48,138,0,48,14,0,102,112,0,95,1,112,
		1,73,25,28,36,231,1,48,109,0,102,106,14,99,
		97,110,99,101,108,68,101,108,101,116,101,100,0,112,
		1,73,36,235,1,48,109,0,102,106,12,101,120,105,
		116,68,101,108,101,116,101,100,0,112,1,73,36,237,
		1,95,2,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLBASECONTROLLER_GETMODELBUFFER )
{
	static const HB_BYTE pcode[] =
	{
		13,0,1,36,243,1,176,10,0,48,14,0,102,112,
		0,12,1,28,8,36,244,1,100,110,7,36,247,1,
		176,10,0,48,139,0,48,14,0,102,112,0,112,0,
		12,1,28,8,36,248,1,100,110,7,36,251,1,176,
		140,0,48,139,0,48,14,0,102,112,0,112,0,95,
		1,12,2,31,8,36,252,1,100,110,7,36,255,1,
		176,141,0,48,139,0,48,14,0,102,112,0,112,0,
		95,1,20,2,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLBASECONTROLLER_GETROWSET )
{
	static const HB_BYTE pcode[] =
	{
		36,5,2,176,10,0,48,142,0,48,14,0,102,112,
		0,112,0,12,1,28,17,36,6,2,48,90,0,48,
		14,0,102,112,0,112,0,73,36,9,2,48,142,0,
		48,14,0,102,112,0,112,0,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLBASECONTROLLER_ADDFASTKEY )
{
	static const HB_BYTE pcode[] =
	{
		13,0,2,36,15,2,176,143,0,95,1,12,1,28,
		58,36,16,2,176,144,0,48,145,0,102,112,0,176,
		146,0,176,147,0,95,1,12,1,12,1,95,2,20,
		3,36,17,2,176,144,0,48,145,0,102,112,0,176,
		146,0,176,148,0,95,1,12,1,12,1,95,2,20,
		3,36,20,2,176,149,0,95,1,12,1,28,20,36,
		21,2,176,144,0,48,145,0,102,112,0,95,1,95,
		2,20,3,36,24,2,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLBASECONTROLLER_ONKEYCHAR )
{
	static const HB_BYTE pcode[] =
	{
		13,0,1,36,30,2,176,150,0,48,145,0,102,112,
		0,89,27,0,2,0,1,0,1,0,95,1,95,255,
		8,28,11,48,151,0,95,2,112,0,25,3,100,6,
		20,2,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLBASECONTROLLER_SETFASTREPORT )
{
	static const HB_BYTE pcode[] =
	{
		13,1,3,36,34,2,102,80,4,36,36,2,95,3,
		100,8,28,16,48,152,0,48,14,0,95,4,112,0,
		112,0,80,3,36,38,2,176,10,0,95,1,12,1,
		28,9,36,39,2,95,4,110,7,36,42,2,48,90,
		0,48,14,0,95,4,112,0,95,2,112,1,73,36,
		44,2,176,10,0,48,142,0,48,14,0,95,4,112,
		0,112,0,12,1,28,9,36,45,2,95,4,110,7,
		36,54,2,48,153,0,95,1,48,154,0,95,4,112,
		0,95,3,89,27,0,0,0,1,0,4,0,48,155,
		0,48,142,0,48,14,0,95,255,112,0,112,0,112,
		0,6,89,28,0,0,0,1,0,4,0,48,156,0,
		48,142,0,48,14,0,95,255,112,0,112,0,122,112,
		1,6,89,29,0,0,0,1,0,4,0,48,156,0,
		48,142,0,48,14,0,95,255,112,0,112,0,92,255,
		112,1,6,89,27,0,0,0,1,0,4,0,48,157,
		0,48,142,0,48,14,0,95,255,112,0,112,0,112,
		0,6,89,29,0,1,0,1,0,4,0,48,52,0,
		48,142,0,48,14,0,95,255,112,0,112,0,95,1,
		112,1,6,112,7,73,36,56,2,95,4,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_INITSTATICS()
{
	static const HB_BYTE pcode[] =
	{
		117,160,0,2,0,116,160,0,4,0,0,82,1,0,
		7
	};

	hb_vmExecute( pcode, symbols );
}

