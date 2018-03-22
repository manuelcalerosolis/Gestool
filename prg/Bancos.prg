#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//----------------------------------------------------------------------------//

CLASS TBancos FROM TMant

   DATA  cName          INIT "Bancos"  

   DATA  cMru           INIT "gc_central_bank_euro_16"

   DATA  cBitmap        INIT clrTopArchivos

   METHOD Create( cPath ) CONSTRUCTOR

   METHOD New( cPath, oWndParent, oMenuItem ) CONSTRUCTOR

   METHOD OpenFiles( lExclusive )
   METHOD CloseFiles()

   METHOD DefineFiles()

   METHOD Resource( nMode )

   METHOD lPreSave( oGet, nMode )

   METHOD GetCuentaBancaria()    INLINE ( ::oDbf:FieldGetByName( "cPaisIBAN" )   + ;
                                          ::oDbf:FieldGetByName( "cCtrlIBAN" )   + ;
                                          ::oDbf:FieldGetByName( "cEntBnc" )     + ;
                                          ::oDbf:FieldGetByName( "cSucBnc" )     + ;
                                          ::oDbf:FieldGetByName( "cDigBnc" )     + ;
                                          ::oDbf:FieldGetByName( "cCtaBnc" ) )

END CLASS

//----------------------------------------------------------------------------//

METHOD Create( cPath ) CLASS TBancos

   DEFAULT cPath        := cPatEmp()

   ::cPath              := cPath
   ::oDbf               := nil

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD New( cPath, oWndParent, oMenuItem ) CLASS TBancos

   DEFAULT cPath        := cPatEmp()
   DEFAULT oWndParent   := GetWndFrame()

   if oMenuItem != nil
      ::nLevel          := nLevelUsr( oMenuItem )
   else
      ::nLevel          := nLevelUsr( "01106" )
   end if

   ::cPath              := cPath
   ::oWndParent         := oWndParent
   ::oDbf               := nil

   ::lAutoButtons       := .t.
   ::lCreateShell       := .f.

   ::cBitmap            := clrTopArchivos

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive, cPath ) CLASS TBancos

   local lOpen          := .t.
   local oError
   local oBlock         

   DEFAULT lExclusive   := .f.
   DEFAULT cPath        := cPatEmp()

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf         := ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

   RECOVER USING oError

      lOpen             := .f.

      ::CloseFiles()

      msgStop( ErrorMessage( oError ), "Imposible abrir las bases de datos de bancos" )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TBancos

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:End()
   end if

   ::oDbf               := nil

RETURN .t.

//---------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver ) CLASS TBancos

   local oDbf

   DEFAULT cPath     := ::cPath
   DEFAULT cDriver   := cDriver()

   DEFINE DATABASE oDbf FILE "Bancos.Dbf" CLASS "Bancos" ALIAS "Bancos" PATH ( cPath ) VIA ( cDriver ) COMMENT "Bancos de empresa"

      FIELD NAME "cCodBnc"  TYPE "C"     LEN  4  DEC 0 COMMENT "Código"                   PICTURE "@!"      COLSIZE  60 OF oDbf
      FIELD NAME "cNomBnc"  TYPE "C"     LEN 50  DEC 0 COMMENT "Nombre"                   PICTURE "@!"      COLSIZE 300 OF oDbf
      FIELD NAME "cNomSuc"  TYPE "C"     LEN 50  DEC 0 COMMENT "Nombre sucursal"          HIDE OF oDbf
      FIELD NAME "cDirBnc"  TYPE "C"     LEN 35  DEC 0 COMMENT "Domicilio del banco"      HIDE OF oDbf
      FIELD NAME "cPobBnc"  TYPE "C"     LEN 25  DEC 0 COMMENT "Población del banco"      HIDE OF oDbf
      FIELD NAME "cProBnc"  TYPE "C"     LEN 20  DEC 0 COMMENT "Provincia del banco"      HIDE OF oDbf
      FIELD NAME "cPosBnc"  TYPE "C"     LEN 15  DEC 0 COMMENT "Código postal del banco"  HIDE OF oDbf
      FIELD NAME "cTlfBnc"  TYPE "C"     LEN 20  DEC 0 COMMENT "Teléfono del banco"       HIDE OF oDbf
      FIELD NAME "cFaxBnc"  TYPE "C"     LEN 20  DEC 0 COMMENT "Fax del banco"            HIDE OF oDbf
      FIELD NAME "cPCoBnc"  TYPE "C"     LEN 35  DEC 0 COMMENT "Persona de contacto"      HIDE OF oDbf
      FIELD NAME "cEntBnc"  TYPE "C"     LEN  4  DEC 0 COMMENT "Entidad"                  PICTURE "@!"      COLSIZE  60 OF oDbf
      FIELD NAME "cOfiBnc"  TYPE "C"     LEN  4  DEC 0 COMMENT "Oficina"                  PICTURE "@!"      COLSIZE  60 OF oDbf

      INDEX TO "Bancos.Cdx" TAG "cCodBnc" ON "cCodBnc" COMMENT "Código"    NODELETED                                    OF oDbf
      INDEX TO "Bancos.Cdx" TAG "cNomBnc" ON "cNomBnc" COMMENT "Nombre"    NODELETED                                    OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//----------------------------------------------------------------------------//

METHOD Resource( nMode ) CLASS TBancos

	local oDlg
   local oGet  := Array( 14 )

   DEFINE DIALOG oDlg RESOURCE "Bancos"  TITLE LblTitle( nMode ) + "banco"

      REDEFINE GET oGet[ 1 ] VAR ::oDbf:cCodBnc UPDATE;
			ID 		100 ;
         WHEN     ( nMode == APPD_MODE ) ;
         VALID    NotValid( oGet[ 1 ], ::oDbf:cAlias, .t., "0" ) ;
         PICTURE  "@!" ;
         OF       oDlg

      REDEFINE GET oGet[ 2 ] VAR ::oDbf:cNomBnc UPDATE;
         ID       110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET oGet[ 3 ] VAR ::oDbf:cNomSuc UPDATE;
         ID       120 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET oGet[ 4 ] VAR ::oDbf:cDirBnc UPDATE;
         ID       130 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET oGet[ 5 ] VAR ::oDbf:cPobBnc UPDATE;
         ID       140 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET oGet[ 6 ] VAR ::oDbf:cProBnc UPDATE;
         ID       160 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET oGet[ 7 ] VAR ::oDbf:cPosBnc UPDATE;
         ID       150 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET oGet[ 8 ] VAR ::oDbf:cTlfBnc UPDATE;
         ID       170 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET oGet[ 9 ] VAR ::oDbf:cFaxBnc UPDATE;
         ID       180 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET oGet[ 10 ] VAR ::oDbf:cPCoBnc UPDATE;
         ID       190 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET oGet[ 11 ] VAR ::oDbf:cEntBnc UPDATE;
         ID       200 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  '9999' ;
         OF       oDlg

      REDEFINE GET oGet[ 12 ] VAR ::oDbf:cOfiBnc UPDATE;
         ID       210 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  '9999' ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       500 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( if( ::lPreSave( oGet, nMode ), oDlg:end( IDOK ), ) )

		REDEFINE BUTTON ;
         ID       550 ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( oDlg:End() )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| if( ::lPreSave( oGet, nMode ), oDlg:end( IDOK ), ) } )
   end if

	ACTIVATE DIALOG oDlg	CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

