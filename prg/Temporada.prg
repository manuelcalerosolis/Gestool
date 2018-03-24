#include "FiveWin.Ch"
#include "Font.ch"
#include "Report.ch"
#include "Factu.ch" 
#include "Image.ch"
#include "Xbrowse.ch"

#define MENUITEM     "01114"

static oWndBrw

static dbfTemporada

static aBmpTipo
static aStrTipo      := {  "Sol", "Sol y nubes", "Nubes", "Lluvia", "Nieve" }
static aResTipo      := {  "gc_sun_16", "gc_cloud_sun_16", "gc_cloud_16", "gc_cloud_rain_16", "gc_snowflake_16" }

static bEdit         := {| aTmp, aGet, dbfTemporada, oBrw, bWhen, bValid, nMode | EdtRec( aTmp, aGet, dbfTemporada, oBrw, bWhen, bValid, nMode ) }

//---------------------------------------------------------------------------//
/*
Funcion con los campos de la base de datos de las Temporadas de artículos
*/

Function aItmTemporada()

   local aBase := { }

   aAdd( aBase, { "cCodigo",   "C", 10, 0, "Código de la Temporada" ,   "",   "", "( cDbfTemporada )"} )
   aAdd( aBase, { "cNombre",   "C", 50, 0, "Nombre de la Temporada" ,   "",   "", "( cDbfTemporada )"} )
   aAdd( aBase, { "cTipo",     "C", 30, 0, "Tipo de la Temporada" ,     "",   "", "( cDbfTemporada )"} )

Return ( aBase )

//---------------------------------------------------------------------------//
/*
Funcion para crear las bases de datos cuando no existen
*/

Function mkTemporada( cPath, lAppend, cPathOld )

   local dbfTemporada

	DEFAULT lAppend := .f.
   DEFAULT cPath   := cPatArt()

   dbCreate( cPath + "Temporadas.Dbf", aSqlStruct( aItmTemporada() ), cDriver() )

   if lAppend .and. lIsDir( cPathOld ) .and. lExistTable( cPathOld + "Temporadas.dbf" )

      dbUseArea( .t., cDriver(), cPath + "Temporadas.Dbf", cCheckArea( "Temporada", @dbfTemporada ), .f. )
      
      if !( dbfTemporada )->( neterr() )
         ( dbfTemporada )->( __dbApp( cPathOld + "Temporadas.Dbf" ) )
         ( dbfTemporada )->( dbCloseArea() )
      end if
      
   end if

   rxTemporada( cPath )

Return ( nil )

//--------------------------------------------------------------------------//
/*
Funcion para crear los indices
*/

