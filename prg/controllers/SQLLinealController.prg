#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS SQLLinealController FROM  SQLBaseController

   METHOD Append()

END CLASS

//---------------------------------------------------------------------------//

METHOD Append() CLASS SQLLinealController

   local nId
   local lAppend     := .t.   

   if ::notUserAppend()
      msgStop( "Acceso no permitido." )
      RETURN ( .f. )
   end if 

   if isFalse( ::fireEvent( 'appending' ) )
      RETURN ( .f. )
   end if

   ::setAppendMode()

   ::saveRowSetRecno()

   nId               := ::oModel:insertBlankBuffer()

   if !empty( nId )

      ::fireEvent( 'appended' ) 

      ::refreshRowSetAndFindId( nId )

   else 
      
      lAppend        := .f.

      ::refreshRowSet()

   end if 

   ::refreshBrowseView()

   ::fireEvent( 'exitAppended' ) 

   if lAppend
      ::oBrowseView:setFocus()
      ::oBrowseView:selectCol( ::oBrowseView:oColumnCodigo:nPos )
   end if 

RETURN ( lAppend )

//----------------------------------------------------------------------------//
