#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS Customer FROM Editable

   DATA oClienteIncidencia
   DATA oGroupCustomer

   DATA oViewIncidencia

   DATA oGridCustomer

   DATA oViewSales

   DATA cTipoCliente                   INIT ""
   DATA hTipoCliente                   INIT { "1" => "Clientes", "2" => "Potenciales", "3" => "Web" }

   DATA cIdCliente                     INIT ""

   METHOD New()
   METHOD Init( nView )
   METHOD Create()

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
   METHOD onPreSaveAppend()

   METHOD editCustomer( Codigo ) 
   METHOD salesCustomer( Codigo )

   METHOD FilterSalesCustomerTable( cTextFilter )

   METHOD RefreshBrowseCustomerSales()

   METHOD liqInvoice( cNumFac )

   METHOD visualizaFactura( cNumFac )

   METHOD runGridGroupCustomer()

   METHOD lValidGroupCustomer()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS Customer

   if ::OpenFiles()

      ::setFilterAgentes()

      ::Create()

   end if   

Return ( self )

//---------------------------------------------------------------------------//

METHOD Init( oSender ) CLASS Customer

   ::nView                                := oSender:nView

   ::Create()

Return ( self )

//---------------------------------------------------------------------------//

METHOD Create() CLASS Customer

   ::oViewNavigator                       := CustomerViewSearchNavigator():New( self )
   ::oViewNavigator:setTitleDocumento( "Clientes" )

   ::oGridCustomer                        := CustomerViewSearchNavigator():New( self )
   ::oGridCustomer:setSelectorMode()
   ::oGridCustomer:setTitleDocumento( "Seleccione cliente" )
   ::oGridCustomer:setDblClickBrowseGeneral( {|| ::oGridCustomer:endView() } )

   ::oViewEdit                            := CustomerView():New( self )

   ::oViewSales                           := CustomerSalesViewSearchNavigator():New( self )

   ::oClienteIncidencia                   := CustomerIncidence():New( self )

   ::oGroupCustomer                       := GroupCustomer():init( self )

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

      D():FacturasClientes( ::nView )

      D():FacturasClientesLineas( ::nView )

      D():FacturasClientesCobros( ::nView )

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

   if !empty( cTipo ) .and. hHasKey( ::hTipoCliente, cTipo )
      ::cTipoCliente    := hGet( ::hTipoCliente, cTipo )
   end if 

   if ::lAppendMode()
      hSet( ::hDictionaryMaster, "Codigo", D():getLastKeyClientes( ::nView ) )
   end if 

Return ( .t. )   

//---------------------------------------------------------------------------//

METHOD onPreSaveAppend() CLASS Customer

   local nScan
   local nTipoCliente      := 1

   nScan                   := hScan( ::hTipoCliente, {|k,v,i| v == ::cTipoCliente } )   
   if nScan != 0 
      nTipoCliente         := val( hGetKeyAt( ::hTipoCliente, nScan ) )
   end if 

   hSet( ::hDictionaryMaster, "TipoCliente", nTipoCliente ) 
   hSet( ::hDictionaryMaster, "EnviarInternet", .t. ) 

Return ( .t. )   

//---------------------------------------------------------------------------//

METHOD setFilterAgentes() CLASS Customer

   local cCodigoAgente     := accessCode():cAgente

   if !empty( cCodigoAgente )
      ( D():Clientes( ::nView ) )->( dbsetfilter( {|| Field->cAgente == cCodigoAgente }, "cAgente == '" + cCodigoAgente + "'" ) )
      ( D():Clientes( ::nView ) )->( dbgotop() )
   end if 

Return ( .t. )   

//---------------------------------------------------------------------------//

METHOD EditCustomer( idCliente ) CLASS Customer

   if empty( idCliente )
      Return .f.
   end if 

   D():getStatusClientes( ::nView )

   ( D():Clientes( ::nView ) )->( ordsetfocus( 1 ) )

   if ( D():Clientes( ::nView ) )->( dbseek( idCliente ) )
      ::edit()
   end if 

   D():setStatusClientes( ::nView )

