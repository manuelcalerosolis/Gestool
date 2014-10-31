#include "FiveWin.Ch"
#include "Struct.ch"
#include "Factu.ch" 
#include "Ini.ch"
#include "MesDbf.ch" 

#define tipoProducto    1
#define tipoCategoria   2     

//---------------------------------------------------------------------------//

#ifndef __XHARBOUR__

CLASS TComercio
ENDCLASS

#else 

static oTimer
static oComercio
static oMsgAlarm

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

   DATA  oDlgWait
   DATA  oBmpWait
   DATA  oSayWait
   DATA  cSayWait

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
   DATA  oBtnImportar

   DATA  oTree
   DATA  oImageList

   DATA  cPath

   DATA  oIniEmpresa

   DATA  lSyncAll             INIT .f.
   DATA  lArticulos           INIT .f.
   DATA  lFamilias            INIT .f.
   DATA  lPedidos             INIT .f.
   DATA  lFabricantes         INIT .f.
   DATA  lIva                 INIT .f.
   DATA  lImagenes            INIT .f.
   DATA  lClientes            INIT .f.

   DATA  oSyncAll
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

   DATA  cPrefijoBaseDatos

   METHOD GetInstance()              
   Method New()               CONSTRUCTOR
   // Method Create()                  INLINE ( Self )
   METHOD lReady()                  INLINE ( !Empty( ::cHost) .and. !Empty( ::cUser ) .and. !Empty( ::cDbName ) )

   Method OpenFiles()
   Method CloseFiles()

   Method Activate( oWnd )
   Method StartDlg()

   METHOD ChangeSincAll()

   Method SetText( cText )
   Method MeterGlobalText( cText )
   Method MeterParticularText( cText )
   
   Method ExportarPrestashop()
   Method ImportarPrestashop()

   METHOD AppendIvaPrestashop()
   METHOD InsertIvaPrestashop()
   METHOD lUpdateIvaPrestashop( nId )
   METHOD DelIdIvaPrestashop()

   METHOD AppendFabricantesPrestashop()
   METHOD InsertFabricantesPrestashop()
   METHOD lUpdateFabricantesPrestashop()
   METHOD DelIdFabricantePrestashop()

   METHOD AppendFamiliaPrestashop()
   METHOD AddCategoriaRaiz()
   METHOD InsertCategoriesPrestashop()
   METHOD UpdateCategoriesPrestashop()
   METHOD DeleteCategoriesPrestashop()
   METHOD DeleteImagesCategories()
   METHOD ActualizaCategoriesPrestashop()
   METHOD DelCascadeCategoriesPrestashop()
   METHOD ActualizaCaterogiaPadrePrestashop()

   //METHOD InsertGrupoCategoriesPrestashop()
   //METHOD UpdateGrupoCategoriesPrestashop()
   //METHOD DeleteGrupoCategoriesPrestashop()
   //METHOD UpdateCascadeCategoriesPrestashop()
   //METHOD DelCascadeGrupoCategoriesPrestashop()
   //METHOD ActualizaGrupoCategoriesPrestashop()
   METHOD RecalculaPosicionesCategoriasPrestashop()
   
   METHOD DelIdFamiliasPrestashop()
   //METHOD DelIdGrupoFamiliasPrestashop()
   //METHOD DelIdTipoArticuloPrestashop()

   METHOD AppendPropiedadesPrestashop()
   METHOD InsertPropiedadesPrestashop()
   METHOD UpdatePropiedadesPrestashop()
   METHOD DeletePropiedadesPrestashop()
   METHOD ActualizaPropiedadesPrestashop()
   METHOD InsertLineasPropiedadesPrestashop()
   METHOD UpdateLineasPropiedadesPrestashop()
   METHOD DeleteLineasPropiedadesPrestashop()
   METHOD InsertPropiedadesProductPrestashop()
   METHOD EliminaPropiedadesProductsPrestashop()
   METHOD GetValPrp( nIdPrp, nProductAttibuteId )

   METHOD AppendArticuloPrestashop()
   METHOD ActualizaProductsPrestashop()
   METHOD InsertProductsPrestashop()
   METHOD UpdateProductsPrestashop()
   METHOD DeleteProductsPrestashop()
   METHOD InsertOfertasPrestashop()
   METHOD UpdateOfertasPrestashop()
   METHOD DeleteImagesProducts( cCodWeb )
   METHOD InsertImageProductsPrestashop( cCodArt )
   METHOD nIvaProduct( cCodArt )
   METHOD ActualizaPropiedadesProducts( cCodWeb )
   Method ActualizaStockProductsPrestashop( cCodigoArticulo )
   METHOD nIdProductAttribute( cCodWebArt, cCodWebValPr1, cCodWebValPr2 )

   METHOD DelIdArticuloPrestashop()

   METHOD AppTipoArticuloPrestashop()

   METHOD AppendImagesPrestashop()
   METHOD AddTipoImagesPrestashop( cImage )
   METHOD aTipoImagenPrestashop()
   METHOD AddImagesArticulos()
   METHOD AddImagesCategories()

   METHOD nDefImagen( cCodArt, cImagen )
   METHOD nCodigoWebImagen( cCodArt, cImagen )
   METHOD lLimpiaRefImgWeb()

   METHOD ConectBBDD()
   METHOD DisconectBBDD()
   METHOD lShowDialogWait()
   METHOD lHideDialogWait()
   METHOD cTextoWait( cText )
   METHOD AvisoSincronizaciontotal()
   METHOD cPreFixtable( cName )
   METHOD AutoRecive()
   METHOD GetLanguagePrestashop()

   Method AddImages( cImage )

   METHOD AppendClientesToPrestashop()

   METHOD AppendClientPrestashop()
   METHOD AppendPedidoprestashop()
   METHOD EstadoPedidosPrestashop()
   METHOD AppendMessagePedido()

   METHOD GetParentCategories()

   METHOD cValidDirectoryFtp( cDirectory )

   METHOD CreateDirectoryImages( cCarpeta )
   METHOD ReturnDirectoryImages( cCarpeta )

   METHOD CreateDirectoryImagesLocal( cCarpeta )

   METHOD LoadIniValues()
   METHOD SaveIniValues()

   // Datos para la recopilacion de informacion----------------------------

   DATA  aIvaData             INIT {}

   // Metodos para la recopilacion de informacion----------------------------

   METHOD buildInitData()
   METHOD buildIvaPrestashop( id )
   METHOD buildProductPrestashop( id )
   METHOD buildInsertIvaPrestashop( hIvaData )

   METHOD buildTextOk( cValue, cTable )      INLINE ( ::SetText( "Insertado correctamente " + cValue + ", en la tabla " + cTable, 3 ) )
   METHOD buildTextError( cValue, cTable )   INLINE ( ::SetText( "Error insertado " + cValue + ", en la tabla " + cTable, 3 ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oMenuItem ) CLASS TComercio

   DEFAULT oMenuItem       := "01108"

   ::oIniEmpresa           := TIni():New( cPatEmp() + "Empresa.Ini" )

   ::lSyncAll              := .f.
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
   ::cDImagen              := ::cValidDirectoryFtp( uFieldEmpresa( "cdImagen" ) )
   ::cSeriePed             := uFieldEmpresa( "cSeriePed" )
   ::nSecondTimer          := uFieldEmpresa( "nTiempoPed", 0 ) * 60000
   ::cUserFtp              := uFieldEmpresa( "cUsrFtpImg" )
   ::cPasswdFtp            := uFieldEmpresa( "cPswFtpImg" )
   ::cHostFtp              := uFieldEmpresa( "cHstFtpImg" )
   ::nPortFtp              := uFieldEmpresa( "nPrtFtp", 21 )
   ::lPassiveFtp           := uFieldEmpresa( "lPasFtp" )
   ::Cookiekey             := uFieldEmpresa( "cCooKey" )
   ::cPrefijoBaseDatos     := uFieldEmpresa( "cPrefixTbl" )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD GetInstance() CLASS TComercio

   if Empty( ::oInstance )
      ::oInstance          := ::New()
   end if

RETURN ( ::oInstance )

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

   DATABASE NEW ::oOferta  PATH ( cPatArt() ) FILE "OFERTA.DBF"      VIA ( cDriver() ) SHARED INDEX "OFERTA.CDX"

   DATABASE NEW ::oFam     PATH ( cPatArt() ) FILE "FAMILIAS.DBF"    VIA ( cDriver() ) SHARED INDEX "FAMILIAS.CDX"

   DATABASE NEW ::oGrpFam  PATH ( cPatArt() ) FILE "GRPFAM.DBF"      VIA ( cDriver() ) SHARED INDEX "GRPFAM.CDX"

   DATABASE NEW ::oTipArt  PATH ( cPatArt() ) FILE "TIPART.DBF"      VIA ( cDriver() ) SHARED INDEX "TIPART.CDX"

   DATABASE NEW ::oCli     PATH ( cPatCli() ) FILE "CLIENT.DBF"      VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

   DATABASE NEW ::oObras   PATH ( cPatCli() ) FILE "OBRAST.DBF"      VIA ( cDriver() ) SHARED INDEX "OBRAST.CDX"

   DATABASE NEW ::oIva     PATH ( cPatDat() ) FILE "TIVA.DBF"        VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   DATABASE NEW ::oDivisas PATH ( cPatDat() ) FILE "DIVISAS.DBF"     VIA ( cDriver() ) SHARED INDEX "DIVISAS.CDX"

   ::oPedCliT := TDataCenter():oPedCliT()

   DATABASE NEW ::oPedCliI PATH ( cPatEmp() ) FILE "PEDCLII.DBF"     VIA ( cDriver() ) SHARED INDEX "PEDCLII.CDX"

   DATABASE NEW ::oPedCliL PATH ( cPatEmp() ) FILE "PEDCLIL.DBF"     VIA ( cDriver() ) SHARED INDEX "PEDCLIL.CDX"

   DATABASE NEW ::oCount   PATH ( cPatEmp() ) FILE "NCOUNT.DBF"      VIA ( cDriver() ) SHARED INDEX "NCOUNT.CDX"

   DATABASE NEW ::oFPago   PATH ( cPatEmp() ) FILE "FPAGO.DBF"       VIA ( cDriver() ) SHARED INDEX "FPAGO.CDX"

   DATABASE NEW ::oFab     PATH ( cPatArt() ) FILE "FABRICANTES.DBF" VIA ( cDriver() ) SHARED INDEX "FABRICANTES.CDX"

   DATABASE NEW ::oKit     PATH ( cPatArt() ) FILE "ARTKIT.DBF"      VIA ( cDriver() ) SHARED INDEX "ARTKIT.Cdx"

   ::oAlbCliT := TDataCenter():oAlbCliT()

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

   if !Empty( ::oOferta ) .and. ::oOferta:Used()
      ::oOferta:End()
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
   ::oOferta   := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Activate( oWnd ) CLASS TComercio

   DEFAULT  oWnd        := oWnd()

   ::nLevel             := nLevelUsr( "01108" )

   if nAnd( ::nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      return ( Self )
   end if

   if oWnd != nil
      SysRefresh(); oWnd:CloseAll(); SysRefresh()
   end if

   ::LoadIniValues()

   /*
   Apertura del fichero de texto---------------------------------------------//
   */

   DEFINE DIALOG ::oDlg RESOURCE "Comercio_0"

      REDEFINE BITMAP ::oBmp ;
         ID       500 ;
         RESOURCE "earth2_alpha_48" ;
         TRANSPARENT ;
         OF       ::oDlg

      // Opciones de sincronización--------------------------------------------

      REDEFINE CHECKBOX ::oSyncAll VAR ::lSyncAll;
         ID       100 ;
         ON CHANGE( ::ChangeSincAll() );
         OF       ::oDlg

      REDEFINE CHECKBOX ::oTipIva VAR ::lIva ;
         ID       110 ;
         WHEN     ( !::lSyncAll );
         OF       ::oDlg

      REDEFINE CHECKBOX ::oArticulos VAR ::lArticulos ;
         ID       120 ;
         WHEN     ( !::lSyncAll );
         OF       ::oDlg

      REDEFINE CHECKBOX ::oCliente VAR ::lClientes ;
         ID       130 ;
         WHEN     ( !::lSyncAll );
         OF       ::oDlg 

      REDEFINE CHECKBOX ::oImagenes VAR ::lImagenes ;
         ID       240 ;
         WHEN     ( !::lSyncAll );
         OF       ::oDlg 

      // Servidor--------------------------------------------------------------

      REDEFINE SAY PROMPT ::cHost;
         ID       140 ;
         OF       ::oDlg

      // Puerto----------------------------------------------------------------

      REDEFINE SAY PROMPT ::nPort; 
         ID       150 ;
         OF       ::oDlg

      // Usuario---------------------------------------------------------------

      REDEFINE SAY PROMPT ::cUser;
         ID       160 ;
         OF       ::oDlg

      // Base de datos---------------------------------------------------------

      REDEFINE SAY PROMPT ::cDbName;
         ID       170 ;
         OF       ::oDlg

      REDEFINE SAY PROMPT ::cUserFtp ;
         ID       180 ;
         OF       ::oDlg

      REDEFINE SAY PROMPT ::cDImagen ;
         ID       190 ;
         OF       ::oDlg

      /*
      Botones exportación------------------------------------------------------
      */

      REDEFINE BUTTONBMP ::oBtnExportar ;
         ID       510 ;
         OF       ::oDlg;
         ACTION   ( ::ExportarPrestashop() );

      REDEFINE BUTTONBMP ::oBtnImportar ;
         ID       520 ;
         OF       ::oDlg;
         ACTION   ( ::ImportarPrestashop() );

      /*
      Tree---------------------------------------------------------------------
      */   

      ::oTree        := TTreeView():Redefine( 200, ::oDlg )

      REDEFINE SAY ::oText PROMPT ::cText ID 210 OF ::oDlg

      ::oMeter       := TApoloMeter():ReDefine( 220, { | u | if( pCount() == 0, ::nActualMeter, ::nActualMeter := u ) }, 10, ::oDlg, .f., , , .t., rgb( 255,255,255 ), , rgb( 128,255,0 ) )

      ::oMeterL      := TApoloMeter():ReDefine( 230, { | u | if( pCount() == 0, ::nActualMeterL, ::nActualMeterL := u ) }, 10, ::oDlg, .f., , , .t., rgb( 255,255,255 ), , rgb( 128,255,0 ) )

      /*
      Botones salida-----------------------------------------------------------
      */      

      REDEFINE BUTTON ::oBtnCancel ;
         ID       IDCANCEL ;
         OF       ::oDlg ;
         ACTION   ( ::oDlg:end() )

         ::oDlg:bStart := {|| ::StartDlg() }

   ACTIVATE DIALOG ::oDlg CENTER

   /*
   Liberamos la imagen---------------------------------------------------------
   */

   ::oBmp:End()

Return Nil

//---------------------------------------------------------------------------//

METHOD LoadIniValues() CLASS TComercio

      ::lArticulos            := ::oIniEmpresa:Get( "Prestashop", "Articulos",   .t., ::lArticulos   )
      ::lFamilias             := ::oIniEmpresa:Get( "Prestashop", "Familias",    .t., ::lFamilias    )
      ::lPedidos              := ::oIniEmpresa:Get( "Prestashop", "Pedidos",     .t., ::lPedidos     )
      ::lFabricantes          := ::oIniEmpresa:Get( "Prestashop", "Fabricantes", .t., ::lFabricantes )
      ::lIva                  := ::oIniEmpresa:Get( "Prestashop", "Iva",         .t., ::lIva         )
      ::lClientes             := ::oIniEmpresa:Get( "Prestashop", "Clientes",    .t., ::lClientes    )
      ::lImagenes             := ::oIniEmpresa:Get( "Prestashop", "Imagenes",    .t., ::lImagenes    )

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD SaveIniValues() CLASS TComercio

      ::oIniEmpresa:Set( "Prestashop", "Articulos",   ::lArticulos   )
      ::oIniEmpresa:Set( "Prestashop", "Familias",    ::lFamilias    )
      ::oIniEmpresa:Set( "Prestashop", "Pedidos",     ::lPedidos     )
      ::oIniEmpresa:Set( "Prestashop", "Fabricantes", ::lFabricantes )
      ::oIniEmpresa:Set( "Prestashop", "Iva",         ::lIva         )
      ::oIniEmpresa:Set( "Prestashop", "Clientes",    ::lClientes    )
      ::oIniEmpresa:Set( "Prestashop", "Imagenes",    ::lImagenes    )

RETURN ( Self )

//------------------------------------------------------------------------//

Method StartDlg() CLASS TComercio

   if uFieldEmpresa( "lHExpWeb" )
      ::oBtnExportar:Hide()
      ::oSyncAll:Hide()
      ::oTipIva:Hide()
      ::oArticulos:Hide()
      ::oCliente:Hide()
      ::oImagenes:Hide()
   else
      ::oBtnExportar:Show()
      ::oSyncAll:Show()
      ::oTipIva:Show()
      ::oArticulos:Show()
      ::oCliente:Show()
      ::oImagenes:Show()
   end if

Return nil

//---------------------------------------------------------------------------//

METHOD ChangeSincAll() CLASS TComercio

   if ::lSyncAll

      ::oArticulos:Disable()
      ::oTipIva:Disable()
      ::oCliente:Disable()

   else

      ::oArticulos:Enable()
      ::oTipIva:Enable()
      ::oCliente:Enable()

   end if

Return .t.

//---------------------------------------------------------------------------//

METHOD SetText( cText, nLevel ) CLASS TComercio

   DEFAULT nLevel    := 2

   ::cTextoWait( cText )

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

Method ExportarPrestashop() Class TComercio

   local oDb
   local oBlock
   local oError

   ::aCategorias     := {}

   ::oBtnExportar:Hide()
   ::oBtnImportar:Hide()

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

         oDb            := TMSDataBase():New( ::oCon, ::cDbName )

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

            if ::lIva .or. ::lSyncAll
               ::MeterGlobalText( "Actualizando tipos de " + cImp() )
               ::SetText ( 'Exportando tablas de tipos de ' + cImp(), 2 )
               ::AppendIvaPrestashop( odb )
               sysRefresh()
            end if

            /*
            Pasamos los artículos a prestashop------------------------------
            */

            if ::lArticulos .or. ::lSyncAll

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
            Pasamos los clientes desde el programa a prestashop-------------

            if ::lClientes .or. ::lSyncAll

               ::MeterGlobalText( "Actualizando estado de los pedidos" )
               ::AppendClientesToPrestashop()
               sysRefresh()

            end if
            */

            /*
            Pasamos las imágenes de los artículos a prestashop--------------
            */

            ::MeterGlobalText( "Subiendo imagenes" )

            if ::lImagenes .or. ::lSyncAll
               ::AppendImagesPrestashop()
            end if

         end if

      end if

      ::oCon:Destroy()

      ::SetText( 'Base de datos desconectada.', 1 )

      /*
      Guardamos la configuración en el INI-------------------------------------
      */

      ::SaveIniValues()

      /*
      Para que al final del proceso quede totalmente llena la barra del meter--
      */

      ::oMeter:Set( 100 )
      ::oMeterL:Set( 100 )

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
   ::oBtnImportar:Hide()

   ::oBtnCancel:Enable()

Return .t.

//---------------------------------------------------------------------------//

Method ImportarPrestashop() CLASS TComercio

   local oDb
   local oBlock
   local oError

   ::oBtnExportar:Hide()
   ::oBtnImportar:Hide()

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

          oDb := TMSDataBase():New ( ::oCon, ::cDbName )

          if Empty( oDb )

             ::SetText ( 'La Base de datos: ' + ::cDbName + ' no esta activa.', 1 )

          else

            /*
            Nos traemos los clientes y pedidos hacia nuestras bases de datos y actualizamos el estado de los pedidos de arriba
            */

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

      end if

      ::oCon:Destroy()

      ::SetText( 'Base de datos desconectada.', 1 )

      ::MeterGlobalText( "Proceso finalizado" )

      /*
      Para que al final del proceso quede totalmente llena la barra del meter--
      */

      ::oMeter:Set( 100 )
      ::oMeterL:Set( 100 )

   else

      ::SetText( 'Error al abrir los ficheros necesarios.', 1 )

   end if

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Error al conectarnos con la base de datos" )

   END SEQUENCE

   ErrorBlock( oBlock )

   ::Closefiles()

   ::oBtnExportar:Hide()
   ::oBtnImportar:Hide()

   ::oBtnCancel:Enable()

Return .t.

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
   Inicializamos el código para la web en el programa--------------------------
   */

   ::DelIdIvaPrestashop()

   /*
   Añadimos tipos de IVA a prestashop------------------------------------------
   */

   ::oIva:GoTop()

   while !::oIva:Eof()

      if ::oIva:lPubInt

         ::MeterParticularText( "Actualizando tipos de " + cImp() )

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

   cCommand := "INSERT INTO " + ::cPreFixtable( "tax") + ;
                  "( rate, " + ;
                  "active ) " + ;
               "VALUES " + ;
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
   Insertamos un tipo de IVA nuevo en la tabla tax_lang-----------------
   */

   cCommand := "INSERT INTO " + ::cPrefixTable( "tax_lang" ) + "( " +;
                  "id_tax, " + ;
                  "id_lang, " + ;
                  "name )" + ;
               " VALUES " + ;
                  "('" + Str( nCodigoWeb ) + "', " + ;         // id_tax
                  "'" + Str( ::nLanguage ) + "', " + ;         // id_lang
                  "'" + ::oCon:EscapeStr( ::oIva:DescIva ) + "' )"      // name

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )

      ::SetText( "He insertado el tipo de " + cImp() + Space(1) + AllTrim( ::oIva:DescIva ) + " correctamente en la tabla" + ::cPrefixTable( "tax_lang" ), 3 )

   else

      ::SetText( "Error al insertar el tipo de " + cImp() + Space(1) + AllTrim( ::oIva:DescIva ) + " en la tabla" + ::cPrefixTable( "tax_lang" ), 3 )

   end if

   /*
   Insertamos un tipo de IVA nuevo en la tabla tax_rule_group-----------------
   */

   cCommand := "INSERT INTO "+ ::cPrefixTable( "tax_rules_group" ) + "( " + ;
                  "name, " + ;
                  "active )" + ;
               " VALUES " + ;
                  "('" + ::oCon:EscapeStr( ::oIva:DescIva ) + "', " + ; // name
                  "'1' )"                                      // active

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )

      nCodigoGrupoWeb           := ::oCon:GetInsertId()

      ::oIva:fieldPutByName( "cGrpWeb", nCodigoGrupoWeb )

      ::SetText( "He insertado el tipo de " + cImp() + Space(1) + AllTrim( ::oIva:DescIva ) + " correctamente en la tabla " + ::cPreFixtable( "tax_rule_group" ), 3 )

   else

      ::SetText( "Error al insertar el tipo de " + cImp() + Space(1) + AllTrim( ::oIva:DescIva ) + " en la tabla " + ::cPreFixTable( "tax_rule_group" ), 3 )

   end if

   /*
   Insertamos un tipo de IVA nuevo en la tabla tax_rule-----------------
   */

   cCommand := "INSERT INTO " + ::cPrefixTable( "tax_rule" ) + "( " +;
                  "id_tax_rules_group, " + ;
                  "id_country, " + ;
                  "id_tax )" + ;
               " VALUES " + ;
                  "('" + Str( nCodigoGrupoWeb ) + "', " + ;  // id_tax_rules_group
                  "'6', " + ;                                // id_country - 6 es el valor de España
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

   if TMSCommand():New( ::oCon ):ExecDirect( "UPDATE " + ::cPrefixTable( "tax" ) + " SET rate='" + AllTrim( Str( ::oIva:TpIva ) ) + "' WHERE id_tax=" + AllTrim( Str( nId ) ) )
      ::SetText( "Actualizada correctamente el tipo de " + cImp() + Space(1) + AllTrim( ::oIva:DescIva ) + " en la tabla tax", 3 )
      lReturn     := .t.
   else
      ::SetText( "Error al actualizar el tipo de " + cImp() + Space(1) + AllTrim( ::oIva:DescIva ) + " en la tabla tax", 3 )
      lReturn     := .f.
   end if

   if TMSCommand():New( ::oCon ):ExecDirect( "UPDATE " + ::cPrefixTable( "tax_lang" ) + " SET name='" + AllTrim( ::oIva:DescIva ) + "' WHERE id_tax=" + AllTrim( Str( nId ) ) )
      ::SetText( "Actualizada correctamente el tipo de " + cImp() + Space(1) + AllTrim( ::oIva:DescIva ) + " en la tabla tax_lang", 3 )
      lReturn     := .t.
   else
      ::SetText( "Error al actualizar el tipo de " + cImp() + Space(1) + AllTrim( ::oIva:DescIva ) + " en la tabla tax_lang", 3 )
      lReturn     := .f.
   end if

   if TMSCommand():New( ::oCon ):ExecDirect( "UPDATE " + ::cPrefixTable( "tax_rules_group" ) + " SET name='" + AllTrim( ::oIva:DescIva ) + "' WHERE id_tax_rules_group=" + AllTrim( Str( nId ) ) )
      ::SetText( "Actualizada correctamente el tipo de " + cImp() + Space(1) + AllTrim( ::oIva:DescIva ) + " en la tabla tax_rules_group", 3 )
      lReturn     := .t.
   else
      ::SetText( "Error al actualizar el tipo de " + cImp() + Space(1) + AllTrim( ::oIva:DescIva ) + " en la tabla tax_rules_group", 3 )
      lReturn     := .f.
   end if

