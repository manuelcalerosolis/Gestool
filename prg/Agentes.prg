#ifndef __PDA__
   #include "FiveWin.Ch"
   #include "Font.ch"
   #include "Report.ch"
   #include "Xbrowse.ch"
#else
   #include "FWCE.ch"
   REQUEST DBFCDX
#endif

#include "Factu.ch" 

#ifndef __PDA__

#define _CCODAGE                  1      //   C      3     0
#define _CAPEAGE                  2      //   C     30     0
#define _CNBRAGE                  3      //   C     15     0
#define _CDNINIF                  4      //   C     15     0
#define _CDIRAGE                  5      //   C     35     0
#define _CPOBAGE                  6      //   C     25     0
#define _CPROV                    7      //   C     15     0
#define _CPTLAGE                  8      //   C      5     0
#define _CTFOAGE                  9      //   C     12     0
#define _CFAXAGE                 10      //   C     12     0
#define _CMOVAGE                 11      //   C     12     0
#define _NIRPFAGE                12      //   N      4     1
#define _MCOMENT                 13      //   N      4     1
#define _LSELAGE                 14      //   L      1     0
#define _NCOM1                   15      //   N      5     2
#define _CMAILAGE                16      //   C     120    0
#define _CAGEREL                 17      //   C      3     0
#define _NCOMREL                 18      //   N      5     2
#define _CTAAGE                  19      //   C     12,  0, "Código subcuenta agente",   "",            "", "( cDbfAge )" },;
#define _CTAGAS                  20      //   C     12,  0, "Código subcuenta gasto",    "",            "", "( cDbfAge )" } }
#define _CCODPRV                 21      //   C     12,  0
#define _CCODART                 22      //   C     12,  0
#define _NCOMTAR1                23      //   N      5     2
#define _NCOMTAR2                24      //   N      5     2
#define _NCOMTAR3                25      //   N      5     2
#define _NCOMTAR4                26      //   N      5     2
#define _NCOMTAR5                27      //   N      5     2
#define _NCOMTAR6                28      //   N      5     2

static cTmpCom
static cTmpRel
static oWndBrw
static lOpenFiles := .f.
static bEdit      := { |aTmp, aoGet, dbfAge, oBrw, bWhen, bValid, nMode | EdtRec( aTmp, aoGet, dbfAge, oBrw, bWhen, bValid, nMode ) }
static bEdtDet    := { |aTmp, aoGet, dbfAge, oBrw, bWhen, bValid, nMode | EdtDet( aTmp, aoGet, dbfAge, oBrw, bWhen, bValid, nMode ) }
static bEdtRel    := { |aTmp, aoGet, dbfAge, oBrw, cCodAge, bValid, nMode | EdtRel( aTmp, aoGet, dbfAge, oBrw, cCodAge, bValid, nMode ) }

#endif

static dbfAge
static dbfAgeCom
static dbfAgeRel
static dbfProvee
static dbfArticulo

static oDetCamposExtra

static dbfTmpCom
static dbfTmpRel

#ifndef __PDA__

//----------------------------------------------------------------------------//
//Funciones del programa
//----------------------------------------------------------------------------//

FUNCTION Agentes( oMenuItem, oWnd )

   local nLevel

   DEFAULT  oMenuItem   := "01033"
   DEFAULT  oWnd        := oWnd()

   if oWndBrw == NIL

   nLevel               := nLevelUsr( oMenuItem )
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
      return .f.
   end if

   /*
   Anotamos el movimiento para el navegador
   */

   DEFINE SHELL oWndBrw FROM 2, 10 TO 18, 70;
      XBROWSE ;
		TITLE 	"Agentes" ;
      PROMPT   "Código",;
					"Apellidos" ,;
					"Nombre";
      MRU      "Security_Agent_16";
      ALIAS    ( dbfAge ) ;
      APPEND   ( WinAppRec( oWndBrw:oBrw, bEdit, dbfAge ) );
      DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdit, dbfAge ) );
      EDIT     ( WinEdtRec( oWndBrw:oBrw, bEdit, dbfAge ) ) ;
      DELETE   ( DBDelRec(  oWndBrw:oBrw, dbfAge ) ) ;
      LEVEL    nLevel ;
      OF       oWnd

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodAge"
         :bEditValue       := {|| ( dbfAge )->cCodAge }
         :nWidth           := 60
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Apellidos"
         :cSortOrder       := "cApeAge"
         :bEditValue       := {|| ( dbfAge )->cApeAge }
         :nWidth           := 200
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNbrAge"
         :bEditValue       := {|| ( dbfAge )->cNbrAge }
         :nWidth           := 200
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      oWndBrw:CreateXFromCode()

      DEFINE BTNSHELL RESOURCE "BUS" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:SearchSetFocus() ) ;
			TOOLTIP 	"(B)uscar" ;
			HOTKEY 	"B"

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
         HOTKEY   "D" ;
         LEVEL    ACC_APPD

		DEFINE BTNSHELL RESOURCE "EDIT" OF oWndBrw ;
			NOBORDER ;
			ACTION  	( oWndBrw:RecEdit() );
			TOOLTIP 	"(M)odificar";
         HOTKEY   "M" ;
         LEVEL    ACC_EDIT

		DEFINE BTNSHELL RESOURCE "ZOOM" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( WinZooRec( oWndBrw:oBrw, bEdit, dbfAge ) );
			TOOLTIP 	"(Z)oom";
         HOTKEY   "Z";

		DEFINE BTNSHELL RESOURCE "DEL" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( oWndBrw:RecDel() );
			TOOLTIP 	"(E)liminar";
         HOTKEY   "E" ;
         LEVEL    ACC_DELE

      if oUser():lAdministrador()

      DEFINE BTNSHELL RESOURCE "BMPCHG" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( ReplaceCreator( oWndBrw, dbfAge, aItmAge() ) ) ;
         TOOLTIP  "Cambiar campos" ;
         LEVEL    ACC_APPD

      end if

#ifndef __TACTIL__

      DEFINE BTNSHELL RESOURCE "IMP" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( InfAge():New( "Listado de agentes" ):Play() ) ;
         TOOLTIP  "(L)istado" ;
			HOTKEY 	"L"

#endif

      DEFINE BTNSHELL RESOURCE "END" GROUP OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:End() ) ;
         TOOLTIP  "(S)alir" ;
			HOTKEY 	"S"

      ACTIVATE WINDOW oWndBrw VALID ( CloseFiles() )

   end if

RETURN NIL

