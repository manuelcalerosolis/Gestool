*-----------------------------------------------------------------------*
* This functions provide a way to execute 32 Bits Help Files from a FiveWin Application
* under Windows NT.
* The problem is that FiveWin applications are recognized as 16 Bits applications by
* Windows NT, so NT thinks that help file is also 16 bits.
* Vicente Aranzana. 30/09/1.998
* varanzan@gruposp.com
*
*-----------------------------------------------------------------------*
* Notes.
* Those functions will only work under 32 bits environment.
*-----------------------------------------------------------------------*

#include "FiveWin.Ch"

*-----------------------------------------------------------------------*

#define HELP_CONTEXT      1   * 0x0001
#define HELP_QUIT         2   * 0x0002
#define HELP_INDEX        3   * 0x0003
#define HELP_CONTENTS     3   * 0x0003
#define HELP_HELPONHELP   4   * 0x0004
#define HELP_SETINDEX     5   * 0x0005
#define HELP_SETCONTENTS  5   * 0x0005
#define HELP_CONTEXTPOPUP 8   * 0x0008
#define HELP_FORCEFILE    9   * 0x0009
#define HELP_KEY          257 * 0x0101
#define HELP_COMMAND      258 * 0x0102
#define HELP_PARTIALKEY   261 * 0x0105
#define HELP_MULTIKEY     513 * 0x0201
#define HELP_SETWINPOS    515 * 0x0203

#define HELP_FINDER       11 * 0x000b


*-----------------------------------------------------------------------*

function HelpTopic( nHelpId )

   local cHelpFile  := GetHelpFile()
   local cHelpTopic := GetHelpTopic()

   if Empty( cHelpFile )
      MsgStop( "No Help file available", " Attention" )
      return .f.
   endif

   if nHelpId != NIL
      if ValType( nHelpId ) == "N"
         SPWinHelp( GetActiveWindow(), cHelpFile, HELP_CONTEXT, nHelpId )
      else
         *fixed - Jim Gale
         StWinHelp( GetActiveWindow(), cHelpFile, HELP_KEY, nHelpId )
         *fixed - Jim Gale
      endif
   else
      *fixed - Jim Gale
      StWinHelp( GetActiveWindow(), cHelpFile, HELP_KEY, cHelpTopic )
      *fixed - Jim Gale
   endif

return NIL

*-----------------------------------------------------------------------*

function HelpIndex()

   local cHelpFile  := GetHelpFile()

   if Empty( cHelpFile )
      MsgStop( "No Help file available", " Attention" )
      return .f.
   endif

   SPWinHelp( GetActiveWindow(), cHelpFile, HELP_FINDER, 0 )

return NIL

*-----------------------------------------------------------------------*

function HelpSearch( cSearch )

   local cHelpFile  := GetHelpFile()

   DEFAULT cSearch := ""

   if Empty( cHelpFile )
      MsgStop( "No Help file available", " Attention" )
      return .f.
   endif

   *fixed - Jim Gale
   StWinHelp( GetActiveWindow(), cHelpFile, HELP_PARTIALKEY, cSearch )
   *fixed - Jim Gale

return NIL

*-----------------------------------------------------------------------*

function HelpPopup( nHelpId )

   local cHelpFile  := GetHelpFile()

   if Empty( cHelpFile )
      MsgStop( "No Help file available", " Attention" )
      return .f.
   endif

   SPWinHelp( GetActiveWindow(), cHelpFile, HELP_CONTEXTPOPUP, nHelpId )

return NIL

*-----------------------------------------------------------------------*

function WinHelp( cHelpFile, nId, nParams )   * this don't work.

   DEFAULT nId     := HELP_CONTENTS
   DEFAULT nParams := 0

   SPWinHelp( GetActiveWindow(), cHelpFile, nId, nParams )

return NIL

*-----------------------------------------------------------------------*

DLL32 FUNCTION SPWinHelp( HWND AS LONG, cHelpFile AS LPSTR, nId AS LONG,;
     nParams AS LONG );
     AS BOOL PASCAL FROM "WinHelpA" LIB "User32.dll"

*added to support strings - Jim Gale
DLL32 FUNCTION StWinHelp( HWND AS LONG, cHelpFile AS LPSTR, nId AS LONG,;
     cSearch AS LPSTR );
     AS BOOL PASCAL FROM "WinHelpA" LIB "User32.dll"
*added to support strings - Jim Gale