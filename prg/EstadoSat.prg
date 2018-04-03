#include "FiveWin.Ch"
#include "Font.ch"
#include "Report.ch"
#include "Factu.ch" 
#include "Image.ch"
#include "Xbrowse.ch"

#define MENUITEM     "01101"

static oWndBrw
static dbfEstadoSat
static aStrTipo      := {  "Círculo azul",;
                           "Círculo verde",;
                           "Círculo rojo",;
                           "Círculo amarillo",;
                           "Cuadrado azul",;
                           "Cuadrado verde",;
                           "Cuadrado rojo",;
                           "Cuadrado amarillo",;
                           "Triángulo azul",;
                           "Triángulo verde",;
                           "Triángulo rojo",;
                           "Triángulo amarillo" }

static aResTipo      := {  "BULLET_BALL_GLASS_BLUE_16",;
                           "BULLET_BALL_GLASS_GREEN_16",;
                           "BULLET_BALL_GLASS_RED_16",;
                           "BULLET_BALL_GLASS_YELLOW_16",;
                           "BULLET_SQUARE_BLUE_16",;
                           "gc_check_12",;
                           "gc_delete_12",;
                           "gc_shape_square_12",;
                           "BULLET_TRIANGLE_BLUE_16",;
                           "BULLET_TRIANGLE_GREEN_16",;
                           "BULLET_TRIANGLE_RED_16",;
                           "BULLET_TRIANGLE_YELLOW_16" }
static aBmpTipo
static bEdit         := {| aTmp, aGet, dbfEstadoSat, oBrw, bWhen, bValid, nMode | EdtRec( aTmp, aGet, dbfEstadoSat, oBrw, bWhen, bValid, nMode ) }

//---------------------------------------------------------------------------//
/*
Funcion con los campos de la base de datos de los estados de artículos
*/

Function aItmEstadoSat()

   local aBase := { }

   aAdd( aBase, { "cCodigo",   "C",  3, 0, "Código del estado" ,  "",   "", "( cdbfEstadoSat )"} )
   aAdd( aBase, { "cNombre",   "C", 50, 0, "Nombre del estado" ,  "",   "", "( cdbfEstadoSat )"} )
   aAdd( aBase, { "cTipo",     "C", 30, 0, "Tipo del estado" ,    "",   "", "( cdbfEstadoSat )"} )
   aAdd( aBase, { "nDisp",     "N",  1, 0, "Disponible" ,         "",   "", "( cdbfEstadoSat )"} )

Return ( aBase )

//---------------------------------------------------------------------------//

/*
Funcion para crear las bases de datos cuando no existen
*/

Function mkEstadoSat( cPath, lAppend, cPathOld )

   local dbfEstadoSat

   DEFAULT cPath   := cPatEmp()
   DEFAULT lAppend := .f.

   dbCreate( cPath + "EstadoSat.Dbf", aSqlStruct( aItmEstadoSat() ), cDriver() )

   if lAppend .and. !Empty( cPathOld ) .and. lExistTable( cPathOld + "EstadoSat.Dbf" )

      dbUseArea( .t., cDriver(), cPath + "EstadoSat.Dbf", cCheckArea( "EstadoSat", @dbfEstadoSat ), .f. )
   
      if !( dbfEstadoSat )->( neterr() )
         ( dbfEstadoSat )->( __dbApp( cPathOld + "EstadoSat.Dbf" ) )
         ( dbfEstadoSat )->( dbCloseArea() )
      end if
   
   end if

   rxEstadoSat( cPath )

Return ( nil )

//--------------------------------------------------------------------------//
/*
Funcion para crear los indices
*/

