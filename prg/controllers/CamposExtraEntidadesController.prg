#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS CamposExtraEntidadesController FROM SQLNavigatorController

   METHOD New()

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS CamposExtraEntidadesController

   ::Super:New()

   ::cTitle                   := "Campos Extra Entidades"

   ::setName( "campos_extra_entidades" )

   ::nLevel                   := Auth():Level( ::getName() )

   ::hImage                   := {  "16" => "gc_user_message_16",;
                                    "32" => "gc_user_message_32",;
                                    "48" => "gc_user_message_48" }

   ::oModel                   := SQLCamposExtraEntidadesModel():New( self )

   ::oBrowseView              := CamposExtraEntidadesBrowseView():New( self )

   ::oDialogView              := CamposExtraEntidadesView():New( self )

   ::oValidator               := CamposExtraEntidadesValidator():New( self, ::oDialogView )

   ::oFilterController:setTableToFilter( ::oModel:cTableName )

RETURN ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS CamposExtraEntidadesBrowseView FROM SQLBrowseView

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
      :cSortOrder          := 'uuid_campo_extra'
      :cHeader             := 'Campo Extra'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'uuid_campo_extra' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with 

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'entidad'
      :cHeader             := 'Entidad'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'entidad' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with 

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS CamposExtraEntidadesView FROM SQLBaseView

   CLASSDATA CEADD  INIT {    "articulos" =>                            { "nombre" => "Artículos",  "icono" => "gc_object_cube_16"                                     } ,;
                              "clientes" =>                             { "nombre" => "Clientes",  "icono" => "gc_user_16"                                             } ,;
                              "proveedores" =>                          { "nombre" => "Proveedores",  "icono" => "gc_businessman_16"                                   } ,;
                              "familias" =>                             { "nombre" => "Familias",  "icono" => "gc_cubes_16"                                            } ,;
                              "agentes" =>                              { "nombre" => "Agentes",  "icono" => "gc_businessman2_16"                                      } ,;
                              "presupuestos_clientes" =>                { "nombre" => "Presupuestos a clientes",  "icono" => "gc_notebook_user_16"                     } ,;
                              "pedidos_clientes" =>                     { "nombre" => "Pedidos a clientes",  "icono" => "gc_clipboard_empty_user_16"                   } ,;
                              "albaranes_clientes" =>                   { "nombre" => "Albaranes a clientes",  "icono" => "gc_document_empty_16"                       } ,;
                              "lineas_albaranes_clientes" =>            { "nombre" => "Lineas de albaranes a clientes",  "icono" => "gc_document_empty_16"             } ,;
                              "facturas_clientes" =>                    { "nombre" => "Facturas a clientes",  "icono" => "gc_document_text_user_16"                    } ,;
                              "lineas_facturas_clientes" =>             { "nombre" => "Lineas de facturas a clientes",  "icono" => "gc_document_text_user_16"          } ,;
                              "facturas_anticipos_clientes" =>          { "nombre" => "Facturas de anticipos a clientes",  "icono" => "gc_document_text_money2_16"     } ,;
                              "rectificativa_clientes" =>               { "nombre" => "Facturas rectificativa a clientes",  "icono" => "gc_document_text_delete_16"    } ,;
                              "pedidos_proveedores" =>                  { "nombre" => "Pedidos a proveedores",  "icono" => "gc_clipboard_empty_businessman_16"         } ,;
                              "lineas_pedidos_proveedores" =>           { "nombre" => "Lineas pedidos a proveedores",  "icono" => "gc_clipboard_empty_businessman_16"  } ,;
                              "albaranes_proveedores" =>                { "nombre" => "Albaranes a proveedores",  "icono" => "gc_clipboard_empty_businessman_16"       } ,;
                              "lineas_albaranes_proveedores" =>         { "nombre" => "Lineas albaranes a proveedores",  "icono" => "gc_clipboard_empty_businessman_16"} ,;
                              "facturas_proveedores" =>                 { "nombre" => "Facturas a proveedores",  "icono" => "gc_document_text_businessman_16"          } ,;
                              "lineas_facturas_proveedores" =>          { "nombre" => "Lineas facturas a proveedores",  "icono" => "gc_document_text_businessman_16"   } ,;
                              "facturas_rectificativa_proveedores"=>    {"nombre" => "Facturas rectificativa a proveedores",  "icono" => "gc_document_text_delete2_16" } ,;
                              "sat" =>                                  { "nombre" => "S.A.T",  "icono" => "gc_power_drill_sat_user_16"                                } ,;
                              "envases_articulos" =>                    { "nombre" => "Envases de artículos",  "icono" => "gc_box_closed_16"                           } ,;
                              "grupos_clientes"   =>                    { "nombre" => "Grupos de clientes",  "icono" => "gc_users3_16"                                 } ,;
                              "propiedades"       =>                    { "nombre" => "Propiedades",  "icono" => "gc_coathanger_16"                                    } ,;
                              "lineas_propiedades" =>                   { "nombre" => "Lineas de propiedades",  "icono" => "gc_coathanger_16"                          } ,;
                           }   

   METHOD New()

