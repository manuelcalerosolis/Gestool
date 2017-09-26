#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

static oAuditor

//---------------------------------------------------------------------------//

Function CreateAuditor()

   if Empty( oAuditor )
      oAuditor    := TAuditor():Create( cPatDat() )
   end if

Return nil

//---------------------------------------------------------------------------//

Function CloseAuditor()

   if !Empty( oAuditor )
      oAuditor:CloseService()
   end if

   oAuditor       := nil

Return nil

//---------------------------------------------------------------------------//

Function OpenAuditor()

   if Empty( oAuditor )
      oAuditor    := TAuditor():Create( cPatDat() )
   end if

   if !Empty( oAuditor )
      oAuditor:OpenService()
   end if

Return nil

//----------------------------------------------------------------------------//

Function AddAuditor( cCodUse, cCodMnu, cCodOpe )

Return oAuditor:Add( cCodUse, cCodMnu, cCodOpe )

//----------------------------------------------------------------------------//

Function oAuditor()

Return ( oAuditor )

//----------------------------------------------------------------------------//

Function ShellAuditor( cPath, oWnd, oMenuItem )

   /*
   if !Empty( oAuditor )
      oAuditor:CloseService()
      oAuditor    := nil
   end if
   */

   TAuditor():New( cPath, oWnd, oMenuItem ):Activate()

   /*
   oAuditor       := TAuditor():Create( cPatDat() )

   if !Empty( oAuditor )
      oAuditor:OpenService()
   end if
   */

Return ( oAuditor )

//----------------------------------------------------------------------------//

Function AuditorAddEvent( cEvent, cDocument, cTipo )

   if !Empty( oAuditor )
      oAuditor:AddEvent( cEvent, cDocument, cTipo )
   end if

Return ( oAuditor )

//----------------------------------------------------------------------------//

