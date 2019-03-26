//-- copyright
// hbunit is a unit-testing framework for the Harbour language.
//
// Copyright (C) 2019 Manuel Calero Solis <manuelcalerosolis _at_ gmail _dot_ com>
//
// Based on hbunit from Enderson maia <endersonmaia _at_ gmail _dot_ com>
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

CLASS TextFWDialogRunner FROM TestRunner

   DATA cResults

   METHOD new() CONSTRUCTOR

   METHOD showResults( oResult )

   METHOD addResults( cResults, cResult )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD new() CLASS TextTextRunner

   ::Super:new()

   ::cResults     := ""

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD addResults( ... ) CLASS TextTextRunner

   local i

   for i := 1 to pcount()
      ::cResults     += hb_pvalue( i ) + CRLF
   next

RETURN ( ::cResults )

//---------------------------------------------------------------------------//

METHOD showResults( oResult ) CLASS TextTextRunner

   local i
   local oError
   local aErrors     
   local nErrors     
   local oFailure
   local aFailures   
   local nFailures   

   aErrors           := oResult:oData:getErrors()
   aFailures         := oResult:oData:getFailures()
   nErrors           := len( aErrors )
   nFailures         := len( aFailures )

   ::addResults( "Testcases: " + hb_ntos( oResult:oData:getTestCasesCount() ) )
   ::addResults( "Asserts:   " + hb_ntos( oResult:oData:getAssertCount() ) )
   ::addResults( "Errors:    " + hb_ntos( nErrors ) )
   ::addResults( "Failures:  " + hb_ntos( nFailures ) )

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
