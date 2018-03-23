#include "FiveWin.Ch"
#include "Font.ch"
#include "Report.ch"
#include "Factu.ch" 

#define _CGRPCONTA               1     //   C      9     0
#define _CGRPNOM                 2     //   C     25     0

static oWndBrw
static dbfGrpVenta

static bEdit := { |aTemp, aoGet, dbfGrpVenta, oBrw, bWhen, bValid, nMode | EdtRec( aTemp, aoGet, dbfGrpVenta, oBrw, bWhen, bValid, nMode ) }

static aBase := { {  "CGRPCONTA",   "C",   9,    0, "Grupo de contabilidad" },;
                  {  "CGRPNOM",     "C",  25,    0, "Nombre del grupo" }      }

//----------------------------------------------------------------------------//

Static Function OpenFiles()

   local lOpen    := .t.
   local oError
   local oBlock

   if !lExistTable( cPatEmp() + "GRPVENT.DBF" )
      mkGrpVenta( cPatEmp() )
   end if

   if !lExistIndex( cPatEmp() + "GRPVENT.CDX" )
      rxGrpVenta( cPatEmp() )
   end if

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatEmp() + "GRPVENT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "GRPVENT", @dbfGrpVenta ) )
   SET ADSINDEX TO ( cPatEmp() + "GRPVENT.CDX" ) ADDITIVE

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos de grupos de ventas" )

      CloseFiles()

      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lOpen )

//----------------------------------------------------------------------------//

Static Function CloseFiles( oWndBrw )

   CLOSE ( dbfGrpVenta )

   oWndBrw           := nil

Return .t.

//----------------------------------------------------------------------------//

Function GrpVenta( oMenuItem, oWnd )

   local nLevel

   DEFAULT  oMenuItem   := "01018"
   DEFAULT  oWnd        := oWnd()

   if Empty( nLenCuentaContaplus() )
      msgStop( "No está definido el enlace con Contaplus ®" )
      return nil
   end if

   if oWndBrw == NIL

      /*
      Obtenemos el nivel de acceso
      */

      nLevel            := Auth():Level( oMenuItem )
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

      AddMnuNext( "Grupos de ventas de contabilidad", ProcName() )

   DEFINE SHELL oWndBrw FROM 2, 10 TO 18, 70;
      XBROWSE ;
      TITLE    "Grupos de ventas de contabilidad" ;
      PROMPT   "Código",;
					"Nombre";
      MRU      "gc_magazine_folder_16";
		ALIAS		( dbfGrpVenta ) ;
      APPEND   ( WinAppRec( oWndBrw:oBrw, bEdit, dbfGrpVenta ) );
      DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdit, dbfGrpVenta ) );
		EDIT 		( WinEdtRec( oWndBrw:oBrw, bEdit, dbfGrpVenta ) ) ;
      DELETE   ( WinDelRec( oWndBrw:oBrw, dbfGrpVenta ) ) ;
      LEVEL    nLevel ;
		OF 		oWnd

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cGrpConta"
         :bEditValue       := {|| ( dbfGrpVenta )->cGrpConta }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cGrpNom"
         :bEditValue       := {|| ( dbfGrpVenta )->cGrpNom }
         :nWidth           := 200
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      oWndBrw:cHtmlHelp    := "Grupos de ventas de contabilidad"

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
			TOOLTIP 	"(M)odificar";
         HOTKEY   "M";
         LEVEL    ACC_EDIT

		DEFINE BTNSHELL RESOURCE "ZOOM" OF oWndBrw ;
			NOBORDER ;
			ACTION  	( WinZooRec( oWndBrw:oBrw, bEdit, dbfGrpVenta ) );
			TOOLTIP 	"(Z)oom";
         HOTKEY   "Z";
         LEVEL    ACC_ZOOM

		DEFINE BTNSHELL RESOURCE "DEL" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( oWndBrw:RecDel() );
			TOOLTIP 	"(E)liminar";
         HOTKEY   "E";
         LEVEL    ACC_DELE

