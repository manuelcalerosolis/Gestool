#include "hbclass.ch"

#define CRLF chr( 13 ) + chr( 10 )

//---------------------------------------------------------------------------//

Function Inicio()

/*
   local oError
   local oBlock

   oBlock               := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE
*/
   
   ImportacionUVERisi():New()

/*
   RECOVER USING oError
      msgStop( "Error en la ejecución del script." + CRLF + ErrorMessage( oError ) )
   END SEQUENCE
   ErrorBlock( oBlock )
*/

Return ( nil )

//---------------------------------------------------------------------------//

CREATE CLASS ImportacionUVERisi

   DATA nView

   DATA oUve

   DATA oDlg

   DATA cFileUVE
   DATA nFileHandle

   DATA aUVELines                               INIT {}

   DATA currentInvoice

   DATA calculateInvoice

   DATA serieInvoice
   DATA numberInvoice
   DATA delegationInvoice

   DATA nLineNumber                             INIT 0

   DATA aSepartors                              INIT { "|#|", ";" }
   DATA cSeparator                              INIT "|#|"

   DATA oComboDistributor

   DATA aDitributors                            INIT { "90 - Blanco", "91 - Begines", "92 - Dismaga", "Vacio" }
   DATA cDistributor                            INIT "90 - Blanco"

   DATA oComboSeparator
   DATA oComboDistributor

   METHOD New()                                 CONSTRUCTOR
   METHOD Dialog() 

   METHOD getFileUVE()
   METHOD isFileUVE() 
   METHOD openFileUVE()
   METHOD closeFileUVE()                        INLINE ( fclose( ::nFileHandle ) )
   METHOD processFileUVE()
      METHOD processLineUVE( cLine)             
         METHOD insertLineUVE( aLine )
   METHOD sortUveLinesByInvoiceId()
   METHOD processUVELinesByInvoiceId()
      METHOD isInvoiceChange( hUVELine )        
      METHOD insertInvoiceHeader( hUVELine )
      METHOD getNewInvoiceNumber( hUVELine )
      METHOD insertInvoiceLine( hUVELine )

   METHOD deleteInvoiceIfExist()

   METHOD isClient( hUVELine )
      METHOD createClient( hUVELine )

   METHOD isProduct( hUVELine )
      METHOD createProduct( hUVELine )

   METHOD isGrupoCliente( hUVELine )
      METHOD createGrupoCliente( hUVELine )

   METHOD isRuta( hUVELine )  
      METHOD createRuta( hUVELine )      

   METHOD isAgente( hUVELine )
      METHOD createAgente( hUVELine )
   
   METHOD writeUVEtoGestool()                   VIRTUAL

   METHOD OpenFiles()
   METHOD CloseFiles()                          INLINE ( D():DeleteView( ::nView ) )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS ImportacionUVERisi

   if !::Dialog()
      Return ( Self )
   end if

   ::getFileUVE()

   if !::isFileUVE()
      Return ( Self )
   end if

   if ::openFileUVE()
      ::processFileUVE()
      ::closeFileUVE()
   end if 

   if !::OpenFiles()
      Return ( Self )
   end if 

   ::sortUveLinesByInvoiceId()

   ::processUVELinesByInvoiceId()

   ::CloseFiles()

   msgInfo( "Proceso finalizado" )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD Dialog() CLASS ImportacionUVERisi

   ::oDlg          := TDialog():New( 5, 5, 18, 60, "Importacion UVE Risi" )

   TSay():New( 1, 1, {|| "Separador" }, ::oDlg )      

   ::oComboSeparator    := TComboBox():New( 1, 6, {| u | if( pcount() == 0, ::cSeparator, ::cSeparator := u ) }, ::aSepartors, 100, , ::oDlg, , , , , , .f., nil, , .f., , .f., , , , , , "ocbx1" )

   TSay():New( 2, 1, {|| "Distribuidor" }, ::oDlg )      

   ::oComboDistributor  := TComboBox():New( 2, 6, {| u | if( pcount() == 0, ::cDistributor, ::cDistributor := u ) }, ::aDitributors, 100, , ::oDlg, , , , , , .f., nil, , .f., , .f., , , , , , "ocbx2" )

   TButton():New( 4, 4, "&Aceptar", ::oDlg, {|| ::oDlg:end( 1 ) }, 40, 12 )

   TButton():New( 4, 12, "&Cancel", ::oDlg, {|| ::oDlg:End() }, 40, 12 )

   ::oDlg:Activate( , , , .t. )

