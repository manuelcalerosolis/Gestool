#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Menu.ch"
#include "Report.ch"
#include "Print.ch"

#define TITULOS            "0"
#define CABECERA           "1"
#define CUERPO             "2"
#define PIE                "3"

static aBmp

static oWndBrw

static filTmpCab
static dbfTmpCab
static filTmpCue
static dbfTmpCue
static filTmpPie
static dbfTmpPie

static dbfDoc
static dbfDet
static aStrColor
static aResColor
static aRgbColor
static nSeaColor

static bEdtTikItems        := { |aTmp, aGet, cDbf, oBrw, bWhen, bValid, nMode | EdtTikItems( aTmp, aGet, cDbf, oBrw, bWhen, bValid, nMode ) }
static bEdtTikLines        := { |aTmp, aGet, cDbf, oBrw, bWhen, bValid, nMode, aTmpTik | EdtTikLines( aTmp, aGet, cDbf, oBrw, bWhen, bValid, nMode, aTmpTik ) }

//----------------------------------------------------------------------------//

Static Function aItemsDocument()

   local aDbf     := {}

   aAdd( aDbf, { "cCodigo",      "C",   3, 0, "Código del documento",                  "", "", "( cDbf )" } )
   aAdd( aDbf, { "cDescrip",     "C", 250, 0, "Descripción del documento",             "", "", "( cDbf )" } )
   aAdd( aDbf, { "cBitmap",      "C", 250, 0, "Imagen del ticket",                     "", "", "( cDbf )" } )
   aAdd( aDbf, { "lPreImp",      "L",   1, 0, "Lógico preimprimir títulos",            "", "", "( cDbf )" } )
   aAdd( aDbf, { "lUseDriver",   "L",   1, 0, "Lógico usar driver windows",            "", "", "( cDbf )" } )
   aAdd( aDbf, { "nSelPrn",      "N",   1, 0, "Impresora seleccionada o por defecto",  "", "", "( cDbf )" } )
   aAdd( aDbf, { "cNomPrn",      "C", 250, 0, "Nombre de impresora seleccionada",      "", "", "( cDbf )" } )

Return ( aDbf )

//----------------------------------------------------------------------------//

Static Function aItemsLines()

   local aDbf     := {}

   aAdd( aDbf, { "cCodigo",      "C",   3, 0, "Código del documento",      "", "", "( cDbf )" } )
   aAdd( aDbf, { "nLinea",       "N",   3, 0, "Número de la línea",        "", "", "( cDbf )" } )
   aAdd( aDbf, { "cDescrip",     "C", 100, 0, "Descripción de la línea",   "", "", "( cDbf )" } )
   aAdd( aDbf, { "mExpresion",   "M",  10, 0, "Expresión de la línea",     "", "", "( cDbf )" } )
   aAdd( aDbf, { "cTipo",        "C",   1, 0, "Tipo de línea",             "", "", "( cDbf )" } )
   aAdd( aDbf, { "lNegrita",     "L",   1, 0, "Lógico de negrita",         "", "", "( cDbf )" } )
   aAdd( aDbf, { "lCentrado",    "L",   1, 0, "Lógico de centrado",        "", "", "( cDbf )" } )
   aAdd( aDbf, { "lExpandido",   "L",   1, 0, "Lógico de expandido",       "", "", "( cDbf )" } )
   aAdd( aDbf, { "lColor",       "L",   1, 0, "Lógico de color",           "", "", "( cDbf )" } )
   aAdd( aDbf, { "nAjuste",      "N",   1, 0, "Ajuste del texto",          "", "", "( cDbf )" } )
   aAdd( aDbf, { "Italic",       "L",   1, 0, "Estilo negrita",            "", "", "( cDbf )" } )
   aAdd( aDbf, { "Underline",    "L",   1, 0, "Estilo subrayado",          "", "", "( cDbf )" } )
   aAdd( aDbf, { "Strikeout",    "L",   1, 0, "Estilo cursiva",            "", "", "( cDbf )" } )
   aAdd( aDbf, { "Facename",     "C",  20, 0, "Nombre fuente",             "", "", "( cDbf )" } )
   aAdd( aDbf, { "Color",        "N",  10, 0, "Color fuente",              "", "", "( cDbf )" } )
   aAdd( aDbf, { "Width",        "N",  10, 0, "Tamaño fuente",             "", "", "( cDbf )" } )
   aAdd( aDbf, { "cCondicion",   "C", 250, 0, "",                          "", "", "( cDbf )" } )

Return ( aDbf )

//----------------------------------------------------------------------------//

Function rxTikItems( cPath, oMeter )

	local cDbf

   DEFAULT cPath  := cPatEmp()

   fErase( cPath + "RTikDoc.Cdx")
   fErase( cPath + "RTikDet.Cdx"  )

   if !lExistTable( cPath + "RTikDoc.Dbf" )
      dbCreate( cPath + "RTikDoc.Dbf", aSqlStruct( aItemsDocument() ), cDriver() )
   end if

   if !lExistTable( cPath + "RTikDet.Dbf" )
      dbCreate( cPath + "RTikDet.Dbf", aSqlStruct( aItemsLines() ), cDriver() )
   end if

   dbUseArea( .t., cDriver(), cPath + "RTikDoc.Dbf", cCheckArea( "RTIKDOC", @cDbf ), .f. )

   if !( cDbf )->( neterr() )
      ( cDbf )->( __dbPack() )

      ( cDbf )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( cDbf )->( ordCreate( cPath + "RTikDoc.Cdx", "cCodigo", "cCodigo", {|| Field->cCodigo }, ) )

      ( cDbf )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cDbf )->( ordCreate( cPath + "RTikDoc.Cdx", "cDescrip", "cDescrip", {|| Field->cDescrip }, ) )

      ( cDbf )->( dbCloseArea() )
   end if

   dbUseArea( .t., cDriver(), cPath + "RTikDet.Dbf", cCheckArea( "RTikDet", @cDbf ), .f. )

   if !( cDbf )->( neterr() )
      ( cDbf )->( __dbPack() )

      ( cDbf )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( cDbf )->( ordCreate( cPath + "RTikDet.Cdx", "cCodigo", "cCodigo", {|| Field->cCodigo }, ) )

      ( cDbf )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( cDbf )->( ordCreate( cPath + "RTikDet.Cdx", "cTipo", "cCodigo + cTipo", {|| Field->cCodigo + Field->cTipo }, ) )

      ( cDbf )->( dbCloseArea() )
   end if

Return nil

//----------------------------------------------------------------------------//

Function mkTikItems( cPath, lAppend, cPathOld, oMeter, cVia )

   local cDbf

   DEFAULT cPath     := cPatEmp()
   DEFAULT lAppend   := .f.
   DEFAULT cPathOld  := ""
   DEFAULT cVia      := cDriver()

   if !lExistTable( cPath + "RTikDoc.Dbf", cVia )
      dbCreate( cPath + "RTikDoc.Dbf", aSqlStruct( aItemsDocument() ), cVia )
   end if

   if !lExistTable( cPath + "RTikDet.Dbf", cVia )
      dbCreate( cPath + "RTikDet.Dbf", aSqlStruct( aItemsLines() ), cVia )
   end if

   if lAppend .and. lIsDir( cPathOld )

      if lExistTable( cPathOld + "RTikDoc.Dbf" )
         dbUseArea( .t., cVia, cPath + "RTikDoc.Dbf", cCheckArea( "RTikDoc", @cDbf ), .f. )
         if !( cDbf )->( neterr() )
            ( cDbf )->( __dbApp( cPathOld + "RTikDoc.Dbf", , , , , , , cVia ) )
            ( cDbf )->( dbCloseArea() )
         end if
      end if

      if lExistTable( cPathOld + "RTikDet.Dbf" )
         dbUseArea( .t., cVia, cPath + "RTikDet.Dbf", cCheckArea( "RTikDet", @cDbf ), .f. )
         if !( cDbf )->( neterr() )
            ( cDbf )->( __dbApp( cPathOld + "RTikDet.Dbf", , , , , , , cVia ) )
            ( cDbf )->( dbCloseArea() )
         end if
      end if

   end if

   rxTikItems( cPath, oMeter )

