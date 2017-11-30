#include "FiveWin.Ch"
#include "Factu.Ch"

//------------------------------------------------------------------------//

CLASS MovimientosAlmacenLineasBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns()

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'id'
      :cHeader             := 'Id'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'id' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'uuid'
      :cHeader             := 'Uuid'
      :nWidth              := 240
      :bEditValue          := {|| ::getRowSet():fieldGet( 'uuid' ) }
      :lHide               := .t.
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'parent_uuid'
      :cHeader             := 'Parent Uuid'
      :nWidth              := 240
      :bEditValue          := {|| ::getRowSet():fieldGet( 'uuid' ) }
      :lHide               := .t.
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'codigo_articulo'
      :cHeader             := 'Código artículo'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'codigo_articulo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'nombre_articulo'
      :cHeader             := 'Nombre artículo'
      :nWidth              := 180
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre_articulo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'codigo_primera_propiedad'
      :cHeader             := 'Código primera propiedad artículo'
      :nWidth              := 80
      :lHide               := .t.
      :bEditValue          := {|| ::getRowSet():fieldGet( 'codigo_primera_propiedad' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'valor_primera_propiedad'
      :cHeader             := 'Valor primera propiedad artículo'
      :nWidth              := 80
      :lHide               := .t.
      :bEditValue          := {|| ::getRowSet():fieldGet( 'valor_primera_propiedad' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'codigo_segunda_propiedad'
      :cHeader             := 'Código segunda propiedad artículo'
      :nWidth              := 80
      :lHide               := .t.
      :bEditValue          := {|| ::getRowSet():fieldGet( 'codigo_segunda_propiedad' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'valor_segunda_propiedad'
      :cHeader             := 'Valor segunda propiedad artículo'
      :nWidth              := 80
      :lHide               := .t.
      :bEditValue          := {|| ::getRowSet():fieldGet( 'valor_segunda_propiedad' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'fecha_caducidad'
      :cHeader             := 'Fecha caducidad'
      :nWidth              := 74
      :lHide               := .t.
      :nHeadStrAlign       := AL_LEFT
      :nDataStrAlign       := AL_LEFT
      :bEditValue          := {|| ::getRowSet():fieldGet( 'fecha_caducidad' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'lote'
      :cHeader             := 'Lote'
      :lHide               := .t.      
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'lote' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'bultos_articulo'
      :cHeader             := 'Bultos'
      :lHide               := !( uFieldEmpresa( "lUseBultos" ) )
      :nWidth              := 80
      :cEditPicture        := masUnd()
      :bEditValue          := {|| ::getRowSet():fieldGet( 'bultos_articulo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'cajas_articulo'
      :cHeader             := 'Cajas'
      :lHide               := !( uFieldEmpresa( "lUseCaj" ) )
      :nWidth              := 80
      :cEditPicture        := masUnd()
      :bEditValue          := {|| ::getRowSet():fieldGet( 'cajas_articulo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nFootStyle          := :nDataStrAlign               
      :nFooterType         := AGGR_SUM
      :cFooterPicture      := :cEditPicture
      :oFooterFont         := getBoldFont()
      :cDataType           := "N"
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'unidades_articulo'
      :cHeader             := 'Unidades'
      :nWidth              := 80
      :cEditPicture        := masUnd()
      :bEditValue          := {|| ::getRowSet():fieldGet( 'unidades_articulo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nFootStyle          := :nDataStrAlign               
      :nFooterType         := AGGR_SUM
      :cFooterPicture      := :cEditPicture
      :oFooterFont         := getBoldFont()
      :cDataType           := "N"
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'total_unidades'
      :cHeader             := 'Total unidades'
      :lHide               := !( uFieldEmpresa( "lUseBultos" ) .and. uFieldEmpresa( "lUseCaj" ) )
      :nWidth              := 80
      :cEditPicture        := masUnd()
      :bEditValue          := {|| ::getRowSet():fieldGet( 'total_unidades' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nFootStyle          := :nDataStrAlign               
      :nFooterType         := AGGR_SUM
      :cFooterPicture      := :cEditPicture
      :oFooterFont         := getBoldFont()
      :cDataType           := "N"
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'precio_articulo'
      :cHeader             := 'Precio costo'
      :nWidth              := 80
      :cEditPicture        := cPinDiv()
      :bEditValue          := {|| ::getRowSet():fieldGet( 'precio_articulo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'total_precio'
      :cHeader             := 'Total costo'
      :nWidth              := 100
      :cEditPicture        := cPinDiv()
      :bEditValue          := {|| ::getRowSet():fieldGet( 'total_precio' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nFootStyle          := :nDataStrAlign               
      :nFooterType         := AGGR_SUM
      :cFooterPicture      := :cEditPicture
      :oFooterFont         := getBoldFont()
      :cDataType           := "N"
   end with

RETURN ( self )

//---------------------------------------------------------------------------//