Function rxEstadoSat( cPath )

   local dbfEstadoSat

   DEFAULT cPath  := cPatEmp()

   if lExistIndex( cPath + "EstadoSat.Cdx" )
      ferase( cPath + "EstadoSat.Cdx" )
   end if

   dbUseArea( .t., cDriver(), cPath + "EstadoSat.Dbf", cCheckArea( "EstadoSat", @dbfEstadoSat ), .f. )
   if !( dbfEstadoSat )->( neterr() )
      ( dbfEstadoSat )->( __dbPack() )

      ( dbfEstadoSat )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfEstadoSat )->( ordCreate( cPath + "EstadoSat.CDX", "Codigo", "cCodigo", {|| Field->cCodigo }, ) )

      ( dbfEstadoSat )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfEstadoSat )->( ordCreate( cPath + "EstadoSat.CDX", "Nombre", "Upper( cNombre )", {|| Upper( Field->cNombre ) } ) )

      ( dbfEstadoSat )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de estados de los SAT" )
   end if

Return ( nil )

//---------------------------------------------------------------------------//
/*
Funcion que abre los ficheros necesarios
*/

Static Function OpenFiles()

   local lOpen       := .t.
   local oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   USE ( cPatEmp() + "EstadoSat.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "EstadoSat", @dbfEstadoSat ) )
   SET ADSINDEX TO ( cPatEmp() + "EstadoSat.CDX" ) ADDITIVE

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lOpen )

//---------------------------------------------------------------------------//
/*
Funcion que cierra los ficheros abiertos
*/

Static Function CloseFiles()

   if oWndBrw != nil
      oWndBrw     := nil
   end if

   CLOSE ( dbfEstadoSat )

   dbfEstadoSat   := nil
   aBmpTipo       := nil

Return ( .t. )

//---------------------------------------------------------------------------//
/*
Funcion que crea el browse general de estados
*/

