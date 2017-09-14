#include "FiveWin.ch"
#include "Font.ch"
#include "Report.ch"
#include "Image.ch"
#include "MesDbf.ch"
#include "xbrowse.ch"
#include "Factu.ch" 

#define DT_TOP                      0x00000000
#define DT_LEFT                     0x00000000
#define DT_CENTER                   0x00000001
#define DT_RIGHT                    0x00000002
#define DT_VCENTER                  0x00000004
#define DT_BOTTOM                   0x00000008
#define DT_WORDBREAK                0x00000010
#define DT_SINGLELINE               0x00000020
#define DT_EXPANDTABS               0x00000040
#define DT_TABSTOP                  0x00000080
#define DT_NOCLIP                   0x00000100
#define DT_EXTERNALLEADING          0x00000200
#define DT_CALCRECT                 0x00000400
#define DT_NOPREFIX                 0x00000800
#define DT_INTERNAL                 0x00001000

#define _CCODFAM                  1      //   C      5     0
#define _CNOMFAM                  2      //   C     30     0
#define _CCODPRP1                 3
#define _CCODPRP2                 4
#define _CCODGRP                  5      //   C      3     0
#define _LINCTPV                  6
#define _NVALANU                  7      //   N      8     3
#define _NENE                     8      //   N     10     3
#define _NFEB                     9      //   N     10     3
#define _NMAR                    10      //   N     10     3
#define _NABR                    11      //   N     10     3
#define _NMAY                    12      //   N     10     3
#define _NJUN                    13      //   N     10     3
#define _NJUL                    14      //   N     10     3
#define _NAGO                    15      //   N     10     3
#define _NSEP                    16      //   N     10     3
#define _NOCT                    17      //   N     10     3
#define _NNOV                    18      //   N     10     3
#define _NDIC                    19      //   N     10     3
#define _NDTOLIN                 20      //   N      6     2
#define _NPCTRPL                 21      //   N     16     6
#define _LPUBINT                 22      //   L      1     0
#define _NCOLBTN                 23
#define _CIMGBTN                 24
#define _LSELDOC                 25
#define _LPREESP                 26
#define _CCODFRA                 27
#define _CTYPE                   28
#define _CFAMCMB                 29      //   C       8    0
#define _NPOSTPV                 30      //
#define _CCODWEB                 31      //   N      11    0
#define _LACUM                   32      //   L       1    0
#define _LMOSTRAR                33      //   L       1    0
#define _CCODIMP                 34      //   C       3    0
#define _CNOMIMP                 35      //   C      50    0
#define _NPOSINT                 36      //   N       3    0
#define _LFAMINT                 37      //   L       1    0
#define _CCOMFAM                 38      //   C       3    0
#define _CDESWEB                 39      //   C       3    0
#define _NDIAGRT                 40      //   N       6    0
#define _MLNGDES                 41      //   M      10    0

static oWndBrw

static nview
static lOpenFiles    :=.f.

static dbfPrv
static dbfArticulo

static tmpProveedor
static tmpLenguaje

static oGrpFam
static oFraPub
static oComentarios
static oLenguajes

static oDetCamposExtra

static cFileProveedor
static cFileLenguaje

static oComercio

static bEdit         := { |aTmp, aGet, dbfFam, oBrw, bWhen, bValid, nMode | EdtRec( aTmp, aGet, dbfFam, oBrw, bWhen, bValid, nMode ) }
static bEdit2        := { |aTmp, aGet, tmpProveedor, oBrw, bWhen, bValid, nMode | EdtDet( aTmp, aGet, tmpProveedor, oBrw, bWhen, bValid, nMode ) }
static bEditLenguaje := { |aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpArt | EditLenguaje( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpArt ) }

static dbfFamPrv

static oTreePadre

static oBtnAceptarActualizarWeb

#define MENUOPTION   "01012"

//----------------------------------------------------------------------------//
//
// Comenzamos la parte de código que se compila para el ejecutable normal
//

FUNCTION BrwFamilia( oGet, oGet2, lAdd )

	local oDlg
	local oBrw
   local cCod     := Space( 16 )
	local oGet1
	local cGet1
   local nOrd     := GetBrwOpt( "BrwFamilia" )
	local oCbxOrd
   local aCbxOrd  := { "Código", "Nombre" }
   local cCbxOrd
   local nLevel   := nLevelUsr( MENUOPTION )
   local lOpen    := .f.

   DEFAULT lAdd   := .t.

   nOrd           := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd        := aCbxOrd[ nOrd ]

   if !OpenFiles( .t. )
      RETURN nil
   end if

   nOrd           := ( D():Familias( nView ) )->( OrdSetFocus( nOrd ) )

   ( D():Familias( nView ) )->( dbgotop() )

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Familias de artículos"

		REDEFINE GET oGet1 VAR cGet1;
         ID       104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, D():Familias( nView ) ) ) ;
         VALID    ( OrdClearScope( oBrw, D():Familias( nView ) ) );
         BITMAP   "FIND" ;
         OF       oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    aCbxOrd ;
			ON CHANGE( ( D():Familias( nView ) )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:refresh(), oGet1:SetFocus() ) ;
			OF 		oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := D():Familias( nView )
      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "Browse.Familias"

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodFam"
         :bEditValue       := {|| ( D():Familias( nView ) )->cCodFam }
         :nWidth           := 120
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomFam"
         :bEditValue       := {|| ( D():Familias( nView ) )->cNomFam }
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
         WHEN     ( nAnd( nLevel, ACC_APPD ) != 0 .and. !IsReport() .and. lAdd );
         ACTION   ( WinAppRec( oBrw, bEdit, D():Familias( nView ) ) )

		REDEFINE BUTTON ;
         ID       501 ;
         OF       oDlg ;
         WHEN     ( nAnd( nLevel, ACC_EDIT ) != 0 .and. !IsReport() .and. lAdd );
         ACTION   ( WinEdtRec( oBrw, bEdit, D():Familias( nView ) ) )

   if nAnd( nLevel, ACC_APPD ) != 0 .and. !IsReport()
      oDlg:AddFastKey( VK_F2,    {|| WinAppRec( oBrw, bEdit, D():Familias( nView ) ) } )
   end if

   if nAnd( nLevel, ACC_EDIT ) != 0 .and. !IsReport()
      oDlg:AddFastKey( VK_F3,    {|| WinEdtRec( oBrw, bEdit, D():Familias( nView ) ) } )
   end if

   oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )
   oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

   DestroyFastFilter( D():Familias( nView ) )

   SetBrwOpt( "BrwFamilia", ( D():Familias( nView ) )->( OrdNumber() ) )

   if oDlg:nResult == IDOK

      cCod                 := ( D():Familias( nView ) )->cCodFam

      if !empty( oGet )
         oGet:cText( cCod )
      end if

      if !empty( oGet2 )
         oGet2:cText( ( D():Familias( nView ) )->cNomFam )
      end if

   end if

   CloseFiles()

   if !empty( oGet )
      oGet:SetFocus()
   end if

RETURN ( cCod )

//---------------------------------------------------------------------------//

