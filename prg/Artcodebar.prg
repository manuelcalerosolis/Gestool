#ifndef __PDA__
#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Folder.ch"
#include "Label.ch"
#include "Image.ch"
#else
#include "FWCE.ch"
REQUEST DBFCDX
#endif

#ifndef __PDA__
static oWndBrw
static dbfArticulo
static dbfCodebar

static filTmpCodebar
static dbfTmpCodebar

static lOpenFiles := .f.

static bEdit      := { |aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode          | EdtRec( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode ) }
static bEdtCod    := { |aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, cCodArt | EdtCodebar( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, cCodArt ) }
#endif

#ifndef __PDA__

//---------------------------------------------------------------------------//
//Funciones del programa normal
//---------------------------------------------------------------------------//

STATIC FUNCTION OpenFiles()

   local oError
   local oBlock

   if lOpenFiles
      MsgStop( 'Imposible abrir ficheros de art�culos' )
      Return ( .f. )
   end if

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   USE ( cPatEmp() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
   SET ADSINDEX TO ( cPatEmp() + "ARTICULO.CDX" ) ADDITIVE

   USE ( cPatEmp() + "ArtCodebar.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CODEBAR", @dbfCodebar ) )
   SET ADSINDEX TO ( cPatEmp() + "ArtCodebar.Cdx" ) ADDITIVE

   lOpenFiles  := .t.

   RECOVER USING oError

   msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )
   CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpenFiles )

//--------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles( lDestroy )

	DEFAULT lDestroy	:= .f.

   if lDestroy
      oWndBrw        := nil
   end if

   if dbfArticulo != nil
      ( dbfArticulo )->( dbCloseArea() )
   end if

   if dbfCodebar != nil
      ( dbfCodebar )->( dbCloseArea() )
   end if

   dbfArticulo       := nil
   dbfCodebar        := nil

   lOpenFiles  := .f.

RETURN ( .t. )

//----------------------------------------------------------------------------//

FUNCTION ArtCodebar( oMenuItem, oWnd )

   local nLevel

   DEFAULT  oMenuItem   := "01024"
   DEFAULT  oWnd        := oWnd()

   if oWndBrw == NIL

      /*
      Obtenemos el nivel de acceso---------------------------------------------
      */

      nLevel            := Auth():Level( oMenuItem )

      if nAnd( nLevel, 1 ) == 0
         msgStop( "Acceso no permitido." )
         return nil
      end if

      /*
      Cerramos todas las ventanas----------------------------------------------
      */

      if oWnd != nil
         SysRefresh(); oWnd:CloseAll(); SysRefresh()
      end if

      /*
      Apertura de ficheros-----------------------------------------------------
      */

      if !OpenFiles()
         return nil
      end if

      /*
      Anotamos el movimiento para el navegador---------------------------------
      */

      AddMnuNext( "Codigos de barras", ProcName() )

      DEFINE SHELL oWndBrw FROM 0, 0 TO 22, 80 ;
         XBROWSE ;
         TITLE    "Codigos de barras" ;
         MRU      "gc_portable_barcode_scanner_16";
         PROMPT   "C�digo",;
                  "Nombre" ;
         ALIAS    ( dbfArticulo ) ;
         EDIT     ( WinEdtRec( oWndBrw:oBrw, bEdit, dbfArticulo ) ) ;
         LEVEL    nLevel ;
         OF       oWnd

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "C�digo"
         :cSortOrder       := "Codigo"
         :bEditValue       := {|| ( dbfArticulo )->Codigo }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "Nombre"
         :bEditValue       := {|| ( dbfArticulo )->Nombre }
         :nWidth           := 260
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      oWndBrw:CreateXFromCode()

      oWndBrw:cHtmlHelp    := "Articulos"

      DEFINE BTNSHELL RESOURCE "BUS" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:SearchSetFocus() ) ;
			TOOLTIP 	"(B)uscar" ;
         HOTKEY   "B"

      oWndBrw:AddSeaBar()

      DEFINE BTNSHELL RESOURCE "BUS" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( SearchArtCodeBar( oWndBrw ) ) ;
         TOOLTIP  "Busca(r)..." ;
         HOTKEY   "R"

		DEFINE BTNSHELL RESOURCE "EDIT" OF oWndBrw ;
			NOBORDER ;
			ACTION  	( oWndBrw:RecEdit() );
         TOOLTIP  "(M)odificar";
         HOTKEY   "M";
         LEVEL    ACC_EDIT

