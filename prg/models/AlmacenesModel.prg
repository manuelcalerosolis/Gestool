#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS AlmacenesModel FROM ADSBaseModel

   METHOD getTableName()                     INLINE ::getEmpresaTableName( "Almacen" )

   METHOD exist()

   METHOD getNombre( idAlamcen )             INLINE ( ::getField( "cNomAlm", "cCodAlm", idAlamcen ) )

   METHOD aNombres()
   METHOD aNombresSeleccionables()           INLINE ( ains( ::aNombres(), 1, "", .t. ) )

   METHOD getUuidFromNombre( cNombre )       INLINE ( ::getField( "Uuid", "cNomAlm", cNombre ) )
   METHOD getNombreFromUuid( cUuid )         INLINE ( ::getField( "cNomAlm", "Uuid", cUuid ) )

   METHOD getCodigoFromNombre( cNombre )     INLINE ( ::getField( "cCodAlm", "cNomAlm", cNombre ) )
   METHOD getNombreFromCodigo( cCodigo )     INLINE ( ::getField( "cNomAlm", "cCodAlm", cCodigo ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD exist( cCodigoAlmacen )

   local cStm
   local cSql  := "SELECT cNomAlm "                               + ;
                     "FROM " + ::getTableName() + " "             + ;
                     "WHERE cCodAlm = " + quoted( cCodigoAlmacen ) 

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( ( cStm )->( lastrec() ) > 0 )
   end if 

RETURN ( .f. )

//---------------------------------------------------------------------------//

METHOD aNombres()

   local cStm
   local aAlm  := {}
   local cSql  := "SELECT * FROM " + ::getTableName() 

   if !::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( aAlm )
   endif 

   while !( cStm )->( eof() ) 
      aadd( aAlm, alltrim( ( cStm )->cNomAlm ) )
      ( cStm )->( dbskip() )
   end while

RETURN ( aAlm )

//---------------------------------------------------------------------------//


