#ifndef __PDA__
   #include "FiveWin.Ch"
   #include "Font.ch"
   #include "Report.ch"
#else
   #include "FWCE.ch"
   REQUEST DBFCDX
#endif

#include "Factu.ch" 

#define _CCODRUT                  1      //   C      4     0
#define _CDESRUT                  2      //   C     30     0
#define _LSELRUT                  3      //   C     30     0

#ifndef __PDA__
   static oWndBrw
   static bEdit         := { |aTemp, aoGet, dbfRuta, oBrw, bWhen, bValid, nMode | EdtRec( aTemp, aoGet, dbfRuta, oBrw, bWhen, bValid, nMode ) }
#endif

static dbfRuta

#ifndef __PDA__

//----------------------------------------------------------------------------//
//Funciones del programa
//----------------------------------------------------------------------------//


STATIC FUNCTION OpenFiles( cPatEmp )

   local lOpen       := .t.
   local oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT cPatEmp   := cPatEmp()

   BEGIN SEQUENCE

      USE ( cPatCli() + "RUTA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "RUTA", @dbfRuta ) )
      SET ADSINDEX TO ( cPatCli() + "RUTA.CDX" ) ADDITIVE

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos rutas" )

      CloseFiles()

      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN lOpen

//----------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles()

   oWndBrw  := nil

   CLOSE ( dbfRuta )

   dbfRuta  := nil

RETURN ( .t. )

//----------------------------------------------------------------------------//

FUNCTION Ruta( oMenuItem, oWnd )

   local nLevel

   DEFAULT  oMenuItem   := "01031"
   DEFAULT  oWnd        := oWnd()

	IF oWndBrw == NIL

   nLevel               := Auth():Level( oMenuItem )

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
   Anotamos el movimiento para el navegador
   */

   AddMnuNext( "Rutas", ProcName() )

   if !OpenFiles()
      return nil
   end if

   DEFINE SHELL oWndBrw FROM 2, 10 TO 18, 70;
      XBROWSE ;
		TITLE 	"Rutas" ;
      PROMPT   "Código",;
					"Nombre";
      MRU      "gc_signpost2_16";
		ALIAS		( dbfRuta ) ;
      APPEND   ( WinAppRec( oWndBrw:oBrw, bEdit, dbfRuta ) );
      DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdit, dbfRuta ) );
		EDIT 		( WinEdtRec( oWndBrw:oBrw, bEdit, dbfRuta ) ) ;
		DELETE   ( DBDelRec(  oWndBrw:oBrw, dbfRuta ) ) ;
      LEVEL    nLevel ;
      OF       oWnd

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodRut"
         :bEditValue       := {|| ( dbfRuta )->cCodRut }
         :nWidth           := 60
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cDesRut"
         :bEditValue       := {|| ( dbfRuta )->cDesRut }
         :nWidth           := 260
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      oWndBrw:CreateXFromCode()

      DEFINE BTNSHELL RESOURCE "BUS" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:SearchSetFocus() ) ;
			TOOLTIP 	"(B)uscar";
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
         MRU ;
			TOOLTIP 	"(D)uplicar";
         HOTKEY   "D" ;
         LEVEL    ACC_APPD

		DEFINE BTNSHELL RESOURCE "EDIT" OF oWndBrw ;
			NOBORDER ;
			ACTION  	( oWndBrw:RecEdit() );
         MRU ;
         TOOLTIP  "(M)odificar";
         HOTKEY   "M" ;
         LEVEL    ACC_EDIT

		DEFINE BTNSHELL RESOURCE "ZOOM" OF oWndBrw ;
			NOBORDER ;
			ACTION  	( WinZooRec( oWndBrw:oBrw, bEdit, dbfRuta ) );
			TOOLTIP 	"(Z)oom";
         MRU ;
         HOTKEY   "Z" ;
         LEVEL    ACC_ZOOM

		DEFINE BTNSHELL RESOURCE "DEL" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( oWndBrw:RecDel() );
         MRU ;
         TOOLTIP  "(E)liminar";
         HOTKEY   "E" ;
         LEVEL    ACC_DELE

