#include "FiveWin.ch"
#include "Factu.ch"
#include "xbrowse.ch"

//***************************************************************************//
//*************LA TABLA ZONE HAY QUE RENOMBRARLA COMO ZONE1******************//
//***************************************************************************//
//******En el campo extra 001 para cliente con el teléfono adicional*********//
//***************Campo de texto de 50****************************************//
//***************************************************************************//
//******En el campo extra 002 para proveedor con el teléfono adicional*******//
//***************Campo de texto de 50****************************************//
//***************************************************************************//
//**********************Propiedad colores 00001 de tipo color****************//
//***************************************************************************//
//**********************Propiedad tallas 00002*******************************//
//*********La tabla Size hay que cambiarle el nombre por size1***************//
//***************************************************************************//
//***************Poner el len y el prefijo de la subcuenta*******************//
//***************************************************************************//

function Import()

   ImportaMdb():New( "C:\La jaca\TPV.mdb" )
   
return nil

//---------------------------------------------------------------------------//

CLASS ImportaMdb

   DATA cDirMdb

   DATA oCon
   DATA oCat
   DATA oRs

   DATA nView

   DATA nLenSubcuenta            INIT 8
   DATA cPrefijoSubcuenta        INIT "4304"

   DATA aClientes                INIT {}
   DATA aProveedores             INIT {}

   Method New( cDirMdb )   CONSTRUCTOR

   Method ImportacionMdb()

   Method OpenFiles()

   Method CloseFiles()

   Method ConectaMdb()

   Method LimpiaConexionMdb()

   Method formatID( ufield )     INLINE ( AllTrim( Str( Int( ufield ) ) ) )

   Method formatField( ufield )  INLINE ( if( Empty( ufield ), "", AllTrim( ufield ) ) )

   Method ImportaAgentes()

   Method ImportaRutas()

   Method ImportaClientes()

   Method ImportaFormasdePago()

   Method ImportaDirecciones()

   Method ImportaProveedores()

   Method ImportaFamilias()

   Method ImportaArticulos()

   Method ImportaDescripcionArticulos()

   Method ImportaGrupoCliente( cValor )
   
   Method ImportaCamposExtraTelefonoAdicionalCliente( cCodCli, cValor )

   Method ImportaCamposExtraTelefonoAdicionalProveedor( cCodPrv, cValor )

   Method ImportaPaises()

   Method ImportaCamposExtra()

   Method nRegimenIva()

   Method lRecargo( cValor )       INLINE ( At( "Recargo", cValor ) != 0 )

   Method ImportaLenguajes()

   Method ImportaValoresCamposExtra()

   Method ImportaMensajesClientes() 

   Method ImportaBancosClientes() 

   Method ImportaColores()

   Method ImportaTallas()

   Method ImportaPrecioGeneral()

   Method ImportaPropiedadesArticulo()

   Method ImportaTemporada()

END CLASS

//---------------------------------------------------------------------------//

Method New( cDirMdb ) CLASS ImportaMdb

   ::cDirMdb         := cDirMdb

   if !Empty( ::cDirMdb )
      ::ImportacionMdb()
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD ImportacionMdb() CLASS ImportaMdb

   if ::ConectaMdb() .and. ::OpenFiles()

      /*if MsgYesNo( "¿Paises?" )
         ::ImportaPaises() //********************FINALIZADO********************
      end if*/

      /*if MsgYesNo( "¿Lenguajes?" )
         ::ImportaLenguajes() //********************FINALIZADO********************
      end if*/

      /*if MsgYesNo( "¿Agentes?" )
         ::ImportaAgentes() //********************FINALIZADO********************
      end if*/

      /*if MsgYesNo( "¿Rutas?" )
         ::ImportaRutas() //********************FINALIZADO********************
      end if*/

      /*if MsgYesNo( "¿Formas de pago?" )
         ::ImportaFormasdePago() //********************FINALIZADO********************
      end if*/

      if MsgYesNo( "¿Clientes?" )
         ::ImportaClientes() //********************FINALIZADO********************
      end if

      if MsgYesNo( "¿Proveedores y Fabricantes?" )
         ::ImportaProveedores() //********************FINALIZADO********************
      end if

      if MsgYesNo( "¿Direcciones?" )
         ::ImportaDirecciones() //********************FINALIZADO********************
      end if

      /*if MsgYesNo( "¿Familias?" )
         ::ImportaFamilias() //********************FINALIZADO********************
      end if*/

      /*if MsgYesNo( "¿Temporada?" )
         ::ImportaTemporada() //********************FINALIZADO********************
      end if*/

      /*if MsgYesNo( "¿Campos Extra?" )
         ::ImportaCamposExtra() //********************FINALIZADO********************
      end if*/

      /*if MsgYesNo( "¿Valores Campos Extra?" )
         ::ImportaValoresCamposExtra() //********************FINALIZADO********************
      end if*/
      
      if MsgYesNo( "¿Mensajes clientes?" )
         ::ImportaMensajesClientes() //********************FINALIZADO********************
      end if

      if MsgYesNo( "¿Bancos Clientes?" )
         ::ImportaBancosClientes() //********************FINALIZADO********************
      end if

      /*if MsgYesNo( "¿Artículos?" )
         ::ImportaArticulos()
      end if   

      if MsgYesNo( "¿Descripciones?" )
         ::ImportaDescripcionArticulos()
      end if

      if MsgYesNo( "¿Color?" )
         ::ImportaColores()
      end if

      if MsgYesNo( "¿Tallas?" )
         ::ImportaTallas()
      end if

      if MsgYesNo( "Precios generales" )
         ::ImportaPrecioGeneral()
      end if

      if MsgYesNo( "Propiedades artículos" )
         ::ImportaPropiedadesArticulo()
      end if*/

      ::CloseFiles()

      MsgInfo( "Proceso finalizado." )

   end if

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD ConectaMdb()  CLASS ImportaMdb

   local lResult  := .t.
   local oError

   ::oCon         := TOleAuto():New( "ADODB.Connection" )
   ::oCat         := TOleAuto():New( "ADOX.Catalog" )
   ::oRs          := TOleAuto():New( "ADODB.Recordset" )

   try
      ::oCon:Open( "Provider='Microsoft.Jet.OLEDB.4.0'; Data Source='" + ::cDirMdb + "';" )
   catch oError
      lResult     := .f.
      MsgInfo( oError:Description )
   end 

   ::oCat:ActiveConnection = ::oCon
   ::oRs = ::oCon:OpenSchema( 20 )

   ::LimpiaConexionMdb()

Return ( lResult )

//---------------------------------------------------------------------------//

METHOD LimpiaConexionMdb() CLASS ImportaMdb

   ::oRs:Close()
   ::oRs:CursorType     = 1        // opendkeyset
   ::oRs:CursorLocation = 3        // local cache
   ::oRs:LockType       = 3        // lockoportunistic

Return ( .t. )

//---------------------------------------------------------------------------//

