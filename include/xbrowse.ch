// TXBrowse & TXBrwColumn header file

#ifndef __XBROWSE_CH
#define __XBROWSE_CH

#define AL_LEFT               0
#define AL_RIGHT              1
#define AL_CENTER             2

#define LINESTYLE_NOLINES     0
#define LINESTYLE_BLACK       1
#define LINESTYLE_DARKGRAY    2
#define LINESTYLE_FORECOLOR   3
#define LINESTYLE_LIGHTGRAY   4
#define LINESTYLE_INSET       5
#define LINESTYLE_RAISED      6

#define MARQSTYLE_NOMARQUEE   0
#define MARQSTYLE_DOTEDCELL   1
#define MARQSTYLE_SOLIDCELL   2
#define MARQSTYLE_HIGHLCELL   3
#define MARQSTYLE_HIGHLROWRC  4
#define MARQSTYLE_HIGHLROW    5
#define MARQSTYLE_HIGHLROWMS  6
#define MARQSTYLE_HIGHLWIN7   7

#define EDIT_NONE             0
#define EDIT_GET              1
#define EDIT_LISTBOX          2
#define EDIT_BUTTON           3
#define EDIT_GET_LISTBOX      4
#define EDIT_GET_BUTTON       5
#define EDIT_DATE             6
#define EDIT_TIME             7
#define TYPE_IMAGE           -1

#define STRETCHCOL_NONE	      nil
#define STRETCHCOL_LAST       -1
#define STRETCHCOL_WIDEST     -2

#define DATATYPE_RDD           1
#define DATATYPE_ARRAY         2
#define DATATYPE_ADO           4
#define DATATYPE_ODBF         16
#define DATATYPE_TREE         32
#define DATATYPE_MYSQL        64
#define DATATYPE_EXCEL       128
#define DATATYPE_USER       4096

// footer aggregate types
#define AGGR_TOTAL            1
#define AGGR_SUM              AGGR_TOTAL
#define AGGR_MIN              2
#define AGGR_MAX              4
#define AGGR_COUNT            8
#define AGGR_AVERAGE          AGGR_SUM + AGGR_COUNT
#define AGGR_STDEV            AGGR_SUM + AGGR_COUNT + 16
#define AGGR_STDEVP           AGGR_STDEV + 32
#define AGGR_AVG              AGGR_AVERAGE
#define AGGR_STD              AGGR_STDEV

#define MOVE_RIGHT            1
#define MOVE_LEFT             2
#define MOVE_UP               3
#define MOVE_DOWN             4
#define MOVE_NONE             5
#define MOVE_FAST_RIGHT       6
#define MOVE_FAST_LEFT        7

#define BCK_TILED             0
#define BCK_STRETCH           1
#define BCK_FILL              2

#define BUTTON_PRINT          1  // xbrowser function button
#define BUTTON_SHEET          2


#xcommand SET XBROWSE TO <bchild> [ SAVE PREVIOUS TO <bprev> ] => ;
	[<bprev> := ] SetXBrowse( If( ValType( <bchild> ) == 'B', <bchild>, <{bchild}> ) )

