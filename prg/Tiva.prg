#ifndef __PDA__
   #include "FiveWin.Ch"
   #include "Font.ch"
   #include "Factu.ch" 
   #include "Report.ch"
#else
   #include "FWCE.ch"
   REQUEST DBFCDX
#endif

#define _TIPO                     1      //   C      1     0
#define _DESCIVA                  2      //   C     30     0
#define _TPIVA                    3      //   N      5     1
#define _NRECEQ                   4      //   N      5     1
#define _GRPASC                   5      //   C      9     0
#define _CODTER                   6      //   C      1     0
#define _CCODWEB                  7      //   N     11     0
#define _LPUBINT                  8      //   L      1
#define _LSNDDOC                  9      //   L      1
#define _NOLDIVA                 10
#define _NOLDREC                 11
#define _CGRPWEB                 12      //   N     11     0

#ifndef __PDA__

static bEdit      := { | aTemp, aoGet, dbfTIva, oBrw, bWhen, bValid, nMode | EdtRec( aTemp, aoGet, dbfTIva, oBrw, bWhen, bValid, nMode ) }

#endif

static dbfTIva
static oWndBrw

#ifndef __PDA__

Static Function OpenFiles()

   local oError
   local oBlock
   local lOpen    := .t.

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatDat() + "TIva.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfTIva ) )
   SET ADSINDEX TO ( cPatDat() + "TIva.Cdx" ) ADDITIVE

  RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      CloseFiles()
      lOpen          := .f.

   END SEQUENCE
   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles()

   if dbfTiva != nil
      ( dbfTiva )->( dbCloseArea() )
   end if

   dbfTiva    := nil
   oWndBrw    := nil

RETURN .T.

//---------------------------------------------------------------------------//
//Funciones del programa
//---------------------------------------------------------------------------//

