#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS CamposExtraEntidadesGestoolController FROM CamposExtraEntidadesController 

   CLASSDATA aEntidades          INIT  {  "empresas" =>  { "nombre" => "Empresas", "icono" => "gc_factory_16"  },;
                                          "usuarios" =>  { "nombre" => "Usuarios", "icono" => "gc_businesspeople_16"  } }

   METHOD getModel()             INLINE ( if( empty( ::oModel ), ::oModel := SQLCamposExtraEntidadesGestoolModel():New( self ), ), ::oModel )

   METHOD getConfiguracionVistasController() ;
                                 INLINE ( if( empty( ::oConfiguracionVistasController ), ::oConfiguracionVistasController := SQLConfiguracionVistasGestoolController():New( self ), ), ::oConfiguracionVistasController )

END CLASS

//---------------------------------------------------------------------------//

CLASS CamposExtraEntidadesController FROM SQLBrowseController

   CLASSDATA aEntidades INIT  {  "articulos" =>                            { "nombre" => "Artículos",  "icono" => "gc_object_cube_16"                                     } ,;
                                 "articulos_temporadas" =>                 { "nombre" => "Temporadas", "icono" => "gc_cloud_sun_16"                                       } ,;
                                 "articulos_categorias" =>                 { "nombre" => "Categorias", "icono" => "gc_photographic_filters_16"                            } ,;
                                 "articulos_propiedades" =>                { "nombre" => "Propiedades", "icono" => "gc_coathanger_16"                                     } ,;
                                 "articulos_familias" =>                   { "nombre" => "Familias",  "icono" => "gc_cubes_16"                                            } ,;
                                 "articulos_tipos" =>                      { "nombre" => "Tipos de artículos", "icono" => "gc_objects_16"                                 } ,;
                                 "articulos_tarifas" =>                    { "nombre" => "Tarifas", "icono" => "gc_money_interest_16"                                     } ,;
                                 "clientes" =>                             { "nombre" => "Clientes",  "icono" => "gc_user_16"                                             } ,;
                                 "clientes_grupos" =>                      { "nombre" => "Grupo de clientes",  "icono" => "gc_users3_16"                                  } ,;
                                 "proveedores" =>                          { "nombre" => "Proveedores",  "icono" => "gc_businessman_16"                                   } ,;
                                 "agentes" =>                              { "nombre" => "Agentes",  "icono" => "gc_businessman2_16"                                      } ,;
                                 "transportistas" =>                       { "nombre" => "Transportistas",  "icono" => "gc_small_truck_16"                                } ,;
                                 "presupuestos_clientes" =>                { "nombre" => "Presupuestos a clientes",  "icono" => "gc_notebook_user_16"                     } ,;
                                 "pedidos_clientes" =>                     { "nombre" => "Pedidos a clientes",  "icono" => "gc_clipboard_empty_user_16"                   } ,;
                                 "albaranes_clientes" =>                   { "nombre" => "Albaranes a clientes",  "icono" => "gc_document_empty_16"                       } ,;
                                 "lineas_albaranes_clientes" =>            { "nombre" => "Líneas de albaranes a clientes",  "icono" => "gc_document_empty_16"             } ,;
                                 "facturas_clientes" =>                    { "nombre" => "Facturas a clientes",  "icono" => "gc_document_text_user_16"                    } ,;
                                 "lineas_facturas_clientes" =>             { "nombre" => "Líneas de facturas a clientes",  "icono" => "gc_document_text_user_16"          } ,;
                                 "facturas_anticipos_clientes" =>          { "nombre" => "Facturas de anticipos a clientes",  "icono" => "gc_document_text_money2_16"     } ,;
                                 "rectificativa_clientes" =>               { "nombre" => "Facturas rectificativa a clientes",  "icono" => "gc_document_text_delete_16"    } ,;
                                 "pedidos_proveedores" =>                  { "nombre" => "Pedidos a proveedores",  "icono" => "gc_clipboard_empty_businessman_16"         } ,;
                                 "lineas_pedidos_proveedores" =>           { "nombre" => "Líneas pedidos a proveedores",  "icono" => "gc_clipboard_empty_businessman_16"  } ,;
                                 "albaranes_proveedores" =>                { "nombre" => "Albaranes a proveedores",  "icono" => "gc_clipboard_empty_businessman_16"       } ,;
                                 "forma_pago" =>                           { "nombre" => "Forma de pago",  "icono" => "gc_credit_cards_16"                                } ,;
                                 "lineas_albaranes_proveedores" =>         { "nombre" => "Líneas albaranes a proveedores",  "icono" => "gc_clipboard_empty_businessman_16"} ,;
                                 "facturas_proveedores" =>                 { "nombre" => "Facturas a proveedores",  "icono" => "gc_document_text_businessman_16"          } ,;
                                 "lineas_facturas_proveedores" =>          { "nombre" => "Líneas facturas a proveedores",  "icono" => "gc_document_text_businessman_16"   } ,;
                                 "facturas_rectificativa_proveedores"=>    { "nombre" => "Facturas rectificativa a proveedores", "icono" => "gc_document_text_delete2_16" } ,;
                                 "sat" =>                                  { "nombre" => "S.A.T",  "icono" => "gc_power_drill_sat_user_16"                                } ,;
                                 "envases_articulos" =>                    { "nombre" => "Envases de artículos",  "icono" => "gc_box_closed_16"                           } ,;
                                 "grupos_clientes" =>                      { "nombre" => "Grupos de clientes",  "icono" => "gc_users3_16"                                 } ,;
                                 "movimientos_almacen" =>                  { "nombre" => "Movimientos de almacén",  "icono" => "gc_pencil_package_16"                     } ,;
                                 "movimientos_almacen_lineas" =>           { "nombre" => "Movimientos de almacén lineas", "icono" => "gc_pencil_package_16"               } ,;
                                 "articulos_fabricantes" =>                { "nombre" => "Fabricantes", "icono" => "gc_pencil_package_16"                                 } ,;
                                 "articulos_familias_comentarios" =>       { "nombre" => "Comentarios", "icono" => "gc_message_16"                                        } ,;
                                 "almacenes" =>                            { "nombre" => "Almacenes", "icono" => "gc_warehouse_16"                                        } ,;
                                 "entidades" =>                            { "nombre" => "Entidades", "icono" => "gc_office_building2_16"                                 } ,;
                                 "cuentas_remesa" =>                       { "nombre" => "Cuentas de remesa", "icono" => "gc_notebook2_16"                                } ,;
                                 "cuentas_bancarias" =>                    { "nombre" => "Cuentas bancarias", "icono" => "gc_central_bank_euro_16"                        } ,;
                                 "tipos_iva" =>                            { "nombre" => "Tipos de IVA", "icono" => "gc_moneybag_16"                                      } ,;
                                 "impuestos_especiales" =>                 { "nombre" => "Impuestos especiales", "icono" => "gc_moneybag_euro_16"                         } ,;
                                 "orden_comandas" =>                       { "nombre" => "Orden de comandas", "icono" => "gc_sort_az_descending_16"                       } ,;
                                 "divisas_monetarias" =>                   { "nombre" => "Divisas monetarias", "icono" => "gc_currency_euro_16"                           } ,;
                                 "cajas" =>                                { "nombre" => "Cajas", "icono" => "gc_cash_register_16"                                        } ,;
                                 "unidades_medicion" =>                    { "nombre" => "Unidades de medición", "icono" => "gc_tape_measure2_16"                         } ,;
                                 "unidades_medicion_grupos" =>             { "nombre" => "Grupos de unidades de medición", "icono" => "gc_tape_measure2_16"               } ,;
                                 "rutas" =>                                { "nombre" => "Rutas", "icono" => "gc_map_route_16"                                            } ,;
                                 "cajas_entradas_salidas" =>               { "nombre" => "Entradas y salidas de caja", "icono" => "gc_cash_register_refresh_16"           } ,;
                                 "lineas_propiedades" =>                   { "nombre" => "Líneas de propiedades",  "icono" => "gc_coathanger_16"                          } ,;
                                 "listin" =>                               { "nombre" => "Listín telefónico", "icono" => "gc_book_telephone_16"                           } }   

   METHOD New( oController ) CONSTRUCTOR

   METHOD End()

   METHOD getNombresEntidades()

   METHOD getNombreWhereEntidad( cEntidad )

   METHOD getEntidadWhereNombre( cNombre )

   METHOD UpdateLine( cCampo, uValue )

   METHOD assertAppend()

   METHOD gettingSelectSentence()

   //Construcciones tardias----------------------------------------------------

   METHOD getModel()          INLINE ( if( empty( ::oModel ), ::oModel := SQLCamposExtraEntidadesModel():New( self ), ), ::oModel )

   METHOD getBrowseView()     INLINE( if( empty( ::oBrowseView ), ::oBrowseView := CamposExtraEntidadesBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()     INLINE( if( empty( ::oDialogView ), ::oDialogView := CamposExtraEntidadesView():New( self ), ), ::oDialogView )

   METHOD getValidator()      INLINE( if( empty( ::oValidator ), ::oValidator := CamposExtraEntidadesValidator():New( self  ), ), ::oValidator )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS CamposExtraEntidadesController

   ::Super:New( oController )

   ::cTitle                   := "Campos extra entidades"

   ::cName                    := "campos_extra_entidades"

   ::hImage                   := {  "16" => "gc_user_message_16",;
                                    "32" => "gc_user_message_32",;
                                    "48" => "gc_user_message_48" }

   ::getModel():setEvent( 'gettingSelectSentence',  {|| ::gettingSelectSentence() } ) 
   
   ::setEvent( 'appending',            {|| ::assertAppend() } )
   ::setEvent( 'appended',             {|| ::oBrowseView:Refresh() } )
   ::setEvent( 'deletedSelection',     {|| ::oBrowseView:Refresh() } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS CamposExtraEntidadesController

   if !empty( ::oModel )
      ::oModel:End()
   end if 

   if !empty( ::oBrowseView )
      ::oBrowseView:End()
   end if

   if !empty( ::oDialogView )
      ::oDialogView:End()
   end if

   if !empty( ::oValidator )
      ::oValidator:End()
   end if

   ::Super:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD gettingSelectSentence()

   local uuid        := ::getController():getUuid() 

   if !empty( uuid )
      ::getModel():setGeneralWhere( "parent_uuid = " + quoted( uuid ) )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getNombreWhereEntidad( cEntidad ) CLASS CamposExtraEntidadesController

   local cNombre     := ""

   heval( ::aEntidades, {|k,v| iif( k == alltrim( cEntidad ), cNombre := hget( v, "nombre" ), ) } )

RETURN ( cNombre )
   
//---------------------------------------------------------------------------//

METHOD getNombresEntidades() CLASS CamposExtraEntidadesController

   local aNombres    := {}

   heval( ::aEntidades, {|k,v| aadd( aNombres, hget( v, "nombre" ) ) } )

RETURN ( aNombres )

//---------------------------------------------------------------------------//

METHOD getEntidadWhereNombre( cNombre ) CLASS CamposExtraEntidadesController

   local cEntidad    := ""

   heval( ::aEntidades, {|k,v| iif( hget( v, "nombre" ) == cNombre, cEntidad := k, ) } )
   
RETURN ( cEntidad )

//---------------------------------------------------------------------------//

METHOD assertAppend() CLASS CamposExtraEntidadesController

   if empty( ::oController )
      RETURN ( .t. )
   end if 

RETURN ( ::getModel():isNotBlankEntityWhereUuid( ::getController():getUuid() ) )

//---------------------------------------------------------------------------//

METHOD UpdateLine( uValue ) CLASS CamposExtraEntidadesController

   local cEntidad    := ::getEntidadWhereNombre( uValue )

   if empty( cEntidad ) 
      RETURN ( nil )
   end if 

   if ::getModel():isEntityWhereUuid( ::oController:getUuid(), cEntidad ) 
      msgStop( "El nombre de la entidad ya existe" )
      RETURN ( nil )
   end if 

   ::getModel():updateFieldWhereId( ::oRowSet:fieldGet( 'id' ), 'entidad', cEntidad )
   
   ::getRowSet():Refresh()

   ::getBrowseView():Refresh()

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS CamposExtraEntidadesBrowseView FROM SQLBrowseView

   DATA lFooter            INIT .f.

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS CamposExtraEntidadesBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'id'
      :cHeader             := 'Id'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'id' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Uuid'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'parent_uuid'
      :cHeader             := 'Campo Extra'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'parent_uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with 

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'entidad'
      :cHeader             := 'Entidad'
      :nWidth              := 320
      :bEditValue          := {|| ::oController:getNombreWhereEntidad( ::getRowSet():fieldGet( 'entidad' ) )  }
      :nEditType           := EDIT_LISTBOX
      :cEditPicture        := ""
      :aEditListTxt        := ::oController:getNombresEntidades() 
      :bOnPostEdit         := {| oCol, uValue, nKey | ::oController:UpdateLine( uValue ) }
   end with

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS CamposExtraEntidadesView FROM SQLBaseView

   METHOD Activate()    INLINE ( .t. )

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS CamposExtraEntidadesValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS CamposExtraEntidadesValidator

   ::hValidators  := {  "nombre" =>    {  "required"  => "El  campo extra es un dato requerido",;
                                          "unique"    => "El nombre introducido ya existe" } ,;   
                        "tipo"     =>  {  "required"  => "El tipo es un dato requerido"} ,; 
                        "longitud" =>  {  "required"  => "La longitud es un dato requerido"} }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLCamposExtraEntidadesGestoolModel FROM SQLCamposExtraEntidadesModel

   METHOD getTableName()                     INLINE ( "gestool." + ::cTableName ) 

END CLASS 

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLCamposExtraEntidadesModel FROM SQLCompanyModel

   DATA cTableName                        INIT "campos_extra_entidad"

   METHOD getColumns()

   METHOD getParentUuidAttribute( value )

   METHOD deleteBlankEntityWhereUuid( parentUuid )

   METHOD isEntityWhereUuid( parentUuid, cEntidad )

   METHOD isBlankEntityWhereUuid( parentUuid );
                                          INLINE ( ::isEntityWhereUuid( parentUuid, '' ) )
   
   METHOD isNotBlankEntityWhereUuid( parentUuid );
                                          INLINE ( !::isBlankEntityWhereUuid(  parentUuid ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLCamposExtraEntidadesModel

   hset( ::hColumns, "id",                {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",              {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;
                                             "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "parent_uuid",       {  "create"    => "VARCHAR( 40 ) NOT NULL"                  ,;
                                             "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "entidad",           {  "create"    => "VARCHAR ( 40 )"                          ,;
                                             "default"   => {|| space( 40 ) } }                       )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getParentUuidAttribute( value )

   if empty( ::oController )
      RETURN ( value )
   end if

   if empty( ::oController:oController )
      RETURN ( value )
   end if

RETURN ( ::oController:oController:getUuid() )

//---------------------------------------------------------------------------//

METHOD deleteBlankEntityWhereUuid( parentUuid )

   local cSQL  := "DELETE FROM " + ::getTableName() + " "
   cSQL        +=    "WHERE parent_uuid = " + quoted( parentUuid ) + " "
   cSQL        +=    "AND entidad = ''"

RETURN ( getSQLDataBase():Exec( cSQL ) )

//---------------------------------------------------------------------------//

METHOD isEntityWhereUuid( parentUuid, cEntidad )

   local cSQL  := "SELECT Count(*) FROM " + ::getTableName() + " "
   cSQL        +=    "WHERE parent_uuid = " + quoted( parentUuid ) + " "
   cSQL        +=    "AND entidad = " + quoted( cEntidad )

RETURN ( getSQLDataBase():getValue( cSQL ) > 0 )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