CLASS TAuditor FROM TMant

   DATA lOpenFiles         INIT .f.

   DATA cMru               INIT "gc_security_agent_16"
   DATA aBmp               INIT {}

   DATA oEmpresa
   DATA oUsuario

   DATA oFilter

   DATA oTree
   DATA oImageList

   DATA dInicio
   DATA dFin

   DATA oCodigoUsuario
   DATA cCodigoUsuario

   DATA oCodigoEmpresa
   DATA cCodigoEmpresa

   DATA cComentario

   METHOD OpenFiles()
   METHOD OpenService()

   METHOD Activate()

   METHOD DefineFiles()

   METHOD CloseFiles()
   METHOD CloseService()

   METHOD Resource( nMode )

   METHOD AddEvent( cEvent )

   METHOD StartAplication()

   METHOD EndAplication()

   Method BitmapOperacion()

   Method AddEventFacturaClientes( nMode, cDocument )

   Method FechayHoraOperacion()     INLINE   ( Dtoc( ::oDbf:dFecOpe ) + Space( 1 ) + ::oDbf:cTimOpe )

   Method UsuarioOperacion()

   Method EmpresaOperacion()

   Method NumeroOperacion()

   Method TipoOperacion()

   Method Filter()
   Method InitFilter()
   Method CreateFilter()
   Method AplyFilter()

   Method DropTrigger()
   Method CreateTrigger()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate()

   if nAnd( ::nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      Return ( Self )
   end if

   if ::oWndParent != nil
      ::oWndParent:CloseAll()
   end if

   if Empty( ::oDbf ) .or. !::oDbf:Used()
      ::lOpenFiles      := ::OpenFiles()
   end if

   if ::lOpenFiles

      if !::lCreateShell
         ::CreateShell( ::nLevel )
      end if

      DEFINE BTNSHELL RESOURCE "BUS" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::oWndBrw:SearchSetFocus() ) ;
         TOOLTIP  "(B)uscar" ;
         HOTKEY   "B";

         ::oWndBrw:AddSeaBar()

      DEFINE BTNSHELL RESOURCE "ZOOM" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::Zoom() );
         TOOLTIP  "(Z)oom";
         HOTKEY   "Z" ;
         LEVEL    ACC_ZOOM

      DEFINE BTNSHELL RESOURCE "BFILTER" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::Filter() ) ;
         TOOLTIP  "(F)iltrar" ;
         HOTKEY   "F"

      ::oWndBrw:EndButtons( Self )

      if ::cHtmlHelp != nil
         ::oWndBrw:cHtmlHelp  := ::cHtmlHelp
      end if

      ::oWndBrw:Activate(  nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, {|| ::CloseFiles() } )

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive )

   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lExclusive   := .f.

   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::DefineFiles()
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

      DATABASE NEW ::oEmpresa PATH ( cPatDat() ) FILE "Empresa.Dbf" VIA ( cDriver() ) SHARED INDEX "Empresa.Cdx"

      DATABASE NEW ::oUsuario PATH ( cPatDat() ) FILE "Users.Dbf"   VIA ( cDriver() ) SHARED INDEX "Users.Cdx"

      ::lOpenFiles      := .t.

      /*
      Cargamos los bitmaps-----------------------------------------------------
      */

      aAdd( ::aBmp, LoadBitmap( GetResources(), "gc_flash_16" ) )                      // Evento 1
      aAdd( ::aBmp, LoadBitmap( GetResources(), "PedPrv" ) )                        // Pedido proveedores 2
      aAdd( ::aBmp, LoadBitmap( GetResources(), "AlbPrv" ) )                        // Albaran proveedores 3
      aAdd( ::aBmp, LoadBitmap( GetResources(), "FacPrv" ) )                        // Factura proveedores 4
      aAdd( ::aBmp, LoadBitmap( GetResources(), "MovAlm" ) )                        // Movimientos de almacen 5
      aAdd( ::aBmp, LoadBitmap( GetResources(), "gc_notebook_user_16" ) )             // Presupuesto clientes 6
      aAdd( ::aBmp, LoadBitmap( GetResources(), "gc_clipboard_empty_user_16" ) )      // Pedido clientes 7
      aAdd( ::aBmp, LoadBitmap( GetResources(), "gc_document_empty_16" ) )       // Albaranes clientes 8
      aAdd( ::aBmp, LoadBitmap( GetResources(), "gc_document_text_businessman_16" ) )             // Factura clientes 9
      aAdd( ::aBmp, LoadBitmap( GetResources(), "gc_cash_register_user_16" ) )              // TPV 10
      aAdd( ::aBmp, LoadBitmap( GetResources(), "gc_document_text_money2_16" ) )            // Factura anticipo 11
      aAdd( ::aBmp, LoadBitmap( GetResources(), "gc_briefcase2_user_16" ) )            // Recibo clientes 12
      aAdd( ::aBmp, LoadBitmap( GetResources(), "gc_clipboard_empty_bag_16" ) )      //
      aAdd( ::aBmp, LoadBitmap( GetResources(), "gc_document_empty_bag_16" ) )
      aAdd( ::aBmp, LoadBitmap( GetResources(), "gc_user_16" ) )

   RECOVER USING oError

      msgStop( "Imposible abrir las bases de datos de auditorias" + CRLF + ErrorMessage( oError ) )
      ::CloseFiles()

      ::lOpenFiles      := .f.

   END SEQUENCE
   ErrorBlock( oBlock )

RETURN ( ::lOpenFiles )

//----------------------------------------------------------------------------//

METHOD OpenService( lExclusive )

   local oError
   local oBlock

   DEFAULT lExclusive   := .f.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::DefineFiles()
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

      ::lOpenFiles      := .t.

   RECOVER USING oError

      msgStop( "Imposible abrir las bases de datos de auditorias" + CRLF + ErrorMessage( oError ) )

      ::CloseFiles()

      ::lOpenFiles      := .f.

   END SEQUENCE
   ErrorBlock( oBlock )

RETURN ( ::lOpenFiles )

