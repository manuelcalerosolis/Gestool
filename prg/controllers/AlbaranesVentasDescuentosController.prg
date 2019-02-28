#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS AlbaranesVentasDescuentosController FROM OperacionesComercialesDescuentosController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD getModel()                   INLINE ( if( empty( ::oModel ), ::oModel := SQLAlbaranesVentasDescuentosModel():New( self ), ), ::oModel )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS AlbaranesVentasDescuentosController

   ::Super:New( oController )

   ::cTitle                            := "Albaranes ventas descuentos"

   ::cName                             := "albaranes_ventas_descuentos"

   ::hImage                            := {  "16" => "gc_symbol_percent_16",;
                                             "32" => "gc_symbol_percent_32",;
                                             "48" => "gc_symbol_percent_48" }

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS AlbaranesVentasDescuentosController

   if !empty( ::oModel )
      ::oModel:End()
   end if 

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLAlbaranesVentasDescuentosModel FROM SQLOperacionesComercialesDescuentosModel

   DATA cConstraints                   INIT  "PRIMARY KEY ( nombre, deleted_at, parent_uuid ), "   + ;
                                                "FOREIGN KEY ( parent_uuid ) "                     + ;
                                                "REFERENCES " + SQLAlbaranesVentasModel():getTable() + " ( uuid ) ON DELETE CASCADE"

   DATA cTableName                     INIT "albaranes_ventas_descuentos"

   DATA cOrderBy                       INIT "albaranes_ventas_descuentos.id"
   
END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//