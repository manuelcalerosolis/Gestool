// FiveWin Pocket PC, (c) FiveTech Software 2005-8

#ifndef _FWCE_CH
#define _FWCE_CH

#include "colors.ch"
#include "hbclass.ch"

#translate CurDir() => GetCurDir()

#define CRLF Chr(13)+Chr(10)

#define bSETGET(x) { | u | If( PCount()==0, x, x:= u ) }

#define CBS_SIMPLE               1  // 0x0001
#define CBS_DROPDOWN             2  // 0x0002
#define CBS_DROPDOWNLIST         3  // 0x0003

#xcommand DEFAULT <uVar1> := <uVal1> ;
               [, <uVarN> := <uValN> ] => ;
                  <uVar1> := If( <uVar1> == nil, <uVal1>, <uVar1> ) ;;
                [ <uVarN> := If( <uVarN> == nil, <uValN>, <uVarN> ); ]

#xcommand DATABASE <oDbf> => <oDbf> := TDataBase():New()

#xcommand DEFINE WINDOW <oWnd> ;
             [ TITLE <cTitle> ] ;
             [ MENU <oMenu> ] ;
             [ STYLE <nStyle> ] ;
       => ;
          <oWnd> := TWindow():New( [<cTitle>], [<oMenu>], [<nStyle>] )       
          
#xcommand ACTIVATE WINDOW <oWnd> ;
             [ ON [ LEFT ] CLICK <uLClick> ] ;
             [ ON PAINT <uPaint> ] ;
             [ ON INIT <uInit> ] ;
             [ ON RIGHT CLICK <uRClick> ] ;
             [ VALID <uValid> ] ;
             [ <modal: MODAL> ] ;
       => ;
          <oWnd>:Activate( ;
             <oWnd>:bLClicked [ := \{ | nRow, nCol, nKeyFlags | <uLClick> \} ],;
             <oWnd>:bPainted  [ := \{ | hDC, cPS | <uPaint> \} ],;
             <oWnd>:bInit     [ := \{ | Self | <uInit> \} ],;
             <oWnd>:bRClicked [ := \{ | nRow, nCol, nKeyFlags | <uRClick> \} ],;
             <oWnd>:bValid    [ := \{ | Self | <uValid> \} ], [<.modal.>] ) ; hb_gcAll()
             
#xcommand DEFINE MENU <oMenu> ;
             [ <res: RESOURCE, NAME, RESNAME> <cResName> ] ;
             [ BITMAPS <nBmpID> ] ;
             [ IMAGES <nBmpImages> ] ;
       => ;
          <oMenu> := TMenu():ReDefine( <cResName>, [<nBmpID>], [<nBmpImages>] )
          
#xcommand REDEFINE MENUITEM [<oMenuItem>] ;
             [ ID <nId> <of: OF, MENU> <oMenu> ] ;
             [ ACTION <uAction> ] ;
             [ WHEN <uWhen> ] ;
       => ;
          [ <oMenuItem> := ] TMenuItem():ReDefine( <nId>, <oMenu>, [<{uAction}>], [<{uWhen}>] )      

#xcommand DEFINE DIALOG <oDlg> ;
             [ <resource: NAME, RESNAME, RESOURCE> <cResName> ] ;
             [ TITLE <cTitle> ] ;
             [ FROM <nTop>, <nLeft> TO <nBottom>, <nRight> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ <lib: LIBRARY, DLL> <hResources> ] ;
             [ <vbx: VBX> ] ;
             [ STYLE <nStyle> ] ;
             [ <color: COLOR, COLORS> <nClrText> [,<nClrBack> ] ] ;
             [ BRUSH <oBrush> ] ;
             [ <of: WINDOW, DIALOG, OF> <oWnd> ] ;
             [ <pixel: PIXEL> ] ;
             [ ICON <oIco> ] ;
             [ FONT <oFont> ] ;
             [ <help: HELP, HELPID> <nHelpId> ] ;
             [ <transparent: TRANSPARENT> ] ;
       => ;
          <oDlg> = TDialog():New( <nTop>, <nLeft>, <nBottom>, <nRight>,;
                 <cTitle>, <cResName>, <hResources>, <.vbx.>, <nStyle>,;
                 <nClrText>, <nClrBack>, <oBrush>, <oWnd>, <.pixel.>,;
                 <oIco>, <oFont>, <nHelpId>, <nWidth>, <nHeight>, <.transparent.> )

