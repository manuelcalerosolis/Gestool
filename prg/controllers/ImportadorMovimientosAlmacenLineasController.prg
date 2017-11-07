#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ImportadorMovimientosAlmacenLineasController FROM SQLBaseController

   DATA aErrors         INIT {}

   METHOD New( oController )

   METHOD Activate()    INLINE ( ::oDialogView:Activate() )

   METHOD getModel()    INLINE ( ::oSenderController:oLineasController:getModel() )
   METHOD getBrowse()   INLINE ( ::oSenderController:oDialogView:oSQLBrowseView )

   METHOD processLines( cLines )
      METHOD processLine( hLine ) 

   METHOD showErrors() 

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::cTitle             := "Importador movimientos almacen lineas"

   ::oDialogView        := ImportadorMovimientosAlmacenLineasView():New( self )

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

   ::getBrowse():Refresh()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD processLine( cLine ) 

   local hBuffer    
   local hArticulo
   local aLines      := hb_atokens( cLine, "," )

   if !hb_isarray( aLines ) 
      aadd( ::aErrors, "No hay líneas que procesar." )
      RETURN ( Self )
   end if 

   if len( aLines ) < 2
      aadd( ::aErrors, "La linea no contiene los valores mínimos." )
      RETURN ( Self )
   end if 

   hBuffer           := ::getModel():loadBlankBuffer()

   hset( hBuffer, "codigo_articulo",     alltrim( aLines[ 1 ] ) )
   hset( hBuffer, "unidades_articulo",   val( strtran( aLines[ 2 ], ".", "," ) ) )

   if len( aLines ) >= 6
      hset( hBuffer, "codigo_primera_propiedad", alltrim( aLines[ 3 ] ) )
      hset( hBuffer, "valor_primera_propiedad",  alltrim( aLines[ 4 ] ) )
      hset( hBuffer, "codigo_segunda_propiedad", alltrim( aLines[ 5 ] ) )
      hset( hBuffer, "valor_segunda_propiedad",  alltrim( aLines[ 6 ] ) )
   end if 

   hArticulo         := ArticulosModel():getHash( hget( hBuffer, "codigo_articulo" ) )
   if empty( hArticulo )
      aadd( ::aErrors, "El código del artículo no existe." )
      RETURN ( Self )
   end if 

   hset( hBuffer, "nombre_articulo", hget( hArticulo, "nombre" ) ) 
   hset( hBuffer, "precio_articulo", hget( hArticulo, "pcosto" ) )

   ::getModel():insertBuffer( hBuffer )

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




