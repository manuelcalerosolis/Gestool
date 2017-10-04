// Managing Register services from FiveWin

/*

2001-07-21 Patrick Mast ( email@patrickmast.com )

 - Added RegOpenKeyExA, RegQueryValueExA, RegEnumKeyExA and RegSetValueExA
   for Harbour compatible of Reg32
 - Added lError. This way no MsgStop needs to be displayed.
 - Added lShowError in New Method
 - Changed error message
 - Changed Get() Method to return default value if lError=.t.
 - Changed Set() to do nothing when lError=.t.
 - Changed Create() method to do nothing when lError=.t.
 - Changed Close() method to do nothing when lError=.t.
 - removed LOCAL nReturn from Create() method. It was not used.

*/

#include "FiveWin.Ch"
#include "Struct.ch"

#define  HKEY_CLASSES_ROOT       2147483648        // 0x80000000
#define  HKEY_CURRENT_USER       2147483649        // 0x80000001
#define  HKEY_LOCAL_MACHINE      2147483650        // 0x80000002
#define  HKEY_USERS              2147483651        // 0x80000003
#define  HKEY_PERFORMANCE_DATA   2147483652        // 0x80000004
#define  HKEY_CURRENT_CONFIG     2147483653        // 0x80000005
#define  HKEY_DYN_DATA           2147483654        // 0x80000006

//  The following are masks for the predefined standard access types

#define SYNCHRONIZE             1048576    // 0x00100000L
#define STANDARD_RIGHTS_READ    131072     // 0x00020000L
#define STANDARD_RIGHTS_WRITE   131072     // 0x00020000L
#define STANDARD_RIGHTS_ALL     2031616    // 0x001F0000L

// Registry Specific Access Rights.

#define KEY_QUERY_VALUE         1    // 0x0001
#define KEY_SET_VALUE           2    // 0x0002
#define KEY_CREATE_SUB_KEY      4    // 0x0004
#define KEY_ENUMERATE_SUB_KEYS  8    // 0x0008
#define KEY_NOTIFY              16   // 0x0010
#define KEY_CREATE_LINK         32   // 0x0020

***
*** Not sure how to handle the &'s and ~'s
***

#define KEY_READ        25 // ((STANDARD_RIGHTS_READ +  KEY_QUERY_VALUE + KEY_ENUMERATE_SUB_KEYS +  KEY_NOTIFY) & (~SYNCHRONIZE))
#define KEY_WRITE        6 // ((STANDARD_RIGHTS_WRITE +  KEY_SET_VALUE +  KEY_CREATE_SUB_KEY) & (~SYNCHRONIZE))
#define KEY_EXECUTE     25 // ((KEY_READ) & (~SYNCHRONIZE))
#define KEY_ALL_ACCESS  63 // ((STANDARD_RIGHTS_ALL +  KEY_QUERY_VALUE +  KEY_SET_VALUE +  KEY_CREATE_SUB_KEY + KEY_ENUMERATE_SUB_KEYS +  KEY_NOTIFY +  KEY_CREATE_LINK) & (~SYNCHRONIZE))

// Predefined Value Types.

#define REG_SZ                          1       && Data string (unicode nul terminated)
#define REG_EXPAND_SZ                   2       && Unicode string
#define REG_BINARY                      3       && Binary data in any form.
#define REG_DWORD                       4       && A 32-bit number.

#ifdef __XPP__
   #define New _New
#endif

//----------------------------------------------------------------------------//

CLASS TReg32

   DATA   cRegKey, nKey, nHandle, nError, lError

   METHOD New( nKey, cRegKey, lShowError ) CONSTRUCTOR

   METHOD Create( nKey, cRegKey ) CONSTRUCTOR

   METHOD Get( cSubKey, uVar )

   METHOD Set( cSubKey, uVar )

   METHOD Close() INLINE If(::lError,,RegCloseKey( ::nHandle ))

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nKey, cRegKey, lShowError ) CLASS TReg32

   local nReturn, nHandle := 0

   DEFAULT cRegKey := ""

   #ifdef __CLIPPER__
    nReturn := RegOpenKeyEx( nKey, cRegKey,, KEY_ALL_ACCESS, @nHandle )
   #else
    nReturn := RegOpenKeyExA( nKey, cRegKey,, KEY_ALL_ACCESS, @nHandle )
   #endif

   ::cRegKey = cRegKey
   ::nHandle = nHandle

   if nReturn != 0
      ::lError:=.t.
      IF lShowError=NIL .OR. lShowError
         MsgStop( "Error creating TReg32 object ("+LTrim(Str(nReturn))+")" )
      ENDIF
   else
      ::lError:=.f.
   endif

return Self

//----------------------------------------------------------------------------//

METHOD Create( nKey, cRegKey ) CLASS TReg32

   local nHandle := 0

   DEFAULT cRegKey := ""

   if !::lError

      ::nError := RegCreateKey( nKey, cRegKey, @nHandle )

      #ifdef __CLIPPER__
       ::nError := RegOpenKeyEx( nKey, cRegKey,, KEY_ALL_ACCESS, @nHandle )
      #else
       ::nError := RegOpenKeyExA( nKey, cRegKey,, KEY_ALL_ACCESS, @nHandle )
      #endif

      ::cRegKey = cRegKey
      ::nHandle = nHandle

   endif

return Self

