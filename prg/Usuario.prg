#ifndef __PDA__
#include "FiveWin.Ch"
#include "Font.ch"
#include "Report.ch"
#else
#include "FWCE.ch"
REQUEST DBFCDX
#endif

#include "Factu.ch" 

#define _CCODUSE                 ( dbfUser )->( fieldpos( "cCodUse" ) )       //   C      3      0
#define _CNBRUSE                 ( dbfUser )->( fieldpos( "cNbrUse" ) )       //   C     30      0
#define _CCLVUSE                 ( dbfUser )->( fieldpos( "cClvUse" ) )       //   C     10      0
#define _LSNDINT                 ( dbfUser )->( fieldpos( "lSndInt" ) ) 
#define _NLEVUSE                 ( dbfUser )->( fieldpos( "nLevUse" ) )       //   N      1      0
#define _LUSEUSE                 ( dbfUser )->( fieldpos( "lUseUse" ) )       //   L      1      0
#define _CEMPUSE                 ( dbfUser )->( fieldpos( "cEmpUse" ) )       //   C      2      0
#define _CPCNUSE                 ( dbfUser )->( fieldpos( "cPcnUse" ) )       //   C     50      0
#define _CCAJUSE                 ( dbfUser )->( fieldpos( "cCajUse" ) ) 
#define _CCJRUSE                 ( dbfUser )->( fieldpos( "cCjrUse" ) ) 
#define _CALMUSE                 ( dbfUser )->( fieldpos( "cAlmUse" ) ) 
#define _CFPGUSE                 ( dbfUser )->( fieldpos( "cFpgUse" ) ) 
#define _NGRPUSE                 ( dbfUser )->( fieldpos( "nGrpUse" ) ) 
#define _CIMAGEN                 ( dbfUser )->( fieldpos( "cImaGen" ) ) 
#define _LCHGPRC                 ( dbfUser )->( fieldpos( "lChgPrc" ) )       //   L      1      0
#define _LSELFAM                 ( dbfUser )->( fieldpos( "lSelFam" ) )       //   L      1      0
#define _LNOTBMP                 ( dbfUser )->( fieldpos( "lNotBmp" ) )       //   L      1      0
#define _LNOTINI                 ( dbfUser )->( fieldpos( "lNotIni" ) )       //   L      1      0
#define _NSIZICO                 ( dbfUser )->( fieldpos( "nSizIco" ) )       //   L      1      0
#define _CCODEMP                 ( dbfUser )->( fieldpos( "cCodEmp" ) )       //   C      2      0
#define _CCODDLG                 ( dbfUser )->( fieldpos( "cCodDlg" ) )       //   C      2      0
#define _LNOTRNT                 ( dbfUser )->( fieldpos( "lNotRnt" ) )       //   L      1      0
#define _LNOTCOS                 ( dbfUser )->( fieldpos( "lNotCos" ) )       //   L      1      0
#define _LUSRZUR                 ( dbfUser )->( fieldpos( "lUsrZur" ) )       //   L      1      0
#define _LALERTA                 ( dbfUser )->( fieldpos( "lAleRta" ) )       //   L      1      0
#define _LGRUPO                  ( dbfUser )->( fieldpos( "lGruPo"  ) )       //   L      1      0     Lógico de grupo
#define _CCODGRP                 ( dbfUser )->( fieldpos( "cCodGrp"  ) )       //   C      3      0     Código de grupo
#define _LNOTDEL                 ( dbfUser )->( fieldpos( "lNotDel"  ) )       //   L      1      0     Lógico de pedir autorización al borrar registros
#define _CCODTRA                 ( dbfUser )->( fieldpos( "cCodTra"  ) )       //   C      3      0     Código de grupo
#define _LFILVTA                 ( dbfUser )->( fieldpos( "lFilVta"  ) )       //   L      1      0     Filtrar ventas por usuario
#define _LDOCAUT                 ( dbfUser )->( fieldpos( "lDocAut"  ) )       //   L      1      0     Documentos automáticos
#define _DULTAUT                 ( dbfUser )->( fieldpos( "dUltAut"  ) )       //   D      8      0     Último documento aautomático
#define _LNOOPCAJ                ( dbfUser )->( fieldpos( "lNooPcaj" ) )       //   L      1      0 
#define _LARQCIE                 ( dbfUser )->( fieldpos( "lArqCie"  ) )       //   L      1      0
#define _CCODSALA                ( dbfUser )->( fieldpos( "cCodSala" ) )       
#define _CSERDEF                 ( dbfUser )->( fieldpos( "cSerDef"  ) )       //   C      1      0
#define _LNOTUNI                 ( dbfUser )->( fieldpos( "lNotUni"  ) )       //   L      1      0
#define _LNOTCOB                 ( dbfUser )->( fieldpos( "lNotCob"  ) )       //   L      1      0
#define _LNOTNOT                 ( dbfUser )->( fieldpos( "lNotNot"  ) )       //   L      1      0
#define _LNOTCOM                 ( dbfUser )->( fieldpos( "lNotCom"  ) )       //   L      1      0
#define _UUID                    ( dbfUser )->( fieldpos( "Uuid"     ) )       //   C     40      0

//----------------------------------------------------------------------------//
//Comenzamos la parte de código que se compila para el ejecutable normal

static oWndBrw

static dbfEmp

static dbfUser
static dbfMapa
static dbfCajT
static dbfDelega
static dbfSalaVta

static oOperario
static oClaveRepetida
static cClaveRepetida

static oLstUsr

static bEdit            := { |aTmp, aGet, dbfUser, oBrw, bWhen, bValid, nMode | EdtRec( aTmp, aGet, dbfUser, oBrw, bWhen, bValid, nMode ) }

//----------------------------------------------------------------------------//

#ifndef __PDA__

Function OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   IF !lExistTable( cPatDat() + "USERS.DBF" ) .or. ;
      !lExistTable( cPatDat() + "MAPAS.DBF" )
		mkUsuario()
	END IF

   IF !lExistIndex( cPatDat() + "USERS.CDX" ) .or. ;
      !lExistIndex( cPatDat() + "MAPAS.CDX" )
      rxUsuario()
	END IF

   USE ( cPatDat() + "Users.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "USERS", @dbfUser ) )
   SET ADSINDEX TO ( cPatDat() + "Users.Cdx" ) ADDITIVE

   USE ( cPatDat() + "Mapas.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "MAPAS", @dbfMapa ) )
   SET ADSINDEX TO ( cPatDat() + "Mapas.Cdx" ) ADDITIVE

   USE ( cPatDat() + "Cajas.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CAJAS", @dbfCajT ) )
   SET ADSINDEX TO ( cPatDat() + "Cajas.Cdx" ) ADDITIVE

   USE ( cPatDat() + "EMPRESA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "EMPRESA", @dbfEmp ) )
   SET ADSINDEX TO ( cPatDat() + "EMPRESA.CDX" ) ADDITIVE

   USE ( cPatDat() + "DELEGA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DELEGA", @dbfDelega ) )
   SET ADSINDEX TO ( cPatDat() + "DELEGA.CDX" ) ADDITIVE

   USE ( cPatEmp() + "SALAVTA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "SALAVTA", @dbfSalaVta ) )
   SET ADSINDEX TO ( cPatEmp() + "SALAVTA.CDX" ) ADDITIVE

   if !Empty( oOperario )
      oOperario:OpenFiles()
   end if

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      CloseFiles()
      lOpen := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lOpen )

//---------------------------------------------------------------------------//

Static Function CloseFiles()

   if !Empty( dbfUser )
      ( dbfUser )->( dbCloseArea() )
   end if

   if !Empty( dbfMapa )
      ( dbfMapa )->( dbCloseArea() )
   end if

   if !Empty( dbfCajT )
      ( dbfCajT )->( dbCloseArea() )
   end if

   if !Empty( dbfEmp )
      ( dbfEmp )->( dbCloseArea() )
   end if

   if !Empty( dbfDelega )
      ( dbfDelega )->( dbCloseArea() )
   end if

   if !Empty( dbfSalaVta )
      ( dbfSalaVta )->( dbCloseArea() )
   end if

   dbfUser        := nil
   dbfMapa        := nil
   dbfCajT        := nil
   dbfEmp         := nil 
   dbfDelega      := nil
   dbfSalaVta     := nil

   if oWndBrw != nil
      oWndBrw     := nil
   end if

Return .t.

//----------------------------------------------------------------------------//

FUNCTION Usuarios( oMenuItem, oWnd )

   local oSnd
   local oFlt
   local nLevel

   DEFAULT  oMenuItem   := "01052"
   DEFAULT  oWnd        := oWnd()

   nLevel               := Auth():Level( oMenuItem )
   if nAnd( nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      return nil
   end if

   oOperario            := TOperarios():Create()

   if oWndBrw == NIL

   /*
   Cerramos todas las ventanas
   */

   if oWnd != nil
      SysRefresh(); oWnd:CloseAll(); SysRefresh()
   end if

   OpenFiles()

   DEFINE SHELL oWndBrw FROM 2, 10 TO 18, 70;
      XBROWSE ;
		TITLE 	"Usuarios" ;
      PROMPT   "Código",;
               "Nombre";
      MRU      "gc_businesspeople_16";
      BITMAP   "WebTopGreen" ;
		ALIAS		( dbfUser ) ;
      LEVEL    ( nLevel ) ;
      APPEND   ( WinAppRec( oWndBrw:oBrw, bEdit, dbfUser ) );
      DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdit, dbfUser ) );
      EDIT     ( WinEdtRec( oWndBrw:oBrw, bEdit, dbfUser ) );
      DELETE   ( WinDelRec( oWndBrw:oBrw, dbfUser, {|| QuiUsr( dbfUser ) } ) );
      OF       oWnd

      oWndBrw:lAutoPos     := .f.
      oWndBrw:cHtmlHelp    := "Usuarios"

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Seleccionado"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfUser )->lUseUse }
         :nWidth           := 20
         :SetCheck( { "Cnt16", "Nil16" } )
         :AddResource( "gc_user_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Envio"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfUser )->lSndInt }
         :nWidth           := 20
         :SetCheck( { "gc_mail2_12", "Nil16" } )
         :AddResource( "gc_mail2_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodUse"
         :bEditValue       := {|| if( ( dbfUser )->lGrupo, '<' + Rtrim( ( dbfUser )->cCodUse ) + '>', ( dbfUser )->cCodUse ) }
         :nWidth           := 80
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNbrUse"
         :bEditValue       := {|| if( ( dbfUser )->lGrupo, '<' + Rtrim( ( dbfUser )->cNbrUse ) + '>', ( dbfUser )->cNbrUse ) }
         :nWidth           := 360
      end with

      oWndBrw:CreateXFromCode()

      DEFINE BTNSHELL RESOURCE "BUS" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:SearchSetFocus() ) ;
			TOOLTIP 	"(B)uscar";
         HOTKEY   "B"

      oWndBrw:AddSeaBar()

      DEFINE BTNSHELL RESOURCE "SEL" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( if( !( dbfUser )->lUseUse, changeUser( ( dbfUser )->cCodUse, dbfUser, dbfCajT, oWndBrw ), MsgStop( "Usuario en uso" ) ) ) ;
         TOOLTIP  "Sele(c)cionar";
         HOTKEY   "C"

      DEFINE BTNSHELL RESOURCE "NEW" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( oWndBrw:RecAdd() );
			ON DROP	( oWndBrw:RecDup() );
         BEGIN GROUP;
         TOOLTIP  "(A)ñadir";
         HOTKEY   "A";
         LEVEL    ACC_APPD

      DEFINE BTNSHELL RESOURCE "GC_BUSINESSPEOPLE_PLUS_" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( WinAppRec( oWndBrw:oBrw, bEdit, dbfUser, .t. ) );
         ON DROP  ( WinAppRec( oWndBrw:oBrw, bEdit, dbfUser, .t. ) );
         BEGIN GROUP;
         TOOLTIP  "Añadir (g)rupo";
         HOTKEY   "G";
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
			TOOLTIP 	"(M)odificar";
         HOTKEY   "M";
         LEVEL    ACC_EDIT

		DEFINE BTNSHELL RESOURCE "ZOOM" OF oWndBrw ;
			NOBORDER ;
			ACTION  	( WinZooRec( oWndBrw:oBrw, bEdit, dbfUser ) );
			TOOLTIP 	"(Z)oom";
         HOTKEY   "Z";
         LEVEL    ACC_ZOOM

      DEFINE BTNSHELL RESOURCE "DEL" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( oWndBrw:RecDel() );
			TOOLTIP 	"(E)liminar";
         HOTKEY   "E";
         LEVEL    ACC_DELE

   #ifndef __TACTIL__

      DEFINE BTNSHELL RESOURCE "IMP" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( ListUsr():New( "Listado de usuarios" ):Play() ) ;
         TOOLTIP  "(L)istado" ;
         HOTKEY   "L";
         LEVEL    ACC_IMPR

   #endif

      DEFINE BTNSHELL oSnd RESOURCE "Lbl" GROUP OF oWndBrw ;
         NOBORDER ;
         MENU     This:Toggle() ;
         TOOLTIP  "En(v)iar" ;
         ACTION   ( lSelectUsuario( .t. ), oWndBrw:Refresh() ) ;
         HOTKEY   "V";
         LEVEL    ACC_EDIT

   if oUser():lAdministrador()

      DEFINE BTNSHELL RESOURCE "BMPCHG" GROUP OF oWndBrw ;
         NOBORDER ;
         ACTION   ( ReplaceCreator( oWndBrw, dbfUser, aItmUsuario() ) ) ;
         TOOLTIP  "Cambiar campos" ;
         LEVEL    ACC_APPD

   end if

      DEFINE BTNSHELL RESOURCE "BMPCHG" GROUP OF oWndBrw ;
         NOBORDER ;
         ACTION   ( lFreeAllUser( dbfUser ), oWndBrw:Refresh() ) ;
         TOOLTIP  "(L)ibrear usuarios" ;
         HOTKEY   "L"

      DEFINE BTNSHELL RESOURCE "END" GROUP OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:End() ) ;
         TOOLTIP  "(S)alir" ;
			HOTKEY 	"S"

      ACTIVATE WINDOW oWndBrw VALID ( CloseFiles() )

	ELSE

      oWndBrw:SetFocus()

	END IF

