#include "hbclass.ch"

#define CRLF chr( 13 ) + chr( 10 )ImportacionUVERisi

//---------------------------------------------------------------------------//

Function Inicio()

   ImportacionUVERisi():New()

Return ( nil )

//---------------------------------------------------------------------------//

CREATE CLASS ImportacionUVERisi

   DATA nView

   DATA oUve

   DATA hProducto

   DATA dInicio             INIT    ( BoM( Date() ) ) 
   DATA dFin                INIT    ( EoM( Date() ) ) 

   DATA oDlg
   DATA oSayDesde
   DATA oGetDesde
   DATA oSayHasta
   DATA oGetHasta
   DATA oSayMessage

   DATA cDelegacion

   DATA oInt
   DATA oFtp

   DATA lPassiveFtp         INIT    .t.
   DATA cUserFtp            INIT    "manolo"
   DATA cPasswdFtp          INIT    "123Ab456"
   DATA cHostFtp            INIT    "ftp.gestool.es"

   DATA aClientesExcluidos  INIT    {}

   METHOD New()                                 CONSTRUCTOR

   METHOD isFileExcel()
   METHOD proccessFileExcel()

   METHOD OpenFiles()
   METHOD CloseFiles()                          INLINE ( D():DeleteView( ::nView ) )

   METHOD ProcessFile()

   METHOD findMainCodeInHash( cCodigoBarra )
   METHOD findCodigoInternoInHash( cCodigoInterno )

   METHOD validateInvoice()       

   METHOD getCantidad()
   METHOD getPrecioBase()

   METHOD getDelegacion()                       INLINE ( oUser():cDelegacion() )

   METHOD SendFile()

   METHOD ftpCreateConexion()
   METHOD ftpEndConexion()
   METHOD ftpCreateFile( cFile )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS FacturasClientesRisi

   if !::OpenFiles()
      Return ( Self )
   end if 

   if ::isFileExcel() 
      ::proccessFileExcel()      
   end if 

   ::CloseFiles()

   msgInfo( "Porceso finalizado : " + if( !empty( ::oUve ), ::oUve:cFile, "" ) )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD isFileExcel() CLASS FacturasClientesRisi

   ::cFileExcel  := cGetFile( "Excel ( *.Xls ) | " + "*.Xls", "Seleccione la hoja de calculo" )

Return ( file( ::cFileExcel ) )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS FacturasClientesRisi

   local oError
   local oBlock
   local lOpenFiles     := .t.

   oBlock               := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::nView           := D():CreateView()

      D():FacturasClientes( ::nView )
      ( D():FacturasClientes( ::nView ) )->( ordsetfocus( "dFecFac" ) )

      D():FacturasClientesLineas( ::nView )    
      ( D():FacturasClientesLineas( ::nView ) )->( ordsetfocus( "nNumLin" ) )

      D():Clientes( ::nView )

      D():Articulos( ::nView )

      D():GruposClientes( ::nView )

      D():Get( "ArtCodebar", ::nView )  

      D():Get( "Ruta", ::nView )

      D():Get( "Agentes", ::nView )

   RECOVER USING oError

      lOpenFiles        := .f.

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lOpenFiles )

//---------------------------------------------------------------------------//

