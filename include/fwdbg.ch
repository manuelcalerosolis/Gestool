
/* Mode of __dbgEntry calls (the first parameter) */
#define HB_DBG_MODULENAME     1  /* 2nd argumment is a module name */
#define HB_DBG_LOCALNAME      2  /* 2nd argument is a local var name */
#define HB_DBG_STATICNAME     3  /* 2nd arg is a static var name */
#define HB_DBG_ENDPROC        4  /* exit from a procedure */
#define HB_DBG_SHOWLINE       5  /* show current line */
#define HB_DBG_GETENTRY       6  /* initialize C __dbgEntry function pointer */
#define HB_DBG_ACTIVATE       7  /* activate debugger interface */
#define HB_DBG_VMQUIT         8  /* call internal debugger destructors */

/* Information structure stored in DATA aCallStack */
#define CSTACK_MODULE           1  // module name (.prg file)
#define CSTACK_FUNCTION         2  // function name
#define CSTACK_LINE             3  // start line
#define CSTACK_LEVEL            4  // eval stack level of the function
#define CSTACK_LOCALS           5  // an array with local variables
#define CSTACK_STATICS          6  // an array with static variables

/* Information structure stored in aCallStack[ n ][ CSTACK_LOCALS ]
   { cLocalName, nLocalIndex, "Local", ProcName( 1 ), nLevel } */
#define VAR_NAME                1
#define VAR_POS                 2
#define VAR_TYPE                3
#define VAR_LEVEL               4  // eval stack level of the function

/* Information structure stored in ::aWatch (watchpoints) */
#define WP_TYPE                 1  // wp = watchpoint, tr = tracepoint
#define WP_EXPR                 2  // source of an expression

/* Information structure stored in ::aModules */
#define MODULE_NAME             1
#define MODULE_STATICS          2
#define MODULE_GLOBALS          3
#define MODULE_EXTERNGLOBALS    4
