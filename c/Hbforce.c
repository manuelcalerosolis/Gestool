//----------------------------------------------------------------------------//
//  AUTOR.....: Manuel Exp¢sito Su rez    Soft 4U '1994-2000                  //
//  e-Mail....: maex14@dipusevilla.es                                         //
//  CLASE.....: HBFORCE.C                                                     //
//  FECHA MOD.: 10/11/2000                                                    //
//  VERSION...: 9.00                                                          //
//  PROPOSITO.: Accesos a bajo nivel a la estructura WorkArea de Harbour      //
//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
//Para las RDD nativas de Harbour

#include "hbrdddbf.h"
#include "hbapirdd.h"

//----------------------------------------------------------------------------//

HB_FUNC( DBFHDL )
{
   LPDBFAREA pArea = hb_rddGetCurrentWorkAreaPointer();
   if( pArea )
      hb_retni( pArea->hDataFile );
   else
      hb_retni( 0 );
}

//----------------------------------------------------------------------------//

HB_FUNC( ISSHARED )
{
   LPDBFAREA pArea = hb_rddGetCurrentWorkAreaPointer();
   if( pArea )
      hb_retl( pArea->fShared );
   else
      hb_retl( FALSE );
}

//----------------------------------------------------------------------------//

HB_FUNC( ISREADONLY )
{
   LPDBFAREA pArea = hb_rddGetCurrentWorkAreaPointer();
   if( pArea )
      hb_retl( pArea->fReadonly );
   else
      hb_retl( FALSE );
}

//----------------------------------------------------------------------------//
//Para la RDD ADS de Harbour

typedef unsigned long  ADSHANDLE;

typedef struct _ADSAREA_
{
   struct _RDDFUNCS * lprfsHost; /* Virtual method table for this workarea */
   USHORT uiArea;                /* The number assigned to this workarea */
   void * atomAlias;             /* Pointer to the alias symbol for this workarea */
   USHORT uiFieldExtent;         /* Total number of fields allocated */
   USHORT uiFieldCount;          /* Total number of fields used */
   LPFIELD lpFields;             /* Pointer to an array of fields */
   void * lpFieldExtents;        /* Void ptr for additional field properties */
   PHB_ITEM valResult;           /* All purpose result holder */
   BOOL fTop;                    /* TRUE if "top" */
   BOOL fBottom;                 /* TRUE if "bottom" */
   BOOL fBof;                    /* TRUE if "bof" */
   BOOL fEof;                    /* TRUE if "eof" */
   BOOL fFound;                  /* TRUE if "found" */
   DBSCOPEINFO dbsi;             /* Info regarding last LOCATE */
   DBFILTERINFO dbfi;            /* Filter in effect */
   LPDBORDERCONDINFO lpdbOrdCondInfo;
   LPDBRELINFO lpdbRelations;    /* Parent/Child relationships used */
   USHORT uiParents;             /* Number of parents for this area */
   USHORT heap;
   USHORT heapSize;
   USHORT rddID;

   /*
   *  ADS's additions to the workarea structure
   *
   *  Warning: The above section MUST match WORKAREA exactly!  Any
   *  additions to the structure MUST be added below, as in this
   *  example.
   */

   char * szDataFileName;        /* Name of data file */
   USHORT uiHeaderLen;           /* Size of header */
   USHORT uiRecordLen;           /* Size of record */
   ULONG ulRecCount;             /* Total records */
   ULONG ulRecNo;                /* Current record */
   BYTE bYear;                   /* Last update */
   BYTE bMonth;
   BYTE bDay;
   USHORT * pFieldOffset;        /* Pointer to field offset array */
   BYTE * pRecord;               /* Buffer of record data */
   ULONG maxFieldLen;
   BOOL fValidBuffer;            /* State of buffer */
   BOOL fRecordChanged;          /* Record changed */
   BOOL fShared;                 /* Shared file */
   BOOL fReadonly;               /* Read only file */
   BOOL fFLocked;                /* TRUE if file is locked */
   ADSHANDLE hTable;
   ADSHANDLE hOrdCurrent;
   ADSHANDLE hStatement;
} ADSAREA;

typedef ADSAREA * ADSAREAP;

//----------------------------------------------------------------------------//

HB_FUNC( ADSDBFHDL )
{
   ADSAREAP pArea = hb_rddGetCurrentWorkAreaPointer();
   if( pArea )
      hb_retni( pArea->hTable );
   else
      hb_retni( 0 );
}

//----------------------------------------------------------------------------//

HB_FUNC( ADSISSHARED )
{
   ADSAREAP pArea = hb_rddGetCurrentWorkAreaPointer();
   if( pArea )
      hb_retl( pArea->fShared );
   else
      hb_retl( FALSE );
}

//----------------------------------------------------------------------------//

HB_FUNC( ADSISREADONLY )
{
   ADSAREAP pArea = hb_rddGetCurrentWorkAreaPointer();
   if( pArea )
      hb_retl( pArea->fReadonly );
   else
      hb_retl( FALSE );
}

//----------------------------------------------------------------------------//

