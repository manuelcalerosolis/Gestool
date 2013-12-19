/*
Fichero de Cabecera para la Aplcaci¢n de Facturaci¢n 3.0 para Windows
*/

#ifdef __GST__
        #define __GSTROTOR__            "Gestool"
        #define __GSTTACTIL__           "Gestool táctil"
        #define __GSTVERSION__          "2K13"
        #define __GSTTPV__              "Gestool"
        #define __GSTFACTORY__          "Gestool"
        #define __GSTCOPYRIGHT__        "(c) Gestool 2013"
        #define __GSTWEB__              "http://www.gestool.es"
        #define __GSTHELP__             "http://www.gstrotor.com/ayuda/Index.html"
        #define __GSTBROWSER__          "http://www.gestool.es/fondo/index.html"
        #define __GSTICON__             "GstRotor.Ico"
        #define __GSTTELEFONO__         "902.930.252"
        #define __GSTLOGO__             "Bmp\GstWellcome.Bmp"
        #define __GSTDIRECCION__        "Cl. Ronda de legionarios, 58"
        #define __GSTPOBLACION__        "21700 La Palma del Condado"
        #define __GSTOTROS__            "Teléfono: +34 902.930.252 Correo electónico: info@gestool.es"
#endif

#ifdef __MK__
        #define __GSTROTOR__            "MKShop Sistema de Gestión"
        #define __GSTTACTIL__           "MKShop Sistema de Gestión - Táctil"
        #define __GSTVERSION__          "2012"
        #define __GSTTPV__              "MKShop Sistema de Gestión - Terminal punto de venta"
        #define __GSTFACTORY__          "Micro K Informática S.L."
        #define __GSTCOPYRIGHT__        "(c) Micro K Informática S.L. 2012"
        #define __GSTWEB__              "http://www.microkinformatica.es"
        #define __GSTHELP__             "http://www.microk.com/ayudamkshopgestion/"
        #define __GSTBROWSER__          "http://www.microk.com/mkgestion"
        #define __GSTICON__             "Logomk.Ico"
        #define __GSTTELEFONO__         "902.107.474"
        #define __GSTLOGO__             "Bmp\MkWellcome.Bmp"
        #define __GSTDIRECCION__        "Calle San Raimundo 15"
        #define __GSTPOBLACION__        "03005 Alicante"
        #define __GSTOTROS__            "Teléfono: +34 965927474 Correo electónico: info@microkinformatica.es"
#endif

#ifdef __OC__
        #define __GSTROTOR__            "Oido Cocina - TPV"
        #define __GSTTACTIL__           "Oido Cocina - TPV táctil"
        #define __GSTVERSION__          "2012"
        #define __GSTTPV__              "Oido Cocina - Terminal punto de venta"
        #define __GSTFACTORY__          "Asema Consultora Informática SL"
        #define __GSTCOPYRIGHT__        "(c) Asema Consultora Informática SL 2012"
        #define __GSTWEB__              "http://www.asemasl.es"
        #define __GSTHELP__             "http://www.gstrotor.com/ayuda/Index.html"
        #define __GSTBROWSER__          "http://www.gstrotor.com/gst/indexoidococina.html"
        #define __GSTICON__             "Oidococina.Ico"
        #define __GSTTELEFONO__         "Tlf 670638384"
        #define __GSTLOGO__             "Bmp\OidoCocina.Bmp"
        #define __GSTDIRECCION__        "Avda. Espartinas, 21-25 C.C. PIBO Local 32 "
        #define __GSTPOBLACION__        "41110 Bollullos de la  Mitación. Sevilla"
        #define __GSTOTROS__            "Teléfono: +34 955776888 Correo electónico: manuelmiguez@asemasl.es"
#endif

#ifdef __MK__
#define SERIALNUMBER                    1234554321
#else
#define SERIALNUMBER                    9876556789
#endif

#define __DAYS__                        5

#define clrTopArchivos                  Rgb( 104, 0, 63 )
#define clrTopCompras                   Rgb( 0, 114, 198 )
#define clrTopAlmacenes                 Rgb( 106, 70, 18 )
#define clrTopProduccion                Rgb( 250, 161, 52 )
#define clrTopExpedientes               Rgb( 231, 135, 0 )
#define clrTopVentas                    Rgb( 190, 57, 0 )
#define clrTopTPV                       Rgb( 164, 55, 58 )
#define clrTopHerramientas              Rgb( 33, 115, 70 )

