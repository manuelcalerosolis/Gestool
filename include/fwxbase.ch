// XBPP

#ifndef _FWXBASE_CH
#define _FWXBASE_CH

#define Alert    _Alert
#define MemoEdit _MemoEdit

#define HIDDEN
#define PROTECTED

#xcommand MENU [ <oObjMenu> ] POPUP => [ <oObjMenu> := ] MenuBegin( .t. )

#xcommand REDEFINE RADIO [ <oRadMenu> VAR ] <nVar> ;
             [ ID <nId,...> ] ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <help:HELPID, HELP ID> <nHelpId,...> ] ;
             [ ON CHANGE <uChange> ] ;
             [ COLOR <nClrFore> [,<nClrBack>] ] ;
             [ MESSAGE <cMsg> ] ;
             [ <update: UPDATE> ] ;
             [ WHEN <uWhen> ] ;
             [ VALID <uValid> ] ;
       => ;
          [ <oRadMenu> := ] TRadMenu():Redefine( [bSETGET(<nVar>)],;
             <oWnd>, [{<nHelpId>}], \{ <nId> \}, <{uChange}>, <nClrFore>,;
             <nClrBack>, <cMsg>, <.update.>, <{uWhen}>, <{uValid}> )

#xtranslate = <cls: TIcon, TButton, TCheckBox, TComboBox, TListBox,;
                  TMetaFile, TWBrowse, TCBrowse, TRadMenu, TBitmap,;
                  TFolder, TGet, TScrollBar, TMultiGet, TGroup,;
                  TMeter, TPages, TPanel, TReg32, TSocket, TSay, TSmtp, TTabs,;
                  TTxtEdit, TBtnBmp, TSplitter, TDatePick, TRichEdit, TGraph>():<met: Accept, Define, NewBar, Redefine, WinNew>( <params,...> ) => ;
            = <cls>():New():<met>( <params> )

#xtranslate := <cls: TIcon, TBrush, TButton, TCheckBox, TComboBox, TListBox,;
                  TMetaFile, TWBrowse, TCBrowse, TRadMenu, TBitmap, TFGet,;
                  TFolder, TFont, TGet, TIconGroup, TScrollBar, TMultiGet, TGroup,;
                  TMeter, TMsgItem, TPages, TProgress, TPanel, TSocket, TSay, TTabs,;
                  TTxtEdit, TBtnBmp, TSelector, TReg32, TSlider, TSocket, TSmtp, TSplitter,;
                  TStruct, TTabCtrl, TDatePick, TRichEdit, TGraph>():New( <params,...> ) => ;
            := <cls>():New():_New( <params> )

#xtranslate TBitmap():<met: Redefine, Define>( <params,...> ) => ;
          TBitmap():New():<met>( <params> )

#xtranslate TBitmap():Define( <params,...> ) => ;
          TBitmap():New():Define( <params> )

#xtranslate TBrush():New( <params,...> ) => ;
          TBrush():New():_New( <params> )

#xtranslate TBtnBmp():New( <params,...> ) => ;
          TBtnBmp():New():_New( <params> )

#xtranslate TBtnBmp():New( <params,...> ) => ;
            TBtnBmp():New():_New( <params> )

#xtranslate TBtnBmp():Redefine( <params,...> ) => ;
          TBtnBmp():New():Redefine( <params> )

#xtranslate TBtnBmp():NewBar( <params,...> ) => ;
          TBtnBmp():New():NewBar( <params> )

#xcommand TButton():New( <params,...> ) => ;
          TButton():New():_New( <params> )

#xtranslate TButton():New( <params,...> ) => ;
          TButton():New():_New( <params> )

#xtranslate TButton():<met: NewBar, Redefine>( <params,...> ) => ;
          TButton():New():<met>( <params> )

#xcommand TButtonBmp():New( <params,...> ) => ;
          TButtonBmp():New():_New( <params> )

#xtranslate TButtonBmp():New( <params,...> ) => ;
          TButtonBmp():New():_New( <params> )

#xtranslate TButtonBmp():<met: NewBar, Redefine>( <params,...> ) => ;
          TButtonBmp():New():<met>( <params> )