FUNCTION TIva( oMenuItem, oWnd )

   local oBlock
   local oError
   local nLevel

   DEFAULT  oMenuItem   := "01036"
   DEFAULT  oWnd        := oWnd()

   if Empty( oWndBrw )

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

      IF !OpenFiles()
         RETURN NIL
      END IF

      /*
      Anotamos el movimiento para el navegador
      */

      AddMnuNext( "Tipos de " + cImp(), ProcName() )

      DEFINE SHELL oWndBrw FROM 2, 10 TO 18, 70 ;
         XBROWSE ;
         TITLE    "Tipos de " + cImp() ;
         PROMPT   "Código",;
                  "Nombre",;
                  "%" + cImp() ;
         MRU      "gc_moneybag_16" ;
         BITMAP   clrTopArchivos ;
			ALIAS		( dbfTIva ) ;
         APPEND   WinAppRec( oWndBrw:oBrw, bEdit, dbfTIva ) ;
         DUPLICAT WinDupRec( oWndBrw:oBrw, bEdit, dbfTIva ) ;
         EDIT     WinEdtRec( oWndBrw:oBrw, bEdit, dbfTIva ) ;
         DELETE   WinDelRec( oWndBrw:oBrw, dbfTIva ) ;
         LEVEL    nLevel ;
			OF 		oWnd

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Envio"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfTIva )->lSndDoc }
         :nWidth           := 20
         :SetCheck( { "gc_mail2_12", "Nil16" } )
         :AddResource( "gc_mail2_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Publicar"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfTIva )->lPubInt }
         :nWidth           := 20
         :SetCheck( { "gc_earth_12", "Nil16" } )
         :AddResource( "gc_earth_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código"
         :cSortOrder       := "Tipo"
         :bEditValue       := {|| ( dbfTIva )->Tipo }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "DescIva"
         :bEditValue       := {|| ( dbfTIva )->DescIva }
         :nWidth           := 200
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "%" + cImp()
         :cSortOrder       := "TPIva"
         :bEditValue       := {|| Trans( ( dbfTIva )->TpIva, "@E 999.99" ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "%R.E."
         :bEditValue       := {|| Trans( ( dbfTIva )->nRecEq, "@E 999.99" ) }
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      oWndBrw:lAutoPos     := .f.
      oWndBrw:cHtmlHelp    := "Tipo de " + cImp()

      oWndBrw:CreateXFromCode()

      DEFINE BTNSHELL RESOURCE "BUS" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:SearchSetFocus() ) ;
         TOOLTIP  "(B)uscar";
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
			ACTION 	( oWndBrw:RecDup() );
			TOOLTIP 	"(D)uplicar";
         MRU ;
         HOTKEY   "D";
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
         ACTION   ( WinZooRec( oWndBrw:oBrw, bEdit, dbfTIva ) );
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

      DEFINE BTNSHELL RESOURCE "Lbl" GROUP OF oWndBrw ;
         NOBORDER ;
         MENU     This:Toggle() ;
         TOOLTIP  "En(v)iar" ;
         MESSAGE  "Seleccionar registros para ser enviados" ;
         ACTION   ChangelSndDoc() ;
         HOTKEY   "V";
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "SNDINT" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( ChangePublicar() );
         TOOLTIP  "P(u)blicar" ;
         HOTKEY   "U";
         LEVEL    ACC_EDIT

#ifndef __TACTIL__

      DEFINE BTNSHELL RESOURCE "IMP" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( InfTipIva():New( "Listado de tipos de " + cImp() ):Play() ) ;
         TOOLTIP  "(L)istado";
         HOTKEY   "L";
         LEVEL    ACC_IMPR

#endif

      DEFINE BTNSHELL RESOURCE "END" GROUP OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:End() ) ;
         TOOLTIP  "(S)alir";
         HOTKEY   "S"

      ACTIVATE WINDOW oWndBrw ;
         VALID   ( CloseFiles() ) ;

	ELSE

		oWndBrw:SetFocus()

	END IF

RETURN NIL

//----------------------------------------------------------------------------//

STATIC FUNCTION lPreSave ( aTemp, aoGet, dbfTIva, oBrw, nMode, oDlg )

   if nMode == APPD_MODE .or. nMode == DUPL_MODE

      if dbSeekInOrd( aTemp[ _TIPO ], "Tipo", dbfTIva )
         MsgStop( "Código ya existe " + Rtrim( aTemp[ _TIPO ] ) )
         return nil
      end if

   end if

   if Empty( aTemp[ _DESCIVA ] )
      MsgStop( "La descripción del tipo de " + cImp() + " no puede estar vacía." )
      Return nil
   end if

   aTemp[ _LSNDDOC ] := .t.

   WinGather( aTemp, aoGet, dbfTIva, oBrw, nMode )

Return ( oDlg:end( IDOK ) )

//---------------------------------------------------------------------------//

FUNCTION cTIva( oGet, dbfTIva, oGet2 )

   local oBlock
   local oError
   local nTag
   local nRec
	local lClose 	:= .F.
	local lValid	:= .F.
	local xValor 	:= oGet:varGet()

	IF Empty( xValor )
		RETURN .T.
	END IF

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

	If dbfTIva == NIL
      USE ( cPatDat() + "TIva.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfTIva ) )
      SET ADSINDEX TO ( cPatDat() + "TIva.Cdx" ) ADDITIVE
		lClose	:= .T.
   else
      nTag        := ( dbfTIva )->( OrdSetFocus( 1 ) )
      nRec        := ( dbfTIva )->( RecNo() )
	End if

   If ( dbfTIva )->( dbSeek( xValor ) )

      oGet:cText( ( dbfTIva )->Tipo )

		If oGet2 != NIL
         oGet2:cText( ( dbfTIva )->DescIva )
		End if

      lValid   := .t.

	Else

      msgStop( "Tipo de " + cImp() + " no encontrado" )

	End if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

	If lClose
      CLOSE ( dbfTIva )
   else
      ( dbfTIva )->( OrdSetFocus( nTag  ) )
      ( dbfTIva )->( dbGoTo( nRec ) )
	End if

RETURN lValid

//---------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aTemp, aoGet, dbfTIva, oBrw, bWhen, bValid, nMode )

	local oDlg
	local oGet
	local cGet

   DEFINE DIALOG oDlg RESOURCE "TipoIva" TITLE LblTitle( nMode ) + "tipos de " + cImp()

      REDEFINE GET aoGet[ _TIPO ] VAR aTemp[ _TIPO ];
			ID 		110 ;
         WHEN     ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) ;
         VALID    ( NotValid( aoGet[ _TIPO ], dbfTIva, .T., "0" ) ) ;
			COLOR 	CLR_GET ;
			OF 		oDlg

      REDEFINE GET aTemp[ _DESCIVA ] ;
			ID 		120 ;
			COLOR 	CLR_GET ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET aTemp[ _TPIVA ] ;
			ID 		130 ;
         PICTURE  "@E 99.99";
         SPINNER ;
         MIN      0 ;
         MAX      99 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			OF 		oDlg

      REDEFINE GET aTemp[ _NRECEQ ] ;
			ID 		140 ;
         PICTURE  "@E 99.99";
         SPINNER ;
         MIN      0 ;
         MAX      99 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			OF 		oDlg

      REDEFINE GET aoGet[ _GRPASC ] VAR aTemp[ _GRPASC ] ;
			ID 		150 ;
         WHEN     ( !Empty( cRutCnt() ) .AND. nMode != ZOOM_MODE ) ;
         VALID    ( cGrpVenta( aoGet[ _GRPASC ], , oGet ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwGrpVenta( aoGet[ _GRPASC ], , oGet ) );
         PICTURE  ( Replicate( "9", nLenCuentaContaplus() ) )  ;
			OF 		oDlg

      REDEFINE GET oGet VAR cGet ;
			ID 		160 ;
			WHEN 		( .F. ) ;
			OF 		oDlg

      REDEFINE GET aTemp[ _CODTER ] ;
         ID       170 ;
         PICTURE  "9";
         WHEN     ( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			OF 		oDlg

      REDEFINE CHECKBOX aTemp[ _LPUBINT ] ;
         ID       180 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( if( nMode == DUPL_MODE, if( aoGet[ _TIPO ]:lValid(), lPreSave ( aTemp, aoGet, dbfTIva, oBrw, nMode, oDlg ), ), lPreSave ( aTemp, aoGet, dbfTIva, oBrw, nMode, oDlg ) ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

      REDEFINE BUTTON ;
         ID       559 ;
			OF 		oDlg ;
         ACTION   ( GoHelp() )

   if nMode != ZOOM_MODE
         oDlg:AddFastKey( VK_F5, {|| if( nMode == DUPL_MODE, if( aoGet[ _TIPO ]:lValid(), lPreSave ( aTemp, aoGet, dbfTIva, oBrw, nMode, oDlg ), ), lPreSave ( aTemp, aoGet, dbfTIva, oBrw, nMode, oDlg ) ) } )
   end if

   oDlg:AddFastKey ( VK_F1, {|| GoHelp() } )

   oDlg:bStart := {|| aoGet[_GRPASC]:lValid(), aoGet[ _TIPO ]:SetFocus() }

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

/*
Devuelve los tipos de " + cImp() + " y de Req.
*/

FUNCTION nTiva( cTipoIva, nPctIva, nPctReq )

   local oBlock
   local oError
	local dbfTIva
   local cTemp    := 0

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatDat() + "TIva.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfTIva ) )
   SET ADSINDEX TO ( cPatDat() + "TIva.Cdx" ) ADDITIVE

   if ( dbfTIva )->( dbSeek( cTipoIva ) )

      cTemp       := ( dbfTIva )->TpIva

      if nPctIva != nil
         nPctIva  := ( dbfTIva )->TpIva
      end if

      if nPctReq != nil
         nPctReq  := ( dbfTIva )->nRecEq
      end if

   end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

	CLOSE ( dbfTIva )

RETURN cTemp

//---------------------------------------------------------------------------//
/*
Devuelve el Req. de un tipo de " + cImp() + " determinado
*/

FUNCTION nTReq( cTipoIva )

   local oBlock
   local oError
	local dbfTIva
	local cTemp

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatDat() + "TIva.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfTIva ) )
   SET ADSINDEX TO ( cPatDat() + "TIva.Cdx" ) ADDITIVE

	IF (dbfTIva)->( DBSEEK( cTipoIva ) )
		cTemp = (dbfTIva)->NRECEQ
	ELSE
		cTemp = 0
	END IF

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

	CLOSE (dbfTIva)

RETURN cTemp

//---------------------------------------------------------------------------//
/*
Devuelve el codigo de " + cImp() + " para los terminales de mano
*/

FUNCTION cCodTerIva( cTipoIva, dbfIva )

   local cTemp    := Space( 1 )

   IF ( dbfIva )->( DbSeek( cTipoIva ) )
      cTemp       := (dbfIva)->CodTer
   END IF

RETURN cTemp

//---------------------------------------------------------------------------//
/*
Devuelve el codigo de porcentaje de " + cImp() + " pasandole el codigo del terminal de mano
*/

FUNCTION nIvaCodTer( cCodTer, dbfIva )

   local nTmp     := 0
   local nOrd     := ( dbfIva )->( OrdSetFocus( "CodTer" ) )

   IF ( dbfIva )->( DbSeek( cCodTer ) )
      nTmp        := ( dbfIva )->TpIva
   END IF

   ( dbfIva )->( OrdSetFocus( nOrd ) )

RETURN nTmp

//---------------------------------------------------------------------------//
/*
Devuelve el porcentaje de r.e. pasandole el codigo del terminal de mano
*/

FUNCTION nReqCodTer( cCodTer, dbfIva )

   local nTmp     := 0
   local nOrd     := ( dbfIva )->( OrdSetFocus( 4 ) )

   if ( dbfIva )->( dbSeek( cCodTer ) )
      nTmp        := ( dbfIva )->nRecEq
   end if

   ( dbfIva )->( OrdSetFocus( nOrd ) )

RETURN nTmp

//---------------------------------------------------------------------------//

/*
Devuelve el codigo de del tipo de " + cImp() + " pasandole el codigo del terminal de mano
*/

FUNCTION cCodTerToCodIva( cCodTer, dbfIva )

   local cTmp     := Space(1)
   local nOrd     := ( dbfIva )->( OrdSetFocus( "CodTer" ) )

   if ( dbfIva )->( DbSeek( cCodTer ) )
      cTmp        := ( dbfIva )->Tipo
   end if

   ( dbfIva )->( OrdSetFocus( nOrd ) )

RETURN cTmp

//---------------------------------------------------------------------------//

FUNCTION BrwIva( oGet, dbfTIva, oGetNombre, lTipo )

   local oBlock
   local oError
   local oDlg
	local oGet1
	local cGet1
	local oBrw
   local nOrd     := GetBrwOpt( "BrwIva" )
	local oCbxOrd
   local aCbxOrd  := { "Código", "Nombre" }
   local cCbxOrd
   local lClose   := .f.
   local nLevel   := Auth():Level( "01036" )
   local cReturn  := Space( 1 )

   DEFAULT lTipo  := .f.

   nOrd           := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd        := aCbxOrd[ nOrd ]

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if Empty( dbfTIva )
      USE ( cPatDat() + "TIva.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfTIva ) )
      SET ADSINDEX TO ( cPatDat() + "TIva.Cdx" ) ADDITIVE
      lClose      := .t.
   end if

   nOrd           := ( dbfTIva )->( OrdSetFocus( nOrd ) )

   ( dbfTIva )->( dbGoTop() )

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Tipos de " + cImp()

		REDEFINE GET oGet1 VAR cGet1;
			ID 		104 ;
			ON CHANGE AutoSeek( nKey, nFlags, Self, oBrw, dbfTIva ) ;
         BITMAP   "FIND" ;
         OF       oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    { "Código", "Nombre" } ;
			ON CHANGE( ( dbfTiva )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:refresh(), oGet1:SetFocus() ) ;
			OF 		oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfTIva
      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "Browse.tipo " + cImp()

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "Tipo"
         :bEditValue       := {|| ( dbfTIva )->Tipo }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "DescIva"
         :bEditValue       := {|| ( dbfTIva )->DescIva }
         :nWidth           := 200
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "% " + cImp()
         :bEditValue       := {|| Trans( ( dbfTIva )->TpIva, "@E 999.99") }
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }
      oBrw:bRClicked       := {| nRow, nCol, nFlags | oBrw:RButtonDown( nRow, nCol, nFlags ) }

      oBrw:CreateFromResource( 105 )

		REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         ACTION   ( oDlg:end(IDOK) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

		REDEFINE BUTTON ;
			ID 		500 ;
			OF 		oDlg ;
         WHEN     ( nAnd( nLevel, ACC_APPD ) != 0 .and. !IsReport() ) ;
         ACTION   ( WinAppRec( oBrw, bEdit, dbfTIva ) );

		REDEFINE BUTTON ;
			ID 		501 ;
			OF 		oDlg ;
         WHEN     ( nAnd( nLevel, ACC_EDIT ) != 0 .and. !IsReport() ) ;
         ACTION   ( WinEdtRec( oBrw, bEdit, dbfTIva ) )

   if nAnd( nLevel, ACC_APPD ) != 0 .and. !IsReport()
      oDlg:AddFastKey( VK_F2, {|| WinAppRec( oBrw, bEdit, dbfTIva ) } )
   end if

   if nAnd( nLevel, ACC_EDIT ) != 0 .and. !IsReport()
      oDlg:AddFastKey( VK_F3, {|| WinEdtRec( oBrw, bEdit, dbfTIva ) } )
   end if

   oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )
   oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )

   oDlg:bStart    := {|| oBrw:Load() }

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK

      if lTipo
         cReturn  := ( dbfTIva )->TpIva
      else
         cReturn  := ( dbfTIva )->Tipo
      end if

      if IsObject( oGet )
         oGet:cText( cReturn )
      end if

      if IsObject( oGetNombre )
         oGetNombre:cText( ( dbfTIva )->DescIva )
      end if

   end if

   SetBrwOpt( "BrwIva", ( dbfTIva )->( OrdNumber() ) )

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if lClose
		Close( dbfTIva )
   else
      ( dbfTIva )->( OrdSetFocus( nOrd  ) )
   end if

RETURN ( cReturn )

//---------------------------------------------------------------------------//

FUNCTION BigBrwIva( oGet, dbfTIva )

   local oBlock
   local oError
   local oDlg
   local oBrw
   local nOrd
   local cReturn  := Space( 1 )
   local nRec
   local oFont

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   nRec           := ( dbfTIva )->( Recno() )
   nOrd           := ( dbfTIva )->( OrdSetFocus( "Tipo" ) )

   ( dbfTIva )->( dbGoTop() )

   DEFINE FONT oFont NAME "Verdana" SIZE 0, -14

   DEFINE DIALOG oDlg RESOURCE "HELPENTRYTACTILIVA" TITLE "Tipos de " + cImp()

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfTIva
      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "Browse.Bigtipo " + cImp()
      oBrw:nRowHeight      := 36
      oBrw:oFont           := oFont

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :bEditValue       := {|| ( dbfTIva )->Tipo }
         :nWidth           := 80
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :bEditValue       := {|| ( dbfTIva )->DescIva }
         :nWidth           := 200
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "% " + cImp()
         :bEditValue       := {|| Trans( ( dbfTIva )->TpIva, "@E 999.99") }
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }

      oBrw:CreateFromResource( 105 )

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
         BITMAP   "gc_check_32" ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( oDlg:end(IDOK) )

      REDEFINE BUTTONBMP ;
         BITMAP   "Delete_32" ;
         ID       IDCANCEL ;
         OF       oDlg ;
         ACTION   ( oDlg:End() )

   oDlg:bStart    := {|| oBrw:Load() }

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK

      cReturn  := ( dbfTIva )->TpIva

      if IsObject( oGet )
         oGet:cText( cReturn )
      end if

   end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !Empty( oFont )
      oFont:End()
   end if

   ( dbfTIva )->( OrdSetFocus( nOrd  ) )

   ( dbfTIva )->( dbGoTo( nRec ) ) 

RETURN ( cReturn )

//---------------------------------------------------------------------------//
/*
Devuelve el Codigo del " + cImp() + " pasando el procentaje
*/

FUNCTION cCodigoIva( dbfIva, nPctIva )

   local cTemp       := Space( 1 )

   if dbSeekInOrd( Str( nPctIva, 6, 2 ), "TPIva", dbfIva )
      cTemp          := ( dbfIva )->Tipo
   else
      if dbSeekInOrd( Str( nPctIva, 6, 2 ), "nOldIva", dbfIva )
         cTemp       := ( dbfIva )->Tipo
      end if
   end if

RETURN cTemp

//---------------------------------------------------------------------------//
/*
Devuelve el porcentaje de recargo de equivalencia
*/

FUNCTION nPorcentajeRE( dbfIva, nPctIva )

   local nTemp       := 0

   if dbSeekInOrd( Str( nPctIva, 6, 2 ), "TPIva", dbfIva )
      nTemp          := ( dbfIva )->nRecEQ
   else
      if dbSeekInOrd( Str( nPctIva, 6, 2 ), "nOldIva", dbfIva )
         nTemp       := ( dbfIva )->nRecEQ
      end if
   end if

RETURN nTemp

//---------------------------------------------------------------------------//

FUNCTION retGrpAsc( nCodIva, dbfTiva, cRuta, cCodEmp )

   local oBlock
   local oError
   local cTemp
   local nLenSubCta
   local lClose      := .f.

   DEFAULT cRuta     := cRutCnt()
   DEFAULT cCodEmp   := cEmpCnt( "A" )

   nLenSubCta        := nLenCuentaContaplus( cRuta, cCodEmp )
   cTemp             := Replicate( "0", nLenSubCta )

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if dbfTIva == nil
      USE ( cPatDat() + "TIva.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfTIva ) )
      SET ADSINDEX TO ( cPatDat() + "TIva.Cdx" ) ADDITIVE
      lClose         := .t.
   end if

   if ( dbSeekInOrd( Str( nCodIva, 6, 2 ), "TPIva", dbfTIva ) .and. !empty( ( dbfTIva )->GrpAsc ) )
      cTemp          := SubStr( ( dbfTIva )->GrpAsc, 1, nLenSubCta )
   end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if lClose
		CLOSE ( dbfTIva )
   end if

RETURN ( Rtrim( cTemp ) )

//---------------------------------------------------------------------------//

#else

//---------------------------------------------------------------------------//
//Funciones solo de PDA
//---------------------------------------------------------------------------//

static function pdaMenuEdtRec( oDlg, oBrw )

   local oMenu

   DEFINE MENU oMenu ;
      RESOURCE 100 ;
      BITMAPS  10 ; // bitmaps resoruces ID
      IMAGES   3     // number of images in the bitmap

      REDEFINE MENUITEM ID 110 OF oMenu ACTION ( oDlg:End( IDOK ) )

      REDEFINE MENUITEM ID 120 OF oMenu ACTION ( oDlg:End( IDCANCEL ) )

   oDlg:SetMenu( oMenu )

   oBrw:GoTop()

Return oMenu

//---------------------------------------------------------------------------//

FUNCTION pdaBrwTipoIva( oGet, dbfTIva, oGet2 )

   local oBlock
   local oError
   local oFont
   local oBtn
	local oDlg
	local oGet1
	local cGet1
	local oBrw
   local nOrd     := GetBrwOpt( "BrwTiva" )
	local oCbxOrd
   local aCbxOrd  := { "Código", "Nombre" }
   local cCbxOrd
   local lClose   := .f.
   local nLevel   := Auth():Level( "01036" )
   local oSayText
   local cSayText := "Tipos de I.V.A"

   nOrd           := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd        := aCbxOrd[ nOrd ]

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if dbfTIva == nil
      USE ( cPatDat() + "TIva.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfTIva ) )
      SET ADSINDEX TO ( cPatDat() + "TIva.Cdx" ) ADDITIVE
      lClose      := .t.
   end if

   nOrd           := ( dbfTIva )->( OrdSetFocus( nOrd ) )

   ( dbfTIva )->( dbGoTop() )

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY_PDA"      TITLE "Seleccionar tipo de " + cImp()

      DEFINE FONT oFont NAME "Verdana" SIZE 0, -14

      REDEFINE SAY oSayTit ;
         VAR      "Buscando tipo de " + cImp() ;
         ID       110 ;
         COLOR    "N/W*" ;
         FONT     oFont ;
         OF       oDlg

      REDEFINE BTNBMP oBtn ;
         ID       100 ;
         OF       oDlg ;
         FILE     ( cPatBmp() + "gc_user_16.bmp" ) ;
         NOBORDER ;
         ACTION      ( nil )

      oBtn:SetColor( 0, nRGB( 255, 255, 255 )  )

		REDEFINE GET oGet1 VAR cGet1;
			ID 		104 ;
			ON CHANGE AutoSeek( nKey, nFlags, Self, oBrw, dbfTIva ) ;
         BITMAP   "FIND" ;
         OF       oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( ( dbfTiva )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:refresh(), oGet1:SetFocus(), ( dbfTiva )->( OrdSetFocus( oCbxOrd:nAt ) ), oCbxOrd:refresh() ) ;
			OF 		oDlg

		REDEFINE LISTBOX oBrw ;
			FIELDS ;
                  (dbfTIva)->Tipo + CRLF + (dbfTIva)->DescIva ,;
                  Trans( (dbfTIva)->TpIva, "@E 999.99"),;
                  "";
			HEADER;
                  "Código" + CRLF + "Nombre",;
                  "%";
         SIZES;
                  180,;
                  80;
         ALIAS    ( dbfTIva );
         ON DBLCLICK ( oDlg:end( IDOK ) );
         ID       105 ;
         OF       oDlg

         oBrw:aJustify  := { .f., .f., .t., .f. }
         oBrw:aActions  := {| nCol | lPressCol( nCol, oBrw, oCbxOrd, aCbxOrd, dbfTIva ) }


   ACTIVATE DIALOG oDlg ;
      ON INIT ( pdaMenuEdtRec( oDlg, oBrw ) )

   if oDlg:nResult == IDOK

      oGet:cText( ( dbfTIva )->TpIva )

      if ValType( oGet2 ) == "O"
         oGet2:cText( ( dbfTIva )->DescIva )
      end if

   end if

   DestroyFastFilter( dbfTIva )

   SetBrwOpt( "BrwTiva", ( dbfTIva )->( OrdNumber() ) )

   oGet:SetFocus()

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if lClose
		Close( dbfTIva )
   else
      ( dbfTIva )->( OrdSetFocus( nOrd  ) )
   end if

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

#endif

CLASS pdaTIvaSenderReciver

   Method CreateData()

END CLASS

//----------------------------------------------------------------------------//

Method CreateData( oPgrActual, oSayStatus, cPatPreVenta ) CLASS pdaTIvaSenderReciver

   local dbfIva
   local tmpIva
   local lExist      := .f.
   local cFileName
   local cPatPc      := if( Empty( cPatPreVenta ), AllTrim( cNombrePc() ), cPatPreVenta )

   USE ( cPatDat() + "TIva.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIva", @dbfIva ) )
   SET ADSINDEX TO ( cPatDat() + "TIva.Cdx" ) ADDITIVE

   dbUseArea( .t., cDriver(), cPatPc + "Datos\TIva.Dbf", cCheckArea( "TIva", @tmpIva ), .t. )
   ( tmpIva )->( ordListAdd( cPatPc + "Datos\TIva.Cdx" ) )

   if !Empty( oPgrActual )
      oPgrActual:SetRange( 0, ( tmpIva )->( OrdKeyCount() ) )
   end if

   ( tmpIva )->( dbGoTop() )
   while !( tmpIva )->( eof() )

      if ( dbfIva )->( dbSeek( ( tmpIva )->Tipo ) )
         dbPass( tmpIva, dbfIva, .f. )
      else
         dbPass( tmpIva, dbfIva, .t. )
      end if

      ( tmpIva )->( dbSkip() )

      if !Empty( oSayStatus )
         oSayStatus:SetText( "Sincronizando Tipos de " + cImp() + Alltrim( Str( ( tmpIva )->( OrdKeyNo() ) ) ) + " de " + Alltrim( Str( ( tmpIva )->( OrdKeyCount() ) ) ) )
      end if

      SysRefresh()

      if !Empty( oPgrActual )
         oPgrActual:SetPos( ( tmpIva )->( OrdKeyNo() ) )
      end if

      SysRefresh()

   end while

   CLOSE ( tmpIva )
   CLOSE ( dbfIva )

Return ( Self )

//---------------------------------------------------------------------------//

//---------------------------------------------------------------------------//
//Funciones comunes para el programa y el PDA
//---------------------------------------------------------------------------//

Function IsIva()

   local oError
   local oBlock
   local dbfIva

   if !lExistTable( cPatDat() + "TIva.Dbf" )
      mkTiva( cPatDat() )
   end if

   if !lExistIndex( cPatDat() + "TIva.Cdx" )
      rxTiva( cPatDat() )
   end if

   oBlock                     := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      USE ( cPatDat() + "TIva.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfIva ) )
      SET ADSINDEX TO ( cPatDat() + "TIva.Cdx" ) ADDITIVE

      ( dbfIva )->( __dbLocate( { || ( dbfIva )->Tipo == "G" } ) )
      if!( dbfIva )->( Found() )
         ( dbfIva )->( dbAppend() )
         ( dbfIva )->Tipo     := "G"
         ( dbfIva )->DescIva  := "General"
         ( dbfIva )->TpIva    := 21
         ( dbfIva )->nRecEq   := 5.2
         ( dbfIva )->( dbUnLock() )
      end if

      ( dbfIva )->( __dbLocate( { || ( dbfIva )->Tipo == "N" } ) )
      if!( dbfIva )->( Found() )
         ( dbfIva )->( dbAppend() )
         ( dbfIva )->Tipo     := "N"
         ( dbfIva )->DescIva  := "Reducido"
         ( dbfIva )->TpIva    := 10
         ( dbfIva )->nRecEq   := 1.4
         ( dbfIva )->( dbUnLock() )
      end if

      ( dbfIva )->( __dbLocate( { || ( dbfIva )->Tipo == "R" } ) )
      if!( dbfIva )->( Found() )
         ( dbfIva )->( dbAppend() )
         ( dbfIva )->Tipo     := "R"
         ( dbfIva )->DescIva  := "Super reducido"
         ( dbfIva )->TpIva    := 4
         ( dbfIva )->nRecEq   := 0.5
         ( dbfIva )->( dbUnLock() )
      end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE ( dbfIva )

Return ( .t. )

//----------------------------------------------------------------------------//

FUNCTION mkTiva( cPath, lAppend, cPathOld )

	local dbfTIva

   DEFAULT lAppend := .f.

   if !lExistTable( cPath + "TIva.Dbf" )
      dbCreate( cPath + "TIva.Dbf", aSqlStruct( aItmTIva() ), cDriver() )
   end if

   if lAppend .and. lIsDir( cPathOld )
      dbUseArea( .t., cDriver(), cPath + "TIva.Dbf", cCheckArea( "TIVA", @dbfTIva ), .f. )
      if !( dbfTIva )->( neterr() )
         ( dbfTIva )->( __dbApp( cPathOld + "TIva.Dbf" ) )
         ( dbfTIva )->( dbCloseArea() )
      end if
   end if

   rxTiva( cPath )

RETURN .t.

//--------------------------------------------------------------------------//

FUNCTION rxTiva( cPath )

	local dbfTIva

   DEFAULT cPath  := cPatDat()

   if !lExistTable( cPath + "TIva.Dbf" )
      dbCreate( cPath + "TIva.Dbf", aSqlStruct( aItmTIva() ), cDriver() )
   end if

   if lExistIndex( cPath + "TIva.Cdx" )
      fErase( cPath + "TIva.Cdx" )
   end if

   dbUseArea( .t., cDriver(), cPath + "TIva.Dbf", cCheckArea( "TIVA", @dbfTIva ), .f. )

   if !( dbfTIva )->( neterr() )

      ( dbfTIva )->( __dbPack() )

      ( dbfTIva )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfTIva )->( ordCreate( cPath + "TIva.Cdx", "Tipo", "Field->Tipo", {|| Field->Tipo } ) )

      ( dbfTIva )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfTIva )->( ordCreate( cPath + "TIva.Cdx", "DescIva", "Upper( Field->DescIva )", {|| Upper( Field->DescIva ) } ) )

      ( dbfTIva )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfTIva )->( ordCreate( cPath + "TIva.Cdx", "TpIva", "Str( Field->TpIva, 6, 2 )", {|| Str( Field->TpIva, 6, 2 ) } ) )

      ( dbfTIva )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfTIva )->( ordCreate( cPath + "TIva.Cdx", "nOldIva", "Str( Field->nOldIva, 6, 2 )", {|| Str( Field->nOldIva, 6, 2 ) } ) )

      ( dbfTIva )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfTIva )->( ordCreate( cPath + "TIva.Cdx", "CodTer", "Field->CodTer", {|| Field->CodTer } ) )

      ( dbfTIva )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfTIva )->( ordCreate( cPath + "TIva.Cdx", "cCodWeb", "Str( Field->cCodWeb, 11 )", {|| Str( Field->cCodWeb, 11 ) } ) )

      ( dbfTIva )->( dbCloseArea() )

   else

      msgStop( "Imposible abrir en modo exclusivo la tabla de tipos de " + cImp() )

   end if

