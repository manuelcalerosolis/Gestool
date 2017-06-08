#include "Fivewin.ch"
#include "Font.ch"
#include "Report.ch"
#include "Factu.ch" 
#include "Ads.ch"

#ifdef __ADS__
   REQUEST ADS, DBFCDX

   REQUEST AdsKeyNo
   REQUEST AdsKeyCount
   REQUEST AdsGetRelKeyPos
   REQUEST AdsSetRelKeyPos
#endif

#ifndef __ADS__
   REQUEST DBFCDX, DBFFPT
#endif

#define TVS_HASBUTTONS       1
#define TVS_HASLINES         2
#define TVS_LINESATROOT      4
#define TVS_SHOWSELALWAYS   32 //   0x0020
#define TVS_DISABLEDRAGDROP 16 //   0x0010

/*
Comentado para que trabaje junto
*/
//---------------------------------------------------------------------------//

static oWndBar
static cNbrUsr
static cCajUsr

static dbfFolder
static dbfFavorito

static oBtnVentas
static oBtnCompras
static oBtnExistencias
static oBtnProduccion
static oBtnFavoritos
static oBtnAddFavorito 
static oBtnEditFavorito
static oBtnDelFavorito
static oBtnEjecutar
static oBtnSalir

static oTrvGaleria

static aInforme         := {}

//---------------------------------------------------------------------------//

Function Main( cCodEmp, cCodUsr, cInitOptions )

   local nError
   local cError

   DEFAULT cCodEmp   := alltrim( str( year( date() ) ) )
   DEFAULT cCodUsr   := "000"

   appSettings()

   // Modificaciones de las clases de fw---------------------------------------

   appDialogExtend() 

   // Chequeamos la existencia del fichero de configuracion--------------------

   appLoadAds()

   // Motor de bases de datos--------------------------------------------------
 
   if ( "ADSINTERNET" $ cAdsType() )

      if !( appConnectADS() )
         msgStop( "Imposible conectar con GstApolo ADS data dictionary" )
         Return nil
      end if
      
   else 

      appConnectCDX()

   end if

   TDataCenter():BuildData()

   // Seleccionamos el usuario-------------------------------------------------

   oUser( cCodUsr )

   // Ponemos el directorio para los ficheros----------------------------------

   cPatEmp( cCodEmp )
   cPatCli( cCodEmp, nil, .t. )
   cPatArt( cCodEmp, nil, .t. )
   cPatPrv( cCodEmp, nil, .t. )
   cPatAlm( cCodEmp, nil, .t. )

   // Seleccionamos la empresa-------------------------------------------------

   cCodigoEmpresaEnUso( cCodEmp )

   aEmpresa( cCodEmp )

   // Cargamos la estructura de ficheros de la empresa-------------------------

   TDataCenter():BuildEmpresa()

   // Apertura de ventana------------------------------------------------------

   reportBar()

Return nil

//---------------------------------------------------------------------------//

init procedure RddInit()

   REQUEST DBFCDX
   REQUEST DBFFPT

   REQUEST HB_LANG_ES         // Para establecer idioma de Mensajes, fechas, etc..
   REQUEST HB_CODEPAGE_ESWIN  // Para establecer código de página a Español (Ordenación, etc..)

   hb_langselect("ES")        // Para mensajes, fechas, etc..
   hb_setcodepage("ESWIN")    // Para ordenación (arrays, cadenas, etc..) *Requiere CodePage.lib

return

//---------------------------------------------------------------------------//

Static Function OnInitReportGalery( oLstTipoGaleria, oImgTipoGaleria, oImgArbolGaleria, oTrvArbolGaleria )

   oLstTipoGaleria:SetImageList( oImgTipoGaleria )

   oLstTipoGaleria:InsertItem( 0, "Ventas" )
   oLstTipoGaleria:InsertItem( 1, "Compras" )
   oLstTipoGaleria:InsertItem( 2, "Existencias" )
   oLstTipoGaleria:InsertItem( 3, "Producción" )
   oLstTipoGaleria:InsertItem( 4, "Favoritos" )

   oLstTipoGaleria:nOption       := 1

   oBtnAddFavorito:Enable()
   oBtnEditFavorito:Disable()
   oBtnDelFavorito:Disable()

   CreateVentasReportGalery( oTrvArbolGaleria, .f. )

Return nil

//----------------------------------------------------------------------------//

Static Function SelectReportGalery( nOption, oTrvArbolGaleria )

   do case
      case nOption == 1
         oBtnAddFavorito:Enable()
         oBtnEditFavorito:Disable()
         oBtnDelFavorito:Disable()
         oTrvArbolGaleria:DeleteAll()
         CreateVentasReportGalery( oTrvArbolGaleria, .f. )

      case nOption == 2
         oBtnAddFavorito:Enable()
         oBtnEditFavorito:Disable()
         oBtnDelFavorito:Disable()
         oTrvArbolGaleria:DeleteAll()
         CreateComprasReportGalery( oTrvArbolGaleria, .f. )

      case nOption == 3
         oBtnAddFavorito:Enable()
         oBtnEditFavorito:Disable()
         oBtnDelFavorito:Disable()
         oTrvArbolGaleria:DeleteAll()
         CreateExistenciasReportGalery( oTrvArbolGaleria, .f. )

      case nOption == 4
         oBtnAddFavorito:Enable()
         oBtnEditFavorito:Disable()
         oBtnDelFavorito:Disable()
         oTrvArbolGaleria:DeleteAll()
         CreateProduccionReportGalery( oTrvArbolGaleria, .f. )

      case nOption == 5
         oBtnAddFavorito:Disable()
         oBtnEditFavorito:Enable()
         oBtnDelFavorito:Enable()
         oTrvArbolGaleria:DeleteAll()
         CreateFavoritoReportGalery( oTrvArbolGaleria )

   end case

Return nil

//----------------------------------------------------------------------------//

Static Function ExecuteReportGalery( oTrvArbolGaleria )

   local oTreeInforme   := oTrvArbolGaleria:GetSelected()

   if !Empty( oTreeInforme ) .and. !Empty( oTreeInforme:Cargo )
      if ValType( oTreeInforme:Cargo ) == "B"
         Eval( oTreeInforme:Cargo )
      else
         Eval( oTreeInforme:Cargo:Accion )
      end if
   end if

Return nil

//---------------------------------------------------------------------------//

Static Function lOpenFiles()

   local lOpen    := .t.
   local cPath    := cPatEmp()
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      USE ( cPath + "CFGCAR.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CFGCAR", @dbfFolder ) )
      SET ADSINDEX TO ( cPath + "CFGCAR.CDX" ) ADDITIVE

      USE ( cPath + "CFGFAV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CFGFAV", @dbfFavorito ) )
      SET ADSINDEX TO ( cPath + "CFGFAV.CDX" ) ADDITIVE

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos necesarias para la galería." )
      
      CloseFiles()
      
      lOpen       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lOpen )

//---------------------------------------------------------------------------//

Static Function CloseFiles()

   if dbfFolder != nil
      ( dbfFolder )->( dbCloseArea() )
   end if

   if dbfFavorito != nil
      ( dbfFavorito )->( dbCloseArea() )
   end if

   dbfFolder    := nil
   dbfFavorito  := nil

Return nil

//---------------------------------------------------------------------------//

