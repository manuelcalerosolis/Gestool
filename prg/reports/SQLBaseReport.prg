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

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD getController()                 INLINE ( ::oController )

   METHOD createFastReport()
   METHOD destroyFastReport()             INLINE ( ::oFastReport:destroyFr(), ::oFastReport := nil )
   METHOD setFastReport( oFastReport )    INLINE ( ::oFastReport := oFastReport )
   METHOD getFastReport()                 INLINE ( ::oFastReport )

   METHOD setDirectory( cDirectory )      INLINE ( ::cDirectory := cDirectory )
   METHOD getDirectory()                  INLINE ( alltrim( ::cDirectory ) )

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

   METHOD getIds()                        INLINE ( iif( !empty( ::oController ), ::oController:getIds(), {} ) )

   METHOD loadDocuments()

   METHOD Show()  

   METHOD Design() 

   METHOD isLoad()

   METHOD Create()

   METHOD Save()

   METHOD buildRowSet()                   VIRTUAL
   
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

METHOD isLoad()

   if empty( ::cDirectory )
      msgStop( "El directorio " + ::cDirectory + " está vacío." )
      RETURN ( .f. )
   end if 

   if empty( ::cFileName )
      msgStop( "El fichero " + ::cFileName + " está vacío." )
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

METHOD Create()

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

METHOD Save()

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
         ::oFastReport:SetProperty(  "PDFExport", "DefaultPath",      cPatTmp() )
         ::oFastReport:SetProperty(  "PDFExport", "FileName",         'Doc' + trimedSeconds() + '.pdf' )
         ::oFastReport:SetProperty(  "PDFExport", "EmbeddedFonts",    .t. )
         ::oFastReport:SetProperty(  "PDFExport", "PrintOptimized",   .t. )
         ::oFastReport:SetProperty(  "PDFExport", "Outline",          .t. )
         ::oFastReport:SetProperty(  "PDFExport", "OpenAfterExport",  .t. )
         ::oFastReport:DoExport(     "PDFExport" )

         ::oEvents:fire( "generatedPdf" )

   end case

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Design() 

   ::oEvents:fire( "designing" )

   ::oFastReport:DesignReport()

   ::oEvents:fire( "designed" )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD loadDocuments()

   local aFiles   := directory( ::getDirectory() + "*.fr3" )

   if empty( aFiles )
      RETURN ( self )
   end if 

   ::getDialogView():oListboxFile:setItems( {} )

   aeval( aFiles, {|aFile| ::getDialogView():oListboxFile:add( getFileNoExt( aFile[ 1 ] ) ) } )

   ::getDialogView():oListboxFile:goTop()

RETURN ( self )

//---------------------------------------------------------------------------//