Return ( ::oDlg:nResult == 1 )

//---------------------------------------------------------------------------//


METHOD getFileUVE()

   ::cFileUVE  := cGetFile( "Csv ( *.* ) | " + "*.*", "Seleccione el fichero a importar" )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD isFileUVE()

   if !empty( ::cFileUVE )
      Return ( file( ::cFileUVE ) )
   end if 

Return ( .f. )

//---------------------------------------------------------------------------//

METHOD openFileUVE()

   ::nFileHandle := fOpen( ::cFileUVE )

   if ferror() != 0
      Return ( .f. )
   end if  

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD processFileUVE()

   local cLine 

   while ( hb_freadline( ::nFileHandle, @cLine ) == 0 )
      ::processLineUVE( cLine )
   end while  
   
Return ( Self )

//---------------------------------------------------------------------------//

METHOD processLineUVE( cLine )

   local aLine

   // msgalert( cLine, "cLine" )

   aLine          := hb_atokens( cLine, ::cSeparator )

   if !( hb_isarray( aLine ) )
      msgalert( "La linea no se puede convertir en array.", "", .1 )
      Return ( Self )
   end if 

   if !( len( aLine ) >= 30 )
      msgwait( hb_valtoexp( aline ), "la linea no contiene los campos necesarios", .1 )
      Return ( Self )
   end if 

   ::insertLineUVE( aLine )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD insertLineUVE( aLine )

   local hUve   := {=>}

   // msgalert( aLine[ 1 ], "numero factura" )

   hset( hUve, "NumeroFactura",                 aLine[ 1 ] )
   hset( hUve, "NumeroLinea",                   aLine[ 2 ] )
   hset( hUve, "CodigoProducto",                aLine[ 3 ] )
   hset( hUve, "DescripcionProducto",           aLine[ 4 ] )
   hset( hUve, "Fabricante",                    aLine[ 5 ] )
   hset( hUve, "CodigoProductoFabricante",      aLine[ 6 ] )
   hset( hUve, "EAN13",                         aLine[ 7 ] )
   hset( hUve, "Cantidad",                      val( aLine[ 8 ] ) )
   hset( hUve, "UnidadMedicion",                aLine[ 9 ] )
   hset( hUve, "PrecioBase",                    val( aLine[ 10 ] ) )
   hset( hUve, "Descuentos",                    val( aLine[ 11 ] ) )
   hset( hUve, "PrecioBrutoTotal",              val( aLine[ 12 ] ) )
   hset( hUve, "FechaFactura",                  aLine[ 13 ] )
   hset( hUve, "Ejercicio",                     aLine[ 14 ] )
   hset( hUve, "CodigoCliente",                 aLine[ 15 ] )
   hset( hUve, "Establecimiento",               aLine[ 16 ] )
   hset( hUve, "Nombre",                        aLine[ 17 ] )
   hset( hUve, "CIF",                           aLine[ 18 ] )
   hset( hUve, "Direccion",                     aLine[ 19 ] )
   hset( hUve, "Poblacion",                     aLine[ 20 ] )
   hset( hUve, "CodigoPostal",                  aLine[ 21 ] )
   hset( hUve, "Ruta",                          aLine[ 22 ] )
   hset( hUve, "NombreRuta",                    aLine[ 23 ] )
   hset( hUve, "CodigoComercial",               aLine[ 24 ] )
   hset( hUve, "NombreComercial",               aLine[ 25 ] )
   hset( hUve, "Peso",                          val( aLine[ 26 ] ) )
   hset( hUve, "UMPeso",                        aLine[ 27 ] )
   hset( hUve, "TipoCliente",                   aLine[ 28 ] )
   hset( hUve, "Telefono",                      aLine[ 29 ] )
   hset( hUve, "DescripciónTipoCliente",        aLine[ 30 ] )

//   msgalert( hb_valtoexp( hUve ), "hUve" )

   aadd( ::aUVELines, hUve )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() 

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

      D():GrupoClientes( ::nView )

      D():Get( "ArtCodebar", ::nView )  

      D():Get( "Ruta", ::nView )

      D():Get( "Agentes", ::nView )

      D():Contadores( ::nView )

   RECOVER USING oError

      lOpenFiles        := .f.

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lOpenFiles )