METHOD lPreSave( oGet, nMode ) CLASS TBancos

   if ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) .and. !oGet[ 1 ]:lValid()
      Return .f.
   end if

   if Empty( ::oDbf:cNomBnc )
      MsgStop( "El nombre del banco no puede estar vacío." )
      oGet[ 2 ]:SetFocus()
      Return .f.
   end if

RETURN .t.

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TCuentasBancarias FROM TMant

   DATA  cMru              INIT "gc_central_bank_euro_text_16"

   DATA  oPais
   DATA  oBanco

   DATA  oPedCliP
   DATA  oAlbCliP
   DATA  oFacCliP
   DATA  oFacPrvP

   DATA  lBreak            INIT .f.

   DATA  oGetSaldoActual
   DATA  nGetSaldoActual   INIT 0

   METHOD Create( cPath ) CONSTRUCTOR

   METHOD New( cPath, oWndParent, oMenuItem ) CONSTRUCTOR

   METHOD OpenFiles( lExclusive )
   METHOD CloseFiles()

   METHOD OpenService( lExclusive )
   METHOD CloseService()

   METHOD DefineFiles()

   METHOD Activate()

   METHOD Resource( nMode )

   METHOD lEndResource( oGet, nMode )

   METHOD lLoadBanco( aGet, nMode )

   METHOD nSaldoActual()
   METHOD nSaldoSesion( cCta, cTurRec )

END CLASS

//----------------------------------------------------------------------------//

METHOD Create( cPath ) CLASS TCuentasBancarias

   DEFAULT cPath        := cPatEmp()

   ::cPath              := cPath
   ::oDbf               := nil

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD New( cPath, oWndParent, oMenuItem ) CLASS TCuentasBancarias

   DEFAULT cPath        := cPatEmp()
   DEFAULT oWndParent   := GetWndFrame()

   if oMenuItem != nil
      ::nLevel          := nLevelUsr( oMenuItem )
   else
      ::nLevel          := nLevelUsr( "01106" )
   end if

   ::cPath              := cPath
   ::oWndParent         := oWndParent
   ::oDbf               := nil

   ::lAutoButtons       := .t.
   ::lCreateShell       := .f.

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive ) CLASS TCuentasBancarias

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lExclusive   := .f.

   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf         := ::DefineFiles()
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

      DATABASE NEW ::oPedCliP PATH ( cPatEmp() ) CLASS "PedCliP" FILE "PedCliP.Dbf" VIA ( cDriver() ) SHARED INDEX "PedCliP.Cdx"

      DATABASE NEW ::oAlbCliP PATH ( cPatEmp() ) CLASS "AlbCliP" FILE "AlbCliP.Dbf" VIA ( cDriver() ) SHARED INDEX "AlbCliP.Cdx"

      ::oFacCliP        := TDataCenter():oFacCliP()

      DATABASE NEW ::oFacPrvP PATH ( cPatEmp() ) CLASS "FacPrvP" FILE "FacPrvP.Dbf" VIA ( cDriver() ) SHARED INDEX "FacPrvP.Cdx"

      ::oPais           := TPais():Create( cPatDat() )
      ::oPais:OpenFiles()

      ::oBanco          := TBancos():Create()
      ::oBanco:OpenFiles()

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir las bases de datos de cuentas bancarias" )

      ::CloseFiles()

      lOpen             := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TCuentasBancarias

   if !Empty( ::oPedCliP ) .and. ( ::oPedCliP:Used() )
      ::oPedCliP:end()
   end if

   if !Empty( ::oAlbCliP ) .and. ( ::oAlbCliP:Used() )
      ::oAlbCliP:end()
   end if

   if !Empty( ::oFacCliP )
      ::oFacCliP:End()
   end if

   if !Empty( ::oFacPrvP )
      ::oFacPrvP:End()
   end if

   if !Empty( ::oPais )
      ::oPais:End()
   end if

   if !Empty( ::oBanco )
      ::oBanco:End()
   end if

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:End()
   end if

   ::oDbf         := nil
   ::oFacCliP     := nil
   ::oFacPrvP     := nil
   ::oPais        := nil
   ::oBanco       := nil

RETURN .t.

//---------------------------------------------------------------------------//

