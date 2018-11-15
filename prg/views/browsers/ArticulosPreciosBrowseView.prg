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
      :cSortOrder          := 'id'
      :cHeader             := 'Id'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'id' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'uuid'
      :cHeader             := 'Uuid'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'articulo_uuid'
      :cHeader             := 'Articulo Uuid'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'articulo_uuid' ) }
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
      :cSortOrder          := 'margen'
      :cHeader             := 'Margen %'
      :nWidth              := 75
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nDataStrAlign       := 1
      :nHeadStrAlign       := 1
      :bEditValue          := {|| ::getRowSet():fieldGet( 'margen' ) }
      :bEditBlock          := {|| ::getRowSet():fieldGet( 'margen' ) }
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
      :cSortOrder          := 'articulos_tarifas_base_nombre'
      :cHeader             := 'Sobre tarifa'
      :nWidth              := 120
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :bEditValue          := {|| ::getRowSet():fieldGet( 'articulos_tarifas_base_nombre' ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'precio_base'
      :cHeader             := 'Precio'
      :nWidth              := 100
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nHeadBmpNo          := 1
      :nDataStrAlign       := 1
      :nHeadStrAlign       := 1
      :addResource( "gc_pencil_16" )
      :nEditType           := 1
      :bEditValue          := {|| ::getRowSet():fieldGet( 'precio_base' ) }
      :bEditBlock          := {|| ::getRowSet():fieldGet( 'precio_base' ) }
      :cEditPicture        := "@E 9999.9999"
      :bOnPostEdit         := {|oCol, nPrecioBase| ::oController:setPrecioBase( oCol, nPrecioBase ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'precio_iva_incluido'
      :cHeader             := 'Precio IVA inc.'
      :nWidth              := 100
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nHeadBmpNo          := 1
      :nDataStrAlign       := 1
      :nHeadStrAlign       := 1
      :AddResource( "gc_pencil_16" )

      :nEditType           := 1
      :bEditValue          := {|| ::getRowSet():fieldGet( 'precio_iva_incluido' ) }
      :bEditBlock          := {|| ::getRowSet():fieldGet( 'precio_iva_incluido' ) }
      :cEditPicture        := "@E 9999.9999"
      :bOnPostEdit         := {|oCol, nPrecioIVAIncluido| ::oController:setPrecioIVAIncluido( oCol, nPrecioIVAIncluido ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'manual'
      :cHeader             := "Manual"
      :bStrData            := {|| "" }
      :bEditValue          := {|| ::getRowSet():fieldGet( 'manual' ) }
      :nWidth              := 60
      :SetCheck( { "Sel16", "Nil16" }, {|oCol, lManual| ::oController:setManual( oCol, lManual ) } )
   end with

   with object ( ::oBrowse:AddCol() )
      :nEditType           := 1
      :cHeader             := "% Dto."
      :bStrData            := {|| "" }
      :nWidth              := 20
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
      :cSortOrder          := 'articulos_codigo'
      :cHeader             := 'Código'
      :nWidth              := 120
      :bEditValue          := {|| ::getRowSet():fieldGet( 'articulos_codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'articulos_nombre'
      :cHeader             := 'Artículo'
      :nWidth              := 280
      :bEditValue          := {|| ::getRowSet():fieldGet( 'articulos_nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

RETURN ( nil )

//---------------------------------------------------------------------------//
