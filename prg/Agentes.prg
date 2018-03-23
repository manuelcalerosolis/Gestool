#include "FiveWin.Ch"
#include "Font.ch"
#include "Report.ch"
#include "Xbrowse.ch"
#include "Factu.ch" 

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
#define _CTAAGE                  19      //   C     12,    0, "Código subcuenta agente",   "",            "", "( cDbfAge )" },;
#define _CTAGAS                  20      //   C     12,    0, "Código subcuenta gasto",    "",            "", "( cDbfAge )" } }
#define _CCODPRV                 21      //   C     12,    0
#define _CCODART                 22      //   C     12,    0
#define _NCOMTAR1                23      //   N      5     2
#define _NCOMTAR2                24      //   N      5     2
#define _NCOMTAR3                25      //   N      5     2
#define _NCOMTAR4                26      //   N      5     2
#define _NCOMTAR5                27      //   N      5     2
#define _NCOMTAR6                28      //   N      5     2

#define fldGeneral               oFld:aDialogs[1]
#define fldComisiones            oFld:aDialogs[2]
#define fldTarifas               oFld:aDialogs[3]
#define fldRelaciones            oFld:aDialogs[4]

static oWndBrw

static cAgentesComisiones
static cAgentesRelaciones
static cAgentesAtipicas

static cOldCodigoAgente          := ""
static nOldPctComision           := 0

static lOpenFiles                := .f.

static bEdit                     := { |aTmp, aoGet, dbfAge, oBrw, bWhen, bValid, nMode | EdtRec( aTmp, aoGet, dbfAge, oBrw, bWhen, bValid, nMode ) }
static bEdtDet                   := { |aTmp, aoGet, dbfAge, oBrw, bWhen, bValid, nMode | EdtDet( aTmp, aoGet, dbfAge, oBrw, bWhen, bValid, nMode ) }
static bEdtRel                   := { |aTmp, aoGet, dbfAge, oBrw, cCodAge, bValid, nMode | EdtRel( aTmp, aoGet, dbfAge, oBrw, cCodAge, bValid, nMode ) }
static bEdicionTarifa            := { |aTmp, aoGet, dbfAge, oBrw, cCodAge, bValid, nMode | EdtRel( aTmp, aoGet, dbfAge, oBrw, cCodAge, bValid, nMode ) }

static dbfAge

static oDetCamposExtra

static tmpAgentesComisiones
static tmpAgentesRelaciones
static tmpAgentesTarifas

static nView

//----------------------------------------------------------------------------//
//Funciones del programa
//----------------------------------------------------------------------------//

FUNCTION Agentes( oMenuItem, oWnd )

   local nLevel

   DEFAULT  oMenuItem   := "01033"
   DEFAULT  oWnd        := oWnd()

   if oWndBrw == NIL

   nLevel               := Auth():Level( oMenuItem )
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
      MRU      "gc_businessman2_16";
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

      oWndBrw:cHtmlHelp    := "Agentes"
      
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

      DEFINE BTNSHELL RESOURCE "IMP" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( InfAge():New( "Listado de agentes" ):Play() ) ;
         TOOLTIP  "(L)istado" ;
			HOTKEY 	"L"

      DEFINE BTNSHELL RESOURCE "END" GROUP OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:End() ) ;
         TOOLTIP  "(S)alir" ;
			HOTKEY 	"S"

      ACTIVATE WINDOW oWndBrw VALID ( CloseFiles() )

   end if

Return nil

//----------------------------------------------------------------------------//

Static Function OpenFiles()

   local oError
   local oBlock

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      nView             := D():CreateView()

      USE ( cPatCli() + "AGENTES.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AGENTES", @dbfAge ) )
      SET ADSINDEX TO ( cPatCli() + "AGENTES.CDX" ) ADDITIVE

      D():AgentesComisiones( nView )

      D():AgentesRelaciones( nView )

      D():Proveedores( nView )

      D():Familias( nView )

      D():Articulos( nView )   

      D():Atipicas( nView )
      ( D():Atipicas( nView ) )->( ordSetFocus( "cCodAge" ) )

      oDetCamposExtra   := TDetCamposExtra():New()
      oDetCamposExtra:OpenFiles()
      oDetCamposExtra:SetTipoDocumento( "Agentes" )
      oDetCamposExtra:setbId( {|| D():AgentesId( nView ) } )

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

   if !Empty( oDetCamposExtra )
      oDetCamposExtra:CloseFiles()
   end if

   D():DeleteView( nView )

   dbfAge                  := nil

   oWndBrw                 := nil

Return ( .t. )

