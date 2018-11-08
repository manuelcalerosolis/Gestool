#include "FiveWin.Ch"
#include "Factu.Ch"
#include "Xbrowse.Ch"

//------------------------------------------------------------------------//

CLASS FacturasClientesLineasBrowseView FROM SQLBrowseView

   DATA lFastEdit          INIT .t.

   DATA lFooter            INIT .t.

   DATA nMarqueeStyle      INIT 3

   DATA nColSel            INIT 2

   DATA oColumnCodigo

   DATA oColumnUnidadMedicion

   DATA oColumnCodigoAlmacen

   DATA oColumnCodigoAgente

   METHOD Create( oWindow )

   METHOD addColumns()

   METHOD setOnCancelEdit()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD Create( oWindow ) CLASS FacturasClientesLineasBrowseView 

   ::Super:Create( oWindow )

   ::oBrowse:setChange( {|| ::oController:getHistoryManager():Set( ::getRowSet():getValuesAsHash() ) } )

   ::oBrowse:bOnSkip       := {|| ::oController:validLinea() }

   ::oBrowse:setGotFocus( {|| ::oController:getHistoryManager():Set( ::getRowSet():getValuesAsHash() ) } )

RETURN ( ::oBrowse )

//---------------------------------------------------------------------------//

METHOD setOnCancelEdit()

RETURN ( ::oController:validLinea() )   

//---------------------------------------------------------------------------//

