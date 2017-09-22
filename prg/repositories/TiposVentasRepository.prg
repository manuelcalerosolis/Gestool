#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS TiposVentasRepository FROM SQLBaseRepository

   METHOD getTableName()         INLINE ( if( !empty( ::getController() ), ::getModelTableName(), TiposVentasModel():getTableName() ) )

   METHOD getAll()

END CLASS

//---------------------------------------------------------------------------//

METHOD getAll() 

   local cSentence               := "SELECT * FROM " + ::getTableName()
   local aTiposVentas            := ::getDatabase():selectFetchHash( cSentence )

RETURN ( aTiposVentas )

//---------------------------------------------------------------------------//