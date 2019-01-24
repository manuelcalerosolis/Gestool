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

   oSuite:addTest( TestFacturasVentasController():New() )

   oSuite:addTest( TestConsolidacionAlmacenController():New() )

   oSuite:addTest( TestMovimientoAlmacenController():New() )

   oSuite:setCategories( { "movimientos_almacenes" } )

   oRunner:run( oSuite )

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
      ::assert:fail( "unable to catch 'Variable not found'" )
   RECOVER
   END
*/

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testLogicals() CLASS TestAssert

   ::assert:true( .t., "test ::assert:true with .t." )
   ::assert:false( .f., "test ::assert:false with .f." )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testAssertEquals() CLASS TestAssert

   // test with nil
   ::assert:equals( nil, nil, "test ::assert:equals nil with nil" )

   // test with logicals
   ::assert:equals( .t., .t., "test ::assert:equals with logical .t." )
   ::assert:equals( .f., .f., "test ::assert:equals with logical .f." )

   // test with characters
   ::assert:equals( "", '', "test ::assert:equals with empty string" )
   ::assert:equals( " ", ' ', "test ::assert:equals with single space" )
   ::assert:equals( "a", 'a', "test ::assert:equals with single character" )

   // test with numerics
   ::assert:equals( 0, 0, "test ::assert:equals on small integers" )
   ::assert:equals( 1234567890, 1234567890.0, "test ::assert:equals on large integers" )
   ::assert:equals( -2, -2, "test ::assert:equals on small negative integers" )
   ::assert:equals( -2342342342342, -2342342342342.0, "test ::assert:equals on large negative integers" )
   ::assert:equals( 0.1, 0.1, "test ::assert:equals on single decimal float" )
   ::assert:equals( 0.12345678, 0.123456780, "test ::assert:equals on multiple decimal floats" )
   ::assert:equals( 0.01, 0.010000, "test ::assert:equals different decimal floats" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testAssertNotEquals() CLASS TestAssert

   ::assert:notEquals( 0, 1, "test ::assert:notEquals on small integers" )
   ::assert:notEquals( 1234567890, 1234567891, "test ::assert:notEquals on large integers" )
   ::assert:notEquals( -2, -3, "test ::assert:notEquals on small negative integers" )
   ::assert:notEquals( -23452342342342, -23452342342343, "test ::assert:notEquals on large negative integers" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testAssertNull() CLASS TestAssert

   ::assert:null( , "test ::assert:notNull with empty parameter" )
   ::assert:null( nil, "test ::assert:notNull with coded nil" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testAssertNotNull() CLASS TestAssert

   ::assert:notNull( 1, "test ::assert:notNull on numerics" )
   ::assert:notNull( 'a', "test ::assert:notNull with character" )
   ::assert:notNull( date(), "test ::assert:notNull with date" )
   ::assert:notNull( .f., "test ::assert:notNull with logical" )
   ::assert:notNull( array(3), "test ::assert:notNull with array" )
   ::assert:notNull( {|| nil }, "test ::assert:notNull with codeblock" )

RETURN ( nil )

//---------------------------------------------------------------------------//