#ifndef __TACTIL__

      DEFINE BTNSHELL RESOURCE "IMP" OF oWndBrw ;
			NOBORDER ;
         ACTION ( InfRut():New( "Listado de rutas" ):Play() ) ;
			TOOLTIP "(L)istado" ;
         HOTKEY   "L" ;
         LEVEL    ACC_ZOOM

#endif

      DEFINE BTNSHELL RESOURCE "END" GROUP OF oWndBrw ;
			NOBORDER ;
			ACTION ( oWndBrw:End() ) ;
			TOOLTIP "(S)alir" ;
			HOTKEY 	"S"

      ACTIVATE WINDOW oWndBrw VALID ( CloseFiles() )

	ELSE

		oWndBrw:SetFocus()

	END IF

RETURN NIL

//----------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aTemp, aoGet, dbfRuta, oBrw, bWhen, bValid, nMode )

	local oDlg
	local oGet

	DEFINE DIALOG oDlg RESOURCE "RUTA" TITLE LblTitle( nMode ) + "Rutas"

		REDEFINE GET oGet VAR aTemp[ _CCODRUT ] ;
         ID       101 ;
         WHEN     ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) ;
         VALID    ( NotValid( oGet, dbfRuta ) ) ;
         OF       oDlg

		REDEFINE GET aoGet[ _CDESRUT ] ;
         VAR      aTemp[ _CDESRUT ];
         ID       102 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@!" ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( lPreSave( aTemp, aoGet, dbfRuta, oBrw, nMode, oDlg, oGet ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         ACTION   ( oDlg:end() )

   REDEFINE BUTTON ;
         ID       559 ;
			OF 		oDlg ;
         ACTION   ( ChmHelp( "Ruta" ) )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| if( nMode == DUPL_MODE, if( oGet:lValid(), lPreSave( aTemp, aoGet, dbfRuta, oBrw, nMode, oDlg, oGet ), ), lPreSave( aTemp, aoGet, dbfRuta, oBrw, nMode, oDlg, oGet ) ) } )
   end if

   oDlg:AddFastKey ( VK_F1, {|| ChmHelp( "Ruta" ) } )

   oDlg:bStart := {|| oGet:SetFocus() }

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

STATIC FUNCTION lPreSave( aTemp, aoGet, dbfRuta, oBrw, nMode, oDlg, oGet )

   if nMode == APPD_MODE .or. nMode == DUPL_MODE

      if Empty( aTemp[_CCODRUT] )
         MsgStop( "El código de la ruta no puede estar vacío." )
         oGet:SetFocus()
         Return .f.
      end if

      if dbSeekInOrd( aTemp[ _CCODRUT ], "CCODRUT", dbfRuta )
         msgStop( "Código existente" )
         return nil
      end if

   end if

   if Empty( aTemp[_CDESRUT] )
      MsgStop( "La descripción de la ruta no puede estar vacía." )
      aoGet[_CDESRUT]:SetFocus()
      Return .f.
   end if

   WinGather( aTemp, aoGet, dbfRuta, oBrw, nMode )

Return ( oDlg:end( IDOK ) )

//---------------------------------------------------------------------------//

