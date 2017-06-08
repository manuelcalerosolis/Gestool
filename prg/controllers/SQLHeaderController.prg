#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Ads.ch"

//---------------------------------------------------------------------------//

CLASS SQLHeaderController FROM SQLBaseController

   METHOD New()

   METHOD getHistoryOfBrowsers()
   METHOD saveHistoryOfBrowsers()

   METHOD buildControllersRowSetWithForeingKey( id )  
   METHOD clearControllersTmpIds()
   METHOD updateIdParentControllersInEdit( id )
   METHOD updateIdParentControllersInInsert()                

   METHOD beginTransaction()                          INLINE ( getSQLDatabase():beginTransaction() )
   METHOD commitTransaction()                         INLINE ( getSQLDatabase():commitTransaction() )
   METHOD rollbackTransaction()                       INLINE ( getSQLDatabase():rollbackTransaction() )

   METHOD initAppendMode()
   METHOD endAppendModePosInsert()
   METHOD cancelAppendMode()

   METHOD initDuplicateMode()
   METHOD endDuplicateModePosInsert()
   METHOD cancelDuplicateMode()

   METHOD initEditMode()
   METHOD endEditModePosUpdate()
   METHOD cancelEditMode()

   METHOD initZoomMode()

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::Super:New()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD initAppendMode()

   ::clearControllersTmpIds()

   ::buildControllersRowSetWithForeingKey( 0 )

   ::beginTransaction()

   ::getHistoryOfBrowsers()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD endAppendModePosInsert()

   ::commitTransaction()

   ::updateIdParentControllersInInsert()

   ::saveHistoryOfBrowsers()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD cancelAppendMode()

   ::rollbackTransaction()

   ::saveHistoryOfBrowsers()

RETURN ( self )

//----------------------------------------------------------------------------//

METHOD initDuplicateMode()

   ::clearControllersTmpIds()

   ::buildControllersRowSetWithForeingKey( ::getIdfromRowset() )

   ::beginTransaction()

   ::getHistoryOfBrowsers()

RETURN ( self )

//----------------------------------------------------------------------------//

METHOD endDuplicateModePosInsert()

   ::commitTransaction()
   ::updateIdParentControllersInInsert()

   ::saveHistoryOfBrowsers()

RETURN ( self )

//----------------------------------------------------------------------------//

METHOD cancelDuplicateMode()

   ::rollbackTransaction()

   ::saveHistoryOfBrowsers()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD initEditMode()  

   ::clearControllersTmpIds()

   ::buildControllersRowSetWithForeingKey( ::getIdfromRowset() )

   ::beginTransaction()

   ::getHistoryOfBrowsers()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD endEditModePosUpdate()

   ::updateIdParentControllersInEdit( ::getIdfromRowset() )

   ::commitTransaction()

   ::saveHistoryOfBrowsers()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD cancelEditMode()

   ::rollbackTransaction()

   ::saveHistoryOfBrowsers()

RETURN ( self )

//----------------------------------------------------------------------------//

METHOD initZoomMode()

   ::clearControllersTmpIds()

   ::buildControllersRowSetWithForeingKey( ::oModel:hBuffer[ "id" ] )

   ::getHistoryOfBrowsers()

RETURN ( Self )

//----------------------------------------------------------------------------//


METHOD buildControllersRowSetWithForeingKey( id )  

RETURN ( hEval( ::ControllerContainer:getControllers(), {| k, oController| oController:oModel:buildRowSetWithForeignKey( id ) } ) )

//----------------------------------------------------------------------------//

METHOD clearControllersTmpIds()

RETURN ( hEval( ::ControllerContainer:getControllers(), { | k, oController| oController:oModel:resetTmpIds() } ) )

//----------------------------------------------------------------------------//

METHOD updateIdParentControllersInEdit( id )

RETURN ( hEval( ::ControllerContainer:getControllers(), { | k, oController| oController:oModel:confirmIdParentToChildsOf( ::getIdfromRowset() ) } ) )

//----------------------------------------------------------------------------//

METHOD updateIdParentControllersInInsert()

   local lastId :=  getSQLDatabase():LastInsertId()

RETURN ( hEval( ::ControllerContainer:getControllers(), { | k, oController| oController:oModel:confirmIdParentToChildsOf( lastId ) } ) )

//----------------------------------------------------------------------------//

METHOD getHistoryOfBrowsers()

RETURN ( hEval( ::ControllerContainer:getControllers(), { | k, oController| oController:getHistoryBrowse() } ) )

//----------------------------------------------------------------------------//

METHOD saveHistoryOfBrowsers()

RETURN ( hEval( ::ControllerContainer:getControllers(), { | k, oController| oController:saveHistoryBrowse() } ) )

//----------------------------------------------------------------------------//

