#include "FiveWin.Ch" 
#include "Struct.ch"
#include "Factu.ch" 
#include "Ini.ch"
#include "MesDbf.ch" 

#define tipoProducto    1
#define tipoCategoria   2     

//---------------------------------------------------------------------------//

static oTimer
static oComercio
static oMsgAlarm

//---------------------------------------------------------------------------//

CLASS TComercio

   CLASSDATA oInstance
   CLASSDATA hProductsToUpdate      INIT {=>}

   DATA  TPrestashopConfig  
   DATA  TPrestashopId

   DATA  TComercioCustomer
   DATA  TComercioBudget
   DATA  TComercioOrder
   DATA  TComercioProduct
   DATA  TComercioCategory

   DATA  aSend
   DATA  oInt
   DATA  oUrl
   DATA  oFtp
   DATA  nTotMeter

   DATA  oBmpSel
   DATA  oDlg
   DATA  oFld
   DATA  oBmp

   DATA  oDlgWait
   DATA  oBmpWait
   DATA  oSayWait
   DATA  cSayWait

   DATA  oSubItem
   DATA  oSubItem2

   DATA  cIniFile

   DATA  lPedidosWeb                INIT  .f.

   DATA  nTipoEnvio                 INIT  1

   DATA  nLevel

   DATA  aFilesProcessed

   DATA  oBotonTerminar

   DATA  cFilTxt
   DATA  oFilTxt
   DATA  hFilTxt

   DATA  oBtnCancel
   DATA  oBtnExportar
   DATA  oBtnImportar
   DATA  oBtnStock

   DATA  cPath

   DATA  lSyncAll                   INIT .f.
   DATA  lArticulos                 INIT .f.
   DATA  lFamilias                  INIT .f.
   DATA  lPedidos                   INIT .f.
   DATA  lFabricantes               INIT .f.
   DATA  lIva                       INIT .f.
   DATA  lImagenes                  INIT .f.
   DATA  lClientes                  INIT .f.

   DATA  oArticulos
   DATA  oPedidos
   DATA  oTipIva
   DATA  oCliente
   DATA  oImagenes

   DATA  oArt
   DATA  oPro
   DATA  oTblPro
   DATA  oFPago

   DATA  oArtDiv
   DATA  oTipArt
   DATA  oFam
   DATA  oGrpFam
   DATA  oCli
   DATA  oObras

   DATA  oIva
   DATA  oDivisas
   DATA  oPedCliT
   DATA  oPedCliI
   DATA  oPedCliE
   DATA  oPedCliL
   DATA  oCount
   DATA  oFab
   DATA  oKit
   DATA  oAlbCliT
   DATA  oAlbCliL
   DATA  oFacCliL
   DATA  oFacRecL
   DATA  oTikCliL
   DATA  oProLin
   DATA  oProMat
   DATA  oHisMov
   DATA  oPedPrvL
   DATA  oAlbPrvT
   DATA  oAlbPrvL
   DATA  oFacPrvL
   DATA  oRctPrvL
   DATA  oArtImg
   DATA  oOferta
   DATA  oTextOfertas
   DATA  oPreCliT
   DATA  oPreCliL
   DATA  oPreCliI
   DATA  oPreCliE

   DATA  aDeletedImages

   DATA  oStock

   DATA  oCon
   DATA  cHost
   DATA  cUser
   DATA  cPasswd
   DATA  cDbName
   DATA  nPort

   DATA  oComboWebToExport

   DATA  cWebToExport                     INIT ""

   DATA  cSeriePed

   DATA  Cookiekey

   DATA  oInt
   DATA  aImages
   DATA  aImagesArticulos
   DATA  aImagesCategories
   DATA  aTypeImagesPrestashop

   DATA  nLanguage

   DATA  nPrecioMinimo                    INIT 0

   DATA  lProductIdColumnImageShop  
   DATA  lProductIdColumnProductAttribute
   DATA  lProductIdColumnProductAttributeShop
   DATA  lSpecificPriceIdColumnReductionTax

   DATA  nSecondTimer

   DATA  lDefImgPrp                       INIT .f.

   DATA  nNumeroCategorias                INIT 0
   DATA  aCategorias                      INIT {}

   DATA  aArticulosActualizar             INIT {}

   DATA  cPrefijoBaseDatos

   DATA TSituaciones

   DATA idOrderPrestashop
   DATA cSeriePedido
   DATA cSeriePresupuesto
   DATA nNumeroPedido
   DATA nNumeroPresupuesto
   DATA cSufijoPedido
   DATA cSufijoPresupuesto

   DATA oWaitMeter

   METHOD New()                           CONSTRUCTOR
   METHOD GetInstance()              
   METHOD EndInstance()

   METHOD MeterTotal( oMeterTotal )       INLINE ( iif( oMeterTotal == nil, ::oMeterTotal := oMeterTotal, ::oMeterTotal ) )
   METHOD TextTotal( oTextTotal )         INLINE ( iif( oTextTotal == nil, ::oTextTotal := oTextTotal, ::oTextTotal ) )

   METHOD writeText( cText )           

   METHOD setWebToExport( cWebToExport )  INLINE ( ::cWebToExport := alltrim( cWebToExport ) )
   METHOD getWebToExport()                INLINE ( ::cWebToExport )

   // Apertura y cierre de ficheros--------------------------------------------

   METHOD filesOpen()
   METHOD filesClose()

   // Dialogos-----------------------------------------------------------------

   METHOD dialogActivate( oWnd )
      METHOD dialogCreateWebCombobox( idCombobox, oDialog )

      METHOD dialogStart()
      METHOD disableDialog()              INLINE   (  if( !empty(::oDlg),           ::oDlg:bValid := {|| .f. }, ),;
                                                      if( !empty(::oBtnExportar),   ::oBtnExportar:Hide(), ),;
                                                      if( !empty(::oBtnImportar),   ::oBtnImportar:Hide(), ),;
                                                      if( !empty(::oBtnStock),      ::oBtnStock:Hide(), ),;
                                                      if( !empty(::oBtnCancel),     ::oBtnCancel:Disable(), ) )
      METHOD enableDialog()               INLINE   (  if( !empty(::oDlg),           ::oDlg:bValid := {|| .t. }, ),;
                                                      if( !empty(::oBtnCancel),     ::oBtnCancel:Enable(), ) )

   METHOD isValidNameWebToExport()        INLINE   (  if ( empty( ::getWebToExport() ),;
                                                         ( msgStop( "No ha seleccionado ninguna web para exportar." ), .f. ),;
                                                         ( .t. ) ) )

   // Mensajes-----------------------------------------------------------------

   DATA  oTree

   DATA  oMeterTotal
   DATA  nMeterTotal                   INIT 0

   METHOD MeterTotal( oMeterTotal)     INLINE ( iif( oMeterTotal != nil, ::oMeterTotal := oMeterTotal, ::oMeterTotal ) )
   METHOD setMeterTotal( nTotal )      INLINE ( ::nTotMeter := nTotal, ( if( !empty( ::oMeterProceso ), ::oMeterProceso:SetTotal( ::nTotMeter ), ) ) )

   DATA  oTextTotal
   DATA  cTextTotal

   METHOD TextTotal( oTextTotal )      INLINE ( iif( oTextTotal != nil, ::oTextTotal := oTextTotal, ::oTextTotal ) )

   DATA  oMeterProceso
   DATA  nMeterProceso                 INIT 0

   DATA  aIvaData                      INIT {}
   DATA  aFabricantesData              INIT {}
   DATA  aFamiliaData                  INIT {}
   DATA  aProductData                  INIT {}
   DATA  aPropiedadesCabeceraData      INIT {}
   DATA  aPropiedadesLineasData        INIT {}
   DATA  aStockProductData             INIT {}
   
   DATA  cDirImagen

   METHOD buildFTP()                   
   METHOD destroyFTP()                 INLINE ( ::oFtp:endConcexion() )

   METHOD meterTotalText( cText )
   METHOD meterTotalSetTotal( nTotal )
   METHOD meterProcesoText( cText )
   METHOD meterProcesoSetTotal( nTotal )
   
   // Controladores---------------------------------------------------------------

   METHOD isAviableWebToExport()
      METHOD controllerExportPrestashop()
      METHOD controllerExportOneProductToPrestashop( idProduct )
      METHOD controllerOrderPrestashop()
      METHOD controllerUpdateStockPrestashop()

   METHOD AppendIvaPrestashop()
   METHOD InsertIvaPrestashop()
   METHOD lUpdateIvaPrestashop( nId )

   METHOD insertRootCategory()
   
   METHOD DelIdFamiliasPrestashop()

   METHOD GetValPrp( nIdPrp, nProductAttibuteId )
   METHOD DelIdPropiedadesPrestashop()

   METHOD InsertImageProductPrestashop()
   METHOD InsertImageProductPrestashopShop()
   METHOD InsertImageProductPrestashopLang()

   METHOD nIvaProduct( cCodArt )
   METHOD nIdProductAttribute( cCodWebArt, cCodWebValPr1, cCodWebValPr2 )

   METHOD DelIdArticuloPrestashop()

   //---------------------------------------------------------------------------//

   METHOD getTypeImagePrestashop()
   METHOD buildFilesProductImages( hProductImage )

   METHOD addImages( cImage )                INLINE ( iif(  ascan( ::aImages, cImage ) == 0,;
                                                            aadd( ::aImages, cImage ),;
                                                            ),;
                                                      ::aImages )

   METHOD addImagesArticulos( cImage )       INLINE ( iif(  ascan( ::aImagesArticulos, cImage ) == 0,;
                                                            aadd( ::aImagesArticulos, cImage ),;
                                                            ),;
                                                      ::aImagesArticulos )

   METHOD addImagesCategories( cImage )      INLINE ( iif(  ascan( ::aImagesCategories, cImage ) == 0,;
                                                            aadd( ::aImagesCategories, cImage ),;
                                                            ),;
                                                      ::aImagesCategories )



   //---------------------------------------------------------------------------//

   METHOD nDefImagen( cCodArt, cImagen )
   METHOD nCodigoWebImagen( cCodArt, cImagen )
   METHOD lLimpiaRefImgWeb()

   METHOD ConectBBDD()
   METHOD DisconectBBDD()
   METHOD AvisoSincronizaciontotal()
   METHOD cPreFixtable( cName )
   METHOD AutoRecive()
   METHOD GetLanguagePrestashop()

   METHOD AppendClientesToPrestashop()

   METHOD AppendClientPrestashop()
   METHOD EstadoPedidosPrestashop()
   METHOD AppendMessagePedido()

   METHOD cValidDirectoryFtp( cDirectory )

   METHOD CreateDirectoryImagesLocal( cCarpeta )

   METHOD loadOrders()
   METHOD processOrder( oQuery )
   METHOD checkDate( cDatePrestashop )

   // recepcion de pedidos o presupuestos--------------------------------------

   METHOD isRecivedDocumentAsBudget( cPrestashopModule ) 

   METHOD documentRecived( oQuery, oDatabase )                INLINE ( .t. )
      METHOD isOrderAlreadyRecived( oQuery )                  INLINE ( ::documentRecived( oQuery, ::oPedCliT ) )

   METHOD getDate( cDatePrestashop )
   METHOD getTime( ctimePrestashop )

   METHOD syncSituacionesPedidoPrestashop( cCodWeb, cSerPed, nNumPed, cSufPed )
   METHOD syncronizeStatesGestool( cCodWeb, cSerPed, nNumPed, cSufPed )
   METHOD checkExistStateUp( oQuery, cCodWeb, cSerPed, nNumPed, cSufPed )
   METHOD syncronizeStatesPrestashop ( cSerPed, nNumPed, cSufPed, cCodWeb, oQuery )
   METHOD downloadState( oQuery, cSerPed, nNumPed, cSufPed )
   METHOD UploadState( id_order_state, dFecSit, tFecSit, cCodWeb )

   METHOD getDatePrestashop( dFec, tFec )
   METHOD idOrderState( cSitua )

   METHOD syncSituacionesPresupuestoPrestashop( cCodWeb, cSerPre, nNumPre, cSufPre )
   METHOD syncronizeStatesPresupuestoGestool( cCodWeb, cSerPre, nNumPre, cSufPre )
   METHOD presupuestoCheckExistStateUp( oQuery, cCodWeb, cSerPre, nNumPre, cSufPre )
   METHOD downloadStateToPresupuesto( oQuery, cSerPre, nNumPre, cSufPre )
   METHOD syncronizeStatesPresupuestoPrestashop ( cSerPre, nNumPre, cSufPre, cCodWeb )
   METHOD UploadStatePrestashop( id_order_state, dFecSit, tFecSit, cCodWeb )

   METHOD isProductIdColumn( cTable )
   METHOD isProductIdColumnImageShop()                       INLINE ( ::isProductIdColumn( "image_shop" ) )
   METHOD isProductIdColumnProductAttribute()                INLINE ( ::isProductIdColumn( "product_attribute" ) )
   METHOD isProductIdColumnProductAttributeShop()            INLINE ( ::isProductIdColumn( "product_attribute_shop" ) )
   METHOD isSpecificPriceIdColumnReductionTax()              INLINE ( ::isProductIdColumn( "specific_price", "reduction_tax" ) )

   // Datos para la recopilacion de informacion----------------------------

   METHOD getCurrentWebName()                         INLINE ( ::TPrestashopConfig:getCurrentWebName() )

   METHOD ProductInCurrentWeb()                       INLINE ( ::oArt:lPubInt .and. alltrim( ::oArt:cWebShop ) == ::getCurrentWebName() )  // DE MOMENTO

   // Metodos para la recopilacion de informacion----------------------------

   METHOD prestaShopConnect()
   METHOD prestashopDisConnect()
   METHOD prestaShopPing()                            INLINE ( if( !empty( ::oCon ), ::oCon:Ping(), ) )

   METHOD prestaShopStart()                           INLINE ( if( !empty( ::oCon ), E1ExecDirect( ::oCon:hConnect, "start" ), ) )
   METHOD prestaShopCommit()                          INLINE ( if( !empty( ::oCon ), E1ExecDirect( ::oCon:hConnect, "commit" ), ) )
   METHOD prestaShopRollBack()                        INLINE ( if( !empty( ::oCon ), E1ExecDirect( ::oCon:hConnect, "rollback" ), ) )

   METHOD ftpConnect()                                INLINE ( if( ::oFtp:CreateConexion(), .t., ( msgStop( "Imposible conectar al sitio ftp " + ::oFtp:cServer ), .t. ) ) )
   METHOD ftpDisConnect()                             INLINE ( if( !empty( ::oFtp ), ::oFtp:EndConexion(), ) )

   METHOD buildInitData()
   METHOD buildIvaPrestashop( id )
   METHOD buildFabricantePrestashop( id )
   METHOD buildFamiliaPrestashop( id )
   METHOD buildStockPrestashop()

   METHOD buildProductInformation( id )
   METHOD uploadInformationToPrestashop( id )
   METHOD updateInformationToPrestashop( id )

   METHOD buildGlobalProductInformation()
   METHOD uploadAditionalInformationToPrestashop()
   METHOD uploadProductToPrestashop()
   METHOD uploadImageToPrestashop()

   METHOD buildInsertIvaPrestashop( hTax )
   METHOD buildInsertFabricantesPrestashop( hFabricantesData )
   METHOD buildInsertCategoriesPrestashop( hFamiliaData )
   METHOD buildInsertProductsPrestashop( hProduct )
   METHOD buildInsertNodeCategoryProduct( idFamilia, idProduct )
   METHOD buildInsertCategoryProduct( idCategory, idProduct )

   METHOD buildProductPrestashop( id )
   METHOD buildActualizaCatergoriaPadrePrestashop( hFamiliaData )
   METHOD buildInsertImageProductsPrestashop( hProduct )
   METHOD buildRecalculaPosicionesCategoriasPrestashop()
   METHOD buildInsertOfertasPrestashop( hProduct, nCodigoWeb )
   METHOD buildPropiedadesPrestashop( id )
   METHOD buildInsertPropiedadesPrestashop( hPropiedadesCabData )
   METHOD buildInsertLineasPropiedadesPrestashop( hPropiedadesLinData )

   METHOD buildInsertImageProductsByProperties( hProduct, idProductAttribute )
   METHOD buildInsertPropiedadesProductPrestashop( hProduct, nCodigoWeb )
      METHOD insertProductAttributePrestashop()
      METHOD insertProductAttributeCombinationPrestashop()
      METHOD insertProductAttributeShopPrestashop()

   METHOD buildImagesArticuloPrestashop( id )

   METHOD buildDeleteProductPrestashop()

   METHOD buildDeleteImagesProducts( cCodWeb )
   METHOD buildDeleteImagesFiles()

   METHOD buildImagenes()
   METHOD buildSubirImagenes()
   METHOD uploadProductImages()

   METHOD buildPriceProduct()
   METHOD buildPriceReduction()
   METHOD buildPriceReductionTax()           INLINE ( if( ::oArt:lIvaWeb, 1, 0 ) )

   METHOD buildGetParentCategories()

   METHOD buildGetNodeParentCategories()

   METHOD buildEliminaTablas()

   METHOD buildCleanPrestashop()

   METHOD writeTextOk( cValue, cTable )      INLINE ( ::writeText( "Insertado correctamente " + cValue + ", en la tabla " + cTable, 3 ) )
   METHOD writeTextError( cValue, cTable )   INLINE ( ::writeText( "Error insertado " + cValue + ", en la tabla " + cTable, 3 ) )

   METHOD buildInformationStockProductDatabase()
   METHOD buildInformationStockProductArray()

   METHOD proccessStockPrestashop()
      METHOD buildInsertStockPrestashop()
      METHOD uploadStockToPrestashop( idProduct )

   METHOD buildAddInformacionStockProductPrestashop()
   METHOD buildAddArticuloActualizar( cCodArt )

   // ftp y movimientos de ficheros

   METHOD cDirectoryProduct()                INLINE ( ::TPrestashopConfig:getImagesDirectory() + "/p" )
   METHOD cDirectoryCategories()             INLINE ( ::TPrestashopConfig:getImagesDirectory() + "/c" )
   METHOD getRecursiveFolderPrestashop( cCarpeta )

   METHOD resetStockProductData()           INLINE ( ::aStockProductData := {} )

   METHOD resetProductsToUpadateStocks()     INLINE ( ::hProductsToUpdate := {=>} )
   METHOD getProductsToUpadateStocks()       INLINE ( ::hProductsToUpdate )
   METHOD appendProductsToUpadateStocks( idProduct )

   METHOD updateWebProductStocks()
   METHOD updateProductStocks( cWebName, aProductsWeb )   

END CLASS

//---------------------------------------------------------------------------//

METHOD GetInstance() CLASS TComercio

   if empty( ::oInstance )
      ::oInstance          := ::New()
   end if

RETURN ( ::oInstance )

//---------------------------------------------------------------------------//

METHOD EndInstance() CLASS TComercio

   if empty( ::oInstance )
      ::oInstance          := nil
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD New( oMenuItem, oMeterTotal, oTextTotal ) CLASS TComercio

   DEFAULT oMenuItem       := "01108"

   ::oMeterTotal           := oMeterTotal
   ::oTextTotal            := oTextTotal

   ::lSyncAll              := .f.
   ::nTotMeter             := 0 

   ::TPrestashopConfig     := TPrestashopConfig():New()
   ::TPrestashopConfig:loadJSON()

   ::TComercioCustomer     := TComercioCustomer():New( Self )

   ::TComercioBudget       := TComercioBudget():New( Self )

   ::TComercioOrder        := TComercioOrder():New( Self )

   ::TComercioProduct      := TComercioProduct():New( Self )

   ::TComercioCategory     := TComercioCategory():New( Self )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD buildInitData() CLASS TComercio

   ::aImages                     := {}
   ::aImagesArticulos            := {}
   ::aImagesCategories           := {}
   ::aTypeImagesPrestashop       := {}

   ::aIvaData                    := {}
   ::aFabricantesData            := {}
   ::aFamiliaData                := {}
   ::aProductData                := {}
   ::aArticulosActualizar        := {}
   ::aPropiedadesCabeceraData    := {}
   ::aPropiedadesLineasData      := {}

Return ( Self )

//---------------------------------------------------------------------------//

