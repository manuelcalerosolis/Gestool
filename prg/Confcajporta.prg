#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

static oWndBrw

static dbfCajPorta

static bEdit      := { |aTmp, aGet, dbfImpTik, oBrw, bWhen, bValid, nMode | EdtRec( aTmp, aGet, dbfImpTik, oBrw, bWhen, bValid, nMode ) }

//----------------------------------------------------------------------------//
/*
Abro las bases de datos necesarias
*/

STATIC FUNCTION OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      if !lExistTable( cPatDat() + "CajPorta.Dbf" )
         mkCajPorta( cPatDat() )
      end if

      USE ( cPatDat() + "CajPorta.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CAJPORTA", @dbfCajPorta ) )
      SET ADSINDEX TO ( cPatDat() + "CajPorta.Cdx" ) ADDITIVE

   RECOVER

      lOpen       := .f.

      CloseFiles()

      msgStop( "Imposible Abrir todas las bases de datos" )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//
/*
Cierra las bases de datos abiertas
*/

STATIC FUNCTION CloseFiles ()

   if dbfCajPorta != nil
      ( dbfCajPorta ) -> ( dbCloseArea() )
   end if

   dbfCajPorta := nil
   oWndBrw     := nil

RETURN .T.

//----------------------------------------------------------------------------//
/*
Monto el Browse principal
*/

FUNCTION ConfCajPorta( oMenuItem, oWnd )

   local nLevel

   DEFAULT  oMenuItem   := "01091"
   DEFAULT  oWnd        := oWnd()

   if oWndBrw == NIL

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
         return Nil
      end if

      /*
      Anotamos el movimiento para el navegador
      */

      AddMnuNext( "Configurar cajón portamonedas", ProcName() )

      DEFINE SHELL oWndBrw FROM 2, 10 TO 18, 70 ;
         XBROWSE ;
         TITLE    "Configurar cajón portamonedas" ;
         PROMPT   "Código",;
                  "Descripción";
         MRU      "gc_modem_screw_16";
         BITMAP   "WebTopGreen" ;
         ALIAS    ( dbfCajPorta ) ;
         APPEND   ( WinAppRec( oWndBrw:oBrw, bEdit, dbfCajPorta ) ) ;
         EDIT     ( WinEdtRec( oWndBrw:oBrw, bEdit, dbfCajPorta ) ) ;
         DELETE   ( WinDelRec( oWndBrw:oBrw, dbfCajPorta ) );
         DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdit, dbfCajPorta ) ) ;
         LEVEL    nLevel ;
         OF       oWnd

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodCaj"
         :bEditValue       := {|| ( dbfCajPorta )->cCodCaj }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Descripción"
         :cSortOrder       := "cNomCaj"
         :bEditValue       := {|| ( dbfCajPorta )->cNomCaj }
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
         ACTION   ( WinZooRec( oWndBrw:oBrw, bEdit, dbfCajPorta ) );
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

