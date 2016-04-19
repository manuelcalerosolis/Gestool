#include "hbclass.ch"

#define CRLF chr( 13 ) + chr( 10 )

//---------------------------------------------------------------------------//

CLASS Uve FROM Cuaderno

   DATA cFile                       INIT FullCurDir() + 'VentasDistribuidor' + dtos( date() ) + timeToString() + '.csv'
   DATA aLineas                     INIT {}

   METHOD New()                     INLINE ( Self )
   METHOD Separator()               INLINE ( ';' )

   METHOD WriteASCII()
   METHOD SerializeASCII()

   DATA cNumFactura                 INIT ''
   METHOD NumFactura(uValue)        INLINE ( if( !Empty(uValue), ::cNumFactura         := uValue, trimpadr( strtran( ::cNumFactura, " ", "" ), 20 ) ) )
   DATA nNumLinea                   INIT 0
   METHOD NumLinea(uValue)          INLINE ( if( !Empty(uValue), ::nNumLinea           := uValue, trimpadr( trans( ::nNumLinea, "@E 9999999.99" ), 10 ) ) )
   DATA cCodigoProducto             INIT ''
   METHOD CodigoProducto(uValue)    INLINE ( if( !Empty(uValue), ::cCodigoProducto     := uValue, trimpadr( ::cCodigoProducto, 18 ) ) )
   DATA cDescProducto               INIT ''
   METHOD DescProducto(uValue)      INLINE ( if( !Empty(uValue), ::cDescProducto       := uValue, trimpadr( ::cDescProducto, 50 ) ) )
   DATA cFabricante                 INIT ''
   METHOD Fabricante(uValue)        INLINE ( if( !Empty(uValue), ::cFabricante         := uValue, trimpadr( ::cFabricante, 10 ) ) )
   DATA cCodigoProdFab              INIT ''
   METHOD CodigoProdFab(uValue)     INLINE ( if( !Empty(uValue), ::cCodigoProdFab      := uValue, trimpadr( ::cCodigoProdFab, 18 ) ) )
   DATA cEAN13                      INIT ''
   METHOD EAN13(uValue)             INLINE ( if( !Empty(uValue), ::cEAN13              := uValue, trimpadr( ::cEAN13, 13 ) ) )
   DATA nCantidad                   INIT 0
   METHOD Cantidad(uValue)          INLINE ( if( !Empty(uValue), ::nCantidad           := uValue, trimpadr( trans( ::nCantidad, "@E 9999999999.999" ), 14 ) ) )
   DATA cUM                         INIT ''
   METHOD UM(uValue)                INLINE ( if( !Empty(uValue), ::cUM                 := uValue, trimpadr( ::cUM, 5 ) ) )
   DATA nPrecioBase                 INIT 0
   METHOD PrecioBase(uValue)        INLINE ( if( !Empty(uValue), ::nPrecioBase         := uValue, trimpadr( trans( ::nPrecioBase, "@E 9999999999.999" ), 14 ) ) )
   DATA nDescuentos                 INIT 0
   METHOD Descuentos(uValue)        INLINE ( if( !Empty(uValue), ::nDescuentos         := uValue, trimpadr( trans( ::nDescuentos, "@E 9999999999.999" ), 14 ) ) )
   DATA nPrecioBrutoTotal           INIT 0
   METHOD PrecioBrutoTotal(uValue)  INLINE ( if( !Empty(uValue), ::nPrecioBrutoTotal   := uValue, trimpadr( trans( ::nPrecioBrutoTotal, "@E 9999999999.999" ), 14 ) ) )
   DATA dFechaFra                   INIT date()
   METHOD FechaFra(uValue)          INLINE ( if( !Empty(uValue), ::dFechaFra           := uValue, dtos( ::dFechaFra ) ) )
   DATA nEjercicio                  INIT 0
   METHOD Ejercicio(uValue)         INLINE ( if( !Empty(uValue), ::nEjercicio          := uValue, str( ::nEjercicio, 4 ) ) )
   DATA cCodigoCliente              INIT ''
   METHOD CodigoCliente(uValue)     INLINE ( if( !Empty(uValue), ::cCodigoCliente      := uValue, trimpadr( ::cCodigoCliente, 15 ) ) )
   DATA cNombre                     INIT ''
   METHOD Nombre(uValue)            INLINE ( if( !Empty(uValue), ::cNombre             := uValue, trimpadr( ::cNombre, 50 ) ) )
   DATA cRazonSocial                INIT ''
   METHOD RazonSocial(uValue)       INLINE ( if( !Empty(uValue), ::cRazonSocial        := uValue, trimpadr( ::cRazonSocial, 50 ) ) )
   DATA cCIF                        INIT ''
   METHOD CIF(uValue)               INLINE ( if( !Empty(uValue), ::cCIF                := uValue, trimpadr( ::cCIF, 15 ) ) )
   DATA cDireccion                  INIT ''
   METHOD Direccion(uValue)         INLINE ( if( !Empty(uValue), ::cDireccion          := uValue, trimpadr( ::cDireccion, 100 ) ) ) 
   DATA cPoblacion                  INIT ''
   METHOD Poblacion(uValue)         INLINE ( if( !Empty(uValue), ::cPoblacion          := uValue, trimpadr( ::cPoblacion, 50 ) ) )
   DATA cCodigoPostal               INIT ''
   METHOD CodigoPostal(uValue)      INLINE ( if( !Empty(uValue), ::cCodigoPostal       := uValue, trimpadr( ::cCodigoPostal, 5 ) ) )
   DATA cRuta                       INIT ''
   METHOD Ruta(uValue)              INLINE ( if( !Empty(uValue), ::cRuta               := uValue, trimpadr( ::cRuta, 10 ) ) )
   DATA cNombreRuta                 INIT ''
   METHOD NombreRuta(uValue)        INLINE ( if( !Empty(uValue), ::cNombreRuta         := uValue, trimpadr( ::cNombreRuta, 50 ) ) )
   DATA cCodigoComercial            INIT ''
   METHOD CodigoComercial(uValue)   INLINE ( if( !Empty(uValue), ::cCodigoComercial    := uValue, trimpadr( ::cCodigoComercial, 10 ) ) )
   DATA cNombreComercial            INIT ''
   METHOD NombreComercial(uValue)   INLINE ( if( !Empty(uValue), ::cNombreComercial    := uValue, trimpadr( ::cNombreComercial, 50 ) ) )
   DATA nPeso                       INIT 0
   METHOD Peso(uValue)              INLINE ( if( !Empty(uValue), ::nPeso               := uValue, trimpadr( trans( ::nPeso, "@E 9999999999.999" ), 14 ) ) )
   DATA cUMPeso                     INIT ''
   METHOD UMPeso(uValue)            INLINE ( if( !Empty(uValue), ::cUMPeso             := uValue, trimpadr( ::cUMPeso, 5 ) ) )
   DATA cTipoCliente                INIT ''
   METHOD TipoCliente(uValue)       INLINE ( if( !Empty(uValue), ::cTipoCliente        := uValue, trimpadr( ::cTipoCliente, 6 ) ) )
   DATA cTelefono                   INIT ''
   METHOD Telefono(uValue)          INLINE ( if( !Empty(uValue), ::cTelefono           := uValue, trimpadr( ::cTelefono, 11 ) ) )
   DATA cDescTipoCliente            INIT ''
   METHOD DescTipoCliente(uValue)   INLINE ( if( !Empty(uValue), ::cDescTipoCliente    := uValue, trimpadr( ::cDescTipoCliente, 50 ) ) )

   METHOD isRepeatLine( cBuffer )
   METHOD isSameLine( aLinea, cBuffer )