#xtranslate TCBrowse():Redefine( <params,...> ) => ;
          TCBrowse():New():Redefine( <params> )

#xcommand TCheckBox():New( <params,...> ) => ;
          TCheckBox():New():_New( <params> )

#xtranslate TCheckBox():New( <params,...> ) => ;
          TCheckBox():New():_New( <params> )

#xtranslate TCheckBox():Redefine( <params,...> ) => ;
          TCheckBox():New():Redefine( <params> )

#xtranslate TComboBox():New( <params,...> ) => ;
          TComboBox():New():_New( <params> )

#xtranslate TComboBox():Redefine( <params,...> ) => ;
          TComboBox():New():Redefine( <params> )

#xtranslate TDatePick():New( <params,...> ) => ;
          TDatePick():New():_New( <params> )

#xtranslate TDatePick():Redefine( <params,...> ) => ;
          TDatePick():New():Redefine( <params> )

#xtranslate TDialog():Redefine( <params,...> ) => ;
          TDialog():New():Redefine( <params> )

#xtranslate TFGet():Redefine( <params,...> ) => ;
          TFGet():New():Redefine( <params> )

#xtranslate TFolder():Redefine( <params,...> ) => ;
          TFolder():New():Redefine( <params> )

#xcommand TGet():New( <params,...> ) => ;
          TGet():New():_New( <params> )

#xtranslate TGet():New( <params,...> ) => ;
          TGet():New():_New( <params> )

#xcommand TGet():Redefine( <params,...> ) => ;
          TGet():New():Redefine( <params> )

#xtranslate TGet():Redefine( <params,...> ) => ;
          TGet():New():Redefine( <params> )

#xcommand TGraph():New( <params,...> ) => ;
          TGraph():New():_New( <params> )

#xtranslate TGraph():New( <params,...> ) => ;
          TGraph():New():_New( <params> )

#xtranslate TGraph():Redefine( <params,...> ) => ;
          TGraph():New():Redefine( <params> )

#xtranslate TGroup():New( <params,...> ) => ;
          TGroup():New():_New( <params> )

#xtranslate TGroup():Redefine( <params,...> ) => ;
          TGroup():New():Redefine( <params> )

#xtranslate THeader():New( <params,...> ) => ;
          THeader():New():_New( <params> )

#xtranslate THeader():Redefine( <params,...> ) => ;
          THeader():New():Redefine( <params> )

#xtranslate TIcon():Redefine( <params,...> ) => ;
          TIcon():New():Redefine( <params> )

#xtranslate TIconGroup():Redefine( <params,...> ) => ;
          TIconGroup():New():Redefine( <params> )

#xtranslate TImage():New( <params,...> ) => ;
          TImage():New():_New( <params> )

#xtranslate TImage():Redefine( <params,...> ) => ;
          TImage():New():Redefine( <params> )

#xtranslate TListBox():New( <params,...> ) => ;
          TListBox():New():_New( <params> )

#xtranslate TListBox():Redefine( <params,...> ) => ;
          TListBox():New():Redefine( <params> )

#xtranslate TListView():Redefine( <params,...> ) => ;
          TListView():New():Redefine( <params> )

#xtranslate TMenu():NewSys( <params,...> ) => ;
          TMenu():New():_NewSys( <params> )

#xtranslate TMenu():New( <params,...> ) => ;
          TMenu():New():_New( <params> )

#xtranslate TMenu():Redefine( <params,...> ) => ;
          TMenu():New():Redefine( <params> )

#xtranslate TMenuItem():New() => ;
          TMenuItem():New():_New()

#xtranslate TMenuItem():New( <params,...> ) => ;
          TMenuItem():New():_New( <params> )

#xtranslate TMenuItem():Redefine( <params,...> ) => ;
          TMenuItem():New():Redefine( <params> )

#xtranslate TMeter():New( <params,...> ) => ;
          TMeter():New():_New( <params> )

#xtranslate TMeter():Redefine( <params,...> ) => ;
          TMeter():New():Redefine( <params> )

