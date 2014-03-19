#include "FiveWin.Ch"
#include "Folder.ch"
#include "Report.ch"
#include "Factu.ch" 
#include "Xbrowse.ch"

#define  fldRecibosClientes      oFld:aDialogs[ 1 ]
#define  fldRecibosProveedores   oFld:aDialogs[ 2 ]
#define  fldIncidencias          oFld:aDialogs[ 3 ]

static nView

static nLevel
static dbfFacPrvP
static dbfClient

static dbfFacPrvT
static dbfFacPrvL
static dbfFacCliT
static dbfFacCliL
static dbfFacRecT
static dbfFacRecL
static dbfRctPrvT
static dbfRctPrvL
static dbfAntCliT
static dbfIva
static dbfDiv

static cNewCli
static cNewPrv
static dbfNewRecPrv

static oFechaInicio
static oFechaFin
static dFecIniCli
static dFecFinCli
static oEstadoCli
static aEstadoCli    := { "Pendientes", "Pagados", "Todos" }
static cEstadoCli

static oPeriodoCli
static aPeriodoCli   := {}
static cPeriodoCli

static oPeriodoPrv
static aPeriodoPrv   := {}
static cPeriodoPrv

static oFecIniPrv
static oFecFinPrv
static dFecIniPrv
static dFecFinPrv
static oEstadoPrv
static aEstadoPrv    := { "Pendientes", "Pagados", "Todos" }
static cEstadoPrv

static cCodigoCliente
static cCodigoProveedor

static oBrwRecCli
static oBrwRecPrv

static nMeter        := 0
static oMeter

static nFolder
static hFolder

static oDlg
static oFld
static oBrwInc
static oBmpCobros
static oBmpPagos
static oBmpIncidencias

//----------------------------------------------------------------------------//

STATIC FUNCTION OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   nView          := TDataView():CreateView()

   TDataView():Get( "Client", nView )

   TDataView():Get( "CliInc", nView )

   TDataView():Get( "TipInci", nView )

   TDataView():Get( "FacCliP", nView )

   USE ( cPatEmp() + "FACPRVP.DBF" )   NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVP", @dbfFacPrvP ) )
   SET ADSINDEX TO ( cPatEmp() + "FACPRVP.CDX" ) ADDITIVE

   USE ( cPatCli() + "CLIENT.DBF" )    NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIENT",  @dbfClient ) )
   SET ADSINDEX TO ( cPatCli() + "CLIENT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "FACPRVT.DBF" )   NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVT", @dbfFacPrvT ) )
   SET ADSINDEX TO ( cPatEmp() + "FACPRVT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "FACPRVL.DBF" )   NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVL", @dbfFacPrvL ) )
   SET ADSINDEX TO ( cPatEmp() + "FACPRVL.CDX" ) ADDITIVE

   USE ( cPatEmp() + "FACCLIL.DBF" )   NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIL", @dbfFacCliL ) )
   SET ADSINDEX TO ( cPatEmp() + "FACCLIL.CDX" ) ADDITIVE

   USE ( cPatEmp() + "FACRECT.DBF" )   NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACRECT", @dbfFacRecT ) )
   SET ADSINDEX TO ( cPatEmp() + "FACRECT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "FACRECL.DBF" )   NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACRECL", @dbfFacRecL ) )
   SET ADSINDEX TO ( cPatEmp() + "FACRECL.CDX" ) ADDITIVE

   USE ( cPatEmp() + "AntCliT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AntCliT", @dbfAntCliT ) )
   SET ADSINDEX TO ( cPatEmp() + "AntCliT.CDX" ) ADDITIVE

   USE ( cPatDat() + "TIVA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfIva ) )
   SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE

   USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDiv ) )
   SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

   USE ( cPatEmp() + "RctPrvT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVT", @dbfRctPrvT ) )
   SET ADSINDEX TO ( cPatEmp() + "RctPrvT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "RctPrvL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVL", @dbfRctPrvL ) )
   SET ADSINDEX TO ( cPatEmp() + "RctPrvL.CDX" ) ADDITIVE

   if !TDataCenter():OpenFacCliT( @dbfFacCliT )
      lOpen          := .f.
   end if

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )

      CloseFiles()

      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lOpen )

