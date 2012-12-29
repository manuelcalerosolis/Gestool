/*
  Copyright 1999 Jos‚ Lal¡n Ferreiro <dezac@corevia.com>

  -[Historial]---------------------------------------------------------
  Fecha         Autor               Cambios
  ---------------------------------------------------------------------
  Nov  9, 1999    Jos‚ Lal¡n          + Primera versi¢n
  Nov  5, 2000    Jos‚ Lal¡n          + Agregados nTabClr, nFocusClr
                                      - Eliminado lWin95Look
  Nov 13, 2000    Jos‚ Lal¡n          + Agregada MESSAGE en Redefine
*/
//--------------------------------------------------------------------------//
#ifndef _FOLDERBMP_CH
#define _FOLDERBMP_CH

#xcommand @ <nRow>, <nCol> FOLDER [<oFolder>] ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <prm: PROMPT, PROMPTS, ITEMS> <cPrompt,...> ] ;
             [ BITMAPS <cBmps,...> ] ;
             [ <dlg: DIALOG, DIALOGS, PAGE, PAGES> <cDlgName1> [,<cDlgNameN>] ] ;
             [ <lPixel: PIXEL> ] ;
             [ <lDesign: DESIGN> ] ;
             [ <color: COLOR, COLORS> <nClrFore> [,<nClrBack>] ] ;
             [ OPTION <nOption> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ MESSAGE <cMsg> ] ;
             [ <lAdjust: ADJUST> ] ;
             [ FONT <oFont> ] ;
             [ STYLE <cDir: TOP, BOTTOM> ] ;
             [ TABCOLOR <nTabClr> ] ;
             [ FOCUSCOLOR <nFocusClr> ] ;
             [ ALIGN <cAlign: LEFT, CENTER, RIGHT> ] ;
       => ;
          [<oFolder> := ] TFolder():New( <nRow>, <nCol>,;
             [\{<cPrompt>\}], \{<cDlgName1> [,<cDlgNameN>]\},;
             <oWnd>, <nOption>, <nClrFore>, <nClrBack>, <.lPixel.>,;
             <.lDesign.>, <nWidth>, <nHeight>, <cMsg>, <.lAdjust.>,;
             <oFont>, [\{<cBmps>\}], <"cDir">, <nTabClr>, <nFocusClr>, ;
             <"cAlign"> )

#xcommand REDEFINE FOLDER [<oFolder>] ;
             [ ID <nId> ] ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <prm: PROMPT, PROMPTS, ITEMS> <cPrompt,...> ] ;
             [ BITMAPS <cBmps,...> ] ;
             [ <dlg: DIALOG, DIALOGS, PAGE, PAGES> <cDlgName1> [,<cDlgNameN>] ] ;
             [ <color: COLOR, COLORS> <nClrFore> [,<nClrBack>] ] ;
             [ OPTION <nOption> ] ;
             [ ON CHANGE <uChange> ] ;
             [ <lAdjust: ADJUST> ] ;
             [ STYLE <cDir: TOP, BOTTOM> ] ;
             [ TABCOLOR <nTabClr> ] ;
             [ FOCUSCOLOR <nFocusClr> ] ;
             [ ALIGN <cAlign: LEFT, RIGHT, CENTER> ] ;
       => ;
          [<oFolder> := ] TFolder():ReDefine( <nId>, [\{<cPrompt>\}],;
             \{ <cDlgName1> [,<cDlgNameN>] \}, <oWnd>,;
             <nOption>, <nClrFore>, <nClrBack>,;
             [{|nOption,nOldOption| <uChange>}], <.lAdjust.>, ;
             [\{<cBmps>\}], <"cDir">, <nTabClr>, <nFocusClr>, ;
             <"cAlign"> )

#endif  // _FOLDERBMP_CH
//--------------------------------------------------------------------------//
