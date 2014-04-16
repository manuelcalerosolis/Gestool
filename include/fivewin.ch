/*
!short: FiveWin main Header File */

#ifndef _FIVEWIN_CH
#define _FIVEWIN_CH

#define FWCOPYRIGHT  "(c) FiveTech Software, 1993-2012"

#ifdef __HARBOUR__
   #ifdef __XHARBOUR__
      #ifndef __64__
         #define FWVERSION     "FWHX 12.04"
         #define FWDESCRIPTION "FiveWin for xHarbour"
      #else
         #define FWVERSION     "FWHX64 12.04"
         #define FWDESCRIPTION "FiveWin for xHarbour 64"
      #endif
   #else
      #ifndef __64__
         #define FWVERSION     "FWH 12.04"
         #define FWDESCRIPTION "FiveWin for Harbour"
      #else
         #define FWVERSION     "FWH64 12.04"
         #define FWDESCRIPTION "FiveWin for Harbour 64"
      #endif
   #endif
   #xtranslate SetCursor(   => WSetCursor(  // to avoid conflicts with Harbour functions
   #xtranslate __Keyboard(  => ___Keyboard( // to avoid conflicts with Harbour functions
   #xtranslate LastKey(     => _LastKey(    // to avoid conflicts with Harbour functions
#endif

#ifdef __FIVESCRIPT__
   #undef __HARBOUR__
#endif

#ifdef __HARBOUR__
   #ifndef __XHARBOUR__
      static bError
      #xcommand TRY              => bError := errorBlock( {|oErr| break( oErr ) } ) ;;
                                    BEGIN SEQUENCE
      #xcommand CATCH [<!oErr!>] => errorBlock( bError ) ;;
                                    RECOVER [USING <oErr>] <-oErr-> ;;
                                    errorBlock( bError )
   #endif
#endif

#include "Dialog.ch"
#include "Font.ch"
#include "Ini.ch"
#include "Menu.ch"
#include "Print.ch"

#ifndef CLIPPER501
   #include "Colors.ch"
   #include "DLL.ch"
   #include "Folder.ch"
   #ifndef _NOOBJECTS_CH
      #include "Objects.ch"
   #endif
   #include "ODBC.ch"
   #include "DDE.ch"
   #include "Video.ch"
   #include "VKey.ch"
   #include "Tree.ch"
   #include "WinApi.ch"
#endif

#ifdef __XPP__
   #include "fwxbase.ch"
#endif

#ifndef HB_SYMBOL_UNUSED
   #define HB_SYMBOL_UNUSED( symbol )  ( symbol := ( symbol ) )
#endif

#ifdef __HARBOUR__
   #ifndef __XHARBOUR__
      #ifndef __FWCE__
         REQUEST FW_GT
      #endif
   #endif
#endif

#ifdef __XHARBOUR__
   REQUEST GetProcAdd
   REQUEST TActiveX
#endif

#define CRLF Chr(13)+Chr(10)

extern errorsys

/*----------------------------------------------------------------------------//
!short: Running multiple instances of a FiveWin EXE */

#xcommand SET MULTIPLE <on:ON,OFF> => SetMultiple( Upper(<(on)>) == "ON" )

/*----------------------------------------------------------------------------//
!short: ACCESSING / SETTING Variables */

#define bSETGET(x) { | u | If( PCount()==0, x, x:= u ) }

/*----------------------------------------------------------------------------//
!short: Default parameters management */

#xcommand DEFAULT <uVar1> := <uVal1> ;
               [, <uVarN> := <uValN> ] => ;
                  If( <uVar1> == nil, <uVar1> := <uVal1>, ) ;;
                [ If( <uVarN> == nil, <uVarN> := <uValN>, ); ]

/*----------------------------------------------------------------------------//
!short: DO ... UNTIL support */

#xcommand REPEAT        => while .t.
#xcommand DO            => while .t.
#xcommand UNTIL <uExpr> => if <uExpr>; exit; end; end

/*----------------------------------------------------------------------------//
!short: Idle periods management */

#xcommand SET IDLEACTION TO <uIdleAction> => SetIdleAction( <{uIdleAction}> )

/*----------------------------------------------------------------------------//
!short: DataBase Objects */

#ifndef __XPP__
   #xcommand DATABASE <oDbf> => <oDbf> := TDataBase():New()
#else
   #xcommand DATABASE <oDbf> => TDataBase():New() ;;
                                <oDbf> := ClassObject( Alias() ):New()
#endif

/*----------------------------------------------------------------------------//
!short: General release command */

#xcommand RELEASE <ClassName> <oObj1> [,<oObjN>] ;
       => ;
          <oObj1>:End() ; <oObj1> := nil ;
        [ ; <oObjN>:End() ; <oObjN> := nil ]

/*----------------------------------------------------------------------------//
!short: Brushes */

#xcommand DEFINE BRUSH [ <oBrush> ] ;
             [ STYLE <cStyle> ] ;
             [ COLOR <nRGBColor> ] ;
             [ <file:FILE,FILENAME,DISK> <cBmpFile> ] ;
             [ <resource:RESOURCE,NAME,RESNAME> <cBmpRes> ] ;
             [ <grad:GRADIENT> <aGrad> ] ;
             [ <cResize:STRETCH,RESIZE,VERTICAL,VERT,HORIZONTAL,HORIZ> ] ;
       => ;
          [ <oBrush> := ] TBrush():New( [ Upper(<(cStyle)>) ], <nRGBColor>,;
             <cBmpFile>, <cBmpRes>, [<aGrad>], [ Upper(<(cResize)>) ] )

#xcommand SET BRUSH ;
             [ OF <oWnd> ] ;
             [ TO <oBrush> ] ;
       => ;
          <oWnd>:SetBrush( <oBrush> )

/*----------------------------------------------------------------------------//
!short: Pens */

#xcommand DEFINE PEN <oPen> ;
             [ STYLE <nStyle> ] ;
             [ WIDTH <nWidth> ] ;
             [ COLOR <nRGBColor> ] ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
       => ;
          <oPen> := TPen():New( <nStyle>, <nWidth>, <nRGBColor>, <oWnd> )

#xcommand ACTIVATE PEN <oPen> => <oPen>:Activate()

/*----------------------------------------------------------------------------//
!short: ButtonBar Commands */

#xcommand DEFINE BUTTONBAR [ <oBar> ] ;
             [ <size: SIZE, BUTTONSIZE, SIZEBUTTON > <nWidth>, <nHeight> ] ;
             [ <_3d: _3D, 3D, 3DLOOK, _3DLOOK> ] ;
             [ <mode: TOP, LEFT, RIGHT, BOTTOM, FLOAT> ] ;
             [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ CURSOR <oCursor> ] ;
             [ <l2007: 2007, _2007> ] ;
             [ <l2010: 2010, _2010> ] ;
      => ;
         [ <oBar> := ] TBar():New( <oWnd>, <nWidth>, <nHeight>, <._3d.>,;
             [ Upper(<(mode)>) ], <oCursor>, <.l2007.>, <.l2010.> )

#xcommand @ <nRow>, <nCol> BUTTONBAR [ <oBar> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ BUTTONSIZE <nBtnWidth>, <nBtnHeight> ] ;
             [ <_3d: 3D, 3DLOOK, _3DLOOK> ] ;
             [ <mode: TOP, LEFT, RIGHT, BOTTOM, FLOAT> ] ;
             [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ CURSOR <oCursor> ] ;
      => ;
         [ <oBar> := ] TBar():NewAt( <nRow>, <nCol>, <nWidth>, <nHeight>,;
             <nBtnWidth>, <nBtnHeight>, <oWnd>, <._3d.>, [ Upper(<(mode)>) ],;
             <oCursor> )

#xcommand DEFINE BUTTON [ <oBtn> ] ;
             [ <bar: OF, BUTTONBAR > <oBar> ] ;
             [ <resource: NAME, RESNAME, RESOURCE> <cResName1> ;
                [,<cResName2>[,<cResName3>[,<cResName4>] ] ] ] ;
             [ <file: FILE, FILENAME, DISK> <cBmpFile1> ;
               [,<cBmpFile2>[,<cBmpFile3>[,<cBmpFile4>] ] ] ] ;
             [ <action:ACTION,EXEC> <uAction,...> ] ;
             [ <group: GROUP > ] ;
             [ MESSAGE <cMsg> ] ;
             [ <adjust: ADJUST > ] ;
             [ WHEN <WhenFunc> ] ;
             [ TOOLTIP <cToolTip> ] ;
             [ <lPressed: PRESSED> ] ;
             [ ON DROP <bDrop> ] ;
             [ AT <nPos> ] ;
             [ PROMPT <cPrompt> ] ;
             [ FONT <oFont> ] ;
             [ <lNoBorder: NOBORDER, FLAT> ] ;
             [ MENU <oPopup> ] ;
             [ <layout: CENTER, TOP, LEFT, BOTTOM, RIGHT> ] ;
             [ <lTrans: TRANSPARENT>];
      => ;
         [ <oBtn> := ] TBtnBmp():NewBar( <cResName1>, <cResName2>,;
            <cBmpFile1>, <cBmpFile2>, <cMsg>, [{|This|<uAction>}],;
            <.group.>, <oBar>, <.adjust.>, <{WhenFunc}>,;
            <cToolTip>, <.lPressed.>, [\{||<bDrop>\}], [#<uAction>], <nPos>,;
            <cPrompt>, <oFont>, [<cResName3>], [<cBmpFile3>], [!<.lNoBorder.>],;
            [<oPopup>], [ Upper(<(layout)>) ],[<cResName4>], [<cBmpFile4>], <.lTrans.> )

#xcommand REDEFINE BTNBMP [<oBtn>] ;
             [ ID <nId> ] ;
             [ <bar: OF, BUTTONBAR > <oBar> ] ;
             [ <resource: NAME, RESNAME, RESOURCE> <cResName1> ;
                [,<cResName2>[,<cResName3>[,<cResName4>] ] ] ];
             [ <file: FILE, FILENAME, DISK> <cBmpFile1> ;
               [,<cBmpFile2>[,<cBmpFile3>[,<cBmpFile4>] ] ] ] ;
             [ <action:ACTION,EXEC,ON CLICK> <uAction,...> ] ;
             [ MESSAGE <cMsg> ] ;
             [ <adjust: ADJUST > ] ;
             [ WHEN <uWhen> ] ;
             [ <lUpdate: UPDATE> ] ;
             [ TOOLTIP <cToolTip> ] ;
             [ PROMPT <cPrompt> ] ;
             [ FONT <oFont> ] ;
             [ <lNoBorder: NOBORDER> ] ;
             [ <layout: CENTER, TOP, LEFT, BOTTOM, RIGHT> ] ;
             [ <l2007: 2007> ] ;
             [ <lTrans: TRANSPARENT> ] ;
             [ <lNoRound: NOROUND> ];
      => ;
         [ <oBtn> := ] TBtnBmp():ReDefine( <nId>, <cResName1>, <cResName2>,;
            <cBmpFile1>, <cBmpFile2>, <cMsg>, [{|Self|<uAction>}],;
            <oBar>, <.adjust.>, <{uWhen}>, <.lUpdate.>, <cToolTip>,;
            <cPrompt>, <oFont>, [<cResName3>], [<cBmpFile3>], [!<.lNoBorder.>],;
            [ Upper(<(layout)>) ], <.l2007.>,[<cResName4>], [<cBmpFile4>], <.lTrans.>, !<.lNoRound.> )

#xcommand @ <nRow>, <nCol> BTNBMP [<oBtn>] ;
             [ <resource: NAME, RESNAME, RESOURCE> <cResName1> ;
                [,<cResName2>[,<cResName3>[,<cResName4>] ] ] ] ;
             [ <file: FILE, FILENAME, DISK> <cBmpFile1> ;
                [,<cBmpFile2>[,<cBmpFile3>[,<cBmpFile4>] ] ] ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ ACTION <uAction,...> ] ;
             [ <of:OF, WINDOW, DIALOG> <oWnd> ] ;
             [ MESSAGE <cMsg> ] ;
             [ WHEN <uWhen> ] ;
             [ <adjust: ADJUST> ] ;
             [ <lUpdate: UPDATE> ] ;
             [ PROMPT <cPrompt> ] ;
             [ FONT <oFont> ] ;
             [ TOOLTIP <cToolTip> ] ;
             [ <lNoBorder: NOBORDER> ] ;
             [ <layout: CENTER, TOP, LEFT, BOTTOM, RIGHT> ] ;
             [ <l2007: 2007> ] ;
             [ <lTrans: TRANSPARENT> ] ;
             [ <lNoRound: NOROUND> ];
             [ GRADIENT <bGradColors> ];
             [ <pixel: PIXEL> ] ;
             [ <design: DESIGN> ] ;
      => ;
         [ <oBtn> := ] TBtnBmp():New( <nRow>, <nCol>, <nWidth>, <nHeight>,;
            <cResName1>, <cResName2>, <cBmpFile1>, <cBmpFile2>,;
            [{|Self|<uAction>}], <oWnd>, <cMsg>, <{uWhen}>, <.adjust.>,;
            <.lUpdate.>, <cPrompt>, <oFont>, [<cResName3>], [<cBmpFile3>],;
            !<.lNoBorder.>, [ Upper(<(layout)>) ], <.l2007.>,[<cResName4>], [<cBmpFile4>], ;
            <.lTrans.>, <cToolTip>, !<.lNoRound.>, <bGradColors>, <.pixel.>, <.design.> )

/*----------------------------------------------------------------------------//
!short: Icons */

#xcommand @ <nRow>, <nCol> ICON [ <oIcon> ] ;
             [ <resource: NAME, RESOURCE, RESNAME> <cResName> ] ;
             [ <file: FILE, FILENAME, DISK> <cIcoFile> ] ;
             [ <border:BORDER> ] ;
             [ ON CLICK <uClick> ] ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <update: UPDATE> ] ;
             [ WHEN <uWhen> ] ;
             [ COLOR <nClrFore> [,<nClrBack>] ] ;
       => ;
          [ <oIcon> := ] TIcon():New( <nRow>, <nCol>, <cResName>,;
             <cIcoFile>, <.border.>, <{uClick}>, <oWnd>, <.update.>,;
             <{uWhen}>, <nClrFore>, <nClrBack> )