Return nil

//----------------------------------------------------------------------------//

Static Function OpenFiles( cPatEmp )

   local lOpen       := .t.
   local oBlock      := ErrorBlock( { | oError | ApoloBreak( oError ) } )

   DEFAULT cPatEmp   := cPatEmp()

   BEGIN SEQUENCE

      if !lExistTable( cPatEmp + "RTikDoc.Dbf" )   .or. ;
         !lExistTable( cPatEmp + "RTikDet.Dbf" )
         mkTikItems( cPatEmp )
      end if

      if !lExistIndex( cPatEmp + "RTikDoc.Cdx" )   .or. ;
         !lExistIndex( cPatEmp + "RTikDet.Cdx" )
         rxTikItems( cPatEmp )
      end if

      USE ( cPatEmp + "RTikDoc.Dbf" ) NEW SHARED VIA ( cDriver() )ALIAS ( cCheckArea( "RTikDoc", @dbfDoc ) )
      SET ADSINDEX TO ( cPatEmp + "RTikDoc.Cdx" ) ADDITIVE

      USE ( cPatEmp + "RTikDet.Dbf" ) NEW SHARED VIA ( cDriver() )ALIAS ( cCheckArea( "RTikDet", @dbfDet ) )
      SET ADSINDEX TO ( cPatEmp + "RTikDet.Cdx" ) ADDITIVE

      aStrColor      := { "Negro", "Rojo oscuro", "Verde oscuro", "Oliva", "Azul marino", "Púrpura", "Verde azulado", "Gris",  "Plateado", "Rojo", "Verde", "Amarillo", "Azul", "Fucsia", "Aguamarina", "Blanco" }
      aResColor      := { "COL_00", "COL_01", "COL_02", "COL_03", "COL_04", "COL_05", "COL_06", "COL_07", "COL_08", "COL_09", "COL_10", "COL_11", "COL_12", "COL_13", "COL_14", "COL_15" }
      aRgbColor      := { Rgb( 0, 0, 0 ), Rgb( 128, 0, 0 ), Rgb( 0, 128, 0 ), Rgb( 128, 128, 128 ), Rgb( 0, 0, 128 ), Rgb( 128, 0, 128 ), Rgb( 0, 128, 128 ), Rgb( 128, 128, 128 ), Rgb( 192, 192, 192 ), Rgb( 255, 0, 0 ), Rgb( 0, 255, 0 ), Rgb( 255, 255, 0 ), Rgb( 0, 0, 255 ), Rgb( 255, 0, 255 ), Rgb( 0, 255, 255 ) }

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN lOpen

//----------------------------------------------------------------------------//

Function CfgTikItems( oMenuItem, oWnd )

   local oRpl
   local nLevel

   if oWndBrw == nil

   nLevel   := Auth():Level( oMenuItem )
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

   aBmp  := {  LoadBitmap( GetResources(), "gc_text_bold_16" )       ,;
               LoadBitmap( GetResources(), "gc_text_center_16" )     ,;
               LoadBitmap( GetResources(), "gc_text_justified_16" ) }

   DEFINE SHELL oWndBrw FROM 2, 10 TO 18, 70;
      TITLE    "Formatos de tickets" ;
      FIELDS   ( dbfDoc )->cCodigo,;
               ( dbfDoc )->cDescrip;
      HEAD     "Código",;
               "Nombre";
      PROMPT   "Código",;
               "Nombre";
      MRU      "gc_document_text_pencil_16";
      BITMAP   "WebTopGreen" ;
		ALIAS		( dbfDoc ) ;
      APPEND   ( WinAppRec( oWndBrw:oBrw, bEdtTikItems, dbfDoc ) );
      DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdtTikItems, dbfDoc ) ) ;
      EDIT     ( WinEdtRec( oWndBrw:oBrw, bEdtTikItems, dbfDoc ) ) ;
      DELETE   ( DocDelRec( oWndBrw:oBrw ) ) ;
      LEVEL    nLevel ;
		OF 		oWnd

      DEFINE BTNSHELL RESOURCE "BUS" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:SearchSetFocus() ) ;
			TOOLTIP 	"(B)uscar";
         HOTKEY   "B"

      oWndBrw:AddSeaBar()

      DEFINE BTNSHELL RESOURCE "NEW" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( oWndBrw:RecAdd() );
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
			TOOLTIP 	"(M)odificar";
         HOTKEY   "M";
         LEVEL    ACC_EDIT

		DEFINE BTNSHELL RESOURCE "ZOOM" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( WinZooRec( oWndBrw:oBrw, bEdtTikItems, dbfDoc ) );
			TOOLTIP 	"(Z)oom";
         HOTKEY   "Z" ;
         LEVEL    4

		DEFINE BTNSHELL RESOURCE "DEL" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( oWndBrw:RecDel() );
			TOOLTIP 	"(E)liminar";
         HOTKEY   "E" ;
         LEVEL    ACC_DELE

      DEFINE BTNSHELL RESOURCE "EXPORT" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( ExpDoc( oWndBrw ) );
         TOOLTIP  "E(x)portar";
         HOTKEY   "X" ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "IMPORT" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( GetDoc( oWndBrw ) );
         TOOLTIP  "Im(p)ortar";
         HOTKEY   "P" ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "END" GROUP OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:End() ) ;
         TOOLTIP  "(S)alir" ;
			HOTKEY 	"S"

      oWndBrw:bDestroy  := {|| aEval( aBmp, { | hBmp | DeleteObject( hBmp ) } ) }

		ACTIVATE WINDOW oWndBrw VALID ( CloseFiles() )

   else

		oWndBrw:SetFocus()

   end if

RETURN NIL

//----------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles()

   if oWndBrw != nil
      oWndBrw:oBrw:lCloseArea()
   else
      ( dbfDoc )->( dbCloseArea() )
   end if

   ( dbfDet )->( dbCloseArea() )

   oWndBrw           := nil

RETURN .T.

//----------------------------------------------------------------------------//