RETURN NIL

//---------------------------------------------------------------------------//

function aItmTIva()

   local aItmTIva := {}

   aAdd( aItmTIva, { "Tipo",     "C",  1,  0 , "Código del tipo de impuesto",             "",   "", "( cDbf )" } )
   aAdd( aItmTIva, { "DescIva",  "C", 30,  0 , "Descripción del tipo de impuesto" ,       "",   "", "( cDbf )" } )
   aAdd( aItmTIva, { "TpIva",    "N",  6,  2 , "Tipo de impuesto" ,                       "",   "", "( cDbf )" } )
   aAdd( aItmTIva, { "nRecEq",   "N",  6,  2 , "Recargo de equivalencia" ,                "",   "", "( cDbf )" } )
   aAdd( aItmTIva, { "GrpAsc",   "C",  9,  0 , "Grupo de venta asociado" ,                "",   "", "( cDbf )" } )
   aAdd( aItmTIva, { "CodTer",   "C",  1,  0 , "Código para terminales" ,                 "",   "", "( cDbf )" } )
   aAdd( aItmTIva, { "cCodWeb",  "N", 11,  0 , "Código de la web" ,                       "",   "", "( cDbf )" } )
   aAdd( aItmTIva, { "lPubInt",  "L",  1,  0 , "Lógico para publicar en internet (S/N)",  "",   "", "( cDbf )" } )
   aAdd( aItmTIva, { "lSndDoc",  "L",  1,  0 , "Lógico para envios" ,                     "",   "", "( cDbf )" } )
   aAdd( aItmTIva, { "nOldIva",  "N",  6,  2 , "Tipo de impuesto anterior" ,              "",   "", "( cDbf )" } )
   aAdd( aItmTIva, { "nOldRec",  "N",  6,  2 , "Recargo de equivalencia anterior" ,       "",   "", "( cDbf )" } )
   aAdd( aItmTIva, { "cGrpWeb",  "N", 11,  0 , "Código del grupo de la web" ,             "",   "", "( cDbf )" } )

