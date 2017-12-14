#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS SQLFiltrosController FROM SQLBaseController

   DATA oSender 

   DATA hColumns

   DATA cTableName

   METHOD New()

   METHOD Dialog()                     INLINE ( ::oDialogView:Dialog() )

   METHOD setTableName( cTableName )   INLINE ( ::cTableName := cTableName )
   METHOD getTableName()               INLINE ( ::cTableName )

   METHOD setColumns()
   METHOD getColumns()                 INLINE ( ::hColumns )

   METHOD getFilters()
   METHOD getFilterSentence( cFilter ) 
   METHOD getId( cFilter )

   METHOD editByText( cFilter )        INLINE ( ::Edit( ::getId( cFilter ) ) )
   METHOD deleteByText( cFilter )      INLINE ( ::Delete( { ::getId( cFilter ) } ) )

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

   if empty( ::getTableName() )
      RETURN ( {} )
   end if 

RETURN ( ::oModel:getFilters( ::getTableName() ) )

//---------------------------------------------------------------------------//

METHOD getFilterSentence( cFilter )

   if empty( ::getTableName() )
      RETURN ( "" )
   end if 

RETURN ( ::oModel:getFilterSentence( cFilter, ::getTableName() ) )

//---------------------------------------------------------------------------//

METHOD getId( cFilter )

   if empty( ::getTableName() )
      RETURN ( 0 )
   end if 

RETURN ( ::oModel:getId( cFilter, ::getTableName() ) )

//---------------------------------------------------------------------------//

