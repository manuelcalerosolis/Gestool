#ifndef _SLIDER_CH
#define _SLIDER_CH

/*----------------------------------------------------------------------------//
!short: SLIDER  */

#xcommand REDEFINE SLIDER [ <oSlide> VAR ] <nVar> ;
               [ ID <nId> ] ;
               [ <h: HORIZONTAL> ] ;
               [ <v: VERTICAL> ] ;
               [ <direction1: TOP DIRECTION, LEFT DIRECTION > ] ;
               [ <direction2: BOTTOM DIRECTION, RIGHT DIRECTION > ] ;
               [ RANGE <nMin>, <nMax> ] ;
               [ MARKS <nMarks> ] ;
               [ <lExact: EXACT > ] ;
               [ <dlg: OF,WINDOW,DIALOG > <oWnd> ] ;
               [ ON CHANGE <uChange> ] ;
               [ ON THUMBPOS <uPos> ] ;
               [ <color: COLOR,COLORS > <nClrFore> [,<nClrBack> [,<nClrBtn> ] ] ] ;
               [ MESSAGE <cMsg> ] ;
               [ <update: UPDATE >  ] ;
      => ;
          [ <oSlide> := ] TSlider():Redefine( <nId>, bSETGET(<nVar>), ;
             (.not.<.v.>) [.or. <.h.>], [<.direction1.>], [<.direction2.>], ;
             <nMin>, <nMax>, <nMarks>, <.lExact.>, ;
             [<oWnd>], [\{|nVar|<uChange>\}], [\{|nVar|<uPos>\}], ;
             <cMsg>, <nClrFore>, <nClrBack>, <nClrBtn>, <.update.> )

#xcommand @ <nRow>, <nCol> SLIDER [ <oSlide> VAR ] <nVar> ;
               [ <h: HORIZONTAL> ] ;
               [ <v: VERTICAL> ] ;
               [ <direction1: TOP DIRECTION, LEFT DIRECTION > ] ;
               [ <direction2: BOTTOM DIRECTION, RIGHT DIRECTION > ] ;
               [ RANGE <nMin>, <nMax> ] ;
               [ MARKS <nMarks> ] ;
               [ <lExact: EXACT > ] ;
               [ SIZE <nWidth>, <nHeight> ] ;
               [ <lPixel: PIXEL > ] ;
               [ <dlg: OF,WINDOW,DIALOG > <oWnd> ] ;
               [ ON CHANGE <uChange> ] ;
               [ ON THUMBPOS <uPos> ] ;
               [ <color: COLOR,COLORS > <nClrFore> [,<nClrBack> [,<nClrBtn> ] ] ] ;
               [ MESSAGE <cMsg> ] ;
               [ <design: DESIGN >  ] ;
               [ <update: UPDATE >  ] ;
      => ;
          [ <oSlide> := ] TSlider():New( <nRow>, <nCol>, bSETGET(<nVar>), ;
             (.not.<.v.>) [.or. <.h.>], [<.direction1.>], [<.direction2.>], ;
             <nMin>, <nMax>, <nMarks>, <.lExact.>, ;
             [<oWnd>], [\{|nVar|<uChange>\}], [\{|nVar|<uPos>\}], ;
             <nWidth>, <nHeight>, <.lPixel.>, <cMsg>, ;
             <nClrFore>, <nClrBack>, <nClrBtn>, <.design.>, <.update.> )

#endif