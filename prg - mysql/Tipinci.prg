#ifndef __PDA__
#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#else
#include "FWCE.ch"
REQUEST DBFCDX
#endif

#ifndef __PDA__

static oWndBrw
static bEdit      := { |aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode | EdtRec( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode ) }

#endif

static dbfInci

#ifndef __PDA__

//----------------------------------------------------------------------------//
//Funciones del programa
//----------------------------------------------------------------------------//


STATIC FUNCTION OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      USE ( cPatEmp() + "TIPINCI.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIPINCI", @dbfInci ) )
      SET ADSINDEX TO ( cPatEmp() + "TIPINCI.CDX" ) ADDITIVE

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles()
//Cierra las bases de datos

   if dbfInci != nil
      ( dbfInci )->( dbCloseArea() )
   end if

   dbfInci     := nil

   oWndBrw     := nil

RETURN .T.

//----------------------------------------------------------------------------//

FUNCTION TipInci( oMenuItem, oWnd )

   local nLevel

   DEFAULT  oMenuItem   := "01089"
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

      /*
      Apertura de ficheros
      */

      if !OpenFiles()
         return nil
      end if

      /*
      Anotamos el movimiento para el navegador
      */

      AddMnuNext( "Tipos de incidencias", ProcName() )

   DEFINE SHELL oWndBrw FROM 2, 10 TO 18, 70 ;
      XBROWSE ;
      TITLE    "Tipos de incidencias" ;
      PROMPT   "Código",;
               "Nombre";
      MRU      "Camera_16";
      ALIAS    ( dbfInci ) ;
      BITMAP   clrTopArchivos ;
      APPEND   ( WinAppRec( oWndBrw:oBrw, bEdit, dbfInci ) ) ;
      EDIT     ( WinEdtRec( oWndBrw:oBrw, bEdit, dbfInci ) ) ;
      DELETE   ( WinDelRec( oWndBrw:oBrw, dbfInci ) ) ;
      DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdit, dbfInci ) ) ;
      LEVEL    nLevel ;
      OF       oWnd

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodInci"
         :bEditValue       := {|| ( dbfInci )->cCodInci }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomInci"
         :bEditValue       := {|| ( dbfInci )->cNomInci }
         :nWidth           := 300
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      oWndBrw:cHtmlHelp    := "Tipos de incidencias"

      oWndBrw:CreateXFromCode()

      DEFINE BTNSHELL RESOURCE "BUS" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( oWndBrw:SearchSetFocus() ) ;
         TOOLTIP  "(B)uscar" ;
         HOTKEY   "B"

      oWndBrw:AddSeaBar()

      DEFINE BTNSHELL RESOURCE "NEW" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( oWndBrw:RecAdd() );
         ON DROP  ( oWndBrw:RecDup() );
         TOOLTIP  "(A)ñadir";
         BEGIN GROUP;
         HOTKEY   "A";
         LEVEL    ACC_APPD

      DEFINE BTNSHELL RESOURCE "EDIT" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( oWndBrw:RecEdit() );
         TOOLTIP  "(M)odificar";
         MRU ;
         HOTKEY   "M";
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "ZOOM" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( WinZooRec( oWndBrw:oBrw, bEdit, dbfInci ) );
         TOOLTIP  "(Z)oom";
         MRU ;
         HOTKEY   "Z";
         LEVEL    ACC_ZOOM

      DEFINE BTNSHELL RESOURCE "DEL" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( oWndBrw:RecDel() );
         TOOLTIP  "(E)liminar";
         MRU ;
         HOTKEY   "E";
         LEVEL    ACC_DELE

#ifndef __TACTIL__

      DEFINE BTNSHELL RESOURCE "IMP" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( TInfListInci():New( "Listado de incidencias" ):Play() );
         TOOLTIP  "(L)istado";
         HOTKEY   "L";
         LEVEL    ACC_IMPR

#endif

      DEFINE BTNSHELL RESOURCE "END" GROUP OF oWndBrw ;
         NOBORDER ;
         ACTION   ( oWndBrw:end() ) ;
         TOOLTIP  "(S)alir" ;
         HOTKEY   "S"

      ACTIVATE WINDOW oWndBrw VALID ( CloseFiles() )

   ELSE

      oWndBrw:SetFocus()

   END IF

RETURN NIL

