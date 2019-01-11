#include "FiveWin.Ch"
#include "Factu.Ch"
#include "Xbrowse.Ch" 

//----------------------------------------------------------------------------//

CLASS ConsolidacionAlmacenBrowseView FROM SQLBrowseView 

   DATA lFastEdit                      INIT .t.

   DATA lDeletedColored                INIT .f.

   METHOD addColumns()    

   METHOD addTercerosNombreLabel()     VIRTUAL

   METHOD addTercerosCodigoLabel()     VIRTUAL                  

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS ConsolidacionAlmacenBrowseView

   ::getColumnIdAndUuid()
   
   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "numero"
      :cHeader             := "Número"
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( "numero" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'fecha_valor_stock'
      :cHeader             := 'Fecha'
      :cEditPicture        := '@DT'
      :nWidth              := 160
      :cDataType           := 'D'
      :nHeadStrAlign       := AL_LEFT
      :nDataStrAlign       := AL_LEFT
      :bEditValue          := {|| ::getRowSet():fieldGet( 'fecha_valor_stock' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'comentario'
      :cHeader             := 'Comentario'
      :nWidth              := 400
      :bEditValue          := {|| ::getRowSet():fieldGet( 'comentario' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
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

   ::getColumnsCreatedUpdatedAt()
   
   ::getColumnDeletedAt()

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