//----------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aTemp, aoGet, dbfAge, oBrw, bWhen, bValid, nMode )

	local oDlg
   local oFld
   local oBrwLin
   local oBrwRel
   local oBmpGeneral
   local oBmpComisiones

   /*
   Comienza la transaccion-----------------------------------------------------
   */

   if lPreEdit( aTemp, nMode )
      Return .f.
   end if

   DEFINE DIALOG oDlg RESOURCE "AGENTES" TITLE LblTitle( nMode ) + "Agentes : " + cNombreAgente( aTemp )

		REDEFINE FOLDER oFld ;
			ID 		500 ;
			OF 		oDlg ;
         PROMPT   "General"      ,;
                  "Comisiones"   ,;
                  "Relaciones"    ;
         DIALOGS  "AGENTES_1"    ,;
                  "AGENTES_2"    ,;
                  "AGENTES_3"

      /*
      Primera pestaña----------------------------------------------------------
      */

      REDEFINE BITMAP oBmpGeneral ;
         ID       500 ;
         RESOURCE "Security_Agent_48_Alpha" ;
         TRANSPARENT ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aoGet[ _CCODAGE ] VAR aTemp[ _CCODAGE ];
         ID       100 ;
         WHEN     ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) ;
         PICTURE  "@!" ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aoGet[ _CAPEAGE ] VAR aTemp[ _CAPEAGE ];
         ID       101 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@!" ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aoGet[ _CNBRAGE ] VAR aTemp[ _CNBRAGE ];
         ID       102 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@!" ;
         OF       oFld:aDialogs[1]

		REDEFINE GET aTemp[ _CDNINIF ];
         ID       103 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

		REDEFINE GET aTemp[ _CDIRAGE ];
         ID       104 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

		REDEFINE GET aTemp[ _CPOBAGE ];
         ID       105 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

		REDEFINE GET aTemp[ _CPROV ];
         ID       106 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

		REDEFINE GET aTemp[ _CPTLAGE ];
         ID       107 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

		REDEFINE GET aTemp[ _CTFOAGE ];
         ID       108 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "############" ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aTemp[ _CMOVAGE ];
         ID       113 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "############" ;
         OF       oFld:aDialogs[1]

		REDEFINE GET aTemp[ _CFAXAGE ];
         ID       109 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "############" ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aTemp[ _CMAILAGE ];
         ID       114 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aTemp[ _MCOMENT ];
         ID       112 ;
			MEMO ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aoGet[ _CCODPRV ] VAR aTemp[ _CCODPRV ] ;
         ID       320 ;
         IDTEXT   330 ;
         BITMAP   "LUPA" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cProvee( aoGet[ _CCODPRV ], dbfProvee, aoGet[ _CCODPRV ]:oHelpText ) );
         ON HELP  ( BrwProvee( aoGet[ _CCODPRV ], aoGet[ _CCODPRV ]:oHelpText ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aoGet[ _CCODART ] VAR aTemp[ _CCODART ] ;
         ID       340 ;
         IDTEXT   350 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    cArticulo( aoGet[ _CCODART ], dbfArticulo, aoGet[ _CCODART ]:oHelpText );
         BITMAP   "LUPA" ;
         ON HELP  BrwArticulo( aoGet[ _CCODART ], aoGet[ _CCODART ]:oHelpText );
         OF       oFld:aDialogs[1]

      /*
      Segunda pestaña----------------------------------------------------------
      */

      REDEFINE BITMAP oBmpComisiones ;
         ID       500 ;
         RESOURCE "Symbol_Percent_48_Alpha" ;
         TRANSPARENT ;
         OF       oFld:aDialogs[2]

      // Comisiones genereales

      REDEFINE GET aTemp[ _NCOM1 ] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999.99" ;
         SPINNER;
         ID       120 ;
         OF       oFld:aDialogs[2]

      // Comisiones por tarifa 1

      REDEFINE GET aTemp[ _NCOMTAR1 ] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999.99" ;
         SPINNER;
         ID       100 ;
         OF       oFld:aDialogs[2]

      // Comisiones por tarifa 2

      REDEFINE GET aTemp[ _NCOMTAR2 ] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999.99" ;
         SPINNER;
         ID       101 ;
         OF       oFld:aDialogs[2]

      // Comisiones por tarifa 3

      REDEFINE GET aTemp[ _NCOMTAR3 ] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999.99" ;
         SPINNER;
         ID       102 ;
         OF       oFld:aDialogs[2]

      // Comisiones por tarifa 4

      REDEFINE GET aTemp[ _NCOMTAR4 ] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999.99" ;
         SPINNER;
         ID       103 ;
         OF       oFld:aDialogs[2]

      // Comisiones por tarifa 5

      REDEFINE GET aTemp[ _NCOMTAR5 ] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999.99" ;
         SPINNER;
         ID       104 ;
         OF       oFld:aDialogs[2]

      // Comisiones por tarifa 6

      REDEFINE GET aTemp[ _NCOMTAR6 ] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999.99" ;
         SPINNER;
         ID       105 ;
         OF       oFld:aDialogs[2]

		// Detalle________________________________________________________________

      oBrwLin                 := IXBrowse():New( oFld:aDialogs[2] )

      oBrwLin:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwLin:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwLin:cAlias          := dbfTmpCom
      oBrwLin:nMarqueeStyle   := 5

      with object ( oBrwLin:AddCol() )
         :cHeader          := "Hasta"
         :bEditValue       := {|| ( dbfTmpCom )->nImpVta }
         :cEditPicture     := PicOut()
         :nWidth           := 120
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader          := "% Comisión"
         :bEditValue       := {|| ( dbfTmpCom )->nPctCom }
         :cEditPicture     := "@E 999.99"
         :nWidth           := 60
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      if nMode != ZOOM_MODE
         oBrwLin:bLDblClick   := {|| WinEdtRec( oBrwLin, bEdtDet, dbfTmpCom ) }
      end if

      oBrwLin:CreateFromResource( 310 )

      REDEFINE BUTTON ;
			ID 		501 ;
         OF       oFld:aDialogs[2] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinAppRec( oBrwLin, bEdtDet, dbfTmpCom ) )

      REDEFINE BUTTON ;
         ID       502 ;
         OF       oFld:aDialogs[2] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinEdtRec( oBrwLin, bEdtDet, dbfTmpCom ) )

      REDEFINE BUTTON ;
         ID       503 ;
         OF       oFld:aDialogs[2] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( dbDelRec( oBrwLin, dbfTmpCom ) )

      REDEFINE GET aoGet[ _CTAAGE ] VAR aTemp[ _CTAAGE ] ;
         ID       350 ;
         IDTEXT   351 ;
         PICTURE  ( Replicate( "X", nLenSubcuentaContaplus() ) ) ;
         WHEN     ( nLenCuentaContaplus() != 0 .and. nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwChkSubcuenta( aoGet[ _CTAAGE ], aoGet[ _CTAAGE ]:oHelpText ) ) ;
         VALID    ( MkSubcuenta( aoGet[ _CTAAGE ],;
                              {  aTemp[ _CTAAGE    ],;
                                 Rtrim( aTemp[ _CNBRAGE ] ) + Space( 1 ) + Rtrim( aTemp[ _CAPEAGE ] ),;
                                 aTemp[ _CDNINIF   ],;
                                 aTemp[ _CDIRAGE   ],;
                                 aTemp[ _CPOBAGE   ],;
                                 aTemp[ _CPROV     ],;
                                 aTemp[ _CPTLAGE   ],;
                                 aTemp[ _CTFOAGE   ],;
                                 aTemp[ _CFAXAGE   ],;
                                 aTemp[ _CMAILAGE  ] },;
                              aoGet[ _CTAAGE ]:oHelpText ) );
         OF       oFld:aDialogs[2]

      REDEFINE GET aoGet[ _CTAGAS ] VAR aTemp[ _CTAGAS ] ;
         ID       360 ;
         IDTEXT   361 ;
         PICTURE  ( Replicate( "X", nLenSubcuentaContaplus() ) ) ;
         WHEN     ( nLenCuentaContaplus() != 0 .and. nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwChkSubcuenta( aoGet[ _CTAGAS ], aoGet[ _CTAGAS ]:oHelpText ) ) ;
         VALID    ( MkSubcuenta( aoGet[ _CTAGAS ], nil, aoGet[ _CTAGAS ]:oHelpText ) );
         OF       oFld:aDialogs[2]

      /*
      Tercera pestaña----------------------------------------------------------
      */

      oBrwRel                 := IXBrowse():New( oFld:aDialogs[3] )

      oBrwRel:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwRel:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwRel:cAlias          := dbfTmpRel
      oBrwRel:nMarqueeStyle   := 5

      with object ( oBrwRel:AddCol() )
         :cHeader          := "Código"
         :bEditValue       := {|| ( dbfTmpRel )->cCodRel }
         :nWidth           := 60
      end with

      with object ( oBrwRel:AddCol() )
         :cHeader          := "Agente"
         :bEditValue       := {|| cNbrAgent( ( dbfTmpRel )->cCodRel, dbfAge ) }
         :nWidth           := 240
      end with

      with object ( oBrwRel:AddCol() )
         :cHeader          := "% Comisión"
         :bEditValue       := {|| ( dbfTmpRel )->nComRel }
         :cEditPicture     := "@E 999.99"
         :nWidth           := 60
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      if nMode != ZOOM_MODE
         oBrwRel:bLDblClick   := {|| WinEdtRec( oBrwRel, bEdtRel, dbfTmpRel, aTemp[ _CCODAGE ] ) }
      end if

      oBrwRel:CreateFromResource( 310 )

      REDEFINE BUTTON ;
			ID 		501 ;
         OF       oFld:aDialogs[3] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinAppRec( oBrwRel, bEdtRel, dbfTmpRel, aTemp[ _CCODAGE ] ) )

      REDEFINE BUTTON ;
         ID       502 ;
         OF       oFld:aDialogs[3] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinEdtRec( oBrwRel, bEdtRel, dbfTmpRel, aTemp[ _CCODAGE ] ) )

      REDEFINE BUTTON ;
         ID       503 ;
         OF       oFld:aDialogs[3] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( dbDelRec( oBrwRel, dbfTmpRel ) )

      /*
      Botones------------------------------------------------------------------
      */

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( lPreSave( aTemp, aoGet, dbfAge, oBrw, oBrwLin, nMode, oDlg ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      if nMode != ZOOM_MODE
         oDlg:AddFastKey( VK_F5, {|| lPreSave( aTemp, aoGet, dbfAge, oBrw, oBrwLin, nMode, oDlg ) } )
      
         oDlg:AddFastKey( VK_F9, {|| oDetCamposExtra:Play( aTemp[ _CCODAGE ] ) } )

      endif

      oDlg:bStart := {|| EvalGet( aoGet, nMode ) }

   ACTIVATE DIALOG oDlg CENTER;
         ON INIT     ( EdtRecMenu( oDlg, aTemp ) ) ;

   oBmpGeneral:End()
   oBmpComisiones:End()

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Static Function EdtRecMenu( oDlg, aTemp )

   local oMenu

   MENU oMenu

      MENUITEM    "&1. Rotor"

         MENU

            MENUITEM "&1. Campos extra [F9]";
            MESSAGE  "Mostramos y rellenamos los campos extra para la familia" ;
            RESOURCE "form_green_add_16" ;
            ACTION   ( oDetCamposExtra:Play( aTemp[ _CCODAGE ] ) )

         ENDMENU

   ENDMENU

   oDlg:SetMenu( oMenu )

Return ( oMenu )

//--------------------------------------------------------------------------//

Static Function lPreEdit( aTmp, nMode )

   local lErrors  := .f.
   local cDbfCom  := "AgeCom"
   local cDbfRel  := "AgeRel"
   local cCodAge  := aTmp[ _CCODAGE ]
   local oError
   local oBlock

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      cTmpCom     := cGetNewFileName( cPatTmp() + cDbfCom )

      /*
      Primero Crear la base de datos local
      */

      dbCreate( cTmpCom, aSqlStruct( aItmCom() ), cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), cTmpCom, cCheckArea( cDbfCom, @dbfTmpCom ), .f. )
      ( dbfTmpCom )->( OrdCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfTmpCom )->( OrdCreate( cTmpCom, "nImpVta", "Str( nImpVta )", {|| Str( Field->nImpVta ) } ) )

      /*
      A¤adimos desde el fichero de lineas
      */

      if ( dbfAgeCom )->( dbSeek( cCodAge ) )
         while ( ( dbfAgeCom )->cCodAge == cCodAge .and. !( dbfAgeCom )->( eof() ) )
            dbPass( dbfAgeCom, dbfTmpCom, .t. )
            ( dbfAgeCom )->( dbSkip() )
         end while
      end if

      ( dbfTmpCom )->( dbGoTop() )

      cTmpRel     := cGetNewFileName( cPatTmp() + cDbfRel )

      /*
      Primero Crear la base de datos local
      */

      dbCreate( cTmpRel, aSqlStruct( aItmRel() ), cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), cTmpRel, cCheckArea( cDbfRel, @dbfTmpRel ), .f. )
      ( dbfTmpRel )->( OrdCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfTmpRel )->( OrdCreate( cTmpRel, "cCodRel", "cCodRel", {|| Field->cCodRel } ) )

      /*
      A¤adimos desde el fichero de lineas
      */

      if ( dbfAgeRel )->( dbSeek( cCodAge ) )
         while ( ( dbfAgeRel )->cCodAge == cCodAge .and. !( dbfAgeRel )->( eof() ) )
            dbPass( dbfAgeRel, dbfTmpRel, .t. )
            ( dbfAgeRel )->( dbSkip() )
         end while
      end if

      ( dbfTmpRel )->( dbGoTop() )

   RECOVER USING oError

      msgStop( "Imposible crear tablas temporales" + CRLF + ErrorMessage( oError ) )

      lPosEdit()

      lErrors     := .t.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lErrors )