return ( aItmTIva )

//---------------------------------------------------------------------------//

FUNCTION nPReq( dbfTIva, nCodIva )

	local nTemp			:= 0

   if dbSeekInOrd( Str( nCodIva, 6, 2 ), "TPIva", dbfTIva )
      nTemp          := ( dbfTIva )->nRecEq
   end if

RETURN nTemp

//---------------------------------------------------------------------------//

FUNCTION nReq( dbfTIva, cCodIva )

	local cTemp 		:= 0

   if dbSeekInOrd( cCodIva, "Tipo", dbfTIva )
      cTemp          := ( dbfTIva )->nRecEq
   end if

RETURN cTemp

//---------------------------------------------------------------------------//

/*
Devuelva el Tipo de " + cImp() + " pasando el Codigo
*/

FUNCTION nIva( dbfTIva, cCodIva )

   local oBlock
   local oError
   local nOrdFocus
   local lClose      := .f.
	local cTemp 		:= 0

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if Empty( dbfTIva )
      USE ( cPatDat() + "TIva.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfTIva ) )
      SET ADSINDEX TO ( cPatDat() + "TIva.Cdx" ) ADDITIVE
      lClose         := .t.
   end if

   do case
   case ValType( dbfTIva ) == "C"

      nOrdFocus      := ( dbfTIva )->( OrdSetFocus( "TIPO" ) )

      if ( dbfTIva )->( dbSeek( cCodIva ) )
         cTemp       := ( dbfTIva )->TPIva
      end if

      ( dbfTIva )->( OrdSetFocus( nOrdFocus ) )

   case ValType( dbfTIva ) == "O"

      nOrdFocus      := dbfTIva:OrdSetFocus( "TIPO" )

      if dbfTIva:Seek( cCodIva )
         cTemp       := dbfTIva:TPIva
      end if

      dbfTIva:OrdSetFocus( nOrdFocus )

   end case

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if lClose
		CLOSE ( dbfTIva )
   end if

RETURN cTemp

//---------------------------------------------------------------------------//

FUNCTION lTIva( uTipoIva, uPctIva, nPctReq )

   local oBlock
   local oError
   local nPctIva
   local lReturn        := .f.
   local lClose         := .f.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if Empty( uTipoIva )
      USE ( cPatDat() + "TIva.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @uTipoIva ) )
      SET ADSINDEX TO ( cPatDat() + "TIva.Cdx" ) ADDITIVE
      lClose            := .t.
   end if

   if IsObject( uPctIva )
      nPctIva           := uPctIva:VarGet()
   else
      nPctIva           := uPctIva
   end if

   do case
      case IsObject( uTipoIva )

         if uTipoIva:SeekInOrd( Str( nPctIva, 6, 2 ), "TPIva" )

            if nPctReq != nil
               nPctReq  := uTipoIva:nRecEq
            end if

            lReturn     := .t.

         else

            if uTipoIva:SeekInOrd( Str( nPctIva, 6, 2 ), "nOldIva" ) .and. uTipoIva:nOldIva != 0

               if nPctReq != nil
                  nPctReq  := uTipoIva:nRecEq
               end if

               lReturn     := .t.

            else

#ifndef __PDA__

               MsgStop( "Tipo de " + cImp() + " inexistente" )
               lReturn     := .f.

#endif

            end if

         end if

      case IsChar( uTipoIva )

         if dbSeekInOrd( Str( nPctIva, 6, 2 ), "TPIva", uTipoIva )

            if nPctReq != nil
               nPctReq  := ( uTipoIva )->nRecEq
            end if

            lReturn     := .t.

         else

            if dbSeekInOrd( Str( nPctIva, 6, 2 ), "nOldIva", uTipoIva ) .and. ( uTipoIva )->nOldIva != 0

               if nPctReq != nil
                  nPctReq  := ( uTipoIva )->nRecEq
               end if

               lReturn     := .t.

            else

#ifndef __PDA__

            MsgStop( "Tipo de " + cImp() + " inexistente" )
            lReturn     := .f.

#endif

            end if

         end if

      end case

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if lClose
      CLOSE ( uTipoIva )
   end if

RETURN lReturn

//---------------------------------------------------------------------------//

Static Function ChangePublicar()

   if ( dbfTIva )->( dbRLock() )
      ( dbfTIva )->lPubInt   := !( dbfTIva )->lPubInt
      ( dbfTIva )->lSndDoc   := ( dbfTIva )->lPubInt
      ( dbfTIva )->( dbUnLock() )
   end if

   oWndBrw:Refresh()

Return nil

//---------------------------------------------------------------------------//

Static Function ChangelSndDoc( aTmp )

   if ( dbfTIva )->( dbRLock() )
      ( dbfTIva )->lSndDoc   := !( dbfTIva )->lSndDoc
      ( dbfTIva )->( dbUnLock() )
   end if

   oWndBrw:Refresh()

Return nil

//---------------------------------------------------------------------------//