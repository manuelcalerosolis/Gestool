#ifndef _PRINT_CH
#define _PRINT_CH

//----------------------------------------------------------------------------//
// Printer

#xcommand PRINT [ <oPrint> ] ;
             [ <name: NAME, TITLE,DOC> <cDocument> ] ;
             [ <user: FROM USER> ] ;
             [ <prvw: PREVIEW> [<lmodal: MODAL>] ] ;
             [ TO  <xModel> ] ;
             [ <sele: SELECTION> ] ;
             [ FILE <cFile> ] ;
       => ;
      [ <oPrint> := ] PrintBegin( [<cDocument>], <.user.>, <.prvw.>, <xModel>, ;
                                  <.lmodal.>, <.sele.>, <cFile> )

#xcommand PRINTER [ <oPrint> ] ;
             [ <name: NAME, DOC> <cDocument> ] ;
             [ <user: FROM USER> ] ;
             [ <prvw: PREVIEW> [<lmodal: MODAL>] ] ;
             [ TO  <xModel> ] ;
             [ <sele: SELECTION> ] ;
             [ FILE <cFile> ] ;
       => ;
      [ <oPrint> := ] PrintBegin( [<cDocument>], <.user.>, <.prvw.>, <xModel>, ;
                                  <.lmodal.>, <.sele.>, <cFile> )

#xcommand PAGE => PageBegin()

#xcommand ENDPAGE => PageEnd()

#xcommand ENDPRINT   => PrintEnd()
#xcommand ENDPRINTER => PrintEnd()

//----------------------------------------------------------------------------//

#endif
