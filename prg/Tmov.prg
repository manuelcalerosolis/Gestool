#ifndef __PDA__
   #include "FiveWin.Ch"
   #include "Font.ch"
   #include "Report.ch"
#else
   #include "FWCE.ch"
   REQUEST DBFCDX
#endif

#include "Factu.ch" 

#define _CCODMOV                  1      //   C      2     0
#define _CDESMOV                  2      //   C     20     0
#define _NTIPMOV                  3      //   N      1     0
#define _LRECMOV                  4      //   L      1     0
#define _LMODMOV                  5      //   L      1     0

#define _MENUITEM                "01042"

static oWndBrw
static dbfTMov
static bEdit := { |aTemp, aoGet, dbfTMov, oBrw, bWhen, bValid, nMode | EdtRec( aTemp, aoGet, dbfTMov, oBrw, bWhen, bValid, nMode ) }

//---------------------------------------------------------------------------//

function aItmMovAlm()

   local aItmMovAlm  := {}

   aAdd( aItmMovAlm, { "CCODMOV",   "C",  2,  0, "Código tipo de movimiento" ,       "",     "", "( cDbf )"} )
   aAdd( aItmMovAlm, { "CDESMOV",   "C", 20,  0, "Descripción tipo de movimiento" ,  "",     "", "( cDbf )"} )
   aAdd( aItmMovAlm, { "NTIPMOV",   "N",  1,  0, "Tipo de movimiento" ,              "",     "", "( cDbf )"} )
   aAdd( aItmMovAlm, { "LRECMOV",   "L",  1,  0, "Recalculable" ,                    "",     "", "( cDbf )"} )
   aAdd( aItmMovAlm, { "LMODMOV",   "L",  1,  0, "Modificable" ,                     "",     "", "( cDbf )"} )

return ( aItmMovAlm )

//----------------------------------------------------------------------------//

STATIC FUNCTION OpenFiles( cPatEmp )

   local lOpen       := .t.
   local oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   local oError

   DEFAULT cPatEmp   := cPatEmp()

   BEGIN SEQUENCE

      USE ( cPatDat() + "TMOV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TMOV", @dbfTMov ) )
      SET ADSINDEX TO ( cPatDat() + "TMOV.CDX" ) ADDITIVE

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos de tipos de movimientos" )

      CloseFiles()

      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN lOpen

//----------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles()

   CLOSE ( dbfTMOV )

   oWndBrw  := nil

RETURN ( .t. )

//----------------------------------------------------------------------------//

#ifndef __PDA__

FUNCTION TMov( oMenuItem, oWnd )

   local nLevel
   local aDbfBmp

   DEFAULT  oMenuItem   := _MENUITEM
   DEFAULT  oWnd        := oWnd()

   if oWndBrw == nil

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

      AddMnuNext( "Cajeros", ProcName() )

   DEFINE SHELL oWndBrw FROM 2, 10 TO 18, 70;
      XBROWSE ;
      TITLE    "Tipos de movimientos de almacén" ;
      PROMPT   "Codigo",;
					"Nombre";
      MRU      "gc_package_refresh_16";
      BITMAP   clrTopAlmacenes ;
      ALIAS    ( dbfTMov ) ;
      APPEND   ( WinAppRec( oWndBrw:oBrw, bEdit, dbfTMov ) );
      DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdit, dbfTMov ) );
      EDIT     ( if( !( dbfTMov )->lModMov, WinEdtRec( oWndBrw:oBrw, bEdit, dbfTMov ), MsgInfo( "Imposible modificar este movimiento" ) ), .f. );
      DELETE   ( if( !( dbfTMov )->lModMov, DBDelRec(  oWndBrw:oBrw, dbfTMov ),        MsgInfo( "Imposible eliminar este movimiento" ) ),  .f. );
      LEVEL    nLevel ;
      OF       oWnd

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Tipo"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfTMov )->nTipMov <= 1 }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Cnt16" } )
         :AddResource( "gc_arrow_circle2_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodMov"
         :bEditValue       := {|| ( dbfTMov )->cCodMov }
         :nWidth           := 100
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cDesMov"
         :bEditValue       := {|| ( dbfTMov )->cDesMov }
         :nWidth           := 280
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
			ACTION  	( WinZooRec( oWndBrw:oBrw, bEdit, dbfTMov ) );
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

#ifndef __TACTIL__

		DEFINE BTNSHELL RESOURCE "IMP" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( InfMovAlm():New( "Listado de tipos de movimientos de almacén" ):Play() ) ;
         TOOLTIP  "(L)istado" ;
         HOTKEY   "L";
         LEVEL    ACC_IMPR

#endif

      DEFINE BTNSHELL RESOURCE "END" GROUP OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:End() ) ;
         TOOLTIP  "(S)alir" ;
			HOTKEY 	"S"

      ACTIVATE WINDOW oWndBrw VALID ( CloseFiles( aDbfBmp ) )

	ELSE

		oWndBrw:SetFocus()

	END IF

