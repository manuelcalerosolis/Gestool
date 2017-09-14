#include "FiveWin.ch"
#include "Struct.ch"
#include "constant.ch"
#include "wcolors.ch"

#ifdef __XPP__
   #define Super ::TControl
   #define New _New
#endif

#define GDTR_MIN     0x1
#define GDTR_MAX     0x2

#define MCN_FIRST           (-750)
#define MCN_SELCHANGE       (MCN_FIRST + 1)
#define MCN_GETDAYSTATE     (MCN_FIRST + 3)

//colors defines
#define MCSC_BACKGROUND         0
#define MCSC_TEXT               1
#define MCSC_TITLEBK            2
#define MCSC_TITLETEXT          3
#define MCSC_MONTHBK            4
#define MCSC_TRAILINGTEXT       5

//Get month range
#define GMR_VISIBLE             0
#define GMR_DAYSTATE            1

#define MCS_DAYSTATE            1
#define MCS_MULTISELECT         2
#define MCS_WEEKNUMBERS         4

#define GWL_STYLE       -16

#ifdef __CLIPPER__
   #define MCS_NOTODAY          8
#else
   #define MCS_NOTODAYCIRCLE    8
   #define MCS_NOTODAY         16
#endif

#define WIDTHDBLCLICK  GetSysMetrics( 36 )
#define HEIGHTDBLCLICK GetSysMetrics( 37 )
#define DATEFORMAT "dd/mm/yyyy"
#define ISSTYLE
//----------------------------------------------------------------------------//

