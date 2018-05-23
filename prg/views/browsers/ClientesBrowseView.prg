#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ClientesBrowseView FROM TercerosBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS ClientesBrowseView

   ::super:addColumns()

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'direccion'
      :cHeader             := 'Dirección'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'direccion' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'poblacion'
      :cHeader             := 'Población'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'poblacion' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'provincia'
      :cHeader             := 'Provincia'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'provincia' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'codigo_postal'
      :cHeader             := 'Cod. postal'
      :nWidth              := 60
      :bEditValue          := {|| ::getRowSet():fieldGet( 'codigo_postal' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'telefono'
      :cHeader             := 'Teléfono'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'telefono' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'movil'
      :cHeader             := 'Móvil'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'movil' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'email'
      :cHeader             := 'Email'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'email' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'establecimiento'
      :cHeader             := 'Establecimiento'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'establecimiento' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'fecha_ultima_llamada'
      :cHeader             := 'Última llamada'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'fecha_ultima_llamada' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'codigo_agente'
      :cHeader             := 'Cod. Agente'
      :nWidth              := 65
      :bEditValue          := {|| ::getRowSet():fieldGet( 'codigo_agente' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'nombre_agente'
      :cHeader             := 'Agente'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre_agente' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

RETURN ( self )

//---------------------------------------------------------------------------//