METHOD filesOpen() CLASS TComercio

   local oBlock
   local oError
   local lOpen       := .t.

   oBlock            := ErrorBlock( { | oError | Break( oError ) } )
   BEGIN SEQUENCE

      DATABASE NEW ::oArt     PATH ( cPatArt() ) FILE "ARTICULO.DBF"    VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"
      ::oArt:OrdSetFocus( "lPubInt" )

      DATABASE NEW ::oPro     PATH ( cPatArt() ) FILE "PRO.DBF"         VIA ( cDriver() ) SHARED INDEX "PRO.CDX"

      DATABASE NEW ::oTblPro  PATH ( cPatArt() ) FILE "TBLPRO.DBF"      VIA ( cDriver() ) SHARED INDEX "TBLPRO.CDX"

      DATABASE NEW ::oArtDiv  PATH ( cPatArt() ) FILE "ARTDIV.DBF"      VIA ( cDriver() ) SHARED INDEX "ARTDIV.CDX"

      DATABASE NEW ::oOferta  PATH ( cPatArt() ) FILE "OFERTA.DBF"      VIA ( cDriver() ) SHARED INDEX "OFERTA.CDX"

      DATABASE NEW ::oFam     PATH ( cPatArt() ) FILE "FAMILIAS.DBF"    VIA ( cDriver() ) SHARED INDEX "FAMILIAS.CDX"

      DATABASE NEW ::oGrpFam  PATH ( cPatArt() ) FILE "GRPFAM.DBF"      VIA ( cDriver() ) SHARED INDEX "GRPFAM.CDX"

      DATABASE NEW ::oTipArt  PATH ( cPatArt() ) FILE "TIPART.DBF"      VIA ( cDriver() ) SHARED INDEX "TIPART.CDX"

      DATABASE NEW ::oCli     PATH ( cPatCli() ) FILE "CLIENT.DBF"      VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

      DATABASE NEW ::oObras   PATH ( cPatCli() ) FILE "OBRAST.DBF"      VIA ( cDriver() ) SHARED INDEX "OBRAST.CDX"

      DATABASE NEW ::oIva     PATH ( cPatDat() ) FILE "TIVA.DBF"        VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

      DATABASE NEW ::oDivisas PATH ( cPatDat() ) FILE "DIVISAS.DBF"     VIA ( cDriver() ) SHARED INDEX "DIVISAS.CDX"

      DATABASE NEW ::oPedCliT PATH ( cPatEmp() ) FILE "PEDCLIT.DBF"     VIA ( cDriver() ) SHARED INDEX "PEDCLIT.CDX"

      DATABASE NEW ::oPedCliI PATH ( cPatEmp() ) FILE "PEDCLII.DBF"     VIA ( cDriver() ) SHARED INDEX "PEDCLII.CDX"

      DATABASE NEW ::oPedCliE PATH ( cPatEmp() ) FILE "PEDCLIE.DBF"     VIA ( cDriver() ) SHARED INDEX "PEDCLIE.CDX"

      DATABASE NEW ::oPedCliL PATH ( cPatEmp() ) FILE "PEDCLIL.DBF"     VIA ( cDriver() ) SHARED INDEX "PEDCLIL.CDX"

      DATABASE NEW ::oCount   PATH ( cPatEmp() ) FILE "NCOUNT.DBF"      VIA ( cDriver() ) SHARED INDEX "NCOUNT.CDX"

      DATABASE NEW ::oFPago   PATH ( cPatEmp() ) FILE "FPAGO.DBF"       VIA ( cDriver() ) SHARED INDEX "FPAGO.CDX"

      DATABASE NEW ::oFab     PATH ( cPatArt() ) FILE "FABRICANTES.DBF" VIA ( cDriver() ) SHARED INDEX "FABRICANTES.CDX"

      DATABASE NEW ::oKit     PATH ( cPatArt() ) FILE "ARTKIT.DBF"      VIA ( cDriver() ) SHARED INDEX "ARTKIT.Cdx"

      DATABASE NEW ::oAlbCliT PATH ( cPatEmp() ) FILE "ALBCLIT.DBF"     VIA ( cDriver() ) SHARED INDEX "ALBCLIT.CDX"

      DATABASE NEW ::oAlbCliL PATH ( cPatEmp() ) FILE "ALBCLIL.DBF"     VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

      DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) FILE "FACCLIL.DBF"     VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

      DATABASE NEW ::oFacRecL PATH ( cPatEmp() ) FILE "FACRECL.DBF"     VIA ( cDriver() ) SHARED INDEX "FACRECL.CDX"

      DATABASE NEW ::oTikCliL PATH ( cPatEmp() ) FILE "TIKEL.DBF"       VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

      DATABASE NEW ::oProLin  PATH ( cPatEmp() ) FILE "PROLIN.DBF"      VIA ( cDriver() ) SHARED INDEX "PROLIN.CDX"

      DATABASE NEW ::oProMat  PATH ( cPatEmp() ) FILE "PROMAT.DBF"      VIA ( cDriver() ) SHARED INDEX "PROMAT.CDX"

      DATABASE NEW ::oHisMov  PATH ( cPatEmp() ) FILE "HISMOV.DBF"      VIA ( cDriver() ) SHARED INDEX "HISMOV.CDX"

      DATABASE NEW ::oPedPrvL PATH ( cPatEmp() ) FILE "PEDPROVL.DBF"    VIA ( cDriver() ) SHARED INDEX "PEDPROVL.CDX"

      DATABASE NEW ::oAlbPrvT PATH ( cPatEmp() ) FILE "ALBPROVT.DBF"    VIA ( cDriver() ) SHARED INDEX "ALBPROVT.CDX"

      DATABASE NEW ::oAlbPrvL PATH ( cPatEmp() ) FILE "ALBPROVL.DBF"    VIA ( cDriver() ) SHARED INDEX "ALBPROVL.CDX"

      DATABASE NEW ::oFacPrvL PATH ( cPatEmp() ) FILE "FACPRVL.DBF"     VIA ( cDriver() ) SHARED INDEX "FACPRVL.CDX"

      DATABASE NEW ::oRctPrvL PATH ( cPatEmp() ) FILE "RCTPRVL.DBF"     VIA ( cDriver() ) SHARED INDEX "RCTPRVL.CDX"

      DATABASE NEW ::oArtImg  PATH ( cPatArt() ) FILE "ARTIMG.DBF"      VIA ( cDriver() ) SHARED INDEX "ARTIMG.CDX"

      DATABASE NEW ::oPreCliT PATH ( cPatEmp() ) FILE "PRECLIT.DBF"     VIA ( cDriver() ) SHARED INDEX "PRECLIT.CDX"

      DATABASE NEW ::oPreCliL PATH ( cPatEmp() ) FILE "PRECLIL.DBF"     VIA ( cDriver() ) SHARED INDEX "PRECLIL.CDX"

      DATABASE NEW ::oPreCliI PATH ( cPatEmp() ) FILE "PRECLII.DBF"     VIA ( cDriver() ) SHARED INDEX "PRECLII.CDX"

      DATABASE NEW ::oPreCliE PATH ( cPatEmp() ) FILE "PRECLIE.DBF"     VIA ( cDriver() ) SHARED INDEX "PRECLIE.CDX"

      ::TPrestashopId         := TPrestashopId():New()
      if !::TPrestashopId:OpenFiles()
         lOpen                := .f.
      end if

      ::oStock                := TStock():Create( cPatGrp() )
      if !::oStock:lOpenFiles()
         lOpen                := .f.
      end if

   RECOVER USING oError

      lOpen                   := .f.

      msgStop( ErrorMessage( oError ), 'Imposible abrir las bases de datos' )      
      
      ::filesClose()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD filesClose() CLASS TComercio

   if !empty( ::oArt ) .and. ::oArt:Used()
      ::oArt:End()
   end if

   if !empty( ::oPro ) .and. ::oPro:Used()
      ::oPro:End()
   end if

   if !empty( ::oTblPro ) .and. ::oTblPro:Used()
      ::oTblPro:End()
   end if

   if !empty( ::oFam ) .and. ::oFam:Used()
      ::oFam:End()
   end if

   if !empty( ::oGrpFam ) .and. ::oGrpFam:Used()
      ::oGrpFam:End()
   end if

   if !empty( ::oTipArt ) .and. ::oTipArt:Used()
      ::oTipArt:End()
   end if

   if !empty( ::oCli ) .and. ::oCli:Used()
      ::oCli:End()
   end if

   if !empty( ::oFPago ) .and. ::oFPago:Used()
      ::oFPago:End()
   end if

   if !empty( ::oObras ) .and. ::oObras:Used()
      ::oObras:End()
   end if

   if !empty( ::oArtDiv ) .and. ::oArtDiv:Used()
      ::oArtDiv:End()
   end if

   if !empty( ::oIva ) .and. ::oIva:Used()
      ::oIva:End()
   end if

   if !empty( ::oDivisas ) .and. ::oDivisas:Used()
      ::oDivisas:End()
   end if

   if !empty( ::oPedCliT ) .and. ::oPedCliT:Used()
      ::oPedCliT:End()
   end if

   if !empty( ::oPedCliI ) .and. ::oPedCliI:Used()
      ::oPedCliI:End()
   end if

   if !empty( ::oPedCliL ) .and. ::oPedCliL:Used()
      ::oPedCliL:End()
   end if

   if !empty( ::oCount ) .and. ::oCount:Used()
      ::oCount:End()
   end if

   if !empty( ::oFab ) .and. ::oFab:Used()
      ::oFab:End()
   end if

   if !empty( ::oKit ) .and. ::oKit:Used()
      ::oKit:End()
   end if

   if !empty( ::oAlbCliT ) .and. ::oAlbCliT:Used()
      ::oAlbCliT:End()
   end if

   if !empty( ::oAlbCliL ) .and. ::oAlbCliL:Used()
      ::oAlbCliL:End()
   end if

   if !empty( ::oFacCliL ) .and. ::oFacCliL:Used()
      ::oFacCliL:End()
   end if

   if !empty( ::oFacRecL ) .and. ::oFacRecL:Used()
      ::oFacRecL:End()
   end if

   if !empty( ::oTikCliL ) .and. ::oTikCliL:Used()
      ::oTikCliL:End()
   end if

   if !empty( ::oProLin ) .and. ::oProLin:Used()
      ::oProLin:End()
   end if

   if !empty( ::oProMat ) .and. ::oProMat:Used()
      ::oProMat:End()
   end if

   if !empty( ::oHisMov ) .and. ::oHisMov:Used()
      ::oHisMov:End()
   end if

   if !empty( ::oPedPrvL ) .and. ::oPedPrvL:Used()
      ::oPedPrvL:End()
   end if

   if !empty( ::oAlbPrvT ) .and. ::oAlbPrvT:Used()
      ::oAlbPrvT:End()
   end if

   if !empty( ::oAlbPrvL ) .and. ::oAlbPrvL:Used()
      ::oAlbPrvL:End()
   end if

   if !empty( ::oFacPrvL ) .and. ::oFacPrvL:Used()
      ::oFacPrvL:End()
   end if

   if !empty( ::oRctPrvL ) .and. ::oRctPrvL:Used()
      ::oRctPrvL:End()
   end if

   if !empty( ::oArtImg ) .and. ::oArtImg:Used()
      ::oArtImg:End()
   end if

   if !empty(::oPreCliT ) .and. ::oPreCliT:Used()
      ::oPreCliT:End()
   end if 

   if !empty( ::oOferta ) .and. ::oOferta:Used()
      ::oOferta:End()
   end if

   if !empty( ::TPrestashopId ) 
      ::TPrestashopId:End()
   end if

   if !empty(::oStock)
      ::oStock:End()
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD dialogActivate( oWnd ) CLASS TComercio

   DEFAULT  oWnd        := oWnd()

   ::lSyncAll           := .t.
   ::nLevel             := nLevelUsr( "01108" )

   if nAnd( ::nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      return ( Self )
   end if

   if oWnd != nil
      SysRefresh(); oWnd:CloseAll(); SysRefresh()
   end if

   /*
   Apertura del fichero de texto---------------------------------------------//
   */

   DEFINE DIALOG     ::oDlg ;
      RESOURCE       "Comercio_0"

      REDEFINE BITMAP ::oBmp ;
         ID          500 ;
         RESOURCE    "earth2_alpha_48" ;
         TRANSPARENT ;
         OF          ::oDlg

      // Web---------------------------------------------------------------------- 

      ::dialogCreateWebCombobox( 110, ::oDlg )

      // Tree---------------------------------------------------------------------

      ::oTree           := TTreeView():Redefine( 200, ::oDlg )

      REDEFINE SAY ::oTextTotal PROMPT ::cTextTotal ID 210 OF ::oDlg

      ::oMeterTotal     := TApoloMeter():ReDefine( 220, { | u | if( pCount() == 0, ::nMeterTotal, ::nMeterTotal := u ) }, 10, ::oDlg, .f., , , .t., rgb( 255,255,255 ), , rgb( 128,255,0 ) )

      ::oMeterProceso   := TApoloMeter():ReDefine( 230, { | u | if( pCount() == 0, ::nMeterProceso, ::nMeterProceso := u ) }, 10, ::oDlg, .f., , , .t., rgb( 255,255,255 ), , rgb( 128,255,0 ) )

      /*
      Botones exportación------------------------------------------------------
      */

      REDEFINE BUTTONBMP ::oBtnExportar ;
         ID       510 ;
         OF       ::oDlg;
         ACTION   ( ::controllerExportPrestashop() ) 

      REDEFINE BUTTONBMP ::oBtnImportar ;
         ID       520 ;
         OF       ::oDlg;
         ACTION   ( ::controllerOrderPrestashop() )

      REDEFINE BUTTONBMP ::oBtnStock ;
         ID       530 ;
         OF       ::oDlg;
         ACTION   ( ::controllerUpdateStockPrestashop() )

      REDEFINE BUTTON ::oBtnCancel ;
         ID       IDCANCEL ;
         OF       ::oDlg ;
         ACTION   ( ::oDlg:end() )

      ::oDlg:AddFastKey( VK_F5, {|| ::controllerExportPrestashop() } )

      ::oDlg:bStart := {|| ::dialogStart() }

   ACTIVATE DIALOG ::oDlg CENTER

   /*
   Liberamos la imagen---------------------------------------------------------
   */

   ::oBmp:End()

Return ( self )

//------------------------------------------------------------------------//

METHOD dialogCreateWebCombobox( id, oDlg ) CLASS TComercio

   REDEFINE COMBOBOX ::oComboWebToExport ;
      VAR         ::cWebToExport ;
      ITEMS       ::TPrestashopConfig:getWebsNames() ;
      ID          id ;
      OF          oDlg

Return ( self )

//------------------------------------------------------------------------//

METHOD dialogStart() CLASS TComercio

   if ::TPrestashopConfig:getHideExportButton()
      ::oBtnExportar:Hide()
   else
      ::oBtnExportar:Show()
   end if

Return nil

//---------------------------------------------------------------------------//

METHOD MeterTotalText( cText ) Class TComercio

   DEFAULT cText  := ""

   ::writeText( cText )

   if !empty( ::oMeterTotal )
      ::oMeterTotal:Set( ++::nMeterTotal )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD MeterTotalSetTotal( nTotal ) Class TComercio

   if !empty( ::oMeterTotal )
      ::oMeterTotal:SetTotal( nTotal )
   end if

   if !empty( ::oWaitMeter )
      ::oWaitMeter:setTotalMeter( nTotal )
   end if

   ::nMeterTotal     := 1

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD meterProcesoText( cText ) Class TComercio

   DEFAULT cText     := ""

   ::writeText( cText )

   if !empty( ::oMeterProceso )
      ::oMeterProceso:Set( ++::nMeterProceso )
   end if

   if !empty( ::oWaitMeter )
      ::oWaitMeter:setMeter( ++::nMeterProceso )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD meterProcesoSetTotal( nTotal ) Class TComercio

   if !empty( ::oMeterProceso )
      ::oMeterProceso:setTotal( nTotal )
   end if

   if !empty( ::oWaitMeter )
      ::oWaitMeter:setTotalMeter( nTotal )
   end if

   ::nMeterProceso   := 1

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD controllerOrderPrestashop() CLASS TComercio

   local oBlock
   local oError

   if !( ::isAviableWebToExport() )
      Return .f.
   end if 

   ::disableDialog()

   oBlock            := ErrorBlock( { | oError | Break( oError ) } )
   BEGIN SEQUENCE

   if ::filesOpen()

      ::MeterTotalText( "Conectando con la base de datos" )

      if ::prestaShopConnect()

         ::MeterTotalText( "Descargando pedidos de prestashop" )

         ::loadOrders()

         // Desconectamos mysql------------------------------------------------

         ::MeterTotalText( "Desconectando bases de datos." )

         ::prestashopDisConnect()  
      
      end if  

      ::filesClose()

   end if 

   RECOVER USING oError
   
      msgStop( ErrorMessage( oError ), "Error en modulo Prestashop." )
   
   END SEQUENCE
   ErrorBlock( oBlock )

   ::EnableDialog()

Return .t.

//---------------------------------------------------------------------------//

METHOD loadOrders() CLASS TComercio

   local oQuery
   local cQuery
   local dStar             := ::TPrestashopConfig():getDateStart()

   ::nMeterProceso         := 0

   cQuery                  := 'SELECT * FROM ' + ::cPrefixTable( "orders" ) + " "
   if !empty( dStar )
      cQuery               += 'WHERE date_add >= "' + dStar + '"'
   end if 

   oQuery                  := TMSQuery():New( ::oCon, cQuery )    
   if oQuery:Open() .and. oQuery:recCount() > 0

      ::setMeterTotal( oQuery:recCount() )

      ::writeText( "Descargando pedidos desde la web", 2 )

      oQuery:GoTop()
      while !oQuery:Eof()

         ::processOrder( oQuery )

         oQuery:Skip()

      end while

   end if

   oQuery:Free()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD processOrder( oQuery ) CLASS TComercio

   if empty( oQuery )
      return .f.
   end if 

   if !::checkDate( oQuery:FieldGetByName( "date_add" ) )
      return .f.
   end if 

   if ::isRecivedDocumentAsBudget( oQuery:FieldGetByName( "module" ) )

      ::meterProcesoText( "Descargando presupuesto " + alltrim( str( ++::nMeterProceso ) ) + " de "  + alltrim( str( ::nTotMeter ) ) )

      ::TComercioBudget:insertDocumentInGestoolIfNotExist( oQuery )
      
   else

      ::meterProcesoText( "Descargando pedido " + alltrim( str( ++::nMeterProceso ) ) + " de "  + alltrim( str( ::nTotMeter ) ) )

      ::TComercioOrder:insertDocumentInGestoolIfNotExist( oQuery )

   endif

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD AppendIvaPrestashop() Class TComercio

Return ( Self )

//---------------------------------------------------------------------------//

METHOD InsertIvaPrestashop() CLASS TComercio

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD lUpdateIvaPrestashop( nId ) CLASS TComercio

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD DelIdFamiliasPrestashop() Class TComercio

   local nRec  := ::oFam:Recno()

   ::oFam:GoTop()

   while !::oFam:Eof()

      ::TPrestashopId:deleteValueCategory( ::oFam:cCodFam, ::getCurrentWebName() )

      ::writeText( 'Eliminando código web en la familia ' + alltrim( ::oFam:cNomFam ), 3  )

      ::oFam:Skip()

   end while

   ::oFam:GoTo( nRec )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD insertRootCategory() CLASS TComercio

   local cCommand := ""

   /*
   Insertamos el root en la tabla de categorias------------------------------
   */

   ::writeText( "Añadiendo categoría raiz" )

   cCommand       := "INSERT INTO " + ::cPrefixTable( "category" ) + " ( id_category, id_parent, id_shop_default, level_depth, nleft, nright, active, date_add, date_upd, position ) VALUES ( '1', '0', '1', '0', '0', '0', '1', '" + dtos( GetSysDate() ) + "', '" + dtos( GetSysDate() ) + "', '0' ) "

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::nNumeroCategorias++
      ::writeText( "He insertado correctamente en la tabla categorías la categoría raiz", 3 )
   else
      ::writeText( "Error al insertar la categoría raiz", 3 )
   end if

   cCommand       := "INSERT INTO " + ::cPrefixTable( "category_lang" ) + " ( id_category, id_lang, name, description, link_rewrite, meta_title, meta_keywords, meta_description ) VALUES ( '1', '" + str( ::nLanguage ) + "', 'Root', 'Root', 'Root', '', '', '' )"

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( "He insertado correctamente en la tabla categorias lenguajes la categoría raiz", 3 )
   else
      ::writeText( "Error al insertar la categoría raiz", 3 )
   end if

   cCommand       := "INSERT INTO " + ::cPrefixTable( "category_shop" ) + " ( id_category, id_shop, position ) VALUES ( '1', '1', '0' )"

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( "He insertado correctamente en la tabla categorias grupo la categoría raiz", 3 )
   else
      ::writeText( "Error al insertar la categoría raiz", 3 )
   end if

   cCommand       := "INSERT INTO " + ::cPrefixTable( "category_group" ) + " ( id_category, id_group ) VALUES ( '1', '1' )"

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( "He insertado correctamente en la tabla categorias grupo la categoría raiz", 3 )
   else
      ::writeText( "Error al insertar la categoría raiz", 3 )
   end if

   cCommand       := "INSERT INTO " + ::cPrefixTable( "category_group" ) + " ( id_category, id_group ) VALUES ( '1', '2' )"

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( "He insertado correctamente en la tabla categorias grupo la categoría raiz", 3 )
   else
      ::writeText( "Error al insertar la categoría raiz", 3 )
   end if

   cCommand       := "INSERT INTO " + ::cPrefixTable( "category_group" ) + " ( id_category, id_group ) VALUES ( '1', '3' )"

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( "He insertado correctamente en la tabla categorias grupo la categoría raiz", 3 )
   else
      ::writeText( "Error al insertar la categoría root en category_group", 3 )
   end if

   /*
   Metemos la categoría de inicio de la que colgarán los grupos y las categorias
   */

   cCommand       := "INSERT INTO " + ::cPrefixTable( "category" ) + " ( id_parent, id_shop_default, level_depth, nleft, nright, active, date_add, date_upd, position, is_root_category ) VALUES ( '1', '1', '1', '0', '0', '1', '" + dtos( GetSysDate() ) + "', '" + dtos( GetSysDate() ) + "', '0', '1' ) "

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::nNumeroCategorias++
      ::writeText( "He insertado correctamente en la tabla categorias la categoría raiz", 3 )
   else
      ::writeText( "Error al insertar la categoría inicio", 3 )
   end if

   cCommand       := "INSERT INTO " + ::cPrefixTable( "category_lang" ) + " ( id_category, id_lang, name, description, link_rewrite, meta_title, meta_keywords, meta_description ) VALUES ( '2', '" + str( ::nLanguage ) + "', 'Inicio', 'Inicio', 'Inicio', '', '', '' )"

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( "He insertado correctamente en la tabla categorias lenguajes la categoría raiz", 3 )
   else
      ::writeText( "Error al insertar la categoría inicio", 3 )
   end if

   cCommand       := "INSERT INTO " + ::cPrefixTable( "category_shop" ) + " ( id_category, id_shop, position ) VALUES ( '2', '1', '0' )"

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( "He insertado correctamente en la tabla categorias grupo la categoría raiz", 3 )
   else
      ::writeText( "Error al insertar la categoría inicio", 3 )
   end if

   cCommand       := "INSERT INTO " + ::cPrefixTable( "category_group" ) + " ( id_category, id_group ) VALUES ( '2', '1' )"

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( "He insertado correctamente en la tabla categorias grupo la categoría raiz", 3 )
   else
      ::writeText( "Error al insertar la categoría inicio", 3 )
   end if

   cCommand       := "INSERT INTO " + ::cPrefixTable( "category_group" ) + " ( id_category, id_group ) VALUES ( '2', '2' )"

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( "He insertado correctamente en la tabla categorias grupo la categoría raiz", 3 )
   else
      ::writeText( "Error al insertar la categoría inicio", 3 )
   end if

   cCommand       := "INSERT INTO " + ::cPrefixTable( "category_group" ) + " ( id_category, id_group ) VALUES ( '2', '3' )"

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( "He insertado correctamente en la tabla categorias grupo la categoría raiz", 3 )
   else
      ::writeText( "Error al insertar la categoría inicio", 3 )
   end if

   SysRefresh()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD InsertImageProductPrestashop( hProduct, hImage, idProductPrestashop, nImagePosition )

   local cCommand
   local nIdImagePrestashop   := 0

   cCommand                   := "INSERT INTO " + ::cPrefixTable( "image" ) + " ( " +;
                                    "id_product, " + ;
                                    "position, " + ;
                                    "cover ) " + ;
                                 "VALUES ( " + ;
                                    "'" + alltrim( str( idProductPrestashop ) ) + "', " + ;
                                    "'" + str( nImagePosition ) + "', " + ;
                                    if( hGet( hImage, "lDefault" ), "'1'", "'0'" ) + " )"

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      nIdImagePrestashop     := ::oCon:GetInsertId()
      ::writeText( "Insertado la imagen " + hGet( hProduct, "name" ) + " correctamente en la tabla " + ::cPrefixTable( "image" ), 3 )
   else
      ::writeText( "Error al insertar la imagen " + hGet( hProduct, "name" ) + " en la tabla " + ::cPrefixTable( "image" ), 3 )
   end if

   if !empty( nIdImagePrestashop )
      ::TPrestashopId:setValueImage( hGet( hProduct, "id" ) + str( hGet( hImage, "id" ), 10 ), ::getCurrentWebName(), nIdImagePrestashop )
   end if

Return ( nIdImagePrestashop )

//---------------------------------------------------------------------------//

METHOD InsertImageProductPrestashopLang( hProduct, hImage, idImagenPrestashop )

   local cCommand

   cCommand := "INSERT INTO " + ::cPrefixTable( "image_lang" ) + " ( " +;
                  "id_image, " + ;
                  "id_lang, " + ;
                  "legend ) " + ;
               "VALUES (" + ;
                  "'" + alltrim( str( idImagenPrestashop ) ) + "', " + ;
                  "'" + alltrim( str( ::nLanguage ) ) + "', " + ;
                  "'" + ::oCon:Escapestr( hGet( hProduct, "name" ) ) + "' )"

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( "Insertado la imagen " + hGet( hProduct, "name" ) + " correctamente en la tabla " + ::cPrefixTable( "image_lang" ), 3 )
   else
      ::writeText( "Error al insertar la imagen " + hGet( hProduct, "name" ) + " en la tabla " + ::cPrefixTable( "image_lang" ), 3 )
   end if

Return .t.

//---------------------------------------------------------------------------//

METHOD InsertImageProductPrestashopShop( hProduct, hImage, idProductPrestashop, idImagenPrestashop )

   local cCommand 
   local cNullCover     := "'0'"

   if ::lProductIdColumnImageShop
      cNullCover        := "null"
   end if 

   cCommand             := "INSERT INTO " + ::cPrefixTable( "image_shop" ) + " ( "  + ;
                              if( ::lProductIdColumnImageShop, "id_product, ", "" ) + ;
                              "id_image, "                                          + ;
                              "id_shop, "                                           + ;
                              "cover ) "                                            + ;
                           "VALUES ( "                                              + ;
                              if( ::lProductIdColumnImageShop, "'" + alltrim( str( idProductPrestashop ) ) + "', ", "" ) + ;  // id_product
                              "'" + alltrim( str( idImagenPrestashop ) ) + "', "    + ;      // id_image
                              "'1', "                                               + ;      // id_shop
                              if( hGet( hImage, "lDefault" ), "'1'", "'0'" ) + ")"           // cover

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( "Insertado la imagen " + hGet( hProduct, "name" ) + " correctamente en la tabla " + ::cPrefixTable( "image_shop" ), 3 )
   else
      ::writeText( "Error al insertar la imagen " + hGet( hProduct, "name" ) + " en la tabla " + ::cPrefixTable( "image_shop" ), 3 )
   end if

Return .t.

//---------------------------------------------------------------------------//

METHOD nIvaProduct( cCodArt ) Class TComercio

   local nIva        := 0
   local oQuery
   local cCommand    := ""
   
   cCommand          := 'SELECT * FROM ' + ::cPrefixTable( "tax" ) + ;
                        ' INNER JOIN ' + ::cPreFixTable( "tax_rule" ) + ' ON ' + ::cPrefixTable( "tax" ) + '.id_tax = ' + ::cPrefixTable( "tax_rule" ) + '.id_tax ' +; 
                        ' INNER JOIN ' + ::cPrefixTable( "product" ) + ' ON ' + ::cPrefixTable( "tax_rule" ) + '.id_tax_rules_group = ' + ::cPrefixTable( "product" ) + '.id_tax_rules_group ' + ;
                        ' WHERE ' + ::cPrefixTable( "product" ) + '.id_product = ' + alltrim( str( cCodArt ) )

   oQuery            := TMSQuery():New( ::oCon, cCommand )

   if oQuery:Open() .and. oQuery:RecCount() > 0
      oQuery:GoTop()
      nIva           := oQuery:FieldGetByName( "rate" )
   end if

Return ( nIva )

//---------------------------------------------------------------------------//

METHOD DelIdArticuloPrestashop( hProduct ) Class TComercio

   local nRec  := ::oArt:Recno()

   ::oArt:GoTop()

   while !::oArt:Eof()

      ::TPrestashopId:deleteDocumentValues( hget( hProduct, "id" ), ::getCurrentWebName() ) 

      ::writeText( 'Eliminando código web en el artículo ' + alltrim( ::oArt:Nombre ), 3  )

      SysRefresh()
      ::oArt:Skip()

   end while

   ::oArt:GoTo( nRec )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD buildImagenes() CLASS TComercio

   local oFile
   local oImage
   local cNewImg           := ""
   local cCarpeta          := ""
   local oTipoImage
   local oImagenFinal

   ::aImagesCategories     := {}
   ::aImagesArticulos      := {}

   CursorWait()

   /*
   Recogemos los tipos de imagenes---------------------------------------------
   */

   ::meterProcesoSetTotal( len( ::aImages ) )

   /*
   Cargamos creamos las imagenes a subir---------------------------------------
   */

   for each oImage in ::aImages

      ::meterProcesoText( "Elaborando imagen " + alltrim(str(hb_enumindex())) + " de "  + alltrim(str(len(::aImages))) )

      // Metemos primero la imagen que no lleva tipo------------------------------

      do case
         case oImage:nTipoImagen == tipoProducto

            cNewImg                       := cPatTmp() + oImage:cPrefijoNombre + ".jpg"

            saveImage( oImage:cNombreImagen, cNewImg )

            oImagenFinal                  := SImagen()
            oImagenFinal:cNombreImagen    := cNewImg
            oImagenFinal:nTipoImagen      := oImage:nTipoImagen
            oImagenFinal:cCarpeta         := oImage:cCarpeta

            ::AddImagesArticulos( oImagenFinal )

         case oImage:nTipoImagen == tipoCategoria

            cNewImg                       := cPatTmp() + oImage:cPrefijoNombre + ".jpg"

            saveImage( oImage:cNombreImagen, cNewImg )

            oImagenFinal                  := SImagen()
            oImagenFinal:cNombreImagen    := cNewImg
            oImagenFinal:nTipoImagen      := oImage:nTipoImagen

            ::AddImagesCategories( oImagenFinal )

      end case

      /*
      Metemos las imagenes por tipo--------------------------------------------
      */

      for each oTipoImage in ::aTypeImagesPrestashop

         do case
            case oImage:nTipoImagen == tipoProducto .and. oTipoImage:lProducts

               cNewImg                       := cPatTmp() + oImage:cPrefijoNombre + "-" + oTipoImage:cNombreTipo + ".jpg"

               SaveImage( oImage:cNombreImagen, cNewImg, oTipoImage:nAnchoTipo, oTipoImage:nAltoTipo )

               oImagenFinal                  := SImagen()
               oImagenFinal:cNombreImagen    := cNewImg
               oImagenFinal:nTipoImagen      := oImage:nTipoImagen
               oImagenFinal:cCarpeta         := oImage:cCarpeta

               ::AddImagesArticulos( oImagenFinal )

            case oImage:nTipoImagen == tipoCategoria .and. oTipoImage:lCategories

               cNewImg                       := cPatTmp() + oImage:cPrefijoNombre + "-" + oTipoImage:cNombreTipo + ".jpg"

               SaveImage( oImage:cNombreImagen, cNewImg, oTipoImage:nAnchoTipo, oTipoImage:nAltoTipo )

               oImagenFinal                  := SImagen()
               oImagenFinal:cNombreImagen    := cNewImg
               oImagenFinal:nTipoImagen      := oImage:nTipoImagen

               ::AddImagesCategories( oImagenFinal )

         end case

         SysRefresh()

      next

   next

Return( nil )

//---------------------------------------------------------------------------//

METHOD buildSubirImagenes() CLASS TComercio

   local oImage

   // Conectamos al FTP y Subimos las imágenes de artículos--------------------

   if len( ::aImagesArticulos ) > 0 .or. len( ::aImagesCategories ) > 0
      if !( ::oFtp:CreateConexion() )
         msgStop( "Imposible conectar al sitio ftp " + ::oFtp:cServer )
         Return ( nil )
      end if 
   end if 

   if Len( ::aImagesArticulos ) > 0

      // Subimos los ficheros de imagenes-----------------------------------

      ::meterProcesoSetTotal( len( ::aImagesArticulos ) )

      for each oImage in ::aImagesArticulos

         ::meterProcesoText( "Subiendo imagen " + oImage:cNombreImagen + " [" + alltrim(str(hb_enumindex())) + " de "  + alltrim(str(len(::aImagesArticulos))) + "]" )

         // Sube el fichero ------------------------------------------------

         ::oFtp:CreateFile( oImage:cNombreImagen, ::cDirectoryProduct() + "/" + ::getRecursiveFolderPrestashop( oImage:cCarpeta ) )
        
         SysRefresh()

      next

   end if 

   // Subimos las imagenes de las categories-----------------------------------

   if Len( ::aImagesCategories ) > 0

      // Subimos los ficheros de imagenes-----------------------------------

      ::meterProcesoSetTotal( len( ::aImagesCategories ) )

      for each oImage in ::aImagesCategories

         ::meterProcesoText( "Subiendo imagen categoría " + alltrim(str(hb_enumindex())) + " de "  + alltrim(str(len(::aImagesCategories))) )

         // Sube el fichero ------------------------------------------------

         ::oFtp:CreateFile( oImage:cNombreImagen, ::cDirectoryCategories() + "/" + ::getRecursiveFolderPrestashop( oImage:cCarpeta ) )
        
         SysRefresh()

      next

      // Borramos las imagenes creadas en los temporales-----------------------

      for each oImage in ::aImagesArticulos
         fErase( oImage:cNombreImagen )
      next

      for each oImage in ::aImagesCategories
         fErase( oImage:cNombreImagen )
      next

   end if 

   if !empty( ::oFtp )
      ::oFtp:EndConexion() 
   end if

   ::aImages               := {}

   CursorWe()

Return( nil )

//---------------------------------------------------------------------------//

METHOD uploadProductImages( aProductImages ) CLASS TComercio

   local cTypeImage
   local hProductImage

   if empty( aProductImages )
      Return ( nil )
   end if 

   CursorWait()

   // Subimos los ficheros de imagenes-----------------------------------

   ::meterProcesoSetTotal( len( aProductImages ) )

   for each hProductImage in aProductImages

      ::buildFilesProductImages( hProductImage )

      for each cTypeImage in hget( hProductImage, "aTypeImages" )

         ::meterProcesoText( "Subiendo imagen " + cTypeImage + " en directorio " + ::cDirectoryProduct() + "/" + ::getRecursiveFolderPrestashop( hget( hProductImage, "cCarpeta" ) ) )

         ::oFtp:CreateFile( cTypeImage, ::cDirectoryProduct() + "/" + ::getRecursiveFolderPrestashop( hget( hProductImage, "cCarpeta" ) ) )
    
         SysRefresh()

         ferase( cTypeImage )

         SysRefresh()

      next 

   next

   CursorWe()

Return ( nil )

//---------------------------------------------------------------------------//

METHOD buildFilesProductImages( hProductImage ) CLASS TComercio

   local oFile
   local oImage
   local rootImage
   local typeImage         := ""
   local cCarpeta          := ""
   local oTipoImage
   local oImagenFinal

   CursorWait()

   /*
   Cargamos creamos las imagenes a subir---------------------------------------
   */

   rootImage               := cPatTmp() + hget( hProductImage, "cPrefijoNombre" ) + ".jpg"

   saveImage( hget( hProductImage, "name" ), rootImage )

   for each oTipoImage in ::aTypeImagesPrestashop

      if hget( hProductImage, "nTipoImagen" ) == tipoProducto .and. oTipoImage:lProducts

         typeImage           := cPatTmp() + hget( hProductImage, "cPrefijoNombre" ) + "-" + oTipoImage:cNombreTipo + ".jpg"

         saveImage( rootImage, typeImage, oTipoImage:nAnchoTipo, oTipoImage:nAltoTipo )

         aadd( hget( hProductImage, "aTypeImages" ), typeImage )

         SysRefresh()

      end if 

   next

   CursorWe()

Return( nil )

//---------------------------------------------------------------------------//

METHOD getTypeImagePrestashop() CLASS TComercio

   local oQuery            
   local cQuery
   local oImagen
   local aTypeImagesPrestashop   := {}

   if !empty( ::aTypeImagesPrestashop )
      Return ( ::aTypeImagesPrestashop )
   end if 

   cQuery                        := 'SELECT * FROM ' + ::cPrefixTable( "image_type" )
   oQuery                        := TMSQuery():New( ::oCon, cQuery )
   if oQuery:Open()

      if oQuery:RecCount() > 0

         oQuery:GoTop()

         while !oQuery:Eof()

            oImagen                       := STipoImagen()
            oImagen:cNombreTipo           := oQuery:FieldGetByName( "name" )
            oImagen:nAnchoTipo            := oQuery:FieldGetByName( "width" )
            oImagen:nAltoTipo             := oQuery:FieldGetByName( "height" )
            oImagen:lCategories           := ( oQuery:FieldGetByName( "categories" ) == 1 )
            oImagen:lProducts             := ( oQuery:FieldGetByName( "products" ) == 1 )
            oImagen:lManufactures         := ( oQuery:FieldGetByName( "manufacturers" ) == 1 )
            oImagen:lSuppliers            := ( oQuery:FieldGetByName( "suppliers" ) == 1 )
            oImagen:lScenes               := ( oQuery:FieldGetByName( "scenes" ) == 1 )
            oImagen:lStores               := ( oQuery:FieldGetByName( "stores" ) == 1 )

            aadd( aTypeImagesPrestashop, oImagen )

            oQuery:Skip()

            SysRefresh()

         end while

      end if

   else 

      ::writeText( "Error al ejecutar la sentencia " + cQuery, 3 )

   end if

   oQuery:Free()

   oQuery            := nil

Return ( aTypeImagesPrestashop )

//---------------------------------------------------------------------------//

METHOD nDefImagen( cCodArt, cImagen ) CLASS TComercio

   local nDef           := 0

   if ::oArtImg:SeekInOrd( cCodArt, "lDefImg" )

      if ::oArtImg:cImgArt == cImagen

         nDef           := 1

      end if

   else

      if !::lDefImgPrp

         nDef           := 1

         ::lDefImgPrp   := .t.

      end if

   end if

Return nDef

//---------------------------------------------------------------------------//

METHOD lLimpiaRefImgWeb() CLASS TComercio

   local nRec     := ::oArtDiv:Recno()
   local nOrdAnt  := ::oArtDiv:OrdSetFocus( "cCodArt" )

   ::oArtDiv:GoTop()

   while !::oArtDiv:Eof()

      if ::oArtDiv:cCodImgWeb != 0
         ::oArtDiv:fieldPutByName( "cCodImgWeb", 0 )
      end if   

      ::oArtDiv:Skip()

   end while

   ::oArtDiv:OrdSetFocus( nOrdAnt )
   ::oArtDiv:GoTo( nRec )

return .t.

//-----------------------------------------------------------------------------

METHOD nCodigoWebImagen( cCodArt, cImagen ) CLASS TComercio

   local nCodigo  := 0
   local nRec     := ::oArtDiv:Recno()
   local nOrdAnt  := ::oArtDiv:OrdSetFocus( "cCodArt" )

   ::oArtDiv:GoTop()

   if ::oArtDiv:Seek( cCodArt )

      while ::oArtDiv:cCodArt == cCodArt .and. !::oArtDiv:Eof()

         if ::oArtDiv:cImgWeb == cImagen .and. ::oArtDiv:cCodImgWeb != 0

            nCodigo  := ::oArtDiv:cCodImgWeb

         end if

         ::oArtDiv:Skip()

      end while

   end if

   ::oArtDiv:OrdSetFocus( nOrdAnt )
   ::oArtDiv:GoTo( nRec )

return nCodigo

//---------------------------------------------------------------------------//

METHOD ConectBBDD() Class TComercio

Return ( .f. )

//---------------------------------------------------------------------------//

METHOD DisconectBBDD() Class TComercio

   if !empty( ::oCon )
      ::oCon:Destroy()
   end if

Return .t.  

//---------------------------------------------------------------------------//

METHOD isProductIdColumn( cTable, cColumn )

   local oQuery
   local cCommand       
   local isProduct      := .f.

   DEFAULT cTable       := "image_shop"
   DEFAULT cColumn      := "id_product"

   cCommand             := "SHOW COLUMNS FROM " + ::cPrefixTable( cTable ) + " LIKE '" +  cColumn + "'"

   oQuery               := TMSQuery():New( ::oCon, cCommand )

   if oQuery:Open()
      isProduct         := oQuery:RecCount() > 0
   end if

   if !empty( oQuery )
      oQuery:Free()
   end if   

Return ( isProduct )

//---------------------------------------------------------------------------//

METHOD AvisoSincronizaciontotal() CLASS TComercio

   msginfo( "Faltan Avisar de que necesita una sincronización total" )

Return .t.

//---------------------------------------------------------------------------//

METHOD cPreFixtable( cName ) Class TComercio

Return ( ::TPrestashopConfig:getPrefixDatabase() + alltrim( cName ) )

//---------------------------------------------------------------------------//

METHOD AutoRecive( oWnd ) CLASS TComercio

Return Nil

//---------------------------------------------------------------------------//

METHOD GetLanguagePrestashop() CLASS TComercio

   local oQuery
   local cCodLanguage

   oQuery               := TMSQuery():New( ::oCon, 'SELECT * FROM ' + ::cPrefixTable( "lang" ) +  ' WHERE active = 1' )

   if oQuery:Open() .and. oQuery:RecCount() > 0
      cCodLanguage   := oQuery:FieldGet( 1 )
   end if

   if !empty( oQuery )
      oQuery:Free()
   end if   

Return if( !empty( cCodLanguage ), cCodLanguage, 1 )

//---------------------------------------------------------------------------//

METHOD GetValPrp( nIdPrp, nProductAttibuteId ) CLASS TComercio

   local oQuery1
   local oQuery2
   local nIdAttribute
   local nIdAttributeGroup
   local cValPrp                 := ""

   oQuery1                       := TMSQuery():New( ::oCon, 'SELECT * FROM ' + ::cPrefixTable( "product_attribute_combination" ) + ' where id_product_attribute = ' + alltrim( str( nProductAttibuteId ) ) )

   if oQuery1:Open()

      /*
      Recorremos el Query con la consulta-----------------------------------------
      */

      if oQuery1:RecCount() > 0

         oQuery1:GoTop()

         while !oQuery1:Eof()

         nIdAttribute            := oQuery1:FieldGet( 1 )

         oQuery2                 := TMSQuery():New( ::oCon, 'SELECT * FROM ' + ::cPrefixTable( "attribute" ) + ' where id_attribute=' + alltrim( str( nIdAttribute ) ) )

         if oQuery2:Open()

            if oQuery2:RecCount() > 0

               nIdAttributeGroup := oQuery2:FieldGet( 2 )

               if nIdAttributeGroup == nIdPrp

                  if ::oTblPro:SeekInOrd( str( nIdAttribute, 11 ), "cCodWeb" )

                     cValPrp     := ::oTblPro:cCodTbl

                  end if

               end if

            end if

         end if

         oQuery1:Skip()

         end while

      end if

   end if

   oQuery1:Free()

return cValPrp

//---------------------------------------------------------------------------//
//
// Deprecated no usar

METHOD AppendClientesToPrestashop() CLASS TComercio

   local nCodigoWeb  := 0
   local nSpace      := 0
   local cFirstName  := ""
   local cLastName   := ""

   ::writeText( "Recorremos la tabla de clientes", 2 )

   /*
   Añadimos familias a prestashop----------------------------------------------
   */

   ::oCli:GoTop()

   while !::oCli:Eof()

      if ::oCli:lPubInt .and. ::oCli:lSndInt

         if !::oCli:lWeb

            if ::oCli:cCodWeb == 0

               nSpace               := At( " ", ::oCli:Titulo )
               cFirstName           := ::oCon:Escapestr( Substr( ::oCli:Titulo, 1, nSpace ) )
               cLastName            := ::oCon:Escapestr( Substr( ::oCli:Titulo, nSpace + 1 ) )

               if TMSCommand():New( ::oCon ):ExecDirect( "INSERT INTO " + ::cPrefixTable( "customer" ) + " ( id_gender, " + ;
                                                                                    "id_default_group, " + ;
                                                                                    "firstname, " + ;
                                                                                    "lastname, " + ;
                                                                                    "email, " + ;
                                                                                    "passwd, " + ;
                                                                                    "newsletter, " + ;
                                                                                    "secure_key, " + ;
                                                                                    "active, " + ;
                                                                                    "is_guest, " + ;
                                                                                    "deleted, " + ;
                                                                                    "date_add, " + ;
                                                                                    "date_upd )" + ;
                                                                           " VALUES " + ;
                                                                                    "('9', " + ;                                                         //id_gender, " - Genero desconocido
                                                                                    "'1', " + ;                                                          //"id_default_group, " + ;
                                                                                    "'" + ( cFirstName ) + "', " + ;                                     //"firstname, " + ;
                                                                                    "'" + ( cLastName ) + "', " + ;                                      //"lastname, " + ;
                                                                                    "'" + ::oCon:Escapestr( ::oCli:cMeiInt ) + "', " + ;                 //"email, " + ;
                                                                                    "'" + hb_md5( alltrim( ::TPrestashopConfig:getCookieKey() ) + alltrim( ::oCli:cClave ) ) + "', " + ;   //"passwd, " + ;
                                                                                    "'1', " + ;                                                          //"newletter, " + ;
                                                                                    "'" + hb_md5( alltrim( ::oCli:Cod ) ) + "', " + ;                    //"secure_key, " + ;
                                                                                    "'1', " + ;                                                          //"active, " + ;
                                                                                    "'0', " + ;                                                          //"is_guest, " + ;
                                                                                    "'0', " + ;                                                          //"deleted, " + ;
                                                                                    "'" + dtos( GetSysDate() ) + "', " + ;                               //"date_add )" + ;
                                                                                    "'" + dtos( GetSysDate() ) + "' )" )                                 //"date_upd )" + ;

                  nCodigoWeb           := ::oCon:GetInsertId()

                  ::oCli:fieldPutByName( "cCodWeb", nCodigoWeb )

                  ::writeText( "He insertado el cliente " + alltrim( ::oCli:Titulo ) + " correctamente en la tabla customer", 3 )

               else
                  ::writeText( "Error al insertar el cliente " + alltrim( ::oCli:Titulo ) + " en la tabla customer", 3 )
               end if

               /*
               Insertamos en la tabla customer_group------------------------
               */

               if TMSCommand():New( ::oCon ):ExecDirect( "INSERT INTO " + ::cPrefixTable( "customer_group" ) + " ( id_customer, " + ;
                                                                                          "id_group )" + ;
                                                                                 " VALUES " + ;
                                                                                           "('" + alltrim( str( nCodigoWeb ) ) + "', " + ;
                                                                                           "'1' )" )

                  ::writeText( "He insertado el cliente " + alltrim( ::oCli:Titulo ) + " correctamente en la tabla customer_group", 3 )

               else
                  ::writeText( "Error al insertar el cliente " + alltrim( ::oCli:Titulo ) + " en la tabla customer_group", 3 )
               end if

               /*
               Insertamos en la tabla address------------------------
               */

               if TMSCommand():New( ::oCon ):ExecDirect( "INSERT INTO " + ::cPrefixTable( "address" ) + " ( id_country, " + ;
                                                                                  "id_customer, " + ;
                                                                                  "alias, " + ;
                                                                                  "lastname, " + ;
                                                                                  "firstname, " + ;
                                                                                  "address1, " + ;
                                                                                  "postcode, " + ;
                                                                                  "city, " + ;
                                                                                  "phone, " + ;
                                                                                  "phone_mobile, " + ;
                                                                                  "dni, " + ;
                                                                                  "date_add, " + ;
                                                                                  "date_upd, " + ;
                                                                                  "active, " + ;
                                                                                  "deleted )" + ;
                                                                         " VALUES " + ;
                                                                                  "('6', " + ;                                                   //id_country
                                                                                  "'" + alltrim( str( nCodigoWeb ) ) + "', " + ;                 //id_customer
                                                                                  "'" + cFirstName + cLastName  + "', " + ; //alias
                                                                                  "'" + alltrim( cLastName ) + "', " + ;                         //lastname
                                                                                  "'" + alltrim( cFirstName ) + "', " + ;                        //firstname
                                                                                  "'" + ::oCon:Escapestr( ::oCli:Domicilio ) + "', " + ;                  //address1
                                                                                  "'" + ::oCon:Escapestr( ::oCli:CodPostal ) + "', " + ;                  //postcode
                                                                                  "'" + ::oCon:Escapestr( ::oCli:Poblacion ) + "', " + ;                  //city
                                                                                  "'" + ::oCon:Escapestr( ::oCli:Telefono ) + "', " + ;                   //phone
                                                                                  "'" + ::oCon:Escapestr( ::oCli:Movil ) + "', " + ;                      //phone_mobile
                                                                                  "'" + ::oCon:Escapestr( ::oCli:Nif ) + "', " + ;                        //dni
                                                                                  "'" + dtos( GetSysDate() ) + "', " + ;                         //date_add
                                                                                  "'" + dtos( GetSysDate() ) + "', " + ;                         //date_upd
                                                                                  "'1', " + ;                                                    //active
                                                                                  "'0' )" )                                                      //deleted


                  ::writeText( "He insertado el cliente " + alltrim( ::oCli:Titulo ) + " correctamente en la tabla address", 3 )

               else
                  ::writeText( "Error al insertar el cliente " + alltrim( ::oCli:Titulo ) + " en la tabla address", 3 )
               end if

            else

               nSpace               := At( " ", ::oCli:Titulo )
               cFirstName           := ::oCon:Escapestr( Substr( ::oCli:Titulo, 1, nSpace ) )
               cLastName            := ::oCon:Escapestr( Substr( ::oCli:Titulo, nSpace + 1 ) )

               if !::oCli:lWeb

                  /*
                  Actualizamos la tabla de clientes----------------------------
                  */

                  if TMSCommand():New( ::oCon ):ExecDirect( "UPDATE " + ::cPrefixTable( "customer" ) + " SET firstname='" + alltrim( cFirstName ) + ;
                                                                                "', lastname='" + alltrim( cLastName ) + ;
                                                                                "', email='" + alltrim( ::oCli:cMeiInt ) + ;
                                                                                "', passwd='" + hb_md5( alltrim( ::TPrestashopConfig:getCookieKey() ) + alltrim( ::oCli:cClave ) ) + ;
                                                                                "', secure_key='" + hb_md5( alltrim( ::oCli:Cod ) ) + ;
                                                                                "', date_upd='" + dtos( GetSysDate() ) + ;
                                                                                "' WHERE id_customer=" + alltrim( str( ::oCli:cCodWeb ) ) )

                     ::writeText( "Actualizado correctamente el cliente " + alltrim( ::oCli:Titulo ) + " en la tabla customer", 3 )
                  else
                     ::writeText( "Error al actualizar el cliente " + alltrim( ::oCli:Titulo ) + " en la tabla customer", 3 )
                  end if

                  /*
                  Actualizamos la tabla de direcciones-------------------------
                  */

                  if TMSCommand():New( ::oCon ):ExecDirect( "UPDATE " + ::cPrefixTable( "address" ) + " SET alias='" + ( cFirstName ) + ( cLastName ) + ;
                                                                                "', firstname='" + ( cFirstName ) + ;
                                                                                "', lastname='" + ( cLastName ) + ;
                                                                                "', address1='" + ::oCon:Escapestr( ::oCli:Domicilio ) + ;
                                                                                "', postcode='" + ::oCon:Escapestr( ::oCli:CodPostal ) + ;
                                                                                "', city='" + ::oCon:Escapestr( ::oCli:Poblacion ) + ;
                                                                                "', phone='" + ::oCon:Escapestr( ::oCli:Telefono ) + ;
                                                                                "', phone_mobile='" + ::oCon:Escapestr( ::oCli:Movil ) + ;
                                                                                "', dni='" + ::oCon:Escapestr( ::oCli:Nif ) + ;
                                                                                "', date_upd='" + dtos( GetSysDate() ) + ;
                                                                                "' WHERE id_customer=" + alltrim( str( ::oCli:cCodWeb ) ) )

                     ::writeText( "Actualizado correctamente el cliente " + alltrim( ::oCli:Titulo ) + " en la tabla address", 3 )
                  else
                     ::writeText( "Error al actualizar el cliente " + alltrim( ::oCli:Titulo ) + " en la tabla address", 3 )
                  end if

               end if

            end if

         end if

      end if

      ::oCli:FieldPutByName( "lSndDoc", .f. )

      ::oCli:Skip()

   end while

Return ( self )

//---------------------------------------------------------------------------//

METHOD AppendClientPrestashop() CLASS TComercio

   local oQueryDirecciones
   local lFirst                  := .t.
   local oQuery                  := TMSQuery():New( ::oCon, 'SELECT * FROM ' + ::cPrefixTable( "customer" ) )
   local cCodCli
   local oQueryState
   local cProvincia              := ""

   /*
   Recorremos el Query con la consulta-----------------------------------------
   */

   if oQuery:Open()

      /*
      Cargamos los valores para el meter------------------------------------------
      */

      ::nTotMeter    := oQuery:RecCount()

      if !empty( ::oMeterProceso )
         ::oMeterProceso:SetTotal( ::nTotMeter )
      end if

      ::nMeterProceso := 1

      if oQuery:RecCount() > 0

         ::writeText( "Descargando clientes desde la web", 2 )

         oQuery:GoTop()

         while !oQuery:Eof()

            ::meterProcesoText( " Descargando cliente " + alltrim( str( ::nMeterProceso ) ) + " de "  + alltrim( str( ::nTotMeter ) ) )

            if !::oCli:SeekInOrd( str( oQuery:FieldGet( 1 ), 11 ), "cCodWeb" )

               cCodCli           := NextKey( dbLast(  ::oCli, 1 ), ::oCli:cAlias, "0", RetNumCodCliEmp() )

               ::oCli:Append()
               ::oCli:Blank()
               ::oCli:Cod        := cCodCli
               
               if ::TPrestashopConfig:getHideHideExportButton()
                  ::oCli:Titulo  := UPPER( oQuery:FieldGetbyName( "lastname" ) ) + ", " + UPPER( oQuery:FieldGetByName( "firstname" ) ) // Last Name - firstname
               else   
                  ::oCli:Titulo  := UPPER( oQuery:FieldGetbyName( "firstname" ) ) + Space( 1 ) + UPPER( oQuery:FieldGetByName( "lastname" ) ) //firstname - Last Name
               end if   
               
               ::oCli:nTipCli    := 3
               ::oCli:CopiasF    := 1
               ::oCli:Serie      := ::TPrestashopConfig:getOrderSerie()
               ::oCli:nRegIva    := 1
               ::oCli:nTarifa    := 1
               ::oCli:cMeiInt    := oQuery:FieldGetByName( "email" ) //email
               ::oCli:lChgPre    := .t.
               ::oCli:lSndInt    := .t.
               ::oCli:CodPago    := cDefFpg()
               ::oCli:cCodAlm    := cDefAlm()
               ::oCli:dFecChg    := GetSysDate()
               ::oCli:cTimChg    := Time()
               ::oCli:cCodWeb    := oQuery:FieldGet( 1 ) //id_customer
               ::oCli:lWeb       := .t.

               /*
               Vamos a meter las direcciones-----------------------------------
               */

               oQueryDirecciones       := TMSQuery():New( ::oCon, "SELECT * FROM " + ::cPrefixTable( "address" ) + " WHERE id_customer = " + str( oQuery:FieldGet( 1 ) ) )

               if oQueryDirecciones:Open()

                  if oQueryDirecciones:RecCount() > 0

                     oQueryDirecciones:GoTop()

                     while !oQueryDirecciones:Eof()

                        /*
                        Tomamos el nombre de la provincia----------------------
                        */                        

                        oQueryState       := TMSQuery():New( ::oCon, "SELECT * FROM " + ::cPrefixTable( "state" ) + " WHERE id_state = " + str( oQueryDirecciones:FieldGetByName( "id_state" ) ) )

                        if oQueryState:Open() .and. oQueryState:RecCount() > 0

                           cProvincia     := oQueryState:FieldGetbyName( "name" )

                        end if   

                        /*
                        El primero lo ponemos en la tabla de clientes----------
                        */

                        if lFirst

                           ::oCli:Nif            := oQueryDirecciones:FieldGetByName( "dni" ) //"dni"
                           ::oCli:Domicilio      := oQueryDirecciones:FieldGetByName( "address1" ) + " " + oQueryDirecciones:FieldGetByName( "address2" ) //"address1" - "address2"
                           ::oCli:Poblacion      := oQueryDirecciones:FieldGetByName( "city" ) //"city"
                           ::oCli:CodPostal      := oQueryDirecciones:FieldGetByName( "postcode" ) //"postcode"
                           ::oCli:Provincia      := cProvincia
                           ::oCli:Telefono       := oQueryDirecciones:FieldGetByName( "phone" ) //"phone"
                           ::oCli:Movil          := oQueryDirecciones:FieldGetByName( "phone_mobile" ) //"phone_mobile"

                        end if

                        /*
                        Ahora lo metemos en la tabla de obras------------------
                        */

                        ::oObras:Append()
                        ::oObras:Blank()

                        ::oObras:cCodCli         := cCodCli
                        ::oObras:cCodObr         := "@" + alltrim( str( oQueryDirecciones:FieldGet( 1 ) ) ) //"id_address"
                        
                        if ::TPrestashopConfig:getHideHideExportButton() 
                           ::oObras:cNomObr      := UPPER( oQuery:FieldGetbyName( "lastname" ) ) + ", " + UPPER( oQuery:FieldGetByName( "firstname" ) ) // Last Name - firstname
                        else   
                           ::oObras:cNomObr      := UPPER( oQuery:FieldGetbyName( "firstname" ) ) + Space( 1 ) + UPPER( oQuery:FieldGetByName( "lastname" ) ) //firstname - Last Name
                        end if

                        ::oObras:cDirObr         := oQueryDirecciones:FieldGetByName( "address1" ) + " " + oQueryDirecciones:FieldGetByName( "address2" ) //"address1" - "address2"
                        ::oObras:cPobObr         := oQueryDirecciones:FieldGetByName( "city" ) //"city"
                        ::oObras:cPosObr         := oQueryDirecciones:FieldGetByName( "postcode" ) //"postcode"
                        ::oObras:cPrvObr         := cProvincia
                        ::oObras:cTelObr         := oQueryDirecciones:FieldGetByName( "phone" ) //"phone"
                        ::oObras:cMovObr         := oQueryDirecciones:FieldGetByName( "phone_mobile" ) //"phone_mobile"
                        ::oObras:lDefObr         := lFirst
                        ::oObras:cCodWeb         := oQueryDirecciones:FieldGet( 1 ) //"id_address"

                        ::oObras:Save()

                        oQueryDirecciones:Skip()

                        lFirst                   := .f.

                     end while

                  end if

               end if

               if ::oCli:Save()
                  ::writeText( "Cliente " + alltrim( oQuery:FieldGetByName( "ape" ) ) + Space( 1 ) + alltrim( oQuery:FieldGetByName( "firstname" ) ) + " introducido correctamente.", 3 )
               else
                  ::writeText( "Error al descargar el cliente: " + alltrim( oQuery:FieldGetByName( "ape" ) ) + Space( 1 ) + alltrim( oQuery:FieldGetByName( "firstname" ) ), 3 )
               end if

            else

               ::writeText( "El cliente " + alltrim( oQuery:FieldGetByName( "ape" ) ) + Space( 1 ) + alltrim( oQuery:FieldGetByName( "firstname" ) ) + " ya existe en nuestra base se datos.", 3 )

            end if

            oQuery:Skip()

            ::nMeterProceso++

            lFirst                               := .t.

         end while

      end if

   end if

   oQuery:Free()

   oQuery                                        := nil

Return ( self )

//---------------------------------------------------------------------------//

METHOD AppendMessagePedido( dFecha ) Class TComercio

   local oQueryThead
   local oQueryMessage

   oQueryThead    := TMSQuery():New( ::oCon, "SELECT * FROM " + ::cPrefixtable( "customer_thread" ) + " WHERE id_order=" + alltrim( str( ::idOrderPrestashop ) ) )

   if oQueryThead:Open()

      if oQueryThead:RecCount() > 0

         oQueryThead:GoTop()

         while !oQueryThead:Eof()

            oQueryMessage    := TMSQuery():New( ::oCon, "SELECT * FROM " + ::cPrefixtable( "customer_message" ) + " WHERE id_customer_thread=" + alltrim( str( oQueryThead:FieldGet( 1 ) ) ) )

            if oQueryMessage:Open()

               if oQueryMessage:RecCount() > 0

                  oQueryMessage:GoTop()

                  while !oQueryMessage:Eof()

                     ::oPedCliI:Append()
                     ::oPedCliI:Blank()

                     ::oPedCliI:cSerPed   := ::cSeriePedido
                     ::oPedCliI:nNumPed   := ::nNumeroPedido
                     ::oPedCliI:cSufPed   := ::cSufijoPedido
                     ::oPedCliI:dFecInc   := dFecha
                     ::oPedCliI:mDesInc   := oQueryMessage:FieldGetByName( "message" )
                     ::oPedCliI:lAviso    := .t.

                     ::oPedCliI:Save()

                  oQueryMessage:Skip()

                  end while

               end if
               
            end if      

            oQueryThead:Skip()

         end while

      end if   

   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD EstadoPedidosPrestashop() Class TComercio

   local oQuery

   ::nTotMeter := 0

   /*
   Compruebo datos para el meter-----------------------------------------
   */

   ::oPedCliT:GoTop()
   while !::oPedCliT:Eof()

      if ::oPedCliT:lInternet .and. ::oPedCliT:nEstado != 3
         ::nTotMeter ++
      end if

   ::oPedCliT:Skip()

   end while

   ::oMeterProceso:SetTotal( ::nTotMeter )
   ::nMeterProceso   := 1

   /*
   Modifico los datos y tablas correspondientes--------------------------
   */

   ::writeText( "Actualizando el estado de los pedidos", 2 )

   ::oPedCliT:GoTop()
   while !::oPedCliT:Eof()

      if ::oPedCliT:lInternet .and. ::oPedCliT:nEstado != 1

         ::meterProcesoText( "Actualizando estado de pedidos " + alltrim( str( ::nMeterProceso ) ) + " de " + alltrim( str( ::nTotMeter ) ) )

         oQuery                  := TMSQuery():New( ::oCon, "SELECT * FROM " + ::cPrefixTable( "order_history" ) + " WHERE id_order=" + alltrim( str( ::oPedCliT:cCodWeb ) ) + " AND id_order_state=5" )

         if oQuery:Open()

            if oQuery:RecCount() == 0

               if TMSCommand():New( ::oCon ):ExecDirect( "INSERT INTO " + ::cPrefixTable( "order_history" ) + " ( id_employee, " + ;
                                                                                         "id_order, " + ;
                                                                                         "id_order_state, " + ;
                                                                                         "date_add )" + ;
                                                                              " VALUES " + ;
                                                                                         "('1', " + ;                                           //id_employee
                                                                                         "'" + alltrim( str( ::oPedCliT:cCodWeb ) ) + "', " + ; //id_order
                                                                                         "'5', " + ;                                            //id_ordder_state
                                                                                         "'" + dtos( GetSysDate() ) + "' )" )                   //date_add

                  ::writeText( "Actualizado el estado del pedido " + ::oPedCliT:cSerPed + "/" + alltrim( str( ::oPedCliT:nNumPed ) ) + "/" + ::oPedCliT:cSufPed, 3 )

               else

                  ::writeText( "Error al actualizar el estado del pedido " + ::oPedCliT:cSerPed + "/" + alltrim( str( ::oPedCliT:nNumPed ) ) + "/" + ::oPedCliT:cSufPed, 3 )

               end if

            end if

         end if

      end if

   ::oPedCliT:Skip()

   end while

Return ( self )

//---------------------------------------------------------------------------//

METHOD nIdProductAttribute( idProductPrestashop, cCodWebValPr1, cCodWebValPr2 ) CLASS TComercio

   local nIdProductAttribute  := 0
   local cCommand             := ""
   local oQuery
   local oQuery2
   local lPrp1                := .f.
   local lPrp2                := .f.

   do case
      case !empty( cCodWebValPr1 ) .and. empty( cCodWebValPr2 )

         cCommand             := "SELECT * FROM " + ::cPrefixTable( "product_attribute" ) + " WHERE id_product = " + alltrim( str( idProductPrestashop ) )

         oQuery               := TMSQuery():New( ::oCon, cCommand )

         if oQuery:Open() .and. oQuery:recCount() > 0

            oQuery:GoTop()
            while !oQuery:Eof()

               cCommand       := "SELECT * FROM " + ::cPrefixTable( "product_attribute_combination" ) + " WHERE id_product_attribute = " + alltrim( str( oQuery:FieldGet( 1 ) ) )

               oQuery2        := TMSQuery():New( ::oCon, cCommand )

                  if oQuery2:Open() .and. oQuery2:recCount() == 1 .and. oQuery2:FieldGet( 1 ) == cCodWebValPr1
                     nIdProductAttribute     := oQuery:FieldGet( 1 )
                  end if   

               oQuery:Skip()

            end while

         end if

      case !empty( cCodWebValPr1 ) .and. !empty( cCodWebValPr2 )

         cCommand                := "SELECT * FROM " + ::cPrefixTable( "product_attribute" ) + " WHERE id_product = " + alltrim( str( idProductPrestashop ) )

         oQuery                  := TMSQuery():New( ::oCon, cCommand )

         if oQuery:Open() // .and. oQuery:recCount() > 0

            oQuery:GoTop()
            while !oQuery:Eof()

               cCommand          := "SELECT * FROM " + ::cPrefixTable( "product_attribute_combination" ) + " WHERE id_product_attribute=" + alltrim( str( oQuery:FieldGet( 1 ) ) )

               oQuery2           := TMSQuery():New( ::oCon, cCommand )

                  if oQuery2:Open() .and. oQuery2:recCount() == 2

                     oQuery2:GoTop()
                     while !oQuery2:Eof()

                        if !lPrp1
                           lPrp1 := ( oQuery2:FieldGet( 1 ) == cCodWebValPr1 )
                        end if

                        oQuery2:Skip()

                     end while

                     oQuery2:GoTop()
                     while !oQuery2:Eof()

                        if !lPrp2
                           lPrp2 := ( oQuery2:FieldGet( 1 ) == cCodWebValPr2 )
                        end if

                        oQuery2:Skip()

                     end while

                     if lPrp1 .and. lPrp2
                        nIdProductAttribute     := oQuery:FieldGet( 1 )
                     end if

                  end if

               oQuery:Skip()

               lPrp1          := .f.
               lPrp2          := .f.

            end while

         end if

   end case

Return nIdProductAttribute

//---------------------------------------------------------------------------//

METHOD cValidDirectoryFtp( cDirectory ) CLASS TComercio

   local cResult

   /*
   Cambiamos todas las contrabarras por barras normales------------------------
   */

   cResult     := StrTran( alltrim( cDirectory ), "\", "/" )

   /*
   Si empieza por barra la quitamos--------------------------------------------
   */

   if Left( cResult, 1 ) == "/"
      cResult  := Substr( cResult, 2 )
   end if

   /*
   Si termina por barra la quitamos--------------------------------------------
   */

   if Right( cResult, 1 ) == "/"
      cResult  := Substr( cResult, 1, Len( cResult ) - 1 )
   end if

Return ( cResult )

//---------------------------------------------------------------------------//

METHOD CreateDirectoryImagesLocal( cCarpeta ) CLASS TComercio

   local n
   local cResult  := ""

   if ValType( cCarpeta ) == "N"
      cCarpeta    := alltrim( str( cCarpeta ) )
   end if

   for n := 1 to Len( cCarpeta )

      cResult     += "/" + Substr( cCarpeta, n, 1 )
         
      if !isDirectory( ::cDirectoryProduct() + cResult )
         Makedir( ::cDirectoryProduct() + cResult )
      end if

   next

Return ( cResult )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD prestaShopConnect()

   local oDb
   local lConnect     := .f.

   if empty( ::TPrestashopConfig:getMySqlServer() )
      msgStop( "No se ha definido ningun servidor web" )
      Return ( lConnect )
   end if 

   ::writeText( 'Intentando conectar con el servidor ' + '"' + ::TPrestashopConfig:getMySqlServer() + '"' + ', el usuario ' + '"' + ::TPrestashopConfig:getMySqlUser()  + '"' + ' y la base de datos ' + '"' + ::TPrestashopConfig:getMySqlDatabase() + '".' , 3 )

   ::oCon            := TMSConnect():New()

   if !empty( ::TPrestashopConfig:getMySqlTimeOut() )
      ::oCon:SetTimeOut( ::TPrestashopConfig:getMySqlTimeOut() )
   end if 

   if !::oCon:Connect(  ::TPrestashopConfig:getMySqlServer(),;
                        ::TPrestashopConfig:getMySqlUser(),;
                        ::TPrestashopConfig:getMySqlPassword(),;
                        ::TPrestashopConfig:getMySqlDatabase(),;
                        ::TPrestashopConfig:getMySqlPort() )

      ::writeText( 'No se ha podido conectar con la base de datos.' )

   else

      ::writeText( 'Se ha conectado con éxito a la base de datos.' , 3 )

      oDb            := TMSDataBase():New( ::oCon, ::TPrestashopConfig:getMySqlDatabase() )

      if empty( oDb )

         ::writeText( 'La Base de datos: ' + ::TPrestashopConfig:getMySqlDatabase() + ' no esta activa.', 3 )

      else

         ::nLanguage                            := ::getLanguagePrestashop()
         ::lProductIdColumnImageShop            := ::isProductIdColumnImageShop()
         ::lProductIdColumnProductAttribute     := ::isProductIdColumnProductAttribute()
         ::lProductIdColumnProductAttributeShop := ::isProductIdColumnProductAttributeShop()
         ::lSpecificPriceIdColumnReductionTax   := ::isSpecificPriceIdColumnReductionTax()
         ::aTypeImagesPrestashop                := ::getTypeImagePrestashop()

         lConnect                               := .t.

      end if

   end if   

Return ( lConnect )

//---------------------------------------------------------------------------//

METHOD prestashopDisConnect()

   if !empty( ::oCon )
      ::oCon:free()
   end if   

   ::writeText( 'Base de datos desconectada.', 1 )

return .t.   

//---------------------------------------------------------------------------//

METHOD buildIvaPrestashop( id ) CLASS TComercio

   if aScan( ::aIvaData, {|h| hGet( h, "id" ) == id } ) != 0
      Return .f. 
   end if 

   if ::lSyncAll .or. ::TPrestashopId:getValueTax( id, ::getCurrentWebName() ) == 0
      if ::oIva:seekInOrd( id, "Tipo" )
         aAdd( ::aIvaData, {  "id"     => id,;
                              "rate"   => alltrim( str( ::oIva:TpIva ) ),;
                              "name"   => alltrim( ::oIva:DescIva ) } )
      end if 
   end if 

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD buildFabricantePrestashop( id ) CLASS TComercio

   if aScan( ::aFabricantesData, {|h| hGet( h, "id" ) == id } ) != 0
      Return .f.
   end if 

   if ::lSyncAll .or. ::TPrestashopId:getValueManufacturer( id, ::getCurrentWebName() ) == 0
      if ::oFab:SeekInOrd( id, "cCodFab" ) .and. ::oFab:lPubInt
         aAdd( ::aFabricantesData,  {  "id"     => id,;
                                       "name"   => rtrim( ::oFab:cNomFab ) } )
      end if
   end if 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD buildFamiliaPrestashop( id ) CLASS TComercio

   if ascan( ::aFamiliaData, {|h| hGet( h, "id" ) == id } ) != 0
      Return .f.
   end if

   if ::lSyncAll .or. ::TPrestashopId:getValueCategory( id, ::getCurrentWebName() ) == 0
   
      if ::oFam:SeekInOrd( id, "cCodFam" ) 
   
         aAdd( ::aFamiliaData, { "id"           => id,;
                                 "id_parent"    => ::oFam:cFamCmb,;
                                 "name"         => if( empty( ::oFam:cDesWeb ), alltrim( ::oFam:cNomFam ), alltrim( ::oFam:cDesWeb ) ),;
                                 "description"  => if( empty( ::oFam:cDesWeb ), alltrim( ::oFam:cNomFam ), alltrim( ::oFam:cDesWeb ) ),;
                                 "link_rewrite" => cLinkRewrite( if( empty( ::oFam:cDesWeb ), alltrim( ::oFam:cNomFam ), alltrim( ::oFam:cDesWeb ) ) ),;
                                 "image"        => ::oFam:cImgBtn } )
   
      end if   

      if !empty( ::oFam:cFamCmb )
         ::buildFamiliaPrestashop( ::oFam:cFamCmb )
      end if

   end if 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD buildProductPrestashop( id ) CLASS TComercio

   local aStockArticulo       := {}
   local aImagesArticulos     := {}

   if aScan( ::aProductData, {|h| hGet( h, "id" ) == id } ) != 0
      Return ( self )
   end if 

   // Recopilar info de imagenes-----------------------------------------

   aImagesArticulos           := ::buildImagesArticuloPrestashop( id )

   aStockArticulo             := ::buildStockPrestashop( id )

   // Rellenamos el Hash-------------------------------------------------

   aAdd( ::aProductData,   {  "id"                    => id,;
                              "name"                  => alltrim( ::oArt:Nombre ),;
                              "id_manufacturer"       => ::oArt:cCodFab ,;
                              "id_tax_rules_group"    => ::oArt:TipoIva ,;
                              "id_category_default"   => ::oArt:Familia ,;
                              "reference"             => ::oArt:Codigo ,;
                              "weight"                => ::oArt:nPesoKg ,;
                              "specific_price"        => ::oArt:lSbrInt,;
                              "price"                 => ::buildPriceProduct(),;
                              "reduction"             => ::buildPriceReduction(),;
                              "reduction_tax"         => ::buildPriceReductionTax(),;
                              "description"           => if( !empty( ::oArt:mDesTec ), ::oArt:mDesTec, ::oArt:Nombre ) ,; 
                              "description_short"     => alltrim( ::oArt:Nombre ) ,;
                              "link_rewrite"          => cLinkRewrite( ::oArt:Nombre ),;
                              "meta_title"            => alltrim( ::oArt:cTitSeo ) ,;
                              "meta_description"      => alltrim( ::oArt:cDesSeo ) ,;
                              "meta_keywords"         => alltrim( ::oArt:cKeySeo ) ,;
                              "lPublicRoot"           => ::oArt:lPubPor,;
                              "cImagen"               => ::oArt:cImagen,;
                              "aImages"               => aImagesArticulos,;
                              "aStock"                => aStockArticulo } )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD buildImagesArticuloPrestashop( id ) CLASS TComercio

   local aImgToken      := {}
   local cImgToken      := ""
   local cImagen
   local aImages        := {}
   local nOrdAntImg
   local nOrdAntDiv     

   // Pasamos las imágenes de los artículos por propiedades-----------------------

   nOrdAntDiv           := ::oArtDiv:OrdSetFocus( "cCodigo" )
   if ::oArtDiv:Seek( id )

      while ::oArtDiv:cCodArt == id .and. !::oArtDiv:Eof()

         if !empty( ::oArtDiv:mImgWeb )

            aImgToken   := hb_atokens( ::oArtDiv:mImgWeb, "," )

            for each cImgToken in aImgToken

               if file( cImgToken )
                  if !empty( cImgToken ) .and. ascan( aImages, {|a| hGet( a, "name" ) == cImgToken } ) == 0
                     aadd( aImages, {  "name"      => cImgToken,;
                                       "id"        => oRetFld( cImgToken, ::oArtImg, "nId", "cImgArt" ),;
                                       "lDefault"  => oRetFld( cImgToken, ::oArtImg, "lDefImg", "cImgArt" ) } )
                  end if
               end if 

            next

         end if

         ::oArtDiv:Skip()

      end while

   end if

   ::oArtDiv:OrdSetFocus( nOrdAntDiv )

   // Pasamos las imágenes de la tabla de artículos-------------------------------

   if empty( aImages )

      nOrdAntImg     := ::oArtImg:OrdSetFocus( "cCodArt" )
      if ::oArtImg:Seek( id )

         while ::oArtImg:cCodArt == id .and. !::oArtImg:Eof()

            cImagen  := alltrim( ::oArtImg:cImgArt )

            if file( cImagen )
               if ascan( aImages, {|a| hGet( a, "name" ) == cImagen } ) == 0
                  aadd( aImages, {  "name"      => cImagen,;
                                    "id"        => ::oArtImg:nId,;
                                    "lDefault"  => ::oArtImg:lDefImg } )
               end if 
            end if 

            ::oArtImg:Skip()

         end while

      end if 

      ::oArtImg:OrdSetFocus( nOrdAntImg )

   end if

   // Nos aseguramos de que por lo menos una imágen sea por defecto------------

   if !empty( aImages )
      if ascan( aImages, {|a| hGet( a, "lDefault" ) == .t. } ) == 0
         hSet( aImages[ 1 ], "lDefault", .t. )
      end if   
   end if   

Return ( aImages )

//---------------------------------------------------------------------------//

METHOD buildPriceProduct() CLASS TComercio

   local priceProduct      := 0

   // calcula el precio en funcion del descuento-------------------------------

   if ::oArt:lSbrInt .and. ::oArt:pVtaWeb != 0

      priceProduct         := ::oArt:pVtaWeb

   else

      if ::oArt:lIvaWeb
         priceProduct      := round( ::oArt:nImpIva1 / ( ( nIva( ::oIva:cAlias, ::oArt:TipoIva ) / 100 ) + 1 ), 6 )
      else
         priceProduct      := ::oArt:nImpInt1
      end if

   end if 

Return ( priceProduct )

//---------------------------------------------------------------------------//
//
// calcula la reduccion sobre el precio
//

METHOD buildPriceReduction() CLASS TComercio

   local priceReduction    := 0

   if ::oArt:lSbrInt .and. ::oArt:pVtaWeb != 0

      if ::oArt:lIvaWeb
         priceReduction    := ::oArt:pVtaWeb
         priceReduction    += ::oArt:pVtaWeb * nIva( ::oIva:cAlias, ::oArt:TipoIva ) / 100
         priceReduction    -= ::oArt:nImpIva1 
      else
         priceReduction    := ::oArt:pVtaWeb 
         priceReduction    -= ::oArt:nImpInt1
      end if

   end if 

Return ( priceReduction )

//---------------------------------------------------------------------------//

METHOD buildPropiedadesPrestashop( id ) CLASS TComercio

   /*
   Primera propiedad--------------------------------------------------------
   */

   if ::oPro:SeekInOrd( ::oArt:cCodPrp1 ) 
      if aScan( ::aPropiedadesCabeceraData, {|h| hGet( h, "id" ) == ::oPro:cCodPro } ) == 0

         if ::lSyncAll .or. ::TPrestashopId:getValueAttributeGroup( id, ::getCurrentWebName() ) == 0

            aAdd( ::aPropiedadesCabeceraData,   {  "id"     => ::oPro:cCodPro,;
                                                   "name"   => if( empty( ::oPro:cNomInt ), alltrim( ::oPro:cDesPro ), alltrim( ::oPro:cNomInt ) ),;
                                                   "lColor" => ::oPro:lColor } )

         end if

      end if 

   end if

   /*
   Segunda propiedad--------------------------------------------------------
   */

   if ::oPro:SeekInOrd( ::oArt:cCodPrp2 ) 
      
      if aScan( ::aPropiedadesCabeceraData, {|h| hGet( h, "id" ) == ::oPro:cCodPro } ) == 0

         if ::lSyncAll .or. ::TPrestashopId:getValueAttributeGroup( id, ::getCurrentWebName() ) == 0

            aAdd( ::aPropiedadesCabeceraData,   {  "id"     => ::oPro:cCodPro,;
                                                   "name"   => if( empty( ::oPro:cNomInt ), alltrim( ::oPro:cDesPro ), alltrim( ::oPro:cNomInt ) ),;
                                                   "lColor" => ::oPro:lColor } )

         end if
         
      end if

   end if

   /*
   Líneas de propiedades de un artículo-------------------------------------
   */

   if ::oArtDiv:Seek( ::oArt:Codigo )

      while ::oArtDiv:cCodArt == ::oArt:Codigo .and. !::oArtDiv:Eof()

         if ::oTblPro:SeekInOrd( ::oArtDiv:cCodPr1 + ::oArtDiv:cValPr1, "cCodPro" )

            if ::lSyncAll .or. ::TPrestashopId:getValueAttribute( ::oTblPro:cCodPro + ::oTblPro:cCodTbl, ::getCurrentWebName() ) == 0

               if aScan( ::aPropiedadesLineasData, {|h| hGet( h, "id" ) == ::oTblPro:cCodTbl .and. hGet( h, "idparent" ) == ::oTblPro:cCodPro } ) == 0
      
                  aAdd( ::aPropiedadesLineasData,  {  "id"           => ::oTblPro:cCodTbl,;
                                                      "idparent"     => ::oTblPro:cCodPro,; 
                                                      "name"         => alltrim( ::oTblPro:cDesTbl ),;
                                                      "color"        => alltrim( RgbToRgbHex( ::oTblPro:nColor ) ),;
                                                      "position"     => ::oTblPro:nOrdTbl } )

               end if

            end if

         end if

         if ::oTblPro:SeekInOrd( ::oArtDiv:cCodPr2 + ::oArtDiv:cValPr2, "cCodPro" )

            if ::lSyncAll .or. ::TPrestashopId:getValueAttribute( ::oTblPro:cCodPro + ::oTblPro:cCodTbl, ::getCurrentWebName() ) == 0

               if aScan( ::aPropiedadesLineasData, {|h| hGet( h, "id" ) == ::oTblPro:cCodTbl .and. hGet( h, "idparent" ) == ::oTblPro:cCodPro } ) == 0
      
                  aAdd( ::aPropiedadesLineasData,  {  "id"           => ::oTblPro:cCodTbl,;
                                                      "idparent"     => ::oTblPro:cCodPro,; 
                                                      "name"         => alltrim( ::oTblPro:cDesTbl ),;
                                                      "color"        => alltrim( RgbToRgbHex( ::oTblPro:nColor ) ),;
                                                      "position"     => ::oTblPro:nOrdTbl } )

               end if

            end if

         end if

         ::oArtDiv:Skip()

      end while

   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD buildGlobalProductInformation() CLASS TComercio

   ::writeText( alltrim( ::oArt:Codigo ) + " - " + alltrim( ::oArt:Nombre ) )

   ::buildIvaPrestashop(            ::oArt:TipoIva )
   ::buildFabricantePrestashop(     ::oArt:cCodFab )
   ::buildFamiliaPrestashop(        ::oArt:Familia )
   ::buildPropiedadesPrestashop(    ::oArt:Codigo )
   ::buildProductPrestashop(        ::oArt:Codigo )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD uploadAditionalInformationToPrestashop() CLASS TComercio

   local hTax
   local hFamiliaData
   local hFabricantesData
   local hPropiedadesCabData
   local hPropiedadesLinData

   // Subimos los tipos de IVA----------------------------------------------

   ::meterProcesoSetTotal( len(::aIvaData) )

   for each hTax in ::aIvaData

      ::buildInsertIvaPrestashop( hTax )

      ::meterProcesoText( "Subiendo impuestos " + alltrim(str(hb_enumindex())) + " de " + alltrim(str(len(::aIvaData))) )

   next

   // Subimos fabricantes---------------------------------------------------

   if ::TPrestashopConfig:getSyncronizeManufacturers()

      ::meterProcesoSetTotal( len(::aFabricantesData) )

      for each hFabricantesData in ::aFabricantesData

         ::buildInsertFabricantesPrestashop( hFabricantesData )

         ::meterProcesoText( "Subiendo fabricantes " + alltrim(str(hb_enumindex())) + " de " + alltrim(str(len(::aFabricantesData))) )

      next 

   end if 

   // Subimos familias------------------------------------------------------

   ::meterProcesoSetTotal( len(::aFamiliaData) )

   for each hFamiliaData in ::aFamiliaData

      ::buildInsertCategoriesPrestashop( hFamiliaData )

      ::meterProcesoText( "Subiendo categorias " + alltrim(str(hb_enumindex())) + " de " + alltrim(str(len(::aFamiliaData))) )

   next 

   // Actualizamos padres de las familias-----------------------------------

   ::meterProcesoSetTotal( len(::aFamiliaData) )

   for each hFamiliaData in ::aFamiliaData

      ::buildActualizaCatergoriaPadrePrestashop( hFamiliaData )

      ::meterProcesoText( "Relacionando categorias " + alltrim(str(hb_enumindex())) + " de " + alltrim(str(len(::aFamiliaData))) )

   next

   // Recalculamos las posiciones de las categorias-------------------------

   ::meterProcesoText( "Recalculando posiciones de categorias" )

   ::buildRecalculaPosicionesCategoriasPrestashop()

   // Subimos las cabeceras de propiedades necesarias-----------------------

   for each hPropiedadesCabData in ::aPropiedadesCabeceraData
      ::buildInsertPropiedadesPrestashop( hPropiedadesCabData )
   next

   // Subimos las Lineas de propiedades necesarias--------------------------

   ::meterProcesoSetTotal( len( ::aPropiedadesLineasData ) )

   asort( ::aPropiedadesLineasData, , , {|x,y| hget( x, "position" ) < hget( y, "position" ) } )

   for each hPropiedadesLinData in ::aPropiedadesLineasData

      ::buildInsertLineasPropiedadesPrestashop( hPropiedadesLinData, hb_enumindex() )

      ::meterProcesoText( "Subiendo propiedad " + alltrim(str(hb_enumindex())) + " de " + alltrim(str(len(::aPropiedadesLineasData))) )

   next
 
Return ( Self )

//---------------------------------------------------------------------------//

METHOD uploadProductToPrestashop()

   local hProduct
   local nArticuloData     := len(::aProductData)
   local nArticuloStart    := ::TPrestashopConfig:getStart()

   // Subimos los artículos----------------------------------------------------

   ::meterProcesoSetTotal( len( ::aProductData ) )
   
   for each hProduct in ::aProductData

      if hb_enumindex() >= nArticuloStart

         ::buildInsertProductsPrestashop( hProduct )

         ::meterProcesoText( "Subiendo artículo " + alltrim( str( hb_enumindex() ) ) + " de " + alltrim( str( nArticuloData ) ) ) 

      end if 
   
   next

Return ( Self )

//---------------------------------------------------------------------------//

METHOD uploadImageToPrestashop()

   local hProduct

   // Subimos las imagenes de los  artículos-----------------------------------

   ::meterProcesoSetTotal( len( ::aProductData ) )
   
   for each hProduct in ::aProductData

      ::uploadProductImages( hGet( hProduct, "aImages" ) )

      ::meterProcesoText( "Subiendo imagenes " + alltrim( str(hb_enumindex())) + " de " + alltrim(str(len(::aProductData))) )
   
   next

Return ( Self )

//---------------------------------------------------------------------------//

METHOD buildProductInformation( idProduct ) CLASS TComercio

   ::buildInitData()

   // Elabora la inormacion para uno o varios articulos---------------------

   if empty( idProduct )

      ::oArt:goTop()
      while !::oArt:Eof()

         if ::productInCurrentWeb()
            ::buildGlobalProductInformation()
         end if 

         ::oArt:Skip()

      end while

   else

      if ::oArt:Seek( idProduct ) .and. ::productInCurrentWeb()
         ::buildGlobalProductInformation()
      end if

   end if   

Return ( Self )

//---------------------------------------------------------------------------//

METHOD uploadInformationToPrestashop( idProduct )

   // Eliminamos las bases de datos--------------------------------------------

   ::MeterTotalText( "Eliminando la bases de datos." )

   if ::lSyncAll 
      ::buildEliminaTablas()
   end if

   if !empty( idProduct )
      ::buildDeleteProductPrestashop( idProduct )
   end if 

   // Subimos la informacion a mysql-------------------------------------------

   ::MeterTotalText( "Subiendo la información adicional." )

   ::uploadAditionalInformationToPrestashop()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD updateInformationToPrestashop( idProduct )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD buildInsertIvaPrestashop( hTax ) CLASS TComercio

   local cCommand          := ""  
   local nCodigoWeb        := 0
   local nCodigoGrupoWeb   := 0

   cCommand := "INSERT INTO " + ::cPreFixtable( "tax" ) + " ( " + ;
                  "rate, " + ;
                  "active ) " + ;
               "VALUES ( " + ;
                  "'" + hGet( hTax, "rate" ) + "', " + ;  // rate
                  "'1' )"                                      // active

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      nCodigoWeb           := ::oCon:GetInsertId()
      ::writeTextOk( hGet( hTax, "name" ), ::cPrefixTable( "tax" ) )
   else
      ::writeTextError( hGet( hTax, "name" ), ::cPrefixTable( "tax" ) )
   end if

   /*
   Insertamos un tipo de IVA nuevo en la tabla tax_lang------------------------
   */

   cCommand := "INSERT INTO " + ::cPrefixTable( "tax_lang" ) + "( " +;
                  "id_tax, " + ;
                  "id_lang, " + ;
                  "name ) " + ;
               "VALUES ( " + ;
                  "'" + str( nCodigoWeb ) + "', " + ;                         // id_tax
                  "'" + str( ::nLanguage ) + "', " + ;                        // id_lang
                  "'" + ::oCon:Escapestr( hGet( hTax, "name" ) ) + "' )"      // name

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeTextOk( hGet( hTax, "name" ), ::cPrefixTable( "tax_lang" ) )
   else
      ::writeTextError( hGet( hTax, "name" ), ::cPrefixTable( "tax_lang" ) )
   end if

   /*
   Insertamos un tipo de IVA nuevo en la tabla tax_rule_group------------------
   */

   cCommand := "INSERT INTO "+ ::cPrefixTable( "tax_rules_group" ) + "( " + ;
                  "name, " + ;
                  "active ) " + ;
               "VALUES ( " + ;
                  "'" + ::oCon:Escapestr( hGet( hTax, "name" ) ) + "', " + ;  // name
                  "'1' )"                                                     // active

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      nCodigoGrupoWeb           := ::oCon:GetInsertId()
      ::writeTextOk( hGet( hTax, "name" ), ::cPrefixTable( "tax_rule_group" ) )
   else
      ::writeTextError( hGet( hTax, "name" ), ::cPrefixTable( "tax_rule_group" ) )
   end if

   /*
   Insertamos un tipo de IVA nuevo en la tabla tax_rule------------------------
   */

   cCommand := "INSERT INTO " + ::cPrefixTable( "tax_rule" ) + "( " +;
                  "id_tax_rules_group, " + ;
                  "id_country, " + ;
                  "id_tax )" + ;
               " VALUES ( " + ;
                  "'" + str( nCodigoGrupoWeb ) + "', " + ;  // id_tax_rules_group
                  "'6', " + ;                                // id_country - 6 es el valor de España
                  "'" + str( nCodigoWeb ) + "' )"            // id_tax

   if !:: TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeTextError( hGet( hTax, "name" ), ::cPrefixTable( "tax_rule" ) )
   end if

   /*
   Insertamos un tipo de IVA nuevo en la tabla tax_rule------------------------
   */

   cCommand := "INSERT INTO " + ::cPrefixTable( "tax_rules_group_shop" ) + "( " +;
                  "id_tax_rules_group, " + ;
                  "id_shop ) " + ;
               "VALUES ( " + ;
                  "'" + str( nCodigoGrupoWeb ) + "', " + ;
                  "'1' )"

   if !TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeTextError( hGet( hTax, "name" ), ::cPrefixTable( "tax_rules_group_shop" ) )
   end if

   // Guardo referencia a la web-----------------------------------------------

   ::TPrestashopId:setValueTax(           hGet( hTax, "id" ), ::getCurrentWebName(), nCodigoWeb )
   ::TPrestashopId:setValueTaxRuleGroup(  hGet( hTax, "id" ), ::getCurrentWebName(), nCodigoWeb )

Return ( nCodigoweb )

//---------------------------------------------------------------------------//

METHOD buildInsertFabricantesPrestashop( hFabricantesData ) CLASS TComercio

   local oImagen
   local cCommand    := ""    
   local nCodigoWeb  := 0
   local nParent     := 1

   /*
   Insertamos un fabricante nuevo en las tablas de prestashop-----------------
   */

   cCommand := "INSERT INTO " + ::cPrefixTable( "manufacturer" ) + "( " +;
                  "name, " + ;
                  "date_add, " + ;
                  "date_upd, " + ;
                  "active ) " + ;
               "VALUES ( " + ;
                  "'" + hGet( hFabricantesData, "name" ) + "', " + ; //name
                  "'" + dtos( GetSysDate() ) + "', " + ;             //date_add
                  "'" + dtos( GetSysDate() ) + "', " + ;             //date_upd
                  "'1' )"                                            //active

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      nCodigoWeb           := ::oCon:GetInsertId()
   else
      ::writeText( "Error al insertar el fabricante " + hGet( hFabricantesData, "name" ) + " en la tabla " + ::cPreFixtable( "manufacturer" ), 3 )
   end if

   cCommand := "INSERT INTO " + ::cPrefixTable( "manufacturer_shop" ) + "( "+ ;
                  "id_manufacturer, " + ;
                  "id_shop ) " + ;
               "VALUES ( " + ;
                  "'" + alltrim( str( nCodigoWeb ) ) + "', " + ;      // id_manufacturer
                  "'1' )"                                             // id_shop                  


   if !TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( "Error al insertar el fabricante " + hGet( hFabricantesData, "name" ) + " en la tabla" + ::cPreFixtable( "manufacturer_shop" ), 3 )
   end if

   cCommand := "INSERT INTO " + ::cPreFixtable( "manufacturer_lang" ) + "( " +;
                  "id_manufacturer, " + ;
                  "id_lang ) " + ;
               "VALUES ( " + ;
                  "'" + alltrim( str( nCodigoWeb ) ) + "', " + ;     //id_manufacturer
                  "'" + str( ::nLanguage ) + "' )"                   //id_lang

   if !TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( "Error al insertar el fabricante " + hGet( hFabricantesData, "name" ) + " en la tabla" + ::cPreFixtable( "manufacturer_lang" ), 3 )
   end if

   // Guardo referencia a la web-----------------------------------------------

   if !empty( nCodigoWeb )
      ::TPrestashopId:setValueManufacturer( hget( hFabricantesData, "id" ), ::getCurrentWebName(), nCodigoWeb )
   end if 

return nCodigoWeb

//---------------------------------------------------------------------------//

METHOD buildInsertCategoriesPrestashop( hFamiliaData ) CLASS TComercio

   local oImagen
   local oCategoria
   local nCodigoWeb           := 0
   local nParent              := 2
   local cCommand             := ""

   ::writeText( "Añadiendo categoría: " + hGet( hFamiliaData, "name" ) )

   //Insertamos una familia nueva en las tablas de prestashop-----------------

   cCommand := "INSERT INTO " + ::cPrefixTable( "category" ) + "( "  + ;
                  "id_parent, "                                      + ;
                  "level_depth, "                                    + ;
                  "nleft, "                                          + ;
                  "nright, "                                         + ;
                  "active, "                                         + ;
                  "date_add,  "                                      + ;
                  "date_upd, "                                       + ;
                  "position ) "                                      + ;
               "VALUES ( "                                           + ;
                  "'" + str( nParent ) + "', "                       + ;
                  "'2', "                                            + ;
                  "'0', "                                            + ;
                  "'0', "                                            + ;
                  "'1', "                                            + ;
                  "'" + dtos( GetSysDate() ) + "', "                 + ;
                  "'" + dtos( GetSysDate() ) + "', "                 + ;
                  "'0' ) "

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )

      nCodigoWeb           := ::oCon:GetInsertId()

      ::nNumeroCategorias++

      //Metemos en un array para luego calcular las coordenadas---------------

      oCategoria                       := SCategoria()
      oCategoria:id                    := nCodigoWeb
      oCategoria:idParent              := nParent
      oCategoria:nTipo                 := 2

      aAdd( ::aCategorias, oCategoria )

      ::writeText( "He insertado la familia " + hGet( hFamiliaData, "name" ) + " correctamente en la tabla " + ::cPrefixTable( "category" ), 3 )

   else
      ::writeText( "Error al insertar la familia " + hGet( hFamiliaData, "name" ) + " en la tabla " + ::cPrefixTable( "category" ), 3 )
   end if

   cCommand := "INSERT INTO " + ::cPrefixTable( "category_lang" ) + "( " + ;
                  "id_category, " + ;
                  "id_lang, " + ;
                  "name, " + ;
                  "description, " + ;
                  "link_rewrite, " + ;
                  "meta_title, " + ;
                  "meta_keywords, " + ;
                  "meta_description ) " + ;
               "VALUES ( '" + ;
                  str( nCodigoWeb ) + "', '" +;
                  str( ::nLanguage ) + "', '" + ;
                  hGet( hFamiliaData, "name" ) + "', '" + ;
                  hGet( hFamiliaData, "description" ) + "', '" + ;
                  hGet( hFamiliaData, "link_rewrite" ) + "', " + ;
                  "'', " + ;
                  "'', " + ;
                  "'' )"

   if !TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( "Error al insertar la familia " + hGet( hFamiliaData, "name" ) + " en la tabla " + ::cPrefixTable( "category_lang" ), 3 )
   end if

   cCommand := "INSERT INTO " + ::cPrefixTable( "category_shop" ) + "( id_category, id_shop, position ) VALUES ( '" + str( nCodigoWeb ) + "', '1', '0' )"

   if !TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( "Error al insertar la categoría inicio en " + ::cPrefixTable( "category_group" ), 3 )
   end if

   cCommand := "INSERT INTO " + ::cPrefixTable( "category_group" ) + "( id_category, id_group ) VALUES ( '" + str( nCodigoWeb ) + "', '1' )"

   if !TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( "Error al insertar la familia " + hGet( hFamiliaData, "name" ) + " en la tabla " + ::cPrefixTable( "category_group" ), 3 )
   end if

   cCommand := "INSERT INTO " + ::cPrefixTable( "category_group" ) + "( id_category, id_group ) VALUES ( '" + str( nCodigoWeb ) + "', '2' )"

   if !TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( "Error al insertar la familia " + hGet( hFamiliaData, "name" ) + " en la tabla " + ::cPrefixTable( "category_group" ), 3 )
   end if

   cCommand := "INSERT INTO " + ::cPrefixTable( "category_group" ) + "( id_category, id_group ) VALUES ( '" + str( nCodigoWeb ) + "', '3' )"

   if !TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( "Error al insertar la familia " + hGet( hFamiliaData, "name" ) + " en la tabla " + ::cPrefixTable( "category_group" ), 3 )
   end if

   SysRefresh()

   //Insertamos un registro en las tablas de imágenes----------------------

   if !empty( hGet( hFamiliaData, "image" ) )

      //Añadimos la imagen al array para pasarla a prestashop--------------

      oImagen                       := SImagen()
      oImagen:cNombreImagen         := hGet( hFamiliaData, "image" )
      oImagen:nTipoImagen           := tipoCategoria
      oImagen:cPrefijoNombre        := alltrim( str( nCodigoWeb ) )

      ::addImages( oImagen )

   end if

   // Guardo referencia a la web-----------------------------------------------

   if !empty( nCodigoWeb )
      ::TPrestashopId:setValueCategory( hget( hFamiliaData, "id" ), ::getCurrentWebName(), nCodigoWeb )
   end if 

return nCodigoWeb

//---------------------------------------------------------------------------//

METHOD buildActualizaCatergoriaPadrePrestashop( hFamiliaData ) CLASS TComercio

   local lReturn     := .f.
   local cCommand    := ""
   local nParent     := 2

   /*
   Actualizamos las familias padre en prestashop-------------------------------
   */

   nParent           := ::TPrestashopId:getValueCategory( hGet( hFamiliaData, "id_parent" ), ::getCurrentWebName(), 2 )

   if ::oFam:SeekInOrd( hGet( hFamiliaData, "id" ), "cCodFam" )

      cCommand       := "UPDATE " + ::cPrefixTable( "category" ) + " " + ;
                           "SET id_parent = '" + alltrim( str( nParent ) ) + "' " + ;
                        "WHERE id_category = " + alltrim( str( ::TPrestashopId:getValueCategory( hGet( hFamiliaData, "id" ), ::getCurrentWebName() ) ) )

      ::writeText( cCommand )

      lReturn        := TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   end if

   SysRefresh()

Return lReturn

//---------------------------------------------------------------------------//

METHOD buildRecalculaPosicionesCategoriasPrestashop() CLASS TComercio

   local nPos              := 0
   local nContador         := 2
   local oCategoria
   local oCat
   local oCat2
   local oQuery         
   local nTotalCategory
   local nLeft             := 0  
   local nRight            := 0

   /*
   Recorremos el Query con la consulta-----------------------------------------
   */

   oQuery               := TMSQuery():New( ::oCon, 'SELECT * FROM ' + ::cPrefixTable( "category" ) )
   if oQuery:Open()

      nTotalCategory    := oQuery:RecCount()

      if nTotalCategory > 0

         oQuery:GoTop()

         while !oQuery:Eof()

            do case
               case oQuery:FieldGet( 1 ) == 1

                  if !TMSCommand():New( ::oCon ):ExecDirect( "UPDATE " + ::cPrefixTable( "category" ) + " SET nLeft='1', nRight='" + alltrim( str( nTotalCategory * 2 ) ) + "' WHERE id_category=1" )
                     ::writeText( "Error al actualizar el grupo de familia en la tabla category", 3 )
                  end if

               case oQuery:FieldGet( 1 ) == 2

                  if !TMSCommand():New( ::oCon ):ExecDirect( "UPDATE " + ::cPrefixTable( "category" ) + " SET nLeft='2', nRight='" + alltrim( str( ( nTotalCategory * 2 ) -1 ) ) + "' WHERE id_category=2" )
                     ::writeText( "Error al actualizar el grupo de familia en la tabla category", 3 )
                  end if

               otherwise

                  nLeft    := ++nContador
                  nRight   := ++nContador

                  if !TMSCommand():New( ::oCon ):ExecDirect( "UPDATE " + ::cPrefixTable( "category" ) + " SET nLeft='" + alltrim( str( nLeft ) ) + "', nRight='" + alltrim( str( nRight ) ) + "' WHERE id_category=" + alltrim( str( oQuery:FieldGet( 1 ) ) ) )
                     ::writeText( "Error al actualizar el grupo de familia en la tabla category", 3 )
                  end if

            end case               

            oQuery:Skip()

         end while

      else 

         ::meterProcesoText( "No hay elementos en la categoría" )

      end if

   else 

      ::meterProcesoText( "Error al ejecutar " + "SELECT * FROM " + ::cPrefixTable( "category" ) )

   end if

return ( .t. )

//---------------------------------------------------------------------------//

METHOD BuildInsertProductsPrestashop( hProduct ) CLASS TComercio

   local cCodigoFamilia
   local nCodigoWeb           := 0
   local nCodigoImagen        := 0
   local oImagen
   local nOrdAnt
   local nPosition            := 1
   local nCodigoPropiedad     := 0
   local aPropiedades1        := {}
   local aPropiedades2        := {}
   local aPropiedad1
   local aPropiedad2
   local nPrecio              := 0
   local nParent              
   local cCommand             := ""
   local nTotStock
   local idTaxRuleGroup        

   cCodigoFamilia             := hGet( hProduct, "id_category_default" )
   nParent                    := ::TPrestashopId:getValueCategory( cCodigoFamilia, ::getCurrentWebName(), 2 )
   idTaxRuleGroup             := ::TPrestashopId:getValueTaxRuleGroup( hGet( hProduct, "id_tax_rules_group" ), ::getCurrentWebName() )

   ::writeText( "Añadiendo artículo: " + hGet( hProduct, "description" ) )

   /*
   Vemos el precio del artículo------------------------------------------------
   */

   cCommand    := "INSERT INTO " + ::cPrefixTable( "product" ) + " ( " + ;
                     "id_manufacturer, " + ;
                     "id_tax_rules_group, " + ;
                     "id_category_default, " + ;
                     "id_shop_default, " + ;
                     "quantity, " + ;
                     "minimal_quantity, " + ;
                     "price, " + ;
                     "reference, " + ;
                     "weight, " + ;
                     "active, " + ;
                     "date_add, " + ;
                     "date_upd ) " + ;
                  "VALUES ( " + ;
                     "'" + alltrim( str( ::TPrestashopId:getValueManufacturer( hGet( hProduct, "id_manufacturer" ), ::getCurrentWebName() ) ) ) + "', " + ; //id_manufacturer
                     "'" + alltrim( str( idTaxRuleGroup ) ) + "', " + ;                                           //id_tax_rules_group  - tipo IVA
                     "'" + alltrim( str( nParent ) ) + "', " + ;                                                  //id_category_default
                     "'1', " + ;                                                                                  //id_shop_default
                     "'1', " + ;                                                                                  //quantity
                     "'1', " + ;                                                                                  //minimal_quantity
                     "'" + alltrim( str( hGet( hProduct, "price" ) ) ) + "', " + ;                           //price
                     "'" + alltrim( hGet( hProduct, "id" ) ) + "', " + ;                                     //reference
                     "'" + alltrim( str( hGet( hProduct, "weight" ) ) ) + "', " + ;                          //weight
                     "'1', " + ;                                                                                  //active
                     "'" + dtos( GetSysDate() ) + "', " + ;                                                       //date_add
                     "'" + dtos( GetSysDate() ) + "' )"

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand ) 

      nCodigoWeb  := ::oCon:GetInsertId()
      
      if !empty( nCodigoWeb )
         ::TPrestashopId:setValueProduct( hGet( hProduct, "id" ), ::getCurrentWebName(), nCodigoWeb )
      end if 

   else
      
      ::writeText( "Error al insertar el artículo " + hGet( hProduct, "name" ) + " en la tabla " + ::cPrefixTable( "product" ), 3 )

      Return ( .f. )

   end if

   // Insertamos un artículo nuevo en la tabla category_product----------------

   ::buildInsertNodeCategoryProduct( cCodigoFamilia, nCodigoWeb )

   // Publicar el articulo en el root------------------------------------------

   if hGet( hProduct, "lPublicRoot" )
      ::buildInsertCategoryProduct( 2, nCodigoWeb )
   end if

   // Insertamos un artículo nuevo en la tabla category_shop----------------------

   cCommand    := "INSERT INTO " + ::cPrefixTable( "product_shop" ) + " ( " +;
                     "id_product, " + ;
                     "id_shop, " + ;
                     "id_category_default, " + ;
                     "id_tax_rules_group, " + ;
                     "on_sale, " + ;
                     "price, " + ;
                     "active, " + ;
                     "date_add, " + ;
                     "date_upd )" + ;
                  " VALUES ( " + ;
                     "'" + str( nCodigoWeb ) + "', " + ;
                     "'1', " + ;
                     "'" + alltrim( str( nParent ) ) + "', " + ;
                     "'" + alltrim( str( idTaxRuleGroup ) ) + "', " + ;
                     "'0', " + ;
                     "'" + alltrim( str( hGet( hProduct, "price" ) ) ) + "', " + ;
                     "'1', " + ;
                     "'" + dtos( GetSysDate() ) + "', " + ;
                     "'" + dtos( GetSysDate() ) + "' )"

   if !TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( "Error al insertar el artículo " + hGet( hProduct, "name" ) + " en la tabla " + ::cPrefixTable( "product_shop" ), 3 )
   end if

   /*
   Insertamos un artículo nuevo en la tabla product_lang--------------------
   */

   cCommand    := "INSERT INTO " + ::cPrefixTable( "product_lang" ) + " ( " +;
                     "id_product, " + ;
                     "id_lang, " + ;
                     "description, " + ;
                     "description_short, " + ;
                     "link_rewrite, " + ;
                     "meta_title, " + ;
                     "meta_description, " + ;
                     "meta_keywords, " + ;
                     "name, " + ;
                     "available_now, " + ;
                     "available_later )" + ;
                  " VALUES ( " + ;
                     "'" + str( nCodigoWeb ) + "', " + ;                            // id_product
                     "'" + str( ::nLanguage ) + "', " + ;                           // id_lang
                     "'" + ::oCon:Escapestr( hGet( hProduct, "description" ) ) + "', " + ;        // description
                     "'" + hGet( hProduct, "description_short" ) + "', " + ;   // description_short
                     "'" + hGet( hProduct, "link_rewrite" ) + "', " + ;        // link_rewrite
                     "'" + hGet( hProduct, "meta_title" ) + "', " + ;          // Meta_título
                     "'" + hGet( hProduct, "meta_description" ) + "', " + ;    // Meta_description
                     "'" + hGet( hProduct, "meta_keywords" ) + "', " + ;       // Meta_keywords
                     "'" + hGet( hProduct, "name" ) + "', " + ;                // name
                     "'En stock', " + ;                                             // avatible_now
                     "'' )"

   if !TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( "Error al insertar el artículo " + hGet( hProduct, "name" ) + " en la tabla " + ::cPrefixTable( "product_lang" ), 3 )
   end if

   sysrefresh()

   ::writeText( "Añadiendo imágenes artículo: " + hGet( hProduct, "name" ) )

   ::buildInsertImageProductsPrestashop( hProduct, nCodigoWeb )

   sysrefresh()

   ::writeText( "Añadiendo propiedades del artículo: " + hGet( hProduct, "name" ) )

   ::buildInsertPropiedadesProductPrestashop( hProduct, nCodigoWeb )

   sysrefresh()

   ::writeText( "Añadiendo ofertas del artículo: " + hGet( hProduct, "name" ) )

   ::buildInsertOfertasPrestashop( hProduct, nCodigoWeb )

   ::writeText( "Añadiendo stock del artículo: " + hGet( hProduct, "name" ) )

   ::uploadStockToPrestashop( hGet( hProduct, "aStock") )

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD buildInsertNodeCategoryProduct( idFamilia, idProduct ) CLASS TComercio

   local idCategory
   local cNodeFamilia

   idCategory                 := ::buildGetParentCategories( idFamilia )

   ::buildInsertCategoryProduct( idCategory, idProduct ) 

   cNodeFamilia               := ::buildGetNodeParentCategories( idFamilia )
   if !empty( cNodeFamilia )
      ::buildInsertNodeCategoryProduct( cNodeFamilia, idProduct )
   end if 