RETURN NIL

#endif

//----------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aTemp, aoGet, dbfTMov, oBrw, bWhen, bValid, nMode )

	local oDlg
	local oGet
   local oGet2

   DEFINE DIALOG oDlg RESOURCE "TIPOMOV" TITLE LblTitle( nMode ) + "tipos de Movimientos"

		REDEFINE GET oGet VAR aTemp[_CCODMOV];
			ID 		110 ;
			PICTURE	"@!";
         WHEN     ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) ;
         VALID    ( NotValid( oGet, dbfTMov, .T., "0" ) ) ;
			COLOR 	CLR_GET ;
			OF 		oDlg

      REDEFINE GET oGet2 VAR aTemp[_CDESMOV] ;
			ID 		120 ;
			COLOR 	CLR_GET ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

		REDEFINE RADIO aTemp[_NTIPMOV] ;
			ID 		130, 131 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( if( lPreSave( aTemp, nMode, oGet, oGet2, dbfTMov ), ( WinGather( aTemp, aoGet, dbfTMov, oBrw, nMode ), oDlg:end( IDOK ) ), ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

   REDEFINE BUTTON ;
         ID       559 ;
			OF 		oDlg ;
         ACTION   ( ChmHelp( "Tipos_de_Movimientos" ) )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| if( lPreSave( aTemp, nMode, oGet, oGet2, dbfTMov ), ( WinGather( aTemp, aoGet, dbfTMov, oBrw, nMode ), oDlg:end( IDOK ) ), ) } )
   end if

   oDlg:AddFastKey ( VK_F1, {|| ChmHelp( "Tipos_de_Movimientos" ) } )

   oDlg:bStart := {|| oGet:SetFocus() }

	ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

STATIC FUNCTION lPreSave( aTemp, nMode, oGet, oGet2, dbfTMov )

   if nMode == APPD_MODE .or. nMode == DUPL_MODE

      if Empty( aTemp[_CCODMOV] )
         MsgStop("El código del tipo de movimiento no puede estar vacío.")
         oGet:SetFocus()
         Return .f.
      end if

      if dbSeekInOrd( aTemp[_CCODMOV], "CCODMOV", dbfTMov )
         MsgStop( "Código ya existe " + Rtrim( aTemp[_CCODMOV] ) )
         return .f.
      end if

   end if

   if Empty( aTemp[ _CDESMOV ] )
      MsgStop("La descripción del tipo de movimiento no puede estar vacía.")
      oGet2:SetFocus()
      Return .f.
   end if

Return .t.

//---------------------------------------------------------------------------//

#ifndef __PDA__

