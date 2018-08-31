#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS SQLFiltrosController FROM SQLBaseController

   DATA hColumns

   DATA cName

   DATA oCustomView

   METHOD New()
   METHOD End()

   METHOD Dialog()                           INLINE ( ::oDialogView:Dialog() )

   METHOD setColumns()
   METHOD getColumns()                       INLINE ( ::hColumns )

   METHOD getFilters()
   METHOD getFilterSentence( cFilter ) 
   METHOD getId( cFilter )

   METHOD Append()
   METHOD editByText( cFilter )              INLINE ( ::Edit( ::getId( cFilter ) ) )
   METHOD deleteByText( cFilter )      

   METHOD loadedBlankBuffer()

   METHOD setComboFilter( cText )            INLINE ( ::oSenderController:oWindowsBar:setComboFilter( cText ) )
   METHOD setComboFilterItem( cText )        INLINE ( ::oSenderController:oWindowsBar:setComboFilterItem( cText ) )
   METHOD showCleanButtonFilter()            INLINE ( ::oSenderController:oWindowsBar:showCleanButtonFilter() )

   METHOD setTableToFilter( cTableToFilter ) INLINE ( ::oModel:setTableToFilter( cTableToFilter ) )
   METHOD getTableToFilter()                 INLINE ( ::oModel:getTableToFilter() )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController )

   ::oSenderController                 := oSenderController

   ::oDialogView                       := SQLFilterView():New( self )

   ::oCustomView                       := SQLCustomFilterView():New( self )

   ::oModel                            := SQLFiltrosModel():New( self )
   
   ::oValidator                        := SQLFiltrosValidator():New( self )

   ::oModel:setEvent( 'loadedBlankBuffer', {|| ::loadedBlankBuffer() } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End()

   if !empty( ::oDialogView )
      ::oDialogView:End()
   end if 

   if !empty( ::oCustomView )
      ::oCustomView:End()
   end if 

   if !empty( ::oModel )
      ::oModel:End()
   end if 
   
   if !empty( ::oValidator )
      ::oValidator:End()
   end if 

   ::oSenderController                 := nil

   ::oDialogView                       := nil

   ::oCustomView                       := nil
   
   ::oModel                            := nil
   
   ::oValidator                        := nil
   
   Self                                := nil

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD setColumns( hColumns )

   DEFAULT hColumns                    := SQLMovimientosAlmacenModel():getColumns()

   ::hColumns                          := hColumns

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD getFilters( cTableToFilter )                 

RETURN ( ::oModel:getFilters( cTableToFilter ) )

//---------------------------------------------------------------------------//

METHOD getFilterSentence( cNameFilter, cTableToFilter )

RETURN ( ::oModel:getFilterSentence( cNameFilter, cTableToFilter ) )

//---------------------------------------------------------------------------//

METHOD getId( cNameFilter, cTableToFilter )

RETURN ( ::oModel:getId( cNameFilter, cTableToFilter ) )

//---------------------------------------------------------------------------//

METHOD loadedBlankBuffer()

   local cTextFilter    := ::oSenderController:oWindowsBar:getComboFilter()

   if empty( cTextFilter )
      RETURN ( Self )   
   end if 

   hset( ::oModel:hBuffer, "nombre", cTextFilter ) 
   hset( ::oModel:hBuffer, "filtro", cTextFilter ) 

RETURN ( Self )   

//---------------------------------------------------------------------------//

METHOD Append()

   if ::Super:Append()
      ::oSenderController:oWindowsBar:addComboFilter( hget( ::oModel:hBuffer, "nombre" ) )
      ::oSenderController:oWindowsBar:setComboFilter( hget( ::oModel:hBuffer, "nombre" ) )
   end if 

RETURN ( Self )   

//---------------------------------------------------------------------------//

METHOD DeleteByText( cNameFilter, cTableToFilter )

   ::oModel:deleteById( { ::getId( cNameFilter, cTableToFilter ) } )

RETURN ( Self )   

//---------------------------------------------------------------------------//