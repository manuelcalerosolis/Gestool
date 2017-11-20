#include "FiveWin.Ch"
#include "Factu.ch" 

//------------------------------------------------------------------//

CLASS ArticulosModel FROM ADSBaseModel

   METHOD getTableName()                     INLINE ::getEmpresaTableName( "Articulo" )

   METHOD exist()

   METHOD get()
   
   METHOD getField()

   METHOD getHash()

   METHOD getValoresPropiedades( cCodPro )

   METHOD getPrimerValorPropiedad( cCodPro, cArea )

   METHOD getArticulosToPrestaShopInFamilia( idFamilia, cWebShop, cArea )

END CLASS

//---------------------------------------------------------------------------//

METHOD exist( cCodigoArticulo )

   local cStm  
   local cSql  := "SELECT Nombre "                                      + ;
                     "FROM " + ::getTableName() + " "                   + ;
                     "WHERE Codigo = " + quoted( cCodigoArticulo ) 

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( ( cStm )->( lastrec() ) > 0 )
   end if 

RETURN ( .f. )

//---------------------------------------------------------------------------//

METHOD get( cCodigoArticulo )

   local cStm  
   local cSql  := "SELECT * "                                           + ;
                     "FROM " + ::getTableName() + " "                   + ;
                     "WHERE Codigo = " + quoted( cCodigoArticulo ) 

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( cStm )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getField( cCodigoArticulo, cField )

   local cStm  
   local cSql  := "SELECT " + cField + " "                              + ;
                     "FROM " + ::getTableName() + " "                   + ;
                     "WHERE Codigo = " + quoted( cCodigoArticulo ) 

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( ( cStm )->( fieldget( fieldpos( cField ) ) ) )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getHash( cCodigoArticulo )

   local cStm 
   local hRecord  
   
   cStm           := ::get( cCodigoArticulo )

   if !empty( cStm ) .and. ( ( cStm )->( lastrec() ) > 0 )
      hRecord     := getHashFromWorkArea( cStm )
   end if 

RETURN ( hRecord )

//---------------------------------------------------------------------------//

METHOD getValoresPropiedades( cCodPro, cArea ) CLASS ArticulosModel

   local cSql  := "SELECT * FROM " + ::getEmpresaTableName( "TblPro" )     + ;
                     " WHERE cCodPro = " + quoted( cCodPro )

Return ( ::ExecuteSqlStatement( cSql, @cArea ) )

//---------------------------------------------------------------------------//

METHOD getPrimerValorPropiedad( cCodPro, cArea ) CLASS ArticulosModel

   local cSql  := "SELECT TOP 1 * FROM " + ::getEmpresaTableName( "TblPro" ) + ;
                     " WHERE cCodPro = " + quoted( cCodPro ) + ""

Return ( ::ExecuteSqlStatement( cSql, @cArea ) )

//---------------------------------------------------------------------------//

METHOD getArticulosToPrestaShopInFamilia( idFamilia, cWebShop, cArea )

   local cSql  := "SELECT Codigo, cWebShop FROM " + ::getTableName()       + ;
                     " WHERE Familia = " + quoted( idFamilia ) + " AND "   + ;
                        "cWebShop = " + quoted( cWebShop ) + " AND "       + ;        
                        "lPubInt"

