#include "FiveWin.Ch"
#include "Factu.ch"
#include "Xbrowse.ch"

CLASS ReceiptInvoiceCustomer FROM DocumentsSales  
  
   DATA cNumeroFactura                    INIT ""
   DATA nImporteAnterior                  INIT 0
   DATA lShowFilterCobrado                INIT .t.
   DATA lCloseFiles                       INIT .t.

   DATA lAceptarImprimir                  INIT .f.

   METHOD New()

   METHOD Play()

   METHOD getEditDocumento()

   METHOD onPreEnd()

   METHOD onPostGetDocumento()

   METHOD onViewSave()

   METHOD onPreSaveEdit()

   METHOD deleteLinesDocument()           INLINE ( .t. )

   METHOD assignLinesDocument()           INLINE ( .t. )

   METHOD setLinesDocument()              INLINE ( .t. )

   METHOD onPreEditDocumento()

   METHOD addReciboDiferencia()

   METHOD FilterTable()

   METHOD onPreRunNavigator()

   METHOD onPostSaveEdit()

   METHOD printReceipt()                  INLINE ( PrnRecCli( ( ::getDataTable() )->cSerie + Str( ( ::getDataTable() )->nNumFac ) + ( ::getDataTable() )->cSufFac + Str( ( ::getDataTable() )->nNumRec ) ) )

   METHOD setTrueAceptarImprimir()        INLINE ( ::lAceptarImprimir  := .t. )
   METHOD setFalseAceptarImprimir()       INLINE ( ::lAceptarImprimir  := .t. )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oInvoice ) CLASS ReceiptInvoiceCustomer

   ::super:oSender         := self

   if Empty( oInvoice )

      if !::openFiles()
         return ( self )
      end if 

   else

      ::lCloseFiles              := .f.
      ::nView                    := oInvoice:nView
      ::cNumeroFactura           := oInvoice:GetId()
      ::lShowFilterCobrado       := Empty( oInvoice:GetId() )

   end if

   ::oViewSearchNavigator  := ReceiptDocumentSalesViewSearchNavigator():New( self )
   ::oViewSearchNavigator:setTitleDocumento( "Recibos de clientes" )  

   ::oViewEdit             := ReceiptDocumentSalesViewEdit():New( self )
   ::oViewEdit:setTitleDocumento( "Recibo cliente" )  

   ::setTypePrintDocuments( "RF" )

   ::setCounterDocuments( "NRECCLI" )

   // Areas--------------------------------------------------------------------

   ::setDataTable( "FacCliP" )

Return ( self )

//---------------------------------------------------------------------------//

METHOD play() CLASS ReceiptInvoiceCustomer

   if ::onPreRunNavigator()
      ::runNavigator()
   end if 

   if ::lCloseFiles
      ::closeFiles()
   end if

return ( self )

//---------------------------------------------------------------------------//

METHOD getEditDocumento() CLASS ReceiptInvoiceCustomer

   local id                := D():FacturasClientesCobrosId( ::nView )

   if Empty( id )
      Return .f.
   end if

   ::hDictionaryMaster     := D():getFacturaClienteCobros( ::nView )

   if empty( ::hDictionaryMaster )
      Return .f.
   end if 

Return ( .t. )

//----------------------------------------------------------------------------//

METHOD onViewSave() CLASS ReceiptInvoiceCustomer

   ::oViewEdit:oDlg:end( IDOK )

Return ( self )

//---------------------------------------------------------------------------//

