#ifndef __PDA__
   #include "FiveWin.ch"
   #include "Font.ch"
   #include "Report.ch"
   #include "Image.ch"
   #include "MesDbf.ch"
   #include "xbrowse.ch"
#else
   #include "FWCE.ch"   
   REQUEST DBFCDX
#endif
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
#define _LINFSTK                 28
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
#define _NDIAGRT                 40      //   N       3    0

static oWndBrw

static nview
static lOpenFiles    :=.f.

static dbfPrv
static dbfTmp
static dbfArticulo

static oGrpFam
static oFraPub
static oComentarios

static oBtnAceptarActualizarWeb

static oDetCamposExtra

static cNewFil

static bEdit         := { |aTmp, aGet, dbfFam, oBrw, bWhen, bValid, nMode | EdtRec( aTmp, aGet, dbfFam, oBrw, bWhen, bValid, nMode ) }
static bEdit2        := { |aTmp, aGet, dbfTmp, oBrw, bWhen, bValid, nMode | EdtDet( aTmp, aGet, dbfTmp, oBrw, bWhen, bValid, nMode ) }

static dbfFamilia
static dbfFamPrv

static oTreePadre

#define MENUOPTION   "01012"

//----------------------------------------------------------------------------//

//Comenzamos la parte de código que se compila para el ejecutable normal

#ifndef __PDA__

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
      return nil
   end if

   nOrd           := ( dbfFamilia )->( OrdSetFocus( nOrd ) )

   ( dbfFamilia )->( dbGoTop() )

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Familias de artículos"

		REDEFINE GET oGet1 VAR cGet1;
         ID       104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfFamilia ) ) ;
         VALID    ( OrdClearScope( oBrw, dbfFamilia ) );
         BITMAP   "FIND" ;
         OF       oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    aCbxOrd ;
			ON CHANGE( ( dbfFamilia )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:refresh(), oGet1:SetFocus() ) ;
			OF 		oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfFamilia
      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "Browse.Familias"

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodFam"
         :bEditValue       := {|| ( dbfFamilia )->cCodFam }
         :nWidth           := 120
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomFam"
         :bEditValue       := {|| ( dbfFamilia )->cNomFam }
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
         ACTION   ( WinAppRec( oBrw, bEdit, dbfFamilia ) )

		REDEFINE BUTTON ;
         ID       501 ;
         OF       oDlg ;
         WHEN     ( nAnd( nLevel, ACC_EDIT ) != 0 .and. !IsReport() .and. lAdd );
         ACTION   ( WinEdtRec( oBrw, bEdit, dbfFamilia ) )

   if nAnd( nLevel, ACC_APPD ) != 0 .and. !IsReport()
      oDlg:AddFastKey( VK_F2,    {|| WinAppRec( oBrw, bEdit, dbfFamilia ) } )
   end if

   if nAnd( nLevel, ACC_EDIT ) != 0 .and. !IsReport()
      oDlg:AddFastKey( VK_F3,    {|| WinEdtRec( oBrw, bEdit, dbfFamilia ) } )
   end if

   oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )
   oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

   DestroyFastFilter( dbfFamilia )

   SetBrwOpt( "BrwFamilia", ( dbfFamilia )->( OrdNumber() ) )

   if oDlg:nResult == IDOK

      cCod                 := ( dbfFamilia )->cCodFam

      if !Empty( oGet )
         oGet:cText( cCod )
      end if

      if !Empty( oGet2 )
         oGet2:cText( ( dbfFamilia )->cNomFam )
      end if

   end if

   CloseFiles()

   if !Empty( oGet )
      oGet:SetFocus()
   end if

RETURN ( cCod )

//---------------------------------------------------------------------------//
/*
Browse de familias para las familias combinadas para que haga el closefiles
*/

FUNCTION BrwFamiliaCombinada( oGet, dbfFamilia, oGet2 )

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

   nRec           := ( dbfFamilia )->( RecNo() )

   nOrd           := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd        := aCbxOrd[ nOrd ]

   nOrd           := ( dbfFamilia )->( OrdSetFocus( nOrd ) )

   ( dbfFamilia )->( dbGoTop() )

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Familias de artículos"

		REDEFINE GET oGet1 VAR cGet1;
         ID       104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfFamilia ) ) ;
         VALID    ( OrdClearScope( oBrw, dbfFamilia ) );
         BITMAP   "FIND" ;
         OF       oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    aCbxOrd ;
			ON CHANGE( ( dbfFamilia )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:refresh(), oGet1:SetFocus() ) ;
			OF 		oDlg

      REDEFINE XBROWSE oBrw ;
			FIELDS ;
                  ( dbfFamilia )->cCodFam,;
                  ( dbfFamilia )->cNomFam;
			HEAD ;
                  "Código",;
                  "Nombre";
         FIELDSIZES ;
                  60 ,;
                  200;
         ALIAS    ( dbfFamilia );
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

   DestroyFastFilter( dbfFamilia )

   SetBrwOpt( "BrwFamilia", ( dbfFamilia )->( OrdNumber() ) )

   if oDlg:nResult == IDOK

      oGet:cText( ( dbfFamilia )->cCodFam )

      if oGet2 != NIL
         oGet2:cText( ( dbfFamilia )->cNomFam )
      end if

   end if

   oGet:SetFocus()

   ( dbfFamilia )->( dbGoTo( nRec ) )

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

static function OpenFiles()

   local lOpen       := .t.
   local oError
   local oBlock

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      DisableAcceso()

      nView             := D():CreateView()

      lOpenFiles  := .t.

      D():Familias( nView )

      USE ( cPatArt() + "Familias.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FAMILIAS", @dbfFamilia ) )
      SET ADSINDEX TO ( cPatArt() + "Familias.Cdx" ) ADDITIVE

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

      oDetCamposExtra      := TDetCamposExtra():New()
      if !empty( oDetCamposExtra )
         oDetCamposExtra:OpenFiles()
         oDetCamposExtra:SetTipoDocumento( "Familias" )
         oDetCamposExtra:setbId( {|| D():FamiliasId( nView ) } )
      end if

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos de familias" )

      CloseFiles()

      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

return ( lOpen )

//---------------------------------------------------------------------------//

static function CloseFiles()

   CLOSE ( dbfFamilia   )
   CLOSE ( dbfFamPrv    )
   CLOSE ( dbfArticulo  )
   CLOSE ( dbfPrv       )

   if !Empty( oGrpFam )
      oGrpFam:End()
   end if

   if !Empty( oFraPub )
      oFraPub:End()
   end if


   if !Empty( oComentarios )
      oComentarios:End()
   end if

   if !Empty( oDetCamposExtra )
      oDetCamposExtra:CloseFiles()
   end if

   oWndBrw        := nil
   dbfArticulo    := nil
   dbfFamilia     := nil
   dbfPrv         := nil
   oComentarios   := nil