METHOD OpenService( lExclusive, cPath ) CLASS TCuentasBancarias

   local lOpen          := .t.
   local oError
   local oBlock         

   DEFAULT lExclusive   := .f.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf         := ::DefineFiles()
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

   RECOVER USING oError

      lOpen             := .f.

      ::CloseService()

      msgStop( ErrorMessage( oError ), "Imposible abrir las bases de datos de bancos" )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseService() CLASS TCuentasBancarias

   if !Empty( ::oDbf ) .and. ::oDbf:Used()
      ::oDbf:End()
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver ) CLASS TCuentasBancarias

   local oDbf

   DEFAULT cPath     := ::cPath
   DEFAULT cDriver   := cDriver()

   DEFINE DATABASE oDbf FILE "EmpBnc.Dbf" CLASS "EmpBnc" ALIAS "EmpBnc" PATH ( cPath ) VIA ( cDriver ) COMMENT "Cuentas bancarias"

      FIELD NAME "cCodBnc"   TYPE "C"     LEN  3  DEC 0 COMMENT "Código"               PICTURE "@!"      COLSIZE  60 OF oDbf
      
      FIELD NAME "cPaisIBAN" TYPE "C"     LEN  2  DEC 0 COMMENT "País IBAN"               HIDE                       OF oDbf
      FIELD NAME "cCtrlIBAN" TYPE "C"     LEN  2  DEC 0 COMMENT "Dígito de control IBAN"  HIDE                       OF oDbf
      
      FIELD NAME "cEntBnc"   TYPE "C"     LEN  4  DEC 0 COMMENT "Entidad bancaria"     HIDE                          OF oDbf
      FIELD NAME "cSucBnc"   TYPE "C"     LEN  4  DEC 0 COMMENT "Sucursal bancaria"    HIDE                          OF oDbf
      FIELD NAME "cDigBnc"   TYPE "C"     LEN  2  DEC 0 COMMENT "Dígito control"       HIDE                          OF oDbf
      FIELD NAME "cCtaBnc"   TYPE "C"     LEN 10  DEC 0 COMMENT "Cuenta"               HIDE                          OF oDbf
      FIELD NAME "cNomBnc"   TYPE "C"     LEN 50  DEC 0 COMMENT "Nombre del banco"     COLSIZE 300                   OF oDbf

      FIELD CALCULATE NAME "bCtaBnc"      LEN 14  DEC 0 COMMENT "Cuenta bancaria" ;
         VAL {|| oDbf:FieldGetByName( "cPaisIBAN" ) + oDbf:FieldGetByName( "cCtrlIBAN" ) + "-" + oDbf:FieldGetByName( "cEntBnc" ) + "-" + oDbf:FieldGetByName( "cSucBnc" ) + "-" + oDbf:FieldGetByName( "cDigBnc" ) + "-" + oDbf:FieldGetByName( "cCtaBnc" ) };
                                                                                       COLSIZE 200                   OF oDbf

      FIELD NAME "cDirBnc"   TYPE "C"     LEN 35  DEC 0 COMMENT "Domicilio del banco"  HIDE                          OF oDbf
      FIELD NAME "cPobBnc"   TYPE "C"     LEN 25  DEC 0 COMMENT "Población del banco"  HIDE                          OF oDbf
      FIELD NAME "cProBnc"   TYPE "C"     LEN 20  DEC 0 COMMENT "Provincia del banco"  HIDE                          OF oDbf
      FIELD NAME "cCPBnc"    TYPE "C"     LEN 15  DEC 0 COMMENT "Código postal"        HIDE                          OF oDbf
      FIELD NAME "cTlfBnc"   TYPE "C"     LEN 20  DEC 0 COMMENT "Teléfono"             PICTURE "@!"      COLSIZE  60 OF oDbf
      FIELD NAME "cFaxBnc"   TYPE "C"     LEN 20  DEC 0 COMMENT "Fax"                  PICTURE "@!"      COLSIZE  60 OF oDbf
      FIELD NAME "cPContBnc" TYPE "C"     LEN 35  DEC 0 COMMENT "Persona de contacto"                    COLSIZE 160 OF oDbf
      FIELD NAME "cPaiBnc"   TYPE "C"     LEN  4  DEC 0 COMMENT "Pais"                 PICTURE "@!"      COLSIZE 120 OF oDbf
      FIELD NAME "nSalIni"   TYPE "N"     LEN 16  DEC 0 COMMENT "Saldo inicial"        HIDE                          OF oDbf

      INDEX TO "EmpBnc.Cdx" TAG "cCodBnc" ON "cCodBnc"                                                         COMMENT "Código" NODELETED   OF oDbf
      INDEX TO "EmpBnc.Cdx" TAG "cNomBnc" ON "cNomBnc"                                                         COMMENT "Nombre" NODELETED   OF oDbf
      INDEX TO "EmpBnc.Cdx" TAG "cCtaBnc" ON "cPaisIBAN + cCtrlIBAN + cEntBnc + cSucBnc + cDigBnc + cCtaBnc"   COMMENT "Cuenta" NODELETED   OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS TCuentasBancarias

   if nAnd( ::nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      Return ( Self )
   end if

   /*
   Cerramos todas las ventanas-------------------------------------------------
   */

   if ::oWndParent != nil
      ::oWndParent:CloseAll()
   end if

   if Empty( ::oDbf ) .or. !::oDbf:Used()
      ::lOpenFiles      := ::OpenFiles()
   end if

   /*
   Creamos el Shell------------------------------------------------------------
   */

   if ::lOpenFiles

      if !::lCreateShell
         ::CreateShell( ::nLevel )
      end if

      ::oWndBrw:GralButtons( Self )

      DEFINE BTNSHELL RESOURCE "gc_document_empty_chart_" GROUP OF ::oWndBrw ;
			NOBORDER ;
         ACTION   ( TFastCuentasBancarias():New():Play() ) ;
         TOOLTIP  "Rep(o)rting";
         HOTKEY   "O" ;
         LEVEL    ACC_IMPR

      ::oWndBrw:EndButtons( Self )

      if ::cHtmlHelp != nil
         ::oWndBrw:cHtmlHelp  := ::cHtmlHelp
      end if

      ::oWndBrw:Activate( , , , , , , , , , , , , , , , , {|| ::CloseFiles() } )

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( nMode ) CLASS TCuentasBancarias

	local oDlg
   local oBmp
   local cBmp
   local aGet
   local oSayPai
   local cSayPai
   local oBmpBancos

   aGet                 := Array( ::oDbf:FieldCount() )
   cBmp                 := ::oPais:cBmp( ::oDbf:cPaiBnc )
   cSayPai              := ::oPais:cNombre( ::oDbf:cPaiBnc )

   ::lBreak             := .f.
   
   if Empty( ::oDbf:cPaisIBAN )
      ::oDbf:cPaisIBAN  := "ES"
   end if

   DEFINE DIALOG oDlg RESOURCE "BancoEmpresa" TITLE LblTitle( nMode ) + "cuentas bancarias"

      REDEFINE BITMAP oBmpBancos ;
         ID       600 ;
         RESOURCE "gc_office_building_48" ;
         TRANSPARENT ;
         OF       oDlg

      REDEFINE GET aGet[ ::oDbf:FieldPos( "cCodBnc" ) ] ;
         VAR      ::oDbf:cCodBnc ;
         ID       190 ;
         WHEN     ( nMode == APPD_MODE ) ;
         VALID    ( NotValid( aGet[ ::oDbf:FieldPos( "cCodBnc" ) ], ::oDbf:cAlias, .t., "0" ) ) ;
         PICTURE  "@!" ;
         OF       oDlg

      REDEFINE GET aGet[ ::oDbf:FieldPos( "cNomBnc" ) ] ;
         VAR      ::oDbf:cNomBnc ;
         ID       200 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "Lupa" ;
         OF       oDlg

      aGet[ ::oDbf:FieldPos( "cNomBnc" ) ]:bHelp   := {|| ::lLoadBanco( aGet, nMode ) }

      REDEFINE GET aGet[ ::oDbf:FieldPos( "cDirBnc" ) ] ;
         VAR      ::oDbf:cDirBnc ;
         ID       210 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aGet[ ::oDbf:FieldPos( "cPobBnc" ) ] ;
         VAR      ::oDbf:cPobBnc ;
         ID       220 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aGet[ ::oDbf:FieldPos( "cCPBnc" ) ] ;
         VAR      ::oDbf:cCPBnc ;
         ID       230 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aGet[ ::oDbf:FieldPos( "cProBnc" ) ] ;
         VAR      ::oDbf:cProBnc ;
         ID       240 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aGet[ ::oDbf:FieldPos( "cPaiBnc" ) ] ;
         VAR      ::oDbf:cPaiBnc ;
         ID       300 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         OF       oDlg

         aGet[ ::oDbf:FieldPos( "cPaiBnc" ) ]:bValid  := {|| ::oPais:GetPais( ::oDbf:cPaiBnc, oSayPai, oBmp ) }
         aGet[ ::oDbf:FieldPos( "cPaiBnc" ) ]:bHelp   := {|| ::oPais:Buscar( aGet[ ::oDbf:FieldPos( "cPaiBnc" ) ] ) }

      REDEFINE BITMAP oBmp ;
         RESOURCE cBmp ;
         ID       301;
         OF       oDlg

      REDEFINE GET oSayPai VAR cSayPai ;
         ID       302 ;
         SPINNER ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE GET aGet[ ::oDbf:FieldPos( "cTlfBnc" ) ] ;
         VAR      ::oDbf:cTlfBnc ;
         ID       250 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aGet[ ::oDbf:FieldPos( "cFaxBnc" ) ] ;
         VAR      ::oDbf:cFaxBnc ;
         ID       260 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aGet[ ::oDbf:FieldPos( "cPContBnc" ) ] ;
         VAR      ::oDbf:cPContBnc ;
         ID       270 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aGet[ ::oDbf:FieldPos( "cPaisIBAN" ) ] ;
         VAR      ::oDbf:cPaisIBAN ;
         PICTURE  "@!" ;
         ID       370 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lIbanDigit( ::oDbf:cPaisIBAN, ::oDbf:cEntBnc, ::oDbf:cSucBnc, ::oDbf:cDigBnc, ::oDbf:cCtaBnc, aGet[ ::oDbf:FieldPos( "cCtrlIBAN" ) ] ) ) ;
         OF       oDlg

      REDEFINE GET aGet[ ::oDbf:FieldPos( "cCtrlIBAN" ) ] ;
         VAR      ::oDbf:cCtrlIBAN ;
         ID       380 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lIbanDigit( ::oDbf:cPaisIBAN, ::oDbf:cEntBnc, ::oDbf:cSucBnc, ::oDbf:cDigBnc, ::oDbf:cCtaBnc, aGet[ ::oDbf:FieldPos( "cCtrlIBAN" ) ] ) ) ;
         OF       oDlg

      REDEFINE GET aGet[ ::oDbf:FieldPos( "cEntBnc" ) ] ;
         VAR      ::oDbf:cEntBnc ;
         ID       310 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    (  lCalcDC( ::oDbf:cEntBnc, ::oDbf:cSucBnc, ::oDbf:cDigBnc, ::oDbf:cCtaBnc, aGet[ ::oDbf:FieldPos( "cDigBnc" ) ] ) .and.;
                     lIbanDigit( ::oDbf:cPaisIBAN, ::oDbf:cEntBnc, ::oDbf:cSucBnc, ::oDbf:cDigBnc, ::oDbf:cCtaBnc, aGet[ ::oDbf:FieldPos( "cCtrlIBAN" ) ] ) ) ;
         OF       oDlg

      REDEFINE GET aGet[ ::oDbf:FieldPos( "cSucBnc" ) ];
         VAR      ::oDbf:cSucBnc ;
         ID       320 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    (  lCalcDC( ::oDbf:cEntBnc, ::oDbf:cSucBnc, ::oDbf:cDigBnc, ::oDbf:cCtaBnc, aGet[ ::oDbf:FieldPos( "cDigBnc" ) ] ) .and.;
                     lIbanDigit( ::oDbf:cPaisIBAN, ::oDbf:cEntBnc, ::oDbf:cSucBnc, ::oDbf:cDigBnc, ::oDbf:cCtaBnc, aGet[ ::oDbf:FieldPos( "cCtrlIBAN" ) ] ) ) ;
         OF       oDlg

      REDEFINE GET aGet[ ::oDbf:FieldPos( "cDigBnc" ) ];
         VAR      ::oDbf:cDigBnc;
         ID       330 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    (  lCalcDC( ::oDbf:cEntBnc, ::oDbf:cSucBnc, ::oDbf:cDigBnc, ::oDbf:cCtaBnc, aGet[ ::oDbf:FieldPos( "cDigBnc" ) ] ) .and.;
                     lIbanDigit( ::oDbf:cPaisIBAN, ::oDbf:cEntBnc, ::oDbf:cSucBnc, ::oDbf:cDigBnc, ::oDbf:cCtaBnc, aGet[ ::oDbf:FieldPos( "cCtrlIBAN" ) ] ) ) ;
         OF       oDlg

      REDEFINE GET aGet[ ::oDbf:FieldPos( "cCtaBnc" ) ];
         VAR      ::oDbf:cCtaBnc ;
         ID       340 ;
         PICTURE  "9999999999" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    (  lCalcDC( ::oDbf:cEntBnc, ::oDbf:cSucBnc, ::oDbf:cDigBnc, ::oDbf:cCtaBnc, aGet[ ::oDbf:FieldPos( "cDigBnc" ) ] ) .and.;
                     lIbanDigit( ::oDbf:cPaisIBAN, ::oDbf:cEntBnc, ::oDbf:cSucBnc, ::oDbf:cDigBnc, ::oDbf:cCtaBnc, aGet[ ::oDbf:FieldPos( "cCtrlIBAN" ) ] ) ) ;
         OF       oDlg

      REDEFINE GET aGet[ ::oDbf:FieldPos( "nSalIni" ) ];
         VAR      ::oDbf:nSalIni;
         ID       350 ;
         PICTURE  cPorDiv() ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oGetSaldoActual ;
         VAR      ::nGetSaldoActual ;
         ID       360 ;
         PICTURE  cPorDiv() ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      TBtnBmp():ReDefine( 361, "gc_recycle_16",,,,, {|| ::nSaldoActual() }, oDlg, .f., , .f. )

   /*
   Botones de la caja----------------------------------------------------------
   */

      REDEFINE BUTTON ;
         ID       500 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::lEndResource( aGet, oDlg, nMode ) )

      REDEFINE BUTTON ;
         ID       550 ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( ::lBreak := .t., SysRefresh(), oDlg:End() )

      /*
      Tecla rápida para boton aceptar------------------------------------------
      */

      if ( nMode != ZOOM_MODE )
         oDlg:AddFastKey( VK_F5, {|| ::lEndResource( aGet, oDlg, nMode ) } )
      end if

      // oDlg:bStart := {|| ::nSaldoActual() }

   ACTIVATE DIALOG oDlg CENTER

   if !Empty( oBmp )
      oBmp:end()
   end if

   if !Empty( oBmpBancos )
      oBmpBancos:end()
   end if

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

