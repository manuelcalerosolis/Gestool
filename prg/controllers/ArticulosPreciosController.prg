#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ArticulosPreciosController FROM SQLBrowseController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD setPrecioBase( uuidArticulo, uuidPrecio, nPrecioBase )
   
   METHOD setPrecioIVAIncluido( uuidArticulo, uuidPrecio, nPrecioBase )

   METHOD setManual( oCol, lManual )

   METHOD getUuid()                    INLINE ( if( !empty( ::getRowSet() ),  ::getRowSet():fieldGet( 'uuid' ), nil ) )

   //Construcciones tardias----------------------------------------------------

   METHOD getModel()                   INLINE ( if( empty( ::oModel ),        ::oModel := SQLArticulosPreciosModel():New( self ), ), ::oModel )

   METHOD getBrowseView()              INLINE ( if( empty( ::oBrowseView ),   ::oBrowseView := ArticulosPreciosBrowseView():New( self ), ), ::oBrowseView )

   METHOD getDialogView()              INLINE ( if( empty( ::oDialogView ),   ::oDialogView := ArticulosPreciosView():New( self ), ), ::oDialogView )

   METHOD getValidator()               INLINE ( if( empty( ::oValidator ),    ::oValidator := ArticulosPreciosValidator():New( self ), ), ::oValidator )

   METHOD getRepository()              INLINE ( if( empty( ::oRepository ),   ::oRepository := ArticulosPreciosRepository():New( self ), ), ::oRepository )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS ArticulosPreciosController

   ::Super:New( oController )

   ::lTransactional                    := .t.

   ::hImage                            := {  "16" => "gc_money_interest_16",;
                                             "32" => "gc_money_interest_32",;
                                             "48" => "gc_money_interest_48" }

   ::cTitle                            := "Precios de artículos"

   ::cName                             := "articulos_precios"

   ::getBrowseView():setEvent( 'created', {|| ::getBrowseView():setLDblClick( {|| nil } ) } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS ArticulosPreciosController
   
   if !empty(::oModel)
      ::oModel:End()
   end if 

   if !empty(::oDialogView)
      ::oDialogView:End()
   end if 

   if !empty( ::oBrowseView )
      ::oBrowseView:End()
   end if 

   if !empty(::oValidator)
      ::oValidator:End()
   end if 

   if !empty(::oRepository)
      ::oRepository:End()
   end if 

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//

METHOD setPrecioBase( uuidArticulo, uuidPrecio, nPrecioBase ) CLASS ArticulosPreciosController

   ::getRepository():callUpdatePrecioBaseWhereUuid( uuidPrecio, nPrecioBase )

   ::getRepository():callUpdatePreciosWhereUuidArticulo( uuidArticulo )

   ::getRowSet():Refresh()

   ::getBrowseView():Refresh() 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD setPrecioIVAIncluido( uuidArticulo, uuidPrecio, nPrecioIVAIncluido ) CLASS ArticulosPreciosController

   ::getRepository():callUpdatePrecioIvaIncluidoWhereUuid( uuidPrecio, nPrecioIVAIncluido )

   ::getRepository():callUpdatePreciosWhereUuidArticulo( uuidArticulo )

   ::getRowSet():Refresh()

   ::getBrowseView():Refresh() 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD setManual( uuidArticulo, uuidPrecio, lManual ) CLASS ArticulosPreciosController

   ::getModel():updateFieldWhereUuid( uuidPrecio, "manual", lManual )

   ::getRepository():callUpdatePreciosWhereUuidArticulo( uuidArticulo )

   ::getRowSet():Refresh()

   ::getBrowseView():Refresh() 

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosPreciosValidator FROM SQLBaseValidator

   METHOD getValidators()

END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS ArticulosPreciosValidator

   ::hValidators  := {  "margen" =>    {  "Positive"  => "El valor debe ser mayor o igual a cero" } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosPreciosTarifasController FROM ArticulosPreciosController

   METHOD getModel()                   INLINE ( if( empty( ::oModel ),        ::oModel := SQLArticulosPreciosTarifasModel():New( self ), ), ::oModel )

   METHOD getBrowseView()              INLINE ( if( empty( ::oBrowseView ),   ::oBrowseView := ArticulosPreciosTarifasBrowseView():New( self ), ), ::oBrowseView )
 
END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