return .t.

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

      AddMnuNext( "Familias de artículos", ProcName() )

      DEFINE SHELL oWndBrw FROM 0, 0 TO 22, 80;
      XBROWSE ;
      TITLE    "Familias de artículos" ;
      PROMPT   "Código",;
               "Nombre",;
               "Posición" ;
      MRU      "gc_cubes_16" ;
      BITMAP   clrTopArchivos ;
		ALIAS		( dbfFamilia ) ;
      APPEND   ( WinAppRec( oWndBrw:oBrw, bEdit, dbfFamilia ) );
      DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdit, dbfFamilia ) );
      EDIT     ( WinEdtRec( oWndBrw:oBrw, bEdit, dbfFamilia ) );
      DELETE   ( WinDelRec( oWndBrw:oBrw, dbfFamilia, {|| DeleteFamiliaProveedores() } ) );
      LEVEL    nLevel ;
		OF 		oWnd

      // Envios ---------------------------------------------------------------

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Envio"
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfFamilia )->lSelDoc }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
         :nHeadBmpNo       := 3
         :AddResource( "gc_mail2_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Publicar"
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfFamilia )->lPubInt }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
         :nHeadBmpNo       := 3
         :AddResource( "gc_earth_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Táctil"
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfFamilia )->lIncTpv }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
         :nHeadBmpNo       := 3
         :AddResource( "Tactil16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código"
         :nHeadBmpNo       := 1
         :cSortOrder       := "CCODFAM"
         :bEditValue       := {|| ( dbfFamilia )->cCodFam }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :AddResource( "Sel16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "CNOMFAM"
         :bEditValue       := {|| ( dbfFamilia )->cNomFam }
         :nWidth           := 260
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Grupo"
         :bStrData         := {|| ( dbfFamilia )->cCodGrp }
         :nWidth           := 60
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Prop. 1"
         :bStrData         := {|| ( dbfFamilia )->cCodPrp1 }
         :nWidth           := 60
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Prop. 2"
         :bStrData         := {|| ( dbfFamilia )->cCodPrp2 }
         :nWidth           := 60
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Posición"
         :cSortOrder       := "nPosTpv"
         :bEditValue       := {|| if( ( dbfFamilia )->lIncTpv, Trans( ( dbfFamilia )->nPosTpv, "99" ), "" ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Familia padre"
         :bStrData         := {|| ( dbfFamilia )->cFamCmb }
         :nWidth           := 60
         :lHide            := .t.
      end with

      oDetCamposExtra:addCamposExtra( oWndBrw )

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
			ACTION  	( WinZooRec( oWndBrw:oBrw, bEdit, dbfFamilia ) );
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
            ACTION   ( lSelectAll( oWndBrw, dbfFamilia, "lSelDoc", .t., .t., .t. ) );
            TOOLTIP  "Todos" ;
            FROM     oSnd ;
            CLOSED ;
            LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "Lbl" OF oWndBrw ;
            NOBORDER ;
            ACTION   ( lSelectAll( oWndBrw, dbfFamilia, "lSelDoc", .f., .t., .t. ) );
            TOOLTIP  "Ninguno" ;
            FROM     oSnd ;
            CLOSED ;
            LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "SNDINT" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( IncWeb() ) ;
         TOOLTIP  "(P)ublicar" ;
         HOTKEY   "P";
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

Static Function EdtRec( aTmp, aGet, dbfFamilia, oBrw, bWhen, bValid, nMode )

	local oDlg
   local oFld
   local oBlock
   local oError
   local oBrwPrv
   local oSayGrp
   local cSayGrp
   local oSayTComandas
   local cSayTComandas
   local oSayPrpUno
   local cSayPrpUno     := ""
   local oSayPrpDos
   local cSayPrpDos     := ""
   local bmpImage

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      BeginTrans( aTmp )

      if Empty( aTmp[ _NCOLBTN ] )
         aTmp[ _NCOLBTN ]  := GetSysColor( COLOR_BTNFACE )
      end if

      if nMode == DUPL_MODE
         aTmp[ _CCODFAM ]  := NextKey( aTmp[ _CCODFAM ], dbfFamilia )
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
                  "&Proveedores";
         DIALOGS  "FAMILIA_01",;
                  "FAMILIA_04",;
                  "FAMILIA_02"

         /*
         Redefinici¢n de la primera caja de Dialogo-------------------------------
         */

         REDEFINE GET aGet[ _CCODFAM ] VAR aTmp[ _CCODFAM ];
            ID       100 ;
            WHEN     ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) ;
            ON HELP  ( aGet[ _CCODFAM ]:cText( NextKey( aTmp[ _CCODFAM ], dbfFamilia ) ) ) ; // dbLast( dbfFamilia, 1, nil, nil, 1 ) ) ) ) ;
            BITMAP   "BOT" ;
            VALID    ( notValid( aGet[ _CCODFAM ], dbfFamilia ) ) ;
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

         REDEFINE CHECKBOX aTmp[ _LPUBINT ] ;
            ID       115 ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            OF       oFld:aDialogs[2]

         REDEFINE CHECKBOX aTmp[ _LFAMINT ];
            ID       116 ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            OF       oFld:aDialogs[2]

         REDEFINE GET aGet[ _NCOLBTN ] VAR aTmp[ _NCOLBTN ] ;
            ID       290 ;
            COLOR    aTmp[ _NCOLBTN ], aTmp[ _NCOLBTN ] ;
            BITMAP   "COLORS_16" ;
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

         REDEFINE GET aGet[ _CCODWEB ] ;
            VAR      aTmp[ _CCODWEB ] ;
            ID       350 ;
            PICTURE  "9999999";
            SPINNER ;
            MIN      ( 1 ) ;
            MAX      ( 9999999 ) ;
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

         // Segunda caja de dialogo--------------------------------------------------

         REDEFINE CHECKBOX aTmp[ _LINFSTK ] ;
            ID       540 ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            OF       oFld:aDialogs[ 3 ]

         oBrwPrv                 := IXBrowse():New( oFld:aDialogs[ 3 ] )

         oBrwPrv:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
         oBrwPrv:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

         oBrwPrv:cAlias          := dbfTmp
         oBrwPrv:nMarqueeStyle   := 6

            with object ( oBrwPrv:AddCol() )
               :cHeader          := "Proveedor"
               :bEditValue       := {|| Rtrim( ( dbfTmp )->cCodPrv ) + Space( 1 ) + retFld( ( dbfTmp )->cCodPrv, dbfPrv, "Titulo" ) }
               :nWidth           := 220
            end with

            with object ( oBrwPrv:AddCol() )
               :cHeader          := "Familia"
               :bEditValue       := {|| ( dbfTmp )->cFamPrv }
               :nWidth           := 140
            end with

            if nMode != ZOOM_MODE
               oBrwPrv:bLDblClick   := {|| WinEdtRec( oBrwPrv, bEdit2, dbfTmp ) }
            end if

            oBrwPrv:CreateFromResource( 530 )

         REDEFINE BUTTON ;
            ID       500 ;
            OF       oFld:aDialogs[3];
            WHEN     ( nMode != ZOOM_MODE ) ;
            ACTION   ( WinAppRec( oBrwPrv, bEdit2, dbfTmp ) )

         REDEFINE BUTTON ;
            ID       510 ;
            OF       oFld:aDialogs[3];
            WHEN     ( nMode != ZOOM_MODE ) ;
            ACTION   ( WinEdtRec( oBrwPrv, bEdit2, dbfTmp ) )

         REDEFINE BUTTON ;
            ID       520 ;
            OF       oFld:aDialogs[3];
            WHEN     ( nMode != ZOOM_MODE ) ;
            ACTION   ( dbDelRec( oBrwPrv, dbfTmp ) )

         // Grabamos-----------------------------------------------------------------

         REDEFINE BUTTON oBtnAceptarActualizarWeb;
            ID       500 ;
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
         
         oFld:aDialogs[2]:AddFastKey( VK_F2, {|| WinAppRec( oBrwPrv, bEdit2, dbfTmp ) } )
         oFld:aDialogs[2]:AddFastKey( VK_F3, {|| WinEdtRec( oBrwPrv, bEdit2, dbfTmp ) } )
         oFld:aDialogs[2]:AddFastKey( VK_F4, {|| dbDelRec( oBrwPrv, dbfTmp ) } )

         oDlg:AddFastKey( VK_F5, {|| EndTrans( aTmp, aGet, nMode, oBrwPrv, oDlg ) } )

         if uFieldEmpresa( "lRealWeb" )
            oDlg:AddFastKey( VK_F6, {|| EndTrans( aTmp, aGet, nMode, oBrwPrv, oDlg, .t. ) } )
         end if

         oDlg:AddFastKey( VK_F9, {|| oDetCamposExtra:Play( aTmp[ _CCODFAM ] ) } )

      end if

      oDlg:bStart    := {|| StartEdtRec( aGet, aTmp, bmpImage ) }

      ACTIVATE DIALOG oDlg CENTER ;
         ON INIT     ( EdtRecMenu( oDlg, aTmp ) ) ;

   RECOVER USING oError

      msgStop( "Imposible abrir dialogo de familias." + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !Empty( oBrwPrv )
      oBrwPrv:End()
   end if

   /*
   Borramos los ficheros-------------------------------------------------------
	*/

   KillTrans()

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Static Function EdtRecMenu( oDlg, aTmp )

   local oMenu

   MENU oMenu

      MENUITEM    "&1. Rotor"

         MENU

            MENUITEM "&1. Campos extra [F9]";
            MESSAGE  "Mostramos y rellenamos los campos extra para la familia" ;
            RESOURCE "form_green_add_16" ;
            ACTION   ( oDetCamposExtra:Play( aTmp[ _CCODFAM ] ) )

         ENDMENU

   ENDMENU

   oDlg:SetMenu( oMenu )

Return ( oMenu )

//--------------------------------------------------------------------------//

Static Function StartEdtRec( aGet, aTmp, bmpImage )

   aGet[ _CCODGRP  ]:lValid()
   aGet[ _CCOMFAM  ]:lValid()
   aGet[ _CCODPRP1 ]:lValid()
   aGet[ _CCODPRP2 ]:lValid()

   aGet[ _CCODFAM ]:SetFocus()

   if uFieldEmpresa( "lRealWeb" )
      oBtnAceptarActualizarWeb:Show()
   else
      oBtnAceptarActualizarWeb:Hide()
   end if 

   LoadTree()  

   SetTreeState( , , aTmp[ _CFAMCMB ] )

   ChgBmp( aGet[ _CIMGBTN ], bmpImage )

Return .t.

//---------------------------------------------------------------------------//

static function LoadTree( oTree, cCodFam )

   local nRec
   local nOrd
   local oNode

   if Empty( cCodFam )
      // return .t.
      cCodFam        := Space( 16 )
   end if

   DEFAULT oTree     := oTreePadre

   CursorWait()

   nRec              := ( dbfFamilia )->( Recno() )
   nOrd              := ( dbfFamilia )->( OrdSetFocus( "cFamCmb" ) )

   if ( dbfFamilia )->( dbSeek( cCodFam ) )

      while ( ( dbfFamilia )->cFamCmb == cCodFam .and. !( dbfFamilia )->( eof() ) )

         oNode       := oTree:Add( Alltrim( ( dbfFamilia )->cNomFam ) )
         oNode:Cargo := ( dbfFamilia )->cCodFam

         LoadTree( oNode, ( dbfFamilia )->cCodFam )

         ( dbfFamilia )->( dbSkip() )

         SysRefresh()

      end while

   end if

   ( dbfFamilia )->( OrdSetFocus( nOrd ) )
   ( dbfFamilia )->( dbGoTo( nRec ) )

   CursorWE()

   oTree:Expand()

Return ( .t. )

//---------------------------------------------------------------------------//

static function SetTreeState( oTree, aItems, cCodFam )

   local oItem

   DEFAULT oTree  := oTreePadre

   if Empty( aItems )
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

Return ( .t. )

//---------------------------------------------------------------------------//

static function ChangeTreeState( oTree, aItems )

   local oItem

   DEFAULT oTree  := oTreePadre

   if Empty( aItems )
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

Return ( .t. )

//---------------------------------------------------------------------------//

static function GetTreeState( aTmp, oTree, aItems )

   local oItem

   DEFAULT oTree              := oTreePadre

   if Empty( aItems )
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

Return ( aTmp )

//---------------------------------------------------------------------------//

static function aChildTree( cCodFamilia, aChild )

   local nRec
   local nOrd

   if Empty( aChild )
      aChild   := {}
   end if

   CursorWait()

   nRec        := ( dbfFamilia )->( Recno() )
   nOrd        := ( dbfFamilia )->( OrdSetFocus( "cFamCmb" ) )

   if ( dbfFamilia )->( dbSeek( cCodFamilia ) )

      while ( ( dbfFamilia )->cFamCmb == cCodFamilia .and. !( dbfFamilia )->( Eof() ) )

         aAdd( aChild, ( dbfFamilia )->cCodFam )

         aChildTree( ( dbfFamilia )->cCodFam, aChild )

         ( dbfFamilia )->( dbSkip() )

      end while

   end if

   ( dbfFamilia )->( OrdSetFocus( nOrd ) )
   ( dbfFamilia )->( dbGoTo( nRec ) )

   CursorWE()

Return ( aChild )

//---------------------------------------------------------------------------//

STATIC FUNCTION BeginTrans( aTmp )

   local cCodFam

   cCodFam           := aTmp[ _CCODFAM ]
   cNewFil           := cGetNewFileName( cPatTmp() + "PrvL" )

	/*
   Primero Crear la base de datos local----------------------------------------
	*/

   dbCreate( cNewFil, aSqlStruct( aItmFamPrv() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cNewFil, cCheckArea( "PrvL", @dbfTmp ), .f. )

   if !( dbfTmp )->( neterr() )

      ( dbfTmp )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfTmp )->( OrdCreate( cNewFil, "cPrvFam", "cCodPrv + cFamPrv", {|| Field->cCodPrv + Field->cFamPrv } ) )

      /*
      A¤adimos desde el fichero de lineas
      */

      if ( dbfFamPrv )->( dbSeek( cCodFam ) )
         while ( ( dbfFamPrv )->cCodFam == cCodFam .and. !( dbfFamPrv )->( Eof() ) )
            dbPass( dbfFamPrv, dbfTmp, .t. )
            ( dbfFamPrv )->( dbSkip() )
         end while
      end if

      ( dbfTmp )->( dbGoTop() )

   end if

Return Nil

//-----------------------------------------------------------------------//

STATIC FUNCTION EndTrans( aTmp, aGet, nMode, oBrw, oDlg, lActualizaWeb )

   local oError
   local oBlock
   local cCodFam           := aTmp[ _CCODFAM ]
   local aGrp

   DEFAULT lActualizaWeb   := .f.

   //Controlamos que no se cree una familia con el código o el nombre en blanco

   if nMode == APPD_MODE .or. nMode == DUPL_MODE

      if Empty( cCodFam )
         MsgStop( "Código no puede estar vacío" )
         aGet[ _CCODFAM ]:SetFocus()
         return nil
      end if

      if dbSeekInOrd( cCodFam, "cCodFam", dbfFamilia )
         MsgStop( "Código ya existe " + Rtrim( cCodFam ) )
         return nil
      end if

   end if

   if Empty( aTmp[ _CNOMFAM ] )
      MsgStop( "Nombre no puede estar vacío" )
      aGet[ _CNOMFAM ]:SetFocus()
      return nil
   end if

   do case
      case !Empty( aTmp[ _CCODPRP2 ] ) .AND. Empty( aTmp[ _CCODPRP1 ] )
         MsgStop( "Para informar la propiedad 2 no puede dejar vacía la propiedad 1." )
         Return nil
      case aTmp[ _CCODPRP1 ] == aTmp[ _CCODPRP2 ] .AND. !Empty( aTmp[ _CCODPRP1 ] ) .AND. !Empty( aTmp[ _CCODPRP2 ] )
         MsgStop( "No puede repetir las propiedades." )
         Return nil
   end case

   aTmp[ _CFAMCMB ]  := ""

   GetTreeState( aTmp )

   if ( aTmp[ _CFAMCMB ] == aTmp[ _CCODFAM ] )
      MsgStop( "Familia padre no puede ser el mismo" )
      oTreePadre:SetFocus()
      Return nil
   end if

   aGrp  := aChildTree( aTmp[ _CCODFAM ] )
   if aScan( aGrp, aTmp[ _CFAMCMB ] ) != 0
      MsgStop( "Familia padre contiene referencia circular" )
      oTreePadre:SetFocus()
      Return nil
   end if

   aTmp[ _LSELDOC ]  := .t.

	/*
	Primero hacer el RollBack
	*/

   CursorWait()

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      BeginTransaction()

      /*
      Roll Back
      */

      while ( dbfFamPrv )->( dbSeek( cCodFam ) ) .and. !( dbfFamPrv )->( Eof() )
         if dbLock( dbfFamPrv )
            ( dbfFamPrv )->( dbDelete() )
            ( dbfFamPrv )->( dbUnLock() )
         end if
      end while

      /*
      Ahora escribimos en el fichero definitivo
      */

      ( dbfTmp )->( dbGoTop() )
      while !( dbfTmp )->( eof() )
         dbPass( dbfTmp, dbfFamPrv, .t., cCodFam )
         ( dbfTmp )->( dbSkip() )
      end while

      // Escribe los datos pendientes---------------------------------------------

      WinGather( aTmp, aGet, dbfFamilia, oBrw, nMode )

      CommitTransaction()

      // Actualizamos los datos de la web para tiempo real------------------------

      if lActualizaWeb
         actualizaWeb( cCodFam )
      end if 

   RECOVER USING oError

      RollBackTransaction()

      msgStop( ErrorMessage( oError ), "Imposible almacenar artículo" )

   END SEQUENCE

   ErrorBlock( oBlock )

   /*
   Reordenación de posiciones--------------------------------------------------

   ChangePosition()
   */

   CursorWe()

   oDlg:end( IDOK )

   // dbCommitAll()

Return NIL

//---------------------------------------------------------------------------//

STATIC FUNCTION KillTrans()

	/*
	Borramos los ficheros
	*/

   if ( dbfTmp )->( Used() )
      ( dbfTmp )->( dbCloseArea() )
   end if

   dbfErase( cNewFil )

RETURN .T.

//------------------------------------------------------------------------//

Static Function actualizaWeb( cCodFam )

   if lPubFam()

      with object ( TComercio():New() )
         :MeterTotal( getAutoMeterDialog() )
         :TextTotal( getAutoTextDialog() )
         :TComercioCategory:buildCategory( cCodFam )
      end with

   end if   

Return .t.

//----------------------------------------------------------------------------//

Static Function lPubFam()

Return ( ( dbfFamilia )->lPubInt .or. ( dbfFamilia )->cCodWeb != 0 )

//----------------------------------------------------------------------------//

STATIC FUNCTION EdtDet( aTmp, aGet, dbfTmp, oBrw, bWhen, bValid, nMode )

	local oDlg
	local oGet
   local oGet2
	local oGetTxt
	local cGetTxt

   DEFINE DIALOG oDlg RESOURCE "LFAMPRV" TITLE LblTitle( nMode ) + "familias de proveedores"

      REDEFINE GET oGet;
         VAR      aTmp[ ( dbfTmp )->( FieldPos( "cCodPrv" ) ) ];
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

      REDEFINE GET oGet2 VAR aTmp[ ( dbfTmp )->( FieldPos( "cFamPrv" ) ) ];
         ID       110 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( 	nMode != ZOOM_MODE ) ;
         ACTION   (  EndDetalle( aTmp, aGet, dbfTmp, oBrw, nMode, oDlg, oGet, oGet2 ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| EndDetalle( aTmp, aGet, dbfTmp, oBrw, nMode, oDlg, oGet, oGet2 ) } )
   end if

   ACTIVATE DIALOG oDlg ON PAINT ( oGet:lValid() ) CENTER

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Static Function EndDetalle( aTmp, aGet, dbfTmp, oBrw, nMode, oDlg, oGet, oGet2 )

   if nMode == APPD_MODE

      if Empty( aTmp[ ( dbfTmp )->( FieldPos( "cCodPrv" ) ) ] )
         MsgStop( "Código no puede estar vacío" )
         oGet:SetFocus()
         return nil
      end if

   end if

   if Empty( aTmp[ ( dbfTmp )->( FieldPos( "cFamPrv" ) ) ] )
      MsgStop( "Código de la familia no puede estar vacío" )
      oGet2:SetFocus()
      return nil
   end if

   if dbSeekFamilia( aTmp, dbfTmp )
      msgStop( "Código de familia existente" )
      return nil
   end if

   WinGather( aTmp, aGet, dbfTmp, oBrw, nMode )

Return ( oDlg:end() )

//---------------------------------------------------------------------------//

Static Function dbSeekFamilia( aTmp, dbfTmp )

   local lSeek    := .f.
   local nOrdAnt  := ( dbfTmp )->( OrdSetFocus( "cPrvFam" ) )

   if ( dbfTmp )->( dbSeek( aTmp[ ( dbfTmp )->( FieldPos( "cCodPrv" ) ) ] + aTmp[ ( dbfTmp )->( FieldPos( "cFamPrv" ) ) ] ) )
      lSeek    := .t.
   end if

   ( dbfTmp )->( OrdSetFocus( nOrdAnt ) )

Return ( lSeek )

//---------------------------------------------------------------------------//

Function EdtFamilia( cCodFam, lOpenBrowse )

   local lEdit          := .f.
   local nLevel         := nLevelUsr( MENUOPTION )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_EDIT ) == 0
      msgStop( 'Acceso no permitido.' )
      return .f.
   end if

   if lOpenBrowse

      if Familia()
         if dbSeekInOrd( cCodFam, "cCodFam", dbfFamilia )
            lEdit       := oWndBrw:RecEdit()
         else
            MsgStop( "No se encuentra familia" )
         end if
      end if

   else

      if !Empty( cCodFam )

         if OpenFiles( .t. )
            if dbSeekInOrd( cCodFam, "cCodFam", dbfFamilia )
               lEdit    := WinEdtRec( oWndBrw, bEdit, dbfFamilia )
            else
               MsgStop( "No se encuentra familia" )
            end if
            CloseFiles()
         end if

      end if 

   end if

Return ( lEdit )

//--------------------------------------------------------------------------//

//
// Devuelve el presupuesto de la familia
//

function nPreFamilia( cCodFam, aMes, lAno, dbfFamilia )

   local nPreFam  := 0

   if dbSeekInOrd( cCodFam, "cCodFam", dbfFamilia )

      if lAno

         nPreFam  := ( dbfFamilia )->NVALANU

      else

         if aMes[ 1]
            nPreFam  += ( dbfFamilia )->NENE
         end if

         if aMes[ 2]
            nPreFam  += ( dbfFamilia )->NFEB
         end if

         if aMes[ 3]
            nPreFam  += ( dbfFamilia )->NMAR
         end if

         if aMes[ 4]
            nPreFam  += ( dbfFamilia )->NABR
         end if

         if aMes[ 5]
            nPreFam  += ( dbfFamilia )->NMAY
         end if

         if aMes[ 6]
            nPreFam  += ( dbfFamilia )->NJUN
         end if

         if aMes[ 7]
            nPreFam  += ( dbfFamilia )->NJUL
         end if

         if aMes[ 8]
            nPreFam  += ( dbfFamilia )->NAGO
         end if

         if aMes[ 9]
            nPreFam  += ( dbfFamilia )->NSEP
         end if

         if aMes[10]
            nPreFam  += ( dbfFamilia )->NOCT
         end if

         if aMes[11]
            nPreFam  += ( dbfFamilia )->NNOV
         end if

         if aMes[12]
            nPreFam  += ( dbfFamilia )->NDIC
         end if

      end if

   end if

return ( nPreFam )

//--------------------------------------------------------------------------//

function lFamInTpv( dbfFamilia )

   local lFamInTpv   := .f.

   ( dbfFamilia )->( dbGoTop() )
   while !( dbfFamilia )->( eof() )
      if ( dbfFamilia )->lIncTpv
         lFamInTpv   := .t.
         exit
      end if
      ( dbfFamilia )->( dbSkip() )
   end while

return ( lFamInTpv )

//---------------------------------------------------------------------------//

Static Function IncWeb( aTmp )

   local nRec

   for each nRec in ( oWndBrw:oBrw:aSelected )

      ( dbfFamilia )->( dbGoTo( nRec ) )

      if dbLock( dbfFamilia )
         ( dbfFamilia )->lPubInt := !( dbfFamilia )->lPubInt
         ( dbfFamilia )->lSelDoc := ( dbfFamilia )->lPubInt
         ( dbfFamilia )->( dbUnLock() )
      end if

      oWndBrw:Refresh()

   next

Return ( nil )

//---------------------------------------------------------------------------//

Static Function IncEnvio( aTmp )

   local nRec

   for each nRec in ( oWndBrw:oBrw:aSelected )

      ( dbfFamilia )->( dbGoTo( nRec ) )

      if dbLock( dbfFamilia )
         ( dbfFamilia )->lSelDoc := !( dbfFamilia )->lSelDoc
         ( dbfFamilia )->( dbUnLock() )
      end if

   next

   oWndBrw:Refresh()

return ( nil )

//---------------------------------------------------------------------------//

static function IncTactil( lIncTactil )

   DEFAULT  lIncTactil  := !( dbfFamilia )->lIncTpv

   if dbLock( dbfFamilia )
      ( dbfFamilia )->lIncTpv := lIncTactil
      ( dbfFamilia )->( dbUnLock() )
      if oWndBrw != nil
         oWndBrw:Refresh()
      end if
   end if

   if apoloMsgNoYes( "¿Desea " + if( lIncTactil, "seleccionar", "deseleccionar" ) +;
                     " todos los artículos de esta familia," + CRLF +;
                     "para que sean " + if( lIncTactil, "incluidos en el", "excluidos del" ) +;
                     " TPV táctil ?",;
                     ( dbfFamilia )->cCodFam + Space( 1 ) + ( dbfFamilia )->cNomFam )

      if ( dbfArticulo )->( dbSeek( ( dbfFamilia )->cCodFam ) )

         while ( dbfArticulo )->Familia == ( dbfFamilia )->cCodFam

            if dbLock( dbfArticulo )
               ( dbfArticulo )->lIncTcl := lIncTactil
               ( dbfArticulo )->( dbUnLock() )
            end if

            ( dbfArticulo )->( dbSkip() )

         end while

      end if

   end if

return ( nil )

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

Function cCodFamPrv( cCodPrv, cFamPrv, dbfFamPrv )

   local cCodFam  := ""
   local nOrdAnt  := ( dbfFamPrv )->( OrdSetFocus( "cFamPrv" ) )

   if ( dbfFamPrv )->( dbSeek( cCodPrv + cFamPrv ) )
      cCodFam     := ( dbfFamPrv )->cCodFam
   end if

   ( dbfFamPrv )->( OrdSetFocus( nOrdAnt ) )

Return ( cCodFam )

//---------------------------------------------------------------------------//

Static Function DeleteFamiliaProveedores()

   local cCodFam        := ( dbfFamilia )->cCodFam

   CursorWait()

   while ( dbfFamPrv )->( dbSeek( cCodFam ) ) .and. !( dbfFamPrv )->( Eof() )
      if( dbLock( dbfFamPrv ), ( ( dbfFamPrv )->( dbDelete() ), ( dbfFamPrv )->( dbUnLock() ) ), )
   end while

   CursorWE()

Return ( .t. )

//---------------------------------------------------------------------------//

Function lPermitirVentaSinValorar( cCodArt, dbfArticulo, dbfFamilia )

   local lPermitir   := .f.

   if dbSeekInOrd( cCodArt, "Codigo", dbfArticulo )
      if dbSeekInOrd( ( dbfArticulo )->Familia, "cCodFam", dbfFamilia )
         lPermitir   := ( dbfFamilia )->lPreEsp
      end if
   end if

Return ( lPermitir )

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

   if !Empty( ::oSender:oMtr )
      ::oSender:oMtr:nTotal := ( dbfFam )->( lastrec() )
   end if

   while !( dbfFam )->( eof() )

      if ( dbfFam )->lSelDoc
         ::oSender:SetText( AllTrim( ( dbfFam )->cCodFam ) + "; " + AllTrim( ( dbfFam )->cNomFam ) )
         lSndFam  := .t.
         dbPass( dbfFam, tmpFam, .t. )
      end if

      ( dbfFam )->( dbSkip() )

      if !Empty( ::oSender:oMtr )
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

Return ( Self )

//---------------------------------------------------------------------------//

Method RestoreData()

   local oBlock
   local oError
   local dbfFamilia

   if ::lSuccesfullSend

      /*
      Sintuacion despues del envio---------------------------------------------
      */

      oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
      BEGIN SEQUENCE

      USE ( cPatArt() + "Familias.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FAMILIAS", @dbfFamilia ) )
      SET ADSINDEX TO ( cPatArt() + "Familias.Cdx" ) ADDITIVE

      while !( dbfFamilia )->( eof() )
         if ( dbfFamilia )->lSelDoc .and. ( dbfFamilia )->( dbRLock() )
            ( dbfFamilia )->lSelDoc := .f.
            ( dbfFamilia )->( dbRUnlock() )
         end if
         ( dbfFamilia )->( dbSkip() )
      end do

      RECOVER USING oError

         msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

      END SEQUENCE

      ErrorBlock( oBlock )

      CLOSE ( dbfFamilia  )

   end if

Return ( Self )

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

Return ( Self )

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

Return ( Self )

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

               if !Empty( ::oSender:oMtr )
                  ::oSender:oMtr:nTotal := ( tmpFam )->( lastrec() )
               end if

               while !( tmpFam )->( eof() )

                  if ( dbfFam )->( dbSeek( ( tmpFam )->cCodFam ) )
                     if !::oSender:lServer
                        dbPass( tmpFam, dbfFam )
                        ::oSender:SetText( "Reemplazado : " + AllTrim( ( dbfFam )->cCodFam ) + "; " + AllTrim( ( dbfFam )->cNomFam ) )
                     else
                        ::oSender:SetText( "Desestimado : " + AllTrim( ( dbfFam )->cCodFam ) + "; " + AllTrim( ( dbfFam )->cNomFam ) )
                     end if
                  else
                        dbPass( tmpFam, dbfFam, .t. )
                        ::oSender:SetText( "Añadido     : " + AllTrim( ( dbfFam )->cCodFam ) + "; " + AllTrim( ( dbfFam )->cNomFam ) )
                  end if

                  ( tmpFam )->( dbSkip() )

                  if !Empty( ::oSender:oMtr )
                     ::oSender:oMtr:Set( ( tmpFam )->( OrdKeyNo() ) )
                  end if

                  SysRefresh()

               end while

               if !Empty( ::oSender:oMtr )
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

Return ( Self )

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
//---------------------------------------------------------------------------//

Function SetHeadDiv( lEur, oWndBrw, cChrSea )

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

return nil

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
   ::AddField( "LPUBINT",    "L",   1, 0, {|| "" },    "Internet",               .f., "Publicar esta familia en internet",   10, .f. )

   ::lDefFecInf   := .f.
   ::lDefSerInf   := .f.
   ::lDefDivInf   := .f.

RETURN ( Self )

//---------------------------------------------------------------------------//

METHod lResource( cFld )

   if !::StdResource( "INF_FAM01" )
      return .f.
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

   if !Empty( ::oFilter:cExpresionFilter )
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
         ::oDbf:lPubInt     := ::oDbfFam:lPubInt

         ::oDbf:Save()

      end if

      ::oDbfFam:Skip()

      ::oMtrInf:AutoInc( ::oDbfFam:OrdKeyNo() )

   END DO

   ::oMtrInf:AutoInc( ::oDbfFam:LastRec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//Comenzamos la parte de código que se compila para el PDA

#else

FUNCTION pdaBrwFamilia( oGet, oGet2 )

	local oDlg
	local oBrw
   local oBtn
   local oFont
	local oGet1
	local cGet1
   local nOrd     := GetBrwOpt( "pdaBrwFamilia" )
	local oCbxOrd
   local aCbxOrd  := { "Código", "Nombre" }
   local cCbxOrd
   local nLevel   := nLevelUsr( MENUOPTION )

   nOrd           := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd        := aCbxOrd[ nOrd ]

   pdaOpenFiles()

   nOrd           := ( dbfFamilia )->( OrdSetFocus( nOrd ) )

   ( dbfFamilia )->( dbGoTop() )

   DEFINE FONT oFont NAME "Verdana" SIZE 0, -14

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY_PDA" TITLE "Familias de artículos"

      REDEFINE SAY oSayTit ;
         VAR      "Buscando familias" ;
         ID       110 ;
         COLOR    "N/W*" ;
         FONT     oFont ;
         OF       oDlg

      REDEFINE BTNBMP oBtn ;
         ID       100 ;
         OF       oDlg ;
         FILE     ( cPatBmp() + "Cubes_16.bmp" ) ;
         NOBORDER ;
         ACTION      ( nil )

         oBtn:SetColor( 0, nRGB( 255, 255, 255 )  )

		REDEFINE GET oGet1 VAR cGet1;
         ID       104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfFamilia ) ) ;
         VALID    ( OrdClearScope( oBrw, dbfFamilia ) );
         BITMAP   "FIND" ;
         OF       oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( ( dbfFamilia )->( OrdSetFocus( oCbxOrd:nAt ) ), ( dbfFamilia )->( dbGoTop() ), oBrw:refresh(), oGet1:SetFocus(), oCbxOrd:Refresh() ) ;
			OF 		oDlg

      REDEFINE LISTBOX oBrw ;
			FIELDS ;
                  (dbfFamilia)->cCodFam + CRLF + (dbfFamilia)->cNomFam;
			HEAD ;
                  "Código" + CRLF + "Nombre";
         FIELDSIZES ;
                  180;
         ALIAS    ( dbfFamilia );
         ID       105 ;
         OF       oDlg

   ACTIVATE DIALOG oDlg ;
      ON INIT ( oDlg:SetMenu( pdaMenuBusFam( oDlg ) ) )

   DestroyFastFilter( dbfFamilia )

   SetBrwOpt( "BrwFamilia", ( dbfFamilia )->( OrdNumber() ) )

   if oDlg:nResult == IDOK

      oGet:cText( ( dbfFamilia )->cCodFam )

      if oGet2 != NIL
         oGet2:cText( ( dbfFamilia )->cNomFam )
		END IF

   end if

   pdaCloseFiles()

	oGet:setFocus()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

static function pdaMenuBusFam( oDlg )

   local oMenu

   DEFINE MENU oMenu ;
      RESOURCE 100 ;
      BITMAPS  10 ; // bitmaps resoruces ID
      IMAGES   3     // number of images in the bitmap

      REDEFINE MENUITEM ID 110 OF oMenu ACTION ( oDlg:End( IDOK ) )

      REDEFINE MENUITEM ID 120 OF oMenu ACTION ( oDlg:End( IDCANCEL ) )

Return oMenu

//---------------------------------------------------------------------------//

static function pdaOpenFiles()

   local lOpen       := .t.
   local oError
   local oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      USE ( cPatArt() + "Familias.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FAMILIAS", @dbfFamilia ) )
      SET ADSINDEX TO ( cPatArt() + "Familias.Cdx" ) ADDITIVE

      USE ( cPatArt() + "FamPrv.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FAMPRV", @dbfFamPrv ) )
      SET ADSINDEX TO ( cPatArt() + "FamPrv.Cdx" ) ADDITIVE

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )
      pdaCloseFiles()

      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