#xcommand REDEFINE ICON [<oIcon>] ;
             [ ID <nId> ] ;
             [ <resource: NAME, RESOURCE, RESNAME> <cResName> ] ;
             [ <file: FILE, FILENAME, DISK> <cIcoFile> ] ;
             [ ON CLICK <uClick> ] ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <update: UPDATE> ] ;
             [ WHEN <uWhen> ] ;
       => ;
          [ <oIcon> := ] TIcon():ReDefine( <nId>, <cResName>, <cIcoFile>,;
             <{uClick}>, <.update.>, <oWnd>, <{uWhen}> )

#xcommand DEFINE ICON <oIcon> ;
             [ <resource: NAME, RESOURCE, RESNAME> <cResName> ] ;
             [ <file: FILE, FILENAME, DISK> <cIcoFile> ] ;
             [ WHEN <WhenFunc> ] ;
       => ;
          <oIcon> := TIcon():New( ,, <cResName>, <cIcoFile>, <{WhenFunc}> )

/*----------------------------------------------------------------------------//
!short: BUTTONBMP */

#xcommand @ <nRow>, <nCol> BUTTONBMP [ <oBtn> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ ACTION <uAction> ] ;
             [ <default: DEFAULT> ] ;
             [ <of:OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <help:HELP, HELPID, HELP ID> <nHelpId> ] ;
             [ FONT <oFont> ] ;
             [ <pixel: PIXEL> ] ;
             [ <design: DESIGN> ] ;
             [ MESSAGE <cMsg> ] ;
             [ <update: UPDATE> ] ;
             [ WHEN <WhenFunc> ] ;
             [ VALID <uValid> ] ;
             [ <lCancel: CANCEL> ] ;
             [ BITMAP <cBitmap> ] ;
             [ PROMPT <cPrompt> ] ;
             [ <cPostext: TEXTTOP, TEXTBOTTOM, TEXTLEFT, TEXTRIGHT> ] ;
      => ;
         [ <oBtn> := ] TButtonBmp():New( <nRow>, <nCol>, <cPrompt>, <oWnd>,;
            <{uAction}>, <nWidth>, <nHeight>, <nHelpId>, <oFont>, <.default.>,;
            <.pixel.>, <.design.>, <cMsg>, <.update.>, <{WhenFunc}>,;
            <{uValid}>, <.lCancel.>, <cBitmap>, [ Upper(<(cPostext)>) ] )

#xcommand REDEFINE BUTTONBMP [ <oBtn> ] ;
             [ ID <nId> [ <of:OF, WINDOW, DIALOG> <oDlg> ] ] ;
             [ ACTION <uAction,...> ] ;
             [ <help:HELP, HELPID, HELP ID> <nHelpId> ] ;
             [ MESSAGE <cMsg> ] ;
             [ <update: UPDATE> ] ;
             [ WHEN <WhenFunc> ] ;
             [ VALID <uValid> ] ;
             [ PROMPT <cPrompt> ] ;
             [ <lCancel: CANCEL> ] ;
             [ BITMAP <cBitmap> ] ;
             [ <cPostext: TEXTTOP, TEXTBOTTOM, TEXTLEFT, TEXTRIGHT> ] ;
             [ TOOLTIP <cToolTip> ] ;
      => ;
          [ <oBtn> := ] TButtonBmp():ReDefine( <nId>, [\{||<uAction>\}], <oDlg>,;
             <nHelpId>, <cMsg>, <.update.>, <{WhenFunc}>, <{uValid}>,;
             <cPrompt>, <.lCancel.>, <cBitmap>, [ Upper(<(cPostext)>) ], <cToolTip> )

/*----------------------------------------------------------------------------//
!short: PUSHBUTTON */

#xcommand @ <nRow>, <nCol> BUTTON [ <oBtn> PROMPT ] <cCaption> ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ ACTION <uAction> ] ;
             [ <default: DEFAULT> ] ;
             [ <of:OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <help:HELP, HELPID, HELP ID> <nHelpId> ] ;
             [ FONT <oFont> ] ;
             [ <pixel: PIXEL> ] ;
             [ <design: DESIGN> ] ;
             [ MESSAGE <cMsg> ] ;
             [ <update: UPDATE> ] ;
             [ WHEN <WhenFunc> ] ;
             [ VALID <uValid> ] ;
             [ <lCancel: CANCEL> ] ;
      => ;
         [ <oBtn> := ] TButton():New( <nRow>, <nCol>, <cCaption>, <oWnd>,;
            <{uAction}>, <nWidth>, <nHeight>, <nHelpId>, <oFont>, <.default.>,;
            <.pixel.>, <.design.>, <cMsg>, <.update.>, <{WhenFunc}>,;
            <{uValid}>, <.lCancel.> )

#xcommand REDEFINE BUTTON [ <oBtn> ] ;
             [ ID <nId> [ <of:OF, WINDOW, DIALOG> <oDlg> ] ] ;
             [ ACTION <uAction,...> ] ;
             [ <help:HELP, HELPID, HELP ID> <nHelpId> ] ;
             [ MESSAGE <cMsg> ] ;
             [ <update: UPDATE> ] ;
             [ WHEN <WhenFunc> ] ;
             [ VALID <uValid> ] ;
             [ PROMPT <cPrompt> ] ;
             [ <lCancel: CANCEL> ] ;
       => ;
          [ <oBtn> := ] TButton():ReDefine( <nId>, [\{||<uAction>\}], <oDlg>,;
             <nHelpId>, <cMsg>, <.update.>, <{WhenFunc}>, <{uValid}>,;
             <cPrompt>, <.lCancel.> )

/*----------------------------------------------------------------------------//
!short: FLATBTN */

#xcommand @ <nRow>, <nCol> FLATBTN [<oBtn>] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ ACTION <uAction,...> ] ;
             [ <of:OF, WINDOW, DIALOG> <oWnd> ] ;
             [ WHEN <uWhen> ] ;
             [ <lUpdate: UPDATE> ] ;
             [ PROMPT <cPrompt> ] ;
             [ COLOR <nClrText>, <nClrPane> ] ;
             [ FONT <oFont> ] ;
             [ <lNoBorder: NOBORDER> ] ;
             [ <lCancel: CANCEL> ] ;
             [ <lDefault: DEFAULT> ] ;
      => ;
         [ <oBtn> := ] TBtnFlat():New( <nRow>, <nCol>, <nWidth>, <nHeight>,;
            <cPrompt>, <oWnd>, <oFont>, [{|Self|<uAction>}], <{uWhen}>, ;
            <.lUpdate.>, !<.lNoBorder.>, <nClrText>, <nClrPane>, <.lCancel.>,;
            <.lDefault.> )

/*----------------------------------------------------------------------------//
!short: CHECKBOX */

#xcommand REDEFINE CHECKBOX [ <oCbx> VAR ] <lVar> ;
             [ ID <nId> ] ;
             [ PROMPT <cPrompt> ];
             [ <of:OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <help:HELPID, HELP ID> <nHelpId> ] ;
             [ <click:ON CLICK, ON CHANGE> <uClick> ];
             [ VALID <uValid> ] ;
             [ <color: COLOR, COLORS> <nClrFore> [,<nClrBack>] ] ;
             [ MESSAGE <cMsg> ] ;
             [ <update: UPDATE> ] ;
             [ WHEN <uWhen> ] ;
       => ;
          [ <oCbx> := ] TCheckBox():ReDefine( <nId>, bSETGET(<lVar>),;
             <oWnd>, <nHelpId>, [<{uClick}>], <{uValid}>, <nClrFore>,;
             <nClrBack>, <cMsg>, <.update.>, <{uWhen}>, <cPrompt> )

#xcommand @ <nRow>, <nCol> CHECKBOX [ <oCbx> VAR ] <lVar> ;
             [ PROMPT <cCaption> ] ;
             [ <of:OF, WINDOW, DIALOG> <oWnd> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ <help:HELPID, HELP ID> <nHelpId> ] ;
             [ FONT <oFont> ] ;
             [ <change: ON CLICK, ON CHANGE> <uClick> ] ;
             [ VALID   <ValidFunc> ] ;
             [ <color: COLOR, COLORS> <nClrFore> [,<nClrBack>] ] ;
             [ <design: DESIGN> ] ;
             [ <pixel: PIXEL> ] ;
             [ MESSAGE <cMsg> ] ;
             [ <update: UPDATE> ] ;
             [ WHEN <WhenFunc> ] ;
      => ;
         [ <oCbx> := ] TCheckBox():New( <nRow>, <nCol>, <cCaption>,;
             bSETGET(<lVar>), <oWnd>, <nWidth>, <nHeight>, <nHelpId>,;
             [<{uClick}>], <oFont>, <{ValidFunc}>, <nClrFore>, <nClrBack>,;
             <.design.>, <.pixel.>, <cMsg>, <.update.>, <{WhenFunc}> )

#xcommand @ <nRow>, <nCol> SWITCH [ <oSw> VAR ] <lVar> ;
             [ PROMPT <cCaption> ] ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ <help:HELPID, HELP ID> <nHelpId> ] ;
             [ FONT <oFont> ] ;
             [ <change: ON CLICK, ON CHANGE> <uClick> ] ;
             [ VALID   <ValidFunc> ] ;
             [ <color: COLOR, COLORS> <nClrFore> [,<nClrBack>] ] ;
             [ <design: DESIGN> ] ;
             [ <pixel: PIXEL> ] ;
             [ MESSAGE <cMsg> ] ;
             [ <update: UPDATE> ] ;
             [ WHEN <WhenFunc> ] ;
             [ BORDERSIZE <nBorderSize> ] [ BORDERCOLOR <nClrBorder> ] ;
             [ THUMBSIZE  <nThumbSize>  ] [ THUMBCOLOR  <nClrThumb> ] ;
             [ <lRad: RADIOSTYLE> ] ;
      => ;
         [ <oSw> := ] TSwitch():New( <nRow>, <nCol>, <cCaption>,;
             bSETGET(<lVar>), <oWnd>, <nWidth>, <nHeight>, <nHelpId>,;
             [<{uClick}>], <oFont>, <{ValidFunc}>, <nClrFore>, <nClrBack>,;
             <.design.>, <.pixel.>, <cMsg>, <.update.>, <{WhenFunc}>, ;
             <nBorderSize>, <nClrBorder>, <nThumbSize>, <nClrThumb>, <.lRad.> )

