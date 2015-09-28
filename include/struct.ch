// FiveWin C language structures support commmands

#ifndef _C_STRUCT
#define _C_STRUCT

#xcommand STRUCT <oStruct> => <oStruct> := ThisStruct( TStruct():New() )

#xcommand MEMBER <cName> AS <type> ;
             [ LEN <nLen> ] ;
             [ INIT <uValue> ] ;
       => ;
          ThisStruct():AddMember( <(cName)>, <type>, <nLen> ) ;
        [ ; ThisStruct():SetMember( Len( ThisStruct():aMembers ), <uValue> ) ]

#xcommand ENDSTRUCT => ThisStruct( nil )

#endif