FUNCTION RetRuta( cCodRut, dbfRuta )

	local cAreaAnt := Alias()
	local cText		:= ""
	local lClose 	:= .F.

	IF dbfRuta == NIL
      USE ( cPatCli() + "RUTA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "RUTA", @dbfRuta ) )
      SET ADSINDEX TO ( cPatCli() + "RUTA.CDX" ) ADDITIVE
		lClose := .T.
	END IF

   if ( dbfRuta )->( dbSeek( cCodRut ) )
      cText       := ( dbfRuta )->cDesRut
	end if

	IF lClose
		CLOSE ( dbfRuta )
	END IF

	IF cAreaAnt != ""
		SELECT( cAreaAnt )
	END IF

RETURN cText

//---------------------------------------------------------------------------//

#else

static function pdaMenuEdtRec( oDlg )

   local oMenu

   DEFINE MENU oMenu ;
      RESOURCE 100 ;
      BITMAPS  10 ; // bitmaps resoruces ID
      IMAGES   3     // number of images in the bitmap

      REDEFINE MENUITEM ID 110 OF oMenu ACTION ( oDlg:End( IDOK ) )

      REDEFINE MENUITEM ID 120 OF oMenu ACTION ( oDlg:End( IDCANCEL ) )

Return oMenu

//---------------------------------------------------------------------------//

function pdaVentas()

   local oDlg
   local oSayTit
   local aBtn        := Array( 5 )
   local oFont
   local hBmp
   local oBrw
   local nOrdAnt     := GetBrwOpt( "BrwClient" )
	local oCbxOrd
   local aCbxOrd     := { "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado", "Domingo", "Todos los clientes" }
   local cCbxOrd     := "Lunes"
   local nLevel      := Auth():Level( "01032" )
   local dbfClient
   local oOrden
   local aOrden      := { "Código", "Nombre", "NIF/CIF", "Población", "Provincia", "Código postal", "Teléfono", "Establecimiento" }
   local cOrden      := "Establecimiento"
   local oGet
   local cGet        := Space( 50 )

   nOrdAnt           := Min( Max( nOrdAnt, 1 ), len( aCbxOrd ) )
   cCbxOrd           := aCbxOrd[ Dow( Date() - 1 ) ]

   hBmp              := LoadBitmap( GetResources(), "bStop"  )

   USE ( cPatCli() + "CLIENT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIENT", @dbfClient ) )
   SET ADSINDEX TO ( cPatCli() + "CLIENT.CDX" ) ADDITIVE

   /*
   Distintas cajas de dialogo--------------------------------------------------
   */

   DEFINE FONT oFont NAME "Verdana" SIZE 0, -14

   DEFINE DIALOG oDlg RESOURCE "VENTAS_PDA"

      REDEFINE SAY oSayTit ;
         VAR      "Ventas" ;
         ID       110 ;
         COLOR    "N/W*" ;
         FONT     oFont ;
         OF       oDlg

      REDEFINE BTNBMP aBtn[ 1 ] ;
         ID       100 ;
         OF       oDlg ;
         FILE     ( cPatBmp() + "gc_money2_16.bmp" ) ;
         NOBORDER ;
         ACTION      ( nil )

      aBtn[ 1 ]:SetColor( 0, nRGB( 255, 255, 255 )  )

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
         ID       200 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( OrdClearScope( oBrw, dbfClient ), ChangeDay( oCbxOrd, oBrw, dbfClient, oOrden ) ) ;
         OF       oDlg

      REDEFINE GET oGet VAR cGet ;
         ID       220 ;
         ON CHANGE( if( oCbxOrd:nAt != 8, ChangeDay( oCbxOrd, oBrw, dbfClient, oOrden, .t. ), ), AutoSeek( nKey, nFlags, Self, oBrw, dbfClient, .t. ) ) ;
         VALID    ( OrdClearScope( oBrw, dbfClient ), oGet:cText( Space( 50 ) ), .t. ) ;
         BITMAP   "FIND" ;
         OF       oDlg

      REDEFINE COMBOBOX oOrden ;
         VAR      cOrden ;
         ID       230 ;
         ITEMS    aOrden ;
         ON CHANGE( ( dbfClient )->( OrdSetFocus( oOrden:nAt ) ), ( dbfClient )->( dbGoTop() ), oBrw:refresh(), oGet:SetFocus(), oOrden:Refresh() ) ;
         OF       oDlg

      REDEFINE IBROWSE oBrw ;
         FIELDS   ( dbfClient )->Cod + CRLF + ( dbfClient )->NbrEst ,;
                  ( dbfClient )->Titulo + CRLF + ( dbfClient )->Domicilio ;
         HEAD     "Código" + CRLF + "Nombre comercial",;
                  "Nombre" + CRLF + "Domicilio" ;
         FIELDSIZES ;
                  122,;
                  300 ;
         JUSTIFY  .f.,;
                  .f. ;
         ALIAS    ( dbfClient ) ;
         ID       210 ;
			OF 		oDlg

      REDEFINE BTNBMP aBtn[ 2 ] ;
         ID       300 ;
         OF       oDlg ;
         FILE     ( cPatBmp() + "ClipBoard_empty_user1_24.bmp" ) ;
         NOBORDER ;
         ACTION   ( pdaAppPedCli( ( dbfClient )->Cod ), if( oCbxOrd:nAt != 8, oBrw:GoDown(), ), SysRefresh() )

      aBtn[ 2 ]:SetColor( 0, nRGB( 255, 255, 255 )  )

      REDEFINE BTNBMP aBtn[ 3 ] ;
         ID       310 ;
         OF       oDlg ;
         FILE     ( cPatBmp() + "Document_plain_user1_24.bmp" ) ;
         NOBORDER ;
         ACTION   ( pdaAppAlbCli( ( dbfClient )->Cod ), if( oCbxOrd:nAt != 8, oBrw:GoDown(), ), SysRefresh() )

      aBtn[ 3 ]:SetColor( 0, nRGB( 255, 255, 255 )  )

      REDEFINE BTNBMP aBtn[ 4 ] ;
         ID       320 ;
         OF       oDlg ;
         FILE     ( cPatBmp() + "Document_user1_24.bmp" ) ;
         NOBORDER ;
         ACTION   ( pdaAppFacCli( ( dbfClient )->Cod ), if( oCbxOrd:nAt != 8, oBrw:GoDown(), ), SysRefresh() )

      aBtn[ 4 ]:SetColor( 0, nRGB( 255, 255, 255 )  )

      REDEFINE BTNBMP aBtn[ 5 ] ;
         ID       330 ;
         OF       oDlg ;
         FILE     ( cPatBmp() + "cobros_pendientes.bmp" ) ;
         NOBORDER ;
         ACTION   ( pdaCobrosPendientes( ( dbfClient )->Cod ), if( oCbxOrd:nAt != 8, oBrw:GoDown(), ), SysRefresh() )

      aBtn[ 5 ]:SetColor( 0, nRGB( 255, 255, 255 )  )

      oDlg:bStart := {|| ChangeDay( oCbxOrd, oBrw, dbfClient, oOrden ) }

   ACTIVATE DIALOG oDlg ;
      ON INIT ( oDlg:SetMenu( pdaMenuRec( oDlg ) ), oDlg:Refresh() )

   CLOSE ( dbfClient )

   oBrw:CloseData()

   // Restauramos la ventana---------------------------------------------------

   oWnd():Show()

