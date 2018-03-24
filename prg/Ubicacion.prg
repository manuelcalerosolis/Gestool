#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

static oWndBrw
static dbfUbicaT
static dbfUbicaL
static dbfTmpUbiL
static cTmpUbiLin
static bEdit      := { |aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode | EdtRec( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode ) }
static bEdtDet    := { |aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, cCodArt | EdtDet( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, cCodArt ) }

//----------------------------------------------------------------------------//
// Abre las bases de datos necesarias

STATIC FUNCTION OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      USE ( cPatAlm() + "UBICAT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "UBICAT", @dbfUbicaT ) )
      SET ADSINDEX TO ( cPatAlm() + "UBICAT.CDX" ) ADDITIVE

      USE ( cPatAlm() + "UBICAL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "UBICAL", @dbfUbicaL ) )
      SET ADSINDEX TO ( cPatAlm() + "UBICAL.CDX" ) ADDITIVE

   RECOVER

      lOpen          := .f.

      CloseFiles()

      msgStop( "Imposible abrir todas las bases de datos" )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles()
//Cierra las bases de datos

   if dbfUbicaT != nil
      ( dbfUbicaT )->( dbCloseArea() )
   end if
   if dbfUbicaL != nil
      ( dbfUbicaL )->( dbCloseArea() )
   end if

   dbfUbicaT  := nil
   dbfUbicaL  := nil
   oWndBrw    := nil

RETURN .T.

//----------------------------------------------------------------------------//
/*
Monta el Brws principal de ubicaciones
*/

FUNCTION Ubicacion( oMenuItem, oWnd )

   local nLevel

   DEFAULT  oMenuItem   := "01088"
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

      AddMnuNext( "Ubicaciones de almacenes", ProcName() )

   DEFINE SHELL oWndBrw FROM 2, 10 TO 18, 70 ;
      XBROWSE ;
      TITLE    "Ubicaciones de almacenes" ;
      MRU      "gc_forklift_16";
      BITMAP   clrTopAlmacenes ;
      ALIAS    ( dbfUbicaT ) ;
      APPEND   ( WinAppRec( oWndBrw:oBrw, bEdit, dbfUbicaT ) ) ;
      EDIT     ( WinEdtRec( oWndBrw:oBrw, bEdit, dbfUbicaT ) ) ;
      DELETE   ( WinDelRec( oWndBrw:oBrw, dbfUbicaT, {|| QuiUbi( dbfUbicaT ) } ) ) ;
      DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdit, dbfUbicaT ) ) ;
      LEVEL    nLevel ;
      OF       oWnd

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodUbi"
         :bEditValue       := {|| ( dbfUbicaT )->cCodUbi }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomUbi"
         :bEditValue       := {|| ( dbfUbicaT )->cNomUbi }
         :nWidth           := 280
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      oWndBrw:cHtmlHelp    := "Ubicaciones de almacónes"

      oWndBrw:CreateXFromCode()

      DEFINE BTNSHELL RESOURCE "BUS" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:SearchSetFocus() ) ;
			TOOLTIP 	"(B)uscar" ;
         HOTKEY   "B"

      oWndBrw:AddSeaBar()

      DEFINE BTNSHELL RESOURCE "NEW" OF oWndBrw ;
			NOBORDER ;
      	ACTION  	( oWndBrw:RecAdd() );
			ON DROP	( oWndBrw:RecDup() );
			TOOLTIP 	"(A)ñadir";
         BEGIN GROUP;
         HOTKEY   "A";
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
         ACTION   ( WinZooRec( oWndBrw:oBrw, bEdit, dbfUbicaT ) );
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

#ifndef __TACTIL__

      DEFINE BTNSHELL RESOURCE "IMP" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( InfUbi():New( "Listado de ubicaciones" ):Play() );
         TOOLTIP  "(L)istado";
         MRU ;
         HOTKEY   "L";
         LEVEL    ACC_DELE

#endif

      DEFINE BTNSHELL RESOURCE "END" GROUP OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:end() ) ;
			TOOLTIP 	"(S)alir" ;
			HOTKEY 	"S"

		ACTIVATE WINDOW oWndBrw VALID ( CloseFiles() )

	ELSE

		oWndBrw:SetFocus()

	END IF

RETURN NIL

