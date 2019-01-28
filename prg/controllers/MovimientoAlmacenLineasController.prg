#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS MovimientoAlmacenLineasController FROM OperacionAlmacenLineasController

   METHOD getModel()                   INLINE ( iif( empty( ::oModel ), ::oModel := SQLMovimientosAlmacenesLineasModel():New( self ), ), ::oModel )

   METHOD getBrowseView()              INLINE ( iif( empty( ::oBrowseView ), ::oBrowseView := MovimientoAlmacenLineasBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD postValidateUbicacionOrigenCodigo( oCol, uValue, nKey, cField ) ;
                                       INLINE ( ::postValidateUbicacionCodigo( oCol, uValue, nKey, "ubicacion_origen_codigo" ) )  

   METHOD postValidateUbicacionDestinoCodigo( oCol, uValue, nKey, cField ) ;
                                       INLINE ( ::postValidateUbicacionCodigo( oCol, uValue, nKey, "ubicacion_destino_codigo" ) )  

   METHOD validLineUbicacionOrigen()   

   METHOD validLineUbicacionDestino()  

   METHOD validLine()

END CLASS

//---------------------------------------------------------------------------//

METHOD validLine() CLASS MovimientoAlmacenLineasController

   if empty( ::getRowSet():fieldget( 'articulo_codigo' ) )
      RETURN ( .t. )
   end if 

   if !( ::validLineLote() )
      RETURN ( .f. )
   end if

   if !( ::validLineCombinacion() )
      RETURN ( .f. )
   end if

   if !( ::validLineUbicacionOrigen() )
      RETURN ( .f. )
   end if

   if !( ::validLineUbicacionDestino() )
      RETURN ( .f. )
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD validLineUbicacionOrigen() CLASS MovimientoAlmacenLineasController

   if !( Company():getDefaultUsarUbicaciones() )
      RETURN ( .t. )
   end if 

   if empty( ::getRowSet():fieldget( 'ubicacion_origen_codigo' ) )

      ::getController():getDialogView():showMessage( "Ubicación origen no puede estar vacia en la línea" )   
   
      ::getBrowseView():setFocusColumnCodigoUbicacionOrigen()
   
      RETURN ( .f. )
   
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD validLineUbicacionDestino() CLASS MovimientoAlmacenLineasController 

   if !( Company():getDefaultUsarUbicaciones() )
      RETURN ( .t. )
   end if 

   if empty( ::getRowSet():fieldget( 'ubicacion_destino_codigo' ) )

      ::getController():getDialogView():showMessage( "Ubicación destino no puede estar vacia en la línea" )   
   
      ::getBrowseView():setFocusColumnCodigoUbicacionDestino()
   
      RETURN ( .f. )
   
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
