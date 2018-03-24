#include "FiveWin.Ch"
#include "Font.ch"
#include "Report.ch"
#include "Factu.ch" 
#include "Xbrowse.ch"

static oWndBrw
static cNewFile
static cCdxFile
static cNewFil2
static dbfArticulo
static dbfTarPreT
static dbfTarPreL
static dbfTarPreS
static dbfAgentes
static dbfDivisa
static dbfFamilia
static dbfPro
static dbfProL
static oBandera
static cPouDiv

static dbfTmpArticulo
static dbfTmpAgente

static bEdit      := {  |aTmp, aGet, dbfTarPreT, oBrw, bWhen, bValid, nMode |          EdtRec(     aTmp, aGet, dbfTarPreT, oBrw, bWhen, bValid, nMode ) }
static bEdit2     := {  |aTmp, aGet, dbfTarPreL, oBrw, bWhen, bValid, nMode, cCodTar | EdtDet(     aTmp, aGet, dbfTarPreL, oBrw, bWhen, bValid, nMode, cCodTar ) }
static bEdit3     := {  |aTmp, aGet, dbfTarPreS, oBrw, bWhen, bValid, nMode, cCodArt | EdtExtDet(  aTmp, aGet, dbfTarPreS, oBrw, bWhen, bValid, nMode, cCodArt ) }

#ifndef __PDA__

//----------------------------------------------------------------------------//
//Funciones del programa
//----------------------------------------------------------------------------//

function aItmTar()

   local aItmTar  :=  {}

   aAdd( aItmTar, { "CCODTAR",   "C",  5,  0, "Código de la tarifa" ,  "",  "", "( cDbf )" } )
   aAdd( aItmTar, { "CNOMTAR",   "C", 30,  0, "Nombre de la tarifa" ,  "",  "", "( cDbf )" } )

return ( aItmTar )

//----------------------------------------------------------------------------//

function aItmTarifaLineas()

   local aItmTar  := {}

   aAdd( aItmTar, { "CCODTAR",   "C",    5,    0, "Código de la tarifa" }            )                 
   aAdd( aItmTar, { "NTIPTAR",   "N",    1,    0, "Tipo de tarifa" }                 )
   aAdd( aItmTar, { "CCODART",   "C",   18,    0, "Código del artículo" }            )      
   aAdd( aItmTar, { "CNOMART",   "C",   50,    0, "Nombre del artículo" }            )      
   aAdd( aItmTar, { "CCODFAM",   "C",   16,    0, "Código de la família" }           )      
   aAdd( aItmTar, { "CNOMFAM",   "C",   50,    0, "Nombre de la família" }           )      
   aAdd( aItmTar, { "NPRCTAR1",  "N",   16,    6, "Precio del artículo 1" }          )      
   aAdd( aItmTar, { "NPRCTAR2",  "N",   16,    6, "Precio del artículo 2" }          )      
   aAdd( aItmTar, { "NPRCTAR3",  "N",   16,    6, "Precio del artículo 3" }          )      
   aAdd( aItmTar, { "NPRCTAR4",  "N",   16,    6, "Precio del artículo 4" }          )      
   aAdd( aItmTar, { "NPRCTAR5",  "N",   16,    6, "Precio del artículo 5" }          )      
   aAdd( aItmTar, { "NPRCTAR6",  "N",   16,    6, "Precio del artículo 6" }          )      
   aAdd( aItmTar, { "NDTOART",   "N",    6,    2, "Descuento fijo del artículo" }    )
   aAdd( aItmTar, { "CDIVART",   "C",    3,    0, "Código de la divisa" }            )
   aAdd( aItmTar, { "NDTODIV",   "N",   16,    6, "Descuento lineal del artículo" }  )
   aAdd( aItmTar, { "DINIPRM",   "D",    8,    0, "Fecha inicio de promoción" }      )
   aAdd( aItmTar, { "DFINPRM",   "D",    8,    0, "Fecha final de promoción" }       )
   aAdd( aItmTar, { "NDTOPRM",   "N",    6,    2, "Descuento promoción" }            )
   aAdd( aItmTar, { "CCODPR1",   "C",   20,    0, "Código de primera propiedad" }    )
   aAdd( aItmTar, { "CCODPR2",   "C",   20,    0, "Código de segunda propiedad" }    )
   aAdd( aItmTar, { "CVALPR1",   "C",   20,    0, "Valor de primera propiedad" }     )
   aAdd( aItmTar, { "CVALPR2",   "C",   20,    0, "Valor de segunda propiedad" }     )

Return ( aItmTar )      

//----------------------------------------------------------------------------//

function aItmTarifaAgentes()

   local aItmTar  := {}

   aAdd( aItmTar, { "CCODTAR",   "C",    5,    0, "Código de la tarifa" }                 )
   aAdd( aItmTar, { "CCODART",   "C",   18,    0, "Código del artículo" }                 )   
   aAdd( aItmTar, { "CCODFAM",   "C",   16,    0, "Código de la família" }                )
   aAdd( aItmTar, { "CCODPR1",   "C",   20,    0, "Código de primera propiedad" }         )
   aAdd( aItmTar, { "CCODPR2",   "C",   20,    0, "Código de segunda propiedad" }         )
   aAdd( aItmTar, { "CVALPR1",   "C",   20,    0, "Valor de primera propiedad" }          )
   aAdd( aItmTar, { "CVALPR2",   "C",   20,    0, "Valor de segunda propiedad" }          )
   aAdd( aItmTar, { "CCODAGE",   "C",    3,    0, "Código del agentes" }                  )
   aAdd( aItmTar, { "NCOMAGE",   "N",    6,    2, "Porcentaje de comisión del agente" }   )
   aAdd( aItmTar, { "NCOMPRM",   "N",    6,    2, "Porcentaje de comisión en promoción" } )

Return ( aItmTar )

//----------------------------------------------------------------------------//

FUNCTION Tarifa( oMenuItem, oWnd )

   local nLevel

   DEFAULT  oMenuItem   := "01019"
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

      if !OpenFiles()
         return nil
      end if

      /*
      Anotamos el movimiento para el navegador---------------------------------
      */

      AddMnuNext( "Tarifa de precios", ProcName() )

      DEFINE SHELL oWndBrw ;
      FROM     0, 0 TO 22, 80;
      XBROWSE ;
      TITLE    "Tarifa de precios" ;
      PROMPT   "Código",;
					"Nombre";
      MRU      "gc_symbol_percent_16";
      BITMAP   clrTopArchivos ;
      APPEND   ( WinAppRec( oWndBrw:oBrw, bEdit, dbfTarPreT ) );
      DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdit, dbfTarPreT ) );
		EDIT 		( WinEdtRec( oWndBrw:oBrw, bEdit, dbfTarPreT ) ) ;
		DELETE   ( DBDelRec(  oWndBrw:oBrw, dbfTarPreT ) ) ;
		ALIAS		( dbfTarPreT ) ;
		OF 		oWnd

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodTar"
         :bEditValue       := {|| ( dbfTarPreT )->cCodTar }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomTar"
         :bEditValue       := {|| ( dbfTarPreT )->cNomTar }
         :nWidth           := 280
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      oWndBrw:CreateXFromCode()

      /*
      Botones------------------------------------------------------------------
      */

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
         HOTKEY   "D" ;
         LEVEL    ACC_APPD

		DEFINE BTNSHELL RESOURCE "EDIT" OF oWndBrw ;
			NOBORDER ;
			ACTION  	( oWndBrw:RecEdit() );
			TOOLTIP 	"(M)odificar";
         MRU ;
         HOTKEY   "M";
         LEVEL    ACC_EDIT

		DEFINE BTNSHELL RESOURCE "ZOOM" OF oWndBrw ;
			NOBORDER ;
			ACTION  	( WinZooRec( oWndBrw:oBrw, bEdit, dbfTarPreT ) );
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

#ifndef  __TACTIL__

      DEFINE BTNSHELL RESOURCE "IMP" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( InfTar():New( "Listado de tarifas" ):Play() ) ;
         TOOLTIP  "(L)istado" ;
         HOTKEY   "L" ;
         LEVEL    ACC_IMPR