return ( lOpen )

//---------------------------------------------------------------------------//

static function pdaCloseFiles()

   CLOSE ( dbfFamilia )
   CLOSE ( dbfFamPrv  )

   dbfFamilia  := nil
   dbfPrv      := nil

return .t.

//---------------------------------------------------------------------------//

FUNCTION pdaFamilia( oMenuItem )

   local oSnd
   local nLevel
   local oBlock
   local oDlg
   local oBrwFamilia
   local oGetBuscar
   local cGetBuscar     := Space( 100 )
   local oCbxOrden
   local cCbxOrden      := "Código"
   local oSayTit
   local oFont
   local oBtn

   DEFAULT  oMenuItem   := MENUOPTION

   /*
   Obtenemos el nivel de acceso
   */

   nLevel               := nLevelUsr( oMenuItem )

   if nAnd( nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      return nil
   end if

   if !pdaOpenFiles()
      return nil
   end if

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      DEFINE FONT oFont NAME "Verdana" SIZE 0, -14

      DEFINE DIALOG oDlg RESOURCE "Dlg_info"

      REDEFINE SAY oSayTit ;
         VAR      "Familias" ;
         ID       140 ;
         COLOR    "N/W*" ;
         FONT     oFont ;
         OF       oDlg

      REDEFINE BTNBMP oBtn ;
         ID       130 ;
         OF       oDlg ;
         FILE     ( cPatBmp() + "Cubes_16.bmp" ) ;
         NOBORDER ;
         ACTION      ( nil )

      oBtn:SetColor( 0, nRGB( 255, 255, 255 )  )

      REDEFINE GET oGetBuscar ;
         VAR      cGetBuscar;
         ID       110 ;
         BITMAP   "FIND" ;
         OF       oDlg

      oGetBuscar:bChange   := {| nKey, nFlags | AutoSeek( nKey, nFlags, oGetBuscar, oBrwFamilia, dbfFamilia ) }

      REDEFINE COMBOBOX oCbxOrden ;
         VAR      cCbxOrden ;
         ID       120 ;
         ITEMS    { "Código", "Nombre" } ;
			OF 		oDlg

      oCbxOrden:bChange    := {|| ( dbfFamilia )->( OrdSetFocus( oCbxOrden:nAt ) ), ( dbfFamilia )->( dbGoTop() ), oBrwFamilia:Refresh(), oGetBuscar:SetFocus(), oCbxOrden:Refresh() }

      REDEFINE LISTBOX oBrwFamilia ;
         FIELDS ;
               ( dbfFamilia )->cCodFam + CRLF + ( dbfFamilia )->cNomFam ;
         SIZES ;
               180 ;
         HEADER ;
               "Código" + CRLF + "Nombre" ;
         ALIAS ( dbfFamilia );
         ID    100 ;
         OF    oDlg

      ACTIVATE DIALOG oDlg ;
         ON INIT ( oDlg:SetMenu( pdaBuildMenu( oDlg, oBrwFamilia ) ) )

      pdaCloseFiles()

   RECOVER

      msgStop( "Imposible abrir familias" )

   END SEQUENCE

   ErrorBlock( oBlock )

   oFont:End()

   // Restauramos la ventana---------------------------------------------------

   oWnd():Show()

RETURN NIL

//----------------------------------------------------------------------------//

static function pdaBuildMenu( oDlg, oBrwFamilia )

   local oMenu

   DEFINE MENU oMenu ;
      RESOURCE 300 ;
      BITMAPS  40 ; // bitmaps resoruces ID
      IMAGES   5     // number of images in the bitmap

      REDEFINE MENUITEM ID 310 OF oMenu ACTION ( WinAppRec( oBrwFamilia, bEdtPda, dbfFamilia, oDlg ) )

      REDEFINE MENUITEM ID 320 OF oMenu ACTION ( WinEdtRec( oBrwFamilia, bEdtPda, dbfFamilia, oDlg ) )

      REDEFINE MENUITEM ID 330 OF oMenu ACTION ( DBDelRec( oBrwFamilia, dbfFamilia ) )

      REDEFINE MENUITEM ID 340 OF oMenu ACTION ( WinZooRec( oBrwFamilia, bEdtPda, dbfFamilia, oDlg ) )

      REDEFINE MENUITEM ID 350 OF oMenu ACTION ( oDlg:End() )

Return oMenu

//---------------------------------------------------------------------------//

Static Function PdaEdtRec( aTmp, aGet, dbfFamilia, oBrw, oDlgAnt, bValid, nMode )

	local oDlg
   local oSayTit
   local oFont
   local oBtn
   local logico   := .t.

   DEFINE FONT oFont NAME "Verdana" SIZE 0, -14

   DEFINE DIALOG oDlg RESOURCE "FAMILIA_PDA"  //TITLE LblTitle( nMode ) + "familias de artículos"

      REDEFINE SAY oSayTit ;
         VAR      LblTitle( nMode ) + "familias" ;
         ID       110 ;
         COLOR    "N/W*" ;
         FONT     oFont ;
         OF       oDlg

      REDEFINE BTNBMP oBtn ;
         ID       100 ;
         OF       oDlg ;
         FILE     ( cPatBmp() + "Cubes_16.bmp" ) ;
         NOBORDER ;
         ACTION      ( nil )

      oBtn:SetColor( 0, nRGB( 255, 255, 255 )  )

      REDEFINE GET aGet[ _CCODFAM ] ;
         VAR      aTmp[ _CCODFAM ] ;
         ID       120 ;
         WHEN     ( nMode == APPD_MODE ) ;
         OF       oDlg

      REDEFINE GET aGet[ _CNOMFAM ] ;
         VAR      aTmp[ _CNOMFAM ] ;
         ID       121 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE CHECKBOX aGet[ _LMOSTRAR ] ;
         VAR      aTmp[ _LMOSTRAR ] ;
         ID       122 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

   ACTIVATE DIALOG oDlg ;
      ON INIT ( oDlg:SetMenu( pdaMenuEdtRec( aTmp, aGet, nMode, oBrw, oDlg ) ) )

   oFont:End()

   oDlgAnt:Show()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

static function pdaMenuEdtRec( aTmp, aGet, nMode, oBrw, oDlg )

   local oMenu

   DEFINE MENU oMenu ;
      RESOURCE 100 ;
      BITMAPS  10 ; // bitmaps resoruces ID
      IMAGES   3     // number of images in the bitmap

      REDEFINE MENUITEM ID 110 OF oMenu ACTION ( PdaEndTrans( aTmp, aGet, nMode, oBrw, oDlg ) )

      REDEFINE MENUITEM ID 120 OF oMenu ACTION ( oDlg:End( IDCANCEL ) )

Return oMenu

//---------------------------------------------------------------------------//

STATIC FUNCTION PdaEndTrans( aTmp, aGet, nMode, oBrw, oDlg )

   local aTabla
   local cCodFam  := aTmp[ _CCODFAM ]

   //Controlamos que no se cree una familia con el código o el nombre en blanco

   if nMode == APPD_MODE

      if Empty( cCodFam )
         MsgStop( "Código no puede estar vacío" )
         aGet[ _CCODFAM ]:SetFocus()
         return nil
      end if

      if dbSeekInOrd( cCodFam, "CCODFAM", dbfFamilia )
         MsgStop( "Código ya existe " + Rtrim( cCodFam ) )
         aGet[ _CCODFAM ]:SetFocus()
         return nil
      end if

   end if

   if Empty( aTmp[ _CNOMFAM ] )
      MsgStop( "Nombre no puede estar vacío" )
      aGet[ _CNOMFAM ]:SetFocus()
      return nil
   end if

   WinGather( aTmp, aGet, dbfFamilia, oBrw, nMode )

   oDlg:end( IDOK )

   dbCommitAll()

Return ( nil )

//------------------------------------------------------------------------//

CLASS pdaPCFamSenderReciver

   Method CreateData()

END CLASS

//---------------------------------------------------------------------------//

Method CreateData( oPgrActual, oSayStatus ) CLASS pdaPCFamSenderReciver

   local lExist      := .f.
   local dbfFam
   local pdaFam

   USE ( cPatPc() + "Familias.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "Familias", @dbfFam ) )
   SET ADSINDEX TO ( cPatPc() + "Familias.CDX" ) ADDITIVE
   ( dbfFam )->( OrdSetFocus( "lSelDoc" ) )

   /*
   Usamos las bases de datos del PC--------------------------------------------
   */

   dbUseArea( .t., cDriver(), cPatArt() + "Familias.Dbf", cCheckArea( "Familias", @pdaFam ), .t. )
   ( pdaFam )->( ordListAdd( cPatArt() + "Familias.Cdx" ) )

   if !Empty( oPgrActual )
      oPgrActual:SetRange( 0, ( pdaFam )->( OrdKeyCount() ) )
   end if

   ( pdaFam )->( dbGoTop() )

   while !( pdaFam )->( eof() )

      if ( pdaFam )->lSelDoc

         if !( dbfFam )->( dbSeek( cCodFam ) )

            if dbLock( pdaFam )
               ( pdaFam )->lSelDoc  := .f.
               ( pdaFam )->( dbUnLock() )
            end if

            dbPass( pdaFam, dbfFam, .t. )

         end if

      end if

      ( pdaFam )->( dbSkip() )

      if !Empty( oSayStatus )
         oSayStatus:SetText( "Sincronizando Familias " + Alltrim( Str( ( pdaFam )->( OrdKeyNo() ) ) ) + " de " + Alltrim( Str( ( pdaFam )->( OrdKeyCount() ) ) ) )
      end if

      SysRefresh()

      if !Empty( oPgrActual )
         oPgrActual:SetPos( ( pdaFam )->( OrdKeyNo() ) )
      end if

      SysRefresh()

   end while

   CLOSE ( pdaFam )
   CLOSE ( dbfFam )

Return ( Self )

//----------------------------------------------------------------------------//

#endif

CLASS pdaFamiliaSenderReciver

   Method CreateData()

END CLASS

//----------------------------------------------------------------------------//

Method CreateData( oPgrActual, oSayStatus, cPatPreVenta ) CLASS pdaFamiliaSenderReciver

   local dbfFam
   local tmpFam
   local lExist      := .f.
   local cFileName
   local cPatPc      := if( Empty( cPatPreVenta ), cPatPc(), cPatPreVenta )

   USE ( cPatArt() + "Familias.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FAMILIAS", @dbfFam ) )
   SET ADSINDEX TO ( cPatArt() + "Familias.Cdx" ) ADDITIVE

   dbUseArea( .t., cDriver(), cPatPc + "Familias.Dbf", cCheckArea( "Familias", @tmpFam ), .t. )
   ( tmpFam )->( ordListAdd( cPatPc + "Familias.Cdx" ) )

   if !Empty( oPgrActual )
      oPgrActual:SetRange( 0, ( tmpFam )->( OrdKeyCount() ) )
   end if

   ( tmpFam )->( dbGoTop() )
   while !( tmpFam )->( eof() )

      if ( tmpFam )->lSelDoc

         if ( dbfFam )->( dbSeek( ( tmpFam )->cCodFam ) )
            dbPass( tmpFam, dbfFam, .f. )
         else
            dbPass( tmpFam, dbfFam, .t. )
         end if

         if dbLock( tmpFam )
            ( tmpFam )->lSelDoc  := .f.
            ( tmpFam )->( dbUnLock() )
         end if

         if dbLock( dbfFam )
            ( dbfFam )->lSelDoc  := .f.
            ( dbfFam )->( dbUnLock() )
         end if

      end if

      ( tmpFam )->( dbSkip() )

      if !Empty( oSayStatus )
         oSayStatus:SetText( "Sincronizando familias " + Alltrim( Str( ( tmpFam )->( OrdKeyNo() ) ) ) + " de " + Alltrim( Str( ( tmpFam )->( OrdKeyCount() ) ) ) )
      end if

      SysRefresh()

      if !Empty( oPgrActual )
         oPgrActual:SetPos( ( tmpFam )->( OrdKeyNo() ) )
      end if

      SysRefresh()

   end while

   CLOSE ( tmpFam )
   CLOSE ( dbfFam )

Return ( Self )

//---------------------------------------------------------------------------//

FUNCTION mkFamilia( cPath, lAppend, cPathOld )

	local dbfFamilia

	DEFAULT lAppend := .f.
   DEFAULT cPath   := cPatArt()

   if lExistTable( cPath + "Familias.Dbf", cLocalDriver() )
      fEraseTable( cPath + "Familias.dbf" )
   end if

   if lExistTable( cPath + "FamPrv.Dbf", cLocalDriver() )
      fEraseTable( cPath + "FamPrv.Dbf" )
   end if

   dbCreate( cPath + "Familias.Dbf", aSqlStruct( aItmFam() ), cLocalDriver() )

   if lAppend .and. cPathOld != nil .and. lIsDir( cPathOld )
      dbUseArea( .t., cDriver(), cPath + "Familias.Dbf", cCheckArea( "Familias", @dbfFamilia ), .f. )
      if !( dbfFamilia )->( neterr() )
         ( dbfFamilia )->( __dbApp( cPathOld + "Familias.Dbf" ) )
         ( dbfFamilia )->( dbCloseArea() )
      end if
   end if

   dbCreate( cPath + "FamPrv.Dbf", aSqlStruct( aItmFamPrv() ), cLocalDriver() )

   if lAppend .and. cPathOld != nil .and. lIsDir( cPathOld )
      dbUseArea( .t., cDriver(), cPath + "FamPrv.Dbf", cCheckArea( "FamPrv", @dbfFamilia ), .f. )
      if !( dbfFamilia )->( neterr() )
         ( dbfFamilia )->( __dbApp( cPathOld + "FamPrv.Dbf" ) )
         ( dbfFamilia )->( dbCloseArea() )
      end if
   end if

   rxFamilia( cPath, cLocalDriver() )

RETURN .t.

//--------------------------------------------------------------------------//

FUNCTION rxFamilia( cPath, cDriver )

	local dbfFamilia

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

   dbUseArea( .t., cDriver, cPath + "FAMILIAS.DBF", cCheckArea( "FAMILIAS", @dbfFamilia ), .f. )
   if !( dbfFamilia )->( neterr() )
      ( dbfFamilia )->( __dbPack() )

      ( dbfFamilia )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfFamilia )->( ordCreate( cPath + "FAMILIAS.CDX", "cCodFam", "Field->cCodFam", {|| Field->cCodFam }, ) )

      ( dbfFamilia )->( ordCondSet("!Deleted()", {|| !Deleted() }  ) )
      ( dbfFamilia )->( ordCreate( cPath + "FAMILIAS.CDX", "cNomFam", "Upper( Field->cNomFam )", {|| Upper( Field->cNomFam ) } ) )

      ( dbfFamilia )->( ordCondSet("!Deleted().and. lIncTpv", {|| !Deleted() .and. Field->lIncTpv }  ) )
      ( dbfFamilia )->( ordCreate( cPath + "FAMILIAS.CDX", "nPosTpv", "Str( Field->nPosTpv )", {|| Str( Field->nPosTpv ) } ) )

      ( dbfFamilia )->( ordCondSet("!Deleted() .and. lIncTpv", {|| !Deleted() .and. Field->lIncTpv }  ) )
      ( dbfFamilia )->( ordCreate( cPath + "FAMILIAS.CDX", "lIncTpv", "Upper( cNomFam )", {|| Upper( Field->cNomFam ) } ) )

      ( dbfFamilia )->( ordCondSet("!Deleted()", {|| !Deleted() }  ) )
      ( dbfFamilia )->( ordCreate( cPath + "FAMILIAS.CDX", "lSelDoc", "lSelDoc", {|| Field->lSelDoc } ) )

      ( dbfFamilia )->( ordCondSet("!Deleted()", {|| !Deleted() }  ) )
      ( dbfFamilia )->( ordCreate( cPath + "FAMILIAS.CDX", "cCodWeb", "Str( Field->cCodWeb, 11 )", {|| Str( Field->cCodWeb, 11 ) } ) )

      ( dbfFamilia )->( ordCondSet("!Deleted()", {|| !Deleted() }  ) )
      ( dbfFamilia )->( ordCreate( cPath + "FAMILIAS.CDX", "cFamCmb", "cFamCmb", {|| Field->cFamCmb } ) )

      ( dbfFamilia )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de familias" )
   end if

   dbUseArea( .t., cDriver, cPath + "FamPrv.Dbf", cCheckArea( "FAMPRV", @dbfFamilia ), .f. )
   if !( dbfFamilia )->( neterr() )
      ( dbfFamilia )->( __dbPack() )

      ( dbfFamilia )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfFamilia )->( ordCreate( cPath + "FamPrv.Cdx", "cCodFam", "cCodFam", {|| Field->cCodFam }, ) )

      ( dbfFamilia )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfFamilia )->( ordCreate( cPath + "FamPrv.Cdx", "cFamPrv", "cCodPrv + cFamPrv", {|| Field->cCodPrv + Field->cFamPrv } ) )

      ( dbfFamilia )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de familias" )
   end if

