//----------------------------------------------------------------------------//
//  AUTOR.....: Manuel Exp¢sito Su rez    Soft 4U '1994-2001                  //
//  e-Mail....: maex14@dipusevilla.es                                         //
//  CLASE.....: TDbf                                                          //
//  FECHA MOD.: 24/01/2002                                                    //
//  VERSION...: 11.00                                                         //
//  PROPOSITO.: Gesti¢n y control de DBFs                                     //
//----------------------------------------------------------------------------//

#include "Obj2Hb.ch"

//----------------------------------------------------------------------------//

CLASS TDbError

    DATA oDbf AS OBJECT
    DATA o    AS OBJECT

    METHOD New() CONSTRUCTOR
    METHOD Exec()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oDbf ) CLASS TDbError


    ::o := ErrorNew()
    ::oDbf := oDbf

    ::o:canSubstitute := .t.
    ::o:fileName      := ::oDbf:cFile
    ::o:severity      := 2
    ::o:subSystem     := "TDbf"

return( Self )

//----------------------------------------------------------------------------//

METHOD Exec( cDec, nError, lDef ) CLASS TDbError

   DEFAULT cDec     := "Error no definido"
   DEFAULT nError   := 0
   DEFAULT lDef     := .f.

   ::o:Description  := cDec
   ::o:SubCode      := nError
   ::o:CanDefault   := lDef

return( eval( ErrorBlock(), self:o ) )

//----------------------------------------------------------------------------//