FUNCTION EstadoSat( oMenuItem, oWnd )

   local nLevel

   DEFAULT  oMenuItem   := MENUITEM
   DEFAULT  oWnd        := oWnd()

   if oWndBrw == nil

      /*
      Obtenemos el nivel de acceso
      */

      nLevel            := Auth():Level( oMenuItem )

      if nAnd( nLevel, 1 ) == 0
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

      AddMnuNext( "Estados SAT", ProcName() )

      DEFINE SHELL oWndBrw FROM 2, 10 TO 18, 70 ;
      XBROWSE ;
      TITLE    "Estados artículos" ;
      PROMPT   "Código",;
               "Nombre";
      ALIAS    ( dbfEstadoSat ) ;
      MRU      "gc_bookmarks_16" ;
      BITMAP   clrTopArchivos ;
      APPEND   ( WinAppRec( oWndBrw:oBrw, bEdit, dbfEstadoSat ) );
      DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdit, dbfEstadoSat ) );
      EDIT     ( WinEdtRec( oWndBrw:oBrw, bEdit, dbfEstadoSat ) );
      DELETE   ( WinDelRec( oWndBrw:oBrw, dbfEstadoSat ) ) ;
      LEVEL    nLevel ;
      OF       oWnd

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodigo"
         :bStrData         := {|| ( dbfEstadoSat )->cCodigo }
         :bBmpData         := {|| nBitmapTipoEstadoSat( ( dbfEstadoSat )->cTipo ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         aEval( aResTipo, {|cRes| :AddResource( cRes ) } )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNombre"
         :bEditValue       := {|| ( dbfEstadoSat )->cNombre }
         :nWidth           := 260
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

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

      DEFINE BTNSHELL RESOURCE "DUP" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( oWndBrw:RecDup() );
         TOOLTIP  "(D)uplicar";
         MRU ;
         HOTKEY   "D";
         LEVEL    ACC_APPD

      DEFINE BTNSHELL RESOURCE "EDIT" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( oWndBrw:RecEdit() );
         TOOLTIP  "(M)odificar";
         HOTKEY   "M";
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "ZOOM" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( WinZooRec( oWndBrw:oBrw, bEdit, dbfEstadoSat ) );
         TOOLTIP  "(Z)oom";
         HOTKEY   "Z";
         LEVEL    ACC_ZOOM

      DEFINE BTNSHELL RESOURCE "DEL" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( oWndBrw:RecDel() );
         TOOLTIP  "(E)liminar";
         HOTKEY   "E";
         LEVEL    ACC_DELE

      DEFINE BTNSHELL RESOURCE "END" GROUP OF oWndBrw ;
         NOBORDER ;
         ACTION   ( oWndBrw:End() ) ;
         TOOLTIP  "(S)alir" ;
         HOTKEY   "S"

      ACTIVATE WINDOW oWndBrw VALID ( CloseFiles() )

   else

      oWndBrw:SetFocus()

   end if

Return nil

//----------------------------------------------------------------------------//
/*Funcion que edita el registro en el que nos encontramos*/

Static Function EdtRec( aTmp, aGet, dbfEstadoSat, oBrw, bWhen, bValid, nMode )

   local oDlg

   if nMode == APPD_MODE
      aTmp[ ( dbfEstadoSat )->( fieldpos( "cTipo" ) ) ]  := aStrTipo[ 1 ]
   end if

   DEFINE DIALOG oDlg RESOURCE "ESTADOSAT" TITLE LblTitle( nMode ) + "estado de SAT"

      REDEFINE GET aGet[ ( dbfEstadoSat )->( fieldpos( "cCodigo" ) ) ] ;
         VAR      aTmp[ ( dbfEstadoSat )->( fieldpos( "cCodigo" ) ) ] ;
         ID       100 ;
         WHEN     ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) ;
         VALID    ( NotValid( aGet[ ( dbfEstadoSat )->( fieldpos( "cCodigo" ) ) ], dbfEstadoSat, .t., "0" ) ) ;
         PICTURE  "@!" ;
         COLOR    CLR_GET ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfEstadoSat )->( fieldpos( "cNombre" ) ) ] ;
         VAR      aTmp[ ( dbfEstadoSat )->( fieldpos( "cNombre" ) ) ] ;
         ID       110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
         OF       oDlg

      REDEFINE COMBOBOX aGet[ ( dbfEstadoSat )->( fieldpos( "cTipo" ) ) ] ;
         VAR      aTmp[ ( dbfEstadoSat )->( fieldpos( "cTipo" ) ) ] ;
         ID       120 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ITEMS    aStrTipo ;
         BITMAPS  aResTipo ;
         OF       oDlg

      REDEFINE RADIO aTmp[ ( dbfEstadoSat )->( fieldpos( "nDisp" ) ) ] ;
         ID       130, 140 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       500 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( EndTrans( aTmp, aGet, nMode, oBrw, oDlg ) )

      REDEFINE BUTTON ;
         ID       510 ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| EndTrans( aTmp, aGet, nMode, oBrw, oDlg ) } )
   end if

   oDlg:bStart    := {|| aGet[ ( dbfEstadoSat )->( fieldpos( "cCodigo" ) ) ]:SetFocus() }

   ACTIVATE DIALOG oDlg CENTER

Return ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//
/*Funcion que finaliza la edición del registro y lo guarda*/

