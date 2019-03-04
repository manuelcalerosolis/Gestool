#include "FiveWin.Ch"
#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS ConversorPrepareAlbaranVentasController FROM ConversorPrepareController

   DATA aControllers                   INIT {}

   DATA oConversorAlbaranesController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD Run()           

   METHOD getWhereOrigen()

   METHOD getWhereDestino()

   METHOD generatePreview()

   METHOD generateConvert()

   //Construcciones tardias----------------------------------------------------

   METHOD getConversorView()           INLINE ( iif( empty( ::oConversorView ), ::oConversorView := ConversorAlbaranVentasView():New( self ), ), ::oConversorView ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS ConversorPrepareAlbaranVentasController

   local oRutasController
   local oAgentesController
   local oTercerosController
   local oAlmacenesController
   local oMetodosPagosController
   local oArticulosTarifasController
   local oContadoresAlbaranesVentasController

   ::Super:New( AlbaranesVentasConversorController():New( self ) )

   ::oDestinoController                   := FacturasVentasConversorController():New( self )

   ::oConversorAlbaranesController        := ConversorAlbaranesController():New( self )

   // Series-------------------------------------------------------------------

   oContadoresAlbaranesVentasController   := ContadoresAlbaranesVentasController():New()
   oContadoresAlbaranesVentasController:getRange():setTable( ::oOrigenController:getModel():getTable() ) 

   aadd( ::aControllers, oContadoresAlbaranesVentasController )

   // Grupos terceros----------------------------------------------------------

   aadd( ::aControllers, TercerosGruposController():New() )

   // Terceros-----------------------------------------------------------------

   oTercerosController                    := TercerosController():New()
   oTercerosController:getRange():setTable( ::oOrigenController:getModel():getTable() ) 

   aadd( ::aControllers, oTercerosController )

   // Metodos de pago----------------------------------------------------------

   oMetodosPagosController                := MetodosPagosController():New()
   oMetodosPagosController:getRange():setTable( ::oOrigenController:getModel():getTable() ) 

   aadd( ::aControllers, oMetodosPagosController )

   // Almacenes-----------------------------------------------------------------

   oAlmacenesController                   := AlmacenesController():New()
   oAlmacenesController:getRange():setTable( ::oOrigenController:getModel():getTable() ) 

   aadd( ::aControllers, oAlmacenesController )

   // Tarifas------------------------------------------------------------------

   oArticulosTarifasController            := ArticulosTarifasController():New()
   oArticulosTarifasController:getRange():setTable( ::oOrigenController:getModel():getTable() ) 

   aadd( ::aControllers, oArticulosTarifasController )

   // Rutas--------------------------------------------------------------------

   oRutasController                       := RutasController():New()
   oRutasController:getRange():setTable( ::oOrigenController:getModel():getTable() ) 

   aadd( ::aControllers, oRutasController )

   // Agentes------------------------------------------------------------------

   oAgentesController                     := AgentesController():New()
   oAgentesController:getRange():setTable( ::oOrigenController:getModel():getTable() ) 

   aadd( ::aControllers, oAgentesController )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD End() CLASS ConversorPrepareAlbaranVentasController

   if !empty( ::oOrigenController )
      ::oOrigenController:End()
   end if

   if !empty( ::oDestinoController )
      ::oDestinoController:End()
   end if

   if !empty( ::oConversorAlbaranesController )
      ::oConversorAlbaranesController:End()
   end if

   if !empty( ::oConversorView )
      ::oConversorView:End()
   end if

   if !empty( ::oRowset )
      ::oRowset:End()
   end if

   aeval( ::aControllers, {| oController | oController:End() } )

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//

METHOD Run() CLASS ConversorPrepareAlbaranVentasController

   ::oOrigenController:getModel():setLimit( 0 )

   ::oDestinoController:getModel():setLimit( 0 )

RETURN ( ::getConversorView():Activate() )

//---------------------------------------------------------------------------//

METHOD generatePreview() CLASS ConversorPrepareAlbaranVentasController

   ::oOrigenController:getModel():setLimit( nil )

   ::oOrigenController:getModel():setGeneralWhere( ::getWhereOrigen() )

   ::oOrigenController:getRowset():build( ::oOrigenController:getModel():getSelectSentence() )

   ::oOrigenController:getBrowseView():selectAll()

RETURN ( ::oOrigenController:getRowset():recCount() > 0 )

//---------------------------------------------------------------------------//

METHOD getWhereOrigen() CLASS ConversorPrepareAlbaranVentasController

   local cWhere   := ''

   cWhere         += "canceled_at = 0 "
   cWhere         += "AND fecha >= " + dtos( ::getConversorView():oPeriodo:oFechaInicio:Value() )  + " "
   cWhere         += "AND fecha <= " + dtos( ::getConversorView():oPeriodo:oFechaFin:Value() )     + " "

   aeval( ::aControllers,;
      {|oController| ; 
         cWhere   += oController:getRange():getWhereAnd(),;
         cWhere   += oController:getFilterController():getWhereAnd() } )

   cWhere         += "AND (" + Company():getTableName( 'isConvertedToFacturasVentas' )+ "( albaranes_ventas.uuid ) ) = 0" + " "

RETURN ( cWhere )

//---------------------------------------------------------------------------//

METHOD generateConvert() CLASS ConversorPrepareAlbaranVentasController

   ::aCreatedDocument   := ::oConversorAlbaranesController():Convert( ::oOrigenController:getUuids() )

   if !empty( ::aCreatedDocument )

   ::oDestinoController:getModel():setLimit( nil )

   ::oDestinoController:getModel():setGeneralWhere( ::getWhereDestino( ::aCreatedDocument ) )

   ::oDestinoController:getRowSet():Build( ::oDestinoController:getModel():getSelectSentence() )

   ::oDestinoController:getBrowseView():Refresh()

   ::aCreatedDocument := {}

   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getWhereDestino( aSelected ) CLASS ConversorPrepareAlbaranVentasController
   
   local cWhere
   
   if empty( aSelected )
      RETURN ( '' )
   end if 
   
   cWhere         :=  ::oDestinoController:getModel():cTableName + ".uuid IN( "

   aeval( aSelected, {| v | cWhere += notEscapedQuoted( v ) + ", " } )

   cWhere         := chgAtEnd( cWhere, ' )', 2 )

RETURN ( cWhere )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ConversorAlbaranVentasView FROM SQLBaseView

   DATA oPeriodo

   DATA oBrwRange

   METHOD Activate()
      METHOD starActivate()
      METHOD okActivate()
         METHOD okActivateFolderOne()
         METHOD okActivateFolderTwo()
      METHOD backActivate()
         METHOD backActivateToFolderOne()


   METHOD setFolderToPreview()         INLINE ( ::oFolder:aEnable[ 2 ] := .t., ::oFolder:setOption( 2 ) )

   METHOD setFolderConvertion()        INLINE ( ::oFolder:aEnable[ 3 ]  := .t., ::oFolder:setOption( 3 ), ::oFolder:aEnable[ 1 ]  := .f., ::oFolder:aEnable[ 2 ]  := .f. )

   METHOD setFolderToSelection()       INLINE ( ::oFolder:aEnable[ 2 ]  := .f., ::oFolder:setOption( 1 ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS ConversorAlbaranVentasView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "CONTAINER_LARGE" ;
      TITLE       "Convertir a factura de ventas"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    "gc_document_gear_48" ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      PROMPT      "Seleccione el rango de fechas y condiciones para la generaci�n de albaranes" ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog

   REDEFINE FOLDER ::oFolder ;
      ID          500 ;
      OF          ::oDialog ;
      PROMPT      "Rangos" ,;
                  "Albaranes",;
                  "Facturas generadas" ;
      DIALOGS     "CONVERTIR_ALBARAN_VENTAS",;
                  "CONVERTIR_ALBARAN_VENTAS_PREVIA",;
                  "CONVERTIR_ALBARAN_VENTAS_PREVIA"

   ::oPeriodo     := GetPeriodo():New( 110, 120, 130 )
   ::oPeriodo:Resource( ::oFolder:aDialogs[ 1 ] )

   ::oBrwRange    := BrowseRange():New( 140, ::oFolder:aDialogs[ 1 ], ::oController )

   ::oBrwRange:Resource()

   ::oController:oOrigenController:Activate( 100, ::oFolder:aDialogs[ 2 ] )

   ::oController:oDestinoController:Activate( 100, ::oFolder:aDialogs[ 3 ] )

   // Botones------------------------------------------------------------------

   ApoloBtnFlat():Redefine( IDBACK, {|| ::backActivate() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDOK, {|| ::okActivate() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oFolder:aDialogs[ 1 ]:bKeyDown := {| nKey | if( nKey == VK_F5, ::okActivate(), ) }
   ::oFolder:aDialogs[ 2 ]:bKeyDown := {| nKey | if( nKey == VK_F5, ::okActivate(), ) }
   ::oFolder:aDialogs[ 3 ]:bKeyDown := {| nKey | if( nKey == VK_F5, ::okActivate(), ) }
   ::oDialog:bKeyDown               := {| nKey | if( nKey == VK_F5, ::okActivate(), ) }

   ::oDialog:bStart                 := {|| ::starActivate(), ::paintedActivate() }

   ACTIVATE DIALOG ::oDialog CENTER

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD starActivate() CLASS ConversorAlbaranVentasView

   ::oFolder:aEnable    := { .t., .f., .f. }

   ::oController:getConversorView():getControl( IDBACK ):hide()

   ::oController:getConversorView():getControl( IDBACK ):setText( "< Atr�s" )

   ::oController:getConversorView():getControl( IDOK ):setText( "Siguiente >" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD okActivate() CLASS ConversorAlbaranVentasView

   do case
      case ::oFolder:nOption == 1

         ::okActivateFolderOne()

      case ::oFolder:nOption == 2

         ::okActivateFolderTwo()

      case ::oFolder:nOption == 3

         ::oDialog:end()

   end case

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD okActivateFolderOne() CLASS ConversorAlbaranVentasView

   if ::oController:generatePreview()

      ::oController:getConversorView():setMessage( "Seleccione los albaranes que deseas convertir a factura" )

      ::setFolderToPreview()

      ::oFolder:aEnable[ 1 ] := .f.

      ::oController:getConversorView():getControl( IDBACK ):show()

      ::oController:getConversorView():getControl( IDOK ):setText( "Convertir[F5]" )

   else

      ::oController:getConversorView():showMessage( "No existen albaranes con el filtro seleccionado" )

   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD okActivateFolderTwo() CLASS ConversorAlbaranVentasView
   
   if empty( ::oController:oOrigenController:getUuids() )

      ::oController:getConversorView():showMessage( "Debe seleccionar al menos un albar�n" )

      RETURN ( nil )

   end if

   ::oController:getConversorView():getControl( IDOK ):hide()

   ::oController:getConversorView():getControl( IDBACK ):hide()

   ::oController:getConversorView():getControl( IDCANCEL ):setText( "Finalizar" )

   ::oController:generateConvert()

   ::setFolderConvertion()

   ::oController:getConversorView():setMessage( "Facturas generadas" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD backActivate() CLASS ConversorAlbaranVentasView

   if ::oFolder:nOption != 2
      RETURN ( nil )
   end if

   ::backActivateToFolderOne()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD backActivateToFolderOne() CLASS ConversorAlbaranVentasView

   ::oFolder:aEnable :={ .t., .f., .f. } 

   ::oController:getConversorView():getControl( IDBACK ):hide()

   ::oController:getConversorView():getControl( IDOK ):setText( "Siguiente >" )

   ::setFolderToSelection()

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

#ifdef __TEST__

CLASS TestConversorToFacturaVentasController FROM TestCase

   DATA aSelected                      INIT {}

   DATA oController

   DATA aCategories                    INIT { "all", "conversor_to_factura_ventas" }

   DATA oAlbaranesVentasController

   data oFacturasVentasController

   METHOD getAlbaranesVentasController();
                                       INLINE ( if( empty( ::oAlbaranesVentasController ), ::oAlbaranesVentasController := AlbaranesVentasController():New( self ), ), ::oAlbaranesVentasController )
   METHOD getFacturasVentasController();
                                       INLINE ( if( empty( ::oFacturasVentasController ), ::oFacturasVentasController := FacturasVentasController():New( self ), ), ::oFacturasVentasController )

   METHOD beforeClass() 

   METHOD afterClass()

   METHOD Before() 

   METHOD createAlbaran()

   METHOD test_create_sin_filtros()

   METHOD test_create_serie_desde()

   METHOD test_create_solo_hasta()

   METHOD test_create_desde_hasta()

   METHOD test_create_select_one()

   METHOD test_create_no_albaran()

   METHOD test_create_cancel()

   METHOD test_create_no_select()

   METHOD test_create_filtros_varios()

END CLASS

//---------------------------------------------------------------------------//

METHOD beforeClass() CLASS TestConversorToFacturaVentasController 

   ::oController  := ConversorPrepareAlbaranVentasController():New( ::getAlbaranesVentasController() , ::getFacturasVentasController() )  

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD afterClass() CLASS TestConversorToFacturaVentasController

   ::oController:End()

   if !empty( ::oAlbaranesVentasController )
      ::oAlbaranesVentasController:End()
   end if

   if !empty( ::oFacturasVentasController )
      ::oFacturasVentasController:End()
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Before() CLASS TestConversorToFacturaVentasController

   SQLTercerosModel():truncateTable()

   SQLDireccionesModel():truncateTable()

   SQLAlmacenesModel():truncateTable()
      SQLUbicacionesModel():truncateTable()

   SQLMetodoPagoModel():truncateTable()

   SQLArticulosModel():truncateTable()
   
   SQLAlbaranesVentasModel():truncateTable()
      SQLAlbaranesVentasLineasModel():truncateTable()
      SQLAlbaranesVentasDescuentosModel():truncateTable()

   SQLFacturasVentasModel():truncateTable()
      SQLFacturasVentasLineasModel():truncateTable()
      SQLFacturasVentasDescuentosModel():truncateTable()

   SQLConversorDocumentosModel():truncateTable()
   SQLRecibosModel():truncateTable()

   SQLArticulosTarifasModel():truncateTable()

   SQLAgentesModel():truncateTable()

   SQLTiposIvaModel():truncateTable()
   SQLUbicacionesModel():truncateTable()
   SQLArticulosTarifasModel():truncateTable()
   SQLRutasModel():truncateTable()

   SQLConversorDocumentosModel():truncateTable()

   SQLContadoresModel():truncateTable()

   SQLMetodoPagoModel():test_create_con_plazos_con_hash() 
   SQLMetodoPagoModel():test_create_con_plazos_con_hash( {  "codigo"          => "1",;
                                                            "numero_plazos"   => 5  } ) 

   SQLTiposIvaModel():test_create_iva_al_21()

   SQLAlmacenesModel():test_create_almacen_principal()

   SQLUbicacionesModel():test_create_trhee_with_parent( SQLAlmacenesModel():test_get_uuid_almacen_principal() )

   SQLRutasModel():test_create_ruta_principal()
   SQLRutasModel():test_create_ruta_alternativa()

   SQLArticulosModel():test_create_precio_con_descuentos()

   SQLArticulosTarifasModel():test_create_tarifa_base()
   SQLArticulosTarifasModel():test_create_tarifa_mayorista()

   SQLAgentesModel():test_create_agente_principal()

   SQLTercerosModel():test_create_cliente_con_plazos( 0 )
   SQLTercerosModel():test_create_cliente_con_plazos( 1 )

   SQLContadoresModel():insertSerie( SQLAlbaranesVentasModel():cTableName, "B", 1 )
   SQLContadoresModel():insertSerie( SQLAlbaranesVentasModel():cTableName, "A", 1 )

   ::aSelected                      := {}

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD createAlbaran( hAlbaran ) CLASS TestConversorToFacturaVentasController

   local hLinea         := {}

   SQLAlbaranesVentasModel():createAlbaran_ventas( hAlbaran )

   hLinea               := { "parent_uuid"   => SQLAlbaranesVentasModel():test_get_uuid_albaran_ventas( hget( hAlbaran,"serie" ), hget( hAlbaran, "numero" ) ) }

   SQLAlbaranesVentasLineasModel():create_linea_albaran_ventas( hLinea )
  
   aadd( ::aSelected, SQLAlbaranesVentasModel():test_get_uuid_albaran_ventas( hget( hAlbaran, "serie" ), hget( hAlbaran, "numero" ) ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_sin_filtros() CLASS TestConversorToFacturaVentasController

   ::createAlbaran( {  "serie"   => "A",;
                        "numero"  =>  3 } )

   ::createAlbaran( {  "serie"  =>  "A",;
                        "numero" =>   4  } )

   ::createAlbaran( {  "serie"  =>  "A",;
                        "numero" =>   5  } )

   ::createAlbaran( {  "serie"  =>  "A",;
                        "numero" =>   6  } )

   ::oController:getConversorView():setEvent( 'painted',;
         <| self | 

         testWaitSeconds( 1 )

         self:getControl( IDOK ):Click()

         testWaitSeconds( 1 )
            
         self:getControl( IDOK ):Click()
            
         testWaitSeconds( 1 )
         
         self:getControl( IDOK ):Click()

         RETURN ( nil ) 

         > )
   
   ::oController:Run()

   ::Assert():equals( 4, ::oController:oOrigenController:getRowset():recCount(), "Aparecen 4 albaranes despues de filtrar" )

   ::Assert():equals( 1, ::oController:oDestinoController:getRowset():recCount(), "Genera una factura con distintos terceros" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_serie_desde() CLASS TestConversorToFacturaVentasController

   ::createAlbaran( {  "serie"           =>  "A",;
                        "numero"          =>   3 ,;
                        "tercero_codigo"  =>  "0" } )

   ::createAlbaran( {  "serie"           =>  "A",;
                        "numero"          =>   4 ,;
                        "tercero_codigo"  =>  "0" } )

   ::createAlbaran( {  "serie"           =>  "A",;
                        "numero"          =>   5 ,;
                        "tercero_codigo"  =>  "1" } )

   ::createAlbaran( {  "serie"           =>  "B",;
                        "numero"          =>   6 ,;
                        "tercero_codigo"  =>  "1" } )

   ::oController:getConversorView():setEvent( 'painted',;
         <| self | 

            testWaitSeconds( 1 )

            eval( ::oBrwRange:oColDesde:bOnPostEdit, nil, "A" )

            testWaitSeconds( 1 )

            self:getControl( IDOK ):Click()

            testWaitSeconds( 1 )
            
            self:getControl( IDOK ):Click()
            
            testWaitSeconds( 1 )
         
            self:getControl( IDOK ):Click()

            RETURN ( nil )

            > )
   
   ::oController:Run()

   ::Assert():equals( 3, ::oController:oOrigenController:getRowset():recCount(), "Aparecen 3 albaranes despues de filtrar" )

   ::Assert():equals( 2, ::oController:oDestinoController:getRowset():recCount(), "Genera dos facturas con distintos terceros" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_solo_hasta() CLASS TestConversorToFacturaVentasController

   ::createAlbaran( {  "serie"           =>  "A",;
                        "numero"          =>   3 ,;
                        "tercero_codigo"  =>  "0" } )

   ::createAlbaran( {  "serie"           =>  "A",;
                        "numero"          =>   4 ,;
                        "tercero_codigo"  =>  "0" } )

   ::createAlbaran( {  "serie"           =>  "A",;
                        "numero"          =>   5 ,;
                        "tercero_codigo"  =>  "1" } )

   ::createAlbaran( {  "serie"           =>  "B",;
                        "numero"          =>   6 ,;
                        "tercero_codigo"  =>  "1" } )

   ::oController:getConversorView():setEvent( 'painted',;
         <| self | 

            testWaitSeconds( 1 )

            eval( ::oBrwRange:oColHasta:bOnPostEdit, nil, "B" )

            testWaitSeconds( 1 )
            
            self:getControl( IDCANCEL ):Click()
            

            RETURN ( nil )

            > )
   
   ::oController:Run()

   ::Assert():equals( 0, ::oController:oOrigenController:getRowset():recCount(), "No aparece ningun albar�n" )

   ::Assert():equals( 0, ::oController:oDestinoController:getRowset():recCount(), "No genera facturas" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_desde_hasta() CLASS TestConversorToFacturaVentasController

   ::createAlbaran( {  "serie"           =>  "A",;
                        "numero"          =>   1 ,;
                        "tercero_codigo"  =>  "0" } )

   ::createAlbaran( {  "serie"           =>  "A",;
                        "numero"          =>   2 ,;
                        "tercero_codigo"  =>  "0" } )

   ::createAlbaran( {  "serie"           =>  "B",;
                        "numero"          =>   1 ,;
                        "tercero_codigo"  =>  "0" } )

   ::createAlbaran( {  "serie"           =>  "C",;
                        "numero"          =>   1 ,;
                        "tercero_codigo"  =>  "0" } )

   ::oController:getConversorView():setEvent( 'painted',;
         <| self | 

            testWaitSeconds( 1 )

            eval( ::oBrwRange:oColDesde:bOnPostEdit, nil, "A" )

            testWaitSeconds( 1 )

            eval( ::oBrwRange:oColHasta:bOnPostEdit, nil, "B" )

            testWaitSeconds( 1 )
            
            self:getControl( IDOK ):Click()

            testWaitSeconds( 1 )
            
            self:getControl( IDOK ):Click()
            
            testWaitSeconds( 1 )
         
            self:getControl( IDOK ):Click()
            
            RETURN ( nil )

            > )
   
   ::oController:Run()

   ::Assert():equals( 3, ::oController:oOrigenController:getRowset():recCount(), "Aparecen 3 albaranes ( la serie C se queda fuera)" )

   ::Assert():equals( 2, ::oController:oDestinoController:getRowset():recCount(), "Genera 2 facturas" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_select_one() CLASS TestConversorToFacturaVentasController

   ::createAlbaran( {  "serie"           =>  "A",;
                        "numero"          =>   1 ,;
                        "tercero_codigo"  =>  "0" } )

   ::createAlbaran( {  "serie"           =>  "A",;
                        "numero"          =>   2 ,;
                        "tercero_codigo"  =>  "0" } )

   ::oController:getConversorView():setEvent( 'painted',;
         <| self | 

            testWaitSeconds( 1 )
            
            self:getControl( IDOK ):Click()

            testWaitSeconds( 1 )

            ::oController:oOrigenController:getBrowseView():selectCurrent() 
            
            self:getControl( IDOK ):Click()
            
            testWaitSeconds( 1 )
         
            self:getControl( IDOK ):Click()
            
            RETURN ( nil )

            > )
   
   ::oController:Run()

   ::Assert():equals( 2, ::oController:oOrigenController:getRowset():recCount(), "Aparecen 2 albaranes" )

   ::Assert():equals( 1, ::oController:oDestinoController:getRowset():recCount(), "Genera 1 facturas" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_no_albaran() CLASS TestConversorToFacturaVentasController

   ::oController:getConversorView():setEvent( 'painted',;
         <| self | 

            testWaitSeconds( 1 )
            
            self:getControl( IDOK ):Click()

            testWaitSeconds( 1 )
            
            self:getControl( IDCANCEL ):Click()
            
            RETURN ( nil )

            > )
   
   ::oController:Run()

   ::Assert():equals( 0, ::oController:oOrigenController:getRowset():recCount(), "Aparecen 0 albaranes" )

   ::Assert():equals( 0, ::oController:oDestinoController:getRowset():recCount(), "No genera facturas" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_cancel() CLASS TestConversorToFacturaVentasController

   ::createAlbaran( {  "serie"           =>  "A",;
                        "numero"          =>   1 ,;
                        "tercero_codigo"  =>  "0" } )

   ::createAlbaran( {  "serie"           =>  "A",;
                        "numero"          =>   2 ,;
                        "tercero_codigo"  =>  "0" } )

   ::oController:getConversorView():setEvent( 'painted',;
         <| self | 

            testWaitSeconds( 1 )
            
            self:getControl( IDOK ):Click()

            testWaitSeconds( 1 )
            
            self:getControl( IDCANCEL ):Click()
            
            RETURN ( nil )

            > )
   
   ::oController:Run()

   ::Assert():equals( 2, ::oController:oOrigenController:getRowset():recCount(), "Aparecen 2 albaranes" )

   ::Assert():equals( 0, ::oController:oDestinoController:getRowset():recCount(), "No genera facturas" )

RETURN ( nil )

//---------------------------------------------------------------------------//

 METHOD test_create_no_select() CLASS TestConversorToFacturaVentasController

 ::createAlbaran( {  "serie"           =>  "A",;
                        "numero"          =>   1 ,;
                        "tercero_codigo"  =>  "0" } )

   ::createAlbaran( {  "serie"           =>  "A",;
                        "numero"          =>   2 ,;
                        "tercero_codigo"  =>  "0" } )

   ::oController:getConversorView():setEvent( 'painted',;
         <| self | 

            testWaitSeconds( 1 )
            
            self:getControl( IDOK ):Click()

            testWaitSeconds( 1 )

            self:getControl( 100, ::oFolder:aDialogs[ 2 ] ):select( 0 ) 

            testWaitSeconds( 1 )
            
            self:getControl( IDOK ):Click()
            
            testWaitSeconds( 1 )

            self:getControl( IDCANCEL ):Click()
            
            RETURN ( nil )

            > )
   
   ::oController:Run()

   ::Assert():equals( 2, ::oController:oOrigenController:getRowset():recCount(), "Aparecen 2 albaranes" )

   ::Assert():equals( 0, ::oController:oDestinoController:getRowset():recCount(), "Genera 0 facturas" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_filtros_varios() CLASS TestConversorToFacturaVentasController

   ::createAlbaran( {  "serie" =>  "A", "numero" => 1, "tercero_codigo" => "0" } )

   ::createAlbaran( {  "serie"           =>  "A",;
                        "numero"          =>   2 ,;
                        "tercero_codigo"  =>  "1" } )

   ::createAlbaran( {  "serie"           =>  "B",;
                        "numero"          =>   6 ,;
                        "tercero_codigo"  =>  "1" } )

   ::createAlbaran( {  "serie"           =>  "B",;
                        "numero"          =>   7 ,;
                        "tercero_codigo"  =>  "1" } )

   ::createAlbaran( {  "serie"           =>  "C",;
                        "numero"          =>   7 ,;
                        "tercero_codigo"  =>  "0" } )

   ::createAlbaran( {  "serie"           =>  "A",;
                        "numero"          =>   7 ,;
                        "tercero_codigo"  =>  "2" } )

   ::oController:getConversorView():setEvent( 'painted',;
         <| self | 

            testWaitSeconds( 1 )

            eval( ::oBrwRange:oColDesde:bOnPostEdit, nil, "A" )

            testWaitSeconds( 1 )

            eval( ::oBrwRange:oColHasta:bOnPostEdit, nil, "B" )

            testWaitSeconds( 1 )

            self:getControl( 140, ::oFolder:aDialogs[ 1 ] ):goDown()

            testWaitSeconds( 1 ) 

            self:getControl( 140, ::oFolder:aDialogs[ 1 ] ):goDown()

            testWaitSeconds( 1 )

            eval( ::oBrwRange:oColDesde:bOnPostEdit, nil, "0" )

            testWaitSeconds( 1 )

            eval( ::oBrwRange:oColHasta:bOnPostEdit, nil, "1" )

            testWaitSeconds( 1 )

            self:getControl( 140, ::oFolder:aDialogs[ 1 ] ):goDown()

            testWaitSeconds( 1 )
            
            self:getControl( IDOK ):Click()

            testWaitSeconds( 1 )
            
            self:getControl( IDOK ):Click()

            testWaitSeconds( 1 )
            
            self:getControl( IDOK ):Click()
            
            RETURN ( nil )

            > )
   
   ::oController:Run()

   ::Assert():equals( 4, ::oController:oOrigenController:getRowset():recCount(), "Aparecen 4 albaranes" )

   ::Assert():equals( 3, ::oController:oDestinoController:getRowset():recCount(), "Genera 3 facturas" )

RETURN ( nil )

//---------------------------------------------------------------------------//