STATIC FUNCTION EdtRec( aTmp, aGet, dbfCajPorta, oBrw, bWhen, bValid, nMode )

   local oDlg

   if Empty( aTmp[ ( dbfCajPorta )->( FieldPos ( "cCodAper" ) ) ] )
      aTmp[ ( dbfCajPorta )->( FieldPos ( "cCodAper" ) ) ]  := "27 112 0 60 240"
   end if

   // Montamos el diálogo

   DEFINE DIALOG oDlg RESOURCE "CNF_CAJ_TPV" TITLE LblTitle( nMode ) + "cajón portamonedas"

   // Grupo General

   REDEFINE GET aGet[ ( dbfCajPorta )->( FieldPos( "cCodCaj" ) ) ] ;
      VAR      aTmp[ ( dbfCajPorta )->( FieldPos( "cCodCaj" ) ) ] ;
      UPDATE ;
      ID       80 ;
      WHEN     ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) ;
      VALID    ( NotValid( aGet[ ( dbfCajPorta )->( FieldPos( "cCodCaj" ) ) ], dbfCajPorta, .t., "0" ) ) ;
      PICTURE  "@!" ;
      OF       oDlg

   REDEFINE GET aGet[ ( dbfCajPorta )->( FieldPos( "cNomCaj" ) ) ] ;
      VAR      aTmp[ ( dbfCajPorta )->( FieldPos( "cNomCaj" ) ) ] ;
      ID       90 ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      OF       oDlg

   REDEFINE GET aGet[ ( dbfCajPorta )->( FieldPos( "cPrinter" ) ) ] ;
      VAR      aTmp[ ( dbfCajPorta )->( FieldPos( "cPrinter" ) ) ] ;
      ID       170 ;
      OF       oDlg

   TBtnBmp():ReDefine( 171, "gc_printer2_check_16",,,,,{|| PrinterPreferences( aGet[ ( dbfCajPorta )->( FieldPos( "cPrinter" ) ) ] ) }, oDlg, .f.,, .f.,  )

   REDEFINE GET aGet[ ( dbfCajPorta )-> ( FieldPos ( "cCodAper" ) ) ] ;
      VAR      aTmp[ ( dbfCajPorta )-> ( FieldPos ( "cCodAper" ) ) ] ;
      ID       110 ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      OF       oDlg

   // Botones del diálogo

   REDEFINE BUTTON ;
      ID       160;
      OF       oDlg ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      ACTION   ( TestCajon( aTmp, dbfCajPorta ) )

   REDEFINE BUTTON ;
      ID       1 ;
      OF       oDlg ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      ACTION   ( EndTrans( aTmp, aGet, dbfCajPorta, oBrw, nMode, oDlg ) )

   REDEFINE BUTTON ;
      ID       IDCANCEL ;
      OF       oDlg ;
      CANCEL ;
      ACTION   ( oDlg:end() )

   //Teclas rápidas

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| EndTrans( aTmp, aGet, dbfCajPorta, oBrw, nMode, oDlg ) } )
   end if

   oDlg:bStart := {|| aGet[ ( dbfCajPorta )->( FieldPos( "cCodCaj" ) ) ]:SetFocus() }

   ACTIVATE DIALOG oDlg CENTER


 RETURN ( oDlg:nResult == IDOK )
//----------------------------------------------------------------------------//
/*
Funcion que termina la edición del registro de la base de datos-----------------
*/

STATIC FUNCTION EndTrans( aTmp, aGet, dbfCajPorta, oBrw, nMode, oDlg )

   //Comprobamos que el código no esté vacío y que no exista

   if nMode == APPD_MODE .or. nMode == DUPL_MODE

      if Empty( aTmp[ ( dbfCajPorta )->( FieldPos( "cCodCaj" ) ) ] )
         MsgStop( "El código del cajón portamonedas no puede estar vacío" )
         aGet[ ( dbfCajPorta )->( FieldPos( "cCodCaj" ) ) ]:SetFocus()
         return nil
      end if

      if dbSeekInOrd( aTmp[ ( dbfCajPorta )->( FieldPos( "cCodCaj" ) ) ], "CCODCAJ", dbfCajPorta )
         msgStop( "Código existente" )
         return nil
      end if

   end if

   //Comprobamos que el nombre no esté vacío

   if Empty( aTmp[ ( dbfCajPorta )->( FieldPos( "cNomCaj" ) ) ] )
      MsgStop( "El nombre del portamonedas no puede estar vacío" )
      aGet[ ( dbfCajPorta )->( FieldPos( "cNomCaj" ) ) ]:SetFocus()
      Return nil
   end if

   //Comprobamos que el código de apertura no esté vacío

   if Empty( aTmp[ ( dbfCajPorta )->( FieldPos( "cCodAper" ) ) ] )
      MsgStop( "El código de apertura del portamonedas no puede estar vacío" )
      aGet[ ( dbfCajPorta )->( FieldPos( "cCodAper" ) ) ]:SetFocus()
      Return nil
   end if

   //Escribimos definitivamente la temporal a la base de datos

   WinGather( aTmp, aGet, dbfCajPorta, oBrw, nMode )

