#ifndef __PDA__
#include "FiveWin.Ch"   
#include "Font.ch"
#include "Report.ch"
#include "Factu.ch" 
#else
#include "FWCE.ch"
REQUEST DBFCDX
#endif   

#ifndef __PDA__

#define _CCODALM                   1      //   C      3     0
#define _CNOMALM                   2      //   C     20     0
#define _CDIRALM                   3      //   C     50     0
#define _CPOSALM                   4      //   C      7     0
#define _CPOBALM                   5      //   C     30     0
#define _CPROALM                   6      //   C     20     0
#define _CTFNALM                   7      //   C     12     0
#define _CFAXALM                   8      //   C     12     0
#define _CPERALM                   9      //   C     50     0
#define _CCODCLI                   10     //   C     14     0
#define _CCOMALM                   11

static bEdit   := { |aTemp, aoGet, dbfAlmT, oBrw, bWhen, bValid, nMode | EdtRec( aTemp, aoGet, dbfAlmT, oBrw, bWhen, bValid, nMode ) }
static bEdit2  := { |aTemp, aoGet, dbfAlmL, oBrw, bWhen, bValid, nMode, cCodAlm | EdtDet( aTemp, aoGet, dbfAlmL, oBrw, bWhen, bValid, nMode, cCodAlm ) }

#endif

static oWndBrw

static dbfAlmT
static dbfAlmL
static dbfAgent
static dbfTmp

static cNewFile

static oTreePadre

//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//

#ifndef __PDA__

FUNCTION Almacen( oMenuItem, oWnd )

   local nLevel

   DEFAULT  oMenuItem   := "01035"
   DEFAULT  oWnd        := oWnd()

	IF oWndBrw == NIL

      /*
      Obtenemos el nivel de acceso
      */

      nLevel            := Auth():Level( oMenuItem )
      if nAnd( nLevel, 1 ) == 0
         msgStop( "Acceso no permitido." )
         RETURN nil
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

      if !lOpenFiles()
         RETURN nil
      end if

      /*
      Anotamos el movimiento para el navegador
      */

      AddMnuNext( "Almacen", ProcName() )

      DEFINE SHELL oWndBrw FROM 2, 10 TO 18, 70;
      XBROWSE ;
      TITLE    "Almacén" ;
      PROMPT   "Código",;
					"Nombre";
      MRU      "gc_package_16";
      BITMAP   clrTopAlmacenes ;
		ALIAS		( dbfAlmT ) ;
      APPEND   ( WinAppRec( oWndBrw:oBrw, bEdit, dbfAlmT ) );
      DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdit, dbfAlmT ) );
		EDIT 		( WinEdtRec( oWndBrw:oBrw, bEdit, dbfAlmT ) ) ;
		DELETE   ( DBDelRec(  oWndBrw:oBrw, dbfAlmT ) ) ;
      LEVEL    nLevel ;
		OF 		oWnd

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodAlm"
         :bEditValue       := {|| ( dbfAlmT )->cCodAlm }
         :nWidth           := 120
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomAlm"
         :bEditValue       := {|| ( dbfAlmT )->cNomAlm }
         :nWidth           := 280
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Domicilio"
         :bEditValue       := {|| ( dbfAlmT )->cDirAlm }
         :nWidth           := 280
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código postal"
         :bEditValue       := {|| ( dbfAlmT )->cPosAlm }
         :nWidth           := 60
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Población"
         :bEditValue       := {|| ( dbfAlmT )->cPobAlm }
         :nWidth           := 180
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Provincia"
         :bEditValue       := {|| ( dbfAlmT )->cProAlm }
         :nWidth           := 140
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Padre"
         :bEditValue       := {|| ( dbfAlmT )->cComAlm }
         :nWidth           := 120
         :lHide            := .f.
      end with

      oWndBrw:cHtmlHelp    := "Almacen"

      oWndBrw:CreateXFromCode()

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
         HOTKEY   "D" ;
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
			ACTION  	( WinZooRec( oWndBrw:oBrw, bEdit, dbfAlmT ) );
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

      DEFINE BTNSHELL RESOURCE "IMP" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( InfAlm():New( "Listado de almacenes" ):Play() ) ;
         TOOLTIP  "(L)istado" ;
         HOTKEY   "L";
         LEVEL    ACC_IMPR

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