#endif

      DEFINE BTNSHELL RESOURCE "END" GROUP OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:end() ) ;
         TOOLTIP  "(S)alir" ;
			HOTKEY 	"S"

	ACTIVATE WINDOW oWndBrw VALID CloseFiles()

	ELSE

		oWndBrw:SetFocus()

	END IF

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aTmp, aGet, dbfTarPreT, oBrw, bWhen, bValid, nMode )

	local oDlg
	local oGet
   local oBrwDet
   local oOrden
   local cOrden   := "Código artículo"

   BeginTrans( aTmp )

   DEFINE DIALOG oDlg RESOURCE "TARIFAS" TITLE LblTitle( nMode ) + "tarifas"

      /*
		Redefinición de la primera caja de Dialogo
		*/

      REDEFINE GET oGet VAR aTmp[ (dbfTarPreT)->( FieldPos( "CCODTAR" ) ) ];
			ID 		100 ;
			PICTURE 	"@!" ;
         VALID    ( NotValid( oGet, dbfTarPreT, .t., "0" ) ) ;
         WHEN     ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) ;
			OF 		oDlg

      REDEFINE GET aTmp[ (dbfTarPreT)->( FieldPos( "CNOMTAR" ) ) ] ;
			ID 		110 ;
			PICTURE 	"@!" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      oBrwDet                 := IXBrowse():New( oDlg )

      oBrwDet:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwDet:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwDet:cAlias          := dbfTmpArticulo
      oBrwDet:nMarqueeStyle   := 5
      oBrwDet:cName           := "Tarifa.Detalle"

      with object ( oBrwDet:AddCol() )
         :cHeader          := "Tipo"
         :bEditValue       := {|| if( ( dbfTmpArticulo )->nTipTar <= 1, "Artículo", "Familia" ) }
         :nWidth           := 60
      end with

      with object ( oBrwDet:AddCol() )
         :cHeader          := "Código"
         :bEditValue       := {|| if( ( dbfTmpArticulo )->nTipTar <= 1, ( dbfTmpArticulo )->cCodArt, ( dbfTmpArticulo )->cCodFam ) }
         :nWidth           := 80
      end with

      with object ( oBrwDet:AddCol() )
         :cHeader          := "Nombre"
         :bEditValue       := {|| if( ( dbfTmpArticulo )->nTipTar <= 1, ( dbfTmpArticulo )->cNomArt, ( dbfTmpArticulo )->cNomFam ) }
         :nWidth           := 160
      end with

      with object ( oBrwDet:AddCol() )
         :cHeader          := "Prop. 1"
         :bEditValue       := {|| ( dbfTmpArticulo )->cValPr1 }
         :nWidth           := 40
      end with

      with object ( oBrwDet:AddCol() )
         :cHeader          := "Prop. 2"
         :bEditValue       := {|| ( dbfTmpArticulo )->cValPr2 }
         :nWidth           := 40
      end with

      with object ( oBrwDet:AddCol() )
         :cHeader          := "Precio 1"
         :bEditValue       := {|| ( dbfTmpArticulo )->nPrcTar1 }
         :cEditPicture     := cPouDiv
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrwDet:AddCol() )
         :cHeader          := "Precio 2"
         :bEditValue       := {|| ( dbfTmpArticulo )->nPrcTar2 }
         :cEditPicture     := cPouDiv
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrwDet:AddCol() )
         :cHeader          := "Precio 3"
         :bEditValue       := {|| ( dbfTmpArticulo )->nPrcTar3 }
         :cEditPicture     := cPouDiv
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrwDet:AddCol() )
         :cHeader          := "Precio 4"
         :bEditValue       := {|| ( dbfTmpArticulo )->nPrcTar4 }
         :cEditPicture     := cPouDiv
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrwDet:AddCol() )
         :cHeader          := "Precio 5"
         :bEditValue       := {|| ( dbfTmpArticulo )->nPrcTar5 }
         :cEditPicture     := cPouDiv
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrwDet:AddCol() )
         :cHeader          := "Precio 6"
         :bEditValue       := {|| ( dbfTmpArticulo )->nPrcTar6 }
         :cEditPicture     := cPouDiv
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrwDet:AddCol() )
         :cHeader          := "% Descuento"
         :bEditValue       := {|| ( dbfTmpArticulo )->nDtoArt }
         :cEditPicture     := "@E 999.99"
         :nWidth           := 40
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrwDet:AddCol() )
         :cHeader          := "% Promoción"
         :bEditValue       := {|| ( dbfTmpArticulo )->nDtoArt }
         :cEditPicture     := "@E 999.99"
         :nWidth           := 40
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrwDet:AddCol() )
         :cHeader          := "Dto. lineal"
         :bEditValue       := {|| ( dbfTmpArticulo )->nDtoDiv }
         :cEditPicture     := cPouDiv
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      oBrwDet:bLDblClick      := {|| EdtDeta(oBrwDet, bEdit2, aTmp ) }
      oBrwDet:bRClicked       := {| nRow, nCol, nFlags | oBrwDet:RButtonDown( nRow, nCol, nFlags ) }

      oBrwDet:CreateFromResource( 200 )

      REDEFINE COMBOBOX oOrden VAR cOrden ;
         ITEMS    { "Código artículo", "Nombre artículo", "Código família", "Nombre família" } ;
         ID       210 ;
         ON CHANGE( ( dbfTmpArticulo )->( OrdSetFocus( oOrden:nAt ) ), oBrwDet:refresh() );
         OF       oDlg

      REDEFINE BUTTON;
			ID 		500 ;
			OF 		oDlg ;
         WHEN     ( ( SQLAjustableModel():getRolCambiarPrecios( Auth():rolUuid() ) ) .and. nMode != ZOOM_MODE );
         ACTION   ( AppDeta( oBrwDet, bEdit2, aTmp ) )

      REDEFINE BUTTON;
			ID 		501 ;
			OF 		oDlg ;
         WHEN     ( ( SQLAjustableModel():getRolCambiarPrecios( Auth():rolUuid() ) ) .and. nMode != ZOOM_MODE );
         ACTION   ( EdtDeta( oBrwDet, bEdit2, aTmp ) )

      REDEFINE BUTTON;
			ID 		502 ;
			OF 		oDlg ;
         WHEN     ( ( SQLAjustableModel():getRolCambiarPrecios( Auth():rolUuid() ) ) .and. nMode != ZOOM_MODE );
         ACTION   ( DelDeta( oBrwDet, aTmp ) )

      REDEFINE BUTTON ;
         ID       503 ;
			OF 		oDlg ;
         ACTION   ( EdtZoom( oBrwDet, bEdit2, aTmp ) )

      REDEFINE BUTTON ;
         ID       504 ;
			OF 		oDlg ;
         ACTION   ( Searching( dbfTmpArticulo, { "Código artículo", "Nombre artículo", "Código família", "Nombre família" }, oBrwDet ) )

      REDEFINE BUTTON;
			ID 		511 ;
			OF 		oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( EndTrans( aTmp, aGet, dbfTarPreT, oBrw, oBrwDet, nMode, oDlg ) )

		REDEFINE BUTTON ;
			ID 		510 ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      REDEFINE BUTTON ;
         ID       559 ;
			OF 		oDlg ;
         ACTION   ( ChmHelp( "Tarifas" ) )

      if ( SQLAjustableModel():getRolCambiarPrecios( Auth():rolUuid() ) ) .and. nMode != ZOOM_MODE
         oDlg:AddFastKey( VK_F2, {|| AppDeta(oBrwDet, bEdit2, aTmp) } )
         oDlg:AddFastKey( VK_F3, {|| EdtDeta(oBrwDet, bEdit2, aTmp ) } )
         oDlg:AddFastKey( VK_F4, {|| DelDeta( oBrwDet, aTmp ) } )
         oDlg:AddFastKey( VK_F5, {|| EndTrans( aTmp, aGet, dbfTarPreT, oBrw, oBrwDet, nMode, oDlg ) } )
      end if

      oDlg:AddFastKey( VK_F1, {|| ChmHelp( "Tarifas" ) } )

      oDlg:bStart := {|| oBrwDet:Load(), oGet:SetFocus() }

	ACTIVATE DIALOG oDlg	CENTER

   KillTrans( oBrwDet )

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

/*
Funcion Auxiliar para A¤adir lineas de detalle
*/

STATIC FUNCTION AppDeta( oBrw, bEdit2, aTmp )

RETURN WinAppRec( oBrw, bEdit2, dbfTmpArticulo, , , aTmp[ (dbfTarPreT)->( FieldPos( "CCODTAR" ) ) ] )

//---------------------------------------------------------------------------//

/*
Funcion Auxiliar para la Edición de Lineas de Detalle
*/

STATIC FUNCTION EdtDeta( oBrw, bEdit2, aTmp )

RETURN WinEdtRec( oBrw, bEdit2, dbfTmpArticulo )

//---------------------------------------------------------------------------//

STATIC FUNCTION EdtZoom( oBrw, bEdit2, aTmp )

RETURN WinZooRec( oBrw, bEdit2, dbfTmpArticulo )

//---------------------------------------------------------------------------//

/*
Funcion Auxiliar para borrar las Lineas de Detalle
*/

STATIC FUNCTION DelDeta( oBrw, aTmp )

RETURN DBDelRec( oBrw, dbfTmpArticulo )

//--------------------------------------------------------------------------//

STATIC FUNCTION BeginTrans( aTmp )

   local cDbf     := "TTarL"
   local cCodTar  := aTmp[ ( dbfTarPreT )->( FieldPos( "CCODTAR" ) ) ]

   cNewFile       := cGetNewFileName( cPatTmp() + cDbf, "DBF", .t. )
   cCdxFile       := cGetNewFileName( cPatTmp() + cDbf, "CDX", .t. )

	/*
	Primero Crear la base de datos local
	*/

   dbCreate( cNewFile, aSqlStruct( aItmTarifaLineas() ), cLocalDriver() )

   dbUseArea( .t., cLocalDriver(), cNewFile, cCheckArea( cDbf, @dbfTmpArticulo ), .f. )
   if !( dbfTmpArticulo )->( neterr() )

      ( dbfTmpArticulo )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfTmpArticulo )->( ordCreate( cCdxFile, "cCodArt", "Field->cCodArt", {|| Field->cCodArt } ) )

      ( dbfTmpArticulo )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfTmpArticulo )->( ordCreate( cCdxFile, "cNomArt", "Field->cNomArt", {|| Field->cNomArt } ) )

      ( dbfTmpArticulo )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfTmpArticulo )->( ordCreate( cCdxFile, "cCodFam", "Field->cCodFam", {|| Field->cCodFam } ) )

      ( dbfTmpArticulo )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfTmpArticulo )->( ordCreate( cCdxFile, "cNomFam", "Field->cNomFam", {|| Field->cNomFam } ) )

      ( dbfTmpArticulo )->( ordListAdd( cCdxFile ) )

      /*
      A¤adimos desde el fichero de lineas-----------------------------------------
      */

      if ( dbfTarPreL )->( dbSeek( cCodTar ) )

         do while ( ( dbfTarPreL )->cCodTar == cCodTar .AND. !( dbfTarPreL )->( Eof() ) )

            dbPass( dbfTarPreL, dbfTmpArticulo, .t. )

            if Empty( ( dbfTmpArticulo )->cNomArt )
               ( dbfTmpArticulo )->cNomArt := RetArticulo( ( dbfTmpArticulo )->cCodArt, dbfArticulo )
            end if

            if Empty( ( dbfTmpArticulo )->cNomFam )
               ( dbfTmpArticulo )->cNomFam := RetFamilia( ( dbfTmpArticulo )->cCodFam, dbfFamilia )
            end if

            ( dbfTarPreL )->( dbSkip() )

         end while

      end if

      ( dbfTmpArticulo )->( ordSetFocus( "cCodArt" ) )
      ( dbfTmpArticulo )->( dbGoTop() )

   end if

RETURN NIL

//-----------------------------------------------------------------------//

