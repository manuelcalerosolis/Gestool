#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenController FROM SQLHeaderController

   METHOD   New()

   METHOD   buildSQLModel( this )         INLINE ( SQLMovimientosAlmacenModel():New( this ) )
   
   METHOD   buildSQLView( this )				INLINE ( MovimientosAlmacenView():New( this ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::idUserMap             := "01050"

   ::setTitle( "Movimientos almacen" )

   ::Super:New()

Return ( Self )

//---------------------------------------------------------------------------//




