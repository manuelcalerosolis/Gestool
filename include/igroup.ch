#ifndef _ICONGROUP_CH
#define _ICONGROUP_CH

/*----------------------------------------------------------------------------//
!short: ICON GROUP  */

#xcommand REDEFINE ICON GROUP [ <oIGroup> ] ;
             [ ID <nId> ] ;
             [ ICONS <aIcons,...> ] ;
             [ PROMPTS <aPrompts,...> ] ;
             [ ACTIONS <aActions,...> ] ;
             [ <dlg: OF,WINDOW,DIALOG > <oWnd> ] ;
             [ <help:HELP, HELPID, HELP ID> <nHelpId> ] ;
             [ ON CHANGE <uChange,...> ] ;
             [ <color: COLOR,COLORS > <nClrFore> [,<nClrBack>] ] ;
             [ FONT <oFont> ];
             [ CURSOR <oCursor> ] ;
             [ MESSAGE <cMsg> ] ;
             [ <update: UPDATE > ] ;
      => ;
          [ <oIGroup> := ] TIconGroup():ReDefine( <nId>, ;
             [\{<aIcons>\}], [\{<aPrompts>\}], [\{<{aActions}>\}], ;
             [<oWnd>], <nHelpId>, [{|Self|<uChange>}], <cMsg>, ;
             <nClrFore>, <nClrBack>, <oFont>, <oCursor>, <.update.> )

#xcommand @ <nRow>, <nCol> ICON GROUP [ <oIGroup> ] ;
             [ ICONS <aIcons,...> ] ;
             [ PROMPTS <aPrompts,...> ] ;
             [ ACTIONS <aActions,...> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ <lPixel: PIXEL > ] ;
             [ <dlg: OF,WINDOW,DIALOG > <oWnd> ] ;
             [ <help:HELP, HELPID, HELP ID> <nHelpId> ] ;
             [ <lNoBorder:NOBORDER, NO BORDER> ] ;
             [ ON CHANGE <uChange,...> ] ;
             [ <lVScroll: VSCROLL, VERTICAL SCROLL> ] ;
             [ <lHScroll: HSCROLL, HORIZONTAL SCROLL> ] ;
             [ <color: COLOR,COLORS > <nClrFore> [,<nClrBack>] ] ;
             [ FONT <oFont> ];
             [ CURSOR <oCursor> ] ;
             [ MESSAGE <cMsg> ] ;
             [ <design: DESIGN >  ] ;
             [ <update: UPDATE >  ] ;
      => ;
          [ <oIGroup> := ] TIconGroup():New( <nRow>, <nCol>, ;
             [\{<aIcons>\}], [\{<aPrompts>\}], [\{<{aActions}>\}], ;
             [<oWnd>], <nHelpId>, <.lNoBorder.>, [{|Self|<uChange>}], ;
             <nWidth>, <nHeight>, <cMsg>, <.lPixel.>, <.lVScroll.>, <.lHScroll.>, ;
             <nClrFore>, <nClrBack>, <oFont>, <oCursor>, <.design.>, <.update.> )

#endif