//----------------------------------------------------------------------------//

METHOD Get( cSubkey, uVar ) CLASS TReg32

   local cValue  := ""
   local nType   := 0
   local nLen    := 0
   local oRegStruct, cBuffer, cType

   if !::lError

      cType := ValType( uVar )

      if cType == 'N'
         nType = REG_DWORD
         nLen  = 4
         STRUCT oRegStruct
           MEMBER nValue AS DWORD
         ENDSTRUCT
         oRegStruct:nValue = uVar
         cBuffer = oRegStruct:cBuffer
         #ifdef __CLIPPER__
          ::nError = RegQueryValueEx( ::nHandle, cSubkey, 0, nType, @cBuffer, nLen )
         #else
          ::nError = RegQueryValueExA( ::nHandle, cSubkey, 0, nType, @cBuffer, nLen )
         #endif
         oRegStruct:cBuffer = cBuffer
         uVar = oRegStruct:nValue
      else
        #ifdef __CLIPPER__
         ::nError = RegQueryValueEx( ::nHandle, cSubKey, 0, @nType, 0, @nLen )
        #else
         ::nError = RegQueryValueExA( ::nHandle, cSubKey, 0, @nType, 0, @nLen )
        #endif
        cValue = Space( nLen - 1 )
        #ifdef __CLIPPER__
         ::nError = RegQueryValueEx( ::nHandle, cSubkey, 0, @nType, @cValue, @nLen )
        #else
         ::nError = RegQueryValueExA( ::nHandle, cSubkey, 0, @nType, @cValue, @nLen )
        #endif
        uVar = cValue

        do case
           case cType == "D"
                uVar = CToD( uVar )

           case cType == "L"
                uVar = ( Upper( uVar ) == ".T." )

           case cType == "N"
                uVar = Val( uVar )
        endcase
      endif

   endif

return uVar

//----------------------------------------------------------------------------//

METHOD Set( cSubKey, uVar ) CLASS TReg32

   local nType, nLen, oRegStruct, cBuffer, cType

   if !::lError

      cType := ValType( uVar )

      if cType == 'N'
         nType = REG_DWORD
         nLen  = 4
         STRUCT oRegStruct
           MEMBER nValue AS DWORD
         ENDSTRUCT
         oRegStruct:nValue = uVar
         cBuffer = oRegStruct:cBuffer
         #ifdef __CLIPPER__
          ::nError = RegSetValueEx( ::nHandle, cSubkey, 0, nType, @cBuffer, nLen )
         #else
          ::nError = RegSetValueExA( ::nHandle, cSubkey, 0, nType, @cBuffer, nLen )
         #endif
      else
        nType = REG_SZ
        do case
           case cType == "D"
                uVar = DToC( uVar )

           case cType == "L"
                uVar := If( uVar, ".T.", ".F." )
        endcase
        nLen = Len( uVar )
        #ifdef __CLIPPER__
         ::nError = RegSetValueEx( ::nHandle, cSubkey, 0, nType, @uVar, nLen )
        #else
         ::nError = RegSetValueExA( ::nHandle, cSubkey, 0, nType, @uVar, nLen )
        #endif
      endif

   endif

return nil


//-------------------------------------------------------------------------//
DLL32 static ;
FUNCTION RegCloseKey(nhKey AS LONG);
         ;
         AS LONG PASCAL  LIB "ADVAPI32.DLL"

//-------------------------------------------------------------------------//
DLL32 static ;
    FUNCTION RegOpenKeyExA(nhKey     AS LONG   ,;
                           cAddress  AS LPSTR  ,;
                           nReserved AS LONG   ,;
                           nSecMask  AS LONG   ,;
                           @nphKey   AS PTR     );   //By reference
         ;
         AS LONG PASCAL LIB "ADVAPI32.DLL"

//-------------------------------------------------------------------------//
DLL32 static ;
FUNCTION RegQueryValueExA(nhKey      AS LONG   ,;
                          cAddress   AS LPSTR  ,;
                          nReserved  AS LONG   ,;
                          @nType     AS PTR    ,;    //By reference
                          @cResult   AS LPSTR  ,;    //By reference
                          @nResSize  AS PTR     );   //By reference
         ;
         AS LONG PASCAL LIB "ADVAPI32.DLL"

//-------------------------------------------------------------------------//
DLL32 static ;
FUNCTION RegEnumKeyExA(nhKey      AS LONG   ,;
                       nIndex     AS LONG   ,;
                       @cBuffer   AS LPSTR  ,;   //By reference
                       @nBufSize  AS PTR    ,;   //By reference
                       nReserved  AS LONG   ,;   //Must be NULL
                       @cClass    AS LPSTR  ,;   //By reference (can be NULL)
                       @nClsSize  AS PTR    ,;   //By reference (can be NULL)
                       @pFileTime AS PTR    );   //By reference (can be NULL)
         ;
         AS LONG PASCAL LIB "ADVAPI32.DLL"

//-------------------------------------------------------------------------//
DLL32 static ;
FUNCTION RegSetValueExA(nhKey      AS LONG   ,;
                        cAddress   AS LPSTR  ,;
                        nReserved  AS LONG   ,;
                        nType      AS LONG   ,;
                        cData      AS LPSTR  ,;
                        nDataLen   AS LONG    );
         ;
         AS LONG PASCAL LIB "ADVAPI32.DLL"