STATIC FUNCTION OpenFiles()

   local lOpen       := .t.
   local oError
   local oBlock
   
   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      DisableAcceso()

      nView          := D():CreateView()

      lOpenFiles     := .t.

      D():Familias( nView )

      D():FamiliasLenguajes( nView )

      D():Lenguajes( nView )

      USE ( cPatArt() + "FamPrv.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FAMPRV", @dbfFamPrv ) )
      SET ADSINDEX TO ( cPatArt() + "FamPrv.Cdx" ) ADDITIVE

      USE ( cPatPrv() + "Provee.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROVEE", @dbfPrv ) )
      SET ADSINDEX TO ( cPatPrv() + "Provee.Cdx" ) ADDITIVE

      USE ( cPatArt() + "Articulo.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
      SET ADSINDEX TO ( cPatArt() + "Articulo.Cdx" ) ADDITIVE
      ( dbfArticulo )->( OrdSetFocus( "cFamCod" ) )

      oGrpFam           := TGrpFam():Create( cPatArt() )
      oGrpFam:OpenFiles()

      oFraPub           := TFrasesPublicitarias():Create( cPatArt() )
      oFraPub:OpenFiles()

      oComentarios      := TComentarios():Create( cPatArt() )
      oComentarios:OpenFiles()

      oDetCamposExtra   := TDetCamposExtra():New()
      if !empty( oDetCamposExtra )
         oDetCamposExtra:OpenFiles()
         oDetCamposExtra:SetTipoDocumento( "Familias" )
         oDetCamposExtra:setbId( {|| D():FamiliasId( nView ) } )
      end if

      oLenguajes        := TLenguaje():Create( cPatDat() )
      if !oLenguajes:OpenFiles()
         lOpenFiles     := .f.
      end if

      oComercio         := TComercioConfig()
      
      if !Empty( oComercio )
         oComercio:getInstance():loadJSON()
      end if

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos de familias" )

      CloseFiles()

      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles()

   CLOSE ( dbfFamPrv    )
   CLOSE ( dbfArticulo  )
   CLOSE ( dbfPrv       )

   if !empty( oGrpFam )
      oGrpFam:End()
   end if

   if !empty( oFraPub )
      oFraPub:End()
   end if

   if !empty( oComentarios )
      oComentarios:End()
   end if

   if !empty( oDetCamposExtra )
      oDetCamposExtra:CloseFiles()
   end if

   if !empty( oLenguajes )
      oLenguajes:End()
   end if

   if !Empty( oComercio )
      oComercio:DestroyInstance()
   end if

   D():DeleteView( nView )

   oWndBrw        := nil

   dbfArticulo    := nil
   dbfPrv         := nil
   oComentarios   := nil
   oLenguajes     := nil

RETURN .t.

//---------------------------------------------------------------------------//

FUNCTION Familia( oMenuItem, oWnd )

   local oSnd
   local nLevel

   DEFAULT  oMenuItem   := MENUOPTION
   DEFAULT  oWnd        := oWnd()

   if oWndBrw == NIL

      /*
      Obtenemos el nivel de acceso
      */

      nLevel            := nLevelUsr( oMenuItem )

      if nAnd( nLevel, 1 ) != 0
         msgStop( "Acceso no permitido." )
         RETURN nil
      end if

      /*
      Cerramos todas las ventanas
      */

      if oWnd != nil
         SysRefresh(); oWnd:CloseAll(); SysRefresh()
      end if

      if !OpenFiles()
         RETURN nil
      end if

      /*
      Anotamos el movimiento para el navegador---------------------------------
      */

      AddMnuNext( "Familias de artículos", ProcName() )

      DEFINE SHELL oWndBrw FROM 0, 0 TO 22, 80;
      XBROWSE ;
      TITLE    "Familias de artículos" ;
      PROMPT   "Código",;
               "Nombre",;
               "Posición" ;
      MRU      "gc_cubes_16" ;
      BITMAP   clrTopArchivos ;
		ALIAS		( D():Familias( nView ) ) ;
      APPEND   ( WinAppRec( oWndBrw:oBrw, bEdit, D():Familias( nView ) ) );
      DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdit, D():Familias( nView ) ) );
      EDIT     ( WinEdtRec( oWndBrw:oBrw, bEdit, D():Familias( nView ) ) );
      DELETE   ( WinDelRec( oWndBrw:oBrw, D():Familias( nView ), {|| DeleteFamiliaProveedores() } ) );
      LEVEL    nLevel ;
		OF 		oWnd

      // Envios ---------------------------------------------------------------

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Envio"
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( D():Familias( nView ) )->lSelDoc }
         :nWidth           := 20
         :SetCheck( { "gc_mail2_12", "Nil16" } )
         :nHeadBmpNo       := 3
         :AddResource( "gc_mail2_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Táctil"
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( D():Familias( nView ) )->lIncTpv }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
         :nHeadBmpNo       := 3
         :AddResource( "Tactil16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código"
         :nHeadBmpNo       := 1
         :cSortOrder       := "CCODFAM"
         :bEditValue       := {|| ( D():Familias( nView ) )->cCodFam }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :AddResource( "Sel16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "CNOMFAM"
         :bEditValue       := {|| ( D():Familias( nView ) )->cNomFam }
         :nWidth           := 260
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Grupo"
         :bStrData         := {|| ( D():Familias( nView ) )->cCodGrp }
         :nWidth           := 60
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Prop. 1"
         :bStrData         := {|| ( D():Familias( nView ) )->cCodPrp1 }
         :nWidth           := 60
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Prop. 2"
         :bStrData         := {|| ( D():Familias( nView ) )->cCodPrp2 }
         :nWidth           := 60
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Posición"
         :cSortOrder       := "nPosTpv"
         :bEditValue       := {|| if( ( D():Familias( nView ) )->lIncTpv, Trans( ( D():Familias( nView ) )->nPosTpv, "99" ), "" ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Familia padre"
         :bStrData         := {|| ( D():Familias( nView ) )->cFamCmb }
         :nWidth           := 60
         :lHide            := .t.
      end with

      oWndBrw:cHtmlHelp    := "Familias"
      
      oWndBrw:CreateXFromCode()

      DEFINE BTNSHELL RESOURCE "BUS" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:SearchSetFocus() ) ;
			TOOLTIP 	"(B)uscar" ;
			HOTKEY 	"B"

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
         MRU ;
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
			ACTION  	( WinZooRec( oWndBrw:oBrw, bEdit, D():Familias( nView ) ) );
			TOOLTIP 	"(Z)oom";
         HOTKEY   "Z";
         LEVEL    ACC_ZOOM

		DEFINE BTNSHELL RESOURCE "DEL" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:RecDel() );
			TOOLTIP 	"(E)liminar";
         HOTKEY   "E";
         LEVEL    ACC_DELE

      DEFINE BTNSHELL RESOURCE "IMP" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( TListadoFamilias():New( "Listado de Familias" ):Play() ) ;
         TOOLTIP  "(L)istado";
         HOTKEY   "L" ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL oSnd RESOURCE "Lbl" GROUP OF oWndBrw ;
         NOBORDER ;
         MENU     This:Toggle() ;
         TOOLTIP  "En(v)iar" ;
         MESSAGE  "Seleccionar registros para ser enviados" ;
         ACTION   IncEnvio() ;
         HOTKEY   "V";
         LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "Lbl" OF oWndBrw ;
            NOBORDER ;
            ACTION   ( lSelectAll( oWndBrw, D():Familias( nView ), "lSelDoc", .t., .t., .t. ) );
            TOOLTIP  "Todos" ;
            FROM     oSnd ;
            CLOSED ;
            LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "Lbl" OF oWndBrw ;
            NOBORDER ;
            ACTION   ( lSelectAll( oWndBrw, D():Familias( nView ), "lSelDoc", .f., .t., .t. ) );
            TOOLTIP  "Ninguno" ;
            FROM     oSnd ;
            CLOSED ;
            LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "TACTIL" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( IncTactil() ) ;
         TOOLTIP  "(T)áctil" ;
         HOTKEY   "T";
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "Up" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( ChangePosition( .f. ), oWndBrw:Select() ) ;
         TOOLTIP  "S(u)bir posición" ;
         HOTKEY   "U";
         LEVEL    ACC_IMPR

      DEFINE BTNSHELL RESOURCE "Down" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( ChangePosition( .t. ), oWndBrw:Select() ) ;
         TOOLTIP  "Ba(j)ar posición" ;
         HOTKEY   "J";
         LEVEL    ACC_IMPR

      DEFINE BTNSHELL RESOURCE "End" GROUP OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:End() ) ;
         TOOLTIP  "(S)alir" ;
			HOTKEY 	"S"

      ACTIVATE WINDOW oWndBrw VALID ( CloseFiles() )

	ELSE

		oWndBrw:SetFocus()

	END IF

RETURN NIL

//----------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aTmp, aGet, cFamilia, oBrw, bWhen, bValid, nMode )

	local oDlg
   local oFld
   local oBlock
   local oError
   local oBrwPrv
   local oBrwLenguaje
   local oSayGrp
   local cSayGrp
   local oSayTComandas
   local cSayTComandas
   local oSayPrpUno
   local cSayPrpUno     := ""
   local oSayPrpDos
   local cSayPrpDos     := ""
   local bmpImage
   local oBmpGeneral
   local oBmpPropiedades
   local oBmpProveedores
   local oBmpIdiomas

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      BeginTrans( aTmp, nMode )

      if empty( aTmp[ _NCOLBTN ] )
         aTmp[ _NCOLBTN ]  := GetSysColor( COLOR_BTNFACE )
      end if

      if nMode == DUPL_MODE
         aTmp[ _CCODFAM ]  := NextKey( aTmp[ _CCODFAM ], D():Familias( nView ) )
      end if

      if nMode == APPD_MODE
         aTmp[ _NPOSINT ]  := 1
      end if

      DEFINE DIALOG oDlg RESOURCE "FAMILIA" TITLE LblTitle( nMode ) + "familias de artículos"

      REDEFINE FOLDER oFld ;
         ID       100 ;
         OF       oDlg ;
         PROMPT   "&General",;
                  "&Propiedades",;
                  "&Proveedores",;
                  "&Idiomas";
         DIALOGS  "FAMILIA_01",;
                  "FAMILIA_04",;
                  "FAMILIA_02",;
                  "FAMILIA_03"

         REDEFINE BITMAP oBmpGeneral ;   
            ID       900 ;
            RESOURCE "gc_cubes_48" ;
            TRANSPARENT ;
            OF       oFld:aDialogs[1]

         REDEFINE BITMAP oBmpPropiedades ;
            ID       900 ;
            RESOURCE "gc_bookmarks_48" ;
            TRANSPARENT ;
            OF       oFld:aDialogs[2]

         REDEFINE BITMAP oBmpProveedores ;
            ID       900 ;
            RESOURCE "gc_businessman_48" ;
            TRANSPARENT ;
            OF       oFld:aDialogs[3]

         REDEFINE BITMAP oBmpIdiomas ;
            ID       900 ;
            RESOURCE "gc_user_message_48" ;
            TRANSPARENT ;
            OF       oFld:aDialogs[4]


         /*
         Redefinici¢n de la primera caja de Dialogo-------------------------------
         */

         REDEFINE GET aGet[ _CCODFAM ] VAR aTmp[ _CCODFAM ];
            ID       100 ;
            WHEN     ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) ;
            ON HELP  ( aGet[ _CCODFAM ]:cText( NextKey( aTmp[ _CCODFAM ], D():Familias( nView ) ) ) ) ; // dbLast( D():Familias( nView ), 1, nil, nil, 1 ) ) ) ) ;
            BITMAP   "BOT" ;
            VALID    ( notValid( aGet[ _CCODFAM ], D():Familias( nView ) ) ) ;
            PICTURE  "@!" ;
            OF       oFld:aDialogs[1]

         REDEFINE GET aGet[ _CNOMFAM ] VAR aTmp[ _CNOMFAM ] ;
            ID       110 ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            OF       oFld:aDialogs[1]

         REDEFINE GET aGet[ _CCODGRP ] VAR aTmp[ _CCODGRP ] ;
            ID       120 ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            VALID    ( oSayGrp:cText( RetFld( aTmp[ _CCODGRP ], oGrpFam:GetAlias() ) ), .t. );
            ON HELP  ( oGrpFam:Buscar( aGet[ _CCODGRP ], "cCodGrp" ) ) ;
            BITMAP   "LUPA" ;
            OF       oFld:aDialogs[1]

         REDEFINE GET oSayGrp VAR cSayGrp ;
            ID       121 ;
            SPINNER ;
            WHEN     ( .f. ) ;
            OF       oFld:aDialogs[1]

         REDEFINE GET aGet[ _CCODPRP1 ] VAR aTmp[ _CCODPRP1 ] ;
            ID       130 ;
            PICTURE  "@!" ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            VALID    cProp( aGet[ _CCODPRP1 ], oSayPrpUno ) ;
            ON HELP  brwProp( aGet[ _CCODPRP1 ], oSayPrpUno ) ;
            BITMAP   "LUPA" ;
            OF       oFld:aDialogs[1]

         REDEFINE GET oSayPrpUno VAR cSayPrpUno ;
            ID       131 ;
            WHEN     ( .f. ) ;
            OF       oFld:aDialogs[1]

         REDEFINE GET aGet[ _CCODPRP2 ] VAR aTmp[ _CCODPRP2 ] ;
            ID       140 ;
            PICTURE  "@!" ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            VALID    cProp( aGet[ _CCODPRP2 ], oSayPrpDos ) ;
            ON HELP  brwProp( aGet[ _CCODPRP2 ], oSayPrpDos ) ;
            BITMAP   "LUPA" ;
            OF       oFld:aDialogs[1]

         REDEFINE GET oSayPrpDos VAR cSayPrpDos ;
            ID       141 ;
            WHEN     ( .f. ) ;
            OF       oFld:aDialogs[ 1 ]   

         /*
         Tree de las familias padre--------------------------------------------------
         */   

         oTreePadre                     := TTreeView():Redefine( 200, oFld:aDialogs[1] )
         oTreePadre:bItemSelectChanged  := {|| ChangeTreeState() }

         REDEFINE IMAGE bmpImage ;
            ID       600 ;
            OF       oFld:aDialogs[1] ;
            FILE     cFileBmpName( aTmp[ _CIMGBTN ] )

         bmpImage:SetColor( , GetSysColor( 15 ) )
         bmpImage:bLClicked   := {|| ShowImage( bmpImage ) }
         bmpImage:bRClicked   := {|| ShowImage( bmpImage ) }

         /*
         Segunda Caja de diálogo-----------------------------------------------
         */

         REDEFINE CHECKBOX aTmp[ _LFAMINT ];
            ID       116 ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            OF       oFld:aDialogs[2]

         REDEFINE GET aGet[ _NCOLBTN ] VAR aTmp[ _NCOLBTN ] ;
            ID       290 ;
            COLOR    aTmp[ _NCOLBTN ], aTmp[ _NCOLBTN ] ;
            BITMAP   "gc_photographic_filters_16" ;
            ON HELP  ( ColorFam( aGet[ _NCOLBTN ] ) ) ;
            OF       oFld:aDialogs[2]

         REDEFINE GET aGet[ _CIMGBTN ] VAR aTmp[ _CIMGBTN ] ;
            BITMAP   "FOLDER" ;
            ON HELP  ( GetBmp( aGet[ _CIMGBTN ], bmpImage ) ) ;
            ON CHANGE( ChgBmp( aGet[ _CIMGBTN ], bmpImage ) ) ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            ID       300 ;
            OF       oFld:aDialogs[2]

         /*
         Comentario por defecto para el táctil---------------------------------
         */

         REDEFINE GET aGet[ _CCOMFAM ] VAR aTmp[ _CCOMFAM ] ;
            ID       430 ;
            IDTEXT   431 ;
            BITMAP   "LUPA" ;
            VALID    ( oComentarios:Existe( aGet[ _CCOMFAM ], aGet[ _CCOMFAM ]:oHelpText, "cDescri" ) );
            ON HELP  ( oComentarios:Buscar( aGet[ _CCOMFAM ] ) ) ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            OF       oFld:aDialogs[2]

         REDEFINE GET aGet[ _NDTOLIN ] VAR aTmp[ _NDTOLIN ] ;
            ID       320 ;
            SPINNER ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            PICTURE  "@E 99.99" ;
            OF       oFld:aDialogs[2]

         REDEFINE GET aGet[ _NPOSINT ] VAR aTmp[ _NPOSINT ] ;
            ID       180 ;
            VALID    ( aTmp[ _NPOSINT ] >= 1 .and. aTmp[ _NPOSINT ] <= 999 ) ;
            SPINNER ;
            MIN      ( 1 ) ;
            MAX      ( 999 ) ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            PICTURE  "999" ;
            OF       oFld:aDialogs[2]

         REDEFINE GET aGet[ _NPCTRPL ] VAR aTmp[ _NPCTRPL ] ;
            ID       310 ;
            SPINNER ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            PICTURE  "@E 99.99" ;
            OF       oFld:aDialogs[2]

         REDEFINE CHECKBOX aTmp[ _LPREESP ];
            ID       315 ;
            WHEN     ( nMode != ZOOM_MODE );
            OF       oFld:aDialogs[2]

         REDEFINE CHECKBOX aTmp[ _LINCTPV ];
            ID       150 ;
            ON CHANGE( if( nMode != APPD_MODE, IncTactil( aTmp[ _LINCTPV ] ), .t. ) ) ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            OF       oFld:aDialogs[2]

         REDEFINE CHECKBOX aTmp[ _LACUM ];
            ID       160 ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            OF       oFld:aDialogs[2]

         REDEFINE CHECKBOX aGet[ _LMOSTRAR ] VAR aTmp[ _LMOSTRAR ];
            ID       170 ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            OF       oFld:aDialogs[2]

         REDEFINE GET aGet[ _NPOSTPV ] VAR aTmp[ _NPOSTPV ] ;
            ID       330 ;
            PICTURE  "99";
            WHEN     ( nMode != ZOOM_MODE );
            VALID    ( aTmp[ _NPOSTPV ] >= 1 .and. aTmp[ _NPOSTPV ] <= 99 ) ;
            SPINNER ;
            MIN      ( 1 ) ;
            MAX      ( 99 ) ;
            OF       oFld:aDialogs[2]

         REDEFINE GET aGet[ _CDESWEB ] ;
            VAR      aTmp[ _CDESWEB ] ;
            ID       340 ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            PICTURE  "@!" ;
            OF       oFld:aDialogs[2]

         REDEFINE GET aGet[ _MLNGDES ] ;
            VAR      aTmp[ _MLNGDES ];
            ID       130 ;
            MEMO ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            OF       oFld:aDialogs[2]

         REDEFINE GET aGet[ _NDIAGRT ] ;
            VAR      aTmp[ _NDIAGRT ] ;
            ID       360 ;
            PICTURE  "999999";
            SPINNER ;
            MIN      ( 1 ) ;
            MAX      ( 999999 ) ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            OF       oFld:aDialogs[2]

         REDEFINE COMBOBOX aGet[ _CTYPE ];
            VAR      aTmp[ _CTYPE ];
            ITEMS    { "", "Root", "Start" };
            ID       370 ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            OF       oFld:aDialogs[2]

         // Segunda caja de dialogo--------------------------------------------------

         oBrwPrv                 := IXBrowse():New( oFld:aDialogs[ 3 ] )

         oBrwPrv:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
         oBrwPrv:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

         oBrwPrv:cAlias          := tmpProveedor
         oBrwPrv:nMarqueeStyle   := 6

            with object ( oBrwPrv:AddCol() )
               :cHeader          := "Proveedor"
               :bEditValue       := {|| Rtrim( ( tmpProveedor )->cCodPrv ) + Space( 1 ) + retFld( ( tmpProveedor )->cCodPrv, dbfPrv, "Titulo" ) }
               :nWidth           := 220
            end with

            with object ( oBrwPrv:AddCol() )
               :cHeader          := "Familia"
               :bEditValue       := {|| ( tmpProveedor )->cFamPrv }
               :nWidth           := 140
            end with

            if nMode != ZOOM_MODE
               oBrwPrv:bLDblClick   := {|| WinEdtRec( oBrwPrv, bEdit2, tmpProveedor ) }
            end if

            oBrwPrv:CreateFromResource( 530 )

         // Idiomas -----------------------------------------------------------

         REDEFINE BUTTON;
            ID       500 ;
            OF       oFld:aDialogs[ 4 ];
            WHEN     ( nMode != ZOOM_MODE );
            ACTION   ( WinAppRec( oBrwLenguaje, bEditLenguaje, tmpLenguaje ) )

         REDEFINE BUTTON;
            ID       510 ;
            OF       oFld:aDialogs[ 4 ];
            WHEN     ( nMode != ZOOM_MODE );
            ACTION   ( WinEdtRec( oBrwLenguaje, bEditLenguaje, tmpLenguaje ) )

         REDEFINE BUTTON;
            ID       520 ;
            OF       oFld:aDialogs[ 4 ];
            WHEN     ( nMode != ZOOM_MODE );
            ACTION   ( dbDelRec( oBrwLenguaje, tmpLenguaje ) )

         oBrwLenguaje                  := IXBrowse():New( oFld:aDialogs[ 4 ] )

         oBrwLenguaje:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
         oBrwLenguaje:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

         oBrwLenguaje:cAlias           := tmpLenguaje
         oBrwLenguaje:nMarqueeStyle    := 6

            with object ( oBrwLenguaje:AddCol() )
               :cHeader                := "Idioma"
               :bEditValue             := {|| alltrim( ( tmpLenguaje )->cCodLen ) + " - " + retFld( ( tmpLenguaje )->cCodLen, D():Lenguajes( nView ), "cNomLen" ) }
               :nWidth                 := 220
            end with

            with object ( oBrwLenguaje:AddCol() )
               :cHeader                := "Descripción"
               :bEditValue             := {|| ( tmpLenguaje )->cDesFam }
               :nWidth                 := 400
            end with

            if nMode != ZOOM_MODE
               oBrwLenguaje:bLDblClick   := {|| WinEdtRec( oBrwLenguaje, bEditLenguaje, tmpLenguaje ) }
            end if

            oBrwLenguaje:CreateFromResource( 530 )

         // Botones------------------------------------------------------------

         REDEFINE BUTTON ;
            ID       500 ;
            OF       oFld:aDialogs[3];
            WHEN     ( nMode != ZOOM_MODE ) ;
            ACTION   ( WinAppRec( oBrwPrv, bEdit2, tmpProveedor ) )

         REDEFINE BUTTON ;
            ID       510 ;
            OF       oFld:aDialogs[3];
            WHEN     ( nMode != ZOOM_MODE ) ;
            ACTION   ( WinEdtRec( oBrwPrv, bEdit2, tmpProveedor ) )

         REDEFINE BUTTON ;
            ID       520 ;
            OF       oFld:aDialogs[3];
            WHEN     ( nMode != ZOOM_MODE ) ;
            ACTION   ( dbDelRec( oBrwPrv, tmpProveedor ) )

         // Grabamos-----------------------------------------------------------------

         REDEFINE BUTTON oBtnAceptarActualizarWeb;
            ID       3 ;
            OF       oDlg ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            ACTION   ( EndTrans( aTmp, aGet, nMode, oBrwPrv, oDlg, .t. ) )

         REDEFINE BUTTON ;
            ID       IDOK ;
            OF       oDlg ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            ACTION   ( EndTrans( aTmp, aGet, nMode, oBrwPrv, oDlg ) )

         REDEFINE BUTTON ;
            ID       IDCANCEL ;
            OF       oDlg ;
            CANCEL ;
            ACTION   ( KillTrans(), oDlg:end() )

      if nMode != ZOOM_MODE
         
         oFld:aDialogs[2]:AddFastKey( VK_F2, {|| WinAppRec( oBrwPrv, bEdit2, tmpProveedor ) } )
         oFld:aDialogs[2]:AddFastKey( VK_F3, {|| WinEdtRec( oBrwPrv, bEdit2, tmpProveedor ) } )
         oFld:aDialogs[2]:AddFastKey( VK_F4, {|| dbDelRec( oBrwPrv, tmpProveedor ) } )

         oDlg:AddFastKey( VK_F5, {|| EndTrans( aTmp, aGet, nMode, oBrwPrv, oDlg ) } )

         if ( TComercioConfig():getInstance():isRealTimeConexion() )
            oDlg:AddFastKey( VK_F6, {|| EndTrans( aTmp, aGet, nMode, oBrwPrv, oDlg, .t. ) } )
         end if

         oDlg:AddFastKey( VK_F9, {|| oDetCamposExtra:Play( space(1) ) } )

      end if

      oDlg:bStart    := {|| StartEdtRec( aGet, aTmp, bmpImage ) }

      ACTIVATE DIALOG oDlg CENTER ;
         ON INIT     ( EdtRecMenu( oDlg, aTmp ) ) ;

   RECOVER USING oError

      msgStop( "Imposible abrir dialogo de familias." + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !empty( oBrwPrv )
      oBrwPrv:End()
   end if

   if !empty( oBmpGeneral )
      oBmpGeneral:End()
   end if

   if !empty( oBmpPropiedades )
      oBmpPropiedades:End()
   end if

   if !empty( oBmpProveedores )
      oBmpProveedores:End()
   end if

   if !empty( oBmpIdiomas )
      oBmpIdiomas:End()
   end if

   /*
   Borramos los ficheros-------------------------------------------------------
	*/

   KillTrans()

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

STATIC FUNCTION EdtRecMenu( oDlg, aTmp )

   local oMenu

   MENU oMenu

      MENUITEM    "&1. Rotor"

         MENU

            MENUITEM "&1. Campos extra [F9]";
            MESSAGE  "Mostramos y rellenamos los campos extra para la familia" ;
            RESOURCE "gc_form_plus2_16" ;
            ACTION   ( oDetCamposExtra:Play( Space(1) ) )

         ENDMENU

   ENDMENU

   oDlg:SetMenu( oMenu )

RETURN ( oMenu )

//--------------------------------------------------------------------------//

STATIC FUNCTION StartEdtRec( aGet, aTmp, bmpImage )

   aGet[ _CCODGRP  ]:lValid()
   aGet[ _CCOMFAM  ]:lValid()
   aGet[ _CCODPRP1 ]:lValid()
   aGet[ _CCODPRP2 ]:lValid()

   aGet[ _CCODFAM ]:SetFocus()

   LoadTree()  

   SetTreeState( , , aTmp[ _CFAMCMB ] )

   ChgBmp( aGet[ _CIMGBTN ], bmpImage )

   // Tiendas en prestashop----------------------------------------------------

   if TComercioConfig():getInstance():isRealTimeConexion()
      oBtnAceptarActualizarWeb:Show()
   else   
      oBtnAceptarActualizarWeb:Hide()
   end if

RETURN .t.

//---------------------------------------------------------------------------//

STATIC FUNCTION LoadTree( oTree, cCodFam )

   local nRec
   local nOrd
   local oNode

   if empty( cCodFam )
      // RETURN .t.
      cCodFam        := Space( 16 )
   end if

   DEFAULT oTree     := oTreePadre

   CursorWait()

   nRec              := ( D():Familias( nView ) )->( Recno() )
   nOrd              := ( D():Familias( nView ) )->( OrdSetFocus( "cFamCmb" ) )

   if ( D():Familias( nView ) )->( dbSeek( cCodFam ) )

      while ( ( D():Familias( nView ) )->cFamCmb == cCodFam .and. !( D():Familias( nView ) )->( eof() ) )

         oNode       := oTree:Add( Alltrim( ( D():Familias( nView ) )->cNomFam ) )
         oNode:Cargo := ( D():Familias( nView ) )->cCodFam

         LoadTree( oNode, ( D():Familias( nView ) )->cCodFam )

         ( D():Familias( nView ) )->( dbSkip() )

         SysRefresh()

      end while

   end if

   ( D():Familias( nView ) )->( OrdSetFocus( nOrd ) )
   ( D():Familias( nView ) )->( dbGoTo( nRec ) )

   CursorWE()

   oTree:Expand()

RETURN ( .t. )

//---------------------------------------------------------------------------//

FUNCTION getHashFamilias()

   local aFamilias   := {}

   ( D():Familias( nView ) )->( dbgotop() )

   while !( D():Familias( nView ) )->( eof() ) 

      aadd( aFamilias, { ( D():Familias( nView ) )->cCodFam, LoadText( alltrim( upper( ( D():Familias( nView ) )->cNomFam ) ), ( D():Familias( nView ) )->cFamCmb ) } )

      ( D():Familias( nView ) )->( dbSkip() )

      SysRefresh()

   end while

RETURN ( aFamilias )

//---------------------------------------------------------------------------//

STATIC FUNCTION LoadText( cText, cCodFam )

   local nRec
   local nOrd

   if empty( cCodFam )
      cCodFam        := Space( 16 )
   end if

   CursorWait()

   nRec              := ( D():Familias( nView ) )->( Recno() )
   nOrd              := ( D():Familias( nView ) )->( OrdSetFocus( "cCodFam" ) )

   if ( D():Familias( nView ) )->( dbSeek( cCodFam ) )

      cText          := alltrim( upper( ( D():Familias( nView ) )->cNomFam ) ) + ", " + cText

      LoadText( @cText, ( D():Familias( nView ) )->cFamCmb )

      SysRefresh()

   end if

   ( D():Familias( nView ) )->( OrdSetFocus( nOrd ) )
   ( D():Familias( nView ) )->( dbGoTo( nRec ) )

   CursorWE()

RETURN ( cText )

//---------------------------------------------------------------------------//

STATIC FUNCTION SetTreeState( oTree, aItems, cCodFam )

   local oItem

   DEFAULT oTree  := oTreePadre

   if empty( aItems )
      aItems      := oTree:aItems
   end if

   for each oItem in aItems

      if ( cCodFam == oItem:Cargo )

         oTree:Select( oItem )
         oTree:SetCheck( oItem, .t. )

         SysRefresh()

      end if

      if len( oItem:aItems ) > 0
         SetTreeState( oTree, oItem:aItems, cCodFam )
      end if

   next

RETURN ( .t. )

//---------------------------------------------------------------------------//

STATIC FUNCTION ChangeTreeState( oTree, aItems )

   local oItem

   DEFAULT oTree  := oTreePadre

   if empty( aItems )
      aItems      := oTree:aItems
   end if

   for each oItem in aItems

      SysRefresh()

      //tvSetCheckState( oTree:hWnd, oItem:hItem, .f. )

      oTree:SetCheck( oItem, .f. )

      if len( oItem:aItems ) > 0
         ChangeTreeState( oTree, oItem:aItems )
      end if

   next

RETURN ( .t. )

//---------------------------------------------------------------------------//

STATIC FUNCTION GetTreeState( aTmp, oTree, aItems )

   local oItem

   DEFAULT oTree              := oTreePadre

   if empty( aItems )
      aItems                  := oTree:aItems
   end if

   for each oItem in aItems

      // if tvGetCheckState( oTree:hWnd, oItem:hItem )
      if oTree:GetCheck( oItem )
         aTmp[ _CFAMCMB ]     := oItem:Cargo
      end if

      if len( oItem:aItems ) > 0
         GetTreeState( aTmp, oTree, oItem:aItems )
      end if

   next

RETURN ( aTmp )

//---------------------------------------------------------------------------//

STATIC FUNCTION aChildTree( cCodFamilia, aChild )

   local nRec
   local nOrd

   if empty( aChild )
      aChild   := {}
   end if

   CursorWait()

   nRec        := ( D():Familias( nView ) )->( Recno() )
   nOrd        := ( D():Familias( nView ) )->( OrdSetFocus( "cFamCmb" ) )

   if ( D():Familias( nView ) )->( dbSeek( cCodFamilia ) )

      while ( ( D():Familias( nView ) )->cFamCmb == cCodFamilia .and. !( D():Familias( nView ) )->( Eof() ) )

         aAdd( aChild, ( D():Familias( nView ) )->cCodFam )

         aChildTree( ( D():Familias( nView ) )->cCodFam, aChild )

         ( D():Familias( nView ) )->( dbSkip() )

      end while

   end if

   ( D():Familias( nView ) )->( OrdSetFocus( nOrd ) )
   ( D():Familias( nView ) )->( dbGoTo( nRec ) )

   CursorWE()

RETURN ( aChild )

//---------------------------------------------------------------------------//

STATIC FUNCTION BeginTrans( aTmp, nMode )

   local cCodFam     := aTmp[ _CCODFAM ]

   cFileProveedor    := cGetNewFileName( cPatTmp() + "FamPrvl" )
   cFileLenguaje     := cGetNewFileName( cPatTmp() + "FamLeng" )

	/*
   Primero Crear la base de datos local----------------------------------------
	*/

   dbCreate( cFileProveedor, aSqlStruct( aItmFamPrv() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cFileProveedor, cCheckArea( "FamPrvl", @tmpProveedor ), .f. )

   if !( tmpProveedor )->( neterr() )

      ( tmpProveedor )->( ordcondset( "!Deleted()", {|| !Deleted() } ) )
      ( tmpProveedor )->( ordcreate( cFileProveedor, "cPrvFam", "cCodPrv + cFamPrv", {|| Field->cCodPrv + Field->cFamPrv } ) )

      /*
      A¤adimos desde el fichero de lineas
      */

      if ( dbfFamPrv )->( dbSeek( cCodFam ) )
         while ( ( dbfFamPrv )->cCodFam == cCodFam .and. !( dbfFamPrv )->( Eof() ) )
            dbPass( dbfFamPrv, tmpProveedor, .t. )
            ( dbfFamPrv )->( dbSkip() )
         end while
      end if

      ( tmpProveedor )->( dbgotop() )

   end if

   /*
   Primero Crear la base de datos local----------------------------------------
   */

   dbCreate( cFileLenguaje, aSqlStruct( aItmFamiliaLenguajes() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cFileLenguaje, cCheckArea( "FamLeng", @tmpLenguaje ), .f. )

   if !( tmpLenguaje )->( neterr() )

      ( tmpLenguaje )->( ordcondset( "!Deleted()", {|| !Deleted() } ) )
      ( tmpLenguaje )->( ordcreate( cFileLenguaje, "cPrvFam", "cCodFam + cCodLen", {|| Field->cCodFam + Field->cCodLen } ) )

      if ( D():FamiliasLenguajes( nView ) )->( dbSeek( cCodFam ) )
         while ( ( D():FamiliasLenguajes( nView ) )->cCodFam == cCodFam .and. !( D():FamiliasLenguajes( nView ) )->( Eof() ) )
            dbPass( D():FamiliasLenguajes( nView ), tmpLenguaje, .t. )
            ( D():FamiliasLenguajes( nView ) )->( dbSkip() )
         end while
      end if

      ( tmpLenguaje )->( dbgotop() )

   end if

   oDetCamposExtra:SetTemporal( aTmp[ _CCODFAM ], "", nMode )

RETURN Nil

//-----------------------------------------------------------------------//

STATIC FUNCTION EndTrans( aTmp, aGet, nMode, oBrw, oDlg, lActualizaWeb )

   local oError
   local oBlock
   local cCodFam           := aTmp[ _CCODFAM ]
   local aGrp

   DEFAULT lActualizaWeb   := .f.

   //Controlamos que no se cree una familia con el código o el nombre en blanco

   if nMode == APPD_MODE .or. nMode == DUPL_MODE

      if empty( cCodFam )
         MsgStop( "Código no puede estar vacío" )
         aGet[ _CCODFAM ]:SetFocus()
         RETURN nil
      end if

      if dbSeekInOrd( cCodFam, "cCodFam", D():Familias( nView ) )
         MsgStop( "Código ya existe " + Rtrim( cCodFam ) )
         RETURN nil
      end if

   end if

   if empty( aTmp[ _CNOMFAM ] )
      MsgStop( "Nombre no puede estar vacío" )
      aGet[ _CNOMFAM ]:SetFocus()
      RETURN nil
   end if

   do case
      case !empty( aTmp[ _CCODPRP2 ] ) .AND. empty( aTmp[ _CCODPRP1 ] )
         MsgStop( "Para informar la propiedad 2 no puede dejar vacía la propiedad 1." )
         RETURN nil
      case aTmp[ _CCODPRP1 ] == aTmp[ _CCODPRP2 ] .AND. !empty( aTmp[ _CCODPRP1 ] ) .AND. !empty( aTmp[ _CCODPRP2 ] )
         MsgStop( "No puede repetir las propiedades." )
         RETURN nil
   end case

   aTmp[ _CFAMCMB ]        := ""

   GetTreeState( aTmp )

   if ( aTmp[ _CFAMCMB ] == aTmp[ _CCODFAM ] )
      MsgStop( "Familia padre no puede ser el mismo" )
      oTreePadre:SetFocus()
      RETURN nil
   end if

   aGrp  := aChildTree( aTmp[ _CCODFAM ] )
   if aScan( aGrp, aTmp[ _CFAMCMB ] ) != 0
      MsgStop( "Familia padre contiene referencia circular" )
      oTreePadre:SetFocus()
      RETURN nil
   end if

   aTmp[ _LSELDOC ]  := .t.

	/*
	Primero hacer el RollBack---------------------------------------------------
	*/

   CursorWait()

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      BeginTransaction()

      /*
      Roll Back----------------------------------------------------------------
      */

      while ( dbfFamPrv )->( dbSeek( cCodFam ) ) .and. !( dbfFamPrv )->( Eof() )
         if dbLock( dbfFamPrv )
            ( dbfFamPrv )->( dbDelete() )
            ( dbfFamPrv )->( dbUnLock() )
         end if
      end while

      while ( D():FamiliasLenguajes( nView ) )->( dbSeek( cCodFam ) ) .and. !( D():FamiliasLenguajes( nView ) )->( Eof() )
         if dbLock( D():FamiliasLenguajes( nView ) )
            ( D():FamiliasLenguajes( nView ) )->( dbDelete() )
            ( D():FamiliasLenguajes( nView ) )->( dbUnLock() )
         end if
      end while

      /*
      Ahora escribimos en el fichero definitivo--------------------------------
      */

      ( tmpProveedor )->( dbgotop() )
      while !( tmpProveedor )->( eof() )
         dbPass( tmpProveedor, dbfFamPrv, .t., cCodFam )
         ( tmpProveedor )->( dbSkip() )
      end while

      ( tmpLenguaje )->( dbgotop() )
      while !( tmpLenguaje )->( eof() )
         dbPass( tmpLenguaje, D():FamiliasLenguajes( nView ), .t., cCodFam )
         ( tmpLenguaje )->( dbSkip() )
      end while

      // Guardamos los campos extra--------------------------------------------

      oDetCamposExtra:saveExtraField( cCodFam, "" )

      // Escribe los datos pendientes------------------------------------------

      WinGather( aTmp, aGet, D():Familias( nView ), oBrw, nMode )

      CommitTransaction()

      // Actualizamos los datos de la web para tiempo real---------------------

      if lActualizaWeb
         actualizaWeb( cCodFam )
      end if 

   RECOVER USING oError

      RollBackTransaction()

      msgStop( ErrorMessage( oError ), "Imposible almacenar artículo" )

   END SEQUENCE

   ErrorBlock( oBlock )

   CursorWe()

   oDlg:end( IDOK )

   // dbCommitAll()

RETURN NIL

//---------------------------------------------------------------------------//
/*
Borramos los ficheros
*/

STATIC FUNCTION KillTrans()

   if ( tmpProveedor )->( Used() )
      ( tmpProveedor )->( dbCloseArea() )
   end if

   dbfErase( cFileProveedor )

   if ( tmpLenguaje )->( Used() )
      ( tmpLenguaje )->( dbCloseArea() )
   end if

   dbfErase( cFileLenguaje )

RETURN .T.

//------------------------------------------------------------------------//

STATIC FUNCTION EditLenguaje( aTmp, aGet, tmpLenguaje, oBrwLenguaje, bWhen, bValid, nMode )

   local oDlg
   local oBmp

   DEFINE DIALOG oDlg RESOURCE "FAMILIA_LENGUAJE" TITLE LblTitle( nMode ) + "descripciones por lenguaje"

   REDEFINE BITMAP oBmp ;
      ID          600 ;
      RESOURCE    "gc_user_message_48" ; 
      TRANSPARENT ;
      OF          oDlg

   REDEFINE GET   aGet[ ( tmpLenguaje )->( fieldpos( "cCodLen" ) ) ] ;
      VAR         aTmp[ ( tmpLenguaje )->( fieldpos( "cCodLen" ) ) ] ;
      ID          110 ;
      IDTEXT      111 ;
      VALID       ( oLenguajes:Existe( aGet[ ( tmpLenguaje )->( fieldpos( "cCodLen" ) ) ], aGet[ ( tmpLenguaje )->( fieldpos( "cCodLen" ) ) ]:oHelpText, "cNomLen" ) );
      ON HELP     ( oLenguajes:Buscar( aGet[ ( tmpLenguaje )->( fieldpos( "cCodLen" ) ) ] ) ) ;
      BITMAP      "LUPA" ;
      OF          oDlg

   REDEFINE GET   aGet[ ( tmpLenguaje )->( fieldpos( "cDesFam" ) ) ] ; 
      VAR         aTmp[ ( tmpLenguaje )->( fieldpos( "cDesFam" ) ) ] ;
      ID          120 ;
      OF          oDlg

   REDEFINE GET aGet[ ( tmpLenguaje )->( fieldpos( "mLngDes" ) ) ] ;
      VAR         aTmp[ ( tmpLenguaje )->( fieldpos( "mLngDes" ) ) ];
      ID          130 ;
      MEMO ;
      WHEN        ( nMode != ZOOM_MODE ) ;
      OF          oDlg

   REDEFINE BUTTON;
      ID          IDOK ;
      OF          oDlg ;
      ACTION      ( endEditLenguaje( aGet, aTmp, nMode, oBrwLenguaje, oDlg ) )

   REDEFINE BUTTON;
      ID          IDCANCEL ;
      OF          oDlg ;
      CANCEL ;
      ACTION      ( oDlg:end() )

   if nMode != APPD_MODE
      oDlg:AddFastKey( VK_F5, {|| endEditLenguaje( aGet, aTmp, nMode, oBrwLenguaje, oDlg ) } )
   end if

   oDlg:bStart    := {|| aGet[ ( tmpLenguaje )->( fieldpos( "cCodLen" ) ) ]:lValid() }

   ACTIVATE DIALOG oDlg CENTER

   if !empty( oBmp )
      oBmp:End()
   end if

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

static function endEditLenguaje( aGet, aTmp, nMode, oBrwLenguaje, oDlg )

   if empty( aTmp[ ( tmpLenguaje )->( FieldPos( "cCodLen" ) ) ] )
      msgStop( "Código de lenguaje no puede estar vacío." )
      aGet[ ( tmpLenguaje )->( FieldPos( "cCodLen" ) ) ]:SetFocus()
      Return .f.
   end if

   if empty( aTmp[ ( tmpLenguaje )->( FieldPos( "cDesFam" ) ) ] ) 
      msgStop( "Tiene que introducir al menos una descripción." )
      aGet[ ( tmpLenguaje )->( FieldPos( "cDesFam" ) ) ]:SetFocus()
      Return .f.
   end if

   // Guardamos el fichero temporal--------------------------------------------

   WinGather( aTmp, aGet, tmpLenguaje, oBrwLenguaje, nMode )

   oDlg:End( IDOK )

Return ( .t. )

//---------------------------------------------------------------------------//

STATIC FUNCTION actualizaWeb( cCodigoFamilia )

   local TComercio   := TComercio():New( nView )
   local aChildTree  := {}

   aChildTree        := aChildTree( cCodigoFamilia, aChildTree )

   aadd( aChildTree, cCodigoFamilia )

   aeval( aChildTree, {|cCodigoFamilia| TComercio:controllerExportOneCategoryToPrestashop( cCodigoFamilia ) } )

RETURN ( nil )

//----------------------------------------------------------------------------//

STATIC FUNCTION EdtDet( aTmp, aGet, tmpProveedor, oBrw, bWhen, bValid, nMode )

	local oDlg
	local oGet
   local oGet2
	local oGetTxt
	local cGetTxt

   DEFINE DIALOG oDlg RESOURCE "LFAMPRV" TITLE LblTitle( nMode ) + "familias de proveedores"

      REDEFINE GET oGet;
         VAR      aTmp[ ( tmpProveedor )->( FieldPos( "cCodPrv" ) ) ];
			ID 		100 ;
         PICTURE  ( RetPicCodPrvEmp() ) ;
         WHEN     ( nMode == APPD_MODE ) ;
         VALID    ( cProvee( oGet, dbfPrv, oGetTxt ) ) ;
         ON HELP  ( BrwProvee( oGet ) ) ;
         BITMAP   "LUPA" ;
         OF       oDlg

		REDEFINE GET oGetTxt VAR cGetTxt;
         ID       101 ;
         WHEN     ( .f. ) ;
			OF 		oDlg

      REDEFINE GET oGet2 VAR aTmp[ ( tmpProveedor )->( FieldPos( "cFamPrv" ) ) ];
         ID       110 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( 	nMode != ZOOM_MODE ) ;
         ACTION   (  EndDetalle( aTmp, aGet, tmpProveedor, oBrw, nMode, oDlg, oGet, oGet2 ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| EndDetalle( aTmp, aGet, tmpProveedor, oBrw, nMode, oDlg, oGet, oGet2 ) } )
   end if

   ACTIVATE DIALOG oDlg ON PAINT ( oGet:lValid() ) CENTER

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

STATIC FUNCTION EndDetalle( aTmp, aGet, tmpProveedor, oBrw, nMode, oDlg, oGet, oGet2 )

   if nMode == APPD_MODE

      if empty( aTmp[ ( tmpProveedor )->( FieldPos( "cCodPrv" ) ) ] )
         MsgStop( "Código no puede estar vacío" )
         oGet:SetFocus()
         RETURN nil
      end if

   end if

   if empty( aTmp[ ( tmpProveedor )->( FieldPos( "cFamPrv" ) ) ] )
      MsgStop( "Código de la familia no puede estar vacío" )
      oGet2:SetFocus()
      RETURN nil
   end if

   if dbSeekFamilia( aTmp, tmpProveedor )
      msgStop( "Código de familia existente" )
      RETURN nil
   end if

   WinGather( aTmp, aGet, tmpProveedor, oBrw, nMode )

RETURN ( oDlg:end() )

//---------------------------------------------------------------------------//

STATIC FUNCTION dbSeekFamilia( aTmp, tmpProveedor )

   local lSeek    := .f.
   local nOrdAnt  := ( tmpProveedor )->( OrdSetFocus( "cPrvFam" ) )

   if ( tmpProveedor )->( dbSeek( aTmp[ ( tmpProveedor )->( FieldPos( "cCodPrv" ) ) ] + aTmp[ ( tmpProveedor )->( FieldPos( "cFamPrv" ) ) ] ) )
      lSeek    := .t.
   end if

   ( tmpProveedor )->( OrdSetFocus( nOrdAnt ) )

RETURN ( lSeek )

//---------------------------------------------------------------------------//

FUNCTION EdtFamilia( cCodFam, lOpenBrowse )

   local lEdit          := .f.
   local nLevel         := nLevelUsr( MENUOPTION )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_EDIT ) == 0
      msgStop( 'Acceso no permitido.' )
      RETURN .f.
   end if

   if lOpenBrowse

      if Familia()
         if dbSeekInOrd( cCodFam, "cCodFam", D():Familias( nView ) )
            lEdit       := oWndBrw:RecEdit()
         else
            MsgStop( "No se encuentra familia" )
         end if
      end if

   else

      if !empty( cCodFam )

         if OpenFiles( .t. )
            if dbSeekInOrd( cCodFam, "cCodFam", D():Familias( nView ) )
               lEdit    := WinEdtRec( oWndBrw, bEdit, D():Familias( nView ) )
            else
               MsgStop( "No se encuentra familia" )
            end if
            CloseFiles()
         end if

      end if 

   end if

RETURN ( lEdit )

//--------------------------------------------------------------------------//
//
// Devuelve el presupuesto de la familia
//

FUNCTION nPreFamilia( cCodFam, aMes, lAno, cFamilia )

   local nPreFam  := 0

   if dbSeekInOrd( cCodFam, "cCodFam", cFamilia )

      if lAno

         nPreFam  := ( cFamilia )->NVALANU

      else

         if aMes[ 1]
            nPreFam  += ( cFamilia )->NENE
         end if

         if aMes[ 2]
            nPreFam  += ( cFamilia )->NFEB
         end if

         if aMes[ 3]
            nPreFam  += ( cFamilia )->NMAR
         end if

         if aMes[ 4]
            nPreFam  += ( cFamilia )->NABR
         end if

         if aMes[ 5]
            nPreFam  += ( cFamilia )->NMAY
         end if

         if aMes[ 6]
            nPreFam  += ( cFamilia )->NJUN
         end if

         if aMes[ 7]
            nPreFam  += ( cFamilia )->NJUL
         end if

         if aMes[ 8]
            nPreFam  += ( cFamilia )->NAGO
         end if

         if aMes[ 9]
            nPreFam  += ( cFamilia )->NSEP
         end if

         if aMes[10]
            nPreFam  += ( cFamilia )->NOCT
         end if

         if aMes[11]
            nPreFam  += ( cFamilia )->NNOV
         end if

         if aMes[12]
            nPreFam  += ( cFamilia )->NDIC
         end if

      end if

   end if

RETURN ( nPreFam )

//--------------------------------------------------------------------------//

FUNCTION lFamInTpv( cFamilia )

   local lFamInTpv   := .f.

   ( cFamilia )->( dbgotop() )
   while !( cFamilia )->( eof() )
      if ( cFamilia )->lIncTpv
         lFamInTpv   := .t.
         exit
      end if
      ( cFamilia )->( dbSkip() )
   end while

RETURN ( lFamInTpv )

//---------------------------------------------------------------------------//

STATIC FUNCTION IncEnvio( aTmp )

   local nRec

   for each nRec in ( oWndBrw:oBrw:aSelected )

      ( D():Familias( nView ) )->( dbGoTo( nRec ) )

      if dbLock( D():Familias( nView ) )
         ( D():Familias( nView ) )->lSelDoc := !( D():Familias( nView ) )->lSelDoc
         ( D():Familias( nView ) )->( dbUnLock() )
      end if

   next

   oWndBrw:Refresh()

RETURN ( nil )

//---------------------------------------------------------------------------//

STATIC FUNCTION IncTactil( lIncTactil )

   DEFAULT  lIncTactil  := !( D():Familias( nView ) )->lIncTpv

   if dbLock( D():Familias( nView ) )
      ( D():Familias( nView ) )->lIncTpv := lIncTactil
      ( D():Familias( nView ) )->( dbUnLock() )
      if oWndBrw != nil
         oWndBrw:Refresh()
      end if
   end if

   if apoloMsgNoYes( "¿Desea " + if( lIncTactil, "seleccionar", "deseleccionar" ) +;
                     " todos los artículos de esta familia," + CRLF +;
                     "para que sean " + if( lIncTactil, "incluidos en el", "excluidos del" ) +;
                     " TPV táctil ?",;
                     ( D():Familias( nView ) )->cCodFam + Space( 1 ) + ( D():Familias( nView ) )->cNomFam )

      if ( dbfArticulo )->( dbSeek( ( D():Familias( nView ) )->cCodFam ) )

         while ( dbfArticulo )->Familia == ( D():Familias( nView ) )->cCodFam

            if dbLock( dbfArticulo )
               ( dbfArticulo )->lIncTcl := lIncTactil
               ( dbfArticulo )->( dbUnLock() )
            end if

            ( dbfArticulo )->( dbSkip() )

         end while

      end if

   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

FUNCTION aFamPrp( cCodFam, dbfFami )

   local aPrp     := aFill( Array( 2 ), "" )

   /*
   Buscamos la familia del articulo y anotamos las propiedades--------------
   */

   if ( dbfFami )->( dbSeek( cCodFam ) )
      aPrp[ 1 ]   := ( dbfFami )->CCODPRP1
      aPrp[ 2 ]   := ( dbfFami )->CCODPRP2
   end if

RETURN ( aPrp )

//---------------------------------------------------------------------------//

FUNCTION cCodFam( cCodFam, oDbfFam )

   local cCod     := ""

   if oDbfFam:Seek( cCodFam )
      cCod        := oDbfFam:Familia
   end if

RETURN cCod

//---------------------------------------------------------------------------//

FUNCTION cNomFam( cCodFam, oDbfFam )

   local cNom     := ""

   if oDbfFam:SeekInOrd( cCodFam, "cCodFam" )
      cNom        := oDbfFam:cNomFam
   end if

RETURN ( cNom )

//---------------------------------------------------------------------------//

FUNCTION cCodFamPrv( cCodPrv, cFamPrv, dbfFamPrv )

   local cCodFam  := ""
   local nOrdAnt  := ( dbfFamPrv )->( OrdSetFocus( "cFamPrv" ) )

   if ( dbfFamPrv )->( dbSeek( cCodPrv + cFamPrv ) )
      cCodFam     := ( dbfFamPrv )->cCodFam
   end if

   ( dbfFamPrv )->( OrdSetFocus( nOrdAnt ) )

RETURN ( cCodFam )

//---------------------------------------------------------------------------//

STATIC FUNCTION DeleteFamiliaProveedores()

   local cCodFam        := ( D():Familias( nView ) )->cCodFam

   CursorWait()

   while ( dbfFamPrv )->( dbSeek( cCodFam ) ) .and. !( dbfFamPrv )->( Eof() )
      if( dbLock( dbfFamPrv ), ( ( dbfFamPrv )->( dbDelete() ), ( dbfFamPrv )->( dbUnLock() ) ), )
   end while

   CursorWE()

RETURN ( .t. )

//---------------------------------------------------------------------------//

FUNCTION lPermitirVentaSinValorar( cCodArt, dbfArticulo, cFamilia )

   local lPermitir   := .f.

   if dbSeekInOrd( cCodArt, "Codigo", dbfArticulo )
      if dbSeekInOrd( ( dbfArticulo )->Familia, "cCodFam", cFamilia )
         lPermitir   := ( cFamilia )->lPreEsp
      end if
   end if

RETURN ( lPermitir )

//---------------------------------------------------------------------------//

CLASS TFamiliaSenderReciver FROM TSenderReciverItem

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
   local dbfFam
   local tmpFam
   local lSndFam     := .f.
   local cFileName

   if ::oSender:lServer
      cFileName      := "Fam" + StrZero( ::nGetNumberToSend(), 6 ) + ".All"
   else
      cFileName      := "Fam" + StrZero( ::nGetNumberToSend(), 6 ) + "." + RetSufEmp()
   end if

   ::oSender:SetText( 'Seleccionando familias' )

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatArt() + "Familias.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FAMILIAS", @dbfFam ) )
   SET ADSINDEX TO ( cPatArt() + "Familias.Cdx" ) ADDITIVE

   mkFamilia( cPatSnd() )

   USE ( cPatSnd() + "Familias.Dbf" ) NEW VIA ( cLocalDriver() ) SHARED ALIAS ( cCheckArea( "FAMILIAS", @tmpFam ) )
   SET ADSINDEX TO ( cPatSnd() + "Familias.Cdx" ) ADDITIVE

   if !empty( ::oSender:oMtr )
      ::oSender:oMtr:nTotal := ( dbfFam )->( lastrec() )
   end if

   while !( dbfFam )->( eof() )

      if ( dbfFam )->lSelDoc
         ::oSender:SetText( AllTrim( ( dbfFam )->cCodFam ) + "; " + AllTrim( ( dbfFam )->cNomFam ) )
         lSndFam  := .t.
         dbPass( dbfFam, tmpFam, .t. )
      end if

      ( dbfFam )->( dbSkip() )

      if !empty( ::oSender:oMtr )
         ::oSender:oMtr:Set( ( dbfFam )->( OrdKeyNo() ) )
      end if

      SysRefresh()

   end while

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE ( dbfFam  )
   CLOSE ( tmpFam  )

   if lSndFam

      ::oSender:SetText( "Comprimiendo familias" )

      if ::oSender:lZipData( cFileName )
         ::oSender:SetText( "Ficheros comprimidos" )
      else
         ::oSender:SetText( "ERROR al crear fichero comprimido" )
      end if

   else

      ::oSender:SetText( "No hay familias para enviar" )

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

