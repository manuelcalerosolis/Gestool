#ifndef _REPORT_CH

#define _REPORT_CH

#define CHAR_PATTERN   "B"

#define RPT_LEFT        1
#define RPT_RIGHT       2
#define RPT_CENTER      3
#define RPT_TOP         4
#define RPT_BOTTOM      5

#define RPT_INCHES      1
#define RPT_CMETERS     2

#define RPT_NOLINE      0
#define RPT_SINGLELINE  1
#define RPT_DOUBLELINE  2


#xcommand REPORT [ <oReport> ] ;
                 [ TITLE <bTitle, ...> [<TFmt:LEFT,CENTER,CENTERED,RIGHT>] ];
                 [ HEADER <bHead, ...> [<HFmt:LEFT,CENTER,CENTERED,RIGHT>] ];
                 [ FOOTER <bFoot, ...> [<FFmt:LEFT,CENTER,CENTERED,RIGHT>] ];
                 [ FONT <oFont, ...> ]  ;
                 [ PEN <oPen, ...> ]  ;
                 [ <lSum:SUMMARY> ] ;
                 [ <file: FILE, FILENAME, DISK> <cRptFile> ] ;
                 [ <resource: NAME, RESNAME, RESOURCE> <cResName> ] ;
                 [ <toPrint: TO PRINTER> ] ;
                 [ <toScreen: PREVIEW> ] ;
                 [ TO FILE <(toFile)> ] ;
                 [ TO DEVICE <oDevice> ] ;
                 [ CAPTION <cName> ] ;
        => ;
        [ <oReport> := ] RptBegin({<{bTitle}>}, {<{bHead}>}, {<{bFoot}>},;
                {<oFont>}, {<oPen>}, <.lSum.>, <cRptFile>, <cResName>,;
                [<.toPrint.>], <.toScreen.>, <(toFile)>, <oDevice>, <cName>,;
                [UPPER(<(TFmt)>)], [UPPER(<(HFmt)>)], [UPPER(<(FFmt)>)] )

#xcommand GROUP [ <oRptGrp> ] ;
                [ ON <bGroup> ] ;
                [ HEADER <bHead> ] ;
                [ FOOTER <bFoot> ] ;
                [ FONT <uFont> ] ;
                [ <lEject:EJECT> ] ;
        => ;
        [ <oRptGrp> := ] RptAddGroup( <{bGroup}>, <{bHead}>, ;
                <{bFoot}>, <{uFont}>, <.lEject.> )

#xcommand COLUMN [ <oRptCol> ] ;
                [ TITLE <bTitle, ...> ] ;
                [ AT <nCol> ] ;
                [ DATA <bData, ...> ] ;
                [ SIZE <nSize> ] ;
                [ <pict: PICT, PICTURE> <cPicture, ...> ] ;
                [ FONT <uFont> ] ;
                [ [ <lCum: CUMULATIVE> ] <total: TOTAL> [ FOR <bTotalExpr> ]  ] ;
                [ <ColFmt:LEFT,CENTER,CENTERED,RIGHT> ] ;
                [ <lShadow:SHADOW> ] ;
                [ <lGrid:GRID> [ <nPen> ] ] ;
                [ <memo: MEMO, MULTILINE> ] ;
                [<img:IMAGE> [ IMGDATA <bimg> ] [HEIGHT <h> [<imgpix:PIXEL>] ] [ ALPHALEVEL <nAlpha>] ] ;
        => ;
         [ <oRptCol> := ] RptAddColumn( {<{bTitle}>}, <nCol> ,;
                {<{bData}>}, <nSize>, {<cPicture>} ,;
                <{uFont}>, <.total.>, <{bTotalExpr}> ,;
                [UPPER(<(ColFmt)>)], <.lShadow.>, <.lGrid.>, <nPen>, <.memo.>, ;
                <.img.>, [<{bimg}>], [<h>], <.imgpix.>, [<nAlpha>], <.lCum.> )

#xcommand END REPORT ;
       => ;
         RptEnd()

#xcommand ENDREPORT ;
       => ;
          END REPORT

#xcommand ACTIVATE REPORT <oReport> ;
                [ FOR <for> ] ;
                [ WHILE <while> ] ;
                [ ON INIT <uInit> ] ;
                [ ON END <uEnd> ] ;
                [ ON POSTEND <uPostEnd> ] ;
                [ ON STARTPAGE <uStartPage> ] ;
                [ ON ENDPAGE <uEndPage> ] ;
                [ ON POSTPAGE <uPostPage> ] ;
                [ ON STARTGROUP <uStartGroup> ] ;
                [ ON ENDGROUP <uEndGroup> ] ;
                [ ON POSTGROUP <uPostGroup> ] ;
                [ ON STARTLINE <uStartLine> ] ;
                [ ON ENDLINE <uEndLine> ] ;
                [ ON CHANGE <bChange> ] ;
        => ;
         <oReport>:Activate(<{for}>, <{while}>, <{uInit}>, <{uEnd}>, ;
                <{uStartPage}>, <{uEndPage}>, [{|oGrp|<uStartGroup>}], [{|oGrp|<uEndGroup>}],;
                <{uStartLine}>, <{uEndLine}>, <{bChange}>,;
                <{uPostEnd}>, <{uPostPage}>, [{|oGrp|<uPostGroup>}] )

#endif
