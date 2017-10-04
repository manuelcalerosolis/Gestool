#include "FiveWin.Ch"
#include "WColors.ch"

#define MF_BYCOMMAND  0
#define MF_ENABLED    0
#define MF_UNCHECKED  0
#define MF_GRAYED     1
#define MF_DISABLED   2
#define MF_CHECKED    8
#define MF_POPUP     16   // 0x0010
#define MF_BREAK     64
#define MF_HELP   16384   // 0x4000

//----------------------------------------------------------------------------//

CLASS TMenuItem

   DATA   cPrompt, cMsg
   DATA   cVarName AS CHARACTER INIT ""
   DATA   nId, nHelpId
   DATA   bAction, bWhen, cWebAction
   DATA   lActive  AS LOGICAL INIT .t.
   DATA   lBreak   AS LOGICAL INIT .f.
   DATA   lChecked AS LOGICAL INIT .f.
   DATA   lHelp    AS LOGICAL INIT .f.
   DATA   oMenu
   DATA   hBmpPal
   DATA   nColorBk
   DATA   nColorText

   CLASSDATA nInitId INIT 20000  // To avoid conflicts with MDI automatic MenuItems

   CLASSDATA aProperties ;
      INIT { "cCaption", "cMsg", "cVarName", "lActive", "lBreak",;
             "lChecked", "nId" }

   CLASSDATA aEvents INIT { "OnActivate", "OnClick" }

   METHOD New( cPrompt, cMsg, lChecked, lActive, bAction, cBmpFile,;
               cResName, nVKState, nVirtKey, lHelp, nHelpId, bWhen,;
               lBreak ) CONSTRUCTOR

   METHOD ReDefine( cPrompt, cMsg, lChecked, lActive, bAction, cBmpFile,;
                    cResName, oMenu, bBlockAction, nId, nVKState,;
                    nVirtKey, nHelpId, bWhen ) CONSTRUCTOR

   METHOD cCaption( cText ) SETGET

   METHOD SetCheck( lOnOff ) INLINE ;
      ::lChecked := lOnOff, CheckMenuItem( ::oMenu:hMenu,;
      ::nId, nOR( MF_BYCOMMAND, If( lOnOff, MF_CHECKED, MF_UNCHECKED ) ) )

   METHOD Enable() INLINE ::lActive := .t.,;
                   EnableMenuItem( ::oMenu:hMenu, ::nId, MF_ENABLED ),;
                   If( ValType( ::bAction ) == "O", ::bAction:Enable(),)

   MESSAGE HelpTopic METHOD __HelpTopic()

   METHOD Disable() INLINE ::lActive := .f.,;
      EnableMenuItem( ::oMenu:hMenu, ::nId, nOR( MF_DISABLED, MF_GRAYED ) ),;
      If( ValType( ::bAction ) == "O", ::bAction:Disable(),)

   METHOD End() INLINE If( ::hBmpPal != 0, DeleteObject( ::hBmpPal ),)

   METHOD SetPrompt( cPrompt )

   METHOD PropCount() INLINE Len( ::aProperties )
   METHOD EveCount()  INLINE Len( ::aEvents )

   METHOD Inspect( cDataName ) VIRTUAL

   METHOD Property( n ) INLINE ::aProperties[ n ]
   METHOD Event( n ) INLINE ::aEvents[ n ]

   METHOD Destroy()

   METHOD Save()
   METHOD Load( cInfo )

   METHOD Refresh() VIRTUAL

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cPrompt, cMsg, lChecked, lActive, bAction, cBmpFile, cResName,;
            nVKState, nVirtKey, lHelp, nHelpId, bWhen, lBreak, nColorBk ) CLASS TMenuItem

   DEFAULT lChecked := .f., lActive := .t., cBmpFile := "",;
           lHelp := .f., lBreak := .f. , nColorBk := RGB( 100,100,100 )

   ::bAction  = bAction
   ::cPrompt  = cPrompt
   ::cMsg     = cMsg
   ::lChecked = lChecked
   ::lActive  = lActive
   ::lHelp    = lHelp
   ::lBreak   = lBreak
   ::hBmpPal  = 0
   ::nHelpId  = nHelpId
   ::bWhen    = bWhen
   ::nColorBk = nColorBk

   #ifdef __XPP__
      ::lActive  = .t.
      ::lBreak   = .f.
      ::lChecked = .f.
      ::lHelp    = .f.
      if ::nInitID == nil
         ::nInitID  = 20000
      endif
   #endif

   while IsMenu( ::nInitId )   // A popup could already own the ID !!!
      ::nInitId++
   end
   ::nId = ::nInitId++

   if ! Empty( cBmpFile ) .and. File( cBmpFile )
      ::hBmpPal = ReadBitmap( 0, cBmpFile )
   endif
   if ! Empty( cResName )
      ::hBmpPal = LoadBitmap( GetResources(), cResName )
   endif

   if nVirtKey != nil
      __AddAccel( nVKState, nVirtKey, ::nId )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD ReDefine( cPrompt, cMsg, lChecked, lActive, bAction, cBmpFile,;
                 cResName, oMenu, bBlockAction, nId, nVKState,;
                 nVirtKey, nHelpId, bWhen ) CLASS TMenuItem

   local oItem

   DEFAULT oMenu := ::oMenu

   if oMenu != nil
      if ( oItem := oMenu:GetMenuItem( nId ) ) != nil
         ::bAction  = oItem:bAction
         ::cPrompt  = oItem:cPrompt
         ::cMsg     = oItem:cMsg
         ::nId      = oItem:nId
         ::lChecked = oItem:lChecked
         ::lActive  = oItem:lActive
         ::lHelp    = oItem:lHelp
         ::hBmpPal  = oItem:hBmpPal
         ::nHelpId  = oItem:nHelpId
         ::oMenu    = oItem:oMenu
         ::bWhen    = oItem:bWhen
      endif
   endif

   if lChecked != nil
      if lChecked != ::lChecked
         ::lChecked = lChecked
         if oMenu != nil .and. nId != nil
            CheckMenuItem( oMenu:hMenu, nId, nOr( MF_BYCOMMAND,;
                           If( lChecked, MF_CHECKED, MF_UNCHECKED ) ) )
         endif
      endif
   endif

   if lActive != nil
      if lActive != ::lActive
         ::lActive = lActive
         if oMenu != nil .and. nId != nil
            EnableMenuItem( oMenu:hMenu, nId, nOr( MF_BYCOMMAND,;
                            If( lActive, MF_ENABLED,;
                            nOr( MF_DISABLED, MF_GRAYED ) ) ) )
         endif
      endif
   endif

   if ! Empty( cPrompt )
      ::SetPrompt( cPrompt )
   endif

   if cMsg != nil
      ::cMsg = cMsg
   endif

   if bAction != nil
      ::bAction = bAction
   endif

   if oMenu != nil
      ::oMenu = oMenu
   endif

   if nHelpId != nil
      ::nHelpId  = nHelpId
   endif

   if bBlockAction != nil
      ::bAction = bBlockAction
   endif

   if bWhen != nil
      ::bWhen = bWhen
   endif

   if ! Empty( cBmpFile )
      ::hBmpPal = ReadBitmap( 0, cBmpFile )
   endif
   if ! Empty( cResName )
      ::hBmpPal = LoadBitmap( GetResources(), cResName )
   endif

   if nVirtKey != nil
      __AddAccel( nVKState, nVirtKey, ::nId )
   endif

   if oItem != nil
      oItem:bAction  = ::bAction
      oItem:cPrompt  = ::cPrompt
      oItem:cMsg     = ::cMsg
      oItem:nId      = ::nId
      oItem:lChecked = ::lChecked
      oItem:lActive  = ::lActive
      oItem:lHelp    = ::lHelp
      oItem:hBmpPal  = ::hBmpPal
      oItem:nHelpId  = ::nHelpId
      oItem:bWhen    = ::bWhen
   endif

