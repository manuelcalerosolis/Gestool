#include "Fivewin.ch"
#include "Factu.ch" 
#include "Hdo.ch"
#include "Hdocommon.ch"
#include "Fastreph.ch"

//---------------------------------------------------------------------------//

CLASS SQLBaseReport
  
   DATA oController

   DATA cDirectory

   DATA cFileName                         INIT Space( 200 )

   DATA oEvents

   DATA oFastReport

   DATA cReport

   DATA cPrinter                          INIT ( prnGetName() )

   DATA nCopies                           INIT 1

   DATA cDevice                           INIT IS_SCREEN

   DATA cPdfDefaultPath                   INIT ( cPatTmp() )

   DATA cPdfFileName                      INIT ( 'Doc' + trimedSeconds() + '.pdf' )

   DATA lPdfOpenAfterExport               INIT .t.

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD createReport( hReport ) 

   METHOD Generate( hReport ) 

   METHOD getController()                 INLINE ( ::oController )

   METHOD createFastReport()
   METHOD destroyFastReport()             INLINE ( ::oFastReport:destroyFr(), ::oFastReport := nil )
   METHOD setFastReport( oFastReport )    INLINE ( ::oFastReport := oFastReport )
   METHOD getFastReport()                 INLINE ( ::oFastReport )

   METHOD setDirectory( cDirectory )      INLINE ( ::cDirectory := cDirectory )
   METHOD getDirectory()                  INLINE ( if( empty( ::cDirectory ), Company():getPathDocuments( ::getController():cName ), ::cDirectory ) )

   METHOD setFileName( cFileName )        INLINE ( ::cFileName := cFileName )
   METHOD getFileName()                   INLINE ( alltrim( ::cFileName ) )

   METHOD getFullPathFileName()           INLINE ( ::getDirectory() + ::getFileName() + if( !( ".fr3" $ lower( ::getFileName() ) ), ".fr3", "" ) )

   METHOD setReport( cReport )            INLINE ( ::cReport := cReport )
   METHOD getReport()                     INLINE ( ::cReport )

   METHOD setPrinter( cPrinter )          INLINE ( ::cPrinter := cPrinter )
   METHOD getPrinter()                    INLINE ( ::cPrinter )

   METHOD setCopies( nCopies )            INLINE ( ::nCopies := nCopies )
   METHOD getCopies()                     INLINE ( ::nCopies )

   METHOD setDevice( cDevice )            INLINE ( ::cDevice := cDevice )
   METHOD getDevice()                     INLINE ( ::cDevice )

   // PDF methods--------------------------------------------------------------

   METHOD setPdfDefaultPath( cPath )      INLINE ( ::cPdfDefaultPath := cPath )
   METHOD getPdfDefaultPath()             INLINE ( alltrim( ::cPdfDefaultPath ) )

   METHOD setPdfFileName( cPdfFileName )  INLINE ( ::cPdfFileName := cPdfFileName + if( ( ".pdf" $ lower( cPdfFileName ) ), "", ".pdf" ) )
   METHOD getPdfFileName()                INLINE ( alltrim( ::cPdfFileName ) )

   METHOD getFullPathPdfFileName()        INLINE ( ::getPdfDefaultPath() + ::getPdfFileName() )

   METHOD setPdfOpenAfterExport( lPdf )   INLINE ( ::lPdfOpenAfterExport := lPdf )
   METHOD getPdfOpenAfterExport()         INLINE ( ::lPdfOpenAfterExport )

   // Others-------------------------------------------------------------------

   METHOD getIds()                        INLINE ( iif( !empty( ::oController ), ::oController:getIds(), {} ) )

   METHOD loadDocuments()

   METHOD Show()  

   METHOD Design() 

   METHOD isLoad()

   METHOD CreateFile()

   METHOD SaveReport()

   METHOD buildRowSet()                   VIRTUAL

   METHOD freeRowSet()                    VIRTUAL
   
END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oController                          := oController

   ::oEvents                              := Events():New()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End()

   ::oEvents:End()
   
RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD createReport( hReport ) 

   if !( hhaskey( hReport, "device" ) )
      msgAlert( "Falta del device" )
      RETURN ( nil )
   end if 

   ::createFastReport()

   ::setDevice( hget( hReport, "device" ) )

   if ( hhaskey( hReport, "fileName" ) )
      ::setFileName( hget( hReport, "fileName" ) )
   end if 

   if hhaskey( hReport, "copies" )
      ::setCopies( hget( hReport, "copies" ) )
   end if 

   if hhaskey( hReport, "printer" )
      ::setPrinter( hget( hReport, "printer" ) )
   end if 

   if hhaskey( hReport, "pdfOpenAfterExport" )
      ::setPdfOpenAfterExport( hget( hReport, "pdfOpenAfterExport" ) )
   end if 
   
   if hhaskey( hReport, "pdfDefaultPath" )
      ::setPdfDefaultPath( hget( hReport, "pdfDefaultPath" ) )
   end if 

   if hhaskey( hReport, "pdfFileName" )
      ::setPdfFileName( hget( hReport, "pdfFileName" ) )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD createFastReport()

   ::oEvents:fire( "creatingFastReport" )

   ::oFastReport := frReportManager():New()
   
   ::oFastReport:ClearDataSets()
   
   ::oFastReport:LoadLangRes( "Spanish.Xml" )
   
   ::oFastReport:SetProperty( "Designer.DefaultFont", "Name", "Verdana")

   ::oFastReport:SetProperty( "Designer.DefaultFont", "Size", 10)
   
   ::oFastReport:SetIcon( 1 )
   
   ::oFastReport:SetTitle( "Diseñador de documentos" ) 

   ::oFastReport:SetEventHandler( "Designer", "OnSaveReport", {|| ::SaveReport() } )

   ::oEvents:fire( "createdFastReport" )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD isLoad()

   if empty( ::getDirectory() )
      msgStop( "El directorio " + ::getDirectory() + " está vacío." )
      RETURN ( .f. )
   end if 

   if empty( ::getFileName() )
      msgStop( "El fichero " + ::getFileName() + " está vacío." )
      RETURN ( .f. )
   end if 

   if !file( ::getFullPathFileName() )
      msgStop( "El fichero " + ::getFullPathFileName() + " no existe." )
      RETURN ( .f. )
   end if 

   ::oEvents:fire( "loadingFromFile" )

   ::oFastReport:loadFromFile( ::getFullPathFileName() )

   ::oEvents:fire( "loadedFromFile" )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD CreateFile()

   ::oFastReport:SetProperty(     "Report",            "ScriptLanguage",   "PascalScript" )

   ::oFastReport:AddPage(         "MainPage" )

   ::oFastReport:AddBand(         "CabeceraDocumento", "MainPage",         frxPageHeader )
   ::oFastReport:SetProperty(     "CabeceraDocumento", "Top",              0 )
   ::oFastReport:SetProperty(     "CabeceraDocumento", "Height",           100 )

   ::oFastReport:AddBand(         "MasterData",        "MainPage",         frxMasterData )
   ::oFastReport:SetProperty(     "MasterData",        "Top",              100 )
   ::oFastReport:SetProperty(     "MasterData",        "Height",           100 )
   ::oFastReport:SetProperty(     "MasterData",        "StartNewPage",     .t. )

   ::oFastReport:AddBand(         "DetalleColumnas",   "MainPage",         frxDetailData  )
   ::oFastReport:SetProperty(     "DetalleColumnas",   "Top",              230 )
   ::oFastReport:SetProperty(     "DetalleColumnas",   "Height",           28 )
   ::oFastReport:SetProperty(     "DetalleColumnas",   "OnMasterDetail",   "DetalleOnMasterDetail" )

   ::oFastReport:AddBand(         "PieDocumento",      "MainPage",         frxPageFooter )
   ::oFastReport:SetProperty(     "PieDocumento",      "Top",              930 )
   ::oFastReport:SetProperty(     "PieDocumento",      "Height",           100 )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD SaveReport()

   if !isDirectory( ::getDirectory() )
      makeDir( ::getDirectory() )
   end if 

   if empty( ::getFileName() )
      msgGet( "Seleccione un fichero", "Fichero : ", @::cFileName )     
   end if 

   if !empty( ::getFileName() )
      ::oFastReport:SaveToFile( ::getFullPathFileName() )
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD Show()

   ::oFastReport:PrepareReport()

   do case
      case ::getDevice() == IS_SCREEN

         ::oEvents:fire( "showing" )

         ::oFastReport:showPreparedReport()

         ::oEvents:fire( "showed" )

      case ::getDevice() == IS_PRINTER

         ::oEvents:fire( "printing" )

         ::oFastReport:PrintOptions:SetPrinter(    ::getPrinter() )
         ::oFastReport:PrintOptions:SetCopies(     ::getCopies() )
         ::oFastReport:PrintOptions:SetShowDialog( .f. )
         ::oFastReport:Print()

         ::oEvents:fire( "printed" )

      case ::getDevice() == IS_PDF

         ::oEvents:fire( "generatingPdf" )

         ::oFastReport:SetProperty(  "PDFExport", "ShowDialog",       .f. )
         ::oFastReport:SetProperty(  "PDFExport", "DefaultPath",      ::getPdfDefaultPath() )
         ::oFastReport:SetProperty(  "PDFExport", "FileName",         ::getPdfFileName() )
         ::oFastReport:SetProperty(  "PDFExport", "EmbeddedFonts",    .t. )
         ::oFastReport:SetProperty(  "PDFExport", "PrintOptimized",   .t. )
         ::oFastReport:SetProperty(  "PDFExport", "Outline",          .t. )
         ::oFastReport:SetProperty(  "PDFExport", "OpenAfterExport",  ::getPdfOpenAfterExport() )
         ::oFastReport:DoExport(     "PDFExport" )

         ::oEvents:fire( "generatedPdf" )

   end case

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Design() 

   ::oEvents:fire( "designing" )

   ::oFastReport:DesignReport()

   ::oEvents:fire( "designed" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD loadDocuments()

   local aFiles   := directory( ::getDirectory() + "*.fr3" )

   if empty( aFiles )
      RETURN ( self )
   end if 

   ::getDialogView():oListboxFile:setItems( {} )

   aeval( aFiles, {|aFile| ::getDialogView():oListboxFile:add( getFileNoExt( aFile[ 1 ] ) ) } )

   ::getDialogView():oListboxFile:goTop()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Generate( hReport ) 

   local uuid

   if !( hhaskey( hReport, "uuid" ) )
      msgStop( "No existe un uuid" )
      RETURN ( nil )
   end if 

   uuid     := hget( hReport, "uuid" ) 

   ::createReport( hReport )

   ::buildRowSet( uuid )

   ::setUserDataSet()

   if ::isLoad()

      ::Show()

   end if 
   
   ::freeRowSet()
   
   ::DestroyFastReport()

RETURN ( nil )

//----------------------------------------------------------------------------//