//---------------------------------------------------------------------------//

METHOD sortUveLinesByInvoiceId()

   // asort( ::aUVELines, , , {|x,y| hget( x, "NumeroFactura" ) < hget( y, "NumeroFactura" ) } ) // + hget( y, "NumeroLinea" )

Return ( self )

//---------------------------------------------------------------------------//

METHOD processUVELinesByInvoiceId()

   local hUVELine

   for each hUVELine in ::aUVELines 

      if ::isInvoiceChange( hUVELine )

         if !( ::isClient( hUVELine ) )
            ::createClient( hUVELine )
         end if 

         ::getNewInvoiceNumber( hUVELine )
   	
         ::deleteInvoiceIfExist()

         ::insertInvoiceHeader( hUVELine )

      end if

      if !( ::isProduct( hUVELine ) )
         ::createProduct( hUVELine )
      end if 

      if !( ::isGrupoCliente( hUVELine ) )
         ::createGrupoCliente( hUVELine )
      end if 

      if !( ::isRuta( hUVELine ) )
         ::createRuta( hUVELine )
      end if 

      if !( ::isAgente( hUVELine ) )
         ::createAgente( hUVELine )
      end if 

      ::insertInvoiceLine( hUVELine )

   next

Return ( self )

//---------------------------------------------------------------------------//

METHOD getNewInvoiceNumber( hUVELine )

   ::currentInvoice     	:= hget( hUVELine, "NumeroFactura" )
   
	if ::cDistributor == "Vacio"
		
		::serieInvoice       := substr( ::currentInvoice, 1, 1 )
   	::numberInvoice      := val( substr( ::currentInvoice, 2, 9 ) )
   	::delegationInvoice  := substr( ::currentInvoice, 11, 2 )

		::calculateInvoice 	:= ::currentInvoice 

	else

   	::delegationInvoice  := substr( ::cDistributor, 1, 2 )
   	::calculateInvoice 	:= ::currentInvoice + "." + ::delegationInvoice

	   ::serieInvoice       := "A"
   	::numberInvoice      := nNewDoc( ::serieInvoice, D():FacturasClientes( ::nView ), "nFacCli", , D():Contadores( ::nView ) )
   
   end if 

Return ( self )

//---------------------------------------------------------------------------//

METHOD isClient( hUVELine )

Return ( dbSeekInOrd( hget( hUVELine, "CodigoCliente" ), "Cod", D():Clientes( ::nView ) ) )

//---------------------------------------------------------------------------//

METHOD createClient( hUVELine )

   ( D():Clientes( ::nView ) )->( dbappend() )

   ( D():Clientes( ::nView ) )->Cod       := hget( hUVELine, "CodigoCliente" )
   ( D():Clientes( ::nView ) )->Titulo    := hget( hUVELine, "Nombre" )
   ( D():Clientes( ::nView ) )->NbrEst    := hget( hUVELine, "Establecimiento" )
   ( D():Clientes( ::nView ) )->Nif       := hget( hUVELine, "CIF" )
   ( D():Clientes( ::nView ) )->Domicilio := hget( hUVELine, "Direccion" )
   ( D():Clientes( ::nView ) )->Poblacion := hget( hUVELine, "Poblacion" )
   ( D():Clientes( ::nView ) )->CodPostal := hget( hUVELine, "CodigoPostal" )
   ( D():Clientes( ::nView ) )->Telefono  := hget( hUVELine, "Telefono" )

   ( D():Clientes( ::nView ) )->cCodGrp   := rjust( hget( hUVELine, "TipoCliente" ), "0", 4 )

   ( D():Clientes( ::nView ) )->cCodRut   := hget( hUVELine, "Ruta" )

   ( D():Clientes( ::nView ) )->( dbrunlock() )

Return ( self )

//---------------------------------------------------------------------------//