//----------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   DEFAULT cPath        := cPatDat()
   DEFAULT cDriver      := cDriver()

   DEFINE DATABASE ::oDbf FILE "OperationLog.Dbf" CLASS "OperationLog" PATH ( cPath ) VIA ( cDriver() ) COMMENT "OperationLog"

      FIELD NAME "dDate"      TYPE "D"  LEN  8  DEC 0  COMMENT "Fecha"       COLSIZE 200    OF ::oDbf
      FIELD NAME "cTime"      TYPE "C"  LEN  8  DEC 0  COMMENT "Hora"        COLSIZE 200    OF ::oDbf
      FIELD NAME "cUserName"  TYPE "C"  LEN 40  DEC 0  COMMENT "Usuario"     COLSIZE 200    OF ::oDbf
      FIELD NAME "cTable"     TYPE "C"  LEN 50  DEC 0  COMMENT "Tabla"       COLSIZE 200    OF ::oDbf
      FIELD NAME "cOperation" TYPE "C"  LEN 50  DEC 0  COMMENT "Operación"   COLSIZE 200    OF ::oDbf

      INDEX TO "OperationLog.Cdx" TAG "dDate"      ON "Dtos( dDate ) + cTime"                COMMENT "Fecha"      NODELETED   OF ::oDbf
      INDEX TO "OperationLog.Cdx" TAG "cTable"     ON "cTable + Dtos( dDate ) + cTime"       COMMENT "Tabla"      NODELETED   OF ::oDbf
      INDEX TO "OperationLog.Cdx" TAG "cOperation" ON "cOperation + Dtos( dDate ) + cTime"   COMMENT "Operacion"  NODELETED   OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//----------------------------------------------------------------------------//

METHOD Resource( nMode )

   local oDlg
   local oGetUse
   local oGetEmp
   local cTipDoc  := ::TipoOperacion()
   local cNumDoc  := ::NumeroOperacion()

   DEFINE DIALOG oDlg RESOURCE "Auditor"

      REDEFINE GET ::oDbf:cCodOpe UPDATE;
         ID       120 ;
         WHEN     ( .f. ) ;
			OF 		oDlg

      REDEFINE GET ::oDbf:dFecOpe UPDATE;
         ID       130 ;
         WHEN     ( .f. ) ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cTimOpe UPDATE;
         ID       140 ;
         WHEN     ( .f. ) ;
			OF 		oDlg

      REDEFINE GET oGetUse VAR ::oDbf:cCodUse UPDATE;
			ID 		100 ;
         IDTEXT   101 ;
         WHEN     ( .f. ) ;
			OF 		oDlg

      oGetUse:oHelpText:cText( oRetFld( ::oDbf:cCodUse, ::oUsuario, "cNbrUse" ) )

      REDEFINE GET oGetEmp VAR ::oDbf:cCodEmp UPDATE;
         ID       150 ;
         IDTEXT   151 ;
         WHEN     ( .f. ) ;
			OF 		oDlg

      oGetEmp:oHelpText:cText( oRetFld( ::oDbf:cCodEmp, ::oEmpresa, "cNombre" ) )

      REDEFINE GET cTipDoc UPDATE;
         ID       160 ;
         WHEN     ( .f. ) ;
			OF 		oDlg

      REDEFINE GET cNumDoc UPDATE;
         ID       170 ;
         WHEN     ( .f. ) ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cComDoc UPDATE;
         ID       110 ;
         WHEN     ( .f. ) ;
			OF 		oDlg

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
			ACTION 	( oDlg:end() )

	ACTIVATE DIALOG oDlg	CENTER

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD CloseService()

   if !Empty( ::oDbf ) .and. ::oDbf:Used()
      ::oDbf:end()
   end if

