#ifndef __PDA__
#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Report.ch"
#include "Xbrowse.ch"
#else
#include "FWCE.ch"
REQUEST DBFCDX
#endif

#ifndef __PDA__

#define _MODULEITEM_               "01051"

#define _DFECMOV                   1      //   D      8     0
#define _CTIMMOV                   2      //   C      6     0
#define _NTIPMOV                   3      //   N      1     0
#define _CALIMOV                   4      //   C      3     0
#define _CALOMOV                   5      //   C      3     0
#define _CREFMOV                   6      //   C     14     0
#define _CCODMOV                   7      //
#define _CCODPR1                   8      //
#define _CCODPR2                   9      //
#define _CVALPR1                  10      //
#define _CVALPR2                  11      //
#define _CCODUSR                  12
#define _CCODDLG                  13
#define _LLOTE                    14      //   C     20     0
#define _NLOTE                    15      //   C     20     0
#define _CLOTE                    16      //   C     20     0
#define _NCAJMOV                  17      //   C     20     0
#define _NUNDMOV                  18      //   C     20     0
#define _NCAJANT                  19
#define _NUNDANT                  20      //   C     12     0
#define _NPREDIV                  21      //   L      1     0
#define _LSNDDOC                  22      //   L      1     0
#define _NNUMREM                  23      //   L      1     0
#define _CSUFREM                  24
#define _LSELDOC                  25
#define _LNOSTK                   26      //   L      1     0
#define _LKITART                  27      //   L      1     0
#define _LKITESC                  28      //   L      1     0
#define _LIMPLIN                  29      //   L      1     0
#define _LKITPRC                  30      //   L      1     0
#define _NNUMLIN                  31      //   N      4     0
#define _MNUMSER                  32      //   M     10     0
#define _NVOLUMEN                 33
#define _CVOLUMEN                 34
#define _NPESOKG                  35
#define _CPESOKG                  36

static oWndBrw
static dbfHisMov
static dbfArticulo
static dbfArtKit
static dbfCodebar
static dbfTblPro
static dbfFamilia
static dbfAlbPrvT
static dbfAlbPrvL
static dbfFacPrvT
static dbfFacPrvL
static dbfRctPrvT
static dbfRctPrvL
static dbfAlbCliT
static dbfAlbCliL
static dbfFacCliT
static dbfFacCliL
static dbfFacRecT
static dbfFacRecL
static dbfTikCliT
static dbfTikCliL
static dbfAlmT
static dbfTmov
static dbfDiv
static oStock
static dbfUsr

static dbfDelega
static dbfProLin
static dbfProMat
static dbfPedPrvL
static dbfPedCliL

static aStockActual
static nStockActual  := 0
static oBrwStock

static nRecEdit
static nOrdEdit

static cOldCod       := ""

static lOpenFiles    := .f.
static lExternal     := .f.

static cPirDiv
static nDinDiv
static nDirDiv
static nVdvDiv
static cPicUnd

static oMenu

static bEdit         := { |aTmp, aGet, dbfHisMov, oBrw, bWhen, bValid, nMode | EdtRec( aTmp, aGet, dbfHisMov, oBrw, bWhen, bValid, nMode ) }

#endif

#ifndef __PDA__

//----------------------------------------------------------------------------//
//Funciones del programa
//----------------------------------------------------------------------------//


STATIC FUNCTION OpenFiles()

   local oBlock

   if lOpenFiles
      MsgStop( 'Imposible abrir ficheros de historico de movimientos' )
      Return ( .f. )
   end if

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      lOpenFiles        := .t.

      USE ( cPatEmp() + "HISMOV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "HISMOV", @dbfHisMov ) )
      SET ADSINDEX TO ( cPatEmp() + "HISMOV.CDX" ) ADDITIVE

      USE ( cPatArt() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
      SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

      USE ( cPatArt() + "ArtCodebar.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CODEBAR", @dbfCodebar ) )
      SET ADSINDEX TO ( cPatArt() + "ArtCodebar.Cdx" ) ADDITIVE

      USE ( cPatArt() + "ArtKit.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTKIT", @dbfArtKit ) )
      SET ADSINDEX TO ( cPatArt() + "ArtKit.Cdx" ) ADDITIVE

      USE ( cPatArt() + "FAMILIAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FAMILIAS", @dbfFamilia ) )
      SET ADSINDEX TO ( cPatArt() + "FAMILIAS.CDX" ) ADDITIVE

      USE ( cPatArt() + "TBLPRO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TBLPRO", @dbfTblPro ) )
      SET ADSINDEX TO ( cPatArt() + "TBLPRO.CDX" ) ADDITIVE

      USE ( cPatAlm() + "ALMACEN.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALMACEN", @dbfAlmT ) )
      SET ADSINDEX TO ( cPatAlm() + "ALMACEN.CDX" ) ADDITIVE 

      USE ( cPatDat() + "TMOV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TMOV", @dbfTMov ) )
      SET ADSINDEX TO ( cPatDat() + "TMOV.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ALBPROVT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBPROVT", @dbfAlbPrvT ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBPROVT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ALBPROVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBPROVL", @dbfAlbPrvL ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBPROVL.CDX" ) ADDITIVE
      ( dbfAlbPrvL )->( ordSetFocus( "cRef" ) )

      USE ( cPatEmp() + "FACPRVT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVT", @dbfFacPrvT ) )
      SET ADSINDEX TO ( cPatEmp() + "FACPRVT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FACPRVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVL", @dbfFacPrvL ) )
      SET ADSINDEX TO ( cPatEmp() + "FACPRVL.CDX" ) ADDITIVE
      ( dbfFacPrvL )->( ordSetFocus( "cRef" ) )

      USE ( cPatEmp() + "RctPrvT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "RctPrvT", @dbfRctPrvT ) )
      SET ADSINDEX TO ( cPatEmp() + "RctPrvT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "RctPrvL.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "RctPrvL", @dbfRctPrvL ) )
      SET ADSINDEX TO ( cPatEmp() + "RctPrvL.Cdx" ) ADDITIVE
      ( dbfRctPrvL )->( ordSetFocus( "cRef" ) )

      USE ( cPatEmp() + "ALBCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIL", @dbfAlbCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBCLIL.CDX" ) ADDITIVE
      ( dbfAlbCliL )->( ordSetFocus( "cRef" ) )

      USE ( cPatEmp() + "FACCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIL", @dbfFacCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "FACCLIL.CDX" ) ADDITIVE
      ( dbfFacCliL )->( ordSetFocus( "cRef" ) )

      USE ( cPatEmp() + "FACRECT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACRECT", @dbfFacRecT ) )
      SET ADSINDEX TO ( cPatEmp() + "FACRECT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FACRECL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACRECL", @dbfFacRecL ) )
      SET ADSINDEX TO ( cPatEmp() + "FACRECL.CDX" ) ADDITIVE
      ( dbfFacRecL )->( ordSetFocus( "cRef" ) )

      USE ( cPatEmp() + "TIKET.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKET", @dbfTikCliT ) )
      SET ADSINDEX TO ( cPatEmp() + "TIKET.CDX" ) ADDITIVE

      USE ( cPatEmp() + "TIKEL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKEL", @dbfTikCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "TIKEL.CDX" ) ADDITIVE
      ( dbfTikCliL )->( ordSetFocus( "cCbaTil" ) )

      USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDiv ) )
      SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

      USE ( cPatDat() + "USERS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "USERS", @dbfUsr ) )
      SET ADSINDEX TO ( cPatDat() + "USERS.CDX" ) ADDITIVE

      USE ( cPatDat() + "DELEGA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DELEGA", @dbfDelega ) )
      SET ADSINDEX TO ( cPatDat() + "DELEGA.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PROLIN.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROLIN", @dbfProLin ) )
      SET ADSINDEX TO ( cPatEmp() + "PROLIN.CDX" ) ADDITIVE
      SET TAG TO "cCodArt"

      USE ( cPatEmp() + "PROMAT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROMAT", @dbfProMat ) )
      SET ADSINDEX TO ( cPatEmp() + "PROMAT.CDX" ) ADDITIVE
      SET TAG TO "cCodArt"

      USE ( cPatEmp() + "PEDPROVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDPROV", @dbfPedPrvL ) )
      SET ADSINDEX TO ( cPatEmp() + "PEDPROVL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PEDCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDCLI", @dbfPedCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "PEDCLIL.CDX" ) ADDITIVE

      if !TDataCenter():OpenAlbCliT( @dbfAlbCliT )
         lOpenFiles     := .f.
      end if

      if !TDataCenter():OpenFacCliT( @dbfFacCliT )
         lOpenFiles     := .f.
      end if

      oStock            := TStock():Create( cPatEmp() )
      if !oStock:lOpenFiles()
         lOpenFiles     := .f.
      end if

      if ( dbfDiv )->( dbSeek( cDivEmp() ) )
         cPirDiv        := RetPic( ( dbfDiv )->nNinDiv, ( dbfDiv )->nRinDiv )
         nDinDiv        := ( dbfDiv )->nDinDiv
         nDirDiv        := ( dbfDiv )->nRinDiv
         nVdvDiv        := nDiv2Div( cDivEmp(), ( dbfDiv )->cCodDiv, dbfDiv )
      end if

      cPicUnd           := MasUnd()

   RECOVER

      lOpenFiles        := .f.

      msgStop( "Imposible abrir todas las bases de datos" )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpenFiles
      CloseFiles()
   end if