RETURN NIL

//----------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aTmp, aGet, dbfUser, oBrw, lGrupo, bValid, nMode )

	local oDlg
	local oGet
   local aBmp           := {}
   local oImgLst
   local oChkAcc        := Array( 6 )
   local aChkAcc        := Afill( Array( 6 ), .f. )
   local oTree
   local oSay           := Array( 2 )
   local cSay           := Array( 2 )
   local bmpImage
   local aGrupoUsuarios := { "Administradores", "Usuarios" }
   local cGrupoUsuarios
   local oSayDlg
   local cSayDlg
   local oBmpGeneral

   if Valtype( lGrupo ) != "L"
      lGrupo            := .f.
   end if

   do case
      case nMode == APPD_MODE

         if !lUsrMaster()
            msgStop( "Solo puede añadir usuarios, el usuario Administrador." )
            return .f.
         end if

         aTmp[ _NLEVUSE ]  := 1
         aTmp[ _NGRPUSE ]  := 2
         aTmp[ _LGRUPO  ]  := lGrupo

      case nMode == EDIT_MODE

         if !lUsrMaster()
            msgStop( "Solo puede modificar las propiedades el usuario Administrador." )
            return .f.
         end if

   end case

   if Empty( aTmp[ _NGRPUSE ] )
      aTmp[ _NGRPUSE ]  := 1
   end if

   cClaveRepetida       := aTmp[ _CCLVUSE ]
   cSayDlg              := RetFld( aTmp[_CCODDLG], dbfDelega, "cNomDlg" )
   cGrupoUsuarios       := aGrupoUsuarios[ aTmp[ _NGRPUSE ] ]

   if aTmp[ _LGRUPO ]

   DEFINE DIALOG oDlg RESOURCE "GRUPOS" TITLE LblTitle( nMode ) + "grupos de usuarios"

   else

   DEFINE DIALOG oDlg RESOURCE "USUARIOS" TITLE LblTitle( nMode ) + "usuarios"

      REDEFINE GET aGet[ _CCLVUSE ] VAR aTmp[ _CCLVUSE ];
			ID 		120 ;
         IDSAY    121 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			PICTURE 	"@!" ;
			COLOR 	CLR_GET ;
			OF 		oDlg

      REDEFINE GET oClaveRepetida VAR cClaveRepetida;
         ID       122 ;
         IDSAY    123 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			PICTURE 	"@!" ;
			COLOR 	CLR_GET ;
			OF 		oDlg

      REDEFINE COMBOBOX aGet[ _NGRPUSE ] VAR cGrupoUsuarios ;
         ITEMS    aGrupoUsuarios ;
         ID       125 ;
         WHEN     ( aTmp[ _CCODUSE ] != "000" .and. nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
         OF       oDlg

      REDEFINE GET aGet[ _CALMUSE ] VAR aTmp[ _CALMUSE ] ;
         ID       130;
         PICTURE  "@!" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cAlmacen( aGet[ _CALMUSE ], , oSay[1] ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAlmacen( aGet[ _CALMUSE ], oSay[1] ) );
         OF       oDlg

      REDEFINE GET oSay[1] VAR cSay[1] ;
         WHEN     .f. ;
         ID       131 ;
         COLOR    CLR_GET ;
         OF       oDlg

      REDEFINE GET aGet[ _CIMAGEN ] VAR aTmp[ _CIMAGEN ] ;
         BITMAP   "LUPA" ;
         ON HELP  ( GetBmp( aGet[ _CIMAGEN ], bmpImage ) ) ;
         ON CHANGE( ChgBmp( aGet[ _CIMAGEN ], bmpImage ) ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ID       140 ;
         OF       oDlg

      REDEFINE CHECKBOX aGet[ _LSELFAM ] VAR aTmp[ _LSELFAM ] ;
         ID       250 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE CHECKBOX aGet[ _LARQCIE ] VAR aTmp[ _LARQCIE ] ;
         ID       300 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE CHECKBOX aGet[ _LALERTA ] VAR aTmp[ _LALERTA ] ;
         ID       310 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aGet[ _CCAJUSE ] VAR aTmp[ _CCAJUSE ];
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    cCajas( aGet[ _CCAJUSE ], dbfCajT, oSay[ 2 ] ) ;
         ID       150 ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwCajas( aGet[ _CCAJUSE ], oSay[ 2 ] ) ) ;
         OF       oDlg

      REDEFINE GET oSay[ 2 ] VAR cSay[ 2 ] ;
         ID       151 ;
         WHEN     .f. ;
         OF       oDlg

      REDEFINE GET aGet[ _CCODEMP ] VAR aTmp[ _CCODEMP ];
         WHEN     ( aTmp[ _CCODUSE ] != "000" .and. nMode != ZOOM_MODE ) ;
         ID       155 ;
         IDTEXT   156 ;
         BITMAP   "LUPA" ;
         VALID    ( cEmpresa( aGet[ _CCODEMP ], dbfEmp, aGet[ _CCODEMP ]:oHelpText ) ) ;
         ON HELP  ( BrwEmpresa( aGet[ _CCODEMP ], dbfEmp, aGet[ _CCODEMP ]:oHelpText ) ) ;
         OF       oDlg

      REDEFINE GET aGet[ _CCODDLG ] VAR aTmp[ _CCODDLG ];
         WHEN     ( aTmp[ _CCODUSE ] != "000" .and. !Empty( aTmp[ _CCODEMP ] ) .and. nMode != ZOOM_MODE ) ;
         ID       160 ;
         BITMAP   "LUPA" ;
         VALID    ( cDelegacion( aGet[ _CCODDLG ], dbfDelega, oSayDlg, aTmp[ _CCODEMP ] ) ) ;
         ON HELP  ( BrwDelegacion( aGet[ _CCODDLG ], dbfDelega, oSayDlg, aTmp[ _CCODEMP ] ) ) ; 
         OF       oDlg

      REDEFINE GET oSayDlg VAR cSayDlg ;
         ID       161 ;
         WHEN     .f. ;
         OF       oDlg

      REDEFINE GET aGet[ _CSERDEF ] VAR aTmp[ _CSERDEF ];
         ID       370 ;
         PICTURE  "@!" ;
         SPINNER ;
         ON UP    ( UpSerie( aGet[ _CSERDEF ] ) );
         ON DOWN  ( DwSerie( aGet[ _CSERDEF ] ) ); 
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( Empty( aTmp[ _CSERDEF ] ) .or. ( aTmp[ _CSERDEF ] >= "A" .AND. aTmp[ _CSERDEF ] <= "Z" ) ) ;
         OF       oDlg   

      REDEFINE GET aGet[ _CCODTRA ] VAR aTmp[ _CCODTRA ];
         ID       340 ;
         IDTEXT   341 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         VALID    ( oOperario:Existe( aGet[ _CCODTRA ], aGet[ _CCODTRA ]:oHelpText, "cNomTra", .t., .t., "0" ) ) ;
         ON HELP  ( oOperario:Buscar( aGet[ _CCODTRA ] ) ) ;
         OF       oDlg

      REDEFINE GET aGet[ _CCODSALA ] VAR aTmp[ _CCODSALA ];
         ID       460 ;
         IDTEXT   461 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cSalaVta( aGet[ _CCODSALA ], dbfSalaVta, aGet[ _CCODSALA ]:oHelpText ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwSalaVta( dbfSalaVta, aGet[ _CCODSALA ], aGet[ _CCODSALA ]:oHelpText ) ) ;
         OF       oDlg

      REDEFINE BITMAP bmpImage ;
         ID       500 ;
         FILE     ( cFileBitmap( cPatImg(), aTmp[ _CIMAGEN ] ) ) ;
         ON RIGHT CLICK ( bmpImage:lStretch := !bmpImage:lStretch, bmpImage:Refresh() );
         OF       oDlg ;

      bmpImage:SetColor( , GetSysColor( 15 ) )

      REDEFINE GET aGet[ _CCODGRP ] VAR aTmp[ _CCODGRP ];
         ID       320 ;
         IDTEXT   321 ;
         IDSAY    322 ;
         WHEN     ( nMode != ZOOM_MODE .and. aTmp[ _CCODUSE ] != "000" ) ;
         VALID    ( lValidGruop( aGet[ _CCODGRP ], dbfUser, oTree, oChkAcc ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwUser( aGet[ _CCODGRP ], dbfUser, aGet[ _CCODGRP ]:oHelpText, .f., .t. ) ) ;
         OF       oDlg

      REDEFINE CHECKBOX aGet[ _LFILVTA ] VAR aTmp[ _LFILVTA ] ;
         ID       350 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE CHECKBOX aGet[ _LDOCAUT ] VAR aTmp[ _LDOCAUT ] ;
         ID       360 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE CHECKBOX aGet[ _LNOOPCAJ ] VAR aTmp[ _LNOOPCAJ ] ;
         ID       400 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg   

      REDEFINE CHECKBOX aGet[ _LNOTUNI ] VAR aTmp[ _LNOTUNI ] ;
         ID       410 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg  

      REDEFINE CHECKBOX aGet[ _LNOTCOB ] VAR aTmp[ _LNOTCOB ] ;
         ID       420 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg  

      REDEFINE CHECKBOX aGet[ _LNOTNOT ] VAR aTmp[ _LNOTNOT ] ;
         ID       430 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg   

      REDEFINE CHECKBOX aGet[ _LNOTCOM ] VAR aTmp[ _LNOTCOM ] ;
         ID       440 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg   

   end if

      REDEFINE BITMAP oBmpGeneral ;
         ID       990 ;
         RESOURCE "gc_businessman_48" ;
         TRANSPARENT ;
         OF       oDlg

      REDEFINE GET oGet VAR aTmp[ _CCODUSE ];
			ID 		100 ;
         WHEN     ( nMode == APPD_MODE .OR. nMode == DUPL_MODE ) ;
         VALID    ( NotValid( oGet, dbfUser, .t., "0" ) ) ;
			OF 		oDlg

      REDEFINE GET aGet[ _CNBRUSE ] VAR aTmp[ _CNBRUSE ];
			ID 		110 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			PICTURE 	"@!" ;
			OF 		oDlg

      REDEFINE CHECKBOX aGet[ _LCHGPRC ] VAR aTmp[ _LCHGPRC ] ;
         ID       240 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE CHECKBOX aGet[ _LNOTRNT ] VAR aTmp[ _LNOTRNT ] ;
         ID       260 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE CHECKBOX aGet[ _LNOTCOS ] VAR aTmp[ _LNOTCOS ] ;
         ID       270 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE CHECKBOX aGet[ _LNOTBMP ] VAR aTmp[ _LNOTBMP ] ;
         ID       280 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE CHECKBOX aGet[ _LNOTINI ] VAR aTmp[ _LNOTINI ] ;
         ID       290 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE CHECKBOX aGet[ _LNOTDEL ] VAR aTmp[ _LNOTDEL ] ;
         ID       330 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      oImgLst        := TImageList():New()

      aAdd( aBmp, TBitmap():Define( "gc_folder_open_16", , oDlg ) )
      aAdd( aBmp, TBitmap():Define( "gc_sign_forbidden_16", , oDlg ) )
      aAdd( aBmp, TBitmap():Define( "new16", , oDlg ) )
      aAdd( aBmp, TBitmap():Define( "edit16", , oDlg ) )
      aAdd( aBmp, TBitmap():Define( "gc_lock2_16", , oDlg ) )
      aAdd( aBmp, TBitmap():Define( "del16", , oDlg ) )
      aAdd( aBmp, TBitmap():Define( "gc_printer2_16", , oDlg ) )

      aEval( aBmp, {| oBmp | oImgLst:AddMasked( oBmp, Rgb( 255, 0, 255 ) ) } )

      oTree          := TTreeView():Redefine( 170, oDlg  )
      oTree:bChanged := {|| SetMenu( oTree, oChkAcc ), ChangeMenu( aChkAcc, oChkAcc ) }

      REDEFINE CHECKBOX oChkAcc[1] VAR aChkAcc[1] ;
         ID       180 ;
         WHEN     ( nMode != ZOOM_MODE .and. aTmp[_CCODUSE] != "000" ) ;
         ON CHANGE( ChangeMenu( aChkAcc, oChkAcc ), SelMenu( oTree, oTree:GetSelected(), aChkAcc, oChkAcc ) );
         OF       oDlg

      REDEFINE CHECKBOX oChkAcc[2] VAR aChkAcc[2] ;
         ID       190 ;
         WHEN     ( nMode != ZOOM_MODE .and. aTmp[_CCODUSE] != "000" ) ;
         ON CHANGE( SelMenu( oTree, oTree:GetSelected(), aChkAcc, oChkAcc ) );
         OF       oDlg

      REDEFINE CHECKBOX oChkAcc[3] VAR aChkAcc[3] ;
         ID       200 ;
         WHEN     ( nMode != ZOOM_MODE .and. aTmp[_CCODUSE] != "000" ) ;
         ON CHANGE( SelMenu( oTree, oTree:GetSelected(), aChkAcc, oChkAcc ) );
         OF       oDlg

      REDEFINE CHECKBOX oChkAcc[4] VAR aChkAcc[4] ;
         ID       210 ;
         WHEN     ( nMode != ZOOM_MODE .and. aTmp[_CCODUSE] != "000" ) ;
         ON CHANGE( SelMenu( oTree, oTree:GetSelected(), aChkAcc, oChkAcc ) );
         OF       oDlg

      REDEFINE CHECKBOX oChkAcc[5] VAR aChkAcc[5] ;
         ID       220 ;
         WHEN     ( nMode != ZOOM_MODE .and. aTmp[ _CCODUSE ] != "000" ) ;
         ON CHANGE( SelMenu( oTree, oTree:GetSelected(), aChkAcc, oChkAcc ) );
         OF       oDlg

      REDEFINE CHECKBOX oChkAcc[6] VAR aChkAcc[6] ;
         ID       230 ;
         WHEN     ( nMode != ZOOM_MODE .and. aTmp[ _CCODUSE ] != "000" ) ;
         ON CHANGE( SelMenu( oTree, oTree:GetSelected(), aChkAcc, oChkAcc ) );
         OF       oDlg

      REDEFINE BUTTON ;
         ID       560 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( if( ComprobarClave( aTmp ), SaveUser( aTmp, aGet, dbfUser, oTree, oBrw, oDlg, nMode, oGet ), ) )

		REDEFINE BUTTON ;
         ID       561 ;
			OF 		oDlg ;
         CANCEL ;
			ACTION	( oDlg:end() )

      REDEFINE BUTTON ;
         ID       569 ;
			OF 		oDlg ;
         ACTION   ( ChmHelp ("Usuarios") )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| if( ComprobarClave( aTmp ), SaveUser( aTmp, aGet, dbfUser, oTree, oBrw, oDlg, nMode, oGet ), ) } )
   end if

   oDlg:AddFastKey( VK_F1, {|| ChmHelp ("Usuarios") } )

   oDlg:bStart    := {|| StartEdtRec( oGet, aGet, nMode ) }

   ACTIVATE DIALOG oDlg ;
      ON INIT     ( InitEdtRec( aTmp, aGet, oTree, oImgLst, bmpImage ) ) ;
      CENTER

   oBmpGeneral:End()

