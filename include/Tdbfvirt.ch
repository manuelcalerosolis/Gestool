//----------------------------------------------------------------------------//
//  AUTOR.....: Manuel Exp¢sito Su rez    Soft 4U '98                         //
//  e-Mail....: expo2001@wanadoo.es                                           //
//  CLASE.....: TDbfVirt.CH                                                   //
//  FECHA MOD.: 17/04/2002                                                    //
//  VERSION...: 12.00                                                         //
//  PROPOSITO.: Gestion de bases de datos virtuales                           //
//----------------------------------------------------------------------------//

#ifndef _TDBFVIRT_CH
#define _TDBFVIRT_CH

//----------------------------------------------------------------------------//

#xCommand DEFINE <_db: DBVIRTUAL, DBARRAY> <oDbv>    ;
                    [ <cNm: NAME, ALIAS> <cAlias> ]  ;
                    [ COMMENT <cComment> ]           ;
                    [ INIT RECORD <aRec> ]           ;
                    => ;
<oDbv> := TDbArray():New( <cAlias>, [ <(aRec)> ], .f., [ <cComment> ] )

//----------------------------------------------------------------------------//

#xCommand DEFINE <_db: DBVIRTUAL, DBARRAY> <oDbv>    ;
                    [ <cNm: NAME, ALIAS> <cAlias> ]  ;
                    [ COMMENT <cCom> ]               ;
                    [ INIT RECORD <aRec> ]           ;
                    <lData: DATA>                    ;
                    => ;
<oDbv> := TDbVirtual( [<cAlias>] ):New( <cAlias>, [<aRec>], .t., [<cCom>] )

//----------------------------------------------------------------------------//

#xCommand DBVIRTUAL <oDbv> <cNm: CLASS, NAME, ALIAS> <cName> ;
               [ COMMENT <cCom> ] => ;
<oDbv> := TDbVirtual( , [<cName>] ):DefNew( [<cCom>] )

#xCommand VFIELD <(cName)> TYPE <cType>     ;
                   [ LEN <nLen> ]   ;
                   [ DEC <nDec> ]   ;
                   OF <oVDb>        ;
                   =>               ;
                   <oVDb>:AddField( <(cName)>, <(cType)>, <nLen>, <nDec> )

#xCommand ACTIVATE <VDb: DBVIRTUAL, DBARRAY> <oVDb> => <oVDb>:Activate()

//----------------------------------------------------------------------------//

#endif

