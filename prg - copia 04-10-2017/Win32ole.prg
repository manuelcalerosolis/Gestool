#include "error.ch"

#define EG_OLEEXECPTION 1001

Static bOleInitialized := .f.

//----------------------------------------------------------------------------//

Function CreateObject( cString )

Return TOleAuto():New( cString )

//----------------------------------------------------------------------------//

Function GetActiveObject( cString )

Return TOleAuto():GetActiveObject( cString )

//----------------------------------------------------------------------------//

PROCEDURE Initialize_Ole
   if ! bOleInitialized
      bOleInitialized := .T.
      Ole_Initialize()
   end if
Return

//----------------------------------------------------------------------------//

EXIT PROCEDURE UnInitialize_Ole
   if bOleInitialized
      bOleInitialized := .F.
      Ole_UnInitialize()
   end if
Return

//----------------------------------------------------------------------------//

CLASS TOleAuto

   DATA hObj
   DATA cClassName
   DATA bShowException INIT .T.

   METHOD New( uObj, cClass ) CONSTRUCTOR
   METHOD GetActiveObject( cClass ) CONSTRUCTOR

   METHOD Invoke( cMember, uParam1, uParam2, uParam3, uParam4, uParam5, uParam6, uParam7, uParam8, uParam9 )
   METHOD Set( cProperty, uParam1, uParam2, uParam3, uParam4, uParam5, uParam6, uParam7, uParam8, uParam9 )
   METHOD Get( cProperty, uParam1, uParam2, uParam3, uParam4, uParam5, uParam6, uParam7, uParam8, uParam9 )

   ERROR HANDLER OnError()

ENDCLASS

//--------------------------------------------------------------------

METHOD New( uObj, cClass ) CLASS TOleAuto

   local oErr

   if ValType( uObj ) = 'C'
      ::hObj := CreateOleObject( uObj )

      if OleError() != 0
         if ::bShowException .AND. Ole2TxtError() == "DISP_E_EXCEPTION"
            oErr := ErrorNew()
            oErr:Args          := { uObj }
            oErr:CanDefault    := .F.
            oErr:CanRetry      := .F.
            oErr:CanSubstitute := .T.
            oErr:Description   := OLEExceptionDescription()
            oErr:GenCode       := EG_OLEEXECPTION
            oErr:Operation     := ProcName()
            oErr:Severity      := ES_ERROR
            oErr:SubCode       := -1
            oErr:SubSystem     := OLEExceptionSource()

            Return Eval( ErrorBlock(), oErr )
         else
            oErr := ErrorNew()
            oErr:Args          := { uObj }
            oErr:CanDefault    := .F.
            oErr:CanRetry      := .F.
            oErr:CanSubstitute := .T.
            oErr:Description   := Ole2TxtError()
            oErr:GenCode       := EG_OLEEXECPTION
            oErr:Operation     := ProcName()
            oErr:Severity      := ES_ERROR
            oErr:SubCode       := -1
            oErr:SubSystem     := "TOleAuto"

            Return Eval( ErrorBlock(), oErr )
         end if
      end if

      ::cClassName := uObj
   elseif ValType( uObj ) = 'N'
      ::hObj := uObj
      if ValType( cClass ) == 'C'
         ::cClassName := cClass
      else
         ::cClassName := LTrim( Str( uObj ) )
      end if
   else
      MessageBox( 0, "Invalid parameter type to constructor TOleAuto():New()!", "OLE Interface", 0 )
      ::hObj := 0
   end if

Return Self

//--------------------------------------------------------------------

METHOD GetActiveObject( cClass ) CLASS TOleAuto

   local oErr

   if ValType( cClass ) = 'C'
      ::hObj := GetOleObject( cClass )

      if OleError() != 0
         if ::bShowException .AND. Ole2TxtError() == "DISP_E_EXCEPTION"
            oErr := ErrorNew()
            oErr:Args          := { cClass }
            oErr:CanDefault    := .F.
            oErr:CanRetry      := .F.
            oErr:CanSubstitute := .T.
            oErr:Description   := OLEExceptionDescription()
            oErr:GenCode       := EG_OLEEXECPTION
            oErr:Operation     := ProcName()
            oErr:Severity      := ES_ERROR
            oErr:SubCode       := -1
            oErr:SubSystem     := OLEExceptionSource()

            Return Eval( ErrorBlock(), oErr )
         else
            oErr := ErrorNew()
            oErr:Args          := { cClass }
            oErr:CanDefault    := .F.
            oErr:CanRetry      := .F.
            oErr:CanSubstitute := .T.
            oErr:Description   := Ole2TxtError()
            oErr:GenCode       := EG_OLEEXECPTION
            oErr:Operation     := ProcName()
            oErr:Severity      := ES_ERROR
            oErr:SubCode       := -1
            oErr:SubSystem     := "TOleAuto"

            Return Eval( ErrorBlock(), oErr )
         end if
      end if

      ::cClassName := cClass
   else
      MessageBox( 0, "Invalid parameter type to constructor TOleAuto():GetActiveObject()!", "OLE Interface", 0 )
      ::hObj := 0
   end if

