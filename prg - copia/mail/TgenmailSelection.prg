#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS TGenMailingSelection FROM TGenMailing 

   DATA oFilter

   DATA oBrwDatabase

   DATA oBntCreateFilter
   DATA oBntQuitFilter

   METHOD freeResources() 

   METHOD SelMailing()
      METHOD SelAllMailing( lValue )

   METHOD getDatabaseList()              
      METHOD addDatabaseList()            INLINE   ( iif( ( ::getWorkArea() )->lMail,;
                                                      aAdd( ::aMailingList, ::hashDatabaseList() ),;
                                                   ) )

   METHOD setItems( aItems )              INLINE   ( ::Super:setItems( aItems ),;
                                                   iif( !empty( ::oFilter ), ::oFilter:setFields( aItems ), ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD getDatabaseList() CLASS TGenMailingDatabase

   local nRecord

   CursorWait()

   ::aMailingList    := {}
   
   nRecord           := ( ::getWorkArea() )->( recno() )
   ( ::getWorkArea() )->( dbeval( {|| ::addDatabaseList() } ) )
   ( ::getWorkArea() )->( dbgoto( nRecord ) )

   CursorArrow()

Return ( ::aMailingList )

//--------------------------------------------------------------------------//

METHOD freeResources() CLASS TGenMailingDatabase

   ::Super:freeResources()

   if !empty(::oBmpDatabase)
      ::oBmpDatabase:end()
   end if 

   if !empty(::oFilter)
      ::oFilter:end()
   end if

Return ( Self )

//--------------------------------------------------------------------------//

METHOD dialogFilter() CLASS TGenMailingDatabase

   ::oFilter:Dialog()

   if !empty( ::oFilter:cExpresionFilter )
      ::buildFilter()
   else
      ::quitFilter()
   end if

Return ( Self )

//--------------------------------------------------------------------------//

METHOD buildFilter()

   createFastFilter( ::oFilter:cExpresionFilter, ::getWorkArea(), .f. )

   ::oBntCreateFilter:setText( "&Filtro activo" )

   ::oBntQuitFilter:Show()

   ::oBrwDatabase:Refresh()

Return ( Self )

//--------------------------------------------------------------------------//

METHOD quitFilter() CLASS TGenMailingDatabase

   destroyFastFilter( ::getWorkArea() )

   ::oBntCreateFilter:setText( "&Filtro" )

   ::oBntQuitFilter:Hide()

   ::oBrwDatabase:Refresh()

Return ( Self )

//--------------------------------------------------------------------------//

METHOD SelMailing( lValue ) CLASS TGenMailingDatabase

   DEFAULT lValue    := !( ::getWorkArea() )->lMail

   if dbDialogLock( ::getWorkArea() )
      ( ::getWorkArea() )->lMail   := lValue
      ( ::getWorkArea() )->( dbUnlock() )
   end if

   ::oBrwDatabase:Refresh()

Return ( Self )

//--------------------------------------------------------------------------//

METHOD SelAllMailing( lValue ) CLASS TGenMailingDatabase

   local hStatus

   DEFAULT lValue := .t.

   CursorWait()

   hStatus        := hGetStatus( ::getWorkArea(), 0 )
   ( ::getWorkArea() )->( dbeval( {|| ::selMailing( lValue ) } ) )
   hSetStatus( hStatus )

   CursorArrow()

Return ( Self )

//--------------------------------------------------------------------------//