Return lReturn

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
                  "('" + ::oCon:EscapeStr( ::oFab:cNomFab ) + "', " + ;       //name
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

   if TMSCommand():New( ::oCon ):ExecDirect( "UPDATE " + ::cPrefixTable( "manufacturer" ) + " SET name='" + AllTrim( ::oFab:cNomFab ) + "', date_upd='" + dtos( GetSysDate() ) + "' WHERE id_manufacturer=" + AllTrim( Str( ::oFab:cCodWeb ) ) )
      ::SetText( "Actualizada correctamente el fabricante " + AllTrim( ::oFab:cNomFab ) + " en la tabla manufacturer", 3 )
      lReturn     := .t.
   else
     ::SetText( "Error al actualizar el fabricante " + AllTrim( ::oFab:cNomFab ) + " en la tabla manufacturer", 3 )
     lReturn     := .f.
   end if

Return lReturn   

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

   /*
   Cargamos la categoría raiz de la que colgarán todas las demás------------
   */

   ::AddCategoriaRaiz()

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

   /*
   Damos una segunda pasada para ponerle los id de los padres------------------
   */

   ::oFam:GoTop()

   while !::oFam:Eof()

      if ::oFam:lPubInt .and. !Empty( ::oFam:cFamCmb )

         ::MeterParticularText( "Actualizando familias" )

         ::ActualizaCaterogiaPadrePrestashop()

      end if

      ::oFam:FieldPutByName( "lSelDoc", .f. )

      ::oFam:Skip()

   end while

Return ( Self )

//---------------------------------------------------------------------------//

METHOD ActualizaCaterogiaPadrePrestashop() CLASS TComercio

   local lReturn  := .f.
   local cCommand := ""
   local nParent  := 2

   /*
   Actualizamos las familias padre en prestashop-------------------------------
   */

   ::cTextoWait( "Actualizando categoría: " + ::oFam:cNomFam )

   nParent                 := oRetFld( ::oFam:cFamCmb, ::oFam, "cCodWeb" )
      
   if nParent == 0
      nParent              := 2
   end if

   cCommand       := "UPDATE " + ::cPrefixTable( "category" ) + " SET " + ;
                        "id_parent='" + AllTrim( Str( nParent ) ) + "' " +;
                        "WHERE id_category=" + AllTrim( Str( ::oFam:cCodWeb ) )

   lReturn        := TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   SysRefresh()

Return lReturn

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
      ::SetText( "Error al insertar la categoría root en category_group", 3 )
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
                  if( Empty( ::oFam:cDesWeb ), AllTrim( ::oFam:cNomFam ), AllTrim( ::oFam:cDesWeb ) ) + "', '" + ;
                  if( Empty( ::oFam:cDesWeb ), AllTrim( ::oFam:cNomFam ), AllTrim( ::oFam:cDesWeb ) ) + "', '" + ;
                  cLinkRewrite( if( Empty( ::oFam:cDesWeb ), AllTrim( ::oFam:cNomFam ), AllTrim( ::oFam:cDesWeb ) ) ) + "', " + ;
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

   ::ActualizaCaterogiaPadrePrestashop()

   cCommand       := "UPDATE " + ::cPrefixTable( "category_lang" ) + " SET " + ;
                        "name='" + if( Empty( ::oFam:cDesWeb ), AllTrim( ::oFam:cNomFam ), AllTrim( ::oFam:cDesWeb ) ) + "', " + ;
                        "description='" + if( Empty( ::oFam:cDesWeb ), AllTrim( ::oFam:cNomFam ), AllTrim( ::oFam:cDesWeb ) ) + "', " + ;
                        "link_rewrite='" + cLinkRewrite( if( Empty( ::oFam:cDesWeb ), AllTrim( ::oFam:cNomFam ), AllTrim( ::oFam:cDesWeb ) ) ) + "' " + ;
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

   if TMSCommand():New( ::oCon ):ExecDirect( "UPDATE " + ::cPrefixTable( "category" ) + " SET nLeft='1', nRight='" + AllTrim( Str( ::nNumeroCategorias * 2 ) ) + "' WHERE id_category=1" )
      ::SetText( "Actualizada correctamente el grupo de familia en la tabla category", 3 )
   else
      ::SetText( "Error al actualizar el grupo de familia en la tabla category", 3 )
   end if

   if TMSCommand():New( ::oCon ):ExecDirect( "UPDATE " + ::cPrefixTable( "category" ) + " SET nLeft='2', nRight='" + AllTrim( Str( ( ::nNumeroCategorias * 2 ) -1 ) ) + "' WHERE id_category=2" )
      ::SetText( "Actualizada correctamente el grupo de familia en la tabla category", 3 )
   else
      ::SetText( "Error al actualizar el grupo de familia en la tabla category", 3 )
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

      if TMSCommand():New( ::oCon ):ExecDirect( "UPDATE " + ::cPrefixTable( "category" ) + " SET nLeft='" + AllTrim( Str( oCategoria:nLeft ) ) + "', nRight='" + AllTrim( Str( ( oCategoria:nRight ) ) + "' WHERE id_category=" + AllTrim( Str( oCategoria:id ) ) ) )
         ::SetText( "Actualizada correctamente el grupo de familia en la tabla category", 3 )
      else
         ::SetText( "Error al actualizar el grupo de familia en la tabla category", 3 )
      end if

   next

