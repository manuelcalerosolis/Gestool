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

CLASS TTestResult

   DATA oData

   DATA cClassName

   METHOD new() CONSTRUCTOR

   METHOD ClassName()

   METHOD run()

   HIDDEN:
   METHOD invokeTestMethod()
   METHOD getTestMethods()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD new() CLASS TTestResult

  ::oData      := TTestResultData():new()
  ::cClassName := "TTestResult"

RETURN( self )

//---------------------------------------------------------------------------//

METHOD ClassName() CLASS TTestResult

RETURN ( ::cClassName )

//---------------------------------------------------------------------------//

METHOD run( oTest ) CLASS TTestResult

   local i
   local aTestMethods   := ::getTestMethods( oTest )
   local nTestMethods   := len ( aTestMethods )

   ::oData:addTestCaseCount( nTestMethods )

   for i := 1 TO nTestMethods
      ::invokeTestMethod( oTest, "SETUP")
      ::invokeTestMethod( oTest, aTestMethods[i] )
      ::invokeTestMethod( oTest, "TEARDOWN")
   next

RETURN ( NIL )

//---------------------------------------------------------------------------//

METHOD getTestMethods( oTest ) CLASS TTestResult

   local i
   local aTestMethods   := {}
   local aMethods       := __objGetMethodList( oTest )

   for i := 1 to len( aMethods )
      if ( left( aMethods[i], 4 ) == "TEST" )
         aadd( aTestMethods, aMethods[i] )
      endif
   next

RETURN ( aTestMethods )

//---------------------------------------------------------------------------//

METHOD invokeTestMethod( oTest, cMethod ) CLASS TTestResult

   local oError

   BEGIN SEQUENCE

      __ObjSendMsg( oTest, cMethod )

   RECOVER USING oError

      oError:Args := oTest:ClassName() + ":" + cMethod

      ::addError( oError )

   END 

RETURN ( nil )

//---------------------------------------------------------------------------//