Method OpenFiles() CLASS ImportaMdb

   local oError
   local oBlock
   local lOpenFiles     := .t.

   oBlock               := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   ::nView              := D():CreateView()

   D():Clientes( ::nView )

   D():Agentes( ::nView )

   D():Ruta( ::nView )

   D():FormasPago( ::nView )

   D():ClientesDirecciones( ::nView )

   D():Proveedores( ::nView )

   D():Articulos( ::nView )

   D():ArticulosCodigosBarras( ::nView )

   D():CamposExtras( ::nView )

   D():DetCamposExtras( ::nView )

   D():Pais( ::nView )

   D():GrupoClientes( ::nView )

   D():Lenguajes( ::nView )

   D():ArticuloLenguaje( ::nView )

   D():ClientesIncidencias( ::nView )

   D():ClientesBancos( ::nView )

   D():PropiedadesLineas( ::nView )

   D():Temporadas( ::nView )

   D():ArticuloPrecioPropiedades( ::nView )

   D():Fabricantes( ::nView )

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

Method CloseFiles() CLASS ImportaMdb

   D():DeleteView( ::nView )

Return( .t. )

//---------------------------------------------------------------------------//

Method nRegimenIva( cValor ) CLASS ImportaMdb

   do case 
      case at( "IVA", cValor ) != 0
         Return 1

      case at( "IntraComunitario", cValor ) != 0
         Return 2

      case at( "Excento", cValor ) != 0
         Return 3

      oTherwise
         Return 4

   end if

Return ( 0 )

//---------------------------------------------------------------------------//

METHOD ImportaPaises() CLASS ImportaMdb

   MsgWait( "Importación de paises.", "Atención", 1 )

   ::oRs:Open( "SELECT * FROM countryCodes", ::oCon )

   while !::oRs:Eof()

      ( D():Pais( ::nView ) )->( dbAppend() )

      ( D():Pais( ::nView ) )->cCodPai    := AllTrim( ::formatField( ::oRs:Fields( "CountryId" ):Value ) )
      ( D():Pais( ::nView ) )->cNomPai    := AllTrim( ::formatField( ::oRs:Fields( "CountryName" ):Value ) )
      ( D():Pais( ::nView ) )->cCodIso    := AllTrim( ::formatField( ::oRs:Fields( "ISOCountryId" ):Value ) )

      ( D():Pais( ::nView ) )->( dbUnlock() )

      MsgWait( "Pais: " + ::oRs:Fields( "CountryName" ):Value, "Atención", 0.05 )

      ::oRs:MoveNext()

   end while

   ::LimpiaConexionMdb()

Return( .t. )

//---------------------------------------------------------------------------//

