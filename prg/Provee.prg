#ifndef __PDA__
   #include "FiveWin.Ch"
   #include "RichEdit.ch"
   #include "Xbrowse.ch"
   #include "FastRepH.ch"
#else
   #include "FWCE.ch"
   REQUEST DBFCDX
#endif

#include "Font.ch"
#include "Folder.ch"
#include "Factu.ch" 
#include "Report.ch"
#include "Label.ch"
#include "Ini.ch"

#define _COD                       1      //   C     7      0
#define _TITULO                    2      //   C     30     0
#define _NIF                       3      //   C     15     0
#define _DOMICILIO                 4      //   C     35     0
#define _POBLACION                 5      //   C     25     0
#define _PROVINCIA                 6      //   C     20     0
#define _CCODPAI                   7      //   C      3     0
#define _CPERCTO                   8      //   C     30     0
#define _CSUCLI                    9      //   C      7     0
#define _CODPOSTAL                10      //   C      7     0
#define _TELEFONO                 11      //   C     12     0
#define _FAX                      12      //   C     12     0
#define _MOVIL                    13      //   C     12     0
#define _CDTOESP                  14      //   N      5     1
#define _NDTOESP                  15      //   N      5     1
#define _CDTOPP                   16      //   N      5     1
#define _DTOPP                    17      //   N      5     1
#define _FPAGO                    18      //   C      2     0
#define _DIAPAGO                  19      //   N      2     0
#define _DIAPAGO2                 20      //   N      2     0
#define _SUBCTA                   21      //   C     12     0
#define _CTAVENTA                 22      //   C      3     0
#define _LLABEL                   23      //   L      1     0
#define _NLABEL                   24      //   N      5     0
#define _CCODSND                  25      //   C      3     0
#define _CMEIINT                  26      //   C     65     0
#define _CWEBINT                  27      //   C     65     0
#define _CUSRINT                  28      //   C     65     0
#define _CPSWINT                  29      //   C     65     0
#define _MCOMENT                  30      //   M     10     0
#define _NMESVAC                  31
#define _NCOPIASF                 32      //   N       1    0
#define _CUSRDEF01                33      //   C     100    0
#define _CUSRDEF02                34      //   C     100    0
#define _CUSRDEF03                35      //   C     100    0
#define _CUSRDEF04                36      //   C     100    0
#define _CUSRDEF05                37      //   C     100    0
#define _CUSRDEF06                38      //   C     100    0
#define _CUSRDEF07                39      //   C     100    0
#define _CUSRDEF08                40      //   C     100    0
#define _CUSRDEF09                41      //   C     100    0
#define _CUSRDEF10                42      //   C     100    0
#define _NVALPUNT                 43      //   N      16    6
#define _CTELCTO                  44
#define _BENEF1                   45      //   N       6    2
#define _BENEF2                   46      //   N       6    2
#define _BENEF3                   47      //   N       6    2
#define _BENEF4                   48      //   N       6    2
#define _BENEF5                   49      //   N       6    2
#define _BENEF6                   50      //   N       6    2
#define _NBNFSBR1                 51      //   N       1    0
#define _NBNFSBR2                 52      //   N       1    0
#define _NBNFSBR3                 53      //   N       1    0
#define _NBNFSBR4                 54      //   N       1    0
#define _NBNFSBR5                 55      //   N       1    0
#define _NBNFSBR6                 56      //   N       1    0
#define _LSNDINT                  57      //   L       1    0
#define _CCODUSR                  58
#define _DFECCHG                  59
#define _CTIMCHG                  60
#define _NTIPRET                  61
#define _NPCTRET                  62
#define _NPLZENT                  63      //   N       3    0
#define _LBLQPRV                  64      //   L       1    0
#define _DFECBLQ                  65      //   D       8    0
#define _CMOTBLQ                  66      //   C      50    0
#define _CCODGRP                  67      //   C       4    0
#define _NREGIVA                  68      //   L      1     0
#define _LMAIL                    69      //   L      1     0
#define _MOBSERV                  70      //   M     10     0
#define _LMOSCOM                  71      //   L      1     0
#define _LREQ                     72      //   L      1     0
#define _CNBREST                  73      //   C    150     0
#define _CDIREST                  74      //   C    150     0
#define _SERIE                    75      //   C    150     0
#define _LRECC                    76
#define _TELEFONO2                77
#define _MOVIL2                   78

memvar dbfPrv
memvar cDbfPrv

#ifndef __PDA__

static dbfProvee
static dbfProveeD
static dbfIva

static nView

static dbfPedPrvT
static dbfPedPrvL
static dbfAlbPrvT
static dbfAlbPrvL
static dbfFacPrvT
static dbfFacPrvL
static dbfFPago
static dbfArtPrv
static dbfArticulo
static dbfDiv
static oBandera
static oPais
static cPirDiv
static cPinDiv
static oWndBrw
static filTmpSubCta
static dbfTmpSubCta
static dbfTmpDoc
static cTmpDoc
static oMenu
static dbfTmpBnc
static cTmpBnc
static dbfBanco
static oGrpPrv
static filProvee
static tmpProvee
static dbfDoc
static oBanco
static oDetCamposExtra

static oRTF
static cRTF
static lBold
static lItalic
static lUnderline
static lBullet

static lOpenFiles := .f.
static lExternal  := .f.

static nLabels    := 1

static bEdit      := { | aTmp, aGet, dbfProvee, oBrw, bWhen, bValid, nMode | EdtRec( aTmp, aGet, dbfProvee, oBrw, bWhen, bValid, nMode ) }
static bEdtDoc    := { | aTmp, aGet, dbfProveeD, oBrw, bWhen, bValid, nMode | EdtDoc( aTmp, aGet, dbfProveeD, oBrw, bWhen, bValid, nMode ) }
static bEdtBnc    := { | aTmp, aGet, dbfBanco, oBrw, bWhen, bValid, nMode, cCodPrv | EdtBnc( aTmp, aGet, dbfBanco, oBrw, bWhen, bValid, nMode, cCodPrv ) }

static oReporting
static oMailing 

#endif

//----------------------------------------------------------------------------//
//Funciones del programa
//----------------------------------------------------------------------------//

#ifndef __PDA__

STATIC FUNCTION OpenFiles( lExt, cPath )

   local oError
   local oBlock

   if lOpenFiles
      MsgStop( 'Imposible abrir ficheros de proveedores' )
      Return ( .f. )
   end if

   DEFAULT  lExt  := .f.
   DEFAULT  cPath := cPatEmp()

   lExternal      := lExt

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      DisableAcceso()

      nView       := D():CreateView()

      lOpenFiles  := .t.

      D():Proveedores( nView )

      USE ( cPatPrv() + "PROVEE.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROVEE", @dbfProvee ) )
      SET ADSINDEX TO ( cPatPrv() + "PROVEE.CDX" ) ADDITIVE

      USE ( cPatPrv() + "PROVEED.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROVEED", @dbfProveeD ) )
      SET ADSINDEX TO ( cPatPrv() + "PROVEED.CDX" ) ADDITIVE

      USE ( cPath + "PEDPROVT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDPROVT", @dbfPedPrvT ) )
      SET ADSINDEX TO ( cPath + "PEDPROVT.CDX" ) ADDITIVE
      SET TAG TO CCODPRV

      USE ( cPath + "PEDPROVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDPROVL", @dbfPedPrvL ) )
      SET ADSINDEX TO ( cPath + "PEDPROVL.CDX" ) ADDITIVE

      USE ( cPath + "ALBPROVT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBPROVT", @dbfAlbPrvT ) )
      SET ADSINDEX TO ( cPath + "ALBPROVT.CDX" ) ADDITIVE
		SET TAG TO CCODPRV

      USE ( cPath + "ALBPROVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBPROVL", @dbfAlbPrvL ) )
      SET ADSINDEX TO ( cPath + "ALBPROVL.CDX" ) ADDITIVE

      USE ( cPath + "FACPRVT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVT", @dbfFacPrvT ) )
      SET ADSINDEX TO ( cPath + "FACPRVT.CDX" ) ADDITIVE
		SET TAG TO CCODPRV

      USE ( cPath + "FACPRVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVL", @dbfFacPrvL ) )
      SET ADSINDEX TO ( cPath + "FACPRVL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FPAGO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FPAGO", @dbfFPago ) )
      SET ADSINDEX TO ( cPatEmp() + "FPAGO.CDX" ) ADDITIVE

      USE ( cPatArt() + "PROVART.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROVART", @dbfArtPrv ) )
      SET ADSINDEX TO ( cPatArt() + "PROVART.CDX" ) ADDITIVE

      USE ( cPatDat() + "TIVA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfIva ) )
      SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE

      USE ( cPatArt() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
      SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

      USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDiv ) )
      SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

      USE ( cPatPrv() + "PRVBNC.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PRVBNC", @dbfBanco ) )
      SET ADSINDEX TO ( cPatPrv() + "PRVBNC.CDX" ) ADDITIVE

      USE ( cPatEmp() + "RDOCUMEN.DBF" ) NEW SHARED VIA ( cDriver() ) ALIAS ( cCheckArea( "RDOCUMEN", @dbfDoc ) )
      SET ADSINDEX TO ( cPatEmp() + "RDOCUMEN.CDX" ) ADDITIVE
      SET TAG TO "CTIPO"

      oBandera          := TBandera():New

      oPais             := TPais():Create( cPatDat() )
      if !oPais:OpenFiles()
         lOpenFiles     := .f.
      end if

      oGrpPrv           := TGrpPrv():Create( cPatPrv() )
      if !oGrpPrv:OpenFiles()
         lOpenFiles     := .f.
      end if

      oBanco            := TBancos():Create()
      oBanco:OpenFiles()

      oDetCamposExtra   := TDetCamposExtra():New()
      if !oDetCamposExtra:OpenFiles
         lOpenFiles     := .f.
      end if

      oDetCamposExtra:SetTipoDocumento( "Proveedores" )
      oDetCamposExtra:setbId( {|| D():ProveedoresId( nView ) } )

      CodigosPostales():GetInstance():OpenFiles()

      cPinDiv           := cPinDiv( cDivEmp(), dbfDiv ) // Picture de la divisa
      cPirDiv           := cPirDiv( cDivEmp(), dbfDiv ) // Picture de la divisa redondeada

      oMailing          := TGenMailingClientes():New( nView )

      EnableAcceso()

   RECOVER USING oError

      lOpenFiles     := .f.

      EnableAcceso()

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos de proveedores' )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpenFiles
      CloseFiles()
   end if

RETURN ( lOpenFiles )

//----------------------------------------------------------------------------//

FUNCTION Provee( oMenuItem, oWnd )

   local oSnd
   local nLevel
   local oRotor

   DEFAULT oMenuItem    := "01034"
   DEFAULT oWnd         := oWnd()

   if !empty( oWndBrw )
      oWndBrw:putFocus()
      Return .t.
   end if 

   /*
   Obtenemos el nivel de acceso
   */

   nLevel               := Auth():Level( oMenuItem )
   if nAnd( nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      return .f.
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

   if !OpenFiles( .f. )
      return .f.
   end if

   DisableAcceso()

   /*
   Anotamos el movimiento para el navegador
   */

   AddMnuNext( "Proveedores", ProcName() )

   DEFINE SHELL oWndBrw FROM 0, 0 TO 22, 80 ;
      XBROWSE ;
		TITLE 	"Proveedores" ;
      PROMPT   "Código",;
               "Nombre",;
               "NIF/CIF",;
               "Población",;
               "Teléfono" ,;
               "Fax",;
               "Domicilio",;
               "Población",;
               "Código postal",;
               "Provincia",;
               "Correo electrónico",;
               "Contacto",;
               "Establecimiento" ;
      MRU      "gc_businessman_16";
      BITMAP   ( clrTopCompras ) ;
      ALIAS    ( dbfProvee ) ;
      APPEND   ( WinAppRec( oWndBrw:oBrw, bEdit, dbfProvee ) );
      DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdit, dbfProvee ) );
		EDIT 		( WinEdtRec( oWndBrw:oBrw, bEdit, dbfProvee ) ) ;
      DELETE   ( WinDelRec( oWndBrw:oBrw, dbfProvee ) ) ;
      LEVEL    nLevel ;
      OF       oWnd

   with object ( oWndBrw:AddXCol() )
      :cHeader          := "Bloqueado"
      :nHeadBmpNo       := 3
      :bStrData         := {|| "" }
      :bEditValue       := {|| ( dbfProvee )->lBlqPrv }
      :nWidth           := 20
      :SetCheck( { "gc_sign_stop_12", "nil16" } )
      :AddResource( "gc_sign_stop_16" )
   end with

   with object ( oWndBrw:AddXCol() )
      :cHeader          := "Envio"
      :nHeadBmpNo       := 3
      :bStrData         := {|| "" }
      :bEditValue       := {|| ( dbfProvee )->lSndInt }
      :nWidth           := 20
      :SetCheck( { "gc_mail2_12", "nil16" } )
      :AddResource( "gc_mail2_16" )
   end with

   with object ( oWndBrw:AddXCol() )
      :cHeader          := "Código"
      :cSortOrder       := "Cod"
      :bEditValue       := {|| ( dbfProvee )->Cod }
      :nWidth           := 80
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
   end with

   with object ( oWndBrw:AddXCol() )
      :cHeader          := "Nombre"
      :cSortOrder       := "Titulo"
      :bEditValue       := {|| ( dbfProvee )->Titulo }
      :nWidth           := 280
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
   end with

   with object ( oWndBrw:AddXCol() )
      :cHeader          := "NIF/CIF"
      :cSortOrder       := "Nif"
      :bEditValue       := {|| ( dbfProvee )->Nif }
      :nWidth           := 80
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
   end with

   with object ( oWndBrw:AddXCol() )
      :cHeader          := "Teléfono"
      :cSortOrder       := "Telefono"
      :bEditValue       := {|| ( dbfProvee )->Telefono }
      :nWidth           := 80
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
   end with

   with object ( oWndBrw:AddXCol() )
      :cHeader          := "Fax"
      :bEditValue       := {|| ( dbfProvee )->Fax }
      :nWidth           := 80
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
   end with

   with object ( oWndBrw:AddXCol() )
      :cHeader          := "Domicilio"
      :bEditValue       := {|| ( dbfProvee )->Domicilio }
      :nWidth           := 300
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
   end with

   with object ( oWndBrw:AddXCol() )
      :cHeader          := "Población"
      :cSortOrder       := "Poblacion"
      :bEditValue       := {|| ( dbfProvee )->Poblacion }
      :nWidth           := 200
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
   end with

   with object ( oWndBrw:AddXCol() )
      :cHeader          := "Código postal"
      :cSortOrder       := "CodPostal"
      :bEditValue       := {|| ( dbfProvee )->CodPostal }
      :nWidth           := 60
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
   end with

   with object ( oWndBrw:AddXCol() )
      :cHeader          := "Provincia"
      :cSortOrder       := "Provincia"
      :bEditValue       := {|| ( dbfProvee )->Provincia }
      :nWidth           := 100
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
   end with

   with object ( oWndBrw:AddXCol() )
      :cHeader          := "Correo electrónico"
      :cSortOrder       := "cMeiInt"
      :bEditValue       := {|| ( dbfProvee )->cMeiInt }
      :nWidth           := 100
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
   end with

   with object ( oWndBrw:AddXCol() )
      :cHeader          := "Contacto"
      :cSortOrder       := "cPerCto"
      :bEditValue       := {|| ( dbfProvee )->cPerCto }
      :nWidth           := 200
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
   end with

   with object ( oWndBrw:AddXCol() )
      :cHeader          := "Establecimiento"
      :cSortOrder       := "cNbrEst"
      :bEditValue       := {|| ( dbfProvee )->cNbrEst }
      :nWidth           := 150
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      :lHide            := .t.
   end with

   with object ( oWndBrw:AddXCol() )
      :cHeader          := "Observaciones"
      :bEditValue       := {|| ( dbfProvee )->mComent }
      :nWidth           := 200
   end with

   oWndBrw:cHtmlHelp    := "Proveedores"

   oWndBrw:CreateXFromCode()

   DEFINE BTNSHELL RESOURCE "BUS" OF oWndBrw ;
		NOBORDER ;
      ACTION   ( oWndBrw:SearchSetFocus() ) ;
		TOOLTIP 	"(B)uscar" ;
      HOTKEY   "B";

   oWndBrw:AddSeaBar( "justZero", retNumCodPrvEmp() )

	DEFINE BTNSHELL RESOURCE "NEW" OF oWndBrw ;
		NOBORDER ;
		ACTION 	( oWndBrw:RecAdd() );
		ON DROP	( oWndBrw:RecDup() );
		TOOLTIP 	"(A)ñadir";
      BEGIN GROUP;
      HOTKEY   "A";
      LEVEL    ACC_APPD

	DEFINE BTNSHELL RESOURCE "DUP" OF oWndBrw ;
		NOBORDER ;
		ACTION 	( oWndBrw:RecDup() );
		TOOLTIP 	"(D)uplicar";
      MRU ;
      HOTKEY   "D";
      LEVEL    ACC_APPD

	DEFINE BTNSHELL RESOURCE "EDIT" OF oWndBrw ;
		NOBORDER ;
		ACTION  	( oWndBrw:RecEdit() );
		TOOLTIP 	"(M)odificar";
      MRU ;
      HOTKEY   "M" ;
      LEVEL    ACC_EDIT

	DEFINE BTNSHELL RESOURCE "ZOOM" OF oWndBrw ;
		NOBORDER ;
		ACTION  	( WinZooRec( oWndBrw:oBrw, bEdit, dbfProvee ) );
		TOOLTIP 	"(Z)oom";
      MRU ;
      HOTKEY   "Z" ;
      LEVEL    ACC_ZOOM

	DEFINE BTNSHELL RESOURCE "DEL" OF oWndBrw ;
		NOBORDER ;
		ACTION 	( oWndBrw:RecDel() );
		TOOLTIP 	"(E)liminar";
      MRU ;
      HOTKEY   "E";
      LEVEL    ACC_DELE

   #ifndef __TACTIL__

   DEFINE BTNSHELL RESOURCE "INFO" GROUP OF oWndBrw ;
		NOBORDER ;
      ACTION   ( BrwComPrv( ( dbfProvee )->Cod, ( dbfProvee )->Titulo, dbfDiv, dbfIva, dbfProvee ) );
      TOOLTIP  "(I)nforme proveedor" ;
      HOTKEY   "I" ;
      LEVEL    ACC_ZOOM

   #endif

   DEFINE BTNSHELL RESOURCE "IMP" OF oWndBrw ;
		NOBORDER ;
      ACTION   ( TInfPrv():New( "Listado de proveedores" ):Play() ) ;
		TOOLTIP 	"(L)istado";
      HOTKEY   "L" ;

   DEFINE BTNSHELL RESOURCE "gc_document_empty_chart_" GROUP OF oWndBrw ;
		NOBORDER ;
      ACTION   ( runFastGallery( "Proveedores" ) ) ;
      TOOLTIP  "Rep(o)rting";
      HOTKEY   "O" ;
      LEVEL    ACC_IMPR

   #ifndef __PDA__

   DEFINE BTNSHELL RESOURCE "gc_portable_barcode_scanner_" OF oWndBrw ;
		NOBORDER ;
      ACTION   ( TProveedorLabelGenerator():Create() ) ;
      TOOLTIP  "Eti(q)uetas" ;
      HOTKEY   "Q" ;
      LEVEL    ACC_IMPR

   #endif

   DEFINE BTNSHELL RESOURCE "GC_MAIL_EARTH_" OF oWndBrw ;
		NOBORDER ;
      ACTION   ( oMailing:documentsDialog( oWndBrw:oBrw:aSelected ) ) ;
      TOOLTIP  "Enviar correos" ;
      HOTKEY   "V" ;
      LEVEL    ACC_IMPR

   DEFINE BTNSHELL oSnd RESOURCE "Lbl" GROUP OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      TOOLTIP  "En(v)iar" ;
      ACTION   lSndPrv( oWndBrw, dbfProvee ) ;
      HOTKEY   "V";
      LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "Lbl" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( lSelectAll( oWndBrw, dbfProvee, "lSndInt", .t., .t., .t. ) );
         TOOLTIP  "Todos" ;
         FROM     oSnd ;
         CLOSED ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "Lbl" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( lSelectAll( oWndBrw, dbfProvee, "lSndInt", .f., .t., .t. ) );
         TOOLTIP  "Ninguno" ;
         FROM     oSnd ;
         CLOSED ;
         LEVEL    ACC_EDIT

   DEFINE BTNSHELL RESOURCE "BMPCONTA" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( ChkAllSubCta() ) ;
      TOOLTIP  "Com(p)robar subcuentas" ;
      HOTKEY   "P";
      LEVEL    ACC_EDIT

   if oUser():lAdministrador()

      DEFINE BTNSHELL RESOURCE "BMPCHG" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( ReplaceCreator( oWndBrw, dbfProvee, aItmPrv() ) ) ;
         TOOLTIP  "Cambiar campos" ;
         LEVEL    ACC_EDIT

   end if

   DEFINE BTNSHELL oRotor RESOURCE "ROTOR" GROUP OF oWndBrw ;
      ACTION   ( oRotor:Expand() ) ;
      TOOLTIP  "Rotor" ;
      LEVEL    ACC_EDIT

      /*DEFINE BTNSHELL RESOURCE "gc_form_plus2_" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( oDetCamposExtra:Play( ( dbfProvee )->Cod ) );
         TOOLTIP  "Campos extra" ;
         FROM     oRotor ;
         ALLOW    EXIT ;
         LEVEL    ACC_EDIT*/

      DEFINE BTNSHELL RESOURCE "gc_clipboard_empty_businessman_" OF oWndBrw ;
         ALLOW    EXIT ;
         ACTION   ( PedPrv( nil, oWnd, ( dbfProvee )->Cod, nil ) ) ;
         TOOLTIP  "Añadir pedido a proveedor" ;
         FROM     oRotor ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "gc_document_empty_businessman_" OF oWndBrw ;
         ALLOW    EXIT ;
         ACTION   ( AlbPrv( nil, oWnd, ( dbfProvee )->Cod, nil ) );
         TOOLTIP  "Añadir albarán de proveedor" ;
         FROM     oRotor ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "GC_DOCUMENT_TEXT_BUSINESSMAN_" OF oWndBrw ;
         ALLOW    EXIT ;
         ACTION   ( FacPrv( nil, oWnd, ( dbfProvee )->Cod, nil ) );
         TOOLTIP  "Añadir factura de proveedor" ;
         FROM     oRotor ;
         LEVEL    ACC_EDIT

   DEFINE BTNSHELL RESOURCE "END" GROUP OF oWndBrw ;
		ACTION 	( oWndBrw:End() ) ;
		TOOLTIP 	"(S)alir" ;
		HOTKEY 	"S"

   /*
   Datos para el filtro-----------------------------------------------------
   */

   oWndBrw:oActiveFilter:SetFields( aItmPrv() )
   oWndBrw:oActiveFilter:SetFilterType( PRV_TBL )

	ACTIVATE WINDOW oWndBrw VALID ( CloseFiles( .t. ) )

   EnableAcceso()

Return .t.

