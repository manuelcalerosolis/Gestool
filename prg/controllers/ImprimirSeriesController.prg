#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ImprimirSeriesController FROM SQLBaseController

   DATA cFileName

   METHOD New()

   METHOD setDirectory( cDirectory )   INLINE ( ::cDirectory := cDirectory )
   METHOD getDirectory()               INLINE ( ::cDirectory )

   METHOD setFileName( cFileName )     INLINE ( ::cFileName := cFileName )
   METHOD getFileName()                INLINE ( ::cFileName )

   METHOD getFullPathFileName()        INLINE ( ::cDirectory + ::cFileName )

   METHOD getIds()                     INLINE ( iif( !empty( ::oSenderController ), ::oSenderController:getIds(), {} ) )

   METHOD Activate()

   METHOD Print()

   METHOD loadDocuments()

   METHOD editDocument()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::Super:New( oController )

   ::cDirectory                        := cPatDocuments( "Movimientos almacen" )    

   ::oDialogView                       := ImprimirSeriesView():New( self )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Activate()

   ::oDialogView:Activate()
   
RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Print() 

   msgalert( "Print") 

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD loadDocuments()

   local aFiles   := directory( ::getDirectory() + "*.fr3" )

   if empty( aFiles )
      RETURN ( self )
   end if 

   ::oDialogView:oListboxFile:aItems   := {}

   aeval( aFiles, {|aFile| ::oDialogView:oListboxFile:add( getFileNoExt( aFile[ 1 ] ) ) } )

   ::oDialogView:oListboxFile:goTop()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD editDocument()

   local nRecno
   local oReport  

   ::setFileName( ::oDialogView:cListboxFile )

   if empty( ::getFileName() )
      msgStop( "No hay formato definido" )
      RETURN ( self )  
   end if 

   oReport  := MovimientosAlmacenReport():New( self )

   oReport:createFastReport()

   oReport:setDevice( IS_SCREEN )

   oReport:setDirectory( ::getDirectory() )
   
   oReport:setFileName( ::getFileName() )

   oReport:buildRowSet()

   oReport:setUserDataSet()

   if oReport:isLoad()

      oReport:Design()

      oReport:DestroyFastReport()
   
   end if 

RETURN ( self )

//---------------------------------------------------------------------------//