Return ( ::ExecuteSqlStatement( cSql, @cArea ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosPrecios FROM ADSBaseModel

   METHOD getTableName()                     INLINE ::getEmpresaTableName( "ArtDiv" )

   METHOD getFirstProperty()

   METHOD getSecondProperty()

   METHOD getProperties( cSql )

END CLASS

//---------------------------------------------------------------------------//

METHOD getFirstProperty( cCodigoArticulo, cCodigoPropiedad )

   local cSql           := "SELECT "                                                                                                   + ;
                              "line.cCodPr1 AS CodigoPropiedad, "                                                                      + ; 
                              "line.cValPr1 AS ValorPropiedad, "                                                                       + ; 
                              "header.cDesPro AS TipoPropiedad, "                                                                      + ; 
                              "header.lColor AS ColorPropiedad, "                                                                      + ; 
                              "property.cDesTbl AS CabeceraPropiedad, "                                                                + ;
                              "property.nColor AS RgbPropiedad "                                                                       + ;
                           "FROM " + ::getTableName() + " line "                                                                       + ;
                              "INNER JOIN " + PropiedadesModel():getTableName() + " header "                                           + ;
                              "ON header.cCodPro = line.cCodPr1 "                                                                      + ;
                              "INNER JOIN " + PropiedadesLineasModel():getTableName() + " property "                                   + ;
                              "ON property.cCodPro = line.cCodPr1  AND property.cCodTbl = line.cValPr1 "                               + ;
                           "WHERE line.cCodArt = " + quoted( cCodigoArticulo ) + " AND line.cCodPr1 = " + quoted( cCodigoPropiedad )   + ;
                           "GROUP BY "                                                                                                 + ;
                              "line.cCodPr1, "                                                                                         + ;
                              "line.cValPr1, "                                                                                         + ;
                              "header.cDesPro, "                                                                                       + ;
                              "header.lColor, "                                                                                        + ;
                              "property.cDesTbl, "                                                                                     + ;
                              "property.nColor" 

RETURN ( ::getProperties( cCodigoArticulo, cCodigoPropiedad, cSql ) )

//---------------------------------------------------------------------------//

METHOD getSecondProperty( cCodigoArticulo, cCodigoPropiedad )

   local cSql           := "SELECT "                                                                                                   + ;
                              "line.cCodPr2 AS CodigoPropiedad, "                                                                      + ; 
                              "line.cValPr2 AS ValorPropiedad, "                                                                       + ; 
                              "header.cDesPro AS TipoPropiedad, "                                                                      + ; 
                              "header.lColor AS ColorPropiedad, "                                                                      + ; 
                              "property.cDesTbl AS CabeceraPropiedad, "                                                                + ;
                              "property.nColor AS RgbPropiedad "                                                                       + ;
                           "FROM " + ::getTableName() + " line "                                                                       + ;
                              "INNER JOIN " + PropiedadesModel():getTableName() + " header "                                           + ;
                              "ON header.cCodPro = line.cCodPr2 "                                                                      + ;
                              "INNER JOIN " + PropiedadesLineasModel():getTableName() + " property "                                   + ;
                              "ON property.cCodPro = line.cCodPr2  AND property.cCodTbl = line.cValPr2 "                               + ;
                           "WHERE line.cCodArt = " + quoted( cCodigoArticulo ) + " AND line.cCodPr2 = " + quoted( cCodigoPropiedad )   + ;
                           "GROUP BY "                                                                                                 + ;
                              "line.cCodPr2, "                                                                                         + ;
                              "line.cValPr2, "                                                                                         + ;
                              "header.cDesPro, "                                                                                       + ;
                              "header.lColor, "                                                                                        + ;
                              "property.cDesTbl, "                                                                                     + ;
                              "property.nColor" 

RETURN ( ::getProperties( cCodigoArticulo, cCodigoPropiedad, cSql ) )

//---------------------------------------------------------------------------//

METHOD getProperties( cCodigoArticulo, cCodigoPropiedad, cSql )

   local cStm  
   local aPropiedades   := {}

   if ::ExecuteSqlStatement( cSql, @cStm )

      ( cStm )->( dbeval( ;
         {|| aadd( aPropiedades ,;
            {  "CodigoArticulo"     => rtrim( cCodigoArticulo ),;
               "CodigoPropiedad"    => rtrim( cCodigoPropiedad ),;
               "TipoPropiedad"      => rtrim( Field->TipoPropiedad ),;
               "ValorPropiedad"     => rtrim( Field->ValorPropiedad ),;
               "CabeceraPropiedad"  => rtrim( Field->CabeceraPropiedad ),;
               "ColorPropiedad"     => Field->ColorPropiedad,;
               "RgbPropiedad"       => Field->RgbPropiedad } ) } ) )

   end if 

RETURN ( aPropiedades )

//---------------------------------------------------------------------------//