CLASS TCalendar FROM TControl

   CLASSDATA lRegistered

   DATA cDateFormat

   DATA pSystemDate
   DATA pDateRange
   DATA bSetGet2
   DATA bOnGetState
   DATA dDate, dDateEnd, lMultiselect
   DATA lBtnUp, lPressed
   DATA aDayState
   DATA lWeekNumbers
   DATA lNoTodayCircle
   DATA lNoToday
   DATA lDayState

   DATA lDblClick
   DATA bAction
   DATA nDelay
   DATA nRowDbl, nColDbl
   DATA oTimerDbl

   METHOD New( nRow, nCol, bSetGet, bSetGet2, oWnd, nWidth, nHeight, bValid, nClrFore,;
               nClrBack, oFont, lDesign, oCursor, lPixel, cMsg, lUpdate, lMultiselect,;
               bWhen, bChange, nHelpId) CONSTRUCTOR

   METHOD ReDefine( nId, bSetGet, bSetGet2,oWnd, nHelpId, cMsg, lUpdate, lMultiselect, bWhen, bValid) CONSTRUCTOR

   METHOD Change()

   METHOD Changed() INLINE ( If(::lMultiselect,( ::GetDateRange(),;
                                                 Eval( ::bSetGet, ::dDate ),;
                                                 Eval( ::bSetGet2, ::dDateEnd )  ) ,;
                                                 ( ::GetDate(),;
                                                   Eval( ::bSetGet, ::dDate ) ) ),;
                             ::Change() )

   METHOD cToChar() INLINE Super:cToChar( "SysMonthCal32" )

   METHOD EraseBkGnd( hDC )

   METHOD GetArrayDatesRange()

   METHOD GetColors( nFlags )        INLINE MonthCal_GetColor( ::hWnd, nFlags ) // see setcolor functions

   METHOD GetDate()

   METHOD GetDateRange()

   METHOD GetFirstDayOfWeek()        INLINE nLoWord( MonthCal_GetFirstDayOfWeek( ::hWnd ) )

   METHOD GetMaxSelCount()           INLINE MonthCal_GetMaxSelCount( ::hWnd )

   METHOD GetMonthRange( nFlags )

   METHOD GetRange()

   METHOD GetSystemDate()

   METHOD GetToday()

   METHOD GetVisibleMonths()         INLINE MonthCal_GetMonthRange( ::hWnd, GMR_VISIBLE )

   METHOD Initiate( hDlg )

   METHOD Notify( nIdCtrl, nPtrNMHDR )

   METHOD Display() INLINE ::BeginPaint(), ::Paint(), ::EndPaint(), 0

   METHOD Paint()

   METHOD Refresh() INLINE If( ::lMultiselect, ::SetDateRange(Eval( ::bSetGet ), Eval( ::bSetGet2 ) ),;
                                               ::SetDate( Eval( ::bSetGet ) ) )

   METHOD RestoreDateFormat()        INLINE Set( _SET_DATEFORMAT, ::cDateFormat )

   METHOD ResetDayStates()           INLINE ::aDayState := Array( ::GetVisibleMonths(), 31 )

   METHOD SetArrayDayState( nMonth, nDay )

   METHOD SetDate( dDate )

   METHOD SetDateRange( dDateIni, dDateEnd )

   METHOD SetDayState()              INLINE SetDayState( ::hWnd, ::aDayState )

   METHOD SaveDateFormat()           INLINE ::cDateFormat := Set( _SET_DATEFORMAT ), Set( _SET_DATEFORMAT, DATEFORMAT )

   METHOD SetBackGround( nColor )    INLINE ::SetColor( MCSC_BACKGROUND, nColor )

   METHOD SetFirstDayOfWeek( nDay )  INLINE MonthCal_SetFirstDayOfWeek( ::hWnd, nDay )

   METHOD SetMaxSelCount( nDays )    INLINE  If( nDays == NIL, nDays := 1, ), MonthCal_SetMaxSelCount( ::hWnd, nDays )

   METHOD SetMaxRange( dDate )

   METHOD SetMinRange( dDate )

   METHOD SetMonthBk( nColor )       INLINE ::SetColor( MCSC_MONTHBK, nColor )

   METHOD SetRange( dDateStart, dDateEnd, nFlags )

   METHOD SetStructs()

   METHOD SetSystemDate( dDate )

   METHOD SetColor( nFlags, nColor ) INLINE MonthCal_SetColor( ::hWnd, nFlags, nColor )

   METHOD SetTextClr( nColor )       INLINE ::SetColor( MCSC_TEXT, nColor )

   METHOD SetTitleBk( nColor )       INLINE ::SetColor( MCSC_TITLEBK, nColor )

   METHOD SetTitleText( nColor )     INLINE ::SetColor( MCSC_TITLETEXT, nColor )

   METHOD SetToday( dDate )

   METHOD SetTrailingText( nColor )  INLINE ::SetColor( MCSC_TRAILINGTEXT, nColor )

   METHOD SetWeekNumbers( lOnOff )   INLINE If( lOnOff != NIL, ;
                                                ( __ChangeStyleWindow( ::hWnd, MCS_WEEKNUMBERS, , lOnOff ), ::lWeekNumbers := lOnOff ),;
                                                ::lWeekNumbers )

   METHOD SetNoTodayCircle( lOnOff ) INLINE If( lOnOff != NIL, ;
                                                ( __ChangeStyleWindow( ::hWnd, MCS_NOTODAYCIRCLE, , lOnOff ), ::lNoTodayCircle := lOnOff ),;
                                                ::lNoTodayCircle )

   METHOD SetNoToday( lOnOff )       INLINE If( lOnOff != NIL, ;
                                                ( __ChangeStyleWindow( ::hWnd, MCS_NOTODAY, , lOnOff ), ::lNoToday := lOnOff ),;
                                                ::lNoToday )

   METHOD SetDayStateStyle( lOnOff )

   METHOD KeyChar( nKey, nFlags )

   METHOD LostFocus( hCtrl )

   METHOD GetDlgCode( nLastKey )

   METHOD KeyDown( nKey, nFlags )

   METHOD LButtonUp( nRow, nCol, nFlags )

   METHOD LButtonDown( nRow, nCol, nFlags )

   METHOD Destroy() INLINE Super:Destroy(), ::oTimerDbl:End()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, bSetGet, bSetGet2, oWnd, nWidth, nHeight, bValid, nClrFore,;
            nClrBack, oFont, lDesign, oCursor, lPixel, cMsg, lUpdate, lMultiselect,;
            bWhen, bChange, nHelpId, bAction, bLDblClick, lWeekNumbers, lNoTodayCircle, lNoToday, lDayState ) Class TCalendar

   LOCAL oSelf := Self

   DEFAULT nRow     := 0, nCol := 0,;
           oWnd     := GetWndDefault(),;
           nWidth   := 185 + If( lWeekNumbers, 15, 0 ),;
           nHeight  := If( oFont != NIL, oFont:nHeight*8, 150 ),;
           nClrFore := GetSysColor( COLOR_CAPTIONTEXT ),;
           nClrBack := GetSysColor( COLOR_ACTIVECAPTION ),;
           oFont    := oWnd:oFont,;
           nHelpId  := 100,;
           lDesign  := .F.,;
           lPixel   := .F.,;
           lUpdate  := .F.,;
           lMultiselect := .F.,;
           lWeekNumbers := .F.,;
           lNoTodayCircle := .F.,;
           lNoToday := .F.,;
           lDayState := .F.


   ::nTop         = nRow * If( ! lPixel, BTN_CHARPIX_H, 1 )
   ::nLeft        = nCol * If( ! lPixel, BTN_CHARPIX_W, 1 )
   ::nBottom      = ::nTop  + nHeight
   ::nRight       = ::nLeft + nWidth
   ::nHelpId      = nHelpId
   ::oWnd         = oWnd
   ::oFont        = oFont
   ::bSetGet      = bSetGet
   ::bSetGet2     = bSetGet2
   ::lMultiselect = lMultiselect

   ::nStyle       = nOR( WS_CHILD, WS_VISIBLE, WS_TABSTOP,;
                         If( lDayState, MCS_DAYSTATE, 0 ),;
                         If( lWeekNumbers, MCS_WEEKNUMBERS, 0 ),;
                         If( lNoTodayCircle, MCS_NOTODAYCIRCLE, 0 ),;
                         If( lNoToday, MCS_NOTODAY, 0 ),;
                         If( lDesign, WS_CLIPSIBLINGS, 0 ),;
                         If( lMultiselect, MCS_MULTISELECT,0 ) )

   ::nId          = ::GetNewId()
   ::lDrag        = lDesign
   ::lCaptured    = .f.
   ::cMsg         = cMsg
   ::lUpdate      = lUpdate
   ::bWhen        = bWhen
   ::bValid       = bValid
   ::bChange      = bChange
   ::dDate        := Eval(::bSetGet)
   ::bAction      = bAction
   ::bLDblClick   = bLDblClick
   if ::lMultiselect
      ::dDateEnd  = Eval(::bSetGet2)
   endif

   ::SetStructs()
   ::lWeekNumbers   = lWeekNumbers
   ::lNoTodayCircle = lNoTodayCircle
   ::lNoToday       = lNoToday
   ::lDayState      = lDayState

   ::lDblClick      = .F.

   InitCommon()

   if ! Empty( oWnd:hWnd )
      ::Create( "SysMonthCal32" )
      oWnd:AddControl( Self )
      if oFont != NIL
         ::SetFont( oFont )
      endif
   else
      oWnd:DefControl( Self )
   endif

   if lDesign
      ::CheckDots()
   endif

   if ::lMultiselect
      ::SetDateRange( ::dDate,::dDateEnd )
   else
      ::SetDate(::dDate)
   endif

   ::SetTitleText( nClrFore )
   ::SetTitleBk( nClrBack )

   ::GetDate()
   ::nDelay    = GetTimeDblClick()
   ::aDayState = Array( ::GetVisibleMonths(), 31 )

   DEFINE TIMER ::oTimerDbl INTERVAL ::nDelay OF ::oWnd;
          ACTION ( oSelf:lDblClick := .F., oSelf:oTimerDbl:Deactivate() )