/*----------------------------------------------------------------------------//
!short: COMBOBOX */

#xcommand @ <nRow>, <nCol> COMBOBOX [ <oCbx> VAR ] <cVar> ;
             [ <it: PROMPTS, ITEMS> <aItems> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ <dlg:OF,WINDOW,DIALOG> <oWnd> ] ;
             [ <help:HELPID, HELP ID> <nHelpId> ] ;
             [ ON CHANGE <uChange> ] ;
             [ VALID <uValid> ] ;
             [ <color: COLOR,COLORS> <nClrText> [,<nClrBack>] ] ;
             [ <pixel: PIXEL> ] ;
             [ FONT <oFont> ] ;
             [ <update: UPDATE> ] ;
             [ MESSAGE <cMsg> ] ;
             [ WHEN <uWhen> ] ;
             [ <design: DESIGN> ] ;
             [ BITMAPS <acBitmaps> ] ;
             [ ON DRAWITEM <uBmpSelect> ] ;
             [ STYLE <nStyle> ] ;
             [ <pict: PICT, PICTURE> <cPicture> ];
             [ ON EDIT CHANGE <uEChange> ] ;
       => ;
          [ <oCbx> := ] TComboBox():New( <nRow>, <nCol>, bSETGET(<cVar>),;
             <aItems>, <nWidth>, <nHeight>, <oWnd>, <nHelpId>,;
             [{|Self|<uChange>}], <{uValid}>, <nClrText>, <nClrBack>,;
             <.pixel.>, <oFont>, <cMsg>, <.update.>, <{uWhen}>,;
             <.design.>, <acBitmaps>, [{|nItem|<uBmpSelect>}], <nStyle>,;
             <cPicture>, [<{uEChange}>] )

#xcommand REDEFINE COMBOBOX [ <oCbx> VAR ] <cVar> ;
             [ <items: PROMPTS, ITEMS> <aItems> ] ;
             [ ID <nId> ] ;
             [ <dlg:OF,WINDOW,DIALOG> <oWnd> ] ;
             [ <help:HELPID, HELP ID> <nHelpId> ] ;
             [ ON CHANGE <uChange> ] ;
             [ VALID   <uValid> ] ;
             [ <color: COLOR,COLORS> <nClrText> [,<nClrBack>] ] ;
             [ <update: UPDATE> ] ;
             [ MESSAGE <cMsg> ] ;
             [ WHEN <uWhen> ] ;
             [ BITMAPS <acBitmaps> ] ;
             [ ON DRAWITEM <uBmpSelect> ] ;
             [ STYLE <nStyle> ] ;
             [ <pict: PICT, PICTURE> <cPicture> ];
             [ ON EDIT CHANGE <uEChange> ] ;
       => ;
          [ <oCbx> := ] TComboBox():ReDefine( <nId>, bSETGET(<cVar>),;
             <aItems>, <oWnd>, <nHelpId>, <{uValid}>, [{|Self|<uChange>}],;
             <nClrText>, <nClrBack>, <cMsg>, <.update.>, <{uWhen}>,;
             <acBitmaps>, [{|nItem|<uBmpSelect>}], <nStyle>, <cPicture>,;
             [<{uEChange}>] )

#xcommand @ <nRow>, <nCol> COMBOMETRO [ <oCbx> VAR ] <cVar> ;
             [ <it: PROMPTS, ITEMS> <aItems> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ <dlg: OF,WINDOW,DIALOG> <oWnd> ] ;
             [ <help: HELPID, HELP ID> <nHelpId> ] ;
             [ ON CHANGE <uChange> ] ;
             [ VALID <uValid> ] ;
             [ <color: COLOR,COLORS> <nClrText> [,<nClrBack>] ] ;
             [ <pixel: PIXEL> ] ;
             [ FONT <oFont> ] ;
             [ <update: UPDATE> ] ;
             [ MESSAGE <cMsg> ] ;
             [ WHEN <uWhen> ] ;
             [ <design: DESIGN> ] ;
       => ;
          [ <oCbx> := ] TComboMetro():New( <nRow>, <nCol>, bSETGET(<cVar>),;
             <aItems>, <nWidth>, <nHeight>, <oWnd>, <nHelpId>,;
             [{|Self|<uChange>}], <{uValid}>, <nClrText>, <nClrBack>,;
             <.pixel.>, <oFont>, <cMsg>, <.update.>, <{uWhen}>,;
             <.design.> )

/*----------------------------------------------------------------------------//
!short: LISTBOX */

#xcommand REDEFINE LISTBOX [ <oLbx> VAR ] <cnVar> ;
             [ <items: PROMPTS, ITEMS> <aItems> ]  ;
             [ <files: FILES, FILESPEC> <cFileSpec> ] ;
             [ ID <nId> ] ;
             [ ON CHANGE <uChange,...> ] ;
             [ ON [ LEFT ] DBLCLICK <uLDblClick> ] ;
             [ <of: OF, WINDOW, DIALOG > <oWnd> ] ;
             [ <help:HELPID, HELP ID> <nHelpId> ] ;
             [ VALID <uValid> ] ;
             [ <color: COLOR,COLORS> <nClrFore> [,<nClrBack>] ] ;
             [ MESSAGE <cMsg> ] ;
             [ <update: UPDATE> ] ;
             [ WHEN <uWhen> ] ;
             [ BITMAPS <acBitmaps> ] ;
             [ ON DRAWITEM <uBmpSelect> ] ;
       => ;
          [ <oLbx> := ] TListBox():ReDefine( <nId>, bSETGET(<cnVar>), <aItems>,;
             [\{||<uChange>\}], <oWnd>, <nHelpId>, <acBitmaps>,;
             <{uValid}>, <cFileSpec>, <nClrFore>, <nClrBack>,;
             <{uLDblClick}>, <cMsg>, <.update.>, <{uWhen}>,;
             [{|nItem|<uBmpSelect>}] )

#xcommand @ <nRow>, <nCol> LISTBOX [ <oLbx> VAR ] <cnVar> ;
             [ <items: PROMPTS, ITEMS> <aList>  ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ ON CHANGE <uChange> ] ;
             [ ON [ LEFT ] DBLCLICK <uLDblClick> ] ;
             [ <of: OF, WINDOW, DIALOG > <oWnd> ] ;
             [ VALID <uValid> ] ;
             [ <color: COLOR,COLORS> <nClrFore> [,<nClrBack>] ] ;
             [ <pixel: PIXEL> ] ;
             [ <design: DESIGN> ] ;
             [ FONT <oFont> ] ;
             [ MESSAGE <cMsg> ] ;
             [ <update: UPDATE> ] ;
             [ WHEN <uWhen> ] ;
             [ BITMAPS <aBitmaps> ] ;
             [ ON DRAWITEM <uBmpSelect> ] ;
             [ <multi: MULTI, MULTIPLE, MULTISEL> ] ;
             [ <sort: SORT> ] ;
       => ;
          [ <oLbx> := ] TListBox():New( <nRow>, <nCol>, bSETGET(<cnVar>),;
             <aList>, <nWidth>, <nHeight>, <{uChange}>, <oWnd>, <{uValid}>,;
             <nClrFore>, <nClrBack>, <.pixel.>, <.design.>, <{uLDblClick}>,;
             <oFont>, <cMsg>, <.update.>, <{uWhen}>, <aBitmaps>,;
             [{|nItem|<uBmpSelect>}], <.multi.>, <.sort.> )

/*----------------------------------------------------------------------------//
!short: LISTBOX - BROWSE */
// Warning: SELECT <cField>  ==> Must be the Field key of the current INDEX !!!

#xcommand REDEFINE LISTBOX [ <oLbx> ] FIELDS [<Flds,...>] ;
             [ ALIAS <cAlias> ] ;
             [ ID <nId> ] ;
             [ <dlg:OF,DIALOG> <oDlg> ] ;
             [ <sizes:FIELDSIZES, SIZES, COLSIZES> <aColSizes,...> ] ;
             [ <head:HEAD,HEADER,HEADERS,TITLE> <aHeaders,...> ] ;
             [ SELECT <cField> FOR <uValue1> [ TO <uValue2> ] ] ;
             [ ON CHANGE <uChange> ] ;
             [ ON [ LEFT ] CLICK <uLClick> ] ;
             [ ON [ LEFT ] DBLCLICK <uLDblClick> ] ;
             [ ON RIGHT CLICK <uRClick> ] ;
             [ FONT <oFont> ] ;
             [ CURSOR <oCursor> ] ;
             [ <color: COLOR, COLORS> <nClrFore> [,<nClrBack>] ] ;
             [ MESSAGE <cMsg> ] ;
             [ <update: UPDATE> ] ;
             [ WHEN <uWhen> ] ;
             [ VALID <uValid> ] ;
             [ ACTION <uAction,...> ] ;
       => ;
              [ <oLbx> := ] TWBrowse():ReDefine( <nId>, ;
              [\{|| \{ <Flds> \} \}], <oDlg>,;
              [ \{<aHeaders>\}], [\{<aColSizes>\}],;
              <(cField)>, <uValue1>, <uValue2>,;
              [<{uChange}>],;
              [\{|nRow,nCol,nFlags|<uLDblClick>\}],;
              [\{|nRow,nCol,nFlags|<uRClick>\}],;
              <oFont>, <oCursor>, <nClrFore>, <nClrBack>, <cMsg>, <.update.>,;
              <cAlias>, <{uWhen}>, <{uValid}>,;
              [\{|nRow,nCol,nFlags|<uLClick>\}], [\{<{uAction}>\}] )

#xcommand @ <nRow>, <nCol> LISTBOX [ <oBrw> ] FIELDS [<Flds,...>] ;
               [ ALIAS <cAlias> ] ;
               [ <sizes:FIELDSIZES, SIZES, COLSIZES> <aColSizes,...> ] ;
               [ <head:HEAD,HEADER,HEADERS,TITLE> <aHeaders,...> ] ;
               [ SIZE <nWidth>, <nHeigth> ] ;
               [ <dlg:OF,DIALOG> <oDlg> ] ;
               [ SELECT <cField> FOR <uValue1> [ TO <uValue2> ] ] ;
               [ ON CHANGE <uChange> ] ;
               [ ON [ LEFT ] CLICK <uLClick> ] ;
               [ ON [ LEFT ] DBLCLICK <uLDblClick> ] ;
               [ ON RIGHT CLICK <uRClick> ] ;
               [ FONT <oFont> ] ;
               [ CURSOR <oCursor> ] ;
               [ <color: COLOR, COLORS> <nClrFore> [,<nClrBack>] ] ;
               [ MESSAGE <cMsg> ] ;
               [ <update: UPDATE> ] ;
               [ <pixel: PIXEL> ] ;
               [ WHEN <uWhen> ] ;
               [ <design: DESIGN> ] ;
               [ VALID <uValid> ] ;
               [ ACTION <uAction,...> ] ;
      => ;
          [ <oBrw> := ] TWBrowse():New( <nRow>, <nCol>, <nWidth>, <nHeigth>,;
                           [\{|| \{<Flds> \} \}], ;
                           [\{<aHeaders>\}], [\{<aColSizes>\}], ;
                           <oDlg>, <(cField)>, <uValue1>, <uValue2>,;
                           [<{uChange}>],;
                           [\{|nRow,nCol,nFlags|<uLDblClick>\}],;
                           [\{|nRow,nCol,nFlags|<uRClick>\}],;
                           <oFont>, <oCursor>, <nClrFore>, <nClrBack>, <cMsg>,;
                           <.update.>, <cAlias>, <.pixel.>, <{uWhen}>,;
                           <.design.>, <{uValid}>, <{uLClick}>,;
                           [\{<{uAction}>\}] )