STATIC FUNCTION EdtRec( aTemp, aoGet, dbfAlmT, oBrw, bWhen, bValid, nMode )

	local oDlg
   local oGet
   local oGet2
	local oBrw2
   local cCodCli
   local oCodCli
   local oFld
   local oBmpGeneral

	BeginTrans( aTemp )

   DEFINE DIALOG oDlg RESOURCE "ALMACEN" TITLE LblTitle( nMode ) + "Almacén"

      REDEFINE FOLDER oFld;
         ID       100 ;
         OF       oDlg ;
         PROMPT   "&General",;
                  "&Facturación y agentes";
         DIALOGS  "ALMACEN_01",;
                  "ALMACEN_02";

      REDEFINE BITMAP oBmpGeneral ;
        ID       990 ;
        RESOURCE "gc_package_48" ;
        TRANSPARENT ;
        OF       oFld:aDialogs[1]

      REDEFINE BITMAP oBmpGeneral ;
        ID       990 ;
        RESOURCE "gc_businessman2_48" ;
        TRANSPARENT ;
        OF       oFld:aDialogs[2]

      REDEFINE GET oGet VAR aTemp[ _CCODALM ];
         ID       100 ;
         PICTURE  "@!" ;
         WHEN     ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) ;
         VALID    ( NotValid( oGet, dbfAlmT, .f. ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oGet2 VAR aTemp[ _CNOMALM ];
         ID       110   ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

		REDEFINE GET aTemp[ _CDIRALM ];
         ID       120 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@!" ;
         OF       oFld:aDialogs[1]

		REDEFINE GET aTemp[ _CPOSALM ];
         ID       130 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

		REDEFINE GET aTemp[ _CPOBALM ];
         ID       140 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

		REDEFINE GET aTemp[ _CPROALM ];
         ID       150 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

		REDEFINE GET aTemp[ _CTFNALM ];
         ID       160 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@R ##########" ;
         OF       oFld:aDialogs[1]

		REDEFINE GET aTemp[ _CFAXALM ];
         ID       170 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@R ##########" ;
         OF       oFld:aDialogs[1]

		REDEFINE GET aTemp[ _CPERALM ];
         ID       180;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      // Tree de los almacenes padre-------------------------------------------

      oTreePadre                     := TTreeView():Redefine( 200, oFld:aDialogs[1] )
      oTreePadre:bItemSelectChanged  := {|| ChangeTreeState() }

      // Segunda caja de dialogo-----------------------------------------------

      REDEFINE GET aoGet[ _CCODCLI ] VAR aTemp[ _CCODCLI ];
         ID       190;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cClient( aoGet[ _CCODCLI ], , oCodCli ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwClient( aoGet[ _CCODCLI ], oCodCli ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET oCodCli VAR cCodCli ;
         WHEN     .F. ;
         ID       200 ;
         OF       oFld:aDialogs[2]

      oBrw2                := IXBrowse():New( oFld:aDialogs[2] )

      oBrw2:bClrSel        := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw2:bClrSelFocus   := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw2:cAlias         := dbfTmp
      oBrw2:nMarqueeStyle  := 5

      with object ( oBrw2:AddCol() )
         :cHeader          := "Código"
         :bEditValue       := {|| ( dbfTmp )->cCodAge }
         :nWidth           := 120
      end with

      with object ( oBrw2:AddCol() )
         :cHeader          := "Agente"
         :bEditValue       := {|| RetNbrAge( ( dbfTmp )->cCodAge, dbfAgent ) }
         :nWidth           := 550
      end with

      oBrw2:bLDblClick     := {|| oDlg:end( IDOK ) }

      oBrw2:CreateFromResource( 210 )

      if nMode != ZOOM_MODE
         oBrw2:bLDblClick  := {|| EdtDeta( oBrw2, bEdit2, aTemp ) }
      end if

      REDEFINE BUTTON ;
			ID 		500 ;
         OF       oFld:aDialogs[2] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			ACTION 	( AppDeta( oBrw2, bEdit2, aTemp) )

      REDEFINE BUTTON ;
			ID 		501 ;
         OF       oFld:aDialogs[2] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			ACTION 	( EdtDeta( oBrw2, bEdit2, aTemp ) )

      REDEFINE BUTTON ;
			ID 		502 ;
         OF       oFld:aDialogs[2] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			ACTION 	( DelDeta( oBrw2, aTemp ) )

		REDEFINE BUTTON ;
			ID 		524 ;
         OF       oFld:aDialogs[2] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			ACTION 	( DbSwapUp( dbfTmp, oBrw2 ) )

		REDEFINE BUTTON ;
			ID 		525 ;
         OF       oFld:aDialogs[2] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			ACTION 	( DbSwapDown( dbfTmp, oBrw2 ) )

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( EndTrans( aTemp, aoGet, dbfAlmT, oBrw, nMode, oDlg, oGet, oGet2 ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      if nMode != ZOOM_MODE
         oFld:aDialogs[2]:AddFastKey( VK_F2, {|| AppDeta( oBrw2, bEdit2, aTemp) } )
         oFld:aDialogs[2]:AddFastKey( VK_F3, {|| EdtDeta( oBrw2, bEdit2, aTemp ) } )
         oFld:aDialogs[2]:AddFastKey( VK_F4, {|| DelDeta( oBrw2, aTemp ) } )
         oDlg:AddFastKey( VK_F5, {|| if( nMode == DUPL_MODE, if( oGet:lValid(), EndTrans( aTemp, aoGet, dbfAlmT, oBrw, nMode, oDlg, oGet, oGet2 ), ), EndTrans( aTemp, aoGet, dbfAlmT, oBrw, nMode, oDlg, oGet, oGet2 ) ) } )
      end if

   oDlg:bStart    := {|| StartEdtRec( aTemp ) }

	ACTIVATE DIALOG oDlg	ON PAINT ( EvalGet( aoGet ) ) CENTER

   /*
	Borramos los ficheros-------------------------------------------------------
	*/

   oBmpGeneral:End()

   KillTrans( oBrw2 )

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Static Function StartEdtRec( aTemp )

   LoadTree()  

   SetTreeState( , , aTemp[ _CCOMALM ] )

RETURN nil

//---------------------------------------------------------------------------//

Static Function BeginTrans( aTemp )

   local cDbf     := "TAlmL"
	local cCodAlm	:= aTemp[ ( dbfAlmT )->( FieldPos( "CCODALM" ) ) ]

   cNewFile       := cGetNewFileName( cPatTmp() + cDbf )

	/*
	Primero Crear la base de datos local
	*/

   dbCreate( cNewFile, aSqlStruct( aItmAlmAgente() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cNewFile, cCheckArea( cDbf, @dbfTmp ), .f. )

   if !( dbfTmp )->( neterr() )
      ( dbfTmp )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmp )->( OrdCreate( cNewFile, "Recno", "Str( Recno() )", {|| Str( Recno() ) } ) )

      /*
      A¤adimos desde el fichero de lineas--------------------------------------
      */

      if ( dbfAlmL )->( dbSeek( cCodAlm ) )

         while ( ( dbfAlmL )->CCODALM == cCodAlm .AND. !( dbfAlmL )->( Eof() ) )
            dbPass( dbfAlmL, dbfTmp, .t. )
            ( dbfAlmL )->( DbSkip() )
         end while

      end if

      ( dbfTmp )->( dbGoTop() )

   end if

RETURN nil

//-----------------------------------------------------------------------//

/*
Funcion Auxiliar para A¤adir lineas de detalle
*/

STATIC FUNCTION AppDeta( oBrw, bEdit2, aTemp )

RETURN WinAppRec( oBrw, bEdit2, dbfTmp, , , aTemp[(dbfAlmT)->( FieldPos( "CCODALM" ) )] )

//--------------------------------------------------------------------------//

/*
Funcion Auxiliar para la Edici¢n de Lineas de Detalle
*/

STATIC FUNCTION EdtDeta( oBrw, bEdit2, aTemp )

RETURN WinEdtRec( oBrw, bEdit2, dbfTmp )

//--------------------------------------------------------------------------//

/*
Funcion Auxiliar para borrar las Lineas de Detalle
*/

STATIC FUNCTION DelDeta( oBrw )

RETURN DBDelRec( oBrw, dbfTmp )

//--------------------------------------------------------------------------//

STATIC FUNCTION EndTrans( aTemp, aoGet, dbfAlmT, oBrw, nMode, oDlg, oGet, oGet2 )

   local oError
   local oBlock
   local aTabla
   local cCodAlm  := aTemp[ ( dbfAlmT )->( FieldPos( "CCODALM" ) ) ]

   if nMode == APPD_MODE .or. nMode == DUPL_MODE

      if Empty( aTemp[ _CCODALM ] )
         MsgStop( "El código del almacén no puede estar vacío." )
         oGet:SetFocus()
         RETURN nil
      end if

      if dbSeekInOrd( aTemp[ _CCODALM ], "CCODALM", dbfAlmT )
         MsgStop( "Código ya existe " + Rtrim( aTemp[ _CCODALM ] ) )
         RETURN nil
      end if

   end if

   if Empty( aTemp[ _CNOMALM ] )
      MsgStop( "El nombre del almacén no puede estar vacío." )
      oGet2:SetFocus()
      RETURN nil
   end if

   // Relaciones entre almacenes-----------------------------------------------

   aTemp[ _CCOMALM ]        := ""

   GetTreeState( aTemp )

   if ( aTemp[ _CCOMALM ] == aTemp[ _CCODALM ] )
      MsgStop( "Almacén padre no puede ser el mismo" )
      oTreePadre:SetFocus()
      RETURN nil
   end if

   if aScan( aChildAlmacen( aTemp[ _CCODALM ] ), aTemp[ _CCOMALM ] ) != 0
      MsgStop( "Almacén padre contiene referencia circular" )
      oTreePadre:SetFocus()
      RETURN nil
   end if

	/*
   Primero hacer el RollBack---------------------------------------------------
	*/

   CursorWait()

   oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   BeginTransaction()

   oDlg:Disable()

	/*
   Roll Back-------------------------------------------------------------------
	*/

   while ( dbfAlmL )->( dbSeek( cCodAlm ) )
      if ( dbfAlmL )->( dbRLock() )
         ( dbfAlmL )->( dbDelete() )
         ( dbfAlmL )->( dbUnLock() )
      end if
   end while

	/*
   Ahora escribimos en el fichero definitivo------------------------------------
	*/

	( dbfTmp )->( DbGoTop() )
   while ( dbfTmp )->( !Eof() )

      aTabla                                          := DBScatter( dbfTmp )
      aTabla[( dbfAlmL )->( FieldPos( "CCODALM" ) )]  := cCodAlm
		( dbfAlmL )->( dbAppend() )
		DBGather( aTabla, dbfAlmL )
		( dbfTmp )->( dbSkip() )

   end while

   WinGather( aTemp, aoGet, dbfAlmT, oBrw, nMode )

   /*
   Escribe los datos pendientes------------------------------------------------
   */

   dbCommitAll()

   CommitTransaction()

   RECOVER USING oError

      RollBackTransaction()
      msgStop( "Imposible eliminar datos anteriores" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE
   ErrorBlock( oBlock )

   oDlg:Enable()

   oDlg:end( IDOK )

   CursorWe()

RETURN nil

//------------------------------------------------------------------------//

STATIC FUNCTION KillTrans( oBrw2 )

	/*
	Borramos los ficheros
	*/

	( dbfTmp )->( dbCloseArea() )
   dbfErase( cNewFile )

RETURN .T.

//------------------------------------------------------------------------//


STATIC FUNCTION EdtDet( aTemp, aoGet, dbfTmp, oBrw, bWhen, bValid, nMode, cCodAlm )

	local oDlg
	local oGet
	local oGetTxt
	local cGetTxt

	IF nMode == APPD_MODE
		aTemp[ (dbfAlmL)->( FieldPos( "CCODALM" ) ) ] := cCodAlm
	END CASE

   DEFINE DIALOG oDlg RESOURCE "AGEALM" TITLE LblTitle( nMode ) + "Agentes relacionados"

		REDEFINE GET oGet VAR aTemp[ (dbfAlmL)->( FieldPos( "CCODAGE" ) ) ];
			ID 		100 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			VALID 	( cAgentes( oGet, dbfAgent, oGetTxt ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAgentes( oGet, oGetTxt ) ) ;
			COLOR 	CLR_GET ;
			OF 		oDlg

		REDEFINE GET oGetTxt VAR cGetTxt;
			ID 		110 ;
			WHEN 		( .F. ) ;
			COLOR 	CLR_GET ;
			OF 		oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( 	nMode != ZOOM_MODE ) ;
         ACTION   ( lPreSave( aTemp, aoGet, dbfTmp, oBrw, nMode, oDlg, oGet ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| lPreSave( aTemp, aoGet, dbfTmp, oBrw, nMode, oDlg, oGet ) } )
   end if

	ACTIVATE DIALOG oDlg ON PAINT ( oGet:lValid() ) CENTER

RETURN ( oDlg:nResult == IDOK )

//-------------------------------------------------------------------------//

Static Function lPreSave( aTemp, aoGet, dbfTmp, oBrw, nMode, oDlg, oGet )

   if Empty( aTemp[ (dbfAlmL)->( FieldPos( "CCODAGE" ) ) ] )
      MsgStop( "El código del agente no puede estar vacío" )
      oGet:SetFocus()
      RETURN nil
   end if

   WinGather( aTemp, aoGet, dbfTmp, oBrw, nMode )

RETURN ( oDlg:end( IDOK ) )

//-------------------------------------------------------------------------//

FUNCTION RetAlmacen( cCodAlm, dbfAlmT )

   local oBlock
   local oError
	local cAlmacen 	:= ""
   local lClose      := .f.

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

	IF dbfAlmT == NIL
      USE ( cPatEmp() + "ALMACEN.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALMACEN", @dbfAlmT ) )
      SET ADSINDEX TO ( cPatEmp() + "ALMACEN.CDX" ) ADDITIVE
      lClose         := .t.
	END IF

   do case
      case Valtype( dbfAlmT ) == "C"

         if ( dbfAlmT )->( DbSeek( cCodAlm ) )
            cAlmacen       := ( dbfAlmT )->cNomAlm
         end if

      case Valtype( dbfAlmT ) == "O"

         if dbfAlmT:Seek( cCodAlm )
            cAlmacen       := dbfAlmT:cNomAlm
         end if

   end case

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos de almacenes" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

	IF lClose
		CLOSE ( dbfAlmT )
	END IF

RETURN cAlmacen

//--------------------------------------------------------------------------//
/*
Devuelve el cliente de un almacen
*/

FUNCTION RetCliAlm( cCodAlm, dbfAlmT )

   local oBlock
   local oError
	local cAlmacen 	:= ""
   local lClose      := .f.

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if dbfAlmT == nil
      USE ( cPatEmp() + "ALMACEN.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALMACEN", @dbfAlmT ) )
      SET ADSINDEX TO ( cPatEmp() + "ALMACEN.CDX" ) ADDITIVE
      lClose         := .t.
   end if

   if ( dbfAlmT )->( dbSeek( cCodAlm ) )
      cAlmacen       := ( dbfAlmT)->cCodCli
   end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos de agentes" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if lClose
      Close ( dbfAlmT )
   end if

RETURN cAlmacen

//--------------------------------------------------------------------------//

FUNCTION aItmAlm()

   local aItmAlm  := {}

   aAdd( aItmAlm, { "cCodAlm",  "C",     16,     0, "Código de almacen"              ,  "",   "", "( cDbfAlm )" } )
   aAdd( aItmAlm, { "cNomAlm",  "C",    100,     0, "Nombre de almacen"              ,  "",   "", "( cDbfAlm )" } )
   aAdd( aItmAlm, { "cDirAlm",  "C",     50,     0, "Domicilio de almacen"           ,  "",   "", "( cDbfAlm )" } )
   aAdd( aItmAlm, { "cPosAlm",  "C",      7,     0, "Código postal de almacen"       ,  "",   "", "( cDbfAlm )" } )
   aAdd( aItmAlm, { "cPobAlm",  "C",     30,     0, "Población de almacen"           ,  "",   "", "( cDbfAlm )" } )
   aAdd( aItmAlm, { "cProAlm",  "C",     20,     0, "Provincia de almacen"           ,  "",   "", "( cDbfAlm )" } )
   aAdd( aItmAlm, { "cTfnAlm",  "C",     12,     0, "Teléfono de almacen"            ,  "",   "", "( cDbfAlm )" } )
   aAdd( aItmAlm, { "cFaxAlm",  "C",     12,     0, "Fax de almacen"                 ,  "",   "", "( cDbfAlm )" } )
   aAdd( aItmAlm, { "cPerAlm",  "C",     50,     0, "Persona de contacto de almacen" ,  "",   "", "( cDbfAlm )" } )
   aAdd( aItmAlm, { "cCodCli",  "C",     12,     0, "Codigo del cliente"             ,  "",   "", "( cDbfAlm )" } )
   aAdd( aItmAlm, { "cComAlm",  "C",     16,     0, "Código de almacen padre"        ,  "",   "", "( cDbfAlm )" } )
   aAdd( aItmAlm, { "Uuid",     "C",     40,     0, "Uuid"        ,  "",   "", "( cDbfAlm )" } )

RETURN ( aItmAlm )

//---------------------------------------------------------------------------//

Function aItmAlmAgente()

   local aItmAlmAgente  := {}

   aAdd( aItmAlmAgente, { "CCODALM",  "C",     16,     0, "" } )
   aAdd( aItmAlmAgente, { "CCODAGE",  "C",      3,     0, "" } )

RETURN aItmAlmAgente

//---------------------------------------------------------------------------//
//Funcion que devuelve el nombre de la ubicación, diciendole
//el almacen y el número de la ubicación

Function cGetUbica( cCodAlm, dbfAlm, nNumUbica )

   local cNomUbica := ""

RETURN cNomUbica

//---------------------------------------------------------------------------//

Function SelectAlmacen()

   local oDlg
   local oBrw
   local oBmp
   local oGetBuscar
   local cGetBuscar     := Space( 100 )
   local oCbxOrden
   local cCbxOrden      := "Código"

   if !lOpenFiles()
      RETURN .f.
   end if

   DEFINE DIALOG oDlg ;
      RESOURCE    "SelectItem" ;
      TITLE       "Seleccionar almacén" ;

      REDEFINE BITMAP oBmp ;
         RESOURCE "gc_package_48" ;
         TRANSPARENT ;
         ID       300;
         OF       oDlg

      REDEFINE GET oGetBuscar ;
         VAR      cGetBuscar;
         ID       100 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfAlmT, nil, nil, .f. ) );
         BITMAP   "FIND" ;
         OF       oDlg

      REDEFINE COMBOBOX oCbxOrden ;
         VAR      cCbxOrden ;
         ID       110 ;
         ITEMS    { "Código", "Nombre" } ;
         ON CHANGE( ( dbfAlmT )->( OrdSetFocus( oCbxOrden:nAt ) ), oBrw:Refresh(), oGetBuscar:SetFocus() ) ;
			OF 		oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfAlmT
      oBrw:nMarqueeStyle   := 5

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :bEditValue       := {|| ( dbfAlmT )->cCodAlm }
         :cSortOrder       := "cCodAlm"
         :nWidth           := 40
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :bEditValue       := {|| ( dbfAlmT )->cNomAlm }
         :cSortOrder       := "cNomAlm"
         :nWidth           := 200
      end with

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }

      oBrw:CreateFromResource( 200 )

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( oDlg:end( IDOK ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

   oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )
   oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK
      oUser():cAlmacen( ( dbfAlmT )->cCodAlm )
   else
      MsgInfo( "No seleccionó ningún almacén, se establecerá el almacén por defecto." + CRLF + ;
               "Almacén actual, " + oUser():cAlmacen() )
   end if

   CloseFiles()

   if oBmp != nil
      oBmp:End()
   end if

RETURN ( oDlg:nResult == IDOK )

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

RETURN oMenu

//--------------------------------------------------------------------------//

#endif

CLASS pdaAlmacenSenderReciver

   Method CreateData()

END CLASS

//----------------------------------------------------------------------------//

//--------------------------------------------------------------------------//
//Funciones comunes del programa y pda
//--------------------------------------------------------------------------//

Method CreateData( oPgrActual, oSayStatus, cPatPreVenta ) CLASS pdaAlmacenSenderReciver

   local oBlock
   local oError
   local dbfAlm
   local tmpAlm
   local lExist      := .f.
   local cFileName
   local cPatPc      := if( Empty( cPatPreVenta ), cPatPc(), cPatPreVenta )

   USE ( cPatEmp() + "Almacen.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "Almacen", @dbfAlm ) )
   SET ADSINDEX TO ( cPatEmp() + "Almacen.Cdx" ) ADDITIVE

   dbUseArea( .t., cDriver(), cPatPc + "Almacen.Dbf", cCheckArea( "Almacen", @tmpAlm ), .t. )
   ( tmpAlm )->( ordListAdd( cPatPc + "Almacen.Cdx" ) )

   if !Empty( oPgrActual )
      oPgrActual:SetRange( 0, ( tmpAlm )->( OrdKeyCount() ) )
   end if

   ( tmpAlm )->( dbGoTop() )
   while !( tmpAlm )->( eof() )

         if ( dbfAlm )->( dbSeek( ( tmpAlm )->cCodAlm ) )
            dbPass( tmpAlm, dbfAlm, .f. )
         else
            dbPass( tmpAlm, dbfAlm, .t. )
         end if

         ( tmpAlm )->( dbSkip() )

         if !Empty( oSayStatus )
            oSayStatus:SetText( "Sincronizando Almacenes " + Alltrim( Str( ( tmpAlm )->( OrdKeyNo() ) ) ) + " de " + Alltrim( Str( ( tmpAlm )->( OrdKeyCount() ) ) ) )
         end if

      SysRefresh()

      if !Empty( oPgrActual )
         oPgrActual:SetPos( ( tmpAlm )->( OrdKeyNo() ) )
      end if

      SysRefresh()

   end while

   CLOSE ( tmpAlm )
   CLOSE ( dbfAlm )

RETURN ( Self )

function IsAlmacen( cPatEmp )

   local oBlock
   local oError

   local dbfAlmT
   local lIsAlmacen  := .f.

   DEFAULT cPatEmp   := cPatEmp()

   if !lExistTable( cPatEmp + "Almacen.Dbf" ) .or. !lExistTable( cPatEmp + "AlmacenL.Dbf" )
      mkAlmacen()
   end if

   if !lExistIndex( cPatEmp + "Almacen.Cdx" ) .or. !lExistIndex( cPatEmp + "AlmacenL.Cdx" )
      rxAlmacen()
   end if

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatEmp + "ALMACEN.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALMACEN", @dbfAlmT ) )
   SET ADSINDEX TO ( cPatEmp + "ALMACEN.CDX" ) ADDITIVE

   if ( dbfAlmT )->( ordKeyCount() ) == 0
      ( dbfAlmT )->( dbAppend() )
      ( dbfAlmT )->cCodAlm := "000"
      ( dbfAlmT )->cNomAlm := "Almacén principal"
      ( dbfAlmT )->( dbUnLock() )
   end if

   lIsAlmacen        := .t.

   CLOSE( dbfAlmT )

   RECOVER USING oError

      msgStop( "Imposible abrir base de datos de almacenes" + CRLF + ErrorMessage( oError )  )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lIsAlmacen )

//---------------------------------------------------------------------------//

FUNCTION mkAlmacen( cPath, lAppend, cPathOld, oMeter )

   DEFAULT cPath     := cPatEmp()
	DEFAULT lAppend	:= .F.

	IF oMeter != NIL
		oMeter:cText	:= "Generando Bases"
		sysrefresh()
	END IF

   IF !lExistTable( cPath + "ALMACEN.DBF" )
      dbCreate( cPath + "ALMACEN.DBF", aSqlStruct( aItmAlm() ), cDriver() )
	END IF

   IF !lExistTable( cPath + "ALMACENL.DBF" )
      dbCreate( cPath + "ALMACENL.DBF", aSqlStruct( aItmAlmAgente() ), cDriver() )
	END IF

	rxAlmacen( cPath, oMeter )

	IF lAppend .and. lIsDir( cPathOld )
      AppDbf( cPathOld, cPath, "ALMACEN" )
	END IF

	IF lAppend .and. lIsDir( cPathOld )
      AppDbf( cPathOld, cPath, "ALMACENL" )
	END IF

RETURN .t.

//--------------------------------------------------------------------------//

FUNCTION rxAlmacen( cPath, oMeter )

	local dbfAlmT
	local dbfAlmL

   DEFAULT cPath  := cPatEmp()

   IF !lExistTable( cPath + "ALMACEN.DBF" )
      dbCreate( cPath + "ALMACEN.DBF", aSqlStruct( aItmAlm() ), cDriver() )
	END IF

   fEraseIndex( cPath + "ALMACEN.CDX" )

   dbUseArea( .t., cDriver(), cPath + "ALMACEN.DBF", cCheckArea( "ALMACEN", @dbfAlmT ), .f. )

   if !( dbfAlmT )->( neterr() )
      ( dbfAlmT )->( __dbPack() )

      ( dbfAlmT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfAlmT )->( ordCreate( cPath + "ALMACEN.CDX", "CCODALM", "CCODALM", {|| Field->cCodAlm } ) )

      ( dbfAlmT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfAlmT )->( ordCreate( cPath + "ALMACEN.CDX", "CNOMALM", "Upper( CNOMALM )", {|| Upper( Field->cNomAlm ) }, ) )

      ( dbfAlmT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfAlmT )->( ordCreate( cPath + "ALMACEN.CDX", "CCOMALM", "CCOMALM", {|| Field->cComAlm } ) )

      ( dbfAlmT )->( dbeval( {|| Field->uuid := win_uuidcreatestring() }, {|| empty( field->uuid ) } ) )

      ( dbfAlmT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de almacenes" )
   end if

   IF !lExistTable( cPath + "ALMACENL.DBF" )
      dbCreate( cPath + "ALMACENL.DBF", aSqlStruct( aItmAlmAgente() ), cDriver() )
	END IF

   fErase( cPath + "ALMACENL.CDX" )

   dbUseArea( .t., cDriver(), cPath + "ALMACENL.DBF", cCheckArea( "ALMACENL", @dbfAlmL ), .f. )

   if !( dbfAlmL )->( neterr() )
      ( dbfAlmL )->( __dbPack() )

      ( dbfAlmL )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfAlmL )->( ordCreate( cPath + "ALMACENL.CDX", "CCODALM", "CCODALM", {|| Field->cCodAlm } ) )

      ( dbfAlmL )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de almacenes" )
   end if

RETURN NIL

//--------------------------------------------------------------------------//

Function cSeekStoreView( cCodigoAlmacen, nView )

   if dbSeekInOrd( cCodigoAlmacen, "cCodAlm", D():Almacen( nView ) )
      RETURN .t.
   end if 

RETURN ( .f. )

//--------------------------------------------------------------------------//

Function lValidAlmacen( cCodigoAlmacen, dbfAlmacen )

   if !( dbfAlmacen )->( dbSeekInOrd( cCodigoAlmacen, "cCodAlm",  dbfAlmacen ) )
      msgStop( "Almacén no encontrado" )
      RETURN .f.
   end if 

RETURN ( .t. )

//--------------------------------------------------------------------------//

FUNCTION cAlmacen( oGet, dbfAlmT, oGet2 )

   local oBlock
   local oError
   local lClose   := .f.
   local lValid   := .f.
   local xValor   := oGet:VarGet()

   if Empty( xValor ) .or. ( xValor == Replicate( "Z", 16 ) )
      if( oGet2 != nil, oGet2:cText( "" ), )
      RETURN .t.
   end if

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if dbfAlmT == nil
      USE ( cPatEmp() + "ALMACEN.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALMACEN", @dbfAlmT ) )
      SET ADSINDEX TO ( cPatEmp() + "ALMACEN.CDX" ) ADDITIVE
      lClose      := .t.
   end if

   do case
      case Valtype( dbfAlmT ) == "C"

         if ( dbfAlmT )->( dbSeek( xValor ) )
            oGet:cText( ( dbfAlmT )->cCodAlm )
            if( oGet2 != nil, oGet2:cText( ( dbfAlmT )->cNomAlm ), )
            lValid   := .t.
         else
            oGet:Refresh()
            msgStop( "Almacén no encontrado" )
         end if

      case Valtype( dbfAlmT ) == "O"

         if dbfAlmT:Seek( xValor )
            oGet:cText( dbfAlmT:cCodAlm )

            if oGet2 != nil
               oGet2:cText( dbfAlmT:cNomAlm )
            end if

            lValid   := .t.
         else
            oGet:Refresh()
            msgStop( "Almacén no encontrado" )
         end if

   end case

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos de almacenes" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if lClose
      CLOSE ( dbfAlmT )
   end if

RETURN lValid

//---------------------------------------------------------------------------//

FUNCTION BrwAlmacen( oGet, oGet2, lBigStyle )

	local oDlg
	local oBrw
   local oFont
   local oBtn
	local oGet1
	local cGet1
   local nOrdAnt        := GetBrwOpt( "BrwAlmacen" )
	local oCbxOrd
   local aCbxOrd        := { "Código", "Nombre" }
   local cCbxOrd
   local nLevel         := Auth():Level( "01035" )
   local oSayText
   local cSayText       := "Listado de almacenes"
   local cRETURN        := ""

   nOrdAnt              := Min( Max( nOrdAnt, 1 ), len( aCbxOrd ) )
   cCbxOrd              := aCbxOrd[ nOrdAnt ]

   DEFAULT  lBigStyle   := .f.

   if lOpenFiles()

      nOrdAnt           := ( dbfAlmT )->( OrdSetFocus( nOrdAnt ) )

      ( dbfAlmT )->( dbGoTop() )

   if lBigStyle

      DEFINE DIALOG oDlg RESOURCE "BIGHELPENTRY"   TITLE "Seleccionar almacén"

      REDEFINE GET oGet1 VAR cGet1;
         ID       104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfAlmT ) );
         VALID    ( OrdClearScope( oBrw, dbfAlmT ) );
         BITMAP   "FIND" ;
         OF       oDlg

   else

      DEFINE DIALOG oDlg RESOURCE "HELPENTRY"      TITLE "Seleccionar almacén"

      REDEFINE GET oGet1 VAR cGet1;
         ID       104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfAlmT ) );
         VALID    ( OrdClearScope( oBrw, dbfAlmT ) );
         BITMAP   "FIND" ;
         OF       oDlg

   end if

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( ( dbfAlmT )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:refresh(), oGet1:SetFocus(), oCbxOrd:refresh() ) ;
			OF 		oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfAlmT
      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "Browse.Almacen"

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodAlm"
         :bEditValue       := {|| ( dbfAlmT )->cCodAlm }
         :nWidth           := 140
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomAlm"
         :bEditValue       := {|| ( dbfAlmT )->cNomAlm }
         :nWidth           := 280
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Domicilio"
         :cSortOrder       := "cDirAlm"
         :bEditValue       := {|| ( dbfAlmT )->cDirAlm }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }
      oBrw:bRClicked       := {| nRow, nCol, nFlags | oBrw:RButtonDown( nRow, nCol, nFlags ) }

      oBrw:CreateFromResource( 105 )

      if lBigStyle
         oBrw:nHeaderHeight   := 36
         oBrw:nFooterHeight   := 36
         oBrw:nLineHeight     := 36
      end if

      if ( "PDA" $ appParamsMain() )

         REDEFINE SAY oSayText VAR cSayText ;
            ID       100 ;
            OF       oDlg

      end if

		REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         ACTION   ( oDlg:end(IDOK) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      if !( "PDA" $ appParamsMain() )

		REDEFINE BUTTON ;
			ID 		500 ;
			OF 		oDlg ;
         WHEN     ( nAnd( nLevel, ACC_APPD ) != 0 .and. !IsReport() );
         ACTION   ( WinAppRec( oBrw, bEdit, dbfAlmT ) )

		REDEFINE BUTTON ;
			ID 		501 ;
			OF 		oDlg ;
         WHEN     ( nAnd( nLevel, ACC_EDIT ) != 0 .and. !IsReport() );
         ACTION   ( WinEdtRec( oBrw, bEdit, dbfAlmT ) )

      if !IsReport()
         oDlg:AddFastKey( VK_F2,    {|| if( nAnd( nLevel, ACC_APPD ) != 0, WinAppRec( oBrw, bEdit, dbfAlmT ), ) } )
         oDlg:AddFastKey( VK_F3,    {|| if( nAnd( nLevel, ACC_EDIT ) != 0, WinEdtRec( oBrw, bEdit, dbfAlmT ), ) } )
      end if

      end if

      oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end(IDOK) } )
      oDlg:AddFastKey( VK_F5,       {|| oDlg:end(IDOK) } )

      ACTIVATE DIALOG oDlg CENTER

      cRETURN                 := ( dbfAlmT )->cCodAlm

      if oDlg:nResult == IDOK

         if !Empty( oGet )
            oGet:cText( cRETURN )
            oGet:lValid()
         end if

         if !Empty( oGet2 ) .and. ValType( oGet2 ) == "O"
            oGet2:cText( ( dbfAlmT )->cNomAlm )
         end if

      end if

      DestroyFastFilter( dbfAlmT )

      SetBrwOpt( "BrwAlmacen", ( dbfAlmT )->( OrdNumber() ) )

		CloseFiles()

      if !Empty( oGet )
         oGet:setFocus()
      end if

   end if

