#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS SQLFiltrosController FROM SQLBaseController

   DATA oSender 

   DATA hColumns

   DATA cName

   METHOD New()

   METHOD Dialog()                     INLINE ( ::oDialogView:Dialog() )

   METHOD setName( cName )             INLINE ( ::cName := cName )
   METHOD getName()                    INLINE ( if( empty( ::cName ), ::oSender:cName, ::cName ) )

   METHOD setColumns()
   METHOD getColumns()                 INLINE ( ::hColumns )

   METHOD getFilters()
   METHOD getFilterSentence( cFilter ) 
   METHOD getId( cFilter )

   METHOD Append()
   METHOD EditByText( cFilter )        INLINE ( ::Edit( ::getId( cFilter ) ) )
   METHOD DeleteByText( cFilter )      

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

METHOD getFilters()                 

   if empty( ::getName() )
      RETURN ( {} )
   end if 

RETURN ( ::oModel:getFilters( ::getName() ) )

//---------------------------------------------------------------------------//

METHOD getFilterSentence( cFilter )

   if empty( ::getName() )
      RETURN ( "" )
   end if 

RETURN ( ::oModel:getFilterSentence( cFilter, ::getName() ) )

//---------------------------------------------------------------------------//

METHOD getId( cFilter )

   if empty( ::getName() )
      RETURN ( 0 )
   end if 

RETURN ( ::oModel:getId( cFilter, ::getName() ) )

//---------------------------------------------------------------------------//

METHOD Append()

   if ::Super:Append()
      ::oSender:oWindowsBar:addComboFilter( hget( ::oModel:hBuffer, "nombre" ) )
      ::oSender:oWindowsBar:setComboFilter( hget( ::oModel:hBuffer, "nombre" ) )
   end if 

RETURN ( Self )   

//---------------------------------------------------------------------------//

METHOD DeleteByText( cFilter )

   if ::Delete( { ::getId( cFilter ) } ) 
      msgalert( "delete")
   end if 

RETURN ( Self )   

//---------------------------------------------------------------------------//
