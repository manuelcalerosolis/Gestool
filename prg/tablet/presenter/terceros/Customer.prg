#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS Customer FROM DocumentsSales

   DATA oClienteIncidencia

   DATA oViewIncidencia

   DATA cTipoCliente             INIT ""

   DATA hTipoCliente             INIT { "1" => "Clientes", "2" => "Potenciales", "3" => "Web" }

   METHOD New()

   METHOD Init( nView )

   METHOD setEnviroment()        INLINE ( ::setDataTable( "Client" ) ) 
   
   METHOD showIncidencia()       INLINE ( ::oClienteIncidencia:showNavigator() )

   METHOD Resource()             INLINE ( ::oViewEdit:Resource() )   

   METHOD onPostGetDocumento()
   METHOD onPreSaveDocumento()   

   METHOD setFilterAgentes()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS Customer

   if ::OpenFiles()

      ::setFilterAgentes()

      ::oViewNavigator        := CustomerViewSearchNavigator():New( self )

      ::oViewEdit             := CustomerView():New( self )

      ::oClienteIncidencia    := CustomerIncidence():New( self )

      ::setEnviroment()

      ::oViewNavigator:showView()

      ::CloseFiles()

   end if   

Return ( self )

//---------------------------------------------------------------------------//

METHOD Init( oSender ) CLASS Customer

   ::nView                 := oSender:nView

   ::oViewEdit             := CustomerView():New( self )

   ::oClienteIncidencia    := CustomerIncidence():New( self )

   ::setEnviroment()

Return ( self )

//---------------------------------------------------------------------------//

METHOD onPostGetDocumento() CLASS Customer

   local cTipo          := str( hGet( ::hDictionaryMaster, "TipoCliente" ) )

   if !empty( cTipo )
      if hHasKey( ::hTipoCliente, cTipo )
         ::cTipoCliente := hGet( ::hTipoCliente, cTipo )
      end if 
   end if 

   if ::lAppendMode()
      hSet( ::hDictionaryMaster, "Codigo", D():getLastKeyClientes( ::nView ) )
   end if 

Return ( .t. )   

//---------------------------------------------------------------------------//

METHOD onPreSaveDocumento() CLASS Customer

   local nScan
   local nTipoCliente      := 1

   nScan                   := hScan( ::hTipoCliente, {|k,v,i| v == ::cTipoCliente } )   
   if nScan != 0 
      nTipoCliente         := val( hGetKeyAt( ::hTipoCliente, nScan ) )
   end if 

   hSet( ::hDictionaryMaster, "TipoCliente", nTipoCliente ) 

Return ( .t. )   

//---------------------------------------------------------------------------//

METHOD setFilterAgentes() CLASS Customer

   local cCodigoAgente     := AccessCode():cAgente

   if !empty(cCodigoAgente)
      ( D():Clientes( ::nView ) )->( dbsetfilter( {|| Field->cAgente == cCodigoAgente }, "cAgente == cCodigoAgente" ) )
      ( D():Clientes( ::nView ) )->( dbgotop() )
   end if 

Return ( .t. )   

//---------------------------------------------------------------------------//



