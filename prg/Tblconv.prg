#ifndef __PDA__
   #include "FiveWin.Ch"
   #include "Xbrowse.ch"
   #include "Report.ch"
   #include "Font.ch"
#else
   #include "FWCE.ch"
   REQUEST DBFCDX
#endif

#include "Factu.ch" 

/*
Estructura de la base de datos Tabla de conversión
*/

#define _CCODCNV  1           // "C",  2, 0, "Codigo de la tabla de conversión"
#define _CDETCNV  2           // "C", 30, 0, "Detalle de la tabla de conversión"
#define _CUNDSTK  3           // "C",  4, 0, "Literal para unidades de Stocks"
#define _CUNDVTA  4           // "C",  4, 0, "Literal para unidades de Venta"
#define _NFACCNV  5           // "N", 13, 4, "Factor de conversión"

/*
Define las variables estaticas
*/

#ifndef __PDA__

static oWndBrw

static bEdit      := { | aTmp, aGet, dbfTblCnv, oBrw, bWhen, bValid, nMode | EdtRec( aTmp, aGet, dbfTblCnv, oBrw, bWhen, bValid, nMode ) }

#endif

static dbfTblCnv
//---------------------------------------------------------------------------//

#ifndef __PDA__

//---------------------------------------------------------------------------//

static function OpenFiles()

   local lOpen       := .t.
   local oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      IF !lExistTable( cPatDat() + "TBLCNV.DBF" )
         mkTblCnv()
      END IF

      USE ( cPatDat() + "TBLCNV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TBLCNV", @dbfTblCnv ) )
      SET ADSINDEX TO ( cPatDat() + "TBLCNV.CDX" ) ADDITIVE

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

return ( lOpen )

//---------------------------------------------------------------------------//

static function CloseFiles()

   if oWndBrw != nil
      oWndBrw := nil
   end if

   ( dbfTblCnv )->( dbCloseArea() )

return .t.

//---------------------------------------------------------------------------//

function TblCnv( oMenuItem, oWnd )

   local nLevel

   DEFAULT  oMenuItem   := "01016"
   DEFAULT  oWnd        := oWnd()

	IF oWndBrw == NIL

      /*
      Obtenemos el nivel de acceso
      */

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

      /*
      Apertura de ficheros
      */

      if !OpenFiles()
         return nil
      end if

      /*
      Anotamos el movimiento para el navegador
      */

      AddMnuNext( "Factores de conversión", ProcName() )

      DEFINE SHELL oWndBrw FROM 2, 10 TO 18, 70 ;
         XBROWSE ;
         TITLE    "Factores de conversión" ;
         PROMPT   "Código",;
                  "Nombre" ;
         ALIAS    ( dbfTblCnv ) ;
         BITMAP   clrTopArchivos ;
         APPEND   WinAppRec( oWndBrw, bEdit, dbfTblCnv ) ;
         EDIT     WinEdtRec( oWndBrw, bEdit, dbfTblCnv ) ;
         DELETE   WinDelRec( oWndBrw, dbfTblCnv ) ;
         DUPLICAT WinDupRec( oWndBrw, bEdit, dbfTblCnv ) ;
         MRU      "gc_objects_transform_16" ;
         LEVEL    nLevel ;
         OF       oWnd

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodCnv"
         :bEditValue       := {|| ( dbfTblCnv )->cCodCnv }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cDetCnv"
         :bEditValue       := {|| ( dbfTblCnv )->cDetCnv }
         :nWidth           := 200
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Und. compra"
         :bEditValue       := {|| ( dbfTblCnv )->cUndStk }
         :nWidth           := 80
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Und. venta"
         :bEditValue       := {|| ( dbfTblCnv )->cUndVta }
         :nWidth           := 80
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Factor conversión"
         :bEditValue       := {|| Trans( ( dbfTblCnv )->nFacCnv, "@E 999,999.999999" ) }
         :nWidth           := 100
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      oWndBrw:CreateXFromCode()

      DEFINE BTNSHELL RESOURCE "BUS" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:SearchSetFocus() ) ;
         TOOLTIP  "(B)uscar";
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
         MRU ;
         HOTKEY   "D";
         LEVEL    ACC_APPD

		DEFINE BTNSHELL RESOURCE "EDIT" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:RecEdit() );
         TOOLTIP  "(M)odificar";
         HOTKEY   "M" ;
         MRU;
         LEVEL    ACC_EDIT

		DEFINE BTNSHELL RESOURCE "ZOOM" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( WinZooRec( oWndBrw:oBrw, bEdit, dbfTblCnv ) );
         TOOLTIP  "(Z)oom";
         MRU ;
         HOTKEY   "Z";
         LEVEL    ACC_ZOOM

		DEFINE BTNSHELL RESOURCE "DEL" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:RecDel() );
         TOOLTIP  "(E)liminar";
         MRU ;
         HOTKEY   "E";
         LEVEL    ACC_DELE