Method RestoreData()

   local oBlock
   local oError
   local cFamilia

   if ::lSuccesfullSend

      /*
      Sintuacion despues del envio---------------------------------------------
      */

      oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
      BEGIN SEQUENCE

      USE ( cPatArt() + "Familias.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FAMILIAS", @cFamilia ) )
      SET ADSINDEX TO ( cPatArt() + "Familias.Cdx" ) ADDITIVE

      while !( cFamilia )->( eof() )
         if ( cFamilia )->lSelDoc .and. ( cFamilia )->( dbRLock() )
            ( cFamilia )->lSelDoc := .f.
            ( cFamilia )->( dbRUnlock() )
         end if
         ( cFamilia )->( dbSkip() )
      end do

      RECOVER USING oError

         msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

      END SEQUENCE

      ErrorBlock( oBlock )

      CLOSE ( cFamilia  )

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

Method SendData()

   local cFileName

   if ::oSender:lServer
      cFileName      := "Fam" + StrZero( ::nGetNumberToSend(), 6 ) + ".All"
   else
      cFileName      := "Fam" + StrZero( ::nGetNumberToSend(), 6 ) + "." + RetSufEmp()
   end if

   if File( cPatOut() + cFileName )

      if ::oSender:SendFiles( cPatOut() + cFileName, cFileName )
         ::IncNumberToSend()
         ::lSuccesfullSend := .t.
         ::oSender:SetText( "Ficheros de familias enviados " + cFileName )
      else
         ::oSender:SetText( "ERROR fichero de familias no enviado" )
      end if

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