//----------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aTemp, aoGet, dbfAge, oBrw, bWhen, bValid, nMode )

	local oDlg
   local oFld
   local oBrwLin
   local oBrwRel
   local oBrwAgentesTarifas
   local oBmpGeneral
   local oBmpComisiones
   local oBmpTarifa
   local oBmpRelaciones

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
         PROMPT   "General"         ,;
                  "Comisiones"      ,;
                  "Tarifas"         ,;
                  "Relaciones"       ;
         DIALOGS  "AGENTES_1"       ,;
                  "AGENTES_2"       ,;
                  "AGENTES_TARIFAS" ,;
                  "AGENTES_3"

      // Primera pestaña----------------------------------------------------------

      REDEFINE BITMAP oBmpGeneral ;
         ID       500 ;
         RESOURCE "gc_businessman2_48" ;
         TRANSPARENT ;
         OF       fldGeneral

      REDEFINE GET aoGet[ _CCODAGE ] VAR aTemp[ _CCODAGE ];
         ID       100 ;
         WHEN     ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) ;
         PICTURE  "@!" ;
         OF       fldGeneral

      REDEFINE GET aoGet[ _CAPEAGE ] VAR aTemp[ _CAPEAGE ];
         ID       101 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@!" ;
         OF       fldGeneral

      REDEFINE GET aoGet[ _CNBRAGE ] VAR aTemp[ _CNBRAGE ];
         ID       102 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@!" ;
         OF       fldGeneral

		REDEFINE GET aTemp[ _CDNINIF ];
         ID       103 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldGeneral

		REDEFINE GET aTemp[ _CDIRAGE ];
         ID       104 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldGeneral

		REDEFINE GET aTemp[ _CPOBAGE ];
         ID       105 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldGeneral

		REDEFINE GET aTemp[ _CPROV ];
         ID       106 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldGeneral

		REDEFINE GET aTemp[ _CPTLAGE ];
         ID       107 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldGeneral

		REDEFINE GET aTemp[ _CTFOAGE ];
         ID       108 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "############" ;
         OF       fldGeneral

      REDEFINE GET aTemp[ _CMOVAGE ];
         ID       113 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "############" ;
         OF       fldGeneral

		REDEFINE GET aTemp[ _CFAXAGE ];
         ID       109 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "############" ;
         OF       fldGeneral

      REDEFINE GET aTemp[ _CMAILAGE ];
         ID       114 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldGeneral

      REDEFINE GET aTemp[ _MCOMENT ];
         ID       112 ;
			MEMO ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       fldGeneral

      REDEFINE GET aoGet[ _CCODPRV ] VAR aTemp[ _CCODPRV ] ;
         ID       320 ;
         IDTEXT   330 ;
         BITMAP   "LUPA" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cProvee( aoGet[ _CCODPRV ], D():Proveedores( nView ), aoGet[ _CCODPRV ]:oHelpText ) );
         ON HELP  ( BrwProvee( aoGet[ _CCODPRV ], aoGet[ _CCODPRV ]:oHelpText ) ) ;
         OF       fldGeneral

      REDEFINE GET aoGet[ _CCODART ] VAR aTemp[ _CCODART ] ;
         ID       340 ;
         IDTEXT   350 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    cArticulo( aoGet[ _CCODART ], D():Articulos( nView ), aoGet[ _CCODART ]:oHelpText );
         BITMAP   "LUPA" ;
         ON HELP  BrwArticulo( aoGet[ _CCODART ], aoGet[ _CCODART ]:oHelpText );
         OF       fldGeneral

      // Segunda pestaña----------------------------------------------------------

      REDEFINE BITMAP oBmpComisiones ;
         ID       500 ;
         RESOURCE "gc_symbol_percent_48" ;
         TRANSPARENT ;
         OF       fldComisiones

      // Comisiones genereales

      REDEFINE GET aTemp[ _NCOM1 ] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999.99" ;
         SPINNER;
         ID       120 ;
         OF       fldComisiones

      // Comisiones por tarifa 1

      REDEFINE GET aTemp[ _NCOMTAR1 ] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999.99" ;
         SPINNER;
         ID       100 ;
         OF       fldComisiones

      // Comisiones por tarifa 2

      REDEFINE GET aTemp[ _NCOMTAR2 ] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999.99" ;
         SPINNER;
         ID       101 ;
         OF       fldComisiones

      // Comisiones por tarifa 3

      REDEFINE GET aTemp[ _NCOMTAR3 ] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999.99" ;
         SPINNER;
         ID       102 ;
         OF       fldComisiones

      // Comisiones por tarifa 4

      REDEFINE GET aTemp[ _NCOMTAR4 ] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999.99" ;
         SPINNER;
         ID       103 ;
         OF       fldComisiones

      // Comisiones por tarifa 5

      REDEFINE GET aTemp[ _NCOMTAR5 ] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999.99" ;
         SPINNER;
         ID       104 ;
         OF       fldComisiones

      // Comisiones por tarifa 6

      REDEFINE GET aTemp[ _NCOMTAR6 ] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999.99" ;
         SPINNER;
         ID       105 ;
         OF       fldComisiones

		// Detalle________________________________________________________________

      oBrwLin                 := IXBrowse():New( fldComisiones )

      oBrwLin:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwLin:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwLin:cAlias          := tmpAgentesComisiones
      oBrwLin:nMarqueeStyle   := 5

      with object ( oBrwLin:AddCol() )
         :cHeader          := "Hasta"
         :bEditValue       := {|| ( tmpAgentesComisiones )->nImpVta }
         :cEditPicture     := PicOut()
         :nWidth           := 120
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader          := "% Comisión"
         :bEditValue       := {|| ( tmpAgentesComisiones )->nPctCom }
         :cEditPicture     := "@E 999.99"
         :nWidth           := 60
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      if nMode != ZOOM_MODE
         oBrwLin:bLDblClick   := {|| WinEdtRec( oBrwLin, bEdtDet, tmpAgentesComisiones ) }
      end if

      oBrwLin:CreateFromResource( 310 )

      REDEFINE BUTTON ;
			ID 		501 ;
         OF       fldComisiones ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinAppRec( oBrwLin, bEdtDet, tmpAgentesComisiones ) )

      REDEFINE BUTTON ;
         ID       502 ;
         OF       fldComisiones ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinEdtRec( oBrwLin, bEdtDet, tmpAgentesComisiones ) )

      REDEFINE BUTTON ;
         ID       503 ;
         OF       fldComisiones ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( dbDelRec( oBrwLin, tmpAgentesComisiones ) )

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
         OF       fldComisiones

      REDEFINE GET aoGet[ _CTAGAS ] VAR aTemp[ _CTAGAS ] ;
         ID       360 ;
         IDTEXT   361 ;
         PICTURE  ( Replicate( "X", nLenSubcuentaContaplus() ) ) ;
         WHEN     ( nLenCuentaContaplus() != 0 .and. nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwChkSubcuenta( aoGet[ _CTAGAS ], aoGet[ _CTAGAS ]:oHelpText ) ) ;
         VALID    ( MkSubcuenta( aoGet[ _CTAGAS ], nil, aoGet[ _CTAGAS ]:oHelpText ) );
         OF       fldComisiones

      // Tarifas particulares de agentes---------------------------------------

      REDEFINE BITMAP oBmpTarifa ;
         ID       500 ;
         RESOURCE "gc_symbol_euro_48" ;
         TRANSPARENT ;
         OF       fldTarifas

      REDEFINE BUTTON  ;
         ID       501 ;
         OF       fldTarifas ;
         WHEN     ( ( SQLAjustableModel():getRolCambiarPrecios( Auth():rolUuid() ) ) .and. nMode != ZOOM_MODE );
         ACTION   ( externalAppendAtipica( oBrwAgentesTarifas, tmpAgentesTarifas, nView ) )

      REDEFINE BUTTON  ;
         ID       502 ;
         OF       fldTarifas ;
         WHEN     ( ( SQLAjustableModel():getRolCambiarPrecios( Auth():rolUuid() ) ) .and. nMode != ZOOM_MODE );
         ACTION   ( externalEditAtipica( oBrwAgentesTarifas, tmpAgentesTarifas, nView ) )

      REDEFINE BUTTON  ;
         ID       503 ;
         OF       fldTarifas ;
         WHEN     ( ( SQLAjustableModel():getRolCambiarPrecios( Auth():rolUuid() ) ) .and. nMode != ZOOM_MODE );
         ACTION   ( winDelRec( oBrwAgentesTarifas, tmpAgentesTarifas ) )

      oBrwAgentesTarifas                 := IXBrowse():New( fldTarifas )

      oBrwAgentesTarifas:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwAgentesTarifas:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwAgentesTarifas:cAlias          := tmpAgentesTarifas
      oBrwAgentesTarifas:nMarqueeStyle   := 6
      oBrwAgentesTarifas:cName           := "Agentes.Atipicas"

      with object ( oBrwAgentesTarifas:AddCol() )
         :cHeader          := "Tipo"
         :bEditValue       := {|| if( ( tmpAgentesTarifas )->nTipAtp <= 1, "Artículo", "Familia" ) }
         :nWidth           := 60
      end with

      with object ( oBrwAgentesTarifas:AddCol() )
         :cHeader          := "Código"
         :bEditValue       := {|| if( ( tmpAgentesTarifas )->nTipAtp <= 1, ( tmpAgentesTarifas )->cCodArt, ( tmpAgentesTarifas )->cCodFam ) }
         :nWidth           := 80
      end with

      with object ( oBrwAgentesTarifas:AddCol() )
         :cHeader          := "Nombre"
         :bEditValue       := {|| if( ( tmpAgentesTarifas )->nTipAtp <= 1, retArticulo( ( tmpAgentesTarifas )->cCodArt, D():Get( "Articulo", nView ) ), retFamilia( ( tmpAgentesTarifas )->cCodFam, D():Familias( nView ) ) ) }
         :nWidth           := 160
      end with

      with object ( oBrwAgentesTarifas:AddCol() )
         :cHeader          := "Prop.1"
         :bEditValue       := {|| ( tmpAgentesTarifas )->cValPr1 }
         :nWidth           := 40
         :lHide            := .t.
      end with

      with object ( oBrwAgentesTarifas:AddCol() )
         :cHeader          := "Prop.2"
         :bEditValue       := {|| ( tmpAgentesTarifas )->cValPr2 }
         :nWidth           := 40
         :lHide            := .t.
      end with

      with object ( oBrwAgentesTarifas:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar1", "Precio 1" )
         :bEditValue       := {|| ( tmpAgentesTarifas )->nPrcArt }
         :cEditPicture     := cPorDiv()
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrwAgentesTarifas:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar2", "Precio 2" )
         :bEditValue       := {|| ( tmpAgentesTarifas )->nPrcArt2 }
         :cEditPicture     := cPorDiv()
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrwAgentesTarifas:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar3", "Precio 3" )
         :bEditValue       := {|| ( tmpAgentesTarifas )->nPrcArt3 }
         :cEditPicture     := cPorDiv()
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrwAgentesTarifas:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar4", "Precio 4" )
         :bEditValue       := {|| ( tmpAgentesTarifas )->nPrcArt4 }
         :cEditPicture     := cPorDiv()
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrwAgentesTarifas:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar5", "Precio 5" )
         :bEditValue       := {|| ( tmpAgentesTarifas )->nPrcArt5 }
         :cEditPicture     := cPorDiv()
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrwAgentesTarifas:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar6", "Precio 6" )
         :bEditValue       := {|| ( tmpAgentesTarifas )->nPrcArt6 }
         :cEditPicture     := cPorDiv()
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrwAgentesTarifas:AddCol() )
         :cHeader          := "% Descuento"
         :bEditValue       := {|| ( tmpAgentesTarifas )->nDtoArt }
         :cEditPicture     := "@E 999.99"
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrwAgentesTarifas:AddCol() )
         :cHeader          := "Descuento lineal"
         :bEditValue       := {|| ( tmpAgentesTarifas )->nDtoDiv }
         :cEditPicture     := cPorDiv()
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrwAgentesTarifas:AddCol() )
         :cHeader          := "% Agente"
         :bEditValue       := {|| ( tmpAgentesTarifas )->nComAge }
         :cEditPicture     := "@E 999.99"
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrwAgentesTarifas:AddCol() )
         :cHeader          := "Inicio"
         :bEditValue       := {|| ( tmpAgentesTarifas )->dFecIni }
         :nWidth           := 80
      end with

      with object ( oBrwAgentesTarifas:AddCol() )
         :cHeader          := "Fin"
         :bEditValue       := {|| ( tmpAgentesTarifas )->dFecFin }
         :nWidth           := 80
      end with

      if ( SQLAjustableModel():getRolCambiarPrecios( Auth():rolUuid() ) ) .and. nMode != ZOOM_MODE
         oBrwAgentesTarifas:bLDblClick   := {|| externalEditAtipica( oBrwAgentesTarifas, tmpAgentesTarifas, nView ) }
      end if
      oBrwAgentesTarifas:bRClicked       := {| nRow, nCol, nFlags | oBrwAgentesTarifas:RButtonDown( nRow, nCol, nFlags ) }

      oBrwAgentesTarifas:CreateFromResource( 400 )

      /*
      Tercera pestaña----------------------------------------------------------
      */
         REDEFINE BITMAP oBmpRelaciones ;
         ID       500 ;
         RESOURCE "gc_businessman2_48" ;
         TRANSPARENT ;
         OF       fldRelaciones

      oBrwRel                 := IXBrowse():New( fldRelaciones )

      oBrwRel:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwRel:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwRel:cAlias          := tmpAgentesRelaciones
      oBrwRel:nMarqueeStyle   := 5

      with object ( oBrwRel:AddCol() )
         :cHeader          := "Código"
         :bEditValue       := {|| ( tmpAgentesRelaciones )->cCodRel }
         :nWidth           := 60
      end with

      with object ( oBrwRel:AddCol() )
         :cHeader          := "Agente"
         :bEditValue       := {|| cNbrAgent( ( tmpAgentesRelaciones )->cCodRel, dbfAge ) }
         :nWidth           := 240
      end with

      with object ( oBrwRel:AddCol() )
         :cHeader          := "% Comisión"
         :bEditValue       := {|| ( tmpAgentesRelaciones )->nComRel }
         :cEditPicture     := "@E 999.99"
         :nWidth           := 60
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      if nMode != ZOOM_MODE
         oBrwRel:bLDblClick   := {|| WinEdtRec( oBrwRel, bEdtRel, tmpAgentesRelaciones, aTemp[ _CCODAGE ] ) }
      end if

      oBrwRel:CreateFromResource( 310 )

      REDEFINE BUTTON ;
			ID 		501 ;
         OF       fldRelaciones ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinAppRec( oBrwRel, bEdtRel, tmpAgentesRelaciones, aTemp[ _CCODAGE ] ) )

      REDEFINE BUTTON ;
         ID       502 ;
         OF       fldRelaciones ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinEdtRec( oBrwRel, bEdtRel, tmpAgentesRelaciones, aTemp[ _CCODAGE ] ) )

      REDEFINE BUTTON ;
         ID       503 ;
         OF       fldRelaciones ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( dbDelRec( oBrwRel, tmpAgentesRelaciones ) )

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
      
         oDlg:AddFastKey( VK_F9, {|| oDetCamposExtra:Play( Space(1) ) } )

      endif

      oDlg:bStart := {|| EvalGet( aoGet, nMode ) }

   ACTIVATE DIALOG oDlg CENTER;
         ON INIT     ( EdtRecMenu( oDlg, aTemp ) ) ;

   oBmpGeneral:End()
   oBmpComisiones:End()
   oBmpTarifa:End()
   oBmpRelaciones:End()

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Static Function EdtRecMenu( oDlg, aTemp )

   local oMenu

   MENU oMenu

      MENUITEM    "&1. Rotor"

         MENU

            MENUITEM "&1. Campos extra [F9]";
            MESSAGE  "Mostramos y rellenamos los campos extra para la familia" ;
            RESOURCE "GC_FORM_PLUS2_16" ;
            ACTION   ( oDetCamposExtra:Play( Space(1) ) )

         ENDMENU

   ENDMENU

   oDlg:SetMenu( oMenu )