RETURN ( oDlg:end( IDOK ) )

//---------------------------------------------------------------------------//
/*
Función que crea las bases de datos necesarias
*/

FUNCTION mkCajPorta( cPath, lAppend, cPathOld, oMeter )

   local oCajPorta

   DEFAULT cPath     := cPatDat()
   DEFAULT lAppend   := .f.

   DEFINE DATABASE oCajPorta FILE "CajPorta.Dbf" PATH ( cPath ) ALIAS "CajPorta" VIA ( cDriver() ) COMMENT  "Cajón Portamonedas"

      FIELD NAME "CCODCAJ"     TYPE "C"  LEN   3  DEC 0 COMMENT  "Código del cajón portamonedas" OF oCajPorta
      FIELD NAME "CNOMCAJ"     TYPE "C"  LEN  35  DEC 0 COMMENT  "Nombre del cajón portamonedas" OF oCajPorta
      FIELD NAME "CPORT"       TYPE "C"  LEN  50  DEC 0 COMMENT  "Puerto del cajón"              OF oCajPorta
      FIELD NAME "CCODAPER"    TYPE "C"  LEN  50  DEC 0 COMMENT  "Código de apertura del cajón"  OF oCajPorta
      FIELD NAME "NBITSSEC"    TYPE "N"  LEN   6  DEC 0 COMMENT  "Bit segundos"                  OF oCajPorta
      FIELD NAME "NBITSPARA"   TYPE "N"  LEN   1  DEC 0 COMMENT  "Bit de parada"                 OF oCajPorta
      FIELD NAME "NBITSDATOS"  TYPE "N"  LEN   1  DEC 0 COMMENT  "Bit de datos"                  OF oCajPorta
      FIELD NAME "CBITSPARI"   TYPE "C"  LEN  50  DEC 0 COMMENT  "Bit de paridad"                OF oCajPorta
      FIELD NAME "NDRIVER"     TYPE "N"  LEN   1  DEC 0 COMMENT  "Selección impresora de windows"OF oCajPorta
      FIELD NAME "CPRINTER"    TYPE "C"  LEN 254  DEC 0 COMMENT  "Impresora de windows"          OF oCajPorta

      INDEX TO "CAJPORTA.CDX" TAG CCODCAJ ON CCODCAJ          NODELETED OF oCajPorta
      INDEX TO "CAJPORTA.CDX" TAG CNOMCAJ ON Upper( CNOMCAJ ) NODELETED OF oCajPorta

   END DATABASE oCajPorta

   oCajPorta:Activate( .f., .t. )

   if lAppend .and. !Empty( cPathOld ) .and. lExistTable( cPathOld + "CajPorta.Dbf" )
      oCajPorta:AppendFrom( cPathOld + "CajPorta.Dbf" )
   end if

   oCajPorta:end()

 RETURN .t.
 
//----------------------------------------------------------------------------//
/*
Funcion que crea los índices de las bases de datos
*/

 FUNCTION rxCajPorta( cPath, oMeter )

   local dbfCajPorta

   DEFAULT cPath  := cPatDat()

   if !lExistTable( cPath + "CAJPORTA.DBF" )
      mkCajPorta( cPath )
   end if

   fEraseIndex( cPath + "CAJPORTA.CDX" )

   if lExistTable( cPath + "CAJPORTA.DBF" )

      dbUseArea( .t., cDriver(), cPath + "CAJPORTA.DBF", cCheckArea( "CAJPORTA", @dbfCajPorta ), .f. )

      if !( dbfCajPorta )->( neterr() )
         ( dbfCajPorta )->( __dbPack() )

         ( dbfCajPorta )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
         ( dbfCajPorta )->( ordCreate( cPath + "CAJPORTA.CDX", "CCODCAJ", "Field->cCodCaj", {|| Field->cCodCaj } ) )

         ( dbfCajPorta )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
         ( dbfCajPorta )->( ordCreate( cPath + "CAJPORTA.CDX", "CNOMCAJ", "Upper( Field->cNomCaj )", {|| Upper( Field->cNomCaj ) } ) )

         ( dbfCajPorta )->( dbCloseArea() )
      else
         msgStop( "Imposible abrir en modo exclusivo cajón portamonedas" )
      end if

   end if

 RETURN NIL