RETURN NIL

//--------------------------------------------------------------------------//

Function aItmFamPrv()

   local aBase := {  {"CCODFAM",    "C",    16,    0, "Código de familia" },;
                     {"CCODPRV",    "C",    12,    0, "Código de proveedor" },;
                     {"CFAMPRV",    "C",    20,    0, "Código de familia del proveedor" } }

return ( aBase )

//---------------------------------------------------------------------------//

Function aItmFam()

   local aBase := {  {"CCODFAM",    "C",    16,    0, "Código de familia" },;
                     {"CNOMFAM",    "C",    40,    0, "Nombre de familia" },;
                     {"CCODPRP1",   "C",    10,    0, "Primera propiedad de la familia" },;
                     {"CCODPRP2",   "C",    10,    0, "Segunda propiedad de la familia" },;
                     {"CCODGRP",    "C",     3,    0, "Código de grupo" },;
                     {"LINCTPV",    "L",     1,    0, "Incluir en TPV táctil" },;
                     {"NVALANU",    "N",    16,    6, "Previsiones anual" },;
                     {"NENE",       "N",    16,    6, "Previsiones Enero" },;
                     {"NFEB",       "N",    16,    6, "Previsiones Febrero" },;
                     {"NMAR",       "N",    16,    6, "Previsiones Marzo" },;
                     {"NABR",       "N",    16,    6, "Previsiones Abril" },;
                     {"NMAY",       "N",    16,    6, "Previsiones Mayo" },;
                     {"NJUN",       "N",    16,    6, "Previsiones Junio" },;
                     {"NJUL",       "N",    16,    6, "Previsiones Julio" },;
                     {"NAGO",       "N",    16,    6, "Previsiones Agosto" },;
                     {"NSEP",       "N",    16,    6, "Previsiones Septiembre" },;
                     {"NOCT",       "N",    16,    6, "Previsiones Octubre" },;
                     {"NNOV",       "N",    16,    6, "Previsiones Noviembre" },;
                     {"NDIC",       "N",    16,    6, "Previsiones Diciembre" },;
                     {"nDtoLin",    "N",     6,    2, "Porcentaje de descuento por familia" },;
                     {"NPCTRPL",    "N",     6,    2, "Porcentaje de rapels" },;
                     {"LPUBINT",    "L",     1,    0, "Publicar esta familia en internet" },;
                     {"NCOLBTN",    "N",    10,    0, "Color del botón" },;
                     {"CIMGBTN",    "C",   250,    0, "Imagen del botón" },;
                     {"lSelDoc",    "L",     1,    0, "Lógico para seleccionado" },;
                     {"lPreEsp",    "L",     1,    0, "Lógico para permitir precios especiales" },;
                     {"cCodFra",    "C",     3,    0, "Código de frases publiciarias" },;
                     {"lInfStk",    "L",     1,    0, "Incluir en informe de stocks bajo minimos" },;
                     {"cFamCmb",    "C",    16,    0, "Familia para combinar" },;
                     {"nPosTpv",    "N",     4,    1, "Posición para mostrar en TPV" },;
                     {"cCodWeb",    "N",    11,    0, "Código para la web" },;
                     {"lAcum",      "L",     1,    0, "Lógico para acumular árticulos" },;
                     {"lMostrar",   "L",     1,    0, "Lógico para mostrar ventana de comentarios" },;
                     {"cCodImp",    "C",     3,    0, "Codigo del orden de impresion comanda" },;
                     {"cNomImp",    "C",    50,    0, "Nombre del orden de impresion comanda" },;
                     {"nPosInt",    "N",     3,    0, "Pocisión para mostrar en internet" },;
                     {"lFamInt",    "L",     1,    0, "Añade la familia junto con la descripción en internet" },;
                     {"cComFam",    "C",     3,    0, "Comentario por defecto para la familia" },;
                     {"cDesWeb",    "C",   250,    0, "Descripción para la web" },;
                     {"nDiaGrt",    "N",     6,    0, "Días de garantía" } }

