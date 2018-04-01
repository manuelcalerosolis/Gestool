#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "Report.ch"
#include "XBrowse.ch"

#define _CCODFAC              1
#define _CNOMFAC              2
#define _DFECINI              3
#define _DFECFIN              4
#define _CDIASEL              5
#define _CMESSEL              6
#define _LDIASEL              7
#define _LUSECLI              8
#define _CDTOESP              9
#define _NDTOESP              10
#define _CDPP                 11
#define _NDPP                 12
#define _CDTOUNO              13
#define _NDTOUNO              14
#define _CDTODOS              15
#define _NDTODOS              16
#define _NIVAMAN              17
#define _NMANOBR              18
#define _CMANOBR              19
#define _NDIAFACT             20
#define _NTIPDOC              21
#define _CSERFACT             22
#define _CCODPAGO             23

#define __NBRTIVA1__          ::aTotIva[ 1, 1 ]
#define __NBASIVA1__          ::aTotIva[ 1, 2 ]
#define __NPCTIVA1__          ::aTotIva[ 1, 3 ]
#define __NIMPIVA1__          ::aTotIva[ 1, 4 ]
#define __NBRTIVA2__          ::aTotIva[ 2, 1 ]
#define __NBASIVA2__          ::aTotIva[ 2, 2 ]
#define __NPCTIVA2__          ::aTotIva[ 2, 3 ]
#define __NIMPIVA2__          ::aTotIva[ 2, 4 ]
#define __NBRTIVA3__          ::aTotIva[ 3, 1 ]
#define __NBASIVA3__          ::aTotIva[ 3, 2 ]
#define __NPCTIVA3__          ::aTotIva[ 3, 3 ]
#define __NIMPIVA3__          ::aTotIva[ 3, 4 ]

//---------------------------------------------------------------------------//

Function StartTFacAutomatica()

   local oTFacAutomatica

   oTFacAutomatica   := TFacAutomatica():New( cPatEmp(), oWnd(), "plantillas_automaticas" )

   if !Empty( oTFacAutomatica )
      oTFacAutomatica:Activate()
   end if

Return nil

//----------------------------------------------------------------------------//

CLASS TFacAutomatica FROM TMasDet

   DATA  oDetFacAutomatica
   DATA  oHisFacAutomatica

   DATA  oDbfIva
   DATA  oDbfFPago
   DATA  oDbfAge

   DATA  oGrpFacturasAutomaticas

   DATA  aTotIva

   DATA  oGetBrt
   DATA  oGetNet
   DATA  oGetIva
   DATA  oGetTotal

   DATA  nTotBrt
   DATA  nTotNet
   DATA  nTotIva
   DATA  nTotFac

   DATA  oBrwIva
   DATA  oBrwLineas
   DATA  oBrwHistorial

   DATA  oFont

   DATA  oBtnKit

   DATA  oDlg
   DATA  aGet

   METHOD New( cPath, oWndParent, oMenuItem )
   METHOD Create( cPath, oWndParent )

   METHOD Activate()

   METHOD OpenFiles( lExclusive )
   METHOD OpenService( lExclusive )

   METHOD CloseFiles()
   METHOD CloseService()

   METHOD DefineFiles()

   METHOD Resource( nMode )
      METHOD NextResource( nMode )
      METHOD PriorResource( nMode )
      METHOD StartResource()
      METHOD SaveResource()

   METHOD nCalculoTotal()

   METHOD ShowKit( lSet )

   METHOD ExternalEdit( cCodFac )

   METHOD RunPlantillaAutomatica( cCodigoPlantilla )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cPath, oWndParent, oMenuItem ) CLASS TFacAutomatica

   DEFAULT cPath              := cPatEmp()
   DEFAULT oWndParent         := GetWndFrame()

   if oMenuItem != nil .and. ::nLevel == nil
      ::nLevel                := Auth():Level( oMenuItem )
   else
      ::nLevel                := 0
   end if

   if nAnd( ::nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      return nil
   end if

   ::cPath                    := cPath
   ::oWndParent               := oWndParent

   ::bFirstKey                := {|| ::oDbf:cCodFac }

   ::oDetFacAutomatica        := TDetFacAutomatica():New( cPath, cDriver(), Self )
   ::AddDetail( ::oDetFacAutomatica )

   ::oHisFacAutomatica        := THisFacAutomatica():New( cPath, cDriver(), Self )
   ::AddDetail( ::oHisFacAutomatica )

   ::oGrpFacturasAutomaticas  := TGrpFacturasAutomaticas():Create( cPatEmp() )

   ::aTotIva                  := { { 0,0,nil,0 }, { 0,0,nil,0 }, { 0,0,nil,0 } }

   ::nTotBrt                  := 0
   ::nTotNet                  := 0
   ::nTotIva                  := 0
   ::nTotFac                  := 0

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Create( cPath, oWndParent ) CLASS TFacAutomatica

   DEFAULT cPath              := cPatEmp()
   DEFAULT oWndParent         := GetWndFrame()

   ::cPath                    := cPath
   ::oWndParent               := oWndParent

   ::oDetFacAutomatica        := TDetFacAutomatica():New( cPath, cDriver(), Self )
   ::AddDetail( ::oDetFacAutomatica )

   ::oHisFacAutomatica        := THisFacAutomatica():New( cPath, cDriver(), Self )
   ::AddDetail( ::oHisFacAutomatica )

   ::oGrpFacturasAutomaticas  := TGrpFacturasAutomaticas():Create( cPatEmp() )

   ::bFirstKey                := {|| ::oDbf:cCodFac }

   ::aTotIva                  := { { 0,0,nil,0 }, { 0,0,nil,0 }, { 0,0,nil,0 } }

   ::nTotBrt                  := 0
   ::nTotNet                  := 0
   ::nTotIva                  := 0
   ::nTotFac                  := 0

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Activate() CLASS TFacAutomatica

   local oGen

   if ::oWndParent != nil
      ::oWndParent:CloseAll()
   end if

   if !::OpenFiles()
      return nil
   end if

   DEFINE SHELL ::oWndBrw FROM 2, 10 TO 18, 70 ;
      XBROWSE ;
      TITLE    "Plantillas de ventas automáticas" ;
      PROMPT   "Código",;
               "Nombre",;
               "Grupo";
      MRU      "gc_document_text_gear_16";
      BITMAP   clrTopArchivos ;
      ALIAS    ( ::oDbf ) ;
      APPEND   ::Append() ;
      EDIT     ::Edit() ;
      DELETE   ::Del() ;
      DUPLICAT ::Dup() ;
      OF       ::oWndParent

      // Columnas ---------------------------------------------------------------

      with object ( ::oWndBrw:AddXCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodFac"
         :bEditValue       := {|| ::oDbf:FieldGetByName( "cCodFac" ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | ::oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( ::oWndBrw:AddXCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomFac"
         :bEditValue       := {|| ::oDbf:FieldGetByName( "cNomFac" ) }
         :nWidth           := 500
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | ::oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( ::oWndBrw:AddXCol() )
         :cHeader          := "Grupo"
         :bEditValue       := {|| ::oDbf:FieldGetByName( "cCodGrp" ) }
         :nWidth           := 80
         :cSortOrder       := "cCodGrp"
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | ::oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( ::oWndBrw:AddXCol() )
         :cHeader          := "Inicio"
         :bEditValue       := {|| Dtoc( ::oDbf:FieldGetByName( "dFecIni" ) ) }
         :nWidth           := 80
      end with

      with object ( ::oWndBrw:AddXCol() )
         :cHeader          := "Fin"
         :bEditValue       := {|| Dtoc( ::oDbf:FieldGetByName( "dFecFin" ) ) }
         :nWidth           := 80
      end with

      with object ( ::oWndBrw:AddXCol() )
         :cHeader          := "Importe"
         :bEditValue       := {|| Trans( ::nCalculoTotal( .t. ), ::cPorDiv ) }
         :nWidth           := 85
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      ::oWndBrw:CreateXFromCode()

   DEFINE BTNSHELL RESOURCE "BUS" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::oWndBrw:SearchSetFocus() ) ;
      TOOLTIP  "(B)uscar" ;
      HOTKEY   "B";

      ::oWndBrw:AddSeaBar()

   DEFINE BTNSHELL RESOURCE "NEW" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::oWndBrw:RecAdd() );
      ON DROP  ( ::oWndBrw:RecAdd() );
      TOOLTIP  "(A)ñadir";
      BEGIN GROUP ;
      HOTKEY   "A" ;
      LEVEL    ACC_APPD

   DEFINE BTNSHELL RESOURCE "DUP" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::oWndBrw:RecDup() );
      TOOLTIP  "(D)uplicar";
      HOTKEY   "D";
      LEVEL    ACC_APPD

   DEFINE BTNSHELL RESOURCE "EDIT" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::oWndBrw:RecEdit() );
      TOOLTIP  "(M)odificar";
      HOTKEY   "M" ;
      LEVEL    ACC_EDIT

   DEFINE BTNSHELL RESOURCE "ZOOM" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::Zoom() );
      TOOLTIP  "(Z)oom";
      HOTKEY   "Z" ;
      LEVEL    ACC_ZOOM

   DEFINE BTNSHELL RESOURCE "DEL" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::oWndBrw:RecDel() );
      TOOLTIP  "(E)liminar";
      HOTKEY   "E";
      LEVEL    ACC_DELE

   DEFINE BTNSHELL oGen RESOURCE "GC_FLASH_" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::RunPlantillaAutomatica( ::oDbf:cCodFac ) ) ;
      TOOLTIP  "(G)enerar ahora";
      HOTKEY   "G"

      DEFINE BTNSHELL RESOURCE "GC_FLASH_" OF ::oWndBrw ;
         ACTION   ( ::RunPlantillaAutomatica() );
         TOOLTIP  "Generar todas ahora" ;
         FROM     oGen

   DEFINE BTNSHELL RESOURCE "END" GROUP OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::oWndBrw:end() ) ;
      TOOLTIP  "(S)alir" ;
      HOTKEY   "S"

   if ::cHtmlHelp != nil
      ::oWndBrw:cHtmlHelp  := ::cHtmlHelp
   end if

   ACTIVATE WINDOW ::oWndBrw VALID ( ::CloseFiles() )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive ) CLASS TFacAutomatica

   local lOpen          := .t.
   local oError
   local oBlock

   DEFAULT  lExclusive  := .f.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      DATABASE NEW ::oDbfFPago   PATH ( cPatEmp() )   FILE "FPAGO.DBF"     VIA ( cDriver() ) SHARED INDEX "FPAGO.CDX"

      DATABASE NEW ::oDbfAge     PATH ( cPatEmp() )   FILE "AGENTES.DBF"   VIA ( cDriver() ) SHARED INDEX "AGENTES.CDX"

      DATABASE NEW ::oDbfIva     PATH ( cPatDat() )   FILE "TIVA.DBF"      VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

      ::lLoadDivisa()

      if Empty( ::oDbf )
         ::DefineFiles()
      end if

      ::oDbf:Activate( .f., !lExclusive )

      if !Empty( ::oGrpFacturasAutomaticas )
         ::oGrpFacturasAutomaticas:OpenFiles()
      end if 

      ::OpenDetails()

      ::oFont                    := TFont():New( "Arial", 8, 26, .F., .T. )

   RECOVER USING oError

      lOpen                      := .f.

      msgStop( "Imposible abrir las bases de datos de facturas automáticas." + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpen
      ::CloseFiles()
   end if

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD OpenService( lExclusive, cPath ) CLASS TFacAutomatica

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lExclusive   := .f.

   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !lExclusive )

   RECOVER USING oError

      lOpen             := .f.

      ::CloseService()

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseService() CLASS TFacAutomatica

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:End()
   end if

   ::oDbf   := nil

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TFacAutomatica

   if ::oDbfFPago != nil .and. ::oDbfFPago:Used()
      ::oDbfFPago:End()
   end if

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:End()
   end if

   if ::oDbfIva != nil .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if

   if ::oDbfAge != nil .and. ::oDbfAge:Used()
      ::oDbfAge:End()
   end if

   if ::oGrpFacturasAutomaticas != nil
      ::oGrpFacturasAutomaticas:End()
   end if

   if ::oFont != nil
      ::oFont:End()
   end if

   ::CloseDetails()

   ::oDbf                     := nil
   ::oDbfIva                  := nil
   ::oDbfFPago                := nil

   ::oGrpFacturasAutomaticas  := nil

   ::oFont                    := nil

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver ) CLASS TFacAutomatica

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE DATABASE ::oDbf FILE "FacAutT.DBF" CLASS "FacAutT" ALIAS "FacAutT" PATH ( cPath ) VIA ( cDriver ) COMMENT "Plantilla venta automática"

      FIELD NAME "cCodFac"   TYPE "C" LEN  03 DEC 0 COMMENT "Código"                                                 COLSIZE  80       OF ::oDbf
      FIELD NAME "cNomFac"   TYPE "C" LEN  50 DEC 0 COMMENT "Nombre"                                                 COLSIZE 200       OF ::oDbf
      FIELD NAME "dFecIni"   TYPE "D" LEN  08 DEC 0 COMMENT "Fecha inicio"                                           HIDE              OF ::oDbf
      FIELD NAME "dFecFin"   TYPE "D" LEN  08 DEC 0 COMMENT "Fecha fin"                                              HIDE              OF ::oDbf
      FIELD NAME "cDiaSel"   TYPE "C" LEN  30 DEC 0 COMMENT ""                                                       HIDE              OF ::oDbf
      FIELD NAME "cMesSel"   TYPE "C" LEN  50 DEC 0 COMMENT ""                                                       HIDE              OF ::oDbf
      FIELD NAME "lDiaSel"   TYPE "L" LEN  01 DEC 0 COMMENT "Lógico para plantilla de diario"                        HIDE              OF ::oDbf
      FIELD NAME "lUseCli"   TYPE "L" LEN  01 DEC 0 COMMENT "Lógico para usar descuentos del cliente"                HIDE              OF ::oDbf
      FIELD NAME "cDtoEsp"   TYPE "C" LEN  50 DEC 0 COMMENT "Descripción de porcentaje de descuento especial"        HIDE              OF ::oDbf
      FIELD NAME "nDtoEsp"   TYPE "N" LEN  06 DEC 2 COMMENT "Porcentaje de descuento especial"                       HIDE              OF ::oDbf
      FIELD NAME "cDpp"      TYPE "C" LEN  50 DEC 0 COMMENT "Descripción de porcentaje de descuento por pronto pago" HIDE              OF ::oDbf
      FIELD NAME "nDpp"      TYPE "N" LEN  06 DEC 2 COMMENT "Porcentaje de descuento por pronto pago"                HIDE              OF ::oDbf
      FIELD NAME "cDtoUno"   TYPE "C" LEN  50 DEC 0 COMMENT "Descripción de porcentaje de descuento personalizado"   HIDE              OF ::oDbf
      FIELD NAME "nDtoUno"   TYPE "N" LEN  06 DEC 2 COMMENT "Porcentaje de descuento por descuento personalizado"    HIDE              OF ::oDbf
      FIELD NAME "cDtoDos"   TYPE "C" LEN  50 DEC 0 COMMENT "Descripción de porcentaje de descuento personalizado"   HIDE              OF ::oDbf
      FIELD NAME "nDtoDos"   TYPE "N" LEN  06 DEC 2 COMMENT "Porcentaje de descuento por descuento personalizado"    HIDE              OF ::oDbf
      FIELD NAME "nIvaMan"   TYPE "N" LEN  06 DEC 2 COMMENT "Porcentaje " + cImp() + " mano de obra"                 HIDE              OF ::oDbf
      FIELD NAME "nManObr"   TYPE "N" LEN  16 DEC 6 COMMENT "Mano de obra"                                           HIDE              OF ::oDbf
      FIELD NAME "cManObr"   TYPE "C" LEN 250 DEC 0 COMMENT "Descripción mano de obra"                               HIDE              OF ::oDbf
      FIELD NAME "nDiaFact"  TYPE "N" LEN  02 DEC 0 COMMENT "Día de facturación"                                     HIDE              OF ::oDbf
      FIELD NAME "nTipDoc"   TYPE "N" LEN  01 DEC 0 COMMENT "Tipo de documento"                                      HIDE              OF ::oDbf
      FIELD NAME "cSerFact"  TYPE "C" LEN  01 DEC 0 COMMENT "Serie de facturación"                                   HIDE              OF ::oDbf
      FIELD NAME "cCodPago"  TYPE "C" LEN  02 DEC 0 COMMENT "Foma de pago"                                           HIDE              OF ::oDbf
      FIELD NAME "cCodGrp"   TYPE "C" LEN  04 DEC 0 COMMENT "Código de grupo"                                        HIDE              OF ::oDbf
      FIELD NAME "nPerSel"   TYPE "N" LEN   3 DEC 0 COMMENT ""                                                       HIDE              OF ::oDbf
      FIELD NAME "cPerSel"   TYPE "C" LEN  20 DEC 0 COMMENT ""                                                       HIDE              OF ::oDbf
      FIELD NAME "dNexFac"   TYPE "D" LEN  08 DEC 0 COMMENT "Fecha de próxima factura"                               HIDE              OF ::oDbf
      FIELD NAME "mGrpSel"   TYPE "M" LEN  10 DEC 0 COMMENT ""                                                       HIDE              OF ::oDbf

      INDEX TO "FacAutT.Cdx" TAG "cCodFac" ON "Field->cCodFac" COMMENT "Código"  NODELETED   OF ::oDbf
      INDEX TO "FacAutT.Cdx" TAG "cNomFac" ON "Field->cNomFac" COMMENT "Nombre"  NODELETED   OF ::oDbf
      INDEX TO "FacAutT.Cdx" TAG "cCodGrp" ON "Field->cCodGrp" COMMENT "Grupo"   NODELETED   OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//---------------------------------------------------------------------------//

