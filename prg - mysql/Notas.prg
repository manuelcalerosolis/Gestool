#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

Static oTimer
Static dbfNotas
Static oMsgAlarm
Static lOnProcess       := .f.

//----------------------------------------------------------------------------//

CLASS TNotas FROM TMant

   DATA cMru            INIT  "gc_notebook2_16"
   DATA cBitmap         INIT  "WebTopGreen"
   DATA oMenu
   DATA oBmpAlr

   DATA aCmbInteresado  INIT  { "Cliente", "Proveedor", "Artículo", "Agente", "Almacén" }
   DATA aCmbTipo

   DATA aBtnFecha       INIT  Array( 4 )
   DATA aBtnFilter      INIT  Array( 6 )

   DATA cFilterFecha    INIT  ""
   DATA cFilterEstado   INIT  ""

   DATA oDbfCli
   DATA oDbfPrv
   DATA oDbfArt
   DATA oDbfAge
   DATA oDbfAlm

   METHOD New( cPath, cDriver, oWndParent, oMenuItem ) CONSTRUCTOR

   METHOD Activate()

   METHOD Dialog()

   Method EditMenu( oDlg )

   METHOD OpenFiles( lExclusive )

   METHOD CloseFiles()

   METHOD DefineFiles( cPath )

   METHOD OpenService( lExclusive )

   METHOD Resource( nMode )

   METHOD ValidCodigoInteresado()

   METHOD HelpCodigoInteresado()

   Method ChangeCodigoInteresado()

   Method SetFilter( cExpresionFilter )

   Method SetFilterFecha( cExpresionFilter )

   Method SetFilterEstado( cExpresionFilter )

   Method ZoomDocument()

   Method Report()         INLINE   InfNotas():New( "Informe de notas", , , , , , ::oDbf ):Play()

END CLASS

//----------------------------------------------------------------------------//

METHOD New( cPath, cDriver, oWndParent, oMenuItem ) CLASS TNotas

   DEFAULT cPath        := cPatDat()
   DEFAULT cDriver      := cDriver()
   DEFAULT oWndParent   := oWnd()
   DEFAULT oMenuItem    := "01075"

   ::nLevel             := nLevelUsr( oMenuItem )

   /*
   Cerramos todas las ventanas
   */

   if oWndParent != nil
      oWndParent:CloseAll()
   end if

   ::cPath              := cPath
   ::cDriver            := cDriver

   ::oWndParent         := oWndParent
   ::oDbf               := nil

   ::lCreateShell       := .f.

   ::cHtmlHelp          := "Notas"
   ::oBmpAlr            := LoadBitmap( GetResources(), "gc_bell_16" )
   ::aCmbTipo           := TiposNotasModel():arrayTiposNotas()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenService( lExclusive, cPath ) CLASS TNotas

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lExclusive   := .f.

   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos" )

      ::CloseFiles()

      lOpen             := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive, lCloseNotas ) CLASS TNotas

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lExclusive   := .f.
   DEFAULT lCloseNotas  := .f.

   BEGIN SEQUENCE

   if Empty( ::oDbf )
      ::DefineFiles()
   end if

   ::oDbf:Activate( .f., !( lExclusive ) )
   ::oDbf:OrdScope( cCurUsr() )

   DATABASE NEW ::oDbfCli PATH ( cPatCli() ) FILE "Client.DBF"   VIA ( ::cDriver ) SHARED INDEX "CLIENT.CDX"

   DATABASE NEW ::oDbfPrv PATH ( cPatPrv() ) FILE "Provee.DBF"   VIA ( ::cDriver ) SHARED INDEX "PROVEE.CDX"

   DATABASE NEW ::oDbfArt PATH ( cPatArt() ) FILE "Articulo.DBF" VIA ( ::cDriver ) SHARED INDEX "ARTICULO.CDX"

   DATABASE NEW ::oDbfAge PATH ( cPatCli() ) FILE "Agentes.Dbf"  VIA ( ::cDriver ) SHARED INDEX "Agentes.Cdx"

   DATABASE NEW ::oDbfAlm PATH ( cPatAlm() ) FILE "Almacen.Dbf"  VIA ( ::cDriver ) SHARED INDEX "Almacen.Cdx"

   if lCloseNotas .and. oUser():lAlerta()
      CloseNotas()
   end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )
      ::CloseFiles()
      lOpen             := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD CloseFiles( lSetNotas )

   DEFAULT lSetNotas    := .f.

   if !Empty( ::oDbfCli ) .and. ::oDbfCli:Used()
      ::oDbfCli:End()
   end if

   if !Empty( ::oDbfPrv ) .and. ::oDbfPrv:Used()
      ::oDbfPrv:End()
   end if

   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if

   if !Empty( ::oDbfAlm ) .and. ::oDbfAlm:Used()
      ::oDbfAlm:End()
   end if

   if !Empty( ::oDbfAge ) .and. ::oDbfAge:Used()
      ::oDbfAge:End()
   end if

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:End()
   end if

   ::oDbf               := nil

   DeleteObject( ::oBmpAlr )

   if ::oMenu != nil
      ::oMenu:End()
   end if

   if lSetNotas .and. oUser():lAlerta()
      SetNotas()
   end if