//---------------------------------------------------------------------------//

Static Function lPosEdit( oBrwLin )

   if !Empty( oBrwLin )
      oBrwLin:CloseData()
   end if

   if !Empty( dbfTmpCom ) .and. ( dbfTmpCom )->( Used() )
      ( dbfTmpCom )->( dbCloseArea() )
   end if

   dbfTmpCom            := nil

   dbfErase( cTmpCom )

   if !Empty( dbfTmpRel ) .and. ( dbfTmpRel )->( Used() )
      ( dbfTmpRel )->( dbCloseArea() )
   end if

   dbfTmpRel            := nil

   dbfErase( cTmpRel )

Return .t.

//------------------------------------------------------------------------//

STATIC FUNCTION lPreSave( aTemp, aoGet, dbfAge, oBrw, oBrwLin, nMode, oDlg )

   if nMode == APPD_MODE .or. nMode == DUPL_MODE

      if Empty( aTemp[ _CCODAGE ] )
         MsgStop( "El código del agente no puede estar vacío." )
         aoGet[ _CCODAGE ]:SetFocus()
         Return nil
      end if

      if !NotValid( aoGet[ _CCODAGE ], dbfAge, .t., "0" )
         aoGet[ _CCODAGE ]:SetFocus()
         Return nil
      end if

   end if

   if Empty( aTemp[ _CNBRAGE ] )
      MsgStop( "El nombre del agente no puede estar vacío." )
      aoGet[ _CNBRAGE ]:SetFocus()
      Return nil
   end if

   CursorWait()

   oDlg:Disable()

   oMsgText( "Archivando" )

   /*
   RollBack en edici¢n de registros--------------------------------------------
	*/

   if nMode == EDIT_MODE

      while ( ( dbfAgeCom )->( dbSeek( aTemp[ _CCODAGE ] ) ) .and. !( dbfAgeCom )->( eof() ) )
         if dbLock( dbfAgeCom )
            ( dbfAgeCom )->( dbDelete() )
            ( dbfAgeCom )->( dbUnLock() )
         end if
      end while

      while ( ( dbfAgeRel )->( dbSeek( aTemp[ _CCODAGE ] ) ) .and. !( dbfAgeRel )->( eof() ) )
         if dbLock( dbfAgeRel )
            ( dbfAgeRel )->( dbDelete() )
            ( dbfAgeRel )->( dbUnLock() )
         end if
      end while

   end if

   /*
   Quitamos los filtros--------------------------------------------------------
   */

   oMsgProgress()
   oMsgProgress():SetRange( 0, ( dbfTmpCom )->( LastRec() ) )

	/*
   Tablas relacionadas---------------------------------------------------------
	*/

   ( dbfTmpCom )->( dbGoTop() )
   while ( dbfTmpCom )->( !eof() )
      dbPass( dbfTmpCom, dbfAgeCom, .t., aTemp[ _CCODAGE ] )
      ( dbfTmpCom )->( dbSkip() )
      oMsgProgress():Deltapos( 1 )
   end while

   ( dbfTmpRel )->( dbGoTop() )
   while ( dbfTmpRel )->( !eof() )
      dbPass( dbfTmpRel, dbfAgeRel, .t., aTemp[ _CCODAGE ] )
      ( dbfTmpRel )->( dbSkip() )
      oMsgProgress():Deltapos( 1 )
   end while

   /*
   Ahora escribimos en el fichero definitivo-----------------------------------
	*/

   WinGather( aTemp, aoGet, dbfAge, oBrw, nMode )

   dbCommitAll()

   oMsgText()

   lPosEdit( oBrwLin )

   EndProgress()

   oDlg:Enable()
   oDlg:End( IDOK )

   CursorWE()

