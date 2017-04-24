#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Ads.ch"

//---------------------------------------------------------------------------//

CLASS SQLBaseView
  
   DATA     oShell

   DATA     nLevel

   DATA     keyUserMap

   DATA     oModel

   DATA     nMode                                  AS NUMERIC
 
   METHOD   New()
   
   METHOD   isUserAccess()                         INLINE ( nAnd( ::nLevel, ACC_ACCE ) == 0 )
   METHOD   notUserAccess()                        INLINE ( !::isUserAccess() )
   METHOD   isUserAppend()                         INLINE ( nAnd( ::nLevel, ACC_APPD ) != 0 )
   METHOD   notUserAppend()                        INLINE ( !::isUserAppend() )
   METHOD   isUserEdit()                           INLINE ( nAnd( ::nLevel, ACC_EDIT ) != 0 )
   METHOD   notUserEdit()                          INLINE ( !::isUserEdit() )

   METHOD setAppendMode( nMode )                   INLINE ( ::nMode := __append_mode__ )
   METHOD setEditMode( nMode )                     INLINE ( ::nMode := __edit_mode__ )
   METHOD setZoomMode( nMode )                     INLINE ( ::nMode := __zoom_mode__ )

   METHOD isZoomMode()                             INLINE ( ::nMode == __zoom_mode__ )

   METHOD setMode( nMode )                         INLINE ( ::nMode := nMode )
   METHOD getMode()                                INLINE ( ::nMode )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::nLevel                                        := nLevelUsr( ::keyUserMap )

Return ( Self )

//---------------------------------------------------------------------------//