#ifndef __TACTIL__

      DEFINE BTNSHELL RESOURCE "IMP" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( InfCnv():New( "Listado de factores de conversión" ):Play() ) ;
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
/*
Caja de dialogo para editar la tabla de conversión
*/

static function EdtRec( aTmp, aGet, dbfTblCnv, oBrw, bWhen, bValid, nMode )

   local oDlg

   DEFINE DIALOG oDlg RESOURCE "TBLCNV";
      TITLE   LblTitle( nMode ) + "factores de conversión"  ;
      OF      oBrw

      REDEFINE GET aGet[ _CCODCNV ] VAR aTmp[ _CCODCNV ];
			ID 		110 ;
         WHEN     ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) ;
         VALID    ( NotValid( aGet[ _CCODCNV ], dbfTblCnv ) .and. !Empty( aTmp[ _CCODCNV ] ) ) ;
			COLOR 	CLR_GET ;
			OF 		oDlg

      REDEFINE GET aGet[ _CDETCNV ] VAR aTmp[ _CDETCNV ] ;
			ID 		120 ;
			COLOR 	CLR_GET ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET aTmp[ _CUNDSTK ] ;  // Literal para unidades de Stock
         ID       130 ;
         COLOR    CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg ;

      REDEFINE GET aTmp[ _CUNDVTA ] ;  // Literal para unidades de Venta
         ID       140 ;
         COLOR    CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg ;

      REDEFINE GET aTmp[ _NFACCNV ] ;  // Factor de conversión
         ID       150 ;
         SPINNER ;
         COLOR    CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999,999.999999" ;

      REDEFINE BUTTON ;                   // Boton de Actualizar o añadir
         ID       IDOK ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( EndTrans( aTmp, aGet, dbfTblCnv, oBrw, nMode, oDlg ) )

      REDEFINE BUTTON ;                         // Boton de salida
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      REDEFINE BUTTON ;
         ID       559 ;
			OF 		oDlg ;
         ACTION   ( ChmHelp( "Factores_de_conversion" ) )

      if nMode != ZOOM_MODE
         oDlg:AddFastKey( VK_F5, {|| EndTrans( aTmp, aGet, dbfTblCnv, oBrw, nMode, oDlg ) } )
      end if

      oDlg:AddFastKey ( VK_F1, {|| ChmHelp( "Factores_de_conversion" ) } )

      oDlg:bStart := {|| aGet[ _CCODCNV ]:SetFocus() }

      ACTIVATE DIALOG oDlg CENTERED

RETURN ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//

Static Function EndTrans( aTmp, aGet, dbfTblCnv, oBrw, nMode, oDlg )

   if nMode == APPD_MODE .or. nMode == DUPL_MODE

      if Empty( aTmp[ _CCODCNV ] )
         MsgStop( "Código no puede estar vacío" )
         aGet[ _CCODCNV ]:SetFocus()
         return nil
      end if

      if dbSeekInOrd( aTmp[ _CCODCNV ], "CCODCNV", dbfTblCnv )
         MsgStop( "Código ya existe " + Rtrim( aTmp[ _CCODCNV ] ) )
         return nil
      end if

   end if

   if Empty( aTmp[ _CDETCNV ] )
         MsgStop( "Nombre no puede estar vacío" )
         aGet[ _CDETCNV ]:SetFocus()
         return nil
      end if

   WinGather( aTmp, aGet, dbfTblCnv, oBrw, nMode )

