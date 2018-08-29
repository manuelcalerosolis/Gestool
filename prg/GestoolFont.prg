#include "FiveWin.Ch"
#include "Factu.ch" 

static oFontBold
static oFontTotal
static oFontBigTitle
static oFontLittleTitle

//----------------------------------------------------------------------------//

FUNCTION oFontLittleTitle()

   if empty( oFontLittleTitle )
      oFontLittleTitle  := TFont():New( "Ms Sans Serif", 6, 12, .f. )
   end if

RETURN ( oFontLittleTitle )

//----------------------------------------------------------------------------//

FUNCTION oFontLittleTitleEnd()

   if !empty( oFontLittleTitle )
      oFontLittleTitle:end()
   end if

   oFontLittleTitle     := nil

RETURN ( nil )

//----------------------------------------------------------------------------//

FUNCTION oFontBigTitle()

   // if empty( oFontBigTitle )
   //    oFontBigTitle     := TFont():New( "Segoe UI Light", 0, -48, .f., .f. )
   // end if

RETURN ( nil )

//----------------------------------------------------------------------------//

FUNCTION oFontTotal()

   if empty( oFontTotal )
      oFontTotal        := TFont():New( "Arial", 8, 26, .f., .t. )
   end if

RETURN ( oFontTotal )

//----------------------------------------------------------------------------//

FUNCTION oFontBold()

   // if empty( oFontBold )
   //    oFontBold   := TFont():New( "Ms Sans Serif", 0, -8, .f., .t. )
   // end if 

RETURN ( nil )

//---------------------------------------------------------------------------//