Method ReciveData()

   local n
   local aExt

   if ::oSender:lServer
      aExt              := aRetDlgEmp()
   else
      aExt              := { "All" }
   end if

   ::oSender:SetText( "Recibiendo familias" )

   for n := 1 to len( aExt )
      if IsChar( aExt[ n ] )
         ::oSender:GetFiles( "Fam*." + aExt[ n ], cPatIn() )
      end if
   next

   ::oSender:SetText( "Familias recibidas" )

RETURN ( Self )

//---------------------------------------------------------------------------//

Method Process()

   local m
   local aFiles
   local tmpFam
   local dbfFam
   local oBlock
   local oError

   /*
   Procesamos los ficheros recibidos de familias
   */

   aFiles                     := Directory( cPatIn() + "Fam*.*" )

   for m := 1 to len( aFiles )

      ::oSender:SetText( "Procesando fichero : " + aFiles[ m, 1 ] )

      oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
      BEGIN SEQUENCE

         /*
         Descomprimimos el fichero recibido------------------------------------
         */

         if ::oSender:lUnZipData( cPatIn() + aFiles[ m, 1 ] )

            if file( cPatSnd() + "Familias.Dbf" )

               USE ( cPatSnd() + "Familias.Dbf" ) NEW VIA ( cLocalDriver() ) SHARED ALIAS ( cCheckArea( "FAMILIAS", @tmpFam ) )
               SET ADSINDEX TO ( cPatSnd() + "Familias.Cdx" ) ADDITIVE

               USE ( cPatArt() + "Familias.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FAMILIAS", @dbfFam ) )
               SET ADSINDEX TO ( cPatArt() + "Familias.Cdx" ) ADDITIVE

               if !empty( ::oSender:oMtr )
                  ::oSender:oMtr:nTotal := ( tmpFam )->( lastrec() )
               end if

               ( tmpFam )->( ordsetfocus( 0 ) )
               ( tmpFam )->( dbgotop() )

               while !( tmpFam )->( eof() )

                  if ( dbfFam )->( dbSeek( ( tmpFam )->cCodFam ) )

                     if !::oSender:lServer
                        
                        dbPass( tmpFam, dbfFam )
                        
                        if dbLock( dbfFam )
                           ( dbfFam )->lSelDoc := .f.
                           ( dbfFam )->( dbUnLock() )
                        end if

                        ::oSender:SetText( "Reemplazado : " + AllTrim( ( dbfFam )->cCodFam ) + "; " + AllTrim( ( dbfFam )->cNomFam ) )
                     
                     else

                        ::oSender:SetText( "Desestimado : " + AllTrim( ( dbfFam )->cCodFam ) + "; " + AllTrim( ( dbfFam )->cNomFam ) )

                     end if

                  else

                        dbPass( tmpFam, dbfFam, .t. )
                        
                        if dbLock( dbfFam )
                           ( dbfFam )->lSelDoc := .f.
                           ( dbfFam )->( dbUnLock() )
                        end if

                        ::oSender:SetText( "Añadido     : " + AllTrim( ( dbfFam )->cCodFam ) + "; " + AllTrim( ( dbfFam )->cNomFam ) )

                  end if

                  ( tmpFam )->( dbSkip() )

                  if !empty( ::oSender:oMtr )
                     ::oSender:oMtr:Set( ( tmpFam )->( OrdKeyNo() ) )
                  end if

                  SysRefresh()

               end while

               if !empty( ::oSender:oMtr )
                  ::oSender:oMtr:nTotal := ( tmpFam )->( LastRec() )
               end if

               CLOSE ( tmpFam )
               CLOSE ( dbfFam )

               ::oSender:AppendFileRecive( aFiles[ m, 1 ] )

            end if

         end if

      RECOVER USING oError

         CLOSE ( tmpFam )
         CLOSE ( dbfFam )

         ::oSender:SetText( "Error procesando fichero " + aFiles[ m, 1 ] )
         ::oSender:SetText( ErrorMessage( oError ) )

      END SEQUENCE

      ErrorBlock( oBlock )

   next

