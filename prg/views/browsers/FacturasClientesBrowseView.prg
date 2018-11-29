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

   ::getColumnIdAndUuid()
   
   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "numero"
      :cHeader             := "N�mero"
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( "numero" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "delegacion_uuid"    
      :cHeader             := "Delegaci�n uuid"
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( "delegacion_uuid" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "sesion_uuid" 
      :cHeader             := "Sesi�n uuid"
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( "sesion_uuid" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'fecha'
      :cHeader             := 'Fecha'
      :cEditPicture        := '@DT'
      :nWidth              := 100
      :cDataType           := 'D'
      :nHeadStrAlign       := AL_LEFT
      :nDataStrAlign       := AL_LEFT
      :bEditValue          := {|| ::getRowSet():fieldGet( 'fecha' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "cliente_codigo"
      :cHeader             := "C�digo cliente"
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
      :cHeader             := "Direcci�n"
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( "direccion_direccion" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "direccion_poblacion"
      :cHeader             := "Poblaci�n"
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( "direccion_poblacion" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "direccion_codigo_provincia"
      :cHeader             := "C�digo provincia"
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( "direccion_codigo_provincia" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "direccion_provincia"
      :cHeader             := "Provincia"
      :nWidth              := 150
      :bEditValue          := {|| ::getRowSet():fieldGet( "direccion_provincia" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "direccion_codigo_postal"
      :cHeader             := "C�digo postal"
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( "direccion_codigo_postal" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "direccion_telefono"
      :cHeader             := "Tel�fono"
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( "direccion_telefono" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "direccion_movil"
      :cHeader             := "M�vil"
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( "direccion_movil" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "direccion_email"
      :cHeader             := "Mail"
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( "direccion_email" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'total'
      :cHeader             := 'Total'
      :nWidth              := 100
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nDataStrAlign       := 1
      :nHeadStrAlign       := 1
      :bEditValue          := {|| ::getRowSet():fieldGet( 'total' ) }
      :cEditPicture        := "@E 9999.9999"
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "tarifa_codigo"
      :cHeader             := "C�digo tarifa"
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
      :cHeader             := "Recargo"
      :bStrData            := {|| "" }
      :bEditValue          := {|| ::getRowSet():fieldGet( "recargo_equivalencia" ) == 1 }
      :nWidth              := 60
      :SetCheck( { "Sel16", "Nil16" } )
   end with

   ::getColumnsCreatedUpdatedAt()
   
   ::getColumnDeletedAt()

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