STATIC FUNCTION EndTrans( aTmp, aGet, dbfTarPreT, oBrw, oBrwDet, nMode, oDlg )

   local oError
   local oBlock
   local aTabla
   local cCodTar  := aTmp[ ( dbfTarPreT )->( FieldPos( "CCODTAR" ) ) ]

   if nMode == APPD_MODE .or. nMode == DUPL_MODE

      if Empty( cCodTar )
         MsgStop( "Código no puede estar vacio" )
         return nil
     end if

      if dbSeekInOrd( cCodTar, "CCODTAR", dbfTarPreT )
         msgStop( "Código ya existe" )
         return nil
      end if

   end if

   /*
   Inicio de la transaccion----------------------------------------------------
   */

   oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      BeginTransaction()

      /*
      Roll Back-------------------------------------------------------------------
      */

      while ( dbfTarPreL )->( dbSeek( cCodTar ) ) .and. !( dbfTarPreL )->( eof() )
         if dbLock( dbfTarPreL )
            ( dbfTarPreL )->( dbDelete() )
            ( dbfTarPreL )->( dbUnLock() )
         end if
      end while

      /*
      Ahora escribimos en el fichero definitivo-----------------------------------
      */

      ( dbfTmpArticulo )->( dbGoTop() )
      while !( dbfTmpArticulo )->( Eof() )

         aTabla                                                := dbScatter( dbfTmpArticulo )
         aTabla[ ( dbfTarPreL )->( FieldPos( "CCODTAR" ) ) ]   := cCodTar

         dbGather( aTabla, dbfTarPreL, .t. )

         ( dbfTmpArticulo )->( dbSkip() )

      end while

      WinGather( aTmp, aGet, dbfTarPreT, oBrw, nMode )

      oDlg:End( IDOK )

      CommitTransaction()

   RECOVER USING oError

      RollBackTransaction()
      msgStop( "Imposible eliminar datos anteriores" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE
   ErrorBlock( oBlock )

RETURN .t.

//------------------------------------------------------------------------//

STATIC FUNCTION KillTrans( oBrwDet )

   if !Empty( dbfTmpArticulo ) .and. ( dbfTmpArticulo )->( Used() )
      ( dbfTmpArticulo )->( dbCloseArea() )
   end if

   if oBrwDet != nil
      oBrwDet:CloseData()
   end if

   fErase( cNewFile )
   fErase( cCdxFile )

   dbCommitAll()

RETURN .T.

//------------------------------------------------------------------------//

STATIC FUNCTION OpenFiles()

   local oBlock
   local oError
   local lOpen       := .t.

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      USE ( cPatArt() + "TARPRET.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TARPRET", @dbfTarPreT ) )
      SET ADSINDEX TO ( cPatArt() + "TARPRET.CDX" ) ADDITIVE

      USE ( cPatArt() + "TARPREL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TARPREL", @dbfTarPreL ) )
      SET ADSINDEX TO ( cPatArt() + "TARPREL.CDX" ) ADDITIVE

      USE ( cPatArt() + "TARPRES.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TARPRES", @dbfTarPreS ) )
      SET ADSINDEX TO ( cPatArt() + "TARPRES.CDX" ) ADDITIVE

      USE ( cPatArt() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
      SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

      USE ( cPatCli() + "AGENTES.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AGENTES", @dbfAgentes ) )
      SET ADSINDEX TO ( cPatCli() + "AGENTES.CDX" ) ADDITIVE

      USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDivisa ) )
      SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

      USE ( cPatArt() + "FAMILIAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FAMILIAS", @dbfFamilia ) )
      SET ADSINDEX TO ( cPatArt() + "FAMILIAS.CDX" ) ADDITIVE

      USE ( cPatArt() + "PRO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PRO", @dbfPro ) )
      SET ADSINDEX TO ( cPatArt() + "PRO.CDX" ) ADDITIVE

      USE ( cPatArt() + "TBLPRO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TBLPRO", @dbfProL ) )
      SET ADSINDEX TO ( cPatArt() + "TBLPRO.CDX" ) ADDITIVE

      oBandera    := TBandera():New
      cPouDiv     := cPouDiv( cDivEmp(), dbfDivisa )

   RECOVER USING oError

      lOpen      := .f.
      MsgStop ( "Imposible abrir la bases de datos de tarifas" + CRLF + ErrorMessage( oError ))

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpen
      CloseFiles()
   end if

RETURN( lOpen )

//----------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles()

   if( !Empty( dbfTarPreT ), ( dbfTarPreT )->( dbCloseArea() ), )
   if( !Empty( dbfTarPreL ), ( dbfTarPreL )->( dbCloseArea() ), )
   if( !Empty( dbfTarPreS ), ( dbfTarPreS )->( dbCloseArea() ), )
   if( !Empty( dbfArticulo), ( dbfArticulo)->( dbCloseArea() ), )
   if( !Empty( dbfAgentes ), ( dbfAgentes )->( dbCloseArea() ), )
   if( !Empty( dbfDivisa  ), ( dbfDivisa  )->( dbCloseArea() ), )
   if( !Empty( dbfFamilia ), ( dbfFamilia )->( dbCloseArea() ), )
   if( !Empty( dbfPro     ), ( dbfPro     )->( dbCloseArea() ), )
   if( !Empty( dbfProL    ), ( dbfProL    )->( dbCloseArea() ), )

	dbfTarPreT	:= NIL
	dbfTarPreL 	:= NIL
	dbfTarPreS	:= NIL
	dbfArticulo	:= NIL
	dbfAgentes	:= NIL
   dbfDivisa   := NIL
   dbfFamilia  := NIL
   oBandera    := NIL
   dbfPro      := NIL
   dbfProL     := NIL

   if oWndBrw  != nil
      oWndBrw  := nil
   end if

Return ( .t. )

//----------------------------------------------------------------------------//

FUNCTION mkTarifa( cPath, oMeter, lAppend, cPathOld )

   DEFAULT lAppend   := .f.
   DEFAULT cPath     := cPatArt()

   if !lExistTable( cPath + "TARPRET.DBF" )
      dbCreate( cPath + "TARPRET.DBF", aSqlStruct( aItmTar() ), cDriver() )
   end if

   if !lExistTable( cPath + "TARPREL.DBF" )
      dbCreate( cPath + "TARPREL.DBF", aSqlStruct( aItmTarifaLineas() ), cDriver() )
   end if

   if !lExistTable( cPath + "TARPRES.DBF" )
      dbCreate( cPath + "TARPRES.DBF", aSqlStruct( aItmTarifaAgentes() ), cDriver() )
   end if

   rxTarifa( cPath, oMeter )

   if lAppend .and. lIsDir( cPathOld )
      AppDbf( cPathOld, cPath, "TARPRET" )
      AppDbf( cPathOld, cPath, "TARPREL" )
      AppDbf( cPathOld, cPath, "TARPRES" )
   end if

RETURN NIL

//----------------------------------------------------------------------------//

Function rxTarifa( cPath, oMeter)

   DEFAULT cPath := cPatArt()

   if !lExistTable( cPath + "TARPRET.DBF" )
      dbCreate( cPath + "TARPRET.DBF", aSqlStruct( aItmTar() ), cDriver() )
   end if

   if !lExistTable( cPath + "TARPREL.DBF" )
      dbCreate( cPath + "TARPREL.DBF", aSqlStruct( aItmTarifaLineas() ), cDriver() )
   end if

   if !lExistTable( cPath + "TARPRES.DBF" )
      dbCreate( cPath + "TARPRES.DBF", aSqlStruct( aItmTarifaAgentes() ), cDriver() )
   end if

   fEraseIndex( cPath + "TARPRET.CDX" )
   fEraseIndex( cPath + "TARPREL.CDX" )
   fEraseIndex( cPath + "TARPRES.CDX" )

   USE ( cPath + "TARPRET.DBF" ) NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "TARPRET", @dbfTarPreT ) ) EXCLUSIVE
   
   if !( dbfTarPreT )->( neterr() )
      ( dbfTarPreT )->( __dbPack() )

      ( dbfTarPreT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfTarPreT )->( ordCreate( cPath + "TARPRET", "CCODTAR", "Field->CCODTAR", {|| Field->CCODTAR } ) )

      ( dbfTarPreT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfTarPreT )->( ordCreate( cPath + "TARPRET", "CNOMTAR", "Field->CNOMTAR", {|| Field->CNOMTAR } ) )

      ( dbfTarPreT )->( dbCloseArea() )
      dbfTarPreT  := nil
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de tarifas" )
   end if

   USE ( cPath + "TARPREL.DBF" ) NEW VIA ( cDriver() )ALIAS ( cCheckArea( "TARPREL", @dbfTarPreL ) ) EXCLUSIVE
   
   if !( dbfTarPreL )->( neterr() )
      ( dbfTarPreL )->( __dbPack() )

      ( dbfTarPreL )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfTarPreL )->( ordCreate( cPath + "TARPREL", "CCODART", "Field->CCODTAR + Field->CCODART", {|| Field->CCODTAR + Field->CCODART } ) )

      ( dbfTarPreL )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfTarPreL )->( ordCreate( cPath + "TARPREL", "CNOMART", "Field->CCODTAR + Field->CNOMART", {|| Field->CCODTAR + Field->CNOMART } ) )

      ( dbfTarPreL )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfTarPreL )->( ordCreate( cPath + "TARPREL", "CCODFAM", "Field->CCODTAR + Field->CCODFAM", {|| Field->CCODTAR + Field->CCODFAM } ) )

      ( dbfTarPreL )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfTarPreL )->( ordCreate( cPath + "TARPREL", "CNOMFAM", "Field->CCODTAR + Field->CNOMFAM", {|| Field->CCODTAR + Field->CNOMFAM } ) )

      ( dbfTarPreL )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfTarPreL )->( ordCreate( cPath + "TARPREL", "CTARPRP", "Field->CCODTAR + Field->CCODART + Field->CCODPR1 + Field->CCODPR2 + Field->CVALPR1 + Field->CVALPR2", {|| Field->CCODTAR + Field->CCODART + Field->CCODPR1 + Field->CCODPR2 + Field->CVALPR1 + Field->CVALPR2 } ) )

      ( dbfTarPreL )->( dbCloseArea() )
      dbfTarPreL  := nil
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de tarifas" )
   end if

   USE ( cPath + "TARPRES.DBF" ) NEW VIA ( cDriver() )ALIAS ( cCheckArea( "TARPRES", @dbfTarPreS ) ) EXCLUSIVE
   
   if !( dbfTarPreS )->( neterr() )
      ( dbfTarPreS )->( __dbPack() )

      ( dbfTarPreS )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfTarPreS )->( ordCreate( cPath + "TARPRES.CDX", "CCODACC", "Field->CCODTAR + Field->CCODART + Field->CCODFAM + Field->CCODPR1 + Field->CCODPR2 + Field->CVALPR1 + Field->CVALPR2", {|| Field->CCODTAR + Field->CCODART + Field->CCODFAM + Field->CCODPR1 + Field->CCODPR2 + Field->CVALPR1 + Field->CVALPR2 } ) )

      ( dbfTarPreS )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfTarPreS )->( ordCreate( cPath + "TARPRES.CDX", "CCODAGE", "Field->CCODTAR + Field->CCODART + Field->CCODFAM + Field->CCODPR1 + Field->CCODPR2 + Field->CVALPR1 + Field->CVALPR2 + Field->CCODAGE", {|| Field->CCODTAR + Field->CCODART + Field->CCODFAM + Field->CCODPR1 + Field->CCODPR2 + Field->CVALPR1 + Field->CVALPR2 + Field->CCODAGE } ) )

      ( dbfTarPreS )->( dbCloseArea() )
      dbfTarPreS  := nil
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de tarifas" )
   end if

RETURN NIL

//--------------------------------------------------------------------------//

/*
Edita las lineas de Detalle
*/

