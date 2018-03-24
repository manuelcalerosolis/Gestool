#include "FiveWin.Ch"
#include "Font.ch"
#include "Folder.ch"
#include "Report.ch"
#include "Factu.ch" 
#include "Xbrowse.ch"

static oWndBrw
static cNewFile1
static cNewFile2
static dbfTmp1
static dbfTmp2
static dbfPromoT
static dbfPromoL
static dbfPromoC
static dbfArticulo
static dbfAgentes
static dbfClient
static dbfTarPreT
static bEdit1     := {  |aBlank, aoGet, dbfPromoT, oBrw, bWhen, bValid, nMode | EdtRec( aBlank, aoGet, dbfPromoT, oBrw, bWhen, bValid, nMode ) }
static bEdit2     := {  |aBlank, aoGet, dbfPromoL, oBrw, bWhen, bValid, nMode, cCodPro | EdtDet( aBlank, aoGet, dbfPromoL, oBrw, bWhen, bValid, nMode, cCodPro ) }
static bEdit3     := {  |aBlank, aoGet, dbfPromoC, oBrw, bWhen, bValid, nMode, cCodPro | EdtCli( aBlank, aoGet, dbfPromoC, oBrw, bWhen, bValid, nMode, cCodPro ) }

//----------------------------------------------------------------------------//

