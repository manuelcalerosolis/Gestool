#include "FiveWin.Ch" 
#include "Struct.ch"
#include "Factu.ch" 
#include "Ini.ch"
#include "MesDbf.ch" 

#define __tipoProducto__      1
#define __tipoCategoria__     2     

//---------------------------------------------------------------------------//

CLASS TComercioTax FROM TComercioConector

   DATA  idCategoryDefault  

   DATA  aTaxProducts                                       INIT {}

   METHOD cleanTaxRuleGroup()                               INLINE ( ::aTaxProducts := {} )
   
   METHOD getOrBuildTaxRulesGroup( id )
      METHOD buildTaxRuleGroup( id )  

   METHOD insertTaxesPrestashop()
      METHOD insertTaxPrestashop( hTax )

END CLASS

//---------------------------------------------------------------------------//

METHOD getOrBuildTaxRulesGroup( id )

   local hTax
   local idTaxRulesGroup   := ::TPrestashopId():getValueTaxRuleGroup( id, ::getCurrentWebName() )

   if empty( idTaxRulesGroup )

      ::cleanTaxRuleGroup()

      ::buildTaxRuleGroup( id )

      for each hTax in ::aTaxProducts

         idTaxRulesGroup   := ::insertTaxPrestashop( hTax )

      next

   end if 

RETURN ( idTaxRulesGroup )

//---------------------------------------------------------------------------//

METHOD buildTaxRuleGroup( id ) 
/*
   if !( ::isSyncronizeAll() )
      RETURN .f. 
   end if 
*/
   if aScan( ::aTaxProducts, {|h| hGet( h, "id" ) == id } ) != 0
      RETURN .f. 
   end if 

   if ::TPrestashopId():getValueTax( id, ::getCurrentWebName() ) != 0
      RETURN .f. 
   end if 

   if D():gotoTiposIva( id, ::getView() )
      aadd( ::aTaxProducts,   {  "id"     => id,;
                                 "rate"   => alltrim( str( ( D():TiposIva( ::getView() ) )->TpIva ) ),;
                                 "name"   => alltrim( ( D():TiposIva( ::getView() ) )->DescIva ) } )
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD insertTaxesPrestashop()

   local hTax

   ::meterProcesoSetTotal( len( ::aTaxProducts ) )

   for each hTax in ::aTaxProducts

      ::insertTaxPrestashop( hTax )

      ::meterProcesoText( "Subiendo impuestos " + alltrim(str(hb_enumindex())) + " de " + alltrim(str(len(::aTaxProducts))) )

   next

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD insertTaxPrestashop( hTax )

   local oQuery
   local idTax             := 0
   local cCommand          := ""  
   local idGroupWeb        := 0

   cCommand                := "INSERT IGNORE INTO " + ::cPreFixtable( "tax" ) + " ( " + ;
                                 "rate, " + ;
                                 "active ) " + ;
                              "VALUES ( " + ;
                                 "'" + hGet( hTax, "rate" ) + "', " + ;    // rate
                                 "'1' )"                                   // active

   if ::commandExecDirect( cCommand )
      idTax                := ::oConexionMySQLDatabase():GetInsertId()
      ::writeTextOk( hGet( hTax, "name" ), ::cPrefixTable( "tax" ) )
   else
      ::writeTextError( hGet( hTax, "name" ), ::cPrefixTable( "tax" ) )
      RETURN .f.
   end if

   // Insertamos un tipo de IVA nuevo en la tabla tax_lang------------------------

   cCommand                := "INSERT IGNORE INTO " + ::cPrefixTable( "tax_lang" ) + "( " +;
                                 "id_tax, " + ;
                                 "id_lang, " + ;
                                 "name ) " + ;
                              "VALUES ( " + ;
                                 "'" + alltrim( str( idTax ) ) + "', " + ;                                  // id_tax
                                 ::getLanguage() + ", " + ;                                                 // id_lang
                                 "'" + ::oConexionMySQLDatabase():Escapestr( hGet( hTax, "name" ) ) + "' )" // name

   if ::commandExecDirect( cCommand )
      ::writeTextOk( hGet( hTax, "name" ), ::cPrefixTable( "tax_lang" ) )
   else
      ::writeTextError( hGet( hTax, "name" ), ::cPrefixTable( "tax_lang" ) )
   end if

   // Insertamos un tipo de IVA nuevo en la tabla tax_rule_group------------------

   cCommand                := "INSERT IGNORE INTO "+ ::cPrefixTable( "tax_rules_group" ) + "( " + ;
                                 "name, " + ;
                                 "active ) " + ;
                              "VALUES ( " + ;
                                 "'" + ::oConexionMySQLDatabase():Escapestr( hGet( hTax, "name" ) ) + "', " + ;  // name
                                 "'1' )"                                                     // active

   if ::commandExecDirect( cCommand )
      idGroupWeb           := ::oConexionMySQLDatabase():GetInsertId()
      ::writeTextOk( hGet( hTax, "name" ), ::cPrefixTable( "tax_rule_group" ) )
   else
      ::writeTextError( hGet( hTax, "name" ), ::cPrefixTable( "tax_rule_group" ) )
   end if

   // Insertamos un tipo de IVA nuevo en la tabla tax_rule------------------------

   cCommand                := 'SELECT id_country FROM ' + ::cPrefixTable( "country" )
   oQuery                  := ::queryExecDirect( cCommand )

   if oQuery:Open() .and. oQuery:RecCount() > 0

      oQuery:GoTop()

      cCommand             := "INSERT IGNORE INTO " + ::cPrefixTable( "tax_rule" ) + "( " +;
                              "id_tax_rules_group, " + ;
                              "id_country, " + ;
                              "id_tax ) VALUES "

      while !oQuery:Eof()

         cCommand          += "( " + ;
                              "'" + alltrim( str( idGroupWeb ) ) + "', " + ;
                              "'" + AllTrim( str( oQuery:FieldGetByName( "id_country" ) ) ) + "', " + ;
                              "'" + alltrim( str( idTax ) ) + "' ), "

         oQuery:Skip()

      end while

   end if
   
   cCommand                := Substr( cCommand, 1, len( cCommand ) - 2 )

   if !::commandExecDirect( cCommand )
      ::writeTextError( hGet( hTax, "name" ), ::cPrefixTable( "tax_rule" ) )
   end if

   /*
   Insertamos un tipo de IVA nuevo en la tabla tax_rule------------------------
   */

   cCommand                := "INSERT IGNORE INTO " + ::cPrefixTable( "tax_rules_group_shop" ) + "( " +;
                                 "id_tax_rules_group, " + ;
                                 "id_shop ) " + ;
                              "VALUES ( " + ;
                                 "'" + alltrim( str( idGroupWeb ) ) + "', " + ;
                                 "'1' )"

   if !::commandExecDirect( cCommand )
      ::writeTextError( hGet( hTax, "name" ), ::cPrefixTable( "tax_rules_group_shop" ) )
   end if

   // Guardo referencia a la web-----------------------------------------------

   ::TPrestashopId():setValueTax(           hGet( hTax, "id" ), ::getCurrentWebName(), idTax )

   ::TPrestashopId():setValueTaxRuleGroup(  hGet( hTax, "id" ), ::getCurrentWebName(), idTax )

RETURN ( idTax )

//---------------------------------------------------------------------------//


