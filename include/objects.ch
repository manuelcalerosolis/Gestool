#ifndef _OBJECTS_CH
#define _OBJECTS_CH

#ifndef __CLIPPER__
   #include <hbclass.ch>
#else

#ifndef __XPP__

#define _FuncType_

#xcommand DEFAULT <Desc> [, <DescN> ]      => ;
                  __DFT__( <Desc> ) [ ; __DFT__( <DescN> ) ]

#xtranslate __DFT__( <Var> := <Dft> ) => ;
            if( <Var> == nil, <Var> := <Dft>, )

#xtranslate __DFT__( <Var> = <Dft> )  => ;
            __DFT__( <Var> := <Dft> )

#xtranslate BYNAME <V> [, <VN> ]     => ::<V> := <V> [; ::<VN> := <VN> ]
#xtranslate BYNAME <V> DEFAULT <Val> => ::<V> := BYDEFAULT <V>, <Val>
#xtranslate BYNAME <V> IFNONIL       => ;
                            if <V> != NIL ;;
                                ::<V> := <V> ;;
                            end
#xtranslate BYDEFAULT <V>, <Val>     => if( <V> == NIL, <Val>, <V> )

#xcommand CLASS <ClsNam>   ;
            [ <from: INHERIT FROM, INHERIT, FROM, OF> <SupCls> [, <MoreSuper> ] ] ;
    => ;
          function _AsFunc_( <ClsNam> )  ;;
             static nClassH              ;;
             if nClassH == nil           ;;
                nClassH = _ObjNewCls( _AsStr_( <ClsNam> ) [, _AsFunc_( <SupCls> ) ] [, \{|| _AsFunc_( <MoreSuper> ) \} ] ) ;
                [ ; #define _sUPcLS_ _AsName_( <SupCls> ) ]

#xtranslate CREATE CLASS <*ClsHead*> =>  CLASS <ClsHead>

#xcommand _GEN_DATA_ <vt>, <Vrs,...> [ AS <Typ,...> ]   ;
         [ <scp: PUBLIC, EXPORT, READONLY, PROTECTED, LOCAL, HIDDEN> ] ;
         [ <dft: DEFAULT, INIT> <uData> ]   ;
         [ USER DATA <uUserData> ] ;
         =>  ;
         _ObjAddMet( nClassH, __SCOPE__ [ <scp> ], [ \{ _AsUppLst_( <Typ> ) \} ] ,;
                    <vt>, [ <uData> ], _AsStrLst_( <Vrs> ) ) ;
         [ ; ObjSetUserData( nClassH, <uUserData>, _AsStrLst_( <Vrs> ) ) ]

#xcommand _GEN_DATA_ <vt>, <Vrs,...> [ AS <Typ,...> ]   ;
         [ <scp: PUBLIC, EXPORT, READONLY, PROTECTED, LOCAL, HIDDEN> ] ;
         [ INSTANTIATE <uData,...> ]    ;
         [ USER DATA <uUserData> ] ;
         =>  ;
         _ObjAddMet( nClassH, __SCOPE__ [ <scp> ], [ \{ _AsUppLst_( <Typ> ) \} ] ,;
                    <vt>, [ _ObjInsDat( \{|Self| <uData> \} )], _AsStrLst_( <Vrs> ) ) ;
         [ ; ObjSetUserData( nClassH, <uUserData>, _AsStrLst_( <Vrs> ) ) ]

#xcommand VAR     <*VLst*>   => _GEN_DATA_  1, <VLst>
#xcommand INSTVAR <*VLst*>   => VAR <VLst>
#xcommand DATA    <*VLst*>   => VAR <VLst>

#xcommand CLASSVAR  <*VLst*>   => _GEN_DATA_ 2, <VLst>
#xcommand CLASSDATA <*VLst*>   => CLASSVAR <VLst>

#xcommand __METHOD__ <Met> [, <MetN> ] [ <scp: PUBLIC, EXPORT, LOCAL, HIDDEN> ] [ <ctor: CONSTRUCTOR> ] => ;
   _ObjAddMet( nClassH, __SCOPE__ [ <scp> ], <.ctor.>, 0, ;
               _MetTrans_( <Met> ) [, _MetTrans_( <MetN> ) ] )

#xcommand _GEN_METHOD_ <Met> [,<MetN> ] [<*x*>] =>  ;
          __METHOD__  <Met> [,<MetN> ]  [<x>]

#xcommand _GEN_METHOD_ <Met> VIRTUAL [<*x*>] => __METHOD__ <Met>:_VIRTUAL_ [<x>]

#xcommand _GEN_METHOD_ <Met> SETGET [<*x*>]  => __METHOD__ <Met>:_SETGET_ [<x>]

#xcommand _GEN_METHOD_ <Met> METHOD <udf> [, <MetN> METHOD <udfN> ] [<*x*>] => ;
          __METHOD__ <Met> = <udf> [ , <MetN> = <udfN> ] [<x>]

#xcommand _GEN_METHOD_ <Met> <code: EXTERN, CFUNC, CMETHOD> <udf> [<*x*>] => ;
          EXTERNAL _AsName_( <udf> ) ;;
          _ObjAddMet( nClassH, __SCOPE__, .f., 0, _AsStr_(<Met>), _AsStr_( <udf> ) )

#xcommand _GEN_METHOD_ <Met> <o: BLOCK, INLINE> <code,...> [ <scp: PUBLIC, EXPORT, LOCAL, HIDDEN> ] => ;
          _ObjAddMet( nClassH, __SCOPE__ [<scp>], .f., 3, _BlkTrans_( <Met> <o> <code> ) )

#xcommand MESSAGE <*cMDesc*>   => _GEN_METHOD_ <cMDesc>

#xcommand DELEGATE MESSAGE <cMsgs,...> TO <cVar> [ <scp: PUBLIC, EXPORT, LOCAL, HIDDEN> ] => ;
          _ObjAddMet( nClassH, __SCOPE__ [<scp>], _AsStr_( <cVar> ), 4, ;
                      _AsStrLst_( <cMsgs> ) )

#xcommand ERROR HANDLER <cFunc>  => ;
          _ObjAddMet( nClassH, , .f., 5, \{|| _AsName_( <cFunc> )() \} )

// BOOL pascal UserErrServer( CLSHANDLE Handle, PCLIPSYMBOL pMessage, WORD wError );
#xcommand ERROR HANDLER <cFunc> <code: EXTERN, CFUNC, CMETHOD> => ;
          EXTERNAL _AsName_( <cFunc> ) ;;
          _ObjAddMet( nClassH, , .f., 5, _AsStr_( <cFunc> ) )

#xcommand _GEN_METHOD_ <cFunc> ERROR HANDLER [ <x> ] => ;
          ERROR HANDLER <cFunc> [ <x> ]

#xcommand _GEN_METHOD_ <cMeth> OPERATOR <cOp> => ;
          _ObjAddMet( nClassH, , .f., 6, <(cOp)>, \{|| _AsName_( <cMeth> )() \} )

#xcommand _GEN_METHOD_ <cMeth> ALIAS OF <cMsg> => ;
          _ObjAddMet( nClassH, _AsStr_( <cMeth> ), _AsStr_( <cMsg> ), 7 )

#xcommand  __ST__  <st: METHOD, MESSAGE, VAR, INSTVAR, DATA, CLASSVAR, CLASSDATA > <*x*> ;
                  => <st> <x>
#xcommand EXPORT  <*x*> => __ST__ <x> PUBLIC
#xcommand HIDE    <*x*> => __ST__ <x> HIDDEN
#xcommand PROTECT <*x*> => __ST__ <x> PROTECTED

#xcommand EXPORT:     =>   _DftScope( 0 )
#xcommand PUBLIC:     =>   EXPORT:
#xcommand PROTECTED:  =>   _DftScope( 1 )
#xcommand READONLY:   =>   PROTECTED:
#xcommand LOCAL:      =>   _DftScope( 2 )
#xcommand HIDDEN:     =>   LOCAL:

#xtranslate _MetTrans_( <Met> ) => ;
            _AsStr_( <Met> ), \{|| _AsName_( <Met> )() \}

#xtranslate _MetTrans_( <Met> = <udf> ) => ;
            _AsStr_( <Met> ), \{|| _AsName_( <udf> )() \}

#xtranslate _MetTrans_( <Met>:_VIRTUAL_ ) => ;
            _AsStr_( <Met> ), "_VIRTUAL_"

#xtranslate _MetTrans_( <Met>:_SETGET_ ) => ;
            _AsStr_( <Met> ), \{|| _AsName_( <Met> )() \}, ;
            "_" + _AsStr_( <Met> ), \{|| _AsName_( <Met> )() \}

#xtranslate _BlkTrans_( <Met> INLINE <code,...> ) => ;
            #<Met>, \{ | Self | <code> \}

#xtranslate _BlkTrans_( <Met>( [<prm,...>] ) INLINE <code,...> ) => ;
            #<Met>, \{ | Self [, <prm> ] | <code> \}

#xtranslate _BlkTrans_( <Met> BLOCK <code,...> ) => ;
            _AsStr_( <Met> ), <code>

#xtranslate _AsFunc_( <itm> )                   => <itm>()
#xtranslate _AsFunc_( <itm>( [<prm,...>] ) )    =>  <itm>( [<prm>] )

#xtranslate _AsName_( <itm> )                   => <itm>
#xtranslate _AsName_( <itm>( [<prm,...>] ) )    => <itm>


#xtranslate _AsStr_( <itm> )                    => <(itm)>
#xtranslate _AsStr_( <itm>( [<prm,...>] ) )     => #<itm>
#xtranslate _AsUpp_( <itm> )                    => upper( _AsStr_( <itm> ) )

#xtranslate _AsStrLst_( <Typ> [, <TypN> ] )     => ;
                                    _AsStr_( <Typ> ) [, _AsStr_( <TypN> ) ]
#xtranslate _AsUppLst_( <Typ> [, <TypN> ] )     => ;
                                    _AsUpp_( <Typ> ) [, _AsUpp_( <TypN> ) ]

#xtranslate __SCOPE__                                => NIL
#xtranslate __SCOPE__ <scp: PUBLIC, EXPORT>          => 0
#xtranslate __SCOPE__ <scp: READONLY, PROTECTED>     => 1
#xtranslate __SCOPE__ <scp: LOCAL, HIDDEN>           => 2

#xtranslate :VIRTUAL => :_VIRTUAL_
#xtranslate :SETGET  => :_SETGET_

#xcommand ENDCLASS  =>                                ;
                       end                           ;;
                       return _ObjClsIns( nClassH )  ;;
                       #include "obendcls.ch"

#xcommand END CLASS  => ENDCLASS

#xcommand _METHOD_ <Tp: FUNCTION, PROCEDURE> <Met> [ CLASS <ClassN> ] =>;
                  _FuncType_ <Tp> <Met>  ;;
                  local Self := QSelf()

#translate METHOD <Tp: FUNCTION, PROCEDURE> <*Met*> => ;
                 _METHOD_ <Tp> <Met>

#translate METHOD <ClassN>::<*Met*>        => ;
                 _METHOD_ FUNCTION <Met>

#translate METHOD <ClassN>.<*Met*>         => ;
                 _METHOD_ FUNCTION <Met>

#xtranslate :Parent( <SupCls> ):<*M*> => :<SupCls>:<M>

#xtranslate :Parent:<*M*>             => :_sUPcLS_:<M>

#xtranslate Super:<*M*>               => Self:_sUPcLS_:<M>

#xtranslate :Super  => :Parent

#xtranslate :: =>  Self:

#xcommand METHOD <*MDesc*> =>  _GEN_METHOD_ <MDesc>

#else

#xcommand METHOD <Method>(<params,...>) [ CONSTRUCTOR ] => ;
          exported: ; METHOD <Method>

#xcommand METHOD <Class>:<Method>([<params,...>]) => ;
          static METHOD <Class>:<Method>([<params>])

#xcommand METHOD <Method>([<params,...>]) CLASS <Class> => ;
          static METHOD <Class>:<Method>([<params>])

// #xcommand METHOD Init[(<params,...>)] CLASS <Class> => ;
//             METHOD <Class>:_Init[(<params>)]

#xcommand METHOD New([<params,...>]) CLASS <Class> => ;
             METHOD <Class>:Init([<params>])

#xcommand METHOD New[([<x,...>])] [ CONSTRUCTOR ] => METHOD Init

#translate End([<x>])        => _End([<x>])
#translate End([<x>][,<y>])  => _End([<x>][,<y>])
#translate Next([<x>])       => _Next([<x>])
#translate Prev([<x>])       => _Prev([<x>])

#xcommand DATA <x,...> [ AS <y,...> ] ;
             [ DEFAULT <d> ] [ INIT <z> ] [ HIDDEN ] ;
             [ READONLY ] [ PROTECTED ] => ;
          exported: ; VAR <x>

#xcommand METHOD <Method>([<params,...>]) BLOCK <Block> => ;
                 INLINE METHOD <Method>([<params>]) ;;
                    return Eval( <Block>, Self [,<params>] )

#xcommand METHOD <Method> VIRTUAL => ;
                 INLINE METHOD <Method> ;;
                    return nil

#xcommand METHOD New[([<x,...>])] VIRTUAL => INLINE METHOD Init() ;;
                                             return nil

#xcommand METHOD <Method>([<params,...>]) SETGET => ACCESS ASSIGN METHOD <Method>

#xcommand METHOD <Method> OPERATOR <Op> => METHOD <Method>

#xcommand METHOD <Method> INLINE <Code,...> => ;
                 exported: ; INLINE METHOD <Method> ;;
                    return (<Code>)

#xcommand METHOD New([<params>]) INLINE <Code,...> => ;
                 INLINE METHOD Init([<params>]) ;;
                    return (<Code>)

#xcommand METHOD <Method> EXTERN <Code> => ;
                 INLINE METHOD <Method> ;;
                    return <Code>

#xcommand CLASSDATA <x,...> [ AS <y,...> ] [ INIT <z> ] [ HIDDEN ] => ;
          exported: ; CLASS VAR <x>

#xcommand MESSAGE <x>[([<params,...>])] METHOD <y>([<params2,...>]) => ;
          INLINE METHOD <x>([<params2>]) ;;
            if PCount() > 0 ;;
               return ::<y>([<params2>]) ;;
            else ;;
               return ::<y>() ;;
            endif ;;
          return nil ;;
          METHOD <y>

#xcommand MESSAGE <x> ALIAS OF <y> =>

#translate PROTECT =>

#xcommand BYNAME <x,...> [ DEFAULT <y> ] =>

#xtranslate ERROR HANDLER => METHOD

#xtranslate :: => Self:

#endif
#endif
#endif
