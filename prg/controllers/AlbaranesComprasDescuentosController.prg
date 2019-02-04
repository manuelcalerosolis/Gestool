#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS AlbaranesComprasDescuentosController FROM OperacionesComercialesDescuentosController

   METHOD New() CONSTRUCTOR

   METHOD End()  

   //Construcciones tardias----------------------------------------------------

   METHOD getModel()                   INLINE ( if( empty( ::oModel ), ::oModel := SQLAlbaranesComprasDescuentosModel():New( self ), ), ::oModel )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS AlbaranesComprasDescuentosController

   ::Super:New( oController )

   ::cTitle                            := "Albaranes proveedores descuentos"

   ::cName                             := "albaranes_proveedores_descuentos"

   ::hImage                            := {  "16" => "gc_symbol_percent_16",;
                                             "32" => "gc_symbol_percent_32",;
                                             "48" => "gc_symbol_percent_48" }

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS AlbaranesComprasDescuentosController

   if !empty( ::oModel )
      ::oModel:End()
   end if 

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLAlbaranesComprasDescuentosModel FROM SQLOperacionesComercialesDescuentosModel

   DATA cTableName               INIT "albaranes_compras_descuentos"

   DATA cOrderBy                 INIT "albaranes_compras_descuentos.id"

#ifdef __TEST__

   METHOD test_create_descuento( hDatosDescuento )

#endif
   
END CLASS

//---------------------------------------------------------------------------//

#ifdef __TEST__

METHOD test_create_descuento( hDatosDescuento ) CLASS SQLAlbaranesComprasDescuentosModel

   local hBuffer := ::loadBlankBuffer( {  "nombre"                => "Descuento 1" ,;
                                          "descuento"             => 15             } )  

 if hb_ishash( hDatosDescuento )
      heval( hDatosDescuento, {|k,v| hset( hBuffer, k, v) } )
   end if
   
   ::insertBuffer( hBuffer )

RETURN( nil )

//---------------------------------------------------------------------------//

#endif

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//