Method ImportaAgentes() CLASS ImportaMdb

   local cConsulta      := ""

   MsgWait( "Importación de agentes.", "Atención", 1 )

   cConsulta            += "SELECT * FROM (Salesman "
   cConsulta            += "LEFT JOIN ProvinceCodes ON (Salesman.ProvinceID = ProvinceCodes.ProvinceID) AND (Salesman.CountryID = ProvinceCodes.CountryID)) "
   cConsulta            += "LEFT JOIN LocalityCodes ON (Salesman.LocalityID = LocalityCodes.LocalityID) AND (Salesman.CountryID = LocalityCodes.CountryID) AND (Salesman.ProvinceID = LocalityCodes.ProvinceID)"

   ::oRs:Open( cConsulta, ::oCon )

   while !::oRs:Eof()

      ( D():Agentes( ::nView ) )->( dbAppend() )

      ( D():Agentes( ::nView ) )->cCodAge    := Rjust( ::formatID( ::oRs:Fields( "SalesManId" ):Value ), "0", 3 )
      ( D():Agentes( ::nView ) )->cNbrAge    := ::formatField( ::oRs:Fields( "SalesManName" ):Value )
      ( D():Agentes( ::nView ) )->cDirAge    := ::formatField( ::oRs:Fields( "AddressLine1" ):Value )
      ( D():Agentes( ::nView ) )->cPtlAge    := ::formatField( ::oRs:Fields( "Salesman.PostalCode" ):Value )
      ( D():Agentes( ::nView ) )->cProv      := ::formatField( ::oRs:Fields( "ProvinceName" ):Value )
      ( D():Agentes( ::nView ) )->cPobAge    := ::formatField( ::oRs:Fields( "LocalityName" ):Value )
      ( D():Agentes( ::nView ) )->cTfoAge    := ::formatField( ::oRs:Fields( "Telephone1" ):Value )
      ( D():Agentes( ::nView ) )->cMovAge    := ::formatField( ::oRs:Fields( "MobilPhone1" ):Value )
      ( D():Agentes( ::nView ) )->cFaxAge    := ::formatField( ::oRs:Fields( "MobilPhone2" ):Value )
      ( D():Agentes( ::nView ) )->cDniNif    := ::formatField( ::oRs:Fields( "FederalTaxId" ):Value )
      ( D():Agentes( ::nView ) )->cMailAge   := ::formatField( ::oRs:Fields( "EmailAddress" ):Value )

      ( D():Agentes( ::nView ) )->( dbUnlock() )

      MsgWait( "Agente: " + ::oRs:Fields( "SalesManName" ):Value, "Atención", 0.05 )

      ::oRs:MoveNext()

   end while

   ::LimpiaConexionMdb()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD ImportaRutas() CLASS ImportaMdb

   MsgWait( "Importación de rutas.", "Atención", 1 )

   ::oRs:Open( "SELECT * FROM Zone1", ::oCon )

   while !::oRs:Eof()

      ( D():Ruta( ::nView ) )->( dbAppend() )

      ( D():Ruta( ::nView ) )->cCodRut    := ::formatID( ::oRs:Fields( "ZoneId" ):Value )
      ( D():Ruta( ::nView ) )->cDesRut    := ::formatField( ::oRs:Fields( "Description" ):Value )

      ( D():Ruta( ::nView ) )->( dbUnlock() )

      MsgWait( "Ruta: " + ::oRs:Fields( "Description" ):Value, "Atención", 0.05 )

      ::oRs:MoveNext()

   end while

   ::LimpiaConexionMdb()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD ImportaFormasdePago() CLASS ImportaMdb

   local nPlazos     := 0
   local nDiasPlazo  := 0

   MsgWait( "Importación de formas de pago.", "Atención", 1 )

   ::oRs:Open( "SELECT * FROM Payment", ::oCon )

   while !::oRs:Eof()

      ( D():FormasPago( ::nView ) )->( dbAppend() )

      ( D():FormasPago( ::nView ) )->cCodPago    := ::formatID( ::oRs:Fields( "PaymentId" ):Value )
      ( D():FormasPago( ::nView ) )->cDesPago    := ::formatField( ::oRs:Fields( "Description" ):Value )
      ( D():FormasPago( ::nView ) )->nTipPgo     := 1
      ( D():FormasPago( ::nView ) )->nCobRec     := 2
      nPlazos                                    := if( Empty( ::oRs:Fields( "Installments" ):Value ), 1, ::oRs:Fields( "Installments" ):Value )  
      ( D():FormasPago( ::nView ) )->nPlazos     := nPlazos
      nDiasPlazo                                 := if( Empty( ::oRs:Fields( "PaymentDays" ):Value ), 0, ::oRs:Fields( "PaymentDays" ):Value )  
      ( D():FormasPago( ::nView ) )->nPlaUno     := nDiasPlazo
      ( D():FormasPago( ::nView ) )->nDiaPla     := if( nPlazos > 1, nDiasPlazo, 0 )

      ( D():FormasPago( ::nView ) )->( dbUnlock() )

      MsgWait( "Forma de pago: " + ::oRs:Fields( "Description" ):Value, "Atención", 0.05 )

      ::oRs:MoveNext()

   end while

   ::LimpiaConexionMdb()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD ImportaClientes() CLASS ImportaMdb

   local cCodCli
   local cTelefonoAdicional
   local cConsulta         := ""
   local nRiesgo

   MsgWait( "Importación de clientes.", "Atención", 1 )

   cConsulta               += "SELECT * FROM (customer "
   cConsulta               += "LEFT JOIN EntityFiscalStatus ON (customer.EntityFiscalStatusID = EntityFiscalStatus.EntityFiscalStatusID)) "

   ::oRs:Open( cConsulta, ::oCon )

   while !::oRs:Eof()

      cCodCli                                   := Rjust( ::formatID( ::oRs:Fields( "CustomerId" ):Value ), "0", RetNumCodCliEmp() )
      cTelefonoAdicional                        := AllTrim( ::formatField( ::oRs:Fields( "Telephone3" ):Value ) )
      nRiesgo                                   := if( ValType( ::oRs:Fields( "LimitPurChaseValue" ):Value ) == "N", ::oRs:Fields( "LimitPurChaseValue" ):Value, 0 )

      if !( D():Clientes( ::nView ) )->( dbSeek( cCodCli ) )

         ( D():Clientes( ::nView ) )->( dbAppend() )

         ( D():Clientes( ::nView ) )->Cod          := cCodCli
         ( D():Clientes( ::nView ) )->Titulo       := ::formatField( ::oRs:Fields( "OrganizationName" ):Value )
         ( D():Clientes( ::nView ) )->Nif          := ::formatField( ::oRs:Fields( "FederalTaxID" ):Value )
         ( D():Clientes( ::nView ) )->cAgente      := Rjust( ::formatID( ::oRs:Fields( "SalesManId" ):Value ), "0", 3 )
         ( D():Clientes( ::nView ) )->cCodRut      := ::formatID( ::oRs:Fields( "ZoneId" ):Value )
         ( D():Clientes( ::nView ) )->CodPago      := ::formatID( ::oRs:Fields( "PaymentId" ):Value )
         ( D():Clientes( ::nView ) )->cMeiInt      := ::formatField( ::oRs:Fields( "EmailAddress" ):Value )
         ( D():Clientes( ::nView ) )->cWebInt      := ::formatField( ::oRs:Fields( "WebAddress" ):Value )
         ( D():Clientes( ::nView ) )->Telefono     := ::formatField( ::oRs:Fields( "Telephone1" ):Value )
         ( D():Clientes( ::nView ) )->Telefono2    := ::formatField( ::oRs:Fields( "Telephone2" ):Value )
         ( D():Clientes( ::nView ) )->Fax          := ::formatField( ::oRs:Fields( "Fax" ):Value )
         ( D():Clientes( ::nView ) )->Movil        := ::formatField( ::oRs:Fields( "MobileTelephone1" ):Value )
         ( D():Clientes( ::nView ) )->Movil2       := ::formatField( ::oRs:Fields( "MobileTelephone2" ):Value )
         ( D():Clientes( ::nView ) )->nTarifa      := 1
         ( D():Clientes( ::nView ) )->nTarCmb      := 1
         ( D():Clientes( ::nView ) )->nLabel       := 1
         ( D():Clientes( ::nView ) )->Serie        := "A"
         ( D():Clientes( ::nView ) )->lChgPre      := .t.
         ( D():Clientes( ::nView ) )->mObserv      := ::formatField( ::oRs:Fields( "Comments" ):Value )
         ( D():Clientes( ::nView ) )->CopiasF      := if( Empty( ::oRs:Fields( "CustomerPrintCopies" ):Value ), 0, ::oRs:Fields( "CustomerPrintCopies" ):Value )
         ( D():Clientes( ::nView ) )->cDtoEsp      := Padr( "General", 50 )
         ( D():Clientes( ::nView ) )->cDpp         := Padr( "Pronto pago", 50 )
         ( D():Clientes( ::nView ) )->cDtoAtp      := Padr( "Atipico", 50 )
         ( D():Clientes( ::nView ) )->cCodAlm      := "000"
         ( D():Clientes( ::nView ) )->Riesgo       := nRiesgo
         ( D():Clientes( ::nView ) )->nRegIva      := ::nRegimenIva( ::formatField( ::oRs:Fields( "Description" ):Value ) )
         ( D():Clientes( ::nView ) )->lReq         := ::lRecargo( ::formatField( ::oRs:Fields( "Description" ):Value ) )
         ( D():Clientes( ::nView ) )->cCodGrp      := ::ImportaGrupoCliente( AllTrim( ::formatField( ::oRs:Fields( "Telephone4" ):Value ) ) )
         ( D():Clientes( ::nView ) )->lCreSol      := ( nRiesgo > 0 )
         ( D():Clientes( ::nView ) )->Subcta       := ::cPrefijoSubcuenta + strzero( val( alltrim( cCodCli ) ), ( ::nLenSubcuenta - Len( ::cPrefijoSubcuenta ) ) )

         ::ImportaCamposExtraTelefonoAdicionalCliente( cCodCli, cTelefonoAdicional )

         ( D():Clientes( ::nView ) )->( dbUnlock() )

         aAdd( ::aClientes, cCodCli )

      end if

      MsgWait( "Cliente: " + ::oRs:Fields( "OrganizationName" ):Value, "Atención", 0.05 )

      ::oRs:MoveNext()

   end while

   ::LimpiaConexionMdb()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD ImportaProveedores() CLASS ImportaMdb

   Local cCodPrv
   local cValTelefonoAdicional 

   MsgWait( "Importación de proveedores.", "Atención", 1 )

   ::oRs:Open( "SELECT * FROM supplier", ::oCon )

   while !::oRs:Eof()

   cCodPrv                                         := Rjust( ::formatID( ::oRs:Fields( "SupplierId" ):Value ), "0", RetNumCodPrvEmp() )
   cValTelefonoAdicional                           := AllTrim( ::formatField( ::oRs:Fields( "Telephone3" ):Value ) )

      if !( D():Proveedores( ::nView ) )->( dbSeek( cCodPrv ) )

         ( D():Proveedores( ::nView ) )->( dbAppend() )

         ( D():Proveedores( ::nView ) )->Cod          := cCodPrv
         ( D():Proveedores( ::nView ) )->Titulo       := ::formatField( ::oRs:Fields( "OrganizationName" ):Value )
         ( D():Proveedores( ::nView ) )->Nif          := ::formatField( ::oRs:Fields( "FederalTaxID" ):Value )
         ( D():Proveedores( ::nView ) )->cMeiInt      := ::formatField( ::oRs:Fields( "EmailAddress" ):Value )
         ( D():Proveedores( ::nView ) )->cWebInt      := ::formatField( ::oRs:Fields( "WebAddress" ):Value )
         ( D():Proveedores( ::nView ) )->Telefono     := ::formatField( ::oRs:Fields( "Telephone1" ):Value )
         ( D():Proveedores( ::nView ) )->Telefono2    := ::formatField( ::oRs:Fields( "Telephone2" ):Value )
         ( D():Proveedores( ::nView ) )->Fax          := ::formatField( ::oRs:Fields( "Fax" ):Value )
         ( D():Proveedores( ::nView ) )->Movil        := ::formatField( ::oRs:Fields( "MobileTelephone1" ):Value )
         ( D():Proveedores( ::nView ) )->Movil2       := ::formatField( ::oRs:Fields( "MobileTelephone2" ):Value )
         ( D():Proveedores( ::nView ) )->FPago        := ::formatID( ::oRs:Fields( "PaymentId" ):Value )
         ( D():Proveedores( ::nView ) )->mComent      := ::formatField( ::oRs:Fields( "Comments" ):Value )
         ( D():Proveedores( ::nView ) )->cDtoEsp      := Padr( "General", 50 )
         ( D():Proveedores( ::nView ) )->cDtoPP       := Padr( "Pronto pago", 50 )

         ::ImportaCamposExtraTelefonoAdicionalProveedor( cCodPrv, cValTelefonoAdicional )

         ( D():Proveedores( ::nView ) )->( dbUnlock() )

         ( D():Fabricantes( ::nView ) )->( dbAppend() )      

         ( D():Fabricantes( ::nView ) )->cCodFab      := ::formatID( ::oRs:Fields( "SupplierId" ):Value )
         ( D():Fabricantes( ::nView ) )->cNomFab      := ::formatField( ::oRs:Fields( "OrganizationName" ):Value )

         ( D():Fabricantes( ::nView ) )->( dbUnlock() )

         aAdd( ::aProveedores, cCodPrv )

      end if

      MsgWait( "Proveedor: " + ::oRs:Fields( "OrganizationName" ):Value, "Atención", 0.05 )

      ::oRs:MoveNext()

   end while

   ::LimpiaConexionMdb()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD ImportaDirecciones() CLASS ImportaMdb
   
   local cConsulta         := ""
   local idDireccion
   local cCodigoCliente
   local cCodigoProveedor
   local nOrdAnt

   MsgWait( "Importación de direcciones.", "Atención", 1 )

   cConsulta               += "SELECT * FROM (PartyAddress "
   cConsulta               += "LEFT JOIN ProvinceCodes ON (PartyAddress.ProvinceID = ProvinceCodes.ProvinceID) AND (PartyAddress.CountryID = ProvinceCodes.CountryID)) "
   cConsulta               += "LEFT JOIN LocalityCodes ON (PartyAddress.LocalityID = LocalityCodes.LocalityID) AND (PartyAddress.CountryID = LocalityCodes.CountryID) AND (PartyAddress.ProvinceID = LocalityCodes.ProvinceID)"

   ::oRs:Open( cConsulta, ::oCon )

   while !::oRs:Eof()

      idDireccion          := ::oRs:Fields( "AddressId" ):Value

      if ::oRs:Fields( "PartyId" ):Value > 10000000000

         cCodigoProveedor  := Rjust( ::formatID( ::oRs:Fields( "PartyId" ):Value - 10000000000 ), "0", RetNumCodPrvEmp() )

         if Empty( idDireccion )

            nOrdAnt        := ( D():Proveedores( ::nView ) )->( OrdSetFocus( "Cod" ) )

            if aScan( ::aProveedores, cCodigoProveedor ) != 0

               if ( D():Proveedores( ::nView ) )->( dbSeek( cCodigoProveedor ) )

                  if ( D():Proveedores( ::nView ) )->( dbRLock() )
                     ( D():Proveedores( ::nView ) )->Domicilio       := ::formatField( ::oRs:Fields( "AddressLine1" ):Value )
                     ( D():Proveedores( ::nView ) )->cNbrEst         := ::formatField( ::oRs:Fields( "AddressLine2" ):Value )
                     ( D():Proveedores( ::nView ) )->Poblacion       := if( !Empty( ::formatField( ::oRs:Fields( "LocalityName" ):Value ) ), ::formatField( ::oRs:Fields( "LocalityName" ):Value ), SubStr( ::formatField( ::oRs:Fields( "PartyAddress.PostalCode" ):Value ), 7 ) )
                     ( D():Proveedores( ::nView ) )->Provincia       := ::formatField( ::oRs:Fields( "ProvinceName" ):Value )
                     ( D():Proveedores( ::nView ) )->CodPostal       := SubStr( ::formatField( ::oRs:Fields( "PartyAddress.PostalCode" ):Value ), 1, 5 )
                     ( D():Proveedores( ::nView ) )->( dbUnLock() )
                  end if

               end if

            end if

            ( D():Proveedores( ::nView ) )->( OrdSetFocus( nOrdAnt ) )

         end if         

      else
         
         cCodigoCliente    := Rjust( ::formatID( ::oRs:Fields( "PartyId" ):Value ), "0", RetNumCodCliEmp() )

         if Empty( idDireccion )

            nOrdAnt        := ( D():Clientes( ::nView ) )->( OrdSetFocus( "Cod" ) )

            if aScan( ::aClientes, cCodigoCliente ) != 0

               if ( D():Clientes( ::nView ) )->( dbSeek( cCodigoCliente ) )

                  if ( D():Clientes( ::nView ) )->( dbRLock() )
                     ( D():Clientes( ::nView ) )->Domicilio       := ::formatField( ::oRs:Fields( "AddressLine1" ):Value )
                     ( D():Clientes( ::nView ) )->NbrEst          := ::formatField( ::oRs:Fields( "AddressLine2" ):Value )
                     ( D():Clientes( ::nView ) )->Poblacion       := if( !Empty( ::formatField( ::oRs:Fields( "LocalityName" ):Value ) ), ::formatField( ::oRs:Fields( "LocalityName" ):Value ), SubStr( ::formatField( ::oRs:Fields( "PartyAddress.PostalCode" ):Value ), 7 ) )
                     ( D():Clientes( ::nView ) )->Provincia       := ::formatField( ::oRs:Fields( "ProvinceName" ):Value )
                     ( D():Clientes( ::nView ) )->CodPostal       := SubStr( ::formatField( ::oRs:Fields( "PartyAddress.PostalCode" ):Value ), 1, 5 )
                     ( D():Clientes( ::nView ) )->cCodPai         := ::formatField( ::oRs:Fields( "PartyAddress.CountryId" ):Value )

                     ( D():Clientes( ::nView ) )->( dbUnLock() )
                  end if

               end if

            end if

            ( D():Clientes( ::nView ) )->( OrdSetFocus( nOrdAnt ) )

         else

            if aScan( ::aClientes, cCodigoCliente ) != 0

               ( D():ClientesDirecciones( ::nView ) )->( dbAppend() )
               
               ( D():ClientesDirecciones( ::nView ) )->cCodCli    := cCodigoCliente
               ( D():ClientesDirecciones( ::nView ) )->cCodObr    := ::formatID( ::oRs:Fields( "PartyId" ):Value )
               ( D():ClientesDirecciones( ::nView ) )->cNomObr    := ::formatField( ::oRs:Fields( "AddressLine2" ):Value )
               ( D():ClientesDirecciones( ::nView ) )->cDirObr    := ::formatField( ::oRs:Fields( "AddressLine1" ):Value )
               ( D():ClientesDirecciones( ::nView ) )->cPrvObr    := ::formatField( ::oRs:Fields( "ProvinceName" ):Value )
               ( D():ClientesDirecciones( ::nView ) )->cPobObr    := if( !Empty( ::formatField( ::oRs:Fields( "LocalityName" ):Value ) ), ::formatField( ::oRs:Fields( "LocalityName" ):Value ), SubStr( ::formatField( ::oRs:Fields( "PartyAddress.PostalCode" ):Value ), 7 ) )
               ( D():ClientesDirecciones( ::nView ) )->cPosObr    := SubStr( ::formatField( ::oRs:Fields( "PartyAddress.PostalCode" ):Value ), 1, 5 )
               ( D():ClientesDirecciones( ::nView ) )->cCntObr    := ::formatField( ::oRs:Fields( "AddressLine2" ):Value )

               ( D():ClientesDirecciones( ::nView ) )->( dbUnlock() )

            end if

         end if 

      end if

      MsgWait( "Dirección: " + ::oRs:Fields( "AddressLine1" ):Value, "Atención", 0.05 )

      ::oRs:MoveNext()

   end while

   ::LimpiaConexionMdb()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD ImportaFamilias() CLASS ImportaMdb

   MsgWait( "Importación de familias.", "Atención", 1 )

   ::oRs:Open( "SELECT * FROM family", ::oCon )

   while !::oRs:Eof()

      ( D():Familias( ::nView ) )->( dbAppend() )

      ( D():Familias( ::nView ) )->cCodFam        := ::formatID( ::oRs:Fields( "FamilyId" ):Value )
      ( D():Familias( ::nView ) )->cNomFam        := ::formatField( ::oRs:Fields( "Description" ):Value ) 
      ( D():Familias( ::nView ) )->cFamCmb        := if( !Empty( ::oRs:Fields( "ParentId" ):Value ), ::formatID( ::oRs:Fields( "ParentId" ):Value ), "" )

      ( D():Familias( ::nView ) )->( dbUnlock() )

      MsgWait( "Familia: " + ::oRs:Fields( "Description" ):Value, "Atención", 0.05 )

      ::oRs:MoveNext()

   end while

   ::LimpiaConexionMdb()

