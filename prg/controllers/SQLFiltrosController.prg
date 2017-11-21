#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS SQLFiltrosController FROM SQLBaseController 

   DATA hColumns

   DATA cTable

   METHOD New()

   METHOD Dialog()            INLINE ( ::oDialogView:Dialog() )

   METHOD setTable( cTable )  INLINE ( ::cTable := cTable )
   METHOD getTable()          INLINE ( ::cTable )

   METHOD setColumns()
   METHOD getColumns()        INLINE ( ::hColumns )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::oDialogView           := SQLFilterView():New( self )

   ::oModel                := SQLFiltrosModel():New( self )

   ::oValidator            := SQLFiltrosValidator():New( self )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD setColumns( hColumns )

   DEFAULT hColumns        := SQLMovimientosAlmacenModel():getColumns()

   ::hColumns              := hColumns

Return ( Self )

//---------------------------------------------------------------------------//