STATIC FUNCTION EdtDet( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, cCodTar )

   local oDlg
   local oFld
   local oTxt
   local cTxt        := ""
   local oBrwExt
   local oSayPr1
   local oSayPr2
   local cSayPr1
   local cSayPr2
   local oSayVp1
   local oSayVp2
   local cSayVp1
   local cSayVp2

   if nMode == APPD_MODE

      aTmp[ ( dbfTarPreL )->( FieldPos( "CCODTAR" ) ) ] := cCodTar

   else

      if !Empty( aTmp[ ( dbfTarPreL )->( FieldPos( "CCODPR1" ) ) ] )
         cSayPr1 := retProp( aTmp[ ( dbfTarPreL )->( FieldPos( "CCODPR1" ) ) ], dbfPro )
         cSayVp1 := retValProp( aTmp[ ( dbfTarPreL )->( FieldPos( "CCODPR1" ) ) ] + aTmp[ ( dbfTarPreL )->( FieldPos( "CVALPR1" ) ) ], dbfProL )
      end if

      if !Empty( aTmp[ ( dbfTarPreL )->( FieldPos( "CCODPR2" ) ) ] )
         cSayPr2 := retProp( aTmp[ ( dbfTarPreL )->( FieldPos( "CCODPR2" ) ) ], dbfPro )
         cSayVp2 := retValProp( aTmp[ ( dbfTarPreL )->( FieldPos( "CCODPR2" ) ) ] + aTmp[ ( dbfTarPreL )->( FieldPos( "CVALPR2" ) ) ], dbfProL )
      end if

   end if

   if Empty( aTmp[ ( dbfTarPreL )->( FieldPos( "CDIVART" ) ) ] )
      aTmp[ ( dbfTarPreL )->( FieldPos( "CDIVART" ) ) ] := cDivEmp()
   end if

   BeginTr2( aTmp )

   DEFINE DIALOG oDlg RESOURCE "LTARPRE" TITLE LblTitle( nMode ) + "lineas a tarifas"

      REDEFINE FOLDER oFld ;
			ID 		500 ;
			OF 		oDlg ;
         PROMPT   "&Tarifa",;
                  "A&gentes";
         DIALOGS  "LTARPRE_1",;
                  "LTARPRE_2"

      REDEFINE RADIO aGet[ (dbfTarPreL)->( FieldPos( "NTIPTAR" ) ) ] ;
         VAR      aTmp[ (dbfTarPreL)->( FieldPos( "NTIPTAR" ) ) ];
         ON CHANGE( ChTipTar( aGet, aTmp, oSayPr1, oSayPr2, oSayVp1, oSayVp2 ) ) ;
         WHEN     ( nMode == APPD_MODE ) ;
         ID       90, 91 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ ( dbfTarPreL )->( FieldPos( "CCODART" ) ) ] ;
         VAR      aTmp[ ( dbfTarPreL )->( FieldPos( "CCODART" ) ) ];
			ID 		100 ;
         WHEN     ( aTmp[ ( dbfTarPreL )->( FieldPos( "NTIPTAR" ) ) ] == 1 .and. nMode == APPD_MODE ) ;
         VALID    ( IsTarTmp( aGet, aTmp, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2 ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwArticulo( aGet[ ( dbfTarPreL )->( FieldPos( "CCODART" ) ) ], aGet[ ( dbfTarPreL )->( FieldPos( "CNOMART" ) ) ] ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ ( dbfTarPreL )->( FieldPos( "CNOMART" ) ) ] ;
         VAR      aTmp[ ( dbfTarPreL )->( FieldPos( "CNOMART" ) ) ] ;
			ID 		110 ;
			WHEN 		( .F. ) ;
         OF       oFld:aDialogs[1]

      REDEFINE SAY oSayPr1 VAR cSayPr1;
         ID       888 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ (dbfTarPreL)->( FieldPos( "CVALPR1" ) ) ] VAR aTmp[ (dbfTarPreL)->( FieldPos( "CVALPR1" ) ) ];
         ID       250 ;
         BITMAP   "LUPA" ;
         WHEN     ( nMode == APPD_MODE ) ;
         ON HELP  ( brwPropiedadActual( aGet[ (dbfTarPreL)->( FieldPos( "CVALPR1" ) ) ], oSayVp1, aTmp[ (dbfTarPreL)->( FieldPos( "CCODPR1" ) ) ] ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oSayVp1 VAR cSayVp1;
         ID       251 ;
         WHEN     .f. ;
         OF       oFld:aDialogs[1]

      REDEFINE SAY oSayPr2 VAR cSayPr2;
         ID       889 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ (dbfTarPreL)->( FieldPos( "CVALPR2" ) ) ] VAR aTmp[ (dbfTarPreL)->( FieldPos( "CVALPR2" ) ) ];
         ID       260 ;
         BITMAP   "LUPA" ;
         WHEN     ( nMode == APPD_MODE ) ;
         ON HELP  ( brwPropiedadActual( aGet[ (dbfTarPreL)->( FieldPos( "CVALPR2" ) ) ], oSayVp2, aTmp[ (dbfTarPreL)->( FieldPos( "CCODPR2" ) ) ] ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oSayVp2 VAR cSayVp2;
         ID       261 ;
         WHEN     .f. ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ ( dbfTarPreL )->( FieldPos( "CCODFAM" ) ) ] ;
         VAR      aTmp[ ( dbfTarPreL )->( FieldPos( "CCODFAM" ) ) ];
         ID       105 ;
         WHEN     ( aTmp[ ( dbfTarPreL )->( FieldPos( "NTIPTAR" ) ) ] == 2 .and. nMode == APPD_MODE );
         VALID    ( IsFamTmp( aGet, aTmp, nMode ) );
         BITMAP   "LUPA" ;
         ON HELP  BrwFamilia( aGet[ ( dbfTarPreL )->( FieldPos( "CCODFAM" ) ) ], aGet[ ( dbfTarPreL )->( FieldPos( "CNOMFAM" ) ) ] ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ (dbfTarPreL)->( FieldPos( "CNOMFAM" ) ) ] ;
         VAR      aTmp[ (dbfTarPreL)->( FieldPos( "CNOMFAM" ) ) ] ;
         ID       106 ;
			WHEN 		( .F. ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ (dbfTarPreL)->( FieldPos( "NPRCTAR1" ) ) ];
         VAR      aTmp[ (dbfTarPreL)->( FieldPos( "NPRCTAR1" ) ) ];
         ID       120 ;
         SPINNER  ;
         WHEN     ( aTmp[ (dbfTarPreL)->( FieldPos( "NTIPTAR" ) ) ] <= 1 .and. nMode != ZOOM_MODE ) ;
         PICTURE  cPouDiv ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ (dbfTarPreL)->( FieldPos( "NPRCTAR2" ) ) ];
         VAR      aTmp[ (dbfTarPreL)->( FieldPos( "NPRCTAR2" ) ) ];
         ID       130 ;
         SPINNER  ;
         WHEN     ( aTmp[ (dbfTarPreL)->( FieldPos( "NTIPTAR" ) ) ] <= 1 .and. nMode != ZOOM_MODE ) ;
         PICTURE  cPouDiv ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ (dbfTarPreL)->( FieldPos( "NPRCTAR3" ) ) ];
         VAR      aTmp[ (dbfTarPreL)->( FieldPos( "NPRCTAR3" ) ) ];
         ID       140 ;
         SPINNER  ;
         WHEN     ( aTmp[ (dbfTarPreL)->( FieldPos( "NTIPTAR" ) ) ] <= 1 .and. nMode != ZOOM_MODE ) ;
         PICTURE  cPouDiv ;
         OF       oFld:aDialogs[1]

     REDEFINE GET aGet[ (dbfTarPreL)->( FieldPos( "NPRCTAR4" ) ) ];
         VAR      aTmp[ (dbfTarPreL)->( FieldPos( "NPRCTAR4" ) ) ];
         ID       150 ;
         SPINNER  ;
         WHEN     ( aTmp[ (dbfTarPreL)->( FieldPos( "NTIPTAR" ) ) ] <= 1 .and. nMode != ZOOM_MODE ) ;
         PICTURE  cPouDiv ;
         OF       oFld:aDialogs[1]

     REDEFINE GET aGet[ (dbfTarPreL)->( FieldPos( "NPRCTAR5" ) ) ];
         VAR      aTmp[ (dbfTarPreL)->( FieldPos( "NPRCTAR5" ) ) ];
         ID       160 ;
         SPINNER  ;
         WHEN     ( aTmp[ (dbfTarPreL)->( FieldPos( "NTIPTAR" ) ) ] <= 1 .and. nMode != ZOOM_MODE ) ;
         PICTURE  cPouDiv ;
         OF       oFld:aDialogs[1]

     REDEFINE GET aGet[ (dbfTarPreL)->( FieldPos( "NPRCTAR6" ) ) ];
         VAR      aTmp[ (dbfTarPreL)->( FieldPos( "NPRCTAR6" ) ) ];
         ID       170 ;
         SPINNER  ;
         WHEN     ( aTmp[ (dbfTarPreL)->( FieldPos( "NTIPTAR" ) ) ] <= 1 .and. nMode != ZOOM_MODE ) ;
         PICTURE  cPouDiv ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aTmp[ (dbfTarPreL)->( FieldPos( "NDTODIV" ) ) ];
         ID       190 ;
         SPINNER  ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( aTmp[ (dbfTarPreL)->( FieldPos( "NDTODIV" ) ) ] >= 0 );
         PICTURE  cPouDiv ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aTmp[ (dbfTarPreL)->( FieldPos( "NDTOART" ) ) ];
         ID       200 ;
         SPINNER  ;
         MIN      0;
         MAX      99 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			PICTURE	"@E 99.99" ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aTmp[ (dbfTarPreL)->( FieldPos( "DINIPRM" ) ) ] ;
         ID       220 ;
			SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ ( dbfTarPreL )->( FieldPos( "DFINPRM" ) ) ] ;
         VAR      aTmp[ ( dbfTarPreL )->( FieldPos( "DFINPRM" ) ) ] ;
         ID       230 ;
			SPINNER ;
         VALID    ( SetNumDay( aTmp, oTxt ) );
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET oTxt VAR cTxt ;
         ID       240 ;
         WHEN     ( .f. );
			OF 		oFld:aDialogs[1]

      REDEFINE GET aTmp[ (dbfTarPreL)->( FieldPos( "NDTOPRM" ) ) ];
         ID       210 ;
         SPINNER  ;
         MIN      0 ;
         MAX      100 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999.99" ;
         OF       oFld:aDialogs[1]

      /*
      REDEFINE IBROWSE oBrwExt ;
         FIELDS   (dbfTmpAgente)->CCODAGE + Space(1) + RetNbrAge( (dbfTmpAgente)->CCODAGE, dbfAgentes ),;
                  Trans( (dbfTmpAgente)->nComAge, "@E 99.99" ),;
                  Trans( (dbfTmpAgente)->nComPrm, "@E 99.99" );
         HEAD     "Agente",;
                  "Com.%",;
                  "Prm.";
			FIELDSIZES ;
                  260,;
                  60,;
                  60;
         JUSTIFY  .f.,;
                  .t.,;
                  .t.;
         ALIAS    ( dbfTmpAgente );
         ID       210 ;
         OF       oFld:aDialogs[2]

         oBrwExt:cWndName        := "Tarifas de precios agentes"
         oBrwExt:Load()

			IF nMode	!= ZOOM_MODE
            oBrwExt:bLDblClick   := {|| EdtDet2( oBrwExt, bEdit3, aTmp ) }
            oBrwExt:bAdd         := {|| AppDet2( oBrwExt, bEdit3, aTmp ) }
            oBrwExt:bEdit        := {|| EdtDet2( oBrwExt, bEdit3, aTmp ) }
            oBrwExt:bDel         := {|| DelDet2( oBrwExt ) }
			END IF
      */

      oBrwExt                 := IXBrowse():New( oFld:aDialogs[2] )

      oBrwExt:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwExt:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwExt:cAlias          := dbfTmpAgente
      oBrwExt:nMarqueeStyle   := 5
      oBrwExt:cName           := "Tarifa.Agente"

      with object ( oBrwExt:AddCol() )
         :cHeader          := "Código"
         :bEditValue       := {|| ( dbfTmpAgente )->cCodAge }
         :nWidth           := 60
      end with

      with object ( oBrwExt:AddCol() )
         :cHeader          := "Nombre"
         :bEditValue       := {|| RetNbrAge( ( dbfTmpAgente )->CCODAGE, dbfAgentes ) }
         :nWidth           := 180
      end with

      with object ( oBrwExt:AddCol() )
         :cHeader          := "% Comisión"
         :bEditValue       := {|| ( dbfTmpAgente )->nComAge }
         :cEditPicture     := "@E 999.99"
         :nWidth           := 60
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrwExt:AddCol() )
         :cHeader          := "% Promoción"
         :bEditValue       := {|| ( dbfTmpAgente )->nComPrm }
         :cEditPicture     := "@E 999.99"
         :nWidth           := 60
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      oBrwExt:bLDblClick      := {|| EdtDet2( oBrwExt, bEdit3, aTmp ) }
      oBrwExt:bRClicked       := {| nRow, nCol, nFlags | oBrwExt:RButtonDown( nRow, nCol, nFlags ) }

      oBrwExt:CreateFromResource( 210 )

      REDEFINE BUTTON;
			ID 		500 ;
         OF       oFld:aDialogs[2];
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( AppDet2( oBrwExt, bEdit3, aTmp) )

      REDEFINE BUTTON;
         ID       501 ;
         OF       oFld:aDialogs[2];
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( EdtDet2( oBrwExt, bEdit3, aTmp ) )

      REDEFINE BUTTON;
			ID 		502 ;
         OF       oFld:aDialogs[2];
         WHEN     ( nMode != ZOOM_MODE ) ;
			ACTION 	( DelDet2( oBrwExt ) )

      REDEFINE BUTTON;
         ID       IDOK ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( EndTr2( aTmp, aGet, nMode, oBrw, oBrwExt, oDlg ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      if nMode != ZOOM_MODE
         oFld:aDialogs[2]:AddFastKey( VK_F2, {|| AppDet2( oBrwExt, bEdit3, aTmp) } )
         oFld:aDialogs[2]:AddFastKey( VK_F3, {|| EdtDet2( oBrwExt, bEdit3, aTmp ) } )
         oFld:aDialogs[2]:AddFastKey( VK_F4, {|| DelDet2( oBrwExt ) } )

         oDlg:AddFastKey( VK_F5, {|| EndTr2( aTmp, aGet, nMode, oBrw, oBrwExt, oDlg ) } )
      end if

      oDlg:bStart := {|| oBrwExt:Load(), cValoresProp( aTmp, aGet, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2 )  }

   ACTIVATE DIALOG oDlg CENTER

   KillTr2( oBrwExt )

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Static Function cValoresProp( aTmp, aGet, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2 )

   if nMode == APPD_MODE

      oSayPr1:Hide()
      oSayPr2:Hide()
      oSayVp1:Hide()
      oSayVp2:Hide()

      aGet[ ( dbfTarPreL )->( FieldPos( "CVALPR1" ) ) ]:Hide()
      aGet[ ( dbfTarPreL )->( FieldPos( "CVALPR2" ) ) ]:Hide()

   else

      if Empty( aTmp[ ( dbfTarPreL )->( FieldPos( "CCODPR1" ) ) ] ) .or. aTmp[ ( dbfTarPreL )->( FieldPos( "NTIPTAR" ) ) ] == 2
         oSayPr1:Hide()
         oSayVp1:Hide()
         aGet[ ( dbfTarPreL )->( FieldPos( "CVALPR1" ) ) ]:Hide()
      end if

      if Empty( aTmp[ ( dbfTarPreL )->( FieldPos( "CCODPR2" ) ) ] ) .or. aTmp[ ( dbfTarPreL )->( FieldPos( "NTIPTAR" ) ) ] == 2
         oSayPr2:Hide()
         oSayVp2:Hide()
         aGet[ ( dbfTarPreL )->( FieldPos( "CVALPR2" ) ) ]:Hide()
      end if

   end if

   aGet[ ( dbfTarPreL )->( FieldPos( "DFINPRM" ) ) ]:lValid()

Return nil

//--------------------------------------------------------------------------//

STATIC FUNCTION SetNumDay( aTmp, oTxt )

   local dFecIni  := aTmp[ (dbfTarPreL)->( FieldPos( "DINIPRM" ) ) ]
   local dFecFin  := aTmp[ (dbfTarPreL)->( FieldPos( "DFINPRM" ) ) ]

	IF dFecFin >= dFecIni
      oTxt:SetText( Trans( dFecFin - dFecIni, "@E 999,999" ) + " días." )
		RETURN .T.
	END IF

	msgStop( "La fecha final debe ser mayor que la inicial." )

RETURN .F.

//--------------------------------------------------------------------------//

static function ChTipTar( aGet, aTmp, oSayPr1, oSayPr2, oSayVp1, oSayVp2 )

   aGet[ (dbfTarPreL)->( FieldPos( "CCODART"  ) ) ]:cText( "" )
   aGet[ (dbfTarPreL)->( FieldPos( "CCODFAM"  ) ) ]:cText( "" )
   aGet[ (dbfTarPreL)->( FieldPos( "CNOMART"  ) ) ]:cText( "" )
   aGet[ (dbfTarPreL)->( FieldPos( "CNOMFAM"  ) ) ]:cText( "" )
   aGet[ (dbfTarPreL)->( FieldPos( "NPRCTAR1" ) ) ]:cText( 0 )
   aGet[ (dbfTarPreL)->( FieldPos( "NPRCTAR2" ) ) ]:cText( 0 )
   aGet[ (dbfTarPreL)->( FieldPos( "NPRCTAR3" ) ) ]:cText( 0 )
   aGet[ (dbfTarPreL)->( FieldPos( "NPRCTAR4" ) ) ]:cText( 0 )
   aGet[ (dbfTarPreL)->( FieldPos( "NPRCTAR5" ) ) ]:cText( 0 )
   aGet[ (dbfTarPreL)->( FieldPos( "NPRCTAR6" ) ) ]:cText( 0 )

   if aTmp[ (dbfTarPreL)->( FieldPos( "NTIPTAR" ) ) ] == 2

      oSayPr1:Hide()
      oSayPr2:Hide()

      oSayVp1:SetText( "" )
      oSayVp2:SetText( "" )

      oSayVp1:Hide()
      oSayVp2:Hide()

      aGet[ (dbfTarPreL)->( FieldPos( "CVALPR1" ) ) ]:cText( "" )
      aGet[ (dbfTarPreL)->( FieldPos( "CVALPR2" ) ) ]:cText( "" )

      aGet[ (dbfTarPreL)->( FieldPos( "CVALPR1" ) ) ]:Hide()
      aGet[ (dbfTarPreL)->( FieldPos( "CVALPR2" ) ) ]:Hide()

   end if

return .t.

//--------------------------------------------------------------------------//

STATIC FUNCTION EndTr2( aTmp, aGet, nMode, oBrw, oBrwExt, oDlg )

   local nOrd
   local nRec
   local aTabla
   local oError
   local oBlock
   local lReturn     := .t.
   local nTipArt     := aTmp[ ( dbfTmpArticulo )->( FieldPos( "NTIPTAR" ) ) ]
   local cCodArt     := aTmp[ ( dbfTmpArticulo )->( FieldPos( "CCODART" ) ) ]
   local cCodFam     := aTmp[ ( dbfTmpArticulo )->( FieldPos( "CCODFAM" ) ) ]
   local cCodTar     := aTmp[ ( dbfTmpArticulo )->( FieldPos( "CCODTAR" ) ) ] + aTmp[ ( dbfTmpArticulo )->( FieldPos( "CCODART" ) ) ] + aTmp[ ( dbfTmpArticulo )->( FieldPos( "CCODFAM" ) ) ] + aTmp[ ( dbfTmpArticulo )->( FieldPos( "CCODPR1" ) ) ] + aTmp[ ( dbfTmpArticulo )->( FieldPos( "CCODPR2" ) ) ] + aTmp[ ( dbfTmpArticulo )->( FieldPos( "CVALPR1" ) ) ] + aTmp[ ( dbfTmpArticulo )->( FieldPos( "CVALPR2" ) ) ]

   if nTipArt == 1 .and. Empty( cCodArt )
      msgStop( "Código de artículo no puede estar vacio" )
      return .f.
   end if

   if nTipArt == 2 .and. Empty( cCodFam )
      msgStop( "Código de família no puede estar vacia" )
      return .f.
   end if

   if nTipArt == 1 .and. ( nMode == APPD_MODE .or. nMode == DUPL_MODE )

      nRec           := ( dbfTmpArticulo )->( Recno() )
      nOrd           := ( dbfTmpArticulo )->( OrdSetFocus( "cCodArt" ) )

      lReturn        := ( dbfTmpArticulo )->( dbSeek( cCodArt ) )
      if lReturn
         msgStop( "Código de artículo ya existe" )
      end if

      ( dbfTmpArticulo )->( dbGoTo( nRec ) )
      ( dbfTmpArticulo )->( OrdSetFocus( nOrd ) )

      if lReturn
         Return .f.
      end if

   end if

   if nTipArt == 2 .and. ( nMode == APPD_MODE .or. nMode == DUPL_MODE )

      nRec           := ( dbfTmpArticulo )->( Recno() )
      nOrd           := ( dbfTmpArticulo )->( OrdSetFocus( "cCodFam" ) )

      lReturn        := ( dbfTmpArticulo )->( dbSeek( cCodFam ) )
      if lReturn
         msgStop( "Código de família ya existe" )
      end if

      ( dbfTmpArticulo )->( dbGoTo( nRec ) )
      ( dbfTmpArticulo )->( OrdSetFocus( nOrd ) )

      if lReturn
         Return .f.
      end if

   end if

   CursorWait()

   /*
   Pasamos los temporales a los ficheros definitivos---------------------------
   */

   oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   BeginTransaction()

	/*
   Roll Back-------------------------------------------------------------------
	*/

   while ( dbfTarPreS )->( dbSeek( cCodTar ) )

      if ( dbfTarPreS )->( dbRLock() )
         ( dbfTarPreS )->( dbDelete() )
         ( dbfTarPreS )->( dbUnLock() )
      end if

   end while

	/*
   Ahora escribimos en el fichero definitivo-----------------------------------
	*/

   ( dbfTmpAgente )->( dbGoTop() )
   while !( dbfTmpAgente )->( Eof() )

      aTabla                                             := dbScatter( dbfTmpAgente )
      aTabla[ ( dbfTarPreS )->( FieldPos( "CCODTAR" ) )] := aTmp[ ( dbfTmpArticulo )->( FieldPos( "CCODTAR" ) ) ]
      aTabla[ ( dbfTarPreS )->( FieldPos( "CCODART" ) )] := aTmp[ ( dbfTmpArticulo )->( FieldPos( "CCODART" ) ) ]
      aTabla[ ( dbfTarPreS )->( FieldPos( "CCODFAM" ) )] := aTmp[ ( dbfTmpArticulo )->( FieldPos( "CCODFAM" ) ) ]
      aTabla[ ( dbfTarPreS )->( FieldPos( "CCODPR1" ) )] := aTmp[ ( dbfTmpArticulo )->( FieldPos( "CCODPR1" ) ) ]
      aTabla[ ( dbfTarPreS )->( FieldPos( "CCODPR2" ) )] := aTmp[ ( dbfTmpArticulo )->( FieldPos( "CCODPR2" ) ) ]
      aTabla[ ( dbfTarPreS )->( FieldPos( "CVALPR1" ) )] := aTmp[ ( dbfTmpArticulo )->( FieldPos( "CVALPR1" ) ) ]
      aTabla[ ( dbfTarPreS )->( FieldPos( "CVALPR2" ) )] := aTmp[ ( dbfTmpArticulo )->( FieldPos( "CVALPR2" ) ) ]

		( dbfTarPreS )->( dbAppend() )

      dbGather( aTabla, dbfTarPreS )

      ( dbfTmpAgente )->( dbSkip() )

   end while

	/*
	Borramos los ficheros
	*/

   WinGather( aTmp, aGet, dbfTmpArticulo, oBrw, nMode )

   CommitTransaction()

   RECOVER USING oError

      RollBackTransaction()
      msgStop( "Imposible actualizar bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE
   ErrorBlock( oBlock )

   oDlg:end()

   CursorWE()

RETURN .T.

//------------------------------------------------------------------------//

STATIC FUNCTION KillTr2( oBrwExt )

   if !Empty( dbfTmpAgente ) .and. ( dbfTmpAgente )->( Used() )
      ( dbfTmpAgente )->( dbCloseArea() )
   end if

   if oBrwExt != nil
      oBrwExt:CloseData()
   end if

   /*
	Borramos los ficheros
	*/

   dbfErase( cNewFil2 )

RETURN .T.

//------------------------------------------------------------------------//

STATIC FUNCTION AppDet2( oBrw, bEdit3, aTmp )

RETURN WinAppRec( oBrw, bEdit3, dbfTmpAgente, , , aTmp[(dbfTarPreL)->( FieldPos( "CCODTAR" ) )] + aTmp[(dbfTarPreL)->( FieldPos( "CCODART" ) )] + aTmp[(dbfTarPreL)->( FieldPos( "CCODFAM" ) )] )

//--------------------------------------------------------------------------//

/*
Funcion Auxiliar para la Edición de Lineas de Detalle en un pedido
*/

STATIC FUNCTION EdtDet2( oBrw, bEdit3 )

RETURN WinEdtRec( oBrw, bEdit3, dbfTmpAgente )

//--------------------------------------------------------------------------//

/*
Funcion Auxiliar para borrar las Lineas de Detalle en un pedido
*/

STATIC FUNCTION DelDet2( oBrw )

RETURN DBDelRec( oBrw, dbfTmpAgente )

//--------------------------------------------------------------------------//

STATIC FUNCTION EdtExtDet( aTmp, aGet, dbfTmpAgente, oBrw, bWhen, bValid, nMode, cCodAcc )

	local oDlg
	local oGet
	local oGetTxt
	local cGetTxt

   DEFINE DIALOG oDlg RESOURCE "LAGETAR" TITLE LblTitle( nMode ) + "agentes a tarifas"

      REDEFINE GET oGet VAR aTmp[ (dbfTarPreS)->( FieldPos( "CCODAGE" ) ) ];
			ID 		100 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			VALID 	( cAgentes( oGet,	dbfAgentes, oGetTxt ) ) ;
         ON HELP  ( BrwAgentes( oGet, oGetTxt ) ) ;
         BITMAP   "LUPA" ;
         COLOR    CLR_GET ;
			OF 		oDlg

		REDEFINE GET oGetTxt VAR cGetTxt;
			ID 		110 ;
			WHEN 		( .F. ) ;
			COLOR 	CLR_GET ;
			OF 		oDlg

      REDEFINE GET aTmp[ (dbfTarPreS)->( FieldPos( "NCOMAGE" ) ) ];
			ID 		120 ;
			SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999.99" ;
			COLOR 	CLR_GET ;
			OF 		oDlg

      REDEFINE GET aTmp[ (dbfTarPreS)->( FieldPos( "NCOMPRM" ) ) ];
         ID       130 ;
			SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999.99" ;
			COLOR 	CLR_GET ;
			OF 		oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( WinGather( aTmp, aGet, dbfTmpAgente, oBrw, nMode ), oDlg:end() )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| WinGather( aTmp, aGet, dbfTmpAgente, oBrw, nMode ), oDlg:end() } )
   end if

   ACTIVATE DIALOG oDlg ON PAINT ( oGet:lValid() ) CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

FUNCTION cTarifa( oGet, oGet2 )

	local nOrdAnt
	local lClose	:= .F.
	local lValid 	:= .F.
	local xValor 	:= oGet:varGet()

   if Empty( xValor )
      if oGet2    != NIL
			oGet2:cText( "" )
      end if
      return .t.
   end if

   if Empty( dbfTarPreT )
      if !OpenFiles()
         return nil
      end if
      lclose      := .t.
   end if

   nOrdAnt        := ( dbfTarPreT )->( OrdSetFocus( 1 ) )

   if Empty( xvalor )
      return .t.
   end if

	xValor	:= Rjust( xValor, "0" )

   if ( dbfTarPreT )->( dbSeek( xValor ) )

		oGet:cText( (dbfTarPreT)->CCODTAR )

		IF oGet2 != NIL
			oGet2:cText( (dbfTarPreT)->CNOMTAR )
		END IF

		lValid 	:= .T.

   else

		msgStop( "Tarifa no encontrada" )

   end if

   ( dbfTarPreT )->( OrdSetFocus( nOrdAnt ) )

   if lClose
		CloseFiles()
   end if

RETURN lValid

//---------------------------------------------------------------------------//

FUNCTION retTarifa( cCodFam, dbfTarPreT )

	local lClose 	:= .F.
	local cAreaAnt := Alias()
	local cTemp		:= Space( 30 )

	IF dbfTarPreT 	== NIL
      IF !OpenFiles()
         RETURN NIL
      END IF
		lClose		:= .T.
	END IF

	IF ( dbfTarPreT )->( DbSeek( cCodFam ) )
		cTemp := (dbfTarPreT)->CNOMTAR
	END IF

	IF lClose
		CloseFiles()
	END IF

	IF cAreaAnt != ""
		SELECT( cAreaAnt )
	END IF

RETURN cTemp

//---------------------------------------------------------------------------//

FUNCTION BrwTarifa( oGet, oGet2 )

	local oDlg
	local oBrw
	local oGet1
	local cGet1
   local nOrd        := GetBrwOpt( "BrwTarifa" )
	local oCbxOrd
   local lClose      := .f.
   local aCbxOrd     := { "Código", "Nombre" }
   local cCbxOrd
   local nLevelUsr   := Auth():Level( "01019" )

   nOrd              := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd           := aCbxOrd[ nOrd ]

   if Empty( dbfTarPreT )
      if !OpenFiles()
         return nil
      end if
      lClose         := .t.
   end if

   nOrd              := ( dbfTarPreT )->( OrdSetFocus( nOrd ) )

   ( dbfTarPreT )->( dbGoTop() )

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Tarifa de precios"

		REDEFINE GET oGet1 VAR cGet1;
			ID 		104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfTarPreT ) );
         VALID    ( OrdClearScope( oBrw, dbfTarPreT ) );
         BITMAP   "FIND" ;
         OF       oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    aCbxOrd ;
			ON CHANGE( ( dbfTarPreT )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:refresh(), oGet1:SetFocus() ) ;
			OF 		oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfTarPreT
      oBrw:nMarqueeStyle   := 5

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodTar"
         :bEditValue       := {|| ( dbfTarPreT )->cCodTar }
         :nWidth           := 60
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomTar"
         :bEditValue       := {|| ( dbfTarPreT )->cNomTar }
         :nWidth           := 200
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
         WHEN     ( nAnd( nLevelUsr, ACC_APPD ) != 0 ) ;
         ACTION   ( WinAppRec( oBrw, bEdit, dbfTarPreT ) )

		REDEFINE BUTTON ;
         ID       501 ;
         OF       oDlg ;
         WHEN     ( nAnd( nLevelUsr, ACC_EDIT ) != 0 ) ;
         ACTION   ( WinEdtRec( oBrw, bEdit, dbfTarPreT ) )

      oDlg:AddFastKey( VK_F2,       {|| if( nAnd( nLevelUsr, ACC_APPD ) != 0, WinAppRec( oBrw, bEdit, dbfTarPreT ), ) } )
      oDlg:AddFastKey( VK_F3,       {|| if( nAnd( nLevelUsr, ACC_EDIT ) != 0, WinEdtRec( oBrw, bEdit, dbfTarPreT ), ) } )
      oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )
      oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK

      oGet:cText( ( dbfTarPreT )->cCodTar )

      if oGet2 != nil
         oGet2:cText( ( dbfTarPreT )->cNomTar )
      end if

   end if

   DestroyFastFilter( dbfTarPreT )

   SetBrwOpt( "BrwTarifa", ( dbfTarPreT )->( OrdNumber() ) )

   if lClose
		CloseFiles()
   else
      ( dbfTarPreT )->( OrdSetFocus( nOrd ) )
   end if

	oGet:setFocus()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

