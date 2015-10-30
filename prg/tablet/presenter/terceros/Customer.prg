#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS Customer FROM Editable

   DATA oClienteIncidencia

   DATA oViewIncidencia

   DATA oGridCustomer

   DATA cTipoCliente                   INIT ""
   DATA hTipoCliente                   INIT { "1" => "Clientes", "2" => "Potenciales", "3" => "Web" }

   METHOD New()
   METHOD Init( nView )

   METHOD runNavigatorCustomer()

   METHOD openFiles()
   METHOD closeFiles()                 INLINE ( D():DeleteView( ::nView ) )

   METHOD setEnviroment()              INLINE ( ::setDataTable( "Client" ) ) 
   
   METHOD showIncidencia()             INLINE ( ::oClienteIncidencia:showNavigator() )

   METHOD Resource()                   INLINE ( ::oViewEdit:Resource() )   

   METHOD setFilterAgentes()

   METHOD onPreSaveEdit()              INLINE ( .t. )
   METHOD onPreEnd()                   INLINE ( .t. )

   METHOD onPostGetDocumento()
   METHOD onPreSaveDocumento()

   METHOD editCustomer( Codigo ) 

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS Customer

   if ::OpenFiles()

      ::setFilterAgentes()

      ::oViewNavigator                       := CustomerViewSearchNavigator():New( self )
      ::oViewNavigator:setTitle( "Clientes" )

      ::oGridCustomer                        := CustomerViewSearchNavigator():New( self )
      ::oGridCustomer:setSelectorMode()
      ::oGridCustomer:setTitle( "Seleccione cliente" )
      ::oGridCustomer:setDblClickBrowseGeneral( {|| ::oGridCustomer:endView() } )

      ::oViewEdit                            := CustomerView():New( self )

      ::oClienteIncidencia                   := CustomerIncidence():New( self )

      ::setEnviroment()

   end if   

Return ( self )

//---------------------------------------------------------------------------//

METHOD Init( oSender ) CLASS Customer

   ::nView                                := oSender:nView

   ::oViewNavigator                       := CustomerViewSearchNavigator():New( self )
   ::oViewNavigator:setTitle( "Clientes" )

   ::oGridCustomer                        := CustomerViewSearchNavigator():New( self )
   ::oGridCustomer:setSelectorMode()
   ::oGridCustomer:setTitle( "Seleccione cliente" )
   ::oGridCustomer:setDblClickBrowseGeneral( {|| ::oGridCustomer:endView() } )

   ::oViewEdit                            := CustomerView():New( self )

   ::oClienteIncidencia                   := CustomerIncidence():New( self )

   ::setEnviroment()

Return ( self )

//---------------------------------------------------------------------------//

METHOD runNavigatorCustomer() CLASS Customer

   if !empty( ::oViewNavigator )
      ::oViewNavigator:showView()
   end if

   ::CloseFiles()

return ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS Customer

   local oError
   local oBlock
   local lOpenFiles     := .t.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::nView           := D():CreateView()

      D():Clientes( ::nView )

      D():ClientesDirecciones( ::nView )

      D():TiposIncidencias( ::nView )

   RECOVER USING oError

      lOpenFiles        := .f.

      ApoloMsgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpenFiles
      ::CloseFiles( "" )
   end if

Return ( lOpenFiles )

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

METHOD EditCustomer( Codigo ) CLASS Customer

   if empty( Codigo )
      Return .f.
   end if 

   D():getStatusClientes( ::nView )

   ( D():Clientes( ::nView ) )->( ordSetFocus( 1 ) )

   if ( D():Clientes( ::nView ) )->( dbseek( Codigo ) )
      ::edit()
   end if 

   D():setStatusClientes( ::nView )

Return( .t. )

//---------------------------------------------------------------------------//