#ifndef __TACTIL__

      DEFINE BTNSHELL RESOURCE "IMP" GROUP OF oWndBrw ;
			NOBORDER ;
         ACTION   ( TInfChgCbr():New( "Listado de �ltimos c�digos de barra modificados" ):Play() );
         TOOLTIP  "Lis(t)ado";
         HOTKEY   "T" ;
         LEVEL    ACC_IMPR

#endif

      DEFINE BTNSHELL RESOURCE "END" GROUP OF oWndBrw ;
         NOBORDER ;
			ACTION 	( oWndBrw:End() ) ;
			TOOLTIP 	"(S)alir" ;
			HOTKEY 	"S"

      ACTIVATE WINDOW oWndBrw VALID ( CloseFiles(.t.) )

	ELSE

		oWndBrw:setFocus()

	END IF

RETURN ( oWndBrw )

//--------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aTmp, aGet, dbfArticulo, oWndBrw, bWhen, bValid, nMode )

	local oDlg
   local oFnt
   local oSay
   local oBrw
   local aBar        := { "Ean13", "Code39", "Code128" }
   local aBtn        := Array( 3 )
   local aNom        := Array( 3 )
   local cSay        := ""


   BeginTrans( aTmp, nMode )

	/*
   Cargamos los precios en sus variables---------------------------------------
	*/

   DEFINE DIALOG oDlg RESOURCE "ArtCodebar" TITLE LblTitle( nMode ) + "c�digos de barras"

   REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "Codigo" ) ) ];
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "Codigo" ) ) ];
			ID 		110 ;
         PICTURE  "@!" ;
         WHEN     ( .f. ) ;
         OF       oDlg

   REDEFINE GET   aGet[( dbfArticulo )->( fieldpos( "NOMBRE" ) ) ] ;
         VAR      aTmp[( dbfArticulo )->( fieldpos( "NOMBRE" ) ) ];
			ID 		130 ;
         WHEN     ( .f. ) ;
         OF       oDlg

   REDEFINE SAY aNom[1] ;
         ID       410 ;
         OF       oDlg

   REDEFINE GET   aGet[( dbfArticulo )->( fieldpos( "CODEBAR" ) ) ] ;
         VAR      aTmp[( dbfArticulo )->( fieldpos( "CODEBAR" ) ) ] ;
         ID       411 ;
         VALID    ( drwBar( aGet[ ( dbfArticulo )->( fieldpos( "CODEBAR" ) ) ], aGet[( dbfArticulo )->( fieldpos( "NTIPBAR" ) ) ]:nAt, oSay, oFnt ) ) ;
         OF       oDlg

   REDEFINE SAY aNom[2] ;
         ID       420 ;
         OF       oDlg

   REDEFINE COMBOBOX aGet[( dbfArticulo )->( fieldpos( "NTIPBAR" ) ) ] VAR aTmp[( dbfArticulo )->( fieldpos( "NTIPBAR" ) ) ] ;
         ITEMS    aBar ;
         ID       421 ;
         ON CHANGE( drwBar( aGet[( dbfArticulo )->( fieldpos( "CODEBAR" ) ) ], aGet[( dbfArticulo )->( fieldpos( "NTIPBAR" ) ) ]:nAt, oSay ) );
         VALID    ( drwBar( aGet[( dbfArticulo )->( fieldpos( "CODEBAR" ) ) ], aGet[( dbfArticulo )->( fieldpos( "NTIPBAR" ) ) ]:nAt, oSay ) );
         OF       oDlg

   REDEFINE SAY aNom[3] ;
         ID       430 ;
         OF       oDlg

   REDEFINE SAY oSay VAR cSay ;
         ID       431;
         FONT     oFnt ;
         OF       oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfTmpCodebar
      oBrw:nMarqueeStyle   := 5
      oBrw:lHScroll        := .f.

      with object ( oBrw:AddCol() )
         :cHeader          := ""
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfTmpCodebar )->lDefBar }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "C�digo de barras"
         :bEditValue       := {|| ( dbfTmpCodebar )->cCodBar }
         :nWidth           := 240
      end with

      oBrw:bRClicked       := {| nRow, nCol, nFlags | oBrw:RButtonDown( nRow, nCol, nFlags ) }
      oBrw:bLDblClick      := {|| WinEdtRec( oBrw, bEdtCod, dbfTmpCodebar, , , aTmp ) }

      oBrw:CreateFromResource( 330 )

   REDEFINE BUTTON aBtn[ 1 ] ;
         ID       300 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinAppRec( oBrw, bEdtCod, dbfTmpCodebar, , , aTmp ) )

   REDEFINE BUTTON aBtn[ 2 ] ;
         ID       310 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinEdtRec( oBrw, bEdtCod, dbfTmpCodebar, , , aTmp ) )

   REDEFINE BUTTON aBtn[ 3 ] ;
         ID       320 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( dbDelRec( oBrw, dbfTmpCodebar ) )

   /*
	Botones de la Caja de Dialogo
	------------------------------------------------------------------------
   */

   REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         ACTION   ( EndTrans( aTmp, aGet, oDlg, nMode ) )

	REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F2, {|| WinAppRec( oBrw, bEdtCod, dbfTmpCodebar, , , aTmp ) } )
      oDlg:AddFastKey( VK_F3, {|| WinEdtRec( oBrw, bEdtCod, dbfTmpCodebar, , , aTmp ) } )
      oDlg:AddFastKey( VK_F4, {|| dbDelRec( oBrw, dbfTmpCodebar ) } )
      oDlg:AddFastKey( VK_F5, {|| EndTrans( aTmp, aGet, oDlg, nMode ) } )
   end if

   oDlg:bStart := {|| StartDlg( aGet, oSay, aNom, aBtn, oBrw ) }

   ACTIVATE DIALOG oDlg CENTER

   /*
   Filtros para los stocks-----------------------------------------------------
   */

   KillTrans()

