/*
  Copyright 1999 Jos‚ Lal¡n Ferreiro <dezac@corevia.com>

  -[History]-----------------------------------------------------------
  Date            Author              Changes
  ---------------------------------------------------------------------
  Mar 24, 1999    Jos‚ Lal¡n          + Initial Release
  Mar 27, 1999                        + Added GetInfo() method
  Jan  5, 2000                        + Added GetDefault() method
  Nov  3, 2000                        + Changed to work in all windows flavours
                                      ! Bug corrected in aPrinters initialization
  Nov  5, 2000    Jos‚ Lal¡n          + Added GetDriver method
                                      + Added SetDefault method
  Nov 12, 2000    Jos‚ Lal¡n          + Fixed to ignore empty entries in New()
                                      ! Changed GetDriver. Now gets driver from win.ini
                                        It should work fine in all platforms now
  Nov 14, 2000    Jos‚ Lal¡n          + First release for betatesters
*/
//--------------------------------------------------------------------------//
#include "FiveWin.Ch"
#include "Objects.ch"
#include "Dll.ch"

#define HKEY_CLASSES_ROOT        2147483648
#define HKEY_CURRENT_USER        2147483649
#define HKEY_LOCAL_MACHINE       2147483650
#define HKEY_USERS               2147483651
#define HKEY_PERFORMANCE_DATA    2147483652
#define HKEY_CURRENT_CONFIG      2147483653
#define HKEY_DYN_DATA            2147483654

#define HWND_BROADCAST  65535   /* ((HWND)0xffff) */
//#define WM_WININICHANGE 26      /* 0x001A */
/*
function Test()

  LOCAL oPrn  := TPrinters():New()
  LOCAL cStr  := ""
  LOCAL aData
  LOCAL cName
  LOCAL i, nLen

  nLen := Len( oPrn:aPrinters )

  if nLen > 0
    AEval( oPrn:aPrinters, {|cName| cStr += cName + CRLF } )
    msgStop( cStr, "TPrinters" )

    for i := 1 to nLen
      cName := oPrn:aPrinters[i]
      aData := oPrn:GetInfo( cName )
      cStr  := ""
      AEval( aData, {|cValue| cStr += if( !Empty( cValue ), cValue, "<empty>" ) + CRLF } )
      msgStop( cName + CRLF + CRLF + cStr, cName )
    next

    for i := 1 to nLen
      cName := oPrn:aPrinters[i]
      oPrn:SetDefault( cName )
      msgStop( "Check if " + cName + " is the default printer." )
    next

    cStr := ""
    for i := 1 to nLen
      cStr += oPrn:GetDriver( oPrn:aPrinters[i] ) + CRLF
    next
    msgStop( cStr, "Drivers List" )

  endif

return nil
*/

//--------------------------------------------------------------------------//
CLASS TPrinters

  DATA oReg PROTECTED

  DATA aPrinters

  METHOD New() CONSTRUCTOR
  METHOD End() VIRTUAL

  METHOD GetDefault()               INLINE PrnGetName()
  METHOD SetDefault( cPrnName )

  METHOD GetDriver( cPrnName )
  METHOD GetInfo( cPrnName )

ENDCLASS
//--------------------------------------------------------------------------//
METHOD New() CLASS TPrinters

  LOCAL oKey
  LOCAL cTemp := ""
  LOCAL i     := 0

  ::aPrinters := {}

  ::oReg := TReg32():New( HKEY_LOCAL_MACHINE, ;
      "System\CurrentControlSet\Control\Print\Printers" )

    while RegEnumKeys( ::oReg:nHandle, i++, @cTemp ) == 0

      if !Empty( cTemp )
        oKey := TReg32():New( HKEY_LOCAL_MACHINE, ;
                "System\CurrentControlSet\Control\Print\Printers\" + cTemp )

        aAdd( ::aPrinters, oKey:Get( "Name" ) )
        oKey:Close()
      endif

    end

  ::oReg:Close()

return Self
//--------------------------------------------------------------------------//
METHOD GetInfo( cPrnName ) CLASS TPrinters

  LOCAL aPrn  := {}

  ::oReg := TReg32():New( HKEY_LOCAL_MACHINE, ;
      "System\CurrentControlSet\Control\Print\Printers\" + cPrnName )

  /* TODO:
     Some datas are commented cause need to be parsed.
     I will do that when I get more info about them
  */

  aAdd( aPrn, ::oReg:Get( "Name" ) )
  aAdd( aPrn, ::oReg:Get( "Description" ) )
  aAdd( aPrn, ::oReg:Get( "Port" ) )
  aAdd( aPrn, ::oReg:Get( "Print Processor" ) )
  aAdd( aPrn, ::oReg:Get( "Printer Driver" ) )
  aAdd( aPrn, ::oReg:Get( "Datatype" ) )
  aAdd( aPrn, ::oReg:Get( "Share Name" ) )
  aAdd( aPrn, ::oReg:Get( "Location" ) )
  //aAdd( aPrn, ::oReg:Get( "Parameters" ) )
  //aAdd( aPrn, ::oReg:Get( "Separator File" ) )
  //aAdd( aPrn, ::oReg:Get( "Status" ) )
  //aAdd( aPrn, ::oReg:Get( "Default DevMode" ) )
  //aAdd( aPrn, ::oReg:Get( "Attributes" ) )
  //aAdd( aPrn, ::oReg:Get( "Priority" ) )
  //aAdd( aPrn, ::oReg:Get( "StartTime" ) )
  //aAdd( aPrn, ::oReg:Get( "UntilTime" ) )

  ::oReg:Close()

/*
  ::oReg := TReg32():New( HKEY_LOCAL_MACHINE, ;
      "System\CurrentControlSet\Control\Print\Printers\" + cPrnName + "\PrinterDriverData" )
    aAdd( aPrn, ::oReg:Get( "PrinterID" ) )
  ::oReg:Close()
*/

return aPrn
//--------------------------------------------------------------------------//
METHOD GetDriver( cPrnName )

  LOCAL cDriver := ""

/* Gracias al amigo Gates no podemos recuperar esta informaci¢n del registro
   porque el NT pone la lista de drivers en diferentes ramas como:

      Windows NT x86\Drivers\Version-2
      Windows NT x86\Drivers\Version-3 (en W2K)

    ::oReg := TReg32():New( HKEY_LOCAL_MACHINE, ;
        "System\CurrentControlSet\Control\Print\Environments\Windows 4.0\Drivers\" + cPrnName )
      cDriver := ::oReg:Get( "Driver" )
    ::oReg:Close()

    cDriver := SubStr( cDriver, 1, At( ".", cDriver ) - 1 )
*/

  cDriver := GetProfString( "PrinterPorts", cPrnName, "" )
  cDriver := StrToken( cDriver, 1, "," )

return cDriver
//--------------------------------------------------------------------------//

METHOD SetDefault( cPrnName ) CLASS TPrinters

  LOCAL cStr    := ""
  LOCAL aData   := ::GetInfo( cPrnName )

  /* cStr -> "Name, Driver, Port" */
  cStr := aData[1] + "," + ::GetDriver( cPrnName ) + "," + aData[3]
  WriteProfString( "Windows", "Device", cStr )

  WinIniChanged()
  PrinterInit()

return cPrnName
//--------------------------------------------------------------------------//
/* Notify Windows when win.ini changes */
static function WinIniChanged()

  SendMessage( HWND_BROADCAST, WM_WININICHANGE, 0, "Windows" )
  SysRefresh()

return nil
//--------------------------------------------------------------------------//