/*
Determina si un codigo de un Articulo ya esta en una tarifa
*/

STATIC FUNCTION IsTarTmp( aGet, aTmp, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2 )

   local nRec
   local cOrd
   local lReturn  := .t.
   local cCodArt  := aTmp[ ( dbfTarPreL )->( FieldPos( "CCODART" ) ) ]

   nRec           := ( dbfArticulo )->( Recno() )
   cOrd           := ( dbfArticulo )->( OrdSetFocus( "Codigo" ) )

   if nMode == APPD_MODE

      if Empty( cCodArt )
         aGet[ ( dbfTarPreL )->( FieldPos( "CNOMART"  ) ) ]:cText( "" )
         return .t.
      end if

      if ( dbfArticulo )->( dbSeek( cCodArt ) )

         aGet[ ( dbfTarPreL )->( FieldPos( "CNOMART" ) ) ]:cText( ( dbfArticulo )->Nombre )

         if Empty( aTmp[ ( dbfTarPreL )->( FieldPos( "NPRCTAR1" ) ) ] )
            aGet[ ( dbfTarPreL )->( FieldPos( "NPRCTAR1" ) ) ]:cText( ( dbfArticulo )->pVenta1 )
         end if
         if Empty( aTmp[ (dbfTarPreL)->( FieldPos( "NPRCTAR2" ) ) ] )
            aGet[ (dbfTarPreL)->( FieldPos( "NPRCTAR2" ) ) ]:cText( ( dbfArticulo )->pVenta2 )
         end if
         if Empty( aTmp[ (dbfTarPreL)->( FieldPos( "NPRCTAR3" ) ) ] )
            aGet[ (dbfTarPreL)->( FieldPos( "NPRCTAR3" ) ) ]:cText( ( dbfArticulo )->pVenta3 )
         end if
         if Empty( aTmp[ (dbfTarPreL)->( FieldPos( "NPRCTAR4" ) ) ] )
            aGet[ (dbfTarPreL)->( FieldPos( "NPRCTAR4" ) ) ]:cText( ( dbfArticulo )->pVenta4 )
         end if
         if Empty( aTmp[ (dbfTarPreL)->( FieldPos( "NPRCTAR5" ) ) ] )
            aGet[ (dbfTarPreL)->( FieldPos( "NPRCTAR5" ) ) ]:cText( ( dbfArticulo )->pVenta5 )
         end if
         if Empty( aTmp[ (dbfTarPreL)->( FieldPos( "NPRCTAR6" ) ) ] )
            aGet[ (dbfTarPreL)->( FieldPos( "NPRCTAR6" ) ) ]:cText( ( dbfArticulo )->pVenta6 )
         end if

         //Buscamos la familia del artículo para anotar las propiedades--------

         aTmp[ (dbfTarPreL)->( FieldPos( "CCODPR1" ) ) ] := ( dbfArticulo )->cCodPrp1
         aTmp[ (dbfTarPreL)->( FieldPos( "CCODPR2" ) ) ] := ( dbfArticulo )->cCodPrp2

         if !empty( aTmp[ ( dbfTarPreL )->( FieldPos( "CCODPR1" ) ) ] )
            oSayPr1:SetText( retProp( ( dbfArticulo )->cCodPrp1, dbfPro ) )
            oSayPr1:show()
            aGet[ (dbfTarPreL)->( FieldPos( "CVALPR1" ) ) ]:show()
            oSayVp1:show()
         else
            oSayPr1:hide()
            aGet[ (dbfTarPreL)->( FieldPos( "CVALPR1" ) ) ]:hide()
            oSayVp1:hide()
         end if

         if !empty( aTmp[ ( dbfTarPreL )->( FieldPos( "CCODPR2" ) ) ] )
            oSayPr2:SetText( retProp( ( dbfArticulo )->cCodPrp2, dbfPro ) )
            oSayPr2:show()
            aGet[ (dbfTarPreL)->( FieldPos( "CVALPR2" ) ) ]:show()
            oSayVp2:show()
         else
            oSayPr2:hide()
            aGet[ (dbfTarPreL)->( FieldPos( "CVALPR2" ) ) ]:hide()
            oSayVp2:hide()
         end if

      else
         MsgStop( "Código de artículo no encontrado" )
         return .f.
      end if

   else

      if ( dbfArticulo )->( dbSeek( cCodArt ) )

         //Buscamos la familia del artículo para anotar las propiedades--------

         aTmp[ (dbfTarPreL)->( FieldPos( "CCODPR1" ) ) ] := ( dbfArticulo )->cCodPrp1
         aTmp[ (dbfTarPreL)->( FieldPos( "CCODPR2" ) ) ] := ( dbfArticulo )->cCodPrp2

         if !empty( aTmp[ (dbfTarPreL)->( FieldPos( "CCODPR1" ) ) ] )
            oSayPr1:SetText( retProp( ( dbfArticulo )->cCodPrp1, dbfPro ) )
            oSayPr1:show()
            aGet[ (dbfTarPreL)->( FieldPos( "CVALPR1" ) ) ]:show()
            oSayVp1:show()
         else
            oSayPr1:hide()
            aGet[ (dbfTarPreL)->( FieldPos( "CVALPR1" ) ) ]:hide()
            oSayVp1:hide()
         end if

         if !empty( aTmp[ (dbfTarPreL)->( FieldPos( "CCODPR2" ) ) ] )
            oSayPr2:SetText( retProp( ( dbfArticulo )->cCodPrp2, dbfPro ) )
            oSayPr2:show()
            aGet[ (dbfTarPreL)->( FieldPos( "CVALPR2" ) ) ]:show()
            oSayVp2:show()
         else
            oSayPr2:hide()
            aGet[ (dbfTarPreL)->( FieldPos( "CVALPR2" ) ) ]:hide()
            oSayVp2:hide()
         end if

      end if

   end if

   ( dbfArticulo )->( dbGoTo( nRec ) )
   ( dbfArticulo )->( OrdSetFocus( cOrd ) )

