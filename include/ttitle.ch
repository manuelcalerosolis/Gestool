// TTITLE

#ifndef __TITLE_CH
#define __TITLE_CH

#xcommand @ <nRow>, <nCol> TITLE [ <oTitle> ] ;
             [ <wnd: OF, WINDOW, DIALOG > <oWnd> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ TEXT <cText> ];
             [ <lRound: ROUND> ];
             [ <lNoBorder: NOBORDER> ];
             [ <lTrans: TRANSPARENT> ];
             [ <lBase: BASE> ];
             [ <ColorBox: COLORBOX> <nClrBoxOut>,<nClrBoxIn> ] ;
             [ SHADOW <shadow: TOPLEFT, TOPRIGHT, BOTTOMLEFT, BOTTOMRIGHT, NOSHADOW> ] ;
             [ SHADOWSIZE <nSSize> ];
             [ GRADIENT <aGrdBack> ];
             [ <lVert: VGRAD, VERTICALGRADIENT, VERTICALG> ];
             [ BRUSH <oBrush> ];
      => ;
         [ <oTitle> := ] TTitle():New( <oWnd>, <nRow>, <nCol>, <nWidth>, <nHeight>,;
                                       [<cText>], [<.lRound.>], [!<.lNoBorder.>], [<.lTrans.>], ;
                                       [<.lBase.>], <aGrdBack> , ,<nClrBoxOut>, <nClrBoxIn>, ;
                                       [ Upper(<(shadow)>) ], [<nSSize>], [!<.lVert.>], <oBrush> )


#xcommand REDEFINE TITLE [ <oTitle> ] ;
             [ ID <nID> ];
             [ <wnd: OF, WINDOW, DIALOG > <oWnd> ] ;
             [ TEXT <cText> ];
             [ <lRound: ROUND> ];
             [ <lNoBorder: NOBORDER> ];
             [ <lTrans: TRANSPARENT> ];
             [ <lBase: BASE> ];
             [ <ColorBox: COLORBOX> <nClrBoxOut>,<nClrBoxIn> ] ;
             [ SHADOW <shadow: TOPLEFT, TOPRIGHT, BOTTOMLEFT, BOTTOMRIGHT, NOSHADOW> ] ;
             [ SHADOWSIZE <nSSize> ];
             [ GRADIENT <aGrdBack> ];
             [ <lVert: VGRAD, VERTICALGRADIENT, VERTICALG> ];
             [ BRUSH <oBrush> ];
      => ;
         [ <oTitle> := ] TTitle():Redefine( <nID>, <oWnd>, [<cText>], [<.lRound.>], [!<.lNoBorder.>], [<.lTrans.>], ;
                                       [<.lBase.>], <aGrdBack> , ,<nClrBoxOut>, <nClrBoxIn>, ;
                                       [ Upper(<(shadow)>) ], [<nSSize>], [!<.lVert.>], <oBrush> )
     
     
#xcommand @ <nRow>, <nCol> TITLEIMG [ <oImg> <tit: OF, TITLE> <oTitle> ] ;
             [ <tit: OF, TITLE> <oTitle> ] ;
             [ <bm: BITMAP, HBITMAP, FILE, NAME, RESNAME> <cnName> ];
             [ SIZE <nWidth>, <nHeight> ];
             [ <alpha: ALPHALEVEL, LEVEL, ALPHA> <nAlphaLevel> ];
             [ <lReflex: REFLEX> ];
             [ <lTrans: TRANSPARENT> ];
             [ <lAnima: ANIMA> ];
             [ ACTION <uAction> ] ;  
             [ TOOLTIP <cToolTip> ];          
        =>;
        [ <oImg> := ] <oTitle>:LoadBitmaps( <cnName>, <nRow>, <nCol>, <nWidth>, ;
                             <nHeight>, <nAlphaLevel>, [<.lReflex.>],;
                             [<.lTrans.>], [<.lAnima.>], [{|Self|<uAction>}] )
        

#xcommand @ <nRow>, <nCol> TITLETEXT [ <oTxt> <tit: OF, TITLE> <oTitle> ] ;
             [ <tit: OF, TITLE> <oTitle> ];
             [ <txt: TEXT, CAPTION, TITLE> <cText> ]; 
             [ <lJustify: JUSTIFY > ];
             [ <br: BRUSH, HBRUSH> <ohBrush> ];
             [ <pn: PEN, HPEN> <ohPen> ];
             [ SHADOW <shadow: TOPLEFT, TOPRIGHT, BOTTOMLEFT, BOTTOMRIGHT> ];
             [ <ft: FONT> <ohFont> ];
             [ COLOR <nTextClr> ];
             [ <look3d: 3D, RELIEVE> ];
        =>;
       [ <oTxt> := ] <oTitle>:AddText( <nRow>, <nCol>, <cText>, ;
                          <.lJustify.>, <ohBrush>, <ohPen>, ;
                          [ Upper(<(shadow)>) ], <ohFont>, <nTextClr>, [<.look3d.>] ) 

#endif         