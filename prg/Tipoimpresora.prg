#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

static oWndBrw
static bEdit      := { |aTmp, aGet, dbfTImp, oBrw, bWhen, bValid, nMode | EdtRec( aTmp, aGet, dbfTImp, oBrw, bWhen, bValid, nMode ) }
static dbfTImp

//----------------------------------------------------------------------------//
//Funciones del programa
//----------------------------------------------------------------------------//

STATIC FUNCTION OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      DisableAcceso()

      if !lExistTable( cPatDat() + "TIPIMP.DBF" )
         mkTipImp( cPatDat() )
      end if

      USE ( cPatDat() + "TIPIMP.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIPIMP", @dbfTImp ) )
      SET ADSINDEX TO ( cPatDat() + "TIPIMP.CDX" ) ADDITIVE

      EnableAcceso()

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )

      EnableAcceso()

      CloseFiles ()

      lOpen       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//
/*
Cierra las bases de datos abiertas
*/

STATIC FUNCTION CloseFiles()

   DisableAcceso()

   if dbfTImp != nil
      ( dbfTImp ) -> ( dbCloseArea() )
   end if

   dbfTImp  := nil
   oWndBrw  := nil

   EnableAcceso()

RETURN .T.

//----------------------------------------------------------------------------//

/*
Monto el Browse principal
*/

FUNCTION TipoImpresoras( oMenuItem, oWnd )

   local nLevel

   DEFAULT  oMenuItem   := "01115"
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

      /*
      Apertura de ficheros
      */

      if !OpenFiles()
         return Nil
      end if

      DisableAcceso()

      /*
      Anotamos el movimiento para el navegador
      */

      AddMnuNext( "Tipos de impresoras", ProcName() )

      DEFINE SHELL oWndBrw FROM 2, 10 TO 18, 70 ;
         XBROWSE ;
         TITLE    "Tipos de impresoras" ;
         PROMPT   "Tipos de impresoras" ;
         MRU      "printer_view_16";
         BITMAP   clrTopArchivos ;
         ALIAS    ( dbfTImp ) ;
         APPEND   ( WinAppRec( oWndBrw:oBrw, bEdit, dbfTImp ) ) ;
         DELETE   ( WinDelRec( oWndBrw:oBrw, dbfTImp ) );
         LEVEL    nLevel ;
         OF       oWnd

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Tipo de impresora"
         :cSortOrder       := "cTipImp"
         :bEditValue       := {|| ( dbfTImp )->cTipImp }
         :nWidth           := 800
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

      DEFINE BTNSHELL RESOURCE "ZOOM" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( WinZooRec( oWndBrw:oBrw, bEdit, dbfTImp ) );
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

      DEFINE BTNSHELL RESOURCE "END" GROUP OF oWndBrw ;
         NOBORDER ;
         ACTION   ( oWndBrw:end() ) ;
         TOOLTIP  "(S)alir" ;
         HOTKEY   "S"

      ACTIVATE WINDOW oWndBrw VALID ( CloseFiles() )

      EnableAcceso()

   else

      oWndBrw:SetFocus()

   end if

RETURN NIL

//----------------------------------------------------------------------------//
/*
Monta el diálogo para añadir, editar,... registros
*/

STATIC FUNCTION EdtRec( aTmp, aGet, dbfTImp, oBrw, bWhen, bValid, nMode )

   local oDlg

   DEFINE DIALOG oDlg RESOURCE "TIPO_IMPRESORA" TITLE LblTitle( nMode ) + "tipos de impresoras"

   REDEFINE GET aGet[ ( dbfTImp )->( FieldPos( "cTipImp" ) ) ] ;
      VAR      aTmp[ ( dbfTImp )->( FieldPos( "cTipImp" ) ) ] ;
      ID       100 ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      OF       oDlg

   REDEFINE BUTTON ;
      ID       IDOK ;
      OF       oDlg ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      ACTION   ( EndTrans( aTmp, aGet, dbfTImp, oBrw, nMode, oDlg ) )

   REDEFINE BUTTON ;
      ID       IDCANCEL ;
      OF       oDlg ;
      CANCEL ;
      ACTION   ( oDlg:end() )

   // Teclas rápidas-----------------------------------------------------------

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| EndTrans( aTmp, aGet, dbfTImp, oBrw, nMode, oDlg ) } )
   end if

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//
/*
Funcion que termina la edición del registro de la base de datos
*/

