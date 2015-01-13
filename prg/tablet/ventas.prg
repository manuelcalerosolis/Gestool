#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS Ventas FROM DocumentoSerializable
   
   DATA oViewEdit

   METHOD OpenFiles()
   METHOD CloseFiles()

   METHOD getDataBrowse( Name )     INLINE ( hGet( ::hDictionaryDetail[ ::oViewEdit:oBrowse:nArrayAt ], Name ) )

   METHOD isChangeSerieTablet( lReadyToSend, getSerie )
   
   METHOD ChangeSerieTablet( getSerie )

   METHOD lValidCliente()

   METHOD lValidDireccion()

   METHOD ChangeRuta()

   METHOD NextClient()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS Ventas
   
   local oError
   local oBlock
   local lOpenFiles     := .t.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   ::nView              := D():CreateView()

   D():PedidosClientes( ::nView )

   D():PedidosClientesLineas( ::nView )

   D():AlbaranesClientes( ::nView )

   D():AlbaranesClientesLineas( ::nView )

   D():TiposIva( ::nView )

   D():Divisas( ::nView )

   D():Clientes( ::nView )

   D():ClientesDirecciones( ::nView )

   RECOVER USING oError

      lOpenFiles        := .f.

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpenFiles
      ::CloseFiles()
   end if

Return ( lOpenFiles )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS Ventas

   D():DeleteView( ::nView )

Return ( self )

//---------------------------------------------------------------------------//

METHOD isChangeSerieTablet( getSerie ) CLASS Ventas
   
   if hGet( ::hDictionaryMaster, "Envio" )
      ::ChangeSerieTablet( getSerie )
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD ChangeSerieTablet( getSerie ) CLASS Ventas

   local cSerie   := getSerie:VarGet()

   do case
      case cSerie == "A"
         getSerie:cText( "B" )

      case cSerie == "B"
         getSerie:cText( "A" )

      otherwise
         getSerie:cText( "A" )

   end case

Return ( self )

//---------------------------------------------------------------------------//