Return( .t. )

//---------------------------------------------------------------------------//

METHOD salesCustomer( idCliente ) CLASS Customer

   if empty( idCliente )
      Return .f.
   end if 

   ::cIdCliente   := idCliente

   D():getStatusFacturasClientes( ::nView )

   ::oViewSales:Resource()

   ( D():FacturasClientes( ::nView ) )->( dbClearFilter() )

   D():setStatusFacturasClientes( ::nView )

Return( .t. )

//---------------------------------------------------------------------------//

METHOD FilterSalesCustomerTable( cTextFilter ) CLASS Customer
   
   ( D():FacturasClientes( ::nView ) )->( dbClearFilter() )
   ( D():FacturasClientes( ::nView ) )->( ordsetfocus( "dFecDes" ) )

   do case
      case cTextFilter == "Todas"
         ( D():FacturasClientes( ::nView ) )->( dbsetfilter( {|| Field->cCodCli == ::cIdCliente }, "cCodCli == '" + ::cIdCliente + "'" ) )

      case cTextFilter == "Pendientes"
         ( D():FacturasClientes( ::nView ) )->( dbsetfilter( {|| !Field->lLiquidada .and. Field->cCodCli == ::cIdCliente }, "!lLiquidada .and. cCodCli == '" + ::cIdCliente + "'" ) )

      case cTextFilter == "Cobradas"
         ( D():FacturasClientes( ::nView ) )->( dbsetfilter( {|| Field->lLiquidada .and. Field->cCodCli == ::cIdCliente }, "lLiquidada .and. cCodCli == '" + ::cIdCliente + "'" ) )

   end case
   
   ( D():FacturasClientes( ::nView ) )->( dbGoTop() )

   ::oViewSales:oBrowse:Refresh()

return ( .t. )

//---------------------------------------------------------------------------//