METHOD ProcessFile() CLASS FacturasClientesRisi

   local cCodigoRuta    := ""
   local cCodigoGrupo   := ""
   local cNombreGrupo   := ""
   local cCodigoBarra   := ""
   local cCodigoInterno := ""
   local cUbicacion     := ""

   CursorWait()

   ::oUve               := Uve():New()

   ( D():FacturasClientes( ::nView ) )->( dbseek( ::dInicio, .t. ) )
   
   while ( D():FacturasClientes( ::nView ) )->dFecFac <= ::dFin .and. ( D():FacturasClientes( ::nView ) )->( !eof() )

      ::oSayMessage:setText( "Progreso : " + alltrim( str( ( D():FacturasClientes( ::nView ) )->( ordkeyno() ) ) ) + " de " + alltrim( str( ( D():FacturasClientes( ::nView ) )->( ordkeycount() ) ) ) )

      if ( ::validateInvoice() ) .and. ( D():FacturasClientesLineas( ::nView ) )->( dbSeek( D():FacturasClientesId( ::nView ) ) )

         while ( D():FacturasClientesId( ::nView ) == D():FacturasClientesLineasId( ::nView ) ) .and. ( D():FacturasClientesLineas( ::nView ) )->( !eof() ) 

            if ( D():Articulos( ::nView ) )->( dbSeek( ( D():FacturasClientesLineas( ::nView ) )->cRef ) )

               // Codigo de la familia-----------------------------------------

               cCodigoInterno             := ( D():Articulos( ::nView ) )->Codigo
               cCodigoBarra               := ( D():Articulos( ::nView ) )->CodeBar
               cUbicacion                 := ( D():Articulos( ::nView ) )->cDesUbi 

               if ::findMainCodeInHash( cUbicacion )

                  // Codigo del grupo-------------------------------------------

                  if ( D():Clientes( ::nView ) )->( dbSeek( ( D():FacturasClientes( ::nView ) )->cCodCli ) )
                     cCodigoGrupo         := ( D():Clientes( ::nView ) )->cCodGrp

                     if !empty(cCodigoGrupo)
                        cNombreGrupo      := oRetFld( cCodigoGrupo, D():Get( "GruposClientes", ::nView ):oDbf, "cNomGrp" )
                     end if

                  end if 

                  // Codigo de la ruta--------------------------------------------

                  cCodigoRuta             := ( D():FacturasClientes( ::nView ) )->cCodRut
                  if empty( cCodigoRuta )
                     cCodigoRuta          := ( D():Clientes( ::nView ) )->cCodRut
                  end if 

                  ::oUve:NumFactura(      D():FacturasClientesLineasId( ::nView ) ) 
                  ::oUve:NumLinea(        ( D():FacturasClientesLineas( ::nView ) )->nNumLin ) 
                  ::oUve:CodigoProducto(  ::hProducto[ "Codigo" ] ) 
                  ::oUve:DescProducto(    ::hProducto[ "Nombre" ] )
                  ::oUve:Fabricante(      'RISI' )
                  ::oUve:CodigoProdFab(   ::hProducto[ "Codigo unidades" ] ) // RetFld( ( D():FacturasClientesLineas( ::nView ) )->cRef, D():Get( "ArtCodebar", ::nView ), "cCodBar", "cDefArt" )
                  ::oUve:EAN13(           ::hProducto[ "Codigo unidades" ] ) // RetFld( ( D():FacturasClientesLineas( ::nView ) )->cRef, D():Get( "ArtCodebar", ::nView ), "cCodBar", "cDefArt" )

                  ::oUve:Cantidad(        ::getCantidad() )

                  ::oUve:UM(              'UN' )
                  ::oUve:PrecioBase(      ::getPrecioBase() )
                  ::oUve:Descuentos(      nDtoLFacCli( D():FacturasClientesLineas( ::nView ) ) / ::getCantidad() )
                  ::oUve:PrecioBrutoTotal(nTotLFacCli( D():FacturasClientesLineas( ::nView ) ) )

                  ::oUve:FechaFra(        ( D():FacturasClientes( ::nView ) )->dFecFac )
                  ::oUve:Ejercicio(       Year( ( D():FacturasClientes( ::nView ) )->dFecFac ) )
                  ::oUve:CodigoCliente(   ( alltrim( ( D():FacturasClientes( ::nView ) )->cCodCli ) + "." + ( D():FacturasClientes( ::nView ) )->cSufFac ) )
                  ::oUve:RazonSocial(     ( D():FacturasClientes( ::nView ) )->cNomCli )
                  ::oUve:Nombre(          ( D():Clientes( ::nView ) )->NbrEst )
                  ::oUve:CIF(             ( D():FacturasClientes( ::nView ) )->cDniCli )
                  ::oUve:Direccion(       ( D():FacturasClientes( ::nView ) )->cDirCli )
                  ::oUve:Poblacion(       ( D():FacturasClientes( ::nView ) )->cPobCli )
                  ::oUve:CodigoPostal(    ( D():FacturasClientes( ::nView ) )->cPosCli )
                  ::oUve:Ruta(            cCodigoRuta )
                  ::oUve:NombreRuta(      retFld( cCodigoRuta, D():Get( "Ruta", ::nView ), "cDesRut" ) )
                  ::oUve:CodigoComercial( cCodigoRuta )
                  ::oUve:NombreComercial( retFld( cCodigoRuta, D():Get( "Ruta", ::nView ), "cDesRut" ) )
                  ::oUve:Peso()
                  ::oUve:UMPeso()
                  ::oUve:TipoCliente(     cCodigoGrupo )
                  ::oUve:Telefono(        ( D():FacturasClientes( ::nView ) )->cTlfCli ) 
                  ::oUve:DescTipoCliente( cNombreGrupo )

                  ::oUve:SerializeASCII()

               end if 

            end if 

            ( D():FacturasClientesLineas( ::nView ) )->( dbSkip() ) 
      
         end while
   
      end if 

      ( D():FacturasClientes( ::nView ) )->( dbskip() )

      sysrefresh()

   end while

   ::oUve:WriteASCII()

   CursorWE()

   ::oSayMessage:setText( "Fichero generado " + ::oUve:cFile )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD findMainCodeInHash( cMainCode ) CLASS FacturasClientesRisi

    local hProducto

    ::hProducto             := nil

    cMainCode               := alltrim( cMainCode )

    if empty( cMainCode )
        RETURN .f.
    end if 

    for each hProducto in ::aProductos

        if hProducto[ "Codigo" ] == cMainCode
            ::hProducto       := hProducto
        end if 

    next 

