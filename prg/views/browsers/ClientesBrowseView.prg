#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ClientesBrowseView FROM TercerosBrowseView 

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS ClientesBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'id'
      :cHeader             := 'Id'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'id' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'uuid'
      :cHeader             := 'Uuid'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'codigo'
      :cHeader             := 'C�digo'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'nombre'
      :cHeader             := 'Nombre'
      :nWidth              := 250
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'dni'
      :cHeader             := 'DNI/CIF'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'dni' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with 

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'direccion'
      :cHeader             := 'Direcci�n'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'direccion' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'poblacion'
      :cHeader             := 'Poblaci�n'
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
      :cHeader             := 'C�digo postal'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'codigo_postal' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'telefono'
      :cHeader             := 'Tel�fono'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'telefono' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'movil'
      :cHeader             := 'M�vil'
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
      :cHeader             := '�ltima llamada'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'fecha_ultima_llamada' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'agente_codigo'
      :cHeader             := 'C�digo agente'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'agente_codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
      
      if ::oController:isUserEdit()
         :nEditType        := 5
         :bOnPostEdit      := {|oCol, uNewValue, nKey| ::oController:validColumnAgentesBrowse( uNewValue, nKey ) }
         :bEditBlock       := {|| ::oController:oAgentesController:ActivateSelectorView() }
         :nBtnBmp          := 1
         :AddResource( "Lupa" )
      end if
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'nombre_agente'
      :cHeader             := 'Agente'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre_agente' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'metodo_pago_codigo'
      :cHeader             := 'C�digo pago'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'metodo_pago_codigo' ) }
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
      :cSortOrder          := 'nombre_metodo_pago'
      :cHeader             := 'Forma pago'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre_metodo_pago' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'ruta_codigo'
      :cHeader             := 'C�digo ruta'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'ruta_codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
      
      if ::oController:isUserEdit()
         :nEditType        := 5
         :bOnPostEdit      := {|oCol, uNewValue, nKey| ::oController:validColumnRutasBrowse( uNewValue, nKey ) }
         :bEditBlock       := {|| ::oController:getRutasController():ActivateSelectorView() }
         :nBtnBmp          := 1
         :AddResource( "Lupa" )
      end if
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'nombre_ruta'
      :cHeader             := 'Ruta'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre_ruta' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'tercero_grupo_codigo'
      :cHeader             := 'C�digo grupo'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'tercero_grupo_codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
      
      if ::oController:isUserEdit()
         :nEditType        := 5
         :bOnPostEdit      := {|oCol, uNewValue, nKey| ::oController:validColumnGruposBrowse( uNewValue, nKey ) }
         :bEditBlock       := {|| ::oController:oTercerosGruposController:ActivateSelectorView() }
         :nBtnBmp          := 1
         :AddResource( "Lupa" )
      end if
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'nombre_grupo_cliente'
      :cHeader             := 'Grupo cliente'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre_grupo_cliente' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'nombre_grupo_cliente'
      :cHeader             := 'C�digo remesa'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre_grupo_cliente' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
      
      if ::oController:isUserEdit()
         :nEditType        := 5
         :bOnPostEdit      := {|oCol, uNewValue, nKey| ::oController:validColumnCuentasRemesasBrowse( uNewValue, nKey ) }
         :bEditBlock       := {|| ::oController:getCuentasRemesasController():ActivateSelectorView() }
         :nBtnBmp          := 1
         :AddResource( "Lupa" )
      end if
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'nombre_remesa'
      :cHeader             := 'Remesa'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre_remesa' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

    with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'tarifa_codigo'
      :cHeader             := 'C�digo tarifa'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'tarifa_codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'tarifa_nombre'
      :cHeader             := 'Nombre tarifa'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'tarifa_nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

RETURN ( nil )

//---------------------------------------------------------------------------//