//----------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aTmp, aGet, dbfUbicaT, oBrw, bWhen, bValid, nMode )

   local oDlg

   BeginTrans( aTmp, nMode, ( dbfUbicaT )->cCodUbi )

   DEFINE DIALOG oDlg RESOURCE "UBICACION" TITLE LblTitle( nMode ) + "ubicaciones"

      REDEFINE GET aGet[ ( dbfUbicaT )->( FieldPos( "cCodUbi" ) ) ] ;
         VAR      aTmp[ ( dbfUbicaT )->( FieldPos( "cCodUbi" ) ) ] ;
         UPDATE ;
			ID 		100 ;
         WHEN     ( nMode == APPD_MODE ) ;
         VALID    ( NotValid( aGet[ ( dbfUbicaT )->( FieldPos( "cCodUbi" ) ) ], dbfUbicaT ) ) ;
			PICTURE 	"@!" ;
			OF 		oDlg

      REDEFINE GET aGet[ ( dbfUbicaT )->( FieldPos( "cNomUbi" ) ) ] ;
         VAR      aTmp[ ( dbfUbicaT )->( FieldPos( "cNomUbi" ) ) ] ;
         ID       110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:nMarqueeStyle   := 6

      oBrw:cAlias          := dbfTmpUbiL

      oBrw:CreateFromResource( 120 )

      with object ( oBrw:addCol() )
         :cHeader       := "Código"
         :bStrData      := {|| ( dbfTmpUbiL )->cUbiLin }
         :nWidth        := 80
      end with

      with object ( oBrw:addCol() )
         :cHeader       := "Nombre"
         :bStrData      := {|| ( dbfTmpUbiL )->cNomUbiL }
         :nWidth        := 180
      end with

      if ( nMode != ZOOM_MODE )
         oBrw:bLDblClick   := {|| WinEdtRec( oBrw, bEdtDet, dbfTmpUbiL ) }
      end if

      REDEFINE BUTTON ;
			ID 		500 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( WinAppRec( oBrw, bEdtDet, dbfTmpUbiL ) )

      REDEFINE BUTTON ;
			ID 		501 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( WinEdtRec( oBrw, bEdtDet, dbfTmpUbiL ) )

      REDEFINE BUTTON ;
			ID 		502 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( WinDelRec( oBrw, dbfTmpUbiL ) )

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( EndTrans( aTmp, aGet, dbfUbicaT, nMode, oDlg ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      REDEFINE BUTTON ;
         ID       559 ;
			OF 		oDlg ;
         ACTION   ( ChmHelp( "Ubicaciones" ) )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F2, {|| WinAppRec( oBrw, bEdtDet, dbfTmpUbiL ), oBrw:refresh() } )
      oDlg:AddFastKey( VK_F3, {|| WinEdtRec( oBrw, bEdtDet, dbfTmpUbiL ), oBrw:refresh() } )
      oDlg:AddFastKey( VK_F4, {|| DelDet(), oBrw:refresh() } )
      oDlg:AddFastKey( VK_F5, {|| if( nMode == DUPL_MODE, if( aGet[ ( dbfUbicaT )->( FieldPos( "cCodUbi" ) ) ]:lValid(), EndTrans( aTmp, aGet, dbfUbicaT, nMode, oDlg ), ), EndTrans( aTmp, aGet, dbfUbicaT, nMode, oDlg ) ) } )
   end if

   oDlg:AddFastKey ( VK_F1, {|| ChmHelp( "Ubicaciones" ) } )

   oDlg:bStart := {|| aGet[ ( dbfUbicaT )->( FieldPos( "cCodUbi" ) ) ]:SetFocus() }

   ACTIVATE DIALOG oDlg CENTER

   KillTrans()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

STATIC FUNCTION BeginTrans( aTmp, nMode, cCodUbi )

   local nOrdAnt

   cTmpUbiLin         := cGetNewFileName( cPatTmp() + "TmpUbiLin" )

   dbCreate( cTmpUbiLin, aSqlStruct( aItmUbiLin() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cTmpUbiLin, cCheckArea( "TmpUbiLin", @dbfTmpUbiL ), .f. )

   if !( dbfTmpUbiL )->( neterr() )
      ( dbfTmpUbiL )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmpUbiL )->( OrdCreate( cTmpUbiLin, "CCODUBI", "cCodUbi", {|| Field->cCodUbi } ) )

      nOrdAnt := ( dbfUbicaL )->( OrdSetFocus( 2 ) )

      ( dbfUbicaL )->( dbGoTop() )
      if nMode != APPD_MODE .and. ( dbfUbicaL )->( dbSeek( cCodUbi ) )
         while ( dbfUbicaL )->cCodUbi == cCodUbi .and. !( dbfUbicaL )->( eof() )
            dbPass( dbfUbicaL, dbfTmpUbiL, .t. )
            ( dbfUbicaL )->( dbSkip() )
         end while
      end if

      ( dbfTmpUbiL )->( dbGoTop() )
      ( dbfUbicaL )->( OrdSetFocus( nOrdAnt ) )
      ( dbfUbicaL )->( dbGoTop() )

   end if

RETURN .t.

//---------------------------------------------------------------------------//

Function aItmUbiLin()

   local aBase := {}

   aAdd( aBase, { "CCODUBI",   "C",  5, 0, "Código ubicación" }    )
   aAdd( aBase, { "CUBILIN",   "C",  5, 0, "Código de línea de ubicación" }   )
   aAdd( aBase, { "CNOMUBIL",  "C", 30, 0, "Nombre de línea de ubicación" }   )

return ( aBase )

//---------------------------------------------------------------------------//

Function aItmUbi()

   local aItmUbi  := {}

   aAdd( aItmUbi, { "CCODUBI",   "C",  5, 0, "Código ubicación" } )
   aAdd( aItmUbi, { "CNOMUBI",   "C", 35, 0, "Nombre ubicación" } )

Return ( aItmUbi )

//---------------------------------------------------------------------------//

STATIC FUNCTION EndTrans( aTmp, aGet, dbfUbicaT, nMode, oDlg )

   local oError
   local oBlock
   local nOrdAnt

   if nMode == APPD_MODE

      if Empty( aTmp[ ( dbfUbicaT )->( FieldPos( "cCodUbi" ) ) ] )
         MsgStop( "El código de la ubicación no puede estas vacío" )
         aGet[ ( dbfUbicaT )->( FieldPos( "cCodUbi" ) ) ]:SetFocus()
         Return nil
      end if

      if dbSeekInOrd( aTmp[ ( dbfUbicaT )->( FieldPos( "cCodUbi" ) ) ], "CCODUBI", dbfUbicaT )
         MsgStop( "Código ya existe " + Rtrim( aTmp[ ( dbfUbicaT )->( FieldPos( "cCodUbi" ) ) ] ) )
         return nil
      end if

   end if

   if Empty( aTmp[ ( dbfUbicaT )->( FieldPos( "cNomUbi" ) ) ] )
      MsgStop( "El nombre de la ubicación no puede estas vacío" )
      aGet[ ( dbfUbicaT )->( FieldPos( "cNomUbi" ) ) ]:SetFocus()
      Return nil
   end if

   oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   BeginTransaction()

   nOrdAnt := ( dbfUbicaL )->( OrdSetFocus( 2 ) )
   ( dbfUbicaL )->( dbGoTop() )

   if ( dbfUbicaL )->( dbSeek( aTmp[ ( dbfUbicaT )->( FieldPos( "cCodUbi" ) ) ] ) )

      while ( dbfUbicaL )->cCodUbi == aTmp[ ( dbfUbicaT )->( FieldPos( "cCodUbi" ) ) ] .and. !( dbfUbicaL )->( eof() )
         if dbLock( dbfUbicaL )
               ( dbfUbicaL )->( dbDelete() )
               ( dbfUbicaL )->( dbUnLock() )
         end if
      ( dbfUbicaL )->( dbSkip() )
      end while

   end if

   ( dbfTmpUbiL )->( dbGoTop() )
   while !( dbfTmpUbiL )->( eof() )
      ( dbfUbicaL )->( dbAppend() )
      ( dbfUbicaL )->cCodUbi   := aTmp[ ( dbfUbicaT )->( FieldPos( "cCodUbi" ) ) ]
      ( dbfUbicaL )->cUbiLin   := ( dbfTmpUbiL )->cUbiLin
      ( dbfUbicaL )->cNomUbiL  := ( dbfTmpUbiL )->cNomUbiL
      ( dbfUbicaL )->( dbUnLock() )
   ( dbfTmpUbiL )->( dbSkip() )
   end while

   WinGather( aTmp, aGet, dbfUbicaT, nil, nMode )

   ( dbfUbicaL )->( OrdSetFocus( nOrdAnt ) )
   ( dbfUbicaL )->( dbGoTop() )
   ( dbfUbicaT )->( dbGoTop() )

   CommitTransaction()

   RECOVER USING oError

      RollBackTransaction()
      msgStop( "Imposible eliminar datos anteriores" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE
   ErrorBlock( oBlock )

RETURN ( oDlg:end( IDOK ) )

//---------------------------------------------------------------------------//

STATIC FUNCTION KillTrans()

   if !Empty( dbfTmpUbiL ) .and. ( dbfTmpUbiL )->( Used() )
      ( dbfTmpUbiL )->( dbCloseArea() )
   end if

   dbfTmpUbiL  := nil

   dbfErase( cTmpUbiLin )

RETURN nil

//---------------------------------------------------------------------------//

STATIC FUNCTION EdtDet( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, cCodArt )

   local oDlg

   DEFINE DIALOG oDlg RESOURCE "UBIDET" TITLE LblTitle( nMode ) + "ubicación"

      REDEFINE GET aGet[ ( dbfUbicaL )->( FieldPos( "cUbiLin" ) ) ];
         VAR      aTmp[ ( dbfUbicaL )->( FieldPos( "cUbiLin" ) ) ];
         UPDATE ;
			ID 		100 ;
         VALID    ( !Empty( aTmp[ ( dbfUbicaL )->( FieldPos( "cUbiLin" ) ) ] ) ) ;
         WHEN     ( nMode == APPD_MODE ) ;
			PICTURE 	"@!" ;
			OF 		oDlg

      REDEFINE GET aGet[ ( dbfUbicaL )->( FieldPos( "cNomUbiL" ) ) ] ;
         VAR       aTmp[ ( dbfUbicaL )->( FieldPos( "cNomUbiL" ) ) ] ;
         UPDATE ;
			ID 		110 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			PICTURE 	"@!" ;
			OF 		oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( WinGather( aTmp, aGet, dbfTmpUbiL, oBrw, nMode ), oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

     REDEFINE BUTTON ;
         ID       9 ;
			OF 		oDlg ;
         ACTION   ( ChmHelp( "Ubicaciones" ) )

    if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| if( aGet[ ( dbfUbicaL )->( FieldPos( "cUbiLin" ) ) ]:lValid(), ( WinGather( aTmp, aGet, dbfTmpUbiL, oBrw, nMode ), oDlg:end( IDOK ) ), ) } )
   end if

   oDlg:AddFastKey ( VK_F1, {|| ChmHelp( "Ubicaciones" ) } )

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

FUNCTION mkUbi( cPath, lAppend, cPathOld, oMeter )

   local dbfUbicaT
   local dbfUbicaL

   DEFAULT cPath     := cPatAlm()
	DEFAULT lAppend	:= .F.

   if !lExistTable( cPath + "UbiCat.Dbf" )
      dbCreate( cPath + "UbiCat.Dbf", aSqlStruct( aItmUbi() ), cDriver() )
   end if

   if !lExistTable( cPath + "UbiCal.Dbf" )
      dbCreate( cPath + "UbiCal.Dbf", aSqlStruct( aItmUbiLin() ), cDriver() )
   end if

   if lAppend .and. lIsDir( cPathOld )
      appDbf( cPathOld, cPath, "UbiCat" )
      appDbf( cPathOld, cPath, "UbiCal" )
   end if

   rxUbi( cPath, oMeter )

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION rxUbi( cPath, oMeter )

   local dbfUbi

   DEFAULT cPath := cPatAlm()

   IF !lExistTable( cPath + "UBICAT.DBF" ) .or. !lExistTable( cPath + "UBICAL.DBF" )
      mkUbi( cPath )
   END IF

   fEraseIndex( cPath + "UBICAT.CDX" )
   fEraseIndex( cPath + "UBICAL.CDX" )

   if lExistTable( cPath + "UBICAT.DBF" )
      
      dbUseArea( .t., cDriver(), cPath + "UBICAT.DBF", cCheckArea( "UBICAT", @dbfUbi ), .f. )

      if !( dbfUbi )->( neterr() )
         ( dbfUbi )->( __dbPack() )

         ( dbfUbi )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
         ( dbfUbi )->( ordCreate( cPath + "UBICAT.CDX", "CCODUBI", "Field->cCodUbi", {|| Field->cCodUbi } ) )

         ( dbfUbi )->( dbCloseArea() )
      else
         msgStop( "Imposible abrir en modo exclusivo las cabeceras de ubicaiones" )
      end if

   end if

   if lExistTable( cPath + "UBICAL.DBF" )
      
      dbUseArea( .t., cDriver(), cPath + "UBICAL.DBF", cCheckArea( "UBICAL", @dbfUbi ), .f. )

      if !( dbfUbi )->( neterr() )
         ( dbfUbi )->( __dbPack() )

         ( dbfUbi )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
         ( dbfUbi )->( ordCreate( cPath + "UBICAL.CDX", "CUBILIN", "Field->cCodUbi + Field->cUbiLin", {|| Field->cCodUbi + Field->cUbiLin } ) )

         ( dbfUbi )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
         ( dbfUbi )->( ordCreate( cPath + "UBICAL.CDX", "CCODUBI", "Field->cCodUbi", {|| Field->cCodUbi } ) )

         ( dbfUbi )->( dbCloseArea() )
      else
         msgStop( "Imposible abrir en modo exclusivo las líneas de ubicaciones." )
      end if

   end if

RETURN NIL

//---------------------------------------------------------------------------//
//
// Elimina una ubicación
//

Static Function QuiUbi( dbfUbicaT )

   local nOrdAnt  := ( dbfUbicaL )->( OrdSetFocus( "cCodUbi" ) )

   while ( dbfUbicaL )->( dbSeek( ( dbfUbicaT )->cCodUbi ) )
      if dbLock( dbfUbicaL )
         ( dbfUbicaL )->( dbDelete() )
         ( dbfUbicaL )->( dbUnLock() )
      end if
   end while

   ( dbfUbicaL )->( OrdSetFocus( nOrdAnt ) )
   ( dbfUbicaL )->( dbGoTop() )

Return .t.

//---------------------------------------------------------------------------//

Static Function DelDet()

   if SQLAjustableModel():getRolNoConfirmacionEliminacion( Auth():rolUuid() ) .or. ApoloMsgNoYes( "¿Desea eliminar el registro en curso?", "Confirme supresión" )

      if dbLock( dbfTmpUbiL )
         ( dbfTmpUbiL )->( dbDelete() )
         ( dbfTmpUbiL )->( dbUnLock() )
      end if

   end if

Return .t.

//---------------------------------------------------------------------------//

FUNCTION BrwUbicacion( oGet, dbfUbicaT, oGet2 )

	local oDlg
	local oBrw
	local oGet1
	local cGet1
   local nOrdAnt        := 1  //GetBrwOpt( "BrwUbicacion" )
	local oCbxOrd
   local aCbxOrd        := { "Código" }
   local cCbxOrd
   local nRec           := ( dbfUbicaT )->( RecNo() )

   nOrdAnt              := Min( Max( nOrdAnt, 1 ), len( aCbxOrd ) )
   cCbxOrd              := aCbxOrd[ nOrdAnt ]

   nOrdAnt  := ( dbfUbicaT )->( OrdSetFocus( nOrdAnt ) )

   ( dbfUbicaT )->( DbGoTop() )

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Seleccionar ubicación"

   REDEFINE GET oGet1 VAR cGet1;
      ID       104 ;
      ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfUbicaT ) );
      VALID    ( OrdClearScope( oBrw, dbfUbicaT ) );
      BITMAP   "FIND" ;
      OF       oDlg

   REDEFINE COMBOBOX oCbxOrd ;
      VAR      cCbxOrd ;
      ID       102 ;
      ITEMS    aCbxOrd ;
      ON CHANGE( ( dbfUbicaT )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:refresh(), oGet1:SetFocus() ) ;
      OF       oDlg

   oBrw                 := IXBrowse():New( oDlg )

   oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   oBrw:cAlias          := dbfUbicaT
   oBrw:nMarqueeStyle   := 5

   oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }

   oBrw:CreateFromResource( 105 )

   with object ( oBrw:AddCol() )
      :cHeader          := "Código"
      :bEditValue       := {|| ( dbfUbicaT )->cCodUbi }
      :nWidth           := 80
   end with

   with object ( oBrw:AddCol() )
      :cHeader          := "Nombre"
      :bEditValue       := {|| ( dbfUbicaT )->cNomUbi }
      :nWidth           := 400
   end with

   REDEFINE BUTTON ;
      ID       500 ;
      OF       oDlg ;
      WHEN     .f. ;
      ACTION   ( nil )

   REDEFINE BUTTON ;
      ID       501 ;
      OF       oDlg ;
      WHEN     .f. ;
      ACTION   ( nil )

   REDEFINE BUTTON ;
      ID       IDOK ;
      OF       oDlg ;
      ACTION   ( oDlg:end(IDOK) )

   REDEFINE BUTTON ;
      ID       IDCANCEL ;
      OF       oDlg ;
      ACTION   ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| oDlg:end( IDOK ) } )
   oDlg:AddFastKey( VK_RETURN, {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

   IF oDlg:nResult == IDOK

      oGet:cText( ( dbfUbicaT )->cCodUbi )
      oGet:lValid()

      IF ValType( oGet2 ) == "O"
         oGet2:cText( ( dbfUbicaT )->cNomUbi )
      END IF

   END IF

   DestroyFastFilter( dbfUbicaT )

   SetBrwOpt( "BrwUbicacion", ( dbfUbicaT )->( OrdNumber() ) )

   ( dbfUbicaT )->( OrdSetFocus( nOrdAnt ) )
   ( dbfUbicaT )->( dbGoTo( nRec ) )

   oGet:setFocus()

RETURN ( .T. )

//---------------------------------------------------------------------------//

FUNCTION BrwUbiLin( oGet, oGet2, cCodUbi, dbfUbicaL )

	local oDlg
	local oBrw
	local oGet1
	local cGet1
   local nOrdAnt        := 1  //GetBrwOpt( "BrwUbicacionLin" )
	local oCbxOrd
   local aCbxOrd        := { "Código" }
   local cCbxOrd        := aCbxOrd[ nOrdAnt ]
   local dbfTmpBrw
   local cTmpBrw
   local nOrdTmp

   nOrdAnt              := Min( Max( nOrdAnt, 1 ), len( aCbxOrd ) )
   cCbxOrd              := aCbxOrd[ nOrdAnt ]

   //Creacion de una dbf temporal

   cTmpBrw         := cGetNewFileName( cPatTmp() + "TmpBrw" )

   dbCreate( cTmpBrw, aSqlStruct( aItmTmpBrw() ), cDriver() )
   dbUseArea( .t., cDriver(), cTmpBrw, cCheckArea( "TmpBrw", @dbfTmpBrw ), .f. )
   if !( dbfTmpBrw )->( neterr() )
      ( dbfTmpBrw )->( OrdCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfTmpBrw )->( OrdCreate( cTmpBrw, "CUBILIN", "cUbiLin", {|| Field->cUbiLin } ) )
   end if

   nOrdTmp := ( dbfUbicaL )->( OrdSetFocus( 2 ) )
   ( dbfUbicaL )->( dbGoTop() )
   if ( dbfUbicaL )->( dbSeek( cCodUbi ) )
      while ( dbfUbicaL )->cCodUbi == cCodUbi .and. !( dbfUbicaL )->( eof() )
         ( dbfTmpBrw )->( dbAppend() )
         ( dbfTmpBrw )->cUbiLin  := ( dbfUbicaL )->cUbiLin
         ( dbfTmpBrw )->cNomUbiL := ( dbfUbicaL )->cNomUbiL
         ( dbfTmpBrw )->( dbUnLock() )
         ( dbfUbicaL )->( dbSkip() )
      end while
   end if
   ( dbfTmpBrw )->( dbGoTop() )
   ( dbfUbicaL )->( OrdSetFocus( nOrdTmp ) )
   ( dbfUbicaL )->( dbGoTop() )

   nOrdAnt  := ( dbfTmpBrw )->( OrdSetFocus( nOrdAnt ) )

   ( dbfTmpBrw )->( dbGoTop() )

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Seleccionar ubicación"

   REDEFINE GET oGet1 VAR cGet1;
      ID       104 ;
      ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfTmpBrw ) );
      VALID    ( OrdClearScope( oBrw, dbfTmpBrw ) );
      BITMAP   "FIND" ;
      OF       oDlg

   REDEFINE COMBOBOX oCbxOrd ;
      VAR      cCbxOrd ;
      ID       102 ;
      ITEMS    aCbxOrd ;
      ON CHANGE( ( dbfTmpBrw )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:refresh(), oGet1:SetFocus() ) ;
      OF       oDlg

   oBrw                 := IXBrowse():New( oDlg )

   oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   oBrw:cAlias          := dbfTmpBrw
   oBrw:nMarqueeStyle   := 5

   oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }

   oBrw:CreateFromResource( 105 )

   with object ( oBrw:AddCol() )
      :cHeader          := "Código"
      :bEditValue       := {|| ( dbfTmpBrw )->cUbiLin }
      :nWidth           := 80
   end with

   with object ( oBrw:AddCol() )
      :cHeader          := "Nombre"
      :bEditValue       := {|| ( dbfTmpBrw )->cNomUbiL }
      :nWidth           := 400
   end with

   REDEFINE BUTTON ;
      ID       500 ;
      OF       oDlg ;
      WHEN     .f. ;
      ACTION   ( nil )

   REDEFINE BUTTON ;
      ID       501 ;
      OF       oDlg ;
      WHEN     .f. ;
      ACTION   ( nil )

   REDEFINE BUTTON ;
      ID       IDOK ;
      OF       oDlg ;
      ACTION   ( oDlg:end(IDOK) )

   REDEFINE BUTTON ;
      ID       IDCANCEL ;
      OF       oDlg ;
      ACTION   ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| oDlg:end(IDOK) } )
   oDlg:AddFastKey( VK_RETURN, {|| oDlg:end(IDOK) } )

   ACTIVATE DIALOG oDlg CENTER

   IF oDlg:nResult == IDOK

      oGet:cText( ( dbfTmpBrw )->cUbiLin )
      oGet:lValid()

      IF ValType( oGet2 ) == "O"
         oGet2:cText( ( dbfTmpBrw )->cNomUbiL )
      END IF

   END IF

   DestroyFastFilter( dbfTmpBrw )

   SetBrwOpt( "BrwUbicacionLin", ( dbfTmpBrw )->( OrdNumber() ) )

   CloseFiles()

   oGet:setFocus()

   if !Empty( dbfTmpBrw ) .and. ( dbfTmpBrw )->( Used() )
      ( dbfTmpBrw )->( dbCloseArea() )
   end if

   dbfTmpBrw  := nil

   dbfErase( cTmpBrw )

