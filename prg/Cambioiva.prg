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

   DATA cDocument   
   DATA aDocuments   

   METHOD New()

   METHOD Dialog()
      METHOD OpenFiles()
      METHOD CloseFiles()

   METHOD BotonSiguiente()
   METHOD BotonAnterior()

   METHOD opcionInvalida()    INLINE ( msgStop( "Opción invalida, por favor elija una opción valida.") )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New()

   ::cDocument    := ""
   ::aDocuments   := {  "Compras" =>                                    {|| ::opcionInvalida() },;                                    
                              "Pedido proveedores" =>                         {|| msgAlert( "" ) },;
                              "Albarán proveedores" =>                        {|| msgAlert( "" ) },;
                              "Factura proveedores" =>                        {|| msgAlert( "" ) },;
                              "Factura rectificativas proveedores" =>         {|| msgAlert( "" ) },;
                              "Recibos facturas proveedor" =>                 {|| msgAlert( "" ) },;
                              "S.A.T. clientes" =>                            {|| msgAlert( "" ) },;
                              "Presupuesto clientes" =>                       {|| msgAlert( "" ) },;
                              "Pedido clientes" =>                            {|| msgAlert( "" ) },;
                              "Albarán clientes" =>                           {|| msgAlert( "" ) },;
                              "Factura clientes" =>                           {|| msgAlert( "" ) },;
                              "Factura de anticipos" =>                       {|| msgAlert( "" ) },;
                              "Factura rectificativa" =>                      {|| msgAlert( "" ) },;
                              "Recibos facturas clientes" =>                  {|| msgAlert( "" ) },;
                              "Tickets clientes" =>                           {|| msgAlert( "" ) },;
                              "Depositos almacén" =>                          {|| msgAlert( "" ) },;
                              "Existencias almacén" =>                        {|| msgAlert( "" ) },;
                              "Remesas de movimientos de almacén" =>          {|| msgAlert( "" ) },;
                              "Entregas a cuenta en pedidos de clientes" =>   {|| msgAlert( "" ) },;
                              "Entregas a cuenta en albaranes de clientes" => {|| msgAlert( "" ) },;
                              "Parte de producción" =>                        {|| msgAlert( "" ) },;
                              "Expedientes" =>                                {|| msgAlert( "" ) },;
                              "Arqueo de sesiones" =>                         {|| msgAlert( "" ) },;
                              "Pagos de clientes" =>                          {|| msgAlert( "" ) },;
                              "Liquidación de agentes" =>                     {|| msgAlert( "" ) } }

   ::OpenFiles()

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
      ITEMS    { "Compras" };
      ID       251 ;
      OF       ::oFld:aDialogs[1]

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

   ::oFld:goNext()

return ( Self )

//---------------------------------------------------------------------------//

Method BotonAnterior()

   ::oFld:goPrev()

return ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      ::lOpenFiles      := .t.

      ::nView           := D():CreateView()

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

   D():CloseView( ::nView )

   ::lCloseFiles        := .f.

Return ( Self )

//---------------------------------------------------------------------------//

