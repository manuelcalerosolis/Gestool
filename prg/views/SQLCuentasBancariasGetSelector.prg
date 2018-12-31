#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS CuentasBancariasGetSelector FROM GetSelector

   METHOD getFields()   

END CLASS
   
//---------------------------------------------------------------------------//

METHOD getFields() CLASS CuentasBancariasGetSelector

local hWhere :={}


   hWhere:= {  "codigo" => ::oGet:varGet(),;
               "parent_uuid" => ::oController():getUuidParent(),;
               "deleted_at"=> 0  }

RETURN ( ::uFields := ::oController:getModel():getFieldWhere( "nombre", hWhere ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