#xcommand ACTIVATE DIALOG <oDlg> ;
             [ <center: CENTER, CENTERED> ] ;
             [ <NonModal: NOWAIT, NOMODAL> ] ;
             [ WHEN <uWhen> ] ;
             [ VALID <uValid> ] ;
             [ ON [ LEFT ] CLICK <uClick> ] ;
             [ ON INIT <uInit> ] ;
             [ ON MOVE <uMoved> ] ;
             [ ON PAINT <uPaint> ] ;
             [ ON RIGHT CLICK <uRClicked> ] ;
	     [ <Resize16: RESIZE16> ] ;
        => ;
          <oDlg>:Activate( <oDlg>:bLClicked [ := {|nRow,nCol,nFlags|<uClick>}], ;
                           <oDlg>:bMoved    [ := <{uMoved}> ], ;
                           <oDlg>:bPainted  [ := {|hDC,cPS|<uPaint>}],;
                           <.center.>, [{|Self|<uValid>}],;
                           [ ! <.NonModal.> ], [{|Self|<uInit>}],;
                           <oDlg>:bRClicked [ := {|nRow,nCol,nFlags|<uRClicked>}],;
                           [{|Self|<uWhen>}], [<.Resize16.>] )

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
      => ;
          [ <oSay> := ] TSay():New( <nRow>, <nCol>, <{cText}>,;
             [<oWnd>], [<cPict>], <oFont>, <.lCenter.>, <.lRight.>, <.lBorder.>,;
             <.lPixel.>, <nClrText>, <nClrBack>, <nWidth>, <nHeight>,;
             <.design.>, <.update.>, <.lShaded.>, <.lBox.>, <.lRaised.> )
             
#xcommand REDEFINE SAY [<oSay>] ;
             [ <label: PROMPT, VAR> <cText> ] ;
             [ <pict: PICT, PICTURE> <cPict> ] ;
             [ ID <nId> ] ;
             [ <dlg: OF,WINDOW,DIALOG > <oWnd> ] ;
             [ <color: COLOR,COLORS > <nClrText> [,<nClrBack> ] ] ;
             [ <update: UPDATE > ] ;
             [ FONT <oFont> ] ;
       => ;
          [ <oSay> := ] TSay():ReDefine( <nId>, <{cText}>, <oWnd>, ;
                        <cPict>, <nClrText>, <nClrBack>, <.update.>, <oFont> )

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
       => ;
          [ <oGet> := ] TGet():New( <nRow>, <nCol>, bSETGET(<uVar>),;
             [<oWnd>], <nWidth>, <nHeight>, <cPict>, <{ValidFunc}>,;
             <nClrFore>, <nClrBack>, <oFont>, <.design.>,;
             <oCursor>, <.pixel.>, <cMsg>, <.update.>, <{uWhen}>,;
             <.lCenter.>, <.lRight.>,;
             [\{|nKey, nFlags, Self| <uChange>\}], <.readonly.>,;
             <.pass.>, [<.lNoBorder.>], <nHelpId> )

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
       => ;
          [ <oGet> := ] TGet():ReDefine( <nId>, bSETGET(<uVar>), <oDlg>,;
             <nHelpId>, <cPict>, <{ValidFunc}>, <nClrFore>, <nClrBack>,;
             <oFont>, <oCursor>, <cMsg>, <.update.>, <{uWhen}>,;
             [ \{|nKey,nFlags,Self| <uChange> \}], <.readonly.>,;
             <.spin.>, <{SpnUp}>, <{SpnDn}>, <{Min}>, <{Max}>)

#xcommand REDEFINE CHECKBOX [ <oCbx> VAR ] <lVar> ;
             [ ID <nId> ] ;
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
             <nClrBack>, <cMsg>, <.update.>, <{uWhen}> )

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

