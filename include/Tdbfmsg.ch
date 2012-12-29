//----------------------------------------------------------------------------//
//  AUTOR.....: Manuel Exp¢sito Su rez    Soft 4U '98                         //
//  e-Mail....: maex14@dipusevilla.es                                         //
//  CLASE.....: TDbfMsg.CH                                                    //
//  FECHA MOD.: 24/01/2002                                                    //
//  VERSION...: 11.00                                                         //
//  PROPOSITO.: Include para el sistema de lenguajes de TDbf                  //
//----------------------------------------------------------------------------//

#ifndef _TDBFMSG_CH
#define _TDBFMSG_CH

#ifndef CRLF
    #define CRLF chr( 13 ) + chr( 10 )
#endif

#define LANGSYS 0           // Por defecto

#ifdef ESPA
    #define LANGSYS 0       // ESPA¥OL
#endif
#ifdef ITA
    #define LANGSYS 1       // ITALIANO
#endif

#define dbYES       01
#define dbNO        02
#define dbCONT      03
#define dbCANCEL    04
#define dbRETRY     05
#define dbSELEC     06
#define dbBLOCREG   07
#define dbOPENDB    08
#define dbFLDNODEF  09
#define dbSCPTMM    10
#define dbSCPRANG   11
#define dbREGREC    12
#define dbBRWBLOCK  13
#define dbNOVAL     14
#define dbINXDEL    15
#define dbNOORDER   16

#endif

//---------------------------------------------------------------------------//

