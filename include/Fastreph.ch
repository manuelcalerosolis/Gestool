//////////////////////////////////////////////////////////////////////
//
//  FastRepH.CH
//
//  Copyright:
//       Spirin Sergey, Paritet Soft, (c) 1992-2008. All rights reserved.         
//  
//  Contents:
//      #define constants for the frReportManager class
//      project - "FastReport for [x]Harbour" 
//      
//      
//////////////////////////////////////////////////////////////////////

#ifndef  _FASTREP_CH


*******************************************************************************
* Defines for ShowReport()
*******************************************************************************

#define FR_NOTCLEARLASTREPORT        1       // 

*******************************************************************************
* Defines for SetVisualActions()
*******************************************************************************

#define FR_ACT_NONE        0       // 
#define FR_ACT_HIDE        0       //  !!! Not work now
#define FR_ACT_DISABLE     0       //  !!! Not work now
#define FR_ACT_USER        3       // 

*******************************************************************************
* Defines for frPrintOptions:SetPrintPages
*******************************************************************************

#define FR_PP_ALL    0
#define FR_PP_ODD    1
#define FR_PP_EVEN   2
        
*******************************************************************************
* Defines for aRangeParams in SetWorkArea()-method 
*******************************************************************************

* RangeBegin

#define FR_RB_FIRST      0
#define FR_RB_CURRENT    1

* RangeEnd

#define FR_RE_LAST       0
#define FR_RE_CURRENT    1
#define FR_RE_COUNT      2
 
*******************************************************************************
* Defines for SetButtons() - Preview window 
*******************************************************************************

#define FR_PB_PRINT          1  
#define FR_PB_LOAD           2  
#define FR_PB_SAVE           4  
#define FR_PB_EXPORT         8  
#define FR_PB_ZOOM           16 
#define FR_PB_FIND           32 
#define FR_PB_OUTLINE        64 
#define FR_PB_PAGESETUP      128
#define FR_PB_TOOLS          256
#define FR_PB_EDIT           512
#define FR_PB_NAVIGATOR      1024

*******************************************************************************
* Defines for SetZoomMode() - Preview window 
*******************************************************************************

#define FR_ZM_DEFAULT        0
#define FR_ZM_WHOLEPAGE      1
#define FR_ZM_PAGEwIDTH      2
#define FR_ZM_MANYPAGES      3

*******************************************************************************
* Defines for SetNewSilentMode() - Engine
*******************************************************************************

#define FR_SIM_MESSAGEBOXES  0
#define FR_SIM_RETHROW       1
#define FR_SIM_SILENT        2

*******************************************************************************
* Defines for StartManualBuild()
*******************************************************************************

#define FR_CM                0
#define FR_MM                1
#define FR_INCHES            2
#define FR_PIXELS            3

#define FR_PORTRAIT          0
#define FR_LANDSCAPE         1

* For possible converting:

#define fr01cm               3.77953
#define fr1cm                37.7953
#define fr01in               9.6
#define fr1in                96

*******************************************************************************
* Defines for SetTabTreeExpanded()
*******************************************************************************

#define FR_tvData            1
#define FR_tvVar             2
#define FR_tvFunc            4
#define FR_tvClass           8
#define FR_tvAll             16

*******************************************************************************
* Defines for manual bands creation
*******************************************************************************

#define frxReportTitle      0
#define frxReportSummary    1
#define frxPageHeader       2
#define frxPageFooter       3
#define frxHeader           4
#define frxFooter           5
#define frxMasterData       6
#define frxDetailData       7
#define frxSubdetailData    8
#define frxDataBand4        9
#define frxDataBand5        10
#define frxDataBand6        11
#define frxGroupHeader      12
#define frxGroupFooter      13
#define frxChild            14
#define frxColumnHeader     15
#define frxColumnFooter     16
#define frxOverlay          17

*******************************************************************************
* Defines for SetFormatSettings()
*******************************************************************************

#define frxCurrencyString              1
#define frxCurrencyFormat              2
#define frxNegCurrFormat               3
#define frxThousandSeparator           4
#define frxDecimalSeparator            5
#define frxCurrencyDecimals            6
#define frxDateSeparator               7
#define frxShortDateFormat             8
#define frxLongDateFormat              9
#define frxTimeSeparator               10
#define frxTimeAMString                11
#define frxTimePMString                12
#define frxShortTimeFormat             13
#define frxLongTimeFormat              14
#define frxShortMonthNames             15
#define frxLongMonthNames              16
#define frxShortDayNames               17
#define frxLongDayNames                18
#define frxTwoDigitYearCenturyWindow   20
#define frxListSeparator               21



#define  _FASTREP_CH
#endif
