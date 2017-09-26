/*
Nota :
FW posee varias funcione para manejar objetos OLE.
OLESetProperty(), OLEGetProperty y OLEInvoke()

El problema es al anidar metodos y propiedades que no pueden ser anidadas es decir
 OLEInvoke( hExcel, "WorkBooks.Add" ) no va tenemos que hacer
 hWork := OleGetProperty( hExcel, "WorkBooks" ) y despues OleInvoke( hWork, "Add" )

*/

#include "FiveWin.Ch"
#include "objects.ch"
#include "wcolors.ch"

CLASS OutLook

   DATA hOutLook        PROTECTED
   DATA hMapi           PROTECTED
   DATA hFolder         PROTECTED
   DATA hNameSpace      PROTECTED
   DATA hAddressLists   PROTECTED

   METHOD New()         CONSTRUCTOR
   METHOD SetFolder()

END CLASS

//---------------------------------------------------------------------------//
/*
Asistente para la generación de graficos
*/

METHOD New() CLASS TOutLook

   ::hOutLook     := CreateOLEObject( "Outlook.Application" )
   SetProperty( ::hOutLook, "GetNameSpace", "MAPI" )
   SetProperty( ::hOutLook, "GetDefaultFolder", "olFolderInbox" )
   OleInvoke( ::hOutLook, "Display" )

/*
Trato de hacer esto que esta en VB

Set myOlApp = CreateObject("Outlook.Application")
Set myNameSpace = myOlApp.GetNameSpace("MAPI")
Set myFolder= _myNameSpace.GetDefaultFolder(olFolderInbox)
myFolder.Display
*/

RETURN Self

//---------------------------------------------------------------------------//

METHOD SetFolder() CLASS TOutLook

   SetProperty( ::hMapi, "DisplayFolders", 1 )

RETURN nil

//---------------------------------------------------------------------------//

function GetProperty( hOle, cProperty )

   local p

   if hOle  != NIL

      if ( p :=At( '.', cProperty ) ) > 0

         return GetProperty( OLEGetProperty( hOle, Left( cProperty, p - 1 ) ), Subs( cProperty, p + 1) )

      end if

      return OLEGetProperty( hOle, cProperty )

   end if

return nil

//---------------------------------------------------------------------------//

function SetProperty( hOle, cProperty, u1, u2, u3, u4, u5 )

   local p

   if ( p :=At( '.', cProperty ) ) > 0

      return  SetProperty( OLEGetProperty( hOle, Left( cProperty, p - 1 ) ), Subs( cProperty, p + 1 ), u1, u2, u3, u4, u5 )

   end if

   if  u1 = nil
      return OLESetProperty( hOle, cProperty )
   elseif u2 = nil
      return OLESetProperty( hOle, cProperty, u1 )
   elseif u3 = nil
      return OLESetProperty( hOle, cProperty, u1, u2 )
   elseif u4 = nil
      return OLESetProperty( hOle, cProperty, u1, u2, u3 )
   elseif u5 = nil
      return OLESetProperty( hOle, cProperty, u1, u2, u3, u4 )
   end if

return OLESetProperty( hOle, cProperty, u1, u2, u3, u4, u5 )

//---------------------------------------------------------------------------//

function lOutLook()

   local oOutLook

   oOutLook   := TOutLook():New()

return nil