#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "HbCom.ch"


#define NOPARITY            0
#define ODDPARITY           1
#define EVENPARITY          2
#define MARKPARITY          3
#define SPACEPARITY         4

#define ONESTOPBIT          0
#define ONESTOPBITS         1
#define TWOSTOPBITS         2

#define IE_BADID           -1
#define IE_OPEN            -2
#define IE_NOPEN           -3
#define IE_MEMORY          -4
#define IE_DEFAULT         -5
#define IE_HARDWARE        -10
#define IE_BYTESIZE        -11
#define IE_BAUDRATE        -12

#define BUFFER             100

static oWndBrw
static dbfImpTik
static bEdit         := { |aTmp, aGet, dbfImpTik, oBrw, bWhen, bValid, nMode | EdtRec( aTmp, aGet, dbfImpTik, oBrw, bWhen, bValid, nMode ) }

//----------------------------------------------------------------------------//
/*
Abre las bases de datos necesarias
*/

STATIC FUNCTION OpenFiles()

   local lOpen       := .t.
   local oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      USE ( cPatDat() + "IMPTIK.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "IMPTIK", @dbfImpTik ) )
      SET ADSINDEX TO ( cPatDat() + "IMPTIK.CDX" ) ADDITIVE

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//
/*
Cierra las bases de datos
*/

STATIC FUNCTION CloseFiles()

   if dbfImpTik != nil
      ( dbfImpTik )->( dbCloseArea() )
   end if

   dbfImpTik  := nil
   oWndBrw    := nil

RETURN .T.

//----------------------------------------------------------------------------//
/*
Monta el Brws principal de ubicaciones
*/

FUNCTION ConfImpTiket( oMenuItem, oWnd )

   local nLevel

   DEFAULT  oMenuItem   := "01090"
   DEFAULT  oWnd        := oWnd()

   if oWndBrw == NIL

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
         return Nil
      end if

      /*
      Anotamos el movimiento para el navegador
      */

      AddMnuNext( "Balanzas", ProcName() )

   DEFINE SHELL oWndBrw FROM 2, 10 TO 18, 70 ;
      XBROWSE;
      TITLE    "Balanzas" ;
      PROMPT   "Código",;
               "Descripción";
      MRU      "gc_balance_16";
      BITMAP   "WebTopGreen" ;
      ALIAS    ( dbfImpTik ) ;
      APPEND   ( WinAppRec( oWndBrw:oBrw, bEdit, dbfImpTik ) ) ;
      EDIT     ( WinEdtRec( oWndBrw:oBrw, bEdit, dbfImpTik ) ) ;
      DELETE   ( WinDelRec( oWndBrw:oBrw, dbfImpTik ) );
      DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdit, dbfImpTik ) ) ;
      LEVEL    nLevel ;
      OF       oWnd

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodImp"
         :bEditValue       := {|| ( dbfImpTik )->cCodImp }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Descripción"
         :cSortOrder       := "cNomImp"
         :bEditValue       := {|| ( dbfImpTik )->cNomImp }
         :nWidth           := 280
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

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

      DEFINE BTNSHELL RESOURCE "DUP" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( oWndBrw:RecDup() );
			TOOLTIP 	"(D)uplicar";
         MRU ;
         HOTKEY   "D";
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
         ACTION   ( WinZooRec( oWndBrw:oBrw, bEdit, dbfImpTik ) );
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

      DEFINE BTNSHELL RESOURCE "END" GROUP OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:end() ) ;
			TOOLTIP 	"(S)alir" ;
			HOTKEY 	"S"

		ACTIVATE WINDOW oWndBrw VALID ( CloseFiles() )

   else

		oWndBrw:SetFocus()

   end if

RETURN NIL

//----------------------------------------------------------------------------//
/*
Funcion que edita el registro de la base de datos
*/