#xcommand @ <nRow>, <nCol> [ COLUMN ] XBROWSE  <oBrw>  ;
               [ [ FIELDS ] <Flds,...>] ;
               [ <dsrc: ALIAS, ARRAY, RECSET, RECORDSET, OBJECT, DATASOURCE> <uDataSrc> ] ;
               [ <sizes:FIELDSIZES, SIZES, COLSIZES> <aColSizes,...> ] ;
               [ <head:HEAD,HEADER,HEADERS> <aHeaders,...> ] ;
               [ <pic: PICS, PICTURE, PICTURES> <aPics,...> ] ;
               [ <cols: COLS, COLUMNS> <aCols,...> ] ;
               [ <idx: SORT,ORDERS> <aSort,...> ] ;
               [ JUSTIFY <aJust,...> ] ;
               [ SIZE <nWidth>, <nHeigth> ] ;
               [ ID <nID> ] ;
               [ <dlg:OF,DIALOG> <oWnd> ] ;
               [ SELECT <cField> FOR <uValue1> [ TO <uValue2> ] ] ;
               [ <change: ON CHANGE, ON CLICK> <uChange> ] ;
               [ ON [ LEFT ] DBLCLICK <uLDblClick> ] ;
               [ ON RIGHT CLICK <uRClick> ] ;
               [ FONT <oFont> ] ;
               [ CURSOR <oCursor> ] ;
               [ <color: COLOR, COLORS> <nClrFore> [,<nClrBack>] ] ;
               [ MESSAGE <cMsg> ] ;
               [ <update: UPDATE> ] ;
               [ <pixel: PIXEL> ] ;
               [ WHEN <uWhen> ] ;
               [ <design: DESIGN> ] ;
               [ VALID <uValid> ] ;
               [ <autosort: AUTOSORT> ] ;
               [ <autocols: AUTOCOLS> ] ;
               [ <footers: FOOTERS> ] ;
               [ <fasted: FASTEDIT> ] ;
               [ <lcell: CELL> ] [ <llines: LINES> ] ;
               [ ROWS <aRows> ] ;
               [ BACKGROUND <uBack> [ <bckmode: TILED, STRETCH, FILL, VERTICAL, HORIZONTAL> ] ] ;
               [ CLASS <child> ] [ <transp: TRANSPARENT> ] [ <noborder: NOBORDER> ] ;
      => ;
          <oBrw> := XbrowseNew( <oWnd>, <nRow>, <nCol>, <nWidth>, <nHeigth>,;
                           [ \{ <{Flds}> \} ], ;
                           [\{<aHeaders>\}], [\{<aColSizes>\}], ;
                           [<{uChange}>],;
                           [\{|nRow,nCol,nFlags|<uLDblClick>\}],;
                           [\{|nRow,nCol,nFlags|<uRClick>\}],;
                           <oFont>, <oCursor>, <nClrFore>, <nClrBack>, <cMsg>,;
                           <.update.>, <uDataSrc>, <{uWhen}>,;
                           <.design.>, <{uValid}>, <.pixel.>, [<nID>], <.autosort.>, <.autocols.> , ;
                           [\{<aPics>\}], [\{<aCols>\}],;
                           [\{<aJust>\}], [\{<aSort>\}], <.footers.>, <.fasted.>, ;
                           <.lcell.>, <.llines.>, <aRows>, <uBack>, [upper(<(bckmode)>)], ;
                           [ If( ValType( <child> ) == 'B', <child>, <{child}> ) ], <.transp.>, <.noborder.> )

#xcommand REDEFINE [ COLUMN ] XBROWSE  <oBrw> [<clauses,...>] ID <nID> [<moreClauses,...>] ;
      => @ 0,0 XBROWSE <oBrw> [<clauses>] ID <nID> [<moreClauses>]

#command ADD [ COLUMN ] [<oCol>] TO [ XBROWSE ] <oBrw> ;
            [ AT <nAt> ] ;
            [ <dat: DATA, SHOWBLOCK> <uData> ] ;
            [ <tit: TITLE, HEADER> <cHead> [ <oem: OEM, ANSI, CONVERT>] ];
            [ <clr: COLOR, COLORS, COLOURS> <uClrFore> [,<uClrBack>] ] ;
            [ ALIGN ] [ <al: LEFT, CENTERED, CENTER, RIGHT> ] ;
            [ <wid: WIDTH, SIZE> <nWidth> [ PIXELS ] ] ;
            [ <pict: PICT, PICTURE> <cPicture> ] ;
            [ <bit: BITMAP> [BMPDATA <uBmpData>] [ IN <aBmp,...> ] ] ;
            [ <edit: EDITABLE> ] ;
            [ ON EDIT <bOnPostEdit> ] ;
            [ MESSAGE <cMsg> ] ;
            [ WHEN <uWhen> ] ;
            [ VALID <uValid> ] ;
            [ ERROR [MSG] [MESSAGE] <cErr> ] ;
            [ <lite: NOBAR, NOHILITE> ] ;
            [ <idx: ORDER, INDEX, SORT, TAG> <cOrder> ] ;
            [ <hide: HIDE, HIDDEN> ] ;
            [ TOTAL <nTot> ] ;
            [ FOOTER <uFooter> ] ;
            [ CARGO <uCargo> ] ;
         => ;
            [<oCol> :=] <oBrw>:AddColumn( ;
            If(<.oem.>, OemToAnsi(<cHead>), <cHead>), ;
            [ If( ValType(<uData>)=="B", <uData>, <{uData}> ) ], <cPicture>, ;
            [<uClrFore>], [<uClrBack>], ;
            [ Upper( <(al)> ) ], <nWidth>, <.bit.>, ;
            <.edit.>, <bOnPostEdit>, <cMsg>, <{uWhen}>, <{uValid}>, <cErr>, ;
            <.lite.>, <(cOrder)>, <nAt>, <{uBmpData}>, [\{ <aBmp> \}], <.hide.>, ;
            <nTot>, [ If( ValType(<uFooter>)=="B", <uFooter>, <{uFooter}> ) ], [<uCargo>]  )