Return ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Static Function StartDlg( aGet, oSay, aNom, aBtn, oBrw )

   if lMultipleCodeBar()

      aBtn[1]:Show()
      aBtn[2]:Show()
      aBtn[3]:Show()
      aGet[ ( dbfArticulo )->( fieldpos( "CODEBAR" ) ) ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "NTIPBAR" ) ) ]:Hide()
      aNom[1]:Hide()
      aNom[2]:Hide()
      aNom[3]:Hide()

      oBrw:Show()
      oSay:Hide()

   else

      aBtn[1]:Hide()
      aBtn[2]:Hide()
      aBtn[3]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "CODEBAR" ) ) ]:Show()
      aGet[ ( dbfArticulo )->( fieldpos( "NTIPBAR" ) ) ]:Show()
      aNom[1]:Show()
      aNom[2]:Show()
      aNom[3]:Show()

      oBrw:Hide()
      oSay:Show()

   end if

   oBrw:SetFocus()

Return ( .t. )

//--------------------------------------------------------------------------//

Static Function BeginTrans( aTmp, nMode )

   local oBlock
   local oError
   local cCodArt     := aTmp[ ( dbfArticulo )->( fieldpos( "Codigo" ) ) ]

   filTmpCodebar     := cGetNewFileName( cPatTmp() + "ArtCodebar" )

   /*
   Codigos de barras
   */

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   dbCreate( filTmpCodebar, aItmBar(), cLocalDriver() )

   dbUseArea( .t., cLocalDriver(), filTmpCodebar, cCheckArea( "CodBar", @dbfTmpCodebar ), .f. )

   ( dbfTmpCodebar )->( OrdCondSet( "!Deleted()", {|| !Deleted() } ) )
   ( dbfTmpCodebar )->( OrdCreate( filTmpCodebar, "cCodBar", "cCodBar", {|| Field->cCodBar } ) )

   if ( dbfCodebar )->( dbSeek( cCodArt ) )

      while ( dbfCodebar )->cCodArt == cCodArt .and. !( dbfCodebar )->( eof() )
         dbPass( dbfCodebar, dbfTmpCodebar, .t. )
         ( dbfCodebar )->( dbSkip() )
      end while

      ( dbfTmpCodebar )->( dbGoTop() )

   end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos de agentes" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return Nil

//--------------------------------------------------------------------------//

