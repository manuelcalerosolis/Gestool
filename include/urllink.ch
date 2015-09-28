#ifndef _URLLINK_CH
#define _URLLINK_CH

#define TME_LEAVE        2
#define WM_MOUSELEAVE  675

#xcommand @ <nTop>, <nLeft> URLLINK <oURL> ;
             [ <dlg: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <pixel: PIXEL> ] ;
             [ <lDesign: DESIGN> ] ;
             [ FONT <oFont> ] ;
             [ MESSAGE <cMsg> ] ;
             [ URL <cURL> ] ;
             [ TOOLTIP <cToolTip> ] ;
             [ CLRINIT <nClrInit> ] ;
             [ CLROVER <nClrOver> ] ;
             [ CLRVISIT <nClrVisit> ] ;
       => ;
          [ <oURL> := ] TURLLink():New( <nTop>, <nLeft>, [<oWnd>], ;
                        <.pixel.>, <.lDesign.>, <oFont>, <cMsg>, ;
                        <cURL>, <cToolTip>, <nClrInit>, <nClrOver>, ;
                        <nClrVisit> )

#xcommand REDEFINE URLLINK [<oURL>] ;
             [ ID <nId> ] ;
             [ <dlg: OF, WINDOW, DIALOG> <oDlg> ] ;
             [ FONT <oFont> ] ;
             [ MESSAGE <cMsg> ] ;
             [ URL <cURL> ] ;
             [ TOOLTIP <cToolTip> ] ;
             [ CLRINIT <nClrInit> ] ;
             [ CLROVER <nClrOver> ] ;
             [ CLRVISIT <nClrVisit> ] ;
       => ;
          [ <oURL> := ] TURLLink():ReDefine( <nId>, <oDlg>, ;
                        <oFont>, <cMsg>, <cURL>, <cToolTip>, ;
                        <nClrInit>, <nClrOver>, <nClrVisit> )

#endif
