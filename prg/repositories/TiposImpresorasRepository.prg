#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS TiposImpresorasRepository FROM SQLBaseRepository

   METHOD getTableName()         INLINE ( if( !empty( ::getController() ), ::getModelTableName(), SQLTiposImpresorasModel():getTableName() ) )

   METHOD getNombres()

END CLASS

//---------------------------------------------------------------------------//

METHOD getNombres() 

   local cSentence               := "SELECT nombre FROM " + ::getTableName()
   local aNombresImpresoras      := ::getDatabase():selectFetchArrayOneColumn( cSentence )

   ains( aNombresImpresoras, 1, "", .t. )

RETURN ( aNombresImpresoras )

//---------------------------------------------------------------------------//