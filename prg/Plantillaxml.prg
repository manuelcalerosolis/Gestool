#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "XBrowse.ch"
#include "HbXml.ch"

//----------------------------------------------------------------------------//

#define OFN_PATHMUSTEXIST            0x00000800
#define OFN_NOCHANGEDIR              0x00000008
#define OFN_ALLOWMULTISELECT         0x00000200
#define OFN_EXPLORER                 0x00080000     // new look commdlg
#define OFN_LONGNAMES                0x00200000     // force long names for 3.x modules
#define OFN_ENABLESIZING             0x00800000

//----------------------------------------------------------------------------//

memvar oThis

//----------------------------------------------------------------------------//
//
// /Catalogue/CatalogueLine/Item/AdditionalItemIdentification/ID/PhysicalAttribute/AttributeID
//

CLASS TPlantillaXML FROM TMasDet

   DATA  cMru              INIT "Cli"
   DATA  cBitmap           INIT "WebTopBlack"

   DATA  aDetails          INIT  {}

   DATA  aCamposCabecera   INIT  {}
   DATA  aCamposDetalle    INIT  {}
   DATA  aRegistros        INIT  {}

   DATA  oCbxCabecera
   DATA  oCbxDetalle

   DATA  lOneImportacion   INIT  .t.
   DATA  lEndImportacion   INIT  .f.

   DATA  nSearchOcurrency  INIT  0

   DATA  oBtnAceptar

   CLASSDATA   aTipo       INIT  {  "Artículo",;
                                    "Artículo. Precios de compra" ,;
                                    "Artículo. Precios de venta por propiedades",;
                                    "Artículo. Escandallos",;
                                    "Artículo. Referencias de proveedores",;
                                    "Artículo. Codigos de barras",;
                                    "Pedido proveedores",;
                                    "Albarán proveedores",;
                                    "Factura proveedores",;
                                    "Factura proveedores.Líneas",;
                                    "Recibos facturas proveedor",;
                                    "Presupuesto clientes",;
                                    "Pedido clientes",;
                                    "Albarán clientes",;
                                    "Factura clientes",;
                                    "Factura de anticipos",;
                                    "Factura rectificativa",;
                                    "Recibos facturas clientes",;
                                    "Tickets clientes",;
                                    "Pagos de clientes" }

   DATA  oBrwCabecera
   DATA  oBrwDetalle

   DATA  oBrwPlantilla
   DATA  aPlantilla        INIT  {}

   DATA  oBrwFichero
   DATA  aFichero          INIT  {}

   DATA  oTreeImportacion
   DATA  oSubTreeImportacion
   DATA  oRecTreeImportacion

   DATA  oImageImportacion
   DATA  lMultipleImportacion

   DATA  oDetCabeceraPlantillaXML

   DATA  oXmlDocument

   DATA  bPreAssign

   DATA  oSav

   DATA  oDbfArt
   DATA  oDbfArtCod
   DATA  oFacPrvT
   DATA  oFacPrvL
   DATA  oAlbPrvT
   DATA  oAlbPrvL
   DATA  oDbfDiv
   DATA  oDbfCount
   DATA  oDbfPrv
   DATA  oDbfIva
   DATA  oDbfFam
   DATA  oFacPrvP
   DATA  oAlbPrvP
   DATA  oDbfFPago
   DATA  oArtPrv

   DATA  cNameConfig       INIT  Space( 100 )
   DATA  lAllUser          INIT  .t.

   DATA  oBtnImportacion

   DATA  oOleExcel
   DATA  oACtiveSheet

   DATA  nActiveSheetRows
   DATA  nActiveSheetColumns

   DATa  nRowSelected

   DATA  aMessage

   METHOD New( cPath, oWndParent, oMenuItem )
   METHOD CreateInit( cPath )
   METHOD Create( cPath )

   METHOD OpenFiles( lExclusive )
   METHOD OpenService( lExclusive )

   METHOD CloseFiles()

   METHOD DefineFiles()

   METHOD Activate()

   METHOD Resource( nMode )

   METHOD lPreSave( oGet, nMode )

   METHOD InitResource()

   METHOD ChangeCabecera()

   METHOD Importacion()

   METHOD TreeImportacionChanged()

   METHOD AddPlantilla()

   METHOD DelPlantilla()

   METHOD AddFichero()

   METHOD DelFichero()

   METHOD AllExecuteImportacion()

   METHOD ExecuteImportacion( cFileXML )

   Method AdoImportacion( cFichero )

   Method XlsCreateObject()

   Method AdoCreateObject()

   Method TxTCreateObject()

   Method TxtFindData()

   METHOD TxtCreateRegister()

   METHOD FindData()

   METHOD AdoFindData()

   METHOD FindIterator()

   METHOD AdoFindIterator()

   METHOD AdoGetPlantilla( cPlantilla )

   METHOD EvalCondition( cCond, nRow )

   METHOD DataToColumn( cData )

   METHOD DataToValue( cData )

   METHOD DataToField( cData, cField )

   METHOD PostEvalData( cData )

   METHOD DataToType( cData, cField )

   METHOD CreateRegister()

   METHOD lOnlyOne()

   METHOD lGetConfigName()

   METHOD lValidConfigName()

   METHOD SaveConfig()

   METHOD DeleteConfig()

   METHOD LoadConfig()

   Method lLoadButtons()

   Method bAction( cText )

   Method lFindCampoClave( aCampos )

   Method aCampoClave()

   Method EditPlantillaImportacion()

END CLASS

//----------------------------------------------------------------------------//

METHOD New( cPath, oWndParent, oMenuItem ) CLASS TPlantillaXML

   DEFAULT cPath              := cPatEmp()
   DEFAULT oWndParent         := GetWndFrame()

   if oMenuItem != nil .and. ::nLevel == nil
      ::nLevel                := Auth():Level( oMenuItem )
   else
      ::nLevel                := 1
   end if

   if nAnd( ::nLevel, 1 ) == 0
      msgStop( "Acceso no permitido." )
      return nil
   end if

   ::cPath                    := cPath
   ::oWndParent               := oWndParent

   ::bFirstKey                := {|| ::oDbf:cCodigo }

   ::oDetCabeceraPlantillaXML := TDetCabeceraPlantillaXML():New( cPath, Self )

   ::AddDetail( ::oDetCabeceraPlantillaXML )

   private oThis              := Self

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD CreateInit( cPath ) CLASS TPlantillaXML

   DEFAULT cPath              := cPatEmp()

   ::cPath                    := cPath

   ::bFirstKey                := {|| ::oDbf:cCodigo }

   ::oDetCabeceraPlantillaXML := TDetCabeceraPlantillaXML():New( cPath, Self )

   ::AddDetail( ::oDetCabeceraPlantillaXML )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Create( cPath ) CLASS TPlantillaXML

   DEFAULT cPath        := cPatEmp()

   ::cPath              := cPath
   ::oDbf               := nil

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Activate() CLASS TPlantillaXML

   if nAnd( ::nLevel, 1 ) == 0

      /*
      Cerramos todas las ventanas----------------------------------------------
      */

      if ::oWndParent != nil
         ::oWndParent:CloseAll()
      end if

      if Empty( ::oDbf )
         if !::OpenFiles()
            return nil
         end if
      end if

      /*
      Creamos el Shell---------------------------------------------------------
      */

      if !::lCreateShell
         ::CreateShell( ::nLevel )
      end if

      ::oWndBrw:GralButtons( Self )

      DEFINE BTNSHELL ::oBtnImportacion ;
         RESOURCE "gc_flash_" ;
         OF       ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::Importacion() ) ;
         TOOLTIP  "E(j)ecutar";
         HOTKEY   "J" ;
         LEVEL    ACC_ZOOM

      ::lLoadButtons()

      ::oWndBrw:EndButtons( Self )

      if ::cHtmlHelp != nil
         ::oWndBrw:cHtmlHelp  := ::cHtmlHelp
      end if

      ::oWndBrw:Activate( nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, {|| ::CloseFiles() } )

   else

      msgStop( "Acceso no permitido." )

   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive ) CLASS TPlantillaXML

   local lOpen          := .t.
   local oError
   local oBlock

   DEFAULT lExclusive   := .f.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf ) .or. Empty( ::oSav )
         ::DefineFiles()
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

      ::oSav:Activate( .f., !( lExclusive ) )

      DATABASE NEW ::oDbfCount   PATH ( cPatEmp() )   FILE "NCOUNT.DBF"       VIA ( cDriver() ) SHARED INDEX "NCOUNT.CDX"

      DATABASE NEW ::oDbfDiv     PATH ( cPatDat() )   FILE "DIVISAS.DBF"      VIA ( cDriver() ) SHARED INDEX "DIVISAS.CDX"

      DATABASE NEW ::oDbfPrv     PATH ( cPatEmp() )   FILE "PROVEE.DBF"       VIA ( cDriver() ) SHARED INDEX "PROVEE.CDX"

      DATABASE NEW ::oDbfArt     PATH ( cPatEmp() )   FILE "ARTICULO.DBF"     VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

      DATABASE NEW ::oDbfArtCod  PATH ( cPatEmp() )   FILE "ArtCodebar.Dbf"   VIA ( cDriver() ) SHARED INDEX "ArtCodebar.Cdx"

      DATABASE NEW ::oFacPrvT    PATH ( cPatEmp() )   FILE "FACPRVT.DBF"      VIA ( cDriver() ) SHARED INDEX "FACPRVT.CDX"

      DATABASE NEW ::oFacPrvL    PATH ( cPatEmp() )   FILE "FACPRVL.DBF"      VIA ( cDriver() ) SHARED INDEX "FACPRVL.CDX"

      DATABASE NEW ::oFacPrvP    PATH ( cPatEmp() )   FILE "FACPRVP.DBF"      VIA ( cDriver() ) SHARED INDEX "FACPRVP.CDX"

      DATABASE NEW ::oAlbPrvT    PATH ( cPatEmp() )   FILE "AlbProvT.DBF"     VIA ( cDriver() ) SHARED INDEX "AlbProvT.CDX"

      DATABASE NEW ::oAlbPrvL    PATH ( cPatEmp() )   FILE "AlbProvL.DBF"     VIA ( cDriver() ) SHARED INDEX "AlbProvL.CDX"

      DATABASE NEW ::oDbfFam     PATH ( cPatEmp() )   FILE "FAMILIAS.DBF"     VIA ( cDriver() ) SHARED INDEX "FAMILIAS.CDX"

      DATABASE NEW ::oDbfIva     PATH ( cPatDat() )   FILE "TIVA.DBF"         VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

      DATABASE NEW ::oDbfFPago   PATH ( cPatEmp() )   FILE "FPAGO.DBF"        VIA ( cDriver() ) SHARED INDEX "FPAGO.CDX"

      DATABASE NEW ::oArtPrv     PATH ( cPatEmp() )   FILE "PROVART.DBF"      VIA ( cDriver() ) SHARED INDEX "PROVART.CDX"

      ::OpenDetails()

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

      ::CloseFiles()

      lOpen             := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD OpenService( lExclusive ) CLASS TPlantillaXML

   local lOpen          := .t.
   local oError
   local oBlock

   DEFAULT lExclusive   := .f.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf ) .or. Empty( ::oSav )
         ::DefineFiles()
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

      ::oSav:Activate( .f., !( lExclusive ) )

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

      ::CloseFiles()

      lOpen             := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TPlantillaXML

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:End()
      ::oDbf         := nil
   end if

   if ::oSav != nil .and. ::oSav:Used()
      ::oSav:End()
      ::oSav         := nil
   end if

   if ::oDbfDiv != nil .and. ::oDbfDiv:Used()
      ::oDbfDiv:End()
      ::oDbfDiv      := nil
   end if

   if ::oDbfCount != nil .and. ::oDbfCount:Used()
      ::oDbfCount:End()
      ::oDbfCount    := nil
   end if

   if ::oDbfPrv != nil .and. ::oDbfPrv:Used()
      ::oDbfPrv:End()
      ::oDbfPrv      := nil
   end if

   if ::oDbfArt != nil .and. ::oDbfArt:Used()
      ::oDbfArt:End()
      ::oDbfArt      := nil
   end if

   if ::oDbfArtCod != nil .and. ::oDbfArtCod:Used()
      ::oDbfArtCod:End()
      ::oDbfArtCod   := nil
   end if

   if ::oFacPrvT != nil .and. ::oFacPrvT:Used()
      ::oFacPrvT:End()
      ::oFacPrvT     := nil
   end if

   if ::oFacPrvL != nil .and. ::oFacPrvL:Used()
      ::oFacPrvL:End()
      ::oFacPrvL     := nil
   end if

   if ::oFacPrvP != nil .and. ::oFacPrvP:Used()
      ::oFacPrvP:End()
      ::oFacPrvP     := nil
   end if

   if ::oAlbPrvT != nil .and. ::oAlbPrvT:Used()
      ::oAlbPrvT:End()
      ::oAlbPrvT     := nil
   end if

   if ::oAlbPrvL != nil .and. ::oAlbPrvL:Used()
      ::oAlbPrvL:End()
      ::oAlbPrvL     := nil
   end if

   if ::oDbfFam != nil .and. ::oDbfFam:Used()
      ::oDbfFam:End()
      ::oDbfFam      := nil
   end if

   if ::oDbfIva != nil .and. ::oDbfIva:Used()
      ::oDbfIva:End()
      ::oDbfIva      := nil
   end if

   if ::oDbfFPago != nil .and. ::oDbfFPago:Used()
      ::oDbfFPago:End()
      ::oDbfFPago    := nil
   end if

   if ::oArtPrv != nil .and. ::oArtPrv:Used()
      ::oArtPrv:End()
      ::oArtPrv    := nil
   end if

   ::CloseDetails()

RETURN .t.

//----------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver ) CLASS TPlantillaXML

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE TABLE ::oDbf FILE "PlantillaXML.Dbf" CLASS "PlantillaXML" ALIAS "PlantXML" PATH ( cPath ) VIA ( cDriver ) COMMENT "PlantillaXML"

      FIELD NAME "cCodigo"    TYPE "C" LEN 003 DEC 0 COMMENT "Código"               COLSIZE 60  OF ::oDbf
      FIELD NAME "cDescrip"   TYPE "C" LEN 035 DEC 0 COMMENT "Nombre"               COLSIZE 300 OF ::oDbf
      FIELD NAME "cTipo"      TYPE "C" LEN 200 DEC 0 COMMENT "Tipo de documento"    COLSIZE 300 OF ::oDbf
      FIELD NAME "lMult"      TYPE "L" LEN 001 DEC 0 COMMENT "Multiple registos"    HIDE        OF ::oDbf

      INDEX TO "PlantillaXML.Cdx" TAG "cCodigo"    ON "cCodigo"   COMMENT "Código"  NODELETED   OF ::oDbf
      INDEX TO "PlantillaXML.Cdx" TAG "cDescrip"   ON "cDescrip"  COMMENT "Nombre"  NODELETED   OF ::oDbf
      INDEX TO "PlantillaXML.Cdx" TAG "cTipo"      ON "cTipo"     COMMENT "Tipo"    NODELETED   OF ::oDbf

   END DATABASE ::oDbf

   DEFINE TABLE ::oSav FILE "PlantillaSav.Dbf" CLASS "PlantillaSav" ALIAS "PlantSav" PATH ( cPath ) VIA ( cDriver ) COMMENT "PlantillaSav"

      FIELD NAME "cUser"      TYPE "C" LEN 003 DEC 0 COMMENT "Usuario"              COLSIZE 60  OF ::oSav
      FIELD NAME "cText"      TYPE "C" LEN 100 DEC 0 COMMENT "Nombre"               COLSIZE 300 OF ::oSav
      FIELD NAME "cData"      TYPE "M" LEN 010 DEC 0 COMMENT "Contanido"            COLSIZE 300 OF ::oSav

      INDEX TO "PlantillaSav.Cdx" TAG "cText"      ON "Upper( cText )"              NODELETED   OF ::oSav

   END DATABASE ::oSav