RETURN ( Self )

//---------------------------------------------------------------------------//

STATIC FUNCTION lSelFam( lSel, oBrw, dbf )

   DEFAULT lSel         := !( dbf )->lSelDoc

   if dbLock( dbf )
      ( dbf )->lSelDoc  := lSel
      ( dbf )->( dbUnlock() )
   end if

   if oBrw != nil
      oBrw:Refresh()
      oBrw:SetFocus()
   end if

RETURN NIL

//---------------------------------------------------------------------------//

FUNCTION SetHeadDiv( lEur, oWndBrw, cChrSea )

   local n

   DEFAULT  cChrSea  := "Precio"

   for n := 1 to len( oWndBrw:oBrw:aHeaders )

      if cChrSea $ oWndBrw:oBrw:aHeaders[ n ]
         if lEur
            oWndBrw:oBrw:aHeaders[ n ] := SubStr( oWndBrw:oBrw:aHeaders[ n ], 1, len( oWndBrw:oBrw:aHeaders[ n ] ) - 4 ) + Space( 1 ) + cDivChg()
         else
            oWndBrw:oBrw:aHeaders[ n ] := SubStr( oWndBrw:oBrw:aHeaders[ n ], 1, len( oWndBrw:oBrw:aHeaders[ n ] ) - 4 ) + Space( 1 ) + cDivEmp()
         end if
      end if
   next

   oWndBrw:Refresh()
   oWndBrw:SetFocus()