Return ( oMenu )

//--------------------------------------------------------------------------//

Static Function lPreEdit( aTmp, nMode )

   local lErrors              := .f.
   local cCodAge              := aTmp[ _CCODAGE ]
   local oError
   local oBlock
   local tmpCom

   oBlock                     := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      // Primero Crear la base de datos local----------------------------------

      cAgentesComisiones      := cGetNewFileName( cPatTmp() + "ComAge" )

      dbCreate( cAgentesComisiones, aSqlStruct( aItmCom() ), cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), cAgentesComisiones, cCheckArea( "ComAge", @tmpAgentesComisiones ), .f. )

      ( tmpAgentesComisiones )->( OrdCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( tmpAgentesComisiones )->( OrdCreate( cAgentesComisiones, "nImpVta", "Str( nImpVta )", {|| Str( Field->nImpVta ) } ) )

      if ( D():AgentesComisiones( nView ) )->( dbSeek( cCodAge ) )
         while ( ( D():AgentesComisiones( nView ) )->cCodAge == cCodAge .and. !( D():AgentesComisiones( nView ) )->( eof() ) )
            dbPass( D():AgentesComisiones( nView ), tmpAgentesComisiones, .t. )
            ( D():AgentesComisiones( nView ) )->( dbSkip() )
         end while
      end if

      ( tmpAgentesComisiones )->( dbGoTop() )

      // Relaciones entre agentes----------------------------------------------

      cAgentesRelaciones     := cGetNewFileName( cPatTmp() + "RelAge" )

      dbCreate( cAgentesRelaciones, aSqlStruct( aItmRel() ), cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), cAgentesRelaciones, cCheckArea( "RelAge", @tmpAgentesRelaciones ), .f. )

      ( tmpAgentesRelaciones )->( OrdCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( tmpAgentesRelaciones )->( OrdCreate( cAgentesRelaciones, "cCodAge", "cCodAge", {|| Field->cCodAge } ) )

      if ( D():AgentesRelaciones( nView ) )->( dbSeek( cCodAge ) )
         while ( ( D():AgentesRelaciones( nView ) )->cCodAge == cCodAge .and. !( D():AgentesRelaciones( nView ) )->( eof() ) )
            dbPass( D():AgentesRelaciones( nView ), tmpAgentesRelaciones, .t. )
            ( D():AgentesRelaciones( nView ) )->( dbSkip() )
         end while
      end if

      ( tmpAgentesRelaciones )->( dbGoTop() )

      // Tarifas atipicas------------------------------------------------------

      cAgentesAtipicas        := cGetNewFileName( cPatTmp() + "AtpAge" )

      dbCreate( cAgentesAtipicas, aSqlStruct( aItmAtp() ), cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), cAgentesAtipicas, cCheckArea( "AtpAge", @tmpAgentesTarifas ), .f. )

      ( tmpAgentesTarifas )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( tmpAgentesTarifas )->( OrdCreate( cAgentesAtipicas, "cCliArt", "cCodArt + cCodPr1 + cCodPr2 + cValPr1 + cValPr2", {|| Field->cCodArt + Field->cCodPr1 + Field->cCodPr2 + Field->cValPr1 + Field->cValPr2 } ) )

      ( tmpAgentesTarifas )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( tmpAgentesTarifas )->( OrdCreate( cAgentesAtipicas, "cCodFam", "cCodFam", {|| Field->cCodFam } ) )

      ( tmpAgentesTarifas )->( OrdSetFocus( "cCliArt" ) )

      if ( D():Atipicas( nView ) )->( dbSeek( cCodAge ) )
         while ( ( D():Atipicas( nView ) )->cCodAge == cCodAge .and. !( D():Atipicas( nView ) )->( eof() ) )
            dbPass( D():Atipicas( nView ), tmpAgentesTarifas, .t. )
            ( D():Atipicas( nView ) )->( dbSkip() )
         end while
      end if

   /*
   Cargamos los temporales de los campos extra---------------------------------
   */

   oDetCamposExtra:SetTemporal( aTmp[ _CCODAGE ], "", nMode )

   RECOVER USING oError

      msgStop( "Imposible crear tablas temporales" + CRLF + ErrorMessage( oError ) )

      lPosEdit()

      lErrors     := .t.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lErrors )

