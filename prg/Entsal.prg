#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "Report.ch"

#define ENTRADA						1
#define SALIDA 						2

#define _MENUITEM_               "01065"

#define _DFECENT                 1      //   D      8     0
#define _CTURENT                 2      //   C      6     0
#define _CSUFENT                 3      //   C      6     0
#define _CCODCAJ                 4      //   C      3     0
#define _NTIPENT                 5      //   N      1     0
#define _CDESENT                 6      //   C     50     0
#define _NIMPENT                 7      //   N      7     0
#define _LCLOENT                 8      //   L      1     0
#define _LSNDENT                 9      //   L      1     0
#define _CCODDIV                10      //   C      3     0
#define _NVDVDIV                11      //   N     10     4
#define _CHORA                  12      //   C      5     0
#define _CCODUSR                13      //   C      3     0
#define _CRUTDOC                14      //   C    250     0

static oWndBrw

static nView

static dbfEntT
static dbfDivisa

static cPorDiv
static oBandera
static dbfUser
static dbfCaj
static bBmp
static bBmpSnd
static bEdit      := { |aTmp, aGet, dbfEntT, oBrw, bWhen, bValid, nMode | EdtRec( aTmp, aGet, dbfEntT, oBrw, bWhen, bValid, nMode ) }
static bEditTct   := { |aTmp, aGet, dbfEntT, oBrw, bWhen, bValid, nMode | EdtRecTct( aTmp, aGet, dbfEntT, oBrw, bWhen, bValid, nMode ) }

//---------------------------------------------------------------------------//

function aItmEntSal()

   local aItmEntSal  := {}

   aAdd( aItmEntSal, { "DFECENT",   "D",  8,  0, "Fecha de la entrada/salida" ,           "",   "", "( cDbf )"} )
   aAdd( aItmEntSal, { "CTURENT",   "C",  6,  0, "Sesión de la entrada/salida" ,           "",   "", "( cDbf )"} )
   aAdd( aItmEntSal, { "CSUFENT",   "C",  2,  0, "Sufijo de la entrada/salida" ,          "",   "", "( cDbf )"} )
   aAdd( aItmEntSal, { "CCODCAJ",   "C",  3,  0, "Código de la caja" ,                    "",   "", "( cDbf )"} )
   aAdd( aItmEntSal, { "NTIPENT",   "N",  1,  0, "Tipo de entrada/salida(1-Ent 2-Sal)" ,  "",   "", "( cDbf )"} )
   aAdd( aItmEntSal, { "CDESENT",   "C", 50,  0, "Descripción" ,                          "",   "", "( cDbf )"} )
   aAdd( aItmEntSal, { "NIMPENT",   "N", 16,  6, "Importe de la entrada/salida" ,         "",   "", "( cDbf )"} )
   aAdd( aItmEntSal, { "LCLOENT",   "L",  1,  0, "Lógico de turno cerrado" ,              "",   "", "( cDbf )"} )
   aAdd( aItmEntSal, { "LSNDENT",   "L",  1,  0, "Lógico de envio" ,                      "",   "", "( cDbf )"} )
   aAdd( aItmEntSal, { "CCODDIV",   "C",  3,  0, "Código divisa" ,                        "",   "", "( cDbf )"} )
   aAdd( aItmEntSal, { "NVDVDIV",   "N", 10,  4, "Valor divisa" ,                         "",   "", "( cDbf )"} )
   aAdd( aItmEntSal, { "CHORA"  ,   "C",  5,  0, "Hora de creación de la entrada",        "",   "", "( cDbf )"} )
   aAdd( aItmEntSal, { "CCODUSR",   "C",  3,  0, "Código de usuario",                     "",   "", "( cDbf )"} )
   aAdd( aItmEntSal, { "CRUTDOC",   "C",250,  0, "Documento adjunto",                     "",   "", "( cDbf )"} )

return ( aItmEntSal )

//----------------------------------------------------------------------------//