STATIC FUNCTION EdtRec( aTmp, aGet, dbfImpTik, oBrw, bWhen, bValid, nMode )

   local oDlg
   local oPort
   local cPort
   local oBitsSec
   local oBitsParada
   local oBitsDatos
   local oBitsParidad
   local cBitsSec
   local cBitsParada
   local cBitsDatos
   local cBitsParidad
   local aBitsSec       := { "2400", "4800", "9600", "19200", "38400", "57600", "115200", "203400", "460800", "921600" }
   local aBitsParada    := { "0", "1", "2" }
   local aBitsDatos     := { "7", "8" }
   local aBitsParidad   := { "Sin paridad", "Paridad par", "Paridad impar" }
   local aPort          := { "COM1", "COM2", "COM3", "COM4", "COM5", "COM6", "COM7", "COM8", "COM9", "COM10", "COM11", "COM12", "COM13", "COM14", "COM15", "COM16", "COM17", "COM18" }

   if nMode == APPD_MODE
      cPort             := "COM1"
      cBitsSec          := "9600"
      cBitsParada       := "0"
      cBitsDatos        := "8"
      cBitsParidad      := "Sin paridad"
      aTmp[ ( dbfImpTik )->( FieldPos( "nRetardo" ) ) ]  := 0
   else
      cPort             := aTmp[ ( dbfImpTik )->( FieldPos( "cPort" ) ) ]
      cBitsSec          := Str( aTmp[ ( dbfImpTik )->( FieldPos( "nBitsSec" ) ) ] )
      cBitsParada       := Str( aTmp[ ( dbfImpTik )->( FieldPos( "nBitsPara" ) ) ] )
      cBitsDatos        := Str( aTmp[ ( dbfImpTik )->( FieldPos( "nBitsDatos" ) ) ] )
      cBitsParidad      := aTmp[ ( dbfImpTik )->( FieldPos( "cBitsPari" ) ) ]
   end if

   // Montamos el diálogo------------------------------------------------------

   DEFINE DIALOG oDlg RESOURCE "Balanza" TITLE LblTitle( nMode ) + " balanzas"

      // Grupo general---------------------------------------------------------

      REDEFINE GET aGet[ ( dbfImpTik )->( FieldPos( "cCodImp" ) ) ] ;
         VAR      aTmp[ ( dbfImpTik )->( FieldPos( "cCodImp" ) ) ] ;
         UPDATE ;
         ID       80 ;
         WHEN     ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) ;
         VALID    ( NotValid( aGet[ ( dbfImpTik )->( FieldPos( "cCodImp" ) ) ], dbfImpTik, .t., "0" ) ) ;
			PICTURE 	"@!" ;
			OF 		oDlg

      REDEFINE GET aGet[ ( dbfImpTik )->( FieldPos( "cNomImp" ) ) ] ;
         VAR      aTmp[ ( dbfImpTik )->( FieldPos( "cNomImp" ) ) ] ;
         ID       90 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE COMBOBOX oPort VAR cPort;
         ITEMS    aPort ;
         ID       160;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( oDlg:aEvalWhen() );
         OF       oDlg

      REDEFINE COMBOBOX oBitsSec VAR cBitsSec ;
         WHEN     ( nMode != ZOOM_MODE );
         ITEMS    aBitsSec ;
         ID       170;
         OF       oDlg

      REDEFINE COMBOBOX oBitsParada VAR cBitsParada ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ITEMS    aBitsParada ;
         ID       180;
         OF       oDlg

      REDEFINE COMBOBOX oBitsDatos VAR cBitsDatos ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ITEMS    aBitsDatos ;
         ID       190;
         OF       oDlg

      REDEFINE COMBOBOX oBitsParidad VAR cBitsParidad ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ITEMS    aBitsParidad ;
         ID       200;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       552;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( TestBalanza( cBitsSec, cBitsDatos, cBitsParada, cBitsParidad, cPort, aTmp[ ( dbfImpTik )->( FieldPos( "cEntub" ) ) ] ) )

      /*
      Grupo propiedades de la impresora
      */

      REDEFINE GET aGet[ ( dbfImpTik )->( FieldPos( "cActCentr" ) ) ] ;
         VAR      aTmp[ ( dbfImpTik )->( FieldPos( "cActCentr" ) ) ];
         ID       100;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfImpTik )->( FieldPos( "nRetardo" ) ) ];
         VAR      aTmp[ ( dbfImpTik )->( FieldPos( "nRetardo" ) ) ];
         SPINNER ;
         ON UP    aGet[ ( dbfImpTik )->( FieldPos( "nRetardo" ) ) ]:cText( aGet[ ( dbfImpTik )->( FieldPos( "nRetardo" ) ) ]:Value + .1 ) ;
         ON DOWN  aGet[ ( dbfImpTik )->( FieldPos( "nRetardo" ) ) ]:cText( aGet[ ( dbfImpTik )->( FieldPos( "nRetardo" ) ) ]:Value - .1 ) ;
         PICTURE  "@E 9.99" ;
         ID       210;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE CHECKBOX aGet[ ( dbfImpTik )->( FieldPos( "lOpenRead" ) ) ] ;
         VAR      aTmp[ ( dbfImpTik )->( FieldPos( "lOpenRead" ) ) ] ;
         ID       220 ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfImpTik )->( FieldPos( "cEntub" ) ) ];
         VAR      aTmp[ ( dbfImpTik )->( FieldPos( "cEntub" ) ) ];
         ID       230;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      // Boton defecto---------------------------------------------------------

      REDEFINE BUTTON ;
         ID       553 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( lDefecto( aGet, oPort, oBitsSec, oBitsParada, oBitsDatos, oBitsParidad ) )

      // Botones del diálogo---------------------------------------------------

      REDEFINE BUTTON ;
         ID       500 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( EndTrans( aTmp, aGet, dbfImpTik, oBrw, nMode, oDlg, cPort, cBitsSec, cBitsParada, cBitsDatos, cBitsParidad ) )

		REDEFINE BUTTON ;
         ID       550 ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

   // Teclas rápidas

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| EndTrans( aTmp, aGet, dbfImpTik, oBrw, nMode, oDlg, cPort, cBitsSec, cBitsParada, cBitsDatos, cBitsParidad ) } )
   end if

   oDlg:bStart    := {|| aGet[ ( dbfImpTik )->( FieldPos( "cCodImp" ) ) ]:SetFocus() }

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//
/*
Funcion que termina la edición del registro de la base de datos
*/

STATIC FUNCTION EndTrans( aTmp, aGet, dbfImpTik, oBrw, nMode, oDlg, cPort, cBitsSec, cBitsParada, cBitsDatos, cBitsParidad )

   // "Comprobamos que el código no esté vacío y que no exista"

   if nMode == APPD_MODE .or. nMode == DUPL_MODE

      if Empty( aTmp[ ( dbfImpTik )->( FieldPos( "cCodImp" ) ) ] )
         MsgStop( "El código de la balanza no puede estar vacío" )
         aGet[ ( dbfImpTik )->( FieldPos( "cCodImp" ) ) ]:SetFocus()
         Return nil
      end if

      if dbSeekInOrd( aTmp[ ( dbfImpTik )->( FieldPos( "cCodImp" ) ) ], "CCODIMP", dbfImpTik )
         msgStop( "Código existente" )
         return nil
      end if

   end if

   // "Comprobamos que el nombre no esté vacío"

   if Empty( aTmp[ ( dbfImpTik )->( FieldPos( "cNomImp" ) ) ] )
      MsgStop( "El nombre de la balanza no puede estar vacío" )
      aGet[ ( dbfImpTik )->( FieldPos( "cNomImp" ) ) ]:SetFocus()
      Return .f.
   end if

   // "Metemos los valores de los combos"

   aTmp[ ( dbfImpTik )->( FieldPos( "cPort" ) ) ]      := cPort
   aTmp[ ( dbfImpTik )->( FieldPos( "nBitsSec" ) ) ]   := Val( cBitsSec )
   aTmp[ ( dbfImpTik )->( FieldPos( "nBitsPara" ) ) ]  := Val( cBitsParada )
   aTmp[ ( dbfImpTik )->( FieldPos( "nBitsDatos" ) ) ] := Val( cBitsDatos )
   aTmp[ ( dbfImpTik )->( FieldPos( "cBitsPari" ) ) ]  := cBitsParidad

   // "Escribimos definitivamente la temporal a la base de datos"

   WinGather( aTmp, aGet, dbfImpTik, oBrw, nMode )

