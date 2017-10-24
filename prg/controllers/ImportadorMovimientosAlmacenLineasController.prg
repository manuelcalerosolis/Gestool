#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ImportadorMovimientosAlmacenLineasController FROM SQLBaseController

   DATA aErrors

   METHOD New( oController )

   METHOD Activate()    INLINE ( ::oDialogView:Activate() )

   METHOD procesarLineas( cLineas )
      METHOD procesarLinea( cInventario ) 

   METHOD showInventarioErrors() 

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::cTitle             := "Importador movimientos almacen lineas"

   ::oDialogView        := ImportarMovimientosAlmacenLineasView():New( self )

   ::Super:New( oController )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD procesarLineas( cLineas )

   local aInventario    

   if empty( cLineas )
      RETURN ( Self )
   end if 

   aInventario          := hb_atokens( cLineas, CRLF )

   msgalert( hb_valtoexp( cLineas ), "cLineas" )

   if empty( aInventario ) 
      RETURN ( Self )
   end if 

   ::aErrors            := {}

   aeval( aInventario, {|elem| ::procesarLinea( elem ) } ) 

   ::showInventarioErrors()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD procesarLinea( cInventario ) 

   local hInventario    := {=>}
   local aInventario    := hb_atokens( cInventario, "," )

   if !hb_isarray( aInventario ) 
      RETURN ( Self )
   end if 

   if len( aInventario ) < 2
      RETURN ( Self )
   end if 

   hset( hInventario, "Codigo"   , alltrim( aInventario[ 1 ] ) )
   hset( hInventario, "Unidades" , val( strtran( aInventario[ 2 ], ".", "," ) ) )

   if len( aInventario ) >= 6
      hset( hInventario, "CodigoPrimeraPropiedad", alltrim( aInventario[ 3 ] ) )
      hset( hInventario, "ValorPrimeraPropiedad",  alltrim( aInventario[ 4 ] ) )
      hset( hInventario, "CodigoSegundaPropiedad", alltrim( aInventario[ 5 ] ) )
      hset( hInventario, "ValorSegundaPropiedad",  alltrim( aInventario[ 6 ] ) )
   end if 

   if !hb_isstring( hget( hInventario, "Codigo" ) ) 
      aadd( ::aErrors, "El código del artículo no es un valor valido." )
      RETURN ( Self )   
   end if 

   if !hb_isnumeric( hget( hInventario, "Unidades" ) )
      aadd( ::aErrors, "Las unidades del artículo no contienen un valor valido." )
      RETURN ( Self )   
   end if 

   // ::insertaArticuloInventario( hInventario )

RETURN ( Self ) 

//---------------------------------------------------------------------------//
/*
METHOD insertaArticuloRemesaMovimiento( hInventario ) 

   ::oDetMovimientos:oDbfVir:Blank()

   ::oDetMovimientos:oDbfVir:cRefMov      := cCodigo
   ::oDetMovimientos:oDbfVir:nUndMov      := nUnidades
   ::oDetMovimientos:oDbfVir:nNumLin      := nLastNum( ::oDetMovimientos:oDbfVir:cAlias )

   if hb_isstring( cCodigoPrimeraPropiedad )   
      ::oDetMovimientos:oDbfVir:cCodPr1   := cCodigoPrimeraPropiedad
   end if 

   if hb_isstring( cValorPrimeraPropiedad )   
      ::oDetMovimientos:oDbfVir:cValPr1   := cValorPrimeraPropiedad
   end if 

   if hb_isstring( cCodigoSegundaPropiedad )   
      ::oDetMovimientos:oDbfVir:cCodPr2   := cCodigoSegundaPropiedad
   end if 

   if hb_isstring( cValorSegundaPropiedad )   
      ::oDetMovimientos:oDbfVir:cValPr2   := cValorSegundaPropiedad
   end if 

   if !( ::oDetMovimientos:loadArticulo( APPD_MODE, .t. ) )
      aadd( ::aErrors, "El código de artículo " + cCodigo + " no es un valor valido." )
   end if 

   if ::oDetMovimientos:isNumeroSerieNecesario( APPD_MODE, .f. )
      aadd( ::aErrors, "El código de artículo " + cCodigo + " necesita proporcinarle el numero de serie." )
      ::oDetMovimientos:oDbfVir:Cancel()
   end if 

   if ::oDetMovimientos:accumulatesStoreMovement()
      
      ::oDetMovimientos:oDbfVir:Cancel()
   
   else
      
      ::oDetMovimientos:oDbfVir:Insert()

      ::oDetMovimientos:appendKit()

   end if 
   
RETURN ( Self )
*/
//---------------------------------------------------------------------------//

METHOD showInventarioErrors() 

   local cErrorMessage  := ""

   if !empty( ::aErrors )
      aeval( ::aErrors, {|cError| cErrorMessage += cError + CRLF } )   
      msgstop( cErrorMessage, "Errores en la importación" )
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//




