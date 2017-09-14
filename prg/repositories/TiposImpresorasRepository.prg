#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS TiposImpresorasRepository FROM SQLBaseRepository

   METHOD getTableName()      INLINE ( if( !empty( ::getController() ), ::getModelTableName(), TiposImpresorasModel():getTableName() ) )

   METHOD getAll()

END CLASS

//---------------------------------------------------------------------------//

METHOD getAll() 

   local cSentence               := "SELECT nombre FROM " + ::getTableName()
   local aNombresImpresoras      := getSQLDatabase():selectFetchArrayOneColumn( cSentence )

   ains( aNombresImpresoras, 1, "", .t. )

RETURN ( aNombresImpresoras )

//---------------------------------------------------------------------------//