RETURN Self

//----------------------------------------------------------------------------//

METHOD ReDefine( nId, bSetGet, bSetGet2, oWnd, nHelpId, nClrFore, nClrBack,;
                 oFont, oCursor, cMsg, lUpdate, lMultiselect, bWhen, bValid, bChanged, bAction, bLDblClick ) Class TCalendar


   LOCAL oSelf        := Self

   DEFAULT oWnd         := GetWndDefault(),;
           nClrFore     := GetSysColor( COLOR_WINDOWTEXT ),;
           nClrBack     := GetSysColor( COLOR_WINDOW ),;
           lUpdate      := .F.,;
           lMultiselect := .F.


   ::nId          = nId
   ::hWnd         = 0
   ::nHelpId      = nHelpId
   ::oWnd         = oWnd
   ::oFont        = oFont
   ::oCursor      = oCursor
   ::lCaptured    = .F.
   ::lDrag        = .F.
   ::cMsg         = cMsg
   ::lUpdate      = lUpdate
   ::bWhen        = bWhen
   ::bValid       = bValid
   ::bSetGet      = bSetGet
   ::bSetGet2     = bSetGet2
   ::lMultiselect = lMultiselect
   ::bChange      = bChanged
   ::dDate        = Eval(::bSetGet)
   ::bAction      = bAction
   ::bLDblClick   = bLDblClick

   ::nDelay := GetTimeDblClick()
   ::lDblClick = .F.

   ::SetStructs()

   InitCommon()

   ::Register()

   oWnd:DefControl( Self )

RETURN Self

//---------------------------------------------------------------------------//

METHOD Change() CLASS TCalendar

   if ::bChange != NIL
      Eval( ::bChange, Self )
   endif

RETURN NIL

//----------------------------------------------------------------------------//

METHOD EraseBkGnd( hDC ) CLASS TCalendar

   DEFAULT ::lTransparent := .f.

   if IsAppThemed() .or. ::lTransparent
      return 1
   endif

return Super:EraseBkGnd( hDC )

//----------------------------------------------------------------------------//

METHOD GetDlgCode( nLastKey ) CLASS TCalendar

   if .not. ::oWnd:lValidating
      if nLastKey == VK_RETURN .or. nLastKey == VK_TAB
         ::oWnd:nLastKey = nLastKey
      endif
   endif