Return ( .t. )

//---------------------------------------------------------------------------//

Method ImportaGrupoCliente( cValor ) CLASS ImportaMdb

   local cResultado  := ""
   local nOrdAnt

   if Empty( cValor )
      return cResultado
   end if

   nOrdAnt     := ( D():GrupoClientes( ::nView ) )->( OrdSetFocus( "cNomGrp" ) )   

   if ( D():GrupoClientes( ::nView ) )->( dbSeek( cValor ) )
   
      cResultado     := ( D():GrupoClientes( ::nView ) )->cCodGrp

   else

      cResultado     := Rjust( NextKey( dbLast( D():GrupoClientes( ::nView ), 1 ), D():GrupoClientes( ::nView ) ), "0", 4 )

      ( D():GrupoClientes( ::nView ) )->( dbAppend() )

      ( D():GrupoClientes( ::nView ) )->cCodGrp   := cResultado
      ( D():GrupoClientes( ::nView ) )->cNomGrp   := cValor

      ( D():GrupoClientes( ::nView ) )->( dbUnlock() )

   end if

   ( D():GrupoClientes( ::nView ) )->( OrdSetFocus( nOrdAnt ) )

Return ( cResultado )

//---------------------------------------------------------------------------//

Method ImportaCamposExtraTelefonoAdicionalCliente( cCodCli, cValor ) CLASS ImportaMdb

   if !Empty( cValor )

      ( D():DetCamposExtras( ::nView ) )->( dbAppend() )

      ( D():DetCamposExtras( ::nView ) )->cTipDoc     := CLI_TBL
      ( D():DetCamposExtras( ::nView ) )->cCodTipo    := "001"
      ( D():DetCamposExtras( ::nView ) )->cClave      := cCodCli
      ( D():DetCamposExtras( ::nView ) )->cValor      := cValor

      ( D():DetCamposExtras( ::nView ) )->( dbUnLock() )

   end if

