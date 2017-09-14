**************************************************************************
*                                                                        *
*  Descripción: Clase TOleAuto()                                         *
*                                                                        *
*  Autor: José F. Giménez (JFG) - jfgimenez@wanadoo.es                   *
*                                 tecnico.sireinsa@ctv.es                *
*  Fecha: 6-11-2000                                                      *
*                                                                        *
*  Nota: basado en la clase TComObj() de FW 2.1                          *
*                                                                        *
**************************************************************************


#include "FiveWin.Ch"


CLASS TOleAuto

   DATA hObj

   METHOD New( cAutoObj ) CONSTRUCTOR
   METHOD End()

   METHOD Invoke( cMember, uParam1, uParam2, uParam3 )
   METHOD Set( cProperty, uParam1, uParam2, uParam3 )
   METHOD Get( cProperty, uParam1, uParam2, uParam3 )

   ERROR HANDLER OnError( cMsg, nError )

ENDCLASS

//--------------------------------------------------------------------

METHOD New( uObj ) CLASS TOleAuto

   IF ValType( uObj )="C"
      ::hObj := CreateOleObject( uObj )
   ELSE
      ::hObj := uObj
   ENDIF

RETURN Self

//--------------------------------------------------------------------

METHOD End() CLASS TOleAuto

   ::hObj := NIL

   OLEUninitialize()

RETURN NIL

//--------------------------------------------------------------------

METHOD Invoke( cMethod, uParam1, uParam2, uParam3 ) CLASS TOleAuto

   LOCAL uObj

   IF uParam3 != NIL
      uObj := OLEInvoke( ::hObj, cMethod, uParam1, uParam2, uParam3 )
   ELSEIF uParam2 != NIL
      uObj := OLEInvoke( ::hObj, cMethod, uParam1, uParam2 )
   ELSEIF uParam1 != NIL
      uObj := OLEInvoke( ::hObj, cMethod, uParam1 )
   ELSE
      uObj := OLEInvoke( ::hObj, cMethod )
   ENDIF

   IF OleIsObject()
      RETURN TOleAuto():New( uObj )
   ELSEIF OleError() != 0
      msgStop( "No existe el miembro: "+cMethod, "OLE Error" )
   ENDIF

RETURN uObj

//--------------------------------------------------------------------

METHOD Set( cProperty, uParam1, uParam2, uParam3 ) CLASS TOleAuto

   LOCAL uObj

   IF uParam3 != NIL
      OLESetProperty( ::hObj, cProperty, uParam1, uParam2, uParam3 )
   ELSEIF uParam2 != NIL
      OLESetProperty( ::hObj, cProperty, uParam1, uParam2 )
   ELSEIF uParam1 != NIL
      OLESetProperty( ::hObj, cProperty, uParam1 )
   ENDIF

RETURN nil

//--------------------------------------------------------------------

METHOD Get( cProperty, uParam1, uParam2, uParam3 ) CLASS TOleAuto

   LOCAL uObj

   IF uParam3 != NIL
      uObj := OLEGetProperty( ::hObj, cProperty, uParam1, uParam2, uParam3 )
   ELSEIF uParam2 != NIL
      uObj := OLEGetProperty( ::hObj, cProperty, uParam1, uParam2 )
   ELSEIF uParam1 != NIL
      uObj := OLEGetProperty( ::hObj, cProperty, uParam1 )
   ELSE
      uObj := OLEGetProperty( ::hObj, cProperty )
   ENDIF

   IF OleError() != 0
      uObj := ::Invoke( cProperty, uParam1, uParam2, uParam3 )
   ENDIF

   IF OleIsObject()
      RETURN TOleAuto():New( uObj )
   ELSEIF OleError() != 0
      msgStop( "No existe el miembro: "+cProperty+CRLF+CRLF+ ;
                "o el valor de retorno no está soportado.", "OLE Error" )
   ENDIF

RETURN uObj

//--------------------------------------------------------------------

METHOD OnError( cMsg, nError ) CLASS TOleAuto

   LOCAL uObj
   LOCAL uParam1 := GetParam( 1, 1 )
   LOCAL uParam2 := GetParam( 1, 2 )
   LOCAL uParam3 := GetParam( 1, 3 )

   IF LEFT( cMsg, 1 ) == '_'
      ::Set( SUBS( cMsg, 2 ), uParam1, uParam2, uParam3 )
   ELSE
      uObj := ::Get( cMsg, uParam1, uParam2, uParam3 )
   ENDIF

RETURN uObj