#ifndef __TACTIL__

      DEFINE BTNSHELL RESOURCE "IMP" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( IGrpVen():New( "Listado de grupos de ventas" ):Play() ) ;
         TOOLTIP  "(L)istado" ;
         HOTKEY   "L";
         LEVEL    ACC_IMPR

#endif

      DEFINE BTNSHELL RESOURCE "END" GROUP OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:End() ) ;
         TOOLTIP  "(S)alir" ;
			HOTKEY 	"S"

		ACTIVATE WINDOW oWndBrw ;
         VALID    ( CloseFiles( oWndBrw ) )

   else

		oWndBrw:SetFocus()

   end if

Return Nil

//----------------------------------------------------------------------------//

Static Function EdtRec( aTemp, aoGet, dbfGrpVenta, oBrw, bWhen, bValid, nMode )

	local oDlg
   local nLen  := nLenCuentaContaplus()

   if nLen == 0
      msgStop( "No está definido el enlace con Contaplus ®" )
      return .t.
   end if

	DEFINE DIALOG oDlg RESOURCE "GRPVENTA"

		REDEFINE GET aoGet[_CGRPCONTA] VAR aTemp[_CGRPCONTA];
			ID 		100 ;
         WHEN     ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) ;
         VALID    ( ChkValid( aoGet[_CGRPCONTA], dbfGrpVenta, .t., "0", nLen ) ) ;
         PICTURE  ( Replicate( "9", nLen ) )  ;
			COLOR 	CLR_GET ;
			OF 		oDlg

      REDEFINE GET aoGet[_CGRPNOM] VAR aTemp[_CGRPNOM] ;
			ID 		101 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			PICTURE 	"@!" ;
			COLOR 	CLR_GET ;
			OF 		oDlg

      REDEFINE BUTTON;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( lPreSave( aTemp, aoGet, dbfGrpVenta, oBrw, nMode, oDlg ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
			ACTION 	( oDlg:end() )

   REDEFINE BUTTON ;
         ID       9 ;
			OF 		oDlg ;
         ACTION   ( ChmHelp( "Grupos_de_ventas" ) )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| lPreSave( aTemp, aoGet, dbfGrpVenta, oBrw, nMode, oDlg ) } )
   end if

   oDlg:AddFastKey ( VK_F1, {|| ChmHelp( "Grupos_de_ventas" ) } )

   oDlg:bStart := {|| aoGet[_CGRPCONTA]:SetFocus() }

	ACTIVATE DIALOG oDlg	CENTER

Return ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Static Function lPreSave( aTemp, aoGet, dbfGrpVenta, oBrw, nMode, oDlg )

   if nMode == APPD_MODE .or. nMode == DUPL_MODE
      if Empty( aTemp[ _CGRPCONTA ] )
         MsgStop( "Código del grupo no puede estar vacío." )
         aoGet[_CGRPCONTA]:SetFocus()
         Return .f.
      end if
      if ( dbfGrpVenta )->( dbSeek( aTemp[ _CGRPCONTA ] ) )
         MsgStop( "Código existente" )
         aoGet[_CGRPCONTA]:SetFocus()
         Return .f.
      end if
   end if

   if Empty( aTemp[ _CGRPNOM ] )
      MsgStop( "Nombre del grupo no puede estar vacío." )
      aoGet[_CGRPNOM]:SetFocus()
      Return .f.
   end if

   WinGather( aTemp, aoGet, dbfGrpVenta, oBrw, nMode )

RETURN ( oDlg:end( IDOK ) )

//--------------------------------------------------------------------------//

/*
Devuelve el grupo de venta
*/