RETURN ( .T. )

//---------------------------------------------------------------------------//

Static Function aItmTmpBrw()

   local aBase := {}

   aAdd( aBase, { "CUBILIN",   "C",  5, 0, "Código de línea de ubicación" }   )
   aAdd( aBase, { "CNOMUBIL",  "C", 30, 0, "Nombre de línea de ubicación" }   )

return ( aBase )

//---------------------------------------------------------------------------//

FUNCTION cUbica( oGet, dbfUbiT, oGet2 )

   local lValid   := .f.
   local xValor   := oGet:VarGet()

   if Empty( xValor )
      if( oGet2 != nil, oGet2:cText( "" ), )
      return .t.
   end if

   do case
      case Valtype( dbfUbiT ) == "C"

         if ( dbfUbiT )->( dbSeek( xValor ) )
            oGet:cText( ( dbfUbiT )->cCodUbi )
            if( oGet2 != nil, oGet2:cText( ( dbfUbiT )->cNomUbi ), )
            lValid   := .t.
         else
            oGet:Refresh()
            msgStop( "Ubicación no encontrada" )
         end if

      case Valtype( dbfUbiT ) == "O"

         if dbfUbiT:Seek( xValor )
            oGet:cText( dbfUbiT:cCodUbi )
            if( oGet2 != nil, oGet2:cText( dbfUbiT:cNomUbi ), )
            lValid   := .t.
         else
            oGet:Refresh()
            msgStop( "Ubicación no encontrada" )
         end if

   end case

RETURN lValid

//---------------------------------------------------------------------------//

FUNCTION cUbicaLin( oGet, oGet2, cCodUbi, dbfUbicaL )

   local lValid   := .f.
   local xValor   := oGet:VarGet()

   if Empty( xValor )
      if( oGet2 != nil, oGet2:cText( "" ), )
      return .t.
   end if

   if dbSeekInOrd( cCodUbi + xValor, "CUBILIN", dbfUbicaL )
      oGet:cText( ( dbfUbicaL )->cUbiLin )
      if( oGet2 != nil, oGet2:cText( ( dbfUbicaL )->cNomUbiL ), )
      lValid   := .t.
   else
      oGet:Refresh()
      oGet:SetFocus()
      msgStop( "Ubicación no encontrada" )
   end if

RETURN lValid

//---------------------------------------------------------------------------//