//---------------------------------------------------------------------------//
/*
Funcion para que siempre haya una impresora por defecto
*/

FUNCTION IsCajPorta()

   local oBlock
   local oError
   local dbfCajPorta

   if !lExistTable( cPatDat() + "CajPorta.Dbf" )
      mkCajPorta( cPatDat() )
   end if

   if !lExistIndex( cPatDat() + "CajPorta.Cdx" )
      rxCajPorta( cPatDat() )
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//
/*
Función para el browse
*/

FUNCTION BrwSelCajPorta( oGet, dbfCajPorta, oGet2 )

   local oDlg
	local oBrw
   local nRec           
   local oGet1
   local cGet1
   local nOrdAnt        := 1
   local oCbxOrd
   local aCbxOrd        := { "Código", "Descripción" }
   local cCbxOrd
   local nLevel         := Auth():Level( "01091" )

   nOrdAnt              := Min( Max( nOrdAnt, 1 ), len( aCbxOrd ) )
   cCbxOrd              := aCbxOrd[ nOrdAnt ]

   nRec                 := ( dbfCajPorta )->( RecNo() )
   nOrdAnt              := ( dbfCajPorta )->( OrdSetFocus( nOrdAnt ) )

   ( dbfCajPorta )->( dbGoTop() )

   DEFINE DIALOG  oDlg ;
      RESOURCE    "HELPENTRY" ;
      TITLE       "Seleccionar cajón portamonedas"

   REDEFINE GET oGet1 VAR cGet1;
      ID          104 ;
      ON CHANGE   ( AutoSeek( nKey, nFlags, Self, oBrw, dbfCajPorta ) );
      VALID       ( OrdClearScope( oBrw, dbfCajPorta ) );
      BITMAP      "FIND" ;
      OF          oDlg

   REDEFINE COMBOBOX oCbxOrd ;
      VAR         cCbxOrd ;
      ID          102 ;
      ITEMS       aCbxOrd ;
      ON CHANGE   ( ( dbfCajPorta )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:Refresh(), oGet1:SetFocus() ) ;
      OF          oDlg

   oBrw                 := IXBrowse():New( oDlg )

   oBrw:nMarqueeStyle   := 5
   oBrw:lHScroll        := .f.
   oBrw:cAlias          := dbfCajPorta

   oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }
   oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }

   oBrw:CreateFromResource( 105 )

   with object ( oBrw:AddCol() )
      :cHeader          := "Código"
      :cSortOrder       := "cCodCaj"
      :bEditValue       := {|| ( dbfCajPorta )->cCodCaj }
      :nWidth           := 80
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
   end with

   with object ( oBrw:AddCol() )
      :cHeader          := "Descripción"
      :cSortOrder       := "cNomCaj"
      :bEditValue       := {|| ( dbfCajPorta )->cNomCaj }
      :nWidth           := 280
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
  end with

   REDEFINE BUTTON ;
      ID       500 ;
      OF       oDlg ;
      WHEN     ( nAnd( nLevel, ACC_APPD ) != 0 );
      ACTION   ( WinAppRec( oBrw, bEdit, dbfCajPorta ) )

   REDEFINE BUTTON ;
      ID       501 ;
      OF       oDlg ;
      WHEN     ( nAnd( nLevel, ACC_EDIT ) != 0 );
      ACTION   ( WinEdtRec( oBrw, bEdit, dbfCajPorta ) )

   REDEFINE BUTTON ;
      ID       IDOK ;
      OF       oDlg ;
      ACTION   ( oDlg:end(IDOK) )

   REDEFINE BUTTON ;
      ID       IDCANCEL ;
      OF       oDlg ;
      ACTION   ( oDlg:end() )

   oDlg:AddFastKey( VK_F2,       {|| if( nAnd( nLevel, ACC_APPD ) != 0, WinAppRec( oBrw, bEdit, dbfCajPorta ), ) } )
   oDlg:AddFastKey( VK_F3,       {|| if( nAnd( nLevel, ACC_EDIT ) != 0, WinEdtRec( oBrw, bEdit, dbfCajPorta ), ) } )
   oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )
   oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK

      oGet:cText( ( dbfCajPorta )->cCodCaj )
      oGet:lValid()

      if ValType( oGet2 ) == "O"
         oGet2:cText( ( dbfCajPorta )->cNomCaj )
      end if

   end if

   DestroyFastFilter( dbfCajPorta )

   SetBrwOpt( "BrwCajPorta", ( dbfCajPorta )->( OrdNumber() ) )

   ( dbfCajPorta )->( OrdSetFocus( nOrdAnt ) )
   ( dbfCajPorta )->( dbGoTo( nRec ) )

   oGet:setFocus()

 RETURN oDlg:nResult == IDOK

 //--------------------------------------------------------------------------//

 FUNCTION cCajPorta( oGet, dbfCajPorta, oGet2 )

   local lValid   := .f.
   local xValor   := oGet:VarGet()

   if Empty( xValor )
      if( oGet2 != nil, oGet2:cText( "" ), )
      return .t.
   else
      xValor   := RJustObj( oGet, "0" )
   end if

   do case
      case Valtype( dbfCajPorta ) == "C"

         if ( dbfCajPorta )->( dbSeek( xValor ) )
            oGet:cText( ( dbfCajPorta )->cCodCaj )
            if( oGet2 != nil, oGet2:cText( ( dbfCajPorta )->cNomCaj ), )
            lValid   := .t.
         else
            oGet:Refresh()
            msgStop( "Cajón portamonedas no encontrado" )
         end if

      case Valtype( dbfCajPorta ) == "O"

         if dbfCajPorta:Seek( xValor )
            oGet:cText( dbfCajPorta:cCodCaj )
            if( oGet2 != nil, oGet2:cText( dbfCajPorta:cNomCaj ), )
            lValid   := .t.
         else
            oGet:Refresh()
            msgStop( "Cajón portamonedas no encontrado" )
         end if

   end case

