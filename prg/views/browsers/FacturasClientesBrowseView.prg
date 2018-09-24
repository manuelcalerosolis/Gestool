#include "FiveWin.Ch"
#include "Factu.Ch"
#include "Xbrowse.Ch" 

//----------------------------------------------------------------------------//

CLASS FacturasClientesBrowseView FROM SQLBrowseView 

   DATA lFastEdit          INIT .t.

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS FacturasClientesBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "id"
      :cHeader             := "Id"
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( "id" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "uuid"
      :cHeader             := "Uuid"
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( "uuid" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "numero"
      :cHeader             := "Número"
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( "numero" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "delegacion_uuid"    
      :cHeader             := "Delegación uuid"
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( "delegacion_uuid" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "sesion_uuid" 
      :cHeader             := "Sesión uuid"
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( "sesion_uuid" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "cliente_codigo"
      :cHeader             := "Código cliente"
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( "cliente_codigo" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with 

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "cliente_nombre"
      :cHeader             := "Nombre cliente"
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( "cliente_nombre" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "direccion_direccion"
      :cHeader             := "Dirección"
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( "direccion_direccion" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "direccion_poblacion"
      :cHeader             := "Población"
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( "direccion_poblacion" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "direccion_codigo_provincia"
      :cHeader             := "Código provincia"
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( "direccion_codigo_provincia" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "direccion_provincia"
      :cHeader             := "Provincia"
      :nWidth              := 150
      :bEditValue          := {|| ::getRowSet():fieldGet( "direccion_provincia" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "direccion_codigo_postal"
      :cHeader             := "Código postal"
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( "direccion_codigo_postal" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "direccion_telefono"
      :cHeader             := "Teléfono"
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( "direccion_telefono" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "direccion_movil"
      :cHeader             := "Móvil"
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( "direccion_movil" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "direccion_email"
      :cHeader             := "Mail"
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( "direccion_email" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "tarifa_codigo"
      :cHeader             := "Código tarifa"
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( "tarifa_codigo" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "tarifa_nombre"
      :cHeader             := "Nombre tarifa"
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( "tarifa_nombre" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "recargo_equivalencia"
      :cHeader             := "Recargo equivalencia"
      :bStrData            := {|| "" }
      :bEditValue          := {|| ::getRowSet():fieldGet( "recargo_equivalencia" ) == 1 }
      :nWidth              := 60
      //:bValid             :={||::click( ::getRowSet():fieldGet( "recargo" ) )  }
      :SetCheck( { "Sel16", "Nil16" } )
   end with

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
