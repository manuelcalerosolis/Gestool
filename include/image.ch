/*----------------------------------------------------------------------------//
!short: Image */

#xcommand @ <nRow>, <nCol> Image [ <oBmp> ] ;
             [ <resource: NAME, RESNAME, RESOURCE> <cResName> ] ;
             [ <file: FILE, FILENAME, DISK> <cBmpFile> ] ;
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

#xcommand REDEFINE Image [ <oBmp> ] ;
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
       => ;
          [ <oBmp> := ] TImage():ReDefine( <nId>, <cResName>, <cBmpFile>,;
             <oWnd>, [\{ |nRow,nCol,nKeyFlags| <uLClick> \}],;
                     [\{ |nRow,nCol,nKeyFlags| <uRClick> \}],;
             <.scroll.>, <.adjust.>, <oCursor>, <cMsg>, <.update.>,;
             <{uWhen}>, <{uValid}> )
