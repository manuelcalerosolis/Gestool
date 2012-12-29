//----------------------------------------------------------------------------//
//  AUTOR.....: Manuel Exp¢sito Su rez    Soft 4U '98                         //
//  e-Mail....: maex14@dipusevilla.es                                         //
//  CLASE.....: TDbfScp.CH                                                    //
//  FECHA MOD.: 20/07/2000                                                    //
//  VERSION...: 8.00                                                          //
//  PROPOSITO.: Gestion de bases de datos con Scopes                          //
//----------------------------------------------------------------------------//

#ifndef _TDBFSCP_CH
#define _TDBFSCP_CH

//----------------------------------------------------------------------------//
//------------------ SCOPES --------------------------------------------------//
//----------------------------------------------------------------------------//

#xCommand SET SCOPE [TO] [ <cnTag> [ IN <(cFile)> ] ]   ;
             [ FOR <xValTop> [ TO <xValBottom> ] ]      ;
             OF <oDbf>                                  ;
             => ;
             <oDbf>:SetScope( <xValTop>, <xValBottom>, <cnTag>, <(cFile)>, .t. )

#command SET SCOPE TO OF <oDbf>             => <oDbf>:ClearScope()
#command SET SCOPE TO <x>, <y> OF <oDbf>    => <oDbf>:SetScope( <x>, <y> )
#command SET SCOPE TO <x> OF <oDbf>         => <oDbf>:SetScope( <x> )
#command SET SCOPE TO ,<x> OF <oDbf>        => <oDbf>:SetScope( , <x> )

#xCommand SET SCOPE ON [ <cnTag> [ IN <(cFile)> ] ] OF <oDbf> ;
            => ;
            <oDbf>:IdxByName( <cnTag>, <(cFile)> ):lScope := .t.

#xCommand SET SCOPE OFF [ <cnTag> [ IN <(cFile)> ] ] OF <oDbf> ;
            => ;
            <oDbf>:IdxByName( <cnTag>, <(cFile)> ):lScope := .f.

//----------------------------------------------------------------------------//

#endif

//----------------------------------------------------------------------------//