return nil

//----------------------------------------------------------------------------//

METHOD SetPrompt( cPrompt ) CLASS TMenuItem

   local nNewId, nFlags

   ::cPrompt = cPrompt

   if ValType( ::bAction ) == "O" .and. ;
      ::bAction:ClassName() == "TMENU"
      nNewId := ::bAction:hMenu
      nFlags := MF_POPUP
   else
      nNewId := ::nId
      nFlags := nOR( If( ::lActive, MF_ENABLED,;
                nOR( MF_DISABLED, MF_GRAYED ) ),;
                If( ::lChecked, MF_CHECKED, 0 ),;
                If( ::lHelp, MF_HELP, 0 ),;
                If( ::lBreak, MF_BREAK, 0 ) )
   endif

   if ::oMenu != nil
      ModifyMenu( ::oMenu:hMenu, ::nId, nFlags, nNewId, cPrompt )

      if ::oMenu:oWnd != nil
         DrawMenuBar( ::oMenu:oWnd:hWnd )
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD __HelpTopic() CLASS TMenuItem

   if Empty( ::nHelpId )
      if ::oMenu != nil
         ::oMenu:HelpTopic()
      else
         HelpIndex()
      endif
   else
      HelpTopic( ::nHelpId )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Destroy() CLASS TMenuItem

   local nAt := AScan( ::oMenu:aItems,;
                       { | oItem | oItem:nId == ::nId } )

   if ValType( ::bAction ) == "O"
      ::bAction:End()
   endif

   if nAt != 0
      ADel( ::oMenu:aItems, nAt )
      ASize( ::oMenu:aItems, Len( ::oMenu:aItems ) - 1 )
   endif

