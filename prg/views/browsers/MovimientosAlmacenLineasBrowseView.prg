#include "FiveWin.Ch"
#include "Factu.Ch"

//------------------------------------------------------------------------//

CLASS MovimientosAlmacenLineasBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns()

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'id'
      :cHeader             := 'Id'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'id' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'nombre_movimiento'
      :cHeader             := 'Tipo movimiento'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre_movimiento' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'fecha_hora'
      :cHeader             := 'Fecha'
      :cEditPicture        := '@DT'
      :nWidth              := 140
      :nHeadStrAlign       := AL_LEFT
      :nDataStrAlign       := AL_LEFT
      :bEditValue          := {|| ::getRowSet():fieldGet( 'fecha_hora' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'almacen_origen'
      :cHeader             := 'Almacén origen'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'almacen_origen' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'almacen_destino'
      :cHeader             := 'Almacén destino'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'almacen_destino' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'grupo_movimiento'
      :cHeader             := 'Grupo'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'grupo_movimiento' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'agente'
      :cHeader             := 'Agente'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'agente' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'divisa'
      :cHeader             := 'Divisa'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'divisa' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'comentarios'
      :cHeader             := 'Comentarios'
      :nWidth              := 240
      :bEditValue          := {|| ::getRowSet():fieldGet( 'comentarios' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

RETURN ( self )

//---------------------------------------------------------------------------//

