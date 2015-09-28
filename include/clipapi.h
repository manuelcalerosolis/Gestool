#ifndef _CLIPAPI_H
#define _CLIPAPI_H

#ifndef __XPP__       // Clipper and C3 only
#ifndef __HARBOUR__
   typedef void ( pascal * PCLIPFUNC )( void );
   #define CLIPPER void pascal
   #define PARAMS void
   #define PCOUNT() _parinfo(0)
#endif
#endif

#ifdef __XPP__
   #include <fwxbase.h>
#endif

#if defined(__HARBOUR__) > 0x020100
   #define _parinfo hb_parinfo
#endif

#ifdef __HARBOUR__
   #include <fwHarb.h>
   #define params void *
   #define PARAMS void
   #undef  PCOUNT
   #define PCOUNT() _parinfo(0)
   #if defined(__HARBOUR__) > 0x020100
      #define ARRAY HB_IT_ARRAY
      #define ITEM PHB_ITEM
   #endif
   
#endif

// Some xBase for C language!
#define IF(x,y,z) ((x)?(y):(z))
#define MIN(a,b)  (int) (((int)(a) < (int)(b)) ? (a) : (b))

#ifndef __HARBOUR__
   #define MAX( a, b ) ( int ) (((int)(a) > (int)(b)) ? (a) : (b))
#endif

#ifndef __XPP__        // Clipper and C3 only
#ifndef __HARBOUR__

// Types for wType in generic struct CLIPVAR
#define S_ANY          0xFFFF
#define S_UNDEF        0x0000
#define S_WORD         0x0001
#define S_LNUM         0x0002
#define S_DNUM         0x0008
#define S_LDATE        0x0020
#define S_LOG          0x0080
#define S_SYM          0x0100
#define S_ALIAS        0x0200
#define S_CHAR         0x0400
#define S_MEMO         ( 0x0800 | S_CHAR )
#define S_BLOCK        0x1000
#define S_VREF         0x2000
#define S_MREF         0x4000
#define S_ANYREF       0x6000
#define S_ARRAY        0x8000
#define S_OBJECT       S_ARRAY
#define S_ANYNUM       ( S_LNUM | S_DNUM )
#define S_ANYEXP       ( S_ANYNUM | S_CHAR | S_LDATE | S_LOG )

#ifndef __FLAT__
   #ifndef _WINDOWS_
      typedef unsigned char BYTE;
      typedef unsigned int WORD;
      typedef signed long LONG;
      typedef unsigned long DWORD;
      typedef BYTE * LPBYTE;
      typedef char * LPSTR;
      typedef WORD * PWORD;
      typedef WORD * LPWORD;
      typedef LONG * PLONG;
      typedef LONG * LPLONG;
      typedef DWORD * PDWORD;
      typedef DWORD * LPDWORD;
      typedef enum{ FALSE, TRUE } BOOL;
   #endif
#endif

typedef struct
{
   WORD  wType;
   WORD  w2;
   WORD  w3;
   LPBYTE pPointer1;
   LPBYTE pPointer2;
} CLIPVAR;              // sizeof( CLIPVAR )  --> 14 bytes

// A kind of inheritance from CLIPVAR struct for NUMERIC types
typedef struct
{
   WORD wType;
   LONG lDummy1;
   LONG lnNumber;
   LONG lDummy2;
} CLV_LONG;

typedef struct
{
   WORD wFloat[ 4 ];
} CLIP_FLOAT;

// A kind of inheritance from CLIPVAR struct for NUM_FLOAT types
// still to be completed. They are the functions _dv......

typedef struct
{
   WORD wType;
   LONG lDummy1;
   CLIP_FLOAT fFloat;
} CLV_FLOAT;

// CLV_WORD struct for NUMERIC (WORD) and for LOGICAL (BOOL).

typedef struct
{
    WORD wType;
    LONG lDummy;
    WORD wWord;         // for LOGICAL clipvars -> Casting to (BOOL)
    WORD wDummy[ 3 ];
} CLV_WORD;

