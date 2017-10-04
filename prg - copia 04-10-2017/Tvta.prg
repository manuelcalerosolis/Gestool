#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "Report.ch"

#define _CCODMOV                  1      //   C      2     0
#define _CDESMOV                  2      //   C     20     0
#define _NUNDMOV                  3      //   N      1     0
#define _NIMPMOV                  4      //   N      1     0

static oWndBrw
static dbfTVta
static bEdit   := { |aTemp, aoGet, dbfTVta, oBrw, bWhen, bValid, nMode | EdtRec( aTemp, aoGet, dbfTVta, oBrw, bWhen, bValid, nMode ) }
static aTipVta := {  { "00", "Ventas",             1, 1 },;
                     { "01", "Ventas especiales",  1, 1 },;
                     { "02", "Devoluciones",       1, 1 },;
                     { "03", "Canjeos",            1, 1 } }

//----------------------------------------------------------------------------//

function aItmTVta()

   local aItmTVta := {}

   aAdd( aItmTVta, { "CCODMOV",  "C",  2,  0, "Tipo de movimiento" ,                   "",  "", "( cDbf )" } )
   aAdd( aItmTVta, { "CDESMOV",  "C", 20,  0, "Descripción del tipo de movimiento" ,   "",  "", "( cDbf )" } )
   aAdd( aItmTVta, { "NUNDMOV",  "N",  1,  0, "Comportamiento en unidades" ,           "",  "", "( cDbf )" } )
   aAdd( aItmTVta, { "NIMPMOV",  "N",  1,  0, "Comportamiento en precio" ,             "",  "", "( cDbf )" } )

return ( aItmTVta )

//----------------------------------------------------------------------------//

FUNCTION TVta( oMenuItem, oWnd )

   local nLevel

   DEFAULT  oMenuItem   := "01043"
   DEFAULT  oWnd        := oWnd()

	IF oWndBrw == NIL

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

      IF !OpenFiles()
         RETURN NIL
      END IF

      /*
      Anotamos el movimiento para el navegador
      */

      AddMnuNext( "Tipos de venta", ProcName() )

      DEFINE SHELL oWndBrw FROM 2, 10 TO 18, 70;
         XBROWSE ;
         TITLE    "Tipos de venta" ;
         PROMPT   "Código",;
						"Nombre";
         MRU      "gc_wallet_16";
         BITMAP   clrTopArchivos ;
			ALIAS		( dbfTVta ) ;
         APPEND   ( WinAppRec( oWndBrw:oBrw, bEdit, dbfTVta ) );
         DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdit, dbfTVta ) );
			EDIT 		( WinEdtRec( oWndBrw:oBrw, bEdit, dbfTVta ) );
         DELETE   ( WinDelRec( oWndBrw:oBrw, dbfTVta ) );
         LEVEL    nLevel ;
			OF 		oWnd

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodMov"
         :bEditValue       := {|| ( dbfTVta )->cCodMov }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cDesMov"
         :bEditValue       := {|| ( dbfTVta )->cDesMov }
         :nWidth           := 200
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      oWndBrw:cHtmlHelp    := "Movimientos de ventas"

      oWndBrw:CreateXFromCode()

      DEFINE BTNSHELL RESOURCE "BUS" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:SearchSetFocus() ) ;
         TOOLTIP  "(B)uscar" ;
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
         MRU ;
         HOTKEY   "D";
         LEVEL    ACC_APPD

		DEFINE BTNSHELL RESOURCE "EDIT" OF oWndBrw ;
			NOBORDER ;
			ACTION  	( oWndBrw:RecEdit() );
         TOOLTIP  "(M)odificar";
         MRU ;
         HOTKEY   "M";
         LEVEL    ACC_EDIT

		DEFINE BTNSHELL RESOURCE "ZOOM" OF oWndBrw ;
			NOBORDER ;
			ACTION  	( WinZooRec( oWndBrw:oBrw, bEdit, dbfTVta ) );
			TOOLTIP 	"(Z)oom";
         MRU ;
         HOTKEY   "Z";
         LEVEL    ACC_ZOOM

		DEFINE BTNSHELL RESOURCE "DEL" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( oWndBrw:RecDel() );
			TOOLTIP 	"(E)liminar";
         MRU ;
         HOTKEY   "E";
         LEVEL    ACC_DELE

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

