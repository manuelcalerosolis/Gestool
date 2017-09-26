#include "FiveWin.Ch"

#define N_OK      550
#define N_NEXT    519
#define N_SHOWTIP 104

static oGhost
static hBmpFondo

//-------------------------------------------------------------------------//

FUNCTION TipOfDay( cIniFile, lShow )

   local cMessage
   local cTip := "Tip"
   local oDlg
   local oText
   local lNext
   local nNextTip
   local nTotals

	DEFAULT lShow := .f.

   if !file(cIniFile) .or. empty(cIniFile)
		return nil
	endif

	cIniFile	:= FullCurDir() + cIniFile

	if !lShow .and. ;
		( Val( GetPvProfString( "Options", "ShowTip", "1", cIniFile ) ) ) == 0
		return nil
	else
		lNext := .t.
	endif

	nTotals  := Val(GetPvProfString("Total Tips","Total Tips","0",cIniFile))
   nNextTip := Val(GetPvProfString("Next Tip","TipNo","0",cIniFile))
	cTip     +=  ltrim(str(nNextTip))
	cMessage := GetPvProfString("Tips", ( cTip ), "Error", cIniFile )

   nNextTip += 1
   if nNextTip > nTotals
      nNextTip := 1
   endif

   if nTotals < nNextTip
		WritePProString("Next Tip", "TipNo", "1", cIniFile)
	else
		WritePProString("Next Tip", "TipNo", ltrim( str( nNextTip ) ), cIniFile )
	endif

	DEFINE DIALOG oDlg  NAME "TIPS"

   REDEFINE CHECKBOX lNext  ID N_SHOWTIP  ;
      ON CHANGE ShowMyTip(lNext,cIniFile) ;
      OF oDlg

	REDEFINE BUTTON ID N_OK  OF oDlg  ACTION oDlg:End()

   REDEFINE BUTTON ID N_NEXT OF oDlg ACTION NextTip(nNextTip,cIniFile,oText)

   REDEFINE GET oText VAR cMessage ID 103 OF oDlg MEMO READONLY

   ACTIVATE DIALOG oDlg CENTERED ON PAINT ( PutFondo( oDlg ) )

	if !WritePProString( "Next Tip", "TipNo", ltrim(str(nNextTip)), cIniFile)
		MsgStop("Writing to tips textfile","Internal error Tips-111")
	endif

return nil

//--------------------------------------------------------------------------//

static function NextTip( nNextTip, cIniFile, oText )

   local nTotals
   local cMessage
   local cTip := "Tip"

   nNextTip := Val(GetPvProfString("Next Tip","TipNo","0",cIniFile))
   cTip     += ltrim(str(nNextTip))
   cMessage := GetPvProfString("Tips", cTip, "", cIniFile)

   if empty(cMessage)
      cMessage := "Internal error occured #Tips-121"  // whatever...
   endif

   oText:cText := cMessage
   oText:Refresh()
   nNextTip += 1

   nTotals  := Val(GetPvProfString("Total Tips","Total Tips","0",cIniFile))

   if nNextTip > nTotals
      nNextTip := 1
   endif

   if nTotals < nNextTip
      WritePProString("Next Tip", "TipNo", "1",cIniFile)
   else
      WritePProString("Next Tip", "TipNo", ltrim(str(nNextTip)),cIniFile)
   endif

return nil

//--------------------------------------------------------------------------//

Static Function ShowMyTip( lNext, cIniFile )

   if !lNext
      WritePProString("Options", "ShowTip","0", cIniFile)
   else
      WritePProString("Options", "ShowTip","1", cIniFile)
	endif

return nil

//--------------------------------------------------------------------------//

function PutFondo( oDlg )

   local hDC
   local cBmpFondo   := "logo.bmp"

   if empty( oGhost )
      DEFINE BRUSH oGhost STYLE "NULL"
   endif

   if !empty( cBmpFondo ) .and. empty( hBmpFondo )

      hDC         := oDlg:GetDC()
      hBmpFondo   := PalBmpRead( hDC, cBmpFondo )

      if hBmpFondo != 0
         PalBmpNew( hDC, hBmpFondo )
      endif

      oDlg:ReleaseDC()

   endif

return nil

//---------------------------------------------------------------------------//

function GetTransp()
return oGhost:hBrush

function ReleaseFondo()

if !empty( hBmpFondo )
   DeleteObject( hBmpFondo )
endif

if !empty( oGhost )
   oGhost:End()
endif

return nil

function hFondo()
return hBmpFondo

function __lFondo()
return !empty( hBmpFondo )

function nRes()

local nW := GetSysMetrics(0)
local nRet

do case
   case nW > 1000
        nRet := 1
   case nW > 700
        nRet := 2
   otherwise
        nRet := 3
endcase

return nRet