Function rxTemporada( cPath )

   local dbfTemporada

   DEFAULT cPath  := cPatArt()

   if !lExistTable( cPath + "Temporadas.Dbf" )
      mkTemporada( cPath )
   end if

   if lExistIndex( cPath + "Temporadas.Cdx" )
      ferase( cPath + "Temporadas.Cdx" )
   end if

   dbUseArea( .t., cDriver(), cPath + "Temporadas.Dbf", cCheckArea( "Temporada", @dbfTemporada ), .f. )

   if !( dbfTemporada )->( neterr() )
      ( dbfTemporada )->( __dbPack() )

      ( dbfTemporada )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfTemporada )->( ordCreate( cPath + "Temporadas.Cdx", "Codigo", "cCodigo", {|| Field->cCodigo }, ) )

      ( dbfTemporada )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfTemporada )->( ordCreate( cPath + "Temporadas.Cdx", "Nombre", "Upper( cNombre )", {|| Upper( Field->cNombre ) } ) )

      ( dbfTemporada )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de " + getConfigTraslation( "Temporadas" ) )
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

   /*
   if Empty( aBmpTipo )
      aBmpTipo       := aBmpTipoTemporada()
   end if
   */

   USE ( cPatArt() + "Temporadas.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "Temporada", @dbfTemporada ) )
   SET ADSINDEX TO ( cPatArt() + "Temporadas.Cdx" ) ADDITIVE

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

   CLOSE ( dbfTemporada )

   dbfTemporada   := nil
   aBmpTipo       := nil

Return ( .t. )

//---------------------------------------------------------------------------//
/*
Funcion que crea el browse general de Temporadas
*/

FUNCTION Temporada( oMenuItem, oWnd )

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


      DEFINE SHELL oWndBrw FROM 2, 10 TO 18, 70 ;
      XBROWSE ;
      TITLE    getConfigTraslation( "Temporadas de artículos" );
      PROMPT   "Código",;
               "Nombre";
      ALIAS    ( dbfTemporada ) ;
      MRU      "gc_cloud_sun_16" ;
      BITMAP   clrTopArchivos ;
      APPEND   ( WinAppRec( oWndBrw:oBrw, bEdit, dbfTemporada ) );
      DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdit, dbfTemporada ) );
      EDIT     ( WinEdtRec( oWndBrw:oBrw, bEdit, dbfTemporada ) );
      DELETE   ( WinDelRec( oWndBrw:oBrw, dbfTemporada ) ) ;
      LEVEL    nLevel ;
      OF       oWnd

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código"
         :cSortOrder       := "Codigo"
         :bStrData         := {|| ( dbfTemporada )->cCodigo }
         :bBmpData         := {|| nBitmapTipoTemporada( ( dbfTemporada )->cTipo ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         aEval( aResTipo, {|cRes| :AddResource( cRes ) } )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "Nombre"
         :bEditValue       := {|| ( dbfTemporada )->cNombre }
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
         ACTION   ( WinZooRec( oWndBrw:oBrw, bEdit, dbfTemporada ) );
         TOOLTIP  "(Z)oom";
         HOTKEY   "Z";
         LEVEL    ACC_ZOOM

      DEFINE BTNSHELL RESOURCE "DEL" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( oWndBrw:RecDel() );
         TOOLTIP  "(E)liminar";
         HOTKEY   "E";
         LEVEL    ACC_DELE

      DEFINE BTNSHELL RESOURCE "IMP" GROUP OF oWndBrw ;
			NOBORDER ;
         ACTION   ( TListadoTemporadas():New( "Listado de " + getConfigTraslation( "temporadas" ) ):Play( dbfTemporada ) );
         TOOLTIP  "(L)istado";
         HOTKEY   "L" ;
         LEVEL    ACC_IMPR

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

Static Function EdtRec( aTmp, aGet, dbfTemporada, oBrw, bWhen, bValid, nMode )

   local oDlg

   if nMode == APPD_MODE
      aTmp[ ( dbfTemporada )->( fieldpos( "cTipo" ) ) ]  := aStrTipo[ 1 ]
   end if

   DEFINE DIALOG oDlg RESOURCE "Categoria" TITLE LblTitle( nMode ) + getConfigTraslation( "Temporadas de artículos" )

      REDEFINE GET aGet[ ( dbfTemporada )->( fieldpos( "cCodigo" ) ) ] ;
         VAR      aTmp[ ( dbfTemporada )->( fieldpos( "cCodigo" ) ) ] ;
         ID       100 ;
         WHEN     ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) ; 
         PICTURE  "@!" ;
         COLOR    CLR_GET ;
         OF       oDlg

         //VALID    ( NotValid( aGet[ ( dbfTemporada )->( fieldpos( "cCodigo" ) ) ], dbfTemporada, .t., "0" ) ) ;

      REDEFINE GET aGet[ ( dbfTemporada )->( fieldpos( "cNombre" ) ) ] ;
         VAR      aTmp[ ( dbfTemporada )->( fieldpos( "cNombre" ) ) ] ;
         ID       110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
         OF       oDlg

      REDEFINE COMBOBOX aGet[ ( dbfTemporada )->( fieldpos( "cTipo" ) ) ] ;
         VAR      aTmp[ ( dbfTemporada )->( fieldpos( "cTipo" ) ) ] ;
         ID       120 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ITEMS    aStrTipo ;
         BITMAPS  aResTipo ;
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

   oDlg:bStart    := {|| aGet[ ( dbfTemporada )->( fieldpos( "cCodigo" ) ) ]:SetFocus() }

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

      if Empty( aTmp[ ( dbfTemporada )->( fieldpos( "cCodigo" ) ) ] )
         MsgStop( "Código no puede estar vacío" )
         aGet[ ( dbfTemporada )->( fieldpos( "cCodigo" ) ) ]:SetFocus()
         return nil
      end if

      if dbSeekInOrd( aTmp[ ( dbfTemporada )->( fieldpos( "cCodigo" ) ) ], "Codigo", dbfTemporada )
         MsgStop( "Código ya existe " + Rtrim( aTmp[ ( dbfTemporada )->( fieldpos( "cCodigo" ) ) ] ) )
         return nil
      end if

      if Empty( aTmp[ ( dbfTemporada )->( fieldpos( "cNombre" ) ) ] )
         MsgStop( "Nombre no puede estar vacío" )
         aGet[ ( dbfTemporada )->( fieldpos( "cNombre" ) ) ]:SetFocus()
         return nil
      end if

      /*
      Comprobamos que el nombre sea único
      */

      nRec     := ( dbfTemporada )->( Recno() )
      nOrdAnt  := ( dbfTemporada )->( OrdSetFocus( "NOMBRE" ) )

      if( dbfTemporada )->( dbSeek( Upper( aTmp[ ( dbfTemporada )->( fieldpos( "cNombre" ) ) ] ) ) )
         MsgStop( "Nombre de Temporada existente" )
         aGet[ ( dbfTemporada )->( fieldpos( "cNombre" ) ) ]:SetFocus()
         ( dbfTemporada )->( OrdSetFocus( nOrdAnt ) )
         ( dbfTemporada )->( dbGoTo( nRec ) )
         return nil
      end if

      ( dbfTemporada )->( OrdSetFocus( nOrdAnt ) )
      ( dbfTemporada )->( dbGoTo( nRec ) )

   end if

   /*Guardamos el color*/

   WinGather( aTmp, aGet, dbfTemporada, oBrw, nMode )

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

Function nBitmapTipoTemporada( cTipo )

   local nBitmapTipo := 0

   if !Empty( cTipo )
      nBitmapTipo    := aScan( aStrTipo, AllTrim( cTipo ) )
   end if

return ( nBitmapTipo )

//---------------------------------------------------------------------------//

Function cTemporada( oGet, dbfTemporada, oGet2, oBmpTemporada  )

   local oBlock
   local oError
   local nOrd
   local lOpen          := .f.
   local lValid         := .f.
   local xValor         := oGet:varGet()

   if ( Empty( xValor ) .or. Rtrim( xValor ) == "ZZZZZZZZZZ" )
      if( oGet2 != nil, oGet2:cText( "" ), )
      return .t.
   end if

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if dbfTemporada == nil

      USE ( cPatArt() + "Temporadas.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "Temporada", @dbfTemporada ) )
      SET ADSINDEX TO ( cPatArt() + "Temporadas.Cdx" ) ADDITIVE

      lOpen := .t.

   end if

   /*
   if Empty( aBmpTipo )
      aBmpTipo          := aBmpTipoTemporada()
   end if
   */

   nOrd                 := ( dbfTemporada )->( OrdSetFocus( "Codigo" ) )

   if ( dbfTemporada )->( dbSeek( xValor ) )

      oGet:cText( ( dbfTemporada )->cCodigo )

      if oGet2 != NIL
         oGet2:cText( ( dbfTemporada )->cNombre )
      end if

      if oBmpTemporada != nil
         oBmpTemporada:ReLoad( aResTipo[ aScan( aStrTipo, AllTrim( ( dbfTemporada )->cTipo ) ) ] )
      end if

      lValid            := .t.

   else
      msgStop( "Temporada no encontrada", "Aviso del sistema" )
   end if

   ( dbfTemporada )->( OrdSetFocus( nOrd ) )

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if lOpen
      CLOSE( dbfTemporada )
   end if

Return lValid

//---------------------------------------------------------------------------//

Function BrwTemporada( oGet, oGet2, oBmpTemporada )

   local uVar
   local oDlg
	local oBrw
   local oGetSeek
   local cGetSeek
   local nOrd           := GetBrwOpt( "BrwTemporada" )
	local oCbxOrd
   local aCbxOrd        := { "Código", "Nombre" }
   local cCbxOrd
   local nLevelUsr

   /*
   if Empty( aBmpTipo )
      aBmpTipo          := aBmpTipoTemporada()
   end if
   */

   nOrd                 := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd              := aCbxOrd[ nOrd ]

   if !OpenFiles()
      return .t.
   end if

   nOrd                 := ( dbfTemporada )->( OrdSetFocus( nOrd ) )

   ( dbfTemporada )->( dbGoTop() )

   nLevelUsr            := Auth():Level( MENUITEM )

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE getConfigTraslation( "Temporadas de artículos" )

      REDEFINE GET oGetSeek VAR cGetSeek;
         ID       104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfTemporada ) ) ;
         VALID    ( OrdClearScope( oBrw, dbfTemporada ) );
         BITMAP   "FIND" ;
         OF       oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( ( dbfTemporada )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:refresh(), oGetSeek:SetFocus() ) ;
			OF 		oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfTemporada
      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "Browse.Temporada"

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "Codigo"
         :bStrData         := {|| ( dbfTemporada )->cCodigo }
         :bBmpData         := {|| nBitmapTipoTemporada( ( dbfTemporada )->cTipo ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
         aEval( aResTipo, {|cRes| :AddResource( cRes ) } )
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "Nombre"
         :bEditValue       := {|| ( dbfTemporada )->cNombre }
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
         ACTION   ( WinAppRec( oBrw, bEdit, dbfTemporada ) )

		REDEFINE BUTTON ;
         ID       501 ;
         OF       oDlg ;
         WHEN     ( nAnd( nLevelUsr, ACC_EDIT ) != 0 .and. !IsReport() ) ;
         ACTION   ( WinEdtRec( oBrw, bEdit, dbfTemporada ) )

   if nAnd( nLevelUsr, ACC_APPD ) != 0
      oDlg:AddFastKey( VK_F2, {|| WinAppRec( oBrw, bEdit, dbfTemporada ) } )
   end if

   if nAnd( nLevelUsr, ACC_EDIT ) != 0
      oDlg:AddFastKey( VK_F3, {|| WinEdtRec( oBrw, bEdit, dbfTemporada ) } )
   end if

   oDlg:AddFastKey( VK_F5,    {|| oDlg:end( IDOK ) } )
   oDlg:AddFastKey( VK_RETURN,{|| oDlg:end( IDOK ) } )

   oDlg:bStart    := {|| oBrw:Load() }

   ACTIVATE DIALOG oDlg CENTER

   DestroyFastFilter( dbfTemporada )

   SetBrwOpt( "BrwTemporada", ( dbfTemporada )->( OrdNumber() ) )

   if oDlg:nResult == IDOK

      uVar        := ( dbfTemporada )->cCodigo

      if !Empty( oGet )
         oGet:cText( ( dbfTemporada )->cCodigo )
      end if

      if !Empty( oGet2 )
         oGet2:cText( ( dbfTemporada )->cNombre )
      end if

      if oBmpTemporada != nil .and. !Empty( ( dbfTemporada )->cTipo )
         oBmpTemporada:ReLoad( aResTipo[ aScan( aStrTipo, AllTrim( ( dbfTemporada )->cTipo ) ) ] )
      end if

   end if

   CloseFiles()

   if !Empty( oGet )
      oGet:setFocus()
   end if

Return ( uVar )

//---------------------------------------------------------------------------//

Function BrwInternalTemporada( oGet, dbfArticulo, oGet2 )

   local oDlg
	local oBrw
	local oGet1
	local cGet1
   local nRec
   local nOrd           := GetBrwOpt( "BrwTemporada" )
	local oCbxOrd
   local aCbxOrd        := { "Código", "Nombre" }
   local cCbxOrd
   local oBtnEdit
   local oBtnAppend
   local nLevelUsr

   nOrd                 := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd              := aCbxOrd[ nOrd ]

   nRec                 := ( dbfTemporada )->( Recno() )
   nOrd                 := ( dbfTemporada )->( OrdSetFocus( nOrd ) )

   ( dbfTemporada )->( dbGoTop() )

   nLevelUsr            := Auth():Level( MENUITEM )

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE getConfigTraslation( "Temporadas de artículos" )

		REDEFINE GET oGet1 VAR cGet1;
         ID       104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfTemporada ) ) ;
         VALID    ( OrdClearScope( oBrw, dbfTemporada ) );
         BITMAP   "FIND" ;
         OF       oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( ( dbfTemporada )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:refresh(), oGet1:SetFocus() ) ;
			OF 		oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfTemporada

      oBrw:nMarqueeStyle   := 5

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }

      oBrw:CreateFromResource( 105 )

      with object ( oBrw:AddCol() )
         :cHeader             := "Código"
         :cSortOrder          := "Codigo"
         :bEditValue          := {|| ( dbfTemporada )->cCodigo }
         :nWidth              := 60
         :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Nombre"
         :cSortOrder          := "Nombre"
         :bEditValue          := {|| ( dbfTemporada )->cNombre }
         :nWidth              := 400
         :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

		REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( oDlg:end(IDOK) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         ACTION   ( oDlg:end() )

      REDEFINE BUTTON oBtnAppend ;
         ID       500 ;
         OF       oDlg ;
         ACTION   ( nil )

      REDEFINE BUTTON oBtnEdit ;
         ID       501 ;
         OF       oDlg ;
         ACTION   ( nil )

   oDlg:AddFastKey( VK_F5,    {|| oDlg:end( IDOK ) } )
   oDlg:AddFastKey( VK_RETURN,{|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER ON INIT ( oBtnAppend:Hide(), oBtnEdit:Hide() )

   DestroyFastFilter( dbfTemporada )

   SetBrwOpt( "BrwTemporada", ( dbfTemporada )->( OrdNumber() ) )

   if oDlg:nResult == IDOK
      oGet:cText( ( dbfTemporada )->cCodigo )

      if oGet2 != nil
         oGet2:cText( ( dbfTemporada )->cNombre )
      end if
   end if

   ( dbfTemporada )->( dbGoTo( nRec ) )
   ( dbfTemporada )->( OrdSetFocus( nOrd ) )

   oGet:SetFocus()

Return ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//


Function aBmpTipoTemporada()

   local aBmpTipo    := {  LoadBitmap( GetResources(), "BULLET_BALL_GLASS_BLUE_16" ),;
                           LoadBitmap( GetResources(), "BULLET_BALL_GLASS_GREEN_16" ),;
                           LoadBitmap( GetResources(), "BULLET_BALL_GLASS_RED_16" ),;
                           LoadBitmap( GetResources(), "BULLET_BALL_GLASS_YELLOW_16" ),;
                           LoadBitmap( GetResources(), "BULLET_SQUARE_BLUE_16" ),;
                           LoadBitmap( GetResources(), "gc_check_12" ),;
                           LoadBitmap( GetResources(), "gc_delete_12" ),;
                           LoadBitmap( GetResources(), "gc_shape_square_12" ),;
                           LoadBitmap( GetResources(), "BULLET_TRIANGLE_BLUE_16" ),;
                           LoadBitmap( GetResources(), "BULLET_TRIANGLE_GREEN_16" ),;
                           LoadBitmap( GetResources(), "BULLET_TRIANGLE_RED_16" ),;
                           LoadBitmap( GetResources(), "BULLET_TRIANGLE_YELLOW_16" ) }

Return ( aBmpTipo )

//---------------------------------------------------------------------------//

Function aStrTipoTemporada()

Return( aStrTipo )

//---------------------------------------------------------------------------//

Function AddResourceTipoTemporada( oCol )

   local cResTipo

   if !Empty( oCol )
      for each cResTipo in aResTipo
         oCol:AddResource( cResTipo )
      next
   end if

Return ( oCol )

//---------------------------------------------------------------------------//