// VITEMCHAR struct for VITEM's CHAR.

typedef struct
{
    WORD wType;
    WORD wLen;
    WORD wDummy[ 5 ];
} CLV_CHAR;

#ifndef __FLAT__
   typedef CLIPVAR near * PCLIPVAR;
   typedef CLIPVAR far * LPCLIPVAR;
#else
   typedef CLIPVAR * PCLIPVAR;
   typedef CLIPVAR * LPCLIPVAR;
#endif

// When a parameter is passed by reference, Clipper provides a
// ClipVar that keeps a pointer to the original ClipVar.
// We call this a REF_CLIPVAR;

typedef struct
{
   WORD wType;
   WORD w2;
   WORD w3;
   PCLIPVAR pClipVar;
   LPBYTE pVoid;
} REF_CLIPVAR;

typedef struct
{
   BYTE cName[ 11 ];
   BYTE cType;
   LPBYTE pSymbol; // Is a LPCLIPSYMBOL. You must cast.
} CLIPNAME;                      // 16 bytes

typedef CLIPNAME * PCLIPNAME;
typedef CLIPNAME * LPCLIPNAME;

typedef struct
{
   BYTE Dummy[ 8 ];
   PCLIPNAME pName;
   PCLIPFUNC pFunc;
} CLIPSYMBOL;                    // 16 bytes

typedef CLIPSYMBOL * PCLIPSYMBOL;
typedef CLIPSYMBOL * LPCLIPSYMBOL;

extern PCLIPSYMBOL _SymEVAL;         // == _get_sym( "EVAL" )
                                     // SymSys init

/////////////////////////////////////////////////////////
// EXTEND Module - Clipper Extend system functions     //
/////////////////////////////////////////////////////////

// Retrieves any parameter checking type. Use ALLTYPES #define for no test.
PCLIPVAR _param( short wParam, WORD wType );

#ifndef __FLAT__
   extern WORD _pcount;   // Number of parameters
   WORD  _parinfo( WORD );
   WORD  _parinfa( WORD, WORD );
   LPSTR _parc( WORD wParam, ... );
   WORD  _parclen( WORD wParam, ... );
   LPSTR _pards( WORD, ...);
   BOOL  _parl( WORD wParam, ... );
   int _parni( WORD wParam, ... );
   LONG _parnl( WORD wParam, ... );
   void  _retc( char * );
   void  _retclen( char *, WORD wLen );
   void  _retd( char * );
   void  _retl( BOOL );
   void _retni( WORD wNumber );
   void  _retnl( LONG lNumber );
   void  _ret( void );
   void  _reta( WORD wArrayLen );      // Creates and returns an Array
   BOOL  _storc( LPSTR, WORD wParam, ... );
   BOOL  _storclen( LPSTR, WORD wLen, WORD wParam, ... );
   BOOL  _storl( BOOL, WORD wParam, ... );
   BOOL  _storni( WORD wValue, WORD wParam, ... );
   BOOL  _stornl( LONG lValue, WORD wParam, ... );
   BOOL  _stords( LPSTR szYYYYMMDD, WORD wParam, ... );
#else
   short _parinfo( short );
   ULONG _parinfa( short, USHORT );
   char * _parc( short, ... );
   ULONG _parcsiz( short, ... );
   ULONG _parclen( short, ... );
   short _parni( short, ... );
   LONG  _parnl( short, ... );
   short _parl( short, ... );
   char * _pards( short, ... );
   void _retc( char * );
   void _retclen( char *, ULONG );
   void _retni( short );
   void _retnl( LONG );
   void _retnd( double );
   void _retl( short );
   void _retds( char * );
   void _ret( void );
   void _reta( ULONG ulLength );  // Creates and returns an Array at _eval
   short _storc( char *, short, ... );
   short _storclen( char *, ULONG, short, ... );
   short _storni( short, short, ... );
   short _stornl( LONG, short, ... );
   short _stornd( double, short, ... );
   short _storl( short, short, ... );
   short _stords( char *, short, ... );
