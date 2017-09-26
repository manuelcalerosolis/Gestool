#ifndef __PDA__
   #include "FiveWin.Ch"
   #include "Font.ch"
   #include "Report.ch"
#else
   #include "FWCE.ch"
   REQUEST DBFCDX
#endif

#include "Factu.ch" 

#ifndef __PDA__
   static bEdit      := {| aBlank, aoGet, dbfObrasT, oBrw, bWhen, bValid, nMode, cCodCli | EdtRec( aBlank, aoGet, dbfObrasT, oBrw, bWhen, bValid, nMode, cCodCli ) }
#endif

static oWndBrw

static dbfContactos

//--------------------------------------------------------------------------//
//Funciones del programa
//--------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aBlank, aoGet, dbfContactos, oBrw, bWhen, bValid, nMode, cCodCli )

	local oDlg

   if nMode == APPD_MODE 
      if !Empty( cCodCli )
         aBlank[ ( dbfContactos )->( FieldPos( "cCodCli" ) ) ] := cCodCli
      end if
      aBlank[ ( dbfContactos )->( FieldPos( "dLlaCon" ) ) ]    := ctod( "" )
   end if

   DEFINE DIALOG oDlg RESOURCE "Contactos" TITLE LblTitle( nMode ) + "contactos de clientes"

      REDEFINE GET aoGet[ ( dbfContactos )->( FieldPos( "cNomCon" ) ) ] ;
         VAR      aBlank[ ( dbfContactos )->( FieldPos( "cNomCon" ) ) ] ;
         ID       100 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			PICTURE 	"@!" ;
			OF 		oDlg

      REDEFINE GET aBlank[ ( dbfContactos )->( FieldPos( "cNifCon" ) ) ] ;
         ID       101 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@!" ;
         OF       oDlg

      REDEFINE GET aBlank[ ( dbfContactos )->( FieldPos( "cDirCon" ) ) ] ;
         ID       110 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET aBlank[ ( dbfContactos )->( FieldPos( "cPobCon" ) ) ] ;
         ID       120 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET aBlank[ ( dbfContactos )->( FieldPos( "cPosCon" ) ) ] ;
         ID       130 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET aBlank[ ( dbfContactos )->( FieldPos( "cPrvCon" ) ) ] ;
         ID       140 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET aBlank[ ( dbfContactos )->( FieldPos( "cTelCon" ) ) ] ;
         ID       150 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET aBlank[ ( dbfContactos )->( FieldPos( "cMovCon" ) ) ] ;
         ID       160 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET aBlank[ ( dbfContactos )->( FieldPos( "cFaxCon" ) ) ] ;
         ID       170 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aBlank[ ( dbfContactos )->( FieldPos( "cMaiCon" ) ) ] ;
         ID       180 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET aoGet[ ( dbfContactos )->( FieldPos( "cObsCon" ) ) ] ; 
         VAR      aBlank[ ( dbfContactos )->( FieldPos( "cObsCon" ) ) ] ;
         ID       200 ;
         MEMO ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aoGet[ ( dbfContactos )->( FieldPos( "dLlaCon" ) ) ] ; 
         VAR      aBlank[ ( dbfContactos )->( FieldPos( "dLlaCon" ) ) ] ;
         ID       190 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aoGet[ ( dbfContactos )->( FieldPos( "cTimCon" ) ) ] ; 
         VAR      aBlank[ ( dbfContactos )->( FieldPos( "cTimCon" ) ) ] ;
         ID       191 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      TBtnBmp():ReDefine( 192, "gc_recycle_16",,,,,{|| LlamadaAhora( aoGet, dbfContactos ) }, oDlg, .f., , .f.,  )               

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( EndTrans( aBlank, aoGet, dbfContactos, oBrw, nMode, oDlg ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

      if nMode != ZOOM_MODE
         oDlg:AddFastKey( VK_F5, {|| EndTrans( aBlank, aoGet, dbfContactos, oBrw, nMode, oDlg ) } )
      end if

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Static Function EndTrans( aBlank, aoGet, dbfContactos, oBrw, nMode, oDlg )

   if Empty( aBlank[ ( dbfContactos )->( FieldPos( "cNomCon" ) ) ] )

      MsgStop( "Nombre no puede estar vacío" )

      aoGet[ ( dbfContactos )->( FieldPos( "cNomCon" ) ) ]:SetFocus()

      return nil

   end if

   WinGather( aBlank, aoGet, dbfContactos, oBrw, nMode )

   oBrw:Refresh()

Return ( oDlg:end( IDOK ) )

//--------------------------------------------------------------------------//

Static Function LlamadaAhora( aoGet, dbfContactos )

   aoGet[ ( dbfContactos )->( FieldPos( "dLlaCon" ) ) ]:cText( date() )
   aoGet[ ( dbfContactos )->( FieldPos( "cTimCon" ) ) ]:cText( left( time(), 5 ) )

Return ( .t. )

//--------------------------------------------------------------------------//

STATIC FUNCTION OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      USE ( cPatCli() + "CliCto.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CliConta", @dbfContactos ) )
      SET ADSINDEX TO ( cPatCli() + "CliCto.Cdx" ) ADDITIVE

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos de contactos de clientes." )

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

   if !Empty( dbfContactos )
      ( dbfContactos )->( dbCloseArea() )
   end if

   dbfContactos   := nil

RETURN ( .T. )

//----------------------------------------------------------------------------//

FUNCTION AppContactos( cCodCli, dbfContactos, oBrw )

   WinAppRec( oBrw, bEdit, dbfContactos, nil, nil, cCodCli )

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION EdtContactos( dbfContactos, oBrw )

   local nLevel      := nLevelUsr( "01032" )

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_EDIT ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   WinEdtRec( oBrw, bEdit, dbfContactos )

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION ZoomContactos( dbfContactos, oBrw )

   WinZooRec( oBrw, bEdit, dbfContactos )

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION DelContactos( dbfContactos, oBrw )

   if dbDelRec( oBrw, dbfContactos )
      oBrw:Refresh()
   end if

RETURN NIL

//--------------------------------------------------------------------------//

Function LlamadaContactos( dbfContactos, oBrw )

   ( dbfContactos )->dLlaCon  := date()
   ( dbfContactos )->cTimCon  := left( time(), 5)

   oBrw:Refresh()

Return ( .t. )

//--------------------------------------------------------------------------//



//Funciones comunes del programa y pda
//--------------------------------------------------------------------------//

FUNCTION aItmContacto()

   local aItmCon  := {}

   aAdd( aItmCon, { "cCodCli",   "C",   12,    0, "Código del cliente" ,               "",                  "", "( cDbfCon )" } )
   aAdd( aItmCon, { "cNomCon",   "C",  140,    0, "Nombre del contacto" ,              "'@!'",              "", "( cDbfCon )" } )
   aAdd( aItmCon, { "cNifCon",   "C",   30,    0, "NIF del contacto" ,                 "'@!'",              "", "( cDbfCon )" } )
   aAdd( aItmCon, { "cDirCon",   "C",  100,    0, "Domicilio del contacto" ,           "'@!'",              "", "( cDbfCon )" } )
   aAdd( aItmCon, { "cPobCon",   "C",  100,    0, "Población del contacto" ,           "'@!'",              "", "( cDbfCon )" } )
   aAdd( aItmCon, { "cPrvCon",   "C",   20,    0, "Provincia del contacto" ,           "'@!'",              "", "( cDbfCon )" } )
   aAdd( aItmCon, { "cPosCon",   "C",   10,    0, "Código postal del contacto" ,       "'@!'",              "", "( cDbfCon )" } )
   aAdd( aItmCon, { "cTelCon",   "C",   17,    0, "Teléfono del contacto" ,            "",                  "", "( cDbfCon )" } )
   aAdd( aItmCon, { "cMovCon",   "C",   17,    0, "Teléfono movil del contacto" ,      "",                  "", "( cDbfCon )" } )
   aAdd( aItmCon, { "cFaxCon",   "C",   17,    0, "Fax del contacto" ,                 "",                  "", "( cDbfCon )" } )
   aAdd( aItmCon, { "cMaiCon",   "C",  140,    0, "Email del contacto" ,               "",                  "", "( cDbfCon )" } )
   aAdd( aItmCon, { "dLlaCon",   "D",    8,    0, "Última llamada del contacto" ,      "",                  "", "( cDbfCon )" } )
   aAdd( aItmCon, { "cTimCon",   "C",    5,    0, "Hora última llamada del contacto" , "",                  "", "( cDbfCon )" } )
   aAdd( aItmCon, { "cObsCon",   "M",   10,    0, "Observaciones del contacto" ,       "",                  "", "( cDbfCon )" } )

RETURN ( aItmCon )

//---------------------------------------------------------------------------//

#ifndef __PDA__

FUNCTION BrwContactos( oGet, oGet2, cCodCli, dbfContactos )

	local oDlg
	local oBrw
   local oFont
   local oBtn
	local oGet1
	local cGet1
   local nOrd        := GetBrwOpt( "BrwContactos" )
	local oCbxOrd
   local aCbxOrd     := { "Nombre", "Código postal", "Teléfono", "Movil", "Correo electrónico" }
   local cCbxOrd     := "Nombre"
   local nLevel      := nLevelUsr( "01032" )
   local lClose      := .f.
   local oSayText
   local cSayText    := "Listado de obras"

   nOrd              := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd           := aCbxOrd[ nOrd ]

   if Empty( cCodCli )
		MsgStop( "Es necesario codificar un cliente" )
      return .t.
   end if

   if !lExistTable( cPatCli() + "CliCto.dbf" )
      MsgStop( 'No existe el fichero de obras' )
      Return .f.
   end if

   if Empty( dbfContactos )
      USE ( cPatCli() + "CliCto.dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CliConta", @dbfContactos ) )
      SET ADSINDEX TO ( cPatCli() + "CliCto.Cdx" ) ADDITIVE
      lClose      := .t.
   END IF

   ( dbfContactos )->( ordSetFocus( nOrd ) )
   ( dbfContactos )->( dbSetFilter( {|| Field->cCodCli == cCodCli }, "Field->cCodCli == cCodCli" ) )
   ( dbfContactos )->( dbGoTop() )

   DEFINE DIALOG  oDlg ;
      RESOURCE    "HELPENTRY";
      TITLE       "Seleccionar contactos de clientes"

      REDEFINE GET oGet1 VAR cGet1;
         ID       104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfContactos, nil, cCodCli ) );
         BITMAP   "FIND" ;
         OF       oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( ( dbfContactos )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:Refresh(), oGet1:SetFocus() );
			OF 		oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfContactos
      oBrw:nMarqueeStyle   := 5

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "Codigo"
         :bEditValue       := {|| ( dbfContactos )->cCodObr }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "Nombre"
         :bEditValue       := {|| ( dbfContactos )->cNomObr }
         :nWidth           := 360
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }

      oBrw:CreateFromResource( 105 )

		REDEFINE BUTTON ;
         ID       500 ;
         OF       oDlg ;
         WHEN     ( nAnd( nLevel, ACC_APPD ) != 0 .and. !IsReport() );
         ACTION   ( WinAppRec( oBrw, bEdit, dbfContactos, nil, nil, cCodCli ) )

		REDEFINE BUTTON ;
         ID       501 ;
         OF       oDlg ;
         WHEN     ( nAnd( nLevel, ACC_EDIT ) != 0 .and. !IsReport() );
         ACTION   ( WinEdtRec( oBrw, bEdit, dbfContactos, nil, nil, cCodCli ) )

      if !IsReport()
         oDlg:AddFastKey( VK_F2,    {|| if( nAnd( nLevel, ACC_APPD ) != 0, WinAppRec( oBrw, bEdit, dbfContactos, nil, nil, cCodCli ), ) } )
         oDlg:AddFastKey( VK_F3,    {|| if( nAnd( nLevel, ACC_EDIT ) != 0, WinEdtRec( oBrw, bEdit, dbfContactos, nil, nil, cCodCli ), ) } )
      end if

   oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )
   oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK
      oGet:cText( ( dbfContactos )->CCODOBR )

      if oGet2 != NIL
         oGet2:cText( ( dbfContactos )->CNOMOBR )
      end if
   end if

   DestroyFastFilter( dbfContactos )

   SetBrwOpt( "BrwContactos", ( dbfContactos )->( OrdNumber() ) )

   if lClose
      ( dbfContactos )->( dbCloseArea() )
   else
      ( dbfContactos )->( OrdSetFocus( nOrd ) )
      ( dbfContactos )->( dbClearFilter() )
   end if

	oGet:setFocus()

RETURN ( oDlg:nResult == IDOK )

#endif

//---------------------------------------------------------------------------//