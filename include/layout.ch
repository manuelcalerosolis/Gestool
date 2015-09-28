#ifndef _LAYOUT_CH
#define _LAYOUT_CH
#xcommand DEFINE LAYOUT <oLayout> <of:OF, WINDOW, DIALOG, LAYOUT> <oDlg> ;
    => ;
    <oLayout> := TLayout():new(<oDlg>) 

#xcommand DEFINE VERTICAL LAYOUT [<oLayout>] OF <oMainLay> [ SIZE <nSize> ]  ;
    => ;
    [<oLayout> :=] <oMainLay>:addVLayout([<nSize>]) 

#xcommand DEFINE HORIZONTAL LAYOUT  [<oLayout>] OF <oMainLay> [ SIZE <nSize> ]  ;
    => ;
    [<oLayout> :=] <oMainLay>:addHLayout([<nSize>]) 

#xcommand SET LAYOUT CONTROL <oControl> OF <oLayout>;
    =>;
    <oLayout>:oClient := <oControl>
#endif