RETURN .t.

//---------------------------------------------------------------------------//

METHOD Activate()

   if nAnd( ::nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      Return ( Self )
   end if

   /*
   Cerramos todas las ventanas
   */

   if ::oWndParent != nil
      ::oWndParent:CloseAll()
   end if

   if Empty( ::oDbf ) .or. !::oDbf:Used()
      ::lOpenFiles      := ::OpenFiles( .f., .t. )
   end if

   /*
   Creamos el Shell------------------------------------------------------------
   */

   if ::lOpenFiles

      ::CreateShell( ::nLevel )

      ::oWndBrw:GralButtons( Self )

      DEFINE BTNSHELL ::aBtnFilter[ 1 ] RESOURCE "bFilter" GROUP ;
         ACTION   ( ::SetFilter( nil, ::aBtnFilter[ 1 ], ::aBtnFilter ) ) ;
         TOOLTIP  "(T)odas" ;
         HOTKEY   "T" ;
         OF       ::oWndBrw

      DEFINE BTNSHELL ::aBtnFilter[ 2 ] RESOURCE "bFilter" GROUP ;
         ACTION   ( ::SetFilter( "Rtrim( cEstNot ) == 'No comenzada'", ::aBtnFilter[ 2 ], ::aBtnFilter ) ) ;
         TOOLTIP  "(N)o comenzada" ;
         HOTKEY   "N" ;
         OF       ::oWndBrw

      DEFINE BTNSHELL ::aBtnFilter[ 3 ] RESOURCE "bFilter" GROUP ;
         ACTION   ( ::SetFilter( "Rtrim( cEstNot ) == 'En curso'", ::aBtnFilter[ 3 ], ::aBtnFilter ) ) ;
         TOOLTIP  "(E)n curso" ;
         HOTKEY   "E" ;
         OF       ::oWndBrw

      DEFINE BTNSHELL ::aBtnFilter[ 4 ] RESOURCE "bFilter" GROUP ;
         ACTION   ( ::SetFilter( "Rtrim( cEstNot ) == 'Completada'", ::aBtnFilter[ 4 ], ::aBtnFilter ) ) ;
         TOOLTIP  "(C)ompletada" ;
         HOTKEY   "C" ;
         OF       ::oWndBrw

      DEFINE BTNSHELL ::aBtnFilter[ 5 ] RESOURCE "bFilter" GROUP ;
         ACTION   ( ::SetFilter( "Rtrim( cEstNot ) == 'A la espera de otra persona'", ::aBtnFilter[ 5 ], ::aBtnFilter ) ) ;
         TOOLTIP  "A la es(p)era..." ;
         HOTKEY   "P" ;
         OF       ::oWndBrw

      DEFINE BTNSHELL ::aBtnFilter[ 6 ] RESOURCE "bFilter" GROUP ;
         ACTION   ( ::SetFilter( "Rtrim( cEstNot ) == 'Aplazada'", ::aBtnFilter[ 6 ], ::aBtnFilter ) ) ;
         TOOLTIP  "Apla(z)ada" ;
         HOTKEY   "Z" ;
         OF       ::oWndBrw

      ::oWndBrw:EndButtons( Self )

      ::oWndBrw:cHtmlHelp  := "Notas"

      ::oWndBrw:Activate(  , , , , , , , , , , , , , , , , {|| ::CloseFiles( .t. ) } )

   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Dialog()

   local oDlg
   local oGetBuscar
   local cGetBuscar  := Space( 100 )
   local oCbxOrden
   local cCbxOrden   := "Fecha"

   if nAnd( ::nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      Return ( Self )
   end if

   /*
   Cerramos todas las ventanas
   */

   if Empty( ::oDbf ) .or. !::oDbf:Used()
      ::lOpenFiles   := ::OpenFiles()
   end if

   /*
   Creamos el Shell------------------------------------------------------------
   */

   if ::lOpenFiles

      DEFINE DIALOG oDlg RESOURCE "DIALOG_PDA"

      REDEFINE GET oGetBuscar ;
         VAR      cGetBuscar;
         ID       100 ;
         BITMAP   "FIND" ;
         OF       oDlg

      oGetBuscar:bChange   := {| nKey, nFlags | AutoSeek( nKey, nFlags, oGetBuscar, ::oWndBrw, ::oDbf:nArea, .t., cCurUsr() ) }

      REDEFINE COMBOBOX oCbxOrden ;
         VAR      cCbxOrden ;
         ID       110 ;
         ITEMS    { "Fecha", "Asunto", "Estado" } ;
			OF 		oDlg

      oCbxOrden:bChange    := {|| ::oDbf:OrdSetFocus( oCbxOrden:nAt ), ::oDbf:GoTop(), ::oWndBrw:Refresh(), oGetBuscar:SetFocus() }

#ifdef __PDA__

      REDEFINE IBROWSE ::oWndBrw;
         FIELDS   ::oDbf:nAlrNot,;
                  Dtoc( ::oDbf:dFecNot ),;
                  ::oDbf:cTexNot,;
                  ::oDbf:aIntNot,;
                  ::oDbf:cIntNot,;
                  ::oDbf:cNomNot,;
                  ::oDbf:cTipNot,;
                  Trans( ::oDbf:cHorNot, "@R 99:99" ),;
                  ::oDbf:cEstNot;
         SIZES    16,;
                  68,;
                  60,;
                  60,;
                  60,;
                  120,;
                  70,;
                  40,;
                  80 ;
         HEAD     "",;
                  "Fecha",;
                  "Asunto",;
                  "Interesado",;
                  "Código",;
                  "Nombre",;
                  "Tipo",;
                  "Hora",;
                  "Estado" ;
         JUSTIFY  .f.,;
                  .f.,;
                  .f.,;
                  .f.,;
                  .f.,;
                  .f.,;
                  .f.,;
                  .f.,;
                  .f. ;
         ID       200 ;
         OF       oDlg

      ::oDbf:SetBrowse( ::oWndBrw )

      ::oWndBrw:cWndName   := "Agenda pda"
      ::oWndBrw:bLDblClick := {|| ::Edit() }

      ::oWndBrw:CloseData()

#endif

      oDlg:bValid          := {|| ::CloseFiles() }

      oDlg:Activate( , , , .t., , , {|| ::EditMenu( oDlg ) } )

   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

Method EditMenu( oDlg )

   MENU ::oMenu

      MENUITEM    "1. Fecha"

         MENU

            MENUITEM    ::aBtnFecha[ 1 ] ;
               PROMPT   "&1. Todas";
               CHECKED ;
               ACTION   ( ::SetFilterFecha( ".t.", ::aBtnFecha[ 1 ] ) );

            MENUITEM    ::aBtnFecha[ 2 ] ;
               PROMPT   "&2. Hoy";
               ACTION   ( ::SetFilterFecha( "dFecNot == Date()", ::aBtnFecha[ 2 ] ) );

            MENUITEM    ::aBtnFecha[ 3 ] ;
               PROMPT   "&3. Semana";
               ACTION   ( ::SetFilterFecha( "Week( dFecNot ) == Week( Date() )", ::aBtnFecha[ 3 ] ) );

            MENUITEM    ::aBtnFecha[ 4 ] ;
               PROMPT   "&4. Mes";
               ACTION   ( ::SetFilterFecha( "Month( dFecNot ) == Month( Date() )", ::aBtnFecha[ 4 ] ) );

         ENDMENU

      MENUITEM    "&2. Estado"

         MENU

            MENUITEM    ::aBtnFilter[ 1 ] ;
               PROMPT   "&1. Todos los asuntos";
               CHECKED ;
               ACTION   ( ::SetFilterEstado( ".t.", ::aBtnFilter[ 1 ] ) );

            MENUITEM    ::aBtnFilter[ 2 ] ;
               PROMPT   "&2. No comenzada";
               ACTION   ( ::SetFilterEstado( "Rtrim( cEstNot ) == 'No comenzada'", ::aBtnFilter[ 2 ] ) );

            MENUITEM    ::aBtnFilter[ 3 ] ;
               PROMPT   "&3. En curso";
               ACTION   ( ::SetFilterEstado( "Rtrim( cEstNot ) == 'En curso'", ::aBtnFilter[ 3 ] ) );

            MENUITEM    ::aBtnFilter[ 4 ] ;
               PROMPT   "&4. Completadas";
               ACTION   ( ::SetFilterEstado( "Rtrim( cEstNot ) == 'Completada'", ::aBtnFilter[ 4 ] ) );

            MENUITEM    ::aBtnFilter[ 5 ] ;
               PROMPT   "&5. A la espera...";
               ACTION   ( ::SetFilterEstado( "Rtrim( cEstNot ) == 'A la espera de otra persona'", ::aBtnFilter[ 5 ] ) );

            MENUITEM    ::aBtnFilter[ 6 ] ;
               PROMPT   "&6. Aplazada";
               ACTION   ( ::SetFilterEstado( "Rtrim( cEstNot ) == 'Aplazada'", ::aBtnFilter[ 6 ] ) );

         ENDMENU

      MENUITEM    "&3. Edición"

         MENU

            MENUITEM    "&1. Añadir";
               ACTION   ( if( nAnd( ::nLevel, ACC_APPD ) != 0, ::Append(), MsgStop( "Acceso no permitido" ) ) );

            MENUITEM    "&2. Modificar";
               ACTION   ( if( nAnd( ::nLevel, ACC_EDIT ) != 0, ::Edit(),   MsgStop( "Acceso no permitido" ) ) );

            MENUITEM    "&3. Eliminar";
               ACTION   ( if( nAnd( ::nLevel, ACC_DELE ) != 0, ::Del(),    MsgStop( "Acceso no permitido" ) ) );

            MENUITEM    "&4. Zoom";
               ACTION   ( if( nAnd( ::nLevel, ACC_ZOOM ) != 0, ::Zoom(),   MsgStop( "Acceso no permitido" ) ) );

         ENDMENU

      MENUITEM    "&S. Salir";
         MESSAGE  "Salir de la ventana actual" ;
         RESOURCE "End" ;
         ACTION   ( oDlg:End() );

   ENDMENU

   oDlg:SetMenu( ::oMenu )

Return ( ::oMenu )

//---------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver ) CLASS TNotas

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE DATABASE ::oDbf ;
      FILE     "AgendaUsr.dbf" ;
      CLASS    "AgendaUsr" ;
      ALIAS    "AgendaUsr" ;
      PATH     ( cPath ) ;
      VIA      ( cDriver ) ;
      COMMENT  "Agenda/CRM" //  del usuario " + Capitalize( oUser():cNombre() )

      FIELD NAME "lAlrNot" TYPE "L"    LEN   1  DEC 0  COMMENT ""                         HIDE                          OF ::oDbf
      FIELD CALCULATE NAME "nAlrNot"   LEN   1  DEC 0  COMMENT "" VAL {|| ::oDbf:lAlrNot } BITMAPS "Sel16", "Nil16" COLSIZE 18 OF ::oDbf
      FIELD NAME "cTexNot" TYPE "C"    LEN 100  DEC 0  COMMENT "Asunto"                   COLSIZE 180                   OF ::oDbf
      FIELD NAME "nIntNot" TYPE "N"    LEN   1  DEC 0  COMMENT "Interesado"               HIDE                          OF ::oDbf
      FIELD CALCULATE NAME "aIntNot"   LEN   1  DEC 0  COMMENT "Interesado" VAL ( ::aCmbInteresado[ Min( Max( ::oDbf:nIntNot, 1 ), len( ::aCmbInteresado ) ) ] ) COLSIZE 70 OF ::oDbf
      FIELD NAME "cIntNot" TYPE "C"    LEN  12  DEC 0  COMMENT "Código"                   COLSIZE 60                    OF ::oDbf
      FIELD NAME "cNomNot" TYPE "C"    LEN 100  DEC 0  COMMENT "Nombre"                   COLSIZE 180                   OF ::oDbf
      FIELD NAME "cTipNot" TYPE "C"    LEN  30  DEC 0  COMMENT "Tipo"                     COLSIZE 80                    OF ::oDbf
      FIELD NAME "dFecNot" TYPE "D"    LEN   8  DEC 0  COMMENT "Fecha"                    COLSIZE 80                    OF ::oDbf
      FIELD NAME "cHorNot" TYPE "C"    LEN   4  DEC 0  COMMENT "Hora"                     COLSIZE 60 PICTURE "@R 99:99" OF ::oDbf
      FIELD NAME "lVisNot" TYPE "L"    LEN   1  DEC 0  COMMENT "Lógico para visto"        HIDE                          OF ::oDbf
      FIELD NAME "dVctNot" TYPE "D"    LEN   8  DEC 0  COMMENT "Vencimiento"              HIDE                          OF ::oDbf
      FIELD NAME "cDesNot" TYPE "M"    LEN  10  DEC 0  COMMENT "Texto largo de la nota"   HIDE                          OF ::oDbf
      FIELD NAME "cObsNot" TYPE "M"    LEN  10  DEC 0  COMMENT "Observaciones de la nota" HIDE                          OF ::oDbf
      FIELD NAME "cEstNot" TYPE "C"    LEN  50  DEC 0  COMMENT "Estado"                   COLSIZE 100                   OF ::oDbf
      FIELD NAME "cUsrNot" TYPE "C"    LEN   3  DEC 0  COMMENT "Usuario"                  HIDE                          OF ::oDbf
      FIELD NAME "cTipDoc" TYPE "C"    LEN   2  DEC 0  COMMENT "Tipo de documento"        HIDE                          OF ::oDbf
      FIELD NAME "cNumDoc" TYPE "C"    LEN  12  DEC 0  COMMENT "Documento"                HIDE                          OF ::oDbf

      INDEX TO "AgendaUsr.cdx" TAG "dFecNot" ON "cUsrNot + Dtos( dFecNot ) + cHorNot"     COMMENT "Fecha"   NODELETED   OF ::oDbf
      INDEX TO "AgendaUsr.cdx" TAG "cTexNot" ON "cUsrNot + Upper( cTexNot )"              COMMENT "Asunto"  NODELETED   OF ::oDbf
      INDEX TO "AgendaUsr.cdx" TAG "cEstNot" ON "cUsrNot + Upper( cEstNot )"              COMMENT "Estado"  NODELETED   OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//----------------------------------------------------------------------------//

METHOD Resource( nMode, aInit ) CLASS TNotas

	local oDlg
   local oGetHora
   local oCmbTipo
   local oCmbEstado
   local oCmbInteresado
   local cCmbInteresado
   local oGetCodigoInteresado
   local oGetNombreInteresado
   local oGetNumeroDocumento
   local oGetTipoDocumento
   local cGetTipoDocumento
   local oBmpGeneral

   do case
      case nMode == ESPE_MODE
         ::oDbf:dFecNot    := GetSysDate()
         ::oDbf:cHorNot    := SubStr( Time(), 1, 2 ) + SubStr( Time(), 4, 2 )
         ::oDbf:cUsrNot    := cCurUsr()
         cCmbInteresado    := ::aCmbInteresado[ 1 ]
         ::oDbf:cTexNot    := aInit[ 1 ]
         ::oDbf:cTipDoc    := aInit[ 2 ]
         ::oDbf:cIntNot    := aInit[ 3 ]
         ::oDbf:cNomNot    := aInit[ 4 ]
         ::oDbf:cNumDoc    := aInit[ 5 ]
         ::oDbf:cDesNot    := aInit[ 6 ]

      case nMode == APPD_MODE
         ::oDbf:dFecNot    := GetSysDate()
         ::oDbf:cHorNot    := SubStr( Time(), 1, 2 ) + SubStr( Time(), 4, 2 )
         ::oDbf:cUsrNot    := cCurUsr()
         cCmbInteresado    := ::aCmbInteresado[ 1 ]

      otherwise
         if ::oDbf:lVisNot
            ::oDbf:cEstNot := "Completada"
         end if
         cCmbInteresado    := ::aCmbInteresado[ Min( Max( ::oDbf:nIntNot, 1 ), len( ::aCmbInteresado ) ) ]

   end case

   cGetTipoDocumento       := cTextoDocumento( ::oDbf:cTipDoc )

   if ( "PDA" $ appParamsMain() )
   DEFINE DIALOG oDlg RESOURCE "NOTAS_PDA"   TITLE LblTitle( nMode ) + "apunte de agenda"
   else
   DEFINE DIALOG oDlg RESOURCE "NOTAS"       TITLE LblTitle( nMode ) + "apunte de agenda"
   end if

   REDEFINE BITMAP oBmpGeneral ;
      ID       990 ;
      RESOURCE "gc_notebook2_48" ;
      TRANSPARENT ;
      OF       oDlg

   REDEFINE GET ::oDbf:cTexNot ;
		WHEN 		( nMode != ZOOM_MODE ) ;
      VALID    ( !Empty( ::oDbf:cTexNot ) ) ;
      ID       100 ;
		OF 		oDlg

   REDEFINE COMBOBOX oCmbInteresado ;
      VAR      cCmbInteresado ;
      ITEMS    ::aCmbInteresado ;
      ID       110 ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      OF       oDlg

   oCmbInteresado:bChange        := {|| ::ChangeCodigoInteresado( oGetCodigoInteresado, oGetNombreInteresado ) }

   REDEFINE GET oGetCodigoInteresado ;
      VAR      ::oDbf:cIntNot ;
      ID       120 ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      BITMAP   "Lupa" ;
      OF       oDlg

   oGetCodigoInteresado:bValid   := {|| ::ValidCodigoInteresado( cCmbInteresado, oGetNombreInteresado ) }
   oGetCodigoInteresado:bHelp    := {|| ::HelpCodigoInteresado( cCmbInteresado, oGetCodigoInteresado, oGetNombreInteresado ) }

   REDEFINE GET oGetNombreInteresado ;
      VAR      ::oDbf:cNomNot ;
      ID       130 ;
      OF       oDlg

   REDEFINE COMBOBOX oCmbTipo ;
      VAR      ::oDbf:cTipNot;
      ITEMS    ::aCmbTipo ;
      ID       140 ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      OF       oDlg

   REDEFINE GET ::oDbf:dFecNot ;
		WHEN 		( nMode != ZOOM_MODE ) ;
		SPINNER ;
      ID       150 ;
		OF 		oDlg

   REDEFINE GET oGetHora ;
      VAR      ::oDbf:cHorNot ;
      PICTURE  ::oDbf:FieldByName( "cHorNot" ):cPict ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      SPINNER ;
      ON UP    ( UpTime( oGetHora ) );
      ON DOWN  ( DwTime( oGetHora ) );
      VALID    ( validHourMinutes( ::oDbf:cHorNot ) ) ;
      ID       160 ;
		OF 		oDlg

   REDEFINE CHECKBOX ::oDbf:lAlrNot ;
		WHEN 		( nMode != ZOOM_MODE ) ;
      ID       170 ;
		OF 		oDlg

   REDEFINE COMBOBOX oCmbEstado ;
      VAR      ::oDbf:cEstNot;
      ITEMS    { "No comenzada", "En curso", "Completada", "A la espera de otra persona", "Aplazada" } ;
      ID       180 ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      OF       oDlg

   REDEFINE CHECKBOX ::oDbf:lVisNot ;
		WHEN 		( nMode != ZOOM_MODE ) ;
      ON CHANGE( if( ::oDbf:lVisNot, oCmbEstado:oGet:cText( "Completada" ), ) );
      ID       190 ;
		OF 		oDlg

   REDEFINE GET ::oDbf:cDesNot MEMO ;
      ID       200 ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      OF       oDlg

   REDEFINE GET ::oDbf:cObsNot MEMO ;
      ID       230 ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      OF       oDlg

   REDEFINE GET oGetNumeroDocumento ;
      VAR      ::oDbf:cNumDoc ;
      PICTURE  "@R #/#########/##" ;
      ID       210 ;
      BITMAP   "gc_flash_16" ;
      OF       oDlg

   oGetNumeroDocumento:bHelp  := {|| ::ZoomDocument() }

   REDEFINE GET oGetTipoDocumento ;
      VAR      cGetTipoDocumento ;
      ID       220 ;
      WHEN     ( .f. ) ;
      OF       oDlg

   REDEFINE BUTTON ;
      ID       IDOK ;
      OF       oDlg ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      ACTION   ( oDlg:end( IDOK ) )

   REDEFINE BUTTON ;
      ID       IDCANCEL ;
      OF       oDlg ;
      CANCEL ;
      ACTION   ( oDlg:end() )

   if !( "PDA" $ appParamsMain() )
   REDEFINE BUTTON ;
      ID       9 ;
      OF       oDlg ;
      ACTION   ( ChmHelp( "Notas" ) )
   end if

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| oDlg:end( IDOK ) } )
   end if
      oDlg:AddFastKey( VK_F1, {|| ChmHelp( "Notas" ) } )

   ACTIVATE DIALOG oDlg CENTER

   oBmpGeneral:End()

   ::oDbf:nIntNot := oCmbInteresado:nAt

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Function AppendNotas()