Return ( .t. )

//---------------------------------------------------------------------------//

Method ImportaCamposExtraTelefonoAdicionalProveedor( cCodPrv, cValor ) CLASS ImportaMdb
   
   if !Empty( cValor )

      ( D():DetCamposExtras( ::nView ) )->( dbAppend() )

      ( D():DetCamposExtras( ::nView ) )->cTipDoc     := PRV_TBL
      ( D():DetCamposExtras( ::nView ) )->cCodTipo    := "002"
      ( D():DetCamposExtras( ::nView ) )->cClave      := cCodPrv
      ( D():DetCamposExtras( ::nView ) )->cValor      := cValor

      ( D():DetCamposExtras( ::nView ) )->( dbUnLock() )

   end if

Return ( .t. )

//---------------------------------------------------------------------------//

Method ImportaTemporada() CLASS ImportaMdb

   MsgWait( "Importación de temporadas.", "Atención", 1 )

   ::oRs:Open( "SELECT * FROM ItemSecondGroup", ::oCon )

   while !::oRs:Eof()

      ( D():Temporadas( ::nView ) )->( dbAppend() )

      ( D():Temporadas( ::nView ) )->cCodigo        := ::formatID( ::oRs:Fields( "ItemSecondGroupId" ):Value )
      ( D():Temporadas( ::nView ) )->cNombre        := ::formatField( ::oRs:Fields( "Description" ):Value )
      ( D():Temporadas( ::nView ) )->cTipo          := "Sol"

      ( D():Temporadas( ::nView ) )->( dbUnlock() )

      MsgWait( "Temporadas: " + ::formatField( ::oRs:Fields( "Description" ):Value ), "Atención", 0.05 )

      ::oRs:MoveNext()

   end while

   ::LimpiaConexionMdb()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD ImportaArticulos() CLASS ImportaMdb

   local cCodArt
   local cFamilia
   local cTemporada
   local cFabricante

   MsgWait( "Importación de artículos.", "Atención", 1 )

   ::oRs:Open( "SELECT * FROM Item", ::oCon )

   while !::oRs:Eof()

      cCodArt        := if( ValType( ::oRs:Fields( "ItemId" ):Value ) == "N", ::formatID( ::oRs:Fields( "ItemId" ):Value ), ::formatField( ::oRs:Fields( "ItemId" ):Value ) )
      cFamilia       := if( ValType( ::oRs:Fields( "FamilyId" ):Value ) == "N", ::formatID( ::oRs:Fields( "FamilyId" ):Value ), ::formatField( ::oRs:Fields( "FamilyId" ):Value ) )
      cTemporada     := if( ValType( ::oRs:Fields( "ItemSecondGroupId" ):Value ) == "N", ::formatID( ::oRs:Fields( "ItemSecondGroupId" ):Value ), ::formatField( ::oRs:Fields( "ItemSecondGroupId" ):Value ) )
      cFabricante    := if( ValType( ::oRs:Fields( "SupplierId" ):Value ) == "N", ::formatID( ::oRs:Fields( "SupplierId" ):Value ), ::formatField( ::oRs:Fields( "SupplierId" ):Value ) )

      ( D():Articulos( ::nView ) )->( dbAppend() )

      ( D():Articulos( ::nView ) )->Codigo      := cCodArt
      ( D():Articulos( ::nView ) )->TipoIva     := "G"
      ( D():Articulos( ::nView ) )->cCodPrp1    := Padr( "00001", 20 )
      ( D():Articulos( ::nView ) )->cCodPrp2    := Padr( "00002", 20 )
      ( D():Articulos( ::nView ) )->Familia     := cFamilia
      ( D():Articulos( ::nView ) )->cCodTemp    := cTemporada
      ( D():Articulos( ::nView ) )->cCodFab     := AllTrim( cFabricante )

      ( D():Articulos( ::nView ) )->( dbUnlock() )

      MsgWait( "Código artículo: " + cCodArt, "Atención", 0.05 )

      ::oRs:MoveNext()

   end while

   ::LimpiaConexionMdb()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD ImportaDescripcionArticulos() CLASS ImportaMdb

   local cCodArt

   MsgWait( "Importación de descripciones de artículos.", "Atención", 1 )

   ::oRs:Open( "SELECT * FROM ItemNames", ::oCon )

   while !::oRs:Eof()

      cCodArt     := if( ValType( ::oRs:Fields( "ItemId" ):Value ) == "N", ::formatID( ::oRs:Fields( "ItemId" ):Value ), ::formatField( ::oRs:Fields( "ItemId" ):Value ) )

      /*
      Rellenamos en la ficha del artículo--------------------------------------
      */

      if ::formatField( ::oRs:Fields( "LanguageId" ):Value ) == "ESN"

         if ( D():Articulos( ::nView ) )->( dbSeek( cCodArt ) ) .and.;
            dbLock( D():Articulos( ::nView ) )

            ( D():Articulos( ::nView ) )->Nombre        := AllTrim( ::formatField( ::oRs:Fields( "ShortDescription" ):Value ) )

            ( D():Articulos( ::nView ) )->( dbUnlock() )

            MsgWait( "Artículo: " + ::formatField( ::oRs:Fields( "ShortDescription" ):Value ), "Atención", 0.05 )

         end if

      end if

      /*
      Pasamos las descripciones por idiomas------------------------------------
      */

      if !Empty( ::formatField( ::oRs:Fields( "ShortDescription" ):Value ) )

         ( D():ArticuloLenguaje( ::nView ) )->( dbAppend() )

         ( D():ArticuloLenguaje( ::nView ) )->cCodArt    := cCodArt
         ( D():ArticuloLenguaje( ::nView ) )->cCodLen    := ::formatField( ::oRs:Fields( "LanguageID" ):Value )
         ( D():ArticuloLenguaje( ::nView ) )->cDesTik    := ::formatField( ::oRs:Fields( "ShortDescription" ):Value )
         ( D():ArticuloLenguaje( ::nView ) )->cDesArt    := ::formatField( ::oRs:Fields( "Description" ):Value )

         ( D():ArticuloLenguaje( ::nView ) )->( dbUnLock() )

      end if

      ::oRs:MoveNext()

   end while

   ::LimpiaConexionMdb()

