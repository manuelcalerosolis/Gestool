#ifndef _RIBBON_CH
#define _RIBBON_CH

/*----------------------------------------------------------------------------//
//RIBONBAR
------------------------------------------------------------------------------*/

#xcommand DEFINE RIBBONBAR [ <oRBar> ] ;
                           [ <of:OF, WINDOW> <oWnd> ] ;
                           [ <prm: PROMPT, PROMPTS, ITEMS> <cPrompt,...> ] ;
                           [ <act: ACTION, EXECUTE, ON CHANGE> <uAction> ] ;
                           [ OPTION <nOption> ] ;
                           [ HEIGHT <nHeight> ] ;
                           [ TOPMARGIN <nTopMargin> ];
                           [ COLOR <nClrPane> ] ;
                           [ <ColorBox: COLORBOX> <nClrBoxOut>,<nClrBoxIn> ] ;
                           [ <ColorSel: COLORSEL> <nClrBoxSelOut>,<nClrBoxSelIn> ] ;
                           [ <l2010: 2010, _2010> ];
                           [ <l2013: 2013, _2013> ];
                           [ STARTBTN <nStart> ];
       => ;
          [<oRBar> := ] TRibbonBar():New( <oWnd>, [\{<cPrompt>\}], [{|nOption,nOldOption|<uAction>}], ;
             <nOption>, , <nHeight>, <nTopMargin>, <nClrPane>, <nClrBoxOut>, <nClrBoxIn>, <nClrBoxSelOut>, ;
             <nClrBoxSelIn>, , , , , <.l2010.>, <nStart>, <.l2013.> )

/*----------------------------------------------------------------------------//
//GROUP
------------------------------------------------------------------------------*/             
#xcommand ADD GROUP [ <oGr> ] ;
                    [ <of: RIBBONBAR, RIBBON > <oRBar> ];
                    [ <to: TO OPTION, TO> <nOption> ];
                    [ PROMPT <cCaption> ];
                    [ WIDTH <nWidth> ];
                    [ ACTION <uAction> ] ;
                    [ BITMAP <cBitmap> ] ;
                    [ GRADIANT <aGradSel> ];
       =>;
          [ <oGr> := ] <oRBar>:AddGroup( <nWidth>, <cCaption>, <nOption>,;
                    [{|Self|<uAction>}], <cBitmap>, <aGradSel> )
          
/*----------------------------------------------------------------------------//
//GROUP
------------------------------------------------------------------------------*/             
#xcommand @ <nRow>, <nCol> RBGROUP [ <oGr> ] ;
                               [ <of: OF, WINDOW, DIALOG > <oWnd> ];
                               [ PROMPT <cCaption> ];
                               [ SIZE <nWidth>, <nHeight> ] ;
                               [ ACTION <uAction> ] ;
                               [ BITMAP <cBitmap> ] ;
                               [ FONT <oFont> ];
                               [ <lTrans: TRANSPARENT> ];
                               [ GRADIANT <aGradSel> ];
                               [ LINECOLORS <nClrBoxIn>, <nClrBoxOut> ];
                               [ CAPTIONGRAD <aGradCaption> ];
                               [ DISABLEGRAD <aGradDisable> ];
                               [ DISABLECAPION <aDisableCap> ];
                               [ TEXTCOLOR <nClrTxt> ];
       =>;
          [ <oGr> := ] TRBGroup():New( <oWnd>, <nRow>, <nCol>, <nHeight>, <nWidth>, ,;
                                       <cCaption>, [{|Self|<uAction>}],;
                                       <nClrBoxIn>, <nClrBoxOut>, <aGradSel>, ,;
                                       <aGradCaption>, <aGradDisable>, <aDisableCap> , ,;
                                       <oFont>, <cBitmap>, [<.lTrans.>], <nClrTxt> )          

/*----------------------------------------------------------------------------//
//SEPARATOR
------------------------------------------------------------------------------*/   
          
#xcommand ADD SEPARATOR TO GROUP <oGr> ;
                    [ <to: TO, COLUMN, COL> <nCol> ];
      =>;
          <oGr>:AddSeparator( <nCol> )

          