RETURN .t.

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oDbf ) .and. ::oDbf:Used()
      ::oDbf:end()
   end if

   if !Empty( ::oEmpresa ) .and. ::oEmpresa:Used()
      ::oEmpresa:end()
   end if

   if !Empty( ::oUsuario ) .and. ::oUsuario:Used()
      ::oUsuario:end()
   end if

   /*
   Cargamos los bitmaps--------------------------------------------------------
   */

   aEval( ::aBmp, {| hBmp | DeleteObject( hBmp ) } )

RETURN .t.

//---------------------------------------------------------------------------//

METHOD StartAplication()

RETURN ( ::AddEvent( START_APLICATION ) )

//---------------------------------------------------------------------------//

METHOD EndAplication()

RETURN ( ::AddEvent( END_APLICATION ) )

//---------------------------------------------------------------------------//

METHOD AddEvent( cEvent, cDocument, cTipo )

   DEFAULT cDocument    := ""
   DEFAULT cTipo        := ""

RETURN ( .t. )

//----------------------------------------------------------------------------//

Method AddEventFacturaClientes( nMode, cDocument )

   do case
      case nMode == APPD_MODE
         ::AddEvent( NEW_FACTURA_CLIENTES,         cDocument, FAC_CLI )
      case nMode == DUPL_MODE
         ::AddEvent( DUPLICATE_FACTURA_CLIENTES,   cDocument, FAC_CLI )
      case nMode == EDIT_MODE
         ::AddEvent( EDIT_FACTURA_CLIENTES,        cDocument, FAC_CLI )
   end case

RETURN ( .t. )

//----------------------------------------------------------------------------//

Method BitmapOperacion()

   if !Empty( ::aBmp )

      do case
         case Empty( ::oDbf:cTipDoc )
            Return ( ::aBmp[ 1 ] )
         case ( ::oDbf:cTipDoc == FAC_CLI )
            Return ( ::aBmp[ 9 ] )
         case ( ::oDbf:cTipDoc == REC_CLI )
            Return ( ::aBmp[ 12 ] )
      end case

   end if

Return ( "" )

//----------------------------------------------------------------------------//

Method UsuarioOperacion()

   if !Empty( ::oUsuario )
      return ( ::oDbf:cCodUse + Space( 1 ) + "-" + Space( 1 ) + oRetFld( ::oDbf:cCodUse, ::oUsuario, "cNbrUse" ) )
   end if

return ( ::oDbf:cCodUse )

//----------------------------------------------------------------------------//

Method EmpresaOperacion()

   if !Empty( ::oEmpresa )
      return ( ::oDbf:cCodEmp + Space( 1 ) + "-" + Space( 1 ) + oRetFld( ::oDbf:cCodEmp, ::oEmpresa, "cNombre" ) )
   end if

return ( ::oDbf:cCodEmp )

//----------------------------------------------------------------------------//

Method NumeroOperacion()

   if Empty( ::oDbf:cNumDoc )
      return ""
   end if

   do case
   case ::oDbf:cTipDoc == TIK_CLI .or. ::oDbf:cTipDoc == DEV_CLI
      return ( Left( ::oDbf:cNumDoc, 1 ) + "/" + Alltrim( SubStr( ::oDbf:cNumDoc, 2, 10 ) ) + "/" + Alltrim( SubStr( ::oDbf:cNumDoc, 10, 2 ) ) )

   case ::oDbf:cTipDoc == MOV_ALM
      return ( Alltrim( Left( ::oDbf:cNumDoc, 9 ) ) + "/" + Alltrim( SubStr( ::oDbf:cNumDoc, 10, 2 ) ) )

   case ::oDbf:cTipDoc == ENT_PED .or. ::oDbf:cTipDoc == ENT_ALB .or. ::oDbf:cTipDoc == REC_CLI .or. ::oDbf:cTipDoc == REC_PRV
      return ( Left( ::oDbf:cNumDoc, 1 ) + "/" + Alltrim( SubStr( ::oDbf:cNumDoc, 2, 9 ) ) + "/" + Alltrim( SubStr( ::oDbf:cNumDoc, 11, 2 ) ) + "-" + Alltrim( SubStr( ::oDbf:cNumDoc, 13, 2 ) ) )

   case ::oDbf:cTipDoc == CLI_TBL
      return ( ::oDbf:cNumDoc )

   end case

