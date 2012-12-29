/*
ÚÄ Programa ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³   Aplication: Header file for class TLabel                               ³
³         File: LABEL.CH                                                   ³
³       Author: Manuel Calero Solis                                        ³
³       Telef.: (959) 40.23.83                                             ³
³         Date: 16/05/95                                                   ³
³         Time: 20:20:07                                                   ³
³    Copyright: 1995 by Manuel Calero Solis                                ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

#ifndef RPT_LEFT
	#define RPT_LEFT        1
#endif

#ifndef RPT_RIGHT
	#define RPT_RIGHT       2
#endif

#ifndef RPT_CENTER
	#define RPT_CENTER      3
#endif

#ifndef RPT_TOP
	#define RPT_TOP         4
#endif

#ifndef RPT_BOTTOM
	#define RPT_BOTTOM      5
#endif

#ifndef RPT_INCHES
	#define RPT_INCHES      1
#endif

#ifndef RPT_CMETERS
	#define RPT_CMETERS     2
#endif

#ifndef RPT_MMETERS
	#define RPT_MMETERS     3
#endif

#ifndef RPT_PIXELS
	#define RPT_PIXELS      4
#endif

#ifndef RPT_NOLINE
	#define RPT_NOLINE      0
#endif

#ifndef RPT_SINGLELINE
	#define RPT_SINGLELINE  1
#endif

#ifndef RPT_DOUBLELINE
	#define RPT_DOUBLELINE  2
#endif

#xcommand LABEL  [ <oLabel> ] ;
					  [ SIZE <nLblWidth>, <nLblHeight> ] ;
					  [ SEPARATORS <nHSeparator>, <nVSeparator> ] ;
					  [ ON LINE <nLblOnLine> ] ;
					  [ FONT <aFont, ...> ]  ;
					  [ PEN <aPen, ...> ]  ;
					  [ <file: FILE, FILENAME, DISK> <cLblFile> ] ;
					  [ <resource: NAME, RESNAME, RESOURCE> <cResName> ] ;
					  [ <toPrint: TO PRINTER> ] ;
					  [ <toScreen: PREVIEW> ] ;
					  [ TO FILE <(toFile)> ] ;
					  [ TO DEVICE <oDevice> ] ;
					  [ CAPTION <cName> ] ;
					  [ <lNoEnd: NO END> ] ;
	  => ;
	  [ <oLabel> := ] LblBegin( <nLblWidth>, <nLblHeight>, <nHSeparator>, ;
					  <nVSeparator>, <nLblOnLine>, {<aFont>}, {<aPen>}, ;
					  <cLblFile>, <cResName>, <.toPrint.>, ;
					  <.toScreen.>, <toFile>, <oDevice>, <cName>, <.lNoEnd.> )

#xcommand LBLITEM [ <oLblFld> ] ;
					 [ AT <nCol> ] ;
					 [ DATA <bData, ...> ] ;
					 [ SIZE <nSize> ] ;
					 [ PICTURE <cPicture, ...> ] ;
					 [ FONT <uFont> ] ;
					 [ <cFmt:LEFT,CENTER,CENTERED,RIGHT> ] ;
					 [ <lShadow:SHADOW> ] ;
					 [ <lGrid:GRID> [ <nPen> ] ] ;
		  => ;
		  [ <oLblFld> := ] LblAddItem( <nCol>, {<{bData}>}, <nSize>,;
					 {<cPicture>}, <{uFont}>, <nPen>, ;
					 [UPPER(<(cFmt)>)], <.lShadow.>, <.lGrid.> )

#xcommand LBLOITEM [ <oLblFld> ] ;
					 [ AT <nCol> ] ;
					 [ DATA <bData, ...> ] ;
					 [ SIZE <nSize> ] ;
					 [ PICTURE <cPicture, ...> ] ;
					 [ FONT <uFont> ] ;
                                         [ <lGrid:GRID> [ <nPen> ] ] ;
                                         [ <cFmt:LEFT,CENTER,CENTERED,RIGHT> ] ;
					 [ <lShadow:SHADOW> ] ;
                                         [ <lEan13:EAN13> ] ;
					 [ <lHorz:HORZ> ] ;
					 [ <lBanner:BANNER> ] ;
                                         [ COLOR <nRgbColor> ] ;
		  => ;
		  [ <oLblFld> := ] LblAddoItem( <nCol>, {<{bData}>}, <nSize>,;
					 {<cPicture>}, <{uFont}>, <nPen>, ;
					 [UPPER(<(cFmt)>)], <.lShadow.>, <.lGrid.>, <.lEan13.>,;
					 <.lHorz.>, <.lBanner.>, <nRgbColor> )

#xcommand ACTIVATE LABEL <oLabel> ;
					 [ FOR <for> ] ;
					 [ WHILE <while> ] ;
					 [ ON INIT <uInit> ] ;
					 [ ON END <uEnd> ] ;
					 [ ON STARTPAGE <uStartPage> ] ;
					 [ ON ENDPAGE <uEndPage> ] ;
					 [ ON STARTLINE <uStartLine> ] ;
                [ ON ENDLINE <uEndLine> ] ;
					 [ ON STARTLABEL <uStartLabel> ] ;
					 [ ON ENDLABEL <uEndLabel> ] ;
					 [ ON CHANGE <bChange> ] ;
		  => ;
			<oLabel>:Activate(<{for}>, <{while}>, <{uInit}>, <{uEnd}>, ;
					 <{uStartPage}>, <{uEndPage}>, ;
					 <{uStartLabel}>, <{uEndLabel}>,;
					 <{uStartLine}>, <{uEndLine}>, <{bChange}> )

#xcommand END LABEL ;
		 => ;
                 LblEnd()

#xcommand ENDLABEL ;
		 => ;
                 END LABEL

// EOF