//----------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aTmp, aGet, dbfProvee, oBrw, bWhen, bValid, nMode )

	local oGet
	local oDlg
	local oFld
   local oBrwDoc
   local oSay[ 3 ]
   local cSay[ 3 ]
   local oGetSaldo
   local nGetSaldo   := 0
	local oGetSubCta
	local cGetSubCta
	local oGetCta
	local cGetCta
   local oBrwCta
   local cSubCtaAnt
   local aMes        := { "Ninguno", "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre" }
   local oBmpDiv
   local oValPnt
   local aBnfSobre   := { "Costo", "Venta" }
   local oBrwBnc
   local oZoom
   local cZoom       := "100%"
   local aZoom       := { "500%", "200%", "150%", "100%", "75%", "50%", "25%", "10%" }
   local oFuente
   local cFuente     := "Arial"
   local aFuente     := aGetFont( oWnd() )
   local oSize
   local cSize       := "10"
   local aSize       := { " 6", " 7", " 8", " 9", "10", "11", "12", "13", "14", "16", "18", "20", "22", "24", "26", "28", "36", "48", "72" }
   local oClp
   local oBtn        := Array( 17 )
   local aRatio      := { { 5, 1 }, { 2, 1 }, { 3, 2 }, { 1, 1 }, { 3, 4 }, { 1, 2 }, { 1, 4 }, { 1, 10 } }
   local oBmpGeneral
   local oBmpComercial
   local oBmpBancos
   local oBmpComentario
   local oBmpObservaciones
   local oBmpDocumentos
   local oBmpContabilidad

   if BeginTrans( aTmp, nMode )
      Return nil
   end if

   if nMode == APPD_MODE
      aTmp[ _NCOPIASF ] := 0
   end if

   if nMode == DUPL_MODE
      aTmp[ _COD ]      := NextKey( aTmp[ _COD ], dbfProvee, "0", RetNumCodPrvEmp() )
   end if

   if Empty( aTmp[ _CDTOESP ] )
      aTmp[ _CDTOESP ]  := Padr( "General", 50 )
   end if

   if Empty( aTmp[ _CDTOPP ] )
      aTmp[ _CDTOPP ]   := Padr( "Pronto pago", 50 )
   end if

   cSubCtaAnt           := aTmp[ ( dbfProvee )->( fieldpos( "SubCta" ) ) ]

	DEFINE DIALOG oDlg RESOURCE "PROVEEDOR" TITLE lblTitle( nMode ) + "Proveedores : " + Rtrim( aTmp[_TITULO] )

	REDEFINE FOLDER oFld;
			ID 		300 ;
			OF 		oDlg ;
         PROMPT   "&General"           ,;
                  "Co&mercial"         ,;
                  "&Bancos"            ,;
                  "C&ontabilidad"      ,;
                  "Comentario"         ,;
                  "Doc&umentos"        ,;
                  "&Observaciones"      ;
         DIALOGS  "PROVEEDOR_1"        ,;
                  "PROVEEDOR_6"        ,;
                  "CLIENT_2"           ,;
                  "PROVEEDOR_5"        ,;
                  "CLIENT_4"           ,;
                  "CLIENT_10"          ,;
                  "CLIENT_14"

		/*
      Redefinici¢n de la primera caja de Dialogo-------------------------------
		*/

      REDEFINE BITMAP oBmpGeneral ;
         ID       500 ;
         RESOURCE "gc_businessman_48" ;
         TRANSPARENT ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oGet ;
         VAR      aTmp[ _COD ] ;
			ID 		110 ;
         WHEN     ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) ;
         PICTURE  ( Replicate( "X", RetNumCodPrvEmp() ) );
         ON HELP  ( oGet:cText( NextKey( aTmp[ _COD ], dbfProvee, "0", RetNumCodPrvEmp() ) ) ) ;
         BITMAP   "BOT" ;
         VALID    ( NotValid( oGet, dbfProvee, .t., "0", 1, RetNumCodPrvEmp() ) ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _TITULO ] VAR aTmp[ _TITULO ];
         ID       120 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@!" ;
			ON CHANGE( ActTitle( nKey, nFlags, Self, nMode, oDlg ) );
         OF       oFld:aDialogs[1]

      if uFieldEmpresa( "nCifRut" ) == 1

      REDEFINE GET aGet[ _NIF ] VAR aTmp[ _NIF ];
         ID       130 ;
         VALID    ( CheckCif( aGet[ _NIF ] ) );
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 1 ]

      else

      REDEFINE GET aGet[ _NIF ] VAR aTmp[ _NIF ];
         ID       130 ;
         PICTURE  "@R 999999999-9" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( CheckRut( aGet[ _NIF ] ) );
         OF       oFld:aDialogs[ 1 ]

      end if

      REDEFINE GET aGet[ _DOMICILIO ] VAR aTmp[ _DOMICILIO ];
         ID       140 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "gc_earth_lupa_16" ;
         ON HELP  GoogleMaps( aTmp[ _DOMICILIO ], Rtrim( aTmp[ _POBLACION ] ) + Space( 1 ) + Rtrim( aTmp[ _PROVINCIA ] ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _POBLACION ] VAR aTmp[ _POBLACION ];
         ID       150 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CODPOSTAL ] VAR aTmp[ _CODPOSTAL ] ;
         ID       160 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( CodigosPostales():GetInstance():validCodigoPostal() );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _PROVINCIA ] VAR aTmp[ _PROVINCIA ] ;
         ID       170 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CCODPAI ] ;
         VAR      aTmp[ _CCODPAI ] ;
         ID       171 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( oPais:GetPais( aTmp[ _CCODPAI ], oSay[ 2 ], oBmpDiv ) ) ;
         ON HELP  ( oPais:Buscar( aGet[ _CCODPAI ] ) ) ;
         BITMAP   "LUPA" ;
         OF       oFld:aDialogs[1]

      REDEFINE BITMAP oBmpDiv ;
         RESOURCE "BAN_EURO" ;
         ID       172;
			OF 		oFld:aDialogs[1]

      REDEFINE GET oSay[2] VAR cSay[2] ;
         ID       173 ;
			SPINNER ;
         WHEN     ( .f. ) ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_CPERCTO] VAR aTmp[_CPERCTO];
         ID       174 ;
			PICTURE 	"@!" ;
			COLOR 	CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

		REDEFINE GET aGet[_TELEFONO] VAR aTmp[_TELEFONO] ;
         ID       180 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_TELEFONO2] VAR aTmp[_TELEFONO2] ;
         ID       185 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

		REDEFINE GET aGet[_FAX] VAR aTmp[_FAX] ;
         ID       190 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_MOVIL] VAR aTmp[_MOVIL] ;
         ID       200 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_MOVIL2] VAR aTmp[_MOVIL2] ;
         ID       205 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_CSUCLI] VAR aTmp[_CSUCLI];
         ID       191 ;
			PICTURE 	"@!" ;
			COLOR 	CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CTELCTO ] VAR aTmp[ _CTELCTO ] ;
         ID       720 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
         PICTURE  "@R ##########" ;
         OF       oFld:aDialogs[1]

		REDEFINE GET aGet[_FPAGO] VAR aTmp[_FPAGO] ;
			ID 		210 ;
			PICTURE 	"@!" ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( cFpago( aGet[_FPAGO], dbfFPago, oSay[ 1 ] ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwFpago( aGet[_FPAGO], oSay[ 1 ] ) ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET oSay[ 1 ] VAR cSay[ 1 ];
			ID 		330 ;
			WHEN 		.F. ;
			OF 		oFld:aDialogs[1]

      /*
      Criterio de caja--------------------------------------------------------------
      */

      REDEFINE CHECKBOX aTmp[ _LRECC ] ;
         ID       195 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]
      
      /*
      Código de grupo--------------------------------------------------------------
      */

      REDEFINE GET aGet[ _CCODGRP ] VAR aTmp[ _CCODGRP ] ;
         ID       400 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( oGrpPrv:Existe( aGet[ _CCODGRP ], oSay[ 3 ], "cNomGrp", .t., .t., "0" ) );
         ON HELP  ( oGrpPrv:Buscar( aGet[ _CCODGRP ] ) ) ;
         BITMAP   "LUPA" ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oSay[3] VAR cSay[3];
         ID       401 ;
			SPINNER ;
         WHEN     ( .f. ) ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

		REDEFINE GET aGet[ _DIAPAGO ] VAR aTmp[ _DIAPAGO ] ;
			ID 		220 ;
         SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			PICTURE 	"99" ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _DIAPAGO2 ] VAR aTmp[ _DIAPAGO2 ] ;
         ID       221 ;
         SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			PICTURE 	"99" ;
			OF 		oFld:aDialogs[1]

      REDEFINE COMBOBOX aGet[ _NMESVAC ] VAR aTmp[ _NMESVAC ];
         ITEMS    aMes ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ID       230 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aTmp[_NCOPIASF] ;
         ID       280 ;
			SPINNER ;
         MIN      0;
         MAX      9;
			COLOR 	CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			PICTURE 	"9" ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CMEIINT ] VAR aTmp[ _CMEIINT ] ;
         ID       310 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ON HELP  ( ShellExecute( oDlg:hWnd, "open", "mailto:" + Rtrim( aGet[ _CMEIINT ]:cText() ) ) ) ;
         BITMAP   "MAIL16" ;
         UPDATE ;
         OF       oFld:aDialogs[1]

      REDEFINE CHECKBOX aGet[ _LMAIL ] VAR aTmp[ _LMAIL ] ;
         ID       159 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _SERIE ] VAR aTmp[ _SERIE ] ;
         ID       222 ;
         SPINNER ;
         ON UP    ( UpSerie( aGet[ _SERIE ] ) );
         ON DOWN  ( DwSerie( aGet[ _SERIE ] ) );
         PICTURE  "@!" ;
         WHEN     ( nMode != ZOOM_MODE );
         VALID    ( Empty( aTmp[ _SERIE ] ) .or. ( aTmp[ _SERIE ] >= "A" .and. aTmp[ _SERIE ] <= "Z" ) );
         OF       oFld:aDialogs[ 1 ]

      /*
      Segunda caja de dialogo
      -------------------------------------------------------------------------
      */

      REDEFINE BITMAP oBmpComercial ;
         ID       500 ;
         RESOURCE "gc_address_book_48" ;
         TRANSPARENT ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[_CNBREST] VAR aTmp[_CNBREST] ;
         ID       400 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[_CDIREST] VAR aTmp[_CDIREST] ;
         ID       410 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[_CWEBINT] VAR aTmp[_CWEBINT] ;
         ID       310 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[_CUSRINT] VAR aTmp[_CUSRINT] ;
         ID       320 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[_CPSWINT] VAR aTmp[_CPSWINT] ;
         ID       330 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[2]

      // Bloqueo de proveedor

      REDEFINE CHECKBOX aGet[ _LBLQPRV ] VAR aTmp[ _LBLQPRV ] ;
         ID       155 ;
         WHEN     ( oUser():lAdministrador() .and. nMode != ZOOM_MODE ) ;
         ON CHANGE( if( aTmp[ _LBLQPRV ], aGet[ _DFECBLQ ]:cText( GetSysDate() ), ( aGet[ _DFECBLQ ]:cText( Ctod("") ), aGet[ _CMOTBLQ ]:cText( Space(50) ) ) ) );
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _DFECBLQ ] VAR aTmp[ _DFECBLQ ];
         ID       156 ;
         WHEN     ( oUser():lAdministrador() .and. nMode != ZOOM_MODE .and. aTmp[ _LBLQPRV ] );
         SPINNER;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CMOTBLQ ] VAR aTmp[ _CMOTBLQ ];
         ID       157 ;
         WHEN     ( oUser():lAdministrador() .and. nMode != ZOOM_MODE .and. aTmp[ _LBLQPRV ] );
         OF       oFld:aDialogs[2]

      // Regimen de impuestos

      REDEFINE RADIO aGet[ _NREGIVA ] VAR aTmp[ _NREGIVA ] ;
         ID       270, 271, 272, 273 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      REDEFINE CHECKBOX aTmp[_LREQ] ;
         ID       200 ;
         WHEN     ( aTmp[_NREGIVA] == 1 .AND. nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      // Segunda caja de diálogo

      REDEFINE COMBOBOX aGet[ _NTIPRET ] VAR aTmp[ _NTIPRET ] ;
         ITEMS    { "Ret. S/Base", "Ret. S/Total" };
         ID       100 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 2 ]

      REDEFINE GET aGet[ _NPCTRET ] VAR aTmp[ _NPCTRET ] ;
         ID       110 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999.99" ;
         OF       oFld:aDialogs[ 2 ]

      REDEFINE GET aGet[ _CDTOESP ] VAR aTmp[ _CDTOESP ] ;
         ID       120 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _NDTOESP ] VAR aTmp[ _NDTOESP ] ;
         ID       130 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999.99" ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CDTOPP ] VAR aTmp[ _CDTOPP ] ;
         ID       140 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _DTOPP ] VAR aTmp[ _DTOPP ] ;
         ID       150 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999.99" ;
         OF       oFld:aDialogs[2]

      /*
      REDEFINE GET aGet[ _BENEF1 ] VAR aTmp[ _BENEF1 ] ;
         ID       210 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999.9" ;
         OF       oFld:aDialogs[2]

      REDEFINE COMBOBOX aGet[ _NBNFSBR1 ] VAR aTmp[ _NBNFSBR1 ] ;
         ITEMS    aBnfSobre ;
         ID       211 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _BENEF2 ] VAR aTmp[ _BENEF2 ] ;
         ID       220 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999.9" ;
         OF       oFld:aDialogs[2]

      REDEFINE COMBOBOX aGet[ _NBNFSBR2 ] VAR aTmp[ _NBNFSBR2 ] ;
         ITEMS    aBnfSobre ;
         ID       221 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _BENEF3 ] VAR aTmp[ _BENEF3 ] ;
         ID       230 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999.9" ;
         OF       oFld:aDialogs[2]

      REDEFINE COMBOBOX aGet[ _NBNFSBR3 ] VAR aTmp[ _NBNFSBR3 ] ;
         ITEMS    aBnfSobre ;
         ID       231 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _BENEF4 ] VAR aTmp[ _BENEF4 ] ;
         ID       240 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999.9" ;
         OF       oFld:aDialogs[2]

      REDEFINE COMBOBOX aGet[ _NBNFSBR4 ] VAR aTmp[ _NBNFSBR4 ] ;
         ITEMS    aBnfSobre ;
         ID       241 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _BENEF5 ] VAR aTmp[ _BENEF5 ] ;
         ID       250 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999.9" ;
         OF       oFld:aDialogs[2]

      REDEFINE COMBOBOX aGet[ _NBNFSBR5 ] VAR aTmp[ _NBNFSBR5 ] ;
         ITEMS    aBnfSobre ;
         ID       251 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _BENEF6 ] VAR aTmp[ _BENEF6 ] ;
         ID       260 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999.9" ;
         OF       oFld:aDialogs[2]

      REDEFINE COMBOBOX aGet[ _NBNFSBR6 ] VAR aTmp[ _NBNFSBR6 ] ;
         ITEMS    aBnfSobre ;
         ID       261 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      REDEFINE SAY oValPnt ;
         ID       700 ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[_NVALPUNT] VAR aTmp[_NVALPUNT] ;
         ID       800 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
         PICTURE  cPinDiv() ;
         OF       oFld:aDialogs[2]
      */

      REDEFINE GET aGet[ _NPLZENT ] VAR aTmp[ _NPLZENT ] ;
         ID       300 ;
         SPINNER ;
         MIN      0 ;
         MAX      999 ;
         VALID    aTmp[ _NPLZENT ] > 0 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "999" ;
         OF       oFld:aDialogs[1]

		/*
      Tercera caja de Dialogo________________________________________________
		*/

      REDEFINE BITMAP oBmpBancos ;
         ID       500 ;
         RESOURCE "gc_central_bank_euro_48" ;
         TRANSPARENT ;
         OF       oFld:aDialogs[3]

      /*
      Montamos los bancos
      */

      REDEFINE BUTTON ;
         ID       101 ;
         OF       oFld:aDialogs[3] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinAppRec( oBrwBnc, bEdtBnc, dbfTmpBnc, aTmp, , aTmp[_COD] ) )

      REDEFINE BUTTON ;
         ID       102 ;
         OF       oFld:aDialogs[3] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinEdtRec( oBrwBnc, bEdtBnc, dbfTmpBnc, aTmp, , aTmp[_COD] ) )

      REDEFINE BUTTON ;
         ID       103 ;
         OF       oFld:aDialogs[3] ;
         ACTION   ( WinZooRec( oBrwBnc, bEdtBnc, dbfTmpBnc ) )

      REDEFINE BUTTON ;
         ID       104 ;
         OF       oFld:aDialogs[3] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( DelBnc( aTmp, oBrwBnc, dbfTmpBnc ) )

      oBrwBnc                 := IXBrowse():New( oFld:aDialogs[3] )

      oBrwBnc:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwBnc:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwBnc:cAlias          := dbfTmpBnc
      oBrwBnc:nMarqueeStyle   := 5
      oBrwBnc:cName           := "Proveedores.Bancos"

      with object ( oBrwBnc:AddCol() )
         :cHeader          := "D. Banco por defecto"
         :bEditValue       := {|| ( dbfTmpBnc )->lBncDef }
         :nWidth           := 16
         :SetCheck( { "Sel16", "Nil16" } )
      end with

      with object ( oBrwBnc:AddCol() )
         :cHeader          := "Nombre banco"
         :bEditValue       := {|| ( dbfTmpBnc )->cCodBnc }
         :nWidth           := 180
      end with

      with object ( oBrwBnc:AddCol() )
         :cHeader          := "Cuenta"
         :bEditValue       := {|| PictureCuentaIBAN( dbfTmpBnc ) }
         :nWidth           := 180
      end with

      with object ( oBrwBnc:AddCol() )
         :cHeader          := "Domicilio"
         :bEditValue       := {|| ( dbfTmpBnc )->cDirBnc }
         :nWidth           := 120
      end with

      with object ( oBrwBnc:AddCol() )
         :cHeader          := "Población"
         :bEditValue       := {|| ( dbfTmpBnc )->cPobBnc }
         :nWidth           := 100
      end with

      with object ( oBrwBnc:AddCol() )
         :cHeader          := "Código postal"
         :bEditValue       := {|| ( dbfTmpBnc )->cCPBnc }
         :nWidth           := 40
      end with

      with object ( oBrwBnc:AddCol() )
         :cHeader          := "Provincia"
         :bEditValue       := {|| ( dbfTmpBnc )->cProBnc }
         :nWidth           := 80
      end with

      with object ( oBrwBnc:AddCol() )
         :cHeader          := "Teléfono"
         :bEditValue       := {|| ( dbfTmpBnc )->cTlfBnc }
         :nWidth           := 80
      end with

      with object ( oBrwBnc:AddCol() )
         :cHeader          := "Fax"
         :bEditValue       := {|| ( dbfTmpBnc )->cFaxBnc }
         :nWidth           := 80
      end with

      with object ( oBrwBnc:AddCol() )
         :cHeader          := "Contacto"
         :bEditValue       := {|| ( dbfTmpBnc )->cPContBnc }
         :nWidth           := 140
      end with

      oBrwBnc:bRClicked       := {| nRow, nCol, nFlags | oBrwBnc:RButtonDown( nRow, nCol, nFlags ) }
      if nMode != ZOOM_MODE
         oBrwBnc:bLDblClick   := {|| WinEdtRec( oBrwBnc, bEdtBnc, dbfTmpBnc, aTmp, , aTmp[_COD] ) }
      end if

      oBrwBnc:CreateFromResource( 100 )

      /*
      Tercera caja de dialogo--------------------------------------------------
      */

      REDEFINE BITMAP oBmpContabilidad ;
         ID       500 ;
         RESOURCE "gc_folders2_48" ;
         TRANSPARENT ;
         OF       oFld:aDialogs[4]

      REDEFINE GET aGet[ _SUBCTA ] VAR aTmp[ _SUBCTA ] ;
			ID 		310 ;
         PICTURE  ( Replicate( "X", nLenSubcuentaContaplus() ) ) ;
         WHEN     ( nLenCuentaContaplus() != 0 .and. nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwChkSubcuenta( aGet[ _SUBCTA ], oGetSubCta ) ) ;
         VALID    ( lValidaSubcuenta( aGet, aTmp, oGetSaldo, oGetSubCta, cSubCtaAnt, oBrwCta, dbfTmpSubCta ) ) ;
         OF       oFld:aDialogs[4]

		REDEFINE GET oGetSubCta VAR cGetSubCta ;
			ID 		311 ;
			WHEN 		.F. ;
         OF       oFld:aDialogs[4]

      REDEFINE GET aGet[_CTAVENTA] VAR aTmp[_CTAVENTA] ;
			ID 		320 ;
         WHEN     ( nLenCuentaContaplus() != 0 .AND. nMode != ZOOM_MODE ) ;
         VALID    ( ChkCta( aTmp[_CTAVENTA], oGetCta, .f. ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwChkCta( aGet[_CTAVENTA], oGetCta ) ) ;
         OF       oFld:aDialogs[4]

		REDEFINE GET oGetCta VAR cGetCta ;
			ID 		321 ;
			WHEN 		.F. ;
         OF       oFld:aDialogs[4]

      REDEFINE GET oGetSaldo VAR nGetSaldo ;
         ID       354 ;
         PICTURE  cPirDiv ;
			WHEN 		.F. ;
         OF       oFld:aDialogs[4]

      /*
      Diario de la subcuenta---------------------------------------------------
      */

      oBrwCta                 := IXBrowse():New( oFld:aDialogs[ 4 ] )

      oBrwCta:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwCta:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwCta:cAlias          := dbfTmpSubCta
      oBrwCta:nMarqueeStyle   := 5
      oBrwCta:cName           := "Proveedores.Contabilidad"
      oBrwCta:lFooter         := .t.

      with object ( oBrwCta:AddCol() )
         :cHeader          := "Asiento"
         :bEditValue       := {|| Trans( ( dbfTmpSubCta )->nAsiento, "9999999" ) }
         :nWidth           := 80
      end with

      with object ( oBrwCta:AddCol() )
         :cHeader          := "Fecha"
         :bEditValue       := {|| Dtoc( ( dbfTmpSubCta )->dFecha ) }
         :nWidth           := 80
      end with

      with object ( oBrwCta:AddCol() )
         :cHeader          := "Concepto"
         :bEditValue       := {|| ( dbfTmpSubCta )->cConcepto }
         :nWidth           := 180
      end with

      with object ( oBrwCta:AddCol() )
         :cHeader          := "Debe"
         :bEditValue       := {|| ( dbfTmpSubCta )->nDebe }
         :cEditPicture     := cPirDiv
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrwCta:AddCol() )
         :cHeader          := "Haber"
         :bEditValue       := {|| ( dbfTmpSubCta )->nHaber }
         :cEditPicture     := cPirDiv
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrwCta:AddCol() )
         :cHeader          := "Departamento"
         :bEditValue       := {|| ( dbfTmpSubCta )->cDeparta }
         :nWidth           := 80
      end with

      with object ( oBrwCta:AddCol() )
         :cHeader          := "Factura"
         :bEditValue       := {|| Trans( ( dbfTmpSubCta )->nFactura, "99999999" ) }
         :nWidth           := 80
      end with

      with object ( oBrwCta:AddCol() )
         :cHeader          := "Base"
         :bEditValue       := {|| ( dbfTmpSubCta )->nBase }
         :cEditPicture     := cPirDiv
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrwCta:AddCol() )
         :cHeader          := cImp()
         :bEditValue       := {|| ( dbfTmpSubCta )->nIva }
         :cEditPicture     := cPirDiv
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      oBrwCta:bRClicked       := {| nRow, nCol, nFlags | oBrwCta:RButtonDown( nRow, nCol, nFlags ) }

      oBrwCta:CreateFromResource( 120 )

      /*
      Cuarta caja de dialogo_______________________________________________
		*/

      REDEFINE BITMAP oBmpComentario ;
         ID       500 ;
         RESOURCE "gc_message_48" ;
         TRANSPARENT ;
         OF       oFld:aDialogs[5]

      REDEFINE CHECKBOX aTmp[ _LMOSCOM ] ;
         ID       380 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[5]

      REDEFINE GET aGet[ _MCOMENT ] VAR aTmp[ _MCOMENT ];
			ID 		370 ;
			MEMO ;
			COLOR 	CLR_GET ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[5]

      /*
      Caja de diálogo de documentos--------------------------------------------
      */

      REDEFINE BITMAP oBmpDocumentos ;
         ID       600 ;
         RESOURCE "gc_folders_48" ;
         TRANSPARENT ;
         OF       oFld:aDialogs[6]

      oBrwDoc                 := IXBrowse():New( oFld:aDialogs[ 6 ] )

      oBrwDoc:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwDoc:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwDoc:cAlias          := dbfTmpDoc
      oBrwDoc:nMarqueeStyle   := 5
      oBrwDoc:cName           := "Proveedores.Documentos"
      oBrwDoc:nRowHeight      := 38
      oBrwDoc:nDataLines      := 2

      with object ( oBrwDoc:AddCol() )
         :cHeader          := "Documento"
         :bEditValue       := {|| Rtrim( ( dbfTmpDoc )->cNombre ) + CRLF + Space( 5 ) + lTrim( ( dbfTmpDoc )->cRuta ) }
         :nWidth           := 480
      end with

      if ( nMode != ZOOM_MODE )
         oBrwDoc:bLDblClick   := {|| ShellExecute( oDlg:hWnd, "open", rTrim( ( dbfTmpDoc )->cRuta ) ) }
      end if
      oBrwDoc:bRClicked       := {| nRow, nCol, nFlags | oBrwDoc:RButtonDown( nRow, nCol, nFlags ) }

      oBrwDoc:CreateFromResource( 400 )

      /*
      REDEFINE LISTBOX oBrwDoc ;
			FIELDS ;
                  rTrim( ( dbfTmpDoc )->cNombre ) + CRLF + Space( 5 ) + lTrim( ( dbfTmpDoc )->cRuta ) ;
			FIELDSIZES ;
                  500;
         HEAD ;
                  "Documento" ;
         ALIAS    ( dbfTmpDoc );
         ID       400 ;
         OF       oFld:aDialogs[ 6 ]

         oBrwDoc:nLineHeight     := 40
         oBrwDoc:bLDblClick   := {|| ShellExecute( oDlg:hWnd, "open", rTrim( ( dbfTmpDoc )->cRuta ) ) }
      */

      REDEFINE BUTTON ;
         ID       500 ;
         OF       oFld:aDialogs[6] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinAppRec( oBrwDoc, bEdtDoc, dbfTmpDoc, nil, nil, aTmp ) )

      REDEFINE BUTTON ;
         ID       501 ;
         OF       oFld:aDialogs[6] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinEdtRec( oBrwDoc, bEdtDoc, dbfTmpDoc, nil, nil, aTmp ) )

      REDEFINE BUTTON ;
         ID       502 ;
         OF       oFld:aDialogs[6] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( DbDelRec( oBrwDoc, dbfTmpDoc, nil, nil, .t. ) )

      REDEFINE BUTTON ;
         ID       503 ;
         OF       oFld:aDialogs[6] ;
         ACTION   ( WinZooRec( oBrwDoc, bEdtDoc, dbfTmpDoc ) )

      REDEFINE BUTTON ;
         ID       504 ;
         OF       oFld:aDialogs[6] ;
         ACTION   ( ShellExecute( oDlg:hWnd, "open", rTrim( ( dbfTmpDoc )->cRuta ) ) )

      /*
      Observaciones de clientes------------------------------------------------
      */

      REDEFINE BITMAP oBmpObservaciones ;
         ID       600 ;
         RESOURCE "gc_eye_48" ;
         TRANSPARENT ;
         OF       oFld:aDialogs[7]

      DEFINE CLIPBOARD oClp OF oFld:aDialogs[ 7 ] FORMAT TEXT

      REDEFINE BTNBMP oBtn[ 1 ] ;
         ID       100 ;
         WHEN     ( .t. ) ;
         OF       oFld:aDialogs[ 7 ] ;
         RESOURCE "gc_printer2_16" ;
         NOBORDER ;
         TOOLTIP  "Imprimir" ;
         ACTION   ( oRTF:Print(), oRTF:SetFocus() )

      REDEFINE BTNBMP oBtn[ 2 ] ;
         ID       110 ;
         WHEN     ( .t. ) ;
         OF       oFld:aDialogs[ 7 ] ;
         RESOURCE "PREV116" ;
         NOBORDER ;
         TOOLTIP  "Previsualizar" ;
         ACTION   ( oRTF:Preview( "Class TRichEdit" ) )

      REDEFINE BTNBMP oBtn[ 3 ] ;
         ID       120 ;
         WHEN     ( .t. ) ;
         OF       oFld:aDialogs[ 7 ] ;
         RESOURCE "Bus16" ;
         NOBORDER ;
         TOOLTIP  "Buscar" ;
         ACTION   ( FindRich( oRTF ) )

      REDEFINE BTNBMP oBtn[ 4 ] ;
         ID       130 ;
         WHEN     ( ! Empty( oRTF:GetSel() ) .and. ! oRTF:lReadOnly ) ;
         OF       oFld:aDialogs[ 7 ] ;
         RESOURCE "gc_cut_16" ;
         NOBORDER ;
         TOOLTIP  "Cortar" ;
         ACTION   ( oRTF:Cut(), oRTF:SetFocus() )

      REDEFINE BTNBMP oBtn[ 5 ] ;
         ID       140 ;
         WHEN     ( ! Empty( oRTF:GetSel() ) ) ;
         OF       oFld:aDialogs[ 7 ] ;
         RESOURCE "gc_copy_16" ;
         NOBORDER ;
         TOOLTIP  "Copiar" ;
         ACTION   ( oRTF:Copy(), oRTF:SetFocus() )

      REDEFINE BTNBMP oBtn[ 6 ] ;
         ID       150 ;
         WHEN     ( ! Empty( oClp:GetText() ) .and. ! oRTF:lReadOnly ) ;
         OF       oFld:aDialogs[ 7 ] ;
         RESOURCE "gc_clipboard_paste_16" ;
         NOBORDER ;
         TOOLTIP  "Pegar" ;
         ACTION   ( oRTF:Paste(), oRTF:SetFocus() )

      REDEFINE BTNBMP oBtn[ 7 ] ;
         ID       160 ;
         WHEN     ( oRTF:SendMsg( EM_CANUNDO ) != 0 ) ;
         OF       oFld:aDialogs[ 7 ] ;
         RESOURCE "gc_undo_inv_16" ;
         NOBORDER ;
         TOOLTIP  "Deshacer" ;
         ACTION   ( oRTF:Undo(), oRTF:SetFocus() )

      REDEFINE BTNBMP oBtn[ 8 ] ;
         ID       170 ;
         WHEN     ( oRTF:SendMsg( EM_CANREDO ) != 0 ) ;
         OF       oFld:aDialogs[ 7 ] ;
         RESOURCE "gc_undo_16" ;
         NOBORDER ;
         TOOLTIP  "Rehacer" ;
         ACTION   ( oRTF:Redo(), oRTF:SetFocus() )

      REDEFINE COMBOBOX oZoom VAR cZoom ;
         ITEMS    aZoom ;
         ID       180 ;
         OF       oFld:aDialogs[ 7 ]

      oZoom:bChange     := {|| oRTF:SetZoom( aRatio[ oZoom:nAt, 1 ], aRatio[ oZoom:nAt, 2 ] ), oRTF:SetFocus()  }

      REDEFINE COMBOBOX oFuente VAR cFuente ;
         ITEMS    aFuente ;
         ID       190 ;
         OF       oFld:aDialogs[ 7 ]

      oFuente:bChange   := {|| oRTF:SetFontName( oFuente:VarGet() ), oRTF:SetFocus() }

      REDEFINE COMBOBOX oSize VAR cSize ;
         ITEMS    aSize ;
         ID       200 ;
         OF       oFld:aDialogs[ 7 ]

      oSize:bChange     := {|| oRTF:SetFontSize( Val( oSize:VarGet() ) ), oRTF:SetFocus() }

      REDEFINE BTNBMP oBtn[ 9 ] ;
         ID       210 ;
         WHEN     ( ! oRTF:lReadOnly ) ;
         OF       oFld:aDialogs[ 7 ] ;
         RESOURCE "gc_text_bold_16" ;
         NOBORDER ;
         TOOLTIP  "Negrita" ;
         ACTION   ( lBold  := !lBold ,;
                    oRTF:SetBold( lBold ), oRTF:SetFocus() )

      REDEFINE BTNBMP oBtn[ 10 ] ;
         ID       220 ;
         WHEN     ( ! oRTF:lReadOnly ) ;
         OF       oFld:aDialogs[ 7 ] ;
         RESOURCE "gc_text_italics_16" ;
         NOBORDER ;
         TOOLTIP  "Cursiva" ;
         ACTION   ( lItalic := !lItalic ,;
                    oRTF:SetItalic( lItalic ), oRTF:SetFocus() )

      REDEFINE BTNBMP oBtn[ 11 ] ;
         ID       230 ;
         WHEN     ( ! oRTF:lReadOnly ) ;
         OF       oFld:aDialogs[ 7 ] ;
         RESOURCE "gc_text_underline_16" ;
         NOBORDER ;
         TOOLTIP  "Subrayado" ;
         ACTION   ( lUnderline := !lUnderline ,;
                    oRTF:SetUnderline( lUnderline ), oRTF:SetFocus() )

      REDEFINE BTNBMP oBtn[ 12 ] ;
         ID       240 ;
         WHEN     ( ! oRTF:lReadOnly ) ;
         OF       oFld:aDialogs[ 7 ] ;
         RESOURCE "gc_text_align_left_16" ;
         NOBORDER ;
         TOOLTIP  "Izquierda" ;
         ACTION   ( oRTF:SetAlign( PFA_LEFT ), oRTF:SetFocus() )

      REDEFINE BTNBMP oBtn[ 13 ]  ;
         ID       250 ;
         WHEN     ( ! oRTF:lReadOnly ) ;
         OF       oFld:aDialogs[ 7 ] ;
         RESOURCE "gc_text_center_16" ;
         NOBORDER ;
         TOOLTIP  "Centro" ;
         ACTION   ( oRTF:SetAlign( PFA_CENTER ), oRTF:SetFocus() )

      REDEFINE BTNBMP oBtn[ 14 ]  ;
         ID       260 ;
         WHEN     ( ! oRTF:lReadOnly ) ;
         OF       oFld:aDialogs[ 7 ] ;
         RESOURCE "gc_text_align_right_16" ;
         NOBORDER ;
         TOOLTIP  "Derecha" ;
         ACTION   ( oRTF:SetAlign( PFA_RIGHT ), oRTF:SetFocus() )

      REDEFINE BTNBMP oBtn[ 15 ] ;
         ID       270 ;
         WHEN     ( ! oRTF:lReadOnly ) ;
         OF       oFld:aDialogs[ 7 ] ;
         RESOURCE "gc_text_justified_16" ;
         NOBORDER ;
         TOOLTIP  "Justificado" ;
         ACTION   ( oRTF:SetAlign( PFA_JUSTIFY ), oRTF:SetFocus() )

      REDEFINE BTNBMP oBtn[ 16 ] ;
         ID       280 ;
         WHEN     ( ! oRTF:lReadOnly .AND. !oRTF:GetNumbering() ) ;
         OF       oFld:aDialogs[ 7 ] ;
         RESOURCE "gc_pin_blue_16" ;
         NOBORDER ;
         TOOLTIP  "Viñetas" ;
         ACTION   ( lBullet := !lBullet ,;
                    oRTF:SetBullet( lBullet ), oRTF:SetFocus() )

      REDEFINE BTNBMP oBtn[ 17 ] ;
         ID       290 ;
         WHEN     ( .t. ) ;
         OF       oFld:aDialogs[ 7 ] ;
         RESOURCE "gc_calendar_16" ;
         NOBORDER ;
         TOOLTIP  "Fecha/Hora" ;
         ACTION   ( DateTimeRich( oRTF ) )

      REDEFINE RICHEDIT oRTF VAR cRTF ;
         ID       300 ;
         OF       oFld:aDialogs[ 7 ]

      oRTF:bChange:= { || RTFRefreshButtons( oRtf, oBtn ) }

		/*
		Botones de la caja de Dialogo__________________________________________
      */

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( lPreSave( aTmp, aGet, dbfProvee, dbfArticulo, oBrw, nMode, oDlg ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
			ACTION 	( oDlg:end() )

      REDEFINE BUTTON ;
         ID       559 ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( GoHelp() )

      if nMode != ZOOM_MODE

         oFld:aDialogs[3]:AddFastKey( VK_F2, {|| WinAppRec( oBrwBnc, bEdtBnc, dbfTmpBnc, aTmp, , aTmp[_COD] ) } )
         oFld:aDialogs[3]:AddFastKey( VK_F3, {|| WinEdtRec( oBrwBnc, bEdtBnc, dbfTmpBnc, aTmp, , aTmp[_COD] ) } )
         oFld:aDialogs[3]:AddFastKey( VK_F4, {|| DbDelRec(  oBrwBnc, dbfTmpBnc ) } )

         oFld:aDialogs[6]:AddFastKey( VK_F2, {|| WinAppRec( oBrwDoc, bEdtDoc, dbfTmpDoc, nil, nil, aTmp ) } )
         oFld:aDialogs[6]:AddFastKey( VK_F3, {|| WinEdtRec( oBrwDoc, bEdtDoc, dbfTmpDoc, nil, nil, aTmp ) } )
         oFld:aDialogs[6]:AddFastKey( VK_F4, {|| DbDelRec( oBrwDoc, dbfTmpDoc, nil, nil, .t. ) } )

         oDlg:AddFastKey( VK_F9, {|| oDetCamposExtra:Play( Space(1) ) } )

         oDlg:AddFastKey( VK_F5, {|| lPreSave( aTmp, aGet, dbfProvee, dbfArticulo, oBrw, nMode, oDlg ) } )

      end if

      oDlg:AddFastKey ( VK_F1, {|| GoHelp() } )

      oDlg:bStart := { || ShowComentario( aTmp, nMode ), StartEdtRec( aTmp, aGet, oValPnt ), oBrwBnc:Load(), oBrwCta:Load(), oGet:SetFocus() }

      CodigosPostales():GetInstance():setBinding( { "CodigoPostal" => aGet[ _CODPOSTAL ], "Poblacion" => aGet[ _POBLACION ], "Provincia" => aGet[ _PROVINCIA ] } )

   ACTIVATE DIALOG oDlg CENTER ;
      ON INIT  ( EdtRecMenu( aTmp, aGet, dbfProvee, dbfArticulo, oBrw, nMode, oDlg ) );
      VALID    ( KillTrans() )

   EndEdtRecMenu()

   /*
   Guardamos los datos del browse----------------------------------------------
   */

   oBrwCta:CloseData()
   oBrwBnc:CloseData()

   oBmpGeneral:End()
   oBmpComercial:End()
   oBmpBancos:End()
   oBmpComentario:End()
   oBmpDocumentos:End()
   oBmpObservaciones:End()
   oBmpContabilidad:End()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Static Function ShowComentario( aTmp, nMode )

   if ( nMode != APPD_MODE .and. aTmp[ _LMOSCOM ] .and. !Empty( aTmp[ _MCOMENT ] ) )
      MsgInfo( AllTrim( aTmp[ _MCOMENT ] ), "Comentario" )
   end if

Return ( .t. )

//--------------------------------------------------------------------------//

STATIC FUNCTION lPreSave( aTmp, aGet, dbfProvee, dbfArticulo, oBrw, nMode, oDlg )

   local oError
   local oBlock

   if nMode == APPD_MODE .or. nMode == DUPL_MODE

      if Empty( aTmp[ _COD ] )
         MsgStop( "Código no puede estar vacio" )
         return .f.
      end if

      if dbSeekInOrd( aTmp[ _COD ], "Cod", dbfProvee )
         msgStop( "Código ya existe" )
         return .f.
      end if

   end if

   if Empty( aTmp[ _TITULO ] )
      MsgStop( "El nombre del proveedor no puede estar vacío." )
      aGet[ _TITULO ]:SetFocus()
      Return .f.
   end if

   CursorWait()

   oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      BeginTransaction()

      // Limpiamos la tabla de documentos-----------------------------------------

      while ( dbfProveeD )->( dbSeek( aTmp[ _COD ] ) )
         if dbLock( dbfProveeD )
            ( dbfProveeD )->( dbDelete() )
            ( dbfProveeD )->( dbUnLock() )
         end if
      end while

      // Escribimos la tabla definitiva de documentos-----------------------------

      ( dbfTmpDoc )->( dbGoTop() )
      while ( dbfTmpDoc )->( !eof() )

         ( dbfProveeD )->( dbAppend() )

         ( dbfProveeD )->cCodPrv := aTmp[ _COD ]
         ( dbfProveeD )->cNombre := ( dbfTmpDoc )->cNombre
         ( dbfProveeD )->cRuta   := ( dbfTmpDoc )->cRuta
         ( dbfProveeD )->mObsDoc := ( dbfTmpDoc )->mObsDoc

         ( dbfTmpDoc )->( dbSkip() )

      end while

      // Limpiamos la tabla de bancos---------------------------------------------

      while ( dbfBanco )->( dbSeek( aTmp[ _COD ] ) )
         dbDel( dbfBanco )
      end while

      // Escribimos la tabla definitiva de bancos---------------------------------

      ( dbfTmpBnc )->( dbGoTop() )
      while !( dbfTmpBnc )->( eof() )
         dbPass( dbfTmpBnc, dbfBanco, .t., aTmp[ _COD ] )
         ( dbfTmpBnc )->( dbSkip() )
      end while

      if IsMuebles() .and. ( nMode == EDIT_MODE )
         lCambiarPuntos( aTmp, dbfArticulo )
      end if

      aTmp[ _LSNDINT ]     := .t.
      aTmp[ _CCODUSR ]     := Auth():Codigo()
      aTmp[ _DFECCHG ]     := GetSysDate()
      aTmp[ _CTIMCHG ]     := Time()
      aTmp[ _MOBSERV ]     := oRTF:SaveAsRTF()

      /*
      Guardamos los campos extra-----------------------------------------------
      */

      oDetCamposExtra:saveExtraField( aTmp[ _COD ], "" )

      WinGather( aTmp, aGet, dbfProvee, oBrw, nMode )

      CommitTransaction()

   RECOVER USING oError

      RollBackTransaction()

      msgStop( "Imposible eliminar datos anteriores" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE
   ErrorBlock( oBlock )

Return ( oDlg:end( IDOK ) )

//---------------------------------------------------------------------------//

Static Function EdtDoc( aTmp, aGet, dbfClientD, oBrw, bWhen, bValid, nMode, aTmpLin )

   local oDlg
   local oNombre
   local oRuta
   local oObservacion

   DEFINE DIALOG oDlg RESOURCE "DOCUMENTOS" TITLE LblTitle( nMode ) + "documento de proveedor"

      REDEFINE GET oNombre VAR aTmp[ ( dbfTmpDoc )->( FieldPos( "cNombre" ) ) ] ;
         ID       120 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET oRuta VAR aTmp[ ( dbfTmpDoc )->( FieldPos( "cRuta" ) ) ] ;
         ID       100 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "FOLDER" ;
         ON HELP  ( oRuta:cText( cGetFile( 'Doc ( *.* ) | ' + '*.*', 'Seleccione el nombre del fichero' ) ) ) ;
         OF       oDlg

      REDEFINE GET oObservacion VAR aTmp[ ( dbfTmpDoc )->( FieldPos( "mObsDoc" ) ) ] ;
         MEMO ;
         ID       110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinGather( aTmp, nil, dbfTmpDoc, oBrw, nMode ), oDlg:end( IDOK ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

   if nMode != ZOOM_MODE
         oDlg:AddFastKey( VK_F5, {|| WinGather( aTmp, nil, dbfTmpDoc, oBrw, nMode ), oDlg:end( IDOK ) } )
      end if

   ACTIVATE DIALOG oDlg CENTER

Return ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Static function lValidaSubcuenta( aGet, aTmp, oGetSaldo, oGetSubCta, cSubCtaAnt, oBrwCta, dbfTmpSubCta )

   MkSubcuenta( aGet[ _SUBCTA ],;
             {  aTmp[ _SUBCTA    ],;
                aTmp[ _TITULO    ],;
                aTmp[ _NIF       ],;
                aTmp[ _DOMICILIO ],;
                aTmp[ _POBLACION ],;
                aTmp[ _PROVINCIA ],;
                aTmp[ _CODPOSTAL ],;
                aTmp[ _TELEFONO  ],;
                aTmp[ _FAX       ],;
                aTmp[ _CMEIINT   ] },;
             oGetSubCta,;
             nil,;
             nil,;
             nil,;
             nil,;
             oGetSaldo )

   if aTmp[ ( dbfProvee )->( fieldpos( "SUBCTA" ) ) ] != cSubCtaAnt
      LoadSubcuenta( aTmp[ ( dbfProvee )->( fieldpos( "SUBCTA" ) ) ], cRutCnt(), dbfTmpSubCta )
      oBrwCta:Refresh()
   end if

Return .t.

//---------------------------------------------------------------------------//

static function BeginTrans( aTmp, nMode )

   local lErrors     := .f.
   local cCodSubCta  := aTmp[ ( dbfProvee )->( fieldpos( "SubCta" ) ) ]
   local cCodPrv     := aTmp[ ( dbfProvee )->( fieldpos( "Cod" ) ) ]
   local cDbfDoc     := "PPrvD"
   local cDbfBnc     := "PBnc"
   local oError
   local oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   filTmpSubCta      := cGetNewFileName( cPatTmp() + "TmpSubCta" )
   cTmpDoc           := cGetNewFileName( cPatTmp() + cDbfDoc )
   cTmpBnc           := cGetNewFileName( cPatTmp() + cDbfBnc )

   dbCreate( filTmpSubCta, aSqlStruct( aItmSubcuenta() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), filTmpSubCta, cCheckArea( "TmpSubCta", @dbfTmpSubCta ), .f. )
   if !( dbfTmpSubCta )->( neterr() )
      ( dbfTmpSubCta )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmpSubCta )->( OrdCreate( filTmpSubCta, "dFecha", "dFecha", {|| Field->dFecha } ) )
   end if

   if nMode != APPD_MODE
      LoadSubcuenta( cCodSubCta, cRutCnt(), dbfTmpSubCta )
   end if

   dbCreate( cTmpDoc, aSqlStruct( aPrvDoc() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cTmpDoc, cCheckArea( cDbfDoc, @dbfTmpDoc ), .f. )
   if !( dbfTmpDoc )->( neterr() )
      ( dbfTmpDoc )->( ordCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmpDoc )->( ordCreate( cTmpDoc, "Recno", "Recno()", {|| Recno() } ) )
   end if

   dbCreate( cTmpBnc, aSqlStruct( aPrvBnc() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cTmpBnc, cCheckArea( cDbfBnc, @dbfTmpBnc ), .f. )
   if !( dbfTmpBnc )->( neterr() )
      ( dbfTmpBnc )->( ordCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmpBnc )->( OrdCreate( cTmpBnc, "CCODPRV", "CCODPRV + CCTABNC + CSUCBNC + CDIGBNC + CCTABNC", {|| Field->CCODPRV + Field->CCTABNC + Field->cSucBnc + Field->CDIGBNC + Field->CCTABNC } ) )
   end if

   /*
   A¤adimos desde el fichero de documentos
	*/

   if ( dbfProveeD )->( dbSeek( cCodPrv ) )
      while ( ( dbfProveeD )->cCodPrv == cCodPrv ) .AND. ( dbfProveeD )->( !eof() )
         dbPass( dbfProveeD, dbfTmpDoc, .t. )
         ( dbfProveeD )->( dbSkip() )
      end while
   end if

   ( dbfTmpDoc )->( dbGoTop() )

   /*
   A¤adimos desde el fichero de Bancos
   */

   if ( dbfBanco )->( dbSeek( cCodPrv ) )
      while ( ( dbfBanco )->cCodPrv == cCodPrv ) .AND. ( dbfBanco )->( !eof() )
         dbPass( dbfBanco, dbfTmpBnc, .t. )
         ( dbfBanco )->( dbSkip() )
      end while
   end if

   ( dbfTmpBnc )->( dbGoTop() )

   /*
   Cargamos los temporales de los campos extra---------------------------------
   */

   oDetCamposExtra:SetTemporal( aTmp[ _COD ], "", nMode )

   RECOVER USING oError

      msgStop( "Imposible crear tablas temporales." + CRLF + ErrorMessage( oError ) )

      KillTrans()

      lErrors     := .t.

   END SEQUENCE

    ErrorBlock( oBlock )

return ( lErrors )

//--------------------------------------------------------------------------//

Static Function KillTrans()

   if !Empty( dbfTmpSubCta ) .and. ( dbfTmpSubCta )->( Used() )
      ( dbfTmpSubCta )->( dbCloseArea() )
   end if

   if !Empty( dbfTmpDoc ) .and. ( dbfTmpDoc )->( Used() )
      ( dbfTmpDoc )->( dbCloseArea() )
   end if

   if !Empty( dbfTmpBnc ) .and. ( dbfTmpBnc )->( Used() )
      ( dbfTmpBnc )->( dbCloseArea() )
   end if

   dbfTmpSubCta := nil
   dbfTmpDoc    := nil
   dbfTmpBnc    := nil

   dbfErase( filTmpSubCta )
   dbfErase( cTmpDoc )
   dbfErase( cTmpBnc )

Return .t.

//---------------------------------------------------------------------------//

Static Function aItmSubcuenta()

   local aBase := {}

   aAdd( aBase, { "nAsiento",  "N",  6, 0, "Asiento"    } )
   aAdd( aBase, { "dFecha",    "D",  8, 0, "Fecha"      } )
   aAdd( aBase, { "cConcepto", "C", 25, 0, "Concepto"   } )
   aAdd( aBase, { "nDebe",     "N", 16, 2, "Debe"       } )
   aAdd( aBase, { "nHaber",    "N", 16, 2, "Haber"      } )
   aAdd( aBase, { "cDeparta",  "C",  6, 0, "Departa"    } )
   aAdd( aBase, { "nFactura",  "N",  8, 0, "Factura"    } )
   aAdd( aBase, { "nBase",     "N", 16, 2, "Base"       } )
   aAdd( aBase, { "nIva",      "N",  5, 2, "I.V.A"      } )

Return ( aBase )

//---------------------------------------------------------------------------//

STATIC FUNCTION lCambiarPuntos( aTmp, dbfArticulo )

   if ApoloMsgNoYes(  "¿ Desea actualizar los artículos que tienen este proveedor por defecto ?", "Elija una opción" )

      ( dbfArticulo )->( dbGoTop() )

      while !( dbfArticulo )->( eof() )

         if ( dbfArticulo )->cPrvHab == aTmp[ _COD ] .and. Empty( ( dbfArticulo )->cCodCat )

            if dbLock( dbfArticulo )

               ( dbfArticulo )->nPunTos     := aTmp[ _NVALPUNT ]
               ( dbfArticulo )->nDtoPnt     := aTmp[ _DTOPP ]

               if ( dbfArticulo )->lBnf1
                  ( dbfArticulo )->Benef1   := aTmp[ _BENEF1 ]
                  ( dbfArticulo )->nBnfSbr1 := aTmp[ _NBNFSBR1 ]
               end if
               if ( dbfArticulo )->lBnf2
                  ( dbfArticulo )->Benef2   := aTmp[ _BENEF2 ]
                  ( dbfArticulo )->nBnfSbr2 := aTmp[ _NBNFSBR2 ]
               end if
               if ( dbfArticulo )->lBnf3
                  ( dbfArticulo )->Benef3   := aTmp[ _BENEF3 ]
                  ( dbfArticulo )->nBnfSbr3 := aTmp[ _NBNFSBR3 ]
               end if
               if ( dbfArticulo )->lBnf4
                  ( dbfArticulo )->Benef4   := aTmp[ _BENEF4 ]
                  ( dbfArticulo )->nBnfSbr4 := aTmp[ _NBNFSBR4 ]
               end if
               if ( dbfArticulo )->lBnf5
                  ( dbfArticulo )->Benef5   := aTmp[ _BENEF5 ]
                  ( dbfArticulo )->nBnfSbr5 := aTmp[ _NBNFSBR5 ]
               end if
               if ( dbfArticulo )->lBnf6
                  ( dbfArticulo )->Benef6   := aTmp[ _BENEF6 ]
                  ( dbfArticulo )->nBnfSbr6 := aTmp[ _NBNFSBR6 ]
               end if

               ( dbfArticulo )->( dbUnLock() )

            end if

         end if

        ( dbfArticulo )->( dbSkip() )

      end while

   end if

RETURN .T.

//---------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles( lDestroy )

	DEFAULT lDestroy	:= .f.

   CLOSE ( dbfProvee  )
   CLOSE ( dbfProveeD )
   CLOSE ( dbfPedPrvT )
   CLOSE ( dbfPedPrvL )
	CLOSE ( dbfAlbPrvT )
	CLOSE ( dbfAlbPrvL )
	CLOSE ( dbfFacPrvT )
	CLOSE ( dbfFacPrvL )
   CLOSE ( dbfFPago   )
   CLOSE ( dbfArtPrv  )
   CLOSE ( dbfIva     )
   CLOSE ( dbfArticulo)
   CLOSE ( dbfDiv     )
   CLOSE ( dbfBanco   )
   CLOSE ( dbfDoc     )

   if !Empty( oPais )
      oPais:End()
   end if

   if !Empty( oGrpPrv )
      oGrpPrv:End()
   end if

   if !Empty( oBanco )
      oBanco:End()
   end if

   if !Empty( oDetCamposExtra )
      oDetCamposExtra:End()
   end if

   if !empty(oMailing)
      oMailing:end()
   end if 

   CodigosPostales():GetInstance():CloseFiles()

   dbfProvee         := nil
   dbfProveeD        := nil
   dbfPedPrvT        := nil
   dbfPedPrvL        := nil
   dbfAlbPrvT        := nil
   dbfAlbPrvL        := nil
   dbfFacPrvT        := nil
   dbfFacPrvL        := nil
   dbfFPago          := nil
   dbfArtPrv         := nil
   dbfIva            := nil
   dbfArticulo       := nil
   dbfDiv            := nil
   oBandera          := nil
   oPais             := nil
   dbfBanco          := nil
   oGrpPrv           := nil
   dbfDoc            := nil
   oBanco            := nil
   oDetCamposExtra   := nil

   if lDestroy
      oWndBrw        := nil
   end if

   lOpenFiles  := .f.

Return ( .t. )

//--------------------------------------------------------------------------//

Static Function ActTitle( nKey, nFlags, oGet, nMode, oDlg )

   oGet:Assign()

   oDlg:cTitle( LblTitle( nMode ) + " Proveedor : " + Rtrim( oGet:VarGet() ) )

RETURN NIL

//--------------------------------------------------------------------------//

/*
Devuelve la cuenta contable de un proveedor
*/

FUNCTION cPrvCta( cCodPrv, dbfProvee )

   local oBlock
   local oError
	local cText		:= ""
   local lClose   := .f.

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if Empty( dbfProvee )
      USE ( cPatPrv() + "PROVEE.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROVEE", @dbfProvee ) )
      SET ADSINDEX TO ( cPatPrv() + "PROVEE.CDX" ) ADDITIVE
      lClose      := .t.
   end if

   if dbSeekInOrd( cCodPrv, "Cod", dbfProvee )
      cText       := ( dbfProvee )->SubCta
   end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if lClose
		CLOSE ( dbfProvee )
   end if

RETURN cText

//---------------------------------------------------------------------------//

/*
Devuelve la cuenta de Venta de un proveedor
*/

FUNCTION cPrvCtaVta( cCodPrv, dbfProvee )

   local oBlock
   local oError
	local cText		:= ""
   local lClose   := .f.

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if Empty( dbfProvee )
      USE ( cPatPrv() + "PROVEE.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROVEE", @dbfProvee ) )
      SET ADSINDEX TO ( cPatPrv() + "PROVEE.CDX" ) ADDITIVE
      lClose      := .t.
   end if

   if dbSeekInOrd( cCodPrv , "Cod", dbfProvee )
      cText       := ( dbfProvee )->CtaVenta
   end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if lClose
		CLOSE ( dbfProvee )
   end if

RETURN cText

//---------------------------------------------------------------------------//

/*
Devuelve la forma de Pago de un proveedor
*/

FUNCTION cPrvFPago( cCodPrv, dbfProvee )

   local oBlock
   local oError
	local cAreaAnt := Alias()
   local cText    := Space( 2 )
   local lClose   := .F.

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

	IF dbfProvee == NIL
      USE ( cPatPrv() + "PROVEE.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROVEE", @dbfProvee ) )
      SET ADSINDEX TO ( cPatPrv() + "PROVEE.CDX" ) ADDITIVE
		lClose = .T.
	END IF

	IF (dbfProvee)->( DbSeek( Rjust( cCodPrv, "0" ) ) )
		cText := (dbfProvee)->FPAGO
	END IF

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

	IF lClose
		CLOSE ( dbfProvee )
	END IF

	IF cAreaAnt != ""
		SELECT( cAreaAnt )
	END IF

RETURN cText

//---------------------------------------------------------------------------//

/*
Devuelve el codigo de Envío de l proveedor
*/

FUNCTION cPrvCodSnd( cCodPrv, dbfProvee )

   local oBlock
   local oError
	local cAreaAnt := Alias()
	local cText		:= ""
	local lClose 	:= .F.

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

	IF dbfProvee == NIL
      USE ( cPatPrv() + "PROVEE.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROVEE", @dbfProvee ) )
      SET ADSINDEX TO ( cPatPrv() + "PROVEE.CDX" ) ADDITIVE
		lClose = .T.
	END IF

	IF (dbfProvee)->( dbSeek( cCodPrv ) )
		cText := (dbfProvee)->CCODSND
	END IF

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

	IF lClose
		CLOSE ( dbfProvee )
	END IF

	IF cAreaAnt != ""
		SELECT( cAreaAnt )
	END IF

RETURN cText

//---------------------------------------------------------------------------//

Static Function StartEdtRec( aTmp, aGet, oValPnt )

	local n

   /*
   Pasamos del campo memo de las observaciones al objeto richedit--------------
   */

   oRTF:LoadAsRTF( aTmp[ _MOBSERV ] )

   EvalGet( aGet )

Return nil

//--------------------------------------------------------------------------//

FUNCTION EdtPrv( cCodPrv, lOpenBrowse )

   local nLevel         := Auth():Level( "01032" )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_EDIT ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if Provee()
         if dbSeekInOrd( cCodPrv, "Cod", dbfProvee )
            oWndBrw:RecEdit()
         end if
      end if

   else

      if OpenFiles( .t. )
         if dbSeekInOrd( cCodPrv, "Cod", dbfProvee )
            WinEdtRec( nil, bEdit, dbfProvee )
         end if
         CloseFiles()
      end if

   end if

RETURN .t.

//---------------------------------------------------------------------------//

FUNCTION AppPrv( lOpenBrowse )

   local nLevel         := Auth():Level( "01032" )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_APPD ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if Provee()
         oWndBrw:RecAdd()
      end if

   else

      if OpenFiles( .t. )
         WinAppRec( nil, bEdit, dbfProvee )
         CloseFiles()
      end if

   end if

RETURN .t.

//---------------------------------------------------------------------------//

Function InfProveedor( cCodPrv, oBrw )

   local nLevel   := Auth():Level( "01034" )

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_EDIT ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if !OpenFiles( .t. )
      CloseFiles()
      return nil
   end if

#ifndef __TACTIL__

   if ( dbfProvee )->( dbSeek( cCodPrv ) )
      BrwComPrv( cCodPrv, ( dbfProvee )->Titulo, dbfDiv, dbfIva )
   else
      MsgStop( "No se encuentra proveedor" )
   end if

#endif

   if oBrw != nil
      oBrw:Refresh()
   end if

   CloseFiles()

RETURN .t.

//---------------------------------------------------------------------------//

CLASS TProveedorSenderReciver FROM TSenderReciverItem

   Method CreateData()

   Method RestoreData()

   Method SendData()

   Method ReciveData()

   Method Process()

END CLASS

//----------------------------------------------------------------------------//

Method CreateData()

   local oBlock
   local oError
   local lSnd        := .f.
   local tmpPrv
   local cFileName

   if ::oSender:lServer
      cFileName      := "Prv" + StrZero( ::nGetNumberToSend(), 6 ) + ".All"
   else
      cFileName      := "Prv" + StrZero( ::nGetNumberToSend(), 6 ) + "." + RetSufEmp()
   end if

   ::oSender:SetText( "Enviando proveedores" )

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatPrv() + "Provee.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "Provee", @dbfProvee ) )
   SET ADSINDEX TO ( cPatPrv() + "Provee.Cdx" ) ADDITIVE
   ( dbfProvee )->( OrdSetFocus( "lSndInt" ) )

   /*
   Creamos todas las bases de datos temporales
   */

   mkProvee( cPatSnd() )

   dbUseArea( .t., cLocalDriver(), cPatSnd() + "Provee.Dbf", cCheckArea( "Provee", @tmpPrv ), .f. )
   if !( tmpPrv )->( neterr() )
      ( tmpPrv )->( ordListAdd( cPatSnd() + "Provee.Cdx" ) )
   end if

   if !Empty( ::oSender:oMtr )
      ::oSender:oMtr:nTotal := ( dbfProvee )->( lastrec() )
   end if

   ( dbfProvee )->( dbGoTop() )
   while !( dbfProvee )->( eof() )

      if ( dbfProvee )->lSndInt

         lSnd  := .t.

         dbPass( dbfProvee, tmpPrv, .t. )
         ::oSender:SetText( AllTrim( ( dbfProvee )->Cod ) + "; " + ( dbfProvee )->Titulo )

      end if

      SysRefresh()

      ( dbfProvee )->( dbSkip() )

      if !Empty( ::oSender:oMtr )
         ::oSender:oMtr:Set( ( dbfProvee )->( OrdKeyNo() ) )
      end if

   end while

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE ( tmpPrv    )

   /*
   Comprimir los archivos------------------------------------------------------
   */

   if lSnd

      ::oSender:SetText( "Comprimiendo proveedores" )

      if ::oSender:lZipData( cFileName )
         ::oSender:SetText( "Ficheros comprimidos" )
      else
         ::oSender:SetText( "ERROR al crear fichero comprimido" )
      end if

   else

      ::oSender:SetText( "No hay proveedores para enviar" )

   end if

Return ( Self )

//----------------------------------------------------------------------------//

Method RestoreData()

   local oBlock
   local oError
   local dbfProvee

   if ::lSuccesfullSend

      oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
      BEGIN SEQUENCE

      USE ( cPatPrv() + "Provee.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "Provee", @dbfProvee ) )
      SET ADSINDEX TO ( cPatPrv() + "Provee.Cdx" ) ADDITIVE
      ( dbfProvee )->( OrdSetFocus( "lSndInt" ) )

      while !( dbfProvee )->( eof() )

         if ( dbfProvee )->lSndInt .and. dbLock( dbfProvee )
            ( dbfProvee )->lSndInt := .f.
            ( dbfProvee )->( dbUnlock() )
         end if

         ( dbfProvee )->( dbSkip() )

      end do

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

      CLOSE ( dbfProvee )

   end if

Return ( Self )

//----------------------------------------------------------------------------//

Method SendData()

   local cFileName

   if ::oSender:lServer
      cFileName      := "Prv" + StrZero( ::nGetNumberToSend(), 6 ) + ".All"
   else
      cFileName      := "Prv" + StrZero( ::nGetNumberToSend(), 6 ) + "." + RetSufEmp()
   end if

   /*
   Enviarlos a internet--------------------------------------------------------
   */

   if file( cPatOut() + cFileName )

      /*
      Enviarlos a internet-----------------------------------------------------
      */

      if ::oSender:SendFiles( cPatOut() + cFileName, cFileName )
         ::IncNumberToSend()
         ::lSuccesfullSend := .t.
         ::oSender:SetText( "Ficheros de proveedores enviados " + cFileName )
      else
         ::oSender:SetText( "ERROR fichero de proveedores no enviado" )
      end if
   end if

Return Self

//----------------------------------------------------------------------------//

Method ReciveData()

   local n
   local aExt

   /*
   Recibirlo de internet
   */

   if ::oSender:lServer
      aExt              := aRetDlgEmp()
   else
      aExt              := { "All" }
   end if

   ::oSender:SetText( "Recibiendo proveedores" )

   for n := 1 to len( aExt )
      ::oSender:GetFiles( "Prv*." + aExt[ n ], cPatIn() )
   next

   ::oSender:SetText( "Proveedores recibidos" )

Return Self

//----------------------------------------------------------------------------//

Method Process()

   local m
   local tmpPrv
   local aFiles               := Directory( cPatIn() + "Prv*.*" )
   local oBlock
   local oError

   /*
   Procesamos los ficheros recibidos
   */

   for m := 1 TO len( aFiles )

      ::oSender:SetText( "Procesando fichero : " + aFiles[ m, 1 ] )

      oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )

      BEGIN SEQUENCE

      if fSize( cPatIn() + aFiles[ m, 1 ] ) > 0

         /*
         Procesamos los ficheros recibidos
         */

         if ::oSender:lUnZipData( cPatIn() + aFiles[ m, 1 ] )

            if lExistTable( cPatSnd() + "Provee.Dbf", cLocalDriver() )

               USE ( cPatSnd() + "Provee.Dbf" ) NEW VIA ( cLocalDriver() ) SHARED ALIAS ( cCheckArea( "Provee", @tmpPrv ) )

               USE ( cPatPrv() + "Provee.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "Provee", @dbfProvee ) )
               SET ADSINDEX TO ( cPatPrv() + "Provee.Cdx" ) ADDITIVE

               if !Empty( ::oSender:oMtr )
                  ::oSender:oMtr:nTotal := ( tmpPrv )->( OrdKeyCount() )
               end if

               ( tmpPrv )->( dbGoTop() )
               while !( tmpPrv )->( eof() )

                  if ( dbfProvee )->( dbSeek( ( tmpPrv )->Cod ) )
                     
                     if !::oSender:lServer
                        
                        dbPass( tmpPrv, dbfProvee, .f. )

                        if dbLock( dbfProvee )
                           ( dbfProvee )->lSndInt := .f.
                           ( dbfProvee )->( dbUnLock() )
                        end if

                        ::oSender:SetText( "Reemplazado : " + AllTrim( ( dbfProvee )->Cod ) + "; " + ( dbfProvee )->Titulo )

                     else

                        ::oSender:SetText( "Desestimado : " + AllTrim( ( dbfProvee )->Cod ) + "; " + ( dbfProvee )->Titulo )

                     end if

                  else

                     dbPass( tmpPrv, dbfProvee, .t. )

                     if dbLock( dbfProvee )
                        ( dbfProvee )->lSndInt := .f.
                        ( dbfProvee )->( dbUnLock() )
                     end if

                     ::oSender:SetText( "Añadido : " + AllTrim( ( dbfProvee )->Cod ) + "; " + ( dbfProvee )->Titulo )

                  end if

                  ( tmpPrv )->( dbSkip() )

                  if !Empty( ::oSender:oMtr )
                     ::oSender:oMtr:Set( ( tmpPrv )->( OrdKeyNo() ) )
                  end if

                  SysRefresh()

               end while

               CLOSE ( tmpPrv    )

               ::oSender:AppendFileRecive( aFiles[ m, 1 ] )

            else

               ::oSender:SetText( "Ficheros no encontrados" )

               if lExistTable( cPatSnd() + "Provee.Dbf", cLocalDriver() )
                  ::oSender:SetText( "Falta" + cPatSnd() + "Provee.Dbf" )
               end if

            end if

         else

            ::oSender:SetText( "Error en ficheros comprimidos" )

         end if

      else

         ::oSender:SetText( "Fichero vacio" )

      end if

      RECOVER USING oError

         CLOSE ( tmpPrv    )

         ::oSender:SetText( "Error procesando fichero " + aFiles[ m, 1 ] )
         ::oSender:SetText( ErrorMessage( oError ) )

      END SEQUENCE

      ErrorBlock( oBlock )

   next

Return Self

//---------------------------------------------------------------------------//

Static Function EdtRecMenu( aTmp, aGet, dbfProvee, dbfArticulo, oBrw, nMode, oDlg )

   MENU oMenu

      MENUITEM    "&1. Rotor"

         MENU

#ifndef __TACTIL__

            MENUITEM "&1. Campos extra [F9]";
               MESSAGE  "Mostramos y rellenamos los campos extra para el proveedor" ;
               RESOURCE "gc_form_plus2_16" ;
               ACTION   ( oDetCamposExtra:Play( Space(1) ) )

            MENUITEM    "&2. Informe del proveedor";
               MESSAGE  "Muestra el informe del artículo" ;
               RESOURCE "info16" ;
               ACTION   ( BrwComPrv( ( dbfProvee )->Cod, ( dbfProvee )->Titulo, dbfDiv, dbfIva, dbfProvee ) )

#endif

            if !lExternal

            SEPARATOR

            MENUITEM    "&2. Añadir pedido a proveedor";
               MESSAGE  "Añade un pedido a proveedor" ;
               RESOURCE "gc_clipboard_empty_businessman_16";
               ACTION   ( lPreSave( aTmp, aGet, dbfProvee, dbfArticulo, oBrw, nMode, oDlg ), PedPrv( nil, nil, ( dbfProvee )->Cod, nil ) )

            MENUITEM    "&3. Añadir albarán de proveedor";
               MESSAGE  "Añade un albarán de proveedor" ;
               RESOURCE "gc_document_empty_businessman_16";
               ACTION   ( lPreSave( aTmp, aGet, dbfProvee, dbfArticulo, oBrw, nMode, oDlg ), AlbPrv( nil, nil, ( dbfProvee )->Cod, nil ) )

            MENUITEM    "&4. Añadir factura de proveedor";
               MESSAGE  "Añade una factura de proveedor" ;
               RESOURCE "gc_document_text_businessman_16";
               ACTION   ( lPreSave( aTmp, aGet, dbfProvee, dbfArticulo, oBrw, nMode, oDlg ), FacPrv( nil, nil, ( dbfProvee )->Cod, nil ) )

            end if

         ENDMENU

   ENDMENU

   oDlg:SetMenu( oMenu )

Return ( oMenu )

//---------------------------------------------------------------------------//

Static Function EndEdtRecMenu()

Return( oMenu:End() )

//---------------------------------------------------------------------------//

Function nTotImpPrv( dbfTmpPrv, dbfDiv, lPicture )

   local nCalculo

   DEFAULT lPicture  := .f.

   nCalculo          := ( dbfTmpPrv )->nImpPrv

   if ( dbfTmpPrv )->nDtoPrv != 0
      nCalculo       -= nCalculo * ( dbfTmpPrv )->nDtoPrv / 100
   end if

   if ( dbfTmpPrv )->nDtoPrm != 0
      nCalculo       -= nCalculo * ( dbfTmpPrv )->nDtoPrm / 100
   end if

Return ( if( lPicture, Trans( nCalculo, cPirDiv( cDivEmp(), dbfDiv ) ), nCalculo ) )

//---------------------------------------------------------------------------//

Function nTmpImpPrv( aTmp, dbfTmpPrv, dbfDiv, lPicture )

   local nCalculo

   DEFAULT lPicture  := .f.

   nCalculo          := aTmp[ ( dbfTmpPrv )->( FieldPos( "nImpPrv" ) ) ]

   if aTmp[ ( dbfTmpPrv )->( FieldPos( "nDtoPrv" ) ) ] != 0
      nCalculo       -= nCalculo * aTmp[ ( dbfTmpPrv )->( FieldPos( "nDtoPrv" ) ) ] / 100
   end if

   if aTmp[ ( dbfTmpPrv )->( FieldPos( "nDtoPrm" ) ) ] != 0
      nCalculo       -= nCalculo * aTmp[ ( dbfTmpPrv )->( FieldPos( "nDtoPrm" ) ) ] / 100
   end if

Return ( if( lPicture, Trans( nCalculo, cPirDiv( cDivEmp(), dbfDiv ) ), nCalculo ) )

//---------------------------------------------------------------------------//

Function lTmpImpPrv( aTmp, dbfTmpPrv, dbfDiv, oTotal )

   if oTotal != nil
      oTotal:cText( nTmpImpPrv( aTmp, dbfTmpPrv, dbfDiv, .f. ) )
   end if

Return ( .t. )

//---------------------------------------------------------------------------//
//
// Función que edita la caja de diálogo de bancos
//

Static Function EdtBnc( aTmp, aGet, dbfTmpBnc, oBrw, bWhen, bValid, nMode, cCodPrv )

   local oDlg
   local oBmpDiv
   local oSayPai
   local cSayPai
   local cOldCtaBnc  := aCuentaIBAN( aTmp, dbfTmpBnc )
   local lDis        := .f.

   /*
   Control para que el primer banco que metamos se ponga por defecto
   */

   if nMode == APPD_MODE
      ( dbfTmpBnc )->( dbGoTop() )
      if ( dbfTmpBnc )->( Eof() )
         aTmp[ ( dbfTmpBnc )->( FieldPos( "lBncDef" ) ) ] := .t.
         lDis        := .t.
      end if
   end if

   DEFINE DIALOG oDlg RESOURCE "Banco" TITLE LblTitle( nMode ) + "banco de proveedor"

      REDEFINE GET aGet[ ( dbfTmpBnc )->( FieldPos( "cCodBnc" ) ) ] ;
         VAR      aTmp[ ( dbfTmpBnc )->( FieldPos( "cCodBnc" ) ) ] ;
         ID       200 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON HELP  ( lCargaBanco( aGet, aTmp, nMode ) ) ;
         BITMAP   "LUPA" ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpBnc )->( FieldPos( "cDirBnc" ) ) ] ;
         VAR      aTmp[ ( dbfTmpBnc )->( FieldPos( "cDirBnc" ) ) ] ;
         ID       210 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpBnc )->( FieldPos( "cPobBnc" ) ) ] ;
         VAR      aTmp[ ( dbfTmpBnc )->( FieldPos( "cPobBnc" ) ) ] ;
         ID       220 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpBnc )->( FieldPos( "cCPBnc" ) ) ] ;
         VAR      aTmp[ ( dbfTmpBnc )->( FieldPos( "cCPBnc" ) ) ] ;
         ID       230 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpBnc )->( FieldPos( "cProBnc" ) ) ] ;
         VAR      aTmp[ ( dbfTmpBnc )->( FieldPos( "cProBnc" ) ) ] ;
         ID       240 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpBnc )->( FieldPos( "cPaiBnc" ) ) ] ;
         VAR      aTmp[ ( dbfTmpBnc )->( FieldPos( "cPaiBnc" ) ) ] ;
         ID       300 ;
         COLOR    CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( oPais:GetPais( aTmp[ ( dbfTmpBnc )->( FieldPos( "cPaiBnc" ) ) ], oSayPai, oBmpDiv ) ) ;
         ON HELP  ( oPais:Buscar( aGet[ ( dbfTmpBnc )->( FieldPos( "cPaiBnc" ) ) ] ) ) ;
         BITMAP   "LUPA" ;
         OF       oDlg

      REDEFINE BITMAP oBmpDiv ;
         RESOURCE "BAN_EURO" ;
         ID       301;
         OF       oDlg

      REDEFINE GET oSayPai VAR cSayPai ;
         ID       302 ;
         SPINNER ;
         WHEN     ( .f. ) ;
         COLOR    CLR_GET ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpBnc )->( FieldPos( "cTlfBnc" ) ) ] ;
         VAR      aTmp[ ( dbfTmpBnc )->( FieldPos( "cTlfBnc" ) ) ] ;
         ID       250 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpBnc )->( FieldPos( "cFaxBnc" ) ) ] ;
         VAR      aTmp[ ( dbfTmpBnc )->( FieldPos( "cFaxBnc" ) ) ] ;
         ID       260 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpBnc )->( FieldPos( "cPContBnc" ) ) ] ;
         VAR      aTmp[ ( dbfTmpBnc )->( FieldPos( "cPContBnc" ) ) ] ;
         ID       270 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpBnc )->( Fieldpos( "cPaisIBAN" ) ) ] ; 
         VAR      aTmp[ ( dbfTmpBnc )->( Fieldpos( "cPaisIBAN" ) ) ] ;
         PICTURE  "@!" ;
         ID       370 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lIbanDigit(  aTmp[ ( dbfTmpBnc )->( Fieldpos( "cPaisIBAN" ) ) ],;
                                 aTmp[ ( dbfTmpBnc )->( FieldPos( "cEntBnc" ) ) ],;
                                 aTmp[ ( dbfTmpBnc )->( FieldPos( "cSucBnc" ) ) ],;
                                 aTmp[ ( dbfTmpBnc )->( FieldPos( "cDigBnc" ) ) ],;
                                 aTmp[ ( dbfTmpBnc )->( FieldPos( "cCtaBnc" ) ) ],;
                                 aGet[ ( dbfTmpBnc )->( Fieldpos( "cCtrlIBAN" ) ) ] ) ) ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpBnc )->( Fieldpos( "cCtrlIBAN" ) ) ] ;
         VAR      aTmp[ ( dbfTmpBnc )->( Fieldpos( "cCtrlIBAN" ) ) ] ;
         ID       380 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lIbanDigit(  aTmp[ ( dbfTmpBnc )->( Fieldpos( "cPaisIBAN" ) ) ],;
                                 aTmp[ ( dbfTmpBnc )->( FieldPos( "cEntBnc" ) ) ],;
                                 aTmp[ ( dbfTmpBnc )->( FieldPos( "cSucBnc" ) ) ],;
                                 aTmp[ ( dbfTmpBnc )->( FieldPos( "cDigBnc" ) ) ],;
                                 aTmp[ ( dbfTmpBnc )->( FieldPos( "cCtaBnc" ) ) ],;
                                 aGet[ ( dbfTmpBnc )->( Fieldpos( "cCtrlIBAN" ) ) ] ) ) ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpBnc )->( FieldPos( "cEntBnc" ) ) ] ;
         VAR      aTmp[ ( dbfTmpBnc )->( FieldPos( "cEntBnc" ) ) ];
         ID       310 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    (  lCalcDC( aTmp[ ( dbfTmpBnc )->( FieldPos( "cEntBnc" ) ) ],;
                              aTmp[ ( dbfTmpBnc )->( FieldPos( "cSucBnc" ) ) ],;
                              aTmp[ ( dbfTmpBnc )->( FieldPos( "cDigBnc" ) ) ],;
                              aTmp[ ( dbfTmpBnc )->( FieldPos( "cCtaBnc" ) ) ],;
                              aGet[ ( dbfTmpBnc )->( FieldPos( "cDigBnc" ) ) ] ),;
                     aGet[ ( dbfTmpBnc )->( Fieldpos( "cCtrlIBAN" ) ) ]:lValid() ) ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpBnc )->( FieldPos( "cSucBnc" ) ) ];
         VAR      aTmp[ ( dbfTmpBnc )->( FieldPos( "cSucBnc" ) ) ];
         ID       320 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    (  lCalcDC( aTmp[ ( dbfTmpBnc )->( FieldPos( "cEntBnc" ) ) ],;
                              aTmp[ ( dbfTmpBnc )->( FieldPos( "cSucBnc" ) ) ],;
                              aTmp[ ( dbfTmpBnc )->( FieldPos( "cDigBnc" ) ) ],;
                              aTmp[ ( dbfTmpBnc )->( FieldPos( "cCtaBnc" ) ) ],;
                              aGet[ ( dbfTmpBnc )->( FieldPos( "cDigBnc" ) ) ] ),;
                     aGet[ ( dbfTmpBnc )->( Fieldpos( "cCtrlIBAN" ) ) ]:lValid() ) ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpBnc )->( FieldPos( "cDigBnc" ) ) ];
         VAR      aTmp[ ( dbfTmpBnc )->( FieldPos( "cDigBnc" ) )  ];
         ID       330 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    (  lCalcDC( aTmp[ ( dbfTmpBnc )->( FieldPos( "cEntBnc" ) ) ],;
                              aTmp[ ( dbfTmpBnc )->( FieldPos( "cSucBnc" ) ) ],;
                              aTmp[ ( dbfTmpBnc )->( FieldPos( "cDigBnc" ) ) ],;
                              aTmp[ ( dbfTmpBnc )->( FieldPos( "cCtaBnc" ) ) ],;
                              aGet[ ( dbfTmpBnc )->( FieldPos( "cDigBnc" ) ) ] ),;
                     aGet[ ( dbfTmpBnc )->( Fieldpos( "cCtrlIBAN" ) ) ]:lValid() ) ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpBnc )->( FieldPos( "cCtaBnc" ) ) ];
         VAR      aTmp[ ( dbfTmpBnc )->( FieldPos( "cCtaBnc" ) ) ];
         ID       340 ;
         PICTURE  "9999999999" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    (  lCalcDC( aTmp[ ( dbfTmpBnc )->( FieldPos( "cEntBnc" ) ) ],;
                              aTmp[ ( dbfTmpBnc )->( FieldPos( "cSucBnc" ) ) ],;
                              aTmp[ ( dbfTmpBnc )->( FieldPos( "cDigBnc" ) ) ],;
                              aTmp[ ( dbfTmpBnc )->( FieldPos( "cCtaBnc" ) ) ],;
                              aGet[ ( dbfTmpBnc )->( FieldPos( "cDigBnc" ) ) ] ),;
                     aGet[ ( dbfTmpBnc )->( Fieldpos( "cCtrlIBAN" ) ) ]:lValid() ) ;
         OF       oDlg

      REDEFINE CHECKBOX aGet[ ( dbfTmpBnc )->( FieldPos( "lBncDef" ) ) ] ;
         VAR      aTmp[ ( dbfTmpBnc )->( FieldPos( "lBncDef" ) ) ] ;
         ID       290 ;
         WHEN     ( nMode != ZOOM_MODE .and. !lDis ) ;
         OF       oDlg

   /*
   Botones de la caja
   */

   REDEFINE BUTTON ;
         ID       500 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( EndEdtBnc( aTmp, aGet, dbfTmpBnc, oBrw, nMode, oDlg, cCodPrv, bWhen, cOldCtaBnc ) )

      REDEFINE BUTTON ;
         ID       550 ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:End() )

   /*
   Tecla rápida para boton aceptar
   */

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| EndEdtBnc( aTmp, aGet, dbfTmpBnc, oBrw, nMode, oDlg, cCodPrv, bWhen, cOldCtaBnc ) } )
   end if

   oDlg:bStart := {|| if( aTmp[ ( dbfTmpBnc )->( FieldPos( "lBncDef" ) ) ], aGet[ ( dbfTmpBnc )->( FieldPos( "lBncDef" ) ) ]:Disable(), aGet[ ( dbfTmpBnc )->( FieldPos( "lBncDef" ) ) ]:Enable() ) }

   ACTIVATE DIALOG oDlg CENTER

   if !Empty( oBmpDiv )
      oBmpDiv:end()
   end if