/*----------------------------------------------------------------------------//
!short: RADIOBUTTONS */

// Creates a radioitem at a certain location
#xcommand @ <nRow>, <nCol> RADIOITEM [ <oRadItem> PROMPT ] <cCaption> ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ RADIOMENU <oRadMenu> ] ;
             [ <help:HELPID, HELP ID> <nHelpId> ] ;
             [ <change: ON CLICK, ON CHANGE> <uChange> ] ;
             [ COLOR <nClrFore> [,<nClrBack>] ] ;
             [ MESSAGE <cMsg> ] ;
             [ <update: UPDATE> ] ;
             [ WHEN <uWhen> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ VALID <uValid> ] ;
             [ <lDesign: DESIGN> ] ;
             [ <lLook3d: 3D, _3D> ] ;
             [ <lPixel: PIXEL> ] ;
       => ;
          [<oRadItem> := ] TRadio():New( <nRow>, <nCol>, <cCaption>, .f., .f.,;
            Len( <oRadMenu>:aItems ) + 1, <oWnd>, <oRadMenu>,;
            [<nHelpId>], [<nClrFore>], [<nClrBack>], [<cMsg>], [<.update.>], [<{uWhen}>],;
            [<nWidth>], [<nHeight>], [<{uValid}>], [<.lDesign.>], [<.lPixel.>] );;
            AAdd( <oRadMenu>:aItems, ATail( <oWnd>:aControls ) )

#xcommand @ <nRow>, <nCol> RADIO [ <oRadMenu> VAR ] <nVar> ;
             [ <prm: PROMPT, ITEMS> <cItems,...> ] ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <help:HELPID, HELP ID> <nHelpId,...> ] ;
             [ <change: ON CLICK, ON CHANGE> <uChange> ] ;
             [ COLOR <nClrFore> [,<nClrBack>] ] ;
             [ MESSAGE <cMsg> ] ;
             [ <update: UPDATE> ] ;
             [ WHEN <uWhen> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ VALID <uValid> ] ;
             [ <lDesign: DESIGN> ] ;
             [ <lLook3d: 3D, _3D> ] ;
             [ <lPixel: PIXEL> ] ;
       => ;
          [ <oRadMenu> := ] TRadMenu():New( <nRow>, <nCol>, {<cItems>},;
             bSETGET(<nVar>), <oWnd>, [{<nHelpId>}], <{uChange}>,;
             <nClrFore>, <nClrBack>, <cMsg>, <.update.>, <{uWhen}>,;
             <nWidth>, <nHeight>, <{uValid}>, <.lDesign.>, <.lLook3d.>,;
             <.lPixel.> )

#xcommand REDEFINE RADIO [ <oRadMenu> VAR ] <nVar> ;
             [ ID <nId,...> ] ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <help:HELPID, HELP ID> <nHelpId,...> ] ;
             [ <change: ON CHANGE, ON CLICK> <uChange> ] ;
             [ COLOR <nClrFore> [,<nClrBack>] ] ;
             [ MESSAGE <cMsg> ] ;
             [ <update: UPDATE> ] ;
             [ WHEN <uWhen> ] ;
             [ VALID <uValid> ] ;
       => ;
          [ <oRadMenu> := ] TRadMenu():Redefine( bSETGET(<nVar>),;
             <oWnd>, [{<nHelpId>}], \{ <nId> \}, <{uChange}>, <nClrFore>,;
             <nClrBack>, <cMsg>, <.update.>, <{uWhen}>, <{uValid}> )

/*----------------------------------------------------------------------------//
!short: BITMAP */

#xcommand @ <nRow>, <nCol> BITMAP [ <oBmp> ] ;
             [ <resource: NAME, RESNAME, RESOURCE> <cResName> ] ;
             [ <file: FILENAME, FILE, DISK> <cBmpFile> ] ;
             [ <NoBorder:NOBORDER, NO BORDER> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <lClick: ON CLICK, ON LEFT CLICK> <uLClick> ] ;
             [ <rClick: ON RIGHT CLICK> <uRClick> ] ;
             [ <scroll: SCROLL> ] ;
             [ <adjust: ADJUST> ] ;
             [ CURSOR <oCursor> ] ;
             [ <pixel: PIXEL>   ] ;
             [ MESSAGE <cMsg>   ] ;
             [ <update: UPDATE> ] ;
             [ WHEN <uWhen> ] ;
             [ VALID <uValid> ] ;
             [ <lDesign: DESIGN> ] ;
       => ;
          [ <oBmp> := ] TBitmap():New( <nRow>, <nCol>, <nWidth>, <nHeight>,;
             <cResName>, <cBmpFile>, <.NoBorder.>, <oWnd>,;
             [\{ |nRow,nCol,nKeyFlags| <uLClick> \} ],;
             [\{ |nRow,nCol,nKeyFlags| <uRClick> \} ], <.scroll.>,;
             <.adjust.>, <oCursor>, <cMsg>, <.update.>,;
             <{uWhen}>, <.pixel.>, <{uValid}>, <.lDesign.> )

#xcommand @ <nRow>, <nCol> IMAGE [ <oBmp> ] ;
             [ <resource: NAME, RESNAME, RESOURCE> <cResName> ] ;
             [ <file: FILENAME, FILE, DISK> <cBmpFile> ] ;
             [ <NoBorder:NOBORDER, NO BORDER> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <lClick: ON CLICK, ON LEFT CLICK> <uLClick> ] ;
             [ <rClick: ON RIGHT CLICK> <uRClick> ] ;
             [ <scroll: SCROLL> ] ;
             [ <adjust: ADJUST> ] ;
             [ CURSOR <oCursor> ] ;
             [ <pixel: PIXEL>   ] ;
             [ MESSAGE <cMsg>   ] ;
             [ <update: UPDATE> ] ;
             [ WHEN <uWhen> ] ;
             [ VALID <uValid> ] ;
             [ <lDesign: DESIGN> ] ;
       => ;
          [ <oBmp> := ] TImage():New( <nRow>, <nCol>, <nWidth>, <nHeight>,;
             <cResName>, <cBmpFile>, <.NoBorder.>, <oWnd>,;
             [\{ |nRow,nCol,nKeyFlags| <uLClick> \} ],;
             [\{ |nRow,nCol,nKeyFlags| <uRClick> \} ], <.scroll.>,;
             <.adjust.>, <oCursor>, <cMsg>, <.update.>,;
             <{uWhen}>, <.pixel.>, <{uValid}>, <.lDesign.> )

#xcommand REDEFINE BITMAP [ <oBmp> ] ;
             [ ID <nId> ] ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <resource: NAME, RESNAME, RESOURCE> <cResName> ] ;
             [ <file: FILE, FILENAME, DISK> <cBmpFile> ] ;
             [ <lClick: ON ClICK, ON LEFT CLICK> <uLClick> ] ;
             [ <rClick: ON RIGHT CLICK> <uRClick> ] ;
             [ <scroll: SCROLL> ] ;
             [ <adjust: ADJUST> ] ;
             [ CURSOR <oCursor> ] ;
             [ MESSAGE <cMsg>   ] ;
             [ <update: UPDATE> ] ;
             [ WHEN <uWhen> ] ;
             [ VALID <uValid> ] ;
             [ <transparent: TRANSPARENT> ] ;
       => ;
          [ <oBmp> := ] TBitmap():ReDefine( <nId>, <cResName>, <cBmpFile>,;
             <oWnd>, [\{ |nRow,nCol,nKeyFlags| <uLClick> \}],;
                     [\{ |nRow,nCol,nKeyFlags| <uRClick> \}],;
             <.scroll.>, <.adjust.>, <oCursor>, <cMsg>, <.update.>,;
             <{uWhen}>, <{uValid}>, <.transparent.> )

#xcommand REDEFINE IMAGE [ <oBmp> ] ;
             [ ID <nId> ] ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <resource: NAME, RESNAME, RESOURCE> <cResName> ] ;
             [ <file: FILE, FILENAME, DISK> <cBmpFile> ] ;
             [ <lClick: ON ClICK, ON LEFT CLICK> <uLClick> ] ;
             [ <rClick: ON RIGHT CLICK> <uRClick> ] ;
             [ <scroll: SCROLL> ] ;
             [ <adjust: ADJUST> ] ;
             [ CURSOR <oCursor> ] ;
             [ MESSAGE <cMsg>   ] ;
             [ <update: UPDATE> ] ;
             [ WHEN <uWhen> ] ;
             [ VALID <uValid> ] ;
             [ <transparent: TRANSPARENT> ] ;
       => ;
          [ <oBmp> := ] TImage():ReDefine( <nId>, <cResName>, <cBmpFile>,;
             <oWnd>, [\{ |nRow,nCol,nKeyFlags| <uLClick> \}],;
                     [\{ |nRow,nCol,nKeyFlags| <uRClick> \}],;
             <.scroll.>, <.adjust.>, <oCursor>, <cMsg>, <.update.>,;
             <{uWhen}>, <{uValid}>, <.transparent.> )

#xcommand DEFINE BITMAP [<oBmp>] ;
             [ <resource: RESOURCE, NAME, RESNAME> <cResName> ] ;
             [ <file: FILE, FILENAME, DISK> <cBmpFile> ] ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
       => ;
          [ <oBmp> := ] TBitmap():Define( <cResName>, <cBmpFile>, <oWnd> )

#xcommand DEFINE IMAGE [<oImg>] ;
             [ <resource: RESOURCE, NAME, RESNAME> <cResName> ] ;
             [ <file: FILE, FILENAME, DISK> <cFileName> ] ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
       => ;
          [ <oImg> := ] TImage():Define( <cResName>, <cFileName>, <oWnd> )

/*----------------------------------------------------------------------------//
!short: SAY  */

#xcommand REDEFINE SAY [<oSay>] ;
             [ <label: PROMPT, VAR> <cText> ] ;
             [ <pict: PICT, PICTURE> <cPict> ] ;
             [ ID <nId> ] ;
             [ <dlg: OF,WINDOW,DIALOG > <oWnd> ] ;
             [ <color: COLOR,COLORS > <nClrText> [,<nClrBack> ] ] ;
             [ <update: UPDATE > ] ;
             [ FONT <oFont> ] ;
             [ <trans: TRANSPARENT> ] ;
             [ <adj: ADJUST> ] ;
       => ;
          [ <oSay> := ] TSay():ReDefine( <nId>, <{cText}>, <oWnd>, ;
                        <cPict>, <nClrText>, <nClrBack>, <.update.>, <oFont>, <.trans.>, <.adj.> )

#xcommand @ <nRow>, <nCol> SAY [ <oSay> <label: PROMPT,VAR > ] <cText> ;
             [ <pict: PICT, PICTURE> <cPict> ] ;
             [ <dlg: OF,WINDOW,DIALOG > <oWnd> ] ;
             [ FONT <oFont> ]  ;
             [ <lCenter: CENTERED, CENTER > ] ;
             [ <lRight:  RIGHT >    ] ;
             [ <lBorder: BORDER >   ] ;
             [ <lPixel: PIXEL, PIXELS > ] ;
             [ <color: COLOR,COLORS > <nClrText> [,<nClrBack> ] ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ <design: DESIGN >  ] ;
             [ <update: UPDATE >  ] ;
             [ <lShaded: SHADED, SHADOW > ] ;
             [ <lBox:    BOX   >  ] ;
             [ <lRaised: RAISED > ] ;
             [ <adj: ADJUST> ] ;
             [ <lTrans: TRANSPARENT>];
      => ;
          [ <oSay> := ] TSay():New( <nRow>, <nCol>, <{cText}>,;
             [<oWnd>], [<cPict>], <oFont>, <.lCenter.>, <.lRight.>, <.lBorder.>,;
             <.lPixel.>, <nClrText>, <nClrBack>, <nWidth>, <nHeight>,;
             <.design.>, <.update.>, <.lShaded.>, <.lBox.>, <.lRaised.>, <.adj.>, <.lTrans.> )

