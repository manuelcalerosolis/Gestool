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

FUNCTION testWaitSeconds( nSecs )

   // local n

   // for n := 1 to nSecs
   //    waitSeconds( 1 )
   //    sysRefresh()
   // next

   waitSeconds( 0.1 )
   
   sysRefresh()

RETURN ( nil )

//---------------------------------------------------------------------------//

FUNCTION testGetControl( nId, oDialog )

   local nPos

   if empty( oDialog ) 
      RETURN ( nil )
   end if 
   
   nPos              := ascan( oDialog:aControls, { | o | o:nId == nId } ) 
   if nPos == 0
      RETURN ( nil )
   end if 

RETURN ( oDialog:aControls[ nPos ] )

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
   
   oSuite:addTest( TestConversorDocumentosController():New() )

   oSuite:setCategories( { "stocks" } ) 

   oRunner:run( oSuite )

   oSuite:End()

RETURN ( nil )

//---------------------------------------------------------------------------//