#xcommand @ <nTop>, <nLeft> [ GROUP <oGroup> ] TO <nBottom>, <nRight> ;
             [ <label:LABEL,PROMPT> <cLabel> ] ;
             [ OF <oWnd> ] ;
             [ COLOR <nClrFore> [,<nClrBack>] ] ;
             [ <lPixel: PIXEL> ] ;
             [ <lDesign: DESIGN> ] ;
             [ FONT <oFont> ] ;
             [ <lTransparent: TRANSPARENT> ] ;
       => ;
          [ <oGroup> := ] TGroup():New( <nTop>, <nLeft>, <nBottom>, <nRight>,;
             <cLabel>, <oWnd>, <nClrFore>, <nClrBack>, <.lPixel.>,;
             [<.lDesign.>], [<oFont>], [<.lTransparent.>] )

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
             [ <trans: TRANSPARENT> ] ;
       => ;
          [ <oBmp> := ] TBitmap():ReDefine( <nId>, <cResName>, <cBmpFile>,;
             <oWnd>, [\{ |nRow,nCol,nKeyFlags| <uLClick> \}],;
                     [\{ |nRow,nCol,nKeyFlags| <uRClick> \}],;
             <.scroll.>, <.adjust.>, <oCursor>, <cMsg>, <.update.>,;
             <{uWhen}>, <{uValid}>, <.trans.> )

#xcommand DEFINE BITMAP [<oBmp>] ;
             [ <resource: RESOURCE, NAME, RESNAME> <cResName> ] ;
             [ <file: FILE, FILENAME, DISK> <cBmpFile> ] ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
       => ;
          [ <oBmp> := ] TBitmap():Define( <cResName>, <cBmpFile>, <oWnd> )