return ( .t. )

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

   cCommand       := "TRUNCATE TABLE " + ::cPrefixTable( "attribute_shop" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText ( 'Tabla ' + ::cPrefixTable( "attribute_shop" ) + ' borrada correctamente', 3  )
   else
      ::SetText ( 'Error al borrar la tabla ' + ::cPrefixTable( "attribute_shop" ), 3  )
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
                                  "'" + if( Empty( ::oPro:cNomInt ), AllTrim( ::oPro:cDesPro ), AllTrim( ::oPro:cNomInt ) ) + "', " + ;          //name
                                  "'" + if( Empty( ::oPro:cNomInt ), AllTrim( ::oPro:cDesPro ), AllTrim( ::oPro:cNomInt ) ) + "' )"              //public_name

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
                        "name='" + if( Empty( ::oPro:cNomInt ), AllTrim( ::oPro:cDesPro ), AllTrim( ::oPro:cNomInt ) ) + "', " + ; 
                        "public_name='" + if( Empty( ::oPro:cNomInt ), AllTrim( ::oPro:cDesPro ), AllTrim( ::oPro:cNomInt ) ) + "' " + ;
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

            ::SetText( "Error al insertar la propiedad " + AllTrim( ::oTblPro:cDesTbl ) + " en la tabla " + ::cPreFixtable( "attribute" ), 3 )

         end if

         cCommand    := "INSERT INTO " + ::cPrefixTable( "attribute_lang" ) + ;
                           " ( id_attribute, " + ;
                              "id_lang, " + ;
                              "name ) " + ;
                           "VALUES " + ;
                              "('" + AllTrim( Str( nCodigoPropiedad ) ) + "', " + ;   //id_attribute
                              "'" + Str( ::nLanguage ) + "', " + ;                    //id_lang
                              "'" + ::oCon:EscapeStr( ::oTblPro:cDesTbl ) + "' )"              //name

         if TMSCommand():New( ::oCon ):ExecDirect( cCommand )

            ::SetText( "He insertado la propiedad " + AllTrim( ::oTblPro:cDesTbl ) + " correctamente en la tabla " + ::cPrefixTable( "attribute_lang" ), 3 )

         else

            ::SetText( "Error al insertar la propiedad " + AllTrim( ::oTblPro:cDesTbl ) + " en la tabla " + ::cPrefixTable( "attribute_lang" ), 3 )

         end if

         cCommand    := "INSERT INTO " + ::cPrefixTable( "attribute_shop" ) + ;
                           " ( id_attribute, " + ;
                              "id_shop ) " + ;
                           "VALUES " + ;
                              "('" + AllTrim( Str( nCodigoPropiedad ) ) + "', " + ;   //id_attribute
                              "'1' )"                                                 //id_shop

         if TMSCommand():New( ::oCon ):ExecDirect( cCommand )

            ::SetText( "He insertado la propiedad " + AllTrim( ::oTblPro:cDesTbl ) + " correctamente en la tabla " + ::cPrefixTable( "attribute_shop" ), 3 )

         else

            ::SetText( "Error al insertar la propiedad " + AllTrim( ::oTblPro:cDesTbl ) + " en la tabla " + ::cPrefixTable( "attribute_shop" ), 3 )

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

METHOD InsertPropiedadesProductPrestashop( nCodigoWeb ) CLASS TComercio

   local nCodigoImagen        := 0
   local oImagen
   local nPosition            := 1
   local nCodigoPropiedad     := 0
   local aPropiedades1        := {}
   local aPropiedades2        := {}
   local aPropiedad1
   local aPropiedad2
   local nOrdAnt
   local nPrecio              := 0
   local nParent              := ::GetParentCategories()
   local cCommand             := ""
   local nOrdArtDiv           := ::oArtDiv:OrdSetFocus( "cCodArt" )
   local lDefault             := .t.
   local nTotStock            := 0

   /*
   Comprobamos si el artículo tiene propiedades y metemos las propiedades
   */

   if ::oArtDiv:Seek( ::oArt:Codigo )

      while ::oArtDiv:cCodArt == ::oArt:Codigo .and. !::oArtDiv:Eof()

         do case

            /*
            -------------------------------------------------------------------
            Caso de tener una sola propiedad-----------------------------------
            -------------------------------------------------------------------
            */

            case !Empty( ::oArtDiv:cValPr1 ) .and. Empty( ::oArtDiv:cValPr2 )

               nOrdAnt        :=   ::oTblPro:OrdSetFocus( "cCodPro" )

               if ::oTblPro:Seek( ::oArtDiv:cCodPr1 + ::oArtDiv:cValPr1 )

                  nPrecio     := nPrePro( ::oArt:Codigo, ::oArtDiv:cCodPr1, ::oArtDiv:cValPr1, Space( 20 ), Space( 20 ), 1, .f., ::oArtDiv:cAlias )

                  /*
                  Metemos la propiedad de éste artículo------------------------
                  */

                  cCommand    :=    "INSERT INTO " + ::cPrefixTable( "product_attribute" ) + " ( " + ;
                                       "id_product, " + ;
                                       "price, " + ;
                                       "wholesale_price, " + ;
                                       "quantity, " + ;
                                       "minimal_quantity )" + ;
                                    " VALUES " + ;
                                       "('" + AllTrim( Str( nCodigoWeb ) ) + "', " + ;                                  //id_product
                                       "'" + AllTrim( Str( if( nPrecio != 0, nPrecio, ::oArt:nImpInt1 ) ) ) + "', " + ; //price
                                       "'" + AllTrim( Str( if( nPrecio != 0, nPrecio, ::oArt:nImpInt1 ) ) ) + "', " + ; //wholesale_price
                                       "'10000', " + ;                                                                  //quantity
                                       "'1' )"                                                                          //minimal_quantity

                  if TMSCommand():New( ::oCon ):ExecDirect( cCommand )

                     nCodigoPropiedad           := ::oCon:GetInsertId()

                     ::SetText( "He insertado la propiedad  " + AllTrim( ::oTblPro:cDesTbl ) + " correctamente en la tabla " + ::cPrefixTable( "product_attribute" ), 3 )

                  else
                     ::SetText( "Error al insertar la propiedad " + AllTrim( ::oTblPro:cDesTbl ) + " en la tabla " + ::cPrefixTable( "product_attribute" ), 3 )
                  end if

                  /*
                  Metemos la relación de la propiedad con el artículo----------
                  */

                  cCommand    := "INSERT INTO " + ::cPrefixTable( "product_attribute_combination" ) + " ( " + ;
                                    "id_attribute, " + ;
                                    "id_product_attribute )" + ;
                                 " VALUES " + ;
                                    "('" + AllTrim( Str( ::oTblPro:cCodWeb ) ) + "', " + ;   //id_attribute
                                    "'" + AllTrim( Str( nCodigoPropiedad ) ) + "' )"         //id_product_attribute

                  if TMSCommand():New( ::oCon ):ExecDirect( cCommand )

                     ::SetText( "He insertado la propiedad  " + AllTrim( ::oTblPro:cDesTbl ) + " correctamente en la tabla " + ::cPrefixTable( "product_attribute_combination" ), 3 )

                  else
                     ::SetText( "Error al insertar la propiedad " + AllTrim( ::oTblPro:cDesTbl ) + " en la tabla " + ::cPrefixTable( "product_attribute_combination" ), 3 )
                  end if

                  /*
                  Metemos la relación entre la propiedad y el shop-------------
                  */

                  cCommand    :=    "INSERT INTO " + ::cPrefixTable( "product_attribute_shop" ) + " ( " + ;
                                       "id_product_attribute, " + ;
                                       "id_shop, " + ;
                                       "wholesale_price, " + ;
                                       "price, " + ;
                                       "ecotax, " + ;
                                       "weight, " + ;
                                       "unit_price_impact, " + ;
                                       "default_on, " + ;
                                       "minimal_quantity )" + ;
                                    " VALUES " + ;
                                       "('" + AllTrim( Str( nCodigoPropiedad ) ) + "', " + ;
                                       "'1', " + ;
                                       "'" + AllTrim( Str( if( nPrecio != 0, nPrecio, ::oArt:nImpInt1 ) ) ) + "', " + ;
                                       "'" + AllTrim( Str( if( nPrecio != 0, nPrecio, ::oArt:nImpInt1 ) ) ) + "', " + ;
                                       "'0', " + ;
                                       "'0', " + ;
                                       "'0', " + ;
                                       "'" + if( lDefault, "1", "0" ) + "', " + ;
                                       "'1' )"

                  if TMSCommand():New( ::oCon ):ExecDirect( cCommand )

                     ::SetText( "He insertado la propiedad  " + AllTrim( ::oTblPro:cDesTbl ) + " correctamente en la tabla " + ::cPrefixTable( "product_attribute_shop" ), 3 )

                  else
                     ::SetText( "Error al insertar la propiedad " + AllTrim( ::oTblPro:cDesTbl ) + " en la tabla " + ::cPrefixTable( "product_attribute_shop" ), 3 )
                  end if

                  /*
                  Metemos el stock por cada propiedad--------------------------
                  */

                  nTotStock   := ::oStock:nStockAlmacen( ::oArt:Codigo, , ::oArtDiv:cValPr1 )

                  cCommand    :=    "INSERT INTO " + ::cPrefixTable( "stock_available" ) + " ( " + ;
                                       "id_product, " + ;
                                       "id_product_attribute, " + ;
                                       "id_shop, " + ;
                                       "id_shop_group, " + ;
                                       "quantity, " + ;
                                       "depends_on_stock, " + ;
                                       "out_of_stock )" + ;
                                    " VALUES " + ;
                                       "('" + AllTrim( Str( nCodigoWeb ) ) + "', " + ;
                                       "'" + AllTrim( Str( nCodigoPropiedad ) ) + "', " + ;   
                                       "'1', " + ;
                                       "'0', " + ;
                                       "'" + AllTrim( Str( nTotStock ) ) + "', " + ;
                                       "'0', " + ;
                                       "'2' )"

                  if TMSCommand():New( ::oCon ):ExecDirect( cCommand )

                     ::SetText( "He insertado la propiedad  " + AllTrim( ::oTblPro:cDesTbl ) + " correctamente en la tabla " + ::cPrefixTable( "stock_available" ), 3 )

                  else
                     ::SetText( "Error al insertar la propiedad " + AllTrim( ::oTblPro:cDesTbl ) + " en la tabla " + ::cPrefixTable( "stock_available" ), 3 )
                  end if

                  /*
                  -------------------------------------------------------------
                  Imágenes para una sola propiedad-----------------------------
                  -------------------------------------------------------------
                  */

                  if !Empty( ::oArtDiv:cImgWeb )

                     if ::oArtImg:SeekInOrd( ::oArt:Codigo, "cCodArt" )

                        while ::oArtImg:cCodArt == ::oArt:Codigo .and. !::oArtImg:Eof()

                           if AllTrim( ::oArtImg:cImgArt ) == AllTrim( ::oArtDiv:cImgWeb )

                              /*
                              Añadimos en la tabla product_attribute_image-----------
                              */

                              cCommand    := "INSERT INTO " + ::cPrefixTable( "product_attribute_image" ) + " ( " + ;
                                                "id_product_attribute, " + ;
                                                "id_image )" + ;
                                             " VALUES " + ;
                                                "('" + AllTrim( Str( nCodigoPropiedad ) ) + "', " + ;    //id_product
                                                "'" + AllTrim( Str( ::oArtImg:cCodWeb ) ) + "' )"        //cover
   
                              if TMSCommand():New( ::oCon ):ExecDirect( cCommand )

                                 ::SetText( "He insertado el artículo " + AllTrim( ::oArt:Nombre ) + " correctamente en la tabla " + ::cPrefixTable( "product_attribute_image" ), 3 )

                              else

                                 ::SetText( "Error al insertar el artículo " + AllTrim( ::oArt:Nombre ) + " en la tabla " + ::cPrefixTable( "product_attribute_image" ), 3 )

                              end if

                           end if   

                           ::oArtImg:Skip()

                        end while   

                     end if

                  end if

               end if

            /*
            -------------------------------------------------------------------
            Caso de tener dos propiedades--------------------------------------
            -------------------------------------------------------------------
            */

            case !Empty( ::oArtDiv:cValPr1 ) .and. !Empty( ::oArtDiv:cValPr2 )

               nPrecio     := nPrePro( ::oArt:Codigo, ::oArtDiv:cCodPr1, ::oArtDiv:cValPr1, ::oArtDiv:cCodPr2, ::oArtDiv:cValPr2, 1, .f., ::oArtDiv:cAlias )

               /*
               Metemos la propiedad de éste artículo---------------------------
               */

               cCommand    := "INSERT INTO " + ::cPrefixTable( "product_attribute" ) + " ( " + ;
                                 "id_product, " + ;
                                 "price, " + ;
                                 "wholesale_price, " + ;
                                 "quantity, " + ;
                                 "minimal_quantity )" + ;
                              " VALUES " + ;
                                 "('" + AllTrim( Str( nCodigoWeb ) ) + "', " + ;                                  //id_product
                                 "'" + AllTrim( Str( if( nPrecio != 0, nPrecio, ::oArt:nImpInt1 ) ) ) + "', " + ; //price
                                 "'" + AllTrim( Str( if( nPrecio != 0, nPrecio, ::oArt:nImpInt1 ) ) ) + "', " + ; //wholesale_price
                                 "'10000', " + ;                                                                  //quantity
                                 "'1' )"                                                                          //minimal_quantity

               if TMSCommand():New( ::oCon ):ExecDirect( cCommand )

                  nCodigoPropiedad           := ::oCon:GetInsertId()

                  ::SetText( "He insertado la propiedad  " + AllTrim( ::oArtDiv:cValPr1 ) + " - " + AllTrim( ::oArtDiv:cValPr2 ) + " correctamente en la tabla " + ::cPrefixTable( "product_attribute" ), 3 )

               else
                  ::SetText( "Error al insertar la propiedad " + AllTrim( ::oArtDiv:cValPr1 ) + " - " + AllTrim( ::oArtDiv:cValPr2 ) + " en la tabla " + ::cPrefixTable( "product_attribute" ), 3 )
               end if

               /*
               Metemos la relación de la propiedad1 con el artículo------------
               */

               nOrdAnt        := ::oTblPro:OrdSetFocus( "cCodPro" )

               if ::oTblPro:Seek( ::oArtDiv:cCodPr1 + ::oArtDiv:cValPr1 )

                  cCommand    := "INSERT INTO " +  ::cPrefixtable( "product_attribute_combination" ) + "( " + ;
                                    "id_attribute, " + ;
                                    "id_product_attribute )" + ;
                                 " VALUES " + ;
                                    "('" + AllTrim( Str( ::oTblPro:cCodWeb ) ) + "', " + ;  //id_attribute
                                    "'" + AllTrim( Str( nCodigoPropiedad ) ) + "' )"        //id_product_attribute

                  if TMSCommand():New( ::oCon ):ExecDirect( cCommand ) 

                     ::SetText( "He insertado la propiedad  " + AllTrim( ::oTblPro:cDesTbl ) + " correctamente en la tabla " + ::cPrefixTable( "product_attribute_combination" ), 3 )

                  else
                     ::SetText( "Error al insertar la propiedad " + AllTrim( ::oTblPro:cDesTbl ) + " en la tabla " + ::PrefixTable( "product_attribute_combination" ), 3 )
                  end if

               end if

               /*
               Metemos la relación de la propiedad 2 con el artículo-----------
               */

               if ::oTblPro:Seek( ::oArtDiv:cCodPr2 + ::oArtDiv:cValPr2 )

                  cCommand    := "INSERT INTO " + ::cPrefixTable( "product_attribute_combination" ) + " ( " + ;
                                    "id_attribute, " + ;
                                    "id_product_attribute )" + ;
                                 " VALUES " + ;
                                    "('" + AllTrim( Str( ::oTblPro:cCodWeb ) ) + "', " + ;   //id_attribute
                                    "'" + AllTrim( Str( nCodigoPropiedad ) ) + "' )"         //id_product_attribute

                  if TMSCommand():New( ::oCon ):ExecDirect( cCommand ) 

                     ::SetText( "He insertado la propiedad  " + AllTrim( ::oTblPro:cDesTbl ) + " correctamente en la tabla " + ::cPrefixTable( "product_attribute_combination" ), 3 )

                  else
                     ::SetText( "Error al insertar la propiedad " + AllTrim( ::oTblPro:cDesTbl ) + " en la tabla " + ::cPrefixTable( "product_attribute_combination" ), 3 )
                  end if

               end if

               ::oTblPro:OrdSetFocus( nOrdAnt )

               /*
               Metemos la relación entre la propiedad y el shop-------------
               */

               cCommand    :=    "INSERT INTO " + ::cPrefixTable( "product_attribute_shop" ) + " ( " + ;
                                    "id_product_attribute, " + ;
                                    "id_shop, " + ;
                                    "wholesale_price, " + ;
                                    "price, " + ;
                                    "ecotax, " + ;
                                    "weight, " + ;
                                    "unit_price_impact, " + ;
                                    "default_on, " + ;
                                    "minimal_quantity )" + ;
                                 " VALUES " + ;
                                    "('" + AllTrim( Str( nCodigoPropiedad ) ) + "', " + ;
                                    "'1', " + ;
                                    "'" + AllTrim( Str( if( nPrecio != 0, nPrecio, ::oArt:nImpInt1 ) ) ) + "', " + ;
                                    "'" + AllTrim( Str( if( nPrecio != 0, nPrecio, ::oArt:nImpInt1 ) ) ) + "', " + ;
                                    "'0', " + ;
                                    "'0', " + ;
                                    "'0', " + ;
                                    "'" + if( lDefault, "1", "0" ) + "', " + ;
                                    "'1' )"

               if TMSCommand():New( ::oCon ):ExecDirect( cCommand )

                  ::SetText( "He insertado la propiedad  " + AllTrim( ::oTblPro:cDesTbl ) + " correctamente en la tabla " + ::cPrefixTable( "product_attribute_shop" ), 3 )

               else

                  ::SetText( "Error al insertar la propiedad " + AllTrim( ::oTblPro:cDesTbl ) + " en la tabla " + ::cPrefixTable( "product_attribute_shop" ), 3 )

               end if

               /*
               Metemos el stock por cada propiedad--------------------------
               */

               nTotStock   := ::oStock:nStockAlmacen( ::oArt:Codigo, , ::oArtDiv:cValPr1, ::oArtDiv:cValPr2 )

               cCommand    :=    "INSERT INTO " + ::cPrefixTable( "stock_available" ) + " ( " + ;
                                    "id_product, " + ;
                                    "id_product_attribute, " + ;
                                    "id_shop, " + ;
                                    "id_shop_group, " + ;
                                    "quantity, " + ;
                                    "depends_on_stock, " + ;
                                    "out_of_stock )" + ;
                                 " VALUES " + ;
                                    "('" + AllTrim( Str( nCodigoWeb ) ) + "', " + ;
                                    "'" + AllTrim( Str( nCodigoPropiedad ) ) + "', " + ;   
                                    "'1', " + ;
                                    "'0', " + ;
                                    "'" + AllTrim( Str( nTotStock ) ) + "', " + ;
                                    "'0', " + ;
                                    "'2' )"

               if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
                  ::SetText( "He insertado la propiedad  " + AllTrim( ::oTblPro:cDesTbl ) + " correctamente en la tabla " + ::cPrefixTable( "stock_available" ), 3 )
               else
                  ::SetText( "Error al insertar la propiedad " + AllTrim( ::oTblPro:cDesTbl ) + " en la tabla " + ::cPrefixTable( "stock_available" ), 3 )
               end if

               /*
               ----------------------------------------------------------------
               Imágenes para dos propiedades-----------------------------------
               ----------------------------------------------------------------
               */

               if !Empty( ::oArtDiv:cImgWeb )

                  if ::oArtImg:SeekInOrd( ::oArt:Codigo, "cCodArt" )

                     while ::oArtImg:cCodArt == ::oArt:Codigo .and. !::oArtImg:Eof()

                        if AllTrim( ::oArtImg:cImgArt ) == AllTrim( ::oArtDiv:cImgWeb )

                           /*
                           Añadimos en la tabla product_attribute_image-----------
                           */

                           cCommand    := "INSERT INTO " + ::cPrefixTable( "product_attribute_image" ) + " ( " + ;
                                             "id_product_attribute, " + ;
                                             "id_image )" + ;
                                          " VALUES " + ;
                                             "('" + AllTrim( Str( nCodigoPropiedad ) ) + "', " + ;    //id_product
                                             "'" + AllTrim( Str( ::oArtImg:cCodWeb ) ) + "' )"        //cover
   
                           if TMSCommand():New( ::oCon ):ExecDirect( cCommand )

                              ::SetText( "He insertado el artículo " + AllTrim( ::oArt:Nombre ) + " correctamente en la tabla " + ::cPrefixTable( "product_attribute_image" ), 3 )

                           else

                              ::SetText( "Error al insertar el artículo " + AllTrim( ::oArt:Nombre ) + " en la tabla " + ::cPrefixTable( "product_attribute_image" ), 3 )

                           end if

                        end if   

                        ::oArtImg:Skip()

                     end while   

                  end if

               end if      

         end case

         ::oArtDiv:Skip()

         lDefault    := .f.

      end while

   end if

   ::oArtDiv:OrdSetFocus( nOrdArtDiv )

Return ( self )

//---------------------------------------------------------------------------//

METHOD EliminaPropiedadesProductsPrestashop( cCodWeb ) CLASS TComercio

   local oQuery
   local cCommand    := ""
   local idDelete

   /*
   Borramos las tablas auxiliares de lineas de propiedades---------------------
   */

   cCommand          := "SELECT * FROM " + ::cPrefixTable( "product_attribute" ) + ;
                        " WHERE id_product = " + Alltrim( Str( cCodWeb ) )

   oQuery            := TMSQuery():New( ::oCon, cCommand )

   if oQuery:Open() .and. oQuery:RecCount() > 0

      oQuery:GoTop()

      while !oQuery:Eof()

         idDelete    := oQuery:FieldGet( 1 ) //id_product_attributeb

         cCommand    := "DELETE FROM " + ::cPrefixTable( "product_attribute_combination" ) + " WHERE id_product_attribute=" + AllTrim( Str( idDelete ) )
         TMSCommand():New( ::oCon ):ExecDirect( cCommand )

         cCommand    := "DELETE FROM " + ::cPrefixTable( "product_attribute_shop" ) + " WHERE id_product_attribute=" + AllTrim( Str( idDelete ) )
         TMSCommand():New( ::oCon ):ExecDirect( cCommand )

         cCommand    := "DELETE FROM " + ::cPrefixTable( "stock_available" ) + " WHERE id_product_attribute=" + AllTrim( Str( idDelete ) )
         TMSCommand():New( ::oCon ):ExecDirect( cCommand )
         
         cCommand    := "DELETE FROM " + ::cPrefixTable( "product_attribute_image" ) + " WHERE id_product_attribute=" + AllTrim( Str( idDelete ) )
         TMSCommand():New( ::oCon ):ExecDirect( cCommand )
         
         oQuery:Skip()

      end while

   end if

   /*
   Borramos las líneas de propiedades de la tabla attribute--------------------
   */

   cCommand          := "DELETE FROM " + ::cPrefixTable( "product_attribute" ) + " WHERE id_product=" + AllTrim( Str( cCodWeb ) )
   TMSCommand():New( ::oCon ):ExecDirect( cCommand )

Return ( self )

//---------------------------------------------------------------------------//

METHOD AppendArticuloPrestashop( oDb ) CLASS TComercio

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

   cCommand          := "TRUNCATE TABLE " + ::cPrefixTable( "product_attribute_shop" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText ( 'Tabla ' + ::cPrefixTable( "product_attribute_shop" ) + ' borrada correctamente', 3  )
   else
      ::SetText ( 'Error al borrar la tabla ' + ::cPrefixTable( "product_attribute_shop" ), 3  )
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

   /*
   stockaje--------------------------------------------------------------------
   */

   cCommand          := "TRUNCATE TABLE " + ::cPrefixTable( "stock_available" )

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText ( 'Tabla ' + ::cPrefixTable( "stock_available" ) + ' borrada correctamente', 3  )
   else
      ::SetText ( 'Error al borrar la tabla ' + ::cPrefixTable( "stock_available" ), 3  )
   end if

   /*
   limpiamos refencias de imagenes a la web------------------------------------
   */

   ::lLimpiaRefImgWeb()

   /*
   Limpiamos las Id de las tablas del programa--------------------------------
   */

   //::DelIdTipoArticuloPrestashop()

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

                  ::cTextoWait( "Eliminando artículo en prestashop" )

                  ::DeleteProductsPrestashop()

                  ::cTextoWait( "Añadiendo artículo en prestashop" )

                  ::InsertProductsPrestashop( .t. )

/*
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
*/
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
   local nTotStock
   local nOrdArtDiv           := ::oArtDiv:OrdSetFocus( "cCodArt" )

   DEFAULT lExt               := .f.

   /*
   ----------------------------------------------------------------------------
   INSERTAMOS EL ARTÍCULO EN TODAS LAS TABLAS DE PRESTASHOP--------------------
   ----------------------------------------------------------------------------
   */

   ::cTextoWait( "Añadiendo artículo: " + AllTrim( ::oArt:Nombre ) )

   /*
   Vemos el preciodel artículo-------------------------------------------------
   */

   if ::oArtDiv:Seek( ::oArt:Codigo )
      nPrecio  := 0
   else
      nPrecio  := ::oArt:pVtaWeb
   end if

   ::oArtDiv:OrdSetFocus( nOrdArtDiv )

   cCommand    := "INSERT INTO " + ::cPrefixTable( "product" ) + ;
                     " ( id_manufacturer, " + ;
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
                     "date_upd )" + ;
                  " VALUES " + ;
                     "('" + AllTrim( Str( oRetFld( ::oArt:cCodFab, ::oFab, "cCodWeb", "cCodFab" ) ) ) + "', " + ; //id_manufacturer
                     "'" + AllTrim( Str( oRetFld( ::oArt:TipoIva, ::oIva, "CGRPWEB", "TIPO" ) ) ) + "', " + ;     //id_tax_rules_group  - tipo IVA
                     "'" + AllTrim( Str( nParent ) ) + "', " + ;                                                  //id_category_default
                     "'1', " + ;                                                                                  //id_shop_default
                     "'1', " + ;                                                                                  //quantity
                     "'1', " + ;                                                                                  //minimal_quantity
                     "'" + AllTrim( Str( nPrecio ) ) + "', " + ;                                                  //price
                     "'" + AllTrim( ::oArt:Codigo ) + "', " + ;                                                   //reference
                     "'" + AllTrim( Str( ::oArt:nPesoKg ) ) + "', " + ;                                           //weight
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
   Insertamos un artículo nuevo en la tabla category_product----------------
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
   Insertamos un artículo como producto destacado------------------------------
   */

   if ::oArt:lPubPor

      cCommand    := "INSERT INTO " + ::cPrefixTable( "category_product" ) + ;
                     " ( id_category, " + ;
                     "id_product )" + ;
                  " VALUES " + ;
                     "('2', " + ;
                     "'" + Str( nCodigoWeb ) + "' )"
   
      if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
         ::SetText( "He insertado el artículo " + AllTrim( ::oArt:Nombre ) + " como producto destacado", 3 )
      else
         ::SetText( "Error al insertar el artículo " + AllTrim( ::oArt:Nombre ) + " como producto destacado", 3 )
      end if

   end if

   /*
   Insertamos un artículo nuevo en la tabla category_shop-------------------
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
                     "'" + AllTrim( Str( nPrecio ) ) + "', " + ;
                     "'1', " + ;
                     "'" + dtos( GetSysDate() ) + "', " + ;
                     "'" + dtos( GetSysDate() ) + "' )"

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText( "He insertado el artículo " + AllTrim( ::oArt:Nombre ) + " correctamente en la tabla " + ::cPrefixTable( "product_shop" ), 3 )
   else
      ::SetText( "Error al insertar el artículo " + AllTrim( ::oArt:Nombre ) + " en la tabla " + ::cPrefixTable( "product_shop" ), 3 )
   end if

   /*
   Insertamos un artículo nuevo en la tabla product_lang--------------------
   */

   cCommand    := "INSERT INTO " + ::cPrefixTable( "product_lang" ) +;
                     " ( id_product, " + ;
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
                  " VALUES " + ;
                     "('" + Str( nCodigoWeb ) + "', " + ;                  // id_product
                     "'" + Str( ::nLanguage ) + "', " + ;                  // id_lang
                     "'" + if( !Empty( ::oArt:mDesTec ), ::oCon:EscapeStr( ::oArt:mDesTec ), ::oCon:EscapeStr( ::oArt:Nombre ) ) + "', " + ;        // description
                     "'" + AllTrim( ::oArt:Nombre ) + "', " + ;   // description_short
                     "'" + cLinkRewrite( ::oCon:EscapeStr( ::oArt:Nombre ) ) + "', " + ;       // link_rewrite
                     "'" + AllTrim( ::oArt:cTitSeo ) + "', " + ;   // Meta_título
                     "'" + AllTrim( ::oArt:cDesSeo ) + "', " + ;   // Meta_description
                     "'" + AllTrim( ::oArt:cKeySeo ) + "', " + ;   // Meta_keywords
                     "'" + ::oCon:EscapeStr( ::oArt:Nombre ) + "', " + ;      // name
                     "'En stock', " + ;                                       // avatible_now
                     "'' )"

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::SetText( "He insertado el artículo " + AllTrim( ::oArt:Nombre ) + " correctamente en la tabla " + ::cPrefixTable( "product_lang" ), 3 )
   else
      ::SetText( "Error al insertar el artículo " + AllTrim( ::oArt:Nombre ) + " en la tabla " + ::cPrefixTable( "product_lang" ), 3 )
   end if

   /*
   Metemos el stock total del artículo-----------------------------------------
   */

   nTotStock   := ::oStock:nStockArticulo( ::oArt:Codigo )

   cCommand    :=    "INSERT INTO " + ::cPrefixTable( "stock_available" ) + " ( " + ;
                        "id_product, " + ;
                        "id_product_attribute, " + ;
                        "id_shop, " + ;
                        "id_shop_group, " + ;
                        "quantity, " + ;
                        "depends_on_stock, " + ;
                        "out_of_stock )" + ;
                     " VALUES " + ;
                        "('" + AllTrim( Str( nCodigoWeb ) ) + "', " + ;
                        "'0', " + ;   
                        "'1', " + ;
                        "'0', " + ;
                        "'" + AllTrim( Str( nTotStock ) ) + "', " + ;
                        "'0', " + ;
                        "'2' )"

      if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
         ::SetText( "He insertado el artículo  " + AllTrim( ::oArt:Nombre ) + " correctamente en la tabla " + ::cPrefixTable( "stock_available" ), 3 )
      else
         ::SetText( "Error al insertar el artículo " + AllTrim( ::oArt:Nombre ) + " en la tabla " + ::cPrefixTable( "stock_available" ), 3 )
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
   Insertamos las propiedades del producto-------------------------------------
   ----------------------------------------------------------------------------
   */

   ::cTextoWait( "Añadiendo propiedades del artículo: " + AllTrim( ::oArt:Nombre ) )

   ::InsertPropiedadesProductPrestashop( nCodigoWeb )

   /*
   ----------------------------------------------------------------------------
   Insertamos las ofertas del producto-----------------------------------------
   ----------------------------------------------------------------------------
   */

   ::cTextoWait( "Añadiendo ofertas del artículo: " + AllTrim( ::oArt:Nombre ) )

   ::InsertOfertasPrestashop( nCodigoWeb )

   /*
   ----------------------------------------------------------------------------
   Subimos las imágenes si no es una global------------------------------------
   ----------------------------------------------------------------------------
   */

   if lExt
      ::cTextoWait( "Añadiendo imágenes del artículo: " + AllTrim( ::oArt:Nombre ) )
      ::AppendImagesPrestashop()
   end if   

return nCodigoweb

//---------------------------------------------------------------------------//

METHOD UpdateProductsPrestashop( lChangeImage ) CLASS TComercio

   local cCommand    := ""
   local lReturn     := .f.
   local nParent     := ::GetParentCategories()
   local nTotStock   := 0

   ::DeleteProductsPrestashop()

   ::InsertProductsPrestashop( .t. )

   /*
   ----------------------------------------------------------------------------
   ACTUALIZAMOS LAS TABLAS DE ARTÍCULO-----------------------------------------
   ----------------------------------------------------------------------------
   */

   /*::cTextoWait( "Modificando artículo: " + AllTrim( ::oArt:Nombre ) )

   cCommand          := "UPDATE " + ::cPrefixTable( "product" ) + " SET " + ;
                           "id_manufacturer='" + AllTrim( Str( oRetFld( ::oArt:cCodFab, ::oFab, "CCODWEB", "CCODFAB" ) ) ) + "', " + ;
                           "id_tax_rules_group='" + AllTrim( Str( oRetFld( ::oArt:TipoIva, ::oIva, "CGRPWEB", "TIPO" ) ) ) + "', " + ;
                           "id_category_default='" + AllTrim( Str( nParent ) ) + "', " + ;
                           "price='" + if( !Empty( ::oArt:cCodPrp1 ), "0", AllTrim( Str( ::oArt:nImpInt1 ) ) ) + "', " + ;
                           "weight='" + AllTrim( Str( ::oArt:nPesoKg ) ) + "', " + ;
                           "date_upd='" + AllTrim( dtoc( GetSysDate() ) ) + "' " + ;
                        "WHERE id_product=" + AllTrim( Str( ::oArt:cCodWeb ) )

   lReturn           := TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   cCommand          := "UPDATE " + ::cPrefixTable( "product_lang" ) + " SET " + ;
                           "description='" + if( !Empty( ::oArt:mDesTec ), AllTrim( ::oArt:mDesTec ), AllTrim( ::oArt:Nombre ) ) + "', " + ;
                           "description_short='" + AllTrim( ::oArt:Nombre ) + "', " + ;
                           "link_rewrite='" + cLinkRewrite( ::oCon:EscapeStr( ::oArt:Nombre ) ) + "', " + ;
                           "meta_title='" + AllTrim( ::oArt:cTitSeo ) + "', " + ;
                           "meta_description='" + AllTrim( ::oArt:cDesSeo ) + "', " + ;
                           "meta_keywords='" + AllTrim( ::oArt:cKeySeo ) + "', " + ;
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

   lReturn           := TMSCommand():New( ::oCon ):ExecDirect( cCommand )*/

   /*
   ----------------------------------------------------------------------------
   Actualizamos el stock total del producto------------------------------------
   ----------------------------------------------------------------------------
   */

   /*nTotStock   := ::oStock:nStockArticulo( ::oArt:Codigo )

   cCommand          := "UPDATE " + ::cPrefixTable( "stock_available" ) + " SET " + ;
                           "quantity='" + AllTrim( Str( nTotStock ) ) + "' " + ;
                        "WHERE id_product=" + AllTrim( Str( ::oArt:cCodWeb ) ) + " AND id_product_attribute=0 "

   lReturn           := TMSCommand():New( ::oCon ):ExecDirect( cCommand )*/

   /*
   ----------------------------------------------------------------------------
   ACTUALIZAMOS PRECIOS POR PROPIEDADES DEL ARTICULO---------------------------
   ----------------------------------------------------------------------------
   */

   //::ActualizaPropiedadesProducts( ::oArt:cCodWeb )

   /*
   ----------------------------------------------------------------------------
   ACTUALIZAMOS LAS OFERTAS DEL ARTÍCULO---------------------------------------
   ----------------------------------------------------------------------------
   */

   //::UpdateOfertasPrestashop()

   /*
   ----------------------------------------------------------------------------
   ACTUALIZAMOS IMAGENES DEL ARTÍCULO------------------------------------------
   ----------------------------------------------------------------------------
   */ 

   /*SysRefresh()

   if lChangeImage

      ::DeleteImagesProducts( ::oArt:cCodWeb )

      SysRefresh()

      ::InsertImageProductsPrestashop()

      SysRefresh()

      ::AppendImagesPrestashop()

   end if*/

Return ( self )

//---------------------------------------------------------------------------//

METHOD DeleteProductsPrestashop() CLASS TComercio

   local idDelete    := 0
   local idDelete2   := 0
   local cCommand    := ""
   local oQuery
   local oQuery2
   local cCodWeb 

   cCodWeb           := AllTrim( Str( ::oArt:cCodWeb ) )

   ::cTextoWait( "Eliminando artículo de Prestashop" )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "product" ) + " WHERE id_product=" + cCodWeb
   TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   ::cTextoWait( "Eliminando adjuntos de Prestashop"  )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "product_attachment" ) + " WHERE id_product=" + cCodWeb
   TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   ::cTextoWait( "Eliminando impuestos de Prestashop"  )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "product_country_tax" ) + " WHERE id_product=" + cCodWeb
   TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   ::cTextoWait( "Eliminando archivos de Prestashop"  )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "product_download" ) + " WHERE id_product=" + cCodWeb
   TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   ::cTextoWait( "Eliminando cache de Prestashop"  )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "product_group_reduction_cache" ) + " WHERE id_product=" + cCodWeb
   TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   ::cTextoWait( "Eliminando multitienda de Prestashop"  )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "product_shop" ) + " WHERE id_product=" + cCodWeb
   TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   ::cTextoWait( "Eliminando descripciones de Prestashop"  )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "product_lang" ) + " WHERE id_product=" + cCodWeb
   TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   ::cTextoWait( "Eliminando ofertas de Prestashop"  )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "product_sale" ) + " WHERE id_product=" + cCodWeb
   TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   ::cTextoWait( "Eliminando etiquetas de Prestashop"  )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "product_tag" ) + " WHERE id_product=" + cCodWeb
   TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   ::cTextoWait( "Eliminando complementos de Prestashop"  )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "product_supplier" ) + " WHERE id_product=" + cCodWeb
   TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   ::cTextoWait( "Eliminando transporte de Prestashop"  )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "product_carrier" ) + " WHERE id_product=" + cCodWeb
   TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   ::cTextoWait( "Eliminando atributos de Prestashop"  )

   cCommand          := 'SELECT * FROM ' + ::cPrefixTable( "product_attribute" ) +  ' WHERE id_product=' + cCodWeb
   oQuery            := TMSQuery():New( ::oCon, cCommand )
   
   ::cTextoWait( "Eliminando lineas atributos de Prestashop"  )

   if oQuery:Open()
   
      if oQuery:RecCount() > 0

         oQuery:GoTop()

         while !oQuery:Eof()

            idDelete    := oQuery:FieldGet( 1 )

            if !Empty( idDelete )

               cCommand          := "DELETE FROM " + ::cPrefixTable( "product_attribute" ) + " WHERE id_product_attribute=" + AllTrim( Str( idDelete ) )
               TMSCommand():New( ::oCon ):ExecDirect( cCommand )

               cCommand          := "DELETE FROM " + ::cPrefixTable( "product_attribute_combination" ) + " WHERE id_product_attribute=" + AllTrim( Str( idDelete ) )
               TMSCommand():New( ::oCon ):ExecDirect( cCommand )

               cCommand          := "DELETE FROM " + ::cPrefixTable( "product_attribute_image" ) + " WHERE id_product_attribute=" + AllTrim( Str( idDelete ) )
               TMSCommand():New( ::oCon ):ExecDirect( cCommand )

               cCommand          := "DELETE FROM " + ::cPrefixTable( "product_attribute_shop" ) + " WHERE id_product_attribute=" + AllTrim( Str( idDelete ) )
               TMSCommand():New( ::oCon ):ExecDirect( cCommand )

            end if

            oQuery:Skip()

            SysRefresh()

         end while
   
      end if

   end if

   ::cTextoWait( "Eliminando precios especificos de Prestashop"  )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "specific_price" ) + " WHERE id_product=" + cCodWeb
   TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   ::cTextoWait( "Eliminando prioridad de precio de Prestashop"  )

   cCommand          := "DELETE FROM " + ::cPrefixTable( "specific_price_priority" ) + " WHERE id_product=" + cCodWeb
   TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   ::cTextoWait( "Eliminando funciones de Prestashop"  )

   cCommand          := 'SELECT * FROM ' + ::cPrefixTable( "feature_product" ) +  ' WHERE id_product=' + cCodWeb
   oQuery            := TMSQuery():New( ::oCon, cCommand )
   
   ::cTextoWait( "Eliminando lineas funciones de Prestashop"  )

   if oQuery:Open()
   
      if oQuery:RecCount() > 0

         oQuery:GoTop()

         while !oQuery:Eof()

            idDelete    := oQuery:FieldGet( 1 )

            if !Empty( idDelete )

               cCommand          := "DELETE FROM " + ::cPrefixTable( "feature_product" ) + " WHERE id_product=" + cCodWeb
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

                     oQuery2:GoTop()

                     while !oQuery2:Eof()

                     idDelete2    := oQuery:FieldGet( 1 )

                        if !Empty( idDelete2 )

                           cCommand          := "DELETE FROM " + ::cPrefixTable( "feature_value" ) + " WHERE id_feature_value=" + AllTrim( Str( idDelete2 ) )
                           TMSCommand():New( ::oCon ):ExecDirect( cCommand )

                           cCommand          := "DELETE FROM " + ::cPrefixTable( "feature_value_lang" ) + " WHERE id_feature_value=" + AllTrim( Str( idDelete2 ) )
                           TMSCommand():New( ::oCon ):ExecDirect( cCommand )

                        end if

                        oQuery2:Skip()

                        SysRefresh()

                     end while      

                  end if

               end if

            end if

            oQuery:Skip()

            SysRefresh()

         end while      
   
      end if

   end if

   SysRefresh()

   /*
   Eliminamos las imágenes del artículo---------------------------------------
   */

   ::cTextoWait( "Eliminando imágenes de prestashop" )

   ::DeleteImagesProducts( cCodWeb )

   SysRefresh()

   /*
   Quitamos la referencia de nuestra tabla-------------------------------------
   */

   ::oArt:fieldPutByName( "cCodWeb", 0 )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD DeleteImagesProducts( cCodWeb ) CLASS TComercio 

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

   if !Empty( cCodWeb )
      
      /*
      Limpiamos la refecencia en la base de datos------------------------------
      */

      cCommand          := 'SELECT * FROM ' + ::cPrefixTable( "image" ) +  ' WHERE id_product=' + cCodWeb
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

      if !Empty( ::cHostFtp )

         if !Empty( ::cDImagen )
            
            for each idDelete in aDelImages

               oInt           := TInternet():New()
               oFtp           := TFtp():New( ::cHostFtp, oInt, ::cUserFtp, ::cPasswdFtp, ::lPassiveFtp )

               if Empty( oFtp ) .or. Empty( oFtp:hFtp )

                  MsgStop( "Imposible conectar al sitio ftp " + ::cHostFtp )

               else

                  cCarpeta    := ::CreateDirectoryImagesLocal( idDelete )

                  oFtp:SetCurrentDirectory( ::cDImagen + "/p" + cCarpeta )
                  oFtp:DeleteMask()

                  oFtp:SetCurrentDirectory( ".." )

               end if 
                  
               if !Empty( oInt )
                  oInt:end()
               end if

               if !Empty( oFtp )
                  oFtp:end()
               end if  

            next

         end if

      else

         if isDirectory( ::cDImagen )
            
            for each idDelete in aDelImages

               cCarpeta       := ::CreateDirectoryImagesLocal( idDelete )

               DeleteFilesToDirectory( ::cDImagen + "/p" + cCarpeta )

            next

         end if
      
      end if   

   end if

   SysRefresh()

