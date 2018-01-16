#include "Fivewin.ch"
#include "Factu.ch" 
#include "Hdo.ch"
#include "Hdocommon.ch"
#include "Fastreph.ch"

//---------------------------------------------------------------------------//

CLASS SQLBaseReport
  
   DATA cId

   DATA oController

   DATA oEvents

   DATA oFastReport

   DATA cReport

   DATA cPrinter                          INIT ( prnGetName() )

   DATA nCopies                           INIT 1

   DATA cDevice                           INIT IS_SCREEN

   METHOD New()

   METHOD End()

   METHOD createFastReport()
   METHOD destroyFastReport()             INLINE ( ::oFastReport:destroyFr(), ::oFastReport := nil )
   METHOD setFastReport( oFastReport )    INLINE ( ::oFastReport := oFastReport )
   METHOD getFastReport()                 INLINE ( ::oFastReport )

   METHOD setId( cId )                    INLINE ( ::cId := cId )
   METHOD getId()                         INLINE ( ::cId )

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

   METHOD isLoad()

   METHOD Save()

   METHOD buildData()                     VIRTUAL
   
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

METHOD createFastReport()

   ::oEvents:fire( "creatingFastReport" )

   ::oFastReport := frReportManager():New()
   
   ::oFastReport:ClearDataSets()
   
   ::oFastReport:LoadLangRes( "Spanish.Xml" )
   
   ::oFastReport:SetProperty( "Designer.DefaultFont", "Name", "Verdana")

   ::oFastReport:SetProperty( "Designer.DefaultFont", "Size", 10)
   
   ::oFastReport:SetIcon( 1 )
   
   ::oFastReport:SetTitle( "Diseñador de documentos" ) 

   ::oFastReport:SetEventHandler( "Designer", "OnSaveReport", {|| ::Save() } )

   ::oEvents:fire( "createdFastReport" )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Print()  

   ::oEvents:fire( "printing" )

   ::createFastReport()

   ::buildData()

   if ::isLoad()

      ::show()

   end if 

   ::destroyFastReport()

   ::oEvents:fire( "printed" )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD isLoad()

   local cReport
   local oWaitMeter  

   if empty( ::cId )
      msgStop( "El identificador del documento a cargar esta vacío")
      RETURN ( .f. )
   end if 

   ::oEvents:fire( "loading" )

   oWaitMeter        := TWaitMeter():New( "Generando documento", "Espere por favor..." )
   oWaitMeter:Run()

   cReport           := DocumentosModel():getReportWhereCodigo( ::cId )

   if !empty( cReport )

      ::oEvents:fire( "loadingFromString" )

      ::oFastReport:loadFromString( cReport )

      ::oEvents:fire( "loadedFromString" )

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

   oWaitMeter:End()

   ::oEvents:fire( "loaded" )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD Save()

   local cReport  := ::oFastReport:SaveToString()

   if !empty( cReport )
      DocumentosModel():setReportWhereCodigo( ::cId, cReport )
      msgalert( cReport, "save" )
   end if 

RETURN ( .t. )

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

   ::oEvents:fire( "designing" )

   ::oFastReport:DesignReport()

   ::oEvents:fire( "designed" )

RETURN ( Self )

//---------------------------------------------------------------------------//
