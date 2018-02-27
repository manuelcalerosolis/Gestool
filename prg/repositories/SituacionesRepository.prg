#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS SituacionesRepository FROM SQLBaseRepository

   METHOD getTableName()         INLINE ( if( !empty( ::getController() ), ::getModelTableName(), SQLSituacionesModel():getTableName() ) )

   METHOD getNombres() 

END CLASS

//---------------------------------------------------------------------------//

METHOD getNombres() 

   local cSentence               := "SELECT nombre FROM " + ::getTableName()
   local aNombres                := ::getDatabase():selectFetchArrayOneColumn( cSentence )

RETURN ( aNombres )

//---------------------------------------------------------------------------//