RETURN ( oDlg:end( IDOK ) )

//---------------------------------------------------------------------------//
/*
Funcion que crea las bases de datos necesarias
*/

FUNCTION mkImpTik( cPath, lAppend, cPathOld, oMeter )

   local oImpTik

   DEFAULT cPath     := cPatDat()
	DEFAULT lAppend	:= .f.

   DEFINE DATABASE oImpTik FILE "IMPTIK.DBF" PATH ( cPath ) ALIAS "IMPTIK" VIA ( cDriver() ) COMMENT "Impresoras de tickets"

      FIELD NAME "CCODIMP"       TYPE "C" LEN  3  DEC 0 COMMENT "Código de la impresora de ticket"       OF oImpTik
      FIELD NAME "CNOMIMP"       TYPE "C" LEN 35  DEC 0 COMMENT "Nombre de la impresora de ticket"       OF oImpTik
      FIELD NAME "LWIN"          TYPE "L" LEN  1  DEC 0 COMMENT "Lógico para utilizar driver de windows" OF oImpTik
      FIELD NAME "CNOMPRN"       TYPE "C" LEN 254 DEC 0 COMMENT "Nombre de la impresora seleccionada"    OF oImpTik
      FIELD NAME "CPORT"         TYPE "C" LEN 50  DEC 0 COMMENT "Puerto de la impresora"                 OF oImpTik
      FIELD NAME "NBITSSEC"      TYPE "N" LEN  6  DEC 0 COMMENT "Bit segundos"                           OF oImpTik
      FIELD NAME "NBITSPARA"     TYPE "N" LEN  1  DEC 0 COMMENT "Bit de parada"                          OF oImpTik
      FIELD NAME "NBITSDATOS"    TYPE "N" LEN  1  DEC 0 COMMENT "Bit de datos"                           OF oImpTik
      FIELD NAME "CBITSPARI"     TYPE "C" LEN 50  DEC 0 COMMENT "Bit de paridad"                         OF oImpTik
      FIELD NAME "CACTCENTR"     TYPE "C" LEN 50  DEC 0 COMMENT "Activar centrado"                       OF oImpTik
      FIELD NAME "CDESCENTR"     TYPE "C" LEN 50  DEC 0 COMMENT "Desactivar centrado"                    OF oImpTik
      FIELD NAME "CACTNEGR"      TYPE "C" LEN 50  DEC 0 COMMENT "Activar negrita"                        OF oImpTik
      FIELD NAME "CDESNEGR"      TYPE "C" LEN 50  DEC 0 COMMENT "Desactivar negrita"                     OF oImpTik
      FIELD NAME "CACTEXP"       TYPE "C" LEN 50  DEC 0 COMMENT "Activar expandida"                      OF oImpTik
      FIELD NAME "CDESEXP"       TYPE "C" LEN 50  DEC 0 COMMENT "Desactivar expandida"                   OF oImpTik
      FIELD NAME "CACTCOLOR"     TYPE "C" LEN 50  DEC 0 COMMENT "Activar color"                          OF oImpTik
      FIELD NAME "CDESCOLOR"     TYPE "C" LEN 50  DEC 0 COMMENT "Desactivar color"                       OF oImpTik
      FIELD NAME "CSALTO"        TYPE "C" LEN 50  DEC 0 COMMENT "Salto de página"                        OF oImpTik
      FIELD NAME "CCORTE"        TYPE "C" LEN 50  DEC 0 COMMENT "Corte del papel"                        OF oImpTik
      FIELD NAME "NRETARDO"      TYPE "N" LEN  4  DEC 2 COMMENT "Tiempo de retardo" PICTURE "@E 9.99"    OF oImpTik
      FIELD NAME "LOPENREAD"     TYPE "L" LEN  1  DEC 0 COMMENT "Lógico abrir el puerto cada lectura"    OF oImpTik
      FIELD NAME "CENTUB"        TYPE "C" LEN  1  DEC 0 COMMENT "Entubamiento"                           OF oImpTik

      INDEX TO "IMPTIK.CDX" TAG CCODIMP ON CCODIMP NODELETED OF oImpTik

   END DATABASE oImpTik

   oImpTik:Activate( .f., .f. )

   if lAppend .and. !Empty( cPathOld ) .and. lExistTable( cPathOld + "IMPTIK.DBF" )
      oImpTik:AppendFrom( cPathOld + "IMPTIK.DBF" )
   end if

   oImpTik:end()

RETURN .t.

//--------------------------------------------------------------------------//
/*Funcion que crea los índices de las bases de datos*/