RETURN ( cRETURN )

//---------------------------------------------------------------------------//

STATIC FUNCTION lOpenFiles()

   local lOpen       := .t.
   local oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      IF !lExistTable( cPatEmp() + "ALMACEN.DBF" ) .OR.;
         !lExistTable( cPatEmp() + "ALMACENL.DBF" )
			mkAlmacen()
		END IF

      USE ( cPatEmp() + "ALMACEN.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALMACEN", @dbfAlmT ) )
      SET ADSINDEX TO ( cPatEmp() + "ALMACEN.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ALMACENL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALMACENL", @dbfAlmL ) )
      SET ADSINDEX TO ( cPatEmp() + "ALMACENL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "AGENTES.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AGENTES", @dbfAgent ) )
      SET ADSINDEX TO ( cPatEmp() + "AGENTES.CDX" ) ADDITIVE

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      CloseFiles()
      lOpen       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN lOpen

//----------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles()

   CLOSE ( dbfAlmT  )
   CLOSE ( dbfAlmL  )
   CLOSE ( dbfAgent )

   dbfAlmT   := nil
   dbfAlmL   := nil
   dbfAgent  := nil

   oWndBrw   := nil

RETURN .t.

//----------------------------------------------------------------------------//
/*
Funcion para editar un almacén desde cualquier parte del programa
*/

FUNCTION EdtAlm( cCodAlm )

   local nLevel         := Auth():Level( "01035" )

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_EDIT ) == 0
      msgStop( 'Acceso no permitido.' )
      RETURN .t.
   end if

   if lOpenFiles()

      if dbSeekInOrd( cCodAlm, "cCodAlm", dbfAlmT )
         WinEdtRec( nil, bEdit, dbfAlmT )
      end if

      CloseFiles()

   end if

