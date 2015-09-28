/*
 * $Id: 22-Sep-10 9:27:27 PM tdolphin.ch Z dgarciagil $
 */
   
/*
 * TDOLPHIN PROJECT source code:
 * Manager MySql server connection
 *
 * Copyright 2010 Daniel Garcia-Gil<danielgarciagil@gmail.com>
 * www - http://tdolphin.blogspot.com/
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this software.  If not, write to
 * the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA 02111-1307 USA (or visit the web site http://www.gnu.org/).
 *
 * As a special exception, the tdolphin Project gives permission for
 * additional uses of the text contained in its release of tdolphin.
 *
 * The exception is that, if you link the tdolphin libraries with other
 * files to produce an executable, this does not by itself cause the
 * resulting executable to be covered by the GNU General Public License.
 * Your use of that executable is in no way restricted on account of
 * linking the tdolphin library code into it.
 *
 * This exception does not however invalidate any other reasons why
 * the executable file might be covered by the GNU General Public License.
 *
 * This exception applies only to the code released by the tdolphin
 * Project under the name tdolphin.  If you copy code from other
 * tdolphin Project or Free Software Foundation releases into a copy of
 * tdolphin, as the General Public License permits, the exception does
 * not apply to the code that you add in this way.  To avoid misleading
 * anyone as to the status of such modified files, you must delete
 * this exception notice from them.
 *
 * If you write modifications of your own for tdolphin, it is your choice
 * whether to permit this exception to apply to your modifications.
 * If you do not wish that, delete this exception notice.
 *
 */

// MySQL field types
#ifndef _TDOLPHIN_CH_
#define _TDOLPHIN_CH_

#define  MYSQL_DECIMAL_TYPE      0
#define  MYSQL_TINY_TYPE         1
#define  MYSQL_SHORT_TYPE        2
#define  MYSQL_LONG_TYPE         3
#define  MYSQL_FLOAT_TYPE        4
#define  MYSQL_DOUBLE_TYPE       5
#define  MYSQL_NULL_TYPE         6
#define  MYSQL_TIMESTAMP_TYPE    7
#define  MYSQL_LONGLONG_TYPE     8
#define  MYSQL_INT24_TYPE        9
#define  MYSQL_DATE_TYPE         10
#define  MYSQL_TIME_TYPE         11
#define  MYSQL_DATETIME_TYPE     12
#define  MYSQL_YEAR_TYPE         13
#define  MYSQL_NEWDATE_TYPE      14
#define  MYSQL_NUMERIC_TYPE      15
#define  MYSQL_ENUMTYPE          247
#define  MYSQL_SET_TYPE          248
#define  MYSQL_TINY_BLOB_TYPE    249
#define  MYSQL_MEDIUM_BLOB_TYPE  250
#define  MYSQL_LONG_BLOB_TYPE    251
#define  MYSQL_BLOB_TYPE         252
#define  MYSQL_VAR_STRING_TYPE   253
#define  MYSQL_STRING_TYPE       254

#define CLIENT_MULTI_STATEMENTS (0x10000) /* Enable/disable multi-stmt support */
#define CLIENT_MULTI_RESULTS    (0x20000) /* Enable/disable multi-results */

#ifndef MAX_BLOCKSIZE
#define MAX_BLOCKSIZE            65535
#endif


// MySQL field structure 
#define  MYSQL_FS_NAME           1     /* Name of column */
#define  MYSQL_FS_TABLE          2     /* Table of column if column was a field */
#define  MYSQL_FS_DEF            3     /* Default value (set by mysql_list_fields) */
#define  MYSQL_FS_TYPE           4     /* Type of field. Se mysql_com.h for types */
#define  MYSQL_FS_LENGTH         5     /* Width of column */
#define  MYSQL_FS_MAXLEN         6     /* Max width of selected set */
#define  MYSQL_FS_FLAGS          7     /* Div flags */
#define  MYSQL_FS_DECIMALS       8     /* Number of decimals in field */
#define  MYSQL_FS_CLIP_TYPE      9     /* Type of field. clipper field type */

// MySQL field flags
#define  NOT_NULL_FLAG           1        /* Field can't be NULL */
#define  PRI_KEY_FLAG            2        /* Field is part of a primary key */
#define  UNIQUE_KEY_FLAG         4		    /* Field is part of a unique key */
#define  MULTIPLE_KEY_FLAG       8		    /* Field is part of a key */
#define  BLOB_FLAG               16		    /* Field is a blob */
#define  UNSIGNED_FLAG           32		    /* Field is unsigned */
#define  ZEROFILL_FLAG           64		    /* Field is zerofill */
#define  BINARY_FLAG             128      /* Field is binary */
#define  ENUM_FLAG               256		  /* field is an enum */
#define  AUTO_INCREMENT_FLAG     512		  /* field is a autoincrement field */
#define  TIMESTAMP_FLAG          1024		  /* Field is a timestamp */
#define  PART_KEY_FLAG           16384		/* Intern; Part of some key */
#define  GROUP_FLAG              32768		/* Intern group field */


