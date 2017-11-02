#include "Fivewin.ch"
#include "Factu.ch" 
#include "Hdo.ch"
#include "Hdocommon.ch"
#include "Fastreph.ch"

//---------------------------------------------------------------------------//

CLASS SQLBaseReport
  
   DATA oController

   DATA oEvents

   DATA oFastReport

   DATA cReport

   DATA cPrinter                          INIT ( prnGetName() )

   DATA nCopies                           INIT 1

   DATA cDevice                           INIT IS_SCREEN

   DATA Id

   METHOD New()

   METHOD End()

   METHOD newFastReport()
   METHOD destroyFastReport()             INLINE ( ::oFastReport:destroyFr(), ::oFastReport := nil )
   METHOD setFastReport( oFastReport )    INLINE ( ::oFastReport := oFastReport )
   METHOD getFastReport()                 INLINE ( ::oFastReport )

   METHOD setId( id )                     INLINE ( ::Id := id )
   METHOD getId()                         INLINE ( if( empty( ::Id ), nil, cvaltostr( ::Id ) ) )

   METHOD setReport( cReport )            INLINE ( ::cReport := cReport )
   METHOD getReport()                     INLINE ( ::cReport )

   METHOD setPrinter( cPrinter )          INLINE ( ::cPrinter := cPrinter )
   METHOD getPrinter()                    INLINE ( ::cPrinter )

   METHOD setCopies( nCopies )            INLINE ( ::nCopies := nCopies )
   METHOD getCopies()                     INLINE ( ::nCopies )

   METHOD setDevice( cDevice )            INLINE ( ::cDevice := cDevice )
   METHOD getDevice()                     INLINE ( ::cDevice )

   METHOD Print()  

   METHOD Design() 

   METHOD Load()
   
   METHOD Show()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oController                 := oController

   ::oEvents                     := Events():New()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End()

   ::oEvents:End()
   
RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD newFastReport()

   ::oFastReport := frReportManager():New()

   ::oFastReport:LoadLangRes( "Spanish.Xml" )
   
   ::oFastReport:SetIcon( 1 )
   
   ::oFastReport:SetTitle( "Diseñador de documentos" ) 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Print()  

   ::newFastReport()

   ::buildData()

   ::load()

   ::show()

   ::destroyFastReport()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD Load()

   local oWaitMeter  := TWaitMeter():New( "Generando documento", "Espere por favor..." )
   oWaitMeter:Run()

   ::oFastReport:loadFromString( ::getReport() )
  
   ::oFastReport:prepareReport()

   oWaitMeter:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Show()

   do case
      case ::getDevice() == IS_SCREEN
         ::oFastReport:showPreparedReport()

      case ::getDevice() == IS_PRINTER
         ::oFastReport:PrintOptions:SetPrinter( ::getPrinter() )
         ::oFastReport:PrintOptions:SetCopies( ::getCopies() )
         ::oFastReport:PrintOptions:SetShowDialog( .f. )
         ::oFastReport:Print()

      case ::getDevice() == IS_PDF
         ::oFastReport:SetProperty(  "PDFExport", "ShowDialog",       .f. )
         ::oFastReport:SetProperty(  "PDFExport", "DefaultPath",      cPatTmp() )
         ::oFastReport:SetProperty(  "PDFExport", "FileName",         'Doc' + trimedSeconds() + '.pdf' )
         ::oFastReport:SetProperty(  "PDFExport", "EmbeddedFonts",    .t. )
         ::oFastReport:SetProperty(  "PDFExport", "PrintOptimized",   .t. )
         ::oFastReport:SetProperty(  "PDFExport", "Outline",          .t. )
         ::oFastReport:SetProperty(  "PDFExport", "OpenAfterExport",  .t. )
         ::oFastReport:DoExport(     "PDFExport" )

   end case

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Design() 

   if empty( ::oFastReport )
      msgStop( "El objeto FastReport no se ha definido")
      RETURN ( Self )
   end if 

   ::buildData()

   if !empty( ::getReport() )

      ::oFastReport:LoadFromString( ::cReport )

   else

      ::oFastReport:SetProperty(     "Report",            "ScriptLanguage", "PascalScript" )

      ::oFastReport:AddPage(         "MainPage" )

      ::oFastReport:AddBand(         "CabeceraDocumento", "MainPage", frxPageHeader )
      ::oFastReport:SetProperty(     "CabeceraDocumento", "Top", 0 )
      ::oFastReport:SetProperty(     "CabeceraDocumento", "Height", 100 )

      ::oFastReport:AddBand(         "MasterData",        "MainPage", frxMasterData )
      ::oFastReport:SetProperty(     "MasterData",        "Top", 100 )
      ::oFastReport:SetProperty(     "MasterData",        "Height", 100 )
      ::oFastReport:SetProperty(     "MasterData",        "StartNewPage", .t. )

      ::oFastReport:AddBand(         "DetalleColumnas",   "MainPage", frxDetailData  )
      ::oFastReport:SetProperty(     "DetalleColumnas",   "Top", 230 )
      ::oFastReport:SetProperty(     "DetalleColumnas",   "Height", 28 )
      ::oFastReport:SetProperty(     "DetalleColumnas",   "OnMasterDetail", "DetalleOnMasterDetail" )

      ::oFastReport:AddBand(         "PieDocumento",      "MainPage", frxPageFooter )
      ::oFastReport:SetProperty(     "PieDocumento",      "Top", 930 )
      ::oFastReport:SetProperty(     "PieDocumento",      "Height", 100 )

   end if

   ::oFastReport:DesignReport()

RETURN ( Self )

//---------------------------------------------------------------------------//