Return ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//
/*
Funcion que termina el diálogo y comprueba que no falte ningún campo
*/

Static Function EndEdtBnc( aTmp, aGet, dbfTmpBnc, oBrw, nMode, oDlg, cCodPrv, aTmpPrv, cOldCtaBnc )

   local nRec

   aTmp[ ( dbfTmpBnc )->( FieldPos( "cCodPrv" ) ) ]   := cCodPrv

   if cOldCtaBnc != aCuentaIBAN( aTmp, dbfTmpBnc )

      nRec     := ( dbfTmpBnc )->( Recno() )

      if ( dbfTmpBnc )->( dbSeek( cCodPrv + aCuentaIBAN( aTmp, dbfTmpBnc ) ) )

         msgStop( "La cuenta bancaria ya existe" )

         aGet[ ( dbfTmpBnc )->( FieldPos( "cPaisIBAN" ) ) ]:SetFocus()

         ( dbfTmpBnc )->( dbGoTo( nRec ) )

         return .f.

      end if

      ( dbfTmpBnc )->( dbGoTo( nRec ) )

   end if

   WinGather( aTmp, aGet, dbfTmpBnc, oBrw, nMode, , .f. )

   /*
   Cambiamos el banco por defecto para controlar cuando cancela
   */

   if aTmp[ ( dbfTmpBnc )->( FieldPos( "lBncDef" ) ) ]
      lSelDefBnc( aTmp, dbfTmpBnc )
   end if

