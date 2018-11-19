#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ArticulosPreciosBrowseView FROM SQLBrowseView

   DATA lFastEdit          INIT .t.

   DATA lMultiSelect       INIT .f.

   DATA nMarqueeStyle      INIT 3

   DATA cName              INIT "articulos_precios"

   METHOD addColumns()         

   METHOD addSpecialColumns()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD addSpecialColumns() CLASS ArticulosPreciosBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'articulos_tarifas_nombre'
      :cHeader             := 'Tarifa'
      :nWidth              := 120
      :bEditValue          := {|| ::getRowSet():fieldGet( 'articulos_tarifas_nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD addColumns() CLASS ArticulosPreciosBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'articulos_precios.id'
      :cHeader             := 'Id'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'articulos_precios_id' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'articulos_precios.uuid'
      :cHeader             := 'Uuid'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'articulos_precios_uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'articulos_precios.articulo_uuid'
      :cHeader             := 'Articulo Uuid'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'articulos_precios_articulo_uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   ::addSpecialColumns()

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Costo'
      :nWidth              := 80
      :bEditValue          := {|| ::oController:oController:getPrecioCosto() }
      :cEditPicture        := "@E 9999.9999"
      :nDataStrAlign       := 1
      :nHeadStrAlign       := 1
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'articulos_precios.margen'
      :cHeader             := 'Margen %'
      :nWidth              := 75
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nDataStrAlign       := 1
      :nHeadStrAlign       := 1
      :bEditValue          := {|| ::getRowSet():fieldGet( 'articulos_precios_margen' ) }
      :bEditBlock          := {|| ::getRowSet():fieldGet( 'articulos_precios_margen' ) }
      :cEditPicture        := "@E 9999.9999"
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'margen_real'
      :cHeader             := 'Markup %'
      :nWidth              := 75
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nDataStrAlign       := 1
      :nHeadStrAlign       := 1
      :bEditValue          := {|| ::getRowSet():fieldGet( 'margen_real' ) }
      :cEditPicture        := "@E 9999.9999"
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Sobre tarifa'
      :nWidth              := 100
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :bEditValue          := {|| ::getRowSet():fieldGet( 'articulos_tarifas_base_nombre' ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'articulos_precios.precio_base'
      :cHeader             := 'Precio'
      :nWidth              := 100
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nHeadBmpNo          := 1
      :nDataStrAlign       := 1
      :nHeadStrAlign       := 1
      :addResource( "gc_pencil_16" )
      :nEditType           := 1
      :bEditValue          := {|| ::getRowSet():fieldGet( 'articulos_precios_precio_base' ) }
      :bEditBlock          := {|| ::getRowSet():fieldGet( 'articulos_precios_precio_base' ) }
      :cEditPicture        := "@E 9999.9999"
      :bOnPostEdit         := {|oCol, nPrecioBase| ::oController:setPrecioBase( ::getRowSet():fieldGet( 'articulos_precios_articulo_uuid' ), ::getRowSet():fieldGet( 'articulos_precios_uuid' ), nPrecioBase ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'articulos_precios.precio_iva_incluido'
      :cHeader             := 'Precio IVA inc.'
      :nWidth              := 100
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nHeadBmpNo          := 1
      :nDataStrAlign       := 1
      :nHeadStrAlign       := 1
      :AddResource( "gc_pencil_16" )

      :nEditType           := 1
      :bEditValue          := {|| ::getRowSet():fieldGet( 'articulos_precios_precio_iva_incluido' ) }
      :bEditBlock          := {|| ::getRowSet():fieldGet( 'articulos_precios_precio_iva_incluido' ) }
      :cEditPicture        := "@E 9999.9999"
      :bOnPostEdit         := {|oCol, nPrecioIVAIncluido| ::oController:setPrecioIVAIncluido( ::getRowSet():fieldGet( 'articulos_precios_articulo_uuid' ), ::getRowSet():fieldGet( 'articulos_precios_uuid' ), nPrecioIVAIncluido ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'articulos_precios.manual'
      :cHeader             := "Manual"
      :bStrData            := {|| "" }
      :bEditValue          := {|| ::getRowSet():fieldGet( 'articulos_precios_manual' ) }
      :nWidth              := 60
      :SetCheck( { "Sel16", "Nil16" }, {|oCol, lManual| ::oController:setManual( ::getRowSet():fieldGet( 'articulos_precios_articulo_uuid' ), ::getRowSet():fieldGet( 'articulos_precios_uuid' ), lManual ) } )
   end with

   with object ( ::oBrowse:AddCol() )
      :nEditType           := 1
      :cHeader             := "% Dto."
      :bStrData            := {|| "" }
      :nWidth              := 30
      :AddResource( "gc_more2_16" )
      :bBmpData            := {|| 1 }
      :bLDClickData        := {|| ::oController:getArticulosPreciosDescuentosController():activateDialogView() }
   end with

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosPreciosTarifasBrowseView FROM ArticulosPreciosBrowseView 

   DATA cName              INIT "articulos_precios_tarifas"

   METHOD addSpecialColumns()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD addSpecialColumns() CLASS ArticulosPreciosTarifasBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'articulos.codigo'
      :cHeader             := 'Código'
      :nWidth              := 120
      :bEditValue          := {|| ::getRowSet():fieldGet( 'articulos_codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'articulos.nombre'
      :cHeader             := 'Artículo'
      :nWidth              := 280
      :bEditValue          := {|| ::getRowSet():fieldGet( 'articulos_nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

RETURN ( nil )

//---------------------------------------------------------------------------//