METHOD RefreshBrowseCustomerSales( cTextFilter ) CLASS Customer

   ::FilterSalesCustomerTable( cTextFilter )

   ::oViewSales:oBrowse:Refresh()   

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD liqInvoice( cNumFac ) CLASS Customer

   local nRec        := ( D():FacturasClientesCobros( ::nView ) )->( Recno() )
   local nOrdAnt     := ( D():FacturasClientesCobros( ::nView ) )->( OrdSetFocus( "fNumFac" ) )

   if ( D():FacturasClientesCobros( ::nView ) )->( dbseek( cNumFac ) )

      while ( D():FacturasClientesCobros( ::nView ) )->cSerie + Str( ( D():FacturasClientesCobros( ::nView ) )->nNumFac ) + ( D():FacturasClientesCobros( ::nView ) )->cSufFac == cNumFac .and.;
            !( D():FacturasClientesCobros( ::nView ) )->( Eof() )

            if !( D():FacturasClientesCobros( ::nView ) )->lCobrado

               /*
               Marco el recibo como cobrado------------------------------------
               */

               if dbLock( D():FacturasClientesCobros( ::nView ) )
                  ( D():FacturasClientesCobros( ::nView ) )->dEntrada   := Date()
                  ( D():FacturasClientesCobros( ::nView ) )->lCobrado   := .t.
                  ( D():FacturasClientesCobros( ::nView ) )->dFecCre    := GetSysDate()
                  ( D():FacturasClientesCobros( ::nView ) )->cHorCre    := Time()
                  ( D():FacturasClientesCobros( ::nView ) )->( dbUnLock() )
               end if

               /*
               Imprimo el recibo como cobrado----------------------------------
               */

               PrnRecCli( ( D():FacturasClientesCobros( ::nView ) )->cSerie + Str( ( D():FacturasClientesCobros( ::nView ) )->nNumFac ) + ( D():FacturasClientesCobros( ::nView ) )->cSufFac + Str( ( D():FacturasClientesCobros( ::nView ) )->nNumRec ) )

            end if

            ( D():FacturasClientesCobros( ::nView ) )->( dbSkip() )

      end while

   end if

   /*
   Cambiamos el estado de la factura liquidada---------------------------------
   */

   ( D():FacturasClientesCobros( ::nView ) )->( OrdSetFocus( nOrdAnt ) )
   ( D():FacturasClientesCobros( ::nView ) )->( dbGoTo( nRec ) )

   nRec        := ( D():FacturasClientes( ::nView ) )->( Recno() )
   nOrdAnt     := ( D():FacturasClientes( ::nView ) )->( OrdSetFocus( "nNumFac" ) )
   
   if ( D():FacturasClientes( ::nView ) )->( dbseek( cNumFac ) )
      
      ChkLqdFacCli( nil,;
                    D():FacturasClientes( ::nView ),;
                    D():FacturasClientesLineas( ::nView ),;
                    D():FacturasClientesCobros( ::nView ),;
                    D():AnticiposClientes( ::nView ),;
                    D():TiposIva( ::nView ),;
                    D():Divisas( ::nView ),;
                    .f. )
   end if

   ( D():FacturasClientes( ::nView ) )->( OrdSetFocus( nOrdAnt ) )
   ( D():FacturasClientes( ::nView ) )->( dbGoTo( nRec ) )

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD visualizaFactura( cNumFac ) CLASS Customer

   local oInvoiceCustomer
   local nRecAnt
   local nOrdAnt

   nRecAnt           := ( D():FacturasClientes( ::nView ) )->( Recno() )
   nOrdAnt           := ( D():FacturasClientes( ::nView ) )->( OrdSetFocus( "nNumFac" ) )

   oInvoiceCustomer  := InvoiceCustomer():Create( ::nView )

   if ( D():FacturasClientes( ::nView ) )->( dbSeek( cNumFac ) )
      oInvoiceCustomer:Zoom()
   else
      ApoloMsgStop( "Error al cargar la factura" )
   end if
   
   ( D():FacturasClientes( ::nView ) )->( OrdSetFocus( nOrdAnt ) )
   ( D():FacturasClientes( ::nView ) )->( dbGoTo( nRecAnt ) )

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD runGridGroupCustomer() CLASS Customer

   ::oViewEdit:oCodigoGrupo:Disable()

   if !empty( ::oGroupCustomer:oGridGroupCustomer )

      ::oGroupCustomer:oGridGroupCustomer:showView()

      if ::oGroupCustomer:oGridGroupCustomer:isEndOk()
         ::oViewEdit:SetGetValue( ( D():GrupoClientes( ::nView ) )->cCodGrp, "CodigoGrupo" )
      end if

      ::lValidGroupCustomer()

   end if

   ::oViewEdit:oCodigoGrupo:Enable()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD lValidGroupCustomer() CLASS Customer

   local nRec
   local nOrdAnt
   local lValid                  := .f.
   local codigoGroupCustomer     := hGet( ::hDictionaryMaster, "CodigoGrupo" )

   if empty( codigoGroupCustomer )
      RETURN ( .t. )
   end if

   ::oViewEdit:oCodigoGrupo:Disable()
   ::oViewEdit:oNombreGrupo:cText( "" )
   
   nRec                          := ( D():GrupoClientes( ::nView ) )->( recno() )
   nOrdAnt                       := ( D():GrupoClientes( ::nView ) )->( ordsetfocus( "cCodGrp" ) )

   if ( D():GrupoClientes( ::nView ) )->( dbSeek( codigoGroupCustomer ) )

      ::oViewEdit:oCodigoGrupo:cText( ( D():GrupoClientes( ::nView ) )->cCodGrp )
      ::oViewEdit:oNombreGrupo:cText( ( D():GrupoClientes( ::nView ) )->cNomGrp )

      lValid                     := .t.

   else

      apoloMsgStop( "Grupo de cliente no encontrado" )
      
   end if

   ( D():GrupoClientes( ::nView ) )->( ordsetfocus( nOrdAnt ) )
   ( D():GrupoClientes( ::nView ) )->( dbgoto( nRec ) )

   ::oViewEdit:oCodigoGrupo:Enable()

RETURN ( lValid )

//---------------------------------------------------------------------------//