return ( aBase )

//---------------------------------------------------------------------------//

Function lPressCol( nCol, oBrw, oCmbOrd, aCbxOrd, cDbf )

   local nPos
   local cHeader

   if !Empty( nCol ) .and. nCol <= len( oBrw:aHeaders )
      cHeader     := oBrw:aHeaders[ nCol ]
      nPos        := aScan( aCbxOrd, cHeader )

      if nPos != 0

         oCmbOrd:Set( cHeader )
         ( cDbf )->( OrdSetFocus( oCmbOrd:nAt ) )

         oBrw:Refresh()

      end if

   end if

return nil

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

Static Function lValidFamiliaCombinado( aTmp )

   local lValid   := .t.

   if !Empty( aTmp[ _CCODFAM ] ) .and.;
      !Empty( aTmp[ _CFAMCMB ] ) .and.;
      ( aTmp[ _CCODFAM ] == aTmp[ _CFAMCMB ] )

      lValid      := .f.

      MsgStop( "Código de familia no puede ser igual al combinado" )

   end if

return ( lValid )

//---------------------------------------------------------------------------//

FUNCTION retFamilia( cCodFam, uFamilia )

   local oBlock
   local oError
   local lClose   := .f.
	local cTemp		:= Space( 30 )

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if Empty( uFamilia )
      USE ( cPatArt() + "FAMILIAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FAMILIAS", @uFamilia ) )
      SET ADSINDEX TO ( cPatArt() + "FAMILIAS.CDX" ) ADDITIVE
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