#define txtFilters                      "[Mis filtros]"

/*
Defines para ficheros INI
*/

#define _NUMINIAPP              40

#define USECAJAS                 1
#define CALCAJAS                 2
#define ENTCONT                  3
#define NTIPCON                  4
#define USEPROP                  5
#define CRUTCON                  6
#define PATHEMPRESA              7
#define PATHDATOS                8
#define MODDESC                  9
#define LASTEMPRESA             10
#define LSUALBARAN              11
#define LNUALBARAN              12
#define LNUMOBRA                13
#define TIPMOV                  14
#define CTXTSUALB               15
#define CTXTNUALB               16
#define CTXTOBRA                17
#define CCAJOPNTPV              18
#define CNOMCON                 19
#define CUSRCON                 20
#define CPSWCON                 21
#define CUSRFTP                 22
#define CPSWFTP                 23
#define CFTPSIT                 24
#define CENVUSR                 25
#define MODIVA                  26
#define CPRTCAJTPV              27
#define APPNEW                  28
#define APPMOD                  29
#define PRNTIK                  30
#define NPRNTIK                 31
#define LAUTCOS                 32
#define SELFAM                  33
#define LASBAK                  34
#define NEWASP                  35
#define AVISOCERO               36
#define AVISOCAMBIO             37
#define GETMATRICULA            38
#define CTITTIKTPV              39
#define CPIETIKTPV              40

#define _NUMINIEMP              49

#define DEFAULTALM              1
#define RUTACONTA               2
#define CODEMPA                 3
#define LSERIEA                 4
#define LSERIEB                 5
#define LABONO                  6
#define CTACLIENTE              7
#define CTAPROVEE               8
#define CTAVENTACLI             9
#define CTAABONOCLI             10
#define CTAVTACONTADO           11
#define SUBCTAPORTE             12
#define SUBCTACLICON            13
#define CTAABNPROVEEDOR         14
#define DEFSERIE                15
#define DEFCAJA                 16
#define DEFCAJERO               17
#define DEFCLIENT               18
#define DEFFPAGO                19
#define DGTUND                  20
#define DECUND                  21
#define DEFDIV                  22
#define NOPCIVA                 23
#define LRECPGD                 24
#define CODEMPB                 25
#define SELCOL                  26
#define REDUNO                  27
#define GREENUNO                28
#define BLUEUNO                 29
#define REDDOS                  30
#define GREENDOS                31
#define BLUEDOS                 32
#define DEFPICOUT               33
#define DEFPICIN                34
#define LUSEPROP                35
#define NUSEPROP                36
#define DEFAULTFPG              37
#define NUMREM                  38
#define NUMTUR                  39
#define NCOPPEDPRV              40
#define NCOPALBPRV              41
#define NCOPFACPRV              42
#define NCOPDEPAGE              43
#define NCOPEXTAGE              44
#define NCOPPRECLI              45
#define NCOPPEDCLI              46
#define NCOPALBCLI              47
#define NCOPFACCLI              48
#define NCOPTIKCLI              49

#define APPD_MODE               1
#define EDIT_MODE               2
#define ZOOM_MODE               3
#define DUPL_MODE               4
#define MULT_MODE               5
#define ESPE_MODE               6
#define DELE_MODE               7

#define PED_PRV                 '01'
#define ALB_PRV                 '02'
#define FAC_PRV                 '03'
#define RCT_PRV                 '04'
#define MOV_ALM                 '05'
#define PRO_LIN                 '06'
#define PRO_MAT                 '07'
#define PRE_CLI                 '08'
#define PED_CLI                 '09'
#define ALB_CLI                 '10'
#define FAC_CLI                 '11'
#define TIK_CLI                 '12'
#define ANT_CLI                 '13'
#define FAC_REC                 '14'
#define DEV_CLI                 '15'
#define VAL_CLI                 '16'
#define APT_CLI                 '17'
#define REC_CLI                 '18'
#define REC_PRV                 '19'
#define ART_TBL                 '20'
#define CLI_TBL                 '21'
#define PRV_TBL                 '22'
#define ENT_SAL                 '23'
#define ENT_PED                 '24'
#define ENT_ALB                 '25'
#define ALQ_CLI                 '26'
#define ENT_ALQ                 '27'
#define USR_TBL                 '28'
#define EXP_CLI                 '29'
#define PAR_PRO                 '30'
#define COB_TIK                 '31'
#define SAT_CLI                 '32'
#define FST_ART                 '33'
#define FST_CLI                 '34'
#define FST_PRV                 '35'

