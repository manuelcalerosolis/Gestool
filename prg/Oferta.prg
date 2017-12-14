#include "FiveWin.Ch"
#include "Font.ch"
#include "Report.ch"
#include "Factu.ch" 
#include "Xbrowse.ch"
#include "FastRepH.ch"

#define _CARTOFE     ( dbfOferta )->( FieldPos( "CARTOFE" ) )
#define _CDESOFE     ( dbfOferta )->( FieldPos( "CDESOFE" ) )
#define _DINIOFE     ( dbfOferta )->( FieldPos( "DINIOFE" ) )
#define _DFINOFE     ( dbfOferta )->( FieldPos( "DFINOFE" ) )
#define _NTIPOFE     ( dbfOferta )->( FieldPos( "NTIPOFE" ) )
#define _NMAXOFE     ( dbfOferta )->( FieldPos( "NMAXOFE" ) )
#define _NUDVOFE     ( dbfOferta )->( FieldPos( "NUDVOFE" ) )
#define _NPREOFE1    ( dbfOferta )->( FieldPos( "NPREOFE1") )
#define _NPREOFE2    ( dbfOferta )->( FieldPos( "NPREOFE2") )
#define _NPREOFE3    ( dbfOferta )->( FieldPos( "NPREOFE3") )
#define _NPREOFE4    ( dbfOferta )->( FieldPos( "NPREOFE4") )
#define _NPREOFE5    ( dbfOferta )->( FieldPos( "NPREOFE5") )
#define _NPREOFE6    ( dbfOferta )->( FieldPos( "NPREOFE6") )
#define _NPREIVA1    ( dbfOferta )->( FieldPos( "NPREIVA1") )
#define _NPREIVA2    ( dbfOferta )->( FieldPos( "NPREIVA2") )
#define _NPREIVA3    ( dbfOferta )->( FieldPos( "NPREIVA3") )
#define _NPREIVA4    ( dbfOferta )->( FieldPos( "NPREIVA4") )
#define _NPREIVA5    ( dbfOferta )->( FieldPos( "NPREIVA5") )
#define _NPREIVA6    ( dbfOferta )->( FieldPos( "NPREIVA6") )
#define _NUNVOFE     ( dbfOferta )->( FieldPos( "NUNVOFE" ) )
#define _NUNCOFE     ( dbfOferta )->( FieldPos( "NUNCOFE" ) )
#define _DFECCHG     ( dbfOferta )->( FieldPos( "DFECCHG" ) )
#define _NTIPXBY     ( dbfOferta )->( FieldPos( "NTIPXBY" ) )
#define _NCLIOFE     ( dbfOferta )->( FieldPos( "NCLIOFE" ) )
#define _CCLIOFE     ( dbfOferta )->( FieldPos( "CCLIOFE" ) )
#define _CGRPOFE     ( dbfOferta )->( FieldPos( "CGRPOFE" ) )
#define _NDTOPCT     ( dbfOferta )->( FieldPos( "NDTOPCT" ) )
#define _NDTOLIN     ( dbfOferta )->( FieldPos( "NDTOLIN" ) )
#define _CCODPR1     ( dbfOferta )->( FieldPos( "CCODPR1" ) )
#define _CCODPR2     ( dbfOferta )->( FieldPos( "CCODPR2" ) )
#define _CVALPR1     ( dbfOferta )->( FieldPos( "CVALPR1" ) )
#define _CVALPR2     ( dbfOferta )->( FieldPos( "CVALPR2" ) )
#define _LIVAINC     ( dbfOferta )->( FieldPos( "LIVAINC" ) )
#define _NUNDMIN     ( dbfOferta )->( FieldPos( "NUNDMIN" ) )
#define _NTBLOFE     ( dbfOferta )->( FieldPos( "NTBLOFE" ) )
#define _NCAJMIN     ( dbfOferta )->( FieldPos( "NCAJMIN" ) )
#define _NIMPMIN     ( dbfOferta )->( FieldPos( "NIMPMIN" ) )
#define _NMINCAN     ( dbfOferta )->( FieldPos( "NMINCAN" ) )
#define _NMINTIP     ( dbfOferta )->( FieldPos( "NMINTIP" ) )

static oWndBrw

static dbfOferta
static dbfArticulo
static dbfFamilia
static dbfTemporada
static dbfPro
static dbfTblPro
static dbfCodebar
static dbfDiv
static dbfIva
static dbfDoc
static dbfArtLbl
static dbfClient
static dbfArtKit
static dbfArtVta
static dbfPedCliL
static dbfAlbCliL
static dbfFacCliL
static dbfFacRecL
static dbfTikL
static dbfPedPrvL
static dbfAlbPrvL
static dbfFacPrvL
static dbfRctPrvL
static dbfProLin
static dbfProMat
static dbfHisMov

static aTipoOferta   := { "Artículos", "Familias", "Tipo de artículo", "Temporadas", "Fabricantes" }
static aBmpOferta    := { "gc_object_cube_16", "gc_cubes_16", "gc_objects_16", "gc_photographic_filters_16", "gc_cloud_sun_16", "gc_bolt_16" }

static oBandera

static oGrpCli
static oNewImp
static oUndMedicion
static oTipArt
static oFabricante

static oStock

static cPouDiv
static nDecDiv

static filOferta
static tmpOferta

static oBtnAnterior
static oBtnSiguiente
static oBtnCancelar

static lOpenFiles := .f.

static nLabels    := 1

static lEuro      := .f.
static bEdit      := { |aBlank, aoGet, dbfOferta, oBrw, bWhen, bValid, nMode, cCodArt | EdtRec( aBlank, aoGet, dbfOferta, oBrw, bWhen, bValid, nMode, cCodArt ) }

//----------------------------------------------------------------------------//
//Funciones del programa
//----------------------------------------------------------------------------//

