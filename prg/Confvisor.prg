#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

static oWndBrw
static dbfVisor
static bEdit      := { |aTmp, aGet, dbfVisor, oBrw, bWhen, bValid, nMode | EdtRec( aTmp, aGet, dbfVisor, oBrw, bWhen, bValid, nMode ) }

//----------------------------------------------------------------------------//

STATIC FUNCTION OpenFiles ()

  local lOpen    := .t.
  local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

  BEGIN SEQUENCE

     if !File ( cPatDat() + "VISOR.DBF" )
        mkVisor( cPatDat() )
     end if

     USE ( cPatDat() + "VISOR.DBF" ) NEW VIA ( cDriver() )SHARE ALIAS ( cCheckArea ( "VISOR", @dbfVisor ) )
     SET ADSINDEX TO ( cPatDat() + "VISOR.CDX" ) ADDITIVE

  RECOVER

     msgStop( "Imposible abrir todas las bases de datos" )
     CloseFiles  ()
     lOpen       := .f.

  END SEQUENCE

  ErrorBlock( oBlock )

RETURN ( lOpen )
//----------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles ()

  if dbfVisor != nil
     ( dbfVisor )-> ( dbCloseArea() )
  end if

  dbfVisor    := nil
  oWndBrw     := nil

RETURN .t.
//----------------------------------------------------------------------------//
/*Monto el Browse principal*/

FUNCTION ConfVisor ( oMenuItem, oWnd )

  local nLevel

  DEFAULT oMenuItem    := "01092"
  DEFAULT oWnd         := oWnd()

  if oWndBrw == nil

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
     Apertura de ficheros------------------------------------------------------
     */

     if !OpenFiles()
        return Nil
     end if

     /*
     Anotamos el movimiento para el navegador----------------------------------
     */

     AddMnuNext( "Configurar visor", ProcName() )

     DEFINE SHELL oWndBrw FROM 2, 10 TO 18, 70 ;
     XBROWSE ;
     TITLE    "Configurar visor" ;
     PROMPT   "Código",;
              "Descripción";
     MRU      "gc_odometer_screw_16";
     BITMAP   "WebTopGreen" ;
     ALIAS    ( dbfVisor ) ;
     APPEND   ( WinAppRec( oWndBrw:oBrw, bEdit, dbfVisor ) ) ;
     EDIT     ( WinEdtRec( oWndBrw:oBrw, bEdit, dbfVisor ) ) ;
     DELETE   ( WinDelRec( oWndBrw:oBrw, dbfVisor ) ) ;
     DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdit, dbfVisor ) ) ;
     LEVEL    nLevel ;
     OF       oWnd

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodVis"
         :bEditValue       := {|| ( dbfVisor )->cCodVis }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Descripción"
         :cSortOrder       := "cNomVis"
         :bEditValue       := {|| ( dbfVisor )->cNomVis }
         :nWidth           := 280
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      oWndBrw:CreateXFromCode()

     DEFINE BTNSHELL RESOURCE "BUS" OF oWndBrw ;
        NOBORDER ;
        ACTION   ( oWndBrw:SearchSetFocus() ) ;
        TOOLTIP  "(B)uscar" ;
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
        ACTION   ( oWndBrw:RecDup() );
        TOOLTIP  "(D)uplicar";
        MRU ;
        HOTKEY   "D";
        LEVEL    ACC_APPD

     DEFINE BTNSHELL RESOURCE "EDIT" OF oWndBrw ;
        NOBORDER ;
        ACTION   ( oWndBrw:RecEdit() );
        TOOLTIP  "(M)odificar";
        MRU ;
        HOTKEY   "M";
        LEVEL    ACC_EDIT

     DEFINE BTNSHELL RESOURCE "ZOOM" OF oWndBrw ;
        NOBORDER ;
        ACTION   ( WinZooRec( oWndBrw:oBrw, bEdit, dbfVisor ) );
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

     DEFINE BTNSHELL RESOURCE "END" GROUP OF oWndBrw ;
        NOBORDER ;
        ACTION   ( oWndBrw:end() ) ;
        TOOLTIP  "(S)alir" ;
        HOTKEY   "S"

     ACTIVATE WINDOW oWndBrw VALID ( CloseFiles() )

  else

     oWndBrw:SetFocus()

  end if