return ( Left( ::oDbf:cNumDoc, 1 ) + "/" + Alltrim( SubStr( ::oDbf:cNumDoc, 2, 9 ) ) + "/" + Alltrim( SubStr( ::oDbf:cNumDoc, 11, 2 ) ) )

//----------------------------------------------------------------------------//

Method TipoOperacion()

   local cTextDocument  := "Evento"

   do case
      case ::oDbf:cTipDoc == CLI_TBL
         cTextDocument  := "Tabla de clientes"
      case ::oDbf:cTipDoc == PRE_CLI
         cTextDocument  := "Presupuestos a clientes"
      case ::oDbf:cTipDoc == PED_CLI
         cTextDocument  := getConfigTraslation("Pedidos de clientes")
      case ::oDbf:cTipDoc == ALB_CLI
         cTextDocument  := "Albaranes de clientes"
      case ::oDbf:cTipDoc == FAC_CLI
         cTextDocument  := "Facturas de clientes"
      case ::oDbf:cTipDoc == ANT_CLI
         cTextDocument  := "Anticipos de clientes"
      case ::oDbf:cTipDoc == TIK_CLI
         cTextDocument  := "Tickets de clientes"
      case ::oDbf:cTipDoc == REC_CLI
         cTextDocument  := "Recibos de clientes"
      case ::oDbf:cTipDoc == DEV_CLI
         cTextDocument  := "Devoluciones de clientes"
      case ::oDbf:cTipDoc == VAL_CLI
         cTextDocument  := "Vales de clientes"
      case ::oDbf:cTipDoc == APT_CLI
         cTextDocument  := "Apartados de clientes"
      case ::oDbf:cTipDoc == ENT_PED
         cTextDocument  := "Ent. pedido"
      case ::oDbf:cTipDoc == ENT_ALB
         cTextDocument  := "Ent. albarán"
   end case

Return ( cTextDocument )

//----------------------------------------------------------------------------//

Method Filter()

   local oDlg

   ::dInicio         := Ctod( "01/01/" + Str( Year( Date() ) ) )
   ::dFin            := Date()
   ::cCodigoUsuario  := Space( 3 )
   ::cCodigoEmpresa  := Space( 2 )
   ::cComentario     := Space( 100 )

   DEFINE DIALOG oDlg RESOURCE "Auditor_Filter"

   ::oTree           := TTreeView():Redefine( 100, oDlg )

   ::oImageList      := TImageList():New( 16, 16 )

   REDEFINE GET ::dInicio ;
      ID       110 ;
      SPINNER ;
      OF       oDlg

   REDEFINE GET ::dFin ;
      ID       120 ;
      SPINNER ;
      OF       oDlg

   REDEFINE GET ::oCodigoUsuario VAR ::cCodigoUsuario ;
      ID       130 ;
      IDTEXT   131 ;
      PICTURE  "@!" ;
      BITMAP   "LUPA" ;
      OF       oDlg

   ::oCodigoUsuario:bValid := {|| cUser( ::oCodigoUsuario, ::oUsuario:cAlias, ::oCodigoUsuario:oHelpText ) }
   ::oCodigoUsuario:bHelp  := {|| BrwUser( ::oCodigoUsuario, ::oUsuario:cAlias, ::oCodigoUsuario:oHelpText ) }

   REDEFINE GET ::oCodigoEmpresa VAR ::cCodigoEmpresa ;
      ID       140 ;
      IDTEXT   141 ;
      PICTURE  "@!" ;
      BITMAP   "LUPA" ;
      OF       oDlg

   ::oCodigoEmpresa:bValid := {|| cEmpresa( ::oCodigoEmpresa, ::oEmpresa:cAlias, ::oCodigoEmpresa:oHelpText ) }
   ::oCodigoEmpresa:bHelp  := {|| BrwEmpresa( ::oCodigoEmpresa, ::oEmpresa:cAlias, ::oCodigoEmpresa:oHelpText ) }

   REDEFINE GET ::cComentario ;
      ID       150 ;
      OF       oDlg

   REDEFINE BUTTON ;
      ID       500;
      OF       oDlg ;
      ACTION   ( ::AplyFilter() )

   REDEFINE BUTTON ;
      ID       510;
      OF       oDlg ;
      ACTION   ( oDlg:End() )

   oDlg:AddFastKey( VK_F5, {|| ::AplyFilter() } )

   oDlg:Activate( , , , .t., , , {|| ::InitFilter() } )