FUNCTION cFamilia( oGet, dbfFamilia, oGet2, lMessage, oGetPrp1, oGetPrp2 )

   local nRec
   local oBlock
   local oError
   local lValid      := .f.
   local lClose      := .f.
   local xValor      := oGet:varGet()

   DEFAULT lMessage  := .t.

   if Empty( xValor ) .or. ( xValor == Replicate( "Z", 16 ) )
      return .t.
   end if

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if Empty( dbfFamilia )
      USE ( cPatArt() + "FAMILIAS.DBF" ) NEW VIA ( cDriver() ) SHARED   ALIAS ( cCheckArea( "FAMILIAS", @dbfFamilia ) )
      SET ADSINDEX TO ( cPatArt() + "FAMILIAS.CDX" ) ADDITIVE
      lClose         := .t.
   else
      nRec           := ( dbfFamilia )->( Recno() )
   end if

   if dbSeekInOrd( xValor, "cCodFam", dbfFamilia )

      if !Empty( oGet )
         oGet:cText( ( dbfFamilia )->cCodFam )
      end if

      if !Empty( oGet2 )
         oGet2:cText( ( dbfFamilia )->cNomFam )
      end if

      if !Empty( oGetPrp1 ) .and. Empty( oGetPrp1:VarGet() )
         oGetPrp1:cText( ( dbfFamilia )->cCodPrp1 )
         oGetPrp1:lValid()
      end if

      if !Empty( oGetPrp2 ) .and. Empty( oGetPrp2:VarGet() )
         oGetPrp2:cText( ( dbfFamilia )->cCodPrp2 )
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
      CLOSE ( dbfFamilia )
   else
      ( dbfFamilia )->( dbGoTo( nRec ) )
   end if

