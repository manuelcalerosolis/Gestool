#ifndef __PDA__
#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#else
#include "FWCE.ch"
REQUEST DBFCDX
#endif

#ifndef __PDA__

static oWndBrw
static bEdit      := { |aTmp, aGet, dbfSitua, oBrw, bWhen, bValid, nMode | EdtRec( aTmp, aGet, dbfSitua, oBrw, bWhen, bValid, nMode ) }

#endif

static dbfSitua

#ifndef __PDA__

//----------------------------------------------------------------------------//
//Funciones del programa
//----------------------------------------------------------------------------//

/*Abro las bases de datos necesarias*/

STATIC FUNCTION OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      if !lExistTable( cPatDat() + "SITUA.DBF" )
         mkSitua( cPatDat() )
      end if

      USE ( cPatDat() + "SITUA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "SITUA", @dbfSitua ) )
      SET ADSINDEX TO ( cPatDat() + "SITUA.CDX" ) ADDITIVE

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

   if dbfSitua != nil
      ( dbfSitua ) -> ( dbCloseArea() )
   end if

   dbfSitua := nil
   oWndBrw  := nil

RETURN .T.

//----------------------------------------------------------------------------//

/*
Monto el Browse principal
*/

FUNCTION Situaciones( oMenuItem, oWnd )

   local nLevel

   DEFAULT  oMenuItem   := "01096"
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

      AddMnuNext( "Situaciones", ProcName() )

      DEFINE SHELL oWndBrw FROM 2, 10 TO 18, 70 ;
         XBROWSE ;
         TITLE    "Situaciones" ;
         PROMPT   "Situaciones" ;
         MRU      "Document_Attachment_16";
         ALIAS    ( dbfSitua ) ;
         BITMAP   clrTopArchivos ;
         APPEND   ( WinAppRec( oWndBrw:oBrw, bEdit, dbfSitua ) ) ;
         EDIT     ( WinEdtRec( oWndBrw:oBrw, bEdit, dbfSitua ) ) ;
         DELETE   ( WinDelRec( oWndBrw:oBrw, dbfSitua ) );
         DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdit, dbfSitua ) ) ;
         LEVEL    nLevel ;
         OF       oWnd

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Situaciones"
         :cSortOrder       := "cSitua"
         :bEditValue       := {|| ( dbfSitua )->cSitua }
         :nWidth           := 800
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      oWndBrw:cHtmlHelp    := "Situaciones"

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
         ACTION   ( WinZooRec( oWndBrw:oBrw, bEdit, dbfSitua ) );
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

//----------------------------------------------------------------------------//
/*
Monta el diálogo para añadir, editar,... registros
*/

STATIC FUNCTION EdtRec( aTmp, aGet, dbfSitua, oBrw, bWhen, bValid, nMode )

   local oDlg

   //Montamos el diálogo

   DEFINE DIALOG oDlg RESOURCE "SITUACION" TITLE LblTitle( nMode ) + "situación"

   //Grupo General

   REDEFINE GET aGet[ ( dbfSitua )->( FieldPos( "cSitua" ) ) ] ;
      VAR      aTmp[ ( dbfSitua )->( FieldPos( "cSitua" ) ) ] ;
      ID       100 ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      OF       oDlg

   REDEFINE BUTTON ;
      ID       500 ;
      OF       oDlg ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      ACTION   ( EndTrans( aTmp, aGet, dbfSitua, oBrw, nMode, oDlg ) )

   REDEFINE BUTTON ;
      ID       550 ;
      OF       oDlg ;
      CANCEL ;
      ACTION   ( oDlg:end() )

   //Teclas rápidas

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| EndTrans( aTmp, aGet, dbfSitua, oBrw, nMode, oDlg ) } )
   end if

   oDlg:bStart := {|| aGet[ ( dbfSitua )->( FieldPos( "cSitua" ) ) ]:SetFocus() }

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//
/*
Funcion que termina la edición del registro de la base de datos
*/