FUNCTION EntSal( oMenuItem, oWnd )

   local lEuro          := .f.
   local nLevel
   local oSnd

   DEFAULT  oMenuItem   := _MENUITEM_
   DEFAULT  oWnd        := oWnd()

   if oWndBrw == nil

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

      if !OpenFiles()
         return nil
      end if

      /*
      Anotamos el movimiento para el navegador
      */

      AddMnuNext( "Entradas y salidas de caja", ProcName() )

      DEFINE SHELL oWndBrw FROM 2, 10 TO 18, 70;
      XBROWSE ;
      TITLE    "Entradas y salidas de caja" ;
      PROMPT   "Fecha";
      MRU      "Cashier_replace_16" ;
      BITMAP   clrTopArchivos ;
      ALIAS    ( dbfEntT ) ;
		APPEND	( WinAppRec( oWndBrw:oBrw, bEdit, dbfEntT ) );
		DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdit, dbfEntT ) );
		EDIT 		( WinEdtRec( oWndBrw:oBrw, bEdit, dbfEntT ) ) ;
      DELETE   ( WinDelRec(  oWndBrw:oBrw, dbfEntT ) ) ;
      OF       oWnd

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Cerrado"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfEntT )->lCloEnt }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "Zoom16" )

      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Envio"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfEntT )->lSndEnt }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "Lbl16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Tipo"
         :bEditValue       := {|| if( ( dbfEntT )->nTipEnt == 1, "Entrada", "Salida" ) }
         :bBmpData         := {|| if( ( dbfEntT )->nTipEnt <= 1, 1, 2 ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :AddResource( "Sel16" )
         :AddResource( "Cnt16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Fecha"
         :cSortOrder       := "dFecEnt"
         :bEditValue       := {|| Dtoc( ( dbfEntT )->dFecEnt ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Sesión"
         :bEditValue       := {|| ( dbfEntT )->cTurEnt }
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Delegación"
         :bEditValue       := {|| ( dbfEntT )->cSufEnt }
         :nWidth           := 40
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Caja"
         :bEditValue       := {|| ( dbfEntT )->cCodCaj }
         :nWidth           := 80
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Descripción"
         :bEditValue       := {|| ( dbfEntT )->cDesEnt }
         :nWidth           := 200
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Importe"
         :bEditValue       := {|| nTotES( nil, dbfEntT, dbfDivisa, if( lEuro, cDivChg(), cDivEmp() ), .t. ) }
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Div."
         :bEditValue       := {|| cSimDiv( if( lEuro, cDivChg(), ( dbfEntT )->cCodDiv ), dbfDivisa ) }
         :nWidth           := 30
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      oWndBrw:cHtmlHelp    := "Entradas y salidas"

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
         HOTKEY   "D";
         LEVEL    ACC_APPD

		DEFINE BTNSHELL RESOURCE "EDIT" OF oWndBrw ;
			NOBORDER ;
			ACTION  	( oWndBrw:RecEdit() );
         TOOLTIP  "(M)odificar";
         HOTKEY   "M";
         LEVEL    ACC_EDIT

		DEFINE BTNSHELL RESOURCE "ZOOM" OF oWndBrw ;
			NOBORDER ;
			ACTION  	( WinZooRec( oWndBrw:oBrw, bEdit, dbfEntT ) );
			TOOLTIP 	"(Z)oom";
         HOTKEY   "Z";
         LEVEL    ACC_ZOOM

		DEFINE BTNSHELL RESOURCE "DEL" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( oWndBrw:RecDel() );
			TOOLTIP 	"(E)liminar";
         HOTKEY   "E";
         LEVEL    ACC_DELE

      DEFINE BTNSHELL oSnd RESOURCE "LBL" OF oWndBrw ;
         NOBORDER ;
         MENU     This:Toggle() ;
         ACTION   lSndEnt( oWndBrw, dbfEntT ) ;
         TOOLTIP  "En(v)iar" ;
         HOTKEY   "V";
         LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "LBL" OF oWndBrw ;
            NOBORDER ;
            ACTION   ( lSelectAll( oWndBrw, dbfEntT, "lSndEnt", .t., .t., .t. ) );
            TOOLTIP  "Todos" ;
            FROM     oSnd ;
            CLOSED ;
            LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "LBL" OF oWndBrw ;
            NOBORDER ;
            ACTION   ( lSelectAll( oWndBrw, dbfEntT, "lSndEnt", .f., .t., .t. ) );
            TOOLTIP  "Ninguno" ;
            FROM     oSnd ;
            CLOSED ;
            LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "LBL" OF oWndBrw ;
            NOBORDER ;
            ACTION   ( lSelectAll( oWndBrw, dbfEntT, "lSndEnt", .t., .f., .t. ) );
            TOOLTIP  "Abajo" ;
            FROM     oSnd ;
            CLOSED ;
            LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "BAL_EURO" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( lEuro := !lEuro, oWndBrw:Refresh() ) ;
         TOOLTIP  "E(u)ros";
         HOTKEY   "U";
         LEVEL    ACC_ZOOM

#ifndef __TACTIL__

      DEFINE BTNSHELL RESOURCE "IMP" OF oWndBrw ;
			NOBORDER ;
         ACTION ( IEntSal():New( "Listado de entradas y salidas de caja" ):Play() ) ;
			TOOLTIP "(L)istado" ;
         HOTKEY   "L";
         LEVEL    ACC_ZOOM

#endif


      DEFINE BTNSHELL RESOURCE "END" GROUP OF oWndBrw ;
			NOBORDER ;
			ACTION ( oWndBrw:End() ) ;
			TOOLTIP "(S)alir" ;
			HOTKEY 	"S"

      oWndBrw:oActiveFilter:SetFields(  aItmEntSal() )
      oWndBrw:oActiveFilter:SetFilterType( ENT_SAL )

		ACTIVATE WINDOW oWndBrw VALID ( CloseFiles() )

	ELSE

		oWndBrw:SetFocus()

   END IF

RETURN nil

//----------------------------------------------------------------------------//

STATIC FUNCTION OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   IF !lExistTable( cPatEmp() + "ENTSAL.DBF" )
		mkEntSal()
	END IF

   nView          := TDataCenter():CreateView()

   TDataCenter():Get( "LogPorta", nView )

   USE ( cPatEmp() + "ENTSAL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ENTSAL", @dbfEntT ) )
   SET ADSINDEX TO ( cPatEmp() + "ENTSAL.CDX" ) ADDITIVE

   USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDivisa ) )
   SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

   USE ( cPatDat() + "USERS.DBF" ) NEW SHARED VIA ( cDriver() ) ALIAS ( cCheckArea( "USERS", @dbfUser ) )
   SET ADSINDEX TO ( cPatDat() + "USERS.CDX" ) ADDITIVE

   USE ( cPatDat() + "CAJAS.DBF" ) NEW SHARED VIA ( cDriver() ) ALIAS ( cCheckArea( "CAJAS", @dbfCaj ) )
   SET ADSINDEX TO ( cPatDat() + "CAJAS.CDX" ) ADDITIVE

   cPorDiv  := cPorDiv( cDivEmp(), dbfDivisa ) // Picture de la divisa redondeada

   oBandera := TBandera():New

   bBmp     := LoadBitmap( GetResources(), "BmpLock" )
   bBmpSnd  := LoadBitmap( GetResources(), "Send16" )

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles()

   CLOSE ( dbfEntT   )
   CLOSE ( dbfDivisa )
   CLOSE ( dbfUser   )
   CLOSE ( dbfCaj    )

   TDataCenter():DeleteView( nView )

   dbfEntT     := nil
   dbfDivisa   := nil
   dbfUser     := nil
   dbfCaj      := nil

   oWndBrw     := nil

RETURN .T.

//----------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aTmp, aGet, dbfEntT, oBrw, bWhen, bValid, nMode )

	local oDlg
   local oSay
   local cSay
   local oBmpDiv
   local cPicImp
   local oSayUsr
   local cSayUsr
   local oBmpGeneral

   do case
   case nMode == APPD_MODE

      if !lCajaOpen( oUser():cCaja() ) .and. !oUser():lAdministrador()
         msgStop( "Esta caja " + oUser():cCaja() + " esta cerrada." )
         Return .f.
      end if

      aTmp[ _CTURENT ]  := cCurSesion()
      aTmp[ _CCODCAJ ]  := oUser():cCaja()
      aTmp[ _CSUFENT ]  := RetSufEmp()
      aTmp[ _CCODDIV ]  := cDivEmp()
      aTmp[ _NVDVDIV ]  := 1
      aTmp[ _CHORA   ]  := SubStr( Time(), 1, 5 )
      aTmp[ _CCODUSR ]  := cCurUsr()

   case nMode == DUPL_MODE

      if !lCajaOpen( oUser():cCaja() ) .and. !oUser():lAdministrador()
         msgStop( "Esta caja " + oUser():cCaja() + " esta cerrada." )
         Return .f.
      end if

      aTmp[ _CTURENT ]  := cCurSesion()
      aTmp[ _CCODCAJ ]  := oUser():cCaja()
      aTmp[ _CSUFENT ]  := RetSufEmp()

   case nMode == EDIT_MODE

      if aTmp[ _LCLOENT ] .AND. !oUser():lAdministrador()
         msgStop( "Solo puede modificar las entradas cerradas los administradores." )
         return .f.
      end if

   end case

   if Empty( aTmp[ _CCODUSR ] )
      aTmp[ _CCODUSR ]  := cCurUsr()
   end if

   if Empty( aTmp[ _CCODCAJ ] )
      aTmp[ _CCODCAJ ]  := oUser():cCaja()
   end if

   if Empty( aTmp[ _CCODDIV ] )
      aTmp[ _CCODDIV ]  := cDivEmp()
   end if

   if Empty( aTmp[ _NVDVDIV ] )
      aTmp[ _NVDVDIV ]  := 1
   end if

   cPicImp              := cPorDiv( aTmp[ _CCODDIV ], dbfDivisa )

   DEFINE DIALOG oDlg RESOURCE "EntSal" TITLE LblTitle( nMode ) + "movimientos de entradas y salidas"

      REDEFINE BITMAP oBmpGeneral ;
         ID       500 ;
         RESOURCE "Money_Alpha_48" ;
         TRANSPARENT ;
         OF       oDlg

      REDEFINE RADIO aGet[ _NTIPENT ] VAR aTmp[ _NTIPENT ] ;
			ID 		90, 91 ;
			WHEN  	( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET aGet[ _DFECENT ] VAR aTmp[ _DFECENT ];
			ID 		100 ;
			WHEN  	( nMode != ZOOM_MODE ) ;
			SPINNER ;
			COLOR 	CLR_GET ;
			OF 		oDlg

      /*
      REDEFINE GET aGet[ _CHORA ] VAR aTmp[ _CHORA ];
         ID       170 ;
         WHEN     ( .f. ) ;
			COLOR 	CLR_GET ;
         OF       oDlg
      */

      /*
      Usuarios_________________________________________________________________

      REDEFINE GET aGet[ _CCODUSR ] VAR aTmp[ _CCODUSR ];
         WHEN     ( lUsrMaster() .and. nMode != ZOOM_MODE ) ;
         VALID    ( cUser( aGet[ _CCODUSR ], dbfUser, oSayUsr ) ) ;
         ID       160 ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwUser( aGet[ _CCODUSR ], dbfUser, oSayUsr ) ) ;
         OF       oDlg

      REDEFINE GET oSayUsr VAR cSayUsr ;
         ID       161 ;
         WHEN     .f. ;
         OF       oDlg
      */

      /*
		Cajas____________________________________________________________________
		*/

      REDEFINE GET aGet[ _CCODCAJ ] VAR aTmp[ _CCODCAJ ];
         WHEN     ( lUsrMaster() .and. nMode != ZOOM_MODE ) ;
         VALID    cCajas( aGet[ _CCODCAJ ], dbfCaj, oSay ) ;
         ID       150 ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwCajas( aGet[ _CCODCAJ ], oSay ) ) ;
         OF       oDlg

      REDEFINE GET oSay VAR cSay ;
         ID       151 ;
         WHEN     .f. ;
         OF       oDlg

      REDEFINE GET aTmp[ _CDESENT ];
			ID 		110 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			PICTURE 	"@!" ;
			OF 		oDlg

      REDEFINE GET aGet[ _CCODDIV ] VAR aTmp[ _CCODDIV ];
         WHEN     ( nMode == APPD_MODE ) ;
         VALID    ( cDivOut( aGet[ _CCODDIV ], oBmpDiv, aTmp[ _NVDVDIV ], , , @cPicImp, , , , nil, dbfDivisa, oBandera ) );
         PICTURE  "@!";
         ID       120 ;
         BITMAP   "LUPA" ;
         ON HELP  BrwDiv( aGet[ _CCODDIV ], oBmpDiv, aTmp[ _NVDVDIV ], dbfDivisa, oBandera ) ;
         OF       oDlg

      REDEFINE BITMAP oBmpDiv ;
         RESOURCE "BAN_EURO" ;
         ID       121;
         OF       oDlg

      REDEFINE GET aGet[ _NIMPENT ] VAR aTmp[ _NIMPENT ];
         ID       140 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  ( cPicImp ) ;
         OF       oDlg

      REDEFINE GET aGet[ _CRUTDOC ] VAR aTmp[ _CRUTDOC ] ;
         ID       160 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "FOLDER" ;
         ON HELP  ( aGet[ _CRUTDOC ]:cText( cGetFile( 'Doc ( *.* ) | ' + '*.*', 'Seleccione el nombre del fichero' ) ) ) ;
         OF       oDlg

      TBtnBmp():ReDefine( 161, "gear_run_16",,,,,{|| ShellExecute( oDlg:hWnd, "open", Rtrim( aTmp[ _CRUTDOC ] ) ) }, oDlg, .f., , .f., )

      REDEFINE GET aGet[ _CTURENT ] VAR aTmp[ _CTURENT ];
         ID       170 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE .and. lUsrMaster() ) ;
			OF 		oDlg

		REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( SaveRec( aTmp, aGet, dbfEntT, oBrw, oDlg, nMode ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

      if nMode != ZOOM_MODE
         oDlg:AddFastKey( VK_F5, {|| SaveRec( aTmp, aGet, dbfEntT, oBrw, oDlg, nMode ) } )
      end if

      oDlg:bStart := {|| aGet[ _CCODDIV ]:lValid(), aGet[ _CCODCAJ ]:lValid(), aGet[ _NIMPENT ]:SetFocus() }

   ACTIVATE DIALOG oDlg CENTER

   oBmpDiv:End()

   if !Empty( oBmpGeneral )
      oBmpGeneral:End()
   end if

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

STATIC FUNCTION EdtRecTct( aTmp, aGet, dbfEntT, oBrw, bWhen, bValid, nMode )

	local oDlg
   local oSay
   local cSay
   local cPicImp
   local oSayCaj
   local cSayCaj
   local oSayUsr
   local cSayUsr
   local oBtnUser
   local oBtnCaj
   local oBtnEnt
   local oBtnSal
   local nOpcion

   do case
   case nMode == APPD_MODE

      if !lCajaOpen( oUser():cCaja() ) .and. !oUser():lAdministrador()
         msgStop( "Esta caja " + oUser():cCaja() + " esta cerrada." )
         Return .f.
      end if

      aTmp[ _CTURENT ]  := cCurSesion()
      aTmp[ _CCODCAJ ]  := oUser():cCaja()
      aTmp[ _CSUFENT ]  := RetSufEmp()
      aTmp[ _CCODDIV ]  := cDivEmp()
      aTmp[ _NVDVDIV ]  := 1
      aTmp[ _NTIPENT ]  := 1
      aTmp[ _CHORA   ]  := SubStr( Time(), 1, 5 )
      aTmp[ _CCODUSR ]  := cCurUsr()

   case nMode == DUPL_MODE

      if !lCajaOpen( oUser():cCaja() ) .and. !oUser():lAdministrador()
         msgStop( "Esta caja " + oUser():cCaja() + " esta cerrada." )
         Return .f.
      end if

      aTmp[ _CTURENT ]  := cCurSesion()
      aTmp[ _CCODCAJ ]  := oUser():cCaja()
      aTmp[ _CSUFENT ]  := RetSufEmp()

   case nMode == EDIT_MODE

      if aTmp[ _LCLOENT ] .AND. !oUser():lAdministrador()
         msgStop( "Solo puede modificar las entradas cerradas los administradores." )
         return .f.
      end if

   end case

   if Empty( aTmp[ _CCODUSR ] )
      aTmp[ _CCODUSR ]  := cCurUsr()
   end if

   if Empty( aTmp[ _CCODCAJ ] )
      aTmp[ _CCODCAJ ]  := oUser():cCaja()
   end if

   if Empty( aTmp[ _CCODDIV ] )
      aTmp[ _CCODDIV ]  := cDivEmp()
   end if

   if Empty( aTmp[ _NVDVDIV ] )
      aTmp[ _NVDVDIV ]  := 1
   end if

   cPicImp              := cPorDiv( aTmp[ _CCODDIV ], dbfDivisa )

   DEFINE DIALOG oDlg RESOURCE "ENTSAL_TCT" TITLE LblTitle( nMode ) + "movimientos de entradas y salidas"

      REDEFINE GET aGet[ _DFECENT ] VAR aTmp[ _DFECENT ];
         ID       110 ;
         WHEN     ( .f. ) ;
			OF 		oDlg

      REDEFINE GET aGet[ _CHORA ] VAR aTmp[ _CHORA ];
         ID       120 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE RADIO aGet[ _NTIPENT ] VAR aTmp[ _NTIPENT ] ;
			ID 		90, 91 ;
			WHEN  	( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE BUTTONBMP oBtnCaj ;
         ID       151 ;
         OF       oDlg ;
         BITMAP   "Cashier_32" ;
         ACTION   ( SelCajTactil(), SetBigCaj( oSayCaj ) )

      REDEFINE GET oSayCaj VAR cSayCaj ;
         ID       150 ;
         OF       oDlg

      REDEFINE BUTTONBMP oBtnUser ;
         ID       161 ;
         OF       oDlg ;
         ACTION   ( BrwUserEnt( aTmp, dbfUser ), SetBigUsr( aTmp, oBtnUser, oSayUsr, dbfUser ) )

      REDEFINE GET oSayUsr VAR cSayUsr ;
         ID       160 ;
         OF       oDlg

      REDEFINE BUTTONBMP ;
         ID       171 ;
         OF       oDlg ;
         BITMAP   "Calculator_32" ;
         ACTION   ( Calculadora( 0, aGet[ _NIMPENT ] ) )

      REDEFINE GET aGet[ _NIMPENT ] VAR aTmp[ _NIMPENT ];
         ID       170 ;
         PICTURE  ( cPicImp ) ;
         OF       oDlg

      REDEFINE BUTTONBMP ;
         ID       181 ;
         OF       oDlg ;
         BITMAP   "Keyboard2_32" ;
         ACTION   ( aGet[ _CDESENT ]:cText( VirtualKey( .f. ) ) )

      REDEFINE GET aGet[ _CDESENT ] VAR aTmp[ _CDESENT ] ;
         ID       180 ;
			PICTURE 	"@!" ;
         OF       oDlg

      REDEFINE BUTTONBMP ;
         BITMAP   "Check_32" ;
         ID       500 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( SaveRec( aTmp, aGet, dbfEntT, oBrw, oDlg, nMode ) )

      REDEFINE BUTTONBMP ;
         BITMAP   "Delete_32" ;
         ID       550 ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

      if nMode != ZOOM_MODE
         oDlg:AddFastKey( VK_F5, {|| SaveRec( aTmp, aGet, dbfEntT, oBrw, oDlg, nMode ) } )
      end if

      oDlg:bStart := {|| SetBigUsr( aTmp, oBtnUser, oSayUsr, dbfUser ), SetBigCaj( oSayCaj ) }

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Static Function BrwUserEnt( aTmp, dbfUsr )

   local oBlock
   local oError
   local oDlg
   local aSta
   local lClose         := .f.
   local oImgUsr
   local oLstUsr

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if Empty( dbfUsr )
      USE ( cPatDat() + "USERS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "USERS", @dbfUsr ) )
      SET ADSINDEX TO ( cPatDat() + "USERS.CDX" ) ADDITIVE
   end if

   aSta                 := aGetStatus( dbfUsr )

   DEFINE DIALOG oDlg RESOURCE "SelUsuarios"

      oImgUsr           := TImageList():New( 50, 50 )

      oLstUsr           := TListView():Redefine( 100, oDlg )
      oLstUsr:nOption   := 0
      oLstUsr:bAction   := {| nOpt | SelBrwUserEnt( nOpt, oDlg, dbfUsr, aTmp ) }

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         ACTION   ( oDlg:end() )

   ACTIVATE DIALOG oDlg ;
      ON INIT     ( InitBrwBigUser( oDlg, oImgUsr, oLstUsr, dbfUsr ) ) ;
      CENTER

   SetStatus( dbfUsr, aSta )

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if lClose
      Close( dbfUsr )
   end if

Return ( oDlg:nResult == IDOK  )

//--------------------------------------------------------------------------//

Static Function SelBrwUserEnt( nOpt, oDlg, dbfUsr, aTmp )

   if nOpt == 0
      MsgStop( "Seleccione usuario" )
      Return nil
   end if

   if ( dbfUsr )->( OrdKeyGoTo( nOpt ) )

      if lGetPsw( dbfUsr, .t. )

         aTmp[ _CCODUSR ] := ( dbfUsr )->cCodUse

         oDlg:end( IDOK )

      end if

   else

      MsgStop( "El usuario no existe" )

   end if

Return ( nil )

//--------------------------------------------------------------------------//

Static function InitBrwUserEnt( oDlg, oImgUsr, oLstUsr, dbfUsr )

   local nUser := 0

   if !Empty( oImgUsr ) .and. !Empty( oLstUsr )

   ( dbfUsr )->( dbSetFilter( {|| !Field->lGrupo }, "!lGrupo" ) )

   ( dbfUsr )->( dbGoTop() )
   while !( dbfUsr )->( eof() )

      if !Empty( ( dbfUsr )->cImagen ) .and. File( Rtrim( ( dbfUsr )->cImagen ) )
         oImgUsr:Add( TBitmap():Define( , Rtrim( ( dbfUsr )->cImagen ), oDlg ) )
      else
         if ( dbfUsr )->nGrpUse <= 1
            oImgUsr:AddMasked( TBitmap():Define( "BIG_ADMIN" ), Rgb( 255, 0, 255 ) )
         else
            oImgUsr:AddMasked( TBitmap():Define( "BIG_USER" ), Rgb( 255, 0, 255 ) )
         end if
      end if

      oLstUsr:InsertItem( nUser, Capitalize( ( dbfUsr )->cNbrUse ) )

      ( dbfUsr )->( dbSkip() )

      nUser++

   end while

   ( dbfUsr )->( dbClearFilter() )

   oLstUsr:SetImageList( oImgUsr )

   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

static function SetBigUsr( aTmp, oBtnUser, oSayUsr, dbfUser )

      if ( dbfUser )->( dbSeek( aTmp[ _CCODUSR ] ) )

         if !Empty( ( dbfUser )->cImagen )
            oBtnUser:lTransparent := .f.
            oBtnUser:LoadBitmap( cFileBmpName( ( dbfUser )->cImagen ) )
         else
            oBtnUser:lTransparent := .t.
            oBtnUser:LoadBitmap( if( ( dbfUser )->nGrpUse == 1, "Big_Admin", "Big_User" ) )
         end if

         oBtnUser:Refresh()

         oSayUsr:cText( ( dbfUser )->cNbrUse )

      end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

static function SetBigCaj( oSayUsr )

   oSayUsr:cText( RetFld( oUser():cCaja(), dbfCaj, "cNomCaj" ) )

RETURN ( .t. )

//---------------------------------------------------------------------------//

Static Function SaveRec( aTmp, aGet, dbfEntT, oBrw, oDlg, nMode )

   if Empty( aTmp[ _CCODDIV ] )
      MsgStop( "Código de la divisa no puede estar vacio" )
      Return .f.
   end if

   if Empty( aTmp[ _CCODCAJ ] )
      MsgStop( "Código de caja no puede estar vacio" )
      Return .f.
   end if

   if aTmp[ _NIMPENT ] <= 0
      MsgStop( "Importe de entrada/salida no válido" )
      aGet[ _NIMPENT ]:SetFocus()
      Return .f.
   end if

   WinGather( aTmp, aGet, dbfEntT, oBrw, nMode )

   oUser():OpenCajon( nView ) //OpnCaj()

RETURN ( oDlg:end( IDOK ) )

//--------------------------------------------------------------------------//

FUNCTION mkEntSal( cPath, oMeter )

   DEFAULT cPath     := cPatEmp()

   if oMeter != nil
		oMeter:cText	:= "Generando Bases"
		sysrefresh()
   end if

   if !lExistTable( cPath + "ENTSAL.DBF" )
      dbCreate( cPath + "ENTSAL.DBF", aSqlStruct( aItmEntSal() ), cDriver() )
   end if

	rxEntSal( cPath, oMeter )

RETURN nil

//--------------------------------------------------------------------------//

FUNCTION rxEntSal( cPath, oMeter )

	local dbfEntT

   DEFAULT cPath  := cPatEmp()

   if !lExistTable( cPath + "ENTSAL.DBF" )
      dbCreate( cPath + "ENTSAL.DBF", aSqlStruct( aItmEntSal() ), cDriver() )
	end if

   fEraseIndex( cPath + "ENTSAL.CDX" )

   dbUseArea( .t., cDriver(), cPath + "ENTSAL.DBF", cCheckArea( "ENTSAL", @dbfEntT ), .f. )

   if !( dbfEntT )->( neterr() )
      ( dbfEntT )->( __dbPack() )

      ( dbfEntT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfEntT )->( ordCreate( cPath + "ENTSAL.CDX", "DFECENT", "Field->dFecEnt", {|| Field->dFecEnt } ) )

      ( dbfEntT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfEntT )->( ordCreate( cPath + "ENTSAL.CDX", "CTURENT", "Field->cTurEnt + Field->cSufEnt + Field->cCodCaj", {|| Field->cTurEnt + Field->cSufEnt + Field->cCodCaj } ) )

      ( dbfEntT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de entradas y salidas de cajas" )
   end if

RETURN nil

//--------------------------------------------------------------------------//

function nTotES( aTmp, dbfEntT, dbfDivisa, cDivRet, lPic )

   local nImp
   local nTot
   local nVdvRet

   DEFAULT lPic      := .t.

   if aTmp == nil
      nImp           := ( dbfEntT )->nVdvDiv
      nTot           := ( dbfEntT )->nImpEnt
   else
      nImp           := aTmp[ _NVDVDIV ]
      nTot           := aTmp[ _NIMPENT ]
   end if

   nTot              := nTot * nImp

   nVdvRet           := nDiv2Div( cDivEmp(), cDivRet, dbfDivisa )
   nTot              := nCnv( nTot, nVdvRet )

return ( if( lPic, Trans( nTot, cPorDiv( cDivRet, dbfDivisa ) ), nTot ) )

//---------------------------------------------------------------------------//

Static Function lSndEnt( oBrw, dbf )

   if dbDialogLock( dbf )
      ( dbf )->lSndEnt := !( dbf )->lSndEnt
      ( dbf )->( dbUnlock() )
      oBrw:Refresh()
      oBrw:SetFocus()
   end if

RETURN nil

//---------------------------------------------------------------------------//

Function IsEntSal( cPatEmp )

   DEFAULT cPatEmp   := cPatEmp()

   if !lExistTable( cPatEmp + "EntSal.Dbf" )
      mkEntSal( cPatEmp )
   end if

   if !lExistIndex( cPatEmp + "EntSal.Cdx" )
      rxEntSal( cPatEmp )
   end if

Return ( .t. )

//---------------------------------------------------------------------------//

Function AppEntSal( oMenuItem )

   local nLevel

   DEFAULT  oMenuItem   := _MENUITEM_

   nLevel               := nLevelUsr( oMenuItem )

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_APPD ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if OpenFiles( nil, .t. )
      WinAppRec( nil, bEditTct, dbfEntT )
      CloseFiles()
   end if

RETURN .t.

//----------------------------------------------------------------------------//

Function EdtEntSal( nRecEntradaSalida )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_EDIT ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if OpenFiles( nil, .t. )

      ( dbfEntT )->( dbGoTo( nRecEntradaSalida ) )
      if ( dbfEntT )->( Recno() ) == nRecEntradaSalida
         WinEdtRec( nil, bEdit, dbfEntT )
      end if

      CloseFiles()

   end if

Return .t.

//----------------------------------------------------------------------------//