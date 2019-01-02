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

CLASS TestSuite FROM Test

   DATA aTests

   DATA aCategories

   METHOD New() CONSTRUCTOR

   METHOD run()

   METHOD addTest( oTest )

   METHOD setCategories( uCategories )

   METHOD isInCategories( aTestCategories )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS TestSuite

  ::Super:New()

  ::aTests        := {}

  ::aCategories   := { "all" }

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD Run() CLASS TestSuite

   aeval( ::aTests, {|oTest| if( ::isInCategories( oTest:aCategories ), oTest:Run(), ) } )

RETURN ( ::oResult )

//---------------------------------------------------------------------------//

METHOD addTest( oTest ) CLASS TestSuite

RETURN ( aadd( ::aTests, oTest ) )

//---------------------------------------------------------------------------//

METHOD setCategories( uCategories ) CLASS TestSuite

   if hb_ischar( uCategories )
      aadd( ::aCategories, uCategories )
   end if 

   if hb_isarray( uCategories )
      ::aCategories  := uCategories
   end if 

RETURN ( ::aCategories )

//---------------------------------------------------------------------------//

METHOD isInCategories( aTestCategories ) CLASS TestSuite

   local cTestCategory 
   local cSuiteCategory

   for each cTestCategory in aTestCategories
      for each cSuiteCategory in ::aCategories
         if cTestCategory == cSuiteCategory 
            RETURN ( .t. )
         end if 
      next
   next 

RETURN ( .f. )

//---------------------------------------------------------------------------//