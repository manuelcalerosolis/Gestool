//calendar.ch

#command @ <nRow>, <nCol> CALENDAR [ <oCalendar> VAR ] <uVar> ;
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
            [ <lWeekNumber: WEEKNUMBER> ];
            [ <lNoTodayC: NOTODAYCIRCLE> ];
            [ <lNoToday: NOTADAY> ];
            [ <lDayState: DAYSTATE> ];
            [ <help:HELPID, HELP ID> <nHelpId> ] ;
            [ ACTION <bAction> ];
            [ DBLCLICK <bLDblClick> ];
       => ;
          [ <oCalendar> := ] TCalendar():New( <nRow>, <nCol>, bSETGET(<uVar>), nil,;
                                        [<oWnd>], <nWidth>, <nHeight>, <{ValidFunc}>,;
                                        <nClrFore>, <nClrBack>, <oFont>, <.design.>,;
                                        <oCursor>, <.pixel.>, <cMsg>, <.update.>, .f., <{uWhen}>,;
                                        [\{|nKey, nFlags, Self| <uChange>\}], <nHelpId>,;
                                        [\{|Self| <bAction>\}], [\{|Self| <bLDblClick>\}], <.lWeekNumber.>,;
                                        <.lNoTodayC.>, <.lNoToday.>, <.lDayState.>  )

#command @ <nRow>, <nCol> CALENDAR [ <oCalendar> VAR ] <uVar>,<uVar2> ;
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
	          [ <multiselect: MULTISELECT> ] ;
            [ WHEN <uWhen> ] ;
            [ ON CHANGE <uChange> ] ;
            [ <help:HELPID, HELP ID> <nHelpId> ] ;
            [ <lWeekNumber: WEEKNUMBER> ];
            [ <lNoTodayC: NOTODAYCIRCLE> ];
            [ <lNoToday: NOTADAY> ];
            [ <lDayState: DAYSTATE> ];            
            [ ACTION <bAction> ];
            [ DBLCLICK <bLDblClick> ];
       => ;
          [ <oCalendar> := ] TCalendar():New( <nRow>, <nCol>, bSETGET(<uVar>), bSETGET(<uVar2>),;
                                        [<oWnd>], <nWidth>, <nHeight>, <{ValidFunc}>,;
                                        <nClrFore>, <nClrBack>, <oFont>, <.design.>,;
                                        <oCursor>, <.pixel.>, <cMsg>, <.update.>, <.multiselect.>, <{uWhen}>,;
                                        [\{|nKey, nFlags, Self| <uChange>\}], <nHelpId>,;
                                        [\{|Self| <bAction>\}], [\{|Self| <bLDblClick>\}], <.lWeekNumber.>,;
                                        <.lNoTodayC.>, <.lNoToday.>, <.lDayState.>  )

#xcommand REDEFINE CALENDAR [ <oCalendar> VAR ] <uVar>, <uVar2> ;
             [ <multiselect: MULTISELECT> ] ;
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
             [ ACTION <bAction> ];
             [ DBLCLICK <bLDblClick> ];
       => ;
          [ <oCalendar> := ] TCalendar():ReDefine( <nId>, bSETGET(<uVar>), bSETGET(<uVar2>),;
             <oDlg>, <nHelpId>, <nClrFore>, <nClrBack>, <oFont>, <oCursor>,;
             <cMsg>, <.update.>, <.multiselect.>, <{uWhen}>, <{uValid}>,;
             [\{|nKey, nFlags, Self| <uChange>\}], [\{|Self| <bAction>\}], [\{|Self| <bLDblClick>\}] )

#xcommand REDEFINE CALENDAR [ <oCalendar> VAR ] <uVar> ;
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
             [ ACTION <bAction> ];
             [ DBLCLICK <bLDblClick> ];
       => ;
          [ <oCalendar> := ] TCalendar():ReDefine( <nId>, bSETGET(<uVar>), nil,;
             <oDlg>, <nHelpId>, <nClrFore>, <nClrBack>, <oFont>, <oCursor>,;
             <cMsg>, <.update.>, .f., <{uWhen}>, <{uValid}>,;
             [\{|nKey, nFlags, Self| <uChange>\}], [\{|Self| <bAction>\}], [\{|Self| <bLDblClick>\}] )

