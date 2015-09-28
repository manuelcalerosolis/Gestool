#ifndef _TSELEX_CH

#define _TSELEX_CH


#xcommand @ <nRow>, <nCol> SELEX [<oSelex> VAR ] <nOption> ;
          [ <of:OF, WINDOW, DIALOG> <oWnd> ] ;
          [ SIZE <nWidth>, <nHeight> ];                         
          [ <lPixel: PIXEL > ] ;
          [ <act: ACTION, EXECUTE, ON CHANGE> <uAction> ] ;
          [ <prm: PROMPT, PROMPTS, ITEMS, OPTIONS> <aOptions,...> ] ;
          [ COLOR THUMB <nClrThumb> ];
          [ GRADIENT INTRACK <aGradIn> ];
          [ GRADIENT OUTTRACK <aGradOut> ];
          [ LINECOLORS <nClrBoxIn> [, <nClrBoxOut> ] ];
          [ ROUNDSIZE <nRound> ];
          [ COLORTEXT <nClrText> [, <nClrOptSel> ] ];
          [ THUMBSIZE <nWidthThumb>[, <nHeightThumb> ] ];
          [ <lUpdate: UPDATE> ] ;
          [ FONT <oFont> ];  
          [ TITLE <cTitle> [ <lTop: TOP> ] ];
          [ COLORTITLE <nClrTitle> ];          
=> ;
          [ <oSelex> := ] TSelex():New( <nRow>, <nCol>, <nWidth>, <nHeight>, <oWnd>, <.lPixel.>, ;
                                        [\{<aOptions>\}], [{|nOption,nOldOption|<uAction>}], <.lUpdate.>,;
                                        <aGradOut>, <aGradIn>, <nClrBoxIn>, ;
                                        <nClrBoxOut>, <nClrThumb>, ;
                                        <nClrText>, bSETGET( <nOption> ), <nClrOptSel>,;
                                        <nWidthThumb>, <nHeightThumb>, <nRound>, <oFont>,;
                                        <cTitle>, <nClrTitle>, [<.lTop.>] ) 
                                        
#xcommand REDEFINE SELEX [<oSelex> VAR ] <nOption> ;
          [ <of:OF, WINDOW, DIALOG> <oWnd> ] ;
          [ ID <nID> ];
          [ <act: ACTION, EXECUTE, ON CHANGE> <uAction> ] ;
          [ <prm: PROMPT, PROMPTS, ITEMS, OPTIONS> <aOptions,...> ] ;
          [ COLOR THUMB <nClrThumb> ];
          [ GRADIENT INTRACK <aGradIn> ];
          [ GRADIENT OUTTRACK <aGradOut> ];
          [ LINECOLORS <nClrBoxIn> [, <nClrBoxOut> ] ];
          [ ROUNDSIZE <nRound> ];
          [ COLORTEXT <nClrText> [, <nClrOptSel> ] ];
          [ THUMBSIZE <nWidthThumb>[, <nHeightThumb> ] ];
          [ <lUpdate: UPDATE> ] ;
          [ FONT <oFont> ];  
          [ TITLE <cTitle> [ <lTop: TOP> ] ];
          [ COLORTITLE <nClrTitle> ];
=> ;
          [ <oSelex> := ] TSelex():Redefine( <nID>, <oWnd>, [\{<aOptions>\}], [{|nOption,nOldOption|<uAction>}], ;
                                        <.lUpdate.>, <aGradOut>, <aGradIn>, <nClrBoxIn>, ;
                                        <nClrBoxOut>, <nClrThumb>, ;
                                        <nClrText>, bSETGET( <nOption> ), <nClrOptSel>,;
                                        <nWidthThumb>, <nHeightThumb>, <nRound>, <oFont>,;
                                        <cTitle>, <nClrTitle>, [<.lTop.>] ) 

#endif