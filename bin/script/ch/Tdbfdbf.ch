//----------------------------------------------------------------------------//
//  AUTOR.....: Manuel Exp¢sito Su rez    Soft 4U '98                         //
//  e-Mail....: maex14@dipusevilla.es                                         //
//  CLASE.....: TDbfDbf.CH                                                    //
//  FECHA MOD.: 24/01/2002                                                    //
//  VERSION...: 11.00                                                         //
//  PROPOSITO.: Gestion de bases de datos                                     //
//----------------------------------------------------------------------------//

#ifndef _TDBFDBF_CH
#define _TDBFDBF_CH

//----------------------------------------------------------------------------//
//------------------ DATA BASES ----------------------------------------------//
//----------------------------------------------------------------------------//

#xCommand DATABASE <oDbf> FILE <*def*> => DEFINE DATABASE <oDbf> FILE <def>

#xCommand DBF <oDbf> FILE <*def*>      => DEFINE DATABASE <oDbf> FILE <def>

#xCommand DEFINE <_db: TABLE, DATABASE, DBF> <oDbf>         ;
                    FILE <(cFile)>                          ;
                    [ PATH <(cPath)> ]                      ;
                    [ CLASS <cClass> ]                      ;
                    [ <cNm: NAME, ALIAS> <cAlias> ]         ;
                    [ COMMENT <cComment> ]                  ;
                    [ <drv: VIA, RDD, DRIVER> <cDriver> ]   ;
                    => ;
<oDbf> := DbfServer( <(cFile)>, <(cClass)> ):New( <(cFile)>, <(cAlias)>, ;
                                [ <(cDriver)> ], [ <cComment> ], <(cPath)> )

//----------------------------------------------------------------------------//
//------------------ FIELDS --------------------------------------------------//
//----------------------------------------------------------------------------//

#xTranslate DEFINE FIELD <*def*> => FIELD <def>

#xTranslate ADD FIELD <*def*> => FIELD <def>

#xTranslate FIELD [ <oFld> ]                        ;
                [ NAME <(cName)> ]                  ;
                [ TYPE <cType> ]                    ;
                [ LEN <nLen> ]                      ;
                [ DEC <nDec> ]                      ;
                [ PICTURE <cPic> ]                  ;
                [ DEFAULT <Def> ]                   ;
                [ VALID <Valid> ]                   ;
                [ <Cal: VAL, SETGET> <bSetGet> ]    ;
                [ COMMENT <cComment> ]              ;
                [ ALIGN <lColAlign: RIGHT> ]        ;
                [ COLSIZE <nColSize> ]              ;
                [ <lHide: HIDE> ]                   ;
                [ <Bitmap:BITMAPS> <aBitmaps,...> ] ;
                OF <oDbf>                           ;
                => ;
    [ <oFld> := ] <oDbf>:AddField( <(cName)>, <(cType)>, <nLen>, <nDec>, ;
                            <cPic>, <Def>, <{Valid}>, <{bSetGet}>, <cComment>, ;
                            <.lColAlign.>, <nColSize>, <.lHide.>, {<aBitmaps>} )

#xTranslate FIELD CALCULATE [ <oFld> ]              ;
                [ NAME <(cName)> ]                  ;
                [ LEN <nLen> ]                      ;
                [ DEC <nDec> ]                      ;
                [ PICTURE <cPic> ]                  ;
                [ VALID <Valid> ]                   ;
                [ <Cal: VAL, SETGET> <bSetGet> ]    ;
                [ COMMENT <cComment> ]              ;
                [ ALIGN <lColAlign: RIGHT> ]        ;
                [ COLSIZE <nColSize> ]              ;
                [ <lHide: HIDE> ]                   ;
                [ <Bitmap:BITMAPS> <aBitmaps,...> ] ;
                OF <oDbf>                           ;
                => ;
    [ <oFld> := ] <oDbf>:AddField( <(cName)>, 'B', <nLen>, <nDec>, ;
                            <cPic>,, <{Valid}>, <{bSetGet}>, <cComment>, ;
                            <.lColAlign.>, <nColSize>, <.lHide.>, {<aBitmaps>} )

//----------------------------------------------------------------------------//
//------------------ END -----------------------------------------------------//
//----------------------------------------------------------------------------//

#xCommand END <_db: DATABASE, DBF, TABLE> <*def*> ;
          => ;
          ENDDATABASE <def>

#xCommand ENDDATABASE <oDbf> ;
          => ;
          //---------- Fin de definicion del objeto TDbf <oDbf> ---------------

//----------------------------------------------------------------------------//
//------------------ ACTIVATE ------------------------------------------------//
//----------------------------------------------------------------------------//

#xCommand OPEN <_db: DATABASE, DBF, TABLE> <*def*> ;
          => ;
          ACTIVATE DBF <def>

#xCommand ACTIVATE <dbf: DATABASE, DBF, TABLE> <oDbf>  ;
                [ <lRecycle:  NORECYCLE> ]      ;
                [ <lShared:   SHARED> ]         ;
                [ <lReadOnly: READONLY> ]       ;
                [ <lProtec:   PROTEC> ]         ;
                => ;
                <oDbf>:Activate( !<.lRecycle.>, <.lShared.>, ;
                                  <.lReadOnly.>, <.lProtec.> )

