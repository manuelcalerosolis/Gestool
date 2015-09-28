#ifndef _MENU_CH
#define _MENU_CH

//----------------------------------------------------------------------------//
// Creating PullDown Menus from source code

#xcommand MENU [ <oObjMenu> ] ;
             [ <popup: POPUP> ] ;
             [ <l2007: 2007, _2007> ] ;
             [ <l2010: 2010, _2010> ];
       => ;
          [ <oObjMenu> := ] MenuBegin( <.popup.>,,, <.l2007.>, <.l2010.> )

#xcommand MENUITEM [ <oMenuItem> PROMPT ] [<cPrompt>] ;
             [ MESSAGE <cMsg> ] ;
             [ <checked: CHECK, CHECKED, MARK> ] ;
             [ <enable: ENABLED, DISABLED> ] ;
             [ <file: FILE, FILENAME, DISK> <cBmpFile> ] ;
             [ <resource: RESOURCE, RESNAME, NAME> <cResName> ] ;
             [ ACTION <uAction,...> ] ;
             [ BLOCK <bAction> ] ;
             [ <of: OF, MENU, SYSMENU> <oMenu> ] ;
             [ ACCELERATOR <nState>, <nVirtKey> ] ;
             [ <help: HELP> ] ;
             [ <HelpId: HELP ID, HELPID> <nHelpId> ] ;
             [ WHEN <uWhen> ] ;
             [ <break: BREAK> ] ;
       => ;
          [ <oMenuItem> := ] MenuAddItem( <cPrompt>, <cMsg>,;
             <.checked.>, [ Upper(<(enable)>) == "ENABLED" ],;
             [\{|oMenuItem|<uAction>\}],;
             <cBmpFile>, <cResName>, <oMenu>, <bAction>, <nState>, <nVirtKey>,;
             <.help.>, <nHelpId>, [<{uWhen}>], <.break.> )

// New MRU technology in FiveWin. See SAMPLES\TestMru.prg !!!

#xcommand MRU <oMru> ;
             [ <Ini: INI, ININAME, FILENAME, NAME, DISK> <cIniFile> ] ;
             [ SECTION <cSection> ] ;
             [ <size: SIZE, ITEMS> <nItems> ] ;
             [ MESSAGE <cMsg> ] ;
             [ ACTION <uAction> ] ;
       => ;
          <oMru> := TMru():New( <cIniFile>, <cSection>, <nItems>, <cMsg>,;
             [{|cMruItem,oMenuItem|<uAction>}] )

#xcommand SEPARATOR [<oMenuItem>] => [<oMenuItem>:=] MenuAddItem()

#xcommand ENDMENU => MenuEnd()

//----------------------------------------------------------------------------//
// Creating PullDown Menus from resources

#xcommand DEFINE MENU <oMenu> ;
             [ <res: RESOURCE, NAME, RESNAME> <cResName> ] ;
             [ <popup: POPUP> ] ;
       => ;
          <oMenu> := TMenu():ReDefine( <cResName>, <.popup.> )

#xcommand REDEFINE MENUITEM [ <oMenuItem> PROMPT ] [<cPrompt>] ;
             [ ID <nId> <of: OF, MENU> <oMenu> ] ;
             [ ACTION <uAction> ] ;
             [ BLOCK  <bAction> ] ;
             [ MESSAGE <cMsg> ] ;
             [ <checked: CHECK, CHECKED, MARK> ] ;
             [ <enable: ENABLED, DISABLED> ] ;
             [ <file: FILE, FILENAME, DISK> <cBmpFile> ] ;
             [ <resource: RESOURCE, RESNAME, NAME> <cResName> ] ;
             [ ACCELERATOR <nState>, <nVirtKey> ] ;
             [ <HelpId: HELP ID, HELPID> <nHelpId> ] ;
             [ WHEN <uWhen> ] ;
       => ;
          [ <oMenuItem> := ] TMenuItem():ReDefine( <cPrompt>, <cMsg>,;
             <.checked.>, [ Upper(<(enable)>) == "ENABLED" ], <{uAction}>,;
             <cBmpFile>, <cResName>, <oMenu>, <bAction>, <nId>,;
             <nState>, <nVirtKey>, <nHelpId>, [<{uWhen}>] )

//----------------------------------------------------------------------------//

#xcommand DEFINE MENU <oMenu> OF <oWnd> ;
       => ;
          <oMenu> := TMenu():New( .f., <oWnd> )

#xcommand SET MENU OF <oWnd> TO <oMenu> => <oWnd>:SetMenu( <oMenu> )

//----------------------------------------------------------------------------//
// PopUps Management

#xcommand ACTIVATE <menu:POPUP,MENU> <oMenu> ;
             [ AT <nRow>, <nCol> ] ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ FLAGS <nFlags> ] ;
             [ <save: SAVE> ] ;
       => ;
          <oMenu>:Activate( <nRow>, <nCol>, <oWnd>, ! <.save.>, <nFlags> )

//----------------------------------------------------------------------------//
// Using Window System Menu

#xcommand REDEFINE SYSMENU [<oMenu>] ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
       => ;
          [<oMenu> :=] MenuBegin( .f., .t., <oWnd> )

#xcommand ENDSYSMENU => MenuEnd()

//----------------------------------------------------------------------------//

#endif