METHOD lEndResource( aGet, oDlg, nMode ) CLASS TCuentasBancarias

   if ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) .and. !aGet[ ::oDbf:FieldPos( "cCodBnc" ) ]:lValid()
      Return .f.
   end if

   if Empty( ::oDbf:cNomBnc )
      MsgStop( "El nombre del banco no puede estar vacío." )
      aGet[ ::oDbf:FieldPos( "cNomBnc" ) ]:SetFocus()
      Return .f.
   end if

   if Empty( ::oDbf:cCtaBnc )
      MsgStop( "La cuenta del banco no puede estar vacío." )
      aGet[ ::oDbf:FieldPos( "cCtaBnc" ) ]:SetFocus()
      Return .f.
   end if

   oDlg:End( IDOK )

RETURN .t.

//---------------------------------------------------------------------------//

METHOD lLoadBanco( aGet, nMode ) CLASS TCuentasBancarias

   local cBanco   := ""
   local cCuenta  := ""

   ::oBanco:Buscar( aGet[ ::oDbf:FieldPos( "cNomBnc" ) ], "cCodBnc" )

   cBanco         := aGet[ ::oDbf:FieldPos( "cNomBnc" ) ]:VarGet()

   aGet[ ::oDbf:FieldPos( "cNomBnc" ) ]:cText( oRetFld( cBanco, ::oBanco:oDbf, "cNomBnc" ) )
   aGet[ ::oDbf:FieldPos( "cDirBnc" ) ]:cText( oRetFld( cBanco, ::oBanco:oDbf, "cDirBnc" ) )
   aGet[ ::oDbf:FieldPos( "cPobBnc" ) ]:cText( oRetFld( cBanco, ::oBanco:oDbf, "cPobBnc" ) )
   aGet[ ::oDbf:FieldPos( "cProBnc" ) ]:cText( oRetFld( cBanco, ::oBanco:oDbf, "cProBnc" ) )
   aGet[ ::oDbf:FieldPos( "cCPBnc" )  ]:cText( oRetFld( cBanco, ::oBanco:oDbf, "cPosBnc" ) )
   aGet[ ::oDbf:FieldPos( "cTlfBnc" ) ]:cText( oRetFld( cBanco, ::oBanco:oDbf, "cTlfBnc" ) )
   aGet[ ::oDbf:FieldPos( "cFaxBnc" ) ]:cText( oRetFld( cBanco, ::oBanco:oDbf, "cFaxBnc" ) )
   aGet[ ::oDbf:FieldPos( "cPContBnc")]:cText( oRetFld( cBanco, ::oBanco:oDbf, "cPcoBnc" ) )

   aGet[ ::oDbf:FieldPos( "cEntBnc" ) ]:cText( oRetFld( cBanco, ::oBanco:oDbf, "cEntBnc" ) )
   aGet[ ::oDbf:FieldPos( "cSucBnc" ) ]:cText( oRetFld( cBanco, ::oBanco:oDbf, "cOfiBnc" ) )
   aGet[ ::oDbf:FieldPos( "cDigBnc" ) ]:cText( Space( 2 ) )
   aGet[ ::oDbf:FieldPos( "cCtaBnc" ) ]:cText( Space( 10 ) )