//----------------------------------------------------------------------------//
// Compatible con TDataBase de FiveWin - DBF abierta                          //
// con mas posibilidades                                                      //
//----------------------------------------------------------------------------//

#xCommand USE <_db: DATABASE, DBF, TABLE> <oDbf>    ;
            [ COMMENT <cComment>   ]            ;
            [ PATH <(cPath)>       ]            ;
            [ DBFILE <(cFile)>     ]            ;
            [ CLASS <cClass>       ]            ;
            [ <lRecycle:  RECYCLE> ]            ;
            [ <lProtec:   PROTECT> ]            ;
    => <oDbf> := DbfServer( <(cFile)>, <(cClass)> ):Use( <(cFile)>, ;
              <(cPath)>, <cComment>, <.lRecycle.>, <.lProtec.> )

#xCommand DATABASE <oDbf>                       ;
            [ COMMENT <cComment>   ]            ;
            [ PATH <(cPath)>       ]            ;
            [ DBFILE <(cFile)>     ]            ;
            [ CLASS <cClass>       ]            ;
            [ <lRecycle:  RECYCLE> ]            ;
            [ <lProtec:   PROTECT> ]            ;
    => <oDbf> := DbfServer( <(cFile)>, <(cClass)> ):Use( <(cFile)>, ;
              <(cPath)>, <cComment>, <.lRecycle.>, <.lProtec.> )

//----------------------------------------------------------------------------//
// Sin abrir la DBF pero existe DBF                                           //
//----------------------------------------------------------------------------//

#xCommand DATABASE <_op: OPEN, NEW> <oDbf> [ COMMENT <cComment> ]    ;
                [ PATH <(cPath)> ]                      ;
                [ FILE <(cFile)> ]                      ;
                [ CLASS <cClass> ]                      ;
                [ <cNm: NAME, ALIAS> <cAlias> ]         ;
                [ <drv: VIA, RDD, DRIVER> <cDriver> ]   ;
                [ <lRecycle:  RECYCLE> ]                ;
                [ <lShared:   SHARED> ]                 ;
                [ <lReadOnly: READONLY> ]               ;
                [ <lProtec:   PROTEC> ]                 ;
                [ INDEX <(index1)> [, <(indexn)>] ]     ;
    => <oDbf> := DbfServer( <(cFile)>, <(cClass)> ):NewOpen( <(cFile)>, ;
                            <(cAlias)>, [ <(cDriver)> ], [ <cComment> ],;
                            <(cPath)>, <.lRecycle.>,                    ;
                            <.lShared.>, <.lReadOnly.>, <.lProtec.> )   ;
                            [; <oDbf>:AddBag( <(index1)> )]             ;
                            [; <oDbf>:AddBag( <(indexn)> )]             ;
                            ; <oDbf>:AutoIndex()

//----------------------------------------------------------------------------//
//----------------- CLOSE ----------------------------------------------------//
//----------------------------------------------------------------------------//

#xCommand CLOSE <_db: DATABASE, DBF, TABLE> <*def*> ;
          => ;
          DEACTIVATE DBF <def>

#xCommand DEACTIVATE <dbf: DATABASE, DBF, TABLE> <oDbf> ;
          => ;
          <oDbf>:Close()


//----------------------------------------------------------------------------//
//------------------ REACTIVAR el OBJETO -------------------------------------//
//----------------------------------------------------------------------------//

#xCommand REACTIVATE <dbf: DATABASE, DBF, TABLE> <oDbf>  ;
          => ;
          <oDbf>:ReActivate()

//----------------------------------------------------------------------------//
//------------------ DESTRUCCION del OBJETO -------------------------------------//
//----------------------------------------------------------------------------//

#xCommand DESTROY <dbf: DATABASE, DBF, TABLE> <oDbf> => <oDbf>:End()

//----------------------------------------------------------------------------//
//----------------- MISCELANEOS ----------------------------------------------//
//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
// Control del buffer

#Command SET BUFFER <x:ON,TRUE,ACTIVE,OFF,FALSE,DEACTIVATE&> TO <oDbf> ;
                                          => lSetBuffer( <oDbf>, <(x)> )
#Command SET BUFFER (<x>) TO <oDbf> => lSetBuffer( <oDbf>, <x> )

//----------------------------------------------------------------------------//
//  SEUDO OOP:  ACCESO DIRECTO A CAMPOS DEL REGISTRO Y A FUNCIONES

#xTranslate @<oDbf>:<(cField)>  =>  ( <oDbf>:nArea )-><cField>
#xTranslate @<oDbf>:<ClFnt>( [<uParam,...>] ) =>  ;
                                    ( <oDbf>:nArea )->( <ClFnt>( <uParam> ) )

//----------------------------------------------------------------------------//
// Control del COMMIT

#xcommand SET COMMIT <on:ON,OFF> OF <oDbf> => ;
                                    <oDbf>:SetCommit( upper(<(on)>) == "ON" )

#endif

//----------------------------------------------------------------------------//