STATIC FUNCTION EndTrans( aTmp, aGet, dbfSitua, oBrw, nMode, oDlg )

   //Comprobamos que el código no esté vacío y que no exista

   if nMode == APPD_MODE .or. nMode == DUPL_MODE
      if Existe( Upper( aTmp[ ( dbfSitua )->( FieldPos( "cSitua" ) ) ] ), dbfSitua, "cSitua" )
         msgStop( "Situación existente" )
         aGet[ ( dbfSitua )->( FieldPos( "cSitua" ) ) ]:SetFocus()
         return nil
      end if
   end if

   if Empty( aTmp[ ( dbfSitua )->( FieldPos( "cSitua" ) ) ] )
      MsgStop( "La situación no puede estar vacía" )
      aGet[ ( dbfSitua )->( FieldPos( "cSitua" ) ) ]:SetFocus()
      return nil
   end if

   //Escribimos definitivamente la temporal a la base de datos

   WinGather( aTmp, aGet, dbfSitua, oBrw, nMode )

RETURN ( oDlg:end( IDOK ) )

//---------------------------------------------------------------------------//

#endif

//---------------------------------------------------------------------------//
//Funciones comunes del programa y pda
//---------------------------------------------------------------------------//

/*
Funcion que llena un array con los valoras de la base de datos
*/

Function aSituacion( dbfSitua )

   local oError
   local oBlock
   local aSitua   := {}

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      /*
      Recorremos la base de datos metiendo todos los valores en una array que es la que vamos a devolver
      */

      aAdd( aSitua, "" )

      ( dbfSitua )->( dbGoTop() )
      while !( dbfSitua )->( Eof() )
         aAdd( aSitua, ( dbfSitua )->cSitua )
         ( dbfSitua )->( dbSkip() )
      end while

   RECOVER USING oError

      msgStop( "Imposible cargar situaciones" + CRLF + ErrorMessage( oError )  )

   END SEQUENCE

   ErrorBlock( oBlock )

Return aSitua

//---------------------------------------------------------------------------//
/*
Función que crea las bases de datos necesarias
*/

FUNCTION mkSitua( cPath, lAppend, cPathOld )

   local dbfSitua

   DEFAULT cPath     := cPatDat()
   DEFAULT lAppend   := .f.

   if !lExistTable( cPath + "Situa.Dbf" )
      dbCreate( cPath + "Situa.Dbf", { { "cSitua", "C", 30, 0 } }, cDriver() )
   end if

   if lExistIndex( cPath + "Situa.Cdx" )
      fErase( cPath + "Situa.Cdx" )
   end if

   if lAppend .and. lIsDir( cPathOld ) .and. lExistTable( cPathOld + "Situa.Dbf" )

      dbUseArea( .t., cDriver(), "Situa.Dbf", cCheckArea( "Situa", @dbfSitua ), .f. )
      ( dbfSitua )->( __dbApp( cPathOld + "Situa.Dbf" ) )
      ( dbfSitua )->( dbCloseArea() )

   end if

   rxSitua( cPath )

RETURN .t.

//----------------------------------------------------------------------------//

/*
Funcion que crea los índices de las bases de datos
*/

FUNCTION rxSitua( cPath, oMeter )

   local dbfSitua

   DEFAULT cPath := cPatDat()

   IF !lExistTable( cPath + "SITUA.DBF" )
      dbCreate( cPath + "Situa.Dbf", { { "cSitua", "C", 30, 0 } }, cDriver() )
   END IF

   IF lExistIndex( cPath + "SITUA.CDX" )
      fErase( cPath + "SITUA.CDX" )
   END IF

   if lExistTable( cPath + "SITUA.DBF" )
      dbUseArea( .t., cDriver(), cPath + "SITUA.DBF", cCheckArea( "SITUA", @dbfSitua ), .f. )

      if !( dbfSitua )->( neterr() )
         ( dbfSitua )->( __dbPack() )

         ( dbfSitua )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
         ( dbfSitua )->( ordCreate( cPath + "SITUA.CDX", "CSITUA", "Upper( Field->cSitua )", {|| Upper( Field->cSitua ) } ) )

         ( dbfSitua )->( dbCloseArea() )
      else

         msgStop( "Imposible abrir en modo exclusivo situaciones" )

      end if

   end if

RETURN NIL

//----------------------------------------------------------------------------//

/*
Funcion para que siempre haya una impresora por defecto
*/

