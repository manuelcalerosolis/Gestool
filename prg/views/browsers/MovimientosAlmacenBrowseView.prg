#include "FiveWin.Ch"
#include "Factu.Ch"

//------------------------------------------------------------------------//

CLASS MovimientosAlmacenBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

//---------------------------------------------------------------------------//
/*
   ::cGeneralSelect  := "SELECT tipo_movimiento, "                               + ;
                           "CASE "                                               + ;
                              "WHEN tipo_movimiento = 1 THEN 'Entre almacenes'"  + ;
                              "WHEN tipo_movimiento = 2 THEN 'Regularización' "  + ;
                              "WHEN tipo_movimiento = 3 THEN 'Objetivos' "       + ;
                              "WHEN tipo_movimiento = 4 THEN 'Consolidación' "   + ;
                           "END as nombre_movimiento, "                          + ;
                           "fecha_hora, "                                        + ;
                           "almacen_origen, "                                    + ;
                           "almacen_destino, "                                   + ;
                           "grupo_movimiento, "                                  + ;
                           "agente, "                                            + ;
                           "divisa, "                                            + ;
                           "divisa_cambio, "                                     + ;
                           "comentarios "                                        + ;        
                        "FROM " + ::getTableName()    
*/

METHOD addColumns()

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

/*
      if hhaskey( hColumn, "picture" ) 
         :cEditPicture     := hColumn[ "picture" ]
      end if 

      if hhaskey( hColumn, "headAlign" ) 
         :nHeadStrAlign    := hColumn[ "headAlign" ]
      end if 

      if hhaskey( hColumn, "dataAlign" ) 
         :nDataStrAlign    := hColumn[ "dataAlign" ]
      end if 

      if hhaskey( hColumn, "hide" ) 
         :lHide            := hColumn[ "hide" ]
      end if 

      if hhaskey( hColumn, "method" ) 
         :bEditValue       := ::getModel():getMethod( hColumn[ "method" ] )
      else 
         :bEditValue       := {|| ::getRowSet():fieldGet( ::getModel():getEditValue( cColumn ) ) }
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oColumn | ::onClickHeader( oColumn ) }
      end if 

      if hhaskey( hColumn, "footer" ) 
         :nFootStyle       := :nDataStrAlign               
         :nFooterType      := AGGR_SUM
         :cFooterPicture   := :cEditPicture
         :cDataType        := "N"
      end if 

      if hhaskey( hColumn, "footAlign" ) 
         :nFootStrAlign    := hColumn[ "footAlign" ]
      end if 

   end with
*/

RETURN ( self )

//---------------------------------------------------------------------------//

