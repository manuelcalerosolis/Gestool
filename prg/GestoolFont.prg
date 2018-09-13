#include "FiveWin.Ch"
#include "Factu.ch" 

static oFontBold
static oFontTotal
static oFontBigTitle
static oFontLittleTitle

//----------------------------------------------------------------------------//

FUNCTION GetSysFont()

RETURN "Ms Sans Serif"

//----------------------------------------------------------------------------//

FUNCTION oFontLittleTitle()

   // if empty( oFontLittleTitle )
   //    oFontLittleTitle  := TFont():New( GetSysFont(), 6, 12, .f. )
   // end if

RETURN ( TFont():New( GetSysFont(), 6, 12, .f. ) )

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

RETURN ( TFont():New( "Segoe UI Light", 0, -48, .f., .f. ) )

//----------------------------------------------------------------------------//

FUNCTION oFontTotal()

   // if empty( oFontTotal )
   //    oFontTotal        := TFont():New( "Arial", 8, 26, .f., .t. )
   // end if

RETURN ( TFont():New( "Arial", 8, 26, .f., .t. ) )

//----------------------------------------------------------------------------//

FUNCTION oFontBold()

   // if empty( oFontBold )
   //    oFontBold   := TFont():New( GetSysFont(), 0, -8, .f., .t. )
   // end if 

RETURN ( TFont():New( GetSysFont(), 0, -8, .f., .t. ) )

//---------------------------------------------------------------------------//