Return ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Method InitFilter()

   local oTree

   ::oImageList:AddMasked( TBitmap():Define( "gc_flash_16" ),           Rgb( 255, 0, 255 ) )
   ::oImageList:AddMasked( TBitmap():Define( "gc_document_text_businessman_16" ),  Rgb( 255, 0, 255 ) )
   ::oImageList:AddMasked( TBitmap():Define( "gc_briefcase2_user_16" ), Rgb( 255, 0, 255 ) )
   ::oImageList:AddMasked( TBitmap():Define( "gc_user_16" ),           Rgb( 255, 0, 255 ) )

   oTree       := ::oTree:Add( "Eventos",                      0 )
                  oTree:Add( START_APLICATION,                 0 )
                  oTree:Add( END_APLICATION,                   0 )
                  oTree:Add( START_FACTURA_CLIENTES,           0 )
                  oTree:Add( END_FACTURA_CLIENTES,             0 )

   oTree       := ::oTree:Add( "Facturas clientes",            1 )
                  oTree:Add( NEW_FACTURA_CLIENTES,             1 )
                  oTree:Add( DUPLICATE_FACTURA_CLIENTES,       1 )
                  oTree:Add( EDIT_FACTURA_CLIENTES,            1 )
                  oTree:Add( DELETE_FACTURA_CLIENTES,          1 )
                  oTree:Add( PRINT_FACTURA_CLIENTES,           1 )
                  oTree:Add( PREVIEW_FACTURA_CLIENTES,         1 )
                  oTree:Add( LIQUIDA_FACTURA_CLIENTES,         1 )
                  oTree:Add( CONT_FACTURA_CLIENTES,            1 )
                  oTree:Add( MARK_CONT_FACTURA_CLIENTES,       1 )
                  oTree:Add( NOMARK_CONT_FACTURA_CLIENTES,     1 )

   oTree       := ::oTree:Add( "Recibos clientes",             2 )
                  oTree:Add( GENERATE_RECIBO_FACTURA_CLIENTES, 2 )

   oTree       := ::oTree:Add( "Clientes",                     3 )
                  oTree:Add( START_CLIENTES,                   3 )
                  oTree:Add( END_CLIENTES,                     3 )
                  oTree:Add( NEW_CLIENTES ,                    3 )
                  oTree:Add( DUPLICATE_CLIENTES,               3 )
                  oTree:Add( EDIT_CLIENTES,                    3 )
                  oTree:Add( DELETE_CLIENTES,                  3 )

   ::oTree:SetImagelist( ::oImageList )

Return ( Self )

//---------------------------------------------------------------------------//