RETURN nil

//---------------------------------------------------------------------------//

CLASS TListadoFamilias FROM TInfGen

   METHOD Create()

   METHod lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "CCODFAM",    "C",  16, 0, {|| "" },    "Código",                 .t., "Código de familia",                   16, .f. )
   ::AddField( "CNOMFAM",    "C",  40, 0, {|| "" },    "Nombre",                 .t., "Nombre de familia",                   40, .f. )
   ::AddField( "CCODPRP1",   "C",  10, 0, {|| "" },    "Prp1",                   .f., "Primera propiedad de la familia",      5, .f. )
   ::AddField( "CCODPRP2",   "C",  10, 0, {|| "" },    "Prp2",                   .f., "Segunda propiedad de la familia",      5, .f. )
   ::AddField( "CCODGRP",    "C",   3, 0, {|| "" },    "Cod. grupo",             .t., "Código de grupo",                      5, .f. )
   ::AddField( "NVALANU",    "N",  16, 6, {|| "" },    "Anual",                  .t., "Previsiones anual",                   20, .f. )
   ::AddField( "NENE",       "N",  16, 6, {|| "" },    "Enero",                  .f., "Previsiones Enero",                   20, .f. )
   ::AddField( "NFEB",       "N",  16, 6, {|| "" },    "Febrero",                .f., "Previsiones Febrero",                 20, .f. )
   ::AddField( "NMAR",       "N",  16, 6, {|| "" },    "Marzo",                  .f., "Previsiones Marzo",                   20, .f. )
   ::AddField( "NABR",       "N",  16, 6, {|| "" },    "Abril",                  .f., "Previsiones Abril",                   20, .f. )
   ::AddField( "NMAY",       "N",  16, 6, {|| "" },    "Mayo",                   .f., "Previsiones Mayo",                    20, .f. )
   ::AddField( "NJUN",       "N",  16, 6, {|| "" },    "Junio",                  .f., "Previsiones Junio",                   20, .f. )
   ::AddField( "NJUL",       "N",  16, 6, {|| "" },    "Julio",                  .f., "Previsiones Julio",                   20, .f. )
   ::AddField( "NAGO",       "N",  16, 6, {|| "" },    "Agosto",                 .f., "Previsiones Agosto",                  20, .f. )
   ::AddField( "NSEP",       "N",  16, 6, {|| "" },    "Septiembre",             .f., "Previsiones Septiembre",              20, .f. )
   ::AddField( "NOCT",       "N",  16, 6, {|| "" },    "Octubre",                .f., "Previsiones Octubre",                 20, .f. )
   ::AddField( "NNOV",       "N",  16, 6, {|| "" },    "Noviembre",              .f., "Previsiones Noviembre",               20, .f. )
   ::AddField( "NDIC",       "N",  16, 6, {|| "" },    "Diciembre",              .f., "Previsiones Diciembre",               20, .f. )
   ::AddField( "NPCTRPL",    "N",   6, 2, {|| "" },    "Rapels",                 .f., "Porcentaje de rapels",                10, .f. )

   ::lDefFecInf   := .f.
   ::lDefSerInf   := .f.
   ::lDefDivInf   := .f.

RETURN ( Self )

//---------------------------------------------------------------------------//

METHod lResource( cFld )

   if !::StdResource( "INF_FAM01" )
      RETURN .f.
   end if

   ::lDefFamInf( 110, 120, 130, 140, 600 )

   ::CreateFilter( aItmFam(), ::oDbfFam )

   ::oMtrInf:SetTotal( ::oDbfFam:Lastrec() )

