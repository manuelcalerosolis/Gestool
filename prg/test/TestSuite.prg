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

CLASS TTestSuite FROM TTest

   DATA cClassName

   PROTECTED:
      DATA aTests

   METHOD New() CONSTRUCTOR
   METHOD className()

   METHOD run()
   METHOD addTest( oTest )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS TTestSuite

  ::Super:New()

  ::cClassName := "TTestSuite"

  ::aTests     := {}

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD className() CLASS TTestSuite

RETURN( ::cClassName )

//---------------------------------------------------------------------------//

METHOD Run() CLASS TTestSuite

   aeval( ::aTests, {|oTest| oTest:Run() } )

RETURN ( ::oResult )

//---------------------------------------------------------------------------//

METHOD addTest( oTest ) CLASS TTestSuite

RETURN ( aadd( ::aTests, oTest ) )

//---------------------------------------------------------------------------//
