#include "FiveWin.Ch"
#include "Factu.ch"

Function ImportarPedidosProveedor( nView )                  
         
   local oImportarPedidosProveedor    := TImportarPedidosProveedor():New( nView )

   oImportarPedidosProveedor:Run()

Return nil

//---------------------------------------------------------------------------//  

CLASS TImportarPedidosProveedor

   DATA oDialog
   DATA nView

   DATA oCodigoProveedor
   DATA cCodigoProveedor
   DATA oNombreProveedor
   DATA cNombreProveedor

   METHOD New()

   METHOD Run()

   METHOD SetResources()   INLINE ( SetResources( fullcurdir() + "Script\PedidosProveedores\agruparmuriel.dll" ) )

   METHOD FreeResources()   INLINE ( FreeResources() )

   METHOD Resource() 

   METHOD lValidProcess()

   METHOD Process()

END CLASS

//----------------------------------------------------------------------------//

METHOD New( nView ) CLASS TImportarPedidosProveedor

   ::nView                    := nView

   ::cCodigoProveedor         := Space( 12 )
   ::cNombreProveedor         := Space( 200 )

Return ( Self )

//----------------------------------------------------------------------------//

METHOD Run() CLASS TImportarPedidosProveedor

   ::SetResources()

   ::Resource()

   ::FreeResources()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD Resource() CLASS TImportarPedidosProveedor

   DEFINE DIALOG ::oDialog RESOURCE "AGRUPARPEDIDOS" 

      REDEFINE GET   ::oCodigoProveedor ;
         VAR         ::cCodigoProveedor ;
         ID          100 ;
         BITMAP      "LUPA" ;
         OF          ::oDialog

         //ON HELP     ( BrwPrv( ::oCodigoProveedor, ::oNombreProveedor, D():Proveedores( ::nView ) ) ) ;

         ::oCodigoProveedor:bHelp   := BrwPrv( ::oCodigoProveedor, ::oNombreProveedor, D():Proveedores( ::nView ) )

      REDEFINE GET   ::oNombreProveedor ;
         VAR         ::cNombreProveedor ;
         ID          110 ;
         WHEN        ( .f. ) ;
         OF          ::oDialog

      REDEFINE BUTTON ;
         ID          IDOK ;
         OF          ::oDialog ;
         ACTION      ( if( ::lValidProcess(), ::Process(), ) )

      REDEFINE BUTTON ;
         ID          IDCANCEL ;
         OF          ::oDialog ;
         ACTION      ( ::oDialog:End( IDCANCEL ) )

   ACTIVATE DIALOG ::oDialog CENTER

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD lValidProcess() CLASS TImportarPedidosProveedor

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD Process() CLASS TImportarPedidosProveedor

   ::oDialog:End( IDOK )

Return ( .t. )

//---------------------------------------------------------------------------//
