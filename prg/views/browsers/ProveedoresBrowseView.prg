#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ProveedoresBrowseView FROM TercerosBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS ProveedoresBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'proveedores.id'
      :cHeader             := 'Id'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'id' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'proveedores.uuid'
      :cHeader             := 'Uuid'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'proveedores.codigo'
      :cHeader             := 'Código'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'proveedores.nombre'
      :cHeader             := 'Nombre'
      :nWidth              := 250
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'proveedores.dni'
      :cHeader             := 'DNI/CIF'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'dni' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with 

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'proveedores.web'
      :cHeader             := 'web'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'web' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   /*with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'clientes.forma_pago_codigo'
      :cHeader             := 'Código pago'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'forma_pago_codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
      
      if ::oController:isUserEdit()
         :nEditType        := 5
         :bOnPostEdit      := {|oCol, uNewValue, nKey| ::oController:validColumnFormasdePagoBrowse( uNewValue, nKey ) }
         :bEditBlock       := {|| ::oController:getFormasPagoController():ActivateSelectorView() }
         :nBtnBmp          := 1
         :AddResource( "Lupa" )
      end if

   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'forma_pago.nombre'
      :cHeader             := 'Forma pago'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre_forma_pago' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with*/

RETURN ( nil )

//---------------------------------------------------------------------------//