RETURN lValid

//---------------------------------------------------------------------------//

Static Function TestCajon( aTmp, dbfCajPorta )

   local oCajon      := TCajon():New( aTmp[ ( dbfCajPorta )-> ( FieldPos ( "cCodAper" ) ) ], aTmp[ ( dbfCajPorta )->( FieldPos( "cPrinter" ) ) ] )

   if !Empty( oCajon )
      oCajon:OpenTest()
   end if

Return ( nil )

//---------------------------------------------------------------------------//

Function OpnCaj()

   local oBlock
   local oError
   local cCajon
   local oCajon
   local dbfCajon

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatDat() + "CAJAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CAJAS", @dbfCajon ) )
   SET ADSINDEX TO ( cPatDat() + "CAJAS.CDX" ) ADDITIVE

   cCajon            := cCajonEnCaja( Application():CodigoCaja(), dbfCajon )

   if !Empty( cCajon )

      oCajon         := TCajon():Create( cCajon )

      if oCajon != nil
         oCajon:OpenTest()
         oCajon:End()
      end if

   end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE( dbfCajon )

Return nil

//---------------------------------------------------------------------------//

FUNCTION mkLogPorta( cPath )

   local oLogPorta

   DEFAULT cPath     := cPatEmp()

   DEFINE DATABASE oLogPorta FILE "LogPorta.Dbf" PATH ( cPath ) ALIAS "LogPorta" VIA ( cDriver() ) COMMENT  "Cajón Portamonedas"

      FIELD NAME "cNumTur" TYPE "C" LEN  6   DEC 0 COMMENT "Sesión de la apertura de cajón"     OF oLogPorta
      FIELD NAME "cSufTur" TYPE "C" LEN  2   DEC 0 COMMENT ""                                   OF oLogPorta
      FIELD NAME "cCodCaj" TYPE "C" LEN  3   DEC 0 COMMENT "Código de la caja"                  OF oLogPorta
      FIELD NAME "cCodUse" TYPE "C" LEN  3   DEC 0 COMMENT "Código del usuario"                 OF oLogPorta
      FIELD NAME "dFecApt" TYPE "D" LEN  8   DEC 0 COMMENT "Fecha de la apertura del cajón"     OF oLogPorta
      FIELD NAME "cHorApt" TYPE "C" LEN  5   DEC 0 COMMENT "Hora de apertura de cajón"          OF oLogPorta

      INDEX TO "LogPorta.Cdx" TAG "cNumTur" ON "cNumTur + cSufTur"            FOR "!Deleted()"  OF oLogPorta
      INDEX TO "LogPorta.Cdx" TAG "cTurCaj" ON "cNumTur + cSufTur + cCodCaj " FOR "!Deleted()"  OF oLogPorta
      INDEX TO "LogPorta.Cdx" TAG "dFecApt" ON "dFecApt"                      FOR "!Deleted()"  OF oLogPorta

   END DATABASE oLogPorta

   oLogPorta:Activate( .f., .f. )
   oLogPorta:End()

 RETURN .t.
 
 //----------------------------------------------------------------------------//

 /*Funcion que crea los índices de las bases de datos*/

 FUNCTION rxLogPorta( cPath, oMeter )

   local dbfLogPorta

   DEFAULT cPath  := cPatEmp()

   if !lExistTable( cPath + "LogPorta.Dbf" )
      mkLogPorta( cPath )
   end if

   fEraseIndex( cPath + "LogPorta.CDX" )

   if lExistTable( cPath + "LogPorta.DBF" )

      dbUseArea( .t., cDriver(), cPath + "LogPorta.DBF", cCheckArea( "LogPorta", @dbfLogPorta ), .f. )

      if !( dbfLogPorta )->( neterr() )
         ( dbfLogPorta )->( __dbPack() )

         ( dbfLogPorta )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
         ( dbfLogPorta )->( ordCreate( cPath + "LogPorta.CDX", "cNumTur", "Field->cNumTur + Field->cSufTur", {|| Field->cNumTur + Field->cSufTur } ) )

         ( dbfLogPorta )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
         ( dbfLogPorta )->( ordCreate( cPath + "LogPorta.CDX", "cTurCaj", "Field->cNumTur + Field->cSufTur + Field->cCodCaj", {|| Field->cNumTur + Field->cSufTur + Field->cCodCaj } ) )

         ( dbfLogPorta )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
         ( dbfLogPorta )->( ordCreate( cPath + "LogPorta.CDX", "dFecApt", "Field->dFecApt", {|| Field->dFecApt } ) )

         ( dbfLogPorta )->( dbCloseArea() )
      else
         msgStop( "Imposible abrir en modo exclusivo log de cajón portamonedas" )
      end if

   end if

 RETURN NIL

//---------------------------------------------------------------------------//
/*
Funcion para que siempre haya una impresora por defecto
*/

FUNCTION IsLogPorta()

   local dbfLogPorta

   if !lExistTable( cPatEmp() + "LogPorta.Dbf" )
      mkLogPorta( cPatEmp() )
   end if

   if !lExistIndex( cPatEmp() + "LogPorta.Cdx" )
      rxLogPorta( cPatEmp() )
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//