RETURN .t.

//---------------------------------------------------------------------------//

static function pdaMenuRec( oDlg )

   local oMenu

   DEFINE MENU oMenu ;
      RESOURCE 400 ;
      BITMAPS  50 ; // bitmaps resoruces ID
      IMAGES   1     // number of images in the bitmap

      REDEFINE MENUITEM ID 410 OF oMenu ACTION ( oDlg:End( IDCANCEL ) )

Return oMenu

//---------------------------------------------------------------------------//

Function ChangeDay( oCbxOrd, oBrw, dbfClient, oOrden, lSearch )

   DEFAULT lSearch   := .f.

   ( dbfClient )->( dbClearFilter() )

   do case
      case oCbxOrd:nAt == 1 // Lunes
         ( dbfClient )->( OrdSetFocus( "nVisLun" ) )
         ( dbfClient )->( dbSetFilter( {|| cAgeLun == cCodAge() }, "cAgeLun == cCodAge()" ) )

      case oCbxOrd:nAt == 2 // Martes
         ( dbfClient )->( OrdSetFocus( "nVisMar" ) )
         ( dbfClient )->( dbSetFilter( {|| cAgeMar == cCodAge() }, "cAgeMar == cCodAge()" ) )

      case oCbxOrd:nAt == 3 // Miercoles
         ( dbfClient )->( OrdSetFocus( "nVisMie" ) )
         ( dbfClient )->( dbSetFilter( {|| cAgeMie == cCodAge() }, "cAgeMie == cCodAge()" ) )

      case oCbxOrd:nAt == 4 // Jueves
         ( dbfClient )->( OrdSetFocus( "nVisJue" ) )
         ( dbfClient )->( dbSetFilter( {|| cAgeJue == cCodAge() }, "cAgeJue == cCodAge()" ) )

      case oCbxOrd:nAt == 5 // Viernes
         ( dbfClient )->( OrdSetFocus( "nVisVie" ) )
         ( dbfClient )->( dbSetFilter( {|| cAgeVie == cCodAge() }, "cAgeVie == cCodAge()" ) )

      case oCbxOrd:nAt == 6 // Sábado
         ( dbfClient )->( OrdSetFocus( "nVisSab" ) )
         ( dbfClient )->( dbSetFilter( {|| cAgeSab == cCodAge() }, "cAgeSab == cCodAge()" ) )

      case oCbxOrd:nAt == 7 // Domingo
         ( dbfClient )->( OrdSetFocus( "nVisDom" ) )
         ( dbfClient )->( dbSetFilter( {|| cAgeDom == cCodAge() }, "cAgeDom == cCodAge()" ) )

      case oCbxOrd:nAt == 8 // Todos los clientes
         ( dbfClient )->( OrdSetFocus( oOrden:nAt ) )
         ( dbfClient )->( dbClearFilter() )

   end case

   if lSearch

      oCbxOrd:Select( 8 )

      ( dbfClient )->( OrdSetFocus( oOrden:nAt ) )
      ( dbfClient )->( dbClearFilter() )

   end if

   ( dbfClient )->( dbGoTop() )

   oBrw:Refresh()

