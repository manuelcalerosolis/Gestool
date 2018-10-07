#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ArticulosPreciosController FROM SQLBrowseController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD setPrecioBase( oCol, nPrecioBase )
   
   METHOD setPrecioIVAIncluido( oCol, nPrecioIVAIncluido )

   METHOD setManual( oCol, lManual )

   METHOD UpdatePreciosAndRefresh() 

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

   ::lTransactional                          := .t.

   ::hImage                                  := {  "16" => "gc_money_interest_16",;
                                                   "32" => "gc_money_interest_32",;
                                                   "48" => "gc_money_interest_48" }

   ::cTitle                                  := "Precios de artículos"

   ::cName                                   := "articulos_precios"

   ::getModel()

   ::getBrowseView():setEvent( 'created',    {|| ::getBrowseView():setLDblClick( {|| nil } ) } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS ArticulosPreciosController

   ::oModel:End()

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

   ::Super:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD UpdatePreciosAndRefresh() 

   ::getRepository():callUpdatePreciosWhereUuidArticulo( ::getRowSet():fieldGet( 'articulo_uuid' ) )

   ::getRowSet():Refresh()

   ::getBrowseView():Refresh() 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD setPrecioBase( oCol, nPrecioBase ) CLASS ArticulosPreciosController

   ::getRepository():callUpdatePrecioBaseWhereUuid( ::getRowSet():fieldGet( 'uuid' ), nPrecioBase )

RETURN ( ::UpdatePreciosAndRefresh() )

//---------------------------------------------------------------------------//

METHOD setPrecioIVAIncluido( oCol, nPrecioIVAIncluido ) CLASS ArticulosPreciosController

   ::getRepository():callUpdatePrecioIvaIncluidoWhereUuid( ::getRowSet():fieldGet( 'uuid' ), nPrecioIVAIncluido )

RETURN ( ::UpdatePreciosAndRefresh() )

//---------------------------------------------------------------------------//

METHOD setManual( oCol, lManual ) CLASS ArticulosPreciosController

   ::oModel:updateFieldWhereUuid( ::getRowSet():fieldGet( 'uuid' ), "manual", lManual )

RETURN ( ::UpdatePreciosAndRefresh() )

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

   METHOD getModel()          INLINE ( if( empty( ::oModel ),        ::oModel := SQLArticulosPreciosTarifasModel():New( self ), ), ::oModel )

   METHOD getBrowseView()     INLINE ( if( empty( ::oBrowseView ),   ::oBrowseView := ArticulosPreciosTarifasBrowseView():New( self ), ), ::oBrowseView )
 
END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

