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
      :bLDClickData        := {|| ::getController():Edit(), ::Refresh() }
   end with

   with object ( oColumn := ::oBrowse:AddCol() )
      :cSortOrder          := 'articulos_familia_codigo'
      :cHeader             := 'Código familia'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'articulos_familia_codigo' ) }
      :lHide               := .t.
      
      if ::oController:isUserEdit()
         :nEditType        := 5
         // :bLDClickData     := {|| oColumn:Edit( 1 ) }
         // :bKeyDown         := {|nKey| if( nKey == VK_RETURN, ( oColumn:Edit( 1 ), 0 ), nil ) }
         :bOnPostEdit      := {|oCol, uNewValue, nKey| ::oController:validColumnArticulosFamiliaBrowse( oCol, uNewValue, nKey ) }
         :bEditBlock       := {|| ::oController:oArticulosFamiliaController:ActivateSelectorView() }
         :nBtnBmp          := 1
         :AddResource( "Lupa" )
      end if
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'articulos_familia_nombre'
      :cHeader             := 'Familia'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'articulos_familia_nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

RETURN ( self )

//---------------------------------------------------------------------------//
