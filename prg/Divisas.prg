#ifndef __PDA__
#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "Report.ch"
#else
#include "FWCE.ch"
REQUEST DBFCDX
#endif

#define _CCODDIV                   1   //( dbfDiv )->( FieldPos( "cCodDiv" ) )
#define _CNOMDIV                   2   //( dbfDiv )->( FieldPos( "cNomDiv" ) )
#define _DACTDIV                   3   //( dbfDiv )->( FieldPos( "dActDiv" ) )
#define _NPTSDIV                   4   //( dbfDiv )->( FieldPos( "nPtsDiv" ) )
#define _NEURDIV                   5   //( dbfDiv )->( FieldPos( "nEurDiv" ) )
#define _NNINDIV                   6   //( dbfDiv )->( FieldPos( "nNinDiv" ) )
#define _NDINDIV                   7   //( dbfDiv )->( FieldPos( "nDinDiv" ) )
#define _NRINDIV                   8   //( dbfDiv )->( FieldPos( "nRinDiv" ) )
#define _NNOUDIV                   9   //( dbfDiv )->( FieldPos( "nNouDiv" ) )
#define _NDOUDIV                  10   //( dbfDiv )->( FieldPos( "nDouDiv" ) )
#define _NROUDIV                  11   //( dbfDiv )->( FieldPos( "nRouDiv" ) )
#define _NNPVDIV                  12   //( dbfDiv )->( FieldPos( "nNpvDiv" ) )
#define _NDPVDIV                  13   //( dbfDiv )->( FieldPos( "nDpvDiv" ) )
#define _NRPVDIV                  14   //( dbfDiv )->( FieldPos( "nRpvDiv" ) )
#define _NNWBDIV                  15
#define _NDWBDIV                  16
#define _NRWBDIV                  17
#define _CBNDDIV                  18   //( dbfDiv )->( FieldPos( "cBndDiv" ) )
#define _CSMBDIV                  19   //( dbfDiv )->( FieldPos( "cSmbDiv" ) )
#define _LCTRDIV                  20   //( dbfDiv )->( FieldPos( "lCtrDiv" ) )
#define _LMASDIV                  21   //( dbfDiv )->( FieldPos( "lMasDiv" ) )

#ifndef __PDA__

static bEdit   := { |aTemp, aoGet, dbfDiv, oBrw, bWhen, bValid, nMode, oBan | EdtRec( aTemp, aoGet, dbfDiv, oBrw, bWhen, bValid, nMode, oBan ) }

#endif

static dbfDiv

static oWndBrw
static cCodBuf
static cPouDiv
static aDivBuf
static cPpvDiv
static cPinDiv
static cPirDiv
static cPorDiv
static cPwbDiv
static cPwrDiv
static nEurDiv
static nPtsDiv
static nDouDiv

//---------------------------------------------------------------------------//
//Funciones del programa
//---------------------------------------------------------------------------//

#ifndef __PDA__

FUNCTION Divisas( oMenuItem, oWnd )

   local nLevel
   local oBandera

   DEFAULT  oMenuItem   := "01039"
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

      if !OpenFiles()
         return nil
      end if

      oBandera          := TBandera():New()

      /*
      Anotamos el movimiento para el navegador
      */

      AddMnuNext( "Divisas monetarias", ProcName() )

      DEFINE SHELL oWndBrw FROM 2, 10 TO 18, 70 ;
         XBROWSE ;
         TITLE    "Tipos de divisas" ;
         PROMPT   "Código" ,;
                  "Nombre" ;
         MRU      "gc_currency_euro_16" ;
         BITMAP   clrTopArchivos ;
         ALIAS    ( dbfDiv );
         APPEND   WinAppRec( oWndBrw:oBrw, bEdit, dbfDiv, nil, nil, oBandera ) ;
         EDIT     WinEdtRec( oWndBrw:oBrw, bEdit, dbfDiv, nil, nil, oBandera ) ;
         DELETE   WinDelRec( oWndBrw:oBrw, dbfDiv ) ;
         DUPLICAT WinDupRec( oWndBrw:oBrw, bEdit, dbfDiv, nil, nil, oBandera ) ;
         LEVEL    nLevel ;
			OF 		oWnd

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCdoDiv"
         :bEditValue       := {|| ( dbfDiv )->cCodDiv }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomDiv"
         :bEditValue       := {|| ( dbfDiv )->cNomDiv }
         :nWidth           := 200
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Valor en pesetas"
         :bEditValue       := {|| Trans( ( dbfDiv )->nPtsDiv, "@E 999,999.999999") }
         :nWidth           := 90
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Valor en euros"
         :bEditValue       := {|| Trans( ( dbfDiv )->nEurDiv, "@E 999,999.999999") }
         :nWidth           := 90
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Simbolo"
         :bEditValue       := {|| ( dbfDiv )->cSmbDiv }
         :nWidth           := 50
      end with

      oWndBrw:lAutoPos     := .f.
      oWndBrw:cHtmlHelp    := "Divisas"

      oWndBrw:CreateXFromCode()

      DEFINE BTNSHELL RESOURCE "BUS" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:SearchSetFocus() ) ;
			TOOLTIP 	"(B)uscar" ;
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
         ACTION   ( WinZooRec( oWndBrw:oBrw, bEdit, dbfDiv, nil, nil, oBandera ) );
         TOOLTIP  "(Z)oom";
         HOTKEY   "Z";
         LEVEL    ACC_ZOOM

		DEFINE BTNSHELL RESOURCE "DEL" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:RecDel() );
         TOOLTIP  "(E)liminar";
         HOTKEY   "E";
         LEVEL    ACC_DELE

#ifndef __TACTIL__

      DEFINE BTNSHELL RESOURCE "IMP" OF oWndBrw ;
			NOBORDER ;
         ACTION  ( InfDiv():New( "Listado de divisas" ):Play(), oWndBrw:Maximize() ) ;
         TOOLTIP  "(L)istado";
         HOTKEY   "L";
         LEVEL    ACC_IMPR

#endif

      DEFINE BTNSHELL RESOURCE "END" GROUP OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:End() ) ;
         TOOLTIP  "(S)alir";
         HOTKEY   "S"

      ACTIVATE WINDOW oWndBrw VALID ( CloseFiles() )

	ELSE

		oWndBrw:SetFocus()

	END IF

RETURN NIL

