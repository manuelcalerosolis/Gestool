#include "FiveWin.Ch"
#include "Factu.Ch"

//------------------------------------------------------------------------//

CLASS MovimientosAlmacenBrowseView FROM SQLBrowseView

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
      :cSortOrder          := 'movimientos_almacen.uuid'
      :cHeader             := 'Uuid'
      :nWidth              := 180
      :bEditValue          := {|| ::getRowSet():fieldGet( 'movimientos_almacen.uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'numero'
      :cHeader             := 'Número'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'numero' ) }
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
      :cSortOrder          := 'movimientos_almacen.fecha_hora'
      :cHeader             := 'Fecha'
      :cEditPicture        := '@DT'
      :nWidth              := 140
      :nHeadStrAlign       := AL_LEFT
      :nDataStrAlign       := AL_LEFT
      :bEditValue          := {|| ::getRowSet():fieldGet( 'movimientos_almacen.fecha_hora' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'movimientos_almacen.almacen_origen'
      :cHeader             := 'Almacén origen'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'movimientos_almacen.almacen_origen' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'movimientos_almacen.almacen_destino'
      :cHeader             := 'Almacén destino'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'movimientos_almacen.almacen_destino' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'movimientos_almacen.grupo_movimiento'
      :cHeader             := 'Grupo'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'movimientos_almacen.grupo_movimiento' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'movimientos_almacen.agente'
      :cHeader             := 'Agente'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'movimientos_almacen.agente' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'movimientos_almacen.divisa'
      :cHeader             := 'Divisa'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'movimientos_almacen.divisa' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'movimientos_almacen.comentarios'
      :cHeader             := 'Comentarios'
      :nWidth              := 240
      :bEditValue          := {|| ::getRowSet():fieldGet( 'movimientos_almacen.comentarios' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'movimientos_almacen.creado'
      :cHeader             := 'Creado'
      :cEditPicture        := '@DT'
      :nWidth              := 140
      :nHeadStrAlign       := AL_LEFT
      :nDataStrAlign       := AL_LEFT
      :lHide               := .t.
      :bEditValue          := {|| ::getRowSet():fieldGet( 'movimientos_almacen.creado' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'movimientos_almacen.modificado'
      :cHeader             := 'Modificado'
      :cEditPicture        := '@DT'
      :nWidth              := 140
      :nHeadStrAlign       := AL_LEFT
      :nDataStrAlign       := AL_LEFT
      :lHide               := .t.
      :bEditValue          := {|| ::getRowSet():fieldGet( 'movimientos_almacen.modificado' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'movimientos_almacen.enviado'
      :cHeader             := 'Enviado'
      :cEditPicture        := '@DT'
      :nWidth              := 140
      :nHeadStrAlign       := AL_LEFT
      :nDataStrAlign       := AL_LEFT
      :lHide               := .t.
      :bEditValue          := {|| ::getRowSet():fieldGet( 'movimientos_almacen.enviado' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

RETURN ( self )

//---------------------------------------------------------------------------//

