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

   METHOD setTableToFilter( cTableToFilter ) INLINE ( ::getModel():setTableToFilter( cTableToFilter ) )
   METHOD getTableToFilter()                 INLINE ( ::getModel():getTableToFilter() )

   METHOD getDialogView()                    INLINE ( iif( empty( ::oDialogView ), ::oDialogView := SQLFilterView():New( self ), ), ::oDialogView )

   METHOD getCustomView()                    INLINE ( iif( empty( ::oCustomView ), ::oCustomView := SQLCustomFilterView():New( self ), ), ::oCustomView )
   
   METHOD getValidator()                     INLINE ( iif( empty( ::oValidator ), ::oValidator  := SQLFiltrosValidator():New( self ), ), ::oValidator )

   METHOD getModel()                         INLINE ( iif( empty( ::oModel ), ::oModel := SQLFiltrosModel():New( self ), ), ::oModel )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oController                             := oController

   ::getModel():setEvent( 'loadedBlankBuffer', {|| ::loadedBlankBuffer() } )

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

RETURN ( ::getModel():getFilters( cTableToFilter ) )

//---------------------------------------------------------------------------//

METHOD getFilterSentence( cNameFilter, cTableToFilter )

RETURN ( ::getModel():getFilterSentence( cNameFilter, cTableToFilter ) )

//---------------------------------------------------------------------------//

METHOD getId( cNameFilter, cTableToFilter )

RETURN ( ::getModel():getId( cNameFilter, cTableToFilter ) )

//---------------------------------------------------------------------------//

METHOD loadedBlankBuffer()

   local cTextFilter    := ::oController:oWindowsBar:getComboFilter()

   if empty( cTextFilter )
      RETURN ( nil )   
   end if 

   ::setModelBuffer( "nombre", cTextFilter ) 

   ::setModelBuffer( "filtro", cTextFilter ) 

RETURN ( nil )   

//---------------------------------------------------------------------------//

METHOD Append()

   if ::Super:Append()
      ::oController:oWindowsBar:addComboFilter( ::getModelBuffer( "nombre" ) )
      ::oController:oWindowsBar:setComboFilter( ::getModelBuffer( "nombre" ) )
   end if 

RETURN ( nil )   

//---------------------------------------------------------------------------//

METHOD DeleteByText( cNameFilter, cTableToFilter )

RETURN ( ::getModel():deleteById( { ::getId( cNameFilter, cTableToFilter ) } ) )   

//---------------------------------------------------------------------------//