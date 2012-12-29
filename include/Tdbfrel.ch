//----------------------------------------------------------------------------//
//  AUTOR.....: Manuel Exp¢sito Su rez    Soft 4U '98                         //
//  e-Mail....: maex14@dipusevilla.es                                         //
//  CLASE.....: TDbfRel.CH                                                    //
//  FECHA MOD.: 24/01/2002                                                    //
//  VERSION...: 11.00                                                         //
//  PROPOSITO.: Gestion de bases de datos con Relacones entre oDbfs           //
//----------------------------------------------------------------------------//

#ifndef _TDBFREL_CH
#define _TDBFREL_CH

//----------------------------------------------------------------------------//
//------------------ RELACIONES --------------------------------------------//
//----------------------------------------------------------------------------//

#xTranslate DEFINE RELATION <*def*>   => RELATION <def>

#xTranslate ADD RELATION <*def*>      => RELATION <def>

#xTranslate RELATION [ <oRelation> ]                    ;
                   [ NAME <(cName)> ]                   ;
                   [ LINK <cLink> ]                     ;
                   [ <oDChld: IN, INTO> <oDbChild> ]    ;
                   [ <lDel: DELETE> ]                   ;
                   [ <lExec: EXECUTE, EXEC> ]           ;
                   [ TRIGGER <cTri> ]                   ;
                   [ COMMENT <cComment> ]               ;
                   OF <oDbf>                            ;
                   => ;
[ <oRelation> := ] <oDbf>:AddRelation( <(cName)>, <(cLink)>, <{cLink}>, ;
                   <oDbChild>, <cComment>, <.lDel.>, <.lExec.>, [<{cTri}>] )

#xCommand CLEAR RELATION <nRel> OF <oDbf> => <oDbf>:DelRelation(<nRel>)

#xCommand CLEAR ALL RELATION OF <oDbf> => <oDbf>:ClearAllRelation()

#xCommand SYNC OF <oDbf> => <oDbf>:Sync()

#xCommand TRIGGER <cTrigger> RELATION <nRel> OF <oDbf> => ;
                  <oDbf>:ATRelation[ <nRel> ]:bTrigger := [<{cTrigger}>]

//----------------------------------------------------------------------------//

#endif

//----------------------------------------------------------------------------//