#endif

#define _pcount()  _parinfo( 0 )

extern void  _xunlock( void );
extern LPBYTE _xgrab( WORD wSize );
extern void   _xfree( LPBYTE );

#define  ISCHAR( s )    ( _param( s, S_CHAR )   != NULL )
#define  ISNUM( s )     ( _param( s, S_ANYNUM ) != NULL )
#define  ISLOGICAL( s ) ( _param( s, S_LOG )    != NULL )
#define  ISARRAY( s )   ( _param( s, S_ARRAY )  != NULL )
#define  ISDATE( s )    ( _param( s, S_LDATE )  != NULL )
#define  ISBLOCK( s )   ( _param( s, S_BLOCK )  != NULL )
#define  ISBYREF( s )   ( _param( s, S_ANYREF ) != NULL )

typedef struct
{
   BYTE Red, Green, Blue, Attr;       // Four bytes
} RGB;

//////////////////////////////////////////////////////
// COLOR Module - Colors Control                    //
//////////////////////////////////////////////////////

// General Terminal
typedef struct
{                         //  R   G   B   +*
   RGB Fore;              //  FF  FF  FF  00
   RGB Back;              //  FF  FF  FF  00
} CLIPCOLOR;

extern CLIPCOLOR * _colors;       // _colors[ 5 ]
extern WORD _ColorCount;      // Number of colors used ¨?
void _xSetColor( PCLIPVAR );  // String dBase Colors

//////////////////////////////////////////////////////////////////
// GT Module - General Terminal                                 //
//////////////////////////////////////////////////////////////////

typedef struct
{
   WORD wTop;
   WORD wLeft;
   WORD wHeight;
   WORD wWidth;      // so there is no conflict with Windows.h rect
} gtRECT;

typedef gtRECT * LPgtRECT;

typedef struct
{
   WORD wTop, wLeft, wHeight, wWidth;
   BYTE RGBColor[ 8 ];
   LONG lDummy1;
   WORD wDummy2;
   WORD wDummy3;
   LPBYTE p34Bytes;
   BYTE bDummy2[ 10 ];
} WINDOW;

typedef WINDOW * gtHWND;
typedef gtHWND * PgtHWND;

WORD _gtBox( WORD, WORD, WORD, WORD, LPSTR );
WORD _gtColorSelect( WORD wColor );      // __color() in 5.01
WORD _gtMaxRow( void );
WORD _gtMaxCol( void );
WORD _gtSetColor( CLIPCOLOR * pColors );
WORD _gtGetColor( CLIPCOLOR * pColors );
WORD _gtSetPos( WORD wRow, WORD wCol );
WORD _gtGetPos( WORD * pwRow, WORD * pwCol );
WORD _gtScroll( WORD, WORD, WORD, WORD, int );
WORD _gtWriteAt( WORD wRow, WORD wCol, LPSTR szText, WORD wLen );
WORD _gtWrite( LPSTR szText, WORD wLen );
WORD _gtWriteCon( LPSTR szText, WORD wLen );
WORD _gtSave( WORD wTop, WORD wLeft, WORD wBottom, WORD wRight, LPBYTE pBuffer );
WORD _gtScrDim( LPWORD pwRows, LPWORD pwCols );
WORD _gtRest( WORD wTop, WORD wLeft, WORD wBottom, WORD wRight, LPBYTE pBuffer );
WORD _gtRectSize( WORD wTop, WORD wLeft, WORD wBottom, WORD wRight, LPWORD wResult );
WORD _gtRepChar( WORD wRow, WORD wCol, WORD wChar, WORD wTimes );

// Undocumented Windowing System !!!
void _gtWCreate( LPgtRECT rctCoors, PgtHWND hWnd );
void _gtWCurrent( gtHWND hWnd );
BOOL _gtWVis( gtHWND hWnd, WORD wStatus );
BOOL _gtWFlash( void );
void _gtWApp( PgtHWND hWndApp );
void _gtWPos( gtHWND hWnd, LPgtRECT rctCoors );