METHOD Resource( nMode ) CLASS TFacAutomatica

   local oFld
   local aMes           := Array( 12 )
   local oSayTot
   local oBmpGeneral
   local oBmpFolder

   ::aGet               := Array( ::oDbf:FieldCount )

   if nMode == APPD_MODE
      ::oDbf:cDtoEsp    := "General"
      ::oDbf:nDtoEsp    := 0
      ::oDbf:cDpp       := "Pronto pago"
      ::oDbf:nDpp       := 0
      ::oDbf:cDtoUno    := Space( 50 )
      ::oDbf:nDtoUno    := 0
      ::oDbf:cDtoDos    := Space( 50 )
      ::oDbf:nDtoDos    := 0
      ::oDbf:nIvaMan    := 0
      ::oDbf:nManObr    := 0
      ::oDbf:cManObr    := getConfigTraslation( "Gastos" )
      ::oDbf:nDiaFact   := 1
      ::oDbf:nTipDoc    := 2
      ::oDbf:dFecIni    := GetSysDate()
      ::oDbf:dNexFac    := GetSysDate()
   end if

   DEFINE DIALOG ::oDlg RESOURCE "FacAutomatica" TITLE LblTitle( nMode ) + "plantilla venta automática"

      /*
		Define de los Folders
		------------------------------------------------------------------------
		*/

      REDEFINE FOLDER oFld ;
         ID       400 ;
         OF       ::oDlg ;
         PROMPT   "&Documento",;
                  "&Historico" ;
         DIALOGS  "FACAUT_1", ;
                  "FACAUT_2"

      REDEFINE BITMAP oBmpGeneral ;
        ID       990 ;
        RESOURCE "gc_document_text_gear_48" ;
        TRANSPARENT ;
        OF       oFld:aDialogs[1]

      /*
      Descripciones
      -------------------------------------------------------------------------
      */

      REDEFINE GET ::aGet[ _CCODFAC ] VAR ::oDbf:cCodFac ;
         ID       110 ;
         VALID    NotValid( ::aGet[ _CCODFAC ], ::oDbf:cAlias, .t., "0" ) ;
         WHEN     ( nMode == APPD_MODE ) ;
         OF       oFld:aDialogs[1] ;

      REDEFINE GET ::aGet[ _CNOMFAC ] VAR ::oDbf:cNomFac ;
         ID       120 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1] ;

      /*
      Fechas de vigencia
      -------------------------------------------------------------------------
      */

      REDEFINE GET ::aGet[ _DFECINI ] VAR ::oDbf:dFecIni ;
			ID 		130 ;
			SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1] ;

      REDEFINE GET ::aGet[ _DFECFIN ] VAR ::oDbf:dFecFin ;
         ID       140 ;
			SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1] ;

      REDEFINE GET ::aGet[ ::oDbf:FieldPos( "nPerSel" ) ] VAR ::oDbf:nPerSel ;
         ID       160 ;
         PICTURE  "999" ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1] ;

      REDEFINE COMBOBOX ::aGet[ ::oDbf:FieldPos( "cPerSel") ] VAR ::oDbf:cPerSel ;
         ID       161 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ITEMS    ( { "Día", "Semana", "Mes", "Año" } ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET ::aGet[ ::oDbf:FieldPos( "dNexFac" ) ] VAR ::oDbf:dNexFac ;
         ID       410 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1] ;

      REDEFINE GET ::aGet[ _CSERFACT ] VAR ::oDbf:cSerFact ;
         ID       440 ;
         SPINNER ;
         ON UP    ( UpSerie( ::aGet[ _CSERFACT ] ) );
         ON DOWN  ( DwSerie( ::aGet[ _CSERFACT ] ) );
         PICTURE  "@!" ;
         WHEN     ( nMode != ZOOM_MODE );
         VALID    ( Empty( ::oDbf:cSerFact ) .or. ( ::oDbf:cSerFact >= "A" .and. ::oDbf:cSerFact <= "Z" ) );
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET ::aGet[ ::oDbf:FieldPos( "cCodGrp" ) ] VAR ::oDbf:cCodGrp ;
         ID       150 ;
         IDTEXT   151 ;
         BITMAP   "LUPA" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 1 ]

         ::aGet[ ::oDbf:FieldPos( "cCodGrp" ) ]:bValid   := {|| ::oGrpFacturasAutomaticas:Existe( ::aGet[ ::oDbf:FieldPos( "cCodGrp" ) ], ::aGet[ ::oDbf:FieldPos( "cCodGrp" ) ]:oHelpText, "cNomGrp", .t., .t., "0" ) }
         ::aGet[ ::oDbf:FieldPos( "cCodGrp" ) ]:bHelp    := {|| ::oGrpFacturasAutomaticas:Buscar( ::aGet[ ::oDbf:FieldPos( "cCodGrp" ) ] ) }

      REDEFINE GET ::aGet[ _CCODPAGO ] VAR ::oDbf:cCodPago ;
         ID       450 ;
         IDTEXT   451 ;
         BITMAP   "LUPA" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 1 ]

         ::aGet[ _CCODPAGO ]:bValid   := {|| cFPago( ::aGet[ _CCODPAGO ], ::oDbfFPago:cAlias, ::aGet[ _CCODPAGO ]:oHelpText ) }
         ::aGet[ _CCODPAGO ]:bHelp    := {|| BrwFPago( ::aGet[ _CCODPAGO ], ::aGet[ _CCODPAGO ]:oHelpText ) }

      REDEFINE CHECKBOX ::aGet[ _LUSECLI ] VAR ::oDbf:lUseCli ;
         ID       170 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE RADIO ::aGet[ _NTIPDOC ] VAR ::oDbf:nTipDoc ;
         ID       420, 430 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      /*
      Grupos-------------------------------------------------------------------
      */

      ::oGrpFacturasAutomaticas:RedefineBrowse( 500, oFld:aDialogs[ 1 ] )      

      /*
      Lineas
      -------------------------------------------------------------------------
      */

      REDEFINE BUTTON ;
         ID       510 ;
         OF       oFld:aDialogs[1] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::oDetFacAutomatica:AppendDet( ::oBrwLineas ), ::nCalculoTotal() )

      REDEFINE BUTTON ;
         ID       520 ;
         OF       oFld:aDialogs[1] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::oDetFacAutomatica:Edit( ::oBrwLineas ), ::nCalculoTotal() )

      REDEFINE BUTTON ;
         ID       530 ;
         OF       oFld:aDialogs[1] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::oDetFacAutomatica:Del( ::oBrwLineas ), ::nCalculoTotal()  )

      REDEFINE BUTTON ;
         ID       540 ;
         OF       oFld:aDialogs[1] ;
         ACTION   ( ::oDetFacAutomatica:Zoom( ::oBrwLineas ) )

      REDEFINE BUTTON ;
         ID       550 ;
         OF       oFld:aDialogs[1] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( DbSwapUp( ::oDetFacAutomatica:oDbfVir:cAlias, ::oBrwLineas ) )

      REDEFINE BUTTON ;
         ID       560 ;
         OF       oFld:aDialogs[1] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( DbSwapDown( ::oDetFacAutomatica:oDbfVir:cAlias, ::oBrwLineas ) )

      REDEFINE BUTTON ::oBtnKit ;
         ID       570 ;
         OF       oFld:aDialogs[1] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::ShowKit( .t. ) )

      ::oBrwLineas                 := IXBrowse():New( oFld:aDialogs[1] )

      ::oBrwLineas:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrwLineas:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }
      ::oBrwLineas:nRowHeight      := 18
      ::oBrwLineas:nMarqueeStyle   := 6
      ::oBrwLineas:cName           := "Lineas de plantilla venta automáticas"

      ::oDetFacAutomatica:oDbfVir:SetBrowse( ::oBrwLineas )

      ::oBrwLineas:CreateFromResource( 200 )

      with object ( ::oBrwLineas:AddCol() )
         :cHeader             := "Número"
         :bEditValue          := {|| ::oDetFacAutomatica:oDbfVir:FieldGetByName( "nNumLin" ) }
         :cEditPicture        := "9999"
         :nWidth              := 65
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( ::oBrwLineas:AddCol() )
         :cHeader             := "Código"
         :bStrData            := {|| ::oDetFacAutomatica:oDbfVir:FieldGetByName( "cCodArt" ) }
         :nWidth              := 80
      end with

      with object ( ::oBrwLineas:AddCol() )
         :cHeader             := "Descripción"
         :bEditValue          := {|| ::oDetFacAutomatica:Descrip() }
         :nWidth              := 470
      end with

      with object ( ::oBrwLineas:AddCol() )
         :cHeader             := "Prop. 1"
         :bEditValue          := {|| ::oDetFacAutomatica:oDbfVir:FieldGetByName( "cValPr1" ) }
         :nWidth              := 40
         :lHide               := .t.
      end with

      with object ( ::oBrwLineas:AddCol() )
         :cHeader             := "Prop. 2"
         :bEditValue          := {|| ::oDetFacAutomatica:oDbfVir:FieldGetByName( "cValPr2" ) }
         :nWidth              := 40
         :lHide               := .t.
      end with

      with object ( ::oBrwLineas:AddCol() )
         :cHeader             := cNombreCajas()
         :bEditValue          := {|| ::oDetFacAutomatica:oDbfVir:FieldGetByName( "nCajas" ) }
         :cEditPicture        := MasUnd()
         :nWidth              := 60
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :lHide               := .t.
      end with

      with object ( ::oBrwLineas:AddCol() )
         :cHeader             := cNombreUnidades()
         :bEditValue          := {|| ::oDetFacAutomatica:oDbfVir:FieldGetByName( "nUnidades" ) }
         :cEditPicture        := MasUnd()
         :nWidth              := 60
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :lHide               := .t.
      end with

      with object ( ::oBrwLineas:AddCol() )
         :cHeader             := "Sumar unidades"
         :bStrData            := {|| "" }
         :bOnPostEdit         := {|| .t. }
         :bEditBlock          := {|| ::oDetFacAutomatica:oDbfVir:FieldPutByName( "nUnidades", ::oDetFacAutomatica:oDbfVir:FieldGetByName( "nUnidades" ) + 1 ), ::nCalculoTotal() }
         :nEditType           := 5
         :nWidth              := 20
         :nHeadBmpNo          := 1
         :nBtnBmp             := 1
         :nHeadBmpAlign       := 1
         :AddResource( "gc_navigate_plus_16" )
         :lHide               := .t.
      end with

      with object ( ::oBrwLineas:AddCol() )
         :cHeader             := "Restar unidades"
         :bStrData            := {|| "" }
         :bOnPostEdit         := {|| .t. }
         :bEditBlock          := {|| ::oDetFacAutomatica:oDbfVir:FieldPutByName( "nUnidades", ::oDetFacAutomatica:oDbfVir:FieldGetByName( "nUnidades" ) - 1 ), ::nCalculoTotal() }
         :nEditType           := 5
         :nWidth              := 20
         :nHeadBmpNo          := 1
         :nBtnBmp             := 1
         :nHeadBmpAlign       := 1
         :AddResource( "gc_navigate_minus_16" )
         :lHide               := .t.
      end with

      with object ( ::oBrwLineas:AddCol() )
         :cHeader             := "Total unidades"
         :bEditValue          := {|| ::oDetFacAutomatica:nTotNFacAut( ::oDetFacAutomatica:oDbfVir ) }
         :cEditPicture        := MasUnd()
         :nWidth              := 85
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( ::oBrwLineas:AddCol() )
         :cHeader             := "Precio"
         :bEditValue          := {|| ::oDetFacAutomatica:oDbfVir:FieldGetByName( "nPreUnit" ) }
         :cEditPicture        := ::cPouDiv
         :nWidth              := 80
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( ::oBrwLineas:AddCol() )
         :cHeader             := "Total"
         :bEditValue          := {|| ::oDetFacAutomatica:nTotLFacAut( ::oDetFacAutomatica:oDbfVir ) }
         :cEditPicture        := ::cPorDiv
         :nWidth              := 90
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( ::oBrwLineas:AddCol() )
         :cHeader             := "% " + cImp()
         :bEditValue          := {|| ::oDetFacAutomatica:oDbfVir:FieldGetByName( "nIva" ) }
         :cEditPicture        := "@E 999.99"
         :nWidth              := 40
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :lHide               := .t.
      end with

      if nMode != ZOOM_MODE
         ::oBrwLineas:bLDblClick   := {|| ::oDetFacAutomatica:Edit( ::oBrwLineas ), ::nCalculoTotal() }
      end if

      /*
      Descuentos
      -------------------------------------------------------------------------
      */

      REDEFINE GET ::aGet[ _CDTOESP ] VAR ::oDbf:cDtoEsp ;
         ID       210 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET ::aGet[ _NDTOESP ] VAR ::oDbf:nDtoEsp ;
         ID       220 ;
         PICTURE  "@ER 999.99%" ;
         SPINNER;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

         ::aGet[ _NDTOESP ]:bChange   := {|| ::nCalculoTotal() }

      REDEFINE GET ::aGet[ _CDPP ] VAR ::oDbf:cDpp ;
         ID       230 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET ::aGet[ _NDPP ] VAR ::oDbf:nDpp ;
         ID       240 ;
         PICTURE  "@ER 999.99%" ;
         SPINNER;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

         ::aGet[ _NDPP ]:bChange   := {|| ::nCalculoTotal() }

      REDEFINE GET ::aGet[ _CDTOUNO ] VAR ::oDbf:cDtoUno ;
         ID       250 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET ::aGet[ _NDTOUNO ] VAR ::oDbf:nDtoUno ;
         ID       260 ;
         PICTURE  "@ER 999.99%" ;
         SPINNER;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

         ::aGet[ _NDTOUNO ]:bChange   := {|| ::nCalculoTotal() }

      REDEFINE GET ::aGet[ _CDTODOS ] VAR ::oDbf:cDtoDos ;
         ID       270 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET ::aGet[ _NDTODOS ] VAR ::oDbf:nDtoDos ;
         ID       280 ;
         PICTURE  "@ER 999.99%" ;
         SPINNER;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

         ::aGet[ _NDTODOS ]:bChange   := {|| ::nCalculoTotal() }

      /*
      Browse de impuestoss
      -------------------------------------------------------------------------
      */

      ::oBrwIva                        := IXBrowse():New( oFld:aDialogs[1] )

      ::oBrwIva:bClrSel                := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrwIva:bClrSelFocus           := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oBrwIva:SetArray( ::aTotIva, , , .f. )

      ::oBrwIva:nMarqueeStyle          := 6
      ::oBrwIva:lRecordSelector        := .f.
      ::oBrwIva:lHScroll               := .f.

      ::oBrwIva:CreateFromResource( 290 )

      with object ( ::oBrwIva:AddCol() )
         :cHeader          := "Base"
         :bStrData         := {|| if( ::aTotIva[ ::oBrwIva:nArrayAt, 3 ] != nil, Trans( ::aTotIva[ ::oBrwIva:nArrayAt, 2 ], ::cPorDiv ), "" ) }
         :nWidth           := 200
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( ::oBrwIva:AddCol() )
         :cHeader          := "%" + cImp()
         :bStrData         := {|| if( !IsNil( ::aTotIva[ ::oBrwIva:nArrayAt, 3 ] ), ::aTotIva[ ::oBrwIva:nArrayAt, 3 ], "" ) }
         :bEditValue       := {|| ::aTotIva[ ::oBrwIva:nArrayAt, 3 ] }
         :nWidth           := 85
         :cEditPicture     := "@E 99.99"
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :nFootStrAlign    := 1
         :nEditType        := 1
         :bEditWhen        := {|| !IsNil( ::aTotIva[ ::oBrwIva:nArrayAt, 3 ] ) }
         :bOnPostEdit      := {|o,x| EdtIva( o, x, ::aTotIva[ ::oBrwIva:nArrayAt, 3 ], ::oDetFacAutomatica:oDbfVir:cAlias, ::oDetFacAutomatica:oDbfIva:cAlias, ::oBrwLineas ), ::nCalculoTotal() }
      end with

      with object ( ::oBrwIva:AddCol() )
         :cHeader          := cImp()
         :bStrData         := {|| if( ::aTotIva[ ::oBrwIva:nArrayAt, 3 ] != nil, Trans( ::aTotIva[ ::oBrwIva:nArrayAt, 4 ], ::cPorDiv ), "" ) }
         :nWidth           := 85
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      /*
      Mano de obra
      -------------------------------------------------------------------------
      */

      REDEFINE GET ::aGet[ _CMANOBR ] VAR ::oDbf:cManObr ;
         ID       300 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET ::aGet[ _NIVAMAN ] VAR ::oDbf:nIvaMan ;
         ID       310 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 99.99" ;
         BITMAP   "LUPA" ;
         OF       oFld:aDialogs[1]

         ::aGet[ _NIVAMAN ]:bValid    := {|| lTiva( ::oDbfIva:cAlias, ::oDbf:nIvaMan ), ::nCalculoTotal(), .t. }
         ::aGet[ _NIVAMAN ]:bHelp     := {|| BrwIva( ::aGet[ _NIVAMAN ], ::oDbfIva:cAlias, , .t. ) }
         ::aGet[ _NIVAMAN ]:bChange   := {|| ::nCalculoTotal() }

      REDEFINE GET ::aGet[ _NMANOBR ] VAR ::oDbf:nManObr ;
         ID       320 ;
         PICTURE  ::cPorDiv ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

         ::aGet[ _NMANOBR ]:bChange  := {|| ::nCalculoTotal() }

      /*
      Totales
      -------------------------------------------------------------------------
      */

      REDEFINE SAY ::oGetBrt VAR ::nTotBrt ;
         ID       330 ;
         PICTURE  ::cPorDiv ;
         OF       oFld:aDialogs[1]

      REDEFINE SAY ::oGetNet VAR ::nTotNet ;
         ID       340 ;
         PICTURE  ::cPorDiv ;
         OF       oFld:aDialogs[1]

      REDEFINE SAY ::oGetIva VAR ::nTotIva ;
         ID       350 ;
         PICTURE  ::cPorDiv ;
         OF       oFld:aDialogs[1]

      REDEFINE SAY oSayTot VAR "Total" ;
         ID       380 ;
         FONT     ::oFont ;
         OF       oFld:aDialogs[1]

      REDEFINE SAY ::oGetTotal VAR ::nTotFac ;
         ID       390 ;
         FONT     ::oFont ;
         PICTURE  ::cPorDiv ;
         OF       oFld:aDialogs[1]

      /*
      Browse del historico de generaciones-------------------------------------
      */

      REDEFINE BITMAP oBmpFolder ;
        ID       990 ;
        RESOURCE "gc_folders2_48" ;
        TRANSPARENT ;
        OF       oFld:aDialogs[2]

      ::oBrwHistorial                  := IXBrowse():New( oFld:aDialogs[ 2 ] )

      ::oBrwHistorial:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrwHistorial:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }
      ::oBrwHistorial:nMarqueeStyle    := 5
      ::oBrwHistorial:cName            := "Historico de plantilla venta automáticas"
      ::oBrwHistorial:lHScroll         := .f.

      ::oHisFacAutomatica:oDbfVir:SetBrowse( ::oBrwHistorial )

      ::oBrwHistorial:CreateFromResource( 200 )

      ::oBrwHistorial:bLDblClick       := {|| if ( File( AllTrim( ::oHisFacAutomatica:oDbfVir:FieldGetByName( "cFichero" ) ) ),;
                                          WinExec( "notepad.exe " + AllTrim( ::oHisFacAutomatica:oDbfVir:FieldGetByName( "cFichero" ) ) ),;
                                          msgStop( "El fichero " + AllTrim( ::oHisFacAutomatica:oDbfVir:FieldGetByName( "cFichero" ) ) + " no existe" ) ) }

      with object ( ::oBrwHistorial:AddCol() )
         :cHeader             := "Fecha"
         :bEditValue          := {|| dToc( ::oHisFacAutomatica:oDbfVir:FieldGetByName( "dFecha" ) ) }
         :nWidth              := 115
      end with

      with object ( ::oBrwHistorial:AddCol() )
         :cHeader             := "Hora"
         :bEditValue          := {|| ::oHisFacAutomatica:oDbfVir:FieldGetByName( "cHora" ) }
         :nWidth              := 55
      end with

      with object ( ::oBrwHistorial:AddCol() )
         :cHeader             := "Resultado"
         :bEditValue          := {|| ::oHisFacAutomatica:oDbfVir:FieldGetByName( "cFichero" ) }
         :nWidth              := 710
      end with

      /*
      Botones comunes de la caja de diálogo
      -------------------------------------------------------------------------
      */

      REDEFINE BUTTON ;
         ID       900 ;
         OF       ::oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::PriorResource( nMode ) )

      REDEFINE BUTTON ;
         ID       901 ;
         OF       ::oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::NextResource( nMode ) )

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       ::oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( if( ::SaveResource( nMode, ::aGet ), ::oDlg:End( IDOK ), ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       ::oDlg ;
         ACTION   ( ::oDlg:End() )

      if nMode != ZOOM_MODE
         ::oDlg:AddFastKey( VK_F2,       {|| ::oDetFacAutomatica:AppendDet( ::oBrwLineas ), ::nCalculoTotal() } )
         ::oDlg:AddFastKey( VK_F3,       {|| ::oDetFacAutomatica:Edit( ::oBrwLineas ), ::nCalculoTotal() } )
         ::oDlg:AddFastKey( VK_F4,       {|| ::oDetFacAutomatica:Del( ::oBrwLineas ), ::nCalculoTotal() } )
         ::oDlg:AddFastKey( VK_F5,       {|| if( ::SaveResource( nMode, ::aGet ), ::oDlg:End( IDOK ), ) } )
         ::oDlg:AddFastKey( VK_DELETE,   {|| ::oHisFacAutomatica:oDbfVir:Delete(), ::oBrwHistorial:Refresh() } )
      end if

   ::oDlg:bStart    := {|| ::StartResource( nMode, ::oBrwIva ) }

   ::oDlg:Activate( , , , .t., , , {|| ::oBrwLineas:Load(), ::oBrwHistorial:Load() } )

   oBmpGeneral:End()
   oBmpFolder:End()

   if !Empty( ::oBrwLineas )
      ::oBrwLineas:CloseData()
      ::oBrwLineas:end()
   end if

   if !Empty( ::oBrwHistorial )
      ::oBrwHistorial:CloseData()
      ::oBrwHistorial:end()
   end if

RETURN ( ::oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

METHOD NextResource( nMode )

   if !::SaveResource( nMode )
      Return ( .f. )
   end if

   CursorWait()

   if ::Next()

      aEval( ::aGet, {|o| if( IsObject( o ), o:Refresh(), ) } )

      ::oBrwLineas:Refresh( .t. )
      ::oBrwLineas:GoTop()

      ::oBrwHistorial:Refresh( .t. )
      ::oBrwHistorial:GoTop()

   else

      ::oDlg:End( IDOK )

   end if

   CursorWE()

RETURN ( .t. )

//--------------------------------------------------------------------------//

METHOD PriorResource( nMode )

   if !::SaveResource( nMode )
      Return ( .f. )
   end if

   CursorWait()

   if ::Prior()

      aEval( ::aGet, {|o| if( IsObject( o ), o:Refresh(), ) } )

      ::oBrwLineas:Refresh( .t. )
      ::oBrwLineas:GoTop()

      ::oBrwHistorial:Refresh( .t. )
      ::oBrwHistorial:GoTop()

   else

      ::oDlg:End( IDOK )

   end if

   CursorWE()

RETURN ( .t. )

//--------------------------------------------------------------------------//

METHOD StartResource( nMode ) CLASS TFacAutomatica

   ::oGrpFacturasAutomaticas:LoadBrowse( ::oDbf:mGrpSel )

   ::nCalculoTotal()

   ::ShowKit( .f. )

   ::aGet[ ::oDbf:FieldPos( "cCodPago" ) ]:lValid()

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD SaveResource( nMode ) CLASS TFacAutomatica

   local oItem
   local lSemana  := .f.
   local cSemana  := ""
   local cMes     := ""

   if ( nMode == APPD_MODE .or. nMode == DUPL_MODE )
      if !::aGet[ _CCODFAC ]:lValid()
         return .f.
      end if
   end if

   if Empty( ::oDbf:cNomFac )
      msgStop( "El campo nombre no puede estar vacío." )
      ::aGet[ _CNOMFAC ]:SetFocus()
      return .f.
   end if

   if !Empty( ::oDbf:dFecFin ) .and. ( ::oDbf:dFecFin < ::oDbf:dFecIni )
      msgStop( "La fecha de fin no puede ser menor que la fecha de inicio." )
      ::aGet[ _DFECINI ]:SetFocus()
      return .f.
   end if

   if ::oDetFacAutomatica:oDbfVir:LastRec() == 0
      msgStop( "No puede almacenar un documento sin líneas." )
      return .f.
   end if

   ::oDbf:cDiaSel := cSemana
   ::oDbf:lDiaSel := lSemana

   ::oDbf:mGrpSel := ::oGrpFacturasAutomaticas:BrowseToChar()

   ::oDetFacAutomatica:oDbfVir:KillFilter()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD nCalculoTotal( lExt ) CLASS TFacAutomatica

   local nRec
   local oDbfDet
   local bCondicion
   local lSeek

   DEFAULT lExt      := .f.

   oDbfDet           := if( lExt, ::oDetFacAutomatica:oDbf, ::oDetFacAutomatica:oDbfVir )

   nRec              := oDbfDet:Recno()

   if lExt
      bCondicion     := {|| ::oDbf:cCodFac == oDbfDet:cCodFac .and. !oDbfDet:Eof() }
      lSeek          := oDbfDet:Seek( ::oDbf:cCodFac )
   else
      bCondicion     := {|| !oDbfDet:Eof() }
      lSeek          := oDbfDet:GoTop()
   end if

   ::aTotIva         := { { 0,0,nil,0 }, { 0,0,nil,0 }, { 0,0,nil,0 } }

   while Eval( bCondicion )

      if ( !oDbfDet:lKitArt .and. !oDbfDet:lKitChl )  .or. ;
         ( oDbfDet:lKitArt .and. oDbfDet:lKitPrc )    .or. ;
         ( oDbfDet:lKitChl .and. oDbfDet:lKitPrc )

         do case
            case __NPCTIVA1__ == nil .OR. __NPCTIVA1__ == oDbfDet:nIva

               __NPCTIVA1__   := oDbfDet:nIva
               __NBRTIVA1__   += ::oDetFacAutomatica:nTotLFacAut( oDbfDet )

            case __NPCTIVA2__ == nil .OR. __NPCTIVA2__ == oDbfDet:nIva

               __NPCTIVA2__   := oDbfDet:nIva
               __NBRTIVA2__   += ::oDetFacAutomatica:nTotLFacAut( oDbfDet )

            case __NPCTIVA3__ == nil .OR. __NPCTIVA3__ == oDbfDet:nIva

               __NPCTIVA3__   := oDbfDet:nIva
               __NBRTIVA3__   += ::oDetFacAutomatica:nTotLFacAut( oDbfDet )

         end case

      end if

      oDbfDet:Skip()

   end while

   oDbfDet:GoTo( nRec )

   /*
   Ordenamos los impuestosS de menor a mayor----------------------------------------
   */

   ::aTotIva         := aSort( ::aTotIva,,, {|x,y| if( x[3] != nil, x[3], -1 ) > if( y[3] != nil, y[3], -1 )  } )

   __NBASIVA1__         := Round( __NBRTIVA1__, ::nRouDiv )
   __NBASIVA2__         := Round( __NBRTIVA2__, ::nRouDiv )
   __NBASIVA3__         := Round( __NBRTIVA3__, ::nRouDiv )

   /*
   Descuento especial----------------------------------------------------------
   */

   if ::oDbf:nDtoEsp  != 0

      __NBASIVA1__      -= Round( __NBASIVA1__ * ::oDbf:nDtoEsp / 100, ::nRouDiv )
      __NBASIVA2__      -= Round( __NBASIVA2__ * ::oDbf:nDtoEsp / 100, ::nRouDiv )
      __NBASIVA3__      -= Round( __NBASIVA3__ * ::oDbf:nDtoEsp / 100, ::nRouDiv )

   end if

   /*
   Descuento pronto pago-------------------------------------------------------
   */

   if ::oDbf:nDpp  != 0

      __NBASIVA1__      -= Round( __NBASIVA1__ * ::oDbf:nDpp / 100, ::nRouDiv )
      __NBASIVA2__      -= Round( __NBASIVA2__ * ::oDbf:nDpp / 100, ::nRouDiv )
      __NBASIVA3__      -= Round( __NBASIVA3__ * ::oDbf:nDpp / 100, ::nRouDiv )

   end if

   /*
   Descuento uno---------------------------------------------------------------
   */

   if ::oDbf:nDtoUno  != 0

      __NBASIVA1__      -= Round( __NBASIVA1__ * ::oDbf:nDtoUno / 100, ::nRouDiv )
      __NBASIVA2__      -= Round( __NBASIVA2__ * ::oDbf:nDtoUno / 100, ::nRouDiv )
      __NBASIVA3__      -= Round( __NBASIVA3__ * ::oDbf:nDtoUno / 100, ::nRouDiv )

   end if

   /*
   Descuento dos---------------------------------------------------------------
   */

   if ::oDbf:nDtoDos  != 0

      __NBASIVA1__      -= Round( __NBASIVA1__ * ::oDbf:nDtoDos / 100, ::nRouDiv )
      __NBASIVA2__      -= Round( __NBASIVA2__ * ::oDbf:nDtoDos / 100, ::nRouDiv )
      __NBASIVA3__      -= Round( __NBASIVA3__ * ::oDbf:nDtoDos / 100, ::nRouDiv )

   end if

   /*
   Mano de obra----------------------------------------------------------------
   */

   if ::oDbf:nManObr != 0

      do case
         case __NPCTIVA1__ == nil .or. __NPCTIVA1__ == ::oDbf:nIvaMan

         __NPCTIVA1__   := ::oDbf:nIvaMan
         __NBASIVA1__   += ::oDbf:nManObr

      case __NPCTIVA2__ == nil .or. __NPCTIVA2__ == ::oDbf:nIvaMan

         __NPCTIVA2__   := ::oDbf:nIvaMan
         __NBASIVA2__   += ::oDbf:nManObr

      case __NPCTIVA3__ == nil .or. __NPCTIVA3__ == ::oDbf:nIvaMan

         __NPCTIVA3__   := ::oDbf:nIvaMan
         __NBASIVA3__   += ::oDbf:nManObr

      end case

   end if

   /*
   Calculo de los impuestoss---------------------------------------------------------
   */

   __NIMPIVA1__      := if( __NPCTIVA1__ != NIL, Round( __NBASIVA1__ * __NPCTIVA1__ / 100, ::nRouDiv ), 0 )
   __NIMPIVA2__      := if( __NPCTIVA2__ != NIL, Round( __NBASIVA2__ * __NPCTIVA2__ / 100, ::nRouDiv ), 0 )
   __NIMPIVA3__      := if( __NPCTIVA3__ != NIL, Round( __NBASIVA3__ * __NPCTIVA3__ / 100, ::nRouDiv ), 0 )

   /*
   Total bruto-----------------------------------------------------------------
   */

   ::nTotBrt      := __NBRTIVA1__ + __NBRTIVA2__ + __NBRTIVA3__

   if !Empty( ::oGetBrt )
      ::oGetBrt:SetText( ::nTotBrt )
   end if

   /*
   Total Neto------------------------------------------------------------------
   */

   ::nTotNet      := Round( __NBASIVA1__ + __NBASIVA2__ + __NBASIVA3__, ::nRouDiv )

   if !Empty( ::oGetNet )
      ::oGetNet:SetText( ::nTotNet )
   end if

   /*
   Total impuestos-------------------------------------------------------------------
   */

   ::nTotIva      := Round( __NIMPIVA1__ + __NIMPIVA2__ + __NIMPIVA3__, ::nRouDiv )

   if !Empty( ::oGetIva )
      ::oGetIva:SetText( ::nTotIva )
   end if

   /*
   Total Factura---------------------------------------------------------------
   */

   ::nTotFac      := Round( ::nTotNet + ::nTotIva, ::nRouDiv )

   if !Empty( ::oGetTotal )
      ::oGetTotal:SetText( ::nTotFac )
   end if

   /*
   Refrescamos el browse de impuestos------------------------------------------
   */

   if !Empty( ::oBrwIva )
      ::oBrwIva:Refresh()
   end if

RETURN ( ::nTotFac )

//---------------------------------------------------------------------------//

METHOD ShowKit( lSet ) CLASS TFacAutomatica

   local lShwKit     := lShwKit()

   if lSet
      lShwKit        := !lShwKit
   end if

   if lShwKit
      SetWindowText( ::oBtnKit:hWnd, "Mostrar Esc&ll." )
      ::oDetFacAutomatica:oDbfVir:SetFilter( "!lKitChl" )
   else
      SetWindowText( ::oBtnKit:hWnd, "Ocultar Esc&ll." )
      ::oDetFacAutomatica:oDbfVir:KillFilter()
   end if

   if lSet
      lShwKit( lShwKit )
   end if

   ::oBrwLineas:Refresh()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ExternalEdit( cCodFac ) CLASS TFacAutomatica

   if ::oDbf:Seek( cCodFac )
      ::Edit()
   else
      MsgStop( "Código " + cCodFac + " de factura automática no encontrado" )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD RunPlantillaAutomatica( cCodigoPlantilla ) CLASS TFacAutomatica

   if SuperUsuarioController():New():isNotDialogViewActivate()
      RETURN ( Self )
   end if 

   with object ( TCreaFacAutomaticas():New() )

      :cCodigoPlantilla    := cCodigoPlantilla
      
      if :OpenFiles()
      
         if :lSelectCodigoPlantilla()      
            :Run()
         end if
      
         :CloseFiles()
      
      end if 
      
   end with

Return ( Self )

//---------------------------------------------------------------------------//

Function lFacturasAutomaticas()

   if !( oUser():lDocAuto() )
      Return .f.
   end if

   with object ( TCreaFacAutomaticas():New() )
      if :OpenFiles()
         if :lLanzaAsistente()
            :Run()
         end if
         :CloseFiles()
      end if 
   end with

RETURN ( nil )

//---------------------------------------------------------------------------//

CLASS TCreaFacAutomaticas

   DATA nView

   DATA oDbfArt
   DATA oDbfCli
   DATA oDbfDiv
   DATA oDbfCount
   DATA oDbfTblCnv
   DATA oDbfFam
   DATA oDbfKit
   DATA oDbfIva
   DATA oDbfUser
   DATA oDbfFPago
   DATA oDbfAge

   DATA oAlbCliT
   DATA oAlbCliL

   DATA oFacCliT
   DATA oFacCliL
   DATA oFacCliP
   DATA oAntCliT

   DATA oFacAutT
   DATA oFacAutL
   DATA oFacAutI

   DATA oGrpFacturasAutomaticas

   DATA oTree
   DATA oBrwPlantilla
   DATA oMetMsg
   DATA oBtnInicio
   DATA oBtnInforme

   DATA oChkIgnoraProcesado 
   DATA lChkIgnoraProcesado      INIT .f.

   DATA cPorDiv

   DATA cFilTxt
   DATA hFilTxt

   DATA oFecDocumento
   DATA dFecDocumento

   DATA aPlantilla

   DATA cErrorMessage

   DATA lAsistente   
   DATA lMensaje   

   DATA oTreeSelector

   DATA oCodigoGrupo 
   DATA cCodigoGrupo             INIT Space( 4 )
   DATA aCodigoGrupo            

   DATA oCodigoPlantilla
   DATA cCodigoPlantilla         INIT Space( 3 )

   Method New()
   METHOD Run()

   METHOD OpenFiles()
   METHOD CloseFiles()

   METHOD lLanzaAsistente()
      METHOD IniciarAsistente()
      METHOD StartAsistente()

   METHOD CreaAlbaran()
   METHOD CreaFactura()

   METHOD lCompruebaFecha()

   METHOD ActionTree()

   METHOD lSeekClient( cCodFac )

   METHOD OnClickRefreshAsistente()    INLINE   ( ::lLanzaAsistente() ) 
   METHOD OnClickIgnoraProcesado()     INLINE   ( ::oBtnIgnoraProcesado:Toggle() )

   METHOD SetNextFechaFactura()

   METHOD lSelectCodigoPlantilla( cCodigoPlantilla ) 

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS TCreaFacAutomaticas

   ::lMensaje           := .f.
   ::lAsistente         := .t.
   ::dFecDocumento      := GetSysDate()
   ::cCodigoPlantilla   := Space( 3 )
   ::cCodigoGrupo       := Space( 4 )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Run() CLASS TCreaFacAutomaticas

   local oDlg 
   local oFld
   local oBmp
   local nMetMsg
   local cCodigoGrupo
   local cCodigoPlantilla

   cCodigoGrupo      := ::cCodigoGrupo
   cCodigoPlantilla  := ::cCodigoPlantilla

   /*
   if !::OpenFiles()
      Return .f.
   end if
   */
   /*
   Comprobamos si tenemos que lanzar el asistente------------------------------
   */

   // if ::lLanzaAsistente()

      DEFINE DIALOG oDlg RESOURCE "AssDocAuto"

      REDEFINE BITMAP oBmp ;
        ID        900 ;
        RESOURCE  "gc_document_text_gear_48" ;
        TRANSPARENT ;
        OF        oDlg

      REDEFINE FOLDER oFld ;
         ID       400 ;
			OF 		oDlg ;
         PROMPT   "Plantillas",;
                  "Proceso" ;
         DIALOGS  "AssDocAuto_2",;
                  "AssDocAuto_1" 

      REDEFINE GET ::oFecDocumento VAR ::dFecDocumento ;
         ID       110 ;
         SPINNER ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET ::oCodigoGrupo VAR ::cCodigoGrupo ;
         ID       120 ;
         IDTEXT   121 ;
         BITMAP   "LUPA" ;
         OF       oFld:aDialogs[ 1 ]

         ::oCodigoGrupo:bValid      := {|| if( ::oGrpFacturasAutomaticas:Existe( ::oCodigoGrupo, ::oCodigoGrupo:oHelpText, "cNomGrp", .t., .t., "0" ), ( if( cCodigoGrupo != ::cCodigoGrupo, ::lSelectCodigoPlantilla(), ), cCodigoGrupo := ::cCodigoGrupo, .t. ), .f. ) }
         ::oCodigoGrupo:bHelp       := {|| ::oGrpFacturasAutomaticas:Buscar( ::oCodigoGrupo ) }

      REDEFINE GET ::oCodigoPlantilla VAR ::cCodigoPlantilla ;
         ID       130 ;
         IDTEXT   131 ;
         BITMAP   "LUPA" ;
         OF       oFld:aDialogs[ 1 ]

         ::oCodigoPlantilla:bValid  := {|| if( ::oFacAutT:Existe( ::oCodigoPlantilla, ::oCodigoPlantilla:oHelpText, "cNomFac", .t., .t., "0" ), ( if( cCodigoPlantilla != ::cCodigoPlantilla, ::lSelectCodigoPlantilla(), ), cCodigoPlantilla := ::cCodigoPlantilla, .t. ), .f. ) }
         ::oCodigoPlantilla:bHelp   := {|| ::oFacAutT:Buscar( ::oCodigoPlantilla ) }

      /*
      TBtnBmp():ReDefine( 120, "gc_recycle_16",,,,, {|| ::OnClickRefreshAsistente() }, oFld:aDialogs[ 1 ], .f., , .f., "Selecionar plantillas" )

      REDEFINE CHECKBOX ::oChkIgnoraProcesado ;
         VAR      ::lChkIgnoraProcesado ;
         ID       130 ;
         OF       oFld:aDialogs[ 1 ]
      */

      /*
      Plantillas para el proceso-----------------------------------------------
      */

      ::oBrwPlantilla                  := IXBrowse():New( oFld:aDialogs[ 1 ] )

      ::oBrwPlantilla:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrwPlantilla:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oBrwPlantilla:SetArray( ::aPlantilla, , , .f. )

      ::oBrwPlantilla:nMarqueeStyle    := 6
      ::oBrwPlantilla:lRecordSelector  := .f.
      ::oBrwPlantilla:lHScroll         := .f.

      ::oBrwPlantilla:bLDblClick       := {|| ::aPlantilla[ ::oBrwPlantilla:nArrayAt, 1 ] := !::aPlantilla[ ::oBrwPlantilla:nArrayAt, 1 ], ::oBrwPlantilla:Refresh() }

      with object ( ::oBrwPlantilla:AddCol() )
         :cHeader          := "Seleccionada"
         :nHeadBmpNo       := 1
         :bStrData         := {|| "" }
         :bEditValue       := {|| ::aPlantilla[ ::oBrwPlantilla:nArrayAt, 1 ] }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
      end with

      with object ( ::oBrwPlantilla:AddCol() )
         :cHeader          := "Código"
         :bEditValue       := {|| ::aPlantilla[ ::oBrwPlantilla:nArrayAt, 2 ] }
         :nWidth           := 60
      end with

      with object ( ::oBrwPlantilla:AddCol() )
         :cHeader          := "Nombre plantilla"
         :bEditValue       := {|| ::aPlantilla[ ::oBrwPlantilla:nArrayAt, 3 ] }
         :nWidth           := 200
      end with

      with object ( ::oBrwPlantilla:AddCol() )
         :cHeader          := "Comentario"
         :bEditValue       := {|| ::aPlantilla[ ::oBrwPlantilla:nArrayAt, 4 ] }
         :nWidth           := 400
      end with

      ::oBrwPlantilla:CreateFromResource( 100 )

      /*
      ::oTreeSelector      := TTreeView():Redefine( 500, oFld:aDialogs[1] )
      */

      /*
      Arbol de resultados------------------------------------------------------
      */

      ::oTree              := TTreeView():Redefine( 100, oFld:aDialogs[ 2 ] )
      ::oTree:bLDblClick   := {|| ::ActionTree() }

      /*
      Resto de controles-------------------------------------------------------
      */

      REDEFINE APOLOMETER ::oMetMsg VAR nMetMsg ;
         ID       120 ;
         OF       oDlg

      REDEFINE BUTTON ::oBtnInicio;
         ID       500 ;
         OF       oDlg ;
         ACTION   ( ::IniciarAsistente( oFld, oDlg ) )

      REDEFINE BUTTON ;
         ID       550 ;
         OF       oDlg ;
         ACTION   ( oDlg:End() )

      REDEFINE BUTTON ::oBtnInforme;
         ID       600 ;
         OF       oDlg ;
         ACTION   ( if( File( AllTrim( ::cFilTxt ) ), WinExec( "notepad.exe " + AllTrim( ::cFilTxt ) ), ) )

      oDlg:bStart := {|| ::StartAsistente() }

      ACTIVATE DIALOG oDlg CENTER

   // else

      // MsgInfo( ::cErrorMessage, "Plantillas de facturas automáticas." )

   // end if

   /*
   Anoto la fecha en el usuario------------------------------------------------
   */

   // ::CloseFiles()

   if !Empty( oBmp )
      oBmp:End()
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD StartAsistente()

   ::oBtnInforme:Disable()  

   ::oCodigoGrupo:lValid()
   ::oCodigoPlantilla:lValid()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TCreaFacAutomaticas

   local oBlock
   local oError
   local lOpen          := .t.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   ::nView              := D():CreateView()

   DATABASE NEW ::oDbfArt     PATH ( cPatEmp() )   FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   DATABASE NEW ::oDbfCli     PATH ( cPatEmp() )   FILE "CLIENT.DBF"   VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL    PATH ( cPatEmp() )   FILE "ALBCLIL.DBF"  VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL    PATH ( cPatEmp() )   FILE "FACCLIL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   ::oFacCliP := TDataCenter():oFacCliP()

   DATABASE NEW ::oAntCliT    PATH ( cPatEmp() )   FILE "ANTCLIT.DBF"  VIA ( cDriver() ) SHARED INDEX "ANTCLIT.CDX"

   DATABASE NEW ::oDbfDiv     PATH ( cPatDat() )   FILE "DIVISAS.DBF"  VIA ( cDriver() ) SHARED INDEX "DIVISAS.CDX"

   DATABASE NEW ::oDbfCount   PATH ( cPatEmp() )   FILE "NCOUNT.DBF"   VIA ( cDriver() ) SHARED INDEX "NCOUNT.CDX"

   DATABASE NEW ::oDbfTblCnv  PATH ( cPatDat() )   FILE "TBLCNV.DBF"   VIA ( cDriver() ) SHARED INDEX "TBLCNV.CDX"

   DATABASE NEW ::oDbfFam     PATH ( cPatEmp() )   FILE "FAMILIAS.DBF" VIA ( cDriver() ) SHARED INDEX "FAMILIAS.CDX"

   DATABASE NEW ::oDbfKit     PATH ( cPatEmp() )   FILE "ARTKIT.DBF"   VIA ( cDriver() ) SHARED INDEX "ARTKIT.CDX"

   DATABASE NEW ::oDbfIva     PATH ( cPatDat() )   FILE "TIVA.DBF"     VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   DATABASE NEW ::oDbfUser    PATH ( cPatDat() )   FILE "USERS.DBF"    VIA ( cDriver() ) SHARED INDEX "USERS.CDX"

   DATABASE NEW ::oDbfFPago   PATH ( cPatEmp() )   FILE "FPAGO.DBF"    VIA ( cDriver() ) SHARED INDEX "FPAGO.CDX"

   DATABASE NEW ::oDbfAge     PATH ( cPatEmp() )   FILE "AGENTES.DBF"  VIA ( cDriver() ) SHARED INDEX "AGENTES.CDX"

   D():Atipicas( ::nView )

   ::oGrpFacturasAutomaticas  := TGrpFacturasAutomaticas():Create( cPatEmp() )
   ::oGrpFacturasAutomaticas:OpenService( .f. )

   ::oFacAutT           := TFacAutomatica():Create( cPatEmp() )
   ::oFacAutT:Openfiles( .f. )

   ::oFacAutL           := TDetFacAutomatica():Create( cPatEmp(), cDriver(), Self )
   ::oFacAutL:Openfiles( .f. )

   ::oFacAutI           := THisFacAutomatica():Create( cPatEmp(), cDriver(), Self )
   ::oFacAutI:Openfiles( .f. )

   if ::oDbfDiv:Seek( cDivEmp() )
      ::cPorDiv         := RetPic( ::oDbfDiv:nNouDiv, ::oDbfDiv:nRouDiv )
   end if

   RECOVER USING oError

      msgStop( "Imposible abrir bases de datos de facturas automáticas." + CRLF + ErrorMessage( oError ) )

      ::CloseFiles()

      lOpen             := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TCreaFacAutomaticas

   D():DeleteView( ::nView )

   if ::oDbfCli != nil .and. ::oDbfCli:Used()
      ::oDbfCli:End()
   end if

   if ::oDbfArt != nil .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if

   if ::oAlbCliT != nil .and. ::oAlbCliT:Used()
      ::oAlbCliT:End()
   end if

   if ::oAlbCliL != nil .and. ::oAlbCliL:Used()
      ::oAlbCliL:End()
   end if

   if ::oFacCliT != nil .and. ::oFacCliT:Used()
      ::oFacCliT:End()
   end if

   if ::oFacCliL != nil .and. ::oFacCliL:Used()
      ::oFacCliL:End()
   end if

   if ::oDbfDiv != nil .and. ::oDbfDiv:Used()
      ::oDbfDiv:End()
   end if

   if ::oDbfCount != nil .and. ::oDbfCount:Used()
      ::oDbfCount:End()
   end if

   if ::oDbfTblCnv != nil .and. ::oDbfTblCnv:Used()
      ::oDbfTblCnv:End()
   end if

   if ::oDbfKit != nil .and. ::oDbfKit:Used()
      ::oDbfKit:End()
   end if

   if ::oDbfFam != nil .and. ::oDbfFam:Used()
      ::oDbfFam:End()
   end if

   if ::oDbfIva != nil .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if

   if ::oFacCliP != nil .and. ::oFacCliP:Used()
      ::oFacCliP:End()
   end if

   if ::oAntCliT != nil .and. ::oAntCliT:Used()
      ::oAntCliT:End()
   end if

   if ::oDbfUser != nil .and. ::oDbfUser:Used()
      ::oDbfUser:End()
   end if

   if ::oDbfFPago != nil .and. ::oDbfFPago:Used()
      ::oDbfFPago:End()
   end if

   if ::oDbfAge != nil .and. ::oDbfAge:Used()
      ::oDbfAge:End()
   end if

   if ::oGrpFacturasAutomaticas != nil
      ::oGrpFacturasAutomaticas:End()
   end if 

   if ::oFacAutT != nil
      ::oFacAutT:End()
   end if

   if ::oFacAutL != nil
      ::oFacAutL:End()
   end if

   if ::oFacAutI != nil
      ::oFacAutI:End()
   end if

   if !Empty( ::oTree )
      ::oTree:End()
   end if

   ::oDbfCli      := nil
   ::oDbfArt      := nil
   ::oAlbCliT     := nil
   ::oAlbCliL     := nil
   ::oFacCliT     := nil
   ::oFacCliL     := nil
   ::oFacCliP     := nil
   ::oFacAutT     := nil
   ::oFacAutL     := nil
   ::oFacAutI     := nil
   ::oDbfDiv      := nil
   ::oDbfCount    := nil
   ::oTree        := nil
   ::oDbfTblCnv   := nil
   ::oDbfFam      := nil
   ::oDbfKit      := nil
   ::oDbfIva      := nil
   ::oAntCliT     := nil
   ::oDbfUser     := nil
   ::oDbfFPago    := nil
   ::oDbfAge      := nil

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD lSelectCodigoPlantilla() CLASS TCreaFacAutomaticas

   local oError
   local oBlock
   local lSelect                          := .f.
   local aCodigoGrupo                     := {}

   oBlock                                 := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      CursorWait()

      aCodigoGrupo                     := ::oGrpFacturasAutomaticas:aChild( ::cCodigoGrupo, { ::cCodigoGrupo } )

      ::aPlantilla                     := {}

      ::oFacAutT:oDbf:GoTop()
      while !::oFacAutT:oDbf:Eof()

         if ( Empty( aCodigoGrupo )       .or. ( lScanCodeInMemo( aCodigoGrupo, ::oFacAutT:oDbf:mGrpSel ) ) )  .and. ;
            ( Empty( ::cCodigoPlantilla ) .or. ( ::oFacAutT:oDbf:cCodFac == ::cCodigoPlantilla ) )                
           
            aAdd( ::aPlantilla, { .t., ::oFacAutT:oDbf:cCodFac, ::oFacAutT:oDbf:cNomFac, "Lista para generar documentos." } )

            lSelect                    := .t.

         end if 

         ::oFacAutT:oDbf:Skip()

      end while

      aSort( ::aPlantilla, , , {|x,y| x[1] > y[1]} )

      if !Empty( ::oBrwPlantilla )
         ::oBrwPlantilla:SetArray( ::aPlantilla, , , .f. )
         ::oBrwPlantilla:GoTop()
      end if

      CursorWE()

   RECOVER USING oError

      msgStop( "Imposible seleccionar plantillas de facturas automáticas." + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lSelect )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
// Comprobamos que si tenemos que lanzar el asistente--------------------------
//---------------------------------------------------------------------------//

METHOD lLanzaAsistente() CLASS TCreaFacAutomaticas

   local lLanza
   local oError
   local oBlock

   lLanza                           := .f.

   ::aPlantilla                     := {}
   ::cErrorMessage                  := ""

   CursorWait()

   if empty( ::oFacAutT:oDbf ) .or. !( ::oFacAutT:oDbf:used() )
      Return ( lLanza )
   end if 

   if !( oUser():lDocAuto() )
      Return ( lLanza )
   end if 

   oBlock                           := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::oFacAutT:oDbf:GoTop()

         while !::oFacAutT:oDbf:Eof()

            if (  ( Empty( ::oFacAutT:oDbf:dFecIni ) .or. ::oFacAutT:oDbf:dFecIni <= GetSysDate() )   .and.;
                  ( Empty( ::oFacAutT:oDbf:dFecFin ) .or. ::oFacAutT:oDbf:dFecFin >= GetSysDate() ) )

               if ::lCompruebaFecha()

                  if ::lSeekClient( ::oFacAutT:oDbf:cCodFac )

                     aAdd( ::aPlantilla, { .t., ::oFacAutT:oDbf:cCodFac, ::oFacAutT:oDbf:cNomFac, "Lista para generar documentos." } )

                     lLanza         := .t.

                  else

                     aAdd( ::aPlantilla, { .f., ::oFacAutT:oDbf:cCodFac, ::oFacAutT:oDbf:cNomFac, "No está asignada a ningún cliente." } )
                     
                     ::cErrorMessage+= "La plantilla " + Rtrim( ::oFacAutT:oDbf:cNomFac ) + " no está asignada a ningún cliente." + CRLF

                  end if

               else

                  aAdd( ::aPlantilla, { .f., ::oFacAutT:oDbf:cCodFac, ::oFacAutT:oDbf:cNomFac, "Ya ha generado sus documentos." } )

                  ::cErrorMessage   += "La plantilla " + Rtrim( ::oFacAutT:oDbf:cNomFac ) + " ya ha generado sus documentos." + CRLF

               end if

            else

               aAdd( ::aPlantilla, { .f., ::oFacAutT:oDbf:cCodFac, ::oFacAutT:oDbf:cNomFac, "No esta en el periodo de fechas." } )

               ::cErrorMessage      += "La plantilla " + Rtrim( ::oFacAutT:oDbf:cNomFac ) + " no esta en el periodo de fechas." + CRLF

            end if

            ::oFacAutT:oDbf:Skip()

         end while

      if !Empty( ::oBrwPlantilla )

         aSort( ::aPlantilla, , , {|x,y| x[1] > y[1]} )

         ::oBrwPlantilla:SetArray( ::aPlantilla, , , .f. )
         ::oBrwPlantilla:GoTop()

      end if

   RECOVER USING oError

      msgStop( "Imposible iniciar el asisitente de facturas automáticas." + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CursorWE()

RETURN ( lLanza )

//---------------------------------------------------------------------------//

METHOD lSeekClient( cCodFac ) Class TCreaFacAutomaticas

   local lSeek    := .f.

   ::oDbfCli:GoTop()

   while !::oDbfCli:Eof()

      if At( AllTrim( cCodFac ), ::oDbfCli:mFacAut ) != 0
         lSeek    := .t.
      end if

      if lSeek
         exit
      end if

      ::oDbfCli:Skip()

   end while

Return lSeek

//---------------------------------------------------------------------------//

METHOD IniciarAsistente( oFld, oDlg ) CLASS TCreaFacAutomaticas

   local oItem
   local aPlantilla

   ::oBtnInicio:Disable()
   ::oFecDocumento:Disable()

   oFld:SetOption( 2 )

   CursorWait()

   ::cFilTxt            := cGetNewFileName( cPatLog() + "DocAut" + Dtos( Date() ) + StrTran( Time(), ":", "" ) ) + ".txt"
   ::hFilTxt            := fCreate( ::cFilTxt )

   if Empty( ::hFilTxt )
      ::hFilTxt         := fOpen( ::cFilTxt, 1 )
   endif

   fWrite( ::hFilTxt, "Proceso iniciado: " + AllTrim( Dtoc( GetSysDate() ) ) + CRLF )

   ::oTree:DeleteAll()

   ::oTree:Select( ::oTree:Add( "Proceso iniciado " + AllTrim( Dtoc( GetSysDate() ) ) ) )

   /*
   Recorremos la plantilla-----------------------------------------------------
   */

   ::oMetMsg:SetTotal( len( ::aPlantilla ) )

   for each aPlantilla in ::aPlantilla

      if aPlantilla[ 1 ] .and. ::oFacAutT:oDbf:Seek( aPlantilla[ 2 ] )

         fWrite( ::hFilTxt, "Procesando plantilla " + AllTrim( ::oFacAutT:oDbf:cCodFac ) + " - " + AllTrim( ::oFacAutT:oDbf:cNomFac ) + CRLF )

         ::oTree:Select( ::oTree:Add( "Procesando pantilla " + AllTrim( ::oFacAutT:oDbf:cCodFac ) + " - " + AllTrim( ::oFacAutT:oDbf:cNomFac ) ) )

         ::oDbfCli:GoTop()
         while !::oDbfCli:Eof()

            if At( AllTrim( ::oFacAutT:oDbf:cCodFac ), ::oDbfCli:mFacAut ) != 0

               if ::oFacAutT:oDbf:nTipDoc != 2
                  ::CreaAlbaran()
               else
                  ::CreaFactura()
               end if

            end if

            ::oDbfCli:Skip()

         end while

         /*
         Guardamos en el histórico del documento automático--------------------
         */

         ::oFacAutI:oDbf:Append()

         ::oFacAutI:oDbf:cCodFac    := ::oFacAutT:oDbf:cCodFac
         ::oFacAutI:oDbf:dFecha     := GetSysDate()
         ::oFacAutI:oDbf:cHora      := Time()
         ::oFacAutI:oDbf:cFichero   := ::cFilTxt

         ::oFacAutI:oDbf:Save()

      end if

      /*
      Actualizamos el meter----------------------------------------------------
      */

      ::oMetMsg:AutoInc()

   next

   ::oMetMsg:AutoInc( ::oFacAutT:oDbf:Lastrec() )

   fWrite( ::hFilTxt, "Proceso finalizado correctamente" )

   ::oTree:Select( ::oTree:Add( "Proceso finalizado correctamente" ) )

   fClose( ::hFilTxt )

   CursorWE()

   /*
   Habilitamos los botones-----------------------------------------------------
   */

   ::oBtnInforme:Enable()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD CreaAlbaran() CLASS TCreaFacAutomaticas

   local cText
   local oNode
   local cSerAlb
   local nNumAlb
   local cSufAlb
   local aTotAlb
   local nImpAtp
   local nDtoArt
   local cCodPgo
   local hAtipica
   local hValue      := {=>}

   BeginTransaction()

   /*
   Cabecera del albarán--------------------------------------------------------
   */

   ::oAlbCliT:Append()

   if ( ::oFacAutT:oDbf:lUseCli .and. !Empty( ::oDbfCli:cCodAlm ) )
      ::oAlbCliT:cCodAlm   := ::oDbfCli:cCodAlm
   else
      ::oAlbCliT:cCodAlm   := cDefAlm()
   end if

   /*
   Forma de pago del albarán---------------------------------------------------
   */

   if !Empty( ::oFacAutT:oDbf:cCodPago )
      cCodPgo              := ::oFacAutT:oDbf:cCodPago 
   end if 

   if Empty( cCodPgo ) .and. ::oFacAutT:oDbf:lUseCli .and. !Empty( ::oDbfCli:CodPago ) 
      cCodPgo              := ::oDbfCli:CodPago
   end if 

   if Empty( cCodPgo )
      cCodPgo              := cDefFpg()
   end if 

   /*
   Serie, numero y sufijo------------------------------------------------------
   */

   ::oAlbCliT:cCodPago     := cCodPgo 

   if !Empty( ::oFacAutT:oDbf:cSerFact )
      cSerAlb              := ::oFacAutT:oDbf:cSerFact
   end if

   if Empty( cSerAlb ) .and. ::oFacAutT:oDbf:lUseCli
      cSerAlb              := oRetFld( ::oDbfCli:Cod, ::oDbfCli, "Serie" )
   end if

   if Empty( cSerAlb )
      cSerAlb              := cNewSer( "nAlbCli", ::oDbfCount:cAlias )
   end if

   nNumAlb                 := nNewDoc( cSerAlb, ::oAlbCliT:cAlias, "nAlbCli", , ::oDbfCount:cAlias )
   cSufAlb                 := RetSufEmp()

   ::oAlbCliT:cTurAlb      := cCurSesion()
   ::oAlbCliT:dFecAlb      := ::dFecDocumento
   ::oAlbCliT:cCodCli      := ::oDbfCli:Cod
   ::oAlbCliT:cCodCaj      := Application():CodigoCaja()
   ::oAlbCliT:cNomCli      := ::oDbfCli:Titulo
   ::oAlbCliT:cDirCli      := ::oDbfCli:Domicilio
   ::oAlbCliT:cPobCli      := ::oDbfCli:Poblacion
   ::oAlbCliT:cPrvCli      := ::oDbfCli:Provincia
   ::oAlbCliT:cPosCli      := ::oDbfCli:CodPostal
   ::oAlbCliT:cDniCli      := ::oDbfCli:Nif
   ::oAlbCliT:lModCli      := ::oDbfCli:lModDat
   ::oAlbCliT:lSndDoc      := .t.
   ::oAlbCliT:cDivAlb      := cDivEmp()
   ::oAlbCliT:nVdvAlb      := nChgDiv( cDivEmp(), ::oDbfDiv:cAlias )
   ::oAlbCliT:lIvaInc      := uFieldEmpresa( "lIvaInc" )
   ::oAlbCliT:cCodUsr      := Auth():Codigo()
   ::oAlbCliT:dFecCre      := GetSysDate()
   ::oAlbCliT:cTimCre      := Time()
   ::oAlbCliT:cCodDlg      := Application():CodigoDelegacion()
   ::oAlbCliT:nTarifa      := Max( uFieldEmpresa( "nPreVta" ), ::oDbfCli:nTarifa )
   ::oAlbCliT:cDtoEsp      := if( ::oFacAutT:oDbf:lUseCli, ::oDbfCli:cDtoEsp, ::oFacAutT:oDbf:cDtoEsp )
   ::oAlbCliT:nDtoEsp      := if( ::oFacAutT:oDbf:lUseCli, ::oDbfCli:nDtoEsp, ::oFacAutT:oDbf:nDtoEsp )
   ::oAlbCliT:cDpp         := if( ::oFacAutT:oDbf:lUseCli, ::oDbfCli:cDpp, ::oFacAutT:oDbf:cDpp )
   ::oAlbCliT:nDpp         := if( ::oFacAutT:oDbf:lUseCli, ::oDbfCli:nDpp, ::oFacAutT:oDbf:nDpp )
   ::oAlbCliT:cDtoUno      := if( ::oFacAutT:oDbf:lUseCli, ::oDbfCli:cDtoUno, ::oFacAutT:oDbf:cDtoUno )
   ::oAlbCliT:nDtoUno      := if( ::oFacAutT:oDbf:lUseCli, ::oDbfCli:nDtoCnt, ::oFacAutT:oDbf:nDtoUno )
   ::oAlbCliT:cDtoDos      := if( ::oFacAutT:oDbf:lUseCli, ::oDbfCli:cDtoDos, ::oFacAutT:oDbf:cDtoDos )
   ::oAlbCliT:nDtoDos      := if( ::oFacAutT:oDbf:lUseCli, ::oDbfCli:nDtoRap, ::oFacAutT:oDbf:nDtoDos )
   ::oAlbCliT:cCodAge      := ::oDbfCli:cAgente
   ::oAlbCliT:nPctComAge   := RetFld( ::oDbfCli:cAgente, ::oDbfAge:cAlias, "nCom1" )
   ::oAlbCliT:cCodRut      := ::oDbfCli:cCodRut
   ::oAlbCliT:cCodGrp      := ::oDbfCli:cCodGrp
   ::oAlbCliT:cCodTrn      := ::oDbfCli:cCodTrn
   ::oAlbCliT:nDtoAtp      := ::oDbfCli:nDtoAtp
   ::oAlbCliT:nSbrAtp      := ::oDbfCli:nSbrAtp
   ::oAlbCliT:nIvaMan      := ::oFacAutT:oDbf:nIvaMan
   ::oAlbCliT:nManObr      := ::oFacAutT:oDbf:nManObr
   ::oAlbCliT:cManObr      := ::oFacAutT:oDbf:cManObr
   ::oAlbCliT:lRecargo     := ::oDbfCli:lReq
   ::oAlbCliT:nFacturado   := 1

   hValue[ "cCodigoCliente"    ] := ::oDbfCli:Cod
   hValue[ "dFecha"            ] := ::dFecDocumento
   hValue[ "cCodigoGrupo"      ] := ::oDbfCli:cCodGrp
   hValue[ "lIvaIncluido"      ] := uFieldEmpresa( "lIvaInc" )
   hValue[ "nDescuentoTarifa"  ] := ::oDbfCli:nDtoArt
   hValue[ "nTarifaPrecio"     ] := Max( uFieldEmpresa( "nPreVta" ), ::oDbfCli:nTarifa )

   nDtoArt                 := oRetFld( ::oDbfCli:Cod, ::oDbfCli, "nDtoArt" )

   ::oAlbCliT:cSerAlb      := cSerAlb
   ::oAlbCliT:nNumAlb      := nNumAlb
   ::oAlbCliT:cSufAlb      := cSufAlb

   ::oAlbCliT:Save()

   /*
   Líneas de albaranes de clientes---------------------------------------------
   */

   if ::oFacAutL:oDbf:Seek( ::oFacAutT:oDbf:cCodFac )

      while ::oFacAutL:oDbf:cCodFac == ::oFacAutT:oDbf:cCodFac .and. !::oFacAutL:oDbf:Eof()

         ::oAlbCliL:Append()
         ::oAlbCliL:cSerAlb         := cSerAlb
         ::oAlbCliL:nNumAlb         := nNumAlb
         ::oAlbCliL:cSufAlb         := cSufAlb
         ::oAlbCliL:cRef            := ::oFacAutL:oDbf:cCodArt
         ::oAlbCliL:cDetalle        := ::oFacAutL:oDbf:cDetalle
         ::oAlbCliL:mLngDes         := ::oFacAutL:oDbf:mLngDes
         ::oAlbCliL:cCodPr1         := ::oFacAutL:oDbf:cCodPr1
         ::oAlbCliL:cCodPr2         := ::oFacAutL:oDbf:cCodPr2
         ::oAlbCliL:cValPr1         := ::oFacAutL:oDbf:cValPr1
         ::oAlbCliL:cValPr2         := ::oFacAutL:oDbf:cValPr2

         ::oAlbCliL:cAlmLin         := ::oAlbCliT:cCodAlm

         hValue[ "cCodigoArticulo"   ] := ::oFacAutL:oDbf:cCodArt
         hValue[ "cCodigoPropiedad1" ] := ::oFacAutL:oDbf:cCodPr1
         hValue[ "cCodigoPropiedad2" ] := ::oFacAutL:oDbf:cCodPr2
         hValue[ "cValorPropiedad1"  ] := ::oFacAutL:oDbf:cValPr1
         hValue[ "cValorPropiedad2"  ] := ::oFacAutL:oDbf:cValPr2
         
         if ::oDbfArt:Seek( ::oFacAutL:oDbf:cCodArt )

            ::oAlbCliL:nPesoKg      := ::oDbfArt:nPesoKg
            ::oAlbCliL:cPesoKg      := ::oDbfArt:cUnidad
            ::oAlbCliL:nVolumen     := ::oDbfArt:nVolumen
            ::oAlbCliL:cVolumen     := ::oDbfArt:cVolumen
            ::oAlbCliL:cUnidad      := ::oDbfArt:cUnidad
            ::oAlbCliL:lMsgVta      := ::oDbfArt:lMsgVta
            ::oAlbCliL:lNotVta      := ::oDbfArt:lNotVta
            ::oAlbCliL:nFacCnv      := ::oDbfArt:nFacCnv
            ::oAlbCliL:cCodTip      := ::oDbfArt:cCodTip
            ::oAlbCliL:cCodFam      := ::oDbfArt:Familia
            ::oAlbCliL:cGrpFam      := RetFld( ::oDbfArt:Familia, ::oDbfFam:cAlias, "cCodGrp" )
            ::oAlbCliL:nCtlStk      := ::oDbfArt:nCtlStock
            ::oAlbCliL:nCosDiv      := nCosto( nil, ::oDbfArt:cAlias, ::oDbfKit:cAlias )

            hValue[ "cCodigoFamilia"    ] := ::oDbfArt:Familia
            
            if ( ::oFacAutT:oDbf:lUseCli )

               do case
               case nDtoArt == 1
                  ::oAlbCliL:nDto   := ::oDbfArt:nDtoArt1

               case nDtoArt == 2
                  ::oAlbCliL:nDto   := ::oDbfArt:nDtoArt2

               case nDtoArt == 3
                  ::oAlbCliL:nDto   := ::oDbfArt:nDtoArt3

               case nDtoArt == 4
                  ::oAlbCliL:nDto   := ::oDbfArt:nDtoArt4

               case nDtoArt == 5
                  ::oAlbCliL:nDto   := ::oDbfArt:nDtoArt5

               case nDtoArt == 6
                  ::oAlbCliL:nDto   := ::oDbfArt:nDtoArt6

               end case

            end if

         end if

         ::oAlbCliL:nCanEnt         := ::oFacAutL:oDbf:nCajas
         ::oAlbCliL:nUniCaja        := ::oFacAutL:oDbf:nUnidades
         ::oAlbCliL:lKitArt         := ::oFacAutL:oDbf:lKitArt
         ::oAlbCliL:lKitChl         := ::oFacAutL:oDbf:lKitChl
         ::oAlbCliL:lKitPrc         := ::oFacAutL:oDbf:lKitPrc
         ::oAlbCliL:nIva            := ::oFacAutL:oDbf:nIva
         ::oAlbCliL:nReq            := nPorcentajeRE( ::oDbfIva:cAlias, ::oFacAutL:oDbf:nIva )
         ::oAlbCliL:nNumLin         := ::oFacAutL:oDbf:nNumLin
         ::oAlbCliL:dFecha          := ::dFecDocumento
         ::oAlbCliL:cTipMov         := cDefVta()
         ::oAlbCliL:lIvaLin         := uFieldEmpresa( "lIvaInc" )
         ::oAlbCliL:nTarLin         := Max( uFieldEmpresa( "nPreVta" ), ::oDbfCli:nTarifa )
         ::oAlbCliL:nComAge         := RetFld( ::oDbfCli:cAgente, ::oDbfAge:cAlias, "nCom1" )
         ::oAlbCliL:nPreUnit        := ::oFacAutL:oDbf:nPreUnit

         hValue[ "nCajas"            ] := ::oFacAutL:oDbf:nCajas
         hValue[ "nUnidades"         ] := ::oFacAutL:oDbf:nUnidades
         hValue[ "nTipoDocumento"    ] := ALB_CLI
         hValue[ "nView"             ] := ::nView

         if ::oFacAutL:oDbf:lPrcAtp

            /*
            Buscamos si existen atipicas de clientes------------------------------
            */

            hAtipica := hAtipica( hValue )

            if !Empty( hAtipica )
                  
               if hhaskey( hAtipica, "nImporte" )
                  if hAtipica[ "nImporte" ] != 0
                     ::oAlbCliL:nPreUnit := hAtipica[ "nImporte" ]
                  end if
               end if

               if hhaskey( hAtipica, "nDescuentoPorcentual" )
                  if hAtipica[ "nDescuentoPorcentual" ] != 0
                     ::oAlbCliL:nDto     := hAtipica[ "nDescuentoPorcentual" ]
                  end if   
               end if

               if hhaskey( hAtipica, "nDescuentoPromocional" )
                  if hAtipica[ "nDescuentoPromocional" ] != 0
                     ::oAlbCliL:nDtoPrm  := hAtipica[ "nDescuentoPromocional" ]
                  end if
               end if

               if hhaskey( hAtipica, "nDescuentoLineal" )
                  if hAtipica[ "nDescuentoLineal" ] != 0
                     ::oAlbCliL:nDtoDiv  := hAtipica[ "nDescuentoLineal" ]
                  end if
               end if

               if hhaskey( hAtipica, "nComisionAgente" )
                  if hAtipica[ "nComisionAgente" ] != 0
                     ::oAlbCliL:nComAge  := hAtipica[ "nComisionAgente" ]
                  end if
               end if

            end if

         end if

         ::oAlbCliL:Save()

         ::oFacAutL:oDbf:Skip()

      end while

   end if

   /*
   Calculo de totales----------------------------------------------------------
   */

   aTotAlb                          := aTotAlbCli( cSerAlb + Str( nNumAlb ) + cSufAlb, ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, cDivEmp() )

   if ::oAlbCliT:Seek( cSerAlb + Str( nNumAlb ) + cSufAlb )
      ::oAlbCliT:Load()
      ::oAlbCliT:nTotNet            := aTotAlb[ 1 ]
      ::oAlbCliT:nTotIva            := aTotAlb[ 2 ]
      ::oAlbCliT:nTotReq            := aTotAlb[ 3 ]
      ::oAlbCliT:nTotAlb            := aTotAlb[ 4 ]
      ::oAlbCliT:Save()
   end if

   /*
   Anotamos en el tree y en el fichero log ------------------------------------
   */

   cText          := "Albarán: " + cSerAlb + "/" + AllTrim( Str( nNumAlb ) ) + "/" + AllTrim( cSufAlb ) + Space( 1 ) + ;
                     "Importe: " + AllTrim( Trans( nTotAlbCli( cSerAlb + Str( nNumAlb ) + cSufAlb, ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias ), ::cPorDiv ) ) + Space(1) + cSimDiv( cDivEmp(), ::oDbfDiv ) + Space( 1 ) + ;
                     "Cliente: " + AllTrim( ::oDbfCli:Cod ) + " - " + AllTrim( ::oDbfCli:Titulo )

   fWrite( ::hFilTxt, cText + CRLF )

   oNode          := ::oTree:Add( cText )
   oNode:bAction  := {|| EdtAlbCli( cSerAlb + Str( nNumAlb ) + cSufAlb ) }

   ::oTree:Select( oNode )

   /*
   Preparamos la proxima factura-----------------------------------------------
   */

   ::SetNextFechaFactura()

   /*
   Escribe los datos pendientes------------------------------------------------
   */

   dbCommitAll()

   CommitTransaction()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CreaFactura() CLASS TCreaFacAutomaticas

   local cText
   local oNode
   local cSerFac
   local nNumFac
   local cSufFac
   local aTotFac
   local nImpAtp
   local nDtoArt
   local cCodPgo
   local hAtipica
   local hValue            := {=>}

   BeginTransaction()

   /*
   Cabecera del facturas-------------------------------------------------------
   */

   ::oFacCliT:Append()

   if ::oFacAutT:oDbf:lUseCli .and. !Empty( ::oDbfCli:cCodAlm )
      ::oFacCliT:cCodAlm   := ::oDbfCli:cCodAlm
   else
      ::oFacCliT:cCodAlm   := cDefAlm()
   end if

   /*
   Forma de pago del albarán---------------------------------------------------
   */

   if !Empty( ::oFacAutT:oDbf:cCodPago )
      cCodPgo              := ::oFacAutT:oDbf:cCodPago 
   end if 

   if Empty( cCodPgo ) .and. ::oFacAutT:oDbf:lUseCli .and. !Empty( ::oDbfCli:CodPago ) 
      cCodPgo              := ::oDbfCli:CodPago
   end if 

   if Empty( cCodPgo )
      cCodPgo              := cDefFpg()
   end if 

   ::oFacCliT:cCodPago     := cCodPgo

   /*
   Serie, numero y sufijo------------------------------------------------------
   */

   if !Empty( ::oFacAutT:oDbf:cSerFact )
      cSerFac              := ::oFacAutT:oDbf:cSerFact
   end if

   if ::oFacAutT:oDbf:lUseCli
      cSerFac              := oRetFld( ::oDbfCli:Cod, ::oDbfCli, "Serie" )
   end if

   if Empty( cSerFac )
      cSerFac              := cNewSer( "nFacCli", ::oDbfCount:cAlias )
   end if

   nNumFac                 := nNewDoc( cSerFac, ::oFacCliT:cAlias, "nFacCli", , ::oDbfCount:cAlias )
   cSufFac                 := RetSufEmp()

   ::oFacCliT:cTurFac      := cCurSesion()
   ::oFacCliT:dFecFac      := ::dFecDocumento
   ::oFacCliT:cCodCli      := ::oDbfCli:Cod
   ::oFacCliT:cCodCaj      := Application():CodigoCaja()
   ::oFacCliT:cNomCli      := ::oDbfCli:Titulo
   ::oFacCliT:cDirCli      := ::oDbfCli:Domicilio
   ::oFacCliT:cPobCli      := ::oDbfCli:Poblacion
   ::oFacCliT:cPrvCli      := ::oDbfCli:Provincia
   ::oFacCliT:cPosCli      := ::oDbfCli:CodPostal
   ::oFacCliT:cDniCli      := ::oDbfCli:Nif
   ::oFacCliT:lModCli      := ::oDbfCli:lModDat
   ::oFacCliT:lSndDoc      := .t.
   ::oFacCliT:cDivFac      := cDivEmp()
   ::oFacCliT:nVdvFac      := nChgDiv( cDivEmp(), ::oDbfDiv:cAlias )
   ::oFacCliT:lIvaInc      := uFieldEmpresa( "lIvaInc" )
   ::oFacCliT:cCodUsr      := Auth():Codigo()
   ::oFacCliT:dFecCre      := GetSysDate()
   ::oFacCliT:cTimCre      := Time()
   ::oFacCliT:nTarifa      := Max( uFieldEmpresa( "nPreVta" ), ::oDbfCli:nTarifa )
   ::oFacCliT:cCodDlg      := Application():CodigoDelegacion()
   ::oFacCliT:cDtoEsp      := if( ::oFacAutT:oDbf:lUseCli, ::oDbfCli:cDtoEsp, ::oFacAutT:oDbf:cDtoEsp )
   ::oFacCliT:nDtoEsp      := if( ::oFacAutT:oDbf:lUseCli, ::oDbfCli:nDtoEsp, ::oFacAutT:oDbf:nDtoEsp )
   ::oFacCliT:cDpp         := if( ::oFacAutT:oDbf:lUseCli, ::oDbfCli:cDpp,    ::oFacAutT:oDbf:cDpp )
   ::oFacCliT:nDpp         := if( ::oFacAutT:oDbf:lUseCli, ::oDbfCli:nDpp,    ::oFacAutT:oDbf:nDpp )
   ::oFacCliT:cDtoUno      := if( ::oFacAutT:oDbf:lUseCli, ::oDbfCli:cDtoUno, ::oFacAutT:oDbf:cDtoUno )
   ::oFacCliT:nDtoUno      := if( ::oFacAutT:oDbf:lUseCli, ::oDbfCli:nDtoCnt, ::oFacAutT:oDbf:nDtoUno )
   ::oFacCliT:cDtoDos      := if( ::oFacAutT:oDbf:lUseCli, ::oDbfCli:cDtoDos, ::oFacAutT:oDbf:cDtoDos )
   ::oFacCliT:nDtoDos      := if( ::oFacAutT:oDbf:lUseCli, ::oDbfCli:nDtoRap, ::oFacAutT:oDbf:nDtoDos )
   ::oFacCliT:nTipRet      := ::oDbfCli:nTipRet
   ::oFacCliT:nPctRet      := ::oDbfCli:nPctRet

   ::oFacCliT:cCodAge      := ::oDbfCli:cAgente
   ::oFacCliT:nPctComAge   := RetFld( ::oDbfCli:cAgente, ::oDbfAge:cAlias, "nCom1" )
   ::oFacCliT:cCodRut      := ::oDbfCli:cCodRut
   ::oFacCliT:cCodGrp      := ::oDbfCli:cCodGrp
   ::oFacCliT:cCodTrn      := ::oDbfCli:cCodTrn
   ::oFacCliT:nDtoAtp      := ::oDbfCli:nDtoAtp
   ::oFacCliT:nSbrAtp      := ::oDbfCli:nSbrAtp
   ::oFacCliT:lRecargo     := ::oDbfCli:lReq
   ::oFacCliT:nRegIva      := ::oDbfCli:nRegIva

   ::oFacCliT:cManObr      := ::oFacAutT:oDbf:cManObr
   ::oFacCliT:nIvaMan      := ::oFacAutT:oDbf:nIvaMan
   ::oFacCliT:nManObr      := ::oFacAutT:oDbf:nManObr

   hValue[ "cCodigoCliente"    ] := ::oDbfCli:Cod
   hValue[ "dFecha"            ] := ::dFecDocumento
   hValue[ "cCodigoGrupo"      ] := ::oDbfCli:cCodGrp
   hValue[ "lIvaIncluido"      ] := uFieldEmpresa( "lIvaInc" )
   hValue[ "nDescuentoTarifa"  ] := ::oDbfCli:nDtoArt
   hValue[ "nTarifaPrecio"     ] := Max( uFieldEmpresa( "nPreVta" ), ::oDbfCli:nTarifa )

   nDtoArt                 := oRetFld( ::oDbfCli:Cod, ::oDbfCli, "nDtoArt" )

   ::oFacCliT:cSerie       := cSerFac
   ::oFacCliT:nNumFac      := nNumFac
   ::oFacCliT:cSufFac      := cSufFac

   ::oFacCliT:Save()

   /*
   Líneas de facturas de clientes----------------------------------------------
   */

   if ::oFacAutL:oDbf:Seek( ::oFacAutT:oDbf:cCodFac )

      while ::oFacAutL:oDbf:cCodFac == ::oFacAutT:oDbf:cCodFac .and. !::oFacAutL:oDbf:Eof()

         ::oFacCliL:Append()

         ::oFacCliL:cSerie       := cSerFac
         ::oFacCliL:nNumFac      := nNumFac
         ::oFacCliL:cSufFac      := cSufFac
         ::oFacCliL:cRef         := ::oFacAutL:oDbf:cCodArt
         ::oFacCliL:cDetalle     := ::oFacAutL:oDbf:cDetalle
         ::oFacCliL:mLngDes      := ::oFacAutL:oDbf:mLngDes
         ::oFacCliL:cCodPr1      := ::oFacAutL:oDbf:cCodPr1
         ::oFacCliL:cCodPr2      := ::oFacAutL:oDbf:cCodPr2
         ::oFacCliL:cValPr1      := ::oFacAutL:oDbf:cValPr1
         ::oFacCliL:cValPr2      := ::oFacAutL:oDbf:cValPr2

         ::oFacCliL:cAlmLin      := ::oFacCliT:cCodAlm

         hValue[ "cCodigoArticulo"   ] := ::oFacAutL:oDbf:cCodArt
         hValue[ "cCodigoPropiedad1" ] := ::oFacAutL:oDbf:cCodPr1
         hValue[ "cCodigoPropiedad2" ] := ::oFacAutL:oDbf:cCodPr2
         hValue[ "cValorPropiedad1"  ] := ::oFacAutL:oDbf:cValPr1
         hValue[ "cValorPropiedad2"  ] := ::oFacAutL:oDbf:cValPr2

         if ::oDbfArt:Seek( ::oFacAutL:oDbf:cCodArt )

            ::oFacCliL:nPesoKg   := ::oDbfArt:nPesoKg
            ::oFacCliL:cPesoKg   := ::oDbfArt:cUnidad
            ::oFacCliL:nVolumen  := ::oDbfArt:nVolumen
            ::oFacCliL:cVolumen  := ::oDbfArt:cVolumen
            ::oFacCliL:cUnidad   := ::oDbfArt:cUnidad
            ::oFacCliL:lMsgVta   := ::oDbfArt:lMsgVta
            ::oFacCliL:lNotVta   := ::oDbfArt:lNotVta
            ::oFacCliL:nFacCnv   := ::oDbfArt:nFacCnv
            ::oFacCliL:cCodTip   := ::oDbfArt:cCodTip
            ::oFacCliL:cCodFam   := ::oDbfArt:Familia
            ::oFacCliL:cGrpFam   := RetFld( ::oDbfArt:Familia, ::oDbfFam:cAlias, "cCodGrp" )
            ::oFacCliL:nCtlStk   := ::oDbfArt:nCtlStock
            ::oFacCliL:nCosDiv   := nCosto( nil, ::oDbfArt:cAlias, ::oDbfKit:cAlias )

            hValue[ "cCodigoFamilia"    ] := ::oDbfArt:Familia

            if ( ::oFacAutT:oDbf:lUseCli )

               do case
               case nDtoArt == 1
                  ::oFacCliL:nDto   := ::oDbfArt:nDtoArt1

               case nDtoArt == 2
                  ::oFacCliL:nDto   := ::oDbfArt:nDtoArt2

               case nDtoArt == 3
                  ::oFacCliL:nDto   := ::oDbfArt:nDtoArt3

               case nDtoArt == 4
                  ::oFacCliL:nDto   := ::oDbfArt:nDtoArt4

               case nDtoArt == 5
                  ::oFacCliL:nDto   := ::oDbfArt:nDtoArt5

               case nDtoArt == 6
                  ::oFacCliL:nDto   := ::oDbfArt:nDtoArt6

               end case

            end if

         end if

         ::oFacCliL:nCanEnt      := ::oFacAutL:oDbf:nCajas
         ::oFacCliL:nUniCaja     := ::oFacAutL:oDbf:nUnidades
         ::oFacCliL:lKitArt      := ::oFacAutL:oDbf:lKitArt
         ::oFacCliL:lKitChl      := ::oFacAutL:oDbf:lKitChl
         ::oFacCliL:lKitPrc      := ::oFacAutL:oDbf:lKitPrc
         ::oFacCliL:nIva         := ::oFacAutL:oDbf:nIva
         ::oFacCliL:nReq         := nPorcentajeRE( ::oDbfIva:cAlias, ::oFacAutL:oDbf:nIva )      
         ::oFacCliL:nNumLin      := ::oFacAutL:oDbf:nNumLin

         ::oFacCliL:dFecha       := ::dFecDocumento
         ::oFacCliL:cTipMov      := cDefVta()
         ::oFacCliL:lIvaLin      := uFieldEmpresa( "lIvaInc" )
         ::oFacCliL:nTarLin      := Max( uFieldEmpresa( "nPreVta" ), ::oDbfCli:nTarifa )
         ::oFacCliL:cCodAge      := ::oDbfCli:cAgente
         ::oFacCliL:nComAge      := RetFld( ::oDbfCli:cAgente, ::oDbfAge:cAlias, "nCom1" )

         hValue[ "nCajas"            ] := ::oFacAutL:oDbf:nCajas
         hValue[ "nUnidades"         ] := ::oFacAutL:oDbf:nUnidades
         hValue[ "nTipoDocumento"    ] := FAC_CLI
         hValue[ "nView"             ] := ::nView

         if ::oFacAutL:oDbf:lPrcAtp

            /*
            Buscamos si existen atipicas de clientes------------------------------
            */

            hAtipica := hAtipica( hValue )

            if !Empty( hAtipica )
                  
               if hhaskey( hAtipica, "nImporte" )
                  if hAtipica[ "nImporte" ] != 0
                     ::oFacCliL:nPreUnit := hAtipica[ "nImporte" ]
                  end if
               end if

               if hhaskey( hAtipica, "nDescuentoPorcentual" )
                  if hAtipica[ "nDescuentoPorcentual" ] != 0
                     ::oFacCliL:nDto     := hAtipica[ "nDescuentoPorcentual" ]
                  end if   
               end if

               if hhaskey( hAtipica, "nDescuentoPromocional" )
                  if hAtipica[ "nDescuentoPromocional" ] != 0
                     ::oFacCliL:nDtoPrm  := hAtipica[ "nDescuentoPromocional" ]
                  end if
               end if

               if hhaskey( hAtipica, "nDescuentoLineal" )
                  if hAtipica[ "nDescuentoLineal" ] != 0
                     ::oFacCliL:nDtoDiv  := hAtipica[ "nDescuentoLineal" ]
                  end if
               end if

               if hhaskey( hAtipica, "nComisionAgente" )
                  if hAtipica[ "nComisionAgente" ] != 0
                     ::oFacCliL:nComAge  := hAtipica[ "nComisionAgente" ]
                  end if
               end if

            end if

         end if

         ::oFacCliL:Save()

         ::oFacAutL:oDbf:Skip()

      end while

   end if

   /*
   Calculo de totales----------------------------------------------------------
   */

   aTotFac                          := aTotFacCli( cSerFac + Str( nNumFac ) + cSufFac, ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oFacCliP:cAlias, ::oAntCliT:cAlias, cDivEmp() )

   if ::oFacCliT:Seek( cSerFac + Str( nNumFac ) + cSufFac )
      ::oFacCliT:Load()
      ::oFacCliT:nTotNet            := aTotFac[ 1 ]
      ::oFacCliT:nTotIva            := aTotFac[ 2 ]
      ::oFacCliT:nTotReq            := aTotFac[ 3 ]
      ::oFacCliT:nTotFac            := aTotFac[ 4 ]
      ::oFacCliT:Save()
   end if

   /*
   Anotamos en el tree y en el fichero log ------------------------------------
   */

   cText          := "Factura: " + cSerFac + "/" + AllTrim( Str( nNumFac ) ) + "/" + AllTrim( cSufFac ) + Space( 1 ) + ;
                     "Importe: " + AllTrim( Trans( nTotFacCli( cSerFac + Str( nNumFac ) + cSufFac, ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oFacCliP:cAlias, ::oAntCliT:cAlias ), ::cPorDiv ) ) + Space(1) + cSimDiv( cDivEmp(), ::oDbfDiv ) + Space( 1 ) + ;
                     "Cliente: " + AllTrim( ::oDbfCli:Cod ) + " - " + AllTrim( ::oDbfCli:Titulo )

   fWrite( ::hFilTxt, cText + CRLF )

   oNode          := ::oTree:Add( cText )
   oNode:bAction  := {|| EdtFacCli( cSerFac + Str( nNumFac ) + cSufFac ) }

   ::oTree:Select( oNode )

   /*
   Recibos de facturas de clientes---------------------------------------------
   */

   GenPgoFacCli( cSerFac + Str( nNumFac ) + cSufFac, ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::oFacCliP:cAlias, ::oAntCliT:cAlias, ::oDbfCli:cAlias, ::oDbfFPago:cAlias, ::oDbfDiv:cAlias, ::oDbfIva:cAlias )

   /*
   Estado de la factura--------------------------------------------------------
   */

   if ::oFacCliT:SeekInOrd( cSerFac + Str( nNumFac ) + cSufFac, "nNumFac" )
      ChkLqdFacCli( nil, ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::oFacCliP:cAlias, ::oAntCliT:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias )
   end if

   /*
   Preparamos la proxima factura-----------------------------------------------
   */

   ::SetNextFechaFactura()

   /*
   Escribe los datos pendientes------------------------------------------------
   */

   dbCommitAll()

   CommitTransaction()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lCompruebaFecha() CLASS TCreaFacAutomaticas

   local lReturn        := .f.

   if ::lChkIgnoraProcesado
      RETURN .t.
   end if

   if !Empty( ::oFacAutT:oDbf:dNexFac ) .and. ( ::oFacAutT:oDbf:dNexFac <= GetSysDate() )
      Return .t.
   end if 

   /*
   ::oFacAutI:oDbf:OrdScope( ::oFacAutT:oDbf:cCodFac )
   ::oFacAutI:oDbf:GoBottom()

   if !Empty( ::oFacAutI:oDbf:dFecha )

      // Facturacion automatica dia de la semana----------------------------------

      if ::oFacAutT:oDbf:lDiaSel

         if ::oFacAutI:oDbf:dFecha < GetSysDate()

            lReturn     := .t.

         else

            lReturn     := .f.

         end if

     else

         if Month( ::oFacAutI:oDbf:dFecha ) <= Month( ::oFacAutI:oDbf:dFecha )

            if Day( ::oFacAutI:oDbf:dFecha ) < ::oFacAutT:oDbf:nDiaFact .and. ::oFacAutT:oDbf:nDiaFact <= Day( GetSysDate() )
               lReturn  := .t.
            else
               lReturn  := .f.
            end if

         else

            lReturn     := .f.

         end if

      end if

   else

      lReturn           := .t.

   end if

   ::oFacAutI:oDbf:ClearScope()
   ::oFacAutI:oDbf:GoTop()
   */

RETURN ( lReturn )

//---------------------------------------------------------------------------//

METHOD ActionTree() CLASS TCreaFacAutomaticas

   local oTreeInforme   := ::oTree:GetItem()

   if !Empty( oTreeInforme ) .and. !Empty( oTreeInforme:bAction )
      Eval( oTreeInforme:bAction )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD SetNextFechaFactura()

   if ( ::oFacAutT:oDbf:nPerSel > 0 ) .and. !Empty( ::oFacAutT:oDbf:cPerSel )

      do case
         case Alltrim( ::oFacAutT:oDbf:cPerSel ) == "Día"
            ::oFacAutT:oDbf:FieldPutByName( "dNexFac", ( GetSysDate() + ::oFacAutT:oDbf:nPerSel ) )

         case Alltrim( ::oFacAutT:oDbf:cPerSel ) == "Semana"
            ::oFacAutT:oDbf:FieldPutByName( "dNexFac", ( GetSysDate() + ( ::oFacAutT:oDbf:nPerSel * 7 ) ) )

         case Alltrim( ::oFacAutT:oDbf:cPerSel ) == "Mes"
            ::oFacAutT:oDbf:FieldPutByName( "dNexFac", ( AddMonth( GetSysDate(), ::oFacAutT:oDbf:nPerSel ) ) )

         case Alltrim( ::oFacAutT:oDbf:cPerSel ) == "Año"
            ::oFacAutT:oDbf:FieldPutByName( "dNexFac", ( AddMonth( GetSysDate(), ( ::oFacAutT:oDbf:nPerSel * 12 ) ) ) )

      end case

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

Static Function lScanCodeInMemo( aCodigoGrupo, cMemoGrupo )

   local lScanCodeInMemo   := .f.

   aEval( aCodigoGrupo, {|c| if( !lScanCodeInMemo, lScanCodeInMemo := c $ cMemoGrupo, .t. ) } )

Return ( lScanCodeInMemo )

//---------------------------------------------------------------------------//