RETURN lValid

//---------------------------------------------------------------------------//

FUNCTION getCodigoWebFamiliaPadre( oFamilia )

   local cCodigoPadre            := oFamilia:cFamCmb
   local cCodigoWebFamiliaPadre  := 2

   if empty( cCodigoPadre )
      Return ( 2 )      // id Prestashop inicio categories
   end if 

   oFamilia:getStatus()
   if oFamilia:seekInOrd( cCodigoPadre, "cCodFam" )
      if oFamilia:lPubInt .and. oFamilia:cCodWeb != 0
         cCodigoWebFamiliaPadre  := oFamilia:cCodWeb
      end if 
   end if
   oFamilia:setStatus()

RETURN ( cCodigoWebFamiliaPadre )

//---------------------------------------------------------------------------//

Static Function ChangePosition( lInc )

   local aPos
   local nPos     := 1
   local aRec     := {}
   local nRec     := ( dbfFamilia )->( Recno() )
   local nOrd     := ( dbfFamilia )->( OrdSetFocus( "nPosTpv" ) )

   CursorWait()

   do case
      case IsTrue( lInc )

         if ( dbfFamilia )->( dbRLock() )
            ( dbfFamilia )->nPosTpv   := ( dbfFamilia )->nPosTpv + 1.5
         end if
         ( dbfFamilia )->( dbUnLock() )

      case IsFalse( lInc )

         if ( dbfFamilia )->( dbRLock() )
            ( dbfFamilia )->nPosTpv   := ( dbfFamilia )->nPosTpv - 1.5
         end if
         ( dbfFamilia )->( dbUnLock() )

   end case

   //--------------------------------------------------------------------------

   ( dbfFamilia )->( dbGoTop() )
   while !( dbfFamilia )->( eof() )

      if ( dbfFamilia )->lIncTpv
         aAdd( aRec, { ( dbfFamilia )->( Recno() ), nPos++ } )
      end if

      ( dbfFamilia )->( dbSkip() )

   end while

   //--------------------------------------------------------------------------

   for each aPos in aRec

      ( dbfFamilia )->( dbGoTo( aPos[ 1 ] ) )

      if ( dbfFamilia )->( dbRLock() )
         ( dbfFamilia )->nPosTpv      := aPos[ 2 ]
         ( dbfFamilia )->( dbUnLock() )
      end if

   next

   //--------------------------------------------------------------------------

   CursorWE()

   ( dbfFamilia )->( dbGoTo( nRec ) )
   ( dbfFamilia )->( OrdSetFocus( nOrd ) )

