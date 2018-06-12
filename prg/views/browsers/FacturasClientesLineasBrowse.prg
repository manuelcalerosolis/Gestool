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

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns()

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
      :bOnPostEdit         := {|oCol, uNewValue, nKey| ::oController:validColumnCodigoArticulo( oCol, uNewValue, nKey ) }
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
      :cSortOrder          := 'articulo_unidades'
      :cHeader             := 'Unidades'
      :nWidth              := 80
      :cEditPicture        := masUnd()
      :bEditValue          := {|| ::getRowSet():fieldGet( 'articulo_unidades' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nFootStyle          := :nDataStrAlign               
      :nFooterType         := AGGR_SUM
      :cFooterPicture      := :cEditPicture
      :oFooterFont         := getBoldFont()
      :cDataType           := "N"
   end with

RETURN ( self )

//---------------------------------------------------------------------------//