Return ( .t. )

//---------------------------------------------------------------------------//

Method ImportaLenguajes() CLASS ImportaMdb

   MsgWait( "Importación de lenguajes.", "Atención", 1 )

   ::oRs:Open( "SELECT * FROM LanguageCodes", ::oCon )

   while !::oRs:Eof()

      ( D():Lenguajes( ::nView ) )->( dbAppend() )

      ( D():Lenguajes( ::nView ) )->cCodLen       := AllTrim( ::formatField( ::oRs:Fields( "LanguageId" ):Value ) )
      ( D():Lenguajes( ::nView ) )->cNomLen       := AllTrim( ::formatField( ::oRs:Fields( "LanguageName" ):Value ) )

      ( D():Lenguajes( ::nView ) )->( dbUnlock() )

      MsgWait( "Lenguaje: " + ::formatField( ::oRs:Fields( "LanguageName" ):Value ), "Atención", 0.05 )

      ::oRs:MoveNext()

   end while

   ::LimpiaConexionMdb()

Return ( .t. )

//---------------------------------------------------------------------------//

Method ImportaCamposExtra() CLASS ImportaMdb

   local aDocumentos    := { "Clientes" => .t. }

   MsgWait( "Importación de campos extra.", "Atención", 1 )

   ::oRs:Open( "SELECT * FROM ConfExtraFields", ::oCon )

   while !::oRs:Eof()

      if AllTrim( ::formatField( ::oRs:Fields( "AplyToTable" ):Value ) ) == "Customer"

         ( D():CamposExtras( ::nView ) )->( dbAppend() )

         ( D():CamposExtras( ::nView ) )->cCodigo      := AllTrim( ::formatID( ::oRs:Fields( "ExtraFieldId" ):Value ) )
         ( D():CamposExtras( ::nView ) )->cNombre      := AllTrim( ::formatField( ::oRs:Fields( "Description" ):Value ) )
         ( D():CamposExtras( ::nView ) )->MDocumento   := hb_serialize( aDocumentos )
         ( D():CamposExtras( ::nView ) )->nLongitud    := 200

         if Empty( ::formatField( ::oRs:Fields( "LongTextAnswersList" ):Value ) )
            ( D():CamposExtras( ::nView ) )->nTipo     := 1
         else
            ( D():CamposExtras( ::nView ) )->nTipo     := 5
            ( D():CamposExtras( ::nView ) )->mDefecto  := hb_serialize( hb_atokens( AllTrim( ::formatField( ::oRs:Fields( "LongTextAnswersList" ):Value ) ), ";" ) )
         end if

         ( D():CamposExtras( ::nView ) )->( dbUnlock() )

         MsgWait( "Campos extra: " + ::formatField( ::oRs:Fields( "Description" ):Value ), "Atención", 0.05 )

      end if

      ::oRs:MoveNext()

   end while

   ::LimpiaConexionMdb()