Return .t.

//---------------------------------------------------------------------------//

FUNCTION pdaBrwRuta( oGet, dbfRuta, oGet2 )

	local oDlg
   local oSayTit
   local oBtn
   local oFont
	local oBrw
   local oGet1
   local cGet1
   local nOrd        := GetBrwOpt( "BrwRuta" )
	local oCbxOrd
   local aCbxOrd     := { 'Código', 'Nombre' }
   local cCbxOrd     := "Código"
   local lClose      := .f.
   local nLevel      := Auth():Level( "01031" )
   local oSayText
   local cSayText    := "Listado de rutas"

   nOrd              := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd           := aCbxOrd[ nOrd ]

   if ( dbfRuta == nil )
      USE ( cPatCli() + "RUTA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "RUTA", @dbfRuta ) )
      SET ADSINDEX TO ( cPatCli() + "RUTA.CDX" ) ADDITIVE
      lClose         := .t.
   end if

   nOrd              := ( dbfRuta )->( OrdSetFocus( nOrd ) )
   ( dbfRuta )->( dbGoTop() )

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY_PDA"     TITLE "Seleccionar rutas"

      DEFINE FONT oFont NAME "Verdana" SIZE 0, -14

      REDEFINE SAY oSayTit ;
         VAR      "Buscando rutas" ;
         ID       110 ;
         COLOR    "N/W*" ;
         FONT     oFont ;
         OF       oDlg

      REDEFINE BTNBMP oBtn ;
         ID       100 ;
         OF       oDlg ;
         FILE     ( cPatBmp() + "signpost.bmp" ) ;
         NOBORDER ;
         ACTION      ( nil )

      oBtn:SetColor( 0, nRGB( 255, 255, 255 )  )

      REDEFINE GET oGet1 VAR cGet1;
         ID       104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfRuta ) );
         VALID    ( OrdClearScope( oBrw, dbfRuta ) );
         BITMAP   "FIND" ;
         OF       oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( (dbfRuta)->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:Refresh(), oGet1:SetFocus(), oCbxOrd:refresh() ) ;
			OF 		oDlg

		REDEFINE LISTBOX oBrw ;
         FIELDS   ( dbfRuta )->cCodRut + CRLF + ( dbfRuta )->cDesRut;
         HEAD     "Código" + CRLF + "Nombre";
         FIELDSIZES ;
                  180 ;
         ALIAS    ( dbfRuta ) ;
         ID       105 ;
         OF       oDlg

         oBrw:aActions     := {| nCol | lPressCol( nCol, oBrw, oCbxOrd, aCbxOrd, dbfRuta ) }
         oBrw:bLDblClick   := {|| oDlg:end( IDOK ) }

   ACTIVATE DIALOG oDlg ;
      ON INIT ( oDlg:SetMenu( pdaMenuEdtRec( oDlg ) ) )

   if oDlg:nResult == IDOK
      oGet:cText( ( dbfRuta )->cCodRut )

      if oGet2 != NIL
         oGet2:cText( ( dbfRuta )->cDesRut )
      end if
   end if

   DestroyFastFilter( dbfRuta )

   SetBrwOpt( "BrwRuta", ( dbfRuta )->( OrdNumber() ) )

   if lClose
      ( dbfRuta )->( dbCloseArea() )
   else
      ( dbfRuta )->( OrdSetFocus( nOrd ) )
   end if

	oGet:setFocus()

   // Restauramos la ventana---------------------------------------------------

   oWnd():Show()

