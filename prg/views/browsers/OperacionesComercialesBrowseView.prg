#include "FiveWin.Ch"
#include "Factu.Ch"
#include "Xbrowse.Ch" 

//----------------------------------------------------------------------------//

CLASS OperacionesComercialesBaseBrowseView FROM SQLBrowseView 

   DATA lFastEdit                      INIT .t.

   DATA lDeletedColored                INIT .f.

   METHOD addColumns()                     

   METHOD addExtraColumn()              VIRTUAL

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS OperacionesComercialesBaseBrowseView

   ::getColumnIdAndUuid()

   ::addExtraColumn() 

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "serie_numero"
      :cHeader             := "N�mero"
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( "serie_numero" ) }
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
      :cSortOrder          := 'fecha_valor_stock'
      :cHeader             := 'Fecha stock'
      :cEditPicture        := '@DT'
      :nWidth              := 120
      :cDataType           := 'D'
      :nHeadStrAlign       := AL_LEFT
      :nDataStrAlign       := AL_LEFT
      :bEditValue          := {|| ::getRowSet():fieldGet( 'fecha_valor_stock' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "tercero_codigo"
      :cHeader             := "C�digo tercero"
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( "tercero_codigo" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with 

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "tercero_nombre"
      :cHeader             := "Nombre tercero"
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( "tercero_nombre" ) }
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
      :cSortOrder          := 'cobrado'
      :cHeader             := 'Cobrado'
      :nWidth              := 100
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nDataStrAlign       := 1
      :nHeadStrAlign       := 1
      :bEditValue          := {|| ::getRowSet():fieldGet( 'cobrado' ) }
      :cEditPicture        := "@E 9999.9999"
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Pendiente'
      :nWidth              := 100
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nDataStrAlign       := 1
      :nHeadStrAlign       := 1
      :bEditValue          := {|| ::getRowSet():fieldGet( 'total' ) - ::getRowSet():fieldGet( 'cobrado' ) }
      :cEditPicture        := "@E 9999.9999"
      :lHide               := .t.
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
      :bEditValue          := {|| ::getRowSet():fieldGet( "recargo_equivalencia" ) }
      :nWidth              := 60
      :SetCheck( { "Sel16", "Nil16" } )
   end with

   ::getColumnsCreatedUpdatedAt()
   
   ::getColumnCanceledAt()

RETURN ( nil )

//---------------------------------------------------------------------------//

CLASS OperacionesComercialesBrowseView FROM OperacionesComercialesBaseBrowseView 

   METHOD addExtraColumn()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addExtraColumn() CLASS OperacionesComercialesBrowseView 

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "canceled_at"
      :cHeader             := "Estado"
      :nWidth              := 80
      :bEditValue          := {|| iif( empty( ::getRowSet():fieldGet( 'canceled_at' ) ), "Activo", "Cancelado" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with 

RETURN ( nil )

//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//

CLASS OperacionesComercialesPreviewBrowseView FROM OperacionesComercialesBaseBrowseView 

   DATA cName                          INIT "OperacionesComercialesPreviewBrowseView"

   DATA lFastEdit                      INIT .f.

   DATA lDeletedColored                INIT .t.

ENDCLASS

//---------------------------------------------------------------------------//

/*METHOD addExtraColumn() CLASS OperacionesComercialesPreviewBrowseView


   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "canceled_at"
      :cHeader             := "Select"
      :nWidth              := 80
      :bEditValue          := {|| iif( empty( ::getRowSet():fieldGet( 'canceled_at' ) ), "Activo", "Cancelado" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with 

RETURN ( nil )*/

//----------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