//----------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles()

   if !Empty( dbfNewRecPrv )
      ( dbfNewRecPrv )->( dbCloseArea() )
   end if

   if File( cNewCli )
      fErase( cNewCli )
   end if

   if File( cNewPrv )
      fErase( cNewPrv )
   end if

   if !Empty( dbfFacPrvP )
      ( dbfFacPrvP )->( dbCloseArea() )
   end if

   if !Empty( dbfClient )
      ( dbfClient )->( dbCloseArea() )
   end if

   if !Empty( dbfFacPrvT )
      ( dbfFacPrvT )->( dbCloseArea() )
   end if

   if !Empty( dbfFacPrvL )
      ( dbfFacPrvL )->( dbCloseArea() )
   end if

   if !Empty( dbfRctPrvT )
      ( dbfRctPrvT )->( dbCloseArea() )
   end if

   if !Empty( dbfRctPrvL )
      ( dbfRctPrvL )->( dbCloseArea() )
   end if

   if !Empty( dbfFacCliT )
      ( dbfFacCliT )->( dbCloseArea() )
   end if

   if !Empty( dbfFacCliL )
      ( dbfFacCliL )->( dbCloseArea() )
   end if

   if !Empty( dbfFacRecT )
      ( dbfFacRecT )->( dbCloseArea() )
   end if

   if !Empty( dbfFacRecL )
      ( dbfFacRecL )->( dbCloseArea() )
   end if

   if !Empty( dbfAntCliT )
      ( dbfAntCliT )->( dbCloseArea() )
   end if

   if !Empty( dbfIva )
      ( dbfIva )->( dbCloseArea() )
   end if

   if !Empty( dbfDiv )
      ( dbfDiv )->( dbCloseArea() )
   end if

   TDataView():DeleteView( nView )  

   dbfFacPrvP              := nil
   dbfClient               := nil
   dbfFacPrvT              := nil
   dbfFacPrvL              := nil
   dbfRctPrvT              := nil
   dbfRctPrvL              := nil
   dbfFacCliT              := nil
   dbfFacCliL              := nil
   dbfFacRecT              := nil
   dbfFacRecL              := nil
   dbfAntCliT              := nil
   dbfIva                  := nil
   dbfDiv                  := nil

   dbfNewRecPrv            := nil

Return .t.

//----------------------------------------------------------------------------//