//---------------------------------------------------------------------------//

Static Function lPosEdit( oBrwLin )

   if !empty( oBrwLin )
      oBrwLin:CloseData()
   end if

   if !Empty( tmpAgentesComisiones ) .and. ( tmpAgentesComisiones )->( Used() )
      ( tmpAgentesComisiones )->( dbCloseArea() )
   end if
   dbfErase( cAgentesComisiones )

   if !Empty( tmpAgentesRelaciones ) .and. ( tmpAgentesRelaciones )->( Used() )
      ( tmpAgentesRelaciones )->( dbCloseArea() )
   end if
   dbfErase( cAgentesRelaciones )

   if !Empty( tmpAgentesTarifas ) .and. ( tmpAgentesTarifas )->( Used() )
      ( tmpAgentesTarifas )->( dbCloseArea() )
   end if
   dbfErase( cAgentesAtipicas )

   tmpAgentesRelaciones          := nil
   tmpAgentesComisiones          := nil
   tmpAgentesTarifas             := nil

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

   // RollBack en edici¢n de registros--------------------------------------------

   if nMode == EDIT_MODE
      deleteRelations( aTemp[ _CCODAGE ], D():AgentesComisiones( nView ) )
      deleteRelations( aTemp[ _CCODAGE ], D():AgentesRelaciones( nView ) )
      deleteRelations( aTemp[ _CCODAGE ], D():Atipicas( nView ) )
   end if

   // Quitamos los filtros--------------------------------------------------------

   oMsgProgress()
   oMsgProgress():SetRange( 0, ( tmpAgentesComisiones )->( LastRec() ) )

   // Tablas relacionadas---------------------------------------------------------

   buildRelation( tmpAgentesComisiones, D():AgentesComisiones( nView ), { "cCodAge" => aTemp[ _CCODAGE ] } )
   buildRelation( tmpAgentesRelaciones, D():AgentesRelaciones( nView ), { "cCodAge" => aTemp[ _CCODAGE ] } )
   buildRelation( tmpAgentesTarifas, D():Atipicas( nView ), { "cCodAge" => aTemp[ _CCODAGE ] } )

   /*
   Guardamos los campos extra-----------------------------------------------
   */

   oDetCamposExtra:saveExtraField( aTemp[ _CCODAGE ], "" )


   // Ahora escribimos en el fichero definitivo-----------------------------------

   winGather( aTemp, aoGet, dbfAge, oBrw, nMode )

   dbCommitAll()

   oMsgText()

   lPosEdit( oBrwLin )

   endProgress()

   oDlg:Enable()
   oDlg:End( IDOK )

   CursorWE()

