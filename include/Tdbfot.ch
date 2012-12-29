//----------------------------------------------------------------------------//
//  AUTOR.....: Manuel Exp¢sito Su rez    Soft 4U '98                         //
//  e-Mail....: maex14@dipusevilla.es                                         //
//  CLASE.....: TDbfOt.CH                                                     //
//  FECHA MOD.: 24/01/2002                                                    //
//  VERSION...: 11.00                                                         //
//  PROPOSITO.: Gestion de metodos basados en bFOR                            //
//----------------------------------------------------------------------------//

#ifndef _TDBFOT_CH
#define _TDBFOT_CH

//----------------------------------------------------------------------------//
//------------------- OTROS --------------------------------------------------//
//----------------------------------------------------------------------------//

#xTranslate LOCATE                  ;
            [FOR <for>]             ;
            [WHILE <while>]         ;
            [<rest:REST>] [ ALL ]   ;
            OF <oDbf>               ;
            => ;
            <oDbf>:Locate( <{for}>, <{while}>, <.rest.> )

#xTranslate CONTINUE OF <oDbf>  ;
            => ;
            <oDbf>:Continue()

#xTranslate COUNT [TO <var>]        ;
            [FOR <for>]             ;
            [WHILE <while>]         ;
            [<rest:REST>] [ALL]     ;
            OF <oDbf>               ;
            => ;
            [ <var> := ] <oDbf>:eval(, <{for}>, <{while}>,, <.rest.> )

#xCommand SUM <cFld1> [,<cFldN>] TO <cVar1> [,<cVarN>]  ;
          [FOR <bFor>]                                  ;
          [WHILE <bWhile>]                              ;
          [NEXT <next>]                                 ;
          [RECORD <rec>]                                ;
          [<rest:REST>] [ ALL ]                         ;
          OF <oDbf>                                     ;
          => ;
          <cVar1> := [<cVarN> :=] 0 ;;
          <oDbf>:Sum( { |_o| <cVar1> += <cFld1> [,  <cVarN> += <cFldN> ] }, ;
                         <{bFor}>, <{bWhile}>, <next>, <rec>, <.rest.> )

#xCommand AVERAGE <cFld1> [,<cFldN>] TO <cVar1> [,<cVarN>]  ;
          [FOR <bFor>]                                      ;
          [WHILE <bWhile>]                                  ;
          [NEXT <next>]                                     ;
          [RECORD <rec>]                                    ;
          [<lRest: REST>] [ALL]                             ;
          OF <oDbf>                                         ;
          => ;
          M->__nTot := <cVar1> := [<cVarN> :=] 0                              ;;
          M->__nTot := <oDbf>:Sum( { || <cVar1> += <cFld1>                     ;
                                   [, <cVarN> += <cFldN> ] },                  ;
                                   <{bFor}>, <{bWhile}>,                       ;
                                   <next>, <rec>, <.lRest.> )                 ;;
          <cVar1> := <cVar1> / M->__nTot [; <cVarN> := <cVarN> / M->__nTot]   ;;
          __MXRelease( "__nTot" )

#command SORT [TO <(file)>] [ON <fields,...>]   ;
         [FOR <for>]                            ;
         [WHILE <while>]                        ;
         [NEXT <next>]                          ;
         [RECORD <rec>]                         ;
         [<rest:REST>] [ ALL ]                  ;
         OF <oDbf>                              ;
         => ;
         <oDbf>:Sort( <(file)>, { <(fields)> }, ;
                      <{for}>, <{while}>, <next>, <rec>, <.rest.> )

#command TOTAL [TO <(file)>] [ON <key>] ;
         [FIELDS <fields,...>]          ;
         [FOR <for>]                    ;
         [WHILE <while>]                ;
         [NEXT <next>]                  ;
         [RECORD <rec>]                 ;
         [<rest:REST>] [ ALL ]          ;
         OF <oDbf>                      ;
         => ;
         <oDbf>:Total( <(file)>, <{key}>, { <(fields)> }, ;
                       <{for}>, <{while}>, <next>, <rec>, <.rest.> )

//----------------------------------------------------------------------------//

#endif

//----------------------------------------------------------------------------//