FUNCTION PageIni( oMenuItem, oWnd )

   local oError
   local oBlock

   DEFAULT  oMenuItem      := "01004"
   DEFAULT  oWnd           := oWnd()

   // Obtenemos el nivel de acceso

   nLevel                  := nLevelUsr( oMenuItem )
   if nAnd( nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      return nil
   end if

   // Cerramos todas las ventanas

   if oWnd != nil
      SysRefresh(); oWnd:CloseAll(); SysRefresh()
   end if

   /*
   Abrimos las tablas necesarias-----------------------------------------------
   */

   if !OpenFiles()
      return nil
   end if

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   // Cargamos los valores por defecto-----------------------------------------

   cEstadoCli              := "Pendientes"
   cEstadoPrv              := "Pendientes"

   aPeriodoCli             := aCreaArrayPeriodos()
   cPeriodoCli             := "Hoy"
   aPeriodoPrv             := aCreaArrayPeriodos()
   cPeriodoPrv             := "Hoy"

   nFolder                 := 1

   /*
   Caja de dialogo_____________________________________________________________
   */

   DEFINE DIALOG oDlg RESOURCE "PAGEINI" OF oWnd

      REDEFINE FOLDER oFld ;
         ID          200 ;
         OF          oDlg ;
         PROMPT      "&Cobros",;
                     "Pagos" ;
         DIALOGS     "PAGEINI_01",;
                     "PAGEINI_02"

      PageIniCobros()

      PageIniPagos()

      // Redefinimos el meter--------------------------------------------------

      oMeter         := TMeter():ReDefine( 210, { | u | if( pCount() == 0, nMeter, nMeter := u ) }, ( dbfNewRecPrv )->( LastRec() ), oDlg, .f., , , .t., rgb( 255,255,255 ), , rgb( 128,255,0 ) )

      REDEFINE BUTTON ;
         ID          IDCANCEL ;
         OF          oDlg ;
         ACTION      ( oDlg:End() )

      oDlg:bStart     := {|| StartPageIni() }

   ACTIVATE DIALOG oDlg CENTER

   // Guardamos la configuracion de los browse------------------------------------

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible cargar gestión de cartera" )

      CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

   /*
   Cerramos las tablas abiertas------------------------------------------------
   */

   CloseFiles()

   /*
   Matamos el objeto imagen----------------------------------------------------
   */

   if !Empty( oBmpCobros )
      oBmpCobros:End()
   end if

   if !empty( oBmpPagos )
      oBmpPagos:End()
   end if

   if !empty( oBmpIncidencias ) 
      oBmpIncidencias:End()
   end if 

RETURN ( NIL )

//----------------------------------------------------------------------------//

FUNCTION PageIniClient( oMenuItem, nView )

   local oError
   local oBlock

   DEFAULT  oMenuItem      := "01004"

   // Obtenemos el nivel de acceso

   nLevel                  := nLevelUsr( oMenuItem )
   if nAnd( nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      return nil
   end if

   /*
   Abrimos las tablas necesarias-----------------------------------------------

   if !OpenFiles()
      return nil
   end if
   */

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   cCodigoCliente          := ( TDataView():Get( "FacCliP", nView ) )->cCodCli 

   // Cargamos los valores por defecto-----------------------------------------

   cEstadoCli              := "Pendientes"

   aPeriodoCli             := aCreaArrayPeriodos()
   cPeriodoCli             := "Hoy"

   nFolder                 := 1

   /*
   Caja de dialogo_____________________________________________________________
   */

   DEFINE DIALOG oDlg RESOURCE "PAGEINI"

      REDEFINE FOLDER oFld ;
         ID          200 ;
         OF          oDlg ;
         PROMPT      "&Cobros",;
                     "Incidencias" ;
         DIALOGS     "PAGEINI_01",;
                     "PAGEINI_03"

      PageIniCobros()

      PageIniIncidecias()

      // Redefinimos el meter--------------------------------------------------

      oMeter         := TMeter():ReDefine( 210, { | u | if( pCount() == 0, nMeter, nMeter := u ) }, ( TDataView():Get( "FacCliP", nView ) )->( ordKeyCount() ), oDlg, .f., , , .t., rgb( 255,255,255 ), , rgb( 128,255,0 ) )

      REDEFINE BUTTON ;
         ID          IDCANCEL ;
         OF          oDlg ;
         ACTION      ( oDlg:End() )

      oDlg:bStart    := {|| lRecargaFecha( oFechaInicio, oFechaFin ), LoadPageIni( .t. ) }

   ACTIVATE DIALOG oDlg CENTER

   // Guardamos la configuracion de los browse------------------------------------

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible cargar gestión de cartera" )

      CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

   /*
   Cerramos las tablas abiertas------------------------------------------------

   CloseFiles()
   */

   /*
   Matamos el objeto imagen----------------------------------------------------
   */

   if !Empty( oBmpCobros )
      oBmpCobros:End()
   end if

   if !empty( oBmpIncidencias ) 
      oBmpIncidencias:End()
   end if 

RETURN ( NIL )

//----------------------------------------------------------------------------//

Static Function StartPageIni( oFld )

   lRecargaFecha( oFechaInicio, oFechaFin )

   lRecargaFecha( oFecIniPrv, oFecFinPrv )

   LoadPageIni( .t., .t. )

RETURN ( NIL )

//----------------------------------------------------------------------------//

static function LoadPageIni( lLoadCli, lLoadPrv )

   local cExpHead    := ""

   DEFAULT lLoadCli  := .f.
   DEFAULT lLoadPrv  := .f.

   /*
   Recargamos la temporal de recibos de clientes-------------------------------
   */

   if lLoadCli

      /*
      Vaciamos la tabla y colocamos los filtros--------------------------------
      */

      ( TDataView():Get( "FacCliP", nView ) )->( OrdSetFocus( "dFecVto" ) )

      do case
         case oEstadoCli:nAt == 1
            cExpHead    := '!lCobrado .and. dFecVto >= Ctod( "' + Dtoc( dFecIniCli ) + '" ) .and. dFecVto <= Ctod( "' + Dtoc( dFecFinCli ) + '" )'
         case oEstadoCli:nAt == 2
            cExpHead    := 'lCobrado .and. dFecVto >= Ctod( "' + Dtoc( dFecIniCli ) + '" ) .and. dFecVto <= Ctod( "' + Dtoc( dFecFinCli ) + '" )'
         case oEstadoCli:nAt == 3
            cExpHead    := 'dFecVto >= Ctod( "' + Dtoc( dFecIniCli ) + '" ) .and. dFecVto <= Ctod( "' + Dtoc( dFecFinCli ) + '" )'
      end case

      CreateFastFilter( cExpHead, TDataView():Get( "FacCliP", nView ), .f., oMeter )

   end if

   /*
   Recargamos la temporal de recibos de proveedores----------------------------
   */

   if lLoadPrv

      /*
      Vaciamos la tabla y colocamos los filtros--------------------------------
      */

      ( TDataView():Get( "FacPrvP", nView ) )->( OrdSetFocus( "dFecVto" ) )

      do case
         case oEstadoPrv:nAt == 1
            cExpHead    := '!lCobrado .and. dFecVto >= Ctod( "' + Dtoc( dFecIniPrv ) + '" ) .and. dFecVto <= Ctod( "' + Dtoc( dFecFinPrv ) + '" )'
         case oEstadoPrv:nAt == 2
            cExpHead    := 'lCobrado .and. dFecVto >= Ctod( "' + Dtoc( dFecIniPrv ) + '" ) .and. dFecVto <= Ctod( "' + Dtoc( dFecFinPrv ) + '" )'
         case oEstadoPrv:nAt == 3
            cExpHead    := 'dFecVto >= Ctod( "' + Dtoc( dFecIniPrv ) + '" ) .and. dFecVto <= Ctod( "' + Dtoc( dFecFinPrv ) + '" )'
      end case

      CreateFastFilter( cExpHead, TDataView():Get( "FacPrvP", nView ), .f., oMeter )

   end if

   /*
   Refrescamos los browse------------------------------------------------------
   */

   if !Empty( oBrwRecCli )
      oBrwRecCli:Refresh()
   end if

   if !Empty( oBrwRecPrv )
      oBrwRecPrv:Refresh()
   end if

return .t.

//---------------------------------------------------------------------------//
/*
static function LiquidaRecCli()

   ( TDataView():Get( "FacCliP", nView ) )->( dbGoTop() )

   oMeter:SetTotal( ( TDataView():Get( "FacCliP", nView ) )->( OrdKeyCount() ) )

   while !( TDataView():Get( "FacCliP", nView ) )->( Eof() )

      if ( TDataView():Get( "FacCliP", nView ) )->lCobrado

         if Empty( ( TDataView():Get( "FacCliP", nView ) )->cTipRec )

            if dbSeekInOrd( ( TDataView():Get( "FacCliP", nView ) )->cSerie + Str( ( TDataView():Get( "FacCliP", nView ) )->nNumFac ) +  ( TDataView():Get( "FacCliP", nView ) )->cSufFac + Str( ( TDataView():Get( "FacCliP", nView ) )->nNumRec ), "pNumFac", dbfFacCliP )  .and.;
               !( dbfFacCliP )->lCobrado

               if ( dbfFacCliP )->( dbRLock() )
                  ( dbfFacCliP )->lCobrado   := .t.
                  ( dbfFacCliP )->dEntrada   := GetSysDate()
                  ( dbfFacCliP )->cTurRec    := cCurSesion()
                  delRiesgo( ( dbfFacCliP )->nImporte, ( dbfFacCliP )->cCodCli, dbfClient )
                  ( dbfFacCliP )->( dbUnLock() )
               end if

               // Actualizamos el estado de la factura----------------------------------

               if ( dbfFacCliT )->( dbSeek( ( TDataView():Get( "FacCliP", nView ) )->cSerie + Str( ( TDataView():Get( "FacCliP", nView ) )->nNumFac ) +  ( TDataView():Get( "FacCliP", nView ) )->cSufFac ) )
                  ChkLqdFacCli( nil, dbfFacCliT, dbfFacCliL, dbfFacCliP, dbfAntCliT, dbfIva, dbfDiv )
               end if

            end if

         else

            if dbSeekInOrd( ( TDataView():Get( "FacCliP", nView ) )->cSerie + Str( ( TDataView():Get( "FacCliP", nView ) )->nNumFac ) +  ( TDataView():Get( "FacCliP", nView ) )->cSufFac + Str( ( TDataView():Get( "FacCliP", nView ) )->nNumRec ), "rNumFac", dbfFacCliP ) .and.;
               !( dbfFacCliP )->lCobrado

               if ( dbfFacCliP )->( dbRLock() )
                  ( dbfFacCliP )->lCobrado   := .t.
                  ( dbfFacCliP )->dEntrada   := GetSysDate()
                  ( dbfFacCliP )->cTurRec    := cCurSesion()
                  delRiesgo( ( dbfFacCliP )->nImporte, ( dbfFacCliP )->cCodCli, dbfClient )
                  ( dbfFacCliP )->( dbUnLock() )
               end if

               // Actualizamos el estado de la factura----------------------------------

               if ( dbfFacRecT )->( dbSeek( ( TDataView():Get( "FacCliP", nView ) )->cSerie + Str( ( TDataView():Get( "FacCliP", nView ) )->nNumFac ) +  ( TDataView():Get( "FacCliP", nView ) )->cSufFac ) )
                  ChkLqdFacRec( nil, dbfFacRecT, dbfFacRecL, dbfFacCliP, dbfIva, dbfDiv )
               end if

            end if

         end if

      end if

      ( TDataView():Get( "FacCliP", nView ) )->( dbSkip() )

      oMeter:Set( ( TDataView():Get( "FacCliP", nView ) )->( OrdKeyNo() ) )

   end while

   oMeter:Set( ( TDataView():Get( "FacCliP", nView ) )->( LastRec() ) )

   LoadPageIni( .t., .f. )

   Msginfo( "Proceso Finalizado con éxito" )

   if !Empty( oBrwRecCli )
      oBrwRecCli:Refresh()
   end if

return .t.
*/
//---------------------------------------------------------------------------//
/*
static function LiquidaRecPrv()

   local nOrdAnt  := ( dbfFacPrvP )->( OrdSetFocus( "nNumFac" ) )

   ( dbfNewRecPrv )->( dbGoTop() )

   oMeter:SetTotal( ( dbfNewRecPrv )->( OrdKeyCount() ) )

   while !( dbfNewRecPrv )->( Eof() )

      if ( dbfNewRecPrv )->lCobrado

         if Empty( ( dbfNewRecPrv )->cTipRec )

            if dbSeekInOrd( ( dbfNewRecPrv )->cSerFac + Str( ( dbfNewRecPrv )->nNumFac ) +  ( dbfNewRecPrv )->cSufFac + Str( ( dbfNewRecPrv )->nNumRec ), "fNumFac", dbfFacPrvP ) .and.;
               !( dbfFacPrvP )->lCobrado

               if ( dbfFacPrvP )->( dbRLock() )
                  ( dbfFacPrvP )->lCobrado   := .t.
                  ( dbfFacPrvP )->dEntrada   := GetSysDate()
                  ( dbfFacPrvP )->cTurRec    := cCurSesion()
                  ( dbfFacPrvP )->( dbUnLock() )
               end if

            end if

            // Actualizamos el estado de la factura----------------------------------

            if ( dbfFacPrvT )->( dbSeek( ( dbfNewRecPrv )->cSerFac + Str( ( dbfNewRecPrv )->nNumFac ) +  ( dbfNewRecPrv )->cSufFac ) )
               ChkLqdFacPrv( nil, dbfFacPrvT, dbfFacPrvL, dbfFacPrvP, dbfIva, dbfDiv )
            end if

         else

            if dbSeekInOrd( ( dbfNewRecPrv )->cSerFac + Str( ( dbfNewRecPrv )->nNumFac ) +  ( dbfNewRecPrv )->cSufFac + Str( ( dbfNewRecPrv )->nNumRec ), "rNumFac", dbfFacPrvP ) .and.;
               !( dbfFacPrvP )->lCobrado

               if ( dbfFacPrvP )->( dbRLock() )
                  ( dbfFacPrvP )->lCobrado   := .t.
                  ( dbfFacPrvP )->dEntrada   := GetSysDate()
                  ( dbfFacPrvP )->cTurRec    := cCurSesion()
                  ( dbfFacPrvP )->( dbUnLock() )
               end if

            end if

            // Actualizamos el estado de la factura----------------------------------

            if ( dbfRctPrvT )->( dbSeek( ( dbfNewRecPrv )->cSerFac + Str( ( dbfNewRecPrv )->nNumFac ) +  ( dbfNewRecPrv )->cSufFac ) )
               ChkLqdRctPrv( nil, dbfRctPrvT, dbfRctPrvL, dbfFacPrvP, dbfIva, dbfDiv )
            end if

         end if

      end if

      ( dbfNewRecPrv )->( dbSkip() )

      oMeter:Set( ( dbfNewRecPrv )->( OrdKeyNo() ) )

   end while

   oMeter:Set( ( dbfNewRecPrv )->( LastRec() ) )

   ( dbfFacPrvP )->( OrdSetFocus( nOrdAnt ) )

   LoadPageIni( .f., .t. )

   Msginfo( "Proceso Finalizado con éxito" )

   if !Empty( oBrwRecPrv )
      oBrwRecPrv:Refresh()
   end if

return .t.
*/
//---------------------------------------------------------------------------//

static function aCreaArrayPeriodos()

   local aPeriodo := {}

   aAdd( aPeriodo, "Hoy" )

   aAdd( aPeriodo, "Ayer" )

   aAdd( aPeriodo, "Mes en curso" )

   aAdd( aPeriodo, "Mes anterior" )

   do case
      case Month( GetSysDate() ) <= 3
         aAdd( aPeriodo, "Primer trimestre" )

      case Month( GetSysDate() ) > 3 .and. Month( GetSysDate() ) <= 6
         aAdd( aPeriodo, "Primer trimestre" )
         aAdd( aPeriodo, "Segundo trimestre" )

      case Month( GetSysDate() ) > 6 .and. Month( GetSysDate() ) <= 9
         aAdd( aPeriodo, "Primer trimestre" )
         aAdd( aPeriodo, "Segundo trimestre" )
         aAdd( aPeriodo, "Tercer trimestre" )

      case Month( GetSysDate() ) > 9 .and. Month( GetSysDate() ) <= 12
         aAdd( aPeriodo, "Primer trimestre" )
         aAdd( aPeriodo, "Segundo trimestre" )
         aAdd( aPeriodo, "Tercer trimestre" )
         aAdd( aPeriodo, "Cuatro trimestre" )

   end case

   aAdd( aPeriodo, "Doce últimos meses" )

   aAdd( aPeriodo, "Año en curso" )

   aAdd( aPeriodo, "Año anterior" )

Return ( aPeriodo )

//---------------------------------------------------------------------------//

Static Function lRecargaFecha( oFechaInicio, oFechaFin )

   do case
      case cPeriodoCli == "Hoy"

         oFechaInicio:cText( GetSysDate() )
         oFechaFin:cText( GetSysDate() )

      case cPeriodoCli == "Ayer"

         oFechaInicio:cText( GetSysDate() -1 )
         oFechaFin:cText( GetSysDate() -1 )

      case cPeriodoCli == "Mes en curso"

         oFechaInicio:cText( CtoD( "01/" + Str( Month( GetSysDate() ) ) + "/" + Str( Year( GetSysDate() ) ) ) )
         oFechaFin:cText( GetSysDate() )

      case cPeriodoCli == "Mes anterior"

         oFechaInicio:cText( BoM( AddMonth( GetSysDate(), -1 ) ) )
         oFechaFin:cText( EoM( AddMonth( GetSysDate(), -1 ) ) )

      case cPeriodoCli == "Primer trimestre"
         oFechaInicio:cText( CtoD( "01/01/" + Str( Year( GetSysDate() ) ) ) )
         oFechaFin:cText( CtoD( "31/03/" + Str( Year( GetSysDate() ) ) ) )

      case cPeriodoCli == "Segundo trimestre"

         oFechaInicio:cText( CtoD( "01/04/" + Str( Year( GetSysDate() ) ) ) )
         oFechaFin:cText( CtoD( "30/06/" + Str( Year( GetSysDate() ) ) ) )

      case cPeriodoCli == "Tercer trimestre"

         oFechaInicio:cText( CtoD( "01/07/" + Str( Year( GetSysDate() ) ) ) )
         oFechaFin:cText( CtoD( "30/09/" + Str( Year( GetSysDate() ) ) ) )

      case cPeriodoCli == "Cuatro trimestre"

         oFechaInicio:cText( CtoD( "01/10/" + Str( Year( GetSysDate() ) ) ) )
         oFechaFin:cText( CtoD( "31/12/" + Str( Year( GetSysDate() ) ) ) )

      case cPeriodoCli == "Doce últimos meses"

         oFechaInicio:cText( CtoD( Str( Day( GetSysDate() ) ) + "/" + Str( Month( GetSysDate() ) ) + "/" + Str( Year( GetSysDate() ) -1 ) ) )
         oFechaFin:cText( GetSysDate() )

      case cPeriodoCli == "Año en curso"

         oFechaInicio:cText( CtoD( "01/01/" + Str( Year( GetSysDate() ) ) ) )
         oFechaFin:cText( CtoD( "31/12/" + Str( Year( GetSysDate() ) ) ) )

      case cPeriodoCli == "Año anterior"

         oFechaInicio:cText( CtoD( "01/01/" + Str( Year( GetSysDate() ) - 1 ) ) )
         oFechaFin:cText( CtoD( "31/12/" + Str( Year( GetSysDate() ) - 1 ) ) )

   end case

   oFechaInicio:Refresh()
   oFechaFin:Refresh()

RETURN ( .t. )

//---------------------------------------------------------------------------//

Static Function PageIniCobros()

   local oBtnModificarRecibo

      /*
      PRIMERA CAJA DE DIALOGO--------------------------------------------------
      */

      REDEFINE BITMAP oBmpCobros ;
         ID          500 ;
         RESOURCE    "SAFE_INTO_ALPHA_48" ;
         TRANSPARENT ;
         OF          oFld:aDialogs[ nFolder ]

      REDEFINE COMBOBOX oPeriodoCli ;
         VAR         cPeriodoCli ;
         ID          100 ;
         ITEMS       aPeriodoCli ;
         ON CHANGE   ( lRecargaFecha( oFechaInicio, oFechaFin ), LoadPageIni( .t., .f. ) ) ;
         OF          oFld:aDialogs[ nFolder ]

      REDEFINE GET oFechaInicio VAR dFecIniCli;
         ID          110 ;
         SPINNER ;
         VALID       ( LoadPageIni( .t., .f. ) );
         OF          oFld:aDialogs[ nFolder ]

      REDEFINE GET oFechaFin VAR dFecFinCli;
         ID          120 ;
         SPINNER ;
         VALID       ( LoadPageIni( .t., .f. ) );
         OF          oFld:aDialogs[ nFolder ]

      REDEFINE COMBOBOX oEstadoCli VAR cEstadoCli ;
         ID          130 ;
         ITEMS       aEstadoCli ;
         ON CHANGE   ( LoadPageIni( .t., .f. ) );
         OF          oFld:aDialogs[ nFolder ]

      REDEFINE BUTTON oBtnModificarRecibo ;
         ID          180 ;
         OF          oFld:aDialogs[ nFolder ] ;
         ACTION      ( if( !Empty( ( TDataView():FacturasClientesCobros( nView ) )->cSerie ),;
                           EdtRecCli( TDataView():FacturasClientesCobrosId( nView ), .f., !Empty( ( TDataView():FacturasClientesCobros( nView ) )->cTipRec ) ), ),;
                           oBrwRecCli:Refresh() )

      oBrwRecCli                 := IXBrowse():New( oFld:aDialogs[ nFolder ] )

      oBrwRecCli:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwRecCli:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwRecCli:cAlias          := ( TDataView():Get( "FacCliP", nView ) )

      oBrwRecCli:nMarqueeStyle   := 6
      oBrwRecCli:lRecordSelector := .f.
      oBrwRecCli:cName           := "Recibos de clientes.Inicio"

      oBrwRecCli:bLDblClick      := {|| oBtnModificarRecibo:Click() }

      oBrwRecCli:CreateFromResource( 170 )

      with object ( oBrwRecCli:AddCol() )
         :cHeader                := "E. Estado"
         :bStrData               := {|| "" }
         :bEditValue             := {|| ( TDataView():Get( "FacCliP", nView ) )->lCobrado }
         :nWidth                 := 18
         :SetCheck( { "Sel16", "Cnt16" } )
      end with

      with object ( oBrwRecCli:AddCol() )
         :cHeader                := "T. Tipo"
         :bEditValue             := {|| if( Empty( ( TDataView():Get( "FacCliP", nView ) )->cTipRec ), "F. Factura", "R. Rectificativa" ) }
         :nWidth                 := 18
      end with

      with object ( oBrwRecCli:AddCol() )
         :cHeader                := "Número"
         :bEditValue             := {|| AllTrim( ( TDataView():Get( "FacCliP", nView ) )->cSerie ) + "/" + AllTrim( Str( ( TDataView():Get( "FacCliP", nView ) )->nNumFac ) ) + "/" +  AllTrim( ( TDataView():Get( "FacCliP", nView ) )->cSufFac ) + "-" + AllTrim( Str( ( TDataView():Get( "FacCliP", nView ) )->nNumRec ) ) }
         :nWidth                 := 80
      end with

      with object ( oBrwRecCli:AddCol() )
         :cHeader                := "Cliente"
         :bEditValue             := {|| AllTrim( ( TDataView():Get( "FacCliP", nView ) )->cCodCli ) }
         :nWidth                 := 60
      end with

      with object ( oBrwRecCli:AddCol() )
         :cHeader                := "Nombre"
         :bEditValue             := {|| AllTrim( ( TDataView():Get( "FacCliP", nView ) )->cNomCli ) }
         :nWidth                 := 130
      end with

      with object ( oBrwRecCli:AddCol() )
         :cHeader                := "Fecha"
         :bEditValue             := {|| Dtoc( ( TDataView():Get( "FacCliP", nView ) )->dPreCob ) }
         :nWidth                 := 80
      end with

      with object ( oBrwRecCli:AddCol() )
         :cHeader                := "Vencimiento"
         :bEditValue             := {|| Dtoc( ( TDataView():Get( "FacCliP", nView ) )->dFecVto ) }
         :nWidth                 := 80
      end with

      with object ( oBrwRecCli:AddCol() )
         :cHeader                := "Importe"
         :bEditValue             := {|| ( TDataView():Get( "FacCliP", nView ) )->nImporte }
         :cEditPicture           := cPorDiv()
         :nWidth                 := 70
         :nDataStrAlign          := 1
         :nHeadStrAlign          := 1
      end with

      oFld:aDialogs[ nFolder ]:AddFastKey( VK_F3, {|| oBtnModificarRecibo:Click() } )

Return ( nil )

//---------------------------------------------------------------------------//

Static Function PageIniIncidecias()

   // Incidencias de clientes ----------------------------------------------

   if !empty( cCodigoCliente )

      nFolder++

      REDEFINE BITMAP oBmpIncidencias ;
         ID          500 ;
         RESOURCE    "Sign_warning_Alpha_48" ;
         TRANSPARENT ;
         OF          oFld:aDialogs[ nFolder ] 

      oBrwInc                 := IXBrowse():New( oFld:aDialogs[ nFolder ] )

      oBrwInc:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwInc:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwInc:cAlias          := TDataView():Get( "CliInc", nView )
      oBrwInc:nMarqueeStyle   := 5
      oBrwInc:cName           := "Clientes.Incidencias"

      with object ( oBrwInc:AddCol() )
         :cHeader             := "Rs. Resuelta"
         :bStrData            := {|| "" }
         :bEditValue          := {|| ( TDataView():Get( "CliInc", nView ) )->lListo }
         :nWidth              := 18
         :SetCheck( { "Sel16", "Nil16" } )
      end with

      with object ( oBrwInc:AddCol() )
         :cHeader             := "Código"
         :cSortOrder          := "cCodTip"
         :bEditValue          := {|| ( TDataView():Get( "CliInc", nView ) )->cCodTip }
         :nWidth              := 80
      end with

      with object ( oBrwInc:AddCol() )
         :cHeader             := "Incidencia"
         :bEditValue          := {|| cNomInci( ( TDataView():Get( "CliInc", nView ) )->cCodTip, TDataView():Get( "TipInci", nView ) ) }
         :nWidth              := 180
      end with

      with object ( oBrwInc:AddCol() )
         :cHeader             := "Fecha"
         :cSortOrder          := "cCodCli"
         :bEditValue          := {|| Dtoc( ( TDataView():Get( "CliInc", nView ) )->dFecInc ) }
         :nWidth              := 80
      end with

      with object ( oBrwInc:AddCol() )
         :cHeader             := "Descripción"
         :bEditValue          := {|| ( TDataView():Get( "CliInc", nView ) )->mDesInc }
         :nWidth              := 300
      end with

      oBrwInc:bLDblClick      := {|| EdtCliIncidencia( nView ) }
      oBrwInc:bRClicked       := {| nRow, nCol, nFlags | oBrwInc:RButtonDown( nRow, nCol, nFlags ) }

      oBrwInc:CreateFromResource( 400 )

      REDEFINE BUTTON ;
         ID          100 ;
         OF          oFld:aDialogs[ nFolder ] ;
         ACTION      ( AddCliIncidencia( nView, cCodigoCliente ) )

      REDEFINE BUTTON ;
         ID          110 ;
         OF          oFld:aDialogs[ nFolder ] ;
         ACTION      ( EdtCliIncidenciaCliente(  ) )

      REDEFINE BUTTON ;
         ID          120 ;
         OF          oFld:aDialogs[ nFolder ] ;
         ACTION      ( Msginfo( "Del") )

      REDEFINE BUTTON ;
         ID          130 ;
         OF          oFld:aDialogs[ nFolder ] ;
         ACTION      ( Msginfo( "Zoo") )

   end if

Return ( nil )

//---------------------------------------------------------------------------//

Static Function PageIniPagos()

   if empty( cCodigoCliente )

      nFolder++

      /*
      SEGUNDA CAJA DE DIALOGO--------------------------------------------------
      */

      REDEFINE BITMAP oBmpPagos ;
         ID          500 ;
         RESOURCE    "SAFE_OUT_ALPHA_48" ;
         TRANSPARENT ;
         OF          fldRecibosProveedores

      REDEFINE COMBOBOX oPeriodoPrv ;
         VAR         cPeriodoPrv ;
         ID          100 ;
         ITEMS       aPeriodoPrv ;
         ON CHANGE   ( lRecargaFecha( oFecIniPrv, oFecFinPrv ), LoadPageIni( .f., .t. ) );
         OF          fldRecibosProveedores

      REDEFINE GET oFecIniPrv VAR dFecIniPrv;
         ID          110 ;
         SPINNER ;
         VALID       ( LoadPageIni( .f., .t. ) );
         OF          fldRecibosProveedores

      REDEFINE GET oFecFinPrv VAR dFecFinPrv;
         ID          120 ;
         SPINNER ;
         VALID       ( LoadPageIni( .f., .t. ) );
         OF          fldRecibosProveedores

      REDEFINE COMBOBOX oEstadoPrv VAR cEstadoPrv ;
         ID          130 ;
         ITEMS       aEstadoPrv ;
         ON CHANGE   ( LoadPageIni( .f., .t. ) );
         OF          fldRecibosProveedores

      REDEFINE BUTTON ;
         ID          140 ;
         OF          fldRecibosProveedores ;
         ACTION      ( SelAllRecPrv( .t. ) )

      REDEFINE BUTTON ;
         ID          150 ;
         OF          fldRecibosProveedores ;
         ACTION      ( SelAllRecPrv( .f. ) )

      REDEFINE BUTTON ;
         ID          160 ;
         OF          fldRecibosProveedores ;
         ACTION      ( SelRecPrv() )

      REDEFINE BUTTON ;
         ID          180 ;
         OF          fldRecibosProveedores ;
         ACTION      ( if( !Empty( ( dbfNewRecPrv )->cSerFac ), EdtRecPrv( ( dbfNewRecPrv )->cSerFac + Str( ( dbfNewRecPrv )->nNumFac ) +  ( dbfNewRecPrv )->cSufFac + Str( ( dbfNewRecPrv )->nNumRec ) ), ) )

      oBrwRecPrv                 := IXBrowse():New( fldRecibosProveedores )

      oBrwRecPrv:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwRecPrv:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwRecPrv:cAlias          := dbfNewRecPrv

      oBrwRecPrv:nMarqueeStyle   := 6
      oBrwRecPrv:lRecordSelector := .f.
      oBrwRecPrv:cName           := "Recibos de proveedor.Inicio"

      oBrwRecPrv:bLDblClick      := {|| SelRecPrv() }

      oBrwRecPrv:CreateFromResource( 170 )

      with object ( oBrwRecPrv:AddCol() )
         :cHeader                := "E. Estado"
         :bStrData               := {|| "" }
         :bEditValue             := {|| ( dbfNewRecPrv )->lCobrado }
         :nWidth                 := 18
         :SetCheck( { "Sel16", "Cnt16" } )
      end with

      with object ( oBrwRecPrv:AddCol() )
         :cHeader                := "T. Tipo"
         :bEditValue             := {|| if( Empty( (dbfNewRecPrv )->cTipRec ), "F. Factura", "R. Rectificativa" ) }
         :nWidth                 := 18
      end with

      with object ( oBrwRecPrv:AddCol() )
         :cHeader                := "Número"
         :bEditValue             := {|| AllTrim( ( dbfNewRecPrv )->cSerFac ) + "/" + AllTrim( Str( ( dbfNewRecPrv )->nNumFac ) ) + "/" +  AllTrim( ( dbfNewRecPrv )->cSufFac ) + "-" + AllTrim( Str( ( dbfNewRecPrv )->nNumRec ) ) }
         :nWidth                 := 80
      end with

      with object ( oBrwRecPrv:AddCol() )
         :cHeader                := "Proveedor"
         :bEditValue             := {|| AllTrim( ( dbfNewRecPrv )->cCodPrv ) }
         :nWidth                 := 60
      end with

      with object ( oBrwRecPrv:AddCol() )
         :cHeader                := "Nombre"
         :bEditValue             := {|| AllTrim( ( dbfNewRecPrv )->cNomPrv ) }
         :nWidth                 := 130
      end with

      with object ( oBrwRecPrv:AddCol() )
         :cHeader                := "Fecha"
         :bEditValue             := {|| Dtoc( ( dbfNewRecPrv )->dPreCob ) }
         :nWidth                 := 80
      end with

      with object ( oBrwRecPrv:AddCol() )
         :cHeader                := "Vencimiento"
         :bEditValue             := {|| Dtoc( ( dbfNewRecPrv )->dFecVto ) }
         :nWidth                 := 80
      end with

      with object ( oBrwRecPrv:AddCol() )
         :cHeader                := "Importe"
         :bEditValue             := {|| ( dbfNewRecPrv )->nImporte }
         :cEditPicture           := cPirDiv()
         :nWidth                 := 70
         :nDataStrAlign          := 1
         :nHeadStrAlign          := 1
      end with

      oFld:aDialogs[ nFolder ]:AddFastKey( VK_F3, {|| if( !Empty( ( dbfNewRecPrv )->cSerFac ), EdtRecPrv( ( dbfNewRecPrv )->cSerFac + Str( ( dbfNewRecPrv )->nNumFac ) +  ( dbfNewRecPrv )->cSufFac + Str( ( dbfNewRecPrv )->nNumRec ) ), ) } )
      oFld:aDialogs[ nFolder ]:AddFastKey( VK_F5, {|| LiquidaRecPrv() } )

   end if

Return ( nil )

//---------------------------------------------------------------------------//


 
























































