Static Function CreateVentasReportGalery( oTrvArbolGaleria, lArray )

   local oTrvTipo
   local oTrvDocumento
   local oTrvSubDoc

   DEFAULT lArray       := .f.

   oTrvTipo             := AddInforme( lArray, oTrvArbolGaleria, "Almacenes" )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Presupuestos" )
         AddInforme( lArray, oTrvDocumento, "Detalle de presupuestos por almacenes", {|| TInfAPre():New( "Informe detallado de presupuestos de clientes agrupados por almacenes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de presupuestos por almacenes", {|| TAcuAPre():New( "Informe de acumulados de presupuestos por almacenes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de presupuestos por almacenes", {|| TAnuAPre():New( "Informe anual de presupuestos de clientes agrupados por almacenes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de presupuestos por almacenes", {|| TRenAPre():New( "Informe de rentabilidad de presupuestos por almacenes" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Pedidos" )
         AddInforme( lArray, oTrvDocumento, "Detalle de pedidos por almacenes", {|| TInfAPed():New( "Informe detallado de pedidos de clientes agrupados por almacenes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de pedidos por almacenes", {|| TAcuAPed():New( "Informe de acumulados de pedidos por almacenes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de pedidos por almacenes", {|| TAnuAPed():New( "Informe anual de pedidos de clientes agrupados por almacenes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de pedidos por almacenes",  {|| TRenAPed():New( "Informe de rentabilidad de pedidos por almacenes" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Albaranes" )
         AddInforme( lArray, oTrvDocumento, "Detalle de albaranes por almacenes", {|| TInfAAlb():New( "Informe detallado de albaranes de clientes agrupados por almacenes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de albaranes por almacenes", {|| TAcuAAlb():New( "Informe de acumulados de albaranes por almacenes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de albaranes por almacenes", {|| TAnuAAlb():New( "Informe anual de albaranes de clientes agrupados por almacenes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de albaranes por almacenes", {|| TRenAAlb():New( "Informe de rentabilidad de albaranes por almacenes" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Facturas" )
         AddInforme( lArray, oTrvDocumento, "Detalle de facturas por almacenes", {|| TInfAFac():New( "Informe detallado de facturas de clientes agrupados por almacenes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de facturas por almacenes", {|| TAcuAFac():New( "Informe de acumulados de facturas por almacenes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de facturas por almacenes", {|| TAnuAFac():New( "Informe anual de facturas de clientes agrupados por almacenes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de facturas por almacenes", {|| TRenAFac():New( "Informe de rentabilidad de facturas por almacenes" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Facturas rectificativas" )
         AddInforme( lArray, oTrvDocumento, "Detalle de facturas rectificativas por almacenes", {|| TInfAFacRec():New( "Informe detallado de facturas rectificativas de clientes agrupados por almacenes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de facturas rectificativas por almacenes", {|| TAcuAFacRec():New( "Informe de acumulados de facturas rectificativas por almacenes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de facturas rectificativas por almacenes", {|| TAnuAFacRec():New( "Informe anual de facturas rectificativas por almacenes" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Tickets" )
         AddInforme( lArray, oTrvDocumento, "Detalle de tikets por almacenes", {|| TInfATik():New( "Informe detallado de tikets a clientes agrupados por almacenes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de tikets por almacenes", {|| TAcuATik():New( "Informe de acumulados de tikets por almacenes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de tikets por almacenes", {|| TAnuATik():New( "Informe anual de tikets de clientes agrupados por almacenes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de tikets por almacenes", {|| TRenATik():New( "Informe de rentabilidad de tikets por almacenes" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Ventas" )
         AddInforme( lArray, oTrvDocumento, "Detalle de ventas por almacenes",  {|| TInfAVta():New( "Informe detallado de ventas a clientes agrupados por almacenes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de ventas por almacenes", {|| TAcuAVta():New( "Informe de acumulados de ventas por almacenes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de ventas por almacenes", {|| TAnuAVta():New( "Informe anual de ventas de clientes agrupados por almacenes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de ventas por almacenes", {|| TRenAVta():New( "Informe de rentabilidad de ventas por almacenes" ):Play() } )

   oTrvTipo             := AddInforme( lArray, oTrvArbolGaleria, "Grupos de familias" )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "General" )
         AddInforme( lArray, oTrvDocumento, "Informe de familias por grupos de familias", {|| TGruFam():New( "Informe de familias agrupadas por grupos de familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Informe de artículos por grupos de familias y familias", {|| TInfArtFamGrp():New( "Informe de artículos agrupados por grupos de familias y familias" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Presupuestos" )
         AddInforme( lArray, oTrvDocumento, "Detalle de presupuestos por grupos de familias", {|| TInfGPre():New( "Informe detallado de presupuestos de clientes agrupado por grupos de familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de presupuestos por grupos de familias", {|| TAcuGPre():New( "Informe de acumulados de presupuestos por grupos de familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de presupuestos por grupos de familias", {|| TAnuGPre():New( "Informe resumido de presupuestos de clientes agrupado por grupos de familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de presupuestos por grupo de familias", {|| TRenGPre():New( "Informe de rentabilidad de presupuestos por grupo de familias" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Pedidos" )
         AddInforme( lArray, oTrvDocumento, "Detalle de pedidos por grupos de familias", {|| TInfGPed():New( "Informe detallado de pedidos de clientes agrupado por grupos de familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de pedidos por grupos de familias", {|| TAcuGPed():New( "Informe de acumulados de pedidos por grupos de familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de pedidos por grupos de familias", {|| TAnuGPed():New( "Informe resumido de pedidos de clientes agrupado por grupos de familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de pedidos por grupo de familias", {|| TRenGPed():New( "Informe de rentabilidad de pedidos por grupo de familias" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Albaranes" )
         AddInforme( lArray, oTrvDocumento, "Detalle de albaranes por grupos de familias", {|| TInfGAlb():New( "Informe detallado de albaranes de clientes agrupado por grupos de familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de albaranes por grupos de familias", {|| TAcuGAlb():New( "Informe de acumulados de albaranes por grupos de familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de albaranes por grupos de familias", {|| TAnuGAlb():New( "Informe resumido de albaranes de clientes agrupado por grupos de familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de albaranes por grupo de familias", {|| TRenGAlb():New( "Informe de rentabilidad de albaranes por grupo de familias" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Facturas" )
         AddInforme( lArray, oTrvDocumento, "Detalle de facturas por grupos de familias", {|| TInfGFac():New( "Informe detallado de facturas de clientes agrupado por grupos de familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de facturas por grupos de familias", {|| TAcuGFac():New( "Informe de acumulados de facturas por grupos de familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de facturas por grupos de familia", {|| TAnuGFac():New( "Informe resumido de facturas de clientes agrupado por grupos de familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de facturas por grupo de familias", {|| TRenGFac():New( "Informe de rentabilidad de facturas por grupo de familias" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Facturas rectificativas" )
         AddInforme( lArray, oTrvDocumento, "Detalle de facturas rectificativas por grupos de familias", {|| TInfGFacRec():New( "Informe detallado de facturas rectificativas de clientes agrupados por grupos de familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de facturas rectificativas por grupos de familias", {|| TAcuGFacRec():New( "Informe de acumulados de facturas rectificativas por grupos de familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de facturas rectificativas por grupos de familias", {|| TAnuGFacRec():New( "Informe anual de facturas rectificativas por grupos de familias" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Tikets" )
         AddInforme( lArray, oTrvDocumento, "Detalle de tikets por grupo de familias", {|| TInfGTik():New( "Informe detallado de tickets a clientes agrupados por grupo de familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de tikets por grupos de familias", {|| TAcuGTik():New( "Informe de acumulados de tikets por grupos de familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de tikets por grupo de familias", {|| TAnuGTik():New( "Informe anual de tikets de clientes agrupados por grupo de familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de tikets por grupo de familias", {|| TRenGTik():New( "Informe de rentabilidad de tikets por grupo de familias" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Ventas" )
         AddInforme( lArray, oTrvDocumento, "Detalle de ventas por grupo de familias", {|| TInfGVta():New( "Informe detallado de ventas a clientes agrupados por grupo de familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de ventas por grupos de familias", {|| TAcuGVta():New( "Informe de acumulados de ventas por grupos de familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de ventas por grupo de familias", {|| TAnuGVta():New( "Informe anual de ventas de clientes agrupados por grupo de familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de ventas por grupo de familias", {|| TRenGVta():New( "Informe de rentabilidad de ventas por grupo de familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Ranking de ventas por grupo de familias", {|| TRnkGVta():New( "Ranking de ventas por grupo de familias" ):Play() } )

   oTrvTipo             := AddInforme( lArray, oTrvArbolGaleria, "Familias" )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Presupuestos" )
         AddInforme( lArray, oTrvDocumento, "Detalle de presupuestos por familias", {|| TInfFPre():New( "Informe detallado de presupuesto de clientes agrupado por familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de presupuestos por familias", {|| TAcuFPre():New( "Informe de acumulados de presupuestos por familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de presupuestos por familias", {|| TAnuFPre():New( "Informe anual de presupuestos de clientes agrupados por familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de presupuestos por familias", {|| TRenFPre():New( "Informe de rentabilidad de presupuestos por familias" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Pedidos" )
         AddInforme( lArray, oTrvDocumento, "Detalle de pedidos por familias", {|| TInfFPed():New( "Informe detallado de pedidos de clientes agrupado por familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de pedidos por familias", {|| TAcuFPed():New( "Informe de acumulados de pedidos por familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de pedidos por familias", {|| TAnuFPed():New( "Informe anual de pedidos de clientes agrupados por familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de pedidos por familias", {|| TRenFPed():New( "Informe de rentabilidad de pedidos por familias" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Albaranes" )
         AddInforme( lArray, oTrvDocumento, "Detalle de albaranes por familias", {|| TInfFAlb():New( "Informe detallado de albaranes de clientes agrupado por familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de albaranes por familias", {|| TAcuFAlb():New( "Informe de acumulados de albaranes por familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de albaranes por familias", {|| TAnuFAlb():New( "Informe anual de albaranes de clientes agrupados por familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de albaranes por familias", {|| TRenFAlb():New( "Informe de rentabilidad de albaranes por familias" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Facturas" )
         AddInforme( lArray, oTrvDocumento, "Detalle de facturas por familias", {|| TInfFFac():New( "Informe detallado de facturas de clientes agrupado por familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de facturas por familias", {|| TAcuFFac():New( "Informe de acumulados de facturas por familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de facturas por familias", {|| TAnuFFac():New( "Informe anual de facturas de clientes agrupados por familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de facturas por familias", {|| TRenFFac():New( "Informe de rentabilidad de facturas por familias" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Facturas rectificativas" )
         AddInforme( lArray, oTrvDocumento, "Detalle de facturas rectificativas por familias", {|| TInfFFacRec():New( "Informe detallado de facturas rectificativas de clientes agrupados por familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de facturas rectificativas por familias", {|| TAcuFFacRec():New( "Informe de acumulados de facturas rectificativas por familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de facturas rectificativas por familias", {|| TAnuFFacRec():New( "Informe anual de facturas rectificativas por familias" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Tickets" )
         AddInforme( lArray, oTrvDocumento, "Detalle de tikets por familias", {|| TInfFTik():New( "Informe detallado de tikets de clientes agrupados por familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de tikets por familias", {|| TAcuFTik():New( "Informe de acumulados de tikets por familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de tikets por familias", {|| TAnuFTik():New( "Informe anual de tikets de clientes agrupados por familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de tikets por familias", {|| TRenFTik():New( "Informe de rentabilidad de tikets por familias" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Ventas" )
         AddInforme( lArray, oTrvDocumento, "Detalle de ventas por familias", {|| TInfFVta():New( "Informe detallado de ventas de artículos agrupados por familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de ventas por familias", {|| TAcuFVta():New( "Informe de acumulados de ventas por familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de ventas por familias", {|| TAnuFVta():New( "Informe anual de ventas de clientes agrupados por familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de ventas por familias", {|| TRenFVta():New( "Informe de rentabilidad de ventas por familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Informe de ventas por familias entre almacenes", {|| TVtaAlm():New( "Informe de ventas por familias entre almacenes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Ranking de ventas por familias", {|| TRnkFVta():New( "Ranking de ventas por familias" ):Play() } )

   oTrvTipo             := AddInforme( lArray, oTrvArbolGaleria, "Tipos de artículos" )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "General" )
         AddInforme( lArray, oTrvDocumento, "Informe de artículos por tipos de artículos", {|| TInfArtTip():New( "Informe de artículos agrupados por tipos de artículos" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Presupuestos")
         AddInforme( lArray, oTrvDocumento, "Detalle de presupuestos por tipos de artículos", {|| TInfTPre():New( "Informe detallado de presupuestos por tipos de artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de presupuestos por tipos de artículos", {|| TAcuTPre():New( "Informe de acumulados de presupuestos por tipos de artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de presupuestos por tipos de artículos", {|| TAnuTPre():New( "Informe anual de presupuestos de clientes agrupados por tipos de artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de presupuestos por tipos de artículos", {|| TRenTPre():New( "Informe de rentabilidad de presupuestos por tipos de artículos" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Pedidos" )
         AddInforme( lArray, oTrvDocumento, "Detalle de pedidos por tipos de artículos", {|| TInfTPed():New( "Informe detallado de pedidos por tipos de artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de pedidos por tipos de artículos", {|| TAcuTPed():New( "Informe de acumulados de pedidos por tipos de artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de pedidos por tipos de artículos", {|| TAnuTPed():New( "Informe anual de pedidos de clientes agrupados por tipos de artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de pedidos por tipos de artículos", {|| TRenTPed():New( "Informe de rentabilidad de pedidos por tipos de artículos" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Albaranes" )
         AddInforme( lArray, oTrvDocumento, "Detalle de albaranes por tipos de artículos", {|| TInfTAlb():New( "Informe detallado de albaranes por tipos de artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de albaranes por tipos de artículos", {|| TAcuTAlb():New( "Informe de acumulados de albaranes por tipos de artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Contabilidad de existencias por tipos de artículos", {|| TInfTCon():New( "Informe detallado de contabilidad de existencias por tipos de artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de albaranes por tipos de artículos", {|| TAnuTAlb():New( "Informe anual de albaranes de clientes agrupados por tipos de artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de albaranes por tipos de artículos", {|| TRenTAlb():New( "Informe de rentabilidad de albaranes por tipos de artículos" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Facturas" )
         AddInforme( lArray, oTrvDocumento, "Detalle de facturas por tipos de artículos", {|| TInfTFac():New( "Informe detallado de facturas por tipos de artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de facturas por tipos de artículos", {|| TAcuTFac():New( "Informe de acumulados de facturas por tipos de artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de facturas por tipos de artículos", {|| TAnuTFac():New( "Informe anual de facturas de clientes agrupados por tipos de artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de facturas por tipos de artículos", {|| TRenTFac():New( "Informe de rentabilidad de facturas por tipos de artículos" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Facturas rectificativas" )
         AddInforme( lArray, oTrvDocumento, "Detalle de facturas rectificativas por tipos de artículos", {|| TInfTFacRec():New( "Informe detallado rectificativas de facturas por tipos de artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de facturas rectificativas por tipos de artículos", {|| TAcuTFacRec():New( "Informe de acumulados rectificativas de facturas por tipos de artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de facturas rectificativas por tipos de artículos", {|| TAnuTFacRec():New( "Informe anual de facturas rectificativas de clientes agrupados por tipos de artículos" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Tickets" )
         AddInforme( lArray, oTrvDocumento, "Detalle de tikets por tipos de artículos", {|| TInfTTik():New( "Informe detallado de tikets por tipos de artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de tikets por tipos de artículos", {|| TAcuTTik():New( "Informe de acumulados de tikets por tipos de artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de tikets por tipos de artículos", {|| TAnuTTik():New( "Informe anual de tikets de clientes agrupados por tipos de artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de tikets por tipos de artículos", {|| TRenTTik():New( "Informe de rentabilidad de tikets por tipos de artículos" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Ventas" )
         AddInforme( lArray, oTrvDocumento, "Detalle de ventas por tipos de artículos", {|| TInfTVta():New( "Informe detallado de ventas por tipos de artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de ventas por tipos de artículos", {|| TAcuTVta():New( "Informe de acumulados de ventas por tipos de artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de ventas por tipos de artículos", {|| TAnuTVta():New( "Informe anual de tikets de clientes agrupados por tipos de artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de ventas por tipos de artículos", {|| TRenTVta():New( "Informe de rentabilidad de ventas por tipos de artículos" ):Play() } )

         oTrvSubDoc     := AddInforme( lArray, oTrvDocumento, "Almacén" )
            AddInforme( lArray, oTrvSubDoc, "Detalle de ventas por tipos de artículos y almacén", {|| TInfATVta():New( "Informe detallado de ventas por tipos de artículos y almacén" ):Play() } )
            AddInforme( lArray, oTrvSubDoc, "Acumulado de ventas por tipos de artículos y almacén", {|| TAcuATVta():New( "Informe de acumulados de ventas por tipos de artículos y almacén" ):Play() } )
            AddInforme( lArray, oTrvSubDoc, "Rentabilidad de ventas por tipos de artículos y almacén", {|| TRenATVta():New( "Informe de rentabilidad de ventas por tipos de artículos y almacén" ):Play() } )

   oTrvTipo             := AddInforme( lArray, oTrvArbolGaleria, "Artículos" )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "General" )
         AddInforme( lArray, oTrvDocumento, "Informe de precios por artículos", {|| TInfArtPre():New( "Informe de precios de artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Ranking de facturación por artículos", {|| TRnkArticulo():New( "Informe de artículos ordenados por su consumo de facturación" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Informe de trazabilidad por lotes", {|| TInfLot():New( "Informe de trazabilidad por lotes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Informe detallado de escandallos", {|| TInfKit():New( "Informe detallado de componentes agrupados por compuestos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Informe detallado de compuestos", {|| TInfEsc():New( "Informe detallado de compuestos agrupados por componentes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Informe de últimos artículos modificados", {|| TInfChgArt():New( "Informe de últimos artículos modificados" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Informe de últimos artículos modificados por código de barras", {|| TInfChgBar():New( "Informe de últimos artículos modificados por códigos de barras" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Informe para generar tarifas", {|| TInfEsp():New( "Informe para generar tarifas" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Informe de artículos por fecha de caducidad", {|| TDiaCaducidad():New( "Informe de artículos por fecha de caducidad" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Presupuestos" )
         AddInforme( lArray, oTrvDocumento, "Detalle de presupuestos por artículos", {|| TInfRPre():New( "Informe detallado de presupuestos por artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de presupuestos por artículos", {|| TAcuRPre():New( "Informe de acumulados de presupuestos por artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de presupuestos por artículos", {|| TAnuRPre():New( "Informe anual de presupuestos de clientes agrupados por artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de presupuestos por artículos", {|| TRenRPre():New( "Informe de rentabilidad de presupuestos por artículos" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Pedidos" )
         AddInforme( lArray, oTrvDocumento, "Detalle de pedidos por artículos", {|| TInfRPed():New( "Informe detallado de pedidos por artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de pedidos por artículos", {|| TAcuRPed():New( "Informe de acumulados de pedidos por artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de pedidos por artículos", {|| TAnuRPed():New( "Informe anual de pedidos de clientes agrupados por artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de pedidos por artículos", {|| TRenRPed():New( "Informe de rentabilidad de pedidos por artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Estado actual de los pedidos", {|| TInfGesPed():New( "Detalle del estado actual de los pedidos de clientes" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Albaranes" )
         AddInforme( lArray, oTrvDocumento, "Detalle de albaranes por artículos", {|| TInfRAlb():New( "Informe detallado de albaranes de clientes agrupado por artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Detalle de albaranes por clientes y direcciones", {|| TInfCliObr():New( "Informe detallado de albaranes por clientes y direcciones" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Detalle de albaranes por agentes", {|| TdlAgeAlb():New( "Informe detallado de la liquidación de agentes en albaranes de clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de albaranes por artículos", {|| TAcuRAlb():New( "Informe de acumulados de albaranes por artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de albaranes por artículos", {|| TAnuRAlb():New( "Informe anual de albaranes de clientes agrupados por artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de albaranes por artículos", {|| TRenRAlb():New( "Informe de rentabilidad de albaranes por artículos" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Facturas" )
         AddInforme( lArray, oTrvDocumento, "Detalle de facturas por artículos", {|| TInfRFac():New( "Informe detallado de facturas de clientes agrupado por artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de facturas por artículos", {|| TAcuRFac():New( "Informe de acumulados de facturas por artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de facturas por artículos", {|| TAnuRFac():New( "Informe anual de facturas de clientes agrupados por artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de facturas por artículos", {|| TRenRFac():New( "Informe de rentabilidad de facturas por artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Detalle de facturación por clientes y familas", {|| TInfCliArt():New( "Informe detallado de facturación por clientes y familias" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Facturas rectificativas" )
         AddInforme( lArray, oTrvDocumento, "Detalle de facturas rectificativas por artículos", {|| TInfRFacRec():New( "Informe detallado de facturas rectificativas agrupadas por artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de facturas rectificativas por artículos", {|| TAcuRFacRec():New( "Informe de acumulados de facturas rectificativas por artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de facturas rectificativas por artículos", {|| TAnuRFacRec():New( "Informe anual de facturas rectificativas agrupadas por artículos" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Tickets" )
         AddInforme( lArray, oTrvDocumento, "Detalle de tikets por artículos", {|| TInfRTik():New( "Informe detallado de tikets de clientes agrupado por artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de tikets por artículos", {|| TAcuRTik():New( "Informe de acumulados de tikets por artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de tikets por artículos", {|| TAnuRTik():New( "Informe anual de tikets de clientes agrupados por artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de tikets por artículos", {|| TRenRTik():New( "Informe de rentabilidad de tikets por artículos" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Ventas" )
         AddInforme( lArray, oTrvDocumento, "Detalle de ventas por artículos", {|| TInfRVta():New( "Informe detallado de ventas de clientes agrupado por artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de ventas por artículos", {|| TAcuRVta():New( "Informe de acumulados de ventas por artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de ventas por artículos, clientes y código postal", {|| TAcuRCVta():New( "Informe de acumulados de ventas por artículos, clientes y código postal" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de unidades vendidas por cliente y artículo", {|| TUndCRVta():New( "Acumulado de unidades vendidas por cliente y artículo" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de unidades vendidas por artículo y fecha", {|| TDiaRentArticulo():New( "Acumulado de unidades vendidas por artículo y fecha" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de ventas por artículos", {|| TAnuRVta():New( "Informe anual de ventas de clientes agrupados por artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de unidades vendidas por artículos", {|| TAnuUndVta():New( "Informe anual de unidades vendidas por artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de ventas por artículos", {|| TRenRVta():New( "Informe de rentabilidad de ventas por artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Ranking de ventas por artículos", {|| TRnkRVta():New( "Ranking de ventas por artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Ranking de ventas de artículos agrupados por familias y grupos", {|| TRnkGFRVta():New( "Ranking de ventas de artículos agrupados por familias y grupos" ):Play() } )

         oTrvSubDoc     := AddInforme( lArray, oTrvDocumento, "Almacén" )
            AddInforme( lArray, oTrvSubDoc, "Informe de ventas por artículos entre almacenes", {|| TVtaFAlm():New( "Informe de ventas por artículos entre almacenes" ):Play() } )

         oTrvSubDoc     := AddInforme( lArray, oTrvDocumento, "Familias" )
            AddInforme( lArray, oTrvSubDoc, "Detalle de ventas de artículos agrupados por familias", {|| TInfRFVta():New( "Informe detallado de ventas de artículos agrupados por familias" ):Play() } )
            AddInforme( lArray, oTrvSubDoc, "Acumulado de ventas por artículos agrupados por familias", {|| TAcuRFVta():New( "Informe de acumulados de ventas por artículos agrupados por familias" ):Play() } )
            AddInforme( lArray, oTrvSubDoc, "Anual de ventas de artículos agrupados por familias", {|| TAnuRFVta():New( "Informe anual de ventas de artículos agrupados por familias" ):Play() } )
            AddInforme( lArray, oTrvSubDoc, "Rentabilidad de ventas de artículos por familias", {|| TRenRFVta():New( "Informe de rentabilidad de ventas de artículos por familias" ):Play() } )

         oTrvSubDoc     := AddInforme( lArray, oTrvDocumento, "Tipos de artículos" )
            AddInforme( lArray, oTrvSubDoc, "Acumulado de ventas de artículos por tipos de artículos", {|| TAcuRTVta():New( "Informe de acumulados de ventas de artículos por tipos de artículos" ):Play() } )
            AddInforme( lArray, oTrvSubDoc, "Rentabilidad de ventas agrupado por tipos de artículos", {|| TRenRTVta():New( "Informe de rentabilidad de ventas agrupado por tipos de artículos" ):Play() } )

         oTrvSubDoc     := AddInforme( lArray, oTrvDocumento, "Proveedor" )
            AddInforme( lArray, oTrvSubDoc, "Acumulado de ventas de artículos por proveedor", {|| TAcuRBVta():New( "Informe de acumulados de ventas de artículos por proveedor habitual" ):Play() } )


   oTrvTipo             := AddInforme( lArray, oTrvArbolGaleria, "Clientes" )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "General" )
         AddInforme( lArray, oTrvDocumento, "Estado de cuentas", {|| TICtaCli():New( "Informe detallado del estado de cuentas de cliente" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Tarifas personalizadas por clientes", {|| TarCli():New( "Tarifas personalizadas por clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Tarifas personalizadas por artículos", {|| TarArt():New( "Tarifas personalizadas por artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen del consumo de artículos en facturas", {|| TResCFac():New( "Informe resumido del consumo de artículos en facturas de clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Consumo de artículos en facturas por clientes", {|| TConFacCli():New( "Informe resumido del consumo de artículos en facturas agrupado por clientes" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Presupuestos" )
         AddInforme( lArray, oTrvDocumento, "Informe de presupuestos de clientes", {|| TInfPre():New( "Informe de presupuestos de clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Detalle de presupuestos por clientes", {|| TInfCPre():New( "Informe detallado de presupuestos por clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Detalle de presupuestos por código postal y clientes", {|| TInfCPrePob():New( "Informe detallado de presupuestos por código postal y clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de presupuestos por clientes", {|| TAcuCPre():New( "Informe de acumulados de presupuestos por clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de presupuestos por clientes", {|| TAnuCPre():New( "Informe anual de presupuestos por clientes" ):Play() } )
         /*
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de presupuestos por clientes", {|| TRenCPre():New( "Informe de rentabilidad de presupuestos por clientes" ):Play() } )
         */

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Pedidos" )
         AddInforme( lArray, oTrvDocumento, "Informe de pedidos de clientes", {|| TInfPed():New( "Informe de pedidos de clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Detalle de pedidos por clientes", {|| TInfCPed():New( "Informe detallado de pedidos por clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Detalle de pedidos por código postal y clientes", {|| TInfCPedPob():New( "Informe detallado de pedidos por código postal y clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de pedidos por clientes", {|| TAcuCPed():New( "Informe de acumulados de pedidos por clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de pedidos por clientes", {|| TAnuCPed():New( "Informe anual de pedidos por clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de pedidos por clientes", {|| TRenCPed():New( "Informe de rentabilidad de pedidos por clientes" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Albaranes" )
         AddInforme( lArray, oTrvDocumento, "Informe de albaranes de clientes", {|| TInfAlbT():New( "Informe de albaranes de clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Detalle de albaranes por clientes", {|| TInfCAlb():New( "Informe detallado de albaranes por clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Detalle de albaranes por código postal y clientes", {|| TInfCAlbPob():New( "Informe detallado de albaranes por código postal y clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de albaranes por clientes", {|| TAcuCAlb():New( "Informe de acumulados de albaranes por clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de albaranes por clientes", {|| TAnuCAlb():New( "Informe anual de albaranes por clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de albaranes por clientes", {|| TRenCAlb():New( "Informe de rentabilidad de albaranes por clientes" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Facturas" )
         AddInforme( lArray, oTrvDocumento, "Informe de facturas de clientes", {|| TInfFacT():New( "Informe de facturas de clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Detalle de facturas por clientes", {|| TInfCFac():New( "Informe detallado de facturas por clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Detalle de facturas por código postal y clientes", {|| TInfCFacPob():New( "Informe detallado de facturas por código postal y clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de facturas por clientes", {|| TAcuCFac():New( "Informe de acumulados de facturas por clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de facturas por clientes", {|| TAnuCFac():New( "Informe anual de facturas por clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de facturas por clientes", {|| TRenCFac():New( "Informe de rentabilidad de facturas por clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Detalle de facturas por clientes y direcciones", {|| TInfCObrFac():New( "Informe detallado de facturas por clientes y direcciones" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Facturas pendientes de cobro", {|| TIPdtCli():New( "Informe detallado de las facturas pendientes de cobro agrupado por clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Facturas pendientes de cobro por rutas", {|| TIPdtCob():New( "Informe detallado de facturas pendientes de cobro por rutas" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Estado de facturas por código postal", {|| TPdtCobPob():New( "Informe detallado de estado de facturas por código postal" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Detalle de facturas por tipo de impuestos", {|| TFacEmiIva():New( "Informe detallado de facturas por tipo de impuestos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de facturas por tipo de impuestos", {|| TAcuFacIva():New( "Informe acumulado de facturas por tipo de impuestos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Ranking de facturación por clientes", {|| TRanking():New( "Informe de clientes ordenados por su consumo de facturación" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Ranking de facturación pendiente por clientes", {|| TRnkFacPdt():New( "Ranking de facturación pendiente por clientes" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Facturas rectificativas" )
         AddInforme( lArray, oTrvDocumento, "Detalle de facturas rectificativas por clientes", {|| TInfCFacRec():New( "Informe detallado de facturas rectificativas por clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de facturas rectificativas por clientes", {|| TAcuCFacRec():New( "Informe de acumulados de facturas rectificativas por clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de facturas rectificativas por clientes", {|| TAnuCFacRec():New( "Informe anual de facturas rectificativas por clientes" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Tickets" )
         AddInforme( lArray, oTrvDocumento, "Informe de tikets de clientes", {|| TInfTpvT():New( "Informe de tikets de clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Detalle de tikets por clientes", {|| TInfCTik():New( "Informe detallado de tikets por clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Detalle de tikets por código postal y clientes", {|| TInfCTikPob():New( "Informe detallado de tikets por código postal y clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de tikets por clientes", {|| TAcuCTik():New( "Informe de acumulados de tikets por clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de tikets por clientes", {|| TAnuCTik():New( "Informe anual de tikets por clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de tikets por clientes", {|| TRenCTik():New( "Informe de rentabilidad de tikets por clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Artículos por contadores", {|| TFamConta():New( "Informe resumido de artículos por contadores agrupados por familias" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Ventas" )
         AddInforme( lArray, oTrvDocumento, "Informe de ventas de clientes", {|| TInfVtaT():New( "Informe de ventas de clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Detalle de ventas por clientes", {|| TInfCVta():New( "Informe detallado de ventas por clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Detalle de ventas por código postal y clientes", {|| TInfCVtaPob():New( "Informe detallado de ventas por código postal y clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de ventas por clientes", {|| TAcuCVta():New( "Informe de acumulados de ventas por clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de ventas por clientes", {|| TAnuCVta():New( "Informe anual de ventas por clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de ventas por clientes", {|| TRenCVta():New( "Informe de rentabilidad de ventas por clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen de ultimas ventas por familias", {|| TIUltFam():New( "Informe resumido de las últimas ventas a clientes por familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen de ultimas ventas por artículos", {|| TIUltArt():New( "Informe resumido de las últimas ventas a clientes por artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Ranking de ventas por clientes", {|| TRnkCVta():New( "Informe de clientes ordenados por su consumo " ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Recibos" )
         AddInforme( lArray, oTrvDocumento, "Recibos agrupados por clientes", {|| TPerRec():New( "Informe detallado de recibos agrupados por clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Recibos cobrados por dias transcurridos", {|| TEmiRec():New( "Informe detallado de recibos cobrados en un periodo de tiempo" ):Play() } )

   oTrvTipo             := AddInforme( lArray, oTrvArbolGaleria, "Agentes" )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "General" )
         AddInforme( lArray, oTrvDocumento, "Relación de clientes atendidos por cada agente", {|| TLisAgeInf():New( "Informe de los clientes a los que atiende cada agente" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Tarifas personalizadas por agentes", {|| TarAge():New( "Tarifas personalizadas por agentes" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Presupuestos" )
         AddInforme( lArray, oTrvDocumento, "Detalle de artículos de presupuestos por agentes", {|| TInfNPre():New( "Informe detallado de artículos por agentes en presupuestos de clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Detalle de presupuestos por agentes", {|| TdAgePre():New( "Informe detallado de la liquidación de agentes en presupuestos de clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de presupuestos por agentes", {|| TAnuNPre():New( "Informe anual de presupuestos por agentes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de presupuestos por agentes", {|| TRenNPre():New( "Informe de rentabilidad de presupuestos por agentes" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Pedidos" )
         AddInforme( lArray, oTrvDocumento, "Detalle de artículos de pedidos por agentes", {|| TInfNPed():New( "Informe detallado de artículos por agentes en pedidos de clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Detalle de pedidos por agentes", {|| TdAgePed():New( "Informe detallado de la liquidación de agentes en pedidos de clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de pedidos por agentes", {|| TAnuNPed():New( "Informe anual de pedidos por agentes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de pedidos por agentes", {|| TRenNPed():New( "Informe de rentabilidad de pedidos por agentes" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Albaranes" )
         AddInforme( lArray, oTrvDocumento, "Detalle de artículos de albaranes por agentes", {|| TInfNAlb():New( "Informe detallado de artículos por agentes en albaranes de clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Detalle de albaranes por agentes", {|| TdlAgeAlb():New( "Informe detallado de la liquidación de agentes en albaranes de clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de albaranes por agentes", {|| TAcuNAlb():New( "Informe de acumulados de albaranes por agentes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de albaranes por agentes", {|| TAnuNAlb():New( "Informe anual de albaranes por agentes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de albaranes por agentes", {|| TRenNAlb():New( "Informe de rentabilidad de albaranes por agentes" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Facturas" )
         AddInforme( lArray, oTrvDocumento, "Detalle de artículos de facturas por agentes", {|| TInfNFac():New( "Informe detallado de artículos por agentes en facturas de clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Detalle de facturas por agentes", {|| TDdAgeFac():New( "Informe detallado de la liquidación de agentes en facturas de clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de facturas por agentes", {|| TAcuNFac():New( "Informe de acumulados de facturas por agentes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de facturas por articulos y agentes", {|| TAcuRNFac():New( "Informe de acumulados de facturas por articulos y agentes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de facturas por agentes", {|| TAnuNFac():New( "Informe anual de facturas por agentes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de facturas por agentes", {|| TRenNFac():New( "Informe de rentabilidad de facturas por agentes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen de artículos por familias y agentes en facturas", {|| TflAgeFac():New( "Informe resumido de la liquidación de agentes agrupados por familias" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Facturas rectificativas" )
         AddInforme( lArray, oTrvDocumento, "Detalle de artículos de facturas rectificativas por agentes", {|| TInfNFacRec():New( "Informe detallado de artículos por agentes en facturas rectificativas  de clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de facturas rectificativas por agentes", {|| TAnuNFacRec():New( "Informe anual de facturas rectificativas por agentes" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Tickets" )
         AddInforme( lArray, oTrvDocumento, "Detalle de artículos de tikets por agentes ", {|| TInfNTik():New( "Informe detallado de artículos por agentes en tikets de clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Detalle de tikets por agentes", {|| TdAgeTik():New( "Informe detallado de la liquidación de agentes en tikets de clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de tikets por agentes", {|| TAnuNTik():New( "Informe anual de tikets por agentes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de tikets por agentes", {|| TRenNTik():New( "Informe de rentabilidad de tikets por agentes" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Ventas" )
         AddInforme( lArray, oTrvDocumento, "Detalle de artículos de ventas por agentes", {|| TInfNVta():New( "Informe detallado de artículos por agentes en ventas de clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Detalle de artículos de ventas por agentes y clientes", {|| TInfNCliVta():New( "Detalle de artículos de ventas por agentes y clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Detalle de artículos de ventas por agentes, rutas y clientes", {|| TInfNCliRutVta():New( "Detalle de artículos de ventas por agentes, rutas y clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Detalle de artículos de ventas por agentes y grupos de clientes", {|| TInfNGrCVta():New( "Detalle de artículos de ventas por agentes y grupos de clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Detalle de ventas por agentes", {|| TdAgeVta():New( "Informe detallado de la liquidación de agentes en ventas de clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de ventas por agentes", {|| TAnuNVta():New( "Informe anual de ventas por agentes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de ventas por agentes", {|| TRenNVta():New( "Informe de rentabilidad de ventas por agentes" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Cobros" )
         AddInforme( lArray, oTrvDocumento, "Detalle de cobros por agentes", {|| TInfCobAge():New( "Detalle de cobros por agentes" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Recibos" )
         AddInforme( lArray, oTrvDocumento, "Recibos agrupados por agentes y clientes", {|| TRecAge():New( "Informe detallado de recibos agrupados por agentes y clientes en un periodo de tiempo" ):Play() } )

   oTrvTipo             := AddInforme( lArray, oTrvArbolGaleria, "Rutas" )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "General" )
         AddInforme( lArray, oTrvDocumento, "Relación de clientes por ruta", {|| TLisRutInf():New( "Informe de los clientes por rutas" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen de tipos de artículos por rutas", {|| TTipFam():New( "Informe resumido de tipos de artículos por rutas" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen de grupos de familias por rutas", {|| TRutGrpFam():New( "Informe resumido de grupos de familias por rutas" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Clientes" )
         AddInforme( lArray, oTrvDocumento, "Resumen de familias por rutas", {|| TFamRut():New( "Informe resumido de familias por rutas" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Presupuestos" )
         AddInforme( lArray, oTrvDocumento, "Detalle de presupuestos por rutas", {|| TInfUPre():New( "Informe detallado de presupuestos por rutas" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de presupuestos por rutas", {|| TAcuUPre():New( "Informe de acumulados de presupuestos por rutas" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de presupuestos por rutas", {|| TAnuUPre():New( "Informe anual de presupuestos por rutas" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de presupuestos por rutas", {|| TRenUPre():New( "Informe de rentabilidad de presupuestos por rutas" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Pedidos" )
         AddInforme( lArray, oTrvDocumento, "Detalle de pedidos por rutas", {|| TInfUPed():New( "Informe detallado de pedidos por rutas" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de pedidos por rutas", {|| TAcuUPed():New( "Informe de acumulados de pedidos por rutas" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de pedidos por rutas", {|| TAnuUPed():New( "Informe anual de pedidos por rutas" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de pedidos por rutas", {|| TRenUPed():New( "Informe de rentabilidad de pedidos por rutas" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Albaranes" )
         AddInforme( lArray, oTrvDocumento, "Detalle de albaranes por rutas", {|| TInfUAlb():New( "Informe detallado de albaranes por rutas" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de albaranes por rutas", {|| TAcuUAlb():New( "Informe de acumulados de albaranes por rutas" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de albaranes por rutas", {|| TAnuUAlb():New( "Informe anual de albaranes por rutas" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de albaranes por rutas", {|| TRenUAlb():New( "Informe de rentabilidad de albaranes por rutas" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Facturas" )
         AddInforme( lArray, oTrvDocumento, "Detalle de facturas por rutas", {|| TInfUFac():New( "Informe detallado de facturas por rutas" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de facturas por rutas", {|| TAcuUFac():New( "Informe de acumulados de facturas por rutas" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de facturas por rutas", {|| TAnuUFac():New( "Informe anual de facturas por rutas" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de facturas por rutas", {|| TRenUFac():New( "Informe de rentabilidad de facturas por rutas" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen de facturas por familias", {|| TRFFacInf():New( "Informe detallado de facturas de clientes agrupado por familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen de facturas por artículos", {|| TRCFacInf():New( "Informe detallado de facturas de clientes agrupado por artículos" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Facturas rectificativas" )
         AddInforme( lArray, oTrvDocumento, "Detalle de facturas rectificativas por rutas", {|| TInfUFacRec():New( "Informe detallado de facturas rectificativas por rutas" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de facturas rectificativas por rutas", {|| TAcuUFacRec():New( "Informe de acumulados de facturas rectificativas por rutas" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de facturas rectificativas por rutas", {|| TAnuUFacRec():New( "Informe anual de facturas rectificativas por rutas" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Tickets" )
         AddInforme( lArray, oTrvDocumento, "Detalle de tikets por rutas", {|| TInfUTik():New( "Informe detallado de tikets por rutas" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de tikets por rutas", {|| TAcuUTik():New( "Informe de acumulados de tikets por rutas" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de tikets por rutas", {|| TAnuUTik():New( "Informe anual de tikets por rutas" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de tikets por rutas", {|| TRenUTik():New( "Informe de rentabilidad de tikets por rutas" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Ventas" )
         AddInforme( lArray, oTrvDocumento, "Detalle de ventas por rutas", {|| TInfUVta():New( "Informe detallado de ventas por rutas" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de ventas por rutas", {|| TAcuUVta():New( "Informe de acumulados de ventas por rutas" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de ventas por rutas", {|| TAnuUVta():New( "Informe anual de ventas por rutas" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de ventas por rutas", {|| TRenUVta():New( "Informe de rentabilidad de ventas por rutas" ):Play() } )

   oTrvTipo             := AddInforme( lArray, oTrvArbolGaleria, "Transportistas" )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Presupuestos" )
         AddInforme( lArray, oTrvDocumento, "Detalle de presupuestos por transportistas", {|| TInfPPre():New( "Informe detallado de presupuestos por transportistas" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de presupuestos por transportistas", {|| TAcuPPre():New( "Informe de acumulados de presupuestos por transportistas" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de presupuestos por transportistas", {|| TAnuPPre():New( "Informe anual de presupuestos por transportistas" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de presupuestos por transportistas", {|| TRenPPre():New( "Informe de rentabilidad de presupuestos por transportistas" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Pedidos" )
         AddInforme( lArray, oTrvDocumento, "Detalle de pedidos por transportistas", {|| TInfPPed():New( "Informe detallado de pedidos por transportistas" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de pedidos por transportistas", {|| TAcuPPed():New( "Informe de acumulados de pedidos por transportistas" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de pedidos por transportistas", {|| TAnuPPed():New( "Informe anual de pedidos por transportistas" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de pedidos por transportistas", {|| TRenPPed():New( "Informe de rentabilidad de pedidos por transportistas" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Albaranes" )
         AddInforme( lArray, oTrvDocumento, "Detalle de albaranes por transportistas", {|| TInfPAlb():New( "Informe detallado de albaranes por transportistas" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de albaranes por transportistas", {|| TAcuPAlb():New( "Informe de acumulados de albaranes por transportistas" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de albaranes por transportistas", {|| TAnuPAlb():New( "Informe anual de albaranes por transportistas" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de albaranes por transportistas", {|| TRenPAlb():New( "Informe de rentabilidad de albaranes por transportistas" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Facturas" )
         AddInforme( lArray, oTrvDocumento, "Detalle de facturas por transportistas", {|| TInfPFac():New( "Informe detallado de facturas por transportistas" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de facturas por transportistas", {|| TAcuPFac():New( "Informe de acumulados de facturas por transportistas" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de facturas por transportistas", {|| TAnuPFac():New( "Informe anual de facturas por transportistas" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de facturas por transportistas", {|| TRenPFac():New( "Informe de rentabilidad de facturas por transportistas" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Facturas rectificativas" )
         AddInforme( lArray, oTrvDocumento, "Detalle de facturas rectificativas por transportistas", {|| TInfPFacRec():New( "Informe detallado de facturas rectificativas por transportistas" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de facturas rectificativas por transportistas", {|| TAcuPFacRec():New( "Informe de acumulados de facturas rectificativas por transportistas" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de facturas rectificativas por transportistas", {|| TAnuPFacRec():New( "Informe anual de facturas rectificativas por transportistas" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Ventas" )
         AddInforme( lArray, oTrvDocumento, "Detalle de ventas por transportistas", {|| TInfPVta():New( "Informe detallado de ventas por transportistas" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de ventas por transportistas", {|| TAcuPVta():New( "Informe de acumulados de ventas por transportistas" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de ventas por transportistas", {|| TAnuPVta():New( "Informe anual de ventas por transportistas" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de ventas por transportistas", {|| TRenPVta():New( "Informe de rentabilidad de ventas por transportistas" ):Play() } )

   oTrvTipo             := AddInforme( lArray, oTrvArbolGaleria, "Usuarios" )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Presupuestos" )
         AddInforme( lArray, oTrvDocumento, "Detalle de presupuestos por usuarios", {|| TInfUsrPre():New( "Informe detallado de presupuestos por usuarios" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de presupuestos por usuarios", {|| TAcuUsrPre():New( "Informe de acumulados de presupuestos por usuarios" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de presupuestos por usuarios", {|| TAnuUsrPre():New( "Informe anual de presupuestos por usuarios" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de presupuestos por usuarios", {|| TRenUsrPre():New( "Informe de rentabilidad de presupuestos por usuarios" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Pedidos" )
         AddInforme( lArray, oTrvDocumento, "Detalle de pedidos por usuarios", {|| TInfUsrPed():New( "Informe detallado de pedidos por usuarios" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de pedidos por usuarios", {|| TAcuUsrPed():New( "Informe de acumulados de pedidos por usuarios" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de pedidos por usuarios", {|| TAnuUsrPed():New( "Informe anual de pedidos por usuarios" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de pedidos por usuarios", {|| TRenUsrPed():New( "Informe de rentabilidad de pedidos por usuarios" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Albaranes" )
         AddInforme( lArray, oTrvDocumento, "Detalle de albaranes por usuarios", {|| TInfUsrAlb():New( "Informe detallado de albaranes por usuarios" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de albaranes por usuarios", {|| TAcuUsrAlb():New( "Informe de acumulados de albaranes por usuarios" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de albaranes por usuarios", {|| TAnuUsrAlb():New( "Informe anual de albaranes por usuarios" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de albaranes por usuarios", {|| TRenUsrAlb():New( "Informe de rentabilidad de albaranes por usuarios" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Facturas" )
         AddInforme( lArray, oTrvDocumento, "Detalle de facturas por usuarios", {|| TInfUsrFac():New( "Informe detallado de facturas por usuarios" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de facturas por usuarios", {|| TAcuUsrFac():New( "Informe de acumulados de facturas por usuarios" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de facturas por usuarios", {|| TAnuUsrFac():New( "Informe anual de facturas por usuarios" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de facturas por usuarios", {|| TRenUsrFac():New( "Informe de rentabilidad de facturas por usuarios" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Facturas rectificativas" )
         AddInforme( lArray, oTrvDocumento, "Detalle de facturas rectificativas por usuarios", {|| TInfUsrFacRec():New( "Informe detallado de facturas rectificativas por usuarios" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de facturas rectificativas por usuarios", {|| TAcuUsrFacRec():New( "Informe de acumulados de facturas rectificativas por usuarios" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de facturas rectificativas por usuarios", {|| TAnuUsrFacRec():New( "Informe anual de facturas rectificativas por usuarios" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Tikets" )
         AddInforme( lArray, oTrvDocumento, "Detalle de tikets por usuarios", {|| TInfUsrTik():New( "Informe detallado de tikets por usuarios" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de tikets por usuarios", {|| TAcuUsrTik():New( "Informe de acumulados de tikets por usuarios" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de tikets por usuarios", {|| TAnuUsrTik():New( "Informe anual de tikets por usuarios" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de tikets por usuarios", {|| TRenUsrTik():New( "Informe de rentabilidad de tikets por usuarios" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Ventas" )
         AddInforme( lArray, oTrvDocumento, "Informe de ventas por usuarios", {|| TUsrTotVta():New( "Informe de ventas totales por usuarios" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Detalle de ventas por usuarios", {|| TInfUsrVta():New( "Informe detallado de ventas por usuarios" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de ventas por usuarios", {|| TAcuUsrVta():New( "Informe de acumulados de ventas por usuarios" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de ventas por usuarios", {|| TAnuUsrVta():New( "Informe anual de ventas por usuarios" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de ventas por usuarios", {|| TRenUsrVta():New( "Informe de rentabilidad de ventas por usuarios" ):Play() } )

   oTrvTipo             := AddInforme( lArray, oTrvArbolGaleria, "Grupos de clientes" )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "General" )
         AddInforme( lArray, oTrvDocumento, "Informe de clientes por grupos de clientes", {|| TGruCli():New( "Informe de clientes agrupados por grupos de clientes" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Presupuestos" )
         AddInforme( lArray, oTrvDocumento, "Detalle de presupuestos por grupo de clientes", {|| TInfXPre():New( "Informe detallado de presupuestos por grupo de clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de presupuestos por grupo de clientes", {|| TAcuXPre():New( "Informe de acumulados de presupuestos por grupo de clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de presupuestos por grupo de clientes", {|| TAnuXPre():New( "Informe anual de presupuestos por grupo de clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de presupuestos por grupo de clientes", {|| TRenXPre():New( "Informe de rentabilidad de presupuestos por grupo de clientes" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Pedidos" )
         AddInforme( lArray, oTrvDocumento, "Detalle de pedidos por grupo de clientes", {|| TInfXPed():New( "Informe detallado de pedidos por grupo de clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de pedidos por grupo de clientes", {|| TAcuXPed():New( "Informe de acumulados de pedidos por grupo de clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de pedidos por grupo de clientes", {|| TAnuXPed():New( "Informe anual de pedidos por grupo de clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de pedidos por grupo de clientes", {|| TRenXPed():New( "Informe de rentabilidad de pedidos por grupo de clientes" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Albaranes" )
         AddInforme( lArray, oTrvDocumento, "Detalle de albaranes por grupo de clientes", {|| TInfXAlb():New( "Informe detallado de albaranes por grupo de clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de albaranes por grupo de clientes", {|| TAcuXAlb():New( "Informe de acumulados de albaranes por grupo de clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de albaranes por grupo de clientes", {|| TAnuXAlb():New( "Informe anual de albaranes por grupo de clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de albaranes por grupo de clientes", {|| TRenXAlb():New( "Informe de rentabilidad de albaranes por grupo de clientes" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Facturas" )
         AddInforme( lArray, oTrvDocumento, "Detalle de facturas por grupo de clientes", {|| TInfXFac():New( "Informe detallado de facturas por grupo de clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de facturas por grupo de clientes", {|| TAcuXFac():New( "Informe de acumulados de facturas por grupo de clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de facturas por grupo de clientes", {|| TAnuXFac():New( "Informe anual de facturas por grupo de clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de facturas por grupo de clientes", {|| TRenXFac():New( "Informe de rentabilidad de facturas por grupo de clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen de facturas por grupos de clientes", {|| TRGruCliInf():New( "Informe resumido de facturas de clientes agrupado por grupos de clientes " ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Facturas rectificativas" )
         AddInforme( lArray, oTrvDocumento, "Detalle de facturas rectificativas por grupo de clientes", {|| TInfXFacRec():New( "Informe detallado de facturas rectificativas por grupo de clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de facturas rectificativas por grupo de clientes", {|| TAcuXFacRec():New( "Informe de acumulados de facturas rectificativas por grupo de clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de facturas rectificativas por grupo de clientes", {|| TAnuXFacRec():New( "Informe anual de facturas rectificativas por grupo de clientes" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Tickets" )
         AddInforme( lArray, oTrvDocumento, "Detalle de tikets por grupo de clientes", {|| TInfXTik():New( "Informe detallado de tikets por grupo de clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de tikets por grupo de clientes", {|| TAcuXTik():New( "Informe de acumulados de tikets por grupo de clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de tikets por grupo de clientes", {|| TAnuXTik():New( "Informe anual de tikets por grupo de clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de tikets por grupo de clientes", {|| TRenXTik():New( "Informe de rentabilidad de tikets por grupo de clientes" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Ventas" )
         AddInforme( lArray, oTrvDocumento, "Detalle de ventas por grupo de clientes", {|| TInfXVta():New( "Informe detallado de ventas por grupo de clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de ventas por grupo de clientes", {|| TAcuXVta():New( "Informe de acumulados de ventas por grupo de clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de ventas por grupo de clientes", {|| TAnuXVta():New( "Informe anual de ventas por grupo de clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de ventas por grupo de clientes", {|| TRenXVta():New( "Informe de rentabilidad de ventas por grupo de clientes" ):Play() } )

   oTrvTipo             := AddInforme( lArray, oTrvArbolGaleria, "Formas de pago" )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Recibos" )
         AddInforme( lArray, oTrvDocumento, "Detalle de recibos por formas de pago", {|| TFpgRec():New( "Informe detallado de recibos por formas de pago" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Detalle de recibos por formas de pago con vencimiento", {|| TInfPgoPob():New( "Informe de recibos por formas de pago con vencimiento" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Presupuestos" )
         AddInforme( lArray, oTrvDocumento, "Detalle de presupuestos por formas de pago", {|| TInfOPre():New( "Informe detallado de presupuestos por formas de pago" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de presupuestos por formas de pago", {|| TAcuOPre():New( "Informe de acumulados de presupuestos por formas de pago" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de presupuestos por formas de pago", {|| TAnuOPre():New( "Informe anual de presupuestos por formas de pago" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de presupuestos por formas de pago", {|| TRenOPre():New( "Informe de rentabilidad de presupuestos por formas de pago" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Pedidos" )
         AddInforme( lArray, oTrvDocumento, "Detalle de pedidos por formas de pago", {|| TInfOPed():New( "Informe detallado de pedidos por formas de pago" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de pedidos por formas de pago", {|| TAcuOPed():New( "Informe de acumulados de pedidos por formas de pago" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de pedidos por formas de pago", {|| TAnuOPed():New( "Informe anual de pedidos por formas de pago" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de pedidos por formas de pago", {|| TRenOPed():New( "Informe de rentabilidad de pedidos por formas de pago" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Albaranes" )
         AddInforme( lArray, oTrvDocumento, "Detalle de albaranes por formas de pago", {|| TInfOAlb():New( "Informe detallado de albaranes por formas de pago" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de albaranes por formas de pago", {|| TAcuOAlb():New( "Informe de acumulados de albaranes por formas de pago" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de albaranes por formas de pago", {|| TAnuOAlb():New( "Informe anual de albaranes por formas de pago" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de albaranes por formas de pago", {|| TRenOAlb():New( "Informe de rentabilidad de albaranes por formas de pago" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Facturas" )
         AddInforme( lArray, oTrvDocumento, "Detalle de facturas por formas de pago", {|| TInfOFac():New( "Informe detallado de facturas por formas de pago" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de facturas por formas de pago", {|| TAcuOFac():New( "Informe de acumulados de facturas por formas de pago" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de facturas por formas de pago", {|| TAnuOFac():New( "Informe anual de facturas por formas de pago" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de facturas por formas de pago", {|| TRenOFac():New( "Informe de rentabilidad de facturas por formas de pago" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Facturas rectificativas" )
         AddInforme( lArray, oTrvDocumento, "Detalle de facturas rectificativas por formas de pago", {|| TInfOFacRec():New( "Informe detallado de facturas rectificativas por formas de pago" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de facturas rectificativas por formas de pago", {|| TAcuOFacRec():New( "Informe de acumulados de facturas rectificativas por formas de pago" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de facturas rectificativas por formas de pago", {|| TAnuOFacRec():New( "Informe anual de facturas rectificativas por formas de pago" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Tikets" )
         AddInforme( lArray, oTrvDocumento, "Detalle de tikets por formas de pago", {|| TInfOTik():New( "Informe detallado de tikets por formas de pago" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de tikets por formas de pago", {|| TAcuOTik():New( "Informe de acumulados de tikets por formas de pago" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de tikets por formas de pago", {|| TAnuOTik():New( "Informe anual de tikets por formas de pago" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de tikets por formas de pago", {|| TRenOTik():New( "Informe de rentabilidad de tikets por formas de pago" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Ventas" )
         AddInforme( lArray, oTrvDocumento, "Detalle de ventas por formas de pago", {|| TInfOVta():New( "Informe detallado de ventas por formas de pago" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de ventas por formas de pago", {|| TAcuOVta():New( "Informe de acumulados de ventas por formas de pago" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de ventas por formas de pago", {|| TAnuOVta():New( "Informe anual de ventas por formas de pago" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Rentabilidad de ventas por formas de pago", {|| TRenOVta():New( "Informe de rentabilidad de ventas por formas de pago" ):Play() } )

   oTrvTipo             := AddInforme( lArray, oTrvArbolGaleria, "Diarios" )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Presupuestos" )
         AddInforme( lArray, oTrvDocumento, "Diario de presupuestos por clientes", {|| TDiaCPre():New( "Diario de presupuestos de clientes", , , , , , .f. ):Play()} )
         AddInforme( lArray, oTrvDocumento, "Diario de presupuestos agrupados por clientes", {|| TDiaCPre():New( "Diario de presupuestos de clientes agrupados por clientes", , , , , , .t. ):Play()} )
         AddInforme( lArray, oTrvDocumento, "Diario de rentabilidad por presupuestos", {|| TRenPre():New( "Diario de rentabilidad por presupuestos" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Pedidos" )
         AddInforme( lArray, oTrvDocumento, "Diario de pedidos por clientes", {|| TDiaCPed():New( "Diario de pedidos de clientes", , , , , , .f. ):Play()} )
         AddInforme( lArray, oTrvDocumento, "Diario de pedidos agrupados por clientes", {|| TDiaCPed():New( "Diario de pedidos de clientes agrupados por clientes", , , , , , .t. ):Play()} )
         AddInforme( lArray, oTrvDocumento, "Diario de rentabilidad por pedidos", {|| TRenPed():New( "Diario de rentabilidad por pedidos" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Albaranes" )
         AddInforme( lArray, oTrvDocumento, "Diario de albaranes por clientes", {|| TDiaCAlb():New( "Diario de albaranes de clientes", , , , , , .f. ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Diario de albaranes agrupados por clientes", {|| TDiaCAlb():New( "Diario de albaranes de clientes agrupados por clientes", , , , , , .t. ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Diario de albaranes por grupos de clientes", {|| TDiaXAlb():New( "Diario de albaranes de grupos de clientes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Diario de rentabilidad por albaranes", {|| TRenAlb():New( "Diario de rentabilidad por albaranes" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Facturas" )
         AddInforme( lArray, oTrvDocumento, "Diario de facturación por clientes", {|| TDiaCFac():New( "Diario de facturas de clientes", , , , , , .f. ):Play()} )
         AddInforme( lArray, oTrvDocumento, "Diario de facturación agrupados por clientes", {|| TDiaCFac():New( "Diario de facturación agrupados por clientes", , , , , , .t. ):Play()} )
         AddInforme( lArray, oTrvDocumento, "Diario de rentabilidad por facturas", {|| TRenFac():New( "Diario de rentabilidad por facturas" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Diario de facturación por rutas", {|| TDiaRutFac():New( "Diario de facturas de clientes agrupadas por rutas" ):Play()} )
         AddInforme( lArray, oTrvDocumento, "Diario de facturación por agentes", {|| TDiaAgeFac():New( "Diario de facturas de clientes agrupadas por agentes" ):Play()} )
         AddInforme( lArray, oTrvDocumento, "Diario de facturación por forma de pago", {|| TDiafPagoFac():New( "Diario de facturas de clientes agrupadas por formas de pago" ):Play()} )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Facturas rectificativas" )
         AddInforme( lArray, oTrvDocumento, "Diario de facturas rectificativas por clientes", {|| TDiaCFacRec():New( "Diario de facturas rectificativas de clientes", , , , , , .f. ):Play()} )
         AddInforme( lArray, oTrvDocumento, "Diario de facturas rectificativas agrupadas por clientes", {|| TDiaCFacRec():New( "Diario de facturas rectificativas agrupadas por clientes", , , , , , .t. ):Play()} )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Anticipos" )
         AddInforme( lArray, oTrvDocumento, "Diario de anticipos por clientes", {|| TDiaCAnt():New( "Diario de anticipos de clientes", , , , , , .f. ):Play()} )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Recibos" )
         AddInforme( lArray, oTrvDocumento, "Diario de recibos por clientes", {|| TDiaCRec():New( "Diario de recibos de clientes" ):Play()} )
         AddInforme( lArray, oTrvDocumento, "Diario de recibos cobrados", {|| TDiaCRecCob():New( "Diario de recibos cobrados" ):Play()} )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Pagos y cobros" )
         AddInforme( lArray, oTrvDocumento, "Diario de recibos pagados y cobrados", {|| TDiarioRecibos():New( "Diario de recibos pagados y cobrados" ):Play()} )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Tickets" )
         AddInforme( lArray, oTrvDocumento, "Diario de tikets", {|| TDiaTik():New( "Diario de tikets" ):Play()} )
         AddInforme( lArray, oTrvDocumento, "Diario de tikets por clientes", {|| TDiaCTik():New( "Diario de tikets de clientes", , , , , , .f. ):Play()} )
         AddInforme( lArray, oTrvDocumento, "Diario de tikets por clientes por caja", {|| TDiaCTikCaj():New( "Diario de tikets de clientes por caja" ):Play()} )
         AddInforme( lArray, oTrvDocumento, "Diario de vales por clientes", {|| TDiaCVal():New( "Diario de vales de clientes", , , , , , .f. ):Play()} )
         AddInforme( lArray, oTrvDocumento, "Diario de tikets agrupados por clientes", {|| TDiaCTik():New( "Diario de tikets de clientes agrupados por clientes", , , , , , .t. ):Play()} )
         AddInforme( lArray, oTrvDocumento, "Diario de rentabilidad por tikets", {|| TRenTik():New( "Diario de rentabilidad por tikets" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Ventas" )
         AddInforme( lArray, oTrvDocumento, "Diario de ventas por clientes", {|| TDiaCVta():New( "Diario de ventas de clientes", , , , , , .f. ):Play()} )
         AddInforme( lArray, oTrvDocumento, "Diario de ventas agrupados por clientes", {|| TDiaCVta():New( "Diario de ventas de clientes agrupados por clientes", , , , , , .t. ):Play()} )
         AddInforme( lArray, oTrvDocumento, "Diario de rentabilidad por ventas", {|| TRenVta():New( "Diario de rentabilidad por ventas" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Diario de ventas por tipo de impuestos", {|| TIvaVta():New( "Diario detallado de ventas por tipo de impuestos" ):Play() } )

   oTrvTipo             := AddInforme( lArray, oTrvArbolGaleria, "Entregas a cuenta" )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Pedidos" )
         AddInforme( lArray, oTrvDocumento, "Informe de entregas a cuenta de pedidos por forma de pago", {|| TInfEntPedPgo():New( "Informe de entregas a cuenta de pedidos por forma de pago" ):Play()} )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Albaranes" )
         AddInforme( lArray, oTrvDocumento, "Informe de entregas a cuenta de albaranes por forma de pago", {|| TInfEntAlbPgo():New( "Informe de entregas a cuenta de albaranes por forma de pago" ):Play()} )
         AddInforme( lArray, oTrvDocumento, "Informe de albaranes pendientes", {|| TInfAlbPdt():New( "Informe de albaranes pendientes" ):Play()} )

RETURN nil

//---------------------------------------------------------------------------//

Static Function CreateComprasReportGalery( oTrvArbolGaleria, lArray )

   local oTrvTipo
   local oTrvDocumento

   DEFAULT lArray       := .f.

   oTrvTipo             := AddInforme( lArray, oTrvArbolGaleria, "Almacenes" )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Pedidos" )
         AddInforme( lArray, oTrvDocumento, "Detalle de pedidos por almacenes", {||TPedPrv():New( "Informe detallado de pedidos de proveedores agrupados por almacenes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de pedidos por almacenes", {||OAcuAPed():New( "Informe de acumulados de pedidos por almacenes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de pedidos por almacenes", {||TAnuPedPrv():New( "Informe anual de pedidos de proveedores agrupados por almacenes" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Albaranes")
         AddInforme( lArray, oTrvDocumento, "Detalle de albaranes por almacenes", {||TInfAlbPrv():New( "Informe detallado de albaranes de proveedores agrupados por almacenes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de albaranes por almacenes", {||OAcuAAlb():New( "Informe de acumulados de albaranes por almacenes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de albaranes por almacenes", {||TAnuAlbPrv():New( "Informe anual de albaranes de proveedores agrupados por almacenes" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Facturas" )
         AddInforme( lArray, oTrvDocumento, "Detalle de facturas por almacenes", {||TInfFacPrv():New( "Informe detallado de facturas de proveedores agrupadas por almacenes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de facturas por almacenes", {||OAcuAFac():New( "Informe de acumulados de facturas por almacenes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de facturas por almacenes", {||TAnuFacPrv():New( "Informe anual de facturas de proveedores agrupadas por almacenes" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Compras" )
         AddInforme( lArray, oTrvDocumento, "Detalle de compras por almacenes", {||TInfComPrv():New( "Informe detallado de compras de proveedores por almacenes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de compras por almacenes", {||OAcuACom():New( "Informe de acumulados de compras por almacenes" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de compras por almacenes", {||TAnuComPrv():New( "Informe anual de compras de proveedores agrupados por almacenes" ):Play() } )

   oTrvTipo             := AddInforme( lArray, oTrvArbolGaleria, "Grupo de familias" )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Pedidos" )
         AddInforme( lArray, oTrvDocumento, "Detalle de pedidos por grupo de familias", {||OInfGPed():New( "Informe detallado de pedidos de proveedores por grupo de familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de pedidos por grupo de familias", {||OAcuGPed():New( "Informe de acumulados de pedidos por grupo de familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de pedidos por grupo de familias", {||OAnuGPed():New( "Informe anual de pedidos de proveedores agrupados por grupo de familias" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Albaranes" )
         AddInforme( lArray, oTrvDocumento, "Detalle de albaranes por grupo de familias", {||OInfGAlb():New( "Informe detallado de albaranes de proveedores por grupo de familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de albaranes por grupo de familias", {||OAcuGAlb():New( "Informe de acumulados de albaranes por grupo de familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de albaranes por grupo de familias", {||OAnuGAlb():New( "Informe anual de albaranes de proveedores agrupados por grupo de familias" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Facturas" )
         AddInforme( lArray, oTrvDocumento, "Detalle de facturas por grupo de familias", {||OInfGFac():New( "Informe detallado de facturas por grupo de familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de facturas por grupo de familias", {||OAcuGFac():New( "Informe de acumulados de facturas por grupo de familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de facturas por grupo de familias", {||OAnuGFac():New( "Informe anual de facturas de proveedores agrupados por grupo de familias" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Compras" )
         AddInforme( lArray, oTrvDocumento, "Detalle de compras por grupo de familias", {||OInfGCom():New( "Informe detallado de compras por grupo de familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de compras por grupo de familias", {||OAcuGCom():New( "Informe de acumulados de compras por grupo de familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de compras por grupo de familias", {||OAnuGCom():New( "Informe anual de compras de proveedores agrupados por grupo de familias" ):Play() } )

   oTrvTipo             := AddInforme( lArray, oTrvArbolGaleria, "Familias")

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Pedidos" )
         AddInforme( lArray, oTrvDocumento, "Detalle de pedidos por familias", {||OInfFPed():New( "Informe detallado de pedidos de proveedores por familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de pedidos por familias", {||OAcuFPed():New( "Informe de acumulados de pedidos por familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de pedidos por familias", {||OAnuFPed():New( "Informe anual de pedidos de proveedores agrupados por familias" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Albaranes" )
         AddInforme( lArray, oTrvDocumento, "Detalle de albaranes por familias", {||OInfFAlb():New( "Informe detallado de albaranes de proveedores por familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de albaranes por familias", {||OAcuFAlb():New( "Informe de acumulados de albaranes por familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de albaranes por familias", {||OAnuFAlb():New( "Informe anual de albaranes de proveedores agrupados por familias" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Facturas" )
         AddInforme( lArray, oTrvDocumento, "Detalle de facturas por familias", {||OInfFFac():New( "Informe detallado de facturas por familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de facturas por familias", {||OAcuFFac():New( "Informe de acumulados de facturas por familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de facturas por familias", {||OAnuFFac():New( "Informe anual de facturas de proveedores agrupados por familias" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Compras" )
         AddInforme( lArray, oTrvDocumento, "Detalle de compras por familias", {||OInfFCom():New( "Informe detallado de compras por familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de compras por familias", {||OAcuFCom():New( "Informe de acumulados de compras por familias" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de compras por familias", {||OAnuFCom():New( "Informe anual de compras de proveedores agrupados por familias" ):Play() } )

   oTrvTipo             := AddInforme( lArray, oTrvArbolGaleria, "Tipos de artículos")

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Pedidos" )
         AddInforme( lArray, oTrvDocumento, "Detalle de pedidos por tipos de artículos", {||OInfTPed():New( "Informe detallado de pedidos de proveedores por tipos de artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de pedidos por tipos de artículos", {||OAcuTPed():New( "Informe de acumulados de pedidos por tipos de artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de pedidos por tipos de artículos", {||OAnuTPed():New( "Informe anual de pedidos de proveedores agrupados por tipos de artículos" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Albaranes" )
         AddInforme( lArray, oTrvDocumento, "Detalle de albaranes por tipos de artículos", {||OInfTAlb():New( "Informe detallado de albaranes de proveedores por tipos de artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de albaranes por tipos de artículos", {||OAcuTAlb():New( "Informe de acumulados de albaranes por tipos de artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de albaranes por tipos de artículos", {||OAnuTAlb():New( "Informe anual de albaranes de proveedores agrupados por tipos de artículos" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Facturas" )
         AddInforme( lArray, oTrvDocumento, "Detalle de facturas por tipos de artículos", {||OInfTFac():New( "Informe detallado de facturas por tipos de artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de facturas por tipos de artículos", {||OAcuTFac():New( "Informe de acumulados de facturas por tipos de artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de facturas por tipos de artículos", {||OAnuTFac():New( "Informe anual de facturas de proveedores agrupados por tipos de artículos" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Compras" )
         AddInforme( lArray, oTrvDocumento, "Detalle de compras por tipos de artículos", {||OInfTCom():New( "Informe detallado de compras por tipos de artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de compras por tipos de artículos", {||OAcuTCom():New( "Informe de acumulados de compras por tipos de artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de compras por tipos de artículos", {||OAnuTCom():New( "Informe anual de compras de proveedores agrupados por tipos de artículos" ):Play() } )

   oTrvTipo             := AddInforme( lArray, oTrvArbolGaleria, "Artículos" )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "General" )
         AddInforme( lArray, oTrvDocumento, "Informe de artículos por proveedor habitual", {||TArtPrv():New( "Informe detallado de artículos agrupados por proveedor habitual" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Informe de trazabilidad por lotes", {|| OInfLot():New( "Informe de trazabilidad por lotes" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Pedidos" )
         AddInforme( lArray, oTrvDocumento, "Detalle de pedidos por artículos", {||OInfRPed():New( "Informe detallado de pedidos de proveedores por artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de pedidos por artículos", {||OAcuRPed():New( "Informe de acumulados de pedidos por artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de pedidos por artículos", {||OAnuRPed():New( "Informe anual de pedidos de proveedores agrupados por artículos" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Albaranes" )
         AddInforme( lArray, oTrvDocumento, "Detalle de albaranes por artículos", {||OInfRAlb():New( "Informe detallado de albaranes de proveedores por artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de albaranes por artículos", {||OAcuRAlb():New( "Informe de acumulados de albaranes por artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de albaranes por artículos", {||OAnuRAlb():New( "Informe anual de albaranes de proveedores agrupados por artículos" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Facturas" )
         AddInforme( lArray, oTrvDocumento, "Detalle de facturas por artículos", {||OInfRFac():New( "Informe detallado de facturas por artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de facturas por artículos", {||OAcuRFac():New( "Informe de acumulados de facturas por artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de facturas por artículos", {||OAnuRFac():New( "Informe anual de facturas de proveedores agrupados por tipos de artículos" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Compras" )
         AddInforme( lArray, oTrvDocumento, "Detalle de compras por artículos", {||OInfRCom():New( "Informe detallado de compras por artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de compras por artículos", {||OAcuRCom():New( "Informe de acumulados de compras por artículos" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de compras por artículos agrupados por proveedor", {||OAcuRBCom():New( "Informe de acumulados de compras por artículos agrupador por proveedor" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de compras por artículos", {||OAnuRCom():New( "Informe anual de compras de proveedores agrupados por artículos" ):Play() } )

   oTrvTipo             := AddInforme( lArray, oTrvArbolGaleria, "Proveedores" )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "General" )
         AddInforme( lArray, oTrvDocumento, "Estado de cuentas", {||TICtaPrv():New( "Informe detallado del estado de cuentas de proveedor" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Informe de rappels", {||OInfBRap():New( "Informe de rappels" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Pedidos" )
         AddInforme( lArray, oTrvDocumento, "Detalle de pedidos por proveedores", {||OInfBPed():New( "Informe detallado de pedidos por proveedores" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de pedidos por proveedores", {||OAcuBPed():New( "Informe de acumulados de pedidos por proveedores" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de pedidos por proveedores", {||OAnuBPed():New( "Informe anual de pedidos por proveedores" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Albaranes" )
         AddInforme( lArray, oTrvDocumento, "Detalle de albaranes por proveedores", {||OInfBAlb():New( "Informe detallado de albaranes por proveedores" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de albaranes por proveedores", {||OAcuBAlb():New( "Informe de acumulados de albaranes por proveedores" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de albaranes por proveedores", {||OAnuBAlb():New( "Informe anual de albaranes por proveedores" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Facturas" )
         AddInforme( lArray, oTrvDocumento, "Detalle de facturas por proveedores", {||OInfBFac():New( "Informe detallado de facturas por proveedores" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de facturas por proveedores", {||OAcuBFac():New( "Informe de acumulados de facturas por proveedores" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de facturas por proveedores", {||OAnuBFac():New( "Informe anual de facturas por proveedores" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Detalle de facturas por tipos de impuestos", {|| TFacRecIva():New( "Informe detallado de las facturas de proveedores agrupadas por tipo de impuestos" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Compras" )
         AddInforme( lArray, oTrvDocumento, "Detalle de compras por proveedores", {|| OInfBCom():New( "Informe detallado de compras por proveedores" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de compras por proveedores", {|| OAcuBCom():New( "Informe de acumulados de compras por proveedores" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de compras por proveedores", {|| OAnuBCom():New( "Informe anual de compras por proveedores" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen de ultimas compras por familias", {|| TIUltCom():New( "Informe resumido de las ultimas compras a proveedores por familias" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Recibos")
         AddInforme( lArray, oTrvDocumento, "Recibos agrupados por proveedores", {||TPgoPrv():New( "Informe detallado de recibos agrupados por proveedores" ):Play() } )

   oTrvTipo             := AddInforme( lArray, oTrvArbolGaleria, "Grupo de proveedores" )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Pedidos" )
         AddInforme( lArray, oTrvDocumento, "Detalle de pedidos por grupo de proveedores", {||OInfXPed():New( "Informe detallado de pedidos por grupo de proveedores" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de pedidos por grupo de proveedores", {||OAcuXPed():New( "Informe de acumulados de pedidos por grupo de proveedores" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de pedidos por grupo de proveedores", {||OAnuXPed():New( "Informe anual de pedidos por grupo de proveedores" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Albaranes" )
         AddInforme( lArray, oTrvDocumento, "Detalle de albaranes por grupo de proveedores", {||OInfXAlb():New( "Informe detallado de albaranes por grupo de proveedores" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de albaranes por grupo de proveedores", {||OAcuXAlb():New( "Informe de acumulados de albaranes grupo de por proveedores" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de albaranes por grupo de proveedores", {||OAnuXAlb():New( "Informe anual de albaranes por grupo de proveedores" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Facturas" )
         AddInforme( lArray, oTrvDocumento, "Detalle de facturas por grupo de proveedores", {||OInfXFac():New( "Informe detallado de facturas por grupo de proveedores" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de facturas por grupo de proveedores", {||OAcuXFac():New( "Informe de acumulados de facturas por grupo de proveedores" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de facturas por grupo de proveedores", {||OAnuXFac():New( "Informe anual de facturas por grupo de proveedores" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Compras" )
         AddInforme( lArray, oTrvDocumento, "Detalle de compras por  grupo de proveedores", {||OInfXCom():New( "Informe detallado de compras por grupo de proveedores" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de compras por  grupo de proveedores", {||OAcuXCom():New( "Informe de acumulados de compras por grupo de proveedores" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de compras por  grupo de proveedores", {||OAnuXCom():New( "Informe anual de compras por grupo de proveedores" ):Play() } )

   oTrvTipo             := AddInforme( lArray, oTrvArbolGaleria, "Formas de pago" )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Pedidos" )
         AddInforme( lArray, oTrvDocumento, "Detalle de pedidos por formas de pago", {||OInfOPed():New( "Informe detallado de pedidos de proveedores por formas de pago" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de pedidos por formas de pago", {||OAcuOPed():New( "Informe de acumulados de pedidos por formas de pago" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de pedidos por formas de pago", {||OAnuOPed():New( "Informe anual de pedidos de proveedores agrupados por formas de pago" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Albaranes" )
         AddInforme( lArray, oTrvDocumento, "Detalle de albaranes por formas de pago", {||OInfOAlb():New( "Informe detallado de albaranes de proveedores por formas de pago" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de albaranes por formas de pago", {||OAcuOAlb():New( "Informe de acumulados de albaranes por formas de pago" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de albaranes por formas de pago", {||OAnuOAlb():New( "Informe anual de albaranes de proveedores agrupados por formas de pago" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Facturas" )
         AddInforme( lArray, oTrvDocumento, "Detalle de facturas por formas de pago", {||OInfOFac():New( "Informe detallado de facturas por formas de pago" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de facturas por formas de pago", {||OAcuOFac():New( "Informe de acumulados de facturas por formas de pago" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de facturas por formas de pago", {||OAnuOFac():New( "Informe anual de facturas de proveedores agrupados por tipos de formas de pago" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Compras" )
         AddInforme( lArray, oTrvDocumento, "Detalle de compras por formas de pago", {||OInfOCom():New( "Informe detallado de compras por formas de pago" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Acumulado de compras por formas de pago", {||OAcuOCom():New("Informe de acumulados de compras por formas de pago" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Resumen anual de compras por formas de pago", {||OAnuOCom():New( "Informe anual de compras de proveedores agrupados por formas de pago" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Recibos" )
         AddInforme( lArray, oTrvDocumento, "Detalle de recibos por formas de pago", {|| TFpgRPrv():New( "Informe detallado de recibos por formas de pago" ):Play() } )

   oTrvTipo             := AddInforme( lArray, oTrvArbolGaleria, "Diarios" )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Pedidos" )
         AddInforme( lArray, oTrvDocumento, "Diario de pedidos de proveedores", {||TDiaPPed():New( "Diario de pedidos de proveedores", , , , , , .f. ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Diario de pedidos agrupado por proveedores", {||TDiaPPed():New( "Diario de pedidos agrupado por proveedores", , , , , , .t. ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Albaranes" )
         AddInforme( lArray, oTrvDocumento, "Diario de albaranes de proveedores", {||TDiaPAlb():New( "Diario de albaranes de proveedores", , , , , , .f. ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Diario de albaranes agrupado por proveedores", {||TDiaPAlb():New( "Diario de albaranes agrupado por proveedores", , , , , , .t. ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Facturas" )
         AddInforme( lArray, oTrvDocumento, "Diario de facturas de proveedores", {||TDiaPrFa():New( "Diario de facturas de proveedores", , , , , , .f. ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Diario de facturas agrupado por proveedores", {||TDiaPrFa():New( "Diario de facturas agrupado por proveedores", , , , , , .t. ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Recibos" )
         AddInforme( lArray, oTrvDocumento, "Diario de recibos por proveedores", {||TDiaPRec():New( "Diario de recibos de proveedores" ):Play()} )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Compras" )
         AddInforme( lArray, oTrvDocumento, "Diario de compras de proveedores", {||TDPrvCom():New( "Diario de compras de proveedores", , , , , , .f. ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Diario de compras agrupado por proveedores", {||TDPrvCom():New( "Diario de compras agrupado por proveedores", , , , , , .t. ):Play() } )

Return nil

//---------------------------------------------------------------------------//

Static Function CreateExistenciasReportGalery( oTrvArbolGaleria, lArray )

   local oTrvTipo
   local oTrvDocumento

   DEFAULT lArray       := .f.

   oTrvTipo             := AddInforme( lArray, oTrvArbolGaleria, "Almacenes" )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Inventario" )
         AddInforme( lArray, oTrvDocumento, "Informe de valoración de almacenes", {|| XTotAlm():New( "Informe de valoración de almacenes"):Play() } )

   oTrvTipo             := AddInforme( lArray, oTrvArbolGaleria, "Artículos" )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Movimientos" )
         AddInforme( lArray, oTrvDocumento, "Detalle de todos los movimientos de los artículos", {|| XMovArt():New( "Informe detallado de todos los movimientos de los artículos"):Play() } )
         AddInforme( lArray, oTrvDocumento, "Detalle de valoración de almacenes por precio medio", {|| XValRStkDet():New( "Informe detallado de valoración de almacenes por precio medio" ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Valoración de almacenes por precio medio", {|| XValRStk():New( "Informe de valoración de almacenes por precio medio" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Situación" )
         AddInforme( lArray, oTrvDocumento, "Stocks de artículos", {|| TTikStkA():New( "Informe resumido del stock de artículos", , , , , , .f. ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Stocks de artículos ( formato tiket )", {|| TTikStkA():New( "Informe resumido del stock de artículos", , , , , , .t. ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Compras, ventas y stocks de artículos", {|| XComVta():New( "Informe resumido de compras, ventas y stocks de artículos"):Play() } )
         AddInforme( lArray, oTrvDocumento, "Artículos con stocks bajo mínimo", {|| TStkMinArt():New( "Informe resumido de los artículos con stockaje bajo mínimo"):Play() } )
         AddInforme( lArray, oTrvDocumento, "Artículos con stocks bajo mínimo agrupados por proveedor", {|| TInfValStk():New( "Informe resumido de los artículos con stockaje bajo mínimo por proveedor"):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Inventario" )
         AddInforme( lArray, oTrvDocumento, "Informe de valoración de artículos", {|| XTotArt():New( "Informe de valoración de artículos"):Play() } )

   oTrvTipo             := AddInforme( lArray, oTrvArbolGaleria, "Familias" )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Movimientos" )
         AddInforme( lArray, oTrvDocumento, "Detalle de todos los movimientos de las familias", {|| XMovFam():New( "Informe detallado de todos los movimientos de las familias" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Situación" )
         AddInforme( lArray, oTrvDocumento, "Stocks de artículos por familias", {|| TInfTikStk():New( "Informe resumido del stock de artículos agrupados por familias", , , , , , .f. ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Stocks de artículos por familias ( formato tiket )", {|| TInfTikStk():New( "Informe resumido del stock de artículos agrupados por familias", , , , , , .t. ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Compras, ventas y stocks de artículos por familias", {|| XComFVta():New( "Informe resumido de compras, ventas y stocks de artículos por familias"):Play() } )
         AddInforme( lArray, oTrvDocumento, "Artículos con stocks bajo mínimo agrupados por familias", {|| TInfStockMinimoFamilia():New( "Informe resumido de los artículos con stockaje bajo mínimo por familias"):Play() }  )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Inventario" )
         AddInforme( lArray, oTrvDocumento, "Informe de valoración de almacenes por familias", {|| XInfValAlm():New( "Informe de valoración de almacenes por familias" ):Play() } )

   oTrvTipo             := AddInforme( lArray, oTrvArbolGaleria, "Grupos de familias" )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Movimientos" )
         AddInforme( lArray, oTrvDocumento, "Detalle de todos los movimientos de los grupos de familias", {|| XMovGrp():New( "Informe detallado de todos los movimientos de los grupos de familias" ):Play() } )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Situación" )
         AddInforme( lArray, oTrvDocumento, "Stocks de artículos por grupos de familias", {|| TInfTikStkG():New( "Informe resumido del stock de artículos agrupados por grupos de familias", , , , , , .f. ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Stocks de artículos por grupos de familias ( formato tiket )", {|| TInfTikStkG():New( "Informe resumido del stock de artículos agrupados por grupos de familias", , , , , , .t. ):Play() } )
         AddInforme( lArray, oTrvDocumento, "Compras, ventas y stocks de artículos por grupos de familias", {|| XComGVta():New( "Informe resumido de compras, ventas y stocks de artículos por grupos de familias"):Play() } )
         AddInforme( lArray, oTrvDocumento, "Artículos con stocks bajo mínimo por proveedor", {|| TArtStkMinGrp():New( "Artículos con stocks bajo mínimo por proveedor" ):Play() }  )
         AddInforme( lArray, oTrvDocumento, "Artículos con stocks bajo mínimo agrupados por grupos de familias", {|| TInfStockMinimoGrupo():New( "Informe resumido de los artículos con stockaje bajo mínimo por grupos de familias"):Play() }  )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Inventario" )
         AddInforme( lArray, oTrvDocumento, "Informe de valoración de almacenes por grupos de familias", {|| XValAlmGrp():New( "Informe de valoración de almacenes por grupos de familias" ):Play() } )

   oTrvTipo             := AddInforme( lArray, oTrvArbolGaleria, "Informes nuevos" )

      oTrvDocumento     := AddInforme( lArray, oTrvTipo, "Valoración de almacén" )
         AddInforme( lArray, oTrvDocumento, "Valoración de almacén", {|| TFastValoracionAlmacen():New( "Valoración de almacén" ):Play() } )

Return nil

//---------------------------------------------------------------------------//

Static Function CreateProduccionReportGalery( oTrvArbolGaleria, lArray )

   local oTrvTipo
   local oTrvProduccion

   DEFAULT lArray       := .f.

      oTrvTipo          := AddInforme( lArray, oTrvArbolGaleria, "Diarios" )

      oTrvProduccion    := AddInforme( lArray, oTrvTipo, "Partes de producción" )
         AddInforme( lArray, oTrvProduccion, "Detalle de partes de producción", {|| PInfDiaParte():New( "Diario detallado de partes de producción" ):Play() } )
         AddInforme( lArray, oTrvProduccion, "Acumulado de partes de producción", {|| PAcuDiaParte():New( "Diario acumulado de partes de producción" ):Play() } )

      oTrvProduccion    := AddInforme( lArray, oTrvTipo, "Materiales producidos" )
         AddInforme( lArray, oTrvProduccion, "Detalle de materiales producidos", {|| PInfDiaMateriales():New( "Diario detallado de materiales producidos" ):Play() } )
         AddInforme( lArray, oTrvProduccion, "Acumulado de materiales producidos", {|| PAcuDiaMateriales():New( "Diario acumulado de materiales producidos" ):Play() } )
         AddInforme( lArray, oTrvProduccion, "Resumen anual de materiales producidos", {|| PAnuDiaMateriales():New( "Diario anual de materiales producidos" ):Play() } )

      oTrvProduccion    := AddInforme( lArray, oTrvTipo, "Materias primas" )
         AddInforme( lArray, oTrvProduccion, "Detalle de materias primas", {|| PInfDiaMPrimas():New( "Diario detallado de materias primas" ):Play() } )
         AddInforme( lArray, oTrvProduccion, "Acumulado de materias primas", {|| PAcuDiaMPrimas():New( "Diario acumulado de materias primas" ):Play() } )
         AddInforme( lArray, oTrvProduccion, "Resumen anual de materias primas", {|| PAnuDiaMPrimas():New( "Diario anual de materias primas" ):Play() } )

      oTrvProduccion    := AddInforme( lArray, oTrvTipo, "Operarios" )
         AddInforme( lArray, oTrvProduccion, "Detalle de operarios", {|| PInfDiaOperarios():New( "Diario detallado de operarios" ):Play() } )
         AddInforme( lArray, oTrvProduccion, "Acumulado de operarios", {|| PAcuDiaOperarios():New( "Diario acumulado de operarios" ):Play() } )
         AddInforme( lArray, oTrvProduccion, "Resumen anual de operarios", {|| PAnuDiaOperarios():New( "Diario anual de operarios" ):Play() } )

      oTrvProduccion    := AddInforme( lArray, oTrvTipo, "Maquinaria" )
         AddInforme( lArray, oTrvProduccion, "Detalle de maquinaria", {|| PInfDiaMaquinaria():New( "Diario detallado de maquinaria" ):Play() } )
         AddInforme( lArray, oTrvProduccion, "Acumulado de maquinaria", {|| PAcuDiaMaquinaria():New( "Diario acumulado de maquinaria" ):Play() } )
         AddInforme( lArray, oTrvProduccion, "Resumen anual de maquinaria", {|| PAnuDiaMaquinaria():New( "Diario anual de maquinaria" ):Play() } )

Return nil

//---------------------------------------------------------------------------//

Function oWndBar() ; Return oWndBar

//---------------------------------------------------------------------------//


Function lHideBmp()

Return nil

//---------------------------------------------------------------------------//

Function TMySql()

Return nil

//---------------------------------------------------------------------------//

Function oMsgText()

Return nil

//---------------------------------------------------------------------------//

Function IsReport()

Return ( .t. )

//---------------------------------------------------------------------------//

Function cAlmUsr()

Return nil

//---------------------------------------------------------------------------//

Function cDlgUsr()

Return nil

//---------------------------------------------------------------------------//

Function GetProcAdd()

Return nil

//---------------------------------------------------------------------------//

Function Hb_DbCreateTemp()

Return nil

//---------------------------------------------------------------------------//

Static Function AddFavorito( oTrvArbolGaleria )

   local oDlg
   local oItem       := oTrvArbolGaleria:GetSelected()
   local oNombre
   local cNombre
   local oCarpeta
   local aCarpeta    := aFolder( dbfFolder )
   local cCarpeta    := "Favoritos"
   local oBtnAdd

   /*
   Comprobamos que hayamos seleccionado algun item ----------------------------
   */

   if Empty( oItem ) .or. oItem:ClassName() != "TTVITEM"
      MsgStop( "No ha seleccionado ningún informe para agregar a favoritos." )
      return .f.
   end if

   /*
   Comprobamos que seleccionemos un informe y no una rama padre ---------------
   */

   if Empty( oItem:Cargo )
      MsgStop( "Debe de seleccionar un informe." )
      return .f.
   end if

   cNombre        := Padr( oItem:cPrompt, 100 )

   DEFINE DIALOG oDlg RESOURCE "ADD_FAVORITOS" TITLE "Agregando a favoritos"

   REDEFINE GET oNombre VAR cNombre ;
      ID       100 ;
      OF       oDlg

   REDEFINE COMBOBOX oCarpeta VAR cCarpeta ;
      ID       120 ;
      ITEMS    aCarpeta ;
      OF       oDlg

   REDEFINE BTNBMP oBtnAdd ;
      ID       130 ;
      OF       oDlg ;
      RESOURCE "New16" ;
      NOBORDER ;
      TOOLTIP  "Añadir carpeta" ;
      ACTION   ( AddFolder( oCarpeta ) )

   REDEFINE BUTTON ;
      ID       500 ;
      OF       oDlg ;
      ACTION   ( SaveFavorito( oCarpeta, oItem, oNombre, oDlg ) )

   REDEFINE BUTTON ;
      ID       550 ;
      OF       oDlg ;
      ACTION   ( oDlg:end() )

   ACTIVATE DIALOG oDlg CENTER

Return nil

//---------------------------------------------------------------------------//

Static Function EditFavorito( oTrvArbolGaleria )

   local oDlg
   local oNombre
   local cNombre     := ""
   local oItem       := oTrvArbolGaleria:GetSelected()
   local oBtnAdd
   local oCarpeta
   local aCarpeta    := aFolder( dbfFolder )
   local cCarpeta    := ""

   /*
   Comprobamos que hayamos seleccionado algun item ----------------------------
   */

   if Empty( oItem ) .or. oItem:ClassName() != "TTVITEM"
      MsgStop( "No ha seleccionado ningún informe para modificarlo." )
      return .f.
   end if

   /*
   Comprobamos que seleccionemos un informe y no una rama padre ---------------
   */

   if Empty( oItem:Cargo )
      MsgStop( "Debe de seleccionar un informe." )
      return .f.
   end if

   cNombre        := Padr( oItem:cPrompt, 100 )
   cCarpeta       := oItem:Cargo:Carpeta

   DEFINE DIALOG oDlg RESOURCE "ADD_FAVORITOS" TITLE "Modificando a favoritos"

   REDEFINE GET oNombre VAR cNombre ;
      ID       100 ;
      OF       oDlg

   REDEFINE COMBOBOX oCarpeta VAR cCarpeta ;
      ID       120 ;
      ITEMS    aCarpeta ;
      OF       oDlg

   REDEFINE BTNBMP oBtnAdd ;
      ID       130 ;
      OF       oDlg ;
      RESOURCE "New16" ;
      NOBORDER ;
      TOOLTIP  "Añadir carpeta" ;
      ACTION   ( AddFolder( oCarpeta ) )

   REDEFINE BUTTON ;
      ID       500 ;
      OF       oDlg ;
      ACTION   ( SaveEditFavorito( oCarpeta, oItem, oNombre, oDlg, oTrvArbolGaleria ) )

   REDEFINE BUTTON ;
      ID       550 ;
      OF       oDlg ;
      ACTION   ( oDlg:end() )

   ACTIVATE DIALOG oDlg CENTER

Return nil

//---------------------------------------------------------------------------//

Static Function SaveEditFavorito( oCarpeta, oItem, oNombre, oDlg, oTrvArbolGaleria )

   local cCodUsr  := cCurUsr()
   local cNombre  := oNombre:VarGet()
   local cOldNom  := oItem:cPrompt
   local cOldCar  := oItem:Cargo:Carpeta
   local cCarpeta := oCarpeta:VarGet()
   local nRec     := ( dbfFavorito )->( Recno() )
   local nOrdAnt  := ( dbfFavorito )->( OrdSetFocus( "CUSRCARFAV" ) )

   if Empty( cNombre )
      msgStop( "Tiene que nombrar el informe para guardarlo en favoritos." )
      oNombre:SetFocus()
      return .f.
   end if

   ( dbfFavorito )->( dbGoTop() )

   if ( dbfFavorito )->( dbSeek( cCodUsr + cOldCar + cOldNom ) )

      if ( dbfFavorito )->( dbRLock() )
         ( dbfFavorito )->cCarpeta := cCarpeta
         ( dbfFavorito )->cNomFav  := cNombre
         ( dbfFavorito )->( dbUnLock() )
      end if

   end if

   ( dbfFavorito )->( OrdSetFocus( nOrdAnt ) )
   ( dbfFavorito )->( dbGoTo( nRec ) )

   oDlg:End( IDOK )

   if oDlg:nResult == IDOK
      oTrvArbolGaleria:DeleteAll()
      CreateFavoritoReportGalery( oTrvArbolGaleria )
      oTrvArbolGaleria:ExpandAll( oItem )
   end if

Return nil

//---------------------------------------------------------------------------//

Static Function DelFavorito( oTrvArbolGaleria )

   local cCodUsr     := cCurUsr()
   local oItem       := oTrvArbolGaleria:GetSelected()
   local cNombre     := ""
   local cCarpeta    := ""
   local nRec        := ( dbfFavorito )->( Recno() )
   local nOrdAnt     := ( dbfFavorito )->( OrdSetFocus( "CUSRCARFAV" ) )

   /*
   Comprobamos que hayamos seleccionado algun item ----------------------------
   */

   if Empty( oItem ) .or. oItem:ClassName() != "TTVITEM"
      MsgStop( "No ha seleccionado ningún informe para eliminarlo." )
      return .f.
   end if

   /*
   Comprobamos que seleccionemos un informe y no una rama padre ---------------
   */

   if Empty( oItem:Cargo )
      MsgStop( "Debe de seleccionar un informe." )
      return .f.
   end if

   cNombre     := oItem:cPrompt
   cCarpeta    := oItem:Cargo:Carpeta

   if oUser():lNotConfirmDelete() .or. ApoloMsgNoYes( "¿ Desea eliminar el informe " + AllTrim( cNombre ) +"?", "Selecciona una opción" )

      if ( dbfFavorito )->( dbSeek( cCodUsr + cCarpeta + cNombre ) )
         if dbLock( dbfFavorito )
            ( dbfFavorito )->( dbDelete() )
            ( dbfFavorito )->( dbUnLock() )
         end if
      end if

      oTrvArbolGaleria:DeleteAll()
      CreateFavoritoReportGalery( oTrvArbolGaleria )
      oTrvArbolGaleria:ExpandAll( oItem )

   end if

   ( dbfFavorito )->( OrdSetFocus( nOrdAnt ) )
   ( dbfFavorito )->( dbGoTo( nRec ) )

Return nil

//---------------------------------------------------------------------------//

Static Function AddFolder( oCarpeta )

   local oDlg
   local oGet
   local cGet := Space( 100 )

   DEFINE DIALOG oDlg RESOURCE "ADD_FOLDER" TITLE "Agregando a favoritos"

   REDEFINE GET oGet VAR cGet ;
      ID       100 ;
      OF       oDlg

   REDEFINE BUTTON ;
      ID       500 ;
      OF       oDlg ;
      ACTION   ( SaveFolder( oGet, oCarpeta, oDlg ) )

   REDEFINE BUTTON ;
      ID       550 ;
      OF       oDlg ;
      ACTION   ( oDlg:end() )

   ACTIVATE DIALOG oDlg CENTER

return nil

//---------------------------------------------------------------------------//

Static Function SaveFolder( oGet, oCarpeta, oDlg )

   local cCodigo  := oGet:VarGet()
   local cCodUsr  := cCurUsr()
   local nRec     := ( dbfFolder )->( Recno() )

   if Empty( cCodigo )
      MsgStop( "No puede añadir una carpeta sin nombre." )
      oGet:SetFocus()
      return .f.
   end if

   //añadimos la carpeta-------------------------------------------------------

   ( dbfFolder )->( dbGoTop() )

   if ( dbfFolder )->( dbSeek( cCodigo ) )
      MsgStop( "La carpeta ya existe." )
      oGet:SetFocus()
      return .f.
   else

      ( dbfFolder )->( dbAppend() )
      ( dbfFolder )->cCodUsr  := cCodUsr
      ( dbfFolder )->cNombre  := cCodigo
      ( dbfFolder )->( dbUnLock() )

      //actualizo el combo--------------------------------------------------------

      oCarpeta:SetItems( aFolder( dbfFolder ) )
      oCarpeta:Set( cCodigo )

      oCarpeta:Refresh()

   end if

   ( dbfFolder )->( dbGoTo( nRec ) )

   oDlg:end( IDOK )

return nil

//---------------------------------------------------------------------------//
/*Esta funcion crea por defecto una carpeta con el nombre favoritos*/

FUNCTION IsReportFolder()

   local oError
   local dbfFolder
   local dbfUser
   local lIsFolder   := .f.
   local oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      USE ( cPatEmp() + "CFGCAR.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CFGCAR", @dbfFolder ) )
      SET ADSINDEX TO ( cPatEmp() + "CFGCAR.CDX" ) ADDITIVE

      USE ( cPatDat() + "USERS.DBF" )     NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "USERS", @dbfUser ) )
      SET ADSINDEX TO ( cPatDat() + "USERS.CDX" ) ADDITIVE

      while !( dbfUser )->( eof() )

         if !( dbfFolder )->( dbSeek( ( dbfUser )->cCodUse + Padr( "Favoritos", 100 ) ) )
            ( dbfFolder )->( dbAppend() )
            ( dbfFolder )->cCodUsr     := ( dbfUser )->cCodUse
            ( dbfFolder )->cNombre     := "Favoritos"
            ( dbfFolder )->( dbUnLock() )
         end if

         ( dbfUser )->( dbSkip() )

      end while

      lIsFolder         := .t.

   RECOVER USING oError

      msgStop( "Imposible realizar las comprobación inicial de galeria de informenes" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE
   ErrorBlock( oBlock )

   CLOSE ( dbfFolder )
   CLOSE ( dbfUser )

 RETURN ( lIsFolder )

//---------------------------------------------------------------------------//

Function aFolder( dbfFolder )

   local aFolder  := {}
   local cCodUsr  := cCurUsr()
   local lClose   := .f.
   local nRec

   if dbfFolder == nil
      USE ( cPatEmp() + "CFGCAR.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CFGCAR", @dbfFolder ) )
      SET ADSINDEX TO ( cPatEmp() + "CFGCAR.CDX" ) ADDITIVE
      lClose      := .t.
   else
      nRec        := ( dbfFolder )->( RecNo() )
   end if

   /*
   Recorremos la base de datos metiendo todos los valores en una array que es la que vamos a devolver
   */

   ( dbfFolder )->( OrdScope( 0, cCodUsr ) )
   ( dbfFolder )->( OrdScope( 1, cCodUsr ) )

   ( dbfFolder )->( dbGoTop() )

   while !( dbfFolder )->( Eof() )
      aAdd( aFolder, ( dbfFolder )->cNombre )
      ( dbfFolder )->( dbSkip() )
   end while

   ( dbfFolder )->( OrdScope( 0, nil ) )
   ( dbfFolder )->( OrdScope( 1, nil ) )

   /*
   Cerramos la base de datos, o en el caso de no haberla abierto, la dejamos donde estaba
   */

   if lClose
      ( dbfFolder )->( dbCloseArea() )  
   else
      ( dbfFolder )->( dbGoto( nRec ) )
   end if

Return aFolder

//---------------------------------------------------------------------------//

Static Function SaveFavorito( oCarpeta, oItem, oNombre, oDlg )

   local cCodUsr  := cCurUsr()
   local cNombre  := oNombre:VarGet()
   local cNomRpt  := oItem:cPrompt
   local cCarpeta := oCarpeta:VarGet()
   local nRec     := ( dbfFavorito )->( Recno() )
   local nOrdAnt  := ( dbfFavorito )->( OrdSetFocus( "CUSRRPT" ) )

   if Empty( cNombre )
      msgStop( "Tiene que nombrar el informe para guardarlo en favoritos." )
      oNombre:SetFocus()
      return .f.
   end if

   ( dbfFavorito )->( dbGoTop() )

   if ( dbfFavorito )->( dbSeek( cCodUsr + cCarpeta + cNomRpt ) )
      msgStop( "El informe seleccionado ya se encuentra introducido en la carpeta " + AllTrim( cCarpeta ) )
      oCarpeta:SetFocus()
      return .f.
   else
      ( dbfFavorito )->( dbAppend() )
      ( dbfFavorito )->cCodUsr  := cCodUsr
      ( dbfFavorito )->cCarpeta := cCarpeta
      ( dbfFavorito )->cNomFav  := cNombre
      ( dbfFavorito )->cNomRpt  := cNomRpt
      ( dbfFavorito )->( dbUnLock() )
   end if

   ( dbfFavorito )->( OrdSetFocus( nOrdAnt ) )
   ( dbfFavorito )->( dbGoTo( nRec ) )

   oDlg:End( IDOK )

Return nil

//---------------------------------------------------------------------------//

Static function CreateFavoritoReportGalery( oTrvArbolGaleria )

   local n              := 0
   local cCodUsr        := cCurUsr()
   local nRecAnt        := ( dbfFavorito )->( Recno() )
   local nOrdAnt        := ( dbfFavorito )->( OrdSetFocus( "CUSRCAR" ) )
   local cCarpeta       := ""
   local oTrvFavorito
   local oTrvNodo

   ( dbfFavorito )->( OrdScope( 0, cCodUsr ) )
   ( dbfFavorito )->( OrdScope( 1, cCodUsr ) )

   ( dbfFavorito )->( dbGoTop() )
   while !( dbfFavorito )->( Eof() )

      sysRefresh()

      if cCarpeta == ( dbfFavorito )->cCarpeta

         n := aScan( aInforme, {|a| a[1] == rtrim( ( dbfFavorito )->cNomRpt ) } )

         if n != 0

            oTrvNodo                := oTrvFavorito:Add( AllTrim( ( dbfFavorito )->cNomFav ), 0 )

            oTrvNodo:Cargo          := SInforme()
            oTrvNodo:Cargo:Accion   := aInforme[ n, 2 ]
            oTrvNodo:Cargo:Carpeta  := ( dbfFavorito )->cCarpeta

         end if

      else

         oTrvFavorito   := oTrvArbolGaleria:Add( AllTrim( ( dbfFavorito )->cCarpeta ) )

         n := aScan( aInforme, {|a| a[1] == rTrim( ( dbfFavorito )->cNomRpt ) } )

         if n != 0

            oTrvNodo                := oTrvFavorito:Add( AllTrim( ( dbfFavorito )->cNomFav ), 0 )

            oTrvNodo:Cargo          := SInforme()
            oTrvNodo:Cargo:Accion   := aInforme[ n, 2 ]
            oTrvNodo:Cargo:Carpeta  := ( dbfFavorito )->cCarpeta

         end if

         cCarpeta                   := ( dbfFavorito )->cCarpeta

      end if

      ( dbfFavorito )->( dbSkip() )

   end if

   ( dbfFavorito )->( OrdScope( 0, nil ) )
   ( dbfFavorito )->( OrdScope( 1, nil ) )

   ( dbfFavorito )->( OrdSetFocus( nOrdAnt ) )
   ( dbfFavorito )->( dbGoTo( nRecAnt ) )

Return nil

//---------------------------------------------------------------------------//

Static Function AddInforme( lArray, oTree, cNombre, bInforme )

   local oItem

   if lArray

      if bInforme != nil
         aAdd( aInforme, { rTrim( cNombre ), bInforme } )
      end if

   else

      if bInforme != nil
         oItem       := oTree:Add( cNombre, 0 )
         oItem:Cargo := bInforme
         return ( oItem )
      else
         return oTree:Add( cNombre )
      end if

   end if

Return nil

//---------------------------------------------------------------------------//

Function TWMail()

Return nil

//---------------------------------------------------------------------------//

function ReportBar()

   local oWnd
   local oBar
   local oReBar
   local oToolBar

   local oCarpeta0

   local oGrp1
   local oGrp2
   local oGrp3

   local oIconApp

   local nScreenHorzRes       := Round( ( GetSysMetrics( 0 ) - 720 ) / 2, 0 )

   DEFINE ICON oIconApp RESOURCE "Gestool"

   CreateVentasReportGalery( , .t. )
   CreateComprasReportGalery( , .t. )
   CreateExistenciasReportGalery( , .t. )
   CreateProduccionReportGalery( , .t. )

   // Creamos por defecto la carpeta favoritos---------------------------------

   IsReportFolder()

   if !lOpenFiles()
      return nil
   end if

   DEFINE WINDOW  oWnd ;
      FROM        120, nScreenHorzRes TO 680, ( nScreenHorzRes + 720 ) PIXEL ;
      TITLE       __GSTROTOR__ + Space( 1 ) + __GSTVERSION__ + " - Galeria de informes : " + cCodEmp() + " - " + cNbrEmp() ;
      ICON        oIconApp

      oBar           := TDotNetBar():New( 0, 0, 1000, 120, oWnd, 1 )
      oBar:lPaintAll := .f.
      oBar:lDisenio  := .f.

      oBar:SetStyle( 1 )

      oWnd:oTop      := oBar

         oCarpeta0   := TCarpeta():New( oBar, "General" )

            oGrp1                := TDotNetGroup():New( oCarpeta0, 308, "Informes", .f., , "" )

               oBtnVentas        := TDotNetButton():New( 60, oGrp1, "gc_money2_32",             "Ventas",      1, {|| SelectReportBar( 1, oBtnVentas ) }, , , .f., .f., .f. )
               oBtnVentas:lSelected := .t.

               oBtnCompras       := TDotNetButton():New( 60, oGrp1, "gc_small_truck_32",                "Compras",     2, {|| SelectReportBar( 2, oBtnCompras ) }, , , .f., .f., .f. )
               oBtnExistencias   := TDotNetButton():New( 60, oGrp1, "gc_package_32",                  "Existencias", 3, {|| SelectReportBar( 3, oBtnExistencias ) }, , , .f., .f., .f. )
               oBtnProduccion    := TDotNetButton():New( 60, oGrp1, "gc_worker2_32",                   "Producción",  4, {|| SelectReportBar( 4, oBtnProduccion ) }, , , .f., .f., .f. )
               oBtnFavoritos     := TDotNetButton():New( 60, oGrp1, "gc_star2_32",              "Favoritos",   5, {|| SelectReportBar( 5, oBtnFavoritos ) }, , , .f., .f., .f. )

            oGrp2                := TDotNetGroup():New( oCarpeta0, 186, "Favoritos", .f., , "" )

               oBtnAddFavorito   := TDotNetButton():New( 60, oGrp2, "gc_star2_add_32",       "Añadir",      1, {|| AddFavorito( oTrvGaleria ) }, , , .f., .f., .f. )
               oBtnEditFavorito  := TDotNetButton():New( 60, oGrp2, "gc_star2_edit_32",      "Modificar",   2, {|| EditFavorito( oTrvGaleria ) }, , , .f., .f., .f. )
               oBtnDelFavorito   := TDotNetButton():New( 60, oGrp2, "gc_star2_delete_32",    "Eliminar",    3, {|| DelFavorito( oTrvGaleria ) }, , , .f., .f., .f. )

            oGrp3                := TDotNetGroup():New( oCarpeta0, 124, "Acciones", .f., , "" )
               oBtnEjecutar      := TDotNetButton():New( 60, oGrp3, "gc_flash_32",                    "Ejecutar",    1, {|| ExecuteReportGalery( oTrvGaleria ) }, , , .f., .f., .f. )
               oBtnSalir         := TDotNetButton():New( 60, oGrp3, "gc_door_open2_32",                     "Salir",       2, {|| oWnd:End() }, , , .f., .f., .f. )

      oBtnEditFavorito:lEnabled  := .f.
      oBtnDelFavorito:lEnabled   := .f.

      oTrvGaleria                := TTreeView():New( 2, 0, oWnd  )
      oTrvGaleria:bLDblClick     := {|| ExecuteReportGalery( oTrvGaleria ) }

      oWnd:oClient               := oTrvGaleria

      /*
      oReBar                     := TReBar():New( oWnd )
      oToolBar                   := TToolBar():New( oReBar, 20, 20, , .t. )
      */

      CreateVentasReportGalery( oTrvGaleria, .f. )

   ACTIVATE WINDOW oWnd

   CloseFiles()

return 0

//---------------------------------------------------------------------------//

Static Function SelectReportBar( nOption, oSender )

   oBtnVentas:lSelected       := .f.
   oBtnCompras:lSelected      := .f.
   oBtnExistencias:lSelected  := .f.
   oBtnProduccion:lSelected   := .f.
   oBtnFavoritos:lSelected    := .f.

   oSender:lSelected          := .t.

   oTrvGaleria:DeleteAll()

   do case
      case nOption == 1
         oBtnAddFavorito:lEnabled   := .t.
         oBtnEditFavorito:lEnabled  := .f.
         oBtnDelFavorito:lEnabled   := .f.
         CreateVentasReportGalery( oTrvGaleria, .f. )

      case nOption == 2
         oBtnAddFavorito:lEnabled   := .t.
         oBtnEditFavorito:lEnabled  := .f.
         oBtnDelFavorito:lEnabled   := .f.
         CreateComprasReportGalery( oTrvGaleria, .f. )

      case nOption == 3
         oBtnAddFavorito:lEnabled   := .t.
         oBtnEditFavorito:lEnabled  := .f.
         oBtnDelFavorito:lEnabled   := .f.
         CreateExistenciasReportGalery( oTrvGaleria, .f. )

      case nOption == 4
         oBtnAddFavorito:lEnabled   := .t.
         oBtnEditFavorito:lEnabled  := .f.
         oBtnDelFavorito:lEnabled   := .f.
         CreateProduccionReportGalery( oTrvGaleria, .f. )

      case nOption == 5
         oBtnAddFavorito:lEnabled   := .f.
         oBtnEditFavorito:lEnabled  := .t.
         oBtnDelFavorito:lEnabled   := .t.
         CreateFavoritoReportGalery( oTrvGaleria )

   end case

Return nil

//---------------------------------------------------------------------------//

CLASS SInforme
   DATA Accion
   DATA Carpeta
END CLASS

//---------------------------------------------------------------------------//

Function SetAutoRecive()

Return nil

//---------------------------------------------------------------------------//

Function KillAutoRecive()

Return nil

//---------------------------------------------------------------------------//

Function InitServices()

Return nil

//---------------------------------------------------------------------------//

Function StopServices()

Return nil

//---------------------------------------------------------------------------//

Function CursorOpenHand()

Return ( 0 )

//---------------------------------------------------------------------------//

Function BmpToStr()

Return ( "" )

//---------------------------------------------------------------------------//

Function Sleep()

Return nil

//---------------------------------------------------------------------------//

Function FwBmpOn()

Return nil

//---------------------------------------------------------------------------//

Function FwBmpOff()

Return nil

//---------------------------------------------------------------------------//

Function GradientFill()

Return nil

//---------------------------------------------------------------------------//

Function SetAlpha()

Return ( .f. )

//---------------------------------------------------------------------------//

Function HasAlpha()

Return nil

//---------------------------------------------------------------------------//

Function ReSizeBmp()

Return nil

//---------------------------------------------------------------------------//

Function TTimePick()

Return nil

//---------------------------------------------------------------------------//

Function TFacAutomatica()

Return nil

//---------------------------------------------------------------------------//

Function TDetFacAutomatica()

Return nil

//---------------------------------------------------------------------------//

Function TCobAge()

Return nil

//---------------------------------------------------------------------------//

Function TDetCobAge()

Return nil

//---------------------------------------------------------------------------//

Function TFastComprasProveedores()

Return nil

//---------------------------------------------------------------------------//

Function TFastProduccion()

Return nil

//---------------------------------------------------------------------------//

Function lInitCheck()

Return nil

//---------------------------------------------------------------------------//

Function EnableAcceso()

Return nil

//---------------------------------------------------------------------------//

Function DisableAcceso()

Return nil

//---------------------------------------------------------------------------//

Function TSeaNumSer()

Return nil

//---------------------------------------------------------------------------//

Function TNumerosSerie()

Return nil

//---------------------------------------------------------------------------//

Function cNameVersion()

Return nil

//---------------------------------------------------------------------------//

Function C5ImageView()

Return nil

Function C5ImageViewItem()

Return nil

Function TTpvRestaurante()

Return nil

Function cTypeVersion( cType )

Return nil 

Function TComercio()

Return nil

Function TAcceso()

Return nil

Function TDetSalaVenta()

Return nil

Function TGrpFacturasAutomaticas()

Return nil 

Function Cuaderno1914()

Return nil 

Function GetBic()

Return nil

Function TProyecto()

Return nil

Function TFacturarLineasAlbaranes()

Return nil

Function PageIniClient()
Return nil

Function TListViewItem()
Return nil

Function TFacturarLineasAlbaranesProveedor()
Return nil

Function TGenMailing()
Return nil

Function TGenMailingClientes()
Return nil

Function TGenMailingProveedores()
Return nil

Function TGenMailingDatabase()
Return nil

Function TGenMailingDocuments()
Return nil

Function TGenMailingSelection()
Return nil

Function TGenMailingSerialDocuments()
Return nil

Function TSendMailCDO()
Return nil

Function TSendMailOutlook()
Return nil

Function TTemplatesHtml()
Return nil

Function PedidoCliente()
Return nil

Function ClienteRutaNavigator()
Return nil

Function TGenMailingDatabaseFacturasClientes()
Return nil

Function TGENMAILINGDATABASEPRESUPUESTOSCLIENTES()
Return nil

Function TGENMAILINGDATABASEPEDIDOSCLIENTES() 
Return nil

Function TGENMAILINGDATABASESATCLIENTES()
Return nil

Function TGENMAILINGDATABASEALBARANESCLIENTES()
Return nil

Function GENERAFACTURASCLIENTES()
Return nil

Function ACCESSCODE()
Return nil

Function TSPECIALSEARCHARTICULO
Return nil

Function TSpecialInfoArticulo
Return nil

Function TSpecialInfoCliente
Return nil

Function TAutoCombo()
Return nil

Function TSendMail()
Return nil

Function PedCLiente2PedProveedor()
Return nil

Function TGenMailingDatabasePedidosProveedor()
Return nil

Function TGenMailingDatabaseAlbaranesProveedor()
Return nil

Function TGenMailingDatabaseFacturaProveedor()
Return nil

Function TGenMailingDatabaseFacturaRectificativaCliente()
Return nil

Function TGenMailingDatabaseFacturaRectificativaProveedor()
Return nil

Function OrderCustomer()
Return nil

Function TConversionPedidosProveedores()
Return nil

Function TGeneracionAlbaranesClientes()
Return nil

Function SepaXml()
Return nil

Function id_File()
Return nil

Function SepaDebitactor()
Return nil

Function sDate()
Return nil

Function id_name()
Return nil

Function TComercioConfig()
Return nil

Function TPrestashopId()
Return nil

Function TFastReportOptions()
Return nil

Function TFtpCUrl()
Return nil

Function TConversionPedidosClientes()
Return nil

Function validRunReport()
Return .t.

Function ClientesModel()
Return nil

Function TSituaciones()
Return nil

Function TiposImpresoras()
Return nil

Function TiposImpresorasModel()
Return nil

Function TiposNotasModel()
Return nil

Function ArticulosModel()
Return nil

Function AlbaranesClientesModel()
Return nil

Function FacturasClientesModel()
Return nil

Function PedidosProveedoresModel()
Return nil

Function lFacturasAutomaticas()
Return nil

Function Etiquetas()
Return nil

Function CloseWebBrowser()
Return nil

Function TGrupoAcceso()
Return nil

Function PageIni()
Return nil

Function TiposNotas()
Return nil

Function ActualizaCosto()
Return nil

Function StartFacturaAutomatica()
Return nil

Function StartTCobAge()
Return nil

Function TpvTactil()
Return nil

Function ImpFacCom()
Return nil

Function TImpEstudio()
Return nil

Function SQLBaseView()
Return nil

Function SituacionesModel()
Return nil

Function SQLTShell()
Return nil



Function TiposVentasController()
Return nil

Function TIPOSIMPRESORASCONTROLLER()
Return nil

Function ETIQUETASMODEL()
Return nil

Function TTAGEVER()
Return nil

Function ETIQUETASCONTROLLER()
Return nil

Function RELACIONESETIQUETASMODEL()
Return nil

Function HISTORICOSUSUARIOSMODEL()
Return nil

Function TIPOSVENTASMODEL()
Return nil

Function PEDIDOSCLIENTESLINEASMODEL()
Return nil

Function AITMCATEGORIA()
Return nil

Function SITUACIONESCONTROLLER()
Return nil

Function TIPOSNOTASCONTROLLER()
Return nil

Function STARTTFACAUTOMATICA()
Return nil

FUNCTION GETSQLDATABASE()
Return nil

FUNCTION FWOPENPNGFILE()
Return nil

//------------------------------------------------------------------//

#pragma BEGINDUMP

#include <C:\bcc582\Include\windows.h>
#include <C:\bcc582\Include\winuser.h>
#include <C:\bcc582\Include\wingdi.h>
#include "hbapi.h"

HB_FUNC( SETWINDOWRGN )
{
   hb_retni( SetWindowRgn( ( HWND ) hb_parnl( 1 ), ( HRGN ) hb_parnl( 2 ), hb_parl( 3 ) ) );
}

#pragma ENDDUMP

//------------------------------------------------------------------//