Return ( TNotas():New( cPatDat(), oWnd(), "01075" ):Activate():Append() )

//--------------------------------------------------------------------------//

Function EditNotas( nRecno )

   local oNotas   := TNotas():New( cPatDat(), oWnd(), "01075" )

   if !Empty( oNotas )
      oNotas:Activate()
      oNotas:oDbf:GoTo( nRecno )
      oNotas:Edit()
   end if

Return ( nil )

//--------------------------------------------------------------------------//

METHOD ValidCodigoInteresado( cCmbInteresado, oGetNombreInteresado )

   if Empty( ::oDbf:cIntNot )
      return .t.
   end if

   do case
      case cCmbInteresado == "Cliente"

         if ::oDbfCli:Seek( ::oDbf:cIntNot )
            oGetNombreInteresado:cText( ::oDbfCli:Titulo )
         else
            MsgStop( "Cliente no encontrado" )
            Return .f.
         end if

      case cCmbInteresado == "Proveedor"

         if ::oDbfPrv:Seek( ::oDbf:cIntNot )
            oGetNombreInteresado:cText( ::oDbfCli:Titulo )
         else
            MsgStop( "Proveedor no encontrado" )
            Return .f.
         end if

      case cCmbInteresado == "Artículo"

         if ::oDbfArt:Seek( ::oDbf:cIntNot )
            oGetNombreInteresado:cText( ::oDbfArt:Nombre )
         else
            MsgStop( "Artículo no encontrado" )
            Return .f.
         end if

      case cCmbInteresado == "Agente"

         if ::oDbfAge:Seek( ::oDbf:cIntNot )
            oGetNombreInteresado:cText( Rtrim( ::oDbfAge:cApeAge ) + ", " + ::oDbfAge:cNbrAge )
         else
            MsgStop( "Agente no encontrado" )
            Return .f.
         end if

      case cCmbInteresado == "Almacén"

         if ::oDbfAlm:Seek( ::oDbf:cIntNot )
            oGetNombreInteresado:cText( ::oDbfAlm:cNomAlm )
         else
            MsgStop( "Almacén no encontrado" )
            Return .f.
         end if

   end case

