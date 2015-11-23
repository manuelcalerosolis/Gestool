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
   DATA cDictionary

   DATA cDocument   
   DATA aDocuments   

   DATA oSearch
   DATA cSearch
   DATA oSort
   DATA cSort
   DATA aSort                             INIT { "Número documento" }
   DATA oBrwDocuments

   METHOD New()

   METHOD Dialog()
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
   METHOD setDictionary( cDictionary )    INLINE ( ::cDictionary := cDictionary )
   METHOD getDictionary( cDictionary )    INLINE ( ::cDictionary )

      METHOD getId()
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

   msgAlert( ::getAlias(), "getAlias" )
   msgAlert( ::getId() )
   msgAlert( ::getName() )

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
      ON CHANGE( msgAlert( "changeSearch" ) );
      BITMAP   "Find" ;
      OF       ::oFld:aDialogs[2]

   REDEFINE COMBOBOX ::oSort ;
      VAR      ::cSort ;
      ITEMS    ::aSort ;
      ID       110 ;
      ON CHANGE( ::oBrwDocuments:Refresh() );
      OF       ::oFld:aDialogs[2]

   ::oBrwDocuments                  := IXBrowse():New( ::oFld:aDialogs[2] )

   ::oBrwDocuments:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrwDocuments:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   ::oBrwDocuments:cAlias           := ::getAlias()
   ::oBrwDocuments:nMarqueeStyle    := 5
   ::oBrwDocuments:cName            := "Browse.Conversion documentos"

   with object ( ::oBrwDocuments:AddCol() )
      :cHeader                      := "Código"
      :bEditValue                   := {|| ::getId() }
      :nWidth                       := 80
   end with

   with object ( ::oBrwDocuments:AddCol() )
      :cHeader                      := "Fecha"
      :bEditValue                   := {|| ::getDate() }
      :nWidth                       := 80
   end with

   with object ( ::oBrwDocuments:AddCol() )
      :cHeader                      := "Nombre"
      :bEditValue                   := {|| ::getName() }
      :nWidth                       := 300
   end with

   with object ( ::oBrwDocuments:AddCol() )
      :cHeader                      := "Base"
      :bEditValue                   := {|| ::getTotalNeto() }
      :nWidth                       := 80
   end with

   with object ( ::oBrwDocuments:AddCol() )
      :cHeader                      := cImp()
      :bEditValue                   := {|| ::getTotalImpuesto() }
      :nWidth                       := 80
   end with

   with object ( ::oBrwDocuments:AddCol() )
      :cHeader                      := "Total"
      :bEditValue                   := {|| ::getTotalDocumento() }
      :nWidth                       := 80
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
   msgAlert( hb_valtoexp( ::getDictionary() ) ) 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD getId()

   local id    := ""

   id          += D():getFieldFromAliasDictionary( "Serie", ::getAlias(), ::getDictionary() )
   id          += "/"
   id          += D():getFieldFromAliasDictionary( "Numero", ::getAlias(), ::getDictionary() )

RETURN ( id )

//---------------------------------------------------------------------------//


