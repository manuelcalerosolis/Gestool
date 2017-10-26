#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"
#include "HdoCommon.ch"
#include "FastRepH.ch"

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenReport

   DATA oMovimientosAlmacenRowSet

   DATA oLineasMovimientosAlmacenRowSet

   METHOD Design()
   
   METHOD buildData() 

   METHOD freeData()

   METHOD Print( nDevice, nCopies, cPrinter ) 
   
   METHOD synchronize() 

END CLASS

//---------------------------------------------------------------------------//

METHOD Design() 

   if empty( ::oFastReport )
      msgStop( "El objeto FastReport no se ha definido" )
      RETURN ( Self )
   end if 

   ::buildData()

   if !empty( ::cReport )

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
      ::oFastReport:SetObjProperty(  "MasterData",        "DataSet", "Movimientos de almacén" )

      ::oFastReport:AddBand(         "DetalleColumnas",   "MainPage", frxDetailData  )
      ::oFastReport:SetProperty(     "DetalleColumnas",   "Top", 230 )
      ::oFastReport:SetProperty(     "DetalleColumnas",   "Height", 28 )
      ::oFastReport:SetObjProperty(  "DetalleColumnas",   "DataSet", "Lineas de movimientos de almacén" )
      ::oFastReport:SetProperty(     "DetalleColumnas",   "OnMasterDetail", "DetalleOnMasterDetail" )

      ::oFastReport:AddBand(         "PieDocumento",      "MainPage", frxPageFooter )
      ::oFastReport:SetProperty(     "PieDocumento",      "Top", 930 )
      ::oFastReport:SetProperty(     "PieDocumento",      "Height", 100 )

   end if

   ::oFastReport:DesignReport()

   ::oFastReport:DestroyFr()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Print( nDevice, nCopies, cPrinter )  

   local cReport
   local oWaitMeter
   local oFastReport

   DEFAULT nDevice      := IS_SCREEN
   DEFAULT nCopies      := 1
   DEFAULT cPrinter     := prnGetName()

   SysRefresh()

   cReport              := DocumentosModel():getReportWhereCodigo( "RM1" )              
   if empty( cReport )
      RETURN ( .f. )
   end if 

   msgalert( cReport, "cReport" )

   ::newFastReport()

   ::oFastReport:LoadLangRes( "Spanish.Xml" )
   ::oFastReport:SetIcon( 1 )
   ::oFastReport:SetTitle( "Diseñador de documentos" )

   ::buildData( oFastReport )

   /*
   Cargar el informe-----------------------------------------------------------
   */

   oWaitMeter           := TWaitMeter():New( "Generando documento", "Espere por favor..." )
   oWaitMeter:Run()

   ::oFastReport:loadFromString( cReport )
   ::oFastReport:prepareReport()

   oWaitMeter:End()

   ::oFastReport:showPreparedReport()
   ::oFastReport:destroyFr()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD buildData( oFastReport ) 

   local oMovimientosAlmacenSelect        
   local oLineasMovimientosAlmacenSelect  

   oMovimientosAlmacenSelect           := getSqlDataBase():query( "SELECT * FROM " + SQLMovimientosAlmacenModel():getTableName() + " WHERE id = 1" )
   ::oMovimientosAlmacenRowSet         := oMovimientosAlmacenSelect:fetchRowSet()

   oLineasMovimientosAlmacenSelect     := getSqlDataBase():query( "SELECT * FROM " + SQLMovimientosAlmacenLineasModel():getTableName() + " WHERE parent_uuid = " + quoted( ::oMovimientosAlmacenRowSet:fieldget( "uuid" ) ) )      
   ::oLineasMovimientosAlmacenRowSet   := oLineasMovimientosAlmacenSelect:fetchRowSet()

   ::oFastReport:ClearDataSets()

   ::oFastReport:setUserDataSet(    "Movimientos de almacén",;
                                    SQLMovimientosAlmacenModel():serializeColumns(),;
                                    {|| ::oMovimientosAlmacenRowSet:gotop() },;
                                    {|| ::oMovimientosAlmacenRowSet:skip(1) },;
                                    {|| ::oMovimientosAlmacenRowSet:skip(-1) },;
                                    {|| ::oMovimientosAlmacenRowSet:eof() },;
                                    {|cField| ::oMovimientosAlmacenRowSet:fieldGet( cField ) } )

   ::oFastReport:setUserDataSet(   "Lineas de movimientos de almacén",;
                                    SQLMovimientosAlmacenLineasModel():serializeColumns(),;
                                    {|| ::oLineasMovimientosAlmacenRowSet:gotop() },;
                                    {|| ::oLineasMovimientosAlmacenRowSet:skip(1) },;
                                    {|| ::oLineasMovimientosAlmacenRowSet:skip(-1) },;
                                    {|| ::oLineasMovimientosAlmacenRowSet:eof() },;
                                    {|cField| ::oLineasMovimientosAlmacenRowSet:fieldGet( cField ) } )

   ::oFastReport:SetMasterDetail(   "Movimientos de almacén",;
                                    "Lineas de movimientos de almacén",;
                                    {|| ::synchronize() } )

   ::oFastReport:SetResyncPair(    "Movimientos de almacén", "Lineas de movimientos de almacén" )

RETURN NIL

//---------------------------------------------------------------------------//

METHOD freeData() 

   ::oMovimientosAlmacenRowSet:free()
   ::oLineasMovimientosAlmacenRowSet:free()

RETURN NIL

//---------------------------------------------------------------------------//

METHOD Synchronize() 

   msgalert( ::oMovimientosAlmacenRowSet:fieldget( "uuid" ), "uuid" )

RETURN NIL

//---------------------------------------------------------------------------//


