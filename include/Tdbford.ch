//----------------------------------------------------------------------------//
//  AUTOR.....: Manuel Exp¢sito Su rez    Soft 4U '98                         //
//  e-Mail....: maex14@dipusevilla.es                                         //
//  CLASE.....: MesOrd.CH                                                     //
//  FECHA MOD.: 24/01/2002                                                    //
//  VERSION...: 11.00                                                         //
//  PROPOSITO.: Include para utilizacion de indices y ordenaciones con TDbf   //
//----------------------------------------------------------------------------//

#ifndef _TDBFORD_CH
#define _TDBFORD_CH

//----------------------------------------------------------------------------//
//------------------ INDEX Y ORDENACIONES ------------------------------------//
//----------------------------------------------------------------------------//

#xTranslate DEFINE INDEX <*def*>    => INDEX <def>

#xTranslate ADD INDEX <*def*>       => INDEX <def>

#xTranslate INDEX [ <oIdx> ]                                                ;
                [ <File: BAG, FILE, TO> <(cFile)> ]                         ;
                [ <Tag: TAG, NAME> <(cTag)> ]                               ;
                [ ON <cKey> ]                                               ;
                [ FOR <cFor> ]                                              ;
                [ WHILE <cWhile> ]                                          ;
                [ <lUniq: UNIQUE> ]                                         ;
                [ <lDes: DESCENDING> ]                                      ;
                [ COMMENT <cComment> ]                                      ;
                [ EVAL <cOption> ]                                          ;
                [ EVERY <nStep> ]                                           ;
                [ <lNoDel: NODELETED, NODELETE, NODEL> ]                    ;
                OF <oDbf>                                                   ;
                => ;
    [ <oIdx> := ] <oDbf>:AddIndex( <(cTag)>, <(cFile)>, <(cKey)>, <(cFor)>, ;
                     <{cWhile}>, <.lUniq.>, <.lDes.>, <(cComment)>,         ;
                     <{cOption}>, <nStep>, <.lNoDel.>, .f. )

#xcommand REINDEX <oDbf>                                                    ;
                [ EVAL <cOption> ]                                          ;
                [ EVERY <nStep> ]                                           ;
                => <oDbf>:ReIndexAll( <{cOption}>, <nStep> )

#xCommand SET      INDEX IN <oDbf> => <oDbf>:IdxActivate()
#xCommand ACTIVATE INDEX IN <oDbf> => <oDbf>:IdxActivate()

#xcommand SUBINDEX [ <oIdx> ]                                               ;
                [ <File: BAG, FILE, TO> <(cFile)> ]                         ;
                [ <Tag: TAG, NAME> <(cTag)> ]                               ;
                [ ON <cKey> ]                                               ;
                [ FOR <cFor> ]                                              ;
                [ WHILE <cWhile> ]                                          ;
                [ <lUniq: UNIQUE> ]                                         ;
                [ <lDes: DESCENDING> ]                                      ;
                [ COMMENT <cComment> ]                                      ;
                [ EVAL <cOption> ]                                          ;
                [ EVERY <nStep> ]                                           ;
                [ <lNoDel: NODELETED, NODELETE, NODEL> ]                    ;
                [ <lFocus: FOCUS, SETFOCUS, CONTROL> ]                      ;
                OF <oDbf>                                                   ;
                => ;
    [ <oIdx> := ] <oDbf>:AddTmpIndex( <(cTag)>, <(cFile)>, <(cKey)>,        ;
                  <(cFor)>, <{cWhile}>, <.lUniq.>, <.lDes.>, <(cComment)>,  ;
                  <{cOption}>, <nStep>, <.lNoDel.>, <.lFocus.> )

#xcommand DELINDEX <oIdx> OF <oDbf> => <oDbf>:IdxDelete( <oIdx> )

//----------------------------------------------------------------------------//

#command SET ORDER TO <cnTag> [ IN <(cFile)> ] OF <oDbf> ;
         => ;
          <oDbf>:SetOrder( <cnTag> [, <(cFile)>] )

//----------------------------------------------------------------------------//
//------------------ SCOPES --------------------------------------------------//
//----------------------------------------------------------------------------//

#command SET SCOPE [FOR <x> [TO <y>]] OF <oDbf> => <oDbf>:SetScope( <x>, <y> )

#command SET SCOPE TO <x>, <y> OF <oDbf>    => <oDbf>:SetScope( <x>, <y> )
#command SET SCOPE TO <x> OF <oDbf>         => <oDbf>:SetScope( <x> )
#command SET SCOPE TO ,<x> OF <oDbf>        => <oDbf>:SetScope( , <x> )

#command SET SCOPE TO OF <oDbf>             => <oDbf>:ClearScope()

//----------------------------------------------------------------------------//

#endif

//----------------------------------------------------------------------------//