Return ( oDlg:end( IDOK ) )

//---------------------------------------------------------------------------//
/*
Carga Todos los Valores del Banco
*/

Static Function lCargaBanco( aGet, aTmp, nMode )

   local cBanco   := ""
   local cCuenta  := ""

   oBanco:Buscar( aGet[ ( dbfTmpBnc )->( FieldPos( "cCodBnc" ) ) ], "cCodBnc" )

   cBanco         := aTmp[ ( dbfTmpBnc )->( FieldPos( "cCodBnc" ) ) ]

   aGet[ ( dbfTmpBnc )->( FieldPos( "cCodBnc" ) ) ]:cText( oRetFld( cBanco, oBanco:oDbf, "cNomBnc" ) )
   aGet[ ( dbfTmpBnc )->( FieldPos( "cDirBnc" ) ) ]:cText( oRetFld( cBanco, oBanco:oDbf, "cDirBnc" ) )
   aGet[ ( dbfTmpBnc )->( FieldPos( "cPobBnc" ) ) ]:cText( oRetFld( cBanco, oBanco:oDbf, "cPobBnc" ) )
   aGet[ ( dbfTmpBnc )->( FieldPos( "cProBnc" ) ) ]:cText( oRetFld( cBanco, oBanco:oDbf, "cProBnc" ) )
   aGet[ ( dbfTmpBnc )->( FieldPos( "cCPBnc"  ) ) ]:cText( oRetFld( cBanco, oBanco:oDbf, "cPosBnc" ) )
   aGet[ ( dbfTmpBnc )->( FieldPos( "cTlfBnc" ) ) ]:cText( oRetFld( cBanco, oBanco:oDbf, "cTlfBnc" ) )
   aGet[ ( dbfTmpBnc )->( FieldPos( "cFaxBnc" ) ) ]:cText( oRetFld( cBanco, oBanco:oDbf, "cFaxBnc" ) )
   aGet[ ( dbfTmpBnc )->( FieldPos( "cPContBnc")) ]:cText( oRetFld( cBanco, oBanco:oDbf, "cPcoBnc" ) )
   aGet[ ( dbfTmpBnc )->( FieldPos( "cEntBnc" ) ) ]:cText( oRetFld( cBanco, oBanco:oDbf, "cEntBnc" ) )
   aGet[ ( dbfTmpBnc )->( FieldPos( "cSucBnc" ) ) ]:cText( oRetFld( cBanco, oBanco:oDbf, "cOfiBnc" ) )
   aGet[ ( dbfTmpBnc )->( FieldPos( "cDigBnc" ) ) ]:cText( Space( 2 ) )
   aGet[ ( dbfTmpBnc )->( FieldPos( "cCtaBnc" ) ) ]:cText( Space( 10 ) )

