#ifndef __PDA__
#else
#include "FWCE.ch"
REQUEST DBFCDX
#endif
#include "DbInfo.ch"

#ifndef __PDA__

#define ES_ERROR           2

/*
Para Harbour
*/

#ifdef __HARBOUR__

Function _IsData()         ; Return ( .t. )

Function GetPrinters()    ; Return ( aGetPrinters() )
Function TOleContainer()   ; Return ( MsgInfo( "TOleContainer()"        ,  "OJO UNRRESOLVED" ) )

Function ZipAddAll( nZip, cPath )
Return   aEval( Directory( cPath ), { | aFile | MsgInfo( aFile[ 1 ], "OJO UNRRESOLVED" ) } )

Function MyZipAddFile( nZip, cPath )   ; Return ( MsgInfo( "MyZipAddFile()" ,  "OJO UNRRESOLVED" ) )
Function MyZipNew( nZip, cPath )       ; Return ( MsgInfo( "MyZipNew()" ,  "OJO UNRRESOLVED" ) )

Function ZipCreate()       ; Return ( MsgInfo( "ZipCreate()"            ,  "OJO UNRRESOLVED" ) )
Function ZipClose()        ; Return ( MsgInfo( "ZipClose()"             ,  "OJO UNRRESOLVED" ) )
Function MyZipCreate()     ; Return ( MsgInfo( "ZipCreate()"            ,  "OJO UNRRESOLVED" ) )
Function MyZipClose()      ; Return ( MsgInfo( "ZipClose()"             ,  "OJO UNRRESOLVED" ) )
Function UnZipOpen()       ; Return ( MsgInfo( "UnZipOpen()"            ,  "OJO UNRRESOLVED" ) )
Function UnZipExtractAll() ; Return ( MsgInfo( "UnZipOpen()"            ,  "OJO UNRRESOLVED" ) )
Function UnZipClose()      ; Return ( MsgInfo( "UnZipOpen()"            ,  "OJO UNRRESOLVED" ) )
Function UnPakFil()        ; Return ( MsgInfo( "UnPakFil()"             ,  "OJO UNRRESOLVED" ) )
Function UnZipDirectory()  ; Return ( MsgInfo( "ZipAddFile()"           ,  "OJO UNRRESOLVED" ) )
Function UnZipExtractFile(); Return ( MsgInfo( "ZipAddFile()"           ,  "OJO UNRRESOLVED" ) )
Function _ObjNewCls()      ; Return ( MsgInfo( "ObjNewCls()"            ,  "OJO UNRRESOLVED" ) )
Function _ObjClsIns()      ; Return ( MsgInfo( "ObjNewCls()"            ,  "OJO UNRRESOLVED" ) )
Function _ObjAddMet()      ; Return ( MsgInfo( "ObjNewCls()"            ,  "OJO UNRRESOLVED" ) )
Function __ClassIns()      ; Return ( MsgInfo( "ObjNewCls()"            ,  "OJO UNRRESOLVED" ) )
Function __ClassNam()      ; Return ( MsgInfo( "ObjNewCls()"            ,  "OJO UNRRESOLVED" ) )

#endif

#endif

Function DbfHdl()          ; Return ( dbInfo( DBI_FILEHANDLE ) )

Function IsShared()        ; Return ( dbInfo( DBI_SHARED ) )

Function IsReadOnly()      ; Return ( .f. )