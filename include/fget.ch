#ifndef _FGET_CH
#define _FGET_CH

#define ES_CENTER               1


#command STORE GTF <value> TO <var1> [, <varN> ] ;
        => <var1> := [ <varN> := ] TxtToGTF( <value> ) 


/*----------------------------------------------------------------------------//
!short: FORMAT GET  */

#xcommand REDEFINE FORMAT GET [ <oFGet> VAR ] <uVar> ;
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
          [ <oFGet> := ] TFGet():ReDefine( <nId>, bSETGET(<uVar>),;
             <oDlg>, <nHelpId>, <nClrFore>, <nClrBack>, <oFont>, <oCursor>,;
             <cMsg>, <.update.>, <{uWhen}>, <.readonly.>, <{uValid}>,;
             [\{|nKey, nFlags, Self| <uChange>\}] )

#command @ <nRow>, <nCol> FORMAT GET [ <oFGet> VAR ] <uVar> ;
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
          [ <oFGet> := ] TFGet():New( <nRow>, <nCol>, bSETGET(<uVar>),;
             [<oWnd>], <nWidth>, <nHeight>, <oFont>, <.hscroll.>,;
             <nClrFore>, <nClrBack>, <oCursor>, <.pixel.>,;
             <cMsg>, <.update.>, <{uWhen}>, <.lCenter.>,;
             <.lRight.>, <.readonly.>, <{uValid}>,;
             [\{|nKey, nFlags, Self| <uChange>\}], <.lDesign.>,;
             [<.lNoBorder.>], [<.lNoVScroll.>] )

#endif


