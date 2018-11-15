#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ClientesBrowseView FROM TercerosBrowseView 

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS ClientesBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'clientes.id'
      :cHeader             := 'Id'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'id' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'clientes.uuid'
      :cHeader             := 'Uuid'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'clientes.codigo'
      :cHeader             := 'Código'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'clientes.nombre'
      :cHeader             := 'Nombre'
      :nWidth              := 250
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'clientes.dni'
      :cHeader             := 'DNI/CIF'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'dni' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with 

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'direcciones.direccion'
      :cHeader             := 'Dirección'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'direccion' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'direcciones.poblacion'
      :cHeader             := 'Población'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'poblacion' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'direcciones.provincia'
      :cHeader             := 'Provincia'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'provincia' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'direcciones.codigo_postal'
      :cHeader             := 'Código postal'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'codigo_postal' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'direcciones.telefono'
      :cHeader             := 'Teléfono'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'telefono' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'direcciones.movil'
      :cHeader             := 'Móvil'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'movil' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'direcciones.email'
      :cHeader             := 'Email'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'email' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'clientes.establecimiento'
      :cHeader             := 'Establecimiento'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'establecimiento' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'clientes.fecha_ultima_llamada'
      :cHeader             := 'Última llamada'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'fecha_ultima_llamada' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'clientes.agente_codigo'
      :cHeader             := 'Código agente'
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
      :cSortOrder          := 'agentes.nombre'
      :cHeader             := 'Agente'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre_agente' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'clientes.metodo_pago_codigo'
      :cHeader             := 'Código pago'
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
      :cSortOrder          := 'forma_pago.nombre'
      :cHeader             := 'Forma pago'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre_forma_pago' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'clientes.ruta_codigo'
      :cHeader             := 'Código ruta'
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
      :cSortOrder          := 'rutas.nombre'
      :cHeader             := 'Ruta'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre_ruta' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'clientes.cliente_grupo_codigo'
      :cHeader             := 'Código grupo'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'cliente_grupo_codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
      
      if ::oController:isUserEdit()
         :nEditType        := 5
         :bOnPostEdit      := {|oCol, uNewValue, nKey| ::oController:validColumnGruposBrowse( uNewValue, nKey ) }
         :bEditBlock       := {|| ::oController:oClientesGruposController:ActivateSelectorView() }
         :nBtnBmp          := 1
         :AddResource( "Lupa" )
      end if

   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'clientes_grupos.nombre'
      :cHeader             := 'Grupo cliente'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'clientes_grupos.nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'clientes.cuenta_remesa_codigo'
      :cHeader             := 'Código remesa'
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
      :cSortOrder          := 'cuentas_remesa.nombre'
      :cHeader             := 'Remesa'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre_remesa' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

    with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'tarifas.codigo'
      :cHeader             := 'Código tarifa'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'tarifa_codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'tarifas.nombre'
      :cHeader             := 'Nombre tarifa'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'tarifa_nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

RETURN ( nil )

//---------------------------------------------------------------------------//