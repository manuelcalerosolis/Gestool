#include "FiveWin.ch"

CREATE CLASS WebMap
   VAR aAddress
   VAR nZoomLevel
   VAR cMapType    // 'MAP' = regular map, 'ROUTE' = route
   VAR oIe
   VAR cLink
   VAR cWhatsNear
   METHOD New
   METHOD ShowMap
   METHOD ShowMapInWin
   METHOD AddStop
   METHOD AddStopSep
   METHOD GenLink
END CLASS

METHOD New( xAddress, nZoomLevel )
   if nZoomLevel == nil
      // default to 0 for auto calc size
      ::nZoomLevel := 0
   else
      ::nZoomLevel := nZoomLevel
   endif
   ::cLink := ''
   ::cWhatsNear := ''
   // Initialize address array
   do case
      case xAddress == nil
         ::aAddress := {}
      case valtype( xAddress ) == 'A'
         ::aAddress := xAddress
      otherwise
         ::aAddress := { xAddress }
   endcase
RETURN( self )

//////////////////////////////////////////
////// Method ShowMap
//////////////////////////////////////////
// Purpose - To demonstrate map dislay in
//           full windows window
METHOD ShowMap()

   ::GenLink()

   if .not. empty( ::cLink )
      ShellExecute( 0, "open", ::cLink,,, 5 )
      sysrefresh()
   endif

RETURN nil

//////////////////////////////////////////
////// Method ShowMapInWin
//////////////////////////////////////////
// Purpose - To demonstrate map dislay in
//           Fivewin window
//
METHOD ShowMapInWin()

   local oWnd, oActiveX, oBar
   local cEvents := ""

   ::GenLink()

   if .not. empty( ::cLink )

      DEFINE WINDOW oWnd TITLE "Google Map Demo in Fivewin window" ;
         FROM 0, 0 TO 600, 800 pixel

      ::oIe          := TActiveX():New( oWnd, "Shell.Explorer" )

      oWnd:oClient   := ::oIe // To fill the entire window surface

      // these setprop options do not work?
      ::oIe:SetProp( "Visible", .T. )
      ::oIe:SetProp( "Toolbar", .T. )
      ::oIe:SetProp( "Statusbar", .T. )
      ::oIe:SetProp( "MenuBar", .T. )
      ::oIe:Do( "Navigate", ::cLink )
      sysrefresh()

      ACTIVATE WINDOW oWnd

      sysrefresh()

   endif

RETURN nil

//////////////////////////////////////////
////// Method AddStop
//////////////////////////////////////////
// Purpose - To add a pre-formatted address
//            to ::aAddress
//
METHOD AddStop( cAddress )
   if cAddress != nil
      // convert spaces to +
      aadd( ::aAddress, strtran( trim( cAddress ),' ', '+' ) )
   endif
RETURN nil

//////////////////////////////////////////
////// Method AddStopSep
//////////////////////////////////////////
// Purpose - To add an address to ::aAddress
//           when you have seperate street,
//           city, zip etc that need to be
//           formated into Google Map format
// Note - You can format address yourself or just
//        type address string like in google maps
//        using :AddStop() instead of :AddStopSep()
//
METHOD AddStopSep( cStreet, cCity, cState, cZip, cCountry )
   local cAddr2
   default cStreet := '', ;
      cCity := '', ;
      cState := '', ;
      cZip := '', ;
      cCountry := ''

   cAddr2 := ltrim( trim( cCity )+' ' )
   cAddr2 += ltrim( trim( cState )+' ' )
   cAddr2 += ltrim( trim( cZip )+' ' )
   cAddr2 += ltrim( trim( cCountry ) )
   if at( ',', cAddr2 ) > 0
      // Remove commas from this portion of address
      cAddr2 := strtran( cAddr2,',', ' ' )
      // Remove extra spaces if any
      cAddr2 := strtran( cAddr2,'  ', ' ' )
   endif
   do case
      case .not. empty( cStreet ) .and. .not. empty( cAddr2 )
         ::AddStop( trim( cStreet)+', '+cAddr2 )
      case empty( cStreet ) .and. .not. empty( cAddr2 )
         ::AddStop( cAddr2 )
      case .not. empty( cStreet ) .and. empty( cAddr2 )
         ::AddStop( trim( cStreet) )
   endcase
RETURN nil

//////////////////////////////////////////
////// Method GenLink
//////////////////////////////////////////
// Purpose - To generate link string that
//           can be passed to Internet Explorer
//           Shell or link string can be emailed
METHOD GenLink()

   local nCounter, nFor
   local cLink

   cLink := 'http://maps.google.com/maps?'

   do case
      case len( ::aAddress ) = 0
         // this will just display country map
         ::cMapType := 'MAP'
      case len( ::aAddress ) > 1
         // must be route so update map type
         ::cMapType := 'ROUTE'
      otherwise
         ::cMapType := 'MAP'
   endcase

   for nFor := 1 to len( ::aAddress )
      do case
         case nFor = 1
            if ::cMapType = 'ROUTE'
               cLink += 'saddr='+::aAddress[ nFor ]
            else
               // In order to use info near address
               // Must be in map mode and not route mode
               if empty( ::cWhatsNear )
                  cLink += 'q='+::aAddress[ nFor ]
               else
                  cLink += 'q='+::cWhatsNear
                  cLink += chr(38)+'near='+::aAddress[ nFor ]
               endif
            endif
         case nFor = 2
            cLink += chr(38)+'daddr='+::aAddress[ nFor ]
         otherwise
            cLink += ',+to:'+::aAddress[ nFor ]
      endcase

   next

   if .not. empty( cLink )
      if ::nZoomLevel > 0
         cLink += chr(38)+'z='+ltrim( str( ::nZoomLevel ) )
      endif
   endif

   ::cLink := cLink

RETURN( ::cLink )