RETURN ( ::hProducto != nil )

//---------------------------------------------------------------------------//

METHOD findCodigoInternoInHash( cCodigoInterno ) CLASS FacturasClientesRisi

    local hProducto

    ::hProducto             := nil

    cCodigoInterno          := alltrim( cCodigoInterno )

    for each hProducto in ::aProductos

        if hProducto[ "Codigo interno" ] == cCodigoInterno
            ::hProducto       := hProducto
        end if 

    next 

RETURN ( ::hProducto != nil )

//---------------------------------------------------------------------------//

METHOD getCantidad() CLASS FacturasClientesRisi

      local nUnidades   := ( D():Articulos( ::nView ) )->nUniCaja 
      local nCantidad   := nTotNFacCli( D():FacturasClientesLineas( ::nView ) )

      if nUnidades != 0
         nCantidad      := nCantidad / nUnidades
      end if 

RETURN ( nCantidad )

//---------------------------------------------------------------------------//

METHOD getPrecioBase() CLASS FacturasClientesRisi

      local nUnidades   := ( D():Articulos( ::nView ) )->nUniCaja 
      local nPrecioBase := nTotUFacCli( D():FacturasClientesLineas( ::nView ) )

      if nUnidades != 0
         nPrecioBase    := nPrecioBase * nUnidades
      end if 

RETURN ( nPrecioBase )

//---------------------------------------------------------------------------//

METHOD validateInvoice() CLASS FacturasClientesRisi

    if !( ( D():FacturasClientes( ::nView ) )->cSerie $ "AB" )
        Return .f.
    end if 

    if ascan( ::aClientesExcluidos, {|cCodigoCliente| alltrim( ( D():FacturasClientes( ::nView ) )->cCodCli ) == cCodigoCliente } ) != 0
        Return .f.
    end if 

Return .t.

//---------------------------------------------------------------------------//

METHOD SendFile() CLASS FacturasClientesRisi

    if ::ftpCreateConexion()
        
        ::oFtp:SetCurrentDirectory( "httpdocs" )
        ::oFtp:SetCurrentDirectory( "uve" )
        ::ftpCreateFile( ::oUve:cFile )
        ::ftpEndConexion()                
    
        msgInfo( "Fichero " + ::oUve:cFile + " subido." )

    end if 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ftpCreateConexion() CLASS FacturasClientesRisi

   local lCreate     := .f.

   if !empty( ::cHostFtp )   

      ::oInt         := TInternet():New()
      ::oFtp         := TFtp():New( ::cHostFtp, ::oInt, ::cUserFtp, ::cPasswdFtp, ::lPassiveFtp )

      if !empty( ::oFtp )
         lCreate     := ( ::oFtp:hFtp != 0 )
      end if 

   end if 

Return ( lCreate )

//---------------------------------------------------------------------------//

METHOD ftpEndConexion() CLASS FacturasClientesRisi

   if !empty( ::oInt )
      ::oInt:end()
   end if

   if !empty( ::oFtp )
      ::oFtp:end()
   end if 

Return( nil )

//---------------------------------------------------------------------------//

METHOD ftpCreateFile( cFile ) CLASS FacturasClientesRisi
   
   local oFile
   local nBytes
   local hSource
   local lPutFile    := .f.
   local cBuffer     := Space( 20000 )
   local nTotalBytes := 0
   local nWriteBytes := 0

   if !file( cFile )
      msgStop( "No existe el fichero " + alltrim( cFile ) )
      Return ( .f. )
   end if 

   oFile             := TFtpFile():New( cNoPath( cFile ), ::oFtp )
   oFile:OpenWrite()

   hSource           := fOpen( cFile ) 
   if ferror() == 0

      fseek( hSource, 0, 0 )

      while ( nBytes := fread( hSource, @cBuffer, 20000 ) ) > 0 
         nWriteBytes += nBytes
         oFile:Write( substr( cBuffer, 1, nBytes ) )
      end while

      lPutFile       := .t.

   end if

   oFile:End()

   fClose( hSource )

   SysRefresh()

Return ( lPutFile )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
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