Return ( .t. )

//---------------------------------------------------------------------------//

Static Function EdtDet( aTmp, aGet, tmpAgentesComisiones, oBrw, bWhen, bValid, nMode )

	local oDlg

   // Caja de dialogo----------------------------------------------------------

   DEFINE DIALOG oDlg RESOURCE "AgeDet"

      REDEFINE GET aGet[ ( tmpAgentesComisiones )->( FieldPos( "nImpVta" ) ) ] ;
         VAR      aTmp[ ( tmpAgentesComisiones )->( FieldPos( "nImpVta" ) ) ] ;
			ID 		100 ;
         PICTURE  PicOut() ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aGet[ ( tmpAgentesComisiones )->( FieldPos( "nPctCom" ) ) ] ;
         VAR      aTmp[ ( tmpAgentesComisiones )->( FieldPos( "nPctCom" ) ) ] ;
         ID       110 ;
         PICTURE  "@E 999.99" ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( WinGather( aTmp, nil, tmpAgentesComisiones, oBrw, nMode ), oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
			ACTION 	( oDlg:end() )

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Static Function EdtRel( aTmp, aGet, tmpAgentesRelaciones, oBrw, cCodAge, bValid, nMode )

	local oDlg

   // Caja de dialogo----------------------------------------------------------

   DEFINE DIALOG oDlg RESOURCE "AgeRel"

      REDEFINE GET aGet[ ( tmpAgentesRelaciones )->( FieldPos( "cCodRel" ) ) ] ;
         VAR      aTmp[ ( tmpAgentesRelaciones )->( FieldPos( "cCodRel" ) ) ] ;
			ID 		100 ;
         IDTEXT   101 ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAgentes( aGet[ ( tmpAgentesRelaciones )->( FieldPos( "cCodRel" ) ) ], aGet[ ( tmpAgentesRelaciones )->( FieldPos( "cCodRel" ) ) ]:oHelpText, .t., aTmp[ ( tmpAgentesRelaciones )->( FieldPos( "cCodRel" ) ) ] ) );
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lValidEdtRel( cCodAge, aTmp, aGet, dbfAge ) );
         PICTURE  "@!" ;
         OF       oDlg

      REDEFINE GET aGet[ ( tmpAgentesRelaciones )->( FieldPos( "nComRel" ) ) ] ;
         VAR      aTmp[ ( tmpAgentesRelaciones )->( FieldPos( "nComRel" ) ) ] ;
         ID       110 ;
         PICTURE  "@E 999.99" ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( WinGather( aTmp, nil, tmpAgentesRelaciones, oBrw, nMode ), oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
			ACTION 	( oDlg:end() )

      oDlg:bStart := {|| aGet[ ( tmpAgentesRelaciones )->( FieldPos( "cCodRel" ) ) ]:lValid() }

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Static Function lValidEdtRel( cCodAge, aTmp, aGet, dbfAge )

   local nRec
   local nOrd
   local lVal  := .f.

   if Empty( aTmp[ ( tmpAgentesRelaciones )->( FieldPos( "cCodRel" ) ) ] )
      return .t.
   end if

   if ( cCodAge == aTmp[ ( tmpAgentesRelaciones )->( FieldPos( "cCodRel" ) ) ] )
      MsgStop( "No se puede relacionar un agente con el mismo" )
      return .f.
   end if

   nRec        := ( dbfAge )->( RecNo() )
   nOrd        := ( dbfAge )->( OrdSetFocus( "cCodAge" ) )

   if ( dbfAge )->( dbSeek( aTmp[ ( tmpAgentesRelaciones )->( FieldPos( "cCodRel" ) ) ] ) )
      aGet[ ( tmpAgentesRelaciones )->( FieldPos( "cCodRel" ) ) ]:oHelpText:cText( cNombreAgente( dbfAge ) )
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

   nLevelUsr            := Auth():Level( "01033" )

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

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Seleccionar agentes"

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

   if !( "PDA" $ appParamsMain() )

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

FUNCTION aAgentesRelacionados( cCodAge, nView )

   local nOrd
   local oBlock
   local oError
   local aAgentes    := {}

   if IsObject( cCodAge )
      cCodAge        := cCodAge:VarGet()
   end if

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   nOrd              := ( D():AgentesRelaciones( nView ) )->( ordSetFocus( "cCodRel" ) )

   if ( D():AgentesRelaciones( nView ) )->( dbSeek( cCodAge ) )
      while ( ( D():AgentesRelaciones( nView ) )->cCodRel == cCodAge ) .and. !( D():AgentesRelaciones( nView ) )->( eof() )
         aAdd( aAgentes, { ( D():AgentesRelaciones( nView ) )->cCodAge, ( D():AgentesRelaciones( nView ) )->nComRel } )
         ( D():AgentesRelaciones( nView ) )->( dbSkip() )
      end while
   end if

   ( D():AgentesRelaciones( nView ) )->( ordSetFocus( nOrd ) )

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

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos" )

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

   if Empty( oGet:varGet() ) .or. ( oGet:varGet() == replicate( "Z", 3 ) )

      if isObject( oGet2 )
			oGet2:cText( "" )
      end if

      if isObject( oGetPct )
			oGetPct:cText( 0 )
      end if

      return .t.

   else

      xValor         := RJustObj( oGet, "0", 3 )

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
      USE ( cPatEmp() + "AGENTES.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AGENTES", @dbfAge ) )
      SET ADSINDEX TO ( cPatEmp() + "AGENTES.CDX" ) ADDITIVE
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

   local nLevel         := Auth():Level( "01033" )

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
         RESOURCE "gc_businessman2_48" ;
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