RETURN oDlg:nResult == IDOK

//---------------------------------------------------------------------------//

#endif

CLASS pdaRutaSenderReciver

   Method CreateData()

END CLASS

//----------------------------------------------------------------------------//

Method CreateData( oPgrActual, oSayStatus, cPatPreVenta ) CLASS pdaRutaSenderReciver

   local dbfRut
   local tmpRut
   local lExist      := .f.
   local cFileName
   local cPatPc      := if( Empty( cPatPreVenta ), cPatPc(), cPatPreVenta )

   USE ( cPatCli() + "Ruta.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "RUTA", @dbfRut ) )
   SET ADSINDEX TO ( cPatCli() + "Ruta.Cdx" ) ADDITIVE

   dbUseArea( .t., cDriver(), cPatPc + "Ruta.Dbf", cCheckArea( "RUTA", @tmpRut ), .t. )
   ( tmpRut )->( ordListAdd( cPatPc + "Ruta.Cdx" ) )

   if !Empty( oPgrActual )
      oPgrActual:SetRange( 0, ( tmpRut )->( OrdKeyCount() ) )
   end if

   ( tmpRut )->( dbGoTop() )
   while !( tmpRut )->( eof() )

      if ( dbfRut )->( dbSeek( ( tmpRut )->cCodRut ) )
         dbPass( tmpRut, dbfRut, .f. )
      else
         dbPass( tmpRut, dbfRut, .t. )
      end if

      if dbLock( tmpRut )
         ( tmpRut )->lSelRut  := .f.
         ( tmpRut )->( dbUnLock() )
      end if

      ( tmpRut )->( dbSkip() )

      if !Empty( oSayStatus )
         oSayStatus:SetText( "Sincronizando Rutas " + Alltrim( Str( ( tmpRut )->( OrdKeyNo() ) ) ) + " de " + Alltrim( Str( ( tmpRut )->( OrdKeyCount() ) ) ) )
      end if

      SysRefresh()

      if !Empty( oPgrActual )
         oPgrActual:SetPos( ( tmpRut )->( OrdKeyNo() ) )
      end if

      SysRefresh()

   end while

   CLOSE ( tmpRut )
   CLOSE ( dbfRut )

Return ( Self )

//---------------------------------------------------------------------------//
//Funciones comunes del programa y pda
//---------------------------------------------------------------------------//

Function IsRuta()

   local oError
   local oBlock

   if !lExistTable( cPatCli() + "Ruta.Dbf" )
      mkRuta( cPatCli() )
   end if

   oBlock                     := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      USE ( cPatCli() + "Ruta.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CCODRUT", @dbfRuta ) )
      SET ADSINDEX TO ( cPatCli() + "Ruta.Cdx" ) ADDITIVE

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE ( dbfRuta )

Return ( .t. )

//----------------------------------------------------------------------------//