Return ( .t. )

//---------------------------------------------------------------------------//

Static Function EdtDet( aTmp, aGet, dbfTmpCom, oBrw, bWhen, bValid, nMode )

	local oDlg

   /*
   Caja de dialogo-------------------------------------------------------------
   */

   DEFINE DIALOG oDlg RESOURCE "AgeDet"

      REDEFINE GET aGet[ ( dbfTmpCom )->( FieldPos( "nImpVta" ) ) ] ;
         VAR      aTmp[ ( dbfTmpCom )->( FieldPos( "nImpVta" ) ) ] ;
			ID 		100 ;
         PICTURE  PicOut() ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpCom )->( FieldPos( "nPctCom" ) ) ] ;
         VAR      aTmp[ ( dbfTmpCom )->( FieldPos( "nPctCom" ) ) ] ;
         ID       110 ;
         PICTURE  "@E 999.99" ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( WinGather( aTmp, nil, dbfTmpCom, oBrw, nMode ), oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
			ACTION 	( oDlg:end() )

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Static Function EdtRel( aTmp, aGet, dbfTmpRel, oBrw, cCodAge, bValid, nMode )

	local oDlg

   /*
   Caja de dialogo-------------------------------------------------------------
   */

   DEFINE DIALOG oDlg RESOURCE "AgeRel"

      REDEFINE GET aGet[ ( dbfTmpRel )->( FieldPos( "cCodRel" ) ) ] ;
         VAR      aTmp[ ( dbfTmpRel )->( FieldPos( "cCodRel" ) ) ] ;
			ID 		100 ;
         IDTEXT   101 ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAgentes( aGet[ ( dbfTmpRel )->( FieldPos( "cCodRel" ) ) ], aGet[ ( dbfTmpRel )->( FieldPos( "cCodRel" ) ) ]:oHelpText, .t., aTmp[ ( dbfTmpRel )->( FieldPos( "cCodRel" ) ) ] ) );
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lValidEdtRel( cCodAge, aTmp, aGet, dbfAge ) );
         PICTURE  "@!" ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpRel )->( FieldPos( "nComRel" ) ) ] ;
         VAR      aTmp[ ( dbfTmpRel )->( FieldPos( "nComRel" ) ) ] ;
         ID       110 ;
         PICTURE  "@E 999.99" ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( WinGather( aTmp, nil, dbfTmpRel, oBrw, nMode ), oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
			ACTION 	( oDlg:end() )

      oDlg:bStart := {|| aGet[ ( dbfTmpRel )->( FieldPos( "cCodRel" ) ) ]:lValid() }

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Static Function lValidEdtRel( cCodAge, aTmp, aGet, dbfAge )

   local nRec
   local nOrd
   local lVal  := .f.

   if Empty( aTmp[ ( dbfTmpRel )->( FieldPos( "cCodRel" ) ) ] )
      return .t.
   end if

   if ( cCodAge == aTmp[ ( dbfTmpRel )->( FieldPos( "cCodRel" ) ) ] )
      MsgStop( "No se puede relacionar un agente con el mismo" )
      return .f.
   end if

   nRec        := ( dbfAge )->( RecNo() )
   nOrd        := ( dbfAge )->( OrdSetFocus( "cCodAge" ) )

   if ( dbfAge )->( dbSeek( aTmp[ ( dbfTmpRel )->( FieldPos( "cCodRel" ) ) ] ) )
      aGet[ ( dbfTmpRel )->( FieldPos( "cCodRel" ) ) ]:oHelpText:cText( cNombreAgente( dbfAge ) )
      lVal     := .t.
   end if

   ( dbfAge )->( dbGoTo( nRec ) )
   ( dbfAge )->( OrdSetFocus( nOrd ) )

Return ( lVal )

//--------------------------------------------------------------------------//

FUNCTION BrwAgentes( oGet, oGet2, lRelacionado, cCodigoAgente )

	local oDlg
	local oBrw
   local oGet1
	local cGet1
   local oBlock
   local oError
   local nOrdAnt
   local oCbxOrd
   local aCbxOrd
   local cCbxOrd
   local aStatus
   local nLevelUsr
   local cReturn        := ""

   aCbxOrd              := { "Código", "Apellidos", "Nombre" }

   nOrdAnt              := GetBrwOpt( "BrwAgentes" )
   nOrdAnt              := Min( Max( nOrdAnt, 1 ), len( aCbxOrd ) )

   cCbxOrd              := aCbxOrd[ nOrdAnt ]

   nLevelUsr            := nLevelUsr( "01033" )

   DEFAULT lRelacionado := .f.

   if lRelacionado

      if !lOpenFiles
         Return ( .f. )
      else

         aStatus        := aGetStatus( dbfAge )
         ( dbfAge )->( dbSetFilter( {|| Field->cCodAge != cCodigoAgente }, "cCodAge" ) )
         ( dbfAge )->( dbGoTop() )

      end if

   else

      if !OpenFiles()
         Return ( .f. )
      end if

   end if

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if ( "PDA" $ cParamsMain() )
   DEFINE DIALOG oDlg RESOURCE "HELPENTRY_PDA"  TITLE "Seleccionar agentes"
   else
   DEFINE DIALOG oDlg RESOURCE "HELPENTRY"      TITLE "Seleccionar agentes"
   end if

		REDEFINE GET oGet1 VAR cGet1;
			ID 		104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfAge ) );
         VALID    ( OrdClearScope( oBrw, dbfAge ) );
         BITMAP   "FIND" ;
         OF       oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( ( dbfAge )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:refresh(), oGet1:SetFocus() ) ;
			OF oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfAge
      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "Browse.Agentes"

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodAge"
         :bEditValue       := {|| ( dbfAge )->cCodAge }
         :nWidth           := 60
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Apellidos"
         :cSortOrder       := "cApeAge"
         :bEditValue       := {|| ( dbfAge )->cApeAge }
         :nWidth           := 225
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNbrAge"
         :bEditValue       := {|| ( dbfAge )->cNbrAge }
         :nWidth           := 225
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }
      oBrw:bRClicked       := {| nRow, nCol, nFlags | oBrw:RButtonDown( nRow, nCol, nFlags ) }

      oBrw:CreateFromResource( 105 )

		REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         ACTION   ( oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

   if !( "PDA" $ cParamsMain() )

		REDEFINE BUTTON ;
			ID 		500 ;
			OF 		oDlg ;
         WHEN     ( nAnd( nLevelUsr, ACC_APPD ) != 0 .and. !IsReport() .and. !lRelacionado );
         ACTION   ( WinAppRec( oBrw, bEdit, dbfAge ) )

		REDEFINE BUTTON ;
			ID 		501 ;
			OF 		oDlg ;
         WHEN     ( nAnd( nLevelUsr, ACC_EDIT ) != 0 .and. !IsReport() .and. !lRelacionado );
         ACTION   ( WinEdtRec( oBrw, bEdit, dbfAge ) )

      if nAnd( nLevelUsr, ACC_APPD ) != 0 .and. !IsReport() .and. !lRelacionado
         oDlg:AddFastKey( VK_F2, {|| WinAppRec( oBrw, bEdit, dbfAge ) } )
      end if

      if nAnd( nLevelUsr, ACC_EDIT ) != 0 .and. !IsReport() .and. !lRelacionado
         oDlg:AddFastKey( VK_F3, {|| WinEdtRec( oBrw, bEdit, dbfAge ) } )
      end if

   end if

   oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )
   oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )

   oDlg:bStart                := {|| oBrw:Load() }

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK

      cReturn                 := ( dbfAge )->cCodAge

      if !Empty( oGet )
         oGet:cText( ( dbfAge )->cCodAge )
      end if

      if IsObject( oGet2 )
         oGet2:cText( RTrim( ( dbfAge )->cApeAge ) + ", " + ( dbfAge )->cNbrAge )
      end if

   end if

   DestroyFastFilter( dbfAge )

   SetBrwOpt( "BrwAgentes", ( dbfAge )->( OrdNumber() ) )

   if lRelacionado

      ( dbfAge )->( dbClearFilter() )

      SetStatus( dbfAge, aStatus )

   else

      CloseFiles()

   end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !Empty( oGet )
      oGet:SetFocus()
   end if

