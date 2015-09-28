#ifndef _SELECTOR_CH
#define _SELECTOR_CH

/*----------------------------------------------------------------------------//
!short: SELECTOR  */

#xcommand REDEFINE SELECTOR [ <oSelec> VAR ] <nVar> ;
               [ ID <nId> ] ;
               [ ORIGIN ANGLE <nAngle1> ] ;
               [ LAST ANGLE <nAngle2> ] ;
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
          [ <oSelec> := ] TSelector():Redefine( <nId>, bSETGET(<nVar>), ;
             [<nAngle1>], [<nAngle2>], ;
             <nMin>, <nMax>, <nMarks>, <.lExact.>, ;
             [<oWnd>], [\{|nVar|<uChange>\}], [\{|nVar|<uPos>\}], ;
             <cMsg>, <nClrFore>, <nClrBack>, <nClrBtn>, <.update.> )

#xcommand @ <nRow>, <nCol> SELECTOR [ <oSelec> VAR ] <nVar> ;
               [ ORIGIN ANGLE <nAngle1> ] ;
               [ LAST ANGLE <nAngle2> ] ;
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
          [ <oSelec> := ] TSelector():New( <nRow>, <nCol>, bSETGET(<nVar>), ;
             [<nAngle1>], [<nAngle2>], ;
             <nMin>, <nMax>, <nMarks>, <.lExact.>, ;
             [<oWnd>], [\{|nVar|<uChange>\}], [\{|nVar|<uPos>\}], ;
             <nWidth>, <nHeight>, <.lPixel.>, <cMsg>, ;
             <nClrFore>, <nClrBack>, <nClrBtn>, <.design.>, <.update.> )

#endif