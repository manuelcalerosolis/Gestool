// FontTest.Prg

#include "FiveWin.Ch"

STATIC oWnd

//---------------------------------------------------------------------------//

FUNCTION Main()

  DEFINE WINDOW oWnd TITLE "Font Names Test"

  ACTIVATE WINDOW oWnd ;
    MAXIMIZED ;
    ON INIT ShowFonts()

RETURN NIL

//---------------------------------------------------------------------------//

FUNCTION ShowFonts()

  LOCAL oDlg
  LOCAL oFontNames, aFontNames, cFontName := "Arial"
  LOCAL oBtn
  LOCAL hDC := oWnd:GetDC()

  IF hDC > 0
    IF EMPTY( aFontNames := GetFontNames( hDC ) )
      msgStop( "Error getting font names" )
    ELSE
      ASORT( aFontNames,,, { |x, y| UPPER( x ) < UPPER( y ) } )
    ENDIF
  ELSE
    msgStop( "Error creating DC" )
  ENDIF

  DEFINE DIALOG oDlg ;
      OF oWnd ;
      FROM 10, 10 TO 20, 60 ;
      TITLE "System Font List"

  @ 1.25, 1 SAY "Font List" ;
      OF oDlg

  @ 2, 1 COMBOBOX oFontNames ;
      VAR cFontName ;
      ITEMS aFontNames ;
      SIZE 180, 100 ;
      OF oDlg

  @ 5, 19 BUTTON oBtn ;
      PROMPT "Cancel" ;
      OF oDlg ;
      ACTION oDlg:End()

  ACTIVATE DIALOG oDlg ;
    CENTERED

RETURN NIL