//----------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aTmp, aGet, dbfInci, oBrw, bWhen, bValid, nMode )

   local oDlg

   DEFINE DIALOG oDlg RESOURCE "TipArt" TITLE LblTitle( nMode ) + "tipos de incidencias"

      REDEFINE GET aGet[ ( dbfInci )->( FieldPos( "CCODINCI" ) ) ] ;
         VAR      aTmp[ ( dbfInci )->( FieldPos( "CCODINCI" ) ) ] ;
         UPDATE ;
         ID       100 ;
         WHEN     ( nMode == APPD_MODE ) ;
         VALID    ( !Empty( aTmp[ ( dbfInci )->( FieldPos( "cCodInci" ) ) ] ) .and. NotValid( aGet[ ( dbfInci )->( FieldPos( "cCodInci" ) ) ], dbfInci ) ) ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfInci )->( FieldPos( "cNomInci" ) ) ] ;
         VAR      aTmp[ ( dbfInci )->( FieldPos( "cNomInci" ) ) ] ;
         ID       110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( lPreSave( aTmp, aGet, dbfInci, nMode, oDlg ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      REDEFINE BUTTON ;
         ID       9 ;
			OF 		oDlg ;
         ACTION   ( ChmHelp( "TipoIncidencia" ) )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| lPreSave( aTmp, aGet, dbfInci, nMode, oDlg ) } )
   end if

   oDlg:AddFastKey ( VK_F1, {|| ChmHelp( "TipoIncidencia" ) } )

   oDlg:bStart := { || aGet[ ( dbfInci )->( FieldPos( "CCODINCI" ) ) ]:SetFocus() }

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Static Function lPreSave( aTmp, aGet, dbfInci, nMode, oDlg )

   if nMode == APPD_MODE

      if Empty( aTmp[ ( dbfInci )->( FieldPos( "cCodInci" ) ) ] )
         MsgStop( "El código del tipo de incidencia no puede estar vacío." )
         aGet[ ( dbfInci )->( FieldPos( "cCodInci" ) ) ]:SetFocus()
         Return nil
      end if

      if dbSeekInOrd( aTmp[ ( dbfInci )->( FieldPos( "cCodInci" ) ) ], "CCODINCI", dbfInci )
         MsgStop( "Código ya existe " + Rtrim( aTmp[ ( dbfInci )->( FieldPos( "cCodInci" ) ) ] ) )
         return nil
      end if

   end if

   if Empty( aTmp[ ( dbfInci )->( FieldPos( "cNomInci" ) ) ] )
      MsgStop( "El nombre del tipo de incidencia no puede estar vacío." )
      aGet[ ( dbfInci )->( FieldPos( "cNomInci" ) ) ]:SetFocus()
      Return nil
   end if

   WinGather( aTmp, aGet, dbfInci, nil, nMode )

Return ( oDlg:end( IDOK ) )

//---------------------------------------------------------------------------//

#else

//---------------------------------------------------------------------------//
//Funciones solo de PDA
//---------------------------------------------------------------------------//

static function pdaMenuEdtRec( oDlg )

   local oMenu

   DEFINE MENU oMenu ;
      RESOURCE 100 ;
      BITMAPS  10 ; // bitmaps resoruces ID
      IMAGES   3     // number of images in the bitmap

      REDEFINE MENUITEM ID 110 OF oMenu ACTION ( oDlg:End( IDOK ) )

      REDEFINE MENUITEM ID 120 OF oMenu ACTION ( oDlg:End( IDCANCEL ) )

   oDlg:SetMenu( oMenu )

Return oMenu

//---------------------------------------------------------------------------//

#endif

//---------------------------------------------------------------------------//
//Funciones comunes del programa y pda
//---------------------------------------------------------------------------//

FUNCTION cNomInci( cCodInci, dbfInci )

   local cNomInci    := ""

   if !Empty( dbfInci ) .and. ( dbfInci )->( Used() )

      if dbSeekInOrd( cCodInci, "cCodInci", dbfInci )

         cNomInci    := ( dbfInci )->cNomInci

      end if

   end if

RETURN cNomInci

//---------------------------------------------------------------------------//

FUNCTION BrwIncidencia( dbfInci, oGet, oGet2 )

   local oDlg
   local oBrw
   local oFont
   local oBtn
   local oGet1
   local cGet1
   local nOrdAnt        := 1
   local oCbxOrd
   local aCbxOrd        := { "Código", "Nombre" }
   local cCbxOrd
   local nLevel         := nLevelUsr( "01089" )
   local oSayText
   local cSayText       := "Listado de incidencias"

   nOrdAnt              := Min( Max( nOrdAnt, 1 ), len( aCbxOrd ) )
   cCbxOrd              := aCbxOrd[ nOrdAnt ]

   nOrdAnt              := ( dbfInci )->( OrdSetFocus( nOrdAnt ) )

   ( dbfInci )->( dbGoTop() )

