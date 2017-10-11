#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS PropiedadesModel FROM ADSBaseModel

   METHOD getTableName()                     INLINE ::getEmpresaTableName( "Pro" )

   METHOD getNombre( cCodigoPropiedad )

END CLASS

//---------------------------------------------------------------------------//

METHOD getNombre( cCodigoPropiedad ) CLASS PropiedadesModel

   local cStm
   local cSql  := "SELECT cDesPro "                                     + ;
                     "FROM " + ::getTableName() + " "                   + ;
                     "WHERE cCodPro = " + quoted( cCodigoPropiedad ) 

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( ( cStm )->cDesPro )
   end if 

RETURN ( "" )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS PropiedadesLineasModel FROM ADSBaseModel

   METHOD getTableName()                     INLINE ::getEmpresaTableName( "TblPro" )

   METHOD exist()

   METHOD getNombre()

END CLASS

//---------------------------------------------------------------------------//

METHOD exist( cCodigoPropiedad, cValorPropiedad ) CLASS PropiedadesLineasModel

   local cStm
   local cSql  := "SELECT cDesTbl "                                     		+ ;
                     "FROM " + ::getTableName() + " "                   		+ ;
                     "WHERE cCodPro = " + quoted( cCodigoPropiedad ) + " " 	+ ;
                     	"AND cCodTbl = " + quoted( cValorPropiedad )

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( ( cStm )->( lastrec() ) > 0 )
   end if 

RETURN ( "" )

//---------------------------------------------------------------------------//

METHOD getNombre( cCodigoPropiedad, cValorPropiedad ) CLASS PropiedadesLineasModel

   local cStm
   local cSql  := "SELECT cDesTbl "                                     		+ ;
                     "FROM " + ::getTableName() + " "                   		+ ;
                     "WHERE cCodPro = " + quoted( cCodigoPropiedad ) + " " 	+ ;
                     	"AND cCodTbl = " + quoted( cValorPropiedad )

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( ( cStm )->cDesTbl )
   end if 

RETURN ( "" )

//---------------------------------------------------------------------------//

