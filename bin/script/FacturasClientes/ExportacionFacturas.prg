#include "hbclass.ch"

#define CRLF chr( 13 ) + chr( 10 )

//---------------------------------------------------------------------------//

Function Inicio()

   local oExportacionFacturas
   local cOld              := HB_LangSelect( "EN" )

   oExportacionFacturas    := ExportacionFacturas():New()

   HB_LangSelect( cOld )

Return ( nil )

//---------------------------------------------------------------------------//

CREATE CLASS ExportacionFacturas

   DATA nView

   DATA dInicio               INIT  ( BoY( Date() ) ) 
   DATA dFin                  INIT  ( EoY( Date() ) ) 

   DATA hProduct
   DATA aProducts             INIT {}
   DATA aProductsSales        INIT {}

   DATA oExcel
   DATA oBook

   METHOD New()               CONSTRUCTOR

   METHOD Dialog()
   METHOD OpenFiles()
   METHOD CloseFiles()        INLINE ( D():DeleteView( ::nView ) )

   METHOD Run()               INLINE ( ::processInformation(), ::writeInExcel(), ::closeFiles() )

   METHOD processInformation()

   METHOD buildFacturaInformation()

   METHOD openExcel()
      METHOD writeInExcel()
      METHOD writeDetail()
   METHOD closeExcel()     

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS ExportacionFacturas

   if !::Dialog() 
      Return ( Self )
   end if 

   if !::OpenFiles()
      Return ( Self )
   end if 

   ::aProducts       := {}

   MsgRun( "Porcesando facturas", "Espere por favor...", {|| ::Run() } )

   msgInfo( "Porceso finalizado" )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD Dialog() CLASS ExportacionFacturas

   local oDlg
   local oBtn
   local getFechaFin

   oDlg 						:= TDialog():New( 5, 5, 15, 40, "Exportación facturas" )

   TSay():New( 1, 1, {|| "Desde" }, oDlg )      

   TGetHlp():New( 1, 4, { | u | if( pcount() == 0, ::dInicio, ::dInicio := u ) }, , 40, 10 )

   TSay():New( 2, 1, {|| "Hasta" }, oDlg )      

   TGetHlp():New( 2, 4, { | u | if( pcount() == 0, ::dFin, ::dFin := u ) }, , 40, 10 )

   TButton():New( 3, 4, "&Aceptar", oDlg, {|| ( oDlg:End(1) ) }, 40, 12 )

   TButton():New( 3, 12, "&Cancel", oDlg, {|| oDlg:End() }, 40, 12 )

   oDlg:Activate( , , , .t. )

Return ( oDlg:nResult == 1 )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS ExportacionFacturas

   local oError
   local oBlock
   local lOpenFiles     := .t.

   oBlock               := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::nView           := D():CreateView()

      D():FacturasClientes( ::nView )
      ( D():FacturasClientes( ::nView ) )->( ordsetfocus( "dFecFac" ) )

      D():FacturasClientesLineas( ::nView )

      D():AlbaranesClientes( ::nView )
      ( D():AlbaranesClientes( ::nView ) )->( ordsetfocus( "cNumFac" ) )

   RECOVER USING oError

      lOpenFiles        := .f.

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lOpenFiles )

//---------------------------------------------------------------------------//

METHOD processInformation() CLASS ExportacionFacturas

   CursorWait()

   ( D():FacturasClientes( ::nView ) )->( dbseek( ::dInicio, .t. ) )

   while ( D():FacturasClientes( ::nView ) )->dFecFac <= ::dFin .and. ( D():FacturasClientes( ::nView ) )->( !eof() )

      // msgAlert( D():FacturasClientesId( ::nView ), "D():FacturasClientesId( ::nView )" )

      if ( D():AlbaranesClientes( ::nView ) )->( dbSeek( D():FacturasClientesId( ::nView ) ) )

         // msgAlert( D():FacturasClientesId( ::nView ), "Encontrado" )

         while ( ( D():AlbaranesClientes( ::nView ) )->cNumFac == D():FacturasClientesId( ::nView ) ) .and. ( D():AlbaranesClientes( ::nView ) )->( !eof() ) 

            ::buildFacturaInformation()
            
            ( D():AlbaranesClientes( ::nView ) )->( dbSkip() ) 
      
         end while
   
      end if 

      ( D():FacturasClientes( ::nView ) )->( dbskip() )

   end while

   CursorWE()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD buildFacturaInformation()

   local aProduct    := {  "FacturaId" =>    D():FacturasClientesId( ::nView ),;
                           "AlbaranId" =>    D():AlbaranesClientesId( ::nView )  } 

   aadd( ::aProducts, aProduct )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD writeInExcel()

   if !::openExcel()
      Return ( Self )
   end if 

   ::writeDetail()

   ::closeExcel()

Return ( Self ) 

//---------------------------------------------------------------------------//

METHOD openExcel()

   local oError
   local oBlock
   local lError      := .f.

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::oExcel                         := TOleExcel():New( "Importando hoja de excel", "Conectando...", .F. )

      ::oExcel:oExcel:Visible          := .f.
      ::oExcel:oExcel:DisplayAlerts    := .f.

      ::oBook                          := ::oExcel:oExcel:WorkBooks:Add()
      ::oExcel:oExcel:WorkSheets( 1 ):Activate()

   RECOVER USING oError

      lError        := .t.

      msgStop( "Error al abrir hoja de calculo " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( !lError )      

//---------------------------------------------------------------------------//

METHOD closeExcel()

   ::oBook:SaveAs( "c:\ads\test.csv", 6 )

   ::oExcel:oExcel:Visible          := .t.

Return ( Self ) 

//---------------------------------------------------------------------------//

METHOD writeDetail()

   local hProduct

   local oError
   local oBlock

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   ::oExcel:oExcel:WorkSheets( 1 ):Cells( 1, 1 ):Value   := "Factura"
   ::oExcel:oExcel:WorkSheets( 1 ):Cells( 1, 2 ):Value   := "Albaran"

   for each hProduct in ::aProducts

      ::oExcel:oExcel:WorkSheets( 1 ):Cells( hb_enumindex() + 1, 1 ):Value := hProduct["FacturaId"]
      ::oExcel:oExcel:WorkSheets( 1 ):Cells( hb_enumindex() + 1, 2 ):Value := hProduct["AlbaranId"]

   next

   RECOVER USING oError

      msgStop( "Error al escribir en la hoja de calculo " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( Self ) 

//---------------------------------------------------------------------------//
