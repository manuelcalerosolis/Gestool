#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

static oWndBrw
static dbfTipoNotas
static bEdit      := { |aTmp, aGet, dbfTipoNotas, oBrw, bWhen, bValid, nMode | EdtRec( aTmp, aGet, dbfTipoNotas, oBrw, bWhen, bValid, nMode ) }

//----------------------------------------------------------------------------//
/*
Abro las bases de datos necesarias
*/

STATIC FUNCTION OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      if !lExistTable( cPatDat() + "TipoNotas.Dbf" )
         mkTipoNotas( cPatDat() )
      end if

      USE ( cPatDat() + "TipoNotas.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TipoNotas", @dbfTipoNotas ) )
      SET ADSINDEX TO ( cPatDat() + "TipoNotas.Cdx" ) ADDITIVE

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      CloseFiles ()
      lOpen       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//
/*
Cierra las bases de datos abiertas
*/

STATIC FUNCTION CloseFiles()

   if dbfTipoNotas != nil
      ( dbfTipoNotas )->( dbCloseArea() )
   end if

   dbfTipoNotas := nil
   oWndBrw  := nil

RETURN .T.

//----------------------------------------------------------------------------//
/*
Función que crea las bases de datos necesarias
*/

FUNCTION mkTipoNotas( cPath, lAppend, cPathOld, oMeter )

   local dbfTipoNotas

   DEFAULT cPath     := cPatDat()
   DEFAULT lAppend   := .f.

   if !lExistTable( cPath + "TipoNotas.Dbf" )
      dbCreate( cPath + "TipoNotas.Dbf", { { "cTipo", "C", 30, 0 } }, cDriver() )
   end if

   if lExistIndex( cPath + "TipoNotas.Cdx" )
      fErase( cPath + "TipoNotas.Cdx" )
   end if

   if lAppend .and. lIsDir( cPathOld ) .and. file( cPathOld + "TipoNotas.Dbf" )
      dbUseArea( .t., cDriver(), "TipoNotas.Dbf", cCheckArea( "TipoNotas", @dbfTipoNotas ), .f. )
      if !( dbfTipoNotas )->( neterr() )
         ( dbfTipoNotas )->( __dbApp( cPathOld + "TipoNotas.Dbf" ) )
         ( dbfTipoNotas )->( dbCloseArea() )
      end if
   end if

   rxTipoNotas( cPath, oMeter )

RETURN .t.

//----------------------------------------------------------------------------//
/*
Funcion que crea los índices de las bases de datos
*/

FUNCTION rxTipoNotas( cPath, oMeter )

   local dbfTipoNotas

   DEFAULT cPath := cPatDat()

   IF !lExistTable( cPath + "TipoNotas.Dbf" )
      dbCreate( cPath + "TipoNotas.Dbf", { { "cTipo", "C", 30, 0 } }, cDriver() )
   END IF

   IF lExistIndex( cPath + "TipoNotas.Cdx" )
      fErase( cPath + "TipoNotas.Cdx" )
   END IF

   if lExistTable( cPath + "TipoNotas.Dbf" )

      dbUseArea( .t., cDriver(), cPath + "TipoNotas.Dbf", cCheckArea( "TipoNotas", @dbfTipoNotas ), .f. )

      if !( dbfTipoNotas )->( neterr() )
         ( dbfTipoNotas )->( __dbPack() )

         ( dbfTipoNotas )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
         ( dbfTipoNotas )->( ordCreate( cPath + "TipoNotas.Cdx", "cTipo", "Upper( Field->cTipo )", {|| Upper( Field->cTipo ) } ) )

         ( dbfTipoNotas )->( dbCloseArea() )

      else

         msgStop( "Imposible abrir en modo exclusivo tipos de notas" )

      end if

   end if

RETURN NIL

//----------------------------------------------------------------------------//
/*
Monto el Browse principal
*/

FUNCTION TipoNotas( oMenuItem, oWnd )

   local nLevel

   DEFAULT  oMenuItem   := "01097"
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

      AddMnuNext( "Tipos notas", ProcName() )

      DEFINE SHELL oWndBrw FROM 2, 10 TO 18, 70 ;
      XBROWSE ;
      TITLE    "Tipos de notas" ;
      PROMPT   "Tipo";
      MRU      "Index_16";
      ALIAS    ( dbfTipoNotas ) ;
      BITMAP   clrTopArchivos ;
      APPEND   ( WinAppRec( oWndBrw:oBrw, bEdit, dbfTipoNotas ) ) ;
      EDIT     ( WinEdtRec( oWndBrw:oBrw, bEdit, dbfTipoNotas ) ) ;
      DELETE   ( WinDelRec( oWndBrw:oBrw, dbfTipoNotas ) );
      DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdit, dbfTipoNotas ) ) ;
      LEVEL    nLevel ;
      OF       oWnd

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Tipo"
         :cSortOrder       := "cTipo"
         :bEditValue       := {|| ( dbfTipoNotas )->cTipo }
         :nWidth           := 800
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      oWndBrw:cHtmlHelp    := "Tipos de notas"

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
         ACTION   ( WinZooRec( oWndBrw:oBrw, bEdit, dbfTipoNotas ) );
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

 RETURN NIL

 //---------------------------------------------------------------------------//

