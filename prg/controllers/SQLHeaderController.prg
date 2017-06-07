#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Ads.ch"

//---------------------------------------------------------------------------//

CLASS SQLHeaderController FROM SQLBaseController

   METHOD beginTransaction()                       INLINE ( getSQLDatabase():beginTransaction() )
   METHOD commitTransaction()                      INLINE ( getSQLDatabase():commit() )
   METHOD rollbackTransaction()                    INLINE ( getSQLDatabase():rollback() )

	METHOD   Append( oBrowse )
      METHOD initAppendMode()                      VIRTUAL
      METHOD endAppendMode()                       VIRTUAL
      METHOD cancelAppendMode()                    VIRTUAL

   METHOD   Duplicate( oBrowse )
      METHOD initDuplicateMode()                   VIRTUAL
      METHOD endDuplicateMode()                    VIRTUAL
      METHOD cancelDuplicateMode()                 VIRTUAL

   METHOD   Edit( oBrowse )
      METHOD initEditMode()                        VIRTUAL
      METHOD endEditMode()                         VIRTUAL
      METHOD cancelEditMode()                      VIRTUAL

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

   ::setAppendMode()

   if ::bOnPreAppend != nil
      lTrigger    := eval( ::bOnPreAppend )
      if Valtype( lTrigger ) == "L" .and. !lTrigger
         RETURN ( .f. )
      end if
   end if

   msgalert( "antes del init")

   ::initAppendMode()

   msgalert( "beginTransaction")

   ::beginTransaction()

   msgalert( hb_valtoexp( ::oModel ) ,"propiedades")

   nRecno         := ::oModel:getRowSetRecno()

   ::oModel:loadBlankBuffer()

   if ::oView:Dialog()

      ::oModel:insertBuffer()

      ::endAppendMode()

      ::commitTransaction()

      if ::bOnPostAppend != nil
         lTrigger    := eval( ::bOnPostAppend  )
         if Valtype( lTrigger ) == "L" .and. !lTrigger
            RETURN ( .f. )
         end if
      end if

   else 

      ::cancelAppendMode()

      ::rollbackTransaction()

      ::oModel:setRowSetRecno( nRecno ) 

      RETURN ( .f. )

   end if

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

   if oUser():lNotConfirmDelete() .or. msgNoYes( "�Desea eliminar " + cNumbersOfDeletes, "Confirme eliminaci�n" )
      ::oModel:deleteSelection( oBrowse:aSelected )
   end if 

   oBrowse:refreshCurrent()
   oBrowse:setFocus()

RETURN ( Self )

//----------------------------------------------------------------------------//