RETURN ( .t. )

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cExpHead := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha    : " + Dtoc( Date() ) },;
                        {|| "Familias : " + if( ::lAllFam, "Todas", AllTrim( ::cFamOrg ) + " > " + AllTrim( ::cFamDes ) ) } }

   if !empty( ::oFilter:cExpresionFilter )
      cExpHead       := ::oFilter:cExpresionFilter
   else
      cExpHead       := '.t.'
   end if

   ::oDbfFam:OrdSetFocus( "cCodFam" )
   ::oDbfFam:GoTop()

   while !::lBreak .and. !::oDbfFam:Eof()

      if ::oDbfFam:cCodFam >= ::cFamOrg                      .and.;
         ::oDbfFam:cCodFam <= ::cFamDes                      .and.;
         ::EvalFilter()

         ::oDbf:Append()

         ::oDbf:cCodFam     := ::oDbfFam:cCodFam
         ::oDbf:cNomFam     := ::oDbfFam:cNomFam
         ::oDbf:cCodPrp1    := ::oDbfFam:cCodPrp1
         ::oDbf:cCodPrp2    := ::oDbfFam:cCodPrp2
         ::oDbf:cCodGrp     := ::oDbfFam:cCodGrp
         ::oDbf:nValAnu     := ::oDbfFam:nValAnu
         ::oDbf:nEne        := ::oDbfFam:nEne
         ::oDbf:nFeb        := ::oDbfFam:nFeb
         ::oDbf:nMar        := ::oDbfFam:nMar
         ::oDbf:nAbr        := ::oDbfFam:nAbr
         ::oDbf:nMay        := ::oDbfFam:nMay
         ::oDbf:nJun        := ::oDbfFam:nJun
         ::oDbf:nJul        := ::oDbfFam:nJul
         ::oDbf:nAgo        := ::oDbfFam:nAgo
         ::oDbf:nSep        := ::oDbfFam:nSep
         ::oDbf:nOct        := ::oDbfFam:nOct
         ::oDbf:nNov        := ::oDbfFam:nNov
         ::oDbf:nDic        := ::oDbfFam:nDic
         ::oDbf:nPctRpl     := ::oDbfFam:nPctRpl

         ::oDbf:Save()

      end if

      ::oDbfFam:Skip()

      ::oMtrInf:AutoInc( ::oDbfFam:OrdKeyNo() )

   END DO

   ::oMtrInf:AutoInc( ::oDbfFam:LastRec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

FUNCTION mkFamilia( cPath, lAppend, cPathOld )

	local cFamilia

	DEFAULT lAppend := .f.
   DEFAULT cPath   := cPatArt()

   if lExistTable( cPath + "Familias.Dbf", cLocalDriver() )
      fEraseTable( cPath + "Familias.dbf" )
   end if

   if lExistTable( cPath + "FamPrv.Dbf", cLocalDriver() )
      fEraseTable( cPath + "FamPrv.Dbf" )
   end if

   if lExistTable( cPath + "FamLeng.Dbf", cLocalDriver() )
      fEraseTable( cPath + "FamLeng.Dbf" )
   end if

   dbCreate( cPath + "Familias.Dbf", aSqlStruct( aItmFam() ), cLocalDriver() )

   if lAppend .and. cPathOld != nil .and. lIsDir( cPathOld )
      dbUseArea( .t., cDriver(), cPath + "Familias.Dbf", cCheckArea( "Familias", @cFamilia ), .f. )
      if !( cFamilia )->( neterr() )
         ( cFamilia )->( __dbApp( cPathOld + "Familias.Dbf" ) )
         ( cFamilia )->( dbCloseArea() )
      end if
   end if

   dbCreate( cPath + "FamPrv.Dbf", aSqlStruct( aItmFamPrv() ), cLocalDriver() )

   if lAppend .and. cPathOld != nil .and. lIsDir( cPathOld )
      dbUseArea( .t., cDriver(), cPath + "FamPrv.Dbf", cCheckArea( "FamPrv", @cFamilia ), .f. )
      if !( cFamilia )->( neterr() )
         ( cFamilia )->( __dbApp( cPathOld + "FamPrv.Dbf" ) )
         ( cFamilia )->( dbCloseArea() )
      end if
   end if

   dbCreate( cPath + "FamLeng.Dbf", aSqlStruct( aItmFamiliaLenguajes() ), cLocalDriver() )

   if lAppend .and. cPathOld != nil .and. lIsDir( cPathOld )
      dbUseArea( .t., cDriver(), cPath + "FamLeng.Dbf", cCheckArea( "FamLeng", @cFamilia ), .f. )
      if !( cFamilia )->( neterr() )
         ( cFamilia )->( __dbApp( cPathOld + "FamLeng.Dbf" ) )
         ( cFamilia )->( dbCloseArea() )
      end if
   end if

   rxFamilia( cPath, cLocalDriver() )

RETURN .t.

//--------------------------------------------------------------------------//

FUNCTION rxFamilia( cPath, cDriver )

	local cFamilia

   DEFAULT cPath     := cPatArt()
   DEFAULT cDriver   := cDriver()

   if !lExistTable( cPath + "Familias.Dbf", cDriver )
      dbCreate( cPath + "Familias.Dbf", aSqlStruct( aItmFam() ), cDriver )
   end if

   fEraseIndex(  cPath + "Familias.Cdx" )

   if !lExistTable( cPath + "FamPrv.Dbf", cDriver )
      dbCreate( cPath + "FamPrv.Dbf", aSqlStruct( aItmFamPrv() ), cDriver )
   end if

   fEraseIndex(  cPath + "FamPrv.Cdx" )

   if !lExistTable( cPath + "FamLeng.Dbf", cDriver )
      dbCreate( cPath + "FamLeng.Dbf", aSqlStruct( aItmFamiliaLenguajes() ), cDriver )
   end if

   fEraseIndex(  cPath + "FamLeng.Cdx" )

   dbUseArea( .t., cDriver, cPath + "Familias.Dbf", cCheckArea( "FAMILIAS", @cFamilia ), .f. )
   if !( cFamilia )->( neterr() )
      ( cFamilia )->( __dbPack() )

      ( cFamilia )->( ordcondset( "!Deleted()", {|| !Deleted() } ) )
      ( cFamilia )->( ordcreate( cPath + "Familias.Cdx", "cCodFam", "Field->cCodFam", {|| Field->cCodFam }, ) )

      ( cFamilia )->( ordcondset( "!Deleted()", {|| !Deleted() } ) )
      ( cFamilia )->( ordcreate( cPath + "Familias.Cdx", "cNomFam", "Upper( Field->cNomFam )", {|| Upper( Field->cNomFam ) } ) )

      ( cFamilia )->( ordcondset("!Deleted().and. lIncTpv", {|| !Deleted() .and. Field->lIncTpv } ) )
      ( cFamilia )->( ordcreate( cPath + "Familias.Cdx", "nPosTpv", "Str( Field->nPosTpv )", {|| Str( Field->nPosTpv ) } ) )

      ( cFamilia )->( ordcondset("!Deleted() .and. lIncTpv", {|| !Deleted() .and. Field->lIncTpv }  ) )
      ( cFamilia )->( ordcreate( cPath + "Familias.Cdx", "lIncTpv", "Upper( cNomFam )", {|| Upper( Field->cNomFam ) } ) )

      ( cFamilia )->( ordcondset( "!Deleted()", {|| !Deleted() } ) )
      ( cFamilia )->( ordcreate( cPath + "Familias.Cdx", "lSelDoc", "lSelDoc", {|| Field->lSelDoc } ) )

      ( cFamilia )->( ordcondset( "!Deleted()", {|| !Deleted() } ) )
      ( cFamilia )->( ordcreate( cPath + "Familias.Cdx", "cType", "cType", {|| Field->cType } ) )

      ( cFamilia )->( ordcondset( "!Deleted()", {|| !Deleted() } ) )
      ( cFamilia )->( ordcreate( cPath + "Familias.Cdx", "cFamCmb", "cFamCmb", {|| Field->cFamCmb } ) )

      ( cFamilia )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de familias" )
   end if

   dbUseArea( .t., cDriver, cPath + "FamPrv.Dbf", cCheckArea( "FAMPRV", @cFamilia ), .f. )
   if !( cFamilia )->( neterr() )
      ( cFamilia )->( __dbPack() )

      ( cFamilia )->( ordcondset( "!Deleted()", {||!Deleted()}  ) )
      ( cFamilia )->( ordcreate( cPath + "FamPrv.Cdx", "cCodFam", "cCodFam", {|| Field->cCodFam }, ) )

      ( cFamilia )->( ordcondset( "!Deleted()", {||!Deleted()}  ) )
      ( cFamilia )->( ordcreate( cPath + "FamPrv.Cdx", "cFamPrv", "cCodPrv + cFamPrv", {|| Field->cCodPrv + Field->cFamPrv } ) )

      ( cFamilia )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de familias" )
   end if

   dbUseArea( .t., cDriver, cPath + "FamLeng.Dbf", cCheckArea( "FamLeng", @cFamilia ), .f. )
   if !( cFamilia )->( neterr() )
      ( cFamilia )->( __dbPack() )

      ( cFamilia )->( ordcondset( "!Deleted()", {||!Deleted()}  ) )
      ( cFamilia )->( ordcreate( cPath + "FamLeng.Cdx", "cCodFam", "cCodFam", {|| Field->cCodFam }, ) )

      ( cFamilia )->( ordcondset( "!Deleted()", {||!Deleted()}  ) )
      ( cFamilia )->( ordcreate( cPath + "FamLeng.Cdx", "cCodLen", "cCodFam + cCodLen", {|| Field->cCodFam + Field->cCodLen } ) )


      ( cFamilia )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de lenguajes de familias" )
   end if

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION aItmFamPrv()

   local aBase := {  {"CCODFAM",    "C",    16,    0, "Código de familia" },;
                     {"CCODPRV",    "C",    12,    0, "Código de proveedor" },;
                     {"CFAMPRV",    "C",    20,    0, "Código de familia del proveedor" } }

RETURN ( aBase )

//---------------------------------------------------------------------------//

FUNCTION aItmFam()

   local aBase := {  {"cCodFam",    "C",    16,    0, "Código de familia" },;
                     {"cNomFam",    "C",    40,    0, "Nombre de familia" },;
                     {"cCodPrp1",   "C",    10,    0, "Primera propiedad de la familia" },;
                     {"cCodPrp2",   "C",    10,    0, "Segunda propiedad de la familia" },;
                     {"cCodGrp",    "C",     3,    0, "Código de grupo" },;
                     {"lIncTpv",    "L",     1,    0, "Incluir en TPV táctil" },;
                     {"nValAnu",    "N",    16,    6, "Previsiones anual" },;
                     {"nEne",       "N",    16,    6, "Previsiones Enero" },;
                     {"nFeb",       "N",    16,    6, "Previsiones Febrero" },;
                     {"nMar",       "N",    16,    6, "Previsiones Marzo" },;
                     {"nAbr",       "N",    16,    6, "Previsiones Abril" },;
                     {"nMay",       "N",    16,    6, "Previsiones Mayo" },;
                     {"nJun",       "N",    16,    6, "Previsiones Junio" },;
                     {"nJul",       "N",    16,    6, "Previsiones Julio" },;
                     {"nAgo",       "N",    16,    6, "Previsiones Agosto" },;
                     {"nSep",       "N",    16,    6, "Previsiones Septiembre" },;
                     {"nOct",       "N",    16,    6, "Previsiones Octubre" },;
                     {"nNov",       "N",    16,    6, "Previsiones Noviembre" },;
                     {"nDic",       "N",    16,    6, "Previsiones Diciembre" },;
                     {"nDtoLin",    "N",     6,    2, "Porcentaje de descuento por familia" },;
                     {"nPctRpl",    "N",     6,    2, "Porcentaje de rapels" },;
                     {"lPubInt",    "L",     1,    0, "Publicar esta familia en internet" },;
                     {"nColBtn",    "N",    10,    0, "Color del botón" },;
                     {"cImgBtn",    "C",   250,    0, "Imagen del botón" },;
                     {"lSelDoc",    "L",     1,    0, "Lógico para seleccionado" },;
                     {"lPreEsp",    "L",     1,    0, "Lógico para permitir precios especiales" },;
                     {"cCodFra",    "C",     3,    0, "Código de frases publiciarias" },;
                     {"cType",      "C",     6,    0, "Tipo especial de familia" },;
                     {"cFamCmb",    "C",    16,    0, "Familia para combinar" },;
                     {"nPosTpv",    "N",     4,    1, "Posición para mostrar en TPV" },;
                     {"cCodWeb",    "N",    11,    0, "Código para la web" },;
                     {"lAcum",      "L",     1,    0, "Lógico para acumular árticulos" },;
                     {"lMostrar",   "L",     1,    0, "Lógico para mostrar ventana de comentarios" },;
                     {"cCodImp",    "C",     3,    0, "Codigo del orden de impresion comanda" },;
                     {"cNomImp",    "C",    50,    0, "Nombre del orden de impresion comanda" },;
                     {"nPosInt",    "N",     3,    0, "Posición para mostrar en internet" },;
                     {"lFamInt",    "L",     1,    0, "Añade la familia junto con la descripción en internet" },;
                     {"cComFam",    "C",     3,    0, "Comentario por defecto para la familia" },;
                     {"cDesWeb",    "C",   250,    0, "Descripción para la web" },;
                     {"nDiaGrt",    "N",     6,    0, "Días de garantía" },;
                     {"mLngDes",    "M",    10,    0, "Descripción extendida" } }

RETURN ( aBase )

//---------------------------------------------------------------------------//

FUNCTION aItmFamiliaLenguajes()

   local aBase := {}

   aAdd( aBase, { "cCodFam",   "C",    16,  0, "Código de la familia" } )
   aAdd( aBase, { "cCodLen",   "C",     4,  0, "Código del lenguaje" } )
   aAdd( aBase, { "cDesFam",   "C",   200,  0, "Descripción familia" } )
   aAdd( aBase, { "mLngDes",   "M",    10,  0, "Descripción extendida" } )

RETURN ( aBase )

//---------------------------------------------------------------------------//

FUNCTION lPressCol( nCol, oBrw, oCmbOrd, aCbxOrd, cDbf )

   local nPos
   local cHeader

   if !empty( nCol ) .and. nCol <= len( oBrw:aHeaders )

      cHeader     := oBrw:aHeaders[ nCol ]
      nPos        := aScan( aCbxOrd, cHeader )

      if nPos != 0

         oCmbOrd:Set( cHeader )

         ( cDbf )->( OrdSetFocus( oCmbOrd:nAt ) )

         oBrw:Refresh()

      end if

   end if

RETURN nil

//---------------------------------------------------------------------------//

FUNCTION nDescuentoFamilia( cCodFam, oDbfFam )

   local nDescuentoFamilia := 0

   if ValType( oDbfFam ) == "O"
      if oDbfFam:SeekInOrd( cCodFam, "cCodFam" )
         nDescuentoFamilia := oDbfFam:nDtoLin
      end if
   else
      if dbSeekInOrd( cCodFam, "cCodFam", oDbfFam )
         nDescuentoFamilia := ( oDbfFam )->nDtoLin
      end if
   end if

RETURN ( nDescuentoFamilia )

//---------------------------------------------------------------------------//

FUNCTION cCodFra( cCodFam, oDbfFam )

   local cCodFra  := ""

   if ValType( oDbfFam ) == "O"
      if oDbfFam:SeekInOrd( cCodFam, "cCodFam" )
         cCodFra  := oDbfFam:cCodFra
      end if
   else
      if dbSeekInOrd( cCodFam, "cCodFam", oDbfFam )
         cCodFra  := ( oDbfFam )->cCodFra
      end if
   end if

RETURN ( cCodFra )

//---------------------------------------------------------------------------//

STATIC FUNCTION lValidFamiliaCombinado( aTmp )

   local lValid   := .t.

   if !empty( aTmp[ _CCODFAM ] ) .and. !empty( aTmp[ _CFAMCMB ] ) .and. ( aTmp[ _CCODFAM ] == aTmp[ _CFAMCMB ] )

      lValid      := .f.

      MsgStop( "Código de familia no puede ser igual al combinado" )

   end if

RETURN ( lValid )

//---------------------------------------------------------------------------//

FUNCTION retFamilia( cCodFam, uFamilia )

   local oBlock
   local oError
   local lClose   := .f.
	local cTemp		:= Space( 30 )

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if empty( uFamilia )
      USE ( cPatArt() + "FAMILIAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FAMILIAS", @uFamilia ) )
      SET ADSINDEX TO ( cPatArt() + "Familias.Cdx" ) ADDITIVE
      lClose      := .t.
   end if

   do case
   case ValType( uFamilia ) == "C"

      if ( uFamilia )->( dbSeek( cCodFam ) )
         cTemp    := ( uFamilia )->cNomFam
      end if

   case ValType( uFamilia ) == "O"

      if uFamilia:Seek( cCodFam )
         cTemp    := uFamilia:cNomFam
      end if

   end case

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if lClose
      CLOSE ( uFamilia )
   end if

RETURN cTemp

//---------------------------------------------------------------------------//

FUNCTION cFamilia( oGet, cFamilia, oGet2, lMessage, oGetPrp1, oGetPrp2 )

   local nRec
   local oBlock
   local oError
   local lValid      := .f.
   local lClose      := .f.
   local xValor      := oGet:varGet()

   DEFAULT lMessage  := .t.

   if empty( xValor ) .or. ( xValor == Replicate( "Z", 16 ) )
      RETURN .t.
   end if

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if empty( cFamilia )
      USE ( cPatArt() + "FAMILIAS.DBF" ) NEW VIA ( cDriver() ) SHARED   ALIAS ( cCheckArea( "FAMILIAS", @cFamilia ) )
      SET ADSINDEX TO ( cPatArt() + "Familias.Cdx" ) ADDITIVE
      lClose         := .t.
   else
      nRec           := ( cFamilia )->( Recno() )
   end if

   if dbSeekInOrd( xValor, "cCodFam", cFamilia )

      if !empty( oGet )
         oGet:cText( ( cFamilia )->cCodFam )
      end if

      if !empty( oGet2 )
         oGet2:cText( ( cFamilia )->cNomFam )
      end if

      if !empty( oGetPrp1 ) .and. empty( oGetPrp1:VarGet() )
         oGetPrp1:cText( ( cFamilia )->cCodPrp1 )
         oGetPrp1:lValid()
      end if

      if !empty( oGetPrp2 ) .and. empty( oGetPrp2:VarGet() )
         oGetPrp2:cText( ( cFamilia )->cCodPrp2 )
         oGetPrp2:lValid()
      end if

      lValid         := .t.

	ELSE

      if lMessage
         msgStop( "Familia no encontrada", "Aviso del sistema" )
      end if

	END IF

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if lClose
      CLOSE ( cFamilia )
   else
      ( cFamilia )->( dbGoTo( nRec ) )
   end if

RETURN lValid

//---------------------------------------------------------------------------//