END CLASS

//---------------------------------------------------------------------------//

/*METHOD New( oController ) CLASS CamposExtraEntidadesView

   ::Super:New( oController )

   ::aTipos          := {  "Texto", "Número", "Fecha", "Lógico", "Lista" }

   ::hTipos          := {  "Texto"  => {|| ::oLongitud:Enable(), ::oDecimales:Disable(), ::disableDefecto(), ::setLongitud( 100, 0 ) } ,;
                           "Número" => {|| ::enableLongitud(), ::disableDefecto(), ::setLongitud( 16, 6 ) } ,;
                           "Fecha"  => {|| ::disableLongitud(), ::setLongitud( 8, 0 ), ::disableDefecto() } ,;
                           "Lógico" =>  {|| ::disableLongitud(), ::setLongitud( 1, 0 ), ::disableDefecto() } ,;
                           "Lista"  => {|| ::disableLongitud(), ::setLongitud( 10, 0 ), ::enableDefecto() } }

   ::aListaDefecto   := {}

RETURN ( self )*/

//---------------------------------------------------------------------------//

METHOD Activate() CLASS CamposExtraEntidadesView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "CAMPOS_EXTRA_ENTIDAD";
      TITLE       ::LblTitle() + "Campo extra"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        getBoldFont() ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "uuid_campo_extra" ] ;
      ID          100 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "uuid_campo_extra" ) ) ;
      OF          ::oDialog

   REDEFINE COMBOBOX ::oTipo ;
      VAR         ::oController:oModel:hBuffer[ "entidad" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ITEMS       ( ::aTipos ) ;
      OF          ::oDialog

   REDEFINE BUTTON ::oAddDefecto;
      ID          120 ;
      OF          ::oDialog ;
      ACTION      ( ::addDefecto() )

   REDEFINE BUTTON ::oDelDefecto;
      ID          130 ;
      OF          ::oDialog ;
      ACTION      ( ::oListaDefecto:Del() )

   REDEFINE BUTTON ;
      ID          IDOK ;
      OF          ::oDialog ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ACTION      ( if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          ::oDialog ;
      CANCEL ;
      ACTION      ( ::oDialog:end() )

   if ::oController:isNotZoomMode() 
      ::oDialog:AddFastKey( VK_F5, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) } )
   end if

   ACTIVATE DIALOG ::oDialog CENTER

   ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
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

   ::hValidators  := {     "nombre" =>          {  "required"     => "El  campo extra es un dato requerido",;
                                                   "unique"       => "El nombre introducido ya existe" } ,;   
                           "tipo"     =>        {  "required"     => "El tipo es un dato requerido"} ,; 
                           "longitud" =>        {  "required"     => "La longitud es un dato requerido"} }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLCamposExtraEntidadesModel FROM SQLBaseModel

   DATA cTableName                           INIT "campos_extra_entidad"

   METHOD getColumns()

   // METHOD getRequeridoAttribute( value )     INLINE ( value == 1 )

   // METHOD setRequeridoAttribute( value )     INLINE ( iif( value, 1, 0 ) )
          
END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLCamposExtraEntidadesModel

   hset( ::hColumns, "id",                {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                             "text"      => "Identificador"                           ,;
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",              {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;
                                             "text"      => "Uuid"                                    ,;
                                             "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "uuid_campo_extra",  {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;
                                             "text"      => "Uuid_campo_extra"                        ,;
                                             "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "entidad",           {  "create"    => "VARCHAR ( 30 )"                          ,;
                                             "default"   => {|| space( 30 ) } }                       )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS CamposExtraEntidadesRepository FROM SQLBaseRepository

   METHOD getTableName()         INLINE ( SQLCamposExtraEntidadesModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//