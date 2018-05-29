#include "Factu.ch" 
#include "FiveWin.ch"

//---------------------------------------------------------------------------//

Function EDI_seleccion( lNoExportados, oTree, nView )

   local cSeleccion
   local aDirectorio
   local aSelect        := {}
   local cPath          := cPatScript() + "FacturasClientes\EDI\"

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

FUNCTION MsgCombo( cTitle, cText, aItems, uVar, cBmpFile, cResName )

   local oDlg, oBmp, oCbx
   local lOk      := .f.
   local cItem

   DEFAULT cTitle := "Title"
   DEFAULT cText  := "Valor"
   DEFAULT aItems := { "One", "Two", "Three" }

   cItem          := aItems[1]

   DEFINE DIALOG oDlg FROM 10, 20 TO 18, 59.5 TITLE cTitle

   if ! empty( cBmpFile ) .or. ! empty( cResName )

      if ! empty( cBmpFile )
         @ 1, 1 BITMAP oBmp FILENAME cBmpFile SIZE 20, 20 NO BORDER OF oDlg
      endif

      if ! empty( cResName )
         @ 1, 1 BITMAP oBmp RESOURCE cResName SIZE 20, 20 NO BORDER OF oDlg
      endif

      @ 0.5, 6 SAY cText OF oDlg SIZE 250, 10
      
      @ 1.6, 4 COMBOBOX oCbx VAR cItem ;
      SIZE 120, 12 ;
      ITEMS aItems ;

   else   
      
      @ 0.5, 3.3 SAY cText OF oDlg SIZE 250, 10

      @ 1.6, 2.3 COMBOBOX oCbx VAR cItem ;
      SIZE 120, 12 ;
      ITEMS aItems ;

   endif   

   @ 2.25, 7.5 - If( oBmp == nil, 2, 0 ) BUTTON "&Ok"  OF oDlg SIZE 35, 12 ;
      ACTION ( oDlg:End(), lOk := .t. ) DEFAULT

   @ 2.25, 16.5 - If( oBmp == nil, 2, 0 ) BUTTON "&Cancel" OF oDlg SIZE 35, 12 ;
      ACTION ( oDlg:End(), lOk := .f. )

   ACTIVATE DIALOG oDlg CENTERED

   if lOk
      uVar := cItem
   endif

RETURN lOk

//---------------------------------------------------------------------------//