METHOD deleteInvoiceIfExist()

   local cNumeroFactura    := ::serieInvoice + str( ::numberInvoice ) + ::delegationInvoice

   while D():gotoIdFacturasClientes( cNumeroFactura, ::nView ) .and. !( D():FacturasClientes( ::nView ) )->( eof() )
      if dbLock( D():FacturasClientes( ::nView ) )
         ( D():FacturasClientes( ::nView ) )->( dbDelete() )
         ( D():FacturasClientes( ::nView ) )->( dbUnLock() )
      end if 
   end while

   while D():seekInOrd( D():FacturasClientesLineas( ::nView ), cNumeroFactura, "nNumFac" ) .and. !( D():FacturasClientesLineas( ::nView ) )->( eof() )
      if dbLock( D():FacturasClientesLineas( ::nView ) )
         ( D():FacturasClientesLineas( ::nView ) )->( dbDelete() )
         ( D():FacturasClientesLineas( ::nView ) )->( dbUnLock() )
      end if 
   end while

Return ( Self )

//---------------------------------------------------------------------------//

METHOD insertInvoiceHeader( hUVELine )
   
   ( D():FacturasClientes( ::nView ) )->( dbappend() )
   ( D():FacturasClientes( ::nView ) )->cSerie     := ::serieInvoice
   ( D():FacturasClientes( ::nView ) )->nNumFac    := ::numberInvoice
   ( D():FacturasClientes( ::nView ) )->cSufFac    := ::delegationInvoice

   // recerencia a la factura de UVE-------------------------------------------

   ( D():FacturasClientes( ::nView ) )->cSuFac     := ::calculateInvoice

   ( D():FacturasClientes( ::nView ) )->cCodAlm    := oUser():cAlmacen()
   ( D():FacturasClientes( ::nView ) )->cCodCaj    := oUser():cCaja()
   ( D():FacturasClientes( ::nView ) )->cDivFac    := cDivEmp()
   ( D():FacturasClientes( ::nView ) )->nVdvFac    := nChgDiv()
   ( D():FacturasClientes( ::nView ) )->cCodUsr    := cCurUsr()
   ( D():FacturasClientes( ::nView ) )->dFecCre    := date() 
   ( D():FacturasClientes( ::nView ) )->cTimCre    := time() 
   ( D():FacturasClientes( ::nView ) )->cCodDlg    := oUser():cDelegacion()

	if ::cDistributor == "Vacio"
	   ( D():FacturasClientes( ::nView ) )->dFecFac := stod( hget( hUVELine, "FechaFactura" ) )
	else
	   ( D():FacturasClientes( ::nView ) )->dFecFac := ctod( hget( hUVELine, "FechaFactura" ) )
	end if

   ( D():FacturasClientes( ::nView ) )->cCodCli    := hget( hUVELine, "CodigoCliente" )
   ( D():FacturasClientes( ::nView ) )->cNomCli    := hget( hUVELine, "Nombre" )
   ( D():FacturasClientes( ::nView ) )->cDniCli    := hget( hUVELine, "CIF" )
   ( D():FacturasClientes( ::nView ) )->cDirCli    := hget( hUVELine, "Direccion" )
   ( D():FacturasClientes( ::nView ) )->cPobCli    := hget( hUVELine, "Poblacion" )
   ( D():FacturasClientes( ::nView ) )->cPosCli    := hget( hUVELine, "CodigoPostal" )

   ( D():FacturasClientes( ::nView ) )->cCodRut    := hget( hUVELine, "Ruta" )
   ( D():FacturasClientes( ::nView ) )->cCodAge    := hget( hUVELine, "CodigoComercial" )

   ( D():FacturasClientes( ::nView ) )->( dbrunlock() )
   
   ::nLineNumber        := 1

Return ( self )

//---------------------------------------------------------------------------//

METHOD isProduct( hUVELine )

Return ( dbSeekInOrd( hget( hUVELine, "CodigoProducto" ), "Codigo", D():Articulos( ::nView ) ) )

//---------------------------------------------------------------------------//

METHOD createProduct( hUVELine )

   ( D():Articulos( ::nView ) )->( dbappend() )

   ( D():Articulos( ::nView ) )->Codigo      := hget( hUVELine, "CodigoProducto" )
   ( D():Articulos( ::nView ) )->Nombre      := hget( hUVELine, "DescripcionProducto" )
   ( D():Articulos( ::nView ) )->pVenta1     := hget( hUVELine, "PrecioBase" )
   ( D():Articulos( ::nView ) )->Familia     := "00001"
   
   ( D():Articulos( ::nView ) )->( dbrunlock() )

Return ( self )

//---------------------------------------------------------------------------//

