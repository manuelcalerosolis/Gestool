// FiveWin ActiveX support (32/64 bits only)
// (c) FiveTech Software, todos los derechos reservados

#include "FiveWin.ch"

#define  HKEY_CLASSES_ROOT       2147483648

//----------------------------------------------------------------------------//

CLASS TActiveX FROM TControl

   CLASSDATA lRegistered AS LOGICAL

   DATA   hActiveX
   DATA   cProgID
   DATA   cString
   DATA   aProperties, aMethods, aEvents
   DATA   bOnEvent
   DATA   oOleAuto

   METHOD New( oWnd, cProgID, nRow, nCol, nWidth, nHeight ) CONSTRUCTOR

   METHOD ReDefine( nId, oWnd, cProgID ) CONSTRUCTOR

   METHOD Do( cMethodName, uParam1, uParam2, uParam3, uParam4, uParam5 )

   METHOD Display() INLINE ::BeginPaint(), ::Paint(), ::EndPaint(), 0

   METHOD EraseBkGnd( hDC ) INLINE 1

   METHOD GetProp( cPropName ) INLINE __ObjSendMsg( ::oOleAuto, cPropName )

   METHOD Initiate( hDlg )

   METHOD OnEvent( nEvent, aParams )

   METHOD ReadTypes()

   METHOD ReSize( nFlags, nWidth, nHeight ) INLINE ;
             ActXSetLocation( ::hActiveX, 0, 0, nWidth, nHeight )

   METHOD SetProp( cPropName, uParam1 ) INLINE __ObjSendMsg( ::oOleAuto, cPropName, uParam1 )

   METHOD Destroy() INLINE ActXEnd( ::hActiveX ), Super:Destroy()

   ERROR HANDLER OnError( uParam1 )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oWnd, cProgID, nRow, nCol, nWidth, nHeight ) CLASS TActiveX

   DEFAULT oWnd := GetWndDefault(), nRow := 0, nCol := 0, nWidth := 200,;
           nHeight := 200

   ::nTop    = nRow
   ::nLeft   = nCol
   ::nBottom = nRow + nHeight
   ::nRight  = nCol + nWidth
   ::oWnd    = oWnd
   ::nId     = ::GetNewId()
   ::nStyle  = nOR( WS_CHILD, WS_VISIBLE, WS_TABSTOP )
   ::cProgID = cProgID
   ::cString = ActXString( cProgID )

   ::Register()

   if ! Empty( oWnd:hWnd )
      ::Create()
      oWnd:AddControl( Self )
      ::hActiveX = CreateActiveX( ::hWnd, cProgID, Self )
      ::oOleAuto = TOleAuto():New( ActXPdisp( ::hActiveX ) )
      ::nTop = nRow
      ::nLeft = nCol
      ::nWidth = nWidth
      ::nHeight = nHeight
      ::ReadTypes()
   else
      oWnd:DefControl( Self )
   endif

return Self

//----------------------------------------------------------------------------//

METHOD Do( ... ) CLASS TActiveX

#ifndef __XHARBOUR__
   return __ObjSendMsg( ::oOleAuto, ... )
#else
   local aParams := hb_aParams()

   AIns( aParams, 1, ::oOleAuto, .T. )

   return hb_execFromArray( @__ObjSendMsg(), aParams )
#endif

//----------------------------------------------------------------------------//

METHOD ReDefine( nId, oWnd, cProgID ) CLASS TActiveX

   DEFAULT oWnd := GetWndDefault()

   ::nId     = nId
   ::oWnd    = oWnd
   ::cProgID = cProgID
   ::cString = ActXString( cProgID )

   ::Register( nOR( CS_VREDRAW, CS_HREDRAW ) )

   oWnd:DefControl( Self )

return Self

//----------------------------------------------------------------------------//

METHOD Initiate( hDlg ) CLASS TActiveX

   Super:Initiate( hDlg )

   ::hActiveX = CreateActiveX( ::hWnd, ::cProgID, Self )
   ::oOleAuto = TOleAuto():New( ActXPdisp( ::hActiveX ) )
   ::ReadTypes()

return nil

//----------------------------------------------------------------------------//

METHOD OnEvent( nEvent, aParams ) CLASS TActiveX

   local nAt := AScan( ::aEvents, { | aEvent | aEvent[ 2 ] == nEvent } )
   local cEvent := If( nAt != 0, ::aEvents[ nAt ][ 1 ], "" )

   if ! Empty( ::bOnEvent )
      Eval( ::bOnEvent, If( ! Empty( cEvent ), cEvent, nEvent ), aParams )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD ReadTypes() CLASS TActiveX

   local oReg := TReg32():New( HKEY_CLASSES_ROOT, "CLSID\" + ::cString + "\InprocServer32" )
   local cTypeLib := oReg:Get( "" )

   oReg:Close()

   if ! Empty( cTypeLib ) .and. File( cTypeLib )
      ::aEvents = ActXEvents( cTypeLib, ::hActiveX )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD OnError( ... ) CLASS TActiveX

#ifndef __XHARBOUR__
   return __ObjSendMsg( ::oOleAuto, __GetMessage(), ... )
#else
   local aParams := hb_aParams()

   AIns( aParams, 1, ::oOleAuto, .T. )
   AIns( aParams, 2, __GetMessage(), .T. )

   return hb_execFromArray( @__ObjSendMsg(), aParams )
#endif

//----------------------------------------------------------------------------//
