#include "Factu.ch"
#include "FiveWin.Ch"

//---------------------------------------------------------------------------//

function PedidosProveedores()

   local cFichero

   cFichero := ImportarPedidosProveedor():GetFile()

   msgalert( cFichero, "cFichero")

   ImportarPedidosProveedor():ReadFile( cFichero )
   
   msgalert( "terminado" )
   
return .t.

//---------------------------------------------------------------------------//

CLASS ImportarPedidosProveedor

   METHOD GetFile()
   METHOD ReadFile( cFichero )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD GetFile() CLASS ImportarPedidosProveedor

   local cFichero

   cFichero  := cGetFile( ".xls,xlsx | *.xls; *.xlsx", "Seleccione el fichero a importar", "*.xls; *.xlsx" , , .f.)

   if empty(cFichero)
      Return ( "No se encuentra el fichero")
   end if



Return( cFichero)

//----------------------------------------------------------------------------//

METHOD ReadFile( cFichero ) CLASS ImportarPedidosProveedor

   local oOleExcel

   oOleExcel                        := TOleExcel():New( "Importando hoja de excel", "Conectando...", .f. )

      oOleExcel:oExcel:Visible         := .f.
      oOleExcel:oExcel:DisplayAlerts   := .f.
      oOleExcel:oExcel:WorkBooks:Open( cFichero )

      oOleExcel:oExcel:WorkSheets( 1 ):Activate()   //Hojas de la hoja de calculo

   /*
   Si no encontramos mas líneas nos salimos------------------------------
   */

      for n := 1 to 6

         msgalert( oOleExcel:oExcel:ActiveSheet:Range( "A" + lTrim( Str( n ) ) ):Value)

      next

   /*
   Cerramos la conexion con el objeto oOleExcel-----------------------------
   */

   oOleExcel:oExcel:WorkBooks:Close()

   oOleExcel:oExcel:Quit()

   oOleExcel:oExcel:DisplayAlerts   := .t.

   oOleExcel:End()

Return .t.