RETURN nil

//--------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aTmp, aGet, dbfVisor, oBrw, bWhen, bValid, nMode )

  local oDlg
  local oPort
  local cPort
  local oBitsSec
  local cBitsSec
  local oBitsParada
  local cBitsParada
  local oBitsDatos
  local cBitsDatos
  local oBitsParidad
  local cBitsParidad
  local aBitsDatos      := { "7", "8" }
  local aBitsParada     := { "0", "1", "2" }
  local aBitsSec        := { "2400", "4800", "9600", "19200", "38400", "57600", "115200", "203400", "460800", "921600" }
  local aBitsParidad    := { "Sin paridad", "Paridad par", "Paridad impar" }
  local aPort           := { "LPT1", "LPT2", "LPT3", "LPT4", "COM1", "COM2", "COM3", "COM4", "COM5", "COM6", "COM7", "COM8", "COM9" }

  if nMode == APPD_MODE

     cPort                                           := "LPT1"
     cBitsSec                                        := "9600"
     cBitsParada                                     := "1"
     cBitsDatos                                      := "8"
     cBitsParidad                                    := "Sin paridad"
     aTmp[ (dbfVisor)->( FieldPos( "nLinea"  ) ) ]   := 1
     aTmp[ (dbfVisor)->( FieldPos( "nChaLin" ) ) ]   := 1
     aTmp[ (dbfVisor)->( FieldPos( "nInact"  ) ) ]   := 10

  else

     cPort         := aTmp[ ( dbfVisor )->( FieldPos( "cPort" ) ) ]
     cBitsSec      := Str( aTmp[ ( dbfVisor )->( FieldPos( "nBitSec" ) ) ] )
     cBitsParada   := Str( aTmp[ ( dbfVisor )->( FieldPos( "nBitPar" ) ) ] )
     cBitsDatos    := Str( aTmp[ ( dbfVisor )->( FieldPos( "nBitDat" ) ) ] )
     cBitsParidad  := aTmp[ ( dbfVisor )->( FieldPos( "cBitPari" ) ) ]

  end if

  /*
  Montamos el dialogo
  */

  DEFINE DIALOG oDlg RESOURCE "CNF_VIS_TPV" TITLE LblTitle ( nMode ) + "visor"

     //Grupo General

     REDEFINE GET aGet[ ( dbfVisor )->( FieldPos( "cCodVis" ) ) ] ;
        VAR      aTmp[ ( dbfVisor )->( FieldPos( "cCodVis" ) ) ] ;
        UPDATE ;
        ID       80 ;
        WHEN     ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) ;
        VALID    ( NotValid( aGet[ ( dbfVisor )->( FieldPos( "cCodVis" ) ) ], dbfVisor, .t., "0" ) ) ;
        PICTURE  "@!" ;
        OF       oDlg

     REDEFINE GET aGet[ ( dbfVisor )->( FieldPos( "cNomVis" ) ) ] ;
        VAR      aTmp[ ( dbfVisor )->( FieldPos( "cNomVis" ) ) ] ;
        ID       90 ;
        WHEN     ( nMode != ZOOM_MODE ) ;
        OF       oDlg

     //Salida

     REDEFINE COMBOBOX oPort VAR cPort ;
        ITEMS    aPort ;
        ID       100 ;
        WHEN     ( nMode != ZOOM_MODE ) ;
        ON CHANGE( oDlg:aEvalWhen() );
        OF       oDlg

     REDEFINE COMBOBOX oBitsSec VAR cBitsSec ;
        ITEMS    aBitsSec ;
        ID       110 ;
        WHEN     ( "COM" $ cPort .and. nMode != ZOOM_MODE ) ;
        OF       oDlg

    REDEFINE COMBOBOX oBitsParada VAR cBitsParada ;
        ITEMS    aBitsParada ;
        ID       120 ;
        WHEN     ( "COM" $ cPort .and. nMode != ZOOM_MODE ) ;
        OF       oDlg

    REDEFINE COMBOBOX oBitsDatos VAR cBitsDatos ;
        ITEMS    aBitsDatos ;
        ID       130 ;
        WHEN     ( "COM" $ cPort .and. nMode != ZOOM_MODE ) ;
        OF       oDlg

    REDEFINE COMBOBOX oBitsParidad VAR cBitsParidad ;
        ITEMS    aBitsParidad ;
        ID       145 ;
        WHEN     ( "COM" $ cPort .and. nMode != ZOOM_MODE ) ;
        OF       oDlg

    REDEFINE BUTTON ;
        ID       552;
        OF       oDlg ;
        WHEN     ( nMode != ZOOM_MODE ) ;
        ACTION   ( TestVisor( aTmp, cPort, cBitsSec, cBitsDatos, cBitsParada, cBitsParidad ) )

    //Propiedades

     REDEFINE GET aGet[ ( dbfVisor )->( FieldPos( "nLinea" ) ) ] ;
        VAR       aTmp[ ( dbfVisor )->( FieldPos( "nLinea" ) ) ] ;
        WHEN     ( nMode != ZOOM_MODE ) ;
        SPINNER ;
        MIN      1 ;
        MAX      20 ;
        PICTURE  "99" ;
        ID       150;
        OF       oDlg

     REDEFINE GET aGet[ ( dbfVisor )->( FieldPos( "nChaLin" ) ) ] ;
        VAR       aTmp[ ( dbfVisor )->( FieldPos( "nChaLin" ) ) ] ;
        WHEN     ( nMode != ZOOM_MODE ) ;
        SPINNER ;
        MIN      1 ;
        PICTURE  "99999" ;
        ID       160;
        OF       oDlg

     REDEFINE GET aGet[ ( dbfVisor )->( FieldPos( "cRetro" ) ) ] ;
        VAR       aTmp[ ( dbfVisor )->( FieldPos( "cRetro" ) ) ] ;
        ID        170 ;
        WHEN      ( nMode != ZOOM_MODE ) ;
        OF        oDlg

     REDEFINE GET aGet[ ( dbfVisor )->( FieldPos( "cAvCha" ) ) ] ;
        VAR       aTmp[ ( dbfVisor )->( FieldPos( "cAvCha" ) ) ] ;
        ID         180 ;
        WHEN      ( nMode != ZOOM_MODE ) ;
        OF         oDlg

     REDEFINE GET aGet[ ( dbfVisor )->( FieldPos( "cAvLin" ) ) ] ;
        VAR       aTmp[ ( dbfVisor )->( FieldPos( "cAvLin" ) ) ] ;
        ID        190 ;
        WHEN      ( nMode != ZOOM_MODE ) ;
        OF        oDlg

     REDEFINE GET aGet[ ( dbfVisor )->( FieldPos( "cReset" ) ) ] ;
        VAR       aTmp[ ( dbfVisor )->( FieldPos( "cReset" ) ) ] ;
        ID        200 ;
        WHEN      ( nMode != ZOOM_MODE ) ;
        OF        oDlg

     REDEFINE GET aGet[ ( dbfVisor )->( FieldPos( "cEscNor" ) ) ] ;
        VAR       aTmp[ ( dbfVisor )->( FieldPos( "cEscNor" ) ) ] ;
        ID        210 ;
        WHEN      ( nMode != ZOOM_MODE ) ;
        OF        oDlg

     REDEFINE GET aGet[ ( dbfVisor )->( FieldPos( "cEscDes" ) ) ] ;
        VAR       aTmp[ ( dbfVisor )->( FieldPos( "cEscDes" ) ) ] ;
        ID        220 ;
        WHEN      ( nMode != ZOOM_MODE ) ;
        OF        oDlg

    //Posicionamiento

     REDEFINE GET aGet[ ( dbfVisor )->( FieldPos( "cPosIni" ) ) ] ;
        VAR       aTmp[ ( dbfVisor )->( FieldPos( "cPosIni" ) ) ] ;
        ID        230 ;
        WHEN      ( nMode != ZOOM_MODE ) ;
        OF        oDlg

     REDEFINE GET aGet[ ( dbfVisor )->( FieldPos( "cPosFin" ) ) ] ;
        VAR       aTmp[ ( dbfVisor )->( FieldPos( "cPosFin" ) ) ] ;
        ID        240 ;
        WHEN      ( nMode != ZOOM_MODE ) ;
        OF        oDlg

     REDEFINE GET aGet[ ( dbfVisor )->( FieldPos( "cPriFil" ) ) ] ;
        VAR       aTmp[ ( dbfVisor )->( FieldPos( "cPriFil" ) ) ] ;
        ID        250 ;
        WHEN      ( nMode != ZOOM_MODE ) ;
        OF        oDlg

     REDEFINE GET aGet[ ( dbfVisor )->( FieldPos( "cPriCol" ) ) ] ;
        VAR       aTmp[ ( dbfVisor )->( FieldPos( "cPriCol" ) ) ] ;
        ID        260 ;
        WHEN      ( nMode != ZOOM_MODE ) ;
        OF        oDlg

    //Texto Defecto

     REDEFINE GET aGet[ ( dbfVisor )->( FieldPos( "cText1" ) ) ] ;
        VAR       aTmp[ ( dbfVisor )->( FieldPos( "cText1" ) ) ] ;
        ID         270 ;
        WHEN      ( nMode != ZOOM_MODE ) ;
        OF         oDlg

     REDEFINE GET aGet[ ( dbfVisor )->( FieldPos( "cText2" ) ) ] ;
        VAR       aTmp[ ( dbfVisor )->( FieldPos( "cText2" ) ) ] ;
        ID         280 ;
        WHEN      ( nMode != ZOOM_MODE ) ;
        OF         oDlg

     REDEFINE GET aGet[ ( dbfVisor )->( FieldPos( "nInact" ) ) ] ;
        VAR       aTmp[ ( dbfVisor )->( FieldPos( "nInact" ) ) ] ;
        WHEN     ( nMode != ZOOM_MODE ) ;
        SPINNER ;
        MIN      0 ;
        MAX      999 ;
        PICTURE  "999" ;
        ID       290 ;
        OF       oDlg

    //Botones del diálogo

     REDEFINE BUTTON ;
        ID       1 ;
        OF       oDlg ;
        WHEN     ( nMode != ZOOM_MODE ) ;
        ACTION   ( EndTrans( aTmp, aGet, dbfVisor, oBrw, nMode, oDlg, cPort, cBitsSec, cBitsParada, cBitsDatos, cBitsParidad ) )

     REDEFINE BUTTON ;
        ID       IDCANCEL ;
        OF       oDlg ;
        CANCEL ;
        ACTION   ( oDlg:end() )

    //Teclas rápidas

     if nMode != ZOOM_MODE
        oDlg:AddFastKey( VK_F5, {|| EndTrans( aTmp, aGet, dbfVisor, oBrw, nMode, oDlg, cPort, cBitsSec, cBitsParada, cBitsDatos, cBitsParidad ) } )
     end if

    oDlg:bStart := {|| aGet[ ( dbfVisor )->( FieldPos( "cCodVis" ) ) ]:SetFocus() }

    ACTIVATE DIALOG oDlg CENTER


