#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Ini.ch"

//---------------------------------------------------------------------------//

CLASS TCajon

   CLASSDATA lCreated                  AS LOGIC INIT .f.

   DATA  cPrinter
   DATA  cApertura                     INIT ""

   METHOD New( cApertura, cPrinter )   CONSTRUCTOR

   METHOD Open()
   METHOD OpenTest()                   INLINE ( ::Open() )

   METHOD End()                        VIRTUAL

END CLASS

//---------------------------------------------------------------------------//

METHOD New( cApertura, cPrinter ) CLASS TCajon

   DEFAULT cApertura    := "27 112 0 60 240"
   DEFAULT cPrinter     := ""

   ::cApertura          := cApertura
   ::cPrinter           := cPrinter

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Open()

   PrintEscCode( ::cApertura, ::cPrinter )

RETURN ( nil )

//---------------------------------------------------------------------------//

FUNCTION PrintEscCode( cEscCode, cPrinter )

   local nResult
   local cFile    := "EscFile.txt"

   if memowrit( cFile, alltrim( retChr( cEscCode ) ) )
      nResult     := win_printFileRaw( alltrim( cPrinter ), cFile )
      fErase( cFile )
   end if 

RETURN ( nil )

//--------------------------------------------------------------------------//