STATIC FUNCTION GenReport( dbfTMov )

	local oReport
	local oFont1
	local oFont2
	local nRecno 		:= ( dbfTMov )->( RecNo() )
   local cTitulo     := Padr( cCodEmp() + " - " + cNbrEmp(), 50 )
   local cSubTitulo  := Padr( "Listado de tipos de movimientos de almacen", 50 )
	local nDevice		:= 1

	/*
	Llamada a la funcion que activa la caja de dialogo
	*/

	IF SetRep( @cTitulo, @cSubTitulo, @nDevice )

		(dbfTMov)->(DbGoTop())

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
            HEADER   "Fecha : " + dtoc(date()) RIGHT ;
            FOOTER   "Página : " + str( oReport:nPage, 3 ) CENTERED;
            CAPTION  "Listando tipos de movimientos";
				PREVIEW

		ELSE

			REPORT oReport ;
				TITLE  	Rtrim( cTitulo ),;
							Rtrim( cSubTitulo ) ;
				FONT   	oFont1, oFont2 ;
            HEADER   "Fecha : " + dtoc(date()) RIGHT ;
            FOOTER   "Página : " + str( oReport:nPage, 3 ) CENTERED;
            CAPTION  "Listando tipos de movimientos";
				TO PRINTER

		END IF

			COLUMN TITLE "Tipo" ;
            DATA     (dbfTMov)->CCODMOV ;
            FONT     2

         COLUMN TITLE "Descripción" ;
            DATA     (dbfTMov)->CDESMOV ;
            FONT     2

		END REPORT

      IF !Empty( oReport ) .and. oReport:lCreated
			oReport:Margin(0, RPT_RIGHT, RPT_CMETERS)
			oReport:bSkip	:= {|| (dbfTMov)->(DbSkip()) }
		END IF

		ACTIVATE REPORT oReport WHILE !(dbfTMov)->(Eof())

		oFont1:end()
		oFont2:end()

	END IF

	(dbfTMov)->(DbGoto( nRecno ) )

RETURN NIL

#endif

//--------------------------------------------------------------------------//

FUNCTION cTMov( oGet, dbfTMov, oGet2, lMessage )

   local oBlock
   local oError
   local lClose      := .f.
   local lValid      := .f.
   local xValor      := oGet:varGet()

   DEFAULT lMessage  := .f.

   if Empty( xValor )
      if( oGet2 != nil, oGet2:cText( "" ), )
      return .t.
   else
      xValor   := RJustObj( oGet, "0" )
   end if

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if dbfTMov == NIL
      USE ( cPatDat() + "TMOV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TMOV", @dbfTMov ) )
      SET ADSINDEX TO ( cPatDat() + "TMOV.CDX" ) ADDITIVE
      lClose      := .t.
   end if

   do case
   case ValType( dbfTMov ) == "C"

      If ( dbfTMov )->( dbSeek( xValor ) ) .OR. ( dbfTMov )->( dbSeek( Upper( xValor ) ) )

         oGet:cText( ( dbfTMov )->cCodMov )

         If oGet2 != NIL
            oGet2:cText( ( dbfTMov )->cDesMov )
         End if

         lValid   := .t.

      Else

         msgStop( "Tipo de movimiento no encontrado" )

      End if

   case ValType( dbfTMov ) == "O"

      If dbfTMov:Seek( xValor ) .OR. dbfTMov:Seek( Upper( xValor ) )

         oGet:cText( dbfTMov:cCodMov )

         If oGet2 != NIL
            oGet2:cText( dbfTMov:cDesMov )
         End if

         lValid   := .t.

      Else

         msgStop( "Tipo de movimiento no encontrado" )

      End if

   end case

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

	If lClose
      CLOSE ( dbfTMov )
	End if

RETURN lValid

//---------------------------------------------------------------------------//

FUNCTION retTMov( dbfTMov, cCodMov )

   local oBlock
   local oError
	local cTemp 	:= 0
	local dbfAnt 	:= Alias()
	local lClose	:= .f.

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

	IF dbfTMov == NIL
      USE ( cPatDat() + "TMOV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TMOV", @dbfTMov ) )
      SET ADSINDEX TO ( cPatDat() + "TMOV.CDX" ) ADDITIVE
		lClose := .t.
	END IF

   IF ( dbfTMov )->( DbSeek( cCodMov ) )
		cTemp = (dbfTMov)->CDESMOV
	END IF

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

	IF lClose
		CLOSE ( dbfTMov )
	END IF

	IF dbfAnt != ""
		SELECT( dbfAnt )
	END IF

RETURN cTemp

//---------------------------------------------------------------------------//