Return ( cReturn )

//---------------------------------------------------------------------------//

FUNCTION RetNbrAge( cCodAge, dbfAge )

   local oBlock
   local oError
   local nRecNo
	local nOrdAnt
	local cNombre	:= ""
   local lClose   := .f.

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if Empty( dbfAge )
      USE ( cPatCli() + "AGENTES.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AGENTES", @dbfAge ) )
      SET ADSINDEX TO ( cPatCli() + "AGENTES.CDX" ) ADDITIVE
      lClose      := .t.
   end if

   nRecNo         := (dbfAge)->( RecNo() )
   nOrdAnt        := (dbfAge)->( OrdSetFocus( 1 ) )

   IF (dbfAge)->( DbSeek( cCodAge ) )
      cNombre     := Rtrim( (dbfAge)->CNBRAGE ) + " " + (dbfAge)->CAPEAGE
	END IF

   (dbfAge)->( dbGoTo( nRecNo ) )
   (dbfAge)->( OrdSetFocus( nOrdAnt ) )

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos de agentes" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

	IF lClose
      CLOSE ( dbfAge )
	END IF

RETURN ( cNombre )

//---------------------------------------------------------------------------//

FUNCTION aAgentesRelacionados( cCodAge, dbfAgeRel )

   local nOrd
   local oBlock
   local oError
   local aAgentes    := {}

   if IsObject( cCodAge )
      cCodAge        := cCodAge:VarGet()
   end if

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   nOrd              := ( dbfAgeRel )->( ordSetFocus( "cCodRel" ) )

   if ( dbfAgeRel )->( dbSeek( cCodAge ) )
      while ( ( dbfAgeRel )->cCodRel == cCodAge ) .and. !( dbfAgeRel )->( eof() )
         aAdd( aAgentes, { ( dbfAgeRel )->cCodAge, ( dbfAgeRel )->nComRel } )
         ( dbfAgeRel )->( dbSkip() )
      end while
   end if

   ( dbfAgeRel )->( ordSetFocus( nOrd ) )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible obtener los agentes relacionados" )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( aAgentes )

//----------------------------------------------------------------------------//

Static Function aAgentes( cCodAge, uAgentes, dbfAge )

   local oNode
   local nRecNo
	local nOrdAnt

   nRecNo            := ( dbfAge )->( RecNo() )
   nOrdAnt           := ( dbfAge )->( OrdSetFocus( "cAgeRel" ) )

   if ( dbfAge )->( dbSeek( cCodAge ) ) .and. ( dbfAge )->cAgeRel != ( dbfAge )->cCodAge

      while ( dbfAge )->cAgeRel == cCodAge .and. !( dbfAge )->( eof() )

         do case
            case isObject( uAgentes )

               oNode := uAgentes:Add( cNombreAgente( dbfAge ) + Space( 1 ) + "[" + Trans( ( dbfAge )->nComRel, "@E 99.99" ) + "% ]" )

               aAgentes( ( dbfAge )->cCodAge, oNode, dbfAge )

            case isArray( uAgentes )

               aAdd( uAgentes, { ( dbfAge )->cCodAge, ( dbfAge )->nComRel } )

               aAgentes( ( dbfAge )->cCodAge, uAgentes, dbfAge )

         end case

         ( dbfAge )->( dbSkip() )

      end while

   end if

   ( dbfAge )->( dbGoTo( nRecNo ) )
   ( dbfAge )->( OrdSetFocus( nOrdAnt ) )

RETURN ( uAgentes )

//----------------------------------------------------------------------------//

#else

//----------------------------------------------------------------------------//
//Funciones para PDA
//----------------------------------------------------------------------------//ç

FUNCTION pdaBrwAgentes( oGet, oGet2 )

   local oDlg
   local oSayTit
   local oBtn
   local oFont
	local oBrw
   local oBlock
   local oError
	local oGet1
	local cGet1
   local nOrdAnt
   local oCbxOrd
   local aCbxOrd
   local cCbxOrd
   local nLevelUsr
   local dbfAgente

   aCbxOrd           := { "Código", "Agente" }
   nOrdAnt           := GetBrwOpt( "BrwAgentes" )
   nLevelUsr         := nLevelUsr( "01033" )
   nOrdAnt           := Min( Max( nOrdAnt, 1 ), len( aCbxOrd ) )
   cCbxOrd           := aCbxOrd[ nOrdAnt ]

   USE ( cPatCli() + "AGENTES.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AGENTES", @dbfAgente ) )
   SET ADSINDEX TO ( cPatCli() + "AGENTES.CDX" ) ADDITIVE

   USE ( cPatCli() + "AGECOM.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AGECOM", @dbfAgeCom ) )
   SET ADSINDEX TO ( cPatCli() + "AGECOM.CDX" ) ADDITIVE

   USE ( cPatCli() + "AgeRel.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AgeRel", @dbfAgeRel ) )
   SET ADSINDEX TO ( cPatCli() + "AgeRel.CDX" ) ADDITIVE

   DEFINE FONT oFont NAME "Verdana" SIZE 0, -14

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY_PDA"  TITLE "Seleccionar agentes"

      REDEFINE SAY oSayTit ;
         VAR      "Buscando agentes" ;
         ID       110 ;
         COLOR    "N/W*" ;
         FONT     oFont ;
         OF       oDlg

      REDEFINE BTNBMP oBtn ;
         ID       100 ;
         OF       oDlg ;
         FILE     ( cPatBmp() + "security_agent.bmp" ) ;
         NOBORDER ;
         ACTION      ( nil )

      oBtn:SetColor( 0, nRGB( 255, 255, 255 )  )

		REDEFINE GET oGet1 VAR cGet1;
			ID 		104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfAgente ) );
         VALID    ( OrdClearScope( oBrw, dbfAgente ) );
			COLOR 	CLR_GET ;
			OF 		oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( ( dbfAgente )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrwLin:refresh(), oGet1:SetFocus(), oCbxOrd:refresh() ) ;
			OF oDlg

       REDEFINE IBROWSE oBrw ;
         FIELDS ;
                  ( dbfAgente )->CCODAGE + CRLF + RTrim( ( dbfAgente )->CAPEAGE ) + ", " + ( dbfAgente )->CNBRAGE ;
         HEAD ;
                  "Código" + CRLF + "Agente" ;
         FIELDSIZES ;
                  180;
         JUSTIFY  .f.;
         ID       105 ;
         ALIAS    ( dbfAgente ) ;
         OF       oDlg

   ACTIVATE DIALOG oDlg ;
      ON INIT ( oDlg:SetMenu( pdaMenuEdtRec( oDlg , dbfAgente , oGet , oGet2 ) ) )

   if oDlg:nResult == IDOK

      oGet:cText( ( dbfAgente )->CCODAGE )

      if ValType( oGet2 ) == "O"
         oGet2:cText( RTrim( ( dbfAgente )->CAPEAGE ) + ", " + ( dbfAgente )->CNBRAGE )
      end if

   end if

   //SetKey( VK_RETURN, {|| oDlg:End( IDOK ) } )

   DestroyFastFilter( dbfAgente )

   SetBrwOpt( "BrwAgentes", ( dbfAgente )->( OrdNumber() ) )

   CLOSE( dbfAgente )
   CLOSE( dbfAgeCom )
   CLOSE( dbfAgeRel )

   oGet:setFocus()