#xcommand DEFINE BUTTON [ <oBtn> ] ;
             [ <bar: OF, BUTTONBAR > <oBar> ] ;
             [ <resource: NAME, RESNAME, RESOURCE> <cResName1> ;
                [,<cResName2>[,<cResName3>] ] ] ;
             [ <file: FILE, FILENAME, DISK> <cBmpFile1> ;
                [,<cBmpFile2>[,<cBmpFile3>] ] ] ;
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
      => ;
         [ <oBtn> := ] TBtnBmp():NewBar( <cResName1>, <cResName2>,;
            <cBmpFile1>, <cBmpFile2>, <cMsg>, [{|This|<uAction>}],;
            <.group.>, <oBar>, <.adjust.>, <{WhenFunc}>,;
            <cToolTip>, <.lPressed.>, [\{||<bDrop>\}], [#<uAction>], <nPos>,;
            <cPrompt>, <oFont>, [<cResName3>], [<cBmpFile3>], [!<.lNoBorder.>],;
            [<oPopup>], [ Upper(<(layout)>) ] )

#xcommand REDEFINE BTNBMP [<oBtn>] ;
             [ ID <nId> ] ;
             [ <bar: OF, BUTTONBAR > <oBar> ] ;
             [ <resource: NAME, RESNAME, RESOURCE> <cResName1> ;
                [,<cResName2>[,<cResName3>] ] ] ;
             [ <file: FILE, FILENAME, DISK> <cBmpFile1> ;
                [,<cBmpFile2>[,<cBmpFile3>] ] ] ;
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
      => ;
         [ <oBtn> := ] TBtnBmp():ReDefine( <nId>, <cResName1>, <cResName2>,;
            <cBmpFile1>, <cBmpFile2>, <cMsg>, [{|Self|<uAction>}],;
            <oBar>, <.adjust.>, <{uWhen}>, <.lUpdate.>, <cToolTip>,;
            <cPrompt>, <oFont>, [<cResName3>], [<cBmpFile3>], [!<.lNoBorder.>],;
            [ Upper(<(layout)>) ] )

#xcommand @ <nRow>, <nCol> BTNBMP [<oBtn>] ;
             [ <resource: NAME, RESNAME, RESOURCE> <cResName1> ;
                [,<cResName2>[,<cResName3>] ] ] ;
             [ <file: FILE, FILENAME, DISK> <cBmpFile1> ;
                [,<cBmpFile2>[,<cBmpFile3>] ] ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ ACTION <uAction,...> ] ;
             [ <of:OF, WINDOW, DIALOG> <oWnd> ] ;
             [ MESSAGE <cMsg> ] ;
             [ WHEN <uWhen> ] ;
             [ <adjust: ADJUST> ] ;
             [ <lUpdate: UPDATE> ] ;
             [ PROMPT <cPrompt> ] ;
             [ FONT <oFont> ] ;
             [ <lNoBorder: NOBORDER> ] ;
             [ <layout: CENTER, TOP, LEFT, BOTTOM, RIGHT> ] ;
      => ;
         [ <oBtn> := ] TBtnBmp():New( <nRow>, <nCol>, <nWidth>, <nHeight>,;
            <cResName1>, <cResName2>, <cBmpFile1>, <cBmpFile2>,;
            [{|Self|<uAction>}], <oWnd>, <cMsg>, <{uWhen}>, <.adjust.>,;
            <.lUpdate.>, <cPrompt>, <oFont>, [<cResName3>], [<cBmpFile3>],;
            !<.lNoBorder.>, [ Upper(<(layout)>) ] )

#define LF_HEIGHT          1
#define LF_WIDTH           2
#define LF_ESCAPEMENT      3
#define LF_ORIENTATION     4
#define LF_WEIGHT          5
#define LF_ITALIC          6
#define LF_UNDERLINE       7
#define LF_STRIKEOUT       8
#define LF_CHARSET         9
#define LF_OUTPRECISION   10
#define LF_CLIPPRECISION  11
#define LF_QUALITY        12
#define LF_PITCHANDFAMILY 13
#define LF_FACENAME       14

#xcommand DEFINE FONT <oFont> ;
             [ NAME <cName> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ <from:FROM USER> ] ;
             [ <bold: BOLD> ] ;
             [ <italic: ITALIC> ] ;
             [ <underline: UNDERLINE> ] ;
             [ PITCHFAMILY <nPitchFamily> ] ;
             [ WEIGHT <nWeight> ] ;
             [ OF <oDevice> ] ;
             [ NESCAPEMENT <nEscapement> ] ;
       => ;
          <oFont> := TFont():New( <cName>, <nWidth>, <nHeight>, [<.from.>],;
                     [<.bold.>],[<nEscapement>],,[<nWeight>], [<.italic.>],;
                     [<.underline.>],,,,,, [<oDevice>], <nPitchFamily> )

#xcommand ACTIVATE   FONT <oFont> => <oFont>:Activate()

#xcommand DEACTIVATE FONT <oFont> => <oFont>:DeActivate()

#xcommand SET FONT ;
             [ OF <oWnd> ] ;
             [ TO <oFont> ] ;
       => ;
          <oWnd>:SetFont( <oFont> )
          
#xcommand DEFINE TIMER [ <oTimer> ] ;
             [ INTERVAL <nInterval> ] ;
             [ ACTION <uAction,...> ] ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
       => ;
          [ <oTimer> := ] TTimer():New( <nInterval>, [\{||<uAction>\}], <oWnd> )

#xcommand ACTIVATE TIMER <oTimer> => <oTimer>:Activate()

#xcommand @ <nRow>, <nCol> PROGRESS <oPrg> ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <pos: POS, POSITION> <nPos> ] ;
             [ COLOR <nClrFore> [,<nClrBack>] ] ;
             [ <pixel: PIXEL> ] ;
             [ <design: DESIGN> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ MESSAGE <cMsg> ] ;
       => ;
          <oPrg> := TProgress():New( <nRow>, <nCol>, <oWnd>, [<nPos>],;
                                     <nClrFore>, <nClrBack>, <.pixel.>, <.design.>,;
                                     <nWidth>, <nHeight>, <cMsg> )                

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
                                        
#xcommand @ <nRow>, <nCol> FOLDER [<oFolder>] ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <prm: PROMPT, PROMPTS, ITEMS> <cPrompt,...> ] ;
             [ <dlg: DIALOG, DIALOGS, PAGE, PAGES> <cDlgName1> [,<cDlgNameN>] ] ;
             [ <lPixel: PIXEL> ] ;
             [ <lDesign: DESIGN> ] ;
             [ <color: COLOR, COLORS> <nClrFore> [,<nClrBack>] ] ;
             [ OPTION <nOption> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ MESSAGE <cMsg> ] ;
             [ <lAdjust: ADJUST> ] ;
             [ FONT <oFont> ];
             [ <bottom: BOTTOM> ] ;
       => ;
          [<oFolder> := ] TFolder():New( <nRow>, <nCol>,;
             [\{<cPrompt>\}], \{<cDlgName1> [,<cDlgNameN>]\},;
             <oWnd>, <nOption>, <nClrFore>, <nClrBack>, <.lPixel.>,;
             <.lDesign.>, <nWidth>, <nHeight>, <cMsg>, <.lAdjust.>,;
             <oFont>, <.bottom.> )

#xcommand REDEFINE FOLDER [<oFolder>] ;
             [ ID <nId> ] ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <prm: PROMPT, PROMPTS, ITEMS> <cPrompt,...> ] ;
             [ <dlg: DIALOG, DIALOGS, PAGE, PAGES> <cDlgName1> [,<cDlgNameN>] ] ;
             [ <color: COLOR, COLORS> <nClrFore> [,<nClrBack>] ] ;
             [ OPTION <nOption> ] ;
             [ ON CHANGE <uChange> ] ;
             [ <lAdjust: ADJUST> ] ;
       => ;
          [<oFolder> := ] TFolder():ReDefine( <nId>, [\{<cPrompt>\}],;
             \{ <cDlgName1> [,<cDlgNameN>] \}, <oWnd>,;
             <nOption>, <nClrFore>, <nClrBack>,;
             [{|nOption,nOldOption| <uChange>}], <.lAdjust.> )
             