#ifndef __PDA__
   DEFINE DIALOG oDlg RESOURCE "HELPENTRY"      TITLE "Seleccionar tipos de incidencia"
#else
   DEFINE DIALOG oDlg RESOURCE "HELPENTRY_PDA"  TITLE "Seleccionar tipos de incidencia"

   DEFINE FONT oFont NAME "Verdana" SIZE 0, -14

      REDEFINE SAY oSayTit ;
         VAR      "Buscando tipos de incidencia" ;
         ID       110 ;
         COLOR    "N/W*" ;
         FONT     oFont ;
         OF       oDlg

      REDEFINE BTNBMP oBtn ;
         ID       100 ;
         OF       oDlg ;
         FILE     ( cPatBmp() + "about_16.bmp" ) ;
         NOBORDER ;
         ACTION      ( nil )

      oBtn:SetColor( 0, nRGB( 255, 255, 255 )  )

#endif

      REDEFINE GET oGet1 VAR cGet1;
         ID       104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfInci ) );
         VALID    ( OrdClearScope( oBrw, dbfInci ) );
         BITMAP   "FIND" ;
         OF       oDlg

      REDEFINE COMBOBOX oCbxOrd ;
         VAR      cCbxOrd ;
         ID       102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( ( dbfInci )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:refresh(), oGet1:SetFocus(), oCbxOrd:Refresh() ) ;
         OF       oDlg

#ifndef __PDA__

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfInci

      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "Browse.Tipos de incidencias"

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodInci"
         :bEditValue       := {|| ( dbfInci )->cCodInci }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomInci"
         :bEditValue       := {|| ( dbfInci )->cNomInci }
         :nWidth           := 300
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }
      oBrw:bRClicked       := {| nRow, nCol, nFlags | oBrw:RButtonDown( nRow, nCol, nFlags ) }

      oBrw:CreateFromResource( 105 )

   if ( "PDA" $ cParamsMain() )

      REDEFINE SAY oSayText VAR cSayText ;
         ID       100 ;
         OF       oDlg

   end if

   if !( "PDA" $ cParamsMain() )

   REDEFINE BUTTON ;
      ID       500 ;
      OF       oDlg ;
      WHEN     ( nAnd( nLevel, ACC_APPD ) != 0 );
      ACTION   ( WinAppRec( oBrw, bEdit, dbfInci ) )

   REDEFINE BUTTON ;
      ID       501 ;
      OF       oDlg ;
      WHEN     ( nAnd( nLevel, ACC_EDIT ) != 0 );
      ACTION   ( WinEdtRec( oBrw, bEdit, dbfInci ) )

   oDlg:AddFastKey( VK_F2, {|| if( nAnd( nLevel, ACC_APPD ) != 0, WinAppRec( oBrw, bEdit, dbfInci ), ) } )
   oDlg:AddFastKey( VK_F3, {|| if( nAnd( nLevel, ACC_EDIT ) != 0, WinEdtRec( oBrw, bEdit, dbfInci ), ) } )

   end if

   REDEFINE BUTTON ;
      ID       IDOK ;
      OF       oDlg ;
      ACTION   ( oDlg:end( IDOK ) )

   REDEFINE BUTTON ;
      ID       IDCANCEL ;
      OF       oDlg ;
      ACTION   ( oDlg:end() )

   oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )
   oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

#else

   REDEFINE LISTBOX oBrw ;
      FIELDS ;
               ( dbfInci )->cCodInci + CRLF + ( dbfInci )->cNomInci ;
      HEAD ;
               "Código" + CRLF + "Nombre" ;
      FIELDSIZES ;
               180 ;
      ID       105 ;
      ALIAS    ( dbfInci ) ;
      OF       oDlg

      oBrw:aJustify     := { .f., .f. }
      oBrw:aActions     := {| nCol | lPressCol( nCol, oBrw, oCbxOrd, aCbxOrd, dbfInci ) }
      oBrw:bLDblClick   := {|| oDlg:end( IDOK ) }
      oBrw:bKeyDown     := {|nKey, nFalg| if( nKey == VK_RETURN, oDlg:end( IDOK ), ) }

   ACTIVATE DIALOG oDlg ;
      ON INIT ( pdaMenuEdtRec( oDlg ) )

#endif

   if oDlg:nResult == IDOK

      oGet:cText( ( dbfInci )->cCodInci )
      oGet:lValid()

      if ValType( oGet2 ) == "O"
         oGet2:cText( ( dbfInci )->cNomInci )
      end if

   end if

   DestroyFastFilter( dbfInci )

   SetBrwOpt( "BrwIncidencia", ( dbfInci )->( OrdNumber() ) )

   oGet:SetFocus()

