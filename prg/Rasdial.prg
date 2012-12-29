#include "FiveWin.Ch"
#include "DLL.ch"
#include "Struct.ch"

#define RAS_MaxEntryName      256
#define RAS_MaxPhoneNumber    128
#define RAS_MaxCallbackNumber RAS_MaxPhoneNumber

#define RAS_MaxDeviceType     16
#define RAS_MaxDeviceName     128

#define UNLEN                 256                 // Maximum user name length
#define PWLEN                 256                 // Maximum password length
#define CNLEN                 15                  // Computer name length
#define DNLEN                 CNLEN               // Maximum domain name length

#define RASCS_DONE            8192
#define RASCS_Connected       RASCS_DONE
#define RASCS_Disconnected    RASCS_DONE+1

#define NOTIFIER_TYPE_NONE    4294967295        // 0xFFFFFFFF
#define RASDIALPARMS_SIZE     1052
#define RASCONNSTATUS_SIZE    160
#define RASENTRYNAME_SIZE     264

#define SUCCESS               0

#define GET_ERROR_MSG    iif(LoadString( GetResources(), nError ) == '','Unknown Error '+str(nError),LoadString( GetResources(), nError ) )

Static oTimer,nOldStatus


*****************************************
Function Ras_Dial(cEntry,cUser,cPass,lServer)

Local oDlg,oSay,oBtn,hRas,oIco

DEFAULT lServer := .f.

DEFINE DIALOG oDlg RESOURCE "RASWAIT" TITLE "Connecting to "+cEntry

REDEFINE ICON oIco  ID 1055 OF oDlg
REDEFINE SAY oSay PROMPT 'Initializing...' ID 1053 OF oDlg
REDEFINE BUTTON  oBtn ID 1054 OF oDlg ACTION Dial(cEntry,cUser,cPass,oDlg,oSay,oBtn)
REDEFINE BUTTON  ID    2 OF oDlg ACTION  (Ras_Hangup(hRas),oDlg:End(),oTimer:end(),hRas := 0)

ACTIVATE DIALOG oDlg CENTER ON INIT InitTimer(cEntry,cUser,cPass,oDlg,oSay,oBtn,lServer,@hRas,oIco) // start the dialing process

Return(hRas)


*****************************************
Static Function InitTimer(cEntry,cUser,cPass,oDlg,oSay,oBtn,lServer,hRas,oIco)

   static nFrame := 1
   static nDirection := 1
   local nError

   nError := Dial(cEntry,cUser,cPass,oDlg,oSay,oBtn,@hRas) // start the dialing process
   if nError == SUCCESS

      DEFINE TIMER  oTimer OF oDlg INTERVAL 450 ACTION (GetStatus(oDlg,oSay,oBtn,lServer,hRas),RASPWincr(@nFrame,@nDirection,oIco) )
      ACTIVATE TIMER oTimer

   else
      oDlg:end()
      MsgInfo( GET_ERROR_MSG )
      hRas := 0
   endif

return nil


*****************************************
Static Function Dial(cEntry,cUser,cPass,oDlg,oSay,oBtn,hRas)

local RasStruct

EnableWindow( oDlg:GetItem(oBtn:nID), .f. )

hRas := 0      // initialize these before dialing
nOldStatus := 0

   struct RasStruct
    MEMBER nSize      AS DWORD
    MEMBER szEntry    AS STRING LEN RAS_MaxEntryName+1
    MEMBER szPhone    AS STRING LEN RAS_MaxPhoneNumber+1
    MEMBER szCallb    AS STRING LEN RAS_MaxCallbackNumber+1
    MEMBER szUser     AS STRING Len UNLEN+1
    MEMBER szPass     AS STRING Len PWLEN+1
    MEMBER szDomain   AS STRING Len DNLEN+1
   endstruct

   RasStruct:nSize := RASDIALPARMS_SIZE   // thanks andy

   RasStruct:szEntry := cEntry+chr(0)
   RasStruct:szUser  := cUser+chr(0)
   RasStruct:szPass  := cPass+chr(0)

Return( Ras_DialER(,,RasStruct:cBuffer,NOTIFIER_TYPE_NONE,oDlg:hWnd,@hRas) )

DLL32 FUNCTION RAS_DIALER (    cDialExt as LPSTR,;
                            cPPhoneBook as LPSTR,;
                                Rstruct AS LPSTR,;
                                  nType as DWORD,;
                                   hWnd as DWORD,;
                                   @hRas as PTR );  // thanks andy
                   AS DWORD PASCAL ;
                   FROM "RasDialA" LIB "rasapi32.dll"


*****************************************
Static Function GetStatus( oDlg, oSay, oBtn, lServer, hRas )

local RasConnStat,cBuffer,nError

oTimer:DeActivate()      // pause the timer

struct RasConnStat
  MEMBER nSize      AS DWORD
  MEMBER nStatus    AS DWORD
  MEMBER nError     AS DWORD
  MEMBER szDevType  AS STRING LEN RAS_MaxDeviceType+1
  MEMBER szDevName  AS STRING LEN RAS_MaxDeviceName+1
endstruct

RasConnStat:nSize := RASCONNSTATUS_SIZE

cBuffer := RasConnStat:cBuffer