RETURN ( lOpenFiles )

//----------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles()

   CLOSE( dbfHisMov   )
   CLOSE( dbfArticulo )
   CLOSE( dbfCodebar  )
   CLOSE( dbfTblPro   )
   CLOSE( dbfFamilia  )
   CLOSE( dbfAlmT     )
   CLOSE( dbfTMov     )
   CLOSE( dbfAlbPrvT  )
   CLOSE( dbfAlbPrvL  )
   CLOSE( dbfFacPrvT  )
   CLOSE( dbfFacPrvL  )
   CLOSE( dbfRctPrvT  )
   CLOSE( dbfRctPrvL  )

   CLOSE( dbfDiv      )
   CLOSE( dbfAlbCliT  )
   CLOSE( dbfAlbCliL  )
   CLOSE( dbfFacCliT  )
   CLOSE( dbfFacCliL  )
   CLOSE( dbfFacRecT  )
   CLOSE( dbfFacRecL  )
   CLOSE( dbfTikCliT  )
   CLOSE( dbfTikCliL  )
   CLOSE( dbfUsr      )
   CLOSE( dbfDelega   )
   CLOSE( dbfProLin   )
   CLOSE( dbfProMat   )
   CLOSE( dbfPedPrvL  )
   CLOSE( dbfPedCliL  )
   CLOSE( dbfArtKit   )

   if !Empty( oStock )
      oStock:end()
   end if

   dbfHisMov   := nil
   dbfArticulo := nil
   dbfCodebar  := nil
   dbfTblPro   := nil
   dbfFamilia  := nil
   dbfAlmT     := nil
   dbfTMov     := nil
   dbfAlbPrvT  := nil
   dbfAlbPrvL  := nil
   dbfFacPrvT  := nil
   dbfFacPrvL  := nil
   dbfRctPrvT  := nil
   dbfRctPrvL  := nil

   dbfDiv      := nil
   dbfAlbCliT  := nil
   dbfAlbCliL  := nil
   dbfFacCliT  := nil
   dbfFacCliL  := nil
   dbfFacRecT  := nil
   dbfFacRecL  := nil
   dbfTikCliT  := nil
   dbfTikCliL  := nil
   dbfUsr      := nil
   dbfDelega   := nil
   oStock      := nil
   dbfPedPrvL  := nil
   dbfPedCliL  := nil
   dbfArtKit   := nil

   if !Empty( oWndBrw )
      oWndBrw  := nil
   end if

   lOpenFiles  := .f.

Return .t.

//----------------------------------------------------------------------------//

FUNCTION HisMovAlm( oMenuItem, oWnd )

   local oSnd
   local nLevel
   local oRotor

   DEFAULT  oMenuItem   := _MODULEITEM_
   DEFAULT  oWnd        := oWnd()

   if oWndBrw == nil

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

      if !OpenFiles()
         return nil
      end if

      /*
      Anotamos el movimiento para el navegador
      */

      AddMnuNext( "Historico de movimientos de almacén", ProcName() )

   DEFINE SHELL oWndBrw FROM 0, 0 TO 22, 80;
      TITLE    "Historico de movimientos de almacén" ;
      XBROWSE ;
      PROMPT   "Fecha",;
               "Código",;
               "Origen almacén",;
               "Destino almacén" ;
      ALIAS    ( dbfHisMov ) ;
      MRU      "gc_document_text_pencil_16" ;
      BITMAP   Rgb( 128, 57, 123 ) ;
      APPEND   ( WinAppRec( oWndBrw:oBrw, bEdit, dbfHisMov ) );
		DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdit, dbfHisMov ) );
		EDIT 		( WinEdtRec( oWndBrw:oBrw, bEdit, dbfHisMov ) ) ;
      DELETE   ( WinDelRec( oWndBrw:oBrw, dbfHisMov ) ) ;
      LEVEL    nLevel ;
      OF       oWnd

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Envio"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfHisMov )->lSndDoc }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "gc_mail2_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Delegación"
         :bEditValue       := {|| ( dbfHisMov )->cCodDlg }
         :nWidth           := 40
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Fecha"
         :bEditValue       := {|| dtoc( ( dbfHisMov )->dFecMov ) }
         :nWidth           := 80
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Tipo"
         :bEditValue       := {|| cTextoMovimiento( dbfHisMov ) }
         :nWidth           := 80
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Origen almacén"
         :cSortOrder       := "cAloMov"
         :bEditValue       := {|| ( dbfHisMov )->cAloMov }
         :nWidth           := 60
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Destino almacén"
         :cSortOrder       := "cAliMov"
         :bEditValue       := {|| ( dbfHisMov )->cAliMov }
         :nWidth           := 60
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Movimiento"
         :bEditValue       := {|| ( dbfHisMov )->cCodMov }
         :nWidth           := 30
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cRefMov"
         :bEditValue       := {|| ( dbfHisMov )->cRefMov }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Artículo"
         :bEditValue       := {|| retArticulo( ( dbfHisMov )->cRefMov, dbfArticulo ) }
         :nWidth           := 180
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Prop. 1"
         :bEditValue       := {|| ( dbfHisMov )->cValPr1 }
         :nWidth           := 40
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Prop. 2"
         :bEditValue       := {|| ( dbfHisMov )->cValPr2 }
         :nWidth           := 40
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Lote"
         :bEditValue       := {|| ( dbfHisMov )->cLote }
         :nWidth           := 80
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Unidades"
         :bEditValue       := {|| Trans( nTotNMovAlm( dbfHisMov ), cPicUnd ) }
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Precio"
         :bEditValue       := {|| Trans( ( dbfHisMov )->nPreDiv, cPirDiv ) }
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Total"
         :bEditValue       := {|| Trans( nTotLMovAlm( dbfHisMov ), cPirDiv ) }
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

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
         HOTKEY   "A";
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
         TOOLTIP  "(M)odificar";
         HOTKEY   "M";
         LEVEL    ACC_EDIT

		DEFINE BTNSHELL RESOURCE "ZOOM" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( WinZooRec( oWndBrw:oBrw, bEdit, dbfHisMov ) );
			TOOLTIP 	"(Z)oom";
         HOTKEY   "Z";
         LEVEL    ACC_ZOOM

		DEFINE BTNSHELL RESOURCE "DEL" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( WinDelRec( oWndBrw:oBrw, dbfHisMov ) );
			TOOLTIP 	"(E)liminar";
         HOTKEY   "E";
         LEVEL    ACC_DELE

      DEFINE BTNSHELL oSnd RESOURCE "LBL" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( lSndInt( oWndBrw, dbfHisMov ) );
         MENU     This:Toggle() ;
         TOOLTIP  "En(v)iar" ;
         HOTKEY   "V";
         LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "LBL" OF oWndBrw ;
            NOBORDER ;
            ACTION   ( lSelAll( oWndBrw, dbfHisMov ) );
            TOOLTIP  "Todos" ;
            FROM     oSnd ;
            CLOSED ;
            LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "LBL" OF oWndBrw ;
            NOBORDER ;
            ACTION   ( lSelAll( oWndBrw, dbfHisMov, .f. ) );
            TOOLTIP  "Ninguno" ;
            FROM     oSnd ;
            CLOSED ;
            LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "IMP" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( IMovAlm():New( "Listado de movimientos de almacén" ):Play() ) ;
         TOOLTIP  "Lis(t)ado" ;
         HOTKEY   "T";
         LEVEL    ACC_IMPR

      if oUser():lAdministrador()

      DEFINE BTNSHELL RESOURCE "BMPCHG" OF oWndBrw ;
         NOBORDER ;
         MENU     This:Toggle() ;
         ACTION   ( ReplaceCreator( oWndBrw, dbfHisMov, aItmMov() ) ) ;
         TOOLTIP  "Cambiar campos" ;
         LEVEL    ACC_EDIT

      end if

      DEFINE BTNSHELL oRotor RESOURCE "ROTOR" GROUP OF oWndBrw ;
         ACTION   ( oRotor:Expand() ) ;
         TOOLTIP  "Rotor" ;

         DEFINE BTNSHELL RESOURCE "GC_OBJECT_CUBE_" OF oWndBrw ;
            ACTION   ( EdtArticulo( ( dbfHisMov )->cRefMov ) );
            TOOLTIP  "Modificar de artículo" ;
            FROM     oRotor ;
            CLOSED ;

         DEFINE BTNSHELL RESOURCE "INFO" OF oWndBrw ;
            NOBORDER ;
            ACTION   ( InfArticulo( ( dbfHisMov )->cRefMov ) );
            TOOLTIP  "Informe de artículo" ;
            FROM     oRotor ;
            CLOSED ;

      DEFINE BTNSHELL RESOURCE "END" GROUP OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:End() ) ;
         TOOLTIP  "(S)alir" ;
			HOTKEY 	"S"

      oWndBrw:oActiveFilter:SetFields( aItmMov() )
      oWndBrw:oActiveFilter:SetFilterType( MOV_ALM )

		ACTIVATE WINDOW oWndBrw VALID ( CloseFiles() )

	ELSE

		oWndBrw:SetFocus()

	END IF