return RemoveMenu( ::oMenu:hMenu, ::nId, MF_BYCOMMAND )

//----------------------------------------------------------------------------//

METHOD Save() CLASS TMenuItem

   local n
   local cType, cInfo := ""
   local oWnd  := &( ::ClassName() + "()" )
   local uData, nProps := 0

   oWnd:New()

   for n = 1 to Len( ::aProperties )
       if ! ( uData := OSend( Self, ::aProperties[ n ] ) ) == ;
          OSend( oWnd, ::aProperties[ n ] )
          cInfo += ( I2Bin( Len( ::aProperties[ n ] ) ) + ;
                     ::aProperties[ n ] )
          nProps++
          cType = ValType( uData )
          do case
             case cType == "A"
                  cInfo += ASave( uData )

             case cType == "O"
                  cInfo += uData:Save()

             otherwise
                  cInfo += ( cType + I2Bin( Len( uData := cValToChar( uData ) ) ) + ;
                             uData )
          endcase
       endif
   next

   oWnd:End()

return "O" + I2Bin( 2 + Len( ::ClassName() ) + 2 + Len( cInfo ) ) + ;
       I2Bin( Len( ::ClassName() ) ) + ;
       ::ClassName() + I2Bin( nProps ) + cInfo

//----------------------------------------------------------------------------//

static function ASave( aArray )

   local n, cType, uData
   local cInfo := ""

   for n = 1 to Len( aArray )
      cType = ValType( aArray[ n ] )
      do case
         case cType == "A"
              cInfo += ASave( aArray[ n ] )

         case cType == "O"
              cInfo += aArray[ n ]:Save()

         otherwise
              cInfo += ( cType + I2Bin( Len( uData := cValToChar( uData ) ) ) + ;
                         uData )
      endcase
   next

return "A" + I2Bin( 2 + Len( cInfo ) ) + I2Bin( Len( aArray ) ) + cInfo

//----------------------------------------------------------------------------//

static function ARead( cInfo )

   local nPos := 1, nLen, n
   local aArray, cType, cBuffer

   nLen   = Bin2I( SubStr( cInfo, nPos, 2 ) )
   nPos  += 2
   aArray = Array( nLen )

   for n = 1 to Len( aArray )
      cType = SubStr( cInfo, nPos++, 1 )
      nLen  = Bin2I( SubStr( cInfo, nPos, 2 ) )
      nPos += 2
      cBuffer = SubStr( cInfo, nPos, nLen )
      nPos += nLen
      do case
         case cType == "A"
              aArray[ n ] = ARead( cBuffer )

         case cType == "O"
              aArray[ n ] = ORead( cBuffer )

         case cType == "C"
              aArray[ n ] = cBuffer

         case cType == "D"
              aArray[ n ] = CToD( cBuffer )

         case cType == "L"
              aArray[ n ] = ( cBuffer == "T" )

         case cType == "N"
              aArray[ n ] = Val( cBuffer )
      endcase
   next

return aArray

//----------------------------------------------------------------------------//

METHOD Load( cInfo ) CLASS TMenuItem

   local nPos := 1, nProps, n, nLen
   local cData, cType, cBuffer

   nProps = Bin2I( SubStr( cInfo, nPos, 2 ) )
   nPos += 2

   for n = 1 to nProps
      nLen  = Bin2I( SubStr( cInfo, nPos, 2 ) )
      nPos += 2
      cData = SubStr( cInfo, nPos, nLen )
      nPos += nLen
      cType = SubStr( cInfo, nPos++, 1 )
      nLen  = Bin2I( SubStr( cInfo, nPos, 2 ) )
      nPos += 2
      cBuffer = SubStr( cInfo, nPos, nLen )
      nPos += nLen
      do case
         case cType == "A"
              OSend( Self, "_" + cData, ARead( cBuffer ) )

         case cType == "O"
              OSend( Self, "_" + cData, ORead( cBuffer ) )

         case cType == "C"
              OSend( Self, "_" + cData, cBuffer )

         case cType == "L"
              OSend( Self, "_" + cData, cBuffer == "T" )

         case cType == "N"
              OSend( Self, "_" + cData, Val( cBuffer ) )
      endcase
   next

return nil

//----------------------------------------------------------------------------//

METHOD cCaption( cText ) CLASS TMenuItem

   if PCount() > 0
      ::SetPrompt( cText )
   else
      return ::cPrompt
   endif

return nil

//----------------------------------------------------------------------------//