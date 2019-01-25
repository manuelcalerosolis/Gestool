#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS OperacionAlmacenView FROM OperacionesView
  
   DATA oBtnLineasDeleted

   DATA oTotalImporte
   DATA nTotalImporte                  INIT 0

   METHOD Activate()
      METHOD startActivate()           VIRTUAL
      METHOD validActivate()

   METHOD defineAlmacenSelector()      VIRTUAL

   METHOD addLinksToExplorerBar()

   METHOD setLinesShowDeleted()        INLINE ( ::getController():getLinesController():setShowDeleted(),;
                                                ::oBtnLineasDeleted:Toggle(),;
                                                ::oBtnLineasDeleted:cTooltip := if( ::oBtnLineasDeleted:lPressed, "Ocultar borrados", "Mostrar borrados" ) ) 

   METHOD setDiscountShowDeleted()     INLINE ( ::getController():getFacturasVentasDescuentosController():setShowDeleted(),;
                                                ::oBtnDescuentosDeleted:Toggle(),;
                                                ::oBtnDescuentosDeleted:cTooltip := if( ::oBtnDescuentosDeleted:lPressed, "Ocultar borrados", "Mostrar borrados" ) ) 

   METHOD defaultTitle()

   METHOD validateAlmacen( cField )

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS OperacionAlmacenView
   
   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "TRANSACION_COMERCIAL" ;
      TITLE       ::LblTitle() + lower( ::oController:getTitle() )

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::getController():getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      PROMPT      ::oController:getTitle() ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog

   REDEFINE FOLDER ::oFolder ;
      ID          500 ;
      OF          ::oDialog ;
      PROMPT      "General" ;
      DIALOGS     "OPERACIONES_ALMACEN"

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

   ::defineAlmacenSelector()

   // Comentario---------------------------------------------------------------

   REDEFINE GET   ::getController():getModel():hBuffer[ "comentario" ] ;
      ID          150 ;
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

   TBtnBmp():ReDefine( 501, "new16", , , , , {|| ::getController():appendLine() }, ::oFolder:aDialogs[1], .f., {|| ::getController():isNotZoomMode() }, .f., "A�adir l�nea" )

   TBtnBmp():ReDefine( 502, "del16",,,,, {|| ::getController():getLinesController():Delete() }, ::oFolder:aDialogs[1], .f., {|| ::getController():isNotZoomMode() }, .f., "Eliminar l�neas" )

   TBtnBmp():ReDefine( 503, "refresh16",,,,, {|| ::getController():getLinesController():refreshRowSet() }, ::oFolder:aDialogs[1], .f., , .f., "Recargar l�neas" )
   
   ::oBtnLineasDeleted := TBtnBmp():ReDefine( 504, "gc_deleted_16",,,,, {|| ::setLinesShowDeleted()  }, ::oFolder:aDialogs[1], .f., , .f., "Mostrar/Ocultar borrados" )
   
   TBtnBmp():ReDefine( 505, "gc_object_cube_16",,,,, {|| ::getController():getLinesController():Edit()  }, ::oFolder:aDialogs[1], .f., , .f., "Mostrar ficha de art�culo" )

   ::getController():getLinesController():Activate( 500, ::oFolder:aDialogs[1] )

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
               ::getController():appendLine()
            case nKey == VK_F4
               ::getController():getLinesController():Delete()
         end 
         RETURN ( 0 )
         >

   end if

   ::oDialog:bStart := {|| ::startActivate(), ::paintedActivate() }

   ACTIVATE DIALOG ::oDialog CENTER

RETURN ( ::oDialog:nResult ) 

//---------------------------------------------------------------------------//

METHOD validActivate() CLASS OperacionAlmacenView

   if notValidateDialog( ::oFolder:aDialogs )
      RETURN ( .f. )
   end if

   if ::getController():notValidate( "formulario" )
      RETURN ( .f. )
   end if 

   if !::getController():getLinesController():validLine()
      RETURN( .f. )
   end if

RETURN ( ::oDialog:end( IDOK ) )

//---------------------------------------------------------------------------//