// Selects a color - Clipper calling conventions
extern void _color( void );

// extended GT - RUNsoft
void _gtShadow( WORD wTop, WORD wLeft, WORD wBottom, WORD wRight );
void _gtClrReverse( WORD wColor );
void _gtSayHot( WORD wRow, WORD wCol, LPSTR szText, WORD wClrNormal, WORD wClrHot );
WORD _gtClrGet( WORD wColor );

//////////////////////////////////////////////////////////////////
// FILESYS Module - Low level Files Management
//////////////////////////////////////////////////////////////////

extern WORD _tcreat( LPSTR szFileName, WORD wMode );
extern BOOL _tclose( WORD wHandle );
extern WORD _topen( LPSTR szFileName, WORD wMode );
extern LONG _tlseek( WORD wHandle, LONG lRecNo, WORD wPosition );
extern WORD _tread( WORD wHandle, LPBYTE cBuffer, WORD wBytes );
extern WORD _twrite( WORD wHandle, LPBYTE cBuffer, WORD wBytes );
void LogFile( LPSTR szFileName, LPSTR szText );

////////////////////////////////////////////////////////////////////////////
// STACK and OM Module - Clipper internal stack and ClipVars management   //
////////////////////////////////////////////////////////////////////////////

// it stores the return value of a function // return ...
extern PCLIPVAR _eval;

// _lbase + 1  --> Self from within Methods ! Reach it with _par...( 0, ... ) !
// _lbase + 2  --> First parameter
// _lbase + 3  --> Second parameter
// ...
extern PCLIPVAR _lbase;      // LOCAL BASE

// statics
extern PCLIPVAR _sbase;    // STATIC BASE

// Clipper Stack   tos = TO S tack
extern PCLIPVAR _tos;

#ifndef __FLAT__
   // They automatically update _tos.
   extern void _putc( LPSTR szText );
   extern void _putcl( LPSTR szText, WORD wLen );
   extern void _putq( WORD wNumber );
   extern void _putln( LONG lNumber );
   extern void _putl( BOOL );
#else
   // They automatically update _tos.
   extern void _put( void ); // C3 special. Places NIL at the stack.
   extern void _putc( LPSTR szText );
   extern void _putcl( LPSTR szText, LONG lLen );
   extern void _putq( WORD wNumber );
   extern void _putln( LONG lNumber );
   extern void _putl( BOOL );
#endif

// Places any CLIPVAR at Clipper Stack.  Pass ClipVars by value.
// Automatically updates _tos
extern void _xpushm( LPCLIPVAR );
extern void _xpopm( LPCLIPVAR );  // LPCLIPVAR can't be NULL !!!

extern WORD _0POP( void ); // decrement _tos

// calling Clipper from C
extern void _putsym( PCLIPSYMBOL );
// ( ++_tos )->wType = NIL;               <-- We place nil at Self !!!
// we place other params with _Put...
extern void _xdo( WORD wParams );


// executing CodeBlocks

// _PutSym( _symEVAL );
extern void _xeval( WORD wNumberOfParameters );

                                           // eval a codeblock with no params
extern void _cEval0( PCLIPVAR CodeBlock ); // evalua codeblock sin parametros.
extern void _cEval1( PCLIPVAR CodeBlock, PCLIPVAR Param1 ); // idem con un par metro.
                                           // same but with one param

extern PCLIPVAR _GetGrip( PCLIPVAR ); // allocates new clipvar in high stack pos.
extern void    _DropGrip( PCLIPVAR ); // free it.

// Returns pointer to _lbase of calls stack, 0->this, 1->previous, ...
extern PCLIPVAR _actinfo( WORD wIndex );

extern WORD  _sptoq( PCLIPVAR );   // Returns the value of a number placed at _tos
                                   // By value or by ref as WORD