#define ACC_ACCE                1        // Acceso
#define ACC_APPD                2        // Acceso añadir
#define ACC_EDIT                4        // Solo modificar
#define ACC_ZOOM                8        // Solo visualizar
#define ACC_DELE                16       // Acceso eliminar
#define ACC_IMPR                32       // Acceso imprimir

#define IS_PRINTER              1
#define IS_SCREEN               2
#define IS_PDF                  3
#define IS_HTML                 4
#define IS_EXCEL                5
#define IS_MAIL                 6

#define KIT_TODOS               1
#define KIT_COMPUESTO           2
#define KIT_COMPONENTE          3

#define SAVTIK                  "1"      // Salvar como tiket
#define SAVALB                  "2"      // Salvar como albaran
#define SAVFAC                  "3"      // Salvar como factura
#define SAVDEV                  "4"      // Salvar como devolución
#define SAVAPT                  "5"      // Salvar como apartado
#define SAVVAL                  "6"      // Salvar como vale
#define SAVPDA                  "7"      // Salvar como pda
#define SAVRGL                  "8"      // Salvar como reglao

#define STOCK_CONTROLAR         1
#define STOCK_CONTADORES        2
#define STOCK_NO_CONTROLAR      3

#define CLR_GET                 "N/W*"
#define CLR_GET_GREEN           "G/W*"
#define CLR_GET_BLUE            "B/W*"
#define CLR_GET_RED             "R/W"
#define CLR_SHOW                "N/W"
#define CLR_TOTAL               "N/GR*"
#define CLR_SAY                 "G+/N"
#define CLR_VIS                 "GR/N"

#ifndef F_ERROR
#define F_ERROR                 (-1)
#endif

#define COLOR_SCROLLBAR         0
#define COLOR_BACKGROUND        1
#define COLOR_ACTIVECAPTION     2
#define COLOR_INACTIVECAPTION   3
#define COLOR_MENU              4
#define COLOR_WINDOW            5
#define COLOR_WINDOWFRAME       6
#define COLOR_MENUTEXT          7
#define COLOR_WINDOWTEXT        8
#define COLOR_CAPTIONTEXT       9
#define COLOR_ACTIVEBORDER      10
#define COLOR_INACTIVEBORDER    11
#define COLOR_APPWORKSPACE      12
#define COLOR_HIGHLIGHT         13
#define COLOR_HIGHLIGHTTEXT     14
#define COLOR_BTNFACE           15
#define COLOR_BTNSHADOW         16
#define COLOR_GRAYTEXT          17
#define COLOR_BTNTEXT           18
#define COLOR_INACTIVECAPTIONTEXT 19
#define COLOR_BTNHIGHLIGHT      20

#define REGIMENES_IVA_ITEMS     {       "Devengo",;
                                        "Caja" }

#define RECTIFICATIVA_ITEMS     {       "01. Número factura",;
                                        "02. Serie factura",;
                                        "03. Fecha expedición",;
                                        "04. Nombre y apellidos / Razón social del emisor",;
                                        "05. Nombre y apellidos / Razón social del receptor",;
                                        "06. Identificación fiscal del emisor obligatoria",;
                                        "07. Identificación fiscal del receptor",;
                                        "08. Domicilio emisor obligatorio",;
                                        "09. Domicilio receptor",;
                                        "10. Detalle operación",;
                                        "11. Porcentaje impositivo a aplicar",;
                                        "12. Cuota tributaria a aplicar",;
                                        "13. Fecha / Periodo a aplicar",;
                                        "14. Clase de factura",;
                                        "15. Literales legales",;
                                        "16. Base imponible",;
                                        "80. Cálculo de cuotas repercutidas",;
                                        "81. Cálculo de cuotas retenidas",;
                                        "82. Base imponible modificada por devolución de envases / embalajes",;
                                        "83. Base imponible modificada por descuentos y bonificaciones",;
                                        "84. Base imponible modificada por resolución firme, judicial o administrativa",;
                                        "85. Base imponible modificada cuotas repercutidas no satisfechas. Auto de declaración de concurso" }