Return Self

//--------------------------------------------------------------------

METHOD Invoke( cMethod, uParam1, uParam2, uParam3, uParam4, uParam5, uParam6, uParam7, uParam8, uParam9 ) CLASS TOleAuto

   local uObj, nParams := PCount(), Counter
   local OleRefFlags := Space( nParams - 1 )
   local oErr

   if ProcName( 1 ) != "TOLEAUTO:" + cMethod

      if nParams >= 10
         if HB_ISBYREF( @uParam9 )
            OleRefFlags[9] = 'Y'
         end if
      end if

      if nParams >= 9
         if HB_ISBYREF( @uParam8 )
            OleRefFlags[8] = 'Y'
         end if
      end if

      if nParams >= 8
         if HB_ISBYREF( @uParam7 )
            OleRefFlags[7] = 'Y'
         end if
      end if

      if nParams >= 7
         if HB_ISBYREF( @uParam6 )
            OleRefFlags[6] = 'Y'
         end if
      end if

      if nParams >= 6
         if HB_ISBYREF( @uParam5 )
            OleRefFlags[5] = 'Y'
         end if
      end if

      if nParams >= 5
         if HB_ISBYREF( @uParam4 )
            OleRefFlags[4] = 'Y'
         end if
      end if

      if nParams >= 4
         if HB_ISBYREF( @uParam3 )
            OleRefFlags[3] = 'Y'
         end if
      end if

      if nParams >= 3
         if HB_ISBYREF( @uParam2 )
            OleRefFlags[2] = 'Y'
         end if
      end if

      if nParams >= 2
         if HB_ISBYREF( @uParam1 )
            OleRefFlags[1] = 'Y'
         end if

         SetOleRefFlags( OleRefFlags )
      end if
   end if

   do case
      case nParams == 10
         uObj := OLEInvoke( ::hObj, cMethod, @uParam1, @uParam2, @uParam3, @uParam4, @uParam5, @uParam6, @uParam7, @uParam8, @uParam9 )
      case nParams == 9
         uObj := OLEInvoke( ::hObj, cMethod, @uParam1, @uParam2, @uParam3, @uParam4, @uParam5, @uParam6, @uParam7, @uParam8 )
      case nParams == 8
         uObj := OLEInvoke( ::hObj, cMethod, @uParam1, @uParam2, @uParam3, @uParam4, @uParam5, @uParam6, @uParam7 )
      case nParams == 7
         uObj := OLEInvoke( ::hObj, cMethod, @uParam1, @uParam2, @uParam3, @uParam4, @uParam5, @uParam6 )
      case nParams == 6
         uObj := OLEInvoke( ::hObj, cMethod, @uParam1, @uParam2, @uParam3, @uParam4, @uParam5 )
      case nParams == 5
         uObj := OLEInvoke( ::hObj, cMethod, @uParam1, @uParam2, @uParam3, @uParam4 )
      case nParams == 4
         uObj := OLEInvoke( ::hObj, cMethod, @uParam1, @uParam2, @uParam3 )
      case nParams == 3
         uObj := OLEInvoke( ::hObj, cMethod, @uParam1, @uParam2 )
      case nParams == 2
         uObj := OLEInvoke( ::hObj, cMethod, @uParam1 )
      case nParams == 1
         uObj := OLEInvoke( ::hObj, cMethod )
      otherwise
         MessageBox( 0, "TOleAuto:Invoke() - Unsupported number of parameter!", "OLE Interface", 0 )
      Return Nil
   end case

   SetOleRefFlags()

   if ::bShowException
      if Ole2TxtError() == "DISP_E_EXCEPTION"
         oErr := ErrorNew()
         oErr:Args          := { Self, cMethod, @uParam1, @uParam2, @uParam3, @uParam4, @uParam5, @uParam6, @uParam7, @uParam8, @uParam9  }
         oErr:CanDefault    := .F.
         oErr:CanRetry      := .F.
         oErr:CanSubstitute := .T.
         oErr:Description   := OLEExceptionDescription()
         oErr:GenCode       := EG_OLEEXECPTION
         oErr:Operation     := ::cClassName + ":" + cMethod
         oErr:Severity      := ES_ERROR
         oErr:SubCode       := -1
         oErr:SubSystem     := OLEExceptionSource()

         Return Eval( ErrorBlock(), oErr )

      elseif OleError() != 0
         oErr := ErrorNew()
         oErr:Args          := { Self, cMethod, @uParam1, @uParam2, @uParam3, @uParam4, @uParam5, @uParam6, @uParam7, @uParam8, @uParam9  }
         oErr:CanDefault    := .F.
         oErr:CanRetry      := .F.
         oErr:CanSubstitute := .T.
         oErr:Description   := Ole2TxtError()
         oErr:GenCode       := EG_OLEEXECPTION
         oErr:Operation     := ::cClassName + ":" + cMethod
         oErr:Severity      := ES_ERROR
         oErr:SubCode       := -1
         oErr:SubSystem     := ::cClassName

         Return Eval( ErrorBlock(), oErr )
      end if

      if ValType( uObj ) == 'O'
         uObj:cClassName := Self:cClassName + ':' + cMethod
      end if

   end if

