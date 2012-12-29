//----------------------------------------------------------------------------//
//  AUTOR.....: Manuel Exp¢sito Su rez    Soft 4U '98                         //
//  e-Mail....: maex14@dipusevilla.es                                         //
//  CLASE.....: TDbfDict.CH                                                   //
//  FECHA MOD.: 24/01/2002                                                    //
//  VERSION...: 11.00                                                         //
//  PROPOSITO.: Gestion de diccionarios de bases de datos                     //
//----------------------------------------------------------------------------//


#ifndef _TDBFDICT_CH
#define _TDBFDICT_CH

//----------------------------------------------------------------------------//
//------------------ DATA BASES DICTIONARY -----------------------------------//
//----------------------------------------------------------------------------//

//---- Definicion de caracteristicas generales del diccionario de datos: -----//

#xCommand DEFINE <_db: DICT, DICTIONARY> <oDict>            ;
                    [ PATH <(cPath)> ]                      ;
                    [ <lRecycle:  NORECYCLE> ]              ;
                    [ <lShared:   SHARED> ]                 ;
                    [ <lReadOnly: READONLY> ]               ;
                    [ <lProtec:   PROTEC> ]                 ;
                    [ <lBuffer:   BUFFER> ]                 ;
                    [ <drv: RDD, VIA, DRIVER> <cDriver> ]   ;
                    [ COMMENT <cComment> ]                  ;
                    => ;
<oDict> := TDict():New( <(cDriver)>, <(cPath)>, !<.lRecycle.>, <.lShared.>, ;
                        <.lReadOnly.>, <.lProtec.>, <.lBuffer.>, <cComment> )

//---- A¤adir tablas al diccionario de datos: --------------------------------//

#xCommand ADD <_dbf: TABLE, DBF, TDBF> <oDbf> OF <oDict> ;
                    [ <cRecycle:  RECYCLE, NORECYCLE> ] ;
                    [ <lShared:   SHARED> ]    ;
                    [ <lReadOnly: READONLY> ]  ;
                    [ <cProtec:   PROTEC, NOPROTEC> ]    ;
                    [ <lBuffer:   BUFFER> ]  ;
                    => ;
<oDict>:AddDBF( <oDbf>, [<"cRecycle">], [<.lShared.>], [<.lReadOnly.>], ;
                [<"cProtec">], [<.lBuffer.>] )

//---- Activacion del diccionario de datos: ----------------------------------//

#xCommand ACTIVATE <dic: DICT, DICTIONARY> <oDict> => <oDict>:Activate()

//----------------------------------------------------------------------------//

#endif

//----------------------------------------------------------------------------//