Return ( nil )

//---------------------------------------------------------------------------//

Function ColorFam( oGetColor )

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
        RESOURCE "color_wheel_48_alpha" ;
        TRANSPARENT ;
        OF       oDlg

     REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         ACTION   ( oDlg:End() )

   ACTIVATE DIALOG oDlg CENTER

Return .t.

//---------------------------------------------------------------------------//

Function SeleccionaColor( oImgColores, oGetColor, oDlg )

   local nOpt  := oImgColores:nOption

   if Empty( nOpt )
      MsgStop( "Seleccione un color" )
      Return .f.
   end if

   nOpt        := Max( Min( nOpt, len( oImgColores:aItems ) ), 1 )

   if nOpt > 0 .and. nOpt <= len( oImgColores:aItems )
      oGetColor:cText( oImgColores:aItems[ nOpt ]:nClrPane )
      oGetColor:SetColor( oImgColores:aItems[ nOpt ]:nClrPane, oImgColores:aItems[ nOpt ]:nClrPane )
    end if

   oDlg:End()

Return .t.

//---------------------------------------------------------------------------//

Function AppFamilia( lOpenBrowse )

   local oBlock
   local oError
   local nLevel         := nLevelUsr( MENUOPTION )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_APPD ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   oBlock               := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if lOpenBrowse

         if Familia()
            oWndBrw:RecAdd()
         end if

      else

         if OpenFiles( .t. )
            WinAppRec( oWndBrw, bEdit, dbfFamilia )
            CloseFiles()
         end if

      end if

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Error añadiendo artículo" )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN .t.

//--------------------------------------------------------------------------//