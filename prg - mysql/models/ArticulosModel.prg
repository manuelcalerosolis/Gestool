#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ArticulosModel FROM BaseModel

   METHOD getHeaderTableName()                  INLINE ::getEmpresaTableName( "Articulo" )

   METHOD getValoresPropiedades( cCodPro )

   METHOD getPrimerValorPropiedad( cCodPro, cArea )

   METHOD getArticulosToPrestaShopInFamilia( idFamilia, cWebShop, cArea )

END CLASS

//---------------------------------------------------------------------------//

METHOD getValoresPropiedades( cCodPro, cArea ) CLASS ArticulosModel

   local cSql  := "SELECT * FROM " + ::getEmpresaTableName( "TblPro" ) + ;
                     " WHERE cCodPro = " + quoted( cCodPro )

Return ( ::ExecuteSqlStatement( cSql, @cArea ) )

//---------------------------------------------------------------------------//

METHOD getPrimerValorPropiedad( cCodPro, cArea ) CLASS ArticulosModel

   local cSql  := "SELECT TOP 1 * FROM " + ::getEmpresaTableName( "TblPro" ) + ;
                     " WHERE cCodPro = " + quoted( cCodPro ) + ""

Return ( ::ExecuteSqlStatement( cSql, @cArea ) )

//---------------------------------------------------------------------------//

METHOD getArticulosToPrestaShopInFamilia( idFamilia, cWebShop, cArea )

   local cSql  := "SELECT Codigo, cWebShop FROM " + ::getHeaderTableName() + ;
                     " WHERE Familia = " + quoted( idFamilia ) + " AND "   + ;
                        "cWebShop = " + quoted( cWebShop ) + " AND "       + ;        
                        "lPubInt"

Return ( ::ExecuteSqlStatement( cSql, @cArea ) )

//---------------------------------------------------------------------------//
