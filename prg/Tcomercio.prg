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
Static oMsgAlarm

//---------------------------------------------------------------------------//

CLASS TComercio

   CLASSDATA oInstance

   DATA  hRas
   DATA  lRasValido
   DATA  lFtpValido

   DATA  lServer

   DATA  oText
   DATA  cText
   DATA  aSend
   DATA  oInt
   DATA  oFtp
   DATA  nTotMeter

   DATA  oMeter
   DATA  nActualMeter

   DATA  oMeterL
   DATA  nActualMeterL

   DATA  oBmpSel
   DATA  oDlg
   DATA  oFld
   DATA  oBmp

   DATA oDlgWait
   DATA oBmpWait
   DATA oSayWait
   DATA cSayWait

   DATA  oSubItem
   DATA  oSubItem2

   DATA  cIniFile

   DATA  lPlanificarEnvio     INIT  .f.
   DATA  cHoraEnvio           INIT  "0000"
   DATA  lPlanificarRecepcion INIT  .f.
   DATA  cHoraRecepcion       INIT  "0000"
   DATA  lEnviado             INIT  .f.
   DATA  lRecibido            INIT  .f.
   DATA  lGetProcesados       INIT  .f.
   DATA  lGetFueraSecuencia   INIT  .f.
   DATA  lGetEliminarFicheros INIT  .f.

   DATA  lPedidosWeb          INIT  .f.

   DATA  nTipoEnvio           INIT  1

   DATA  nLevel

   DATA  oDbfSenderReciver
   DATA  oDbfFilesReciver

   DATA  aFilesProcessed

   DATA  oBotonTerminar

   DATA  cFilTxt
   DATA  oFilTxt
   DATA  hFilTxt

   DATA  oBtnCancel
   DATA  oBtnExportar

   DATA  oTree
   DATA  oImageList

   DATA  cPath

   DATA  lSincAll
   DATA  oArticulos
   DATA  lArticulos
   DATA  lFamilias
   DATA  oPedidos
   DATA  lPedidos
   DATA  lFabricantes
   DATA  oTipIva
   DATA  lIva
   DATA  oCliente
   DATA  lCliente

   DATA  oArt
   DATA  oPro
   DATA  oTblPro
   DATA  oFPAgo

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

   DATA  oStock

   DATA  oCon
   DATA  cHost
   DATA  cUser
   DATA  cPasswd
   DATA  cDbName
   DATA  nPort
   DATA  cSeriePed
   DATA  cHostFtp
   DATA  nPortFtp
   DATA  cUserFtp
   DATA  cPasswdFtp
   DATA  lPassiveFtp
   DATA  cPlataforma
   DATA  nExportar
   DATA  Cookiekey

   DATA  oInt
   DATA  oFtp
   DATA  aImages
   DATA  aImagesArticulos
   DATA  aImagesCategories
   DATA  aTipoImagesPrestashop
   DATA  cDImagen
   DATA  nLanguage

   DATA  nPrecioMinimo        INIT  0

   DATA  nSecondTimer

   DATA  lDefImgPrp           INIT .f.

   DATA  nNumeroCategorias    INIT 0
   DATA  aCategorias          INIT {}

   DATA cPrefijoBaseDatos

   Method GetInstance()

   Method New()
   Method Create()                  INLINE ( Self )
   METHOD lReady()                  INLINE ( !Empty( ::cHost) .and. !Empty( ::cUser ) .and. !Empty( ::cPasswd ) .and. !Empty( ::cDbName ) )

   Method OpenFiles()
   Method CloseFiles()

   Method Activate( oWnd )
   Method AutoRecive()

   Method Sincronizar()

   Method Exportar()
   Method Importar()

   METHOD cPreFixtable( cName )

   Method SetText( cText )
   Method MeterGlobalText( cText )
   Method MeterParticularText( cText )

   Method AppendArticulo( oTablaArticulos, oTablaDescripciones, oTablaRelaciones, oTablaArticulos_Atributos, oTablaArticulos_Images, oTablaOfertas )
   Method AppendPropiedades( oTablaPropiedades, oTablaPropiedades_Lineas, oTablaRelaciones_Propiedades_Lineas )
   Method AppendFamilia( oTablaFamilias, oTablaFamiliasDesc )
   Method AppendClient( oTablaClientes, oTablaClientesDirec, oTablaClientesInfo, oTablaZona )
   Method AppendPedido( oTablaPedidos, oTablaPedidosPro, oTablaPedidosAtributos, oTablaPedidosTotal )
   Method AppendImages()
   Method AppendFabricantes( oTablaFabricantes, oTablaFabricantes_info )
   Method AppendIva( oTablaIva, oTablaIva_rates, oTablaGeoZone, oTablaZone )
   Method AppendZone( oTablaGeoZone, oTablaZone )
   Method EstadoPedidos( oTablaPedidos, oTablaPedidosStatus )

   Method AppendImages_bd()
   Method AppendIva_bd( oTablaIva )
   Method AppendArticulo_bd( oTablaArticulos, oTablaDescripciones, oTablaRelaciones, oTablaArticulos_Atributos )
   Method AppendPropiedades_bd( oTablaPropiedades, oTablaPropiedades_Lineas, oTablaRelaciones_Propiedades_Lineas )
   Method AppendFamilia_bd( oTablaFamilias, oTablaFamiliasDesc )
   Method AppendFabricantes_bd( oTablaFabricantes, oTablaFabricantes_info )

   Method AppProducts( oDb )
   Method AppOptions( oDb )
   Method AppOptions_Values( oDb )
   Method AppOptions_Relacion( oDb )
   Method AppCategories( oDb )
   Method AppGrpCategories( oDb )
   Method AppCustomers( oDb )
   Method AppPedidos( oDb )
   Method AppFabricantes( oDb )
   Method AppIva( oDb )
   Method AppZone( oDb )
   Method AppAtributes( oDb, codigo )
   Method AppImages( oDb, codigo )
   Method AppPreciosAtributes( oTablaArticulos, oTablaArticulos_Atributos, nCodWeb )
   Method CambiarEPedidos( oDb )
   Method DropAtributes( oDb )

   Method AppIva_bd( oDb )
   Method AppProducts_bd( oDb )
   Method AppOptions_bd( oDb )
   Method AppCategories_bd( oDb )
   Method AppCustomers_bd( oDb )
   Method AppFabricantes_bd( oDb )

   Method GetParentCategories()
   Method GetParentFamilia()
   Method GetParentFabricantes()
   Method GetParentIva()
   Method GetParentTipoArticulo( oDb )
   Method lParentTipoArticulo( oTablaFamilias, oTablaFamiliasDesc )
   Method GetLanguage( oDb )

   Method AutoInt( oTabla )

   Method AddImages( cImage )

   METHOD ChangeSincAll()
   METHOD GetTipArt()
   METHOD GetPropArt()

   Method cModelArticulo( nId )
   Method SeleccionFamilia()

   Method ExportarPrestashop()
   Method ImportarPrestashop()

   Method GetLanguagePrestashop()

   METHOD AppendFamiliaPrestashop()

   METHOD AddCategoriaRaiz()

   Method AppTipoArticuloPrestashop()

   METHOD RecalculaPosicionesCategoriasPrestashop()

   METHOD AppendIvaPrestashop()

   METHOD InsertIvaPrestashop()

   METHOD lUpdateIvaPrestashop( nId )

   Method AppendImagesPrestashop()

   Method AddTipoImagesPrestashop( cImage )

   METHOD aTipoImagenPrestashop()

   METHOD AddImagesArticulos()

   METHOD AddImagesCategories()

   METHOD AppendClientPrestashop()

   METHOD AppendPedidoprestashop()

   METHOD EstadoPedidosPrestashop()

   METHOD AppendClientesToPrestashop()

   METHOD AppendFabricantesPrestashop()

   METHOD InsertFabricantesPrestashop()

   METHOD lUpdateFabricantesPrestashop( nId )

   METHOD GetColorDefault()

   METHOD GetValPrp( nIdPrp, nProductAttibuteId )

   METHOD nDefImagen( cCodArt, cImagen )

   METHOD nCodigoWebImagen( cCodArt, cImagen )

   METHOD lLimpiaRefImgWeb()

   METHOD DelIdFamiliasPrestashop()

   METHOD DelIdGrupoFamiliasPrestashop()

   METHOD DelIdTipoArticuloPrestashop()

   METHOD DelIdArticuloPrestashop()

   METHOD DelIdFabricantePrestashop()

   METHOD DelIdIvaPrestashop()

   /*
   Nuevos metodos para prestashop----------------------------------------------
   */

   METHOD ConectBBDD()

   METHOD DisconectBBDD()

   METHOD lShowDialogWait()

   METHOD lHideDialogWait()

   METHOD cTextoWait( cText )

   METHOD InsertCategoriesPrestashop()

   METHOD UpdateCategoriesPrestashop()

   METHOD DeleteCategoriesPrestashop()

   METHOD DeleteImagesCategories( cCodCategorie )

   METHOD ActualizaCategoriesPrestashop( oDbf )

   METHOD InsertGrupoCategoriesPrestashop()

   METHOD UpdateGrupoCategoriesPrestashop()

   METHOD UpdateCascadeCategoriesPrestashop()

   METHOD DeleteGrupoCategoriesPrestashop()

   METHOD DelCascadeGrupoCategoriesPrestashop()

   METHOD ActualizaGrupoCategoriesPrestashop( oDbf )

   METHOD AppendArticuloPrestashop()

   METHOD ActualizaProductsPrestashop( oDbf )

   METHOD InsertProductsPrestashop()

   METHOD UpdateProductsPrestashop()

   METHOD DeleteProductsPrestashop()

   METHOD AppendPropiedadesPrestashop()

   METHOD InsertPropiedadesPrestashop()

   METHOD UpdatePropiedadesPrestashop()

   METHOD DeletePropiedadesPrestashop()

   METHOD ActualizaPropiedadesPrestashop( oDbf )

   METHOD InsertLineasPropiedadesPrestashop()

   METHOD UpdateLineasPropiedadesPrestashop()

   METHOD DeleteLineasPropiedadesPrestashop()

   METHOD AvisoSincronizaciontotal()

   METHOD DelCascadeCategoriesPrestashop()

   METHOD DeleteImagesProducts( cCodWeb )

   METHOD InsertImageProductsPrestashop( cCodArt )

   METHOD InsertPropiedadesProductPrestashop( cCodArt )

END CLASS

//---------------------------------------------------------------------------//

Method GetInstance()

   if Empty( ::oInstance )
      ::oInstance          := ::New()
   end if

RETURN ( ::oInstance )

//---------------------------------------------------------------------------//

METHOD New( oMenuItem ) CLASS TComercio

   DEFAULT oMenuItem       := "01108"

   ::nLevel                := nLevelUsr( oMenuItem )

   ::lSincAll              := .f.
   ::lArticulos            := .t.
   ::lFamilias             := .t.
   ::lPedidos              := .t.
   ::lFabricantes          := .t.
   ::lIva                  := .t.
   ::lCliente              := .t.
   ::aImages               := {}
   ::aImagesArticulos      := {}
   ::aImagesCategories     := {}
   ::aTipoImagesPrestashop := {}
   ::nTotMeter             := 0

   ::cHost                 := uFieldEmpresa( "cSitSql" )
   ::cUser                 := uFieldEmpresa( "cUsrSql" )
   ::cPasswd               := uFieldEmpresa( "cPswSql" )
   ::cDbName               := uFieldEmpresa( "cDtbSql" )
   ::nPort                 := uFieldEmpresa( "nPrtSql", 3306 )
   ::cDImagen              := uFieldEmpresa( "cdImagen" )
   ::cSeriePed             := uFieldEmpresa( "cSeriePed" )
   ::nSecondTimer          := uFieldEmpresa( "nTiempoPed", 0 ) * 60000
   ::cUserFtp              := uFieldEmpresa( "cUsrFtpImg" )
   ::cPasswdFtp            := uFieldEmpresa( "cPswFtpImg" )
   ::cHostFtp              := uFieldEmpresa( "cHostFtpImg" )
   ::nPortFtp              := uFieldEmpresa( "nPrtFtp", 21 )
   ::lPassiveFtp           := uFieldEmpresa( "lPasFtp" )
   ::nExportar             := 1
   ::Cookiekey             := uFieldEmpresa( "cCooKey" )

   if uFieldEmpresa( "nTipWeb" ) == 1
      ::cPlataforma        := "OsCommerce"
   else
      ::cPlataforma        := "Prestashop"
   end if

   /*
   Tomamos el prefijo de las bases de datos de prestashop-------------------
   */

   ::cPrefijoBaseDatos     := "ps_"

RETURN ( Self )

//---------------------------------------------------------------------------//



METHOD OpenFiles() CLASS TComercio

   local oBlock
   local oError
   local lOpen     := .t.

   /*
   Ficheros necesarios
   */

   oBlock         := ErrorBlock( { | oError | Break( oError ) } )
   BEGIN SEQUENCE

   DATABASE NEW ::oArt     PATH ( cPatArt() ) FILE "ARTICULO.DBF"    VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   DATABASE NEW ::oPro     PATH ( cPatArt() ) FILE "PRO.DBF"         VIA ( cDriver() ) SHARED INDEX "PRO.CDX"

   DATABASE NEW ::oTblPro  PATH ( cPatArt() ) FILE "TBLPRO.DBF"      VIA ( cDriver() ) SHARED INDEX "TBLPRO.CDX"

   DATABASE NEW ::oArtDiv  PATH ( cPatArt() ) FILE "ARTDIV.DBF"      VIA ( cDriver() ) SHARED INDEX "ARTDIV.CDX"

   DATABASE NEW ::oFam     PATH ( cPatArt() ) FILE "FAMILIAS.DBF"    VIA ( cDriver() ) SHARED INDEX "FAMILIAS.CDX"

   DATABASE NEW ::oGrpFam  PATH ( cPatArt() ) FILE "GRPFAM.DBF"      VIA ( cDriver() ) SHARED INDEX "GRPFAM.CDX"

   DATABASE NEW ::oTipArt  PATH ( cPatArt() ) FILE "TIPART.DBF"      VIA ( cDriver() ) SHARED INDEX "TIPART.CDX"

   DATABASE NEW ::oCli     PATH ( cPatCli() ) FILE "CLIENT.DBF"      VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

   DATABASE NEW ::oObras   PATH ( cPatCli() ) FILE "OBRAST.DBF"      VIA ( cDriver() ) SHARED INDEX "OBRAST.CDX"

   DATABASE NEW ::oIva     PATH ( cPatDat() ) FILE "TIVA.DBF"        VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   DATABASE NEW ::oDivisas PATH ( cPatDat() ) FILE "DIVISAS.DBF"     VIA ( cDriver() ) SHARED INDEX "DIVISAS.CDX"

   DATABASE NEW ::oPedCliT PATH ( cPatEmp() ) FILE "PEDCLIT.DBF"     VIA ( cDriver() ) SHARED INDEX "PEDCLIT.CDX"

   DATABASE NEW ::oPedCliI PATH ( cPatEmp() ) FILE "PEDCLII.DBF"     VIA ( cDriver() ) SHARED INDEX "PEDCLII.CDX"

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

   ::oStock                := TStock():Create( cPatGrp() )

   if !::oStock:lOpenFiles()

      lOpen                := .f.

   else

      ::oStock:cKit        := ::oKit:cAlias
      ::oStock:cPedCliL    := ::oPedCliL:cAlias
      ::oStock:cAlbCliT    := ::oAlbCliT:cAlias
      ::oStock:cAlbCliL    := ::oAlbCliL:cAlias
      ::oStock:cFacCliL    := ::oFacCliL:cAlias
      ::oStock:cFacRecL    := ::oFacRecL:cAlias
      ::oStock:cTikL       := ::oTikCliL:cAlias
      ::oStock:cProducL    := ::oProLin:cAlias
      ::oStock:cProducM    := ::oProMat:cAlias
      ::oStock:cHisMov     := ::oHisMov:cAlias
      ::oStock:cPedPrvL    := ::oPedPrvL:cAlias
      ::oStock:cAlbPrvT    := ::oAlbPrvT:cAlias
      ::oStock:cAlbPrvL    := ::oAlbPrvL:cAlias
      ::oStock:cFacPrvL    := ::oFacPrvL:cAlias
      ::oStock:cRctPrvL    := ::oRctPrvL:cAlias

   end if

   RECOVER USING oError

      lOpen                := .f.

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TComercio

   if !Empty( ::oArt ) .and. ::oArt:Used()
      ::oArt:End()
   end if

   if !Empty( ::oPro ) .and. ::oPro:Used()
      ::oPro:End()
   end if

   if !Empty( ::oTblPro ) .and. ::oTblPro:Used()
      ::oTblPro:End()
   end if

   if !Empty( ::oFam ) .and. ::oFam:Used()
      ::oFam:End()
   end if

   if !Empty( ::oGrpFam ) .and. ::oGrpFam:Used()
      ::oGrpFam:End()
   end if

   if !Empty( ::oTipArt ) .and. ::oTipArt:Used()
      ::oTipArt:End()
   end if

   if !Empty( ::oCli ) .and. ::oCli:Used()
      ::oCli:End()
   end if

   if !Empty( ::oFPago ) .and. ::oFPago:Used()
      ::oFPago:End()
   end if

   if !Empty( ::oObras ) .and. ::oObras:Used()
      ::oObras:End()
   end if

   if !Empty( ::oArtDiv ) .and. ::oArtDiv:Used()
      ::oArtDiv:End()
   end if

   if !Empty( ::oIva ) .and. ::oIva:Used()
      ::oIva:End()
   end if

   if !Empty( ::oDivisas ) .and. ::oDivisas:Used()
      ::oDivisas:End()
   end if

   if !Empty( ::oPedCliT ) .and. ::oPedCliT:Used()
      ::oPedCliT:End()
   end if

   if !Empty( ::oPedCliI ) .and. ::oPedCliI:Used()
      ::oPedCliI:End()
   end if

   if !Empty( ::oPedCliL ) .and. ::oPedCliL:Used()
      ::oPedCliL:End()
   end if

  if !Empty( ::oCount ) .and. ::oCount:Used()
      ::oCount:End()
   end if

   if !Empty( ::oFab ) .and. ::oFab:Used()
      ::oFab:End()
   end if

   if !Empty( ::oKit ) .and. ::oKit:Used()
      ::oKit:End()
   end if

   if !Empty( ::oAlbCliT ) .and. ::oAlbCliT:Used()
      ::oAlbCliT:End()
   end if

   if !Empty( ::oAlbCliL ) .and. ::oAlbCliL:Used()
      ::oAlbCliL:End()
   end if

   if !Empty( ::oFacCliL ) .and. ::oFacCliL:Used()
      ::oFacCliL:End()
   end if

   if !Empty( ::oFacRecL ) .and. ::oFacRecL:Used()
      ::oFacRecL:End()
   end if

   if !Empty( ::oTikCliL ) .and. ::oTikCliL:Used()
      ::oTikCliL:End()
   end if

   if !Empty( ::oProLin ) .and. ::oProLin:Used()
      ::oProLin:End()
   end if

   if !Empty( ::oProMat ) .and. ::oProMat:Used()
      ::oProMat:End()
   end if

   if !Empty( ::oHisMov ) .and. ::oHisMov:Used()
      ::oHisMov:End()
   end if

   if !Empty( ::oPedPrvL ) .and. ::oPedPrvL:Used()
      ::oPedPrvL:End()
   end if

   if !Empty( ::oAlbPrvT ) .and. ::oAlbPrvT:Used()
      ::oAlbPrvT:End()
   end if

   if !Empty( ::oAlbPrvL ) .and. ::oAlbPrvL:Used()
      ::oAlbPrvL:End()
   end if

   if !Empty( ::oFacPrvL ) .and. ::oFacPrvL:Used()
      ::oFacPrvL:End()
   end if

   if !Empty( ::oRctPrvL ) .and. ::oRctPrvL:Used()
      ::oRctPrvL:End()
   end if

   if !Empty( ::oArtImg ) .and. ::oArtImg:Used()
      ::oArtImg:End()
   end if

   ::oArt      := nil
   ::oPro      := nil
   ::oTblPro   := nil
   ::oFPago    := nil
   ::oFam      := nil
   ::oGrpFam   := nil
   ::oCli      := nil
   ::oObras    := nil
   ::oPedCliT  := nil
   ::oPedCliI  := nil
   ::oPedCliL  := nil
   ::oCount    := nil
   ::oFab      := nil
   ::oIva      := nil
   ::oDivisas  := nil
   ::oTipArt   := nil
   ::oKit      := nil
   ::oAlbCliT  := nil
   ::oAlbCliL  := nil
   ::oFacCliL  := nil
   ::oFacRecL  := nil
   ::oTikCliL  := nil
   ::oProLin   := nil
   ::oProMat   := nil
   ::oHisMov   := nil
   ::oPedPrvL  := nil
   ::oAlbPrvT  := nil
   ::oAlbPrvL  := nil
   ::oFacPrvL  := nil
   ::oRctPrvL  := nil
   ::oArtImg   := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Activate( oWnd ) CLASS TComercio

   DEFAULT  oWnd        := oWnd()

   if nAnd( ::nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      return ( Self )
   end if

   CursorWait()

   if oWnd != nil
      SysRefresh(); oWnd:CloseAll(); SysRefresh()
   end if

   /*
   Apertura del fichero de texto---------------------------------------------//
   */

   DEFINE DIALOG ::oDlg RESOURCE "Comercio_0"

      REDEFINE BITMAP ::oBmp ;
         ID       500 ;
         RESOURCE "earth2_alpha_48" ;
         TRANSPARENT ;
         OF       ::oDlg

      REDEFINE PAGES ::oFld ;
         ID       10;
         OF       ::oDlg ;
         DIALOGS  "Comercio_1", "Comercio_2"

      /*
      Primera caja de diálogo--------------------------------------------------
		*/

      // Plataforma------------------------------------------------------------

      REDEFINE SAY PROMPT ::cPlataforma;
         ID       220 ;
         OF       ::oFld:aDialogs[ 1 ]

      // Servidor--------------------------------------------------------------

      REDEFINE SAY PROMPT ::cHost;
         ID       100 ;
         OF       ::oFld:aDialogs[ 1 ]

      // Puerto----------------------------------------------------------------

      REDEFINE SAY PROMPT ::nPort;
         ID       110 ;
         OF       ::oFld:aDialogs[ 1 ]

      // Usuario---------------------------------------------------------------

      REDEFINE SAY PROMPT ::cUser;
         ID       120 ;
         OF       ::oFld:aDialogs[ 1 ]

      // Base de datos---------------------------------------------------------

      REDEFINE SAY PROMPT ::cDbName;
         ID       130 ;
         OF       ::oFld:aDialogs[ 1 ]

      // Exportar o importar---------------------------------------------------

      REDEFINE RADIO ::nExportar ;
         ID       121, 122 ;
         OF       ::oFld:aDialogs[ 1 ]

      // Opciones de sincronización--------------------------------------------

      REDEFINE CHECKBOX ::lSincAll;
         ID        210 ;
         ON CHANGE ( ::ChangeSincAll() );
         WHEN      ( ::nExportar == 1 );
         OF        ::oFld:aDialogs[ 1 ]

      REDEFINE CHECKBOX ::oArticulos VAR ::lArticulos ;
         ID       140 ;
         WHEN      ( ::nExportar == 1 .and. !::lSincAll );
         OF       ::oFld:aDialogs[ 1 ]

       REDEFINE CHECKBOX ::oPedidos VAR ::lPedidos ;
         ID       160 ;
         WHEN      ( ::nExportar == 1 .and. !::lSincAll );
         OF       ::oFld:aDialogs[ 1 ]

       REDEFINE CHECKBOX ::oTipIva VAR ::lIva ;
         ID       180 ;
         WHEN      ( ::nExportar == 1 .and. !::lSincAll );
         OF       ::oFld:aDialogs[ 1 ]

       REDEFINE CHECKBOX ::oCliente VAR ::lCliente ;
         ID       230 ;
         WHEN      ( ::nExportar == 1 .and. !::lSincAll );
         OF       ::oFld:aDialogs[ 1 ]

       REDEFINE SAY PROMPT ::cUserFtp ;
         ID       190 ;
         OF       ::oFld:aDialogs[ 1 ]

       REDEFINE SAY PROMPT ::cDImagen ;
         ID       200 ;
         OF       ::oFld:aDialogs[ 1 ]

      /*
      Comercio2--------------------------------------------------------------//
      */

      ::oTree        := TTreeView():Redefine( 100, ::oFld:aDialogs[ 2 ] )

      REDEFINE SAY ::oText PROMPT ::cText ID 110 OF ::oFld:aDialogs[ 2 ]

      ::oMeter       := TMeter():ReDefine( 120, { | u | if( pCount() == 0, ::nActualMeter, ::nActualMeter := u ) }, 10, ::oFld:aDialogs[ 2 ], .f., , , .t., rgb( 255,255,255 ), , rgb( 128,255,0 ) )

      ::oMeterL      := TMeter():ReDefine( 130, { | u | if( pCount() == 0, ::nActualMeterL, ::nActualMeterL := u ) }, 10, ::oFld:aDialogs[ 2 ], .f., , , .t., rgb( 255,255,255 ), , rgb( 128,255,0 ) )

      /*
      Botones------------------------------------------------------------------
      */

      REDEFINE BUTTONBMP ::oBtnExportar ;
         ID       220 ;
         OF       ::oDlg;
         ACTION   ( ::Sincronizar() );

      REDEFINE BUTTON ::oBtnCancel ;
         ID       IDCANCEL ;
         OF       ::oDlg ;
         ACTION   ( ::oDlg:end() )

      ::oDlg:bStart  := {|| CursorWe() }

   ACTIVATE DIALOG ::oDlg CENTER

   /*
   Liberamos la imagen---------------------------------------------------------
   */

   ::oBmp:End()

Return Nil

//---------------------------------------------------------------------------//

METHOD Sincronizar() CLASS TComercio

   if uFieldEmpresa( "nTipWeb" ) == 1  //OsCommerce

      if ::nExportar == 1
         ::Exportar()
      else
         ::Importar()
      end if

   else                                //Prestashop

      ::aCategorias     := {}

      if ::nExportar == 1
         ::ExportarPrestashop()
      else
         ::ImportarPrestashop()
      end if

   end if

Return .t.

//---------------------------------------------------------------------------//

METHOD AutoRecive( oWnd ) CLASS TComercio

   local oDb

   if !Empty( oTimer )
      oTimer:DeActivate()
   end if

   DEFAULT  oWnd        := oWnd()

   if ::OpenFiles()

      ::SetText( 'Intentando conectar con el servidor ' + '"' + ::cHost + '"' + ', el usuario ' + '"' + ::cUser + '"' + ' y la base de datos ' + '"' + ::cDbName + '".' , 1 )

      ::oCon            := TMSConnect():New()

      if !::oCon:Connect( ::cHost, ::cUser, ::cPasswd, ::cDbName, ::nPort )

          ::SetText( 'No se ha podido conectar con la base de datos.' )

      else

          ::SetText( 'Se ha conectado con éxito a la base de datos.' , 1 )

          oDb           := TMSDataBase():New ( ::oCon, ::cDbName )

          if Empty( oDb )

             ::SetText( 'La Base de datos: ' + ::cDbName + ' no está activa.', 1 )

          else

            ::AppendClient( oDb )
            ::AppendPedido( oDb )

          end if

      end if

      ::oCon:Destroy()

      ::SetText( 'Base de datos desconectada.', 1 )

   else

      ::SetText( 'Error al abrir los ficheros necesarios.', 1 )

   end if

   /*
   Comprobamos q existen pedidos para recibir----------------------------------
   */

   lPedidosWeb( ::oPedCliT:cAlias )

   /*
   Cerramos los ficheros-------------------------------------------------------
   */

   ::Closefiles()

   /*
   Reactivamos el timer--------------------------------------------------------
   */

   if !Empty( oTimer )
      oTimer:Activate()
   end if

Return Nil

//---------------------------------------------------------------------------//

METHOD Exportar() CLASS TComercio

   local oDb
   local oBlock
   local oError

   if !::lSincAll .or.;
      ( ::lSincAll .and. ApoloMsgNoYes(  "Ha seleccionado un envio global de información hacia la web,"          + CRLF + ;
                                    "la operación es muy delicada y conlleva vaciar las tablas de la web."  + CRLF + ;
                                    "¿Desea continuar?" ,"Seleccione una opción" ) )

      if !Empty( ::oFld )
         ::oFld:SetOption( 2 )
      end if

      ::oBtnExportar:Hide()

      ::oBtnCancel:Disable()
      /*
      oBlock            := ErrorBlock( { | oError | Break( oError ) } )
      BEGIN SEQUENCE
      */
      if ::OpenFiles()

         ::SetText ( 'Intentando conectar con el servidor ' + '"' + ::cHost + '"' + ', el usuario ' + '"' + ::cUser + '"' + ' y la base de datos ' + '"' + ::cDbName + '".' , 1 )

         ::oCon            := TMSConnect():New() // Iniciar el objeto de Conexion

         if !::oCon:Connect( ::cHost, ::cUser, ::cPasswd, ::cDbName, ::nPort )

            ::SetText ( 'No se ha podido conectar con la base de datos.' )

         else

            ::SetText ( 'Se ha conectado con éxito a la base de datos.' , 1 )

            oDb            := TMSDataBase():New ( ::oCon, ::cDbName )

            if Empty( oDb )

               ::SetText ( 'La Base de datos: ' + ::cDbName + ' no esta activa.', 1 )

            else

               // Tomamos el lenguaje

               ::nLanguage    := ::GetLanguage( oDb )

               ::oMeter:SetTotal( 10 )
               ::nActualMeter := 1

               if ::lPedidos .or. ::lSincAll

                  ::MeterGlobalText( "Descargando clientes" )
                  ::AppendClient( oDb )
                  sysRefresh()

                  ::MeterGlobalText( "Descargando pedidos" )
                  ::AppendPedido( oDb )
                  sysRefresh()

                  ::MeterGlobalText( "Actualizando estado de los pedidos" )
                  ::EstadoPedidos( oDb )
                  sysRefresh()

               end if

               if ::lSincAll
                  ::MeterGlobalText( "Actualizando ciudades de OsCommerce" )
                  ::AppendZone( odb )
               end if

               sysRefresh()
               if ::lIva .or. ::lSincAll
                  ::MeterGlobalText( "Actualizando tipos de " + cImp() )
                  ::AppendIva( odb )
                  sysRefresh()
               end if

               if ::lFamilias .or. ::lSincAll
                  ::MeterGlobalText( "Actualizando familias" )
                  ::AppendFamilia( odb )
                  sysRefresh()
               end if

               if ::lFabricantes .or. ::lSincAll
                  ::MeterGlobalText( "Actualizando fabricantes" )
                  ::AppendFabricantes( odb )
                  sysRefresh()
               end if

               if ::lArticulos .or. ::lSincAll

                  ::MeterGlobalText( "Actualizando propiedades de artículos" )
                  ::AppendPropiedades( odb )

                  ::MeterGlobalText( "Actualizando artículos" )
                  ::AppendArticulo( odb )
                  sysRefresh()

               end if

               ::MeterGlobalText( "Subiendo imagenes" )

               ::AppendImages()

             end if

         end if

         ::oCon:Destroy()

         ::SetText( 'Base de datos desconectada.', 1 )

         ::MeterGlobalText( "Proceso finalizado" )

      else

         ::SetText( 'Error al abrir los ficheros necesarios.', 1 )

      end if
      /*
      RECOVER USING oError

         msgStop( ErrorMessage( oError ), "Error al conectarnos con la base de datos" )

      END SEQUENCE

      ErrorBlock( oBlock )
      */
      ::Closefiles()

      ::oBtnExportar:Hide()

      ::oBtnCancel:Enable()

   end if

return( self )

//---------------------------------------------------------------------------//

METHOD Importar() CLASS TComercio

   local oDb

   if !ApoloMsgNoYes( "Se va a iniciar el proceso de importación desde OsCommerce, los datos de su equipo van a ser modificados." + CRLF + CRLF + "¿Desea continuar?", "Elija una opción" )
      Return ( Self )
   end if

   if !Empty( ::oFld )
      ::oFld:SetOption( 2 )
   end if

   ::oBtnExportar:Disable()
   ::oBtnCancel:Disable()

   if ::OpenFiles()

      ::SetText ( 'Intentando conectar con el servidor ' + '"' + ::cHost + '"' + ', el usuario ' + '"' + ::cUser + '"' + ' y la base de datos ' + '"' + ::cDbName + '".' , 1 )

      ::oCon            := TMSConnect():New() // Iniciar el objeto de Conexion

      if !::oCon:Connect( ::cHost, ::cUser, ::cPasswd, ::cDbName, ::nPort )

          ::SetText ( 'No se ha podido conectar con la base de datos.' )

      else

           ::SetText ( 'Se ha conectado con éxito a la base de datos.' , 1 )

          oDb := TMSDataBase():New ( ::oCon, ::cDbName )

          if Empty( oDb )

             ::SetText ( 'La Base de datos: ' + ::cDbName + ' no esta activa.', 1 )

          else

            ::oMeter:SetTotal( 9 )
            ::nActualMeter := 1

            ::MeterGlobalText( "Descargando propiedades" )
            ::AppendPropiedades_bd( odb )
            sysRefresh()

            if ::lIva .or. ::lSincAll
               ::MeterGlobalText( "Descargando tipos de " + cImp() )
               ::AppendIva_bd( odb )
               sysRefresh()
            end if

            if ::lFamilias .or. ::lSincAll
               ::MeterGlobalText( "Descargando familias" )
               ::AppendFamilia_bd( odb )
               sysRefresh()
            end if

            if ::lFabricantes .or. ::lSincAll
               ::MeterGlobalText( "Descargando fabricantes" )
               ::AppendFabricantes_bd( odb )
               sysRefresh()
            end if

            if ::lArticulos .or. ::lSincAll
               ::MeterGlobalText( "Descargando artículos" )
               ::AppendArticulo_bd( odb )
               sysRefresh()
            end if

            if ::lPedidos .or. ::lSincAll
               ::MeterGlobalText( "Descargando clientes" )
               ::AppendClient( oDb )
               sysRefresh()

               ::MeterGlobalText( "Descargando pedidos" )
               ::AppendPedido( oDb )
               sysRefresh()

               ::MeterGlobalText( "Actualizando estados de pedidos" )
               ::EstadoPedidos( oDb )
               sysRefresh()
            end if

            ::MeterGlobalText( "Descargando imagenes" )
            ::AppendImages_bd()

          end if

      end if

      ::oCon:Destroy()

      ::SetText( 'Base de datos desconectada.', 1 )

   else

      ::SetText( 'Error al abrir los ficheros necesarios.', 1 )

   end if

   ::Closefiles()

   ::oBtnExportar:Enable()
   ::oBtnCancel:Enable()

return( self )

//---------------------------------------------------------------------------//

METHOD SetText( cText, nLevel ) CLASS TComercio

   DEFAULT nLevel    := 2

   if Empty( ::cFilTxt )
      ::cFilTxt      := cGetNewFileName( cPatLog() + "Com" + Dtos( Date() ) + StrTran( Time(), ":", "" ) ) + ".Txt"
      ::hFilTxt      := fCreate( ::cFilTxt )
   end if

   if Empty( ::hFilTxt )
      ::hFilTxt      := fOpen( ::cFilTxt, 1 )
   endif

   /*
   Escritura en el fichero
   */

   do case
      case nLevel == 1
         fWrite( ::hFilTxt, cValToChar( cText ) + CRLF )
      case nLevel == 2
         fWrite( ::hFilTxt, Space( 3 ) + cValToChar( cText ) + CRLF )
      case nLevel == 3
         fWrite( ::hFilTxt, Space( 6 ) + cValToChar( cText ) + CRLF )
   end case

   if ::oTree != nil
      do case
         case nLevel == 1
            ::oSubItem  := ::oTree:Add( cText )
            ::oTree:Select( ::oSubItem )
         case nLevel == 2
            ::oSubItem2 := ::oTree:Add( cText )
            ::oTree:Select( ::oSubItem2 )
            ::oTree:Expand()
         case nLevel == 3
            ::oTree:Select( ::oSubItem2:Add( cText ) )
            ::oSubItem2:Expand()
      end case
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD MeterGlobalText( cText ) Class TComercio

   DEFAULT cText  := ""

   if !Empty( ::oText )
      ::oText:SetText( cText )
   end if

   if !Empty( ::oMeter )
      ::oMeter:Set( ++::nActualMeter )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD MeterParticularText( cText ) Class TComercio

   DEFAULT cText  := ""

   if !Empty( ::oText )
      ::oText:SetText( cText )
   end if

   if !Empty( ::oMeterL )
      ::oMeterL:Set( ++::nActualMeterL )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

Method AppendZone( oDb ) CLASS TComercio

   local oTablaGeoZone
   local oTablaZone

   /*
   Compruebo que las tablas existen--------------------------------------------
   */
   if oDb:ExistTable( "zones_to_geo_zones" )  .and.;
      oDb:ExistTable( "geo_zones" )

      oTablaGeoZone        := TMSTable():New( oDb, "zones_to_geo_zones" )
      oTablaZone           := TMSTable():New( oDb, "geo_zones" )

      /*
      Abrimos las tablas-------------------------------------------------------
      */

      if oTablaGeoZone:Open() .and.;
         oTablaZone:Open()

         /*
         Vaciamos las tablas para el proceso global----------------------------
         */

         if ::lSincAll
            oTablaZone:oCmd:ExecDirect(      "TRUNCATE TABLE " + oTablaZone:cName )
            oTablaGeoZone:oCmd:ExecDirect(   "TRUNCATE TABLE " + oTablaGeoZone:cName )
            ::SetText ( 'Tablas de zonas borradas corectamente ', 2  )
         end if

         if oTablaZone:RecCount() > 0 .and. !oTablaZone:Find( 2, "Spain" , .t. )
            ::appZone( oTablaZone, oTablaGeoZone )
         end if

     else

         ::SetText ( 'No se puede abrir las tablas de Zona ', 1  )

      end if

      oTablaGeoZone:Free()
      oTablaZone:Free()

   else

      ::SetText( 'No existe la tabla de Zona', 1 )

   end if

Return( Self )

//---------------------------------------------------------------------------//

Method AppendClient( oDb ) CLASS TComercio

   local n
   local oTablaClientes
   local oTablaClientesDirec
   local oTablaClientesInfo
   local oTablaZona
   local nCodigo

   ::nTotMeter    := 0

   /*
   Compruebo que las tablas existen--------------------------------------------
   */

   if oDb:ExistTable( "customers" )  .and.;
      oDb:ExistTable( "address_book" ) .and.;
      oDb:ExistTable( "customers_info" ) .and.;
      oDb:ExistTable( "zones" )

      oTablaClientes           := TMSTable():New( oDb, "customers" )
      oTablaClientesDirec      := TMSTable():New( oDb, "address_book" )
      oTablaClientesInfo       := TMSTable():New( oDb, "customers_info" )
      oTablaZona               := TMSTable():New( oDb, "zones" )

      /*
      Abrimos las tablas-------------------------------------------------------
      */

      if oTablaClientes:Open()      .and.;
         oTablaClientesDirec:Open() .and.;
         oTablaClientesInfo:Open()  .and.;
         oTablaZona:Open()

         oTablaClientes:GoTop()
         oTablaClientesDirec:GoTop()
         oTablaClientesInfo:GoTop()
         oTablaZona:GoTop()

         ::SetText( "Actualizando clientes de la web", 2 )

          /*
         Limpiamos tabla customers de Os---------------------------------------
         */

         if oTablaClientes:RecCount() > 0

         for n := 1 to oTablaClientes:RecCount()

            oTablaClientes:Load()

            if ::oCli:SeekInOrd( upper( oTablaClientes:GetBuffer( 6 ) ) , "cMeiInt" )

               if !::oCli:lPubInt

                  nCodigo := oTablaClientes:GetBuffer( 1 )

                  ::SetText( "Borrado cliente "  + AllTrim( Str( oTablaClientes:GetBuffer( 1 ) ) ) + " de la tabla customers", 3 )

                  oTablaClientes:Delete()

                  /*
                  Limpiamos tabla Address_book de Os---------------------------
                  */

                  if oTablaClientesDirec:RecCount() > 0 .and. oTablaClientesDirec:Find( 2, nCodigo , .t. )

                     oTablaClientesDirec:Delete()

                  end if

               end if

            end if

            oTablaClientes:Skip()

         next

         end if

         /*
         Compruebo datos para el meter-----------------------------------------
         */

         ::SetText( "Subiendo clientes a la web", 2 )

         ::oCli:OrdSetFocus( "lSndEnviar" )
         ::oCli:GoTop()

         while !::oCli:Eof()

            if ::oCli:lPubInt .and. ::oCli:lSndInt
               ::nTotMeter    += 1
            end if

            ::oCli:Skip()

         end while

         if !Empty( ::oMeterL )
            ::oMeterL:SetTotal( ::nTotMeter )
            ::nActualMeterL   := 1
         end if

         /*
         Añadimos clientes a Os------------------------------------------------
         */

         ::oCli:GoTop()
         while !::oCli:Eof()

            if ::oCli:lPubInt .and. ::oCli:lSndInt

               ::MeterParticularText( " Actualizando cliente " + AllTrim( Str( ::nActualMeterL ) ) + " de "  + AllTrim( Str( ::nTotMeter ) ) )

               ::AppCustomers( oTablaClientes, oTablaClientesDirec, oTablaClientesInfo, oTablaZona )

               ::oCli:Load()

               ::oCli:lSndInt  := .f.

               if !::oCli:Save()
                  ::SetText( "Error modificando estado de clientes", 3 )
               end if

            end if

            ::oCli:Skip()

         end while

         ::oCli:OrdSetFocus( "Cod" )

         /*
         Añadimos clientes a nuestra base de datos
         */

         oTablaClientes:GoTop()
         oTablaClientesDirec:GoTop()

         ::AppCustomers_bd( oTablaClientes, oTablaClientesDirec, oTablaZona )

      else

         ::SetText ( 'No se puede abrir las tablas de Clientes ', 1  )

      end if

      oTablaClientes:Free()
      oTablaClientesDirec:Free()
      oTablaClientesInfo:Free()
      oTablaZona:Free()

   else

      ::SetText( 'No existe la tabla de Clientes', 1 )

   end if

Return (  Self )

//---------------------------------------------------------------------------//

Method AppendPropiedades_bd( odb ) CLASS TComercio

   local n
   local oTablaPropiedades
   local oTablaPropiedades_Lineas
   local oTablaRelaciones_Propiedades_Lineas

   /*
   Abrimos las tablas y borramos todos los registros---------------------------
   */

   if oDb:ExistTable( "products_options" )                              .and.;
      oDb:ExistTable( "products_options_values" )                       .and.;
      oDb:ExistTable( "products_options_values_to_products_options" )

      oTablaPropiedades                     := TMSTable():New( oDb, "products_options" )
      oTablaPropiedades_Lineas              := TMSTable():New( oDb, "products_options_values" )
      oTablaRelaciones_Propiedades_Lineas   := TMSTable():New( oDb, "products_options_values_to_products_options" )

      /*
      Abrimos las tablas-------------------------------------------------------
      */

      if oTablaPropiedades:Open()                  .and.;
         oTablaPropiedades_Lineas:Open()           .and.;
         oTablaRelaciones_Propiedades_Lineas:Open()

         oTablaPropiedades:GoTop()
         oTablaPropiedades_Lineas:GoTop()
         oTablaRelaciones_Propiedades_Lineas:GoTop()

         ::SetText ( 'Tabla de propiedades: ', 2 )

         /*
         Añadimos las tablas de cabecera y lineas de propiedades a Os----------
         */

         ::AppOptions_bd( oTablaPropiedades, oTablaPropiedades_Lineas, oTablaRelaciones_Propiedades_Lineas )

         sysRefresh()

      else

         ::SetText ( 'No se puede abrir las tablas de propiedades', 1  )

      end if

      oTablaPropiedades:Free()
      oTablaPropiedades_Lineas:Free()
      oTablaRelaciones_Propiedades_Lineas:Free()

   else

      ::SetText( 'No existen las tablas de propiedades', 1 )

   end if


Return(  Self )


//---------------------------------------------------------------------------//

Method AppendPropiedades( odb ) CLASS TComercio

   local n
   local oTablaPropiedades
   local oTablaPropiedades_Lineas
   local oTablaRelaciones_Propiedades_Lineas

   ::nTotMeter    := 0

   /*
   Abrimos las tablas y borramos todos los registros---------------------------
   */

   if oDb:ExistTable( "products_options" )                              .and.;
      oDb:ExistTable( "products_options_values" )                       .and.;
      oDb:ExistTable( "products_options_values_to_products_options" )

      oTablaPropiedades                     := TMSTable():New( oDb, "products_options" )
      oTablaPropiedades_Lineas              := TMSTable():New( oDb, "products_options_values" )
      oTablaRelaciones_Propiedades_Lineas   := TMSTable():New( oDb, "products_options_values_to_products_options" )

      /*
      Abrimos las tablas-------------------------------------------------------
      */

      if oTablaPropiedades:Open()                     .and.;
         oTablaPropiedades_Lineas:Open()              .and.;
         oTablaRelaciones_Propiedades_Lineas:Open()

         /*
         Vaciamos las tablas para el proceso global----------------------------
         */

         if ::lSincAll
            oTablaPropiedades:oCmd:ExecDirect(                    "TRUNCATE TABLE " + oTablaPropiedades:cName )
            oTablaPropiedades_Lineas:oCmd:ExecDirect(             "TRUNCATE TABLE " + oTablaPropiedades_Lineas:cName )
            oTablaRelaciones_Propiedades_Lineas:oCmd:ExecDirect(  "TRUNCATE TABLE " + oTablaRelaciones_Propiedades_Lineas:cName )
            ::SetText( 'Tablas de propiedades borradas corectamente', 2  )
         end if

         oTablaPropiedades:GoTop()
         oTablaPropiedades_Lineas:GoTop()
         oTablaRelaciones_Propiedades_Lineas:GoTop()

         ::SetText ( 'Actualizando propiedades: ', 2 )

         /*
         Limpiamos la tabla products_options-----------------------------------
         */

         if oTablaPropiedades:RecCount()> 0

            for n := 1 to oTablaPropiedades:RecCount()

               oTablaPropiedades:Load()

               if !::oPro:SeekInOrd( Str( oTablaPropiedades:GetBuffer( 1 ), 11 ), "cCodWeb" )

                  ::SetText( "Borrado registro "  + AllTrim( Str( oTablaPropiedades:GetBuffer( 1 ) ) ) + " atributos", 3 )

                  oTablaPropiedades:Delete()

               end if

               oTablaPropiedades:Skip()

            next

         end if

         /*
         Limpiamos la tabla products_options_values----------------------------
         */

         if oTablaPropiedades_Lineas:RecCount() > 0

            for n := 1 to oTablaPropiedades_Lineas:RecCount()

               oTablaPropiedades_Lineas:Load()

               if !::oTblPro:SeekInOrd( Str( oTablaPropiedades_Lineas:GetBuffer( 1 ), 11 ), "cCodWeb" )

                  ::SetText( "Borrado registro "  + AllTrim( Str( oTablaPropiedades_Lineas:GetBuffer( 1 ) ) ) + " lineas de atributos", 3 )

                  oTablaPropiedades_Lineas:Delete()

               end if

               oTablaPropiedades_Lineas:Skip()

            next

         end if

         /*
         Limpiamos la tabla products_options to products_options_values--------
         */

         if oTablaRelaciones_Propiedades_Lineas:RecCount() > 0

            for n := 1 to oTablaRelaciones_Propiedades_Lineas:RecCount()

               oTablaRelaciones_Propiedades_Lineas:Load()

               if !::oPro:SeekInOrd( Str( oTablaRelaciones_Propiedades_Lineas:GetBuffer( 2 ), 11 ), "cCodWeb" )

                  ::SetText( "Borrado registro "  + AllTrim( Str( oTablaRelaciones_Propiedades_Lineas:GetBuffer( 1 ) ) ) + " relaciones de atributos", 3 )

                   oTablaRelaciones_Propiedades_Lineas:Delete()

               end if

               oTablaRelaciones_Propiedades_Lineas:Skip()

            next

         end if

         /*
         Comprobando datos para el meter---------------------------------------
         */

         ::oPro:GoTop()
         while !::oPro:Eof()

            if ( ::oPro:lPubInt ) .and. ( ::oPro:lSndDoc .or. ::lSincAll )

               ::nTotMeter          += 1

               ::oTblPro:GoTop()
               while !::oTblPro:Eof()

                  if ::oPro:cCodPro == ::oTblPro:cCodPro

                     ::nTotMeter    += 1

                  end if

                  sysRefresh()

                  ::oTblPro:Skip()

               end while

            end if

         sysRefresh()

         ::oPro:Skip()

         end while

         ::oMeterL:SetTotal( ::nTotMeter )

         ::nActualMeterL            := 1

         /*
         Añadimos las tablas de cabecera y lineas de propiedades a Os----------
         */

         ::oPro:GoTop()
         while !::oPro:Eof()

            if ( ::oPro:lPubInt ) .and. ( ::oPro:lSndDoc .or. ::lSincAll )

               ::MeterParticularText( " Actualizando propiedades " + AllTrim( Str( ::nActualMeterL ) ) + " de "  + AllTrim( Str( ::nTotMeter ) ) )

               ::AppOptions( oTablaPropiedades )

               ::oTblPro:GoTop()
               while !::oTblPro:Eof()

                  if ::oPro:cCodPro == ::oTblPro:cCodPro

                     ::MeterParticularText( " Actualizando lineas de propiedades " + AllTrim( Str( ::nActualMeterL ) ) + " de "  + AllTrim( Str( ::nTotMeter ) ) )

                     ::AppOptions_Values( oTablaPropiedades_Lineas )

                     ::AppOptions_Relacion( oTablaRelaciones_Propiedades_Lineas )

                  end if

                  sysRefresh()

                  ::oTblPro:Skip()

               end while

            end if

            ::oPro:Load()

            ::oPro:lSndDoc  := .f.

            if !::oPro:Save()
               ::SetText( "Error modificando estado de propiedades", 3 )
            end if

            sysRefresh()

            ::oPro:Skip()

         end while

         // Creo la relacion de lineas cabecera---------------------------------

      else

         ::SetText ( 'No se puede abrir las tablas de propiedades', 1  )

      end if

      oTablaPropiedades:Free()
      oTablaPropiedades_Lineas:Free()
      oTablaRelaciones_Propiedades_Lineas:Free()

   else

      ::SetText( 'No existen las tablas de propiedades', 1 )

   end if

Return(  Self )

//---------------------------------------------------------------------------//

METHOD AppOptions_bd( oTablaPropiedades, oTablaPropiedades_Lineas, oTablaRelaciones_Propiedades_Lineas ) CLASS TComercio

   local cCodWeb
   local cCodWebLin
   local cCodPro
   local cNombre
   local cNombreLineas
   local n
   local n2
   local n3

   ::nTotMeter                         := 0

   /*
   Compruebo datos para el meter-----------------------------------------------
   */

   oTablaPropiedades:GoTop()
   oTablaPropiedades_Lineas:GoTop()
   oTablaRelaciones_Propiedades_Lineas:GoTop()

   if oTablaRelaciones_Propiedades_Lineas:RecCount() > 0

   for n := 1 to oTablaRelaciones_Propiedades_Lineas:RecCount()

      oTablaRelaciones_Propiedades_Lineas:Load()

      cCodWeb                          := oTablaRelaciones_Propiedades_Lineas:GetBuffer( 2 )
      cCodWebLin                       := oTablaRelaciones_Propiedades_Lineas:GetBuffer( 3 )

      /*
      Busco en cabecera el nombre de la propiedad y compruebo que sea español--
      */

      if oTablaPropiedades:RecCount() > 0 .and. oTablaPropiedades:Find( 1, cCodWeb, .t. )
         oTablaPropiedades:Load()

         if oTablaPropiedades:GetBuffer( 2 ) == ::nLanguage
            ::nTotMeter    += 1
         end if

      end if

      /*
      Busco en lineas el nombre de la propiedad y compruebo que sea español--
      */

      if oTablaPropiedades_Lineas:RecCount() > 0 .and. oTablaPropiedades_Lineas:Find( 1, cCodWebLin, .t. )
         oTablaPropiedades_Lineas:Load()

         if oTablaPropiedades_Lineas:GetBuffer( 2 ) == ::nLanguage
            ::nTotMeter    += 1
         end if

      end if

      oTablaRelaciones_Propiedades_Lineas:skip()

   next

   end if

   ::oMeterL:SetTotal( ::nTotMeter )
   ::nActualMeterL := 1

   /*
   Guardo los datos correspondientes-------------------------------------------
   */

   oTablaPropiedades:GoTop()
   oTablaPropiedades_Lineas:GoTop()
   oTablaRelaciones_Propiedades_Lineas:GoTop()

   if oTablaRelaciones_Propiedades_Lineas:RecCount() > 0

   for n := 1 to oTablaRelaciones_Propiedades_Lineas:RecCount()

      oTablaRelaciones_Propiedades_Lineas:Load()

      cCodWeb                          := oTablaRelaciones_Propiedades_Lineas:GetBuffer( 2 )
      cCodWebLin                       := oTablaRelaciones_Propiedades_Lineas:GetBuffer( 3 )

      /*
      Busco en cabecera el nombre de la propiedad y compruebo que sea español--
      */

      if oTablaPropiedades:RecCount() > 0 .and. oTablaPropiedades:Find( 1, cCodWeb, .t. )
         oTablaPropiedades:Load()

         if oTablaPropiedades:GetBuffer( 2 ) == ::nLanguage

            cNombre                    := oTablaPropiedades:GetBuffer( 3 )
            ::MeterParticularText( " Descargando propiedades " + AllTrim( Str( ::nActualMeterL ) ) + " de "  + AllTrim( Str( ::nTotMeter ) ) )

            if !::oPro:SeekInOrd( Str( cCodWeb, 11 ), "cCodWeb" )

               ::oPro:Append()

               cCodPro                 := RJust( NextVal( DbLast( ::oPro:cAlias , 1, nil, nil, 1 ) ), "0", 3 )

               ::oPro:cCodPro          := cCodPro
               ::oPro:cDesPro          := cNombre
               ::oPro:cCodWeb          := cCodWeb

               if ::oPro:save()
                  ::SetText( "Añadido propiedad " + Rtrim( cNombre ), 3 )
               else
                  ::SetText( "Error al añadir propiedad " + Rtrim( cNombre ), 3 )
               end if

            else

               cCodPro                 := ::oPro:cCodPro

               ::oPro:Load()

               ::oPro:cDesPro          := cNombre
               ::oPro:cCodWeb          := cCodWeb

               if !::oPro:save()
                  ::SetText( "Error al modificar propiedad " + Rtrim( cNombre ), 3 )
               end if

            end if

         end if

      end if

      /*
      Busco en lineas el nombre de la propiedad y compruebo que sea español--
      */

      if oTablaPropiedades_Lineas:RecCount() > 0 .and. oTablaPropiedades_Lineas:Find( 1, cCodWebLin, .t. )
         oTablaPropiedades_Lineas:Load()

         if oTablaPropiedades_Lineas:GetBuffer( 2 ) == ::nLanguage
            cNombre                    := oTablaPropiedades_Lineas:GetBuffer( 3 )

            if !::oTblPro:SeekInOrd( Str( cCodWebLin, 11 ), "cCodWeb" )

               ::oTblPro:Append()

               ::oTblPro:cCodPro       := cCodPro
               ::oTblPro:cCodTbl       := RJust( NextVal( DbLast( ::oTblPro:cAlias, 2, nil, nil, 1 ) ), "0", 3 )
               ::oTblPro:cDesTbl       := cNombre
               ::oTblPro:cCodWeb       := cCodWebLin

               if ::oTblPro:save()
                  ::SetText( "Añadido linea de propiedad " + Rtrim( cNombre ), 3 )
               else
                  ::SetText( "Error al añadir linea de propiedad " + Rtrim( cNombre ), 3 )
               end if

            else

               ::oTblPro:Load()

               ::oTblPro:cCodPro       := cCodPro
               ::oTblPro:cDesTbl       := cNombre
               ::oTblPro:cCodWeb       := cCodWebLin

               if ::oTblPro:save()
                  ::SetText( "Modificando linea de propiedad " + Rtrim( cNombre ), 3 )
               else
                  ::SetText( "Error al modificar linea de propiedad " + Rtrim( cNombre ), 3 )
               end if

            end if

         end if

      end if

   oTablaRelaciones_Propiedades_Lineas:skip()

   next

   end if

Return nil

//---------------------------------------------------------------------------//

METHOD AppOptions( oTablaPropiedades ) CLASS TComercio

   local nCodigoWeb        := 0

   oTablaPropiedades:GoTop()

   if ::oPro:cCodWeb == 0 .or. ::lSincAll

      /*
      Añade en la tabla products_options de Os
      */

      nCodigoWeb           := ::AutoInt( oTablaPropiedades )

      oTablaPropiedades:Blank()
      oTablaPropiedades:FieldPut( 1, nCodigoWeb  )
      oTablaPropiedades:FieldPut( 2, ::nLanguage )
      oTablaPropiedades:FieldPut( 3, ::oCon:EscapeStr( ::GetPropArt() ) )

      if oTablaPropiedades:Insert()

         ::SetText( "Añadiendo propiedades " + Rtrim( ::oPro:cCodPro ) + Space( 1 ) + AllTrim( ::GetPropArt() ), 3 )

         ::oPro:fieldPutByName( "cCodWeb", nCodigoWeb )

      else
         ::SetText( "Error insertado" + Rtrim( ::oPro:cCodPro ) + Space( 1 ) + AllTrim( ::GetPropArt() ) + " en tabla products_option", 3 )

         return .f.

      end if

   else

      /*
      Modifico en la tabla products_opcion
      */

      if oTablaPropiedades:RecCount() > 0 .and. oTablaPropiedades:Find( 1, ::oPro:cCodWeb, .t. )

         oTablaPropiedades:Load()

         oTablaPropiedades:FieldPut( 2, ::nLanguage )
         oTablaPropiedades:FieldPut( 3, ::oCon:EscapeStr( ::GetPropArt() ) )

         if oTablaPropiedades:update()
            ::SetText( "Modificando propiedad " + Rtrim( ::oPro:cCodPro ) + Space( 1 ) + AllTrim( ::GetPropArt() ), 3 )
         else
            ::SetText( "Error modificando" + Rtrim( ::oPro:cCodPro ) + Space( 1 ) + AllTrim( ::GetPropArt() ) + " en tabla propiedades", 3 )
         end if

      end if

   end if

Return nCodigoWeb

//---------------------------------------------------------------------------//

METHOD AppOptions_Values( oTablaPropiedades_Lineas ) CLASS TComercio

   local nCodigoWeb        := 0


   oTablaPropiedades_Lineas:GoTop()

   /*
   Modifico en la tabla products_opcion_values
   */

   if !::lSincAll                                                 .and. ;
      ::oTblPro:cCodWeb != 0                                      .and. ;
      oTablaPropiedades_Lineas:RecCount() > 0                     .and. ;
      oTablaPropiedades_Lineas:Find( 1, ::oTblPro:cCodWeb, .t. )

      oTablaPropiedades_Lineas:Load()

      oTablaPropiedades_Lineas:FieldPut( 2, ::nLanguage )
      oTablaPropiedades_Lineas:FieldPut( 3, ::oCon:EscapeStr( ::oTblPro:cDesTbl ) )

      if oTablaPropiedades_Lineas:Update()
         ::SetText( "Modificando lineas de propiedades " + Rtrim( ::oTblPro:cCodTbl ) + Space( 1 ) + AllTrim( ::oTblPro:cDesTbl ), 3 )
      else
         ::SetText( "Error modificando lineas de propiedades" + Rtrim( ::oTblPro:cCodTbl ) + Space( 1 ) + AllTrim( ::oTblPro:cDesTbl ) + " en tabla lineas de propiedades", 3 )
      end if

   else

      nCodigoWeb           := ::AutoInt( oTablaPropiedades_Lineas )

      oTablaPropiedades_Lineas:Blank()
      oTablaPropiedades_Lineas:FieldPut( 1, nCodigoWeb )
      oTablaPropiedades_Lineas:FieldPut( 2, ::nLanguage )
      oTablaPropiedades_Lineas:FieldPut( 3, ::oCon:EscapeStr( ::oTblPro:cDesTbl ) )

      if oTablaPropiedades_Lineas:Insert()

         ::SetText( "Añadiendo linea de propiedades " + Rtrim( ::oTblPro:cCodTbl ) + Space( 1 ) + AllTrim( ::oTblPro:cDesTbl ), 3 )

         ::oTblPro:fieldPutByName( "cCodWeb", nCodigoWeb )

      else

         ::SetText( "Error insertado" + Rtrim( ::oTblPro:cCodTbl ) + Space( 1 ) + AllTrim( ::oTblPro:cDesTbl ) + " en tabla products_option_values", 3 )

         return .f.

      end if

   end if

Return nCodigoWeb

//---------------------------------------------------------------------------//

Method AppOptions_Relacion( oTablaRelaciones_Propiedades_Lineas ) CLASS TComercio

   local n
   local cCodPro

   oTablaRelaciones_Propiedades_Lineas:GoTop()

   cCodPro   := oRetFld( ::oTblPro:cCodPro, ::oPro, "cCodWeb" )

   if oTablaRelaciones_Propiedades_Lineas:RecCount() <= 0                     .or.;
      !oTablaRelaciones_Propiedades_Lineas:Find( 2, cCodPro, .t. )            .or.;
      !oTablaRelaciones_Propiedades_Lineas:Find( 3, ::oTblPro:cCodWeb , .t. )

      oTablaRelaciones_Propiedades_Lineas:Blank()

      oTablaRelaciones_Propiedades_Lineas:FieldPut( 2, cCodPro )
      oTablaRelaciones_Propiedades_Lineas:FieldPut( 3, ::oTblPro:cCodWeb )

      if !oTablaRelaciones_Propiedades_Lineas:Insert()
         ::SetText( "Error estableciendo la relación en propiedades " + Rtrim( cCodPro ), 3 )
      else
         ::SetText( "Establecioendo la relación de propiedades " + Rtrim( ::oPro:cDesPro ) + " con " + Rtrim( ::oTblPro:cDesTbl ), 3 )
      end if

   end if

Return( nil )

//---------------------------------------------------------------------------//

Method AppendArticulo_bd( oDb ) CLASS TComercio

   local n
   local oTablaArticulos
   local oTablaDescripciones
   local oTablaRelaciones
   local oTablaArticulos_Atributos
   local oTablaArticulos_Images
   local uResult

   /*
   Abrimos las tablas de oscommerce--------------------------------------------
   */

   if oDb:ExistTable( "products" ).and.;
      oDb:ExistTable( "products_description" ).and.;
      oDb:ExistTable( "products_to_categories" ).and.;
      oDb:ExistTable( "products_attributes" )

      oTablaArticulos            := TMSTable():New( oDb, "products" )
      oTablaDescripciones        := TMSTable():New( oDb, "products_description" )
      oTablaRelaciones           := TMSTable():New( oDb, "products_to_categories" )
      oTablaArticulos_Atributos  := TMSTable():New( oDb, "products_attributes" )
      if oDb:ExistTable( "products_images" )
         oTablaArticulos_Images  := TMSTable():New( oDb, "products_images" )
      end if

      /*
      Abrimos las tablas-------------------------------------------------------
      */

      if oTablaArticulos:Open()           .and.;
         oTablaDescripciones:Open()       .and.;
         oTablaRelaciones:Open()          .and.;
         oTablaArticulos_Atributos:Open()

         if oTablaArticulos_Images        != nil
            oTablaArticulos_Images:Open()
         end if

         /*
         Añadios artículos de oscommerce a nuestras tablas
         */

         ::SetText( "Tabla de artículos ", 2 )

         ::AppProducts_bd( oTablaArticulos, oTablaDescripciones, oTablaRelaciones, oTablaArticulos_Atributos )

      end if

      oTablaArticulos:Free()
      oTablaDescripciones:Free()
      oTablaRelaciones:Free()
      oTablaArticulos_Atributos:Free()
      if oTablaArticulos_Images        != nil
         oTablaArticulos_Images:Free()
      end if

   else

      ::SetText( 'No existe la tabla de artículos', 1 )

   end if

Return( Self )

//---------------------------------------------------------------------------//

Method AppProducts_bd( oTablaArticulos, oTablaDescripciones, oTablaRelaciones, oTablaArticulos_Atributos ) CLASS TComercio

   local cCodWeb
   local nPrecio
   local cImagen
   local cNombre        := ""
   local cCodigoFamilia
   local cCodPro1       := ""
   local cCodPro2       := ""
   local n
   local n2
   local cCodIva
   local cCodFab
   local nPeso

   ::nTotMeter          := 0

   /*
   Compruebo datos para el meter-----------------------------------------------
   */

   oTablaArticulos:GoTop()

   if oTablaArticulos:RecCount() > 0

      for n := 1 to oTablaArticulos:RecCount()

         ::nTotMeter       += 1

         oTablaArticulos:skip()

      next

   end if

   ::oMeterL:SetTotal( ::nTotMeter )
   ::nActualMeterL      := 1

   /*
   Añadimos a la tabla Articulos-----------------------------------------------
   */

   oTablaArticulos:GoTop()

   if oTablaArticulos:RecCount() > 0

   for n := 1 to oTablaArticulos:RecCount()

      cCodPro1    := ""
      cCodPro2    := ""

      oTablaArticulos:Load()

      cCodWeb     := oTablaArticulos:GetBuffer( 1 )
      cImagen     := oTablaArticulos:GetBuffer( 4 )
      nPrecio     := oTablaArticulos:GetBuffer( 5 )
      nPeso       := oTablaArticulos:GetBuffer( 9 )
      cCodIva     := oTablaArticulos:GetBuffer( 11 )
      cCodFab     := oTablaArticulos:GetBuffer( 12 )

      /*
      Busco el nombre del artículo
      */

      oTablaDescripciones:GoTop()

      if oTablaDescripciones:RecCount() > 0 .and. oTablaDescripciones:Find( 1 , cCodWeb , .t. )

         oTablaDescripciones:Load()

         if oTablaDescripciones:GetBuffer( 2 ) == ::nLanguage
            cNombre  := oTablaDescripciones:GetBuffer( 3 )
         end if

      end if

      /*
      Guardo el codigo de las propiedades del artículo
      */

      oTablaArticulos_Atributos:GoTop()

      for n2 := 1 to oTablaArticulos_Atributos:RecCount()

      oTablaArticulos_Atributos:Load()

         if oTablaArticulos_Atributos:GetBuffer( 2 ) == cCodWeb

            if Empty( cCodPro1 )

               cCodPro1         := oTablaArticulos_Atributos:GetBuffer( 3 )

            end if

            if !Empty( cCodPro1 ) .and. ( cCodPro1 != oTablaArticulos_Atributos:GetBuffer( 3 ) )

               cCodPro2         := oTablaArticulos_Atributos:GetBuffer( 3 )

            end if

         end if

      oTablaArticulos_Atributos:skip()
      next

      /*
      Busco el código de la familia del artículo
      */

      oTablaRelaciones:GoTop()

      if oTablaRelaciones:Find( 1, cCodWeb , .t. )
         oTablaRelaciones:Load()
            cCodigoFamilia     := oTablaRelaciones:GetBuffer( 2 )
      end if

      ::MeterParticularText( " Descargando artículo " + AllTrim( Str( ::nActualMeterL ) ) + " de "  + AllTrim( Str( ::nTotMeter ) ) )

      if !::oArt:SeekInOrd( Str( cCodWeb, 11 ), "cCodWeb" )

         ::oArt:Append()

         ::oArt:Codigo              := RJust( NextVal( DbLast( ::oArt:cAlias , 1, nil, nil, 1 ) ), "0", 4 )
         ::oArt:Nombre              := cNombre
         ::oArt:pVenta1             := nPrecio
         ::oArt:cCodWeb             := cCodWeb
         ::oArt:Familia             := BuscarCodFam( cCodigoFamilia, ::oFam )
         ::oArt:lIvaInc             := .t.
         ::oArt:TipoIva             := BuscarCodIva( cCodIva, ::oIva )
         ::oArt:nPesoKg             := nPeso
         ::oArt:cCodFab             := BuscarCodFab( cCodFab, ::oFab )
         ::oArt:lPubInt             := .t.
         ::oArt:cCodPrp1            := BuscarCodPro( cCodPro1, ::oPro )
         ::oArt:cCodPrp2            := BuscarCodPro( cCodPro2, ::oPro )
         ::oArt:cImagenWeb          := uFieldEmpresa( "cDirImg" ) + "\" + cNoPathInt( cImagen )

         if ::oArt:save()
            ::SetText( "Añadido artículo " + Rtrim( cNombre ), 3 )

            ::AddImages( cImagen )

         else
            ::SetText( "Error al añadir artículo " + Rtrim( cNombre ), 3 )
         end if

      else

         ::oArt:Load()

         ::oArt:Nombre              := cNombre
         ::oArt:pVenta1             := nPrecio
         ::oArt:cCodWeb             := cCodWeb
         ::oArt:Familia             := BuscarCodFam( cCodigoFamilia, ::oFam )
         ::oArt:lIvaInc             := .t.
         ::oArt:TipoIva             := BuscarCodIva( cCodIva, ::oIva )
         ::oArt:nPesoKg             := nPeso
         ::oArt:cCodFab             := BuscarCodFab( cCodFab, ::oFab )
         ::oArt:lPubInt             := .t.
         ::oArt:cCodPrp1            := BuscarCodPro( cCodPro1, ::oPro )
         ::oArt:cCodPrp2            := BuscarCodPro( cCodPro2, ::oPro )
         ::oArt:cImagenWeb          := uFieldEmpresa( "cDirImg" ) + "\" + cNoPathInt( cImagen )

         if ::oArt:save()

            ::SetText( "Modificando artículo " + Rtrim( cNombre ), 3 )

            ::AddImages( cImagen )

         else

            ::SetText( "Error al modificar artículo " + Rtrim( cNombre ), 3 )

         end if

      end if

   oTablaArticulos:skip()

   next

   end if

Return( nil )

//---------------------------------------------------------------------------//

Method AppendArticulo( oDb ) CLASS TComercio

   local n
   local oTablaArticulos
   local oTablaDescripciones
   local oTablaRelaciones
   local oTablaArticulos_Atributos
   local oTablaArticulos_Images
   local oTablaOfertas
   local uResult

   ::nTotMeter    := 0

   /*
   Abrimos las tablas y borramos todos los registros---------------------------
   */

   if oDb:ExistTable( "products" ).and.;
      oDb:ExistTable( "products_description" ).and.;
      oDb:ExistTable( "products_to_categories" ).and.;
      oDb:ExistTable( "products_attributes" ).and.;
      oDb:ExistTable( "specials" )

      oTablaArticulos            := TMSTable():New( oDb, "products" )
      oTablaDescripciones        := TMSTable():New( oDb, "products_description" )
      oTablaRelaciones           := TMSTable():New( oDb, "products_to_categories" )
      oTablaArticulos_Atributos  := TMSTable():New( oDb, "products_attributes" )
      oTablaOfertas              := TMSTable():New( oDb, "specials" )

      if oDb:ExistTable( "products_images" )
         oTablaArticulos_Images  := TMSTable():New( oDb, "products_images" )
      end if

      /*
      Abrimos las tablas-------------------------------------------------------
      */

      if oTablaArticulos:Open()           .and.;
         oTablaDescripciones:Open()       .and.;
         oTablaRelaciones:Open()          .and.;
         oTablaArticulos_Atributos:Open() .and.;
         oTablaOfertas:Open()

         if oTablaArticulos_Images        != nil
            oTablaArticulos_Images:Open()
         end if


         /*
         Vaciamos las tablas para el proceso global----------------------------
         */

         if ::lSincAll
            oTablaArticulos:oCmd:ExecDirect(             "TRUNCATE TABLE " + oTablaArticulos:cName )
            oTablaDescripciones:oCmd:ExecDirect(         "TRUNCATE TABLE " + oTablaDescripciones:cName )
            oTablaRelaciones:oCmd:ExecDirect(            "TRUNCATE TABLE " + oTablaRelaciones:cName )
            oTablaArticulos_Atributos:oCmd:ExecDirect(   "TRUNCATE TABLE " + oTablaArticulos_Atributos:cName )
            oTablaOfertas:oCmd:ExecDirect(               "TRUNCATE TABLE " + oTablaOfertas:cName )

            if oTablaArticulos_Images    != nil
               oTablaArticulos_Images:oCmd:ExecDirect(   "TRUNCATE TABLE " + oTablaArticulos_Images:cName )
            end if


            ::SetText ( 'Tablas de artículos borradas corectamente ', 2  )
         end if

         oTablaArticulos:GoTop()
         oTablaDescripciones:GoTop()
         oTablaRelaciones:GoTop()
         oTablaArticulos_Atributos:GoTop()
         oTablaOfertas:GoTop()

         if oTablaArticulos_Images        != nil
            oTablaArticulos_Images:GoTop()
         end if


         ::SetText ( 'Actualizando artículos de la web: ', 2 )

         /*
         Limpiamos tabla Articulos de Os---------------------------------------
         */

         if oTablaArticulos:RecCount() > 0

         for n := 1 to oTablaArticulos:RecCount()

            oTablaArticulos:Load()

            if ::oArt:SeekInOrd( Str( oTablaArticulos:GetBuffer( 1 ), 11 ), "cCodWeb" )

               if !::oArt:lPubInt

                  ::SetText( "Borrado registro "  + AllTrim( Str( oTablaArticulos:GetBuffer( 1 ) ) ) + " de la tabla products", 3 )

                  oTablaArticulos:Delete()

               end if

            else

               ::SetText( "Borrado registro "  + AllTrim( Str( oTablaArticulos:GetBuffer( 1 ) ) ) + " de la tabla products", 3 )

               oTablaArticulos:Delete()

            end if

            oTablaArticulos:Skip()

         next

         end if

         /*
         Limpiamos tabla Descripcion de Os-------------------------------------
         */

         for n := 1 to oTablaDescripciones:RecCount()

         oTablaDescripciones:Load()

            if ::oArt:SeekInOrd( Str( oTablaDescripciones:GetBuffer( 1 ), 11 ), "cCodWeb" )

               if !::oArt:lPubInt

                  ::SetText( "Borrado registro "  + AllTrim( Str( oTablaDescripciones:GetBuffer( 1 ) ) ) + " de la tabla products_description", 3 )

                  oTablaDescripciones:Delete()

               end if

            else

               ::SetText( "Borrado registro "  + AllTrim( Str( oTablaDescripciones:GetBuffer( 1 ) ) ) + " de la tabla products_description", 3 )

               oTablaDescripciones:Delete()

            end if

            oTablaDescripciones:Skip()

         next

         /*
         Limpiamos tabla Relaciones de  Os-------------------------------------
         */

         for n := 1 to oTablaRelaciones:RecCount()

            oTablaRelaciones:Load()

            if ::oArt:SeekInOrd( Str( oTablaRelaciones:GetBuffer( 1 ), 11 ), "cCodWeb" )

               if !::oArt:lPubInt

                  ::SetText( "Borrado registro "  + AllTrim( Str( oTablaRelaciones:GetBuffer( 1 ) ) ) + " de la tabla products_to_categories", 3 )

                  oTablaRelaciones:Delete()

               end if

            else

               ::SetText( "Borrado registro "  + AllTrim( Str( oTablaRelaciones:GetBuffer( 1 ) ) ) + " de la tabla products_to_categories", 3 )
               oTablaRelaciones:Delete()

            end if

            oTablaRelaciones:Skip()

         next

         /*
         Limpiamos tabla products images de  Os-------------------------------------
         */
         if oTablaArticulos_Images        != nil

            for n := 1 to oTablaArticulos_Images:RecCount()

               oTablaArticulos_Images:Load()

               if ::oArt:SeekInOrd( Str( oTablaArticulos_Images:GetBuffer( 2 ), 11 ), "cCodWeb" )

                  if !::oArt:lPubInt

                      ::SetText( "Borrado registro "  + AllTrim( Str( oTablaArticulos_Images:GetBuffer( 2 ) ) ) + " de la tabla products_images", 3 )

                      oTablaArticulos_Images:Delete()

                  end if

               else

                  ::SetText( "Borrado registro "  + AllTrim( Str( oTablaArticulos_Images:GetBuffer( 2 ) ) ) + " de la tabla products_images", 3 )
                  oTablaArticulos_Images:Delete()

               end if

               oTablaArticulos_Images:Skip()

            next

         end if

         /*
         Limpiamos tabla specials de  Os--------------------------------------------
         */

         for n := 1 to oTablaOfertas:RecCount()

            oTablaOfertas:Load()

            if ::oArt:SeekInOrd( Str( oTablaOfertas:GetBuffer( 2 ), 11 ), "cCodWeb" )

               if !::oArt:lPubInt

                  ::SetText( "Borrado registro "  + AllTrim( Str( oTablaOfertas:GetBuffer( 2 ) ) ) + " de la tabla specials", 3 )

                  oTablaOfertas:Delete()

               end if

            else

               ::SetText( "Borrado registro "  + AllTrim( Str( oTablaOfertas:GetBuffer( 2 ) ) ) + " de la tabla specials", 3 )
               oTablaOfertas:Delete()

            end if

            oTablaOfertas:Skip()

         next

         /*
         Compruebo datos para el meter-----------------------------------------
         */

         ::oArt:GoTop()
         while !::oArt:Eof()

            if ::oArt:lPubInt .and. ( ::oArt:lSndDoc .or. ::lSincAll )
               ::nTotMeter    += 1
            end if

            sysRefresh()

         ::oArt:Skip()

         end while

         ::oMeterL:SetTotal( ::nTotMeter )
         ::nActualMeterL := 1

         /*
         Añadimos artículos a Os-----------------------------------------------
         */

         ::oArt:GoTop()
         while !::oArt:Eof()

            if ::oArt:lPubInt .and. ( ::oArt:lSndDoc .or. ::lSincAll )

               ::MeterParticularText( " Actualizando artículo " + AllTrim( Str( ::nActualMeterL ) ) + " de "  + AllTrim( Str( ::nTotMeter ) ) )

               ::AppProducts( oTablaArticulos, oTablaDescripciones, oTablaRelaciones, oTablaArticulos_Atributos, oTablaArticulos_Images, oTablaOfertas, oDb )

               ::oArt:fieldPutByName( "lSndDoc", .f. )

            end if

            sysRefresh()

         ::oArt:Skip()

         end while

      else

         ::SetText ( 'No se puede abrir las tablas de artículos', 1  )

      end if

      oTablaArticulos:Free()
      oTablaDescripciones:Free()
      oTablaRelaciones:Free()
      oTablaArticulos_Atributos:Free()
      oTablaOfertas:Free()

      if oTablaArticulos_Images        != nil
         oTablaArticulos_Images:Free()
      end if

   else

      ::SetText( 'No existe la tabla de artículos', 1 )

   end if


Return(  Self )

//---------------------------------------------------------------------------//

METHOD AppProducts( oTablaArticulos, oTablaDescripciones, oTablaRelaciones, oTablaArticulos_Atributos, oTablaArticulos_Images, oTablaOfertas, oDb ) CLASS TComercio

   local o
   local n                 := 0
   local nIva              := 0
   local id_iva            := 0
   local cCodFab           := 0
   local nPrecio           := 0
   local nPrecioOferta     := 0
   local aStock            := {}
   local nStock            := 0
   local nCodigoWeb        := 0
   local nPrecioDef        := 0
   local nPrecioWeb        := 0

   oTablaArticulos:GoTop()
   oTablaDescripciones:GoTop()
   oTablaRelaciones:GoTop()
   oTablaArticulos_Atributos:GoTop()
   if oTablaArticulos_Images        != nil
      oTablaArticulos_Images:Gotop()
   end if
   oTablaOfertas:GoTop()

   nPrecioDef              := uFieldEmpresa( "nPreWebVta" )

   nIva                    := ( 1 + nIva( ::oIva, ::oArt:TipoIva ) / 100 )

   do case

      /*
      Tarifa 1 ----------------------------------------------------------------
      */

      case nPrecioDef <= 1 .and. !::oArt:lIvaInc

         nPrecio              := ::oArt:pVenta1

         if ::oArt:nImpInt1 != 0
            nPrecioOferta     := ::oArt:nImpInt1
         end if

      case nPrecioDef <= 1 .and. ::oArt:lIvaInc

         nPrecio              := Round( ::oArt:pVtaIva1 / nIva, nDwbDiv() )

         if ::oArt:nImpIva1 != 0
            nPrecioOferta     := Round( ::oArt:nImpIva1 / nIva, nDwbDiv() )
         end if

      /*
      Tarifa 2 ----------------------------------------------------------------
      */

      case nPrecioDef == 2 .and. !::oArt:lIvaInc

         nPrecio             := ::oArt:pVenta2

         if ::oArt:nImpInt2 != 0
            nPrecioOferta    := ::oArt:nImpInt2
         end if

      case nPrecioDef == 2 .and. ::oArt:lIvaInc

         nPrecio             := Round( ::oArt:pVtaIva2 / nIva, nDwbDiv() )

         if ::oArt:nImpIva2 != 0
            nPrecioOferta    := Round( ::oArt:nImpIva2 / nIva, nDwbDiv() )
         end if

      /*
      Tarifa 3 ----------------------------------------------------------------
      */

      case nPrecioDef == 3 .and. !::oArt:lIvaInc

         nPrecio             := ::oArt:pVenta3

         if ::oArt:nImpInt2 != 0
            nPrecioOferta    := ::oArt:nImpInt3
         end if

      case nPrecioDef == 3 .and. ::oArt:lIvaInc

         nPrecio             := Round( ::oArt:pVtaIva3 / nIva, nDwbDiv() )

         if ::oArt:nImpIva2 != 0
            nPrecioOferta    := Round( ::oArt:nImpIva3 / nIva, nDwbDiv() )
         end if

      /*
      Tarifa 4 ----------------------------------------------------------------
      */

      case nPrecioDef == 4 .and. !::oArt:lIvaInc

         nPrecio             := ::oArt:pVenta4

         if ::oArt:nImpInt4 != 0
            nPrecioOferta    := ::oArt:nImpInt4
         end if

      case nPrecioDef == 4 .and. ::oArt:lIvaInc

         nPrecio             := Round( ::oArt:pVtaIva4 / nIva, nDwbDiv() )

         if ::oArt:nImpIva4 != 0
            nPrecioOferta    := Round( ::oArt:nImpIva4 / nIva, nDwbDiv() )
         end if


      /*
      Tarifa 5 ----------------------------------------------------------------
      */

      case nPrecioDef == 5 .and. !::oArt:lIvaInc

         nPrecio             := ::oArt:pVenta5

         if ::oArt:nImpInt5 != 0
            nPrecioOferta    := ::oArt:nImpInt5
         end if

      case nPrecioDef == 5 .and. ::oArt:lIvaInc

         nPrecio             := Round( ::oArt:pVtaIva5 / nIva, nDwbDiv() )

         if ::oArt:nImpIva5 != 0
            nPrecioOferta    := Round( ::oArt:nImpIva5 / nIva, nDwbDiv() )
         end if


      /*
      Tarifa 6 ----------------------------------------------------------------
      */

      case nPrecioDef == 6 .and. !::oArt:lIvaInc

         nPrecio             := ::oArt:pVenta6

         if ::oArt:nImpInt2 != 0
            nPrecioOferta          := ::oArt:nImpInt6
         end if

      case nPrecioDef == 6 .and. ::oArt:lIvaInc

         nPrecio             := Round( ::oArt:pVtaIva6 / nIva, nDwbDiv() )

         if ::oArt:nImpIva6 != 0
            nPrecioOferta    := Round( ::oArt:nImpIva6 / nIva, nDwbDiv() )
         end if

   end case

   if nPrecio == 0

      nPrecio              := ::oArt:nImpInt1

      if ::oArt:nImpInt1 != 0
         nPrecio           := ::oArt:nImpInt1
      else
         nPrecio           := ::oArt:pVenta1
      end if

   end if

   /*
   Guardamos el precio minimo--------------------------------------------------
   */

   ::nPrecioMinimo         := nPrecio

   /*
   Si no tiene codigo web lo añadimos------------------------------------------
   */

   if ::oArt:cCodWeb == 0 .or. ::lSincAll

      /*
      Añade en la tabla products de Os-----------------------------------------
      */

      oTablaArticulos:Blank()

      /*
      Calculamos el Stock del artículo para subirlo a la web-------------------
      */

      oTablaArticulos:FieldPut( 2, Max( ::oStock:nStockArticulo( ::oArt:Codigo ), 0 ) )


      ::oStock:aStockArticulo( ::oArt:Codigo )

      /* Subimos los demás datos */

      oTablaArticulos:FieldPut( 3, Left( ::oArt:Codigo, 12 ) )
      oTablaArticulos:FieldPut( 4, cNoPathInt( ::cdImagen ) + "/" + cNoPath( cFirstImage( ::oArt:Codigo, ::oArtImg:cAlias ) ) )
      //oTablaArticulos:FieldPut( 5, nPrecio )
      oTablaArticulos:FieldPut( 5, if( ::oArt:pVtaWeb < 1, ::oArt:pVenta1 , ::oArt:pVtaWeb ) )
      oTablaArticulos:FieldPut( 6, GetSysDate() )
      oTablaArticulos:FieldPut( 9, ::oArt:nPesoKG )
      oTablaArticulos:FieldPut(10, 1 )
      oTablaArticulos:FieldPut(11, ::GetParentIva() )
      oTablaArticulos:FieldPut(12, ::GetParentFabricantes() )

      if oTablaArticulos:Insert()

         ::SetText( "Añadiendo artículo " + Rtrim( ::oArt:Codigo ) + Space( 1 ) + AllTrim( ::oArt:Nombre ), 3 )

         nCodigoWeb           := ::oCon:GetInsertId()

         ::oArt:fieldPutByName( "cCodWeb", nCodigoWeb )

         ::AppImages( oTablaArticulos_Images, nCodigoWeb )

         /*
         if Empty( ::oArt:cImagenWeb )
            ::AddImages( ::oArt:cImagen )
         else
            ::AddImages( ::oArt:cImagenWeb )
         end if

          */

      else

         ::SetText( "Error insertado" + Rtrim( ::oArt:Codigo ) + Space( 1 ) + AllTrim( ::oArt:Nombre ) + " en tabla products", 3 )

         return .f.

      end if

      /*
      Añade en la tabla products_description-----------------------------------
      */

      oTablaDescripciones:Blank()

      oTablaDescripciones:FieldPut( 2, ::nLanguage )
      oTablaDescripciones:FieldPut( 3, ::SeleccionFamilia() )

      oTablaDescripciones:FieldPut( 4, ::oCon:EscapeStr( ::oArt:mDesTec ) )

      if !oTablaDescripciones:Insert()
      ::SetText( "Error insertado" + Rtrim( ::oArt:Codigo ) + Space( 1 ) + Alltrim( ::oArt:Nombre ) + " en tabla products_description", 3 )
      end if

      /*
      Añade en la tabla products_to_categories---------------------------------
      */

      oTablaRelaciones:Blank()

      oTablaRelaciones:FieldPut( 1, ::oArt:cCodWeb  )

      if Empty( ::oArt:cCodTip )
         oTablaRelaciones:FieldPut( 2, ::GetParentCategories() )
      else
         oTablaRelaciones:FieldPut( 2, ::GetParentTipoArticulo( oDb ) )
      end if

      if !oTablaRelaciones:Insert()
         ::SetText( "Error insertado" + Rtrim( ::oArt:Codigo ) + Space( 1 ) + Alltrim( ::oArt:Nombre ) + " en tabla products_to_categories", 3 )
      end if

      /*
      Añado atributos a los articulos------------------------------------------
      */

      ::AppAtributes( oTablaArticulos_Atributos, nCodigoWeb )

      /*
      Añad o las ofertas si las tuviese-----------------------------------------
      */

      if ::oArt:pVtaWeb  != 0                 .and.;
         ::oArt:pVtaWeb  != ::oArt:nImpInt1   .and.;
         ::oArt:nImpInt1 != 0

            oTablaOfertas:Blank()

            oTablaOfertas:FieldPut( 2, ::oArt:cCodWeb )
            oTablaOfertas:FieldPut( 3, nPrecioOferta )
            oTablaOfertas:FieldPut( 4, GetSysDate() )
            oTablaOfertas:FieldPut( 8, 1 )

            if !oTablaOfertas:Insert()
               ::SetText( "Error insertado" + Rtrim( ::oArt:Codigo ) + Space( 1 ) + Alltrim( ::oArt:Nombre ) + " en tabla specials", 3 )
            end if

     end if

   else

      /*
      Modifico en la tabla products
      */

      if oTablaArticulos:RecCount() > 0 .and. oTablaArticulos:Find( 1, ::oArt:cCodWeb, .t. )

         oTablaArticulos:Load()

         oTablaArticulos:FieldPut( 2, 1 )
         oTablaArticulos:FieldPut( 3, Left( ::oArt:Codigo, 12 ) )

         /*
          if Empty( ::oArt:cImagenWeb )
            oTablaArticulos:FieldPut( 4, cNoPathInt( ::cdImagen ) + "/" + cNoPath( ::oArt:cImagen ) )
         else
            oTablaArticulos:FieldPut( 4, cNoPathInt( ::cdImagen ) + "/" + cNoPath( ::oArt:cImagenWeb ) )
         end if
         */

         oTablaArticulos:FieldPut( 4, cNoPathInt( ::cdImagen ) + "/" + cNoPath( cFirstImage( ::oArt:Codigo, ::oArtImg:cAlias ) ) )
         //oTablaArticulos:FieldPut( 5, nPrecio )
         oTablaArticulos:FieldPut( 5, if( ::oArt:pVtaWeb < 1, ::oArt:pVenta1, ::oArt:pVtaWeb ) )
         oTablaArticulos:FieldPut( 6, GetSysDate() )
         oTablaArticulos:FieldPut( 9, ::oArt:nPesoKG )
         oTablaArticulos:FieldPut(10, 1 )
         oTablaArticulos:FieldPut(11, ::GetParentIva() )
         oTablaArticulos:FieldPut(12, ::GetParentFabricantes() )

         if oTablaArticulos:update()
            ::SetText( "Modificando articulo " + Rtrim( ::oArt:Codigo ) + Space( 1 ) + AllTrim( ::oArt:Nombre ), 3 )

            if Empty( ::oArt:cImagenWeb )
               ::AddImages( ::oArt:cImagen )
            else
               ::AddImages( ::oArt:cImagenWeb )
            end if

         else
            ::SetText( "Error modificando" + Rtrim( ::oArt:Codigo ) + Space( 1 ) + AllTrim( ::oArt:Nombre ) + " en tabla products", 3 )
         end if

      end if

      /*
      Modifico en la tabla products_description
      */

      if oTablaDescripciones:RecCount() > 0 .and. oTablaDescripciones:Find( 1, ::oArt:cCodWeb, .t. )

         oTablaDescripciones:Load()

         oTablaDescripciones:FieldPut( 2, ::nLanguage )
         //oTablaDescripciones:FieldPut( 3, ::oCon:EscapeStr( ::oArt:Nombre ) )
         oTablaDescripciones:FieldPut( 3, ::SeleccionFamilia() )
         oTablaDescripciones:FieldPut( 4, ::oCon:EscapeStr( ::oArt:mDesTec ) )

         if !oTablaDescripciones:update()
            ::SetText( "Error modificando" + Rtrim( ::oArt:Codigo ) + Space( 1 ) + AllTrim( ::oArt:Nombre ) + " en tabla products_description", 3 )
         end if

      end if

      /*
      Modificar en la tabla products_to_categories
      */

      if oTablaRelaciones:RecCount() > 0 .and. oTablaRelaciones:Find( 1, ::oArt:cCodWeb, .t. )

         oTablaRelaciones:FieldPut( 1, ::oArt:cCodWeb )

         if Empty( ::oArt:cCodtip )
            oTablaRelaciones:FieldPut( 2, ::GetParentCategories() )
         else
            oTablaRelaciones:FieldPut( 2, ::GetParentTipoArticulo( oDb ) )
         end if

         if !oTablaRelaciones:update()
            ::SetText( "Error modificando" + Rtrim( ::oArt:Codigo ) + Space( 1 ) + AllTrim( ::oArt:Nombre ) + " en tabla products_to_categories", 3 )
         end if

      else

         oTablaRelaciones:Blank()

         oTablaRelaciones:FieldPut( 1, ::oArt:cCodWeb  )

         if Empty( ::oArt:cCodtip )
            oTablaRelaciones:FieldPut( 2, ::GetParentCategories() )
         else
            oTablaRelaciones:FieldPut( 2, ::GetParentTipoArticulo( oDb ) )
         end if

         if !oTablaRelaciones:Insert()
            ::SetText( "Error insertado" + Rtrim( ::oArt:Codigo ) + Space( 1 ) + Alltrim( ::oArt:Nombre ) + " en tabla products_to_categories", 3 )
         end if

      end if

      /*
      Modifico en la tabla Ofertas
      */

      if oTablaOfertas:RecCount() > 0 .and. oTablaOfertas:Find( 1, ::oArt:cCodWeb, .t. )

            oTablaOfertas:Load()

            oTablaOfertas:FieldPut( 2, ::oArt:cCodWeb )
            oTablaOfertas:FieldPut( 3, nPrecioOferta )
            oTablaOfertas:FieldPut( 4, GetSysDate() )
            oTablaOfertas:FieldPut( 8, 1 )

            if !oTablaOfertas:update()
               ::SetText( "Error modificando" + Rtrim( ::oArt:Codigo ) + Space( 1 ) + AllTrim( ::oArt:Nombre ) + " en tabla specials", 3 )
            end if

      end if

      /*
      Añado las imagenes
      */

      ::AppImages( oTablaArticulos_Images, ::oArt:cCodWeb )

      /*
      Añado los atributos
      */

      ::AppAtributes( oTablaArticulos_Atributos, ::oArt:cCodWeb )

   end if

   /*
   Añadimos precios por propiedades--------------------------------------------
   */

   ::AppPreciosAtributes( oTablaArticulos, oTablaArticulos_Atributos )

Return nCodigoWeb

//---------------------------------------------------------------------------//

Method AppAtributes( oTablaArticulos_Atributos, nCodigoWeb ) CLASS TComercio

   local n
   local aValPrp1
   local aValPrp2

   /*
   Eliminamos las relaciones tabla products_attributes primer atributo---------
   */

   oTablaArticulos_Atributos:GoTop()

   if oTablaArticulos_Atributos:RecCount() > 0

   for n := 1 to oTablaArticulos_Atributos:RecCount()

      oTablaArticulos_Atributos:Load()

      if oTablaArticulos_Atributos:GetBuffer( 2 ) == nCodigoWeb

         ::SetText( "Borrado registro "  + AllTrim( Str( oTablaArticulos_Atributos:GetBuffer( 1 ) ) ) + " relación de atributos", 3 )

         oTablaArticulos_Atributos:Delete()

      end if

      oTablaArticulos_Atributos:Skip()

   next

   end if

   /*
   Añade en la tabla products_attributes primer atributo-----------------------
   */

   ::oTblPro:GetStatus()

   ::oTblPro:OrdSetFocus( "cCodWeb" )

   if !Empty( ::oArt:cCodPrp1 )

      ::oTblPro:GoTop()
      while !::oTblPro:Eof()

         if ::oArt:cCodPrp1 == ::oTblPro:cCodPro

            aValPrp1 := hb_aTokens( ::oArt:mValPrp1, "," )

            if Empty( ::oArt:mValPrp1 ) .or. aScan( aValPrp1, {|a| Alltrim( ::oTblPro:cCodTbl ) == a } ) != 0

               oTablaArticulos_Atributos:Blank()

               oTablaArticulos_Atributos:FieldPut( 2, nCodigoWeb )
               oTablaArticulos_Atributos:FieldPut( 3, oRetFld( ::oArt:cCodPrp1, ::oPro, "cCodWeb" ) )
               oTablaArticulos_Atributos:FieldPut( 4, ::oTblPro:cCodWeb )

               if !oTablaArticulos_Atributos:Insert()
                  ::SetText( "Error insertado" + Rtrim( ::oArt:Codigo ) + Space( 1 ) + Alltrim( ::oArt:Nombre ) + " con la propiedad " + Alltrim( ::oTblPro:cCodTbl ) + " en tabla products_attributes", 3 )
               else
                  ::SetText( "Registro insertado" + Rtrim( ::oArt:Codigo ) + Space( 1 ) + Alltrim( ::oArt:Nombre ) + " con la propiedad " + Alltrim( ::oTblPro:cCodTbl ) + " en tabla products_attributes", 3 )
               end if

            end if

         end if

         ::oTblPro:Skip()

      end while

   end if

   /*
   Añade en la tabla products_attributes segundo atributo
   */

   if !Empty( ::oArt:cCodPrp2 )

      ::oTblPro:GoTop()
      while !::oTblPro:Eof()

         if ::oArt:cCodPrp2 == ::oTblPro:cCodPro

            aValPrp2 := hb_aTokens( ::oArt:mValPrp2, "," )

            if Empty( ::oArt:mValPrp2 ) .or. aScan( aValPrp2, {|a| Alltrim( ::oTblPro:cCodTbl ) == a } ) != 0

               oTablaArticulos_Atributos:Blank()

               oTablaArticulos_Atributos:FieldPut( 2, nCodigoWeb )
               oTablaArticulos_Atributos:FieldPut( 3, oRetFld( ::oArt:cCodPrp2, ::oPro, "cCodWeb" ) )
               oTablaArticulos_Atributos:FieldPut( 4, ::oTblPro:cCodWeb )

               if !oTablaArticulos_Atributos:Insert()
                  ::SetText( "Error insertado" + Rtrim( ::oArt:Codigo ) + Space( 1 ) + Alltrim( ::oArt:Nombre ) + " con la propiedad " + Alltrim( ::oTblPro:cCodTbl ) + " en tabla products_attributes", 3 )
               else
                  ::SetText( "Registro insertado" + Rtrim( ::oArt:Codigo ) + Space( 1 ) + Alltrim( ::oArt:Nombre ) + " con la propiedad " + Alltrim( ::oTblPro:cCodTbl ) + " en tabla products_attributes", 3 )
               end if

            end if

         end if

         ::oTblPro:Skip()

      end while

   end if

   ::oTblPro:SetStatus()

   /*
   Alteramos la tabla para ordenarla ascendete---------------------------------
   */

   oTablaArticulos_Atributos:oCmd:ExecDirect( "ALTER TABLE `products_attributes` ORDER BY `products_attributes_id`"  )

return nil

//---------------------------------------------------------------------------//

Method AppImages( oTablaArticulos_Images, nCodigoWeb ) CLASS TComercio

   local n
   local nImage := 0

   /*
   Eliminamos las relaciones tabla products_images ---------------------------
   */
   if oTablaArticulos_Images        != nil

      oTablaArticulos_Images:GoTop()

      if oTablaArticulos_Images:RecCount() > 0

      for n := 1 to oTablaArticulos_Images:RecCount()

       oTablaArticulos_Images:Load()

         if oTablaArticulos_Images:GetBuffer( 2 ) == nCodigoWeb

            ::SetText( "Borrado registro "  + AllTrim( Str( oTablaArticulos_Images:GetBuffer( 1 ) ) ) + " relación de imagenes", 3 )

            oTablaArticulos_Images:Delete()

         end if

         oTablaArticulos_Images:Skip()

      next

      end if

   /*
   Añade en la tabla products_images las imagenes ----------------------------
   */

      ::oArtImg:GetStatus()

      ::oArtImg:OrdSetFocus( "cCodArt" )

      if ::oArtImg:Seek( ::oArt:Codigo )

       while ( ::oArtImg:cCodArt == ::oArt:Codigo ) .and. !::oArtImg:Eof()

            oTablaArticulos_Images:Blank()

            oTablaArticulos_Images:FieldPut( 2, nCodigoWeb )

            oTablaArticulos_Images:FieldPut( 3, cNoPathInt( ::cdImagen ) + "/" + cNoPath( ::oArtImg:cImgArt) )

            oTablaArticulos_Images:FieldPut( 4, ++nImage  )

            if !oTablaArticulos_Images:Insert()
               ::SetText( "Error insertado" + Rtrim( ::oArt:Codigo ) + Space( 1 ) + Alltrim( ::oArt:Nombre ) + " con la imagen " + Alltrim( ::oArt:Codigo ) + " en tabla products_images", 3 )
          else
              ::SetText( "Registro insertado" + Rtrim( ::oArt:Codigo ) + Space( 1 ) + Alltrim( ::oArt:Nombre ) + " con la imagen " + Alltrim( ::oArt:Codigo ) + " en tabla products_images", 3 )

              ::AddImages( ::oArtImg:cImgArt )

          end if

            ::oArtImg:Skip()

         end while

      end if

      ::oArtImg:SetStatus()

   end if

return nil

//---------------------------------------------------------------------------//

Method AppPreciosAtributes( oTablaArticulos, oTablaArticulos_Atributos ) CLASS TComercio

   local nIva
   local oPrePro
   local aPrePro     := {}
   local nPrePro     := 0
   local cStatement  := ""

   nIva              := ( 1 + nIva( ::oIva, ::oArt:TipoIva ) / 100 )

   /*
   Rellenamos un array con los valores de precios por propiedades--------------
   */

   ::oArtDiv:GetStatus()

   if ::oArtDiv:Seek( ::oArt:Codigo )

      while ::oArtDiv:cCodArt == ::oArt:Codigo .and. !::oArtDiv:Eof()

         with object ( SPrePro() )

            :cCodArt    := Str( ::oArt:cCodWeb )
            :cCodPrp    := Str( RetFld( ::oArtDiv:cCodPr1, ::oPro:cAlias, "cCodWeb", "cCodPro" ) )
            :cValPrp    := Str( RetFld( ::oArtDiv:cCodPr1 + ::oArtDiv:cValPr1, ::oTblPro:cAlias, "cCodWeb", "cCodPro" ) )

            if ::oArt:lIvaInc .and. nIva != 0
               :nPrecio := Round( ::oArtDiv:nPreIva1 / nIva, nDwbDiv() )
            else
               :nPrecio := ::oArtDiv:nPreVta1
            end if

            aAdd( aPrePro, oClone( hb_QWith() ) )

         end with

         ::oArtDiv:Skip()

      end while

   end if

   if Len( aPrePro ) != 0

      /*
      Buscamos el menor precio por propiedad--------------------------------------
      */

      if ::nPrecioMinimo == 0

         for each oPrePro in aPrePro

            if ::nPrecioMinimo == 0
               ::nPrecioMinimo   := oPrePro:nPrecio
            end if

            ::nPrecioMinimo      := Min( oPrePro:nPrecio, ::nPrecioMinimo )

         next

      end if

      /*
      Cambiamos el precio en el artículo------------------------------------------
      */

      cStatement                    := "UPDATE " + oTablaArticulos:cName + Space( 1 )
      cStatement                    += "SET "
      cStatement                    += "products_price = '" + Alltrim( Str( ::nPrecioMinimo ) ) + "' "
      cStatement                    += "WHERE "
      cStatement                    += "products_id = '" + Alltrim( Str( ::oArt:cCodWeb ) ) + "' "
      cStatement                    += "LIMIT 1"

      if !TMSCommand():New( ::oCon ):ExecDirect( cStatement )
         ::SetText( "Error modificando precio mínimo de artículo", 3 )
      end if

      /*
      Cambiamos los precios por propiedades---------------------------------------
      */

      for each oPrePro in aPrePro

         nPrePro     := oPrePro:nPrecio - ::nPrecioMinimo

         if nPrePro  != 0

            cStatement    := "UPDATE products_attributes "
            cStatement    += "SET "
            cStatement    += "options_values_price = '" + Alltrim( Str( Abs( nPrePro ) ) ) + "' , "
            if nPrePro > 0
               cStatement += "price_prefix = '+' "
            else
               cStatement += "price_prefix = '-' "
            end if
            cStatement    += "WHERE "
            cStatement    += "products_id = '" + Alltrim( oPrePro:cCodArt ) + "' AND "
            cStatement    += "options_id = '" + Alltrim( oPrePro:cCodPrp ) + "' AND "
            cStatement    += "options_values_id = '" + Alltrim( oPrePro:cValPrp ) + "'"

            if !TMSCommand():New( ::oCon ):ExecDirect( cStatement )
               ::SetText( "Error al modificar precios por propiedades", 3 )
            end if

         end if

      next

   end if

   ::oArtDiv:SetStatus()

return nil

//---------------------------------------------------------------------------//

Method DropAtributes( oTablaArticulos_Atributos ) CLASS TComercio

   oTablaArticulos_Atributos:oCmd:ExecDirect( "TRUNCATE TABLE " + oTablaArticulos_Atributos:cName )

Return nil

//---------------------------------------------------------------------------//

Method AppendFamilia_bd( oDb ) CLASS TComercio

   local n
   local oTablaFamilias
   local oTablaFamiliasDesc

   if oDb:ExistTable( "categories" ) .and. oDb:ExistTable( "categories_description" )

      oTablaFamilias       := TMSTable():New( oDb, "categories" )
      oTablaFamiliasDesc   := TMSTable():New( oDb, "categories_description" )

      if oTablaFamilias:Open() .and. oTablaFamiliasDesc:Open()

         oTablaFamilias:GoTop()
         oTablaFamiliasDesc:GoTop()

         ::SetText ( 'Actualizando familias y grupos de familias: ', 2 )

         /*
         Añadimos familias a nuestras tablas-----------------------------------
         */

         ::AppCategories_bd( oTablaFamilias, oTablaFamiliasDesc )

      else

         ::SetText ( 'No se puede abrir la tabla: ' + oTablaFamilias:cName, 1 )

      end if

      oTablaFamilias:Free()
      oTablaFamiliasDesc:Free()

   else

      ::SetText ( 'No se puede crear la tabla: ' + oTablaFamilias:cName, 1 )

   end if

Return ( Self )

//---------------------------------------------------------------------------//

Method AppCategories_bd( oTablaFamilias, oTablaFamiliasDesc ) CLASS TComercio

   local cCodigoWeb  := 0
   local cImagen
   local cNombre
   local n
   local n2

   ::nTotMeter       := 0

   /*
   Compruebo datos para el meter-----------------------------------------------
   */

   oTablaFamilias:GoTop()
   oTablaFamiliasDesc:GoTop()

   if oTablaFamilias:RecCount() > 0

   for n := 1 to oTablaFamilias:RecCount()

      ::nTotMeter += 1

      oTablaFamiliasDesc:skip()

   next

   end if

   ::oMeterL:SetTotal( ::nTotMeter )
   ::nActualMeterL := 1

   /*
   Descargo los datos de oscommerce--------------------------------------------
   */

   oTablaFamilias:GoTop()
   oTablaFamiliasDesc:GoTop()

   if oTablaFamilias:RecCount() > 0

   for n := 1 to oTablaFamilias:RecCount()

      oTablaFamilias:Load()

      cCodigoWeb     := oTablaFamilias:GetBuffer( 1 )
      cImagen        := oTablaFamilias:GetBuffer( 2 )

      oTablaFamiliasDesc:GoTop()

      for n2 := 1 to oTablaFamiliasDesc:RecCount()

         oTablaFamiliasDesc:Load()

         if oTablaFamiliasDesc:GetBuffer( 1 ) == cCodigoWeb .and. oTablaFamiliasDesc:GetBuffer( 2 ) == ::nLanguage

            cNombre  := oTablaFamiliasDesc:GetBuffer( 3 )

         end if

         oTablaFamiliasDesc:skip()

      next

      /*
      Guardo familia de OsCommercer en nuestra tabla---------------------------
      */

      ::MeterParticularText( " Descargando familia " + AllTrim( Str( ::nActualMeterL ) ) + " de "  + AllTrim( Str( ::nTotMeter ) ) )

      if !::oFam:SeekInOrd( Str( cCodigoWeb, 11 ), "cCodWeb" )

         ::oFam:Append()

         ::oFam:cCodFam       := RJust( NextVal( DbLast( ::oFam:cAlias , 1, nil, nil, 1 ) ), "0", 3 )
         ::oFam:cNomFam       := cNombre
         ::oFam:cImgBtn       := uFieldEmpresa( "cDirImg" ) + "\" + cNoPathInt( cImagen )
         ::oFam:cCodWeb       := cCodigoWeb
         ::oFam:lPubInt       := .t.

         if ::oFam:save()

            ::SetText( "Añadido familia " + Rtrim( cNombre ), 3 )

            ::AddImages( cImagen )

         else

            ::SetText( "Error al añadir familia" + Rtrim( cNombre ), 3 )

         end if

      else

         ::oFam:Load()

         ::oFam:cNomFam       := cNombre
         ::oFam:cImgBtn       := uFieldEmpresa( "cDirImg" ) + "\" + cNoPathInt( cImagen )
         ::oFam:cCodWeb       := cCodigoWeb
         ::oFam:lPubInt       := .t.

         if ::oFam:save()

            ::SetText( "Modificando familia " + Rtrim( cNombre ), 3 )

            ::AddImages( cImagen )

         else

            ::SetText( "Error al modificar familia " + Rtrim( cNombre ), 3 )

         end if

      end if

      oTablaFamiliasDesc:skip()

   next

   end if

return .t.

//---------------------------------------------------------------------------//

Method AppendFamilia( oDb ) CLASS TComercio

   local n
   local oTablaFamilias
   local oTablaFamiliasDesc

   ::nTotMeter             := 0

   if oDb:ExistTable( "categories" ) .and.;
      oDb:ExistTable( "categories_description" )

      oTablaFamilias       := TMSTable():New( oDb, "categories" )
      oTablaFamiliasDesc   := TMSTable():New( oDb, "categories_description" )

      if oTablaFamilias:Open()   .and.;
         oTablaFamiliasDesc:Open()

         /*
         Vaciamos las tablas para el proceso global----------------------------
         */

         if ::lSincAll
            oTablaFamilias:oCmd:ExecDirect( "TRUNCATE TABLE " + oTablaFamilias:cName )
            oTablaFamiliasDesc:oCmd:ExecDirect( "TRUNCATE TABLE " + oTablaFamiliasDesc:cName )
            ::SetText ( 'Tablas de familias borradas corectamente ', 2  )
         end if

         oTablaFamilias:GoTop()
         oTablaFamiliasDesc:GoTop()

         ::SetText ( 'Actualizando familias y grupos de familias: ', 2 )

         /*
         Limpiamos tabla de grupo de Familias de Os-------------------------------
         */

         if oTablaFamilias:RecCount() > 0

         for n := 1 to oTablaFamilias:RecCount()

            oTablaFamilias:Load()

            /*
            if !::oGrpFam:SeekInOrd(   Str( oTablaFamilias:GetBuffer( 1 ), 11 ), "cCodWeb" )   .and.;
               !::oFam:SeekInOrd(      Str( oTablaFamilias:GetBuffer( 1 ), 11 ), "cCodWeb" )

               ::SetText( "Borrado " + AllTrim( Str( oTablaFamilias:GetBuffer( 1 ) ) ) + " de la tabla categories 1", 3 )

               oTablaFamilias:Delete()
            */

            if ::oGrpFam:SeekInOrd( Str( oTablaFamilias:GetBuffer( 1 ), 11 ), "cCodWeb" )

               if !::oGrpFam:lPubInt

                  ::SetText( "Borrado "  + AllTrim( Str( oTablaFamilias:GetBuffer( 1 ) ) ) + " de la tabla categories 2", 3 )

                  oTablaFamilias:Delete()

               end if

            elseif ::oFam:SeekInOrd( Str( oTablaFamilias:GetBuffer( 1 ), 11 ), "cCodWeb" )

               if !::oFam:lPubInt

                  ::SetText( "Borrado "  + AllTrim( Str( oTablaFamilias:GetBuffer( 1 ) ) ) + " de la tabla categories 3", 3 )

                  oTablaFamilias:Delete()

               end if

            end if

            oTablaFamilias:Skip()

         next

         end if

         /*
         Limpiamos tabla de grupo de Familias de Os-------------------------------
         */

         if oTablaFamiliasDesc:RecCount() > 0

         for n := 1 to oTablaFamiliasDesc:RecCount()

            oTablaFamiliasDesc:Load()
            /*
            if !::oGrpFam:SeekInOrd(   Str( oTablaFamiliasDesc:GetBuffer( 1 ), 11 ), "cCodWeb" ) .and.;
               !::oFam:SeekInOrd(      Str( oTablaFamiliasDesc:GetBuffer( 1 ), 11 ), "cCodWeb" ) .and.;
               !::oTipArt:SeekInOrd(   Str( oTablaFamiliasDesc:GetBuffer( 1 ), 11 ), "cCodWeb" )

               ::SetText( "Borrado " + AllTrim( Str( oTablaFamiliasDesc:GetBuffer( 1 ) ) ) + " de la tabla categories_description", 3 )

               oTablaFamiliasDesc:Delete()
            */
            if ::oGrpFam:SeekInOrd( Str( oTablaFamiliasDesc:GetBuffer( 1 ), 11 ), "cCodWeb" )

               if !::oGrpFam:lPubInt

                  ::SetText( "Borrado "  + AllTrim( Str( oTablaFamiliasDesc:GetBuffer( 1 ) ) ) + " de la tabla categories_description", 3 )

                  oTablaFamiliasDesc:Delete()

               end if

            elseif ::oFam:SeekInOrd( Str( oTablaFamiliasDesc:GetBuffer( 1 ), 11 ), "cCodWeb" )

               if !::oFam:lPubInt

                  ::SetText( "Borrado "  + AllTrim( Str( oTablaFamiliasDesc:GetBuffer( 1 ) ) ) + " de la tabla categories_description", 3 )

                  oTablaFamiliasDesc:Delete()

               end if

            end if

            oTablaFamiliasDesc:Skip()

         next

         end if

         /*
         Compruebo datos para el meter-----------------------------------------
         */

         ::oGrpFam:GoTop()
         while !::oGrpFam:Eof()

            if ::oGrpFam:lPubInt .and. ( ::oGrpFam:lSndDoc .or. ::lSincAll )
               ::nTotMeter += 1
            end if

            ::oGrpFam:Skip()

         end while

         ::oFam:GoTop()
         while !::oFam:Eof()

            if ::oFam:lPubInt .and. ( ::oFam:lSelDoc .or. ::lSincAll )
               ::nTotMeter += 1
            end if

            ::oFam:Skip()

         end while

         ::oMeterL:SetTotal( ::nTotMeter )

         ::nActualMeterL   := 1

         /*
         Añadimos Grupos de familia a Os--------------------------------------
         */

         ::oGrpFam:GoTop()

         while !::oGrpFam:Eof()

            if ::oGrpFam:lPubInt .and. ( ::oGrpFam:lSndDoc .or. ::lSincAll )

               ::MeterParticularText( " Actualizando familia " + AllTrim( Str( ::nActualMeterL ) ) + " de "  + AllTrim( Str( ::nTotMeter ) ) )

               ::AppGrpCategories( oTablaFamilias, oTablaFamiliasDesc )

            end if

            ::oGrpFam:FieldPutByName( "lSndDoc", .f. )

            ::oGrpFam:Skip()

         end while

         /*
         Añadimos familias a Os------------------------------------------------
         */

         ::oFam:GoTop()

         while !::oFam:Eof()

            if ::oFam:lPubInt .and. ( ::oFam:lSelDoc .or. ::lSincAll )

               ::MeterParticularText( "Actualizando familia " + AllTrim( Str( ::nActualMeterL ) ) + " de " + AllTrim( Str( ::nTotMeter ) ) )

               ::AppCategories( oTablaFamilias, oTablaFamiliasDesc )

            end if

            ::oFam:FieldPutByName( "lSelDoc", .f. )

            ::oFam:Skip()

         end while

      else

         ::SetText ( 'No se puede abrir la tabla: ' + oTablaFamilias:cName, 1 )

      end if

      oTablaFamilias:Free()

   else

      ::SetText ( 'No se puede crear la tabla: ' + oTablaFamilias:cName, 1 )

   end if

Return ( Self )

//---------------------------------------------------------------------------//

Method AppCategories( oTablaFamilias, oTablaFamiliasDesc ) CLASS TComercio

   local nCodigoWeb        := 0

   oTablaFamilias:GoTop()

   if ( ::oFam:cCodWeb == 0 .or. ::lSincAll )

      /*
      Añade en la tabla categories de Os---------------------------------------
      */

      oTablaFamilias:Blank()
      oTablaFamilias:FieldPut( 2, cNoPathInt( ::cdImagen ) + "/" + cNoPath( ::oFam:cImgBtn ) )
      oTablaFamilias:FieldPut( 3, ::GetParentFamilia() )
      oTablaFamilias:FieldPut( 4, ::oFam:nPosInt )
      oTablaFamilias:FieldPut( 5, GetSysDate() )
      oTablaFamilias:FieldPut( 6, GetSysDate() )

      if oTablaFamilias:Insert()

         ::SetText( "Añadiendo familia " + Rtrim( ::oFam:cCodFam ) + Space( 1 ) + AllTrim( ::oFam:cNomFam ), 3 )

         nCodigoWeb           := ::oCon:GetInsertId()

         ::oFam:fieldPutByName( "cCodWeb", nCodigoWeb )

         ::AddImages( ::oFam:cImgBtn )

      else

         ::SetText( "Error insertado" + Rtrim( ::oFam:cCodFam ) + Space( 1 ) + AllTrim( ::oFam:cNomFam ) + " en tabla categories", 3 )

      end if

      /*
      añade en la tabla categories_description---------------------------------
      */

      if nCodigoWeb != 0

         oTablaFamiliasDesc:Blank()
         oTablaFamiliasDesc:FieldPut( 1, nCodigoWeb )
         oTablaFamiliasDesc:FieldPut( 2, ::nLanguage )
         oTablaFamiliasDesc:FieldPut( 3, ::oCon:EscapeStr( ::oFam:cNomFam ) )

         if !oTablaFamiliasDesc:Insert()
            ::SetText( "Error insertado" + Rtrim( ::oArt:Codigo ) + Space( 1 ) + Alltrim( ::oArt:Nombre ) + " en tabla products_description", 3 )
         end if

      end if

   else

      /*
      Modificar en la tabla categories-----------------------------------------
      */

      if oTablaFamilias:RecCount() > 0 .and. oTablaFamilias:Find( 1, ::oFam:cCodWeb, .t. )

         oTablaFamilias:Load()

         oTablaFamilias:FieldPut( 2, cNoPathInt( ::cdImagen ) + "/" + cNoPath( ::oFam:cImgBtn ) )
         oTablaFamilias:FieldPut( 3, 0 )
         oTablaFamilias:FieldPut( 3, ::GetParentFamilia() )
         oTablaFamilias:FieldPut( 4, ::oFam:nPosInt )
         oTablaFamilias:FieldPut( 5, GetSysDate() )
         oTablaFamilias:FieldPut( 6, GetSysDate() )

         if oTablaFamilias:update()

            ::SetText( "Modificando Familia " + Rtrim( ::oFam:cCodFam ) + Space( 1 ) + AllTrim( ::oFam:cNomFam), 3 )

            ::AddImages( ::oFam:cImgBtn )

         else

            ::SetText( "Error modificando" + Rtrim( ::oFam:cCodFam ) + Space( 1 ) + AllTrim( ::oFam:cNomFam ) + " en tabla categories", 3 )

         end if

      end if

      /*
      Modificar en la tabla categories_description-----------------------------
      */

      if oTablaFamiliasDesc:RecCount() > 0 .and. oTablaFamiliasDesc:Find( 1, ::oFam:cCodWeb, .t.)

         oTablaFamiliasDesc:Load()

         oTablaFamiliasDesc:FieldPut( 2, ::nLanguage )
         oTablaFamiliasDesc:FieldPut( 3, ::oCon:EscapeStr( ::oFam:cNomFam ) )

         if !oTablaFamiliasDesc:update()
            ::SetText( "Error modificando" + Rtrim( ::oFam:cCodFam ) + Space( 1 ) + AllTrim( ::oFam:cNomFam ) + " en tabla categories_description", 3 )
         end if

      end if

   end if

return nCodigoWeb

//---------------------------------------------------------------------------//

Method AppGrpCategories( oTablaFamilias, oTablaFamiliasDesc ) CLASS TComercio

   local nCodigoWeb        := 0

   oTablaFamilias:GoTop()

   if ::oGrpFam:cCodWeb == 0 .or. ::lSincAll

      /*
      Añade grupos de familias en la tabla categories------------------------
      */

      oTablaFamilias:Blank()
      oTablaFamilias:FieldPut( 3, 0 )
      //oTablaFamilias:FieldPut( 4, ::oFam:nPosInt )
      oTablaFamilias:FieldPut( 5, GetSysDate() )
      oTablaFamilias:FieldPut( 6, GetSysDate() )

      if oTablaFamilias:Insert()

         ::SetText( "Añadiendo Grupo de familia " + Rtrim( ::oGrpFam:cCodGrp ) + Space( 1 ) + AllTrim( ::oGrpFam:cNomGrp ), 3 )

         nCodigoWeb           := ::oCon:GetInsertId()

         ::oGrpFam:fieldPutByName( "cCodWeb", nCodigoWeb )

      end if

      /*
      Añade grupo de familias en la tabla categories_description-------------
      */

      oTablaFamiliasDesc:Blank()
      oTablaFamiliasDesc:FieldPut( 1, nCodigoWeb )
      oTablaFamiliasDesc:FieldPut( 2, ::nLanguage )
      oTablaFamiliasDesc:FieldPut( 3, ::oCon:EscapeStr( ::oGrpFam:cNomGrp ) )

      if !oTablaFamiliasDesc:Insert()
         ::SetText( "Error insertado" + Rtrim( ::oGrpFam:cCodGrp ) + Space( 1 ) + AllTrim( ::oGrpFam:cNomGrp ) + " en tabla categories", 3 )
      end if

   else
      /*
      Modifica grupo en la tabla categories----------------------------------
      */

      if oTablaFamilias:RecCount() > 0 .and. oTablaFamilias:Find( 1, ::oGrpFam:cCodWeb, .t. )

         oTablaFamilias:Load()

         oTablaFamilias:FieldPut( 3, 0 )
        // oTablaFamilias:FieldPut( 4, ::oFam:nPosInt )
         oTablaFamilias:FieldPut( 5, GetSysDate() )
         oTablaFamilias:FieldPut( 6, GetSysDate() )

         if oTablaFamilias:update()
            ::SetText( "Modificando grupo familia " + Rtrim( ::oGrpFam:cCodGrp ) + Space( 1 ) + AllTrim( ::oGrpFam:cNomGrp ), 3 )
         else
            ::SetText( "Error modificando" + Rtrim( ::oGrpFam:cCodGrp ) + Space( 1 ) + AllTrim( ::oGrpFam:cNomGrp ) + " en tabla categories", 3 )
         end if

      end if

      /*
      Modifica grupo en la tabla categories_description----------------------
      */

      if oTablaFamiliasDesc:RecCount() > 0 .and. oTablaFamiliasDesc:Find( 1, ::oGrpFam:cCodWeb, .t.)

         oTablaFamiliasDesc:Load()

         oTablaFamiliasDesc:FieldPut( 2, ::nLanguage )
         oTablaFamiliasDesc:FieldPut( 3, ::oCon:EscapeStr( ::oGrpFam:cNomGrp ) )

         if !oTablaFamiliasDesc:update()
            ::SetText( "Error modificando" + Rtrim( ::oGrpFam:cCodGrp ) + Space( 1 ) + AllTrim( ::oGrpFam:cNomGrp ) + " en tabla categories_description", 3 )
         end if

      end if

   end if

Return nCodigoWeb

//---------------------------------------------------------------------------//

Method AppendPedido( oDb ) CLASS TComercio

   local oTablaPedidos
   local oTablaPedidosPro
   local oTablaPedidosAtributos
   local oTablaPedidosTotal
   local oTablaPedidosHistory

   if oDb:ExistTable( "orders" )  .and.;
      oDb:ExistTable( "orders_products" ) .and.;
      oDb:ExistTable( "orders_products_attributes" ) .and.;
      oDb:ExistTable( "orders_total" ) .and.;
      oDb:ExistTable( "orders_status_history" )

      oTablaPedidos           := TMSTable():New( oDb, "orders" )
      oTablaPedidosPro        := TMSTable():New( oDb, "orders_products" )
      oTablaPedidosAtributos  := TMSTable():New( oDb, "orders_products_attributes" )
      oTablaPedidosTotal      := TMSTable():New( oDb, "orders_total" )
      oTablaPedidosHistory    := TMSTable():New( oDb, "orders_status_history" )

      /*
      Abrimos las tablas-------------------------------------------------------
      */

      if oTablaPedidos:Open() .and.;
         oTablaPedidosPro:Open() .and.;
         oTablaPedidosAtributos:Open() .and.;
         oTablaPedidosTotal:Open() .and.;
         oTablaPedidosHistory:Open()

         oTablaPedidos:GoTop()
         oTablaPedidosPro:GoTop()
         oTablaPedidosAtributos:GoTop()
         oTablaPedidosTotal:GoTop()
         oTablaPedidosHistory:GoTop()

         ::SetText( "Actualizando Pedidos", 2 )

      /*
      Añadimos pedidos a nuestra tabla-----------------------------------------
      */

         ::AppPedidos( oTablaPedidos, oTablaPedidosPro, oTablaPedidosAtributos, oTablaPedidosTotal, oTablaPedidosHistory )

      else

         ::SetText ( 'No se puede abrir las tablas de pedidos', 1  )

      end if

      oTablaPedidos:Free()
      oTablaPedidosPro:Free()
      oTablaPedidosAtributos:Free()
      oTablaPedidosTotal:Free()
      oTablaPedidosHistory:Free()

   else

      ::SetText( 'No existe la tabla de pedidos', 1 )

   end if

Return ( Self )

//---------------------------------------------------------------------------//

Method GetParentIva() CLASS TComercio

   local nIva     := 0

   if ::oIva:Seek( ::oArt:TipoIva )
      nIva        := ::oIva:cCodWeb
   end if

Return ( nIva )

//---------------------------------------------------------------------------//

Method GetParentFamilia() CLASS TComercio

   local ParentFamilia  := 0

   if ::oGrpFam:Seek( ::oFam:cCodGrp )
      if ::oGrpFam:lPubInt
         ParentFamilia  := ::oGrpFam:cCodWeb
      end if
   end if

Return ( ParentFamilia )

//---------------------------------------------------------------------------//

Method GetParentFabricantes() CLASS TComercio

   local ParenFabricantes  := 0

   if ::oFab:Seek( ::oArt:cCodFab )
      if ::oFab:lPubInt
         ParenFabricantes := ::oFab:cCodWeb
      end if
   end if

Return( ParenFabricantes )

//---------------------------------------------------------------------------//

Method AppendIva( oDb ) CLASS TComercio

   local oTablaIva
   local oTablaIva_rates
   local oTablaZone
   local n

   if oDb:ExistTable( "tax_class" )  .and.;
      oDb:ExistTable( "tax_rates" )  .and.;
      oDb:ExistTable( "geo_zones" )

      oTablaIva            := TMSTable():New( oDb, "tax_class" )
      oTablaIva_rates      := TMSTable():New( oDb, "tax_rates" )
      oTablaZone           := TMSTable():New( oDb, "geo_zones" )

      /*
      Abrimos las tablas-------------------------------------------------------
      */

      if oTablaIva:Open()        .and.;
         oTablaIva_rates:Open()  .and.;
         oTablaZone:Open()

         /*
         Vaciamos las tablas para el proceso global----------------------------
         */

         if ::lSincAll
            oTablaIva:oCmd:ExecDirect(       "TRUNCATE TABLE " + oTablaIva:cName )
            oTablaIva_rates:oCmd:ExecDirect( "TRUNCATE TABLE " + oTablaIva_rates:cName )
            oTablaZone:oCmd:ExecDirect(      "TRUNCATE TABLE " + oTablaZone:cName )
            ::SetText ( 'Tablas de tipos de ' + cImp() + ' borradas corectamente ', 2  )
         end if

         oTablaIva:GoTop()
         oTablaIva_rates:GoTop()
         oTablaZone:GoTop()

         ::SetText ( 'Actualizando los tipos de ' + cImp() + ' de la web: ', 2 )

         /*
         Limpiamos tablas de tax_class
         */

         if oTablaIva:RecCount() > 0

         for n := 1 to oTablaIva:RecCount()

            oTablaIva:Load()

            if ::oIva:SeekInOrd( Str( oTablaIva:GetBuffer( 1 ), 11 ), "cCodWeb" )

               if !::oIva:lPubInt

                  ::SetText( "Borrado registro "  + AllTrim( Str( oTablaIva:GetBuffer( 1 ) ) ) + " de la tabla tax_class", 3 )

                  oTablaIva:Delete()

               end if

            else

               ::SetText( "Borrado registro "  + AllTrim( Str( oTablaIva:GetBuffer( 1 ) ) ) + " de la tabla tax_class", 3 )

               oTablaIva:Delete()

            end if

            oTablaIva:Skip()

         next

         end if

         /*
         Limpiando tabla de tax_rate
         */

         if oTablaIva_rates:RecCount() > 0

         for n := 1 to oTablaIva_rates:RecCount()

            oTablaIva_rates:Load()

            if ::oIva:SeekInOrd( Str( oTablaIva_rates:GetBuffer( 3 ), 11 ), "cCodWeb" )

               if !::oIva:lPubInt

                  ::SetText( "Borrado registro "  + AllTrim( Str( oTablaIva_rates:GetBuffer( 1 ) ) ) + " de la tabla tax_rate", 3 )

                  oTablaIva_rates:Delete()

               end if

            else

               ::SetText( "Borrado registro "  + AllTrim( Str( oTablaIva_rates:GetBuffer( 1 ) ) ) + " de la tabla tax_rate", 3 )

               oTablaIva_rates:Delete()

            end if

            oTablaIva_rates:Skip()

         next

         end if

         /*
         Añado los nuevos tipos de IVA
         */

         ::oIva:GoTop()

         while !::oIva:Eof()

            if ::oIva:lPubInt .and. ( ::oIva:lSndDoc .or. ::lSincAll )

               ::AppIva( oTablaIva, oTablaIva_rates, oTablaZone )

               ::oIva:FieldPutByName( "lSndDoc", .f. )

            end if

            ::oIva:Skip()

         end while

      else

         ::SetText ( 'No se puede abrir las tablas de ' + cImp(), 1  )

      end if

      oTablaIva:Free()
      oTablaIva_rates:Free()
      oTablaZone:Free()

   else

      ::SetText( 'No existen las tablas para el ' + cImp(), 1 )

   end if

Return( self )

//---------------------------------------------------------------------------//

Method GetParentCategories() CLASS TComercio

   local idCategories := 2

   if !Empty( ::oArt:Familia )
      if ::oFam:Seek( ::oArt:Familia )
         if ::oFam:lPubInt
            idCategories := ::oFam:cCodWeb
         end if
      end if
   end if   

Return( idCategories )

//---------------------------------------------------------------------------//

Method GetParentTipoArticulo( oDb ) CLASS TComercio

   local nCodigoWeb
   local oTablaFamilias
   local oTablaFamiliasDesc
   local idCategories            := 0

   if ::oTipArt:Seek( ::oArt:cCodTip ) .and. ::oFam:Seek( ::oArt:Familia )

      if ::oTipArt:lPubInt .and. ( ::oTipArt:lSelect .or. ::lSincAll )

         if oDb:ExistTable( "categories" ) .and. oDb:ExistTable( "categories_description" )

            oTablaFamilias       := TMSTable():New( oDb, "categories" )
            oTablaFamiliasDesc   := TMSTable():New( oDb, "categories_description" )

            if oTablaFamilias:Open() .and. oTablaFamiliasDesc:Open()

               idCategories      := ::lParentTipoArticulo( oTablaFamilias, oTablaFamiliasDesc )
               if Empty( idCategories )

                  /*
                  Añade en la tabla categories de Os---------------------------------------
                  */

                  oTablaFamilias:Blank()
                  oTablaFamilias:FieldPut( 2, cNoPathInt( ::cdImagen ) + "/" + cNoPath( ::oTipArt:cImgTip ) )
                  oTablaFamilias:FieldPut( 3, ::GetParentCategories() )
                  oTablaFamilias:FieldPut( 4, ::oTipArt:nPosInt )
                  oTablaFamilias:FieldPut( 5, GetSysDate() )
                  oTablaFamilias:FieldPut( 6, GetSysDate() )

                  if oTablaFamilias:Insert()

                     ::SetText( "Añadiendo tipo de artículo " + AllTrim( ::GetTipArt() ), 3 )

                     idCategories   := ::oCon:GetInsertId()

                     /*
                     ::oTipArt:fieldPutByName( "cCodWeb", nCodigoWeb )
                     */

                  else

                     ::SetText( "Error insertado" +  AllTrim( ::GetTipArt() ) + " en tabla categories", 3 )

                  end if

                  /*
                  Añadimos la imagen al array para despues subirla-------------------------
                  */

                  ::AddImages( ::oTipArt:cImgTip )

                  /*
                  añade en la tabla categories_description---------------------------------
                  */

                  oTablaFamiliasDesc:Blank()
                  oTablaFamiliasDesc:FieldPut( 1, idCategories )
                  oTablaFamiliasDesc:FieldPut( 2, ::nLanguage )
                  oTablaFamiliasDesc:FieldPut( 3, ::oCon:EscapeStr( ::GetTipArt() ) )

                  if oTablaFamiliasDesc:Insert()
                     ::SetText( "Insertado" + AllTrim( ::GetTipArt() ) + " en tabla products_description", 3 )
                  else
                     ::SetText( "Error insertado" + AllTrim( ::GetTipArt() ) + " en tabla products_description", 3 )
                  end if

               end if

            end if

         end if

      end if

      /*
      Desmarco el tipo de artículo para no subirlo más-------------------------

      ::oTipArt:FieldPutByName( "lSelect", .f. )
      */

   end if

Return( idCategories )

//---------------------------------------------------------------------------//

Method lParentTipoArticulo( oTablaFamilias, oTablaFamiliasDesc )

   local oQuery
   local oQuery2
   local nCategories := 0
   local nCategories2:= 0

   if Empty( ::oFam:cCodWeb )
      return 0
   end if

   oQuery            := TMSQuery():New( ::oCon, 'SELECT * FROM ' + oTablaFamiliasDesc:cName + ' WHERE categories_name = "' + ::oCon:EscapeStr( Rtrim( ::GetTipArt() ) ) + '"' )

   if oQuery:Open()

      if oQuery:RecCount() > 0

         oQuery:GoTop()
         while !oQuery:Eof()

            nCategories       := oQuery:FieldGet( 1 )

            // Nueva consulta -------------------------------------------------

            oQuery2           := TMSQuery():New( ::oCon, 'SELECT * FROM ' + oTablaFamilias:cName + ' WHERE categories_id = ' + Alltrim( Str( nCategories ) ) + ' AND parent_id = ' + Alltrim( Str( ::oFam:cCodWeb ) ) )

            if oQuery2:Open()

               if oQuery2:RecCount() > 0

                  if oQuery2:FieldGet( 1 ) != 0

                     nCategories2   := oQuery2:FieldGet( 1 )

                  end if

               end if

            end if

            oQuery2:Free()

            oQuery2  := nil

            // Salto ----------------------------------------------------------

            oQuery:Skip()

         end while

         nCategories := nCategories2

      else

         nCategories := 0

      end if

   end if

   oQuery:Free()

   oQuery            := nil

/*
   if Empty( nCategories )
      return 0
   end if

   oQuery            := TMSQuery():New( ::oCon, 'SELECT * FROM ' + oTablaFamilias:cName + ' WHERE categories_id = ' + Alltrim( Str( nCategories ) ) + ' AND parent_id = ' + Alltrim( Str( ::oFam:cCodWeb ) ) )
   logwrite( oQuery:cStatement )
   if oQuery:Open()

      if oQuery:RecCount() > 0
         nCategories := oQuery:FieldGet( 1 )
      else
         nCategories := 0
      end if
      logwrite( nCategories )

   end if

   oQuery:Free()

   oQuery            := nil
*/

return ( nCategories )

//---------------------------------------------------------------------------//

Method AppCustomers( oTablaClientes, oTablaClientesDirec, oTablaClientesinfo, oTablaZona ) CLASS TComercio

   local nSpace
   local cClave
   local cConstante        := "00"
   local nCodigoWeb        := 0
   local nCodigoDirec      := 0
   local cFirstName
   local cLastName
   local prueba
   local id_pais
   local id_zona
   local cProvincia

   oTablaClientes:GoTop()
   oTablaClientesDirec:GoTop()
   oTablaZona:GoTop()

   /*
   Busqueda de id_zona e id_countries------------------------------------------
   */

   if ::oCli:nTipCli != 3

      cProvincia     := Upper( SubStr( ::oCli:Provincia, 1, 1 ) ) + Lower( SubStr( ::oCli:Provincia, 2 ) )

      if oTablaZona:RecCount() > 0 .and. !oTablaZona:Find( 4, cProvincia, .t. )

         ::SetText( "Error Provincia no encontrada del Cliente " + Rtrim( ::oCli:Titulo ), 3 )

         return .f.

      else

         oTablaZona:Load()
         id_zona     := oTablaZona:GetBuffer( 1 )
         id_pais     := oTablaZona:GetBuffer( 2 )

      end if

      if ::oCli:cCodWeb == 0

         /*
         Compruebo que cliente contenga dirección------------------------------
         */

         if Empty( ::oCli:Domicilio ) .or. Empty(::oCli:CodPostal ) .or. Empty(::oCli:Poblacion ) .or. Empty(::oCli:Provincia )
            return .f.
         end if

         /*
         Añade Clientes a la tabla customers------------------------------------
         */

         nSpace               := At( " ", ::oCli:Titulo )
         cFirstName           := ::oCon:EscapeStr( SubStr( ::oCli:Titulo, 1, nSpace ) )
         cLastName            := ::oCon:EscapeStr( SubStr( ::oCli:Titulo, nSpace + 1 ) )

         oTablaClientes:Blank()
         oTablaClientes:FieldPut( 3, cFirstName  )
         oTablaClientes:FieldPut( 4, cLastName )
         oTablaClientes:FieldPut( 6, ::oCli:cMeIInt )
         oTablaClientes:FieldPut( 8, ::oCli:Telefono )
         oTablaClientes:FieldPut( 9, ::oCli:Fax )
         oTablaClientes:FieldPut( 10, ( hb_md5( cConstante + Rtrim( ::oCli:cClave ) ) + ":" + cConstante ) )

         if oTablaClientes:Insert()

             ::SetText( "Añadiendo Cliente " + Rtrim( ::oCli:Titulo ), 3 )

             nCodigoWeb       := ::oCon:GetInsertId()

             ::oCli:fieldPutByName( "cCodWeb", nCodigoWeb )

         else
             ::SetText( "Error añadiendo Cliente " + Rtrim( ::oCli:Titulo ) + " en tabla customers", 3 )
         end if

         /*
         Añade Clientes a la tabla Address_book---------------------------------
         */

         oTablaClientesDirec:Blank()
         oTablaClientesDirec:FieldPut( 2,  nCodigoWeb )
         oTablaClientesDirec:FieldPut( 5,  cFirstName )
         oTablaClientesDirec:FieldPut( 6,  cLastName )
         oTablaClientesDirec:FieldPut( 7,  ::oCon:EscapeStr( ::oCli:Domicilio ) )
         oTablaClientesDirec:FieldPut( 9,  ::oCon:EscapeStr( ::oCli:CodPostal ) )
         oTablaClientesDirec:FieldPut( 10, ::oCon:EscapeStr( ::oCli:Poblacion ) )
         oTablaClientesDirec:FieldPut( 11, ::oCon:EscapeStr( ::oCli:Provincia ) )
         oTablaClientesDirec:FieldPut( 12, id_pais )
         oTablaClientesDirec:FieldPut( 13, id_zona )


         if !oTablaClientesDirec:Insert()
            ::SetText( "Error añadiendo Cliente " + Rtrim( ::oCli:Titulo ) + " en tabla Address_book", 3 )
         end if

         nCodigoDirec         := ::oCon:GetInsertId()

         /*
         Añade Codigo de addres_book a customers--------------------------------
         */

         oTablaClientes:Refresh()

         if oTablaClientes:RecCount() > 0 .and. oTablaClientes:Find( 1, nCodigoDirec, .t. )

             oTablaClientes:Load()
             oTablaClientes:FieldPut( 7, nCodigoDirec )
             oTablaClientes:update()

         end if

      else

         /*
         Modifica Clientes en la  tabla customers-------------------------------
         */

         nSpace               := At( " ", ::oCli:Titulo )
         cFirstName           := ::oCon:EscapeStr( SubStr( ::oCli:Titulo, 1, nSpace ) )
         cLastName            := ::oCon:EscapeStr( SubStr( ::oCli:Titulo, nSpace + 1 ) )

         if oTablaClientes:RecCount() > 0 .and. oTablaClientes:Find( 1, ::oCli:cCodWeb, .t. )

            oTablaClientes:Load()
            oTablaClientes:FieldPut( 3, cFirstName  )
            oTablaClientes:FieldPut( 4, cLastName )
            oTablaClientes:FieldPut( 6, ::oCli:cMeIInt )
            oTablaClientes:FieldPut( 10, ( hb_md5( cConstante + Rtrim( ::oCli:cClave ) ) + ":" + cConstante ) )
            oTablaClientes:FieldPut( 8, ::oCli:Telefono )

            if oTablaClientes:update()
               ::SetText( "Modificando cliente " + Rtrim( ::oCli:Titulo ), 3 )
            else
               ::SetText( "Error modificando cliente " + Rtrim( ::oCli:Titulo ) + " en tabla customers", 3 )
            end if
         end if

         /*
         Modifica Clientes en la  tabla Address_book----------------------------
         */

         if oTablaClientesDirec:RecCount() > 0 .and. oTablaClientesDirec:Find( 1, ::oCli:cCodWeb, .t. )

            oTablaClientesDirec:Load()
            oTablaClientesDirec:FieldPut( 5, cFirstName  )
            oTablaClientesDirec:FieldPut( 6, cLastName )
            oTablaClientesDirec:FieldPut( 7, ::oCon:EscapeStr( ::oCli:Domicilio ) )
            oTablaClientesDirec:FieldPut( 9, ::oCon:EscapeStr( ::oCli:CodPostal ) )
            oTablaClientesDirec:FieldPut( 10, ::oCon:EscapeStr( ::oCli:Poblacion ) )
            oTablaClientesDirec:FieldPut( 11, ::oCon:EscapeStr( ::oCli:Provincia ) )
            oTablaClientesDirec:FieldPut( 12, id_pais )
            oTablaClientesDirec:FieldPut( 13, id_zona )

            if !oTablaClientesDirec:update()
               ::SetText( "Error modificando cliente " + Rtrim( ::oCli:Titulo ) + " en tabla Address_book", 3 )
            end if

         end if

      end if

   end if

Return( nCodigoWeb )

//---------------------------------------------------------------------------//

Method AppCustomers_bd( oTablaClientes, oTablaClientesDirec, oTablaZona ) CLASS TComercio

   local n
   local cCodCliente
   local cCodObraCliente
   local cNextcCodObr
   local cLastCli := ""

   ::nTotMeter    := 0

   oTablaClientes:Refresh()
   oTablaClientesDirec:Refresh()

   if oTablaClientes:RecCount() > 0

      for n := 1 to oTablaClientes:RecCount()
         ::nTotMeter += 1
         oTablaClientes:Skip()
      next

   end if

   if !Empty( ::oMeterL )
      ::oMeterL:SetTotal( ::nTotMeter )
   end if

   ::nActualMeterL := 1

   /*
   Añadimos tabla customers de la web en nuestra tabla Clientes
   */

   oTablaClientes:GoTop()

   if oTablaClientes:RecCount() > 0

   for n := 1 to oTablaClientes:RecCount()

      ::MeterParticularText( " Descargando cliente " + AllTrim( Str( ::nActualMeterL ) ) + " de "  + AllTrim( Str( ::nTotMeter ) ) )

      oTablaClientes:Load()

      if !::oCli:SeekInOrd( Str( oTablaClientes:GetBuffer( 1 ), 11 ), "cCodWeb" )

         cLastCli          := dbLast(  ::oCli, 1 )

         ::oCli:Append()
         ::oCli:Blank()

         //::oCli:Cod        := NextKey( Replicate( "0", RetNumCodCliEmp() ), ::oCli:cAlias, "0", RetNumCodCliEmp() )

         ::oCli:Cod        := NextKey( cLastCli, ::oCli:cAlias, "0", RetNumCodCliEmp() )
         ::oCli:Titulo     := if ( uFieldEmpresa( "LAPELNOMB" ), oTablaClientes:GetBuffer( 4 ) + ", " + oTablaClientes:GetBuffer ( 3 ), oTablaClientes:GetBuffer( 3 ) + ", " + oTablaClientes:GetBuffer ( 4 ) )
         ::oCli:Telefono   := oTablaClientes:GetBuffer( 8 )
         ::oCli:Fax        := if( Empty( oTablaClientes:GetBuffer( 9 ) ), "", oTablaClientes:GetBuffer( 9 ) )
         ::oCli:cMeiInt    := oTablaClientes:GetBuffer( 6 )
         ::oCli:cClave     := oTablaClientes:GetBuffer( 10 )
         ::oCli:lPubInt    := .t.
         ::oCli:nTipCli    := 3
         ::oCli:cCodWeb    := oTablaClientes:GetBuffer( 1 )
         ::oCli:lChgPre    := .t.

         if ::oCli:Save()

            ::SetText( "Añadido cliente de la web " + Rtrim( ::oCli:Titulo ), 3 )

         else

            ::SetText( "Error al añadir cliente de la tabla customer en cliente" + Rtrim( ::oCli:Titulo ), 3 )

         end if

      else

         if ::oCli:nTipCli == 3

            ::oCli:Load()

            ::oCli:Titulo     := if ( uFieldEmpresa( "LAPELNOMB" ), oTablaClientes:GetBuffer( 4 ) + ", " + oTablaClientes:GetBuffer ( 3 ), oTablaClientes:GetBuffer( 4 ) + ", " + oTablaClientes:GetBuffer ( 3 ) )
            ::oCli:Telefono   := oTablaClientes:GetBuffer( 8 )
            ::oCli:Fax        := if( Empty( oTablaClientes:GetBuffer( 9 ) ), "", oTablaClientes:GetBuffer( 9 ) )
            ::oCli:cMeiInt    := oTablaClientes:GetBuffer( 6 )
            ::oCli:cClave     := oTablaClientes:GetBuffer( 10 )
            ::oCli:lPubInt    := .t.
            ::oCli:cCodWeb    := oTablaClientes:GetBuffer( 1 )

            if ::oCli:save()

               ::SetText( "Modificando cliente " + Rtrim( ::oCli:Titulo ), 3 )

            else

               ::SetText( "Error al modificar cliente" + Rtrim( ::oCli:Titulo ), 3 )

            end if

         end if

      end if

      if !Empty( oTablaClientes:GetBuffer( 7 ) ) .and. oTablaclientesDirec:Find( 1, oTablaClientes:GetBuffer( 7 ) , .t. )

         oTablaClientesDirec:Load()

         ::oCli:Load()

         ::oCli:Domicilio        := oTablaClientesDirec:GetBuffer( 7 )
         ::oCli:CodPostal        := oTablaClientesDirec:GetBuffer( 9 )
         ::oCli:Poblacion        := oTablaClientesDirec:GetBuffer( 10 )
         if oTablaClientesDirec:Fieldpos( "entry_NIF" ) != 0
            ::oCli:Nif           := oTablaClientesDirec:FieldGetByName( "entry_NIF" )
         end if
         ::oCli:Provincia     := BuscarProvincia( oTablaClientesDirec:GetBuffer( 13 ), oTablaZona )

         if !::oCli:Save()
            ::SetText( "Error al añadir cliente de la tabla Address_Book en cliente" + Rtrim( ::oCli:Titulo ), 3 )
         end if

      end if

      oTablaClientes:Skip()

   next

   end if

   /*
   Añadimos tabla adress_book de la web en nuestra tabla Clientes
   */

   oTablaClientesDirec:GoTop()

   if oTablaClientesDirec:RecCount() > 0

   for n := 1 to oTablaClientesDirec:RecCount()

      oTablaClientesDirec:Load()

      cCodCliente          := BuscarCliente( oTablaclientesDirec:GetBuffer( 2 ), ::oCli )

      if !Empty( cCodCliente )

         cCodObraCliente   := oTablaclientesDirec:GetBuffer( 1 )
         cCodObraCliente   := Str( cCodObraCliente, 11 )

         if ::oObras:SeekInOrd( cCodObraCliente, "cCodWeb" )

            ::oObras:Load()

            ::oObras:cCodCli     := cCodCliente
            ::oObras:cNomObr     := oTablaclientesDirec:GetBuffer( 5 ) + ", " + oTablaclientesDirec:GetBuffer( 6 )
            ::oObras:cDirObr     := oTablaclientesDirec:GetBuffer( 7 )
            ::oObras:cPobObr     := oTablaclientesDirec:GetBuffer( 10 )
            ::oObras:cPrvObr     := BuscarProvincia( oTablaClientesDirec:GetBuffer( 13 ), oTablaZona )
            ::oObras:cPosObr     := oTablaclientesDirec:GetBuffer( 9 )
            ::oObras:cCodWeb     := oTablaclientesDirec:GetBuffer( 1 )
            if oTablaClientesDirec:Fieldpos( "entry_telephone" ) != 0
            ::oObras:cTelObr     := oTablaClientesDirec:FieldGetByName( "entry_telephone" )
            end if

            if !::oObras:Save()
               ::SetText( "Error al modificar dirección " + Rtrim( oTablaclientesDirec:GetBuffer( 7 ) ), 3 )
            end if

         else

            //cNextcCodObr         := NextVal( dbLast( ::oObras, 2, nil, nil, "cCodigo" ) )

            ::oObras:Append()

            ::oObras:cCodCli     := cCodCliente
            ::oObras:cCodObr     := "@" + Alltrim( cCodObraCliente )
            ::oObras:cNomObr     := oTablaclientesDirec:GetBuffer( 5 ) + ", " + oTablaclientesDirec:GetBuffer( 6 )
            ::oObras:cDirObr     := oTablaclientesDirec:GetBuffer( 7 )
            ::oObras:cPobObr     := oTablaclientesDirec:GetBuffer( 10 )
            ::oObras:cPrvObr     := BuscarProvincia( oTablaClientesDirec:GetBuffer( 13 ), oTablaZona )
            ::oObras:cPosObr     := oTablaclientesDirec:GetBuffer( 9 )
            ::oObras:cCodWeb     := oTablaclientesDirec:GetBuffer( 1 )
            if oTablaClientesDirec:Fieldpos( "entry_telephone" ) != 0
            ::oObras:cTelObr     := oTablaClientesDirec:FieldGetByName( "entry_telephone" )
            end if

            if !::oObras:Save()
               ::SetText( "Error al añadir dirección " + Rtrim( oTablaclientesDirec:GetBuffer( 7 ) ), 3 )
            end if

         end if

       end if

      oTablaClientesDirec:Skip()

   next

   end if

Return ( self )

//---------------------------------------------------------------------------//

Function HB_DBCREATETEMP()

Return( nil )

//---------------------------------------------------------------------------//

Method AppPedidos( oTablaPedidos, oTablaPedidosPro, oTablaPedidosAtributos, oTablaPedidosTotal, oTablaPedidosHistory ) CLASS TComercio

   local n
   local n2
   local n3
   local n4
   local cont           := 0
   local dFecha
   local cArticulo
   local nNumeroPedido
   local nNumero
   local cCodArt        := Space( 18 )
   ::nTotMeter          := 0

   /*
   Compruebo datos para el meter-----------------------------------------------
   */

   oTablaPedidos:GoTop()

   if oTablaPedidos:RecCount() > 0

   for n := 1 to oTablaPedidos:RecCount()

      oTablaPedidos:Load()

      if oTablaPedidos:GetBuffer( 39 ) == 1 .and. ::oCli:SeekInOrd( Str( oTablaPedidos:GetBuffer( 2 ), 11 ), "cCodWeb" )
         ::nTotMeter    +=1
      end if

      oTablaPedidos:skip()
   next

   end if

   if !Empty( ::oMeterL )
      ::oMeterL:SetTotal( ::nTotMeter )
   end if

   ::nActualMeterL   := 1

   /*
   Añadimos a la tabla PedCliT------------------------------------------------
   */

   oTablaPedidos:GoTop()
   oTablaPedidosPro:GoTop()
   oTablaPedidosAtributos:GoTop()
   oTablaPedidosTotal:GoTop()
   oTablaPedidosHistory:GoTop()

   if oTablaPedidos:RecCount() > 0

   for n := 1 to oTablaPedidos:RecCount()

      oTablaPedidos:Load()

      if oTablaPedidos:GetBuffer( 39 ) == 1

         if ::oCli:SeekInOrd( Str( oTablaPedidos:GetBuffer( 2 ), 11 ), "cCodWeb" )

            ::MeterParticularText( " Descargando pedidos " + AllTrim( Str( ::nActualMeterL ) ) + " de "  + AllTrim( Str( ::nTotMeter ) ) )

            SET DATE FORMAT "yyyy/mm/dd"
            dFecha                     := Ctod( Left( oTablaPedidos:GetBuffer( 38 ), 10 ) )
            SET DATE FORMAT "dd/mm/yyyy"

            nNumeroPedido              := nNewDoc( ::cSeriePed, ::oPedCliT:cAlias, "nPedCli", 9, ::oCount:cAlias )
            nNumero                    := oTablaPedidos:GetBuffer( 1 )

            ::oPedCliT:Append()

            ::oPedCliT:cSerPed         := ::cSeriePed
            ::oPedCliT:nNumPed         := nNumeroPedido
            ::oPedCliT:cSufPed         := RetSufEmp()
            ::oPedCliT:cCodCli         := ::oCli:Cod
            ::oPedCliT:cCodAlm         := cDefAlm()
            ::oPedCliT:cCodCaj         := cDefCaj()
            ::oPedCliT:cDivPed         := "EUR"
            ::oPedCliT:cNomCli         := oTablaPedidos:GetBuffer( 3 )
            ::oPedCliT:cDirCli         := oTablaPedidos:GetBuffer( 5 )
            ::oPedCliT:cPobCli         := oTablaPedidos:GetBuffer( 7 )
            ::oPedCliT:cPosCli         := oTablaPedidos:GetBuffer( 8 )
            if oTablaPedidos:Fieldpos( "billing_nif" ) != 0
            ::oPedCliT:cDniCli         := oTablaPedidos:FieldGetByName( "billing_nif" )
            end if
            ::oPedCliT:dFecPed         := dFecha
            ::oPedCliT:lInternet       := .t.
            ::oPedCliT:cTimCre         := Time()
            ::oPedCliT:cCodPgo         := BuscarFormaPago( oTablaPedidos:GetBuffer( 32 ), ::oFPago )
            ::oPedCliT:nManObr         := BuscarGastoEnvio( oTablaPedidos:GetBuffer( 1 ), oTablaPedidosTotal )
            ::oPedCliT:cManObr         := "Gasto envio"
            //::oPedCliT:cCodObr         := BuscarDireccion( oTablaPedidos:GetBuffer( 16 ), ::oObras )
            ::oPedCliT:cCodObr         := BuscarDireccion( oTablaPedidos:GetBuffer( "billing_street_address" ), ::oObras, ::oCli:Cod )
            ::oPedCliT:cCodWeb         := oTablaPedidos:GetBuffer( 1 )
            ::oPedCliT:nEstado         := 1
            ::oPedCliT:lSndDoc         := .t.

            /*
            Recoremos la tabla de historicos para sacar el comentario-------------
            */

            oTablaPedidosHistory:GoTop()

            for n4 := 1 to oTablaPedidosHistory:RecCount()

               oTablaPedidosHistory:Load()

               if oTablaPedidosHistory:GetBuffer( 2 ) == nNumero
                  ::oPedCliT:mComent   := oTablaPedidosHistory:GetBuffer( 6 )
               end if

               oTablaPedidosHistory:Skip()

            next

            if ::oPedCliT:save()
               ::SetText( "Añadido pedido de " + Rtrim( ::oPedCliT:cNomCli ), 3 )
            else
               ::SetText( "Error al añadir pedido en la tabla cabecera" + Rtrim( ::oPedCliT:cNomCli ), 3 )
            end if

         end if

         oTablaPedidosPro:GoTop()
         for n2 := 1 to oTablaPedidosPro:RecCount()

            oTablaPedidosPro:Load()

            if oTablaPedidosPro:GetBuffer( 2 ) == nNumero

               cCodArt                    := ::cModelArticulo( oTablaPedidosPro:GetBuffer( 3 ) )

               ::oPedCliL:Append()

               ::oPedCliL:cSerPed         := ::cSeriePed
               ::oPedCliL:nNumPed         := nNumeroPedido
               ::oPedCliL:cSufPed         := RetSufEmp()
               ::oPedCliL:cRef            := cCodArt
               ::oPedCliL:cDetalle        := oTablaPedidosPro:GetBuffer( 5 )
               if Empty( cCodArt )
                  ::oPedCliL:mLngDes      := oTablaPedidosPro:GetBuffer( 5 )
               end if
               ::oPedCliL:nIva            := oTablaPedidosPro:GetBuffer( 8 )
               ::oPedCliL:nPreDiv         := oTablaPedidosPro:GetBuffer( 7 )
            // ::oPedCliL:nCanPed         := oTablaPedidosPro:GetBuffer( 9 )
               ::oPedCliL:nUniCaja        := oTablaPedidosPro:GetBuffer( 9 )

               if ::oArt:SeekInOrd( cCodArt, "Codigo" )

                  ::oPedCliL:lLote        := ::oArt:lLote
                  ::oPedCliL:cLote        := ::oArt:cLote

               end if

               for n3 := 1 to oTablaPedidosAtributos:RecCount()

                  oTablaPedidosAtributos:Load()

                  if oTablaPedidosAtributos:GetBuffer( 2 ) == oTablaPedidosPro:GetBuffer( 2 ) .and. oTablaPedidosAtributos:GetBuffer( 3 ) == oTablaPedidosPro:GetBuffer( 1 )

                     if cont == 0

                        //Primera propiedad

                        if ::oPro:SeekInOrd( oTablaPedidosAtributos:GetBuffer( 4 ), "cDesPro" )

                           ::oPedCliL:cCodPr1      := ::oPro:cCodPro

                           if ::oTblPro:SeekInOrd( ::oPedCliL:cCodPr1 + oTablaPedidosAtributos:GetBuffer( 5 ), "cCodDes" )
                              ::oPedCliL:cValPr1   := ::oTblPro:cCodTbl
                              cont                 := 1
                           end if

                        end if

                     else

                        //Segunda propiedad

                        if ::oPro:SeekInOrd( oTablaPedidosAtributos:GetBuffer( 4 ), "cDesPro" )

                           ::oPedCliL:cCodPr2      := ::oPro:cCodPro

                           if ::oTblPro:SeekInOrd( ::oPedCliL:cCodPr2 + oTablaPedidosAtributos:GetBuffer( 5 ), "cCodDes" )
                              ::oPedCliL:cValPr2   := ::oTblPro:cCodTbl
                           end if

                        end if
                     end if

                  end if

                  oTablaPedidosAtributos:skip()
               next

               if !::oPedCliL:Save()
                  ::SetText( "Error al añadir pedido en la tabla PedCliL" + Rtrim( ::oPedCliL:cNomCli ), 3 )
               end if

            end if

            oTablaPedidosPro:Skip()

         next

      end if

      oTablaPedidos:Skip()

   next

   end if

Return( nil )

//---------------------------------------------------------------------------//

Method AppendImages() CLASS TComercio

   local cImage
   local oFile
   local hSource
   local nBytes
   local cBuffer  := Space( 2000 )
   local nCount   := 0

   ::nTotMeter    := 0

   ::oInt         := TInternet():New()
   ::oFtp         := TFtp():New( ::cHostFtp, ::oInt, ::cUserFtp, ::cPasswdFtp, ::lPassiveFtp )

   if Empty( ::oFtp ) .or. Empty( ::oFtp:hFtp )

      MsgStop( "Imposible conectar al sitio ftp " + ::cHostFtp )

   else

      if !Empty( ::cDImagen )
         ::oFtp:CreateDirectory( ::cDImagen )
         ::oFtp:SetCurrentDirectory( ::cDImagen )
      end if

      ::SetText( "Actualizando imagenes", 2 )

      /*
      Subimos los ficheros de imagenes-----------------------------------------
      */

      ::nTotMeter          := len( ::aImages )
      nCount               := 1

      for each cImage in ::aImages

         ::SetText( "Subiendo imagen " + cNoPath( cImage ), 3 )

         ::MeterParticularText( " Subiendo imagen " + AllTrim( Str( nCount ) ) + " de "  + AllTrim( Str( ::nTotMeter ) ) )

         oFile          := TFtpFile():New( cFileBmpName( cImage ), ::oFtp )
         if !oFile:PutFile( ::oMeterL )
            ::SetText( "Error copiando imagen " + cFileBmpName( cImage ), 3 )
         end if

         nCount            += 1

         oFile:End()

         sysRefresh()

      next

   end if

   if !Empty( ::oInt )
      ::oInt:end()
   end if

   if !Empty( ::oFtp )
      ::oFtp:end()
   end if

Return( nil )

//---------------------------------------------------------------------------//

Method AppendImages_bd() CLASS TComercio

   local cImage
   local aFile
   local cFile
   local oFile
   local hTarget
   local nBytes
   local nTotal         := 0
   local cBuffer        := Space( 2000 )
   local nTotalBytes    := 0
   local nCount         := 1

   ::oInt               := TInternet():New()
   ::oFtp               := TFtp():New( ::cHostFtp, ::oInt, ::cUserFtp, ::cPasswdFtp, ::lPassiveFtp )

   ::nTotMeter          := 0

   if Empty( ::oFtp ) .or. Empty( ::oFtp:hFtp )

      MsgStop( "Imposible conectar al sitio ftp " + ::cHostFtp )

   else

      ::SetText( "Actualizando imagenes", 2 )

      ::oFtp:SetCurrentDirectory( ::cDImagen )

      aFile       := ::oFtp:Directory( "*.*" )

      /*
      Bajamos los ficheros de imagenes-----------------------------------------
      */

      ::nTotMeter    := len( ::aImages ) - 1

      for each cImage in ::aImages

         for each cFile in aFile

         if Upper( cNoPathInt( cImage ) ) == Upper( cFile[ 1 ] )

            nTotal         := 0

            ::SetText( "Bajando imagen " + cFile[ 1 ], 3 )

            ::MeterParticularText( "Descargando imagen " + AllTrim( Str( nCount ) ) + " de "  + AllTrim( Str( ::nTotMeter ) ) )

            hTarget        := fCreate( uFieldEmpresa( "cDirImg" ) + "\" + cFile[ 1 ] )

            oFile          := TFtpFile():New( cFile[ 1 ], ::oFtp ) // ::cDImagen + "/" +
            oFile:OpenRead()

            /*
            Compruebo datos para el meter--------------------------------------
            */

            ::oMeterL:SetTotal( cFile[ 2 ] )

            /*
            Descargo imagen
            */

            while .t. //( nBytes := Len( cBuffer := oFile:Read( 2000 ) ) ) > 0 // .t.

               cBuffer     := oFile:Read()
               nBytes      := Len( cBuffer )

               if nBytes > 0
                  fWrite( hTarget, cBuffer, nBytes )
               else
                  exit
               end if

               nTotal      += nBytes

               ::oMeterL:Set( nTotal )

               sysRefresh()

            end

            fClose( hTarget )

            oFile:End()

            nCount      += 1

         end if

         next

         sysRefresh()

      next

   end if

   if !Empty( ::oInt )
      ::oInt:end()
   end if

   if !Empty( ::oFtp )
      ::oFtp:end()
   end if

Return( nil )

//---------------------------------------------------------------------------//

Method AppendFabricantes_bd( oDb ) CLASS TComercio

   local cCodFab
   local oTablaFabricantes
   local oTablaFabricantes_info
   local n

   if oDb:ExistTable( "manufacturers" )  .and.;
      oDb:ExistTable( "manufacturers_info" )

      oTablaFabricantes           := TMSTable():New( oDb, "manufacturers" )
      oTablaFabricantes_info      := TMSTable():New( oDb, "manufacturers_info" )

      /*
      Abrimos las tablas-------------------------------------------------------
      */

      if oTablaFabricantes:Open() .and.;
         oTablaFabricantes_info:Open()

         oTablaFabricantes:GoTop()
         oTablaFabricantes_info:GoTop()

         /*
         Añadimos fabircantes de oscommerce a nuestras tablas
         */

         ::SetText( "Tabla de fabricantes ", 2 )

         ::AppFabricantes_bd( oTablaFabricantes, oTablaFabricantes_info )

      else

         ::SetText ( 'No se puede abrir las tablas de fabricante', 1  )

      end if

      oTablaFabricantes:Free()
      oTablaFabricantes_info:Free()

   else

      ::SetText( 'No existe la tabla de fabricantes', 1 )

   end if

Return( nil )

//---------------------------------------------------------------------------//

Method AppendFabricantes( oDb ) CLASS TComercio

   local cCodFab
   local oTablaFabricantes
   local oTablaFabricantes_info
   local n

   ::nTotMeter    := 0

   if oDb:ExistTable( "manufacturers" )  .and.;
      oDb:ExistTable( "manufacturers_info" )

      oTablaFabricantes           := TMSTable():New( oDb, "manufacturers" )
      oTablaFabricantes_info      := TMSTable():New( oDb, "manufacturers_info" )

      /*
      Abrimos las tablas-------------------------------------------------------
      */

      if oTablaFabricantes:Open() .and.;
         oTablaFabricantes_info:Open()

         /*
         Vaciamos las tablas para el proceso global----------------------------
         */

         if ::lSincAll
            oTablaFabricantes:oCmd:ExecDirect( "TRUNCATE TABLE " + oTablaFabricantes:cName )
            oTablaFabricantes_info:oCmd:ExecDirect( "TRUNCATE TABLE " + oTablaFabricantes_info:cName )
            ::SetText ( 'Tablas de fabricantes borradas corectamente ', 2  )
         end if

         oTablaFabricantes:GoTop()
         oTablaFabricantes_info:GoTop()

         ::SetText ( 'Actualizando Fabricantes de la web: ', 2 )

      /*
      Limpiamo la tabla manufacturers de oscomerce
      */

         if oTablaFabricantes:RecCount() > 0

         for n := 1 to oTablaFabricantes:RecCount()

            oTablaFabricantes:Load()

            if ::oFab:SeekInOrd( Str( oTablaFabricantes:GetBuffer( 1 ), 11 ), "cCodWeb" )

               if !::oFab:lPubInt

                  ::SetText( "Borrado registro "  + AllTrim( oTablaFabricantes:GetBuffer( 2 ) ) + " de la tabla manufacturers", 3 )

                  oTablaFabricantes:Delete()

               end if

            else

               ::SetText( "Borrado registro "  + AllTrim( oTablaFabricantes:GetBuffer( 2 ) ) + " de la tabla manufacturers", 3 )

               oTablaFabricantes:Delete()

            end if

            oTablaFabricantes:Skip()

         next

         end if

         /*
         Limpiamo la tabla manufacturers_info de oscomerce
         */

         if oTablaFabricantes_info:RecCount() > 0

         for n := 1 to oTablaFabricantes_info:RecCount()

            oTablaFabricantes_info:Load()

            if !::oFab:SeekInOrd( Str( oTablaFabricantes_info:GetBuffer( 1 ), 11 ), "cCodWeb" )

               ::SetText( "Borrado registro "  + AllTrim( Str( oTablaFabricantes_info:GetBuffer( 2 ) ) ) + " de la tabla manufacturers_info", 3 )

               oTablaFabricantes_info:Delete()

               ::oFab:fieldPutByName( "cCodWeb", 0 )

            end if
            oTablaFabricantes_info:Skip()

         next

         end if

         /*
         Busco cuantos registros voy a modificar-------------------------------
         */

         ::oFab:GoTop()

         while !::oFab:Eof()

            if ::oFab:lPubInt .and. ::oFab:lSndDoc
               ::nTotMeter    += 1
            end if

            ::oFab:Skip()

         end while

         ::oMeterL:SetTotal( ::nTotMeter )
         ::nActualMeterL := 1

       /*
       Añadimos Fabricantes
       */
         ::oFab:GoTop()

         while !::oFab:Eof()

            if ::oFab:lPubInt .and. ::oFab:lSndDoc
               ::MeterParticularText( " Actualizando fabricantes " + AllTrim( Str( ::nActualMeterL ) ) + " de "  + AllTrim( Str( ::nTotMeter ) ) )
               ::AppFabricantes( oTablaFabricantes, oTablaFabricantes_info )
            end if

            ::oFab:load()
            ::oFab:lSndDoc  := .f.

            if !::oFab:Save()
               ::SetText( "Error modificando estado de fabricante", 3 )
            end if

            ::oFab:Skip()

         end while

      else

         ::SetText ( 'No se puede abrir las tablas de fabricante', 1  )

      end if

      oTablaFabricantes:Free()
      oTablaFabricantes_info:Free()

   else

      ::SetText( 'No existe la tabla de fabricantes', 1 )

   end if

Return( nil )

//---------------------------------------------------------------------------//

Method AppFabricantes_bd( oTablaFabricantes, oTablaFabricantes_info ) CLASS TComercio

   local cCodWeb
   local cNombre
   local cImagen
   local url
   local n

   ::nTotMeter       := 0

   /*
   Compruebo datos para el meter-----------------------------------------------
   */

   oTablaFabricantes:GoTop()

   if oTablaFabricantes:RecCount() > 0

      for n := 1 to oTablaFabricantes:RecCount()

         ::nTotMeter    += 1

         oTablaFabricantes:skip()

      next

   end if

   ::oMeterL:SetTotal( ::nTotMeter )
   ::nActualMeterL   := 1

   /*
   Descargo los datos desde oscommerce-----------------------------------------
   */

   oTablaFabricantes:GoTop()

   if oTablaFabricantes:RecCount() > 0

   for n := 1 to oTablaFabricantes:RecCount()

      oTablaFabricantes:Load()

      cCodWeb              := oTablaFabricantes:GetBuffer( 1 )
      cNombre              := oTablaFabricantes:GetBuffer( 2 )
      cImagen              := oTablaFabricantes:GetBuffer( 3 )

      oTablaFabricantes_info:GoTop()

      if oTablaFabricantes_info:Find( 1, cCodWeb , .t. )
         oTablaFabricantes_info:Load()
         url               := oTablaFabricantes_info:GetBuffer( 3 )
      end if

      ::MeterParticularText( " Descargando fabricante " + AllTrim( Str( ::nActualMeterL ) ) + " de "  + AllTrim( Str( ::nTotMeter ) ) )

      if !::oFab:SeekInOrd( Str( cCodWeb, 11 ), "cCodWeb" )

         ::oFab:Append()

         ::oFab:cCodFab       := RJust( NextVal( DbLast( ::oFab:cAlias , 1, nil, nil, 1 ) ), "0", 3 )
         ::oFab:cNomFab       := cNombre
         ::oFab:lPubInt       := .t.
         ::oFab:cImgLogo      := uFieldEmpresa( "cDirImg" ) + "\" + cNoPathInt( cImagen )
         ::oFab:cCodWeb       := cCodWeb
         ::oFab:cUrlFab       := url

         if ::oFab:save()

            ::SetText( "Añadido fabricante " + Rtrim( cNombre ), 3 )

            ::AddImages( cImagen )

         else

            ::SetText( "Error al añadir fabricante" + Rtrim( cNombre ), 3 )

         end if

      else

         ::oFab:Load()

         ::oFab:cNomFab       := cNombre
         ::oFab:lPubInt       := .t.
         ::oFab:cImgLogo      := uFieldEmpresa( "cDirImg" ) + "\" + cNoPathInt( cImagen )
         ::oFab:cCodWeb       := cCodWeb
         ::oFab:cUrlFab       := url

         if ::oFab:save()

            ::SetText( "Modificando fabricante " + Rtrim( cNombre ), 3 )

            ::AddImages( cImagen )

         else

            ::SetText( "Error al modificar fabricante" + Rtrim( cNombre ), 3 )

         end if

      end if

   oTablaFabricantes:skip()

   next

   end if

Return( nil )

//---------------------------------------------------------------------------//

Method AppFabricantes( oTablaFabricantes, oTablaFabricantes_info ) CLASS TComercio

   local cCodFab

   oTablaFabricantes:GoTop()
   oTablaFabricantes_info:GoTop()

   if ::oFab:cCodWeb == 0 .or. ::lSincAll

   /*
   Añade en la tabla manufacturers de Os
   */

      oTablaFabricantes:Blank()
      oTablaFabricantes:FieldPut( 2, ::oCon:EscapeStr( ::oFab:cNomFab ) )
      oTablaFabricantes:FieldPut( 3, cNoPathInt( ::cdImagen ) + "/" + cNoPath( ::oFab:cImgLogo))
      oTablaFabricantes:FieldPut( 4, GetSysDate() )
      oTablaFabricantes:FieldPut( 5, GetSysDate() )

      if oTablaFabricantes:Insert()

         ::SetText( "Añadiendo fabricante " + AllTrim( ::oFab:cNomFab ), 3 )

         ::AddImages( ::oFab:cImgLogo )

         cCodFab           := ::oCon:GetInsertId()

         ::oFab:fieldPutByName( "cCodWeb", cCodFab )

      else

         ::SetText( "Error insertado"  + AllTrim( ::oFab:cNomFab ) + " en tabla manufacturers", 3 )

      end if

    /*
   Añade en la tabla manufacturers_info de Os
   */

      oTablaFabricantes_info:Blank()
      oTablaFabricantes_info:FieldPut( 1, cCodFab )
      oTablaFabricantes_info:FieldPut( 2, ::nLanguage )
      oTablaFabricantes_info:FieldPut( 3, ::oFab:cUrlFab )

      if ! oTablaFabricantes_info:Insert()

         ::SetText( "Error insertado"  + AllTrim( ::oFab:cNomFab ) + " en tabla manufacturers_info", 3 )

      end if

   else
   /*
   Modificar tabla manufacturers de oscomerce
   */
        if oTablaFabricantes:RecCount() > 0 .and. oTablaFabricantes:Find( 1, ::oFab:cCodWeb, .t. )

            oTablaFabricantes:Load()
            oTablaFabricantes:FieldPut( 2, ::oCon:EscapeStr( ::oFab:cNomFab ) )
            oTablaFabricantes:FieldPut( 3, cNoPathInt( ::cdImagen ) + "/" + cNoPath( ::oFab:cImgLogo))
            oTablaFabricantes:FieldPut( 4, GetSysDate() )
            oTablaFabricantes:FieldPut( 5, GetSysDate() )

            if oTablaFabricantes:update()

               ::SetText( "Modificando fabricante " + Rtrim( ::oFab:cNomFab ), 3 )

               ::AddImages( ::oFab:cImgLogo )

            else

               ::SetText( "Error modificando fabricante " + Rtrim( ::oFab:cNomFab ) + " en tabla manufacturers", 3 )

            end if

         end if
   /*
   Modificar tabla manufacturers_info de oscomerce
   */

        if oTablaFabricantes_info:RecCount() > 0 .and. oTablaFabricantes_info:Find( 1, ::oFab:cCodWeb, .t. )

            oTablaFabricantes_info:Load()
            oTablaFabricantes_info:FieldPut( 1, cCodFab )
            oTablaFabricantes_info:FieldPut( 2, ::nLanguage )
            oTablaFabricantes_info:FieldPut( 3, ::oFab:cUrlFab )


            if !oTablaFabricantes:update()
               ::SetText( "Error modificando fabricante " + Rtrim( ::oFab:cNomFab ) + " en tabla manufacturers_info", 3 )
            end if

       end if

   end if

Return( nil )

//---------------------------------------------------------------------------//

Method AppIva( oTablaIva, oTablaIva_rates, oTablaZone ) CLASS TComercio

   local nCodigo
   local nCodigoZona       := 0

   oTablaIva:GoTop()
   oTablaIva_rates:GoTop()
   oTablaZone:GoTop()

   if oTablaZone:RecCount() > 0 .and. oTablaZone:Find( 2, "España" , .t.)
      nCodigoZona          := oTablaZone:FieldGet( 1 )
   end if

   /*
   Añade en la tabla tax_class de OsCommerce-----------------------------------
   */

   if ::oIva:cCodWeb == 0 .or. ::lSincAll

      oTablaIva:Blank()
      oTablaIva:FieldPut( 2, ::oCon:EscapeStr( ::oIva:DescIva ) )
      oTablaIva:FieldPut( 3, ::oIva:TPIva )
      oTablaIva:FieldPut( 4, GetSysDate() )
      oTablaIva:FieldPut( 5, GetSysDate() )

      if oTablaIva:Insert()

         ::SetText( "Añadiendo " + cImp() + Space(1) + AllTrim( ::oIva:DescIva ), 3 )

         nCodigo           := ::oCon:GetInsertId()

         ::oIva:fieldPutByName( "cCodWeb", nCodigo )

      else

         ::SetText( "Error insertado"  + AllTrim( ::oIva:DescIva  ) + " en tabla tax_class", 3 )

      end if

      /*
      Añade en la tabla tax_rates de OsCommerce-----------------------------------
      */

      oTablaIva:Blank()
      oTablaIva_rates:FieldPut( 2, nCodigoZona )
      oTablaIva_rates:FieldPut( 3, nCodigo )
      oTablaIva_rates:FieldPut( 4, 1 )
      oTablaIva_rates:FieldPut( 5, ::oIva:TpIva )
      oTablaIva_rates:FieldPut( 6, ::oCon:EscapeStr( ::oIva:DescIva ) )
      oTablaIva_rates:FieldPut( 7, GetSysDate() )
      oTablaIva_rates:FieldPut( 8, GetSysDate() )

      if !oTablaIva_rates:Insert()
         ::SetText( "Error insertado"  + AllTrim( ::oIva:DescIva  ) + " en tabla tax_class", 3 )
      end if

   else

   /*
   Modificar la tabla tax_class de oscomerce
   */

      if oTablaIva:RecCount() > 0 .and. oTablaIva:Find( 1, ::oIva:cCodWeb, .t. )

         oTablaIva:Load()
         oTablaIva:FieldPut( 2, ::oCon:EscapeStr( ::oIva:DescIva ) )
         oTablaIva:FieldPut( 3, ::oIva:TPIva )
         oTablaIva:FieldPut( 4, GetSysDate() )
         oTablaIva:FieldPut( 5, GetSysDate() )

         if oTablaIva:Update()
            ::SetText( "Modificando " + cImp() + Space(1) + AllTrim( ::oIva:DescIva ) + "en la tabla tax_class", 3 )
         else
            ::SetText( "Error modificando " + cImp() + Space(1) + AllTrim( ::oIva:DescIva ) + "en la tabla tax_class", 3 )
         end if

      end if

      /*
      Modificar la tabla tax_class de oscomerce--------------------------------
      */

      if oTablaIva_rates:RecCount() > 0 .and. oTablaIva_rates:Find( 3, ::oIva:cCodWeb, .t. )

         oTablaIva_rates:Load()
         oTablaIva_rates:FieldPut( 2, nCodigoZona )
         oTablaIva_rates:FieldPut( 4, 1 )
         oTablaIva_rates:FieldPut( 5, ::oIva:TpIva )
         oTablaIva_rates:FieldPut( 6, ::oCon:EscapeStr( ::oIva:DescIva ) )
         oTablaIva_rates:FieldPut( 7, GetSysDate() )
         oTablaIva_rates:FieldPut( 8, GetSysDate() )

         if oTablaIva_rates:Update()
            ::SetText( "Modificando " + cImp() + Space(1) + AllTrim( ::oIva:DescIva ) + "en la tabla tax_rates", 3 )
         else
            ::SetText( "Error modificando " + cImp() + Space(1) + AllTrim( ::oIva:DescIva ) + "en la tabla tax_rates", 3 )
         end if

      end if

   end if

Return( nil )

//---------------------------------------------------------------------------//

 Method AppZone( oTablaZone, oTablaGeoZone ) CLASS TComercio

   Local aNombre
   Local aZona
   Local aZona2
   Local aCodigo  := {}

   Local cNombre
   Local cZona
   Local cZona2
   Local cCodigo

   oTablaZone:GoTop()
   oTablaGeoZone:GoTop()

   aNombre :={ "España",;
               "Islas" }

   aZona   :={ 130,;
               131,;
               132,;
               133,;
               134,;
               135,;
               136,;
               137,;
               138,;
               139,;
               140,;
               141,;
               142,;
               143,;
               144,;
               146,;
               147,;
               148,;
               149,;
               150,;
               151,;
               152,;
               153,;
               154,;
               155,;
               156,;
               158,;
               159,;
               160,;
               161,;
               162,;
               164,;
               165,;
               166,;
               167,;
               168,;
               169,;
               171,;
               172,;
               173,;
               174,;
               175,;
               176,;
               177,;
               178,;
               179,;
               180,;
               181 }

   aZona2 := { 145,;
               163,;
               170 }

    /*
    Añade en la tabla Geo_zone de Os
    */

    for each cNombre in aNombre

       oTablaZone:Blank()
       oTablaZone:FieldPut( 2, ::oCon:EscapeStr( cNombre ) )
       oTablaZone:FieldPut( 3, "Peninsula" )
       oTablaZone:FieldPut( 4, getsysdate() )
       oTablaZone:FieldPut( 5, getsysdate() )

       if oTablaZone:Insert()

          ::SetText( "Añadiendo Zona " + cNombre, 2 )

          aAdd ( aCodigo, ::oCon:GetInsertId() )

       else
          ::SetText( "Error añadiendo Zona " + cNombre, 2 )
       end if

    next

    /*
    Añadir a tabla Zone_to_geo_zones la zona 1
    */

    for each cZona in aZona

       oTablaGeoZone:Blank()
       oTablaGeoZone:FieldPut( 2, 195 )
       oTablaGeoZone:FieldPut( 3, cZona )
       oTablaGeoZone:FieldPut( 4, aCodigo[1] )
       oTablaGeoZone:FieldPut( 5, getsysdate() )
       oTablaGeoZone:FieldPut( 6, getsysdate() )

       if oTablaGeoZone:Insert()

          ::SetText( "Añadiendo Geo Zona " + str( cZona ), 2 )

       else
          ::SetText( "Error añadiendo Geo Zona " + str( cZona ), 2 )
       end if

    next

    /*
    Añadir a tabla Zone_to_geo_zones la zona 2
    */

    for each cZona2 in aZona2

       oTablaGeoZone:Blank()
       oTablaGeoZone:FieldPut( 2, 195 )
       oTablaGeoZone:FieldPut( 3, cZona2 )
       oTablaGeoZone:FieldPut( 4, aCodigo[2] )
       oTablaGeoZone:FieldPut( 5, getsysdate() )
       oTablaGeoZone:FieldPut( 6, getsysdate() )

       if oTablaGeoZone:Insert()

          ::SetText( "Añadiendo Geo Zona 2 " + str( cZona2 ), 2 )

       else
          ::SetText( "Error añadiendo Geo Zona 2 " + str( cZona2 ), 2 )
       end if

    next

 Return( nil )

 //--------------------------------------------------------------------------//

 Method AutoInt( oTabla ) CLASS TComercio

   local Codigo     :=1
   local n
   local Ultimo

   oTabla:Refresh()

   if oTabla:RecCount() > 0

   for n := 1 to oTabla:RecCount()

      oTabla:Load()

      if oTabla:GetBuffer( 1 )>= Codigo
      Codigo := oTabla:GetBuffer( 1 )
      end if

   oTabla:skip()

   next

   end if

   Codigo += 1

Return( Codigo )

//---------------------------------------------------------------------------//

Method AppendIva_bd( oDb ) CLASS TComercio

   local oTablaIva

   if oDb:ExistTable( "tax_class" )

      oTablaIva            := TMSTable():New( oDb, "tax_class" )

      /*
      Abrimos la tabla---------------------------------------------------------
      */

      if oTablaIva:Open()

         oTablaIva:GoTop()

         ::SetText ( 'Tipos de ' + cImp() + ': ', 2 )

         ::oIva:GoTop()

         ::AppIva_bd( oTablaIva )

      else

         ::SetText ( 'No se puede abrir las tablas de ' + cImp(), 1  )

      end if

      oTablaIva:Free()

   else

      ::SetText( 'No existen las tablas para el ' + cImp(), 1 )

   end if

Return ( Self )

//---------------------------------------------------------------------------//

Method AppIva_bd( oTablaIva ) CLASS TComercio

   local cCodWeb           := 0
   local cNombre
   local cDescrip
   local n
   local n2

   ::nTotMeter             := 0

   /*
   Compruebo datos para el meter-----------------------------------------------
   */

   oTablaIva:GoTop()

   if oTablaIva:RecCount() > 0

   for n := 1 to oTablaIva:RecCount()

      ::nTotMeter          += 1

      oTablaIva:skip()

   next

   end if

   ::oMeterL:SetTotal( ::nTotMeter )
   ::nActualMeterL         := 1

   /*
   Modifico los datos correspondientes-----------------------------------------
   */

   oTablaIva:GoTop()

   if oTablaIva:RecCount() > 0

   for n := 1 to oTablaIva:RecCount()

      oTablaIva:Load()

      cCodWeb              := oTablaIva:GetBuffer( 1 )
      cNombre              := oTablaIva:GetBuffer( 2 )
      cDescrip             := oTablaIva:GetBuffer( 3 )

      /*
      Guardo IVA en nuestra tabla----------------------------------------------
      */

      ::MeterParticularText( " Descargando tipos de " + cImp() + Space( 1 ) + AllTrim( Str( ::nActualMeterL ) ) + " de "  + AllTrim( Str( ::nTotMeter ) ) )


      if ::oIva:SeekInOrd( Str( cCodWeb, 11 ), "cCodWeb" )

         ::oIva:Load()

         ::oIva:DescIva    := cNombre
         ::oIva:TPIva      := Val( cDescrip )

         if ::oIva:save()
            ::SetText( "Modificando " + cImp() + Space(1) + Rtrim( cNombre ), 3 )
         else
            ::SetText( "Error al modificar " + cImp() + Space(1) + Rtrim( cNombre ), 3 )
         end if

      else

         ::oIva:Append()

         ::oIva:Tipo       := Alltrim( Str( cCodWeb ) )
         ::oIva:DescIva    := cNombre
         ::oIva:TPIva      := Val( cDescrip )
         ::oIva:cCodWeb    := cCodWeb

         if ::oIva:save()
            ::SetText( "Añadido " + cImp() + Space(1) + Rtrim( cNombre ), 3 )
         else
            ::SetText( "Error al añadir " + cImp() + Space(1) + Rtrim( cNombre ), 3 )
         end if

      end if

      oTablaIva:skip()

   next

   end if

return .t.

//---------------------------------------------------------------------------//

Method EstadoPedidos( oDb ) Class TComercio

   local oTablaPedidos
   local oTablaPedidosStatus

   ::nTotMeter := 0

   if oDb:ExistTable( "orders" )  .and.;
      oDb:ExistTable( "orders_status_history" )

      oTablaPedidos        := TMSTable():New( oDb, "orders" )
      oTablaPedidosStatus  := TMSTable():New( oDb, "orders_status_history" )

      /*
      Abrimos las tablas-------------------------------------------------------
      */

      if oTablaPedidos:Open() .and. oTablaPedidosStatus:Open()

         oTablaPedidos:GoTop()
         oTablaPedidosStatus:GoTop()

         /*
         Compruebo datos para el meter-----------------------------------------
         */

         ::oPedCliT:GoTop()
         while !::oPedCliT:Eof()

            if ::oPedCliT:lInternet .and. ::oPedCliT:lSndDoc

               ::nTotMeter += 1

            end if

         ::oPedCliT:Skip()

         end while

         ::oMeterL:SetTotal( ::nTotMeter )
         ::nActualMeterL   := 1

         /*
         Modifico los datos y tablas correspondientes--------------------------
         */

         ::oPedCliT:GoTop()
         while !::oPedCliT:Eof()

            if ::oPedCliT:lInternet .and. ::oPedCliT:lSndDoc

               ::MeterParticularText( "Actualizando estado de pedidos " + AllTrim( Str( ::nActualMeterL ) ) + " de " + AllTrim( Str( ::nTotMeter ) ) )

               ::CambiarEPedidos( oTablaPedidos, oTablaPedidosStatus )

               ::oPedCliT:load()
               ::oPedCliT:lSndDoc := .f.

               if !::oPedCliT:Save()
                  ::SetText( "Error modificando estado de pedido", 3 )
               end if

            end if

         ::oPedCliT:Skip()

         end while

      else

         ::SetText ( 'No se puede abrir tablas para actualizar estados de pedidos', 1  )

      end if

      oTablaPedidos:Free()
      oTablaPedidosStatus:Free()

   else

      ::SetText( 'No existe las tablas para los estados de pedidos', 1 )

   end if

Return ( self )

//---------------------------------------------------------------------------//

Method CambiarEPedidos( oTablaPedidos, oTablaPedidosStatus ) Class TComercio

   local nEstado     := 0

   oTablaPedidos:GoTop()
   oTablaPedidosStatus:GoTop()

   if oTablaPedidos:Find( 1, ::oPedCliT:cCodWeb , .t. )

      oTablaPedidos:Load()

      if ::oPedCliT:nEstado == 1

         nEstado                    := 2

         oTablaPedidos:FieldPut( 39, 2 )
         oTablaPedidos:update()

         if ::oPedCliI:SeekInOrd( ::oPedCliT:cSerPed + Str( ::oPedCliT:nNumPed ) + ::oPedCliT:cSufPed , "lSndWeb" )

            while !::oPedCliI:Eof()

               oTablaPedidosStatus:Blank()
               oTablaPedidosStatus:FieldPut( 2, ::oPedCliT:cCodWeb )
               oTablaPedidosStatus:FieldPut( 3, nEstado )
               oTablaPedidosStatus:FieldPut( 4, GetSysDate() )
               oTablaPedidosStatus:FieldPut( 5, 1 )
               oTablaPedidosStatus:FieldPut( 6, ::oPedCliI:mDesInc )

               if !oTablaPedidosStatus:Insert()
                  ::SetText( "Error insertando historico de pedido " + ::oPedCliT:cCodWeb , 3 )
               end if

               ::oPedCliI:load()
               ::oPedCliI:lSndWeb   := .t.

               if !::oPedCliI:Save()
                  ::SetText( "Error modificando historico de pedido", 3 )
               end if

            ::oPedCliI:Skip()

            end while

         end if

      else

         nEstado     := 3

         oTablaPedidos:FieldPut( 39, 3 )
         oTablaPedidos:Update()

         oTablaPedidosStatus:Blank()
         oTablaPedidosStatus:FieldPut( 2, ::oPedCliT:cCodWeb )
         oTablaPedidosStatus:FieldPut( 3, nEstado )
         oTablaPedidosStatus:FieldPut( 4, GetSysDate() )
         oTablaPedidosStatus:FieldPut( 5, 1 )
         oTablaPedidosStatus:FieldPut( 6, "Pedido enviado" )

         if !oTablaPedidosStatus:Insert()
            ::SetText( "Error insertando historico de pedido " + ::oPedCliT:cCodWeb , 3 )
         end if

      end if

   end if

Return .t.

//---------------------------------------------------------------------------//

Method AddImages( cImage ) CLASS TComercio

   if aScan( ::aImages, cImage ) == 0
      aAdd( ::aImages, cImage )
   end if

Return ( ::aImages )

//---------------------------------------------------------------------------//

METHOD ChangeSincAll()

   if ::lSincAll

      ::lArticulos      := .t.
      ::lFamilias       := .t.
      ::lPedidos        := .t.
      ::lFabricantes    := .t.
      ::lIva            := .t.

      ::oArticulos:Disable()
      ::oPedidos:Disable()
      ::oTipIva:Disable()

   else

      ::oArticulos:Enable()
      ::oPedidos:Enable()
      ::oTipIva:Enable()

   end if

Return .t.

//---------------------------------------------------------------------------//

Method cModelArticulo( nId )

   local oQuery
   local cModel      := ""

   oQuery            := TMSQuery():New( ::oCon, 'SELECT * FROM ' + 'products' + ' WHERE products_id = "' + Alltrim( Str( nId ) ) + '"' )
   if oQuery:Open()

      if oQuery:RecCount() > 0
         cModel      := oQuery:FieldGet( 3 )
      end if

   end if

   oQuery:Free()

   oQuery            := nil

return ( cModel )

//---------------------------------------------------------------------------//

Method GetTipArt() CLASS TComercio

   local cTipArt      := ""

   if !Empty ( ::oTipArt:cNomInt )
      cTipArt  := ::oTipArt:cNomInt
   else
      cTipArt  := ::oTipArt:cNomTip
   end if

return ( cTipArt )

//---------------------------------------------------------------------------//

Method GetPropArt() CLASS TComercio

   local cPropArt      := ""

   if !Empty  ( ::oPro:cNomInt )
      cPropArt  := ::oPro:cNomInt
   else
      cPropArt  := ::oPro:cDesPro
   end if

return ( cPropArt )

//---------------------------------------------------------------------------//


Function SetAutoRecive()

   if Empty( oComercio )
      oComercio   := TComercio():New()
   end if

   if !Empty( oComercio )           .and. ;
      !Empty( oComercio:cHost )     .and. ;
      !Empty( oComercio:cUser )     .and. ;
      !Empty( oComercio:cPasswd )   .and. ;
      !Empty( oComercio:cDbName )   .and. ;
      ( oComercio:nSecondTimer != 0 )

      oTimer      := TTimer():New( oComercio:nSecondTimer, {|| oComercio:AutoRecive() } )
      oTimer:Activate()

   end if

Return( nil )

//---------------------------------------------------------------------------//

Function KillAutoRecive()

   if !Empty( oTimer )
      oTimer:End()
   end if

   oTimer         := nil
   oComercio      := nil

Return( nil )

//---------------------------------------------------------------------------//

Static Function BuscarCodFam( cCodigo, oFam )

   local cCodFamilia

   if oFam:SeekInOrd( Str( cCodigo, 11 ), "cCodWeb" )

      cCodFamilia       := oFam:cCodfam

   end if

Return cCodFamilia

//---------------------------------------------------------------------------//

Method GetLanguage( oDb )

   local cCodLanguage
   local oTablaLanguages

   /*
   Abrimos la tablas ----------------------------------------------------------
   */

   if oDb:ExistTable( "languages" )

      oTablaLanguages                        := TMSTable():New( oDb, "languages" )

      /*
      Abrimos las tablas-------------------------------------------------------
      */

      if oTablaLanguages:Open()
         /*
         Ejecutamos la sentencia SQL ------------------------------------------
         */

         if oTablaLanguages:RecCount() > 0 .and. oTablaLanguages:Find( 5, 'espanol', .f. )
            oTablaLanguages:Load()
            cCodLanguage   := oTablaLanguages:GetBuffer( 1 )
         end if

      end if

   end if

Return cCodLanguage

//---------------------------------------------------------------------------//

Static Function BuscarCodPro( cCodigo, oPro )

   local cCodPro

   if oPro:SeekInOrd( Str( cCodigo, 11 ), "cCodWeb" )

      cCodPro       := oPro:cCodPro

   end if

Return cCodPro

//---------------------------------------------------------------------------//

Static Function BuscarCodIva( cCodigo, oIva )

   local cCodIva

   if oIva:SeekInOrd( Str( cCodigo, 11 ), "cCodWeb" )
      cCodIva           := oIva:Tipo
   end if

Return cCodIva

//---------------------------------------------------------------------------//

Static Function BuscarCodFab( cCodigo, oFab )

   local cCodFab

   if oFab:SeekInOrd( Str( cCodigo, 11 ), "cCodWeb" )

      cCodFab           := oFab:cCodFab

   end if

Return cCodFab

//---------------------------------------------------------------------------//

Static Function BuscarProvincia( cCodZona, oTablaZona )

   local cNomZona := ""

   if ValType( cCodZona ) == "N" .and. cCodZona != 0

      if oTablaZona:Find( 1, cCodZona , .t. )

         oTablaZona:load()

         cNomZona    := oTablaZona:GetBuffer( 4 )

      end if

   end if

Return cNomZona

//---------------------------------------------------------------------------//

Static Function BuscarCliente( cCodCli, oCli )

   local cCodigo := ""

   if oCli:SeekInOrd( Str( cCodCli, 11 ), "cCodWeb" )
      cCodigo    := oCli:Cod
   end if

Return cCodigo

//---------------------------------------------------------------------------//

Static Function BuscarFormaPago( cNombre , oFPago )

   local cCodigo  := Space( 2 )

   if oFPago:SeekInOrd( Upper( cNombre ), "cDesPgoBig" )
      cCodigo     := oFPago:cCodPago
   end if

Return cCodigo

//---------------------------------------------------------------------------//

Static Function BuscarGastoEnvio( cCodigo, oTotal )

   local nTotal   := 0
   local n

   if oTotal:RecCount() > 0

   for n := 1 to oTotal:RecCount()

      oTotal:Load()

      if( oTotal:GetBuffer( 2 ) == cCodigo ).and.;
        ( oTotal:GetBuffer( 6 ) == "ot_shipping" )

         nTotal   := oTotal:GetBuffer( 5 )

      end if

   oTotal:Skip()

   next

   end if

Return nTotal

//---------------------------------------------------------------------------//

Static Function BuscarDireccion( cDireccion, oObras, cCliente )

   local cCodigo

   if oObras:SeekInOrd( Upper( cDireccion ), "cDirObr" )
      cCodigo     := oObras:cCodObr
   end if

Return cCodigo

//---------------------------------------------------------------------------//

Method SeleccionFamilia() CLASS TComercio

   local cFamilia

   if oRetFld( ::oArt:FAMILIA, ::oFam, "LFAMINT" )
      cFamilia    := AllTrim( oRetFld( ::oArt:FAMILIA, ::oFam ) ) + Space( 1 ) + Rtrim( ::oArt:Nombre )
   else
      cFamilia    := ::oArt:Nombre
   end if

Return cFamilia
//---------------------------------------------------------------------------//
/*
METODOS PARA PRESTASHOP--------------------------------------------------------
*/
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

Method ExportarPrestashop() Class TComercio

   local oDb
   local oBlock
   local oError

   if !Empty( ::oFld )
      ::oFld:SetOption( 2 )
   end if

   ::oBtnExportar:Hide()

   ::oBtnCancel:Disable()

   oBlock            := ErrorBlock( { | oError | Break( oError ) } )
   BEGIN SEQUENCE

   if ::OpenFiles()

      ::SetText ( 'Intentando conectar con el servidor ' + '"' + ::cHost + '"' + ', el usuario ' + '"' + ::cUser + '"' + ' y la base de datos ' + '"' + ::cDbName + '".' , 1 )

      ::oCon            := TMSConnect():New()

      if !::oCon:Connect( ::cHost, ::cUser, ::cPasswd, ::cDbName, ::nPort )

         ::SetText ( 'No se ha podido conectar con la base de datos.' )

      else

         ::SetText ( 'Se ha conectado con éxito a la base de datos.' , 1 )

         oDb            := TMSDataBase():New ( ::oCon, ::cDbName )

         if Empty( oDb )

            ::SetText ( 'La Base de datos: ' + ::cDbName + ' no esta activa.', 1 )

         else

            /*
            Tomamos el lenguaje---------------------------------------------
            */

            ::nLanguage    := ::GetLanguagePrestashop( oDb )

            ::oMeter:SetTotal( 10 )
            ::nActualMeter := 1

            /*
            Pasamos los tipos de IVA a prestashop---------------------------
            */

            if ::lIva .or. ::lSincAll
               ::MeterGlobalText( "Actualizando tipos de " + cImp() )
               ::SetText ( 'Exportando tablas de tipos de ' + cImp(), 2 )
               ::AppendIvaPrestashop( odb )
               sysRefresh()
            end if

            /*
            Pasamos los artículos a prestashop------------------------------
            */

            if ::lArticulos .or. ::lSincAll

               ::MeterGlobalText( "Actualizando fabricantes" )
               ::SetText ( 'Exportando tablas de fabricantes', 2 )
               ::AppendFabricantesPrestashop()
               sysRefresh()

               ::MeterGlobalText( "Actualizando familias" )
               ::SetText ( 'Exportando tablas de familias de artículos', 2 )
               ::AppendFamiliaPrestashop( odb )
               sysRefresh()

               ::MeterGlobalText( "Actualizando artículos" )
               ::SetText ( 'Exportando tablas de propiedades de artículos', 2 )
               ::AppendPropiedadesPrestashop()
               sysRefresh()

               ::SetText ( 'Exportando tablas de artículos', 2 )
               ::AppendArticuloPrestashop( odb )
               sysRefresh()

               ::RecalculaPosicionesCategoriasPrestashop()
               sysRefresh()

            end if

            /*
            Nos traemos los clientes y pedidos hacia nuestras bases de datos y actualizamos el estado de los pedidos de arriba
            */

            if ::lPedidos .or. ::lSincAll

               ::MeterGlobalText( "Descargando clientes" )
               ::AppendClientPrestashop()
               sysRefresh()

               ::MeterGlobalText( "Descargando pedidos" )
               ::AppendPedidoprestashop()
               sysRefresh()

               ::MeterGlobalText( "Actualizando estado de los pedidos" )
               ::EstadoPedidosPrestashop()
               sysRefresh()

            end if
               

            /*
            Pasamos los clientes desde el programa a prestashop-------------
               

            if ::lCliente .or. ::lSincAll

               ::MeterGlobalText( "Actualizando estado de los pedidos" )
               ::AppendClientesToPrestashop()
               sysRefresh()

            end if
            */

            /*
            Pasamos las imágenes de los artículos a prestashop--------------
            */

            ::MeterGlobalText( "Subiendo imagenes" )

            ::AppendImagesPrestashop()

         end if

      end if

      ::oCon:Destroy()

      ::SetText( 'Base de datos desconectada.', 1 )

      ::MeterGlobalText( "Proceso finalizado" )

   else

      ::SetText( 'Error al abrir los ficheros necesarios.', 1 )

   end if

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Error al conectarnos con la base de datos" )

   END SEQUENCE

   ErrorBlock( oBlock )

   ::Closefiles()

   ::oBtnExportar:Hide()

   ::oBtnCancel:Enable()

Return .t.

//---------------------------------------------------------------------------//

Method ImportarPrestashop()

   local oDb

   if !ApoloMsgNoYes( "Se va a iniciar el proceso de importación desde OsCommerce, los datos de su equipo van a ser modificados." + CRLF + CRLF + "¿Desea continuar?", "Elija una opción" )
      Return ( Self )
   end if

   if !Empty( ::oFld )
      ::oFld:SetOption( 2 )
   end if

   ::oBtnExportar:Disable()
   ::oBtnCancel:Disable()

   if ::OpenFiles()

      ::SetText ( 'Intentando conectar con el servidor ' + '"' + ::cHost + '"' + ', el usuario ' + '"' + ::cUser + '"' + ' y la base de datos ' + '"' + ::cDbName + '".' , 1 )

      ::oCon            := TMSConnect():New()

      if !::oCon:Connect( ::cHost, ::cUser, ::cPasswd, ::cDbName, ::nPort )

          ::SetText ( 'No se ha podido conectar con la base de datos.' )

      else

           ::SetText ( 'Se ha conectado con éxito a la base de datos.' , 1 )

          oDb := TMSDataBase():New ( ::oCon, ::cDbName )

          if Empty( oDb )

             ::SetText ( 'La Base de datos: ' + ::cDbName + ' no esta activa.', 1 )

          else

            Msginfo( "Importamos en Prestashop" )

            /*::oMeter:SetTotal( 9 )
            ::nActualMeter := 1

            ::MeterGlobalText( "Descargando propiedades" )
            ::AppendPropiedades_bd( odb )
            sysRefresh()

            if ::lIva .or. ::lSincAll
               ::MeterGlobalText( "Descargando tipos de " + cImp() )
               ::AppendIva_bd( odb )
               sysRefresh()
            end if

            if ::lFamilias .or. ::lSincAll
               ::MeterGlobalText( "Descargando familias" )
               ::AppendFamilia_bd( odb )
               sysRefresh()
            end if

            if ::lFabricantes .or. ::lSincAll
               ::MeterGlobalText( "Descargando fabricantes" )
               ::AppendFabricantes_bd( odb )
               sysRefresh()
            end if

            if ::lArticulos .or. ::lSincAll
               ::MeterGlobalText( "Descargando artículos" )
               ::AppendArticulo_bd( odb )
               sysRefresh()
            end if

            if ::lPedidos .or. ::lSincAll
               ::MeterGlobalText( "Descargando clientes" )
               ::AppendClient( oDb )
               sysRefresh()

               ::MeterGlobalText( "Descargando pedidos" )
               ::AppendPedido( oDb )
               sysRefresh()

               ::MeterGlobalText( "Actualizando estados de pedidos" )
               ::EstadoPedidos( oDb )
               sysRefresh()
            end if

            ::MeterGlobalText( "Descargando imagenes" )
            ::AppendImages_bd()*/

          end if

      end if

      ::oCon:Destroy()

      ::SetText( 'Base de datos desconectada.', 1 )

   else

      ::SetText( 'Error al abrir los ficheros necesarios.', 1 )

   end if

   ::Closefiles()

   ::oBtnExportar:Enable()
   ::oBtnCancel:Enable()

Return .t.

//---------------------------------------------------------------------------//

Method GetLanguagePrestashop( oDb ) CLASS TComercio

   local oQuery
   local cCodLanguage

   if oDb:ExistTable( ::cPreFixtable( "lang" ) )

      oQuery               := TMSQuery():New( ::oCon, 'SELECT * FROM ' + ::cPrefixTable( "lang" ) +  ' WHERE active = 1' )

      if oQuery:Open()

         if oQuery:RecCount() > 0

            cCodLanguage   := oQuery:FieldGet( 1 )

         end if

      end if

   end if

   oQuery:Free()

Return if( !Empty( cCodLanguage ), cCodLanguage, 3 )

//---------------------------------------------------------------------------//

Method AppendFamiliaPrestashop( oDb ) CLASS TComercio

   local n
   local cCommand := ""

   /*
   Vaciamos las tablas para el proceso global-------------------------
   */

   cCommand       := "TRUNCATE TABLE " + ::cPrefixtable( "category" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText ( 'Tabla ' + ::cPreFixtable( "category" ) + ' borrada correctamente', 3  )
   else
      ::SetText ( 'Error al borrar la tabla ' + ::cPreFixtable( "category" ), 3  )
   end if

   cCommand       := "TRUNCATE TABLE " + ::cPrefixTable( "category_lang" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText ( 'Tabla ' + ::cPrefixTable( "category_lang" ) + ' borrada correctamente', 3  )
   else
      ::SetText ( 'Error al borrar la tabla ' + ::cPrefixTable( "category_lang" ), 3  )
   end if

   cCommand       := "TRUNCATE TABLE " + ::cPrefixTable( "category_product" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText ( 'Tabla ' + ::cPrefixTable( "category_product" ) + ' borrada correctamente', 3  )
   else
      ::SetText ( 'Error al borrar la tabla ' + ::cPrefixTable( "category_product" ), 3  )
   end if

   cCommand       := "TRUNCATE TABLE " + ::cPrefixTable( "category_group" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText ( 'Tabla ' + ::cPrefixTable( "category_group" ) + ' borrada correctamente', 3  )
   else
      ::SetText ( 'Error al borrar la tabla ' + ::cPrefixTable( "category_group" ), 3  )
   end if

   cCommand       := "TRUNCATE TABLE " + ::cPrefixTable( "category_shop" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText ( 'Tabla ' + ::cPrefixTable( "category_shop" ) + ' borrada correctamente', 3  )
   else
      ::SetText ( 'Error al borrar la tabla '+ ::cPrefixTable( "category_group" ), 3  )
   end if

   cCommand       := "TRUNCATE TABLE " + ::cPrefixTable( "image" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText ( 'Tabla ' + ::cPrefixTable( "image" ) + 'borrada correctamente', 3  )
   else
      ::SetText ( 'Error al borrar la tabla' + ::cPrefixTable( "image" ), 3  )
   end if

   cCommand       := "TRUNCATE TABLE " + ::cPrefixTable( "image_shop" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText ( 'Tabla ' + ::cPrefixTable( "image_shop" ) + ' borrada correctamente', 3  )
   else
      ::SetText ( 'Error al borrar la tabla '+ ::cPrefixTable( "image_shop" ), 3  )
   end if

   cCommand       := "TRUNCATE TABLE " + ::cPrefixTable( "image_lang" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText ( 'Tabla ' + ::cPrefixTable( "image_lang" ) + ' borrada correctamente', 3  )
   else
      ::SetText ( 'Error al borrar la tabla ' + ::cPrefixTable( "image_lang" ), 3  )
   end if

   /*
   Borramos los IdWeb de todas las familias---------------------------------
   */

   ::DelIdFamiliasPrestashop()
   ::DelIdGrupoFamiliasPrestashop()
   ::DelIdTipoArticuloPrestashop()

   /*
   Cargamos la categoría raiz de la que colgarán todas las demás------------
   */

   ::AddCategoriaRaiz()

   /*
   Añadimos los grupos de familia si los hay-----------------------------------
   */

   ::oGrpFam:GoTop()

   while !::oGrpFam:Eof()

      if ::oGrpFam:lPubInt

         ::MeterParticularText( "Actualizando grupos familias" )

         /*
         Metemos las familias como categorías----------------------------------
         */

         ::InsertGrupoCategoriesPrestashop()

      end if

      ::oGrpFam:FieldPutByName( "lSelDoc", .f. )

      ::oGrpFam:Skip()

   end while

   /*
   Añadimos familias a prestashop----------------------------------------------
   */

   ::oFam:GoTop()

   while !::oFam:Eof()

      if ::oFam:lPubInt

         ::MeterParticularText( "Actualizando familias" )

         /*
         Metemos las familias como categorías----------------------------------
         */

         ::InsertCategoriesPrestashop()

      end if

      ::oFam:FieldPutByName( "lSelDoc", .f. )

      ::oFam:Skip()

   end while

Return ( Self )

//---------------------------------------------------------------------------//

METHOD AddCategoriaRaiz() CLASS TComercio

   local cCommand := ""

   /*
   Insertamos el root en la tabla de categorias------------------------------
   */

   ::cTextoWait( "Añadiendo categoría raiz" )

   cCommand       := "INSERT INTO " + ::cPrefixTable( "category" ) + " ( id_category, id_parent, id_shop_default, level_depth, nleft, nright, active, date_add, date_upd, position ) VALUES ( '1', '0', '1', '0', '0', '0', '1', '" + dtos( GetSysDate() ) + "', '" + dtos( GetSysDate() ) + "', '0' ) "

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::nNumeroCategorias++
      ::SetText( "He insertado correctamente en la tabla categorías la categoría raiz", 3 )
   else
      ::SetText( "Error al insertar la categoría raiz", 3 )
   end if

   cCommand       := "INSERT INTO " + ::cPrefixTable( "category_lang" ) + " ( id_category, id_lang, name, description, link_rewrite, meta_title, meta_keywords, meta_description ) VALUES ( '1', '" + Str( ::nLanguage ) + "', 'Root', 'Root', 'Root', '', '', '' )"

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText( "He insertado correctamente en la tabla categorias lenguajes la categoría raiz", 3 )
   else
      ::SetText( "Error al insertar la categoría raiz", 3 )
   end if

   cCommand       := "INSERT INTO " + ::cPrefixTable( "category_shop" ) + " ( id_category, id_shop, position ) VALUES ( '1', '1', '0' )"

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText( "He insertado correctamente en la tabla categorias grupo la categoría raiz", 3 )
   else
      ::SetText( "Error al insertar la categoría raiz", 3 )
   end if

   cCommand       := "INSERT INTO " + ::cPrefixTable( "category_group" ) + " ( id_category, id_group ) VALUES ( '1', '1' )"

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText( "He insertado correctamente en la tabla categorias grupo la categoría raiz", 3 )
   else
      ::SetText( "Error al insertar la categoría raiz", 3 )
   end if

   cCommand       := "INSERT INTO " + ::cPrefixTable( "category_group" ) + " ( id_category, id_group ) VALUES ( '1', '2' )"

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText( "He insertado correctamente en la tabla categorias grupo la categoría raiz", 3 )
   else
      ::SetText( "Error al insertar la categoría raiz", 3 )
   end if

   cCommand       := "INSERT INTO " + ::cPrefixTable( "category_group" ) + " ( id_category, id_group ) VALUES ( '1', '3' )"

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText( "He insertado correctamente en la tabla categorias grupo la categoría raiz", 3 )
   else
      ::SetText( "Error al insertar la categoría root en ps_category_group", 3 )
   end if

   /*
   Metemos la categoría de inicio de la que colgarán los grupos y las categorias
   */

   cCommand       := "INSERT INTO " + ::cPrefixTable( "category" ) + " ( id_parent, id_shop_default, level_depth, nleft, nright, active, date_add, date_upd, position, is_root_category ) VALUES ( '1', '1', '1', '0', '0', '1', '" + dtos( GetSysDate() ) + "', '" + dtos( GetSysDate() ) + "', '0', '1' ) "

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::nNumeroCategorias++
      ::SetText( "He insertado correctamente en la tabla categorias la categoría raiz", 3 )
   else
      ::SetText( "Error al insertar la categoría inicio", 3 )
   end if

   cCommand       := "INSERT INTO " + ::cPrefixTable( "category_lang" ) + " ( id_category, id_lang, name, description, link_rewrite, meta_title, meta_keywords, meta_description ) VALUES ( '2', '" + Str( ::nLanguage ) + "', 'Inicio', 'Inicio', 'Inicio', '', '', '' )"

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText( "He insertado correctamente en la tabla categorias lenguajes la categoría raiz", 3 )
   else
      ::SetText( "Error al insertar la categoría inicio", 3 )
   end if

   cCommand       := "INSERT INTO " + ::cPrefixTable( "category_shop" ) + " ( id_category, id_shop, position ) VALUES ( '2', '1', '0' )"

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText( "He insertado correctamente en la tabla categorias grupo la categoría raiz", 3 )
   else
      ::SetText( "Error al insertar la categoría inicio", 3 )
   end if

   cCommand       := "INSERT INTO " + ::cPrefixTable( "category_group" ) + " ( id_category, id_group ) VALUES ( '2', '1' )"

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText( "He insertado correctamente en la tabla categorias grupo la categoría raiz", 3 )
   else
      ::SetText( "Error al insertar la categoría inicio", 3 )
   end if

   cCommand       := "INSERT INTO " + ::cPrefixTable( "category_group" ) + " ( id_category, id_group ) VALUES ( '2', '2' )"

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText( "He insertado correctamente en la tabla categorias grupo la categoría raiz", 3 )
   else
      ::SetText( "Error al insertar la categoría inicio", 3 )
   end if

   cCommand       := "INSERT INTO " + ::cPrefixTable( "category_group" ) + " ( id_category, id_group ) VALUES ( '2', '3' )"

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText( "He insertado correctamente en la tabla categorias grupo la categoría raiz", 3 )
   else
      ::SetText( "Error al insertar la categoría inicio", 3 )
   end if

   SysRefresh()

Return ( Self )

//---------------------------------------------------------------------------//

Method InsertCategoriesPrestashop() CLASS TComercio

   local oImagen
   local oCategoria
   local nCodigoWeb           := 0
   local nParent              := 2
   local cCommand             := ""

   if !Empty( ::oFam:cCodGrp )
      
      nParent                 := oRetFld( ::oFam:cCodGrp, ::oGrpFam, "cCodWeb" )
      
      if nParent == 0
         nParent              := 2
      end if

   end if

   ::cTextoWait( "Añadiendo categoría: " + AllTrim( ::oFam:cNomFam ) )

   /*
   Insertamos una familia nueva en las tablas de prestashop-----------------
   */

   cCommand := "INSERT INTO " + ::cPrefixTable( "category" ) + "( " + ;
                  "id_parent, " + ;
                  "level_depth, " + ;
                  "nleft, " + ;
                  "nright, " + ;
                  "active, " + ;
                  "date_add,  " + ;
                  "date_upd, " + ;
                  "position " + ;
               ") VALUES ( '" + ;
                  Str( nParent ) + "', " + ;
                  "'2', " + ;
                  "'0', " + ;
                  "'0', " + ;
                  "'1', " + ;
                  "'" + dtos( GetSysDate() ) + "', " + ;
                  "'" + dtos( GetSysDate() ) + "', " + ;
                  "'0' ) "

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )

      nCodigoWeb           := ::oCon:GetInsertId()

      ::nNumeroCategorias++

      /*
      Metemos en un array para luego calcular las coordenadas---------------
      */

      oCategoria                       := SCategoria()
      oCategoria:id                    := nCodigoWeb
      oCategoria:idParent              := nParent
      oCategoria:nTipo                 := 2

      aAdd( ::aCategorias, oCategoria )

      /*
      Guardamos en nuestra tabla lasel id de la categoria-------------------
      */

      ::oFam:fieldPutByName( "cCodWeb", nCodigoWeb )

      ::SetText( "He insertado la familia " + AllTrim( ::oFam:cNomFam ) + " correctamente en la tabla " + ::cPrefixTable( "category" ), 3 )

   else
      ::SetText( "Error al insertar la familia " + AllTrim( ::oFam:cNomFam ) + " en la tabla " + ::cPrefixTable( "category" ), 3 )
   end if

   cCommand := "INSERT INTO " + ::cPrefixTable( "category_lang" ) + "( " + ;
                  "id_category, " + ;
                  "id_lang, " + ;
                  "name, " + ;
                  "description, " + ;
                  "link_rewrite, " + ;
                  "meta_title, " + ;
                  "meta_keywords, " + ;
                  "meta_description" + ;
                  " ) VALUES ( '" + ;
                  Str( nCodigoWeb ) + "', '" +;
                  Str( ::nLanguage ) + "', '" + ;
                  AllTrim( ::oFam:cNomFam ) + "', '" + ;
                  AllTrim( ::oFam:cNomFam ) + "', '" + ;
                  cLinkRewrite( ::oFam:cNomFam ) + "', " + ;
                  "'', " + ;
                  "'', " + ;
                  "'' )"

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText( "He insertado la familia " + AllTrim( ::oFam:cNomFam ) + " correctamente en la tabla " + ::cPrefixTable( "category_lang" ), 3 )
   else
      ::SetText( "Error al insertar la familia " + AllTrim( ::oFam:cNomFam ) + " en la tabla " + ::cPrefixTable( "category_lang" ), 3 )
   end if

   cCommand := "INSERT INTO " + ::cPrefixTable( "category_shop" ) + "( id_category, id_shop, position ) VALUES ( '" + Str( nCodigoWeb ) + "', '1', '0' )"

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText( "He insertado correctamente en la tabla categorias grupo la categoría raiz", 3 )
   else
      ::SetText( "Error al insertar la categoría inicio en " + ::cPrefixTable( "category_group" ), 3 )
   end if

   cCommand := "INSERT INTO " + ::cPrefixTable( "category_group" ) + "( id_category, id_group ) VALUES ( '" + Str( nCodigoWeb ) + "', '1' )"

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText( "He insertado la familia " + AllTrim( ::oFam:cNomFam ) + " correctamente en la tabla " + ::cPrefixTable( "category_group" ), 3 )
   else
      ::SetText( "Error al insertar la familia " + AllTrim( ::oFam:cNomFam ) + " en la tabla " + ::cPrefixTable( "category_group" ), 3 )
   end if

   cCommand := "INSERT INTO " + ::cPrefixTable( "category_group" ) + "( id_category, id_group ) VALUES ( '" + Str( nCodigoWeb ) + "', '2' )"

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText( "He insertado la familia " + AllTrim( ::oFam:cNomFam ) + " correctamente en la tabla " + ::cPrefixTable( "category_group" ), 3 )
   else
      ::SetText( "Error al insertar la familia " + AllTrim( ::oFam:cNomFam ) + " en la tabla " + ::cPrefixTable( "category_group" ), 3 )
   end if

   cCommand := "INSERT INTO " + ::cPrefixTable( "category_group" ) + "( id_category, id_group ) VALUES ( '" + Str( nCodigoWeb ) + "', '3' )"

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText( "He insertado la familia " + AllTrim( ::oFam:cNomFam ) + " correctamente en la tabla " + ::cPrefixTable( "category_group" ), 3 )
   else
      ::SetText( "Error al insertar la familia " + AllTrim( ::oFam:cNomFam ) + " en la tabla " + ::cPrefixTable( "category_group" ), 3 )
   end if

   SysRefresh()

   /*
   Insertamos un registro en las tablas de imágenes----------------------
   */

   if !Empty( ::oFam:cImgBtn )

      /*
      Añadimos la imagen al array para pasarla a prestashop--------------
      */

      oImagen                       := SImagen()
      oImagen:cNombreImagen         := ::oFam:cImgBtn
      oImagen:nTipoImagen           := tipoCategoria
      oImagen:cPrefijoNombre        := AllTrim( Str( nCodigoWeb ) )

      ::AddImages( oImagen )

   end if

return nCodigoWeb

//---------------------------------------------------------------------------//

Method UpdateCategoriesPrestashop() CLASS TComercio

   local lReturn  := .f.
   local cCommand := ""
   local nParent  := 2

   /*
   Actualizamos la familia en prestashop------------------------------------
   */

   ::cTextoWait( "Actualizando categoría: " + ::oFam:cNomFam )

   if !Empty( ::oFam:cCodGrp )
      
      nParent                 := oRetFld( ::oFam:cCodGrp, ::oGrpFam, "cCodWeb" )
      
      if nParent == 0

         nParent              := 2 //Por defecto toma 2, porque siempre existen dos categorias por sefecto que son Root e Inicio.

      end if

   end if

   cCommand       := "UPDATE " + ::cPrefixTable( "category" ) + " SET " + ;
                        "id_parent='" + AllTrim( Str( nParent ) ) + "', " + ;
                        "date_upd='" + dtos( GetSysDate() ) + "' " + ;
                     "WHERE id_category=" + AllTrim( Str( ::oFam:cCodWeb ) )

   lReturn        := TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   cCommand       := "UPDATE " + ::cPrefixTable( "category_lang" ) + " SET " + ;
                        "name='" + AllTrim( ::oFam:cNomFam ) + "', " + ;
                        "description='" + AllTrim( ::oFam:cNomFam ) + "', " + ;
                        "link_rewrite='" + cLinkRewrite( ::oFam:cNomFam ) + "' " + ;
                     "WHERE id_category=" + AllTrim( Str( ::oFam:cCodWeb ) )

   lReturn        := TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   SysRefresh()

Return lReturn

//---------------------------------------------------------------------------//

Method DeleteCategoriesPrestashop() CLASS TComercio

   local lReturn     := .f.
   local cCommand    := ""

   ::cTextoWait( "Eliminando categoría: " + ::oFam:cNomFam )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "category" ) + " WHERE id_category=" + AllTrim( Str( ::oFam:cCodWeb ) )
   lReturn           := TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "category_lang" ) + " WHERE id_category=" + AllTrim( Str( ::oFam:cCodWeb ) )
   lReturn           := TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "category_product" ) + " WHERE id_category=" + AllTrim( Str( ::oFam:cCodWeb ) )
   lReturn           := TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "category_group" ) + " WHERE id_category=" + AllTrim( Str( ::oFam:cCodWeb ) )
   lReturn           := TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "category_shop" ) + " WHERE id_category=" + AllTrim( Str( ::oFam:cCodWeb ) )
   lReturn           := TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   SysRefresh()

   /*
   Eliminamos las imágenes de la familia---------------------------------------
   */

   ::cTextoWait( "Eliminando imágenes categoría: " + ::oFam:cNomFam )

   ::DeleteImagesCategories( ::oFam:cCodWeb )

   SysRefresh()

   /*
   Eliminamos en cascada Todo lo que esté tirando de la familia----------------
   */

   ::DelCascadeCategoriesPrestashop()

   /*
   Quitamos la referencia de nuestra tabla-------------------------------------
   */

   ::oFam:fieldPutByName( "cCodWeb", 0 )

Return lReturn

//---------------------------------------------------------------------------//

METHOD DelCascadeCategoriesPrestashop() CLASS TComercio

   local nRec     := ::oArt:Recno()
   local nOrdAnt  := ::oArt:OrdSetFocus( "FAMILIA" )

   if ::oArt:Seek( ::oFam:cCodFam )

      while ::oArt:Familia == ::oFam:cCodfam .and. !::oArt:Eof()

         if ::oArt:lPubInt .and. ::oArt:cCodWeb != 0

            ::DeleteProductsPrestashop()

         end if

         SysRefresh()

         ::oArt:Skip()

      end while

   end if

   /*
   Antes de irnos dejamos la tabla donde estaba--------------------------------
   */

   ::oArt:OrdSetFocus( nOrdAnt )
   ::oArt:GoTo( nRec )

return .t.

//---------------------------------------------------------------------------//

Method ActualizaCategoriesPrestashop( cCodigoFamilia ) CLASS TComercio

   local oQuery
   local cCommand

   if !::lReady()
      Return .f.
   end if
   
   ::lShowDialogWait()

   if ::OpenFiles()

      if ::oFam:Seek( cCodigoFamilia )
   
         if ::ConectBBDD()
   
            do case
               case !::oFam:lPubInt .and. ::oFam:cCodWeb != 0
      
                  ::cTextoWait( "Elimina categoría: " + ::oFam:cNomFam )

                  ::DeleteCategoriesPrestashop()
      
               case ::oFam:lPubInt .and. ::oFam:cCodWeb != 0
      
                  cCommand := 'SELECT * FROM ' + ::cPrefixTable( "category" ) +  ' WHERE id_category=' + AllTrim( Str( ::oFam:cCodWeb ) )
                  oQuery   := TMSQuery():New( ::oCon, cCommand )
      
                  if oQuery:Open()
      
                     if oQuery:RecCount() > 0
      
                        ::cTextoWait( "Actualizando categoría: " + ::oFam:cNomFam )

                        ::UpdateCategoriesPrestashop()
      
                     else
      
                        ::cTextoWait( "Añadiendo categoría: " + ::oFam:cNomFam )

                        ::InsertCategoriesPrestashop()
      
                     end if
      
                  end if
      
                  oQuery:Free()
      
               case ::oFam:lPubInt .and. ::oFam:cCodWeb == 0
      
                  ::cTextoWait( "Añadiendo categoría: " + ::oFam:cNomFam )

                  ::InsertCategoriesPrestashop()
      
            end case   

            ::DisconectBBDD()
   
         endif      

      end if

      ::CloseFiles()

   end if

   ::lHideDialogWait()

Return .t.

//---------------------------------------------------------------------------//

Method InsertGrupoCategoriesPrestashop() CLASS TComercio

   local nRecAnt           := ::oGrpFam:Recno()
   local nCodigoWeb        := 2
   local cCommand          := ""
   local oCategoria

   ::cTextoWait( "Añadiendo grupo: " + AllTrim( ::oGrpFam:cNomGrp ) )

   cCommand := "INSERT INTO " + ::cPrefixTable( "category" ) + "( " + ;
                  "id_parent, " + ;
                  "level_depth, " + ;
                  "nleft, " + ;
                  "nright, " + ;
                  "active, " + ;
                  "date_add, " + ;
                  "date_upd, " + ;
                  "position ) " + ;
               "VALUES ( " +; 
                  "'2', " + ;
                  "'2', " + ;
                  "'0', " + ;
                  "'0', " + ;
                  "'1', " + ;
                  "'" + dtos( GetSysDate() ) + "', " + ;
                  "'" + dtos( GetSysDate() ) + "', " + ;
                  "'0' ) "

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )

      nCodigoWeb           := ::oCon:GetInsertId()

      ::nNumeroCategorias++

      /*
      Metemos en un array para luego calcular las coordenadas---------------
      */

      oCategoria                       := SCategoria()
      oCategoria:id                    := nCodigoWeb
      oCategoria:idParent              := 2
      oCategoria:nTipo                 := 1

      aAdd( ::aCategorias, oCategoria )

      /*
      Guardamos en nuestra tabla el id que nos han dado en prestashop-------
      */

      ::oGrpFam:fieldPutByName( "cCodWeb", nCodigoWeb )

      ::SetText( "He insertado el grupo de familia " + AllTrim( ::oGrpFam:cNomGrp ) + " correctamente en la tabla " + ::cPrefixTable( "category" ), 3 )

   else
      ::SetText( "Error al insertar el grupo de familia " + AllTrim( ::oGrpFam:cNomGrp ) + " en la tabla " + ::cPrefixTable( "ps_category" ), 3 )
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
               "VALUES ( " + ; 
                  "'" + Str( nCodigoWeb ) + "'," + ;
                  "'" + Str( ::nLanguage ) + "', " + ;
                  "'" + AllTrim( ::oGrpFam:cNomGrp ) + "', " + ;
                  "'" + AllTrim( ::oGrpFam:cNomGrp ) + "', " + ;
                  "'" + cLinkRewrite( ::oGrpFam:cNomGrp ) + "', "+ ;
                  "'', " + ;
                  "'', " + ;
                  "'' )"

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText( "He insertado el grupo de familia " + AllTrim( ::oGrpFam:cNomGrp ) + " correctamente en la tabla ps_category_lang", 3 )
   else
      ::SetText( "Error al insertar el grupo de familia " + AllTrim( ::oGrpFam:cNomGrp ) + " en la tabla ps_category_lang", 3 )
   end if

   cCommand := "INSERT INTO " + ::cPrefixTable( "category_shop" ) + " ( id_category, id_shop, position ) VALUES ( '" + Str( nCodigoWeb ) + "', '1', '0' )"

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText( "He insertado el grupo de familia " + AllTrim( ::oGrpFam:cNomGrp ) + " correctamente en la tabla " + ::cPrefixTable( "category_shop" ), 3 )
   else
      ::SetText( "Error al insertar el grupo de familia " + AllTrim( ::oGrpFam:cNomGrp ) + " en la tabla " + ::cPrefixTable( "category_shop" ), 3 )
   end if

   cCommand := "INSERT INTO " + ::cPreFixTable( "category_group" ) + " ( id_category, id_group ) VALUES ( '" + Str( nCodigoWeb ) + "', '1' )"

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText( "He insertado el grupo de familia " + AllTrim( ::oGrpFam:cNomGrp ) + " correctamente en la tabla "+ ::cPrefixTable( "category_group" ), 3 )
   else
      ::SetText( "Error al insertar el grupo de familia " + AllTrim( ::oGrpFam:cNomGrp ) + " en la tabla " + ::cPrefixTable( "category_group" ), 3 )
   end if

   cCommand := "INSERT INTO " + ::cPrefixTable( "category_group" ) + " ( id_category, id_group ) VALUES ( '" + Str( nCodigoWeb ) + "', '2' )"

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText( "He insertado el grupo de familia " + AllTrim( ::oGrpFam:cNomGrp ) + " correctamente en la tabla " + ::cPrefixTable( "category_group" ), 3 )
   else
      ::SetText( "Error al insertar el grupo de familia " + AllTrim( ::oGrpFam:cNomGrp ) + " en la tabla " + ::cPrefixTable( "category_group" ), 3 )
   end if

   cCommand := "INSERT INTO " + ::cPrefixTable( "category_group" ) + "( id_category, id_group ) VALUES ( '" + Str( nCodigoWeb ) + "', '3' )"

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText( "He insertado el grupo de familia " + AllTrim( ::oGrpFam:cNomGrp ) + " correctamente en la tabla " + ::cPrefixTable( "category_group" ), 3 )
   else
      ::SetText( "Error al insertar el grupo de familia " + AllTrim( ::oGrpFam:cNomGrp ) + " en la tabla " + ::cPrefixTable( "category_group" ), 3 )
   end if

   SysRefresh()

   /*
   Actualizamos en cascada las familias que cuelgan del grupo------------------
   */

   ::UpdateCascadeCategoriesPrestashop()

return nCodigoWeb   

//---------------------------------------------------------------------------//

Method UpdateGrupoCategoriesPrestashop() CLASS TComercio

   local lReturn  := .f.
   local cCommand := ""

   ::cTextoWait( "Actualizando grupo: " + AllTrim( ::oGrpFam:cNomGrp ) )

   /*
   Actualizamos la familia en prestashop---------------------------------------
   */

   cCommand       := "UPDATE " + ::cPrefixTable( "category" ) + " SET " + ;
                        "date_upd='" + dtos( GetSysDate() ) + "' " + ; 
                     "WHERE id_category=" + AllTrim( Str( ::oGrpFam:cCodWeb ) )

   lReturn        := TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   cCommand       := "UPDATE " + ::cPrefixTable( "category_lang" ) + " SET " + ;
                        "name='" + AllTrim( ::oGrpFam:cNomGrp ) + "', " + ;
                        "description='" + AllTrim( ::oGrpFam:cNomGrp ) + "', " + ;
                        "link_rewrite='" + cLinkRewrite( ::oGrpFam:cNomGrp ) + "' " + ;
                     "WHERE id_category=" + AllTrim( Str( ::oGrpFam:cCodWeb ) )

   lReturn        := TMSCommand():New( ::oCon ):ExecDirect( cCommand )

Return lReturn

//---------------------------------------------------------------------------//

Method DeleteGrupoCategoriesPrestashop( cCodWeb, lDel ) CLASS TComercio

   local lReturn     := .f.
   local cCommand    := ""

   DEFAULT cCodWeb   := ::oGrpFam:cCodWeb

   if cCodWeb == 0 .or. cCodWeb == 1
      return .f.
   end if

   ::cTextoWait( "Eliminando grupo: " + AllTrim( ::oGrpFam:cNomGrp ) )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "category" ) + " WHERE id_category=" + AllTrim( Str( cCodWeb ) )
   lReturn           := TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "category_lang" ) + " WHERE id_category=" + AllTrim( Str( cCodWeb ) )
   lReturn           := TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "category_product" ) + " WHERE id_category=" + AllTrim( Str( cCodWeb ) )
   lReturn           := TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "category_group" ) + " WHERE id_category=" + AllTrim( Str( cCodWeb ) )
   lReturn           := TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "category_shop" ) + " WHERE id_category=" + AllTrim( Str( cCodWeb ) )
   lReturn           := TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   SysRefresh()

   /*
   Eliminamos las imágenes del grupo de familia--------------------------------
   */

   ::cTextoWait( "Eliminando imágenes grupo: " + AllTrim( ::oGrpFam:cNomGrp ) )

   ::DeleteImagesCategories( cCodWeb )

   /*
   Quitamos la referencia de nuestra tabla-------------------------------------
   */

   if !lDel
      ::oGrpFam:fieldPutByName( "cCodWeb", 0 )
   end if

   /*
   Actualizamos en cascada las familias que cuelgan del grupo------------------
   */

   if !lDel
      ::UpdateCascadeCategoriesPrestashop()   
   else   
      ::DelCascadeGrupoCategoriesPrestashop( cCodWeb )
   end if   

Return lReturn

//---------------------------------------------------------------------------//

Method UpdateCascadeCategoriesPrestashop() CLASS TComercio

   ::oFam:GoTop()

   while !::oFam:Eof()

      if ::oFam:cCodGrp == ::oGrpFam:cCodGrp

         ::UpdateCategoriesPrestashop()

      end if

      ::oFam:Skip()

      SysRefresh()

   end while

Return .t.   

//---------------------------------------------------------------------------//

Method DelCascadeGrupoCategoriesPrestashop( cCodWeb ) CLASS TComercio

   local cCommand := "UPDATE " + ::cPrefixTable( "category" ) + " SET id_parent=2 WHERE id_parent=" + AllTrim( Str( cCodWeb ) )

   TMSCommand():New( ::oCon ):ExecDirect( cCommand )

Return .t.   

//---------------------------------------------------------------------------//

Method ActualizaGrupoCategoriesPrestashop( cCodigoGrupo, lDel, cCodWeb ) CLASS TComercio

   local oQuery
   local cCommand

   DEFAULT lDel := .f.

   if !::lReady()
      Return .f.
   end if

   ::lShowDialogWait()

   if ::OpenFiles()

      if ::oGrpFam:Seek( cCodigoGrupo )
   
         if ::ConectBBDD()
   
            do case
               case ( !::oGrpFam:lPubInt .and. ::oGrpFam:cCodWeb != 0 ) .or. lDel
   
                  ::cTextoWait( "Eliminando grupo: " + AllTrim( ::oGrpFam:cNomGrp ) )

                  ::DeleteGrupoCategoriesPrestashop( cCodWeb, lDel )
   
               case ::oGrpFam:lPubInt .and. ::oGrpFam:cCodWeb != 0
   
                  cCommand := 'SELECT * FROM ' + ::cPrefixTable( "category" ) +  ' WHERE id_category=' + AllTrim( Str( ::oGrpFam:cCodWeb ) )
                  oQuery   := TMSQuery():New( ::oCon, cCommand )
   
                  if oQuery:Open()
   
                     if oQuery:RecCount() > 0
   
                        ::cTextoWait( "Actualizando grupo: " + AllTrim( ::oGrpFam:cNomGrp ) )

                        ::UpdateGrupoCategoriesPrestashop()
   
                     else   
   
                        ::cTextoWait( "Añadiendo grupo: " + AllTrim( ::oGrpFam:cNomGrp ) )

                        ::InsertGrupoCategoriesPrestashop()
   
                     end if
   
                  end if
   
                  oQuery:Free()
   
               case ::oGrpFam:lPubInt .and. ::oGrpFam:cCodWeb == 0
   
                  ::cTextoWait( "Añadiendo grupo: " + AllTrim( ::oGrpFam:cNomGrp ) )

                  ::InsertGrupoCategoriesPrestashop()
   
            end case   

            ::DisconectBBDD()
   
         endif      

      end if

      ::CloseFiles()

   end if

   ::lHideDialogWait()

Return .t.

//---------------------------------------------------------------------------//

METHOD DeleteImagesCategories( cCodCategorie ) CLASS TComercio

   local oInt
   local oFtp
   local aDirectory
   local cDirectory
   local lerror

   if !Empty( cCodCategorie )

      /*
      Conectamos al FTP para eliminar las imagenes de las categorías-----------
      */

      oInt         := TInternet():New()
      oFtp         := TFtp():New( ::cHostFtp, oInt, ::cUserFtp, ::cPasswdFtp, ::lPassiveFtp )

      if Empty( oFtp ) .or. Empty( oFtp:hFtp )

         MsgStop( "Imposible conectar al sitio ftp " + ::cHostFtp )

      else

         if !Empty( ::cDImagen )
            oFtp:SetCurrentDirectory( ::cDImagen + "/c" )
         end if

         oFtp:DeleteMask( AllTrim( Str( cCodCategorie ) ) + "*.*" )

      end if

      if !Empty( oInt )
         oInt:end()
      end if

      if !Empty( oFtp )
         oFtp:end()
      end if

   end if

Return .t.

//---------------------------------------------------------------------------//

METHOD RecalculaPosicionesCategoriasPrestashop() CLASS TComercio

   local nContador      := 3
   local aTemporal      := ::aCategorias
   local oCategoria
   local nPos           := 0
   local oCat
   local oCat2

   /*
   Pongo posiciones en la categoría raiz e inicio
   */

   if TMSCommand():New( ::oCon ):ExecDirect( "UPDATE ps_category SET nLeft='1', nRight='" + AllTrim( Str( ::nNumeroCategorias * 2 ) ) + "' WHERE id_category=1" )
      ::SetText( "Actualizada correctamente el grupo de familia en la tabla ps_category", 3 )
   else
      ::SetText( "Error al actualizar el grupo de familia en la tabla ps_category", 3 )
   end if

   if TMSCommand():New( ::oCon ):ExecDirect( "UPDATE ps_category SET nLeft='2', nRight='" + AllTrim( Str( ( ::nNumeroCategorias * 2 ) -1 ) ) + "' WHERE id_category=2" )
      ::SetText( "Actualizada correctamente el grupo de familia en la tabla ps_category", 3 )
   else
      ::SetText( "Error al actualizar el grupo de familia en la tabla ps_category", 3 )
   end if

   /*
   Calculo las posiciones en un array temporal---------------------------------
   */

   for each oCategoria in aTemporal

      do case
         case oCategoria:nTipo == 1    //Grupos

            nPos := aScan( ::aCategorias, {|a| a:id == oCategoria:id } )

            if nPos != 0
               ::aCategorias[ nPos ]:nLeft   := nContador
               nContador++
            end if

            for each oCat in ::aCategorias

               if oCat:idParent == oCategoria:id

                  oCat:nLeft   := nContador
                  nContador++

                  for each oCat2 in ::aCategorias

                     if oCat2:idParent == oCat:id
                        oCat2:nLeft   := nContador
                        nContador++
                        oCat2:nRight  := nContador
                        nContador++
                     end if

                  next

                  oCat:nRight  := nContador
                  nContador++

               end if

            next

            nPos := aScan( ::aCategorias, {|a| a:id == oCategoria:id } )

            if nPos != 0
               ::aCategorias[ nPos ]:nRight   := nContador
               nContador++
            end if

         case oCategoria:nTipo == 2    //Familias

            if oCategoria:idParent == 2

                  nPos := aScan( ::aCategorias, {|a| a:id == oCategoria:id } )

                  if nPos != 0
                     ::aCategorias[ nPos ]:nLeft   := nContador
                     nContador++
                     ::aCategorias[ nPos ]:nRight  := nContador
                     nContador++
                  end if

            end if

      end case

   next

   /*
   Actualizo las posiciones en la tabla de la web en mysql---------------------
   */

   for each oCategoria in ::aCategorias

      if TMSCommand():New( ::oCon ):ExecDirect( "UPDATE ps_category SET nLeft='" + AllTrim( Str( oCategoria:nLeft ) ) + "', nRight='" + AllTrim( Str( ( oCategoria:nRight ) ) + "' WHERE id_category=" + AllTrim( Str( oCategoria:id ) ) ) )
         ::SetText( "Actualizada correctamente el grupo de familia en la tabla ps_category", 3 )
      else
         ::SetText( "Error al actualizar el grupo de familia en la tabla ps_category", 3 )
      end if

   next

return ( .t. )

//---------------------------------------------------------------------------//

METHOD AppendArticuloPrestashop( oDb )

   local cCommand    := ""

   /*
   Artículos----------------------------------------------------------
   */

   cCommand          := "TRUNCATE TABLE " + ::cPrefixTable( "product" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText ( 'Tabla ' + ::cPrefixTable( "product" ) + ' borrada correctamente', 3  )
   else
      ::SetText ( 'Error al borrar la tabla ' + ::cPrefixTable( "product" ), 3  )
   end if

   cCommand          := "TRUNCATE TABLE " + ::cPrefixTable( "product_attachment" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText ( 'Tabla ' + ::cPrefixTable( "product_attachment" ) + ' borrada correctamente', 3  )
   else
      ::SetText ( 'Error al borrar la tabla ' + ::cPrefixTable( "product_attachment" ), 3  )
   end if

   cCommand          := "TRUNCATE TABLE " + ::cPrefixTable( "product_attribute" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText ( 'Tabla ' + ::cPrefixTable( "product_attribute" ) + ' borrada correctamente', 3  )
   else
      ::SetText ( 'Error al borrar la tabla ' + ::cPrefixTable( "product_attribute" ), 3  )
   end if

   cCommand          := "TRUNCATE TABLE " + ::cPrefixTable( "product_attribute_combination" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText ( 'Tabla ' + ::cPrefixTable( "product_attribute_combination" ) + ' borrada correctamente', 3  )
   else
      ::SetText ( 'Error al borrar la tabla ' + ::cPrefixTable( "product_attribute_combination" ), 3  )
   end if

   cCommand          := "TRUNCATE TABLE " + ::cPreFixTable( "product_attribute_image" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText ( 'Tabla ' + ::cPrefixTable( "product_attribute_image" ) + ' borrada correctamente', 3  )
   else
      ::SetText ( 'Error al borrar la tabla ' + ::cPrefixTable( "product_attribute_image" ), 3  )
   end if

   cCommand          := "TRUNCATE TABLE " + ::cPrefixTable( "product_country_tax" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText ( 'Tabla ' + ::cPrefixTable( "product_country_tax" ) + ' borrada correctamente', 3  )
   else
      ::SetText ( 'Error al borrar la tabla ' + ::cPrefixTable( "product_country_tax" ), 3  )
   end if

   cCommand          := "TRUNCATE TABLE " + ::cPrefixTable( "product_download" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText ( 'Tabla ' + ::cPrefixTable( "product_download" ) + ' borrada correctamente', 3  )
   else
      ::SetText ( 'Error al borrar la table ' + ::cPrefixTable( "product_download" ), 3  )
   end if

   cCommand          := "TRUNCATE TABLE " + ::cPrefixTable( "product_group_reduction_cache" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText ( 'Tabla ' + ::cPrefixTable( "product_group_reduction_cache" ) + ' borrada correctamente', 3  )
   else
      ::SetText ( 'Error al borrar la tabla ' + ::cPrefixTable( "product_group_reduction_cache" ), 3  )
   end if

   cCommand          := "TRUNCATE TABLE " + ::cPrefixTable( "product_shop" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText ( 'Tabla ' + ::cPrefixTable( "product_shop" ) + ' borrada correctamente', 3  )
   else
      ::SetText ( 'Error al borrar la tabla ' + ::cPrefixTable( "product_shop" ), 3  )
   end if

   /*
   Descripciones de artículos-----------------------------------------------
   */

   cCommand          := "TRUNCATE TABLE " + ::cPrefixTable( "product_lang" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText ( 'Tabla ' + ::cPrefixTable( "product_lang" ) + ' borrada correctamente', 3  )
   else
      ::SetText ( 'Error al borrar la tabla ' + ::cPrefixTable( "product_lang" ), 3  )
   end if

   cCommand          := "TRUNCATE TABLE " + ::cPrefixTable( "product_sale" ) 

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText ( 'Tabla ' + ::cPrefixTable( "product_sale" ) + ' borrada correctamente', 3  )
   else
      ::SetText ( 'Error al borrar la tabla ' + ::cPrefixTable( "product_sale" ), 3  )
   end if

   cCommand          := "TRUNCATE TABLE " + ::cPrefixTable( "product_tag" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText ( 'Tabla ' + ::cPrefixTable( "product_tag" ) + ' borrada correctamente', 3  )
   else
      ::SetText ( 'Error al borrar la tabla ' + ::cPrefixTable( "product_tag" ), 3  )
   end if

   
   cCommand          := "TRUNCATE TABLE " + ::cPrefixTable( "specific_price")

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText ( 'Tabla ' + ::cPrefixTable( "specific_price" ) + ' borrada correctamente', 3  )
   else
      ::SetText ( 'Error al borrar la tabla ' + ::cPrefixTable( "specific_price" ), 3  )
   end if

   /*
   Propiedades logistica----------------------------------------------------
   */

   cCommand          := "TRUNCATE TABLE " + ::cPrefixTable( "feature" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText ( 'Tabla '  + ::cPrefixTable( "feature" ) + ' borrada correctamente', 3  )
   else
      ::SetText ( 'Error al borrar la tabla ' + ::cPrefixTable( "feature" ), 3  )
   end if

   cCommand          := "TRUNCATE TABLE " + ::cPrefixTable( "feature_lang" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText ( 'Tabla ' + ::cPrefixTable( "feature_lang" ) + ' borrada correctamente', 3  )
   else
      ::SetText ( 'Error al borrar la tabla ' + ::cPrefixTable( "feature_lang" ), 3  )
   end if

   cCommand          := "TRUNCATE TABLE " + ::cPrefixTable( "feature_product" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText ( 'Tabla ' + ::cPrefixTable( "feature_product" ) + ' borrada correctamente', 3  )
   else
      ::SetText ( 'Error al borrar la tabla ' + ::cPrefixTable( "feature_product" ), 3  )
   end if

   cCommand          := "TRUNCATE TABLE " + ::cPrefixTable( "feature_value" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText ( 'Tabla ' + ::cPrefixTable( "feature_value" ) + ' borrada correctamente', 3  )
   else
      ::SetText ( 'Error al borrar la tabla ' + ::cPrefixTable( "feature_value" ), 3  )
   end if

   cCommand          := "TRUNCATE TABLE " + ::cPrefixTable( "feature_value_lang" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText ( 'Tabla ' + ::cPrefixTable( "feature_value_lang" ) + ' borrada correctamente', 3  )
   else
      ::SetText ( 'Error al borrar la tabla ' + ::cPrefixTable( "feature_value_lang" ), 3  )
   end if

   /*
   Imagenes de escena-------------------------------------------------------
   */

   cCommand          := "TRUNCATE TABLE " + ::cPrefixTable( "scene" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText ( 'Tabla ' + ::cPrefixTable( "scene " ) + ' borrada correctamente', 3  )
   else
      ::SetText ( 'Error al borrar la tabla ' + ::cPrefixTable( "scene" ), 3  )
   end if

   cCommand          := "TRUNCATE TABLE " + ::cPrefixTable( "scene_category" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText ( 'Tabla ' + ::cPrefixTable( "scene_category" ) + ' borrada correctamente', 3  )
   else
      ::SetText ( 'Error al borrar la tabla' + ::cPrefixTable( "scene_category" ), 3  )
   end if

   cCommand          := "TRUNCATE TABLE " + ::cPrefixTable( "scene_lang" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText ( 'Tabla ' + ::cPrefixTable( "scene_lang" ) + ' borrada correctamente', 3  )
   else
      ::SetText ( 'Error al borrar la tabla ' + ::cPrefixTable( "scene_lang" ), 3  )
   end if

   cCommand          := "TRUNCATE TABLE " + ::cPrefixTable( "scene_products" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText ( 'Tabla ' + ::cPrefixTable( "scene_products" ) + ' borrada correctamente', 3  )
   else
      ::SetText ( 'Error al borrar la tabla ' + ::cPrefixTable( "scene_products" ), 3  )
   end if

   ::lLimpiaRefImgWeb()

   /*
   Limpiamos las Id de las tablas del programa------------------------------
   */

   ::DelIdTipoArticuloPrestashop()

   ::oMeterL:Set( 0 )

   ::oMeter:Refresh()

   ::oMeterL:SetTotal( ::oArt:OrdKeyCount() )

   /*
   Añadimos articulos a prestashop---------------------------------------------
   */

   ::oArt:GoTop()

   while !::oArt:Eof()

      if ::oArt:lPubInt

         ::MeterParticularText( "Actualizando artículos" )

         /*
         Metemos las familias como categorías----------------------------------
         */

         ::InsertProductsPrestashop()

      end if

      ::oArt:FieldPutByName( "lSndDoc", .f. )

      ::oArt:Skip()

      ::oMeterL:AutoInc()

   end while

   ::oMeterL:SetTotal( ::oArt:LastRec() )

return ( Self )

//---------------------------------------------------------------------------//

Method ActualizaProductsPrestashop( cCodigoArticulo, lChangeImage ) CLASS TComercio

   local oQuery
   local cCommand

   if !::lReady()
      Return .f.
   end if
   
   ::lShowDialogWait()

   if ::OpenFiles()

      if ::oArt:Seek( cCodigoArticulo )
   
         if ::ConectBBDD()

            do case
               case !::oArt:lPubInt .and. ::oArt:cCodWeb != 0
      
                  ::cTextoWait( "Eliminando artículo en prestashop" )

                  ::DeleteProductsPrestashop()
      
               case ::oArt:lPubInt .and. ::oArt:cCodWeb != 0
      
                  cCommand := 'SELECT * FROM ' + ::cPrefixTable( "product" ) +  ' WHERE id_product=' + AllTrim( Str( ::oArt:cCodWeb ) )
                  oQuery   := TMSQuery():New( ::oCon, cCommand )
      
                  if oQuery:Open()
      
                     if oQuery:RecCount() > 0
      
                        ::cTextoWait( "Actualizando artículo en prestashop" )

                        ::UpdateProductsPrestashop( lChangeImage )
      
                     else
      
                        ::cTextoWait( "Añadiendo artículo en prestashop" )

                        ::InsertProductsPrestashop( .t. )
      
                     end if
      
                  end if
      
                  oQuery:Free()
      
               case ::oArt:lPubInt .and. ::oArt:cCodWeb == 0
      
                  ::cTextoWait( "Añadiendo artículo en prestashop" )

                  ::InsertProductsPrestashop( .t. )
      
            end case   

            ::DisconectBBDD()
   
         endif      

      end if

      ::CloseFiles()

   end if

   ::lHideDialogWait()

Return .t.

//---------------------------------------------------------------------------//

METHOD InsertProductsPrestashop( lExt ) CLASS TComercio

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
   local nParent              := ::GetParentCategories()
   local cCommand             := ""

   DEFAULT lExt               := .f.

   ::lDefImgPrp               := .f.

   /*
   ----------------------------------------------------------------------------
   INSERTAMOS EL ARTÍCULO EN TODAS LAS TABLAS DE PRESTASHOP--------------------
   ----------------------------------------------------------------------------
   */

   ::cTextoWait( "Añadiendo artículo: " + AllTrim( ::oArt:Nombre ) )

   /*
   Insertamos el artículo en la tabla ps_product-------------------------------
   */

   cCommand    := "INSERT INTO " + ::cPrefixTable( "product" ) + ;
                     " ( id_manufacturer, " + ;
                     "id_tax_rules_group, " + ;
                     "id_category_default, " + ;
                     "id_shop_default, " + ;
                     "quantity, " + ;
                     "minimal_quantity, " + ;
                     "price, " + ;
                     "active, " + ;
                     "date_add, " + ;
                     "date_upd )" + ;
                  " VALUES " + ;
                     "('" + AllTrim( Str( oRetFld( ::oArt:cCodFab, ::oFab, "cCodWeb", "cCodFab" ) ) ) + "', " + ; //id_manufacturer
                     "'" + AllTrim( Str( oRetFld( ::oArt:TipoIva, ::oIva, "CGRPWEB", "TIPO" ) ) ) + "', " + ;     //id_tax_rules_group  - tipo IVA
                     "'" + AllTrim( Str( nParent ) ) + "', " + ;                                                  //id_category_default
                     "'1', " + ;                                                                                  //id_shop_default
                     "'1', " + ;                                                                                  //quantity
                     "'1', " + ;                                                                                  //minimal_quantity
                     "'" + if( !Empty( ::oArt:cCodPrp1 ), "0", AllTrim( Str( ::oArt:nImpInt1 ) ) ) + "', " + ;    //price
                     "'1', " + ;                                                                                  //active
                     "'" + dtos( GetSysDate() ) + "', " + ;                                                       //date_add
                     "'" + dtos( GetSysDate() ) + "' )"

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )                                                                                                             //date_upd

      nCodigoWeb           := ::oCon:GetInsertId()

      ::oArt:fieldPutByName( "cCodWeb", nCodigoWeb )

      ::SetText( "He insertado el artículo " + AllTrim( ::oArt:Nombre ) + " correctamente en la tabla " + ::cPrefixTable( "product" ), 3 )

   else

      ::SetText( "Error al insertar el artículo " + AllTrim( ::oArt:Nombre ) + " en la tabla " + ::cPrefixTable( "product" ), 3 )

   end if

   /*
   Insertamos un artículo nuevo en la tabla ps_category_product----------------
    */

   cCommand    := "INSERT INTO " + ::cPrefixTable( "category_product" ) + ; 
                     " ( id_category, " + ;
                     "id_product )" + ;
                  " VALUES " + ;
                     "('" + AllTrim( Str( Max( nParent, 1 ) ) ) + "', " + ;
                     "'" + Str( nCodigoWeb ) + "' )"

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText( "He insertado el artículo " + AllTrim( ::oArt:Nombre ) + " correctamente en la tabla " + ::cPrefixTable( "product_lang" ), 3 )
   else
      ::SetText( "Error al insertar el artículo " + AllTrim( ::oArt:Nombre ) + " en la tabla " + ::cPrefixTable( "category_product" ), 3 )
   end if

   /*
   Insertamos un artículo nuevo en la tabla ps_category_shop-------------------
   */

   cCommand    := "INSERT INTO " + ::cPrefixTable( "product_shop" ) + ;
                     " ( id_product, " + ;
                     "id_shop, " + ;
                     "id_category_default, " + ;
                     "id_tax_rules_group, " + ;
                     "on_sale, " + ;
                     "price, " + ;
                     "active, " + ;
                     "date_add, " + ;
                     "date_upd )" + ;
                  " VALUES " + ;
                     "('" + Str( nCodigoWeb ) + "', " + ;
                     "'1', " + ;
                     "'" + AllTrim( Str( nParent ) ) + "', " + ;
                     "'" + AllTrim( Str( oRetFld( ::oArt:TipoIva, ::oIva, "CGRPWEB", "TIPO" ) ) ) + "', " + ;
                     "'0', " + ;
                     "'" + if( !Empty( ::oArt:cCodPrp1 ), "0", AllTrim( Str( ::oArt:nImpInt1 ) ) ) + "', " + ;
                     "'1', " + ;
                     "'" + dtos( GetSysDate() ) + "', " + ;
                     "'" + dtos( GetSysDate() ) + "' )"

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText( "He insertado el artículo " + AllTrim( ::oArt:Nombre ) + " correctamente en la tabla " + ::cPrefixTable( "product_shop" ), 3 )
   else
      ::SetText( "Error al insertar el artículo " + AllTrim( ::oArt:Nombre ) + " en la tabla " + ::cPrefixTable( "product_shop" ), 3 )
   end if

   /*
   Insertamos un artículo nuevo en la tabla ps_product_lang--------------------
   */

   cCommand    := "INSERT INTO " + ::cPrefixTable( "product_lang" ) +;
                     " ( id_product, " + ;
                     "id_lang, " + ;
                     "description, " + ;
                     "description_short, " + ;
                     "link_rewrite, " + ;
                     "name, " + ;
                     "available_now, " + ;
                     "available_later )" + ;
                  " VALUES " + ;
                     "('" + Str( nCodigoWeb ) + "', " + ;               // id_product
                     "'" + Str( ::nLanguage ) + "', " + ;               // id_lang
                     "'" + if( !Empty( ::oArt:mDesTec ), AllTrim( ::oArt:mDesTec ), AllTrim( ::oArt:Nombre ) ) + "', " + ;        // description
                     "'" + AllTrim( ::oArt:Nombre ) + "', " + ;         // description_short
                     "'" + cLinkRewrite( ::oArt:Nombre ) + "', " + ;    // link_rewrite
                     "'" + AllTrim( ::oArt:Nombre ) + "', " + ;         // name
                     "'En stock', " + ;                                 // avatible_now
                     "'' )"

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText( "He insertado el artículo " + AllTrim( ::oArt:Nombre ) + " correctamente en la tabla " + ::cPrefixTable( "product_lang" ), 3 )
   else
      ::SetText( "Error al insertar el artículo " + AllTrim( ::oArt:Nombre ) + " en la tabla " + ::cPrefixTable( "product_lang" ), 3 )
   end if

   SysRefresh()

   /*
   ----------------------------------------------------------------------------
   Insertamos las imágenes del producto----------------------------------------
   ----------------------------------------------------------------------------
   */

   ::cTextoWait( "Añadiendo imágenes artículo: " + AllTrim( ::oArt:Nombre ) )

   ::InsertImageProductsPrestashop()

   /*
   ----------------------------------------------------------------------------
   Insertamos las imágenes del producto----------------------------------------
   ----------------------------------------------------------------------------
   */

   ::cTextoWait( "Añadiendo propiedades del artículo: " + AllTrim( ::oArt:Nombre ) )

   ::InsertPropiedadesProductPrestashop( ::oArt:Codigo )

   /*
   ----------------------------------------------------------------------------
   Subimos las imágenes si no es una global------------------------------------
   ----------------------------------------------------------------------------
   */

   if lExt
      ::AppendImagesPrestashop()
   end if   

return nCodigoweb

//---------------------------------------------------------------------------//

METHOD InsertImageProductsPrestashop() CLASS TComercio

   local cCommand          := ""
   local nCodigoImagen     := 0
   local oImagen
   local nOrdAnt
   local nPosition         := 1

   /*
   ----------------------------------------------------------------------------
   INSERTAMOS IMAGENES DEL ARTÍCULO EN CONCRETO--------------------------------
   ----------------------------------------------------------------------------
   */

   nOrdAnt        := ::oArtImg:OrdSetFocus( "cCodArt" )

   if !::oArtImg:Seek( ::oArt:Codigo )

      /*
      Tiene una sola imagen seleccionada---------------------------------------
      */

      if !Empty( ::oArt:cImagen )

         cCommand := "INSERT INTO " + ::cPrefixTable( "image" ) + ;
                        " ( id_product, " + ;
                        "position, " + ;
                        "cover )" + ;
                     " VALUES " + ;
                        "('" + AllTrim( Str( ::oArt:cCodWeb ) ) + "', " + ; //id_product
                        "'" + Str( nPosition ) + "', " + ;              //position
                        "'1' )"

         if TMSCommand():New( ::oCon ):ExecDirect( cCommand )

            nCodigoImagen           := ::oCon:GetInsertId()

            ::SetText( "He insertado el artículo " + AllTrim( ::oArt:Nombre ) + " correctamente en la tabla " + ::cPrefixTable( "image" ), 3 )

         else

            ::SetText( "Error al insertar el artículo " + AllTrim( ::oArt:Nombre ) + " en la tabla " + ::cPreFixTable( "image" ), 3 )

         end if

         cCommand := "INSERT INTO " + ::cPrefixTable( "image_shop" ) + ;
                        " (  id_image, " + ;
                        "id_shop, " + ;
                        "cover )" + ;
                     " VALUES " + ;
                        "('" + AllTrim( Str( nCodigoImagen ) ) + "', " + ;
                        "'1', " + ;
                        "'1' )"

         if TMSCommand():New( ::oCon ):ExecDirect( cCommand )

            ::SetText( "He insertado el artículo " + AllTrim( ::oArt:Nombre ) + " correctamente en la tabla " + ::cPrefixTable( "image_shop" ), 3 )

         else

            ::SetText( "Error al insertar el artículo " + AllTrim( ::oArt:Nombre ) + " en la tabla " + ::cPrefixTable( "image_shop" ), 3 )

         end if

         /*
         Añadimos la imagen al array para pasarla a prestashop--------------
         */

         oImagen                       := SImagen()
         oImagen:cNombreImagen         := ::oArt:cImagen
         oImagen:nTipoImagen           := tipoProducto
         oImagen:cCarpeta              := AllTrim( Str( nCodigoImagen ) )
         oImagen:cPrefijoNombre        := AllTrim( Str( nCodigoImagen ) )

         ::AddImages( oImagen )

         nPosition++

      end if

   else

      /*
      Metemos las imágenes desde la tabla de imágenes del programa-------
      */

      while ::oArtImg:cCodArt == ::oArt:Codigo .and. !::oArtImg:Eof()

         cCommand := "INSERT INTO " + ::cPrefixTable( "image" ) + ;
                        " ( id_product, " + ;
                        "position, " + ;
                        "cover )" + ;
                     " VALUES " + ;
                        "('" + AllTrim( Str( ::oArt:cCodWeb ) ) + "', " + ;
                        "'" + Str( nPosition ) + "', " + ;
                        "'" + if( ::oArtImg:lDefImg, "1", "0" ) + "' )"

         if TMSCommand():New( ::oCon ):ExecDirect( cCommand )

            nCodigoImagen           := ::oCon:GetInsertId()

            ::oArtImg:fieldPutByName( "cCodWeb", nCodigoImagen )

            ::SetText( "He insertado el artículo " + AllTrim( ::oArt:Nombre ) + " correctamente en la tabla " + ::cPrefixTable( "image" ), 3 )

         else
            ::SetText( "Error al insertar el artículo " + AllTrim( ::oArt:Nombre ) + " en la tabla " + ::cPrefixTable( "image" ), 3 )
         end if

         /*
         Metemos los ToolTip de las imágenes--------------------------
         */

         cCommand := "INSERT INTO " + ::cPrefixTable( "image_lang" ) + ;
                        " ( id_image, " + ;
                        "id_lang, " + ;
                        "legend )" + ;
                     " VALUES " + ;
                        "('" + AllTrim( Str( nCodigoImagen ) ) + "', " + ;
                        "'" + AllTrim( Str( ::nLanguage ) ) + "', " + ;
                        "'" + AllTrim( ::oArtImg:cNbrArt ) + "' )"

         if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
            ::SetText( "He insertado el artículo " + AllTrim( ::oArt:Nombre ) + " correctamente en la tabla " + ::cPrefixTable( "image_lang" ), 3 )
         else
            ::SetText( "Error al insertar el artículo " + AllTrim( ::oArt:Nombre ) + " en la tabla " + ::cPrefixTable( "image_lang" ), 3 )
         end if

         cCommand := "INSERT INTO " + ::cPrefixTable( "image_shop" ) + ;
                        "(  id_image, " + ;
                        "id_shop, " + ;
                        "cover )" + ;
                     " VALUES " + ;
                        "('" + AllTrim( Str( nCodigoImagen ) ) + "', " + ;
                        "'1', " + ;
                        "'" + if( ::oArtImg:lDefImg, "1", "0" ) + "' )"

         if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
            ::SetText( "He insertado el artículo " + AllTrim( ::oArt:Nombre ) + " correctamente en la tabla " + ::cPrefixTable( "image_shop" ), 3 )
         else
            ::SetText( "Error al insertar el artículo " + AllTrim( ::oArt:Nombre ) + " en la tabla " + ::cPreFixTable( "image_shop" ), 3 )
         end if

         /*
         Añadimos la imagen al array para pasarla a prestashop--------------
         */

         oImagen                       := SImagen()
         oImagen:cNombreImagen         := ::oArtImg:cImgArt
         oImagen:nTipoImagen           := tipoProducto
         oImagen:cCarpeta              := AllTrim( Str( nCodigoImagen ) )
         oImagen:cPrefijoNombre        := AllTrim( Str( nCodigoImagen ) )

         ::AddImages( oImagen )

         ::oArtImg:Skip()

         nPosition++

         SysRefresh()

      end while

   end if

   ::oArtImg:OrdSetFocus( nOrdAnt )

Return .t.

//---------------------------------------------------------------------------//

METHOD UpdateProductsPrestashop( lChangeImage ) CLASS TComercio

   local cCommand    := ""
   local lReturn     := .f.
   local nParent     := ::GetParentCategories()

   /*
   ----------------------------------------------------------------------------
   ACTUALIZAMOS LAS TABLAS DE ARTÍCULO-----------------------------------------
   ----------------------------------------------------------------------------
   */

   ::cTextoWait( "Modificando artículo: " + AllTrim( ::oArt:Nombre ) )

   cCommand          := "UPDATE " + ::cPrefixTable( "product" ) + " SET " + ;
                           "id_manufacturer='" + AllTrim( Str( oRetFld( ::oArt:cCodFab, ::oFab, "CCODWEB", "CCODFAB" ) ) ) + "', " + ;
                           "id_tax_rules_group='" + AllTrim( Str( oRetFld( ::oArt:TipoIva, ::oIva, "CGRPWEB", "TIPO" ) ) ) + "', " + ;
                           "id_category_default='" + AllTrim( Str( nParent ) ) + "', " + ;
                           "price='" + if( !Empty( ::oArt:cCodPrp1 ), "0", AllTrim( Str( ::oArt:nImpInt1 ) ) ) + "', " + ;
                           "date_upd='" + AllTrim( dtoc( GetSysDate() ) ) + "' " + ;
                        "WHERE id_product=" + AllTrim( Str( ::oArt:cCodWeb ) )

   lReturn           := TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   cCommand          := "UPDATE " + ::cPrefixTable( "product_lang" ) + " SET " + ;
                           "description='" + if( !Empty( ::oArt:mDesTec ), AllTrim( ::oArt:mDesTec ), AllTrim( ::oArt:Nombre ) ) + "', " + ;
                           "description_short='" + AllTrim( ::oArt:Nombre ) + "', " + ;
                           "name='" + AllTrim( ::oArt:Nombre ) + "' " + ;
                        "WHERE id_product=" + AllTrim( Str( ::oArt:cCodWeb ) )

   lReturn           := TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   cCommand          := "UPDATE " + ::cPrefixTable( "product_shop" ) + " SET " + ;
                           "id_category_default='" + AllTrim( Str( nParent ) ) + "', " + ;
                           "price='" + if( !Empty( ::oArt:cCodPrp1 ), "0", AllTrim( Str( ::oArt:nImpInt1 ) ) ) + "', " + ;
                           "date_upd='" + AllTrim( dtoc( GetSysDate() ) ) + "' " + ;
                        "WHERE id_product=" + AllTrim( Str( ::oArt:cCodWeb ) )

   lReturn           := TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   cCommand          := "UPDATE " + ::cPrefixTable( "category_product" ) + " SET " + ;
                           "id_category='" + AllTrim( Str( nParent ) ) + "' " + ;
                        "WHERE id_product=" + AllTrim( Str( ::oArt:cCodWeb ) )

   lReturn           := TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   /*
   ----------------------------------------------------------------------------
   ACTUALIZAMOS IMAGENES DEL ARTÍCULO------------------------------------------
   ----------------------------------------------------------------------------
   */

   SysRefresh()

   if lChangeImage

      ::DeleteImagesProducts( ::oArt:cCodWeb )

      SysRefresh()

      ::InsertImageProductsPrestashop()

      SysRefresh()

      ::AppendImagesPrestashop()

   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD DeleteProductsPrestashop() CLASS TComercio

   local idDelete    := 0
   local idDelete2   := 0
   local cCommand    := ""
   local oQuery
   local oQuery2

   ::cTextoWait( "Eliminando artículo de prestashop"  )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "product" ) + " WHERE id_product=" + AllTrim( Str( ::oArt:cCodWeb ) )
   TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "product_attachment" ) + " WHERE id_product=" + AllTrim( Str( ::oArt:cCodWeb ) )
   TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "product_country_tax" ) + " WHERE id_product=" + AllTrim( Str( ::oArt:cCodWeb ) )
   TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "product_download" ) + " WHERE id_product=" + AllTrim( Str( ::oArt:cCodWeb ) )
   TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "product_group_reduction_cache" ) + " WHERE id_product=" + AllTrim( Str( ::oArt:cCodWeb ) )
   TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "product_shop" ) + " WHERE id_product=" + AllTrim( Str( ::oArt:cCodWeb ) )
   TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "product_lang" ) + " WHERE id_product=" + AllTrim( Str( ::oArt:cCodWeb ) )
   TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "product_sale" ) + " WHERE id_product=" + AllTrim( Str( ::oArt:cCodWeb ) )
   TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "product_tag" ) + " WHERE id_product=" + AllTrim( Str( ::oArt:cCodWeb ) )
   TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "product_supplier" ) + " WHERE id_product=" + AllTrim( Str( ::oArt:cCodWeb ) )
   TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "product_carrier" ) + " WHERE id_product=" + AllTrim( Str( ::oArt:cCodWeb ) )
   TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   cCommand          := 'SELECT * FROM ' + ::cPrefixTable( "product_attribute" ) +  ' WHERE id_product=' + AllTrim( Str( ::oArt:cCodWeb ) )
   oQuery            := TMSQuery():New( ::oCon, cCommand )
   
   if oQuery:Open()
   
      if oQuery:RecCount() > 0

         idDelete    := oQuery:FieldGetByName( "id_product_attribute" )

         cCommand          := "DELETE FROM " + ::cPrefixTable( "product_attribute" ) + " WHERE id_product_attribute=" + AllTrim( Str( idDelete ) )
         TMSCommand():New( ::oCon ):ExecDirect( cCommand )

         cCommand          := "DELETE FROM " + ::cPrefixTable( "product_attribute_combination" ) + " WHERE id_product_attribute=" + AllTrim( Str( idDelete ) )
         TMSCommand():New( ::oCon ):ExecDirect( cCommand )

         cCommand          := "DELETE FROM " + ::cPrefixTable( "product_attribute_image" ) + " WHERE id_product_attribute=" + AllTrim( Str( idDelete ) )
         TMSCommand():New( ::oCon ):ExecDirect( cCommand )

         cCommand          := "DELETE FROM " + ::cPrefixTable( "product_attribute_shop" ) + " WHERE id_product_attribute=" + AllTrim( Str( idDelete ) )
         TMSCommand():New( ::oCon ):ExecDirect( cCommand )
   
      end if

   end if

   cCommand          := "DELETE FROM " + ::cPrefixTable( "specific_price" ) + " WHERE id_product=" + AllTrim( Str( ::oArt:cCodWeb ) )
   TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "specific_price_priority" ) + " WHERE id_product=" + AllTrim( Str( ::oArt:cCodWeb ) )
   TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   cCommand          := 'SELECT * FROM ' + ::cPrefixTable( "feature_product" ) +  ' WHERE id_product=' + AllTrim( Str( ::oArt:cCodWeb ) )
   oQuery            := TMSQuery():New( ::oCon, cCommand )
   
   if oQuery:Open()
   
      if oQuery:RecCount() > 0

         idDelete    := oQuery:FieldGetByName( "id_feature" )

         cCommand          := "DELETE FROM " + ::cPrefixTable( "feature_product" ) + " WHERE id_product=" + AllTrim( Str( ::oArt:cCodWeb ) )
         TMSCommand():New( ::oCon ):ExecDirect( cCommand )

         cCommand          := "DELETE FROM " + ::cPrefixTable( "feature" ) + " WHERE id_feature=" + AllTrim( Str( idDelete ) )
         TMSCommand():New( ::oCon ):ExecDirect( cCommand )

         cCommand          := "DELETE FROM " + ::cPrefixTable( "feature_lang" ) + " WHERE id_feature=" + AllTrim( Str( idDelete ) )
         TMSCommand():New( ::oCon ):ExecDirect( cCommand )

         cCommand          := "DELETE FROM " + ::cPrefixTable( "feature_shop" ) + " WHERE id_feature=" + AllTrim( Str( idDelete ) )
         TMSCommand():New( ::oCon ):ExecDirect( cCommand )

         cCommand          := 'SELECT * FROM ' + ::cPrefixTable( "feature_value" ) +  ' WHERE id_feature=' + AllTrim( Str( idDelete ) )
         oQuery2           := TMSQuery():New( ::oCon, cCommand )

         if oQuery2:Open()
   
            if oQuery2:RecCount() > 0

               idDelete2    := oQuery:FieldGetByName( "id_feature_value" )

               cCommand          := "DELETE FROM " + ::cPrefixTable( "feature_value" ) + " WHERE id_feature_value=" + AllTrim( Str( idDelete2 ) )
               TMSCommand():New( ::oCon ):ExecDirect( cCommand )

               cCommand          := "DELETE FROM " + ::cPrefixTable( "feature_value_lang" ) + " WHERE id_feature_value=" + AllTrim( Str( idDelete2 ) )
               TMSCommand():New( ::oCon ):ExecDirect( cCommand )

            end if

         end if   
   
      end if

   end if

   SysRefresh()

   /*
   Eliminamos las imágenes del artículo---------------------------------------
   */

   ::cTextoWait( "Eliminando imágenes de prestashop" )

   ::DeleteImagesProducts( ::oArt:cCodWeb )

   SysRefresh()

   /*
   Quitamos la referencia de nuestra tabla-------------------------------------
   */

   ::oArt:fieldPutByName( "cCodWeb", 0 )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD DeleteImagesProducts( cCodProduct ) CLASS TComercio 

   local oInt
   local oFtp
   local aDirectory
   local cDirectory
   local lError
   local idDelete
   local oQuery
   local cCommand    := ""
   local aDelImages  := {}

   if !Empty( cCodProduct )
      
      /*
      Limpiamos la refecencia en la base de datos------------------------------
      */

      cCommand          := 'SELECT * FROM ' + ::cPrefixTable( "image" ) +  ' WHERE id_product=' + AllTrim( Str( cCodProduct ) )
      oQuery            := TMSQuery():New( ::oCon, cCommand )
   

      if oQuery:Open() .and. oQuery:RecCount() > 0

         oQuery:GoTop()

         while !oQuery:Eof()

            idDelete    := oQuery:FieldGet( 1 )

            aAdd( aDelImages, idDelete )

            cCommand          := "DELETE FROM " + ::cPrefixTable( "image" ) + " WHERE id_image=" + AllTrim( Str( idDelete ) )
            TMSCommand():New( ::oCon ):ExecDirect( cCommand )

            cCommand          := "DELETE FROM " + ::cPrefixTable( "image_shop" ) + " WHERE id_image=" + AllTrim( Str( idDelete ) )
            TMSCommand():New( ::oCon ):ExecDirect( cCommand )

            cCommand          := "DELETE FROM " + ::cPrefixTable( "image_lang" ) + " WHERE id_image=" + AllTrim( Str( idDelete ) )
            TMSCommand():New( ::oCon ):ExecDirect( cCommand )
         
            oQuery:Skip()

            SysRefresh()

         end while

      end if

      oQuery:Free()

      /*
      Conectamos al FTP para eliminar las imagenes del articulo----------------
      */

      /*oInt         := TInternet():New()
      oFtp         := TFtp():New( ::cHostFtp, oInt, ::cUserFtp, ::cPasswdFtp, ::lPassiveFtp )

      if Empty( oFtp ) .or. Empty( oFtp:hFtp )

         MsgStop( "Imposible conectar al sitio ftp " + ::cHostFtp )

      else

         if !Empty( ::cDImagen )
            
            for each idDelete in aDelImages

               oFtp:SetCurrentDirectory( ::cDImagen + "/p/" + AllTrim( Str( idDelete ) ) )
            
               oFtp:DeleteMask()

               oFtp:SetCurrentDirectory( ".." )

               oFtp:RemoveDirectory( ::cDImagen + "/p/" + AllTrim( Str( idDelete ) ) )

            next

         end if

      end if

      if !Empty( oInt )
         oInt:end()
      end if

      if !Empty( oFtp )
         oFtp:end()
      end if*/

      if !Empty( ::cDImagen )
            
         for each idDelete in aDelImages

            oInt         := TInternet():New()
            oFtp         := TFtp():New( ::cHostFtp, oInt, ::cUserFtp, ::cPasswdFtp, ::lPassiveFtp )

            if Empty( oFtp ) .or. Empty( oFtp:hFtp )

               MsgStop( "Imposible conectar al sitio ftp " + ::cHostFtp )

            else

               oFtp:SetCurrentDirectory( ::cDImagen + "/p/" + AllTrim( Str( idDelete ) ) )
            
               oFtp:DeleteMask()

               //oFtp:RemoveDirectory( ::cDImagen + "/p/" + AllTrim( Str( idDelete ) ) )

            end if 
               
            if !Empty( oInt )
               oInt:end()
            end if

            if !Empty( oFtp )
               oFtp:end()
            end if  

         next

      end if

   end if

   SysRefresh()

Return nil

//---------------------------------------------------------------------------//

METHOD InsertPropiedadesProductPrestashop( cCodArt ) CLASS TComercio

   local nOrdArtDiv           := ::oArtDiv:OrdSetFocus( "cCodArt" )

/*
         Comprobamos si el artículo tiene propiedades y metemos las propiedades
         */

         /*if ::oArtDiv:Seek( ::oArt:Codigo )

            while ::oArtDiv:cCodArt == ::oArt:Codigo .and. !::oArtDiv:Eof()

               do case

                  /*
                  Caso de tener una sola propiedad-----------------------------
                  */

         /*         case !Empty( ::oArtDiv:cValPr1 ) .and. Empty( ::oArtDiv:cValPr2 )

                     nOrdAnt  :=   ::oTblPro:OrdSetFocus( "cCodPro" )

                     if ::oTblPro:Seek( ::oArtDiv:cCodPr1 + ::oArtDiv:cValPr1 )

                        nPrecio     := nPrePro( ::oArt:Codigo, ::oArtDiv:cCodPr1, ::oArtDiv:cValPr1, Space( 10 ), Space( 10 ), 1, .f., ::oArtDiv:cAlias )

                        /*
                        Metemos la propiedad de éste artículo---------------------
                        */

         /*               if TMSCommand():New( ::oCon ):ExecDirect( "INSERT INTO ps_product_attribute ( id_product, " + ;
                                                                                                     "price, " + ;
                                                                                                     "wholesale_price, " + ;
                                                                                                     "quantity, " + ;
                                                                                                     "minimal_quantity )" + ;
                                                                                            " VALUES " + ;
                                                                                                     "('" + AllTrim( Str( nCodigoWeb ) ) + "', " + ;      //id_product
                                                                                                     "'" + AllTrim( Str( if( nPrecio != 0, nPrecio, ::oArt:nImpInt1 ) ) ) + "', " + ;  //price
                                                                                                     "'" + AllTrim( Str( if( nPrecio != 0, nPrecio, ::oArt:nImpInt1 ) ) ) + "', " + ;  //wholesale_price
                                                                                                     "'10000', " + ;                                      //quantity
                                                                                                     "'1' )" )                                            //minimal_quantity

                           nCodigoPropiedad           := ::oCon:GetInsertId()

                           ::SetText( "He insertado la propiedad  " + AllTrim( ::oTblPro:cDesTbl ) + " correctamente en la tabla ps_product_attribute", 3 )

                        else
                           ::SetText( "Error al insertar la propiedad " + AllTrim( ::oTblPro:cDesTbl ) + " en la tabla ps_product_attribute", 3 )
                        end if

                        /*
                        Metemos la relación de la propiedad con el artículo-------
                        */

           /*             if TMSCommand():New( ::oCon ):ExecDirect( "INSERT INTO ps_product_attribute_combination ( id_attribute, " + ;
                                                                                                                 "id_product_attribute )" + ;
                                                                                                        " VALUES " + ;
                                                                                                                 "('" + AllTrim( Str( ::oTblPro:cCodWeb ) ) + "', " + ;   //id_attribute
                                                                                                                 "'" + AllTrim( Str( nCodigoPropiedad ) ) + "' )" )       //id_product_attribute

                           ::SetText( "He insertado la propiedad  " + AllTrim( ::oTblPro:cDesTbl ) + " correctamente en la tabla ps_product_attribute_combination", 3 )

                        else
                           ::SetText( "Error al insertar la propiedad " + AllTrim( ::oTblPro:cDesTbl ) + " en la tabla ps_product_attribute_combination", 3 )
                        end if

                        /*
                        Imágenes para una sola propiedad--------------------------
                        */

           //             if !Empty( ::oArtDiv:cImgWeb )

                           /*
                           Metemos la imagen en la tabla de imágenes de prestashop
                           */

           /*                if TMSCommand():New( ::oCon ):ExecDirect( "INSERT INTO ps_image ( id_product, " + ;
                                                                                             "position, " + ;
                                                                                             "cover )" + ;
                                                                                    " VALUES " + ;
                                                                                             "('" + AllTrim( Str( nCodigoWeb ) ) + "', " + ;   //id_product
                                                                                             "'" + Str( nPosition ) + "', " + ;                //position
                                                                                             "'" + Str( ::nDefImagen( ::oArt:Codigo, ::oArtDiv:cImgWeb ) ) + "' )" ) //cover

                              nCodigoImagen           := ::oCon:GetInsertId()

                              /*
                              Guardamos el código asignado por la web en la tabla de propiedades
                              */

             //                 ::oArtDiv:fieldPutByName( "cCodImgWeb", nCodigoImagen )

                              /*
                              Guardamos el código asignado por la web en la tabla de imágenes
                              */

             /*                 if ::oArtImg:SeekInOrd( ::oArt:Codigo, "cCodArt" )

                                 while ::oArtImg:cCodArt == ::oArt:Codigo .and. !::oArtImg:Eof()

                                    if ::oArtImg:cImgArt == ::oArtDiv:cImgWeb

                                       ::oArtImg:fieldPutByName( "cCodWeb", nCodigoImagen )

                                    end if

                                    ::oArtImg:Skip()

                                 end while

                              end if

                              ::SetText( "He insertado el artículo " + AllTrim( ::oArt:Nombre ) + " correctamente en la tabla ps_image", 3 )

                           else
                              ::SetText( "Error al insertar el artículo " + AllTrim( ::oArt:Nombre ) + " en la tabla ps_image", 3 )
                           end if

                           /*
                           Metemos los ToolTip de las imágenes--------------------------
                           */

             /*              if TMSCommand():New( ::oCon ):ExecDirect( "INSERT INTO ps_image_lang ( id_image, " + ;
                                                                                                  "id_lang, " + ;
                                                                                                  "legend )" + ;
                                                                                         " VALUES " + ;
                                                                                                  "('" + AllTrim( Str( nCodigoImagen ) ) + "', " + ;   //id_image
                                                                                                  "'" + AllTrim( Str( ::nLanguage ) ) + "', " + ;      //id_lang
                                                                                                  "'" + AllTrim( ::oArtDiv:cToolTip ) + "' )" )        //legend

                              ::SetText( "He insertado el artículo " + AllTrim( ::oArt:Nombre ) + " correctamente en la tabla ps_image_lang", 3 )

                           else
                              ::SetText( "Error al insertar el artículo " + AllTrim( ::oArt:Nombre ) + " en la tabla ps_image_lang", 3 )
                           end if

                           /*
                           Añadimos la imagen al array para pasarla a prestashop--------------
                           */

             /*              oImagen                       := SImagen()
                           oImagen:cNombreImagen         := ::oArtDiv:cImgWeb
                           oImagen:nTipoImagen           := tipoProducto
                           oImagen:cPrefijoNombre        := AllTrim( Str( nCodigoWeb ) ) + "-" + AllTrim( Str( nCodigoImagen ) )

                           ::AddImages( oImagen )

                           nPosition++

                           /*
                           Añadimos en la tabla ps_product_attribute_image
                           */

             /*              if TMSCommand():New( ::oCon ):ExecDirect( "INSERT INTO ps_product_attribute_image ( id_product_attribute, " + ;
                                                                                                               "id_image )" + ;
                                                                                                      " VALUES " + ;
                                                                                                               "('" + AllTrim( Str( nCodigoPropiedad ) ) + "', " + ;   //id_product
                                                                                                               "'" + AllTrim( Str( nCodigoImagen ) ) + "' )" ) //cover

                              ::SetText( "He insertado el artículo " + AllTrim( ::oArt:Nombre ) + " correctamente en la tabla ps_product_attribute_image", 3 )

                           else
                              ::SetText( "Error al insertar el artículo " + AllTrim( ::oArt:Nombre ) + " en la tabla ps_product_attribute_image", 3 )
                           end if

                        end if

                     end if

                  /*
                  Caso de tener dos propiedades--------------------------------
                  */

            /*      case !Empty( ::oArtDiv:cValPr1 ) .and. !Empty( ::oArtDiv:cValPr2 )

                     nPrecio     := nPrePro( ::oArt:Codigo, ::oArtDiv:cCodPr1, ::oArtDiv:cValPr1, ::oArtDiv:cCodPr2, ::oArtDiv:cValPr2, 1, .f., ::oArtDiv:cAlias )

                     /*
                     Metemos la propiedad de éste artículo---------------------
                     */

            /*         if TMSCommand():New( ::oCon ):ExecDirect( "INSERT INTO ps_product_attribute ( id_product, " + ;
                                                                                                  "price, " + ;
                                                                                                  "wholesale_price, " + ;
                                                                                                  "quantity, " + ;
                                                                                                  "minimal_quantity )" + ;
                                                                                         " VALUES " + ;
                                                                                                  "('" + AllTrim( Str( nCodigoWeb ) ) + "', " + ;      //id_product
                                                                                                  "'" + AllTrim( Str( if( nPrecio != 0, nPrecio, ::oArt:nImpInt1 ) ) ) + "', " + ;  //price
                                                                                                  "'" + AllTrim( Str( if( nPrecio != 0, nPrecio, ::oArt:nImpInt1 ) ) ) + "', " + ;  //wholesale_price
                                                                                                  "'10000', " + ;                                      //quantity
                                                                                                  "'1' )" )                                            //minimal_quantity

                        nCodigoPropiedad           := ::oCon:GetInsertId()

                        ::SetText( "He insertado la propiedad  " + AllTrim( ::oArtDiv:cValPr1 ) + " - " + AllTrim( ::oArtDiv:cValPr2 ) + " correctamente en la tabla ps_product_attribute", 3 )

                     else
                        ::SetText( "Error al insertar la propiedad " + AllTrim( ::oArtDiv:cValPr1 ) + " - " + AllTrim( ::oArtDiv:cValPr2 ) + " en la tabla ps_product_attribute", 3 )
                     end if

                     /*
                     Metemos la relación de la propiedad1 con el artículo---
                     */

            /*         nOrdAnt  :=   ::oTblPro:OrdSetFocus( "cCodPro" )

                     if ::oTblPro:Seek( ::oArtDiv:cCodPr1 + ::oArtDiv:cValPr1 )

                        if TMSCommand():New( ::oCon ):ExecDirect( "INSERT INTO ps_product_attribute_combination ( id_attribute, " + ;
                                                                                                                 "id_product_attribute )" + ;
                                                                                                        " VALUES " + ;
                                                                                                                 "('" + AllTrim( Str( ::oTblPro:cCodWeb ) ) + "', " + ;   //id_attribute
                                                                                                                 "'" + AllTrim( Str( nCodigoPropiedad ) ) + "' )" )       //id_product_attribute

                           ::SetText( "He insertado la propiedad  " + AllTrim( ::oTblPro:cDesTbl ) + " correctamente en la tabla ps_product_attribute_combination", 3 )

                        else
                           ::SetText( "Error al insertar la propiedad " + AllTrim( ::oTblPro:cDesTbl ) + " en la tabla ps_product_attribute_combination", 3 )
                        end if

                     end if

                     /*
                     Metemos la relación de la propiedad 2 con el artículo--
                     */

            /*         if ::oTblPro:Seek( ::oArtDiv:cCodPr2 + ::oArtDiv:cValPr2 )

                        if TMSCommand():New( ::oCon ):ExecDirect( "INSERT INTO ps_product_attribute_combination ( id_attribute, " + ;
                                                                                                                 "id_product_attribute )" + ;
                                                                                                        " VALUES " + ;
                                                                                                                 "('" + AllTrim( Str( ::oTblPro:cCodWeb ) ) + "', " + ;   //id_attribute
                                                                                                                 "'" + AllTrim( Str( nCodigoPropiedad ) ) + "' )" )       //id_product_attribute

                           ::SetText( "He insertado la propiedad  " + AllTrim( ::oTblPro:cDesTbl ) + " correctamente en la tabla ps_product_attribute_combination", 3 )

                        else
                           ::SetText( "Error al insertar la propiedad " + AllTrim( ::oTblPro:cDesTbl ) + " en la tabla ps_product_attribute_combination", 3 )
                        end if

                     end if

                     ::oTblPro:OrdSetFocus( nOrdAnt )

                     /*
                     Imágenes para dos propiedades-----------------------------
                     */

            /*         if !Empty( ::oArtDiv:cImgWeb )

                        if aScan( ::aImages, {|aVal| AllTrim( aVal:cNombreImagen ) == AllTrim( ::oArtDiv:cImgWeb ) } ) == 0

                           /*
                           Metemos la imagen en la tabla de imágenes de prestashop
                           */

            /*               if TMSCommand():New( ::oCon ):ExecDirect( "INSERT INTO ps_image ( id_product, " + ;
                                                                                             "position, " + ;
                                                                                             "cover )" + ;
                                                                                    " VALUES " + ;
                                                                                             "('" + AllTrim( Str( nCodigoWeb ) ) + "', " + ;   //id_product
                                                                                             "'" + Str( nPosition ) + "', " + ;                //position
                                                                                             "'" + Str( ::nDefImagen( ::oArt:Codigo, ::oArtDiv:cImgWeb ) ) + "' )" ) //cover

                              nCodigoImagen           := ::oCon:GetInsertId()

                              /*
                              Guardamos el código asignado por la web en la tabla de propiedades
                              */

              //                ::oArtDiv:fieldPutByName( "cCodImgWeb", nCodigoImagen )

                              /*
                              Guardamos el código asignado por la web en la tabla de imágenes
                              */

              /*                if ::oArtImg:SeekInOrd( ::oArt:Codigo, "cCodArt" )

                                 while ::oArtImg:cCodArt == ::oArt:Codigo .and. !::oArtImg:Eof()

                                    if ::oArtImg:cImgArt == ::oArtDiv:cImgWeb

                                       ::oArtImg:fieldPutByName( "cCodWeb", nCodigoImagen )

                                       end if

                                    ::oArtImg:Skip()

                                 end while

                              end if

                              ::SetText( "He insertado el artículo " + AllTrim( ::oArt:Nombre ) + " correctamente en la tabla ps_image", 3 )

                           else
                              ::SetText( "Error al insertar el artículo " + AllTrim( ::oArt:Nombre ) + " en la tabla ps_image", 3 )
                           end if

                           /*
                           Metemos los ToolTip de las imágenes--------------------------
                           */

              /*             if TMSCommand():New( ::oCon ):ExecDirect( "INSERT INTO ps_image_lang ( id_image, " + ;
                                                                                                  "id_lang, " + ;
                                                                                                  "legend )" + ;
                                                                                            " VALUES " + ;
                                                                                                  "('" + AllTrim( Str( nCodigoImagen ) ) + "', " + ;   //id_image
                                                                                                  "'" + AllTrim( Str( ::nLanguage ) ) + "', " + ;      //id_lang
                                                                                                  "'" + AllTrim( ::oArtDiv:cToolTip ) + "' )" )        //legend

                              ::SetText( "He insertado el artículo " + AllTrim( ::oArt:Nombre ) + " correctamente en la tabla ps_image_lang", 3 )

                           else
                              ::SetText( "Error al insertar el artículo " + AllTrim( ::oArt:Nombre ) + " en la tabla ps_image_lang", 3 )
                           end if

                           /*
                           Añadimos la imagen al array para pasarla a prestashop--------------
                           */

              /*             oImagen                       := SImagen()
                           oImagen:cNombreImagen         := ::oArtDiv:cImgWeb
                           oImagen:nTipoImagen           := tipoProducto
                           oImagen:cPrefijoNombre        := AllTrim( Str( nCodigoWeb ) ) + "-" + AllTrim( Str( nCodigoImagen ) )

                           ::AddImages( oImagen )

                           nPosition++

                           /*
                           Añadimos en la tabla ps_product_attribute_image
                           */

              /*             if TMSCommand():New( ::oCon ):ExecDirect( "INSERT INTO ps_product_attribute_image ( id_product_attribute, " + ;
                                                                                                               "id_image )" + ;
                                                                                                      " VALUES " + ;
                                                                                                               "('" + AllTrim( Str( nCodigoPropiedad ) ) + "', " + ;   //id_product
                                                                                                               "'" + AllTrim( Str( nCodigoImagen ) ) + "' )" ) //cover

                              ::SetText( "He insertado el artículo " + AllTrim( ::oArt:Nombre ) + " correctamente en la tabla ps_product_attribute_image", 3 )

                           else
                              ::SetText( "Error al insertar el artículo " + AllTrim( ::oArt:Nombre ) + " en la tabla ps_product_attribute_image", 3 )
                           end if

                        else

                           nCodigoImagen  := ::nCodigoWebImagen( ::oArt:Codigo, ::oArtDiv:cImgWeb )

                           if TMSCommand():New( ::oCon ):ExecDirect( "INSERT INTO ps_product_attribute_image ( id_product_attribute, " + ;
                                                                                                              "id_image )" + ;
                                                                                                     " VALUES " + ;
                                                                                                              "('" + AllTrim( Str( nCodigoPropiedad ) ) + "', " + ;   //id_product
                                                                                                              "'" + AllTrim( Str( nCodigoImagen ) ) + "' )" ) //cover

                              ::SetText( "He insertado el artículo " + AllTrim( ::oArt:Nombre ) + " correctamente en la tabla ps_product_attribute_image", 3 )

                           else
                              ::SetText( "Error al insertar el artículo " + AllTrim( ::oArt:Nombre ) + " en la tabla ps_product_attribute_image", 3 )
                           end if

                        end if

                     end if

               end case

               ::oArtDiv:Skip()

            end while

         end if*/

::oArtDiv:OrdSetFocus( "nOrdArtDiv" )

Return ( self )

//---------------------------------------------------------------------------//

METHOD AppTipoArticuloPrestashop( cCodTip, IdParent )

   local nCodigoWeb     := 0
   local nOrdAnt        := ::oTipArt:OrdSetFocus( "cCodTip" )
   local oCategoria
   local oImagen

   if !::oTipArt:Seek( cCodTip )

      nCodigoWeb        := IdParent

   else

      if ( ::oTipArt:cCodWeb != 0 )

         nCodigoWeb     := ::oTipArt:cCodWeb

      else

         if TMSCommand():New( ::oCon ):ExecDirect( "INSERT INTO ps_category ( id_parent, level_depth, nleft, nright, active, date_add, date_upd, position ) VALUES ( '" + Str( IdParent ) + "', '2', '0', '0', '1', '" + dtos( GetSysDate() ) + "', '" + dtos( GetSysDate() ) + "', '0' ) " )

            nCodigoWeb           := ::oCon:GetInsertId()

            ::nNumeroCategorias++

            /*
            Metemos en un array para luego calcular las coordenadas---------------
            */

            oCategoria                       := SCategoria()
            oCategoria:id                    := nCodigoWeb
            oCategoria:idParent              := IdParent
            oCategoria:nTipo                 := 3

            aAdd( ::aCategorias, oCategoria )

            /*
            Guardamos en nuestra tabla lasel id de la categoria-------------------
            */

            ::oTipArt:fieldPutByName( "cCodWeb", nCodigoWeb )

            ::SetText( "He insertado el tipo de artículo " + AllTrim( ::oTipArt:cNomTip ) + " correctamente en la tabla ps_category", 3 )

         else
            ::SetText( "Error al insertar el tipo de artículo " + AllTrim( ::oTipArt:cNomTip ) + " en la tabla ps_category", 3 )
         end if

         if TMSCommand():New( ::oCon ):ExecDirect( "INSERT INTO ps_category_lang ( id_category, id_lang, name, description, link_rewrite, meta_title, meta_keywords, meta_description ) VALUES ( '" + Str( nCodigoWeb ) + "', '" + Str( ::nLanguage ) + "', '" + AllTrim( ::oTipArt:cNomTip ) + "', '" + AllTrim( ::oTipArt:cNomTip ) + "', '" + cLinkRewrite( ::oTipArt:cNomTip ) + "', '', '', '' )" )
            ::SetText( "He insertado el tipo de artículo " + AllTrim( ::oTipArt:cNomTip ) + " correctamente en la tabla ps_category_lang", 3 )
         else
            ::SetText( "Error al insertar el tipo de artículo " + AllTrim( ::oTipArt:cNomTip ) + " en la tabla ps_category_lang", 3 )
         end if

         if TMSCommand():New( ::oCon ):ExecDirect( "INSERT INTO ps_category_shop ( id_category, id_shop, position ) VALUES ( '" + Str( nCodigoWeb ) + "', '1', '0' )" )
            ::SetText( "He insertado correctamente en la tabla categorias grupo la categoría raiz", 3 )
         else
            ::SetText( "Error al insertar la categoría inicio en ps_category_group", 3 )
         end if

         if TMSCommand():New( ::oCon ):ExecDirect( "INSERT INTO ps_category_group ( id_category, id_group ) VALUES ( '" + Str( nCodigoWeb ) + "', '1' )" )
            ::SetText( "He insertado el tipo de artículo " + AllTrim( ::oTipArt:cNomTip ) + " correctamente en la tabla ps_category_group", 3 )
         else
            ::SetText( "Error al insertar v " + AllTrim( ::oTipArt:cNomTip ) + " en la tabla ps_category_group", 3 )
         end if

         if TMSCommand():New( ::oCon ):ExecDirect( "INSERT INTO ps_category_group ( id_category, id_group ) VALUES ( '" + Str( nCodigoWeb ) + "', '2' )" )
            ::SetText( "He insertado el tipo de artículo " + AllTrim( ::oTipArt:cNomTip ) + " correctamente en la tabla ps_category_group", 3 )
         else
            ::SetText( "Error al insertar el tipo de artículo " + AllTrim( ::oTipArt:cNomTip ) + " en la tabla ps_category_group", 3 )
         end if

         if TMSCommand():New( ::oCon ):ExecDirect( "INSERT INTO ps_category_group ( id_category, id_group ) VALUES ( '" + Str( nCodigoWeb ) + "', '3' )" )
            ::SetText( "He insertado el tipo de artículo " + AllTrim( ::oTipArt:cNomTip ) + " correctamente en la tabla ps_category_group", 3 )
         else
            ::SetText( "Error al insertar el tipo de artículo " + AllTrim( ::oTipArt:cNomTip ) + " en la tabla ps_category_group", 3 )
         end if

         /*
         Insertamos un registro en las tablas de imágenes----------------------
         */

         if !Empty( ::oTipArt:cImgTip )

            /*
            Añadimos la imagen al array para pasarla a prestashop--------------
            */

            oImagen                       := SImagen()
            oImagen:cNombreImagen         := ::oTipArt:cImgTip
            oImagen:nTipoImagen           := tipoCategoria
            oImagen:cPrefijoNombre        := AllTrim( Str( nCodigoWeb ) )

            ::AddImages( oImagen )

         end if

      end if

   end if

return nCodigoWeb

//---------------------------------------------------------------------------//

METHOD nDefImagen( cCodArt, cImagen )

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

METHOD lLimpiaRefImgWeb()

   local nRec     := ::oArtDiv:Recno()
   local nOrdAnt  := ::oArtDiv:OrdSetFocus( "cCodArt" )

   ::oArtDiv:GoTop()

   while !::oArtDiv:Eof()

      ::oArtDiv:fieldPutByName( "cCodImgWeb", 0 )

      ::oArtDiv:Skip()

   end while

   ::oArtDiv:OrdSetFocus( nOrdAnt )
   ::oArtDiv:GoTo( nRec )

return .t.

//-----------------------------------------------------------------------------

METHOD nCodigoWebImagen( cCodArt, cImagen )

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

METHOD AppendIvaPrestashop() Class TComercio

   /*
   Vaciamos las tablas para el proceso global----------------------------------
   */

   if TMSCommand():New( ::oCon ):ExecDirect( "TRUNCATE TABLE " + ::cPreFixtable( "tax" ) )
      ::SetText ( 'Tabla ' + ::cPreFixtable( "tax" ) + ' borrada correctamente', 3  )
   else
      ::SetText ( 'Error al borrar la tabla ' + ::cPreFixtable( "tax" ), 3  )
   end if

   if TMSCommand():New( ::oCon ):ExecDirect( "TRUNCATE TABLE " + ::cPreFixtable( "tax_lang" ) )
      ::SetText ( 'Tabla ' + ::cPreFixtable( "tax_lang" ) + ' borrada correctamente', 3  )
   else
      ::SetText ( 'Error al borrar la tabla ' + ::cPreFixtable( "tax_lang" ), 3  )
   end if

   if TMSCommand():New( ::oCon ):ExecDirect( "TRUNCATE TABLE " + ::cPreFixtable( "tax_rule" ) )
      ::SetText ( 'Tabla ' + ::cPreFixtable( "tax_rule" ) + ' borrada correctamente', 3  )
   else
      ::SetText ( 'Error al borrar la tabla ' + ::cPreFixtable( "tax_rule" ), 3  )
   end if

   if TMSCommand():New( ::oCon ):ExecDirect( "TRUNCATE TABLE " + ::cPreFixtable( "tax_rules_group" ) )
      ::SetText ( 'Tabla ' + ::cPreFixtable( "tax_rules_group" ) + ' borrada correctamente', 3  )
   else
      ::SetText ( 'Error al borrar la tabla ' + ::cPreFixtable( "tax_rules_group" ), 3  )
   end if

   /*
   Inicializamos el código para la web en el programa-----------------------
   */

   ::DelIdIvaPrestashop()

   /*
   Añadimos tipos de IVA a prestashop------------------------------------------
   */

   ::oIva:GoTop()

   while !::oIva:Eof()

      if ::oIva:lPubInt

         ::MeterParticularText( "Actualizando tipos de " + cImp() )

         /*
         Metemos las familias como categorías----------------------------------
         */

         ::InsertIvaPrestashop()

      end if

      ::oIva:FieldPutByName( "lSndDoc", .f. )

      ::oIva:Skip()

   end while

return ( Self )

//---------------------------------------------------------------------------//

METHOD InsertIvaPrestashop() CLASS TComercio

   local cCommand          := ""  
   local nCodigoWeb        := 0
   local nCodigoGrupoWeb   := 0

   cCommand := "INSERT INTO " + ::cPreFixtable( "tax") + "( " +;
                  "rate, " + ;
                  "active )" + ;
               " VALUES " + ;
                  "('" + AllTrim( Str( ::oIva:TpIva ) ) + "', " + ;  // rate
                  "'1' )"                                            // active

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )

      nCodigoWeb           := ::oCon:GetInsertId()

      ::oIva:fieldPutByName( "cCodWeb", nCodigoWeb )

      ::SetText( "He insertado el tipo de " + cImp() + Space(1) + AllTrim( ::oIva:DescIva ) + " correctamente en la tabla " + ::cPreFixtable( "tax" ), 3 )

   else
      ::SetText( "Error al insertar el tipo de " + cImp() + Space(1) + AllTrim( ::oIva:DescIva ) + " en la tabla " + ::cPreFixtable( "tax" ), 3 )
   end if

   /*
   Insertamos un tipo de IVA nuevo en la tabla ps_tax_lang-----------------
   */

   cCommand := "INSERT INTO " + ::cPrefixTable( "tax_lang" ) + "( " +;
                  "id_tax, " + ;
                  "id_lang, " + ;
                  "name )" + ;
               " VALUES " + ;
                  "('" + Str( nCodigoWeb ) + "', " + ;         // id_tax
                  "'" + Str( ::nLanguage ) + "', " + ;         // id_lang
                  "'" + AllTrim( ::oIva:DescIva ) + "' )"      // name

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )

      ::SetText( "He insertado el tipo de " + cImp() + Space(1) + AllTrim( ::oIva:DescIva ) + " correctamente en la tabla" + ::cPrefixTable( "tax_lang" ), 3 )

   else

      ::SetText( "Error al insertar el tipo de " + cImp() + Space(1) + AllTrim( ::oIva:DescIva ) + " en la tabla" + ::cPrefixTable( "tax_lang" ), 3 )

   end if

   /*
   Insertamos un tipo de IVA nuevo en la tabla ps_tax_rule_group-----------------
   */

   cCommand := "INSERT INTO "+ ::cPrefixTable( "tax_rules_group" ) + "( " + ;
                  "name, " + ;
                  "active )" + ;
               " VALUES " + ;
                  "('" + AllTrim( ::oIva:DescIva ) + "', " + ; // name
                  "'1' )"                                      // active

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )

      nCodigoGrupoWeb           := ::oCon:GetInsertId()

      ::oIva:fieldPutByName( "cGrpWeb", nCodigoGrupoWeb )

      ::SetText( "He insertado el tipo de " + cImp() + Space(1) + AllTrim( ::oIva:DescIva ) + " correctamente en la tabla " + ::cPreFixtable( "tax_rule_group" ), 3 )

   else

      ::SetText( "Error al insertar el tipo de " + cImp() + Space(1) + AllTrim( ::oIva:DescIva ) + " en la tabla " + ::cPreFixTable( "tax_rule_group" ), 3 )

   end if

   /*
   Insertamos un tipo de IVA nuevo en la tabla ps_tax_rule-----------------
   */

   cCommand := "INSERT INTO " + ::cPrefixTable( "tax_rule" ) + "( " +;
                  "id_tax_rules_group, " + ;
                  "id_country, " + ;
                  "id_tax )" + ;
               " VALUES " + ;
                  "('" + Str( nCodigoGrupoWeb ) + "', " + ;    // id_tax_rules_group
                  "'6', " + ;                                  // id_country - 6 es el valor de España
                  "'" + Str( nCodigoWeb ) + "' )"            // id_tax

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )

      ::SetText( "He insertado el tipo de " + cImp() + Space(1) + AllTrim( ::oIva:DescIva ) + " correctamente en la tabla " + ::cPrefixTable( "tax_rule" ), 3 )

   else

      ::SetText( "Error al insertar el tipo de " + cImp() + Space(1) + AllTrim( ::oIva:DescIva ) + " en la tabla " + ::cPrefixTable( "tax_rule" ), 3 )

   end if

return nCodigoweb

//---------------------------------------------------------------------------//

METHOD lUpdateIvaPrestashop( nId ) CLASS TComercio

   local lReturn  := .f.

   /*
   Actualizamos los tipos de IVA ----------------------------------------
   */

   if TMSCommand():New( ::oCon ):ExecDirect( "UPDATE ps_tax SET rate='" + AllTrim( Str( ::oIva:TpIva ) ) + "' WHERE id_tax=" + AllTrim( Str( nId ) ) )
      ::SetText( "Actualizada correctamente el tipo de " + cImp() + Space(1) + AllTrim( ::oIva:DescIva ) + " en la tabla ps_tax", 3 )
      lReturn     := .t.
   else
      ::SetText( "Error al actualizar el tipo de " + cImp() + Space(1) + AllTrim( ::oIva:DescIva ) + " en la tabla ps_tax", 3 )
      lReturn     := .f.
   end if

   if TMSCommand():New( ::oCon ):ExecDirect( "UPDATE ps_tax_lang SET name='" + AllTrim( ::oIva:DescIva ) + "' WHERE id_tax=" + AllTrim( Str( nId ) ) )
      ::SetText( "Actualizada correctamente el tipo de " + cImp() + Space(1) + AllTrim( ::oIva:DescIva ) + " en la tabla ps_tax_lang", 3 )
      lReturn     := .t.
   else
      ::SetText( "Error al actualizar el tipo de " + cImp() + Space(1) + AllTrim( ::oIva:DescIva ) + " en la tabla ps_tax_lang", 3 )
      lReturn     := .f.
   end if

   if TMSCommand():New( ::oCon ):ExecDirect( "UPDATE ps_tax_rules_group SET name='" + AllTrim( ::oIva:DescIva ) + "' WHERE id_tax_rules_group=" + AllTrim( Str( nId ) ) )
      ::SetText( "Actualizada correctamente el tipo de " + cImp() + Space(1) + AllTrim( ::oIva:DescIva ) + " en la tabla ps_tax_rules_group", 3 )
      lReturn     := .t.
   else
      ::SetText( "Error al actualizar el tipo de " + cImp() + Space(1) + AllTrim( ::oIva:DescIva ) + " en la tabla ps_tax_rules_group", 3 )
      lReturn     := .f.
   end if

Return lReturn

//---------------------------------------------------------------------------//

Method AppendImagesPrestashop() CLASS TComercio

   local oFile
   local oImage
   local oTipoImage
   local hSource
   local nBytes
   local cBuffer           := Space( 2000 )
   local nCount            := 0
   local cNewImg           := ""
   local oImagenFinal

   ::aImagesCategories     := {}
   ::aImagesArticulos      := {}

   CursorWait()

   /*
   Recogemos los tipos de imagenes---------------------------------------------
   */

   ::aTipoImagenPrestashop()

   /*
   Cargamos creamos las imagenes a subir---------------------------------------
   */

   for each oImage in ::aImages

      /*
      Metemos primero la imagen que no lleva tipo------------------------------
      */

      do case

         case oImage:nTipoImagen == tipoProducto

            cNewImg           := cPatTmp() + oImage:cPrefijoNombre + ".jpg"

            SaveImage( oImage:cNombreImagen, cNewImg )

            oImagenFinal                  := SImagen()
            oImagenFinal:cNombreImagen    := cNewImg
            oImagenFinal:nTipoImagen      := oImage:nTipoImagen
            oImagenFinal:cCarpeta         := oImage:cCarpeta

            ::AddImagesArticulos( oImagenFinal )

         case oImage:nTipoImagen == tipoCategoria

            cNewImg           := cPatTmp() + oImage:cPrefijoNombre + ".jpg"

            SaveImage( oImage:cNombreImagen, cNewImg )

            oImagenFinal                  := SImagen()
            oImagenFinal:cNombreImagen    := cNewImg
            oImagenFinal:nTipoImagen      := oImage:nTipoImagen

            ::AddImagesCategories( oImagenFinal )

      end case

      /*
      Metemos las imagenes por tipo--------------------------------------------
      */

      for each oTipoImage in ::aTipoImagesPrestashop

         do case

            case oImage:nTipoImagen == tipoProducto .and. oTipoImage:lProducts

               cNewImg           := cPatTmp() + oImage:cPrefijoNombre + "-" + oTipoImage:cNombreTipo + ".jpg"

               SaveImage( oImage:cNombreImagen, cNewImg, oTipoImage:nAnchoTipo, oTipoImage:nAltoTipo )

               oImagenFinal                  := SImagen()
               oImagenFinal:cNombreImagen    := cNewImg
               oImagenFinal:nTipoImagen      := oImage:nTipoImagen
               oImagenFinal:cCarpeta         := oImage:cCarpeta

               ::AddImagesArticulos( oImagenFinal )

            case oImage:nTipoImagen == tipoCategoria .and. oTipoImage:lCategories

               cNewImg           := cPatTmp() + oImage:cPrefijoNombre + "-" + oTipoImage:cNombreTipo + ".jpg"

               SaveImage( oImage:cNombreImagen, cNewImg, oTipoImage:nAnchoTipo, oTipoImage:nAltoTipo )

               oImagenFinal                  := SImagen()
               oImagenFinal:cNombreImagen    := cNewImg
               oImagenFinal:nTipoImagen      := oImage:nTipoImagen

               ::AddImagesCategories( oImagenFinal )

         end case

         SysRefresh()

      next

   next

   if Len( ::aImagesArticulos ) > 0

      /*
      Conectamos al FTP y Subimos las imágenes de artículos-----------------------
      */

      ::nTotMeter    := 0

      ::oInt         := TInternet():New()
      ::oFtp         := TFtp():New( ::cHostFtp, ::oInt, ::cUserFtp, ::cPasswdFtp, ::lPassiveFtp )

      if Empty( ::oFtp ) .or. Empty( ::oFtp:hFtp )

         MsgStop( "Imposible conectar al sitio ftp " + ::cHostFtp )

      else

         ::SetText( "Actualizando imagenes de productos", 2 )

         /*
         Subimos los ficheros de imagenes-----------------------------------------
         */

         ::nTotMeter                := len( ::aImagesArticulos )
         nCount                     := 1

         if !Empty( ::cDImagen )
            ::oFtp:CreateDirectory( ::cDImagen + "/p" )
            ::oFtp:SetCurrentDirectory( ::cDImagen + "/p" )
         end if

         for each oImage in ::aImagesArticulos

            ::SetText( "Subiendo imagen " + cNoPath( oImage:cNombreImagen ), 3 )

            ::MeterParticularText( " Subiendo imagen " + AllTrim( Str( nCount ) ) + " de "  + AllTrim( Str( ::nTotMeter ) ) )

            ::oFtp:CreateDirectory( oImage:cCarpeta )
            ::oFtp:SetCurrentDirectory( oImage:cCarpeta )

            oFile                   := TFtpFile():New( cFileBmpName( oImage:cNombreImagen ), ::oFtp )
            if !oFile:PutFile( ::oMeterL )
               ::SetText( "Error copiando imagen " + cFileBmpName( oImage:cNombreImagen ), 3 )
            end if

            ::oFtp:SetCurrentDirectory( ".." )

            nCount                  += 1

            oFile:End()

            /*
            Me Paso Al Anterior---------------------------------------------------
            */

            SysRefresh()

         next

      end if

      if !Empty( ::oInt )
         ::oInt:end()
      end if

      if !Empty( ::oFtp )
         ::oFtp:end()
      end if

   end if

   /*
   Subimos las imagenes de las categories--------------------------------------
   */

   if Len( ::aImagesCategories ) > 0

      /*
      Conectamos al FTP y Subimos las imágenes de artículos--------------------
      */

      ::nTotMeter    := 0

      ::oInt         := TInternet():New()
      ::oFtp         := TFtp():New( ::cHostFtp, ::oInt, ::cUserFtp, ::cPasswdFtp, ::lPassiveFtp )

      if Empty( ::oFtp ) .or. Empty( ::oFtp:hFtp )

         MsgStop( "Imposible conectar al sitio ftp " + ::cHostFtp )

      else

         ::SetText( "Actualizando imagenes de categorías", 2 )

         /*
         Subimos los ficheros de imagenes--------------------------------------
         */

         ::nTotMeter                := len( ::aImagesCategories )
         nCount                     := 1

         if !Empty( ::cDImagen )
            ::oFtp:CreateDirectory( ::cDImagen + "/c" )
            ::oFtp:SetCurrentDirectory( ::cDImagen + "/c" )
         end if

         for each oImage in ::aImagesCategories

            ::SetText( "Subiendo imagen " + cNoPath( oImage:cNombreImagen ), 3 )

            ::MeterParticularText( " Subiendo imagen " + AllTrim( Str( nCount ) ) + " de "  + AllTrim( Str( ::nTotMeter ) ) )

            oFile                   := TFtpFile():New( cFileBmpName( oImage:cNombreImagen ), ::oFtp )
            if !oFile:PutFile( ::oMeterL )
               ::SetText( "Error copiando imagen " + cFileBmpName( oImage:cNombreImagen ), 3 )
            end if

            nCount                  += 1

            oFile:End()

            /*
            Me Paso Al Anterior------------------------------------------------
            */

            SysRefresh()

         next

      end if

      if !Empty( ::oInt )
         ::oInt:end()
      end if

      if !Empty( ::oFtp )
         ::oFtp:end()
      end if

   end if

   /*
   Borramos las imagenes creadas en los temporales-----------------------------
   */

   for each oImage in ::aImagesArticulos
      fErase( oImage:cNombreImagen )
   next

   for each oImage in ::aImagesCategories
      fErase( oImage:cNombreImagen )
   next

   CursorWe()

Return( nil )

//---------------------------------------------------------------------------//

METHOD aTipoImagenPrestashop() CLASS TComercio

   local oImagen
   local oQuery            := TMSQuery():New( ::oCon, 'SELECT * FROM ps_image_type' )

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

            ::AddTipoImagesPrestashop( oImagen )

            oQuery:Skip()

            SysRefresh()

         end while

      end if

   end if

   oQuery:Free()

   oQuery            := nil

Return ( self )

//---------------------------------------------------------------------------//

Method AddImagesArticulos( cImage ) CLASS TComercio

   if aScan( ::aImagesArticulos, cImage ) == 0
      aAdd( ::aImagesArticulos, cImage )
   end if

Return ( ::aImagesArticulos )

//---------------------------------------------------------------------------//

Method AddImagesCategories( cImage ) CLASS TComercio

   if aScan( ::aImagesCategories, cImage ) == 0
      aAdd( ::aImagesCategories, cImage )
   end if

Return ( ::aImagesCategories )

//---------------------------------------------------------------------------//

Method AddTipoImagesPrestashop( cImage ) CLASS TComercio

   if aScan( ::aTipoImagesPrestashop, cImage ) == 0
      aAdd( ::aTipoImagesPrestashop, cImage )
   end if

Return ( ::aTipoImagesPrestashop )

//---------------------------------------------------------------------------//

METHOD AppendClientPrestashop()

   local oQueryDirecciones
   local lFirst                  := .t.
   local oQuery                  := TMSQuery():New( ::oCon, 'SELECT * FROM ps_customer' )
   local cCodCli

   /*
   Recorremos el Query con la consulta-----------------------------------------
   */

   if oQuery:Open()

      /*
      Cargamos los valores para el meter------------------------------------------
      */

      ::nTotMeter    := oQuery:RecCount()

      if !Empty( ::oMeterL )
         ::oMeterL:SetTotal( ::nTotMeter )
      end if

      ::nActualMeterL := 1

      if oQuery:RecCount() > 0

         ::SetText( "Descargando clientes desde la web", 2 )

         oQuery:GoTop()

         while !oQuery:Eof()

            ::MeterParticularText( " Descargando cliente " + AllTrim( Str( ::nActualMeterL ) ) + " de "  + AllTrim( Str( ::nTotMeter ) ) )

            if !::oCli:SeekInOrd( Str( oQuery:FieldGet( 1 ), 11 ), "cCodWeb" ) //id_customer

               cCodCli           := NextKey( dbLast(  ::oCli, 1 ), ::oCli:cAlias, "0", RetNumCodCliEmp() )

               ::oCli:Append()
               ::oCli:Blank()
               ::oCli:Cod        := cCodCli
               ::oCli:Titulo     := oQuery:FieldGet( 10 ) + Space( 1 ) + oQuery:FieldGet( 11 ) //firstname - Last Name
               ::oCli:nTipCli    := 3
               ::oCli:CopiasF    := 1
               ::oCli:Serie      := uFieldEmpresa( "cSeriePed" )
               ::oCli:nRegIva    := 1
               ::oCli:nTarifa    := 1
               ::oCli:cMeiInt    := oQuery:FieldGet( 12 ) //email
               ::oCli:lChgPre    := .t.
               ::oCli:lSndInt    := .t.
               ::oCli:CodPago    := cDefFpg()
               ::oCli:cCodAlm    := cDefAlm()
               ::oCli:dFecChg    := GetSysDate()
               ::oCli:cTimChg    := Time()
               ::oCli:lPubInt    := .t.
               ::oCli:cCodWeb    := oQuery:FieldGet( 1 ) //id_customer
               ::oCli:lWeb       := .t.

               /*
               Vamos a meter las direcciones-----------------------------------
               */

               oQueryDirecciones       := TMSQuery():New( ::oCon, "SELECT * FROM ps_address WHERE id_customer = " + Str( oQuery:FieldGet( 1 ) ) )

               if oQueryDirecciones:Open()

                  if oQueryDirecciones:RecCount() > 0

                     oQueryDirecciones:GoTop()

                     while !oQueryDirecciones:Eof()

                        /*
                        El primero lo ponemos en la tabla de clientes----------
                        */

                        if lFirst

                           ::oCli:Nif            := oQueryDirecciones:FieldGet( 20 ) //"dni"
                           ::oCli:Domicilio      := oQueryDirecciones:FieldGet( 12 ) + " " + oQueryDirecciones:FieldGet( 13 ) //"address1" - "address2"
                           ::oCli:Poblacion      := oQueryDirecciones:FieldGet( 15 ) //"city"
                           ::oCli:CodPostal      := oQueryDirecciones:FieldGet( 14 ) //"postcode"
                           ::oCli:Telefono       := oQueryDirecciones:FieldGet( 17 ) //"phone"
                           ::oCli:Movil          := oQueryDirecciones:FieldGet( 18 ) //"phone_mobile"

                        end if

                        /*
                        Ahora lo metemos en la tabla de obras------------------
                        */

                        ::oObras:Append()
                        ::oObras:Blank()

                        ::oObras:cCodCli         := cCodCli
                        ::oObras:cCodObr         := "@" + AllTrim( Str( oQueryDirecciones:FieldGet( 1 ) ) ) //"id_address"
                        ::oObras:cNomObr         := oQueryDirecciones:FieldGet( 12 ) + " " + oQueryDirecciones:FieldGet( 13 ) //"address1" - "address2"
                        ::oObras:cDirObr         := oQueryDirecciones:FieldGet( 12 ) + " " + oQueryDirecciones:FieldGet( 12 ) //"address1" - "address2"
                        ::oObras:cPobObr         := oQueryDirecciones:FieldGet( 15 ) //"city"
                        ::oObras:cPosObr         := oQueryDirecciones:FieldGet( 14 ) //"postcode"
                        ::oObras:cTelObr         := oQueryDirecciones:FieldGet( 17 ) //"phone"
                        ::oObras:cMovObr         := oQueryDirecciones:FieldGet( 18 ) //"phone_mobile"
                        ::oObras:lDefObr         := lFirst
                        ::oObras:cCodWeb         := oQueryDirecciones:FieldGet( 1 ) //"id_address"

                        ::oObras:Save()

                        oQueryDirecciones:Skip()

                        lFirst                   := .f.

                     end while

                  end if

               end if

               if ::oCli:Save()
                  ::SetText( "Cliente " + AllTrim( oQuery:FieldGet( 10 ) ) + Space( 1 ) + AllTrim( oQuery:FieldGet( 11 ) ) + " introducido correctamente.", 3 )
               else
                  ::SetText( "Error al descargar el cliente: " + AllTrim( oQuery:FieldGet( 10 ) ) + Space( 1 ) + AllTrim( oQuery:FieldGet( 11 ) ), 3 )
               end if

            else

               ::SetText( "El cliente " + AllTrim( oQuery:FieldGet( 10 ) ) + Space( 1 ) + AllTrim( oQuery:FieldGet( 11 ) ) + " ya existe en nuestra base se datos.", 3 )

            end if

            oQuery:Skip()

            ::nActualMeterL++

            lFirst                               := .t.

         end while

      end if

   end if

   oQuery:Free()

   oQuery                                        := nil

Return ( self )

//---------------------------------------------------------------------------//

METHOD AppendPedidoprestashop()

   local oQuery                  := TMSQuery():New( ::oCon, 'SELECT * FROM ps_orders' )
   local cSerPed                 := ""
   local nNumPed                 := 0
   local cSufPed                 := ""
   local dFecha
   local oQueryL
   local nNumLin                 := 1
   local cCodWeb                 := 1

   if oQuery:Open()

      /*
      Cargamos los valores para el meter------------------------------------------
      */

      ::nTotMeter    := oQuery:RecCount()

      if !Empty( ::oMeterL )
         ::oMeterL:SetTotal( ::nTotMeter )
      end if

      ::nActualMeterL := 1

      /*
      Recorremos el Query con la consulta-----------------------------------------
      */

      if oQuery:RecCount() > 0

         ::SetText( "Descargando pedidos desde la web", 2 )

         oQuery:GoTop()

         while !oQuery:Eof()

            ::MeterParticularText( " Descargando pedido " + AllTrim( Str( ::nActualMeterL ) ) + " de "  + AllTrim( Str( ::nTotMeter ) ) )

            if !::oPedCliT:SeekInOrd( Str( oQuery:FieldGet( 1 ), 11 ), "cCodWeb" ) //id_order

               /*
               Tomamos el número del pedido------------------------------------
               */

               cSerPed                 := uFieldEmpresa( "cSeriePed" )
               nNumPed                 := nNewDoc( uFieldEmpresa( "cSeriePed" ), ::oPedCliT:cAlias, "NPEDCLI", , ::oCount:cAlias )
               cSufPed                 := RetSufEmp()

               SET DATE FORMAT "yyyy/mm/dd"
               dFecha                  := Ctod( Left( oQuery:FieldGet( 42 ), 10 ) ) /*date_add*/
               SET DATE FORMAT "dd/mm/yyyy"

               ::oPedCliT:Append()
               ::oPedCliT:Blank()

               ::oPedCliT:cSerPed      := cSerPed
               ::oPedCliT:nNumPed      := nNumPed
               ::oPedCliT:cSufPed      := cSufPed
               ::oPedCliT:cTurPed      := cCurSesion()
               ::oPedCliT:dFecPed      := dFecha
               ::oPedCliT:cCodAlm      := oUser():cAlmacen()
               ::oPedCliT:cCodCaj      := oUser():cCaja()
               ::oPedCliT:cCodPgo      := cDefFpg()
               ::oPedCliT:nEstado      := 1
               ::oPedCliT:nTarifa      := 1
               ::oPedCliT:cDivPed      := cDivEmp()
               ::oPedCliT:nVdvPed      := nChgDiv( cDivEmp(), ::oDivisas:cAlias )
               ::oPedCliT:lSndDoc      := .t.
               ::oPedCliT:lIvaInc      := uFieldEmpresa( "lIvaInc" )
               ::oPedCliT:cManObr      := Padr( "Gastos envio", 250 )
               ::oPedCliT:nManObr      := oQuery:FieldGet( 30 )
               ::oPedCliT:lCloPed      := .f.
               ::oPedCliT:cCodUsr      := cCurUsr()
               ::oPedCliT:dFecCre      := GetSysDate()
               ::oPedCliT:cTimCre      := Time()
               ::oPedCliT:cCodDlg      := oUser():cDelegacion()
               ::oPedCliT:lWeb         := .t.
               ::oPedCliT:lInternet    := .t.
               ::oPedCliT:cCodWeb      := oQuery:FieldGet( 1 )
               cCodWeb                 := oQuery:FieldGet( 1 )
               ::oPedCliT:nTotNet      := oQuery:FieldGet( 29 )
               ::oPedCliT:nTotIva      := oQuery:FieldGet( 25 ) - ( oQuery:FieldGet( 29 ) + oQuery:FieldGet( 32 ) )
               ::oPedCliT:nTotPed      := oQuery:FieldGet( 25 )

               if ::oCli:SeekInOrd( Str( oQuery:FieldGet( 4 ), 11 ) , "cCodWeb" )

                  ::oPedCliT:cCodCli   := ::oCli:Cod
                  ::oPedCliT:cNomCli   := ::oCli:Titulo
                  ::oPedCliT:cDirCli   := ::oCli:Domicilio
                  ::oPedCliT:cPobCli   := ::oCli:Poblacion
                  ::oPedCliT:cPrvCli   := ::oCli:Provincia
                  ::oPedCliT:cPosCli   := ::oCli:CodPostal
                  ::oPedCliT:cDniCli   := ::oCli:Nif
                  ::oPedCliT:lModCli   := .t.
                  ::oPedCliT:cTlfCli   := ::oCli:Telefono
                  ::oPedCliT:cCodGrp   := ::oCli:cCodGrp
                  ::oPedCliT:nRegIva   := ::oCli:nRegIva

               end if

               /*
               Introducimos las lineas del pedido------------------------------
               */

               oQueryL            := TMSQuery():New( ::oCon, "SELECT * FROM ps_order_detail WHERE id_order=" + AllTrim( Str( cCodWeb ) ) )

               if oQueryL:Open()

                  if oQueryL:RecCount() > 0

                     oQueryL:GoTop()

                     while !oQueryL:Eof()

                        ::oPedCliL:Append()
                        ::oPedCliL:Blank()
                        ::oPedCliL:cSerPed        := cSerPed
                        ::oPedCliL:nNumPed        := nNumPed
                        ::oPedCliL:cSufPed        := cSufPed
                        ::oPedCliL:cDetalle       := oQueryL:FieldGet( 8 )
                        ::oPedCliL:mLngDes        := oQueryL:FieldGet( 8 )
                        ::oPedCliL:nCanPed        := 1
                        ::oPedCliL:nUniCaja       := oQueryL:FieldGet( 9 )
                        ::oPedCliL:nPreDiv        := oQueryL:FieldGet( 14 )
                        ::oPedCliL:dFecha         := dFecha
                        ::oPedCliL:nNumLin        := nNumLin
                        ::oPedCliL:cAlmLin        := cDefAlm()
                        ::oPedCliL:nTarLin        := 1


                        if ::oArt:SeekInOrd( Str( oQueryL:FieldGet( 6 ), 11 ) , "cCodWeb" )

                           ::oPedCliL:cRef        := ::oArt:Codigo
                           ::oPedCliL:cUnidad     := ::oArt:cUnidad
                           ::oPedCliL:nPesoKg     := ::oArt:nPesoKg
                           ::oPedCliL:cPesoKg     := ::oArt:cUnidad
                           ::oPedCliL:nVolumen    := ::oArt:nVolumen
                           ::oPedCliL:cVolumen    := ::oArt:cVolumen
                           ::oPedCliL:nCtlStk     := ::oArt:nCtlStock
                           ::oPedCliL:nCosDiv     := nCosto( ::oArt:Codigo, ::oArt:cAlias, ::oKit:cAlias )
                           ::oPedCliL:cCodTip     := ::oArt:cCodTip
                           ::oPedCliL:cCodFam     := ::oArt:Familia
                           ::oPedCliL:cGrpFam     := RetFld( ::oArt:Familia, ::oFam:cAlias, "cCodGrp" )
                           ::oPedCliL:cCodPr1     := ::oArt:cCodPrp1
                           ::oPedCliL:cCodPr2     := ::oArt:cCodPrp2
                           ::oPedCliL:cValPr1     := ::GetValPrp( oRetFld( ::oArt:cCodPrp1, ::oPro, "cCodWeb", "cCodPro" ), oQueryL:FieldGet( 7 ) )
                           ::oPedCliL:cValPr2     := ::GetValPrp( oRetFld( ::oArt:cCodPrp2, ::oPro, "cCodWeb", "cCodPro" ), oQueryL:FieldGet( 7 ) )
                           ::oPedCliL:nIva        := nIva( ::oIva:cAlias, ::oArt:TipoIva )

                        end if

                        if !::oPedCliL:Save()
                           ::SetText( "Error al descargar las lineas el pedido: " + cSerPed + "/" + AllTrim( Str( nNumPed ) ) + "/" + cSufPed, 3 )
                        end if

                     oQueryL:Skip()

                     nNumLin++

                     end while

                  end if

               end if

               if ::oPedCliT:Save()
                  ::SetText( "Pedido " + cSerPed + "/" + AllTrim( Str( nNumPed ) ) + "/" + cSufPed + " introducido correctamente.", 3 )
               else
                  ::SetText( "Error al descargar el pedido: " + cSerPed + "/" + AllTrim( Str( nNumPed ) ) + "/" + cSufPed, 3 )
               end if

            else

               ::SetText( "El pedido " + ::oPedCliT:cSerPed + "/" + AllTrim( Str( ::oPedCliT:nNumPed ) ) + "/" + ::oPedCliT:cSufPed + " ya ha sido importado desde la página web.", 3 )

            end if

            oQuery:Skip()

            ::nActualMeterL++

         end while

      end if

   end if

   oQuery:Free()

   oQuery   := nil

Return ( self )

//---------------------------------------------------------------------------//

Method EstadoPedidosPrestashop() Class TComercio

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

   ::oMeterL:SetTotal( ::nTotMeter )
   ::nActualMeterL   := 1

   /*
   Modifico los datos y tablas correspondientes--------------------------
   */

   ::SetText( "Actualizando el estado de los pedidos", 2 )

   ::oPedCliT:GoTop()
   while !::oPedCliT:Eof()

      if ::oPedCliT:lInternet .and. ::oPedCliT:nEstado != 1

         ::MeterParticularText( "Actualizando estado de pedidos " + AllTrim( Str( ::nActualMeterL ) ) + " de " + AllTrim( Str( ::nTotMeter ) ) )

         oQuery                  := TMSQuery():New( ::oCon, "SELECT * FROM ps_order_history WHERE id_order=" + AllTrim( Str( ::oPedCliT:cCodWeb ) ) + " AND id_order_state=5" )

         if oQuery:Open()

            if oQuery:RecCount() == 0

               if TMSCommand():New( ::oCon ):ExecDirect( "INSERT INTO ps_order_history ( id_employee, " + ;
                                                                                         "id_order, " + ;
                                                                                         "id_order_state, " + ;
                                                                                         "date_add )" + ;
                                                                              " VALUES " + ;
                                                                                         "('1', " + ;                                           //id_employee
                                                                                         "'" + AllTrim( Str( ::oPedCliT:cCodWeb ) ) + "', " + ; //id_order
                                                                                         "'5', " + ;                                            //id_ordder_state
                                                                                         "'" + dtos( GetSysDate() ) + "' )" )                   //date_add

                  ::SetText( "Actualizado el estado del pedido " + ::oPedCliT:cSerPed + "/" + AllTrim( Str( ::oPedCliT:nNumPed ) ) + "/" + ::oPedCliT:cSufPed, 3 )

               else

                  ::SetText( "Error al actualizar el estado del pedido " + ::oPedCliT:cSerPed + "/" + AllTrim( Str( ::oPedCliT:nNumPed ) ) + "/" + ::oPedCliT:cSufPed, 3 )

               end if

            end if

         end if

      end if

   ::oPedCliT:Skip()

   end while

Return ( self )

//---------------------------------------------------------------------------//

METHOD AppendClientesToPrestashop()

   local nCodigoWeb  := 0
   local nSpace      := 0
   local cFirstName  := ""
   local cLastName   := ""

   ::SetText( "Recorremos la tabla de clientes", 2 )

   /*
   Añadimos familias a prestashop----------------------------------------------
   */

   ::oCli:GoTop()

   while !::oCli:Eof()

      if ::oCli:lPubInt .and. ::oCli:lSndInt

         if !::oCli:lWeb

            if ::oCli:cCodWeb == 0

               nSpace               := At( " ", ::oCli:Titulo )
               cFirstName           := ::oCon:EscapeStr( SubStr( ::oCli:Titulo, 1, nSpace ) )
               cLastName            := ::oCon:EscapeStr( SubStr( ::oCli:Titulo, nSpace + 1 ) )

               if TMSCommand():New( ::oCon ):ExecDirect( "INSERT INTO ps_customer ( id_gender, " + ;
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
                                                                                    "('9', " + ;                                                       //id_gender, " - Genero desconocido
                                                                                    "'1', " + ;                                                        //"id_default_group, " + ;
                                                                                    "'" + AllTrim( cFirstName ) + "', " + ;                            //"firstname, " + ;
                                                                                    "'" + AllTrim( cLastName ) + "', " + ;                             //"lastname, " + ;
                                                                                    "'" + AllTrim( ::oCli:cMeiInt ) + "', " + ;                        //"email, " + ;
                                                                                    "'" + hb_md5( AllTrim( ::Cookiekey ) + AllTrim( ::oCli:cClave ) ) + "', " + ;   //"passwd, " + ;
                                                                                    "'1', " + ;                                                        //"newletter, " + ;
                                                                                    "'" + hb_md5( AllTrim( ::oCli:Cod ) ) + "', " + ;                  //"secure_key, " + ;
                                                                                    "'1', " + ;                                                        //"active, " + ;
                                                                                    "'0', " + ;                                                        //"is_guest, " + ;
                                                                                    "'0', " + ;                                                        //"deleted, " + ;
                                                                                    "'" + dtos( GetSysDate() ) + "', " + ;                             //"date_add )" + ;
                                                                                    "'" + dtos( GetSysDate() ) + "' )" )                               //"date_upd )" + ;

                  nCodigoWeb           := ::oCon:GetInsertId()

                  ::oCli:fieldPutByName( "cCodWeb", nCodigoWeb )

                  ::SetText( "He insertado el cliente " + AllTrim( ::oCli:Titulo ) + " correctamente en la tabla ps_customer", 3 )

               else
                  ::SetText( "Error al insertar el cliente " + AllTrim( ::oCli:Titulo ) + " en la tabla ps_customer", 3 )
               end if

               /*
               Insertamos en la tabla ps_customer_group------------------------
               */

               if TMSCommand():New( ::oCon ):ExecDirect( "INSERT INTO ps_customer_group ( id_customer, " + ;
                                                                                          "id_group )" + ;
                                                                                 " VALUES " + ;
                                                                                           "('" + AllTrim( Str( nCodigoWeb ) ) + "', " + ;
                                                                                           "'1' )" )


                  ::SetText( "He insertado el cliente " + AllTrim( ::oCli:Titulo ) + " correctamente en la tabla ps_customer_group", 3 )

               else
                  ::SetText( "Error al insertar el cliente " + AllTrim( ::oCli:Titulo ) + " en la tabla ps_customer_group", 3 )
               end if

               /*
               Insertamos en la tabla ps_address------------------------
               */

               if TMSCommand():New( ::oCon ):ExecDirect( "INSERT INTO ps_address ( id_country, " + ;
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
                                                                                  "'" + AllTrim( Str( nCodigoWeb ) ) + "', " + ;                 //id_customer
                                                                                  "'" + AllTrim( cFirstName ) + AllTrim( cLastName ) + "', " + ; //alias
                                                                                  "'" + AllTrim( cLastName ) + "', " + ;                         //lastname
                                                                                  "'" + AllTrim( cFirstName ) + "', " + ;                        //firstname
                                                                                  "'" + AllTrim( ::oCli:Domicilio ) + "', " + ;                  //address1
                                                                                  "'" + AllTrim( ::oCli:CodPostal ) + "', " + ;                  //postcode
                                                                                  "'" + AllTrim( ::oCli:Poblacion ) + "', " + ;                  //city
                                                                                  "'" + AllTrim( ::oCli:Telefono ) + "', " + ;                   //phone
                                                                                  "'" + AllTrim( ::oCli:Movil ) + "', " + ;                      //phone_mobile
                                                                                  "'" + AllTrim( ::oCli:Nif ) + "', " + ;                        //dni
                                                                                  "'" + dtos( GetSysDate() ) + "', " + ;                         //date_add
                                                                                  "'" + dtos( GetSysDate() ) + "', " + ;                         //date_upd
                                                                                  "'1', " + ;                                                    //active
                                                                                  "'0' )" )                                                      //deleted


                  ::SetText( "He insertado el cliente " + AllTrim( ::oCli:Titulo ) + " correctamente en la tabla ps_address", 3 )

               else
                  ::SetText( "Error al insertar el cliente " + AllTrim( ::oCli:Titulo ) + " en la tabla ps_address", 3 )
               end if

            else

               nSpace               := At( " ", ::oCli:Titulo )
               cFirstName           := ::oCon:EscapeStr( SubStr( ::oCli:Titulo, 1, nSpace ) )
               cLastName            := ::oCon:EscapeStr( SubStr( ::oCli:Titulo, nSpace + 1 ) )

               if !::oCli:lWeb

                  /*
                  Actualizamos la tabla de clientes----------------------------
                  */

                  if TMSCommand():New( ::oCon ):ExecDirect( "UPDATE ps_customer SET firstname='" + AllTrim( cFirstName ) + ;
                                                                                "', lastname='" + AllTrim( cLastName ) + ;
                                                                                "', email='" + AllTrim( ::oCli:cMeiInt ) + ;
                                                                                "', passwd='" + hb_md5( AllTrim( ::Cookiekey ) + AllTrim( ::oCli:cClave ) ) + ;
                                                                                "', secure_key='" + hb_md5( AllTrim( ::oCli:Cod ) ) + ;
                                                                                "', date_upd='" + dtos( GetSysDate() ) + ;
                                                                                "' WHERE id_customer=" + AllTrim( Str( ::oCli:cCodWeb ) ) )

                     ::SetText( "Actualizado correctamente el cliente " + AllTrim( ::oCli:Titulo ) + " en la tabla ps_customer", 3 )
                  else
                     ::SetText( "Error al actualizar el cliente " + AllTrim( ::oCli:Titulo ) + " en la tabla ps_customer", 3 )
                  end if

                  /*
                  Actualizamos la tabla de direcciones-------------------------
                  */

                  if TMSCommand():New( ::oCon ):ExecDirect( "UPDATE ps_address SET alias='" + AllTrim( cFirstName ) + AllTrim( cLastName ) + ;
                                                                                "', firstname='" + AllTrim( cFirstName ) + ;
                                                                                "', lastname='" + AllTrim( cLastName ) + ;
                                                                                "', address1='" + AllTrim( ::oCli:Domicilio ) + ;
                                                                                "', postcode='" + AllTrim( ::oCli:CodPostal ) + ;
                                                                                "', city='" + AllTrim( ::oCli:Poblacion ) + ;
                                                                                "', phone='" + AllTrim( ::oCli:Telefono ) + ;
                                                                                "', phone_mobile='" + AllTrim( ::oCli:Movil ) + ;
                                                                                "', dni='" + AllTrim( ::oCli:Nif ) + ;
                                                                                "', date_upd='" + dtos( GetSysDate() ) + ;
                                                                                "' WHERE id_customer=" + AllTrim( Str( ::oCli:cCodWeb ) ) )

                     ::SetText( "Actualizado correctamente el cliente " + AllTrim( ::oCli:Titulo ) + " en la tabla ps_address", 3 )
                  else
                     ::SetText( "Error al actualizar el cliente " + AllTrim( ::oCli:Titulo ) + " en la tabla ps_address", 3 )
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

METHOD AppendFabricantesPrestashop CLASS TComercio

   local n

   /*
   Vaciamos las tablas para el proceso global-------------------------
   */

   if TMSCommand():New( ::oCon ):ExecDirect( "TRUNCATE TABLE " + ::cPrefixTable( "manufacturer" ) )
      ::SetText ( 'Tabla ' + ::cPrefixTable( "manufacturer" ) + ' borrada correctamente', 3  )
   else
      ::SetText ( 'Error al borrar la tabla ' + ::cPrefixTable( "manufacturer" ), 3  )
   end if

   if TMSCommand():New( ::oCon ):ExecDirect( "TRUNCATE TABLE " + ::cPrefixTable( "manufacturer_shop" ) )
      ::SetText ( 'Tabla ' + ::cPrefixTable( "manufacturer_shop" ) + ' borrada correctamente', 3 )
   else
      ::SetText ( 'Error al borrar la tabla ' + ::cPreFixtable( "manufacturer_shop" ), 3 )
   end if

   if TMSCommand():New( ::oCon ):ExecDirect( "TRUNCATE TABLE " + ::cPrefixTable( "manufacturer_lang" ) )
      ::SetText ( 'Tabla ' + ::cPrefixTable( "manufacturer_lang" ) + ' borrada correctamente', 3  )
   else
      ::SetText ( 'Error al borrar la tabla ' + ::cPrefixTable( "manufacturer_lang" ), 3  )
   end if

   /*
   Ponemos los id de fabricantes para la web-----------------------------------
   */

   ::DelIdFabricantePrestashop()

   /*
   Añadimos familias a prestashop----------------------------------------------
   */

   ::oFab:GoTop()

   while !::oFab:Eof()

      if ::oFab:lPubInt

         ::MeterParticularText( "Actualizando fabricantes" )

         /*
         Metemos las familias como categorías----------------------------------
         */

         ::InsertFabricantesPrestashop()

      end if

      ::oFab:FieldPutByName( "lSndDoc", .f. )

      ::oFab:Skip()

   end while

Return ( self )

//---------------------------------------------------------------------------//

Method InsertFabricantesPrestashop() CLASS TComercio

   local oImagen
   local cCommand    := ""    
   local nCodigoWeb  := 0
   local nParent     := 1

   /*
   Insertamos una familia nueva en las tablas de prestashop-----------------
   */

   cCommand := "INSERT INTO " + ::cPrefixTable( "manufacturer" ) + "( " +;
                  "name, " + ;
                  "date_add, " + ;
                  "date_upd, " + ;
                  "active )" + ;
               " VALUES " + ;
                  "('" + AllTrim( ::oFab:cNomFab ) + "', " + ;       //name
                  "'" + dtos( GetSysDate() ) + "', " + ;             //date_add
                  "'" + dtos( GetSysDate() ) + "', " + ;             //date_upd
                  "'1' )"                                            //active

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )

      nCodigoWeb           := ::oCon:GetInsertId()

      ::oFab:fieldPutByName( "cCodWeb", nCodigoWeb )

      ::SetText( "He insertado el fabricante " + AllTrim( ::oFab:cNomFab ) + " correctamente en la tabla " + ::cPrefixTable( "manufacturer" ), 3 )

   else
      ::SetText( "Error al insertar el fabricante " + AllTrim( ::oFab:cNomFab ) + " en la tabla " + ::cPreFixtable( "manufacturer" ), 3 )
   end if

   cCommand := "INSERT INTO " + ::cPrefixTable( "manufacturer_shop" ) + "( "+ ;
                  "id_manufacturer, " + ;
                  "id_shop )" + ;
               " VALUES " + ;
                  "('" + AllTrim( Str( nCodigoWeb ) ) + "', " + ;     // id_manufacturer
                  "'1' )"                                             // id_shop                  


   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )

      ::SetText( "He insertado el fabricante " + AllTrim( ::oFab:cNomFab ) + " correctamente en la tabla" + ::cPreFixtable( "manufacturer_shop" ), 3 )

   else
      ::SetText( "Error al insertar el fabricante " + AllTrim( ::oFab:cNomFab ) + " en la tabla" + ::cPreFixtable( "manufacturer_shop" ), 3 )
   end if

   cCommand := "INSERT INTO " + ::cPreFixtable( "manufacturer_lang" ) + "( " +;
                  "id_manufacturer, " + ;
                  "id_lang )" + ;
               " VALUES " + ;
                  "('" + AllTrim( Str( nCodigoWeb ) ) + "', " + ;    //id_manufacturer
                  "'" + Str( ::nLanguage ) + "' )"                   //id_lang

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )

      ::SetText( "He insertado el fabricante " + AllTrim( ::oFab:cNomFab ) + " correctamente en la tabla" + ::cPreFixtable( "manufacturer_lang" ), 3 )

   else
      ::SetText( "Error al insertar el fabricante " + AllTrim( ::oFab:cNomFab ) + " en la tabla" + ::cPreFixtable( "manufacturer_lang" ), 3 )
   end if

return nCodigoWeb

//---------------------------------------------------------------------------//

METHOD lUpdateFabricantesPrestashop( nId ) Class TComercio

   local lReturn  := .f.

   if TMSCommand():New( ::oCon ):ExecDirect( "UPDATE ps_manufacturer SET name='" + AllTrim( ::oFab:cNomFab ) + "', date_upd='" + dtos( GetSysDate() ) + "' WHERE id_manufacturer=" + AllTrim( Str( ::oFab:cCodWeb ) ) )
      ::SetText( "Actualizada correctamente el fabricante " + AllTrim( ::oFab:cNomFab ) + " en la tabla ps_manufacturer", 3 )
      lReturn     := .t.
   else
     ::SetText( "Error al actualizar el fabricante " + AllTrim( ::oFab:cNomFab ) + " en la tabla ps_manufacturer", 3 )
     lReturn     := .f.
   end if

Return lReturn   

//---------------------------------------------------------------------------//

METHOD AppendPropiedadesPrestashop CLASS TComercio

   local n
   local cCommand := ""

   /*
   Vaciamos las tablas para el proceso global-------------------------
   */

   cCommand       := "TRUNCATE TABLE " + ::cPrefixTable( "attribute" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText ( 'Tabla ' + ::cPrefixTable( "attribute" ) + ' borrada correctamente', 3  )
   else
      ::SetText ( 'Error al borrar la tabla ' + ::cPrefixTable( "attribute" ), 3  )
   end if

   cCommand       := "TRUNCATE TABLE " + ::cPrefixTable( "attribute_lang" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText ( 'Tabla ' + ::cPrefixTable( "attribute_lang" ) + ' borrada correctamente', 3  )
   else
      ::SetText ( 'Error al borrar la tabla ' + ::cPrefixTable( "attribute_lang" ), 3  )
   end if

   cCommand       := "TRUNCATE TABLE " + ::cPrefixTable( "attribute_impact" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText ( 'Tabla ' + ::cPrefixTable( "attribute_impact" ) + ' borrada correctamente', 3  )
   else
      ::SetText ( 'Error al borrar la tabla ' + ::cPrefixTable( "attribute_impact" ), 3  )
   end if

   cCommand       := "TRUNCATE TABLE " + ::cPrefixTable( "attribute_group" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText ( 'Tabla ' + ::cPrefixTable( "attribute_group" ) + ' borrada correctamente', 3  )
   else
      ::SetText ( 'Error al borrar la tabla ' + ::cPrefixTable( "attribute_group" ), 3  )
   end if

   cCommand       := "TRUNCATE TABLE " + ::cPrefixTable( "attribute_group_lang" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText ( 'Tabla ' + ::cPrefixTable( "attribute_group_lang" ) + ' borrada correctamente', 3  )
   else
      ::SetText ( 'Error al borrar la tabla ' + ::cPrefixTable( "attribute_group_lang" ), 3  )
   end if

   /*
   Añadimos Propiedades de artículos a prestashop------------------------------
   */

   ::oPro:GoTop()

   while !::oPro:Eof()

      if ::oPro:lPubInt

         ::MeterParticularText( "Actualizando propiedades de artículos" )

         ::InsertPropiedadesPrestashop()

      end if

      ::oPro:FieldPutByName( "lSndDoc", .f. )

      ::oPro:Skip()

   end while

Return ( self )

//---------------------------------------------------------------------------//

Method InsertPropiedadesPrestashop() CLASS TComercio

   local oImagen
   local nCodigoGrupo      := 0
   local nCodigoPropiedad  := 0
   local nParent           := 1
   local cCommand          := ""

   /*
   Insertamos una propiedad nueva en las tablas de prestashop-----------------
   */

   cCommand          := "INSERT INTO " + ::cPrefixTable( "attribute_group" ) + ; 
                              " ( is_color_group, " + ;
                                  "group_type )" + ;
                              " VALUES " + ;
                                  "('" + if( ::oPro:lColor, "1", "0" ) + "', " + ;        //is_color_group
                                  "'" + if( ::oPro:lColor, "color", "select" ) + "' )"    //group_type                        

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )

      nCodigoGrupo   := ::oCon:GetInsertId()

      ::oPro:fieldPutByName( "cCodWeb", nCodigoGrupo )

      ::SetText( "He insertado la propiedad " + AllTrim( ::oPro:cDesPro ) + " correctamente en la tabla " + ::cPrefixTable( "attribute_group" ), 3 )

   else

      ::SetText( "Error al insertar la propiedad " + AllTrim( ::oPro:cDesPro ) + " en la tabla " + ::cPrefixTable( "attribute_group" ), 3 )

   end if

   cCommand          := "INSERT INTO " + ::cPrefixTable( "attribute_group_lang" ) + ; 
                              " ( id_attribute_group, " + ;
                                  "id_lang, " + ;
                                  "name, " + ;
                                  "public_name )" + ;
                              " VALUES " + ;
                                  "('" + AllTrim( Str( nCodigoGrupo ) ) + "', " + ;    //id_attribute_group
                                  "'" + Str( ::nLanguage ) + "', " + ;                 //id_lang
                                  "'" + AllTrim( ::oPro:cDesPro ) + "', " + ;          //name
                                  "'" + AllTrim( ::oPro:cDesPro ) + "' )"              //public_name

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )

      ::SetText( "He insertado la propiedad " + AllTrim( ::oPro:cDesPro ) + " correctamente en la tabla " + ::cPrefixTable( "attribute_group_lang" ), 3 )

   else

      ::SetText( "Error al insertar la propiedad " + AllTrim( ::oPro:cDesPro ) + " en la tabla " + ::cPrefixTable( "attribute_group_lang" ), 3 )

   end if

   /*
   Introducimos las líneas-----------------------------------------------------
   */

   ::InsertLineasPropiedadesPrestashop( ::oPro:cCodPro, nCodigoGrupo )

return nCodigoGrupo

//---------------------------------------------------------------------------//

METHOD InsertLineasPropiedadesPrestashop( cCodPro, nCodigoGrupo ) CLASS TComercio

   local nCodigoPropiedad  := 0
   local nRec              := ::oTblPro:Recno()
   local nOrdAnt           := ::oTblPro:OrdSetFocus( "CPRO" )
   local cCommand          := ""

   /*
   Introducimos las líneas-----------------------------------------------------
   */

   if ::oTblPro:Seek( cCodPro )

      while cCodPro == ::oTblPro:cCodPro .and. !::oTblPro:Eof()

         cCommand    := "INSERT INTO " + ::cPrefixTable( "attribute" ) + ; 
                           " ( id_attribute_group, " + ;
                               "color )" + ;
                           " VALUES " + ;
                               "('" + AllTrim( Str( nCodigoGrupo ) ) + "', " + ;          //name
                               "'" + AllTrim( RgbToRgbHex( ::oTblPro:nColor) ) + "' )"    //active

         if TMSCommand():New( ::oCon ):ExecDirect( cCommand )

            nCodigoPropiedad   := ::oCon:GetInsertId()

            ::oTblPro:fieldPutByName( "cCodWeb", nCodigoPropiedad )

            ::SetText( "He insertado la propiedad " + AllTrim( ::oTblPro:cDesTbl ) + " correctamente en la tabla " + ::cPrefixTable( "attribute" ), 3 )

         else

            ::SetText( "Error al insertar la propiedad " + AllTrim( ::oTblPro:cDesTbl ) + " en la tabla " + ::cPreFixtable( "ps_attribute" ), 3 )

         end if

         cCommand    := "INSERT INTO " + ::cPrefixTable( "attribute_lang" ) + ;
                           " ( id_attribute, " + ;
                              "id_lang, " + ;
                              "name ) " + ;
                           "VALUES " + ;
                              "('" + AllTrim( Str( nCodigoPropiedad ) ) + "', " + ;   //id_attribute
                              "'" + Str( ::nLanguage ) + "', " + ;                    //id_lang
                              "'" + AllTrim( ::oTblPro:cDesTbl ) + "' )"              //name

         if TMSCommand():New( ::oCon ):ExecDirect( cCommand )

            ::SetText( "He insertado la propiedad " + AllTrim( ::oTblPro:cDesTbl ) + " correctamente en la tabla " + ::cPrefixTable( "attribute_lang" ), 3 )

         else

            ::SetText( "Error al insertar la propiedad " + AllTrim( ::oTblPro:cDesTbl ) + " en la tabla " + ::cPrefixTable( "attribute_lang" ), 3 )

         end if

         ::oTblPro:Skip()

      end while

   end if

   /*
   Dejamos la tabla como estaba antes de entrar--------------------------------
   */

   ::oTblPro:OrdSetFocus( nOrdAnt )

   ::oTblPro:GoTo( nRec )

Return ( self )

//---------------------------------------------------------------------------//

METHOD UpdatePropiedadesPrestashop( nTipoActualizacionLineas ) CLASS TComercio

   local cCommand

   DEFAULT nTipoActualizacionLineas := EDIT_MODE

   /*
   Modificamos la cabecera de las propiedades----------------------------------
   */

   cCommand       := "UPDATE " + ::cPrefixTable( "attribute_group" ) + " SET " + ;
                        "is_color_group='" + if( ::oPro:lColor, "1", "0" ) + "', " + ; 
                        "group_type='" + if( ::oPro:lColor, "color", "select" ) + "' " + ;
                     "WHERE id_attribute_group=" + AllTrim( Str( ::oPro:cCodWeb ) )                  

   TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   cCommand       := "UPDATE " + ::cPrefixTable( "attribute_group_lang" ) + " SET " + ;
                        "name='" + AllTrim( ::oPro:cDesPro ) + "', " + ; 
                        "public_name='" + AllTrim( ::oPro:cDesPro ) + "' " + ;
                     "WHERE id_attribute_group=" + AllTrim( Str( ::oPro:cCodWeb ) )

   TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   /*
   Tratamiento de las lineas de las propiedades--------------------------------
   */

   do case 
      case nTipoActualizacionLineas == EDIT_MODE //Actualiza las lineas--------

         ::UpdateLineasPropiedadesPrestashop( ::oPro:cCodPro )

      case nTipoActualizacionLineas != EDIT_MODE //Han eliminado o insertado alguna linea

         ::DeleteLineasPropiedadesPrestashop( ::oPro:cCodWeb )
         ::InsertLineasPropiedadesPrestashop( ::oPro:cCodPro, ::oPro:cCodWeb )

   end case

return ( self )

//---------------------------------------------------------------------------//

METHOD UpdateLineasPropiedadesPrestashop( nCodigoPropiedad ) CLASS TComercio

   local cCommand
   local nRec              := ::oTblPro:Recno()
   local nOrdAnt           := ::oTblPro:OrdSetFocus( "CPRO" )

   if ::oTblPro:Seek( nCodigoPropiedad )

      while nCodigoPropiedad == ::oTblPro:cCodPro .and. !::oTblPro:Eof()

         cCommand       := "UPDATE " + ::cPrefixTable( "attribute" ) + " SET " + ;
                              "color='" + AllTrim( RgbToRgbHex( ::oTblPro:nColor ) ) + "' " + ;
                           "WHERE id_attribute=" + AllTrim( Str( ::oTblPro:cCodWeb ) )

         TMSCommand():New( ::oCon ):ExecDirect( cCommand )

         cCommand       := "UPDATE " + ::cPrefixTable( "attribute_lang" ) + " SET " + ;
                              "name='" + AllTrim( ::oTblPro:cDesTbl ) + "' " + ;
                           "WHERE id_attribute=" + AllTrim( Str( ::oTblPro:cCodWeb ) )

         TMSCommand():New( ::oCon ):ExecDirect( cCommand )

         ::oTblPro:Skip()

      end while

   end if

   /*
   Dejamos la tabla como estaba antes de entrar--------------------------------
   */

   ::oTblPro:OrdSetFocus( nOrdAnt )

   ::oTblPro:GoTo( nRec )

Return ( self )

//---------------------------------------------------------------------------//

METHOD DeletePropiedadesPrestashop() CLASS TComercio

   local lReturn     := .f.
   local cCommand    := ""
   local oQuery

   cCommand          := "DELETE FROM " + ::cPrefixTable( "attribute_group" ) + " WHERE id_attribute_group=" + AllTrim( Str( ::oPro:cCodWeb ) )
   lReturn           := TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "attribute_group_lang" ) + " WHERE id_attribute_group=" + AllTrim( Str( ::oPro:cCodWeb ) )
   lReturn           := TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "attribute_group_shop" ) + " WHERE id_attribute_group=" + AllTrim( Str( ::oPro:cCodWeb ) )
   lReturn           := TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   /*
   Eliminamos las lineas-------------------------------------------------------
   */

   ::DeleteLineasPropiedadesPrestashop( ::oPro:cCodWeb )

   /*
   Quitamos la referencia de nuestra tabla-------------------------------------
   */

   ::oPro:fieldPutByName( "cCodWeb", 0 )

return ( self )

//---------------------------------------------------------------------------//

METHOD DeleteLineasPropiedadesPrestashop( nCodigoPropiedad ) CLASS TComercio

   local oQuery
   local cCommand    := ""

   /*
   Borramos las tablas auxiliares de lineas de propiedades---------------------
   */

   cCommand          := "SELECT * FROM " + ::cPrefixTable( "attribute" ) + ;
                        " WHERE id_attribute_group = " + Alltrim( Str( nCodigoPropiedad ) )

   oQuery            := TMSQuery():New( ::oCon, cCommand )

   if oQuery:Open() .and. oQuery:RecCount() > 0

      oQuery:GoTop()

      while !oQuery:Eof()

         cCommand    := "DELETE FROM " + ::cPrefixTable( "attribute_lang" ) + " WHERE id_attribute=" + AllTrim( Str( oQuery:FieldGet( 1 ) ) )
         TMSCommand():New( ::oCon ):ExecDirect( cCommand )

         oQuery:Skip()

      end while

   end if

   /*
   Borramos las líneas de propiedades de la tabla attribute--------------------
   */

   cCommand          := "DELETE FROM " + ::cPrefixTable( "attribute" ) + " WHERE id_attribute_group=" + AllTrim( Str( nCodigoPropiedad ) )
   TMSCommand():New( ::oCon ):ExecDirect( cCommand )

return ( self )

//---------------------------------------------------------------------------//

METHOD ActualizaPropiedadesPrestashop( cCodigoPropiedad, nTipoActualizacionLineas ) CLASS TComercio

   local oQuery
   local cCommand

   DEFAULT nTipoActualizacionLineas  := EDIT_MODE

   if !::lReady()
      Return .f.
   end if
   
   ::lShowDialogWait()

   if ::OpenFiles()

      if ::oPro:Seek( cCodigoPropiedad )
   
         if ::ConectBBDD()
   
            do case
               case !::oPro:lPubInt .and. ::oPro:cCodWeb != 0
      
                  ::DeletePropiedadesPrestashop()

                  ::AvisoSincronizaciontotal()
      
               case ::oPro:lPubInt .and. ::oPro:cCodWeb != 0
      
                  cCommand := 'SELECT * FROM ' + ::cPrefixTable( "attribute_group" ) +  ' WHERE id_attribute_group=' + AllTrim( Str( ::oPro:cCodWeb ) )
                  oQuery   := TMSQuery():New( ::oCon, cCommand )
      
                  if oQuery:Open()
      
                     if oQuery:RecCount() > 0

                        ::UpdatePropiedadesPrestashop( nTipoActualizacionLineas )

                        if nTipoActualizacionLineas != EDIT_MODE
                           ::AvisoSincronizaciontotal()
                        end if

                     else

                        ::InsertPropiedadesPrestashop()
                        
                        ::AvisoSincronizaciontotal()

                     end if
      
                  end if
      
                  oQuery:Free()
      
               case ::oPro:lPubInt .and. ::oPro:cCodWeb == 0
      
                  ::InsertPropiedadesPrestashop()

                  ::AvisoSincronizaciontotal()
      
            end case

            ::DisconectBBDD()
   
         end if

      end if

      ::CloseFiles()

   end if

   ::lHideDialogWait()

Return .t.

//---------------------------------------------------------------------------//

METHOD GetColorDefault() CLASS TComercio

   local nIdColorDefault   := 0

   if !Empty( ::oArt:cCodPrp1 )

      if oRetFld( ::oArt:cCodPrp1, ::oPro, "lColor", "cCodPro" )

         nIdColorDefault   := oRetFld( ::oArt:cCodPrp1, ::oPro, "cCodWeb", "cCodPro" )

       end if

   end if


   if !Empty( ::oArt:cCodPrp2 )

       if oRetFld( ::oArt:cCodPrp2, ::oPro, "lColor", "cCodPro" )

         nIdColorDefault   := oRetFld( ::oArt:cCodPrp2, ::oPro, "cCodWeb", "cCodPro" )

       end if

   end if

return( nIdColorDefault )

//---------------------------------------------------------------------------//

METHOD GetValPrp( nIdPrp, nProductAttibuteId ) CLASS TComercio

   local oQuery1
   local oQuery2
   local nIdAttribute
   local nIdAttributeGroup
   local cValPrp                 := ""

   oQuery1                       := TMSQuery():New( ::oCon, 'SELECT * FROM ps_product_attribute_combination where id_product_attribute=' + AllTrim( Str( nProductAttibuteId ) ) )

   if oQuery1:Open()

      /*
      Recorremos el Query con la consulta-----------------------------------------
      */

      if oQuery1:RecCount() > 0

         oQuery1:GoTop()

         while !oQuery1:Eof()

         nIdAttribute            := oQuery1:FieldGet( 1 )

         oQuery2                 := TMSQuery():New( ::oCon, 'SELECT * FROM ps_attribute where id_attribute=' + AllTrim( Str( nIdAttribute ) ) )

         if oQuery2:Open()

            if oQuery2:RecCount() > 0

               nIdAttributeGroup := oQuery2:FieldGet( 2 )

               if nIdAttributeGroup == nIdPrp

                  if ::oTblPro:SeekInOrd( Str( nIdAttribute, 11 ), "cCodWeb" )

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

METHOD DelIdFamiliasPrestashop() Class TComercio

   local nRec  := ::oFam:Recno()

   ::oFam:GoTop()

   while !::oFam:Eof()

      ::oFam:Load()
      ::oFam:cCodWeb := 0
      ::oFam:Save()

      ::oFam:Skip()

   end while

   ::oFam:GoTo( nRec )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD DelIdGrupoFamiliasPrestashop() Class TComercio

   local nRec  := ::oGrpFam:Recno()

   ::oGrpFam:GoTop()

   while !::oGrpFam:Eof()

      ::oGrpFam:Load()
      ::oGrpFam:cCodWeb := 0
      ::oGrpFam:Save()

      ::oGrpFam:Skip()

   end while

   ::oGrpFam:GoTo( nRec )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD DelIdTipoArticuloPrestashop() Class TComercio

   local nRec  := ::oTipArt:Recno()

   ::oTipArt:GoTop()

   while !::oTipArt:Eof()

      ::oTipArt:Load()
      ::oTipArt:cCodWeb := 0
      ::oTipArt:Save()

      ::oTipArt:Skip()

   end while

   ::oTipArt:GoTo( nRec )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD DelIdArticuloPrestashop() Class TComercio

   local nRec  := ::oArt:Recno()

   ::oArt:GoTop()

   while !::oArt:Eof()

      ::oArt:Load()
      ::oArt:cCodWeb := 0
      ::oArt:Save()

      ::oArt:Skip()

   end while

   ::oArt:GoTo( nRec )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD DelIdFabricantePrestashop() Class TComercio

   local nRec  := ::oFab:Recno()

   ::oFab:GoTop()

   while !::oFab:Eof()

      ::oFab:Load()
      ::oFab:cCodWeb := 0
      ::oFab:Save()

      ::oFab:Skip()

   end while

   ::oFab:GoTo( nRec )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD DelIdIvaPrestashop() Class TComercio

   local nRec  := ::oIva:Recno()

   ::oIva:GoTop()

   while !::oIva:Eof()

      ::oIva:Load()
      ::oIva:cCodWeb := 0
      ::oIva:Save()

      ::oIva:Skip()

   end while

   ::oIva:GoTo( nRec )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD cPreFixtable( cName ) Class TComercio

Return ( ::cPrefijoBaseDatos + AllTrim( cName ) )

//---------------------------------------------------------------------------//

METHOD ConectBBDD() Class TComercio

   local oDb
   local lReturn        := .f.

   ::oCon               := TMSConnect():New()

   if !::oCon:Connect( ::cHost, ::cUser, ::cPasswd, ::cDbName, ::nPort )

      MsgStop( "No se ha podido conectar con la base de datos." )
      lReturn           := .f.

   else

      oDb               := TMSDataBase():New ( ::oCon, ::cDbName )

      if Empty( oDb )

         MsgStop( 'La Base de datos: ' + ::cDbName + ' no esta activa.', 1 )
         lReturn        := .f.         

      else

         if Empty( ::nLanguage )
            ::nLanguage := ::GetLanguagePrestashop( oDb )
         end if   

         lReturn        := .t.

      end if

   end if   

Return lReturn

//---------------------------------------------------------------------------//

Method DisconectBBDD() Class TComercio

   if !Empty( ::oCon )
      ::oCon:Destroy()
   end if

Return .t.  

//---------------------------------------------------------------------------//

METHOD lShowDialogWait() Class TComercio

   CursorWait()

   ::oDlgWait     := TDialog():New( , , , , , "wait_web", , .f.,,,,,,.f. )

   ::oBmpWait     := TBitmap():ReDefine( 500, "logogestool_48", , ::oDlgWait, , , .f., .f., , , .f., , , .t. ) 

   ::oSayWait     := TSay():ReDefine( 510, {|| "Actualizando web espere por favor..." }, ::oDlgWait )

   TAnimat():Redefine( ::oDlgWait, 520, { "BAR_01" }, 1 )

   ::oDlgWait:Activate( , , , .t., ,.f. )

Return .t.

//---------------------------------------------------------------------------//

METHOD lHideDialogWait() Class TComercio

   ::oDlgWait:End()

   if !Empty( ::oBmpWait )
      ::oBmpWait:End()
   end if

   CursorWe()

Return .t.

//---------------------------------------------------------------------------//

METHOD cTextoWait( cText ) CLASS TComercio

   if Empty( cText )
      cText    := "Actualizando web espere por favor..."
   end if   

   if !Empty( ::oSayWait )
      ::oSayWait:SetText( cText )
   end if

Return nil

//---------------------------------------------------------------------------//

METHOD AvisoSincronizaciontotal() CLASS TComercio

   msginfo( "Faltan Avisar de que necesita una sincronización total" )

Return .t.

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
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

CLASS SPrePro

   DATA cCodArt    INIT ""
   DATA cCodPrp    INIT ""
   DATA cValPrp    INIT ""
   DATA nPrecio    INIT 0

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

function cLinkRewrite( cLink )

Return( StrTran( AllTrim( cLink ), " ", "-" ) )

//---------------------------------------------------------------------------//