STATIC FUNCTION EdtRec( aTemp, aoGet, dbfTVta, oBrw, bWhen, bValid, nMode )

	local oDlg
	local oGet

	DEFINE DIALOG oDlg RESOURCE "TVTA" TITLE LblTitle( nMode ) + "Tipos de Venta"

		REDEFINE GET oGet VAR aTemp[_CCODMOV];
			ID 		110 ;
			PICTURE	"@!";
         WHEN     ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) ;
         VALID    ( NotValid( oGet, dbfTVta, .t., "0" ) ) ;
			COLOR 	CLR_GET ;
			OF 		oDlg

		REDEFINE GET aTemp[_CDESMOV] ;
			ID 		120 ;
			COLOR 	CLR_GET ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

		REDEFINE RADIO aTemp[_NUNDMOV] ;
			ID 		130, 131, 132 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

		REDEFINE RADIO aTemp[_NIMPMOV] ;
			ID 		140, 141, 142 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

		REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( if( nMode == DUPL_MODE, if( oGet:lValid(), lPreSave( aTemp, aoGet, dbfTVta, oBrw, nMode, oDlg ), ),  lPreSave( aTemp, aoGet, dbfTVta, oBrw, nMode, oDlg ) ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
			ACTION 	( oDlg:end() )

      REDEFINE BUTTON ;
         ID       559 ;
			OF 		oDlg ;
         ACTION   ( GoHelp() )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| if( nMode == DUPL_MODE, if(  oGet:lValid(),;
                                                               lPreSave( aTemp, aoGet, dbfTVta, oBrw, nMode, oDlg ), ),;
                                                               lPreSave( aTemp, aoGet, dbfTVta, oBrw, nMode, oDlg ) ) } )
   end if

   oDlg:AddFastKey ( VK_F1, {|| GoHelp() } )

   oDlg:bStart := { || oGet:SetFocus() }

	ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

STATIC FUNCTION lPreSave( aTemp, aoGet, dbfTVta, oBrw, nMode, oDlg )

   if nMode == APPD_MODE .or. nMode == DUPL_MODE

      if dbSeekInOrd( aTemp[ _CDESMOV ], "CCODMOV", dbfTVta )
         MsgStop( "Código ya existe " + Rtrim( aTemp[ _CDESMOV ] ) )
         return nil
      end if

   end if

   if Empty( aTemp[ _CDESMOV ] )
      MsgStop( "La descripción del tipo de venta no puede estar vacía." )
      Return .f.
   end if

   WinGather( aTemp, aoGet, dbfTVta, oBrw, nMode )

Return oDlg:end( IDOK )

//---------------------------------------------------------------------------//

STATIC FUNCTION GenReport( dbfTVta )

	local oReport
	local oFont1
	local oFont2
	local nRecno 		:= ( dbfTVta )->( RecNo() )
   local cTitulo     := Padr( cCodEmp() + " - " + cNbrEmp(), 50 )
   local cSubTitulo  := Padr( "Listado de tipos de ventas", 50 )
	local nDevice		:= 1

	/*
	Llamada a la funcion que activa la caja de dialogo
	*/

	IF SetRep( @cTitulo, @cSubTitulo, @nDevice )

		(dbfTVta)->(DbGoTop())

		/*
		Tipos de Letras
		*/

      DEFINE FONT oFont1 NAME "Courier New" SIZE 0,-10 BOLD
      DEFINE FONT oFont2 NAME "Courier New" SIZE 0,-10

		IF nDevice == 1

			REPORT oReport ;
				TITLE  	Rtrim( cTitulo ),;
							Rtrim( cSubTitulo ) ;
				FONT   	oFont1, oFont2 ;
				HEADER 	"Fecha: " + dtoc(date()) RIGHT ;
            FOOTER   "Página : " + str( oReport:nPage, 3 ) CENTERED;
				CAPTION 	"Listando Tipos de Ventas";
				PREVIEW

		ELSE

			REPORT oReport ;
				TITLE  	Rtrim( cTitulo ),;
							Rtrim( cSubTitulo ) ;
				FONT   	oFont1, oFont2 ;
				HEADER 	"Fecha: " + dtoc(date()) RIGHT ;
            FOOTER   "Página : "  + str(oReport:nPage,3) CENTERED;
				CAPTION 	"Listando Tipos de Ventas";
            TO PRINTER

		END IF

			COLUMN TITLE "Tipo" ;
				DATA (dbfTVta)->CCODMOV ;
				FONT 2

         COLUMN TITLE "Descripción" ;
				DATA (dbfTVta)->CDESMOV ;
				FONT 2

		END REPORT

      IF !Empty( oReport ) .and.  oReport:lCreated
			oReport:Margin(0, RPT_RIGHT, RPT_CMETERS)
			oReport:bSkip	:= {|| (dbfTVta)->(DbSkip()) }
		END IF

		ACTIVATE REPORT oReport WHILE !(dbfTVta)->(Eof())

		oFont1:end()
		oFont2:end()

	END IF

	(dbfTVta)->(DbGoto( nRecno ) )

RETURN NIL

//--------------------------------------------------------------------------//