RETURN DLGC_WANTALLKEYS

//---------------------------------------------------------------------------//

METHOD GetArrayDatesRange() CLASS TCalendar

   LOCAL aDates := { , }, dDate

   dDate =  StrZero( ::pDateRange:nDay1, 2) + "/" +;
            StrZero( ::pDateRange:nMonth1, 2) +"/" +;
            StrZero( ::pDateRange:nYear1, 4)

   aDates[ 1 ] := CToD( dDate )

   dDate =  StrZero( ::pDateRange:nDay2, 2) + "/" +;
            StrZero( ::pDateRange:nMonth2, 2) +"/" +;
            StrZero( ::pDateRange:nYear2, 4)

   aDates[ 2 ] := CToD( dDate )

RETURN aDates

//---------------------------------------------------------------------------//

METHOD GetDate() CLASS TCalendar
   LOCAL cDate

   ::SaveDateFormat()

   IF MonthCal_GetCurSel( ::hWnd, ::pSystemDate:cBuffer )

      ::dDate := ::GetSystemDate()

   ENDIF

   ::RestoreDateFormat()

RETURN ::dDate


//---------------------------------------------------------------------------//

METHOD GetMonthRange( nFlags ) CLASS TCalendar

   LOCAL dDate, aDates
   LOCAL nMonths

   DEFAULT nFlags := GMR_VISIBLE

   ::SaveDateFormat()

   nMonths := MonthCal_GetMonthRange( ::hWnd, nFlags, ::pDateRange:cBuffer )

   aDates = ::GetArrayDatesRange()

   ::dDate   := aDates[ 1 ]
   ::dDateEnd:= aDates[ 2 ]

   ::RestoreDateFormat()

RETURN aDates

//---------------------------------------------------------------------------//

METHOD GetSystemDate() CLASS TCalendar

   LOCAL cDate

   cDate := StrZero( ::pSystemDate:nDay, 2) + "/" +;
            StrZero( ::pSystemDate:nMonth, 2) +"/" +;
            StrZero( ::pSystemDate:nYear, 4)

RETURN CToD( cDate )

//---------------------------------------------------------------------------//

METHOD GetRange() CLASS TCalendar
   LOCAL dDate, aDates := { , }

   ::SaveDateFormat()

   MonthCal_GetRange( ::hWnd, ::pDateRange:cBuffer )
   aDates = ::GetArrayDatesRange()

   ::RestoreDateFormat()

RETURN aDates

//---------------------------------------------------------------------------//

METHOD GetToday() CLASS TCalendar
   LOCAL dDate

   ::SaveDateFormat()

   MonthCal_GetToday( ::hWnd, ::pSystemDate:cBuffer )

   dDate = ::GetSystemDate()

   ::RestoreDateFormat()

RETURN dDate


//---------------------------------------------------------------------------//

METHOD GetDateRange() CLASS TCalendar
   LOCAL dDate, aDates

   ::SaveDateFormat()

   MonthCal_GetSelRange( ::hWnd, ::pDateRange:cBuffer )

   aDates = ::GetArrayDatesRange()

   ::dDate   := aDates[ 1 ]
   ::dDateEnd:= aDates[ 2 ]

   ::RestoreDateFormat()

RETURN aDates

//----------------------------------------------------------------------------//

METHOD Initiate( hDlg ) Class TCalendar
   local oSelf := Self
   LOCAL nStyle

   Super:Initiate( hDlg )

   nStyle           = GetWindowLong( ::hWnd, GWL_STYLE )
   ::lWeekNumbers   = lAnd( nStyle, MCS_WEEKNUMBERS )
   ::lNoTodayCircle = lAnd( nStyle, MCS_NOTODAYCIRCLE )
   ::lNoToday       = lAnd( nStyle, MCS_NOTODAY )
   ::lDayState      = lAnd( nStyle, MCS_DAYSTATE )
   ::lMultiselect   = ::lMultiselect .OR. lAnd( nStyle, MCS_MULTISELECT )

   if ::lMultiselect
      ::dDateEnd  = Eval(::bSetGet2)
      ::SetDateRange( ::dDate, ::dDateEnd )
   else
      ::SetDate(::dDate)
   endif


   ::aDayState = Array( ::GetVisibleMonths(), 31 )

   ::GetDate()

   DEFINE TIMER ::oTimerDbl INTERVAL ::nDelay OF ::oWnd;
          ACTION ( oSelf:lDblClick := .F., oSelf:oTimerDbl:Deactivate() )

RETURN NIL

//---------------------------------------------------------------------------//