Return ( .t. )

//---------------------------------------------------------------------------//

FUNCTION cTipInci( oGet, dbfInci, oGet2, lMessage )

   local oBlock
   local oError
   local nOrdAnt
   local lValid      := .f.
   local lClose      := .f.
   local xValor      := oGet:varGet()

   DEFAULT lMessage  := .t.

   if Empty( xValor )
		RETURN .T.
	END IF

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if (dbfInci) == NIL

      USE ( cPatEmp() + "TIPINCI.DBF" ) NEW VIA ( cDriver() ) SHARED   ALIAS ( cCheckArea( "TIPINCI", @dbfInci ) )
      SET ADSINDEX TO ( cPatEmp() + "TIPINCI.CDX" ) ADDITIVE
      lClose         := .t.

   else

      nOrdAnt        := ( dbfInci )->( ordSetFocus( 1 ) )

   end if

   if ( dbfInci )->( dbSeek( xValor ) )

      oGet:cText( ( dbfInci )->CCODINCI )

      if oGet2 != NIL
         oGet2:cText( (dbfInci)->CNOMINCI )
      end if

      lValid         := .t.

   else

      if lMessage
         msgStop( "Tipo de incidencia no encontrado", "Aviso del sistema" )
      end if

   end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if lClose
      CLOSE (dbfInci)
   else
      ( dbfInci )->( ordSetFocus( nOrdAnt ) )
   end if

RETURN lValid

//---------------------------------------------------------------------------//

FUNCTION mkInci( cPath, lAppend, cPathOld, oMeter )

   local dbfInci

   DEFAULT cPath     := cPatEmp()
   DEFAULT lAppend   := .F.

   if !lExistTable( cPath + "TipInci.Dbf" )
      dbCreate( cPath + "TipInci.Dbf", aSqlStruct( aItmInci() ),  cDriver() )
   end if

   if lAppend .and. lIsDir( cPathOld )
      dbUseArea( .t., cDriver(), cPath + "TipInci.Dbf", cCheckArea( "TipInci", @dbfInci ), .f. )
      if !( dbfInci )->( neterr() )
         ( dbfInci )->( __dbApp( cPathOld + "TipInci.Dbf" ) )
         ( dbfInci )->( dbCloseArea() )
      end if
   end if

   rxInci( cPath, oMeter )

RETURN .t.

//---------------------------------------------------------------------------//

function aItmInci()

   local aBase  := {}

   aAdd( aBase, { "CCODINCI",   "C",  3, 0, "Código incidencia",    "'@!'",               "" } )
   aAdd( aBase, { "CNOMINCI",   "C", 50, 0, "Nombre incidencia",    "",                   "" } )

return ( aBase )

//---------------------------------------------------------------------------//

FUNCTION rxInci( cPath, oMeter )

   local dbfInci

   DEFAULT cPath := cPatEmp()

   if !lExistTable( cPath + "TIPINCI.DBF" )
      mkInci( cPath )
   end if

   fEraseIndex( cPath + "TIPINCI.CDX" )

   if lExistTable( cPath + "TIPINCI.DBF" )

      dbUseArea( .t., cDriver(), cPath + "TIPINCI.DBF", cCheckArea( "TIPINCI", @dbfInci ), .f. )

      if !( dbfInci )->( neterr() )
         ( dbfInci )->( __dbPack() )

         ( dbfInci )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
         ( dbfInci )->( ordCreate( cPath + "TIPINCI.CDX", "CCODINCI", "Field->CCODINCI", {|| Field->CCODINCI } ) )

         ( dbfInci )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
         ( dbfInci )->( ordCreate( cPath + "TIPINCI.CDX", "CNOMINCI", "Field->CNOMINCI", {|| Field->CNOMINCI } ) )

         ( dbfInci )->( dbCloseArea() )
      else
         msgStop( "Imposible abrir en modo exclusivo los tipos de incidencias" )
      end if

   end if

RETURN NIL

//---------------------------------------------------------------------------//

Function IsTipInci()

   local oError
   local oBlock
   local dbfInci

   if !lExistTable( cPatEmp() + "TIPINCI.Dbf" )
      mkInci( cPatEmp() )
   end if

   if !lExistIndex( cPatEmp() + "TIPINCI.Cdx" )
      rxInci( cPatEmp() )
   end if

   oBlock                     := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      USE ( cPatEmp() + "TIPINCI.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CCODINCI", @dbfInci ) )
      SET ADSINDEX TO ( cPatEmp() + "TIPINCI.Cdx" ) ADDITIVE

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE ( dbfInci )

Return ( .t. )

//----------------------------------------------------------------------------//