#include "FiveWin.Ch"


function ImportarPedidosProveedor()

   local oDialog

   msgalert( file( fullcurdir() +  "Script\PedidosProveedores\Test.dll" ), fullcurdir() +  "Script\PedidosProveedores\Test.dll" )

   msgalert( SetResources( fullcurdir() + "Script\PedidosProveedores\Test.dll" ) )

   DEFINE DIALOG oDialog RESOURCE "GETSERIE" 

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDialog ;
         ACTION   ( oDialog:End( IDOK ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDialog ;
         ACTION   ( oDialog:End() ) CANCEL

   ACTIVATE DIALOG oDialog

   FreeResources()

return nil