RETURN lReturn

//---------------------------------------------------------------------------//

FUNCTION IsFamTmp( aGet, aTmp, nMode )

   local nRecNo
   local lReturn  := .t.
   local cCodFam  := aTmp[ ( dbfTarPreL )->( FieldPos( "CCODFAM" ) ) ]

   if Empty( cCodFam )
      aGet[ ( dbfTarPreL )->( FieldPos( "CNOMFAM" ) ) ]:cText( "" )
      return .t.
   end if

   if ( dbfFamilia )->( dbSeek( cCodFam ) )
      aGet[ ( dbfTarPreL )->( FieldPos( "CNOMFAM" ) ) ]:cText( ( dbfFamilia )->cNomFam )
   else
      MsgStop( "Código de família no encontrada" )
      return .f.
   end if

   if nMode == APPD_MODE

      nRecNo      := ( dbfTmpArticulo )->( RecNo() )

      ( dbfTmpArticulo )->( dbGoTop() )
      while !( dbfTmpArticulo )->( Eof() )

         if ( dbfTmpArticulo )->cCodFam == cCodFam
            msgStop( "Código de família ya existe" )
            lReturn  := .f.
            exit
         end if

         ( dbfTmpArticulo )->( dbSkip() )

      end do

      ( dbfTmpArticulo )->( dbGoTo( nRecNo ) )

   end if