Static Function BeginTrans( aTmp )

   local lErrors     := .f.
   local cCodDoc     := aTmp[ ( dbfDoc )->( FieldPos( "cCodigo" ) ) ]
   local oBlock      := ErrorBlock( { | oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   filTmpCab         := cGetNewFileName( cPatTmp() + "DbfTmpCab" )
   filTmpCue         := cGetNewFileName( cPatTmp() + "DbfTmpCue" )
   filTmpPie         := cGetNewFileName( cPatTmp() + "DbfTmpPie" )

   /*
   Temporal de la base de datos cabeceras
   */

   dbCreate( filTmpCab, aSqlStruct( aItemsLines() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), filTmpCab, cCheckArea( "DbfTmpCab", @dbfTmpCab ), .f. )
   if !( dbfTmpCab )->( neterr() )
      ( dbfTmpCab )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmpCab )->( OrdCreate( filTmpCab, "cCodigo", "Str( Recno() )", {|| Str( Recno() ) } ) )
   end if

   /*
   Temporal de la base de datos cuerpo
   */

   dbCreate( filTmpCue, aSqlStruct( aItemsLines() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), filTmpCue, cCheckArea( "DbfTmpCue", @dbfTmpCue ), .f. )
   if !( dbfTmpCue )->( neterr() )
      ( dbfTmpCue )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmpCue )->( OrdCreate( filTmpCue, "cCodigo", "Str( Recno() )", {|| Str( Recno() ) } ) )
   end if

   /*
   Temporal de la base de datos pie
   */

   dbCreate( filTmpPie, aSqlStruct( aItemsLines() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), filTmpPie, cCheckArea( "DbfTmpPie", @dbfTmpPie ), .f. )
   if !( dbfTmpPie )->( neterr() )
      ( dbfTmpPie )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmpPie )->( OrdCreate( filTmpPie, "cCodigo", "Str( Recno() )", {|| Str( Recno() ) } ) )
   end if

   /*
   Trasbase de datos-----------------------------------------------------------
   */

   if ( dbfDet )->( dbSeek( cCodDoc ) )
      while ( dbfDet )->cCodigo == cCodDoc .and. !( dbfDet )->( eof() )
         do case
            case ( dbfDet )->cTipo == CABECERA
               dbPass( dbfDet, dbfTmpCab, .t. )
            case ( dbfDet )->cTipo == CUERPO
               dbPass( dbfDet, dbfTmpCue, .t. )
            case ( dbfDet )->cTipo == PIE
               dbPass( dbfDet, dbfTmpPie, .t. )
         end case
         ( dbfDet )->( dbSkip() )
      end while
      ( dbfTmpCab )->( dbGoTop() )
      ( dbfTmpCue )->( dbGoTop() )
      ( dbfTmpPie )->( dbGoTop() )
   end if

   RECOVER

      msgStop( "Imposible crear tablas temporales." )
      KillTrans()
      lErrors        := .t.

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lErrors )

//----------------------------------------------------------------------------//

