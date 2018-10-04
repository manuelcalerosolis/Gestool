#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS SQLFiltrosController FROM SQLBaseController

   DATA hColumns

   DATA cName

   DATA oCustomView

   METHOD New() CONSTRUCTOR
   METHOD End()

   METHOD Dialog()                           INLINE ( ::getDialogView():Dialog() )

   METHOD setColumns( hColumns )             INLINE ( ::hColumns := hColumns )
   METHOD getColumns()                       INLINE ( ::hColumns )

   METHOD getFilters()
   METHOD getFilterSentence( cFilter ) 
   METHOD getId( cFilter )

   METHOD Append()
   METHOD editByText( cFilter )              INLINE ( ::Edit( ::getId( cFilter ) ) )
   METHOD deleteByText( cFilter )      

   METHOD loadedBlankBuffer()

   METHOD setComboFilter( cText )            INLINE ( ::oController:oWindowsBar:setComboFilter( cText ) )
   METHOD setComboFilterItem( cText )        INLINE ( ::oController:oWindowsBar:setComboFilterItem( cText ) )
   METHOD showCleanButtonFilter()            INLINE ( ::oController:oWindowsBar:showCleanButtonFilter() )

   METHOD setTableToFilter( cTableToFilter ) INLINE ( ::oModel:setTableToFilter( cTableToFilter ) )
   METHOD getTableToFilter()                 INLINE ( ::oModel:getTableToFilter() )

   METHOD getDialogView()                    INLINE ( iif( empty( ::oDialogView ), ::oDialogView := SQLFilterView():New( self ), ), ::oDialogView )

   METHOD getCustomView()                    INLINE ( iif( empty( ::oCustomView ), ::oCustomView := SQLCustomFilterView():New( self ), ), ::oCustomView )
   
   METHOD getValidator()                     INLINE ( iif( empty( ::oValidator ),  ::oValidator  := SQLFiltrosValidator():New( self ), ), ::oValidator )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oController                             := oController

   ::oModel                                  := SQLFiltrosModel():New( self )

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

RETURN ( ::Super:End() )

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

   local cTextFilter    := ::oController:oWindowsBar:getComboFilter()

   if empty( cTextFilter )
      RETURN ( nil )   
   end if 

   hset( ::oModel:hBuffer, "nombre", cTextFilter ) 

   hset( ::oModel:hBuffer, "filtro", cTextFilter ) 

RETURN ( nil )   

//---------------------------------------------------------------------------//

METHOD Append()

   if ::Super:Append()
      ::oController:oWindowsBar:addComboFilter( hget( ::oModel:hBuffer, "nombre" ) )
      ::oController:oWindowsBar:setComboFilter( hget( ::oModel:hBuffer, "nombre" ) )
   end if 

RETURN ( nil )   

//---------------------------------------------------------------------------//

METHOD DeleteByText( cNameFilter, cTableToFilter )

   ::oModel:deleteById( { ::getId( cNameFilter, cTableToFilter ) } )

RETURN ( nil )   

//---------------------------------------------------------------------------//