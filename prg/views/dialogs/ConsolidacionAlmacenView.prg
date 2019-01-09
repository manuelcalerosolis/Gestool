#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ConsolidacionAlmacenView FROM SQLBaseView
  
   DATA oExplorerBar

   DATA oBtnLineasDeleted

   DATA oTotalImporte
   DATA nTotalImporte                  INIT 0
   
   METHOD Activate()
      METHOD startActivate()
      METHOD validActivate()

   METHOD addLinksToExplorerBar()

   METHOD lineAppend()

   METHOD setLinesShowDeleted()       INLINE ( ::getController():getFacturasVentasLineasController():setShowDeleted(),;
                                                ::oBtnLineasDeleted:Toggle(),;
                                                ::oBtnLineasDeleted:cTooltip := if( ::oBtnLineasDeleted:lPressed, "Ocultar borrados", "Mostrar borrados" ) ) 

   METHOD setDiscountShowDeleted()    INLINE ( ::getController():getFacturasVentasDescuentosController():setShowDeleted(),;
                                                ::oBtnDescuentosDeleted:Toggle(),;
                                                ::oBtnDescuentosDeleted:cTooltip := if( ::oBtnDescuentosDeleted:lPressed, "Ocultar borrados", "Mostrar borrados" ) ) 

METHOD defaultTitle()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS ConsolidacionAlmacenView
   
   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "TRANSACION_COMERCIAL" ;
      TITLE       ::LblTitle() + "consolidación"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::getController():getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      PROMPT      "Consolidaciones de almacén" ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog

   REDEFINE FOLDER ::oFolder ;
      ID          500 ;
      OF          ::oDialog ;
      PROMPT      "General" ;
      DIALOGS     "CONSOLIDACION_ALMACEN"

   ::redefineExplorerBar()

   // Serie-------------------------------------------------------------------

   ::getController():getSerieDocumentoComponent():BindValue( bSETGET( ::getController():getModel():hBuffer[ "serie" ] ) )
   ::getController():getSerieDocumentoComponent():Activate( 100, ::oFolder:aDialogs[1] )

   // Numero-------------------------------------------------------------------

   ::getController():getNumeroDocumentoComponent():BindValue( bSETGET( ::getController():getModel():hBuffer[ "numero" ] ) )
   ::getController():getNumeroDocumentoComponent():Activate( 110, ::oFolder:aDialogs[1] )

   // Fecha--------------------------------------------------------------------

   REDEFINE GET   ::getController():getModel():hBuffer[ "fecha_valor_stock" ] ;
      ID          120 ;
      PICTURE     "@DT" ;
      SPINNER ;
      WHEN        ( ::getController():isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   // Almacenes----------------------------------------------------------------

   ::getController():getAlmacenesController():getSelector():Bind( bSETGET( ::getController():getModel():hBuffer[ "almacen_codigo" ] ) )
   ::getController():getAlmacenesController():getSelector():Build( { "idGet" => 130, "idText" => 131, "idLink" => 132, "oDialog" => ::oFolder:aDialogs[1] } )
   ::getController():getAlmacenesController():getSelector():setValid( {|| ::getController():validate( "almacen_codigo" ) } )

   // Comentario---------------------------------------------------------------

   REDEFINE GET   ::getController():getModel():hBuffer[ "comentario" ] ;
      ID          140 ;
      WHEN        ( ::getController():isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   // Totales------------------------------------------------------------------

   REDEFINE SAY   ::oTotalImporte ;
      VAR         ::nTotalImporte ;
      ID          330 ;
      FONT        oFontBold() ;
      PICTURE     "@E 999,999,999.99" ;
      OF          ::oFolder:aDialogs[1]

   // Lineas ------------------------------------------------------------------

   TBtnBmp():ReDefine( 501, "new16", , , , , {|| ::lineAppend() }, ::oFolder:aDialogs[1], .f., {|| ::getController():isNotZoomMode() }, .f., "Añadir línea" )

   TBtnBmp():ReDefine( 502, "del16",,,,, {|| ::getController():getFacturasVentasLineasController():Delete() }, ::oFolder:aDialogs[1], .f., {|| ::getController():isNotZoomMode() }, .f., "Eliminar líneas" )

   TBtnBmp():ReDefine( 503, "refresh16",,,,, {|| ::getController():getFacturasVentasLineasController():refreshRowSet() }, ::oFolder:aDialogs[1], .f., , .f., "Recargar líneas" )
   
   ::oBtnLineasDeleted := TBtnBmp():ReDefine( 504, "gc_deleted_16",,,,, {|| ::setLinesShowDeleted()  }, ::oFolder:aDialogs[1], .f., , .f., "Mostrar/Ocultar borrados" )
   
   TBtnBmp():ReDefine( 505, "gc_object_cube_16",,,,, {|| ::getController():getFacturasVentasLineasController():Edit()  }, ::oFolder:aDialogs[1], .f., , .f., "Mostrar ficha de artículo" )

   ::getController():getFacturasVentasLineasController():Activate( 500, ::oFolder:aDialogs[1] )

   // Botones generales--------------------------------------------------------

   ApoloBtnFlat():Redefine( IDOK, {|| ::validActivate() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, ::oDialog:end( IDOK ), ) }

   if ::getController():isNotZoomMode() 
   
      ::oDialog:bKeyDown   := <| nKey |  
         do case         
            case nKey == VK_F5
               ::validActivate()
            case nKey == VK_F2
               ::getController():getFacturasVentasLineasController():AppendLineal()
            case nKey == VK_F4
               ::getController():getFacturasVentasLineasController():Delete()
         end 
         RETURN ( 0 )
         >

   end if

   ::oDialog:bStart := {|| ::startActivate(), ::paintedActivate() }

   ACTIVATE DIALOG ::oDialog CENTER

RETURN ( ::oDialog:nResult ) 

//---------------------------------------------------------------------------//

METHOD startActivate() CLASS ConsolidacionAlmacenView

   ::addLinksToExplorerBar()

   ::getController():getAlmacenesController():getSelector():Start()

   ::getController():calculateTotals()

   // ::getController():getSerieDocumentoComponent()::setFocus()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD validActivate() CLASS ConsolidacionAlmacenView

   if notValidateDialog( ::oFolder:aDialogs )
      RETURN ( nil )
   end if

   if !::getController():getFacturasVentasLineasController():validLine()
      RETURN( nil )
   end if

RETURN ( ::oDialog:end( IDOK ) )

//---------------------------------------------------------------------------//

METHOD addLinksToExplorerBar() CLASS ConsolidacionAlmacenView

   local oPanel

   oPanel            := ::oExplorerBar:AddPanel( "Datos relacionados", nil, 1 ) 


   oPanel:AddLink(   "Incidencias...",;
                     {|| ::getController():getIncidenciasController():activateDialogView() },;
                         ::getController():getIncidenciasController():getImage( "16" ) )

   oPanel            := ::oExplorerBar:AddPanel( "Otros datos", nil, 1 ) 

   if ::getController():isNotZoomMode()

      oPanel:AddLink(   "Campos extra...",;
                        {||   ::getController():getCamposExtraValoresController():Edit( ::getController():getUuid() ) },;
                              ::getController():getCamposExtraValoresController():getImage( "16" ) )
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD lineAppend() CLASS ConsolidacionAlmacenView

   if !::getController():getFacturasVentasLineasController():validLine()
      RETURN( nil )
   end if

RETURN ( ::getController():getFacturasVentasLineasController():AppendLineal() ) 

//---------------------------------------------------------------------------//

METHOD defaultTitle() CLASS ConsolidacionAlmacenView

   local cTitle  := ::oController:getTitle() + " : " 

   if empty( ::oController:oModel )
      RETURN ( cTitle )
   end if 

   if empty( ::oController:oModel:hBuffer )
      RETURN ( cTitle )
   end if 

   if hhaskey( ::oController:oModel:hBuffer, "serie" )
      cTitle      +=  alltrim( ::oController:oModel:hBuffer[ "serie" ] ) + "/"
   end if
   
   if hhaskey( ::oController:oModel:hBuffer, "numero" )
      cTitle      += alltrim( toSQLString( ::oController:oModel:hBuffer[ "numero" ] ) )
   end if

RETURN ( cTitle )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