Static Function EndTrans( aTmp, aGet, oBrw, oDlg, nMode )

   local oError
   local oBlock
   local cCodDoc     := aTmp[ ( dbfDoc )->( FieldPos( "cCodigo" ) ) ]

   /*
   Condiciones para que no se meta un documento sin código---------------------
   */

   if Empty( cCodDoc )
      MsgStop( "Código no puede estar vacío" )
      aGet[ ( dbfDoc )->( FieldPos( "cCodigo" ) ) ]:SetFocus()
      return nil
   end if

   if Empty( aTmp[ ( dbfDoc )->( FieldPos( "cDescrip" ) ) ] )
      MsgStop( "Descripción no puede estar vacía" )
      aGet[ ( dbfDoc )->( FieldPos( "cDescrip" ) ) ]:SetFocus()
      return nil
   end if

   /*
   Comprueba si el codigo introducido existe-----------------------------------
   */

   if nMode == APPD_MODE .or. nMode == DUPL_MODE

      if ( dbfDoc )->( dbSeek( cCodDoc ) )
         msgStop( "Código ya existente" )
         aGet[ ( dbfDoc )->( FieldPos( "cCodigo" ) ) ]:SetFocus()
         return nil
      end if

   end if

   oBlock      := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   BeginTransaction()

      while ( dbfDet )->( dbSeek( cCodDoc ) ) .and. !( dbfDet )->( eof() )
         if dbLock( dbfDet )
            ( dbfDet )->( dbDelete() )
            ( dbfDet )->( dbUnLock() )
         end if
      end while

      /*
      Pasamos los temporales a los ficheros definitivos---------------------------
      */

      ( dbfTmpCab )->( OrdSetFocus( 0 ) )
      ( dbfTmpCab )->( dbGoTop() )
      while !( dbfTmpCab )->( eof() )
         ( dbfTmpCab )->cCodigo  := cCodDoc
         ( dbfTmpCab )->cTipo    := CABECERA
         dbPass( dbfTmpCab, dbfDet, .t. )
         ( dbfTmpCab )->( dbSkip() )
      end while

      ( dbfTmpCue )->( OrdSetFocus( 0 ) )
      ( dbfTmpCue )->( dbGoTop() )
      while !( dbfTmpCue )->( eof() )
         ( dbfTmpCue )->cCodigo  := cCodDoc
         ( dbfTmpCue )->cTipo    := CUERPO
         dbPass( dbfTmpCue, dbfDet, .t. )
         ( dbfTmpCue )->( dbSkip() )
      end while

      ( dbfTmpPie )->( OrdSetFocus( 0 ) )
      ( dbfTmpPie )->( dbGoTop() )
      while !( dbfTmpPie )->( eof() )
         ( dbfTmpPie )->cCodigo  := cCodDoc
         ( dbfTmpPie )->cTipo    := PIE
         dbPass( dbfTmpPie, dbfDet, .t. )
         ( dbfTmpPie )->( dbSkip() )
      end while

      WinGather( aTmp, nil, dbfDoc, oBrw, nMode, nil, .f. )

      CommitTransaction()

   RECOVER USING oError

      RollBackTransaction()
      msgStop( "Imposible almacenar documento" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE
   ErrorBlock( oBlock )

Return ( oDlg:end( IDOK ) )

//---------------------------------------------------------------------------//

Static Function KillTrans( oBrwCab, oBrwCue, oBrwPie )

   // Cerramos las bases de datos si no están en uso

   if !Empty( dbfTmpCab ) .and. ( dbfTmpCab )->( Used() )
      ( dbfTmpCab )->( dbCloseArea() )
   end if

   if !Empty( dbfTmpCue ) .and. ( dbfTmpCue )->( Used() )
      ( dbfTmpCue )->( dbCloseArea() )
   end if

   if !Empty( dbfTmpPie ) .and. ( dbfTmpPie )->( Used() )
      ( dbfTmpPie )->( dbCloseArea() )
   end if

   // Inicializamos las variables

   dbfTmpCab   := nil
   dbfTmpCue   := nil
   dbfTmpPie   := nil

   // Eliminamos las bases de datos temporales que se han creado

   dbfErase( filTmpCab )
   dbfErase( filTmpCue )
   dbfErase( filTmpPie )

   /*
    Guardamos los datos del browse
   */

   if oBrwCab != nil
      oBrwCab:CloseData()
   end if

   if oBrwCue != nil
      oBrwCue:CloseData()
   end if

   if oBrwPie != nil
      oBrwPie:CloseData()
   end if

Return ( .t. )

//---------------------------------------------------------------------------//

Static Function EdtTikItems( aTmp, aGet, dbfDoc, oBrw, bWhen, bValid, nMode )

   local oDlg
   local oFld
   local oBrwCab
   local oBrwCue
   local oBrwPie
   local bmpImage
   local aAjuste     := { "Izquierda", "Centro", "Derecha" }

   if BeginTrans( aTmp )
      Return .f.
   end if

   if nMode == APPD_MODE
      aTmp[ ( dbfDoc )->( fieldpos( "nSelPrn" ) ) ]      := 1
      aTmp[ ( dbfDoc )->( fieldpos( "cNomPrn" ) ) ]      := ""
   else
      if aTmp[ ( dbfDoc )->( fieldpos( "nSelPrn" ) ) ] == 1
         aTmp[ ( dbfDoc )->( fieldpos( "cNomPrn" ) ) ]   := ""
      end if
   end if

   DEFINE DIALOG oDlg RESOURCE "TikItems" TITLE LblTitle( nMode ) + "formato : " + Rtrim( ( dbfDoc )->cDescrip )

      REDEFINE FOLDER oFld ID 200 OF oDlg ;
         PROMPT   "&Principal",  "Ca&becera",   "C&uerpo"      ,"Pi&e";
         DIALOGS  "TikItems1",   "TikItems3",   "TikItems4"    , "TikItems5"

	/*
	Creamos la segunda caja de Dialogo
	---------------------------------------------------------------------------
	*/

      REDEFINE GET aGet[ ( dbfDoc )->( FieldPos( "cCodigo" ) ) ] ;
         VAR      aTmp[ ( dbfDoc )->( FieldPos( "cCodigo" ) ) ] ;
         VALID    ( notValid( aGet[ ( dbfDoc )->( FieldPos( "cCodigo" ) ) ], dbfDoc ) );
         WHEN     ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) ;
         PICTURE  "@!" ;
         ID       100 ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ ( dbfDoc )->( FieldPos( "cDescrip" ) ) ] ;
         VAR      aTmp[ ( dbfDoc )->( FieldPos( "cDescrip" ) ) ] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			ON CHANGE( ActTitle( nKey, nFlags, Self, nMode, oDlg ) );
         ID       110 ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ ( dbfDoc )->( fieldpos( "cBitmap" ) ) ] ;
         VAR      aTmp[ ( dbfDoc )->( fieldpos( "cBitmap" ) ) ] ;
         BITMAP   "LUPA" ;
         ON HELP  ( GetBmp( aGet[ ( dbfDoc )->( fieldpos( "cBitmap" ) ) ], bmpImage ) ) ;
         ON CHANGE( ChgBmp( aGet[ ( dbfDoc )->( fieldpos( "cBitmap" ) ) ], bmpImage ) ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( ChgBmp( aGet[ ( dbfDoc )->( fieldpos( "cBitmap" ) ) ], bmpImage ), .t. ) ;
         ID       120 ;
         OF       oFld:aDialogs[1]

      REDEFINE BITMAP bmpImage ;
         ID       130 ;
         ON RIGHT CLICK ( bmpImage:lStretch := !bmpImage:lStretch, bmpImage:Refresh() );
         FILE     if(   Empty( cPatImg() ),;
                        Rtrim( aTmp[ ( dbfDoc )->( fieldpos( "cBitmap" ) ) ] ),;
                        Rtrim( cPatImg() ) + aTmp[ ( dbfDoc )->( fieldpos( "cBitmap" ) ) ] );
         OF       oFld:aDialogs[1]

      bmpImage:SetColor( , GetSysColor( 15 ) )

      REDEFINE CHECKBOX aTmp[ ( dbfDoc )->( fieldpos( "lUseDriver" ) ) ] ;
         ID       150 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

	/*
   Cabeceras
	---------------------------------------------------------------------------
	*/

      REDEFINE BUTTON ;
			ID 		500 ;
         OF       oFld:aDialogs[ 2 ] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinAppRec( oBrwCab, bEdtTikLines, dbfTmpCab, , , aTmp ) )

      REDEFINE BUTTON ;
         ID       510 ;
         OF       oFld:aDialogs[ 2 ] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinEdtRec( oBrwCab, bEdtTikLines, dbfTmpCab, , , aTmp ) )

      REDEFINE BUTTON ;
         ID       520 ;
         OF       oFld:aDialogs[ 2 ] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( dbDelRec( oBrwCab, dbfTmpCab ) )

      REDEFINE BUTTON ;
         ID       530 ;
         OF       oFld:aDialogs[ 2 ] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( dbSwapUp( dbfTmpCab, oBrwCab ) )

		REDEFINE BUTTON ;
         ID       540 ;
         OF       oFld:aDialogs[ 2 ] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( dbSwapDown( dbfTmpCab, oBrwCab ) )

      REDEFINE IBROWSE oBrwCab ;
			FIELDS ;
                  ( dbfTmpCab )->cDescrip                                           ,;
                  if( aTmp[ ( dbfDoc )->( fieldpos( "lUseDriver" ) ) ], aAjuste[ Max( ( dbfTmpCab )->nAjuste , 1 ) ], if( ( dbfTmpCab )->lCentrado , "Centro", "Izquierda" ) ),;
                  if( aTmp[ ( dbfDoc )->( fieldpos( "lUseDriver" ) ) ], ( dbfTmpCab )->Facename, "" ),;
                  if( aTmp[ ( dbfDoc )->( fieldpos( "lUseDriver" ) ) ], Trans( ( dbfTmpCab )->Width, "@E 999" ), "" ),;
                  if( aTmp[ ( dbfDoc )->( fieldpos( "lUseDriver" ) ) ], cEstilo( ( dbfTmpCab )->Italic, ( dbfTmpCab )->StrikeOut ), if( ( dbfTmpCab )->lNegrita , "Negrita", "Normal" ) ),;
                  ""                                                                ;
         HEAD ;
                  "Descripción"                                                     ,;
                  "Alineación"                                                      ,;
                  "Fuente"                                                          ,;
                  "Tamaño"                                                          ,;
                  "Estilo"                                                          ,;
                  ""                                                                ;
         FIELDSIZES ;
                  302                                                               ,;
                  80                                                                ,;
                  80                                                                ,;
                  45                                                                ,;
                  80                                                                ,;
                  10                                                                ;
         JUSTIFY  .f., .f., .f., .t., .f., .f.                                      ;
         ALIAS    ( dbfTmpCab ) ;
         ID       200 ;
         OF       oFld:aDialogs[ 2 ]

         oBrwCab:bAdd         := {|| WinAppRec( oBrwCab, bEdtTikLines, dbfTmpCab, , , aTmp ) }
         oBrwCab:bEdit        := {|| WinEdtRec( oBrwCab, bEdtTikLines, dbfTmpCab, , , aTmp ) }
         oBrwCab:bLDblClick   := {|| if( nMode != ZOOM_MODE, WinEdtRec( oBrwCab, bEdtTikLines, dbfTmpCab, , , aTmp ), ) }
         oBrwCab:bDel         := {|| DBDelRec( oBrwCab, dbfTmpCab ) }
         oBrwCab:cWndName     := "Linea de tickets cabecera"
         oBrwCab:Load()

   /*
   Cuerpo
	---------------------------------------------------------------------------
	*/

      REDEFINE BUTTON ;
         ID       500 ;
         OF       oFld:aDialogs[ 3 ] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinAppRec( oBrwCue, bEdtTikLines, dbfTmpCue, , , aTmp ) )

      REDEFINE BUTTON ;
         ID       510 ;
         OF       oFld:aDialogs[ 3 ] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinEdtRec( oBrwCue, bEdtTikLines, dbfTmpCue, , , aTmp ) )

      REDEFINE BUTTON ;
         ID       520 ;
         OF       oFld:aDialogs[ 3 ] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( dbDelRec( oBrwCue, dbfTmpCue ) )

      REDEFINE BUTTON ;
         ID       530 ;
         OF       oFld:aDialogs[ 3 ] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( dbSwapUp( dbfTmpCue, oBrwCue ) )

		REDEFINE BUTTON ;
         ID       540 ;
         OF       oFld:aDialogs[ 3 ] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( dbSwapDown( dbfTmpCue, oBrwCue ) )

      REDEFINE IBROWSE oBrwCue ;
			FIELDS ;
                  ( dbfTmpCue )->cDescrip                                           ,;
                  if( aTmp[ ( dbfDoc )->( fieldpos( "lUseDriver" ) ) ], aAjuste[ Max( ( dbfTmpCue )->nAjuste , 1 ) ], if( ( dbfTmpCue )->lCentrado , "Centro", "Izquierda" ) ),;
                  if( aTmp[ ( dbfDoc )->( fieldpos( "lUseDriver" ) ) ], ( dbfTmpCue )->Facename, "" ),;
                  if( aTmp[ ( dbfDoc )->( fieldpos( "lUseDriver" ) ) ], Trans( ( dbfTmpCue )->Width, "@E 999" ), "" ),;
                  if( aTmp[ ( dbfDoc )->( fieldpos( "lUseDriver" ) ) ], cEstilo( ( dbfTmpCue )->Italic, ( dbfTmpCue )->StrikeOut ), if( ( dbfTmpCue )->lNegrita , "Negrita", "Normal" ) ),;
                  ""                                                                ;
         HEAD ;
                  "Descripción"                                                     ,;
                  "Alineación"                                                      ,;
                  "Fuente"                                                          ,;
                  "Tamaño"                                                          ,;
                  "Estilo"                                                          ,;
                  ""                                                                ;
         FIELDSIZES ;
                  302                                                               ,;
                  80                                                                ,;
                  80                                                                ,;
                  45                                                                ,;
                  80                                                                ,;
                  10                                                                ;
         JUSTIFY  .f., .f., .f., .t., .f., .f.                                      ;
         ALIAS    ( dbfTmpCue ) ;
         ID       200 ;
         OF       oFld:aDialogs[ 3 ]

         oBrwCue:bAdd         := {|| WinAppRec( oBrwCue, bEdtTikLines, dbfTmpCue, , , aTmp ) }
         oBrwCue:bEdit        := {|| WinEdtRec( oBrwCue, bEdtTikLines, dbfTmpCue, , , aTmp ) }
         oBrwCue:bLDblClick   := {|| if( nMode != ZOOM_MODE, WinEdtRec( oBrwCue, bEdtTikLines, dbfTmpCue, , , aTmp ), ) }
         oBrwCue:bDel         := {|| DBDelRec( oBrwCue, dbfTmpCue ) }
         oBrwCue:cWndName     := "Linea de ticket cuerpo"
         oBrwCue:Load()

   /*
   Píe
	---------------------------------------------------------------------------
	*/

      REDEFINE BUTTON ;
         ID       500 ;
         OF       oFld:aDialogs[ 4 ] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinAppRec( oBrwPie, bEdtTikLines, dbfTmpPie, , , aTmp ) )

      REDEFINE BUTTON ;
         ID       510 ;
         OF       oFld:aDialogs[ 4 ] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinEdtRec( oBrwPie, bEdtTikLines, dbfTmpPie, , , aTmp ) )

      REDEFINE BUTTON ;
         ID       520 ;
         OF       oFld:aDialogs[ 4 ] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( dbDelRec( oBrwPie, dbfTmpPie ) )

      REDEFINE BUTTON ;
         ID       530 ;
         OF       oFld:aDialogs[ 4 ] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( dbSwapUp( dbfTmpPie, oBrwPie ) )

		REDEFINE BUTTON ;
         ID       540 ;
         OF       oFld:aDialogs[ 4 ] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( dbSwapDown( dbfTmpPie, oBrwPie ) )

      REDEFINE IBROWSE oBrwPie ;
			FIELDS ;
                  ( dbfTmpPie )->cDescrip                                           ,;
                  if( aTmp[ ( dbfDoc )->( fieldpos( "lUseDriver" ) ) ], aAjuste[ Max( ( dbfTmpPie )->nAjuste , 1 ) ], if( ( dbfTmpPie )->lCentrado , "Centro", "Izquierda" ) ),;
                  if( aTmp[ ( dbfDoc )->( fieldpos( "lUseDriver" ) ) ], ( dbfTmpPie )->Facename, "" ),;
                  if( aTmp[ ( dbfDoc )->( fieldpos( "lUseDriver" ) ) ], Trans( ( dbfTmpPie )->Width, "@E 999" ), "" ),;
                  if( aTmp[ ( dbfDoc )->( fieldpos( "lUseDriver" ) ) ], cEstilo( ( dbfTmpPie )->Italic, ( dbfTmpPie )->StrikeOut ), if( ( dbfTmpPie )->lNegrita , "Negrita", "Normal" ) ),;
                  ""                                                                ;
         HEAD ;
                  "Descripción"                                                     ,;
                  "Alineación"                                                      ,;
                  "Fuente"                                                          ,;
                  "Tamaño"                                                          ,;
                  "Estilo"                                                          ,;
                  ""                                                                ;
         FIELDSIZES ;
                  302                                                               ,;
                  80                                                                ,;
                  80                                                                ,;
                  45                                                                ,;
                  80                                                                ,;
                  10                                                                ;
         JUSTIFY  .f., .f., .f., .t., .f., .f.                                      ;
         ALIAS    ( dbfTmpPie ) ;
         ID       200 ;
         OF       oFld:aDialogs[ 4 ]

         oBrwPie:bAdd         := {|| WinAppRec( oBrwPie, bEdtTikLines, dbfTmpPie, , , aTmp ) }
         oBrwPie:bEdit        := {|| WinEdtRec( oBrwPie, bEdtTikLines, dbfTmpPie, , , aTmp ) }
         oBrwPie:bLDblClick   := {|| if( nMode != ZOOM_MODE, WinEdtRec( oBrwPie, bEdtTikLines, dbfTmpPie, , , aTmp ), ) }
         oBrwPie:bDel         := {|| DBDelRec( oBrwPie, dbfTmpPie ) }
         oBrwPie:cWndName     := "Linea de ticket pie"
         oBrwPie:Load()

	/*
	Boton de Salida
	---------------------------------------------------------------------------
	*/

	REDEFINE BUTTON ;
      ID       500 ;
		OF 		oDlg ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      ACTION   ( EndTrans( aTmp, aGet, oBrw, oDlg, nMode ) )

	REDEFINE BUTTON ;
      ID       510 ;
		OF 		oDlg ;
      CANCEL ;
      ACTION   ( oDlg:end( IDOK ) )

   oDlg:bStart := {|| ChgBmp( aGet[ ( dbfDoc )->( fieldpos( "cBitmap" ) ) ], bmpImage ) }

   if nMode != ZOOM_MODE
      oFld:aDialogs[2]:AddFastKey( VK_F2, {|| WinAppRec( oBrwCab, bEdtTikLines, dbfTmpCab, , , aTmp ) } )
      oFld:aDialogs[2]:AddFastKey( VK_F3, {|| WinEdtRec( oBrwCab, bEdtTikLines, dbfTmpCab, , , aTmp ) } )
      oFld:aDialogs[2]:AddFastKey( VK_F4, {|| DBDelRec( oBrwCab, dbfTmpCab ) } )
      oFld:aDialogs[3]:AddFastKey( VK_F2, {|| WinAppRec( oBrwCue, bEdtTikLines, dbfTmpCue, , , aTmp ) } )
      oFld:aDialogs[3]:AddFastKey( VK_F3, {|| WinEdtRec( oBrwCue, bEdtTikLines, dbfTmpCue, , , aTmp ) } )
      oFld:aDialogs[3]:AddFastKey( VK_F4, {|| DBDelRec( oBrwCue, dbfTmpCue ) } )
      oFld:aDialogs[4]:AddFastKey( VK_F2, {|| WinAppRec( oBrwPie, bEdtTikLines, dbfTmpPie, , , aTmp ) } )
      oFld:aDialogs[4]:AddFastKey( VK_F3, {|| WinEdtRec( oBrwPie, bEdtTikLines, dbfTmpPie, , , aTmp ) } )
      oFld:aDialogs[4]:AddFastKey( VK_F4, {|| DBDelRec( oBrwPie, dbfTmpPie ) } )
      oDlg:AddFastKey( VK_F5, {|| EndTrans( aTmp, aGet, oBrw, oDlg, nMode ) } )
   end if

   ACTIVATE DIALOG oDlg ;
      CENTER ;
      VALID ( KillTrans( oBrwCab, oBrwCue, oBrwPie ) )

