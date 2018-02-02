#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS SQLFiltrosController FROM SQLBaseController

   DATA oSender 

   DATA hColumns

   DATA cName

   METHOD New()

   METHOD Dialog()                           INLINE ( ::oDialogView:Dialog() )

   METHOD setColumns()
   METHOD getColumns()                       INLINE ( ::hColumns )

   METHOD getFilters()
   METHOD getFilterSentence( cFilter ) 
   METHOD getId( cFilter )

   METHOD Append()
   METHOD EditByText( cFilter )              INLINE ( ::Edit( ::getId( cFilter ) ) )
   METHOD DeleteByText( cFilter )      

   METHOD setTableToFilter( cTableToFilter ) INLINE ( ::oModel:setTableToFilter( cTableToFilter ) )
   METHOD getTableToFilter()                 INLINE ( ::oModel:getTableToFilter() )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender )

   ::oSender                           := oSender

   ::oDialogView                       := SQLFilterView():New( self )

   ::oModel                            := SQLFiltrosModel():New( self )
   
   ::oValidator                        := SQLFiltrosValidator():New( self )

RETURN ( Self )

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

METHOD Append()

   if ::Super:Append()
      ::oSender:oWindowsBar:addComboFilter( hget( ::oModel:hBuffer, "nombre" ) )
      ::oSender:oWindowsBar:setComboFilter( hget( ::oModel:hBuffer, "nombre" ) )
   end if 

RETURN ( Self )   

//---------------------------------------------------------------------------//

METHOD DeleteByText( cNameFilter, cTableToFilter )

      ::oModel:deleteById( { ::getId( cNameFilter, cTableToFilter ) } )

RETURN ( Self )   

//---------------------------------------------------------------------------//
