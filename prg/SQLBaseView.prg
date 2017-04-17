#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Ads.ch"

//---------------------------------------------------------------------------//

CLASS SQLBaseView
  
   DATA     oShell

   DATA     nLevel

   DATA     keyUserMap

   DATA     oModel

   DATA     cFind

   DATA     cColumnOrder
   DATA     cColumnOrientation
 
   METHOD   New()
   
   METHOD   isUserAccess()
   METHOD   notUserAccess()                        INLINE   ( !::isUserAccess() )

   METHOD   getHistory()                           INLINE   ( HistoricosUsuariosModel():getHistory( ::cTableName ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD isUserAccess()

   ::nLevel                      := nLevelUsr( ::keyUserMap )

   if nAnd( ::nLevel, 1 ) != 0
      Return ( .f. )
   end if

Return ( .t. )

//---------------------------------------------------------------------------//