RETURN .t.

//---------------------------------------------------------------------------//

static function LoadTree( oTree, cComAlm )

   local nRec
   local nOrd
   local oNode

   DEFAULT oTree     := oTreePadre

   if Empty( cComAlm )
      cComAlm        := Space( 16 )
   end if

   CursorWait()

   nRec              := ( dbfAlmT )->( Recno() )
   nOrd              := ( dbfAlmT )->( OrdSetFocus( "cComAlm" ) )

   if ( dbfAlmT )->( dbSeek( cComAlm ) )

      while ( ( dbfAlmT )->cComAlm == cComAlm .and. !( dbfAlmT )->( Eof() ) )

         oNode       := oTree:Add( Alltrim( ( dbfAlmT )->cNomAlm ) )
         oNode:Cargo := ( dbfAlmT )->cCodAlm

         LoadTree( oNode, ( dbfAlmT )->cCodAlm )

         ( dbfAlmT )->( dbSkip() )

      end while

   end if

   ( dbfAlmT )->( OrdSetFocus( nOrd ) )
   ( dbfAlmT )->( dbGoTo( nRec ) )

   CursorWE()

   oTree:Expand()

RETURN ( .t. )

//---------------------------------------------------------------------------//

static function SetTreeState( oTree, aItems, cComAlm )

   local oItem

   DEFAULT oTree  := oTreePadre

   if Empty( aItems )
      aItems      := oTree:aItems
   end if

   for each oItem in aItems

      if ( cComAlm == oItem:Cargo )

         oTree:Select( oItem )

         // tvSetCheckState( oTree:hWnd, oItem:hItem, .t. )
         oTree:GetCheck( oItem, .t. )

         SysRefresh()

      end if

      if len( oItem:aItems ) > 0
         SetTreeState( oTree, oItem:aItems, cComAlm )
      end if

   next