FUNCTION IsSitua()

   local oError
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   if !lExistTable( cPatDat() + "SITUA.DBF" )
      mkSitua( cPatDat() )
   end if

   if !lExistIndex( cPatDat() + "SITUA.CDX" )
      rxSitua( cPatDat() )
   end if

   RECOVER USING oError

      msgStop( "Imposible realizar las comprobación inicial de situaciones" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

 RETURN ( .t. )

//---------------------------------------------------------------------------//

CLASS TSituaciones FROM TMant

   CLASSDATA oInstance

   CLASSDATA aSituaciones

   DATA  cMru                                   INIT "Document_Attachment_16"

   METHOD New( cPath, oWndParent, oMenuItem )   CONSTRUCTOR
   METHOD Create( cPath )                       CONSTRUCTOR

   METHOD DefineFiles()

   METHOD Resource( nMode )
   METHOD   lSaveResource()

   METHOD LoadSituaciones()
   METHOD LoadSituacionesFromFiles()            INLINE ( if( ::OpenFiles(), ( ::LoadSituaciones(), ::CloseFiles() ), ) )
   METHOD GetSituaciones()                      INLINE ( if( empty( ::aSituaciones ), ::LoadSituacionesFromFiles() , ), ::aSituaciones ) 

   METHOD GetInstance()                         INLINE ( if( empty( ::oInstance ), ::oInstance := ::Create(), ) ) 
   METHOD EndInstance()                         INLINE ( if( !empty( ::oInstance ), ::oInstance := nil, ) ) 

END CLASS

//----------------------------------------------------------------------------//

METHOD New( cPath, oWndParent, oMenuItem )

   DEFAULT oWndParent   := GetWndFrame()
   DEFAULT oMenuItem    := "01096"

   ::Create( cPath )

   if Empty( ::nLevel )
      ::nLevel          := nLevelUsr( oMenuItem )
   end if

   if oWndParent != nil
      oWndParent:CloseAll()
   end if

   ::cPath              := cPath
   ::oWndParent         := oWndParent

   ::lAutoButtons       := .t.
   ::lCreateShell       := .f.

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Create( cPath )

   DEFAULT cPath        := cPatDat()

   ::cPath              := cPath
   ::oDbf               := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE DATABASE ::oDbf FILE "Situa.Dbf" CLASS "Situa" ALIAS "Situa" PATH ( cPath ) VIA ( cDriver ) COMMENT GetTraslation( "Situaciones" )

      FIELD NAME "cSitua"  TYPE "C" LEN 30  DEC 0  COMMENT "Número de serie"        COLSIZE 200    OF ::oDbf

      INDEX TO "Situa.Cdx" TAG "cSitua" ON "Upper( cSitua )"   COMMENT "Situación"  NODELETED      OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//----------------------------------------------------------------------------//

METHOD Resource( nMode )

   local oDlg

   DEFINE DIALOG oDlg RESOURCE "SITUACION" TITLE LblTitle( nMode ) + GetTraslation( "situación" )

   REDEFINE GET   ::oDbf:cSitua ;
      ID          100 ;
      WHEN        ( nMode != ZOOM_MODE ) ;
      OF          oDlg

   REDEFINE BUTTON ;
      ID          IDOK ;
      OF          oDlg ;
      WHEN        ( nMode != ZOOM_MODE ) ;
      ACTION      ( ::lSaveResource( oDlg ) )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          oDlg ;
      CANCEL ;
      ACTION      ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| ::lSaveResource( oDlg ) } )

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Method lSaveResource( oDlg )

   if Empty( ::oDbf:cSitua )
      MsgStop( "Código de " + GetTraslation( "situación" ) + " no puede estar vacío" )
      ::oGetCodigo:SetFocus()
      Return nil
   end if

   ::loadSituaciones()

Return ( oDlg:end( IDOK ) )

//---------------------------------------------------------------------------//

METHOD LoadSituaciones()

   ::aSituaciones := {}

   ::oDbf:GoTop()
   while !::oDbf:Eof()
      aAdd( ::aSituaciones, ::oDbf:cSitua )
      ::oDbf:Skip()
   end while

Return ( ::aSituaciones )

//---------------------------------------------------------------------------//