Return .t.

//--------------------------------------------------------------------------//

METHOD HelpCodigoInteresado( cCmbInteresado, oGetCodigoInteresado, oGetNombreInteresado )

   do case
      case cCmbInteresado == "Cliente"
         BrwClient( oGetCodigoInteresado, oGetNombreInteresado )

      case cCmbInteresado == "Proveedor"
         BrwProvee( oGetCodigoInteresado, oGetNombreInteresado )

      case cCmbInteresado == "Artículo"
         BrwArticulo( oGetCodigoInteresado, oGetNombreInteresado )

      case cCmbInteresado == "Agente"
         BrwAgentes( oGetCodigoInteresado, oGetNombreInteresado )

      case cCmbInteresado == "Almacén"
         BrwAlmacen( oGetCodigoInteresado, oGetNombreInteresado )

   end case

Return ( Self )

//---------------------------------------------------------------------------//

Method ChangeCodigoInteresado( oGetCodigoInteresado, oGetNombreInteresado )

   oGetCodigoInteresado:cText( Space( 12 ) )
   oGetNombreInteresado:cText( "" )

Return ( Self )

//---------------------------------------------------------------------------//

Method SetFilter( cFltExpresion, oBtn, aBtn )

   ::oDbf:SetFilter( cFltExpresion )
   ::oWndBrw:Refresh()

   // Ponemos todos los filtros vacios-----------------------------------------

   if oBtn:ClassName == "TMENUITEM"
      aEval( aBtn, {| oBtn | oBtn:SetCheck( .f. ) } )
      oBtn:SetCheck( .t. )
   else

   // aEval( aBtn, {| oBtn | TvSetItemImage( ::oWndBrw:oBtnBar:hWnd, oBtn:hItem, 8 ) } )
   aEval( aBtn, {| oBtn | ::oWndBrw:oBtnBar:SetItemImage( oBtn, 8 ) } )

   // TvSetItemImage( ::oWndBrw:oBtnBar:hWnd, oBtn:hItem, 7 )
   ::oWndBrw:oBtnBar:SetItemImage( oBtn, 7 )

   end if