Return nil

//---------------------------------------------------------------------------//

Method InsertOfertasPrestashop( nCodigoWeb ) CLASS TComercio

   local cCommand          := ""

   if ::oArt:lSbrInt .and. ::oArt:nDtoInt1 != 0

      cCommand          := "INSERT INTO " + ::cPrefixTable( "specific_price" ) + ; 
                           " ( id_specific_price_rule, " + ;
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
                              "reduction_type )" + ;
                           " VALUES " + ;
                              "('0', " + ;                                             //id_specific_price_rule
                              "'0', " + ;                                              //id_cart
                              "'" + AllTrim( Str( nCodigoWeb ) ) + "', " + ;           //id_product
                              "'1', " + ;                                              //id_shop
                              "'0', " + ;                                              //id_shop_group
                              "'0', " + ;                                              //id_currency
                              "'0', " + ;                                              //id_country
                              "'0', " + ;                                              //id_group
                              "'0', " + ;                                              //id_customer
                              "'0', " + ;                                              //id_product_attribute
                              "'-1', " + ;                                             //price
                              "'1', " + ;                                              //from_quantity
                              "'" + AllTrim( Str( ::oArt:nDtoInt1 / 100 ) ) + "', " + ;//reduction
                              "'percentage' )"                                         //reduction_type
   
      if TMSCommand():New( ::oCon ):ExecDirect( cCommand )

         ::SetText( "He insertado la propiedad " + AllTrim( ::oTblPro:cDesTbl ) + " correctamente en la tabla " + ::cPrefixTable( "attribute" ), 3 )

      else

         ::SetText( "Error al insertar la propiedad " + AllTrim( ::oTblPro:cDesTbl ) + " en la tabla " + ::cPreFixtable( "attribute" ), 3 )

      end if

   end if