Return .t.

//---------------------------------------------------------------------------//

METHOD ImportaValoresCamposExtra() CLASS ImportaMdb

   MsgWait( "Importación de detalle de campos extra.", "Atención", 1 )

   ::oRs:Open( "SELECT * FROM PartyExtraFields", ::oCon )

   while !::oRs:Eof()

      ( D():DetCamposExtras( ::nView ) )->( dbAppend() )
         
      ( D():DetCamposExtras( ::nView ) )->cTipDoc     := CLI_TBL
      ( D():DetCamposExtras( ::nView ) )->cCodTipo    := AllTrim( ::formatId( ::oRs:Fields( "ExtraFieldId" ):Value ) )
      ( D():DetCamposExtras( ::nView ) )->cClave      := Rjust( ::formatID( ::oRs:Fields( "PartyId" ):Value ), "0", RetNumCodCliEmp() )
      ( D():DetCamposExtras( ::nView ) )->cValor      := AllTrim( ::formatField( ::oRs:Fields( "TextAnswer" ):Value ) )

      ( D():DetCamposExtras( ::nView ) )->( dbUnlock() )

      MsgWait( "Valores campos extra: " + ::formatField( ::oRs:Fields( "TextAnswer" ):Value ), "Atención", 0.05 )

      ::oRs:MoveNext()

   end while

   ::LimpiaConexionMdb()

Return .t.

//---------------------------------------------------------------------------//

Method ImportaMensajesClientes() CLASS ImportaMdb

   local cCodCli

   MsgWait( "Importación de incidencias de clientes.", "Atención", 1 )

   ::oRs:Open( "SELECT * FROM PartyMessages", ::oCon )

   while !::oRs:Eof()

      cCodCli     := Rjust( ::formatID( ::oRs:Fields( "PartyId" ):Value ), "0", RetNumCodCliEmp() )

      if aScan( ::aClientes, cCodCli ) != 0

         ( D():ClientesIncidencias( ::nView ) )->( dbAppend() )
            
         ( D():ClientesIncidencias( ::nView ) )->cCodCli     := cCodCli
         ( D():ClientesIncidencias( ::nView ) )->mDesInc     := AllTrim( ::formatField( ::oRs:Fields( "Message" ):Value ) )
         ( D():ClientesIncidencias( ::nView ) )->lAviso     := .t.

         ( D():ClientesIncidencias( ::nView ) )->( dbUnlock() )

      end if

      MsgWait( "Incidencias clientes: " + ::formatId( ::oRs:Fields( "PartyId" ):Value ), "Atención", 0.05 )

      ::oRs:MoveNext()

   end while

   ::LimpiaConexionMdb()

Return .t.

//---------------------------------------------------------------------------//

Method ImportaBancosClientes() CLASS ImportaMdb

   local cCodCli

   MsgWait( "Importación de bancos de clientes.", "Atención", 1 )

   ::oRs:Open( "SELECT * FROM PartyBankAccount", ::oCon )

   while !::oRs:Eof()

      cCodCli        := Rjust( ::formatID( ::oRs:Fields( "PartyId" ):Value ), "0", RetNumCodCliEmp() )

      if aScan( ::aClientes, cCodCli ) != 0

         ( D():ClientesBancos( ::nView ) )->( dbAppend() )
            
         ( D():ClientesBancos( ::nView ) )->cCodCli     := cCodCli
         ( D():ClientesBancos( ::nView ) )->cCodBnc     := AllTrim( ::formatField( ::oRs:Fields( "BankName" ):Value ) )

         ( D():ClientesBancos( ::nView ) )->cPaisIBAN    := SubStr( AllTrim( ::formatField( ::oRs:Fields( "FormattedIBAN" ):Value ) ), 1, 2 )
         ( D():ClientesBancos( ::nView ) )->cCtrlIBAN    := SubStr( AllTrim( ::formatField( ::oRs:Fields( "FormattedIBAN" ):Value ) ), 3, 2 )
         ( D():ClientesBancos( ::nView ) )->cEntBnc      := SubStr( AllTrim( ::formatField( ::oRs:Fields( "FormattedIBAN" ):Value ) ), 5, 4 )
         ( D():ClientesBancos( ::nView ) )->cSucBnc      := SubStr( AllTrim( ::formatField( ::oRs:Fields( "FormattedIBAN" ):Value ) ), 9, 4 )
         ( D():ClientesBancos( ::nView ) )->cDigBnc      := SubStr( AllTrim( ::formatField( ::oRs:Fields( "FormattedIBAN" ):Value ) ), 13, 2 )
         ( D():ClientesBancos( ::nView ) )->cCtaBnc      := SubStr( AllTrim( ::formatField( ::oRs:Fields( "FormattedIBAN" ):Value ) ), 15 )

         ( D():ClientesBancos( ::nView ) )->( dbUnlock() )

      end if

      MsgWait( "Bancos clientes: " + ::formatId( ::oRs:Fields( "PartyId" ):Value ), "Atención", 0.05 )

      ::oRs:MoveNext()

   end while

   ::LimpiaConexionMdb()

Return .t.

//---------------------------------------------------------------------------//

Method ImportaColores() CLASS ImportaMdb

   MsgWait( "Importación de colores.", "Atención", 1 )

   ::oRs:Open( "SELECT * FROM color", ::oCon )

   while !::oRs:Eof()

      ( D():PropiedadesLineas( ::nView ) )->( dbAppend() )

      ( D():PropiedadesLineas( ::nView ) )->cCodPro   := Padr( "00001", 20 )
      ( D():PropiedadesLineas( ::nView ) )->cCodTbl   := Padr( AllTrim( ::formatID( ::oRs:Fields( "ColorId" ):Value ) ), 40 )
      ( D():PropiedadesLineas( ::nView ) )->cDesTbl   := AllTrim( ::formatField( ::oRs:Fields( "Description" ):Value ) )
      ( D():PropiedadesLineas( ::nView ) )->nColor    := ::oRs:Fields( "ColorCode" ):Value

      ( D():PropiedadesLineas( ::nView ) )->( dbUnlock() )

      MsgWait( "Color: " + ::formatField( ::oRs:Fields( "Description" ):Value ), "Atención", 0.05 )

      ::oRs:MoveNext()

   end while

   ::LimpiaConexionMdb()

Return .t.

//---------------------------------------------------------------------------//