FUNCTION cGrpVenta( oGet, dbfGrp, oGet2 )

   local oBlock
   local oError
   local lValid      := .f.
   local lClose      := .f.
   local xValor      := oGet:varGet()

   if Empty( xValor )

      if !Empty( oGet2 )
         oGet2:cText( "" )
      end if

      Return .t.

   end if

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if Empty( dbfGrp )
      USE ( cPatEmp() + "GrpVent.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "GRPVENT", @dbfGrp ) )
      SET ADSINDEX TO ( cPatEmp() + "GrpVent.Cdx" ) ADDITIVE
      lClose         := .t.
   end if

   if Len( Alltrim( xValor ) ) > nLenCuentaContaplus()
      xValor         := Left( xValor, nLenCuentaContaplus() )
   else
      xValor         := Rjust( xValor, "0", nLenCuentaContaplus() )
   end if

   if ( dbfGrp )->( dbSeek( xValor ) )

      oGet:cText( ( dbfGrp )->cGrpConta )

      if !Empty( oGet2 )
         oGet2:cText( ( dbfGrp )->cGrpNom )
      end if

      lValid         := .t.

   else

		msgStop( "Grupo de venta no encontrado" )

   end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if ( lClose )
      ( dbfGrp )->( dbCloseArea() )
   end if

RETURN lValid

//---------------------------------------------------------------------------//

FUNCTION BrwGrpVenta( oGet, dbfGrp, oGet2 )

   local oBlock
   local oError
	local oDlg
	local oBrw
	local oGet1
	local cGet1
   local nOrd     := GetBrwOpt( "BrwGrpVenta" )
	local nOrdAnt
	local oCbxOrd
   local aCbxOrd  := { "Código", "Nombre" }
   local cCbxOrd
   local nLevel   := Auth():Level( "01018" )
   local lClose   := .f.

   nOrd           := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd        := aCbxOrd[ nOrd ]

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if Empty( dbfGrp )
      USE ( cPatEmp() + "GRPVENT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "GRPVENT", @dbfGrp ) )
      SET ADSINDEX TO ( cPatEmp() + "GRPVENT.CDX" ) ADDITIVE
      lClose      := .t.
   end if

   nOrdAnt        := ( dbfGrp )->( OrdSetFocus( nOrd ) )

   ( dbfGrp )->( dbGoTop() )

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Grupos de ventas"

		REDEFINE GET oGet1 VAR cGet1;
         ID       104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfGrp ) );
         VALID    ( OrdClearScope( oBrw, dbfGrp ) );
         BITMAP   "FIND" ;
         OF       oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( ( dbfGrp )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:refresh(), oGet1:SetFocus() ) ;
			OF 		oDlg

      /*
		REDEFINE LISTBOX oBrw ;
         FIELDS   ( dbfGrp )->cGrpConta,;
                  ( dbfGrp )->cGrpNom;
         HEAD     "Código",;
                  "Nombre";
         ALIAS    ( dbfGrp ) ;
         ID       105 ;
         OF       oDlg
      */

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfGrp
      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "Browse.Grupos de venta"

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cGrpConta"
         :bEditValue       := {|| ( dbfGrp )->cGrpConta }
         :nWidth           := 60
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cGrpNom"
         :bEditValue       := {|| ( dbfGrp )->cGrpNom }
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
            WHEN     ( nAnd( nLevel, ACC_APPD ) != 0 );
            ACTION   ( WinAppRec( oBrw, bEdit, dbfGrp ) )

		REDEFINE BUTTON ;
            ID       501 ;
            OF       oDlg ;
            WHEN     ( nAnd( nLevel, ACC_EDIT ) != 0 );
            ACTION   ( WinEdtRec( oBrw, bEdit, dbfGrp ) )

      oDlg:AddFastKey( VK_F2,       {|| if( nAnd( nLevel, ACC_APPD ) != 0, WinAppRec( oBrw, bEdit, dbfGrp ), ) } )
      oDlg:AddFastKey( VK_F3,       {|| if( nAnd( nLevel, ACC_EDIT ) != 0, WinEdtRec( oBrw, bEdit, dbfGrp ), ) } )
      oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )
      oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )

      oDlg:bStart    := {|| oBrw:Load() }

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK

      oGet:cText( ( dbfGrp )->cGrpConta )
		oGet:lValid()

      if oGet2 != nil
         oGet2:cText( ( dbfGrp )->cGrpNom )
      end if

   end if

   DestroyFastFilter( dbfGrp )

   SetBrwOpt( "BrwGrpVenta", ( dbfGrp )->( OrdNumber() ) )

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if lClose
      ( dbfGrp )->( dbCloseArea() )
   else
      ( dbfGrp )->( OrdSetFocus( nOrdAnt ) )
   end if

   oGet:SetFocus()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