Return ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//

Static Function EdtTikLines( aTmp, aGet, dbfDet, oBrw, bWhen, bValid, nMode, aTmpTik )

	local oDlg
   local aResAjust      := { "ALIGN_LEFT", "ALIGN_CENTER", "ALIGN_RIGHT" }
   local oCbxAjust
   local aCbxAjust      := { "Izquierda", "Centro", "Derecha" }
   local cCbxAjust      := aCbxAjust[ Max( aTmp[ ( dbfDet )->( FieldPos( "nAjuste" ) ) ], 1 ) ]
   local oEstilo
   local cEstilo        := "Normal"
   local aEstilo        := { "Normal", "Cursiva", "Negrita", "Negrita Cursiva" }
   local aFont          := aGetFont( oWnd() )
   local aSizes         := { " 6", " 7", " 8", " 9", "10", "11", "12", "13", "14", "16", "18", "20", "22", "24", "26", "28", "36", "48", "72" }
   local cTxtColor
   local oWidth
   local cWidth
   local oSay1
   local oSay2

   if nMode == APPD_MODE
      aTmp[ ( dbfDet )->( FieldPos( "FACENAME" ) ) ] := "Arial"
      cWidth := " 8"
   else
      cWidth := Str( aTmp[ ( dbfDet )->( FieldPos( "WIDTH" ) ) ], 2 )
   end if

   cEstilo              := cEstilo( aTmp[ ( dbfDet )->( FieldPos( "ITALIC" ) ) ], aTmp[ ( dbfDet )->( FieldPos( "STRIKEOUT" ) ) ] )
   nSeaColor            := aScan( aRgbColor, aTmp[ ( dbfDet )->( FieldPos( "COLOR" ) ) ] )

   if nSeaColor != 0
      cTxtColor         := aStrColor[ nSeaColor ]
   end if

   DEFINE DIALOG oDlg RESOURCE "DetTikItems" TITLE LblTitle( nMode ) + "líneas de tickets"

      REDEFINE GET aTmp[ ( dbfDet )->( FieldPos( "cDescrip" ) ) ] ;
			MEMO ;
         ID       100 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aTmp[ ( dbfDet )->( FieldPos( "mExpresion" ) ) ] ;
			MEMO ;
         ID       110 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE CHECKBOX aGet[ ( dbfDet )->( FieldPos( "lNegrita" ) ) ] VAR aTmp[ ( dbfDet )->( FieldPos( "lNegrita" ) ) ] ;
         ID       120 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE CHECKBOX aGet[ ( dbfDet )->( FieldPos( "lCentrado" ) ) ] VAR aTmp[ ( dbfDet )->( FieldPos( "lCentrado" ) ) ] ;
         ID       130 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE CHECKBOX aGet[ ( dbfDet )->( FieldPos( "lExpandido" ) ) ] VAR aTmp[ ( dbfDet )->( FieldPos( "lExpandido" ) ) ] ;
         ID       140 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE CHECKBOX aGet[ ( dbfDet )->( FieldPos( "lColor" ) ) ] VAR aTmp[ ( dbfDet )->( FieldPos( "lColor" ) ) ] ;
         ID       150 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE COMBOBOX oCbxAjust VAR cCbxAjust ;
         ITEMS    aCbxAjust ;
         BITMAPS  aResAjust ;
         ID       170 ;
         OF       oDlg

      REDEFINE COMBOBOX aGet[ ( dbfDet )->( FieldPos( "FACENAME" ) ) ] VAR aTmp[ ( dbfDet )->( FieldPos( "FACENAME" ) ) ] ;
         ID       190 ;
         ITEMS    aFont ;
         OF       oDlg

      REDEFINE COMBOBOX oWidth VAR cWidth ;
         ID       191 ;
         ITEMS    aSizes ;
         OF       oDlg

      REDEFINE COMBOBOX oEstilo VAR cEstilo ;
         ID       192 ;
         ITEMS    aEstilo ;
         OF       oDlg

      REDEFINE COMBOBOX aGet[ ( dbfDet )->( FieldPos( "COLOR" ) ) ] VAR cTxtColor;
         ID       193;
         ITEMS    aStrColor;
         BITMAPS  aResColor;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfDet )->( FieldPos( "CCONDICION" ) ) ] VAR aTmp[ ( dbfDet )->( FieldPos( "CCONDICION" ) ) ] ;
         ID       200 ;
         OF       oDlg

      REDEFINE SAY oSay1 ;
         ID       888 ;
         OF       oDlg

      REDEFINE SAY oSay2 ;
         ID       889 ;
         OF       oDlg

		REDEFINE BUTTON ;
         ID       500 ;
         OF       oDlg ;
         ACTION   ( aTmp[ ( dbfDet )->( FieldPos( "nAjuste" ) ) ]    := oCbxAjust:nAt ,;
                    aTmp[ ( dbfDet )->( FieldPos( "Italic" ) ) ]     := "Negrita" $ cEstilo ,;
                    aTmp[ ( dbfDet )->( FieldPos( "Strikeout" ) ) ]  := "Cursiva" $ cEstilo ,;
                    aTmp[ ( dbfDet )->( FieldPos( "Width" ) ) ]      := Val( cWidth ),;
                    aTmp[ ( dbfDet )->( FieldPos( "Color" ) ) ]      := aRgbColor[ aGet[ ( dbfDet )->( FieldPos( "Color" ) ) ]:nAt ],;
                    EndTikLines( aTmp, aGet, dbfDet, oBrw, oDlg, nMode ) )

		REDEFINE BUTTON ;
         ID       510 ;
			OF 		oDlg ;
         CANCEL ;
			ACTION 	( oDlg:end() )

   oDlg:bStart := {|| StartDlg( aGet, oWidth, oEstilo, oCbxAjust, oSay1, oSay2, aTmpTik ) }

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| EndTikLines( aTmp, aGet, dbfDet, oBrw, oDlg, nMode ) } )
   end if

   ACTIVATE DIALOG oDlg CENTER