#define FORMASDEPAGO_ITEMS      {       "01. Al contado",;
                                        "02. Recibo Domiciliado",;
                                        "03. Recibo",;
                                        "04. Transferencia",;
                                        "05. Letra Aceptada",;
                                        "06. Crédito Documentario",;
                                        "07. Contrato Adjudicación",;
                                        "08. Letra de cambio",;
                                        "09. Pagaré a la Orden",;
                                        "10. Pagaré No a la Orden",;
                                        "11. Cheque",;
                                        "12. Reposición",;
                                        "13. Especiales",;
                                        "14. Compensación",;
                                        "15. Giro postal",;
                                        "16. Cheque conformado",;
                                        "17. Cheque bancario",;
                                        "18. Pago contra reembolso",;
                                        "19. Pago mediante tarjeta" }


#command SET TAG TO <tag> [OF <(cdx)>] ;
      => ordSetFocus( <(tag)> [, <(cdx)>] )

// Eventos de la aplicación

#define START_APLICATION                        "Inicio de aplicación"
#define END_APLICATION                          "Salida de aplicación"
#define START_FACTURA_CLIENTES                  "Inicio facturas de clientes"
#define END_FACTURA_CLIENTES                    "Salida facturas de clientes"
#define NEW_FACTURA_CLIENTES                    "Añadida nueva factura de clientes"
#define DUPLICATE_FACTURA_CLIENTES              "Duplicada nueva factura de clientes"
#define EDIT_FACTURA_CLIENTES                   "Modificada factura de clientes"
#define DELETE_FACTURA_CLIENTES                 "Eliminada factura de clientes"
#define PRINT_FACTURA_CLIENTES                  "Impresa factura de clientes"
#define PREVIEW_FACTURA_CLIENTES                "Previsualizada factura de clientes"
#define LIQUIDA_FACTURA_CLIENTES                "Liquidada factura de clientes"
#define CONT_FACTURA_CLIENTES                   "Contabiliza factura de clientes"
#define MARK_CONT_FACTURA_CLIENTES              "Marca como contabilizada factura de clientes"
#define NOMARK_CONT_FACTURA_CLIENTES            "Marca como no contabilizada factura de clientes"
#define GENERATE_RECIBO_FACTURA_CLIENTES        "Genera recibo de factura de clientes"
#define PRINT_PRESUPUESTO_CLIENTES              "Impreso presupuesto a clientes"
#define PREVIEW_PRESUPUESTO_CLIENTES            "Previsualizado presupuesto a clientes"
#define PRINT_PEDIDO_CLIENTES                   "Impreso pedido a clientes"
#define PREVIEW_PEDIDO_CLIENTES                 "Previsualizado pedido a clientes"
#define PRINT_ALBARAN_CLIENTES                  "Impreso albaran a clientes"
#define PREVIEW_ALBARAN_CLIENTES                "Previsualizado albaran a clientes"
#define PRINT_FACTURA_RECTIFICATIVA             "Impresa factura rectificativa"
#define PREVIEW_FACTURA_RECTIFICATIVA           "Previsualizada factura rectificativa"
#define PRINT_FACTURA_ANTICIPO                  "Impresa factura de anticipo"
#define PREVIEW_FACTURA_ANTICIPO                "Previsualiza factura de anticipo"

#define START_CLIENTES                          "Inicio de cliente"
#define END_CLIENTES                            "Salida de cliente"
#define NEW_CLIENTES                            "Añadido nuevo cliente"
#define DUPLICATE_CLIENTES                      "Duplicado cliente"
#define EDIT_CLIENTES                           "Modifica cliente"
#define DELETE_CLIENTES                         "Elimina cliente"


/*----------------------------------------------------------------------------//
Extend FW
*/

