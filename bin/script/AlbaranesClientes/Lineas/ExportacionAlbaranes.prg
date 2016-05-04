#include "hbclass.ch"

#define CRLF chr( 13 ) + chr( 10 )

#define __separator__            ";"

//---------------------------------------------------------------------------//

Function Inicio()

   local oExportacionAlbarans
   local cOld              := HB_LangSelect( "EN" )

   oExportacionAlbarans    := ExportacionAlbarans():New()

   HB_LangSelect( cOld )

Return ( nil )

//---------------------------------------------------------------------------//

CREATE CLASS ExportacionAlbarans

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

   METHOD buildAlbaranInformation()

   METHOD openExcel()         
      METHOD writeInExcel()
      METHOD writeDetail()
   METHOD closeExcel()        INLINE ( ::oFileCsv:Close() )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS ExportacionAlbarans

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

METHOD Dialog() CLASS ExportacionAlbarans

   local oDlg
   local oBtn
   local getFechaFin

   oDlg 						:= TDialog():New( 5, 5, 15, 40, "Exportación Albarans" )

   TSay():New( 1, 1, {|| "Desde" }, oDlg )      

   TGetHlp():New( 1, 4, { | u | if( pcount() == 0, ::dInicio, ::dInicio := u ) }, , 40, 10 )

   TSay():New( 2, 1, {|| "Hasta" }, oDlg )      

   TGetHlp():New( 2, 4, { | u | if( pcount() == 0, ::dFin, ::dFin := u ) }, , 40, 10 )

   TButton():New( 3, 4, "&Aceptar", oDlg, {|| ( oDlg:End(1) ) }, 40, 12 )

   TButton():New( 3, 12, "&Cancel", oDlg, {|| oDlg:End() }, 40, 12 )

   oDlg:Activate( , , , .t. )

Return ( oDlg:nResult == 1 )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS ExportacionAlbarans

   local oError
   local oBlock
   local lOpenFiles     := .t.

   oBlock               := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::nView           := D():CreateView()

      D():AlbaranesClientes( ::nView )
      ( D():AlbaranesClientes( ::nView ) )->( ordsetfocus( "dFecAlb" ) )

      D():AlbaranesClientesLineas( ::nView )

   RECOVER USING oError

      lOpenFiles        := .f.

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lOpenFiles )

//---------------------------------------------------------------------------//

METHOD openExcel()

   if file( ::cFileCsv )
      ferase( ::cFileCsv )
   end if

   ::oFileCsv := TTxtFile():New( ::cFileCsv )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD processInformation() CLASS ExportacionAlbarans

   CursorWait()

   ( D():AlbaranesClientes( ::nView ) )->( dbseek( ::dInicio, .t. ) )

   while !( D():AlbaranesClientes( ::nView ) )->( eof() )

      if ( D():AlbaranesClientes( ::nView ) )->dFecAlb <= ::dFin 
      
         // msgWait( "procesando albaranes " + D():AlbaranesClientesIdText( ::nView ), "Espere", 0.0001 )

         ::buildAlbaranInformation()

         ( D():AlbaranesClientes( ::nView ) )->( dbSkip() ) 
         
      end if 

   end while

   CursorWE()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD buildAlbaranInformation()

   local aProduct    := {  "AlbaranId" =>             alltrim( D():AlbaranesClientesId( ::nView ) ),;
                           "SerieAlbaran" =>          alltrim( ( D():AlbaranesClientes( ::nView ) )->cSerAlb ) ,;
                           "NumeroAlbaran" =>         alltrim( str( ( D():AlbaranesClientes( ::nView ) )->nNumAlb ) ),;
                           "SufijoAlbaran" =>         alltrim( ( D():AlbaranesClientes( ::nView ) )->cSufAlb ),;
                			   "FechaAlbaran" =>          alltrim( dtos ( ( d():AlbaranesClientes( ::nview ) )->dFecAlb ) ),; 
               			   "ClienteAlbaran" =>        alltrim( ( D():AlbaranesClientes( ::nView ) )->cCodCli ),;
               			   "BaseAlbaran" =>           alltrim( str( ( D():AlbaranesClientes( ::nView ) )->nTotNet ) ),; 
               			   "PorcentajeIvaAlbaran" =>  alltrim( '21' ),;
               			   "ImporteIvaAlbaran" =>     alltrim( str( ( D():AlbaranesClientes( ::nView ) )->nTotIva ) ),;
               			   "TotalAlbaran" =>          alltrim( str( ( D():AlbaranesClientes( ::nView ) )->nTotAlb ) ) } 

   aadd( ::aProducts, aProduct )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD writeInExcel()

   ::openExcel()

   ::writeDetail()

   ::closeExcel()

Return ( Self ) 

//---------------------------------------------------------------------------//

METHOD writeDetail()

   local cLine   
   local cProduct 

   for each cProduct in ::aProducts

      cLine    := cProduct["SerieAlbaran"] + __separator__
      cLine    += cProduct["NumeroAlbaran"] + __separator__
      cLine    += cProduct["SufijoAlbaran"] + __separator__
      cLine    += cProduct["FechaAlbaran"] + __separator__
      cLine    += cProduct["ClienteAlbaran"] + __separator__
      cLine    += cProduct["BaseAlbaran"] + __separator__
      cLine    += cProduct["PorcentajeIvaAlbaran"] + __separator__
      cLine    += cProduct["ImporteIvaAlbaran"] + __separator__
      cLine    += cProduct["TotalAlbaran"] + __separator__

      ::oFileCsv:add( cLine )

   next

Return ( Self ) 

//---------------------------------------------------------------------------//