Return ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//

Static Function StartDlg( aGet, oWidth, oEstilo, oCbxAjust, oSay1, oSay2, aTmpTik )

   if aTmpTik[ ( dbfDoc )->( fieldpos( "lUseDriver" ) ) ]
      aGet[ ( dbfDet )->( FieldPos( "lNegrita" ) )  ]:Hide()
      aGet[ ( dbfDet )->( FieldPos( "lCentrado" ) ) ]:Hide()
      aGet[ ( dbfDet )->( FieldPos( "lExpandido" ) )]:Hide()
      aGet[ ( dbfDet )->( FieldPos( "lColor" ) )    ]:Hide()
      aGet[ ( dbfDet )->( FieldPos( "FaceName" ) )  ]:Show()
      aGet[ ( dbfDet )->( FieldPos( "Color" ) )     ]:Show()
      oWidth:Show()
      oEstilo:Show()
      oCbxAjust:Show()
      oSay1:Show()
      oSay2:Show()
   else
      aGet[ ( dbfDet )->( FieldPos( "lNegrita" ) )  ]:Show()
      aGet[ ( dbfDet )->( FieldPos( "lCentrado" ) ) ]:Show()
      aGet[ ( dbfDet )->( FieldPos( "lExpandido" ) )]:Show()
      aGet[ ( dbfDet )->( FieldPos( "lColor" ) )    ]:Show()
      aGet[ ( dbfDet )->( FieldPos( "FaceName" ) )  ]:Hide()
      aGet[ ( dbfDet )->( FieldPos( "Color" ) )     ]:Hide()
      oWidth:Hide()
      oEstilo:Hide()
      oCbxAjust:Hide()
      oSay1:Hide()
      oSay2:Hide()
   end if