METHOD addColumns() CLASS FacturasClientesLineasBrowseView

   ::getColumnIdAndUuid()

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'parent_uuid'
      :cHeader             := 'Parent Uuid'
      :nWidth              := 240
      :bEditValue          := {|| ::getRowSet():fieldGet( 'parent_uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oColumnCodigo := ::oBrowse:AddCol() )
      :cSortOrder          := 'articulo_codigo'
      :cHeader             := 'C�digo art�culo'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'articulo_codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nEditType           := EDIT_GET_BUTTON
      :bEditValid          := {|oGet, oCol| ::oController:validArticuloCodigo( oGet, oCol ) }
      :bOnPostEdit         := {|oCol, uNewValue, nKey| ::oController:postValidateArticuloCodigo( oCol, uNewValue, nKey ) }
      :bEditBlock          := {|| ::oController:oController:getArticulosController():ActivateSelectorView() }
      :nBtnBmp             := 1
      :AddResource( "Lupa" )
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'articulo_nombre'
      :cHeader             := 'Nombre art�culo'
      :nWidth              := 180
      :bEditValue          := {|| ::getRowSet():fieldGet( 'articulo_nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nEditType           := EDIT_GET
      :bOnPostEdit         := {|oCol, uNewValue, nKey| ::oController:validColumnNombreArticulo( oCol, uNewValue, nKey ) }
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
      :nEditType           := EDIT_GET
      :bOnPostEdit         := {|oCol, uNewValue, nKey| ::oController:updateFieldWhereId( 'fecha_caducidad', uNewValue ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'lote'
      :cHeader             := 'Lote'
      :lHide               := .t.      
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'lote' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nEditType           := EDIT_GET
      :bOnPostEdit         := {|oCol, uNewValue, nKey| ::oController:updateFieldWhereId( 'lote', uNewValue ) }
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
      :nEditType           := EDIT_GET
      :bOnPostEdit         := {|oCol, uNewValue, nKey| ::oController:stampArticuloUnidades( oCol, uNewValue ) }
   end with

   with object ( ::oColumnUnidadMedicion    := ::oBrowse:AddCol() )
      :cSortOrder          := 'unidad_medicion_codigo'
      :cHeader             := 'Unidad'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'unidad_medicion_codigo' ) }
      :nEditType           := EDIT_GET_LISTBOX
      :aEditListTxt        := {}
      :bEditWhen           := {|| ::oController:loadUnidadesMedicion() }
      :bOnPostEdit         := {|o,x| ::oController:stampArticuloUnidadMedicion( x ) }
      :cEditPicture        := "@! NNNNNNNNNNNNNNNNNNNN"
      :bEditValid          := {|uNewValue| ::oController:lValidUnidadMedicion( uNewValue ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'unidad_medicion_factor'
      :cHeader             := 'Factor'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'unidad_medicion_factor' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :cEditPicture        := "@E 999,999.999999"
      :cDataType           := "N"
      :lHide               := .t.
      :cDataType           := "N"
      :nEditType           := EDIT_GET
      :bOnPostEdit         := {|oCol, uNewValue, nKey| ::oController:stampArticuloFactor( oCol, uNewValue ) }

   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'total_unidades'
      :cHeader             := 'Total unidades'
      :nWidth              := 120
      :bEditValue          := {|| ::getRowSet():fieldGet( 'total_unidades' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :cEditPicture        := "@E 999,999.999999"
      :nFootStyle          := :nDataStrAlign               
      :nFooterType         := AGGR_SUM
      :cFooterPicture      := :cEditPicture
      :oFooterFont         := oFontBold()
      :cDataType           := "N"
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'articulo_precio'
      :cHeader             := 'Precio'
      :nWidth              := 80
      :cEditPicture        := "@E 999,999.999999"
      :bEditValue          := {|| ::getRowSet():fieldGet( 'articulo_precio' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nFootStyle          := :nDataStrAlign               
      :cDataType           := "N"
      :nEditType           := EDIT_GET
      :bOnPostEdit         := {|oCol, uNewValue, nKey| ::oController:updateField( 'articulo_precio', uNewValue ), ::oController:oController:calculateTotals() }
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
      :nEditType           := EDIT_GET
      :bOnPostEdit         := {| oCol, uNewValue | ::oController:updateField( 'incremento_precio', uNewValue ) }
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
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'iva'
      :cHeader             := '% IVA'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'iva' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :cEditPicture        := "@E 999.9999"
      :cDataType           := "N"
      :nEditType           := EDIT_GET
      :bEditValid          := {|uNewValue| ::oController:validateIva( uNewValue ) }
      :bOnPostEdit         := {| oCol, uNewValue | ::oController:updateImpuestos( uNewValue ) }
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

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Propiedades'
      :nWidth              := 180
      :bEditValue          := {|| ::getRowSet():fieldGet( 'articulos_propiedades_nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nEditType           := EDIT_GET_BUTTON
      :bEditValid          := {|| .t. }
      :bEditBlock          := {|| ::oController:getCombinacionesController():runViewSelector( ::getRowSet():fieldGet( 'articulo_codigo' ) ) }
      :nBtnBmp             := 1
      :AddResource( "Lupa" )
      :bOnPostEdit         := {|oCol, uNewValue | ::oController:postValidateCombinacionesUuid( oCol, uNewValue ) }
   end with

   with object ( ::oColumnCodigoAlmacen := ::oBrowse:AddCol() )
      :cSortOrder          := 'almacen_codigo'
      :cHeader             := 'C�digo almac�n'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'almacen_codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nEditType           := EDIT_GET_BUTTON
      :bEditValid          := {|oGet, oCol| ::oController:validAlmacenCodigo( oGet, oCol ) }
      :bOnPostEdit         := {|oCol, uNewValue, nKey| ::oController:postValidateAlmacenCodigo( oCol, uNewValue, nKey ) }
      :bEditBlock          := {|| ::oController:oController:getAlmacenesController():ActivateSelectorView() }
      :nBtnBmp             := 1
      :AddResource( "Lupa" )
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'almacen_nombre'
      :cHeader             := 'Nombre almac�n'
      :nWidth              := 180
      :bEditValue          := {|| ::getRowSet():fieldGet( 'almacen_nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oColumnCodigoAgente := ::oBrowse:AddCol() )
      :cSortOrder          := 'agente_codigo'
      :cHeader             := 'C�digo agente'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'agente_codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nEditType           := EDIT_GET_BUTTON
      :bEditValid          := {|oGet, oCol| ::oController:validAgenteCodigo( oGet, oCol ) }
      :bOnPostEdit         := {|oCol, uNewValue, nKey| ::oController:postValidateAgenteCodigo( oCol, uNewValue, nKey ) }
      :bEditBlock          := {|| ::oController:oController:getAgentesController():ActivateSelectorView() }
      :nBtnBmp             := 1
      :AddResource( "Lupa" )
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
      :cHeader             := '% Comisi�n agente'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'agente_comision' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :cEditPicture        := "@E 999.99"
      :nEditType           := EDIT_GET
      :bOnPostEdit         := {| oCol, uNewValue | ::oController:updateField( 'agente_comision', uNewValue ) }
   end with

   ::getColumnDeletedAt()

RETURN ( nil )

//---------------------------------------------------------------------------//