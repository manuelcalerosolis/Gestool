#include "FiveWin.Ch"
#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS SQLAlbaranesComprasModel FROM SQLOperacionesComercialesModel

   DATA cPackage                       INIT "AlbaranesCompras"

   DATA cTableName                     INIT "albaranes_compras"

   METHOD getHashWhereUuid( aSelected )


END CLASS

//---------------------------------------------------------------------------//

METHOD getHashWhereUuid( cWhere ) CLASS SQLAlbaranesComprasModel
   
   local cSql
   local aSelected

   TEXT INTO cSql

      SELECT 
         *  
      FROM %1$s

      WHERE uuid %2$s

      Order by tercero_codigo
       
   ENDTEXT

   cSql  := hb_strformat(  cSql, ::getTableName(), cWhere )

RETURN ( ::getDatabase():selectFetchHash( cSQL ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