nError := RAS_STATUS(hRas,@cBuffer)

if nError != SUCCESS
   Ras_Hangup(hRas)
   hRas := 0
   oDlg:end()
   oTimer:end()
   MsgInfo( GET_ERROR_MSG )
   return nil
endif

RasConnStat:cBuffer := cBuffer

if RasConnStat:nStatus != nOldStatus   // only display if changed
   oSay:SetText( PADR( LoadString( GetResources(),RasConnStat:nStatus ), 50 ) )
   nOldStatus := RasConnStat:nStatus
endif

if RasConnStat:nStatus == RASCS_Connected
   oDlg:end()
   oTimer:end()
   return nil
endif

if RasConnStat:nStatus == RASCS_Disconnected
   if lServer
      Ras_Hangup(hRas)
      hRas := 0
      oDlg:end()
      oTimer:end()
      return nil
   endif
   EnableWindow( oDlg:GetItem(oBtn:nID), .t. )
endif

oTimer:Activate()    // start the timer back up

Return nil


***************************************************
Static Function RASPWincr(nFrame,nDirection,oIco)

Do Case
   Case nDirection = 1 .And. nFrame < 4
      nFrame++
   Case nDirection = 1 .And. nFrame >= 4
      nFrame--
      nDirection = -1
   Case nDirection = -1 .And. nFrame > 1
      nFrame--
   Case nDirection = -1 .And. nFrame <= 1
      nFrame++
      nDirection = 1
EndCase

oIco:SetName( 'RAS' + AllTrim( Str( nFrame ) ) )

Return nil

***************************************
Function EditEntry(cEntry)

local cEntries := ""
local nSize := 0
local nRasindex := 0
local nRasCount := 0
local RasEntry
local lFoundIt := .f.
local nError

struct RasEntry
 MEMBER nSize      AS DWORD
 MEMBER szEntry    AS STRING LEN RAS_MaxEntryName+1
endstruct

RasEntry:nSize := RASENTRYNAME_SIZE

cEntries := RasEntry:cBuffer

if (RAS_ENUM(,,@cEntries,@nSize, @nRAScount ) != 0)

   cEntries := REPLICATE( RasEntry:cBuffer, nRASCount )  // thanks andy

   nError := RAS_ENUM(,,@cEntries,@nSize, @nRAScount )
   if nError != SUCCESS
      MsgInfo( GET_ERROR_MSG )
   endif
endif

for nRasIndex = 1 to nRasCount
   if left(substr(cEntries,((nRasIndex-1)*RASENTRYNAME_SIZE)+5,RASENTRYNAME_SIZE-4),len(trim(cEntry))) == trim(cEntry)
      lFoundIt := .t.
      exit
   endif
next

if lFoundIt
   nError := EDIT_ENTRY(GetActiveWindow(),,cEntry)    // get an error in NT if not found
   if nError != SUCCESS
      MsgInfo( GET_ERROR_MSG )
   endif
else
   cEntry := ""
   nError := ADD_ENTRY(GetActiveWindow())

   if nError == SUCCESS

      cEntries := RasEntry:cBuffer

      if (RAS_ENUM(,, @cEntries,@nSize, @nRAScount ) != 0 ) // first time to get nSize

         cEntries := REPLICATE( RasEntry:cBuffer, nRASCount )

         nError := RAS_ENUM(,, @cEntries,@nSize, @nRAScount )
         if nError != 0
            MsgInfo( GET_ERROR_MSG )
         endif
      endif

      // get the last entry to return the name

      RasEntry:cBuffer := substr(cEntries,((nRasCount-1)*RASENTRYNAME_SIZE)+1,RASENTRYNAME_SIZE)
      cEntry := left(RasEntry:szEntry,at(chr(0),RasEntry:szEntry)-1)
   else
      MsgInfo( GET_ERROR_MSG )
   endif
endif

return(cEntry)


***************************************

DLL32 FUNCTION RAS_STATUS ( hRas as DWORD, ;
                        @Rstruct AS LPSTR);
                   AS DWORD PASCAL ;
                   FROM "RasGetConnectStatusA" LIB "rasapi32.dll"

DLL32 FUNCTION RAS_HANGUP ( hRas as DWORD );
                   AS DWORD PASCAL ;
                   FROM "RasHangUpA" LIB "rasapi32.dll"

DLL32 FUNCTION EDIT_ENTRY (        hWnd as DWORD,;
                            cPphoneBook as LPSTR,;
                                cEntry  AS LPSTR);
                   AS DWORD PASCAL ;
                   FROM "RasEditPhonebookEntryA" LIB "rasapi32.dll"

DLL32 FUNCTION ADD_ENTRY (        hWnd as DWORD,;
                            cPphoneBook as LPSTR);
                   AS DWORD PASCAL ;
                   FROM "RasCreatePhonebookEntryA" LIB "rasapi32.dll"


DLL32 FUNCTION RAS_ENUM (   cReserved as LPSTR,;
                          cPphoneBook as LPSTR,;
                              @cEntry AS LPSTR,;
                               @nSize AS PTR,;
                            @nEntries AS PTR);
                   AS DWORD PASCAL ;
                   FROM "RasEnumEntriesA" LIB "rasapi32.dll"

