STATIC FUNCTION ChangePosition( lInc )

   local aPos
   local nPos     := 1
   local aRec     := {}
   local nRec     := ( D():Familias( nView ) )->( Recno() )
   local nOrd     := ( D():Familias( nView ) )->( OrdSetFocus( "nPosTpv" ) )

   CursorWait()

   do case
      case IsTrue( lInc )

         if ( D():Familias( nView ) )->( dbRLock() )
            ( D():Familias( nView ) )->nPosTpv   := ( D():Familias( nView ) )->nPosTpv + 1.5
         end if
         ( D():Familias( nView ) )->( dbUnLock() )

      case IsFalse( lInc )

         if ( D():Familias( nView ) )->( dbRLock() )
            ( D():Familias( nView ) )->nPosTpv   := ( D():Familias( nView ) )->nPosTpv - 1.5
         end if
         ( D():Familias( nView ) )->( dbUnLock() )

   end case

   //--------------------------------------------------------------------------

   ( D():Familias( nView ) )->( dbgotop() )
   while !( D():Familias( nView ) )->( eof() )

      if ( D():Familias( nView ) )->lIncTpv
         aAdd( aRec, { ( D():Familias( nView ) )->( Recno() ), nPos++ } )
      end if

      ( D():Familias( nView ) )->( dbSkip() )

   end while

   //--------------------------------------------------------------------------

   for each aPos in aRec

      ( D():Familias( nView ) )->( dbGoTo( aPos[ 1 ] ) )

      if ( D():Familias( nView ) )->( dbRLock() )
         ( D():Familias( nView ) )->nPosTpv      := aPos[ 2 ]
         ( D():Familias( nView ) )->( dbUnLock() )
      end if

   next

   //--------------------------------------------------------------------------

   CursorWE()

   ( D():Familias( nView ) )->( dbGoTo( nRec ) )
   ( D():Familias( nView ) )->( OrdSetFocus( nOrd ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

FUNCTION ColorFam( oGetColor )

   local oDlg
   local oBmpGeneral
   local oImgColores

   DEFINE DIALOG oDlg RESOURCE "COLORFAM"

      oImgColores             := C5ImageView():Redefine( 200, oDlg )
      oImgColores:nWItem      := 131
      oImgColores:nHItem      := 75
      oImgColores:lVScroll    := .f.
      oImgColores:nAlignText  := nOr( DT_TOP, DT_CENTER )
      oImgColores:lTitle      := .t.
      oImgColores:nHTitle     := 12
      oImgColores:lShowOption := .t.
      oImgColores:aTextMargin := { 0, 0, 0, 0 }
      oImgColores:nClrTextSel := Rgb( 0, 0, 0 )
      oImgColores:bAction     := {|| SeleccionaColor( oImgColores, oGetColor, oDlg ) }

      oImgColores:nOption     := 0

      aAdd( oImgColores:aItems, C5ImageViewItem():New( , "Amarillo pastel",   Rgb( 255, 255, 149 ) ) )
      aAdd( oImgColores:aItems, C5ImageViewItem():New( , "Amarillo señales",  Rgb( 255, 204,   0 ) ) )
      aAdd( oImgColores:aItems, C5ImageViewItem():New( , "Amarillo miel",     Rgb( 201, 135,  33 ) ) )
      aAdd( oImgColores:aItems, C5ImageViewItem():New( , "Amarillo ocre",     Rgb( 196, 181, 134 ) ) )
      aAdd( oImgColores:aItems, C5ImageViewItem():New( , "Pardo verdoso",     Rgb( 143, 141,  97 ) ) )
      aAdd( oImgColores:aItems, C5ImageViewItem():New( , "Rosa lavanda",      Rgb( 235, 205, 245 ) ) )
      aAdd( oImgColores:aItems, C5ImageViewItem():New( , "Rosa claro",        Rgb( 232, 156, 181 ) ) )
      aAdd( oImgColores:aItems, C5ImageViewItem():New( , "Violeta pastel",    Rgb( 172, 134, 164 ) ) )
      aAdd( oImgColores:aItems, C5ImageViewItem():New( , "Biscuit",           Rgb( 249, 228, 202 ) ) )
      aAdd( oImgColores:aItems, C5ImageViewItem():New( , "Rojo beige",        Rgb( 204, 130, 115 ) ) )
      aAdd( oImgColores:aItems, C5ImageViewItem():New( , "Rojo anaranjado",   Rgb( 224,  94,  31 ) ) )
      aAdd( oImgColores:aItems, C5ImageViewItem():New( , "Verde amarillento", Rgb( 165, 226, 135 ) ) )
      aAdd( oImgColores:aItems, C5ImageViewItem():New( , "Verde mayo",        Rgb(  88, 186,  78 ) ) )
      aAdd( oImgColores:aItems, C5ImageViewItem():New( , "Verde oliva",       Rgb(  69, 182, 159 ) ) )
      aAdd( oImgColores:aItems, C5ImageViewItem():New( , "Cian",              Rgb( 180, 243, 243 ) ) )
      aAdd( oImgColores:aItems, C5ImageViewItem():New( , "Azul pastel",       Rgb( 196, 215, 225 ) ) )
      aAdd( oImgColores:aItems, C5ImageViewItem():New( , "Azul luminoso",     Rgb(  50, 134, 209 ) ) )
      aAdd( oImgColores:aItems, C5ImageViewItem():New( , "Gris ceniza",       Rgb( 226, 224, 228 ) ) )
      aAdd( oImgColores:aItems, C5ImageViewItem():New( , "Aluminio blanco",   Rgb( 172, 172, 181 ) ) )
      aAdd( oImgColores:aItems, C5ImageViewItem():New( , "Gris piedra",       Rgb( 145, 145, 135 ) ) )

      REDEFINE BITMAP oBmpGeneral ;
        ID       500 ;
        RESOURCE "gc_photographic_filters_48" ;
        TRANSPARENT ;
        OF       oDlg

     REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         ACTION   ( oDlg:End() )

   ACTIVATE DIALOG oDlg CENTER

RETURN .t.

//---------------------------------------------------------------------------//

FUNCTION SeleccionaColor( oImgColores, oGetColor, oDlg )

   local nOpt  := oImgColores:nOption

   if empty( nOpt )
      MsgStop( "Seleccione un color" )
      RETURN .f.
   end if

   nOpt        := Max( Min( nOpt, len( oImgColores:aItems ) ), 1 )

   if nOpt > 0 .and. nOpt <= len( oImgColores:aItems )
      oGetColor:cText( oImgColores:aItems[ nOpt ]:nClrPane )
      oGetColor:SetColor( oImgColores:aItems[ nOpt ]:nClrPane, oImgColores:aItems[ nOpt ]:nClrPane )
    end if

   oDlg:End()

RETURN .t.

//---------------------------------------------------------------------------//

FUNCTION AppFamilia( lOpenBrowse )

   local oBlock
   local oError
   local nLevel         := nLevelUsr( MENUOPTION )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_APPD ) == 0
      msgStop( 'Acceso no permitido.' )
      RETURN .t.
   end if

   oBlock               := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if lOpenBrowse

         if Familia()
            oWndBrw:RecAdd()
         end if

      else

         if OpenFiles( .t. )
            WinAppRec( oWndBrw, bEdit, D():Familias( nView ) )
            CloseFiles()
         end if

      end if

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Error añadiendo artículo" )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN .t.

//--------------------------------------------------------------------------//
/*
Browse de familias para las familias combinadas para que haga el closefiles
*/

FUNCTION BrwFamiliaCombinada( oGet, cFamilia, oGet2 )

   local oDlg
   local oBrw
   local nRec
   local oGet1
   local cGet1
   local nOrd     := GetBrwOpt( "BrwFamilia" )
   local oCbxOrd
   local aCbxOrd  := { "Código", "Nombre" }
   local cCbxOrd
   local nLevel   := nLevelUsr( MENUOPTION )
   local lOpen    := .f.

   nRec           := ( cFamilia )->( RecNo() )

   nOrd           := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd        := aCbxOrd[ nOrd ]

   nOrd           := ( cFamilia )->( OrdSetFocus( nOrd ) )

   ( cFamilia )->( dbgotop() )

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Familias de artículos"

      REDEFINE GET oGet1 VAR cGet1;
         ID       104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, cFamilia ) ) ;
         VALID    ( OrdClearScope( oBrw, cFamilia ) );
         BITMAP   "FIND" ;
         OF       oDlg

      REDEFINE COMBOBOX oCbxOrd ;
         VAR      cCbxOrd ;
         ID       102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( ( cFamilia )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:refresh(), oGet1:SetFocus() ) ;
         OF       oDlg

      REDEFINE XBROWSE oBrw ;
         FIELDS ;
                  ( cFamilia )->cCodFam,;
                  ( cFamilia )->cNomFam;
         HEAD ;
                  "Código",;
                  "Nombre";
         FIELDSIZES ;
                  60 ,;
                  200;
         ALIAS    ( cFamilia );
         ID       105 ;
         OF       oDlg

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }

      oBrw:nMarqueeStyle   := 5

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

   DestroyFastFilter( cFamilia )

   SetBrwOpt( "BrwFamilia", ( cFamilia )->( OrdNumber() ) )

   if oDlg:nResult == IDOK

      oGet:cText( ( cFamilia )->cCodFam )

      if oGet2 != NIL
         oGet2:cText( ( cFamilia )->cNomFam )
      end if

   end if

   oGet:SetFocus()

   ( cFamilia )->( dbGoTo( nRec ) )

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

static function sortHashBrowseFamilia( nOrd, oBrw, oCbxOrd, aFamilias )

   if Empty( oBrw )
      Return .t.
   end if

   if !Empty( oCbxOrd )
      oCbxOrd:Select( nOrd )
   end if

   asort( aFamilias, , , {|x,y| x[nOrd] < y[nOrd] })

   oBrw:Select(0)
   oBrw:Select(1)
   oBrw:Refresh()

RETURN ( .t. )

//---------------------------------------------------------------------------//

static function searchHashBrowseFamilia( nPos, oBrw, cGet1, aFamiliasOriginal, aFamilias )

   local aArray

   if Empty( oBrw )
      return .t.
   end if

   if Empty( cGet1 )
      
      aFamilias         := aFamiliasOriginal

      oBrw:setArray( aFamilias, , , .f. )
      oBrw:Select(0)
      oBrw:Select(1)
      oBrw:Refresh()

      return .t.

   end if

   aFamilias   := {}

   for each aArray in aFamiliasOriginal
      
      if AllTrim( Upper( cGet1 ) ) $ AllTrim( Upper( aArray[nPos] ) )
         aAdd( aFamilias, aArray )
      end if

   next

   oBrw:setArray( aFamilias, , , .f. )
   oBrw:Select(0)
   oBrw:Select(1)
   oBrw:Refresh()

RETURN ( .t. )

//---------------------------------------------------------------------------//

FUNCTION browseHashFamilia( oGet )

   local oDlg
   local oBrw
   local cCod     := Space( 16 )
   local oGet1
   local cGet1
   local nOrd     := GetBrwOpt( "BrwHashFamilia" )
   local oCbxOrd
   local aCbxOrd  := { "Código", "Nombre", "Ruta" }
   local cCbxOrd
   local aFamilias
   local aFamiliasOriginal

   nOrd           := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd        := aCbxOrd[ nOrd ]

   if !OpenFiles( .t. )
      RETURN nil
   end if

   aFamiliasOriginal    := getHashFamilias()
   aFamilias            := aFamiliasOriginal

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Familias de artículos"

      REDEFINE GET oGet1 VAR cGet1;
         ID       104 ;
         BITMAP   "FIND" ;
         OF       oDlg

         oGet1:bHelp    := {|| searchHashBrowseFamilia( oCbxOrd:nAt, oBrw, cGet1, aFamiliasOriginal, @aFamilias ) }
         oGet1:bValid   := {|| searchHashBrowseFamilia( oCbxOrd:nAt, oBrw, cGet1, aFamiliasOriginal, @aFamilias ) }
         oGet1:bChange  := {|| searchHashBrowseFamilia( oCbxOrd:nAt, oBrw, cGet1, aFamiliasOriginal, @aFamilias ) }

      REDEFINE COMBOBOX oCbxOrd ;
         VAR      cCbxOrd ;
         ID       102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE ( sortHashBrowseFamilia( aScan( aCbxOrd, cCbxOrd ), oBrw, oCbxOrd, @aFamilias ) );
         OF       oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "Browse.Hash.Familias"

      oBrw:setArray( aFamilias, , , .f. )

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "Código"
         :bEditValue       := {|| aFamilias[ oBrw:nArrayAt, 1 ] }
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | sortHashBrowseFamilia( aScan( aCbxOrd, oCol:cSortOrder ), oBrw, oCbxOrd, @aFamilias ) }
         :bEditValue       := {|| aFamilias[ oBrw:nArrayAt, 1 ] }
         :nWidth           := 120
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "Nombre"
         :bEditValue       := {|| aFamilias[ oBrw:nArrayAt, 2 ] }
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | sortHashBrowseFamilia( aScan( aCbxOrd, oCol:cSortOrder ), oBrw, oCbxOrd, @aFamilias ) }
         :nWidth           := 115
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Ruta"
         :cSortOrder       := "Ruta"
         :bEditValue       := {|| aFamilias[ oBrw:nArrayAt, 3 ] }
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | sortHashBrowseFamilia( aScan( aCbxOrd, oCol:cSortOrder ), oBrw, oCbxOrd, @aFamilias ) }
         :nWidth           := 590
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
         WHEN     .f. ;
         ACTION   .t.

      REDEFINE BUTTON ;
         ID       501 ;
         OF       oDlg ;
         WHEN     .f. ;
         ACTION   .t.

   oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )
   oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg ;
      ON INIT ( sortHashBrowseFamilia( aScan( aCbxOrd, cCbxOrd ), oBrw, oCbxOrd, @aFamilias ) ) ;
      CENTER

   if oDlg:nResult == IDOK

      if !Empty( oGet ) .and. len( aFamilias ) > 0
         oGet:cText( aFamilias[ oBrw:nArrayAt, 1 ] )
      end if

   end if

   CloseFiles()

   SetBrwOpt( "BrwHashFamilia", oCbxOrd:nAt )

   if !empty( oGet )
      oGet:SetFocus()
   end if

RETURN ( cCod )

//---------------------------------------------------------------------------//

