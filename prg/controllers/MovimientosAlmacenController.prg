#include "Fivewin.ch"
#include "Factu.ch" 
#include "Fastreph.ch"

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenController FROM SQLNavigatorController

   DATA cFileName

   DATA oLineasController

   DATA oTagsController

   DATA oImportadorController

   DATA oCapturadorController

   DATA oEtiquetasController

   DATA oConfiguracionesController

   DATA oImprimirSeriesController

   DATA oReport

   METHOD New()
   METHOD End()

   METHOD validateNumero()          

   METHOD validateAlmacenOrigen()   INLINE ( iif(  ::validate( "almacen_origen" ),;
                                                   ::stampAlmacenNombre( ::oDialogView:oGetAlmacenOrigen ),;
                                                   .f. ) )

   METHOD validateAlmacenDestino()  INLINE ( iif(  ::validate( "almacen_destino" ),;
                                                   ::stampAlmacenNombre( ::oDialogView:oGetAlmacenDestino ),;
                                                   .f. ) )

   METHOD validateGrupoMovimiento() INLINE ( iif(  ::validate( "grupo_movimiento" ),;
                                                   ::stampGrupoMovimientoNombre( ::oDialogView:oGetGrupoMovimiento ),;
                                                   .f. ) )

   METHOD validateAgente()          INLINE ( iif(  ::validate( "agente" ),;
                                                   ::stampAgente( ::oDialogView:oGetAgente ),;
                                                   .f. ) )

   METHOD setFileName( cFileName )  INLINE ( ::cFileName := cFileName )
   METHOD getFileName()             INLINE ( ::cFileName )

   METHOD stampNumero()

   METHOD checkSerie( oGetNumero )

   METHOD stampAlmacenNombre()

   METHOD stampGrupoMovimientoNombre()

   METHOD stampAgente()

   METHOD stampMarcadores()

   METHOD printDocument()  

   METHOD labelDocument()

   METHOD setConfig()              

   METHOD deleteLines()
   
   METHOD refreshLineasBrowse()     INLINE ( iif( !empty( ::oLineasController ), ::getBrowse():Refresh(), ) )

   METHOD printSerialDocument()     INLINE ( ::oImprimirSeriesController:Activate() ) 

   METHOD buildNotSentJson()

   METHOD zipNotSentJson()

   METHOD setSentFromFetch()   

   METHOD isUnzipToJson( cZipFile )

   METHOD jsonToSQL()

   METHOD setSent()                 INLINE ( ::setSender( ::oModel:getSentenceSentFromIds( ::getIdFromRecno( ::getBrowse():aSelected ) ) ) )
   METHOD setNotSent()              INLINE ( ::setSender( ::oModel:getSentenceNotSentFromIds( ::getIdFromRecno( ::getBrowse():aSelected ) ) ) )
   METHOD setSender( cSentence )

   METHOD isAddedTag( cMarcador )
      METHOD addTag( uuidTag )
      METHOD deleteTag( idTageable )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::Super:New()

   ::cTitle                      := "Movimientos de almacén" 

   ::setName( "movimientos_almacen" )

   ::cDirectory                  := cPatDocuments( "Movimientos almacen" ) 

   ::hImage                      := {  "16"  => "gc_pencil_package_16",;
                                       "48"  => "gc_package_48",;
                                       "64"  => "gc_package_64" }

   ::nLevel                      := nLevelUsr( "01050" )

   ::lTransactional              := .t.

   ::lDocuments                  := .t.

   ::lLabels                     := .t.

   ::lConfig                     := .t.

   ::lOthers                     := .t.

   ::oModel                      := SQLMovimientosAlmacenModel():New( self )

   ::oBrowseView                 := MovimientosAlmacenBrowseView():New( self )

   ::oDialogView                 := MovimientosAlmacenView():New( self )

   ::oValidator                  := MovimientosAlmacenValidator():New( self )

   ::oLineasController           := MovimientosAlmacenLineasController():New( self )

   ::oTagsController             := TagsController():New( self )

   ::oImportadorController       := ImportadorMovimientosAlmacenLineasController():New( self )

   ::oCapturadorController       := CapturadorMovimientosAlmacenLineasController():New( self )

   ::oImprimirSeriesController   := ImprimirSeriesController():New( self )

   ::oEtiquetasController        := EtiquetasMovimientosAlmacenController():New( self )

   ::oConfiguracionesController  := ConfiguracionesController():New( self )

   ::oReport                     := MovimientosAlmacenReport():New( Self )

   ::loadDocuments()

   ::oNavigatorView:oMenuTreeView:setEvent( 'addedConfigButton',;
      {|| ::oNavigatorView:oMenuTreeView:AddButton( "Marcar para envio", "gc_mail2_delete_16", {|| ::setNotSent() }, , ACC_EDIT, ::oNavigatorView:oMenuTreeView:oButtonOthers ) } )
 
   ::oNavigatorView:oMenuTreeView:setEvent( 'addedConfigButton',;
      {|| ::oNavigatorView:oMenuTreeView:AddButton( "Marcar como enviado", "gc_mail2_check_16", {|| ::setSent() }, , ACC_EDIT, ::oNavigatorView:oMenuTreeView:oButtonOthers ) } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End()

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oLineasController:End()

   ::oTagsController:End()

   ::oCapturadorController:End()

   ::oImportadorController:End()

   ::oEtiquetasController:End()

   ::oReport:End()

   ::oConfiguracionesController:End()

   ::Super:End()

RETURN ( Self )

//---------------------------------------------------------------------------//
   
METHOD validateNumero()

   if !::validate( "numero" )
      RETURN ( .f. )
   end if 
      
   ::stampNumero( ::oDialogView:oGetNumero )
      
RETURN ( ::checkSerie( ::oDialogView:oGetNumero ) )

//---------------------------------------------------------------------------//

METHOD stampNumero( oGetNumero )

   local nAt
   local cSerie   := ""
   local nNumero
   local cNumero  := alltrim( oGetNumero:varGet() )

   nAt            := rat( "/", cNumero )
   if nAt == 0
      cNumero     := padr( rjust( cNumero, "0", 6 ), 50 )
   else 
      cSerie      := upper( substr( cNumero, 1, nAt - 1 ) )
      nNumero     := substr( cNumero, nAt + 1 )
      cNumero     := padr( cSerie + "/" + rjust( nNumero, "0", 6 ), 50 )
   end if 
      
   oGetNumero:cText( cNumero )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD checkSerie( oGetNumero )

   local nAt
   local cSerie
   local cNumero  := alltrim( oGetNumero:varGet() )

   nAt            := rat( "/", cNumero )
   if nAt == 0
      RETURN ( .t. )
   end if 

   cSerie         := upper( substr( cNumero, 1, nAt - 1 ) )

   if SQLConfiguracionesModel():isSerie( ::cName, cSerie )
      RETURN ( .t. )
   end if

   if msgYesNo( "La serie " + cSerie + ", no existe.", "¿ Desea crear una nueva serie ?" )
      SQLConfiguracionesModel():setSerie( ::cName, cSerie ) 
   else 
      RETURN ( .f. )
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD stampAlmacenNombre( oGetAlmacen )

   local cCodigoAlmacen    := oGetAlmacen:varGet()
   local cNombreAlmacen    := AlmacenesModel():getNombre( cCodigoAlmacen )

   oGetAlmacen:oHelpText:cText( cNombreAlmacen )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD stampGrupoMovimientoNombre( oGetGrupoMovimiento )

   local cCodigoGrupo      := oGetGrupoMovimiento:varGet()
   local cNombreGrupo      := GruposMovimientosModel():getNombre( cCodigoGrupo )

   oGetGrupoMovimiento:oHelpText:cText( cNombreGrupo )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD stampAgente( oGetAgente )

   local cCodigoAgente     := oGetAgente:varGet()
   local cNombreAgente     := AgentesModel():getNombre( cCodigoAgente )

   oGetAgente:oHelpText:cText( cNombreAgente )

RETURN ( .t. )

//---------------------------------------------------------------------------//
   
METHOD stampMarcadores( oTagsEver )
   
   local aMarcadores    := TageableRepository():getHashTageableTagsNameAndId( ::oModel:getBuffer( "uuid" ) ) 

   if empty( aMarcadores )
      RETURN ( .t. )
   end if 
   
   aeval( aMarcadores, {|h| oTagsEver:addItem( hget( h, "nombre" ), hget( h, "id" ) ) } )

   oTagsEver:Refresh()

RETURN ( .t. )

//---------------------------------------------------------------------------//
   
METHOD deleteLines()

   aeval( ::getRowSet():IdFromRecno( ::aSelected, "uuid" ), {| uuid | ::oLineasController:deleteLines( uuid ) } )

RETURN ( self ) 

//---------------------------------------------------------------------------//

METHOD printDocument( nDevice, cFile, nCopies, cPrinter )

   DEFAULT nDevice   := IS_SCREEN

   if empty( ::aDocuments )
      msgStop( "No hay formatos para impresión" )
      RETURN ( self )  
   end if 

   if empty( cFile )
      cFile          := ::oConfiguracionesController:oModel:getDocumentoMovimientosAlmacen()
   end if 

   if empty( cFile ) 
      cFile          := afirst( ::aDocuments )
   end if 

   if empty( cFile )
      msgStop( "No hay formatos por defecto" )
      RETURN ( self )  
   end if 

   if empty( nCopies )
      nCopies        := ::oConfiguracionesController:oModel:getCopiasMovimientosAlmacen()
   end if 

   ::oImprimirSeriesController:showDocument( nDevice, cFile, nCopies, cPrinter )

RETURN ( self ) 

//---------------------------------------------------------------------------//

METHOD labelDocument()

  ::oEtiquetasController:Activate()

RETURN ( self ) 

//---------------------------------------------------------------------------//

METHOD setConfig()

   ::oConfiguracionesController:Edit()

RETURN ( self ) 

//---------------------------------------------------------------------------//

METHOD buildNotSentJson()

   ::oModel:selectNotSentToJson()

   if empty( ::oModel:aFetch )
      RETURN ( nil )
   end if 

   ::oLineasController:oModel:selectFetchToJson( ;
      ::oLineasController:oModel:getSentenceNotSent( ::oModel:aFetch ) )  

   if empty( ::oLineasController:oModel:aFetch )
      RETURN ( nil )
   end if 

   ::oLineasController:oSeriesControler:oModel:selectFetchToJson( ;
      ::oLineasController:oSeriesControler:oModel:getSentenceNotSent( ::oLineasController:oModel:aFetch ) )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD zipNotSentJson()

   local cZipFile

   if !file( ::oModel:getJsonFileToExport() )                                    .and. ;
      !file( ::oLineasController:oModel:getJsonFileToExport() )                  .and. ;
      !file( ::oLineasController:oSeriesControler:oModel:getJsonFileToExport() )
      RETURN ( self )
   end if 

   cZipFile       := cpatout() + ::cName + "_" + hb_ttos( hb_datetime() ) + ".zip"

   hb_setdiskzip( {|| nil } )

   hb_zipfile( cZipFile, ::oModel:getJsonFileToExport(), 9 )
   hb_zipfile( cZipFile, ::oLineasController:oModel:getJsonFileToExport(), 9 ) 
   hb_zipfile( cZipFile, ::oLineasController:oSeriesControler:oModel:getJsonFileToExport(), 9 ) 

   hb_gcall()

   ::oExportableController:setZipFile( cZipFile )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD setSentFromFetch()

   local cSentence   := ::oModel:getSentenceSentFromFetch()
      
   if !empty( cSentence )
      getSQLDatabase():Exec( cSentence )
   end if 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD isUnzipToJson( cZipFile )

   local aFiles
   local lUnZiped    := .t.

   if !file( cZipFile )
      RETURN ( .f. )
   end if 

   aFiles            := hb_getfilesinzip( cZipFile )

   if !hb_unzipfile( cZipFile, , , , cpatin(), aFiles )
      msgStop( "No se ha descomprimido el fichero " + cZipFile, "Error" )
      lUnZiped       :=  .f. 
   end if

   hb_gcall()

RETURN ( lUnZiped )

//---------------------------------------------------------------------------//

METHOD jsonToSQL()

   if !::oModel:isInsertOrUpdateFromJson( ::oModel:getJsonFileToImport() )
      msgStop( "No se ha incorporado el fichero " + ::oModel:getJsonFileToImport(), "Error" )
      RETURN ( .f. )
   end if 

   if !::oLineasController:oModel:isInsertOrUpdateFromJson()
      msgStop( "No se ha incorporado el fichero " + ::oLineasController:oModel:getJsonFileToImport(), "Error" )
      RETURN ( .f. )
   end if 

   if !::oLineasController:oSeriesControler:oModel:isInsertOrUpdateFromJson()
      msgStop( "No se ha incorporado el fichero " + ::oLineasController:oSeriesControler:oModel:getJsonFileToImport(), "Error" )
      RETURN ( .f. )
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD setSender( cSentence )

   if empty( cSentence )
      RETURN ( self )
   end if 
      
   getSQLDatabase():Exec( cSentence )

   ::getRowSet():Refresh()

   ::getBrowse():Refresh()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD isAddedTag( cMarcador )

   local uuidTag

   uuidTag                    := TagsRepository():getUuidWhereName( cMarcador ) 

   if empty( uuidTag )
      RETURN ( .f. )
   end if 

   ::addTag( uuidTag )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD addTag( uuidTag )

   local hBuffer

   hBuffer                    := SQLTageableModel():loadBlankBuffer()
   hBuffer[ "tag_uuid"]       := uuidTag
   hBuffer[ "tageable_type" ] := ::getName()
   hBuffer[ "tageable_uuid" ] := ::oModel:getBuffer( "uuid" )
   SQLTageableModel():insertBuffer( hBuffer )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD deleteTag( idTageable )

   SQLTageableModel():deleteById( idTageable )

RETURN ( .t. )

//---------------------------------------------------------------------------//

