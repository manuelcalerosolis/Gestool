#include "Factu.ch" 
#include "FiveWin.ch"

//---------------------------------------------------------------------------//

Function EDI_seleccion( lNoExportados, oTree, nView )

   local cSeleccion
   local aDirectorio
   local aSelect        := {}
   local cPath          := cPatScript() + "FacturasClientes\EDI\"

      MsgInfo( "Entro en el script" )

      aDirectorio       := Directory( cPath, "D" )

      AEval( aDirectorio, {|x| if( x[5] == "D" .and. x[1] != "." .and. x[1] != "..", aAdd( aSelect, x[1] ), "" ) } )

      MsgCombo( "Seleccione una opción", "Seleccione el script a ejecutar", aSelect, @cSeleccion )

      if !Empty( cSeleccion )

         if isdir( cPath + cSeleccion ) 

            aDirectorio       := Directory( cPath + cSeleccion + "\*.prg" )

            AEval( aDirectorio, {|x| if( File( cPath + cSeleccion + "\" + x[1] ), RunScript( "FacturasClientes\EDI\" + cSeleccion + "\" + x[1], lNoExportados, oTree, nView ), ) } )

         end if

      end if

Return nil

//---------------------------------------------------------------------------//