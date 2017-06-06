#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Ads.ch"

//---------------------------------------------------------------------------//

CLASS SQLHeaderController FROM SQLBaseController

   METHOD New()

   METHOD buildControllersRowSetWithForeingKey( id )  
   METHOD clearControllersTmpIds()
   METHOD updateIdParentControllersInEdit( id )
   METHOD updateIdParentControllersInInsert()                

   METHOD beginTransaction()                          INLINE ( getSQLDatabase():beginTransaction() )
   METHOD commitTransaction()                         INLINE ( getSQLDatabase():commitTransaction() )
   METHOD rollbackTransaction()                       INLINE ( getSQLDatabase():rollbackTransaction() )

   METHOD initAppendMode()
   METHOD endAppendMode()
   METHOD cancelAppendMode()

   METHOD initDuplicateMode()
   METHOD endDuplicateMode()
   METHOD cancelDuplicateMode()

   METHOD initEditMode()
   METHOD endEditMode()
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

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD endAppendMode()

   ::commitTransaction()

   ::updateIdParentControllersInInsert()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD cancelAppendMode()

   ::rollbackTransaction()

RETURN ( self )

//----------------------------------------------------------------------------//

METHOD initDuplicateMode()

   ::clearControllersTmpIds()

   ::buildControllersRowSetWithForeingKey( ::getIdfromRowset() )

   ::beginTransaction()

RETURN ( self )

//----------------------------------------------------------------------------//

METHOD endDuplicateMode()

   ::commitTransaction()
   ::updateIdParentControllersInInsert()

RETURN ( self )

//----------------------------------------------------------------------------//

METHOD cancelDuplicateMode()

   ::rollbackTransaction()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD initEditMode()  

   ::clearControllersTmpIds()

   ::buildControllersRowSetWithForeingKey( ::getIdfromRowset() )

   ::beginTransaction()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD endEditMode()

   ::updateIdParentControllersInEdit( ::getIdfromRowset() )

   ::commitTransaction()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD cancelEditMode()

   ::rollbackTransaction()

RETURN ( self )

//----------------------------------------------------------------------------//

METHOD initZoomMode()

   ::clearControllersTmpIds()

   ::buildControllersRowSetWithForeingKey( ::oModel:hBuffer[ "id" ] )

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

