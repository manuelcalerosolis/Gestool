#ifndef _AUTOGET_CH
#define _AUTOGET_CH

#xcommand REDEFINE AUTOGET [ <oGet> VAR ] <uVar> ;
             [ ID <nId> ] ;
             [ <dsrc: ARRAY, HASH, DATASOURCE> <uDataSrc> ];
             [ <fil: FILTERLIST, FILTER, LIST> <uFilter> ];             
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
             [ HEIGHTLIST <nLHeight> ] ;               
             [ CUEBANNER <cCueText> ] ;
             [ [ <fld: FIELD, COLUMN> ] <Flds>] ;
             [ GRADLIST <aGradList> ] ;
             [ GRADITEM <aGrad> ] ;
             [ LINECOLOR <nColor> ];
             [ ITEMCOLOR <nColorTxt>[,<nColorSel>] ];              
       => ;
          [ <oGet> := ] TAutoGet():ReDefine( <nId>, bSETGET(<uVar>), <oDlg>,;
             <nHelpId>, <cPict>, <{ValidFunc}>, <nClrFore>, <nClrBack>,;
             <oFont>, <oCursor>, <cMsg>, <.update.>, <{uWhen}>,;
             [ \{|nKey,nFlags,Self| <uChange> \}], <.readonly.>,;
             <.spin.>, <{SpnUp}>, <{SpnDn}>, <{Min}>, <{Max}>, [\{|self| <uAction> \}], <cBmpName>, <"uVar">,;
             [<cCueText>], <uDataSrc>, ;
             <Flds>, <nLHeight>, [\{|uDataSource, cData, Self| <uFilter>\}],;
             <aGradList>, <aGrad>, <nColor>, <nColorTxt>[,<nColorSel>] )
					
#command @ <nRow>, <nCol> AUTOGET [ <oGet> VAR ] <uVar> ;
            [ <dsrc: ARRAY, HASH, DATASOURCE> <uDataSrc> ];
            [ <fil: FILTERLIST, FILTER, LIST> <uFilter> ];
            [ <dlg: OF, WINDOW, DIALOG> <oWnd> ] ;
            [ <pict: PICT, PICTURE> <cPict> ] ;
            [ VALID <ValidFunc> ] ;
            [ <color:COLOR,COLORS> <nClrFore> [,<nClrBack>] ] ;
            [ SIZE <nWidth>, <nHeight> ]  ;
            [ HEIGHTLIST <nLHeight> ]  ;
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
            [ CUEBANNER <cCueText> ] ;            
            [ [ <fld: FIELD, COLUMN> ] <Flds>] ;
            [ GRADLIST <aGradList> ] ;
            [ GRADITEM <aGrad> ] ;
            [ LINECOLOR <nColor> ];   
            [ ITEMCOLOR <nColorTxt>[,<nColorSel>] ];         
       => ;
          [ <oGet> := ] TAutoGet():New( <nRow>, <nCol>, bSETGET(<uVar>),;
             [<oWnd>], <nWidth>, <nHeight>, <cPict>, <{ValidFunc}>,;
             <nClrFore>, <nClrBack>, <oFont>, <.design.>,;
             <oCursor>, <.pixel.>, <cMsg>, <.update.>, <{uWhen}>,;
             <.lCenter.>, <.lRight.>,;
             [\{|nKey, nFlags, Self| <uChange>\}], <.readonly.>,;
             .f., .f., <nHelpId>,;
             .f., , , , ,,, <"uVar">, [<cCueText>], <uDataSrc>, ;
             <Flds>, <nLHeight>, [\{|uDataSource, cData, Self| <uFilter>\}],;
             <aGradList>, <aGrad>, <nColor>, <nColorTxt>[,<nColorSel>] )
             
#endif             