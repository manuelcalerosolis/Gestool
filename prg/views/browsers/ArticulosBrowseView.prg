#include "FiveWin.Ch"
#include "Factu.ch" 
#include "InKey.ch"

//---------------------------------------------------------------------------//

CLASS ArticulosBrowseView FROM SQLBrowseView

   DATA lFastEdit          INIT .t.

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS ArticulosBrowseView

  ::getColumnIdAndUuid()

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "codigo"
      :cHeader             := "Código"
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( "codigo" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with 

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "nombre"
      :cHeader             := "Nombre"
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( "nombre" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "familia_codigo"
      :cHeader             := "Código familia"
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( "familia_codigo" ) }
      :lHide               := .t.
      
      if ::getController():isUserEdit()
         :nEditType        := 5
         :bOnPostEdit      := {|oCol, uNewValue, nKey| ::getController():validColumnArticulosFamiliaBrowse( oCol, uNewValue, nKey ) }
         :bEditBlock       := {|| ::getController():getArticulosFamiliasController():ActivateSelectorView() }
         :nBtnBmp          := 1
         :AddResource( "Lupa" )
      end if
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "articulo_familia_nombre"
      :cHeader             := "Familia"
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( "articulo_familia_nombre" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "tipo_codigo"
      :cHeader             := "Código tipo"
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( "tipo_codigo" ) }
      :lHide               := .t.
      
      if ::getController():isUserEdit()
         :nEditType        := 5
         :bOnPostEdit      := {|oCol, uNewValue, nKey| ::getController():validColumnArticulosTipoBrowse( oCol, uNewValue, nKey ) }
         :bEditBlock       := {|| ::getController():getArticulostipoController():ActivateSelectorView() }
         :nBtnBmp          := 1
         :AddResource( "Lupa" )
      end if
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "articulo_tipo_nombre"
      :cHeader             := "Tipo"
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( "articulo_tipo_nombre" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   // Categoria----------------------------------------------------------------

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "categoria_codigo"
      :cHeader             := "Código categoría"
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( "categoria_codigo" ) }
      :lHide               := .t.
      
      if ::getController():isUserEdit()
         :nEditType        := 5
         :bOnPostEdit      := {|oCol, uNewValue, nKey| ::getController():validColumnArticulosCategoriasBrowse( oCol, uNewValue, nKey ) }
         :bEditBlock       := {|| ::getController():getArticulosCategoriasController():ActivateSelectorView() }
         :nBtnBmp          := 1
         :AddResource( "Lupa" )
      end if
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "articulo_categoria_nombre"
      :cHeader             := "Categoría"
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( "articulo_categoria_nombre" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   // Fabricante----------------------------------------------------------------

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "fabricante_codigo"
      :cHeader             := "Código fabricante"
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( "fabricante_codigo" ) }
      :lHide               := .t.
      
      if ::getController():isUserEdit()
         :nEditType        := 5
         :bOnPostEdit      := {|oCol, uNewValue, nKey| ::getController():validColumnArticulosFabricantesBrowse( oCol, uNewValue, nKey ) }
         :bEditBlock       := {|| ::getController():getArticulosFabricantesController():ActivateSelectorView() }
         :nBtnBmp          := 1
         :AddResource( "Lupa" )
      end if
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "articulo_fabricante_nombre"
      :cHeader             := "Fabricante"
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( "articulo_fabricante_nombre" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   // Temporada----------------------------------------------------------------

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "temporada_codigo"
      :cHeader             := "Código temporada"
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( "temporada_codigo" ) }
      :lHide               := .t.
      
      if ::getController():isUserEdit()
         :nEditType        := 5
         :bOnPostEdit      := {|oCol, uNewValue, nKey| ::getController():validColumnArticulosTemporadasBrowse( oCol, uNewValue, nKey ) }
         :bEditBlock       := {|| ::getController():getArticulosTemporadasController():ActivateSelectorView() }
         :nBtnBmp          := 1
         :AddResource( "Lupa" )
      end if
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "articulo_temporada_nombre"
      :cHeader             := "Temporada"
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( "articulo_temporada_nombre" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   // IVA----------------------------------------------------------------------

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "tipo_iva_codigo"
      :cHeader             := "Código IVA"
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( "tipo_iva_codigo" ) }
      :lHide               := .t.
      
      if ::getController():isUserEdit()
         :nEditType        := 5
         :bOnPostEdit      := {|oCol, uNewValue, nKey| ::getController():validColumnTiposIvaBrowse( oCol, uNewValue, nKey ) }
         :bEditBlock       := {|| ::getController():getTipoIvaController():ActivateSelectorView() }
         :nBtnBmp          := 1
         :AddResource( "Lupa" )
      end if
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "tipo_iva_nombre"
      :cHeader             := "IVA"
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( "tipo_iva_nombre" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   // Impuestos especiales-----------------------------------------------------

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "impuesto_especial_codigo"
      :cHeader             := "Código impuesto especial"
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( "impuesto_especial_codigo" ) }
      :lHide               := .t.
      
      if ::getController():isUserEdit()
         :nEditType        := 5
         :bOnPostEdit      := {|oCol, uNewValue, nKey| ::getController():validColumnImpuestosEspecialesBrowse( oCol, uNewValue, nKey ) }
         :bEditBlock       := {|| ::getController():getImpuestosEspecialesController():ActivateSelectorView() }
         :nBtnBmp          := 1
         :AddResource( "Lupa" )
      end if
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "impuesto_especial_nombre"
      :cHeader             := "Impuesto especial"
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( "impuesto_especial_nombre" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   // grupos de unidades de medicion-------------------------------------------

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "unidades_medicion_grupos_codigo"
      :cHeader             := "Código grupo unidades medición"
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( "unidades_medicion_grupos_codigo" ) }
      :lHide               := .t.
      
      if ::getController():isUserEdit()
         :nEditType        := 5
         :bOnPostEdit      := {|oCol, uNewValue, nKey| ::getController():validColumnUnidadesMedicionGruposBrowse( oCol, uNewValue, nKey ) }
         :bEditBlock       := {|| ::getController():getUnidadesMedicionGruposController():ActivateSelectorView() }
         :nBtnBmp          := 1
         :AddResource( "Lupa" )
      end if
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "unidades_medicion_grupos_nombre"
      :cHeader             := "Grupo unidades medición"
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( "unidades_medicion_grupos_nombre" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   ::getColumnsCreatedUpdatedAt()
   
   ::getColumnDeletedAt()

RETURN ( self )

//---------------------------------------------------------------------------//
