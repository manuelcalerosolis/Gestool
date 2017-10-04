#include "FiveWin.Ch"


PROCEDURE MAIN()

   LOCAL oWnd, oMenu

   MENU oMenu
      MENUITEM "&Probar OLE con..."
      MENU
         MENUITEM "&Excel" ACTION EXCEL97()
         MENUITEM "&Word"  ACTION WORD97()
         MENUITEM "&Internet Explorer"  ACTION IEXPLORER()
         SEPARATOR
         MENUITEM "&Salir" ACTION oWnd:End()
      ENDMENU
   ENDMENU

   DEFINE WINDOW oWnd FROM 0,0 TO 20,70 TITLE "OLE con FW" MENU oMenu
   ACTIVATE WINDOW oWnd MAXIMIZED

RETURN

//--------------------------------------------------------------------

STATIC PROCEDURE EXCEL97()

   LOCAL oExcel, oHoja

   oExcel := TOleAuto():New( "Excel.Application" )
   //oExcel := TOleAuto():New( "{00024500-0000-0000-C000-000000000046}" )

   oExcel:WorkBooks:Add()

   oHoja := oExcel:Get( "ActiveSheet" )

   oHoja:Cells:Font:Name := "Arial"
   oHoja:Cells:Font:Size := 12

   oHoja:Cells( 3, 1 ):Value := "Texto:"
   oHoja:Cells( 3, 2 ):Value := "Esto es un texto"
   oHoja:Cells( 4, 1 ):Value := "Número:"
   oHoja:Cells( 4, 2 ):Set( "NumberFormat", "#.##0,00" )
   oHoja:Cells( 4, 2 ):Value := 1234.50
   oHoja:Cells( 5, 1 ):Value := "Lógico:"
   oHoja:Cells( 5, 2 ):Value := .T.
   oHoja:Cells( 6, 1 ):Value := "Fecha:"
   oHoja:Cells( 6, 2 ):Value := DATE()

   oHoja:Columns( 1 ):Font:Bold := .T.
   oHoja:Columns( 2 ):Set( "HorizontalAlignment", -4152 )  // xlRight

   oHoja:Columns( 1 ):AutoFit()
   oHoja:Columns( 2 ):AutoFit()

   oHoja:Cells( 1, 1 ):Value := "OLE desde FW"
   oHoja:Cells( 1, 1 ):Font:Size := 16
   oHoja:Range( "A1:B1" ):Set( "HorizontalAlignment", 7 )

   oHoja:Cells( 1, 1 ):Select()
   oExcel:Visible := .T.

   oHoja:End()
   oExcel:End()

RETURN

//--------------------------------------------------------------------

STATIC PROCEDURE WORD97()

   LOCAL oWord, oTexto

   oWord:=TOleAuto():New( "Word.Application" )

   oWord:Documents:Add()

   oTexto := oWord:Selection()

   oTexto:Text := "OLE desde FW"+CRLF
   oTexto:Font:Name := "Arial"
   oTexto:Font:Size := 48
   oTexto:Font:Bold := .T.

   oWord:Visible := .T.
   oWord:Set( "WindowState", 1 )  // Maximizado

   oTexto:End()
   oWord:End()

RETURN

//--------------------------------------------------------------------

STATIC PROCEDURE IEXPLORER()

   LOCAL oIE

   oIE:=TOleAuto():New( "InternetExplorer.Application" )

   oIE:Visible := .T.

   oIE:Invoke("Navigate", "http://www.fivetech.com")

   oIE:End()

RETURN