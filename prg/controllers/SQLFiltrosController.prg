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

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender )

   ::oSender                           := oSender

   ::oDialogView                       := SQLFilterView():New( self )

   ::oModel                            := SQLFiltrosModel():New( self )
   
   ::oModel:setEvent( 'insertingBuffer', {|| ::oModel:hBuffer[ "tabla" ] := ::getTableName() } )

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

   local aSentence

   if empty( ::getTableName() )
      RETURN ( "" )
   end if 

   aSentence   := ::oModel:getFilterSentence( cFilter, ::getTableName() )

   if empty( aSentence )
      RETURN ( "" )    
   end if 

RETURN ( atail( aSentence ) )

//---------------------------------------------------------------------------//