Static Function deleteRelations( cCodigoAgente, dbfRelation )

   while ( ( dbfRelation )->( dbSeek( cCodigoAgente ) ) .and. !( dbfRelation )->( eof() ) )
      if dbLock( dbfRelation )
         ( dbfRelation )->( dbDelete() )
         ( dbfRelation )->( dbUnLock() )
      end if
   end while

Return ( nil )

//---------------------------------------------------------------------------//

Static Function buildRelation( dbfTemporal, dbfRelation, hHash )

   ( dbfTemporal )->( dbGoTop() )
   while ( dbfTemporal )->( !eof() )
      appendRegisterByHash( dbfTemporal, dbfRelation, hHash )
      ( dbfTemporal )->( dbSkip() )
      oMsgProgress():Deltapos( 1 )
   end while

Return ( nil )

//---------------------------------------------------------------------------//

FUNCTION nPrecioAgenteArticuloTarifa( cCodigoAgente, cCodigoArticulo, nTarifaPrecio, nView )

   local cNombreCampo
   local nPrecioAgenteArticuloTarifa   := 0

   if empty( cCodigoAgente )
      Return ( nPrecioAgenteArticuloTarifa )
   end if

   if nTarifaPrecio == 1
      cNombreCampo   := "nPrcArt"
   else 
      cNombreCampo   := "nPrcArt" + str( nTarifaPrecio, 1 )
   end if 

   if D():gotoIdAtipicasAgentes( cCodigoAgente, cCodigoArticulo, nView )
      nPrecioAgenteArticuloTarifa      := ( D():Atipicas( nView ) )->( fieldGet( fieldpos( cNombreCampo ) ) )
   end if