Return ( nil )

//---------------------------------------------------------------------------//
/*
Insertamos un artículo nuevo en la tabla category_product----------------
*/

METHOD buildInsertCategoryProduct( idCategory, idProduct ) CLASS TComercio

   local cCommand := "INSERT INTO " + ::cPrefixTable( "category_product" ) + " ( " + ;
                        "id_category, " + ;
                        "id_product ) " + ;
                     "VALUES ( " + ;
                        "'" + alltrim( str( max( idCategory, 1 ) ) ) + "', " + ;
                        "'" + str( idProduct ) + "' )"

   if !TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( "Error al insertar el artículo " + str( idProduct ) + " en la tabla " + ::cPrefixTable( "category_product" ), 3 )
      Return ( .f. )
   end if

Return ( .t. )

//---------------------------------------------------------------------------//
/*
insertamos imagenes del artículo en concreto--------------------------------
*/

METHOD buildInsertImageProductsPrestashop( hProduct, idProductPrestashop ) CLASS TComercio

   local idImagenPrestashop   := 0
   local oImagen
   local hImage
   local nImagePosition       := 1

   for each hImage in hGet( hProduct, "aImages" )

      idImagenPrestashop      := ::insertImageProductPrestashop( hProduct, hImage, idProductPrestashop, nImagePosition )

      if idImagenPrestashop != 0

         ::insertImageProductPrestashopLang( hProduct, hImage, idImagenPrestashop )

         ::insertImageProductPrestashopShop( hProduct, hImage, idProductPrestashop, idImagenPrestashop )

         // Añadimos la imagen al array para subirla a prestashop--------------

         hSet( hImage, "nTipoImagen", tipoProducto )
         hSet( hImage, "cCarpeta", alltrim( str( idImagenPrestashop ) ) )
         hSet( hImage, "cPrefijoNombre", alltrim( str( idImagenPrestashop ) ) )
         hSet( hImage, "aTypeImages", {} )

      end if 

      nImagePosition++

   next