Return ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Static Function StartEdtRec( oGet, aGet, nMode )

   EvalGet( aGet, nMode )

   oGet:SetFocus()

Return ( .t.  )

//--------------------------------------------------------------------------//

Static Function InitEdtRec( aTmp, aGet, oTree, oImgLst, bmpImage )

   oWndBar():CreateTree( oTree )

   oTree:SetImageList( oImgLst )

   oMenuTree( aTmp[ _CCODUSE ], oTree, oTree:aItems )

   if !empty( aGet[ _CIMAGEN ] )
      ChgBmp( aGet[ _CIMAGEN ], bmpImage )
   end if

Return ( nil )

//--------------------------------------------------------------------------//

Static Function SaveUser( aTmp, aGet, dbfUser, oTree, oBrw, oDlg, nMode, oGet )

   local nRec  := ( dbfUser )->( Recno() )

   if Empty( aTmp[ _CCODUSE ] )
      MsgStop( "Código de usuario no puede estar vacio" )
      aGet[ _CCODUSE ]:SetFocus()
      Return .f.
   end if

   if Empty( aTmp[ _CNBRUSE ] )
      MsgStop( "Nombre de usuario no puede estar vacio" )
      aGet[ _CNBRUSE ]:SetFocus()
      Return .f.
   end if

   if ( Rtrim( cClaveRepetida ) != Rtrim( aTmp[ _CCLVUSE ] ) ) .or. Len( Rtrim( cClaveRepetida ) ) != Len( Rtrim( aTmp[ _CCLVUSE ] ) )
      MsgStop( "La clave de usuario no coincide" )
      aGet[ _CCLVUSE ]:SetFocus()
      Return .f.
   end if

   /*
   Empezamos a grabar--------------------------------------------------------
   */

   if !Empty( aGet[ _NGRPUSE ] )
      aTmp[ _NGRPUSE ]  := aGet[ _NGRPUSE ]:nAt
   end if

   ( dbfUser )->( dbGoTo( nRec ) )

   SaveMenu( oTree, aTmp )

   WinGather( aTmp, aGet, dbfUser, oBrw, nMode )

   /*
   Situamos las porpiedades del usuario por defecto----------------------------
   */

   if ( dbfUser )->cCodUse == Auth():Codigo()
      oSetUsr( ( dbfUser )->cCodUse, .f. )
   end if

Return ( oDlg:end( IDOK ) )

//---------------------------------------------------------------------------//

Static Function SetMenu( oTree, oChkAcc )

   local oItem := oTree:GetSelected()

   if !Empty( oItem:Cargo )
      Eval( oChkAcc[ 1 ]:bSetGet, nAnd( oItem:Cargo,  1 ) != 0 )
      Eval( oChkAcc[ 2 ]:bSetGet, nAnd( oItem:Cargo,  2 ) != 0 )
      Eval( oChkAcc[ 3 ]:bSetGet, nAnd( oItem:Cargo,  4 ) != 0 )
      Eval( oChkAcc[ 4 ]:bSetGet, nAnd( oItem:Cargo,  8 ) != 0 )
      Eval( oChkAcc[ 5 ]:bSetGet, nAnd( oItem:Cargo, 16 ) != 0 )
      Eval( oChkAcc[ 6 ]:bSetGet, nAnd( oItem:Cargo, 32 ) != 0 )
      aSend( oChkAcc, "Refresh" )
   end if

return ( nil )

//----------------------------------------------------------------------------//

static function SelMenu( oTree, oItem, aChkAcc, oChkAcc )

   local i

   if empty( oItem )
      Return .f.
   end if 

   if !isnil( oItem:Cargo )

      oItem:Cargo       := 0

      if Eval( oChkAcc[1]:bSetGet )
         oItem:Cargo    := nOr( oItem:Cargo, 1 )
      end if

      if Eval( oChkAcc[2]:bSetGet )
         oItem:Cargo    := nOr( oItem:Cargo, 2 )
      end if

      if Eval( oChkAcc[3]:bSetGet )
         oItem:Cargo    := nOr( oItem:Cargo, 4 )
      end if

      if Eval( oChkAcc[4]:bSetGet )
         oItem:Cargo    := nOr( oItem:Cargo, 8 )
      end if

      if Eval( oChkAcc[5]:bSetGet )
         oItem:Cargo    := nOr( oItem:Cargo, 16 )
      end if

      if Eval( oChkAcc[6]:bSetGet )
         oItem:Cargo    := nOr( oItem:Cargo, 32 )
      end if

      oTree:SetItemImage( oItem, nLev2Img( oItem:Cargo ) - 1 )
      // TvSetItemImage( oTree:hWnd, oItem:hItem, nLev2Img( oItem:Cargo ) - 1 )

   else

      for i := 1 to Len( oItem:aItems )
         selMenu( oTree, oItem:aItems[ i ], aChkAcc, oChkAcc )
      next

   end if

   if !empty(oTree)
      oTree:Refresh()
   end if 

return .t.

//----------------------------------------------------------------------------//

function oMenuTree( cCodUsr, oTree, aItems )

   local n
   local nLevOpc

   for n := 1 to Len( aItems )

      if !Empty( aItems[ n ]:aItems )

         oMenuTree( cCodUsr, oTree, aItems[ n ]:aItems )

      else

         if !Empty( aItems[ n ]:bAction )

            if ( dbfMapa )->( dbSeek( cCodUsr + aItems[ n ]:bAction ) )
               nLevOpc              := ( dbfMapa )->nLevOpc
            else
               nLevOpc              := 62
            end if

            aItems[ n ]:Cargo       := nLevOpc

            oTree:SetItemImage( aItems[ n ], nLev2Img( aItems[ n ]:Cargo - 1 ) )
            // TvSetItemImage( oTree:hWnd, aItems[ n ]:hItem, nLev2Img( aItems[ n ]:Cargo ) - 1 )

         end if

      endif

   next

return oTree

//----------------------------------------------------------------------------//

static function SaveMenu( oTree, aTmp )

   /*
   Si existe anterior----------------------------------------------------------
   */

   while ( dbfMapa )->( dbSeek( aTmp[ _CCODUSE ] ) )
      if ( dbfMapa )->( dbRLock() )
         ( dbfMapa )->( dbDelete() )
         ( dbfMapa )->( dbUnLock() )
      end if
      ( dbfMapa )->( dbSkip() )
   end while

   Tree2Mapa( "", oTree:aItems, aTmp )

return ( nil )

//----------------------------------------------------------------------------//
/*
Grabamos--------------------------------------------------------------------
*/