RETURN NIL

//----------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aTmp, aGet, dbfHisMov, oBrw, cCodArt, nTipMov, nMode, lExt )

	local oDlg
   local oSayMov
   local oSayPre
   local oSayTxt
   local cSayTxt        := "Almacén origen"
	local oSayAli
	local cSayAli
	local oSayAlo
	local cSayAlo
	local oSayArt
	local cSayArt
   local oSayPr1
   local oSayPr2
   local cSayPr1        := ""
   local cSayPr2        := ""
   local oSayVp1
   local oSayVp2
   local cSayVp1        := ""
   local cSayVp2        := ""
   local cSay2          := ""
   local oSay2
   local oSayDlg
   local cSayDlg        := ""
   local oSayLote
   local cSayLote       := "Lote"
   local aOld           := aClone( aTmp )
   local oBtnSer

   DEFAULT lExt         := .t.

   aStockActual         := { { "", "", "", "", "", 0, 0, 0 } }

   cOldCod              := aTmp[ _CREFMOV ]

   //if !Empty( cCodArt )
      lExternal         := lExt
   //end if

   if nMode == APPD_MODE
      if !Empty( cCodArt ) .and. ValType( cCodArt ) == "C"
      aTmp[ _CREFMOV ]  := cCodArt
      end if
      if !Empty( nTipMov )
      aTmp[ _NTIPMOV ]  := nTipMov
      end if
      aTmp[ _DFECMOV ]  := GetSysDate()
      aTmp[ _CTIMMOV ]  := Time()
      aTmp[ _CALIMOV ]  := oUser():cAlmacen()
      aTmp[ _CCODUSR ]  := cCurUsr()
      aTmp[ _CCODDLG ]  := oUser():cDelegacion()
   end if

   if nMode == EDIT_MODE
      nRecEdit          := ( dbfHisMov )->( RecNo() )
      nOrdEdit          := ( dbfHisMov )->( OrdSetFocus() )
   end if

   /*
   cargamos valores en los Say-------------------------------------------------
   */

   cSayDlg              := RetFld( cCodEmp() + aTmp[ _CCODDLG ], dbfDelega, "cNomDlg" )
   cSay2                := RetFld( aTmp[ _CCODMOV ], dbfTMov, "cDesMov" )
   cSayAlo              := RetFld( aTmp[ _CALOMOV ], dbfAlmT, "cNomAlm" )
   cSayAli              := RetFld( aTmp[ _CALIMOV ], dbfAlmT, "cNomAlm" )

   DEFINE DIALOG oDlg RESOURCE "HISMOV" TITLE LblTitle( nMode ) + "regularización de almacén"

      REDEFINE RADIO aTmp[ _NTIPMOV ] ;
         ID       70, 71, 72, 73 ;
         WHEN     ( nMode == APPD_MODE ) ;
         ON CHANGE( ShwAlm( aGet, aTmp, nMode, oSayArt, oSayAlo, oSayTxt, oSayLote, oSayPr1, oSayPr2, oSayVp1, oSayVp2, dbfArticulo, dbfFamilia ) ) ;
         OF       oDlg

      REDEFINE GET aGet[ _CCODDLG ] VAR aTmp[ _CCODDLG ] ;
         ID       300 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE GET oSayDlg VAR cSayDlg ;
         ID       301 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE GET aGet[ _DFECMOV ] VAR aTmp[ _DFECMOV ];
         ID       80 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         SPINNER ;
			OF 		oDlg

      REDEFINE GET aGet[ _CCODMOV ] VAR aTmp[ _CCODMOV ] ;
         ID       180 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cTMov( aGet[ _CCODMOV ], dbfTMov, oSay2 ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( browseGruposMovimientos( aGet[ _CCODMOV ], oSay2, dbfTMov ) ) ;
         OF       oDlg

      REDEFINE GET oSay2 VAR cSay2 ;
         ID       190 ;
         WHEN     .F. ;
         OF       oDlg

		REDEFINE GET aGet[ _CALOMOV ] VAR aTmp[ _CALOMOV ];
			ID 		100 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( cAlmacen( aGet[ _CALOMOV ], dbfAlmT, oSayAlo ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAlmacen( aGet[ _CALOMOV ], oSayAlo ) ) ;
			OF 		oDlg

		REDEFINE GET oSayAlo VAR cSayAlo ;
			WHEN 		.F. ;
			ID 		110 ;
			OF 		oDlg

      REDEFINE SAY oSayTxt VAR cSayTxt ;
         ID       119 ;
         OF       oDlg

		REDEFINE GET aGet[ _CALIMOV ] VAR aTmp[ _CALIMOV ];
			ID 		120 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( cAlmacen( aGet[ _CALIMOV ], dbfAlmT, oSayAli ) ) ;
         BITMAP   "LUPA" ;
			ON HELP 	( BrwAlmacen( 	aGet[ _CALIMOV ], oSayAli ) ) ;
			OF 		oDlg

		REDEFINE GET oSayAli VAR cSayAli ;
			WHEN 		.F. ;
			ID 		130 ;
			OF 		oDlg

		REDEFINE GET aGet[ _CREFMOV ] VAR aTmp[ _CREFMOV ];
			ID 		140 ;
         WHEN     ( nMode != ZOOM_MODE .and. Empty( cCodArt ) );
         VALID    ( LoaArt( aGet, aTmp, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oSayArt, oSayLote, oDlg ) ) ;
         BITMAP   "LUPA" ;
			ON HELP 	( BrwArticulo( aGet[ _CREFMOV ], oSayArt ) ) ;
			OF 		oDlg

		REDEFINE GET oSayArt VAR cSayArt ;
         WHEN     .f. ;
			ID 		150 ;
			OF 		oDlg

      /*
      Propiedades
      -------------------------------------------------------------------------
      */

      REDEFINE GET aGet[ _CVALPR1 ] VAR aTmp[ _CVALPR1 ];
         ID       220 ;
         BITMAP   "LUPA" ;
         VALID    ( if( lPrpAct( aGet[ _CVALPR1 ], oSayVp1, aTmp[ _CCODPR1 ], dbfTblPro ), LoaArt( aGet, aTmp, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oSayArt, oSayLote, oDlg ), .f. ) ) ;
         ON HELP  ( brwPropiedadActual( aGet[ _CVALPR1 ], oSayVp1, aTmp[ _CCODPR1 ] ) ) ;
         OF       oDlg

      REDEFINE SAY oSayPr1 VAR cSayPr1;
         ID       221 ;
         OF       oDlg

      REDEFINE GET oSayVp1 VAR cSayVp1;
         ID       222 ;
         WHEN     .f. ;
         OF       oDlg

      REDEFINE GET aGet[ _CVALPR2 ] VAR aTmp[ _CVALPR2 ];
         ID       230 ;
         BITMAP   "LUPA" ;
         VALID    ( if( lPrpAct( aGet[ _CVALPR2 ], oSayVp2, aTmp[ _CCODPR2 ], dbfTblPro ), LoaArt( aGet, aTmp, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oSayArt, oSayLote, oDlg ), .f. ) ) ;
         ON HELP  ( brwPropiedadActual( aGet[ _CVALPR2 ], oSayVp2, aTmp[ _CCODPR2 ] ) ) ;
         OF       oDlg

      REDEFINE SAY oSayPr2 VAR cSayPr2;
         ID       231 ;
         OF       oDlg

      REDEFINE GET oSayVp2 VAR cSayVp2;
         ID       232 ;
         WHEN     .f. ;
         OF       oDlg

      /*
      Lotes
      -------------------------------------------------------------------------
      */

      REDEFINE SAY oSayLote VAR cSayLote ;
         ID       154;
         OF       oDlg

      REDEFINE GET aGet[ _CLOTE ] VAR aTmp[ _CLOTE ];
         ID       155 ;
         VALID    ( LoaArt( aGet, aTmp, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oSayArt, oSayLote, oDlg ), .t. );
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      /*
      Stock--------------------------------------------------------------------
      */

      oBrwStock                        := IXBrowse():New( oDlg )

      oBrwStock:bClrSel                := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwStock:bClrSelFocus           := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwStock:SetArray( oStock:aStocks, , , .f. )

      oBrwStock:lFooter                := .t.
      oBrwStock:lHScroll               := .f.
      oBrwStock:nMarqueeStyle          := 5
      oBrwStock:cName                  := "Stock movimientos"
      oBrwStock:lRecordSelector        := .f.

      oBrwStock:CreateFromResource( 160 )

      with object ( oBrwStock:AddCol() )
         :cHeader             := "Código"
         :nWidth              := 40
         :bStrData            := {|| if( !Empty( oStock:aStocks ), oStock:aStocks[ oBrwStock:nArrayAt ]:cCodigoAlmacen, "" ) }
      end with

      with object ( oBrwStock:AddCol() )
         :cHeader             := "Almacén"
         :nWidth              := 170
         :bStrData            := {|| if( !Empty( oStock:aStocks ), RetAlmacen( oStock:aStocks[ oBrwStock:nArrayAt ]:cCodigoAlmacen, dbfAlmT ), "" ) }
      end with

      with object ( oBrwStock:AddCol() )
         :cHeader             := "Prop. 1"
         :nWidth              := 40
         :bStrData            := {|| if( !Empty( oStock:aStocks ), oStock:aStocks[ oBrwStock:nArrayAt ]:cValorPropiedad1, "" ) }
         :lHide               := .t.
      end with

      with object ( oBrwStock:AddCol() )
         :cHeader             := "Prop. 2"
         :nWidth              := 40
         :bStrData            := {|| if( !Empty( oStock:aStocks ), oStock:aStocks[ oBrwStock:nArrayAt ]:cValorPropiedad2, "" ) }
         :lHide               := .t.
      end with

      with object ( oBrwStock:AddCol() )
         :cHeader             := "Lote"
         :nWidth              := 50
         :bStrData            := {|| if( !Empty( oStock:aStocks ), oStock:aStocks[ oBrwStock:nArrayAt ]:cLote, "" ) }
         :lHide               := .t.
      end with

      with object ( oBrwStock:AddCol() )
         :cHeader             := "Num. serie"
         :nWidth              := 60
         :bStrData            := {|| if( !Empty( oStock:aStocks ), oStock:aStocks[ oBrwStock:nArrayAt ]:cNumeroSerie, "" ) }
         :lHide               := .t.
      end with

      with object ( oBrwStock:AddCol() )
         :cHeader             := "Unidades"
         :nWidth              := 80
         :bEditValue          := {|| if( !Empty( oStock:aStocks ), oStock:aStocks[ oBrwStock:nArrayAt ]:nUnidades, 0 ) }
         :bFooter             := {|| nStockUnidades( oBrwStock ) }
         :cEditPicture        := MasUnd()
         :nDataStrAlign       := AL_RIGHT
         :nHeadStrAlign       := AL_RIGHT
         :nFootStrAlign       := AL_RIGHT
      end with

      with object ( oBrwStock:AddCol() )
         :cHeader             := "Pdt. recibir"
         :bEditValue          := {|| if( !Empty( oStock:aStocks ), oStock:aStocks[ oBrwStock:nArrayAt ]:nPendientesRecibir, 0 ) }
         :bFooter             := {|| nStockPendiente( oBrwStock ) }
         :nWidth              := 70
         :cEditPicture        := MasUnd()
         :nDataStrAlign       := AL_RIGHT
         :nHeadStrAlign       := AL_RIGHT
         :nFootStrAlign       := AL_RIGHT
         :lHide               := .t.
      end with

      with object ( oBrwStock:AddCol() )
         :cHeader             := "Pdt. entregar"
         :bEditValue          := {|| if( !Empty( oStock:aStocks ), oStock:aStocks[ oBrwStock:nArrayAt ]:nPendientesEntregar, 0 ) }
         :bFooter             := {|| nStockEntregar( oBrwStock ) }
         :nWidth              := 70
         :cEditPicture        := MasUnd()
         :nDataStrAlign       := AL_RIGHT
         :nHeadStrAlign       := AL_RIGHT
         :nFootStrAlign       := AL_RIGHT
         :lHide               := .t.
      end with

      REDEFINE GET aGet[ _NCAJMOV ] VAR aTmp[ _NCAJMOV ];
         ID       170 ;
         IDSAY    171 ;
			SPINNER ;
         ON CHANGE( oSayMov:Refresh(), oSayPre:Refresh() ) ;
         VALID    ( oSayMov:Refresh(), oSayPre:Refresh(), .t. ) ;
         WHEN     ( lUseCaj() .AND. nMode != ZOOM_MODE ) ;
         PICTURE  cPicUnd ;
			OF 		oDlg

		REDEFINE GET aGet[ _NUNDMOV ] VAR aTmp[ _NUNDMOV ];
         ID       200 ;
			SPINNER ;
         ON CHANGE( oSayMov:Refresh(), oSayPre:Refresh() ) ;
         VALID    ( oSayMov:Refresh(), oSayPre:Refresh(), .t. ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  cPicUnd ;
			OF 		oDlg

      REDEFINE SAY oSayMov VAR nTotNMovAlm( aTmp );
         ID       210 ;
         PICTURE  cPicUnd ;
         COLOR    CLR_GET ;
         OF       oDlg

      REDEFINE GET aGet[ _NPREDIV ] VAR aTmp[ _NPREDIV ];
         ID       240 ;
			SPINNER ;
         ON CHANGE( oSayPre:Refresh() ) ;
         VALID    ( oSayPre:Refresh(), .t. ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  cPirDiv ;
			OF 		oDlg

      REDEFINE SAY oSayPre VAR nTotLMovAlm( aTmp );
         ID       250 ;
         PICTURE  cPirDiv ;
         COLOR    CLR_GET ;
			OF 		oDlg

      REDEFINE BUTTON oBtnSer ;
         ID       500 ;
			OF 		oDlg ;
         ACTION   ( aTmp[ _MNUMSER ] := EdtNumSer( aTmp[ _MNUMSER ], nTotNMovAlm( aTmp ), nMode ) )

		REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( ChkCodAlm( aTmp, aOld, aGet, oBrw, nMode, oDlg, oBtnSer ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         ACTION   ( oDlg:end() )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F6, {|| oBtnSer:Click() } )
      oDlg:AddFastKey( VK_F5, {|| ChkCodAlm( aTmp, aOld, aGet, oBrw, nMode, oDlg, oBtnSer ) } )
   end if

   oDlg:bStart    := {|| ShwAlm( aGet, aTmp, nMode, oSayArt, oSayAlo, oSayTxt, oSayLote, oSayPr1, oSayPr2, oSayVp1, oSayVp2, dbfArticulo, dbfFamilia ),;
                         aGet[ _CCODMOV ]:SetFocus(),;
                         oBrwStock:Load(),;
                         if( !Empty( cCodArt ), aGet[ _CREFMOV ]:lValid(), ),;
                         if( !Empty( aTmp[ _CREFMOV ] ), aStkArticulo( aTmp[ _CREFMOV ] ), ) }

   ACTIVATE DIALOG oDlg ;
         ON INIT  ( EdtDetMenu( aTmp, oDlg ) );
         CENTER

   oMenu:End()

   if oBrw != nil
      oBrw:Refresh()
   end if

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

STATIC FUNCTION ChkCodAlm( aTmp, aOld, aGet, oBrw, nMode, oDlg, oBtnSer )

   if aTmp[ _NTIPMOV ] == 1

      if empty( aTmp[ _CALIMOV ] ) .OR. empty( aTmp[ _CALOMOV ] )
         msgStop( "Ningun almacén debe estar vacío" )
         return .f.
      end if

      if aTmp[ _CALIMOV ] == aTmp[ _CALOMOV ]
         msgStop( "Almacén de origen y destino deben de ser distintos" )
         return .f.
      end if

      if aTmp[ _NUNDMOV ] <= 0
         msgStop( "Cantidad no valida" )
         return .f.
      end if

      if nTotNMovAlm( aTmp ) > nStockActual
         if !ApoloMsgNoYes( "No hay stock suficiente", "¿Desea proceder?" )
            return .f.
         end if
      end if

   else

      if empty( aTmp[ _CALIMOV ] )
         msgStop( "Almacén destino no puede estar vacío" )
         return .f.
      end if

   end if

   if empty( aTmp[ _CREFMOV ] )
      msgStop( "Artículo no encontrado" )
      return .f.
   end if

   if empty( aTmp[ _CCODMOV ] )
      msgStop( "No existe tipo de movimiento" )
      return .f.
   end if

   do case
   case nMode == APPD_MODE

      if aTmp[ _NTIPMOV ] == 3
         aTmp[ _NUNDMOV ]  := ( nTotNMovAlm( aTmp ) - nTotNMovOld( aTmp ) ) / NotCero( aTmp[ _NCAJMOV ] )
         aTmp[ _NUNDANT ]  := 0
         aTmp[ _NCAJANT ]  := 0
      end if

   case nMode == EDIT_MODE

      ( dbfHisMov )->( OrdSetFocus( nOrdEdit ) )
      ( dbfHisMov )->( dbGoTo( nRecEdit ) )

   end case

   WinGather( aTmp, aGet, dbfHisMov, oBrw, nMode )

   oDlg:end( IDOK )

RETURN .T.

//--------------------------------------------------------------------------//

STATIC FUNCTION PrnReport( cAlmOrg, cAlmDes, dFecOrg, dFecDes, cTitulo, cSubTitulo, nDevice )

   local oReport
   local oFont1      := TFont():New( "Courier New", 0, 10, .F., .T. )
   local oFont2      := TFont():New( "Courier New", 0, 10, .F., .f. )
   local nRecno      := ( dbfHisMov )->( Recno() )

   ( dbfHisMov )->( dbGoTop() )

   IF nDevice == 1

      REPORT oReport ;
         TITLE    Rtrim( cTitulo ),;
                  Rtrim( cSubTitulo ) ;
         FONT     oFont1, oFont2 ;
         HEADER   "Fecha: " + dtoc( date() ) RIGHT ;
         FOOTER   "Página : " + str( oReport:nPage, 3 ) CENTERED;
         CAPTION  "Listado movimientos de almacén";
         PREVIEW

   ELSE

      REPORT oReport ;
         TITLE    Rtrim( cTitulo ),;
                  Rtrim( cSubTitulo ) ;
         FONT     oFont1, oFont2 ;
         HEADER   "Fecha: " + dtoc(date()) RIGHT ;
         FOOTER   "Página : " + str( oReport:nPage, 3) CENTERED;
         CAPTION  "Listado movimientos de almacén";
         TO PRINTER

   END IF

      COLUMN TITLE "Fecha" ;
         DATA     ( dbfHisMov )->DFECMOV ;
         SIZE     10;
         FONT     2

      COLUMN TITLE "Alm. Org." ;
         DATA     ( dbfHisMov )->CALOMOV ;
         SIZE     10;
         FONT     2

      COLUMN TITLE "Alm. Des." ;
         DATA     ( dbfHisMov )->CALIMOV ;
         SIZE     10;
         FONT     2

      COLUMN TITLE "Artículo" ;
         DATA     ( dbfHisMov )->cRefMov + Space( 1 ) + RetArticulo(  ( dbfHisMov )->cRefMov, dbfArticulo ) ;
         SIZE     60;
         FONT     2

      COLUMN TITLE "Unidades" ;
         DATA     nTotNMovAlm( dbfHisMov ) ;
         PICTURE  cPicUnd ;
         TOTAL ;
         SIZE     14;
         FONT     2

      COLUMN TITLE "Importe" ;
         DATA     ( dbfHisMov )->nPreDiv ;
         PICTURE  cPirDiv ;
         TOTAL ;
         SIZE     14;
         FONT     2

      COLUMN TITLE "Total" ;
         DATA     nTotLMovAlm( dbfHisMov ) ;
         PICTURE  cPirDiv ;
         TOTAL ;
         SIZE     14;
         FONT     2

   END REPORT

   IF !Empty( oReport ) .and.  oReport:lCreated
      oReport:Margin( 0, RPT_RIGHT, RPT_CMETERS )
      oReport:bSkip := {|| ( dbfHisMov )->( dbSkip() ) }
   END IF

   ACTIVATE REPORT oReport ;
      FOR   ( dbfHisMov )->DFECMOV >= dFecOrg .AND.;
            ( dbfHisMov )->DFECMOV <= dFecDes .AND.;
            ( ( dbfHisMov )->CALOMOV >= cAlmOrg .OR. ( dbfHisMov )->CALOMOV <= cAlmDes .OR. empty( cAlmOrg ) ) .OR.;
            ( ( dbfHisMov )->CALIMOV >= cAlmDes .OR. ( dbfHisMov )->CALIMOV <= cAlmDes .OR. empty( cAlmDes ) ) ;
      WHILE !( dbfHisMov )->( eof() )

   oFont1:end()
   oFont2:end()

   ( dbfHisMov )->( dbGoTo( nRecno ) )

RETURN NIL

//--------------------------------------------------------------------------//

static function lNotOpen()

   if NetErr()
      msgStop( "Imposible abrir ficheros" )
      CloseFiles()
      return .t.
   end if

return .f.

//---------------------------------------------------------------------------//

static function LoaArt( aGet, aTmp, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oSayArt, oSayLote, oDlg )

   local lValid   := .t.
   local nPos
   local cCodArt  := aGet[ _CREFMOV ]:VarGet()
   local lChgCod  := ( Empty( cOldCod ) .or. cOldCod != cCodArt )

   if !( lChgCod )
      Return .t.
   end if

   /*
   Primero buscamos por codigos de barra---------------------------------------
   */

   if !Empty( cCodArt )

      cCodArt     := cSeekCodebar( cCodArt, dbfCodebar, dbfArticulo )

      /*
      Ahora buscamos por el codigo interno
      */

      if ( dbfArticulo )->( dbSeek( cCodArt ) )

         CursorWait()

         oDlg:Disable()

         if ( dbfArticulo )->lKitArt .and. !( dbfArticulo )->lKitAsc .and. ( dbfArticulo )->nKitStk != 2
            msgStop( "No se puede añadir artículos con escandallos y stock en componentes" )
            return .f.
         end if

         aGet[ _CREFMOV ]:cText( ( dbfArticulo )->Codigo )

         oSayArt:cText( ( dbfArticulo )->Nombre )

         /*
         Lotes-----------------------------------------------------------------
         */

         aTmp[ _LLOTE  ]   := ( dbfArticulo )->lLote

         if ( dbfArticulo )->lLote

            oSayLote:Show()

            aGet[ _CLOTE  ]:Show()

            if Empty( aTmp[ _CLOTE ] )
               aGet[ _CLOTE  ]:cText( ( dbfArticulo )->cLote )
            end if

         else

            oSayLote:Hide()

            aGet[ _CLOTE  ]:Hide()

         end if

         /*
         Peso y Volumen--------------------------------------------------------
         */

         aTmp[ _NVOLUMEN ] := ( dbfArticulo )->nVolumen
         aTmp[ _CVOLUMEN ] := ( dbfArticulo )->cVolumen
         aTmp[ _NPESOKG  ] := ( dbfArticulo )->nPesoKg
         aTmp[ _CPESOKG  ] := ( dbfArticulo )->cUndDim

         /*
         Buscamos la familia del articulo y anotamos las propiedades-----------
         */

         aTmp[ _CCODPR1 ]  := ( dbfArticulo )->cCodPrp1
         aTmp[ _CCODPR2 ]  := ( dbfArticulo )->cCodPrp2
         aTmp[ _CVALPR1 ]  := Space( 40 )
         aTmp[ _CVALPR2 ]  := Space( 40 )

         if !Empty( aTmp[_CCODPR1 ] )

            aGet[ _CVALPR1 ]:Show()

            oSayPr1:SetText( RetProp( ( dbfArticulo )->cCodPrp1 ) )
            oSayPr1:Show()
            oSayVp1:Show()

         else

            aGet[ _CVALPR1 ]:Hide()

            oSayPr1:Hide()
            oSayVp1:Hide()

         end if

         if !Empty( aTmp[_CCODPR2 ] )

            aGet[ _CVALPR2 ]:Show()

            oSayPr2:SetText( RetProp( ( dbfArticulo )->cCodPrp2 ) )
            oSayPr2:Show()
            oSayVp2:Show()

         else

            aGet[ _CVALPR2 ]:Hide()

            oSayPr2:Hide()
            oSayVp2:Hide()

         end if


         if !uFieldEmpresa( "lCosAct" )
            aGet[ _NPREDIV ]:cText( oStock:nPrecioMedioCompra( ( dbfArticulo )->Codigo, aTmp[ _CALIMOV ], nil, GetSysDate() ) )
         else
            aGet[ _NPREDIV ]:cText( nCosto( ( dbfArticulo )->Codigo, dbfArticulo, dbfArtKit ) )
         end if

         /*
         Ponemos el stock------------------------------------------------------
         */

         aStkArticulo( ( dbfArticulo )->Codigo, ( dbfArticulo )->nCtlStock )

         SysRefresh()

         nPos                 := aScan( oStock:aStocks, {|o| o:cCodigo == aTmp[ _CREFMOV ] .and. o:cCodigoAlmacen == aTmp[ _CALIMOV ] .and. o:cValorPropiedad1 == aTmp[ _CVALPR1 ] .and. o:cValorPropiedad2 == aTmp[ _CVALPR2 ] .and. o:cLote == aTmp[ _CLOTE ] .and. o:cNumeroSerie == aTmp[ _MNUMSER ] } )
         if ( nPos != 0 )
            aTmp[ _NUNDANT ]  := oStock:aStocks[ nPos ]:nUnidades
         end if

         lValid   := .t.

         oDlg:Enable()

         CursorWE()

      end if

   else

      lValid      := .f.

   end if

return lValid

//---------------------------------------------------------------------------//

static function ShwAlm( aGet, aTmp, nMode, oSayArt, oSayAlo, oSayTxt, oSayLote, oSayPr1, oSayPr2, oSayVp1, oSayVp2, dbfArticulo, dbfFamilia )

   do case
      case nMode == APPD_MODE

         oSayLote:Hide()
         aGet[ _CLOTE ]:Hide()

      case nMode == EDIT_MODE

         if aTmp[ _LLOTE ]
            aGet[ _CLOTE ]:Show()
            oSayLote:Show()
         else
            aGet[ _CLOTE ]:Hide()
            oSayLote:Hide()
         end if

         if ( dbfArticulo )->( dbSeek( aTmp[ _CREFMOV ] ) )
            oSayArt:cText( ( dbfArticulo )->Nombre )
         end if

   end case

   if aTmp[ _NTIPMOV ] > 1
      oSayAlo:hide()
      oSayTxt:hide()
      aGet[ _CALOMOV ]:hide()
   else
      oSayAlo:show()
      oSayTxt:show()
      aGet[ _CALOMOV ]:show()
   end if

   if !lUseCaj()
      aGet[ _NCAJMOV ]:hide()
   end if

   /*
   Propiedades-----------------------------------------------------------------
   */

   if !Empty( aTmp[ _CCODPR1 ] )

      aGet[ _CVALPR1 ]:Show()
      aGet[ _CVALPR1 ]:lValid()

      oSayPr1:SetText( RetProp( ( dbfArticulo )->cCodPrp1 ) )
      oSayPr1:Show()
      oSayVp1:Show()

   else

      aGet[ _CVALPR1 ]:Hide()

      oSayPr1:Hide()
      oSayVp1:Hide()

   end if

   if !Empty( aTmp[ _CCODPR2 ] )

      aGet[ _CVALPR2 ]:Show()
      aGet[ _CVALPR2 ]:lValid()

      oSayPr2:SetText( RetProp( ( dbfArticulo )->cCodPrp2 ) )
      oSayPr2:Show()
      oSayVp2:Show()

   else

      aGet[ _CVALPR2 ]:Hide()

      oSayPr2:Hide()
      oSayVp2:Hide()

   end if

return .t.

//---------------------------------------------------------------------------//

function nTotNMovOld( uDbf )

   local nTotUnd

   do case
   case ValType( uDbf ) == "A"
      nTotUnd     := NotCaja( uDbf[ _NCAJANT ] ) * uDbf[ _NUNDANT ]
   case ValType( uDbf ) == "C"
      nTotUnd     := NotCaja( ( uDbf )->nCajAnt ) * ( uDbf )->nUndAnt
   case ValType( uDbf ) == "O"
      nTotUnd     := NotCaja( uDbf:nCajAnt ) * uDbf:nUndAnt
   end case

RETURN ( nTotUnd )

//-------------------------------------------------------------------------//

function nTotVMovAlm( cCodArt, dbfMovAlm, cCodAlm )

   local nTotVta  := 0
   local nOrd     := ( dbfMovAlm )->( OrdSetFocus( "cRefMov" ) )
   local nRec     := ( dbfMovAlm )->( Recno() )

   if ( dbfMovAlm )->( dbSeek( cCodArt ) )

      while ( dbfMovAlm )->cRefMov == cCodArt .and. !( dbfMovAlm )->( eof() )

         if !( dbfMovAlm )->lNoStk

            if cCodAlm != nil

               if cCodAlm == ( dbfMovAlm )->cAliMov
                  nTotVta  += nTotNMovAlm( dbfMovAlm )
               end if

               if cCodAlm == ( dbfMovAlm )->cAloMov
                  nTotVta  -= nTotNMovAlm( dbfMovAlm )
               end if

            else

               if !Empty( ( dbfMovAlm )->cAliMov )
                  nTotVta  += nTotNMovAlm( dbfMovAlm )
               end if

               if !Empty( ( dbfMovAlm )->cAloMov )
                  nTotVta  -= nTotNMovAlm( dbfMovAlm )
               end if

            end if

         end if

         ( dbfMovAlm )->( dbSkip() )

      end while

   end if

   ( dbfMovAlm )->( dbGoTo( nRec ) )
   ( dbfMovAlm )->( OrdSetFocus( nOrd ) )

return ( nTotVta )

//---------------------------------------------------------------------------//

FUNCTION AppMovAlm( cCodArt, nTipMov, oBrw )

   local nLevel      := nLevelUsr( "01050" )

   DEFAULT nTipMov   := 1

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_APPD ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if !OpenFiles()
      CloseFiles()
      return nil
   end if

   WinAppRec( nil, bEdit, dbfHisMov, cCodArt, nTipMov )

   if oBrw != NIL
		oBrw:refresh()
   end if

   CloseFiles()

RETURN NIL

//----------------------------------------------------------------------------//

FUNCTION EdtMovAlm( nNumRec, oBrw )

   local nLevel   := nLevelUsr( _MODULEITEM_ )

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_EDIT ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if !OpenFiles()
      CloseFiles()
      return nil
   end if

   ( dbfHisMov )->( dbGoto( Int( nNumRec ) ) )

   WinEdtRec( nil, bEdit, dbfHisMov )

   if oBrw != NIL
		oBrw:refresh()
   end if

   CloseFiles()

RETURN NIL

//----------------------------------------------------------------------------//

FUNCTION ZooMovAlm( nNumRec, oBrw )

   local nLevel   := nLevelUsr( _MODULEITEM_ )

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_ZOOM ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if !OpenFiles()
      CloseFiles()
      return nil
   end if

   ( dbfHisMov )->( dbGoto( Int( nNumRec ) ) )

   WinZooRec( nil, bEdit, dbfHisMov )

   if oBrw != NIL
		oBrw:refresh()
   end if

   CloseFiles()

RETURN NIL

//----------------------------------------------------------------------------//

FUNCTION DelMovAlm( nNumRec, oBrw )

   local nLevel   := nLevelUsr( _MODULEITEM_ )

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_DELE ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if !OpenFiles()
      CloseFiles()
      return nil
   end if

   ( dbfHisMov )->( dbGoto( Int( nNumRec ) ) )

   WinDelRec( nil, dbfHisMov )

   if oBrw != nil
		oBrw:refresh()
   end if

   CloseFiles()

RETURN NIL

//----------------------------------------------------------------------------//

Static Function EdtDetMenu( aTmp, oDlg )

   MENU oMenu

      MENUITEM    "&1. Rotor"

         if !lExternal

         MENU

            MENUITEM    "&1. Modificar de artículo";
               MESSAGE  "Modificar la ficha del artículo" ;
               RESOURCE "gc_object_cube_16";
               ACTION   ( EdtArticulo( aTmp[ _CREFMOV ] ) );

            MENUITEM    "&2. Informe de artículo";
               MESSAGE  "Abrir el informe del artículo" ;
               RESOURCE "Info16";
               ACTION   ( InfArticulo( aTmp[ _CREFMOV ] ) );

         ENDMENU

        end if

   ENDMENU

   oDlg:SetMenu( oMenu )

Return ( oMenu )

//----------------------------------------------------------------------------//

#endif

//----------------------------------------------------------------------------//
//Funciones comunes del programa y pda
//----------------------------------------------------------------------------//

function nTotLMovAlm( uDbf )

   local nTotUnd  := nTotNMovAlm( uDbf )

   do case
   case ValType( uDbf ) == "A"
      nTotUnd     := NotCaja( uDbf[ _NCAJMOV ] ) * uDbf[ _NUNDMOV ] * uDbf[ _NPREDIV ]
   case ValType( uDbf ) == "C"
      nTotUnd     := NotCaja( ( uDbf )->nCajMov ) * ( uDbf )->nUndMov * ( uDbf )->nPreDiv
   case ValType( uDbf ) == "O"
      nTotUnd     := NotCaja( uDbf:nCajMov ) * uDbf:nUndMov * uDbf:nPreDiv
      // nTotUnd     := NotCaja( uDbf:FieldGetByName( "nCajMov" ) ) * uDbf:FieldGetByName( "nUndMov" ) * uDbf:FieldGetByName( "nPreDiv" )
   end case

RETURN ( nTotUnd )

//---------------------------------------------------------------------------//

Function nTotNMovAlm( uDbf )

   local nTotUnd

   do case
   case ValType( uDbf ) == "A"
      nTotUnd     := NotCaja( uDbf[ _NCAJMOV ] ) * uDbf[ _NUNDMOV ]
   case ValType( uDbf ) == "C"
      nTotUnd     := NotCaja( ( uDbf )->nCajMov ) * ( uDbf )->nUndMov
   case ValType( uDbf ) == "O"
      nTotUnd     := NotCaja( uDbf:nCajMov ) * uDbf:nUndMov
   end case

RETURN ( nTotUnd )

//-------------------------------------------------------------------------//

Static Function aStkArticulo( cCodArt, nCtlStock )

   DEFAULT  nCtlStock := 1

   nStockActual       := 0

   oStock:aStockArticulo( cCodArt, , oBrwStock )
   aEval( oBrwStock:aArrayData, {|a| nStockActual += a:nUnidades } )

Return .t.

//---------------------------------------------------------------------------//
/*
Function aItmMov()

   local aBase := {}

   aAdd( aBase, { "dFecMov",   "D",     8,    0, "Fecha del movimiento" }              )
   aAdd( aBase, { "cTimMov",   "C",     5,    0, "Hora del movimiento" }               )
   aAdd( aBase, { "nTipMov",   "N",     1,    0, "Tipo del movimiento" }               )
   aAdd( aBase, { "cAliMov",   "C",    16,    0, "Almacén destino" }                   )
   aAdd( aBase, { "cAloMov",   "C",    16,    0, "Almacén origen" }                    )
   aAdd( aBase, { "cRefMov",   "C",    18,    0, "Código de artículo" }                )
   aAdd( aBase, { "cCodMov",   "C",     2,    0, "Tipo de movimiento" }                )
   aAdd( aBase, { "cCodPr1",   "C",    20,    0, "Código de la primera propiedad" }    )
   aAdd( aBase, { "cCodPr2",   "C",    20,    0, "Código de la segunda propiedad" }    )
   aAdd( aBase, { "cValPr1",   "C",    20,    0, "Valor de la primera propiedad"  }    )
   aAdd( aBase, { "cValPr2",   "C",    20,    0, "Valor de la segunda propiedad"  }    )
   aAdd( aBase, { "cCodUsr",   "C",     3,    0, "Código de usuario" }                 )
   aAdd( aBase, { "cCodDlg",   "C",     2,    0, "Código de delegación" }              )
   aAdd( aBase, { "lLote"  ,   "L",     1,    0, "" }                                  )
   aAdd( aBase, { "nLote"  ,   "N",     9,    0, "" }                                  )
   aAdd( aBase, { "cLote"  ,   "C",    14,    0, "Número de lote" }                    )
   aAdd( aBase, { "nCajMov",   "N",    19,    6, "Cajas movidas" }                     )
   aAdd( aBase, { "nUndMov",   "N",    19,    6, "Unidades movidas" }                  )
   aAdd( aBase, { "nCajAnt",   "N",    19,    6, "Cajas movidas anterior" }            )
   aAdd( aBase, { "nUndAnt",   "N",    19,    6, "Unidades movidas anterior" }         )
   aAdd( aBase, { "nPreDiv",   "N",    19,    6, "Precio del artículo" }               )
   aAdd( aBase, { "lSndDoc",   "L",     1,    0, "" }                                  )
   aAdd( aBase, { "nNumRem",   "N",     9,    0, "Número de remesa" }                  )
   aAdd( aBase, { "cSufRem",   "C",     2,    0, "Sufijo de remesa" }                  )
   aAdd( aBase, { "lSelDoc",   "L",     1,    0, "" }                                  )
   aAdd( aBase, { "lNoStk",    "L",     1,    0, "No controlar stock" }                )
   aAdd( aBase, { "lKitArt",   "L",     1,    0, "Línea con escandallo" }              )
   aAdd( aBase, { "lKitEsc",   "L",     1,    0, "Línea perteneciente a escandallo" }  )
   aAdd( aBase, { "lImpLin",   "L",     1,    0, "Imprimir línea" }                    )
   aAdd( aBase, { "lKitPrc",   "L",     1,    0, "Precios del kit" }                   )
   aAdd( aBase, { "nNumLin",   "N",     4,    0, "Número de línea" }                   )
   aAdd( aBase, { "mNumSer",   "M",    10,    0, "Números de serie" }                  )
   aAdd( aBase, { "nVolumen",  "N",    16,    6, "Volumen del producto" }              )
   aAdd( aBase, { "cVolumen",  "C",     2,    0, "Unidad del volumen" }                )
   aAdd( aBase, { "nPesoKg",   "N",    16,    6, "Peso del producto" }                 )
   aAdd( aBase, { "cPesoKg",   "C",     2,    0, "Unidad de peso del producto" }       )

Return ( aBase )
*/
//---------------------------------------------------------------------------//

FUNCTION rxHisMov( cPath, oMeter )

	local dbfHisMov

   DEFAULT cPath     := cPatEmp()

   if !lExistTable( cPath + "HISMOV.DBF" )
      dbCreate( cPath + "HISMOV.DBF", aSqlStruct( aItmMov() ), cDriver() )
   end if

   fEraseIndex( cPath + "HISMOV.CDX" )

   dbUseArea( .t., cDriver(), cPath + "HISMOV.DBF", cCheckArea( "HISMOV", @dbfHisMov ), .f. )

   if !( dbfHisMov )->( neterr() )
      ( dbfHisMov )->( __dbPack() )

      ( dbfHisMov )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfHisMov )->( ordCreate( cPath + "HISMOV.CDX", "nNumRem", "Str( nNumRem ) + cSufRem", {|| Str( Field->nNumRem ) + Field->cSufRem }, ) )

      ( dbfHisMov )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfHisMov )->( ordCreate( cPath + "HISMOV.CDX", "dFecMov", "Dtos( dFecMov ) + cTimMov", {|| Dtos( Field->dFecMov ) + Field->cTimMov } ) )

      ( dbfHisMov )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfHisMov )->( ordCreate( cPath + "HISMOV.CDX", "cRefMov", "CREFMOV + CVALPR1 + CVALPR2 + CLOTE", {|| Field->CREFMOV + Field->CVALPR1 + Field->CVALPR2 + Field->cLote } ) )

      ( dbfHisMov )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfHisMov )->( ordCreate( cPath + "HISMOV.CDX", "cAloMov", "CALOMOV", {|| Field->CALOMOV } ) )

      ( dbfHisMov )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfHisMov )->( ordCreate( cPath + "HISMOV.CDX", "cAliMov", "CALIMOV", {|| Field->CALIMOV } ) )

      ( dbfHisMov )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfHisMov )->( ordCreate( cPath + "HISMOV.CDX", "cRefAlm", "cRefMov + cValPr1 + cValPr2 + cAliMov + cLote", {|| Field->cRefMov + Field->cValPr1 + Field->cValPr2 + Field->cAliMov + Field->cLote } ) )

      ( dbfHisMov )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfHisMov )->( ordCreate( cPath + "HISMOV.CDX", "cLote", "cLote", {|| Field->cLote } ) )

      ( dbfHisMov )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfHisMov )->( ordCreate( cPath + "HISMOV.CDX", "nNumLin", "Str( nNumLin )", {|| Str( Field->nNumLin ) } ) )

      ( dbfHisMov )->( ordCondSet("!Deleted() .and. lSndDoc", {|| !Deleted() .and. Field->lSndDoc }  ) )
      ( dbfHisMov )->( ordCreate( cPath + "HISMOV.CDX", "lSndDoc", "lSndDoc", {|| Field->lSndDoc } ) )

      ( dbfHisMov )->( ordCondSet("!Deleted() .and. nTipMov == 4", {|| !Deleted() .and. Field->nTipMov == 4 }, , , , , , , , , .t. ) )
      ( dbfHisMov )->( ordCreate( cPath + "HISMOV.CDX", "nTipMov", "cRefMov + Dtos( dFecMov )", {|| Field->cRefMov + Dtos( Field->dFecMov ) } ) )

      ( dbfHisMov )->( ordCondSet("!Deleted() .and. nTipMov == 4", {|| !Deleted() .and. Field->nTipMov == 4 }, , , , , , , , , .t. ) )
      ( dbfHisMov )->( ordCreate( cPath + "HISMOV.CDX", "cStock", "cRefMov + cAliMov + cValPr1 + cValPr2 + cLote", {|| Field->cRefMov + Field->cAliMov + Field->cValPr1 + Field->cValPr2 + Field->cLote } ) )

      ( dbfHisMov )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfHisMov )->( ordCreate( cPath + "HisMov.Cdx", "cStkFastIn", "cRefMov + cAliMov + cCodPr1 + cCodPr2 + cValPr1 + cValPr2 + cLote", {|| Field->cRefMov + Field->cAliMov + Field->cCodPr1 + Field->cCodPr2 + Field->cValPr1 + Field->cValPr2 + Field->cLote } ) )

      ( dbfHisMov )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfHisMov )->( ordCreate( cPath + "HisMov.Cdx", "cStkFastOu", "cRefMov + cAloMov + cCodPr1 + cCodPr2 + cValPr1 + cValPr2 + cLote", {|| Field->cRefMov + Field->cAloMov + Field->cCodPr1 + Field->cCodPr2 + Field->cValPr1 + Field->cValPr2 + Field->cLote } ) )

      ( dbfHisMov )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfHisMov )->( ordCreate( cPath + "HISMOV.CDX", "cRefFec", "CREFMOV + CLOTE + dTos( dFecMov )", {|| Field->CREFMOV + Field->cLote + dTos( Field->dFecMov ) } ) )

      ( dbfHisMov )->( dbCloseArea() )

   else

      msgStop( "Imposible abrir en modo exclusivo la tabla de movimientos de almacén" )

   end if