return nil

//---------------------------------------------------------------------------//

Method UpdateOfertasPrestashop() CLASS TComercio

   local cCommand          := ""

   if ::oArt:lSbrInt .and. ::oArt:nDtoInt1 != 0

      cCommand          := "UPDATE " + ::cPrefixTable( "specific_price" ) + " SET " + ;
                              "reduction='" + AllTrim( Str( ::oArt:nDtoInt1 / 100 ) ) + "' " + ;
                           "WHERE id_product=" + AllTrim( Str( ::oArt:cCodWeb ) )

      TMSCommand():New( ::oCon ):ExecDirect( cCommand )

   end if   
            
return nil

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
                        "'" + ::oCon:EscapeStr( ::oArtImg:cNbrArt ) + "' )"

         if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
            ::SetText( "He insertado el artículo " + AllTrim( ::oArt:Nombre ) + " correctamente en la tabla " + ::cPrefixTable( "image_lang" ), 3 )
         else
            ::SetText( "Error al insertar el artículo " + AllTrim( ::oArt:Nombre ) + " en la tabla " + ::cPrefixTable( "image_lang" ), 3 )
         end if

         cCommand := "INSERT INTO " + ::cPrefixTable( "image_shop" ) + ;
                        "( id_image, " + ;
                           "id_shop, " + ;
                           "cover ) "  + ;
                     "VALUES " + ;
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