RETURN ( oDlg:nResult == IDOK )
//-------------------------------------------------------------------------//

STATIC FUNCTION EndTrans( aTmp, aGet, dbfVisor, oBrw, nMode, oDlg, cPort, cBitsSec, cBitsParada, cBitsDatos, cBitsParidad )

  //Comprobamos que el código no esté vacío y que no exista

  if nMode == APPD_MODE .or. nMode == DUPL_MODE

     if Empty( aTmp[ ( dbfVisor )->( FieldPos( "cCodVis" ) ) ] )
        MsgStop( "El código del visor no puede estar vacío" )
        aGet[ ( dbfVisor )->( FieldPos( "cCodVis" ) ) ]:SetFocus()
        return nil
     end if

     if dbSeekInOrd( aTmp[ ( dbfVisor )->( FieldPos( "cCodVis" ) ) ], "CCODVIS", dbfVisor )
        msgStop( "Código existente" )
        return nil
     end if

  end if

  //Comprobamos que el nombre no esté vacío

  if Empty( aTmp[ ( dbfVisor )->( FieldPos( "cNomVis" ) ) ] )
     MsgStop( "El nombre del visor no puede estar vacío" )
     aGet[ ( dbfVisor )->( FieldPos( "cNomVis" ) ) ]:SetFocus()
     Return nil
  end if

  //Metemos los valores de los combos

  aTmp[ ( dbfVisor )->( FieldPos( "cPort" )   ) ]  := cPort
  aTmp[ ( dbfVisor )->( FieldPos( "nBitSec" ) ) ]  := Val( cBitsSec )
  aTmp[ ( dbfVisor )->( FieldPos( "nBitPar" ) ) ]  := Val( cBitsParada )
  aTmp[ ( dbfVisor )->( FieldPos( "nBitDat" ) ) ]  := Val( cBitsDatos )
  aTmp[ ( dbfVisor )->( FieldPos( "cBitPari" ) )]  := cBitsParidad

  WinGather( aTmp, aGet, dbfVisor, oBrw, nMode )

