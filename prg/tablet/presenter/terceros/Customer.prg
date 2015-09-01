#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS Customer FROM Editable

   DATA oClienteIncidencia

   DATA oViewIncidencia

   DATA oGridCustomer

   DATA cTipoCliente                   INIT ""

   DATA hTipoCliente                   INIT { "1" => "Clientes", "2" => "Potenciales", "3" => "Web" }

   METHOD New()
   METHOD Init( nView )

   METHOD runNavigatorCustomer()

   METHOD runGridCustomer()

   METHOD OpenFiles()
   METHOD CloseFiles()                 INLINE ( D():DeleteView( ::nView ) )

   METHOD setEnviroment()              INLINE ( ::setDataTable( "Client" ) ) 
   
   METHOD showIncidencia()             INLINE ( ::oClienteIncidencia:showNavigator() )

   METHOD Resource()                   INLINE ( ::oViewEdit:Resource() )   

   METHOD setFilterAgentes()

   METHOD onPreSaveEditDocumento()     INLINE ( .t. )
   METHOD onPreEnd()                   INLINE ( .t. )

   METHOD onPostGetDocumento()
   METHOD onPreSaveDocumento()

   METHOD EditCustomer( Codigo )           

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS Customer

   if ::OpenFiles()

      ::setFilterAgentes()

      ::oViewNavigator                       := CustomerViewSearchNavigator():New( self )
      ::oViewNavigator:setTextoTipoDocumento( "Clientes" )

      ::oGridCustomer                        := CustomerViewSearchNavigator():New( self )
      ::oGridCustomer:setSelectorMode()
      ::oGridCustomer:setTextoTipoDocumento( "Seleccione cliente" )
      ::oGridCustomer:setDblClickBrowseGeneral( {|| ::oGridCustomer:endView() } )

      ::oViewEdit                            := CustomerView():New( self )

      ::oClienteIncidencia                   := CustomerIncidence():New( self )

      ::setEnviroment()

   end if   

Return ( self )

//---------------------------------------------------------------------------//

METHOD Init( oSender ) CLASS Customer

   ::nView                                := oSender:nView

   ::oViewNavigator                       := CustomerViewSearchNavigator():New( self )
   ::oViewNavigator:setTextoTipoDocumento( "Clientes" )

   ::oGridCustomer                        := CustomerViewSearchNavigator():New( self )
   ::oGridCustomer:setSelectorMode()
   ::oGridCustomer:setTextoTipoDocumento( "Seleccione cliente" )
   ::oGridCustomer:setDblClickBrowseGeneral( {|| ::oGridCustomer:endView() } )

   ::oViewEdit                            := CustomerView():New( self )

   ::oClienteIncidencia                   := CustomerIncidence():New( self )

   ::setEnviroment()

Return ( self )

//---------------------------------------------------------------------------//

METHOD runNavigatorCustomer() CLASS Customer

   if !empty( ::oViewNavigator )
      ::oViewNavigator:showView()
   end if

   ::CloseFiles()

return ( self )

//---------------------------------------------------------------------------//

METHOD runGridCustomer() CLASS Customer

   local result   := ""

   if !Empty( ::oGridCustomer )

      ::oGridCustomer:showView()

      if ::oGridCustomer:oDlg:nResult == IDOK

         result   := ( D():Clientes( ::nView ) )->Cod

      end if

   end if

Return ( result )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS Customer

   local oError
   local oBlock
   local lOpenFiles     := .t.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::nView           := D():CreateView()

      D():Clientes( ::nView )

      D():ClientesDirecciones( ::nView )

      D():TiposIncidencias( ::nView )

   RECOVER USING oError

      lOpenFiles        := .f.

      ApoloMsgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpenFiles
      ::CloseFiles( "" )
   end if

Return ( lOpenFiles )

//---------------------------------------------------------------------------//

METHOD onPostGetDocumento() CLASS Customer

   local cTipo          := str( hGet( ::hDictionaryMaster, "TipoCliente" ) )

   if !empty( cTipo )
      if hHasKey( ::hTipoCliente, cTipo )
         ::cTipoCliente := hGet( ::hTipoCliente, cTipo )
      end if 
   end if 

   if ::lAppendMode()
      hSet( ::hDictionaryMaster, "Codigo", D():getLastKeyClientes( ::nView ) )
   end if 