return ( .t. )

//----------------------------------------------------------------------------//

Static Function EndTikLines( aTmp, aGet, dbfDet, oBrw, oDlg, nMode )

   if Empty( aTmp[ ( dbfDet )->( FieldPos( "mExpresion" ) ) ] )
      msgStop( "La expresión esta vacía" )
      Return nil
   end if

   WinGather( aTmp, aGet, dbfDet, oBrw, nMode, nil, .f. )

Return ( oDlg:end( IDOK ) )

//---------------------------------------------------------------------------//

STATIC FUNCTION ActTitle( nKey, nFlags, oGet, nMode, oDlg )

   oGet:Assign()
	oDlg:cTitle( "Documento : " + rtrim( oGet:varGet() ) + Chr( nKey ) )

RETURN NIL

//--------------------------------------------------------------------------//

static function DocDelRec( oBrw )

   local cCodDoc  := ( dbfDoc )->cCodigo

   if dbDelRec( oBrw, dbfDoc )

      while ( dbfDet )->( dbSeek( cCodDoc ) ) .and. !( dbfDet )->( eof() )
         if ( dbfDet )->( dbRLock() )
            ( dbfDet )->( dbDelete() )
            ( dbfDet )->( dbUnLock() )
         end if
      end while

   end if

return .t.

//----------------------------------------------------------------------------//

