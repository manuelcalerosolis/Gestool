#include "FiveWin.Ch"
#include "Factu.Ch"
#include "Xbrowse.Ch"

//------------------------------------------------------------------------//

CLASS ConsolidacionAlmacenLineasBrowseView FROM SQLBrowseView

   DATA lFastEdit                      INIT .t.

   DATA lFooter                        INIT .t.

   DATA nMarqueeStyle                  INIT 3

   DATA nColSel                        INIT 2

   DATA oColumnCodigoArticulo

   DATA oColumnUnidadMedicion

   DATA oColumnCodigoAlmacen

   DATA oColumnCodigoAgente

   DATA oColumnPropiedades

   DATA oColumnArticuloPrecio

   DATA oColumnCodigoUbicacion

   METHOD Create( oWindow )

   METHOD addColumns()

   METHOD setOnCancelEdit()

   METHOD keyChar( nKey )

   METHOD getEditButton()              INLINE ( if( ::getSuperController():isNotZoomMode(), EDIT_GET_BUTTON, 0 ) )
   
   METHOD getEditGet()                 INLINE ( if( ::getSuperController():isNotZoomMode(), EDIT_GET, 0 ) )

   METHOD getEditListBox()             INLINE ( if( ::getSuperController():isNotZoomMode(), EDIT_GET_LISTBOX, 0 ) )

   METHOD setFocusColumnCodigoArticulo() ;
                                       INLINE ( ::oBrowse:setFocus(), ::oBrowse:goToCol( ::oColumnCodigoArticulo ) )

   METHOD setFocusColumnCodigoAlmacen() ;
                                       INLINE ( ::oBrowse:setFocus(), ::oBrowse:goToCol( ::oColumnCodigoAlmacen ) )

   METHOD setFocusColumnCodigoUbicacion() ;
                                       INLINE ( ::oBrowse:setFocus(), ::oBrowse:goToCol( ::oColumnCodigoUbicacion ) )

   METHOD setFocusColumnPropiedades()  INLINE ( ::oBrowse:setFocus(), ::oBrowse:goToCol( ::oColumnPropiedades ) )

   METHOD activateUbicacionesSelectorView()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD Create( oWindow ) CLASS ConsolidacionAlmacenLineasBrowseView 

   ::Super:Create( oWindow )

   ::oBrowse:bOnSkip       := {|| ::getController():validLine() }

   ::oBrowse:bKeyChar      := {| nKey | ::keyChar( nKey ) }

   ::oBrowse:setChange( {|| ::getController():getHistoryManager():Set( ::getRowSet():getValuesAsHash() ) } )

   ::oBrowse:setGotFocus( {|| ::getController():getHistoryManager():Set( ::getRowSet():getValuesAsHash() ) } )

RETURN ( ::oBrowse )

//---------------------------------------------------------------------------//

METHOD setOnCancelEdit() CLASS ConsolidacionAlmacenLineasBrowseView

RETURN ( ::getController():validLine() )   

//---------------------------------------------------------------------------//

METHOD keyChar( nKey ) CLASS ConsolidacionAlmacenLineasBrowseView

   if nkey != VK_EXECUTE
      RETURN ( nil )
   end if 

   if !empty( ::oBrowse:SelectedCol() ) .and. !empty( ::oBrowse:SelectedCol():bEditBlock )
      eval( ::oBrowse:SelectedCol():bEditBlock )
   end if 

RETURN ( nil )   

//---------------------------------------------------------------------------//

METHOD addColumns() CLASS ConsolidacionAlmacenLineasBrowseView

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

   ::getColumnDeletedAt()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD activateUbicacionesSelectorView() CLASS ConsolidacionAlmacenLineasBrowseView

   local hUbicacion
   local uuidAlmacen
   local cCodigoAlmacen

   cCodigoAlmacen          := ::getSuperController():getModelBuffer( 'almacen_codigo' )

   if empty( cCodigoAlmacen )
      ::getController():getDialogView():showMessage( "El código de almacén no puede estar vacio" )
      RETURN ( nil )
   end if 

   uuidAlmacen             := SQLAlmacenesModel():getUuidWhereCodigo( cCodigoAlmacen )
   if empty( uuidAlmacen )
      ::getController():getDialogView():showMessage( "No se ha podido obtener el identificador de almacén" )
      RETURN ( nil )
   end if 

   ::getSuperController():getUbicacionesController():setControllerParentUuid( uuidAlmacen )

   hUbicacion              := ::getSuperController():getUbicacionesController():ActivateSelectorView()

RETURN ( hUbicacion )

//---------------------------------------------------------------------------//