FUNCTION mkRuta( cPath, lAppend, cPathOld, oMeter )

	local dbfRuta

   DEFAULT lAppend   := .f.
   DEFAULT cPath     := cPatCli()

	IF oMeter != NIL
		oMeter:cText	:= "Generando Bases"
      SysRefresh()
	END IF

   dbCreate( cPath + "Ruta.Dbf", aSqlStruct( aItmRut() ), cDriver() )

   if lAppend .and. lIsDir( cPathOld ) .and. lExistTable( cPathOld + "Ruta.Dbf" )

      dbUseArea( .t., cDriver(), cPath + "Ruta.Dbf", cCheckArea( "RUTA", @dbfRuta ), .f. )
      ( dbfRuta )->( __dbApp( cPathOld + "Ruta.Dbf" ) )
		( dbfRuta )->( dbCloseArea() )

   end if

	rxRuta( cPath, oMeter )

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION rxRuta( cPath, oMeter )

	local dbfRuta

   DEFAULT cPath := cPatCli()

   if !lExistTable( cPath + "RUTA.DBF" )
      dbCreate( cPath + "RUTA.DBF", aSqlStrucT( aItmRut() ), cDriver() )
   end if

   fEraseIndex( cPath + "RUTA.CDX" )

   dbUseArea( .t., cDriver(), cPath + "RUTA.DBF", cCheckArea( "RUTA", @dbfRuta ), .f. )
   if !( dbfRuta )->( neterr() )
      ( dbfRuta )->( __dbPack() )

      ( dbfRuta )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfRuta )->( ordCreate( cPath + "RUTA.CDX", "CCODRUT", "CCODRUT", {|| Field->CCODRUT } ) )

      ( dbfRuta )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfRuta )->( ordCreate( cPath + "RUTA.CDX", "CDESRUT", "CDESRUT", {|| Field->CDESRUT }, ) )

      ( dbfRuta )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfRuta )->( ordCreate( cPath + "RUTA.CDX", "TRMCOD", "PadL( AllTrim( CCODRUT ), 4 )", {|| PadL( AllTrim( Field->cCodRut ), 4 ) } ) )

      ( dbfRuta )->( dbCloseArea() )

   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de rutas" )
   end if

RETURN NIL

//--------------------------------------------------------------------------//

function aItmRut()

local aBase := {  {"CCODRUT", "C", 4, 0, "Código de la ruta"   ,  "",                  "", "( cDbfRut )" },;
                  {"CDESRUT", "C",30, 0, "Nombre de la ruta"   ,  "'@!'",              "", "( cDbfRut )" },;
                  {"LSELRUT", "L", 1, 0, ""                    ,  "",                  "", "( cDbfRut )" } }

return ( aBase )

//--------------------------------------------------------------------------//