Static Function EndTrans( aTmp, aGet, oDlg, nMode )

   local cCod     := aTmp[ ( dbfArticulo )->( fieldpos( "Codigo" ) ) ]
   local cCodArt

   /*
   Codigos de barras
   */

   while ( dbfCodebar )->( dbSeek( cCod ) ) .and. !( dbfCodebar )->( eof() )
      if dbLock( dbfCodebar )
         ( dbfCodebar )->( dbDelete() )
         ( dbfCodebar )->( dbUnLock() )
      end if
   end while

   /*
   Pasamos los temporales a los ficheros definitivos---------------------------
   */

   ( dbfTmpCodebar )->( OrdSetFocus( 0 ) )
   ( dbfTmpCodebar )->( dbGoTop() )
   cCodArt        := ( dbfTmpCodebar )->cCodBar
   while !( dbfTmpCodebar )->( eof() )
      ( dbfTmpCodebar )->cCodArt := cCod
      if ( dbfTmpCodebar )->lDefBar
         cCodArt                 := ( dbfTmpCodebar )->cCodBar
      end if
       dbPass( dbfTmpCodebar, dbfCodebar, .t. )
      ( dbfTmpCodebar )->( dbSkip() )
   end while

   /*
   Tomamos algunos valores
   */

   aTmp[ ( dbfArticulo )->( fieldpos( "dFecChg" ) ) ]    := GetSysDate()
   aTmp[ ( dbfArticulo )->( fieldpos( "LastChg" ) ) ]    := GetSysDate()

   WinGather( aTmp, aGet, dbfArticulo, nil, nMode )

Return ( oDlg:end( IDOK ) )

//-----------------------------------------------------------------------//

Static Function KillTrans()

   if !Empty( dbfTmpCodebar ) .and. ( dbfTmpCodebar )->( Used() )
      ( dbfTmpCodebar )->( dbCloseArea() )
   end if

   dbfTmpCodebar  := nil

   dbfErase( filTmpCodebar )

Return Nil

//------------------------------------------------------------------------//
/*
Edita las asociaciones con los codigos de barras
*/

STATIC FUNCTION EdtCodebar( aTmp, aGet, dbfTmpCodebar, oBrw, bWhen, bValid, nMode )

	local oDlg
   local oFnt
   local oSayCodebar
   local cSayCodebar    := ""
   local cOldCodebar    := aTmp[ ( dbfTmpCodebar )->( fieldPos( "cCodBar" ) ) ]

   DEFINE DIALOG oDlg RESOURCE "ArtCode" TITLE LblTitle( nMode ) + "codigos de barras"

   REDEFINE GET   aGet[ ( dbfTmpCodebar )->( fieldPos( "cCodBar" ) ) ] ;
         VAR      aTmp[ ( dbfTmpCodebar )->( fieldPos( "cCodBar" ) ) ] ;
         ID       100 ;
         OF       oDlg

   REDEFINE CHECKBOX aTmp[ ( dbfTmpCodebar )->( fieldpos( "lDefBar" ) ) ] ;
         ID       130 ;
         OF       oDlg

   REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( SaveCodebar( aTmp, aGet, cOldCodebar, oBrw, oDlg, dbfTmpCodebar, nMode ) )

	REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| SaveCodebar( aTmp, aGet, cOldCodebar, oBrw, oDlg, dbfTmpCodebar, nMode ) } )

   ACTIVATE DIALOG oDlg ON INIT ( EvalGet( aGet ) ) CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Static Function SaveCodebar( aTmp, aGet, cOldCodebar, oBrw, oDlg, dbfTmpCodebar, nMode )

   local nRec

   if dbSeekCodebar( aTmp[ ( dbfTmpCodebar )->( fieldPos( "cCodBar" ) ) ], dbfTmpCodebar, cOldCodebar, .t. )
      aGet[ ( dbfTmpCodebar )->( fieldPos( "cCodBar" ) ) ]:SetFocus()
      return nil
   end if

   if aTmp[ ( dbfTmpCodebar )->( fieldpos( "lDefBar" ) ) ]

      nRec     := ( dbfTmpCodebar )->( Recno() )

      ( dbfTmpCodebar )->( dbGoTop() )
      while !( dbfTmpCodebar )->( eof() )
         ( dbfTmpCodebar )->lDefBar  := .f.
         ( dbfTmpCodebar )->( dbSkip() )
      end while

      ( dbfTmpCodebar )->( dbGoTo( nRec ) )

   end if

   WinGather( aTmp, aGet, dbfTmpCodebar, oBrw, nMode )

   oDlg:end( IDOK )

