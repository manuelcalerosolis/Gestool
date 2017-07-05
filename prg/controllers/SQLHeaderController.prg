#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Ads.ch"

//---------------------------------------------------------------------------//

CLASS SQLHeaderController FROM SQLBaseController

   METHOD getHistoryOfBrowsers()
   METHOD saveHistoryOfBrowsers()

   METHOD buildControllersRowSetWithForeingKey( id )  
   METHOD clearControllersTmpIds()
   METHOD updateIdParentControllersInEdit( id )
   METHOD updateIdParentControllersInInsert()                

   METHOD beginTransaction()                       INLINE ( getSQLDatabase():beginTransaction() )
   METHOD commitTransaction()                      INLINE ( getSQLDatabase():commit() )
   METHOD rollbackTransaction()                    INLINE ( getSQLDatabase():rollback() )

   METHOD   Append( oBrowse )
   
   METHOD   Duplicate( oBrowse )
      METHOD initDuplicateMode()                   
      METHOD endDuplicateMode()                    VIRTUAL
      METHOD cancelDuplicateMode()                 
      METHOD endDuplicateModePosInsert()

   METHOD   Edit( oBrowse )
      METHOD initEditMode()                        
      METHOD endEditMode()                         VIRTUAL
      METHOD cancelEditMode()                      
      METHOD endEditModePosUpdate()

   METHOD   Zoom( oBrowse )
      METHOD initZoomMode()                        VIRTUAL
      METHOD endZoomMode()                         VIRTUAL
      METHOD cancelZoomMode()                      VIRTUAL

   METHOD   Delete( oBrowse )
      METHOD initDeleteMode()                      VIRTUAL
      METHOD endDeleteMode()                       VIRTUAL
      METHOD cancelDeleteMode()                    VIRTUAL

END CLASS

//---------------------------------------------------------------------------//

METHOD Append( oBrowse )

   local nRecno   
   local lTrigger

   if ::notUserAppend()
      msgStop( "Acceso no permitido." )
      RETURN ( .f. )
   end if 

   if !::evalOnPreAppend()
      RETURN ( .f. )
   end if

   ::setAppendMode()

   ::initAppendMode()

   ::clearControllersTmpIds()

   ::buildControllersRowSetWithForeingKey( 0 )

   ::getHistoryOfBrowsers()

   ::beginTransaction()

   nRecno         := ::oModel:getRowSetRecno()

   ::oModel:loadBlankBuffer()

   if ::oView:Dialog()
   
      ::endAppendModePreInsert()

      ::oModel:insertBuffer()

      ::commitTransaction()

      ::updateIdParentControllersInInsert()

      ::endAppendModePostInsert()

      ::evalOnPostAppend()

   else 

      ::rollbackTransaction()

      ::cancelAppendMode()

      ::oModel:setRowSetRecno( nRecno ) 

      RETURN ( .f. )

   end if

   ::saveHistoryOfBrowsers()

   if !empty( oBrowse )
      oBrowse:refreshCurrent()
      oBrowse:setFocus()
   end if

RETURN ( .t. )

//----------------------------------------------------------------------------//

METHOD Duplicate( oBrowse )

   local nRecno   

   if ::notUserDuplicate()
      msgStop( "Acceso no permitido." )
      RETURN ( Self )
   end if 

   ::setDuplicateMode()

   nRecno         := ::oModel:getRowSetRecno()

   ::oModel:loadCurrentBuffer()

   if ::oView:Dialog( ::oModel )
      ::oModel:insertBuffer()
   else 
      ::oModel:setRowSetRecno( nRecno ) 
   end if

   if !empty( oBrowse )
      oBrowse:refreshCurrent()
      oBrowse:setFocus()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD initDuplicateMode()

   ::clearControllersTmpIds()

   ::buildControllersRowSetWithForeingKey( ::getIdfromRowset() )

   ::getHistoryOfBrowsers()

RETURN ( self )

//----------------------------------------------------------------------------//

METHOD endDuplicateModePosInsert()

   ::updateIdParentControllersInInsert()

   ::saveHistoryOfBrowsers()

RETURN ( self )

//----------------------------------------------------------------------------//

METHOD cancelDuplicateMode()

   ::saveHistoryOfBrowsers()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Edit( oBrowse )  

   if ::notUserEdit()
      msgStop( "Acceso no permitido." )
      RETURN ( Self )
   end if 

   ::setEditMode()

   ::preEdit()

   ::oModel:setIdForRecno( ::oModel:getKeyFieldOfRecno() )

   ::oModel:loadCurrentBuffer()

   if ::oView:Dialog( ::oModel )
      
      ::oModel:updateCurrentBuffer()

      ::postEdit()

   end if 

   if !empty( oBrowse )
      oBrowse:refreshCurrent()
      oBrowse:setFocus()
   end if 

RETURN ( .t. )

//----------------------------------------------------------------------------//

METHOD Zoom( oBrowse )

   if ::notUserZoom()
      msgStop( "Acceso no permitido." )
      RETURN ( Self )
   end if 

   ::setZoomMode()

   ::oModel:loadCurrentBuffer()

   ::oView:Dialog( ::oModel )

   if !empty( oBrowse )
      oBrowse:setFocus()
   end if 

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

METHOD Delete( oBrowse )

   local nSelected      
   local cNumbersOfDeletes

   if ::notUserDelete()
      msgStop( "Acceso no permitido." )
      RETURN ( Self )
   end if 

   if empty( oBrowse )
      msgStop( "Faltan parametros." )
      RETURN ( Self )
   end if 

   nSelected            := len( oBrowse:aSelected )

   if nSelected > 1
      cNumbersOfDeletes := alltrim( str( nSelected, 3 ) ) + " registros?"
   else
      cNumbersOfDeletes := "el registro en curso?"
   end if

   if oUser():lNotConfirmDelete() .or. msgNoYes( "¿Desea eliminar " + cNumbersOfDeletes, "Confirme eliminación" )
      ::oModel:deleteSelection( oBrowse:aSelected )
   end if 

   oBrowse:refreshCurrent()
   oBrowse:setFocus()

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

