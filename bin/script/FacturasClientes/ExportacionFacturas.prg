#include "hbclass.ch"

#define CRLF chr( 13 ) + chr( 10 )

#define __separator__            ";"

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

   DATA oFileCsv
   DATA cFileCsv              INIT "c:\ads\test.csv"

   METHOD New()               CONSTRUCTOR

   METHOD Dialog()
   METHOD OpenFiles()
   METHOD CloseFiles()        INLINE ( D():DeleteView( ::nView ) )

   METHOD Run()               

   METHOD processInformation()

   METHOD buildFacturaInformation()

   METHOD openExcel()
      METHOD writeInExcel()
      METHOD writeDetail()
   METHOD closeExcel()        INLINE ( ::oFileCsv:Close() )

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

   ::Run()

   msgInfo( "Porceso finalizado" )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD Run()

   msgRun( "Procesando...", "Espere por favor", {|| ::processInformation(), ::writeInExcel(), ::closeFiles() } ) 

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

   while !( D():FacturasClientes( ::nView ) )->( eof() )

      if ( D():FacturasClientes( ::nView ) )->dFecFac <= ::dFin 
      
         if ( D():AlbaranesClientes( ::nView ) )->( dbSeek( D():FacturasClientesId( ::nView ) ) )

            while ( ( D():AlbaranesClientes( ::nView ) )->cNumFac == D():FacturasClientesId( ::nView ) ) .and. !( D():AlbaranesClientes( ::nView ) )->( eof() ) 

               ::buildFacturaInformation()

               ( D():AlbaranesClientes( ::nView ) )->( dbSkip() ) 
         
            end while

         else 

            ::buildFacturaInformation()

         end if 

      end if 

      ( D():FacturasClientes( ::nView ) )->( dbskip() )

   end while

   CursorWE()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD buildFacturaInformation()

   local aProduct    := {  "FacturaId" =>             D():FacturasClientesId( ::nView ),;
                           "SerieFactura" =>          ( D():FacturasClientes( ::nView ) )->cSerie,;
                           "NumeroFactura" =>         ( D():FacturasClientes( ::nView ) )->nNumFac,;
                           "SufijoFactura" =>         ( D():FacturasClientes( ::nView ) )->cSufFac,;
                           "FechaFactura" =>          dtos( ( D():FacturasClientes( ::nView ) )->dFecFac ),;
                           "ClienteFactura" =>        ( D():FacturasClientes( ::nView ) )->cCodCli,;
                           "BaseFactura" =>           ( D():FacturasClientes( ::nView ) )->nTotNet,;
                           "PorcentajeIvaFactura" =>  21,;
                           "ImporteIvaFactura" =>     ( D():FacturasClientes( ::nView ) )->nTotIva,;
                           "TotalFactura" =>          ( D():FacturasClientes( ::nView ) )->nTotFac,;
                           "AlbaranId" =>             D():AlbaranesClientesId( ::nView ),;
                           "SerieAlbaran" =>          ( D():AlbaranesClientes( ::nView ) )->cSerAlb,;
                           "NumeroAlbaran" =>         ( D():AlbaranesClientes( ::nView ) )->nNumAlb,;
                           "SufijoAlbaran" =>         ( D():AlbaranesClientes( ::nView ) )->cSufAlb } 

   aadd( ::aProducts, aProduct )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD writeInExcel()

   ::openExcel()

   ::writeDetail()

   ::closeExcel()

Return ( Self ) 

//---------------------------------------------------------------------------//

METHOD openExcel()

   ferase( ::cFileCsv )

   ::oFileCsv := TTxtFile():New( ::cFileCsv )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD writeDetail()

   local cLine   
   local hProduct 

   for each hProduct in ::aProducts

      cLine    := trimmer( hProduct["SerieFactura"] ) 
      cLine    += trimmer( hProduct["NumeroFactura"] ) 
      cLine    += trimmer( hProduct["SufijoFactura"] ) 
      cLine    += trimmer( hProduct["FechaFactura"] ) 
      cLine    += trimmer( hProduct["ClienteFactura"] ) 
      cLine    += trimmer( hProduct["BaseFactura"] ) 
      cLine    += trimmer( hProduct["PorcentajeIvaFactura"] ) 
      cLine    += trimmer( hProduct["ImporteIvaFactura"] ) 
      cLine    += trimmer( hProduct["TotalFactura"] ) 
      cLine    += trimmer( hProduct["SerieAlbaran"] ) 
      cLine    += trimmer( hProduct["NumeroAlbaran"] ) 
      cLine    += trimmer( hProduct["SufijoAlbaran"] ) 

      ::oFileCsv:add( cLine )

   next

Return ( Self ) 

//---------------------------------------------------------------------------//

static Function trimmer( uValue )

return ( alltrim(cvaltochar( uValue ) ) + __separator__ )