Return .t.
//---------------------------------------------------------------------------//
/*
Cambia el banco por defecto y mete los datos en la tabla de cliente
*/

Static Function lSelDefBnc( aTmp, dbfTmpBnc, oBrw )

   local nRec  := ( dbfTmpBnc )->( RecNo() )

   ( dbfTmpBnc )->( dbGoTop() )

   while !( dbfTmpBnc )->( Eof() )

      if ( dbfTmpBnc )->cCtaBnc != aTmp[ ( dbfTmpBnc )->( FieldPos( "cCtaBnc" ) ) ]
         ( dbfTmpBnc )->lBncDef := .f.
      else
         ( dbfTmpBnc )->lBncDef := .t.
      end if

      ( dbfTmpBnc )->( dbSkip() )

   end while

   ( dbfTmpBnc )->( dbGoto( nRec ) )

   if !Empty( oBrw )
      oBrw:Refresh()
   end if

Return .t.

//---------------------------------------------------------------------------//
/*Funcion de borrado del banco*/

Static Function DelBnc( aTmp, oBrwBnc, dbfTmpBnc )

   /*Si no es el de por defecto lo borramos sin mas*/

   if !( dbfTmpBnc )->lBncDef

      DbDelRec( oBrwBnc, dbfTmpBnc )

   else

      if DbDelRec( oBrwBnc, dbfTmpBnc )

         /*Si mandamos borrar el de por defecto, pondremos el primero de la lista
         en defecto y cambiamos la tabla de clientes*/

         ( dbfTmpBnc )->( dbGoTop() )

         if !( dbfTmpBnc )->( Eof() )
            ( dbfTmpBnc )->lBncDef  := .t.
         end if

      end if

   end if

   oBrwBnc:Refresh()

Return ( .t. )

//---------------------------------------------------------------------------//

Function SynProvee( cPath )

   DEFAULT cPath  := cPatEmp()

   if OpenFiles( .f., cPath )

      while !( dbfBanco )->( eof() )
         if Len( Rtrim( ( dbfBanco )->cCtaBnc ) ) >= 20
            if dbLock( dbfBanco )
               ( dbfBanco )->cEntBnc   := SubStr( ( dbfBanco )->cCtaBnc,  1,  4 )
               ( dbfBanco )->cSucBnc   := SubStr( ( dbfBanco )->cCtaBnc,  5,  4 )
               ( dbfBanco )->cDigBnc   := SubStr( ( dbfBanco )->cCtaBnc,  9,  2 )
               ( dbfBanco )->cCtaBnc   := SubStr( ( dbfBanco )->cCtaBnc, 11, 10 )
               ( dbfBanco )->( dbUnLock() )
            end if
         end if
         ( dbfBanco )->( dbSkip() )
      end while

      /*
      Recorremos la tabla de cliente, y si no existe el banco lo añadimos

      while !( dbfProvee )->( Eof() )

         if !Empty( ( dbfProvee )->Cuenta )

            if !( dbfBanco )->( dbSeek( ( dbfProvee )->Cod + ( dbfProvee )->Cuenta ) )

               if ( dbfBanco )->( dbSeek( ( dbfProvee )->Cod ) )
                  while ( dbfBanco )->cCodCli == ( dbfProvee )->Cod .and. !( dbfBanco )->( eof() )
                     if dbLock( dbfBanco )
                        ( dbfBanco )->lBncDef   := .f.
                        ( dbfBanco )->( dbUnLock() )
                     end if
                     ( dbfBanco )->( dbSkip() )
                  end while
               end if

               ( dbfBanco )->( dbAppend() )
               ( dbfBanco )->lBncDef   := .t.
               ( dbfBanco )->cCodCli   := ( dbfProvee )->Cod
               ( dbfBanco )->cEntBnc   := SubStr( ( dbfProvee )->Cuenta,  1,  4 )
               ( dbfBanco )->cSucBnc   := SubStr( ( dbfProvee )->Cuenta,  5,  4 )
               ( dbfBanco )->cDigBnc   := SubStr( ( dbfProvee )->Cuenta,  9,  2 )
               ( dbfBanco )->cCtaBnc   := SubStr( ( dbfProvee )->Cuenta, 11, 10 )
               ( dbfBanco )->cCodBnc   := ( dbfProvee )->Banco
               ( dbfBanco )->cDirBnc   := ( dbfProvee )->DirBanco
               ( dbfBanco )->cPobBnc   := ( dbfProvee )->PobBanco
               ( dbfBanco )->cProBnc   := ( dbfProvee )->cProBanco
               ( dbfBanco )->cPaiBnc   := ( dbfProvee )->cCodPai
               ( dbfBanco )->( dbUnLock() )

            end if

            if dbLock( dbfProvee )
               ( dbfProvee )->Cuenta   := ""
               ( dbfProvee )->( dbUnLock() )
            end if

         end if

         ( dbfProvee )->( dbSkip() )

      end while
      */

      CloseFiles()

   end if

Return ( nil )

//---------------------------------------------------------------------------//
//
// Funcion que devuelve la referencia del proveedor
//

Function cRefArtPrv( cCodArt, cCodPrv, dbfArtPrv )

   local nRec        := ( dbfArtPrv )->( RecNo())
   local nOrdAnt     := ( dbfArtPrv )->( OrdSetFocus( "CCODPRV" ) )
   local cRefArtPrv  := ""

   if ( dbfArtPrv )->( dbSeek( cCodPrv + cCodArt ) )
      cRefArtPrv     := ( dbfArtPrv )->cRefPrv
   end if

   ( dbfArtPrv )->( OrdSetFocus( nOrdAnt ) )
   ( dbfArtPrv )->( dbGoTo( nRec ))

Return cRefArtPrv

//---------------------------------------------------------------------------//

Function cProveedorDefecto( cCodArt, dbfArtPrv )

   local nRec                 := ( dbfArtPrv )->( recno() )
   local nOrd                 := ( dbfArtPrv )->( ordsetfocus( "cCodArt" ) )
   local cProveedorDefecto    := ""

   if ( dbfArtPrv )->( dbSeek( cCodArt ) )
      while ( dbfArtPrv )->cCodArt == cCodArt .and. !( dbfArtPrv )->( eof() )
         if empty( cProveedorDefecto ) .or. ( dbfArtPrv )->lDefPrv
            cProveedorDefecto := ( dbfArtPrv )->cCodPrv
         end if 
         ( dbfArtPrv )->( dbSkip() )
      end while
   end if

   ( dbfArtPrv )->( ordsetfocus( nOrd ) )
   ( dbfArtPrv )->( dbgoto( nRec ) )

Return ( cProveedorDefecto )

//---------------------------------------------------------------------------//

//---------------------------------------------------------------------------//

#ifndef __PDA__

CLASS TProveedorLabelGenerator

   Data oDlg
   Data oFld

   Data oCriterio
   Data cCriterio
   Data aCriterio

   Data oGrupoInicio
   Data cGrupoInicio

   Data oGrupoFin
   Data cGrupoFin

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

   Data oBtnFilter
   Data oBtnSiguiente
   Data oBtnAnterior
   Data oBtnCancel

   Data aSearch

   Method Create()
   Method End()

   Method lDefault()

   Method BotonAnterior()

   Method BotonSiguiente()

   Method PutLabel()

   Method SelectAllLabels()

   Method SelectCriterioLabels()

   Method AddLabel()

   Method DelLabel()

   Method EditLabel()

   Method ChangeCriterio()

   Method lPrintLabels()

   Method InitLabel( oLabel )

   Method lCreateTemporal()

   Method PrepareTemporal( oFr )

   Method DestroyTemporal()

   Method SelectColumn( oCombo )