Return .t.

//---------------------------------------------------------------------------//

METHOD buildInsertOfertasPrestashop( hProduct, nCodigoWeb ) CLASS TComercio

   local cCommand       := ""

   if hGet( hProduct, "specific_price" ) .and. hGet( hProduct, "reduction" ) != 0

      cCommand          := "INSERT INTO " + ::cPrefixTable( "specific_price" ) + " ( " + ; 
                              "id_specific_price_rule, " + ;
                              "id_cart, " + ;
                              "id_product, " + ;
                              "id_shop, " + ;
                              "id_shop_group, " + ;
                              "id_currency, " + ;
                              "id_country, " + ;
                              "id_group, " + ;
                              "id_customer, " + ;
                              "id_product_attribute, " + ;
                              "price, " + ;
                              "from_quantity, " + ;
                              "reduction, " + ;
                              if( ::lSpecificPriceIdColumnReductionTax, "reduction_tax, ", "" ) + ;
                              "reduction_type ) " + ;
                           "VALUES ( " + ;
                              "'0', " + ;                                                                                                                // id_specific_price_rule
                              "'0', " + ;                                                                                                                // id_cart
                              "'" + alltrim( str( nCodigoWeb ) ) + "', " + ;                                                                             // id_product
                              "'1', " + ;                                                                                                                // id_shop
                              "'0', " + ;                                                                                                                // id_shop_group
                              "'0', " + ;                                                                                                                // id_currency
                              "'0', " + ;                                                                                                                // id_country
                              "'0', " + ;                                                                                                                // id_group
                              "'0', " + ;                                                                                                                // id_customer
                              "'0', " + ;                                                                                                                // id_product_attribute
                              "'-1', " + ;                                                                                                               // price
                              "'1', " + ;                                                                                                                // from_quantity
                              "'" + alltrim( str( hGet( hProduct, "reduction" ) ) ) + "', " + ;                                                     // reduction
                              if( ::lSpecificPriceIdColumnReductionTax, "'" + alltrim( str( hGet( hProduct, "reduction_tax" ) ) ) + "', ", "" ) + ; // reduction_tax
                              "'amount' )"                                                                                                               // reduction_type
   
      if !TMSCommand():New( ::oCon ):ExecDirect( cCommand )
         ::writeText( "Error al insertar una oferta de " + hGet( hProduct, "name" ), 3 )
      end if

   end if