METHOD nIvaProduct( cCodArt ) Class TComercio

   local nIva        := 0
   local oQuery
   local cCommand    := ""
   
   cCommand    := 'SELECT * FROM ' + ::cPrefixTable( "tax" ) + ;
                  ' INNER JOIN ' + ::cPreFixTable( "tax_rule" ) + ' ON ' + ::cPrefixTable( "tax" ) + '.id_tax = ' + ::cPrefixTable( "tax_rule" ) + '.id_tax ' +; 
                  ' INNER JOIN ' + ::cPrefixTable( "product" ) + ' ON ' + ::cPrefixTable( "tax_rule" ) + '.id_tax_rules_group = ' + ::cPrefixTable( "product" ) + '.id_tax_rules_group ' + ;
                  ' WHERE ' + ::cPrefixTable( "product" ) + '.id_product = ' + AllTrim( Str( cCodArt ) )

   oQuery     := TMSQuery():New( ::oCon, cCommand )

   if oQuery:Open() .and. oQuery:RecCount() > 0

      oQuery:GoTop()

      nIva     := oQuery:FieldGetByName( "rate" )

   end if

Return ( nIva )

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
   local cCarpeta          := ""

   ::aImagesCategories     := {}
   ::aImagesArticulos      := {}

   CursorWait()

   /*
   Recogemos los tipos de imagenes---------------------------------------------
   */

   ::aTipoImagenPrestashop()

   ::SetText( "Creando y redimensionando imágenes", 2 )

   /*
   Cargamos creamos las imagenes a subir---------------------------------------
   */

   for each oImage in ::aImages

      /*
      Metemos primero la imagen que no lleva tipo------------------------------
      */

      do case

         case oImage:nTipoImagen == tipoProducto

            cNewImg                       := cPatTmp() + oImage:cPrefijoNombre + ".jpg"

            SaveImage( oImage:cNombreImagen, cNewImg )

            oImagenFinal                  := SImagen()
            oImagenFinal:cNombreImagen    := cNewImg
            oImagenFinal:nTipoImagen      := oImage:nTipoImagen
            oImagenFinal:cCarpeta         := oImage:cCarpeta

            ::AddImagesArticulos( oImagenFinal )

            ::SetText( "Elaborando " + cNoPath( oImage:cNombreImagen ), 3 )

         case oImage:nTipoImagen == tipoCategoria

            cNewImg                       := cPatTmp() + oImage:cPrefijoNombre + ".jpg"

            SaveImage( oImage:cNombreImagen, cNewImg )

            oImagenFinal                  := SImagen()
            oImagenFinal:cNombreImagen    := cNewImg
            oImagenFinal:nTipoImagen      := oImage:nTipoImagen

            ::AddImagesCategories( oImagenFinal )

            ::SetText( "Elaborando " + cNoPath( oImage:cNombreImagen ), 3 )

      end case

      /*
      Metemos las imagenes por tipo--------------------------------------------
      */

      for each oTipoImage in ::aTipoImagesPrestashop

         do case

            case oImage:nTipoImagen == tipoProducto .and. oTipoImage:lProducts

               cNewImg                       := cPatTmp() + oImage:cPrefijoNombre + "-" + oTipoImage:cNombreTipo + ".jpg"

               SaveImage( oImage:cNombreImagen, cNewImg, oTipoImage:nAnchoTipo, oTipoImage:nAltoTipo )

               oImagenFinal                  := SImagen()
               oImagenFinal:cNombreImagen    := cNewImg
               oImagenFinal:nTipoImagen      := oImage:nTipoImagen
               oImagenFinal:cCarpeta         := oImage:cCarpeta

               ::AddImagesArticulos( oImagenFinal )

               ::SetText( "Elaborando " + cNoPath( oImagenFinal:cNombreImagen ), 3 )

            case oImage:nTipoImagen == tipoCategoria .and. oTipoImage:lCategories

               cNewImg                       := cPatTmp() + oImage:cPrefijoNombre + "-" + oTipoImage:cNombreTipo + ".jpg"

               SaveImage( oImage:cNombreImagen, cNewImg, oTipoImage:nAnchoTipo, oTipoImage:nAltoTipo )

               oImagenFinal                  := SImagen()
               oImagenFinal:cNombreImagen    := cNewImg
               oImagenFinal:nTipoImagen      := oImage:nTipoImagen

               ::AddImagesCategories( oImagenFinal )

               ::SetText( "Elaborando " + cNoPath( oImagenFinal:cNombreImagen ), 3 )

         end case

         SysRefresh()

      next

   next

   /*
   Conectamos al FTP y Subimos las imágenes de artículos-----------------------
   */

   if Len( ::aImagesArticulos ) > 0

      ::nTotMeter    := 0

      if !Empty( ::cHostFtp )

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

               /*
               Posicionamos en el directorio-----------------------------------
               */

               ::CreateDirectoryImages( oImage:cCarpeta )

               /*
               Sube el fichero ------------------------------------------------
               */
             
               oFile                   := TFtpFile():New( cFileBmpName( oImage:cNombreImagen ), ::oFtp )
               if !oFile:PutFile( ::oMeterL )
                  ::SetText( "Error copiando imagen " + cFileBmpName( oImage:cNombreImagen ), 3 )
               end if
               oFile:End()

               /*
               Volvemos al directorio raiz-------------------------------------
               */

               ::ReturnDirectoryImages( oImage:cCarpeta )

               /*
               if !Empty( ::cDImagen )
                  ::oFtp:SetCurrentDirectory( ::cDImagen + "/p" )
               end if

               Siguiente-------------------------------------------------------
               */

               nCount++

               SysRefresh()

            next

         end if

         if !Empty( ::oInt )
            ::oInt:end()
         end if

         if !Empty( ::oFtp )
            ::oFtp:end()
         end if

      else  

         if isDirectory( ::cDImagen )
            
            if !isDirectory( ::cDImagen + "/p" )
              
               Makedir( ::cDImagen + "/p" )

            end if

            for each oImage in ::aImagesArticulos

               ::SetText( "Subiendo imagen " + cNoPath( oImage:cNombreImagen ), 3 )

               ::MeterParticularText( " Subiendo imagen " + AllTrim( Str( nCount ) ) + " de "  + AllTrim( Str( ::nTotMeter ) ) )

               cCarpeta       :=    ::CreateDirectoryImagesLocal( oImage:cCarpeta )

               CopyFile( oImage:cNombreImagen, ::cDImagen + "/p" + cCarpeta + "/" + cNoPath( oImage:cNombreImagen ) )

               nCount         += 1

            next

         end if

      end if   

   end if

   /*
   Subimos las imagenes de las categories--------------------------------------
   */

   if Len( ::aImagesCategories ) > 0

      if !Empty( ::cHostFtp )

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

      else 
      
         if isDirectory( ::cDImagen )

            if !isDirectory( ::cDImagen + "/c" )
               
               Makedir( ::cDImagen + "/c" )

            end if

            for each oImage in ::aImagesCategories

               ::SetText( "Subiendo imagen " + cNoPath( oImage:cNombreImagen ), 3 )

               ::MeterParticularText( " Subiendo imagen " + AllTrim( Str( nCount ) ) + " de "  + AllTrim( Str( ::nTotMeter ) ) )

               CopyFile( oImage:cNombreImagen, ::cDImagen + "/c/" + cNoPath( oImage:cNombreImagen ) )

               nCount                  += 1

            next      

         end if

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

   ::aImages               := {}

   CursorWe()

Return( nil )

//---------------------------------------------------------------------------//

METHOD aTipoImagenPrestashop() CLASS TComercio

   local oImagen
   local oQuery            := TMSQuery():New( ::oCon, 'SELECT * FROM ' + ::cPrefixTable( "image_type" ) )

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

METHOD cPreFixtable( cName ) Class TComercio

Return ( ::cPrefijoBaseDatos + AllTrim( cName ) )

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

Method GetLanguagePrestashop( oDb ) CLASS TComercio

   local oQuery
   local cCodLanguage

   oQuery               := TMSQuery():New( ::oCon, 'SELECT * FROM ' + ::cPrefixTable( "lang" ) +  ' WHERE active = 1' )

   if oQuery:Open()

      if oQuery:RecCount() > 0
         cCodLanguage   := oQuery:FieldGet( 1 )
      end if

   end if

   if !Empty( oQuery )
      oQuery:Free()
   end if   

Return if( !Empty( cCodLanguage ), cCodLanguage, 1 )

//---------------------------------------------------------------------------//

METHOD GetValPrp( nIdPrp, nProductAttibuteId ) CLASS TComercio

   local oQuery1
   local oQuery2
   local nIdAttribute
   local nIdAttributeGroup
   local cValPrp                 := ""

   oQuery1                       := TMSQuery():New( ::oCon, 'SELECT * FROM ' + ::cPrefixTable( "product_attribute_combination" ) + ' where id_product_attribute=' + AllTrim( Str( nProductAttibuteId ) ) )

   if oQuery1:Open()

      /*
      Recorremos el Query con la consulta-----------------------------------------
      */

      if oQuery1:RecCount() > 0

         oQuery1:GoTop()

         while !oQuery1:Eof()

         nIdAttribute            := oQuery1:FieldGet( 1 )

         oQuery2                 := TMSQuery():New( ::oCon, 'SELECT * FROM ' + ::cPrefixTable( "attribute" ) + ' where id_attribute=' + AllTrim( Str( nIdAttribute ) ) )

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

METHOD AppTipoArticuloPrestashop( cCodTip, IdParent ) CLASS TComercio

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

         if TMSCommand():New( ::oCon ):ExecDirect( ;
            "INSERT INTO " + ::cPrefixTable( "category" ) + ;
               " ( id_parent, level_depth, nleft, nright, active, date_add, date_upd, position ) " + ;
            "VALUES " + ;
               " ( '" + Str( IdParent ) + "', '2', '0', '0', '1', '" + dtos( GetSysDate() ) + "', '" + dtos( GetSysDate() ) + "', '0' ) " )

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

            ::SetText( "He insertado el tipo de artículo " + AllTrim( ::oTipArt:cNomTip ) + " correctamente en la tabla category", 3 )

         else
            ::SetText( "Error al insertar el tipo de artículo " + AllTrim( ::oTipArt:cNomTip ) + " en la tabla category", 3 )
         end if

         if TMSCommand():New( ::oCon ):ExecDirect( ;
            "INSERT INTO " + ::cPrefixTable( "category_lang" ) +;
               " ( id_category, id_lang, name, description, link_rewrite, meta_title, meta_keywords, meta_description ) " + ;
            "VALUES"+ ;
               " ( '" + Str( nCodigoWeb ) + "', '" + Str( ::nLanguage ) + "', '" + ::oCon:EscapeStr( ::oTipArt:cNomTip ) + "', '" + ::oCon:EscapeStr( ::oTipArt:cNomTip ) + "', '" + cLinkRewrite( ::oTipArt:cNomTip ) + "', '', '', '' )" )

            ::SetText( "He insertado el tipo de artículo " + AllTrim( ::oTipArt:cNomTip ) + " correctamente en la tabla category_lang", 3 )
         else
            ::SetText( "Error al insertar el tipo de artículo " + AllTrim( ::oTipArt:cNomTip ) + " en la tabla category_lang", 3 )
         end if

         if TMSCommand():New( ::oCon ):ExecDirect( "INSERT INTO " + ::cPrefixTable( "category_shop" ) + " ( id_category, id_shop, position ) VALUES ( '" + Str( nCodigoWeb ) + "', '1', '0' )" )
            ::SetText( "He insertado correctamente en la tabla category_group la categoría raiz", 3 )
         else
            ::SetText( "Error al insertar la categoría inicio en category_group", 3 )
         end if

         if TMSCommand():New( ::oCon ):ExecDirect( "INSERT INTO " + ::cPrefixTable( "category_group" ) + " ( id_category, id_group ) VALUES ( '" + Str( nCodigoWeb ) + "', '1' )" )
            ::SetText( "He insertado el tipo de artículo " + AllTrim( ::oTipArt:cNomTip ) + " correctamente en la tabla category_group", 3 )
         else
            ::SetText( "Error al insertar " + AllTrim( ::oTipArt:cNomTip ) + " en la tabla category_group", 3 )
         end if

         if TMSCommand():New( ::oCon ):ExecDirect( "INSERT INTO " + ::cPrefixTable( "category_group" ) + " ( id_category, id_group ) VALUES ( '" + Str( nCodigoWeb ) + "', '2' )" )
            ::SetText( "He insertado el tipo de artículo " + AllTrim( ::oTipArt:cNomTip ) + " correctamente en la tabla category_group", 3 )
         else
            ::SetText( "Error al insertar el tipo de artículo " + AllTrim( ::oTipArt:cNomTip ) + " en la tabla category_group", 3 )
         end if

         if TMSCommand():New( ::oCon ):ExecDirect( "INSERT INTO " + ::cPrefixTable( "category_group" ) + " ( id_category, id_group ) VALUES ( '" + Str( nCodigoWeb ) + "', '3' )" )
            ::SetText( "He insertado el tipo de artículo " + AllTrim( ::oTipArt:cNomTip ) + " correctamente en la tabla category_group", 3 )
         else
            ::SetText( "Error al insertar el tipo de artículo " + AllTrim( ::oTipArt:cNomTip ) + " en la tabla category_group", 3 )
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