Static Function ExpDoc( oWndBrw )

   local oDlg
   local oGetFile
   local cGetFile    := Padr( "A:\Docs.Zip", 100 )

   DEFINE DIALOG oDlg RESOURCE "EXPDOCS"

      REDEFINE SAY PROMPT ( dbfDoc )->cDescrip ;
         ID       100 ;
         OF       oDlg

      REDEFINE GET oGetFile VAR cGetFile ;
         ID       110 ;
         BITMAP   "FOLDER" ;
         ON HELP  ( oGetFile:cText( Padr( cGetFile( "*.zip", "Seleccion de Fichero" ), 100 ) ) ) ;
			OF 		oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         ACTION   ( oDlg:Disable(), if( ExeExpDoc( Rtrim( cGetFile ) ), oDlg:Enable():End(), oDlg:Enable() ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

      REDEFINE BUTTON ;
         ID       559 ;
			OF 		oDlg ;
         ACTION   ( ChmHelp( "Formato_de_tickets" ) )

   oDlg:AddFastKey( VK_F5, {|| oDlg:Disable(), if( ExeExpDoc( Rtrim( cGetFile ) ), oDlg:Enable():End(), oDlg:Enable() ) } )
   oDlg:AddFastKey( VK_F1, {|| ChmHelp( "Formato_de_tickets" ) } )

	ACTIVATE DIALOG oDlg CENTER

Return ( nil )

//---------------------------------------------------------------------------//

Static Function ExeExpDoc( cGetFile, oDlg )

   local oBlock
   local oError
   local aDir
   local nZip
   local tmpDoc
   local tmpDet
   local nHandle     := 0
   local lExport     := .t.
   local nOrdAnt     := ( dbfDoc )->( OrdSetFocus( "cCodigo" ) )
   local nRecAnt     := ( dbfDoc )->( Recno() )
   local cCodDoc     := ( dbfDoc )->cCodigo

   mkTikItems( cPatTmp(), , , , cLocalDriver() )

   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      USE ( cPatTmp() + "RTikDoc.Dbf" ) NEW SHARED VIA ( cLocalDriver() ) ALIAS ( cCheckArea( "RTikDoc", @tmpDoc ) )
      SET ADSINDEX TO ( cPatTmp() + "RTikDoc.Cdx" ) ADDITIVE

      USE ( cPatTmp() + "RTikDet.Dbf" ) NEW SHARED VIA ( cLocalDriver() ) ALIAS ( cCheckArea( "RTikDet", @tmpDet ) )
      SET ADSINDEX TO ( cPatTmp() + "RTikDet.Cdx" ) ADDITIVE

      if ( dbfDoc )->( dbSeek( cCodDoc ) )
         while ( dbfDoc )->cCodigo == cCodDoc .and. !( dbfDoc )->( eof() )
            dbPass( dbfDoc, tmpDoc, .t. )
            ( dbfDoc )->( dbSkip() )
         end while
      end if

      if ( dbfDet )->( dbSeek( cCodDoc ) )
         while ( dbfDet )->cCodigo == cCodDoc .and. !( dbfDet )->( eof() )
            dbPass( dbfDet, tmpDet, .t. )
            ( dbfDet )->( dbSkip() )
         end while
      end if

   RECOVER USING oError

      lExport  := .f.

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !Empty( tmpDoc )
      ( tmpDoc )->( dbCloseArea() )
   end if

   if !Empty( tmpDet )
      ( tmpDet )->( dbCloseArea() )
   end if

   ( dbfDoc )->( OrdSetFocus( nOrdAnt ) )
   ( dbfDoc )->( dbGoTo( nRecAnt ) )

   /*
   Comprobamos antes de crear el zip-------------------------------------------
   */

   if lExport

      nHandle := fCreate( cGetFile )
      if nHandle == -1

         MsgStop( "Ruta no válida" )

         Return ( .f. )

      else

         if fClose( nHandle ) .and. ( fErase( cGetFile ) == 0 )

            /*
            Creamos el zip-----------------------------------------------------
            */

            aDir     := Directory( cPatTmp() + "RTik*.*" )

            #ifdef __HARBOUR__

            hb_SetDiskZip( {|| nil } )
            aEval( aDir, { | cName, nIndex | hb_ZipFile( cGetFile, cPatTmp( .t., .t. ) + cName[ 1 ], 9 ) } )
            hb_gcAll()

            #else

            nZip     := ZipCreate( cGetFile )
            if nZip  != F_ERROR
               aEval( aDir, { | cName, nIndex | ZipAddFile( nZip, cPatTmp( .t., .t. ) + cName[ 1 ] ) } )
               ZipClose( nZip )
            end if

            #endif

            msgInfo( "Documento exportado satisfactoriamente" )

            EraseFilesInDirectory(cPatTmp(), "RTik*.*" )

         else

            MsgStop( "Error en la unidad" )

            Return ( .f. )

         end if

      end if

   end if

Return ( lExport )

//---------------------------------------------------------------------------//

Static Function GetDoc( oWndBrw )

   local oDlg
   local oGetFile
   local cGetFile    := Padr( "A:\Docs.Zip", 100 )
   local oSayProc
   local cSayProc    := ""

   DEFINE DIALOG oDlg RESOURCE "IMPDOCS"

      REDEFINE GET oGetFile VAR cGetFile ;
         ID       100 ;
         BITMAP   "FOLDER" ;
         ON HELP  ( oGetFile:cText( Padr( cGetFile( "*.zip", "Selección de fichero" ), 100 ) ) ) ;
			OF 		oDlg

      REDEFINE SAY oSayProc PROMPT cSayProc ;
         ID       110 ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         ACTION   ( ExeGetDoc( Rtrim( cGetFile ), oSayProc, oDlg ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

      REDEFINE BUTTON ;
         ID       559 ;
			OF 		oDlg ;
         ACTION   ( ChmHelp( "Formato_de_tickets" ) )

   oDlg:AddFastKey( VK_F5, {|| ExeGetDoc( Rtrim( cGetFile ), oSayProc, oDlg ) } )
   oDlg:AddFastKey( VK_F1, {|| ChmHelp( "Formato_de_tickets" ) } )

	ACTIVATE DIALOG oDlg CENTER

   if oWndBrw != nil
      oWndBrw:Refresh()
   end if

Return ( nil  )

//---------------------------------------------------------------------------//

Static Function ExeGetDoc( cGetFile, oSayProc, oDlg )

   local oBlock
   local oError
   local nZip
   local tmpDoc
   local tmpDet
   #ifdef __HARBOUR__
   local aFiles
   #endif

   if !file( cGetFile )
      MsgStop( "El fichero " + cGetFile + " no existe." )
      return .f.
   end if

   #ifdef __HARBOUR__

   aFiles            := Hb_GetFilesInZip( cGetFile )
   if !Hb_UnZipFile( cGetFile, , , , cPatTmp(), aFiles )
      MsgStop( "No se ha descomprimido el fichero " + cGetFile, "Error" )
      Return .f.
   end if
   hb_gcAll()

   #else

   nZip              := UnZipOpen( cGetFile )
   if nZip != F_ERROR
      aEval( UnZipDirectory( nZip ), { | cName | UnZipExtractFile( nZip, cName ) } )
      UnZipClose( nZip )
   else
      Return .f.
   end if

   #endif

   if !lExistTable( cPatTmp() + "RTikDoc.Dbf" )   .or.;
      !lExistTable( cPatTmp() + "RTikDet.Dbf" )
      MsgStop( "Faltan ficheros para importar el documento" )
      return .f.
   end if

   oDlg:Disable()

   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatTmp() + "RTikDoc.Dbf" ) NEW SHARED VIA ( cDriver() )ALIAS ( cCheckArea( "RTikDoc", @tmpDoc ) )

   USE ( cPatTmp() + "RTikDet.Dbf" ) NEW SHARED VIA ( cDriver() )ALIAS ( cCheckArea( "RTikDet", @tmpDet ) )

   oSayProc:SetText( "Importando documento" )

   while ( dbfDoc )->( dbSeek( ( tmpDoc )->cCodigo ) ) .and. !( dbfDoc )->( eof() )
      if ( dbfDoc )->( dbRLock() )
         ( dbfDoc )->( dbDelete() )
      end if
   end while

   while !( tmpDoc )->( eof() )
      dbPass( tmpDoc, dbfDoc, .t. )
      ( tmpDoc )->( dbSkip() )
   end while

   oSayProc:SetText( "Importando líneas" )

   while ( dbfDet )->( dbSeek( ( tmpDoc )->cCodigo ) ) .and. !( dbfDet )->( eof() )
      if ( dbfDet )->( dbRLock() )
         ( dbfDet )->( dbDelete() )
      end if
   end while

   while !( tmpDet )->( eof() )
      dbPass( tmpDet, dbfDet, .t. )
      ( tmpDet )->( dbSkip() )
   end while

   oSayProc:SetText( "Proceso finalizado" )

   msgInfo( "Documento importado satisfactoriamente" )

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !Empty( tmpDoc )
      ( tmpDoc )->( dbCloseArea() )
   end if

   if !Empty( tmpDet )
      ( tmpDet )->( dbCloseArea() )
   end if

   /*
   Eliminar todos los ficheros-------------------------------------------------
   */

   EraseFilesInDirectory(cPatTmp(), "*.*" )

   oDlg:Enable():End()

Return .t.

//---------------------------------------------------------------------------//

Function BrwTikItems( oGet, oGet2 )

	local oDlg
	local oGet1
	local cGet1
	local oBrw
   local nOrd        := GetBrwOpt( "BrwTikItems" )
	local oCbxOrd
   local aCbxOrd     := { "Código", "Nombre" }
   local cCbxOrd
   local nLevel      := Auth():Level( "01086" )
   local nRec

   nOrd              := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd           := aCbxOrd[ nOrd ]

   OpenFiles()

   nRec              := ( dbfDoc )->( RecNo() )
   ( dbfDoc )->( dbGoTop() )

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Seleccionar formatos de tickets"

		REDEFINE GET oGet1 VAR cGet1;
			ID 		104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfDoc ) );
         VALID    ( OrdClearScope( oBrw, dbfDoc ) );
         BITMAP   "FIND" ;
         OF       oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( ( dbfDoc )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:Refresh(), oGet1:SetFocus() ) ;
			OF 		oDlg

      REDEFINE LISTBOX oBrw ;
         FIELDS   ( dbfDoc )->cCodigo,;
                  ( dbfDoc )->cDescrip;
         HEAD     "Código",;
                  "Nombre";
         SIZES ;
                  60,;
                  200;
         ALIAS    ( dbfDoc );
         ID       105 ;
         OF       oDlg

         oBrw:bLDblClick   := {|| oDlg:end( IDOK ) }
         oBrw:aActions     := {| nCol | lPressCol( nCol, oBrw, oCbxOrd, aCbxOrd, dbfDoc ) }

		REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( oDlg:end(IDOK) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

		REDEFINE BUTTON ;
         ID       500 ;
         OF       oDlg ;
         WHEN     ( nAnd( nLevel, ACC_APPD ) != 0 ) ;
         ACTION   ( WinAppRec( oBrw, bEdtTikItems, dbfDoc ) );

		REDEFINE BUTTON ;
         ID       501 ;
         OF       oDlg ;
         WHEN     ( nAnd( nLevel, ACC_EDIT ) != 0 ) ;
         ACTION   ( WinEdtRec( oBrw, bEdtTikItems, dbfDoc ) )

   oDlg:AddFastKey( VK_F2,       {|| if( nAnd( nLevel, ACC_APPD ) != 0, WinAppRec( oBrw, bEdtTikItems, dbfDoc ), ) } )
   oDlg:AddFastKey( VK_F3,       {|| if( nAnd( nLevel, ACC_EDIT ) != 0, WinEdtRec( oBrw, bEdtTikItems, dbfDoc ), ) } )
   oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )
   oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK

      oGet:cText( ( dbfDoc )->cCodigo )
		oGet:lValid()

      if ValType( oGet2 ) == "O"
         oGet2:cText( ( dbfDoc )->cDescrip )
      end if

   end if

	oGet:setFocus()

   DestroyFastFilter( dbfDoc )

   SetBrwOpt( "BrwTikItems", ( dbfDoc )->( OrdNumber() ) )

   ( dbfDoc )->( dbGoTo( nRec ) )

   CloseFiles()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Function cTikItems( oGet, dbfDoc, oGet2 )

   local lValid   := .f.
	local xValor 	:= oGet:varGet()

   if Empty( xValor )
      if oGet2 != nil
			oGet2:cText( "" )
      end if
      return .t.
   end if

   if ( dbfDoc )->( dbSeek( xValor ) )

      oGet:cText( ( dbfDoc )->cCodigo )

      if oGet2 != nil
         oGet2:cText( ( dbfDoc )->cDescrip )
      end if

      lValid      := .t.

   else

      msgStop( "Código de formato de tickets no encontrado" )

   end if

Return lValid

//---------------------------------------------------------------------------//

Function nPadPrinters( nPad )

   local nPadPrinters   := 0

   do case
      case nPad == 1
         nPadPrinters   := 0
      case nPad == 2
         nPadPrinters   := 2
      case nPad == 3
         nPadPrinters   := 1
   end case

Return( nPadPrinters )