Return ( .t. )   

//---------------------------------------------------------------------------//

METHOD onPreSaveDocumento() CLASS Customer

   local nScan
   local nTipoCliente      := 1

   nScan                   := hScan( ::hTipoCliente, {|k,v,i| v == ::cTipoCliente } )   
   if nScan != 0 
      nTipoCliente         := val( hGetKeyAt( ::hTipoCliente, nScan ) )
   end if 

   hSet( ::hDictionaryMaster, "TipoCliente", nTipoCliente ) 

Return ( .t. )   

//---------------------------------------------------------------------------//

METHOD setFilterAgentes() CLASS Customer

   local cCodigoAgente     := AccessCode():cAgente

   if !empty(cCodigoAgente)
      ( D():Clientes( ::nView ) )->( dbsetfilter( {|| Field->cAgente == cCodigoAgente }, "cAgente == cCodigoAgente" ) )
      ( D():Clientes( ::nView ) )->( dbgotop() )
   end if 

Return ( .t. )   

//---------------------------------------------------------------------------//

METHOD EditCustomer( Codigo ) CLASS Customer

   if empty( Codigo )
      Return .f.
   end if 

   D():getStatusClientes( ::nView )

   ( D():Clientes( ::nView ) )->( ordSetFocus( 1 ) )

   if ( D():Clientes( ::nView ) )->( dbseek( Codigo ) )
      ::edit()
   end if 

   D():setStatusClientes( ::nView )

Return( .t. )

//---------------------------------------------------------------------------//

