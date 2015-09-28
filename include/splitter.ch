#ifndef _SPLITTER_CH
#define _SPLITTER_CH

/*----------------------------------------------------------------------------//
!short: SPLITTER  */

#xcommand REDEFINE SPLITTER [ <oSplit> ] ;
             [ ID <nId> ] ;
             [ <h: HORIZONTAL> ] ;
             [ <v: VERTICAL> ] ;
             [ PREVIOUS CONTROLS <aPrevCtrols,...> [ <prev: NO ADJUST> ] ] ;
             [ HINDS CONTROLS <aHindCtrols,...> [ <hind: NO ADJUST> ] ] ;
             [ <margin1: TOP MARGIN, LEFT MARGIN > <nMargin1> ] ;
             [ <margin2: BOTTOM MARGIN, RIGHT MARGIN > <nMargin2> ] ;
             [ <dlg: OF,WINDOW,DIALOG > <oWnd> ] ;
             [ ON CHANGE <uChange,...> ] ;
             [ <lLook3d: 3D, 3DLOOK, _3D, _3DLOOK> ] ;
             [ <color: COLOR,COLORS > <nClrBack> ] ;
             [ <update: UPDATE > ] ;
             [ <lStyle: STYLE> ];
             [ GRAD <aGradient>[,<aGradientOver>] ];
       => ;
          [ <oSplit> := ] TSplitter():ReDefine( <nId>, ;
             (.not.<.h.>) [.or. <.v.>], [\{<aPrevCtrols>\}], .not.<.prev.>, ;
             [\{<aHindCtrols>\}], .not.<.hind.>, ;
             [{|| <nMargin1>}], [{|| <nMargin2>}], ;
             <oWnd>, [\{||<uChange>\}], ;
             <.lLook3d.>, <nClrBack>, <.update.> )

#xcommand @ <nRow>, <nCol> SPLITTER [ <oSplit> ] ;
             [ <h: HORIZONTAL> ] ;
             [ <v: VERTICAL> ] ;
             [ PREVIOUS CONTROLS <aPrevCtrols,...> [ <prev: NO ADJUST> ] ] ;
             [ HINDS CONTROLS <aHindCtrols,...> [ <hind: NO ADJUST> ] ] ;
             [ <margin1: TOP MARGIN, LEFT MARGIN > <nMargin1> ] ;
             [ <margin2: BOTTOM MARGIN, RIGHT MARGIN > <nMargin2> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ <lPixel: PIXEL > ] ;
             [ <dlg: OF,WINDOW,DIALOG > <oWnd> ] ;
             [ ON CHANGE <uChange,...> ] ;
             [ <lLook3d: 3D, 3DLOOK, _3D, _3DLOOK> ] ;
             [ <color: COLOR,COLORS > <nClrBack> ] ;
             [ <design: DESIGN >  ] ;
             [ <update: UPDATE >  ] ;
             [ <lStyle: STYLE> ];
             [ GRAD <aGradient>[,<aGradientOver>] ];
      => ;
          [ <oSplit> := ] TSplitter():New( <nRow>, <nCol>, ;
             (.not.<.h.>) [.or. <.v.>], [\{<aPrevCtrols>\}], .not.<.prev.>, ;
             [\{<aHindCtrols>\}], .not.<.hind.>, ;
             [{|| <nMargin1>}], [{|| <nMargin2>}], ;
             [<oWnd>], [\{||<uChange>\}], ;
             <nWidth>, <nHeight>, <.lPixel.>, ;
             <.lLook3d.>, <nClrBack>, <.design.>, <.update.>, <.lStyle.>, <aGradient>[,<aGradientOver>] )

#endif