Return ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

static function pdaMenuEdtRec( oDlg , dbfAgente , oGet , oGet2 )

   local oMenu

   DEFINE MENU oMenu ;
      RESOURCE 100 ;
      BITMAPS  10 ; // bitmaps resoruces ID
      IMAGES   3     // number of images in the bitmap

      REDEFINE MENUITEM ID 110 OF oMenu ACTION ( oDlg:End( IDOK ) )

      REDEFINE MENUITEM ID 120 OF oMenu ACTION ( oDlg:End( IDCANCEL ) )

Return oMenu

//---------------------------------------------------------------------------//

#endif

CLASS pdaAgentesSenderReciver

   Method CreateData()

END CLASS

//----------------------------------------------------------------------------//

Method CreateData( oPgrActual, oSayStatus, cPatPreVenta ) CLASS pdaAgentesSenderReciver

   local dbfAge
   local tmpAge
   local lExist      := .f.
   local cFileName
   local cPatPc      := if( Empty( cPatPreVenta ), cPatPc(), cPatPreVenta )

   USE ( cPatCli() + "Agentes.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "Agentes", @dbfAge ) )
   SET ADSINDEX TO ( cPatCli() + "AGENTES.Cdx" ) ADDITIVE

   dbUseArea( .t., cDriver(), cPatPc + "Agentes.Dbf", cCheckArea( "Agentes", @tmpAge ), .t. )
   ( tmpAge )->( ordListAdd( cPatPc + "AGENTES.Cdx" ) )

   if !Empty( oPgrActual )
      oPgrActual:SetRange( 0, ( tmpAge )->( OrdKeyCount() ) )
   end if

   ( tmpAge )->( dbGoTop() )

   while !( tmpAge )->( eof() )

      if ( dbfAge )->( dbSeek( ( tmpAge )->cCodAge ) )
         dbPass( tmpAge, dbfAge, .f. )
      else
         dbPass( tmpAge, dbfAge, .t. )
      end if

      if dbLock( tmpAge )
         ( tmpAge )->lSelAge  := .f.
         ( tmpAge )->( dbUnLock() )
      end if

      ( tmpAge )->( dbSkip() )

      if !Empty( oSayStatus )
         oSayStatus:SetText( "Sincronizando Agentes " + Alltrim( Str( ( tmpAge )->( OrdKeyNo() ) ) ) + " de " + Alltrim( Str( ( tmpAge )->( OrdKeyCount() ) ) ) )
      end if

      SysRefresh()

      if !Empty( oPgrActual )
         oPgrActual:SetPos( ( tmpAge )->( OrdKeyNo() ) )
      end if

      SysRefresh()

   end while

   CLOSE ( tmpAge )
   CLOSE ( dbfAge )

Return ( Self )

//---------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//Funciones comunes del programa y del pda
//----------------------------------------------------------------------------//

Function IsAgentes()

   local oError
   local oBlock
   local dbfAgente

   if !lExistTable( cPatCli() + "Agentes.Dbf" )
      mkAgentes( cPatCli() )
   end if

   if !lExistIndex( cPatCli() + "Agentes.Cdx" )
      rxAgentes( cPatCli() )
   end if

   oBlock                     := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      USE ( cPatCli() + "Agentes.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CCODAGE", @dbfAge ) )
      SET ADSINDEX TO ( cPatCli() + "Agentes.Cdx" ) ADDITIVE

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE ( dbfAge )

Return ( .t. )

//----------------------------------------------------------------------------//