return nil

//---------------------------------------------------------------------------//

METHOD buildInsertPropiedadesPrestashop( hPropiedadesCabData ) CLASS TComercio

   local idPrestashop      := 0
   local cCommand          := ""

   /*
   Insertamos una propiedad nueva en las tablas de prestashop-----------------
   */

   cCommand                := "INSERT INTO " + ::cPrefixTable( "attribute_group" ) + " ( " +; 
                                 "is_color_group, " + ;
                                 "group_type ) " + ;
                              "VALUES ( " + ;
                                 "'" + if( hGet( hPropiedadesCabData, "lColor" ), "1", "0" ) + "', " + ;         // is_color_group
                                 "'" + if( hGet( hPropiedadesCabData, "lColor" ), "color", "select" ) + "' )"    // group_type                        

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      idPrestashop         := ::oCon:GetInsertId()
   else
      ::writeText( "Error al insertar la propiedad " + hGet( hPropiedadesCabData, "name" ) + " en la tabla " + ::cPrefixTable( "attribute_group" ), 3 )
   end if

   if !empty( idPrestashop )
      cCommand             := "INSERT INTO " + ::cPrefixTable( "attribute_group_lang" ) + " ( " + ; 
                                 "id_attribute_group, " + ;
                                 "id_lang, " + ;
                                 "name, " + ;
                                 "public_name ) " + ;
                              "VALUES ( " + ;
                                 "'" + alltrim( str( idPrestashop ) ) + "', " + ;        //id_attribute_group
                                 "'" + str( ::nLanguage ) + "', " + ;                  //id_lang
                                 "'" + hGet( hPropiedadesCabData, "name" ) + "', " + ; //name
                                 "'" + hGet( hPropiedadesCabData, "name" ) + "' )"     //public_name

      if !TMSCommand():New( ::oCon ):ExecDirect( cCommand )
         ::writeText( "Error al insertar la propiedad " + hGet( hPropiedadesCabData, "name" ) + " en la tabla " + ::cPrefixTable( "attribute_group_lang" ), 3 )
      end if

      // Guardo referencia a la web-----------------------------------------------

      ::TPrestashopId:setValueAttributeGroup( hget( hPropiedadesCabData, "id" ), ::getCurrentWebName(), idPrestashop )

   end if 