Return .t.

//---------------------------------------------------------------------------//

METHOD nSaldoActual( cCta ) CLASS TCuentasBancarias

   local nOrd
   local nSaldo      := 0

   DEFAULT cCta      := ::oDbf:bCtaBnc

   if Empty( cCta )
      Return ( nSaldo )
   end if

   CursorWait()

   /*
   Saldo anterior--------------------------------------------------------------
   */

   nOrd              := ::oDbf:OrdSetFocus( "cCtaBnc" )

   if ::oDbf:Seek( cCta )
      nSaldo         := ::oDbf:nSalIni
   end if

   ::oDbf:OrdSetFocus( nOrd )

   /*
   Entregas en pedidos---------------------------------------------------------
   */

   nOrd              := ::oPedCliP:OrdSetFocus( "lCtaBnc" )

   if ::oPedCliP:Seek( cCta )

      while !::lBreak .and. ::oPedCliP:cEntEmp + ::oPedCliP:cSucEmp + ::oPedCliP:cDigEmp + ::oPedCliP:cCtaEmp == cCta .and. !::oPedCliP:Eof()

         nSaldo      += ::oPedCliP:nImporte

         ::oPedCliP:Skip()

      end while

   end if

   ::oPedCliP:OrdSetFocus( nOrd )

   /*
   Entregas en albaranes-------------------------------------------------------
   */

   nOrd              := ::oAlbCliP:OrdSetFocus( "lCtaBnc" )

   if ::oAlbCliP:Seek( cCta )

      while !::lBreak .and. ::oAlbCliP:cEntEmp + ::oAlbCliP:cSucEmp + ::oAlbCliP:cDigEmp + ::oAlbCliP:cCtaEmp == cCta .and. !::oAlbCliP:Eof()

         nSaldo      += ::oAlbCliP:nImporte

         ::oAlbCliP:Skip()

      end while

   end if

   ::oAlbCliP:OrdSetFocus( nOrd )

   /*
   Recibos de clientes---------------------------------------------------------
   */

   nOrd              := ::oFacCliP:OrdSetFocus( "lCtaBnc" )

   if ::oFacCliP:Seek( cCta )

      while !::lBreak .and. ::oFacCliP:cEntEmp + ::oFacCliP:cSucEmp + ::oFacCliP:cDigEmp + ::oFacCliP:cCtaEmp == cCta .and. !::oFacCliP:Eof()

         nSaldo      += ::oFacCliP:nImporte

         ::oFacCliP:Skip()

      end while

   end if

   ::oFacCliP:OrdSetFocus( nOrd )

   /*
   Recibos de proveedores------------------------------------------------------
   */

   nOrd              := ::oFacPrvP:OrdSetFocus( "lCtaBnc" )

   if ::oFacPrvP:Seek( cCta )

      while !::lBreak .and. ::oFacPrvP:cEntEmp + ::oFacPrvP:cSucEmp + ::oFacPrvP:cDigEmp + ::oFacPrvP:cCtaEmp == cCta .and. !::oFacPrvP:Eof()

         nSaldo      -= ::oFacPrvP:nImporte

         ::oFacPrvP:Skip()

      end while

   end if

   ::oFacPrvP:OrdSetFocus( nOrd )

   if !Empty( ::oGetSaldoActual )
      ::oGetSaldoActual:cText( nSaldo )
   end if

   CursorWE()

Return ( nSaldo )

//---------------------------------------------------------------------------//

METHOD nSaldoSesion( cCta, cTurRec ) CLASS TCuentasBancarias

   local nOrd
   local nSaldo      := 0

   if Empty( cCta )
      Return ( nSaldo )
   end if

   if Empty( cTurRec )
      Return ( nSaldo )
   end if

   CursorWait()

   /*
   Saldo anterior--------------------------------------------------------------
   */

   nOrd              := ::oDbf:OrdSetFocus( "cCtaBnc" )

   if ::oDbf:Seek( cCta )
      nSaldo         := ::oDbf:nSalIni
   end if

   ::oDbf:OrdSetFocus( nOrd )

   /*
   Recibos de clientes---------------------------------------------------------
   */

   nOrd              := ::oFacCliP:OrdSetFocus( "lCtaBnc" )

   if ::oFacCliP:Seek( cCta )

      while !::lBreak .and. ::oFacCliP:cEntEmp + ::oFacCliP:cSucEmp + ::oFacCliP:cDigEmp + ::oFacCliP:cCtaEmp == cCta .and. !::oFacCliP:Eof()

         if ::oFacCliP:cTurRec != cTurRec
            nSaldo   += ::oFacCliP:nImporte
         end if

         ::oFacCliP:Skip()

      end while

   end if

   ::oFacCliP:OrdSetFocus( nOrd )

   /*
   Recibos de proveedores------------------------------------------------------
   */

   nOrd              := ::oFacPrvP:OrdSetFocus( "lCtaBnc" )

   if ::oFacPrvP:Seek( cCta )

      while !::lBreak .and. ::oFacPrvP:cEntEmp + ::oFacPrvP:cSucEmp + ::oFacPrvP:cDigEmp + ::oFacPrvP:cCtaEmp == cCta .and. !::oFacPrvP:Eof()

         if ::oFacPrvP:cTurRec != cTurRec
            nSaldo   -= ::oFacPrvP:nImporte
         end if

         ::oFacPrvP:Skip()

      end while

   end if

   ::oFacPrvP:OrdSetFocus( nOrd )

   if !Empty( ::oGetSaldoActual )
      ::oGetSaldoActual:cText( nSaldo )
   end if

   CursorWE()