FUNCTION browseGruposMovimientos( oGet, oGet2, dbfTMov )

   local oBlock
   local oError
	local oDlg
   local oGet1
   local cGet1
	local oBrw
   local nOrd     := GetBrwOpt( "BrwTMov" )
   local oCbxOrd
   local aCbxOrd  := { "Código", "Nombre" }
   local cCbxOrd
   local lClose   := .f.
   local nLevel   := Auth():Level( _MENUITEM )
   local oBtn
   local oSayTit
   local oFont

   nOrd           := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd        := aCbxOrd[ nOrd ]

   /*
   Obtenemos el nivel de acceso
   */

   if nAnd( nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      return nil
   end if

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( dbfTMov )
         USE ( cPatDat() + "TMOV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TMOV", @dbfTMov ) )
         SET ADSINDEX TO ( cPatDat() + "TMOV.CDX" ) ADDITIVE
         lClose      := .t.
      end if

      if ValType( dbfTMov ) == "O"
         dbfTMov     := dbfTMov:cAlias
      end if

      ( dbfTMov )->( dbGoTop() )

      DEFINE DIALOG oDlg RESOURCE "HELPENTRY"

         REDEFINE GET oGet1 VAR cGet1;
            ID       104 ;
            ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfTMov ) );
            VALID    ( OrdClearScope( oBrw, dbfTMov ) );
            BITMAP   "FIND" ;
            OF       oDlg

         REDEFINE COMBOBOX oCbxOrd ;
            VAR      cCbxOrd ;
            ID       102 ;
            ITEMS    aCbxOrd ;
            ON CHANGE( ( dbfTMov )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:refresh(), oGet1:SetFocus() ) ;
            OF oDlg

         oBrw                 := IXBrowse():New( oDlg )

         oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
         oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

         oBrw:cAlias          := dbfTMov

         oBrw:nMarqueeStyle   := 5
         oBrw:cName           := "Browse.Tipos de movimientos de almacen"

         with object ( oBrw:AddCol() )
            :cHeader          := "Tipo"
            :nHeadBmpNo       := 3
            :bStrData         := {|| "" }
            :bEditValue       := {|| ( dbfTMov )->nTipMov <= 1 }
            :nWidth           := 20
            :SetCheck( { "Sel16", "Cnt16" } )
            :AddResource( "gc_arrow_circle2_16" )
         end with

         with object ( oBrw:AddCol() )
            :cHeader          := "Código"
            :cSortOrder       := "cCodMov"
            :bEditValue       := {|| ( dbfTMov )->cCodMov }
            :nWidth           := 100
            :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
         end with

         with object ( oBrw:AddCol() )
            :cHeader          := "Nombre"
            :cSortOrder       := "cDesMov"
            :bEditValue       := {|| ( dbfTMov )->cDesMov }
            :nWidth           := 280
            :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
         end with

         oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }
         oBrw:bRClicked       := {| nRow, nCol, nFlags | oBrw:RButtonDown( nRow, nCol, nFlags ) }

         oBrw:CreateFromResource( 105 )

         REDEFINE BUTTON ;
            ID       IDOK ;
            OF       oDlg ;
            ACTION   ( oDlg:end( IDOK ) )

         REDEFINE BUTTON ;
            ID       IDCANCEL ;
            OF       oDlg ;
            ACTION   ( oDlg:end() )

         REDEFINE BUTTON ;
            ID       500 ;
            OF       oDlg ;
            WHEN     ( nAnd( nLevel, ACC_APPD ) != 0 ) ;
            ACTION   ( WinAppRec( oBrw, bEdit, dbfTMov ) );

         REDEFINE BUTTON ;
            ID       501 ;
            OF       oDlg ;
            WHEN     ( nAnd( nLevel, ACC_EDIT ) != 0 ) ;
            ACTION   ( WinEdtRec( oBrw, bEdit, dbfTMov ) )

      oDlg:AddFastKey( VK_F2,       {|| if( nAnd( nLevel, ACC_APPD ) != 0, WinAppRec( oBrw, bEdit, dbfTMov ), ) } )
      oDlg:AddFastKey( VK_F3,       {|| if( nAnd( nLevel, ACC_EDIT ) != 0, WinEdtRec( oBrw, bEdit, dbfTMov ), ) } )
      oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )
      oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )

      ACTIVATE DIALOG oDlg CENTER

      if oDlg:nResult == IDOK

         oGet:cText( ( dbfTMov )->cCodMov )
         oGet:lValid()

         if ValType( oGet2 ) == "O"
            oGet2:cText( ( dbfTMov )->cDesMov )
         end if

      end if

      oGet:setFocus()

      DestroyFastFilter( dbfTMov )

      SetBrwOpt( "BrwTMov", ( dbfTMov )->( OrdNumber() ) )

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if lClose
		CLOSE ( dbfTMov )
   end if

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

