#include "FiveWin.Ch"
#include "Font.ch"
#include "Report.ch"
#include "Factu.ch" 

static oWndBrw
static dbfObrasT

static bEdit         := {| aBlank, aoGet, dbfObrasT, oBrw, bWhen, bValid, nMode, cCodCli | EdtRec( aBlank, aoGet, dbfObrasT, oBrw, bWhen, bValid, nMode, cCodCli ) }

static aTipoObra     := { "Defecto", "Envio", "Factura", "Otras" }

//--------------------------------------------------------------------------//
//Funciones del programa
//--------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aBlank, aoGet, dbfObrasT, oBrw, bWhen, bValid, nMode, cCodCli )

	local oDlg
	local oGet
   local oGet2

   if nMode == APPD_MODE .AND. !Empty( cCodCli )
      aBlank[ ( dbfObrasT )->( FieldPos( "CCODCLI" ) ) ] := cCodCli
   end if

   DEFINE DIALOG oDlg RESOURCE "OBRAS" TITLE LblTitle( nMode ) + "direcciones de clientes"

      REDEFINE GET oGet VAR aBlank[ ( dbfObrasT )->( FieldPos( "CCODOBR" ) ) ] ;
			ID 		120 ;
			WHEN 		( nMode == APPD_MODE ) ;
         VALID    ( If ( nMode == APPD_MODE, ChkObra( oGet, cCodCli, dbfObrasT ), .t. ) ) ;
			COLOR 	CLR_GET ;
			OF 		oDlg

      REDEFINE GET oGet2 VAR aBlank[ ( dbfObrasT )->( FieldPos( "CNOMOBR" ) ) ] ;
			ID 		130 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			PICTURE 	"@!" ;
			OF 		oDlg

      REDEFINE GET aBlank[ ( dbfObrasT )->( FieldPos( "CDIROBR" ) ) ] ;
			ID 		140 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

		REDEFINE GET aBlank[ (dbfObrasT)->( FieldPos( "CPOBOBR" ) ) ] ;
			ID 		150 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

		REDEFINE GET aBlank[ (dbfObrasT)->( FieldPos( "CPRVOBR" ) ) ] ;
			ID 		160 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

		REDEFINE GET aBlank[ (dbfObrasT)->( FieldPos( "CPOSOBR" ) ) ] ;
			ID 		170 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

		REDEFINE GET aBlank[ (dbfObrasT)->( FieldPos( "CTELOBR" ) ) ] ;
			ID 		180 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

		REDEFINE GET aBlank[ (dbfObrasT)->( FieldPos( "CFAXOBR" ) ) ] ;
			ID 		190 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET aBlank[ (dbfObrasT)->( FieldPos( "CCODEDI" ) ) ] ;
         ID       230 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aBlank[ (dbfObrasT)->( FieldPos( "CDEPARTA" ) ) ] ;
         ID       250 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aBlank[ (dbfObrasT)->( FieldPos( "CPROVEE" ) ) ] ;
         ID       260 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aBlank[ (dbfObrasT)->( FieldPos( "CCODBIC" ) ) ] ;
         ID       231 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aBlank[ (dbfObrasT)->( FieldPos( "CHORARIO" ) ) ] ;
         ID       232;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aBlank[ (dbfObrasT)->( FieldPos( "CESTOBR" ) ) ] ;
         ID       240 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE CHECKBOX aBlank[ (dbfObrasT)->( FieldPos( "LDEFOBR" ) ) ] ;
         ID       220 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aBlank[ ( dbfObrasT )->( FieldPos( "CCNTOBR" ) ) ] ;
         ID       200 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET aBlank[ ( dbfObrasT )->( FieldPos( "CMOVOBR" ) ) ] ;
         ID       210 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET aBlank[ ( dbfObrasT )->( FieldPos( "cCodPos" ) ) ] ;
         ID       300 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET aoGet[ ( dbfObrasT )->( FieldPos( "Nif" ) ) ] ;
         VAR      aBlank[ ( dbfObrasT )->( FieldPos( "Nif" ) ) ] ;
         ID       310 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aoGet[ ( dbfObrasT )->( FieldPos( "cDomEnt" ) ) ] ;
         VAR      aBlank[ ( dbfObrasT )->( FieldPos( "cDomEnt" ) ) ] ;
         ID       320 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg
         
      REDEFINE GET aoGet[ ( dbfObrasT )->( FieldPos( "cPobEnt" ) ) ] ;
         VAR      aBlank[ ( dbfObrasT )->( FieldPos( "cPobEnt" ) ) ] ;
         ID       330 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aoGet[ ( dbfObrasT )->( FieldPos( "cCPEnt" ) ) ] ;
         VAR      aBlank[ ( dbfObrasT )->( FieldPos( "cCPEnt" ) ) ] ;
         ID       340 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aoGet[ ( dbfObrasT )->( FieldPos( "cPrvEnt" ) ) ] ;
         VAR      aBlank[ ( dbfObrasT )->( FieldPos( "cPrvEnt" ) ) ] ;
         ID       350 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg   

      REDEFINE COMBOBOX aoGet[ ( dbfObrasT )->( FieldPos( "cTipo" ) ) ] ;
         VAR      aBlank[ ( dbfObrasT )->( FieldPos( "cTipo" ) ) ] ;
         ID       360 ;
         ITEMS    aTipoObra ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( EndTrans( aBlank, aoGet, dbfObrasT, oBrw, nMode, oDlg, oGet, oGet2 ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

      if nMode != ZOOM_MODE
         oDlg:AddFastKey( VK_F5, {|| EndTrans( aBlank, aoGet, dbfObrasT, oBrw, nMode, oDlg, oGet, oGet2 ) } )
      end if

      oDlg:AddFastKey( VK_F1, {|| ChmHelp( "Clientes" ) } )

	ACTIVATE DIALOG oDlg ON PAINT ( oGet:lValid() ) CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Static Function EndTrans( aBlank, aoGet, dbfObrasT, oBrw, nMode, oDlg, oGet, oGet2 )

   local nRec  := ( dbfObrasT )->( Recno() )

   if nMode == APPD_MODE .or. nMode == DUPL_MODE

      if Empty( aBlank[ ( dbfObrasT )->( FieldPos( "CCODOBR" ) ) ] )
         MsgStop( "Código no puede estar vacío" )
         oGet:SetFocus()
         return nil
      end if

   end if

   if Empty( aBlank[ ( dbfObrasT )->( FieldPos( "CNOMOBR" ) ) ] )
      MsgStop( "Nombre no puede estar vacío" )
      oGet2:SetFocus()
      return nil
   end if

   if aBlank[ ( dbfObrasT )->( FieldPos( "LDEFOBR" ) ) ]

      ( dbfObrasT )->( dbGoTop() )

      while !( dbfObrasT )->( Eof() )

         if dbLock( dbfObrasT )
            ( dbfObrasT )->lDefObr := .f.
            ( dbfObrasT )->( dbUnlock() )
         end if

         ( dbfObrasT )->( dbSkip() )

      end while

   end if

   ( dbfObrasT )->( dbGoTo( nRec ) )

   WinGather( aBlank, aoGet, dbfObrasT, oBrw, nMode )

   oBrw:Refresh()

Return ( oDlg:end( IDOK ) )

//--------------------------------------------------------------------------//

STATIC FUNCTION OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   USE ( cPatCli() + "ObrasT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "OBRAST", @dbfObrasT ) )
   SET ADSINDEX TO ( cPatCli() + "ObrasT.Cdx" ) ADDITIVE

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      CloseFiles()
      lOpen       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles()

   if oWndBrw != nil
      oWndBrw  := nil
   end if

   if !Empty( dbfObrasT )
      ( dbfObrasT )->( dbCloseArea() )
   end if

   dbfObrasT   := nil

RETURN ( .T. )

//----------------------------------------------------------------------------//

FUNCTION retObras( cCodCli, cCodObr, dbfObrasT )

   local lClose   := .f.
	local cTemp		:= Space( 30 )

	IF ( dbfObrasT ) == NIL
      USE ( cPatEmp() + "" + "OBRAST" + ".DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "OBRAST", @dbfObrasT ) )
      SET ADSINDEX TO ( cPatEmp() + "" + "OBRAST" + ".CDX" ) ADDITIVE
      lClose      := .t.
	END IF

   IF ( dbfObrasT )->( DbSeek( cCodCli + cCodObr ) )
      cTemp       := ( dbfObrasT )->cNomObr
   END IF

	IF lClose
		CLOSE ( dbfObrasT )
	END IF

RETURN cTemp

//---------------------------------------------------------------------------//

FUNCTION AppObras( cCodCli, dbfObrasT, oBrw )

   WinAppRec( oBrw, bEdit, dbfObrasT, nil, nil, cCodCli )

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION EdtObras( cCodCli, cCodObr, dbfObrasT, oBrw, lControl )

   local nLevel   := Auth():Level( "01032" )

   DEFAULT cCodObr   := ( dbfObrasT )->cCodObr
   DEFAULT lControl  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_EDIT ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lControl
      WinEdtRec( oBrw, bEdit, dbfObrasT, nil, nil, cCodCli )
   else

      if ( dbfObrasT )->( dbSeek( cCodCli + cCodObr ) )
         WinEdtRec( oBrw, bEdit, dbfObrasT, nil, nil, cCodCli )
      else
         MsgStop( "No se encuentra la dirección" )
      end if

   end if

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION ZoomObras( dbfObrasT, oBrw )

   WinZooRec( oBrw, bEdit, dbfObrasT )

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION delObras( dbfObrasT, oBrw )

   if dbDelRec( oBrw, dbfObrasT )
      oBrw:Refresh()
   end if

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION ChkObra( oGet, cCodCli, dbfObrasT )

	local lFound
	local xValor
	local nRecno   := ( dbfObrasT )->( RecNo() )

	xValor			:= cCodCli + oGet:varGet()
   lFound         := ( dbfObrasT )->( dbSeek( xValor ) )

   ( dbfObrasT )->( dbGoTo( nRecno ) )

   if lFound
		MsgStop( "Obra ya existe" )
   end if

RETURN ( !lFound )

//--------------------------------------------------------------------------//

function PredObras( dbfTmpObr, oBrwObr )

   local nRec  := ( dbfTmpObr )->( Recno() )

   if !( dbfTmpObr )->lDefObr

      ( dbfTmpObr )->( dbGoTop() )

      while !( dbfTmpObr )->( Eof() )

         if dbLock( dbfTmpObr )
            ( dbfTmpObr )->lDefObr := .f.
            ( dbfTmpObr )->( dbUnlock() )
         end if

         ( dbfTmpObr )->( dbSkip() )

      end while

      ( dbfTmpObr )->( dbGoTo( nRec ) )

      if dbLock( dbfTmpObr )
         ( dbfTmpObr )->lDefObr := .t.
         ( dbfTmpObr )->( dbUnlock() )
      end if

   end if

   oBrwObr:Refresh()

return ( .t. )

//---------------------------------------------------------------------------//

function cObraDir( cCodCli, dbfClient, dbfObrasT )

   local cDireccion     := ""
   local nRecObr        := ( dbfObrasT )->( Recno() )
   local nRecCli        := ( dbfClient )->( Recno() )

   if dbSeekInOrd( cCodCli, "LDEFOBR", dbfObrasT )

      cDireccion  := ( dbfObrasT )->cDirObr

   end if

   if Empty( cDireccion ) .and. dbSeekInOrd( cCodCli, "COD", dbfClient )

      cDireccion     := ( dbfClient )->Domicilio

   end if

   ( dbfObrasT )->( dbGoTo( nRecObr ) )
   ( dbfClient )->( dbGoTo( nRecCli ) )

return ( cDireccion )

//---------------------------------------------------------------------------//

function cObraPob( cCodCli, dbfClient, dbfObrasT )

   local cPoblacion     := ""
   local nRecObr        := ( dbfObrasT )->( Recno() )
   local nRecCli        := ( dbfClient )->( Recno() )

   if dbSeekInOrd( cCodCli, "LDEFOBR", dbfObrasT )

      cPoblacion  := ( dbfObrasT )->cPobObr

   end if

   if Empty( cPoblacion ) .and. dbSeekInOrd( cCodCli, "COD", dbfClient )

      cPoblacion     := ( dbfClient )->Poblacion

   end if

   ( dbfObrasT )->( dbGoTo( nRecObr ) )
   ( dbfClient )->( dbGoTo( nRecCli ) )

return ( cPoblacion )

//---------------------------------------------------------------------------//

function cObraPrv( cCodCli, dbfClient, dbfObrasT )

   local cProvincia     := ""
   local nRecObr        := ( dbfObrasT )->( Recno() )
   local nRecCli        := ( dbfClient )->( Recno() )

   if dbSeekInOrd( cCodCli, "LDEFOBR", dbfObrasT )

      cProvincia  := ( dbfObrasT )->cPrvObr

   end if

   if Empty( cProvincia ) .and. dbSeekInOrd( cCodCli, "COD", dbfClient )

      cProvincia     := ( dbfClient )->Provincia

   end if

   ( dbfObrasT )->( dbGoTo( nRecObr ) )
   ( dbfClient )->( dbGoTo( nRecCli ) )

return ( cProvincia )

//---------------------------------------------------------------------------//

function cObraPos( cCodCli, dbfClient, dbfObrasT )

   local cCodPostal     := ""
   local nRecObr        := ( dbfObrasT )->( Recno() )
   local nRecCli        := ( dbfClient )->( Recno() )

   if dbSeekInOrd( cCodCli, "LDEFOBR", dbfObrasT )
      cCodPostal        := ( dbfObrasT )->cPosObr
   end if

   if Empty( cCodPostal ) .and. dbSeekInOrd( cCodCli, "COD", dbfClient )
      cCodPostal        := ( dbfClient )->CodPostal
   end if

   ( dbfObrasT )->( dbGoTo( nRecObr ) )
   ( dbfClient )->( dbGoTo( nRecCli ) )

return ( cCodPostal )

//---------------------------------------------------------------------------//

function cObraNbr( cCodCli, dbfClient, dbfObrasT )

   local cNombre        := ""
   local nRecObr        := ( dbfObrasT )->( Recno() )
   local nRecCli        := ( dbfClient )->( Recno() )

   if dbSeekInOrd( cCodCli, "LDEFOBR", dbfObrasT )

      cNombre           := ( dbfObrasT )->cNomObr

   end if

   if Empty( cNombre ) .and. dbSeekInOrd( cCodCli, "COD", dbfClient )

      cNombre           := ( dbfClient )->Titulo

   end if

   ( dbfObrasT )->( dbGoTo( nRecObr ) )
   ( dbfClient )->( dbGoTo( nRecCli ) )

return ( cNombre )

//---------------------------------------------------------------------------//

Function aCalObrCli()

   local aCalObrCli  := {}

   aAdd( aCalObrCli, { "cObraNbr( ( cDbfCli )->Cod, cDbfCli, cDbfObr )",  "C", 100, 0, "Nombre defecto",        "",  "Nombre",      "" } )
   aAdd( aCalObrCli, { "cObraDir( ( cDbfCli )->Cod, cDbfCli, cDbfObr )",  "C", 100, 0, "Domicilio defecto",     "",  "Domicilio",   "" } )
   aAdd( aCalObrCli, { "cObraPob( ( cDbfCli )->Cod, cDbfCli, cDbfObr )",  "C", 100, 0, "Población defecto",     "",  "Población",   "" } )
   aAdd( aCalObrCli, { "cObraPrv( ( cDbfCli )->Cod, cDbfCli, cDbfObr )",  "C",  20, 0, "Provincia defecto",     "",  "Provincia",   "" } )
   aAdd( aCalObrCli, { "cObraPos( ( cDbfCli )->Cod, cDbfCli, cDbfObr )",  "C",  20, 0, "Código postal defecto", "",  "Cód. postal", "" } )

Return ( aCalObrCli )

//---------------------------------------------------------------------------//

FUNCTION aItmObr()

   local aItmObr  := {}

   aAdd( aItmObr, { "cCodCli",   "C",   12,    0, "" ,                                 "",                  "", "( cDbfObr )" } )
   aAdd( aItmObr, { "cCodObr",   "C",   10,    0, "Código de la dirección" ,           "",                  "", "( cDbfObr )" } )
   aAdd( aItmObr, { "cNomObr",   "C",  150,    0, "Nombre de la dirección" ,           "'@!'",              "", "( cDbfObr )" } )
   aAdd( aItmObr, { "cDirObr",   "C",  100,    0, "Domicilio de la dirección" ,        "'@!'",              "", "( cDbfObr )" } )
   aAdd( aItmObr, { "cPobObr",   "C",  100,    0, "Población de la dirección" ,        "'@!'",              "", "( cDbfObr )" } )
   aAdd( aItmObr, { "cPrvObr",   "C",   20,    0, "Provincia de la dirección" ,        "'@!'",              "", "( cDbfObr )" } )
   aAdd( aItmObr, { "cPosObr",   "C",   10,    0, "Código postal de la dirección" ,    "'@!'",              "", "( cDbfObr )" } )
   aAdd( aItmObr, { "cTelObr",   "C",   17,    0, "Teléfono de la dirección" ,         "",                  "", "( cDbfObr )" } )
   aAdd( aItmObr, { "cFaxObr",   "C",   17,    0, "Fax de la dirección" ,              "",                  "", "( cDbfObr )" } )
   aAdd( aItmObr, { "cCntObr",   "C",  100,    0, "Contacto de la dirección" ,         "'@!'",              "", "( cDbfObr )" } )
   aAdd( aItmObr, { "cMovObr",   "C",   17,    0, "Móvil de la dirección" ,            "",                  "", "( cDbfObr )" } )
   aAdd( aItmObr, { "lDefObr",   "L",    1,    0, "Lógico de dirección por defecto" ,  "",                  "", "( cDbfObr )" } )
   aAdd( aItmObr, { "cCodEdi",   "C",   17,    0, "Código del cliente en EDI (EAN)",   "",                  "", "( cDbfObr )" } )
   aAdd( aItmObr, { "cCodWeb",   "N",   11,    0, "Codigo para la web             ",   "",                  "", "( cDbfObr )" } )
   aAdd( aItmObr, { "cEstObr",   "C",   35,    0, "Nombre del establecimiento     ",   "",                  "", "( cDbfObr )" } )
   aAdd( aItmObr, { "cCodPos",   "C",   12,    0, "Número operacional" ,               "",                  "", "( cDbfObr )" } )
   aAdd( aItmObr, { "cDeparta",  "C",    4,    0, "Departamento" ,                     "",                  "", "( cDbfObr )" } )
   aAdd( aItmObr, { "Nif",       "C",   30,    0, "Nif de la dirección" ,              "",                  "", "( cDbfObr )" } )
   aAdd( aItmObr, { "cDomEnt",   "C",  200,    0, "Domicilio de entrega" ,             "",                  "", "( cDbfObr )" } )
   aAdd( aItmObr, { "cPobEnt",   "C",  200,    0, "Población de entrega" ,             "",                  "", "( cDbfObr )" } )
   aAdd( aItmObr, { "cCPEnt",    "C",   15,    0, "Código postal de entrega" ,         "",                  "", "( cDbfObr )" } )
   aAdd( aItmObr, { "cPrvEnt",   "C",  100,    0, "Provincia de entrega" ,             "",                  "", "( cDbfObr )" } )
   aAdd( aItmObr, { "cProvee",   "C",   50,    0, "Código de proveedor" ,              "",                  "", "( cDbfObr )" } )
   aAdd( aItmObr, { "cCodBic",   "C",   50,    0, "Código Bic" ,                       "",                  "", "( cDbfObr )" } )
   aAdd( aItmObr, { "cHorario",  "C",   50,    0, "Horario" ,                          "",                  "", "( cDbfObr )" } )
   aAdd( aItmObr, { "cTipo",     "C",   50,    0, "Tipo de obra" ,                     "",                  "", "( cDbfObr )" } )

RETURN ( aItmObr )

//---------------------------------------------------------------------------//

FUNCTION BrwObrasOLD( oGet, oGet2, cCodigoCliente, dbfObrasT )

	local oDlg
	local oBrw
   local oFont
   local oBtn
	local oGet1
	local cGet1
   local nOrd        := GetBrwOpt( "BrwObras" )
	local oCbxOrd
   local aCbxOrd     := { "Código", "Nombre" }
   local aIndOrd     := { "cCodigo", "cNombre" }
   local cCbxOrd     := "Código"
   local nLevel      := Auth():Level( "01032" )
   local lClose      := .f.
   local oSayText
   local cSayText    := "Listado de obras"

   nOrd              := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd           := aCbxOrd[ nOrd ]

   if Empty( cCodigoCliente )
		MsgStop( "Es necesario codificar un cliente" )
      return .t.
   end if

   if !lExistTable( cPatCli() + "ObrasT.Dbf" )
      MsgStop( 'No existe el fichero de obras' )
      Return .f.
   end if

   if Empty( dbfObrasT )
      USE ( cPatCli() + "ObrasT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "OBRAST", @dbfObrasT ) )
      SET ADSINDEX TO ( cPatCli() + "ObrasT.Cdx" ) ADDITIVE
      lClose         := .t.
   END IF

   ( dbfObrasT )->( ordSetFocus( nOrd ) )

   ( dbfObrasT )->( dbSetFilter( {|| alltrim( Field->cCodCli ) = alltrim( cCodigoCliente ) }, "Field->cCodigoCliente = 'cCodCli'" ) )
   ( dbfObrasT )->( dbGoTop() )

   DEFINE DIALOG     oDlg ;
      RESOURCE       "HELPENTRY";
      TITLE          "Seleccionar direcciones"

      REDEFINE GET oGet1 VAR cGet1;
         ID          104 ;
         ON CHANGE   ( AutoSeek( nKey, nFlags, Self, oBrw, dbfObrasT, nil, cCodigoCliente ) );
         BITMAP      "FIND" ;
         OF          oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		   cCbxOrd ;
			ID 		   102 ;
         ITEMS       aCbxOrd ;
         ON CHANGE   ( ( dbfObrasT )->( ordsetfocus( oCbxOrd:nAt ) ),;
                     oBrw:Refresh(),;
                     oGet1:SetFocus() );
			OF 		   oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfObrasT
      oBrw:nMarqueeStyle   := 5

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "Codigo"
         :bEditValue       := {|| ( dbfObrasT )->cCodObr }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ), eval( oCbxOrd:bChange ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "Nombre"
         :bEditValue       := {|| ( dbfObrasT )->cNomObr }
         :nWidth           := 360
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ), eval( oCbxOrd:bChange ) }
      end with

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }

      oBrw:CreateFromResource( 105 )

		REDEFINE BUTTON ;
         ID       500 ;
         OF       oDlg ;
         WHEN     ( nAnd( nLevel, ACC_APPD ) != 0 .and. !IsReport() );
         ACTION   ( WinAppRec( oBrw, bEdit, dbfObrasT, nil, nil, cCodigoCliente ) )

		REDEFINE BUTTON ;
         ID       501 ;
         OF       oDlg ;
         WHEN     ( nAnd( nLevel, ACC_EDIT ) != 0 .and. !IsReport() );
         ACTION   ( WinEdtRec( oBrw, bEdit, dbfObrasT, nil, nil, cCodigoCliente ) )

      if !IsReport()
         oDlg:AddFastKey( VK_F2, {|| if( nAnd( nLevel, ACC_APPD ) != 0, WinAppRec( oBrw, bEdit, dbfObrasT, nil, nil, cCodigoCliente ), ) } )
         oDlg:AddFastKey( VK_F3, {|| if( nAnd( nLevel, ACC_EDIT ) != 0, WinEdtRec( oBrw, bEdit, dbfObrasT, nil, nil, cCodigoCliente ), ) } )
      end if

   oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )
   oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK

      oGet:cText( ( dbfObrasT )->cCodObr )

      if !Empty( oGet2 )
         oGet2:cText( ( dbfObrasT )->cNomObr )
      end if

   end if

   DestroyFastFilter( dbfObrasT )

   SetBrwOpt( "BrwObras", ( dbfObrasT )->( OrdNumber() ) )

   if lClose
      ( dbfObrasT )->( dbCloseArea() )
   else
      ( dbfObrasT )->( dbsetfilter() )
   end if

	oGet:setFocus()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

FUNCTION cObras( oGet, oGet2, cCodigoCliente, dbfObrasT )

	local lValid 	:= .f.
	local lClose 	:= .f.
	local xValor 	:= oGet:VarGet()

	if Empty( xValor )
		if !Empty( oGet2 )
			oGet2:cText( "" )
      end if
      return .t.
   end if

   if Empty( cCodigoCliente )
		MsgStop( "Es necesario codificar un cliente" )
		return .t.
	end if

   if Empty( dbfObrasT )
      USE ( cPatEmp() + "OBRAST.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "OBRAST", @dbfObrasT ) )
      SET ADSINDEX TO ( cPatEmp() + "OBRAST.CDX" ) ADDITIVE
      lClose      := .t.
   end if

   ( dbfObrasT )->( OrdSetFocus( "cCodCli" ) )

   xValor         := cCodigoCliente + xValor

   if ( dbfObrasT )->( dbSeek( xValor ) )

      oGet:cText( ( dbfObrasT )->cCodObr )

		if !Empty( oGet2 )
			oGet2:cText( ( dbfObrasT )->cNomObr )
		end if

      lValid      := .t.

	else

      msgStop( "Obra no encontrada", ( dbfObrasT )->( OrdSetFocus() ) )

	end if

   if lClose
      CLOSE ( dbfObrasT )
   end if

Return lValid

//---------------------------------------------------------------------------//

FUNCTION BrwObras( oGet, oGet2, cCodigoCliente, dbfObrasT )

   local oDlg
   local oBrw
   local oFont
   local oBtn
   local oGet1
   local cGet1
   local nOrd        := GetBrwOpt( "BrwObras" )
   local oCbxOrd
   local aCbxOrd     := { "Código", "Nombre" }
   local aIndOrd     := { "cCodigo", "cNombre" }
   local cCbxOrd     := "Código"
   local nLevel      := Auth():Level( "01032" )
   local lClose      := .f.
   local oSayText
   local cSayText    := "Listado de obras"
   local dbfSql      := "BrowseObras"
   local nOrdAnt
   local nRecAnt

   nOrd              := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd           := aCbxOrd[ nOrd ]

   if Empty( cCodigoCliente )
      MsgStop( "Es necesario codificar un cliente" )
      return .t.
   end if

   if !lExistTable( cPatCli() + "ObrasT.Dbf" )
      MsgStop( 'No existe el fichero de obras' )
      Return .f.
   end if

   ClientesModel():getObrasPorCliente( @dbfSql, cCodigoCliente )

   ( dbfSql )->( OrdSetFocus( aIndOrd[ nOrd ] ) )
   ( dbfSql )->( dbGoTop() )  

   if Empty( dbfObrasT )
      USE ( cPatCli() + "ObrasT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "OBRAST", @dbfObrasT ) )
      SET ADSINDEX TO ( cPatCli() + "ObrasT.Cdx" ) ADDITIVE
      lClose         := .t.
   end if

   DEFINE DIALOG     oDlg ;
      RESOURCE       "HELPENTRY";
      TITLE          "Seleccionar direcciones"

      REDEFINE GET oGet1 VAR cGet1;
         ID          104 ;
         ON CHANGE   ( AutoSeek( nKey, nFlags, Self, oBrw, dbfSql ) );
         BITMAP      "FIND" ;
         OF          oDlg

      REDEFINE COMBOBOX oCbxOrd ;
         VAR         cCbxOrd ;
         ID          102 ;
         ITEMS       aCbxOrd ;
         ON CHANGE   ( ( dbfSql )->( ordsetfocus( aIndOrd[ oCbxOrd:nAt ] ) ),;
                     oBrw:Refresh(),;
                     oGet1:SetFocus() );
         OF          oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfSql
      oBrw:nMarqueeStyle   := 5

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodigo"
         :bEditValue       := {|| ( dbfSql )->cCodObr }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ), eval( oCbxOrd:bChange ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNombre"
         :bEditValue       := {|| ( dbfSql )->cNomObr }
         :nWidth           := 360
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ), eval( oCbxOrd:bChange ) }
      end with

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }

      oBrw:CreateFromResource( 105 )

      REDEFINE BUTTON ;
         ID       500 ;
         OF       oDlg ;
         WHEN     ( nAnd( nLevel, ACC_APPD ) != 0 .and. !IsReport() );
         ACTION   ( WinAppRecFromBrowse( oBrw, bEdit, dbfObrasT, cCodigoCliente, dbfSql, nOrd ) )

      REDEFINE BUTTON ;
         ID       501 ;
         OF       oDlg ;
         WHEN     ( nAnd( nLevel, ACC_EDIT ) != 0 .and. !IsReport() );
         ACTION   ( WinEdtRecFromBrowse( oBrw, bEdit, dbfObrasT, cCodigoCliente, ( dbfSql )->cCodObr, dbfSql, nOrd ) )

      if !IsReport()
         oDlg:AddFastKey( VK_F2, {|| if( nAnd( nLevel, ACC_APPD ) != 0, WinAppRecFromBrowse( oBrw, bEdit, dbfObrasT, cCodigoCliente, dbfSql, nOrd ), ) } )
         oDlg:AddFastKey( VK_F3, {|| if( nAnd( nLevel, ACC_EDIT ) != 0, WinEdtRecFromBrowse( oBrw, bEdit, dbfObrasT, cCodigoCliente, ( dbfSql )->cCodObr, dbfSql, nOrd ), ) } )
      end if

   oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )
   oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK

      oGet:cText( ( dbfSql )->cCodObr )

      if !Empty( oGet2 )
         oGet2:cText( ( dbfSql )->cNomObr )
      end if

   end if

   SetBrwOpt( "BrwObras", ( dbfSql )->( OrdNumber() ) )

   if lClose
      ( dbfObrasT )->( dbCloseArea() )
   end if

   oGet:setFocus()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Function WinAppRecFromBrowse( oBrw, bEdit, dbfObrasT, cCodigoCliente, dbfSql, nOrd )

   WinAppRec( oBrw, bEdit, dbfObrasT, nil, nil, cCodigoCliente )

   ClientesModel():getObrasPorCliente( @dbfSql, cCodigoCliente )

   ( dbfSql )->( ordSetFocus( nOrd ) )
   ( dbfSql )->( dbGoTop() )

   if !Empty( oBrw )
      oBrw:Refresh()
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

Function WinEdtRecFromBrowse( oBrw, bEdit, dbfObrasT, cCodigoCliente, cCodObr, dbfSql, nOrd )

   if ( dbfObrasT )->( dbSeek( cCodigoCliente + cCodObr ) )
      WinEdtRec( oBrw, bEdit, dbfObrasT, nil, nil, cCodigoCliente )
   end if

   ClientesModel():getObrasPorCliente( @dbfSql, cCodigoCliente )

   ( dbfSql )->( ordSetFocus( "cCodCli" ) )   

   ( dbfSql )->( dbSeek( cCodigoCliente + cCodObr ) )

   ( dbfSql )->( ordSetFocus( nOrd ) )

   if !Empty( oBrw )
      oBrw:Refresh()
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//