Return ( nSaldo )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TFastCuentasBancarias FROM TFastReportInfGen

   DATA  cResource       INIT "ReportingDialog"

   DATA  oPedCliP
   DATA  oAlbCliP
   DATA  oFacCliP
   DATA  oFacPrvP

   METHOD lResource( cFld )

   METHOD OpenFiles()
   METHOD CloseFiles()

   METHOD Create()

   METHOD lGenerate()
   METHOD lValidRegister()

   METHOD DataReport( oFr )

   METHOD StartDialog()
   METHOD BuildTree( oTree, lSubNode )

   METHOD AddPedidosClientes()
   METHOD AddAlbaranesClientes()
   METHOD AddRecibosClientes()
   METHOD AddRecibosProveedores()

   METHOD CalculaSaldo()

   METHOD TreeReportingChanged()

END CLASS

//----------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS TFastCuentasBancarias

   ::lNewInforme     := .t.
   ::lDefCondiciones := .f.

   if !::NewResource()
      return .f.
   end if

   if !::lGrupoEntidadesBancarias( .t. )
      return .f.
   end if

   if !::lGrupoCliente( .t. )
      return .f.
   end if

   if !::lGrupoProveedor( .t. )
      return .f.
   end if

RETURN .t.

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TFastCuentasBancarias

   local lOpen    := .t.
   local oError
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      DATABASE NEW ::oPedCliP PATH ( cPatEmp() ) CLASS "PedCliP" FILE "PedCliP.Dbf" VIA ( cDriver() ) SHARED INDEX "PedCliP.Cdx"

      DATABASE NEW ::oAlbCliP PATH ( cPatEmp() ) CLASS "AlbCliP" FILE "AlbCliP.Dbf" VIA ( cDriver() ) SHARED INDEX "AlbCliP.Cdx"

      ::oFacCliP  := TDataCenter():oFacCliP()

      DATABASE NEW ::oFacPrvP PATH ( cPatEmp() ) CLASS "FacPrvP" FILE "FacPrvP.Dbf" VIA ( cDriver() ) SHARED INDEX "FacPrvP.Cdx"

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos de informes de cuentas bancarias." )

      ::CloseFiles()

      lOpen       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TFastCuentasBancarias

   if !Empty( ::oPedCliP ) .and. ( ::oPedCliP:Used() )
      ::oPedCliP:end()
   end if

   if !Empty( ::oAlbCliP ) .and. ( ::oAlbCliP:Used() )
      ::oAlbCliP:end()
   end if

   if !Empty( ::oFacCliP ) .and. ( ::oFacCliP:Used() )
      ::oFacCliP:end()
   end if

   if !Empty( ::oFacPrvP ) .and. ( ::oFacPrvP:Used() )
      ::oFacPrvP:end()
   end if

   if !Empty( ::oCuentasBancarias )
      ::oCuentasBancarias:End()
   end if

RETURN .t.

//---------------------------------------------------------------------------//

METHOD Create( uParam ) CLASS TFastCuentasBancarias

   ::AddField( "cTipDoc",  "C", 30, 0, {|| "" },   "Tipo de documento"                             )
   ::AddField( "cSerFac" , "C",  1, 0, {|| "" },   "Serie de recibo"                               )
   ::AddField( "nNumFac",  "N",  9, 0, {|| "" },   "Número de recibo"                              )
   ::AddField( "cSufFac",  "C",  2, 0, {|| "" },   "Sufijo de recibo"                              )
   ::AddField( "cCodCli",  "C", 12, 0, {|| "@!" }, "Código cliente"                                )
   ::AddField( "cCodPrv",  "C", 12, 0, {|| "@!" }, "Código proveedor"                              )
   ::AddField( "dCobRec",  "D",  8, 0, {|| "" },   "Fecha de cobro"                                )
   ::AddField( "dEmiRec",  "D",  8, 0, {|| "" },   "Fecha de emisión"                              )
   ::AddField( "cCodCta",  "C",  3, 0, {|| "" },   "Código de la cuenta bancaria"                  )
   ::AddField( "cEntEmp",  "C",  4, 0, {|| "@!" }, "Entidad de la cuenta de la empresa"            )
   ::AddField( "cSucEmp",  "C",  4, 0, {|| "@!" }, "Sucursal de la cuenta de la empresa"           )
   ::AddField( "cDigEmp",  "C",  2, 0, {|| "@!" }, "Dígito de control de la cuenta de la empresa"  )
   ::AddField( "cCtaEmp",  "C", 10, 0, {|| "@!" }, "Cuenta bancaria de la empresa"                 )
   ::AddField( "nTotImp",  "N", 16, 6, {|| "" },   "Importe recibo"                                )
   ::AddField( "nSalImp",  "N", 16, 6, {|| "" },   "Saldo recibo"                                  )

   ::AddTmpIndex( "cCtaEmp", "cCodCta + Dtos( dCobRec )" )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD lGenerate() CLASS TFastCuentasBancarias

   ::oDbf:Zap()

   do case
      case ::cReportType == "Informe de cuentas bancarias"

         ::AddPedidosClientes()

         ::AddAlbaranesClientes()

         ::AddRecibosClientes()

         ::AddRecibosProveedores()

         ::CalculaSaldo()

      otherwise

         msgStop( "Tipo de informe no valido.", ::cReportType )

   end case

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

Method lValidRegister( cCtaBnc ) CLASS TFastCuentasBancarias

Return ( cCtaBnc >= ::oGrupoCuentasBancarias:Cargo:Desde .and. cCtaBnc <= ::oGrupoCuentasBancarias:Cargo:Hasta )

//---------------------------------------------------------------------------//