Return uObj

//--------------------------------------------------------------------

METHOD Set( cProperty, uParam1, uParam2, uParam3, uParam4, uParam5, uParam6, uParam7, uParam8, uParam9 ) CLASS TOleAuto

   local uObj
   local nParams := PCount()
   local oErr

   do case
      case nParams == 10
         OLESetProperty( ::hObj, cProperty, @uParam1, @uParam2, @uParam3, @uParam4, @uParam5, @uParam6, @uParam7, @uParam8, @uParam9 )
      case nParams == 9
         OLESetProperty( ::hObj, cProperty, @uParam1, @uParam2, @uParam3, @uParam4, @uParam5, @uParam6, @uParam7, @uParam8 )
      case nParams == 8
         OLESetProperty( ::hObj, cProperty, @uParam1, @uParam2, @uParam3, @uParam4, @uParam5, @uParam6, @uParam7 )
      case nParams == 7
         OLESetProperty( ::hObj, cProperty, @uParam1, @uParam2, @uParam3, @uParam4, @uParam5, @uParam6 )
      case nParams == 6
         OLESetProperty( ::hObj, cProperty, @uParam1, @uParam2, @uParam3, @uParam4, @uParam5 )
      case nParams == 5
         OLESetProperty( ::hObj, cProperty, @uParam1, @uParam2, @uParam3, @uParam4 )
      case nParams == 4
         OLESetProperty( ::hObj, cProperty, @uParam1, @uParam2, @uParam3 )
      case nParams == 3
         OLESetProperty( ::hObj, cProperty, @uParam1, @uParam2 )
      case nParams == 2
         OLESetProperty( ::hObj, cProperty, @uParam1 )
      otherwise
         MessageBox( 0, "TOleAuto:Set() - Unsupported number of parameter!", "OLE Interface", 0 )
      Return Nil
   end case

   SetOleRefFlags()

   if ::bShowException .AND. Ole2TxtError() == "DISP_E_EXCEPTION"
      oErr := ErrorNew()
      oErr:Args          := { Self, cProperty, @uParam1, @uParam2, @uParam3, @uParam4, @uParam5, @uParam6, @uParam7, @uParam8, @uParam9 }
      oErr:CanDefault    := .F.
      oErr:CanRetry      := .F.
      oErr:CanSubstitute := .T.
      oErr:Description   := OLEExceptionDescription()
      oErr:GenCode       := EG_OLEEXECPTION
      oErr:Operation     := ::cClassName + ":" + cProperty
      oErr:Severity      := ES_ERROR
      oErr:SubCode       := -1
      oErr:SubSystem     := OLEExceptionSource()

      Return Eval( ErrorBlock(), oErr )
   elseif ::bShowException .AND. OleError() != 0
      oErr := ErrorNew()
      oErr:Args          := { Self, cProperty, @uParam1, @uParam2, @uParam3, @uParam4, @uParam5, @uParam6, @uParam7, @uParam8, @uParam9 }
      oErr:CanDefault    := .F.
      oErr:CanRetry      := .F.
      oErr:CanSubstitute := .T.
      oErr:Description   := Ole2TxtError()
      oErr:GenCode       := EG_OLEEXECPTION
      oErr:Operation     := ::cClassName + ":" + cProperty
      oErr:Severity      := ES_ERROR
      oErr:SubCode       := -1
      oErr:SubSystem     := ::cClassName

      Return Eval( ErrorBlock(), oErr )
   end if

