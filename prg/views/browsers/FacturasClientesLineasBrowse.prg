#include "FiveWin.Ch"
#include "Factu.Ch"
#include "Xbrowse.Ch"

//------------------------------------------------------------------------//

CLASS FacturasClientesLineasBrowseView FROM SQLBrowseView

   DATA lFastEdit          INIT .t.

   DATA lFooter            INIT .t.

   DATA nFreeze            INIT 1

   DATA nMarqueeStyle      INIT 3

   DATA nColSel            INIT 2

   DATA oColumnCodigo

   DATA oColumnUnidadMedicion

   METHOD Create( oWindow )

   METHOD addColumns()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD Create( oWindow ) CLASS FacturasClientesLineasBrowseView 

   ::Super:Create( oWindow )

   ::oBrowse:setChange( {|| ::oController:oHistoryManager:Set( ::getRowSet():getValuesAsHash() ) } )

   ::oBrowse:setGotFocus( {|| ::oController:oHistoryManager:Set( ::getRowSet():getValuesAsHash() ) } )

RETURN ( ::oBrowse )

//---------------------------------------------------------------------------//

METHOD addColumns() CLASS FacturasClientesLineasBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'id'
      :cHeader             := 'Id'
      :cOrder              := 'D'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'id' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'uuid'
      :cHeader             := 'Uuid'
      :nWidth              := 240
      :bEditValue          := {|| ::getRowSet():fieldGet( 'uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'parent_uuid'
      :cHeader             := 'Parent Uuid'
      :nWidth              := 240
      :bEditValue          := {|| ::getRowSet():fieldGet( 'uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oColumnCodigo := ::oBrowse:AddCol() )
      :cSortOrder          := 'articulo_codigo'
      :cHeader             := 'Código artículo'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'articulo_codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nEditType           := EDIT_GET_BUTTON
      :bEditValid          := {|oGet, oCol| ::oController:validArticuloCodigo( oGet, oCol ) }
      :bOnPostEdit         := {|oCol, uNewValue, nKey| ::oController:postValidateArticuloCodigo( oCol, uNewValue, nKey ) }
      :bEditBlock          := {|| ::oController:oSenderController:oArticulosController:ActivateSelectorView() }
      :nBtnBmp             := 1
      :AddResource( "Lupa" )
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'articulo_nombre'
      :cHeader             := 'Nombre artículo'
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
      :oFooterFont         := getBoldFont()
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
      :cEditPicture        := masUnd()
      :cDataType           := "N"
      :lHide               := .t.
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
      :oFooterFont         := getBoldFont()
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
      :bOnPostEdit         := {|oCol, uNewValue, nKey| ::oController:updateField( 'articulo_precio', uNewValue ) }
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
      :oFooterFont         := getBoldFont()
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
      :cSortOrder          := 'total_precio'
      :cHeader             := 'Total precio'
      :nWidth              := 80
      :cEditPicture        := "@E 99,999,999.999999"
      :bEditValue          := {|| ::getRowSet():fieldGet( 'total_precio' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nFootStyle          := :nDataStrAlign               
      :nFooterType         := AGGR_SUM
      :cFooterPicture      := :cEditPicture
      :oFooterFont         := getBoldFont()
      :cDataType           := "N"
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Propiedades'
      :nWidth              := 100
      :bEditValue          := {|| 'propiedades' }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nEditType           := EDIT_GET_BUTTON
      :bEditValid          := {|| msgalert( 'valid' ), .t. }
      :bEditBlock          := {|| ::oController:oCombinacionesController:runViewSelector() }
      :nBtnBmp             := 1
      :AddResource( "Lupa" )
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'incremento_precio'
      :cHeader             := 'Incremento'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'incremento_precio' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nFootStyle          := :nDataStrAlign               
      :cEditPicture        := "@E 999.9999"
      :cFooterPicture      := :cEditPicture
      :oFooterFont         := getBoldFont()
      :cDataType           := "N"
      :nEditType           := EDIT_GET
      :bOnPostEdit         := {| oCol, uNewValue | ::oController:updateField( 'incremento_precio', uNewValue ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'iva'
      :cHeader             := '% IVA'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'iva' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nFootStyle          := :nDataStrAlign               
      :cEditPicture        := "@E 999.9999"
      :cFooterPicture      := :cEditPicture
      :oFooterFont         := getBoldFont()
      :cDataType           := "N"
      :nEditType           := EDIT_GET
      :bOnPostEdit         := {| oCol, uNewValue | ::oController:updateField( 'iva', uNewValue ) }
   end with

RETURN ( nil )

//---------------------------------------------------------------------------//