FUNCTION BrwRuta( oGet, dbfRuta, oGet2 )

	local oDlg
   local oSayTit
   local oBtn
   local oFont
	local oBrw
   local oGet1
   local cGet1
   local nOrd        := GetBrwOpt( "BrwRuta" )
	local oCbxOrd
   local aCbxOrd     := { 'Código', 'Nombre' }
   local cCbxOrd     := "Código"
   local lClose      := .f.
   local nLevel      := Auth():Level( "01031" )
   local oSayText
   local cSayText    := "Listado de rutas"
   local cReturn     := ""

   nOrd              := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd           := aCbxOrd[ nOrd ]

   if ( dbfRuta == nil )
      USE ( cPatCli() + "RUTA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "RUTA", @dbfRuta ) )
      SET ADSINDEX TO ( cPatCli() + "RUTA.CDX" ) ADDITIVE
      lClose         := .t.
   end if

   nOrd              := ( dbfRuta )->( OrdSetFocus( nOrd ) )
   ( dbfRuta )->( dbGoTop() )

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Seleccionar rutas"

      REDEFINE GET   oGet1 VAR cGet1;
         ID          104 ;
         ON CHANGE   ( AutoSeek( nKey, nFlags, Self, oBrw, dbfRuta ) );
         VALID       ( OrdClearScope( oBrw, dbfRuta ) );
         BITMAP      "FIND" ;
         OF          oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR         cCbxOrd ;
			ID          102 ;
         ITEMS       aCbxOrd ;
         ON CHANGE   ( ( dbfRuta )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:Refresh(), oGet1:SetFocus(), oCbxOrd:refresh() ) ;
			OF          oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfRuta
      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "Browse.Ruta"

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodRut"
         :bEditValue       := {|| ( dbfRuta )->cCodRut }
         :nWidth           := 60
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cDesRut"
         :bEditValue       := {|| ( dbfRuta )->cDesRut }
         :nWidth           := 260
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }
      oBrw:bRClicked       := {| nRow, nCol, nFlags | oBrw:RButtonDown( nRow, nCol, nFlags ) }

      oBrw:CreateFromResource( 105 )

      if ( "PDA" $ appParamsMain() )

      REDEFINE SAY oSayText VAR cSayText ;
         ID       100 ;
         OF       oDlg

      end if

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( oDlg:end(IDOK) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         ACTION   ( oDlg:end() )

      if !( "PDA" $ appParamsMain() )

      REDEFINE BUTTON ;
         ID       500 ;
         OF       oDlg ;
         WHEN     ( nAnd( nLevel, ACC_APPD ) != 0 .and. !IsReport() );
         ACTION   ( WinAppRec( oBrw, bEdit, dbfRuta ) )

      REDEFINE BUTTON ;
         ID       501 ;
         OF       oDlg ;
         WHEN     ( nAnd( nLevel, ACC_EDIT ) != 0 .and. !IsReport() );
         ACTION   ( WinEdtRec( oBrw, bEdit, dbfRuta ) )

      if nAnd( nLevel, ACC_APPD ) != 0 .and. !IsReport()
         oDlg:AddFastKey( VK_F2, {|| WinAppRec( oBrw, bEdit, dbfRuta ) } )
      end if

      if nAnd( nLevel, ACC_EDIT ) != 0 .and. !IsReport()
         oDlg:AddFastKey( VK_F3, {|| WinEdtRec( oBrw, bEdit, dbfRuta ) } )
      end if

      end if

      oDlg:AddFastKey( VK_F5,    {|| oDlg:end( IDOK ) } )
      oDlg:AddFastKey( VK_RETURN,{|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg

   if oDlg:nResult == IDOK

      cReturn  := ( dbfRuta )->cCodRut

      if IsObject( oGet )
         oGet:cText( ( dbfRuta )->cCodRut )
      end if

      if IsObject( oGet2 )
         oGet2:cText( ( dbfRuta )->cDesRut )
      end if

   end if

   DestroyFastFilter( dbfRuta )

   SetBrwOpt( "BrwRuta", ( dbfRuta )->( OrdNumber() ) )

   if lClose
      ( dbfRuta )->( dbCloseArea() )
   else
      ( dbfRuta )->( OrdSetFocus( nOrd ) )
   end if

   if IsObject( oGet )
      oGet:setFocus()
   end if

Return ( cReturn )

//---------------------------------------------------------------------------//

FUNCTION cRuta( oGet, dbfRuta, oGet2 )

   local lClose   := .f.
   local lValid   := .f.
	local xValor 	:= oGet:varGet()

   if Empty( xValor ) .or. ( xValor == Replicate( "Z", 4 ) )
      if IsObject( oGet2 )
         oGet2:cText( "" )
      end if
      return .t.
   end if

   if Empty( dbfRuta )
      USE ( cPatCli() + "RUTA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "RUTA", @dbfRuta ) )
      SET ADSINDEX TO ( cPatCli() + "RUTA.CDX" ) ADDITIVE
      lClose      := .t.
   end if

   if ( dbfRuta )->( dbSeek( xValor ) )

      if IsObject( oGet )
         oGet:cText( ( dbfRuta )->cCodRut )
      end if

      if IsObject( oGet2 )
         oGet2:cText( ( dbfRuta )->cDesRut )
      end if

      lValid      := .t.

   else

      msgStop( "Ruta no encontrada" )

   end if

   if lClose
      CLOSE ( dbfRuta )
   end if

RETURN lValid

//---------------------------------------------------------------------------//