extern LONG  _sptol( PCLIPVAR );   // IDEM as LONG

#ifndef __FLAT__
   // Copy wBytes from Source to Destination
   extern void _bcopy( LPBYTE pDest, LPBYTE pSource, WORD wBytes );

   // Inicializes wLen Bytes with the value wValue
   extern void _bset( LPBYTE pStart, WORD wValue, WORD wLen );

   // Retrieves an element of an array
   extern void _cAt( PCLIPVAR vArray, WORD wIndex, WORD wFlag, PCLIPVAR vDest );

   // Changes an element of an array
   extern void _cAtPut( PCLIPVAR vArray, WORD wIndex, PCLIPVAR vSource );

   // Stores a String into an array element
   extern void _cAtPutStr( PCLIPVAR vArray, WORD wIndex, LPSTR szString,
                              WORD wStrLen );

   // Strings
   // Creates a new String. Stores a CLIPVAR at _eval
   extern void pascal _BYTESNEW( WORD wLenBytes );
#else
   // Copy wBytes from Source to Destination
   extern void _bcopy( LPBYTE pDest, LPBYTE pSource, LONG lBytes );

   // Inicializes wLen Bytes with the value wValue
   extern void _bset( LPBYTE pStart, WORD wValue, LONG lLen );

   // Retrieves an element of an array
   extern void _cAt( PCLIPVAR vArray, LONG lIndex, WORD wFlag, PCLIPVAR vDest );

   // Changes an element of an array
   extern void _cAtPut( PCLIPVAR vArray, LONG lIndex, PCLIPVAR vSource );

   // Stores a String into an array element
   extern void _cAtPutStr( PCLIPVAR vArray, LONG lIndex, LPSTR szString,
                              LONG lStrLen );

   // Strings
   // Creates a new String. Stores a CLIPVAR at _eval
   extern void pascal _BYTESNEW( LONG lLenBytes );
#endif

// Locks a CLIPVAR String to access its bytes
// if need unlock returns TRUE
extern BOOL pascal _VSTRLOCK( PCLIPVAR vString );

// Gets the LPSTR of the String. It must be locked before with _VSTRLOCK
extern LPSTR pascal _VSTR( PCLIPVAR vString );

// UnLocks the String
extern void pascal _VSTRUNLOCK( PCLIPVAR vString );

#ifndef __FLAT__
#ifndef _BC5
   WORD strlen( LPSTR szText );
   void strcpy( LPBYTE lpTarget, LPBYTE lpSource );
   BOOL strcmp( LPSTR szString1, LPSTR szString2 );
   LPBYTE strcat( LPBYTE lpTarget, LPBYTE lpSource );
#endif
#endif

LPSTR _StrScan( LPSTR szSearchAt, LPSTR szSearchFor );

#ifndef __FLAT__
   // Arrays
   // Retrieves the Len of an array
   extern WORD pascal _VARRAYLEN( PCLIPVAR vArray );

   // Creates and returns an Array in _eval
   extern void pascal _ARRAYNEW( WORD wLen );
#else
   // Arrays
   // Retrieves the Len of an array
   extern LONG pascal _VARRAYLEN( PCLIPVAR vArray );

   // Creates and returns an Array in _eval
   extern void pascal _ARRAYNEW( LONG lLen );
#endif

// Add a new element to an array
// _tos + 1  --> array
// _tos + 2  --> element
// _tos must be incremented
extern void pascal __AADD( void );

// Resizes an Array
// Parameters must be placed usign _tos
// pcount must be updated
extern void pascal ASIZE( void );

// Retrieves the Symbol of a String
extern PCLIPSYMBOL _get_sym( LPSTR szName );
extern PCLIPSYMBOL _Chk_Sym( LPSTR szName );

////////////////////////////////////////////////////////
// SEND Module - OOPS Management !
////////////////////////////////////////////////////////

// Creates a new Class
LONG _mdCreate( WORD wMethods, PCLIPSYMBOL pClassName );