Static Function EndTrans( aTmp, aGet, nMode, oBrw, oDlg )

   local nRec
   local nOrdAnt

   if nMode == APPD_MODE .or. nMode == DUPL_MODE

      /*
      Estos Campos no pueden estar vacíos
      */

      if Empty( aTmp[ ( dbfEstadoSat )->( fieldpos( "cCodigo" ) ) ] )
         MsgStop( "Código no puede estar vacío" )
         aGet[ ( dbfEstadoSat )->( fieldpos( "cCodigo" ) ) ]:SetFocus()
         return nil
      end if

      if dbSeekInOrd( aTmp[ ( dbfEstadoSat )->( fieldpos( "cCodigo" ) ) ], "CODIGO", dbfEstadoSat )
         MsgStop( "Código ya existe " + Rtrim( aTmp[ ( dbfEstadoSat )->( fieldpos( "cCodigo" ) ) ] ) )
         return nil
      end if

      if Empty( aTmp[ ( dbfEstadoSat )->( fieldpos( "cNombre" ) ) ] )
         MsgStop( "Nombre no puede estar vacío" )
         aGet[ ( dbfEstadoSat )->( fieldpos( "cNombre" ) ) ]:SetFocus()
         return nil
      end if

      /*
      Comprobamos que el nombre sea único
      */

      nRec     := ( dbfEstadoSat )->( Recno() )
      nOrdAnt  := ( dbfEstadoSat )->( OrdSetFocus( "NOMBRE" ) )

      if( dbfEstadoSat )->( dbSeek( Upper( aTmp[ ( dbfEstadoSat )->( fieldpos( "cNombre" ) ) ] ) ) )
         MsgStop( "Nombre de estado existente" )
         aGet[ ( dbfEstadoSat )->( fieldpos( "cNombre" ) ) ]:SetFocus()
         ( dbfEstadoSat )->( OrdSetFocus( nOrdAnt ) )
         ( dbfEstadoSat )->( dbGoTo( nRec ) )
         return nil
      end if

      ( dbfEstadoSat )->( OrdSetFocus( nOrdAnt ) )
      ( dbfEstadoSat )->( dbGoTo( nRec ) )

   end if

   WinGather( aTmp, aGet, dbfEstadoSat, oBrw, nMode )

   oDlg:end( IDOK )

Return ( nil )

//---------------------------------------------------------------------------//

/*
Funcion que devuelve el bitmap del color o el nombre
*/

Static Function cBitmapTipo( cTipo, aStrTipo )

   local cBitmapTipo := ""

   if !Empty( cTipo )
      cBitmapTipo    := aResTipo[ aScan( aStrTipo, AllTrim( cTipo ) ) ]
   end if

return ( cBitmapTipo )

//---------------------------------------------------------------------------//

Function nBitmapTipoEstadoSat( cTipo )

   local nBitmapTipo := 0

   if !Empty( cTipo )
      nBitmapTipo    := aScan( aStrTipo, AllTrim( cTipo ) )
   end if

return ( nBitmapTipo )

//---------------------------------------------------------------------------//

Function cEstadoArticulo( oGet, dbfEstadoSat, oGet2, oBmpEstado  )

   local oBlock
   local oError
   local nOrd
   local lOpen          := .f.
   local lValid         := .f.
   local xValor         := oGet:varGet()

   if Empty( xValor ) .or. ( xValor == replicate( "Z", 3 ) )
      if( oGet2 != nil, oGet2:cText( "" ), )
      return .t.
   else
      xValor   := RJustObj( oGet, "0" )
   end if

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if dbfEstadoSat == nil

      USE ( cPatEmp() + "ESTADOSAT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ESTADOSAT", @dbfEstadoSat ) )
      SET ADSINDEX TO ( cPatEmp() + "ESTADOSAT.CDX" ) ADDITIVE

      lOpen             := .t.

   end if

   nOrd                 := ( dbfEstadoSat )->( OrdSetFocus( "Codigo" ) )

   if ( dbfEstadoSat )->( dbSeek( xValor ) )

      oGet:cText( ( dbfEstadoSat )->cCodigo )

      if !Empty( oGet2 )
         oGet2:cText( ( dbfEstadoSat )->cNombre )
      end if

      if !Empty( oBmpEstado ) .and. !Empty( ( dbfEstadoSat )->cTipo )
         oBmpEstado:ReLoad( aResTipo[ Max( aScan( aStrTipo, AllTrim( ( dbfEstadoSat )->cTipo ) ), 1 ) ] )
      end if

      lValid            := .t.

   else
      msgStop( "Estado no encontrado", "Aviso del sistema" )
   end if

   ( dbfEstadoSat )->( OrdSetFocus( nOrd ) )

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if lOpen
      CLOSE( dbfEstadoSat )
   end if