static function Tree2Mapa( cPreItem, oItem , aTmp )

   local n

   for n := 1 to len( oItem )

      if !Empty( oItem[ n ]:aItems )

         Tree2Mapa( Rtrim( oItem[ n ]:cPrompt ), oItem[ n ]:aItems, aTmp )

      else

         ( dbfMapa )->( dbAppend() )
         ( dbfMapa )->cCodUse       := aTmp[ _CCODUSE ]

         if oItem[ n ]:Cargo != nil

            ( dbfMapa )->cNomOpc    := oItem[ n ]:bAction

            if oItem[ n ]:Cargo == 0
               ( dbfMapa )->nLevOpc := 1024
            else
               ( dbfMapa )->nLevOpc := oItem[ n ]:Cargo
            end if

         end if

      end if

   next

return nil

//----------------------------------------------------------------------------//
/*
function Auth():Level( uHelpId )

   local oError
   local oBlock
   local dbfMapa
   local cLevOpc
   local nLevOpc  := 0

   CursorWait()

   if ValType( uHelpId ) == "O"
      cLevOpc     := uHelpId:nHelpId
   else
      cLevOpc     := uHelpId
   end if

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      dbUseArea( .t., cDriver(), ( cPatDat() + "MAPAS.DBF" ),( cCheckArea( "MAPAS", @dbfMapa ) ), .t., .f. )
      if !( dbfMapa )->( neterr() )
         ( dbfMapa )->( ordListAdd( cPatDat() + "MAPAS.CDX" ) )
      end if

      if !Empty( cCurGrp() )
         if ( dbfMapa )->( dbSeek( cCurGrp() + cLevOpc ) )
            nLevOpc     := ( dbfMapa )->nLevOpc
         end if
      else
         if ( dbfMapa )->( dbSeek( Auth():Codigo() + cLevOpc ) )
            nLevOpc     := ( dbfMapa )->nLevOpc
         end if
      end if

      ( dbfMapa )->( dbCloseArea() )

   RECOVER USING oError

      msgStop( "Imposible abrir los mapas de usuarios" + CRLF + ErrorMessage( oError )  )

      if !Empty( dbfMapa )
         ( dbfMapa )->( dbCloseArea() )
      end if

   END SEQUENCE
   ErrorBlock( oBlock )

   if nLevOpc  == 0
      nLevOpc     := nOr( ACC_APPD, ACC_EDIT, ACC_ZOOM, ACC_DELE, ACC_IMPR )
   end if

   CursorWE()

return ( nLevOpc )
*/

//----------------------------------------------------------------------------//
/*
Comprobamos q el usuario esta libre--------------------------------------------
*/