Return ( oDlg:end( IDOK ) )

//----------------------------------------------------------------------------//

FUNCTION BrwTblCnv( oGet, dbfTblCnv, oGet2 )

   local oBlock
   local oError
	local oDlg
	local oBrw
	local oGet1
	local cGet1
   local nOrd     := GetBrwOpt( "BrwTblCnv" )
	local oCbxOrd
   local aCbxOrd  := { "Código", "Nombre" }
   local cCbxOrd
   local nLevel   := nLevelUsr( "01016" )
   local lClose   := .f.

   nOrd           := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd        := aCbxOrd[ nOrd ]

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if dbfTblCnv == nil
      USE ( cPatDat() + "TBLCNV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TBLCNV", @dbfTblCnv ) )
      SET ADSINDEX TO ( cPatDat() + "TBLCNV.CDX" ) ADDITIVE
      lClose      := .t.
   end if

   nOrd           := ( dbfTblCnv )->( OrdSetFocus( nOrd ) )

   ( dbfTblCnv )->( dbGoTop() )

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Tablas de conversión"

		REDEFINE GET oGet1 VAR cGet1;
         ID       104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfTblCnv ) ) ;
         VALID    ( OrdClearScope( oBrw, dbfTblCnv ) );
         BITMAP   "FIND" ;
         OF       oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( ( dbfTblCnv )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:Refresh(), oGet1:SetFocus() ) ;
			OF 		oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfTblCnv
      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "Browse.Tablas de conversión"

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodCnv"
         :bEditValue       := {|| ( dbfTblCnv )->cCodCnv }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cDetCnv"
         :bEditValue       := {|| ( dbfTblCnv )->cDetCnv }
         :nWidth           := 260
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }
      oBrw:bRClicked       := {| nRow, nCol, nFlags | oBrw:RButtonDown( nRow, nCol, nFlags ) }

      oBrw:CreateFromResource( 105 )



      /*
		REDEFINE LISTBOX oBrw ;
			FIELDS ;
                  (dbfTblCnv)->CCODCNV,;
                  (dbfTblCnv)->CDETCNV ;
			HEAD ;
                  "Código",;
						"Nombre" ;
			ID 		105 ;
         ALIAS    ( dbfTblCnv ) ;
			OF 		oDlg

      oBrw:aActions    := {| nCol | lPressCol( nCol, oBrw, oCbxOrd, aCbxOrd, dbfTblCnv ) }
      oBrw:bLDblClick  := {|| oDlg:end( IDOK ) }
      */

		REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         ACTION   ( oDlg:end(IDOK) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

		REDEFINE BUTTON ;
			ID 		500 ;
			OF 		oDlg ;
         WHEN     nAnd( nLevel, ACC_APPD ) != 0 ;
         ACTION   ( WinAppRec( oBrw, bEdit, dbfTblCnv ) )

		REDEFINE BUTTON ;
			ID 		501 ;
			OF 		oDlg ;
         WHEN     nAnd( nLevel, ACC_EDIT ) != 0 ;
         ACTION   ( WinEdtRec( oBrw, bEdit, dbfTblCnv ) )

      oDlg:AddFastKey( VK_F2,       {|| if( nAnd( nLevel, ACC_APPD ) != 0, WinAppRec( oBrw, bEdit, dbfTblCnv ), ) } )
      oDlg:AddFastKey( VK_F3,       {|| if( nAnd( nLevel, ACC_EDIT ) != 0, WinEdtRec( oBrw, bEdit, dbfTblCnv ), ) } )
      oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )
      oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )

      oDlg:bStart := {|| oBrw:Load() }

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK

      oGet:cText( ( dbfTblCnv )->cCodCnv )
      oGet:lValid()

      if ValType( oGet2 ) == "O"
         oGet2:cText( ( dbfTblCnv )->cDetCnv )
      end if

   end if

   DestroyFastFilter( dbfTblCnv )

   SetBrwOpt( "BrwTblCnv", ( dbfTblCnv )->( OrdNumber() ) )

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if lClose
      CLOSE ( dbfTblCnv )
   else
      ( dbfTblCnv )->( OrdSetFocus( nOrd ) )
   end if

   oGet:setFocus()