STATIC FUNCTION OpenFiles()

   local oBlock
   local oError

   if lOpenFiles
      MsgStop( 'Imposible abrir ficheros de ofertas' )
      Return ( .f. )
   end if

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   lOpenFiles           := .t.

   USE ( cPatArt() + "OFERTA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "OFERTA", @dbfOferta ) )
   SET ADSINDEX TO ( cPatArt() + "OFERTA.CDX" ) ADDITIVE

   USE ( cPatArt() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
   SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

   USE ( cPatArt() + "FAMILIAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FAMILIAS", @dbfFamilia ) )
   SET ADSINDEX TO ( cPatArt() + "FAMILIAS.CDX" ) ADDITIVE

   USE ( cPatArt() + "PRO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PRO", @dbfPro ) )
   SET ADSINDEX TO ( cPatArt() + "PRO.CDX" ) ADDITIVE

   USE ( cPatArt() + "TBLPRO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TBLPRO", @dbfTblPro ) )
   SET ADSINDEX TO ( cPatArt() + "TBLPRO.CDX" ) ADDITIVE

   USE ( cPatArt() + "ArtCodebar.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CODEBAR", @dbfCodebar ) )
   SET ADSINDEX TO ( cPatArt() + "ArtCodebar.Cdx" ) ADDITIVE

   USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDiv ) )
   SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

   USE ( cPatCli() + "CLIENT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIENT", @dbfClient ) )
   SET ADSINDEX TO ( cPatCli() + "CLIENT.CDX" ) ADDITIVE

   USE ( cPatDat() + "TIVA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfIva ) )
   SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE

   USE ( cPatEmp() + "RDOCUMEN.DBF" ) NEW SHARED VIA ( cDriver() )ALIAS ( cCheckArea( "RDOCUMEN", @dbfDoc ) )
   SET ADSINDEX TO ( cPatEmp() + "RDOCUMEN.CDX" ) ADDITIVE
   SET TAG TO "CTIPO"

   USE ( cPatArt() + "ArtLbl.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ArtLbl", @dbfArtLbl ) )
   SET ADSINDEX TO ( cPatArt() + "ArtLbl.Cdx" ) ADDITIVE

   USE ( cPatArt() + "ARTKIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTTIK", @dbfArtKit ) )
   SET ADSINDEX TO ( cPatArt() + "ARTKIT.CDX" ) ADDITIVE

   USE ( cPatArt() + "ARTDIV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTDIV", @dbfArtVta ) )
   SET ADSINDEX TO ( cPatArt() + "ARTDIV.CDX" ) ADDITIVE

   USE ( cPatArt() + "Temporadas.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TEMPORADA", @dbfTemporada ) )
   SET ADSINDEX TO ( cPatArt() + "Temporadas.Cdx" ) ADDITIVE

   USE ( cPatEmp() + "PEDCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDCLIT", @dbfPedCliL ) )
   SET ADSINDEX TO ( cPatEmp() + "PEDCLIL.CDX" ) ADDITIVE

   USE ( cPatEmp() + "ALBCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIL", @dbfAlbCliL ) )
   SET ADSINDEX TO ( cPatEmp() + "ALBCLIL.CDX" ) ADDITIVE

   USE ( cPatEmp() + "FACCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIL", @dbfFacCliL ) )
   SET ADSINDEX TO ( cPatEmp() + "FACCLIL.CDX" ) ADDITIVE

   USE ( cPatEmp() + "FACRECL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACRECL", @dbfFacRecL ) )
   SET ADSINDEX TO ( cPatEmp() + "FACRECL.CDX" ) ADDITIVE

   USE ( cPatEmp() + "TIKEL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKEL", @dbfTikL ) )
   SET ADSINDEX TO ( cPatEmp() + "TIKEL.CDX" ) ADDITIVE

   USE ( cPatEmp() + "PEDPROVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PedPrvL", @dbfPedPrvL ) )
   SET ADSINDEX TO ( cPatEmp() + "PEDPROVL.CDX" ) ADDITIVE
   SET TAG TO "cRef"

   USE ( cPatEmp() + "ALBPROVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBPROVL", @dbfAlbPrvL ) )
   SET ADSINDEX TO ( cPatEmp() + "ALBPROVL.CDX" ) ADDITIVE

   USE ( cPatEmp() + "FACPRVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVL", @dbfFacPrvL ) )
   SET ADSINDEX TO ( cPatEmp() + "FACPRVL.CDX" ) ADDITIVE
   SET TAG TO "cRef"

   USE ( cPatEmp() + "RctPrvL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "RctPrvL", @dbfRctPrvL ) )
   SET ADSINDEX TO ( cPatEmp() + "RctPrvL.CDX" ) ADDITIVE
   SET TAG TO "cRef"

   USE ( cPatEmp() + "PROLIN.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROLIN", @dbfProLin ) )
   SET ADSINDEX TO ( cPatEmp() + "PROLIN.CDX" ) ADDITIVE
   SET TAG TO "cCodArt"

   USE ( cPatEmp() + "PROMAT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROMAT", @dbfProMat ) )
   SET ADSINDEX TO ( cPatEmp() + "PROMAT.CDX" ) ADDITIVE
   SET TAG TO "cCodArt"

   USE ( cPatEmp() + "HISMOV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "HISMOV", @dbfHisMov ) )
   SET ADSINDEX TO ( cPatEmp() + "HISMOV.CDX" ) ADDITIVE
   SET TAG TO "cRefMov"

   oBandera             := TBandera():New

   oStock            := TStock():Create( cPatEmp() )
   if !oStock:lOpenFiles()
      lOpenFiles     := .f.
   end if

   oGrpCli              := TGrpCli():Create()
   if !oGrpCli:OpenFiles()
      lOpenFiles        := .f.
   end if

   oNewImp              := TNewImp():Create( cPatEmp() )
   if !oNewImp:OpenFiles()
      lOpenFiles        := .f.
   end if

   oUndMedicion         := UniMedicion():Create( cPatEmp() )
   if !oUndMedicion:OpenFiles()
      lOpenFiles        := .f.
   end if

   oTipArt              := TTipArt():Create( cPatArt() )
   if !oTipArt:OpenFiles()
      lOpenFiles        := .f.
   end if

   oFabricante          := TFabricantes():Create( cPatArt() )
   if !oFabricante:OpenFiles()
      lOpenFiles        := .f.
   end if

   cPouDiv              := cPouDiv( cDivEmp(), dbfDiv )
   nDecDiv              := nDouDiv( cDivEmp(), dbfDiv )

   RECOVER USING oError

      lOpenFiles        := .f.
      msgStop( ErrorMessage( oError ), "Imposible abrir las bases de datos" )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpenFiles
      CloseFiles()
   end if

RETURN ( lOpenfiles )

//----------------------------------------------------------------------------//

Static Function CloseFiles()

   ( dbfOferta   )->( dbCloseArea() )
   ( dbfArticulo )->( dbCloseArea() )
   ( dbfDiv      )->( dbCloseArea() )
   ( dbfClient   )->( dbCloseArea() )
   ( dbfIva      )->( dbCloseArea() )
   ( dbfFamilia  )->( dbCloseArea() )
   ( dbfPro      )->( dbCloseArea() )
   ( dbfTblPro   )->( dbCloseArea() )

   if !Empty( dbfPedCliL ) .and. ( dbfPedCliL )->( Used() )
      ( dbfPedCliL )->( dbCloseArea() )
   end if

   if !Empty( dbfAlbCliL ) .and. ( dbfAlbCliL )->( Used() )
      ( dbfAlbCliL )->( dbCloseArea() )
   end if

   if !Empty( dbfFacCliL ) .and. ( dbfFacCliL )->( Used() )
      ( dbfFacCliL )->( dbCloseArea() )
   end if

   if !Empty( dbfFacRecL ) .and. ( dbfPedCliL )->( Used() )
      ( dbfFacRecL )->( dbCloseArea() )
   end if

   if !Empty( dbfTikL ) .and. ( dbfTikL )->( Used() )
      ( dbfTikL )->( dbCloseArea() )
   end if

   if !Empty( dbfPedPrvL ) .and. ( dbfPedPrvL )->( Used() )
      ( dbfPedPrvL )->( dbCloseArea() )
   end if

   if !Empty( dbfAlbPrvL ) .and. ( dbfAlbPrvL )->( Used() )
      ( dbfAlbPrvL )->( dbCloseArea() )
   end if

   if !Empty( dbfFacPrvL ) .and. ( dbfFacPrvL )->( Used() )
      ( dbfFacPrvL )->( dbCloseArea() )
   end if

   if !Empty( dbfRctPrvL ) .and. ( dbfRctPrvL )->( Used() )
      ( dbfRctPrvL )->( dbCloseArea() )
   end if

   if !Empty( dbfProLin ) .and. ( dbfProLin )->( Used() )
      ( dbfProLin )->( dbCloseArea() )
   end if

   if !Empty( dbfProMat ) .and. ( dbfProMat )->( Used() )
      ( dbfProMat )->( dbCloseArea() )
   end if

   if !Empty( dbfHisMov ) .and. ( dbfHisMov )->( Used() )
      ( dbfHisMov )->( dbCloseArea() )
   end if

   if !Empty( dbfTemporada ) .and. ( dbfTemporada )->( Used() )
      ( dbfTemporada )->( dbCloseArea() )
   end if

   if dbfArtVta != nil
      ( dbfArtVta )->( dbCloseArea() )
   end if

   if !Empty( dbfArtKit )
      ( dbfArtKit )->( dbCloseArea() )
   end if

   if !Empty( dbfArtLbl )
      ( dbfArtLbl )->( dbCloseArea() )
   end if

   if !Empty( dbfDoc )
      ( dbfDoc )->( dbCloseArea() )
   end if

   if dbfCodebar != nil
      ( dbfCodebar )->( dbCloseArea() )
   end if

   if !Empty( oGrpCli )
      oGrpCli:end()
   end if

   if !Empty( oNewImp )
      oNewImp:end()
   end if

   if !Empty( oUndMedicion )
      oUndMedicion:end()
   end if

   if !Empty( oTipArt )
      oTipArt:end()
   end if

   if !Empty( oFabricante )
      oFabricante:end()
   end if

   if !Empty( oStock )
      oStock:end()
   end if

   dbfArticulo    := nil
   dbfCodebar     := nil
   dbfOferta      := nil
   dbfDiv         := nil
   oBandera       := nil
   oGrpCli        := nil
   oNewImp        := nil
   dbfClient      := nil
   dbfIva         := nil
   dbfFamilia     := nil
   dbfTemporada   := nil
   dbfPro         := nil
   dbfTblPro      := nil
   dbfDoc         := nil

   oUndMedicion   := nil
   oStock         := nil
   oTipArt        := nil
   oFabricante    := nil

   dbfPedCliL     := nil
   dbfAlbCliL     := nil
   dbfFacCliL     := nil
   dbfFacRecL     := nil
   dbfTikL        := nil
   dbfPedPrvL     := nil
   dbfAlbPrvL     := nil
   dbfFacPrvL     := nil
   dbfRctPrvL     := nil
   dbfProLin      := nil
   dbfProMat      := nil
   dbfHisMov      := nil

   lOpenFiles     := .f.

   if oWndBrw != nil
      oWndBrw     := nil
   end if

RETURN ( .t. )

//----------------------------------------------------------------------------//

FUNCTION Oferta( oMenuItem, oWnd )

   local nLevel

   DEFAULT  oMenuItem   := "01020"
   DEFAULT  oWnd        := oWnd()

   if Empty( oWndBrw )

      /*
      Obtenemos el nivel de acceso
      */

      nLevel            := nLevelUsr( oMenuItem )

      if nAnd( nLevel, 1 ) != 0
         msgStop( "Acceso no permitido." )
         return nil
      end if

      /*
      Cerramos todas las ventanas
      */

      if oWnd != nil
         SysRefresh(); oWnd:CloseAll(); SysRefresh()
      end if

      /*
      Apertura de ficheros
      */

      if !OpenFiles()
         return nil
      end if

      /*
      Anotamos el movimiento para el navegador
      */

      AddMnuNext( "Ofertas", ProcName() )

      DEFINE SHELL oWndBrw FROM 0, 0 TO 22, 80 ;
         XBROWSE ;
         TITLE    "Ofertas" ;
         PROMPT   "Código",;
                  "Nombre",;
                  "Fecha inicio",;
                  "Fecha fin";
         MRU      "gc_star2_16";
         BITMAP   clrTopArchivos ;
         APPEND   ( WinAppRec( oWndBrw:oBrw, bEdit, dbfOferta, .f., cDefIva() ) );
         DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdit, dbfOferta, .f., cDefIva() ) );
         EDIT     ( WinEdtRec( oWndBrw:oBrw, bEdit, dbfOferta, .f., cDefIva() ) ) ;
         DELETE   ( dbDelRec(  oWndBrw:oBrw, dbfOferta ) ) ;
         ALIAS    ( dbfOferta ) ;
         LEVEL    nLevel ;
         OF       oWnd

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Origen"
         :bStrData         := {|| aTipoOferta[ Max( ( dbfOferta )->nTblOfe, 1 ) ] }
         :bBmpData         := {|| ( dbfOferta )->nTblOfe }
         :nWidth           := 110
         :AddResource( "gc_object_cube_16" )
         :AddResource( "gc_cubes_16" )
         :AddResource( "gc_objects_16" )
         :AddResource( "gc_photographic_filters_16" )
         :AddResource( "gc_cloud_sun_16" )
         :AddResource( "gc_bolt_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cArtOfe"
         :bEditValue       := {|| ( dbfOferta )->cArtOfe }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cDesOfe"
         :bEditValue       := {|| ( dbfOferta )->cDesOfe }
         :nWidth           := 170
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Fecha inicio"
         :cSortOrder       := "dIniOfe"
         :bEditValue       := {|| Dtoc( ( dbfOferta )->dIniOfe ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Fecha fin"
         :cSortOrder       := "dFinOfe"
         :bEditValue       := {|| Dtoc( ( dbfOferta )->dFinOfe ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "X*Y"
         :bStrData         := {|| Trans( ( dbfOferta )->nUnvOfe, "@E 999" ) + " x" + Trans( ( dbfOferta )->nUncOfe, "@E 999" ) }
         :nWidth           := 50
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar1", "Precio 1" )
         :bStrData         := {|| Trans( ( dbfOferta )->nPreOfe1, cPouDiv ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar2", "Precio 2" )
         :bStrData         := {|| Trans( ( dbfOferta )->nPreOfe2, cPouDiv ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar3", "Precio 3" )
         :bStrData         := {|| Trans( ( dbfOferta )->nPreOfe3, cPouDiv ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar4", "Precio 4" )
         :bStrData         := {|| Trans( ( dbfOferta )->nPreOfe4, cPouDiv ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar5", "Precio 5" )
         :bStrData         := {|| Trans( ( dbfOferta )->nPreOfe5, cPouDiv ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar6", "Precio 6" )
         :bStrData         := {|| Trans( ( dbfOferta )->nPreOfe6, cPouDiv ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Und. maximas"
         :bStrData         := {|| Trans( ( dbfOferta )->nMaxOfe, "@E 999,999" ) }
         :nWidth           := 60
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      oWndBrw:cHtmlHelp    := "Ofertas"

      oWndBrw:CreateXFromCode()

      DEFINE BTNSHELL RESOURCE "BUS" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:SearchSetFocus() ) ;
			TOOLTIP 	"(B)uscar" ;
         HOTKEY   "B"

      oWndBrw:AddSeaBar()

      DEFINE BTNSHELL RESOURCE "NEW" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( oWndBrw:RecAdd() );
			ON DROP	( oWndBrw:RecDup() );
			TOOLTIP 	"(A)ñadir";
         BEGIN GROUP;
         HOTKEY   "A" ;
         LEVEL    ACC_APPD

		DEFINE BTNSHELL RESOURCE "DUP" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( oWndBrw:RecDup() );
			TOOLTIP 	"(D)uplicar";
         HOTKEY   "D";
         LEVEL    ACC_APPD

		DEFINE BTNSHELL RESOURCE "EDIT" OF oWndBrw ;
			NOBORDER ;
			ACTION  	( oWndBrw:RecEdit() );
			TOOLTIP 	"(M)odificar";
         HOTKEY   "M";
         LEVEL    ACC_EDIT

		DEFINE BTNSHELL RESOURCE "ZOOM" OF oWndBrw ;
			NOBORDER ;
			ACTION  	( WinZooRec( oWndBrw:oBrw, bEdit, dbfOferta ) );
			TOOLTIP 	"(Z)oom";
         HOTKEY   "Z";
         LEVEL    ACC_ZOOM

		DEFINE BTNSHELL RESOURCE "DEL" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( oWndBrw:RecDel() );
         TOOLTIP  "(E)liminar";
         HOTKEY   "E" ;
         LEVEL    ACC_DELE

      DEFINE BTNSHELL RESOURCE "DEL" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( DelFecha() );
         TOOLTIP  "Eliminar (f)echas";
         HOTKEY   "F" ;
         LEVEL    ACC_DELE

      DEFINE BTNSHELL RESOURCE "IMP" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( TInfOfr():New( "Listado de ofertas" ):Play() ) ;
			TOOLTIP 	"(L)istado" ;
         HOTKEY   "L" ;
         LEVEL    ACC_IMPR

      DEFINE BTNSHELL RESOURCE "gc_portable_barcode_scanner_" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( TOfertaLabelGenerator():Create() ) ;
         TOOLTIP  "Eti(q)uetas" ;
         HOTKEY   "Q";
         LEVEL    ACC_IMPR

      DEFINE BTNSHELL RESOURCE "END" GROUP OF oWndBrw ;
			NOBORDER ;
			ACTION 	( oWndBrw:end() ) ;
			TOOLTIP 	"(S)alir" ;
			HOTKEY 	"S"

      ACTIVATE WINDOW oWndBrw VALID ( CloseFiles() )

	ELSE

		oWndBrw:SetFocus()

	END IF

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aBlank, aoGet, dbfOferta, oBrw, lIvaInc, cTipIva, nMode, cCodArt )

	local oDlg
   local oFld
   local oBmpPrimera
   local oBmpSegunda
   local oBmpTercera
   local oGetGrp
   local oGetCli
   local oSayPr1
   local oSayPr2
   local oSayVp1
   local oSayVp2
   local cSayPr1
   local cSayPr2
   local cSayVp1
   local cSayVp2
   local nValDiv           := 1
   local oSay              := Array( 6 )
   local cSay              := Array( 6 )
   local oGetPrc           := Array( 6 )
   local oSayPrc           := Array( 6 )
   local cGetGrp           := RetFld( aBlank[ _CGRPOFE ], oGrpCli:GetAlias() )
   local cGetCli           := RetFld( aBlank[ _CCLIOFE ], dbfClient )
   local lCodArt           := ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) .and. ( cCodArt != nil )
   local oTipoOferta
   local cTipoOferta

   DEFAULT cCodArt         := Space( 18 )

   if nMode != ZOOM_MODE .and. oUser():lNotCambiarPrecio()
      MsgStop( "No tiene autorización para añadir o modificar ofertas." )
      Return .f.
   end if

   if lCodArt .and. !( dbfArticulo )->( dbSeek( cCodArt ) )
      MsgStop( "Artículo no encontrado" )
      Return .f.
   end if

   do case
   case nMode == APPD_MODE

      aBlank[ _NTBLOFE ]   := 1
      aBlank[ _NUNVOFE ]   := 1
		aBlank[ _NUNCOFE ]	:= 1
      aBlank[ _CARTOFE ]   := cCodArt
      aBlank[ _DINIOFE ]   := Ctod( '' )
      aBlank[ _DFINOFE ]   := Ctod( '' )
      aBlank[ _DFECCHG ]   := Ctod( '' )
      cTipoOferta          := "Artículos"
      aBlank[ _LIVAINC ]   := lIvaInc

   otherwise

      cTipoOferta          := aTipoOferta[ Max( ( dbfOferta )->nTblOfe, 1 ) ]

      if !Empty( aBlank[ _CCODPR1 ] )
         cSayPr1           := retProp( aBlank[ _CCODPR1 ], dbfPro )
         cSayVp1           := retValProp( aBlank[ _CCODPR1 ] + aBlank[ _CVALPR1 ], dbfTblPro )
      end if

      if !Empty( aBlank[ _CCODPR2 ] )
         cSayPr2           := retProp( aBlank[ _CCODPR2 ], dbfPro )
         cSayVp2           := retValProp( aBlank[ _CCODPR2 ] + aBlank[ _CVALPR2 ], dbfTblPro )
      end if

   end case

   cPouDiv                 := cPouDiv( cDivEmp(), dbfDiv )

   DEFINE DIALOG oDlg RESOURCE "OFERTA_00" TITLE LblTitle( nMode ) + "ofertas"

      REDEFINE FOLDER oFld;
         ID       300 ;
         OF       oDlg ;
         PROMPT   "&Oferta",;
                  "&Tipificación",;
                  "&Condiciones" ;
         DIALOGS  "OFERTA_01",;
                  "OFERTA_03",;
                  "OFERTA_04"

      oFld:bChange   := {|| ChangeFolder( aBlank, aoGet, nMode, oFld ) }

      /*
      Primera caja de diálogo--------------------------------------------------
      */

      REDEFINE BITMAP oBmpPrimera ;
         ID       500 ;
         RESOURCE "gc_star2_48" ;
         TRANSPARENT ;
         OF       oFld:aDialogs[1]

      REDEFINE COMBOBOX oTipoOferta VAR cTipoOferta ;
         ID       100 ;
         OF       oFld:aDialogs[ 1 ] ;
         WHEN     ( nMode == APPD_MODE .and. Empty( cCodArt ) ) ;
         ITEMS    aTipoOferta;
         BITMAPS  aBmpOferta

         oTipoOferta:bChange    := {|| ChangeComboTipo( aoGet, aBlank, nValDiv, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oTipoOferta, cCodArt ) }

      REDEFINE GET aoGet[ _CARTOFE ] VAR aBlank[ _CARTOFE ];
         ID       110 ;
         PICTURE  "@!" ;
         WHEN     ( nMode != ZOOM_MODE .and. if( !Empty( cCodArt ), .f., ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) .and. cCodArt != nil ) ) ;
         VALID    ( loaArt( aoGet, aBlank, nValDiv, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2 ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwArticulo( aoGet[ _CARTOFE ], aoGet[ _CDESOFE ] ) ) ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

		REDEFINE GET aoGet[ _CDESOFE ] VAR aBlank[ _CDESOFE ];
         ID       111 ;
         PICTURE  "@S20" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE SAY oSayPr1 VAR cSayPr1;
         ID       888 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aoGet[ _CVALPR1 ] VAR aBlank[ _CVALPR1 ];
         ID       270 ;
			COLOR 	CLR_GET ;
         BITMAP   "LUPA" ;
         WHEN     ( nMode != ZOOM_MODE .and. aBlank[ _NTBLOFE ] == 1 ) ;
         ON HELP  ( brwPropiedadActual( aoGet[ _CVALPR1 ], oSayVp1, aBlank[ _CCODPR1 ] ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oSayVp1 VAR cSayVp1;
         ID       271 ;
         WHEN     .f. ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE SAY oSayPr2 VAR cSayPr2;
         ID       999 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aoGet[ _CVALPR2 ] VAR aBlank[ _CVALPR2 ];
         ID       280 ;
			COLOR 	CLR_GET ;
         BITMAP   "LUPA" ;
         WHEN     ( nMode != ZOOM_MODE .and. aBlank[ _NTBLOFE ] == 1 ) ;
         ON HELP  ( brwPropiedadActual( aoGet[ _CVALPR2 ], oSayVp2, aBlank[ _CCODPR2 ] ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oSayVp2 VAR cSayVp2;
         ID       281 ;
         WHEN     .f. ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      /*
      Segunda caja de diálogo--------------------------------------------------
      */

      REDEFINE GET aBlank[ _DINIOFE ] ;
			ID 		120 ;
			SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[1]

		REDEFINE GET aBlank[ _DFINOFE ] ;
			ID 		130 ;
			SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( if( aBlank[ _DINIOFE ] > aBlank[ _DFINOFE ], ( msgStop( "Fecha de finalización debe ser mayor o igual a inicio" ), .f. ), .t. ) );
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aBlank[ _DFECCHG ] ;
         ID       140 ;
			SPINNER ;
         WHEN     ( .F. ) ;
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE RADIO aBlank[ _NCLIOFE ] ;
         ID       150, 151, 152 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aoGet[ _CGRPOFE ] VAR aBlank[ _CGRPOFE ];
         WHEN     ( aBlank[ _NCLIOFE ] == 2 .AND. nMode != ZOOM_MODE ) ;
         PICTURE  "@!";
         ID       160 ;
			COLOR 	CLR_GET ;
         BITMAP   "LUPA" ;
         VALID    ( oGetGrp:cText( retFld( aBlank[ _CGRPOFE ], oGrpCli:GetAlias() ) ), .t. );
         ON HELP  ( oGrpCli:Buscar( aoGet[ _CGRPOFE ] ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oGetGrp VAR cGetGrp;
         WHEN     ( .f. ) ;
         PICTURE  "@!";
         ID       161 ;
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aoGet[ _CCLIOFE ] VAR aBlank[ _CCLIOFE ];
         WHEN     ( aBlank[ _NCLIOFE ] == 3 .AND. nMode != ZOOM_MODE ) ;
         PICTURE  "@!";
         ID       170 ;
			COLOR 	CLR_GET ;
         BITMAP   "LUPA" ;
         VALID    ( cClient( aoGet[ _CCLIOFE ], dbfClient, oGetCli ) );
         ON HELP  ( BrwClient( aoGet[ _CCLIOFE ], oGetCli, .f. ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET oGetCli VAR cGetCli;
         WHEN     ( .f. ) ;
         PICTURE  "@!";
         ID       171    ;
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[1]

      /*
      Primera caja de diálogo--------------------------------------------------
      */

      REDEFINE BITMAP oBmpSegunda ;
         ID       500 ;
         RESOURCE "gc_symbol_euro_48" ;
         TRANSPARENT ;
         OF       oFld:aDialogs[2]

      REDEFINE RADIO aoGet[ _NTIPOFE ] VAR aBlank[ _NTIPOFE ] ;
         ID       180, 181 ;
         WHEN     ( nMode != ZOOM_MODE );
         OF       oFld:aDialogs[2] ;

      /*
      " + cImp() + " INCLUIDO__________________________________________________
      */

      REDEFINE CHECKBOX aoGet[ _LIVAINC ] VAR aBlank[ _LIVAINC ] ;
         ID       182 ;
         WHEN     ( oTipoOferta:nAt == 1 .and. aBlank[ _NTIPOFE ] == 1 .AND. nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      /*
      Nombres de precios_______________________________________________________
      */

      REDEFINE SAY oSay[ 1 ] ID 300 OF oFld:aDialogs[2]
      REDEFINE SAY oSay[ 2 ] ID 301 OF oFld:aDialogs[2]
      REDEFINE SAY oSay[ 3 ] ID 302 OF oFld:aDialogs[2]
      REDEFINE SAY oSay[ 4 ] ID 303 OF oFld:aDialogs[2]
      REDEFINE SAY oSay[ 5 ] ID 304 OF oFld:aDialogs[2]
      REDEFINE SAY oSay[ 6 ] ID 305 OF oFld:aDialogs[2]

      /*
      Importe _________________________________________________________________
      */

      REDEFINE GET aoGet[ _NPREOFE1 ] VAR aBlank[ _NPREOFE1 ] ;
         ID       190 ;
         PICTURE  cPouDiv ;
         SPINNER ;
         WHEN     ( oTipoOferta:nAt == 1 .and. aBlank[ _NTIPOFE ] == 1 .AND. nMode != ZOOM_MODE ) ;
         ON CHANGE( CalIva( aBlank[ _NPREOFE1 ], aBlank[ _LIVAINC ], if( !Empty( cTipIva ) .and. oTipoOferta:nAt == 1, cTipIva, RetFld( aBlank[ _CARTOFE ], dbfArticulo, "TipoIva", "Codigo" ) ), ( dbfArticulo )->cCodImp, aoGet[ _NPREIVA1 ] ) );
         VALID    ( CalIva( aBlank[ _NPREOFE1 ], aBlank[ _LIVAINC ], if( !Empty( cTipIva ) .and. oTipoOferta:nAt == 1, cTipIva, RetFld( aBlank[ _CARTOFE ], dbfArticulo, "TipoIva", "Codigo" ) ), ( dbfArticulo )->cCodImp, aoGet[ _NPREIVA1 ] ) );
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aoGet[ _NPREOFE2 ] VAR aBlank[ _NPREOFE2 ] ;
         ID       191 ;
         PICTURE  cPouDiv ;
         SPINNER ;
         WHEN     ( oTipoOferta:nAt == 1 .and. aBlank[ _NTIPOFE ] == 1 .AND. nMode != ZOOM_MODE ) ;
         ON CHANGE( CalIva( aBlank[ _NPREOFE2 ], aBlank[ _LIVAINC ], if( !Empty( cTipIva ) .and. oTipoOferta:nAt == 1, cTipIva, RetFld( aBlank[ _CARTOFE ], dbfArticulo, "TipoIva", "Codigo" ) ), ( dbfArticulo )->cCodImp, aoGet[ _NPREIVA2 ] ) );
         VALID    ( CalIva( aBlank[ _NPREOFE2 ], aBlank[ _LIVAINC ], if( !Empty( cTipIva ) .and. oTipoOferta:nAt == 1, cTipIva, RetFld( aBlank[ _CARTOFE ], dbfArticulo, "TipoIva", "Codigo" ) ), ( dbfArticulo )->cCodImp, aoGet[ _NPREIVA2 ] ) );
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aoGet[ _NPREOFE3 ] VAR aBlank[ _NPREOFE3 ] ;
         ID       192 ;
         PICTURE  cPouDiv ;
         SPINNER ;
         WHEN     ( oTipoOferta:nAt == 1 .and. aBlank[ _NTIPOFE ] == 1 .AND. nMode != ZOOM_MODE ) ;
         ON CHANGE( CalIva( aBlank[ _NPREOFE3 ], aBlank[ _LIVAINC ], if( !Empty( cTipIva ) .and. oTipoOferta:nAt == 1, cTipIva, RetFld( aBlank[ _CARTOFE ], dbfArticulo, "TipoIva", "Codigo" ) ), ( dbfArticulo )->cCodImp, aoGet[ _NPREIVA3 ] ) );
         VALID    ( CalIva( aBlank[ _NPREOFE3 ], aBlank[ _LIVAINC ], if( !Empty( cTipIva ) .and. oTipoOferta:nAt == 1, cTipIva, RetFld( aBlank[ _CARTOFE ], dbfArticulo, "TipoIva", "Codigo" ) ), ( dbfArticulo )->cCodImp, aoGet[ _NPREIVA3 ] ) );
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aoGet[ _NPREOFE4 ] VAR aBlank[ _NPREOFE4 ] ;
         ID       193 ;
         PICTURE  cPouDiv ;
         SPINNER ;
         WHEN     ( oTipoOferta:nAt == 1 .and. aBlank[ _NTIPOFE ] == 1 .AND. nMode != ZOOM_MODE ) ;
         ON CHANGE( CalIva( aBlank[ _NPREOFE4 ], aBlank[ _LIVAINC ], if( !Empty( cTipIva ) .and. oTipoOferta:nAt == 1, cTipIva, RetFld( aBlank[ _CARTOFE ], dbfArticulo, "TipoIva", "Codigo" ) ), ( dbfArticulo )->cCodImp, aoGet[ _NPREIVA4 ] ) );
         VALID    ( CalIva( aBlank[ _NPREOFE4 ], aBlank[ _LIVAINC ], if( !Empty( cTipIva ) .and. oTipoOferta:nAt == 1, cTipIva, RetFld( aBlank[ _CARTOFE ], dbfArticulo, "TipoIva", "Codigo" ) ), ( dbfArticulo )->cCodImp, aoGet[ _NPREIVA4 ] ) );
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aoGet[ _NPREOFE5 ] VAR aBlank[ _NPREOFE5 ] ;
         ID       194 ;
         PICTURE  cPouDiv ;
         SPINNER ;
         WHEN     ( oTipoOferta:nAt == 1 .and. aBlank[ _NTIPOFE ] == 1 .AND. nMode != ZOOM_MODE ) ;
         ON CHANGE( CalIva( aBlank[ _NPREOFE5 ], aBlank[ _LIVAINC ], if( !Empty( cTipIva ) .and. oTipoOferta:nAt == 1, cTipIva, RetFld( aBlank[ _CARTOFE ], dbfArticulo, "TipoIva", "Codigo" ) ), ( dbfArticulo )->cCodImp, aoGet[ _NPREIVA5 ] ) );
         VALID    ( CalIva( aBlank[ _NPREOFE5 ], aBlank[ _LIVAINC ], if( !Empty( cTipIva ) .and. oTipoOferta:nAt == 1, cTipIva, RetFld( aBlank[ _CARTOFE ], dbfArticulo, "TipoIva", "Codigo" ) ), ( dbfArticulo )->cCodImp, aoGet[ _NPREIVA5 ] ) );
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aoGet[ _NPREOFE6 ] VAR aBlank[ _NPREOFE6 ] ;
         ID       195 ;
         PICTURE  cPouDiv ;
         WHEN     ( oTipoOferta:nAt == 1 .and. aBlank[ _NTIPOFE ] == 1 .AND. nMode != ZOOM_MODE ) ;
         ON CHANGE( CalIva( aBlank[ _NPREOFE6 ], aBlank[ _LIVAINC ], if( !Empty( cTipIva ) .and. oTipoOferta:nAt == 1, cTipIva, RetFld( aBlank[ _CARTOFE ], dbfArticulo, "TipoIva", "Codigo" ) ), ( dbfArticulo )->cCodImp, aoGet[ _NPREIVA6 ] ) );
         VALID    ( CalIva( aBlank[ _NPREOFE6 ], aBlank[ _LIVAINC ], if( !Empty( cTipIva ) .and. oTipoOferta:nAt == 1, cTipIva, RetFld( aBlank[ _CARTOFE ], dbfArticulo, "TipoIva", "Codigo" ) ), ( dbfArticulo )->cCodImp, aoGet[ _NPREIVA6 ] ) );
         SPINNER ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[2]

      /*
      Importe con " + cImp() + " incluido_________________________________________________
      */

      REDEFINE GET aoGet[ _NPREIVA1 ] VAR aBlank[ _NPREIVA1 ] ;
         ID       250 ;
         PICTURE  cPouDiv ;
         SPINNER ;
         WHEN     ( oTipoOferta:nAt == 1 .and. aBlank[ _NTIPOFE ] == 1 .AND. nMode != ZOOM_MODE ) ;
         ON CHANGE( CalBas( aBlank[ _NPREIVA1 ], aBlank[ _LIVAINC ], if( !Empty( cTipIva ) .and. oTipoOferta:nAt == 1, cTipIva, RetFld( aBlank[ _CARTOFE ], dbfArticulo, "TipoIva", "Codigo" ) ), ( dbfArticulo )->cCodImp, aoGet[ _NPREOFE1 ] ) );
         VALID    ( CalBas( aBlank[ _NPREIVA1 ], aBlank[ _LIVAINC ], if( !Empty( cTipIva ) .and. oTipoOferta:nAt == 1, cTipIva, RetFld( aBlank[ _CARTOFE ], dbfArticulo, "TipoIva", "Codigo" ) ), ( dbfArticulo )->cCodImp, aoGet[ _NPREOFE1 ] ) );
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aoGet[ _NPREIVA2 ] VAR aBlank[ _NPREIVA2 ] ;
         ID       251 ;
         PICTURE  cPouDiv ;
         SPINNER ;
         WHEN     ( oTipoOferta:nAt == 1 .and. aBlank[ _NTIPOFE ] == 1 .AND. nMode != ZOOM_MODE ) ;
         ON CHANGE( CalBas( aBlank[ _NPREIVA2 ], aBlank[ _LIVAINC ], if( !Empty( cTipIva ) .and. oTipoOferta:nAt == 1, cTipIva, RetFld( aBlank[ _CARTOFE ], dbfArticulo, "TipoIva", "Codigo" ) ), ( dbfArticulo )->cCodImp, aoGet[ _NPREOFE2 ] ) );
         VALID    ( CalBas( aBlank[ _NPREIVA2 ], aBlank[ _LIVAINC ], if( !Empty( cTipIva ) .and. oTipoOferta:nAt == 1, cTipIva, RetFld( aBlank[ _CARTOFE ], dbfArticulo, "TipoIva", "Codigo" ) ), ( dbfArticulo )->cCodImp, aoGet[ _NPREOFE2 ] ) );
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aoGet[ _NPREIVA3 ] VAR aBlank[ _NPREIVA3 ] ;
         ID       252 ;
         PICTURE  cPouDiv ;
         SPINNER ;
         WHEN     ( oTipoOferta:nAt == 1 .and. aBlank[ _NTIPOFE ] == 1 .AND. nMode != ZOOM_MODE ) ;
         ON CHANGE( CalBas( aBlank[ _NPREIVA3 ], aBlank[ _LIVAINC ], if( !Empty( cTipIva ) .and. oTipoOferta:nAt == 1, cTipIva, RetFld( aBlank[ _CARTOFE ], dbfArticulo, "TipoIva", "Codigo" ) ), ( dbfArticulo )->cCodImp, aoGet[ _NPREOFE3 ] ) );
         VALID    ( CalBas( aBlank[ _NPREIVA3 ], aBlank[ _LIVAINC ], if( !Empty( cTipIva ) .and. oTipoOferta:nAt == 1, cTipIva, RetFld( aBlank[ _CARTOFE ], dbfArticulo, "TipoIva", "Codigo" ) ), ( dbfArticulo )->cCodImp, aoGet[ _NPREOFE3 ] ) );
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aoGet[ _NPREIVA4 ] VAR aBlank[ _NPREIVA4 ] ;
         ID       253 ;
         PICTURE  cPouDiv ;
         SPINNER ;
         WHEN     ( oTipoOferta:nAt == 1 .and. aBlank[ _NTIPOFE ] == 1 .AND. nMode != ZOOM_MODE ) ;
         ON CHANGE( CalBas( aBlank[ _NPREIVA4 ], aBlank[ _LIVAINC ], if( !Empty( cTipIva ) .and. oTipoOferta:nAt == 1, cTipIva, RetFld( aBlank[ _CARTOFE ], dbfArticulo, "TipoIva", "Codigo" ) ), ( dbfArticulo )->cCodImp, aoGet[ _NPREOFE4 ] ) );
         VALID    ( CalBas( aBlank[ _NPREIVA4 ], aBlank[ _LIVAINC ], if( !Empty( cTipIva ) .and. oTipoOferta:nAt == 1, cTipIva, RetFld( aBlank[ _CARTOFE ], dbfArticulo, "TipoIva", "Codigo" ) ), ( dbfArticulo )->cCodImp, aoGet[ _NPREOFE4 ] ) );
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aoGet[ _NPREIVA5 ] VAR aBlank[ _NPREIVA5 ] ;
         ID       254 ;
         PICTURE  cPouDiv ;
         SPINNER ;
         WHEN     ( oTipoOferta:nAt == 1 .and. aBlank[ _NTIPOFE ] == 1 .AND. nMode != ZOOM_MODE ) ;
         ON CHANGE( CalBas( aBlank[ _NPREIVA5 ], aBlank[ _LIVAINC ], if( !Empty( cTipIva ) .and. oTipoOferta:nAt == 1, cTipIva, RetFld( aBlank[ _CARTOFE ], dbfArticulo, "TipoIva", "Codigo" ) ), ( dbfArticulo )->cCodImp, aoGet[ _NPREOFE5 ] ) );
         VALID    ( CalBas( aBlank[ _NPREIVA5 ], aBlank[ _LIVAINC ], if( !Empty( cTipIva ) .and. oTipoOferta:nAt == 1, cTipIva, RetFld( aBlank[ _CARTOFE ], dbfArticulo, "TipoIva", "Codigo" ) ), ( dbfArticulo )->cCodImp, aoGet[ _NPREOFE5 ] ) );
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aoGet[ _NPREIVA6 ] VAR aBlank[ _NPREIVA6 ] ;
         ID       255 ;
         PICTURE  cPouDiv ;
         WHEN     ( oTipoOferta:nAt == 1 .and. aBlank[ _NTIPOFE ] == 1 .AND. nMode != ZOOM_MODE  ) ;
         ON CHANGE( CalBas( aBlank[ _NPREIVA6 ], aBlank[ _LIVAINC ], if( !Empty( cTipIva ) .and. oTipoOferta:nAt == 1, cTipIva, RetFld( aBlank[ _CARTOFE ], dbfArticulo, "TipoIva", "Codigo" ) ), ( dbfArticulo )->cCodImp, aoGet[ _NPREOFE6 ] ) );
         VALID    ( CalBas( aBlank[ _NPREIVA6 ], aBlank[ _LIVAINC ], if( !Empty( cTipIva ) .and. oTipoOferta:nAt == 1, cTipIva, RetFld( aBlank[ _CARTOFE ], dbfArticulo, "TipoIva", "Codigo" ) ), ( dbfArticulo )->cCodImp, aoGet[ _NPREOFE6 ] ) );
         SPINNER ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[2]

      /*
      Descuento porcentual_____________________________________________________
		*/

      REDEFINE GET  aoGet[ _NDTOPCT ] VAR aBlank[ _NDTOPCT ] ;
         ID       200 ;
         PICTURE  "@E 99.99" ;
         SPINNER ;
         WHEN     ( aBlank[ _NTIPOFE ] == 1 .AND. nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      /*
      Descuento lineal_________________________________________________________
		*/

      REDEFINE GET  aoGet[ _NDTOLIN ] VAR aBlank[ _NDTOLIN ] ;
         ID       210 ;
         PICTURE  cPouDiv ;
         SPINNER ;
         WHEN     ( aBlank[ _NTIPOFE ] == 1 .AND. nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      /*
      Ofertas tipos X por Y____________________________________________________
		*/

      REDEFINE RADIO aBlank[ _NTIPXBY ] ;
         WHEN     ( aBlank[ _NTIPOFE ] == 2 .AND. nMode != ZOOM_MODE ) ;
         ID       220, 221 ;
         OF       oFld:aDialogs[2] ;

		REDEFINE GET aBlank[ _NUNVOFE ] ;
         ID       230 ;
			PICTURE	"@E 999" ;
			SPINNER ;
         WHEN     ( aBlank[ _NTIPOFE ] == 2 .AND. nMode != ZOOM_MODE ) ;
         VALID    ( isBig( aBlank[ _NUNVOFE ], aBlank[ _NUNCOFE ] ) ) ;
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[2]

		REDEFINE GET aBlank[ _NUNCOFE ] ;
         ID       240 ;
			PICTURE	"@E 999" ;
			SPINNER ;
         WHEN     ( aBlank[ _NTIPOFE ] == 2 .AND. nMode != ZOOM_MODE ) ;
         VALID    ( isBig( aBlank[ _NUNVOFE ], aBlank[ _NUNCOFE ] ) ) ;
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[2]

      /*
      Primera caja de diálogo--------------------------------------------------
      */

      REDEFINE BITMAP oBmpTercera ;
         ID       500 ;
         RESOURCE "gc_clipboard_check_edit_48" ;
         TRANSPARENT ;
         OF       oFld:aDialogs[3]

      /*
      Unidades minimas para aplicar la oferta__________________________________
      */

      REDEFINE RADIO aoGet[ _NMINCAN ] VAR aBlank[ _NMINCAN ] ;
         ID       100, 110 ;
         WHEN     ( aBlank[ _NTIPOFE ] == 1 .and. nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[3]

      REDEFINE GET  aoGet[ _NIMPMIN ] VAR aBlank[ _NIMPMIN ] ;
         ID       140 ;
         PICTURE  cPouDiv ;
         SPINNER ;
         WHEN     ( aBlank[ _NTIPOFE ] == 1 .and. aBlank[ _NMINCAN ] == 1 .and. nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[3]

      REDEFINE RADIO aoGet[ _NMINTIP ] VAR aBlank[ _NMINTIP ] ;
         ID       120, 130 ;
         WHEN     ( aBlank[ _NTIPOFE ] == 1 .and. aBlank[ _NMINCAN ] == 2 .and. nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[3]

      REDEFINE GET  aoGet[ _NCAJMIN ] VAR aBlank[ _NCAJMIN ] ;
         ID       150 ;
         PICTURE  MasUnd() ;
         SPINNER ;
         WHEN     ( aBlank[ _NTIPOFE ] == 1 .and. aBlank[ _NMINCAN ] == 2 .and. aBlank[ _NMINTIP ] == 1 .and. nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[3]

      REDEFINE GET  aoGet[ _NUNDMIN ] VAR aBlank[ _NUNDMIN ] ;
         ID       160 ;
         PICTURE  MasUnd() ;
         SPINNER ;
         WHEN     ( aBlank[ _NTIPOFE ] == 1 .and. aBlank[ _NMINCAN ] == 2 .and. aBlank[ _NMINTIP ] == 2 .and. nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[3]

		/*
		Botones________________________________________________________________
		*/

      REDEFINE BUTTON oBtnAnterior ;
         ID       500 ;
			OF 		oDlg;
			WHEN 		( 	nMode != ZOOM_MODE ) ;
         ACTION   (  BotonAnterior( oFld ) )

      REDEFINE BUTTON oBtnSiguiente ;
         ID       550 ;
			OF 		oDlg;
			WHEN 		( 	nMode != ZOOM_MODE ) ;
         ACTION   (  BotonSiguiente( aBlank, aoGet, nMode, oBrw, oFld, oDlg, oTipoOferta, dbfOferta ) )

      REDEFINE BUTTON oBtnCancelar ;
         ID       560 ;
			OF 		oDlg ;
         CANCEL ;
			ACTION 	( 	oDlg:end() )

      oDlg:bStart := {|| StartEdtRec( aoGet, aBlank, nValDiv, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oTipoOferta, cCodArt, oSay ) }
      
   ACTIVATE DIALOG oDlg CENTER

   oBmpPrimera:End()
   oBmpSegunda:End()
   oBmpTercera:End()

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

static function StartEdtRec( aoGet, aBlank, nValDiv, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oTipoOferta, cCodArt, oSay )

   ChangeComboTipo( aoGet, aBlank, nValDiv, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oTipoOferta, cCodArt )

   oBtnAnterior:Hide()

   if( !Empty( cCodArt ), aoGet[ _CARTOFE ]:lValid(), )

   InitProp( aBlank, aoGet, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2 )

   aoGet[ _CARTOFE ]:SetFocus()

   StartPrecios( oSay, aoGet )

Return .t.

//--------------------------------------------------------------------------//

static function BotonAnterior( oFld )

   do case
      case oFld:nOption == 2
           oFld:SetOption( 1 )
           oBtnAnterior:Hide()

      case oFld:nOption == 3
           oFld:SetOption( 2 )
           SetWindowText( oBtnSiguiente:hWnd, "Siguiente >" )

   end case

Return .t.

//--------------------------------------------------------------------------//

static function BotonSiguiente( aBlank, aoGet, nMode, oBrw, oFld, oDlg, oTipoOferta, dbfOferta )

   do case

      case oFld:nOption == 1
           if lChkOfe( aBlank, dbfOferta, nMode, aoGet, oFld )
               oFld:SetOption( 2 )
               oBtnAnterior:Show()
           end if

      case oFld:nOption == 2
           oFld:SetOption( 3 )
           SetWindowText( oBtnSiguiente:hWnd, "Terminar" )

      case oFld:nOption == 3

         if lChkOfe( aBlank, dbfOferta, nMode, aoGet, oFld )

            aBlank[ _NTBLOFE ]      := oTipoOferta:nAt

            WinGather( aBlank, aoGet, dbfOferta, oBrw, nMode )

            oDlg:end( IDOK )

         end if

   end case

Return .t.

//--------------------------------------------------------------------------//

Static Function StartPrecios( oSay, aoGet )

   oSay[ 1 ]:SetText( uFieldEmpresa( "cTxtTar1", "Precio 1" ) )

   if uFieldEmpresa( "lShwTar2" )
      oSay[ 2 ]:SetText( uFieldEmpresa( "cTxtTar2", "Precio 2" ) )
   else
      oSay[ 2 ]:Hide()
      aoGet[ _NPREOFE2 ]:Hide()
      aoGet[ _NPREIVA2 ]:Hide()
   end if

   if uFieldEmpresa( "lShwTar3" )
      oSay[ 3 ]:SetText( uFieldEmpresa( "cTxtTar3", "Precio 3" ) )
   else
      oSay[ 3 ]:Hide()
      aoGet[ _NPREOFE3 ]:Hide()
      aoGet[ _NPREIVA3 ]:Hide()
   end if

   if uFieldEmpresa( "lShwTar4" )
      oSay[ 4 ]:SetText( uFieldEmpresa( "cTxtTar4", "Precio 4" ) )
   else
      oSay[ 4 ]:Hide()
      aoGet[ _NPREOFE4 ]:Hide()
      aoGet[ _NPREIVA4 ]:Hide()
   end if

   if uFieldEmpresa( "lShwTar5" )
      oSay[ 5 ]:SetText( uFieldEmpresa( "cTxtTar5", "Precio 5" ) )
   else
      oSay[ 5 ]:Hide()
      aoGet[ _NPREOFE5 ]:Hide()
      aoGet[ _NPREIVA5 ]:Hide()
   end if

   if uFieldEmpresa( "lShwTar6" )
      oSay[ 6 ]:SetText( uFieldEmpresa( "cTxtTar6", "Precio 6" ) )
   else
      oSay[ 6 ]:Hide()
      aoGet[ _NPREOFE6 ]:Hide()
      aoGet[ _NPREIVA6 ]:Hide()
   end if

Return .t.

//--------------------------------------------------------------------------//

static function ChangeFolder( aBlank, aoGet, nMode, oFld )

   do case
      case oFld:nOption == 1
           oBtnAnterior:Hide()
           SetWindowText( oBtnSiguiente:hWnd, "Siguiente >" )

      case oFld:nOption == 2
           oBtnAnterior:Show()
           SetWindowText( oBtnSiguiente:hWnd, "Siguiente >" )

      case oFld:nOption == 3
           oBtnAnterior:Show()
           SetWindowText( oBtnSiguiente:hWnd, "Terminar" )

   end case

Return .t.

//--------------------------------------------------------------------------//

Static function InitProp( aBlank, aoGet, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2 )

   if nMode == APPD_MODE

      oSayPr1:Hide()
      oSayPr2:Hide()
      oSayVp1:Hide()
      oSayVp2:Hide()

      aoGet[ _CVALPR1 ]:Hide()
      aoGet[ _CVALPR2 ]:Hide()

   else

      if Empty( aBlank[ _CCODPR1 ] )
         oSayPr1:Hide()
         oSayVp1:Hide()
         aoGet[ _CVALPR1 ]:Hide()
      end if

      if Empty( aBlank[ _CCODPR2 ] )
         oSayPr2:Hide()
         oSayVp2:Hide()
         aoGet[ _CVALPR2 ]:Hide()
      end if

   end if

RETURN nil

//--------------------------------------------------------------------------//

STATIC FUNCTION delFecha()

	local oDlg
	local dFecIni	:= ctod( "01/01/" + Str( Year( Date() ) ) )
	local dFecFin	:= date()

	DEFINE DIALOG oDlg RESOURCE "DELFEC"

		REDEFINE GET dFecIni ;
			ID 		100 ;
			SPINNER ;
			COLOR 	CLR_GET ;
			OF 		oDlg

		REDEFINE GET dFecFin ;
			ID 		110 ;
			SPINNER ;
			COLOR 	CLR_GET ;
			OF 		oDlg

		REDEFINE BUTTON ;
			ID 		502 ;
			OF 		oDlg;
			ACTION 	(  mkdelfec( dFecIni, dFecFin ),;
                     oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
			ID 		510 ;
			OF 		oDlg ;
			ACTION 	( 	oDlg:end() )

	ACTIVATE DIALOG oDlg	CENTER

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION mkDelFec( dFecIni, dFecFin )

	local nRec	:= ( dbfOferta )->( recno() )

   CursorWait()

	( dbfOferta )->( dbGoTop() )

	WHILE !( dbfOferta )->( eof() )

		IF ( dbfOferta )->DINIOFE >= dFecIni .AND.;
			( dbfOferta )->DFINOFE <= dFecFin

			delRecno( dbfOferta, oWndBrw:oBrw )

		END IF

		( dbfOferta )->( dbSkip() )

	END WHILE

	( dbfOferta )->( dbGoTo( nRec ) )

   CursorWe()

	oWndBrw:oBrw:refresh()

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION isBig( nUndVen, nUndCob )

	IF nUndVen < nUndCob
      msgStop( "Las unidades a vender debe ser mayor o igual que ha cobrar." )
		RETURN .F.
	END IF

RETURN .T.

//--------------------------------------------------------------------------//

FUNCTION BrwOfe( oGet, dbfOferta, oGet2 )

	local oDlg
	local oBrw
	local oGet1
	local cGet1
   local nOrd        := GetBrwOpt( "BrwOfe" )
	local oCbxOrd
   local aCbxOrd     := { "Código", "Nombre" }
   local cCbxOrd
   local lClose      := .f.
   local nLevelUsr   := nLevelUsr( "01020" )

   nOrd              := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd           := aCbxOrd[ nOrd ]

   if ( dbfOferta ) == nil
		OpenFiles()
      lClose         := .t.
   end if

   nOrd              := ( dbfOferta )->( OrdSetFocus( nOrd ) )

   ( dbfOferta )->( dbGoTop() )

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Ofertas"

		REDEFINE GET oGet1 VAR cGet1;
         ID       104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfOferta ) );
         VALID    ( OrdClearScope( oBrw, dbfOferta ) );
         BITMAP   "FIND" ;
         OF       oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    aCbxOrd ;
			ON CHANGE( ( dbfOferta )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:refresh(), oGet1:SetFocus() ) ;
			OF 		oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfOferta
      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "Browse.Oferta"

      with object ( oBrw:AddCol() )
         :cHeader          := "Origen"
         :bStrData         := {|| aTipoOferta[ Max( ( dbfOferta )->nTblOfe, 1 ) ] }
         :bBmpData         := {|| ( dbfOferta )->nTblOfe }
         :nWidth           := 110
         :AddResource( "gc_object_cube_16" )
         :AddResource( "gc_cubes_16" )
         :AddResource( "gc_objects_16" )
         :AddResource( "gc_photographic_filters_16" )
         :AddResource( "gc_cloud_sun_16" )
         :AddResource( "gc_bolt_16" )
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cArtOfe"
         :bEditValue       := {|| ( dbfOferta )->cArtOfe }
         :nWidth           := 90
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cDesOfe"
         :bEditValue       := {|| ( dbfOferta )->cDesOfe }
         :nWidth           := 260
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }
      oBrw:bRClicked       := {| nRow, nCol, nFlags | oBrw:RButtonDown( nRow, nCol, nFlags ) }

      oBrw:CreateFromResource( 105 )

		REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( oDlg:end(IDOK) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         ACTION   ( oDlg:end() )

		REDEFINE BUTTON ;
         ID       500 ;
         OF       oDlg ;
         WHEN     ( nAnd( nLevelUsr, ACC_APPD ) != 0 ) ;
         ACTION   ( WinAppRec( oBrw, bEdit, dbfOferta, .f., cDefIva() ) )

		REDEFINE BUTTON ;
         ID       501 ;
         OF       oDlg ;
         WHEN     ( nAnd( nLevelUsr, ACC_EDIT ) != 0 ) ;
         ACTION   ( WinEdtRec( oBrw, bEdit, dbfOferta, .f., cDefIva() ) )

   oDlg:AddFastKey( VK_F2, {|| if( nAnd( nLevelUsr, ACC_APPD ) != 0, WinAppRec( oBrw, bEdit, dbfOferta, .f., cDefIva() ), ) } )
   oDlg:AddFastKey( VK_F3, {|| if( nAnd( nLevelUsr, ACC_EDIT ) != 0, WinEdtRec( oBrw, bEdit, dbfOferta, .f., cDefIva() ), ) } )
   oDlg:AddFastKey( VK_F5, {|| oDlg:end(IDOK) } )
   oDlg:AddFastKey( VK_RETURN, {|| oDlg:end(IDOK) } )

   ACTIVATE DIALOG oDlg CENTER

   If oDlg:nResult == IDOK

      oGet:cText( (dbfOferta)->CARTOFE )

		IF oGet2 != NIL
         oGet2:cText( (dbfOferta)->CDESOFE )
		END IF

	END IF

   DestroyFastFilter( dbfOferta )

   SetBrwOpt( "BrwOfe", ( dbfOferta )->( OrdNumber() ) )

	IF lClose
		CloseFiles()
	ELSE
      ( dbfOferta )->( OrdSetFocus( nOrd ) )
	END IF

	oGet:setFocus()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

FUNCTION AppOfeArt( cCodArt, lIvaInc, cTipIva, oBrw, dbfTmpOfe )

   OpenFiles()

   WinAppRec( oBrw, bEdit, dbfTmpOfe, lIvaInc, cTipIva, cCodArt )

   if oBrw != NIL
      oBrw:Refresh()
   end if

   CloseFiles()

RETURN NIL

//---------------------------------------------------------------------------//

FUNCTION EdtOfeArt( cCodArt, lIvaInc, cTipIva, oBrw, dbfTmpOfe )

   OpenFiles()

   WinEdtRec( oBrw, bEdit, dbfTmpOfe, lIvaInc, cTipIva, cCodArt )

   CloseFiles()

   if oBrw != nil
      oBrw:Refresh()
   end if

RETURN NIL

//---------------------------------------------------------------------------//

FUNCTION DelOfeArt( cCodArt, lIvaInc, cTipIva, oBrw, dbfTmpOfe )

   OpenFiles()

   dbDelRec( oBrw, dbfTmpOfe )

   CloseFiles()

   if oBrw != nil
      oBrw:Refresh()
   end if

RETURN NIL

//---------------------------------------------------------------------------//

STATIC FUNCTION lChkOfe( aBlank, dbfOferta, nMode, aGet, oFld )

   local lRet     := .t.

   if nMode == APPD_MODE

      /*
      Caso Oferta por artículo----------------------------------------------
      */

      if Empty( aBlank[ _CARTOFE ] )

         MsgStop( "Código de la oferta no puede estar vacío" )
         lRet     := .f.

      elseif Empty( aBlank[ _CDESOFE ] )

         MsgStop( "Descripción de la oferta no puede estar vacía" )
         lRet     := .f.

      end if

      /*
      SetFocus en el código----------------------------------------------
      */

      oFld:SetOption( 1 )
      oBtnAnterior:Hide()
      SetWindowText( oBtnSiguiente:hWnd, "Siguiente >" )
      aGet[ _CARTOFE ]:SetFocus()

   end if

   aBlank[ _DFECCHG  ] := date()

RETURN lRet

//---------------------------------------------------------------------------//

static function loaArt( aoGet, aBlank, nValDiv, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2 )

   local lValid      := .t.
   local lMessage    := .t.
   local xValor      := aoGet[ _CARTOFE ]:varGet()

   DEFAULT nValDiv   := 1

   if Empty( xValor )
      lMessage       := .f.
   end if

   /*
   Primero buscamos por codigos de barra
   */

   xValor            := cSeekCodebar( xValor, dbfCodebar, dbfArticulo )

   /*
   Ahora buscamos por el codigo interno
   */

   if ( dbfArticulo )->( dbSeek( xValor ) )

      aoGet[ _CARTOFE  ]:cText( xValor )
      aoGet[ _CDESOFE  ]:cText( ( dbfArticulo )->NOMBRE )
      aoGet[ _NPREOFE1 ]:cText( ( dbfArticulo )->PVENTA1 / nValDiv )
      aoGet[ _NPREOFE2 ]:cText( ( dbfArticulo )->PVENTA2 / nValDiv )
      aoGet[ _NPREOFE3 ]:cText( ( dbfArticulo )->PVENTA3 / nValDiv )
      aoGet[ _NPREOFE4 ]:cText( ( dbfArticulo )->PVENTA4 / nValDiv )
      aoGet[ _NPREOFE5 ]:cText( ( dbfArticulo )->PVENTA5 / nValDiv )
      aoGet[ _NPREOFE6 ]:cText( ( dbfArticulo )->PVENTA6 / nValDiv )
      aoGet[ _NPREIVA1 ]:cText( ( dbfArticulo )->PVTAIVA1 / nValDiv )
      aoGet[ _NPREIVA2 ]:cText( ( dbfArticulo )->PVTAIVA2 / nValDiv )
      aoGet[ _NPREIVA3 ]:cText( ( dbfArticulo )->PVTAIVA3 / nValDiv )
      aoGet[ _NPREIVA4 ]:cText( ( dbfArticulo )->PVTAIVA4 / nValDiv )
      aoGet[ _NPREIVA5 ]:cText( ( dbfArticulo )->PVTAIVA5 / nValDiv )
      aoGet[ _NPREIVA6 ]:cText( ( dbfArticulo )->PVTAIVA6 / nValDiv )

         aBlank[ _CCODPR1 ] := ( dbfArticulo )->cCodPrp1
         aBlank[ _CCODPR2 ] := ( dbfArticulo )->cCodPrp2

         if !empty( aBlank[ _CCODPR1 ] )

            oSayPr1:SetText( retProp( ( dbfArticulo )->cCodPrp1, dbfPro ) )
            oSayPr1:Show()
            aoGet[ _CVALPR1 ]:show()
            oSayVp1:show()

         else

            oSayPr1:hide()
            aoGet[ _CVALPR1 ]:hide()
            oSayVp1:hide()

         end if

         if !empty( aBlank[ _CCODPR2 ] )

            oSayPr2:SetText( retProp( ( dbfArticulo )->cCodPrp2, dbfPro ) )
            oSayPr2:show()
            aoGet[ _CVALPR2 ]:show()
            oSayVp2:show()

         else

            oSayPr2:hide()
            aoGet[ _CVALPR2 ]:hide()
            oSayVp2:hide()

         end if

   ELSE


      if lMessage
         MsgStop( "Artículo no encontrado." )
         lValid         := .f.
      end if

   END IF

RETURN lValid

//---------------------------------------------------------------------------//

/*
Exporta el fichero de rutas y clientes a EDM
*/

FUNCTION EdmOfe( cCodRut, cPathTo, oStru )

/*
NOMBRE FICHERO      : EOFERxxx.ODB    (xxx = AGENTE)
DESCRIPCION         : MAESTRO DE OFERTAS POR CLIENTE/GRUPO
TIPO DE FICHERO     : SECUENCIAL CON SEPARADOR DE CAMPOS
NUM. DE CAMPOS      : 9
LONG. DEL REGISTRO  : VARIABLE

N§ LC  LV  J  Descripci¢n       Observaciones
1  21  No  D  CLAVE             (1)
2  13  Si  I  REFERENCIA        C¢digo del art¡culo para el cliente
3  1   No  I  TIPO OFERTA       (2)
4  5   Si  I  CANT. BASE        cantidad base necesaria para aplicar oferta
5  5   Si  I  OFERTA            cantidad de la oferta en s¡
6  8   No  I  FECHA INICIAL     AAAAMMDD Fechas entre las cuales
7  8   No  I  FECHA FINAL       AAAAMMDD tendr  vigencia la oferta
8  13  No  D  REF. REGALO       C¢digo del art¡culo a regalar (si es otro)
9  7   SI  I  ACUMULADO         (3)
*/

   local n           := 0
   local cChr
   local fTar
   local cFilEdm
   local cFilOdb
   local nWrote
   local nRead
   local dbfOferta

   DEFAULT cCodRut   := "001"
   DEFAULT cPathTo   := "C:\INTERS~1\"

   cCodRut           := SubStr( cCodRut, -3 )

   cFilEdm           := cPathTo + "EOFER" + cCodRut + ".TXT"    //  de momento ruta unica
   cFilOdb           := cPathTo + "EOFER" + cCodRut + ".ODB"    //  de momento ruta unica

   /*
   Creamos el fichero destino
   */

   IF file( cFilEdm )
      fErase( cFilEdm )
   END IF

   fTar     := fCreate( cFilEdm )

   /*
   Abrimos las bases de datos
   */

   USE ( cPatArt() + "OFERTA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "OFERTA", @dbfOferta ) )
   SET ADSINDEX TO ( cPatArt() + "OFERTA.CDX" ) ADDITIVE

   oStru:oMetUno:cText   := "Ofertas"
   oStru:oMetUno:SetTotal( ( dbfOferta )->( LastRec() ) )

   WHILE !( dbfOferta )->( eof() )

      cChr  := "+"
      if (dbfOferta)->NCLIOFE == 2                                         // Tipo de oferta de cliente o de grupo
      cChr  += Space( 3 ) + Rjust( ( dbfOferta )->CGRPOFE, "0", 4 )        // Codigo de grupo de cliente
      else
      cChr  += Rjust( ( dbfOferta )->CCLIOFE, "0", 7 )                     // Codigo de cliente
      end if
      cChr  += Rjust( ( dbfOferta )->CARTOFE, Space(1), 13 ) + "@"         // Articulo de la oferta
      cChr  += Rtrim( ( dbfOferta )->CARTOFE ) + "@"                       // Codigo de articulo para el cliente
      cChr  += Str( ( dbfOferta )->NTIPOFE, 1 ) + "@"                      // Tipo de la oferta 1,2,3,4
      if ( dbfOferta )->NTIPOFE == 1
      cChr  += AllTrim( Str( ( dbfOferta )->nPreOfe1, 10 ) ) + "@"         // precio de la oferta
      else
      cChr  += AllTrim( Str( ( dbfOferta )->NUNVOFE, 2 ) ) + "@"           // cantidad base necesaria para aplicar oferta
      end if
      cChr  += AllTrim( Str( ( dbfOferta )->NUNCOFE, 2 ) ) + "@"           // cobrar en la oferta
      cChr  += Dtos( ( dbfOferta )->DINIOFE ) + "@"                        // fecha inicio de oferta
      cChr  += Dtos( ( dbfOferta )->DFINOFE ) + "@"                        // fecha fin de la oferta
      cChr  += Rjust( ( dbfOferta )->CARTOFE, Space(1), 13 ) + "@"         // articulo a regalar
      cChr  += "0"                                                         // unidades acumuladas esto no se usa
      cChr  += CRLF

      nWrote:= fwrite( fTar, cChr, nRead )

      oStru:oMetUno:Set( ++n )

      /*
      IF fError() != 0
         msginfo( "Hay errores" )
      END IF
      */

      ( dbfOferta )->( dbSkip() )

   END DO

   CLOSE ( dbfOferta )

   fClose( fTar )

   if file( FullCurDir() + "CONVER.EXE" )
      WinExec( FullCurDir() + "CONVER.EXE " + cFilEdm + " " + cFilOdb + " 64 -x", 6 ) // Minimized
   end if

RETURN NIL

//---------------------------------------------------------------------------//

Static Function CalIva( nPrecio, lIvaInc, cTipIva, cCodImp, oGetIva )

   local nIvaPct     := nIva( dbfIva, cTipIva )

   /*
   Despues si tiene impuesto especial qitarlo
   */

   if !Empty( cCodImp )
      nPrecio        += oNewImp:nValImp( cCodImp, .t., nIvaPct )
   end if

	/*
   Calculo del impuestos
	*/

   nPrecio           += ( nPrecio * nIvaPct / 100 )

   if oGetIva != NIL
      oGetIva:cText( nPrecio )
   end if

Return .t.

//----------------------------------------------------------------------------//

Static Function CalBas( nPrecio, lIvaInc, cTipIva, cCodImp, oGetBas )

	local nNewPre
   local nIvaPct  := nIva( dbfIva, cTipIva )

	/*
   Primero es quitar el impuestos
	*/

   nNewPre        := ( nPrecio / ( 1 + nIvaPct / 100 ) )

   /*
   Despues si tiene impuesto especial qitarlo
   */

   if !Empty( cCodImp )
      nNewPre     -= oNewImp:nValImp( cCodImp, lIvaInc , nIvaPct )
   end if

	/*
	Actualizamos la base
	*/

   oGetBas:cText( nNewPre )

Return .t.

//----------------------------------------------------------------------------//

Function nPreOfe( cCodArt, nTarifa, dFecOfe, lIvaInc, dbfOferta )

   local nPreOfe     := 0

   DEFAULT nTarifa   := 1
   DEFAULT dFecOfe   := GetSysDate()
   DEFAULT lIvaInc   := .f.

   if ( dbfOferta )->( dbSeek( cCodArt ) )

      while ( dbfOferta )->cArtOfe == cCodArt .and. !( dbfOferta )->( eof() )

			/*
			Comprobamos si esta entre las fechas
			*/

         if ( dFecOfe >= ( dbfOferta )->dIniOfe .OR. empty( ( dbfOferta )->dIniOfe ) ) .and. ;
            ( dFecOfe <= ( dbfOferta )->dFinOfe .OR. empty( ( dbfOferta )->dFinOfe ) )

            /*
            Cambiamos las unidades por el numero de unidades a vender
            entre los de la oferta
            Recogemos el precio de la oferta
            */

            if lIvaInc

               do case
                  case nTarifa == 1
                     nPreOfe  := ( dbfOferta )->nPreIva1
                  case nTarifa == 2
                     nPreOfe  := ( dbfOferta )->nPreIva2
                  case nTarifa == 3
                     nPreOfe  := ( dbfOferta )->nPreIva3
                  case nTarifa == 4
                     nPreOfe  := ( dbfOferta )->nPreIva4
                  case nTarifa == 5
                     nPreOfe  := ( dbfOferta )->nPreIva5
                  case nTarifa == 6
                     nPreOfe  := ( dbfOferta )->nPreIva6
               end case

            else

               do case
                  case nTarifa == 1
                     nPreOfe  := ( dbfOferta )->nPreOfe1
                  case nTarifa == 2
                     nPreOfe  := ( dbfOferta )->nPreOfe2
                  case nTarifa == 3
                     nPreOfe  := ( dbfOferta )->nPreOfe3
                  case nTarifa == 4
                     nPreOfe  := ( dbfOferta )->nPreOfe4
                  case nTarifa == 5
                     nPreOfe  := ( dbfOferta )->nPreOfe5
                  case nTarifa == 6
                     nPreOfe  := ( dbfOferta )->nPreOfe6
               end case

            end if

         end if

		( dbfOferta )->( dbSkip() )

      end do

   end if

Return ( nPreOfe )

//---------------------------------------------------------------------------//
//Funciones comunes del programa y pda
//---------------------------------------------------------------------------//

/*
Devuelve el precio de un producto este de oferta
*/

FUNCTION nXbYOferta( cCodArt, cCodCli, cGrpCli, nCajVen, nUndVen, dFecOfe, dbfOferta, nTblOfe )

   local nModOfe     := 0
   local nTipXbY     := 0
   local nUndGrt     := 0
   local aXbYRet     := { 0, 0 }

   DEFAULT nTblOfe   := 1

	/*
	Primero buscar si existe el articulo en la oferta
	*/

   if ( dbfOferta )->( dbSeek( Padr( cCodArt, 18 ) ) )

      while ( dbfOferta )->cArtOfe == Padr( cCodArt, 18 ) .and. !( dbfOferta )->( eof() )

         /*
			Comprobamos si esta entre las fechas
			*/

         if ( dbfOferta )->nTblOfe  == nTblOfe                                         .AND. ;
            ( dFecOfe >= ( dbfOferta )->DINIOFE .OR. empty( ( dbfOferta )->DINIOFE ) ) .AND. ;
            ( dFecOfe <= ( dbfOferta )->DFINOFE .OR. empty( ( dbfOferta )->DFINOFE ) ) .AND. ;
            ( dbfOferta )->NTIPOFE == 2                                                .AND. ;
            (  ( ( dbfOferta )->nCliOfe == 1 )                                         .OR. ;
               ( ( dbfOferta )->nCliOfe == 2 .AND. cGrpCli == ( dbfOferta )->cGrpOfe ) .OR. ;
               ( ( dbfOferta )->nCliOfe == 3 .AND. cCodCli == ( dbfOferta )->cCliOfe ) )

            /*
            Vamos a comprobar si la oferta es de unidades o de cajas
            */

            if nTipXbY == 1   // Cajas

               if mod( nCajVen, ( dbfOferta )->nUnvOfe ) == 0

                  /*
                  Multiplos de la oferta
                  */

                  nModOfe     := Int( nCajVen / ( dbfOferta )->nUnvOfe )
                  nUndGrt     := ( ( dbfOferta )->nUnvOfe - ( dbfOferta )->nUncOfe ) * nModOfe
                  nTipXbY     := ( dbfOferta )->nTipXbY

                  if nUndGrt != 0 .and. nUndGrt > aXbYRet[ 2 ]
                     aXbYRet  := { nTipXbY, nUndGrt }
                  end if

                  // exit

               end if

            else

               /*
               Comprobamos el numero de unidades a vender es igual a de la oferta
               o si al dividirlo devuelve un numero de resto 0 tendremos un
               multiplo de la oferta
               */

               if mod( nCajVen * nUndVen, ( dbfOferta )->nUnvOfe ) == 0

                  /*
                  Multiplos de la oferta
                  */

                  nModOfe     := Int( ( nCajVen * Abs( nUndVen ) ) / ( dbfOferta )->nUnvOfe )
                  nUndGrt     := ( ( dbfOferta )->nUnvOfe - ( dbfOferta )->nUncOfe ) * nModOfe
                  nTipXbY     := ( dbfOferta )->nTipXbY

                  if nUndGrt != 0 .and. nUndGrt > aXbYRet[ 2 ]
                     aXbYRet  := { nTipXbY, nUndGrt }
                  end if

                  // exit

               end if

            end if

         end if

         ( dbfOferta )->( dbSkip() )

      end do

   end if

RETURN ( aXbYRet )

//---------------------------------------------------------------------------//

FUNCTION nDtoLineal( cCodArt, cCodCli, cGrpCli, nUndVen, dFecOfe, dbfOferta, cCodPr1, cCodPr2, cValPr1, cValPr2 )

   local nDtoLin     := 0

	/*
	Primero buscar si existe el articulo en la oferta
	*/

   IF ( dbfOferta )->( dbSeek( cCodArt + cCodPr1 + cCodPr2 + cValPr1 + cValPr2 ) )

      WHILE ( dbfOferta )->CARTOFE + ( dbfOferta )->CCODPR1 + ( dbfOferta )->CCODPR2 + ( dbfOferta )->CVALPR1 + ( dbfOferta )->CVALPR2 == cCodArt + cCodPr1 + cCodPr2 + cValPr1 + cValPr2

			/*
			Comprobamos si esta entre las fechas
			*/

			IF ( dFecOfe >= ( dbfOferta )->DINIOFE .OR. empty( ( dbfOferta )->DINIOFE ) ) .AND. ;
            ( dFecOfe <= ( dbfOferta )->DFINOFE .OR. empty( ( dbfOferta )->DFINOFE ) ) .AND. ;
            ( dbfOferta )->NTIPOFE == 1                                                .AND. ;
            (  ( ( dbfOferta )->nCliOfe == 1 )                                         .OR. ;
               ( ( dbfOferta )->nCliOfe == 2 .AND. cGrpCli == ( dbfOferta )->cGrpOfe ) .OR. ;
               ( ( dbfOferta )->nCliOfe == 3 .AND. cCodCli == ( dbfOferta )->cCliOfe ) )

            /*
				Comprobamos que no vayamos a vender mas articulos que los del lote
				*/

            IF ( dbfOferta )->NMAXOFE == 0 .OR. nUndVen <= ( dbfOferta )->NMAXOFE
               nDtoLin  := ( dbfOferta )->nDtoLin
				END IF

			END IF

         ( dbfOferta )->( dbSkip() )

		END DO

	END IF

RETURN nDtoLin

//---------------------------------------------------------------------------//

FUNCTION nDtoOferta( cCodArt, cCodCli, cGrpCli, nUndVen, dFecOfe, dbfOferta, cCodPr1, cCodPr2, cValPr1, cValPr2 )

   local nDtoOfe     := 0

	/*
	Primero buscar si existe el articulo en la oferta
	*/

   if ( dbfOferta )->( dbSeek( cCodArt + cCodPr1 + cCodPr2 + cValPr1 + cValPr2 ) )

      while ( dbfOferta )->CARTOFE + ( dbfOferta )->CCODPR1 + ( dbfOferta )->CCODPR2 + ( dbfOferta )->CVALPR1 + ( dbfOferta )->CVALPR2 == cCodArt + cCodPr1 + cCodPr2 + cValPr1 + cValPr2
			
         /*
			Comprobamos si esta entre las fechas
			*/

         if ( dFecOfe >= ( dbfOferta )->dIniOfe .OR. empty( ( dbfOferta )->dIniOfe ) ) .AND. ;
            ( dFecOfe <= ( dbfOferta )->dFinOfe .OR. empty( ( dbfOferta )->dFinOfe ) ) .AND. ;
            ( dbfOferta )->nTipOfe == 1                                                .AND. ;
            (  ( ( dbfOferta )->nCliOfe == 1 )                                         .OR. ;
               ( ( dbfOferta )->nCliOfe == 2 .AND. cGrpCli == ( dbfOferta )->cGrpOfe ) .OR. ;
               ( ( dbfOferta )->nCliOfe == 3 .AND. cCodCli == ( dbfOferta )->cCliOfe ) )

            /*
				Comprobamos que no vayamos a vender mas articulos que los del lote
				*/

            if ( dbfOferta )->nMaxOfe == 0 .OR. nUndVen <= ( dbfOferta )->nMaxOfe
               nDtoOfe  := ( dbfOferta )->nDtoPct
            end if

         end if

         ( dbfOferta )->( dbSkip() )

      end do

   end if

RETURN nDtoOfe

//---------------------------------------------------------------------------//

/*
Devuelve el precio de un producto este de oferta
*/

FUNCTION nImpOferta( cCodArt, cCodCli, cGrpCli, nUndVen, dFecOfe, dbfOferta, nPrecio, lIvaInc, cCodPr1, cCodPr2, cValPr1, cValPr2, cDivPre, cDbfArticulo, cDbfDiv, cDbfKit, cDbfIva )

   local nPreOfe     := 0

   DEFAULT nPrecio   := 1
   DEFAULT lIvaInc   := .f.

   /*
   Primero buscar si existe el articulo en la oferta
   */

   if ( dbfOferta )->( dbSeek( cCodArt + cCodPr1 + cCodPr2 + cValPr1 + cValPr2 ) )

      while ( dbfOferta )->cArtOfe + ( dbfOferta )->cCodPr1 + ( dbfOferta )->cCodPr2 + ( dbfOferta )->cValPr1 + ( dbfOferta )->cValPr2 == cCodArt + cCodPr1 + cCodPr2 + cValPr1 + cValPr2

         /*
         Comprobamos si esta entre las fechas
         */

         if ( dbfOferta )->nTblOfe < 2                                                 .AND.;
            ( dFecOfe >= ( dbfOferta )->dIniOfe .OR. empty( ( dbfOferta )->dIniOfe ) ) .AND.;
            ( dFecOfe <= ( dbfOferta )->dFinOfe .OR. empty( ( dbfOferta )->dFinOfe ) ) .AND.;
            ( dbfOferta )->nTipOfe == 1                                                .AND.;
            (  ( ( dbfOferta )->nCliOfe == 1 )                                         .OR.;
               ( ( dbfOferta )->nCliOfe == 2 .AND. cGrpCli == ( dbfOferta )->cGrpOfe ) .OR.;
               ( ( dbfOferta )->nCliOfe == 3 .AND. cCodCli == ( dbfOferta )->cCliOfe ) )

            /*
            Comprobamos que no vayamos a vender mas articulos que los del lote
            */

            do case
               case nPrecio == 1
                  nPreOfe  :=  if( lIvaInc, ( dbfOferta )->nPreIva1, ( dbfOferta )->nPreOfe1 )
               case nPrecio == 2
                  nPreOfe  :=  if( lIvaInc, ( dbfOferta )->nPreIva2, ( dbfOferta )->nPreOfe2 )
               case nPrecio == 3
                  nPreOfe  :=  if( lIvaInc, ( dbfOferta )->nPreIva3, ( dbfOferta )->nPreOfe3 )
               case nPrecio == 4
                  nPreOfe  :=  if( lIvaInc, ( dbfOferta )->nPreIva4, ( dbfOferta )->nPreOfe4 )
               case nPrecio == 5
                  nPreOfe  :=  if( lIvaInc, ( dbfOferta )->nPreIva5, ( dbfOferta )->nPreOfe5 )
               case nPrecio == 6
                  nPreOfe  :=  if( lIvaInc, ( dbfOferta )->nPreIva6, ( dbfOferta )->nPreOfe6 )
            end case

            exit

         end if

         ( dbfOferta )->( dbSkip() )

      end do

   end if

RETURN nPreOfe

//---------------------------------------------------------------------------//
/*
Devuelve un array con el precio y los descuentos de la oferta según el artículo
*/

FUNCTION sOfertaArticulo( cCodArt, cCodCli, cGrpCli, nUndVen, dFecOfe, dbfOferta, nPrecio, lIvaInc, cCodPr1, cCodPr2, cValPr1, cValPr2, nCajVen, nImpVen )

   local nPreOfe     := 0
   local nPreAnt     := 0
   local sPrecio
   local nRec        := ( dbfOferta )->( Recno() )
   local nOrdAnt     := ( dbfOferta )->( OrdSetFocus( "cArtOfe" ) )

   DEFAULT nPrecio   := 1
   DEFAULT lIvaInc   := .f.

   /*
   Primero buscar si existe el articulo en la oferta--------------------------
   */

   if ( dbfOferta )->( dbSeek( cCodArt + cCodPr1 + cCodPr2 + cValPr1 + cValPr2 ) )

      while ( dbfOferta )->cArtOfe + ( dbfOferta )->cCodPr1 + ( dbfOferta )->cCodPr2 + ( dbfOferta )->cValPr1 + ( dbfOferta )->cValPr2 == cCodArt + cCodPr1 + cCodPr2 + cValPr1 + cValPr2

         /*
         Comprobamos si esta entre las fechas----------------------------------
         */

         if ( dbfOferta )->nTblOfe < 2                                                    .and.;
            ( dFecOfe >= ( dbfOferta )->dIniOfe .or. empty( ( dbfOferta )->dIniOfe ) )    .and.;
            ( dFecOfe <= ( dbfOferta )->dFinOfe .or. empty( ( dbfOferta )->dFinOfe ) )    .and.;
            ( dbfOferta )->nTipOfe == 1                                                   .and.;
            ( ( ( dbfOferta )->nCliOfe == 1 ) .or. ( ( dbfOferta )->nCliOfe == 2 .and. cGrpCli == ( dbfOferta )->cGrpOfe ) .or. ( ( dbfOferta )->nCliOfe == 3 .and. cCodCli == ( dbfOferta )->cCliOfe ) ) .and.;
            ( ( ( dbfOferta )->nMinCan == 1 .and. ( ( dbfOferta )->nImpMin == 0 .or. ( ( dbfOferta )->nImpMin != 0 .and. nImpVen >= ( dbfOferta )->nImpMin ) ) ) .or.;
            ( ( dbfOferta )->nMinCan == 2 .and. ( dbfOferta )->nMinTip == 1 .and. ( ( dbfOferta )->nCajMin == 0 .or. ( ( dbfOferta )->nCajMin != 0 .and. nCajVen >= ( dbfOferta )->nCajMin ) ) ) .or.;
            ( ( dbfOferta )->nMinCan == 2 .and. ( dbfOferta )->nMinTip == 2 .and. ( ( dbfOferta )->nUndMin == 0 .or. ( ( dbfOferta )->nUndMin != 0 .and. nUndVen >= ( dbfOferta )->nUndMin ) ) ) )

            /*
            Comprobamos que no vayamos a vender mas articulos que los del lote
            */

            do case
               case nPrecio == 1
                  nPreOfe              :=  if( lIvaInc, ( dbfOferta )->nPreIva1, ( dbfOferta )->nPreOfe1 )
               case nPrecio == 2
                  nPreOfe              :=  if( lIvaInc, ( dbfOferta )->nPreIva2, ( dbfOferta )->nPreOfe2 )
               case nPrecio == 3
                  nPreOfe              :=  if( lIvaInc, ( dbfOferta )->nPreIva3, ( dbfOferta )->nPreOfe3 )
               case nPrecio == 4
                  nPreOfe              :=  if( lIvaInc, ( dbfOferta )->nPreIva4, ( dbfOferta )->nPreOfe4 )
               case nPrecio == 5
                  nPreOfe              :=  if( lIvaInc, ( dbfOferta )->nPreIva5, ( dbfOferta )->nPreOfe5 )
               case nPrecio == 6
                  nPreOfe              :=  if( lIvaInc, ( dbfOferta )->nPreIva6, ( dbfOferta )->nPreOfe6 )
            end case

            if nPreAnt == 0 .or. nPreOfe < nPreAnt
               sPrecio                 := sPrecioOferta()
               sPrecio:nPrecio         := nPreOfe
               sPrecio:nDtoPorcentual  := ( dbfOferta )->nDtoPct
               sPrecio:nDtoLineal      := ( dbfOferta )->nDtoLin
            end if

            nPreAnt                    := nPreOfe

         end if

         ( dbfOferta )->( dbSkip() )

      end do

   end if

   ( dbfOferta )->( OrdSetFocus( nOrdAnt ) )
   ( dbfOferta )->( dbGoTo( nRec ) )

RETURN ( sPrecio )

//---------------------------------------------------------------------------//
/*
Devuelve un array con los descuentos de la oferta según la familia
*/

FUNCTION sOfertaFamilia( cCodFam, cCodCli, cGrpCli, dFecOfe, dbfOferta, nPrecio, cDbfArticulo, nUndVen, nCajVen, nImpVen )

   local nPreOfe     := 0
   local nPreAnt     := 0
   local sPrecio

   DEFAULT nPrecio   := 1

   /*
   Primero buscar si existe el articulo en la oferta
   */

   if ( dbfOferta )->( dbSeek( Padr( cCodFam, 18 ) ) )

      while ( dbfOferta )->cArtOfe  == Padr( cCodFam, 18 ) .and. !( dbfOferta )->( Eof() )

         /*
         Comprobamos si esta entre las fechas
         */

         if ( dbfOferta )->nTblOfe == 2                                                   .AND.;
            ( dFecOfe >= ( dbfOferta )->dIniOfe .OR. empty( ( dbfOferta )->dIniOfe ) )    .AND.;
            ( dFecOfe <= ( dbfOferta )->dFinOfe .OR. empty( ( dbfOferta )->dFinOfe ) )    .AND.;
            ( dbfOferta )->nTipOfe == 1                                                   .AND.;
            (  ( ( dbfOferta )->nCliOfe == 1 )                                            .OR.;
               ( ( dbfOferta )->nCliOfe == 2 .AND. cGrpCli == ( dbfOferta )->cGrpOfe )    .OR.;
               ( ( dbfOferta )->nCliOfe == 3 .AND. cCodCli == ( dbfOferta )->cCliOfe ) )  .AND.;
            ( ( ( dbfOferta )->nMinCan == 1 .AND. ( ( dbfOferta )->nImpMin == 0 .or. ( ( dbfOferta )->nImpMin != 0 .AND. nImpVen >= ( dbfOferta )->nImpMin ) ) ) .OR.;
            ( ( dbfOferta )->nMinCan == 2 .AND. ( dbfOferta )->nMinTip == 1 .AND. ( ( dbfOferta )->nCajMin == 0 .or. ( ( dbfOferta )->nCajMin != 0 .AND. nCajVen >= ( dbfOferta )->nCajMin ) ) ) .OR.;
            ( ( dbfOferta )->nMinCan == 2 .AND. ( dbfOferta )->nMinTip == 2 .AND. ( ( dbfOferta )->nUndMin == 0 .or. ( ( dbfOferta )->nUndMin != 0 .AND. nUndVen >= ( dbfOferta )->nUndMin ) ) ) )

            if nPreAnt == 0 .or. ( dbfOferta )->nDtoPct > nPreAnt
               sPrecio                 := sPrecioOferta()
               sPrecio:nDtoPorcentual  := ( dbfOferta )->nDtoPct
               sPrecio:nDtoLineal      := ( dbfOferta )->nDtoLin
            end if

            nPreAnt                    := ( dbfOferta )->nDtoPct

         end if

         ( dbfOferta )->( dbSkip() )

      end do

   end if

RETURN sPrecio

//---------------------------------------------------------------------------//

FUNCTION sOfertaTipoArticulo( cCodTip, cCodCli, cGrpCli, dFecOfe, dbfOferta, nPrecio, cDbfArticulo, nUndVen, nCajVen, nImpVen )

   local nPreOfe     := 0
   local nPreAnt     := 0
   local sPrecio

   DEFAULT nPrecio   := 1

   /*
   Primero buscar si existe el tipo de articulo en la oferta
   */

   if ( dbfOferta )->( dbSeek( Padr( cCodTip, 18 ) ) )

      while ( dbfOferta )->cArtOfe  == Padr( cCodTip, 18 ) .and. !( dbfOferta )->( Eof() )

         /*
         Comprobamos si esta entre las fechas
         */

         if ( dbfOferta )->nTblOfe == 3                                                   .AND.;
            ( dFecOfe >= ( dbfOferta )->dIniOfe .OR. empty( ( dbfOferta )->dIniOfe ) )    .AND.;
            ( dFecOfe <= ( dbfOferta )->dFinOfe .OR. empty( ( dbfOferta )->dFinOfe ) )    .AND.;
            ( dbfOferta )->nTipOfe == 1                                                   .AND.;
            (  ( ( dbfOferta )->nCliOfe == 1 )                                            .OR.;
               ( ( dbfOferta )->nCliOfe == 2 .AND. cGrpCli == ( dbfOferta )->cGrpOfe )    .OR.;
               ( ( dbfOferta )->nCliOfe == 3 .AND. cCodCli == ( dbfOferta )->cCliOfe ) )  .AND.;
            ( ( ( dbfOferta )->nMinCan == 1 .AND. ( ( dbfOferta )->nImpMin == 0 .or. ( ( dbfOferta )->nImpMin != 0 .AND. nImpVen >= ( dbfOferta )->nImpMin ) ) ) .OR.;
            ( ( dbfOferta )->nMinCan == 2 .AND. ( dbfOferta )->nMinTip == 1 .AND. ( ( dbfOferta )->nCajMin == 0 .or. ( ( dbfOferta )->nCajMin != 0 .AND. nCajVen >= ( dbfOferta )->nCajMin ) ) ) .OR.;
            ( ( dbfOferta )->nMinCan == 2 .AND. ( dbfOferta )->nMinTip == 2 .AND. ( ( dbfOferta )->nUndMin == 0 .or. ( ( dbfOferta )->nUndMin != 0 .AND. nUndVen >= ( dbfOferta )->nUndMin ) ) ) )

            if nPreAnt == 0 .or. ( dbfOferta )->nDtoPct > nPreAnt
               sPrecio                 := sPrecioOferta()
               sPrecio:nDtoPorcentual  := ( dbfOferta )->nDtoPct
               sPrecio:nDtoLineal      := ( dbfOferta )->nDtoLin
            end if

            nPreAnt                    := ( dbfOferta )->nDtoPct

         end if

         ( dbfOferta )->( dbSkip() )

      end do

   end if

RETURN sPrecio

//---------------------------------------------------------------------------//

FUNCTION sOfertaCategoria( cCodCat, cCodCli, cGrpCli, dFecOfe, dbfOferta, nPrecio, cDbfArticulo, nUndVen, nCajVen, nImpVen )

   local nPreOfe     := 0
   local nPreAnt     := 0
   local sPrecio

   DEFAULT nPrecio   := 1

   /*
   Primero buscar si existe el tipo de articulo en la oferta
   */

   if ( dbfOferta )->( dbSeek( Padr( cCodCat, 18 ) ) )

      while ( dbfOferta )->cArtOfe  == Padr( cCodCat, 18 ) .and. !( dbfOferta )->( Eof() )

         /*
         Comprobamos si esta entre las fechas
         */

         if ( dbfOferta )->nTblOfe == 4                                                   .AND.;
            ( dFecOfe >= ( dbfOferta )->dIniOfe .OR. empty( ( dbfOferta )->dIniOfe ) )    .AND.;
            ( dFecOfe <= ( dbfOferta )->dFinOfe .OR. empty( ( dbfOferta )->dFinOfe ) )    .AND.;
            ( dbfOferta )->nTipOfe == 1                                                   .AND.;
            (  ( ( dbfOferta )->nCliOfe == 1 )                                            .OR.;
               ( ( dbfOferta )->nCliOfe == 2 .AND. cGrpCli == ( dbfOferta )->cGrpOfe )    .OR.;
               ( ( dbfOferta )->nCliOfe == 3 .AND. cCodCli == ( dbfOferta )->cCliOfe ) )  .AND.;
            ( ( ( dbfOferta )->nMinCan == 1 .AND. ( ( dbfOferta )->nImpMin == 0 .or. ( ( dbfOferta )->nImpMin != 0 .AND. nImpVen >= ( dbfOferta )->nImpMin ) ) ) .OR.;
            ( ( dbfOferta )->nMinCan == 2 .AND. ( dbfOferta )->nMinTip == 1 .AND. ( ( dbfOferta )->nCajMin == 0 .or. ( ( dbfOferta )->nCajMin != 0 .AND. nCajVen >= ( dbfOferta )->nCajMin ) ) ) .OR.;
            ( ( dbfOferta )->nMinCan == 2 .AND. ( dbfOferta )->nMinTip == 2 .AND. ( ( dbfOferta )->nUndMin == 0 .or. ( ( dbfOferta )->nUndMin != 0 .AND. nUndVen >= ( dbfOferta )->nUndMin ) ) ) )

            if nPreAnt == 0 .or. ( dbfOferta )->nDtoPct > nPreAnt
               sPrecio                 := sPrecioOferta()
               sPrecio:nDtoPorcentual  := ( dbfOferta )->nDtoPct
               sPrecio:nDtoLineal      := ( dbfOferta )->nDtoLin
            end if

            nPreAnt                    := ( dbfOferta )->nDtoPct

         end if

         ( dbfOferta )->( dbSkip() )

      end do

   end if

RETURN sPrecio

//---------------------------------------------------------------------------//

FUNCTION sOfertaTemporada( cCodTem, cCodCli, cGrpCli, dFecOfe, dbfOferta, nPrecio, cDbfArticulo, nUndVen, nCajVen, nImpVen )

   local nPreOfe     := 0
   local nPreAnt     := 0
   local sPrecio

   DEFAULT nPrecio   := 1

   /*
   Primero buscar si existe el tipo de articulo en la oferta
   */

   if ( dbfOferta )->( dbSeek( Padr( cCodTem, 18 ) ) )

      while ( dbfOferta )->cArtOfe  == Padr( cCodTem, 18 ) .and. !( dbfOferta )->( Eof() )

         /*
         Comprobamos si esta entre las fechas
         */

         if ( dbfOferta )->nTblOfe == 5                                                   .AND.;
            ( dFecOfe >= ( dbfOferta )->dIniOfe .OR. empty( ( dbfOferta )->dIniOfe ) )    .AND.;
            ( dFecOfe <= ( dbfOferta )->dFinOfe .OR. empty( ( dbfOferta )->dFinOfe ) )    .AND.;
            ( dbfOferta )->nTipOfe == 1                                                   .AND.;
            (  ( ( dbfOferta )->nCliOfe == 1 )                                            .OR.;
               ( ( dbfOferta )->nCliOfe == 2 .AND. cGrpCli == ( dbfOferta )->cGrpOfe )    .OR.;
               ( ( dbfOferta )->nCliOfe == 3 .AND. cCodCli == ( dbfOferta )->cCliOfe ) )  .AND.;
            ( ( ( dbfOferta )->nMinCan == 1 .AND. ( ( dbfOferta )->nImpMin == 0 .or. ( ( dbfOferta )->nImpMin != 0 .AND. nImpVen >= ( dbfOferta )->nImpMin ) ) ) .OR.;
            ( ( dbfOferta )->nMinCan == 2 .AND. ( dbfOferta )->nMinTip == 1 .AND. ( ( dbfOferta )->nCajMin == 0 .or. ( ( dbfOferta )->nCajMin != 0 .AND. nCajVen >= ( dbfOferta )->nCajMin ) ) ) .OR.;
            ( ( dbfOferta )->nMinCan == 2 .AND. ( dbfOferta )->nMinTip == 2 .AND. ( ( dbfOferta )->nUndMin == 0 .or. ( ( dbfOferta )->nUndMin != 0 .AND. nUndVen >= ( dbfOferta )->nUndMin ) ) ) )

            if nPreAnt == 0 .or. ( dbfOferta )->nDtoPct > nPreAnt
               sPrecio                 := sPrecioOferta()
               sPrecio:nDtoPorcentual  := ( dbfOferta )->nDtoPct
               sPrecio:nDtoLineal      := ( dbfOferta )->nDtoLin
            end if

            nPreAnt                    := ( dbfOferta )->nDtoPct

         end if

         ( dbfOferta )->( dbSkip() )

      end do

   end if

RETURN sPrecio

//---------------------------------------------------------------------------//

FUNCTION sOfertaFabricante( cCodFab, cCodCli, cGrpCli, dFecOfe, dbfOferta, nPrecio, cDbfArticulo, nUndVen, nCajVen, nImpVen )

   local nPreOfe     := 0
   local nPreAnt     := 0
   local sPrecio

   DEFAULT nPrecio   := 1

   /*
   Primero buscar si existe el tipo de articulo en la oferta
   */

   if ( dbfOferta )->( dbSeek( Padr( cCodFab, 18 ) ) )

      while ( dbfOferta )->cArtOfe  == Padr( cCodFab, 18 ) .and. !( dbfOferta )->( Eof() )

         /*
         Comprobamos si esta entre las fechas
         */

         if ( dbfOferta )->nTblOfe == 6                                                   .AND.;
            ( dFecOfe >= ( dbfOferta )->dIniOfe .OR. empty( ( dbfOferta )->dIniOfe ) )    .AND.;
            ( dFecOfe <= ( dbfOferta )->dFinOfe .OR. empty( ( dbfOferta )->dFinOfe ) )    .AND.;
            ( dbfOferta )->nTipOfe == 1                                                   .AND.;
            (  ( ( dbfOferta )->nCliOfe == 1 )                                            .OR.;
               ( ( dbfOferta )->nCliOfe == 2 .AND. cGrpCli == ( dbfOferta )->cGrpOfe )    .OR.;
               ( ( dbfOferta )->nCliOfe == 3 .AND. cCodCli == ( dbfOferta )->cCliOfe ) )  .AND.;
            ( ( ( dbfOferta )->nMinCan == 1 .AND. ( ( dbfOferta )->nImpMin == 0 .or. ( ( dbfOferta )->nImpMin != 0 .AND. nImpVen >= ( dbfOferta )->nImpMin ) ) ) .OR.;
            ( ( dbfOferta )->nMinCan == 2 .AND. ( dbfOferta )->nMinTip == 1 .AND. ( ( dbfOferta )->nCajMin == 0 .or. ( ( dbfOferta )->nCajMin != 0 .AND. nCajVen >= ( dbfOferta )->nCajMin ) ) ) .OR.;
            ( ( dbfOferta )->nMinCan == 2 .AND. ( dbfOferta )->nMinTip == 2 .AND. ( ( dbfOferta )->nUndMin == 0 .or. ( ( dbfOferta )->nUndMin != 0 .AND. nUndVen >= ( dbfOferta )->nUndMin ) ) ) )

            if nPreAnt == 0 .or. ( dbfOferta )->nDtoPct > nPreAnt
               sPrecio                 := sPrecioOferta()
               sPrecio:nDtoPorcentual  := ( dbfOferta )->nDtoPct
               sPrecio:nDtoLineal      := ( dbfOferta )->nDtoLin
            end if

            nPreAnt                    := ( dbfOferta )->nDtoPct

         end if

         ( dbfOferta )->( dbSkip() )

      end do

   end if

RETURN sPrecio

//---------------------------------------------------------------------------//

FUNCTION mkOferta( cPath, lAppend, cPathOld, oMeter )

   local dbfOfe

   DEFAULT lAppend   := .f.
   DEFAULT cPath     := cPatArt()

   if !lExistTable( cPath + "Oferta.Dbf", cLocalDriver() )
      dbCreate( cPath + "Oferta.Dbf", aSqlStruct( aItmOfe() ), cLocalDriver() )
   end if 

   if lAppend .and. !Empty( cPathOld ) .and. lExistTable( cPathOld + "Oferta.Dbf" )

      dbUseArea( .t., cLocalDriver(), cPath + "Oferta.Dbf", cCheckArea( "Oferta", @dbfOfe ), .f. )
   
      if !( dbfOfe )->( neterr() )
         ( dbfOfe )->( __dbApp( cPathOld + "Oferta.Dbf" ) )
         ( dbfOfe )->( dbCloseArea() )
      end if
   
   end if

   rxOferta( cPath )

RETURN NIL

//----------------------------------------------------------------------------//

FUNCTION rxOferta( cPath, cDriver )

   local oError
   local oBlock
   local dbfOferta

   DEFAULT cPath     := cPatArt()
   DEFAULT cDriver   := cDriver()

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if !lExistTable( cPath + "Oferta.Dbf", cDriver )
         dbCreate( cPath + "Oferta.Dbf", aSqlStruct( aItmOfe() ), cDriver )
      end if 

      fEraseIndex( cPath + "Oferta.CDX" )

      dbUseArea( .t., cLocalDriver(), cPath + "Oferta.Dbf", cCheckArea( "OFERTA", @dbfOferta ), .f. )
      if !( dbfOferta )->( neterr() )
         ( dbfOferta )->( __dbPack() )

         ( dbfOferta )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
         ( dbfOferta )->( ordCreate( cPath + "OFERTA.CDX", "CARTOFE", "CARTOFE + CCODPR1 + CCODPR2 + CVALPR1 + CVALPR2", {|| Field->CARTOFE + Field->CCODPR1 + Field->CCODPR2 + Field->CVALPR1 + Field->CVALPR2 } ) )

         ( dbfOferta )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
         ( dbfOferta )->( ordCreate( cPath + "OFERTA.CDX", "CDESOFE", "CDESOFE", {|| Field->CDESOFE } ) )

         ( dbfOferta )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
         ( dbfOferta )->( ordCreate( cPath + "OFERTA.CDX", "DINIOFE", "DTOC( DINIOFE )", {|| DTOC( Field->DINIOFE ) } ) )

         ( dbfOferta )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
         ( dbfOferta )->( ordCreate( cPath + "OFERTA.CDX", "DFINOFE", "DTOC( DFINOFE )", {|| DTOC( Field->DFINOFE ) } ) )

         ( dbfOferta )->( dbCloseArea() )
      else
         msgStop( "Imposible abrir en modo exclusivo la tabla de ofertas" )
      end if

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos de ofertas" )

      CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN NIL

//--------------------------------------------------------------------------//

Function aItmOfe()

   local aBase := {}

   aAdd( aBase, { "CARTOFE",   "C",   18,    0, "Código del artículo de la oferta" }                     )
   aAdd( aBase, { "CDESOFE",   "C",   40,    0, "Descripción de la oferta" }                             )
   aAdd( aBase, { "DINIOFE",   "D",    8,    0, "Fecha inicio de la oferta" }                            )
   aAdd( aBase, { "DFINOFE",   "D",    8,    0, "Fecha final del la oferta" }                            )
   aAdd( aBase, { "NTIPOFE",   "N",    1,    0, "Tipo de oferta (1)-Precio (2)-Tipo X * Y" }             )
   aAdd( aBase, { "NMAXOFE",   "N",    6,    0, "Número de unidades maximas a vender de la oferta" }     )
   aAdd( aBase, { "NUDVOFE",   "N",    6,    0, "Número de unidades vendidas de la oferta" }             )
   aAdd( aBase, { "NPREOFE1",  "N",   16,    6, "Precio oferta 1" }                                      )
   aAdd( aBase, { "NPREOFE2",  "N",   16,    6, "Precio oferta 2" }                                      )
   aAdd( aBase, { "NPREOFE3",  "N",   16,    6, "Precio oferta 3" }                                      )
   aAdd( aBase, { "NPREOFE4",  "N",   16,    6, "Precio oferta 4" }                                      )
   aAdd( aBase, { "NPREOFE5",  "N",   16,    6, "Precio oferta 5" }                                      )
   aAdd( aBase, { "NPREOFE6",  "N",   16,    6, "Precio oferta 6" }                                      )
   aAdd( aBase, { "NPREIVA1",  "N",   16,    6, "Precio oferta con " + cImp() + " 1" }                   )
   aAdd( aBase, { "NPREIVA2",  "N",   16,    6, "Precio oferta con " + cImp() + " 2" }                   )
   aAdd( aBase, { "NPREIVA3",  "N",   16,    6, "Precio oferta con " + cImp() + " 3" }                   )
   aAdd( aBase, { "NPREIVA4",  "N",   16,    6, "Precio oferta con " + cImp() + " 4" }                   )
   aAdd( aBase, { "NPREIVA5",  "N",   16,    6, "Precio oferta con " + cImp() + " 5" }                   )
   aAdd( aBase, { "NPREIVA6",  "N",   16,    6, "Precio oferta con " + cImp() + " 6" }                   )
   aAdd( aBase, { "NUNVOFE",   "N",    3,    0, "Unidades a vender en la oferta" }                       )
   aAdd( aBase, { "NUNCOFE",   "N",    3,    0, "Unidades a cobrar en la oferta" }                       )
   aAdd( aBase, { "DFECCHG",   "D",    8,    0, "Fecha de cambio" }                                      )
   aAdd( aBase, { "NTIPXBY",   "N",    1,    0, "Tipo de oferta" }                                       )
   aAdd( aBase, { "NCLIOFE",   "N",    1,    0, "Tipo de cliente" }                                      )
   aAdd( aBase, { "CCLIOFE",   "C",   12,    0, "Código del cliente de la oferta" }                      )
   aAdd( aBase, { "CGRPOFE",   "C",    4,    0, "Código del grupo de cliente de la oferta" }             )
   aAdd( aBase, { "NDTOPCT",   "N",    6,    2, "Descuento porcentual %" }                               )
   aAdd( aBase, { "NDTOLIN",   "N",   16,    6, "Descuento lineal" }                                     )
   aAdd( aBase, { "CCODPR1",   "C",   20,    0, "Código de primera propiedad" }                          )
   aAdd( aBase, { "CCODPR2",   "C",   20,    0, "Código de segunda propiedad" }                          )
   aAdd( aBase, { "CVALPR1",   "C",   20,    0, "Valor de primera propiedad" }                           )
   aAdd( aBase, { "CVALPR2",   "C",   20,    0, "Valor de segunda propiedad" }                           )
   aAdd( aBase, { "LLABEL",    "L",    1,    0, "Lógico de selección de etiqueta"  }                     )
   aAdd( aBase, { "NLABEL",    "N",    5,    0, "Número de etiquetas a imprimir"   }                     )
   aAdd( aBase, { "LIVAINC",   "L",    1,    0, "Lógico " + cImp() + " incluido"   }                     )
   aAdd( aBase, { "NUNDMIN",   "N",   16,    6, "Unidades mínimas para aplicar la oferta"   }            )
   aAdd( aBase, { "NTBLOFE",   "N",    1,    0, "Tabla a la que aplicamos la oferta"   }                 )
   aAdd( aBase, { "NCAJMIN",   "N",   16,    6, "Cajas mínimas para aplicar la oferta" }                 )
   aAdd( aBase, { "NIMPMIN",   "N",   16,    6, "Importe mínimo para aplicar la oferta" }                )
   aAdd( aBase, { "NMINCAN",   "N",    1,    0, "aplicar por importe o por canticad"   }                 )
   aAdd( aBase, { "NMINTIP",   "N",    1,    0, "Aplicar a cajas o a unidades"   }                       )

Return ( aBase )

//---------------------------------------------------------------------------//

function ChangeComboTipo( aoGet, aBlank, nValDiv, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oCombo, cCodArt )

   if nMode == APPD_MODE          .and.;
      !Empty( aoGet[ _CARTOFE ] ) .and.;
      !Empty( oCombo )

      /*
      Cambiamos el bchange y el bvalid dependiendo del origen------------------
      */

      do case
         case oCombo:nAt < 2
            aoGet[ _CARTOFE ]:bHelp  := {|| BrwArticulo( aoGet[ _CARTOFE ], aoGet[ _CDESOFE ] ) }
            aoGet[ _CARTOFE ]:bValid := {|| loaArt( aoGet, aBlank, nValDiv, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2 ) }

         case oCombo:nAt == 2
            aoGet[ _CARTOFE ]:bHelp  := {|| BrwFamilia( aoGet[ _CARTOFE ], aoGet[ _CDESOFE] ) }
            aoGet[ _CARTOFE ]:bValid := {|| cFamilia( aoGet[ _CARTOFE ], dbfFamilia, aoGet[ _CDESOFE ] ) }

         case oCombo:nAt == 3
            aoGet[ _CARTOFE ]:bHelp  := {|| oTipArt:Buscar( aoGet[ _CARTOFE ] ) }
            aoGet[ _CARTOFE ]:bValid := {|| oTipArt:Existe( aoGet[ _CARTOFE ], aoGet[ _CDESOFE ] ) }

         case oCombo:nAt == 5
            aoGet[ _CARTOFE ]:bHelp  := {|| BrwTemporada( aoGet[ _CARTOFE ], aoGet[ _CDESOFE ] ) }
            aoGet[ _CARTOFE ]:bValid := {|| cTemporada( aoGet[ _CARTOFE ], dbfTemporada, aoGet[ _CDESOFE ] ) }

         case oCombo:nAt == 6
            aoGet[ _CARTOFE ]:bHelp  := {|| oFabricante:Buscar( aoGet[ _CARTOFE ] ) }
            aoGet[ _CARTOFE ]:bValid := {|| oFabricante:Existe( aoGet[ _CARTOFE ], aoGet[ _CDESOFE ] ) }

      end case

      /*
      Limpiamos los campos cuando cambiamos el combo del origen----------------
      */

      if Empty( cCodArt )
         aoGet[ _CARTOFE ]:cText( Space( 18 ) )
         aoGet[ _CDESOFE ]:cText( Space( 40 ) )
      end if

   end if

return .t.

//---------------------------------------------------------------------------//

Static Function CreateFiles( cPath )

   DEFAULT cPath  := cPatArt()

   dbCreate( cPath + "OFERTA.DBF", aSqlStruct( aItmOfe() ), cLocalDriver() )

   rxOferta( cPath, cLocalDriver() )

Return nil

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TOfertaLabelGenerator

   Data oDlg
   Data oFld

   Data oCriterio
   Data cCriterio
   Data aCriterio

   Data oFamiliaInicio
   Data cFamiliaInicio

   Data oFamiliaFin
   Data cFamiliaFin

   Data oFechaInicio
   Data dFechaInicio

   Data oFechaFin
   Data dFechaFin

   Data oInicio
   Data oFin

   Data oFormatoLabel
   Data cFormatoLabel

   Data nFilaInicio
   Data nColumnaInicio

   Data cFileTmpLabel
   Data cAreaTmpLabel

   Data oBrwLabel

   Data nCantidadLabels
   Data nUnidadesLabels

   Data oMtrLabel
   Data nMtrLabel

   Data hBmp

   Data oBtnListado
   Data oBtnSiguiente
   Data oBtnAnterior
   Data oBtnCancel
   Data oBtnPropiedades

   Data aSearch

   Method Create()
   Method End()

   Method lDefault()

   Method BotonAnterior()

   Method BotonSiguiente()

   Method PutLabel()

   Method SelectAllLabels()

   Method SelectPropertiesLabels()

   Method SavePropertiesLabels()

   Method LoadPropertiesLabels()

   Method SelectCriterioLabels()

   Method PutStockLabels()

   Method AddLabel()

   Method DelLabel()

   Method EditLabel()

   Method ChangeCriterio()

   Method lPrintLabels()

   Method InitLabel( oLabel )

   Method lCreateTemporal()

   Method PrepareTemporal()

   Method DestroyTemporal()

   Method SelectColumn( oCombo )

END CLASS

//----------------------------------------------------------------------------//

Method lDefault() CLASS TOfertaLabelGenerator

   local oError
   local oBlock
   local lError         := .f.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   ::cCriterio          := "Ningún criterio"
   ::aCriterio          := { "Ningún criterio", "Todos los registros", "Fecha inicio", "Fecha fin" }

   ::cFamiliaInicio    := "" // ( dbfOferta )->Familia
   ::cFamiliaFin       := "" // ( dbfOferta )->Familia

   ::dFechaInicio       := Ctod( "01/" + Str( Month( Date() ), 2 ) + "/" + Str( Year( Date() ), 4 ) )
   ::dFechaFin          := GetSysDate()

   ::cFormatoLabel      := GetPvProfString( "Etiquetas", "Oferta", Space( 3 ), cIniEmpresa() )
   if len( ::cFormatoLabel ) < 3
      ::cFormatoLabel   := Space( 3 )
   end if

   ::nMtrLabel          := 0

   ::nFilaInicio        := 1
   ::nColumnaInicio     := 1

   ::nCantidadLabels    := 1
   ::nUnidadesLabels    := 1

   ::aSearch            := { "Código", "Nombre" }

   RECOVER USING oError

      lError            := .t.

      msgStop( "Error en la creación de generador de etiquetas" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE
   ErrorBlock( oBlock )

Return ( !lError )

//--------------------------------------------------------------------------//

Method Create() CLASS TOfertaLabelGenerator

   local oGetOrd
   local cGetOrd     := Space( 100 )
	local oCbxOrd
   local cCbxOrd     := "Código"
   local aCbxOrd     := { "Código", "Nombre" }

   if ::lDefault()

      DEFINE DIALOG ::oDlg RESOURCE "SelectLabels_0"

         REDEFINE PAGES ::oFld ;
            ID       10;
            OF       ::oDlg ;
            DIALOGS  "SelectLabels_3",;
                     "SelectLabels_2"

         /*
         Bitmap-------------------------------------------------------------------
         */

         REDEFINE BITMAP ;
            RESOURCE "gc_portable_barcode_scanner_48" ;
            ID       500 ;
            TRANSPARENT ;
            OF       ::oDlg ;

         REDEFINE COMBOBOX ::oCriterio VAR ::cCriterio ;
            ITEMS    ::aCriterio ;
            ID       90 ;
            OF       ::oFld:aDialogs[1]

         ::oCriterio:bChange        := {|| ::ChangeCriterio() }

         REDEFINE GET ::oFamiliaInicio VAR ::cFamiliaInicio ;
            ID       100 ;
            IDTEXT   101 ;
            BITMAP   "LUPA" ;
            OF       ::oFld:aDialogs[1]

         //::oFamiliaInicio:bValid    := {|| cFamilia( ::oFamiliaInicio, dbfFam, ::oFamiliaInicio:oHelpText ), .t. }
         //::oFamiliaInicio:bHelp     := {|| BrwFamilia( ::oFamiliaInicio, ::oFamiliaInicio:oHelpText ) }

         REDEFINE SAY ::oInicio ;
            ID       102 ;
            OF       ::oFld:aDialogs[1]

         REDEFINE GET ::oFamiliaFin VAR ::cFamiliaFin ;
            ID       110 ;
            IDTEXT   111 ;
            BITMAP   "LUPA" ;
            OF       ::oFld:aDialogs[1]

         //::oFamiliaFin:bValid       := {|| cFamilia( ::oFamiliaFin, dbfFam, ::oFamiliaFin:oHelpText ), .t. }
         //::oFamiliaFin:bHelp        := {|| BrwFamilia( ::oFamiliaFin, ::oFamiliaFin:oHelpText ) }

         REDEFINE SAY ::oFin ;
            ID       112 ;
            OF       ::oFld:aDialogs[1]

         REDEFINE GET ::oFechaInicio VAR ::dFechaInicio ;
            SPINNER ;
            ID       120 ;
            OF       ::oFld:aDialogs[1]

         REDEFINE GET ::oFechaFin VAR ::dFechaFin ;
            SPINNER ;
            ID       130 ;
            OF       ::oFld:aDialogs[1]

         REDEFINE GET ::oFormatoLabel VAR ::cFormatoLabel ;
            ID       160 ;
            IDTEXT   161 ;
            BITMAP   "LUPA" ;
            OF       ::oFld:aDialogs[1]

            ::oFormatoLabel:bValid  := {|| cDocumento( ::oFormatoLabel, ::oFormatoLabel:oHelpText, dbfDoc, "OF" ) }
            ::oFormatoLabel:bHelp   := {|| BrwDocumento( ::oFormatoLabel, ::oFormatoLabel:oHelpText, "OF" ) }

         TBtnBmp():ReDefine( 220, "gc_document_text_pencil_12",,,,,{|| EdtDocumento( ::cFormatoLabel ) }, ::oFld:aDialogs[1], .f., , .f., "Modificar formato de etiquetas" )

         REDEFINE GET ::nFilaInicio ;
            ID       180 ;
            PICTURE  "999" ;
            SPINNER ;
            OF       ::oFld:aDialogs[1]

         REDEFINE GET ::nColumnaInicio ;
            ID       190 ;
            PICTURE  "999" ;
            SPINNER ;
            OF       ::oFld:aDialogs[1]

         REDEFINE RADIO ::nCantidadLabels ;
            ID       200, 201 ;
            OF       ::oFld:aDialogs[1]

         REDEFINE GET ::nUnidadesLabels ;
            ID       210 ;
            PICTURE  "99999" ;
            SPINNER ;
            MIN      1 ;
            MAX      99999 ;
            WHEN     ( ::nCantidadLabels == 1 ) ;
            OF       ::oFld:aDialogs[1]

         /*
         Segunda caja de dialogo--------------------------------------------------
         */

         REDEFINE GET oGetOrd ;
            VAR      cGetOrd;
            ID       200 ;
            BITMAP   "FIND" ;
            OF       ::oFld:aDialogs[2]

         oGetOrd:bChange   := {| nKey, nFlags, oGet | AutoSeek( nKey, nFlags, oGet, ::oBrwLabel, dbfOferta ) }
         oGetOrd:bValid    := {|| ( dbfOferta )->( OrdScope( 0, nil ) ), ( dbfOferta )->( OrdScope( 1, nil ) ), ::oBrwLabel:Refresh(), .t. }

         REDEFINE COMBOBOX oCbxOrd ;
            VAR      cCbxOrd ;
            ID       210 ;
            ITEMS    aCbxOrd ;
            OF       ::oFld:aDialogs[2]

         oCbxOrd:bChange   := {|| ::SelectColumn( oCbxOrd ) }

         REDEFINE BUTTON ;
            ID       100 ;
            OF       ::oFld:aDialogs[2] ;
            ACTION   ( ::PutLabel() )

         REDEFINE BUTTON ;
            ID       110 ;
            OF       ::oFld:aDialogs[2] ;
            ACTION   ( ::SelectAllLabels( .t. ) )

         REDEFINE BUTTON ;
            ID       120 ;
            OF       ::oFld:aDialogs[2] ;
            ACTION   ( ::SelectAllLabels( .f. ) )

         REDEFINE BUTTON ::oBtnPropiedades ;
            ID       220 ;
            OF       ::oFld:aDialogs[2] ;
            ACTION   ( nil ) // ::SelectPropertiesLabels( .f. )

         REDEFINE BUTTON ;
            ID       130 ;
            OF       ::oFld:aDialogs[2] ;
            ACTION   ( ::AddLabel() )

         REDEFINE BUTTON ;
            ID       140 ;
            OF       ::oFld:aDialogs[2] ;
            ACTION   ( ::DelLabel() )

         REDEFINE BUTTON ;
            ID       150 ;
            OF       ::oFld:aDialogs[2] ;
            ACTION   ( ::EditLabel() )

         REDEFINE BUTTON ;
            ID       160 ;
            OF       ::oFld:aDialogs[2] ;
            ACTION   ( WinEdtRec( ::oBrwLabel, bEdit, dbfOferta, .f., cDefIva() ) )

         REDEFINE BUTTON ;
            ID       165 ;
            OF       ::oFld:aDialogs[2] ;
            ACTION   ( WinZooRec( ::oBrwLabel, bEdit, dbfOferta, .f., cDefIva() ) )

         ::oBrwLabel                 := IXBrowse():New( ::oFld:aDialogs[2] )

         ::oBrwLabel:nMarqueeStyle   := 5
         ::oBrwLabel:nColSel         := 2

         ::oBrwLabel:lHScroll        := .f.
         ::oBrwLabel:cAlias          := dbfOferta

         ::oBrwLabel:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
         ::oBrwLabel:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }
         ::oBrwLabel:bLDblClick      := {|| ::PutLabel() }

         ::oBrwLabel:CreateFromResource( 180 )

         with object ( ::oBrwLabel:AddCol() )
            :cHeader          := "Sl. Seleccionada"
            :bEditValue       := {|| ( dbfOferta )->lLabel }
            :nWidth           := 20
            :SetCheck( { "Sel16", "Nil16" } )
         end with

         with object ( ::oBrwLabel:AddCol() )
            :cHeader          := "Código"
            :bEditValue       := {|| ( dbfOferta )->cArtOfe }
            :nWidth           := 80
            :cSortOrder       := "cArtOfe"
            :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
         end with

         with object ( ::oBrwLabel:AddCol() )
            :cHeader          := "Nombre"
            :bEditValue       := {|| ( dbfOferta )->cDesOfe }
            :nWidth           := 280
            :cSortOrder       := "cDesOfe"
            :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
         end with

         with object ( ::oBrwLabel:AddCol() )
            :cHeader          := "N. etiquetas"
            :bEditValue       := {|| ( dbfOferta )->nLabel }
            :cEditPicture     := "@E 99,999"
            :nWidth           := 80
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
            :nEditType        := 1
            :bOnPostEdit      := {|o,x| if( dbDialogLock( dbfOferta ), ( ( dbfOferta )->nLabel := x, ( dbfOferta )->( dbUnlock() ) ), ) }
         end with

   REDEFINE APOLOMETER ::oMtrLabel ;
            VAR      ::nMtrLabel ;
            PROMPT   "" ;
            ID       190 ;
            OF       ::oFld:aDialogs[2] ;
            TOTAL    ( dbfOferta )->( lastrec() )

         ::oMtrLabel:nClrText   := rgb( 128,255,0 )
         ::oMtrLabel:nClrBar    := rgb( 128,255,0 )
         ::oMtrLabel:nClrBText  := rgb( 128,255,0 )

         /*
         Botones generales--------------------------------------------------------
         */

         REDEFINE BUTTON ::oBtnListado ;          // Boton listado
            ID       40 ;
            OF       ::oDlg ;
            ACTION   ( nil  )

         REDEFINE BUTTON ::oBtnAnterior ;          // Boton anterior
            ID       20 ;
            OF       ::oDlg ;
            ACTION   ( ::BotonAnterior() )

         REDEFINE BUTTON ::oBtnSiguiente ;         // Boton de Siguiente
            ID       30 ;
            OF       ::oDlg ;
            ACTION   ( ::BotonSiguiente() )

         REDEFINE BUTTON ::oBtnCancel ;            // Boton de Siguiente
            ID       IDCANCEL ;
            OF       ::oDlg ;
            ACTION   ( ::oDlg:End() )

      ::oDlg:bStart  := {|| ::oBtnAnterior:Hide(), ::oBtnListado:Hide(), ::oBtnPropiedades:Hide(), ::ChangeCriterio(), ::oFormatoLabel:lValid() }

      ACTIVATE DIALOG ::oDlg CENTER

      ::End()

   end if

Return ( Self )

//--------------------------------------------------------------------------//

Method BotonAnterior() CLASS TOfertaLabelGenerator

   ::oFld:GoPrev()

   ::oBtnAnterior:Hide()

   SetWindowText( ::oBtnSiguiente:hWnd, "Siguien&te >" )

Return ( Self )

//--------------------------------------------------------------------------//

Method BotonSiguiente() CLASS TOfertaLabelGenerator

   do case
      case ::oFld:nOption == 1

         if Empty( ::cFormatoLabel )

            MsgStop( "Debe cumplimentar un formato de etiquetas" )

         else

            ::oFld:GoNext()
            ::oBtnAnterior:Show()

            ::SelectCriterioLabels()

            SetWindowText( ::oBtnSiguiente:hWnd, "&Terminar" )

         end if

      case ::oFld:nOption == 2

         if ::lPrintLabels()

            SetWindowText( ::oBtnCancel:hWnd, "&Cerrar" )

         end if

   end case

Return ( Self )

//--------------------------------------------------------------------------//

Method End() CLASS TOfertaLabelGenerator

   WritePProString( "Etiquetas", "Oferta", ::cFormatoLabel, cIniEmpresa() )

Return ( Self )

//--------------------------------------------------------------------------//

Method PutLabel() CLASS TOfertaLabelGenerator

   if dbLock( dbfOferta )
      ( dbfOferta )->lLabel := !( dbfOferta )->lLabel
      ( dbfOferta )->( dbUnLock() )
   end if

   ::oBrwLabel:Refresh()
   ::oBrwLabel:SetFocus()

Return ( Self )

//--------------------------------------------------------------------------//

Method SelectAllLabels( lSelect ) CLASS TOfertaLabelGenerator

	local n			:= 0
   local nRecno   := ( dbfOferta )->( Recno() )

	CursorWait()

   ::oDlg:Disable()

   ( dbfOferta )->( dbGoTop() )
   while !( dbfOferta )->( eof() )

      if ( dbfOferta )->lLabel != lSelect

         if dbLock( dbfOferta )
            ( dbfOferta )->lLabel := lSelect
            ( dbfOferta )->( dbUnLock() )
         end if

      end if

      ( dbfOferta )->( dbSkip() )

      ::oMtrLabel:Set( ++n )

   end while

   ( dbfOferta )->( dbGoTo( nRecno ) )

   ::oBrwLabel:Refresh()

   ::oMtrLabel:Set( 0 )
   ::oMtrLabel:Refresh()

   ::oDlg:Enable()

   CursorArrow()

Return ( Self )

//--------------------------------------------------------------------------//

Method SelectCriterioLabels() CLASS TOfertaLabelGenerator

	local n			:= 0
   local nRecno   := ( dbfOferta )->( Recno() )

   CursorWait()

   ::oDlg:Disable()

   ( dbfOferta )->( dbGoTop() )
   while !( dbfOferta )->( eof() )

      do case
         case ::oCriterio:nAt == 2

            ::PutStockLabels()

         case ::oCriterio:nAt == 3 .and. ( dbfOferta )->dIniOfe >= ::dFechaInicio .and. ( dbfOferta )->dIniOfe <= ::dFechaFin

            ::PutStockLabels()

         case ::oCriterio:nAt == 4 .and. ( dbfOferta )->dFinOfe >= ::dFechaInicio .and. ( dbfOferta )->dFinOfe <= ::dFechaFin

            ::PutStockLabels()

         otherwise

            ::PutStockLabels()

      end case

      ( dbfOferta )->( dbSkip() )

      ::oMtrLabel:Set( ++n )

   end while

   ::oBrwLabel:Refresh()

   ::oMtrLabel:Set( 0 )
   ::oMtrLabel:Refresh()

   ( dbfOferta )->( dbGoTo( nRecno ) )

	CursorArrow()

   ::oDlg:Enable()

Return ( Self )

//--------------------------------------------------------------------------//

Method PutStockLabels() CLASS TOfertaLabelGenerator

   local nStock                        := 0

   if ( ::nCantidadLabels == 1 )
      nStock                           := ::nUnidadesLabels
   else
      nStock                           := oStock:nStockAlmacen( ( dbfOferta )->cArtOfe, , ( dbfOferta )->cValPr1, ( dbfOferta )->cValPr2 )
   end if

   if dbLock( dbfOferta )
      ( dbfOferta )->lLabel            := .t.
      ( dbfOferta )->nLabel            := Max( nStock, 0 )
      ( dbfOferta )->( dbUnLock() )
   end if

Return ( Self )

//--------------------------------------------------------------------------//

Method SelectPropertiesLabels() CLASS TOfertaLabelGenerator

   local n
   local oDlg
   local aTblPrp
   local oBrwPrp

   if !Empty( ( dbfOferta )->cCodPrp1 ) .or. !Empty( ( dbfOferta )->cCodPrp2 )

      aTblPrp                       := LoadPropertiesTable( ( dbfOferta )->cArtOfe, nCosto( ( dbfOferta )->cArtOfe, dbfOferta, dbfArtKit ), ( dbfOferta )->cCodPrp1, ( dbfOferta )->cCodPrp2, dbfPro, dbfTblPro, dbfArtVta )

      ::LoadPropertiesLabels( aTblPrp )

      DEFINE DIALOG oDlg RESOURCE "Propiedades"

      oBrwPrp                       := IXBrowse():New( oDlg )

      oBrwPrp:nDataType             := DATATYPE_ARRAY

      oBrwPrp:bClrSel               := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwPrp:bClrSelFocus          := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwPrp:lHScroll              := .t.
      oBrwPrp:lVScroll              := .t.

      oBrwPrp:nMarqueeStyle         := 3
      oBrwPrp:lRecordSelector       := .f.
      oBrwPrp:lFastEdit             := .t.
      oBrwPrp:nFreeze               := 1
      oBrwPrp:lFooter               := .t.

      oBrwPrp:SetArray( aTblPrp )

      for n := 1 to len( aTblPrp[ 1 ] )

         with object ( oBrwPrp:aCols[ n ] )

            :cHeader          := aTblPrp[ oBrwPrp:nArrayAt, n ]:cHead

            if IsNil( aTblPrp[ oBrwPrp:nArrayAt, n ]:Value )
               :bEditValue    := bGenEditText( aTblPrp, oBrwPrp, n )
               :nWidth        := 80
               :bFooter       := {|| "Total" }
            else
               :bEditValue    := bGenEditValue( aTblPrp, oBrwPrp, n )
               :cEditPicture  := MasUnd()
               :nWidth        := 60
               :nEditType     := 1 // EDIT_GET
               :nTotal        := 0
               :bOnPostEdit   := {| oCol, xVal, nKey | aTblPrp[ oBrwPrp:nArrayAt, oBrwPrp:nColSel + oBrwPrp:nColOffset - 1 ]:Value := xVal } // , oBrwPrp:MakeTotals()
            end if

         end with

      next

      oBrwPrp:MakeTotals()

      oBrwPrp:CreateFromResource( 100 )

      REDEFINE BUTTON;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( ::SavePropertiesLabels( aTblPrp, oDlg ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      oDlg:AddFastKey( VK_F5, {|| ::SavePropertiesLabels( aTblPrp, oDlg ) } )

      ACTIVATE DIALOG oDlg CENTER

   else

      MsgStop( "Este artículo no tiene propiedades." )

   end if

Return ( Self )

//--------------------------------------------------------------------------//

Method SavePropertiesLabels( aTblPrp, oDlg ) CLASS TOfertaLabelGenerator

   local o
   local a
   local n  := 0
   local c  := ""

   while ( dbfArtLbl )->( dbSeek( ( dbfOferta )->cArtOfe ) ) .and. !( dbfArtLbl )->( eof() )
      if dbLock( dbfArtLbl )
         ( dbfArtLbl )->( dbDelete() )
         ( dbfArtLbl )->( dbUnLock() )
      end if
   end while

   for each a in ( aTblPrp )

      for each o in ( a )

         if IsNum( o:Value ) .and. ( o:Value != 0 )

            if dbAppe( dbfArtLbl )
               ( dbfArtLbl )->cCodArt  := o:cCodigo
               ( dbfArtLbl )->cCodPr1  := o:cCodigoPropiedad1
               ( dbfArtLbl )->cCodPr2  := o:cCodigoPropiedad2
               ( dbfArtLbl )->cValPr1  := o:cValorPropiedad1
               ( dbfArtLbl )->cValPr2  := o:cValorPropiedad2
               ( dbfArtLbl )->nUndLbl  := o:Value
               ( dbfArtLbl )->( dbUnLock() )
            end if

            n  += o:Value

         end if

      next

   next

   if dbLock( dbfOferta )
      ( dbfOferta )->nLabel := n
      ( dbfOferta )->( dbUnLock() )
   end if

   ::oBrwLabel:Refresh()
   ::oBrwLabel:SetFocus()

   oDlg:end( IDOK )

Return ( .t. )

//--------------------------------------------------------------------------//

Method LoadPropertiesLabels( aTblPrp ) CLASS TOfertaLabelGenerator

   local o
   local a

   if ( dbfArtLbl )->( dbSeek( ( dbfOferta )->cArtOfe ) )

      while ( dbfArtLbl )->cCodArt == ( dbfOferta )->cArtOfe .and. !( dbfArtLbl )->( eof() )

         for each a in ( aTblPrp )

            for each o in ( a )

               if Rtrim( o:cCodigo )            == Rtrim( ( dbfArtLbl )->cCodArt )  .and. ;
                  Rtrim( o:cCodigoPropiedad1 )  == Rtrim( ( dbfArtLbl )->cCodPr1 )  .and. ;
                  Rtrim( o:cCodigoPropiedad2 )  == Rtrim( ( dbfArtLbl )->cCodPr2 )  .and. ;
                  Rtrim( o:cValorPropiedad1 )   == Rtrim( ( dbfArtLbl )->cValPr1 )  .and. ;
                  Rtrim( o:cValorPropiedad2 )   == Rtrim( ( dbfArtLbl )->cValPr2 )

                  o:Value  := ( dbfArtLbl )->nUndLbl

               end if

            next

         next

         ( dbfArtLbl )->( dbSkip() )

      end while

   end if

Return ( aTblPrp )

//--------------------------------------------------------------------------//

Static Function bGenEditText( aTblPrp, oBrwPrp, n )

Return ( {|| aTblPrp[ oBrwPrp:nArrayAt, n ]:cText } )

//--------------------------------------------------------------------------//

Static Function bGenEditValue( aTblPrp, oBrwPrp, n )

Return ( {|| aTblPrp[ oBrwPrp:nArrayAt, n ]:Value } )

//--------------------------------------------------------------------------//

Method AddLabel() CLASS TOfertaLabelGenerator

   if dbLock( dbfOferta )
      ( dbfOferta )->nLabel++
      ( dbfOferta )->( dbUnLock() )
   end if

   ::oBrwLabel:Refresh()
   ::oBrwLabel:SetFocus()

Return ( Self )

//--------------------------------------------------------------------------//

Method DelLabel() CLASS TOfertaLabelGenerator

   if ( dbfOferta )->nLabel > 1
      if dbLock( dbfOferta )
         ( dbfOferta )->nLabel--
         ( dbfOferta )->( dbUnLock() )
      end if
   end if

   ::oBrwLabel:Refresh()
   ::oBrwLabel:SetFocus()

Return ( Self )

//---------------------------------------------------------------------------//

Method EditLabel() CLASS TOfertaLabelGenerator

   ::oBrwLabel:aCols[ 4 ]:Edit()

Return ( Self )

//---------------------------------------------------------------------------//

Method ChangeCriterio() CLASS TOfertaLabelGenerator

   ::oFamiliaInicio:Hide()
   ::oFamiliaFin:Hide()

   ::oInicio:Hide()
   ::oFin:Hide()

   ::oFechaInicio:Hide()
   ::oFechaFin:Hide()

   do case
      case ::oCriterio:nAt == 3

         ::oFechaInicio:Show()
         ::oFechaFin:Show()
         ::oInicio:Show()
         ::oFin:Show()

      case ::oCriterio:nAt == 4

         ::oFechaInicio:Show()
         ::oFechaFin:Show()
         ::oInicio:Show()
         ::oFin:Show()

   end case

Return ( Self )

//---------------------------------------------------------------------------//

Method lCreateTemporal() CLASS TOfertaLabelGenerator

   local n
   local nRec
   local oBlock
   local oError
   local nBlancos
   local lCreateTemporal   := .t.
   local lCloseOferta      := .f.
   local lCloseLabel       := .f.

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      tmpOferta            := "LblArt"
      filOferta            := cGetNewFileName( cPatTmp() + "LblAlb" )

      dbCreate( filOferta, aSqlStruct( aItmOfe() ), cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), filOferta, tmpOferta, .f. )

      ( tmpOferta )->( OrdCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( tmpOferta )->( OrdCreate( filOferta, "Codigo", "Codigo", {|| Field->cArtOfe } ) )

      /*
      Proceso de paso a temporales---------------------------------------------
      */

      nRec                 := ( dbfOferta )->( Recno() )

      ( dbfOferta )->( dbGoTop() )
      while !( dbfOferta )->( eof() )

         if ( dbfOferta )->lLabel

            for n := 1 to ( dbfOferta )->nLabel
               dbPass( dbfOferta, tmpOferta, .t. )
            next

         end if

         ( dbfOferta )->( dbSkip() )

      end while

      ( dbfOferta )->( dbGoTo( nRec ) )

      ( tmpOferta )->( dbGoTop() )

      /*
      Cerramos las tablas------------------------------------------------------
      */

   RECOVER USING oError

      lCreateTemporal      := .f.

      MsgStop( 'Imposible crear tabla temporal de ofertas' + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lCreateTemporal )

//---------------------------------------------------------------------------//

Method PrepareTemporal( oFr ) CLASS TOfertaLabelGenerator

   local n
   local nBlancos       := 0
   local nPaperHeight   := oFr:GetProperty( "MainPage", "PaperHeight" ) * fr01cm
   local nHeight        := oFr:GetProperty( "MasterData", "Height" )
   local nColumns       := oFr:GetProperty( "MainPage", "Columns" )
   local nItemsInColumn := 0

   if !Empty( nPaperHeight ) .and. !Empty( nHeight ) .and. !Empty( nColumns )

      nItemsInColumn    := int( nPaperHeight / nHeight )

      nBlancos          := ( ::nColumnaInicio - 1 ) * nItemsInColumn
      nBlancos          += ( ::nFilaInicio - 1 )

   end if 

   for n := 1 to nBlancos
      dbPass( dbBlankRec( dbfOferta ), tmpOferta, .t. )
   next

   ( tmpOferta )->( dbGoTop() )

Return ( .t. )

//---------------------------------------------------------------------------//

Method DestroyTemporal() CLASS TOfertaLabelGenerator

   if ( tmpOferta )->( Used() )
      ( tmpOferta )->( dbCloseArea() )
   end if

   dbfErase( filOferta )

Return ( .t. )

//---------------------------------------------------------------------------//

Method lPrintLabels() CLASS TOfertaLabelGenerator

   local oFr

   if !::lCreateTemporal()
      Return .f.
   end if

   SysRefresh()

   oFr                  := frReportManager():New()

   oFr:LoadLangRes(     "Spanish.Xml" )

   oFr:SetIcon( 1 )

   oFr:SetTitle(        "Diseñador de documentos" )

   /*
   Manejador de eventos--------------------------------------------------------
   */

   oFr:SetEventHandler( "Designer", "OnSaveReport", {|| oFr:SaveToBlob( ( dbfDoc )->( Select() ), "mReport" ) } )

   /*
   Zona de datos---------------------------------------------------------------
   */

   DataReport( oFr, .t. )

   /*
   Cargar el informe-----------------------------------------------------------
   */

   if !Empty( ( dbfDoc )->mReport )

      oFr:LoadFromBlob( ( dbfDoc )->( Select() ), "mReport")

      /*
      Necesidad de incluir espacion en blancos---------------------------------
      */

      ::PrepareTemporal( oFr )

      /*
      Preparar el report-------------------------------------------------------
      */

      oFr:PrepareReport()

      /*
      Imprimir el informe------------------------------------------------------
      */

      oFr:ShowPreparedReport()

   else

      msgStop( "El informe no contiene información" )

   end if

   /*
   Destruye el diseñador-------------------------------------------------------
   */

   oFr:DestroyFr()

   /*
   Destruye el fichero temporal------------------------------------------------
   */

   ::DestroyTemporal()

Return .t.

//---------------------------------------------------------------------------//

Method InitLabel( oLabel ) CLASS TOfertaLabelGenerator

   local nStartRow

   if ::nFilaInicio > 1
      nStartRow            := oLabel:nStartRow
      nStartRow            += ( ::nFilaInicio - 1 ) * ( oLabel:nLblHeight + oLabel:nVSeparator )

      if nStartRow < oLabel:nBottomRow
         oLabel:nStartRow  := nStartRow
      end if
   end if

   if ::nColumnaInicio > 1 .and. ::nColumnaInicio <= oLabel:nLblOnLine
      oLabel:nLblCurrent   := ::nColumnaInicio
   end if

Return ( Self )

//---------------------------------------------------------------------------//

Method SelectColumn( oCombo ) CLASS TOfertaLabelGenerator

   local oCol
   local cOrd                    := oCombo:VarGet()

   if ::oBrwLabel != nil

      with object ::oBrwLabel

         for each oCol in :aCols

            if Equal( cOrd, oCol:cHeader )
               oCol:cOrder       := "A"
               oCol:SetOrder()
            else
               oCol:cOrder       := " "
            end if

         next

      end with

      ::oBrwLabel:Refresh()

   end if

Return ( Self )

//---------------------------------------------------------------------------//

Static Function lLabel( dbfTmpLbl )

   oMsgProgress():Deltapos( 1 )

Return ( ( dbfTmpLbl )->lLabel )

//---------------------------------------------------------------------------//

Static Function SkipLabel( dbfOferta, oMtr )

   if ( dbfOferta )->lLabel .and. ( dbfOferta )->nLabel > nLabels
      ++nLabels
   else
      nLabels  := 1
      ( dbfOferta )->( dbSkip() )
   end if

   if !Empty( oMtr )
      oMtr:Set( ( dbfOferta )->( ordKeyNo() ) )
   end if

Return ( ( dbfOferta )->( Recno() ) )

//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//

Static Function DataReport( oFr, lTemporal )

   local oError
   local oBlock

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   /*
   Zona de datos------------------------------------------------------------
   */

   oFr:ClearDataSets()

   if lTemporal
      oFr:SetWorkArea(     "Ofertas", ( tmpOferta )->( Select() ), .f., { FR_RB_FIRST, FR_RE_LAST, 0 } )
   else
      oFr:SetWorkArea(     "Ofertas", ( dbfOferta )->( Select() ), .f., { FR_RB_FIRST, FR_RE_LAST, 0 } )
   end if
   oFr:SetFieldAliases(    "Ofertas", cItemsToReport( aItmOfe() ) )

   oFr:SetWorkArea(        "Artículos", ( dbfArticulo )->( Select() ) )
   oFr:SetFieldAliases(    "Artículos", cItemsToReport( aItmArt() ) )

   oFr:SetWorkArea(        "Familias", ( dbfFamilia )->( Select() ) )
   oFr:SetFieldAliases(    "Familias", cItemsToReport( aItmFam() ) )

   oFr:SetWorkArea(        "Códigos de barras", ( dbfCodebar )->( Select() ) )
   oFr:SetFieldAliases(    "Códigos de barras", cItemsToReport( aItmBar() ) )

   oFr:SetWorkArea(        "Unidad de medición",  oUndMedicion:Select() )
   oFr:SetFieldAliases(    "Unidad de medición",  cObjectsToReport( oUndMedicion:oDbf ) )

   if lTemporal
      oFr:SetMasterDetail( "Ofertas",        "Artículos",               {|| ( tmpOferta )->cArtOfe } )
   else
      oFr:SetMasterDetail( "Ofertas",        "Artículos",               {|| ( dbfOferta )->cArtOfe } )
   end if

   oFr:SetMasterDetail(    "Artículos",      "Familias",                {|| ( dbfArticulo )->Familia } )
   oFr:SetMasterDetail(    "Artículos",      "Códigos de barras",       {|| ( dbfArticulo )->Codigo } )
   oFr:SetMasterDetail(    "Artículos",      "Unidad de medición",      {|| ( dbfArticulo )->cUnidad } )

   oFr:SetResyncPair(      "Ofertas",        "Artículos" )
   oFr:SetResyncPair(      "Artículos",      "Familias" )
   oFr:SetResyncPair(      "Artículos",      "Códigos de barras" )
   oFr:SetResyncPair(      "Artículos",      "Unidad de medición" )

   RECOVER USING oError

      msgStop( "Imposible crear data report" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return nil

//---------------------------------------------------------------------------//

Static Function VariableReport( oFr )

   /*
   Creación de variables----------------------------------------------------

   oFr:AddVariable(     "Artículos",      "Código de barras para primera propiedad",  "CallHbFunc('cArtBarPrp1')" )
   oFr:AddVariable(     "Artículos",      "Código de barras para segunda propiedad",  "CallHbFunc('cArtBarPrp2')" )
   */

Return nil

//---------------------------------------------------------------------------//

Function DesignReportOferta( oFr, dbfDoc )

   local oLabel
   local nOrdAnt
   local lOpen    := .f.
   local lFlag    := .f.

   /*
   Tratamiento para no hacer dos veces el openfiles al editar el documento en imprimir series
   */

   if lOpenFiles
      lFlag       := .t.
   else
      if Openfiles()
         lFlag    := .t.
         lOpen    := .t.
      else
         lFlag    := .f.
      end if
   end if

   if lFlag

      nOrdAnt     := ( dbfOferta )->( OrdSetFocus( "cArtOfe" ) )

      oLabel      := TOfertaLabelGenerator()

      if oLabel:lCreateTemporal()

         /*
         Zona de datos------------------------------------------------------------
         */

         DataReport( oFr, .t. )

         /*
         Paginas y bandas---------------------------------------------------------
         */

         if !Empty( ( dbfDoc )->mReport )

            oFr:LoadFromBlob( ( dbfDoc )->( Select() ), "mReport")

         else

            oFr:AddPage(         "MainPage" )

            oFr:AddBand(         "MasterData",  "MainPage",       frxMasterData )
            oFr:SetProperty(     "MasterData",  "Top",            200 )
            oFr:SetProperty(     "MasterData",  "Height",         100 )
            oFr:SetObjProperty(  "MasterData",  "DataSet",        "Ofertas" )

         end if

         /*
         Zona de variables--------------------------------------------------------
         */

         VariableReport( oFr )

         /*
         Diseño de report---------------------------------------------------------
         */

         oFr:DesignReport()

         /*
         Destruye el diseñador----------------------------------------------------
         */

         oFr:DestroyFr()

         /*
         Cierra ficheros----------------------------------------------------------
         */

         oLabel:DestroyTemporal()

      else

         lFlag    := .f.

      end if

   end if

   if lOpen
      CloseFiles()
   end if

Return ( lFlag )

//---------------------------------------------------------------------------//

Function PrintReportOferta( nDevice, nCopies, cPrinter, dbfDoc )

   local oFr

   DEFAULT nDevice      := IS_SCREEN
   DEFAULT nCopies      := 1
   DEFAULT cPrinter     := PrnGetName()

   SysRefresh()

   oFr                  := frReportManager():New()

   oFr:LoadLangRes(     "Spanish.Xml" )

   oFr:SetIcon( 1 )

   oFr:SetTitle(        "Diseñador de documentos" )

   /*
   Manejador de eventos--------------------------------------------------------
   */

   oFr:SetEventHandler( "Designer", "OnSaveReport", {|| oFr:SaveToBlob( ( dbfDoc )->( Select() ), "mReport" ) } )

   /*
   Zona de datos------------------------------------------------------------
   */

   DataReport( oFr, .t. )

   /*
   Cargar el informe-----------------------------------------------------------
   */

   if !Empty( ( dbfDoc )->mReport )

      oFr:LoadFromBlob( ( dbfDoc )->( Select() ), "mReport")

      /*
      Preparar el report-------------------------------------------------------
      */

      oFr:PrepareReport()

      /*
      Imprimir el informe------------------------------------------------------
      */

      do case
         case nDevice == IS_SCREEN

            oFr:ShowPreparedReport()

         case nDevice == IS_PRINTER

            oFr:PrintOptions:SetPrinter( cPrinter )
            oFr:PrintOptions:SetCopies( nCopies )
            oFr:PrintOptions:SetShowDialog( .f. )
            oFr:Print()

         case nDevice == IS_PDF

            oFr:SetProperty(  "PDFExport", "EmbeddedFonts",    .t. )
            oFr:SetProperty(  "PDFExport", "PrintOptimized",   .t. )
            oFr:SetProperty(  "PDFExport", "Outline",          .t. )
            oFr:DoExport(     "PDFExport" )

      end case

   end if

   /*
   Destruye el diseñador-------------------------------------------------------
   */

   oFr:DestroyFr()

Return .t.

//---------------------------------------------------------------------------//

Function structOfertaArticulo( hCabecera, hLinea, nTotalLinea, nView  )

   local sOfertaArticulo
   local lOfertaArticulo   := .f.

   if empty( hLinea[ "Articulo" ] )
      return nil
   end if 

   if !( D():Articulos( nView ) )->( dbSeek( hLinea[ "Articulo" ] ) )
      msgStop( "Código de artículo " + alltrim( hLinea[ "Articulo" ] ) + " no encontrado", "Busqueda de ofertas" )
      Return nil
   end if 

   // Buscamos si existen ofertas por artículo----------------------------

   sOfertaArticulo         := hOfertaArticulo( hCabecera, hLinea, nTotalLinea, nView )

   if empty( sOfertaArticulo ) 
      sOfertaArticulo      := hOfertaFamilia( hCabecera, hLinea, nTotalLinea, nView )
   end if 

   if empty( sOfertaArticulo ) 
      sOfertaArticulo      := hOfertaTipoArticulo( hCabecera, hLinea, nTotalLinea, nView )
   end if 

   if empty( sOfertaArticulo ) 
      sOfertaArticulo      := hOfertaCategoria( hCabecera, hLinea, nTotalLinea, nView )
   end if 

   if empty( sOfertaArticulo )
      sOfertaArticulo      := hOfertaTemporada( hCabecera, hLinea, nTotalLinea, nView )
   end if 

   if empty( sOfertaArticulo )
      sOfertaArticulo      := hOfertaFabricante( hCabecera, hLinea, nTotalLinea, nView )
   end if 

Return ( sOfertaArticulo )

//--------------------------------------------------------------------------//

Static Function hOfertaArticulo( hCabecera, hLinea, nTotalLinea, nView )

   local sPrecio

   D():getStatusOfertas( nView )
   ( D():Ofertas( nView ) )->( ordSetFocus( "cArtOfe" ) )

   // Primero buscar si existe el articulo en la oferta-----------------------

   if ( D():Ofertas( nView ) )->( dbSeek( hLinea[ "Articulo" ] + hLinea[ "CodigoPropiedad1" ] + hLinea[ "CodigoPropiedad2" ] + hLinea[ "ValorPropiedad1" ] + hLinea[ "ValorPropiedad2" ] ) )

      while ( D():Ofertas( nView ) )->cArtOfe + ( D():Ofertas( nView ) )->cCodPr1 + ( D():Ofertas( nView ) )->cCodPr2 + ( D():Ofertas( nView ) )->cValPr1 + ( D():Ofertas( nView ) )->cValPr2 == hLinea[ "Articulo" ] + hLinea[ "CodigoPropiedad1" ] + hLinea[ "CodigoPropiedad2" ] + hLinea[ "ValorPropiedad1" ] + hLinea[ "ValorPropiedad2" ] .and. !( D():Ofertas( nView ) )->( eof() )

         if isOfertaArticulo( nView ) .and. isCondiconesComunes( hCabecera, hLinea, nTotalLinea, nView )
            
            // Comprobamos que no vayamos a vender mas articulos que los del lote

            if empty( sPrecio )

               sPrecio           := sPrecioOferta():get( hLinea, nView )

            else 

               if sPrecioOferta():menor( sPrecio )
                  sPrecio        := sPrecioOferta():get( hLinea, nView )
               end if

            end if

         end if

         ( D():Ofertas( nView ) )->( dbSkip() )

      end while

   end if

   D():setStatusOfertas( nView )

RETURN ( sPrecio )

//---------------------------------------------------------------------------//

FUNCTION hOfertaFamilia( hCabecera, hLinea, nTotalLinea, nView )

   local sPrecio
   local cCodigoFamilia

   cCodigoFamilia             := padr( hLinea[ "Familia" ], 18 )

   D():getStatusOfertas( nView )
   ( D():Ofertas( nView ) )->( ordSetFocus( "cArtOfe" ) )

   if ( D():Ofertas( nView ) )->( dbSeek( cCodigoFamilia ) )

      while ( D():Ofertas( nView ) )->cArtOfe == cCodigoFamilia .and. !( D():Ofertas( nView ) )->( eof() )

         if isOfertaFamilia( nView ) .and. isCondiconesComunes( hCabecera, hLinea, nTotalLinea, nView )  

            if empty( sPrecio ) .or. ( sPrecio:nDtoPorcentual >= sPrecioOferta():getDtoPorcentual( nView ) )
               sPrecio        := sPrecioOferta():get( hLinea, nView )
            end if

         end if

         ( D():Ofertas( nView ) )->( dbSkip() )

      end do

   end if

   D():setStatusOfertas( nView )

RETURN sPrecio

//---------------------------------------------------------------------------//

Static Function hOfertaTipoArticulo( hCabecera, hLinea, nTotalLinea, nView )

   local sPrecio
   local cCodigoTipo

   D():getStatusOfertas( nView )
   ( D():Ofertas( nView ) )->( ordSetFocus( "cArtOfe" ) )

   cCodigoTipo                := padr( hLinea[ "Tipo" ], 18 )

   if ( D():Ofertas( nView ) )->( dbSeek( cCodigoTipo ) )

      while ( D():Ofertas( nView ) )->cArtOfe  == cCodigoTipo .and. !( D():Ofertas( nView ) )->( Eof() )

         if isOfertaTipoArticulo( nView ) .and. isCondiconesComunes( hCabecera, hLinea, nTotalLinea, nView ) 

            if empty( sPrecio ) .or. ( sPrecio:nDtoPorcentual >= sPrecioOferta():getDtoPorcentual( nView ) )
               sPrecio        := sPrecioOferta():get( hLinea, nView )
            end if

         end if

         ( D():Ofertas( nView ) )->( dbSkip() )

      end do

   end if

   D():setStatusOfertas( nView )

RETURN sPrecio

//---------------------------------------------------------------------------//

FUNCTION hOfertaCategoria( hCabecera, hLinea, nTotalLinea, nView )

   local sPrecio
   local cCodigoCategoria

   D():getStatusOfertas( nView )
   ( D():Ofertas( nView ) )->( ordSetFocus( "cArtOfe" ) )

   cCodigoCategoria           := retFld( hLinea[ "Articulo" ], D():Articulos( nView ), "cCodTemp" )

   if ( D():Ofertas( nView ) )->( dbSeek( cCodigoCategoria ) )

      while ( D():Ofertas( nView ) )->cArtOfe  == cCodigoCategoria .and. !( D():Ofertas( nView ) )->( Eof() )

         if isOfertaTemporada( nView ) .and. isCondiconesComunes( hCabecera, hLinea, nTotalLinea, nView ) 

            if empty( sPrecio ) .or. ( sPrecio:nDtoPorcentual >= sPrecioOferta():getDtoPorcentual( nView ) )
               sPrecio        := sPrecioOferta():get( hLinea, nView )
            end if

         end if

         ( D():Ofertas( nView ) )->( dbSkip() )

      end do

   end if

   D():setStatusOfertas( nView )

RETURN sPrecio

//---------------------------------------------------------------------------//

FUNCTION hOfertaTemporada( hCabecera, hLinea, nTotalLinea, nView )

   local sPrecio
   local cCodigoTemporada

   D():getStatusOfertas( nView )
   ( D():Ofertas( nView ) )->( ordSetFocus( "cArtOfe" ) )

   cCodigoTemporada           := retFld( hLinea[ "Articulo" ], D():Articulos( nView ), "cCodTemp" )

   if ( D():Ofertas( nView ) )->( dbSeek( cCodigoTemporada ) )

      while ( D():Ofertas( nView ) )->cArtOfe  == cCodigoTemporada .and. !( D():Ofertas( nView ) )->( Eof() )

         if isOfertaTemporada( nView ) .and. isCondiconesComunes( hCabecera, hLinea, nTotalLinea, nView ) 

            if empty( sPrecio ) .or. ( sPrecio:nDtoPorcentual >= sPrecioOferta():getDtoPorcentual( nView ) )
               sPrecio        := sPrecioOferta():get( hLinea, nView )
            end if

         end if

         ( D():Ofertas( nView ) )->( dbSkip() )

      end do

   end if

   D():setStatusOfertas( nView )

RETURN sPrecio

//---------------------------------------------------------------------------//

FUNCTION hOfertaFabricante( hCabecera, hLinea, nTotalLinea, nView )

   local sPrecio
   local cCodigoFabricante

   D():getStatusOfertas( nView )
   ( D():Ofertas( nView ) )->( ordSetFocus( "cArtOfe" ) )

   cCodigoFabricante           := retFld( hLinea[ "Articulo" ], D():Articulos( nView ), "cCodFab" )

   if ( D():Ofertas( nView ) )->( dbSeek( cCodigoFabricante ) )

      while ( D():Ofertas( nView ) )->cArtOfe  == cCodigoFabricante .and. !( D():Ofertas( nView ) )->( Eof() )

         if isOfertaFabricante( nView ) .and. isCondiconesComunes( hCabecera, hLinea, nTotalLinea, nView ) 

            if empty( sPrecio ) .or. ( sPrecio:nDtoPorcentual >= sPrecioOferta():getDtoPorcentual( nView ) )
               sPrecio        := sPrecioOferta():get( hLinea, nView )
            end if

         end if

         ( D():Ofertas( nView ) )->( dbSkip() )

      end do

   end if

   D():setStatusOfertas( nView )

RETURN sPrecio

//---------------------------------------------------------------------------//

Static Function getPrecioOferta( nTarifa, lIvaIncluido, nView )

   local nPrecioOferta  := 0

   // Oferta de tipo X*Y-------------------------------------------------------

   if ( D():Ofertas( nView ) )->nTipOfe == 2
      Return ( nPrecioOferta )
   end if 

   do case
      case nTarifa == 1
         nPrecioOferta  :=  if( lIvaIncluido, ( D():Ofertas( nView ) )->nPreIva1, ( D():Ofertas( nView ) )->nPreOfe1 )
      case nTarifa == 2
         nPrecioOferta  :=  if( lIvaIncluido, ( D():Ofertas( nView ) )->nPreIva2, ( D():Ofertas( nView ) )->nPreOfe2 )
      case nTarifa == 3
         nPrecioOferta  :=  if( lIvaIncluido, ( D():Ofertas( nView ) )->nPreIva3, ( D():Ofertas( nView ) )->nPreOfe3 )
      case nTarifa == 4
         nPrecioOferta  :=  if( lIvaIncluido, ( D():Ofertas( nView ) )->nPreIva4, ( D():Ofertas( nView ) )->nPreOfe4 )
      case nTarifa == 5
         nPrecioOferta  :=  if( lIvaIncluido, ( D():Ofertas( nView ) )->nPreIva5, ( D():Ofertas( nView ) )->nPreOfe5 )
      case nTarifa == 6
         nPrecioOferta  :=  if( lIvaIncluido, ( D():Ofertas( nView ) )->nPreIva6, ( D():Ofertas( nView ) )->nPreOfe6 )
   end case

Return ( nPrecioOferta )

//---------------------------------------------------------------------------//

Static Function isValidClient( hCabecera, nView )

   local cGrupoCliente

   // Todos los clientes

   if ( D():Ofertas( nView ) )->nCliOfe == 1
      Return .t.
   end if 

   // Solo el cliente especificado en la oferta

   if ( D():Ofertas( nView ) )->nCliOfe == 3 .and. hCabecera[ "Cliente" ] == ( D():Ofertas( nView ) )->cCliOfe 
      Return .t.
   end if 

   cGrupoCliente           := retGrpCli( hCabecera[ "Cliente" ], D():Clientes( nView ) ) 
   if ( D():Ofertas( nView ) )->nCliOfe == 2 .and. cGrupoCliente == ( D():Ofertas( nView ) )->cGrpOfe 
      Return .t.
   end if 

Return ( .f. )   

//---------------------------------------------------------------------------//

Static Function isOfertaArticulo( nView )
Return ( ( D():Ofertas( nView ) )->nTblOfe < 2 )

//---------------------------------------------------------------------------//

Static Function isOfertaFamilia( nView )
Return ( ( D():Ofertas( nView ) )->nTblOfe == 2 )

//---------------------------------------------------------------------------//

Static Function isOfertaTipoArticulo( nView )
Return ( ( D():Ofertas( nView ) )->nTblOfe == 3 )

//---------------------------------------------------------------------------//

Static Function isOfertaCategoria( nView )
Return ( ( D():Ofertas( nView ) )->nTblOfe == 4 )

//---------------------------------------------------------------------------//

Static Function isOfertaTemporada( nView )
Return ( ( D():Ofertas( nView ) )->nTblOfe == 5 )

//---------------------------------------------------------------------------//

Static Function isOfertaFabricante( nView )
Return ( ( D():Ofertas( nView ) )->nTblOfe == 6 )

//---------------------------------------------------------------------------//

Static Function isValidFecha( hCabecera, nView )
Return ( ( hCabecera[ "Fecha" ] >= ( D():Ofertas( nView ) )->dIniOfe .or. empty( ( D():Ofertas( nView ) )->dIniOfe ) ) .and.;
         ( hCabecera[ "Fecha" ] <= ( D():Ofertas( nView ) )->dFinOfe .or. empty( ( D():Ofertas( nView ) )->dFinOfe ) ) )

//---------------------------------------------------------------------------//

Static Function isOfertaPrecio( nView )
Return ( ( D():Ofertas( nView ) )->nTipOfe < 2 )

//---------------------------------------------------------------------------//

Static Function isImporteMinimo( nTotalLinea, nView )
Return ( ( D():Ofertas( nView ) )->nMinCan == 1 .and. ( ( D():Ofertas( nView ) )->nImpMin == 0 .or. ( ( D():Ofertas( nView ) )->nImpMin != 0 .and. nTotalLinea >= ( D():Ofertas( nView ) )->nImpMin ) ) ) 

//---------------------------------------------------------------------------//

Static Function isCajasMinimas( nTotalCajas, nView )
Return ( ( D():Ofertas( nView ) )->nMinCan == 2 .and. ( D():Ofertas( nView ) )->nMinTip == 1 .and. ( ( D():Ofertas( nView ) )->nCajMin == 0 .or. ( ( D():Ofertas( nView ) )->nCajMin != 0 .and. nTotalCajas >= ( D():Ofertas( nView ) )->nCajMin ) ) ) 

//---------------------------------------------------------------------------//

Static Function isUnidadesMinimas( nTotalUnidades, nView )
Return ( ( D():Ofertas( nView ) )->nMinCan == 2 .and. ( D():Ofertas( nView ) )->nMinTip == 2 .and. ( ( D():Ofertas( nView ) )->nUndMin == 0 .or. ( ( D():Ofertas( nView ) )->nUndMin != 0 .and. nTotalUnidades >= ( D():Ofertas( nView ) )->nUndMin ) ) ) 

//---------------------------------------------------------------------------//

Static Function isCondiconesComunes( hCabecera, hLinea, nTotalLinea, nView )

   local lReturn  := .f.

   lReturn        := isValidFecha( hCabecera, nView ) .and. ;
                     isValidClient( hCabecera, nView ) .and.;
                     if( isOfertaPrecio( nView ),; 
                        (  isImporteMinimo( nTotalLinea, nView ) .or.;
                           isCajasMinimas( hLinea[ "Cajas" ], nView ) .or.;
                           isUnidadesMinimas( hLinea[ "Unidades" ], nView ) ),;
                        .t. )

Return ( lReturn )

/*Return   (  isValidFecha( hCabecera, nView ) .and. ;
            isValidClient( hCabecera, nView ) .and.;
            (  isImporteMinimo( nTotalLinea, nView ) .or.;
               isCajasMinimas( hLinea[ "Cajas" ], nView ) .or.;
               isUnidadesMinimas( hLinea[ "Unidades" ], nView ) ) )*/

//---------------------------------------------------------------------------//

CLASS sPrecioOferta

   DATA nPrecio                        INIT 0
   DATA nDtoPorcentual                 INIT 0
   DATA nDtoLineal                     INIT 0
   DATA nCajasGratis                   INIT 0
   DATA nUnidadesGratis                INIT 0

   METHOD say()                        INLINE ( "nPrecio" + str( ::nPrecio ) + CRLF +;
                                                "nDtoPorcentual" + str( ::nDtoPorcentual ) + CRLF +;
                                                "nDtoLineal" + str( ::nDtoLineal ) + CRLF +;
                                                "nCajasGratis " + str( ::nCajasGratis ) + CRLF +;
                                                "nUnidadesGratis " + str( ::nUnidadesGratis ) )

   METHOD get( nTarifa, nImpuestosIncluidos, nView )
   METHOD getPrecio( hLinea, nView ) ;
                                       INLINE ( getPrecioOferta( hLinea[ "NumeroTarifa" ], hLinea[ "LineaImpuestoIncluido" ], nView ) )
   METHOD getDtoPorcentual( nView )    INLINE ( ( D():Ofertas( nView ) )->nDtoPct )
   METHOD getDtoLineal( nView )        INLINE ( ( D():Ofertas( nView ) )->nDtoLin )

   METHOD isImporte()                  INLINE ( ::nPrecio != 0 .or. ::nDtoPorcentual != 0 .or. ::nDtoLineal != 0 )

   METHOD menor( sPrecio )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD get( hLinea, nView ) CLASS sPrecioOferta

   local nDifrenciaUnidades

   ::nDtoPorcentual        := ::getDtoPorcentual( nView )
   ::nDtoLineal            := ::getDtoLineal( nView )

   if ( D():Ofertas( nView ) )->nTipOfe == 1

      ::nPrecio            := ::getPrecio( hLinea, nView )
   
   else 

      nDifrenciaUnidades   := ( D():Ofertas( nView ) )->nUnvOfe - ( D():Ofertas( nView ) )->nUncOfe

      if ( D():Ofertas( nView ) )->nTipXbY == 1
         ::nCajasGratis    := int( div( hLinea[ "Cajas" ], ( D():Ofertas( nView ) )->nUnvOfe ) ) * nDifrenciaUnidades
      end if 
      if ( D():Ofertas( nView ) )->nTipXbY == 2
         ::nUnidadesGratis := int( div( hLinea[ "Unidades" ], ( D():Ofertas( nView ) )->nUnvOfe ) ) * nDifrenciaUnidades
      end if 

   end if 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD menor( sPrecio ) CLASS sPrecioOferta

   if ::nPrecio > 0
      return ( ::nPrecio < sPrecio:nPrecio )
   end if 

 return ( ::nUnidadesGratis < sPrecio:nUnidadesGratis )

//---------------------------------------------------------------------------//