Method ImportaTallas() CLASS ImportaMdb

   MsgWait( "Importación de tallas.", "Atención", 1 )

   ::oRs:Open( "SELECT * FROM Size1", ::oCon )

   while !::oRs:Eof()

      ( D():PropiedadesLineas( ::nView ) )->( dbAppend() )

      ( D():PropiedadesLineas( ::nView ) )->cCodPro   := Padr( "00002", 20 )
      ( D():PropiedadesLineas( ::nView ) )->cCodTbl   := Padr( AllTrim( ::formatID( ::oRs:Fields( "SizeId" ):Value ) ), 40 )
      ( D():PropiedadesLineas( ::nView ) )->cDesTbl   := if( ValType( ::oRs:Fields( "Description" ):Value ) == "N", AllTrim( ::formatID( ::oRs:Fields( "Description" ):Value ) ), AllTrim( ::formatField( ::oRs:Fields( "Description" ):Value ) ) )

      ( D():PropiedadesLineas( ::nView ) )->( dbUnlock() )

      MsgWait( "Color: " + ::formatField( ::oRs:Fields( "Description" ):Value ), "Atención", 0.05 )

      ::oRs:MoveNext()

   end while

   ::LimpiaConexionMdb()

Return .t.

//---------------------------------------------------------------------------//

Method ImportaPrecioGeneral() CLASS ImportaMdb

   local cCodArt
   local nPriceLineId

   MsgWait( "Importación de precios generales.", "Atención", 1 )

   ::oRs:Open( "SELECT * FROM ItemSellingPrices", ::oCon )

   while !::oRs:Eof()

      if ::oRs:Fields( "SizeId" ):Value == 0

         cCodArt        := if( ValType( ::oRs:Fields( "ItemId" ):Value ) == "N", ::formatID( ::oRs:Fields( "ItemId" ):Value ), ::formatField( ::oRs:Fields( "ItemId" ):Value ) )
         nPriceLineId   := ::oRs:Fields( "PriceLineId" ):Value

         if ( D():Articulos( ::nView ) )->( dbSeek( cCodArt ) ) .and.;
            dbLock( D():Articulos( ::nView ) )

            do case
               case nPriceLineId == 0
                  ( D():Articulos( ::nView ) )->pCosto        := ::oRs:Fields( "UnitPrice" ):Value

               case nPriceLineId == 1
                  ( D():Articulos( ::nView ) )->Benef1        := ::oRs:Fields( "FixedProfitRate" ):Value
                  ( D():Articulos( ::nView ) )->pVenta1       := ::oRs:Fields( "UnitPrice" ):Value
                  ( D():Articulos( ::nView ) )->pVtaIva1      := ::oRs:Fields( "TaxIncludedPrice" ):Value

               case nPriceLineId == 2
                  ( D():Articulos( ::nView ) )->Benef2        := ::oRs:Fields( "FixedProfitRate" ):Value
                  ( D():Articulos( ::nView ) )->pVenta2       := ::oRs:Fields( "UnitPrice" ):Value
                  ( D():Articulos( ::nView ) )->pVtaIva2      := ::oRs:Fields( "TaxIncludedPrice" ):Value

               case nPriceLineId == 3
                  ( D():Articulos( ::nView ) )->Benef3        := ::oRs:Fields( "FixedProfitRate" ):Value
                  ( D():Articulos( ::nView ) )->pVenta3       := ::oRs:Fields( "UnitPrice" ):Value
                  ( D():Articulos( ::nView ) )->pVtaIva3      := ::oRs:Fields( "TaxIncludedPrice" ):Value

            end case

            ( D():Articulos( ::nView ) )->( dbUnlock() )

            MsgWait( "Precio artículo: " + AllTrim( ( D():Articulos( ::nView ) )->Nombre ), "Atención", 0.05 )

         end if

      end if

      ::oRs:MoveNext()

   end while

   ::LimpiaConexionMdb()

Return .t.

//---------------------------------------------------------------------------//

METHOD ImportaPropiedadesArticulo() CLASS ImportaMdb

   local cConsulta         := ""
   local cCodBar

   MsgWait( "Importación de Propiedades de artículos.", "Atención", 1 )

   cConsulta               := "SELECT * FROM ItemSize INNER JOIN ItemColor ON ItemSize.ItemID = ItemColor.ItemID"

   ::oRs:Open( cConsulta, ::oCon )

   while !::oRs:Eof()

         ( D():ArticuloPrecioPropiedades( ::nView ) )->( dbAppend() )

         ( D():ArticuloPrecioPropiedades( ::nView ) )->cCodArt    := if( ValType( ::oRs:Fields( "ItemSize.ItemId" ):Value ) == "N", ::formatID( ::oRs:Fields( "ItemSize.ItemId" ):Value ), ::formatField( ::oRs:Fields( "ItemSize.ItemId" ):Value ) )
         ( D():ArticuloPrecioPropiedades( ::nView ) )->cCodDiv    := cDivEmp()
         ( D():ArticuloPrecioPropiedades( ::nView ) )->cCodPr1    := Padr( "00001", 20 )
         ( D():ArticuloPrecioPropiedades( ::nView ) )->cCodPr2    := Padr( "00002", 20 )
         ( D():ArticuloPrecioPropiedades( ::nView ) )->cValPr1    := ::formatID( ::oRs:Fields( "ColorId" ):Value )
         ( D():ArticuloPrecioPropiedades( ::nView ) )->cValPr2    := ::formatID( ::oRs:Fields( "SizeId" ):Value )

         ( D():ArticuloPrecioPropiedades( ::nView ) )->( dbUnLock() )

         MsgWait( "Artículo: " + if( ValType( ::oRs:Fields( "ItemSize.ItemId" ):Value ) == "N", ::formatID( ::oRs:Fields( "ItemSize.ItemId" ):Value ), ::formatField( ::oRs:Fields( "ItemSize.ItemId" ):Value ) ) + CRLF + ;
                  "Talla: " + ::formatID( ::oRs:Fields( "SizeId" ):Value ) + CRLF + ;
                  "Color: " + ::formatID( ::oRs:Fields( "ColorId" ):Value ),;
                  "Atención",;
                  0.05 )

         /*( D():ArticulosCodigosBarras( ::nView ) )->( dbAppend() )

         ( D():ArticulosCodigosBarras( ::nView ) )->cCodArt       := if( ValType( ::oRs:Fields( "ItemSize.ItemId" ):Value ) == "N", ::formatID( ::oRs:Fields( "ItemSize.ItemId" ):Value ), ::formatField( ::oRs:Fields( "ItemSize.ItemId" ):Value ) )
         cCodBar                                                  := AllTrim( if( ValType( ::oRs:Fields( "ItemSize.ItemId" ):Value ) == "N", ::formatID( ::oRs:Fields( "ItemSize.ItemId" ):Value ), ::formatField( ::oRs:Fields( "ItemSize.ItemId" ):Value ) ) )
         cCodBar                                                  += "." + AllTrim( ::formatID( ::oRs:Fields( "ColorId" ):Value ) )
         cCodBar                                                  += "." + AllTrim( ::formatID( ::oRs:Fields( "SizeId" ):Value ) )

         ( D():ArticulosCodigosBarras( ::nView ) )->cCodBar       := cCodBar

         ( D():ArticulosCodigosBarras( ::nView ) )->( dbUnlock() )

         MsgWait( "Código de barras: " + cCodBar, "Atención", 0.05 )*/

      ::oRs:MoveNext()

   end while

   ::LimpiaConexionMdb()

return .t.

//---------------------------------------------------------------------------//