#command @ <nRow>, <nCol> DTPICKER [ <oDTPicker> VAR ] <uVar> ;
            [ <dlg: OF, WINDOW, DIALOG> <oWnd> ] ;
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
            [ ON CHANGE <uChange> ] ;
            [ <help:HELPID, HELP ID> <nHelpId> ] ;
       => ;
          [ <oDTPicker> := ] TDatePick():New( <nRow>, <nCol>, bSETGET(<uVar>),;
                                        [<oWnd>], <nWidth>, <nHeight>, <{ValidFunc}>,;
                                        <nClrFore>, <nClrBack>, <oFont>, <.design.>,;
                                        <oCursor>, <.pixel.>, <cMsg>, <.update.>, <{uWhen}>,;
                                        [\{|nKey, nFlags, Self| <uChange>\}], <nHelpId> )


#xcommand REDEFINE DTPICKER [ <oDTPicker> VAR ] <uVar> ;
             [ ID <nId> ] ;
             [ <dlg: OF, WINDOW, DIALOG> <oDlg> ] ;
             [ <help:HELPID, HELP ID> <nHelpId> ] ;
             [ <color: COLOR,COLORS> <nClrFore> [,<nClrBack>] ] ;
             [ FONT <oFont> ] ;
             [ CURSOR <oCursor> ] ;
             [ MESSAGE <cMsg> ] ;
             [ <update: UPDATE> ] ;
             [ WHEN <uWhen> ] ;
             [ VALID <uValid> ] ;
             [ ON CHANGE <uChange> ] ;
       => ;
          [ <oDTPicker> := ] TDatePick():ReDefine( <nId>, bSETGET(<uVar>),;
             <oDlg>, <nHelpId>, <nClrFore>, <nClrBack>, <oFont>, <oCursor>,;
             <cMsg>, <.update.>, <{uWhen}>, <{uValid}>,;
             [\{|nKey, nFlags, Self| <uChange>\}] )
             
#xcommand @ <nRow>, <nCol> PANEL <oPanel> ;
             [ <dlg: OF,WINDOW,DIALOG > <oWnd> ] ;
             [ <lPixel: PIXEL, PIXELS > ] ;
             [ <color: COLOR,COLORS > <nClrText> [,<nClrBack> ] ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
      => ;
          [ <oPanel> := ] TPanel():New( <nRow>, <nCol>, <nRow> [+ <nHeight>],;
             <nCol> [+ <nWidth>], [<oWnd>], <.lPixel.>, <nClrText>, <nClrBack> )
             
#xcommand REDEFINE PAGES <oPag> ;
             [ ID <nId> ] ;
             [ OF <oWnd> ] ;
             [ DIALOGS <DlgName,...> ] ;
             [ OPTION <nOption> ] ;
             [ ON CHANGE <uChange> ] ;
             [ FONT <oFont> ] ;
       => ;
          <oPag> := TPages():Redefine( <nId>, <oWnd>, [{<DlgName>}], <nOption>,;
             [{|nOption, nOldOption|<uChange>}], <oFont> )
             
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

#xcommand DEFINE BRUSH [ <oBrush> ] ;
             [ STYLE <cStyle> ] ;
             [ COLOR <nRGBColor> ] ;
             [ <file:FILE,FILENAME,DISK> <cBmpFile> ] ;
             [ <resource:RESOURCE,NAME,RESNAME> <cBmpRes> ] ;
       => ;
          [ <oBrush> := ] TBrush():New( [ Upper(<(cStyle)>) ], <nRGBColor>,;
             <cBmpFile>, <cBmpRes> )

#xcommand SET BRUSH ;
             [ OF <oWnd> ] ;
             [ TO <oBrush> ] ;
       => ;
          <oWnd>:SetBrush( <oBrush> )

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

#endif                      