METHOD onPreSaveEdit() CLASS ReceiptInvoiceCustomer

   local nNuevoImporte        := 0
   local nImporteReciboNuevo  := 0

   /*
   Convertimos el estado a Lógico----------------------------------------------
   */

   hSet( ::oSender:hDictionaryMaster, "LogicoCobrado", ( ::oViewEdit:cCbxEstado == "Cobrado" ) )
   hSet( ::oSender:hDictionaryMaster, "FechaCobro", if( ::oViewEdit:cCbxEstado == "Cobrado", Date(), cToD( "" ) ) )
   
   hSet( ::oSender:hDictionaryMaster, "FechaCreacion", Date() )
   hSet( ::oSender:hDictionaryMaster, "HoraCreacion", Time() )

   /*
   Vemos si hay que generar un nuevo recibo------------------------------------
   */

   nNuevoImporte  := hGet( ::oSender:hDictionaryMaster, "TotalDocumento" )

   if nNuevoImporte != ::nImporteAnterior
      
      nImporteReciboNuevo     := ( ::nImporteAnterior - nNuevoImporte ) * if( ::nImporteAnterior < 0, - 1 , 1 )

      ::addReciboDiferencia( nImporteReciboNuevo )

   end if

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD onPostSaveEdit() CLASS ReceiptInvoiceCustomer

   local nRec     := ( D():FacturasClientes( ::nView ) )->( Recno() )
   local nOrdAnt  := ( D():FacturasClientes( ::nView ) )->( OrdSetFocus( "NNUMFAC" ) )

   if ::lAceptarImprimir
      ::printReceipt()
      ::setFalseAceptarImprimir()
   end if

   if ( D():FacturasClientes( ::nView ) )->( dbSeek( ( ::getDataTable() )->cSerie + Str( ( ::getDataTable() )->nNumFac ) + ( ::getDataTable() )->cSufFac ) )

      if dbLock( D():FacturasClientes( ::nView ) )
         ( D():FacturasClientes( ::nView ) )->lSndDoc    := .t.
         ( D():FacturasClientes( ::nView ) )->dFecCre    := date()
         ( D():FacturasClientes( ::nView ) )->cTimCre    := time()
         ( D():FacturasClientes( ::nView ) )->( dbUnLock() )
      end if

      ChkLqdFacCli( nil, D():FacturasClientes( ::nView ), D():FacturasClientesLineas( ::nView ), D():FacturasClientesCobros( ::nView ), D():AnticiposClientes( ::nView ), D():TiposIva( ::nView ), D():Divisas( ::nView ), .f. )
      
   end if

   ( D():FacturasClientes( ::nView ) )->( OrdSetFocus( nOrdAnt ) )
   ( D():FacturasClientes( ::nView ) )->( dbGoTo( nRec ) )
   
   ::oViewSearchNavigator:changeComboboxSearch()
   
   ::FilterTable( ::oViewSearchNavigator:cComboboxFilter )
   
Return ( .t. )

//---------------------------------------------------------------------------//

