#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Ads.ch"

//---------------------------------------------------------------------------//

CLASS SQLBaseView
  
   DATA     oRowSet

   DATA     cTableName
   DATA     hColumns

   DATA     cSQLInsert     
   DATA     cSQLSelect      
   
   DATA     cColumnKey

   DATA     hBuffer
   DATA     idBuffer     
   DATA     cFind
   DATA     cColumnOrder
   DATA     cColumnOrientation
 
   METHOD   New()
   METHOD   End()
 
   METHOD   getSQLCreateTable()

   METHOD   getSelectSentence()
   METHOD   getInsertSentence()                     
   METHOD   getUpdateSentence()
   METHOD   getDeleteSentence()
   METHOD   setColumnOrderBy( cColumn )           INLINE   ( ::cColumnOrder := cColumn )
   METHOD   setOrderOrientation( cOrientation )   INLINE   ( ::cColumnOrientation := cOrientation )

   METHOD   setFind( cFind )                      INLINE   ( ::cFind := cFind )
   METHOD   getRowSet()
   METHOD   buildRowSet()
   METHOD   freeRowSet()                           INLINE   ( if( !empty( ::oRowSet ), ( ::oRowSet := nil ), ) )
   METHOD   getRowSetRecno()                       INLINE   ( if( !empty( ::oRowSet ), ( ::oRowSet:recno() ) , 0 ) )
   METHOD   setRowSetRecno( nRecno )               INLINE   ( if( !empty( ::oRowSet ), ( ::oRowSet:goto( nRecno ) ), ) )
 
   METHOD   getSelectByColumn()
   METHOD   getSelectByOrder()

   METHOD   find( cFind )

   METHOD   loadBuffer( id )
   METHOD   loadBlankBuffer()
   METHOD   loadCurrentBuffer()

   METHOD   getBuffer( cColumn )                   INLINE   ( hget( ::hBuffer, cColumn ) )
   METHOD   updateCurrentBuffer()                  INLINE   ( getSQLDatabase():Query( ::getUpdateSentence() ), ::refreshSelect() )
   METHOD   insertBuffer()                         INLINE   ( getSQLDatabase():Query( ::getInsertSentence() ), ::refreshSelect() )
   METHOD   deleteSelection()                      INLINE   ( getSQLDatabase():Query( ::getdeleteSentence() ), ::refreshSelect() )

   METHOD   getHistory()                           INLINE   ( HistoricosUsuariosModel():getHistory( ::cTableName ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()