#define  DBS_NOTNULL             5        /* True if field has to be NOT NULL */
#define  DBS_DEFAULT             6        /* Field Value by default  */


//Create index
#define IDX_UNIQUE      1
#define IDX_FULLTEXT    2
#define IDX_SPATIAL     3
#define IDX_PRIMARY     4
                        
#define IDX_ASC         1
#define IDX_DES         2
                        
#define IDX_BTREE       1
#define IDX_HASH        2
#define IDX_RTREE       3

// 
#define IS_PRIMARY_KEY( uValue )  MyAND( uValue, PRI_KEY_FLAG ) == PRI_KEY_FLAG 
#define IS_MULTIPLE_KEY( uValue ) MyAND( uValue, MULTIPLE_KEY_FLAG ) == MULTIPLE_KEY_FLAG
#define IS_AUTO_INCREMENT( uValue ) MyAND( uValue, AUTO_INCREMENT_FLAG ) == AUTO_INCREMENT_FLAG
#define IS_NOT_NULL( uValue ) MyAND( uValue, NOT_NULL_FLAG ) == NOT_NULL_FLAG

// SET NEW FILTER
#define SET_WHERE    1
#define SET_GROUP    2
#define SET_HAVING   3
#define SET_ORDER    4
#define SET_LIMIT    5

//Privileges type
#define PRIV_ADMIN      1
#define PRIV_DATA       2
#define PRIV_TABLE      3
#define PRIV_ALL        4

//Backup Status process
#define ST_STARTBACKUP   1
#define ST_LOADINGTABLE  2
#define ST_ENDBACKUP     3
#define ST_BACKUPCANCEL  0
#define ST_FILLBACKUP    4

//Restore Process 
#define ST_STARTRESTORE  1
#define ST_LOADING       2
#define ST_RESTORING     3
#define ST_ENDRESTORE    4
#define ST_RSTCANCEL     0

//export
#define EXP_TEXT     1 
#define EXP_EXCEL    2
#define EXP_DBF      3
#define EXP_HTML     4
#define EXP_WORD     5
#define EXP_SQL      6



#ifndef __XHARBOUR__
#xcommand TRY  => BEGIN SEQUENCE WITH {|oErr| Break( oErr )}
#xcommand CATCH [<!oErr!>] => RECOVER [USING <oErr>] <-oErr->
#xcommand FINALLY => ALWAYS  

#xtranslate hb_ReadIni([<x,...>])       => hb_IniRead(<x>)
#xtranslate HASH([<x,...>])             => hb_HASH(<x>)
#xtranslate HGETPOS([<x,...>])          => hb_HPOS(<x>)
#xtranslate HSET([<x,...>])             => hb_HSET(<x>)
#xtranslate HSETCASEMATCH([<x,...>])    => hb_HSETCASEMATCH(<x>)
#xtranslate HCLONE([<x,...>])           => hb_HCLONE(<x>)
#xtranslate HGETKEYS([<x,...>])         => hb_HKEYS(<x>) 


//#include "hbcompat.ch"
#ifndef RGB
#define RGB( nR,nG,nB )  ( nR + ( nG * 256 ) + ( nB * 256 * 256 ) )
#endif /*RGB*/
#endif/*__HARBOUR__*/

//-------------------

#xcommand SET CASESENSITIVE <on:ON,OFF> => D_SetCaseSensitive( Upper(<(on)>) == "ON" )
#xcommand SET PADRIGHT <on:ON,OFF> => D_SetPadRight( Upper(<(on)>) == "ON" )
#xcommand SET LOGICALVALUE <on:ON,OFF> => D_LogicalValue( Upper(<(on)>) == "ON" )

//-------------------

#xcommand CLOSEMYSQL ALL  => _CloseHosts( "ALL" )
#xcommand CLOSEMYSQL SERVER <on> => _CloseHosts( <on> )
#xcommand SELECTSERVER <uParam> => _SelectHost( <uParam> )
#xcommand BEGINMYSQL [ TRANSACTION ] [<oServer>] => _BeginTransaction( [<oServer>] )
#xcommand COMMITMYSQL [<oServer>] => _CommitTransaction( [<oServer>] )                    
#xcommand ROLLBACKMYSQL [<oServer>] => _RollBack( [<oServer>] )                    

//-------------------
#xcommand CONNECT [ <srv: SERVER, MYSQL, OF> ] <oServer> ;
                  HOST <cHost> ;
                  USER <cUser> ;
                  PASSWORD <cPassword>;
                  [ PORT <nPort> ];
                  [ FLAGS <nFlags> ];
                  [ DATABASE <cDBName> ];
                  [ ON ERROR <uOnError> ] ;
                  [ NAME <cName> ];
                  [ DECRYPT <uDecrypt> ];
       => ;
          <oServer> := TDolphinSrv():New( <cHost>, <cUser>, <cPassword>, <nPort>, ;
                                          <nFlags>, <cDBName>, [{| Self, nError, lInternal, cExtra | <uOnError> }], ;
                                          [ <cName> ], [{| cValue |<uDecrypt>}]  )


