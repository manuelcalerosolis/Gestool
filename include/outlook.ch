#ifndef _OUTLOOK_CH
#define _OUTLOOK_CH

/*----------------------------------------------------------------------------//
!short: OUTLOOK  */

#xcommand @ <nRow>, <nCol> OUTLOOK [<oOut>] ;
            [ SIZE <nWidth>, <nHeight> ] ;
            [ <color: COLOR, COLORS> <nClrFore> [,<nClrBack>] ] ;
            [ STYLE <nStyle> ] ;
            [ FONT <oFont> ] ;
            [ <lPixel: PIXEL> ] ;
            [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
            [ <help: HELP, HELPID> <nHelpId> ] ;
            [ ON RIGHT CLICK <uRClicked> ] ;
         => ;
            [<oOut> := ] TOutLook():New( <nRow>, <nCol>, ;
               <nWidth>, <nHeight>, ;
               <nClrFore>, <nClrBack>, <nStyle>, <oFont>, ;
               <.lPixel.>, <oWnd>, <nHelpId>, ;
               [{|nRow,nCol,nFlags|<uRClicked>}] )

#xcommand DEFINE GROUP OF OUTLOOK <oOut> ;
            [ PROMPT <cPrompt> ] ;
            [ WHEN <bWhen> ] ;
            [ MESSAGE <cMsg> ] ;
            [ FONT <oFont> ] ;
         => ;
            <oOut>:AddGroup( <cPrompt>, ;
               [{|Self|<bWhen>}], <cMsg>, <oFont> )

#xcommand DEFINE BITMAP OF OUTLOOK <oOut> ;
            [ GROUP <nGroup> ] ;
            [ PROMPT <cPrompt> ] ;
            [ <action: ACTION, ON CLICK> <uAction> ] ;
            [ ON RIGHT CLICK <uRClicked> ] ;
            [ BITMAP <cBmp> ] ;
            [ RESOURCE <cResBmp> ] ;
            [ WHEN <bWhen> ] ;
            [ MESSAGE <cMsg> ] ;
            [ FONT <oFont> ] ;
            [ <lAdjust: ADJUST> ] ;
            [ <lBorder: BORDER> ] ;
            [ TOOLTIP <cToolTip> ] ;
         => ;
            <oOut>:AddItem( <cPrompt>, <cBmp>, <cResBmp>, ;
               [{|Self, oBmp, oSay|<uAction>}], <nGroup>, ;
               [{|Self|<bWhen>}], <cMsg>, ;
               [{|nRow,nCol,nFlags|<uRClicked>}], <oFont>, ;
               <.lAdjust.>, <.lBorder.>, <cToolTip>, .f. )

// OutLook 2003
               
#xcommand DEFINE OUTLOOK2003 <oOut> ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <prm: PROMPT, PROMPTS, ITEMS> <cPrompt,...> ] ;
             [ <bmp: BITMAPS, IMAGES> <cBmpName,...> ] ;
             [ ON CHANGE <uChange> ] ;
          => ;
          [ <oOut> := ] TOutLook2003():New( [<oWnd>], [\{<cPrompt>\}],;
             [\{<cBmpName>\}], [{|nOption,nOldOption| <uChange>}] )

#xcommand REDEFINE OUTLOOK2003 <oOut> ;
             [ ID <nId> ] ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <prm: PROMPT, PROMPTS, ITEMS> <cPrompt,...> ] ;
             [ <bmp: BITMAPS, IMAGES> <cBmpName,...> ] ;
             [ <dlg: DIALOG, DIALOGS, PAGE, PAGES> <cDlgName,...> ] ;
             [ ON CHANGE <uChange> ] ;
          => ;
          [ <oOut> := ] TOutLook2003():Redefine( [<nId>], [<oWnd>], [\{<cPrompt>\}],;
             [\{<cBmpName>\}], [{|nOption,nOldOption| <uChange>}], [\{<cDlgName>\}], )

// OutLook 2010
               
#xcommand DEFINE OUTLOOK2010 <oOut> ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <prm: PROMPT, PROMPTS, ITEMS> <cPrompt,...> ] ;
             [ <bmp: BITMAPS, IMAGES> <cBmpName,...> ] ;
             [ ON CHANGE <uChange> ] ;
          => ;
          [ <oOut> := ] TOutLook2010():New( [<oWnd>], [\{<cPrompt>\}],;
             [\{<cBmpName>\}], [{|nOption,nOldOption| <uChange>}] )

#xcommand REDEFINE OUTLOOK2010 <oOut> ;
             [ ID <nId> ] ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <prm: PROMPT, PROMPTS, ITEMS> <cPrompt,...> ] ;
             [ <bmp: BITMAPS, IMAGES> <cBmpName,...> ] ;
             [ <dlg: DIALOG, DIALOGS, PAGE, PAGES> <cDlgName,...> ] ;
             [ ON CHANGE <uChange> ] ;
          => ;
          [ <oOut> := ] TOutLook2010():Redefine( [<nId>], [<oWnd>], [\{<cPrompt>\}],;
             [\{<cBmpName>\}], [{|nOption,nOldOption| <uChange>}], [\{<cDlgName>\}], )

#endif   // _OUTLOOK_CH
//--------------------------------------------------------------------------//