METHOD lValidCliente( oGet, oGet2, nMode ) CLASS Ventas

   local lValid      := .t.
   local cNewCodCli  := hGet( ::hDictionaryMaster, "Cliente" )

   if Empty( cNewCodCli )
      Return .t.
   else
      cNewCodCli     := Rjust( cNewCodCli, "0", RetNumCodCliEmp() )
   end if

   if ( D():Clientes( ::nView ) )->( dbSeek( cNewCodCli ) )

      hSet( ::hDictionaryMaster, "Cliente", cNewCodCli )
      hSet( ::hDictionaryMaster, "NombreCliente", ( D():Clientes( ::nView ) )->Titulo )
      hSet( ::hDictionaryMaster, "DomicilioCliente", ( D():Clientes( ::nView ) )->Domicilio )
      hSet( ::hDictionaryMaster, "PoblacionCliente", ( D():Clientes( ::nView ) )->Poblacion )
      hSet( ::hDictionaryMaster, "ProvinciaCliente", ( D():Clientes( ::nView ) )->Provincia )
      hSet( ::hDictionaryMaster, "CodigoPostalCliente", ( D():Clientes( ::nView ) )->CodPostal )
      hSet( ::hDictionaryMaster, "TelefonoCliente", ( D():Clientes( ::nView ) )->Telefono )
      hSet( ::hDictionaryMaster, "DniCliente", ( D():Clientes( ::nView ) )->Nif )
      hSet( ::hDictionaryMaster, "GrupoCliente", ( D():Clientes( ::nView ) )->Nif )
      hSet( ::hDictionaryMaster, "ModificarDatOperarPuntoVerdeGrupoCliente", ( D():Clientes( ::nView ) )->lPntVer )

      if nMode == APPD_MODE

         hSet( ::hDictionaryMaster, "TipoImpuesto", ( D():Clientes( ::nView ) )->nRegIva )
         hSet( ::hDictionaryMaster, "Serie", ( D():Clientes( ::nView ) )->Serie )
         hSet( ::hDictionaryMaster, "Almacen", ( D():Clientes( ::nView ) )->cCodAlm )
         hSet( ::hDictionaryMaster, "Tarifa", ( D():Clientes( ::nView ) )->cCodTar )
         hSet( ::hDictionaryMaster, "Pago", ( D():Clientes( ::nView ) )->CodPago )
         hSet( ::hDictionaryMaster, "Agente", ( D():Clientes( ::nView ) )->cAgente )
         hSet( ::hDictionaryMaster, "Ruta", ( D():Clientes( ::nView ) )->cCodRut )
         hSet( ::hDictionaryMaster, "TarifaAplicar", ( D():Clientes( ::nView ) )->nTarifa )
         hSet( ::hDictionaryMaster, "DescuentoTarifa", ( D():Clientes( ::nView ) )->nDtoArt )
         hSet( ::hDictionaryMaster, "Transportista", ( D():Clientes( ::nView ) )->cCodTrn )
         hSet( ::hDictionaryMaster, "DescripcionDescuento1", ( D():Clientes( ::nView ) )->cDtoEsp )
         hSet( ::hDictionaryMaster, "PorcentajeDescuento1", ( D():Clientes( ::nView ) )->nDtoEsp )
         hSet( ::hDictionaryMaster, "DescripcionDescuento2", ( D():Clientes( ::nView ) )->cDpp )
         hSet( ::hDictionaryMaster, "PorcentajeDescuento2", ( D():Clientes( ::nView ) )->nDpp )
         hSet( ::hDictionaryMaster, "DescripcionDescuento3", ( D():Clientes( ::nView ) )->cDtoUno )
         hSet( ::hDictionaryMaster, "PorcentajeDescuento3", ( D():Clientes( ::nView ) )->nDtoCnt )
         hSet( ::hDictionaryMaster, "DescripcionDescuento4", ( D():Clientes( ::nView ) )->cDtoDos )
         hSet( ::hDictionaryMaster, "PorcentajeDescuento4", ( D():Clientes( ::nView ) )->nDtoRap )
         hSet( ::hDictionaryMaster, "DescuentoAtipico", ( D():Clientes( ::nView ) )->nDtoAtp )
         hSet( ::hDictionaryMaster, "LugarAplicarDescuentoAtipico", ( D():Clientes( ::nView ) )->nSbrAtp )

      end if

      if !Empty( oGet )
         oGet:Refresh()
      end if

      if !Empty( oGet2 )
         oGet2:Refresh()
      end if

      lValid      := .t.

   else

      msgStop( "Cliente no encontrado" )
      lValid := .f.

   end if

RETURN lValid

//---------------------------------------------------------------------------//

METHOD lValidDireccion( oGet, oGet2, cCodCli ) CLASS Ventas

   local lValid   := .f.
   local xValor   := oGet:VarGet()
   local nOrdAnt

   if Empty( xValor )
      if !Empty( oGet2 )
         oGet2:cText( "" )
      end if
      return .t.
   end if

   if Empty( cCodCli )
      MsgStop( "Es necesario codificar un cliente" )
      return .t.
   end if

   nOrdAnt        := ( D():ClientesDirecciones( ::nView ) )->( OrdSetFocus( "cCodCli" ) )

   xValor         := Padr( cCodCli, 12 ) + xValor

   if ( D():ClientesDirecciones( ::nView ) )->( dbSeek( xValor ) )

      oGet:cText( ( D():ClientesDirecciones( ::nView ) )->cCodObr )

      if !Empty( oGet2 )
         oGet2:cText( ( D():ClientesDirecciones( ::nView ) )->cNomObr )
      end if

      lValid      := .t.

   else

      msgStop( "Dirección no encontrada" )
      
      if !Empty( oGet )
         oGet:SetFocus()
      end if

      if !Empty( oGet2 )
         oGet2:cText( Space( 50 ) )
      end if

   end if

   ( D():ClientesDirecciones( ::nView ) )->( OrdSetFocus( nOrdAnt ) )

Return lValid

//---------------------------------------------------------------------------//

METHOD ChangeRuta() CLASS Ventas

   ?"Cambio las rutas"

Return ( self )

//--------------------------------------------------------------------------------

METHOD NextClient() CLASS Ventas

   ?"Cambio los clientes"

Return ( self )

//---------------------------------------------------------------------------//