#xcommand REDEFINE GET [ <oGet> VAR ] <uVar> ;
            [ ID <nId> ] ;
            [ <dlg: OF, WINDOW, DIALOG> <oDlg> ] ;
            [ <help:HELPID, HELP ID> <nHelpId> ] ;
            [ VALID <ValidFunc> ] ;
            [ PICTURE <cPict> ] ;
            [ <color:COLOR,COLORS> <nClrFore> [,<nClrBack>] ] ;
            [ FONT <oFont> ] ;
            [ CURSOR <oCursor> ] ;
            [ MESSAGE <cMsg> ] ;
            [ <update: UPDATE> ] ;
            [ WHEN <uWhen> ] ;
            [ ON CHANGE <uChange> ] ;
            [ <readonly: READONLY, NO MODIFY> ] ;
            [ <spin: SPINNER> [ON UP <SpnUp>] [ON DOWN <SpnDn>] [MIN <Min>] [MAX <Max>] ] ;
            [ ON HELP <uHelp> ];
            [ BITMAP <cBmp> ];
            [ IDSAY <nIdSay> ];
            [ IDTEXT <nIdText> ];
            => ;
            [ <oGet> := ] TGetHlp():ReDefine( <nId>, bSETGET(<uVar>), <oDlg>,;
            <nHelpId>, <cPict>, <{ValidFunc}>, <nClrFore>, <nClrBack>,;
            <oFont>, <oCursor>, <cMsg>, <.update.>, <{uWhen}>,;
            [ \{|nKey,nFlags,Self| <uChange> \}], <.readonly.>,;
            <.spin.>, <{SpnUp}>, <{SpnDn}>, <{Min}>, <{Max}>,;
            [{|Self|<uHelp>}], nil, <cBmp>, <nIdSay>, <nIdText> )

#command @ <nRow>, <nCol> GET [ <oGet> VAR ] <uVar> ;
            [ <dlg: OF, WINDOW, DIALOG> <oWnd> ] ;
            [ PICTURE <cPict> ] ;
            [ VALID <ValidFunc> ] ;
            [ <color:COLOR,COLORS> <nClrFore> [,<nClrBack>] ] ;
            [ SIZE <nWidth>, <nHeight> ]  ;
            [ FONT <oFont> ] ;
            [ <design: DESIGN> ] ;
            [ CURSOR <oCursor> ] ;
            [ <pixel: PIXEL> ] ;
            [ MESSAGE <cMsg> ] ;
            [ <update: UPDATE> ] ;
            [ WHEN <uWhen> ] ;
            [ <lCenter: CENTER, CENTERED> ] ;
            [ <lRight: RIGHT> ] ;
            [ ON CHANGE <uChange> ] ;
            [ <readonly: READONLY, NO MODIFY> ] ;
            [ <pass: PASSWORD> ] ;
            [ <lNoBorder: NO BORDER, NOBORDER> ] ;
            [ <help:HELPID, HELP ID> <nHelpId> ] ;
            [ <spin: SPINNER> [ON UP <SpnUp>] [ON DOWN <SpnDn>] [MIN <Min>] [MAX <Max>] ] ;
            [ ON HELP <uHelp> ] ;
            [ ON MULT <uMult> ] ;
            [ BITMAP <cBmp> ];
            [ IDSAY <oSay> ];
            => ;
            [ <oGet> := ] TGetHlp():New( <nRow>, <nCol>, bSETGET(<uVar>),;
            [<oWnd>], <nWidth>, <nHeight>, <cPict>, <{ValidFunc}>,;
            <nClrFore>, <nClrBack>, <oFont>, <.design.>,;
            <oCursor>, <.pixel.>, <cMsg>, <.update.>, <{uWhen}>,;
            <.lCenter.>, <.lRight.>,;
            [\{|nKey, nFlags, Self| <uChange>\}], <.readonly.>,;
            <.pass.>, [<.lNoBorder.>], <nHelpId>,;
            <.spin.>, <{SpnUp}>, <{SpnDn}>, <{Min}>, <{Max}>,;
            [{|Self|<uHelp>}], [{|Self|<uMult>}], <cBmp>, <oSay> )

