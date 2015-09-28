#define FWGIF_LOOPING          1
#define FWGIF_CURRENTLOOP      2
#define FWGIF_IMAGES           3
#define FWGIF_WIDTH            4
#define FWGIF_HEIGHT           5
#define FWGIF_SIZINGTYPE       6

#define FWGIF_SIZING_FILE      0
#define FWGIF_SIZING_CLIP      1
#define FWGIF_SIZING_STRETCH   2


#xcommand @ <nRow>, <nCol> GIF [<oGif>] ;
             [ <file: FILE, FILENAME, DISK> <cGifFile> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ ACTION <uAction,...> ] ;
             [ <of:OF, WINDOW, DIALOG> <oWnd> ] ;
             [ MESSAGE <cMsg> ] ;
             [ <adjust: ADJUST> ] ;
             [ CURSOR <oCursor> ] ;
      => ;
         [ <oGif> := ] TGif():New( <oWnd>, <cGifFile>, <nRow>, <nCol>,;
                                   <nHeight>, <nWidth>, <oCursor>, <.adjust.>, [{|Self|<uAction>}] )