function nUsrInUse( dbfUser )

   local oBlock
   local oError
   local lClo        := .f.
   local nUsr        := 0

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if Empty( dbfUser )
      USE ( cPatDat() + "USERS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "USERS", @dbfUser ) )
      SET ADSINDEX TO ( cPatDat() + "USERS.CDX" ) ADDITIVE
      lClo           := .t.
   end if

   ( dbfUser )->( dbGoTop() )
   while !( dbfUser )->( eof() )

      lFreeUser( ( dbfUser )->cCodUse, .f., dbfUser )

      if ( dbfUser )->lUseUse
         nUsr++
      end if

      ( dbfUser )->( dbSkip() )

      SysRefresh()

   end while

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if lClo
      CLOSE ( dbfUser )
   end if

return ( nUsr )

//---------------------------------------------------------------------------//

Function lFreeAllUser( dbfUser )

   local oBlock
   local oError
   local nRecno

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   nRecno            := ( dbfUser )->( recno() )

   ( dbfUser )->( dbGoTop() )
   while !( dbfUser )->( eof() )

      lFreeUser( ( dbfUser )->cCodUse, .f., dbfUser )

      ( dbfUser )->( dbSkip() )

      SysRefresh()

   end while

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   ( dbfUser )->( dbgoto( nRecno ))

Return ( nil )

//---------------------------------------------------------------------------//

FUNCTION cUser( oGet, dbfUsr, oGet2 )

   local oBlock
   local oError
   local lClose   := .f.
   local lValid   := .f.
	local xValor 	:= oGet:varGet()

   if Empty( xValor )
      if !Empty( oGet2 )
			oGet2:cText( "" )
      end if
      Return .t.
   end if

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if Empty( dbfUsr )
      USE ( cPatDat() + "USERS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "USERS", @dbfUsr ) )
      SET ADSINDEX TO ( cPatDat() + "USERS.CDX" ) ADDITIVE
      lClose      := .t.
   end if

   if dbSeekInOrd( xValor, "cCodUse", dbfUsr )

      oGet:cText( ( dbfUsr )->cCodUse )

      if !Empty( oGet2 )
         oGet2:cText( ( dbfUsr )->cNbrUse )
      end if

      lValid      := .t.

   else

      msgStop( "Código de usuario no encontrado" )

	END IF

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE
   ErrorBlock( oBlock )

   if lClose
      CLOSE ( dbfUsr )
   end if

RETURN lValid

//---------------------------------------------------------------------------//

FUNCTION BrwUser( oGet, dbfUsr, oGet2, lBigStyle, lGroup, lGetPassword, lStatus )

   local oBlock
   local oError
	local oDlg
   local aSta
   local oGet1
	local cGet1
	local oBrw
   local oBtnApp
   local oBtnEdt
	local oCbxOrd
   local lClose         := .f.
   local aCbxOrd        := { "Código", "Nombre" }
   local cCbxOrd        := "Código"
   local cReturn        := Space( 3 )

   DEFAULT lBigStyle    := .f.
   DEFAULT lGroup       := .f.
   DEFAULT lGetPassword := .t.
   DEFAULT lStatus      := .f.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if Empty( dbfUsr )
      USE ( cPatDat() + "USERS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "USERS", @dbfUsr ) )
      SET ADSINDEX TO ( cPatDat() + "USERS.CDX" ) ADDITIVE
   end if

   if lGroup
      ( dbfUsr )->( dbSetFilter( {|| Field->lGrupo }, "lGrupo" ) )
   else
      ( dbfUsr )->( dbSetFilter( {|| !Field->lGrupo }, "!lGrupo" ) )
   end if

   aSta                 := aGetStatus( dbfUsr )

   ( dbfUsr )->( ordsetfocus( "CCODUSE" ) )
   ( dbfUsr )->( dbGoTop() )

   if !lBigStyle
      DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Seleccionar usuarios"
   else
      DEFINE DIALOG oDlg RESOURCE "BigHelpEntry" TITLE "Seleccionar usuarios"
   end if

      REDEFINE GET      oGet1 ;
         VAR            cGet1 ;
			ID             104 ;
         ON CHANGE      ( AutoSeek( nKey, nFlags, oGet1, oBrw, dbfUsr ) );
         VALID          ( OrdClearScope( oBrw, dbfUsr ) );
         BITMAP         "FIND" ;
         OF             oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR            cCbxOrd ;
			ID             102 ;
         ITEMS          aCbxOrd ;
         ON CHANGE      ( ( dbfUsr )->( ordsetfocus( oCbxOrd:nAt ) ), oBrw:Refresh(), oGet1:SetFocus() ) ;
			OF             oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:cAlias          := dbfUsr
      oBrw:nMarqueeStyle   := 5

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:bLDblClick      := {|| if( !lGetPassword .or. lGetPsw( dbfUsr ), oDlg:end( IDOK ), oDlg:End() ) }

      if lBigStyle
         oBrw:nHeaderHeight   := 30
         oBrw:nRowHeight      := 40
      end if

      oBrw:CreateFromResource( 105 )

      if lStatus

      with object ( oBrw:AddCol() )
         :cHeader             := "Us. En uso"
         :bStrData            := {|| "" }
         :bEditValue          := {|| ( dbfUsr )->lUseUse }
         :nWidth              := 20
         :SetCheck( { "Cnt16", "Nil16" } )
      end with

      end if

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodUse"
         :bEditValue       := {|| if( ( dbfUsr )->lGrupo, '<' + Rtrim( ( dbfUsr )->cCodUse ) + '>', ( dbfUsr )->cCodUse ) }
         :nWidth           := 60
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNbrUse"
         :bEditValue       := {|| if( ( dbfUsr )->lGrupo, '<' + Rtrim( ( dbfUsr )->cNbrUse ) + '>', ( dbfUsr )->cNbrUse ) }
         :nWidth           := 300
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( if( !lGetPassword .or. lGetPsw( dbfUsr ), oDlg:end( IDOK ), oDlg:end() ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         ACTION   ( oDlg:end() )

      REDEFINE BUTTON oBtnApp;
         ID       500 ;
         OF       oDlg ;
         ACTION   ( if( lBigStyle, oBrw:GoUp(), ) )

      REDEFINE BUTTON oBtnEdt;
         ID       501 ;
         OF       oDlg ;
         ACTION   ( if( lBigStyle, oBrw:GoDown(), ) )

   oDlg:AddFastKey( VK_F5,       {|| if( !lGetPassword .or. lGetPsw( dbfUsr ), oDlg:end( IDOK ), oDlg:End() ) } )
   oDlg:AddFastKey( VK_RETURN,   {|| if( !lGetPassword .or. lGetPsw( dbfUsr ), oDlg:end( IDOK ), oDlg:End() ) } )

   ACTIVATE DIALOG oDlg CENTER ON INIT ( InitBrwUser( oBtnApp, oBtnEdt, lBigStyle ) )

   if oDlg:nResult == IDOK

      cReturn     := ( dbfUsr )->cCodUse

      if IsObject( oGet )
         oGet:cText( ( dbfUsr )->cCodUse )
         oGet:lValid()
      end if

      if IsObject( oGet2 )
         oGet2:cText( ( dbfUsr )->cNbrUse  )
      end if

   end if

   if !Empty( oGet )
      oGet:setFocus()
   end if

   DestroyFastFilter( dbfUsr )

   SetStatus( dbfUsr, aSta )

   ( dbfUsr )->( dbClearFilter() )

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if lClose
      Close( dbfUsr )
   end if

RETURN ( cReturn )

//---------------------------------------------------------------------------//

Function BrwUserTactil( oGet, dbfUsr, oGet2 )

   local oDlg
   local oBrw
   local nRec
   local nOrdAnt
   local cUsr              := ""
   local lClose            := .f.
   local oGetBusqueda
   local cGetBusqueda      := Space( 100 )
   local oBmpGeneral
   local oSayGeneral
   local oBotonAnadir
   local oBotonEditar
   local cResource         := "HelpEntryTactilCli"

   if Empty( dbfUsr )

      if !OpenFiles( .t. )
         Return nil
      end if

      dbfUsr               := dbfUser
      lClose               := .t.

   end if

   nRec                    := ( dbfUsr )->( Recno() )
   nOrdAnt                 := ( dbfUsr )->( ordsetfocus( "cCodUse" ) )

   ( dbfUsr )->( dbGoTop() )

   DEFINE DIALOG oDlg RESOURCE cResource

      REDEFINE BUTTONBMP ;
         ID       100 ;
         OF       oDlg ;
         BITMAP   "gc_keyboard_32";
         ACTION   ( VirtualKey( .f., oGetBusqueda ), if( lBigSeek( nil, cGetBusqueda, dbfUsr ), oBrw:Refresh(), ) )

      REDEFINE SAY oSayGeneral ;
         PROMPT   "Seleccione usuario" ;
         ID       200 ;
         OF       oDlg

      REDEFINE BITMAP oBmpGeneral ;
        ID        500 ;
        RESOURCE  "gc_users3_48" ;
        TRANSPARENT ;
        OF        oDlg

      REDEFINE GET oGetBusqueda VAR cGetBusqueda;
         ID       600 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfUsr ) );
         OF       oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfUsr
      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "Browse usuario tactil"
      oBrw:nHeaderHeight   := 40
      oBrw:nRowHeight      := 60
      oBrw:nDataLines      := 2
      oBrw:lHScroll        := .f.

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }

      oBrw:CreateFromResource( 105 )

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodUse"
         :bEditValue       := {|| alltrim( ( dbfUsr )->cCodUse ) }
         :nWidth           := 160
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNbrUse"
         :bEditValue       := {|| alltrim( ( dbfUsr )->cNbrUse ) }
         :nWidth           := 400
      end with

      REDEFINE BUTTONBMP oBotonAnadir ;
         ID       160 ;
         OF       oDlg

      REDEFINE BUTTONBMP oBotonEditar ;
         ID       170 ;
         OF       oDlg

      REDEFINE BUTTONBMP ;
         ID       140 ;
         OF       oDlg ;
         BITMAP   "Up32" ;
         ACTION   ( oBrw:GoUp() )

      REDEFINE BUTTONBMP ;
         ID       150 ;
         OF       oDlg ;
         BITMAP   "Down32" ;
         ACTION   ( oBrw:GoDown() )

      REDEFINE BUTTONBMP ;
         BITMAP   "gc_check_32" ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( oDlg:End( IDOK ) )

      REDEFINE BUTTONBMP ;
         BITMAP   "Delete_32" ;
         ID       IDCANCEL ;
         OF       oDlg ;
         ACTION   ( oDlg:End() )

      oDlg:AddFastKey( VK_F5, {|| oDlg:end( IDOK ) } )

      oDlg:bStart := {|| oBrw:Load(), oBotonAnadir:Hide(), oBotonEditar:Hide() }

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK

      cUsr        := ( dbfUsr )->cCodUse

      if !Empty( oGet )
         oGet:cText( cUsr )
      end if

      if !Empty( oGet2 )
         oGet2:cText( Rtrim( ( dbfUsr )->cNbrUse ) )
      end if

   end if

   if lClose

      CloseFiles()

   else

      ( dbfUsr )->( ordsetfocus( nOrdAnt ) )
      ( dbfUsr )->( dbGoTo( nRec ) )

   end if

Return ( .t. )

//---------------------------------------------------------------------------//

Static Function InitBrwUser( oBtnApp, oBtnEdt, lBigStyle )

   if lBigStyle
      SetWindowText( oBtnApp:hWnd, "&Subir" )
      SetWindowText( oBtnEdt:hWnd, "&Bajar" )
   else
      oBtnApp:Hide()
      oBtnEdt:Hide()
   end if

Return ( nil )

//---------------------------------------------------------------------------//

FUNCTION RetUser( cCodCaj, dbfUser )

   local oBlock
   local oError
   local cUser       := ""
   local lClose      := .f.

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if dbfUser == NIL
      USE ( cPatDat() + "USERS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "USERS", @dbfUser ) )
      SET ADSINDEX TO ( cPatDat() + "USERS.CDX" ) ADDITIVE
      lClose         := .t.
   end if

   IF ( dbfUser )->( dbSeek( cCodCaj ) )
      cUser          := ( dbfUser )->cNbrUse
	END IF

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

	IF lClose
      CLOSE ( dbfUser )
	END IF

RETURN Rtrim( cUser )

//--------------------------------------------------------------------------//

Function lGetPsw( dbfUsr, lVirtual )

   local oDlg
   local oGetClv
   local cGetClv     := Space( 10 )

   DEFAULT lVirtual  := .f.

   if Empty( Rtrim( ( dbfUsr )->cClvUse ) )
      Return .t.
   end if

   if lVirtual

      cGetClv        := VirtualKey( .t., , "Introduzca contraseña" )

      if lValidPassword( cGetClv, ( dbfUsr )->cClvUse )
         Return .t.
      else
         if !Empty( cGetClv )
            MsgStop( "Clave de usuario no valido" )
         end if
      end if

   else

      DEFINE DIALOG oDlg RESOURCE "SELUSR"

         REDEFINE GET oGetClv ;
            VAR      cGetClv ;
            ID       110 ;
            OF       oDlg

         REDEFINE BUTTON ;
            ID       ( IDOK ) ;
            OF       oDlg ;
            ACTION   oDlg:end( IDOK )

      ACTIVATE DIALOG oDlg CENTER

      if oDlg:nResult == IDOK                                                    
         
         if lValidPassword( cGetClv, ( dbfUsr )->cClvUse )

            Return .t.

         end if 

      else
         
         MsgStop( "Clave de usuario no valida" )

      end if

   end if

return ( .f. )

//--------------------------------------------------------------------------//

Static Function QuiUsr( dbfUser )

   if ( dbfUser )->lUseUse
      MsgStop( "Usuario en uso" )
      return .t.
   end if

   if !lUsrMaster()
      msgStop( "Solo puede eliminar usuarios el Administrador." )
      return .f.
   end if

Return .t.

//--------------------------------------------------------------------------//

Static Function nLev2Img( nLvlOpc )

   if nAnd( nLvlOpc, 1 ) == 1
      Return 1
   end if

   if nAnd( nLvlOpc, 2 ) == 2
      Return 2
   end if

   if nAnd( nLvlOpc, 4 ) == 4
      Return 3
   end if

   if nAnd( nLvlOpc, 8 ) == 8
      Return 4
   end if

   if nAnd( nLvlOpc, 16 ) == 16
      Return 5
   end if

   if nAnd( nLvlOpc, 32 ) == 32
      Return 6
   end if

Return ( 1 )

//---------------------------------------------------------------------------//

Function nPalBmpRead( cBmpFile, oDlg )

   local nBmpPal  := PalBmpRead( oDlg:GetDC(), cBmpFile )[ 1 ]

   oDlg:ReleaseDC()

Return ( nBmpPal )

//---------------------------------------------------------------------------//

/*
Cambia el usuario actual por el q nos pasen
*/

FUNCTION changeUser( cCodUsr, dbfUsr, dbfCajas, oWndBrw )

   if lGetPsw( dbfUsr )
      oUser():openFiles( dbfUsr, dbfCajas )
      oUser():quitUser( Auth():Codigo() )
      oUser():setUser( cCodUsr, .t. )
      oUser():save()
      oUser():closeFiles()
   end if

   if oWndBrw != nil
      oWndBrw:Refresh()
   end if

RETURN nil

//---------------------------------------------------------------------------//

FUNCTION TstUsuario()

   local oBlock
   local oError
   local dbfUsr
   local nFldUsr

   IF !lExistTable( cPatDat() + "USERS.DBF" ) .or. ;
      !lExistTable( cPatDat() + "MAPAS.DBF" )
		mkUsuario()
	END IF

   IF !lExistIndex( cPatDat() + "USERS.CDX" ) .or. ;
      !lExistIndex( cPatDat() + "MAPAS.CDX" )
      rxUsuario()
	END IF

   /*
   Cuantos campos tiene--------------------------------------------------------
   */

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   dbUseArea( .t., ( cDriver() ), ( cPatDat() + "USERS.DBF" ), ( cCheckArea( "USERS", @dbfUsr ) ), .f. )

   if !( dbfUsr )->( netErr() )

      nFldUsr        := ( dbfUsr )->( fCount() )

      ( dbfUsr )->( dbCloseArea() )

      if ( nFldUsr < len( aItmUsuario() ) )

         dbCreate( cPatEmpTmp() + "Users.Dbf", aSqlStruct( aItmUsuario() ), ( cLocalDriver() ) )
         appDbf( cPatDat(), cPatEmpTmp(), "Users" )

         fEraseTable( cPatDat() + "Users.Dbf" )
         fRenameTable( cPatEmpTmp() + "Users.Dbf", cPatDat() + "Users.Dbf" )

         rxUsuario( cPatDat() )

      end if

   end if

   RECOVER USING oError

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN NIL

//--------------------------------------------------------------------------//

Function SetNotIni( cCodUsr, dbfUser )

   local oBlock
   local oError
   local lClo        := .f.

   DEFAULT cCodUsr   := Auth():Codigo()

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if ApoloMsgNoYes( "¿ No volver a mostrar página de inicio ?", "Confirme por favor" )

      if dbfUser == nil
         USE ( cPatDat() + "USERS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "USERS", @dbfUser ) )
         SET ADSINDEX TO ( cPatDat() + "USERS.CDX" ) ADDITIVE
         lClo        := .t.
      end if

      if ( dbfUser )->( dbSeek( cCodUsr ) ) .and. ( dbfUser )->( dbRLock() )
         ( dbfUser )->lNotIni := .t.
         ( dbfUser )->( dbUnLock() )
      end if

      if lClo
         CLOSE ( dbfUser )
      end if

   end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE
   ErrorBlock( oBlock )

RETURN ( nil )

//--------------------------------------------------------------------------//

CLASS TUsuarioSenderReciver FROM TSenderReciverItem

   METHOD CreateData()

   METHOD RestoreData()

   METHOD SendData()

   METHOD ReciveData()

   METHOD Process()

END CLASS

//----------------------------------------------------------------------------//

METHOD CreateData()

   local oBlock
   local oError
   local tmpUser
   local tmpMapa
   local lSnd        := .f.
   local cFileName

   if ::oSender:lServer
      cFileName      := "Usr" + StrZero( ::nGetNumberToSend(), 6 ) + ".All"
   else
      cFileName      := "Usr" + StrZero( ::nGetNumberToSend(), 6 ) + "." + RetSufEmp()
   end if

   If !OpenFiles()
      Return Nil
   End If

   ::oSender:SetText( 'Seleccionando usuarios' )

   // Creamos todas las bases de datos relacionadas con Articulos

   mkUsuario( cPatSnd() )

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatSnd() + "Users.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "USERS", @tmpUser ) )
   SET ADSINDEX TO ( cPatSnd() + "Users.Cdx" ) ADDITIVE

   USE ( cPatSnd() + "Mapas.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "MAPAS", @tmpMapa ) )
   SET ADSINDEX TO ( cPatSnd() + "Mapas.Cdx" ) ADDITIVE

   if !Empty( ::oSender:oMtr )
      ::oSender:oMtr:nTotal := ( dbfUser )->( LastRec() )
   end if

   ( dbfUser )->( dbGoTop() )

   while !( dbfUser )->( eof() )

      if ( dbfUser )->lSndInt

         ::oSender:SetText( ( dbfUser )->cCodUse + "; " + ( dbfUser )->cNbrUse )

         lSnd     := .t.

         dbPass( dbfUser, tmpUser, .t. )

         // Mapas

         if ( dbfMapa )->( dbSeek( ( dbfUser )->cCodUse ) )

            while ( dbfMapa )->cCodUse == ( dbfUser )->cCodUse .and. !( dbfMapa )->( eof() )

               dbPass( dbfMapa, tmpMapa, .t. )
               ( dbfMapa )->( dbSkip() )

            end while

         end if

      end if

      ( dbfUser )->( dbSkip() )

      if !Empty( ::oSender:oMtr )
         ::oSender:oMtr:Set( ( dbfUser )->( OrdKeyNo() ) )
      end if

      SysRefresh()

   end while

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE ( tmpUser )
   CLOSE ( tmpMapa )

   CloseFiles()

   // Comprimir los archivos------------------------------------------------------

   if lSnd

      ::oSender:SetText( "Comprimiendo usuarios" )

      if ::oSender:lZipData( cFileName )
         ::oSender:SetText( "Ficheros comprimidos" )
      else
         ::oSender:SetText( "ERROR al crear fichero comprimido" )
      end if

   else

      ::oSender:SetText( "No hay usuarios para enviar" )

   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD RestoreData()

   local oBlock
   local oError
   local dbfUser

   if ::lSuccesfullSend

      // Sintuacion despues del envio---------------------------------------------

      oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
      BEGIN SEQUENCE

      USE ( cPatDat() + "Users.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "USERS", @dbfUser ) )
      SET ADSINDEX TO ( cPatDat() + "Users.Cdx" ) ADDITIVE

      while !( dbfUser )->( Eof() )

         if ( dbfUser )->lSndInt .and. ( dbfUser )->( dbRLock() )
            ( dbfUser )->lSndInt := .f.
            ( dbfUser )->( dbRUnlock() )
         end if

         ( dbfUser )->( dbSkip() )

      end while

      RECOVER USING oError

         msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

      END SEQUENCE
      ErrorBlock( oBlock )

      CLOSE ( dbfUser )

   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD SendData()

   local cFileName

   if ::oSender:lServer
      cFileName         := "Usr" + StrZero( ::nGetNumberToSend(), 6 ) + ".All"
   else
      cFileName         := "Usr" + StrZero( ::nGetNumberToSend(), 6 ) + "." + RetSufEmp()
   end if

   if File( cPatOut() + cFileName )

      if ::oSender:SendFiles( cPatOut() + cFileName, cFileName )
         ::IncNumberToSend()
         ::lSuccesfullSend := .t.
         ::oSender:SetText( "Ficheros de usuarios enviados " + cFileName )
      else
         ::oSender:SetText( "ERROR fichero de usuarios no enviado" )
      end if

   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD ReciveData()

   local n
   local aExt

   if ::oSender:lServer
      aExt              := aRetDlgEmp()
   else
      aExt              := { "All" }
   end if

   ::oSender:SetText( "Recibiendo usuarios" )

   for n := 1 to len( aExt )
      ::oSender:GetFiles( "Usr*." + aExt[ n ], cPatIn() )
   next

   ::oSender:SetText( "Usuarios recibidos" )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD Process()

   local m
   local aFiles
   local tmpUser
   local tmpMapa
   local oBlock
   local oError

   // Procesamos los ficheros recibidos-------------------------------------------

   aFiles                     := Directory( cPatIn() + "Usr*.*" )

   for m := 1 to len( aFiles )

      ::oSender:SetText( "Procesando fichero : " + aFiles[ m, 1 ] )

      oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )

      BEGIN SEQUENCE

      // Descomprimimos el fichero recibido------------------------------------

      if ::oSender:lUnZipData( cPatIn() + aFiles[ m, 1 ] )

         if File( cPatSnd() + "Users.Dbf" )        .and.;
            File( cPatSnd() + "Mapas.Dbf"  )       .and.;
            OpenFiles()

            USE ( cPatSnd() + "Users.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "USERS", @tmpUser ) )
            SET ADSINDEX TO ( cPatSnd() + "Users.Cdx" ) ADDITIVE

            USE ( cPatSnd() + "Mapas.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "MAPAS", @tmpMapa ) )
            SET ADSINDEX TO ( cPatSnd() + "Mapas.Cdx" ) ADDITIVE

            if !Empty( ::oSender:oMtr )
               ::oSender:oMtr:nTotal := ( tmpUser )->( OrdKeyCount() )
            end if

            while !( tmpUser )->( eof() )

               if ( dbfUser )->( dbSeek( ( tmpUser )->cCodUse ) )
                  if !::oSender:lServer
                     dbPass( tmpUser, dbfUser )
                     ::oSender:SetText( "Reemplazado : " + ( tmpUser )->cCodUse + "; " + ( tmpUser )->cNbrUse )
                  else
                     ::oSender:SetText( "Desestimado : " + ( tmpUser )->cCodUse + "; " + ( tmpUser )->cNbrUse )
                  end if
               else
                  dbPass( tmpUser, dbfUser, .t. )
                  ::oSender:SetText( "Añadido     : " + ( tmpUser )->cCodUse + "; " + ( tmpUser )->cNbrUse )
               end if

               ( tmpUser )->( dbSkip() )

               if !Empty( ::oSender:oMtr )
                  ::oSender:oMtr:Set( ( tmpUser )->( OrdKeyNo() ) )
               end if

               SysRefresh()

            end while

            if !Empty( ::oSender:oMtr )
               ::oSender:oMtr:nTotal := ( tmpMapa )->( OrdKeyCount() )
            end if

            while !( tmpMapa )->( eof() )

               if ( dbfMapa )->( dbSeek( ( tmpMapa )->cCodUse + ( tmpMapa )->cNomOpc ) )
                  if !::oSender:lServer
                     dbPass( tmpMapa, dbfMapa )
                     ::oSender:SetText( "Reemplazado : " + ( tmpMapa )->cCodUse + "; " + ( tmpMapa )->cNomOpc )
                  else
                     ::oSender:SetText( "Desestimado : " + ( tmpMapa )->cCodUse + "; " + ( tmpMapa )->cNomOpc )
                  end if
               else
                     dbPass( tmpMapa, dbfMapa, .t. )
                     ::oSender:SetText( "Añadido     : " + ( tmpMapa )->cCodUse + "; " + ( tmpMapa )->cNomOpc )
               end if

               ( tmpMapa )->( dbSkip() )

               if !Empty( ::oSender:oMtr )
                  ::oSender:oMtr:Set( ( tmpMapa )->( OrdKeyNo() ) )
               end if

               SysRefresh()

            end while

            CLOSE ( tmpUser )
            CLOSE ( tmpMapa )

            CloseFiles()

            ::oSender:AppendFileRecive( aFiles[ m, 1 ] )

         else

            ::oSender:SetText( "Faltan ficheros" )

            if !File( cPatSnd() + "Users.Dbf" )
               ::oSender:SetText( "Falta " + cPatSnd() + "Users.Dbf" )
            end if

            if !File( cPatSnd() + "Mapas.Dbf" )
               ::oSender:SetText( "Falta " + cPatSnd() + "Mapas.Dbf" )
            end if

         end if

      else

         ::oSender:SetText( "Error en el fichero comprimido" )

      end if

      RECOVER USING oError

         CLOSE ( tmpUser )
         CLOSE ( tmpMapa )

         ::oSender:SetText( "Error procesando fichero " + aFiles[ m, 1 ] )
         ::oSender:SetText( ErrorMessage( oError ) )

      END SEQUENCE
      ErrorBlock( oBlock )

   next

Return ( Self )

//---------------------------------------------------------------------------//

FUNCTION BrwBigUser( dbfUsr, dbfCaj )

   local oBlock
   local oError
   local oDlg
   local oBtn
   local aSta
   local oImgUsr
   local lCloseUsr         := .f.
   local lCloseCaj         := .f.

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( dbfUsr )
         USE ( cPatDat() + "Users.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "Users", @dbfUsr ) )
         SET ADSINDEX TO ( cPatDat() + "Users.CDX" ) ADDITIVE
         lCloseUsr         := .t.
      end if

      if Empty( dbfCaj )
         USE ( cPatDat() + "Cajas.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "Cajas", @dbfCaj ) )
         SET ADSINDEX TO ( cPatDat() + "Cajas.Cdx" ) ADDITIVE
         lCloseCaj         := .t.
      end if

      aSta                 := aGetStatus( dbfUsr )

      DEFINE DIALOG oDlg RESOURCE "SelUsuarios"

         oImgUsr           := TImageList():New( 50, 50 )

         oLstUsr           := TListView():Redefine( 100, oDlg )
         oLstUsr:nOption   := 0
         oLstUsr:bClick    := {| nOpt | selectBrwBigUser( nOpt, oDlg, dbfUsr, dbfCaj, .t. ) }

         REDEFINE BUTTONBMP oBtn ;
            BITMAP         "Delete_32" ;
            ID             IDCANCEL ;
            OF             oDlg ;
            ACTION         ( oDlg:End() )

         oDlg:bStart       := {|| InitBrwBigUser( oDlg, oImgUsr, dbfUsr ) }

      ACTIVATE DIALOG oDlg CENTER

      SetStatus( dbfUsr, aSta )

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if lCloseUsr
      Close( dbfUsr )
   end if

   if lCloseCaj
      Close( dbfCaj )
   end if

Return ( oDlg:nResult == IDOK  )

//---------------------------------------------------------------------------//

Function InitBrwBigUser( oDlg, oImgUsr, dbfUsr )

   local nItem
   local oItem
   local nGrpUse
   local nImgUse

   CursorWait()

   oImgUsr:AddMasked( TBitmap():Define( "GC_BUSINESSMAN2_50" ), Rgb( 255, 0, 255 ) )
   oImgUsr:AddMasked( TBitmap():Define( "GC_USER2_50" ), Rgb( 255, 0, 255 ) )

   if !Empty( oImgUsr ) .and. !Empty( oLstUsr )

      oLstUsr:SetImageList( oImgUsr )
      oLstUsr:EnableGroupView()

      // oLstUsr:InsertGroup( 2, "Usuarios" )
      // oLstUsr:InsertGroup( 1, "Administradores" )

      oLstUsr:InsertGroup( "Administradores" )
      oLstUsr:InsertGroup( "Usuarios" )

      ( dbfUsr )->( dbGoTop() )
      while !( dbfUsr )->( eof() )

         if !( dbfUsr )->lGrupo

            nGrpUse           := 0

            if ( dbfUsr )->nGrpUse <= 1
               nImgUse        := 0
            else
               nImgUse        := 1
            end if 

            if !empty( ( dbfUsr )->cImagen ) .and. file( rtrim( ( dbfUsr )->cImagen ) )

               oImgUsr:Add( TBitmap():Define( , rtrim( ( dbfUsr )->cImagen ), oDlg ) )

               nImgUse        := len( oImgUsr:aBitmaps )

            end if

            oItem             := TListViewItem():New( oLstUsr )
            oItem:cText       := Capitalize( ( dbfUsr )->cNbrUse )
            oItem:nImage      := nImgUse
            oItem:nGroup      := nGrpUse
            oItem:Cargo       := ( dbfUsr )->cCodUse
            oItem:Create()

         end if 

         ( dbfUsr )->( dbSkip() )

      end while

   end if

   CursorWE()

RETURN ( nil )

//---------------------------------------------------------------------------//

Static Function selectBrwBigUser( nOpt, oDlg, dbfUsr, dbfCaj )

   local oUser
   local cCodigoUsuario

   if ( nOpt == 0 )
      MsgStop( "Seleccione usuario" )
      Return nil
   end if

   if !( nOpt > 0 .and. nOpt <= len( oLstUsr:aItems ) )
      MsgStop( "Seleccione usuario" )
      Return nil
   end if       

   cCodigoUsuario    := oLstUsr:GetItem( nOpt ):Cargo

   if empty( cCodigoUsuario )
      MsgStop( "Seleccione usuario" )
      Return nil
   end if 

   if !( dbSeekInOrd( cCodigoUsuario, "cCodUse", dbfUsr ) ) // ( dbfUsr )->( OrdKeyGoTo( nOpt ) )
      MsgStop( "El usuario no existe" )
      Return nil
   end if 

   if ( dbfUsr )->lUseUse .and. !( ( dbfUsr )->cCodUse == Auth():Codigo() )
      msgStop( "Usuario en uso" )
      Return nil
   end if

   // set nuevo usuario--------------------------------------------------------

   oUser():openFiles( dbfUsr, dbfCaj )
   oUser():quitUser( Auth():Codigo() )
   oUser():setUser( cCodigoUsuario )

   oLstUsr:nOption   := 0

   oDlg:end( IDOK )

Return nil

//---------------------------------------------------------------------------//

FUNCTION SetSizeUser( cCodUsr, nSizIco, dbfUser )

   local oBlock
   local oError
   local lClose      := .f.

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if dbfUser == nil
      USE ( cPatDat() + "Users.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "USERS", @dbfUser ) )
      SET ADSINDEX TO ( cPatDat() + "Users.Cdx" ) ADDITIVE
      lClose         := .t.
   end if

   if ( dbfUser )->( dbSeek( cCodUsr ) )
      if ( dbfUser )->( dbRLock() )
         ( dbfUser )->nSizIco := nSizIco
         ( dbfUser )->( dbUnLock() )
      end if
   end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE
   ErrorBlock( oBlock )

   if lClose
      CLOSE ( dbfUser )
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

Static function ChangeMenu( aChkAcc, oChkAcc )

   if aChkAcc[1]
      oChkAcc[2]:Click( .f. )
      oChkAcc[3]:Click( .f. )
      oChkAcc[4]:Click( .f. )
      oChkAcc[5]:Click( .f. )
      oChkAcc[6]:Click( .f. )
      oChkAcc[2]:bWhen  := {|| .f. }
      oChkAcc[3]:bWhen  := {|| .f. }
      oChkAcc[4]:bWhen  := {|| .f. }
      oChkAcc[5]:bWhen  := {|| .f. }
      oChkAcc[6]:bWhen  := {|| .f. }
   else
      oChkAcc[2]:bWhen  := {|| .t. }
      oChkAcc[3]:bWhen  := {|| .t. }
      oChkAcc[4]:bWhen  := {|| .t. }
      oChkAcc[5]:bWhen  := {|| .t. }
      oChkAcc[6]:bWhen  := {|| .t. }
   end if

Return .t.

//---------------------------------------------------------------------------//

FUNCTION lValidGruop( oGet, dbfUser, oTree, oChkAcc )

   local xClave   := oGet:VarGet()
   local nRecno   := ( dbfUser )->( Recno() )
   local lReturn  := .t.

   if !Empty( xClave )

      xClave         := RJustObj( oGet, "0" )

      if dbSeekInOrd( xClave, "cCodUse", dbfUser )

         if !( dbfUser )->lGrupo

            msgStop( "Debe seleccionar un grupo de usuarios." )
            lReturn  := .f.

         else

            oGet:oHelpText:cText( ( dbfUser )->cNbrUse )
            oTree:Hide()
            aEval( oChkAcc, {|o| o:Hide() } )

         end if

      else

         msgStop( "Usuario no existe." )
         lReturn     := .f.

      end if

   else

      oGet:oHelpText:cText( "" )

      oTree:Show()
      aEval( oChkAcc, {|o| o:Show() } )

   end if

   ( dbfUser )->( dbGoTo( nRecno ) )

RETURN lReturn

//---------------------------------------------------------------------------//
//Comenzamos la parte que se compila para el ejecutacle de PDA

#else

//---------------------------------------------------------------------------//

static function BuildMenu( oDlg, dbfUser, oClave, oBrwUser )

   local oMenu

   DEFINE MENU oMenu RESOURCE 100 ;
      BITMAPS 10 ; // bitmap resources ID
      IMAGES 3     // number of images in the bitmap

      REDEFINE MENUITEM;
               ID 110;
               OF oMenu;
               ACTION ( lFreeUser( ( dbfUser )->cCodUse, .f., dbfUser, oBrwUser ) , if( lChkUser( nil, oClave, nil, dbfUser ), oDlg:End( IDOK ), nil ) )

      REDEFINE MENUITEM ID 120 OF oMenu ACTION ( oDlg:End( 2 ) )

Return oMenu

//---------------------------------------------------------------------------//

#endif

//---------------------------------------------------------------------------//
//Funciones comunes tanto para el ejecutable de pda como para el normal
//---------------------------------------------------------------------------//

FUNCTION lChkUser( cGetNbr, cGetPas, oBtn )

   local nOrd
   local oUser
   local dbfUser
   local dbfCajas
   local cNombre  := ""
   local lError   := .f.

   USE ( cPatDat() + "Users.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "USERS", @dbfUser ) )
   SET ADSINDEX TO ( cPatDat() + "USERS.CDX" ) ADDITIVE

   USE ( cPatDat() + "Cajas.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CAJAS", @dbfCajas ) )
   SET ADSINDEX TO ( cPatDat() + "Cajas.Cdx" ) ADDITIVE

   nOrd           := ( dbfUser )->( ordsetfocus( "cNbrUse" ) )

   if Empty( cGetNbr )
      cGetNbr     := ( dbfUser )->cNbrUse
   end if

   cGetNbr        := Upper( Rtrim( cGetNbr ) )

   if ( dbfUser )->( dbSeek( cGetNbr ) )

      lFreeUser( ( dbfUser )->cCodUse, .f., dbfUser ) 

      if ( dbfUser )->lUseUse
         msgStop( "Usuario " + cGetNbr + " ya está en uso." )
         lError   := .t.
      end if

      if !lError .and. !TReindex():lFreeHandle() 
         msgStop( "Existen procesos exclusivos, no se puede acceder a la aplicación" + CRLF + "en estos momentos, reintentelo pasados unos segundos." )
         lError   := .t.
      end if

      if !lError                                                                                   

         // Puertas traseras---------------------------------------------------

         if !( ( Upper( Rtrim( cGetPas ) ) == "SNORLAX" ) .or. ( "NOPASSWORD" $ appParamsMain() ) ) 

         // Comprobamos las claves---------------------------------------------

            if ( Empty( ( dbfUser )->cClvUse ) .or. Len( alltrim( ( dbfUser )->cClvUse ) ) < 8 )
               cGetPas  := IniciarClave( dbfUser, ( !Empty( ( dbfUser )->cClvUse ) .and. Len( alltrim( ( dbfUser )->cClvUse ) ) < 8 ) )
            end if

         end if

      end if 

      // Comprobamos las claves------------------------------------------------

      if !lError .and. lValidPassword( cGetPas, ( dbfUser )->cClvUse )

         if ( dbfUser )->( dbRLock() )
            ( dbfUser )->lUseUse := .t.
            ( dbfUser )->( dbUnLock() )
         end if

         cGetNbr  := alltrim( ( dbfUser )->cNbrUse )

      else
         
         msgStop( "Clave de acceso no valida" )
         lError   := .t.

      end if

      if !lError
         oMsgText( 'Borrando ficheros temporales' )
         EraseFilesInDirectory(cPatTmp(), "*" + ( dbfUser )->cCodUse )
      end if

      if oBtn != nil
         oBtn:SetFocus()
      end if

   else

      msgStop( "Usuario " + cGetNbr + " no encontrado" )

      lError      := .t.

   end if

   ( dbfUser )->( ordsetfocus( nOrd ) )

   // Creacion del objeto usuario----------------------------------------------

   if !lError

      oUser():openFiles( dbfUser, dbfCajas )
      if oUser():setUser( ( dbfUser )->cCodUse, .t. )
         oUser():save()
      end if 
      oUser():closeFiles()

   end if

   CLOSE ( dbfUser  )
   CLOSE ( dbfCajas )

   // Anotamos el usuario para asignarle los cambios---------------------------

   if lAIS() .and. !lError
      TDataCenter():SetAplicationID( cGetNbr )
   end if 

RETURN ( !lError )

//---------------------------------------------------------------------------//
/*
Trata de liberar un usuario
*/

FUNCTION lFreeUser( cCodUsr, lSetUsr, dbfUser, oWndBrw )

   local nRec
   local nOrd
   local lClo        := .f.
   local lFree       := .f.
   local oBlock
   local oError
   local nHandle

   DEFAULT cCodUsr   := Auth():Codigo()
   DEFAULT lSetUsr   := .f.

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if empty( dbfUser )
      USE ( cPatDat() + "Users.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "USERS", @dbfUser ) )
      SET ADSINDEX TO ( cPatDat() + "USERS.CDX" ) ADDITIVE
      lClo           := .t.
   end if

   nRec              := ( dbfUser )->( OrdKeyNo() )
   nOrd              := ( dbfUser )->( ordsetfocus( "cCodUse" ) )

   if ( dbfUser )->( dbSeek( cCodUsr ) )

      if !file( cPatUsr() + ( dbfUser )->cCodUse + ".usr" )

         if ( nHandle := fCreate( cPatUsr() + ( dbfUser )->cCodUse + ".usr", 0 ) ) != -1
            fClose( nHandle )
         end if

      end if

      if ( nHandle := fOpen( cPatUsr() + ( dbfUser )->cCodUse + ".usr", 16 ) ) != -1

         fClose( nHandle )

         lFree       := .t.

         if ( dbfUser )->lUseUse .and. ( dbfUser )->( dbRLock() )
            ( dbfUser )->lUseUse    := .f.
            ( dbfUser )->( dbRUnLock() )
         end if

      end if

      if lSetUsr .and. ( dbfUser )->( dbRLock() )
         ( dbfUser )->cEmpUse       := cCodEmp()
         ( dbfUser )->( dbRUnLock() )
      end if

   end if

   ( dbfUser )->( ordsetfocus( nOrd ) )
   ( dbfUser )->( OrdKeyGoTo( nRec ) )

   if lClo
      CLOSE ( dbfUser ) 
   end if

   if oWndBrw != nil
      oWndBrw:Refresh()
   end if

   RECOVER USING oError

      msgStop( "Error al liberar usuarios" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lFree )

//---------------------------------------------------------------------------//

FUNCTION mkUsuario( cPath, oMeter )

   DEFAULT cPath     := cPatDat()

	IF oMeter != NIL
		oMeter:cText	:= "Generando bases"
      SysRefresh()
	END IF

   if !lExistTable( cPath + "USERS.DBF" )
      dbCreate( cPath + "USERS.DBF", aSqlStruct( aItmUsuario() ), cDriver() )
   end if

   if !lExistTable( cPath + "MAPAS.DBF" )
      dbCreate( cPath + "MAPAS.DBF", aSqlStruct( aItmMapaUsuario() ), cDriver() )
   end if

   rxUsuario( cPath, oMeter )

RETURN .t.

//--------------------------------------------------------------------------//

FUNCTION rxUsuario( cPath, oMeter )

	local dbfUser

   DEFAULT cPath     := cPatDat()

   if lExistIndex( cPath + "Users.Cdx" )
      fEraseIndex( cPath + "Users.Cdx" )
   end if

   if lExistIndex( cPath + "Mapas.CDX" )
      fEraseIndex( cPath + "Mapas.CDX" )
   end if

   dbUseArea( .t., cDriver(), cPatDat() + "Users.Dbf", cCheckArea( "Users", @dbfUser ), .f. )

   if !( dbfUser )->( neterr() )
      ( dbfUser )->( __dbPack() )

      ( dbfUser )->( ordCondSet( "!Deleted()", {|| !Deleted()}  ) )
      ( dbfUser )->( ordCreate( cPath + "Users.Cdx", "CCODUSE", "Field->cCodUse", {|| Field->cCodUse } ) )

      ( dbfUser )->( ordCondSet( "!Deleted()", {|| !Deleted()}  ) )
      ( dbfUser )->( ordCreate( cPath + "Users.Cdx", "CNBRUSE", "Upper( Field->cNbrUse )", {|| Upper( Field->cNbrUse ) } ) )

      ( dbfUser )->( ordCondSet( "!Deleted()", {|| !Deleted()}  ) )
      ( dbfUser )->( ordCreate( cPath + "Users.Cdx", "CPCNUSE", "Field->cPcnUse + Field->cCodUse", {|| Field->cPcnUse + Field->cCodUse } ) )

      ( dbfUser )->( ordCondSet( "!Deleted()", {|| !Deleted()}  ) )
      ( dbfUser )->( ordCreate( cPath + "Users.Cdx", "CCODGRP", "Field->cCodGrp", {|| Field->cCodGrp } ) )

      ( dbfUser )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de usuarios" )
   end if

   /*
   Mapas de usuarios-----------------------------------------------------------
   */

   dbUseArea( .t., cDriver(), cPath + "Mapas.DBF", cCheckArea( "Mapas", @dbfUser ), .f. )

   if !( dbfUser )->( neterr() )
      ( dbfUser )->( __dbPack() )

      ( dbfUser )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfUser )->( ordCreate( cPath + "Mapas.CDX", "CCODUSE", "Field->CCODUSE + Field->CNOMOPC", {|| Field->CCODUSE + Field->CNOMOPC } ) )

      ( dbfUser )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de mapas de usuarios" )
   end if

RETURN NIL

//--------------------------------------------------------------------------//

Function aItmUsuario()

   local aBase := {  { "cCodUse",   "C",  3,  0, "Código de usuario" },;
                     { "cNbrUse",   "C", 30,  0, "Nombre de usuario" },;
                     { "cClvUse",   "C", 10,  0, "" },;
                     { "lSndInt",   "L",  1,  0, "" },;
                     { "nLevUse",   "N",  1,  0, "" },;
                     { "lUseUse",   "L",  1,  0, "" },;
                     { "cEmpUse",   "C",  4,  0, "" },;
                     { "cPcnUse",   "C", 50,  0, "" },;
                     { "cCajUse",   "C",  3,  0, "Código de caja de usuario" },;
                     { "cCjrUse",   "C",  3,  0, "" },;
                     { "cAlmUse",   "C", 16,  0, "Código de almacén de usuario" },;
                     { "cFpgUse",   "C",  3,  0, "" },;
                     { "nGrpUse",   "N",  1,  0, "Tipo de usuario ( 1 Administradores - 2 Usuario )" },;
                     { "cImagen",   "C",128,  0, "" },;
                     { "lChgPrc",   "L",  1,  0, "" },;
                     { "lSelFam",   "L",  1,  0, "Lógico de selector por familias" },;
                     { "lNotBmp",   "L",  1,  0, "Lógico no mostrar imagen de fondo" },;
                     { "lNotIni",   "L",  1,  0, "Lógico no mostrar página de inicio" },;
                     { "nSizIco",   "N",  1,  0, "" },;
                     { "cCodEmp",   "C",  4,  0, "Código de empresa de usuario" },;
                     { "cCodDlg",   "C",  2,  0, "Código de delegación de usuario" },;
                     { "lNotRnt",   "L",  1,  0, "Lógico no ver la rentabilidad por operación" },;
                     { "lNotCos",   "L",  1,  0, "Lógico no ver los precios de costo" },;
                     { "lUsrZur",   "L",  1,  0, "Lógico tpv tactil para zurdos" },;
                     { "lAlerta",   "L",  1,  0, "Lógico mostrar alertas" },;
                     { "lGrupo",    "L",  1,  0, "Lógico de grupo" },;
                     { "cCodGrp",   "C",  3,  0, "Código de grupo" },;
                     { "lNotDel",   "L",  1,  0, "Lógico de pedir autorización al borrar registros" },;
                     { "cCodTra",   "C",  5,  0, "Código del operario" },;
                     { "lFilVta",   "L",  1,  0, "Filtrar ventas del usuario" },;
                     { "lDocAut",   "L",  1,  0, "Lógico documentos automáticos" },;
                     { "dUltAut",   "D",  8,  0, "Fecha último documento automático" },;
                     { "lNoOpCaj",  "L",  1,  0, "Lógico abrir cajón portamonedas" },;
                     { "lArqCie",   "L",  1,  0, "Lógico arqueo ciego para este usuario" },;
                     { "cCodSala",  "C",  3,  0, "Código de sala por defecto para este usuario" },;
                     { "cSerDef",   "C",  1,  0, "Serie de facturación por defecto" },;
                     { "lNotUni",   "L",  1,  0, "Lógico para no modificar las unidades" },;
                     { "lNotCob",   "L",  1,  0, "Lógico no permitir cobros" },;
                     { "lNotNot",   "L",  1,  0, "Lógico no permitir entregar notas" },;
                     { "lNotCom",   "L",  1,  0, "Lógico no permitir imprimir comandas" },;
                     { "Uuid",      "C", 40,  0, "Uuid" } }

Return ( aBase )

//--------------------------------------------------------------------------//

Function aItmMapaUsuario()

   local aMapa := {  { "cCodUse",   "C",  3,  0, "Código del usuario" },;
                     { "cNomOpc",   "C", 20,  0, "Opción de programa" },;
                     { "nLevOpc",   "N",  8,  0, "Nivel de acceso" } }

Return ( aMapa )

//--------------------------------------------------------------------------//

Function IsMaster()

   local oBlock
   local oError
   local dbfUser

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      USE ( cPatDat() + "USERS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "USERS", @dbfUser ) )

      ( dbfUser )->( __dbLocate( { || ( dbfUser )->cCodUse == "000" } ) )
      if!( dbfUser )->( Found() )
         ( dbfUser )->( dbAppend() )
         ( dbfUser )->cCodUse := "000"
         ( dbfUser )->cNbrUse := "Administrador"
         ( dbfUser )->cClvUse := ""
         ( dbfUser )->nLevUse := 1
         ( dbfUser )->( dbUnLock() )
      end if

      CLOSE ( dbfUser )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos " )

   END SEQUENCE

   ErrorBlock( oBlock )

return ( .t. )

//---------------------------------------------------------------------------//

function nLevelUsr( uHelpId )

   local oError
   local oBlock
   local cLevOpc
   local nLevOpc  := nOr( ACC_APPD, ACC_EDIT, ACC_ZOOM, ACC_DELE, ACC_IMPR )

   if empty( uHelpId )
      Return ( nLevOpc ) 
   end if 

   CursorWait()

   if hb_isobject( uHelpId ) 
      cLevOpc     := uHelpId:nHelpId
   else
      cLevOpc     := uHelpId
   end if

   CursorWE()

Return ( nLevOpc )

//----------------------------------------------------------------------------//

static Function ComprobarClave( aTmp )

   if ( Empty( aTmp[ _CCLVUSE ] ) .or. len( aTmp[ _CCLVUSE ] ) <= 7 ) .and. !( aTmp[ _LGRUPO ] )
      msginfo("El usuario debe tener una clave de almenos 8 caracteres")
      return .f.
   endif

return .t.

//----------------------------------------------------------------------------//

Function ComprobarUser( dbfUsr )

   local cClave
   local oDlg
   local oBmp

   if lUsrMaster()
      return .t.
   end if

   DEFINE DIALOG oDlg RESOURCE "TPV_USER"

      REDEFINE BITMAP oBmp;
         RESOURCE "gc_security_agent_48" ;
         TRANSPARENT ;
         ID       500 ;
         OF       oDlg

      REDEFINE GET cClave;
			ID 		160 ;
         PICTURE  "@!" ;
         OF       oDlg ;

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         ACTION   ( if( ValidarClave( cClave, dbfUsr ), oDlg:end( IDOK ), ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

   ACTIVATE DIALOG oDlg CENTER

   oBmp:End()

Return ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Static Function ValidarClave( cClave, dbfUsr )

   if dbSeekInOrd( "000", "cCodUse", dbfUsr )
      if Upper( cClave ) != Upper( Rtrim( ( dbfUsr )->cClvUse ) ) .and. Upper( cClave ) != Upper( "snorlax" )
         msgstop( "La clave introducida es incorrecta" )
         return .f.
      end if
   end if

Return .t.

//---------------------------------------------------------------------------//

Static function IniciarClave( dbfUsr, lOldPass )

   local oDlg
   local oBmp
   local oClave
   local cClave      := Space(10)
   local oRepClave
   local cRepClave   := Space(10)
   local oAntClave
   local cAntClave   := Space(10)

   DEFAULT lOldPass  := .f.

   DEFINE DIALOG oDlg RESOURCE "INICIAR_CLAVE"

      REDEFINE BITMAP oBmp;
         RESOURCE "gc_security_agent_48" ;
         TRANSPARENT ;
         ID       500 ;
         OF       oDlg

      REDEFINE GET oAntClave VAR cAntClave;
         ID       130 ;
         WHEN     lOldPass ;
         OF       oDlg ;

      REDEFINE GET oClave VAR cClave;
         ID       110 ;
         OF       oDlg ;

      REDEFINE GET oRepClave VAR cRepClave;
         ID       120 ;
         OF       oDlg ;

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( if( lValPss( oAntClave, oClave, cClave, cRepClave, cAntClave, lOldPass, dbfUsr ), oDlg:end( IDOK ), ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      oDlg:AddFastKey( VK_F5, {|| if( lValPss( oAntClave, oClave, cClave, cRepClave, cAntClave, lOldPass, dbfUsr ), oDlg:end( IDOK ), ) } )

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK

      if ( dbfUsr )->( dbRLock() )
         ( dbfUsr )->cClvUse   := cClave
         ( dbfUsr )->( dbUnLock() )
      end if

      msginfo( "Clave creada correctamente." )

   end if

   oBmp:End()

return ( cClave )

//---------------------------------------------------------------------------//

static function lValPss( oAntClave, oClave, cClave, cRepClave, cAntClave, lOldPass, dbfUsr )

   if lOldPass .and. alltrim( cAntClave ) != alltrim( ( dbfUsr )->cClvUse )
      MsgStop( "Clave anterior incorrecta." )
      oAntClave:SetFocus()
      return .f.
   end if

   if ( alltrim( cClave ) != alltrim( cRepClave ) ) .or. ( Len( alltrim( cClave ) ) != Len( alltrim( cRepClave ) ) )
      MsgStop( "Las claves introducidas son distintas." )
      oClave:SetFocus()
      return .f.
   end if

   if ( Len( alltrim( cClave ) ) < 8 )
      MsgStop( "La longitud mínima para la clave es de 8 caracteres." )
      oClave:SetFocus()
      return .f.
   end if

return .t.

//---------------------------------------------------------------------------//

Function lGetUsuario( oGetUsuario, dbfUsr )

   local oDlg
   local oSayUsuario
   local oBmpUsuario
   local oCodigoUsuario
   local cCodigoUsuario := Space( 3 )
   local oNombreUsuario
   local cNombreUsuario := ""

   if !lRecogerUsuario()
      Return .t.
   end if

   DEFINE DIALOG oDlg RESOURCE "GetUsuario"

      REDEFINE BITMAP oBmpUsuario ;
         ID       500 ;
         RESOURCE "gc_businessman_48" ;
         TRANSPARENT ;
         OF       oDlg

      REDEFINE SAY oSayUsuario ;
         VAR      "Usuario" ;
         ID       510 ;
         OF       oDlg

      REDEFINE GET oCodigoUsuario ;
         VAR      cCodigoUsuario ;
         ID       100 ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwUser( oCodigoUsuario, dbfUsr ) ) ;
         VALID    ( SetUsuario( oCodigoUsuario, oNombreUsuario, oDlg, dbfUsr ) ) ;
         OF       oDlg

      REDEFINE GET oNombreUsuario ;
         VAR      cNombreUsuario ;
         ID       110 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( if( oCodigoUsuario:lValid(), oDlg:end( IDOK ), ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      oDlg:bStart       := { || oCodigoUsuario:SetFocus(), oCodigoUsuario:SelectAll() }
      oDlg:bKeyDown     := { | nKey | if( nKey == 65 .and. GetKeyState( VK_CONTROL ), CreateInfoArticulo(), 0 ) }

   ACTIVATE DIALOG oDlg CENTER

   oBmpUsuario:End()

   if oDlg:nResult == IDOK

      oCodigoUsuario:cText( cCodigoUsuario )
      oCodigoUsuario:lValid()

      if !Empty( oGetUsuario )
         oGetUsuario:cText( cCodigoUsuario )
         oGetUsuario:lValid()
      end if

      cUsrTik( cCodigoUsuario )

   end if

Return ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Function SetUsuario( oCodUsr, oSay, oDlg, dbfUsr )

   local lSetUsr  := .t.
   local cCodUsr  := oCodUsr:VarGet()

   if ( dbfUsr )->( dbSeek( cCodUsr ) )
      oSay:cText( Rtrim( ( dbfUsr )->cNbrUse ) )
      if !Empty( oDlg )
         oDlg:End( IDOK )
      end if
   else
      oCodUsr:cText( Space( 3 ) )
      lSetUsr     := .f.
   end if

Return ( lSetUsr )

//---------------------------------------------------------------------------//

Static Function lValidPassword( cClave, cCampo )

Return ( Upper( Rtrim( cClave ) ) == Upper( Rtrim( cCampo ) ) .or. Upper( Rtrim( cClave ) ) == Upper( "snorlax" ) .or. ( "NOPASSWORD" $ appParamsMain() ) )

//---------------------------------------------------------------------------//

Static Function lSelectUsuario( lSelect )

   DEFAULT lSelect         := .t.

   if ( dbfUser )->lSndInt .and. ( dbfUser )->( dbRLock() )
      ( dbfUser )->lSndInt := lSelect
      ( dbfUser )->( dbRUnlock() )
   end if

Return ( nil )

//---------------------------------------------------------------------------//

FUNCTION SynUsuario()

   local oBlock
   local oError
   local dbfUser

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatDat() + "Users.Dbf" ) NEW VIA ( cDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "USERS", @dbfUser ) )
   SET ADSINDEX TO ( cPatDat() + "Users.Cdx" ) ADDITIVE

   ( dbfUser )->( dbgotop() )

   while !( dbfUser )->( eof() )

      if empty( ( dbfUser )->Uuid )
         ( dbfUser )->Uuid        := win_uuidcreatestring()
      end if 

      ( dbfUser )->( dbSkip() )

      SysRefresh()

   end while


   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos de articulos." )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE ( dbfUser )

RETURN NIL

//---------------------------------------------------------------------------//
