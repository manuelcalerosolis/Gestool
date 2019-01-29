//-- copyright
// hbunit is a unit-testing framework for the Harbour language.
//
// Copyright (C) 2014 Enderson maia <endersonmaia _at_ gmail _dot_ com>
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// See COPYRIGHT for more details.
//++

#include "hbunit.ch"

//---------------------------------------------------------------------------//

USER FUNCTION hbunit_test()

   local oRunner   := TextRunner():New()
   local oSuite    := TestSuite():New()

   oSuite:addTest( TestAssert():New() )

   oSuite:addTest( TestEmpresasController():New() )

   oSuite:addTest( TestArticulosController():New() )

   oSuite:addTest( TestCaracteristicasController():New() )

   oSuite:addTest( TestCaracteristicasLineasController():New() )

   oSuite:addTest( TestCaracteristicasValoresArticulosController():New() )

   oSuite:addTest( TestUnidadesMedicionController():New() )

   oSuite:addTest( TestUnidadesMedicionGruposController():New() )

   oSuite:addTest( TestArticulosTarifasController():New() )

   oSuite:addTest( TestArticulosTarifasController():New() )

   oSuite:addTest( TestAlmacenesController():New() )

   oSuite:addTest( TestTercerosController():New() )

   oSuite:addTest( TestTercerosGruposController():New() )

   oSuite:addTest( TestEntidadesController():New() )

   oSuite:addTest( TestFacturasClientesFacturaeController():New() )

   oSuite:addTest( TestPagosController():New() )

   oSuite:addTest( TestPagosAssistantController():New() )

   oSuite:addTest( TestAlbaranesComprasController():New() )

   oSuite:addTest( TestFacturasVentasController():New() )

   oSuite:addTest( TestConsolidacionAlmacenController():New() )

   oSuite:addTest( TestMovimientoAlmacenController():New() )

   oSuite:addTest( TestStocksRepository():New() )

   oSuite:setCategories( { "stocks" } )

   oRunner:run( oSuite )

   oSuite:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

CLASS TestAssert FROM TestCase

   METHOD testAssertErrors()
   METHOD testLogicals()
   METHOD testAssertErrors()
   METHOD testAssertEquals()
   METHOD testAssertNotEquals()
   METHOD testAssertNull()
   METHOD testAssertNotNull()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD testAssertErrors() CLASS TestAssert

   local a
   local oError
/*
   BEGIN SEQUENCE
      a := 1/0
      ::fail( "division by zero not caught" )
   RECOVER USING oError
   END

   BEGIN SEQUENCE
      ::assert( a, "test variable not found" )
      ::getAssert():fail( "unable to catch 'Variable not found'" )
   RECOVER
   END
*/

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testLogicals() CLASS TestAssert

   ::getAssert():true( .t., "test ::getAssert():true with .t." )
   ::getAssert():false( .f., "test ::getAssert():false with .f." )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testAssertEquals() CLASS TestAssert

   // test with nil
   ::getAssert():equals( nil, nil, "test ::getAssert():equals nil with nil" )

   // test with logicals
   ::getAssert():equals( .t., .t., "test ::getAssert():equals with logical .t." )
   ::getAssert():equals( .f., .f., "test ::getAssert():equals with logical .f." )

   // test with characters
   ::getAssert():equals( "", '', "test ::getAssert():equals with empty string" )
   ::getAssert():equals( " ", ' ', "test ::getAssert():equals with single space" )
   ::getAssert():equals( "a", 'a', "test ::getAssert():equals with single character" )

   // test with numerics
   ::getAssert():equals( 0, 0, "test ::getAssert():equals on small integers" )
   ::getAssert():equals( 1234567890, 1234567890.0, "test ::getAssert():equals on large integers" )
   ::getAssert():equals( -2, -2, "test ::getAssert():equals on small negative integers" )
   ::getAssert():equals( -2342342342342, -2342342342342.0, "test ::getAssert():equals on large negative integers" )
   ::getAssert():equals( 0.1, 0.1, "test ::getAssert():equals on single decimal float" )
   ::getAssert():equals( 0.12345678, 0.123456780, "test ::getAssert():equals on multiple decimal floats" )
   ::getAssert():equals( 0.01, 0.010000, "test ::getAssert():equals different decimal floats" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testAssertNotEquals() CLASS TestAssert

   ::getAssert():notEquals( 0, 1, "test ::getAssert():notEquals on small integers" )
   ::getAssert():notEquals( 1234567890, 1234567891, "test ::getAssert():notEquals on large integers" )
   ::getAssert():notEquals( -2, -3, "test ::getAssert():notEquals on small negative integers" )
   ::getAssert():notEquals( -23452342342342, -23452342342343, "test ::getAssert():notEquals on large negative integers" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testAssertNull() CLASS TestAssert

   ::getAssert():null( , "test ::getAssert():notNull with empty parameter" )
   ::getAssert():null( nil, "test ::getAssert():notNull with coded nil" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testAssertNotNull() CLASS TestAssert

   ::getAssert():notNull( 1, "test ::getAssert():notNull on numerics" )
   ::getAssert():notNull( 'a', "test ::getAssert():notNull with character" )
   ::getAssert():notNull( date(), "test ::getAssert():notNull with date" )
   ::getAssert():notNull( .f., "test ::getAssert():notNull with logical" )
   ::getAssert():notNull( array(3), "test ::getAssert():notNull with array" )
   ::getAssert():notNull( {|| nil }, "test ::getAssert():notNull with codeblock" )

RETURN ( nil )

//---------------------------------------------------------------------------//