Return nil

//---------------------------------------------------------------------------//


Static Function SearchArtCodeBar( oWndBrw )

	local oDlg
   local oGetBar
   local cGetBar  := Space( 18 )

   DEFINE DIALOG oDlg RESOURCE "SeaCodebar"

      REDEFINE GET oGetBar VAR cGetBar ;
         ID       130 ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       500 ;
         OF       oDlg ;
         ACTION   ( SeekArtCodeBar( cGetBar, dbfCodeBar, oWndBrw ) )

      REDEFINE BUTTON ;
         ID       510 ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

   ACTIVATE DIALOG oDlg CENTER

RETURN NIL

//---------------------------------------------------------------------------//

Static Function SeekArtCodeBar( cGetBar, dbfCodeBar, oWndBrw )

   local nOrd
   local nCod  := ( dbfCodeBar )->( OrdSetFocus( "cCodBar" ) )

   if ( dbfCodeBar )->( dbSeek( cGetBar ) )
      nOrd  := ( dbfArticulo )->( OrdSetFocus( "Codigo" ) )
      if !( dbfArticulo )->( dbSeek( ( dbfCodeBar )->cCodArt ) )
         msgStop( "Art�culo " + Rtrim( ( dbfCodeBar )->cCodArt ) + " no encontrado." )
      else
         oWndBrw:Refresh()
      end if
      ( dbfArticulo )->( OrdSetFocus( nOrd ) )
   else
      msgStop( "C�digo de barras " + Rtrim( cGetBar ) + " no encontrado." )
   end if
   ( dbfCodeBar )->( OrdSetFocus( nCod ) )

RETURN NIL

//---------------------------------------------------------------------------//

Function EdtArtCodeBar( cCodArt, oBrw )

   local nLevel   := Auth():Level( "01024" )

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_EDIT ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if !OpenFiles()
      CloseFiles()
      return nil
   end if

   if ( dbfArticulo )->( dbSeek( cCodArt ) )
      WinEdtRec( nil, bEdit, dbfArticulo )
   else
      MsgStop( "No se encuentra art�culo" )
   end if

   if oBrw != nil
      oBrw:Refresh()
   end if

   CloseFiles()

Return .t.

//--------------------------------------------------------------------------//

#endif

//---------------------------------------------------------------------------//
//Funciones del programa normal y del PDA
//---------------------------------------------------------------------------//

Function aItmBar()

   local aBase := {}

   aAdd( aBase, { "cCodArt",  "C", 18, 0, "C�digo de art�culo"                   , "", "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodBar",  "C", 20, 0, "C�digo de barras"                     , "", "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nTipBar",  "N",  2, 0, "Tipo de c�digo de barras"             , "", "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lDefBar",  "L",  1, 0, "C�digo de barras por defecto"         , "", "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodPr1",  "C", 20, 0, "C�digo de primera propiedad"          , "", "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodPr2",  "C", 20, 0, "C�digo de segunda propiedad"          , "", "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cValPr1",  "C", 20, 0, "Valor de primera propiedad"           , "", "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cValPr2",  "C", 20, 0, "Valor de segunda propiedad"           , "", "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cPrvHab",  "C", 12, 0, "Proveedor habitual"                   , "", "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cRefPrv",  "C", 18, 0, "Referencia del proveedor al art�culo" , "", "", "( cDbfArt )", nil } )

Return ( aBase )

//---------------------------------------------------------------------------//

function cCodigoBarrasDefecto( cCodArt, dbfCodeBar )

   local cCodigoBarras     := ""
   local nRec              := ( dbfCodeBar )->( Recno() )
   local nOrdAnt           := ( dbfCodeBar )->( OrdSetFocus( "cCodArt" ) )

   if ( dbfCodeBar )->( dbSeek( cCodArt ) )

      while ( dbfCodeBar )->cCodArt == cCodArt .and. !( dbfCodeBar )->( Eof() )


         if ( dbfCodeBar )->lDefBar

            cCodigoBarras  := ( dbfCodeBar )->cCodBar

         end if

         ( dbfCodeBar )->( dbSkip() )

      end while

   end if

   ( dbfCodeBar )->( OrdSetFocus( nOrdAnt ) )

   ( dbfCodeBar )->( dbGoTo( nRec ) )

return cCodigoBarras

//---------------------------------------------------------------------------//