Return ( Self )

//---------------------------------------------------------------------------//

Method SetFilterFecha( cFltExpresion, oBtn )

   ::cFilterFecha    := cFltExpresion

   if !Empty( ::cFilterEstado )
      cFltExpresion  := ::cFilterEstado + ' .and. ' + cFltExpresion
   end if

   ::oDbf:SetFilter( cFltExpresion )

   ::oWndBrw:Refresh()

   // Ponemos todos los filtros vacios-----------------------------------------

   aEval( ::aBtnFecha, {| oBtn | oBtn:SetCheck( .f. ) } )

   oBtn:SetCheck( .t. )

Return ( Self )

//---------------------------------------------------------------------------//

Method SetFilterEstado( cFltExpresion, oBtn )

   ::cFilterEstado    := cFltExpresion

   if !Empty( ::cFilterFecha )
      cFltExpresion  := ::cFilterFecha + ' .and. ' + cFltExpresion
   end if

   ::oDbf:SetFilter( cFltExpresion )

   ::oWndBrw:Refresh()

   // Ponemos todos los filtros vacios-----------------------------------------

   aEval( ::aBtnFilter, {| oBtn | oBtn:SetCheck( .f. ) } )

   oBtn:SetCheck( .t. )

Return ( Self )

//---------------------------------------------------------------------------//