METHOD AddPedidosClientes() CLASS TFastCuentasBancarias

   local cExp
   local cCta

   ::oPedCliP:OrdSetFocus( "dEntrega" )

   cExp                 := '!lPasado .and. dEntrega >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dEntrega <= Ctod( "' + Dtoc( ::dFinInf ) + '" ) .and. '
   cExp                 += 'cCodCli >= "' + ::oGrupoCliente:Cargo:Desde + '" .and. cCodCli <= "' + ::oGrupoCliente:Cargo:Hasta + '"'

   ::oPedCliP:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oPedCliP:cFile ), ::oPedCliP:OrdKey(), ( cExp ), , , , , , , , .t. )

   ::oMtrInf:cText      := "Procesando recibos de clientes"
   ::oMtrInf:SetTotal( ::oPedCliP:OrdKeyCount() )

   ::oPedCliP:GoTop()
   while !::lBreak .and. !::oPedCliP:Eof()

      cCta              := oRetFld( ::oPedCliP:cEntEmp + ::oPedCliP:cSucEmp + ::oPedCliP:cDigEmp + ::oPedCliP:cCtaEmp, ::oCuentasBancarias:oDbf, "cCodBnc", "cCtaBnc" )

      if ::lValidRegister( cCta )

         ::oDbf:Append()

         ::oDbf:cCodPrv := ""
         ::oDbf:cCodCta := cCta
         ::oDbf:cTipDoc := "Entregas pedidos"
         ::oDbf:cSerFac := ::oPedCliP:cSerPed
         ::oDbf:nNumFac := ::oPedCliP:nNumPed
         ::oDbf:cSufFac := ::oPedCliP:cSufPed
         ::oDbf:cCodCli := ::oPedCliP:cCodCli
         ::oDbf:dEmiRec := ::oPedCliP:dEntrega
         ::oDbf:dCobRec := ::oPedCliP:dEntrega
         ::oDbf:cEntEmp := ::oPedCliP:cEntEmp
         ::oDbf:cSucEmp := ::oPedCliP:cSucEmp
         ::oDbf:cDigEmp := ::oPedCliP:cDigEmp
         ::oDbf:cCtaEmp := ::oPedCliP:cCtaEmp
         ::oDbf:nTotImp := ::oPedCliP:nImporte

         ::oDbf:Save()

      end if

      ::oPedCliP:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oPedCliP:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oPedCliP:cFile ) )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddAlbaranesClientes() CLASS TFastCuentasBancarias

   local cExp
   local cCta

   ::oAlbCliP:OrdSetFocus( "dEntrega" )

   cExp                 := '!lPasado .and. dEntrega >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dEntrega <= Ctod( "' + Dtoc( ::dFinInf ) + '" ) .and. '
   cExp                 += 'cCodCli >= "' + ::oGrupoCliente:Cargo:Desde + '" .and. cCodCli <= "' + ::oGrupoCliente:Cargo:Hasta + '"'

   ::oAlbCliP:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oAlbCliP:cFile ), ::oAlbCliP:OrdKey(), ( cExp ), , , , , , , , .t. )

   ::oMtrInf:cText      := "Procesando recibos de clientes"
   ::oMtrInf:SetTotal( ::oAlbCliP:OrdKeyCount() )

   ::oAlbCliP:GoTop()
   while !::lBreak .and. !::oAlbCliP:Eof()

      cCta              := oRetFld( ::oAlbCliP:cEntEmp + ::oAlbCliP:cSucEmp + ::oAlbCliP:cDigEmp + ::oAlbCliP:cCtaEmp, ::oCuentasBancarias:oDbf, "cCodBnc", "cCtaBnc" )

      if ::lValidRegister( cCta )

         ::oDbf:Append()

         ::oDbf:cCodPrv := ""
         ::oDbf:cCodCta := cCta
         ::oDbf:cTipDoc := "Entregas albraranes"
         ::oDbf:cSerFac := ::oAlbCliP:cSerAlb
         ::oDbf:nNumFac := ::oAlbCliP:nNumAlb
         ::oDbf:cSufFac := ::oAlbCliP:cSufAlb
         ::oDbf:cCodCli := ::oAlbCliP:cCodCli
         ::oDbf:dEmiRec := ::oAlbCliP:dEntrega
         ::oDbf:dCobRec := ::oAlbCliP:dEntrega
         ::oDbf:cEntEmp := ::oAlbCliP:cEntEmp
         ::oDbf:cSucEmp := ::oAlbCliP:cSucEmp
         ::oDbf:cDigEmp := ::oAlbCliP:cDigEmp
         ::oDbf:cCtaEmp := ::oAlbCliP:cCtaEmp
         ::oDbf:nTotImp := ::oAlbCliP:nImporte

         ::oDbf:Save()

      end if

      ::oAlbCliP:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oAlbCliP:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oAlbCliP:cFile ) )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddRecibosClientes() CLASS TFastCuentasBancarias

   local cExp
   local cCta

   ::oFacCliP:OrdSetFocus( "dEntrada" )

   cExp                 := 'lCobrado .and. dEntrada >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dEntrada <= Ctod( "' + Dtoc( ::dFinInf ) + '" ) .and. '
   cExp                 += 'cCodCli >= "' + ::oGrupoCliente:Cargo:Desde + '" .and. cCodCli <= "' + ::oGrupoCliente:Cargo:Hasta + '"'

   ::oFacCliP:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacCliP:cFile ), ::oFacCliP:OrdKey(), ( cExp ), , , , , , , , .t. )

   ::oMtrInf:cText      := "Procesando recibos de clientes"
   ::oMtrInf:SetTotal( ::oFacCliP:OrdKeyCount() )

   ::oFacCliP:GoTop()
   while !::lBreak .and. !::oFacCliP:Eof()

      cCta              := oRetFld( ::oFacCliP:cEntEmp + ::oFacCliP:cSucEmp + ::oFacCliP:cDigEmp + ::oFacCliP:cCtaEmp, ::oCuentasBancarias:oDbf, "cCodBnc", "cCtaBnc" )

      if ::lValidRegister( cCta )

         ::oDbf:Append()

         ::oDbf:cCodPrv := ""
         ::oDbf:cCodCta := cCta
         ::oDbf:cTipDoc := "Recibos clientes"
         ::oDbf:cSerFac := ::oFacCliP:cSerie
         ::oDbf:nNumFac := ::oFacCliP:nNumFac
         ::oDbf:cSufFac := ::oFacCliP:cSufFac
         ::oDbf:cCodCli := ::oFacCliP:cCodCli
         ::oDbf:dEmiRec := ::oFacCliP:dPreCob
         ::oDbf:dCobRec := ::oFacCliP:dEntrada
         ::oDbf:cEntEmp := ::oFacCliP:cEntEmp
         ::oDbf:cSucEmp := ::oFacCliP:cSucEmp
         ::oDbf:cDigEmp := ::oFacCliP:cDigEmp
         ::oDbf:cCtaEmp := ::oFacCliP:cCtaEmp
         ::oDbf:nTotImp := ::oFacCliP:nImporte

         ::oDbf:Save()

      end if

      ::oFacCliP:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oFacCliP:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacCliP:cFile ) )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddRecibosProveedores() CLASS TFastCuentasBancarias

   local cExp
   local cCta

   ::oFacPrvP:OrdSetFocus( "dEntrada" )

   cExp                 := 'lCobrado .and. dEntrada >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dEntrada <= Ctod( "' + Dtoc( ::dFinInf ) + '" ) .and. '
   cExp                 += 'cCodPrv >= "' + ::oGrupoCliente:Cargo:Desde + '" .and. cCodPrv <= "' + ::oGrupoCliente:Cargo:Hasta + '"'

   ::oFacPrvP:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacPrvP:cFile ), ::oFacPrvP:OrdKey(), ( cExp ), , , , , , , , .t. )

   ::oMtrInf:cText      := "Procesando recibos de proveedores"
   ::oMtrInf:SetTotal( ::oFacPrvP:OrdKeyCount() )

   ::oFacPrvP:GoTop()
   while !::lBreak .and. !::oFacPrvP:Eof()

      cCta              := oRetFld( ::oFacPrvP:cEntEmp + ::oFacPrvP:cSucEmp + ::oFacPrvP:cDigEmp + ::oFacPrvP:cCtaEmp, ::oCuentasBancarias:oDbf, "cCodBnc", "cCtaBnc" )

      if ::lValidRegister( cCta )

         ::oDbf:Append()

         ::oDbf:cCodCli := ""
         ::oDbf:cCodCta := cCta
         ::oDbf:cTipDoc := "Recibos proveedores"
         ::oDbf:cCodPrv := ::oFacPrvP:cCodPrv
         ::oDbf:cSerFac := ::oFacPrvP:cSerFac
         ::oDbf:nNumFac := ::oFacPrvP:nNumFac
         ::oDbf:cSufFac := ::oFacPrvP:cSufFac
         ::oDbf:dEmiRec := ::oFacPrvP:dPreCob
         ::oDbf:dCobRec := ::oFacPrvP:dEntrada
         ::oDbf:cEntEmp := ::oFacPrvP:cEntEmp
         ::oDbf:cSucEmp := ::oFacPrvP:cSucEmp
         ::oDbf:cDigEmp := ::oFacPrvP:cDigEmp
         ::oDbf:cCtaEmp := ::oFacPrvP:cCtaEmp
         ::oDbf:nTotImp := - ::oFacPrvP:nImporte

         ::oDbf:Save()

      end if

      ::oFacPrvP:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oFacPrvP:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacPrvP:cFile ) )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CalculaSaldo() CLASS TFastCuentasBancarias

   local nSaldo         := 0
   local cCuenta        := ""

   ::oMtrInf:cText      := "Calcula saldo"
   ::oMtrInf:SetTotal( ::oDbf:OrdKeyCount() )

   ::oDbf:GoTop()
   while !::lBreak .and. !::oDbf:Eof()

      if cCuenta != ::oDbf:cCodCta
         cCuenta        := ::oDbf:cCodCta
         nSaldo         := oRetFld( cCuenta, ::oCuentasBancarias:oDbf, "nSalIni", "cCodBnc" )
      end if

      ::oDbf:FieldPutByName( "nSalImp", ::oDbf:nTotImp + nSaldo )

      nSaldo            := ::oDbf:nSalImp

      ::oDbf:Skip()

      ::oMtrInf:AutoInc()

   end while

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD StartDialog() CLASS TFastCuentasBancarias

   ::CreateTreeImageList()

   ::BuildTree( ::oTreeReporting, .f. )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD BuildTree( oTree, lLoadFile ) CLASS TFastCuentasBancarias

   local aReports

   DEFAULT oTree     := ::oTreeReporting
   DEFAULT lLoadFile := .t.

   aReports          := {  {  "Title" => "Informe de cuentas bancarias", "Image" => 17, "Type" => "Informe de cuentas bancarias", "Directory" => "Cuentas bancarias", "File" => "Informe.fr3"  } }

   ::BuildNode( aReports, oTree, lLoadFile )

   oTree:ExpandAll()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD DataReport( oFr ) CLASS TFastCuentasBancarias

   ::oFastReport:SetWorkArea(       "Informe", ::oDbf:nArea )
   ::oFastReport:SetFieldAliases(   "Informe", cObjectsToReport( ::oDbf ) )

   ::oFastReport:SetWorkArea(       "Empresa", ::oDbfEmp:nArea )
   ::oFastReport:SetFieldAliases(   "Empresa", cItemsToReport( aItmEmp() ) )

   ::oFastReport:SetWorkArea(       "Cuentas bancarias", ::oCuentasBancarias:oDbf:nArea )
   ::oFastReport:SetFieldAliases(   "Cuentas bancarias", cObjectsToReport( ::oCuentasBancarias:oDbf ) )

   ::oFastReport:SetWorkArea(       "Clientes", ::oDbfCli:nArea )
   ::oFastReport:SetFieldAliases(   "Clientes", cItemsToReport( aItmCli() ) )

   ::oFastReport:SetWorkArea(       "Proveedores", ::oDbfPrv:nArea )
   ::oFastReport:SetFieldAliases(   "Proveedores", cItemsToReport( aItmPrv() ) )

   ::oFastReport:SetWorkArea(       "Recibos de clientes", ::oFacCliP:nArea )
   ::oFastReport:SetFieldAliases(   "Recibos de clientes", cItemsToReport( aItmRecCli() ) )

   ::oFastReport:SetWorkArea(       "Recibos de proveedores", ::oFacPrvP:nArea )
   ::oFastReport:SetFieldAliases(   "Recibos de proveedores", cItemsToReport( aItmRecPrv() ) )

   ::oFastReport:SetMasterDetail(   "Informe", "Empresa",               {|| cCodEmp() } )
   ::oFastReport:SetMasterDetail(   "Informe", "Cuentas bancarias",     {|| ::oDbf:cCodCta } )
   ::oFastReport:SetMasterDetail(   "Informe", "Clientes",              {|| ::oDbf:cCodCli } )
   ::oFastReport:SetMasterDetail(   "Informe", "Proveedores",           {|| ::oDbf:cCodPrv } )
   ::oFastReport:SetMasterDetail(   "Informe", "Recibos de clientes",   {|| ::oDbf:cSerFac + Str( ::oDbf:nNumFac, 9 ) + ::oDbf:cSufFac } )
   ::oFastReport:SetMasterDetail(   "Informe", "Recibos de proveedores",{|| ::oDbf:cSerFac + Str( ::oDbf:nNumFac, 9 ) + ::oDbf:cSufFac } )

   ::oFastReport:SetResyncPair(     "Informe", "Empresa" )
   ::oFastReport:SetResyncPair(     "Informe", "Cuentas bancarias" )
   ::oFastReport:SetResyncPair(     "Informe", "Cliente" )
   ::oFastReport:SetResyncPair(     "Informe", "Proveedores" )
   ::oFastReport:SetResyncPair(     "Informe", "Recibos de clientes" )
   ::oFastReport:SetResyncPair(     "Informe", "Recibos de proveedores" )

   ::AddVariable()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD TreeReportingChanged() CLASS TFastCuentasBancarias

   if ::oTreeReporting:GetSelText() == "Listado"
      ::lHideFecha()
   else
      ::lShowFecha()
   end if

Return ( Self )

//---------------------------------------------------------------------------//

Function isBancos()

   local oError
   local oBlock

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   with object ( TBancos():Create() )

      :oDbf       := :DefineFiles()

      if !lExistTable( :oDbf:cFile )
         :oDbf:Create()
         :oDbf:Activate( .f., .f. )
         :oDbf:IdxFCheck()
      endif

      :End()

   end with

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible al comprobar bancos" )

   END SEQUENCE

   ErrorBlock( oBlock )

return nil

//---------------------------------------------------------------------------//