//----------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aTmp, aoGet, dbfDiv, oBrw, bWhen, bValid, nMode, oBandera )

	local oDlg
	local oGetCod
   local oGet2
	local oCmb
	local cCmb

   /*
	Cargamos las banderas
	*/

   cCmb           := oBandera:cBandera( aTmp[ _CBNDDIV ] )

   DEFINE DIALOG oDlg RESOURCE "DIVISAS" TITLE LblTitle( nMode ) + "Divisas"

      REDEFINE GET oGetCod VAR aTmp[ _CCODDIV ];
			ID 		110 ;
			PICTURE	"@!" ;
         WHEN     ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) ;
			VALID 	( NotValid( oGetCod, dbfDiv ) ) ;
			COLOR 	CLR_GET ;
			OF 		oDlg

      REDEFINE GET oGet2 VAR aTmp[_CNOMDIV] ;
			ID 		120 ;
			COLOR 	CLR_GET ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET aTmp[_NPTSDIV] ;
			ID 		130 ;
         PICTURE  "@E 999,999.999999";
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			OF 		oDlg

      REDEFINE GET aTmp[ _NEURDIV ] ;
			ID 		140 ;
         PICTURE  "@E 999,999.999999";
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET aoGet[ _DACTDIV ] ;
         VAR      aTmp[ _DACTDIV ] ;
         ID       150 ;
         ON HELP  aoGet[_DACTDIV]:cText( Calendario( aTmp[_DACTDIV] ) ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aTmp[_CSMBDIV] ;
			ID 		160 ;
			COLOR 	CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

		/*
		Bandera_________________________________________________________________
		*/

		REDEFINE COMBOBOX oCmb VAR cCmb;
			ID			170;
			OF 		oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ITEMS    oBandera:aNomBan ;
         BITMAPS  oBandera:aResBan

      REDEFINE CHECKBOX aTmp[_LMASDIV] ;
         ID        270 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF        oDlg

		/*
		Divisas de Compras______________________________________________________
		*/

      REDEFINE GET aTmp[_NNINDIV] ;
			ID 		180 ;
			SPINNER 	MIN 1 MAX 12;
			PICTURE 	"99" ;
         VALID    ( aTmp[_NNINDIV] >= 1 .AND. aTmp[_NNINDIV] <= 12 );
			COLOR 	CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET aTmp[_NDINDIV] ;
			ID 		190 ;
         SPINNER  MIN 0 MAX 6;
			PICTURE 	"9" ;
         VALID    ( aTmp[_NDINDIV] >= 0 .AND. aTmp[_NDINDIV] <= 6 );
			COLOR 	CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET aTmp[_NRINDIV] ;
         ID        200 ;
         SPINNER   MIN 0 MAX 6;
         PICTURE   "9" ;
         VALID     ( aTmp[ _NRINDIV ] >= 0 .AND. aTmp[ _NRINDIV ] <= 6 );
         COLOR     CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF        oDlg

		/*
		Divisas de Ventas______________________________________________________
		*/

      REDEFINE GET aTmp[_NNOUDIV] ;
         ID        210 ;
         SPINNER   MIN 1 MAX 12;
         PICTURE   "99" ;
         VALID     ( aTmp[_NNOUDIV] >= 1 .AND. aTmp[_NNOUDIV] <= 12 );
         COLOR     CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF        oDlg

      REDEFINE GET aTmp[_NDOUDIV] ;
         ID        220 ;
         SPINNER   MIN 0 MAX 6;
         PICTURE   "9" ;
         VALID     ( aTmp[_NDOUDIV] >= 0 .AND. aTmp[_NDOUDIV] <= 6 );
         COLOR     CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF        oDlg

      REDEFINE GET aTmp[_NROUDIV] ;
         ID        230 ;
         SPINNER   MIN 0 MAX 6;
         PICTURE   "9" ;
         VALID     ( aTmp[_NROUDIV] >= 0 .AND. aTmp[_NROUDIV] <= 6 );
         COLOR     CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF        oDlg

		/*
      Digitos para punto verde_________________________________________________________________
		*/

      REDEFINE GET aTmp[_NNPVDIV] ;
         ID        240 ;
         SPINNER   MIN 1 MAX 12;
         PICTURE   "99" ;
         VALID     ( aTmp[_NNPVDIV] >= 1 .AND. aTmp[_NNPVDIV] <= 12 );
         COLOR     CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF        oDlg

      REDEFINE GET aTmp[_NDPVDIV] ;
         ID       250 ;
         SPINNER  MIN 0 MAX 6;
         PICTURE  "9" ;
         VALID    ( aTmp[_NDPVDIV] >= 0 .AND. aTmp[_NDPVDIV] <= 6 );
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aTmp[_NRPVDIV] ;
         ID       260 ;
         SPINNER  MIN 0 MAX 6;
         PICTURE  "9" ;
         VALID    ( aTmp[_NRPVDIV] >= 0 .AND. aTmp[_NRPVDIV] <= 6 );
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      /*
      Digitos para punto verde_________________________________________________________________
		*/

      REDEFINE GET aTmp[ _NNWBDIV ] ;
         ID       300 ;
         SPINNER  MIN 1 MAX 12;
         PICTURE  "99" ;
         VALID    ( aTmp[ _NNWBDIV ] >= 1 .AND. aTmp[ _NNWBDIV ] <= 12 );
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aTmp[ _NDWBDIV ] ;
         ID       310 ;
         SPINNER  MIN 0 MAX 6;
         PICTURE  "9" ;
         VALID    ( aTmp[ _NDWBDIV ] >= 0 .AND. aTmp[ _NDWBDIV ] <= 6 );
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aTmp[ _NRWBDIV ] ;
         ID       320 ;
         SPINNER  MIN 0 MAX 6;
         PICTURE  "9" ;
         VALID    ( aTmp[ _NRWBDIV ] >= 0 .AND. aTmp[ _NRWBDIV ] <= 6 );
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

		/*
		Botones_________________________________________________________________
		*/

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( 	nMode != ZOOM_MODE ) ;
         ACTION   (  if( nMode == DUPL_MODE, if( oGetCod:lValid(), lPresave( aTmp, dbfDiv, oBrw, nMode, oCmb, oBandera, oDlg, oGetCod, oGet2 ), ), lPresave( aTmp, dbfDiv, oBrw, nMode, oCmb, oBandera, oDlg, oGetCod, oGet2 ) ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
			ACTION 	( oDlg:end() )


   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| if( nMode == DUPL_MODE, if( oGetCod:lValid(), lPresave( aTmp, dbfDiv, oBrw, nMode, oCmb, oBandera, oDlg, oGetCod, oGet2 ), ), lPresave( aTmp, dbfDiv, oBrw, nMode, oCmb, oBandera, oDlg, oGetCod, oGet2 ) ) } )
   end if

   oDlg:bStart := {|| oGetCod:SetFocus() }

	ACTIVATE DIALOG oDlg ON PAINT ( EvalGet( aoGet, nMode ) ) CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Static Function lPresave( aTmp, dbfDiv, oBrw, nMode, oCmb, oBandera, oDlg, oGetCod, oGet2 )

   if nMode == APPD_MODE .or. nMode == DUPL_MODE

      if Empty( aTmp[_CCODDIV] )
         MsgStop( "El código de la divisa no puede estar vacío" )
         oGetCod:SetFocus()
         Return nil
      end if

      if dbSeekInOrd( aTmp[ _CCODDIV ], "CCODDIV", dbfDiv )
         MsgStop( "Código ya existe " + Rtrim( aTmp[ _CCODDIV ] ) )
         return nil
      end if

   end if

   if Empty( aTmp[_CNOMDIV] )
      MsgStop( "El nombre de la divisa no puede estar vacío" )
      oGet2:SetFocus()
      Return nil
   end if

   aTmp[_CBNDDIV] := oBandera:aResBan[ oCmb:nAt ]

   WinGather( aTmp, nil, dbfDiv, oBrw, nMode )

   aDivBuf( aTmp[ _CCODDIV ], dbfDiv )

Return ( oDlg:end( IDOK ) )

//--------------------------------------------------------------------------//

/*
Comprueba si existe una divisa y devualve la bandera
*/

FUNCTION cDiv( oGet, uBmp, xGetDiv, cPinDiv, nDinDiv, dbfDiv, oBan )

	local cCodDiv	:= oGet:varGet()
	local cAreaAnt := Alias()
   local lValid   := .f.

   if Empty( cCodDiv )
      return .t.
   end if

   if ( dbfDiv )->( dbSeek( cCodDiv ) )

		oGet:cText( cCodDiv )

      if ValType( uBmp ) == "O"
         uBmp:Reload( ( dbfDiv )->cBndDiv )
      elseif ValType( uBmp ) == "N"
         uBmp           := oBan:hBandera( ( dbfDiv )->cBndDiv )
      end if

      if ValType( xGetDiv ) == "O"
         xGetDiv:cText( nValChgDiv( dbfDiv ) )
      elseif ValType( xGetDiv ) == "N"
         xGetDiv  := nValChgDiv( dbfDiv )
      end if

		lValid	:= .T.

		/*
		Picture de la divisa
		*/

      if cPinDiv != NIL
			cPinDiv := cPinDiv( cCodDiv, dbfDiv )
      end if

      if nDinDiv != NIL
         nDinDiv := nDinDiv( cCodDiv, dbfDiv )
      end if

   else

      msgStop( "Divisa no encontrada", cCodDiv )
      lValid      := .f.

   end if

   IF cAreaAnt != ""
		SELECT( cAreaAnt )
	END IF

RETURN lValid

//---------------------------------------------------------------------------//

/*
Comprueba si existe una divisa y devualve el nombre
*/

FUNCTION cNbrDiv( oGet, oGetDiv, dbfDiv )

	local cCodDiv	:= oGet:varGet()
   local lValid   := .f.

   if Empty( cCodDiv )
      return .t.
   end if

   if ( dbfDiv )->( dbSeek( cCodDiv ) )

		oGet:cText( cCodDiv )

      if ValType( oGetDiv ) == "O"
         oGetDiv:cText( ( dbfDiv )->cNomDiv )
      elseif ValType( oGetDiv ) == "N"
         oGetDiv  := ( dbfDiv )->cNomDiv
      end if

      lValid   := .t.
   else
      msgStop( "Divisa no encontrada", cCodDiv )
      lValid   := .f.
   end if

RETURN lValid

//---------------------------------------------------------------------------//

FUNCTION cDivIn( oGet, oBmp, xGetDiv, cPinDiv, nDinDiv, cPirDiv, nDirDiv, oSayMas, dbfDiv, oBan )

   local lValid   := .f.
   local cCodDiv  := oGet:varGet()

   if Empty( cCodDiv )
      cCodDiv     := cDivEmp()
   end if

   if ( dbfDiv )->( dbSeek( cCodDiv ) )

		oGet:cText( cCodDiv )

      if !Empty( oBmp ) .and. !Empty( oBan )
         oBmp:Reload( ( dbfDiv )->cBndDiv )
      end if

      if ValType( xGetDiv ) == "O"
         xGetDiv:cText( nValChgDiv( dbfDiv ) )
      elseif ValType( xGetDiv ) == "N"
         xGetDiv  := nValChgDiv( dbfDiv )
      end if

      lValid      := .T.

		/*
		Picture de la divisa
		*/

      if cPinDiv != nil
         cPinDiv  := cPinDiv( cCodDiv, dbfDiv )
      end if

      if nDinDiv != nil
         nDinDiv  := nDinDiv( cCodDiv, dbfDiv )
      end if

      if cPirDiv != nil
         cPirDiv  := cPirDiv( cCodDiv, dbfDiv )
      end if

      if nDirDiv != nil
         nDirDiv  := nRinDiv( cCodDiv, dbfDiv )
      end if

      if oSayMas != nil
         oSayMas:SetText( ( dbfDiv )->cSmbDiv )
      end if

   else

      msgStop( "Divisa no encontrada", cCodDiv )
      lValid      := .f.

   end if

RETURN lValid

//---------------------------------------------------------------------------//

FUNCTION cDivOut( oGet, uBmp, xGetDiv, cPouDiv, nDouDiv, cPorDiv, nDorDiv, cPpvDiv, nDprDiv, oSayMas, dbfDiv, oBan )

	local cCodDiv	:= oGet:varGet()
   local lValid   := .f.

   if Empty( cCodDiv )
      cCodDiv     := cDivEmp()
   end if

   if ( dbfDiv )->( dbSeek( cCodDiv ) )

		oGet:cText( cCodDiv )

      if ValType( uBmp ) == "O" .and. !Empty( oBan )
         uBmp:Reload( ( dbfDiv )->cBndDiv )
      elseif ValType( uBmp ) == "N" .and. !Empty( oBan )
         uBmp           := oBan:hBandera( ( dbfDiv )->cBndDiv )
      end if

      if ValType( xGetDiv ) == "O"
         xGetDiv:cText( nValChgDiv( dbfDiv ) )
      elseif ValType( xGetDiv ) == "N"
         xGetDiv  := nValChgDiv( dbfDiv )
      end if

      lValid      := .t.

		/*
		Picture de la divisa
		*/

      if cPouDiv != nil
         cPouDiv := cPouDiv( cCodDiv, dbfDiv )
      end if

      if nDouDiv != nil
         nDouDiv := nDouDiv( cCodDiv, dbfDiv )
      end if

      if cPorDiv != nil
         cPorDiv := cPorDiv( cCodDiv, dbfDiv )
      end if

      if nDorDiv != nil
         nDorDiv := nRouDiv( cCodDiv, dbfDiv )
      end if

      if cPpvDiv != nil
         cPpvDiv := cPpvDiv( cCodDiv, dbfDiv )
      end if

      if nDprDiv != nil
         nDprDiv := nDpvDiv( cCodDiv, dbfDiv )
      end if

      if oSayMas != nil
         oSayMas:SetText( ( dbfDiv )->CSMBDIV )
      end if

   else

      msgStop( "Divisa no encontrada", cCodDiv )
      lValid      := .f.

   end if

RETURN lValid

//---------------------------------------------------------------------------//
/*
Devuelve el cambio de una divisa
*/

FUNCTION nValDiv( cCodDiv, dbfDiv )

	local nPtsVal	:= 1

	IF Empty( cCodDiv )
		RETURN .T.
	END IF

	IF ( dbfDiv )->( dbSeek( cCodDiv ) )
      nPtsVal     := nValChgDiv( dbfDiv )
   ELSE
      msgStop( "Divisa no encontrada", cCodDiv )
	END IF

RETURN ( nPtsVal )

//---------------------------------------------------------------------------//

FUNCTION BrwDiv( oGet, oBmp, oGetDiv, dbfDiv, oBan, lBigStyle )

	local oDlg
	local oGet1
	local cGet1
	local oBrw
   local nOrd        := GetBrwOpt( "BrwDiv" )
   local aSta
   local lCloDiv     := .f.
	local oCbxOrd
   local aCbxOrd     := { "Código", "Nombre" }
   local cCbxOrd
   local nLevel      := Auth():Level( "01039" )

   nOrd              := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd           := aCbxOrd[ nOrd ]

   DEFAULT lBigStyle := .f.

   if empty( dbfDiv )
      dbUseArea( .t., ( cDriver() ), ( cPatDat() + "Divisas.Dbf" ), ( cCheckArea( "Divisas", @dbfDiv ) ), .t. )
      lCloDiv        := .t.
   else
      aSta           := aGetStatus( dbfDiv, .t. )
   end if

   nOrd              := ( dbfDiv )->( OrdSetFocus( nOrd ) )

   if !lBigStyle
      DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Seleccione la divisa"
   else
      DEFINE DIALOG oDlg RESOURCE "BIGHELPENTRY" TITLE "Seleccione la divisa"
   end if

		REDEFINE GET    oGet1 VAR cGet1;
			ID 		    104 ;
         ON CHANGE   ( AutoSeek( nKey, nFlags, Self, oBrw, dbfDiv ) );
         VALID       ( OrdClearScope( oBrw, dbfDiv ) );
         BITMAP      "FIND" ;
         OF          oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		   cCbxOrd ;
			ID          102 ;
         ITEMS       aCbxOrd ;
			ON CHANGE   ( ( dbfDiv )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:refresh(), oGet1:SetFocus() ) ;
			OF          oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfDiv
      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "Browse.Divisas"

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCdoDiv"
         :bEditValue       := {|| ( dbfDiv )->cCodDiv }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomDiv"
         :bEditValue       := {|| ( dbfDiv )->cNomDiv }
         :nWidth           := 200
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Valor en pesetas"
         :bEditValue       := {|| Trans( ( dbfDiv )->nPtsDiv, "@E 999,999.999999") }
         :nWidth           := 90
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Valor en euros"
         :bEditValue       := {|| Trans( ( dbfDiv )->nEurDiv, "@E 999,999.999999") }
         :nWidth           := 90
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Simbolo"
         :bEditValue       := {|| ( dbfDiv )->cSmbDiv }
         :nWidth           := 50
      end with

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }
      oBrw:bRClicked       := {| nRow, nCol, nFlags | oBrw:RButtonDown( nRow, nCol, nFlags ) }

      oBrw:CreateFromResource( 105 )

      if lBigStyle
         oBrw:nHeaderHeight   := 36
         oBrw:nFooterHeight   := 36
         oBrw:nLineHeight     := 36
      end if

		REDEFINE BUTTON ;
			ID 		500 ;
			OF 		oDlg ;
         WHEN     ( .f. ) ;
         ACTION   ( nil )

		REDEFINE BUTTON ;
			ID 		501 ;
			OF 		oDlg ;
         WHEN     ( .f. ) ;
         ACTION   ( nil )

		REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         ACTION   ( oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

      oDlg:bStart := { || oBrw:Load() }

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK

      oGet:cText( ( dbfDiv )->cCodDiv )

      if hb_isobject( oBmp )
         oBmp:Reload( ( dbfDiv )->cBndDiv )
      end if

      if hb_isobject( oGetDiv )
         oGetDiv:cText( nValChgDiv( dbfDiv ) )
      elseif hb_isnumeric( oGetDiv )
         oGetDiv  := nValChgDiv( dbfDiv )
      end if

   end if

   DestroyFastFilter( dbfDiv )

   SetBrwOpt( "BrwDiv", ( dbfDiv )->( OrdNumber() ) )

	oGet:setFocus()

   if lCloDiv
      ( dbfDiv )->( dbclosearea() )
      dbfDiv      := nil
   else 
      setStatus( dbfDiv, aSta )
   end if

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

FUNCTION BrwNbrDiv( oGet, oGetDiv, dbfDiv, oBan )

	local oDlg
	local oGet1
	local cGet1
	local oBrw
   local nOrd        := GetBrwOpt( "BrwDiv" )
   local aSta
	local oCbxOrd
   local aCbxOrd     := { "Código", "Nombre" }
   local cCbxOrd
   local nLevel      := Auth():Level( "01039" )

   nOrd              := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd           := aCbxOrd[ nOrd ]

   if dbfDiv == nil
      return .f.
   end if

   aSta              := aGetStatus( dbfDiv, .t. )
   nOrd              := ( dbfDiv )->( OrdSetFocus( nOrd ) )

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Seleccione la divisa"

		REDEFINE GET oGet1 VAR cGet1;
			ID 		104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfDiv ) );
         VALID    ( OrdClearScope( oBrw, dbfDiv ) );
         BITMAP   "FIND" ;
         OF       oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    aCbxOrd ;
			ON CHANGE( ( dbfDiv )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:refresh(), oGet1:SetFocus() ) ;
			OF 		oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfDiv
      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "Browse.Divisas por nombre"

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCdoDiv"
         :bEditValue       := {|| ( dbfDiv )->cCodDiv }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomDiv"
         :bEditValue       := {|| ( dbfDiv )->cNomDiv }
         :nWidth           := 200
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Valor en pesetas"
         :bEditValue       := {|| Trans( ( dbfDiv )->nPtsDiv, "@E 999,999.999999") }
         :nWidth           := 90
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Valor en euros"
         :bEditValue       := {|| Trans( ( dbfDiv )->nEurDiv, "@E 999,999.999999") }
         :nWidth           := 90
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Simbolo"
         :bEditValue       := {|| ( dbfDiv )->cSmbDiv }
         :nWidth           := 50
      end with

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }
      oBrw:bRClicked       := {| nRow, nCol, nFlags | oBrw:RButtonDown( nRow, nCol, nFlags ) }

      oBrw:CreateFromResource( 105 )


		REDEFINE BUTTON ;
			ID 		500 ;
			OF 		oDlg ;
         WHEN     ( nAnd( nLevel, ACC_APPD ) != 0 ) ;
         ACTION   WinAppRec( oBrw, bEdit, dbfDiv, nil, nil, oBan )

		REDEFINE BUTTON ;
			ID 		501 ;
			OF 		oDlg ;
         WHEN     ( nAnd( nLevel, ACC_EDIT ) != 0 ) ;
         ACTION   WinEdtRec( oBrw, bEdit, dbfDiv, nil, nil, oBan )

		REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         ACTION   ( oDlg:end(IDOK) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

      oDlg:bStart := { || oBrw:Load() }

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK

      oGet:cText( ( dbfDiv )->cCodDiv )

      if ValType( oGetDiv ) == "O"
         oGetDiv:cText( ( dbfDiv )->cNomDiv )
      elseif ValType( oGetDiv ) == "N"
         oGetDiv := ( dbfDiv )->cNomDiv
      end if

   end if

   DestroyFastFilter( dbfDiv )

   SetBrwOpt( "BrwDiv", ( dbfDiv )->( OrdNumber() ) )

	oGet:setFocus()

   ( dbfDiv )->( OrdSetFocus( nOrd ) )

   SetStatus( dbfDiv, aSta )

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

/*
Devuelve un array con los nombres de los paises
*/

FUNCTION loadBan( dbfBan, aCodBan, aNomBan, aResBan )

   local nRec  := ( dbfBan )->( Recno() )

   aCodBan     := {}
   aNomBan     := {}
   aResBan     := {}

   ( dbfBan )->( dbGoTop() )
	WHILE ( dbfBan )->( !eof() )

		aadd( aCodBan, ( dbfBan )->CCODBAN )
		aadd( aNomBan, ( dbfBan )->CNOMBAN )
      aadd( aResBan, LoadBitMap( GetResources(), ( dbfBan )->CRESBAN ) )

		( dbfBan )->( dbSkip() )

	END DO

   ( dbfBan )->( dbGoTo( nRec ) )

RETURN NIL

//---------------------------------------------------------------------------//

/*
Devuelve el nombre de una bandera
*/

FUNCTION cNomBan( cCodBan, dbfBan )

	local cNomBan	:= ""

	IF ( dbfBan )->( dbSeek( cCodBan ) )
      cNomBan     := ( dbfBan )->cNomBan
	END IF

RETURN ( cNomBan )

//---------------------------------------------------------------------------//

/*
Devuelve el recurso de una bandera
*/

FUNCTION cResBan( cCodBan, dbfBan )

	local cNomBan	:= ""

	IF ( dbfBan )->( dbSeek( cCodBan ) )
      cNomBan     := Rtrim( ( dbfBan )->cBndDiv )
	END IF

RETURN ( cNomBan )

//---------------------------------------------------------------------------//

/*
Devuelve el grafico de una bandera
*/

STATIC FUNCTION cBmpBan( cResBan, oBan )

RETURN ( oBan:hBandera( cResBan ) )

//---------------------------------------------------------------------------//
/*
Devuelve el grafico de la bendera de una divisa
*/

FUNCTION hBmpDiv( cCodDiv, dbfDiv, oBan, lDefDiv )

   local oBlock
   local oError
   local hBmp        := 0
   local lCloDiv     := .f.

   /*
   Mostrar la divisa por defecto
   */

   DEFAULT lDefDiv   := .t.

   if cCodDiv == cDivEmp() .and. lDefDiv
      return ( 0 )
   end if

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if dbfDiv == NIL
      dbUseArea( .t., ( cDriver() ), ( cPatDat() + "Divisas.Dbf" ), ( cCheckArea( "Divisas", @dbfDiv ) ), .f., .f. )
      ( dbfDiv )->( ordSetFocus( 1 ) )
      lCloDiv        := .t.
   end if

   if dbSeekInOrd( cCodDiv, "cCodDiv", dbfDiv ) .and. oBan !=nil
      hBmp           := oBan:hBandera( ( dbfDiv )->cBndDiv )
   end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if lCloDiv
		CLOSE( dbfDiv )
   end if

RETURN ( hBmp )

//---------------------------------------------------------------------------//

/*
Devuelve el numero de decimales redondeado del punto verde de una divisa
*/

FUNCTION nDprDiv( cCodDiv, dbfDiv )

   DEFAULT cCodDiv   := cDivEmp()

   if cCodDiv != cCodBuf .or. Empty( aDivBuf )
      aDivBuf( cCodDiv, dbfDiv )
   end if

RETURN ( aDivBuf[ _NRPVDIV ] )

//---------------------------------------------------------------------------//

FUNCTION cNomDiv( cCodDiv, dbfDiv )

   DEFAULT cCodDiv   := cDivEmp()

   if cCodDiv != cCodBuf .or. Empty( aDivBuf )
      aDivBuf( cCodDiv, dbfDiv )
   end if

RETURN ( aDivBuf[ _CNOMDIV ] )

//---------------------------------------------------------------------------//

FUNCTION cBmpDiv( cCodDiv, dbfDiv )

   DEFAULT cCodDiv   := cDivEmp()

   if cCodDiv != cCodBuf .or. Empty( aDivBuf )
      aDivBuf( cCodDiv, dbfDiv )
   end if

RETURN ( aDivBuf[ _CBNDDIV ] )

//---------------------------------------------------------------------------//

FUNCTION Chg2Div()

	local oDlg
	local oGetDivOrg
   local cGetDivOrg  := cDivEmp()
	local oBmpDivOrg
	local cPicDivOrg
	local nVdvDivOrg
	local oGetDivDes
	local cGetDivDes	:= "EUR"
	local oBmpDivDes
	local cPicDivDes
	local nVdvDivDes
	local oPtsDivOrg
	local oPtsDivDes
	local nPtsDivOrg 	:= 0
	local nPtsDivDes 	:= 0

   IF !OpenFiles()
      RETURN NIL
   END IF

	cPicDivOrg			:= cPouDiv( cGetDivOrg, dbfDiv )
	cPicDivDes			:= cPouDiv( cGetDivDes, dbfDiv )
   nVdvDivOrg        := nChgDiv( cGetDivOrg, dbfDiv )
   nVdvDivDes        := nChgDiv( cGetDivDes, dbfDiv )

	DEFINE DIALOG oDlg RESOURCE "CNVDIV"

	REDEFINE GET oGetDivOrg VAR cGetDivOrg;
			VALID		( 	cDiv( oGetDivOrg, oBmpDivOrg, @nVdvDivOrg, @cPicDivOrg ),;
							SetPic( oPtsDivOrg, cPicDivOrg ),;
							SetChgDiv( oPtsDivOrg, oPtsDivDes, nVdvDivOrg, nVdvDivDes ) );
			PICTURE	"@!";
			ID 		100 ;
			COLOR 	CLR_GET ;
         BITMAP   "LUPA" ;
			ON HELP	BrwDiv( oGetDivOrg, oBmpDivOrg ) ;
			OF 		oDlg

	REDEFINE BITMAP oBmpDivOrg ;
         RESOURCE "BAN_EURO" ;
			ID 		110;
			OF 		oDlg

	REDEFINE GET oPtsDivOrg VAR nPtsDivOrg ;
			ID 		120 ;
			COLOR 	CLR_GET ;
			PICTURE	cPicDivOrg ;
         ON HELP  BrwDiv( oGetDivOrg, oBmpDivOrg ) ;
			VALID		SetChgDiv( oPtsDivOrg, oPtsDivDes, nVdvDivOrg, nVdvDivDes ) ;
			OF 		oDlg

	REDEFINE GET oGetDivDes VAR cGetDivDes;
			VALID		(	cDiv( oGetDivDes, oBmpDivDes, @nVdvDivDes, @cPicDivDes ),;
							SetPic( oPtsDivDes, cPicDivDes ),;
							SetChgDiv( oPtsDivOrg, oPtsDivDes, nVdvDivOrg, nVdvDivDes ) );
			PICTURE	"@!";
			ID 		130 ;
			COLOR 	CLR_GET ;
         BITMAP   "LUPA" ;
			ON HELP	BrwDiv( oGetDivDes, oBmpDivDes ) ;
			OF 		oDlg

	REDEFINE BITMAP oBmpDivDes ;
			RESOURCE	"BAN_EURO" ;
			ID 		140;
			OF 		oDlg

	REDEFINE GET oPtsDivDes VAR nPtsDivDes ;
			ID 		150 ;
			WHEN		.F. ;
			COLOR 	CLR_GET ;
			PICTURE	cPicDivDes ;
			ON HELP	BrwDiv( oGetDivDes, oBmpDivDes ) ;
			OF 		oDlg

	REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			ACTION	oDlg:end()

	ACTIVATE DIALOG oDlg CENTER VALID ( CloseFiles() )

   oBmpDivOrg:End()
   oBmpDivDes:End()

RETURN NIL

//---------------------------------------------------------------------------//

FUNCTION SetChgDiv( oPtsDivOrg, oPtsDivDes, nVdvDivOrg, nVdvDivDes )

	local nPtsOrg	:= oPtsDivOrg:varGet() / nVdvDivOrg

	oPtsDivDes:cText( nPtsOrg / nVdvDivDes )

RETURN .T.

//---------------------------------------------------------------------------//

STATIC FUNCTION SetPic( oPtsDiv, cPicDiv )

	oPtsDiv:oGet:Picture := cPicDiv
	oPtsDiv:refresh()

RETURN NIL

//---------------------------------------------------------------------------//
//
// Devuelve el improte en Euros
//

FUNCTION nImpEuros( nImp, cCodDiv, dbfDiv )

   local nChgEuros   := nChgDiv( cCodDiv, dbfDiv )
   local nRnd        := nRouDiv( cCodDiv, dbfDiv )

return Round( nImp / nChgEuros, nRnd )

//---------------------------------------------------------------------------//

FUNCTION nImpPesetas( nImp, cCodDiv, dbfDiv )

   local nChgPesetas := nChgDiv( cCodDiv, dbfDiv )
   local nRnd        := nRouDiv( cCodDiv, dbfDiv )

return Round( nImp / nChgPesetas, nRnd )

//---------------------------------------------------------------------------//

FUNCTION nCnv( nImp, nVdv )
RETURN ( nImp / nVdv  )

//---------------------------------------------------------------------------//

FUNCTION nValChgDiv( dbfDiv )

RETURN ( if( lEmpCnv(), ( dbfDiv )->NEURDIV, ( dbfDiv )->NPTSDIV ) )

//---------------------------------------------------------------------------//
/*
Devuelve el grafico de la bendera de una divisa
*/

FUNCTION cFilBmpDiv( cCodDiv, dbfDiv, oBan )

   local oBlock
   local oError
   local hBmp        := 0
   local lCloDiv     := .f.

   /*
   Mostrar la divisa por defecto
   */

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if dbfDiv == NIL
      dbUseArea( .t., ( cDriver() ), ( cPatDat() + "Divisas.Dbf" ), ( cCheckArea( "Divisas", @dbfDiv ) ), .f., .f. )
      ( dbfDiv )->( ordSetFocus( 1 ) )
		lCloDiv	:= .t.
   end if

   if dbSeekInOrd( cCodDiv, "cCodDiv", dbfDiv )
      hBmp     := ( dbfDiv )->CBNDDIV
   end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if lCloDiv
		CLOSE( dbfDiv )
   end if

RETURN ( hBmp )

//---------------------------------------------------------------------------//

FUNCTION lMasDiv( cCodDiv, dbfDiv )

   local lMas        := .t.

   DEFAULT cCodDiv   := cDivEmp()

	IF ( dbfDiv )->( dbSeek( cCodDiv ) )
      lMas           := ( dbfDiv )->lMasDiv
	END IF

RETURN ( lMas )

//----------------------------------------------------------------------------//
//Funciones para programa y pda
//----------------------------------------------------------------------------//

#endif

//---------------------------------------------------------------------------//

Function IsDiv()

   if OpenFiles()

      ( dbfDiv )->( __dbLocate( { || ( dbfDiv )->cCodDiv == "EUR" } ) )
      if!( dbfDiv )->( Found() )
         ( dbfDiv )->( dbAppend() )
         ( dbfDiv )->cCodDiv  := "EUR"
         ( dbfDiv )->cNomDiv  := "Euros"
         ( dbfDiv )->dActDiv  := Ctod( "01/01/2000" )
         ( dbfDiv )->nPtsDiv  := 166.386
         ( dbfDiv )->nEurDiv  := 1
         ( dbfDiv )->nNinDiv  := 8
         ( dbfDiv )->nDinDiv  := 2
         ( dbfDiv )->nRinDiv  := 2
         ( dbfDiv )->nNouDiv  := 8
         ( dbfDiv )->nDouDiv  := 2
         ( dbfDiv )->nRouDiv  := 2
         ( dbfDiv )->nNpvDiv  := 8
         ( dbfDiv )->nDpvDiv  := 2
         ( dbfDiv )->nRpvDiv  := 2
         ( dbfDiv )->nNwbDiv  := 8
         ( dbfDiv )->nDwbDiv  := 2
         ( dbfDiv )->nRwbDiv  := 2
         ( dbfDiv )->cBndDiv  := "BAN_EURO"
         ( dbfDiv )->cSmbDiv  := "€"
         ( dbfDiv )->( dbUnLock() )
      end if

      ( dbfDiv )->( __dbLocate( { || ( dbfDiv )->cCodDiv == "PTS" } ) )
      if!( dbfDiv )->( Found() )
         ( dbfDiv )->( dbAppend() )
         ( dbfDiv )->cCodDiv  := "PTS"
         ( dbfDiv )->cNomDiv  := "Pesetas"
         ( dbfDiv )->dActDiv  := Ctod( "01/01/2000" )
         ( dbfDiv )->nPtsDiv  := 1
         ( dbfDiv )->nEurDiv  := 166.386
         ( dbfDiv )->nNinDiv  := 10
         ( dbfDiv )->nDinDiv  := 2
         ( dbfDiv )->nRinDiv  := 0
         ( dbfDiv )->nNouDiv  := 10
         ( dbfDiv )->nDouDiv  := 2
         ( dbfDiv )->nRouDiv  := 0
         ( dbfDiv )->nNpvDiv  := 10
         ( dbfDiv )->nDpvDiv  := 2
         ( dbfDiv )->nRpvDiv  := 0
         ( dbfDiv )->nNwbDiv  := 10
         ( dbfDiv )->nDwbDiv  := 2
         ( dbfDiv )->nRwbDiv  := 0
         ( dbfDiv )->cBndDiv  := "BAN_ESPA"
         ( dbfDiv )->cSmbDiv  := "Pts"
         ( dbfDiv )->( dbUnLock() )
      end if

      CloseFiles()

   end if

Return ( .t. )

//----------------------------------------------------------------------------//

/*
Abre los ficheros
*/

STATIC FUNCTION OpenFiles()

   local lOpen       := .t.
   local oError
   local oBlock

   IF !lExistTable( cPatDat() + "Divisas.Dbf" )
		mkDiv()
	END IF

   IF !lExistIndex( cPatDat() + "Divisas.Cdx" )
		rxDiv()
	END IF

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      dbUseArea( .t., ( cDriver() ), ( cPatDat() + "Divisas.Dbf" ), ( cCheckArea( "Divisas", @dbfDiv ) ), .f., .f. )
      ( dbfDiv )->( ordSetFocus( 1 ) )

   RECOVER USING oError

      lOpen          := .f.
      CloseFiles()

      msgStop( "Imposible abrir todas las bases de datos de divisas" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN lOpen

//----------------------------------------------------------------------------//

Static Function CloseFiles()

   oWndBrw  := nil

   if !Empty ( dbfDiv )
      ( dbfDiv )->( dbCloseArea() )
   end if

   dbfDiv   := nil

Return .t.

//----------------------------------------------------------------------------//

Function mkDiv( cPath, lAppend, cPathOld )

	local dbfDiv

   DEFAULT cPath     := cPatDat()
	DEFAULT lAppend	:= .f.

   if !lExistTable( cPath + "Divisas.Dbf" )
      dbCreate( cPath + "Divisas.Dbf", aSqlStruct( aItmDiv() ), cDriver() )
   end if

	rxDiv( cPath )

   if lAppend .and. lIsDir( cPathOld )

      dbUseArea( .t., cDriver(), cPath + "Divisas.Dbf", cCheckArea( "DIVISAS", @dbfDiv ), .t. )

      if !( dbfDiv )->( neterr() )
         ( dbfDiv )->( __dbApp( cPathOld + "Divisas.Dbf" ) )
         ( dbfDiv )->( dbCloseArea() )
       end if

   end if

RETURN .T.

//--------------------------------------------------------------------------//
/*
Crea el indice
*/

FUNCTION rxDiv( cPath, oMeter )

	local dbfDiv

   DEFAULT cPath  := cPatDat()

   if !lExistTable( cPath + "Divisas.Dbf" )
      dbCreate( cPath + "Divisas.Dbf", aSqlStruct( aItmDiv() ), cDriver() )
   end if

   fErase( cPath + "Divisas.Cdx" )

   dbUseArea( .t., cDriver(), cPath + "Divisas.Dbf", cCheckArea( "DIVISAS", @dbfDiv ), .f. )

   if !( dbfDiv )->( neterr() )
      ( dbfDiv )->( __dbPack() )

      ( dbfDiv )->( ordCondSet("!Deleted()", {||!Deleted() }  ) )
      ( dbfDiv )->( ordCreate( cPath + "DIVISAS.CDX", "CCODDIV", "CCODDIV", {|| Field->CCODDIV } ) )

      ( dbfDiv )->( ordCondSet("!Deleted()", {||!Deleted() }  ) )
      ( dbfDiv )->( ordCreate( cPath + "DIVISAS.CDX", "CNOMDIV", "CNOMDIV", {|| Field->CNOMDIV } ) )

   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de divisas" )
   end if

   ( dbfDiv )->( dbCloseArea() )

RETURN NIL

//--------------------------------------------------------------------------//

function aItmDiv()

   local aItmDiv  := {}

   aAdd( aItmDiv, {"CCODDIV",   "C",     3,    0, "Código de la divisa"                                  ,  "",                  "", "( cDbfDiv )", nil } )
   aAdd( aItmDiv, {"CNOMDIV",   "C",    20,    0, "Nombre de la divisa"                                  ,  "",                  "", "( cDbfDiv )", nil } )
   aAdd( aItmDiv, {"DACTDIV",   "D",     8,    0, "Fecha ultimo cambio de la divisa"                     ,  "",                  "", "( cDbfDiv )", nil } )
   aAdd( aItmDiv, {"NPTSDIV",   "N",    16,    6, "Valor en pesetas de la divisa"                        ,  "'999,999.999999'",  "", "( cDbfDiv )", nil } )
   aAdd( aItmDiv, {"NEURDIV",   "N",    16,    6, "Valor en euros de la divisa"                          ,  "'999,999.999999'",  "", "( cDbfDiv )", nil } )
   aAdd( aItmDiv, {"NNINDIV",   "N",     2,    0, "Unidades de compra de la divisa"                      ,  "'99'",              "", "( cDbfDiv )", nil } )
   aAdd( aItmDiv, {"NDINDIV",   "N",     1,    0, "Decimales de compra de la divisa"                     ,  "'99'",              "", "( cDbfDiv )", nil } )
   aAdd( aItmDiv, {"NRINDIV",   "N",     1,    0, "Decimales de redondeo de la divisa"                   ,  "'99'",              "", "( cDbfDiv )", nil } )
   aAdd( aItmDiv, {"NNOUDIV",   "N",     2,    0, "Unidades de venta de la divisa"                       ,  "'99'",              "", "( cDbfDiv )", nil } )
   aAdd( aItmDiv, {"NDOUDIV",   "N",     1,    0, "Decimales de venta de la divisa"                      ,  "'99'",              "", "( cDbfDiv )", nil } )
   aAdd( aItmDiv, {"NROUDIV",   "N",     1,    0, "Decimales de redondeo de la divisa"                   ,  "'99'",              "", "( cDbfDiv )", nil } )
   aAdd( aItmDiv, {"NNPVDIV",   "N",     2,    0, "Unidades de punto verde de la divisa"                 ,  "'99'",              "", "( cDbfDiv )", nil } )
   aAdd( aItmDiv, {"NDPVDIV",   "N",     1,    0, "Decimales de punto verde de la divisa"                ,  "'99'",              "", "( cDbfDiv )", nil } )
   aAdd( aItmDiv, {"NRPVDIV",   "N",     1,    0, "Decimales de redondeo de punto verde  de la divisa"   ,  "'99'",              "", "( cDbfDiv )", nil } )
   aAdd( aItmDiv, {"NNWBDIV",   "N",     2,    0, "Unidades precio web de la divisa"                     ,  "'99'",              "", "( cDbfDiv )", nil } )
   aAdd( aItmDiv, {"NDWBDIV",   "N",     1,    0, "Decimales precio web de la divisa"                    ,  "'99'",              "", "( cDbfDiv )", nil } )
   aAdd( aItmDiv, {"NRWBDIV",   "N",     1,    0, "Decimales de redondeo precio web de la divisa"        ,  "'99'",              "", "( cDbfDiv )", nil } )
   aAdd( aItmDiv, {"CBNDDIV",   "C",     8,    0, ""                                                     ,  "",                  "", "( cDbfDiv )", nil } )
   aAdd( aItmDiv, {"CSMBDIV",   "C",     4,    0, ""                                                     ,  "",                  "", "( cDbfDiv )", nil } )
   aAdd( aItmDiv, {"LCTRDIV",   "L",     1,    0, ""                                                     ,  "",                  "", "( cDbfDiv )", nil } )
   aAdd( aItmDiv, {"LMASDIV",   "L",     1,    0, ""                                                     ,  "",                  "", "( cDbfDiv )", nil } )

return ( aItmDiv )

//---------------------------------------------------------------------------//

/*
Devuelve el numero de decimales del punto verde de una divisa
*/

FUNCTION nDpvDiv( cCodDiv, dbfDiv )

   DEFAULT cCodDiv   := cDivEmp()

   if cCodDiv != cCodBuf .or. Empty( aDivBuf )
      aDivBuf( cCodDiv, dbfDiv )
   end if

RETURN ( aDivBuf[ _NDPVDIV ] )

//---------------------------------------------------------------------------//

/*
Devuelve el picture de la divisa del punto verde
*/

FUNCTION cPpvDiv( cCodDiv, dbfDiv )

   DEFAULT cCodDiv   := cDivEmp()

   if cCodDiv != cCodBuf .or. Empty( aDivBuf )
      aDivBuf( cCodDiv, dbfDiv )
   end if

RETURN ( cPpvDiv )

//---------------------------------------------------------------------------//

/*
Devuelve el numero de decimales de una divisa
*/

FUNCTION nDouDiv( cCodDiv, dbfDiv )

   DEFAULT cCodDiv   := cDivEmp()

   if cCodDiv != cCodBuf .or. Empty( aDivBuf )
      aDivBuf( cCodDiv, dbfDiv )
   end if

RETURN ( aDivBuf[ _NDOUDIV ] )

//---------------------------------------------------------------------------//

FUNCTION nDwbDiv( cCodDiv, dbfDiv )

   DEFAULT cCodDiv   := cDivEmp()

   if cCodDiv != cCodBuf .or. Empty( aDivBuf )
      aDivBuf( cCodDiv, dbfDiv )
   end if

RETURN ( aDivBuf[ _NDWBDIV ] )

//---------------------------------------------------------------------------//

/*
Devuelve el picture del redondeo
*/

FUNCTION cPirDiv( cCodDiv, dbfDiv )

   DEFAULT cCodDiv   := cDivEmp()

   if cCodDiv != cCodBuf .or. Empty( aDivBuf )
      aDivBuf( cCodDiv, dbfDiv )
   end if

RETURN ( cPirDiv )

//---------------------------------------------------------------------------//

/*
Devuelve el picture de la divisa de compra
*/

FUNCTION cPinDiv( cCodDiv, dbfDiv )

   DEFAULT cCodDiv   := cDivEmp()

   if cCodDiv != cCodBuf .or. Empty( aDivBuf )
      aDivBuf( cCodDiv, dbfDiv )
   end if

RETURN ( cPinDiv )

//---------------------------------------------------------------------------//

/*
Devuelve el picture del redondeo de salida
*/

FUNCTION cPorDiv( cCodDiv, dbfDiv )

   DEFAULT cCodDiv   := cDivEmp()

   if cCodDiv != cCodBuf .or. Empty( aDivBuf )
      aDivBuf( cCodDiv, dbfDiv )
   end if

RETURN ( cPorDiv )

//---------------------------------------------------------------------------//

/*
Devuelve el picture de la divisa de venta
*/

FUNCTION cPouDiv( cCodDiv, dbfDiv )

   DEFAULT cCodDiv   := cDivEmp()

   if cCodDiv != cCodBuf .or. Empty( aDivBuf )
      aDivBuf( cCodDiv, dbfDiv )
   end if

RETURN ( cPouDiv )

//---------------------------------------------------------------------------//

FUNCTION cPwbDiv( cCodDiv, dbfDiv )

   DEFAULT cCodDiv   := cDivEmp()

   if cCodDiv != cCodBuf .or. Empty( aDivBuf )
      aDivBuf( cCodDiv, dbfDiv )
   end if

RETURN ( cPwbDiv )

//---------------------------------------------------------------------------//

FUNCTION cPwrDiv( cCodDiv, dbfDiv )

   DEFAULT cCodDiv   := cDivEmp()

   if cCodDiv != cCodBuf .or. Empty( aDivBuf )
      aDivBuf( cCodDiv, dbfDiv )
   end if

RETURN ( cPwrDiv )

//---------------------------------------------------------------------------//

Static Function aDivBuf( cCodDiv, dbfDiv )

   local n
   local oBlock
   local oError
   local nField
   local lCloDiv     := .f.

   if Empty( cCodDiv )
      cCodDiv        := cDivEmp()
   end if

   aDivBuf           := {}

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if dbfDiv == nil
      dbUseArea( .t., ( cDriver() ), ( cPatDat() + "Divisas.Dbf" ), ( cCheckArea( "Divisas", @dbfDiv ) ), .t., .f. )
      ( dbfDiv )->( ordSetFocus( 1 ) )
      lCloDiv        := .t.
   end if

   do case
   case ValType( dbfDiv ) == "C"

      if !dbSeekInOrd( cCodDiv, "cCodDiv", dbfDiv )
         cCodDiv     := cDivEmp()
      end if

      if dbSeekInOrd( cCodDiv, "cCodDiv", dbfDiv )

         nField      := ( dbfDiv )->( fCount() )

         for n := 1 to nField
            aAdd( aDivBuf, ( dbfDiv )->( FieldGet( n ) ) )
         next

         nDouDiv     := ( dbfDiv )->nDouDiv 
         nEurDiv     := ( dbfDiv )->nEurDiv
         nPtsDiv     := ( dbfDiv )->nPtsDiv

         cPouDiv     := RetPic( ( dbfDiv )->nNouDiv, ( dbfDiv )->nDouDiv )
         cPpvDiv     := RetPic( ( dbfDiv )->nNpvDiv, ( dbfDiv )->nDpvDiv )
         cPinDiv     := RetPic( ( dbfDiv )->nNinDiv, ( dbfDiv )->nDinDiv )
         cPirDiv     := RetPic( ( dbfDiv )->nNinDiv, ( dbfDiv )->nRinDiv )
         cPorDiv     := RetPic( ( dbfDiv )->nNouDiv, ( dbfDiv )->nRouDiv )
         cPwbDiv     := RetPic( ( dbfDiv )->nNwbDiv, ( dbfDiv )->nDwbDiv )
         cPwrDiv     := RetPic( ( dbfDiv )->nNwbDiv, ( dbfDiv )->nRwbDiv )

      end if

   case ValType( dbfDiv ) == "O"

      if !dbfDiv:SeekInOrd( cCodDiv, "cCodDiv" )
         cCodDiv     := cDivEmp()
      end if

      if dbfDiv:SeekInOrd( cCodDiv, "cCodDiv" )

         nField      := dbfDiv:fCount()

         for n := 1 to nField
            aAdd( aDivBuf, dbfDiv:FieldGet( n ) )
         next

         nDouDiv     := dbfDiv:nDouDiv 
         nEurDiv     := dbfDiv:nEurDiv
         nPtsDiv     := dbfDiv:nPtsDiv

         cPouDiv     := RetPic( dbfDiv:nNouDiv, dbfDiv:nDouDiv )
         cPpvDiv     := RetPic( dbfDiv:nNpvDiv, dbfDiv:nDpvDiv )
         cPinDiv     := RetPic( dbfDiv:nNinDiv, dbfDiv:nDinDiv )
         cPirDiv     := RetPic( dbfDiv:nNinDiv, dbfDiv:nRinDiv )
         cPorDiv     := RetPic( dbfDiv:nNouDiv, dbfDiv:nRouDiv )
         cPwbDiv     := RetPic( dbfDiv:nNwbDiv, dbfDiv:nDwbDiv )
         cPwrDiv     := RetPic( dbfDiv:nNwbDiv, dbfDiv:nRwbDiv )

      end if

   end case

   RECOVER USING oError
      // msgStop( "Imposible abrir todas las bases de datos de divisas" + CRLF + ErrorMessage( oError ) )
   END SEQUENCE
   ErrorBlock( oBlock )

   if lCloDiv
      ( dbfDiv )->( dbCloseArea() )
   end if

   cCodBuf           := cCodDiv

Return ( aDivBuf )

//----------------------------------------------------------------------------//

/*
Devuelve el numero de decimales para el redondeo
*/

FUNCTION nRouDiv( cCodDiv, dbfDiv )

   DEFAULT cCodDiv   := cDivEmp()

   if cCodDiv != cCodBuf .or. Empty( aDivBuf )
      aDivBuf( cCodDiv, dbfDiv )
   end if

RETURN ( aDivBuf[ _NROUDIV ] )

//---------------------------------------------------------------------------//
/*
Devuelve el cambio de una divisa
*/

FUNCTION nChgDiv( cCodDiv, uDiv )

   DEFAULT cCodDiv   := cDivEmp()

   if cCodDiv != cCodBuf .or. Empty( aDivBuf )
      aDivBuf( cCodDiv, uDiv )
   end if

RETURN ( if( lEmpCnv(), aDivBuf[ _NEURDIV ], aDivBuf[ _NPTSDIV ] ) )

//---------------------------------------------------------------------------//

/*
Devuelve el numero de decimales para el redondeo
*/

FUNCTION nRinDiv( cCodDiv, dbfDiv )

   DEFAULT cCodDiv   := cDivEmp()

   if cCodDiv != cCodBuf .or. Empty( aDivBuf )
      aDivBuf( cCodDiv, dbfDiv )
   end if

RETURN ( aDivBuf[ _NRINDIV ] )

//---------------------------------------------------------------------------//

/*
Devuelve el numero de decimales de una divisa
*/

FUNCTION nDinDiv( cCodDiv, dbfDiv )

   DEFAULT cCodDiv   := cDivEmp()

   if cCodDiv != cCodBuf .or. Empty( aDivBuf )
      aDivBuf( cCodDiv, dbfDiv )
   end if

RETURN ( aDivBuf[ _NDINDIV ] )

//---------------------------------------------------------------------------//

/*
Devuelve el cambio de una divisa
*/

FUNCTION nDiv2Div( cDivOrg, cDivDes, dbfDiv )

	local nPtsVal	   := 1

   if Empty( aDivBuf )
      aDivBuf( cDivOrg, dbfDiv )
   end if

   /*
   Conversiones directas
   */

   do case
      case cDivOrg == "PTS" .and. cDivDes == "EUR"
         nPtsVal     := aDivBuf[ _NEURDIV ]

      case cDivOrg == "EUR" .and. cDivDes == "PTS"
         nPtsVal     := 1 / aDivBuf[ _NPTSDIV ]

   end case

RETURN ( nPtsVal )

//---------------------------------------------------------------------------//

/*
Devuelve el simbolo de la divisa
*/

FUNCTION cSimDiv( cCodDiv, dbfDiv )

   DEFAULT cCodDiv   := cDivEmp()

   if cCodDiv != cCodBuf .or. Empty( aDivBuf )
      aDivBuf( cCodDiv, dbfDiv )
   end if

RETURN ( Rtrim( aDivBuf[ _CSMBDIV ] ) )

//---------------------------------------------------------------------------//

FUNCTION nCnv2Div( nImpChg, cDivOrg, cDivDes, lRound )

   local nDec        := 0

   DEFAULT lRound    := .t.

   if Empty( aDivBuf )
      aDivBuf( cDivOrg, dbfDiv )
   end if

   /*
   Conversiones directas-------------------------------------------------------
   */

   do case
      case cDivOrg == "PTS" .AND. cDivDes == "EUR"
         nImpChg     := nImpChg / aDivBuf[ _NEURDIV ]

      case cDivOrg == "EUR" .and. cDivDes == "PTS"
         nImpChg     := nImpChg * aDivBuf[ _NPTSDIV ]

   end case

   if isTrue( lRound )
      nImpChg        := Round( nImpChg, aDivBuf[ _NDOUDIV ] )
   end if

RETURN ( nImpChg )

//---------------------------------------------------------------------------//

FUNCTION TstDivisas( cPatDat )

   local n
   local dbfDiv

   local oError
   local oBlock

   if !lExistTable( cPatDat() + "Divisas.DBF" )
      dbCreate( cPatDat() + "Divisas.DBF", aSqlStruct( aItmDiv() ), cDriver() )
   end if

   if !lExistIndex( cPatDat() + "Divisas.CDX" )
      rxDiv( cPatDat() )
   end if

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   /*
   Cuantos campos tiene--------------------------------------------------------
   */

   dbUseArea( .t., cDriver(), cPatDat() + "Divisas.Dbf", cCheckArea( "Divisas", @dbfDiv ), .f. )

   
   if !( dbfDiv )->( netErr() )

      n           := ( dbfDiv )->( fCount() )

      ( dbfDiv )->( dbCloseArea() )

      if n != len( aItmDiv() )

         dbCreate( cPatEmpTmp() + "Divisas.Dbf", aSqlStruct( aItmDiv() ), cDriver() )
         appDbf( cPatDat(), cPatEmpTmp(), "Divisas", aItmDiv() )

         fEraseTable( cPatDat() + "Divisas.Dbf" )
         fRenameTable( cPatEmpTmp() + "Divisas.Dbf", cPatDat() + "Divisas.Dbf" )

         rxDiv( cPatDat() )

      end if

   end if

   RECOVER USING oError

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( .t. )

//---------------------------------------------------------------------------//

FUNCTION nRwbDiv( cCodDiv, dbfDiv )

   DEFAULT cCodDiv   := cDivEmp()

   if cCodDiv != cCodBuf .or. Empty( aDivBuf )
      aDivBuf( cCodDiv, dbfDiv )
   end if

RETURN ( aDivBuf[ _NRWBDIV ] )

//---------------------------------------------------------------------------//

