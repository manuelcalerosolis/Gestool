#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//----------------------------------------------------------------------------//

CLASS TCentroCoste FROM TMant

   DATA cMru               INIT     "gc_folder_open_money_16"
   DATA cName              INIT     "CentroCoste"

   DATA aTipo              INIT {   "Clientes", "Art�culos", "Proveedores" }
   DATA cTipo              INIT     "Art�culos"
   DATA oTipo

   DATA cGetDocument
   DATA oGetDocument

   DATA hValid             INIT {=>}
   DATA hHelp              INIT {=>}

   DATA oCodPrp1
   DATA oCodPrp2
   DATA oValPrp1
   DATA oValPrp2

   METHOD New()
   METHOD Create()

   METHOD Default()

	METHOD DefineFiles( cPath, cDriver )

   METHOD Activate()

	METHOD Resource( nMode )

	METHOD lPreSave( oGet, oDlg, nMode )

   METHOD loadValues()

	METHOD validCodigo( oGet, cCodigo, nMode )

	METHOD validName( cNombre )							INLINE ( iif( empty( cNombre ),;
																	( msgStop( "La descripci�n del centro de coste no puede estar vac�a." ), .f. ),;
																	.t. ) )
   METHOD loadGet()

   METHOD clearGet()

   METHOD SearchToUuid()

END CLASS

//----------------------------------------------------------------------------//

METHOD New( cPath, cDriver, oWndParent, oMenuItem )

   DEFAULT cPath        := cPatDat()
   DEFAULT cDriver      := cDriver()
   DEFAULT oWndParent   := oWnd()

   ::Super:New( cPath, cDriver, oWndParent, oMenuItem )

   ::Default()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD Create( cPath, cDriver )

   DEFAULT cPath        := cPatDat()
   DEFAULT cDriver      := cDriver()

   ::Super:Create( cPath, cDriver )

   ::Default()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD Default()

   ::hValid             := {  "Clientes"     => {|| cClient( ::oGetDocument, , ::oGetDocument:oHelpText ) } ,;
                              "Art�culos"    => {|| cArticulo( ::oGetDocument, , ::oGetDocument:oHelpText ) } ,;
                              "Proveedores"  => {|| cProvee( ::oGetDocument, , ::oGetDocument:oHelpText ) } }

   ::hHelp              := {  "Clientes"     => {|| BrwClient( ::oGetDocument, ::oGetDocument:oHelpText ) } ,;
                              "Art�culos"    => {|| BrwArticulo( ::oGetDocument, ::oGetDocument:oHelpText ) } ,;
                              "Proveedores"  => {|| BrwProvee( ::oGetDocument, ::oGetDocument:oHelpText ) } }

Return ( Self )

//---------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE DATABASE ::oDbf FILE "CCoste.Dbf" CLASS "CENTROCOSTE" PATH ( cPath ) VIA ( cDriver ) COMMENT "Centro de coste"

   	FIELD NAME "cCodigo"   TYPE "C" LEN   9  DEC 0  COMMENT "C�digo"  				DEFAULT Space(  9 )  					  				         COLSIZE 80  OF ::oDbf
   	FIELD NAME "cNombre"   TYPE "C" LEN  50  DEC 0  COMMENT "Nombre"  				DEFAULT Space( 50 )  					  				         COLSIZE 200 OF ::oDbf
   	FIELD NAME "nVentas"   TYPE "N" LEN  15  DEC 6  COMMENT "Objetivo de Ventas"  						 PICTURE cPorDiv()	  ALIGN RIGHT  	COLSIZE 150 OF ::oDbf
   	FIELD NAME "nCompras"  TYPE "N" LEN  15  DEC 6  COMMENT "Objetivo de compras"  						 PICTURE cPirDiv()	  ALIGN RIGHT	   COLSIZE 150 OF ::oDbf
      FIELD NAME "nTipoDoc"  TYPE "N" LEN   2  DEC 0  COMMENT "Tipo documento asociado"                HIDE  OF ::oDbf
      FIELD NAME "cCodDoc"   TYPE "C" LEN  30  DEC 0  COMMENT "Documento asociado"                     HIDE  OF ::oDbf
      FIELD NAME "cCodPr1"   TYPE "C" LEN  20  DEC 0  COMMENT "C�digo de primera propiedad"            HIDE  OF ::oDbf
      FIELD NAME "cCodPr2"   TYPE "C" LEN  20  DEC 0  COMMENT "C�digo de segunda propiedad"            HIDE  OF ::oDbf
      FIELD NAME "cValPr1"   TYPE "C" LEN  20  DEC 0  COMMENT "Valor de primera propiedad"             HIDE  OF ::oDbf
      FIELD NAME "cValPr2"   TYPE "C" LEN  20  DEC 0  COMMENT "Valor de segunda propiedad"             HIDE  OF ::oDbf
      FIELD NAME "dFecIni"   TYPE "D" LEN   8  DEC 0  COMMENT "Fecha de inicio"                              OF ::oDbf
      FIELD NAME "dFecFin"   TYPE "D" LEN   8  DEC 0  COMMENT "Fecha de fin"                                 OF ::oDbf
      FIELD NAME "cComent"   TYPE "C" LEN 200  DEC 0  COMMENT "Comentario"                                   OF ::oDbf
      FIELD NAME "uuid"      TYPE "C" LEN  40  DEC 0  COMMENT "Identificador UUID"                     HIDE  OF ::oDbf

   	INDEX TO "CCoste.CDX" TAG "cCodigo" ON "cCodigo" COMMENT "C�digo" NODELETED OF ::oDbf
   	INDEX TO "CCoste.CDX" TAG "cNombre" ON "cNombre" COMMENT "Nombre" NODELETED OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//----------------------------------------------------------------------------//