Return lValid

//---------------------------------------------------------------------------//

Function BrwEstadoArticulo( oGet, oGet2, oBmpEstado )

   local uVar
   local oDlg
	local oBrw
	local oGet1
	local cGet1
   local nOrd           := GetBrwOpt( "BrwEstadoArticulo" )
	local oCbxOrd
   local aCbxOrd        := { "Código", "Nombre" }
   local cCbxOrd
   local nLevelUsr

   nOrd                 := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd              := aCbxOrd[ nOrd ]

   if !OpenFiles()
      return .t.
   end if

   nOrd                 := ( dbfEstadoSat )->( OrdSetFocus( nOrd ) )

   ( dbfEstadoSat )->( dbGoTop() )

   nLevelUsr            := Auth():Level( MENUITEM )

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Estado artículos"

		REDEFINE GET oGet1 VAR cGet1;
         ID       104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfEstadoSat ) ) ;
         VALID    ( OrdClearScope( oBrw, dbfEstadoSat ) );
         BITMAP   "FIND" ;
         OF       oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( ( dbfEstadoSat )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:refresh(), oGet1:SetFocus() ) ;
			OF 		oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfEstadoSat
      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "Browse.Estado.Articulos"

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "Codigo"
         :bStrData         := {|| ( dbfEstadoSat )->cCodigo }
         :bBmpData         := {|| nBitmapTipoEstadoSat( ( dbfEstadoSat )->cTipo ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
         aEval( aResTipo, {|cRes| :AddResource( cRes ) } )
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "Nombre"
         :bEditValue       := {|| ( dbfEstadoSat )->cNombre }
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
         WHEN     ( nAnd( nLevelUsr, ACC_APPD ) != 0 .and. !IsReport() ) ;
         ACTION   ( WinAppRec( oBrw, bEdit, dbfEstadoSat ) )

		REDEFINE BUTTON ;
         ID       501 ;
         OF       oDlg ;
         WHEN     ( nAnd( nLevelUsr, ACC_EDIT ) != 0 .and. !IsReport() ) ;
         ACTION   ( WinEdtRec( oBrw, bEdit, dbfEstadoSat ) )

   if nAnd( nLevelUsr, ACC_APPD ) != 0
      oDlg:AddFastKey( VK_F2, {|| WinAppRec( oBrw, bEdit, dbfEstadoSat ) } )
   end if

   if nAnd( nLevelUsr, ACC_EDIT ) != 0
      oDlg:AddFastKey( VK_F3, {|| WinEdtRec( oBrw, bEdit, dbfEstadoSat ) } )
   end if

   oDlg:AddFastKey( VK_F5,    {|| oDlg:end( IDOK ) } )
   oDlg:AddFastKey( VK_RETURN,{|| oDlg:end( IDOK ) } )

   oDlg:bStart    := {|| oBrw:Load() }

   ACTIVATE DIALOG oDlg CENTER

   DestroyFastFilter( dbfEstadoSat )

   SetBrwOpt( "BrwEstadoArticulo", ( dbfEstadoSat )->( OrdNumber() ) )

   if oDlg:nResult == IDOK

      uVar        := ( dbfEstadoSat )->cCodigo

      if !Empty( oGet )
         oGet:cText( ( dbfEstadoSat )->cCodigo )
      end if

      if !Empty( oGet2 )
         oGet2:cText( ( dbfEstadoSat )->cNombre )
      end if

      if oBmpEstado != nil .and. !Empty( ( dbfEstadoSat )->cTipo )
         oBmpEstado:ReLoad( aResTipo[ aScan( aStrTipo, AllTrim( ( dbfEstadoSat )->cTipo ) ) ] )
      end if

   end if

   CloseFiles()

   if !Empty( oGet )
      oGet:setFocus()
   end if

Return ( uVar )

//---------------------------------------------------------------------------//