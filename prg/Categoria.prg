#include "FiveWin.Ch"
#include "Font.ch"
#include "Report.ch"
#include "Factu.ch" 
#include "Image.ch"
#include "Xbrowse.ch"

#define MENUITEM     "01101"

static oWndBrw
static dbfCategoria
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
static bEdit         := {| aTmp, aGet, dbfCategoria, oBrw, bWhen, bValid, nMode | EdtRec( aTmp, aGet, dbfCategoria, oBrw, bWhen, bValid, nMode ) }

//---------------------------------------------------------------------------//
/*
Funcion con los campos de la base de datos de las categorias de artículos
*/

Function aItmCategoria()

   local aBase := { }

   aAdd( aBase, { "cCodigo",   "C", 10, 0, "Código de la categoría" ,   "",   "", "( cDbfCategoria )"} )
   aAdd( aBase, { "cNombre",   "C", 50, 0, "Nombre de la categoría" ,   "",   "", "( cDbfCategoria )"} )
   aAdd( aBase, { "cTipo",     "C", 30, 0, "Tipo de la categoría" ,     "",   "", "( cDbfCategoria )"} )

Return ( aBase )

//---------------------------------------------------------------------------//
/*
Funcion para crear las bases de datos cuando no existen
*/

Function mkCategoria( cPath, lAppend, cPathOld )

   local dbfCategoria

   DEFAULT lAppend := .f.
   DEFAULT cPath   := cPatArt()

   dbCreate( cPath + "Categorias.Dbf", aSqlStruct( aItmCategoria() ), cDriver() )

   if lAppend .and. !Empty( cPathOld ) .and. lExistTable( cPathOld + "Categorias.Dbf" )

      dbUseArea( .t., cDriver(), cPath + "Categorias.Dbf", cCheckArea( "Categorias", @dbfCategoria ), .f. )
   
      if !( dbfCategoria )->( neterr() )
         ( dbfCategoria )->( __dbApp( cPathOld + "Categorias.Dbf" ) )
         ( dbfCategoria )->( dbCloseArea() )
      end if
   
   end if

   rxCategoria( cPath )

Return ( nil )

//--------------------------------------------------------------------------//
/*
Funcion para crear los indices
*/

Function rxCategoria( cPath )

   local dbfCategoria

   DEFAULT cPath  := cPatArt()

   if !lExistTable( cPath + "Categorias.Dbf" )
      mkCategoria( cPath )
   end if

   if lExistIndex( cPath + "Categorias.Cdx" )
      ferase( cPath + "Categorias.Cdx" )
   end if

   dbUseArea( .t., cDriver(), cPath + "Categorias.Dbf", cCheckArea( "CATEGORIA", @dbfCategoria ), .f. )
   if !( dbfCategoria )->( neterr() )
      ( dbfCategoria )->( __dbPack() )

      ( dbfCategoria )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfCategoria )->( ordCreate( cPath + "CATEGORIAS.CDX", "CODIGO", "CCODIGO", {|| Field->CCODIGO }, ) )

      ( dbfCategoria )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfCategoria )->( ordCreate( cPath + "CATEGORIAS.CDX", "Nombre", "Upper( cNombre )", {|| Upper( Field->cNombre ) } ) )

      ( dbfCategoria )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de " + getConfigTraslation( "Categorías" ) )
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
      aBmpTipo       := aBmpTipoCategoria()
   end if
   */

   USE ( cPatArt() + "CATEGORIAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CATEGORIA", @dbfCategoria ) )
   SET ADSINDEX TO ( cPatArt() + "CATEGORIAS.CDX" ) ADDITIVE

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

   CLOSE ( dbfCategoria )

   dbfCategoria   := nil
   aBmpTipo       := nil

Return ( .t. )

//---------------------------------------------------------------------------//
/*
Funcion que crea el browse general de categorias
*/

