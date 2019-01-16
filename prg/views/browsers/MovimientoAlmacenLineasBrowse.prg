#include "FiveWin.Ch"
#include "Factu.Ch"
#include "Xbrowse.Ch"

//------------------------------------------------------------------------//

CLASS MovimientoAlmacenLineasBrowseView FROM OperacionesLineasBrowseView

   METHOD addColumns()

   METHOD activateUbicacionesOrigenSelectorView() ;
                                       INLINE ( ::activateUbicacionesSelectorView( 'almacen_origen_codigo' ) )

   METHOD activateUbicacionesDestinoSelectorView() ;
                                       INLINE ( ::activateUbicacionesSelectorView( 'almacen_destino_codigo' ) )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS MovimientoAlmacenLineasBrowseView

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

   if Company():getDefaultUsarUbicaciones()

   with object ( ::oColumnCodigoUbicacion := ::oBrowse:AddCol() )
      :cSortOrder          := 'ubicacion_origen_codigo'
      :cHeader             := 'Ubicación origen'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'ubicacion_origen_codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nEditType           := EDIT_GET_BUTTON
      :bEditValid          := {|oGet, oCol| ::getController():validUbicacionCodigo( oGet, oCol ) }
      :bEditBlock          := {|| ::activateUbicacionesOrigenSelectorView() }
      :nBtnBmp             := 1
      :AddResource( "Lupa" )
      :bOnPostEdit         := {|oCol, uNewValue, nKey| ::getController():postValidateUbicacionOrigenCodigo( oCol, uNewValue, nKey ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'ubicacion_origen_nombre'
      :cHeader             := 'Nombre ubicación origen'
      :nWidth              := 180
      :bEditValue          := {|| ::getRowSet():fieldGet( 'ubicacion_origen_nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oColumnCodigoUbicacion := ::oBrowse:AddCol() )
      :cSortOrder          := 'ubicacion_destino_codigo'
      :cHeader             := 'Ubicación destino'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'ubicacion_destino_codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nEditType           := EDIT_GET_BUTTON
      :bEditValid          := {|oGet, oCol| ::getController():validUbicacionCodigo( oGet, oCol ) }
      :bEditBlock          := {|| ::activateUbicacionesDestinoSelectorView() }
      :nBtnBmp             := 1
      :AddResource( "Lupa" )
      :bOnPostEdit         := {|oCol, uNewValue, nKey| ::getController():postValidateUbicacionDestinoCodigo( oCol, uNewValue, nKey ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'ubicacion_destino_nombre'
      :cHeader             := 'Nombre ubicación destino'
      :nWidth              := 180
      :bEditValue          := {|| ::getRowSet():fieldGet( 'ubicacion_destino_nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   end if 

   ::getColumnDeletedAt()

RETURN ( nil )

//---------------------------------------------------------------------------//