METHOD KeyChar( nKey, nFlags ) CLASS TCalendar

   if nKey == VK_RETURN
      ::oWnd:GoNextCtrl( ::hWnd )
      RETURN 0
   endif

RETURN Super:KeyChar( nKey, nFlags )

//----------------------------------------------------------------------------//

METHOD KeyDown( nKey, nFlags ) CLASS TCalendar

   IF Empty( ::dDate )
      ::dDate := Eval( ::bSetGet )
   ENDIF

   do case
      case nKey == VK_RETURN
         if ::bAction != NIL
            Eval( ::bAction, Self )
         endif
   endcase

RETURN Super:KeyDown( nKey, nFlags )

//----------------------------------------------------------------------------//

METHOD LButtonDown( nRow, nCol, nFlags ) CLASS TCalendar

   if ::lDrag
      RETURN Super:LButtonDown( nRow, nCol, nFlags )
   endif

   if !::lFocused
      ::SetFocus()
   endif

   if ! ::lCaptured

      ::lCaptured = .t.
      ::Capture()

      IF ! ::lDblClick .and. IsOverDay( ::hWnd, nRow, nCol )
         ::nRowDbl   = nRow
         ::nColDbl   = nCol
      ENDIF

   endif

   Super:LButtonDown( nRow, nCol, nFlags )

RETURN NIL

//----------------------------------------------------------------------------//

METHOD LButtonUp( nRow, nCol, nFlags ) CLASS TCalendar

   local nPos

   if ::lDrag
      RETURN Super:LButtonUp( nRow, nCol, nFlags )
   endif

   if ::lCaptured

      ::lCaptured = .f.
      ReleaseCapture()

      ::lBtnUp := .T.

      IF ! ::lDblClick
         ::lDblClick = .T.
         ::oTimerDbl:Activate()
      ELSE
         IF IsOverDay( ::hWnd, nRow, nCol ) .AND. Abs( ::nRowDbl - nRow  ) <= HEIGHTDBLCLICK .AND. Abs( ::nColDbl - nCol ) <= WIDTHDBLCLICK
         MsgBeep()
            IF ::bLDblClick != NIL
               ::oTimerDbl:Deactivate()
               Eval( ::bLDblClick, nRow, nCol )
            ENDIF
         ENDIF
         ::lDblClick = .F.
      ENDIF


   endif

   ::Change()

   Super:LButtonUp( nRow, nCol, nFlags )

RETURN NIL


//---------------------------------------------------------------------------//

METHOD LostFocus( hCtrl )  CLASS TCalendar

   Eval( ::bSetGet, ::dDate )
   if ::lMultiselect
      Eval( ::bSetGet2, ::dDateEnd )
   endif

RETURN Super:LostFocus( hCtrl )

//---------------------------------------------------------------------------//


METHOD Notify( nIdCtrl, nPtrNMHDR ) CLASS TCalendar

   local nCode := GetNMHDRCode( nPtrNMHDR )
   local aDates, dDate, nMonth

   do case
      case nCode == MCN_SELCHANGE
         ::Changed()

      case nCode == MCN_GETDAYSTATE

         IF ::bOnGetState != NIL .AND. ::lDayState
            ::ResetDayStates()
            GetDayState( nPtrNMHDR, ::aDayState, ::pSystemDate:cBuffer )
            ::SaveDateFormat()
            ::GetMonthRange()
            dDate := CToD( StrZero( Day( ::dDate ), 2 ) + "/" + StrZero( Month( ::dDate ), 2 ) + "/" + Str( Year( ::dDate ), 4 ) )
            ::SetSystemDate( dDate )
            ::RestoreDateFormat()
            Eval( ::bOnGetState, Self )
            GetDayState( nPtrNMHDR, ::aDayState )
         ELSE
            GetDayState( nPtrNMHDR, ::aDayState )
         ENDIF

   endcase

RETURN NIL

//---------------------------------------------------------------------------//

METHOD Paint() CLASS TCalendar

   local aInfo
   aInfo = ::DispBegin()

   FillRect( ::hDC, GetClientRect( ::hWnd ), ::oWnd:oBrush:hBrush )

   CallWindowProc( ::nOldProc, ::hWnd, WM_PAINT, ::hDC, 0 )

  ::DispEnd( aInfo )

return 1


//---------------------------------------------------------------------------//

METHOD SetArrayDayState( nMonth, nDay )

   IF nMonth > 0 .AND. nMonth <= ::GetVisibleMonths() .AND.;
      nDay > 0 .AND. nDay < 32
      ::aDayState[ nMonth, nDay ] := 1
   ENDIF

RETURN NIL

//---------------------------------------------------------------------------//

