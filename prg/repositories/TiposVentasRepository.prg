#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS TiposVentasRepository FROM SQLBaseRepository

   METHOD getTableName()         INLINE ( if( !empty( ::getController() ), ::getModelTableName(), TiposVentasModel():getTableName() ) )

   METHOD getAll()
   METHOD getNombreWhereId()    

END CLASS

//---------------------------------------------------------------------------//

METHOD getAll() 

   local cSentence               := "SELECT * FROM " + ::getTableName()
   local hTiposVentas            := ::getDatabase():selectFetchHash( cSentence )

RETURN ( hTiposVentas )

//---------------------------------------------------------------------------//

METHOD getNombreWhereId( id ) 

   local cSentence               := "SELECT nombre FROM " + ::getTableName() + space( 1 ) + ;
                                       "WHERE id = " + quoted( id ) + space( 1 ) + ;
                                       "LIMIT 1"
   local hTiposVentas            := ::getDatabase():selectFetchHash( cSentence )

   if !empty( hTiposVentas )
      RETURN ( hget( atail( hTiposVentas ), "nombre" ) )
   end if 

RETURN ( "" )

//---------------------------------------------------------------------------//