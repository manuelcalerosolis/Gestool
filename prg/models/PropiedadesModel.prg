#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS PropiedadesModel FROM ADSBaseModel

   METHOD getTableName()                     INLINE ::getEmpresaTableName( "Pro" )

   MESSAGE getNombre( cCodigoPropiedad )     INLINE ::getField( "cDesPro", "cCodPro", cCodigoPropiedad )

END CLASS

//---------------------------------------------------------------------------//
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

   METHOD getPropiedadesGeneral( cCodigoPropiedad )

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
      RETURN ( alltrim( ( cStm )->cDesTbl ) )
   end if 

RETURN ( "" )

//---------------------------------------------------------------------------//

METHOD getPropiedadesGeneral( cCodigoArticulo, cCodigoPropiedad )

   local aPropiedades   := {}
   local cStm
   local cSql           := "SELECT "                                                            + ;
                              "header.cDesPro AS TipoPropiedad, "                               + ; 
                              "header.lColor AS ColorPropiedad, "                               + ; 
                              "line.cCodTbl AS ValorPropiedad, "                                + ; 
                              "line.nColor AS RgbPropiedad, "                                   + ; 
                              "line.cDesTbl AS CabeceraPropiedad "                              + ;
                           "FROM " + ::getTableName() + " line "                                + ;
                              "INNER JOIN " + PropiedadesModel():getTableName() + " header "    + ;
                              "ON header.cCodPro = " + quoted( cCodigoPropiedad )         

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



