//----------------------------------------------------------------------------//
// GANTT

#ifndef __GANTT_CH
#define __GANTT_CH

#xcommand @ <nRow>, <nCol> GANTT [<oGantt>] ;
             [ <dlg: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ <border: BORDER>] ;
             [ <vScroll: VSCROLL, VERTICAL SCROLL> ] ;
             [ <hScroll: HSCROLL, HORIZONTAL SCROLL> ] ;
             [ <color: COLOR, COLORS> <nClrFore> [,<nClrBack>] ] ;
             [  ON CHANGE <uChange> ] ;
             [  ON PRESSED <uPressed> ] ;
             [  BOXLIS <uLbx> ] ;
       => ;
          [<oGantt> := ] TGantt():New( <nRow>, <nCol>, <nWidth>, <nHeight>, <oWnd>,;
             <.border.>, [<.vScroll.>], [<.hScroll.>], <nClrFore>,;
             <nClrBack>, [<{uChange}>], [<{uPressed}>], <uLbx> )

#xcommand REDEFINE GANTT [<oGantt>] ;
             [ ID <nId> ] ;
             [ <dlg: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <color: COLOR, COLORS> <nClrFore> [,<nClrBack>] ] ;
       => ;
          [ <oGantt> := ] TGantt():Redefine( <nId>, <oWnd>,;
             <nClrFore>, <nClrBack> )

#endif