Method ZoomDocument()

   do case
      case ::oDbf:cTipDoc == PRE_CLI
         ZooPreCli( ::oDbf:cNumDoc, .f., ( "PDA" $ appParamsMain() ) )

      case ::oDbf:cTipDoc == PED_CLI
         ZooPedCli( ::oDbf:cNumDoc )

      case ::oDbf:cTipDoc == ALB_CLI
         ZooAlbCli( ::oDbf:cNumDoc )

      case ::oDbf:cTipDoc == FAC_CLI
         ZooFacCli( ::oDbf:cNumDoc )

      case ::oDbf:cTipDoc == ANT_CLI
         ZooAntCli( ::oDbf:cNumDoc )

   end case

Return ( Self )

//---------------------------------------------------------------------------//

Function GenerarNotas( aData )

   local lAppend
   local oNotas   := TNotas():New( cPatDat(), nil, "01075" )

   if oNotas != nil .and. oNotas:OpenFiles()

      oNotas:oDbf:Blank()
      oNotas:oDbf:SetDefault()

      lAppend     := oNotas:Resource( ESPE_MODE, aData )

      if lAppend
         oNotas:oDbf:Insert()
      else
         oNotas:oDbf:Cancel()
      end if

   end if

   oNotas:End()

Return ( lAppend )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

