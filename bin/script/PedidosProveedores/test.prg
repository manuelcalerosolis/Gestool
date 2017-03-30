#include "FiveWin.Ch"


function ImportarPedidosProveedor()

   local oDialog

   msgalert( SetResources( "Test.Dll" ) )

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