RETURN ( nPrecioAgenteArticuloTarifa )

//---------------------------------------------------------------------------//

Function setOldPorcentajeAgente( nPctComision )

   nOldPctComision   := nPctComision

RETURN ( nil )

//---------------------------------------------------------------------------//

FUNCTION LoadAgente( oGetCodigoAgente, dbfAge, oGetNombreAgente, oGetPorcentajeAgente, dbfAgeCom, dbfTmpLin, oBrw ) 

   if cAgentes( oGetCodigoAgente, dbfAge, oGetNombreAgente, oGetPorcentajeAgente )  

      validateAgentPercentage( oGetPorcentajeAgente, dbfTmpLin, oBrw )

   end if  

RETURN ( nil )

//---------------------------------------------------------------------------//

FUNCTION validateAgentPercentage( oGetPorcentajeAgente, dbfTmpLin, oBrw )

   local nNewPctComision   := oGetPorcentajeAgente:varGet()

   if ( nNewPctComision != nOldPctComision ) 

      if ( dbfTmpLin )->( ordkeycount() ) > 0 .and. ;
         apoloMsgNoYes( "La comisión del agente seleccionado es distinta a la anterior," + CRLF + ;
                        "¿desea extender el cambio de comisión a todas las líneas?",;
                        "¿Relizar el cambio?" )
   
         changeAgentPercentageInAllLines( nNewPctComision, dbfTmpLin, oBrw )

      end if 
     
   end if  

   setOldPorcentajeAgente( nNewPctComision )

RETURN ( nil )

//---------------------------------------------------------------------------//