/*----------------------------------------------------------------------------//
!short: GET  */

#command @ <nRow>, <nCol> EDIT [ <oEdit> VAR ] <uVar> ;
            [ <dlg: OF, WINDOW, DIALOG> <oWnd> ] ;
            [ SIZE <nWidth>, <nHeight> ]  ;
       => ;
          [ <oEdit> := ] TEdit():New( <nRow>, <nCol>, bSETGET(<uVar>),;
             [<oWnd>], <nWidth>, <nHeight> )

/*----------------------------------------------------------------------------//
!short: GET  */

#xcommand REDEFINE GET [ <oGet> VAR ] <uVar> ;
             [ <memo: MULTILINE, MEMO, TEXT> ] ;
             [ ID <nId> ] ;
             [ <dlg: OF, WINDOW, DIALOG> <oDlg> ] ;
             [ <help:HELPID, HELP ID> <nHelpId> ] ;
             [ <color: COLOR,COLORS> <nClrFore> [,<nClrBack>] ] ;
             [ FONT <oFont> ] ;
             [ CURSOR <oCursor> ] ;
             [ MESSAGE <cMsg> ] ;
             [ <update: UPDATE> ] ;
             [ WHEN <uWhen> ] ;
             [ <readonly: READONLY, NO MODIFY> ] ;
             [ VALID <uValid> ] ;
             [ ON CHANGE <uChange> ] ;
       => ;
          [ <oGet> := ] TMultiGet():ReDefine( <nId>, bSETGET(<uVar>),;
             <oDlg>, <nHelpId>, <nClrFore>, <nClrBack>, <oFont>, <oCursor>,;
             <cMsg>, <.update.>, <{uWhen}>, <.readonly.>, <{uValid}>,;
             [\{|nKey, nFlags, Self| <uChange>\}] )

#xcommand REDEFINE GET [ <oGet> VAR ] <uVar> ;
             [ ID <nId> ] ;
             [ <dlg: OF, WINDOW, DIALOG> <oDlg> ] ;
             [ <help:HELPID, HELP ID> <nHelpId> ] ;
             [ VALID   <ValidFunc> ]       ;
             [ <pict: PICT, PICTURE> <cPict> ] ;
             [ <color:COLOR,COLORS> <nClrFore> [,<nClrBack>] ] ;
             [ FONT <oFont> ] ;
             [ CURSOR <oCursor> ] ;
             [ MESSAGE <cMsg> ] ;
             [ <update: UPDATE> ] ;
             [ WHEN <uWhen> ] ;
             [ ON CHANGE <uChange> ] ;
             [ <readonly: READONLY, NO MODIFY> ] ;
             [ <spin: SPINNER> [ON UP <SpnUp>] [ON DOWN <SpnDn>] [MIN <Min>] [MAX <Max>] ] ;
             [ ACTION <uAction> ] ;
             [ BITMAP <cBmpName> ] ;
             [ CUEBANNER <cCueText> ] ;
       => ;
          [ <oGet> := ] TGet():ReDefine( <nId>, bSETGET(<uVar>), <oDlg>,;
             <nHelpId>, <cPict>, <{ValidFunc}>, <nClrFore>, <nClrBack>,;
             <oFont>, <oCursor>, <cMsg>, <.update.>, <{uWhen}>,;
             [ \{|nKey,nFlags,Self| <uChange> \}], <.readonly.>,;
             <.spin.>, <{SpnUp}>, <{SpnDn}>, <{Min}>, <{Max}>, [\{|self| <uAction> \}], <cBmpName>, <"uVar">,;
             [<cCueText>] )

#command @ <nRow>, <nCol> GET [ <oGet> VAR ] <uVar> ;
            [ <dlg: OF, WINDOW, DIALOG> <oWnd> ] ;
            [ <memo: MULTILINE, MEMO, TEXT> ] ;
            [ <color:COLOR,COLORS> <nClrFore> [,<nClrBack>] ] ;
            [ SIZE <nWidth>, <nHeight> ] ;
            [ FONT <oFont> ] ;
            [ <hscroll: HSCROLL> ] ;
            [ CURSOR <oCursor> ] ;
            [ <pixel: PIXEL> ] ;
            [ MESSAGE <cMsg> ] ;
            [ <update: UPDATE> ] ;
            [ WHEN <uWhen> ] ;
            [ <lCenter: CENTER, CENTERED> ] ;
            [ <lRight: RIGHT> ] ;
            [ <readonly: READONLY, NO MODIFY> ] ;
            [ VALID <uValid> ] ;
            [ ON CHANGE <uChange> ] ;
            [ <lDesign: DESIGN> ] ;
            [ <lNoBorder: NO BORDER, NOBORDER> ] ;
            [ <lNoVScroll: NO VSCROLL> ] ;
       => ;
          [ <oGet> := ] TMultiGet():New( <nRow>, <nCol>, bSETGET(<uVar>),;
             [<oWnd>], <nWidth>, <nHeight>, <oFont>, <.hscroll.>,;
             <nClrFore>, <nClrBack>, <oCursor>, <.pixel.>,;
             <cMsg>, <.update.>, <{uWhen}>, <.lCenter.>,;
             <.lRight.>, <.readonly.>, <{uValid}>,;
             [\{|nKey, nFlags, Self| <uChange>\}], <.lDesign.>,;
             [<.lNoBorder.>], [<.lNoVScroll.>] )

#command @ <nRow>, <nCol> GET [ <oGet> VAR ] <uVar> ;
            [ <dlg: OF, WINDOW, DIALOG> <oWnd> ] ;
            [ <pict: PICT, PICTURE> <cPict> ] ;
            [ VALID <ValidFunc> ] ;
            [ <color:COLOR,COLORS> <nClrFore> [,<nClrBack>] ] ;
            [ SIZE <nWidth>, <nHeight> ]  ;
            [ FONT <oFont> ] ;
            [ <design: DESIGN> ] ;
            [ CURSOR <oCursor> ] ;
            [ <pixel: PIXEL> ] ;
            [ MESSAGE <cMsg> ] ;
            [ <update: UPDATE> ] ;
            [ WHEN <uWhen> ] ;
            [ <lCenter: CENTER, CENTERED> ] ;
            [ <lRight: RIGHT> ] ;
            [ ON CHANGE <uChange> ] ;
            [ <readonly: READONLY, NO MODIFY> ] ;
            [ <pass: PASSWORD> ] ;
            [ <lNoBorder: NO BORDER, NOBORDER> ] ;
            [ <help:HELPID, HELP ID> <nHelpId> ] ;
            [ ACTION <uAction> ] ;
            [ BITMAP <cBmpName> ] ;
            [ CUEBANNER <cCueText> ] ;
       => ;
          [ <oGet> := ] TGet():New( <nRow>, <nCol>, bSETGET(<uVar>),;
             [<oWnd>], <nWidth>, <nHeight>, <cPict>, <{ValidFunc}>,;
             <nClrFore>, <nClrBack>, <oFont>, <.design.>,;
             <oCursor>, <.pixel.>, <cMsg>, <.update.>, <{uWhen}>,;
             <.lCenter.>, <.lRight.>,;
             [\{|nKey, nFlags, Self| <uChange>\}], <.readonly.>,;
             <.pass.>, [<.lNoBorder.>], <nHelpId>,,,,,, [\{|self| <uAction> \}], <cBmpName>, <"uVar">,;
             [<cCueText>] )

#command @ <nRow>, <nCol> GET [ <oGet> VAR ] <uVar> ;
            [ <dlg: OF, WINDOW, DIALOG> <oWnd> ] ;
            [ <pict: PICT, PICTURE> <cPict> ] ;
            [ VALID <ValidFunc> ] ;
            [ <color:COLOR,COLORS> <nClrFore> [,<nClrBack>] ] ;
            [ SIZE <nWidth>, <nHeight> ]  ;
            [ FONT <oFont> ] ;
            [ <design: DESIGN> ] ;
            [ CURSOR <oCursor> ] ;
            [ <pixel: PIXEL> ] ;
            [ MESSAGE <cMsg> ] ;
            [ <update: UPDATE> ] ;
            [ WHEN <uWhen> ] ;
            [ <lCenter: CENTER, CENTERED> ] ;
            [ <lRight: RIGHT> ] ;
            [ ON CHANGE <uChange> ] ;
            [ <readonly: READONLY, NO MODIFY> ] ;
            [ <help:HELPID, HELP ID> <nHelpId> ] ;
            [ <spin: SPINNER> [ON UP <SpnUp>] [ON DOWN <SpnDn>] [MIN <Min>] [MAX <Max>] ] ;
            [ CUEBANNER <cCueText> ] ;
       => ;
          [ <oGet> := ] TGet():New( <nRow>, <nCol>, bSETGET(<uVar>),;
             [<oWnd>], <nWidth>, <nHeight>, <cPict>, <{ValidFunc}>,;
             <nClrFore>, <nClrBack>, <oFont>, <.design.>,;
             <oCursor>, <.pixel.>, <cMsg>, <.update.>, <{uWhen}>,;
             <.lCenter.>, <.lRight.>,;
             [\{|nKey, nFlags, Self| <uChange>\}], <.readonly.>,;
             .f., .f., <nHelpId>,;
             <.spin.>, <{SpnUp}>, <{SpnDn}>, <{Min}>, <{Max}>,,, <"uVar">, [<cCueText>] )

/*----------------------------------------------------------------------------//
!short: SCROLLBAR */

#xcommand @ <nRow>, <nCol> SCROLLBAR [ <oSbr> ] ;
             [ <h: HORIZONTAL> ] ;
             [ <v: VERTICAL> ] ;
             [ RANGE <nMin>, <nMax> ] ;
             [ PAGESTEP <nPgStep> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ <up:UP, ON UP> <uUpAction> ] ;
             [ <dn:DOWN, ON DOWN> <uDownAction> ] ;
             [ <pgup:PAGEUP, ON PAGEUP> <uPgUpAction> ] ;
             [ <pgdn:PAGEDOWN, ON PAGEDOWN> <uPgDownAction> ] ;
             [ <pos: ON THUMBPOS> <uPos> ] ;
             [ <pixel: PIXEL> ] ;
             [ <color: COLOR,COLORS> <nClrText> [,<nClrBack>] ] ;
             [ OF <oWnd> ] ;
             [ MESSAGE <cMsg> ] ;
             [ <update: UPDATE> ] ;
             [ WHEN <uWhen> ] ;
             [ VALID <uValid> ] ;
             [ <lDesign: DESIGN> ] ;
       => ;
          [ <oSbr> := ] TScrollBar():New( <nRow>, <nCol>, <nMin>, <nMax>, <nPgStep>,;
             (.not.<.h.>) [.or. <.v.> ], <oWnd>, <nWidth>, <nHeight> ,;
             [<{uUpAction}>], [<{uDownAction}>], [<{uPgUpAction}>], ;
             [<{uPgDownAction}>], [\{|nPos| <uPos> \}], [<.pixel.>],;
             <nClrText>, <nClrBack>, <cMsg>, <.update.>, <{uWhen}>, <{uValid}>,;
             <.lDesign.> )

// for 'non-true ScrollBars' ( when using WS_VSCROLL or WS_HSCROLL styles )

#xcommand DEFINE SCROLLBAR [ <oSbr> ] ;
             [ <h: HORIZONTAL> ] ;
             [ <v: VERTICAL> ] ;
             [ RANGE <nMin>, <nMax> ] ;
             [ PAGESTEP <nPgStep> ] ;
             [ <up:UP, ON UP> <uUpAction> ] ;
             [ <dn:DOWN, ON DOWN> <uDownAction> ] ;
             [ <pgup:PAGEUP, ON PAGEUP> <uPgUpAction> ] ;
             [ <pgdn:PAGEDOWN, ON PAGEDOWN> <uPgDownAction> ] ;
             [ <pos: ON THUMBPOS> <uPos> ] ;
             [ <color: COLOR,COLORS> <nClrText> [,<nClrBack>] ] ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ MESSAGE <cMsg> ] ;
             [ <update: UPDATE> ] ;
             [ WHEN <uWhen> ] ;
             [ VALID <uValid> ] ;
       => ;
             [ <oSbr> := ] TScrollBar():WinNew( <nMin>, <nMax>, <nPgStep>, ;
             (.not.<.h.>) [.or. <.v.> ], <oWnd>, [<{uUpAction}>],;
             [<{uDownAction}>], [<{uPgUpAction}>], ;
             [<{uPgDownAction}>], [\{|nPos| <uPos> \}],;
             <nClrText>, <nClrBack>, <cMsg>, <.update.>, <{uWhen}>, <{uValid}> )