#command ADD [ COLUMN ] [<oCol>]  TO [ XBROWSE ] <oBrw> ;
            [ AT <nAt> ] ;
	    [ DATA ] ARRAY ;
            [ <el: ELM, ELEM, ELEMENT> <elm> ] ;
            [ <tit: TITLE, HEADER> <cHead> [ <oem: OEM, ANSI, CONVERT>] ];
            [ <clr: COLORS, COLOURS> <uClrFore> [,<uClrBack>] ] ;
            [ ALIGN ] [ <al: LEFT, CENTERED, RIGHT> ] ;
            [ <wid: WIDTH, SIZE> <nWidth> [ PIXELS ] ] ;
            [ <pict: PICT, PICTURE> <cPicture> ] ;
            [ <bit: BITMAP> [BMPDATA <nBmpElem>] [ IN <aBmp,...> ] ] ;
            [ <edit: EDITABLE> ] ;
            [ ON EDIT <bOnPostEdit> ] ;
            [ MESSAGE <cMsg> ] ;
            [ WHEN <uWhen> ] ;
            [ VALID <uValid> ] ;
            [ ERROR [MSG] [MESSAGE] <cErr> ] ;
            [ <lite: NOBAR, NOHILITE> ] ;
            [ <idx: ORDER, INDEX, SORT, TAG> <nOrder> ] ;
            [ <hide: HIDDEN> ] ;
            [ TOTAL <nTot> ] ;
            [ FOOTER <uFooter> ] ;
            [ CARGO <uCargo> ] ;
            => ;
            [<oCol> :=] <oBrw>:AddColumn( ;
            If(<.oem.>, OemToAnsi(<cHead>), <cHead>), ;
            <elm>, <cPicture>, ;
            [<uClrFore>], [<uClrBack>], ;
            [ Upper( <(al)> ) ], <nWidth>, <.bit.>, ;
            <.edit.>, <bOnPostEdit>, <cMsg>, <{uWhen}>, <{uValid}>, <cErr>,;
             <.lite.>, <nOrder>, <nAt>, <nBmpElem>, [\{ <aBmp> \}], <.hide.>,, ;
            <nTot>, [ If( ValType(<uFooter>)=="B", <uFooter>, <{uFooter}> ) ], [<uCargo>]  )


#xcommand XBROWSER [<uData>] ;
      [ TITLE <cTitle> ] ;
      [ <autosort:AUTOSORT> ] ;
      [ SETUP <fnSetUp> ] ;
      [ COLUMNS <aCols,...> ] ;
      [ SELECT <fnSelect> ] ;
      [ <excel: CALC> ];
      [ <fastedit: FASTEDIT> ];
      => ;
      XBrowse( [<uData>], [<cTitle>], [<.autosort.>], ;
         [\{|oBrw|<fnSetUp>\}], [\{<aCols>\}], ;
         [\{|oBrw,oCol|<fnSelect>\}],!<.excel.>, <.fastedit.> )


#xcommand XBREPORT <oXbr> [<clauses,...>] ;
      [TITLE <cTitle>] [BRWSETUP <bBrwSetup>] [REPSETUP <bRepSetup>] ;
      => ;
      @ 0,0 XBROWSE <oXbr> [<clauses>] ;;
      Eval( IfNil( <{bBrwSetup}>, {||nil} ), <oXbr> );;
      <oXbr>:CreateFromCode();<oXbr>:Report( [<cTitle>],,,<{bRepSetup}> );;
      <oXbr>:oWnd:End()

#ifdef ADS_NTX
   REQUEST ADSKEYCOUNT, ADSGETRELKEYPOS, ADSSETRELKEYPOS
#endif

#endif