METHOD addLinksToExplorerBar() CLASS OperacionAlmacenView

   local oPanel

   oPanel            := ::oExplorerBar:AddPanel( "Datos relacionados", nil, 1 ) 

   oPanel:AddLink(   "Incidencias...",;
                     {||   ::getController():getIncidenciasController():activateDialogView() },;
                           ::getController():getIncidenciasController():getImage( "16" ) )

   oPanel:AddLink(   "Campos extra...",;
                     {||   ::getController():getCamposExtraValoresController():Edit( ::getController():getUuid() ) },;
                           ::getController():getCamposExtraValoresController():getImage( "16" ) )

   ::addLinksElementToExplorerBar() 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD defaultTitle() CLASS OperacionAlmacenView

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

METHOD validateAlmacen( cField ) CLASS OperacionAlmacenView

   DEFAULT cField    := "almacen_codigo"

   if ::getController():validate( cField )
      
      ::getController():getModel():updateFieldWhereId( ::getController():getModel():getBufferColumnKey(), cField, ::getController():getModelBuffer( cField ) )
      
      RETURN ( .t. )
   
   end if 

RETURN ( .f. )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ConsolidacionAlmacenView FROM OperacionAlmacenView 

   METHOD defineAlmacenSelector()

   METHOD startActivate()

END CLASS

//---------------------------------------------------------------------------//

METHOD defineAlmacenSelector() CLASS ConsolidacionAlmacenView

   ::getController():getAlmacenesController():getSelector():Bind( bSETGET( ::getController():getModel():hBuffer[ "almacen_codigo" ] ) )
   ::getController():getAlmacenesController():getSelector():Build( { "idGet" => 130, "idText" => 131, "idLink" => 132, "oDialog" => ::oFolder:aDialogs[1] } )
   ::getController():getAlmacenesController():getSelector():setValid( {|| ::validateAlmacen() } )
   ::getController():getAlmacenesController():getSelector():setWhen( {|| ::getController():hasNotLines() } )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD startActivate() CLASS ConsolidacionAlmacenView

   ::addLinksToExplorerBar()

   ::getController():getAlmacenesController():getSelector():Start()

   ::getController():calculateTotals()

   ::getController():getLinesController():getBrowseView():Refresh()

   ::getController():getAlmacenesController():getSelector():setFocus()

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS MovimientoAlmacenView FROM OperacionAlmacenView 

   METHOD defineAlmacenSelector()

   METHOD startActivate()

   METHOD validateAlmacenOrigen()      INLINE ( ::validateAlmacen( "almacen_origen_codigo" ) )

   METHOD validateAlmacenDestino()     INLINE ( ::validateAlmacen( "almacen_destino_codigo" ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD defineAlmacenSelector() CLASS MovimientoAlmacenView

   ::getController():getAlmacenOrigenController():getSelector():Bind( bSETGET( ::getController():getModel():hBuffer[ "almacen_origen_codigo" ] ) )
   ::getController():getAlmacenOrigenController():getSelector():Build( { "idGet" => 130, "idText" => 131, "idLink" => 132, "oDialog" => ::oFolder:aDialogs[1] } )
   ::getController():getAlmacenOrigenController():getSelector():setLinkText( "Almac�n origen" ) 
   ::getController():getAlmacenOrigenController():getSelector():setValid( {|| ::validateAlmacenOrigen() } )
   ::getController():getAlmacenOrigenController():getSelector():setWhen( {|| ::getController():hasNotLines() } )

   ::getController():getAlmacenDestinoController():getSelector():Bind( bSETGET( ::getController():getModel():hBuffer[ "almacen_destino_codigo" ] ) )
   ::getController():getAlmacenDestinoController():getSelector():Build( { "idGet" => 140, "idText" => 141, "idLink" => 142, "oDialog" => ::oFolder:aDialogs[1] } )
   ::getController():getAlmacenDestinoController():getSelector():setValid( {|| ::validateAlmacenDestino() } )
   ::getController():getAlmacenDestinoController():getSelector():setWhen( {|| ::getController():hasNotLines() } )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD startActivate() CLASS MovimientoAlmacenView

   ::addLinksToExplorerBar()

   ::getController():getAlmacenOrigenController():getSelector():Start()

   ::getController():getAlmacenDestinoController():getSelector():Show()
   ::getController():getAlmacenDestinoController():getSelector():Start()

   ::getController():calculateTotals()

   ::getController():getLinesController():getBrowseView():Refresh()

   ::getController():getAlmacenOrigenController():getSelector():setFocus()

RETURN ( nil )

//---------------------------------------------------------------------------//