FUNCTION ChkNotas()

   local cDate    := Dtos( date() )
   local cTime    := Time()
   local oBlock

	cTime 			:= SubStr( cTime, 1, 2 ) + SubStr( cTime, 4, 2 )

   if !File( cPatDat() + "AgendaUsr.dbf" ) .or. !File( cPatDat() + "AgendaUsr.cdx" )
      return nil
   end if

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   if !Empty( dbfNotas ) .and. ( dbfNotas )->( Used() ) .and. !lOnProcess .and. Empty( oMsgAlarm )

      lOnProcess  := .t.

      ( dbfNotas )->( dbGoTop() )
      while ( dbfNotas )->( !Eof() )

         if Dtos( ( dbfNotas )->dFecNot ) + ( dbfNotas )->cHorNot < cDate + cTime .and. !( dbfNotas )->lVisNot .and. ( dbfNotas )->lAlrNot
            oMsgAlarm         := TMsgItem():New( oWnd():oMsgBar,,24,,,,.t.,,"gc_bell_16",, "Asunto : " + AllTrim( ( dbfNotas )->cTexNot ) )
            oMsgAlarm:bAction := {|| TNotas():New( cPatDat(), oWnd(), "01075" ):Activate() }
            exit
         end if

			( dbfNotas )->( dbSkip() )

      end do

      lOnProcess  := .f.

   end if

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION SetNotas()

   if !lAIS()

      if !file( cPatDat() + "AgendaUsr.dbf" )
         msgStop( "El fichero " + ( cPatDat() + "AgendaUsr.dbf" ) + " no existe." )
         return nil
      end if 

      if !file( cPatDat() + "AgendaUsr.cdx" )
         msgStop( "El fichero " + ( cPatDat() + "AgendaUsr.cdx" ) + " no existe." )
         return nil
      end if

   end if

   USE ( cPatDat() + "AgendaUsr.dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "NOTAS", @dbfNotas ) )
   SET ADSINDEX TO ( cPatDat() + "AgendaUsr.cdx" ) ADDITIVE

   ( dbfNotas )->( OrdScope( 0, cCurUsr() ) )
   ( dbfNotas )->( OrdScope( 1, cCurUsr() ) )

   oTimer      := TTimer():New( 6000, {|| ChkNotas() } ):Activate()

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION CloseNotas()

   if !Empty( oTimer )
      oTimer:End()
   end if

   if !Empty( dbfNotas ) .and. ( dbfNotas )->( Used() )
      ( dbfNotas )->( dbCloseArea() )
   end if

   if !Empty( oMsgAlarm )
      oWnd():oMsgBar:DelItem( oMsgAlarm )
   end if

   oTimer      := nil
   dbfNotas    := nil
   oMsgAlarm   := nil

RETURN NIL

//--------------------------------------------------------------------------//

Function DialogNotas()

   local oDlg
   local oBrw
   local oGetBuscar
   local cGetBuscar  := Space( 100 )
   local oCbxOrden
   local cCbxOrden   := "Fecha"

   DEFINE DIALOG oDlg RESOURCE "DIALOG_PDA"

      REDEFINE GET oGetBuscar ;
         VAR      cGetBuscar;
         ID       100 ;
         OF       oDlg

      REDEFINE COMBOBOX oCbxOrden ;
         VAR      cCbxOrden ;
         ID       110 ;
         ITEMS    { "Fecha", "Asunto", "Estado" } ;
			OF 		oDlg


   oDlg:Activate( , , , .t. )


RETURN ( nil )

//----------------------------------------------------------------------------//