METHOD SetDate(dDate) CLASS TCalendar

   ::pSystemDate:nYear  := Year(dDate)
   ::pSystemDate:nMonth := Month(dDate)
   ::pSystemDate:nDay   := Day(dDate)

return MonthCal_SetCurSel( ::hWnd, ::pSystemDate:cBuffer )

//---------------------------------------------------------------------------//

METHOD SetDayStateStyle( lOnOff )

   IF lOnOff != NIL
      __ChangeStyleWindow( ::hWnd, MCS_DAYSTATE, , lOnOff )
      ::lDayState := lOnOff
   ENDIF

   IF ! ::lDayState
      ::ResetDayStates()
   ENDIF

   ::SetDayState()

RETURN ::lDayState

//---------------------------------------------------------------------------//

METHOD SetSystemDate( dDate ) CLASS TCalendar

   ::pSystemDate:nYear  := Year( dDate )
   ::pSystemDate:nMonth := Month( dDate )
   ::pSystemDate:nDay   := Day( dDate )

RETURN NIL

//---------------------------------------------------------------------------//

METHOD SetToday( dDate ) CLASS TCalendar

   ::SetSystemDate( dDate )

RETURN MonthCal_SetToday( ::hWnd, ::pSystemDate:cBuffer )

//---------------------------------------------------------------------------//

METHOD SetDateRange( dDateStart, dDateEnd ) CLASS TCalendar

   IF ( dDateEnd - dDateStart + 1) > ::GetMaxSelCount()
      dDateEnd := dDateStart + ::GetMaxSelCount() - 1
   endif

   ::pDateRange:nYear1  := Year( dDateStart )
   ::pDateRange:nMonth1 := Month( dDateStart )
   ::pDateRange:nDay1   := Day( dDateStart )

   ::pDateRange:nYear2  := Year( dDateEnd )
   ::pDateRange:nMonth2 := Month( dDateEnd )
   ::pDateRange:nDay2   := Day( dDateEnd )

   ::dDate    := dDateStart
   ::dDateEnd := dDateEnd

   IF MonthCal_SetSelRange( ::hWnd, ::pDateRange:cBuffer )
      ::Changed()
   ENDIF


RETURN NIL

//---------------------------------------------------------------------------//

METHOD SetRange( dDateStart, dDateEnd, nFlags ) CLASS TCalendar

   DEFAULT nFlags := nOR( GDTR_MIN, GDTR_MAX )

   ::pDateRange:nYear1  := Year( dDateStart )
   ::pDateRange:nMonth1 := Month( dDateStart )
   ::pDateRange:nDay1   := Day( dDateStart )

   ::pDateRange:nYear2  := Year( dDateEnd )
   ::pDateRange:nMonth2 := Month( dDateEnd )
   ::pDateRange:nDay2   := Day( dDateEnd )

RETURN MonthCal_SetRange( ::hWnd, nFlags, ::pDateRange:cBuffer )


//---------------------------------------------------------------------------//

METHOD SetMaxRange( dDate ) CLASS TCalendar

   ::pDateRange:nYear2  := Year( dDate )
   ::pDateRange:nMonth2 := Month( dDate )
   ::pDateRange:nDay2   := Day( dDate )

RETURN MonthCal_SetRange( ::hWnd, GDTR_MAX, ::pDateRange:cBuffer )

//---------------------------------------------------------------------------//

METHOD SetMinRange( dDate ) CLASS TCalendar

   ::pDateRange:nYear1  := Year( dDate )
   ::pDateRange:nMonth1 := Month( dDate )
   ::pDateRange:nDay1   := Day( dDate )

RETURN MonthCal_SetRange( ::hWnd, GDTR_MIN, ::pDateRange:cBuffer )


//---------------------------------------------------------------------------//

METHOD SetStructs() CLASS TCalendar

   STRUCT ::pDateRange
        MEMBER nYear1            AS WORD
        MEMBER nMonth1           AS WORD
        MEMBER nDayOfWeek1       AS WORD
        MEMBER nDay1             AS WORD
        MEMBER nHour1            AS WORD
        MEMBER nMinute1          AS WORD
        MEMBER nSecond1          AS WORD
        MEMBER nMilliseconds1    AS WORD

        MEMBER nYear2            AS WORD
        MEMBER nMonth2           AS WORD
        MEMBER nDayOfWeek2       AS WORD
        MEMBER nDay2             AS WORD
        MEMBER nHour2            AS WORD
        MEMBER nMinute2          AS WORD
        MEMBER nSecond2          AS WORD
        MEMBER nMilliseconds2    AS WORD
   ENDSTRUCT

   STRUCT ::pSystemDate
        MEMBER nYear            AS WORD
        MEMBER nMonth           AS WORD
        MEMBER nDayOfWeek       AS WORD
        MEMBER nDay             AS WORD
        MEMBER nHour            AS WORD
        MEMBER nMinute          AS WORD
        MEMBER nSecond          AS WORD
        MEMBER nMilliseconds    AS WORD
   ENDSTRUCT