METHOD onPostGetDocumento() CLASS ReceiptInvoiceCustomer

   ::oldSerie           := ::getSerie()   

   ::nImporteAnterior   := hGet( ::oSender:hDictionaryMaster, "TotalDocumento" )

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD onPreEditDocumento() CLASS ReceiptInvoiceCustomer

   ::nOrdenAnterior     := ( ::getDataTable() )->( OrdSetFocus() )

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD onPreEnd() CLASS ReceiptInvoiceCustomer

   local cNumeroFactura    := ( ::getDataTable() )->cSerie + Str( ( ::getDataTable() )->nNumFac ) + ( ::getDataTable() )->cSufFac

   /*
   Chequeamos el estado de la factura antes de terminar------------------------
   */

   if ( D():FacturasClientes( ::nView ) )->( dbSeek( cNumeroFactura ) )
      ChkLqdFacCli( nil, D():FacturasClientes( ::nView ), D():FacturasClientesLineas( ::nView ), D():FacturasClientesCobros( ::nView ), D():AnticiposClientes( ::nView ), D():TiposIva( ::nView ), D():Divisas( ::nView ), .f. )
   end if

   ( ::getDataTable() )->( OrdSetFocus( ::nOrdenAnterior ) )

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD addReciboDiferencia( nImporteRecibo ) CLASS ReceiptInvoiceCustomer

   local nRec        := ( ::getDataTable() )->( Recno() )
   local aTabla
   local nCount
   local cNumRec     := ""

   aTabla            := dbScatter( ::getDataTable() )

   cNumRec           += aTabla[ ( ::getDataTable() )->( fieldpos( "cSerie" ) ) ]
   cNumRec           += Str( aTabla[ ( ::getDataTable() )->( fieldpos( "nNumFac" ) ) ] )
   cNumRec           += aTabla[ ( ::getDataTable() )->( fieldpos( "cSufFac" ) ) ]

   ( ::getDataTable() )->( dbClearFilter() )

   nCount            := nNewReciboCliente( cNumRec, aTabla[ ( ::getDataTable() )->( fieldpos( "cTipRec" ) ) ], ::getDataTable() )

   /*
   Añadimos el nuevo recibo-------------------------------------------------
   */

   ( ::getDataTable() )->( dbAppend() )

   ( ::getDataTable() )->cTurRec    := cCurSesion()
   ( ::getDataTable() )->cTipRec    := aTabla[ ( ::getDataTable() )->( fieldpos( "cTipRec" ) ) ]
   ( ::getDataTable() )->cSerie     := aTabla[ ( ::getDataTable() )->( fieldpos( "cSerie" ) ) ]
   ( ::getDataTable() )->nNumFac    := aTabla[ ( ::getDataTable() )->( fieldpos( "nNumFac" ) ) ]
   ( ::getDataTable() )->cSufFac    := aTabla[ ( ::getDataTable() )->( fieldpos( "cSufFac" ) ) ]
   ( ::getDataTable() )->nNumRec    := nCount
   ( ::getDataTable() )->cCodCaj    := aTabla[ ( ::getDataTable() )->( fieldpos( "cCodCaj" ) ) ]
   ( ::getDataTable() )->cCodCli    := aTabla[ ( ::getDataTable() )->( fieldpos( "cCodCli" ) ) ]
   ( ::getDataTable() )->cNomCli    := aTabla[ ( ::getDataTable() )->( fieldpos( "cNomCli" ) ) ]
   ( ::getDataTable() )->cCodAge    := aTabla[ ( ::getDataTable() )->( fieldpos( "cCodAge" ) ) ] 
   ( ::getDataTable() )->nImporte   := nImporteRecibo
   ( ::getDataTable() )->nImpCob    := nImporteRecibo
   ( ::getDataTable() )->cDescrip   := "Recibo nº" + AllTrim( str( nCount ) ) + " de factura " + if( !empty( aTabla[ ( ::getDataTable() )->( fieldpos( "cTipRec" ) ) ] ), "rectificativa ", "" ) + aTabla[ ( ::getDataTable() )->( fieldpos( "cSerie" ) ) ] + '/' + AllTrim( str( aTabla[ ( ::getDataTable() )->( fieldpos( "nNumFac" ) ) ] ) ) + '/' + aTabla[ ( ::getDataTable() )->( fieldpos( "cSufFac" ) ) ]
   ( ::getDataTable() )->dPreCob    := dFecFacCli( cNumRec, D():FacturasClientes( ::nView ) )
   ( ::getDataTable() )->cPgdoPor   := ""
   ( ::getDataTable() )->lCobrado   := .f.
   ( ::getDataTable() )->cDivPgo    := aTabla[ ( ::getDataTable() )->( fieldpos( "cDivPgo" ) ) ]
   ( ::getDataTable() )->nVdvPgo    := aTabla[ ( ::getDataTable() )->( fieldpos( "nVdvPgo" ) ) ]
   ( ::getDataTable() )->cCodPgo    := aTabla[ ( ::getDataTable() )->( fieldpos( "cCodPgo" ) ) ]
   ( ::getDataTable() )->lConPgo    := .f.
   ( ::getDataTable() )->dFecCre    := GetSysDate()
   ( ::getDataTable() )->cHorCre    := Substr( Time(), 1, 5 )

   ( ::getDataTable() )->( dbUnLock() )

   ( ::getDataTable() )->( dbGoTo( nRec ) )

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD FilterTable( cTextFilter ) CLASS ReceiptInvoiceCustomer

   do case
      case cTextFilter == "Todos delegación"

         ( ::getDataTable() )->( adsSetAOF( "Field->cSufFac == '" + Application():CodigoDelegacion() + "'" ) )

      case cTextFilter == "Pendientes delegación"

         ( ::getDataTable() )->( adsSetAOF( "!Field->lCobrado .and. Field->cSufFac == '" + Application():CodigoDelegacion() + "'" ) )
      
      case cTextFilter == "Cobrados delegación"
         
         ( ::getDataTable() )->( adsSetAOF( "Field->lCobrado .and. Field->cSufFac = '" + Application():CodigoDelegacion() + "'" ) )
      
      case cTextFilter == "Pendientes"

         ( ::getDataTable() )->( adsSetAOF( "!Field->lCobrado" ) )
      
      case cTextFilter == "Cobrados"

         ( ::getDataTable() )->( adsSetAOF( "Field->lCobrado" ) )
      
      case cTextFilter == "Todos"

         ( ::getDataTable() )->( adsClearAOF() )

   end case

   ( ::getDataTable() )->( dbgotop() )

   ::oViewSearchNavigator:oBrowse:SelectCurrent()
   ::oViewSearchNavigator:oBrowse:Refresh()

return ( .t. )

//---------------------------------------------------------------------------//

METHOD onPreRunNavigator() CLASS ReceiptInvoiceCustomer

   if empty( ::getWorkArea() )
      Return .t.
   end if 

   if !Empty( ::cNumeroFactura )
      
      if !( D():FacturasClientes( ::nView ) )->( dbSeek( ::cNumeroFactura ) )
         Return ( .f. )
      end if

   end if

   ( ::getWorkArea() )->( ordsetfocus( "dFecDes" ) )
   ( ::getWorkArea() )->( dbgotop() ) 

   if !Empty( ::cNumeroFactura )

      ( ::getWorkArea() )->( adsSetAOF( "Field->cSerie + Str( Field->nNumFac ) + Field->cSufFac == '" + ::cNumeroFactura + "'" ) )
      ( ::getWorkArea() )->( dbgotop() )

   else

      if ( accessCode():lFilterByAgent ) .and. !empty( accessCode():cAgente )
      
         ( ::getWorkArea() )->( adsSetAOF( "Field->cCodAge == '" + accessCode():cAgente + "'" ) )
         ( ::getWorkArea() )->( dbgotop() )

         ( D():Clientes( ::nView ) )->( adsSetAOF( "Field->cCodAge == '" + accessCode():cAgente + "'" ) )
         ( D():Clientes( ::nView ) )->( dbgotop() )

      end if 

   end if

Return ( .t. )

//---------------------------------------------------------------------------//