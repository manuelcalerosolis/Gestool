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

CLASS TAssert

  DATA oResult

  METHOD new( oResult ) CONSTRUCTOR

  METHOD equals( xExp, xAct, cMsg )
  METHOD notEquals( xExp, xAct, cMsg )
  METHOD true( xAct, cMsg )
  METHOD false( xAct, cMsg )
  METHOD null( xAct, cMsg )
  METHOD notNull( xAct, cMsg )

PROTECTED:
  METHOD isEqual( xExp, xAct )
  METHOD assert( xExp, xAct, cMsg, lInvert )
  METHOD fail( cMsg )
  METHOD toStr (xVal, lUseQuote )

ENDCLASS

METHOD new( oResult ) CLASS TAssert

   ::oResult      := oResult

RETURN ( self )

METHOD fail( cMsg ) CLASS TAssert

RETURN ( ::assert( .f.,, "Failure: " + cMsg ) )

METHOD equals( xExp, xAct, cMsg ) CLASS TAssert

   local cErrMsg := ""

   cErrMsg += "Exp: " + ::toStr( xExp, .t. )
   cErrMsg += ", Act: " + ::toStr( xAct, .t. )
   cErrMsg += "( " + cMsg + " )"

RETURN ( ::assert( xExp, xAct, cErrMsg ) )

METHOD notEquals( xExp, xAct, cMsg ) CLASS TAssert

   local cErrMsg := ""

   cErrMsg += "Exp: not " + ::toStr( xExp, .t. )
   cErrMsg += ", Act: " + ::toStr( xAct )
   cErrMsg += "( " + cMsg + " )"

RETURN ( ::assert( xExp, xAct, cErrMsg, .t. ) )

METHOD true( xAct, cMsg ) CLASS TAssert

   local cErrMsg := ""

   cErrMsg += "Exp: .t., Act: "
   cErrMsg += ::toStr( xAct, .t. )
   cErrMsg += "( " + cMsg + " )"

RETURN ( ::assert( .t., xAct , cErrMsg ) )

METHOD false( xAct, cMsg ) CLASS TAssert

   local cErrMsg := ""

   cErrMsg += "Exp: .f., Act: "
   cErrMsg += ::toStr( xAct, .t. )
   cErrMsg += "( " + cMsg + " )"

RETURN ( ::assert( .f., xAct , cErrMsg ) )

METHOD null( xAct, cMsg ) CLASS TAssert

   local cErrMsg := ""

   cErrMsg += "Exp: nil, Act: "
   cErrMsg += ::toStr( xAct, .t. )
   cErrMsg += "( " + cMsg + " )"

RETURN ( ::assert( nil, xAct , cErrMsg ) )

METHOD notNull( xAct, cMsg ) CLASS TAssert

   local cErrMsg := ""

   cErrMsg += "Exp: not nil, Act: "
   cErrMsg += ::toStr( xAct, .t. )
   cErrMsg += "( " + cMsg + " )"

RETURN ( ::assert( nil, xAct , cErrMsg, .t. ) )

METHOD assert( xExp, xAct, cMsg, lInvert ) CLASS TAssert

   local oError

   cMsg := Procfile(2) + ":" + LTRIM(STR(ProcLine(2))) + ":" + ProcName(2) + " => " + cMsg

   if( lInvert == nil, lInvert := .f., )

   BEGIN SEQUENCE
      ::oResult:oData:incrementAssertCount()

      if ( ( lInvert .and. ::isEqual( xExp, xAct )) .or. ( !( lInvert ) .and. ( !( ::isEqual( xExp, xAct ) ) ) ) )

      oError := ErrorNew()
      oError:description  := cMsg
      oError:filename     := Procfile(2)

      ::oResult:oData:addFailure( oError )

      endif

   RECOVER USING oError

      ::oResult:oData:addError( oError )

   END 

RETURN ( nil )

METHOD isEqual( xExp, xAct ) CLASS TAssert

   local lResult := .F.

   do case
      case ValType( xExp ) != ValType( xAct )
      case ( !( xExp == xAct ))
      otherwise
      lResult := .T.
   endcase

RETURN ( lResult )

// #TODO - see where to put these util methods

METHOD toStr (xVal, lUseQuote ) CLASS TAssert

   local cStr, i

   if( lUseQuote == nil, lUseQuote := .f., )

   do case
   case ( valtype( xVal ) == "C" )
      cStr := xVal
   case ( valtype( xVal ) == "M" )
      cStr := xVal
   case ( valtype( xVal ) == "L" )
      cStr := if( xVal, ".t.", ".f." )
   case ( valtype( xVal ) ==  "D" )
      cStr := DToC( xVal )
   case ( valtype( xVal ) == "N" )
      cStr := ltrim( str( xVal ) )
   case ( valtype( xVal ) == "A" )
      cStr := hb_valtoexp( xVal )
   case ( valtype( xVal ) == "O" )
      cStr := "obj"
   case ( valtype( xVal ) == "B" )
      cStr := "blk"
   otherwise
      cStr := "nil"
   end

   if ( lUseQuote .and. ValType( xVal ) == "C" )
      cStr := "'" + cStr+ "'"
   endif

RETURN ( cStr )

