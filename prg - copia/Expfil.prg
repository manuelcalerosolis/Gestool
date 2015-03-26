#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

static oWndBrw
static oExp
static oExpDet

//----------------------------------------------------------------------------//

STATIC FUNCTION OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DEFINE DATABASE oExp ;
        FILE    "EXPORT.DBF" ;
        PATH    ( cPatDat() );
        ALIAS   "EXPORT" ;
        VIA     cDriver() ;
        COMMENT "Base de datos de exportaciones"

            FIELD NAME "CTIPEXP"      TYPE "C" LEN  2  DEC 0 COMMENT "" DEFAULT "Tipo exportación"    OF oExp
            FIELD NAME "CCODEXP"      TYPE "C" LEN  3  DEC 0 COMMENT "" DEFAULT "Codigo exportación"  OF oExp
            FIELD NAME "CNOMEXP"      TYPE "C" LEN 35  DEC 0 COMMENT "" DEFAULT "Nombre exportación"  OF oExp
            FIELD NAME "CFILEXP"      TYPE "C" LEN 100 DEC 0 COMMENT "" DEFAULT "Fichero de salida de la exportación"   OF oExp

            INDEX TO "EXPORT.CDX" TAG "CCODEXP" ON "CCODEXP" NODELETED OF oExp
//          INDEX TO "EXPORT.CDX" TAG "CNOMEXP" ON "UPPER( CNOMEXP )" OF oExp

   END DATABASE oExp

   ACTIVATE DATABASE oExp SHARED // NOBUFFER

   DEFINE DATABASE oExpDet ;
        FILE    "EXPORTL.DBF" ;
        PATH    ( cPatDat() );
        ALIAS   "EXPORTL" ;
        VIA     cDriver() ;
        COMMENT "Base de datos de exportaciones "

            FIELD NAME "CCODEXP"      TYPE "C" LEN  3  DEC 0 COMMENT "" DEFAULT "Codigo exportación"           OF oExpDet
            FIELD NAME "CDESEXP"      TYPE "C" LEN 50  DEC 0 COMMENT "" DEFAULT "Nombre de la exportación"     OF oExpDet
            FIELD NAME "CEXPEXP"      TYPE "C" LEN 50  DEC 0 COMMENT "" DEFAULT "Expresión de la exportación"  OF oExpDet
            FIELD NAME "NLENEXP"      TYPE "N" LEN  2  DEC 0 COMMENT "" DEFAULT "Longitud de la exportación"   OF oExpDet
            FIELD NAME "NDECEXP"      TYPE "N" LEN  1  DEC 0 COMMENT "" DEFAULT "Decimales de la exportación"  OF oExpDet

            INDEX TO "EXPORTL.CDX" TAG "CCODEXP" ON "CCODEXP"          OF oExpDet
//          INDEX TO "EXPORTL.CDX" TAG "CNOMEXP" ON "UPPER( CNOMEXP )" OF oExpDet

   END DATABASE oExpDet

   ACTIVATE DATABASE oExpDet SHARED // NOBUFFER

   ADD RELATION LINK CCODEXP INTO oExp OF oExpDet

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      CloseFiles()
      lOpen          := .f.

   END SEQUENCE
   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles()

   if !Empty( oExp )
      oExp:end()
   end if
   if !Empty( oExpDet )
      oExpDet:end()
   end if

   oExp     := nil
   oExpDet  := nil
   oWndBrw  := nil

RETURN .T.

//----------------------------------------------------------------------------//

FUNCTION ExpFil( oWnd )

	IF oWndBrw == NIL

   if !OpenFiles()
      return nil
   end if

   DEFINE SHELL oWndBrw FROM 2, 10 TO 18, 70 ;
      TITLE   "Plantillas de exportaciones" ;
      FIELDS   oExp:CCODEXP,;
               oExp:CNOMEXP ;
      HEAD     "Codigo",;
               "Nombre" ;
      PROMPT   "Codigo",;
               "Nombre" ;
      ALIAS    ( oExp ) ;
      APPEND   EdtRec( APPD_MODE ) ;
		EDIT	   EdtRec( EDIT_MODE ) ;
      DELETE   ( oExp:delete() ) ;
		DUPLICAT EdtRec( APPD_MODE ) ;
      OF       oWnd

      DEFINE BTNSHELL RESOURCE "NEW" OF oWndBrw ;
			NOBORDER ;
      	ACTION  	( oWndBrw:RecAdd() );
			ON DROP	( oWndBrw:RecDup() );
			TOOLTIP 	"(A)ñadir";
			HOTKEY 	"A"

		DEFINE BTNSHELL RESOURCE "DUP" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( oWndBrw:RecDup() );
			TOOLTIP 	"(D)uplicar";
			HOTKEY 	"D"

		DEFINE BTNSHELL RESOURCE "EDIT" OF oWndBrw ;
			NOBORDER ;
			ACTION  	( oWndBrw:RecEdit() );
			TOOLTIP 	"(M)odificar";
			HOTKEY 	"M"

		DEFINE BTNSHELL RESOURCE "ZOOM" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( EdtRec( ZOOM_MODE ) );
			TOOLTIP 	"(Z)oom";
			HOTKEY 	"Z"

		DEFINE BTNSHELL RESOURCE "DEL" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( oWndBrw:RecDel() );
			TOOLTIP 	"(E)liminar";
			HOTKEY 	"E"

      DEFINE BTNSHELL RESOURCE "BUS" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( oWndBrw:search() ) ;
			TOOLTIP 	"(B)uscar" ;
			HOTKEY 	"B"

      DEFINE BTNSHELL RESOURCE "END" OF oWndBrw ;
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