//-------------------

#xcommand CONNECT EMBEDDED [ <srv: SERVER, MYSQL, OF> ] <oServer> ;
                  [ DATABASE <cDBName> ];
                  [ OPTIONS <options,...> ];
                  [ GROUPS <groups,...> ];
                  [ ON ERROR <uOnError> ] ;
                  [ NAME <cName> ];
                  [ DECRYPT <uDecrypt> ];
       => ;
          <oServer> := TDolphinSrv():Embedded( <cDBName>, \{<options>\}, \{<groups>\},;
                          [{| Self, nError, lInternal, cExtra | <uOnError> }], [ <cName> ], [{|cValue|<uDecrypt>}] )

//-------------------

#xcommand DEFINE QUERY <oQuery> [ <cQuery> ] [ <srv: OF, SERVER, HOST> <uServer> ];
       => ;
          <oQuery> := TDolphinQry():New( [ <cQuery> ],[ <uServer> ] )

//-------------------

#xcommand SELECTDB <cdb> <srv: SERVER, MYSQL, OF> <oServer>;
       => ;
          <oServer>:SelectDB( <cdb> )

#xcommand SELECTDB <cdb>;
       => ;
          GetServerDefault():SelectDB( <cdb> )
          
//-------------------
          
#xcommand INSERTMYSQL TO <ctable> ;
                 COLUMNS <acolumns,...> ;
                 VALUES <avalues,...>;
                 [ <srv: OF, SERVER, HOST><oServer> ];
       => ;
          _InsertMySql( [<oServer>], <ctable>, {<acolumns>}, {<avalues>} )

//-------------------          
          
#xcommand UPDATEMYSQL TO <ctable> ;
                 COLUMNS <acolumns,...> ;
                 VALUES <avalues,...>;
                 [ <srv: OF, SERVER, HOST><oServer> ];
                 [ WHERE <cWhere> ];
       => ;
          _UpdateMysql( [ <oServer> ], <ctable>, {<acolumns>}, {<avalues>}, <cWhere> )

//-------------------    

#xcommand BACKUPMYSQL TABLES <aTables,...>;
                FILE <cFile>;
                [ <srv: OF, SERVER, HOST><oServer> ];
                [ < lDrop: DROP > ];
                [ < lOverwrite: OVERWRITE > ];
                [ STEP <nStep> ];
                [ HEADER <cHeader> ];
                [ FOOTER <cFooter> ];
                [ <lCan: CANCEL> <lCancel> ];
                [ ON BACKUP <uOnBackup> ];
       =>;
           _BackUpMysql( [ <oServer> ], {<aTables>}, <cFile>, [<.lDrop.>], [<.lOverwrite.>], ;
                         [<nStep>], [<cHeader>], [<cFooter>], [if( <.lCan.>, @<lCancel>,)],;
                         [{| nStatus, cTabFile, nTotTable, nCurrTable, nRecNo | <uOnBackup> }] )
                         
//-------------------    

#xcommand RESTOREMYSQL FILE <cFile>;
                [ <srv: OF, SERVER, HOST><oServer> ];
                [ <lCan: CANCEL> <lCancel> ];
                [ ON RESTORE <uOnRestore> ];
       =>;
           _RestoreMysql( [ <oServer> ], ;
                          <cFile>,;
                          [if( <.lCan.>, @<lCancel>,)],;
                          [{| nStatus, cTable, nTotLine, nIdx | <uOnRestore> }] )        
                          
//-------------------    

#xcommand EXECUTEESCRIPT FILE <cFile>;
                [ <srv: OF, SERVER, HOST><oServer> ];
                [ ON SCRIPT <uOnScript> ];    
 =>;
           _ExecuteScript( [ <oServer> ], ;
                          <cFile>, [{| nID, nTotal | <uOnScript> }] )      
                          
#xcommand SELECTTABLES TO <oQuery>;
                 TABLES <cTable,...>;
                 [ COLUMNS <cColumns,...> ];
                 [ WHERE <cWhere> ];
                 [ GROUP <cGroup> ];
                 [ HAVING <cHaving> ];
                 [ ORDER BY <cOrder> ];
                 [ LIMIT <cLimit> ];
                 [ <lWithRoll: WITROLL> ];
                 [ <srv: OF, SERVER, HOST><oServer> ];
       =>;
          <oQuery> := _SelectTable( [<oServer>], [{<cColumns>}], {<cTable>}, [<cWhere>],;
                        [<cGroup>], [<cOrder>], [<cLimit>], [<.lWithRoll.>] )
#endif //_TDOLPHIN_CH_                        