#xcommand REDEFINE SCROLLBAR [ <oSbr> ] ;
             [ ID <nID>  ] ;
             [ RANGE <nMin>, <nMax> ] ;
             [ PAGESTEP <nPgStep> ] ;
             [ <up:UP, ON UP, ON LEFT> <uUpAction> ] ;
             [ <dn:DOWN, ON DOWN, ON RIGHT> <uDownAction> ] ;
             [ <pgup:PAGEUP, ON PAGEUP> <uPgUpAction> ] ;
             [ <pgdn:PAGEDOWN, ON PAGEDOWN> <uPgDownAction> ] ;
             [ <pos: ON THUMBPOS> <uPos> ] ;
             [ <color: COLOR,COLORS> <nClrText> [,<nClrBack>] ] ;
             [ OF <oDlg> ] ;
             [ MESSAGE <cMsg> ] ;
             [ <update: UPDATE> ] ;
             [ WHEN <uWhen> ] ;
             [ VALID <uValid> ] ;
       => ;
          [ <oSbr> := ] TScrollBar():Redefine( <nID>, <nMin>, <nMax>, <nPgStep>,;
            <oDlg>, [<{uUpAction}>], [<{uDownAction}>], [<{uPgUpAction}>], ;
            [<{uPgDownAction}>], [\{|nPos| <uPos> \}], <nClrText>,;
            <nClrBack>, <cMsg>, <.update.>, <{uWhen}>, <{uValid}> )

/*----------------------------------------------------------------------------//
!short: SCROLLBAR METRO UI */

#xcommand @ <nRow>, <nCol> SCROLLMETRO [ <oSbr> ] ;
             [ <h: HORIZONTAL> ] ;
             [ <v: VERTICAL> ] ;
             [ RANGE <nMin>, <nMax> ] ;
             [ PAGESTEP <nPgStep> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ <up:UP, ON UP> <uUpAction> ] ;
             [ <dn:DOWN, ON DOWN> <uDownAction> ] ;
             [ <pgup:PAGEUP, ON PAGEUP> <uPgUpAction> ] ;
             [ <pgdn:PAGEDOWN, ON PAGEDOWN> <uPgDownAction> ] ;
             [ <pos: ON THUMBPOS> <uPos> ] ;
             [ <pixel: PIXEL> ] ;
             [ <color: COLOR,COLORS> <nClrText> [,<nClrBack>] ] ;
             [ OF <oWnd> ] ;
             [ MESSAGE <cMsg> ] ;
             [ <update: UPDATE> ] ;
             [ WHEN <uWhen> ] ;
             [ VALID <uValid> ] ;
             [ <lDesign: DESIGN> ] ;
       => ;
          [ <oSbr> := ] TScrollMetro():New( <nRow>, <nCol>, <nMin>, <nMax>, <nPgStep>,;
             (.not.<.h.>) [.or. <.v.> ], <oWnd>, <nWidth>, <nHeight> ,;
             [<{uUpAction}>], [<{uDownAction}>], [<{uPgUpAction}>], ;
             [<{uPgDownAction}>], [\{|nPos| <uPos> \}], [<.pixel.>],;
             <nClrText>, <nClrBack>, <cMsg>, <.update.>, <{uWhen}>, <{uValid}>,;
             <.lDesign.> )

/*----------------------------------------------------------------------------//
!short: BOX - GROUPS */

#xcommand @ <nTop>, <nLeft> GROUP [ <oGroup> ] ;
             [ TO <nBottom>, <nRight> ] ;
             [ <label:LABEL,PROMPT> <cLabel> ] ;
             [ OF <oWnd> ] ;
             [ COLOR <nClrFore> [,<nClrBack>] ] ;
             [ <lPixel: PIXEL> ] ;
             [ <lDesign: DESIGN> ] ;
             [ FONT <oFont> ] ;
             [ <lTransparent: TRANSPARENT> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
       => ;
          [ <oGroup> := ] TGroup():New( <nTop>, <nLeft>, <nBottom>, <nRight>,;
             <cLabel>, <oWnd>, <nClrFore>, <nClrBack>, <.lPixel.>,;
             [<.lDesign.>], [<oFont>], [<.lTransparent.>], <nWidth>, <nHeight> )

#xcommand REDEFINE GROUP [ <oGroup> ] ;
             [ <label:LABEL,PROMPT> <cLabel> ] ;
             [ ID <nId> ] ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ COLOR <nClrFore> [,<nClrBack>] ] ;
             [ FONT <oFont> ] ;
             [ <lTransparent: TRANSPARENT> ] ;
       => ;
          [ <oGroup> := ] TGroup():ReDefine( <nId>, <cLabel>, <oWnd>,;
             <nClrFore>, <nClrBack>, [<oFont>], [<.lTransparent.>] )

/*----------------------------------------------------------------------------//
!short: Meter  */

#xcommand @ <nRow>, <nCol> METER [ <oMeter> VAR ] <nActual> ;
           [ TOTAL <nTotal> ] ;
           [ SIZE <nWidth>, <nHeight> ];
           [ OF <oWnd> ] ;
           [ <update: UPDATE > ] ;
           [ <lPixel: PIXEL > ] ;
           [ FONT <oFont> ] ;
           [ PROMPT <cPrompt> ] ;
           [ <lNoPercentage: NOPERCENTAGE > ] ;
           [ <color: COLOR, COLORS> <nClrPane>, <nClrText> ] ;
           [ BARCOLOR <nClrBar>, <nClrBText> ] ;
           [ <lDesign: DESIGN> ] ;
     => ;
        [ <oMeter> := ] TMeter():New( <nRow>, <nCol>, bSETGET(<nActual>),;
           <nTotal>, <oWnd>, <nWidth>, <nHeight>, <.update.>, ;
           <.lPixel.>, <oFont>, <cPrompt>, <.lNoPercentage.>,;
           <nClrPane>, <nClrText>, <nClrBar>, <nClrBText>, <.lDesign.> )

#xcommand REDEFINE METER [ <oMeter> VAR ] <nActual> ;
             [ TOTAL <nTotal> ] ;
             [ ID <nId> ];
             [ OF <oWnd> ] ;
             [ <update: UPDATE > ] ;
             [ FONT <oFont> ] ;
             [ PROMPT <cPrompt> ] ;
             [ <lNoPercentage: NOPERCENTAGE > ] ;
             [ <color: COLOR, COLORS> <nClrPane>, <nClrText> ] ;
             [ BARCOLOR <nClrBar>, <nClrBText> ] ;
       => ;
          [ <oMeter> := ] TMeter():ReDefine( <nId>, bSETGET(<nActual>),;
              <nTotal>, <oWnd>, <.update.>, <oFont>, <cPrompt>, <.lNoPercentage.>, ;
              <nClrPane>, <nClrText>, <nClrBar>, <nClrBText> )

/*----------------------------------------------------------------------------//
!short: MeterEx*/

#xcommand @ <nRow>, <nCol> METEREX [ <oMeter> VAR ] <nActual> ;
           [ TOTAL <nTotal> ] ;
           [ SIZE <nWidth>, <nHeight> ];
           [ OF <oWnd> ] ;
           [ <update: UPDATE > ] ;
           [ <lPixel: PIXEL > ] ;
           [ <lDesign: DESIGN> ] ;
           [ BITMAP <cBitmap> ];
           [ <lRound: ROUND> [ ROUNDSIZE <nRound> ] ];
           [ GRADIENT TRACK <aGradTrack> ];
           [ GRADIENT CHUNK <aGradChunk> ];
           [ LINECOLORS <nClrBoxIn> [, <nClrBoxOut> ] ];
           [ <vertical: VERTICAL> ];
           [ <inverted: INVERTED> ];
           [ ON PAINT <uPaint> ] ;
           [ <upd: UPDATE> ];
     => ;
        [ <oMeter> := ] TMeterEx():New( <nRow>, <nCol>, <oWnd>, <nWidth>, <nHeight>, <cBitmap>,;
                                        bSETGET( <nActual> ), <nTotal>, <.lPixel.>, <.lDesign.>,;
                                        <.lRound.>, <nRound>, <aGradTrack>, <aGradChunk>, <nClrBoxIn>, ;
                                        <nClrBoxOut>, <.vertical.>, <.inverted.>, [{|hDC|<uPaint>}], <.upd.> )

#xcommand REDEFINE METEREX [ <oMeter> VAR ] <nActual>;
           [ TOTAL <nTotal> ] ;
           [ ID <nId> ];
           [ OF <oWnd> ] ;
           [ <update: UPDATE > ] ;
           [ BITMAP <cBitmap> ];
           [ <lRound: ROUND> [ ROUNDSIZE <nRound> ] ];
           [ GRADIENT TRACK <aGradTrack> ];
           [ GRADIENT CHUNK <aGradChunk> ];
           [ LINECOLORS <nClrBoxIn> [, <nClrBoxOut> ] ];
           [ <vertical: VERTICAL> ];
           [ <inverted: INVERTED> ];
           [ ON PAINT <uPaint> ] ;
           [ <upd: UPDATE> ];
       => ;
          [ <oMeter> := ] TMeterEx():Redefine( <nId>, bSETGET( <nActual> ), <nTotal>,;
                                              <oWnd>, <cBitmap>, <.lRound.>, <nRound>,;
                                              <aGradTrack>, <aGradChunk>,<nClrBoxIn>, ;
                                              <nClrBoxOut>, <.vertical.>, <.inverted.>, ;
                                              [{|hDC|<uPaint>}], <.upd.> )

/*----------------------------------------------------------------------------//
!short: MetaFile Controls  */

#xcommand @ <nRow>, <nCol> METAFILE [<oMeta>] ;
             [ <file: FILE, FILENAME, DISK> <cMetaFile> ] ;
             [ <dlg: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ <color: COLOR, COLORS> <nClrFore> [,<nClrBack>] ] ;
       => ;
          [<oMeta> := ] TMetaFile():New( <nRow>, <nCol>, <nWidth>, <nHeight>,;
             <cMetaFile>, <oWnd>, <nClrFore>, <nClrBack> )

#xcommand REDEFINE METAFILE [<oMeta>] ;
             [ ID <nId> ] ;
             [ <file: FILE, FILENAME, DISK> <cMetaFile> ] ;
             [ <dlg: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <color: COLOR, COLORS> <nClrFore> [,<nClrBack>] ] ;
       => ;
          [ <oMeta> := ] TMetaFile():Redefine( <nId>, <cMetaFile>, <oWnd>,;
             <nClrFore>, <nClrBack> )

/*----------------------------------------------------------------------------//
!short: Cursor Commands */

#xcommand DEFINE CURSOR <oCursor> ;
             [ <resource: RESOURCE, RESNAME, NAME> <cResName> ] ;
             [ <predef: ARROW, ICON, SIZENS, SIZEWE, SIZENWSE,;
               SIZENESW, IBEAM, CROSS, SIZE, UPARROW, WAIT, HAND, DRAG, STOP> ] ;
       => ;
          <oCursor> := TCursor():New( <cResName>, [ Upper(<(predef)>) ] )

/*----------------------------------------------------------------------------//
!short: Window Commands */