STATIC FUNCTION EndTrans( aTmp, aGet, dbfSitua, oBrw, nMode, oDlg )

   //Comprobamos que el código no esté vacío y que no exista

   if nMode == APPD_MODE .or. nMode == DUPL_MODE
      if Existe( Upper( aTmp[ ( dbfTImp )->( FieldPos( "cTipImp" ) ) ] ), dbfTImp, "cTipImp" )
         msgStop( "Tipo de impresora existente" )
         aGet[ ( dbfTImp )->( FieldPos( "cTipImp" ) ) ]:SetFocus()
         return nil
      end if
   end if

   if Empty( aTmp[ ( dbfTImp )->( FieldPos( "cTipImp" ) ) ] )
      MsgStop( "El tipo de impresora no puede estar vacío" )
      aGet[ ( dbfTImp )->( FieldPos( "cTipImp" ) ) ]:SetFocus()
      return nil
   end if

   //Escribimos definitivamente la temporal a la base de datos

   WinGather( aTmp, aGet, dbfTImp, oBrw, nMode )

RETURN ( oDlg:end( IDOK ) )

//---------------------------------------------------------------------------//
/*
Función que crea las bases de datos necesarias
*/

FUNCTION mkTipImp( cPath, lAppend, cPathOld, oMeter )

   local dbfTImp

   DEFAULT cPath     := cPatDat()
   DEFAULT lAppend   := .f.

   if !lExistTable( cPath + "TipImp.Dbf" )
      dbCreate( cPath + "TipImp.Dbf", { { "cTipImp", "C", 50, 0 } }, cDriver() )
   end if

   if lExistIndex( cPath + "TipImp.Cdx" )
      fErase( cPath + "TipImp.Cdx" )
   end if

   if lAppend .and. file( cPathOld + "TipImp.Dbf" )
      dbUseArea( .t., cDriver(), "TipImp.Dbf", cCheckArea( "TipImp", @dbfTImp ), .f. )
      ( dbfTImp )->( __dbApp( cPathOld + "TipImp.Dbf" ) )
      ( dbfTImp )->( dbCloseArea() )
   end if

   rxTipImp( cPath )

RETURN .t.

//----------------------------------------------------------------------------//

/*
Funcion que crea los índices de las bases de datos
*/

FUNCTION rxTipImp( cPath, oMeter )

   local dbfTImp

   DEFAULT cPath := cPatDat()

   IF !lExistTable( cPath + "TipImp.DBF" )
      dbCreate( cPath + "TipImp.Dbf", { { "cTipImp", "C", 50, 0 } }, cDriver() )
   END IF

   IF lExistIndex( cPath + "TIPIMP.CDX" )
      fErase( cPath + "TIPIMP.CDX" )
   END IF

   if lExistTable( cPath + "TIPIMP.DBF" )

      dbUseArea( .t., cDriver(), cPath + "TIPIMP.DBF", cCheckArea( "TIPIMP", @dbfTImp ), .f. )

      if !( dbfTImp )->( neterr() )
         ( dbfTImp )->( __dbPack() )

         ( dbfTImp )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
         ( dbfTImp )->( ordCreate( cPath + "TIPIMP.CDX", "cTipImp", "Upper( Field->cTipImp )", {|| Upper( Field->cTipImp ) } ) )

         ( dbfTImp )->( dbCloseArea() )
      else

         msgStop( "Imposible abrir en modo exclusivo tipos de impresoras" )

      end if

   end if

RETURN NIL

//----------------------------------------------------------------------------//

FUNCTION IsTipImp()

   local oError
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      if !lExistTable( cPatDat() + "TipImp.Dbf" )
         mkTipImp( cPatDat() )
      end if

      if !lExistIndex( cPatDat() + "TipImp.Cdx" )
         rxTipImp( cPatDat() )
      end if

   RECOVER USING oError

      ( dbfTImp )->( dbCloseArea() )

      msgStop( ErrorMessage( oError ), "Imposible realizar las comprobación inicial de tipos de impresoras" )

   END SEQUENCE

   ErrorBlock( oBlock )

   ( dbfTImp )->( dbCloseArea() )

 RETURN ( .t. )

//---------------------------------------------------------------------------//

FUNCTION cTipoImpresora( oGet, dbfTImp )

   local oBlock
   local oError
   local lClose      := .f.
   local lValid      := .f.
	local xValor 	   := oGet:varGet()

   if Empty( xValor )
      return .t.
   end if

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( dbfTImp )
         USE ( cPatDat() + "TIPIMP.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIPIMP", @dbfTImp ) )
         SET ADSINDEX TO ( cPatDat() + "TIPIMP.CDX" ) ADDITIVE
         lClose      := .t.
      end if

      if ( dbfTImp )->( dbSeek( Padr( Upper( xValor ), 50 ) ) )

         oGet:cText( ( dbfTImp )->cTipImp )

         lValid      := .t.

      else

         msgStop( "Código de tipo de impresora no encontrado" )

      end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

	IF lClose
      CLOSE( dbfTImp )
	END IF

RETURN lValid

//---------------------------------------------------------------------------//