METHOD insertInvoiceLine( hUVELine )

   ( D():FacturasClientesLineas( ::nView ) )->( dbappend() )

   ( D():FacturasClientesLineas( ::nView ) )->cSerie     := ::serieInvoice
   ( D():FacturasClienteslineas( ::nView ) )->nNumFac    := ::numberInvoice
   ( D():FacturasClienteslineas( ::nView ) )->cSufFac    := ::delegationInvoice

   ( D():FacturasClientesLineas( ::nView ) )->cAlmLin    := oUser():cAlmacen()

   ( D():FacturasClienteslineas( ::nView ) )->nNumLin    := ::nLineNumber
   ( D():FacturasClienteslineas( ::nView ) )->nPosPrint  := ::nLineNumber

   ( D():FacturasClienteslineas( ::nView ) )->cRef       := hget( hUVELine, "CodigoProducto" )
   ( D():FacturasClienteslineas( ::nView ) )->cDetalle   := hget( hUVELine, "DescripcionProducto" )
   ( D():FacturasClienteslineas( ::nView ) )->nUniCaja   := hget( hUVELine, "Cantidad" )
   ( D():FacturasClienteslineas( ::nView ) )->nPreUnit   := hget( hUVELine, "PrecioBase" )
   ( D():FacturasClienteslineas( ::nView ) )->nDtoDiv    := hget( hUVELine, "Descuentos" )
   ( D():FacturasClienteslineas( ::nView ) )->nIva       := 10
   ( D():FacturasClienteslineas( ::nView ) )->nPesoKg    := hget( hUVELine, "Peso" )
   ( D():FacturasClienteslineas( ::nView ) )->cPesoKg    := hget( hUVELine, "UMPeso" )

   ( D():FacturasClientesLineas( ::nView ) )->( dbrunlock() )

   ::nLineNumber++
   
Return ( self )

//---------------------------------------------------------------------------//

METHOD isGrupoCliente( hUVELine )

Return ( dbSeekInOrd( rjust( hget( hUVELine, "TipoCliente" ), "0", 4 ), "cCodGrp", D():GrupoClientes( ::nView ) ) )

//---------------------------------------------------------------------------//

METHOD createGrupoCliente( hUVELine )

   ( D():GrupoClientes( ::nView ) )->( dbappend() )

   ( D():GrupoClientes( ::nView ) )->cCodGrp    := rjust( hget( hUVELine, "TipoCliente" ), "0", 4 )
   ( D():GrupoClientes( ::nView ) )->cNomGrp    := hget( hUVELine, "DescripciónTipoCliente" )

   ( D():GrupoClientes( ::nView ) )->( dbrunlock() )

Return ( self )

//---------------------------------------------------------------------------//

METHOD isRuta( hUVELine )

Return ( dbSeekInOrd( hget( hUVELine, "Ruta" ), "cCodRut", D():Get( "Ruta", ::nView ) ) )

//---------------------------------------------------------------------------//

METHOD createRuta( hUVELine )

   ( D():Get( "Ruta", ::nView ) )->( dbappend() )

   ( D():Get( "Ruta", ::nView ) )->cCodRut    := hget( hUVELine, "Ruta" )
   ( D():Get( "Ruta", ::nView ) )->cDesRut    := hget( hUVELine, "NombreRuta" )

   ( D():Get( "Ruta", ::nView ) )->( dbrunlock() )

Return ( self )

//---------------------------------------------------------------------------//

METHOD isAgente( hUVELine )

Return ( dbSeekInOrd( hget( hUVELine, "CodigoComercial" ), "cCodAge", D():Get( "Agentes", ::nView ) ) )

//---------------------------------------------------------------------------//

METHOD createAgente( hUVELine )

   ( D():Get( "Agentes", ::nView ) )->( dbappend() )

   ( D():Get( "Agentes", ::nView ) )->cCodAge    := hget( hUVELine, "CodigoComercial" )
   ( D():Get( "Agentes", ::nView ) )->cApeAge    := hget( hUVELine, "NombreComercial" )

   ( D():Get( "Agentes", ::nView ) )->( dbrunlock() )

Return ( self )

//---------------------------------------------------------------------------//

METHOD isInvoiceChange( hUVELine )

Return ( hget( hUVELine, "NumeroFactura" ) != ::currentInvoice )

//---------------------------------------------------------------------------//