RETURN ( oDlg:end( IDOK ) )

//-------------------------------------------------------------------------//
/*
Función que crea la base de datos
*/

FUNCTION mkVisor(cPath, lAppend, cPathOld, oMeter )

   local oVisor

   DEFAULT cPath     :=cPatDat()
   DEFAULT lAppend   := .f.

   DEFINE DATABASE oVisor FILE "VISOR.DBF" PATH ( cPath ) ALIAS "VISOR" VIA ( cDriver() ) COMMENT  "Visor"

         FIELD NAME "CCODVIS"   TYPE "C"    LEN  3 DEC 0 COMMENT "Código del visor"                    OF oVisor
         FIELD NAME "CNOMVIS"   TYPE "C"    LEN 50 DEC 0 COMMENT "Nombre del visor"                    OF oVisor
         FIELD NAME "CPORT"     TYPE "C"    LEN  5 DEC 0 COMMENT "Puerto del visor"                    OF oVisor
         FIELD NAME "NBITSEC"   TYPE "N"    LEN  6 DEC 0 COMMENT "Bits segundo"                        OF oVisor
         FIELD NAME "NBITPAR"   TYPE "N"    LEN  1 DEC 0 COMMENT "Bits de parada"                      OF oVisor
         FIELD NAME "NBITDAT"   TYPE "N"    LEN  5 DEC 0 COMMENT "Bits de datos"                       OF oVisor
         FIELD NAME "CBITPARI"  TYPE "C"    LEN 50 DEC 0 COMMENT "Bits de paridad"                     OF oVisor
         FIELD NAME "NLINEA"    TYPE "N"    LEN  2 DEC 0 COMMENT "Número de lineas"                    OF oVisor
         FIELD NAME "NCHALIN"   TYPE "N"    LEN  5 DEC 0 COMMENT "Caracteres por líneas"               OF oVisor
         FIELD NAME "CRETRO"    TYPE "C"    LEN 20 DEC 0 COMMENT "Retroceso del visor"                 OF oVisor
         FIELD NAME "CAVCHA"    TYPE "C"    LEN 50 DEC 0 COMMENT "Avance caracter del visor"           OF oVisor
         FIELD NAME "CAVLIN"    TYPE "C"    LEN 50 DEC 0 COMMENT "Avance linea del visor"              OF oVisor
         FIELD NAME "CRESET"    TYPE "C"    LEN 50 DEC 0 COMMENT "Reset del visor"                     OF oVisor
         FIELD NAME "CESCNOR"   TYPE "C"    LEN 50 DEC 0 COMMENT "Escritura normal"                    OF oVisor
         FIELD NAME "CESCDES"   TYPE "C"    LEN 50 DEC 0 COMMENT "Escritura desplazada"                OF oVisor
         FIELD NAME "CPOSINI"   TYPE "C"    LEN 50 DEC 0 COMMENT "Posición de inicio"                  OF oVisor
         FIELD NAME "CPOSFIN"   TYPE "C"    LEN 50 DEC 0 COMMENT "Posición de fin"                     OF oVisor
         FIELD NAME "CPRIFIL"   TYPE "C"    LEN 50 DEC 0 COMMENT "Primera fila"                        OF oVisor
         FIELD NAME "CPRICOL"   TYPE "C"    LEN 50 DEC 0 COMMENT "Primera columna"                     OF oVisor
         FIELD NAME "CTEXT1"    TYPE "C"    LEN 50 DEC 0 COMMENT "Texto defec. primera línea"          OF oVisor
         FIELD NAME "CTEXT2"    TYPE "C"    LEN 50 DEC 0 COMMENT "Texto defec. segunda línea"          OF oVisor
         FIELD NAME "NINACT"    TYPE "N"    LEN  3 DEC 0 COMMENT "Tiempo por defecto de inactividad"   OF oVisor

         INDEX TO "VISOR.CDX" TAG CCODVIS ON CCODVIS           NODELETED OF oVisor
         INDEX TO "VISOR.CDX" TAG CNOMVIS ON Upper ( CNOMVIS ) NODELETED OF oVisor

   END DATABASE oVisor

   oVisor:Activate( .f., .f. )

   if lAppend .and. file( cPathOld + "VISOR.DBF" )
        oVisor:AppendFrom( cPathOld + "VISOR.DBF" )
   end if

   oVisor:end()