RETURN lReturn

//---------------------------------------------------------------------------//

FUNCTION AppTarPre( cTarPreT, cTarPreL, cTarPreS, cCodArt )

	local cTagPreT
	local cTagPreL
	local cTagPreS
	local oldTarPreT	:= dbfTarPreT
	local oldTarPreL	:= dbfTarPreL
	local oldTarPreS	:= dbfTarPreS

	dbfTarPreT			:= cTarPreT
	dbfTarPreL			:= cTarPreL
	dbfTarPreS			:= cTarPreS

	cTagPreT				:= (dbfTarPreT)->( OrdSetFocus( 1 ) )
	cTagPreL				:= (dbfTarPreL)->( OrdSetFocus( 1 ) )
	cTagPreS				:= (dbfTarPreS)->( OrdSetFocus( 1 ) )

	WinAppRec( Nil, bEdit2, dbfTarPreL, nil, nil, cCodArt )

	(dbfTarPreT)->( OrdSetFocus( cTagPreT ) )
	(dbfTarPreL)->( OrdSetFocus( cTagPreL ) )
	(dbfTarPreS)->( OrdSetFocus( cTagPreS ) )

	dbfTarPreT			:= oldTarPreT
	dbfTarPreL			:= oldTarPreL
	dbfTarPreS			:= oldTarPreS

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION BeginTr2( aTmp )

   local cDbf     := "TTarS"
   local cCodTar  := aTmp[ ( dbfTarPreL )->( FieldPos( "CCODTAR" ) ) ] + aTmp[ ( dbfTarPreL )->( FieldPos( "CCODART" ) ) ] + aTmp[ ( dbfTarPreL )->( FieldPos( "CCODFAM" ) ) ] + aTmp[ ( dbfTarPreL )->( FieldPos( "CCODPR1" ) ) ] + aTmp[ ( dbfTarPreL )->( FieldPos( "CCODPR2" ) ) ] + aTmp[ ( dbfTarPreL )->( FieldPos( "CVALPR1" ) ) ] + aTmp[ ( dbfTarPreL )->( FieldPos( "CVALPR2" ) ) ]

   cNewFil2       := cGetNewFileName( cPatTmp() + cDbf )

	/*
   Primero Crear la base de datos local----------------------------------------
	*/

   dbCreate( cNewFil2, aSqlStruct( aItmTarifaAgentes() ), cLocalDriver() )

   dbUseArea( .t., cLocalDriver(), cNewFil2, cCheckArea( cDbf, @dbfTmpAgente ), .f. )
   if !( dbfTmpAgente )->( neterr() )

      /*
      A¤adimos desde el fichero de lineas--------------------------------------
      */

      if ( dbfTarPreS )->( dbSeek( cCodTar ) )

         while ( ( dbfTarPreS )->CCODTAR + ( dbfTarPreS )->CCODART + ( dbfTarPreS )->CCODFAM + ( dbfTarPreS )->CCODPR1 + ( dbfTarPreS )->CCODPR2 + ( dbfTarPreS )->CVALPR1 + ( dbfTarPreS )->CVALPR2 == cCodTar .AND. !( dbfTarPreS )->( Eof() ) )

            dbPass( dbfTarPreS, dbfTmpAgente, .t. )

            ( dbfTarPreS )->( dbSkip() )

         end while

      end if

      ( dbfTmpAgente )->( dbGoTop() )

   end if