FUNCTION Promocion( oMenuItem, oWnd )

   local nLevel

   DEFAULT  oMenuItem   := "01021"
   DEFAULT  oWnd        := oWnd()

	IF oWndBrw == NIL

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

      /*
      Apertura de ficheros
      */

      IF !OpenFiles()
         RETURN NIL
      END IF

      /*
      Anotamos el movimiento para el navegador
      */

      AddMnuNext( "Promociones de artículos", ProcName() )

      DEFINE SHELL oWndBrw FROM 0, 0 TO 22, 80 ;
      XBROWSE ;
      TITLE    "Promociones de artículos" ;
      PROMPT   "Promoción",;
					"Tarifa",;
               "Artículo";
      MRU      "gc_star2_blue_16";
      BITMAP   clrTopArchivos ;
      ALIAS    ( dbfPromoT ) ;
      APPEND   ( WinAppRec( oWndBrw:oBrw, bEdit1, dbfPromoT ) );
      DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdit1, dbfPromoT ) );
		EDIT 		( WinEdtRec( oWndBrw:oBrw, bEdit1, dbfPromoT ) ) ;
		DELETE   ( DBDelRec(  oWndBrw:oBrw, dbfPromoT ) ) ;
      LEVEL    nLevel ;
		OF 		oWnd

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Promoción"
         :cSortOrder       := "cCodPro"
         :bEditValue       := {|| ( dbfPromoT )->cCodPro + Space( 1 ) + ( dbfPromoT )->cNomPro }
         :nWidth           := 160
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Tarifa"
         :cSortOrder       := "cCodTar"
         :bEditValue       := {|| ( dbfPromoT )->cCodTar + Space( 1 ) + retTarifa( ( dbfPromoT )->cCodTar, dbfTarPreT ) }
         :nWidth           := 160
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Artículo"
         :cSortOrder       := "cCodArt"
         :bEditValue       := {|| ( dbfPromoT )->cCodArt + Space( 1 ) + retArticulo( ( dbfPromoT )->cCodArt, dbfArticulo ) }
         :nWidth           := 240
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Fecha inicio"
         :cSortOrder       := "dIniPro"
         :bEditValue       := {|| Dtoc( ( dbfPromoT )->dIniPro ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Fecha fin"
         :cSortOrder       := "dFinPro"
         :bEditValue       := {|| Dtoc( ( dbfPromoT )->dFinPro ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "% Descuento"
         :bEditValue       := {|| Trans( ( dbfPromoT )->nDtoPro, "@E 99.99" ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      oWndBrw:CreateXFromCode()

      oWndBrw:cHtmlHelp    := "Promociones"

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
         HOTKEY   "A" ;
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
			TOOLTIP 	"(M)odificar";
         MRU ;
         HOTKEY   "M" ;
         LEVEL    ACC_EDIT

		DEFINE BTNSHELL RESOURCE "ZOOM" OF oWndBrw ;
			NOBORDER ;
			ACTION  	( WinZooRec( oWndBrw:oBrw, bEdit1, dbfPromoT ) );
			TOOLTIP 	"(Z)oom";
         MRU ;
         HOTKEY   "Z" ;
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
         ACTION   ( InfPro():New( "Listado de promociones" ):Play() ) ;
			TOOLTIP 	"(L)istado" ;
         HOTKEY   "L" ;
         LEVEL    ACC_ZOOM

#endif

      DEFINE BTNSHELL RESOURCE "END" GROUP OF oWndBrw ;
			NOBORDER ;
			ACTION 	( oWndBrw:end() ) ;
			TOOLTIP 	"(S)alir" ;
			HOTKEY 	"S"

      ACTIVATE WINDOW oWndBrw VALID CloseFiles()

	ELSE

		oWndBrw:SetFocus()

	END IF

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aBlank, aoGet, dbfPromoT, oBrw, bWhen, bValid, nMode )

	local oDlg
	local oGet
	local oGetTxt, cGetTxt
	local oGetTxt2, cGetTxt2
	local oBrw2
	local oBrw3
	local oTxt
	local cTxt	:= ""

   if nMode != ZOOM_MODE .and. oUser():lNotCambiarPrecio()
      MsgStop( "No tiene autorización para añadir o modificar promociones." )
      Return .f.
   end if

   BeginTrans( aBlank, nMode )

   DEFINE DIALOG oDlg RESOURCE "PROMO" TITLE LblTitle( nMode ) + "promociones de artículos"

		/*
		Redefinici¢n de la primera caja de Dialogo
		*/

      REDEFINE GET oGet ;
         VAR      aBlank[ (dbfPromoT)->( FieldPos( "CCODPRO" ) ) ];
			ID 		90 ;
			PICTURE 	"@!" ;
         WHEN     ( nMode == APPD_MODE .OR. nMode == DUPL_MODE ) ;
         VALID    ( NotValid( oGet, dbfPromoT, .t., "0" ) ) ;
         OF       oDlg

      REDEFINE    GET aoGet[ (dbfPromoT)->( FieldPos( "CNOMPRO" ) ) ] ;
         VAR      aBlank[ (dbfPromoT)->( FieldPos( "CNOMPRO" ) ) ];
         ID       95 ;
			PICTURE 	"@!" ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE    GET aoGet[ (dbfPromoT)->( FieldPos( "CCODTAR" ) ) ] ;
         VAR      aBlank[ (dbfPromoT)->( FieldPos( "CCODTAR" ) ) ];
			ID 		100 ;
			PICTURE 	"@!" ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			VALID		( cTarifa( aoGet[ (dbfPromoT)->( FieldPos( "CCODTAR" ) ) ], oGetTxt ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwTarifa( aoGet[ (dbfPromoT)->( FieldPos( "CCODTAR" ) ) ], oGetTxt ) );
         OF       oDlg

		REDEFINE GET oGetTxt VAR cGetTxt ;
			ID 		105 ;
			PICTURE 	"@!" ;
			WHEN 		( .F. ) ;
         OF       oDlg

      REDEFINE GET aoGet[ (dbfPromoT)->( FieldPos( "CCODART" ) ) ]  VAR aBlank[ (dbfPromoT)->( FieldPos( "CCODART" ) ) ] ;
			ID 		110 ;
         VALID    ( cArticulo( aoGet[ (dbfPromoT)->( FieldPos( "CCODART" ) ) ], , oGetTxt2 ) ) ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwArticulo( aoGet[ (dbfPromoT)->( FieldPos( "CCODART" ) ) ], oGetTxt2 ) ) ;
         OF       oDlg

		REDEFINE GET oGetTxt2 VAR cGetTxt2 ;
			ID 		115 ;
			PICTURE 	"@!" ;
			WHEN 		( .F. ) ;
         OF       oDlg

      REDEFINE GET aBlank[ (dbfPromoT)->( FieldPos( "DINIPRO" ) ) ] ;
			ID 		120 ;
			SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

		REDEFINE GET aBlank[ (dbfPromoT)->( FieldPos( "DFINPRO" ) ) ] ;
			ID 		130 ;
			SPINNER ;
         VALID    ( SetNumDay( aBlank, oTxt ) );
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET oTxt VAR cTxt ;
			ID 		135 ;
         WHEN     ( .t. );
         OF       oDlg

		REDEFINE GET aBlank[ (dbfPromoT)->( FieldPos( "NDTOPRO" ) ) ] ;
			ID 		140 ;
			SPINNER ;
			PICTURE	"@E 99.99";
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

		/*
		Segunda caja de Dialogo_______________________________________________
		*/

      oBrw2          := IXBrowse():New( oDlg )

      oBrw2:bClrSel        := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw2:bClrSelFocus   := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw2:cAlias         := dbfTmp1
      oBrw2:nMarqueeStyle  := 5

         with object ( oBrw2:AddCol() )
            :cHeader          := "Agente"
            :bStrData         := {|| ( dbfTmp1 )->cCodAge + Space( 1 ) + RetNbrAge( ( dbfTmp1 )->cCodAge, dbfAgentes ) }
            :nWidth           := 240
         end with

         with object ( oBrw2:AddCol() )
            :cHeader          := "% Descuento"
            :bEditValue       := {|| Trans( ( dbfTmp1 )->nDtoAge, "@E 99.99" ) }
            :nWidth           := 60
            :nDataStrAlign    := AL_RIGHT
            :nHeadStrAlign    := AL_RIGHT
         end with

         if nMode != ZOOM_MODE
            oBrw2:bLDblClick  := {|| WinEdtRec( oBrw2, bEdit2, dbfTmp1 ) }
         end if

      oBrw2:CreateFromResource( 200 )

      oBrw2:lHScroll := .f.

      REDEFINE BUTTON ;
			ID 		500 ;
         OF       oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			ACTION 	( WinAppRec( oBrw2, bEdit2, dbfTmp1, , , aBlank[ 1 ] ) )

      REDEFINE BUTTON ;
			ID 		501 ;
         OF       oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			ACTION 	( WinEdtRec( oBrw2, bEdit2, dbfTmp1 ) )

      REDEFINE BUTTON ;
			ID 		502 ;
         OF       oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			ACTION 	( DBDelRec(oBrw2, dbfTmp1 ) )

		/*
		Tercera caja de dialogo________________________________________________
		*/
      /*
		REDEFINE LISTBOX oBrw3 ;
			FIELDS	(dbfTmp2)->CCODCLI + Space(1) + RetClient( (dbfTmp2)->CCODCLI, dbfClient ),;
						(dbfTmp2)->CCODOBR,;
						Trans( (dbfTmp2)->NDTOPRO, "@E 999,99" ),;
						Trans( (dbfTmp2)->NCOMAGE, "@E 999,99" );
         HEAD     "Cliente",;
						"Cod. dirección",;
						"% Dto. Prm.",;
						"% Com. Age.";
			FIELDSIZES;
						200,;
						60,;
						60,;
						60;
			ALIAS 	( dbfTmp2 );
         ID       300 ;
         OF       oDlg

			IF nMode	!= ZOOM_MODE
				oBrw3:bAdd 			= {|| WinAppRec( oBrw3, bEdit3, dbfTmp2, , , aBlank[1] ) }
				oBrw3:bLDblClick 	= {|| WinEdtRec( oBrw3, bEdit3, dbfTmp2 ) }
				oBrw3:bEdit			= {|| WinEdtRec( oBrw3, bEdit3, dbfTmp2 ) }
				oBrw3:bDel 			= {|| dbDelRec( oBrw3, dbfTmp2 ) }
			END IF
      */

      oBrw3          := IXBrowse():New( oDlg )

      oBrw3:bClrSel        := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw3:bClrSelFocus   := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw3:cAlias         := dbfTmp2

      oBrw3:nMarqueeStyle  := 5

         with object ( oBrw3:AddCol() )
            :cHeader          := "Cliente"
            :bStrData         := {|| Rtrim( ( dbfTmp2 )->cCodCli ) + Space( 1 ) + RetClient( ( dbfTmp2 )->cCodCli, dbfClient ) }
            :nWidth           := 160
         end with

         with object ( oBrw3:AddCol() )
            :cHeader          := "Dirección"
            :bStrData         := {|| ( dbfTmp2 )->cCodObr }
            :nWidth           := 40
         end with

         with object ( oBrw3:AddCol() )
            :cHeader          := "% Descuento promoción"
            :bEditValue       := {|| ( dbfTmp2 )->nDtoPro }
            :cEditPicture     := "@E 999.99"
            :nWidth           := 40
            :nDataStrAlign    := AL_RIGHT
            :nHeadStrAlign    := AL_RIGHT
         end with

         with object ( oBrw3:AddCol() )
            :cHeader          := "% Comisión agente"
            :bEditValue       := {|| ( dbfTmp2 )->nComAge }
            :cEditPicture     := "@E 999.99"
            :nWidth           := 40
            :nDataStrAlign    := AL_RIGHT
            :nHeadStrAlign    := AL_RIGHT
         end with

         if nMode != ZOOM_MODE
            oBrw3:bLDblClick  := {|| WinEdtRec( oBrw3, bEdit3, dbfTmp2 ) }
         end if

      oBrw3:CreateFromResource( 300 )

      oBrw3:lHScroll          := .f.

      REDEFINE BUTTON ;
         ID       600 ;
         OF       oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			ACTION 	( WinAppRec( oBrw3, bEdit3, dbfTmp2, , , aBlank[1] ) )

      REDEFINE BUTTON ;
         ID       610 ;
         OF       oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			ACTION 	( WinEdtRec( oBrw3, bEdit3, dbfTmp2 ) )

      REDEFINE BUTTON ;
         ID       620 ;
         OF       oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			ACTION 	( dbDelRec( oBrw3, dbfTmp2 ) )

		/*
		Botones________________________________________________________________
		*/

      REDEFINE BUTTON ;
			ID 		511 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( if( EndTrans( aBlank, oGet, aoGet, nMode, oBrw2, oBrw3 ), ( WinGather( aBlank, aoGet, dbfPromoT, oBrw, nMode ), oDlg:end( IDOK ) ), ) )

		REDEFINE BUTTON ;
			ID 		510 ;
			OF 		oDlg ;
         ACTION   ( KillTrans(), oDlg:end() )

      REDEFINE BUTTON ;
         ID       9 ;
			OF 		oDlg ;
         ACTION   ( ChmHelp ("Promociones") )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F2, {|| WinAppRec( oBrw2, bEdit2, dbfTmp1, , , aBlank[ 1 ] ) } )
      oDlg:AddFastKey( VK_F3, {|| WinEdtRec( oBrw2, bEdit2, dbfTmp1 ) } )
      oDlg:AddFastKey( VK_F4, {|| DBDelRec(oBrw2, dbfTmp1 ) } )
      oDlg:AddFastKey( VK_F5, {|| if( EndTrans( aBlank, oGet, aoGet, nMode, oBrw2, oBrw3 ), ( WinGather( aBlank, aoGet, dbfPromoT, oBrw, nMode ), oDlg:end( IDOK ) ), ) } )
   end if

   oDlg:AddFastKey( VK_F1,    {|| ChmHelp ("Promociones") } )
   oDlg:bStart             := {|| EvalGet( aoGet, nMode ), oGet:SetFocus(), SetNumDay( aBlank, oTxt ) }

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Static Function SetNumDay( aBlank, oText )

   local dFecIni  := aBlank[ ( dbfPromoT )->( FieldPos( "DINIPRO" ) ) ]
   local dFecFin  := aBlank[ ( dbfPromoT )->( FieldPos( "DFINPRO" ) ) ]

   if dFecFin >= dFecIni
      oText:SetText( Trans( dFecFin - dFecIni, "@E 999,999" ) + " dias" )
      Return .t.
   end if

	msgStop( "La fecha final debe ser mayor que la inicial." )

Return .f.

//--------------------------------------------------------------------------//

STATIC FUNCTION BeginTrans( aBlank, nMode )

   local cDbf1    := "TProL"
   local cDbf2    := "TProC"
	local cCodPro	:= aBlank[ ( dbfPromoT )->( FieldPos( "CCODPRO" ) ) ]

   cNewFile1      := cGetNewFileName( cPatTmp() + cDbf1 )
   cNewFile2      := cGetNewFileName( cPatTmp() + cDbf2 )

	/*
	Primero Crear la base de datos local
	*/

   dbCreate( cNewFile1, aSqlStruct( aColPrm() ), cLocalDriver() )

   dbUseArea( .t., cLocalDriver(), cNewFile1, cCheckArea( cDbf1, @dbfTmp1 ), .f. )
   if !( dbfTmp1 )->( neterr() )

      ( dbfTmp1 )->( ordCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmp1 )->( ordCreate( cNewFile1, "Recno", "Recno()", {|| Recno() } ) )

      /*
      A¤adimos desde el fichero de lineas
      */

      if nMode != APPD_MODE

         if ( dbfPromoL )->( dbSeek( cCodPro ) )

            while ( ( dbfPromoL )->CCODPRO == cCodPro .AND. !( dbfPromoL )->( Eof() ) )

               dbPass( dbfPromoL, dbfTmp1, .t. )
               ( dbfPromoL )->( DbSkip() )

            end while

         end if

      end if

      ( dbfTmp1 )->( dbGoTop() )

   end if

   dbCreate( cNewFile2, aSqlStruct( aCliPrm() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cNewFile2, cCheckArea( cDbf2, @dbfTmp2 ), .f. )
   if !( dbfTmp2 )->( neterr() )

      ( dbfTmp2 )->( ordCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmp2 )->( ordCreate( cNewFile2, "Recno", "Recno()", {|| Recno() } ) )

      /*
      A¤adimos desde el fichero de lineas
      */

      if ( dbfPromoC)->( dbSeek( cCodPro ) )

         while ( ( dbfPromoC )->CCODPRO == cCodPro .AND. !( dbfPromoC )->( Eof() ) )

            dbPass( dbfPromoC, dbfTmp2, .t. )
            ( dbfPromoC )->( DbSkip() )

         end while

      end if

      ( dbfTmp2 )->( dbGoTop() )

   end if

RETURN NIL

//-----------------------------------------------------------------------//

STATIC FUNCTION EndTrans( aBlank, oGet, aoGet, nMode, oBrw2, oBrw3 )

   local oBlock
   local oError
	local cCodPro	:= aBlank[ ( dbfPromoT )->( FieldPos( "CCODPRO" ) ) ]

   if nMode == APPD_MODE

      if Empty( aBlank[ (dbfPromoT)->( FieldPos( "CCODPRO" ) ) ] )
         msgStop( "Código de promoción no puede estar vacio" )
         oGet:SetFocus()
         return .f.
      end if

      if Empty( aBlank[ (dbfPromoT)->( FieldPos( "CNOMPRO" ) ) ] )
         msgStop( "Nombre de promoción no puede estar vacio" )
         aoGet[ (dbfPromoT)->( FieldPos( "CNOMPRO" ) ) ]:SetFocus()
         return .f.
      end if

      if Empty( aBlank[ (dbfPromoT)->( FieldPos( "CCODTAR" ) ) ] )
         msgStop( "Código de tarifa no puede estar vacio" )
         oGet:SetFocus()
         return .f.
      end if

      if Empty( aBlank[ (dbfPromoT)->( FieldPos( "CCODART" ) ) ] )
         msgStop( "Código de artículo no puede estar vacio" )
         aoGet[ (dbfPromoT)->( FieldPos( "CCODART" ) ) ]:SetFocus()
         return .f.
      end if

      if dbSeekInOrd( aBlank[ (dbfPromoT)->( FieldPos( "CCODPRO" ) ) ], "CCODPRO", dbfPromoT )
         MsgStop( "Código ya existe " + Rtrim( aBlank[ (dbfPromoT)->( FieldPos( "CCODPRO" ) ) ] ) )
         return .f.
      end if

   end if

   CursorWait()

   oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   BeginTransaction()

	/*
   Roll Back-------------------------------------------------------------------
	*/

   while ( dbfPromoL )->( dbSeek( cCodPro ) ) .and. !( dbfPromoL )->( eof() )
      if dbLock( dbfPromoL )
         ( dbfPromoL )->( dbDelete() )
         ( dbfPromoL )->( dbUnLock() )
      end if
   end while

   while ( dbfPromoC )->( dbSeek( cCodPro ) ) .and. !( dbfPromoC )->( eof() )
      if dbLock( dbfPromoC )
         ( dbfPromoC )->( dbDelete() )
         ( dbfPromoC )->( dbUnLock() )
      end if
   end while

	/*
   Ahora escribimos en el fichero definitivo-----------------------------------
	*/

	( dbfTmp1 )->( DbGoTop() )
   while ( dbfTmp1 )->( !Eof() )
      dbPass( dbfTmp1, dbfPromoL, .t. )
		( dbfTmp1 )->( dbSkip() )
   end while

	( dbfTmp2 )->( DbGoTop() )
   while ( dbfTmp2 )->( !Eof() )
      dbPass( dbfTmp2, dbfPromoC, .t. )
		( dbfTmp2 )->( dbSkip() )
   end while

   /*
   Escribe los datos pendientes------------------------------------------------
   */

   dbCommitAll()

   CommitTransaction()

   RECOVER USING oError

   RollBackTransaction()
   msgStop( "Imposible actualizar bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE
   ErrorBlock( oBlock )

   /*
	Borramos los ficheros
	*/

   KillTrans()

   CursorWe()

RETURN .t.

//------------------------------------------------------------------------//

STATIC FUNCTION KillTrans()

	/*
	Borramos los ficheros
	*/

	( dbfTmp1 )->( dbCloseArea() )
	( dbfTmp2 )->( dbCloseArea() )

   dbfErase( cNewFile1 )
   dbfErase( cNewFile2 )

RETURN .T.

//------------------------------------------------------------------------//

STATIC FUNCTION OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   USE ( cPatArt() + "PROMOT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROMOT", @dbfPromoT ) )
   SET ADSINDEX TO ( cPatArt() + "PROMOT.CDX" ) ADDITIVE

   USE ( cPatArt() + "PROMOL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROMOL", @dbfPromoL ) )
   SET ADSINDEX TO ( cPatArt() + "PROMOL.CDX" ) ADDITIVE

   USE ( cPatArt() + "PROMOC.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROMOL", @dbfPromoC ) )
   SET ADSINDEX TO ( cPatArt() + "PROMOC.CDX" ) ADDITIVE

   USE ( cPatArt() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
   SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

   USE ( cPatCli() + "AGENTES.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AGENTES", @dbfAgentes ) )
   SET ADSINDEX TO ( cPatCli() + "AGENTES.CDX" ) ADDITIVE

   USE ( cPatCli() + "CLIENT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIENT", @dbfClient ) )
   SET ADSINDEX TO ( cPatCli() + "CLIENT.CDX" ) ADDITIVE

   USE ( cPatArt() + "TARPRET.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TARPRET", @dbfTarPreT ) )
   SET ADSINDEX TO ( cPatArt() + "TARPRET.CDX" ) ADDITIVE

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles()

   if dbfPromoT != nil
		( dbfPromoT )->( dbCloseArea() )
   end if

   if dbfPromoL != nil
      ( dbfPromoL )->( dbCloseArea() )
   end if

   if dbfPromoC != nil
      ( dbfPromoC )->( dbCloseArea() )
   end if

   if dbfArticulo != nil
      ( dbfArticulo )->( dbCloseArea() )
   end if

   if dbfAgentes != nil
      ( dbfAgentes )->( dbCloseArea() )
   end if

   if dbfClient != nil
      ( dbfClient )->( dbCloseArea() )
   end if

   if dbfTarPreT != nil
      ( dbfTarPreT )->( dbCloseArea() )
   end if

   dbfPromoT   := nil
   dbfPromoL   := nil
   dbfPromoC   := nil
   dbfArticulo := nil
   dbfAgentes  := nil
   dbfClient   := nil
   dbfTarPreT  := nil

RETURN ( .T. )

//----------------------------------------------------------------------------//

FUNCTION mkPromo( cPath, lAppend, cPathOld, oMeter )

   local dbfPrm
   local oldPrm

   DEFAULT lAppend   := .f.
   DEFAULT cPath     := cPatArt()

   if !lExistTable( cPath + "PROMOT.DBF" )
      dbCreate( cPath + "PROMOT.DBF", aSqlStruct( aItmPrm() ), cDriver() )
   end if 

   if !lExistTable( cPath + "PROMOL.DBF" )
      dbCreate( cPath + "PROMOL.DBF", aSqlStruct( aColPrm() ), cDriver() )
   end if 
   
   if !lExistTable( cPath + "PROMOC.DBF" )
      dbCreate( cPath + "PROMOC.DBF", aSqlStruct( aCliPrm() ), cDriver() )
   end if 

   RxPromo( cPath, oMeter )

   if lAppend .and. lIsDir( cPathOld )

      dbUseArea( .t., cDriver(), cPath + "PROMOT.DBF", cCheckArea( "PROMOT", @dbfPrm ), .f. )
      ordListAdd( cPath + "PROMOT.CDX"  )

      dbUseArea( .t., cDriver(), cPathOld + "PROMOT.DBF", cCheckArea( "PROMOT", @oldPrm ), .f. )
      ordListAdd( cPathOld + "PROMOT.CDX"  )

      while !( oldPrm )->( Eof() )
         dbCopy( oldPrm, dbfPrm, .t. )
         ( oldPrm )->( dbSkip() )
      end while

      ( dbfPrm )->( dbCloseArea() )
      ( oldPrm )->( dbCloseArea() )

      // Lineas

      dbUseArea( .t., cDriver(), cPath + "PROMOL.DBF", cCheckArea( "PROMOL", @dbfPrm ), .f. )
      ordListAdd( cPath + "PROMOL.CDX"  )

      dbUseArea( .t., cDriver(), cPathOld + "PROMOL.DBF", cCheckArea( "PROMOL", @oldPrm ), .f. )
      ordListAdd( cPathOld + "PROMOL.CDX"  )

      while !( oldPrm )->( Eof() )
         dbCopy( oldPrm, dbfPrm, .t. )
         ( oldPrm )->( dbSkip() )
      end while

      ( dbfPrm )->( dbCloseArea() )
      ( oldPrm )->( dbCloseArea() )

      // Clientes

      dbUseArea( .t., cDriver(), cPath + "PROMOC.DBF", cCheckArea( "PROMOC", @dbfPrm ), .f. )
      ordListAdd( cPath + "PROMOC.CDX"  )

      dbUseArea( .t., cDriver(), cPathOld + "PROMOC.DBF", cCheckArea( "PROMOC", @oldPrm ), .f. )
      ordListAdd( cPathOld + "PROMOC.CDX"  )

      while !( oldPrm )->( Eof() )
         dbCopy( oldPrm, dbfPrm, .t. )
         ( oldPrm )->( dbSkip() )
      end while

      ( dbfPrm )->( dbCloseArea() )
      ( oldPrm )->( dbCloseArea() )

   end if

RETURN ( nil )

//----------------------------------------------------------------------------//

FUNCTION rxPromo( cPath, oMeter )

   DEFAULT cPath := cPatArt()

   if !lExistTable( cPath + "PROMOT.DBF" )
      dbCreate( cPath + "PROMOT.DBF", aSqlStruct( aItmPrm() ), cDriver() )
   end if

   if !lExistTable( cPath + "PROMOL.DBF" )
      dbCreate( cPath + "PROMOL.DBF", aSqlStruct( aColPrm() ), cDriver() )
   end if

   if !lExistTable( cPath + "PROMOC.DBF" )
      dbCreate( cPath + "PROMOC.DBF", aSqlStruct( aCliPrm() ), cDriver() )
   end if

   fEraseIndex( cPath + "PROMOT.CDX" )
   fEraseIndex( cPath + "PROMOL.CDX" )
   fEraseIndex( cPath + "PROMOC.CDX" )

   USE ( cPath + "PROMOT.DBF" ) NEW VIA ( cDriver() )ALIAS ( cCheckArea( "PROMOT", @dbfPromoT ) ) EXCLUSIVE
   if !( dbfPromoT )->( neterr() )
      ( dbfPromoT )->( __dbPack() )

      ( dbfPromoT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPromoT )->( ordCreate( cPath + "PROMOT.CDX", "CCODPRO", "Field->CCODPRO", {|| Field->CCODPRO } ) )

      ( dbfPromoT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPromoT )->( ordCreate( cPath + "PROMOT.CDX", "CNOMPRO", "Field->CNOMPRO", {|| Field->CNOMPRO } ) )

      ( dbfPromoT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPromoT )->( ordCreate( cPath + "PROMOT.CDX", "CCODTAR", "Field->CCODTAR + Field->CCODART", {|| Field->CCODTAR + Field->CCODART } ) )

      ( dbfPromoT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPromoT )->( ordCreate( cPath + "PROMOT.CDX", "CCODART", "Field->CCODART", {|| Field->CCODART } ) )

      ( dbfPromoT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de promociones" )
   end if

   USE ( cPath + "PROMOL.DBF" ) NEW VIA ( cDriver() )ALIAS ( cCheckArea( "PROMOL", @dbfPromoL ) ) EXCLUSIVE
   if !( dbfPromoL )->( neterr() )
      ( dbfPromoL )->( __dbPack() )

      ( dbfPromoL )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPromoL )->( ordCreate( cPath + "PROMOL.CDX", "CCODPRO", "Field->CCODPRO", {|| Field->CCODPRO } ) )

      ( dbfPromoL )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPromoL )->( ordCreate( cPath + "PROMOL.CDX", "CCODTAR", "Field->CCODPRO + Field->CCODAGE", {|| Field->CCODPRO + Field->CCODAGE } ) )

      ( dbfPromoL )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de promociones" )
   end if

   USE ( cPath + "PROMOC.DBF" ) NEW VIA ( cDriver() )ALIAS ( cCheckArea( "PROMOC", @dbfPromoC ) ) EXCLUSIVE
   if !( dbfPromoC )->( neterr() )
      ( dbfPromoC )->( __dbPack() )

      ( dbfPromoC )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPromoC )->( ordCreate( cPath + "PROMOC.CDX", "CCODPRO", "Field->CCODPRO", {|| Field->CCODPRO } ) )

      ( dbfPromoC )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPromoC )->( ordCreate( cPath + "PROMOC.CDX", "CCODCLI", "Field->CCODPRO + Field->CCODCLI + Field->CCODOBR", {|| Field->CCODPRO + Field->CCODCLI + Field->CCODOBR } ) )

      ( dbfPromoC )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de promociones" )
   end if