#xcommand DEFINE WINDOW [<oWnd>] ;
             [ MDICHILD ] ;
             [ FROM <nTop>, <nLeft> TO <nBottom>, <nRight> ] ;
             [ TITLE <cTitle> ] ;
             [ BRUSH <oBrush> ] ;
             [ CURSOR <oCursor> ] ;
             [ MENU <oMenu> ] ;
             [ MENUINFO <nMenuInfo> ] ;
             [ ICON <oIco> ] ;
             [ OF <oParent> ] ;
             [ <vscroll: VSCROLL, VERTICAL SCROLL> ] ;
             [ <hscroll: HSCROLL, HORIZONTAL SCROLL> ] ;
             [ <color: COLOR, COLORS> <nClrFore> [,<nClrBack>] ] ;
             [ <pixel: PIXEL> ] ;
             [ STYLE <nStyle> ] ;
             [ <HelpId: HELPID, HELP ID> <nHelpId> ] ;
             [ BORDER <border: NONE, SINGLE> ] ;
             [ <NoSysMenu:  NOSYSMENU, NO SYSMENU> ] ;
             [ <NoCaption:  NOCAPTION, NO CAPTION, NO TITLE> ] ;
             [ <NoIconize:  NOICONIZE, NOMINIMIZE> ] ;
             [ <NoMaximize: NOZOOM, NO ZOOM, NOMAXIMIZE, NO MAXIMIZE> ] ;
       => ;
          [<oWnd> := ] TMdiChild():New( <nTop>, <nLeft>, <nBottom>, <nRight>,;
             <cTitle>, <nStyle>, <oMenu>, <oParent>, <oIco>, <.vscroll.>, <nClrFore>,;
             <nClrBack>, <oCursor>, <oBrush>, <.pixel.>, <.hscroll.>,;
             <nHelpId>, [Upper(<(border)>)], !<.NoSysMenu.>, !<.NoCaption.>,;
             !<.NoIconize.>, !<.NoMaximize.>, [<nMenuInfo>] )

#xcommand DEFINE WINDOW <oWnd> ;
             [ FROM <nTop>, <nLeft> TO <nBottom>, <nRight> ] ;
             [ TITLE <cTitle> ] ;
             [ STYLE <nStyle> ] ;
             [ MENU  <oMenu> ] ;
             [ BRUSH <oBrush> ] ;
             [ ICON  <oIcon> ] ;
             [ MDI ] ;
             [ <color: COLOR, COLORS> <nClrFore> [,<nClrBack>] ] ;
             [ <vScroll: VSCROLL, VERTICAL SCROLL> ] ;
             [ <hScroll: HSCROLL, HORIZONTAL SCROLL> ] ;
             [ MENUINFO <nMenuInfo> ] ;
             [ [ BORDER ] <border: NONE, SINGLE> ] ;
             [ OF <oParent> ] ;
             [ <pixel: PIXEL> ] ;
       => ;
          <oWnd> := TMdiFrame():New( <nTop>, <nLeft>, <nBottom>, <nRight>,;
             <cTitle>, <nStyle>, <oMenu>, <oBrush>, <oIcon>, <nClrFore>,;
             <nClrBack>, [<.vScroll.>], [<.hScroll.>], <nMenuInfo>,;
             [Upper(<(border)>)], <oParent>, [<.pixel.>] )

#xcommand DEFINE WINDOW <oWnd> ;
             [ FROM <nTop>, <nLeft> TO <nBottom>, <nRight> [<pixel: PIXEL>] ] ;
             [ TITLE <cTitle> ] ;
             [ <color: COLOR, COLORS> <nClrFore> [,<nClrBack>] ];
             [ OF <oParent> ] ;
             [ BRUSH <oBrush> ] ;                         // Contained Objects
             [ CURSOR <oCursor> ] ;
             [ ICON  <oIcon> ] ;
             [ MENU <oMenu> ] ;
             [ STYLE <nStyle> ] ;                          // Styles
             [ BORDER <border: NONE, SINGLE> ] ;
             [ <NoSysMenu:  NOSYSMENU, NO SYSMENU> ] ;
             [ <NoCaption:  NOCAPTION, NO CAPTION, NO TITLE> ] ;
             [ <NoIconize:  NOICONIZE, NOMINIMIZE> ] ;
             [ <NoMaximize: NOZOOM, NO ZOOM, NOMAXIMIZE, NO MAXIMIZE> ] ;
             [ <vScroll: VSCROLL, VERTICAL SCROLL> ] ;
             [ <hScroll: HSCROLL, HORIZONTAL SCROLL> ] ;
       => ;
          <oWnd> := TWindow():New( <nTop>, <nLeft>, <nBottom>, <nRight>,;
             <cTitle>, <nStyle>, <oMenu>, <oBrush>, <oIcon>, <oParent>,;
             [<.vScroll.>], [<.hScroll.>], <nClrFore>, <nClrBack>, <oCursor>,;
             [Upper(<(border)>)], !<.NoSysMenu.>, !<.NoCaption.>,;
             !<.NoIconize.>, !<.NoMaximize.>, <.pixel.> )

#xcommand ACTIVATE WINDOW <oWnd> ;
             [ <show: ICONIZED, NORMAL, MAXIMIZED, HIDDEN> ] ;
             [ ON [ LEFT ] CLICK <uLClick> ] ;
             [ ON LBUTTONUP <uLButtonUp> ] ;
             [ ON RIGHT CLICK <uRClick> ] ;
             [ ON MOVE <uMove> ] ;
             [ ON RESIZE <uResize> ] ;
             [ ON PAINT <uPaint> ] ;
             [ ON KEYDOWN <uKeyDown> ] ;
             [ ON INIT <uInit> ] ;
             [ ON UP <uUp> ] ;
             [ ON DOWN <uDown> ] ;
             [ ON PAGEUP <uPgUp> ] ;
             [ ON PAGEDOWN <uPgDn> ] ;
             [ ON LEFT <uLeft> ] ;
             [ ON RIGHT <uRight> ] ;
             [ ON PAGELEFT <uPgLeft> ] ;
             [ ON PAGERIGHT <uPgRight> ] ;
             [ ON DROPFILES <uDropFiles> ] ;
             [ VALID <uValid> ] ;
       => ;
          <oWnd>:Activate( [ Upper(<(show)>) ],;
                           <oWnd>:bLClicked [ := \{ |nRow,nCol,nKeyFlags| <uLClick> \} ], ;
                           <oWnd>:bRClicked [ := \{ |nRow,nCol,nKeyFlags| <uRClick> \} ], ;
                           <oWnd>:bMoved    [ := <{uMove}> ], ;
                           <oWnd>:bResized  [ := \{ | nSizeType, nWidth, nHeight | <uResize> \} ], ;
                           <oWnd>:bPainted  [ := \{ | hDC, cPS | <uPaint> \} ], ;
                           <oWnd>:bKeyDown  [ := \{ | nKey | <uKeyDown> \} ],;
                           <oWnd>:bInit     [ := \{ | Self | <uInit> \} ],;
                           [<{uUp}>], [<{uDown}>], [<{uPgUp}>], [<{uPgDn}>],;
                           [<{uLeft}>], [<{uRight}>], [<{uPgLeft}>], [<{uPgRight}>],;
                           [<{uValid}>], [\{|nRow,nCol,aFiles|<uDropFiles>\}],;
                           <oWnd>:bLButtonUp [ := \{ |nRow,nCol,nKeyFlags| <uLButtonUp> \} ] )

/*----------------------------------------------------------------------------//
!short: MESSAGE BAR */

#xcommand SET <msg: MESSAGE, MESSAGE BAR, MSGBAR> [ OF <oWnd> ] ;
             [ TO <cMsg> ] ;
             [ <center: CENTER, CENTERED> ] ;
             [ <clock: CLOCK, TIME> ] ;
             [ <date: DATE> ] ;
             [ <kbd: KEYBOARD> ] ;
             [ FONT <oFont> ] ;
             [ <color: COLOR, COLORS> <nClrFore> [,<nClrBack> ] ] ;
             [ <inset: NO INSET, NOINSET> ] ;
             [ <l2007: 2007, _2007> ] ;
             [ <l2010: 2010, _2010> ] ;
       => ;
          <oWnd>:oMsgBar := TMsgBar():New( <oWnd>, <cMsg>, <.center.>,;
                                            <.clock.>, <.date.>, <.kbd.>,;
                                            <nClrFore>, <nClrBack>, <oFont>,;
                                            [!<.inset.>], <.l2007.>, if( <.l2007.>, .F., <.l2010.> ) )

#xcommand DEFINE <msg: MESSAGE BAR, MESSAGE, MSGBAR> [<oMsg>] ;
             [ OF <oWnd> ] ;
             [ <prm: PROMPT, TITLE> <cMsg> ] ;
             [ <center: CENTER, CENTERED> ] ;
             [ <clock: CLOCK, TIME> ] ;
             [ <date: DATE> ] ;
             [ <kbd: KEYBOARD> ] ;
             [ FONT <oFont> ] ;
             [ <color: COLOR, COLORS> <nClrFore> [,<nClrBack> ] ] ;
             [ <inset: NO INSET, NOINSET> ] ;
             [ <l2007: 2007, _2007> ] ;
             [ <l2010: 2010, _2010> ] ;
      => ;
         [<oMsg> := ] TMsgBar():New( <oWnd>, <cMsg>, <.center.>,;
                                     <.clock.>, <.date.>, <.kbd.>,;
                                     <nClrFore>, <nClrBack>, <oFont>,;
                                     [!<.inset.>], <.l2007.>, if( <.l2007.>, .F., <.l2010.> ) )

#xcommand DEFINE MSGITEM [<oMsgItem>] ;
             [ OF <oMsgBar> ] ;
             [ PROMPT <cMsg> ] ;
             [ SIZE <nSize> ] ;
             [ FONT <oFont> ] ;
             [ <color: COLOR, COLORS> <nClrFore> [,<nClrBack> ] ] ;
             [ <bmp: BITMAP, BITMAPS> <cBitmap1> [, <cBitmap2> ] ] ;
             [ ACTION <uAction> ] ;
             [ TOOLTIP <cToolTip> ] ;
       => ;
          [<oMsgItem>:=] TMsgItem():New( <oMsgBar>, <cMsg>, <nSize>,;
                                         <oFont>, <nClrFore>, <nClrBack>, .t.,;
                                         [<{uAction}>],;
                                         [<cBitmap1>], [<cBitmap2>], [<cToolTip>] )

/*----------------------------------------------------------------------------//
!short: CLIPBOARD */

#xcommand DEFINE CLIPBOARD <oClp> ;
             [ FORMAT <format:TEXT,OEMTEXT,BITMAP,DIF> ] ;
             [ OF <oWnd> ] ;
       => ;
          <oClp> := TClipBoard():New( [Upper(<(format)>)], <oWnd> )

#xcommand ACTIVATE CLIPBOARD <oClp>  => <oClp>:Open()

/*----------------------------------------------------------------------------//
!short: Timer  */

#xcommand DEFINE TIMER [ <oTimer> ] ;
             [ INTERVAL <nInterval> ] ;
             [ ACTION <uAction,...> ] ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
       => ;
          [ <oTimer> := ] TTimer():New( <nInterval>, [\{||<uAction>\}], <oWnd> )

#xcommand ACTIVATE TIMER <oTimer> => <oTimer>:Activate()

/*----------------------------------------------------------------------------//
!short: Visual Basic VBX Controls Support  */

#xtranslate _PARM_BLOCK_10_( <uAction> ) => ;
            \{ |bp1,bp2,bp3,bp4,bp5,bp6,bp7,bp8,bp9,bp10| <uAction> \}

#xcommand @ <nRow>, <nCol> VBX [<oVbx>] ;
             [ OF <oWnd> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ <file: FILE, FILENAME, DISK> <cVbxFile> ] ;
             [ CLASS <cVbxClass> ] ;
             [ ON <cClause1> <uAction1> ;
             [ ON <cClauseN> <uActionN> ] ] ;
             [ WHEN <uWhen> ] ;
             [ VALID <uValid> ] ;
             [ <lPixel: PIXEL> ] ;
             [ <lDesign: DESIGN> ] ;
       => ;
          [ <oVbx> := ] TVbControl():New( <nRow>, <nCol>, <nWidth>, <nHeight>,;
             <oWnd>, <cVbxFile>, <cVbxClass>, ;
             \{ [ <(cClause1)>, _PARM_BLOCK_10_( <uAction1> ) ] ;
              [,<(cClauseN)>, _PARM_BLOCK_10_( <uActionN> ) ] ;
             \}, [<{uWhen}>], [<{uValid}>], <.lPixel.>, <.lDesign.> )