FUNCTION rxImpTik( cPath, oMeter )

   local dbfImpTik

   DEFAULT cPath := cPatDat()

   if !lExistTable( cPath + "IMPTIK.DBF" )
      mkImpTik( cPath )
   end if

   if lExistIndex( cPath + "IMPTIK.CDX" )
      fErase( cPath + "IMPTIK.CDX" )
   end if

   if lExistTable( cPath + "IMPTIK.DBF" )

      dbUseArea( .t., cDriver(), cPath + "IMPTIK.DBF", cCheckArea( "IMPTIK", @dbfImpTik ), .f. )

      if !( dbfImpTik )->( neterr() )

         ( dbfImpTik )->( __dbPack() )

         ( dbfImpTik )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
         ( dbfImpTik )->( ordCreate( cPath + "IMPTIK.CDX", "CCODIMP", "Field->cCodImp", {|| Field->cCodImp } ) )

         ( dbfImpTik )->( dbCloseArea() )

      else

         msgStop( "Imposible abrir en modo exclusivo impresoras de tickets" )

      end if

   end if

Return nil

//---------------------------------------------------------------------------//

Static Function lDefecto( aGet, oPort, oBitsSec, oBitsParada, oBitsDatos, oBitsParidad )

   //Da los valores por defecto

   oPort:oGet:cText(       "COM1" )
   oBitsSec:oGet:cText(    "9600" )
   oBitsParada:oGet:cText( "0" )
   oBitsDatos:oGet:cText(  "8" )
   oBitsParidad:oGet:cText("Sin paridad" )

   aGet[ ( dbfImpTik )->( FieldPos( "cActCEntr" ) ) ]:cText( Padr( "98000001" + Chr( 13 ) + Chr( 10 ) + Chr( 13 ) + Chr( 10 ), 100 ) )
   aGet[ ( dbfImpTik )->( FieldPos( "nRetardo"  ) ) ]:cText( 0 )

   //Refresca los objetos

Return .t.

//---------------------------------------------------------------------------//
/*
Test de la impresora de tickets
*/

Static Function TestBalanza( cBitsSec, cBitsDatos, cBitsPara, cBitsPari, cPuerto, cEntub )

   local oPrn
   
   // Creamos el puerto---------------------------------------------------------

   oPrn   := TCommPort():New( cPuerto, cBitsSec, cBitsPara, cBitsDatos, cBitsPari, cEntub )

   if oPrn != nil

      if oPrn:OpenPort()

         msgInfo( "Puerto  : " + cPuerto                        + CRLF +;
                  "Bit     : " + cBitsSec                       + CRLF +;
                  "Parada  : " + cBitsPara                      + CRLF +;
                  "Dato    : " + cBitsDatos                     + CRLF +;
                  "Paridad : " + cBitsPari                      + CRLF +;
                  "Peso    : " + oPrn:Read(),;
                  "Puerto creado" )

         oPrn:ClosePort()
         oPrn:End()

      end if

   else

     msgStop( "Puerto  : " + cPuerto               + CRLF +;
              "Bit     : " + cBitsSec              + CRLF +;
              "Parada  : " + cBitsPara             + CRLF +;
              "Dato    : " + cBitsDatos            + CRLF +;
              "Paridad : " + cBitsPari             + CRLF +;
              "Puerto no creado" )

   end if

Return .t.

//--------------------------------------------------------------------------//
/*
Browse de la impresora de ticktes
*/

FUNCTION BrwBalanza( oGet, oGet2 )

	local oDlg
	local oBrw
	local oGet1
	local cGet1
	local oCbxOrd
   local aCbxOrd        := { "Código" }
   local cCbxOrd        := "Código"
   local nLevel         := nLevelUsr( "01090" )

   if !OpenFiles()
      Return .f.
   end if

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Seleccionar balanzas"

   REDEFINE GET oGet1 VAR cGet1;
      ID       104 ;
      ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfImpTik ) );
      VALID    ( OrdClearScope( oBrw, dbfImpTik ) );
      BITMAP   "FIND" ;
      OF       oDlg

   REDEFINE COMBOBOX oCbxOrd ;
      VAR      cCbxOrd ;
      ID       102 ;
      ITEMS    aCbxOrd ;
      ON CHANGE( ( dbfImpTik )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:Refresh(), oGet1:SetFocus() ) ;
      OF       oDlg

   oBrw                 := IXBrowse():New( oDlg )

   oBrw:nMarqueeStyle   := 5
   oBrw:lHScroll        := .f.
   oBrw:cAlias          := dbfImpTik

   oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }
   oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }

   oBrw:CreateFromResource( 105 )

   with object ( oBrw:AddCol() )
      :cHeader          := "Código"
      :cSortOrder       := "cCodImp"
      :bEditValue       := {|| ( dbfImpTik )->cCodImp }
      :nWidth           := 80
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
   end with

   with object ( oBrw:AddCol() )
      :cHeader          := "Descripción"
      :cSortOrder       := "cNomImp"
      :bEditValue       := {|| ( dbfImpTik )->cNomImp }
      :nWidth           := 280
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
   end with

   REDEFINE BUTTON ;
      ID       500 ;
      OF       oDlg ;
      WHEN     ( nAnd( nLevel, ACC_APPD ) != 0 );
      ACTION   ( WinAppRec( oBrw, bEdit, dbfImpTik ) )

   REDEFINE BUTTON ;
      ID       501 ;
      OF       oDlg ;
      WHEN     ( nAnd( nLevel, ACC_EDIT ) != 0 );
      ACTION   ( WinEdtRec( oBrw, bEdit, dbfImpTik ) )

   REDEFINE BUTTON ;
      ID       IDOK ;
      OF       oDlg ;
      ACTION   ( oDlg:end( IDOK ) )

   REDEFINE BUTTON ;
      ID       IDCANCEL ;
      OF       oDlg ;
      ACTION   ( oDlg:end() )

   oDlg:AddFastKey( VK_F2,       {|| if( nAnd( nLevel, ACC_APPD ) != 0, WinAppRec( oBrw, bEdit, dbfImpTik ), ) } )
   oDlg:AddFastKey( VK_F3,       {|| if( nAnd( nLevel, ACC_EDIT ) != 0, WinEdtRec( oBrw, bEdit, dbfImpTik ), ) } )
   oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )
   oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK

      oGet:cText( ( dbfImpTik )->cCodImp )
      oGet:lValid()

      if ValType( oGet2 ) == "O"
         oGet2:cText( ( dbfImpTik )->cNomImp )
      end if

   end if

   DestroyFastFilter( dbfImpTik )

   CloseFiles()

   oGet:SetFocus()