METHOD AppendClientesToPrestashop() CLASS TComercio

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
                                                                                    "'" + ::oCon:EscapeStr( ::oCli:cMeiInt ) + "', " + ;                 //"email, " + ;
                                                                                    "'" + hb_md5( AllTrim( ::Cookiekey ) + AllTrim( ::oCli:cClave ) ) + "', " + ;   //"passwd, " + ;
                                                                                    "'1', " + ;                                                          //"newletter, " + ;
                                                                                    "'" + hb_md5( AllTrim( ::oCli:Cod ) ) + "', " + ;                    //"secure_key, " + ;
                                                                                    "'1', " + ;                                                          //"active, " + ;
                                                                                    "'0', " + ;                                                          //"is_guest, " + ;
                                                                                    "'0', " + ;                                                          //"deleted, " + ;
                                                                                    "'" + dtos( GetSysDate() ) + "', " + ;                               //"date_add )" + ;
                                                                                    "'" + dtos( GetSysDate() ) + "' )" )                                 //"date_upd )" + ;

                  nCodigoWeb           := ::oCon:GetInsertId()

                  ::oCli:fieldPutByName( "cCodWeb", nCodigoWeb )

                  ::SetText( "He insertado el cliente " + AllTrim( ::oCli:Titulo ) + " correctamente en la tabla customer", 3 )

               else
                  ::SetText( "Error al insertar el cliente " + AllTrim( ::oCli:Titulo ) + " en la tabla customer", 3 )
               end if

               /*
               Insertamos en la tabla customer_group------------------------
               */

               if TMSCommand():New( ::oCon ):ExecDirect( "INSERT INTO " + ::cPrefixTable( "customer_group" ) + " ( id_customer, " + ;
                                                                                          "id_group )" + ;
                                                                                 " VALUES " + ;
                                                                                           "('" + AllTrim( Str( nCodigoWeb ) ) + "', " + ;
                                                                                           "'1' )" )


                  ::SetText( "He insertado el cliente " + AllTrim( ::oCli:Titulo ) + " correctamente en la tabla customer_group", 3 )

               else
                  ::SetText( "Error al insertar el cliente " + AllTrim( ::oCli:Titulo ) + " en la tabla customer_group", 3 )
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
                                                                                  "'" + AllTrim( Str( nCodigoWeb ) ) + "', " + ;                 //id_customer
                                                                                  "'" + cFirstName + cLastName  + "', " + ; //alias
                                                                                  "'" + AllTrim( cLastName ) + "', " + ;                         //lastname
                                                                                  "'" + AllTrim( cFirstName ) + "', " + ;                        //firstname
                                                                                  "'" + ::oCon:EscapeStr( ::oCli:Domicilio ) + "', " + ;                  //address1
                                                                                  "'" + ::oCon:EscapeStr( ::oCli:CodPostal ) + "', " + ;                  //postcode
                                                                                  "'" + ::oCon:EscapeStr( ::oCli:Poblacion ) + "', " + ;                  //city
                                                                                  "'" + ::oCon:EscapeStr( ::oCli:Telefono ) + "', " + ;                   //phone
                                                                                  "'" + ::oCon:EscapeStr( ::oCli:Movil ) + "', " + ;                      //phone_mobile
                                                                                  "'" + ::oCon:EscapeStr( ::oCli:Nif ) + "', " + ;                        //dni
                                                                                  "'" + dtos( GetSysDate() ) + "', " + ;                         //date_add
                                                                                  "'" + dtos( GetSysDate() ) + "', " + ;                         //date_upd
                                                                                  "'1', " + ;                                                    //active
                                                                                  "'0' )" )                                                      //deleted


                  ::SetText( "He insertado el cliente " + AllTrim( ::oCli:Titulo ) + " correctamente en la tabla address", 3 )

               else
                  ::SetText( "Error al insertar el cliente " + AllTrim( ::oCli:Titulo ) + " en la tabla address", 3 )
               end if

            else

               nSpace               := At( " ", ::oCli:Titulo )
               cFirstName           := ::oCon:EscapeStr( SubStr( ::oCli:Titulo, 1, nSpace ) )
               cLastName            := ::oCon:EscapeStr( SubStr( ::oCli:Titulo, nSpace + 1 ) )

               if !::oCli:lWeb

                  /*
                  Actualizamos la tabla de clientes----------------------------
                  */

                  if TMSCommand():New( ::oCon ):ExecDirect( "UPDATE " + ::cPrefixTable( "customer" ) + " SET firstname='" + AllTrim( cFirstName ) + ;
                                                                                "', lastname='" + AllTrim( cLastName ) + ;
                                                                                "', email='" + AllTrim( ::oCli:cMeiInt ) + ;
                                                                                "', passwd='" + hb_md5( AllTrim( ::Cookiekey ) + AllTrim( ::oCli:cClave ) ) + ;
                                                                                "', secure_key='" + hb_md5( AllTrim( ::oCli:Cod ) ) + ;
                                                                                "', date_upd='" + dtos( GetSysDate() ) + ;
                                                                                "' WHERE id_customer=" + AllTrim( Str( ::oCli:cCodWeb ) ) )

                     ::SetText( "Actualizado correctamente el cliente " + AllTrim( ::oCli:Titulo ) + " en la tabla customer", 3 )
                  else
                     ::SetText( "Error al actualizar el cliente " + AllTrim( ::oCli:Titulo ) + " en la tabla customer", 3 )
                  end if

                  /*
                  Actualizamos la tabla de direcciones-------------------------
                  */

                  if TMSCommand():New( ::oCon ):ExecDirect( "UPDATE " + ::cPrefixTable( "address" ) + " SET alias='" + ( cFirstName ) + ( cLastName ) + ;
                                                                                "', firstname='" + ( cFirstName ) + ;
                                                                                "', lastname='" + ( cLastName ) + ;
                                                                                "', address1='" + ::oCon:EscapeStr( ::oCli:Domicilio ) + ;
                                                                                "', postcode='" + ::oCon:EscapeStr( ::oCli:CodPostal ) + ;
                                                                                "', city='" + ::oCon:EscapeStr( ::oCli:Poblacion ) + ;
                                                                                "', phone='" + ::oCon:EscapeStr( ::oCli:Telefono ) + ;
                                                                                "', phone_mobile='" + ::oCon:EscapeStr( ::oCli:Movil ) + ;
                                                                                "', dni='" + ::oCon:EscapeStr( ::oCli:Nif ) + ;
                                                                                "', date_upd='" + dtos( GetSysDate() ) + ;
                                                                                "' WHERE id_customer=" + AllTrim( Str( ::oCli:cCodWeb ) ) )

                     ::SetText( "Actualizado correctamente el cliente " + AllTrim( ::oCli:Titulo ) + " en la tabla address", 3 )
                  else
                     ::SetText( "Error al actualizar el cliente " + AllTrim( ::oCli:Titulo ) + " en la tabla address", 3 )
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

      if !Empty( ::oMeterL )
         ::oMeterL:SetTotal( ::nTotMeter )
      end if

      ::nActualMeterL := 1

      if oQuery:RecCount() > 0

         ::SetText( "Descargando clientes desde la web", 2 )

         oQuery:GoTop()

         while !oQuery:Eof()

            ::MeterParticularText( " Descargando cliente " + AllTrim( Str( ::nActualMeterL ) ) + " de "  + AllTrim( Str( ::nTotMeter ) ) )

            if !::oCli:SeekInOrd( Str( oQuery:FieldGet( 1 ), 11 ), "cCodWeb" )

               cCodCli           := NextKey( dbLast(  ::oCli, 1 ), ::oCli:cAlias, "0", RetNumCodCliEmp() )

               ::oCli:Append()
               ::oCli:Blank()
               ::oCli:Cod        := cCodCli
               
               if uFieldEmpresa( "lApeNomb" )
                  ::oCli:Titulo  := UPPER( oQuery:FieldGetbyName( "lastname" ) ) + ", " + UPPER( oQuery:FieldGetByName( "firstname" ) ) // Last Name - firstname
               else   
                  ::oCli:Titulo  := UPPER( oQuery:FieldGetbyName( "firstname" ) ) + Space( 1 ) + UPPER( oQuery:FieldGetByName( "lastname" ) ) //firstname - Last Name
               end if   
               
               ::oCli:nTipCli    := 3
               ::oCli:CopiasF    := 1
               ::oCli:Serie      := uFieldEmpresa( "cSeriePed" )
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

               oQueryDirecciones       := TMSQuery():New( ::oCon, "SELECT * FROM " + ::cPrefixTable( "address" ) + " WHERE id_customer = " + Str( oQuery:FieldGet( 1 ) ) )

               if oQueryDirecciones:Open()

                  if oQueryDirecciones:RecCount() > 0

                     oQueryDirecciones:GoTop()

                     while !oQueryDirecciones:Eof()

                        /*
                        Tomamos el nombre de la provincia----------------------
                        */                        

                        oQueryState       := TMSQuery():New( ::oCon, "SELECT * FROM " + ::cPrefixTable( "state" ) + " WHERE id_state = " + Str( oQueryDirecciones:FieldGetByName( "id_state" ) ) )

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
                        ::oObras:cCodObr         := "@" + AllTrim( Str( oQueryDirecciones:FieldGet( 1 ) ) ) //"id_address"
                        
                        if uFieldEmpresa( "lApeNomb" )
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
                  ::SetText( "Cliente " + AllTrim( oQuery:FieldGetByName( "ape" ) ) + Space( 1 ) + AllTrim( oQuery:FieldGetByName( "firstname" ) ) + " introducido correctamente.", 3 )
               else
                  ::SetText( "Error al descargar el cliente: " + AllTrim( oQuery:FieldGetByName( "ape" ) ) + Space( 1 ) + AllTrim( oQuery:FieldGetByName( "firstname" ) ), 3 )
               end if

            else

               ::SetText( "El cliente " + AllTrim( oQuery:FieldGetByName( "ape" ) ) + Space( 1 ) + AllTrim( oQuery:FieldGetByName( "firstname" ) ) + " ya existe en nuestra base se datos.", 3 )

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

METHOD AppendPedidoprestashop() CLASS TComercio

   local cSerPed                 := ""
   local nNumPed                 := 0
   local cSufPed                 := ""
   local dFecha
   local oQueryL
   local nNumLin                 := 1
   local cCodWeb                 := 1
   local oQuery                  := TMSQuery():New( ::oCon, 'SELECT * FROM ' + ::cPrefixTable( "orders" ) )

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
               nNumPed                 := nNewDoc( if( !Empty( uFieldEmpresa( "cSeriePed" ) ), uFieldEmpresa( "cSeriePed" ), cNewSer( "nPedCli", ::oCount:cAlias ) ), ::oPedCliT:cAlias, "NPEDCLI", , ::oCount:cAlias )
               cSufPed                 := RetSufEmp()

               SET DATE FORMAT "yyyy/mm/dd"
               dFecha                  := Ctod( Left( oQuery:FieldGetByName( "date_add" ), 10 ) )
               SET DATE FORMAT "dd/mm/yyyy"

               ::oPedCliT:Append()
               ::oPedCliT:Blank()

               ::oPedCliT:cSerPed      := cSerPed
               ::oPedCliT:nNumPed      := nNumPed
               ::oPedCliT:cSufPed      := cSufPed
               ::oPedCliT:cSuPed       := oQuery:FieldGetByName( "reference" )
               ::oPedCliT:cTurPed      := cCurSesion()
               ::oPedCliT:dFecPed      := dFecha
               ::oPedCliT:cCodAlm      := oUser():cAlmacen()
               ::oPedCliT:cCodCaj      := oUser():cCaja()
               ::oPedCliT:cCodObr      := "@" + AllTrim( Str( oQuery:FieldGetByName( "id_address_delivery" ) ) )
               ::oPedCliT:cCodPgo      := cFPagoWeb( AllTrim( oQuery:FieldGetByName( "module" ) ), ::oFPago:cAlias )
               ::oPedCliT:nEstado      := 1
               ::oPedCliT:nTarifa      := 1
               ::oPedCliT:cDivPed      := cDivEmp()
               ::oPedCliT:nVdvPed      := nChgDiv( cDivEmp(), ::oDivisas:cAlias )
               ::oPedCliT:lSndDoc      := .t.
               ::oPedCliT:lIvaInc      := uFieldEmpresa( "lIvaInc" )
               ::oPedCliT:cManObr      := Padr( "Gastos envio", 250 )
               ::oPedCliT:nManObr      := oQuery:FieldGetByName( "total_shipping_tax_excl" )
               ::oPedCliT:nIvaMan      := oQuery:FieldGetByName( "carrier_tax_rate" )
               ::oPedCliT:lCloPed      := .f.
               ::oPedCliT:cCodUsr      := cCurUsr()
               ::oPedCliT:dFecCre      := GetSysDate()
               ::oPedCliT:cTimCre      := Time()
               ::oPedCliT:cCodDlg      := oUser():cDelegacion()
               ::oPedCliT:lWeb         := .t.
               ::oPedCliT:lInternet    := .t.
               ::oPedCliT:cCodWeb      := oQuery:FieldGet( 1 )
               cCodWeb                 := oQuery:FieldGet( 1 )
               ::oPedCliT:nTotNet      := oQuery:FieldGetByName( "total_products" )
               ::oPedCliT:nTotIva      := oQuery:FieldGetByName( "total_paid_tax_incl" ) - ( oQuery:FieldGetByName( "total_products" ) + oQuery:FieldGetByName( "total_shipping_tax_incl" ) )
               ::oPedCliT:nTotPed      := oQuery:FieldGetByName( "total_paid_tax_incl" )

               if ::oCli:SeekInOrd( Str( oQuery:FieldGetByName( "id_customer" ), 11 ) , "cCodWeb" )

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

               oQueryL            := TMSQuery():New( ::oCon, "SELECT * FROM " + ::cPrefixtable( "order_detail" ) + " WHERE id_order=" + AllTrim( Str( cCodWeb ) ) )

               if oQueryL:Open()

                  if oQueryL:RecCount() > 0

                     oQueryL:GoTop()

                     while !oQueryL:Eof()

                        ::oPedCliL:Append()
                        ::oPedCliL:Blank()
                        ::oPedCliL:cSerPed        := cSerPed
                        ::oPedCliL:nNumPed        := nNumPed
                        ::oPedCliL:cSufPed        := cSufPed
                        ::oPedCliL:cDetalle       := oQueryL:FieldGetByName( "product_name" )
                        ::oPedCliL:mLngDes        := oQueryL:FieldGetByName( "product_name" )
                        ::oPedCliL:nCanPed        := 1
                        ::oPedCliL:nUniCaja       := oQueryL:FieldGetByName( "product_quantity" )
                        ::oPedCliL:nPreDiv        := oQueryL:FieldGetByName( "product_price" )
                        ::oPedCliL:dFecha         := dFecha
                        ::oPedCliL:nNumLin        := nNumLin
                        ::oPedCliL:cAlmLin        := cDefAlm()
                        ::oPedCliL:nTarLin        := 1
                        ::oPedCliL:nDto           := oQueryL:FieldGetByName( "reduction_percent" )
                        ::oPedCliL:nDtoDiv        := oQueryL:FieldGetByName( "reduction_amount" )
                        ::oPedCliL:nIva           := ::nIvaProduct( oQueryL:FieldGetByName( "product_id" ) )

                        if ::oArt:SeekInOrd( Str( oQueryL:FieldGetByName( "product_id" ), 11 ) , "cCodWeb" )

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
                           ::oPedCliL:lLote       := ::oArt:lLote 
                           ::oPedCliL:cLote       := ::oArt:cLote 

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

               /*
               Metemos los comentarios del cliente como incidencias------------
               */

               ::AppendMessagePedido( cCodWeb, cSerPed, nNumPed, cSufPed, dFecha )

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

