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

CLASS TextRunner FROM TTestRunner

   DATA cResults

   METHOD new() CONSTRUCTOR

   METHOD showResults( oResult )

   METHOD addResults( cResults, cResult )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD new() CLASS TextRunner

   ::Super:new()

   ::cResults     := ""

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD addResults( ... ) CLASS TextRunner

   local i

   for i := 1 to pcount()
      ::cResults     += hb_pvalue( i ) + CRLF
   next

RETURN ( ::cResults )

//---------------------------------------------------------------------------//

METHOD showResults( oResult ) CLASS TextRunner

   local i
   local oError
   local oFailure
   local aErrors     
   local aFailures   
   local nTestCases  
   local nAsserts    
   local nErrors     
   local nFailures   

   aErrors           := oResult:oData:getErrors()
   aFailures         := oResult:oData:getFailures()
   nTestCases        := oResult:oData:getTestCasesCount()
   nAsserts          := oResult:oData:getAssertCount()
   nErrors           := len( aErrors )
   nFailures         := len( aFailures )

   ::addResults( "Testcases: " + ltrim( str( nTestCases ) ) )
   ::addResults( "Asserts:   " + ltrim( str( nAsserts   ) ) )
   ::addResults( "Errors:    " + ltrim( str( nErrors    ) ) )
   ::addResults( "Failures:  " + ltrim( str( nFailures  ) ) )

   if ( nErrors + nFailures == 0 )
      ::addResults( "Ok." )
   end if 

   if ( nErrors > 0 )
   
      ::addResults( "Errors:" )

      for i := 1 to nErrors
         oError := aErrors[i]
         ::addResults( padl( i, 4 ), oError:description, oError:operation, if( !( empty( oError:args ) ), ::toStr( oError:args ), "" ) )
      next
   
   endif

   if ( nFailures > 0 )

      ::addResults( "Failures:" )

      for i := 1 to nFailures
         oFailure := aFailures[i]
         ::addResults( padl( i, 4 ), oFailure:description, oFailure:operation, if( !( empty( oFailure:args ) ), ::toStr( oFailure:args ), "" ) )
      next

   endif

   msgInfo( ::cResults, "Test information" )

RETURN ( nil )

//---------------------------------------------------------------------------//