Return nil

//--------------------------------------------------------------------

METHOD Get( cProperty, uParam1, uParam2, uParam3, uParam4, uParam5, uParam6, uParam7, uParam8, uParam9 ) CLASS TOleAuto

   local uObj
   local nParams := PCount()
   local oErr

   do case
      case nParams == 10
         uObj := OLEGetProperty( ::hObj, cProperty, @uParam1, @uParam2, @uParam3, @uParam4, @uParam5, @uParam6, @uParam7, @uParam8, @uParam9 )
      case nParams == 9
         uObj := OLEGetProperty( ::hObj, cProperty, @uParam1, @uParam2, @uParam3, @uParam4, @uParam5, @uParam6, @uParam7, @uParam8 )
      case nParams == 8
         uObj := OLEGetProperty( ::hObj, cProperty, @uParam1, @uParam2, @uParam3, @uParam4, @uParam5, @uParam6, @uParam7 )
      case nParams == 7
         uObj := OLEGetProperty( ::hObj, cProperty, @uParam1, @uParam2, @uParam3, @uParam4, @uParam5, @uParam6 )
      case nParams == 6
         uObj := OLEGetProperty( ::hObj, cProperty, @uParam1, @uParam2, @uParam3, @uParam4, @uParam5 )
      case nParams == 5
         uObj := OLEGetProperty( ::hObj, cProperty, @uParam1, @uParam2, @uParam3, @uParam4 )
      case nParams == 4
         uObj := OLEGetProperty( ::hObj, cProperty, @uParam1, @uParam2, @uParam3 )
      case nParams == 3
         uObj := OLEGetProperty( ::hObj, cProperty, @uParam1, @uParam2 )
      case nParams == 2
         uObj := OLEGetProperty( ::hObj, cProperty, @uParam1 )
      case nParams == 1
         uObj := OLEGetProperty( ::hObj, cProperty )
      otherwise
         MessageBox( 0, "TOleAuto:Get() - Unsupported number of parameter!", "OLE Interface", 0 )
         Return NIL
   end case

   if ::bShowException
      if Ole2TxtError() == "DISP_E_EXCEPTION"
         oErr := ErrorNew()
         oErr:Args          := { Self, cProperty, @uParam1, @uParam2, @uParam3, @uParam4, @uParam5, @uParam6 }
         oErr:CanDefault    := .F.
         oErr:CanRetry      := .F.
         oErr:CanSubstitute := .T.
         oErr:Description   := OLEExceptionDescription()
         oErr:GenCode       := EG_OLEEXECPTION
         oErr:Operation     := ::cClassName + ":" + cProperty
         oErr:Severity      := ES_ERROR
         oErr:SubCode       := -1
         oErr:SubSystem     := OLEExceptionSource()

         Return Eval( ErrorBlock(), oErr )
      elseif OleError() != 0
         oErr := ErrorNew()
         oErr:Args          := { Self, cProperty, @uParam1, @uParam2, @uParam3, @uParam4, @uParam5, @uParam6 }
         oErr:CanDefault    := .F.
         oErr:CanRetry      := .F.
         oErr:CanSubstitute := .T.
         oErr:Description   := Ole2TxtError()
         oErr:GenCode       := EG_OLEEXECPTION
         oErr:Operation     := ::cClassName + ":" + cProperty
         oErr:Severity      := ES_ERROR
         oErr:SubCode       := -1
         oErr:SubSystem     := ::cClassName

         Return Eval( ErrorBlock(), oErr )
      end if

      if ValType( uObj ) == 'O'
         uObj:cClassName := Self:cClassName + ':' + cProperty
      end if
   end if

Return uObj

//--------------------------------------------------------------------