RETURN ( .t. )

//---------------------------------------------------------------------------//
/*Browse de la impresora de ticktes*/

FUNCTION cBalanza( oGet, dbfImpTik, oGet2 )

   local lValid   := .f.
   local xValor   := oGet:VarGet()

   if Empty( oGet2 ) .and. !Empty( oGet:oHelpText )
      oGet2       := oGet:oHelpText
   end if

   if Empty( xValor )
      if( oGet2 != nil, oGet2:cText( "" ), )
      return .t.
   else
      xValor   := RJustObj( oGet, "0" )
   end if

   do case
      case Valtype( dbfImpTik ) == "C"

         if ( dbfImpTik )->( dbSeek( xValor ) )
            oGet:cText( ( dbfImpTik )->cCodImp )
            if( oGet2 != nil, oGet2:cText( ( dbfImpTik )->cNomImp ), )
            lValid   := .t.
         else
            oGet:Refresh()
            msgStop( "Balanza no encontrada" )
         end if

      case Valtype( dbfImpTik ) == "O"

         if dbfImpTik:Seek( xValor )
            oGet:cText( dbfImpTik:cCodImp )
            if( oGet2 != nil, oGet2:cText( dbfImpTik:cNomImp ), )
            lValid   := .t.
         else
            oGet:Refresh()
            msgStop( "Balanza no encontrada" )
         end if

   end case

RETURN lValid

//---------------------------------------------------------------------------//
/*Funcion para que siempre haya una impresora por defecto*/

function IsImpTik()

   local oBlock
   local oError
   local dbfImpTik

   if !lExistTable( cPatDat() + "IMPTIK.DBF" )
      mkImpTik( cPatDat() )
   end if

   if !lExistIndex( cPatDat() + "IMPTIK.CDX" )
      rxImpTik( cPatDat() )
   end if

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatDat() + "IMPTIK.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "IMPTIK", @dbfImpTik ) )
   // SET ADSINDEX TO ( cPatDat() + "IMPTIK.CDX" ) ADDITIVE

   ( dbfImpTik )->( __dbLocate( { || ( dbfImpTik )->cCodImp == "000" } ) )

   if!( dbfImpTik )->( Found() )

      ( dbfImpTik )->( dbAppend() )
      ( dbfImpTik )->cCodImp     := "000"
      ( dbfImpTik )->cNomImp     := "Balanza por defecto"
      ( dbfImpTik )->lWin        := .f.
      ( dbfImpTik )->cPort       := "COM1"
      ( dbfImpTik )->nBitsSec    := 9600
      ( dbfImpTik )->nBitsPara   := 1
      ( dbfImpTik )->nBitsDatos  := 8
      ( dbfImpTik )->cBitsPari   := "Sin paridad"
      ( dbfImpTik )->cActCentr   := "27 97 49"
      ( dbfImpTik )->cDesCentr   := "27 97 48"
      ( dbfImpTik )->cActNegr    := ""
      ( dbfImpTik )->cDesNegr    := ""
      ( dbfImpTik )->cActExp     := "27 33 16"
      ( dbfImpTik )->cDesExp     := "27 33 1"
      ( dbfImpTik )->cActColor   := "27 114 49"
      ( dbfImpTik )->cDesColor   := "27 114 48"
      ( dbfImpTik )->cSalto      := "27 100 5"
      ( dbfImpTik )->cCorte      := "27 105"
      ( dbfImpTik )->nRetardo    := 0
      ( dbfImpTik )->( dbUnLock() )

   end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE ( dbfImpTik )

return ( .t. )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TCommPort

   DATA  nPort
   DATA  cPort
   DATA  lCreated       AS LOGIC    INIT .f.
   DATA  lOpen          AS LOGIC    INIT .f.
   DATA  nHComm         AS NUMERIC
   DATA  cLastError
   DATA  nBitsSec
   DATA  nBitsParada
   DATA  nBitsDatos
   DATA  nBitsParidad
   DATA  lOpenToRead    AS LOGIC    INIT .f.
   DATA  nTimeOut
   DATA  cEntubamiento

   DATA  cBuffer

   METHOD New( cPort, nBitsSec, nBitsParada, nBitsDatos, nBitsParidad, lOpenToRead ) CONSTRUCTOR

   METHOD Create( cCodBalanaza )

   METHOD OpenPort()

   METHOD ClosePort()

   //METHOD lBuild()

   METHOD OpenCommError()

   METHOD Write( cTexto )

   METHOD Read()

   METHOD Flush()

   METHOD Close()

   METHOD End()         INLINE ( ::Flush(), ::Close() )

   //------------------------------------------------------------------------//

   METHOD SetBitsSec( nBitsSec )
   METHOD SetBitsParada( nBitsParada )
   METHOD SetBitsDatos( nBitsDatos )
   METHOD SetBitsParidad( cBitsParidad )
   METHOD SetEntubamiento( cEntubamiento )

   METHOD Inicializa()

   METHOD nKilos()
   METHOD nGramos()
   METHOD cPeso()
   METHOD nPeso()       INLINE ( Val( ::Read() ) )

   METHOD ClearString( cString )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( cPort, nBitsSec, nBitsParada, nBitsDatos, cBitsParidad, cEntubamiento ) CLASS TCommPort

   DEFAULT cPort           := "COM1"
   DEFAULT nBitsSec        := "9600"
   DEFAULT nBitsParada     := "1"
   DEFAULT nBitsDatos      := "8"
   DEFAULT cBitsParidad    := "Sin paridad"
   DEFAULT cEntubamiento   := ""

   ::nTimeOut           := 1000
   ::cBuffer            := Space( BUFFER )
   ::lCreated           := .t.

   /*
   Puerto----------------------------------------------------------------------
   */

   ::cPort              := Rtrim( cPort )

   /*
   Velocidad-------------------------------------------------------------------
   */

   ::SetBitsSec( nBitsSec )

   /*
   Bits de parada-----------------------------------------------------------
   */

   ::SetBitsParada( nBitsParada )

   /*
   Bits de datos------------------------------------------------------------
   */

   ::SetBitsDatos( nBitsDatos )

   /*
   Paridad---------------------------------------------------------------------
   */

   ::SetBitsParidad( cBitsParidad )

   /*
   Entubamiento----------------------------------------------------------------
   */

   ::SetEntubamiento( cEntubamiento )

