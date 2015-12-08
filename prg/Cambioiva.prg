#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "Report.ch"
#include "XBrowse.ch"

//---------------------------------------------------------------------------//

CLASS TConversionDocumentos

   DATA oDocumentLine

   DATA oDlg
   DATA oFld

   DATA oBtnAnterior
   DATA oBtnSiguiente
   DATA oBtnSalir

   DATA nView
   DATA lOpenFiles

   DATA cHeaderAlias                               INIT ""
   DATA aHeaderDictionary
   DATA aHeaderIndex

   DATA cLinesAlias                                INIT ""
   DATA aLinesDictionary
   DATA aLinesIndex

   DATA cDocument   
   DATA aDocuments   

   DATA oSearch
   DATA cSearch
   DATA oSortDocument
   DATA cSortDocument                              INIT "Número"
   DATA aSortDocument                              INIT { "Número", "Fecha", "Nombre" }
   
   DATA oBrwDocuments

   DATA oBrwLines
   DATA aSelectedLines                             INIT {}

   DATA cPictureRound
   DATA nDecimalPrice
   DATA nRoundDecimalPrice

   METHOD New()

   METHOD Dialog()
      METHOD startDialog()
      METHOD clickOnHeader( oColumn )
      METHOD changeSortDocument()
      METHOD changeSearch()
      METHOD setOrderInColumn( oColumn )  

   METHOD OpenFiles()
   METHOD CloseFiles()

   METHOD BotonSiguiente()
   METHOD BotonAnterior()

   METHOD selectLine()                             
   METHOD unSelectLine()                           
   METHOD toogleSelectLine()
   METHOD selectAllLine()                          
   METHOD unselectAllLine()                        INLINE ( ::aSelectedLines := {}, ::oBrwLines:Refresh() )
   METHOD positionSelectedLine()                   INLINE ( ascan( ::aSelectedLines, ::getRecnoArticle() ) )

   METHOD opcionInvalida()                         INLINE ( msgStop( "Opción invalida, por favor elija una opción valida." ), .f. )

   METHOD setSalesPictures()                       INLINE ( ::cPictureRound      := cPorDiv(),;
                                                            ::nDecimalPrice      := nDinDiv(),;
                                                            ::nRoundDecimalPrice := nRinDiv() )

   METHOD setShoppingPictures()                    INLINE ( ::cPictureRound      := cPirDiv(),;
                                                            ::nDecimalPrice      := nDouDiv(),;
                                                            ::nRoundDecimalPrice := nRouDiv() )

   // get the documents data---------------------------------------------------

   METHOD setDocumentType( cDataTable )
   METHOD setSalesDocumentType( cHeaderTable, cLineTable ) ;
                                                   INLINE ( ::setSalesPictures(), ::setDocumentType( cHeaderTable, cLineTable ) )
   METHOD setShoppingDocumentType( cHeaderTable, cLineTable ) ;
                                                   INLINE ( ::setShoppingPictures(), ::setDocumentType( cHeaderTable, cLineTable ) )
   METHOD setDocumentPedidosProveedores()          INLINE ( ::setShoppingDocumentType( D():PedidosProveedoresTableName(), D():PedidosProveedoresLineasTableName() ) )

   METHOD setHeaderAlias( cHeaderAlias )           INLINE ( ::cHeaderAlias := cHeaderAlias )
   METHOD getHeaderAlias()                         INLINE ( ::cHeaderAlias )
   METHOD setHeaderDictionary( aHeaderDictionary ) INLINE ( ::aHeaderDictionary := aHeaderDictionary )
   METHOD getHeaderDictionary()                    INLINE ( ::aHeaderDictionary )
   METHOD setHeaderIndex( aHeaderIndex )           INLINE ( ::aHeaderIndex := aHeaderIndex )
   METHOD getHeaderIndex()                         INLINE ( ::aHeaderIndex )

   METHOD setLinesAlias( cLinesAlias )             INLINE ( ::cLinesAlias := cLinesAlias )
   METHOD getLinesAlias()                          INLINE ( ::cLinesAlias )
   METHOD setLinesDictionary( aLinesDictionary )   INLINE ( ::aLinesDictionary := aLinesDictionary )
   METHOD getLinesDictionary()                     INLINE ( ::aLinesDictionary )
   METHOD setLinesIndex( aLinesIndex )             INLINE ( ::aLinesIndex := aLinesIndex )
   METHOD getLinesIndex()                          INLINE ( ::aLinesIndex )
   METHOD setLinesScope( Id )                      INLINE ( ( ::getLinesAlias() )->( ordscope( 0, Id ) ),;
                                                            ( ::getLinesAlias() )->( ordscope( 1, Id ) ),;
                                                            ( ::getLinesAlias() )->( dbgotop() ) ) 
   METHOD quitLinesScope()                         INLINE ( ::setLinesScope( nil ) )

      METHOD getId()                               INLINE ( D():getFieldFromAliasDictionary( "Serie", ::getHeaderAlias(), ::getHeaderDictionary() ) + ;
                                                            str( D():getFieldFromAliasDictionary( "Numero", ::getHeaderAlias(), ::getHeaderDictionary() ) ) + ; 
                                                            D():getFieldFromAliasDictionary( "Sufijo", ::getHeaderAlias(), ::getHeaderDictionary() ) )
      METHOD getTextId()                           INLINE ( D():getFieldFromAliasDictionary( "Serie", ::getHeaderAlias(), ::getHeaderDictionary() ) + "/" + ;
                                                            alltrim( str( D():getFieldFromAliasDictionary( "Numero", ::getHeaderAlias(), ::getHeaderDictionary() ) ) ) )
      METHOD getDate()                             INLINE ( D():getFieldFromAliasDictionary( "Fecha", ::getHeaderAlias(), ::getHeaderDictionary() ) )
      METHOD getName()                             INLINE ( D():getFieldFromAliasDictionary( "NombreCliente", ::getHeaderAlias(), ::getHeaderDictionary() ) )
      METHOD getTotalNeto()                        INLINE ( D():getFieldFromAliasDictionary( "TotalNeto", ::getHeaderAlias(), ::getHeaderDictionary() ) )
      METHOD getTotalImpuesto()                    INLINE ( D():getFieldFromAliasDictionary( "TotalImpuesto", ::getHeaderAlias(), ::getHeaderDictionary() ) )
      METHOD getTotalDocumento()                   INLINE ( D():getFieldFromAliasDictionary( "TotalDocumento", ::getHeaderAlias(), ::getHeaderDictionary() ) )

      METHOD getRecnoArticle()                     INLINE ( ( ::getLinesAlias() )->( recno() ) )

      METHOD getTotalArticle()

   METHOD showDocuments() 
   METHOD showDocumentsLines()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New()

   ::cDocument       := "" // "Pedido proveedores"
   ::aDocuments      := {  "Compras" =>                                                   {|| ::opcionInvalida() },;                                    
                           space( 3 ) + "Pedido proveedores" =>                           {|| ::setDocumentPedidosProveedores() },;
                           space( 3 ) + "Albarán proveedores" =>                          {|| msgAlert( "Albarán proveedores" ) },;
                           space( 3 ) + "Factura proveedores" =>                          {|| msgAlert( "Factura proveedores" ) },;
                           space( 3 ) + "Factura rectificativas proveedores" =>           {|| msgAlert( "Factura rectificativas proveedores" ) },;
                           space( 3 ) + "Recibos de proveedores" =>                       {|| msgAlert( "Recibos de proveedores" ) },;
                           "Ventas" =>                                                    {|| ::opcionInvalida() },;                                    
                           space( 3 ) + "S.A.T. clientes" =>                              {|| msgAlert( "" ), .t. },;
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

   ::OpenFiles()

   ::oDocumentLine   := AliasDocumentLine():New( Self )   

   ::setDocumentPedidosProveedores()

RETURN ( Self )

//----------------------------------------------------------------------------//
   
METHOD Dialog() 

   local oBmp

   DEFINE DIALOG ::oDlg RESOURCE "ASS_CONVERSION_DOCUMENTO"

   REDEFINE BITMAP oBmp ;
      ID       500 ;
      RESOURCE "hand_point_48" ;
      TRANSPARENT ;
      OF       ::oDlg

   REDEFINE PAGES ::oFld ;
      ID       100;
      OF       ::oDlg ;
      DIALOGS  "ASS_CONVERSION_DOCUMENTO_1",;
               "ASS_CONVERSION_DOCUMENTO_2",;
               "ASS_CONVERSION_DOCUMENTO_3"

   REDEFINE COMBOBOX ::cDocument ;
      ITEMS    hgetkeys( ::aDocuments );
      ID       100 ;
      OF       ::oFld:aDialogs[1]

   // segundo dialogo-----------------------------------------------------------

   REDEFINE GET ::oSearch ;
      VAR      ::cSearch ;
      ID       100 ;
      PICTURE  "@!" ;
      BITMAP   "Find" ;
      OF       ::oFld:aDialogs[2]

   ::oSearch:bChange                := {|| ::changeSearch() }

   REDEFINE COMBOBOX ::oSortDocument ;
      VAR      ::cSortDocument ;
      ITEMS    ::aSortDocument ;
      ID       110 ;
      ON CHANGE( ::changeSortDocument() );
      OF       ::oFld:aDialogs[2]

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
      :bEditValue                   := {|| ::getTextId() }
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

   // botones -----------------------------------------------------------------
   
   REDEFINE BUTTON ;
      ID       500 ;
      OF       ::oFld:aDialogs[3] ;
      ACTION   ( ::selectLine() )

   REDEFINE BUTTON ;
      ID       510 ;
      OF       ::oFld:aDialogs[3] ;
      ACTION   ( ::unselectLine() )

   REDEFINE BUTTON ;
      ID       520 ;
      OF       ::oFld:aDialogs[3] ;
      ACTION   ( ::selectAllLine() )

   REDEFINE BUTTON ;
      ID       530 ;
      OF       ::oFld:aDialogs[3] ;
      ACTION   ( ::unselectAllLine() )
   
   // browse de lineas-----------------------------------------------------

   ::oBrwLines                      := IXBrowse():New( ::oFld:aDialogs[3] )

   ::oBrwLines:lAutoSort            := .f.
   ::oBrwLines:bClrSel              := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrwLines:bClrSelFocus         := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   ::oBrwLines:cAlias               := ::getLinesAlias()
   ::oBrwLines:nMarqueeStyle        := 5
   ::oBrwLines:cName                := "Browse.Conversion documentos lineas"
   ::oBrwLines:bLDblClick           := {|| ::toogleSelectLine() }

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "Seleccionando"
      :bEditValue                   := {|| aScan( ::aSelectedLines, ::getRecnoArticle() ) > 0 }
      :nWidth                       := 20
      :SetCheck( { "Sel16", "Nil16" } )
   end with
  
   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "Código"
      :bEditValue                   := {|| ::oDocumentLine:getCode() }
      :nWidth                       := 80
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "Descripción"
      :bEditValue                   := {|| ::oDocumentLine:getDescription() }
      :nWidth                       := 340
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "Prop. 1"
      :bEditValue                   := {|| ::oDocumentLine:getCodeFirstProperty() }
      :nWidth                       := 60
      :lHide                        := .t.
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "Prop. 2"
      :bEditValue                   := {|| ::oDocumentLine:getCodeSecondProperty() }
      :nWidth                       := 60
      :lHide                        := .t.
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "Valor propiedad 1"
      :bEditValue                   := {|| ::oDocumentLine:getValueFirstProperty() }
      :nWidth                       := 60
      :lHide                        := .t.
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "Valor propiedad 2"
      :bEditValue                   := {|| ::oDocumentLine:getValueSecondProperty() }
      :nWidth                       := 60
      :lHide                        := .t.
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "Nombre propiedad 1"
      :bEditValue                   := {|| ::oDocumentLine:getNameFirstProperty() }
      :nWidth                       := 60
      :lHide                        := .t.
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "Nombre propiedad 2"
      :bEditValue                   := {|| ::oDocumentLine:getNameSecondProperty() }
      :nWidth                       := 60
      :lHide                        := .t.
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "Lote"
      :bEditValue                   := {|| ::oDocumentLine:getLote() }
      :nWidth                       := 80
      :lHide                        := .t.
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := cNombreCajas()
      :bEditValue                   := {|| ::oDocumentLine:getBoxes() }
      :cEditPicture                 := masUnd()
      :nWidth                       := 50
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
      :lHide                        := .t.
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := cNombreUnidades()
      :bEditValue                   := {|| ::oDocumentLine:getUnits() }
      :cEditPicture                 := masUnd()
      :nWidth                       := 60
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
      :lHide                        := .t.
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "Total " + cNombreUnidades()
      :bEditValue                   := {|| ::oDocumentLine:getTotalUnits() }
      :cEditPicture                 := masUnd()
      :nWidth                       := 60
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
      :lHide                        := .f.
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "UM. Unidad de medición"
      :bEditValue                   := {|| ::oDocumentLine:getMeasurementUnit() }
      :nWidth                       := 25
      :lHide                        := .t.
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "Almacen"
      :bEditValue                   := {|| ::oDocumentLine:getStore() }
      :nWidth                       := 60
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "Importe"
      :bEditValue                   := {|| ::oDocumentLine:getPrice() }
      :cEditPicture                 := ::cPictureRound
      :nWidth                       := 90
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "% Dto."
      :bEditValue                   := {|| ::oDocumentLine:getPercentageDiscount() }
      :cEditPicture                 := "@E 999.99"
      :nWidth                       := 50
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
      :lHide                        := .t.
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "% Dto."
      :bEditValue                   := {|| ::oDocumentLine:getPercentagePromotion() }
      :cEditPicture                 := "@E 999.99"
      :nWidth                       := 50
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
      :lHide                        := .t.
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "% " + cImp()
      :bEditValue                   := {|| ::oDocumentLine:getPercentageTax() }
      :cEditPicture                 := "@E 999.99"
      :nWidth                       := 50
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
   end with

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "Total"
      :bEditValue                   := {|| ::oDocumentLine:getTotal() }
      :cEditPicture                 := ::cPictureRound
      :nWidth                       := 80
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
   end with

   ::oBrwLines:CreateFromResource( 100 )

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

METHOD startDialog()

   ::oBrwDocuments:Load()

   ::oBrwLines:Load()
   
RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD BotonSiguiente()

   do case
      case ::oFld:nOption == 1
         if ::showDocuments()
            ::oFld:goNext()
         end if

      case ::oFld:nOption == 2
         if ::showDocumentsLines()
            ::oFld:goNext()
         end if

   end case

Return ( Self )

//---------------------------------------------------------------------------//

Method BotonAnterior()

   ::oFld:goPrev()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      ::lOpenFiles      := .t.

      ::nView           := D():CreateView()

      D():Proveedores( ::nView )

      D():GruposProveedores( ::nView )

      D():PedidosProveedores( ::nView )

      D():PedidosProveedoresLineas( ::nView )

      D():PedidosProveedoresIncidencias( ::nView )

      D():PedidosProveedoresDocumentos( ::nView )

      D():PropiedadesLineas( ::nView )

      D():Clientes( ::nView )

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

METHOD showDocuments()

   local bAction  
   local lAction  := .f.

   if empty( ::cDocument )
      Return ( lAction )
   end if 

   bAction        := hget( ::aDocuments, ::cDocument )
   if isBlock( bAction )
      lAction     :=  eval( bAction )
   end if 

Return ( lAction )

//---------------------------------------------------------------------------//

METHOD showDocumentsLines()

   local Id       := ::getId()

   if empty( Id )
      Return ( .f. )
   end if 

   ::setLinesScope( Id )

   ::selectAllLine()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD setDocumentType( cTableName, cTableLineName )

   ::setHeaderAlias(       D():get( cTableName, ::nView ) )
   ::setHeaderDictionary(  D():getDictionaryFromArea( cTableName ) )
   ::setHeaderIndex(       D():getIndexFromArea( cTableName ) )

   ::setLinesAlias(        D():get( cTableLineName, ::nView ) )
   ::setLinesDictionary(   D():getDictionaryFromArea( cTableLineName ) )

   ::oDocumentLine:setAlias(        D():get( cTableLineName, ::nView ) )
   ::oDocumentLine:setDictionary(   D():getDictionaryFromArea( cTableLineName ) )

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

   if ::positionSelectedLine() == 0
      aadd( ::aSelectedLines, ::getRecnoArticle() )
      ::oBrwLines:DrawLine( .t. )
   endif

Return ( Self )

//---------------------------------------------------------------------------//

METHOD unselectLine()

   local nAt   := ::positionSelectedLine()

   if nAt != 0
      adel( ::aSelectedLines, nAt, .t. )
      ::oBrwLines:DrawLine( .t. )
   end if 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD toogleSelectLine()

   local nAt   := ::positionSelectedLine()

   if nAt != 0
      adel( ::aSelectedLines, nAt, .t. )
   else
      aadd( ::aSelectedLines, ::getRecnoArticle() )
   end if 

   ::oBrwLines:DrawLine( .t. )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD selectAllLine()

   local recno       := ::getRecnoArticle()

   ::aSelectedLines  := {}

   CursorWait()

   ( ::getLinesAlias() )->( dbgotop() ) 
   while !( ( ::getLinesAlias() )->( eof() ) )
      aadd( ::aSelectedLines, ::getRecnoArticle() )
      ( ::getLinesAlias() )->( dbskip() )
   enddo
   
   ( ::getLinesAlias() )->( dbgoto( recno ) )

   CursorArrow()

   ::oBrwLines:Refresh()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD getTotalArticle()                     

   local nTotalArticle  := ::getPriceArticle()

   if ::getPercentageDiscount() != 0
      nTotalArticle     -= nTotalArticle * ::getPercentageDiscount() / 100
   end if 

   if ::getPercentagePromotion() != 0
      nTotalArticle     -= nTotalArticle * ::getPercentagePromotion() / 100
   end if 

   nTotalArticle        *= ::getTotalUnitsArticle()

   nTotalArticle        := round( nTotalArticle, ::nRoundDecimalPrice )

RETURN ( nTotalArticle )

//---------------------------------------------------------------------------//
