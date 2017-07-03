#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "Font.ch"

//---------------------------------------------------------------------------//

CLASS TMasterDetailGuid FROM TMasDet

   DATA  cGuid          

   METHOD newGuid()           INLINE ( ::setGuid( win_uuidcreatestring() ) )
   METHOD setGuid( cGuid )    INLINE ( ::cGuid  := cGuid )
   METHOD getGuid()           INLINE ( ::cGuid )

   METHOD Append( oBrw ) 

   METHOD endAppend( lAppend ) 

   METHOD LoadDetails()

END CLASS

//---------------------------------------------------------------------------//

METHOD Append( oBrw ) CLASS TMasterDetailGuid

   local lAppend
   local lTrigger

   if ::lMinimize .and. !empty( ::oWndBrw )
      ::oWndBrw:Minimize()
   end if

   if ::bOnPreAppend != nil
      lTrigger := Eval( ::bOnPreAppend, Self )
      if Valtype( lTrigger ) == "L" .and. !lTrigger
         return .f.
      end if
   end if

   ::nMode        := APPD_MODE

   ::newGuid()

   ::oDbf:Blank()
   ::oDbf:SetDefault()

   ::oDbf:cGuid   := ::getGuid()

   ::LoadDetails( .f. )

   lAppend        := ::Resource( 1 )

   if ::lAutoActions
      ::EndAppend( lAppend )
   end if

   if ::lMinimize .and. !empty( ::oWndBrw )
      ::oWndBrw:Maximize()
      ::oWndBrw:Refresh()
   end if

   if lAppend .and. !empty( oBrw )
      oBrw:Refresh()
   end if

   if ::bOnPostAppend != nil
      Eval( ::bOnPostAppend, Self )
   end if

return ( lAppend )

//---------------------------------------------------------------------------//

METHOD EndAppend( lAppend ) CLASS TMasterDetailGuid

   if lAppend

      ::getNewCount()

      ::oDbf:Insert()

      ::SaveDetails( APPD_MODE )

   else

      ::oDbf:Cancel()

   end if

   if !empty( ::oWndBrw )
      ::oWndBrw:Refresh()
   end if 

   ::CancelDetails()

return ( lAppend )

//---------------------------------------------------------------------------//

METHOD LoadDetails() CLASS TMasterDetailGuid

   if !hb_isarray( ::oDbfDet )
      RETURN ( Self )
   end if 

   msgalert( "LoadDetails" ) 

   aSend( ::oDbfDet, "Load()" )

RETURN ( Self )

//---------------------------------------------------------------------------//