RETURN ( .T. )

//---------------------------------------------------------------------------//

FUNCTION cTblCnv( oGet, dbfTblCnv, oGet2, oGetCom, oGetVta )

   local oBlock
   local oError
   local lClose   := .f.
   local lValid   := .f.
	local xValor	:= oGet:varGet()

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   IF dbfTblCnv == NIL
      USE ( cPatDat() + "TBLCNV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TBLCNV", @dbfTblCnv ) )
      SET ADSINDEX TO ( cPatDat() + "TBLCNV.CDX" ) ADDITIVE
      lClose = .T.
	END IF

   IF !(dbfTblCnv)->( dbSeek( xValor ) )

      (dbfTblCnv)->( dbGoBottom() )
      (dbfTblCnv)->( dbSkip() )

      if !Empty( xValor )
         msgStop( "Tabla de conversión no encontrada" )
         lValid   := .f.
      else
         lValid   := .t.
      end if

   ELSE

      lValid   := .t.

   END IF

   oGet:cText( (dbfTblCnv)->CCODCNV )

   IF oGet2 != NIL
      oGet2:cText( (dbfTblCnv)->CDETCNV )
   END IF

   IF oGetCom != NIL
      oGetCom:cText( (dbfTblCnv)->CUNDSTK )
   END IF

   IF oGetVta != NIL
      oGetVta:cText( (dbfTblCnv)->CUNDVTA )
   END IF

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos de agentes" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

	IF lClose
      CLOSE (dbfTblCnv)
	END IF

   dbfTblCnv := NIL

RETURN lValid

//---------------------------------------------------------------------------//
/*
Devuelve el factor de conversion de un articulo pasado
*/

FUNCTION nValTblCnv( cCod, dbfArt, dbfTblCnv )

   local nRec     := ( dbfArt )->( Recno() )
   local nValCnv  := 1

   if !Empty( dbfArt ) .and. ( dbfArt )->( Used() )
      RETURN ( nValCnv )
   end if

   if !Empty( dbfTblCnv ) .and. ( dbfTblCnv )->( Used() )
      RETURN ( nValCnv )
   end if

   if dbSeekInOrd( cCod, "Codigo", dbfArt )
      if ( dbfTblCnv )->( dbSeek( ( dbfArt )->cFacCnv ) ) .and. ( dbfArt )->lFacCnv
         nValCnv  := ( dbfTblCnv )->nFacCnv
      end if
   end if

   ( dbfArt )->( dbGoTo( nRec ) )

RETURN ( nValCnv )

//---------------------------------------------------------------------------//
#else
//---------------------------------------------------------------------------//

CLASS pdaTblconvSenderReciver

   Method CreateData()

END CLASS

//----------------------------------------------------------------------------//

Method CreateData( oPgrActual, oSayStatus ) CLASS pdaTblconvSenderReciver

   local tmpTblcnv
   local dbfTblcnv
   local lExist        := .f.

   USE ( cPatDat() + "TBLCNV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TBLCNV", @dbfTblcnv ) )
   SET ADSINDEX TO ( cPatDat() + "TBLCNV.CDX" ) ADDITIVE

   dbUseArea( .t., cDriver(), AllTrim( cNombrePc() ) + "Datos\TBLCNV.Dbf", cCheckArea( "TBLCNV", @tmpTblcnv ), .t. )
   ( tmpTblcnv )->( ordListAdd( AllTrim( cNombrePc() ) + "Datos\TBLCNV.Cdx" ) )

   if !Empty( oPgrActual )
      oPgrActual:SetRange( 0, ( tmpTblcnv )->( OrdKeyCount() ) )
   end if

   ( tmpTblcnv )->( dbGoTop() )
   while !( tmpTblcnv )->( eof() )

      if ( dbfTblcnv )->( dbSeek( ( tmpTblcnv )->cCodCnv ) )
         dbPass( tmpTblcnv, dbfTblcnv, .f. )
      else
         dbPass( tmpTblcnv, dbfTblcnv, .t. )
      end if

      ( tmpTblcnv )->( dbSkip() )

      if !Empty( oSayStatus )
         oSayStatus:SetText( "Sincronizando Contadores " + Alltrim( Str( ( tmpTblcnv )->( OrdKeyNo() ) ) ) + " de " + Alltrim( Str( ( tmpTblcnv )->( OrdKeyCount() ) ) ) )
      end if

      SysRefresh()

      if !Empty( oPgrActual )
         oPgrActual:SetPos( ( tmpTblcnv )->( OrdKeyNo() ) )
      end if

      SysRefresh()

   end while

   CLOSE ( tmpTblcnv )
   CLOSE ( dbfTblcnv )