RETURN NIL

//----------------------------------------------------------------------------//

#define  HKEY_CURRENT_USER       2147483649

Static Function GetTimeDblClick()
   local oReg := TReg32():New( HKEY_CURRENT_USER, "Control Panel\Mouse" )
   local uVar

   uVar := oReg:Get( "DoubleClickSpeed", "500" )

   IF uVar == NIL
      uVar = 500
   ENDIF
   oReg:Close()

RETURN Val( uVar )

//----------------------------------------------------------------------------//

#pragma BEGINDUMP

#include <windows.h>
#include <hbapi.h>
#include <commctrl.h>
#include <hbapiitm.h>
//---------
// Set Functions
//---------

HB_FUNC( MONTHCAL_SETCOLOR ) // hWnd, iColor, clr -> COLORREF
{
   hb_retnl( ( LONG ) MonthCal_SetColor( ( HWND ) hb_parnl( 1 ), hb_parni( 2 ), ( COLORREF ) hb_parnl( 3 ) ) );
}

//---------

HB_FUNC( MONTHCAL_SETCURSEL ) //hWnd, pSystemDate -> BOOL
{
   hb_retl( MonthCal_SetCurSel( ( HWND ) hb_parnl( 1 ), ( LPSYSTEMTIME ) hb_parc( 2 ) ) );
}

//---------

CHAR * LToStr( LONG ) ;
#define BOLDDAY(ds,iDay) if(iDay>0 && iDay<32)\
                            (ds)|=(0x00000001<<(iDay-1))

HB_FUNC( SETDAYSTATE ) //hWnd, ArrayDays
{
   INT iMonths;
   HWND hwndMC = ( HWND ) hb_parnl( 1 );
   MONTHDAYSTATE *pDayState;
   PHB_ITEM pArraydate  = hb_param( 2, HB_IT_ARRAY );
   INT i, j;
   PHB_ITEM pItem;

   iMonths = MonthCal_GetMonthRange( hwndMC, GMR_DAYSTATE, NULL );

   pDayState = ( MONTHDAYSTATE * )hb_xgrab( sizeof( MONTHDAYSTATE ) * iMonths );

   memset( pDayState, 0, sizeof( MONTHDAYSTATE ) * iMonths );

   for( i = 1; i < iMonths - 1; i++ )
   {
      pItem = hb_itemArrayGet( pArraydate, i );
      for( j = 1; j <= 31; j++ )
      {
         if( hb_arrayGetNL( pItem, j ) == 1 )
            BOLDDAY( pDayState[ i ], j ) ;
      }
      hb_itemRelease( pItem );
   }

   MonthCal_SetDayState( hwndMC, iMonths, pDayState );
   hb_xfree( ( void *)pDayState );

}

//---------

HB_FUNC( GETDAYSTATE ) //hWnd, ArrayDays, pDayState
{
   LPNMDAYSTATE lParam = ( LPNMDAYSTATE ) hb_parnl( 1 );
   INT iMonths;
   MONTHDAYSTATE *pDayState;
   PHB_ITEM pArraydate  = hb_param( 2, HB_IT_ARRAY );
   INT i, j;
   PHB_ITEM pItem;
   LPSYSTEMTIME lpSysTime ;


   iMonths = lParam->cDayState;


   pDayState = ( MONTHDAYSTATE * )hb_xgrab( sizeof( MONTHDAYSTATE ) * iMonths );

   memset( pDayState, 0, sizeof( MONTHDAYSTATE ) * iMonths );

   for( i = 1; i < iMonths - 1; i++ )
   {
      pItem = hb_itemArrayGet( pArraydate, i );

      for( j = 1; j <= 31; j++ )
      {
         if( hb_arrayGetNL( pItem, j ) == 1 )
            BOLDDAY( pDayState[ i ], j ) ;
      }
      hb_itemRelease( pItem );
   }

   lParam->prgDayState = pDayState;

   if( hb_pcount() > 2 )
   {
      lpSysTime = ( LPSYSTEMTIME ) hb_parc( 3 );
      *lpSysTime = lParam->stStart;
   }

   hb_xfree( pDayState );

}

//---------