RETURN NIL

//---------------------------------------------------------------------------//

FUNCTION mkHisMov( cPath, lAppend, cPathOld, oMeter )

	local dbfHisMov

   DEFAULT cPath     := cPatEmp()
	DEFAULT lAppend	:= .F.

   if oMeter != NIL
      oMeter:cText   := "Generando bases"
		sysrefresh()
   end if

   if !lExistTable( cPath + "HISMOV.DBF" )
      dbCreate( cPath + "HISMOV.DBF", aSqlStruct( aItmMov() ), cDriver() )
   end if

   if lAppend .and. lExistTable( cPathOld + "HISMOV.DBF" )
      dbUseArea( .t., cDriver(), cPath + "HISMOV.DBF", cCheckArea( "HISMOV", @dbfHisMov ), .f. )
      if !( dbfHisMov )->( neterr() )
         ( dbfHisMov )->( __dbApp( cPathOld + "HISMOV.DBF" ) )
         ( dbfHisMov )->( dbCloseArea() )
      end if
   end if

   rxHisMov( cPath, oMeter )

RETURN .t.

//---------------------------------------------------------------------------//

#ifndef __PDA__

//---------------------------------------------------------------------------//

CLASS THisMovSenderReciver FROM TSenderReciverItem

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
   local tmpHisMov
   local lSnd        := .f.
   local cFileName

   if ::oSender:lServer
      cFileName      := "HisMov" + StrZero( ::nGetNumberToSend(), 6 ) + ".All"
   else
      cFileName      := "HisMov" + StrZero( ::nGetNumberToSend(), 6 ) + "." + RetSufEmp()
   end if

   If !OpenFiles( .f. )
      Return Nil
   End If

   ::oSender:SetText( 'Seleccionando historico de movimientos' )

   /*
   Creamos todas las bases de datos relacionadas con historicos de movimientos-
   */

   mkHisMov( cPatSnd() )

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatSnd() + "HISMOV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "HISMOV", @tmpHisMov ) )
   SET ADSINDEX TO ( cPatSnd() + "HISMOV.CDX" ) ADDITIVE

   if !Empty( ::oSender:oMtr )
      ::oSender:oMtr:nTotal := ( dbfHisMov )->( Lastrec() )
   end if

   ( dbfHisMov )->( OrdSetFocus( "SndCod" ) )
   ( dbfHisMov )->( dbGoTop() )

   while !( dbfHisMov )->( eof() )

      if ( dbfHisMov )->lSndDoc

         ::oSender:SetText( "Añadido un movimiento de almacén al artículo: " + AllTrim( ( dbfHisMov )->cRefMov ) + AllTrim( RetFld( ( dbfHisMov )->cRefMov, dbfArticulo, "Nombre" ) ) )

         lSnd     := .t.

         dbPass( dbfHisMov, tmpHisMov, .t. )

      end if

      ( dbfHisMov )->( dbSkip() )

      if !Empty( ::oSender:oMtr )
         ::oSender:oMtr:Set( ( dbfHisMov )->( OrdKeyNo() ) )
      end if

      SysRefresh()

   end while

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos de historico de movimientos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE ( tmpHisMov )

   CloseFiles()

   /*
   Comprimir los archivos------------------------------------------------------
   */

   if lSnd

      ::oSender:SetText( "Comprimiendo historico de movimientos" )

      if ::oSender:lZipData( cFileName )
         ::oSender:SetText( "Ficheros comprimidos" )
      else
         ::oSender:SetText( "ERROR al crear fichero comprimido" )
      end if

   else

      ::oSender:SetText( "No hay historico de movimientos para enviar" )

   end if