FUNCTION mkAgentes( cPath, lAppend, cPathOld, oMeter )

   DEFAULT lAppend   := .f.
   DEFAULT cPath     := cPatCli()

   if oMeter != nil
		oMeter:cText	:= "Generando Bases"
		sysrefresh()
   end if

   if !lExistTable( cPath + "Agentes.Dbf" )
      dbCreate( cPath + "Agentes.Dbf", aSqlStruct( aItmAge() ), cDriver() )
   end if

   if !lExistTable( cPath + "AgeCom.Dbf" )
      dbCreate( cPath + "AgeCom.Dbf", aSqlStruct( aItmCom() ), cDriver() )
   end if

   if !lExistTable( cPath + "AgeRel.Dbf" )
      dbCreate( cPath + "AgeRel.Dbf", aSqlStruct( aItmRel() ), cDriver() )
   end if

	rxAgentes( cPath, oMeter )

   if lAppend .and. lIsDir( cPathOld )
      appDbf( cPathOld, cPath, "Agentes" )
      appDbf( cPathOld, cPath, "AgeCom" )
      appDbf( cPathOld, cPath, "AgeRel" )
   end if

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION rxAgentes( cPath, oMeter )

   local dbfAge

   DEFAULT cPath  := cPatCli()

   if !lExistTable( cPath + "Agentes.Dbf" ) .or. !lExistTable( cPath + "AgeCom.Dbf" ) .or. !lExistTable( cPath + "AgeRel.Dbf" )
		mkAgentes( cPath, , , oMeter )
   end if

   fEraseIndex( cPath + "Agentes.Cdx" )
   fEraseIndex( cPath + "AgeCom.Cdx" )
   fEraseIndex( cPath + "AgeRel.Cdx" )

   dbUseArea( .t., cDriver(), cPath + "AGENTES.DBF", cCheckArea( "AGENTES", @dbfAge ), .f. )

   if !( dbfAge )->( neterr() )
      ( dbfAge )->( __dbPack() )

      ( dbfAge )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfAge )->( ordCreate( cPath + "AGENTES.CDX", "CCODAGE", "CCODAGE", {|| Field->cCodAge } ) )

      ( dbfAge )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfAge )->( ordCreate( cPath + "AGENTES.CDX", "CAPEAGE", "CAPEAGE", {|| Field->cApeAge } ) )

      ( dbfAge )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfAge )->( ordCreate( cPath + "AGENTES.CDX", "CNBRAGE", "CNBRAGE", {|| Field->cNbrAge } ) )

      ( dbfAge )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfAge )->( ordCreate( cPath + "AGENTES.CDX", "CAGEREL", "CAGEREL", {|| Field->cAgeRel } ) )

      ( dbfAge )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de agentes" )
   end if

   dbUseArea( .t., cDriver(), cPath + "AGECOM.DBF", cCheckArea( "AGENTES", @dbfAge ), .f. )

   if !( dbfAge )->( neterr() )
      ( dbfAge )->( __dbPack() )

      ( dbfAge )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfAge )->( ordCreate( cPath + "AGECOM.CDX", "CCODAGE", "cCodAge + Str( nImpVta )", {|| Field->cCodAge + Str( Field->nImpVta ) } ) )

      ( dbfAge )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de agentes" )
   end if

   dbUseArea( .t., cDriver(), cPath + "AgeRel.Dbf", cCheckArea( "AGENTES", @dbfAge ), .f. )

   if !( dbfAge )->( neterr() )
      ( dbfAge )->( __dbPack() )

      ( dbfAge )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfAge )->( ordCreate( cPath + "AgeRel.Cdx", "cCodAge", "cCodAge + cCodRel", {|| Field->cCodAge + Field->cCodRel } ) )

      ( dbfAge )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfAge )->( ordCreate( cPath + "AgeRel.Cdx", "cCodRel", "cCodRel", {|| Field->cCodRel } ) )

      ( dbfAge )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de agentes" )
   end if

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION aItmAge()

   local aBase := {  { "cCodAge",   "C",  3,  0, "Código del agente" ,        "",            "", "( cDbfAge )" },;
                     { "cApeAge",   "C",100,  0, "Apellidos del agente" ,     "'@!'",        "", "( cDbfAge )" },;
                     { "cNbrAge",   "C",100,  0, "Nombre del agente" ,        "'@!'",        "", "( cDbfAge )" },;
                     { "cDniNif",   "C", 15,  0, "DNI del agente" ,           "'@!'",        "", "( cDbfAge )" },;
                     { "cDirAge",   "C", 35,  0, "Domicilio del agente" ,     "'@!'",        "", "( cDbfAge )" },;
                     { "cPobAge",   "C", 25,  0, "Población del agente" ,     "'@!'",        "", "( cDbfAge )" },;
                     { "cProv",     "C", 15,  0, "Provincia del agente" ,     "'@!'",        "", "( cDbfAge )" },;
                     { "cPtlAge",   "C",  5,  0, "Código postal del agente" , "'@!'",        "", "( cDbfAge )" },;
                     { "cTfoAge",   "C", 12,  0, "Teléfono del agente" ,      "",            "", "( cDbfAge )" },;
                     { "cFaxAge",   "C", 12,  0, "Fax del agente" ,           "",            "", "( cDbfAge )" },;
                     { "cMovAge",   "C", 12,  0, "Teléfono movíl del agente" ,"",            "", "( cDbfAge )" },;
                     { "nIrpfAge",  "N",  5,  2, "IRPF del agente" ,          "'@E 99.99'",  "", "( cDbfAge )" },;
                     { "mComEnt",   "M", 10,  0, "Comentarios" ,              "",            "", "( cDbfAge )" },;
                     { "lSelAge",   "L",  1,  0, "Seleccionar el agente" ,    "",            "", "( cDbfAge )" },;
                     { "nCom1",     "N",  6,  2, "Comisión del agente" ,      "'@E 99.99'",  "", "( cDbfAge )" },;
                     { "cMailAge",  "C",120,  0, "Email del agente" ,         "",            "", "( cDbfAge )" },;
                     { "cAgeRel",   "C",  3,  0, "Código del agente relacionado" ,     "",   "", "( cDbfAge )" },;
                     { "nComRel",   "N",  6,  2, "Comisión del agente relacionado" ,   "",   "", "( cDbfAge )" },;
                     { "CtaAge",    "C", 12,  0, "Código subcuenta agente",   "",            "", "( cDbfAge )" },;
                     { "CtaGas",    "C", 12,  0, "Código subcuenta gasto",    "",            "", "( cDbfAge )" },;
                     { "cCodPrv",   "C", 12,  0, "Código de proveedor",       "",            "", "( cDbfAge )" },;
                     { "cCodArt",   "C", 18,  0, "Código de artículo",        "",            "", "( cDbfAge )" },;
                     { "nComTar1",  "N",  6,  2, "Comisión de la tarifa 1" ,  "'@E 99.99'",  "", "( cDbfAge )" },;
                     { "nComTar2",  "N",  6,  2, "Comisión de la tarifa 2" ,  "'@E 99.99'",  "", "( cDbfAge )" },;
                     { "nComTar3",  "N",  6,  2, "Comisión de la tarifa 3" ,  "'@E 99.99'",  "", "( cDbfAge )" },;
                     { "nComTar4",  "N",  6,  2, "Comisión de la tarifa 4" ,  "'@E 99.99'",  "", "( cDbfAge )" },;
                     { "nComTar5",  "N",  6,  2, "Comisión de la tarifa 5" ,  "'@E 99.99'",  "", "( cDbfAge )" },;
                     { "nComTar6",  "N",  6,  2, "Comisión de la tarifa 6" ,  "'@E 99.99'",  "", "( cDbfAge )" } }

RETURN ( aBase )

//----------------------------------------------------------------------------//

FUNCTION aItmCom()

   local aBase := {  { "cCodAge",   "C",  3,  0, "Código del agente" ,        "",            "", "( cDbfAge )" },;
                     { "nImpVta",   "N", 16,  6, "Importe de venta" ,         "",            "", "( cDbfAge )" },;
                     { "nPctCom",   "N",  6,  2, "Porcentaje de comisión" ,   "",            "", "( cDbfAge )" } }

RETURN ( aBase )

//--------------------------------------------------------------------------//

FUNCTION aItmRel()

   local aBase := {  { "cCodAge",   "C",  3,  0, "Código del agente" ,        "",            "", "( cDbfAge )" },;
                     { "cCodRel",   "C",  3,  0, "Código del agente relacionado" , "",       "", "( cDbfAge )" },;
                     { "nComRel",   "N",  6,  2, "Porcentaje de comisión" ,   "",            "", "( cDbfAge )" } }

RETURN ( aBase )

//--------------------------------------------------------------------------//

FUNCTION cAgentes( oGet, dbfAge, oGet2, oGetPct )

   local nRec
   local oBlock
   local oError
   local xValor
   local lClose      := .f.
   local lValid      := .f.

   if Empty( oGet:varGet() ) .or. ( oGet:varGet() == "ZZZ" )

      if isObject( oGet2 )
			oGet2:cText( "" )
      end if

      if isObject( oGetPct )
			oGetPct:cText( 0 )
      end if

      return .t.

   else

      xValor         := RJustObj( oGet, "0" )

   end if

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if Empty( dbfAge )
      USE ( cPatCli() + "AGENTES.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AGENTES", @dbfAge ) )
      SET ADSINDEX TO ( cPatCli() + "AGENTES.CDX" ) ADDITIVE
      lClose         := .t.
   else
      nRec           := ( dbfAge )->( Recno() )
   end if

   if dbSeekInOrd( xValor, "cCodAge", dbfAge )

      if isObject( oGet2 )
         oGet2:cText( RTrim( ( dbfAge )->cApeAge ) + ", " + ( dbfAge )->cNbrAge )
      end if

      if isObject( oGetPct )
         oGetPct:cText( ( dbfAge )->nCom1 )
      end if

      lValid         := .t.

   else

      msgStop( "Agente no encontrado", "Código " + xValor )

   end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos de agentes" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if lClose
      CLOSE( dbfAge )
   else
      ( dbfAge )->( dbGoTo( nRec ) )
   end if

RETURN lValid

//---------------------------------------------------------------------------//