#xcommand DEFINE SHELL [<oWnd>] ;
            [ FROM <nTop>, <nLeft> TO <nBottom>, <nRight> ] ;
            [ TITLE <cTitle> ] ;
            [ CURSOR <oCursor> ] ;
            [ MENU <oMenu> ] ;
            [ ICON <oIco> ] ;
            [ OF <oParent> ] ;
            [ <pixel: PIXEL> ] ;
            [ <HelpId: HELPID, HELP ID> <nHelpId> ] ;
            [ FIELDS <Flds,...> ];
            [ ALIAS <cAlias> ] ;
            [ <head:HEAD,HEADER,HEADERS,TITLE> <aHeaders,...> ] ;
            [ <sizes:FIELDSIZES, SIZES, COLSIZES> <aColSizes,...> ] ;
            [ <select:FIELDSELECT, SELECTS, SELECT> <aColSelect,...> ] ;
            [ JUSTIFY <aJustify,...> ] ;
            [ <prm:PROMPT, PROMPTS, ITEMS> <cPrompt,...> ] ;
            [ APPEND <bAdd> ] ;
            [ EDIT <bEdit> ] ;
            [ DELETE <bDel> ] ;
            [ DUPLICAT <bDup> ] ;
            [ LEVEL <nLevel> ] ;
            [ MRU <cMru> ] ;
            [ BITMAP <cIniFile> ] ;
            [ <lBigStyle: BIGSTYLE> ] ;
            [ ZOOM <bZoo> ] ;
            [ <lXBrowse: XBROWSE > ] ;
            => ;
            [<oWnd> := ] TShell():New( <nTop>, <nLeft>, <nBottom>, <nRight>,;
            <cTitle>,;
            <oMenu>,;
            <oParent>,;
            <oIco>,;
            <oCursor>,;
            <.pixel.>,;
            <nHelpId>,;
            [\{ <{Flds}> \} ],;
            <cAlias>, ;
            [\{<aHeaders>\}],;
            [\{<aColSizes>\}],;
            [\{<aColSelect>\}],;
            [\{<aJustify>\}],;
            [\{<cPrompt>\}],;
            [\{||<bAdd>\}],;
            [\{||<bEdit>\}],;
            [\{||<bDel>\}],;
            [\{||<bDup>\}],;
            nil,;
            <nLevel>,;
            [<cMru>],;
            [<cIniFile>],;
            [<.lBigStyle.>],;
            [\{||<bZoo>\}],;
            [<.lXBrowse.>] )

#xcommand DEFINE BTNSHELL [ <oBtn> ] ;
            [ OF <oShell> ] ;
            [ <resource: NAME, RESNAME, RESOURCE> <cResName1> [,<cResName2>] ] ;
            [ <file: FILE, FILENAME, DISK> <cBmpFile1> [,<cBmpFile2>] ] ;
            [ ACTION <bAction> ] ;
            [ <group: GROUP > ] ;
            [ MESSAGE <cMsg> ] ;
            [ <adjust: ADJUST > ] ;
            [ WHEN <WhenFunc> ] ;
            [ TOOLTIP <cToolTip> ] ;
            [ <lPressed: PRESSED> ] ;
            [ ON DROP <bDrop> ] ;
            [ PROMPT <cPrompt> ] ;
            [ FONT <oFont> ] ;
            [ FONT OVER <oFontOver> ] ;
            [ <lNoBorder: NOBORDER> ] ;
            [ <action:MENU> <uMenu,...> ] ;
            [ HOTKEY <cKey> ] ;
            [ <mru: MRU> ] ;
            [ <mruSea: MRUSEARCH> ] ;
            [ LEVEL <nLevel> ] ;
            [ <lBeginGrp: BEGIN GROUP> ] ;
            [ <lOpen: CLOSED> ] ;
            [ FROM <oBar> ] ;
            [ <lAllowExit:ALLOW EXIT> ] ;
            => ;
            [ <oBtn> := ] <oShell>:NewAt( <cResName1>, <cResName2>,;
            <cMsg>, [\{||<bAction>\}], <cToolTip>, [<cKey>],;
            <cPrompt>, [{|This|<uMenu>}], [<nLevel>], <oBar>, <.lAllowExit.> )