RETURN NIL

//--------------------------------------------------------------------------//
/*
Funcion Auxiliar para borrar las Lineas de Detalle en un pedido
*/

STATIC FUNCTION DelDeta( oBrw, dbfTmp )

RETURN DBDelRec( oBrw, dbfTmp )

//--------------------------------------------------------------------------//

/*
Edita las lineas de Detalle
*/

STATIC FUNCTION EdtDet( aBlank, aoGet, dbfPromoL, oBrw, bWhen, bValid, nMode, cCodPro )

	local oDlg
	local oGet
	local oGetTxt
	local cGetTxt

	IF nMode == APPD_MODE
		aBlank[ (dbfPromoL)->( FieldPos( "CCODPRO" ) ) ] := cCodPro
	END CASE

   DEFINE DIALOG oDlg RESOURCE "LPROMO" TITLE LblTitle( nMode ) + "lineas de promociones"

		REDEFINE GET oGet VAR aBlank[ (dbfPromoL)->( FieldPos( "CCODAGE" ) ) ];
			ID 		100 ;
			WHEN 		( nMode == APPD_MODE ) ;
			VALID		( cAgentes( oGet, , oGetTxt ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAgentes( oGet, oGetTxt ) ) ;
			OF 		oDlg

		REDEFINE GET oGetTxt VAR cGetTxt;
			ID 		105 ;
         WHEN     ( .f. ) ;
			OF 		oDlg

		REDEFINE GET aBlank[ (dbfPromoL)->( FieldPos( "NDTOAGE" ) ) ];
			ID 		110 ;
			SPINNER ;
			PICTURE	"@E 99.99" ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( EndAge( aBlank, aoGet, dbfTmp1, oBrw, nMode, oGet, oDlg )  )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

      REDEFINE BUTTON ;
         ID       9 ;
			OF 		oDlg ;
         ACTION   ( ChmHelp ("Promociones") )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| If ( IsAge( aBlank, nMode, dbfTmp1 ), ( WinGather( aBlank, aoGet, dbfTmp1, oBrw, nMode ), oDlg:end() ), ) } )
   end if

   oDlg:AddFastKey ( VK_F1, {|| ChmHelp ("Promociones") } )

   ACTIVATE DIALOG oDlg ON PAINT ( oGet:lValid() ) CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Static Function EndAge( aBlank, aoGet, dbfTmp1, oBrw, nMode, oGet, oDlg )

   if nMode == APPD_MODE
      if Empty( aBlank[ (dbfPromoL)->( FieldPos( "CCODAGE" ) ) ] )
         MsgStop( "Código no puede estar vacío" )
         oGet:SetFocus()
         return nil
      end if
   end if

   If IsAge( aBlank, nMode, dbfTmp1 )
      WinGather( aBlank, aoGet, dbfTmp1, oBrw, nMode )
   end if