END CLASS

//----------------------------------------------------------------------------//

Method lDefault() CLASS TProveedorLabelGenerator

   local oError
   local oBlock
   local lError         := .f.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   ::cCriterio          := "Ningún criterio"
   ::aCriterio          := { "Ningún criterio", "Grupo proveedores", "Fecha modificación" }

   ::cGrupoInicio       := ( dbfProvee )->cCodGrp
   ::cGrupoFin          := ( dbfProvee )->cCodGrp

   ::dFechaInicio       := Ctod( "01/" + Str( Month( Date() ), 2 ) + "/" + Str( Year( Date() ), 4 ) )
   ::dFechaFin          := GetSysDate()

   ::cFormatoLabel      := GetPvProfString( "Etiquetas", "Proveedor", Space( 3 ), cIniEmpresa() )
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

Method Create( ) CLASS TProveedorLabelGenerator

   local oBtnPrp
   local oGetOrd
   local oCbxOrd
   local cGetOrd     := Space( 100 )
   local cCbxOrd     := "Código"
   local aCbxOrd     := { "Código", "Nombre" }

   if ::lDefault()

      DEFINE DIALOG ::oDlg RESOURCE "SelectLabels_0"

         REDEFINE PAGES ::oFld ;
            ID       10;
            OF       ::oDlg ;
            DIALOGS  "SelectLabels_4",;
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
            OF       ::oFld:aDialogs[ 1 ]

         ::oCriterio:bChange        := {|| ::ChangeCriterio() }

         REDEFINE GET ::oGrupoInicio VAR ::cGrupoInicio ;
            ID       100 ;
            IDTEXT   101 ;
            BITMAP   "LUPA" ;
            OF       ::oFld:aDialogs[ 1 ]

         ::oGrupoInicio:bValid    := {|| oGrpPrv:Existe( ::cGrupoInicio, ::oGrupoInicio:oHelpText, "cNomGrp", .t., .t., "0" ) }
         ::oGrupoInicio:bHelp     := {|| oGrpPrv:Buscar( ::oGrupoInicio ) }

         REDEFINE SAY ::oInicio ;
            ID       102 ;
            OF       ::oFld:aDialogs[1]

         REDEFINE GET ::oGrupoFin VAR ::cGrupoFin ;
            ID       110 ;
            IDTEXT   111 ;
            BITMAP   "LUPA" ;
            OF       ::oFld:aDialogs[ 1 ]

         ::oGrupoFin:bValid       := {|| oGrpPrv:Existe( ::cGrupoFin, ::oGrupoFin:oHelpText, "cNomGrp", .t., .t., "0" ) }
         ::oGrupoFin:bHelp        := {|| oGrpPrv:Buscar( ::oGrupoFin ) }

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
            OF       ::oFld:aDialogs[ 1 ]

            ::oFormatoLabel:bValid  := {|| cDocumento( ::oFormatoLabel, ::oFormatoLabel:oHelpText, dbfDoc, "PL" ) }
            ::oFormatoLabel:bHelp   := {|| BrwDocumento( ::oFormatoLabel, ::oFormatoLabel:oHelpText, "PL" ) }

         TBtnBmp():ReDefine( 220, "gc_document_text_pencil_12",,,,,{|| EdtDocumento( ::cFormatoLabel ) }, ::oFld:aDialogs[ 1 ], .f., , .f., "Modificar formato de etiquetas" )

         REDEFINE GET ::nFilaInicio ;
            ID       180 ;
            PICTURE  "999" ;
            SPINNER ;
            OF       ::oFld:aDialogs[ 1 ]

         REDEFINE GET ::nColumnaInicio ;
            ID       190 ;
            PICTURE  "999" ;
            SPINNER ;
            OF       ::oFld:aDialogs[ 1 ]

         REDEFINE GET ::nUnidadesLabels ;
            ID       210 ;
            PICTURE  "99999" ;
            SPINNER ;
            MIN      1 ;
            MAX      99999 ;
            OF       ::oFld:aDialogs[ 1 ]

         /*
         Segunda caja de dialogo--------------------------------------------------
         */

         REDEFINE GET oGetOrd ;
            VAR      cGetOrd;
            ID       200 ;
            BITMAP   "FIND" ;
            OF       ::oFld:aDialogs[ 2 ]

         oGetOrd:bChange   := {| nKey, nFlags, oGet | AutoSeek( nKey, nFlags, oGet, ::oBrwLabel, dbfProvee ) }
         oGetOrd:bValid    := {|| ( dbfProvee )->( OrdScope( 0, nil ) ), ( dbfProvee )->( OrdScope( 1, nil ) ), ::oBrwLabel:Refresh(), .t. }

         REDEFINE COMBOBOX oCbxOrd ;
            VAR      cCbxOrd ;
            ID       210 ;
            ITEMS    aCbxOrd ;
            OF       ::oFld:aDialogs[ 2 ]

         oCbxOrd:bChange   := {|| ::SelectColumn( oCbxOrd ) }

         REDEFINE BUTTON ;
            ID       100 ;
            OF       ::oFld:aDialogs[ 2 ] ;
            ACTION   ( ::PutLabel() )

         REDEFINE BUTTON ;
            ID       110 ;
            OF       ::oFld:aDialogs[ 2 ] ;
            ACTION   ( ::SelectAllLabels( .t. ) )

         REDEFINE BUTTON ;
            ID       120 ;
            OF       ::oFld:aDialogs[ 2 ] ;
            ACTION   ( ::SelectAllLabels( .f. ) )

         REDEFINE BUTTON ;
            ID       130 ;
            OF       ::oFld:aDialogs[ 2 ] ;
            ACTION   ( ::AddLabel() )

         REDEFINE BUTTON ;
            ID       140 ;
            OF       ::oFld:aDialogs[ 2 ] ;
            ACTION   ( ::DelLabel() )

         REDEFINE BUTTON ;
            ID       150 ;
            OF       ::oFld:aDialogs[ 2 ] ;
            ACTION   ( ::EditLabel() )

         REDEFINE BUTTON ;
            ID       160 ;
            OF       ::oFld:aDialogs[ 2 ] ;
            ACTION   ( WinEdtRec( ::oBrwLabel, bEdit, dbfProvee ) )

         REDEFINE BUTTON ;
            ID       165 ;
            OF       ::oFld:aDialogs[ 2 ] ;
            ACTION   ( WinZooRec( ::oBrwLabel, bEdit, dbfProvee ) )

         REDEFINE BUTTON oBtnPrp ;
            ID       220 ;
            OF       ::oFld:aDialogs[ 2 ] ;
            ACTION   ( nil )

         ::oBrwLabel                   := IXBrowse():New( ::oFld:aDialogs[ 2 ] )

         ::oBrwLabel:nMarqueeStyle     := 5
         ::oBrwLabel:nColSel           := 2

         ::oBrwLabel:lHScroll          := .f.
         ::oBrwLabel:cAlias            := dbfProvee

         ::oBrwLabel:bClrSel           := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
         ::oBrwLabel:bClrSelFocus      := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }
         ::oBrwLabel:bLDblClick        := {|| ::PutLabel() }

         ::oBrwLabel:CreateFromResource( 180 )

         with object ( ::oBrwLabel:AddCol() )
            :cHeader          := "Sl. Seleccionado"
            :bStrData         := {|| "" }
            :bEditValue       := {|| ( dbfProvee )->lLabel }
            :nWidth           := 20
            :SetCheck( { "Sel16", "Nil16" } )
         end with

         with object ( ::oBrwLabel:AddCol() )
            :cHeader          := "Código"
            :cSortOrder       := "Cod"
            :bEditValue       := {|| ( dbfProvee )->Cod }
            :nWidth           := 80
            :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
         end with

         with object ( ::oBrwLabel:AddCol() )
            :cHeader          := "Nombre"
            :cSortOrder       := "Titulo"
            :bEditValue       := {|| ( dbfProvee )->Titulo }
            :nWidth           := 280
            :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
         end with

         with object ( ::oBrwLabel:AddCol() )
            :cHeader          := "N. etiquetas"
            :bEditValue       := {|| ( dbfProvee )->nLabel }
            :cEditPicture     := "@E 99,999"
            :nWidth           := 80
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
            :nEditType        := 1
            :bOnPostEdit      := {|o,x| if( dbDialogLock( dbfProvee ), ( ( dbfProvee )->nLabel := x, ( dbfProvee )->( dbUnlock() ) ), ) }
         end with

   REDEFINE APOLOMETER ::oMtrLabel ;
            VAR      ::nMtrLabel ;
            PROMPT   "" ;
            ID       190 ;
            OF       ::oFld:aDialogs[ 2 ] ;
            TOTAL    ( dbfProvee )->( lastrec() )

         ::oMtrLabel:nClrText   := rgb( 128,255,0 )
         ::oMtrLabel:nClrBar    := rgb( 128,255,0 )
         ::oMtrLabel:nClrBText  := rgb( 128,255,0 )

         /*
         Botones generales--------------------------------------------------------
         */

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

      ::oDlg:bStart  := {|| ::oBtnAnterior:Hide(), ::ChangeCriterio(), ::oFormatoLabel:lValid(), oBtnPrp:Hide() }

      ACTIVATE DIALOG ::oDlg CENTER

      ::End()

   end if

Return ( Self )

//--------------------------------------------------------------------------//

Method BotonAnterior() CLASS TProveedorLabelGenerator

   ::oFld:GoPrev()

   ::oBtnAnterior:Hide()

   SetWindowText( ::oBtnSiguiente:hWnd, "Siguien&te >" )

Return ( Self )

//--------------------------------------------------------------------------//

Method BotonSiguiente() CLASS TProveedorLabelGenerator

   do case
      case ::oFld:nOption == 1

         if Empty( ::cFormatoLabel )

            MsgStop( "Debe cumplimentar un formato de etiquetas" )

         else

            ::oFld:GoNext()
            ::oBtnAnterior:Show()

            if ::oCriterio:nAt != 1
               ::SelectCriterioLabels()
            end if

            SetWindowText( ::oBtnSiguiente:hWnd, "&Terminar" )

         end if

      case ::oFld:nOption == 2

         if ::lPrintLabels()

            SetWindowText( ::oBtnCancel:hWnd, "&Cerrar" )

         end if

         ::oBrwLabel:Refresh()

   end case

Return ( Self )

//--------------------------------------------------------------------------//

Method End() CLASS TProveedorLabelGenerator

   WritePProString( "Etiquetas", "Proveedor", ::cFormatoLabel, cIniEmpresa() )

Return ( Self )

//--------------------------------------------------------------------------//

Method PutLabel() CLASS TProveedorLabelGenerator

   if dbLock( dbfProvee )
      ( dbfProvee )->lLabel := !( dbfProvee )->lLabel
      ( dbfProvee )->( dbUnLock() )
   end if

   ::oBrwLabel:Refresh()
   ::oBrwLabel:SetFocus()

Return ( Self )

//--------------------------------------------------------------------------//

Method SelectAllLabels( lSelect ) CLASS TProveedorLabelGenerator

	local n			:= 0
   local nRecno   := ( dbfProvee )->( Recno() )

	CursorWait()

   ( dbfProvee )->( dbGoTop() )
   while !( dbfProvee )->( eof() )

      if dbLock( dbfProvee )
         ( dbfProvee )->lLabel := lSelect
         ( dbfProvee )->( dbUnLock() )
      end if

      ( dbfProvee )->( dbSkip() )

      ::oMtrLabel:Set( ++n )

   end while

   ( dbfProvee )->( dbGoTo( nRecno ) )

   ::oBrwLabel:Refresh()

   ::oMtrLabel:Set( 0 )
   ::oMtrLabel:Refresh()

	CursorArrow()

Return ( Self )

//--------------------------------------------------------------------------//

Method SelectCriterioLabels() CLASS TProveedorLabelGenerator

	local n			:= 0
   local nRecno   := ( dbfProvee )->( Recno() )

	CursorWait()

   ( dbfProvee )->( dbGoTop() )
   while !( dbfProvee )->( eof() )

      if dbLock( dbfProvee )

         do case
            case ::oCriterio:nAt == 2 .and. ( dbfProvee )->cCodGrp >= ::cGrupoInicio .and. ( dbfProvee )->cCodGrp <= ::cGrupoFin

               ( dbfProvee )->lLabel := .t.
               ( dbfProvee )->nLabel := ::nUnidadesLabels

            case ::oCriterio:nAt == 3 .and. ( dbfProvee )->dFecChg >= ::dFechaInicio .and. ( dbfProvee )->dFecChg <= ::dFechaFin

               ( dbfProvee )->lLabel := .t.
               ( dbfProvee )->nLabel := ::nUnidadesLabels

            otherwise

               ( dbfProvee )->lLabel := .f.
               ( dbfProvee )->nLabel := 1

         end case

         ( dbfProvee )->( dbUnLock() )

      end if

      ( dbfProvee )->( dbSkip() )

      ::oMtrLabel:Set( ++n )

   end while

   ( dbfProvee )->( dbGoTo( nRecno ) )

   ::oBrwLabel:Refresh()

   ::oMtrLabel:Set( 0 )
   ::oMtrLabel:Refresh()

	CursorArrow()

Return ( Self )

//--------------------------------------------------------------------------//

Method AddLabel() CLASS TProveedorLabelGenerator

   if dbLock( dbfProvee )
      ( dbfProvee )->nLabel++
      ( dbfProvee )->( dbUnLock() )
   end if

   ::oBrwLabel:Refresh()
   ::oBrwLabel:SetFocus()

Return ( Self )

//--------------------------------------------------------------------------//

Method DelLabel() CLASS TProveedorLabelGenerator

   if ( dbfProvee )->nLabel > 1
      if dbLock( dbfProvee )
         ( dbfProvee )->nLabel--
         ( dbfProvee )->( dbUnLock() )
      end if
   end if

   ::oBrwLabel:Refresh()
   ::oBrwLabel:SetFocus()

Return ( Self )

//---------------------------------------------------------------------------//

Method EditLabel() CLASS TProveedorLabelGenerator

   local uVar     := ( dbfProvee )->nLabel
	local cPic     := "999"
   local bValid   := { || .t. }
   local nCol     := aScan( ::oBrwLabel:aHeaders, "Und." )

   if nCol != 0

      if ::oBrwLabel:lEditCol( nCol, @uVar, cPic, bValid )

         if dbLock( dbfProvee )
            ( dbfProvee )->nLabel   := uVar
            ( dbfProvee )->( dbUnLock() )
         end if

         ::oBrwLabel:DrawSelect()

      end if

   end if

Return ( Self )

//---------------------------------------------------------------------------//

Method ChangeCriterio() CLASS TProveedorLabelGenerator

   ::oGrupoInicio:Hide()
   ::oGrupoFin:Hide()
   ::oInicio:Hide()
   ::oFin:Hide()
   ::oFechaInicio:Hide()
   ::oFechaFin:Hide()

   do case
      case ::oCriterio:nAt == 2

         ::oGrupoInicio:Show()
         ::oGrupoFin:Show()
         ::oInicio:Show()
         ::oFin:Show()

      case ::oCriterio:nAt == 3

         ::oFechaInicio:Show()
         ::oFechaFin:Show()
         ::oInicio:Show()
         ::oFin:Show()

   end case

Return ( Self )

//---------------------------------------------------------------------------//

Method lPrintLabels() CLASS TProveedorLabelGenerator

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
   Zona de datos------------------------------------------------------------
   */

   DataReport( oFr, .t. )

   /*
   Cargar el informe-----------------------------------------------------------
   */

   if !Empty( ( dbfDoc )->mReport )

      oFr:LoadFromBlob( ( dbfDoc )->( Select() ), "mReport")

      /*
      Zona de variables--------------------------------------------------------
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

   end if

   /*
   Destruye el diseñador-------------------------------------------------------
   */

   oFr:DestroyFr()

   /*
   Destruye el fichero temporal------------------------------------------------
   */

   ::DestroyTemporal()

Return ( .t. )

//---------------------------------------------------------------------------//

Method InitLabel( oLabel ) CLASS TProveedorLabelGenerator

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

Method lCreateTemporal() CLASS TProveedorLabelGenerator

   local n
   local nRec
   local oBlock
   local oError
   local nBlancos
   local lCreateTemporal   := .t.
   local lClose            := .f.

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      tmpProvee            := "LblPrv"
      filProvee            := cGetNewFileName( cPatTmp() + "LblPrv" )

      dbCreate( filProvee, aSqlStruct( aItmPrv() ), cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), filProvee, tmpProvee, .f. )

      ( tmpProvee )->( OrdCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( tmpProvee )->( OrdCreate( filProvee, "Cod", "Cod", {|| Field->Cod } ) )

      if Empty( dbfProvee )
         USE ( cPatPrv() + "PROVEE.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROVEE", @dbfProvee ) )
         SET ADSINDEX TO ( cPatPrv() + "PROVEE.CDX" ) ADDITIVE
         lClose            := .t.
      end if

      nRec                 := ( dbfProvee )->( Recno() )

      ( dbfProvee )->( dbGoTop() )
      while !( dbfProvee )->( eof() )

         if ( dbfProvee )->lLabel
            for n := 1 to ( dbfProvee )->nLabel
               dbPass( dbfProvee, tmpProvee, .t. )
            next
         end if

         ( dbfProvee )->( dbSkip() )

      end while
      ( tmpProvee )->( dbGoTop() )

      ( dbfProvee )->( dbGoTo( nRec ) )

      if lClose
         ( dbfProvee )->( dbCloseArea() )
         dbfProvee         := nil
      end if

   RECOVER USING oError

      lCreateTemporal      := .f.

      MsgStop( 'Imposible abrir ficheros de proveedores' + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lCreateTemporal )

//---------------------------------------------------------------------------//

Method PrepareTemporal( oFr ) CLASS TProveedorLabelGenerator

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
      dbPass( dbBlankRec( dbfProvee ), tmpProvee, .t. )
   next

   ( tmpProvee )->( dbGoTop() )

Return ( .t. )

//---------------------------------------------------------------------------//

Method DestroyTemporal() CLASS TProveedorLabelGenerator

   if ( tmpProvee )->( Used() )
      ( tmpProvee )->( dbCloseArea() )
   end if

   dbfErase( filProvee )

Return ( .t. )

//---------------------------------------------------------------------------//

Method SelectColumn( oCombo ) CLASS TProveedorLabelGenerator

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

#endif
//---------------------------------------------------------------------------//

Static Function lLabel( dbfTmpLbl )

Return ( ( dbfTmpLbl)->lLabel )

//---------------------------------------------------------------------------//

Static Function SkipLabel( dbfProvee, oMtr )

   if ( dbfProvee )->lLabel .and. ( dbfProvee )->nLabel > nLabels
      ++nLabels
   else
      nLabels  := 1
      ( dbfProvee )->( dbSkip() )
   end if

   if !Empty( oMtr )
      oMtr:Set( ( dbfProvee )->( ordKeyNo() ) )
   end if

Return ( ( dbfProvee )->( Recno() ) )

//----------------------------------------------------------------------------//

#else

//---------------------------------------------------------------------------//
//Funciones del pda
//---------------------------------------------------------------------------//

STATIC FUNCTION pdaOpenFiles( lExt, cPath )

   local oError
   local oBlock

   if lOpenFiles
      MsgStop( 'Imposible abrir ficheros de proveedores' )
      Return ( .f. )
   end if

   DEFAULT  lExt     := .f.
   DEFAULT  cPath    := cPatEmp()

   lExternal         := lExt

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      lOpenFiles     := .t.

      USE ( cPatPrv() + "PROVEE.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROVEE", @dbfProvee ) )
      SET ADSINDEX TO ( cPatPrv() + "PROVEE.CDX" ) ADDITIVE

      USE ( cPatPrv() + "PROVEED.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROVEED", @dbfProveeD ) )
      SET ADSINDEX TO ( cPatPrv() + "PROVEED.CDX" ) ADDITIVE

      cPinDiv        := cPinDiv( cDivEmp(), dbfDiv ) // Picture de la divisa
      cPirDiv        := cPirDiv( cDivEmp(), dbfDiv ) // Picture de la divisa redondeada

   RECOVER USING oError

      lOpenFiles     := .f.
      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos de proveedores' )

   END SEQUENCE

   ErrorBlock( oBlock )

#ifndef __PDA__
   if !lOpenFiles
      CloseFiles()
   end if
#else
   if !lOpenFiles
      pdaCloseFiles()
   end if
#endif

RETURN ( lOpenFiles )

//----------------------------------------------------------------------------//

STATIC FUNCTION pdaCloseFiles( lDestroy )

	DEFAULT lDestroy	:= .f.

   if lDestroy
		oWndBrw:oBrw:lCloseArea()
      oWndBrw        := nil
   else
      if dbfProvee != nil
         ( dbfProvee )->( dbCloseArea() )
      end if
   end if

   CLOSE ( dbfProveeD )
   CLOSE ( dbfPedPrvT )
   CLOSE ( dbfPedPrvL )
	CLOSE ( dbfAlbPrvT )
	CLOSE ( dbfAlbPrvL )
	CLOSE ( dbfFacPrvT )
	CLOSE ( dbfFacPrvL )
   CLOSE ( dbfFPago   )
   CLOSE ( dbfArtPrv  )
   CLOSE ( dbfIva     )
   CLOSE ( dbfArticulo)
   CLOSE ( dbfDiv     )
   CLOSE ( dbfBanco   )

   if !Empty( oPais )
      oPais:End()
   end if
   if !Empty( oGrpPrv )
      oGrpPrv:End()
   end if

   dbfProvee   := nil
   dbfProveeD  := nil
   dbfPedPrvT  := nil
   dbfPedPrvL  := nil
   dbfAlbPrvT  := nil
   dbfAlbPrvL  := nil
   dbfFacPrvT  := nil
   dbfFacPrvL  := nil
   dbfFPago    := nil
   dbfArtPrv   := nil
   dbfIva      := nil
   dbfArticulo := nil
   dbfDiv      := nil
   oBandera    := nil
   oPais       := nil
   dbfBanco    := nil
   oGrpPrv     := nil

   lOpenFiles  := .f.

Return ( .t. )

//--------------------------------------------------------------------------//

#endif

//----------------------------------------------------------------------------//
//Funciones comunes del programa y pda
//----------------------------------------------------------------------------//

Function IsProvee()

   local oError
   local oBlock

   if !lExistTable( cPatPrv() + "PROVEE.Dbf" ) .or.;
      !lExistTable( cPatPrv() + "PROVEED.Dbf" )
      mkProvee( cPatPrv() )
   end if

   if !lExistIndex( cPatPrv() + "PROVEE.Cdx" ) .or.;
      !lExistIndex( cPatPrv() + "PROVEED.Cdx" )
      rxProvee( cPatPrv() )
   end if

Return ( .t. )

//----------------------------------------------------------------------------//