#xcommand ACTIVATE SHELL <oWnd> ;
            [ <show: ICONIZED, NORMAL, MAXIMIZED> ] ;
            [ ON [ LEFT ] CLICK <uLClick> ] ;
            [ ON LBUTTONUP <uLButtonUp> ] ;
            [ ON RIGHT CLICK <uRClick> ] ;
            [ ON MOVE <uMove> ] ;
            [ ON RESIZE <uResize> ] ;
            [ ON PAINT <uPaint> ] ;
            [ ON KEYDOWN <uKeyDown> ] ;
            [ ON INIT <uInit> ] ;
            [ ON UP <uUp> ] ;
            [ ON DOWN <uDown> ] ;
            [ ON PAGEUP <uPgUp> ] ;
            [ ON PAGEDOWN <uPgDn> ] ;
            [ ON LEFT <uLeft> ] ;
            [ ON RIGHT <uRight> ] ;
            [ ON PAGELEFT <uPgLeft> ] ;
            [ ON PAGERIGHT <uPgRight> ] ;
            [ ON DROPFILES <uDropFiles> ] ;
            [ VALID <uValid> ] ;
            => ;
            <oWnd>:Activate( [ Upper(<(show)>) ],;
            <oWnd>:bLClicked [ := \{ |nRow,nCol,nKeyFlags| <uLClick> \} ], ;
            <oWnd>:bRClicked [ := \{ |nRow,nCol,nKeyFlags| <uRClick> \} ], ;
            <oWnd>:bMoved    [ := <{uMove}> ], ;
            <oWnd>:bResized  [ := <{uResize}> ], ;
            <oWnd>:bPainted  [ := \{ | hDC, cPS | <uPaint> \} ], ;
            <oWnd>:bKeyDown  [ := \{ | nKey | <uKeyDown> \} ],;
            <oWnd>:bInit     [ := \{ | Self | <uInit> \} ],;
            [<{uUp}>], [<{uDown}>], [<{uPgUp}>], [<{uPgDn}>],;
            [<{uLeft}>], [<{uRight}>], [<{uPgLeft}>], [<{uPgRight}>],;
            [<{uValid}>], [\{|nRow,nCol,aFiles|<uDropFiles>\}],;
            <oWnd>:bLButtonUp [ := <{uLButtonUp}> ] )

#xcommand @ <nRow>, <nCol> WEBBAR [<oBar>] ;
            [ SIZE <nWidth>, <nHeight> ] ;
            [ CTLHEIGHT <nCtlHeight> ] ;
            [ BITMAP <cBitmap> ] ;
            [ RESOURCE <cResBmp>] ;
            [ COLOR <nClrFore> [,<nClrBack>] ] ;
            [ STYLE <cStyle> ] ;
            [ BRUSH <oBrush> ] ;
            [ FONT <oFont> ] ;
            [ <pixel: PIXEL> ] ;
            [ MESSAGE <cMsg> ] ;
            [ <of:OF, WINDOW, DIALOG> <oWnd> ] ;
            [ <help:HELP, HELPID, HELP ID> <nHelpId> ] ;
            [ ON RIGHT CLICK <uRClick> ] ;
=> ;
[ <oBar> := ] TWebBar():New( <nRow>, <nCol>, ;
                                <nWidth>,;
                                <nHeight>,;
                                <nCtlHeight>,;
                                [<cBitmap>],;
                                [<cResBmp>],;
                                [<nClrFore>],;
                                [<nClrBack>],;
                                [<cStyle>],;
                                [<oBrush>],;
                                [<oFont>],;
                                [<.pixel.>],;
                                [<cMsg>],;
                                [<oWnd>],;
                                [<nHelpId>],;
                                [\{|nRow,nCol,nFlags|<uRClick>\}] )

#xcommand REDEFINE CHECKBOX [ <oCbx> VAR ] <lVar> ;
             [ ID <nId> ] ;
             [ <of:OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <help:HELPID, HELP ID> <nHelpId> ] ;
             [ <click:ON CLICK, ON CHANGE> <uClick> ];
             [ VALID <uValid> ] ;
             [ <color: COLOR, COLORS> <nClrFore> [,<nClrBack>] ] ;
             [ MESSAGE <cMsg> ] ;
             [ <update: UPDATE> ] ;
             [ WHEN <uWhen> ] ;
             [ <grayed: GRAYED> ] ;
       => ;
          [ <oCbx> := ] TCheckBox():ReDefine( <nId>, bSETGET(<lVar>),;
             <oWnd>, <nHelpId>, [<{uClick}>], <{uValid}>, <nClrFore>,;
             <nClrBack>, <cMsg>, <.update.>, <{uWhen}>, <.grayed.> )

#xcommand @ <nRow>, <nCol> CHECKBOX [ <oCbx> VAR ] <lVar> ;
             [ PROMPT <cCaption> ] ;
             [ <of:OF, WINDOW, DIALOG> <oWnd> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ <help:HELPID, HELP ID> <nHelpId> ] ;
             [ FONT <oFont> ] ;
             [ <change: ON CLICK, ON CHANGE> <uClick> ] ;
             [ VALID   <ValidFunc> ] ;
             [ <color: COLOR, COLORS> <nClrFore> [,<nClrBack>] ] ;
             [ <design: DESIGN> ] ;
             [ <pixel: PIXEL> ] ;
             [ MESSAGE <cMsg> ] ;
             [ <update: UPDATE> ] ;
             [ WHEN <WhenFunc> ] ;
             [ <grayed: GRAYED> ] ;
      => ;
         [ <oCbx> := ] TCheckBox():New( <nRow>, <nCol>, <cCaption>,;
             bSETGET(<lVar>), <oWnd>, <nWidth>, <nHeight>, <nHelpId>,;
             [<{uClick}>], <oFont>, <{ValidFunc}>, <nClrFore>, <nClrBack>,;
             <.design.>, <.pixel.>, <cMsg>, <.update.>, <{WhenFunc}>, <.grayed.> )