/*----------------------------------------------------------------------------//
//BUTTON
------------------------------------------------------------------------------*/          
#xcommand @ <nRow>, <nCol> ADD BUTTON [ <oBtn> ] ;
                                      [ PROMPT <cCaption> ];
                                      [ SIZE <nWidth>, <nHeight> ] ;
                                      [ BITMAP <cBitmap> ] ;
                                      [ ACTION <uAction> ] ;
                                      [ <of: OF, GROUP> <oGr> ] ;
                                      [ WHEN <WhenFunc> ] ;
                                      [ <lBorder: BORDER> ] ;
                                      [ <lRound: ROUND> [ <rs: RSIZE, ROUNDSIZE> <nRound> ] ] ;
                                      [ <layout: TOP, LEFT, BOTTOM, RIGHT, MOSTLEFT, MOSTRIGHT, CENTER> ] ;
                                      [ <type: NORMAL, POPUP, SPLITPOPUP, SAYBUTTON> ] ;
                                      [ <lGrouping: GROUPBUTTON> [<lFirstElm: FIRST>][ <lEndElm: END> ] ];
                                      [ MENU <oPopup> ];
                                      [ MESSAGE <cMsg> ] ;
                                      [ LINECOLORS <nClrBoxIn>, <nClrBoxOut> ];    
                                      [ TOOLTIP <cToolTip> ];                                  
       =>;
          [ <oBtn> := ] <oGr>:AddButton( <nRow>, <nCol>, <nHeight>, <nWidth>, <cCaption>,;
                                         [{|Self|<uAction>}], [ Upper(<(type)>) ], <{WhenFunc}>, ;
                                         <cBitmap>, [<.lBorder.>], <.lRound.>, [ Upper(<(layout)>) ], ;
                                         [<oPopup>], [<.lGrouping.>], [<.lFirstElm.>], [<.lEndElm.>], <cMsg>, [<nRound>],;
                                         [<nClrBoxIn>], [<nClrBoxOut>], ,<cToolTip> )
          
                     
/*----------------------------------------------------------------------------//
//BUTTON
------------------------------------------------------------------------------*/          
#xcommand @ <nRow>, <nCol> RBBTN [ <oBtn> ] ;
                                 [ PROMPT <cCaption> ];
                                 [ SIZE <nWidth>, <nHeight> ] ;
                                 [ BITMAP <cBitmap> ] ;
                                 [ ACTION <uAction> ] ;
                                 [ <of: OF, DIALOG, WINDOW> <oWnd> ] ;
                                 [ WHEN <WhenFunc> ] ;
                                 [ <lBorder: BORDER> ] ;
                                 [ <lRound: ROUND> [ <rs: RSIZE, ROUNDSIZE><nRound> ] ] ;
                                 [ <lAdjust: ADJUST> ] ;
                                 [ <layout: TOP, LEFT, BOTTOM, RIGHT, MOSTLEFT, MOSTRIGHT, CENTER> ] ;
                                 [ <type: NORMAL, POPUP, SPLITPOPUP, SAYBUTTON> ] ;
                                 [ <lGrouping: GROUPBUTTON> [<lFirstElm: FIRST>][ <lEndElm: END> ] ];
                                 [ MENU <oPopup> ];
                                 [ MESSAGE <cMsg> ] ;
                                 [ TOOLTIP <cToolTip> ];
                                 [ FONT <oFont> ];
                                 [ <lTrans: TRANSPARENT> ];
                                 [ GRADIANT <aGradiant> ];
                                 [ LINECOLORS <nClrBoxIn>, <nClrBoxOut> ];
       =>;
          [ <oBtn> := ] TRBtn():New( <nRow>, <nCol>, <nWidth>, <nHeight>, <cBitmap>,;
                                         [{|Self|<uAction>}], <oWnd>, <cMsg>, <{WhenFunc}>, <.lAdjust.>, ,;
                                         <cCaption>, <oFont>, [<.lBorder.>], [<.lRound.>],; 
                                         [ Upper(<(layout)>) ], , <cToolTip>, , ,[ Upper(<(type)>) ],  ;
                                         [<oPopup>], , , , , , , , ,[<.lGrouping.>], [<.lFirstElm.>], ;
                                         [<.lEndElm.>], [<.lTrans.>], [<aGradiant>], [<nClrBoxIn>], [<nClrBoxOut>], [<nRound>] )

#xcommand REDEFINE RBBTN [ <oBtn> ] ;
                         [ ID <nID> ];
                         [ PROMPT <cCaption> ];
                         [ BITMAP <cBitmap> ] ;
                         [ ACTION <uAction> ] ;
                         [ <of: OF, DIALOG, WINDOW> <oWnd> ] ;
                         [ WHEN <WhenFunc> ] ;
                         [ <lBorder: BORDER> ] ;
                         [ <lRound: ROUND> [ <rs: RSIZE, ROUNDSIZE><nRound> ] ] ;
                         [ <lAdjust: ADJUST> ] ;
                         [ <layout: TOP, LEFT, BOTTOM, RIGHT, MOSTLEFT, MOSTRIGHT, CENTER> ] ;
                         [ <type: NORMAL, POPUP, SPLITPOPUP, SAYBUTTON> ] ;
                         [ <lGrouping: GROUPBUTTON> [<lFirstElm: FIRST>][ <lEndElm: END> ] ];
                         [ MENU <oPopup> ];
                         [ MESSAGE <cMsg> ] ;
                         [ TOOLTIP <cToolTip> ];
                         [ FONT <oFont> ];
                         [ <lTrans: TRANSPARENT> ];
                         [ GRADIANT <aGradiant> ];
                         [ LINECOLORS <nClrBoxIn>, <nClrBoxOut> ];
       =>;
          [ <oBtn> := ] TRBtn():Redefine( <nID>, <cBitmap>,;
                                    [{|Self|<uAction>}], <oWnd>, <cMsg>, <{WhenFunc}>, <.lAdjust.>, ,;
                                    <cCaption>, <oFont>, [<.lBorder.>], [<.lRound.>],; 
                                    [ Upper(<(layout)>) ], , <cToolTip>, , ,[ Upper(<(type)>) ],  ;
                                    [<oPopup>], , , , , , , , ,[<.lGrouping.>], [<.lFirstElm.>], ;
                                    [<.lEndElm.>], [<.lTrans.>], [<aGradiant>], [<nClrBoxIn>], [<nClrBoxOut>], [<nRound>] )
                                         
