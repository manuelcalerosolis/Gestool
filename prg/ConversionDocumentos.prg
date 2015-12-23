#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "Report.ch"
#include "XBrowse.ch"

//---------------------------------------------------------------------------//

CLASS TConversionDocumentos 

   DATA oDocumentLines

   DATA oDlg
   DATA oFld

   DATA oBtnAnterior
   DATA oBtnSiguiente
   DATA oBtnSalir

   DATA nView
   DATA lOpenFiles

   DATA oHeaderTable
   DATA oLineTable

   DATA oDocument
   DATA cDocument   
   DATA aDocuments   

   DATA cTargetDocument
   DATA aTargetEmpresa
   DATA cTargetEmpresa

   DATA oSearch
   DATA cSearch
   DATA oSortDocument
   DATA cSortDocument                              INIT "Número"
   DATA aSortDocument                              INIT { "Número", "Fecha", "Nombre" }

   DATA oSearchLines
   DATA cSearchLines
   DATA oSortLines
   DATA cSortLines
   DATA aSortLines                                 INIT {}
   
   DATA oBrwDocuments
   DATA oBrwLines

   DATA cPictureRound
   DATA nDecimalPrice
   DATA nRoundDecimalPrice

   DATA oPeriodo
   DATA oCliente
   DATA oProveedor
   DATA oArticulo
   DATA oEmpresa
   DATA oSerie
   DATA oFecha

   METHOD New()

   METHOD Dialog()
      METHOD DialogSelectionCriteria()
      METHOD DialogSelectionDocument()
      METHOD DialogSelectionLines()
      METHOD DialogSummary()
      METHOD startDialog()
      METHOD clickOnHeader( oColumn )
      METHOD changeSortDocument()
      METHOD changeSearch()
      METHOD setOrderInColumn( oColumn )  
      METHOD setAliasInBrowseDocument()            INLINE ( if ( !empty( ::oBrwDocuments ), ::oBrwDocuments:setAlias( ::getHeaderAlias() ), ) )
      METHOD getDocument()                         INLINE ( alltrim( ::cDocument ) )
      METHOD getDocumentName()                     INLINE ( if( !empty( ::getHeaderAlias() ), ::getDocument() + space( 1 ) + ::getHeaderTextId(), "" ) )
      
      METHOD isValidDialogRequisite()
      METHOD isValidTargetDocument()
      
      METHOD getActionDocument()                   INLINE ( hget( ::aDocuments, ::cDocument ) )
      METHOD getActionTargetDocument()             INLINE ( hget( ::aDocuments, ::cTargetDocument ) )

   METHOD OpenFiles()
   METHOD CloseFiles()
   METHOD getView()                                INLINE ( ::nView )

   METHOD BotonSiguiente()
   METHOD BotonAnterior()

   METHOD selectLine()                             
   METHOD unSelectLine()                           
   METHOD toogleSelectLine()                       

   METHOD selectAllLine()                          INLINE ( ::oDocumentLines:selectAll(),       ::oBrwLines:Refresh() )
   METHOD unselectAllLine()                        INLINE ( ::oDocumentLines:unSelectAll(),     ::oBrwLines:Refresh() )

   METHOD opcionInvalida()                         INLINE ( msgStop( "Opción invalida, por favor elija una opción valida." ), .f. )

   METHOD setSalesPictures()                       INLINE ( ::cPictureRound      := cPorDiv(),;
                                                            ::nDecimalPrice      := nDinDiv(),;
                                                            ::nRoundDecimalPrice := nRinDiv() )

   METHOD setShoppingPictures()                    INLINE ( ::cPictureRound      := cPirDiv(),;
                                                            ::nDecimalPrice      := nDouDiv(),;
                                                            ::nRoundDecimalPrice := nRouDiv() )

   METHOD setSalesControls()                       INLINE ( if( !empty(::oProveedor), ::oProveedor:Hide(), ),;
                                                            if( !empty(::oCliente), ::oCliente:Show(), ) )

   METHOD setShoppingControls()                    INLINE ( if( !empty(::oProveedor), ::oProveedor:Show(), ),;
                                                            if( !empty(::oCliente), ::oCliente:Hide(), ) )

   // get the documents data---------------------------------------------------

   METHOD setDocumentType( cDataTable )

   METHOD setSalesDocumentType( cHeaderTable, cLineTable ) ;
                                                   INLINE ( ::setSalesPictures(),;
                                                            ::setSalesControls(),;
                                                            ::setDocumentType( cHeaderTable, cLineTable ) )

   METHOD setShoppingDocumentType( cHeaderTable, cLineTable ) ;
                                                   INLINE ( ::setShoppingPictures(),;
                                                            ::setShoppingControls(),;
                                                            ::setDocumentType( cHeaderTable, cLineTable ) )

   METHOD setDocumentPedidosProveedores()          INLINE ( ::setShoppingDocumentType( D():PedidosProveedoresTableName(), D():PedidosProveedoresLineasTableName() ) )
   METHOD setDocumentSATClientes()                 INLINE ( ::setSalesDocumentType( D():SATClientesTableName(), D():SATClientesLineasTableName() ) )

   METHOD setHeaderTable( cTableName )             INLINE ( ::oHeaderTable := TDataCenter():scanDataTableInView( cTableName, ::nView ) )
   METHOD getHeaderAlias()                         INLINE ( ::oHeaderTable:getAlias() )
   METHOD getHeaderDictionary()                    INLINE ( ::oHeaderTable:getDictionary() )
   METHOD getHeaderIndex()                         INLINE ( ::oHeaderTable:getIndex() )

   METHOD getHeaderId()                            INLINE ( D():getFieldFromAliasDictionary( "Serie", ::getHeaderAlias(), ::getHeaderDictionary() ) + ;
                                                            str( D():getFieldFromAliasDictionary( "Numero", ::getHeaderAlias(), ::getHeaderDictionary() ) ) + ; 
                                                            D():getFieldFromAliasDictionary( "Sufijo", ::getHeaderAlias(), ::getHeaderDictionary() ) )
   METHOD getHeaderTextId()                        INLINE ( D():getFieldFromAliasDictionary( "Serie", ::getHeaderAlias(), ::getHeaderDictionary() ) + "/" + ;
                                                            alltrim( str( D():getFieldFromAliasDictionary( "Numero", ::getHeaderAlias(), ::getHeaderDictionary() ) ) ) )
   METHOD getDate()                                INLINE ( D():getFieldFromAliasDictionary( "Fecha", ::getHeaderAlias(), ::getHeaderDictionary() ) )
   METHOD getName()                                INLINE ( D():getFieldFromAliasDictionary( "NombreCliente", ::getHeaderAlias(), ::getHeaderDictionary() ) )
   METHOD getTotalNeto()                           INLINE ( D():getFieldFromAliasDictionary( "TotalNeto", ::getHeaderAlias(), ::getHeaderDictionary() ) )
   METHOD getTotalImpuesto()                       INLINE ( D():getFieldFromAliasDictionary( "TotalImpuesto", ::getHeaderAlias(), ::getHeaderDictionary() ) )
   METHOD getTotalDocumento()                      INLINE ( D():getFieldFromAliasDictionary( "TotalDocumento", ::getHeaderAlias(), ::getHeaderDictionary() ) )
   METHOD isPuntoVerde()                           INLINE ( D():getFieldFromAliasDictionary( "OperarPuntoVerde", ::getHeaderAlias(), ::getHeaderDictionary(), .f. ) )

   METHOD setLineTable( cTableName )               INLINE ( ::oLineTable := TDataCenter():scanDataTableInView( cTableName, ::nView ) )
   METHOD getLineAlias()                           INLINE ( ::oLineTable:getAlias() )
   METHOD getLineDictionary()                      INLINE ( ::oLineTable:getDictionary() )
   METHOD getLineIndex()                           INLINE ( ::oLineTable:getIndex() )

   METHOD getLineId()                              INLINE ( D():getFieldFromAliasDictionary( "Serie", ::getLineAlias(), ::getLineDictionary() ) + ;
                                                            str( D():getFieldFromAliasDictionary( "Numero", ::getLineAlias(), ::getLineDictionary() ) ) + ; 
                                                            D():getFieldFromAliasDictionary( "Sufijo", ::getLineAlias(), ::getLineDictionary() ) )
   METHOD getLineTextId()                          INLINE ( D():getFieldFromAliasDictionary( "Serie", ::getLineAlias(), ::getLineDictionary() ) + "/" + ;
                                                            alltrim( str( D():getFieldFromAliasDictionary( "Numero", ::getLineAlias(), ::getHeaderDictionary() ) ) ) )

   METHOD getLineDocument( nPosition )             INLINE ( ::oDocumentLines:getLine( if( !empty( nPosition ), nPosition, ::oBrwLines:nArrayAt ) ) )

   METHOD loadLinesDocument() 
   METHOD setBrowseLinesDocument()                 

   METHOD showDocuments() 
   METHOD showDocumentsLines()

   METHOD changeSearchLines()                      INLINE ( ::oBrwLines:Seek( alltrim( ::cSearchLines ) ) )
   METHOD changeSortLines()                        INLINE ( .t. )

   METHOD sortColumn( cExpresion, oColumn )     
   METHOD seekLine( c )                            

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New()

   ::OpenFiles()

   ::cDocument       := "Pedido proveedores"
   ::aDocuments      := {  "Compras" =>                                                   nil,;                                    
                           space( 3 ) + "Pedido proveedores" =>                           {|| ::setDocumentPedidosProveedores() },;
                           space( 3 ) + "Albarán proveedores" =>                          {|| msgAlert( "Albarán proveedores" ) },;
                           space( 3 ) + "Factura proveedores" =>                          {|| msgAlert( "Factura proveedores" ) },;
                           space( 3 ) + "Factura rectificativas proveedores" =>           {|| msgAlert( "Factura rectificativas proveedores" ) },;
                           space( 3 ) + "Recibos de proveedores" =>                       {|| msgAlert( "Recibos de proveedores" ) },;
                           "Ventas" =>                                                    nil,;                                    
                           space( 3 ) + "S.A.T. clientes" =>                              {|| ::setDocumentSATClientes() },;
                           space( 3 ) + "Presupuesto clientes" =>                         {|| msgAlert( "" ), .t. },;
                           space( 3 ) + "Pedido clientes" =>                              {|| msgAlert( "" ), .t. },;
                           space( 3 ) + "Albarán clientes" =>                             {|| msgAlert( "" ), .t. },;
                           space( 3 ) + "Factura clientes" =>                             {|| msgAlert( "" ), .t. },;
                           space( 3 ) + "Factura de anticipos" =>                         {|| msgAlert( "" ), .t. },;
                           space( 3 ) + "Factura rectificativa" =>                        {|| msgAlert( "" ), .t. },;
                           space( 3 ) + "Recibos facturas clientes" =>                    {|| msgAlert( "" ), .t. },;
                           space( 3 ) + "Tickets clientes" =>                             {|| msgAlert( "" ), .t. },;
                           space( 3 ) + "Parte de producción" =>                          {|| msgAlert( "" ), .t. },;
                           space( 3 ) + "Recibos de clientes" =>                          {|| msgAlert( "" ), .t. } }

   ::aTargetEmpresa  := aSerializedEmpresas()

   ::oDocumentLines  := DocumentLines():New( Self ) // AliasDocumentLine():New( Self )   

   ::setDocumentPedidosProveedores()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD OpenFiles()

   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      ::lOpenFiles      := .t.

      ::nView           := D():CreateView()

      D():Empresa( ::nView )

      D():Proveedores( ::nView )
      
      D():Clientes( ::nView )

      D():GruposProveedores( ::nView )

      D():PedidosProveedores( ::nView )

      D():PedidosProveedoresLineas( ::nView )

      D():PedidosProveedoresIncidencias( ::nView )

      D():PedidosProveedoresDocumentos( ::nView )

      D():SATClientes( ::nView )
      
      D():SATClientesLineas( ::nView )

      D():PropiedadesLineas( ::nView )

   RECOVER USING oError

      ::lOpenFiles      := .f.

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !::lOpenFiles
      ::CloseFiles()
   end if

