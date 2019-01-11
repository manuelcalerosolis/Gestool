#include "FiveWin.Ch"
#include "Factu.Ch"
#include "Xbrowse.Ch"

//------------------------------------------------------------------------//

CLASS OperacionesComercialesLineasBrowseView FROM OperacionesLineasBrowseView

   DATA oColumnCodigoAlmacen

   DATA oColumnCodigoAgente

   METHOD addColumns()

   METHOD activateUbicacionesSelectorView()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS OperacionesComercialesLineasBrowseView

   ::getColumnIdAndUuid()

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'parent_uuid'
      :cHeader             := 'Parent Uuid'
      :nWidth              := 240
      :bEditValue          := {|| ::getRowSet():fieldGet( 'parent_uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oColumnCodigoArticulo := ::oBrowse:AddCol() )
      :cSortOrder          := 'articulo_codigo'
      :cHeader             := 'Código artículo'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'articulo_codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nEditType           := ::getEditButton()
      :bEditValid          := {|oGet, oCol| ::getController():validArticuloCodigo( oGet, oCol ) }
      :bEditBlock          := {|| ::getSuperController():getArticulosController():ActivateSelectorView() }
      :nBtnBmp             := 1
      :bOnPostEdit         := {|oCol, uNewValue, nKey| ::getController():postValidateArticuloCodigo( oCol, uNewValue, nKey ) }
      :AddResource( "Lupa" )
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'articulo_nombre'
      :cHeader             := 'Nombre artículo'
      :nWidth              := 180
      :bEditValue          := {|| ::getRowSet():fieldGet( 'articulo_nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nEditType           := ::getEditGet()
      :bOnPostEdit         := {|oCol, uNewValue, nKey| ::getController():validColumnNombreArticulo( oCol, uNewValue, nKey ) }
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
      :nEditType           := ::getEditGet()
      :bOnPostEdit         := {|oCol, uNewValue, nKey| ::getController():updateField( 'fecha_caducidad', uNewValue ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'lote'
      :cHeader             := 'Lote'
      :lHide               := .t.      
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'lote' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nEditType           := ::getEditGet()
      :bOnPostEdit         := {| oCol, uNewValue, nKey | ::getController():updateField( 'lote', uNewValue ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'articulo_unidades'
      :cHeader             := 'Unidades'
      :nWidth              := 80
      :cEditPicture        := "@E 999,999.999999"
      :bEditValue          := {|| ::getRowSet():fieldGet( 'articulo_unidades' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nFootStyle          := :nDataStrAlign               
      :nFooterType         := AGGR_SUM
      :cFooterPicture      := :cEditPicture
      :oFooterFont         := oFontBold()
      :cDataType           := "N"
      :nEditType           := ::getEditGet()
      :bOnPostEdit         := {| oCol, uNewValue, nKey | ::getController():updateArticuloUnidades( oCol, uNewValue ) }
   end with

   with object ( ::oColumnUnidadMedicion := ::oBrowse:AddCol() )
      :cSortOrder          := 'unidad_medicion_codigo'
      :cHeader             := 'Unidad'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'unidad_medicion_codigo' ) }
      :nEditType           := ::getEditListBox()
      :aEditListTxt        := {}
      :bEditWhen           := {|| ::getController():loadUnidadesMedicion() }
      :cEditPicture        := "@! NNNNNNNNNNNNNNNNNNNN"
      :bEditValid          := {|uNewValue| ::getController():lValidUnidadMedicion( uNewValue ) }
      :bOnPostEdit         := {|oCol, uNewValue| ::getController():postValidateUnidadMedicion( oCol, uNewValue ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'unidad_medicion_factor'
      :cHeader             := 'Factor'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'unidad_medicion_factor' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :cEditPicture        := "@E 99,999,999.999999"
      :cDataType           := "N"
      :lHide               := .t.
      :nEditType           := ::getEditGet()
      :bOnPostEdit         := {|oCol, uNewValue, nKey| ::getController():updateArticuloFactor( oCol, uNewValue ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'total_unidades'
      :cHeader             := 'Total unidades'
      :nWidth              := 120
      :bEditValue          := {|| ::getRowSet():fieldGet( 'total_unidades' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :cEditPicture        := "@E 99,999,999.999999"
      :nFootStyle          := :nDataStrAlign               
      :nFooterType         := AGGR_SUM
      :cFooterPicture      := :cEditPicture
      :oFooterFont         := oFontBold()
      :cDataType           := "N"
      :lHide               := .t.
   end with

   with object ( ::oColumnArticuloPrecio := ::oBrowse:AddCol() )
      :cSortOrder          := 'articulo_precio'
      :cHeader             := 'Precio'
      :nWidth              := 80
      :cEditPicture        := "@E 99,999,999.999999"
      :bEditValue          := {|| ::getRowSet():fieldGet( 'articulo_precio' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nFootStyle          := :nDataStrAlign               
      :cDataType           := "N"
      :nEditType           := ::getEditGet()
      :bOnPostEdit         := {|oCol, uNewValue| ::getController():updateArticuloPrecio( uNewValue ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'incremento_precio'
      :cHeader             := 'Incremento'
      :nWidth              := 80
      :cEditPicture        := "@E 99,999,999.999999"
      :bEditValue          := {|| ::getRowSet():fieldGet( 'incremento_precio' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nFootStyle          := :nDataStrAlign               
      :cFooterPicture      := :cEditPicture
      :oFooterFont         := oFontBold()
      :cDataType           := "N"
      :nEditType           := ::getEditGet()
      :bOnPostEdit         := {| oCol, uNewValue | ::getController():updateArticuloIncrementoPrecio( uNewValue ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'total_bruto'
      :cHeader             := 'Total bruto'
      :nWidth              := 80
      :cEditPicture        := "@E 99,999,999.999999"
      :bEditValue          := {|| ::getRowSet():fieldGet( 'total_bruto' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nFootStyle          := :nDataStrAlign               
      :nFooterType         := AGGR_SUM
      :cFooterPicture      := :cEditPicture
      :oFooterFont         := oFontBold()
      :cDataType           := "N"
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'descuento'
      :cHeader             := '% Descuento'
      :nWidth              := 80
      :cEditPicture        := "@E 999.9999"
      :bEditValue          := {|| ::getRowSet():fieldGet( 'descuento' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :cDataType           := "N"
      :nEditType           := ::getEditGet()
      :bEditValid          := {| oGet | ::getController():validateDescuento( oGet ) }
      :bOnPostEdit         := {| oCol, uNewValue | ::getController():updateDescuento( uNewValue ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'iva'
      :cHeader             := '% IVA'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'iva' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :cEditPicture        := "@E 999.9999"
      :cDataType           := "N"
      :nEditType           := ::getEditGet()
      :bEditValid          := {| oGet | ::getController():validateIva( oGet ) }
      :bOnPostEdit         := {| oCol, uNewValue | ::getController():updateImpuestos( uNewValue ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'recargo_equivalencia'
      :cHeader             := '% R.E.'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'recargo_equivalencia' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :cEditPicture        := "@E 999.9999"
      :cDataType           := "N"
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'total_precio'
      :cHeader             := 'Total precio'
      :nWidth              := 80
      :cEditPicture        := "@E 99,999,999.999999"
      :bEditValue          := {|| ::getRowSet():fieldGet( 'total_precio' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nFootStyle          := :nDataStrAlign               
      :nFooterType         := AGGR_SUM
      :cFooterPicture      := :cEditPicture
      :oFooterFont         := oFontBold()
      :cDataType           := "N"
   end with

   with object ( ::oColumnPropiedades := ::oBrowse:AddCol() )
      :cHeader             := 'Propiedades'
      :nWidth              := 180
      :bEditValue          := {|| ::getRowSet():fieldGet( 'articulos_propiedades_nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nEditType           := ::getEditButton()
      :bEditValid          := {|| .t. }
      :bEditBlock          := {|| ::getController():getCombinacionesController():runViewSelector( ::getRowSet():fieldGet( 'articulo_codigo' ) ) }
      :nBtnBmp             := 1
      :AddResource( "Lupa" )
      :bOnPostEdit         := {|oCol, uNewValue | ::getController():postValidateCombinacionesUuid( oCol, uNewValue ) }
   end with

   with object ( ::oColumnCodigoAlmacen := ::oBrowse:AddCol() )
      :cSortOrder          := 'almacen_codigo'
      :cHeader             := 'Código almacén'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'almacen_codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nEditType           := EDIT_GET_BUTTON
      :bEditValid          := {|oGet, oCol| ::getController():validAlmacenCodigo( oGet, oCol ) }
      :bEditBlock          := {|| ::getController():oController:getAlmacenesController():ActivateSelectorView() }
      :nBtnBmp             := 1
      :AddResource( "Lupa" )
      :bOnPostEdit         := {|oCol, uNewValue, nKey| ::getController():postValidateAlmacenCodigo( oCol, uNewValue, nKey ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'almacen_nombre'
      :cHeader             := 'Nombre almacén'
      :nWidth              := 180
      :bEditValue          := {|| ::getRowSet():fieldGet( 'almacen_nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   if Company():getDefaultUsarUbicaciones()

   with object ( ::oColumnCodigoUbicacion := ::oBrowse:AddCol() )
      :cSortOrder          := 'ubicacion_codigo'
      :cHeader             := 'Código ubicación'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'ubicacion_codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nEditType           := EDIT_GET_BUTTON
      :bEditValid          := {|oGet, oCol| ::getController():validUbicacionCodigo( oGet, oCol ) }
      :bEditBlock          := {|| ::activateUbicacionesSelectorView() }
      :nBtnBmp             := 1
      :AddResource( "Lupa" )
      :bOnPostEdit         := {|oCol, uNewValue, nKey| ::getController():postValidateUbicacionCodigo( oCol, uNewValue, nKey ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'ubicacion_nombre'
      :cHeader             := 'Nombre ubicación'
      :nWidth              := 180
      :bEditValue          := {|| ::getRowSet():fieldGet( 'ubicacion_nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   end if 

   with object ( ::oColumnCodigoAgente := ::oBrowse:AddCol() )
      :cSortOrder          := 'agente_codigo'
      :cHeader             := 'Código agente'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'agente_codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nEditType           := ::getEditButton()
      :bEditValid          := {|oGet, oCol| ::getController():validAgenteCodigo( oGet, oCol ) }
      :bEditBlock          := {|| ::getController():oController:getAgentesController():ActivateSelectorView() }
      :nBtnBmp             := 1
      :AddResource( "Lupa" )
      :bOnPostEdit         := {|oCol, uNewValue, nKey| ::getController():postValidateAgenteCodigo( oCol, uNewValue, nKey ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'agente_nombre'
      :cHeader             := 'Nombre agente'
      :nWidth              := 180
      :bEditValue          := {|| ::getRowSet():fieldGet( 'agente_nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'agente_comision'
      :cHeader             := '% Comisión agente'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'agente_comision' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :cEditPicture        := "@E 999.99"
      :nEditType           := ::getEditGet()
      :bOnPostEdit         := {| oCol, uNewValue | ::getController():updateAgenteComision( uNewValue ) }
   end with

   ::getColumnDeletedAt()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD activateUbicacionesSelectorView() CLASS OperacionesComercialesLineasBrowseView

   local hUbicacion
   local uuidAlmacen
   local cCodigoAlmacen

   cCodigoAlmacen          := ::getRowSet():fieldGet( 'almacen_codigo' )

   if empty( cCodigoAlmacen )
      msgStop( "El código de almacén no puede estar vacio" )
      RETURN ( nil )
   end if 

   uuidAlmacen             := SQLAlmacenesModel():getUuidWhereCodigo( cCodigoAlmacen )
   if empty( uuidAlmacen )
      msgStop( "No se ha podido obtener el identificador de almacén" )
      RETURN ( nil )
   end if 

   ::getSuperController():getUbicacionesController():setControllerParentUuid( uuidAlmacen )

   hUbicacion              := ::getSuperController():getUbicacionesController():ActivateSelectorView()

RETURN ( hUbicacion )

//---------------------------------------------------------------------------//
