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

   DATA cConstraints                   INIT  "PRIMARY KEY ( id ), "                                   + ;
                                                "FOREIGN KEY ( parent_uuid ) "                        + ;
                                                "REFERENCES " + SQLAlbaranesVentasModel():cTableName() + " ( uuid ) ON DELETE CASCADE"

   DATA cTableName                     INIT "albaranes_ventas_descuentos"

   DATA cOrderBy                       INIT "albaranes_ventas_descuentos.id"
   
END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//