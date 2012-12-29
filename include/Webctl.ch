#xcommand @ <nRow>, <nCol> WEBBTN [<oBtn>] ;
                                [ SIZE <nWidth>, <nHeight> ] ;
                                [ <resource: NAME, RESNAME, RESOURCE> <cResName1> [, <cResName2> [, <cResName3> ] ] ] ;
                                [ <file: FILE, FILENAME, DISK> <cBmpFile1> [, <cBmpFile2> [, <cBmpFile3> ] ] ] ;
                                [ <action:ACTION,EXEC> <bAction,...> ] ;
                                [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
                                [ MESSAGE <cMsg> ] ;
                                [ WHEN <WhenFunc> ] ;
                                [ <update: UPDATE > ] ;
                                [ PROMPT <cPrompt> ] ;
                                [ ALIGN <cAlign: LEFT, CENTER, RIGHT> ] ;
                                [ FONT <oFont> [, <oFontOver> ] ] ;
                                [ COLORTEXT <nClrText> [, <nClrTextOver>] ];
                                [ COLORPANE <nClrPane> [, <nClrPaneOver>] ];
                                [ <lBorder: BORDER > ] ;
                                [ MENU <bMenu,...> ] ;
=> ;
[<oBtn> := ] TWebBtn():New(     <nRow>,;
                                <nCol>,;
                                <nWidth>,;
                                <nHeight>,;
                                [ <cResName1> ],;
                                [ <cResName2> ],;
                                [ <cBmpFile1> ],;
                                [ <cBmpFile2> ],;
                                [ {|This| <bAction> } ],;
                                <oWnd>,;
                                [ <cMsg> ],;
                                [ <WhenFunc> ],;
                                [ <.update.> ],;
                                [ <cPrompt> ],;
                                [ <"cAlign"> ],;
                                [ <oFont> ],;
                                [ <oFontOver> ],;
                                [ <cResName3> ],;
                                [ <cBmpFile3> ],;
                                [ <nClrText> ],;
                                [ <nClrTextOver> ],;
                                [ <nClrPane> ],;
                                [ <nClrPaneOver> ],;
                                [ <.lBorder.> ],;
                                [ {|This| <bMenu> } ] )

#xcommand REDEFINE WEBBTN       [<oBtn>] ;
                                ID <nId> ;
                                [ <resource: NAME, RESNAME, RESOURCE> <cResName1> [, <cResName2> [, <cResName3> ] ] ] ;
                                [ <file: FILE, FILENAME, DISK> <cBmpFile1> [, <cBmpFile2> [, <cBmpFile3> ] ] ] ;
                                [ <action:ACTION,EXEC> <bAction,...> ] ;
                                [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
                                [ MESSAGE <cMsg> ] ;
                                [ WHEN <WhenFunc> ] ;
                                [ <update: UPDATE > ] ;
                                [ PROMPT <cPrompt> ] ;
                                [ ALIGN <cAlign: LEFT, CENTER, RIGHT> ] ;
                                [ FONT <oFont> [, <oFontOver> ] ] ;
                                [ COLORTEXT <nClrText> [, <nClrTextOver>] ];
                                [ COLORPANE <nClrPane> [, <nClrPaneOver>] ];
                                [ <lBorder: BORDER > ] ;
                                [ TOOLTIP <cToolTip> ] ;
                                [ ON DROP <bDrop,...> ] ;
                                [ MENU <bMenu,...> ] ;
                                [ <lGroup: GRUOP > ] ;
                                [ BRUSH <oBrush> ] ;
=> ;
[<oBtn> := ] TWebBtn():Redefine(<nId>,;
                                [ <cResName1> ],;
                                [ <cResName2> ],;
                                [ <cBmpFile1> ],;
                                [ <cBmpFile2> ],;
                                [ {|This| <bAction> } ],;
                                <oWnd>,;
                                [ <cMsg> ],;
                                [ <WhenFunc> ],;
                                [ <.update.> ],;
                                [ bSETGET(<cPrompt>) ],;
                                [ <"cAlign"> ],;
                                [ <oFont> ],;
                                [ <oFontOver> ],;
                                [ <cResName3> ],;
                                [ <cBmpFile3> ],;
                                [ <nClrText> ],;
                                [ <nClrTextOver> ],;
                                [ <nClrPane> ],;
                                [ <nClrPaneOver> ],;
                                [ <.lBorder.> ],;
                                [ <cToolTip> ],;
                                [ {|This| <bDrop> } ],;
                                [ {|This| <bMenu> } ],;
                                [ <.lGroup.> ],;
                                [ <oBrush> ] )

#xcommand DEFINE WEBBTN         [<oBtn>] ;
                                [<wnd: OF, WINDOW, DIALOG> <oWnd>] ;
                                [ <resource: NAME, RESNAME, RESOURCE> <cResName1> [, <cResName2> [, <cResName3> ] ] ] ;
                                [ <file: FILE, FILENAME, DISK> <cBmpFile1> [, <cBmpFile2> [, <cBmpFile3> ] ] ] ;
                                [ <action:ACTION,EXEC> <bAction,...> ] ;
                                [ MESSAGE <cMsg> ] ;
                                [ WHEN <WhenFunc> ] ;
                                [ <update: UPDATE > ] ;
                                [ PROMPT <cPrompt> ] ;
                                [ ALIGN <cAlign: LEFT, CENTER, RIGHT> ] ;
                                [ FONT <oFont> [, <oFontOver> ] ] ;
                                [ COLORTEXT <nClrText> [, <nClrTextOver>] ];
                                [ COLORPANE <nClrPane> [, <nClrPaneOver>] ];
                                [ <lBorder: BORDER > ] ;
                                [ TOOLTIP <cToolTip> ] ;
                                [ ON DROP <bDrop,...> ] ;
                                [ MENU <bMenu,...> ] ;
                                [ <lGroup: GRUOP > ] ;
                                [ BRUSH <oBrush> ] ;
=> ;
[<oBtn> := ] TWebBtn():NewBar(  [ <cResName1> ],;
                                [ <cResName2> ],;
                                [ <cBmpFile1> ],;
                                [ <cBmpFile2> ],;
                                [ {|This| <bAction> } ],;
                                <oWnd>,;
                                [ <cMsg> ],;
                                [ <WhenFunc> ],;
                                [ <.update.> ],;
                                [ {|This| <cPrompt> } ],;
                                [ <"cAlign"> ],;
                                [ <oFont> ],;
                                [ <oFontOver> ],;
                                [ <cResName3> ],;
                                [ <cBmpFile3> ],;
                                [ <nClrText> ],;
                                [ <nClrTextOver> ],;
                                [ <nClrPane> ],;
                                [ <nClrPaneOver> ],;
                                [ <.lBorder.> ],;
                                [ <cToolTip> ],;
                                [ {|This| <bDrop> } ],;
                                [ {|This| <bMenu> } ],;
                                [ <.lGroup.> ],;
                                [ <oBrush> ] )

#xcommand @ <nRow>, <nCol> WEBBAR [<oBar>] ;
                                [ SIZE <nWidth>, <nHeight> ] ;
                                [ CTLHEIGHT <nCtlHeight> ] ;
                                [ BITMAP <cBitmap> ] ;
                                [ RESOURCE <cResBmp>] ;
                                [ COLOR <nClrFore> [,<nClrBack>] ] ;
                                [ STYLE <cStyle> ] ;
                                [ BRUSH <oBrush> ] ;
                                [ FONT <oFont> ] ;
                                [ <pixel: PIXEL> ] ;
                                [ MESSAGE <cMsg> ] ;
                                [ <of:OF, WINDOW, DIALOG> <oWnd> ] ;
                                [ <help:HELP, HELPID, HELP ID> <nHelpId> ] ;
                                [ ON RIGHT CLICK <uRClick> ] ;
=> ;
[ <oBar> := ] TWebBar():New( <nRow>, <nCol>, ;
                                <nWidth>,;
                                <nHeight>,;
                                <nCtlHeight>,;
                                [<cBitmap>],;
                                [<cResBmp>],;
                                [<nClrFore>],;
                                [<nClrBack>],;
                                [<cStyle>],;
                                [<oBrush>],;
                                [<oFont>],;
                                [<.pixel.>],;
                                [<cMsg>],;
                                [<oWnd>],;
                                [<nHelpId>],;
                                [\{|nRow,nCol,nFlags|<uRClick>\}] )

#xcommand REDEFINE WEBBAR       [<oBar>] ;
                                ID <nId> ;
                                [ CTLHEIGHT <nCtlHeight> ] ;
                                [ BITMAP <cBitmap> ] ;
                                [ RESOURCE <cResBmp>] ;
                                [ COLOR <nClrFore> [,<nClrBack>] ] ;
                                [ STYLE <cStyle> ] ;
                                [ BRUSH <oBrush> ] ;
                                [ FONT <oFont> ] ;
                                [ <pixel: PIXEL> ] ;
                                [ MESSAGE <cMsg> ] ;
                                [ <of:OF, WINDOW, DIALOG> <oWnd> ] ;
                                [ <help:HELP, HELPID, HELP ID> <nHelpId> ] ;
                                [ ON RIGHT CLICK <uRClick> ] ;
=> ;
[ <oBar> := ] TWebBar():Redefine( <nId>,;
                                [<nCtlHeight>],;
                                [<cBitmap>],;
                                [<cResBmp>],;
                                [<nClrFore>],;
                                [<nClrBack>],;
                                [<cStyle>],;
                                [<oBrush>],;
                                [<oFont>],;
                                [<.pixel.>],;
                                [<cMsg>],;
                                [<oWnd>],;
                                [<nHelpId>],;
                                [\{|nRow,nCol,nFlags|<uRClick>\}] )




































































































































































