FUNCTION mkProvee( cPath, lAppend, cPathOld, oMeter )

   local dbfPrv
   local oldPrv
   local dbfBnc
   local oldBnc
   local dbfPrvD
   local oldPrvD

   DEFAULT lAppend   := .f.
   DEFAULT cPath     := cPatPrv()

	IF oMeter != NIL
		oMeter:cText	:= "Generando Bases"
		sysrefresh()
	END IF

   IF !lExistTable( cPath + "Provee.Dbf", cLocalDriver() )
      dbCreate( cPath + "Provee.Dbf", aSqlStruct( aItmPrv() ), cLocalDriver() )
   END IF

   IF !lExistTable( cPath + "PROVEED.DBF", cLocalDriver() )
      dbCreate( cPath + "PROVEED.DBF", aSqlStruct( aPrvDoc() ), cLocalDriver() )
   END IF

   IF !lExistTable( cPath + "PRVBNC.DBF", cLocalDriver() )
      dbCreate( cPath + "PRVBNC.DBF", aSqlStruct( aPrvBnc() ), cLocalDriver() )
   END IF

   rxProvee( cPath, cLocalDriver() )

	if lAppend .and. lIsDir( cPathOld )
      appDbf( cPathOld, cPath, "Provee" )
      appDbf( cPathOld, cPath, "ProveeD" )
      appDbf( cPathOld, cPath, "PrvBnc" )
   end if

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION rxProvee( cPath, cDriver )

	local dbfProvee

   DEFAULT cPath     := cPatPrv()
   DEFAULT cDriver   := cDriver()

   fEraseIndex( cPath + "Provee.Cdx", cDriver )
   fEraseIndex( cPath + "ProveeD.Cdx", cDriver )
   fEraseIndex( cPath + "PrvBnc.Cdx", cDriver )

   dbUseArea( .t., cDriver, cPath + "Provee.Dbf", cCheckArea( "PROVEE", @dbfProvee ), .f. )
   if !( dbfProvee )->( neterr() )
      ( dbfProvee )->( __dbPack() )

      ( dbfProvee )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfProvee )->( ordCreate( cPath + "Provee.Cdx", "COD", "COD", {|| Field->COD } )      )

      ( dbfProvee )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfProvee )->( ordCreate( cPath + "Provee.Cdx", "TITULO", "UPPER( TITULO )", {|| UPPER( Field->TITULO ) } ) )

      ( dbfProvee )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfProvee )->( ordCreate( cPath + "Provee.Cdx", "NIF", "NIF", {|| Field->NIF }, ) )

      ( dbfProvee )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfProvee )->( ordCreate( cPath + "Provee.Cdx", "POBLACION", "POBLACION", {|| Field->POBLACION } ) )

      ( dbfProvee )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfProvee )->( ordCreate( cPath + "Provee.Cdx", "Telefono", "Telefono", {|| Field->Telefono } ) )

      ( dbfProvee )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfProvee )->( ordCreate( cPath + "Provee.Cdx", "Fax", "Fax", {|| Field->Fax } ) )

      ( dbfProvee )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfProvee )->( ordCreate( cPath + "Provee.Cdx", "CodPostal", "CodPostal", {|| Field->CodPostal } ) )

      ( dbfProvee )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfProvee )->( ordCreate( cPath + "Provee.Cdx", "Provincia", "Provincia", {|| Field->Provincia } ) )

      ( dbfProvee )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfProvee )->( ordCreate( cPath + "Provee.Cdx", "cMeiInt", "cMeiInt", {|| Field->cMeiInt } ) )

      ( dbfProvee )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfProvee )->( ordCreate( cPath + "Provee.Cdx", "cPerCto", "cPerCto", {|| Field->cPerCto } ) )

      ( dbfProvee )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfProvee )->( ordCreate( cPath + "Provee.Cdx", "cNbrEst", "Upper( cNbrEst )", {|| Upper( Field->cNbrEst ) } ) )

      ( dbfProvee )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfProvee )->( ordCreate( cPath + "Provee.Cdx", "lSndInt", "lSndInt", {|| Field->lSndInt } ) )

      ( dbfProvee )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfProvee )->( ordCreate( cPath + "Provee.Cdx", "cCodUsr", "Field->cCodUsr + Dtos( Field->dFecChg ) + Field->cTimChg", {|| Field->cCodUsr + Dtos( Field->dFecChg ) + Field->cTimChg } ) )

      ( dbfProvee )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de proveedores" )
   end if

   dbUseArea( .t., cDriver, cPath + "PROVEED.DBF", cCheckArea( "PROVEED", @dbfProvee ), .f. )
   if !( dbfProvee )->( neterr() )
      ( dbfProvee )->( __dbPack() )

      ( dbfProvee )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfProvee )->( ordCreate( cPath + "PROVEED.CDX", "CCODPRV", "CCODPRV", {|| Field->CCODPRV } )      )

      ( dbfProvee )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de proveedores" )
   end if

   fEraseIndex( cPath + "PrvBnc.Cdx" )

   dbUseArea( .t., cDriver, cPath + "PrvBnc.DBF", cCheckArea( "PrvBnc", @dbfProvee ), .f. )
   if !( dbfProvee )->( neterr() )
      ( dbfProvee )->( __dbPack() )

      ( dbfProvee )->( ordCondSet( "!Deleted()", {|| !Deleted()}  ) )
      ( dbfProvee )->( ordCreate( cPath + "PrvBnc.CDX", "cCodPrv", "cCodPrv + cCodBnc", {|| Field->cCodPrv + Field->cCodBnc } ) )

      ( dbfProvee )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfProvee )->( ordCreate( cPath + "PrvBnc.CDX", "cCtaBnc", "cCodPrv + cEntBnc + cSucBnc + cDigBnc + cCtaBnc", {|| Field->cCodPrv + Field->cEntBnc + Field->cSucBnc + Field->cDigBnc + Field->cCtaBnc } ) )

      ( dbfProvee )->( ordCondSet("!Deleted() .and. lBncDef", {|| !Deleted() .and. Field->lBncDef } ) )
      ( dbfProvee )->( ordCreate( cPath + "PrvBnc.CDX", "cBncDef", "cCodPrv + cCodBnc", {|| Field->cCodPrv + Field->cCodBnc } ) )

      ( dbfProvee )->( ordCondSet("!Deleted() .and. lBncDef", {|| !Deleted() .and. Field->lBncDef } ) )
      ( dbfProvee )->( ordCreate( cPath + "PrvBnc.CDX", "cCodDef", "cCodPrv + cEntBnc + cSucBnc + cDigBnc + cCtaBnc", {|| Field->CCODPrv + Field->CENTBNC + Field->CSUCBNC + Field->CDIGBNC + Field->CCTABNC } ) )

      ( dbfProvee )->( dbCloseArea() )

   else

      msgStop( "Imposible abrir en modo exclusivo la tabla de bancos de proveedores" )

   end if

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION RetProvee( cCodProv, dbfProvee )

   local oBlock
   local oError
	local cAreaAnt 	:= Alias()
	local cProveedor 	:= ""
	local lClose		:= .f.

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   	if empty( dbfProvee )
         USE ( cPatPrv() + "PROVEE.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROVEE", @dbfProvee ) )
         SET ADSINDEX TO ( cPatPrv() + "PROVEE.CDX" ) ADDITIVE
   		lClose	   := .t.
   	end if

      if dbSeekInOrd( cCodProv, "Cod", dbfProvee )
   		cProveedor  := (dbfProvee)->Titulo
   	end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

	if lClose
		CLOSE ( dbfProvee )
	end if

	if cAreaAnt != ""
		SELECT( cAreaAnt )
	end if

RETURN cProveedor

//--------------------------------------------------------------------------//

Function cSeekProveedor( cCodArt, dbfArtPrv )

   local nPosComa          := At( ",", cCodArt )
   local cProveedor        := Left( cCodArt, nPosComa - 1 )
   local cRefProv          := Right( AllTrim( cCodArt ), len( AllTrim( cCodArt ) ) - nPosComa )
   local nOrdenAnterior    := ( dbfArtPrv )->( OrdSetFocus( "cRefPrv" ) )

   cProveedor              := RJust( cProveedor, "0", RetNumCodPrvEmp() )

   if ( dbfArtPrv )->( dbSeek( Padr( cProveedor, 12 ) + Padr( cRefProv, 18 ) ) )
      cCodArt              := ( dbfArtPrv )->cCodArt
   end if

   ( dbfArtPrv )->( OrdSetFocus( nOrdenAnterior ) )

return cCodArt

//---------------------------------------------------------------------------//

FUNCTION aItmPrv()

   local aItmPrv  := {}

   aAdd( aItmPrv, { "Cod",       "C", 12, 0, "Código proveedor",                     "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "Titulo",    "C", 80, 0, "Nombre proveedor",                     "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "Nif",       "C", 15, 0, "NIF proveedor",                        "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "Domicilio", "C",200, 0, "Domicilio proveedor",                  "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "Poblacion", "C",200, 0, "Población proveedor",                  "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "Provincia", "C",100, 0, "Provincia proveedor",                  "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "CCODPAI",   "C",  4, 0, "Código de país" ,                      "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "CPERCTO",   "C", 40, 0, "Persona de contacto",                  "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "CSUCLI",    "C", 14, 0, "Código de su cliente" ,                "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "CodPostal", "C", 15, 0, "Código postal proveedor",              "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "Telefono",  "C", 50, 0, "Teléfono proveedor",                   "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "FAX",       "C", 50, 0, "Fax proveedor",                        "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "MOVIL",     "C", 50, 0, "Movil proveedor",                      "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "cDtoEsp",   "C", 50, 0, "Descripción de descuento especial",    "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "nDtoEsp",   "N",  6, 2, "Descuento especial",                   "'@R 99.9 %'",        "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "cDtoPp",    "C", 50, 0, "Descripción de descuento pronto pago", "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "DtoPp",     "N",  6, 2, "Descuento pronto pago",                "'@R 99.9 %'",        "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "FPAGO",     "C",  2, 0, "Forma de pago proveedor",              "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "DIAPAGO",   "N",  2, 0, "Primer día pago proveedor",            "'99'",               "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "DIAPAGO2",  "N",  2, 0, "Segundo día pago proveedor",           "'99'",               "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "SUBCTA",    "C", 12, 0, "Subcuenta contaplus proveedor",        "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "CTAVENTA",  "C",  3, 0, "Cuenta contaplus proveedor",           "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "LLABEL",    "L",  1, 0, "Lógico para etiquetas",                "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "NLABEL",    "N",  5, 0, "Número de etiquetas a imprimir",       "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "CCODSND",   "C",  3, 0, "Código de envio proveedor",            "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "CMEIINT",   "C", 65, 0, "dirección e-mail proveedor",           "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "CWEBINT",   "C",100, 0, "Página web proveedor",                 "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "CUSRINT",   "C", 14, 0, "Usuario para la web del proveedor",    "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "CPSWINT",   "C", 14, 0, "Clave de acceso para la web del proveedor", "",              "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "MCOMENT",   "M", 10, 0, "Memo para comentarios",                "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "NMESVAC",   "N",  1, 0, "Mes de vacaciones",                    "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "NCOPIASF",  "N",  1, 0, "Número de facturas a imprimir",        "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "CUSRDEF01", "C",100, 0, "Campo definido 1" ,                    "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "CUSRDEF02", "C",100, 0, "Campo definido 2" ,                    "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "CUSRDEF03", "C",100, 0, "Campo definido 3" ,                    "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "CUSRDEF04", "C",100, 0, "Campo definido 4" ,                    "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "CUSRDEF05", "C",100, 0, "Campo definido 5" ,                    "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "CUSRDEF06", "C",100, 0, "Campo definido 6" ,                    "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "CUSRDEF07", "C",100, 0, "Campo definido 7" ,                    "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "CUSRDEF08", "C",100, 0, "Campo definido 8" ,                    "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "CUSRDEF09", "C",100, 0, "Campo definido 9" ,                    "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "CUSRDEF10", "C",100, 0, "Campo definido 10" ,                   "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "NVALPUNT",  "N", 16, 6, "Valor del punto" ,                     "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "CTELCTO",   "C", 12, 0, "Teléfono del contacto" ,               "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "Benef1",    "N",  6, 2, "Porcentaje de beneficio1" ,            "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "Benef2",    "N",  6, 2, "Porcentaje de beneficio2" ,            "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "Benef3",    "N",  6, 2, "Porcentaje de beneficio3" ,            "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "Benef4",    "N",  6, 2, "Porcentaje de beneficio4" ,            "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "Benef5",    "N",  6, 2, "Porcentaje de beneficio5" ,            "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "Benef6",    "N",  6, 2, "Porcentaje de beneficio6" ,            "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "nBnfSbr1",  "N",  1, 0, "Sobre compra o sobre venta 1" ,        "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "nBnfSbr2",  "N",  1, 0, "Sobre compra o sobre venta 2" ,        "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "nBnfSbr3",  "N",  1, 0, "Sobre compra o sobre venta 3" ,        "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "nBnfSbr4",  "N",  1, 0, "Sobre compra o sobre venta 4" ,        "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "nBnfSbr5",  "N",  1, 0, "Sobre compra o sobre venta 5" ,        "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "nBnfSbr6",  "N",  1, 0, "Sobre compra o sobre venta 6" ,        "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "lSndInt",   "L",  1, 0, "Lógico para envio",                    "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "cCodUsr",   "C",  3, 0, "Código de usuario que realiza el cambio" ,"",                "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "dFecChg",   "D",  8, 0, "Fecha de cambio" ,                     "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "cTimChg",   "C",  5, 0, "Hora de cambio" ,                      "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "nTipRet",   "N",  1, 0, "Tipo de retención ( 1. Base / 2. Base+IVA )","",             "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "nPctRet",   "N",  6, 2, "Porcentaje de retención",              "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "nPlzEnt",   "N",  3, 0, "Plazo de entrega en días",             "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "lBlqPrv",   "L",  1, 0, "Proveedor bloqueado",                  "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "dFecBlq",   "D",  8, 0, "Fecha de bloqueo del proveedor",       "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "cMotBlq",   "C", 50, 0, "Motivo del bloqueo del proveedor",     "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "cCodGrp",   "C",  4, 0, "Código grupo de proveedor",            "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "nRegIva",   "N",  1, 0, "Regimen de " + cImp(),                 "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "lMail",     "L",  1, 0, "Lógico para enviar mail",              "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "mObserv",   "M", 10, 0, "Observaciones",                        "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "lMosCom",   "L",  1, 0, "Mostrar comentario" ,                  "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "lReq",      "L",  1, 0, "Lógico recargo equivalencia" ,         "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "cNbrEst",   "C",150, 0, "Nombre del establecimiento" ,          "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "cDirEst",   "C",150, 0, "dirección del establecimiento" ,       "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "Serie",     "C",  1, 0, "Serie del documento" ,                 "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "lRECC",     "L",  1, 0, "Acogido al régimen especial del criterio de caja",  "",      "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "TELEFONO2", "C", 50, 0, "Teléfono2 proveedor",                  "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "MOVIL2",    "C", 50, 0, "Movil2 proveedor",                     "",                   "", "( cDbfPrv )" } )

RETURN ( aItmPrv )

//----------------------------------------------------------------------------//

FUNCTION aPrvBnc()

   local aBase := {}

   aAdd( aBase, { "cCodPrv",     "C", 12, 0, "Código",                                    "",         "", "( cDbfBnc )" } )
   aAdd( aBase, { "lBncDef",     "L",  1, 0, "Banco por defecto",                         "",         "", "( cDbfBnc )" } )
   aAdd( aBase, { "cCodBnc",     "C", 50, 0, "Nombre del banco",                          "",         "", "( cDbfBnc )" } )
   aAdd( aBase, { "cDirBnc",     "C", 35, 0, "Domicilio del banco",                       "",         "", "( cDbfBnc )" } )
   aAdd( aBase, { "cPobBnc",     "C", 25, 0, "Población del banco",                       "",         "", "( cDbfBnc )" } )
   aAdd( aBase, { "cProBnc",     "C", 20, 0, "Provincia del banco",                       "",         "", "( cDbfBnc )" } )
   aAdd( aBase, { "cCPBnc",      "C", 15, 0, "Código postal",                             "",         "", "( cDbfBnc )" } )
   aAdd( aBase, { "cTlfBnc",     "C", 20, 0, "Teléfono",                                  "",         "", "( cDbfBnc )" } )
   aAdd( aBase, { "cFaxBnc",     "C", 20, 0, "Fax",                                       "",         "", "( cDbfBnc )" } )
   aAdd( aBase, { "cPContBnc",   "C", 35, 0, "Persona de contacto",                       "",         "", "( cDbfBnc )" } )
   aAdd( aBase, { "cPaiBnc",     "C",  4, 0, "Pais",                                      "",         "", "( cDbfBnc )" } )
   aAdd( aBase, { "cPaisIBAN",   "C",  2, 0, "País IBAN",                                 "",         "", "( cDbfBnc )" } )
   aAdd( aBase, { "cCtrlIBAN",   "C",  2, 0, "Dígito de control IBAN",                    "",         "", "( cDbfBnc )" } )
   aAdd( aBase, { "cEntBnc",     "C",  4, 0, "Entidad de la cuenta bancaria",             "",         "", "( cDbfBnc )" } )
   aAdd( aBase, { "cSucBnc",     "C",  4, 0, "Sucursal de la cuenta bancaria",            "",         "", "( cDbfBnc )" } )
   aAdd( aBase, { "cDigBnc",     "C",  2, 0, "Dígito de control de la cuenta bancaria",   "",         "", "( cDbfBnc )" } )
   aAdd( aBase, { "cCtaBnc",     "C", 20, 0, "Cuenta bancaria",                           "",         "", "( cDbfBnc )" } )
   aAdd( aBase, { "nSalIni",     "N", 16, 6, "Saldo inicial",                             "",         "", "( cDbfBnc )" } )

RETURN ( aBase )

//---------------------------------------------------------------------------//

function aPrvDoc()

   local aPrvDoc  := {}

   aAdd( aPrvDoc, { "cCodPrv", "C",   12,  0, "Código del proveedor" ,            "",                   "", "( cDbfCol )" } )
   aAdd( aPrvDoc, { "cNombre", "C",  250,  0, "Nombre del documento" ,            "",                   "", "( cDbfCol )" } )
   aAdd( aPrvDoc, { "cRuta",   "C",  250,  0, "Ruta del documento" ,              "",                   "", "( cDbfCol )" } )
   aAdd( aPrvDoc, { "mObsDoc", "M",   10,  0, "Observaciones del documento" ,     "",                   "", "( cDbfCol )" } )

return ( aPrvDoc )

//---------------------------------------------------------------------------//

FUNCTION cProvee( oGet, dbfProvee, oGet2 )

   local oBlock
   local oError
   local lClose   := .f.
   local lValid   := .f.
	local xValor 	:= oGet:varGet()

   if Empty( xValor )
      if !Empty( oGet2 )
         oGet2:cText( "" )
      end if
      return .t.
   elseif At( ".", xValor ) != 0
      xValor      := PntReplace( oGet, "0", RetNumCodPrvEmp() )
   else
      xValor      := RJustObj( oGet, "0", RetNumCodPrvEmp() )
   end if

   if ( Alltrim( xValor ) == Replicate( "Z", len( Alltrim( xValor ) ) ) )
      return .t.
   end if

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if Empty( dbfProvee )
      USE ( cPatPrv() + "PROVEE.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROVEE", @dbfProvee ) )
      SET ADSINDEX TO ( cPatPrv() + "PROVEE.CDX" ) ADDITIVE
      lClose   := .t.
   end if

   IF ( dbfProvee )->( dbSeek( xValor ) )

      oGet:cText( ( dbfProvee )->Cod )

		IF oGet2 != NIL
         oGet2:cText( ( dbfProvee )->Titulo )
		END IF

		lValid	:= .T.

	ELSE

		msgStop( "Proveedor no encontrado" )

	END IF

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if lClose
		CLOSE (dbfProvee)
   end if

RETURN lValid

//---------------------------------------------------------------------------//

FUNCTION BrwProvee( oGet, oGet2, lApp )

	local oDlg
	local oBrw
	local oGet1
	local cGet1
   local nOrd        := GetBrwOpt( "BrwProvee" )
	local oCbxOrd
   local cCbxOrd
   local cTxtOrigen
   local cReturn     := Space( 12 )
   local nLevelUsr   := Auth():Level( "01034" )
   local aCbxOrd     := {  "Código", "Nombre", "NIF/CIF", "Población", "Teléfono", "Fax", "Domicilio", "Población", "Código postal", "Provincia", "Correo electrónico", "Contacto" }

   nOrd              := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd           := aCbxOrd[ nOrd ]

#ifndef __PDA__
   if !OpenFiles( .t. )
      Return nil
   end if
#else
   if !pdaOpenFiles( .t. )
      Return nil
   end if
#endif

   DEFAULT lApp      := .t.

   /*
   Origen de busqueda----------------------------------------------------------
   */

   ( dbfProvee )->( OrdSetFocus( nOrd ) )

   if IsObject( oGet )
      cTxtOrigen     := oGet:VarGet()
      if Empty( cTxtOrigen ) .or. !( dbfProvee )->( dbSeek( cTxtOrigen ) )
         ( dbfProvee )->( dbGoTop() )
      end if
   end if

   /*
   Distintas cajas de dialogo--------------------------------------------------
   */

   if IsPda()
      DEFINE DIALOG oDlg RESOURCE "HELPENTRY_PDA"  TITLE "Seleccionar proveedores"
   else
      DEFINE DIALOG oDlg RESOURCE "HELPENTRY"      TITLE "Seleccionar proveedores"
   end if

      REDEFINE GET oGet1 VAR cGet1;
         PICTURE  "@!" ;
			ID 		104 ;
			ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfProvee ) ) ;
         VALID    ( OrdClearScope( oBrw, dbfProvee ) );
         BITMAP   "FIND" ;
         OF       oDlg

      REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( ( dbfProvee )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:refresh(), oGet1:SetFocus() ) ;
			OF 		oDlg

#ifndef __PDA__
      oBrw                 := IXBrowse():New( oDlg )
#endif

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfProvee
      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "Browse.Proveedor"

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "Cod"
         :bEditValue       := {|| ( dbfProvee )->Cod }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "Titulo"
         :bEditValue       := {|| ( dbfProvee )->Titulo }
         :nWidth           := 260
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "NIF/CIF"
         :cSortOrder       := "Nif"
         :bEditValue       := {|| ( dbfProvee )->Nif }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Teléfono"
         :cSortOrder       := "Telefono"
         :bEditValue       := {|| ( dbfProvee )->Telefono }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Fax"
         :bEditValue       := {|| ( dbfProvee )->Fax }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Domicilio"
         :bEditValue       := {|| ( dbfProvee )->Domicilio }
         :nWidth           := 300
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Población"
         :cSortOrder       := "Poblacion"
         :bEditValue       := {|| ( dbfProvee )->Poblacion }
         :nWidth           := 200
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Código postal"
         :cSortOrder       := "CodPostal"
         :bEditValue       := {|| ( dbfProvee )->CodPostal }
         :nWidth           := 60
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Provincia"
         :cSortOrder       := "Provincia"
         :bEditValue       := {|| ( dbfProvee )->Provincia }
         :nWidth           := 100
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Correo electrónico"
         :cSortOrder       := "cMeiInt"
         :bEditValue       := {|| ( dbfProvee )->cMeiInt }
         :nWidth           := 100
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Contacto"
         :bEditValue       := {|| ( dbfProvee )->cPerCto }
         :nWidth           := 200
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Observaciones"
         :bEditValue       := {|| ( dbfProvee )->mComent }
         :nWidth           := 200
      end with

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }
      oBrw:bRClicked       := {| nRow, nCol, nFlags | oBrw:RButtonDown( nRow, nCol, nFlags ) }

      oBrw:CreateFromResource( 105 )

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         ACTION   ( oDlg:end( IDOK ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

   if !IsPda()

   if lApp

      REDEFINE BUTTON ;
			ID 		500 ;
			OF 		oDlg ;
         WHEN     ( nAnd( nLevelUsr, ACC_APPD ) != 0 .and. !IsReport() );
         ACTION   ( WinAppRec( oBrw, bEdit, dbfProvee ) )

      REDEFINE BUTTON ;
			ID 		501 ;
			OF 		oDlg ;
         WHEN     ( nAnd( nLevelUsr, ACC_EDIT ) != 0 .and. !IsReport() );
         ACTION   ( WinEdtRec( oBrw, bEdit, dbfProvee ) )

      if nAnd( nLevelUsr, ACC_APPD ) != 0 .and. !IsReport()
         oDlg:AddFastKey( VK_F2, {|| WinAppRec( oBrw, bEdit, dbfProvee ) } )
      end if

      if nAnd( nLevelUsr, ACC_EDIT ) != 0 .and. !IsReport()
         oDlg:AddFastKey( VK_F3, {|| WinEdtRec( oBrw, bEdit, dbfProvee ) } )
      end if

   else

      REDEFINE BUTTON ;
			ID 		500 ;
			OF 		oDlg ;
         WHEN     ( .f. );
         ACTION   ( nil )

      REDEFINE BUTTON ;
			ID 		501 ;
			OF 		oDlg ;
         WHEN     ( .f. );
         ACTION   ( nil )

   end if

   end if

   oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )
   oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )

   oDlg:bStart := {|| oBrw:Load() }

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK

      cReturn     := ( dbfProvee )->Cod

      if IsObject( oGet )
         oGet:cText( ( dbfProvee )->Cod )
         oGet:lValid()
      end if

      if IsObject( oGet2 )
         oGet2:cText( ( dbfProvee )->Titulo )
      end if

   end if

   DestroyFastFilter( dbfProvee )

   SetBrwOpt( "BrwProvee", ( dbfProvee )->( OrdNumber() ) )