// Adds a new Method to a ClassH
extern _mdAdd( LONG lClassHandle, PCLIPSYMBOL pMethodName, PCLIPFUNC pMethod );

// Gets the function address of a method
// Message info must be placed at ( _lbase + 0 )->pMsg
// Self must be placed at _lbase + 1
extern PCLIPFUNC _isendp( void );

// Retrieves the ClassH of an Object
extern LONG _VDict( PCLIPVAR );

// Changes the ClassH of an Object or Array
extern void _VSetDict( PCLIPVAR, LONG lClassHandle );

void _xsend( WORD wNumberOfParameters );     // The missing xSend function

#define INSTVAR(Name,pCode) _mdAdd(ulHandle,_get_sym(Name),pCode); _mdAdd(ulHandle,_get_sym("_"Name),pCode)
#define METHOD(Name,pCode) _mdAdd(ulHandle,_get_sym(Name),pCode)

/*********************************************************/
// executes a CodeBlock
// lbase + 1  --> CodeBlock
// lbase + 2  --> First parameter
// lbase + 3  --> ...
// _pcount    --> Number of parameters
// extern void _ixblock( void );   // NO DEBE USARSE SIN guardar y preparar
                                   // las variables de estado de plankton.

                                   // IT MAY NOT BE USED without saving and
                                   // preparing plakton state variables
#ifndef __FLAT__
   // Memory Management
   // Alloc wBytes (fixed ¨?)
   extern LPBYTE _AllocF( WORD wBytes );
#else
   // Memory Management
   // Alloc wBytes (fixed ¨?)
   extern LPBYTE _AllocF( LONG lBytes );
#endif

//////////////////////////////////////////////
// EVENT Module - Clipper internally is event-driven !!!
//////////////////////////////////////////////

typedef struct
{
   WORD wDymmy;
   WORD wMessage;
} EVENT;

typedef EVENT * PEVENT;

typedef WORD ( * EVENTFUNCP ) ( PEVENT pEvent );

// Register a new Event Handler
extern WORD _evRegReceiverFunc( EVENTFUNCP pFunc, WORD wType );

extern void _evDeRegReceiver( WORD wHandlerOrder );

extern void _evSendId( WORD wMessage, WORD wHandlerOrder ); // 0xFFFF a Todos
extern WORD _evRegType( DWORD, DWORD, WORD );
extern void _evPostId( WORD evId, WORD wReceiverHandle );

extern void _Break_Cycle( void );

WORD _evModalRead( void );

WORD _gtModalRead( void );

extern void ( * _evKbdEntry )( PEVENT pEvent );

///////////////////////////////////////////////////////////
// BEEP Module - Terminal Driver Module
///////////////////////////////////////////////////////////

void _beep_( void );

///////////////////////////////////////////////////////////
// DYNC Module - Dynamic Linking Modules
///////////////////////////////////////////////////////////

typedef struct
{
   WORD AX, BX, CX, DX;
} DLM_PARAMS;

typedef DLM_PARAMS * PDLM_PARAMS;

typedef WORD ( * DLMSERVER )( PDLM_PARAMS pParams, WORD wService );
typedef DLMSERVER * PDLMSERVER;

void _DynLoadModule( PWORD pHandle, LPSTR szModule );
WORD _DynGetNamedAddr( WORD wHandle, LPSTR szEntryModule, PDLMSERVER pServer );
LONG _DynGetOrdAddr( WORD wHandle, WORD wService );

// ERROR
void _ierror( WORD wError );  // generates an internal error message and quit.

// TB Module
LPSTR _tbname( PCLIPVAR, WORD );      // Same as ProcName. 2 param no matter
                                      // 1 param is _ActInfo( WORD )
void pascal QOUT( void );

#endif
#endif

#ifdef __C3__
   #define __HARBOUR__  // to use symbols larger than 10 chars
#endif

#ifdef UNICODE
   #include <fwce.h>
#endif   

#endif