/*----------------------------------------------------------------------------//
Browse inteligente
*/

#xcommand REDEFINE IBROWSE [ <oLbx> ] FIELDS [<Flds,...>] ;
             [ ALIAS <cAlias> ] ;
             [ ID <nId> ] ;
             [ <dlg:OF,DIALOG> <oDlg> ] ;
             [ <sizes:FIELDSIZES, SIZES, COLSIZES> <aColSizes,...> ] ;
             [ <head:HEAD,HEADER,HEADERS,TITLE> <aHeaders,...> ] ;
             [ SELECT <cField> FOR <uValue1> [ TO <uValue2> ] ] ;
             [ ON CHANGE <uChange> ] ;
             [ ON [ LEFT ] CLICK <uLClick> ] ;
             [ ON [ LEFT ] DBLCLICK <uLDblClick> ] ;
             [ ON RIGHT CLICK <uRClick> ] ;
             [ FONT <oFont> ] ;
             [ CURSOR <oCursor> ] ;
             [ <color: COLOR, COLORS> <nClrFore> [,<nClrBack>] ] ;
             [ MESSAGE <cMsg> ] ;
             [ <update: UPDATE> ] ;
             [ WHEN <uWhen> ] ;
             [ VALID <uValid> ] ;
             [ ACTION <uAction,...> ] ;
             [ <just:JUST,JUSTIFY> <aJustify,...> ] ;
             [ <selected:SELECTED> <aSelected,...> ] ;
       => ;
             [ <oLbx> := ] IWBrowse():ReDefine( <nId>, ;
             [\{ <{Flds}> \} ],;
             <oDlg>,;
             [ \{<aHeaders>\} ], [\{<aColSizes>\}],;
             <(cField)>, <uValue1>, <uValue2>,;
             [<{uChange}>],;
             [\{|nRow,nCol,nFlags|<uLDblClick>\}],;
             [\{|nRow,nCol,nFlags|<uRClick>\}],;
             <oFont>, <oCursor>, <nClrFore>, <nClrBack>, <cMsg>, <.update.>,;
             <cAlias>, <{uWhen}>, <{uValid}>,;
             [\{|nRow,nCol,nFlags|<uLClick>\}],;
             [\{<{uAction}>\}],;
             [\{<aJustify>\}],;
             [\{<aSelected>\}] )

#command SET ADSINDEX TO [<(i)> ] [<add: ADDITIVE>] => ;
         [ if !lAIS() ; ordListAdd( <(i)> ) ; else ; ordSetFocus( 1 ) ; end ]

/* Generic error codes (oError:genCode) */

#ifndef EG_ZERODIV
#define EG_ZERODIV      5
#endif

#ifndef __C3__

#define ZipClose                MyZipClose
#define ZipNew                  MyZipNew
#define ZipSetCompressLevel     MyZipSetCompressLevel
#define ZipSetPassword          MyZipSetPassword
#define ZipSetReadOnly          MyZipSetReadOnly
#define ZipSetExtractPath       MyZipSetExtractPath
#define ZipSetRootPath          MyZipSetRootPath
#define ZipSetFilePath          MyZipSetFilePath
#define ZipSetFiles             MyZipSetFiles
#define ZipGetCompressLevel     MyZipGetCompressLevel
#define ZipGetPassword          MyZipGetPassword
#define ZipCreate               MyZipCreate
#define ZipOpen                 MyZipOpen
#define ZipAddFile              MyZipAddFile
#define ZipAddFiles             MyZipAddFiles
#define ZipExtractFiles         MyZipExtractFiles

#endif

#xtranslate MinMax( <xValue>, <nMin>, <nMax> ) => Min( Max( <xValue>, <nMin> ), <nMax> )