METHOD AppendMessagePedido( cCodWeb, cSerPed, nNumPed, cSufPed, dFecha ) Class TComercio

   local oQueryThead
   local oQueryMessage

   oQueryThead    := TMSQuery():New( ::oCon, "SELECT * FROM " + ::cPrefixtable( "customer_thread" ) + " WHERE id_order=" + AllTrim( Str( cCodWeb ) ) )

   if oQueryThead:Open()

      if oQueryThead:RecCount() > 0

         oQueryThead:GoTop()

         while !oQueryThead:Eof()

            oQueryMessage    := TMSQuery():New( ::oCon, "SELECT * FROM " + ::cPrefixtable( "customer_message" ) + " WHERE id_customer_thread=" + AllTrim( Str( oQueryThead:FieldGet( 1 ) ) ) )

            if oQueryMessage:Open()

               if oQueryMessage:RecCount() > 0

                  oQueryMessage:GoTop()

                  while !oQueryMessage:Eof()

                     ::oPedCliI:Append()
                     ::oPedCliI:Blank()

                     ::oPedCliI:cSerPed   := cSerPed
                     ::oPedCliI:nNumPed   := nNumPed
                     ::oPedCliI:cSufPed   := cSufPed
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

         oQuery                  := TMSQuery():New( ::oCon, "SELECT * FROM " + ::cPrefixTable( "order_history" ) + " WHERE id_order=" + AllTrim( Str( ::oPedCliT:cCodWeb ) ) + " AND id_order_state=5" )

         if oQuery:Open()

            if oQuery:RecCount() == 0

               if TMSCommand():New( ::oCon ):ExecDirect( "INSERT INTO " + ::cPrefixTable( "order_history" ) + " ( id_employee, " + ;
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

Method AddImages( cImage ) CLASS TComercio

   if aScan( ::aImages, cImage ) == 0
      aAdd( ::aImages, cImage )
   end if

Return ( ::aImages )

//---------------------------------------------------------------------------//

METHOD ActualizaPropiedadesProducts( cCodWeb ) CLASS TComercio

   /*
   Eliminamos todas las comvinaciones------------------------------------------
   */

   ::EliminaPropiedadesProductsPrestashop( cCodWeb )
   ::InsertPropiedadesProductPrestashop( cCodWeb )

Return ( Self )

//---------------------------------------------------------------------------//

Method ActualizaStockProductsPrestashop( cCodigoArticulo, cCodigoPropiedad1, cCodigoPropiedad2, cValorPropiedad1, cValorPropiedad2 ) CLASS TComercio

   local oQuery
   local cCommand
   local nTotStock            := 0
   local cCodWebValPr1
   local cCodWebValPr2
   local nIdProductAttribute

   if !::lReady()
      Return .f.
   end if
   
   ::lShowDialogWait()

   if ::OpenFiles()

      if !Empty( cCodigoArticulo )

         if ::oArt:Seek( cCodigoArticulo )

            cCodWebValPr1        := oRetFld( cCodigoPropiedad1 + cValorPropiedad1, ::oTblPro, "cCodWeb" )
            cCodWebValPr2        := oRetFld( cCodigoPropiedad2 + cValorPropiedad2, ::oTblPro, "cCodWeb" )
   
            if ::ConectBBDD()

               do case
                  case Empty( cValorPropiedad1 ) .and. Empty( cValorPropiedad2 ) //Caso de artículo sin propiedades

                     /*
                     Actualizamos el stock total de la web---------------------
                     */

                     nTotStock   := ::oStock:nStockArticulo( ::oArt:Codigo )

                     cCommand    := "UPDATE " + ::cPrefixTable( "stock_available" ) + " SET " + ;
                                       "quantity='" + AllTrim( Str( nTotStock ) ) + "' " + ;
                                    "WHERE id_product=" + AllTrim( Str( ::oArt:cCodWeb ) ) + " AND id_product_attribute=0 "

                     TMSCommand():New( ::oCon ):ExecDirect( cCommand )

                  case !Empty( cValorPropiedad1 ) .and. Empty( cValorPropiedad2 ) //Caso de artículo con una sola propiedad

                     /*
                     Actualizamos el stock total de la web---------------------
                     */

                     nTotStock   := ::oStock:nStockArticulo( ::oArt:Codigo )

                     cCommand    := "UPDATE " + ::cPrefixTable( "stock_available" ) + " SET " + ;
                                       "quantity='" + AllTrim( Str( nTotStock ) ) + "' " + ;
                                    "WHERE id_product=" + AllTrim( Str( ::oArt:cCodWeb ) ) + " AND id_product_attribute=0 "

                     TMSCommand():New( ::oCon ):ExecDirect( cCommand )

                     /*
                     Actualizamos el stock por propiedades---------------------
                     */

                     nTotStock   := ::oStock:nStockAlmacen( cCodigoArticulo, , cValorPropiedad1 )

                     nIdProductAttribute := ::nIdProductAttribute( ::oArt:cCodWeb, cCodWebValPr1 )

                     if nIdProductAttribute != 0

                        cCommand    := "UPDATE " + ::cPrefixTable( "stock_available" ) + " SET " + ;
                                          "quantity='" + AllTrim( Str( nTotStock ) ) + "' " + ;
                                       "WHERE id_product=" + AllTrim( Str( ::oArt:cCodWeb ) ) + " AND id_product_attribute=" + Str( nIdProductAttribute )

                        TMSCommand():New( ::oCon ):ExecDirect( cCommand )

                     end if   

                  case !Empty( cValorPropiedad1 ) .and. !Empty( cValorPropiedad2 ) //Caso de artículo con dos propiedades

                     /*
                     Actualizamos el stock total de la web---------------------
                     */

                     nTotStock   := ::oStock:nStockArticulo( ::oArt:Codigo )

                     cCommand    := "UPDATE " + ::cPrefixTable( "stock_available" ) + " SET " + ;
                                       "quantity='" + AllTrim( Str( nTotStock ) ) + "' " + ;
                                    "WHERE id_product=" + AllTrim( Str( ::oArt:cCodWeb ) ) + " AND id_product_attribute=0 "

                     TMSCommand():New( ::oCon ):ExecDirect( cCommand )

                     /*
                     Actualizamos el stock por propiedades---------------------
                     */

                     nTotStock   := ::oStock:nStockAlmacen( cCodigoArticulo, , cValorPropiedad1, cValorPropiedad2 )

                     nIdProductAttribute := ::nIdProductAttribute( ::oArt:cCodWeb, cCodWebValPr1, cCodWebValPr2 )

                     if nIdProductAttribute != 0

                        cCommand    := "UPDATE " + ::cPrefixTable( "stock_available" ) + " SET " + ;
                                          "quantity='" + AllTrim( Str( nTotStock ) ) + "' " + ;
                                       "WHERE id_product=" + AllTrim( Str( ::oArt:cCodWeb ) ) + " AND id_product_attribute=" + Str( nIdProductAttribute )

                        TMSCommand():New( ::oCon ):ExecDirect( cCommand )

                     end if   

               end case   

            ::DisconectBBDD()
   
            endif      

         end if   

      end if

      ::CloseFiles()

   end if

   ::lHideDialogWait()

Return .t.

//---------------------------------------------------------------------------//

METHOD nIdProductAttribute( cCodWebArt, cCodWebValPr1, cCodWebValPr2 ) CLASS TComercio

   local nIdProductAttribute  := 0
   local cCommand             := ""
   local oQuery
   local oQuery2
   local lPrp1                := .f.
   local lPrp2                := .f.

   do case
      case !Empty( cCodWebValPr1 ) .and. Empty( cCodWebValPr2 )

      cCommand          := "SELECT * FROM " + ::cPrefixTable( "product_attribute" ) + ;
                        " WHERE id_product = " + Alltrim( Str( cCodWebArt ) )

      oQuery            := TMSQuery():New( ::oCon, cCommand )

      if oQuery:Open() .and. oQuery:RecCount() > 0

         oQuery:GoTop()

         while !oQuery:Eof()

            cCommand                      := "SELECT * FROM " + ::cPrefixTable( "product_attribute_combination" ) + ;
                                             " WHERE id_product_attribute = " + Alltrim( Str( oQuery:FieldGet( 1 ) ) )

            oQuery2                       := TMSQuery():New( ::oCon, cCommand )

               if oQuery2:Open()             .and.;
                  oQuery2:RecCount() == 1    .and.;
                  oQuery2:FieldGet( 1 ) == cCodWebValPr1

                  nIdProductAttribute     := oQuery:FieldGet( 1 )

               end if   

            oQuery:Skip()

         end while

      end if

      case !Empty( cCodWebValPr1 ) .and. !Empty( cCodWebValPr2 )

      cCommand          := "SELECT * FROM " + ::cPrefixTable( "product_attribute" ) + " WHERE id_product=" + Alltrim( Str( cCodWebArt ) )

      oQuery            := TMSQuery():New( ::oCon, cCommand )

      if oQuery:Open() .and. oQuery:RecCount() > 0

         oQuery:GoTop()

         while !oQuery:Eof()

            cCommand                      := "SELECT * FROM " + ::cPrefixTable( "product_attribute_combination" ) + " WHERE id_product_attribute=" + Alltrim( Str( oQuery:FieldGet( 1 ) ) )

            oQuery2                       := TMSQuery():New( ::oCon, cCommand )

               if oQuery2:Open() .and. oQuery2:RecCount() == 2

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

            lPrp1 := .f.
            lPrp2 := .f.

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

   cResult     := StrTran( AllTrim( cDirectory ), "\", "/" )

   /*
   Si empieza por barra la quitamos--------------------------------------------
   */

   if Left( cResult, 1 ) == "/"
      cResult  := SubStr( cResult, 2 )
   end if

   /*
   Si termina por barra la quitamos--------------------------------------------
   */

   if Right( cResult, 1 ) == "/"
      cResult  := SubStr( cResult, 1, Len( cResult ) - 1 )
   end if

Return ( cResult )

//---------------------------------------------------------------------------//

METHOD CreateDirectoryImages( cCarpeta ) CLASS TComercio

   local n

   for n := 1 to Len( cCarpeta )
      ::oFtp:CreateDirectory( SubStr( cCarpeta, n, 1 ) )
      ::oFtp:SetCurrentDirectory( SubStr( cCarpeta, n, 1 ) )
   next   

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD ReturnDirectoryImages( cCarpeta ) CLASS TComercio

   local n

   for n := 1 to Len( cCarpeta )
      ::oFtp:SetCurrentDirectory( ".." )
   next   

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD CreateDirectoryImagesLocal( cCarpeta ) CLASS TComercio

   local n
   local cResult  := ""

   if ValType( cCarpeta ) == "N"
      cCarpeta    := AllTrim( Str( cCarpeta ) )
   end if

   for n := 1 to Len( cCarpeta )

      cResult  += "/" + SubStr( cCarpeta, n, 1 )
         
      if !isDirectory( ::cDImagen + "/p" + cResult )
         Makedir( ::cDImagen + "/p" + cResult )
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

METHOD buildInitData() CLASS TComercio

   ::aIvaData  := {}
   ::lSyncAll  := .t.

Return ( Self )

//---------------------------------------------------------------------------//

METHOD buildIvaPrestashop( id ) CLASS TComercio

   if aScan( ::aIvaData, {|h| hGet( h, "id" ) == id } ) == 0
      if ::oIva:SeekInOrd( id, "Tipo" ) 
         if ::lSyncAll .or. ::oIva:cCodWeb == 0
            aAdd( ::aIvaData, { "id" => id, "rate" => alltrim( str( ::oIva:TpIva ) ), "name" => rtrim( ::oIva:DescIva ) } )
         end if
      end if 
   end if 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD buildProductPrestashop( id ) CLASS TComercio

   local hIvaData

   ::lShowDialogWait()

   if ::OpenFiles()

      ::buildInitData()

      if ::oArt:Seek( id )
         ::buildIvaPrestashop( ::oArt:TipoIva )
      end if

      for each hIvaData in ::aIvaData
         ::buildInsertIvaPrestashop( hIvaData )
      next 

      ::CloseFiles()

   end if

   ::lHideDialogWait()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD buildInsertIvaPrestashop( hIvaData ) CLASS TComercio

   local cCommand          := ""  
   local nCodigoWeb        := 0
   local nCodigoGrupoWeb   := 0

   cCommand := "INSERT INTO " + ::cPreFixtable( "tax") + ;
                  "( rate, " + ;
                  "active ) " + ;
               "VALUES " + ;
                  "('" + hGet( hIvaData, "rate" ) + "', " + ;  // rate
                  "'1' )"                                      // active

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      nCodigoWeb           := ::oCon:GetInsertId()
      ::buildTextOk( hGet( hIvaData, "name" ), ::cPrefixTable( "tax" ) )
   else
      ::buildTextCancel( hGet( hIvaData, "name" ), ::cPrefixTable( "tax" ) )
   end if

   /*
   Insertamos un tipo de IVA nuevo en la tabla tax_lang-----------------
   */

   cCommand := "INSERT INTO " + ::cPrefixTable( "tax_lang" ) + "( " +;
                  "id_tax, " + ;
                  "id_lang, " + ;
                  "name )" + ;
               " VALUES " + ;
                  "('" + Str( nCodigoWeb ) + "', " + ;         // id_tax
                  "'" + Str( ::nLanguage ) + "', " + ;         // id_lang
                  "'" + ::oCon:EscapeStr( hGet( hIvaData, "name" ) ) + "' )"      // name

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::buildTextOk( hGet( hIvaData, "name" ), ::cPrefixTable( "tax_lang" ) )
   else
      ::buildTextCancel( hGet( hIvaData, "name" ), ::cPrefixTable( "tax_lang" ) )
   end if

   /*
   Insertamos un tipo de IVA nuevo en la tabla tax_rule_group-----------------
   */

   cCommand := "INSERT INTO "+ ::cPrefixTable( "tax_rules_group" ) + "( " + ;
                  "name, " + ;
                  "active )" + ;
               " VALUES " + ;
                  "('" + ::oCon:EscapeStr( hGet( hIvaData, "name" ) ) + "', " + ; // name
                  "'1' )"                                      // active

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      nCodigoGrupoWeb           := ::oCon:GetInsertId()
      ::buildTextOk( hGet( hIvaData, "name" ), ::cPrefixTable( "tax_rule_group" ) )
   else
      ::buildTextError( hGet( hIvaData, "name" ), ::cPrefixTable( "tax_rule_group" ) )
   end if

   /*
   Insertamos un tipo de IVA nuevo en la tabla tax_rule------------------------
   */

   cCommand := "INSERT INTO " + ::cPrefixTable( "tax_rule" ) + "( " +;
                  "id_tax_rules_group, " + ;
                  "id_country, " + ;
                  "id_tax )" + ;
               " VALUES " + ;
                  "('" + Str( nCodigoGrupoWeb ) + "', " + ;  // id_tax_rules_group
                  "'6', " + ;                                // id_country - 6 es el valor de España
                  "'" + Str( nCodigoWeb ) + "' )"            // id_tax

   if TMSCommand():New( ::oCon ):ExecDirect( cCommand )
      ::buildTextOk( hGet( hIvaData, "name" ), ::cPrefixTable( "tax_rule" ) )
   else
      ::buildTextError( hGet( hIvaData, "name" ), ::cPrefixTable( "tax_rule" ) )
   end if

   // Guardo referencia a la web-----------------------------------------------

   if ::oIva:SeekInOrd( hGet( hIvaData, "id" ), "Tipo" )
      ::oIva:fieldPutByName( "cCodWeb", nCodigoWeb )
      ::oIva:fieldPutByName( "cGrpWeb", nCodigoGrupoWeb )
   end if 

Return ( nCodigoweb )

//ESTRUCTURAS----------------------------------------------------------------//
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

   cLink             := AllTrim( cLink )

   for each cCaracter in cLink

      do case
         case ( Abs( cCaracter ) >= 48 .and. Abs( cCaracter ) <= 57 ) .or.;
              ( Abs( cCaracter ) >= 65 .and. Abs( cCaracter ) <= 90 ) .or.;
              ( Abs( cCaracter ) >= 97 .and. Abs( cCaracter ) <= 122 )

            cResult     := cResult + cCaracter

         case Abs( cCaracter ) == 32

            if Abs( cCarAnt ) != 32
               cResult  := cResult + "-"
            end if   

         otherwise

            cResult     := cResult + ReemplazaAcento( cCaracter )

      end case

      cCarAnt           := cCaracter

   next

   if !Empty( cResult )
      cResult        := lower( cResult + "-" )
   end if  

Return( cResult )

//---------------------------------------------------------------------------//

Function ReemplazaAcento( cCaracter )

   local nPos
   local cPatron     := "ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖÙÚÛÜÝàáâãäåæçèéêëìíîïñòóôõöùúûüýÿŠšŸ"
   local cReemplazo  := "AAAAAAACEEEEIIIIDNOOOOOUUUUYaaaaaaaceeeeiiiinooooouuuuyySsY"
   local cResultado  := Space( 0 )

   nPos              := At( cCaracter, cPatron )

   if nPos != 0
      cResultado     := SubStr( cReemplazo, nPos, 1 )
   end if

return ( cResultado )

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

#endif