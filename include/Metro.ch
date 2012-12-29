// FiveWin - Windows 8 Metro look

#ifndef _METRO_CH
#define _METRO_CH

//----------------------------------------------------------------------------//

#xcommand DEFINE METRO <oMtr> ;
             [ BACKGROUND <cFileName> ] ;
             [ BTNSIZE <nBtnWidth>, <nBtnHeight> ] ;
             [ TITLE <cTitle> ] ;
          => ;
          <oMtr> := TMetro():New( <cTitle>, <nBtnWidth>, <nBtnHeight>, <cFileName> )

#xcommand DEFINE METROBUTTON [<oBtn>] ;
             [ PROMPT <cPrompt> ] ;
             [ COLOR <nClrText>, <nClrPane> ] ;
             [ IMAGE <cImgName> ] ;
             [ OF <oMetro> ] ;
             [ <large: LARGE> ] ;
             [ ACTION <uAction,...> ] ;
             [ FONT <oFont> ] ;
             [ TOOLTIP <cToolTip> ] ;
             [ <adjust: ADJUST> ] ;
             [ <layout: CENTER, TOP, LEFT, BOTTOM, RIGHT> ] ;
          => ;
             [ <oBtn> := ] <oMetro>:AddButton( <cPrompt>, <nClrText>, <nClrPane>, <.large.>, <cImgName>, [{||<uAction>}], <oFont>, <cToolTip>, <.adjust.>, [ Upper(<(layout)>) ] )

#xcommand ACTIVATE METRO <oMtr> => <oMtr>:Activate()

//----------------------------------------------------------------------------//

#endif