RETURN Self

//----------------------------------------------------------------------------//

METHOD Create( cCodBalanza ) CLASS TCommPort

   local oBlock
   local oError

   local dbfImpTik

   oBlock                     := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      USE ( cPatDat() + "IMPTIK.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "IMPTIK", @dbfImpTik ) )
      SET ADSINDEX TO ( cPatDat() + "IMPTIK.CDX" ) ADDITIVE

      if !Empty( cCodBalanza ) .and. ( dbfImpTik )->( dbSeek( cCodBalanza ) )

         ::cPort              := Rtrim( ( dbfImpTik )->cPort )

         ::SetBitsSec(        ( dbfImpTik )->nBitsSec )
         ::SetBitsParada(     ( dbfImpTik )->nBitsPara )
         ::SetBitsDatos(      ( dbfImpTik )->nBitsDatos )
         ::SetBitsParidad(    ( dbfImpTik )->cBitsPari )
         ::SetEntubamiento(   ( dbfImpTik )->cEntub )

      else

         ::cPort              := "COM1"
         ::nBitsSec           := "9600"
         ::nBitsParada        := "1"
         ::nBitsDatos         := "8"
         ::nBitsParidad       := "Sin paridad"
         ::lOpenToRead        := .f.

      end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !Empty( dbfImpTik )
      ( dbfImpTik )->( dbCloseArea() )
   end if

   dbfImpTik                  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenPort() CLASS TCommPort

   ::lCreated    := .t.
   ::lOpen       := .t.
   ::nPort       := 1

   if ! Empty( ::cPort )
      hb_comSetDevice( ::nPort, ::cPort )
   end if

   if ! hb_comOpen( ::nPort )
      
      ::lCreated    := .f.

   else

      if ! hb_comInit( ::nPort, ::nBitsSec, ::nBitsParidad, ::nBitsDatos, ::nBitsParada )

         ::lOpen    := .f.

      end if

   end if

Return ( ::lCreated .and. ::lOpen )

//---------------------------------------------------------------------------//

METHOD ClosePort() CLASS TCommPort

   hb_comClose( ::nPort )

Return Self

//---------------------------------------------------------------------------//

/*METHOD lBuild( lMessage ) CLASS TCommPort

   local cDCB
   local lBuild         := .t.

   DEFAULT lMessage     := .f.

   ::nHComm             := OpenComm( ::cPort, 1024, 128 )

   if ::nHComm > 0

      if !BuildCommDcb( ::cPort + ":" + ::nBitsSec +"," + ::nBitsParidad + "," + ::nBitsDatos + "," + ::nBitsParada, @cDCB )

         lBuild         := .f.

         if lMessage
            MsgStop( "Error abriendo el puerto : " + Str( GetCommError( ::nHComm ) ) )
         end if

      else

         if !SetCommState( ::nHComm, cDCB )

            lBuild      := .f.

            if lMessage
               MsgStop( "Error en el estado del puerto : " + Str( GetCommError( ::nHComm ) ) )
            end if

         endif

      end if

   else

      ::OpenCommError()

      lBuild            := .f.

      if lMessage
         msgStop( "Puerto  : " + cValToChar( ::cPort )          + CRLF +;
                  "Bits    : " + cValToChar( ::nBitsSec )       + CRLF +;
                  "Parada  : " + cValToChar( ::nBitsParada )    + CRLF +;
                  "Datos   : " + cValToChar( ::nBitsDatos )     + CRLF +;
                  "Paridad : " + cValToChar( ::nBitsParidad ),;
                  ::cLastError )
      end if

      ::Close()

   end if

RETURN ( lBuild )*/

//----------------------------------------------------------------------------//

METHOD OpenCommError() CLASS TCommPort

   if ( ::nHComm >= 0 )
      ::cLastError         := "No error"
	else
		do case
         case ::nHComm == IE_BADID
            ::cLastError   := "ID: Inválido o no soportado"
         case ::nHComm == IE_BAUDRATE
            ::cLastError   := "BAUDIOS: No soportado"
         case ::nHComm == IE_BYTESIZE
            ::cLastError   := "BYTE: Tamaño no válido"
         case ::nHComm == IE_DEFAULT
            ::cLastError   := "Valores por defecto son erroneos"
         case ::nHComm == IE_HARDWARE
            ::cLastError   := "HARDWARE: No presente"
         case ::nHComm == IE_MEMORY
            ::cLastError   := "MEMORIA: Insuficiente"
         case ::nHComm == IE_NOPEN
            ::cLastError   := "HARDWARE: Dispositivo no abierto"
         case ::nHComm == IE_OPEN
            ::cLastError   := "HARDWARE: Dispositivo ya abierto"
			otherwise
            ::cLastError   := "Error no determinado"
		endcase
	endif

Return ( ::nHComm )

//----------------------------------------------------------------------------//

METHOD Write( cTexto, nRetardo ) CLASS TCommPort

   local nWrite      := 0
   local nLenTexto   := len( cTexto )

   DEFAULT nRetardo  := 0

   nWrite            := WriteComm( ::nHComm, cTexto, nLenTexto )

   if nRetardo != 0
      DlgWait( nRetardo )
   end if

return ( nWrite )

//---------------------------------------------------------------------------//

/*METHOD Read( nRetardo ) CLASS TCommPort

   local oWnd
   local nRead
   local cBuffer     := Space( BUFFER )

   DEFAULT nRetardo  := 0

   oWnd              := TWindow():New( -100, -100, -100, -100 )
   oWnd:Activate()

   if ::lOpenToRead
      if !::lBuild()
         Return ( "" )
      end if
   end if

   ::Inicializa()

   Inkey( 0.1 )

   nRead             := ReadComm( ::nHComm, @cBuffer )

   msginfo( nRead, "nRead" )

   if nRead != BUFFER
      cBuffer        := SubStr( cBuffer, 1, nRead )
      ?cBuffer
   end if

   ::cBuffer         := cBuffer

   if nRetardo != 0
      DlgWait( nRetardo )
   end if

   if !Empty( oWnd )
      oWnd:End()
   end if

   if ::lOpenToRead
      ::Close()
   end if

   SysRefresh()

RETURN ( ::cBuffer )*/

//---------------------------------------------------------------------------//

METHOD Read() CLASS TCommPort
   
   local cString     := Space( 250 )
   local nResult

   MsgWait( "Obteniendo peso", "", 0.2 )

   hb_comRecv( ::nPort, @cString, hb_BLen( cString ), ::nTimeOut )

   if !Empty( ::cEntubamiento )
      cString        := ::ClearString( cString )
   end if

Return cString

//---------------------------------------------------------------------------//

METHOD ClearString( cString ) CLASS TCommPort

   local nPos           := 0
   local cClearString   := ""

   /*
   Comprobamos que el primer caracter no sea el entubamiento-------------------
   */

   if SubStr( cString, 1, 1 ) == ::cEntubamiento
      cClearString      := SubStr( cString, 2 )
   else
      cClearString      := cString
   end if

   /*
   Comprobamos que no exista ningún entubamiento más---------------------------
   */

   nPos                 :=  At( ::cEntubamiento, cClearString )

   if nPos != 0
      cClearString      := SubStr( cString, 1, nPos )
   end if

return cClearString

//---------------------------------------------------------------------------//



METHOD Flush() CLASS TCommPort

   ::cBuffer         := ""

   if FlushComm( ::nHComm, 0 ) != 0
      MsgStop( "Error vaciando el puerto : " + Str( GetCommError( ::nHComm ) ) )
   endif

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Close() CLASS TCommPort

   if !Empty( ::nHComm ) .and. !CloseComm( ::nHComm )
      MsgStop( "Error cerrando el puerto : " + Str( GetCommError( ::nHComm ) ) )
   endif

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD SetBitsSec( nBitsSec )

   if ValType( nBitsSec ) != "N"
      ::nBitsSec        := Val( nBitsSec )
   end if

RETURN ( ::nBitsSec )

//------------------------------------------------------------------------//

METHOD SetBitsParada( nBitsParada )

   if ValType( nBitsParada ) != "N"
      ::nBitsParada     := Val( nBitsParada )
   end if

RETURN ( ::nBitsParada )

//------------------------------------------------------------------------//

METHOD SetBitsDatos( nBitsDatos )

   if ValType( nBitsDatos ) != "N"
      ::nBitsDatos      := Val( nBitsDatos )
   end if

RETURN ( ::nBitsDatos )

//------------------------------------------------------------------------//

METHOD SetBitsParidad( cBitsParidad )

   do case
      case Rtrim( cBitsParidad ) == "Sin paridad"
         ::nBitsParidad := "n" // NOPARITY
      case Rtrim( cBitsParidad ) == "Paridad par"
         ::nBitsParidad := "p" // ODDPARITY
      case Rtrim( cBitsParidad ) == "Paridad impar"
         ::nBitsParidad := "i" //EVENPARITY
   end do

RETURN ( ::nBitsParidad )

//------------------------------------------------------------------------//

METHOD SetEntubamiento( cEntub )

   if !Empty( cEntub )
      ::cEntubamiento   := cEntub
   end if

RETURN ( ::cEntubamiento )

//------------------------------------------------------------------------//

METHOD Inicializa()

   local nWrite

   nWrite            := ::Write( "98000001" + Chr( 13 ) + Chr( 10 ) + Chr( 13 ) + Chr( 10 )  )

   if nWrite <= 0
      MsgInfo( "Error realizando la petición a la báscula : " + Str( GetCommError( ::nHComm ) ) )
   end if

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD nKilos()

   local nKilos      := 0

   ::Read()

   if !Empty( ::cBuffer )
      nKilos         := Val( Substr( ::cBuffer, 4, 2 ) )
   end if

RETURN ( nKilos )

//------------------------------------------------------------------------//

METHOD nGramos()

   local nGramos     := 0

   ::Read()

   if !Empty( ::cBuffer )
      nGramos        := Val( Substr( ::cBuffer, 6, 3 ) )
   end if

RETURN ( nGramos )

//------------------------------------------------------------------------//

METHOD cPeso()

   local cPeso       := "0.000"

   ::Read()

   if !Empty( ::cBuffer )
      cPeso          := Substr( ::cBuffer, 4, 2 ) + "." + Substr( ::cBuffer, 6, 3 )
   end if

RETURN ( cPeso )

//------------------------------------------------------------------------//

/*
Method Test() CLASS TCommPort

   Función que lee el peso de una báscula, standard TISA

   En esta función uso fTpvCFG, donde almaceno los distintos valores de configuración
   de la báscula.

   Se pueden cambiar por valores fijos.
   -------------------------------------------------------------------------------
   Creación:Angel 08/03/2007 15:23
   Revisión:Angel 18/04/2007 18:24

local nPesoBascula
Local cDcb, nBytes, nComm , nError, cBuffer:="", cKilos:="", cGramos:="", oMiWnd:=NIL, oSayBascula
Local cPuerto, cVelocidad,cParidad,cDatos,cParada

   cPuerto:=("COM"+Str((fTpvCfg)->BPUERTO,1))
   cVelocidad:=Alltrim(Str((fTpvCfg)->BVELOCIDAD))
   Do Case
     Case (fTpvCfg)->BPARIDAD==1
       cParidad:="n"
     Case (fTpvCfg)->BPARIDAD==2
       cParidad:="p"
     Case (fTpvCfg)->BPARIDAD==3
       cParidad:="i"
   EndCase

   cDatos:=Alltrim(Str((fTpvCfg)->BDATOS))
   cParada:=Alltrim(Str((fTpvCfg)->BPARADA))

   nComm := OpenComm( ::cPort, 1024, 128 )

   if !BuildCommDcb( ::cPort + ":" + ::nBitsSec +"," + ::nBitsParidad + "," + ::nBitsDatos + "," + ::nBitsParada, @cDcb )
      nError = GetCommError( nComm )
      MsgInfo( "Error abriendo el puerto de la báscula : " + Str( nError ) )
   endif

   if !SetCommState( nComm, cDcb )
      nError = GetCommError( nComm )
      MsgInfo( "Error en el estado del puerto de la báscula : " + Str( nError ) )
   endif

   if ( nBytes := WriteComm( nComm, "98000001" + Chr( 13 ) + Chr( 10 ) + Chr( 13 ) + Chr( 10 ) ) ) < 0
      nError = GetCommError( nComm )
      MsgInfo( "Error realizando la petición a la báscula : " + Str( nError ) )
   else
      // Windows requires to have a Window at least to perform comunications !!!
      // Let's use the MessageBox() Window as default

      DEFINE WINDOW oMiWnd FROM 0,0 TO 0,0
      ACTIVATE WINDOW oMiWnd
      Inkey(0.1)

   endif

   cBuffer:=Space(100)

   nBytes := ReadComm (nComm,@cBuffer)

   If FlushComm( nComm, 0 ) != 0
      nError = GetCommError( nComm )
      MsgInfo( "Error vaciando el puerto de la báscula : " + Str( nError ) )
   endif

   if ! CloseComm( nComm )
      nError = GetCommError( nComm )
      MsgInfo( "Error cerrando el puerto de la báscula : " + Str( nError ) )
   endif

   // 1234567890
   // Descompongo la cadena  9900016000000007  -> corresponde a 0,160
   cKilos :=Substr(cBuffer,4,2)
   cGramos:=Substr(cBuffer,6,3)

  nPesoBascula:=Val(Alltrim(cKilos)+"."+Alltrim(cGramos))


  ? nPesoBascula

   if( oMiWnd != nil, oMiWnd:End(), )
   SysRefresh()


Return nPesoBascula
 */

 //-----------------*********************------------------------//
 /*CODIGO BUENO PARA CONECTAR CON LAS BALANZAS
 //LOCAL cString := "ATE0" + Chr( 13 ) + "ATI3" + Chr( 13 )
   LOCAL cString  := Space( 250 )
   LOCAL nTimeOut := 500 // 3000 miliseconds = 3 sec.
   LOCAL nResult
   LOCAL nPort    := 1*/

   /*
   Empezamos a hacer el test con harbour---------------------------------------
   */

   /*IF ! Empty( cPuerto )
      hb_comSetDevice( nPort, cPuerto )
      ?nPort
   ENDIF

   MsgInfo( cBitsSec, "cBitsSec" )
   MsgInfo( cBitsDatos, "cBitsDatos" )
   MsgInfo( cBitsPara, "cBitsPara" )
   MsgInfo( cBitsPari, "cBitsPari" )

   IF ! hb_comOpen( nPort )
      ? "Cannot open port:", nPort, hb_comGetDevice( nPort ), ;
        "error: " + hb_ntos( hb_comGetError( nPort ) )
   ELSE
      ? "port:", hb_comGetDevice( nPort ), "opened"
      IF ! hb_comInit( nPort, 9600, "N", 8, 1 )
         ? "Cannot initialize port to: 9600:N:8:1", ;
           "error: " + hb_ntos( hb_comGetError( nPort ) )
      ELSE
         /*nResult := hb_comSend( nPort, cString )//, hb_BLen( cString ), nTimeOut )
         IF nResult != hb_BLen( cString )
            ? "SEND() failed,", nResult, "bytes sent in", nTimeOut / 1000, ;
              "sec., expected:", hb_BLen( cString ), "bytes."
            ? "error: " + hb_ntos( hb_comGetError( nPort ) )
         ELSE
            ? "SEND() succeeded."
         ENDIF*/

         //WAIT "Press any key to begin reading..."

/*         cString := Space( 250 )
         nResult := hb_comRecv( nPort, @cString, hb_BLen( cString ), nTimeOut )//, hb_BLen( cString ), nTimeOut )
         msginfo( nResult, "nResult" )
         IF nResult == -1
            ? "RECV() failed,", ;
              "error: " + hb_ntos( hb_comGetError( nPort ) )
         ELSE
            ? nResult, "bytes read in", nTimeOut / 1000, "sec."
            ?cString
         ENDIF

      ENDIF

      ? "CLOSE:", hb_comClose( nPort )

   ENDIF*/