RETURN NIL

#endif

//---------------------------------------------------------------------------//
//Funciones comunes del programa y pda
//---------------------------------------------------------------------------//

/*
Devuelve el porcentaje de promoción del agente
*/

FUNCTION RetDtoAge( cCodArt, cCodFam, cCodTar, cCodPr1, cCodPr2, cValPr1, cValPr2, dFecDoc, cCodAge, dbfTarPreL, dbfTarPreS )

   local lFound      := .f.
   local nResult     := 0
   local cCodSek
   local nOrdAnt     := ( dbfTarPreL )->( OrdSetFocus( "CTARPRP" ) )
   local nOrdAge     := ( dbfTarPreS )->( OrdSetFocus( "CCODAGE" ) )

   DEFAULT cCodPr1:= Space( 20 )
   DEFAULT cCodPr2:= Space( 20 )
   DEFAULT cValPr1:= Space( 40 )
   DEFAULT cValPr2:= Space( 40 )

   cCodSek := cCodTar + cCodArt + cCodPr1 + cCodPr2 + cValPr1 + cValPr2

   if ( dbfTarPreL )->( dbSeek( cCodSek ) )
      if ( dbfTarPreS )->( dbSeek( cCodTar + cCodArt + Space( 8 ) + cCodPr1 + cCodPr2 + cValPr1 + cValPr2 + cCodAge ) )
         if ( dbfTarPreL )->dIniPrm <= dFecDoc .AND. dFecDoc <= ( dbfTarPreL )->dFinPrm
            nResult  := ( dbfTarPreS )->nComPrm
         end if
         lFound      := .t.
      end if
   end if

	(dbfTarPreL)->( OrdSetFocus( nOrdAnt ) )

   if !lFound

      cCodSek        := cCodTar + cCodFam
      nOrdAnt        := ( dbfTarPreL )->( OrdSetFocus( "CCODFAM" ) )

      if ( dbfTarPreL )->( dbSeek( cCodSek ) )
         if ( dbfTarPreS )->( dbSeek( cCodTar + Space( 18 ) + cCodFam + cCodAge ) )
            if ( dbfTarPreL )->dIniPrm <= dFecDoc .AND. dFecDoc <= ( dbfTarPreL )->dFinPrm
               nResult  := ( dbfTarPreS )->nComPrm
            end if
            lFound      := .t.
         end if
      end if

      ( dbfTarPreL )->( OrdSetFocus( nOrdAnt ) )

   end if

   ( dbfTarPreS )->( OrdSetFocus( nOrdAge ) )

RETURN nResult

//--------------------------------------------------------------------------//

/*
Devuelve el porcentaje de promoción
*/

FUNCTION RetDtoPrm( cCodArt, cCodFam, cCodTar, cCodPr1, cCodPr2, cValPr1, cValPr2, dFecDoc, dbfTarPreL )

   local lFound      := .f.
   local nResult     := 0
   local cCodSek
   local nOrdAnt     := ( dbfTarPreL )->( OrdSetFocus( "CTARPRP" ) )

   DEFAULT cCodPr1:= Space( 20 )
   DEFAULT cCodPr2:= Space( 20 )
   DEFAULT cValPr1:= Space( 40 )
   DEFAULT cValPr2:= Space( 40 )

   cCodSek := cCodTar + cCodArt + cCodPr1 + cCodPr2 + cValPr1 + cValPr2


   if ( dbfTarPreL )->( dbSeek( cCodSek ) )
      if ( dbfTarPreL )->dIniPrm <= dFecDoc .AND. dFecDoc <= ( dbfTarPreL )->dFinPrm
         nResult     := (dbfTarPreL)->nDtoPrm
         lFound      := .t.
      end if
   end if

	(dbfTarPreL)->( OrdSetFocus( nOrdAnt ) )

   if !lFound

      cCodSek        := cCodTar + cCodFam
      nOrdAnt        := (dbfTarPreL)->( OrdSetFocus( "CCODFAM" ) )

      if ( dbfTarPreL )->( dbSeek( cCodSek ) )
         if ( dbfTarPreL )->dIniPrm <= dFecDoc .AND. dFecDoc <= ( dbfTarPreL )->dFinPrm
            nResult  := (dbfTarPreL)->nDtoPrm
         end if
      end if

      ( dbfTarPreL )->( OrdSetFocus( nOrdAnt ) )

   end if

RETURN nResult

//--------------------------------------------------------------------------//

/*
Devuelve la comision de un agente en una taria
*/

FUNCTION RetComTar( cCodArt, cCodFam, cCodTar, cCodPr1, cCodPr2, cValPr1, cValPr2, cCodAge, dbfTarPreL, dbfTarPreS )

	local nResult	:= 0
   local cCodSek
   local nOrdAnt  := ( dbfTarPreS )->( OrdSetFocus( "CCODAGE" ) )
   local nOrdAntL := ( dbfTarPreL )->( OrdSetFocus( "CTARPRP" ) )

   DEFAULT cCodPr1:= Space( 20 )
   DEFAULT cCodPr2:= Space( 20 )
   DEFAULT cValPr1:= Space( 40 )
   DEFAULT cValPr2:= Space( 40 )

   if ( dbfTarPreL )->( dbSeek( cCodTar + cCodArt + cCodPr1 + cCodPr2 + cValPr1 + cValPr2 ) )
      cCodSek  := cCodTar + cCodArt + Space(16) + cCodPr1 + cCodPr2 + cValPr1 + cValPr2 + cCodAge
   else
      cCodSek  := cCodTar + Space(18) + cCodFam + Space(20) + Space(20) + Space(20) + Space(20) + cCodAge
   end if

   if ( dbfTarPreS )->( dbSeek( cCodSek ) )
      nResult     := ( dbfTarPreS )->NCOMAGE
   end if

   ( dbfTarPreS )->( OrdSetFocus( nOrdAnt ) )
   ( dbfTarPreL )->( OrdSetFocus( nOrdAntL ) )

RETURN nResult

//--------------------------------------------------------------------------//

FUNCTION RetLinTar( cCodArt, cCodFam, cCodTar, cCodPr1, cCodPr2, cValPr1, cValPr2, dbfTarPreL )

   local lFound   := .f.
	local nResult	:= 0
   local cCodSek
   local nOrdAnt  := ( dbfTarPreL )->( OrdSetFocus( "CTARPRP" ) )

   DEFAULT cCodPr1:= Space( 20 )
   DEFAULT cCodPr2:= Space( 20 )
   DEFAULT cValPr1:= Space( 40 )
   DEFAULT cValPr2:= Space( 40 )

   cCodSek := cCodTar + cCodArt + cCodPr1 + cCodPr2 + cValPr1 + cValPr2

   if ( dbfTarPreL )->( dbSeek( cCodSek ) )
      nResult     := ( dbfTarPreL )->nDtoDiv
      lFound      := .t.
   end if

   ( dbfTarPreL )->( OrdSetFocus( nOrdAnt ) )

   if !lFound

      cCodSek     := cCodTar + cCodFam
      nOrdAnt     := ( dbfTarPreL )->( OrdSetFocus( "CCODFAM" ) )

      if ( dbfTarPreL )->( dbSeek( cCodSek ) )
         nResult  := ( dbfTarPreL )->nDtoDiv
      end if

      ( dbfTarPreL )->( OrdSetFocus( nOrdAnt ) )

   end if

RETURN nResult

//--------------------------------------------------------------------------//

FUNCTION RetPctTar( cCodArt, cCodFam, cCodTar, cCodPr1, cCodPr2, cValPr1, cValPr2, dbfTarPreL )

   local lFound   := .f.
	local nResult	:= 0
   local cCodSek
   local nOrdAnt  := ( dbfTarPreL )->( OrdSetFocus( "CTARPRP" ) )

   DEFAULT cCodPr1:= Space( 20 )
   DEFAULT cCodPr2:= Space( 20 )
   DEFAULT cValPr1:= Space( 40 )
   DEFAULT cValPr2:= Space( 40 )

   cCodSek := cCodTar + cCodArt + cCodPr1 + cCodPr2 + cValPr1 + cValPr2

   if ( dbfTarPreL )->( dbSeek( cCodSek ) )
      nResult     := ( dbfTarPreL )->NDTOART
      lFound      := .t.
   end if

   ( dbfTarPreL )->( OrdSetFocus( nOrdAnt ) )

   if !lFound .and. !Empty( cCodFam )

      cCodSek     := cCodTar + cCodFam
      nOrdAnt     := ( dbfTarPreL )->( OrdSetFocus( "CCODFAM" ) )

      if ( dbfTarPreL )->( dbSeek( cCodSek ) )
         nResult  := ( dbfTarPreL )->NDTOART
      end if

      ( dbfTarPreL )->( OrdSetFocus( nOrdAnt ) )

   end if

RETURN nResult

//--------------------------------------------------------------------------//

/*
Devuelve el precio de un articulo en una tarifa
*/

FUNCTION RetPrcTar( cCodArt, cCodTar, cCodPr1, cCodPr2, cValPr1, cValPr2, dbfTarPreL, nTarPre )

	local nResult	:= 0
   local cCodSek
   local nOrdAnt  := ( dbfTarPreL )->( OrdSetFocus( "CTARPRP" ) )

   DEFAULT cCodPr1:= Space( 20 )
   DEFAULT cCodPr2:= Space( 20 )
   DEFAULT cValPr1:= Space( 40 )
   DEFAULT cValPr2:= Space( 40 )
   DEFAULT nTarPre:= 1

   cCodSek        := cCodTar + cCodArt + cCodPr1 + cCodPr2 + cValPr1 + cValPr2

   if ( dbfTarPreL )->( dbSeek( cCodSek ) )

      do case
         case nTarPre == 1
            nResult     := (dbfTarPreL)->nPrcTar1
         case nTarPre == 2
            nResult     := (dbfTarPreL)->nPrcTar2
         case nTarPre == 3
            nResult     := (dbfTarPreL)->nPrcTar3
         case nTarPre == 4
            nResult     := (dbfTarPreL)->nPrcTar4
         case nTarPre == 5
            nResult     := (dbfTarPreL)->nPrcTar5
         case nTarPre == 6
            nResult     := (dbfTarPreL)->nPrcTar6
      end case

   end if

   ( dbfTarPreL )->( OrdSetFocus( nOrdAnt ) )

RETURN nResult

//--------------------------------------------------------------------------//