#ifndef __PDA__
   CloseFiles()
#else
   pdaCloseFiles()
#endif

RETURN ( cReturn )

//---------------------------------------------------------------------------//

FUNCTION BrwPrv( oGet, oGet2, dbfProvee )

	local oDlg
	local oBrw
	local oGet1
	local cGet1
   local nOrd        := GetBrwOpt( "BrwProvee" )
	local oCbxOrd
   local cCbxOrd
   local cTxtOrigen
   local cReturn     := Space( 12 )
   local nLevelUsr   := Auth():Level( "01034" )
   local aCbxOrd     := {  "Código", "Nombre", "NIF/CIF", "Población", "Teléfono", "Fax", "Domicilio", "Población", "Código postal", "Provincia", "Correo electrónico", "Contacto" }

   nOrd              := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd           := aCbxOrd[ nOrd ]

   nOrd              := ( dbfProvee )->( OrdSetFocus( nOrd ) )

   ( dbfProvee )->( dbGoTop() )

   /*
   Distintas cajas de dialogo--------------------------------------------------
   */

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY"      TITLE "Seleccionar proveedores"

      REDEFINE GET oGet1 VAR cGet1;
         PICTURE  "@!" ;
			ID 		104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfProvee ) ) ;
         VALID    ( OrdClearScope( oBrw, dbfProvee ) );
         BITMAP   "FIND" ;
         OF       oDlg

      REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( ( dbfProvee )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:refresh(), oGet1:SetFocus() ) ;
			OF 		oDlg

      oBrw                 := IXBrowse():New( oDlg )
      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfProvee
      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "Browse.Proveedor.Report"

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "Cod"
         :bEditValue       := {|| ( dbfProvee )->Cod }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "Titulo"
         :bEditValue       := {|| ( dbfProvee )->Titulo }
         :nWidth           := 260
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "NIF/CIF"
         :cSortOrder       := "Nif"
         :bEditValue       := {|| ( dbfProvee )->Nif }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Teléfono"
         :cSortOrder       := "Telefono"
         :bEditValue       := {|| ( dbfProvee )->Telefono }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Fax"
         :bEditValue       := {|| ( dbfProvee )->Fax }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Domicilio"
         :bEditValue       := {|| ( dbfProvee )->Domicilio }
         :nWidth           := 300
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Población"
         :cSortOrder       := "Poblacion"
         :bEditValue       := {|| ( dbfProvee )->Poblacion }
         :nWidth           := 200
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Código postal"
         :cSortOrder       := "CodPostal"
         :bEditValue       := {|| ( dbfProvee )->CodPostal }
         :nWidth           := 60
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Provincia"
         :cSortOrder       := "Provincia"
         :bEditValue       := {|| ( dbfProvee )->Provincia }
         :nWidth           := 100
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Correo electrónico"
         :cSortOrder       := "cMeiInt"
         :bEditValue       := {|| ( dbfProvee )->cMeiInt }
         :nWidth           := 100
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Contacto"
         :bEditValue       := {|| ( dbfProvee )->cPerCto }
         :nWidth           := 200
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Observaciones"
         :bEditValue       := {|| ( dbfProvee )->mComent }
         :nWidth           := 200
      end with

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }
      oBrw:bRClicked       := {| nRow, nCol, nFlags | oBrw:RButtonDown( nRow, nCol, nFlags ) }

      oBrw:CreateFromResource( 105 )

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         ACTION   ( oDlg:end( IDOK ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

      REDEFINE BUTTON ;
			ID 		500 ;
			OF 		oDlg ;
         WHEN     ( .f. );
         ACTION   ( nil )

      REDEFINE BUTTON ;
			ID 		501 ;
			OF 		oDlg ;
         WHEN     ( .f. );
         ACTION   ( nil )

      oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )
      oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )

      oDlg:bStart := {|| oBrw:Load() }

   ACTIVATE DIALOG oDlg CENTER

   CursorWait()

   if oDlg:nResult == IDOK

      cReturn     := ( dbfProvee )->Cod

      if IsObject( oGet )
         oGet:cText( ( dbfProvee )->Cod )
         oGet:lValid()
      end if

      if IsObject( oGet2 )
         oGet2:cText( ( dbfProvee )->Titulo )
      end if

   end if

   DestroyFastFilter( dbfProvee )

   SetBrwOpt( "BrwProvee", ( dbfProvee )->( OrdNumber() ) )

   ( dbfProvee )->( OrdSetFocus( nOrd ) )

   if !Empty( oBrw )
      oBrw:end()
   end if

   CursorWE()

   if !Empty( oGet )
      oGet:SetFocus()
   end if

RETURN ( cReturn )

//---------------------------------------------------------------------------//


#ifndef  __PDA__

Function DesignReportProvee( oFr, dbfDoc )

   local oLabel   := TProveedorLabelGenerator()

   if oLabel:lCreateTemporal()

      /*
      Zona de datos------------------------------------------------------------
      */

      DataReport( oFr, .t. )

      /*
      Paginas y bandas---------------------------------------------------------
      */

      if !Empty( ( dbfDoc )->mReport )

         oFr:LoadFromBlob( ( dbfDoc )->( Select() ), "mReport" )

      else

         oFr:AddPage(         "MainPage" )

         oFr:AddBand(         "MasterData",  "MainPage",       frxMasterData )
         oFr:SetProperty(     "MasterData",  "Top",            200 )
         oFr:SetProperty(     "MasterData",  "Height",         100 )
         oFr:SetObjProperty(  "MasterData",  "DataSet",        "Proveedores" )

      end if

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

      Return .f.

   end if

Return .t.

#endif

//---------------------------------------------------------------------------//

Static Function DataReport( oFr, lTemporal )

   /*
   Zona de datos---------------------------------------------------------------
   */

   oFr:ClearDataSets()

   if lTemporal
      oFr:SetWorkArea(  "Proveedores", ( tmpProvee )->( Select() ), .f., { FR_RB_FIRST, FR_RE_LAST, 0 } )
   else
      oFr:SetWorkArea(  "Proveedores", ( dbfProvee )->( Select() ), .f., { FR_RB_FIRST, FR_RE_LAST, 0 } )
   end if

   oFr:SetFieldAliases( "Proveedores", cItemsToReport( aItmPrv() ) )

Return nil

//---------------------------------------------------------------------------//
/*
Devuelve la cuenta del banco proveedor
*/

FUNCTION cCtaBanPrv( cCodPrv, dbfBanco )

   local nRec
   local oBlock
   local oError
   local cText    := ""
   local lClose   := .f.
   local nOrdAnt

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if Empty( dbfBanco )
      USE ( cPatPrv() + "PRVBNC.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PRVBNC", @dbfBanco ) )
      SET ADSINDEX TO ( cPatPrv() + "PRVBNC.CDX" ) ADDITIVE
      SET TAG TO CCODDEF
      lClose      := .t.
   else
      nRec        := ( dbfBanco )->( Recno() )
      nOrdAnt     := ( dbfBanco )->( OrdSetFocus( "cCodDef" ) )
   end if

   if ( dbfBanco )->( dbSeek( cCodPrv ) )
      cText       := ( dbfBanco )->cCtaBnc
   end if

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos de bancos" )

   END SEQUENCE
   ErrorBlock( oBlock )

   if lClose
      CLOSE ( dbfBanco )
   else
      ( dbfBanco )->( OrdSetFocus( nOrdAnt ) )
      ( dbfBanco )->( dbGoTo( nRec ) )
   end if

Return ( cText )

//---------------------------------------------------------------------------//

FUNCTION BrwBncPrv( oGet, oPaisIBAN, oCtrlIBAN, oEntBnc, oSucBnc, oDigBnc, oCtaBnc, cCodPrv, dbfBancos )

	local oDlg
	local oBrw
   local oFont
   local oBtn
	local oGet1
	local cGet1
   local nOrd        := GetBrwOpt( "BrwBncPrv" )
	local oCbxOrd
   local aCbxOrd     := { "Cuenta" }
   local cCbxOrd     := "Cuenta"
   local nLevel      := Auth():Level( "01110" )
   local lClose      := .f.

   nOrd              := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd           := aCbxOrd[ nOrd ]

   if Empty( cCodPrv )
      MsgStop( "Es necesario codificar un proveedor" )
      return .t.
   end if

   if !lExistTable( cPatPrv() + "PrvBnc.Dbf" )
      MsgStop( 'No existe el fichero de bancos' )
      Return .f.
   end if

   if Empty( dbfBancos )
      USE ( cPatPrv() + "PrvBnc.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PRVBNC", @dbfBancos ) )
      SET ADSINDEX TO ( cPatPrv() + "PrvBnc.Cdx" ) ADDITIVE
      lClose      := .t.
   END IF

   ( dbfBancos )->( ordSetFocus( nOrd ) )

   ( dbfBancos )->( OrdScope( 0, cCodPrv ) )
   ( dbfBancos )->( OrdScope( 1, cCodPrv ) )
   ( dbfBancos )->( dbGoTop() )

   DEFINE DIALOG  oDlg ;
      RESOURCE    "HELPENTRY";
      TITLE       "Seleccionar cuentas bancarias de proveedores"

      REDEFINE GET oGet1 VAR cGet1;
         ID       104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfBancos, nil, cCodPrv ) );
         BITMAP   "FIND" ;
         OF       oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE(  ( dbfBancos )->( OrdSetFocus( oCbxOrd:nAt ) ),;
                     ( dbfBancos )->( OrdScope( 0, cCodPrv ) ),;
                     ( dbfBancos )->( OrdScope( 1, cCodPrv ) ),;
                     oBrw:Refresh(),;
                     oGet1:SetFocus() );
			OF 		oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfBancos
      oBrw:nMarqueeStyle   := 5

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cCodBnc"
         :bEditValue       := {|| ( dbfBancos )->cCodBnc }
         :nWidth           := 200
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Cuenta"
         :cSortOrder       := "cCtaBnc"
         :bEditValue       := {|| PictureCuentaIBAN( dbfBancos ) }
         :nWidth           := 180
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Domicilio"
         :bEditValue       := {|| ( dbfBancos )->cDirBnc }
         :nWidth           := 180
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Población"
         :bEditValue       := {|| ( dbfBancos )->cPobBnc }
         :nWidth           := 100
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Código postal"
         :bEditValue       := {|| ( dbfBancos )->cCPBnc }
         :nWidth           := 40
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Provincia"
         :bEditValue       := {|| ( dbfBancos )->cProBnc }
         :nWidth           := 80
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Teléfono"
         :bEditValue       := {|| ( dbfBancos )->cTlfBnc }
         :nWidth           := 80
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Fax"
         :bEditValue       := {|| ( dbfBancos )->cFaxBnc }
         :nWidth           := 80
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Contacto"
         :bEditValue       := {|| ( dbfBancos )->cPContBnc }
         :nWidth           := 140
      end with

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }

      oBrw:CreateFromResource( 105 )

		REDEFINE BUTTON ;
         ID       500 ;
         OF       oDlg ;
         WHEN     ( .f. );
         ACTION   ( nil )

		REDEFINE BUTTON ;
         ID       501 ;
         OF       oDlg ;
         WHEN     ( .f. );
         ACTION   ( nil )

   oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )
   oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK

      oGet:cText( ( dbfBancos )->cCodBnc )

      oPaisIBAN:cText( ( dbfBancos )->cPaisIBAN )
      oCtrlIBAN:cText( ( dbfBancos )->cCtrlIBAN )
      oEntBnc:cText( ( dbfBancos )->cEntBnc )
      oSucBnc:cText( ( dbfBancos )->cSucBnc )
      oDigBnc:cText( ( dbfBancos )->cDigBnc )
      oCtaBnc:cText( ( dbfBancos )->cCtaBnc )

   end if

   DestroyFastFilter( dbfBancos )

   SetBrwOpt( "BrwBncPrv", ( dbfBancos )->( OrdNumber() ) )

   if lClose
      ( dbfBancos )->( dbCloseArea() )
   else
      ( dbfBancos )->( OrdSetFocus( nOrd ) )
      ( dbfBancos )->( OrdScope( 0, nil ) )
      ( dbfBancos )->( OrdScope( 1, nil ) )
   end if

	oGet:setFocus()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

/*
Chequea las cuentas de contaplus
*/

STATIC FUNCTION ChkAllSubCta()

   local oDlg
   local cArea
   local nRecno      := ( dbfProvee )->( RecNo() )
   local cTag        := ( dbfProvee )->( OrdSetFocus( 1 ) )
   local cRuta       := cRutCnt()
   local cCodEmp     := cEmpCnt( "A" )
   local oChkCreate
   local lChkCreate  := .f.
   local oChkCuenta
   local lChkCuenta  := .f.
   local aMsg        := {}
   local oTree
   local cCliOrg
   local cCliDes
   local oCliOrg
   local oCliDes
   local oSayCliOrg
   local oSayCliDes
   local cSayCliOrg
   local cSayCliDes
   local oImageList

   if Empty( cRuta ) .or. Empty( cCodEmp )
      msgStop( "No existe enlace a contaplus ®" )
      return .f.
   end if

   if !OpenSubCuenta( cRuta, cCodEmp, @cArea, .f. )
      msgStop( "Imposible acceder a ficheros de contaplus ®" )
      return .t.
   end if

   /*
	Obtenemos los valores del primer y ultimo codigo
	*/

   cCliOrg           := dbFirst( dbfProvee, 1 )
   cCliDes           := dbLast(  dbfProvee, 1 )
   cSayCliOrg        := dbFirst( dbfProvee, 2 )
   cSayCliDes        := dbLast(  dbfProvee, 2 )

   oImageList        := TImageList():New( 16, 16 )
   oImageList:AddMasked( TBitmap():Define( "bRed" ),     Rgb( 255, 0, 255 ) )
   oImageList:AddMasked( TBitmap():Define( "bGreen" ),   Rgb( 255, 0, 255 ) )

   /*
   Llamada a la funcion que activa la caja de dialogo--------------------------
	*/

   DEFINE DIALOG oDlg RESOURCE "ChkAllSubCta"

   /*
   Monta los clientes----------------------------------------------------------
   */

   REDEFINE GET oCliOrg VAR cCliOrg;
      ID       80 ;
      VALID    cProvee( oCliOrg, dbfProvee, oSayCliOrg );
      BITMAP   "Lupa" ;
      ON HELP  BrwPrv( oCliOrg, oSayCliOrg, dbfProvee );
      OF       oDlg

   REDEFINE GET oSayCliOrg VAR cSayCliOrg ;
      WHEN     .f.;
      ID       81 ;
      OF       oDlg

   REDEFINE GET oCliDes VAR cCliDes;
      ID       90 ;
      VALID    cProvee( oCliDes, dbfProvee, oSayCliDes );
      BITMAP   "Lupa" ;
      ON HELP  BrwPrv( oCliDes, oSayCliDes, dbfProvee );
      OF       oDlg

   REDEFINE GET oSayCliDes VAR cSayCliDes ;
      WHEN     .f.;
      ID       91 ;
      OF       oDlg

   REDEFINE CHECKBOX oChkCreate VAR lChkCreate ;
      ID       100 ;
		OF 		oDlg

   REDEFINE CHECKBOX oChkCuenta VAR lChkCuenta ;
      ID       110 ;
		OF 		oDlg

   oTree       := TTreeView():Redefine( 170, oDlg )

   REDEFINE BUTTON ;
      ID       IDOK ;
		OF 		oDlg ;
      ACTION   ( MakAllSubCta( cCliOrg, cCliDes, lChkCuenta, lChkCreate, cArea, aMsg, oTree, oDlg ) )

   REDEFINE BUTTON ;
      ID       IDCANCEL ;
		OF 		oDlg ;
      CANCEL ;
      ACTION   ( oDlg:end() )

   ACTIVATE DIALOG oDlg ;
      CENTER ;
      ON INIT  ( oTree:SetImageList( oImageList ) )

   ( dbfProvee )->( dbGoTo( nRecno ) )
   ( dbfProvee )->( OrdSetFocus( cTag ) )

   CLOSE ( cArea )

   oImageList:End()

   oTree:Destroy()

   oWndBrw:oBrw:SetFocus()
   oWndBrw:oBrw:Refresh()

return .t.

//-------------------------------------------------------------------------//

Static Function MakAllSubCta( cCliOrg, cCliDes, lChkCuenta, lChkCreate, cArea, aMsg, oTree, oDlg )

   local nLen
   local oItem

   oDlg:Disable()

   oTree:DeleteAll()

   nLen              := nLenCuentaContaplus()

   if ( dbfProvee )->( dbSeek( cCliOrg ) )

      while ( dbfProvee )->Cod <= cCliDes .and. !( dbfProvee )->( Eof() )

         if Empty( AllTrim( ( dbfProvee )->SubCta ) ) .and. lChkCuenta
            if dbLock( dbfProvee )
               ( dbfProvee )->SubCta      := "400" + Right( Rtrim( ( dbfProvee )->Cod ), nLen )
               ( dbfProvee )->( dbUnLock() )
            end if
         end if

         if !Empty( AllTrim( ( dbfProvee )->SubCta ) )

            if !( cArea )->( dbSeek( ( dbfProvee )->SubCta, .t. ) )

               if lChkCreate .or. ApoloMsgNoYes(   "Subcuenta : " + Rtrim( ( dbfProvee )->SubCta ) + " no existe" + CRLF + ;
                                                   "¿ Desea crearla ?",;
                                                   "Enlace con contaplus ®" )

                  ( cArea )->( dbAppend() )
                  ( cArea )->Cod          := ( dbfProvee )->Subcta
                  ( cArea )->Titulo       := ( dbfProvee )->Titulo
                  ( cArea )->Nif          := ( dbfProvee )->Nif
                  ( cArea )->Domicilio    := ( dbfProvee )->Domicilio
                  ( cArea )->Poblacion    := ( dbfProvee )->Poblacion
                  ( cArea )->Provincia    := ( dbfProvee )->Provincia
                  ( cArea )->CodPostal    := ( dbfProvee )->CodPostal
                  ( cArea )->( dbCommit() )

                  oItem := oTree:Add( "Cuenta " + Rtrim( ( dbfProvee )->Subcta ) + " del proveedor " + Rtrim( ( dbfProvee )->Cod ) + ", " + Rtrim( ( dbfProvee )->Titulo ) + " creada", 1 )

               else

                  oItem := oTree:Add( "Cuenta " + Rtrim( ( dbfProvee )->Subcta ) + " del proveedor " + Rtrim( ( dbfProvee )->Cod ) + ", " + Rtrim( ( dbfProvee )->Titulo ) + " creación cancelada", 1 )

               end if

            else

               oItem    := oTree:Add( "Cuenta " + Rtrim( ( dbfProvee )->Subcta ) + " del proveedor " + Rtrim( ( dbfProvee )->Cod ) + ", " + Rtrim( ( dbfProvee )->Titulo ) + " ya existe", 0 )

            end if

         else

            oItem       := oTree:Add( "El proveedor : " + Rtrim( ( dbfProvee )->Cod ) + ", " + Rtrim( ( dbfProvee )->Titulo ) + " no tiene codificada cuenta en Contaplus", 0 )

         end if

         oTree:Select( oItem )

         SysRefresh()

         ( dbfProvee )->( dbSkip() )

      end do

   end if

   MsgInfo( "Proceso finalizado" )

   oDlg:Enable()

Return nil

//---------------------------------------------------------------------------//

Function cProveeCuenta( cProvee, dbfBncPrv )

   local lCloseBnc   := .f.
   local cCuenta     := ""

   if Empty( dbfBncPrv )
      USE ( cPatPrv() + "PrvBnc.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PRVBNC", @dbfBncPrv ) )
      SET ADSINDEX TO ( cPatPrv() + "PrvBnc.Cdx" ) ADDITIVE
      lCloseBnc      := .t.
   end if

   if dbSeekInOrd( cProvee, "cCodDef", dbfBncPrv )
      cCuenta        := ( dbfBncPrv )->cEntBnc + ( dbfBncPrv )->cSucBnc + ( dbfBncPrv )->cDigBnc + ( dbfBncPrv )->cCtaBnc
   end if

   if Empty( cCuenta )
      if dbSeekInOrd( cProvee, "cCodPrv", dbfBncPrv )
         cCuenta     := ( dbfBncPrv )->cEntBnc + ( dbfBncPrv )->cSucBnc + ( dbfBncPrv )->cDigBnc + ( dbfBncPrv )->cCtaBnc
      end if
   end fi

   if lCloseBnc
      CLOSE ( dbfBncPrv )
   end if

Return cCuenta

//---------------------------------------------------------------------------//

Function cNombreBancoProvee( cProvee, dbfBncPrv )

   local lCloseBnc   := .f.
   local cBanco      := ""

   if Empty( dbfBncPrv )
      USE ( cPatPrv() + "PrvBnc.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PRVBNC", @dbfBncPrv ) )
      SET ADSINDEX TO ( cPatPrv() + "PrvBnc.Cdx" ) ADDITIVE
      lCloseBnc      := .t.
   end if

   if dbSeekInOrd( cProvee, "cCodDef", dbfBncPrv )
      cBanco         := ( dbfBncPrv )->cCodBnc
   end if

   if Empty( cBanco )
      if dbSeekInOrd( cProvee, "cCodPrv", dbfBncPrv )
         cBanco      := ( dbfBncPrv )->cCodBnc
      end if
   end fi

   if lCloseBnc
      CLOSE ( dbfBncPrv )
   end if

Return cBanco

//---------------------------------------------------------------------------//

Static FUNCTION lSndPrv( oWndBrw, dbfProvee )

   local nRecAct
   local nRecOld           := ( dbfProvee )->( Recno() )

   for each nRecAct in ( oWndBrw:oBrw:aSelected )

      ( dbfProvee )->( dbGoTo( nRecAct ) )

      if dbDialogLock( dbfProvee )

         ( dbfProvee )->lSndInt  := !( dbfProvee )->lSndInt

         ( dbfProvee )->( dbUnlock() )

      end if

   next

   ( dbfProvee )->( dbGoTo( nRecOld ) )

   oWndBrw:Refresh()

   oWndBrw:oBrw:Select()

Return nil

//---------------------------------------------------------------------------//