ENDCLASS

   //------------------------------------------------------------------------//

   METHOD SerializeASCII() CLASS Uve 

      local cBuffer

      cBuffer         := ::NumFactura()       + ::Separator()
      cBuffer         += ::NumLinea()         + ::Separator()
      cBuffer         += ::CodigoProducto()   + ::Separator()
      cBuffer         += ::DescProducto()     + ::Separator()
      cBuffer         += ::Fabricante()       + ::Separator()
      cBuffer         += ::CodigoProdFab()    + ::Separator()
      cBuffer         += ::EAN13()            + ::Separator()
      cBuffer         += ::Cantidad()         + ::Separator()
      cBuffer         += ::UM()               + ::Separator()
      cBuffer         += ::PrecioBase()       + ::Separator()
      cBuffer         += ::Descuentos()       + ::Separator()
      cBuffer         += ::PrecioBrutoTotal() + ::Separator()
      cBuffer         += ::FechaFra()         + ::Separator()
      cBuffer         += ::Ejercicio()        + ::Separator()
      cBuffer         += ::CodigoCliente()    + ::Separator()
      cBuffer         += ::Nombre()           + ::Separator()
      cBuffer         += ::RazonSocial()      + ::Separator()
      cBuffer         += ::CIF()              + ::Separator()
      cBuffer         += ::Direccion()        + ::Separator()
      cBuffer         += ::Poblacion()        + ::Separator()
      cBuffer         += ::CodigoPostal()     + ::Separator()
      cBuffer         += ::Ruta()             + ::Separator()
      cBuffer         += ::NombreRuta()       + ::Separator()
      cBuffer         += ::CodigoComercial()  + ::Separator()
      cBuffer         += ::NombreComercial()  + ::Separator()
      cBuffer         += ::Peso()             + ::Separator()
      cBuffer         += ::UMPeso()           + ::Separator()
      cBuffer         += ::TipoCliente()      + ::Separator()
      cBuffer         += ::Telefono()         + ::Separator()
      cBuffer         += ::DescTipoCliente()  + ::Separator()
      cBuffer         += CRLF

      if !::isRepeatLine( cBuffer )
         aadd( ::aLineas, cBuffer )
      end if

   Return ( ::aLineas )

//---------------------------------------------------------------------------//

   METHOD isRepeatLine( cBuffer )  CLASS Uve 
      
      local aLastLine   := atail( ::aLineas )

      if empty( aLastLine )
         return ( .f. )
      end if 

      // msgAlert( hb_valtoexp( aLastLine ), "aLastLine" )
      // msgAlert( cBuffer, "cBuffer")
      // msgAlert( ::isSameLine( aLastLine, cBuffer ), "isSameLine" )

   Return ( ::isSameLine( aLastLine, cBuffer ) )

//---------------------------------------------------------------------------//

   METHOD isSameLine( cLinea, cBuffer )  CLASS Uve 

       local aLinea     := hb_atokens( cLinea, ";" )
       local aBuffer    := hb_atokens( cBuffer, ";" )

   Return ( aLinea[ 1 ] + aLinea[ 2 ] == aBuffer[ 1 ] + aBuffer[ 2 ] )

//---------------------------------------------------------------------------//

   METHOD WriteASCII( bWriteLine ) CLASS Uve

      local cLinea

      if empty( ::aLineas )
         msgAlert( "Lineas vacias." )
         Return ( .f. )
      end if

      ::hFile  := fCreate( ::cFile )

      if !empty( ::hFile )
         for each cLinea in ::aLineas
            fWrite( ::hFile, cLinea )
         next
         fClose( ::hFile )
      end if

   Return ( Self )

//---------------------------------------------------------------------------//

Static Function TrimPadr( cString, nLen )

Return ( alltrim( padr( cString, nLen ) ) )

//---------------------------------------------------------------------------//