STATIC FUNCTION EdtRec( nMode )

	local oDlg
   local oFld
	local oBrw

	DO CASE
	CASE nMode == APPD_MODE
         oExp:blank()
	CASE nMode == EDIT_MODE
         oExp:load()
	CASE nMode == ZOOM_MODE
         oExp:load()
	END DO

   DEFINE DIALOG oDlg RESOURCE "EXPFIL" TITLE LblTitle( nMode ) + "Exportación de ficheros"

		REDEFINE FOLDER oFld ID 400 OF oDlg ;
         PROMPT "&Plantilla", "Campos" ;
         DIALOGS "EXPFIL_1", "EXPFIL_2"

      REDEFINE GET oExp:CTIPEXP UPDATE;
			ID 		100 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			PICTURE 	"@!" ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET oExp:CCODEXP UPDATE;
			ID 		110 ;
         WHEN     ( nMode == APPD_MODE ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET oExp:CNOMEXP UPDATE ;
         ID       120 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET oExp:CFILEXP UPDATE ;
         ID       130 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oFld:aDialogs[1]

		REDEFINE LISTBOX oBrw ;
			FIELDS ;
                  oExpDet:CDESEXP ,;
                  oExpDet:CEXPEXP ,;
                  oExpDet:NLENEXP ,;
                  oExpDet:NDECEXP ;
			HEAD ;
                  "Nombre" ,;
                  "Expresión",;
                  "Lon",;
                  "Dec";
			FIELDSIZES;
                  200,;
                  200,;
                  20 ,;
                  20  ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ID       100 ;
         SELECT   "CCODEXP" FOR oExp:CCODEXP ;
         OF       oFld:aDialogs[2]

      oExpDet:SetBrowse( oBrw, .f. )
      oBrw:aJustify  := { .f., .t., .t. }

		REDEFINE BUTTON ;
			ID 		500 ;
         OF       oFld:aDialogs[2] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( EdtDet( APPD_MODE, oExp:CTIPEXP ) )

		REDEFINE BUTTON ;
			ID 		501 ;
         OF       oFld:aDialogs[2] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
        	ACTION	( EdtDet( EDIT_MODE ) )

		REDEFINE BUTTON ;
			ID 		502 ;
         OF       oFld:aDialogs[2] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( oExp:delete() )

		REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( 	if ( nMode == APPD_MODE,;
                        ( oExp:insert(), oExp:insert() ),;
                        ( oExp:update(), oExp:update() ) ),;
                     oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

	ACTIVATE DIALOG oDlg	CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

STATIC FUNCTION EdtDet( nMode, cNif )

	local oDlg

	DO CASE
	CASE nMode == APPD_MODE
			oTel:blank()
			oTel:CNIF	:= cNif
	CASE nMode == EDIT_MODE
			oTel:load()
	CASE nMode == ZOOM_MODE
			oTel:load()
	END DO


	DEFINE DIALOG oDlg RESOURCE "AGEDET" TITLE LblTitle( nMode ) + "Teléfono"

      REDEFINE GET oTel:CTELEFONO UPDATE;
			ID 		100 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			PICTURE 	"@!" ;
			OF 		oDlg

      REDEFINE GET oTel:NTELEFONO UPDATE;
			ID 		110 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

		REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   (  if ( nMode == APPD_MODE, oTel:insert(), oTel:update() ),;
                     oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

	ACTIVATE DIALOG oDlg	CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

FUNCTION rxExport( cPath, oMeter )

	local dbfAgenda

	DEFAULT cPath := cPatDat()

   fErase( cPath + "EXPORT.CDX" )
   fErase( cPath + "EXPORTL.CDX" )

   dbUseArea( .t., cDriver(), cPath + "AGENDA.DBF", cCheckArea( "AGENDA", @dbfAgenda ), .f. )
   if !( dbfAgenda )->( neterr() )
      ( dbfAgenda )->( __dbPack() )

      ( dbfAgenda )->( ordCondSet("!Deleted()", {||!Deleted()},,, {|| oMeter:Set( ( dbfAgenda )->( RecNo() ) ), sysrefresh() }, 1, ( dbfAgenda )->( RecNo() ), ) )
      ( dbfAgenda )->( ordCreate( cPath + "AGENDA.CDX", "CNIF", "CNIF", {|| CNIF } ) )

      ( dbfAgenda )->( ordCondSet("!Deleted()", {||!Deleted()},,, {|| oMeter:Set( ( dbfAgenda )->( RecNo() ) ), sysrefresh() }, 1, ( dbfAgenda )->( RecNo() ), ) )
      ( dbfAgenda )->( ordCreate( cPath + "AGENDA.CDX", "CAPELLIDOS", "UPPER( CAPELLIDOS )", {|| UPPER( CAPELLIDOS ) } ) )

      ( dbfAgenda )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de agenda" )
   end if

   dbUseArea( .t., cDriver(), cPath + "TELAGE.DBF", cCheckArea( "TELAGE", @dbfAgenda ), .f. )
   if !( dbfAgenda )->( neterr() )
      ( dbfAgenda )->( __dbPack() )

      ( dbfAgenda )->( ordCondSet("!Deleted()", {||!Deleted()},,, {|| oMeter:Set( ( dbfAgenda )->( RecNo() ) ), sysrefresh() }, 1, ( dbfAgenda )->( RecNo() ), ) )
      ( dbfAgenda )->( ordCreate( cPath + "TELAGE.CDX", "CNIF", "CNIF", {|| CNIF } ) )

      ( dbfAgenda )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de agenda" )
   end if

RETURN NIL

//--------------------------------------------------------------------------//