#xtranslate TMsgItem():New( <params,...> ) => ;
          TMsgItem():New():_New( <params> )

#xcommand TMsgItem():New( <params,...> ) => ;
          TMsgItem():New():_New( <params> )

#xcommand TMultiGet():New( <params,...> ) => ;
          TMultiGet():New():_New( <params> )

#xtranslate TMultiGet():New( <params,...> ) => ;
          TMultiGet():New():_New( <params> )

#xcommand TMultiGet():Redefine( <params,...> ) => ;
          TMultiGet():New():Redefine( <params> )

#xtranslate TMultiGet():Redefine( <params,...> ) => ;
          TMultiGet():New():Redefine( <params> )

#xtranslate TPages():Redefine( <params,...> ) => ;
          TPages():New():Redefine( <params> )

#xcommand TPanel():New( <params,...> ) => ;
          TPanel():New():_New( <params> )

#xtranslate TProgress():Redefine( <params,...> ) => ;
          TProgress():New():Redefine( <params> )

#xtranslate TRadio():Redefine( <params,...> ) => ;
          TRadio():New():Redefine( <params> )

#xtranslate TRadio():Redefine( <params,...> ) => ;
            TRadio():New():Redefine( <params> )

#xtranslate TRadMenu():New( <params,...> ) => ;
          TRadMenu():New():_New( <params> )

#xtranslate TRadMenu():Redefine( <params,...> ) => ;
          TRadMenu():New():Redefine( <params> )

#xtranslate TRadMenu():Redefine( <params,...> ) => ;
            TRadMenu():New():Redefine( <params> )

#xtranslate TReg32():New( <params,...> ) => ;
            TReg32():New():_New( <params> )

#xtranslate TReg32():Create( <params,...> ) => ;
            TReg32():New():Create( <params> )

#xtranslate TReport():New( <params,...> ) => ;
            TReport():New():_New( <params> )

#xtranslate TRichEdit():New( <params,...> ) => ;
          TRichEdit():New():_New( <params> )

#xcommand TRichEdit():Redefine( <params,...> ) => ;
          TRichEdit():New():Redefine( <params> )

#xtranslate TRichEdit():Redefine( <params,...> ) => ;
          TRichEdit():New():Redefine( <params> )

#xcommand TSay():New( <params,...> ) => ;
          TSay():New():_New( <params> )

#xtranslate TSay():New( <params,...> ) => ;
          TSay():New():_New( <params> )

#xtranslate TSay():Redefine( <params,...> ) => ;
          TSay():New():Redefine( <params> )

#xtranslate TScrollBar():New( <params,...> ) => ;
          TScrollBar():New():_New( <params> )

#xcommand TScrollBar():New( <params,...> ) => ;
          TScrollBar():New():_New( <params> )

#xtranslate TScrollBar():Redefine( <params,...> ) => ;
          TScrollBar():New():Redefine( <params> )

#xtranslate TScrollBar():WinNew( <params,...> ) => ;
          TScrollBar():New():WinNew( <params> )

#xtranslate TSelector():Redefine( <params,...> ) => ;
          TSelector():New():Redefine( <params> )

#xtranslate TSlider():Redefine( <params,...> ) => ;
          TSlider():New():Redefine( <params> )

#xtranslate TSocket():Accept( <params,...> ) => ;
          TSocket():New():Accept( <params> )

#xtranslate TSplitter():Redefine( <params,...> ) => ;
          TSplitter():New():Redefine( <params> )

#xcommand TStruct():Create( <params,...> ) => ;
          TStruct():New():Create( <params> )

#xcommand TStruct():New( <params,...> ) => ;
          TStruct():New():_New( <params> )

#xtranslate TTabControl():Redefine( <params,...> ) => ;
          TTabControl():New():Redefine( <params> )

#xtranslate TTabs():Redefine( <params,...> ) => ;
          TTabs():New():Redefine( <params> )

#xtranslate TWBrowse():Redefine( <params,...> ) => ;
          TWBrowse():New():Redefine( <params> )

#xtranslate TCBrowse():Redefine( <params,...> ) => ;
          TCBrowse():New():Redefine( <params> )

#endif