FUNCTION cTVta( oGet, dbfTVta, oGet2 )

   local lValid   := .f.
	local xValor 	:= oGet:varGet()

   if Empty( xValor )
      if( oGet2 != nil, oGet2:cText( "" ), )
      return .t.
   else
      xValor   := RJustObj( oGet, "0" )
   end if

   if ( dbfTVta )->( dbSeek( xValor ) )

      oGet:cText( ( dbfTVta )->cCodMov )

      if oGet2 != nil
         oGet2:cText( ( dbfTVta )->cDesMov )
      end if

      lValid      := .t.

   else

		msgStop( "Tipo de movimiento no encontrado" )

   end if

RETURN lValid

//---------------------------------------------------------------------------//

FUNCTION retTVta( dbfTVta, cCodMov )

   local oError
   local oBlock
   local cTemp    := ""
	local lClose	:= .f.
   local cPath    := cPatDat()

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if !Empty( dbfTVta )
         USE ( cPath + "TVTA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TVta", @dbfTVta ) )
         SET ADSINDEX TO ( cPath + "TVTA.CDX" ) ADDITIVE
         lClose      := .t.
      end if

      if ( dbfTVta )->( dbSeek( cCodMov ) )
         cTemp       := ( dbfTVta )->cDesMov
      end if

      if lClose
         CLOSE ( dbfTVta )
      end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos de movimientos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN cTemp

//---------------------------------------------------------------------------//

FUNCTION BrwTVta( oGet, dbfTVta, oGet2 )

	local oDlg
   local oGet1
   local cGet1
	local oBrw
   local oError
   local oBlock
   local nOrd     := GetBrwOpt( "BrwTVta" )
	local oCbxOrd
   local aCbxOrd  := { "Código", "Nombre" }
   local cCbxOrd
   local lClose   := .f.
   local cPath    := cPatDat()
   local nLevel   := nLevelUsr( "01042" )

   nOrd           := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd        := aCbxOrd[ nOrd ]

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if !Empty( dbfTVta )
      USE ( cPath + "TVTA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TVta", @dbfTVta ) )
      SET ADSINDEX TO ( cPath + "TVTA.CDX" ) ADDITIVE

      lClose      := .t.
   end if

   ( dbfTVta )->( dbGoTop() )

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Tipos de venta"

		REDEFINE GET oGet1 VAR cGet1;
         ID       104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfTVta ) );
         VALID    ( OrdClearScope( oBrw, dbfTVta ) );
         BITMAP   "FIND" ;
         OF       oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( ( dbfTVta )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:Refresh(), oGet1:SetFocus() ) ;
			OF oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfTVta

      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "Browse.Movimientos de ventas"

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodMov"
         :bEditValue       := {|| ( dbfTVta )->cCodMov }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cDesMov"
         :bEditValue       := {|| ( dbfTVta )->cDesMov }
         :nWidth           := 200
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
         WHEN     ( nAnd( nLevel, ACC_APPD ) != 0 .and. !IsReport() ) ;
         ACTION   ( WinAppRec( oBrw, bEdit, dbfTVta ) );

		REDEFINE BUTTON ;
         ID       501 ;
         OF       oDlg ;
         WHEN     ( nAnd( nLevel, ACC_EDIT ) != 0 .and. !IsReport() ) ;
         ACTION   ( WinEdtRec( oBrw, bEdit, dbfTVta ) )


   if nAnd( nLevel, ACC_APPD ) != 0 .and. !IsReport()
      oDlg:AddFastKey( VK_F2,    {|| WinAppRec( oBrw, bEdit, dbfTVta ) } )
   end if

   if nAnd( nLevel, ACC_EDIT ) != 0 .and. !IsReport()
      oDlg:AddFastKey( VK_F3,    {|| WinEdtRec( oBrw, bEdit, dbfTVta ) } )
   end if

   oDlg:AddFastKey( VK_F5,       {|| oDlg:end(IDOK) } )
   oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end(IDOK) } )

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK

      oGet:cText( ( dbfTVta )->cCodMov )
		oGet:lValid()

      if ValType( oGet2 ) == "O"
         oGet2:cText( ( dbfTVta )->cDesMov )
      end if

   end if

   DestroyFastFilter( dbfTVta )

   SetBrwOpt( "BrwTVta", ( dbfTVta )->( OrdNumber() ) )

	oGet:setFocus()

   if lClose
		CLOSE ( dbfTVta )
   end if

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos de tipos de ventas" )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

FUNCTION lTVta( dbfTVta, cCodMov )

   local oError
   local oBlock
   local lReturn  := .f.
   local lClose   := .f.
   local cPath    := cPatDat()

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if !Empty( dbfTVta )
         USE ( cPath + "TVTA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TVta", @dbfTVta ) )
         SET ADSINDEX TO ( cPath + "TVTA.CDX" ) ADDITIVE
         lClose      := .t.
      end if

      if ( dbfTVta )->( dbSeek( cCodMov ) )
         lReturn     := .t.
      else
         MsgStop( "Tipo de movimiento inexistente" )
         lReturn     := .f.
      end if

      if lClose
         CLOSE ( dbfTVta )
      end if

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos de tipos de ventas" )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN lReturn