FUNCTION cNbrAgent( cCodAge, dbfAge )

   local nRec
   local nOrd
   local oBlock
   local oError
   local xValRet  := ""
   local lClose   := .f.

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if Empty( dbfAge )
      USE ( cPatCli() + "AGENTES.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AGENTES", @dbfAge ) )
      SET ADSINDEX TO ( cPatCli() + "AGENTES.CDX" ) ADDITIVE
      lClose      := .t.
   end if

   do case
      case IsChar( dbfAge )

         nRec     := ( dbfAge )->( RecNo() )
         nOrd     := ( dbfAge )->( OrdSetFocus( "cCodAge" ) )

         if ( dbfAge )->( dbSeek( cCodAge ) )
            xValRet  := cNombreAgente( dbfAge )
         end if

         nRec     := ( dbfAge )->( dbGoTo( nRec ) )
         nOrd     := ( dbfAge )->( OrdSetFocus( nOrd ) )

      case IsObject( dbfAge )

         dbfAge:GetStatus()

         if dbfAge:Seek( cCodAge )
            xValRet  := cNombreAgente( dbfAge )
         end if

         dbfAge:SetStatus()

   end case

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos de agentes" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if lClose
      CLOSE ( dbfAge )
   end if

Return xValRet

//---------------------------------------------------------------------------//

FUNCTION cNombreAgente( uAge )

   local xValRet     := ""

   do case
      case IsChar( uAge )

         xValRet     := if( !Empty( ( uAge )->cApeAge ), Rtrim( ( uAge )->cApeAge ) + ", ", "" ) + ( uAge )->cNbrAge

      case IsObject( uAge )

         xValRet     := if( !Empty( uAge:cApeAge ), Rtrim( uAge:cApeAge ) + ", ", "" ) + uAge:cNbrAge

      case IsArray( uAge )

         xValRet     := if( !Empty( uAge[ _CAPEAGE ] ), Rtrim( uAge[ _CNBRAGE ] ) + ", ", "" ) + uAge[ _CNBRAGE ]

   end case

Return ( Alltrim( xValRet ) )

//---------------------------------------------------------------------------//

FUNCTION nComisionAgenteTarifa( cCodigoAgente, nTarifaPrecio, nView )

   local nComisionAgente   := 0

   if empty( cCodigoAgente )
      Return ( nComisionAgente )
   end if

   D():getStatus( "Agentes", nView )

   if dbSeekInOrd( cCodigoAgente, "cCodAge", D():Agentes( nView ) )
      nComisionAgente      := ( D():Agentes( nView ) )->( fieldGet( fieldpos( "nComTar" + str( nTarifaPrecio, 1 ) ) ) )
   else
      msgStop( "Agente no encontrado", "Código " + cCodigoAgente )
   end if

   D():setStatus( "Agentes", nView )

RETURN ( nComisionAgente )

//---------------------------------------------------------------------------//
/*
Funcion para editar un agente desde cualquier parte del programa
*/

FUNCTION EdtAge( cCodAge )

   local nLevel         := nLevelUsr( "01033" )

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_EDIT ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if OpenFiles()

      if dbSeekInOrd( cCodAge, "cCodAge", dbfAge )
         WinEdtRec( nil, bEdit, dbfAge )
      end if

      CloseFiles()

   end if

RETURN .t.

//---------------------------------------------------------------------------//

Static Function OpenFiles()

   local oError
   local oBlock

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      USE ( cPatCli() + "AGENTES.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AGENTES", @dbfAge ) )
      SET ADSINDEX TO ( cPatCli() + "AGENTES.CDX" ) ADDITIVE

      USE ( cPatCli() + "AgeCom.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AgeCom", @dbfAgeCom ) )
      SET ADSINDEX TO ( cPatCli() + "AgeCom.Cdx" ) ADDITIVE

      USE ( cPatCli() + "AgeRel.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AgeRel", @dbfAgeRel ) )
      SET ADSINDEX TO ( cPatCli() + "AgeRel.CDX" ) ADDITIVE

      USE ( cPatPrv() + "PROVEE.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROVEE", @dbfProvee ) )
      SET ADSINDEX TO ( cPatPrv() + "PROVEE.CDX" ) ADDITIVE

      USE ( cPatArt() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
      SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

      oDetCamposExtra      := TDetCamposExtra():New()
      oDetCamposExtra:OpenFiles()
      oDetCamposExtra:SetTipoDocumento( "Agentes" )

      lOpenFiles        := .t.

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos de agentes" )

      CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lOpenFiles )

//----------------------------------------------------------------------------//

Static Function CloseFiles()

   if !Empty( dbfAge )
      ( dbfAge )->( dbCloseArea() )
   end if

   if !Empty( dbfAgeCom )
      ( dbfAgeCom )->( dbCloseArea() )
   end if

   if !Empty( dbfAgeRel )
      ( dbfAgeRel )->( dbCloseArea() )
   end if

   if !Empty( dbfProvee )
      ( dbfProvee )->( dbCloseArea() )
   end if

   if !Empty( dbfArticulo )
      ( dbfArticulo )->( dbCloseArea() )
   end if

   if !Empty( oDetCamposExtra )
      oDetCamposExtra:CloseFiles()
   end if

   dbfAge      := nil
   dbfAgeCom   := nil
   dbfAgeRel   := nil
   dbfProvee   := nil
   dbfArticulo := nil

   oWndBrw     := nil

Return ( .t. )

//----------------------------------------------------------------------------//

Function lGetAgente( oGetAgente, dbfAgente )

   local oDlg
   local oBmpUsuario
   local oSayUsuario
   local oCodigoAgente
   local cCodigoAgente := Space( 3 )
   local oNombreAgente
   local cNombreAgente := ""

   if !lRecogerAgentes()
      Return .t.
   end if

   DEFINE DIALOG oDlg RESOURCE "GetUsuario" TITLE "Introduzca agente"

      REDEFINE BITMAP oBmpUsuario ;
         ID       500 ;
         RESOURCE "Security_Agent_48_Alpha" ;
         TRANSPARENT ;
         OF       oDlg

      REDEFINE SAY oSayUsuario ;
         VAR      "Agentes" ;
         ID       510 ;
         OF       oDlg

      REDEFINE GET oCodigoAgente ;
         VAR      cCodigoAgente ;
         ID       100 ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAgentes( oCodigoAgente ) ) ;
         VALID    ( SetAgentes( oCodigoAgente, oNombreAgente, oDlg, dbfAgente ) ) ;
         OF       oDlg

      REDEFINE GET oNombreAgente ;
         VAR      cNombreAgente ;
         ID       110 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( if( oCodigoAgente:lValid(), oDlg:end( IDOK ), ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      oDlg:bStart       := { || oCodigoAgente:SetFocus(), oCodigoAgente:SelectAll() }
      oDlg:bKeyDown     := { | nKey | if( nKey == 65 .and. GetKeyState( VK_CONTROL ), CreateInfoArticulo(), 0 ) }

   ACTIVATE DIALOG oDlg CENTER

   oBmpUsuario:End()

   if oDlg:nResult == IDOK

      oCodigoAgente:cText( cCodigoAgente )
      oCodigoAgente:lValid()

      if !Empty( oGetAgente )
         oGetAgente:cText( cCodigoAgente )
         oGetAgente:lValid()
      end if

   end if

Return ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Function SetAgentes( oCodigoAgente, oSay, oDlg, dbfAgente )

   local lSetAgente  := .t.
   local cCodAgente  := oCodigoAgente:VarGet()

   if dbSeekInOrd( cCodAgente, "cCodAge", dbfAgente )
      oSay:cText( Rtrim( cNombreAgente( dbfAgente ) ) )
      if !Empty( oDlg )
         oDlg:End( IDOK )
      end if
   else
      oCodigoAgente:cText( Space( 3 ) )
      lSetAgente     := .f.
   end if

Return ( lSetAgente )

//---------------------------------------------------------------------------//
