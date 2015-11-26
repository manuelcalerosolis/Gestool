#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "Report.ch"
#include "XBrowse.ch"

//---------------------------------------------------------------------------//

CLASS TConversionDocumentos

   DATA oDlg
   DATA oFld

   DATA oBtnAnterior
   DATA oBtnSiguiente
   DATA oBtnSalir

   DATA nView
   DATA lOpenFiles
   DATA cAlias                            INIT ""
   DATA aDictionary
   DATA aIndex

   DATA cDocument   
   DATA aDocuments   

   DATA oSearch
   DATA cSearch
   DATA oSortDocument
   DATA cSortDocument                     INIT "Número"
   DATA aSortDocument                     INIT { "Número", "Fecha", "Nombre" }
   DATA oBrwDocuments

   METHOD New()

   METHOD Dialog()
      METHOD clickOnHeader( oColumn )
      METHOD changeSortDocument()
      METHOD changeSearch()
      METHOD setOrderInColumn( oColumn )  INLINE ( aeval( ::oBrwDocuments:aCols, {|o| o:cOrder := '' } ),;
                                                   if( empty( oColumn ), ::oBrwDocuments:aCols[ 1 ]:cOrder := 'A', oColumn:cOrder := 'A' ) )
      
   METHOD OpenFiles()
   METHOD CloseFiles()

   METHOD BotonSiguiente()
   METHOD BotonAnterior()

   METHOD opcionInvalida()                INLINE ( msgStop( "Opción invalida, por favor elija una opción valida." ), .f. )

   // get the documents data

   METHOD setDocumentType( cDataTable )
   METHOD setDocumentPedidosProveedores() INLINE ( ::setDocumentType( D():PedidosProveedoresTableName() ) )

   METHOD setAlias( cAlias )              INLINE ( ::cAlias := cAlias )
   METHOD getAlias()                      INLINE ( ::cAlias )
   METHOD setDictionary( aDictionary )    INLINE ( ::aDictionary := aDictionary )
   METHOD getDictionary()                 INLINE ( ::aDictionary )
   METHOD setIndex( aIndex )              INLINE ( ::aIndex := aIndex )
   METHOD getIndex()                      INLINE ( ::aIndex )

      METHOD getId()                      INLINE ( D():getFieldFromAliasDictionary( "Serie", ::getAlias(), ::getDictionary() ) + "/" + alltrim( str( D():getFieldFromAliasDictionary( "Numero", ::getAlias(), ::getDictionary() ) ) ) )
      METHOD getDate()                    INLINE ( D():getFieldFromAliasDictionary( "Fecha", ::getAlias(), ::getDictionary() ) )
      METHOD getName()                    INLINE ( D():getFieldFromAliasDictionary( "NombreCliente", ::getAlias(), ::getDictionary() ) )
      METHOD getTotalNeto()               INLINE ( D():getFieldFromAliasDictionary( "TotalNeto", ::getAlias(), ::getDictionary() ) )
      METHOD getTotalImpuesto()           INLINE ( D():getFieldFromAliasDictionary( "TotalImpuesto", ::getAlias(), ::getDictionary() ) )
      METHOD getTotalDocumento()          INLINE ( D():getFieldFromAliasDictionary( "TotalDocumento", ::getAlias(), ::getDictionary() ) )

   METHOD runAction() 

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New()

   ::cDocument    := ""
   ::aDocuments   := {  "Compras" =>                                                   {|| ::opcionInvalida() },;                                    
                        space( 3 ) + "Pedido proveedores" =>                           {|| ::setDocumentPedidosProveedores(), .t. },;
                        space( 3 ) + "Albarán proveedores" =>                          {|| msgAlert( "Albarán proveedores" ), .t. },;
                        space( 3 ) + "Factura proveedores" =>                          {|| msgAlert( "Factura proveedores" ) },;
                        space( 3 ) + "Factura rectificativas proveedores" =>           {|| msgAlert( "Factura rectificativas proveedores" ), .t. },;
                        space( 3 ) + "Recibos de proveedores" =>                       {|| msgAlert( "Recibos de proveedores" ), .t. },;
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
               "ASS_CONVERSION_DOCUMENTO_2"

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

   ::oBrwDocuments:cAlias           := ::getAlias()
   ::oBrwDocuments:nMarqueeStyle    := 5
   ::oBrwDocuments:cName            := "Browse.Conversion documentos"

   with object ( ::oBrwDocuments:AddCol() )
      :cHeader                      := "Número"
      :bEditValue                   := {|| ::getId() }
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
   end with

   with object ( ::oBrwDocuments:AddCol() )
      :cHeader                      := "Nombre"
      :bEditValue                   := {|| ::getName() }
      :nWidth                       := 400
      :cSortOrder                   := "Fecha"
      :bLClickHeader                := {| nMRow, nMCol, nFlags, oColumn | ::clickOnHeader( oColumn ) }
   end with

   with object ( ::oBrwDocuments:AddCol() )
      :cHeader                      := "Base"
      :bEditValue                   := {|| ::getTotalNeto() }
      :cEditPicture                 := cPirDiv()
      :nWidth                       := 80
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
   end with

   with object ( ::oBrwDocuments:AddCol() )
      :cHeader                      := cImp()
      :bEditValue                   := {|| ::getTotalImpuesto() }
      :cEditPicture                 := cPirDiv()
      :nWidth                       := 80
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
   end with

   with object ( ::oBrwDocuments:AddCol() )
      :cHeader                      := "Total"
      :bEditValue                   := {|| ::getTotalDocumento() }
      :cEditPicture                 := cPirDiv()
      :nWidth                       := 80
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
   end with

   ::oBrwDocuments:CreateFromResource( 120 )

   // Botones -----------------------------------------------------------------

   REDEFINE BUTTON ::oBtnAnterior;
      ID       3 ;
      OF       ::oDlg ;
      ACTION   ( ::BotonAnterior() )

   REDEFINE BUTTON ::oBtnSiguiente;
      ID       IDOK ;
      OF       ::oDlg ;
      ACTION   ( ::BotonSiguiente() )

   REDEFINE BUTTON ;
      ID       IDCANCEL ;
      OF       ::oDlg ;
      ACTION   ( ::oDlg:End() )

   // ::oDlg:bStart := {|| ::oBtnInforme:Disable() }

   ACTIVATE DIALOG ::oDlg CENTER

   ::CloseFiles()

   oBmp:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

Method BotonSiguiente()

   do case
      case ::oFld:nOption == 1
         if ::runAction()
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

METHOD runAction()

   local lAction  := .t.
   local bAction  := hget( ::aDocuments, ::cDocument )

   if isBlock( bAction )
      lAction     :=  eval( bAction )
   else 
      lAction     := ::opcionInvalida()
   end if 

Return ( lAction )

//---------------------------------------------------------------------------//

METHOD setDocumentType( cTableName )

   ::setAlias(       D():Get( cTableName, ::nView ) )
   ::setDictionary(  D():getDictionaryFromArea( cTableName ) )
   ::setIndex(       D():getIndexFromArea( cTableName ) )

   ::setOrderInColumn()   

Return ( Self )

//---------------------------------------------------------------------------//

METHOD clickOnHeader( oColumn )
   
   local cTag

   if !empty( oColumn ) .and. !empty( oColumn:cSortOrder )
      cTag           := D():getIndexFromAliasDictionary( oColumn:cSortOrder, ::getIndex() ) 
   end if 

   if empty( cTag )
      Return ( Self )
   end if 

   ( ::getAlias() )->( ordsetfocus( cTag ) )

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
   local cSearch  := ::oSearch:varGet()

   lSeek          := lSeekKeySimple( cSearch, ::getAlias() ) // lMiniSeek( xCadena, cAlias, ::cSearchType, ::nLenSearchType )

   if ( !lSeek .and. ( ( ::getAlias )->( ordnumber() ) == 1 ) )
      lSeek       := seekDocumentoSimple( cSearch, ::getAlias() )          
   end if 

   if lSeek 
      ::oBrwDocuments:Refresh()
   end if 

Return ( .t. )

//---------------------------------------------------------------------------//