//----------------------------------------------------------------------------//

STATIC FUNCTION OpenFiles( dbf )

   local cPath       := cPatDat()
   local lOpen       := .t.
   local oError
   local oBlock

   IF !lExistTable( cPath + "TVta.Dbf" )
      mkTVta( cPath )
   END IF

   IF !lExistIndex( cPath + "TVta.Cdx" )
      rxTVta( cPath )
   END IF

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      USE ( cPath + "TVta.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TVTA", @dbfTVta ) )
      SET ADSINDEX TO ( cPath + "TVta.Cdx" ) ADDITIVE

   RECOVER

      CloseFiles()

      lOpen          := .f.

      msgStop( "Imposible abrir todas las bases de datos de tipos de ventas" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles()

   CLOSE( dbfTVta )

   oWndBrw     := nil

RETURN .t.

//---------------------------------------------------------------------------//

FUNCTION mkTVta( cPath, lAppend )

   local nCont
	local dbfTVta

   DEFAULT lAppend   := .f.

   if !lExistTable( cPath + "TVta.Dbf" )

      dbCreate( cPath + "TVta.Dbf", aSqlStruct( aItmTVta() ), cDriver() )

      /*
      A¤adimos registros obligatorios------------------------------------------

      dbUseArea( .t., cDriver(), cPath + "TVta.Dbf", cCheckArea( "TVta", @dbfTVta ), .f. )

      for nCont := 1 to Len( aTipVta )
         dbGather( aTipVta[ nCont ], dbfTVta, .t. )
      next

      ( dbfTVta )->( dbCloseArea() )
      */

   end if

   rxTVta( cPath )   

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION rxTVta( cPath, oMeter )

	local dbfTVta

   DEFAULT cPath  := cPatDat()

   if !lExistTable( cPath + "TVta.Dbf" )
		mkTVta( cPath )
   end if

   if lExistIndex( cPath + "TVta.Cdx" )
      fErase( cPath + "TVta.Cdx" )
   end if

   dbUseArea( .t., cDriver(), cPath + "TVTA.DBF", cCheckArea( "TVta", @dbfTVta ), .f. )
   if !( dbfTVta )->( neterr() )
      ( dbfTVta )->( __dbPack() )

      ( dbfTVta )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfTVta )->( ordCreate( cPath + "TVTA.CDX", "CCODMOV", "Field->CCODMOV", {|| Field->CCODMOV }, ) )

      ( dbfTVta )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfTVta )->( ordCreate( cPath + "TVTA.CDX", "CDESMOV", "Field->CDESMOV", {|| Field->CDESMOV } ) )

      ( dbfTVta )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de tipos de ventas" )
   end if

RETURN NIL

//--------------------------------------------------------------------------//

/*
Devuelve el factor por el que hay que multiplicar las unidades de venta
*/

FUNCTION nVtaUnd( cRef, dbfTVta )

   local nCom  := 1

   IF ( dbfTVta )->( dbSeek( cRef ) )

      DO CASE
      CASE ( dbfTVta )->NUNDMOV == 1  //
         nCom  := 1
      CASE ( dbfTVta )->NUNDMOV == 2  //
         nCom  := -1
      CASE ( dbfTVta )->NUNDMOV == 3  //
         nCom  := 0
      END CASE

   END IF

RETURN ( nCom )

//--------------------------------------------------------------------------//

/*
Devuelve el factor por el que hay que multiplicar las pesetas de venta
*/

Function nVtaImp( cRef, dbfTVta )

   local nCom  := 1

   IF ( dbfTVta )->( dbSeek( cRef ) )

      DO CASE
      CASE ( dbfTVta )->NIMPMOV == 1  //
         nCom := 1
      CASE ( dbfTVta )->NIMPMOV == 2  //
         nCom := -1
      CASE ( dbfTVta )->NIMPMOV == 3  //
         nCom := 0
      END CASE

   END IF

Return ( nCom )

//--------------------------------------------------------------------------//

function IsTipoVentas()

   local nCont

   if OpenFiles()

      for nCont := 1 to Len( aTipVta )
         ( dbfTVta )->( __dbLocate( { || ( dbfTVta )->cCodMov == aTipVta[ nCont, 1 ] } ) )
         if!( dbfTVta )->( Found() )
            dbGather( aTipVta[ nCont ], dbfTVta, .t. )
         end if
      next

      CloseFiles()

   end if

return ( .t. )

//--------------------------------------------------------------------------//