FUNCTION Categoria( oMenuItem, oWnd )

   local nLevel

   DEFAULT  oMenuItem   := MENUITEM
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

      DEFINE SHELL oWndBrw FROM 2, 10 TO 18, 70 ;
      XBROWSE ;
      TITLE    getConfigTraslation( "Categorías" ) ;
      PROMPT   "Código",;
               "Nombre";
      ALIAS    ( dbfCategoria ) ;
      MRU      "gc_photographic_filters_16" ;
      BITMAP   clrTopArchivos ;
      APPEND   ( WinAppRec( oWndBrw:oBrw, bEdit, dbfCategoria ) );
      DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdit, dbfCategoria ) );
      EDIT     ( WinEdtRec( oWndBrw:oBrw, bEdit, dbfCategoria ) );
      DELETE   ( WinDelRec( oWndBrw:oBrw, dbfCategoria ) ) ;
      LEVEL    nLevel ;
      OF       oWnd

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodigo"
         :bStrData         := {|| ( dbfCategoria )->cCodigo }
         :bBmpData         := {|| nBitmapTipoCategoria( ( dbfCategoria )->cTipo ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         aEval( aResTipo, {|cRes| :AddResource( cRes ) } )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNombre"
         :bEditValue       := {|| ( dbfCategoria )->cNombre }
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
         ACTION   ( WinZooRec( oWndBrw:oBrw, bEdit, dbfCategoria ) );
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

Static Function EdtRec( aTmp, aGet, dbfCategoria, oBrw, bWhen, bValid, nMode )

   local oDlg

   if nMode == APPD_MODE
      aTmp[ ( dbfCategoria )->( fieldpos( "cTipo" ) ) ]  := aStrTipo[ 1 ]
   end if

   DEFINE DIALOG oDlg RESOURCE "CATEGORIA" TITLE LblTitle( nMode ) + getConfigTraslation( "categoría" )

      REDEFINE GET aGet[ ( dbfCategoria )->( fieldpos( "cCodigo" ) ) ] ;
         VAR      aTmp[ ( dbfCategoria )->( fieldpos( "cCodigo" ) ) ] ;
         ID       100 ;
         WHEN     ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) ;
         PICTURE  "@!" ;
         COLOR    CLR_GET ;
         OF       oDlg

         //VALID    ( NotValid( aGet[ ( dbfCategoria )->( fieldpos( "cCodigo" ) ) ], dbfCategoria, .t., "0" ) ) ;

      REDEFINE GET aGet[ ( dbfCategoria )->( fieldpos( "cNombre" ) ) ] ;
         VAR      aTmp[ ( dbfCategoria )->( fieldpos( "cNombre" ) ) ] ;
         ID       110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
         OF       oDlg

      REDEFINE COMBOBOX aGet[ ( dbfCategoria )->( fieldpos( "cTipo" ) ) ] ;
         VAR      aTmp[ ( dbfCategoria )->( fieldpos( "cTipo" ) ) ] ;
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

   oDlg:bStart    := {|| aGet[ ( dbfCategoria )->( fieldpos( "cCodigo" ) ) ]:SetFocus() }

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

      if Empty( aTmp[ ( dbfCategoria )->( fieldpos( "cCodigo" ) ) ] )
         MsgStop( "Código no puede estar vacío" )
         aGet[ ( dbfCategoria )->( fieldpos( "cCodigo" ) ) ]:SetFocus()
         return nil
      end if

      if dbSeekInOrd( aTmp[ ( dbfCategoria )->( fieldpos( "cCodigo" ) ) ], "CODIGO", dbfCategoria )
         MsgStop( "Código ya existe " + Rtrim( aTmp[ ( dbfCategoria )->( fieldpos( "cCodigo" ) ) ] ) )
         return nil
      end if

      if Empty( aTmp[ ( dbfCategoria )->( fieldpos( "cNombre" ) ) ] )
         MsgStop( "Nombre no puede estar vacío" )
         aGet[ ( dbfCategoria )->( fieldpos( "cNombre" ) ) ]:SetFocus()
         return nil
      end if

      /*
      Comprobamos que el nombre sea único
      */

      nRec     := ( dbfCategoria )->( Recno() )
      nOrdAnt  := ( dbfCategoria )->( OrdSetFocus( "NOMBRE" ) )

      if( dbfCategoria )->( dbSeek( Upper( aTmp[ ( dbfCategoria )->( fieldpos( "cNombre" ) ) ] ) ) )
         MsgStop( "Nombre de " + getConfigTraslation( "categoría" ) + " existente" )
         aGet[ ( dbfCategoria )->( fieldpos( "cNombre" ) ) ]:SetFocus()
         ( dbfCategoria )->( OrdSetFocus( nOrdAnt ) )
         ( dbfCategoria )->( dbGoTo( nRec ) )
         return nil
      end if

      ( dbfCategoria )->( OrdSetFocus( nOrdAnt ) )
      ( dbfCategoria )->( dbGoTo( nRec ) )

   end if

   /*Guardamos el color*/

   WinGather( aTmp, aGet, dbfCategoria, oBrw, nMode )

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

Function nBitmapTipoCategoria( cTipo )

   local nBitmapTipo := 0

   if !Empty( cTipo )
      nBitmapTipo    := aScan( aStrTipo, AllTrim( cTipo ) )
   end if

return ( nBitmapTipo )

//---------------------------------------------------------------------------//

Function cCategoria( oGet, oGet2, oBmpCategoria  )

   local oBlock
   local oError
   local lValid         := .f.
   local xValor         := oGet:varGet()
   local dbfSql         := "Categorias"

   if Empty( xValor ) .or. ( xValor == replicate( "Z", 10 ) )
      if( oGet2 != nil, oGet2:cText( "" ), )
      return .t.
   end if

   CategoriasModel():getSelectFromCategoria( dbfSql, xValor )

   if !( dbfSql )->( Eof() )

      oGet:cText( ( dbfSql )->cCodigo )

      if !Empty( oGet2 )
         oGet2:cText( ( dbfSql )->cNombre )
      end if

      if !Empty( oBmpCategoria ) .and. !Empty( ( dbfSql )->cTipo )
         oBmpCategoria:ReLoad( aResTipo[ Max( aScan( aStrTipo, AllTrim( ( dbfSql )->cTipo ) ), 1 ) ] )
      end if

      lValid            := .t.

   else
      msgStop( "Categoría no encontrada", "Aviso del sistema" )
   end if

Return lValid

//---------------------------------------------------------------------------//

Function BrwCategoria( oGet, oGet2, oBmpCategoria )

   local uVar
   local oDlg
   local oBrw
   local oGet1
   local cGet1
   local nOrd           := GetBrwOpt( "BrwCategoria" )
   local oCbxOrd
   local aCbxOrd        := { "Código", "Nombre" }
   local cCbxOrd
   local nLevelUsr

   nOrd                 := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd              := aCbxOrd[ nOrd ]

   if !OpenFiles()
      return .t.
   end if

   nOrd                 := ( dbfCategoria )->( OrdSetFocus( nOrd ) )

   ( dbfCategoria )->( dbGoTop() )

   nLevelUsr            := nLevelUsr( MENUITEM )

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE getConfigTraslation( "Categorías" )

      REDEFINE GET oGet1 VAR cGet1;
         ID       104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfCategoria ) ) ;
         VALID    ( OrdClearScope( oBrw, dbfCategoria ) );
         BITMAP   "FIND" ;
         OF       oDlg

      REDEFINE COMBOBOX oCbxOrd ;
         VAR      cCbxOrd ;
         ID       102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( ( dbfCategoria )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:refresh(), oGet1:SetFocus() ) ;
         OF       oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfCategoria
      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "Browse.Categoria"

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "Codigo"
         :bStrData         := {|| ( dbfCategoria )->cCodigo }
         :bBmpData         := {|| nBitmapTipoCategoria( ( dbfCategoria )->cTipo ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
         aEval( aResTipo, {|cRes| :AddResource( cRes ) } )
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "Nombre"
         :bEditValue       := {|| ( dbfCategoria )->cNombre }
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
         ACTION   ( WinAppRec( oBrw, bEdit, dbfCategoria ) )

      REDEFINE BUTTON ;
         ID       501 ;
         OF       oDlg ;
         WHEN     ( nAnd( nLevelUsr, ACC_EDIT ) != 0 .and. !IsReport() ) ;
         ACTION   ( WinEdtRec( oBrw, bEdit, dbfCategoria ) )

   if nAnd( nLevelUsr, ACC_APPD ) != 0
      oDlg:AddFastKey( VK_F2, {|| WinAppRec( oBrw, bEdit, dbfCategoria ) } )
   end if

   if nAnd( nLevelUsr, ACC_EDIT ) != 0
      oDlg:AddFastKey( VK_F3, {|| WinEdtRec( oBrw, bEdit, dbfCategoria ) } )
   end if

   oDlg:AddFastKey( VK_F5,    {|| oDlg:end( IDOK ) } )
   oDlg:AddFastKey( VK_RETURN,{|| oDlg:end( IDOK ) } )

   oDlg:bStart    := {|| oBrw:Load() }

   ACTIVATE DIALOG oDlg CENTER

   DestroyFastFilter( dbfCategoria )

   SetBrwOpt( "BrwCategoria", ( dbfCategoria )->( OrdNumber() ) )

   if oDlg:nResult == IDOK

      uVar        := ( dbfCategoria )->cCodigo

      if !Empty( oGet )
         oGet:cText( ( dbfCategoria )->cCodigo )
      end if

      if !Empty( oGet2 )
         oGet2:cText( ( dbfCategoria )->cNombre )
      end if

      if oBmpCategoria != nil .and. !Empty( ( dbfCategoria )->cTipo )
         oBmpCategoria:ReLoad( aResTipo[ aScan( aStrTipo, AllTrim( ( dbfCategoria )->cTipo ) ) ] )
      end if

   end if

   CloseFiles()

   if !Empty( oGet )
      oGet:setFocus()
   end if

Return ( uVar )

//---------------------------------------------------------------------------//

Function BrwInternalCategoria( oGet, dbfArticulo, oGet2 )

   local oDlg
   local oBrw
   local oGet1
   local cGet1
   local nRec
   local nOrd           := GetBrwOpt( "BrwCategoria" )
   local oCbxOrd
   local aCbxOrd        := { "Código", "Nombre" }
   local cCbxOrd
   local oBtnEdit
   local oBtnAppend
   local nLevelUsr

   nOrd                 := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd              := aCbxOrd[ nOrd ]

   nRec                 := ( dbfCategoria )->( Recno() )
   nOrd                 := ( dbfCategoria )->( OrdSetFocus( nOrd ) )

   ( dbfCategoria )->( dbGoTop() )

   nLevelUsr            := nLevelUsr( MENUITEM )

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE getConfigTraslation( "Categorías" )

      REDEFINE GET oGet1 VAR cGet1;
         ID       104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfCategoria ) ) ;
         VALID    ( OrdClearScope( oBrw, dbfCategoria ) );
         BITMAP   "FIND" ;
         OF       oDlg

      REDEFINE COMBOBOX oCbxOrd ;
         VAR      cCbxOrd ;
         ID       102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( ( dbfCategoria )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:refresh(), oGet1:SetFocus() ) ;
         OF       oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfCategoria

      oBrw:nMarqueeStyle   := 5

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }

      oBrw:CreateFromResource( 105 )

      with object ( oBrw:AddCol() )
         :cHeader             := "Código"
         :cSortOrder          := "Codigo"
         :bEditValue          := {|| ( dbfCategoria )->cCodigo }
         :nWidth              := 60
         :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Nombre"
         :cSortOrder          := "Nombre"
         :bEditValue          := {|| ( dbfCategoria )->cNombre }
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

   DestroyFastFilter( dbfCategoria )

   SetBrwOpt( "BrwCategoria", ( dbfCategoria )->( OrdNumber() ) )

   if oDlg:nResult == IDOK
      oGet:cText( ( dbfCategoria )->cCodigo )

      if oGet2 != nil
         oGet2:cText( ( dbfCategoria )->cNombre )
      end if
   end if

   ( dbfCategoria )->( dbGoTo( nRec ) )
   ( dbfCategoria )->( OrdSetFocus( nOrd ) )

   oGet:SetFocus()

Return ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//


Function aBmpTipoCategoria()

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

Function aStrTipoCategoria()

Return( aStrTipo )

//---------------------------------------------------------------------------//

Function AddResourceTipoCategoria( oCol )

   local cResTipo

   if !Empty( oCol )
      for each cResTipo in aResTipo
         oCol:AddResource( cResTipo )
      next
   end if

Return ( oCol )

//---------------------------------------------------------------------------//