METHOD OnError( uParam1, uParam2, uParam3, uParam4, uParam5, uParam6, uParam7, uParam8, uParam9 ) CLASS TOleAuto

   local cMsg := __GetMessage()
   local bPresetShowException := ::bShowException
   local uObj
   local cError
   local nParams := PCount()
   local OleRefFlags := Space( nParams )
   local oErr

   if nParams >= 9
      if HB_ISBYREF( @uParam9 )
         OleRefFlags[9] = 'Y'
      end if
   end if

   if nParams >= 8
      if HB_ISBYREF( @uParam8 )
         OleRefFlags[8] = 'Y'
      end if
   end if

   if nParams >= 7
      if HB_ISBYREF( @uParam7 )
         OleRefFlags[7] = 'Y'
      end if
   end if

   if nParams >= 6
      if HB_ISBYREF( @uParam6 )
         OleRefFlags[6] = 'Y'
      end if
   end if

   if nParams >= 5
      if HB_ISBYREF( @uParam5 )
         OleRefFlags[5] = 'Y'
      end if
   end if

   if nParams >= 4
      if HB_ISBYREF( @uParam4 )
         OleRefFlags[4] = 'Y'
      end if
   end if

   if nParams >= 3
      if HB_ISBYREF( @uParam3 )
         OleRefFlags[3] = 'Y'
      end if
   end if

   if nParams >= 2
      if HB_ISBYREF( @uParam2 )
         OleRefFlags[2] = 'Y'
      end if
   end if

   if nParams >= 1
      if HB_ISBYREF( @uParam1 )
         OleRefFlags[1] = 'Y'
      end if

      SetOleRefFlags( OleRefFlags )
   end if

   ::bShowException := .F.

   if Left( cMsg, 1 ) == '_'
      cMsg := SubStr( cMsg, 2 )

      do case
         case nParams == 9
            uObj := ::Set( cMsg, @uParam1, @uParam2, @uParam3, @uParam4, @uParam5, @uParam6, @uParam7, @uParam8, @uParam9 )
         case nParams == 8
            uObj := ::Set( cMsg, @uParam1, @uParam2, @uParam3, @uParam4, @uParam5, @uParam6, @uParam7, @uParam8 )
         case nParams == 7
            uObj := ::Set( cMsg, @uParam1, @uParam2, @uParam3, @uParam4, @uParam5, @uParam6, @uParam7 )
         case nParams == 6
            uObj := ::Set( cMsg, @uParam1, @uParam2, @uParam3, @uParam4, @uParam5, @uParam6 )
         case nParams == 5
            uObj := ::Set( cMsg, @uParam1, @uParam2, @uParam3, @uParam4, @uParam5 )
         case nParams == 4
            uObj := ::Set( cMsg, @uParam1, @uParam2, @uParam3, @uParam4 )
         case nParams == 3
            uObj := ::Set( cMsg, @uParam1, @uParam2, @uParam3 )
         case nParams == 2
            uObj := ::Set( cMsg, @uParam1, @uParam2 )
         case nParams == 1
            uObj := ::Set( cMsg, @uParam1 )
         case nParams == 0
            uObj := ::Set( cMsg )
         otherwise
            oErr := ErrorNew()
            oErr:Args          := { Self, cMsg, HB_aParams() }
            oErr:CanDefault    := .F.
            oErr:CanRetry      := .F.
            oErr:CanSubstitute := .T.
            oErr:Description   := "Too many paramteres"
            oErr:GenCode       := EG_OLEEXECPTION
            oErr:Operation     := ::cClassName + ":" + cMsg
            oErr:Severity      := ES_ERROR
            oErr:SubCode       := -1
            oErr:SubSystem     := "TOleAuto"
      end case

   else

      do case
         case nParams == 9
            uObj := ::Invoke( cMsg, @uParam1, @uParam2, @uParam3, @uParam4, @uParam5, @uParam6, @uParam7, @uParam8, @uParam9 )
         case nParams == 8
            uObj := ::Invoke( cMsg, @uParam1, @uParam2, @uParam3, @uParam4, @uParam5, @uParam6, @uParam7, @uParam8 )
         case nParams == 7
            uObj := ::Invoke( cMsg, @uParam1, @uParam2, @uParam3, @uParam4, @uParam5, @uParam6, @uParam7 )
         case nParams == 6
            uObj := ::Invoke( cMsg, @uParam1, @uParam2, @uParam3, @uParam4, @uParam5, @uParam6 )
         case nParams == 5
            uObj := ::Invoke( cMsg, @uParam1, @uParam2, @uParam3, @uParam4, @uParam5 )
         case nParams == 4
            uObj := ::Invoke( cMsg, @uParam1, @uParam2, @uParam3, @uParam4 )
         case nParams == 3
            uObj := ::Invoke( cMsg, @uParam1, @uParam2, @uParam3 )
         case nParams == 2
            uObj := ::Invoke( cMsg, @uParam1, @uParam2 )
         case nParams == 1
            uObj := ::Invoke( cMsg, @uParam1 )
         case nParams == 0
            uObj := ::Invoke( cMsg )
         otherwise
            oErr := ErrorNew()
            oErr:Args          := { Self, cMsg, HB_aParams() }
            oErr:CanDefault    := .F.
            oErr:CanRetry      := .F.
            oErr:CanSubstitute := .T.
            oErr:Description   := "Too many paramteres"
            oErr:GenCode       := EG_OLEEXECPTION
            oErr:Operation     := ::cClassName + ":" + cMsg
            oErr:Severity      := ES_ERROR
            oErr:SubCode       := -1
            oErr:SubSystem     := "TOleAuto"
      end case

      if Ole2TxtError() != "S_OK"

         do case
            case nParams == 9
               uObj := ::Get( cMsg, @uParam1, @uParam2, @uParam3, @uParam4, @uParam5, @uParam6, @uParam7, @uParam8, @uParam9 )
            case nParams == 8
               uObj := ::Get( cMsg, @uParam1, @uParam2, @uParam3, @uParam4, @uParam5, @uParam6, @uParam7, @uParam8 )
            case nParams == 7
               uObj := ::Get( cMsg, @uParam1, @uParam2, @uParam3, @uParam4, @uParam5, @uParam6, @uParam7 )
            case nParams == 6
               uObj := ::Get( cMsg, @uParam1, @uParam2, @uParam3, @uParam4, @uParam5, @uParam6 )
            case nParams == 5
               uObj := ::Get( cMsg, @uParam1, @uParam2, @uParam3, @uParam4, @uParam5 )
            case nParams == 4
               uObj := ::Get( cMsg, @uParam1, @uParam2, @uParam3, @uParam4 )
            case nParams == 3
               uObj := ::Get( cMsg, @uParam1, @uParam2, @uParam3 )
            case nParams == 2
               uObj := ::Get( cMsg, @uParam1, @uParam2 )
            case nParams == 1
               uObj := ::Get( cMsg, @uParam1 )
            case nParams == 0
               uObj := ::Get( cMsg )
         end case

      end if

   end if

   ::bShowException := bPresetShowException

   if ::bShowException
      if Ole2TxtError() == "DISP_E_EXCEPTION"
         oErr := ErrorNew()
         oErr:Args          := { Self, cMsg, HB_aParams() }
         oErr:CanDefault    := .F.
         oErr:CanRetry      := .F.
         oErr:CanSubstitute := .T.
         oErr:Description   := OLEExceptionDescription()
         oErr:GenCode       := EG_OLEEXECPTION
         oErr:Operation     := ::cClassName + ":" + cMsg
         oErr:Severity      := ES_ERROR
         oErr:SubCode       := -1
         oErr:SubSystem     := OLEExceptionSource()

         Return Eval( ErrorBlock(), oErr )
      elseif ( cError := Ole2TxtError() ) != "S_OK"
         if cMsg == "END"
            Return OleRelease( ::hObj )
         end if

         oErr := ErrorNew()
         oErr:Args          := { Self, cMsg, HB_aParams() }
         oErr:CanDefault    := .F.
         oErr:CanRetry      := .F.
         oErr:CanSubstitute := .T.
         oErr:Description   := cError
         oErr:GenCode       := EG_OLEEXECPTION
         oErr:Operation     := ::cClassName + ":" + cMsg
         oErr:Severity      := ES_ERROR
         oErr:SubCode       := -1
         oErr:SubSystem     := ::cClassName

         Return Eval( ErrorBlock(), oErr )
      end if

   end if

   if ValType( uObj ) == 'O'
      uObj:cClassName := Self:cClassName + ':' + cMsg
   end if

Return uObj

//--------------------------------------------------------------------
