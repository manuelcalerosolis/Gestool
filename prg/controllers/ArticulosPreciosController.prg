#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ArticulosPreciosController FROM SQLBrowseController

   DATA oArticulosPreciosDescuentosController

   METHOD New()

   METHOD End()

   METHOD setPrecioBase( oCol, nPrecioBase )
   
   METHOD setPrecioIVAIncluido( oCol, nPrecioIVAIncluido )

   METHOD setManual( oCol, lManual )

   METHOD UpdatePreciosAndRefresh() 

   METHOD getArticulosPreciosModel()   INLINE ( ::oModel := SQLArticulosPreciosModel():New( self ) )

   METHOD getBrowseView()              INLINE ( ::oBrowseView := ArticulosPreciosBrowseView():New( self ) )

   METHOD getUuid()                    INLINE ( iif(  !empty( ::getRowSet() ),;
                                                      ::getRowSet():fieldGet( 'uuid' ),;
                                                      nil ) )

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

   ::getArticulosPreciosModel()

   ::oDialogView                             := ArticulosPreciosView():New( self )

   ::oValidator                              := ArticulosPreciosValidator():New( self )

   ::oRepository                             := ArticulosPreciosRepository():New( self )

   ::getBrowseView()

   ::oArticulosPreciosDescuentosController   := ArticulosPreciosDescuentosController():New( self )

   ::oBrowseView:setEvent( 'created',        {|| ::oBrowseView:setLDblClick( {|| nil } ) } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS ArticulosPreciosController

   ::oModel:End()

   ::oDialogView:End()

   ::oBrowseView:End()

   ::oValidator:End()

   ::oRepository:End()

   ::oArticulosPreciosDescuentosController:End()

   ::oModel                                  := nil

   ::oDialogView                             := nil

   ::oBrowseView                             := nil

   ::oValidator                              := nil

   ::oRepository                             := nil

   ::oArticulosPreciosDescuentosController   := nil

   ::Super:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD UpdatePreciosAndRefresh() 

   ::oRepository:callUpdatePreciosWhereUuidArticulo( ::getRowSet():fieldGet( 'articulo_uuid' ) )

   ::getRowSet():Refresh()

   ::getBrowseView():Refresh() 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD setPrecioBase( oCol, nPrecioBase ) CLASS ArticulosPreciosController

   ::oRepository:callUpdatePrecioBaseWhereUuid( ::getRowSet():fieldGet( 'uuid' ), nPrecioBase )

RETURN ( ::UpdatePreciosAndRefresh() )

//---------------------------------------------------------------------------//

METHOD setPrecioIVAIncluido( oCol, nPrecioIVAIncluido ) CLASS ArticulosPreciosController

   ::oRepository:callUpdatePrecioIvaIncluidoWhereUuid( ::getRowSet():fieldGet( 'uuid' ), nPrecioIVAIncluido )

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

CLASS ArticulosPreciosTarifasController FROM ArticulosPreciosController

   METHOD getArticulosPreciosModel()   INLINE ( ::oModel := SQLArticulosPreciosTarifasModel():New( self ) )

   METHOD getBrowseView()              INLINE ( ::oBrowseView := ArticulosPreciosTarifasBrowseView():New( self ) )
 
END CLASS

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