#xcommand REDEFINE VBX [<oControl>] ;
             [ ID <nId> ] ;
             [ OF <oDlg> ] ;
             [ COLOR <nClrFore> [,<nClrBack>] ] ;
             [ ON <cClause1> <uAction1> ;
             [ ON <cClauseN> <uActionN> ] ] ;
       => ;
          [ <oControl> := ] TVbControl():ReDefine( <nId>, <oDlg>,;
             <nClrFore>, <nClrBack>, ;
             \{ [ <(cClause1)>, _PARM_BLOCK_10_( <uAction1> ) ] ;
              [,<(cClauseN)>, _PARM_BLOCK_10_( <uActionN> ) ] ;
             \} )

#xcommand OBJECT <obj> AS <ClassName> => ;
          Self := SetObject( Self, { || <ClassName>():New() } )

#xcommand ENDOBJECT => Self := EndObject()

/*----------------------------------------------------------------------------//
!short: Common Controls */

#xcommand @ <nRow>, <nCol> LISTVIEW <oLvw> ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ PROMPTS <aTexts,...> ] ;
             [ ACTION <uAction> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ <lPixel: PIXEL> ] ;
             [ <lDesign: DESIGN> ] ;
             [ <color: COLOR, COLORS> <nClrFore> [,<nClrBack>] ] ;
             [ MESSAGE <cMsg> ] ;
          => ;
             [ <oLvw> := ] TListView():New( <nRow>, <nCol>,;
             [\{<aTexts>\}], [\{ | nOption, Self | <uAction> \} ], [<oWnd>],;
             [<nClrFore>], [<nClrBack>], <.lPixel.>, <.lDesign.>, [<nWidth>], [<nHeight>],;
             [<cMsg>] )

#xcommand REDEFINE LISTVIEW <oLvw> ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ ID <nId> ] ;
             [ ACTION <uAction> ] ;
          => ;
             <oLvw> := TListView():Redefine( <nId>, <oWnd>,;
                       [\{ | nOption, Self | <uAction> \} ] )

#xcommand DEFINE STATUSBAR [ <oStatusBar> ] ;
             [ OF <oWnd> ] ;
             [ <prompt: PROMPT, TEXT> <cText> ] ;
             [ SIZES <aWidths,...> ] ;
             [ PROMPTS <aTexts,...> ] ;
             [ <clock: CLOCK, TIME> ] ;
          => ;
          [ <oStatusBar> := ] TStatusBar():New( <oWnd>, <cText>,;
             [\{<aWidths>\}], [\{<aTexts>\}], [<.clock.>] )

#xcommand @ <nTop>, <nLeft> TRACKBAR <oTrack> ;
             [ <dlg: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ <pixel: PIXEL> ] ;
             [ <lDesign: DESIGN> ] ;
             [ MESSAGE <cMsg> ] ;
             [ WHEN <uWhen> ] ;
             [ ON CHANGE <uChange> ] ;
             [ MIN <nMin> ] ;
             [ MAX <nMax> ] ;
             [ POS <nPos> ] ;
             [ FREQUENCY <nFreq> ] ;
             [ TICKPOS <nTickPos> ] ;
             [ <lNoAutoTicks: NOAUTOTICKS> ] ;
             [ <lNoTooltip:   NOTOOLTIP> ] ;
             [ <lSelRange:    SELRANGE> ] ;
             [ <lVert:        VERTICAL> ] ;
       => ;
          [ <oTrack> := ] TTrackBar():New( <nTop>, <nLeft>, [<oWnd>], ;
                          <nWidth>, <nHeight>, <.pixel.>, <.lDesign.>, <cMsg>, ;
                          <{uWhen}>, [ \{ |nKey,nFlags,nSelf| <uChange> \}], ;
                          <nMin>, <nMax>, <nPos>, <nFreq>, !<.lNoAutoTicks.>, ;
                          !<.lNoTooltip.>, <.lSelRange.>, !<.lVert.>, <nTickPos> )

  #xcommand REDEFINE TRACKBAR <oTrack> ;
             [ ID <nId> ] ;
             [ <dlg: OF, WINDOW, DIALOG> <oDlg> ] ;
             [ <help: HELPID, HELP ID> <nHelpId> ] ;
             [ MESSAGE <cMsg> ] ;
             [ WHEN <uWhen> ] ;
             [ ON CHANGE <uChange> ] ;
             [ MIN <nMin> ] ;
             [ MAX <nMax> ] ;
             [ POS <nPos> ] ;
             [ FREQUENCY <nFreq> ] ;
       => ;
          [ <oTrack> := ] TTrackBar():ReDefine( <nId>, <oDlg>, ;
                          <nHelpId>, <cMsg>, <{uWhen}>, ;
                          [ \{ |nKey,nFlags,nSelf| <uChange> \}], ;
                          <nMin>, <nMax>, <nPos>, <nFreq> )

#xcommand DEFINE IMAGELIST <oImgLst> ;
             [ SIZE <nWidth>, <nHeight> ] ;
       => ;
          <oImgLst> := TImageList():New( [<nWidth>], [<nHeight>] )

#xcommand DEFINE IMGBITMAP [<oBmp>] ;
             [ <resource: RESOURCE, NAME, RESNAME> <cResName> ] ;
             [ <of: OF> <oImageList> ] ;
             [ COLOR <nClrMask> ] ;
       => ;
          <oImageList>:AddMasked( [ <oBmp> := ]TBitmap():Define( <cResName>,,;
             GetWndDefault() ), [<nClrMask>] )

#xcommand DEFINE REBAR <oReBar> ;
             [<of: OF, WINDOW, DIALOG> <oWnd> ] ;
       => ;
          <oReBar> := TReBar():New( <oWnd> )

#xcommand DEFINE TOOLBAR <oTlb> ;
             [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ IMAGELIST <oImg> ] ;
             [ <balloon: BALLOON > ] ;
       => ;
          <oTlb> := TToolBar():New( <oWnd>, [<nWidth>], [<nHeight>], [<oImg>],;
                                   [<.balloon.>] )

#xcommand DEFINE TBBUTTON ;
             [ OF <oToolBar> ] ;
             [ ACTION <uAction> ] ;
             [ TOOLTIP <cToolTip> ] ;
             [ PROMPT <cPrompt> ] ;
             [ WHEN <uWhen> ] ;
             [ MESSAGE <cMsg> ] ;
       => ;
          <oToolBar>:AddButton( [<{uAction}>], [<cToolTip>], [<cPrompt>],;
                                [<{uWhen}>], [<cMsg>] )

#xcommand DEFINE TBMENU ;
             [ OF <oToolBar> ] ;
             [ ACTION <uAction> ] ;
             [ TOOLTIP <cToolTip> ] ;
             [ PROMPT <cPrompt> ] ;
             [ WHEN <uWhen> ] ;
             [ MESSAGE <cMsg> ] ;
             [ MENU <oMenu> ] ;
       => ;
          <oToolBar>:AddMenu( [<{uAction}>], [<cToolTip>], [<cPrompt>],;
                              [<{uWhen}>], [<cMsg>], [<{oMenu}>] )

#xcommand DEFINE TBSEPARATOR ;
             [ OF <oToolBar> ] ;
       => ;
          <oToolBar>:AddSeparator()

#xcommand @ <nRow>, <nCol> PROGRESS <oPrg> ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <pos: POS, POSITION> <nPos> ] ;
             [ COLOR <nClrFore> [,<nClrBack>] ] ;
             [ <pixel: PIXEL> ] ;
             [ <design: DESIGN> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ MESSAGE <cMsg> ] ;
             [ <vert: VERTICAL> ] ;
             [ <lMar: MARQUEE> ];
       => ;
          <oPrg> := TProgress():New( <nRow>, <nCol>, <oWnd>, [<nPos>],;
                                     <nClrFore>, <nClrBack>, <.pixel.>, <.design.>,;
                                     <nWidth>, <nHeight>, <cMsg>, <.vert.>, <.lMar.> )

#xcommand REDEFINE PROGRESS [<oPrg>] ;
             [ ID <nId> ];
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
       => ;
          [ <oPrg> := ] TProgress():Redefine( <nId>, <oWnd> )

#xcommand @ <nRow>, <nCol> TABCONTROL [<oCtrl>] ;
             [ PROMPTS <aPrompts> ] ;
             [ OPTION <nOption> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <design: DESIGN> ] ;
             [ <pixel: PIXEL> ] ;
             [ ACTION <uAction> ] ;
             [ MESSAGE <cMsg> ] ;
             [ COLOR <nClrFore> [,<nClrBack>] ] ;
       => ;
          [ <oCtrl> := ] TTabControl():New( <nRow>, <nCol>, [<aPrompts>], [<{uAction}>],;
                                        [<oWnd>], [<nOption>], [<nClrFore>], [<nClrBack>],;
                                        [<.pixel.>], [<.design.>], [<nWidth>],;
                                        [<nHeight>], [<cMsg>] )

#xcommand @ <nRow>, <nCol> TREEVIEW [<oTV>] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <design: DESIGN> ] ;
             [ <pixel: PIXEL> ] ;
             [ COLOR <nClrFore> [,<nClrBack>] ] ;
             [ MESSAGE <cMsg> ] ;
             [ <check: CHECK, CHECKBOX, CHECKBOXES> ] ;
             [ ON CHANGE <uChange,...> ] ;
       => ;
          [ <oTV> := ] TTreeView():New( <nRow>, <nCol>, <oWnd>, <nClrFore>, <nClrBack>,;
                                        [<.pixel.>], [<.design.>], <nWidth>, <nHeight>,;
                                        [<cMsg>], [<.check.>], [ { | nOption, nOldOption | <uChange> } ] )

// Using ActiveX controls

#xcommand @ <nRow>, <nCol> ACTIVEX <oActX> ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ PROGID <cProgID> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
       => ;
          <oActX> := TActiveX():New( <oWnd>, <cProgID>, <nRow>, <nCol>, <nWidth>, <nHeight> )

#xcommand REDEFINE ACTIVEX <oActX> ;
             [ ID <nId> ];
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ PROGID <cProgID> ] ;
       => ;
          <oActX> := TActiveX():Redefine( <nId>, <oWnd>, <cProgID> )

/*----------------------------------------------------------------------------//
!short: Control TExplorerBar */

#xcommand @ <nRow>, <nCol> EXPLORERBAR <oExBar> ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
          => ;
          [ <oExBar> := ] TExplorerBar():New( <nRow>, <nCol>, <nWidth>, <nHeight>, <oWnd> )

#xcommand REDEFINE EXPLORERBAR <oExBar> ;
             [ ID <nId> ] ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
          => ;
          [ <oExBar> := ] TExplorerBar():Redefine( <nId>, <oWnd> )

/*----------------------------------------------------------------------------//
!short: Different used commands */

#xcommand CLS => InvalidateRect( GetActiveWindow(), 0, .t. )

#xcommand CLEAR SCREEN => InvalidateRect( GetActiveWindow(), 0, .t. )

#command ? [ <list,...> ] => WQout( [ \{ <list> \} ] )

#command ?? [ <list,...> ] => WQout( [ \{ <list> \} ] )

/*----------------------------------------------------------------------------//
!short: Commands & functions not supported */

#xcommand READ =>

#xcommand SAVE SCREEN [ TO <u> ] =>

#xcommand RESTORE SCREEN [ FROM <u> ] =>

#xcommand SaveScreen( <*u*> ) => ;
   MsgAlert( OemToAnsi( "SaveScreen() not available in FiveWin" ) )

#xcommand RestScreen( <*u*> ) => ;
   MsgAlert( OemToAnsi( "RestScreen() not available in FiveWin" ) )

#xcommand @ <nRow>, <nCol> PROMPT <*u*> =>

#xcommand MENU TO <u> =>

//----------------------------------------------------------------------------//

#endif