RETURN .t.
//----------------------------------------------------------------------------//
/*función que crea los índices de la base de datos*/

FUNCTION rxVisor( cPath, oMeter )

   local dbfVisor

   DEFAULT cPath := cPatDat()

   if !lExistTable( cPath + "VISOR.DBF" )
      mkVisor( cPath )
   end if

   if lExistIndex( cPath + "VISOR.CDX" )
      fErase( cPath + "VISOR.CDX" )
   end if

   if lExistTable( cPath + "VISOR.DBF" )

      dbUseArea( .t., cDriver(), cPath + "VISOR.DBF", cCheckArea( "VISOR", @dbfVisor ), .f. )

      if !( dbfVisor )->( neterr() )

         ( dbfVisor )->( __dbPack() )

         ( dbfVisor )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
         ( dbfVisor )->( ordCreate( cPath + "VISOR.CDX", "CCODVIS", "Field->cCodVis", {|| Field->cCodVis } ) )

         ( dbfVisor )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
         ( dbfVisor )->( ordCreate( cPath + "VISOR.CDX", "CNOMVIS", "Upper( Field->cNomVis )", {|| Upper( Field->cNomVis ) } ) )

         ( dbfVisor )->( dbCloseArea() )

      else

         msgStop( "Imposible abrir en modo exclusivo el visor" )

      end if

   end if