RETURN ( ::lOpenFiles )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   D():DeleteView( ::nView )

   ::lOpenFiles         := .f.

Return ( Self )

//---------------------------------------------------------------------------//
   
METHOD Dialog() 

   local oBmp

   DEFINE DIALOG ::oDlg RESOURCE "ASS_CONVERSION_DOCUMENTO"

   REDEFINE BITMAP oBmp ;
      ID          500 ;
      RESOURCE    "hand_point_48" ;
      TRANSPARENT ;
      OF          ::oDlg

   REDEFINE PAGES ::oFld ;
      ID          100;
      OF          ::oDlg ;
      DIALOGS     "ASS_CONVERSION_DOCUMENTO_1",;
                  "ASS_CONVERSION_DOCUMENTO_2",;
                  "ASS_CONVERSION_DOCUMENTO_3",;
                  "ASS_CONVERSION_DOCUMENTO_4"

   ::DialogSelectionCriteria( ::oFld:aDialogs[1] )

   // segundo dialogo----------------------------------------------------------

   ::DialogSelectionDocument( ::oFld:aDialogs[2] )

   // tercera caja de dialogo -------------------------------------------------

   ::DialogSelectionLines( ::oFld:aDialogs[3] )
   
   // Resumen de la exportacion------------------------------------------------

   ::DialogSummary( ::oFld:aDialogs[4] )

   // Botones -----------------------------------------------------------------

   REDEFINE BUTTON ::oBtnAnterior;
      ID          3 ;
      OF          ::oDlg ;
      ACTION      ( ::BotonAnterior() )

   REDEFINE BUTTON ::oBtnSiguiente;
      ID          IDOK ;
      OF          ::oDlg ;
      ACTION      ( ::BotonSiguiente() )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          ::oDlg ;
      ACTION      ( ::oDlg:End() )

   ::oDlg:bStart  := {|| ::startDialog() }

   ACTIVATE DIALOG ::oDlg CENTER

   ::CloseFiles()

   oBmp:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD DialogSelectionCriteria( oDlg )

   REDEFINE COMBOBOX ::oDocument ;
      VAR         ::cDocument ;
      ITEMS       hgetkeys( ::aDocuments );
      ID          100 ;
      OF          oDlg

   ::oDocument:bChange  := {|| ::showDocuments() }

   ::oPeriodo     := GetPeriodo()
      ::oPeriodo:New( 110, 120, 130 )
      ::oPeriodo:Resource( oDlg )

   ::oCliente     := GetCliente()
      ::oCliente:New( 140, 141, 142 )
      ::oCliente:Resource( oDlg )
      ::oCliente:setView( ::nView )

   ::oProveedor   := GetProveedor() 
      ::oProveedor:New( 150, 151, 152 )
      ::oProveedor:Resource( oDlg )
      ::oProveedor:setView( ::nView )

   ::oArticulo    := GetArticulo()
      ::oArticulo:New( 200, 201, 202 )
      ::oArticulo:Resource( oDlg )
      ::oArticulo:setView( ::nView )

   REDEFINE COMBOBOX ::cTargetDocument ;
      ITEMS       hgetkeys( ::aDocuments );
      ID          160 ;
      OF          oDlg

   ::oSerie       := GetSerie():New( 170 )
      ::oSerie:Resource( oDlg )      

   ::oFecha       := GetFecha():New( 180 )
      ::oFecha:Resource( oDlg )

   ::oEmpresa     := GetEmpresa():New( 190, 191, 192 )
      ::oEmpresa:Resource( oDlg )
      ::oEmpresa:setView( ::nView )
      ::oEmpresa:Current()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD DialogSelectionDocument( oDlg )

   REDEFINE GET   ::oSearch ;
      VAR         ::cSearch ;
      ID          100 ;
      PICTURE     "@!" ;
      BITMAP      "Find" ;
      OF          oDlg

   ::oSearch:bChange                := {|| ::changeSearch() }

   REDEFINE COMBOBOX ::oSortDocument ;
      VAR         ::cSortDocument ;
      ITEMS       ::aSortDocument ;
      ID          110 ;
      ON CHANGE   ( ::changeSortDocument() );
      OF          oDlg

   ::oSortDocument:bChange          := {|| ::changeSortDocument() }

   // browse de documentos-----------------------------------------------------

   ::oBrwDocuments                  := IXBrowse():New( ::oFld:aDialogs[2] )

   ::oBrwDocuments:lAutoSort        := .f.
   ::oBrwDocuments:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrwDocuments:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   ::oBrwDocuments:cAlias           := ::getHeaderAlias()
   ::oBrwDocuments:nMarqueeStyle    := 5
   ::oBrwDocuments:cName            := "Browse.Conversion documentos"

   with object ( ::oBrwDocuments:AddCol() )
      :cHeader                      := "Número"
      :bEditValue                   := {|| ::getHeaderTextId() }
      :nWidth                       := 80
      :cSortOrder                   := "Id"
      :bLClickHeader                := {| nMRow, nMCol, nFlags, oColumn | ::clickOnHeader( oColumn ) }
   end with

   with object ( ::oBrwDocuments:AddCol() )
      :cHeader                      := "Fecha"
      :bEditValue                   := {|| ::getDate() }
      :nWidth                       := 80
      :cSortOrder                   := "Fecha"
      :bLClickHeader                := {| nMRow, nMCol, nFlags, oColumn | ::clickOnHeader( oColumn ) }
      :nDataStrAlign                := 3
      :nHeadStrAlign                := 3
   end with

   with object ( ::oBrwDocuments:AddCol() )
      :cHeader                      := "Nombre"
      :bEditValue                   := {|| ::getName() }
      :nWidth                       := 400
      :cSortOrder                   := "NombreEntidad"
      :bLClickHeader                := {| nMRow, nMCol, nFlags, oColumn | ::clickOnHeader( oColumn ) }
   end with

   with object ( ::oBrwDocuments:AddCol() )
      :cHeader                      := "Base"
      :bEditValue                   := {|| ::getTotalNeto() }
      :cEditPicture                 := ::cPictureRound
      :nWidth                       := 80
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
   end with

   with object ( ::oBrwDocuments:AddCol() )
      :cHeader                      := cImp()
      :bEditValue                   := {|| ::getTotalImpuesto() }
      :cEditPicture                 := ::cPictureRound
      :nWidth                       := 80
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
   end with

   with object ( ::oBrwDocuments:AddCol() )
      :cHeader                      := "Total"
      :bEditValue                   := {|| ::getTotalDocumento() }
      :cEditPicture                 := ::cPictureRound
      :nWidth                       := 80
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
   end with

   ::oBrwDocuments:CreateFromResource( 120 )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD DialogSelectionLines( oDlg )

   REDEFINE GET   ::oSearchLines ;
      VAR         ::cSearchLines ;
      ID          200 ;
      PICTURE     "@!" ;
      BITMAP      "Find" ;
      OF          oDlg

   ::oSearchLines:bChange           := {|| ::changeSearchLines() }

   REDEFINE COMBOBOX ::oSortLines ;
      VAR         ::cSortLines ;
      ITEMS       ::aSortLines ;
      ID          210 ;
      OF          oDlg

   ::oSortLines:bChange             := {|| ::changeSortLines() }

   REDEFINE BUTTON ;
      ID       500 ;
      OF       oDlg ;
      ACTION   ( ::selectLine() )

   REDEFINE BUTTON ;
      ID       510 ;
      OF       oDlg ;
      ACTION   ( ::unselectLine() )

   REDEFINE BUTTON ;
      ID       520 ;
      OF       oDlg ;
      ACTION   ( ::selectAllLine() )

   REDEFINE BUTTON ;
      ID       530 ;
      OF       oDlg ;
      ACTION   ( ::unselectAllLine() )

   REDEFINE SAY ; 
      VAR      ::getDocumentName() ;
      ID       110 ;
      OF       oDlg   

   // browse de lineas-----------------------------------------------------

   ::oBrwLines                      := IXBrowse():New( oDlg )

   ::oBrwLines:lAutoSort            := .f.
   ::oBrwLines:bClrSel              := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrwLines:bClrSelFocus         := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   ::oBrwLines:nMarqueeStyle        := 6
   ::oBrwLines:cName                := "Browse.Conversion documentos lineas"
   ::oBrwLines:bLDblClick           := {|| ::toogleSelectLine() }

   ::setBrowseLinesDocument()

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "Seleccionando"
      :bEditValue                   := {|| ::getLineDocument():isSelect() }
      :nWidth                       := 20
      :SetCheck( { "Sel16", "Nil16" } )
   end with

   with object ( ::oColumnNumeroDocumento := ::oBrwLines:AddCol() )
      :cHeader                      := "Número"
      :bEditValue                   := {|| ::getLineDocument():getNumeroDocumento() }
      :nWidth                       := 80
      :bLClickHeader                := {|nMRow, nMCol, nFlags, oColumn| ::sortColumn( "getNumeroDocumento", oColumn ) }         
   end with
  
   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "Código"
      :bEditValue                   := {|| ::getLineDocument():getCode() }
      :nWidth                       := 80
      :bLClickHeader                := {|nMRow, nMCol, nFlags, oColumn| ::sortColumn( "getCode", oColumn ) }         
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "Descripción"
      :bEditValue                   := {|| ::getLineDocument():getDescription() }
      :nWidth                       := 340
      :bLClickHeader                := {|nMRow, nMCol, nFlags, oColumn| ::sortColumn( "getDescription", oColumn ) }         
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "Prop. 1"
      :bEditValue                   := {|| ::getLineDocument():getCodeFirstProperty() }
      :nWidth                       := 60
      :lHide                        := .t.
      :bLClickHeader                := {|nMRow, nMCol, nFlags, oColumn| ::sortColumn( "getCodeFirstProperty", oColumn ) }         
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "Prop. 2"
      :bEditValue                   := {|| ::getLineDocument():getCodeSecondProperty() }
      :nWidth                       := 60
      :lHide                        := .t.
      :bLClickHeader                := {|nMRow, nMCol, nFlags, oColumn| ::sortColumn( "getCodeSecondProperty", oColumn ) }         
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "Valor propiedad 1"
      :bEditValue                   := {|| ::getLineDocument():getValueFirstProperty() }
      :nWidth                       := 60
      :lHide                        := .t.
      :bLClickHeader                := {|nMRow, nMCol, nFlags, oColumn| ::sortColumn( "getValueFirstProperty", oColumn ) }         
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "Valor propiedad 2"
      :bEditValue                   := {|| ::getLineDocument():getValueSecondProperty() }
      :nWidth                       := 60
      :lHide                        := .t.
      :bLClickHeader                := {|nMRow, nMCol, nFlags, oColumn| ::sortColumn( "getValueSecondProperty", oColumn ) }         
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "Nombre propiedad 1"
      :bEditValue                   := {|| ::getLineDocument():getNameFirstProperty() }
      :nWidth                       := 60
      :lHide                        := .t.
      :bLClickHeader                := {|nMRow, nMCol, nFlags, oColumn| ::sortColumn( "getNameFirstProperty", oColumn ) }         
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "Nombre propiedad 2"
      :bEditValue                   := {|| ::getLineDocument():getNameSecondProperty() }
      :nWidth                       := 60
      :lHide                        := .t.
      :bLClickHeader                := {|nMRow, nMCol, nFlags, oColumn| ::sortColumn( "getNameSecondProperty", oColumn ) }         
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "Lote"
      :bEditValue                   := {|| ::getLineDocument():getLote() }
      :nWidth                       := 80
      :lHide                        := .t.
      :bLClickHeader                := {|nMRow, nMCol, nFlags, oColumn| ::sortColumn( "getLote", oColumn ) }         
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := cNombreCajas()
      :bEditValue                   := {|| ::getLineDocument():getBoxes() }
      :cEditPicture                 := masUnd()
      :nWidth                       := 50
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
      :lHide                        := .t.
      :bLClickHeader                := {|nMRow, nMCol, nFlags, oColumn| ::sortColumn( "getBoxes", oColumn ) }         
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := cNombreUnidades()
      :bEditValue                   := {|| ::getLineDocument():getUnits() }
      :cEditPicture                 := masUnd()
      :nWidth                       := 60
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
      :lHide                        := .t.
      :bLClickHeader                := {|nMRow, nMCol, nFlags, oColumn| ::sortColumn( "getUnits", oColumn ) }         
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "Total " + cNombreUnidades()
      :bEditValue                   := {|| ::getLineDocument():getTotalUnits() }
      :cEditPicture                 := masUnd()
      :nWidth                       := 60
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
      :lHide                        := .f.
      :bLClickHeader                := {|nMRow, nMCol, nFlags, oColumn| ::sortColumn( "getTotalUnits", oColumn ) }         
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "UM. Unidad de medición"
      :bEditValue                   := {|| ::getLineDocument():getMeasurementUnit() }
      :nWidth                       := 25
      :lHide                        := .t.
      :bLClickHeader                := {|nMRow, nMCol, nFlags, oColumn| ::sortColumn( "getMeasurementUnit", oColumn ) }         
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "Almacen"
      :bEditValue                   := {|| ::getLineDocument():getStore() }
      :nWidth                       := 60
      :bLClickHeader                := {|nMRow, nMCol, nFlags, oColumn| ::sortColumn( "getStore", oColumn ) }         
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "Importe"
      :bEditValue                   := {|| ::getLineDocument():getNetPrice() }
      :cEditPicture                 := ::cPictureRound
      :nWidth                       := 90
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
      :bLClickHeader                := {|nMRow, nMCol, nFlags, oColumn| ::sortColumn( "getNetPrice", oColumn ) }         
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "% Dto."
      :bEditValue                   := {|| ::getLineDocument():getPercentageDiscount() }
      :cEditPicture                 := "@E 999.99"
      :nWidth                       := 50
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
      :lHide                        := .t.
      :bLClickHeader                := {|nMRow, nMCol, nFlags, oColumn| ::sortColumn( "getPercentageDiscount", oColumn ) }         
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "% Dto."
      :bEditValue                   := {|| ::getLineDocument():getPercentagePromotion() }
      :cEditPicture                 := "@E 999.99"
      :nWidth                       := 50
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
      :lHide                        := .t.
      :bLClickHeader                := {|nMRow, nMCol, nFlags, oColumn| ::sortColumn( "getPercentagePromotion", oColumn ) }         
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "% " + cImp()
      :bEditValue                   := {|| ::getLineDocument():getPercentageTax() }
      :cEditPicture                 := "@E 999.99"
      :nWidth                       := 50
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
      :bLClickHeader                := {|nMRow, nMCol, nFlags, oColumn| ::sortColumn( "getPercentageTax", oColumn ) }         
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "Total"
      :bEditValue                   := {|| ::getLineDocument():getBruto() }
      :cEditPicture                 := ::cPictureRound
      :nWidth                       := 80
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
      :bLClickHeader                := {|nMRow, nMCol, nFlags, oColumn| ::sortColumn( "getBruto", oColumn ) }         
   end with

   ::oBrwLines:CreateFromResource( 100 )

   ::sortColumn( "getNumeroDocumento", ::oColumnNumeroDocumento )

   aeval( ::oBrwLines:aCols, {|oColumn| aadd( ::aSortLines, oColumn:cHeader ) } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD DialogSummary( oDlg )

   REDEFINE SAY ; 
      VAR         ::getDocument() ;
      ID          100 ;
      OF          oDlg

   REDEFINE SAY ; 
      VAR         ::getHeaderTextId() ;
      ID          110 ;
      OF          oDlg

   REDEFINE COMBOBOX ::cTargetEmpresa ;
      ITEMS       ::aTargetEmpresa ;
      ID          130 ;
      OF          oDlg

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD startDialog()

   ::oBrwDocuments:Load()

   ::oBrwLines:Load()

   ::setDocumentPedidosProveedores()
   
RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD isValidDialogRequisite()

   if !::isValidTargetDocument()
      RETURN ( .f. )
   end if 

   if !::oSerie:Valid()
      RETURN ( .f. )
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD isValidTargetDocument()

   if empty(::cTargetDocument)
      msgStop( "El documento destino no es valido.")
      RETURN ( .f. )
   end if 

   if ( ::cTargetDocument == ::cDocument )
      msgStop( "El documento origen y destino son del mismo tipo.")
      RETURN ( .f. )
   end if 

   if empty( ::getActionTargetDocument() )
      msgStop( "El documento destino seleccionado no es valido." )
      RETURN ( .f. )
   end if   

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD BotonSiguiente()

   do case
      case ::oFld:nOption == 1

         if ::isValidDialogRequisite() .and. ::showDocuments()
            ::oFld:goNext()
         end if

      case ::oFld:nOption == 2
         if ::showDocumentsLines()
            ::oFld:goNext()
         end if

      case ::oFld:nOption == 3
         ::oFld:goNext()

   end case

Return ( Self )

//---------------------------------------------------------------------------//

Method BotonAnterior()

   ::oFld:goPrev()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD showDocuments()

   local bAction  
   local lAction  := .f.

   if empty( ::cDocument )
      Return ( .f. )
   end if 

   bAction        := ::getActionDocument()
   if isBlock( bAction )
      lAction     := eval( bAction )
   else 
      ::opcionInvalida()
   end if 

Return ( lAction )

//---------------------------------------------------------------------------//

METHOD showDocumentsLines()

   local id    := ::getHeaderId()

   if empty( id )
      Return ( .f. )
   end if 

   if ::loadLinesDocument( id )
      ::setBrowseLinesDocument()
   end if 

   // ::setLinesScope( Id )

   ::selectAllLine()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD setDocumentType( cTableHeadName, cTableLineName )

   ::setHeaderTable( cTableHeadName )

   ::setLineTable( cTableLineName )

   ::setAliasInBrowseDocument()
   ::setOrderInColumn()   

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD clickOnHeader( oColumn )
   
   local cTag

   if !empty( oColumn ) .and. !empty( oColumn:cSortOrder )
      cTag           := D():getIndexFromAliasDictionary( oColumn:cSortOrder, ::getHeaderIndex() ) 
   end if 

   if empty( cTag )
      Return ( Self )
   end if 

   ( ::getHeaderAlias() )->( ordsetfocus( cTag ) )

   ::setOrderInColumn( oColumn )

   ::oSortDocument:Set( oColumn:cHeader )

   ::oBrwDocuments:Refresh()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD changeSortDocument()

   local nScan
   local cSort    := ::oSortDocument:varGet()

   nScan          := ascan( ::oBrwDocuments:aCols, {| oColumn | oColumn:cHeader == cSort } )
   if nScan != 0
      ::clickOnHeader( ::oBrwDocuments:aCols[ nScan ] )
   end if 

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD changeSearch()

   local lSeek
   local cSearch  := alltrim( ::oSearch:varGet() )

   lSeek          := lSeekKeySimple( cSearch, ::getHeaderAlias() ) // lMiniSeek( xCadena, cAlias, ::cSearchType, ::nLenSearchType )

   if ( !lSeek .and. ( ( ::getHeaderAlias )->( ordnumber() ) == 1 ) )
      lSeek       := seekDocumentoSimple( cSearch, ::getHeaderAlias() )          
   end if 

   if lSeek 
      ::oBrwDocuments:Refresh()
   end if 

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD setOrderInColumn( oColumn )

   if empty(::oBrwDocuments)
      Return ( Self )
   end if 

   aeval( ::oBrwDocuments:aCols, {|o| o:cOrder := '' } )

   if empty( oColumn )
      ::oBrwDocuments:aCols[ 1 ]:cOrder := 'A'
   else
      oColumn:cOrder := 'A' 
   end if 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD selectLine()
   
   local position 

   for each position in ::oBrwLines:aSelected
      ::getLineDocument( position ):select()
   next

   ::oBrwLines:Refresh()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD unselectLine()
   
   local position 

   for each position in ::oBrwLines:aSelected
      ::getLineDocument( position ):unselect()
   next

   ::oBrwLines:Refresh()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD toogleSelectLine()
   
   local position 

   for each position in ::oBrwLines:aSelected
      ::getLineDocument( position ):toogleSelect()
   next

   ::oBrwLines:Refresh()

Return ( Self )

//---------------------------------------------------------------------------//
//
// Convierte las lineas del albaran en objetos
//

METHOD loadLinesDocument( id ) 

   local aStatus
   local lLoadLines     
   local hDictionary    

   lLoadLines           := .f.

   ::oDocumentLines:reset()

   aStatus              := aGetStatus( ::getLineAlias(), .t. )

   if ( ::getLineAlias() )->( dbSeek( id ) )  

      while ( id == ::getLineId() ) .and. !( ::getLineAlias() )->( eof() ) 

         hDictionary    := D():getHashFromAlias( ::getLineAlias(), ::getLineDictionary() )

         ::oDocumentLines:addLines( DocumentLine():newFromDictionary( hDictionary ) )

         ( ::getLineAlias() )->( dbSkip() ) 
      
      end while

      lLoadLines     := .t.

   end if 
   
   setStatus( ::getLineAlias(), aStatus ) 

RETURN ( lLoadLines ) 

//---------------------------------------------------------------------------//

METHOD setBrowseLinesDocument()

   ::oBrwLines:setArray( ::oDocumentLines:getLines(), .t., , .f. )
   
   ::oBrwLines:bSeek := {|c| ::seekLine( c ) }

RETURN ( .t. ) 

//---------------------------------------------------------------------------//

METHOD sortColumn( cExpresion, oColumn )

   aeval( ::oBrwLines:aCols, {|o| o:cOrder := "" } )

   oColumn:cOrder    := "A"

   ::oSortDocument:set( oColumn:cHeader )

   ::oDocumentLines:sortingPleaseWait( cExpresion )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD seekLine( cSeek )

   local nRow
   local uVal
   local nColumnToSearch

   nColumnToSearch         := ascan( ::oBrwLines:aCols, { |o| !Empty( o:cOrder ) } )

   if nColumnToSearch == 0
      Return .f.
   end if 

   nRow                    := ::oBrwLines:nArrayAt

   for ::oBrwLines:nArrayAt := 1 to ::oBrwLines:nLen

      uVal                 := eval( ::oBrwLines:aCols[ nColumnToSearch ]:bEditValue )

      if hb_WildMatch( '*' + cSeek, uVal )
         ::oBrwLines:SelectCurrent()
         Return .t.
      endif
     
   next 

   ::oBrwLines:nArrayAt    := nRow

Return .t.

//---------------------------------------------------------------------------//
