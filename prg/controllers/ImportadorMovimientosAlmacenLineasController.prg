#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ImportadorMovimientosAlmacenLineasController FROM SQLBaseController

   DATA aErrors

   METHOD New( oController )

   METHOD Activate()    INLINE ( ::oDialogView:Activate() )

   METHOD getModel()    INLINE ( ::oSenederController:getModel() )

   METHOD processLines( cLines )
      METHOD processLine( hLine ) 

   METHOD insertLineInModel( hLine ) 

   METHOD showErrors() 

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::cTitle             := "Importador movimientos almacen lineas"

   ::oDialogView        := ImportarMovimientosAlmacenLineasView():New( self )

   ::Super:New( oController )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD processLines( cLines )

   local aLines    

   if empty( cLines )
      RETURN ( Self )
   end if 

   aLines               := hb_atokens( cLines, CRLF )

   if empty( aLines ) 
      RETURN ( Self )
   end if 

   ::aErrors            := {}

   aeval( aLines, {|elem| ::processLine( elem ) } ) 

   ::showErrors()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD processLine( cLine ) 

   local hLine    := {=>}
   local aLines   := hb_atokens( cLine, "," )

   if !hb_isarray( aLines ) 
      RETURN ( Self )
   end if 

   if len( aLines ) < 2
      RETURN ( Self )
   end if 

   hset( hLine, "Codigo"   , alltrim( aLines[ 1 ] ) )
   hset( hLine, "Unidades" , val( strtran( aLines[ 2 ], ".", "," ) ) )

   if len( aLines ) >= 6
      hset( hLine, "CodigoPrimeraPropiedad", alltrim( aLines[ 3 ] ) )
      hset( hLine, "ValorPrimeraPropiedad",  alltrim( aLines[ 4 ] ) )
      hset( hLine, "CodigoSegundaPropiedad", alltrim( aLines[ 5 ] ) )
      hset( hLine, "ValorSegundaPropiedad",  alltrim( aLines[ 6 ] ) )
   end if 

   if !hb_isstring( hget( hLine, "Codigo" ) ) 
      aadd( ::aErrors, "El código del artículo no es un valor valido." )
      RETURN ( Self )   
   end if 

   if !hb_isnumeric( hget( hLine, "Unidades" ) )
      aadd( ::aErrors, "Las unidades del artículo no contienen un valor valido." )
      RETURN ( Self )   
   end if 

   ::insertLineInModel( hLine )

RETURN ( Self ) 

//---------------------------------------------------------------------------//

METHOD insertLineInModel( hLine ) 

   local hArticulo

   msgalert( hb_valtoexp( hLine ), "hLine" )

   hArticulo         := ArticulosModel():getHash( hget( hLine, "Codigo" ) )

   msgalert( hb_valtoexp( hArticulo ), "hArticulo" )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD showErrors() 

   local cErrorMessage  := ""

   if !empty( ::aErrors )
      aeval( ::aErrors, {|cError| cErrorMessage += cError + CRLF } )   
      msgstop( cErrorMessage, "Errores en la importación" )
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//