FUNCTION BrwTipoImpresora( oGet, lBigStyle )

	local oDlg
	local oGet1
	local cGet1
	local oBrw
   local nOrd        := GetBrwOpt( "BrwTipImpresora" )
	local oCbxOrd
   local aCbxOrd     := { "Tipo" }
   local cCbxOrd
   local nLevel      := nLevelUsr( "01115" )
   local cResource   := "HELPENTRYTACTILIMP"

   DEFAULT lBigStyle := .f.

   if !OpenFiles()
      return .f.
   end if

   if lBigStyle
      nOrd           := ( dbfTImp )->( OrdSetFocus( "cTipImp" ) )
      ( dbfTImp )->( dbGoTop() )
   else
      nOrd           := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
      cCbxOrd        := aCbxOrd[ nOrd ]
   end if

   if lBigStyle

      if GetSysMetrics( 1 ) == 560

         DEFINE DIALOG oDlg RESOURCE "HELPENTRYTACTILIMP_1024x576"   TITLE "Seleccionar tipo de impresora"

      else

         DEFINE DIALOG oDlg RESOURCE cResource TITLE "Seleccionar tipo de impresora"

      end if

   else

      DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Seleccionar tipo de impresora"

   end if

   if !lBigStyle

      REDEFINE GET oGet1 VAR cGet1;
			ID 		104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfTImp ) );
         VALID    ( OrdClearScope( oBrw, dbfTImp ) );
         BITMAP   "FIND" ;
         OF       oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( ( dbfTImp )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:Refresh(), oGet1:SetFocus() ) ;
			OF 		oDlg

   end if

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfTImp
      oBrw:lHScroll        := .f.
      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "Browse.TipoImpresora"

      if lBigStyle
         oBrw:nRowHeight   := 36
      end if

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cTipImp"
         :bEditValue       := {|| ( dbfTImp )->cTipImp }
         :nWidth           := 400
         if !lBigStyle
            :bLClickHeader := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
         end if
      end with

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }
      oBrw:bRClicked       := {| nRow, nCol, nFlags | oBrw:RButtonDown( nRow, nCol, nFlags ) }

      oBrw:CreateFromResource( 105 )

      if lBigStyle

      REDEFINE BUTTONBMP ;
         ID       140 ;
         OF       oDlg ;
         BITMAP   "UP32" ;
         ACTION   ( oBrw:GoUp() )

      REDEFINE BUTTONBMP ;
         ID       150 ;
         OF       oDlg ;
         BITMAP   "DOWN32" ;
         ACTION   ( oBrw:GoDown() )

      REDEFINE BUTTONBMP ;
         BITMAP   "Check_32" ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( oDlg:end(IDOK) )

      REDEFINE BUTTONBMP ;
         BITMAP   "Delete_32" ;
         ID       IDCANCEL ;
         OF       oDlg ;
         ACTION   ( oDlg:End() )

      else

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      end if   

      if !lBigStyle

      REDEFINE BUTTON ;
         ID       500 ;
         OF       oDlg ;
         WHEN     ( nAnd( nLevel, ACC_APPD ) != 0 .and. !IsReport() ) ;
         ACTION   ( WinAppRec( oBrw, bEdit, dbfTImp ) );

		REDEFINE BUTTON ;
         ID       501 ;
         OF       oDlg ;
         WHEN     ( nAnd( nLevel, ACC_EDIT ) != 0 .and. !IsReport() ) ;
         ACTION   ( WinEdtRec( oBrw, bEdit, dbfTImp ) )

      if nAnd( nLevel, ACC_APPD ) != 0 .and. !IsReport()
         oDlg:AddFastKey( VK_F2,    {|| WinAppRec( oBrw, bEdit, dbfTImp ) } )
      end if

      if nAnd( nLevel, ACC_EDIT ) != 0 .and. !IsReport()
         oDlg:AddFastKey( VK_F3,    {|| WinEdtRec( oBrw, bEdit, dbfTImp ) } )
      end if

      end if

      oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )
      oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK

      oGet:cText( ( dbfTImp )->cTipImp )
		oGet:lValid()

   end if

   oGet:SetFocus()

   DestroyFastFilter( dbfTImp )

   SetBrwOpt( "BrwTipImpresora", ( dbfTImp )->( OrdNumber() ) )

   CloseFiles()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//
/*
Funcion que llena un array con los valoras de la base de datos
*/

Function aTiposImpresoras( dbfTImp )

   local oError
   local oBlock
   local aTipImp  := {}

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      /*
      Recorremos la base de datos metiendo todos los valores en una array que es la que vamos a devolver
      */

      aAdd( aTipImp, "No imprimir" )

      ( dbfTImp )->( dbGoTop() )
      while !( dbfTImp )->( Eof() )
         aAdd( aTipImp, AllTrim( ( dbfTImp )->cTipImp ) )
         ( dbfTImp )->( dbSkip() )
      end while

   RECOVER USING oError

      msgStop( "Imposible cargar situaciones" + CRLF + ErrorMessage( oError )  )

   END SEQUENCE

   ErrorBlock( oBlock )

Return aTipImp

//---------------------------------------------------------------------------//