Return self

//---------------------------------------------------------------------------//

METHOD buildInsertLineasPropiedadesPrestashop( hPropiedadesLinData, nPosition ) CLASS TComercio

   local nCodigoPropiedad  := 0
   local cCommand          := ""
   local nCodigoGrupo      := ::TPrestashopId:getValueAttributeGroup( hGet( hPropiedadesLinData, "idparent" ), ::getCurrentWebName() )

   /*
   Introducimos las líneas-----------------------------------------------------
   */

   cCommand                := "INSERT INTO " + ::cPrefixTable( "attribute" ) + " ( " + ; 
                                 "id_attribute_group, " + ;
                                 "color, " + ;
                                 "position ) " + ;
                              "VALUES ( " + ;
                                 "'" + alltrim( str( nCodigoGrupo ) ) + "', " + ;
                                 "'" + hGet( hPropiedadesLinData, "color" ) + "' ," + ;
                                 "'" + alltrim( str( nPosition ) ) + "' )"             // posicion

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      nCodigoPropiedad   := ::oCon:GetInsertId()
   else
      ::writeText( "Error al insertar la propiedad " + hGet( hPropiedadesLinData, "name" ) + " en la tabla " + ::cPreFixtable( "attribute" ), 3 )
   end if

   if !empty( nCodigoPropiedad )

      cCommand    := "INSERT INTO " + ::cPrefixTable( "attribute_lang" ) + " ( " + ;
                        "id_attribute, " + ;
                        "id_lang, " + ;
                        "name ) " + ;
                     "VALUES ( " + ;
                        "'" + alltrim( str( nCodigoPropiedad ) ) + "', " + ;                    //id_attribute
                        "'" + str( ::nLanguage ) + "', " + ;                                    //id_lang
                        "'" + ::oCon:Escapestr( hGet( hPropiedadesLinData, "name" ) ) + "' )"   //name

      if !TMSCommand():New( ::oCon ):ExecDirect( cCommand )
         ::writeText( "Error al insertar la propiedad " + hGet( hPropiedadesLinData, "name" ) + " en la tabla " + ::cPrefixTable( "attribute_lang" ), 3 )
      end if

      cCommand    := "INSERT INTO " + ::cPrefixTable( "attribute_shop" ) + " ( " + ;
                        "id_attribute, " + ;
                        "id_shop ) " + ;
                     "VALUES ( " + ;
                        "'" + alltrim( str( nCodigoPropiedad ) ) + "', " + ;   //id_attribute
                        "'1' )"                                                 //id_shop

      if !TMSCommand():New( ::oCon ):ExecDirect( cCommand )
         ::writeText( "Error al insertar la propiedad " + hGet( hPropiedadesLinData, "name" ) + " en la tabla " + ::cPrefixTable( "attribute_shop" ), 3 )
      end if

      // Guardo referencia a la web-----------------------------------------------

      ::TPrestashopId:setValueAttribute( hGet( hPropiedadesLinData, "idparent" ) + hGet( hPropiedadesLinData, "id" ), ::getCurrentWebName(), nCodigoPropiedad )
   end if 

Return ( self )

//---------------------------------------------------------------------------//

METHOD buildInsertImageProductsByProperties( hProduct, idProductAttribute )

   local cImage
   local aImages
   local cCommand
   local nIdProductImage

   aImages                 := hget( hProduct, "aImages")
   
   if empty( aImages )
      Return ( self )
   end if 

   for each cImage in aImages

      if ::oArtImg:SeekInOrd( hGet( hProduct, "id" ), "cCodArt" )

         while ::oArtImg:cCodArt == hGet( hProduct, "id" ) .and. !::oArtImg:Eof()

            if alltrim( ::oArtImg:cImgArt ) == alltrim( cImage )

               nIdProductImage   := ::TPrestashopId:getValueImage( hGet( hProduct, "id" ) + str( ::oArtImg:nId, 10 ), ::getCurrentWebName() )

               cCommand          := "INSERT INTO " + ::cPrefixTable( "product_attribute_image" ) + " ( " + ;
                                       "id_product_attribute, " + ;
                                       "id_image )" + ;
                                    "VALUES ( " + ;
                                       "'" + alltrim( str( idProductAttribute ) ) + "', " + ;      // id_product_attribute
                                       "'" + alltrim( str( nIdProductImage ) ) + "' )"             // id_image

               if !TMSCommand():New( ::oCon ):ExecDirect( cCommand )
                  ::writeText( "Error al insertar el artículo " + hGet( hProduct, "name" ) + " en la tabla " + ::cPrefixTable( "product_attribute_image" ), 3 )
               end if

            end if   

            ::oArtImg:Skip()

         end while   

      end if

   next   

Return ( self )

//---------------------------------------------------------------------------//

METHOD buildInsertPropiedadesProductPrestashop( hProduct, nCodigoWeb ) CLASS TComercio

   local oImagen
   local cImage
   local aImages
   local nPosition            := 1
   local nCodigoImagen        := 0
   local nCodigoPropiedad     := 0
   local nIdProductImage
   local aPropiedades1        := {}
   local aPropiedades2        := {}
   local aPropiedad1
   local aPropiedad2
   local nOrdAnt
   local nPrecio              := 0
   local nParent              := ::buildGetParentCategories( hGet( hProduct, "id_category_default" ) )
   local cCommand             := ""
   local nOrdArtDiv           := ::oArtDiv:OrdSetFocus( "cCodArt" )
   local lDefault             := .t.

   // Comprobamos si el artículo tiene propiedades y metemos las propiedades

   if ::oArtDiv:Seek( hGet( hProduct, "id" ) )

      while ::oArtDiv:cCodArt == hGet( hProduct, "id" ) .and. !::oArtDiv:Eof()

         // Caso de tener una sola propiedad-----------------------------------

         do case
            case !empty( ::oArtDiv:cValPr1 ) .and. empty( ::oArtDiv:cValPr2 )

               nPrecio           := nPrePro( hGet( hProduct, "id" ), ::oArtDiv:cCodPr1, ::oArtDiv:cValPr1, space( 20 ), space( 20 ), 1, .f., ::oArtDiv:cAlias )

               nCodigoPropiedad  := ::insertProductAttributePrestashop( hProduct, nCodigoWeb, nPrecio )

               // Metemos la relación de la propiedad1 con el artículo------------

               ::insertProductAttributeCombinationPrestashop( ::oArtDiv:cCodPr1, ::oArtDiv:cValPr1, nCodigoPropiedad )
               
               // Metemos la relación entre la propiedad y el shop-------------

               ::insertProductAttributeShopPrestashop( lDefault, nCodigoWeb, nCodigoPropiedad, nPrecio )

               // Imágenes para dos propiedades-----------------------------------

               ::buildInsertImageProductsByProperties( hProduct, nCodigoPropiedad )

            // Caso de tener dos propiedades--------------------------------------

            case !empty( ::oArtDiv:cValPr1 ) .and. !empty( ::oArtDiv:cValPr2 )

               nPrecio           := nPrePro( hGet( hProduct, "id" ), ::oArtDiv:cCodPr1, ::oArtDiv:cValPr1, ::oArtDiv:cCodPr2, ::oArtDiv:cValPr2, 1, .f., ::oArtDiv:cAlias )

               nCodigoPropiedad  := ::insertProductAttributePrestashop( hProduct, nCodigoWeb, nPrecio )

               // Metemos la relación de la propiedad1 con el artículo------------

               ::insertProductAttributeCombinationPrestashop( ::oArtDiv:cCodPr1, ::oArtDiv:cValPr1, nCodigoPropiedad )
               
               // Metemos la relación de la propiedad 2 con el artículo-----------

               ::insertProductAttributeCombinationPrestashop( ::oArtDiv:cCodPr2, ::oArtDiv:cValPr2, nCodigoPropiedad )

               // Metemos la relación entre la propiedad y el shop-------------

               ::insertProductAttributeShopPrestashop( lDefault, nCodigoWeb, nCodigoPropiedad, nPrecio )

               // Imágenes para dos propiedades-----------------------------------

               ::buildInsertImageProductsByProperties( hProduct, nCodigoPropiedad )

         end case

         ::oArtDiv:Skip()

         lDefault    := .f.

      end while

   end if

   ::oArtDiv:OrdSetFocus( nOrdArtDiv )

Return ( self )

//---------------------------------------------------------------------------//

METHOD insertProductAttributePrestashop( hProduct, nCodigoWeb, nPrecio ) CLASS TComercio

   local cCommand
   local idProductAttribute   := 0

   // Metemos la propiedad de éste artículo---------------------------

   cCommand := "INSERT INTO " + ::cPrefixTable( "product_attribute" ) + " ( "                                     + ;
                  if( ::lProductIdColumnProductAttribute, "id_product, ", "" )                                    + ;
                  "price, "                                                                                       + ;
                  "wholesale_price, "                                                                             + ;
                  "quantity, "                                                                                    + ;
                  "minimal_quantity ) "                                                                           + ;
               "VALUES ( "                                                                                        + ;
                  if( ::lProductIdColumnProductAttribute, "'" + alltrim( str( nCodigoWeb ) ) + "', ", "" )        + ;      //id_product
                  "'" + alltrim( str( nPrecio ) ) + "', "                                                         + ;      //price
                  "'" + alltrim( str( nPrecio ) ) + "', "                                                         + ;      //wholesale_price
                  "'10000', "                                                                                     + ;      //quantity
                  "'1' )"                                                                                                  //minimal_quantity

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      idProductAttribute      := ::oCon:GetInsertId()
   else
      ::writeText( "Error al insertar la propiedad " + alltrim( ::oArtDiv:cValPr1 ) + " - " + alltrim( ::oArtDiv:cValPr2 ) + " en la tabla " + ::cPrefixTable( "product_attribute" ), 3 )
   end if

Return ( idProductAttribute )

//---------------------------------------------------------------------------//