/*
Monta el diálogo para añadir, editar,... registros
*/

STATIC FUNCTION EdtRec( aTmp, aGet, dbfTipoNotas, oBrw, bWhen, bValid, nMode )

   local oDlg

   //Montamos el diálogo

   DEFINE DIALOG oDlg RESOURCE "SITUACION" TITLE LblTitle( nMode ) + "tipos de notas"

   //Grupo General

   REDEFINE GET aGet[ ( dbfTipoNotas )->( FieldPos( "cTipo" ) ) ] ;
      VAR      aTmp[ ( dbfTipoNotas )->( FieldPos( "cTipo" ) ) ] ;
      ID       90 ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      OF       oDlg

   REDEFINE BUTTON ;
      ID       500 ;
      OF       oDlg ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      ACTION   ( EndTrans( aTmp, aGet, dbfTipoNotas, oBrw, nMode, oDlg ) )

   REDEFINE BUTTON ;
      ID       550 ;
      OF       oDlg ;
      CANCEL ;
      ACTION   ( oDlg:end() )

   REDEFINE BUTTON ;
      ID       9 ;
      OF       oDlg ;
      ACTION   ( GoHelp() )

   //Teclas rápidas

   if nMode != ZOOM_MODE
   oDlg:AddFastKey( VK_F5, {|| EndTrans( aTmp, aGet, dbfTipoNotas, oBrw, nMode, oDlg ) } )
   end if
   oDlg:AddFastKey( VK_F1, {|| GoHelp() } )

   oDlg:bStart          := {|| aGet[ ( dbfTipoNotas )->( FieldPos( "cTipo" ) ) ]:SetFocus() }

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//
/*
Funcion que termina la edición del registro de la base de datos
*/

STATIC FUNCTION EndTrans( aTmp, aGet, dbfTipoNotas, oBrw, nMode, oDlg )

   /*
   Comprobamos que el código no esté vacío y que no exista
   */

   if nMode == APPD_MODE .or. nMode == DUPL_MODE
      if Existe( Upper( aTmp[ ( dbfTipoNotas )->( FieldPos( "cTipo" ) ) ] ), dbfTipoNotas, "cTipo" )
         msgStop( "Tipo de nota existente" )
         aGet[ ( dbfTipoNotas )->( FieldPos( "cTipo" ) ) ]:SetFocus()
         return nil
      end if
   end if

   if Empty( aTmp[ ( dbfTipoNotas )->( FieldPos( "cTipo" ) ) ] )
      MsgStop( "El tipo de nota no puede estar vacío" )
      aGet[ ( dbfTipoNotas )->( FieldPos( "cTipo" ) ) ]:SetFocus()
      return nil
   end if

   /*
   Escribimos definitivamente la temporal a la base de datos
   */

   WinGather( aTmp, aGet, dbfTipoNotas, oBrw, nMode )

RETURN ( oDlg:end( IDOK ) )

//---------------------------------------------------------------------------//
/*
Funcion que llena un array con los valoras de la base de datos
*/

Function aTipoNotas( dbfTipoNotas )

   local oBlock
   local oError
   local aSitua   := {}
   local lClose   := .f.
   local nRec

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if dbfTipoNotas == nil

      /*
      Si no nos pasan la base de datos la abrimos
      */

      USE ( cPatDat() + "TipoNotas.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TipoNotas", @dbfTipoNotas ) )
      SET ADSINDEX TO ( cPatDat() + "TipoNotas.Cdx" ) ADDITIVE
      lClose      := .t.

   else

      /*
      En caso de que esté abierto ya la base de datos tomamos el registro para dejarla como estaba
      */

      nRec        := ( dbfTipoNotas )->( RecNo() )

   end if

   /*
   Recorremos la base de datos metiendo todos los valores en una array que es la que vamos a devolver
   */

   ( dbfTipoNotas )->( dbGoTop() )

   aAdd( aSitua, "" )

   while !( dbfTipoNotas )->( Eof() )
      if !Empty( ( dbfTipoNotas )->cTipo )
         aAdd( aSitua, ( dbfTipoNotas )->cTipo )
      end if
      ( dbfTipoNotas )->( dbSkip() )
   end while

   /*
   Cerramos la base de datos, o en el caso de no haberla abierto, la dejamos donde estaba
   */

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if lClose
      ( dbfTipoNotas )->( dbCloseArea() )
   else
      ( dbfTipoNotas )->( dbGoto( nRec ) )
   end if

Return aSitua

//---------------------------------------------------------------------------//
/*
Funcion para que siempre haya una impresora por defecto
*/

FUNCTION IsTipoNotas()

   local dbfTipoNotas
   local oError
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   if !lExistTable( cPatDat() + "TipoNotas.Dbf" )
      mkTipoNotas( cPatDat() )
   end if

   if !lExistIndex( cPatDat() + "TipoNotas.Cdx" )
      rxTipoNotas( cPatDat() )
   end if

   RECOVER USING oError

      msgStop( "Imposible realizar las comprobación inicial de tipos de notas" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE ( dbfTipoNotas )

 RETURN ( .t. )

//---------------------------------------------------------------------------//