METHOD Activate() CLASS TCentroCoste

   local oScript

   if nAnd( ::nLevel, 1 ) == 0
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
      ::lOpenFiles      := ::OpenFiles()
   end if

   /*
   Creamos el Shell
   */

   if ::lOpenFiles

      if !::lCreateShell
         ::CreateShell( ::nLevel )
      end if

      if ::lAutoButtons

         ::oWndBrw:GralButtons( Self )
         
         DEFINE BTNSHELL oScript RESOURCE "gc_folder_document_" GROUP OF ::oWndBrw ;
            NOBORDER ;
            ACTION   ( oScript:Expand() ) ;
            TOOLTIP  "Scripts" ;

            ImportScript( ::oWndBrw, oScript, "CentroCoste", Self )

         ::oWndBrw:EndButtons( Self )

      end if

      if ::cHtmlHelp != nil
         ::oWndBrw:cHtmlHelp  := ::cHtmlHelp
      end if

      ::oWndBrw:Activate( nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, {|| ::CloseFiles() } )

   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Resource( nMode ) 

	local oDlg
	local oGetCodigo
   local oBmp
   local oSayPrp1
   local cSayPrp1
   local oSayPrp2
   local cSayPrp2
   local oSayVal1
   local cSayVal1
   local oSayVal2
   local cSayVal2

   ::loadValues()

	DEFINE DIALOG oDlg RESOURCE "CentroCoste" TITLE LblTitle( nMode ) + "centro de coste"

      REDEFINE BITMAP oBmp ;
         RESOURCE "gc_folder_money_48" ;
         ID       800 ;
         TRANSPARENT ;
         OF       oDlg ;

   	REDEFINE GET oGetCodigo ;
         VAR      ::oDbf:cCodigo ;
         ID 		100 ;
         WHEN     ( nMode == APPD_MODE ) ;
         PICTURE 	"@!" ;
         OF 		oDlg

   	REDEFINE GET ::oDbf:cNombre ;
         ID 		110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF 		oDlg

      REDEFINE GET ::oCodPrp1 VAR ::oDbf:cCodPr1 ;
         ID       270 ;
         PICTURE  "@!" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         OF       oDlg

         ::oCodPrp1:bValid    := {|| cProp( ::oCodPrp1, oSayPrp1 ) }
         ::oCodPrp1:bHelp     := {|| brwProp( ::oCodPrp1, oSayPrp1 ) }

      REDEFINE GET oSayPrp1 VAR cSayPrp1 ;
         ID       271 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE GET ::oValPrp1 VAR ::oDbf:cValPr1 ;
         ID       280 ;
         PICTURE  "@!" ;
         WHEN     ( !Empty( ::oDbf:cCodPr1 ) .and. nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         OF       oDlg

         ::oValPrp1:bValid    := {|| lPrpAct( ::oValPrp1, oSayVal1, ::oDbf:cCodPr1 ) }
         ::oValPrp1:bhelp     := {|| brwPropiedadActual( ::oValPrp1, oSayVal1, ::oDbf:cCodPr1 ) }

      REDEFINE GET oSayVal1 VAR cSayVal1 ;
         ID       281 ;
         WHEN     ( .f. );
         OF       oDlg

      REDEFINE GET ::oCodPrp2 VAR ::oDbf:cCodPr2 ;
         ID       290 ;
         PICTURE  "@!" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON HELP  brwProp( ::oCodPrp2, oSayPrp2 ) ;
         BITMAP   "LUPA" ;
         OF       oDlg

         ::oCodPrp2:bValid    := {|| cProp( ::oCodPrp2, oSayPrp2 ) }
         ::oCodPrp2:bhelp     := {|| brwProp( ::oCodPrp2, oSayPrp2 ) }

      REDEFINE GET oSayPrp2 VAR cSayPrp2 ;
         ID       291 ;
         WHEN     ( .f. ) ;
         OF       oDlg   

      REDEFINE GET ::oValPrp2 VAR ::oDbf:cValPr2 ;
         ID       300 ;
         PICTURE  "@!" ;
         WHEN     ( !Empty( ::oDbf:cCodPr2 ) .and. nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         OF       oDlg

         ::oValPrp2:bValid    := {|| lPrpAct( ::oValPrp2, oSayVal2, ::oDbf:cCodPr2 ) }
         ::oValPrp2:bhelp     := {|| brwPropiedadActual( ::oValPrp2, oSayVal2, ::oDbf:cCodPr2 ) }

      REDEFINE GET oSayVal2 VAR cSayVal2 ;
         ID       301 ;
         WHEN     ( .f. );
         OF       oDlg

      REDEFINE GET ::oDbf:dFecIni ;
         ID       170 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg   

      REDEFINE GET ::oDbf:dFecFin ;
         ID       180 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg
      
      REDEFINE GET ::oDbf:cComent ;
         ID       310 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oDbf:nVentas ;
         ID 		120 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  ( cPorDiv() );
         OF 		oDlg

      REDEFINE GET ::oDbf:nCompras ;
         ID 		130 ;
         WHEN     ( nMode != ZOOM_MODE ) ; 
         PICTURE  ( cPirDiv() );
         OF 		oDlg

      REDEFINE COMBOBOX ::oTipo ;
         VAR      ::cTipo ;
         ITEMS    ::aTipo ;
         ID       140 ;
         WHEN     ( nMode != ZOOM_MODE ) ; 
         OF       oDlg

         ::oTipo:bChange   := {|| ::clearGet(), ::loadGet() }

      REDEFINE GET ::oGetDocument ;
         VAR      ::cGetDocument ;
         ID       150 ;
         IDTEXT   160 ;
         BITMAP   "LUPA" ;
         WHEN     ( nMode != ZOOM_MODE ) ; 
         OF       oDlg

   	REDEFINE BUTTON ;
         ID       IDOK ;
         OF 		oDlg ;
      	WHEN     (  nMode != ZOOM_MODE ) ;
      	ACTION   (  ::lPreSave( oGetCodigo, oDlg, nMode ) )

   	REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF 		oDlg ;
         CANCEL ;
         ACTION 	( oDlg:end() )

   	if nMode != ZOOM_MODE
      	oDlg:AddFastKey( VK_F5, {|| ::lPreSave( oGetCodigo, oDlg, nMode ) } )
   	end if

   	oDlg:bStart    := {|| ::LoadGet(), ::oGetDocument:lValid(), oGetCodigo:SetFocus(), ::oCodPrp1:lValid(), ::oCodPrp2:lValid(), ::oValPrp1:lValid(), ::oValPrp2:lValid() }

	ACTIVATE DIALOG oDlg	CENTER

   if !Empty( oBmp )
      oBmp:End()
   end if

RETURN ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//

METHOD lPreSave( oGetCodigo, oDlg, nMode )

	if !::validCodigo( oGetCodigo, ::oDbf:cCodigo, nMode )
		Return .f.
	endif

	if !::validName( ::oDbf:cNombre )
		Return .f.
	endif

   if !::oGetDocument:lValid()
      Return .f.
   end if

   ::oDbf:nTipoDoc   := ::oTipo:nAt
   ::oDbf:cCodDoc    := ::oGetDocument:varGet()

Return ( oDlg:end( IDOK ) )

//---------------------------------------------------------------------------//

METHOD validCodigo( oGet, cCodigo, nMode )

	if nMode == APPD_MODE .or. nMode == DUPL_MODE

   	if ::oDbf:SeekInOrd( cCodigo, "cCodigo" )
      	MsgStop( "El c�digo introducido ya existe: " + ::oDbf:cCodigo )
      	Return .f.
      	oGet:SetFocus()
   	end if

	end if

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD loadValues()

   ::cTipo                 := ::aTipo[ Max( ::oDbf:nTipoDoc, 1 ) ]
   ::cGetDocument          := ::oDbf:cCodDoc

Return .t.

//---------------------------------------------------------------------------//

METHOD loadGet()

   ::oGetDocument:bValid  := hGet( ::hValid, ::cTipo )
   ::oGetDocument:bHelp   := hGet( ::hHelp, ::cTipo )

Return .t.

//---------------------------------------------------------------------------//

METHOD clearGet()

   ::oGetDocument:cText( Space( 30 ) )
   ::oGetDocument:oHelpText:cText( Space( 200 ) )

Return .t.

//---------------------------------------------------------------------------//

METHOD SearchToUuid()

   local cCodigo  := ::Buscar()

   if Empty( cCodigo )
      Return ( "" )
   end if

Return ( oRetFld( cCodigo, ::oDbf, "Uuid", "cCodigo" ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

Function SynCentroCoste()

   local oBlock
   local oError
   local dbfCentroCoste

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatDat() + "CCoste.DBF" ) NEW VIA ( cDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "CCoste", @dbfCentroCoste ) )
   SET ADSINDEX TO ( cPatDat() + "CCoste.CDX" ) ADDITIVE

   /*
   Cabeceras-------------------------------------------------------------------
   */

   ( dbfCentroCoste )->( dbGoTop() )

   while !( dbfCentroCoste )->( eof() )

      if empty( ( dbfCentroCoste )->uuid )
         ( dbfCentroCoste )->uuid          := win_uuidcreatestring()
      end if

      ( dbfCentroCoste )->( dbSkip() )

   end while

   RECOVER USING oError

      msgstop( "Imposible abrir todas las bases de datos de centros de coste" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE ( dbfCentroCoste )

return nil

//---------------------------------------------------------------------------//