Return ( Self )

//---------------------------------------------------------------------------//

Function IsTblcnv( cPath )

   DEFAULT cPath  := cPatDat()

   if !lExistTable( cPath + "Tblcnv.Dbf" )
      rxTblCnv( cPath )
   end if

   if !lExistIndex( cPath + "Tblcnv.Cdx"   )
      rxTblcnv( cPath )
   end if

Return ( nil )

//---------------------------------------------------------------------------//
#endif
//---------------------------------------------------------------------------//

FUNCTION mkTblCnv( cPath, lAppend, cPathOld )

   local dbf

   DEFAULT cPath     := cPatDat()
   DEFAULT lAppend   := .f.

   if !lExistTable( cPath + "TblCnv.Dbf" )
      dbCreate( cPath + "TblCnv.Dbf", aSqlStruct( aItmTbl() ), cDriver() )
   end if

   if lAppend .and. lIsDir( cPathOld ) .and. lExistTable( cPathOld + "TblCnv.Dbf" )

      dbUseArea( .t., cDriver(), cPath + "TblCnv.Dbf", cCheckArea( "TblCnv.Dbf", @dbf ), .f. )
      if !( dbf )->( neterr() )
         ( dbf )->( __dbApp( cPathOld + "TblCnv.Dbf" ) )
         ( dbf )->( dbCloseArea() )
      end if

   end if

   rxTblCnv( cPath )

RETURN .t.

//--------------------------------------------------------------------------//

FUNCTION rxTblCnv( cPath, oMeter )

   local dbf

   DEFAULT cPath  := cPatDat()

   if !lExistTable( cPath + "TBLCNV.DBF" )
      mkTblCnv( cPath )
   end if

   dbUseArea( .t., cDriver(), cPath + "TBLCNV.DBF", cCheckArea( "TBLCNV", @dbf ), .f. )
   if !( dbf )->( neterr() )
      ( dbf )->( __dbPack() )

      ( dbf )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbf )->( ordCreate( cPath + "TBLCNV.CDX", "CCODCNV", "Field->CCODCNV", {|| Field->CCODCNV } ) )

      ( dbf )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbf )->( ordCreate( cPath + "TBLCNV.CDX", "CDETCNV", "Upper( Field->cDetCnv )", {|| Upper( Field->cDetCnv ) } ) )

      ( dbf )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de factores de conversión" )
   end if

RETURN NIL

//--------------------------------------------------------------------------//

function aItmTbl()

   local aItmTbl  :=  {}

   aAdd( aItmTbl, { "CCODCNV",   "C",  2,  0, "Código de la tabla de conversión" ,  "",  "", "( cDbf )"} )
   aAdd( aItmTbl, { "CDETCNV",   "C", 30,  0, "Detalle de la tabla de conversión" , "",  "", "( cDbf )"} )
   aAdd( aItmTbl, { "CUNDSTK",   "C",  4,  0, "Literal para unidades de stocks" ,   "",  "", "( cDbf )"} )
   aAdd( aItmTbl, { "CUNDVTA",   "C",  4,  0, "Literal para unidades de venta" ,    "",  "", "( cDbf )"} )
   aAdd( aItmTbl, { "NFACCNV",   "N", 16,  6, "Factor de conversión" ,              "",  "", "( cDbf )"} )

return ( aItmTbl )

//---------------------------------------------------------------------------//