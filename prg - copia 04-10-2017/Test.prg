#include "FiveWin.Ch"
#include "Outlook.ch"
//--------------------------------------------------------------------------//
function Main()

  LOCAL oDlg
  LOCAL oOut

  LOCAL lVar  := .f.

  DEFINE DIALOG oDlg NAME "Test" TITLE 'Testing TOutLook Class'

    REDEFINE OUTLOOK oOut ;
      ID 100 ;
      OF oDlg ;
      COLOR CLR_WHITE, CLR_BLUE ;
      ON RIGHT CLICK MsgInfo( "RightClick!" )

    DEFINE GROUP OF OUTLOOK oOut PROMPT "&First" ;
      MESSAGE "First folder"

      DEFINE ITEM OF OUTLOOK oOut ;
        PROMPT "&First" ;
        BITMAP "bmp1.bmp" ;
        ACTION MsgInfo( "First" ) ;
        MESSAGE "The first button"

      DEFINE ITEM OF OUTLOOK oOut ;
        PROMPT "&Second" ;
        BITMAP "bmp2.bmp" ;
        ACTION MsgInfo( "Second" ) ;
        WHEN lVar ;
        MESSAGE "The second button"

      DEFINE ITEM OF OUTLOOK oOut ;
        PROMPT "&Third" ;
        BITMAP "bmp3.bmp" ;
        ACTION ( lVar := !lVar, ;
                 MsgInfo( "I am enabling/disabling the second button" ) ) ;
        MESSAGE "The third button"

    DEFINE GROUP OF OUTLOOK oOut PROMPT "&Second" ;
      MESSAGE "Second folder"

      DEFINE ITEM OF OUTLOOK oOut ;
        PROMPT "&First" ;
        BITMAP "bmp1.bmp" ;
        ACTION MsgInfo( "First" ) ;
        MESSAGE "The first button"

    DEFINE GROUP OF OUTLOOK oOut PROMPT "&Third" ;
      MESSAGE "Third folder"

      DEFINE ITEM OF OUTLOOK oOut ;
        PROMPT "&First" ;
        BITMAP "bmp1.bmp" ;
        ACTION MsgInfo( "First" ) ;
        MESSAGE "The first button"

  ACTIVATE DIALOG oDlg CENTERED

return nil
//--------------------------------------------------------------------------//