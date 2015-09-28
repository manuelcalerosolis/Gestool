/*
*
*   MetroPnl.ch
*
*
*/

#include "fivewin.ch"

#ifndef DT_TOP
#define DT_TOP              0
#define DT_LEFT             0
#define DT_CENTER           1
#define DT_RIGHT            2
#define DT_VCENTER          4
#define DT_BOTTOM           8
#define DT_WORDBREAK       16
#define DT_SINGLELINE      32
#define DT_CALCRECT      1024
#endif

#xcommand DEFINE METROPANEL <oMetro> OF <oWnd> ;
            [ TITLE <cTitle> ] ;
            [ COLOR <nClrText>, <nClrPane> ] ;
            [ TILESIZE <nSize> ] ;
            [ ON CLICK <uAction> ] ;
            [ SCROLLBARCOLOR <nClrThumb>, <nClrScroll> ] ;
          => ;
          <oMetro> := TMetroPanel():New( <oWnd>, <cTitle>, <nClrText>, <nClrPane>, <{uAction}>, <nSize>, ;
          				 <nClrThumb>, <nClrScroll> )

#xcommand DEFINE METROBUTTON [<oBtn>] OF <oMetro> ;
            [ <prmt:PROMPT,CAPTION> <cPrompt> ] ;
            [ COLOR <nClrText>, <nClrPane> ] ;
            [ ALIGN <nAlign> ] ;
            [ FONT  <oFont>  ] ;
            [ GROUP <nGroup> ] ;
            [ MENU <oSub> ] ;
            [ <bmp:BITMAP,IMAGE> <cImgName> [ BMPALIGN <nBmpAlign> ] [ SIZE <nBmpWidth>,<nBmpHeight> ] ] ;
            [ BACKGROUND <cImage> ] ;
            [ <large: LARGE> ] ;
            [ <txt:BODY,BODYTEXT,TEXT> <cText> [ TEXTALIGN <nTextAlign> ] [ TEXTFONT <oTextFont> ] ] ;
            [ ACTION <uAction,...> ] ;
          => ;
            [ <oBtn> := ] <oMetro>:AddButton( <.large.>, <nGroup>, <cPrompt>, [<{uAction}>], <nClrText>, <nClrPane>,  ;
                     <cImgName>, <oFont>, <nAlign>, <nBmpAlign>, <nBmpWidth>, <nBmpHeight>, ;
                     <cText>, <nTextAlign>, <oTextFont>, <oSub>, <cImage>, <"uAction">, <"oSub"> )

#xcommand ADD [<oBtn>] TO METRO <oMetro> [<clauses,...>] => ;
          DEFINE METROBUTTON [<oBtn>] OF <oMetro> [<clauses>]

