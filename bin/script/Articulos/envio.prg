#include "hbclass.ch"

#define CRLF                        chr( 13 ) + chr( 10 )

#define __path__                    "c:\ads\"

static nView
static aBuzones

//---------------------------------------------------------------------------//

Function StartEnvio()

   nView             := D():CreateView()

   D():Clientes( nView )

   D():Articulos( nView )
   ( D():Articulos( nView ) )->( ordSetFocus( "SndCod" ) )

   D():ArticulosCodigosBarras( nView )

   D():FacturasClientes( nView )
   ( D():FacturasClientes( nView ) )->( ordSetFocus( "SndDoc" ) )

   D():FacturasClientesLineas( nView )

   D():Clientes( nView )
   ( D():Clientes( nView ) )->( ordSetFocus( "lSndEnviar" ) )
   
   D():ClientesDirecciones( nView )

   Buzones()

   EnvioArticulos()

   EnvioClientes()

   EnvioFacturas()

   D():DeleteView( nView )

Return nil

//---------------------------------------------------------------------------//

Function Buzones()

   aBuzones             := {}    
   ( D():Clientes( nView ) )->( dbeval(   {|| aAdd( aBuzones, ( rtrim( D():ClientesId( nView ) ) ) ) },;
                                          {|| rtrim( ( D():Clientes( nView ) )->cCodGrp ) == "9999" } ) )
   aeval( aBuzones, {|cBuzon| makedir( __path__ + cBuzon ) } )

Return nil

//---------------------------------------------------------------------------//

Function EnvioArticulos()

   local cFile
   local hArticulo
   local aCodebar       := {}
   local sArticulos
   local aArticulos     := {}

   ( D():Articulos( nView ) )->( dbGoTop() )
   while !( D():Articulos( nView ) )->( eof() )

      hArticulo         := hashRecord( D():Articulos( nView ) )

      if ( D():ArticulosCodigosBarras( nView ) )->( dbSeek( ( D():Articulos( nView ) )->Codigo ) )

         aCodebar       := {}

         while ( D():ArticulosCodigosBarras( nView ) )->cCodArt == ( D():Articulos( nView ) )->Codigo .and. !( D():ArticulosCodigosBarras( nView ) )->( eof() )

            aAdd( aCodebar, hashRecord( D():ArticulosCodigosBarras( nView ) ) )

            ( D():ArticulosCodigosBarras( nView ) )->( dbSkip( 1 ) ) 

         end while

         hSet( hArticulo, "Codebar", aCodebar )

      end if

      aAdd( aArticulos, hArticulo )

      ( D():Articulos( nView ) )->( dbSkip() )

   end while

   sArticulos           := hb_serialize( aArticulos )
   cFile                := "Articulos" + dtos( date() ) + strtran( time(), ":", "" ) + ".txt"

   aeval( aBuzones, {|cBuzon| hb_memowrit( __path__ + cBuzon + "\" + cFile, sArticulos ) } )

Return ( nil )

//---------------------------------------------------------------------------//

Function EnvioClientes()

   local cFile
   local hCliente
   local aDirecciones   := {}
   local sClientes
   local aClientes      := {}

   ( D():Clientes( nView ) )->( dbGoTop() )
   while !( D():Clientes( nView ) )->( eof() )

      hCliente          := hashRecord( D():Clientes( nView ) )

      if ( D():ClientesDirecciones( nView ) )->( dbSeek( ( D():ClientesId( nView ) ) ) )

         aDirecciones   := {}

         while ( D():ClientesDireccionesId( nView ) == D():ClientesId( nView ) ) .and. !( D():ClientesDirecciones( nView ) )->( eof() )

            aAdd( aDirecciones, hashRecord( D():ClientesDirecciones( nView ) ) )

            ( D():ClientesDirecciones( nView ) )->( dbSkip( 1 ) ) 

         end while

         hSet( hCliente, "Direcciones", aDirecciones )

      end if

      aAdd( aClientes, hCliente )

      ( D():Clientes( nView ) )->( dbSkip() )

   end while

   sClientes            := hb_serialize( aClientes )
   cFile                := "Clientes" + dtos( date() ) + strtran( time(), ":", "" ) + ".txt"

   aeval( aBuzones, {|cBuzon| hb_memowrit( __path__ + cBuzon + "\" + cFile, sClientes ) } )

Return ( nil )

//---------------------------------------------------------------------------//

Function EnvioFacturas()

   local cFile
   local aLineas        := {}
   local cCliente
   local hFactura
   local sFacturas
   local aFacturas      := {}

   ( D():FacturasClientes( nView ) )->( dbGoTop() )
   while !( D():FacturasClientes( nView ) )->( eof() )

      cCliente          := alltrim( ( D():FacturasClientes( nView ) )->cCodCli )
      hFactura          := hashRecord( D():FacturasClientes( nView ) )

      if ( D():FacturasClientesLineas( nView ) )->( dbSeek( D():FacturasClientesId( nView ) ) )

         aLineas        := {}

         while ( D():FacturasClientesLineasId( nView ) == D():FacturasClientesId( nView ) ) .and. !( D():FacturasClientesLineasId( nView ) )->( eof() )

            aAdd( aLineas, hashRecord( D():FacturasClientesLineas( nView ) ) )

            ( D():FacturasClientesLineas( nView ) )->( dbSkip( 1 ) ) 

         end while

         hSet( hFactura, "Lineas", aLineas )

      end if

      aAdd( aFacturas, hFactura )

      ( D():FacturasClientes( nView ) )->( dbSkip() )

   end while

   sFacturas            := hb_serialize( aFacturas )
   cFile                := "FacturasClientes" + dtos( date() ) + strtran( time(), ":", "" ) + ".txt"

   makedir( __path__ + cCliente )
   hb_memowrit( __path__ + cCliente + "\" + cFile, sFacturas )

Return ( nil )
   
//---------------------------------------------------------------------------//