STATIC FUNCTION ChkValid( oGet, dbfGrpVenta, lRjust, cChar, nLen )

	local xClave
	local nOldTag
   local lReturn        := .t.

   DEFAULT nLen         := nLenCuentaContaplus()
   DEFAULT lRjust       := .t.
	DEFAULT cChar			:= "0"
   DEFAULT dbfGrpVenta  := Alias()

   if Empty( ( dbfGrpVenta )->( OrdSetFocus() ) )
      msgStop( "Indice no disponible" + CRLF + "Comprobación imposible", "Aviso del sistema")
      Return .t.
   end if

	/*
	Cambiamos el tag y guardamos el anterior
	*/

   nOldTag              := ( dbfGrpVenta )->( OrdSetFocus( 1 ) )

	RJustObj( oGet, cChar, nLen )

   xClave               := oGet:VarGet()

   if Existe( xClave, dbfGrpVenta )
      MsgStop( "Clave " + xClave + " existente" )
      lReturn           := .f.
   end if

   ( dbfGrpVenta )->( OrdSetFocus( nOldTag ) )

RETURN lReturn

//-------------------------------------------------------------------------//

FUNCTION mkGrpVenta( cPath, lAppend, cPathOld )

	local dbfGrpVenta

	DEFAULT lAppend := .f.

   if !lExistTable( cPath + "GrpVent.Dbf" )
      dbCreate( cPath + "GrpVent.Dbf", aSqlStruct( aItmGrpVta() ), cDriver() )
   end if

   if lAppend .and. lIsDir( cPathOld )
      dbUseArea( .t., cDriver(), cPath + "GrpVent.Dbf", cCheckArea( "GRPVENT", @dbfGrpVenta ), .f. )
      if !( dbfGrpVenta )->( neterr() )
         ( dbfGrpVenta )->( __dbApp( cPathOld + "GrpVent.Dbf" ) )
         ( dbfGrpVenta )->( dbCloseArea() )
      end if
   end if

   if !lExistIndex( cPath + "GrpVent.Cdx" )
      rxGrpVenta( cPath )
   end if

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION rxGrpVenta( cPath, oMeter )

	local dbfGrpVenta

   DEFAULT cPath  := cPatEmp()

   if !lExistTable( cPath + "GRPVENT.DBF" )
		mkGrpVenta( cPath )
   end if

   fEraseIndex( cPath + "GRPVENT.CDX" )

   dbUseArea( .t., cDriver(), cPath + "GRPVENT.DBF", cCheckArea( "GRPVENT", @dbfGrpVenta ), .f. )
   if !( dbfGrpVenta )->( neterr() )
      ( dbfGrpVenta )->( __dbPack() )

      ( dbfGrpVenta )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfGrpVenta )->( ordCreate( cPath + "GRPVENT.CDX", "CGRPCONTA", "Field->CGRPCONTA", {|| Field->CGRPCONTA }, ) )

      ( dbfGrpVenta )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfGrpVenta )->( ordCreate( cPath + "GRPVENT.CDX", "CGRPNOM", "Field->CGRPNOM", {|| Field->CGRPNOM } ) )

      ( dbfGrpVenta )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de grupo de ventas" )
   end if

RETURN NIL

//---------------------------------------------------------------------------//

Function aItmGrpVta()

   local aBase    := {  {"CGRPCONTA",   "C",   9,    0, "Grupo de contabilidad" },;
                        {"CGRPNOM",     "C",  25,    0, "Nombre del grupo" } }

Return ( aBase )

//---------------------------------------------------------------------------//