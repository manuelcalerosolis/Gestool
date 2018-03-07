#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS CajasModel FROM ADSBaseModel

   METHOD getTableName()                     INLINE ::getDatosTableName( "Cajas" )

   METHOD aNombres()
   METHOD aNombresSeleccionables()           INLINE ( ains( ::aNombres(), 1, "", .t. ) )

   METHOD getUuidFromNombre( cNombre )       INLINE ( ::getField( "Uuid", "cNomCaj", cNombre ) )
   METHOD getNombreFromUuid( cUuid )         INLINE ( ::getField( "cNomCaj", "Uuid", cUuid ) ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD aNombres()

   local cStm
   local aEmp  := {}
   local cSql  := "SELECT * FROM " + ::getTableName() 

   if !::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( aEmp )
   endif 

   while !( cStm )->( eof() ) 
      aadd( aEmp, alltrim( ( cStm )->cNomCaj ) )
      ( cStm )->( dbskip() )
   end while

RETURN ( aEmp )

//---------------------------------------------------------------------------//

