#include "FiveWin.Ch"
#include "Factu.ch" 
#include "InKey.ch"

//---------------------------------------------------------------------------//

CLASS ArticulosBrowseView FROM SQLBrowseView

   DATA lFastEdit                            INIT .t.

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS ArticulosBrowseView

   local oColumn

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'id'
      :cHeader             := 'Id'
      :nWidth              := 60
      :bEditValue          := {|| ::getRowSet():fieldGet( 'id' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Uuid'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'codigo'
      :cHeader             := 'Código'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with 

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'nombre'
      :cHeader             := 'Nombre'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( oColumn := ::oBrowse:AddCol() )
      :cSortOrder          := 'articulo_familia_codigo'
      :cHeader             := 'Código familia'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'articulo_familia_codigo' ) }
      :lHide               := .t.
      
      if ::oController:isUserEdit()
         :nEditType        := 5
         :bOnPostEdit      := {|oCol, uNewValue, nKey| ::oController:validColumnArticulosFamiliaBrowse( oCol, uNewValue, nKey ) }
         :bEditBlock       := {|| ::oController:oArticulosFamiliasController:ActivateSelectorView() }
         :nBtnBmp          := 1
         :AddResource( "Lupa" )
      end if
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'articulo_familia_nombre'
      :cHeader             := 'Familia'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'articulo_familia_nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( oColumn := ::oBrowse:AddCol() )
      :cSortOrder          := 'articulo_tipo_codigo'
      :cHeader             := 'Código tipo'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'articulo_tipo_codigo' ) }
      :lHide               := .t.
      
      if ::oController:isUserEdit()
         :nEditType        := 5
         :bOnPostEdit      := {|oCol, uNewValue, nKey| ::oController:validColumnArticulosTipoBrowse( oCol, uNewValue, nKey ) }
         :bEditBlock       := {|| ::oController:oArticulostipoController:ActivateSelectorView() }
         :nBtnBmp          := 1
         :AddResource( "Lupa" )
      end if
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'articulo_tipo_nombre'
      :cHeader             := 'Tipo'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'articulo_tipo_nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   // Categoria----------------------------------------------------------------

   with object ( oColumn := ::oBrowse:AddCol() )
      :cSortOrder          := 'articulo_categoria_codigo'
      :cHeader             := 'Código categoría'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'articulo_categoria_codigo' ) }
      :lHide               := .t.
      
      if ::oController:isUserEdit()
         :nEditType        := 5
         :bOnPostEdit      := {|oCol, uNewValue, nKey| ::oController:validColumnArticulosCategoriasBrowse( oCol, uNewValue, nKey ) }
         :bEditBlock       := {|| ::oController:oArticulosCategoriasController:ActivateSelectorView() }
         :nBtnBmp          := 1
         :AddResource( "Lupa" )
      end if
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'articulo_categoria_nombre'
      :cHeader             := 'Categoría'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'articulo_categoria_nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   // Fabricante----------------------------------------------------------------

   with object ( oColumn := ::oBrowse:AddCol() )
      :cSortOrder          := 'articulo_fabricante_codigo'
      :cHeader             := 'Código fabricante'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'articulo_fabricante_codigo' ) }
      :lHide               := .t.
      
      if ::oController:isUserEdit()
         :nEditType        := 5
         :bOnPostEdit      := {|oCol, uNewValue, nKey| ::oController:validColumnArticulosFabricantesBrowse( oCol, uNewValue, nKey ) }
         :bEditBlock       := {|| ::oController:oArticulosFabricantesController:ActivateSelectorView() }
         :nBtnBmp          := 1
         :AddResource( "Lupa" )
      end if
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'articulo_fabricante_nombre'
      :cHeader             := 'Fabricante'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'articulo_fabricante_nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   // IVA----------------------------------------------------------------------

   with object ( oColumn := ::oBrowse:AddCol() )
      :cSortOrder          := 'iva_tipo_codigo'
      :cHeader             := 'Código IVA'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'tipo_iva_codigo' ) }
      :lHide               := .t.
      
      if ::oController:isUserEdit()
         :nEditType        := 5
         :bOnPostEdit      := {|oCol, uNewValue, nKey| ::oController:validColumnTiposIvaBrowse( oCol, uNewValue, nKey ) }
         :bEditBlock       := {|| ::oController:oTipoIvaController:ActivateSelectorView() }
         :nBtnBmp          := 1
         :AddResource( "Lupa" )
      end if
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'tipo_iva_nombre'
      :cHeader             := 'IVA'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'tipo_iva_nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   // Impuestos especiales-----------------------------------------------------

   with object ( oColumn := ::oBrowse:AddCol() )
      :cSortOrder          := 'impuesto_especial_codigo'
      :cHeader             := 'Código impuesto especial'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'impuesto_especial_codigo' ) }
      :lHide               := .t.
      
      if ::oController:isUserEdit()
         :nEditType        := 5
         :bOnPostEdit      := {|oCol, uNewValue, nKey| ::oController:validColumnImpuestosEspecialesBrowse( oCol, uNewValue, nKey ) }
         :bEditBlock       := {|| ::oController:oImpuestosEspecialesController:ActivateSelectorView() }
         :nBtnBmp          := 1
         :AddResource( "Lupa" )
      end if
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'impuesto_especial_nombre'
      :cHeader             := 'Impuesto especial'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'impuesto_especial_nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   // primera propiedad--------------------------------------------------------

   with object ( oColumn := ::oBrowse:AddCol() )
      :cSortOrder          := 'primera_propiedad_codigo'
      :cHeader             := 'Código primera propiedad'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'primera_propiedad_codigo' ) }
      :lHide               := .t.
      
      if ::oController:isUserEdit()
         :nEditType        := 5
         :bOnPostEdit      := {|oCol, uNewValue, nKey| ::oController:validPrimeraPropiedadBrowse( oCol, uNewValue, nKey ) }
         :bEditBlock       := {|| ::oController:oPrimeraPropiedadController:ActivateSelectorView() }
         :nBtnBmp          := 1
         :AddResource( "Lupa" )
      end if
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'primera_propiedad_nombre'
      :cHeader             := 'Primera propiedad'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'primera_propiedad_nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   // segunda propiedad--------------------------------------------------------

   with object ( oColumn := ::oBrowse:AddCol() )
      :cSortOrder          := 'segunda_propiedad_codigo'
      :cHeader             := 'Código segunda propiedad'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'segunda_propiedad_codigo' ) }
      :lHide               := .t.
      
      if ::oController:isUserEdit()
         :nEditType        := 5
         :bOnPostEdit      := {|oCol, uNewValue, nKey| ::oController:validsegundaPropiedadBrowse( oCol, uNewValue, nKey ) }
         :bEditBlock       := {|| ::oController:osegundaPropiedadController:ActivateSelectorView() }
         :nBtnBmp          := 1
         :AddResource( "Lupa" )
      end if
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'segunda_propiedad_nombre'
      :cHeader             := 'Segunda propiedad'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'segunda_propiedad_nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with


RETURN ( self )

//---------------------------------------------------------------------------//