RETURN NIL
//--------------------------------------------------------------------------//
/*
Funcion que crea un visor por defecto si no existe
*/

FUNCTION IsVisor()

   local oBlock
   local oError
   local dbfVisor

   if !lExistTable( cPatDat() + "VISOR.DBF" )
      mkVisor( cPatDat() )
   end if

   if !lExistIndex( cPatDat() + "VISOR.CDX" )
      rxVisor( cPatDat() )
   end if

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

       USE ( cPatDat() + "VISOR.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "VISOR", @dbfVisor ) )
       SET ADSINDEX TO ( cPatDat() + "VISOR.CDX" ) ADDITIVE

       ( dbfVisor )->( __dbLocate( { || ( dbfVisor )->cCodVis == "000" } ) )
       if!( dbfVisor )->( Found() )
          ( dbfVisor )->( dbAppend() )
          ( dbfVisor )->cCodVis      := "000"
          ( dbfVisor )->cNomVis      := "Visor por defecto"
          ( dbfVisor )->cPort        := "COM1"
          ( dbfVisor )->nBitSec      := 9600
          ( dbfVisor )->nBitPar      := 1
          ( dbfVisor )->nBitDat      := 8
          ( dbfVisor )->cBitPari     := "Sin paridad"
          ( dbfVisor )->nLinea       := 2
          ( dbfVisor )->nChaLin      := 20
          ( dbfVisor )->cRetro       := ""              //Retroceso del visor
          ( dbfVisor )->cAvCha       := ""              //Avance caracter del visor
          ( dbfVisor )->cAvLin       := ""              //Avance linea del visor
          ( dbfVisor )->cReset       := "12"            //Reset del visor
          ( dbfVisor )->cEscNor      := ""              //Escritura normal
          ( dbfVisor )->cEscDes      := ""              //Escritura desplazada
          ( dbfVisor )->cPosIni      := ""              //Posición de inicio
          ( dbfVisor )->cPosFin      := ""              //Posición de fin
          ( dbfVisor )->cPriFil      := ""              //Primera fila
          ( dbfVisor )->cPriCol      := ""              //Primera columna
          ( dbfVisor )->cText1       := ""              //Texto defec. primera linea
          ( dbfVisor )->cText2       := ""              //Texto defec. segunda linea
          ( dbfVisor )->nInact       := 15              //Segundos de inactividad del visor
          ( dbfVisor )->( dbUnLock() )
       end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE ( dbfVisor )

RETURN ( .t. )

//--------------------------------------------------------------------------//
/*
Test del visor
*/

STATIC FUNCTION TestVisor( aTmp, cPuerto, cBitsSec, cBitsDatos, cBitsPara, cBitsPari )

  local oVis   := TCommPort():New( cPuerto, cBitsSec, cBitsPara, cBitsDatos, cBitsPari, .f. )

  // Comprobamos si se ha creado el puerto

  if oVis:lCreated

     // Informamos de los valores que nos han pasado y con los que hemos creado el puerto

     msgInfo( "Puerto  : " + cPuerto               + CRLF +;
              "Bits    : " + cBitsSec              + CRLF +;
              "Parada  : " + cBitsPara             + CRLF +;
              "Datos   : " + cBitsDatos            + CRLF +;
              "Paridad : " + cBitsPari             + CRLF +;
              "Handle  : " + AllTrim( Str( oVis:nHComm ) ) )

     if oVis:nHComm > 0

         //Escribimos en el visor el texto

         oVis:Write( Padr( "Test del visor", 20) )

     end if

   end if

   oVis:End()

Return .t.

//---------------------------------------------------------------------------//
/*Función para el browse*/

FUNCTION BrwSelVisor( oGet, dbfVisor, oGet2 )

   local oDlg
	local oBrw
	local oGet1
	local cGet1
   local nOrdAnt        := 1
	local oCbxOrd
   local aCbxOrd        := { "Código", "Descripción" }
   local cCbxOrd
   local nRec           := ( dbfVisor )->( RecNo() )
   local nLevel         := Auth():Level( "01091" )

   nOrdAnt              := Min( Max( nOrdAnt, 1 ), len( aCbxOrd ) )
   cCbxOrd              := aCbxOrd[ nOrdAnt ]

   nOrdAnt              := ( dbfVisor )->( OrdSetFocus( nOrdAnt ) )

   ( dbfVisor )->( dbGoTop() )

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Seleccionar visor"

   REDEFINE GET oGet1 VAR cGet1;
      ID       104 ;
      ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfVisor ) );
      VALID    ( OrdClearScope( oBrw, dbfVisor ) );
      BITMAP   "FIND" ;
      OF       oDlg

   REDEFINE COMBOBOX oCbxOrd ;
      VAR      cCbxOrd ;
      ID       102 ;
      ITEMS    aCbxOrd ;
      ON CHANGE( ( dbfVisor )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:Refresh(), oGet1:SetFocus() ) ;
      OF       oDlg

   oBrw                 := IXBrowse():New( oDlg )

   oBrw:nMarqueeStyle   := 5
   oBrw:lHScroll        := .f.
   oBrw:cAlias          := dbfVisor

   oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }
   oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }

   oBrw:CreateFromResource( 105 )

   with object ( oBrw:AddCol() )
      :cHeader          := "Código"
      :cSortOrder       := "cCodVis"
      :bEditValue       := {|| ( dbfVisor )->cCodVis }
      :nWidth           := 80
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
   end with

   with object ( oBrw:AddCol() )
      :cHeader          := "Descripción"
      :cSortOrder       := "cNomVis"
      :bEditValue       := {|| ( dbfVisor )->cNomVis }
      :nWidth           := 280
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
   end with

   REDEFINE BUTTON ;
      ID       500 ;
      OF       oDlg ;
      WHEN     ( nAnd( nLevel, ACC_APPD ) != 0 );
      ACTION   ( WinAppRec( oBrw, bEdit, dbfVisor ) )

   REDEFINE BUTTON ;
      ID       501 ;
      OF       oDlg ;
      WHEN     ( nAnd( nLevel, ACC_EDIT ) != 0 );
      ACTION   ( WinEdtRec( oBrw, bEdit, dbfVisor ) )

   REDEFINE BUTTON ;
      ID       IDOK ;
      OF       oDlg ;
      ACTION   ( oDlg:end(IDOK) )

   REDEFINE BUTTON ;
      ID       IDCANCEL ;
      OF       oDlg ;
      ACTION   ( oDlg:end() )

   oDlg:AddFastKey( VK_F2,       {|| if( nAnd( nLevel, ACC_APPD ) != 0, WinAppRec( oBrw, bEdit, dbfVisor ), ) } )
   oDlg:AddFastKey( VK_F3,       {|| if( nAnd( nLevel, ACC_EDIT ) != 0, WinEdtRec( oBrw, bEdit, dbfVisor ), ) } )
   oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )
   oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK

      oGet:cText( ( dbfVisor )->cCodVis )
      oGet:lValid()

      if ValType( oGet2 ) == "O"
         oGet2:cText( ( dbfVisor )->cNomVis )
      end if

   end if

   DestroyFastFilter( dbfVisor )

   SetBrwOpt( "BrwVisor", ( dbfVisor )->( OrdNumber() ) )

   ( dbfVisor )->( OrdSetFocus( nOrdAnt ) )
   ( dbfVisor )->( dbGoTo( nRec ) )

   oGet:setFocus()

RETURN oDlg:nResult == IDOK

//--------------------------------------------------------------------------//

FUNCTION cVisor( oGet, dbfVisor, oGet2 )

   local lValid   := .f.
   local xValor   := oGet:VarGet()

   if Empty( xValor )
      if( oGet2 != nil, oGet2:cText( "" ), )
      return .t.
   else
      xValor   := RJustObj( oGet, "0" )
   end if

   do case
      case Valtype( dbfVisor ) == "C"

         if ( dbfVisor )->( dbSeek( xValor ) )
            oGet:cText( ( dbfVisor )->cCodVis )
            if( oGet2 != nil, oGet2:cText( ( dbfVisor )->cNomVis ), )
            lValid   := .t.
         else
            oGet:Refresh()
            msgStop( "Visor no encontrado" )
         end if

      case Valtype( dbfVisor ) == "O"

         if dbfVisor:Seek( xValor )
            oGet:cText( dbfVisor:cCodVis )
            if( oGet2 != nil, oGet2:cText( dbfVisor:cNomVis ), )
            lValid   := .t.
         else
            oGet:Refresh()
            msgStop( "Visor no encontrado" )
         end if

   end case

RETURN lValid

//--------------------------------------------------------------------------//