/*----------------------------------------------------------------------------//
//BACKSTAGE
------------------------------------------------------------------------------*/          
#xcommand DEFINE BACKSTAGE <oBackStage>;
                 [ MAINWIDTH <nWidth> ];
       => ;
          <oBackStage> := TBackStage():New( , , , , , [<nWidth>] )



#xcommand DEFINE BSSELECT [ <oOption> ] [ <of: OF, BACKSTAGE> <oBackStage> ] ;
                          [ PROMPT <cCaption> ];
                          [ HEIGHT <nHeight> ] ;
                          [ ACTION <uAction> ] ;
                          [ <clrtext: COLORTEXT> <nClrText>[,<nClrTextOver>] ] ;
                          [ GRADIENT <aGradOver> ];
                          [ COLORS <nClrStart>[,<nClrEnd>] ];
                          [ BORDER <nBorderClr> ];
                          [ LEFTMARGIN <nLeftMargin> ];
       =>;
          [ <oOption> := ] <oBackStage>:AddOption( <cCaption>, [<nClrText>], <aGradOver>, 1, ;
                                         <nHeight>, <nClrStart>, [<nClrEnd>], <nBorderClr>, , ;
                                         <nLeftMargin>, [<nClrTextOver>], ,[{|Self, oOpt, nLastSelect |<uAction>}] )

#xcommand DEFINE BSBUTTON [ <oOption> ] [ <of: OF, BACKSTAGE> <oBackStage> ] ;
                          [ PROMPT <cCaption> ];
                          [ BITMAP <cBitmap> ] ;
                          [ HEIGHT <nHeight> ] ;
                          [ ACTION <uAction> ] ;
                          [ <clrtext: COLORTEXT> <nClrText>[,<nClrTextOver>] ] ;
                          [ GRADIENT <aGradOver> ];
                          [ BORDER <nBorderClr> ];
                          [ LEFTMARGIN <nLeftMargin> ];
       =>;
          [ <oOption> := ] <oBackStage>:AddOption( <cCaption>, [<nClrText>], <aGradOver>, 2, ;
                                         <nHeight>, , , <nBorderClr>, <cBitmap>, ;
                                         <nLeftMargin>, [<nClrTextOver>], ,[{|Self, oOpt, nLastSelect |<uAction>}] )


#xcommand SET BACKSTAGE <oBackStage>  TO <oRBar>;
       => ;
          <oRBar>:SetBackStage( <oBackStage> )
          
#xcommand DEFINE QUICKBUTTON [ <of: OF, RIBBON> <oRibbon> ] ;
                             [ <file: BITMAP, IMAGE> <cBmp1> ;
                             [,<cBmp2>[,<cBmp3>[,<cBmp4>] ] ] ] ;
                             [ ACTION <uAction> ] ;
                             [ <lNoGrad: NOGRAD> ];
       =>;
          <oRibbon>:QuickRoundBtn( <cBmp1>, [<cBmp2>], [<cBmp3>], [<cBmp4>],;
                                                 [{|Self|<uAction>}], !<.lNoGrad.> )
                             
#xcommand DEFINE QUICKACCESS [<oQuickAcc>] [ <of: OF, RIBBON> <oRibbon> ] ;
                             [ LEFTMARGIN <nLeftMargin> ];
                             [ <lNoGrad: NOGRAD> ];
       =>;
          [ <oQuickAcc> := ] <oRibbon>:QuickAccess( <nLeftMargin>, !<.lNoGrad.> )
          

#xcommand ADD BUTTON [ <oBtn> ] [ QUICKACCESS <oQuickAcc> ];
                                [ BITMAP <cBitmap> ] ;
                                [ ACTION <uAction> ] ;
                                [ WHEN <WhenFunc> ] ;
       =>;
          [ <oBtn> := ] <oQuickAcc>:AddButton( <cBitmap>, [{|Self|<uAction>}], ;
                        <{WhenFunc}> )

#endif

