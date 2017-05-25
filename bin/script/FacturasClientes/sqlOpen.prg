Function SqlOpen()

   local cStatement     := ""
   local cFecha

   cFecha               := AllTrim( Str( Year( GetSysDate() - 30 ) ) ) + "-"
   cFecha               += Rjust( AllTrim( Str( month( GetSysDate() - 30 ) ) ), "0", 2 ) + "-"
   cFecha               += Rjust( AllTrim( Str( day( GetSysDate() - 30 ) ) ), "0", 2 )

   cStatement           := "SELECT * FROM " + cPatEmp() + "FacCliT WHERE ( NOT lLiquidada ) OR ( dFecFac > '" + cFecha + "' )"

   logwrite( cStatement )

Return ( cStatement )

//---------------------------------------------------------------------------//