RETURN ( .t. )

//---------------------------------------------------------------------------//


Static Function ChangeTreeState( oTree, aItems )

   local oItem

   DEFAULT oTree  := oTreePadre

   if Empty( aItems )
      aItems      := oTree:aItems
   end if

   for each oItem in aItems

      SysRefresh()

      // tvSetCheckState( oTree:hWnd, oItem:hItem, .f. )

      oTree:SetCheck( oItem, .f. )

      if len( oItem:aItems ) > 0
         ChangeTreeState( oTree, oItem:aItems )
      end if

   next

RETURN ( .t. )

//---------------------------------------------------------------------------//

Static Function GetTreeState( aTemp, oTree, aItems )

   local oItem

   DEFAULT oTree           := oTreePadre

   if Empty( aItems )
      aItems               := oTree:aItems
   end if

   for each oItem in aItems

      // if tvGetCheckState( oTree:hWnd, oItem:hItem )
      
      if oTree:GetCheck( oItem )
         aTemp[ _CCOMALM ]  := oItem:Cargo
      end if

      if len( oItem:aItems ) > 0
         GetTreeState( aTemp, oTree, oItem:aItems )
      end if

   next

RETURN ( aTemp )

//---------------------------------------------------------------------------//

Function aChildAlmacen( cCodigoAlmacen, aChild, dbfAlmacen )

   local nRec
   local nOrd

   DEFAULT dbfAlmacen   := dbfAlmT
   DEFAULT aChild       := {}

   if empty( dbfAlmacen )
      RETURN ( aChild )
   end if 

   CursorWait()

   nRec                 := ( dbfAlmacen )->( Recno() )
   nOrd                 := ( dbfAlmacen )->( OrdSetFocus( "cComAlm" ) )

   if ( dbfAlmacen )->( dbSeek( cCodigoAlmacen ) )

      while ( ( dbfAlmacen )->cComAlm == cCodigoAlmacen .and. !( dbfAlmacen )->( Eof() ) )

         aAdd( aChild, ( dbfAlmacen )->cCodAlm )

         aChildAlmacen( ( dbfAlmacen )->cCodAlm, aChild, dbfAlmacen )

         ( dbfAlmacen )->( dbSkip() )

      end while

   end if

   ( dbfAlmacen )->( OrdSetFocus( nOrd ) )
   ( dbfAlmacen )->( dbGoTo( nRec ) )

   CursorWE()

RETURN ( aChild )

//---------------------------------------------------------------------------//

Function aAllAlmacen( cCodigoAlmacen, aChild, dbfAlmacen )

   local nRec
   local nOrd

   DEFAULT aChild       := {}
   DEFAULT dbfAlmacen   := dbfAlmT

   CursorWait()

   nRec                 := ( dbfAlmacen )->( recno() )
   nOrd                 := ( dbfAlmacen )->( ordsetfocus( "cCodAlm" ) )

   ( dbfAlmacen )->( dbgotop() )

   while !( dbfAlmacen )->( eof() ) 

      if ascan( aChild, ( dbfAlmacen )->cCodAlm ) == 0
         aadd( aChild, ( dbfAlmacen )->cCodAlm )
      end if 

      ( dbfAlmacen )->( dbskip() )

   end while

   ( dbfAlmacen )->( ordsetfocus( nOrd ) )
   ( dbfAlmacen )->( dbgoto( nRec ) )

   CursorWE()

RETURN ( aChild )

//---------------------------------------------------------------------------//