Return ( oDlg:end( IDOK ) )

//--------------------------------------------------------------------------//

STATIC FUNCTION EdtCli( aBlank, aoGet, dbfPromoC, oBrw, bWhen, bValid, nMode, cCodPro )

	local oDlg
	local oGet
	local oGet2
	local oGetTxt
	local cGetTxt
	local oGetTxt2
	local cGetTxt2

	IF nMode == APPD_MODE
		aBlank[ (dbfPromoC)->( FieldPos( "CCODPRO" ) ) ] := cCodPro
	END CASE

   DEFINE DIALOG oDlg RESOURCE "LPROMOC" TITLE LblTitle( nMode ) + "clientes y obras en promociones"

		REDEFINE GET oGet VAR aBlank[ (dbfPromoC)->( FieldPos( "CCODCLI" ) ) ];
			ID 		100 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			VALID		( cClient( oGet, , oGetTxt ) ) ;
         BITMAP   "LUPA" ;
			ON HELP	( BrwClient( oGet, oGetTxt ) ) ;
			COLOR 	CLR_GET ;
			OF 		oDlg

		REDEFINE GET oGetTxt VAR cGetTxt;
			ID 		105 ;
			WHEN 		( .F. ) ;
			COLOR 	CLR_GET ;
			OF 		oDlg

      REDEFINE GET oGet2 VAR aBlank[ (dbfPromoC)->( FieldPos( "CCODOBR" ) ) ];
			ID 		110 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			VALID 	( cObras( oGet2, oGetTxt2, aBlank[ (dbfPromoC)->( FieldPos( "CCODCLI" ) ) ] ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwObras( oGet2, oGetTxt2, aBlank[ (dbfPromoC)->( FieldPos( "CCODCLI" ) ) ] ) ) ;
			COLOR 	CLR_GET ;
			OF 		oDlg

		REDEFINE GET oGetTxt2 VAR cGetTxt2;
			ID 		115 ;
			WHEN 		( .F. ) ;
			COLOR 	CLR_GET ;
			OF 		oDlg

		REDEFINE GET aBlank[ (dbfPromoC)->( FieldPos( "NDTOPRO" ) ) ];
			ID 		120 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			SPINNER ;
			PICTURE	"@E 999.99" ;
			COLOR 	CLR_GET ;
			OF 		oDlg

		REDEFINE GET aBlank[ (dbfPromoC)->( FieldPos( "NCOMAGE" ) ) ];
			ID 		130 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			SPINNER ;
			PICTURE	"@E 999.99" ;
			COLOR 	CLR_GET ;
			OF 		oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( EndTransCli( aBlank, dbfTmp2, oBrw, nMode, oDlg, oGet ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

      REDEFINE BUTTON ;
         ID       9 ;
			OF 		oDlg ;
         ACTION   ( ChmHelp ("Promociones") )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| EndTransCli( aBlank, dbfTmp2, oBrw, nMode, oDlg, oGet ) } )
   end if

   oDlg:AddFastKey ( VK_F1, {|| ChmHelp ("Promociones") } )

   ACTIVATE DIALOG oDlg ON PAINT ( oGet:lValid(), oGet2:lValid() ) CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Static Function EndTransCli( aBlank, dbfTmp2, oBrw, nMode, oDlg, oGet )

   if nMode == APPD_MODE
      if Empty( aBlank[ (dbfPromoC)->( FieldPos( "CCODCLI" ) ) ] )
         MsgStop( "Código no puede estar vacío" )
         oGet:SetFocus()
         return nil
      end if
   end if

   WinGather( aBlank, , dbfTmp2, oBrw, nMode )

Return ( oDlg:end( IDOK ) )

//--------------------------------------------------------------------------//

FUNCTION cPromo( oGet, dbfPromoT, oGet2 )

	local cAreaAnt := Alias()
	local lValid 	:= .F.
	local lClose 	:= .F.
	local xValor 	:= oGet:varGet()

	IF Empty( xValor )
		RETURN .T.
	END IF

	IF (dbfPromoT) == NIL

      IF !OpenFiles()
         RETURN .t.
      END IF

		lClose	:= .T.

	END IF

	xValor	:= Rjust( xValor, "0", 3 )

	IF (dbfPromoT)->( DbSeek( xValor ) )

		oGet:varPut( (dbfPromoT)->CCODPRO )
		oGet:refresh()

		IF oGet2 != NIL
			oGet2:varPut( (dbfPromoT)->CNOMPRO )
			oGet2:refresh()
		END IF

		lValid 	:= .T.

	ELSE

		msgStop( "Promoci¢n no encontrada" )

	END IF

	IF lClose

		CloseFiles()

	END IF

	IF cAreaAnt != ""

		SELECT( cAreaAnt )

	END IF

RETURN lValid

//---------------------------------------------------------------------------//

FUNCTION retPromo( cCodPro, dbfPromoT )

	local lClose 	:= .F.
	local cAreaAnt := Alias()
	local cTemp		:= Space( 30 )

	IF ( dbfPromoT ) == NIL

      IF !OpenFiles()
         RETURN cTemp
      END IF

		lClose	:= .T.

	END IF

	IF ( dbfPromoT )->( DbSeek( cCodPro ) )
		cTemp := (dbfPromoT)->CNOMPRO
	END IF

	IF lClose
		CloseFiles()
	END IF

	IF cAreaAnt != ""
		SELECT( cAreaAnt )
	END IF

RETURN cTemp

//---------------------------------------------------------------------------//

FUNCTION BrwPromo( oGet, dbfPromoT, oGet2 )

	local oDlg
	local oBrw
	local oGet1
	local cGet1
   local nOrd        := GetBrwOpt( "BrwPromo" )
	local oCbxOrd
   local aCbxOrd     := { "Código", "Nombre" }
   local cCbxOrd
   local lClose      := .f.
   local nLevelUsr   := Auth():Level( "01021" )

   nOrd              := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd           := aCbxOrd[ nOrd ]

   if ( dbfPromoT ) == nil

      if !OpenFiles()
         return .f.
      end if

      lClose         := .t.

   end if

   nOrd              := ( dbfPromoT )->( OrdSetFocus( nOrd ) )

   ( dbfPromoT )->( dbGoTop() )

	DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Promociones"

		REDEFINE GET oGet1 VAR cGet1;
         ID       104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfPromoT ) );
         VALID    ( OrdClearScope( oBrw, dbfPromoT ) );
         BITMAP   "FIND" ;
         OF       oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    aCbxOrd ;
			ON CHANGE( ( dbfPromoT )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:refresh(), oGet1:SetFocus() ) ;
			OF 		oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfPromoT
      oBrw:nMarqueeStyle   := 5

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }

      oBrw:CreateFromResource( 105 )

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodPro"
         :bEditValue       := {|| ( dbfPromoT )->cCodPro }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomPro"
         :bEditValue       := {|| ( dbfPromoT )->cNomPro }
         :nWidth           := 400
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

		REDEFINE BUTTON ;
         ID IDOK ;
			OF oDlg ;
         ACTION ( oDlg:end(IDOK) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         ACTION   ( oDlg:end() )

		REDEFINE BUTTON ;
         ID       500 ;
         OF       oDlg ;
         WHEN     nLevelUsr <= 1 ;
         ACTION   ( WinAppRec( oBrw, bEdit1, dbfPromoT ) )

		REDEFINE BUTTON ;
         ID       501 ;
         OF       oDlg ;
         WHEN     nLevelUsr <= 2 ;
         ACTION   ( WinEdtRec( oBrw, bEdit1, dbfPromoT ) )

   ACTIVATE DIALOG oDlg CENTER

   DestroyFastFilter( dbfPromoT )

   SetBrwOpt( "BrwPromo", ( dbfPromoT )->( OrdNumber() ) )

   If oDlg:nResult == IDOK

      oGet:cText( ( dbfPromoT )->CCODPRO )

		IF oGet2 != NIL
         oGet2:cText( ( dbfPromoT )->CNOMPRO )
		END IF

	End if

	IF lClose
		CloseFiles()
	ELSE
      ( dbfPromoT )->( OrdSetFocus( nOrd ) )
	END IF

	oGet:setFocus()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

/*
Comprueba si un agente esta en la promoci¢n
*/

STATIC FUNCTION IsAge( aBlank, nMode, dbfTmp )

	local lReturn 	:= .t.
	local nRecNo	:= ( dbfTmp )->( RecNo() )
	local cTarget 	:= aBlank[ (dbfPromoL)->( FieldPos( "CCODAGE" ) ) ]

	IF nMode == APPD_MODE

		( dbfTmp )->( dbGoTop() )

		WHILE !( dbfTmp )->( Eof() )

			IF ( dbfTmp )->CCODAGE == cTarget
				msgStop( "Ya existe este agente en promoci¢n" )
				lReturn := .f.
				EXIT
			END IF

			( dbfTmp )->( dbSkip() )

		END DO

		( dbfTmp )->( dbGoTo( nRecNo ) )

	END IF

RETURN lReturn

//--------------------------------------------------------------------------//

FUNCTION aItmPrm()

   local aItmPrm  := {}

   aAdd( aItmPrm, { "cCodPro",   "C",    5,    0, "Código de la promoción"  } )
   aAdd( aItmPrm, { "cNomPro",   "C",   25,    0, "Nombre de la promoción"  } )
   aAdd( aItmPrm, { "cCodTar",   "C",    5,    0, "Código de la tarifa"     } )
   aAdd( aItmPrm, { "cCodArt",   "C",   18,    0, "Código del artículo"     } )
   aAdd( aItmPrm, { "dIniPro",   "D",    8,    0, "Fecha inicio promoción"  } )
   aAdd( aItmPrm, { "dFinPro",   "D",    8,    0, "Fecha fin promoción"     } )
   aAdd( aItmPrm, { "nDtoPro",   "N",    5,    2, "Porcentaje de descuento" } )

RETURN ( aItmPrm )

//---------------------------------------------------------------------------//

FUNCTION aColPrm()

   local aColPrm  := {}

   aAdd( aColPrm, { "CCODPRO",   "C",    5,    0, "Código de la promoción"          } )
   aAdd( aColPrm, { "CCODAGE",   "C",    3,    0, "Código del agente"               } )
   aAdd( aColPrm, { "NDTOAGE",   "N",    5,    2, "Descuento promoción del agente"  } )

RETURN ( aColPrm )

//---------------------------------------------------------------------------//

FUNCTION aCliPrm()

   local aCliPrm  := {}

   aAdd( aCliPrm, { "CCODPRO",   "C",    5,    0, "Código de la promoción" }  )
   aAdd( aCliPrm, { "CCODCLI",   "C",   12,    0, "Código del cliente" }      )
   aAdd( aCliPrm, { "CCODOBR",   "C",   10,    0, "Código de la dirección" }       )
   aAdd( aCliPrm, { "NDTOPRO",   "N",    5,    2, "" }                        )
   aAdd( aCliPrm, { "NCOMAGE",   "N",    5,    2, "" }                        )

RETURN ( aCliPrm )

//---------------------------------------------------------------------------//