Return ( Self )

//---------------------------------------------------------------------------//

Method RestoreData()

   local oBlock
   local oError
   local dbfHisMov

   if ::lSuccesfullSend

      /*
      Sintuacion despues del envio---------------------------------------------
      */

      oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
      BEGIN SEQUENCE

         USE ( cPatEmp() + "HISMOV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "HISMOV", @dbfHisMov ) )
         SET ADSINDEX TO ( cPatEmp() + "HISMOV.CDX" ) ADDITIVE
         ( dbfHisMov )->( ordSetFocus( "SndCod" ) )

         while !( dbfHisMov )->( Eof() )

            if ( dbfHisMov )->( dbRLock() )
               ( dbfHisMov )->lSndDoc   := .f.
               ( dbfHisMov )->( dbRUnlock() )
            end if

            ( dbfHisMov )->( dbSkip() )

         end while

      RECOVER USING oError

         msgStop( "Imposible abrir todas las bases de datos de historico de movimientos" + CRLF + ErrorMessage( oError ) )

      END SEQUENCE

      ErrorBlock( oBlock )

      CLOSE ( dbfHisMov )

   end if

Return ( Self )

//---------------------------------------------------------------------------//

Method SendData()

   local cFileName

   if ::oSender:lServer
      cFileName         := "HisMov" + StrZero( ::nGetNumberToSend(), 6 ) + ".All"
   else
      cFileName         := "HisMov" + StrZero( ::nGetNumberToSend(), 6 ) + "." + RetSufEmp()
   end if

   if File( cPatOut() + cFileName )

      if ::oSender:SendFiles( cPatOut() + cFileName, cFileName )
         ::IncNumberToSend()
         ::lSuccesfullSend := .t.
         ::oSender:SetText( "Ficheros de historico de movimientos enviados " + cFileName )
      else
         ::oSender:SetText( "ERROR fichero de historico de movimientos no enviado" )
      end if

   end if

Return ( Self )

//---------------------------------------------------------------------------//

Method ReciveData()

   local n
   local aExt

   if ::oSender:lServer
      aExt              := RetSufEmp()
   else
      aExt              := { "All" }
   end if

   ::oSender:SetText( "Recibiendo historico de movimientos" )

   for n := 1 to len( aExt )
      ::oSender:GetFiles( "HisMov*." + aExt[ n ], cPatIn() )
   next

   ::oSender:SetText( "Historico de movimientos recibidos" )

Return ( Self )

//---------------------------------------------------------------------------//

Method Process()

   local m
   local aFiles
   local tmpMov
   local tmpHisMov
   local oBlock
   local oError

   /*
   Procesamos los ficheros recibidos-------------------------------------------
   */

   aFiles                     := Directory( cPatIn() + "HisMov*.*" )

   for m := 1 to len( aFiles )

      oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )

      BEGIN SEQUENCE

      /*
      Descomprimimos el fichero recibido------------------------------------
      */

      if ::oSender:lUnZipData( cPatIn() + aFiles[ m, 1 ] )

         if lExistTable( cPatSnd() + "HisMov.Dbf" )     .and.;
            OpenFiles( .f. )

            USE ( cPatSnd() + "HISMOV.DBF" ) NEW VIA ( cDriver() )READONLY ALIAS ( cCheckArea( "HISMOV", @tmpHisMov ) )
            SET ADSINDEX TO ( cPatSnd() + "HISMOV.CDX" ) ADDITIVE

            if !Empty( ::oSender:oMtr )
               ::oSender:oMtr:nTotal := ( tmpHisMov )->( lastrec() )
            end if

            while !( tmpHisMov )->( eof() )

               dbPass( tmpHisMov, dbfHisMov, .t. )
               ::oSender:SetText( "Añadido un movimiento de almacén al artículo: " + AllTrim( ( tmpHisMov )->cRefMov ) + AllTrim( RetFld( ( tmpHisMov )->cRefMov, dbfArticulo, "Nombre" ) ) )

               ( tmpHisMov )->( dbSkip() )

               if !Empty( ::oSender:oMtr )
                  ::oSender:oMtr:Set( ( tmpHisMov )->( OrdKeyNo() ) )
               end if

               SysRefresh()

            end while

            CLOSE ( tmpHisMov )

            CloseFiles()

            ::oSender:AppendFileRecive( aFiles[ m, 1 ] )

         else

            ::oSender:SetText( "Falta el fichero HisMov.dbf" )

         end if

      else

         ::oSender:SetText( "Error en el fichero comprimido" )

      end if

      RECOVER USING oError

         CLOSE ( tmpHisMov )
         CloseFiles()

         ::oSender:SetText( "Error procesando fichero " + aFiles[ m, 1 ] )
         ::oSender:SetText( ErrorMessage( oError ) )

      END SEQUENCE

      ErrorBlock( oBlock )

   next

Return ( Self )

//---------------------------------------------------------------------------//

#endif

//---------------------------------------------------------------------------//

Function cTextoMovimiento( dbfHisMov )

Return ( { "Entre almacenes", "Regularización", "Objetivos", "Consolidación" }[ Min( Max( ( dbfHisMov )->nTipMov, 1 ), 4 ) ] )

//---------------------------------------------------------------------------//