Method CreateFilter()

   local oItem
   local aItems
   local cFilterOperacion           := ""
   local cFilterExpresion           := "( dFecOpe >= Ctod( '" + Dtoc( ::dInicio ) + "') .and. dFecOpe <= Ctod( '" + Dtoc( ::dFin ) +"' ) )"

   for each aItems in ::oTree:aItems

      if !Empty( aItems:aItems )

         for each oItem in aItems:aItems

            // if TvGetCheckState( ::oTree:hWnd, oItem:hItem )
            if ::oTree:GetCheck( oItem )         

               if !Empty( cFilterOperacion )
                  cFilterOperacion  += " .or. "
               end if

               cFilterOperacion     += "'" + Alltrim( oItem:cPrompt ) + "' $ cCodOpe"

            end if

         next

      end if

   next

   if !Empty( cFilterOperacion )
      cFilterExpresion              += " .and. "
      cFilterExpresion              += "(" + cFilterOperacion + ")"
   end if

   if !Empty( ::cCodigoUsuario )
      cFilterExpresion              += " .and. "
      cFilterExpresion              += "cCodUse == '" + ::cCodigoUsuario + "'"
   end if

   if !Empty( ::cCodigoEmpresa )
      cFilterExpresion              += " .and. "
      cFilterExpresion              += "cCodEmp == '" + ::cCodigoEmpresa + "'"
   end if

   if !Empty( ::cComentario )
      cFilterExpresion              += " .and. "
      cFilterExpresion              += "cComDoc $ '" + Alltrim( ::cComentario ) + "'"
   end if

Return ( cFilterExpresion )

//---------------------------------------------------------------------------//

Method AplyFilter()

Return ( Self )

//---------------------------------------------------------------------------//

Method DropTrigger()

   local nError
   local cErrorAds
   local cTrigger := ''
   local lTrigger

   cTrigger       += 'DROP TRIGGER DatosAgendaUsr.UpdateDatosAgendaUsr;' + CRLF

   if ADSCreateSQLStatement( 'Trigger', 2 )

      lTrigger    := ADSExecuteSQLDirect( cTrigger )
      if !lTrigger

          nError  := AdsGetLastError( @cErrorAds )

          msgStop( cErrorAds, 'ERROR DROP TRIGGER en ADSExecuteSQLDirect' )

          Return ( Self )

      endif

   else

      nError      := AdsGetLastError( @cErrorAds )

      msgStop( cErrorAds, 'ERROR DROP TRIGGER en ADSCreateSQLStatement' )

   end if

Return ( Self )

//---------------------------------------------------------------------------//

Method CreateTrigger()

   local nError
   local cErrorAds
   local cTrigger := ''
   local lTrigger

   cTrigger       += 'CREATE TRIGGER "UpdateDatosAgendaUsr" ON "DatosAgendaUsr" AFTER UPDATE' + CRLF

   cTrigger       += 'BEGIN' + CRLF

   cTrigger       += 'DECLARE @co CURSOR AS SELECT * FROM __OLD;' + CRLF
   cTrigger       += 'DECLARE @cn CURSOR AS SELECT * FROM __NEW;' + CRLF

   cTrigger       += 'OPEN @co;' + CRLF
   cTrigger       += 'OPEN @cn;' + CRLF

   cTrigger       += 'TRY' + CRLF

   cTrigger       += 'FETCH @co;' + CRLF
   cTrigger       += 'FETCH @cn;' + CRLF

   cTrigger       += 'INSERT INTO DatosOperationLog ( dDate, cTime, cOperation )' + CRLF
   cTrigger       += 'VALUES ( cast( Now() as sql_date ), cast( CurTime() as sql_varchar ), ' + "'" + "UPDATE" + "'" + ' );' + CRLF

   cTrigger       += 'FINALLY' + CRLF

   cTrigger       += 'CLOSE @co;' + CRLF
   cTrigger       += 'CLOSE @cn;' + CRLF

   cTrigger       += 'END TRY;' + CRLF

   cTrigger       += 'END;' + CRLF

   if ADSCreateSQLStatement( 'Trigger', 2 )

      lTrigger    := ADSExecuteSQLDirect( cTrigger )
      if !lTrigger

          nError  := AdsGetLastError( @cErrorAds )

          msgStop( cErrorAds, 'ERROR CREATE TRIGGER en ADSExecuteSQLDirect' )

          Return ( Self )

      endif

   else

      nError      := AdsGetLastError( @cErrorAds )

      msgStop( cErrorAds, 'ERROR CREATE TRIGGER en ADSCreateSQLStatement' )

   end if

Return ( Self )

//---------------------------------------------------------------------------//