RETURN ( ::oDbf )

//----------------------------------------------------------------------------//

METHOD Resource( nMode ) CLASS TPlantillaXML

	local oDlg
   local oGet

   DEFINE DIALOG oDlg RESOURCE "PlantillaXML" TITLE LblTitle( nMode ) + "plantilla de importación XML"

      REDEFINE GET oGet ;
         VAR      ::oDbf:cCodigo ;
         ID       100 ;
         WHEN     ( nMode == APPD_MODE ) ;
         VALID    NotValid( oGet, ::oDbf:cAlias, .t., "0" ) ;
			PICTURE 	"@!" ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cDescrip ;
         ID       110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE CHECKBOX ::oDbf:lMult ;
         ID       130 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE COMBOBOX ::oCbxCabecera ;
         VAR      ::oDbf:cTipo ;
         WHEN     ( nMode == APPD_MODE ) ;
         ITEMS    ( ::aTipo ) ;
         ID       120 ;
         OF       oDlg

      ::oCbxCabecera:bChange        := {|| ::ChangeCabecera() }

      /*
      Browse de los datos de cabecera------------------------------------------
      */

      ::oBrwCabecera                := IXBrowse():New( oDlg )

      ::oBrwCabecera:bClrSel        := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrwCabecera:bClrSelFocus   := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oDetCabeceraPlantillaXML:oDbfVir:SetBrowse( ::oBrwCabecera ) 

      ::oBrwCabecera:nMarqueeStyle  := 6
      ::oBrwCabecera:cName          := "Cabeceras de plantillas XML"

      if ( nMode != ZOOM_MODE )
         ::oBrwCabecera:bLDblClick  := {|| ::oDetCabeceraPlantillaXML:Edit( ::oBrwCabecera ) }
      end if

      with object ( ::oBrwCabecera:AddCol() )
         :cHeader          := "Campo"
         :bStrData         := {|| ::oDetCabeceraPlantillaXML:oDbfVir:cCampo }
         :nWidth           := 200
      end with

      with object ( ::oBrwCabecera:AddCol() )
         :cHeader          := "Nodo o constante"
         :bStrData         := {|| if( ::oDetCabeceraPlantillaXML:oDbfVir:nTipo != 2, ::oDetCabeceraPlantillaXML:oDbfVir:mNode, ::oDetCabeceraPlantillaXML:oDbfVir:uConst ) }
         :nWidth           := 280
      end with

      ::oBrwCabecera:CreateFromResource( 200 )

		REDEFINE BUTTON ;
         ID       210 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( ::oDetCabeceraPlantillaXML:Append( ::oBrwCabecera ) )

      REDEFINE BUTTON ;
         ID       220 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( ::oDetCabeceraPlantillaXML:Edit( ::oBrwCabecera ) )

      REDEFINE BUTTON ;
         ID       230 ;
			OF 		oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::oDetCabeceraPlantillaXML:Del( ::oBrwCabecera ) )

      REDEFINE BUTTON ;
         ID       240 ;
			OF 		oDlg ;
         ACTION   ( ::oDetCabeceraPlantillaXML:Zoom() )

      REDEFINE BUTTON ;
         ID       250 ;
			OF 		oDlg ;
         ACTION   ( dbSwapUp( ::oDetCabeceraPlantillaXML:oDbfVir:cAlias, ::oBrwCabecera ) )

      REDEFINE BUTTON ;
         ID       260 ;
			OF 		oDlg ;
         ACTION   ( dbSwapDown( ::oDetCabeceraPlantillaXML:oDbfVir:cAlias, ::oBrwCabecera ) )

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( if( ::lPreSave( oGet, nMode ), oDlg:end( IDOK ), ) )

      /*
      Botones de dialogo-------------------------------------------------------
      */

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
			ACTION 	( oDlg:end() )

      REDEFINE BUTTON ;
         ID       559 ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( MsgInfo( "Ayuda no definida" ) )

      if nMode != ZOOM_MODE
         oDlg:AddFastKey( VK_F2, {|| ::oDetCabeceraPlantillaXML:Append( ::oBrwCabecera ) } )
         oDlg:AddFastKey( VK_F3, {|| ::oDetCabeceraPlantillaXML:Edit( ::oBrwCabecera ) } )
         oDlg:AddFastKey( VK_F4, {|| ::oDetCabeceraPlantillaXML:Del( ::oBrwCabecera ) } )
         oDlg:AddFastKey( VK_F5, {|| if( ::lPreSave( oGet, nMode ), oDlg:end( IDOK ), ) } )
      end if

      oDlg:bStart := {|| ::InitResource() }

	ACTIVATE DIALOG oDlg	CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

METHOD lPreSave( oGet, nMode ) CLASS TPlantillaXML

   if nMode == APPD_MODE .or. nMode == DUPL_MODE

      if Empty( ::oDbf:cCodigo )
         MsgStop( "Código de la plantilla no puede estar vacío." )
         return .f.
      end if

      if ::oDbf:SeekInOrd( ::oDbf:cCodigo, "cCodigo" )
         msgStop( "Código de la plantilla ya existe." )
         return .f.
      end if

   end if

   if Empty( ::oDbf:cDescrip )
      MsgStop( "La descripción de la plantilla no puede estar vacia." )
      return .f.
   end if

   if Empty( ::oDbf:cTipo )
      MsgStop( "El tipo de la plantilla no puede estar vacio." )
      return .f.
   end if

RETURN .t.

//---------------------------------------------------------------------------//