HB_FUNC( ISOVERDAY )
{
	HWND hwndMC = ( HWND ) hb_parnl( 1 );
	PMCHITTESTINFO pMCHitTest = ( PMCHITTESTINFO ) hb_xgrab( sizeof ( MCHITTESTINFO ) ) ;
	BOOL lOver;

	memset( pMCHitTest, 0, sizeof( MCHITTESTINFO ) );

	pMCHitTest->cbSize = sizeof( MCHITTESTINFO );
	pMCHitTest->pt.y = hb_parnl( 2 );
	pMCHitTest->pt.x = hb_parnl( 3 );

	lOver = ( MonthCal_HitTest( hwndMC, pMCHitTest ) == MCHT_CALENDARDATE );

	hb_xfree( pMCHitTest );

	hb_retl( lOver );
}

//---------

HB_FUNC( MONTHCAL_SETFIRSTDAYOFWEEK )
{
   MonthCal_SetFirstDayOfWeek( ( HWND ) hb_parnl( 1 ), hb_parni( 2 ) );
}

//---------

HB_FUNC( MONTHCAL_SETMAXSELCOUNT ) //hWnd, iMax -> BOOL
{
   hb_retl( MonthCal_SetMaxSelCount( ( HWND ) hb_parnl( 1 ), hb_parni( 2 ) ) );
}

//---------

HB_FUNC( MONTHCAL_SETRANGE ) //hWnd, iMax, pDayState -> BOOL
{
   hb_retl( MonthCal_SetRange( ( HWND ) hb_parnl( 1 ), hb_parni( 2 ), ( LPSYSTEMTIME ) hb_parc( 3 ) ) );
}

//---------


HB_FUNC( MONTHCAL_SETSELRANGE ) //hWnd, pSystemDate -> BOOL
{
   hb_retl( MonthCal_SetSelRange( ( HWND ) hb_parnl( 1 ), ( LPSYSTEMTIME ) hb_parc( 2 ) ) );
}

//---------

HB_FUNC( MONTHCAL_SETTODAY )  //hWnd, pSystemDate
{
   MonthCal_SetToday( ( HWND ) hb_parnl( 1 ), ( LPSYSTEMTIME ) hb_parc( 2 ) );
}

//---------
// Get functions
//---------

HB_FUNC( MONTHCAL_GETCOLOR ) // hWnd, iColor -> COLORREF
{
   hb_retnl( ( LONG ) MonthCal_GetColor( ( HWND ) hb_parnl( 1 ), hb_parni( 2 ) ) );
}

//---------

HB_FUNC( MONTHCAL_GETCURSEL )  //hWnd, @pSystemDate -> BOOL
{
   LPSYSTEMTIME lpSysTime = ( LPSYSTEMTIME ) hb_parc( 2 );
   hb_retl( MonthCal_GetCurSel( ( HWND ) hb_parnl( 1 ), lpSysTime ) );
}


//---------

HB_FUNC( MONTHCAL_GETFIRSTDAYOFWEEK )  //hWnd -> iFirstDay
{
   hb_retnl( MonthCal_GetFirstDayOfWeek( ( HWND ) hb_parnl( 1 ) ) );
}

//---------

HB_FUNC( MONTHCAL_GETMAXSELCOUNT )  //hWnd -> iMaxSel
{
   hb_retni( MonthCal_GetMaxSelCount( ( HWND ) hb_parnl( 1 ) ) );
}

//---------

HB_FUNC( MONTHCAL_GETMONTHRANGE )  //hWnd, dwFlags, @pSystemDate -> iTotalMonths
{
   LPSYSTEMTIME lpSysTime = ( LPSYSTEMTIME ) hb_parc( 3 );
   hb_retnl( MonthCal_GetMonthRange( ( HWND ) hb_parnl( 1 ), hb_parnl( 2 ), lpSysTime ) );
}

//---------

HB_FUNC( MONTHCAL_GETTODAY )  //hWnd, @pSystemDate -> BOOL
{
   LPSYSTEMTIME lpSysTime = ( LPSYSTEMTIME ) hb_parc( 2 );
   hb_retl( MonthCal_GetToday( ( HWND ) hb_parnl( 1 ), lpSysTime ) );
}

//---------

HB_FUNC( MONTHCAL_GETRANGE )
{
   LPSYSTEMTIME lpSysTime = ( LPSYSTEMTIME ) hb_parc( 2 );
   hb_retnl( MonthCal_GetRange( ( HWND ) hb_parnl( 1 ), lpSysTime ) );
}

//---------

HB_FUNC( MONTHCAL_GETSELRANGE )  //hWnd, @pDateRange -> BOOL
{
   LPSYSTEMTIME lpSysTime = ( LPSYSTEMTIME ) hb_parc( 2 );
   hb_retl( MonthCal_GetSelRange( ( HWND ) hb_parnl( 1 ), lpSysTime ) );
}

//---------

#pragma ENDDUMP