METHOD insertProductAttributeCombinationPrestashop( idFirstProperty, valueFirstProperty, nCodigoPropiedad ) CLASS TComercio

   local cCommand

   if !( ::oTblPro:seekInOrd( upper( idFirstProperty ) + upper( valueFirstProperty ), "cCodPro" ) )
      ::writeText( "Error al buscar en tabla de propiedades " + alltrim( idFirstProperty ) + " : " + alltrim( valueFirstProperty ), 3 )
      Return .f.
   end if 

   cCommand := "INSERT INTO " +  ::cPrefixtable( "product_attribute_combination" ) + "( " + ;
                  "id_attribute, "                                                        + ;
                  "id_product_attribute ) "                                               + ;
               "VALUES ("                                                                 + ;
                  "'" + alltrim( str( ::TPrestashopId:getValueAttribute( idFirstProperty + valueFirstProperty, ::getCurrentWebName() ) ) ) + "', " + ;  //id_attribute
                  "'" + alltrim( str( nCodigoPropiedad ) ) + "' )"                        //id_product_attribute

   if !TMSCommand():New( ::oCon ):ExecDirect( cCommand ) 
      ::writeText( "Error al insertar la propiedad " + alltrim( ::oTblPro:cDesTbl ) + " en la tabla " + ::PrefixTable( "product_attribute_combination" ), 3 )
   end if

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD insertProductAttributeShopPrestashop( lDefault, nCodigoWeb, nCodigoPropiedad, nPrecio ) CLASS TComercio

   local cCommand := "INSERT INTO " + ::cPrefixTable( "product_attribute_shop" ) + " ( "  + ;
                        if( ::isProductIdColumnProductAttributeShop, "id_product, ", "" ) + ;
                        "id_product_attribute, "                                          + ;
                        "id_shop, "                                                       + ;
                        "wholesale_price, "                                               + ;
                        "price, "                                                         + ;
                        "ecotax, "                                                        + ;
                        "weight, "                                                        + ;
                        "unit_price_impact, "                                             + ;
                        if( lDefault, "default_on, ", "" )                                + ;
                        "minimal_quantity ) "                                             + ;
                     "VALUES ( "                                                          + ;
                        if( ::isProductIdColumnProductAttributeShop, "'" + alltrim( str( nCodigoWeb ) ) + "', ", "" ) + ;  // id_product
                        "'" + alltrim( str( nCodigoPropiedad ) )                  + "', " + ;
                        "'1', "                                                           + ;
                        "'" + alltrim( str( nPrecio ) ) + "', "                           + ;
                        "'" + alltrim( str( nPrecio ) ) + "', "                           + ;
                        "'0', "                                                           + ;
                        "'0', "                                                           + ;
                        "'0', "                                                           + ;
                        if( lDefault, "'1',", "" )                                        + ;
                        "'1' )"

   if !TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( "Error al insertar la propiedad " + alltrim( ::oTblPro:cDesTbl ) + " en la tabla " + ::cPrefixTable( "product_attribute_shop" ), 3 )
   end if

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD buildEliminaTablas() CLASS TComercio

   local cCommand

   /*
   Vaciamos las tablas de tipos de Iva-----------------------------------------
   */

   if TMSCommand():New( ::oCon ):ExecDirect( "TRUNCATE TABLE " + ::cPreFixtable( "tax" ) )
      ::writeText( 'Tabla ' + ::cPreFixtable( "tax" ) + ' borrada correctamente', 3  )
   else
      ::writeText( 'Error al borrar la tabla ' + ::cPreFixtable( "tax" ), 3  )
   end if

   if TMSCommand():New( ::oCon ):ExecDirect( "TRUNCATE TABLE " + ::cPreFixtable( "tax_lang" ) )
      ::writeText( 'Tabla ' + ::cPreFixtable( "tax_lang" ) + ' borrada correctamente', 3  )
   else
      ::writeText( 'Error al borrar la tabla ' + ::cPreFixtable( "tax_lang" ), 3  )
   end if

   if TMSCommand():New( ::oCon ):ExecDirect( "TRUNCATE TABLE " + ::cPreFixtable( "tax_rule" ) )
      ::writeText( 'Tabla ' + ::cPreFixtable( "tax_rule" ) + ' borrada correctamente', 3  )
   else
      ::writeText( 'Error al borrar la tabla ' + ::cPreFixtable( "tax_rule" ), 3  )
   end if

   if TMSCommand():New( ::oCon ):ExecDirect( "TRUNCATE TABLE " + ::cPreFixtable( "tax_rules_group" ) )
      ::writeText( 'Tabla ' + ::cPreFixtable( "tax_rules_group" ) + ' borrada correctamente', 3  )
   else
      ::writeText( 'Error al borrar la tabla ' + ::cPreFixtable( "tax_rules_group" ), 3  )
   end if

   if TMSCommand():New( ::oCon ):ExecDirect( "TRUNCATE TABLE " + ::cPreFixtable( "tax_rules_group_shop" ) )
      ::writeText( 'Tabla ' + ::cPreFixtable( "tax_rules_group_shop" ) + ' borrada correctamente', 3  )
   else
      ::writeText( 'Error al borrar la tabla ' + ::cPreFixtable( "tax_rules_group_shop" ), 3  )
   end if

   /*
   Vaciamos las tablas de fabricantes------------------------------------------
   */

   if TMSCommand():New( ::oCon ):ExecDirect( "TRUNCATE TABLE " + ::cPrefixTable( "manufacturer" ) )
      ::writeText( 'Tabla ' + ::cPrefixTable( "manufacturer" ) + ' borrada correctamente', 3  )
   else
      ::writeText( 'Error al borrar la tabla ' + ::cPrefixTable( "manufacturer" ), 3  )
   end if

   if TMSCommand():New( ::oCon ):ExecDirect( "TRUNCATE TABLE " + ::cPrefixTable( "manufacturer_shop" ) )
      ::writeText( 'Tabla ' + ::cPrefixTable( "manufacturer_shop" ) + ' borrada correctamente', 3 )
   else
      ::writeText( 'Error al borrar la tabla ' + ::cPreFixtable( "manufacturer_shop" ), 3 )
   end if

   if TMSCommand():New( ::oCon ):ExecDirect( "TRUNCATE TABLE " + ::cPrefixTable( "manufacturer_lang" ) )
      ::writeText( 'Tabla ' + ::cPrefixTable( "manufacturer_lang" ) + ' borrada correctamente', 3  )
   else
      ::writeText( 'Error al borrar la tabla ' + ::cPrefixTable( "manufacturer_lang" ), 3  )
   end if

   /*
   Vaciamos las tablas de Categorias-------------------------------------------
   */

   cCommand       := "TRUNCATE TABLE " + ::cPrefixtable( "category" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( 'Tabla ' + ::cPreFixtable( "category" ) + ' borrada correctamente', 3  )
   else
      ::writeText( 'Error al borrar la tabla ' + ::cPreFixtable( "category" ), 3  )
   end if

   cCommand       := "TRUNCATE TABLE " + ::cPrefixTable( "category_lang" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( 'Tabla ' + ::cPrefixTable( "category_lang" ) + ' borrada correctamente', 3  )
   else
      ::writeText( 'Error al borrar la tabla ' + ::cPrefixTable( "category_lang" ), 3  )
   end if

   cCommand       := "TRUNCATE TABLE " + ::cPrefixTable( "category_product" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( 'Tabla ' + ::cPrefixTable( "category_product" ) + ' borrada correctamente', 3  )
   else
      ::writeText( 'Error al borrar la tabla ' + ::cPrefixTable( "category_product" ), 3  )
   end if

   cCommand       := "TRUNCATE TABLE " + ::cPrefixTable( "category_group" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( 'Tabla ' + ::cPrefixTable( "category_group" ) + ' borrada correctamente', 3  )
   else
      ::writeText( 'Error al borrar la tabla ' + ::cPrefixTable( "category_group" ), 3  )
   end if

   cCommand       := "TRUNCATE TABLE " + ::cPrefixTable( "category_shop" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( 'Tabla ' + ::cPrefixTable( "category_shop" ) + ' borrada correctamente', 3  )
   else
      ::writeText( 'Error al borrar la tabla '+ ::cPrefixTable( "category_group" ), 3  )
   end if

   cCommand       := "TRUNCATE TABLE " + ::cPrefixTable( "image" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( 'Tabla ' + ::cPrefixTable( "image" ) + 'borrada correctamente', 3  )
   else
      ::writeText( 'Error al borrar la tabla' + ::cPrefixTable( "image" ), 3  )
   end if

   cCommand       := "TRUNCATE TABLE " + ::cPrefixTable( "image_shop" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( 'Tabla ' + ::cPrefixTable( "image_shop" ) + ' borrada correctamente', 3  )
   else
      ::writeText( 'Error al borrar la tabla '+ ::cPrefixTable( "image_shop" ), 3  )
   end if

   cCommand       := "TRUNCATE TABLE " + ::cPrefixTable( "image_lang" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( 'Tabla ' + ::cPrefixTable( "image_lang" ) + ' borrada correctamente', 3  )
   else
      ::writeText( 'Error al borrar la tabla ' + ::cPrefixTable( "image_lang" ), 3  )
   end if

   /*
   Cargamos la categoría raiz de la que colgarán todas las demás---------------
   */

   ::insertRootCategory()

   /*
   Vaciamos las tablas de propiedades------------------------------------------
   */

   cCommand       := "TRUNCATE TABLE " + ::cPrefixTable( "attribute" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( 'Tabla ' + ::cPrefixTable( "attribute" ) + ' borrada correctamente', 3  )
   else
      ::writeText( 'Error al borrar la tabla ' + ::cPrefixTable( "attribute" ), 3  )
   end if

   cCommand       := "TRUNCATE TABLE " + ::cPrefixTable( "attribute_lang" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( 'Tabla ' + ::cPrefixTable( "attribute_lang" ) + ' borrada correctamente', 3  )
   else
      ::writeText( 'Error al borrar la tabla ' + ::cPrefixTable( "attribute_lang" ), 3  )
   end if

   cCommand       := "TRUNCATE TABLE " + ::cPrefixTable( "attribute_shop" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( 'Tabla ' + ::cPrefixTable( "attribute_shop" ) + ' borrada correctamente', 3  )
   else
      ::writeText( 'Error al borrar la tabla ' + ::cPrefixTable( "attribute_shop" ), 3  )
   end if

   cCommand       := "TRUNCATE TABLE " + ::cPrefixTable( "attribute_impact" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( 'Tabla ' + ::cPrefixTable( "attribute_impact" ) + ' borrada correctamente', 3  )
   else
      ::writeText( 'Error al borrar la tabla ' + ::cPrefixTable( "attribute_impact" ), 3  )
   end if

   cCommand       := "TRUNCATE TABLE " + ::cPrefixTable( "attribute_group" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( 'Tabla ' + ::cPrefixTable( "attribute_group" ) + ' borrada correctamente', 3  )
   else
      ::writeText( 'Error al borrar la tabla ' + ::cPrefixTable( "attribute_group" ), 3  )
   end if

   cCommand       := "TRUNCATE TABLE " + ::cPrefixTable( "attribute_group_lang" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( 'Tabla ' + ::cPrefixTable( "attribute_group_lang" ) + ' borrada correctamente', 3  )
   else
      ::writeText( 'Error al borrar la tabla ' + ::cPrefixTable( "attribute_group_lang" ), 3  )
   end if

   /*
   Vaciamos las tablas de Artículos--------------------------------------------
   */

   cCommand          := "TRUNCATE TABLE " + ::cPrefixTable( "product" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( 'Tabla ' + ::cPrefixTable( "product" ) + ' borrada correctamente', 3  )
   else
      ::writeText( 'Error al borrar la tabla ' + ::cPrefixTable( "product" ), 3  )
   end if

   cCommand          := "TRUNCATE TABLE " + ::cPrefixTable( "product_attachment" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( 'Tabla ' + ::cPrefixTable( "product_attachment" ) + ' borrada correctamente', 3  )
   else
      ::writeText( 'Error al borrar la tabla ' + ::cPrefixTable( "product_attachment" ), 3  )
   end if

   cCommand          := "TRUNCATE TABLE " + ::cPrefixTable( "product_attribute" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( 'Tabla ' + ::cPrefixTable( "product_attribute" ) + ' borrada correctamente', 3  )
   else
      ::writeText( 'Error al borrar la tabla ' + ::cPrefixTable( "product_attribute" ), 3  )
   end if

   cCommand          := "TRUNCATE TABLE " + ::cPrefixTable( "product_attribute_combination" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( 'Tabla ' + ::cPrefixTable( "product_attribute_combination" ) + ' borrada correctamente', 3  )
   else
      ::writeText( 'Error al borrar la tabla ' + ::cPrefixTable( "product_attribute_combination" ), 3  )
   end if

   cCommand          := "TRUNCATE TABLE " + ::cPrefixTable( "product_attribute_shop" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( 'Tabla ' + ::cPrefixTable( "product_attribute_shop" ) + ' borrada correctamente', 3  )
   else
      ::writeText( 'Error al borrar la tabla ' + ::cPrefixTable( "product_attribute_shop" ), 3  )
   end if

   cCommand          := "TRUNCATE TABLE " + ::cPreFixTable( "product_attribute_image" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( 'Tabla ' + ::cPrefixTable( "product_attribute_image" ) + ' borrada correctamente', 3  )
   else
      ::writeText( 'Error al borrar la tabla ' + ::cPrefixTable( "product_attribute_image" ), 3  )
   end if

   cCommand          := "TRUNCATE TABLE " + ::cPrefixTable( "product_country_tax" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( 'Tabla ' + ::cPrefixTable( "product_country_tax" ) + ' borrada correctamente', 3  )
   else
      ::writeText( 'Error al borrar la tabla ' + ::cPrefixTable( "product_country_tax" ), 3  )
   end if

   cCommand          := "TRUNCATE TABLE " + ::cPrefixTable( "product_download" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( 'Tabla ' + ::cPrefixTable( "product_download" ) + ' borrada correctamente', 3  )
   else
      ::writeText( 'Error al borrar la table ' + ::cPrefixTable( "product_download" ), 3  )
   end if

   cCommand          := "TRUNCATE TABLE " + ::cPrefixTable( "product_group_reduction_cache" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( 'Tabla ' + ::cPrefixTable( "product_group_reduction_cache" ) + ' borrada correctamente', 3  )
   else
      ::writeText( 'Error al borrar la tabla ' + ::cPrefixTable( "product_group_reduction_cache" ), 3  )
   end if

   cCommand          := "TRUNCATE TABLE " + ::cPrefixTable( "product_shop" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( 'Tabla ' + ::cPrefixTable( "product_shop" ) + ' borrada correctamente', 3  )
   else
      ::writeText( 'Error al borrar la tabla ' + ::cPrefixTable( "product_shop" ), 3  )
   end if

   cCommand          := "TRUNCATE TABLE " + ::cPrefixTable( "product_lang" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( 'Tabla ' + ::cPrefixTable( "product_lang" ) + ' borrada correctamente', 3  )
   else
      ::writeText( 'Error al borrar la tabla ' + ::cPrefixTable( "product_lang" ), 3  )
   end if

   cCommand          := "TRUNCATE TABLE " + ::cPrefixTable( "product_sale" ) 

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( 'Tabla ' + ::cPrefixTable( "product_sale" ) + ' borrada correctamente', 3  )
   else
      ::writeText( 'Error al borrar la tabla ' + ::cPrefixTable( "product_sale" ), 3  )
   end if

   cCommand          := "TRUNCATE TABLE " + ::cPrefixTable( "product_tag" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( 'Tabla ' + ::cPrefixTable( "product_tag" ) + ' borrada correctamente', 3  )
   else
      ::writeText( 'Error al borrar la tabla ' + ::cPrefixTable( "product_tag" ), 3  )
   end if

   cCommand          := "TRUNCATE TABLE " + ::cPrefixTable( "specific_price")

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( 'Tabla ' + ::cPrefixTable( "specific_price" ) + ' borrada correctamente', 3  )
   else
      ::writeText( 'Error al borrar la tabla ' + ::cPrefixTable( "specific_price" ), 3  )
   end if

   cCommand          := "TRUNCATE TABLE " + ::cPrefixTable( "feature" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( 'Tabla '  + ::cPrefixTable( "feature" ) + ' borrada correctamente', 3  )
   else
      ::writeText( 'Error al borrar la tabla ' + ::cPrefixTable( "feature" ), 3  )
   end if

   cCommand          := "TRUNCATE TABLE " + ::cPrefixTable( "feature_lang" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( 'Tabla ' + ::cPrefixTable( "feature_lang" ) + ' borrada correctamente', 3  )
   else
      ::writeText( 'Error al borrar la tabla ' + ::cPrefixTable( "feature_lang" ), 3  )
   end if

   cCommand          := "TRUNCATE TABLE " + ::cPrefixTable( "feature_product" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( 'Tabla ' + ::cPrefixTable( "feature_product" ) + ' borrada correctamente', 3  )
   else
      ::writeText( 'Error al borrar la tabla ' + ::cPrefixTable( "feature_product" ), 3  )
   end if

   cCommand          := "TRUNCATE TABLE " + ::cPrefixTable( "feature_value" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( 'Tabla ' + ::cPrefixTable( "feature_value" ) + ' borrada correctamente', 3  )
   else
      ::writeText( 'Error al borrar la tabla ' + ::cPrefixTable( "feature_value" ), 3  )
   end if

   cCommand          := "TRUNCATE TABLE " + ::cPrefixTable( "feature_value_lang" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( 'Tabla ' + ::cPrefixTable( "feature_value_lang" ) + ' borrada correctamente', 3  )
   else
      ::writeText( 'Error al borrar la tabla ' + ::cPrefixTable( "feature_value_lang" ), 3  )
   end if

   cCommand          := "TRUNCATE TABLE " + ::cPrefixTable( "scene" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( 'Tabla ' + ::cPrefixTable( "scene " ) + ' borrada correctamente', 3  )
   else
      ::writeText( 'Error al borrar la tabla ' + ::cPrefixTable( "scene" ), 3  )
   end if

   cCommand          := "TRUNCATE TABLE " + ::cPrefixTable( "scene_category" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( 'Tabla ' + ::cPrefixTable( "scene_category" ) + ' borrada correctamente', 3  )
   else
      ::writeText( 'Error al borrar la tabla' + ::cPrefixTable( "scene_category" ), 3  )
   end if

   cCommand          := "TRUNCATE TABLE " + ::cPrefixTable( "scene_lang" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( 'Tabla ' + ::cPrefixTable( "scene_lang" ) + ' borrada correctamente', 3  )
   else
      ::writeText( 'Error al borrar la tabla ' + ::cPrefixTable( "scene_lang" ), 3  )
   end if

   cCommand          := "TRUNCATE TABLE " + ::cPrefixTable( "scene_products" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( 'Tabla ' + ::cPrefixTable( "scene_products" ) + ' borrada correctamente', 3  )
   else
      ::writeText( 'Error al borrar la tabla ' + ::cPrefixTable( "scene_products" ), 3  )
   end if

   cCommand          := "TRUNCATE TABLE " + ::cPrefixTable( "stock_available" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::writeText( 'Tabla ' + ::cPrefixTable( "stock_available" ) + ' borrada correctamente', 3  )
   else
      ::writeText( 'Error al borrar la tabla ' + ::cPrefixTable( "stock_available" ), 3  )
   end if

   /*
   Limpiamos las referencias de las tablas de gestool--------------------------
   */

   ::buildCleanPrestashop()

Return ( self )

//---------------------------------------------------------------------------//

METHOD DelIdPropiedadesPrestashop() Class TComercio

   local nRec

   /*
   Cabeceras de propiedades----------------------------------------------------
   */

   nRec  := ::oPro:Recno()
   ::oPro:GoTop()

   while !::oPro:Eof()

      ::TPrestashopId:deleteValueAttributeGroup( ::oPro:cCodPro, ::getCurrentWebName() ) 

      ::writeText( 'Eliminando código web en la propiedad ' + alltrim( ::oPro:cDesPro ), 3  )

      ::oPro:Skip()

   end while

   ::oPro:GoTo( nRec )

   /*
   Lineas de propiedades-------------------------------------------------------
   */

   nRec  := ::oTblPro:Recno()
   ::oTblPro:GoTop()

   while !::oTblPro:Eof()

      ::TPrestashopId:deleteValueAttribute( ::oTblPro:cCodPro + ::oTblPro:cCodTbl, ::getCurrentWebName() ) 

      ::writeText( 'Eliminando código web en la propiedad ' + alltrim( ::oTblPro:cDesTbl ), 3  )

      ::oTblPro:Skip()

   end while

   ::oTblPro:GoTo( nRec )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD isAviableWebToExport() Class TComercio

   if !( ::isValidNameWebToExport() )
      Return .f.
   end if 

   if !( ::TPrestashopConfig:setCurrentWebName( ::getWebToExport() ) )
      msgStop( "No se puede poner en uso la web " + ::getWebToExport() )
      Return .f.
   end if 

   if !( ::TPrestashopConfig:isActive() )
      msgStop( "Web " + ::getWebToExport() + " esta actualmente desactivada" )
      Return .f.
   end if 

Return .t.

//---------------------------------------------------------------------------//

METHOD controllerExportPrestashop( idProduct ) Class TComercio

   local oBlock
   local oError

   if !( ::isAviableWebToExport() )
      Return .f.
   end if 

   ::disableDialog()

   oBlock            := ErrorBlock( { | oError | Break( oError ) } )
   BEGIN SEQUENCE

      if ::filesOpen()

         ::MeterTotalSetTotal( 8 )

         ::MeterTotalText( "Eliminando referencias en gestool." )

         ::TComercioProduct:cleanGestoolReferences()

         ::TComercioCategory:cleanGestoolReferences()

         // Construimos la informacion de todos los productos---------------

         ::TComercioProduct:buildAllProductInformation()

         ::buildFTP()

         if ::prestaShopConnect()

            ::prestaShopStart()

            ::TComercioProduct:truncateAllTables()

            ::TComercioCategory:truncateAllTables()

            ::MeterTotalText( "Subiendo la información adicional a los productos." )

            ::TComercioProduct:insertAditionalInformation()

            ::TComercioCategory:insertCategories()   

            // ::TComercioProduct:insertProducts()

            ::prestaShopCommit()

            ::prestaShopDisConnect()

            // subiendo imagenes-----------------------------------------------

            // ::ftpConnect()

            // ::TComercioProduct:uploadImagesToPrestashop()

            // ::ftpDisConnect()

         end if 

         waitSeconds( 30 )

         if ::prestaShopConnect()

            ::prestaShopStart()

            ::TComercioProduct:insertProducts()

            ::prestaShopCommit()

            ::prestaShopDisConnect()

         end if 

         waitSeconds( 30 )

         // subiendo imagenes-----------------------------------------------

         ::ftpConnect()

         ::TComercioProduct:uploadImagesToPrestashop()

         ::ftpDisConnect()

         ::filesClose()

         ::MeterTotalText( "Proceso finalizado." )

      end if
   
   RECOVER USING oError
      msgStop( ErrorMessage( oError ), "Error en modulo Prestashop." )
   END SEQUENCE
   ErrorBlock( oBlock )

   ::EnableDialog()

Return .t.

//---------------------------------------------------------------------------//

METHOD controllerExportOneProductToPrestashop( idProduct ) Class TComercio

   if !( ::isAviableWebToExport() )
      Return .f.
   end if 

   ::oWaitMeter         := TWaitMeter():New( "Actualizando articulos", "Espere por favor..." )
   ::oWaitMeter:Run()

   if ::filesOpen()

      ::buildFTP()

      if ::prestaShopConnect()

         ::prestaShopStart()

         ::TComercioProduct:buildProductInformation( idProduct )

         ::TComercioProduct:insertProducts()

         ::prestaShopCommit()

         ::prestaShopDisConnect()

         // subiendo imagenes-----------------------------------------------

         ::ftpConnect()

         ::TComercioProduct:uploadImagesToPrestashop()

         ::ftpDisConnect()
         
      end if 

      ::filesClose()

   end if

   ::oWaitMeter:End()

Return .t.

//---------------------------------------------------------------------------//

METHOD buildCleanPrestashop() CLASS TComercio

   ::writeText( "Limpiamos las referencias de las tablas de tipos de impuestos" )
   ::TPrestashopId:deleteDocumentValuesTax( ::getCurrentWebName() )
   ::TPrestashopId:deleteDocumentValuesTaxRuleGroup( ::getCurrentWebName() )

   ::writeText( "Limpiamos las referencias de las tablas de fabricantes" )
   ::TPrestashopId:deleteDocumentValuesManufacturer( ::getCurrentWebName() )

   ::writeText( "Limpiamos las referencias de las tablas de familias" )
   ::TPrestashopId:deleteDocumentValuesCategory( ::getCurrentWebName() )

   ::writeText( "Limpiamos las referencias de las tablas de propiedades" )
   ::TPrestashopId:deleteDocumentValuesAttribute( ::getCurrentWebName() )
   ::TPrestashopId:deleteDocumentValuesAttributeGroup( ::getCurrentWebName() )

   ::writeText( "Limpiamos las referencias de las tablas de artículos" )
   ::TPrestashopId:deleteDocumentValuesProduct( ::getCurrentWebName() )

   ::writeText( "Limpiamos las referencias de las imagenes" )
   ::TPrestashopId:deleteDocumentValuesImage( ::getCurrentWebName() )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD buildGetParentCategories( cCodFam ) CLASS TComercio

   local idCategories      := 2

   if ::oFam:Seek( cCodFam ) .and. ::oFam:lPubInt
      idCategories         := ::TPrestashopId:getValueCategory( cCodFam, ::getCurrentWebName() )  
   end if

Return ( idCategories )

//---------------------------------------------------------------------------//

METHOD buildGetNodeParentCategories( cCodFam ) CLASS TComercio

   local idNode            := ""

   if !empty( cCodFam ) .and. ::oFam:Seek( cCodFam )
      idNode               := ::oFam:cFamCmb
   end if   

Return ( idNode )

//---------------------------------------------------------------------------//

METHOD BuildDeleteProductPrestashop( idProduct ) CLASS TComercio

   local oQuery
   local oQuery2
   local alltrimIdProductPrestashop 
   local idDelete                      := 0
   local idDelete2                     := 0
   local cCommand                      := ""

   if empty( ::TPrestashopId:getValueProduct( idProduct, ::getCurrentWebName() ) ) 
      Return ( Self )
   end if 

   alltrimIdProductPrestashop            := alltrim( str( ::TPrestashopId:getValueProduct( idProduct, ::getCurrentWebName() ) ) )

   if empty(alltrimIdProductPrestashop)
      return self
   end if

   ::writeText( "Eliminando artículo de Prestashop" )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "product" ) + " WHERE id_product=" + alltrimIdProductPrestashop
   TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   ::writeText( "Eliminando adjuntos de Prestashop"  )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "product_attachment" ) + " WHERE id_product=" + alltrimIdProductPrestashop
   TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   ::writeText( "Eliminando impuestos de Prestashop"  )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "product_country_tax" ) + " WHERE id_product=" + alltrimIdProductPrestashop
   TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   ::writeText( "Eliminando archivos de Prestashop"  )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "product_download" ) + " WHERE id_product=" + alltrimIdProductPrestashop
   TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   ::writeText( "Eliminando cache de Prestashop"  )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "product_group_reduction_cache" ) + " WHERE id_product=" + alltrimIdProductPrestashop
   TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   ::writeText( "Eliminando multitienda de Prestashop"  )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "product_shop" ) + " WHERE id_product=" + alltrimIdProductPrestashop
   TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   ::writeText( "Eliminando descripciones de Prestashop"  )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "product_lang" ) + " WHERE id_product=" + alltrimIdProductPrestashop
   TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   ::writeText( "Eliminando ofertas de Prestashop"  )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "product_sale" ) + " WHERE id_product=" + alltrimIdProductPrestashop
   TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   ::writeText( "Eliminando etiquetas de Prestashop"  )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "product_tag" ) + " WHERE id_product=" + alltrimIdProductPrestashop
   TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   ::writeText( "Eliminando complementos de Prestashop"  )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "product_supplier" ) + " WHERE id_product=" + alltrimIdProductPrestashop
   TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   ::writeText( "Eliminando transporte de Prestashop"  )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "product_carrier" ) + " WHERE id_product=" + alltrimIdProductPrestashop
   TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   ::writeText( "Eliminando atributos de Prestashop"  )

   cCommand          := 'SELECT * FROM ' + ::cPrefixTable( "product_attribute" ) +  ' WHERE id_product=' + alltrimIdProductPrestashop
   oQuery            := TMSQuery():New( ::oCon, cCommand )
   
   ::writeText( "Eliminando lineas atributos de Prestashop"  )

   if oQuery:Open() .and. oQuery:RecCount() > 0

      oQuery:GoTop()

      while !oQuery:Eof()

         idDelete    := oQuery:FieldGet( 1 )

         if !empty( idDelete )

            cCommand          := "DELETE FROM " + ::cPrefixTable( "product_attribute" ) + " WHERE id_product_attribute=" + alltrim( str( idDelete ) )
            TMSCommand():New( ::oCon ):ExecDirect( cCommand )

            cCommand          := "DELETE FROM " + ::cPrefixTable( "product_attribute_combination" ) + " WHERE id_product_attribute=" + alltrim( str( idDelete ) )
            TMSCommand():New( ::oCon ):ExecDirect( cCommand )

            cCommand          := "DELETE FROM " + ::cPrefixTable( "product_attribute_image" ) + " WHERE id_product_attribute=" + alltrim( str( idDelete ) )
            TMSCommand():New( ::oCon ):ExecDirect( cCommand )

            cCommand          := "DELETE FROM " + ::cPrefixTable( "product_attribute_shop" ) + " WHERE id_product_attribute=" + alltrim( str( idDelete ) )
            TMSCommand():New( ::oCon ):ExecDirect( cCommand )

         end if

         oQuery:Skip()

         SysRefresh()

      end while

   end if

   ::writeText( "Eliminando precios especificos de Prestashop"  )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "specific_price" ) + " WHERE id_product=" + alltrimIdProductPrestashop
   TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   ::writeText( "Eliminando prioridad de precio de Prestashop"  )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "specific_price_priority" ) + " WHERE id_product=" + alltrimIdProductPrestashop
   TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   ::writeText( "Eliminando funciones de Prestashop"  )

   cCommand          := 'SELECT * FROM ' + ::cPrefixTable( "feature_product" ) +  ' WHERE id_product=' + alltrimIdProductPrestashop
   oQuery            := TMSQuery():New( ::oCon, cCommand )
   
   ::writeText( "Eliminando lineas funciones de Prestashop"  )

   if oQuery:Open() .and. oQuery:RecCount() > 0
   
      oQuery:GoTop()
      while !oQuery:Eof()

         idDelete    := oQuery:FieldGet( 1 )

         if !empty( idDelete )

            cCommand          := "DELETE FROM " + ::cPrefixTable( "feature_product" ) + " WHERE id_product=" + alltrimIdProductPrestashop
            TMSCommand():New( ::oCon ):ExecDirect( cCommand )

            cCommand          := "DELETE FROM " + ::cPrefixTable( "feature" ) + " WHERE id_feature=" + alltrim( str( idDelete ) )
            TMSCommand():New( ::oCon ):ExecDirect( cCommand )

            cCommand          := "DELETE FROM " + ::cPrefixTable( "feature_lang" ) + " WHERE id_feature=" + alltrim( str( idDelete ) )
            TMSCommand():New( ::oCon ):ExecDirect( cCommand )

            cCommand          := "DELETE FROM " + ::cPrefixTable( "feature_shop" ) + " WHERE id_feature=" + alltrim( str( idDelete ) )
            TMSCommand():New( ::oCon ):ExecDirect( cCommand )

            cCommand          := 'SELECT * FROM ' + ::cPrefixTable( "feature_value" ) +  ' WHERE id_feature=' + alltrim( str( idDelete ) )
            oQuery2           := TMSQuery():New( ::oCon, cCommand )

            if oQuery2:Open() .and. oQuery2:RecCount() > 0

               oQuery2:GoTop()
               while !oQuery2:Eof()

                  idDelete2   := oQuery:FieldGet( 1 )

                  if !empty( idDelete2 )

                     cCommand          := "DELETE FROM " + ::cPrefixTable( "feature_value" ) + " WHERE id_feature_value=" + alltrim( str( idDelete2 ) )
                     TMSCommand():New( ::oCon ):ExecDirect( cCommand )

                     cCommand          := "DELETE FROM " + ::cPrefixTable( "feature_value_lang" ) + " WHERE id_feature_value=" + alltrim( str( idDelete2 ) )
                     TMSCommand():New( ::oCon ):ExecDirect( cCommand )

                  end if

                  oQuery2:Skip()

                  SysRefresh()

               end while      

            end if

         end if

         oQuery:Skip()

         SysRefresh()

      end while      

   end if

   sysrefresh()

   // Eliminamos las imágenes del artículo---------------------------------------

   ::writeText( "Eliminando imágenes de prestashop" )

   ::buildDeleteImagesProducts( alltrimIdProductPrestashop )

   SysRefresh()

   // Quitamos la referencia de nuestra tabla-------------------------------------

   ::TPrestashopId:deleteDocumentValuesProduct( idProduct, ::getCurrentWebName() )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD buildDeleteImagesProducts( cCodWeb ) CLASS TComercio 

   local oInt
   local oFtp
   local aDirectory
   local cDirectory
   local lError
   local idDelete
   local oQuery
   local cCommand    := ""
   local aDelImages  := {}
   local cCarpeta

   ::aDeletedImages  := {}

   if !empty( cCodWeb )
      
      /*
      Limpiamos la refecencia en la base de datos------------------------------
      */

      cCommand          := 'SELECT * FROM ' + ::cPrefixTable( "image" ) +  ' WHERE id_product=' + cCodWeb
      oQuery            := TMSQuery():New( ::oCon, cCommand )

      if oQuery:Open() .and. oQuery:RecCount() > 0

         oQuery:GoTop()

         while !oQuery:Eof()

            idDelete    := oQuery:FieldGet( 1 )

            aAdd( ::aDeletedImages, idDelete )

            cCommand          := "DELETE FROM " + ::cPrefixTable( "image" ) + " WHERE id_image=" + alltrim( str( idDelete ) )
            TMSCommand():New( ::oCon ):ExecDirect( cCommand )

            cCommand          := "DELETE FROM " + ::cPrefixTable( "image_shop" ) + " WHERE id_image=" + alltrim( str( idDelete ) )
            TMSCommand():New( ::oCon ):ExecDirect( cCommand )

            cCommand          := "DELETE FROM " + ::cPrefixTable( "image_lang" ) + " WHERE id_image=" + alltrim( str( idDelete ) )
            TMSCommand():New( ::oCon ):ExecDirect( cCommand )
         
            oQuery:Skip()

            SysRefresh()

         end while

      end if

      oQuery:Free()

   endif

Return nil

//---------------------------------------------------------------------------//

METHOD buildDeleteImagesFiles() CLASS TComercio

   local cDeleteImage

   for each cDeleteImage in ::aDeletedImages

      SysRefresh()

   next

Return nil

//---------------------------------------------------------------------------//

METHOD buildAddInformacionStockProductPrestashop( hProduct ) CLASS tComercio

   local sStock
   local idProduct            := hget( hProduct, "id" )
   local idFirstProperty      := hget( hProduct, "idFirstProperty" )
   local valueFirstProperty   := hget( hProduct, "valueFirstProperty" )
   local idSecondProperty     := hget( hProduct, "idSecondProperty" )
   local valueSecondProperty  := hget( hProduct, "valueSecondProperty" )
   local nTotalStock          := 0
   local nUnidadesStock       := 0
   local aStockArticulo

   ::writeText( "Recopilando información del artículo " + alltrim( idProduct ) )

   // Recopilamos la información del Stock-------------------------------------

   aStockArticulo             := ::oStock:aStockArticulo( idProduct, ::TPrestashopConfig:getStore() )

   // Recorremos el array con los stocks---------------------------------------

   for each sStock in aStockArticulo

      if sStock:cCodigo             == idProduct            .and.;
         sStock:cCodigoPropiedad1   == idFirstProperty      .and.;
         sStock:cValorPropiedad1    == valueFirstProperty   .and.;
         sStock:cCodigoPropiedad2   == idSecondProperty     .and.;
         sStock:cValorPropiedad2    == valueSecondProperty

         nUnidadesStock       := sStock:nUnidades

      end if  

      nTotalStock             += sStock:nUnidades 

   next

   aAdd( ::aStockProductData, {  "idProduct"             => idProduct ,;
                                 "idFirstProperty"       => idFirstProperty ,;
                                 "idSecondProperty"      => idSecondProperty ,;
                                 "valueFirstProperty"    => valueFirstProperty ,;
                                 "valueSecondProperty"   => valueSecondProperty ,;
                                 "unitStock"             => nUnidadesStock } )

   aAdd( ::aStockProductData, {  "idProduct"             => idProduct ,;
                                 "idFirstProperty"       => space( 20 ) ,;
                                 "idSecondProperty"      => space( 20 ) ,;
                                 "valueFirstProperty"    => space( 20 ) ,;
                                 "valueSecondProperty"   => space( 20 ) ,;
                                 "unitStock"             => nTotalStock } )

Return .t.

//---------------------------------------------------------------------------//

METHOD buildInformationStockProductArray( aProducts ) CLASS TComercio

   local hProduct

   ::meterProcesoSetTotal( len( aProducts ) )

   ::resetStockProductData()

   for each hProduct in aProducts
      ::buildAddInformacionStockProductPrestashop( hProduct )
   next

return .t.

//---------------------------------------------------------------------------//

METHOD proccessStockPrestashop() CLASS TComercio

   local hStockProductData

   ::meterProcesoSetTotal( len( ::aStockProductData ) )

   for each hStockProductData in ::aStockProductData
      ::buildInsertStockPrestashop( hStockProductData )
   next

Return .t.

//---------------------------------------------------------------------------//

METHOD uploadStockToPrestashop( aStockProductData )

   local hStockProductData

   for each hStockProductData in aStockProductData
      ::buildInsertStockPrestashop( hStockProductData )
   next

Return .t.

//---------------------------------------------------------------------------//

METHOD buildInsertStockPrestashop( hStockProductData ) CLASS TComercio

   local cText
   local cCommand
   local unitStock               
   local idProductPrestashop     
   local attributeFirstProperty  
   local attributeSecondProperty 
   local idProductAttribute      := 0

   idProductPrestashop           := ::TPrestashopId:getValueProduct( hget( hStockProductData, "idProduct" ), ::getCurrentWebName() )
   attributeFirstProperty        := ::TPrestashopId:getValueAttribute( hget( hStockProductData, "idFirstProperty" ) + hget( hStockProductData, "valueFirstProperty" ),     ::getCurrentWebName() )
   attributeSecondProperty       := ::TPrestashopId:getValueAttribute( hget( hStockProductData, "idSecondProperty" ) + hget( hStockProductData, "valueSecondProperty" ),   ::getCurrentWebName() ) 
   unitStock                     := hget( hStockProductData, "unitStock" )

   if ( attributeFirstProperty != 0 ) .and. ( attributeSecondProperty != 0 )
      idProductAttribute         := ::nIdProductAttribute( idProductPrestashop, attributeFirstProperty, attributeSecondProperty ) 
   end if 

   cCommand                      := "DELETE FROM " + ::cPrefixTable( "stock_available" ) + " "                          + ;
                                    "WHERE id_product = " + alltrim( str( idProductPrestashop ) ) + " "                 + ;
                                    "AND id_product_attribute = " + alltrim( str( idProductAttribute ) )

   TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   if ( unitStock != 0 )

      cCommand                   := "INSERT INTO " + ::cPrefixTable( "stock_available" ) + " ( "                        + ;
                                       "id_product, "                                                                   + ;
                                       "id_product_attribute, "                                                         + ;
                                       "id_shop, "                                                                      + ;
                                       "id_shop_group, "                                                                + ;
                                       "quantity, "                                                                     + ;
                                       "depends_on_stock, "                                                             + ;
                                       "out_of_stock ) "                                                                + ;
                                    "VALUES ( "                                                                         + ;
                                       "'" + alltrim( str( idProductPrestashop ) ) + "', "                              + ;
                                       "'" + alltrim( str( idProductAttribute ) ) + "', "                               + ;   
                                       "'1', "                                                                          + ;
                                       "'0', "                                                                          + ;
                                       "'" + alltrim( str( unitStock ) ) + "', "                                        + ;
                                       "'0', "                                                                          + ;
                                       "'2' )"

      TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   end if

   cText       := "Actualizando stock con propiedades : " + alltrim( str( attributeFirstProperty ) ) + " , " + alltrim( str( attributeSecondProperty ) ) + ", "
   cText       += "cantidad : " + alltrim( str( unitStock ) )

   ::writeText( cText )

Return .t.   

//---------------------------------------------------------------------------//

METHOD BuildAddArticuloActualizar( cCodArt ) CLASS tComercio

   if !empty( cCodArt ) .and. ascan( ::aArticulosActualizar, cCodArt ) == 0
      aadd( ::aArticulosActualizar, cCodArt )
   end if

Return .t.   

//---------------------------------------------------------------------------//

METHOD getDate( uDatePrestashop ) CLASS TComercio

   local dFecha

   if hb_isdate( uDatePrestashop )
      uDatePrestashop   := dtoc( uDatePrestashop )
   end if 

   SET DATE FORMAT "yyyy-mm-dd"
      dFecha            := ctod( left( uDatePrestashop, 10 ) )
   SET DATE FORMAT "dd/mm/yyyy"

Return ( dFecha )

//---------------------------------------------------------------------------//

METHOD getDatePrestashop( dFecha, tHora ) CLASS TComercio

   local cFechaPrestashop

   SET DATE FORMAT "yyyy-mm-dd"
   cFechaPrestashop   := alltrim( dtoc( dFecha ) ) + " " + alltrim( trans( tHora, "@R ##:##:##" ) ) + ".0000000"
   SET DATE FORMAT "dd/mm/yyyy"

Return ( cFechaPrestashop )

//---------------------------------------------------------------------------//

METHOD getTime( ctimePrestashop ) CLASS TComercio

   local dHora

   dHora   := strtran( Substr( cTimePrestashop, 12, 8 ), ":", "" )
   
Return ( dHora )

//---------------------------------------------------------------------------//

METHOD checkDate( cDatePrestashop ) CLASS TComercio

   local dFecha   := ::getDate( cDatePrestashop )

Return ( dFecha >= uFieldEmpresa( "dIniOpe" ) .or. empty( uFieldEmpresa( "dIniOpe" ) ) ) .and. ( dFecha <= uFieldEmpresa( "dFinOpe" ) .or. empty( uFieldEmpresa( "dFinOpe" ) ) )

//---------------------------------------------------------------------------//

METHOD isRecivedDocumentAsBudget( cPrestashopModule ) CLASS TComercio

   local lAsBudget   := .f.

   if ( ::oFPago:SeekInOrd( upper( cPrestashopModule ), "cCodWeb" ) ) .and. ( ::oFPago:nGenDoc <= 1 )
      lAsBudget      := .t.
   endif

return ( lAsBudget )

//---------------------------------------------------------------------------//

METHOD syncSituacionesPresupuestoPrestashop( cCodWeb, cSerPre, nNumPre, cSufPre ) CLASS TComercio
Return ( .t. )

//---------------------------------------------------------------------------//

METHOD syncronizeStatesPresupuestoGestool( cCodWeb, cSerPre, nNumPre, cSufPre ) CLASS TComercio
Return ( .t. )

//---------------------------------------------------------------------------//

METHOD presupuestoCheckExistStateUp( oQuery, cCodWeb, cSerPre, nNumPre, cSufPre ) CLASS TComercio

   if !::oPreCliE:SeekInOrd( str( oQuery:FieldGetByName( "id_order_history" ), 11 ), "idPs" )
      ::downloadStateToPresupuesto( oQuery, cSerPre, nNumPre, cSufPre )
   endif

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD downloadStateToPresupuesto( oQuery, cSerPre, nNumPre, cSufPre ) CLASS TComercio

   local oQueryState          := TMSQuery():New( ::oCon, "SELECT * FROM " +::cPrefixtable( "order_state_lang" ) + " WHERE id_lang = " + str( ::nLanguage ) + " and id_order_state = " + alltrim( str( oQuery:FieldGetByName( "id_order_state" ) ) ) ) 

   if oQueryState:Open() .and. oQueryState:RecCount() > 0

         ::oPreCliE:Append()
         ::oPreCliE:Blank()

         ::oPreCliE:cSerPre   := cSerPre
         ::oPreCliE:nNumPre   := nNumPre
         ::oPreCliE:cSufPre   := cSufPre
         ::oPreCliE:cSitua    := oQueryState:FieldGetByName( "name" )
         ::oPreCliE:dFecSit   := ::getDate( oQuery:FieldGetByName( "date_add" ) )
         ::oPreCliE:tFecSit   := ::getTime( oQuery:FieldGetByName( "date_add" ) )
         ::oPreCliE:idPs      := oQuery:FieldGetByName( "id_order_history" )
                  
         ::oPreCliE:Save()

   end if

Return( .t. )

//---------------------------------------------------------------------------//

METHOD syncronizeStatesPresupuestoPrestashop ( cSerPre, nNumPre, cSufPre, cCodWeb ) CLASS TComercio

   local nRec        := ::oPreCliE:Recno()
   local nOrdAnt     := ::oPreCliE:OrdSetFocus( "NNUMPRE" )
   local id
   local oQuery
   
   oQuery   := TMSQuery():New( ::oCon, "SELECT * FROM " + ::cPrefixtable( "order_history" ) + " where id_order = " + alltrim( str( cCodWeb ) ) )

   
   if oQuery:Open() .and. oQuery:RecCount() > 0

      if ::oPreCliE:Seek( cSerPre + str( nNumPre ) + cSufPre )

         while ( ::oPreCliE:cSerPre + str( ::oPreCliE:nNumPre ) + ::oPreCliE:cSufPre ) == ( cSerPre + str( nNumPre ) + cSufPre ) .and. !::oPreCliE:eof()
        
            if empty( ::oPreCliE:idPs )
                 
               id       := ::UploadStatePrestashop( ::idOrderState( ::oPreCliE:cSitua ), ::oPreCliE:dFecSit, ::oPreCliE:tFecSit, cCodWeb )      

               if !empty( id )
                  ::oPreCliE:fieldPutByName( "idPs", id )
               end if 
            endif

            ::oPreCliE:Skip()  

         end while

      endif

   endif

   ::oPreCliE:OrdSetFocus( nOrdAnt )
   ::oPreCliE:GoTo( nRec )

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD UploadStatePrestashop( id_order_state, dFecSit, tFecSit, cCodWeb ) CLASS TComercio

   local id 
   local cCommand 

   cCommand      :=  "INSERT INTO " + ::cPrefixtable( "order_history" ) + " VALUES ( '', 1, " + alltrim( str( cCodWeb ) ) + ", " + alltrim( str( id_order_state ) ) + ", '" + ::getDatePrestashop( dFecSit, tFecSit ) + "' )" 

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      id             := ::oCon:GetInsertId()   
   end if 

Return ( id  )

//---------------------------------------------------------------------------//

METHOD syncSituacionesPedidoPrestashop( cCodWeb, cSerPed, nNumPed, cSufPed ) CLASS TComercio

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD syncronizeStatesGestool( cCodWeb, cSerPed, nNumPed, cSufPed ) CLASS TComercio

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD checkExistStateUp( oQuery, cCodWeb, cSerPed, nNumPed, cSufPed ) CLASS TComercio

   if !::oPedCliE:SeekInOrd( str( oQuery:FieldGetByName( "id_order_history" ), 11 ), "idPs" )
      ::downloadState( oQuery, cSerPed, nNumPed, cSufPed)
   endif

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD downloadState( oQuery, cSerPed, nNumPed, cSufPed ) CLASS TComercio

   local oQueryState

   oQueryState          := TMSQuery():New( ::oCon, "SELECT * FROM " +::cPrefixtable( "order_state_lang" ) + " WHERE id_lang = " + str( ::nLanguage ) + " and id_order_state = " + alltrim( str( oQuery:FieldGetByName( "id_order_state" ) ) ) ) 

   if oQueryState:Open() .and. oQueryState:RecCount() > 0

         ::oPedCliE:Append()
         ::oPedCliE:Blank()

         ::oPedCliE:cSerPed   := cSerPed
         ::oPedCliE:nNumPed   := nNumPed
         ::oPedCliE:cSufPed   := cSufPed
         ::oPedCliE:cSitua    := oQueryState:FieldGetByName( "name" )
         ::oPedCliE:dFecSit   := ::getDate( oQuery:FieldGetByName( "date_add" ) )
         ::oPedCliE:tFecSit   := ::getTime( oQuery:FieldGetByName( "date_add" ) )
         ::oPedCliE:idPs      := oQuery:FieldGetByName( "id_order_history" )
                  
         ::oPedCliE:Save()

   end if

Return( .t. )

//---------------------------------------------------------------------------//

METHOD syncronizeStatesPrestashop ( cSerPed, nNumPed, cSufPed, cCodWeb ) CLASS TComercio

   local nRec        := ::oPedCliE:Recno()
   local nOrdAnt     := ::oPedCliE:OrdSetFocus( "NNUMPED" )
   local id
   local oQuery
   
   oQuery   := TMSQuery():New( ::oCon, "SELECT * FROM " + ::cPrefixtable( "order_history" ) + " where id_order = " + alltrim( str( cCodWeb ) ) )

   
   if oQuery:Open() .and. oQuery:RecCount() > 0

      if ::oPedCliE:Seek( cSerPed + str( nNumPed ) + cSufPed )

         while ( ::oPedCliE:cSerPed + str( ::oPedCliE:nNumPed ) + ::oPedCliE:cSufPed ) == ( cSerPed + str( nNumPed ) + cSufPed ) .and. !::oPedCliE:eof()
        
            if empty( ::oPedCliE:idPs )
                          
               id       := ::UploadState( ::idOrderState( ::oPedCliE:cSitua ), ::oPedCliE:dFecSit, ::oPedCliE:tFecSit, cCodWeb )      

               if !empty( id )
                  ::oPedCliE:fieldPutByName( "idPs", id )
               end if 
            endif

            ::oPedCliE:Skip()  

         end while

      endif

   endif

   ::oPedCliE:OrdSetFocus( nOrdAnt )
   ::oPedCliE:GoTo( nRec )

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD idOrderState( cSitua ) CLASS TComercio

   local oQuery2 
   local idState  

   oQuery2             := TMSQuery():New( ::oCon, "SELECT id_order_state FROM " + ::cPrefixtable( "order_state_lang" ) + " WHERE id_lang = " + str( ::nLanguage ) + " and name = '" + alltrim( cSitua ) + "'" )


   if oQuery2:Open() .and. oQuery2:RecCount() > 0

      idState := oQuery2:FieldGetByName( "id_order_state" )

   endif

Return ( idState )

//---------------------------------------------------------------------------//

METHOD UploadState( id_order_state, dFecSit, tFecSit, cCodWeb ) CLASS TComercio

   local id 
   local cCommand 

   cCommand      :=  "INSERT INTO " + ::cPrefixtable( "order_history" ) + " VALUES ( '', 1, " + alltrim( str( cCodWeb ) ) + ", " + alltrim( str( id_order_state ) ) + ", '" + ::getDatePrestashop(::oPedCliE:dFecSit, ::oPedCliE:tFecSit) + "' )" 

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      id         := ::oCon:GetInsertId()   
   end if 

Return ( id  )

//---------------------------------------------------------------------------//

METHOD buildFTP() CLASS TComercio

   do case
      case ::TPrestashopConfig:getFtpService() == "Linux"
         ::oFtp      := TFtpLinux():NewPrestashopConfig( ::TPrestashopConfig )
      case ::TPrestashopConfig:getFtpService() == "Windows"
         ::oFtp      := TFtpWindows():NewPrestashopConfig( ::TPrestashopConfig )
      case ::TPrestashopConfig:getFtpService() == "Curl"
         ::oFtp      := TFtpCurl():NewPrestashopConfig( ::TPrestashopConfig )
   end case 

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeText( cText ) CLASS TComercio

   if !( ::TPrestashopConfig:isSilenceMode() )

      if !empty( ::oTree )
         ::oTree:Select( ::oTree:Add( cText ) )
      end if 

      if !empty( ::oWaitMeter )
         ::oWaitMeter:setMessage( cText )
      end if 
   
   end if 
   
   logWrite( cText, cPatLog() + "prestashop.log" ) 

Return ( nil )   

//---------------------------------------------------------------------------//

METHOD getRecursiveFolderPrestashop( cCarpeta ) CLASS TComercio

   local n
   local cFolder  := ""

   for n := 1 to len( cCarpeta )
      cFolder     += ( substr( cCarpeta, n, 1 ) + "/" )
   next 

Return ( cFolder )

//---------------------------------------------------------------------------//

METHOD appendProductsToUpadateStocks( idProduct, idFirstProperty, valueFirstProperty, idSecondProperty, valueSecondProperty, nView ) CLASS TComercio

   local nScan
   local cWebShop
   local hProduct

   if !( D():gotoArticulos( idProduct, nView ) )
      Return ( .f. )
   end if 

   if !( D():Articulos( nView ) )->lPubInt
      Return ( .f. )
   end if 

   cWebShop          := alltrim( ( D():Articulos( nView ) )->cWebShop )

   hProduct          := {  "id"                    => idProduct,;
                           "idFirstProperty"       => idFirstProperty,;
                           "valueFirstProperty"    => valueFirstProperty,;
                           "idSecondProperty"      => idSecondProperty,;
                           "valueSecondProperty"   => valueSecondProperty }

   nScan             := hscan( ::hProductsToUpdate, {|k,v| k == cWebShop } )
   if nScan == 0
      hset( ::hProductsToUpdate, cWebShop, { hProduct } )
   else 
      if ascan( ::hProductsToUpdate[ cWebShop ], {|h| hget( h, "id" ) == idProduct .and. hget( h, "idFirstProperty" ) == idFirstProperty .and. hget( h, "valueFirstProperty" ) == valueFirstProperty .and. hget( h, "idSecondProperty" ) == idSecondProperty .and. hget( h, "valueSecondProperty" ) == valueSecondProperty } )  == 0
         aadd( ::hProductsToUpdate[ cWebShop ], hProduct )
      end if 
   end if 
   
Return ( ::hProductsToUpdate )   

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD controllerUpdateStockPrestashop() Class TComercio

   local oBlock
   local oError

   if !( ::isAviableWebToExport() )
      Return .f.
   end if 

   ::disableDialog()

   oBlock            := ErrorBlock( { | oError | Break( oError ) } )
   BEGIN SEQUENCE

   if ::filesOpen()

      ::MeterTotalText( "Actualizando stocks de prestashop" )

      ::buildInformationStockProductDatabase()

      if ::prestaShopConnect()

         ::MeterTotalText( "Actualizando stocks" )

         ::proccessStockPrestashop()

         ::prestashopDisConnect()  
      
      end if  

      ::filesClose()

   end if 

   RECOVER USING oError
      msgStop( ErrorMessage( oError ), "Error en modulo Prestashop." )
   END SEQUENCE
   ErrorBlock( oBlock )

   ::enableDialog()

Return .t.

//---------------------------------------------------------------------------//

METHOD buildInformationStockProductDatabase() CLASS TComercio

   local sStock
   local aStockArticulo

   ::meterProcesoSetTotal( ::oArt:ordkeycount() )

   ::resetStockProductData()

   ::oArt:GoTop()
   while !::oArt:eof()

      if ::productInCurrentWeb()

         ::meterProcesoText( "Procesando " + alltrim( ::oArt:Codigo ) + ", " + alltrim( ::oArt:Nombre ) )

         ::buildStockPrestashop( ::oArt:Codigo )

      end if 

      ::oArt:Skip()

   end while

return .t.

//---------------------------------------------------------------------------//

METHOD buildStockPrestashop( idProduct ) CLASS tComercio
   
   local sStock
   local nStock            := 0
   local aStockProduct     := {}
   local aStockArticulo    := ::oStock:aStockArticulo( idProduct, ::TPrestashopConfig:getStore() )

   for each sStock in aStockArticulo

      aAdd( aStockProduct, {  "idProduct"             => idProduct ,;
                              "idFirstProperty"       => sStock:cCodigoPropiedad1 ,;
                              "idSecondProperty"      => sStock:cCodigoPropiedad2 ,;
                              "valueFirstProperty"    => sStock:cValorPropiedad1 ,;
                              "valueSecondProperty"   => sStock:cValorPropiedad2 ,;
                              "unitStock"             => sStock:nUnidades } )

      nStock               += sStock:nUnidades

   next

   // apunte resumen ---------------------------------------------------------

   aAdd( aStockProduct, {  "idProduct"             => idProduct ,;
                           "idFirstProperty"       => space( 20 ) ,;
                           "idSecondProperty"      => space( 20 ) ,;
                           "valueFirstProperty"    => space( 20 ) ,;
                           "valueSecondProperty"   => space( 20 ) ,;
                           "unitStock"             => nStock } )

Return ( aStockProduct )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD updateWebProductStocks() CLASS TComercio

   if !::TPrestashopConfig:isRealTimeConexion()
      Return .f.
   end if 

   if !::filesOpen()
      ::filesClose()
      Return .f.
   end if 

   ::oWaitMeter         := TWaitMeter():New( "Actualizando stocks", "Espere por favor..." )
   ::oWaitMeter:Run()

   heval( ::hProductsToUpdate, {|cWebName, aProductsWeb | ::updateProductStocks( cWebName, aProductsWeb ) } )

   ::oWaitMeter:End()

   ::filesClose()

Return ( ::hProductsToUpdate )   

//---------------------------------------------------------------------------//

METHOD updateProductStocks( cWebName, aProductsWeb ) CLASS TComercio

   ::TPrestashopConfig:setCurrentWebName( cWebName )

   if !::prestaShopConnect()
      Return .f.
   end if 

   ::buildInformationStockProductArray( aProductsWeb )

   ::proccessStockPrestashop()

   ::prestaShopDisConnect()  

Return ( ::hProductsToUpdate )   

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SImagen

   DATA cNombreImagen      INIT ""
   DATA nTipoImagen        INIT ""
   DATA cCarpeta           INIT ""
   DATA cPrefijoNombre     INIT ""

END CLASS

//---------------------------------------------------------------------------//

CLASS STipoImagen

   DATA cNombreTipo        INIT ""
   DATA nAnchoTipo         INIT 0
   DATA nAltoTipo          INIT 0
   DATA lCategories        INIT .f.
   DATA lProducts          INIT .f.
   DATA lManufactures      INIT .f.
   DATA lSuppliers         INIT .f.
   DATA lScenes            INIT .f.
   DATA lStores            INIT .f.

END CLASS

//---------------------------------------------------------------------------//

CLASS SCategoria

   DATA id           INIT 0
   DATA idParent     INIT 0
   DATA nLeft        INIT 0
   DATA nRight       INIT 0
   DATA nTipo        INIT 0   //1-Grupo  -  2-Familia  -  3-Tipo

END CLASS

//---------------------------------------------------------------------------//
//FUNCIONES------------------------------------------------------------------//
//---------------------------------------------------------------------------//

function cLinkRewrite( cLink )

   local cCaracter   := ""
   local cResult     := ""
   local cCarAnt     := ""

   cLink             := alltrim( cLink )

   for each cCaracter in cLink

      do case
         case ( Asc( cCaracter ) >= 48 .and. Asc( cCaracter ) <= 57 ) .or.;
              ( Asc( cCaracter ) >= 65 .and. Asc( cCaracter ) <= 90 ) .or.;
              ( Asc( cCaracter ) >= 97 .and. Asc( cCaracter ) <= 122 )

            cResult     := cResult + cCaracter

         case Asc( cCaracter ) == 32

            if Asc( cCarAnt ) != 32
               cResult  := cResult + "-"
            end if   

         otherwise

            cResult     := cResult + ReemplazaAcento( cCaracter )

      end case

      cCarAnt           := cCaracter

   next

   if !empty( cResult )
      cResult           := lower( cResult )
   end if  

Return( cResult )

//---------------------------------------------------------------------------//

Function reemplazaAcento( cCaracter )

   local nPos
   local cPatron     := "ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖÙÚÛÜÝàáâãäåæçèéêëìíîïñòóôõöùúûüýÿŠšŸ"
   local cReemplazo  := "AAAAAAACEEEEIIIIDNOOOOOUUUUYaaaaaaaceeeeiiiinooooouuuuyySsY"
   local cResultado  := Space( 0 )

   nPos              := At( cCaracter, cPatron )

   if nPos != 0
      cResultado     := Substr( cReemplazo, nPos, 1 )
   end if

return ( cResultado )

//---------------------------------------------------------------------------//

Function SetAutoRecive()

   if empty( oComercio )
      oComercio   := TComercio():New()
   end if

   if !empty( oComercio )           .and. ;
      !empty( oComercio:cHost )     .and. ;
      !empty( oComercio:cUser )     .and. ;
      !empty( oComercio:cPasswd )   .and. ;
      !empty( oComercio:cDbName )   .and. ;
      ( oComercio:nSecondTimer != 0 )

      oTimer      := TTimer():New( oComercio:nSecondTimer, {|| oComercio:AutoRecive() } )
      oTimer:dialogActivate()

   end if

Return( nil )

//---------------------------------------------------------------------------//

Function KillAutoRecive()

   if !empty( oTimer )
      oTimer:End()
   end if

   oTimer         := nil
   oComercio      := nil

Return( nil )

//---------------------------------------------------------------------------//