METHOD InitResource() CLASS TPlantillaXML

   ::ChangeCabecera()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ChangeCabecera() CLASS TPlantillaXML

   local cTipo                := Rtrim( ::oDbf:cTipo )

   ::aCamposCabecera          := {}

   do case
      case cTipo == "Artículo"

         ::aCamposCabecera    := aItmArt()

      case cTipo == "Artículo. Precios de compra"

         ::aCamposCabecera    := aItmCom()

      case cTipo == "Artículo. Precios de venta por propiedades"

         ::aCamposCabecera    := aItmVta()

      case cTipo == "Artículo. Escandallos"

         ::aCamposCabecera    := aItmKit()

      case cTipo == "Artículo. Referencias de proveedores"

         ::aCamposCabecera    := aItmPrv()

      case cTipo == "Artículo. Codigos de barras"

         ::aCamposCabecera    := aItmBar()

      case cTipo == "Pedido proveedores"

         ::aCamposCabecera    := aItmPedPrv()

      case cTipo == "Albarán proveedores"

         ::aCamposCabecera    := aItmAlbPrv()

      case cTipo == "Factura proveedores"

         ::aCamposCabecera    := aItmFacPrv()

      case cTipo == "Factura proveedores.Líneas"

         ::aCamposCabecera    := aColFacPrv()

      case cTipo == "Recibos facturas proveedor"

      case cTipo == "Presupuesto clientes"

      case cTipo == "Pedido clientes"

         ::aCamposCabecera    := aItmPedCli()

      case cTipo == "Albarán clientes"
      case cTipo == "Factura clientes"
      case cTipo == "Factura de anticipos"
      case cTipo == "Factura rectificativa"
      case cTipo == "Recibos facturas clientes"
      case cTipo == "Tickets clientes"
      case cTipo == "Pagos de clientes"
   end case

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Importacion( cText ) CLASS TPlantillaXML

   local oDlg

   ::aPlantilla                              := {}
   ::aFichero                                := {}

   if !Empty( cText )
      ::LoadConfig( cText )
   end if

   ::oImageImportacion                       := TImageList():New( 16, 16 )
   ::oImageImportacion:AddMasked( TBitmap():Define( "gc_check_12" ),  Rgb( 255, 0, 255 ) )
   ::oImageImportacion:AddMasked( TBitmap():Define( "gc_flash_16" ),                Rgb( 255, 0, 255 ) )

   DEFINE DIALOG oDlg RESOURCE "ImportarPlantillaXML"

      ::oBrwPlantilla                        := IXBrowse():New( oDlg )

      ::oBrwPlantilla:bClrSel                := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrwPlantilla:bClrSelFocus           := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oBrwPlantilla:nMarqueeStyle          := 5
      ::oBrwPlantilla:lHScroll               := .f.

      ::oBrwPlantilla:SetArray( ::aPlantilla, , , .f. )

      ::oBrwPlantilla:bLDblClick             := {|| ::EditPlantillaImportacion()  }

      ::oBrwPlantilla:CreateFromResource( 120 )

      with object ( ::oBrwPlantilla:AddCol() )
         :cHeader          := "Código"
         :bEditValue       := {|| ::aPlantilla[ ::oBrwPlantilla:nArrayAt, 1 ] }
         :nWidth           := 60
      end with

      with object ( ::oBrwPlantilla:AddCol() )
         :cHeader          := "Nombre"
         :bEditValue       := {|| ::aPlantilla[ ::oBrwPlantilla:nArrayAt, 2 ] }
         :nWidth           := 140
      end with

      with object ( ::oBrwPlantilla:AddCol() )
         :cHeader          := "Tipo"
         :bEditValue       := {|| ::aPlantilla[ ::oBrwPlantilla:nArrayAt, 3 ] }
         :nWidth           := 140
      end with

      REDEFINE BUTTON ;
         ID       100 ;
         OF       oDlg ;
         ACTION   ( ::AddPlantilla() )

      REDEFINE BUTTON ;
         ID       110 ;
         OF       oDlg ;
         ACTION   ( ::DelPlantilla() )

      REDEFINE BUTTON ;
         ID       130 ;
         OF       oDlg ;
         ACTION   ( msginfo( "Arriba" ) )

      REDEFINE BUTTON ;
         ID       140 ;
         OF       oDlg ;
         ACTION   ( msginfo( "Abajo" ) )

      /*
      Browse de ficheros a importar--------------------------------------------
      */

      ::oBrwFichero                        := IXBrowse():New( oDlg )

      ::oBrwFichero:bClrSel                := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrwFichero:bClrSelFocus           := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oBrwFichero:SetArray( ::aFichero, , , .f. )

      ::oBrwFichero:nMarqueeStyle          := 5

      ::oBrwFichero:lHScroll               := .f.

      ::oBrwFichero:CreateFromResource( 220 )

      ::oBrwFichero:bLDblClick             := {|| ShellExecute( oDlg:hWnd, "open", Rtrim( ::aFichero[ ::oBrwFichero:nArrayAt ] ) ) }

      with object ( ::oBrwFichero:AddCol() )
         :cHeader          := "Fichero"
         :bEditValue       := {|| ::aFichero[ ::oBrwFichero:nArrayAt ] }
         :nWidth           := 460
      end with

      REDEFINE BUTTON ;
         ID       200 ;
         OF       oDlg ;
         ACTION   ( ::AddFichero() )

      REDEFINE BUTTON ;
         ID       210 ;
         OF       oDlg ;
         ACTION   ( ::DelFichero() )

      /*
      Tree de importación------------------------------------------------------
      */

      ::oTreeImportacion            := TTreeView():Redefine( 300, oDlg )
      ::oTreeImportacion:bLDblClick := {|| ::TreeImportacionChanged() }

      REDEFINE BUTTON ;
         ID       400 ;
         OF       oDlg ;
         ACTION   ( ::SaveConfig() )

      REDEFINE BUTTON ;
         ID       410 ;
         OF       oDlg ;
         ACTION   ( ::DeleteConfig() )

      REDEFINE BUTTON ::oBtnAceptar ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( ::AllExecuteImportacion( oDlg ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      REDEFINE BUTTON ;
         ID       559 ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( MsgInfo( "Ayuda no definida" ) )

      oDlg:bStart := {|| ::oTreeImportacion:SetImageList( ::oImageImportacion ) }

      oDlg:AddFastKey( VK_F5, {|| ::AllExecuteImportacion( oDlg ) } )

   ACTIVATE DIALOG oDlg CENTER

   ::oImageImportacion:End()

   ::oTreeImportacion:Destroy()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Method EditPlantillaImportacion()

   local nRec  := ::oDbf:Recno()

   if ::oDbf:SeekInOrd( ::aPlantilla[ ::oBrwPlantilla:nArrayAt, 1 ], "cCodigo" )
      ::oWndBrw:RecEdit()
   end if

   ::oDbf:GoTo( nRec )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD TreeImportacionChanged() CLASS TPlantillaXML

   local oItemTree   := ::oTreeImportacion:GetItem()

   if !Empty( oItemTree ) .and. !Empty( oItemTree:bAction )
      Eval( oItemTree:bAction )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddPlantilla() CLASS TPlantillaXML

   local cPlantilla           := ::Buscar()

   if !Empty( cPlantilla )

      if aScan( ::aPlantilla, {|a| a[ 1 ] == ::oDbf:cCodigo } ) != 0 //  .or. a[ 3 ] == ::oDbf:cTipo

         MsgStop( "La plantilla ya está incorporada." )

      else

         if aScan( ::aPlantilla, {|a| Rtrim( a[ 3 ] ) == Rtrim( ::oDbf:cTipo ) } ) != 0 //  .or.

            MsgStop( "La plantilla es del mismo tipo que una anterior." )

         else

            aAdd( ::aPlantilla, { ::oDbf:cCodigo, ::oDbf:cDescrip, ::oDbf:cTipo } )

         end if

      end if

   end if

   ::oBrwPlantilla:Refresh()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD DelPlantilla() CLASS TPlantillaXML

   aDel( ::aPlantilla, ::oBrwPlantilla:nArrayAt, .t. )

   ::oBrwPlantilla:Refresh()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddFichero() CLASS TPlantillaXML

   local i
   local cFile
   local aFile
   local nFlag    := nOr( OFN_PATHMUSTEXIST, OFN_NOCHANGEDIR, OFN_ALLOWMULTISELECT, OFN_EXPLORER, OFN_LONGNAMES )

   cFile          := cGetFile( "All | *.*", "Seleccione los ficheros a importar", "*.*" , , .f., .t., nFlag )
   cFile          := Left( cFile, At( Chr( 0 ) + Chr( 0 ), cFile ) - 1 )

   if !Empty( cFile ) //.or. Valtype( cFile ) == "N"

      cFile       := StrTran( cFile, Chr( 0 ), "," )
      aFile       := hb_aTokens( cFile, "," )

      if Len( aFile ) > 1

         for i := 2 to Len( aFile )
            aFile[ i ] := aFile[ 1 ] + "\" + aFile[ i ]
         next

         aDel( aFile, 1, .t. )

      endif

      if IsArray( aFile )

         for i := 1 to Len( aFile )
            aAdd( ::aFichero, aFile[ i ] ) // if( SubStr( aFile[ i ], 4, 1 ) == "\", aFileDisc( aFile[i] ) + "\" + aFileName( aFile[ i ] ), aFile[ i ] ) )
         next

      else

         aAdd( ::aFichero, aFile )

      endif

   end if

   ::oBrwFichero:Refresh()

RETURN ( ::aFichero )

//---------------------------------------------------------------------------//

METHOD DelFichero() CLASS TPlantillaXML

   aDel( ::aFichero, ::oBrwFichero:nArrayAt, .t. )

   ::oBrwFichero:Refresh()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lOnlyOne( cPlantilla ) CLASS TPlantillaXML

   ::lOneImportacion          := .t.

   ::oDetCabeceraPlantillaXML:oDbf:Seek( cPlantilla )
   while ::oDetCabeceraPlantillaXML:oDbf:cCodigo == cPlantilla .and. !::oDetCabeceraPlantillaXML:oDbf:Eof()

      if ::oDetCabeceraPlantillaXML:oDbf:lOcurr
         ::lOneImportacion    := .f.
      end if

      ::oDetCabeceraPlantillaXML:oDbf:Skip()

   end while

RETURN ( ::lOneImportacion )

//---------------------------------------------------------------------------//

METHOD AllExecuteImportacion( oDlg ) CLASS TPlantillaXML

   local cFichero
   local cPlantilla

   oDlg:Disable()

   ::oTreeImportacion:DeleteAll()

   if len( ::aFichero ) != 0

      for each cFichero in ::aFichero

         ::oSubTreeImportacion   := ::oTreeImportacion:Add( "Procesando fichero " + cFichero )

         ::oTreeImportacion:Select( ::oSubTreeImportacion )

         for each cPlantilla in ::aPlantilla

            ::AdoImportacion( cPlantilla[ 1 ], cFichero )

         next

      next

      ::oTreeImportacion:Select( ::oTreeImportacion:Add( "Proceso finalizado" ) )

   else
      ::oTreeImportacion:Select( ::oTreeImportacion:Add( "Tiene que seleccionar, al menos un fichero para exportar." ) )
   end if

   oDlg:Enable()

   SetWindowText( ::oBtnAceptar:hWnd, "Procesado" )

RETURN ( Self )

//---------------------------------------------------------------------------//

Method AdoImportacion( cPlantilla, cFichero ) CLASS TPlantillaXML

   local oError
   local oBlock

   local cExtension
   /*
   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE
   */
   if ::oDbf:SeekInOrd( cPlantilla, "cCodigo" )

      ::lMultipleImportacion                    := ::oDbf:lMult

      if ::oDetCabeceraPlantillaXML:oDbf:SeekInOrd( cPlantilla, "cCodigo" )

         if File( cFichero )

            cExtension  := GetFileExt( cFichero )

            do case
               case AllTrim( cExtension ) == "xls"
                  ::XlsCreateObject( cPlantilla, cFichero )

               case AllTrim( cExtension ) == "xml"
                  ::AdoCreateObject( cPlantilla, cFichero )

               otherwise

                  ::TxtCreateObject( cPlantilla, cFichero )

            end case

         end if

      else

         msgStop( "Líneas de plantilla " + cPlantilla + " no encontrada." )

      end if

   else

      msgStop( "Plantilla " + cPlantilla + " no encontrada." )

   end if
   /*
   RECOVER USING oError

      msgStop( "Error en la importación." + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )
   */
RETURN ( Self )

//---------------------------------------------------------------------------//ç

Method AdoCreateObject( cPlantilla, cFichero ) CLASS TPlantillaXML

   local oError
   local oBlock
   local lError                           := .f.

   oBlock                                 := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::oOleExcel                         := TOleExcel():New( "Importando hoja de excel", "Conectando...", .f. )

      ::oOleExcel:oExcel:Visible          := .f.
      ::oOleExcel:oExcel:DisplayAlerts    := .f.

      ::oOleExcel:oExcel:Workbooks:Add()
      ::oOleExcel:oExcel:Workbooks:OpenXml( cFichero, 1, 2 )

      ::oActiveSheet                      := ::oOleExcel:oExcel:ActiveSheet

      ::nActiveSheetRows                  := ::oActiveSheet:UsedRange:Rows:Count()
      ::nActiveSheetColumns               := ::oActiveSheet:UsedRange:Columns:Count()

      if ::AdoFindData( cPlantilla )
         ::CreateRegister()
      end if

      ::oOleExcel:oExcel:Quit()
      ::oOleExcel:oExcel:DisplayAlerts    := .t.

      ::oOleExcel:End()
   
   RECOVER USING oError

      msgStop( "Error al crear el objeto Excel." + CRLF + ErrorMessage( oError ) )

      lError                              := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

Return( !lError )

//---------------------------------------------------------------------------//

Method XlsCreateObject( cPlantilla, cFichero ) CLASS TPlantillaXML

   ::oOleExcel                         := TOleExcel():New( "Importando hoja de excel", "Conectando...", .f. )

   ::oOleExcel:oExcel:Visible          := .f.
   ::oOleExcel:oExcel:DisplayAlerts    := .f.

   ::oOleExcel:oExcel:Workbooks:Add()
   ::oOleExcel:oExcel:Workbooks:Open( cFichero )

   ::oActiveSheet                      := ::oOleExcel:oExcel:ActiveSheet

   ::nActiveSheetRows                  := ::oActiveSheet:UsedRange:Rows:Count()
   ::nActiveSheetColumns               := ::oActiveSheet:UsedRange:Columns:Count()

   if ::AdoFindData( cPlantilla )
      ::CreateRegister()
   end if

   ::oOleExcel:oExcel:Quit()
   ::oOleExcel:oExcel:DisplayAlerts    := .t.

   ::oOleExcel:End()

Return( .t. )

//---------------------------------------------------------------------------//

Method TxtCreateObject( cPlantilla, cFichero ) CLASS TPlantillaXML

   local oFile

   if !Empty( cFichero ) .and. File( cFichero )

      oFile           := TTxtFile():New( cFichero )

      if !Empty( cPlantilla )       .and.;
         !Empty( oFile )            .and.;
         ::TxtFindData( cPlantilla )

         ::TxtCreateRegister( oFile )

      end if

      oFile:End()
      oFile           := nil

   end if

Return( .t. )

//---------------------------------------------------------------------------//

Method TxtFindData( cPlantilla ) CLASS TPlantillaXML

   local oStruct
   local aLineas              := {}
   local nPos
   local lReturn              := .t.

   ::ChangeCabecera()

   ::aCamposDetalle           := {}

   /*
   Recorremos las lineas de la plantilla---------------------------
   */

   if ::oDetCabeceraPlantillaXML:oDbf:Seek( cPlantilla )

      while ::oDetCabeceraPlantillaXML:oDbf:cCodigo == cPlantilla .and. !::oDetCabeceraPlantillaXML:oDbf:Eof()

         oStruct              := sCamposLineas():New()
         oStruct:cCampo       := ::oDetCabeceraPlantillaXML:oDbf:cCampo
         oStruct:nTipo        := ::oDetCabeceraPlantillaXML:oDbf:nTipo
         oStruct:uConst       := ::oDetCabeceraPlantillaXML:oDbf:uConst

         if ::oDetCabeceraPlantillaXML:oDbf:nTipo < 2

            nPos              := At( "-", ::oDetCabeceraPlantillaXML:oDbf:mNode )

            oStruct:nInicio   := Val( Left( ::oDetCabeceraPlantillaXML:oDbf:mNode, nPos - 1 ) )
            oStruct:nAncho    := Val( SubStr( ::oDetCabeceraPlantillaXML:oDbf:mNode, nPos + 1 ) )

         else

            oStruct:nInicio   := 0
            oStruct:nAncho    := 0

         end if

         oStruct:lClave       := ::oDetCabeceraPlantillaXML:oDbf:lClave

         aAdd( ::aCamposDetalle, oStruct )

      ::oDetCabeceraPlantillaXML:oDbf:Skip()

      end while

   else

      lReturn                 := .f.

   end if

return ( lReturn )

//---------------------------------------------------------------------------//

METHOD ExecuteImportacion( cPlantilla, cFileXML ) CLASS TPlantillaXML

   local cXml
   local oSubNode
   local oSubIter

   ::nSearchOcurrency         := 0

   if ::oDbf:SeekInOrd( cPlantilla, "cCodigo" )

      ::ChangeCabecera()

      ::lOnlyOne( cPlantilla )

      if ::oDetCabeceraPlantillaXML:oDbf:SeekInOrd( cPlantilla, "cCodigo" )

         ::oXmlDocument       := TXmlDocument():New( cFileXML )

         if ::oXmlDocument:nStatus != HBXML_STATUS_OK
            ::oTreeImportacion:Select( ::oTreeImportacion:Add( "Error procesando fichero " + cFileXML + " en la línea " + AllTrim( Str( ::oXmlDocument:nLine ) ) + ".", 0 ) )
            ::oTreeImportacion:Select( ::oTreeImportacion:Add( "Error " + ::oXmlDocument:ErrorMsg, 1 ) )
            return .f.
         end if

         if ::lOneImportacion

            if ::FindData( cPlantilla )
               ::CreateRegister()
            end if

         else

            while ::FindData( cPlantilla )
               ::CreateRegister()
            end while

         end if

      else

         msgStop( "Líneas de plantilla " + cPlantilla + " no encontrada." )

      end if

   else

      msgStop( "Plantilla " + cPlantilla + " no encontrada." )

   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD FindData( cPlantilla ) CLASS TPlantillaXML

   local a
   local oIter
   local oNode
   local cNode
   local cData
   local oTreeNode
   local lFindData               := .t.

   ::aMessage                    := {}

   /*
   Recorremos las lineas-------------------------------------------------------
   */

   if ::oDetCabeceraPlantillaXML:oDbf:Seek( cPlantilla )

      while ::oDetCabeceraPlantillaXML:oDbf:cCodigo == cPlantilla .and. !::oDetCabeceraPlantillaXML:oDbf:Eof()

         ::oDetCabeceraPlantillaXML:LoadValues( ::oDetCabeceraPlantillaXML:oDbf:mValue )

         if ::oDetCabeceraPlantillaXML:oDbf:nTipo == 2

            aAdd( ::aMessage, "Reemplazado el campo " + Rtrim( ::oDetCabeceraPlantillaXML:oDbf:cCampo ) + " con el valor " + Rtrim( ::oDetCabeceraPlantillaXML:oDbf:uConst ) )

            ::DataToType( Rtrim( ::oDetCabeceraPlantillaXML:oDbf:uConst ), Rtrim( ::oDetCabeceraPlantillaXML:oDbf:cCampo ) )

         else

            oNode                := ::FindIterator()

            if !Empty( oNode )

               cData             := cValToChar( oNode:cData )
               if !Empty( cData )

                  /*
                  Reemplazo por tabla de valores----------------------------------------
                  */

                  cData          := ::DataToValue( cData )

                  /*
                  Asignamos el valor al campo-------------------------------------------
                  */

                  ::DataToField( cData, Rtrim( ::oDetCabeceraPlantillaXML:oDbf:cCampo ) )

                  aAdd( ::aMessage, "Encontrado en el path " + Rtrim( ::oDetCabeceraPlantillaXML:oDbf:mNode ) + " con el valor " + cData )

               else

                  lFindData      := .f.

                  aAdd( ::aMessage, "El path " + Rtrim( ::oDetCabeceraPlantillaXML:oDbf:mNode ) + " no contiene datos." )

               end if

            else

               aAdd( ::aMessage, "No encontrado en el path " + Rtrim( ::oDetCabeceraPlantillaXML:oDbf:mNode ) + "." )

            end if

         end if

         sysrefresh()

         ::oDetCabeceraPlantillaXML:oDbf:Skip()

      end while

   end if

   /*
   Valores q lleva la tabla para crearse---------------------------------------
   */

   if lFindData

      oTreeNode                  := ::oSubTreeImportacion:Add( "Busqueda de valores :" + ::oDbf:cDescrip )

      for each a in ::aMessage
         oTreeNode:Add( a )
      next

      oTreeNode                  := oTreeNode:Add( "Valores almacenados" )

      for each a in ::aCamposCabecera
         if !Empty( a[ 5 ] )
            oTreeNode:Add( Rtrim( a[ 5 ] ) + " con el valor " + Rtrim( cValToChar( a[ 9 ] ) ) + " de tipo " + a[ 2 ] )
         end if
      next

   else

      ::oSubTreeImportacion:Add( "Busqueda sin resultados :" + ::oDbf:cDescrip )

   end if

RETURN ( lFindData )

//---------------------------------------------------------------------------//

METHOD AdoFindData( cPlantilla ) CLASS TPlantillaXML

   local a
   local oTreeNode
   local lFindData            := .t.

   ::aMessage                 := {}
   ::aRegistros               := {}

   /*
   Recorremos el fichero-------------------------------------------------------
   */

   if ::lMultipleImportacion

      for ::nRowSelected := 2 to ::nActiveSheetRows
         ::AdoGetPlantilla( cPlantilla )
      next

   else

      ::AdoGetPlantilla( cPlantilla )

   end if

   /*
   Valores q lleva la tabla para crearse---------------------------------------
   */

   oTreeNode               := ::oSubTreeImportacion:Add( "Busqueda de valores :" + ::oDbf:cDescrip )



   for each a in ::aMessage
      oTreeNode:Add( a )
   next

   oTreeNode               := oTreeNode:Add( "Valores almacenados" )

   for each a in ::aCamposCabecera
      if !Empty( a[ 5 ] )
         oTreeNode:Add( Rtrim( a[ 5 ] ) + " con el valor " + Rtrim( cValToChar( a[ 9 ] ) ) + " de tipo " + a[ 2 ] )
      end if
   next

RETURN ( lFindData )

//---------------------------------------------------------------------------//

METHOD AdoGetPlantilla( cPlantilla ) CLASS TPlantillaXML

   local cData
   local lFindData            := .f.

   ::ChangeCabecera()

   /*
   Recorremos las lineas-------------------------------------------------------
   */

   if ::oDetCabeceraPlantillaXML:oDbf:Seek( cPlantilla )

      while ::oDetCabeceraPlantillaXML:oDbf:cCodigo == cPlantilla .and. !::oDetCabeceraPlantillaXML:oDbf:Eof()

         ::oDetCabeceraPlantillaXML:LoadValues( ::oDetCabeceraPlantillaXML:oDbf:mValue )

         if ::oDetCabeceraPlantillaXML:oDbf:nTipo == 2

            aAdd( ::aMessage, "Reemplazado el campo " + Rtrim( ::oDetCabeceraPlantillaXML:oDbf:cCampo ) + " con el valor " + Rtrim( ::oDetCabeceraPlantillaXML:oDbf:uConst ) )

            ::DataToType( Rtrim( ::oDetCabeceraPlantillaXML:oDbf:uConst ), Rtrim( ::oDetCabeceraPlantillaXML:oDbf:cCampo ) )

         else

            cData             := ::AdoFindIterator()

            if !Empty( cData )

               lFindData      := .t.

               /*
               Reemplazo por tabla de valores----------------------------------------
               */

               cData          := ::DataToValue( cData )

               /*
               Asignamos el valor al campo-------------------------------------------
               */

               ::DataToField( cData, Rtrim( ::oDetCabeceraPlantillaXML:oDbf:cCampo ) )

               aAdd( ::aMessage, "Encontrado en el path " + Rtrim( ::oDetCabeceraPlantillaXML:oDbf:mNode ) + " con el valor " + cValToChar( cData ) )

            else

               //lFindData      := .f.

               aAdd( ::aMessage, "El path " + Rtrim( ::oDetCabeceraPlantillaXML:oDbf:mNode ) + " no contiene datos." )

               //exit

            end if

         end if

         sysrefresh()

         ::oDetCabeceraPlantillaXML:oDbf:Skip()

     end while

   end if

   if lFindData

      aAdd( ::aRegistros, ::aCamposCabecera )

      if !Empty( ::oRecTreeImportacion )
         ::oRecTreeImportacion:Add( "Registro " + Alltrim( Trans( Len( ::aRegistros ), "999999999" ) ) + " completado." )
      else
         ::oTreeImportacion:Select( ::oTreeImportacion:Add( "Registro " + Alltrim( Trans( Len( ::aRegistros ), "999999999" ) ) + " completado." ) )
      end if

   end if

RETURN ( lFindData )

//---------------------------------------------------------------------------//

METHOD TxtCreateRegister( oFile ) CLASS TPlantillaXML

   local i
   local nPos
   local cTipo          := Rtrim( ::oDbf:cTipo )
   local aCampos
   local aPlantilla
   local cCodArt
   local nNumLin        := 1
   local aFacturas      := {}

   ::aRegistros         := {}

   do case
   case cTipo == "Artículo"

      ::oRecTreeImportacion         := ::oTreeImportacion:Add( "Procesando artículos", 0, nil )
      ::oTreeImportacion:Select( ::oRecTreeImportacion )

      /*
      Recorremos el fichero y guardamos los valores----------------------------
      */

      while !oFile:lEoF()

         aPlantilla                 := Array( Len( ::aCamposCabecera ) )

         for each aCampos in ::aCamposDetalle

            nPos                    := aScan( ::aCamposCabecera, {| a | Upper( a[ 5 ] ) == Upper( AllTrim( aCampos:cCampo ) ) } )

            if aCampos:nTipo != 2
               aPlantilla[ nPos ]   := ::DataToType( SubStr( oFile:cLine, aCampos:nInicio, aCampos:nAncho ), aCampos:cCampo, .t. )
            else
               aPlantilla[ nPos ]   := ::DataToType( aCampos:uConst, aCampos:cCampo, .t. )
            end if

         next

         aAdd( ::aRegistros, aPlantilla )

         oFile:Skip()

      end while

      /*
      Creamos los registros nuevos---------------------------------------------
      */

      for each aCampos in ::aRegistros

         cCodArt                       := aCampos[ ::oDbfArt:FieldPos( "Codigo" ) ]

         if !Empty( cCodArt )

            if !::oDbfArt:SeekInOrd( cCodArt, "Codigo" )

               ::oDbfArt:Append()

               for i := 1 to len( aCampos )
                  ::oDbfArt:FieldPut( i, aCampos[ i ] )
               next

               ::oRecTreeImportacion   := ::oTreeImportacion:Add( "Código de artículo " + Rtrim( cCodArt ) + " añadido a la base de datos.", 1, bGenEdtArticulo( cCodArt ) )

            else

               for i := 1 to len( aCampos )
                  if !Empty( aCampos[ i ] )
                     ::oDbfArt:FieldPut( i, aCampos[ i ] )
                  end if
               next

               ::oRecTreeImportacion   := ::oTreeImportacion:Add( "Código de artículo " + Rtrim( cCodArt ) + " ya existe en la base de datos.", 1, bGenEdtArticulo( cCodArt ) )

            end if

            ::oTreeImportacion:Select( ::oRecTreeImportacion )
            ::oTreeImportacion:Refresh()

         end if

         SysRefresh()

      next

   case cTipo == "Artículo. Precios de compra"
   case cTipo == "Artículo. Precios de venta por propiedades"
   case cTipo == "Artículo. Escandallos"
   case cTipo == "Artículo. Referencias de proveedores"
   case cTipo == "Artículo. Codigos de barras"
   case cTipo == "Pedido proveedores"

   case cTipo == "Albarán proveedores"

      ::oRecTreeImportacion                        := ::oTreeImportacion:Add( "Procesando albaran de proveedor", 0, nil )
      ::oTreeImportacion:Select( ::oRecTreeImportacion )

      /*
      Recorremos el fichero----------------------------------------------------
      */

      while !oFile:lEoF()

         if !::lFindCampoClave( oFile )

            aPlantilla                             := Array( Len( ::aCamposCabecera ) )

            /*
            Pasamos todos los campos-------------------------------------------
            */

            for each aCampos in ::aCamposDetalle

               nPos                                := aScan( ::aCamposCabecera, {| a | Upper( a[ 5 ] ) == Upper( AllTrim( aCampos:cCampo ) ) } )

               if aCampos:nTipo != 2
                  aPlantilla[ nPos ]               := ::DataToType( SubStr( oFile:cLine, aCampos:nInicio, aCampos:nAncho ), aCampos:cCampo, .t. )
               else
                  aPlantilla[ nPos ]               := ::DataToType( aCampos:uConst, aCampos:cCampo, .t. )
               end if

            next

            aAdd( ::aRegistros, aPlantilla )

         end if

         oFile:Skip()

      end while

      /*
      Creamos los registros nuevos---------------------------------------------
      */

      for each aCampos in ::aRegistros

         if !Empty( aCampos[ ::oAlbPrvT:FieldPos( "cSuPed" ) ] )                          .and.;
            !::oAlbPrvT:SeekInOrd( aCampos[ ::oAlbPrvT:FieldPos( "cSuPed" ) ], "cSuPed" )

            /*
            Campos obligatorios de la cabecera de la Albtura-------------------
            */

            aCampos[ ::oAlbPrvT:FieldPos( "cSerAlb" ) ]     := cNewSer( "nAlbPrv", ::oDbfCount:cAlias )
            aCampos[ ::oAlbPrvT:FieldPos( "nNumAlb" ) ]     := nNewDoc( aPlantilla[ ::oAlbPrvT:FieldPos( "cSerAlb" ) ], ::oAlbPrvT:cAlias, "nAlbPrv", , ::oDbfCount:cAlias )
            aCampos[ ::oAlbPrvT:FieldPos( "cSufAlb" ) ]     := RetSufEmp()
            aCampos[ ::oAlbPrvT:FieldPos( "cTurAlb" ) ]     := cCurSesion()
            aCampos[ ::oAlbPrvT:FieldPos( "cDivAlb" ) ]     := cDivEmp()
            aCampos[ ::oAlbPrvT:FieldPos( "cCodAlm" ) ]     := Application():codigoAlmacen()
            aCampos[ ::oAlbPrvT:FieldPos( "cCodCaj" ) ]     := Application():CodigoCaja()
            aCampos[ ::oAlbPrvT:FieldPos( "nVdvAlb" ) ]     := nChgDiv( aPlantilla[ ::oAlbPrvT:FieldPos( "cDivAlb" ) ], ::oDbfDiv:cAlias )
            aCampos[ ::oAlbPrvT:FieldPos( "lSndDoc" ) ]     := .t.
            aCampos[ ::oAlbPrvT:FieldPos( "cCodPro" ) ]     := cProCnt()
            aCampos[ ::oAlbPrvT:FieldPos( "cCodUsr" ) ]     := Auth():Codigo()
            aCampos[ ::oAlbPrvT:FieldPos( "cCodDlg" ) ]     := Application():CodigoDelegacion()
            aCampos[ ::oAlbPrvT:FieldPos( "dFecAlb" ) ]     := GetSysDate()

            if !Empty( aCampos[ ::oAlbPrvT:FieldPos( "cCodPrv" ) ] )    .and.;
               ::oDbfPrv:Seek( AllTrim( aCampos[ ::oAlbPrvT:FieldPos( "cCodPrv" ) ] ), "Cod" )

               aCampos[ ::oAlbPrvT:FieldPos( "cNomPrv"  ) ] := ::oDbfPrv:Titulo
               aCampos[ ::oAlbPrvT:FieldPos( "cDirPrv"  ) ] := ::oDbfPrv:Domicilio
               aCampos[ ::oAlbPrvT:FieldPos( "cPobPrv"  ) ] := ::oDbfPrv:Poblacion
               aCampos[ ::oAlbPrvT:FieldPos( "cProvProv") ] := ::oDbfPrv:Provincia
               aCampos[ ::oAlbPrvT:FieldPos( "cPosPrv"  ) ] := ::oDbfPrv:CodPostal
               aCampos[ ::oAlbPrvT:FieldPos( "cDniPrv"  ) ] := ::oDbfPrv:Nif
               aCampos[ ::oAlbPrvT:FieldPos( "cCodPago" ) ] := ::oDbfPrv:FPago

            end if

            ::oAlbPrvT:Append()

            for i:= 1 to len( aCampos )
               ::oAlbPrvT:FieldPut( i, aCampos[ i ] )
            next

            ::oRecTreeImportacion   := ::oTreeImportacion:Add( "Albtura de proveedor " + Alltrim( aCampos[ 1 ] ) + AllTrim( Str( aCampos[ 2 ] ) ) + AllTrim( aCampos[ 3 ] ) + " añadida a la base de datos.", 1, {|| EdtAlbPrv( aCampos[ 1 ] + Str( aCampos[ 2 ] ) + aCampos[ 3 ] ) } )
            ::oTreeImportacion:Select( ::oRecTreeImportacion )

         end if

      next

   case cTipo == "Albaranes proveedores.Líneas"

      ::oRecTreeImportacion                        := ::oTreeImportacion:Add( "Procesando lineas de albaranes de proveedor", 0, nil )
      ::oTreeImportacion:Select( ::oRecTreeImportacion )

      /*
      Recorremos el fichero y guardamos los valores----------------------------
      */

      while !oFile:lEoF()

         aPlantilla                 := Array( Len( ::aCamposCabecera ) )

         for each aCampos in ::aCamposDetalle

            nPos                    := aScan( ::aCamposCabecera, {| a | Upper( a[ 5 ] ) == Upper( AllTrim( aCampos:cCampo ) ) } )

            if aCampos:nTipo != 2
               aPlantilla[ nPos ]   := ::DataToType( SubStr( oFile:cLine, aCampos:nInicio, aCampos:nAncho ), aCampos:cCampo, .t. )
            else
               aPlantilla[ nPos ]   := ::DataToType( aCampos:uConst, aCampos:cCampo, .t. )
            end if

         next

         aAdd( ::aRegistros, aPlantilla )

         oFile:Skip()

      end while

      /*
      Creamos los registros nuevos---------------------------------------------
      */

      for each aCampos in ::aRegistros

         cCodArt                                         := aCampos[ ::oAlbPrvL:FieldPos( "cRef" ) ]

         nNumLin                                         := 1

         if !Empty( cCodArt )                            .and.;
            ::oDbfArt:SeekInOrd( cCodArt, "Codigo" )     .and.;
            ::oAlbPrvT:SeekInOrd( Upper( AllTrim( aCampos[ ::oAlbPrvL:FieldPos( "cSuPed" ) ] ) ), "cSuPed" )

            ::oDbfArt:Load()
            ::oAlbPrvT:Load()

            aCampos[ ::oAlbPrvL:FieldPos( "cSerAlb" ) ]  := ::oAlbPrvT:cSerAlb
            aCampos[ ::oAlbPrvL:FieldPos( "nNumAlb" ) ]  := ::oAlbPrvT:nNumAlb
            aCampos[ ::oAlbPrvL:FieldPos( "cSufAlb" ) ]  := ::oAlbPrvT:cSufAlb
            aCampos[ ::oAlbPrvL:FieldPos( "cAlmLin" ) ]  := ::oAlbPrvT:cCodAlm

            /*
            Guardo los números de Albtura para generarle los pagos-------------
            */

            if aScan( aFacturas, {|a| a == ::oAlbPrvT:cSerAlb + Str( ::oAlbPrvT:nNumAlb ) + ::oAlbPrvT:cSufAlb } ) == 0
               aAdd( aFacturas, ::oAlbPrvT:cSerAlb + Str( ::oAlbPrvT:nNumAlb ) + ::oAlbPrvT:cSufAlb )
            end if

            aCampos[ ::oAlbPrvL:FieldPos( "nIva"    ) ]  := nIva( AllTrim( ::oDbfIva:cAlias ), ::oDbfArt:TipoIva )
            aCampos[ ::oAlbPrvL:FieldPos( "nPreCom" ) ]  := ::oDbfArt:pCosto
            aCampos[ ::oAlbPrvL:FieldPos( "nCtlStk" ) ]  := ::oDbfArt:nCtlStock
            aCampos[ ::oAlbPrvL:FieldPos( "cCodFam" ) ]  := ::oDbfArt:Familia
            aCampos[ ::oAlbPrvL:FieldPos( "cGrpFam" ) ]  := cGruFam( ::oDbfArt:Familia, ::oDbfFam:cAlias )
            aCampos[ ::oAlbPrvL:FieldPos( "nNumLin" ) ]  := nNumLin

            ::oAlbPrvL:Append()

            for i:= 1 to len( aCampos )
               ::oAlbPrvL:FieldPut( i, aCampos[ i ] )
            next

            ::oRecTreeImportacion                        := ::oTreeImportacion:Add( "Artículo " + AllTrim( cCodArt ) + " añadido a la Albtura de proveedor " + Alltrim( aCampos[ 1 ] ) + "/" + AllTrim( Str( aCampos[ 2 ] ) ) + "/" + AllTrim( aCampos[ 3 ] ) + " añadida a la base de datos.", 1, {|| EdtAlbPrv( aCampos[ 1 ] + Str( aCampos[ 2 ] ) + aCampos[ 3 ] ) } )
            ::oTreeImportacion:Select( ::oRecTreeImportacion )

            nNumLin++

         end if

      next

      /*
      Generamos los pagos y refrescamos el estado
      */

      for each aCampos in aFacturas
         if ::oAlbPrvT:SeekInOrd( aCampos, "nNumAlb" )

            ::oRecTreeImportacion   := ::oTreeImportacion:Add( "Creando recibos de la albaran " + aCampos, 0, nil )
            ::oTreeImportacion:Select( ::oRecTreeImportacion )
            //GenPgoAlbPrv( aCampos, ::oAlbPrvT:cAlias, ::oAlbPrvL:cAlias, ::oAlbPrvP:cAlias, ::oDbfPrv:cAlias, ::oDbfFPago:cAlias, ::oDbfDiv:cAlias )
            //ChkLqdAlbPrv( nil, ::oAlbPrvT:cAlias, ::oAlbPrvL:cAlias, ::oAlbPrvP:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias )

         end if
      next

   case cTipo == "Factura proveedores"

      ::oRecTreeImportacion                        := ::oTreeImportacion:Add( "Procesando facturas de proveedor", 0, nil )
      ::oTreeImportacion:Select( ::oRecTreeImportacion )

      /*
      Recorremos el fichero----------------------------------------------------
      */

      while !oFile:lEoF()

         if !::lFindCampoClave( oFile )

            aPlantilla                             := Array( Len( ::aCamposCabecera ) )

            /*
            Pasamos todos los campos-------------------------------------------
            */

            for each aCampos in ::aCamposDetalle

               nPos                                := aScan( ::aCamposCabecera, {| a | Upper( a[ 5 ] ) == Upper( AllTrim( aCampos:cCampo ) ) } )

               if aCampos:nTipo != 2
                  aPlantilla[ nPos ]               := ::DataToType( SubStr( oFile:cLine, aCampos:nInicio, aCampos:nAncho ), aCampos:cCampo, .t. )
               else
                  aPlantilla[ nPos ]               := ::DataToType( aCampos:uConst, aCampos:cCampo, .t. )
               end if

            next

            aAdd( ::aRegistros, aPlantilla )

         end if

         oFile:Skip()

      end while

      /*
      Creamos los registros nuevos---------------------------------------------
      */

      for each aCampos in ::aRegistros

         /*
         Campos obligatorios de la cabecera de la factura-------------------
         */

         if Empty( aCampos[ ::oFacPrvT:FieldPos( "cSerFac" ) ] )
            aCampos[ ::oFacPrvT:FieldPos( "cSerFac" ) ]     := cNewSer( "nFacPrv", ::oDbfCount:cAlias )
         end if

         if Empty( aCampos[ ::oFacPrvT:FieldPos( "nNumFac" ) ] )
            aCampos[ ::oFacPrvT:FieldPos( "nNumFac" ) ]     := nNewDoc( aPlantilla[ ::oFacPrvT:FieldPos( "cSerFac" ) ], ::oFacPrvT:cAlias, "nFacPrv", , ::oDbfCount:cAlias )
         end if

         if Empty( aCampos[ ::oFacPrvT:FieldPos( "cSufFac" ) ] )
            aCampos[ ::oFacPrvT:FieldPos( "cSufFac" ) ]     := RetSufEmp()
         end if

         if Empty( aCampos[ ::oFacPrvT:FieldPos( "cTurFac" ) ] )
            aCampos[ ::oFacPrvT:FieldPos( "cTurFac" ) ]     := cCurSesion()
         end if

         if Empty( aCampos[ ::oFacPrvT:FieldPos( "cDivFac" ) ] )
            aCampos[ ::oFacPrvT:FieldPos( "cDivFac" ) ]     := cDivEmp()
         end if

         if Empty( aCampos[ ::oFacPrvT:FieldPos( "cCodAlm" ) ] )
            aCampos[ ::oFacPrvT:FieldPos( "cCodAlm" ) ]     := Application():codigoAlmacen()
         end if

         if Empty( aCampos[ ::oFacPrvT:FieldPos( "cCodCaj" ) ] )
            aCampos[ ::oFacPrvT:FieldPos( "cCodCaj" ) ]     := Application():CodigoCaja()
         end if

         if Empty( aCampos[ ::oFacPrvT:FieldPos( "nVdvFac" ) ] )
            aCampos[ ::oFacPrvT:FieldPos( "nVdvFac" ) ]     := nChgDiv( aPlantilla[ ::oFacPrvT:FieldPos( "cDivFac" ) ], ::oDbfDiv:cAlias )
         end if

         if Empty( aCampos[ ::oFacPrvT:FieldPos( "lSndDoc" ) ] )
            aCampos[ ::oFacPrvT:FieldPos( "lSndDoc" ) ]     := .t.
         end if

         if Empty( aCampos[ ::oFacPrvT:FieldPos( "cCodPro" ) ] )
            aCampos[ ::oFacPrvT:FieldPos( "cCodPro" ) ]     := cProCnt()
         end if

         if Empty( aCampos[ ::oFacPrvT:FieldPos( "cSufFac" ) ] )
            aCampos[ ::oFacPrvT:FieldPos( "cCodUsr" ) ]     := Auth():Codigo()
         end if

         if Empty( aCampos[ ::oFacPrvT:FieldPos( "cCodDlg" ) ] )
            aCampos[ ::oFacPrvT:FieldPos( "cCodDlg" ) ]     := Application():CodigoDelegacion()
         end if

         if Empty( aCampos[ ::oFacPrvT:FieldPos( "dFecFac" ) ] )
            aCampos[ ::oFacPrvT:FieldPos( "dFecFac" ) ]     := GetSysDate()
         end if

         /*
         Campos del proveedor--------------------------------------------------
         */

         if !Empty( aCampos[ ::oFacPrvT:FieldPos( "cCodPrv" ) ] ) .and. ::oDbfPrv:Seek( AllTrim( aCampos[ ::oFacPrvT:FieldPos( "cCodPrv" ) ] ), "Cod" )

            if Empty( aCampos[ ::oFacPrvT:FieldPos( "cNomPrv" ) ] )
               aCampos[ ::oFacPrvT:FieldPos( "cNomPrv"  ) ] := ::oDbfPrv:Titulo
            end if

            if Empty( aCampos[ ::oFacPrvT:FieldPos( "cDirPrv" ) ] )
               aCampos[ ::oFacPrvT:FieldPos( "cDirPrv"  ) ] := ::oDbfPrv:Domicilio
            end if

            if Empty( aCampos[ ::oFacPrvT:FieldPos( "cPobPrv" ) ] )
               aCampos[ ::oFacPrvT:FieldPos( "cPobPrv"  ) ] := ::oDbfPrv:Poblacion
            end if

            if Empty( aCampos[ ::oFacPrvT:FieldPos( "cProvProv" ) ] )
               aCampos[ ::oFacPrvT:FieldPos( "cProvProv") ] := ::oDbfPrv:Provincia
            end if

            if Empty( aCampos[ ::oFacPrvT:FieldPos( "cPosPrv" ) ] )
               aCampos[ ::oFacPrvT:FieldPos( "cPosPrv"  ) ] := ::oDbfPrv:CodPostal
            end if

            if Empty( aCampos[ ::oFacPrvT:FieldPos( "cDniPrv" ) ] )
               aCampos[ ::oFacPrvT:FieldPos( "cDniPrv"  ) ] := ::oDbfPrv:Nif
            end if

            if Empty( aCampos[ ::oFacPrvT:FieldPos( "cCodPago" ) ] )
               aCampos[ ::oFacPrvT:FieldPos( "cCodPago" ) ] := ::oDbfPrv:FPago
            end if

         end if

         ::oFacPrvT:Append()

         for i:= 1 to len( aCampos )
            ::oFacPrvT:FieldPut( i, aCampos[ i ] )
         next

         ::oRecTreeImportacion   := ::oTreeImportacion:Add( "Factura de proveedor " + Alltrim( aCampos[ 1 ] ) + AllTrim( Str( aCampos[ 2 ] ) ) + AllTrim( aCampos[ 3 ] ) + " añadida a la base de datos.", 1, {|| EdtFacPrv( aCampos[ 1 ] + Str( aCampos[ 2 ] ) + aCampos[ 3 ] ) } )

         ::oTreeImportacion:Select( ::oRecTreeImportacion )

      next

   case cTipo == "Factura proveedores.Líneas"

      ::oRecTreeImportacion                        := ::oTreeImportacion:Add( "Procesando lineas de facturas de proveedor", 0, nil )

      ::oTreeImportacion:Select( ::oRecTreeImportacion )

      /*
      Recorremos el fichero y guardamos los valores----------------------------
      */

      while !oFile:lEoF()

         aPlantilla                 := Array( Len( ::aCamposCabecera ) )

         for each aCampos in ::aCamposDetalle

            nPos                    := aScan( ::aCamposCabecera, {| a | Upper( a[ 5 ] ) == Upper( AllTrim( aCampos:cCampo ) ) } )

            if aCampos:nTipo != 2
               aPlantilla[ nPos ]   := ::DataToType( SubStr( oFile:cLine, aCampos:nInicio, aCampos:nAncho ), aCampos:cCampo, .t. )
            else
               aPlantilla[ nPos ]   := ::DataToType( aCampos:uConst, aCampos:cCampo, .t. )
            end if

         next

         aAdd( ::aRegistros, aPlantilla )

         oFile:Skip()

      end while

      /*
      Creamos los registros nuevos---------------------------------------------
      */

      for each aCampos in ::aRegistros

         cCodArt                                         := Alltrim( aCampos[ ::oFacPrvL:FieldPos( "cRef" ) ] )

         nNumLin                                         := 1

         if !Empty( cCodArt ) .and. ::oDbfArt:SeekInOrd( cCodArt, "Codigo" )

            // ::oFacPrvT:SeekInOrd( Upper( AllTrim( aCampos[ ::oFacPrvL:FieldPos( "cSuPed" ) ] ) ), "cSuPed" )

            // ::oDbfArt:Load()

            /*
            Guardo los números de factura para generarle los pagos-------------
            */

            /*
            ::oFacPrvT:Load()
            aCampos[ ::oFacPrvL:FieldPos( "cSerFac" ) ]  := ::oFacPrvT:cSerFac
            aCampos[ ::oFacPrvL:FieldPos( "nNumFac" ) ]  := ::oFacPrvT:nNumFac
            aCampos[ ::oFacPrvL:FieldPos( "cSufFac" ) ]  := ::oFacPrvT:cSufFac
            */

            if Empty( aCampos[ ::oFacPrvL:FieldPos( "cAlmLin" ) ] )
               aCampos[ ::oFacPrvL:FieldPos( "cAlmLin" ) ]  := Application():codigoAlmacen()
            end if

            if Empty( aCampos[ ::oFacPrvL:FieldPos( "nIva" ) ] )
               aCampos[ ::oFacPrvL:FieldPos( "nIva"    ) ]  := nIva( AllTrim( ::oDbfIva:cAlias ), ::oDbfArt:TipoIva )
            end if

            if Empty( aCampos[ ::oFacPrvL:FieldPos( "nPreUnit" ) ] )
               aCampos[ ::oFacPrvL:FieldPos( "nPreUnit" ) ] := ::oDbfArt:pCosto
            end if

            if Empty( aCampos[ ::oFacPrvL:FieldPos( "nCtlStk" ) ] )
               aCampos[ ::oFacPrvL:FieldPos( "nCtlStk" ) ]  := ::oDbfArt:nCtlStock
            end if

            if Empty( aCampos[ ::oFacPrvL:FieldPos( "cCodFam" ) ] )
               aCampos[ ::oFacPrvL:FieldPos( "cCodFam" ) ]  := ::oDbfArt:Familia
            end if

            if Empty( aCampos[ ::oFacPrvL:FieldPos( "cGrpFam" ) ] )
               aCampos[ ::oFacPrvL:FieldPos( "cGrpFam" ) ]  := cGruFam( ::oDbfArt:Familia, ::oDbfFam:cAlias )
            end if

            if Empty( aCampos[ ::oFacPrvL:FieldPos( "nNumLin" ) ] )
               aCampos[ ::oFacPrvL:FieldPos( "nNumLin" ) ]  := nNumLin
            end if

            if Empty( aCampos[ ::oFacPrvL:FieldPos( "nPreCom" ) ] )
               aCampos[ ::oFacPrvL:FieldPos( "nPreCom" ) ]  := ::oDbfArt:pCosto
            end if

            ::oRecTreeImportacion                           := ::oTreeImportacion:Add( "Artículo " + AllTrim( cCodArt ) + " añadido a la factura de proveedor " + Alltrim( aCampos[ 1 ] ) + "/" + AllTrim( Str( aCampos[ 2 ] ) ) + "/" + AllTrim( aCampos[ 3 ] ) + " añadida a la base de datos.", 1, {|| EdtFacPrv( aCampos[ 1 ] + Str( aCampos[ 2 ] ) + aCampos[ 3 ] ) } )
            ::oTreeImportacion:Select( ::oRecTreeImportacion )

            nNumLin++

         else

            ::oTreeImportacion:Select( ::oTreeImportacion:Add( "Código de artículo " + cCodArt + " no encontrado." ) )

         end if

         /*
         ::oFacPrvL:Append()

         for i := 1 to len( aCampos )
            ::oFacPrvL:FieldPut( i, aCampos[ i ] )
         next
         */

      next


      /*
      Generamos los pagos y refrescamos el estado------------------------------
      */

   case cTipo == "Recibos facturas proveedor"
   case cTipo == "Presupuesto clientes"
   case cTipo == "Pedido clientes"
   case cTipo == "Albarán clientes"
   case cTipo == "Factura clientes"
   case cTipo == "Factura de anticipos"
   case cTipo == "Factura rectificativa"
   case cTipo == "Recibos facturas clientes"
   case cTipo == "Tickets clientes"
   case cTipo == "Pagos de clientes"

   end case

Return ( .t. )

//---------------------------------------------------------------------------//

Method aCampoClave() Class TPlantillaXML

   local aCampos
   local aCampoClave

   for each aCampos in ::aCamposDetalle

      if aCampos:lClave
         aCampoClave                         := aCampos
      end if

   next

Return aCampoClave

//---------------------------------------------------------------------------//

Method lFindCampoClave( oFile ) Class TPlantillaXML

   local nPos
   local lFind          := .f.
   local aCampos
   local uNuevo
   local aCampoClave    := ::aCampoClave()

   nPos                 := aScan( ::aCamposCabecera, {| a | Upper( a[ 5 ] ) == Upper( AllTrim( aCampoClave:cCampo ) ) } )
   uNuevo               := SubStr( oFile:cLine, aCampoClave:nInicio, aCampoClave:nAncho )

   if !Empty( AllTrim( uNuevo ) )

      for each aCampos in ::aRegistros

         if Upper( AllTrim( uNuevo ) ) == Upper( AllTrim( aCampos[ nPos ] ) )
             lFind    := .t.
         end if

      next

   end if

Return lFind

//---------------------------------------------------------------------------//

METHOD CreateRegister() CLASS TPlantillaXML

   local a
   local oBlock
   local oError
   local aCampos
   local cCodArt     := ""
   local nNumLin     := 1
   local cTipo       := Rtrim( ::oDbf:cTipo )
   local aFacturas   := {}
   local cFactura    := ""
   local aTotFac     := {}

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   do case
      case cTipo == "Artículo"

         for each aCampos in ::aRegistros

            cCodArt  := ""

            /*
            Si nos rellena el campo de proveedor y referencia de proveedor, lo usamos como campo clave
            */

            if Empty( aCampos[ ::oDbfArt:FieldPos( "Codigo" ), 9 ] )

               if !Empty( aCampos[ ::oDbfArt:FieldPos( "cPrvHab" ), 9 ] )  .and.;
                  !Empty( aCampos[ ::oDbfArt:FieldPos( "cRefPrv" ), 9 ] )

                  if ::oArtPrv:SeekInOrd( aCampos[ ::oDbfArt:FieldPos( "cPrvHab" ), 9 ] + aCampos[ ::oDbfArt:FieldPos( "cRefPrv" ), 9 ], "cRefPrv" )
                     cCodArt  := ::oArtPrv:cCodArt
                  end if

               end if

            else

               cCodArt        := aCampos[ ::oDbfArt:FieldPos( "Codigo" ), 9 ]

            end if

            /*
            Introducimos el artículo-------------------------------------------
            */

            if !Empty( cCodArt ) .and. ValType( cCodArt ) != "C"

               ::oTreeImportacion:Add( "El valor obtenido de la clave principal no es valido." )

            else

               if !Empty( cCodArt )                       .and.;
                  ::oDbfArt:SeekInOrd( cCodArt, "Codigo" )

                  for each a in aCampos
                     ::oDbfArt:FieldPut( hb_EnumIndex(), a[ 9 ] )
                  next

                  ::oRecTreeImportacion   := ::oTreeImportacion:Add( "Código de artículo " + Rtrim( cCodArt ) + " reemplazado en la base de datos.", 1, bGenEdtArticulo( cCodArt ) )

                  ::oTreeImportacion:Select( ::oRecTreeImportacion )

               else

                  if Empty( cCodArt )
                     cCodArt              := NextKey( dbLast( ::oDbfArt:cAlias ), ::oDbfArt:cAlias )
                     aCampos[ 1,9 ]       := cCodArt
                  end if

                  ::oDbfArt:Append()

                  for each a in aCampos
                     ::oDbfArt:FieldPut( hb_EnumIndex(), a[ 9 ] )
                  next

                  ::oRecTreeImportacion   := ::oTreeImportacion:Add( "Código de artículo " + Rtrim( cCodArt ) + " añadido a la base de datos.", 1, bGenEdtArticulo( cCodArt ) )

                  ::oTreeImportacion:Select( ::oRecTreeImportacion )

               end if

            end if

            /*
            Artículo nuevo, metemos la refeencia de proveedor en su tabla------
            */

            if !Empty( aCampos[ ::oDbfArt:FieldPos( "cPrvHab" ), 9 ] )  .and.;
               !Empty( aCampos[ ::oDbfArt:FieldPos( "cRefPrv" ), 9 ] )  .and.;
               !::oArtPrv:SeekInOrd( aCampos[ ::oDbfArt:FieldPos( "cPrvHab" ), 9 ] + aCampos[ ::oDbfArt:FieldPos( "cRefPrv" ), 9 ], "cRefPrv" )

               ::oArtPrv:Append()

               ::oArtPrv:cCodArt  := cCodArt
               ::oArtPrv:cCodPrv  := aCampos[ ::oDbfArt:FieldPos( "cPrvHab" ), 9 ]
               ::oArtPrv:cRefPrv  := aCampos[ ::oDbfArt:FieldPos( "cRefPrv" ), 9 ]
               ::oArtPrv:lDefPrv  := .t.

               ::oArtPrv:Save()

            end if

         next

      case cTipo == "Artículo. Codigos de barras"

         for each aCampos in ::aRegistros

            /*
            Buscamos por referencia de proveedor-------------------------------
            */

            if Empty( aCampos[ ::oDbfArtCod:FieldPos( "cCodArt" ), 9 ] )

               if !Empty( aCampos[ ::oDbfArtCod:FieldPos( "cPrvHab" ), 9 ] )  .and.;
                  !Empty( aCampos[ ::oDbfArtCod:FieldPos( "cRefPrv" ), 9 ] )

                  if ::oArtPrv:SeekInOrd( aCampos[ ::oDbfArtCod:FieldPos( "cPrvHab" ), 9 ] + aCampos[ ::oDbfArtCod:FieldPos( "cRefPrv" ), 9 ], "cRefPrv" )
                     aCampos[ ::oDbfArtCod:FieldPos( "cCodArt" ), 9 ]  := ::oArtPrv:cCodArt
                  end if

               end if

            end if

            if ValType( aCampos[ ::oDbfArtCod:FieldPos( "cCodArt" ), 9 ] ) != "C" .or. ;
               ValType( aCampos[ ::oDbfArtCod:FieldPos( "cCodBar" ), 9 ] ) != "C"

               if !Empty( ::oRecTreeImportacion )
                  ::oRecTreeImportacion:Add( "El valor obtenido de la clave principal no es valido." )
               else
                  ::oTreeImportacion:Select( ::oTreeImportacion:Add( "El valor obtenido de la clave principal no es valido." ) )
               end if

            else

               if ::oDbfArtCod:SeekInOrd( Padr( aCampos[ ::oDbfArtCod:FieldPos( "cCodArt" ), 9 ], 18 ) + Padr( aCampos[ ::oDbfArtCod:FieldPos( "cCodBar" ), 9 ], 20 ), "cArtBar" )

                  if !Empty( ::oRecTreeImportacion )
                     ::oRecTreeImportacion:Add( "El valor obtenido de la clave principal no es valido." )
                  else
                     ::oTreeImportacion:Add( "Código de barras " + Rtrim( aCampos[ ::oDbfArtCod:FieldPos( "cCodBar" ), 9 ] ) + " del artículo " + Rtrim( aCampos[ ::oDbfArtCod:FieldPos( "cCodArt" ), 9 ] ) + " ya existe.", 1, bGenEdtArticulo( aCampos[ ::oDbfArtCod:FieldPos( "cCodArt" ), 9 ] ) )
                  end if

                  for each a in aCampos

                     if !Empty( a[ 9 ] ) .and. ::oDbfArtCod:FieldGet( hb_EnumIndex() ) != a[ 9 ]
                        ::oDbfArtCod:FieldPut( hb_EnumIndex(), a[ 9 ] )
                     end if

                  next

               else

                  ::oDbfArtCod:Append()

                  for each a in aCampos
                     ::oDbfArtCod:FieldPut( hb_EnumIndex(), a[ 9 ] )
                  next

                  if !Empty( ::oRecTreeImportacion )
                     ::oRecTreeImportacion:Add( "Código de barras " + Rtrim( aCampos[ ::oDbfArtCod:FieldPos( "cCodBar" ), 9 ] ) + " del artículo " + Rtrim( aCampos[ ::oDbfArtCod:FieldPos( "cCodArt" ), 9 ] ) + " añadido a la base de datos.", 1, bGenEdtArticulo( aCampos[ ::oDbfArtCod:FieldPos( "cCodArt" ), 9 ] ) )
                  else
                     ::oTreeImportacion:Add( "Código de barras " + Rtrim( aCampos[ ::oDbfArtCod:FieldPos( "cCodBar" ), 9 ] ) + " del artículo " + Rtrim( aCampos[ ::oDbfArtCod:FieldPos( "cCodArt" ), 9 ] ) + " añadido a la base de datos.", 1, bGenEdtArticulo( aCampos[ ::oDbfArtCod:FieldPos( "cCodArt" ), 9 ] ) )
                  end if

               end if

            end if

         next

      case cTipo == "Pedido proveedores"
      case cTipo == "Albarán proveedores"

      case cTipo == "Factura proveedores"

         for each aCampos in ::aRegistros

            if ValType( aCampos[ ::oFacPrvT:FieldPos( "cSerFac" ), 9 ] ) != "C"  .or. ;
               ValType( aCampos[ ::oFacPrvT:FieldPos( "nNumFac" ), 9 ] ) != "N"

               ::oTreeImportacion:Add( "El valor obtenido de la clave principal no es valido." )

            else

               /*
               Rellenamos los campos claves que estén vacíos-------------------
               */

               if Empty( aCampos[ ::oFacPrvT:FieldPos( "cSerFac" ), 9 ] )
                  aCampos[ ::oFacPrvT:FieldPos( "cSerFac" ), 9 ]     := cNewSer( "nFacPrv", ::oDbfCount:cAlias )
               end if

               if aCampos[ ::oFacPrvT:FieldPos( "nNumFac" ), 9 ] == 0
                  aCampos[ ::oFacPrvT:FieldPos( "nNumFac" ), 9 ]     := nNewDoc( aCampos[ ::oFacPrvT:FieldPos( "cSerFac" ) ], ::oFacPrvT:cAlias, "nFacPrv", , ::oDbfCount:cAlias )
               end if

               if Empty( aCampos[ ::oFacPrvT:FieldPos( "cSufFac" ), 9 ] )
                  aCampos[ ::oFacPrvT:FieldPos( "cSufFac" ), 9 ]     := RetSufEmp()
               end if

               if Empty( aCampos[ ::oFacPrvT:FieldPos( "cTurFac" ), 9 ] )
                  aCampos[ ::oFacPrvT:FieldPos( "cTurFac" ), 9 ]     := cCurSesion()
               end if

               if Empty( aCampos[ ::oFacPrvT:FieldPos( "cDivFac" ), 9 ] )
                  aCampos[ ::oFacPrvT:FieldPos( "cDivFac" ), 9 ]     := cDivEmp()
               end if

               if Empty( aCampos[ ::oFacPrvT:FieldPos( "cCodAlm" ), 9 ] )
                  aCampos[ ::oFacPrvT:FieldPos( "cCodAlm" ), 9 ]     := Application():codigoAlmacen()
               end if

               if Empty( aCampos[ ::oFacPrvT:FieldPos( "cCodCaj" ), 9 ] )
                  aCampos[ ::oFacPrvT:FieldPos( "cCodCaj" ), 9 ]     := Application():CodigoCaja()
               end if

               if Empty( aCampos[ ::oFacPrvT:FieldPos( "lSndDoc" ), 9 ] )
                  aCampos[ ::oFacPrvT:FieldPos( "lSndDoc" ), 9 ]     := .t.
               end if

               if Empty( aCampos[ ::oFacPrvT:FieldPos( "cCodPro" ), 9 ] )
                  aCampos[ ::oFacPrvT:FieldPos( "cCodPro" ), 9 ]     := cProCnt()
               end if

               if Empty( aCampos[ ::oFacPrvT:FieldPos( "cSufFac" ), 9 ] )
                  aCampos[ ::oFacPrvT:FieldPos( "cCodUsr" ), 9 ]     := Auth():Codigo()
               end if

               if Empty( aCampos[ ::oFacPrvT:FieldPos( "cCodDlg" ), 9 ] )
                  aCampos[ ::oFacPrvT:FieldPos( "cCodDlg" ), 9 ]     := Application():CodigoDelegacion()
               end if

               if Empty( aCampos[ ::oFacPrvT:FieldPos( "dFecFac" ), 9 ] )
                  aCampos[ ::oFacPrvT:FieldPos( "dFecFac" ), 9 ]     := GetSysDate()
               end if

               /*
               Campos del proveedor--------------------------------------------------
               */

               if !Empty( aCampos[ ::oFacPrvT:FieldPos( "cCodPrv" ), 9 ] ) .and. ::oDbfPrv:Seek( AllTrim( aCampos[ ::oFacPrvT:FieldPos( "cCodPrv" ), 9 ] ), "Cod" )

                  if Empty( aCampos[ ::oFacPrvT:FieldPos( "cNomPrv" ), 9 ] )
                     aCampos[ ::oFacPrvT:FieldPos( "cNomPrv"  ), 9 ] := ::oDbfPrv:Titulo
                  end if

                  if Empty( aCampos[ ::oFacPrvT:FieldPos( "cDirPrv" ), 9 ] )
                     aCampos[ ::oFacPrvT:FieldPos( "cDirPrv"  ), 9 ] := ::oDbfPrv:Domicilio
                  end if

                  if Empty( aCampos[ ::oFacPrvT:FieldPos( "cPobPrv" ), 9 ] )
                     aCampos[ ::oFacPrvT:FieldPos( "cPobPrv"  ), 9 ] := ::oDbfPrv:Poblacion
                  end if

                  if Empty( aCampos[ ::oFacPrvT:FieldPos( "cProvProv" ), 9 ] )
                     aCampos[ ::oFacPrvT:FieldPos( "cProvProv" ), 9 ] := ::oDbfPrv:Provincia
                  end if

                  if Empty( aCampos[ ::oFacPrvT:FieldPos( "cPosPrv" ), 9 ] )
                     aCampos[ ::oFacPrvT:FieldPos( "cPosPrv"  ), 9 ] := ::oDbfPrv:CodPostal
                  end if

                  if Empty( aCampos[ ::oFacPrvT:FieldPos( "cDniPrv" ), 9 ] )
                     aCampos[ ::oFacPrvT:FieldPos( "cDniPrv"  ), 9 ] := ::oDbfPrv:Nif
                  end if

                  if Empty( aCampos[ ::oFacPrvT:FieldPos( "cCodPago" ), 9 ] )
                     aCampos[ ::oFacPrvT:FieldPos( "cCodPago" ), 9 ] := ::oDbfPrv:FPago
                  end if

               end if

               /*
               Empezamos a meter los datos-------------------------------------
               */

               if ::oFacPrvT:SeekInOrd( aCampos[ ::oFacPrvT:FieldPos( "cSerFac" ), 9 ] + Str( aCampos[ ::oFacPrvT:FieldPos( "nNumFac" ), 9 ], 9 ) + aCampos[ ::oFacPrvT:FieldPos( "cSufFac" ), 9 ], "nNumFac" )

                  for each a in aCampos
                     ::oFacPrvT:FieldPut( hb_EnumIndex(), a[ 9 ] )
                  next

                  ::oRecTreeImportacion   := ::oTreeImportacion:Add( "Factura de proveedores " + Alltrim( aCampos[ ::oFacPrvT:FieldPos( "cSerFac" ), 9 ] + "/" + Str( aCampos[ ::oFacPrvT:FieldPos( "nNumFac" ), 9 ] ) + "/" + aCampos[ ::oFacPrvT:FieldPos( "cSufFac" ), 9 ] ) + " reemplazado en la base de datos.", 1, bGenEdtFacPrv( aCampos[ ::oFacPrvT:FieldPos( "cSerFac" ), 9 ] + Str( aCampos[ ::oFacPrvT:FieldPos( "nNumFac" ), 9 ], 9 ) + aCampos[ ::oFacPrvT:FieldPos( "cSufFac" ), 9 ] ) )

                  ::oTreeImportacion:Select( ::oRecTreeImportacion )

               else

                  ::oFacPrvT:Append()

                  for each a in aCampos
                     ::oFacPrvT:FieldPut( hb_EnumIndex(), a[ 9 ] )
                  next

                  ::oRecTreeImportacion   := ::oTreeImportacion:Add( "Factura de proveedores " + Rtrim( aCampos[ ::oFacPrvT:FieldPos( "cSerFac" ), 9 ] + "/" + Str( aCampos[ ::oFacPrvT:FieldPos( "nNumFac" ), 9 ] ) + "/" + aCampos[ ::oFacPrvT:FieldPos( "cSufFac" ), 9 ] ) + " añadido a la base de datos.", 1, bGenEdtFacPrv( aCampos[ ::oFacPrvT:FieldPos( "cSerFac" ), 9 ] + Str( aCampos[ ::oFacPrvT:FieldPos( "nNumFac" ), 9 ], 9 ) + aCampos[ ::oFacPrvT:FieldPos( "cSufFac" ), 9 ] ) )

                  ::oTreeImportacion:Select( ::oRecTreeImportacion )

               end if

               /*
               Borramos todas las lineas de esta factura-----------------------
               */

               while ::oFacPrvL:SeekInOrd( aCampos[ ::oFacPrvT:FieldPos( "cSerFac" ), 9 ] + Str( aCampos[ ::oFacPrvT:FieldPos( "nNumFac" ), 9 ], 9 ) + aCampos[ ::oFacPrvT:FieldPos( "cSufFac" ), 9 ], "nNumFac" ) .and. !::oFacPrvL:eof()
                  ::oFacPrvL:Delete(.f.)
               end while

            end if

         next

      case cTipo == "Factura proveedores.Líneas"

         for each aCampos in ::aRegistros

            /*
            Buscamos por referencia de proveedor-------------------------------
            */

            if Empty( aCampos[ ::oFacPrvL:FieldPos( "cRef" ), 9 ] )

               if !Empty( aCampos[ ::oFacPrvL:FieldPos( "cCodPrv" ), 9 ] ) .and. !Empty( aCampos[ ::oFacPrvL:FieldPos( "cRefPrv" ), 9 ] )

                  if ::oArtPrv:SeekInOrd( aCampos[ ::oFacPrvL:FieldPos( "cCodPrv" ), 9 ] + aCampos[ ::oFacPrvL:FieldPos( "cRefPrv" ), 9 ], "cRefPrv" )
                     aCampos[ ::oFacPrvL:FieldPos( "cRef" ), 9 ]  := ::oArtPrv:cCodArt
                  end if

               end if

            end if

            if ValType( aCampos[ ::oFacPrvL:FieldPos( "cSerFac" ), 9 ] ) != "C"  .or.;
               ValType( aCampos[ ::oFacPrvL:FieldPos( "nNumFac" ), 9 ] ) != "N"  .or.;
               ValType( aCampos[ ::oFacPrvL:FieldPos( "cRef"    ), 9 ] ) != "C"

               if !Empty( ::oRecTreeImportacion )
                  ::oRecTreeImportacion:Add( "El valor obtenido de la clave principal no es valido." )
               else
                  ::oTreeImportacion:Select( ::oTreeImportacion:Add( "El valor obtenido de la clave principal no es valido." ) )
               end if

            else

               /*
               Guardamos los numeros de las facturas que vamos metiendo--------
               */

               if aScan( aFacturas, aCampos[ ::oFacPrvL:FieldPos( "cSerFac" ), 9 ] + Str( aCampos[ ::oFacPrvL:FieldPos( "nNumFac" ), 9 ], 9 ) + Space(2) ) == 0
                  aAdd( aFacturas, aCampos[ ::oFacPrvL:FieldPos( "cSerFac" ), 9 ] + Str( aCampos[ ::oFacPrvL:FieldPos( "nNumFac" ), 9 ], 9 ) + Space(2) )
               end if

               /*
               Esto es solo para Zemtrum---------------------------------------
               */

               if ( IsChar( aCampos[ ::oFacPrvL:FieldPos( "cRefPrv" ), 9 ] ) )                     .and.;
                  ( ::oFacPrvL:SeekInOrd( aCampos[ ::oFacPrvL:FieldPos( "cSerFac" ), 9 ]              + ;
                                          Str( aCampos[ ::oFacPrvL:FieldPos( "nNumFac" ), 9 ], 9 )    + ;
                                          Space( 2 )                                                  + ;
                                          aCampos[ ::oFacPrvL:FieldPos( "cRef" ), 9 ]                 + ;
                                          aCampos[ ::oFacPrvL:FieldPos( "cRefPrv" ), 9 ] ,;
                                          "cRefPrv" ) )

                  if !Empty( ::oTreeImportacion )
                     ::oTreeImportacion:Add( "Lineas de facturas " + Rtrim( aCampos[ ::oFacPrvL:FieldPos( "cRef" ), 9 ] ) + " de factura de proveedores ya existe.", 1 )
                  end if

                  for each a in aCampos
                     if !Empty( a[ 9 ] ) .and. ::oFacPrvL:FieldGet( hb_EnumIndex() ) != a[ 9 ]
                        ::oFacPrvL:FieldPut( hb_EnumIndex(), a[ 9 ] )
                     end if
                  next

               else

                  /*
                  Obtenemos los campos de la base de datos---------------------
                  */

                  if !Empty( aCampos[ ::oFacPrvL:FieldPos( "cRef" ), 9 ] ) .and. ::oDbfArt:SeekInOrd( aCampos[ ::oFacPrvL:FieldPos( "cRef" ), 9 ], "Codigo" )

                     if Empty( aCampos[ ::oFacPrvL:FieldPos( "cAlmLin" ), 9 ] )
                        aCampos[ ::oFacPrvL:FieldPos( "cAlmLin" ), 9 ]  := Application():codigoAlmacen()
                     end if

                     if Empty( aCampos[ ::oFacPrvL:FieldPos( "nIva" ), 9 ] )
                        aCampos[ ::oFacPrvL:FieldPos( "nIva"    ), 9 ]  := nIva( AllTrim( ::oDbfIva:cAlias ), ::oDbfArt:TipoIva )
                     end if

                     if Empty( aCampos[ ::oFacPrvL:FieldPos( "nPreUnit" ), 9 ] )
                        aCampos[ ::oFacPrvL:FieldPos( "nPreUnit" ), 9 ] := ::oDbfArt:pCosto
                     end if

                     if Empty( aCampos[ ::oFacPrvL:FieldPos( "nCtlStk" ), 9 ] )
                        aCampos[ ::oFacPrvL:FieldPos( "nCtlStk" ), 9 ]  := ::oDbfArt:nCtlStock
                     end if

                     if Empty( aCampos[ ::oFacPrvL:FieldPos( "cCodFam" ), 9 ] )
                        aCampos[ ::oFacPrvL:FieldPos( "cCodFam" ), 9 ]  := ::oDbfArt:Familia
                     end if

                     if Empty( aCampos[ ::oFacPrvL:FieldPos( "cGrpFam" ), 9 ] )
                        aCampos[ ::oFacPrvL:FieldPos( "cGrpFam" ), 9 ]  := cGruFam( ::oDbfArt:Familia, ::oDbfFam:cAlias )
                     end if

                     if Empty( aCampos[ ::oFacPrvL:FieldPos( "nNumLin" ), 9 ] )
                        aCampos[ ::oFacPrvL:FieldPos( "nNumLin" ), 9 ]  := nNumLin
                     end if

                     if Empty( aCampos[ ::oFacPrvL:FieldPos( "nPreCom" ), 9 ] )
                        aCampos[ ::oFacPrvL:FieldPos( "nPreCom" ), 9 ]  := ::oDbfArt:pCosto
                     end if

                     nNumLin++

                  else

                     if !Empty( ::oTreeImportacion )
                        ::oTreeImportacion:Select( ::oTreeImportacion:Add( "Código de artículo " + Alltrim( aCampos[ ::oFacPrvL:FieldPos( "cRef" ), 9 ] ) + " no encontrado." ) )
                     end if

                  end if

                  /*
                  Añade linea a la factura de proveedor------------------------
                  */

                  ::oFacPrvL:Append()

                  for each a in aCampos
                     ::oFacPrvL:FieldPut( hb_EnumIndex(), a[ 9 ] )
                  next

                  if !Empty( ::oTreeImportacion )
                     ::oTreeImportacion:Add( "Lineas de facturas " + Rtrim( aCampos[ ::oFacPrvL:FieldPos( "cRef" ), 9 ] ) + " de factura de proveedores añadida.", 1 )
                  end if

               end if

            end if

         next

         /*
         Calculo de totales de la factura--------------------------------------
         */

         if Len( aFacturas ) != 0

            for each cFactura in aFacturas

               if ::oFacPrvT:SeekInOrd( cFactura, "nNumFac" )

                  aTotFac                 := aTotFacPrv( cFactura, ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oFacPrvP:cAlias )

                  ::oFacPrvT:Load()

                  ::oFacPrvT:nTotNet := aTotFac[1]
                  ::oFacPrvT:nTotIva := aTotFac[2]
                  ::oFacPrvT:nTotReq := aTotFac[3]
                  ::oFacPrvT:nTotFac := aTotFac[4]

                  ::oFacPrvT:Save()

               end if

            next

         end if

      case cTipo == "Recibos facturas proveedor"
      case cTipo == "Presupuesto clientes"
      case cTipo == "Pedido clientes"

         ::aCamposCabecera   := aItmPedCli()

      case cTipo == "Albarán clientes"
      case cTipo == "Factura clientes"
      case cTipo == "Factura de anticipos"
      case cTipo == "Factura rectificativa"
      case cTipo == "Recibos facturas clientes"
      case cTipo == "Tickets clientes"
      case cTipo == "Pagos de clientes"
   end case

   RECOVER USING oError

      msgStop( "Error al crear registro." + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD FindIterator() CLASS TPlantillaXML

   local oNode
   local cPath
   local cData          := ""
   local nIter          := 0
   local oIterator
   local cNode
   local nOcurrency
   local lOcurrency

   cNode                := Rtrim( ::oDetCabeceraPlantillaXML:oDbf:mNode )
   nOcurrency           := ::oDetCabeceraPlantillaXML:oDbf:nOcurr
   lOcurrency           := ::oDetCabeceraPlantillaXML:oDbf:lOcurr

   if ( nOcurrency == 0 )
      nOcurrency        := 1
   end if

   if lOcurrency
      nOcurrency        := ++::nSearchOcurrency
   end if

   oNode                := ::oXmlDocument:oRoot

   oIterator            := TXmlIterator():New( oNode )

   while oNode != nil

      cPath             := Rtrim( cValTochar( oNode:Path() ) )

      // ::oTreeImportacion:Add( "Proceso : " + cValTochar( oNode:Path() ) + ":" + cValToChar( oNode:cData ) )

      if ( cNode $ cPath )

         /*
         if !Empty( oNode )
            ::oTreeImportacion:Add( "Child string : " + cValTochar( oNode:ToString() ) )
            ::oTreeImportacion:Add( "Child data : " + cValTochar( oNode:cData ) )
         end if
         */

         nIter++

         if ( nOcurrency == nIter )

            Return ( oNode )

            /*
            cData       := cValToChar( oNode:cData ) // oNode:ToString() //
            */

         end if

      end if

      oNode             := oIterator:Next()

      // ::oTreeImportacion:Add( "Node : " + Valtype( oNode ) )

   end while

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD AdoFindIterator() CLASS TPlantillaXML

   local c
   local nCol
   local nRow
   local cCond
   local aNode
   local cNode
   local nRows
   local nCols
   local nOcurrency
   local lOcurrency
   local cData          := ""
   local nColSelect     := 0
   local cIterator      := ""
   local lCompile       := .f.

   cNode                := Rtrim( ::oDetCabeceraPlantillaXML:oDbf:mNode )
   cCond                := Rtrim( ::oDetCabeceraPlantillaXML:oDbf:mCond )
   nOcurrency           := ::oDetCabeceraPlantillaXML:oDbf:nOcurr
   lOcurrency           := ::oDetCabeceraPlantillaXML:oDbf:lOcurr

   aNode                := hb_aTokens( cNode, ";" )

   lCompile             := len( aNode ) > 1

   for each c in aNode

      nColSelect                 := ::DataToColumn( c )

      if nColSelect != 0

         // Lo busca en todo el fichero-------------------------------------------

         if ::lMultipleImportacion

            cNode                := ::oActiveSheet:Cells( ::nRowSelected, nColSelect ):Value

            if !Empty( cNode ) .and. ( Empty( cCond ) .or. ::EvalCondition( cCond, ::nRowSelected ) )

               if lCompile
                  cIterator      += cValToChar( cNode )
               else
                  cIterator      := cNode
               end if

            end if

         else

            for nRow := 2 to ::nActiveSheetRows

               cNode             := ::oActiveSheet:Cells( nRow, nColSelect ):Value

               if !Empty( cNode ) .and. ( Empty( cCond ) .or. ::EvalCondition( cCond, nRow ) )

                  if lCompile
                     cIterator   += cValToChar( cNode )
                  else
                     cIterator   := cNode
                  end if

                  exit

               end if

            next

         end if

      else

         if lCompile
            cIterator            += c
         end if

      end if

   next

   if lCompile
      cIterator                  := Eval( Compile( cIterator ) )
   end if

Return ( cIterator )

//---------------------------------------------------------------------------//

METHOD EvalCondition( cCond, nRow ) CLASS TPlantillaXML

   local cData
   local cValue
   local cColumn
   local lCondition     := .f.
   local nColSelect     := 0
   local nStart         := At( "<", cCond )
   local nEnd           := At( ">", cCond )

   if nStart != 0 .and. nEnd != 0

      cData             := SubStr( cCond, nStart - 1, ( nEnd - nStart ) + 1 )

      cColumn           := SubStr( cCond, nStart + 1, ( nEnd - nStart ) - 1 )

      nColSelect        := ::DataToColumn( cColumn )

      if nColSelect != 0

         cValue         := ::oActiveSheet:Cells( nRow, nColSelect ):Value
         cValue         := '"' + cValue + '"'
         cValue         := StrTran( cCond, cData, cValue )

         if Empty( cValue ) .or. At( Type( cValue ), "UEUI" ) != 0
            msgStop( "Expresión " + Rtrim( cValue ) + " no valida" )
            lCondition  := .f.
         else
            cValue      := Compile( cValue )
         end if

         if !Empty( cValue )
            lCondition  := Eval( cValue )
         end if

      end if

   end if

// Return ( .t. )

Return ( lCondition )

//---------------------------------------------------------------------------//

METHOD DataToColumn( cData ) CLASS TPlantillaXML

   local nCol
   local nColSelect     := 0

   for nCol := 1 to ::nActiveSheetColumns

      if Alltrim( cData ) == Alltrim( ::oActiveSheet:Cells( 1, nCol ):Value )
         nColSelect     := nCol
      end if
   next

RETURN ( nColSelect )

//---------------------------------------------------------------------------//

METHOD DataToValue( cData ) CLASS TPlantillaXML

   local nValue

   nValue                  := aScan( ::oDetCabeceraPlantillaXML:aValues, {|a| Upper( Alltrim( cValToChar( a[ 1 ] ) ) ) == Upper( Alltrim( cValToChar( cData ) ) ) } )
   if nValue != 0
      cData                := ::oDetCabeceraPlantillaXML:aValues[ nValue, 2 ]
   end if

RETURN ( cData )

//---------------------------------------------------------------------------//

METHOD DataToField( cData, cField ) CLASS TPlantillaXML

   local nScan
   local nValue

   nScan                      := aScan( ::aCamposCabecera, {| a | Upper( a[ 5 ] ) == Upper( cField ) } )
   if nScan != 0

      cData                   := ::DataToValue( cData )

      if !Empty( ::bPreAssign )
         cData                := Eval( ::bPreAssign, cData )
      end if

      ::DataToType( cData, cField )

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Comprueba si existe alguna condicion que evaluar y la evalua
*/

METHOD PostEvalData( cData ) CLASS TPlantillaXML

   local cCondition  := ::oDetCabeceraPlantillaXML:oDbf:mPost

   if !Empty( cCondition )

      cCondition     := CompileParam( cCondition )

      if !Empty( cCondition )
         cData       := Eval( cCondition, cData )
      end if

   end if

return ( cData )

//---------------------------------------------------------------------------//
/*
Devuelve la data obtnida ajustandose al tipo de datos del campo
*/

METHOD DataToType( cData, cField, lReturn ) CLASS TPlantillaXML

   local nLen
   local cType
   local nScan
   local nPos

   DEFAULT lReturn            := .f.

   cData                      := ::PostEvalData( cData )

   nScan                      := aScan( ::aCamposCabecera, {| a | Upper( a[ 5 ] ) == AllTrim( Upper( cField ) ) } )
   if nScan != 0

      cType                   := ::aCamposCabecera[ nScan, 2 ]
      nLen                    := ::aCamposCabecera[ nScan, 3 ]

      do case
         case cType == "C"

            if !IsChar( cData )
               cData          := Alltrim( Str( Round( cData, 0 ) ) )
            end if

            cData             := Padr( AllTrim( cData ), nLen, " " )

         case cType == "D"

            if !IsDate( cData )
               cData          := Ctod( cData )
            end if

         case cType == "L"

            cData             := ( cData == "S" )

         case cType == "N"

            if !IsNum( cData )

               nPos           := At( ",", cData )

               if nPos != 0
                  cData       := Left( cData, nPos - 1 ) + "." + SubStr( cData, nPos + 1 )
               end if

               cData          := Val( cData )

            end if

      end case

      if !lReturn

         if !Empty( ::bPreAssign )
            cData                := Eval( ::bPreAssign, cData )
         end if

         //::aCamposCabecera[ nScan, 9 ]   := ::PostEvalData( cData )

         ::aCamposCabecera[ nScan, 9 ]   := cData

      end if

   end if

RETURN ( if( !lReturn, Self, cData ) )

//---------------------------------------------------------------------------//

METHOD SaveConfig() CLASS TPlantillaXML

   local cData
   local cPlantilla
   local cFichero

   cData                := ""

   if ::lGetConfigName()

      for each cPlantilla in ::aPlantilla
         cData          += cPlantilla[ 1 ] + ","
      next

      if ::oSav:Seek( Rtrim( Upper( ::cNameConfig ) ) )
         ::oSav:Load()
         ::oSav:cText   := ::cNameConfig
         ::oSav:cData   := cData
         ::oSav:Save()
      else
         ::oSav:Append()
         ::oSav:cText   := ::cNameConfig
         ::oSav:cData   := cData
         ::oSav:Save()
      end if

      ::lLoadButtons()

   end if

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD DeleteConfig() CLASS TPlantillaXML

   if ::oSav:Seek( Upper( ::cNameConfig ) )

      if SQLAjustableModel():getRolNoConfirmacionEliminacion( Auth():rolUuid() ) .or. ApoloMsgNoYes("¿ Desea eliminar la configuración " + CRLF + Rtrim( ::cNameConfig ) + " ?", "Confirme supresión" )

         ::oSav:Delete()

         ::lLoadButtons()

      end if

   else

      msgStop( "La configuración " + Rtrim( ::cNameConfig ) + " no se encuentra." )

   end if

Return ( .t. )

//---------------------------------------------------------------------------//

Method lGetConfigName() CLASS TPlantillaXML

   local oDlg

   ::lAllUser     := .t.

   DEFINE DIALOG oDlg RESOURCE "Nombre_Filtro" TITLE "Guardar conficuración de importación"

   REDEFINE GET ::cNameConfig ;
      ID       110 ;
      OF       oDlg

   REDEFINE CHECKBOX ::lAllUser ;
      ID       120 ;
      OF       oDlg

   REDEFINE BUTTON ;
      ID       IDOK ;
      OF       oDlg ;
      ACTION   ( if( ::lValidConfigName(), oDlg:end( IDOK ), ) )

   REDEFINE BUTTON ;
      ID       IDCANCEL ;
      OF       oDlg ;
      ACTION   ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

Return ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Method lValidConfigName() CLASS TPlantillaXML

   if Empty( ::cNameConfig )
      MsgStop( "El nombre de la configuración no puede estar vacia." )
      Return ( .f. )
   end if

Return ( .t. )

//---------------------------------------------------------------------------//

Method LoadConfig( cText ) CLASS TPlantillaXML

   local nPos
   local cData
   local cField

   if ::oSav:Seek( Upper( cText ) )

      cData          := Rtrim( ::oSav:cData )

      while ( nPos := At( ",", cData ) ) > 0

         if nPos != 0

            cField   := SubStr( cData, 1, nPos - 1 )
            cField   := Rtrim( cField )

            if ::oDbf:SeekInOrd( cField, "cCodigo" )
               aAdd( ::aPlantilla, { ::oDbf:cCodigo, ::oDbf:cDescrip, ::oDbf:cTipo } )
            end if

            ++nPos

            cData    := SubStr( cData, nPos )

         end if

      end while

      ::cNameConfig  := Padr( cText, 100 )

   else

      MsgStop( "Configuración " + cText + " no encontrada." )

   end if

Return ( Self )

//---------------------------------------------------------------------------//

Method lLoadButtons() CLASS TPlantillaXML

   local cText
   local bAction

   ::oBtnImportacion:DeleteBranches()

   ::oSav:GoTop()
   while !::oSav:eof()

      cText       := by( Rtrim( ::oSav:cText ) )
      bAction     := ::bAction( cText )

      ::oWndBrw:NewAt( "gc_flash_", , , bAction, cText, , , , , ::oBtnImportacion )

      ::oSav:Skip()

   end do

   ::oWndBrw:Refresh()

return nil

//---------------------------------------------------------------------------//

Method bAction( cText ) CLASS TPlantillaXML

   local bGen     := {|| ::Importacion( cText ) }

Return ( bGen )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TDetCabeceraPlantillaXML FROM TDet

   DATA  cMru     INIT "gc_industrial_robot_money_16"
   DATA  cBitmap  INIT Rgb( 197, 227, 9 )

   DATA  oCombo

   DATA  oBrwValues

   DATA  aCamposCabecera  INIT  {}

   DATA  aValues  INIT  {}

   METHOD OpenFiles( lExclusive )

   MESSAGE OpenService( lExclusive )   METHOD OpenFiles( lExclusive )

   METHOD CloseFiles()

   METHOD DefineFiles()

   METHOD Resource( nMode )

   METHOD lPreSave( oGet, nMode )

   METHOD SaveDetails()                INLINE ( ::oDbfVir:cCodigo := ::oParent:oDbf:cCodigo )

   METHOD InitResource()

   METHOD LoadValues()

   METHOD SaveValues()

   METHOD EditValues( lAppend )

   METHOD DeleteValues()

END CLASS

//----------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive ) CLASS TDetCabeceraPlantillaXML

   local lOpen             := .t.
   local oError
   local oBlock

   DEFAULT lExclusive      := .f.

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf            := ::DefineFiles()
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

      ::bOnPreSave         := {|| ::SaveDetails() }
      ::bOnPreSaveDetail   := {|| ::SaveDetails() }

      ::bOnPreAppend       := {|| ::LoadValues() }
      ::bOnPreEdit         := {|| ::LoadValues() }
      ::bOnPostSave        := {|| ::SaveValues() }

   RECOVER USING oError

      msgStop( "Imposible abrir las bases de datos detalle de fidelización." + CRLF + ErrorMessage( oError ) )

      ::CloseFiles()

      lOpen                := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TDetCabeceraPlantillaXML

   if !Empty( ::oDbf )
      ::oDbf:end()
   end if

   ::oDbf               := nil

RETURN .t.

//----------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cVia, lUniqueName, cFileName ) CLASS TDetCabeceraPlantillaXML

   local oDbf

   DEFAULT cPath        := ::cPath
   DEFAULT lUniqueName  := .f.
   DEFAULT cFileName    := "PlantillaXMLCabecera"
   DEFAULT cVia         := cDriver()

   if lUniqueName
      cFileName         := cGetNewFileName( cFileName, , , cPath )
   end if

   DEFINE TABLE oDbf FILE ( cFileName ) CLASS ( cFileName ) ALIAS "PltXMLCab" PATH ( cPath ) VIA ( cVia ) COMMENT "Cabecera de importación XML"

      FIELD NAME "cCodigo"    TYPE "C" LEN 03  DEC 0 COMMENT "Código"                        HIDE  OF oDbf
      FIELD NAME "nLinea"     TYPE "N" LEN 02  DEC 0 COMMENT "Línea"                         HIDE  OF oDbf
      FIELD NAME "cCampo"     TYPE "C" LEN 250 DEC 0 COMMENT "Campo"                               OF oDbf
      FIELD NAME "nTipo"      TYPE "N" LEN 01  DEC 0 COMMENT "Tipo"                          HIDE  OF oDbf
      FIELD NAME "cItem"      TYPE "C" LEN 250 DEC 0 COMMENT "Item"                          HIDE  OF oDbf
      FIELD NAME "mNode"      TYPE "M" LEN 10  DEC 0 COMMENT "Nodo"                                OF oDbf
      FIELD NAME "mCond"      TYPE "M" LEN 10  DEC 0 COMMENT "Condición"                           OF oDbf
      FIELD NAME "mValue"     TYPE "M" LEN 10  DEC 0 COMMENT "Valores de reemplazo"          HIDE  OF oDbf
      FIELD NAME "lOcurr"     TYPE "L" LEN 01  DEC 0 COMMENT "Registro nuevo por ocurrecia"  HIDE  OF oDbf
      FIELD NAME "nOcurr"     TYPE "N" LEN 06  DEC 0 COMMENT "Ocurrecia"                     HIDE  OF oDbf
      FIELD NAME "uConst"     TYPE "C" LEN 250 DEC 0 COMMENT "Constante"                     HIDE  OF oDbf
      FIELD NAME "lClave"     TYPE "L" LEN 01  DEC 0 COMMENT "Campo clave"                   HIDE  OF oDbf
      FIELD NAME "mPost"      TYPE "M" LEN 10  DEC 0 COMMENT "Post-Evaluación"               HIDE  OF oDbf

      INDEX TO ( cFileName )  TAG "cCodigo"  ON "cCodigo"                  NODELETED               OF oDbf
      INDEX TO ( cFileName )  TAG "nLinea"   ON "cCodigo + Str( nLinea )"  NODELETED               OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//----------------------------------------------------------------------------//

METHOD Resource( nMode ) CLASS TDetCabeceraPlantillaXML

	local oDlg

   ::InitResource()

   DEFINE DIALOG oDlg RESOURCE "DetPlantillaXML" TITLE LblTitle( nMode ) + "detalle de importación XML"

      REDEFINE COMBOBOX ::oCombo ;
         VAR      ::oDbfVir:cCampo ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ITEMS    ( ::aCamposCabecera );
         ID       100 ;
         OF       oDlg

      REDEFINE CHECKBOX ::oDbfVir:lClave ;
         ID       310 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE RADIO ::oDbfVir:nTipo ;
         ID       300, 301 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oDbfVir:mNode MEMO ;
         ID       110 ;
         WHEN     ( ::oDbfVir:nTipo == 1 .and. nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oDbfVir:mCond MEMO ;
         ID       140 ;
         WHEN     ( ::oDbfVir:nTipo == 1 .and. nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oDbfVir:mPost MEMO ;
         ID       150 ;
         WHEN     ( ::oDbfVir:nTipo == 1 .and. nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oDbfVir:nOcurr ;
         ID       120 ;
         PICTURE  "99" ;
         SPINNER ;
         MIN      0 ;
         WHEN     ( ::oDbfVir:nTipo == 1 .and. nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE CHECKBOX ::oDbfVir:lOcurr ;
         ID       130 ;
         WHEN     ( ::oDbfVir:nTipo == 1 .and. nMode != ZOOM_MODE ) ;
         OF       oDlg

      /*
      Browse de los rangos----------------------------------------------------------
      */

      ::oBrwValues                  := IXBrowse():New( oDlg )

      ::oBrwValues:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrwValues:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oBrwValues:lHScroll         := .f.
      ::oBrwValues:lRecordSelector  := .t.

      ::oBrwValues:nMarqueeStyle    := 6

      ::oBrwValues:SetArray( ::aValues, , , .f. )

      if ( ::oDbfVir:nTipo == 1 .and. nMode != ZOOM_MODE )
         ::oBrwValues:bLDblClick    := {|| ::EditValues( .f. ) }
      end if

      with object ( ::oBrwValues:addCol() )
         :cHeader       := "Contiene"
         :bEditValue    := {|| ::aValues[ ::oBrwValues:nArrayAt, 1 ] }
         :nWidth        := 180
      end with

      with object ( ::oBrwValues:addCol() )
         :cHeader       := "Cambiar por"
         :bEditValue    := {|| ::aValues[ ::oBrwValues:nArrayAt, 2 ] }
         :nWidth        := 180
      end with

      ::oBrwValues:CreateFromResource( 200 )

		REDEFINE BUTTON ;
         ID       210 ;
			OF 		oDlg ;
         WHEN     ( ::oDbfVir:nTipo == 1 .and. nMode != ZOOM_MODE ) ;
         ACTION   ( ::EditValues( .t. ) )

      REDEFINE BUTTON ;
         ID       220 ;
			OF 		oDlg ;
         WHEN     ( ::oDbfVir:nTipo == 1 .and. nMode != ZOOM_MODE ) ;
         ACTION   ( ::EditValues( .f. ) )

      REDEFINE BUTTON ;
         ID       230 ;
			OF 		oDlg ;
         WHEN     ( ::oDbfVir:nTipo == 1 .and. nMode != ZOOM_MODE ) ;
         ACTION   ( ::DeleteValues() )

      REDEFINE GET ::oDbfVir:uConst ;
         ID       400 ;
         WHEN     ( ::oDbfVir:nTipo == 2 .and. nMode != ZOOM_MODE ) ;
         OF       oDlg

      /*
      Botones -----------------------------------------------------------------
      */

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( if( ::lPreSave( nMode ), oDlg:end( IDOK ), ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
			ACTION 	( oDlg:end() )

      if nMode != ZOOM_MODE
         oDlg:AddFastKey( VK_F5, {|| if( ::lPreSave( nMode ), oDlg:end( IDOK ), ) } )
      end if

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD lPreSave( nMode ) CLASS TDetCabeceraPlantillaXML

   if Empty( ::oDbfVir:cCampo )
      MsgStop( "El campo a cumplimentar no puede estar vacio." )
      return .f.
   end if

   if ::oDbfVir:nTipo == 1 .and. Empty( ::oDbfVir:mNode )
      MsgStop( "El valor del nodo no puede estar vacio." )
      return .f.
   end if

   if ::oDbfVir:nTipo == 2 .and. Empty( ::oDbfVir:uConst )
      MsgStop( "El valor de la constante no puede estar vacio." )
      return .f.
   end if

Return .t.

//---------------------------------------------------------------------------//

METHOD InitResource() CLASS TDetCabeceraPlantillaXML

   local cCampo
   local cTipo          := Rtrim( ::oParent:oDbf:cTipo )

   ::aCamposCabecera    := {}

   for each cCampo in ::oParent:aCamposCabecera
      if !Empty( cCampo[ 5 ] )
         aAdd( ::aCamposCabecera, cCampo[ 5 ] )
      end if
   next

   do case
      case cTipo == "Artículo"

      case cTipo == "Pedido proveedores"
      case cTipo == "Albarán proveedores"
      case cTipo == "Factura proveedores"
      case cTipo == "Factura proveedores.Líneas"
      case cTipo == "Recibos facturas proveedor"
      case cTipo == "Presupuesto clientes"

      case cTipo == "Pedido clientes"

      case cTipo == "Albarán clientes"
      case cTipo == "Factura clientes"
      case cTipo == "Factura de anticipos"
      case cTipo == "Factura rectificativa"
      case cTipo == "Recibos facturas clientes"
      case cTipo == "Tickets clientes"
      case cTipo == "Pagos de clientes"
   end case

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD LoadValues( mValue ) CLASS TDetCabeceraPlantillaXML

   local a
   local aTokens

   DEFAULT mValue    := ::oDbfVir:mValue

   ::aValues         := {}

   aTokens           := hb_aTokens( mValue, ";", .f., .f. )

   for each a in aTokens
      aAdd( ::aValues, hb_aTokens( a, ",", .f., .f. ) )
   next

Return ( ::aValues )

//----------------------------------------------------------------------------//

METHOD SaveValues() CLASS TDetCabeceraPlantillaXML

   local a
   local cValues     := ""

   for each a in ::aValues
      cValues        += a[ 1 ] + "," + a[ 2 ] + ";"
   next

   ::oDbfVir:mValue  := cValues

Return ( Self )

//----------------------------------------------------------------------------//

METHOD EditValues( lAppend ) CLASS TDetCabeceraPlantillaXML

   local oDlg
   local cContiene
   local cReemplaza

   DEFAULT lAppend   := .f.

   if lAppend
      cContiene      := Space( 250 )
      cReemplaza     := Space( 250 )
   else
      cContiene      := Padr( ::aValues[ ::oBrwValues:nArrayAt, 1 ], 250 )
      cReemplaza     := Padr( ::aValues[ ::oBrwValues:nArrayAt, 2 ], 250 )
   end if

   DEFINE DIALOG oDlg RESOURCE "ValuesPlantillaXML"

      REDEFINE GET cContiene MEMO ;
         ID       110 ;
         OF       oDlg

      REDEFINE GET cReemplaza MEMO ;
         ID       120 ;
         OF       oDlg

      /*
      Botones -----------------------------------------------------------------
      */

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         ACTION   ( oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
			ACTION 	( oDlg:end() )

      REDEFINE BUTTON ;
         ID       559 ;
			OF 		oDlg ;
         ACTION   ( MsgInfo( "Ayuda no definida" ) )

      oDlg:AddFastKey( VK_F5, {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK
      if lAppend
         aAdd( ::aValues, { cContiene, cReemplaza } )
      else
         ::aValues[ ::oBrwValues:nArrayAt, 1 ]  := cContiene
         ::aValues[ ::oBrwValues:nArrayAt, 2 ]  := cReemplaza
      end if
   end if

   ::oBrwValues:Refresh()

RETURN ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//

METHOD DeleteValues() CLASS TDetCabeceraPlantillaXML

   aDel( ::aValues, ::oBrwValues:nArrayAt, .t. )

   ::oBrwValues:Refresh()

Return ( Self )

//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//

CLASS sCamposLineas

   Data  cCampo
   Data  nTipo
   Data  nInicio
   Data  nAncho
   Data  uConst
   Data  lClave

END CLASS

//----------------------------------------------------------------------------//
/*
#include "HbXml.ch"

Function ImportaXmlBestseller()

   local cXml
   local oNode
   local oXmlDocument := TXmlDocument():New( "C:/Users/Calero/Desktop/Des.xml" )

   if oXmlDocument:nStatus != HBXML_STATUS_OK

      switch oXml:nStatus
         case HBXML_STATUS_ERROR
            msgStop( "Ay! pillin, nos jorobo alguna cosa....!!" )
         case HBXML_STATUS_MALFORMED
            msgStop( "No es un documento xml" )
      end

   else

      oNode                := oXmlDocument:oRoot

      while !Empty( oNode )

      cXml                 := oNode:Path()
      
      if Empty( cXml )
         cXml              :=  "(Node without path)"
      end if 

      msgWait( Alltrim( Str( oNode:nType ) ) + "cName : " + oNode:cName + " aAttributes: " + ValToPrg( oNode:aAttributes ) + " cData: " + oNode:cData + " xml: " + cXml, , .5 )

      oNode                := oXmlDocument:Next()

      end while

   end if

Return nil

*/