FUNCTION lTMov( dbfTMov, cCodMov )

   local oBlock
   local oError
	local lReturn
	local nOrdAnt
   local lClose   := .f.

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

	IF dbfTMov == NIL
      USE ( cPatDat() + "TMOV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TMOV", @dbfTMov ) )
      SET ADSINDEX TO ( cPatDat() + "TMOV.CDX" ) ADDITIVE
      lClose      := .t.
   end if

   if ( dbfTMov )->( dbSeek( cCodMov ) )
      lReturn     := .t.
   else
      MsgStop( "Tipo de movimiento inexistente" )
      lReturn     := .f.
   end if

   ( dbfTMov )->( OrdSetFocus( nOrdAnt ) )

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

	IF lClose
		CLOSE ( dbfTMov )
	END IF

RETURN lReturn

//---------------------------------------------------------------------------//

FUNCTION mkTMov( cPath, lAppend )

   local nCont
	local dbfTMov
   local aTMov       := {  { "EI", "Exs. Iniciales",     1, .T., .T. },;
                           { "MV", "Movimientos",        2, .T., .T. },;
                           { "RG", "Reg. Almacen",       2, .T., .T. } }

	DEFAULT lAppend  := .F.

   dbCreate( cPath + "TMOV.DBF", aSqlStruct( aItmMovAlm() ), cDriver() )

	/*
	A¤adimos registros obligatorios-----------------------------------------
	*/

   if lAppend

      dbUseArea( .t., cDriver(), cPath + "TMOV.DBF", cCheckArea( "TMOV", @dbfTMov ), .f. )

      for nCont := 1 to Len( aTMov )
         dbGather( aTMov[ nCont ], dbfTMov, .T. )
      next

	  ( dbfTMov )->( dbCloseArea() )

   end if

   rxTMov( cPath )

RETURN .t.

//--------------------------------------------------------------------------//

FUNCTION rxTMov( cPath, oMeter )

	local dbfTMov

   DEFAULT cPath  := cPatDat()

   if !lExistTable( cPath + "TMOV.DBF" )
		mkTMov( cPath )
   end if

   fEraseIndex( cPath + "TMOV.DCX" )

   dbUseArea( .t., cDriver(), cPath + "TMOV.DBF", cCheckArea( "TMOV", @dbfTMov ), .f. )
   if !( dbfTMov )->( neterr() )
      ( dbfTMov )->( __dbPack() )

      ( dbfTMov )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfTMov )->( ordCreate( cPath + "TMOV.CDX", "CCODMOV", "Field->CCODMOV", {|| Field->CCODMOV }, ) )

      ( dbfTMov )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfTMov )->( ordCreate( cPath + "TMOV.CDX", "CDESMOV", "Field->CDESMOV", {|| Field->CDESMOV } ) )

      ( dbfTMov )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de movimientos de almacén" )
   end if

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION IsTMov( cPath )

   DEFAULT cPath  := cPatDat()

   if !lExistTable( cPath + "TMOV.Dbf" )
      dbCreate( cPath + "TMOV.DBF", aSqlStruct( aItmMovAlm() ), cDriver() )
   end if

   if !lExistIndex( cPath + "TMOV.Cdx" )
      rxTMov( cPath )
   end if

Return ( .t. )

//---------------------------------------------------------------------------//