FUNCTION GridBrwObras( oGet, oGetName, cCodCli, dbfObras )

   local oDlg
   local oBrw
   local oSayGeneral
   local oBtnAceptar
   local oBtnCancelar
   local oGetSearch
   local cGetSearch  := Space( 100 )
   local cTxtOrigen  := if( !empty( oGet ), oGet:VarGet(), )
   local nOrdAnt     := GetBrwOpt( "BrwGridObras" )
   local oCbxOrd
   local aCbxOrd     := { "Código", "Nombre" }
   local cCbxOrd
   local nLevel      := nLevelUsr( "01032" )
   local lClose      := .f.
   local oBtnAdd
   local oBtnEdt
   local oBtnUp
   local oBtnDown
   local oBtnUpPage
   local oBtnDownPage

   nOrdAnt           := Min( Max( nOrdAnt, 1 ), len( aCbxOrd ) )
   cCbxOrd           := aCbxOrd[ nOrdAnt ]

   DEFAULT cCodCli   := "000000      "

   if Empty( dbfObras )
      USE ( cPatCli() + "ObrasT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "OBRAST", @dbfObras ) )
      SET ADSINDEX TO ( cPatCli() + "ObrasT.Cdx" ) ADDITIVE
      lClose         := .t.
   end if

   ( dbfObras )->( ordSetFocus( nOrdAnt ) )

   // Filtro de la busqueda----------------------------------------------------

   SetScopeObras( cCodCli, dbfObras )

   // Dialogo------------------------------------------------------------------

   oDlg           := TDialog():New( 1, 5, 40, 100, "Buscar direcciones",,, .f., nOR( DS_MODALFRAME, WS_POPUP, WS_CAPTION, WS_SYSMENU, WS_MINIMIZEBOX, WS_MAXIMIZEBOX ),, rgb(255,255,255),,, .F.,, oGridFont(),,,, .f.,, "oDlg" )

   oSayGeneral    := TGridSay():Build(    {  "nRow"      => 0,;
                                             "nCol"      => {|| GridWidth( 0.5, oDlg ) },;
                                             "bText"     => {|| "Buscar direcciones" },;
                                             "oWnd"      => oDlg,;
                                             "oFont"     => oGridFontBold(),;
                                             "lPixels"   => .t.,;
                                             "nClrText"  => Rgb( 0, 0, 0 ),;
                                             "nClrBack"  => Rgb( 255, 255, 255 ),;
                                             "nWidth"    => {|| GridWidth( 8, oDlg ) },;
                                             "nHeight"   => 32 } )

   oBtnAceptar    := TGridImage():Build(  {  "nTop"      => 5,;
                                             "nLeft"     => {|| GridWidth( 10.5, oDlg ) },;
                                             "nWidth"    => 32,;
                                             "nHeight"   => 32,;
                                             "cResName"  => "flat_check_64",;
                                             "bLClicked" => {|| oDlg:End( IDOK ) },;
                                             "oWnd"      => oDlg } )

   oBtnCancelar   := TGridImage():Build(  {  "nTop"      => 5,;
                                             "nLeft"     => {|| GridWidth( 9, oDlg ) },;
                                             "nWidth"    => 32,;
                                             "nHeight"   => 32,;
                                             "cResName"  => "flat_del_64",;
                                             "bLClicked" => {|| oDlg:End() },;
                                             "oWnd"      => oDlg } )

   // Texto de busqueda--------------------------------------------------------

   oGetSearch     := TGridGet():Build(    {  "nRow"      => 45,;
                                             "nCol"      => {|| GridWidth( 0.5, oDlg ) },;
                                             "bSetGet"   => {|u| if( PCount() == 0, cGetSearch, cGetSearch := u ) },;
                                             "oWnd"      => oDlg,;
                                             "nWidth"    => {|| GridWidth( 9, oDlg ) },;
                                             "nHeight"   => 25,;
                                             "bChanged"  => {| nKey, nFlags, Self | AutoSeek( nKey, nFlags, Self, oBrw, dbfObras, .t., cCodCli ) } } )

   oCbxOrd     := TGridComboBox():Build(  {  "nRow"      => 45,;
                                             "nCol"      => {|| GridWidth( 9.5, oDlg ) },;
                                             "bSetGet"   => {|u| if( PCount() == 0, cCbxOrd, cCbxOrd := u ) },;
                                             "oWnd"      => oDlg,;
                                             "nWidth"    => {|| GridWidth( 2, oDlg ) },;
                                             "nHeight"   => 25,;
                                             "aItems"    => aCbxOrd,;
                                             "bChange"   => {|| ( dbfObras )->( OrdSetFocus( oCbxOrd:nAt ) ),;
                                                                                SetScopeObras( cCodCli, dbfObras ),;
                                                                                oBrw:Refresh(),;
                                                                                oGetSearch:SetFocus() } } )

   oBtnAdd           := TGridImage():Build(  {  "nTop"      => 75,;
                                                   "nLeft"     => {|| GridWidth( 0.5, oDlg ) },;
                                                   "nWidth"    => 64,;
                                                   "nHeight"   => 64,;
                                                   "cResName"  => "flat_add_64",;
                                                   "bLClicked" => {|| nil },;
                                                   "bWhen"     => {|| .f. },;
                                                   "oWnd"      => oDlg } )

      oBtnEdt           := TGridImage():Build(  {  "nTop"      => 75,;
                                                   "nLeft"     => {|| GridWidth( 2, oDlg ) },;
                                                   "nWidth"    => 64,;
                                                   "nHeight"   => 64,;
                                                   "cResName"  => "flat_edit_64",;
                                                   "bLClicked" => {|| nil },;
                                                   "bWhen"     => {|| .f. },;
                                                   "oWnd"      => oDlg } )

      oBtnUpPage        := TGridImage():Build(  {  "nTop"      => 75,;
                                                   "nLeft"     => {|| GridWidth( 7.5, oDlg ) },;
                                                   "nWidth"    => 64,;
                                                   "nHeight"   => 64,;
                                                   "cResName"  => "flat_page_up_64",;
                                                   "bLClicked" => {|| oBrw:PageUp(), oBrw:Select( 0 ), oBrw:Select( 1 ), oBrw:Refresh()  },;
                                                   "oWnd"      => oDlg } )

      oBtnUp         := TGridImage():Build(  {     "nTop"      => 75,;
                                                   "nLeft"     => {|| GridWidth( 8.5, oDlg ) },;
                                                   "nWidth"    => 64,;
                                                   "nHeight"   => 64,;
                                                   "cResName"  => "flat_up_64",;
                                                   "bLClicked" => {|| oBrw:GoUp(), oBrw:Select( 0 ), oBrw:Select( 1 ), oBrw:Refresh()  },;
                                                   "oWnd"      => oDlg } )

      oBtnDown          := TGridImage():Build(  {  "nTop"      => 75,;
                                                   "nLeft"     => {|| GridWidth( 9.5, oDlg ) },;
                                                   "nWidth"    => 64,;
                                                   "nHeight"   => 64,;
                                                   "cResName"  => "flat_down_64",;
                                                   "bLClicked" => {|| oBrw:GoDown(), oBrw:Select( 0 ), oBrw:Select( 1 ), oBrw:Refresh() },;
                                                   "oWnd"      => oDlg } )

      oBtnDownPage      := TGridImage():Build(  {  "nTop"      => 75,;
                                                   "nLeft"     => {|| GridWidth( 10.5, oDlg ) },;
                                                   "nWidth"    => 64,;
                                                   "nHeight"   => 64,;
                                                   "cResName"  => "flat_page_down_64",;
                                                   "bLClicked" => {|| oBrw:PageDown(), oBrw:Select( 0 ), oBrw:Select( 1 ), oBrw:Refresh() },;
                                                   "oWnd"      => oDlg } )

   // Browse de articulos ------------------------------------------------------

   oBrw                 := TGridIXBrowse():New( oDlg )

   oBrw:nTop            := oBrw:EvalRow( 115 )
   oBrw:nLeft           := oBrw:EvalCol( {|| GridWidth( 0.5, oDlg ) } )
   oBrw:nWidth          := oBrw:EvalWidth( {|| GridWidth( 11, oDlg ) } )
   oBrw:nHeight         := oBrw:EvalHeight( {|| GridHeigth( oDlg ) - oBrw:nTop - 10 } )

   oBrw:cAlias          := dbfObras
   oBrw:nMarqueeStyle   := 5
   oBrw:cName           := "BrwGridObras"

   with object ( oBrw:AddCol() )
      :cHeader          := "Código"
      :bEditValue       := {|| ( dbfObras )->cCodObr }
      :nWidth           := 200
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ), eval( oCbxOrd:bChange ) }
   end with

   with object ( oBrw:AddCol() )
      :cHeader          := "Nombre"
      :bEditValue       := {|| ( dbfObras )->cNomObr }
      :nWidth           := 560
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ), eval( oCbxOrd:bChange ) }
   end with

   oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }

   oBrw:nHeaderHeight   := 48
   oBrw:nFooterHeight   := 48
   oBrw:nRowHeight      := 48

   oBrw:CreateFromCode( 105 )

   // Dialogo------------------------------------------------------------------

   oDlg:bResized        := {|| GridResize( oDlg ) }
   oDlg:bStart          := {|| oBrw:Load() }

   ACTIVATE DIALOG oDlg CENTER ON INIT ( GridMaximize( oDlg ) ) 

   if oDlg:nResult == IDOK

      if isObject( oGet )
         oGet:cText( ( dbfObras )->cCodObr )
         oGet:lValid()
      else
         oGet           := ( dbfObras )->cNomObr
      end if

      if isObject( oGetName ) 
         oGetName:cText( ( dbfObras )->cNomObr )
      end if

   end if

   DestroyFastFilter( dbfObras )

   SetBrwOpt( "BrwGridObras", ( dbfObras )->( OrdNumber() ) )

   // Cerramos la tabla--------------------------------------------------------

   if lClose
      ( dbfObras )->( dbCloseArea() )
   else
      ( dbfObras )->( OrdSetFocus( nOrdAnt ) )
      SetScopeObras( nil, dbfObras )
   end if

   if IsObject( oGet ) 
      oGet:setFocus()
   end if

   oBtnAceptar:end()
   oBtnCancelar:end()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Function SetScopeObras( cCodigoCliente, dbfObras )

   ( dbfObras )->( OrdScope( 0, cCodigoCliente ) )
   ( dbfObras )->( OrdScope( 1, cCodigoCliente ) )
   ( dbfObras )->( dbGoTop() )

Return ( .t. )   

//---------------------------------------------------------------------------//


