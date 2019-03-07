#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS SQLAjustableGestoolModel FROM SQLAjustableModel

   METHOD getTableName()               INLINE ( "gestool." + ::cTableName )
  
   METHOD getAjusteModel()             INLINE ( iif( empty( ::oAjusteModel ), ::oAjusteModel := SQLAjustesGestoolModel():New(), ), ::oAjusteModel )

   METHOD getUsuarioCajaExclusiva( cUuid ) ;
                                       INLINE ( ::getValue( cUuid, 'usuarios', 'caja_exclusiva', space( 40 ) ) )   
   METHOD getUsuarioPcEnUso( cUuid ) ;
                                       INLINE ( ::getValue( cUuid, 'usuarios', 'pc_en_uso', '' ) )
   METHOD getUsuarioEmpresaEnUso( cUuid ) ;
                                       INLINE ( ::getValue( cUuid, 'usuarios', 'empresa_en_uso', '' ) )
   METHOD getUsuarioEmpresaExclusiva( cUuid ) ;
                                       INLINE ( ::getValue( cUuid, 'usuarios', 'empresa_exclusiva', space( 40 ) ) )   
   
   METHOD getUsuarioEmpresa( cUuid )   

   METHOD getUsuarioAlmacenExclusivo( cUuid ) ;
                                       INLINE ( ::getValue( cUuid, 'usuarios', 'almacen_exclusivo', space( 40 ) ) )   
   METHOD getUsuarioDelegacionExclusiva( cUuid ) ;
                                       INLINE ( ::getValue( cUuid, 'usuarios', 'delegacion_exclusiva', space( 40 ) ) )   

   METHOD getRolMostrarRentabilidad( cUuid ) ;
                                       INLINE ( ::getLogic( cUuid, 'roles', 'mostrar_rentabilidad', .t. ) )   
   METHOD getRolNoMostrarRentabilidad( cUuid ) ;
                                       INLINE ( !::getRolMostrarRentabilidad( cUuid ) )   
   
   METHOD getRolCambiarPrecios( cUuid )                                 ;
                                       INLINE ( ::getLogic( cUuid, 'roles', 'cambiar_precios', .t. ) )   
   METHOD getRolNoCambiarPrecios( cUuid )                               ;
                                       INLINE ( !::getRolCambiarPrecios( cUuid ) )   
   
   METHOD getRolVerPreciosCosto( cUuid )                                ;
                                       INLINE ( ::getLogic( cUuid, 'roles', 'ver_precios_costo', .t. ) )   
   METHOD getRolNoVerPreciosCosto( cUuid )                              ;
                                       INLINE ( !::getRolVerPreciosCosto( cUuid ) )   
    
   METHOD getRolFiltrarVentas( cUuid )                                  ;
                                    INLINE ( ::getLogic( cUuid, 'roles', 'fitrar_ventas_por_usuario', .t. ) )   
   METHOD getRolNoFiltrarVentas( cUuid )                                ;
                                    INLINE ( !::getRolFiltrarVentas( cUuid ) )   
   
   METHOD getRolAbrirCajonPortamonedas( cUuid )                         ;
                                    INLINE ( ::getLogic( cUuid, 'roles', 'abrir_cajon_portamonedas', .t. ) )   

   METHOD setEmpresaSeleccionarUsuarios( uAjusteValue, cAjustableUuid ) ;
                                    INLINE ( ::setLogic( 'seleccionar_usuarios', uAjusteValue, 'empresas', cAjustableUuid ) )
   METHOD getEmpresaSeleccionarUsuarios( cUuid );
                                    INLINE ( ::getLogic( cUuid, 'empresas', 'seleccionar_usuarios', .f. ) )   

   METHOD getRolAlbaranEntregado( cUuid );
                                    INLINE ( ::getLogic( cUuid, 'roles', 'albaran_entregado', .t. ) )   
   METHOD getRolNoAlbaranEntregado( cUuid );
                                    INLINE ( !::getRolAlbaranEntregado( cUuid ) )

   METHOD getRolAsistenteGenerarFacturas( cUuid );
                                    INLINE ( ::getLogic( cUuid, 'roles', 'asistente_generar_facturas', .t. ) )   
   METHOD getRolNoAsistenteGenerarFacturas( cUuid );
                                    INLINE ( !::getRolAsistenteGenerarFacturas( cUuid ) )

   METHOD getRolCambiarEstado( cUuid );
                                    INLINE ( ::getLogic( cUuid, 'roles', 'cambiar_estado', .t. ) )   
   METHOD getRolNoCambiarEstado( cUuid );
                                    INLINE ( !::getRolCambiarEstado( cUuid ) )

   METHOD getRolCambiarCampos( cUuid );
                                    INLINE ( ::getLogic( cUuid, 'roles', 'cambiar_campos', .t. ) )   
   METHOD getRolNoCambiarCampos( cUuid );
                                    INLINE ( !::getRolCambiarCampos( cUuid ) )

   METHOD setEmpresaDelegacionDefecto( uAjusteValue, cAjustableUuid );
                                    INLINE ( ::setValue( 'delegacion_defecto', uAjusteValue, 'empresas', cAjustableUuid ) )
   METHOD getEmpresaDelegacionDefecto( cUuid );
                                    INLINE ( ::getValue( cUuid, 'empresas', 'delegacion_defecto', space( 40 ) ) )   

   METHOD getValueWhereMac( cTipoAjuste, cMacAddress, uDefault )

   METHOD setUsuarioCajaExclusiva( uAjusteValue, cAjustableUuid ) ;      
                                    INLINE ( ::setValue( 'caja_exclusiva', uAjusteValue, 'usuarios', cAjustableUuid ) )
   METHOD setUsuarioPcEnUso( uAjusteValue, cAjustableUuid ) ;            
                                    INLINE ( ::setValue( 'pc_en_uso', uAjusteValue, 'usuarios', cAjustableUuid ) )
   METHOD setUsuarioEmpresaEnUso( uAjusteValue, cAjustableUuid ) ;       
                                    INLINE ( ::setValue( 'empresa_en_uso', uAjusteValue, 'usuarios', cAjustableUuid ) )
   METHOD setUsuarioEmpresaExclusiva( uAjusteValue, cAjustableUuid ) ;   
                                    INLINE ( ::setValue( 'empresa_exclusiva', uAjusteValue, 'usuarios', cAjustableUuid ) )
   METHOD setUsuarioAlmacenExclusivo( uAjusteValue, cAjustableUuid ) ;   
                                    INLINE ( ::setValue( 'almacen_exclusivo', uAjusteValue, 'usuarios', cAjustableUuid ) )
   METHOD setUsuarioDelegacionExclusiva( uAjusteValue, cAjustableUuid ) ;
                                    INLINE ( ::setValue( 'delegacion_exclusiva', uAjusteValue, 'usuarios', cAjustableUuid ) )
   METHOD setRolMostrarRentabilidad( uAjusteValue, cAjustableUuid ) ;    
                                    INLINE ( ::setLogic( 'mostrar_rentabilidad', uAjusteValue, 'roles', cAjustableUuid ) )
   METHOD setRolCambiarPrecios( uAjusteValue, cAjustableUuid ) ;         
                                    INLINE ( ::setLogic( 'cambiar_precios', uAjusteValue, 'roles', cAjustableUuid ) )
   METHOD setRolVerPreciosCosto( uAjusteValue, cAjustableUuid ) ;        
                                    INLINE ( ::setLogic( 'ver_precios_costo', uAjusteValue, 'roles', cAjustableUuid ) )
   METHOD setRolConfirmacionEliminacion( uAjusteValue, cAjustableUuid ) ;
                                    INLINE ( ::setLogic( 'confirmacion_eliminacion', uAjusteValue, 'roles', cAjustableUuid ) )
   METHOD setRolFiltrarVentas( uAjusteValue, cAjustableUuid ) ;          
                                    INLINE ( ::setLogic( 'fitrar_ventas_por_usuario', uAjusteValue, 'roles', cAjustableUuid ) )
   METHOD setRolAbrirCajonPortamonedas( uAjusteValue, cAjustableUuid ) ; 
                                    INLINE ( ::setLogic( 'abrir_cajon_portamonedas', uAjusteValue, 'roles', cAjustableUuid ) )
   METHOD setRolAlbaranEntregado( uAjusteValue, cAjustableUuid ) ;       
                                    INLINE ( ::setLogic( 'albaran_entregado', uAjusteValue, 'roles', cAjustableUuid ) )
   METHOD setRolAsistenteGenerarFacturas( uAjusteValue, cAjustableUuid );
                                    INLINE ( ::setLogic( 'asistente_generar_facturas', uAjusteValue, 'roles', cAjustableUuid ) )
   METHOD setRolCambiarEstado( uAjusteValue, cAjustableUuid ) ;          
                                    INLINE ( ::setLogic( 'cambiar_estado', uAjusteValue, 'roles', cAjustableUuid ) )
   METHOD setRolCambiarCampos( uAjusteValue, cAjustableUuid ) ;          
                                    INLINE ( ::setLogic( 'cambiar_campos', uAjusteValue, 'roles', cAjustableUuid ) )

   METHOD setUltimaEmpresaInMac( uuidEmpresa, cMacAddress ) ;            
                                    INLINE ( ::set( '', uuidEmpresa, 'ultima_empresa', cMacAddress ) )
   METHOD getUltimaEmpresaInMac( cMacAddress ) ;            
                                    INLINE ( ::getValueWhereMac( 'ultima_empresa', cMacAddress, '' ) )

   METHOD setUltimoUsuarioInMac( uuidUsuario, cMacAddress ) ;            
                                    INLINE ( ::set( '', uuidUsuario, 'ultimo_usuario', cMacAddress ) )
   METHOD getUltimoUsuarioInMac( cMacAddress ) ;            
                                    INLINE ( ::getValueWhereMac( 'ultimo_usuario', cMacAddress ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD getUsuarioEmpresa( cUuid ) CLASS SQLAjustableGestoolModel

   local cCodigoEmpresa    := ::getUsuarioEmpresaExclusiva( cUuid )

   if !empty( cCodigoEmpresa )                                    
      RETURN ( cCodigoEmpresa )
   end if 

RETURN ( ::getUsuarioEmpresaEnUso( cUuid ) )

//---------------------------------------------------------------------------//

METHOD getValueWhereMac( cTipoAjuste, cMacAddress, uDefault ) CLASS SQLAjustableGestoolModel

   local uValue
   local cSentence 

   if empty( cTipoAjuste ) .or. empty( cMacAddress )
      RETURN ( uDefault )
   end if 

   cSentence               := "SELECT ajuste_valor "
   cSentence               +=    "FROM " + ::getTableName() + " "
   cSentence               += "WHERE ajustable_uuid = " + notEscapedQuoted( cMacAddress ) + " "
   cSentence               +=    "AND ajustable_tipo = " + quoted( cTipoAjuste )

   uValue                  := getSQLDatabase():getValue( cSentence )

   if hb_ischar( uValue ) 
      RETURN ( uValue ) 
   endif

RETURN ( uDefault )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLAjustableModel FROM SQLCompanyModel

   DATA oAjusteModel

   DATA cTableName                     INIT "ajustables"

   DATA cConstraints                   INIT "PRIMARY KEY ( id ), UNIQUE KEY ( ajuste_uuid, ajustable_tipo, ajustable_uuid )"

   METHOD getAjusteModel()             INLINE ( iif( empty( ::oAjusteModel ), ::oAjusteModel := SQLAjustesModel():New(), ), ::oAjusteModel )

   METHOD getAjusteTableName()         INLINE ( ::getAjusteModel():getTableName() )

   METHOD getColumns()

   METHOD set( cAjusteUuid, uAjusteValue, cAjustableTipo, cAjustableUuid )

   METHOD getValue( cUuid, cTipo, cAjuste, uDefault )
   METHOD setValue( cAjusteUuid, uAjusteValue, cAjustableTipo, cAjustableUuid )

   METHOD getLogic( cUuid, cTipo, cAjuste, lDefault ) 
   METHOD setLogic( cAjusteUuid, lAjusteValue, cAjustableTipo, cAjustableUuid )

   METHOD setMetodoPago( uAjusteValue, cAjustableUuid ) ;
                                       INLINE ( ::setValue( 'metodo_pago_defecto', uAjusteValue, 'empresas', cAjustableUuid ) )
   METHOD getMetodoPago( uuidEmpresa );
                                       INLINE ( padr( ::getValue( uuidEmpresa, 'empresas', 'metodo_pago_defecto', space( 20 ) ), 20 ) )   

   METHOD setAlmacen( uAjusteValue, cAjustableUuid ) ;
                                       INLINE ( ::setValue( 'almacen_defecto', uAjusteValue, 'empresas', cAjustableUuid ) )
   METHOD getAlmacen( uuidEmpresa );
                                       INLINE ( padr( ::getValue( uuidEmpresa, 'empresas', 'almacen_defecto', space( 20 ) ), 20 ) )   

   METHOD setUnidadesGrupo( uAjusteValue, cAjustableUuid );
                                       INLINE ( ::setValue( 'unidades_grupo_defecto', uAjusteValue, 'empresas', cAjustableUuid ) )
   METHOD getUnidadesGrupo( uuidEmpresa );
                                       INLINE ( padr( ::getValue( uuidEmpresa, 'empresas', 'unidades_grupo_defecto', space( 20 ) ), 20 ) )   

   METHOD setUsarUbicaciones( uAjusteValue, cAjustableUuid );
                                       INLINE ( ::setLogic( 'usar_ubicaciones', uAjusteValue, 'empresas', cAjustableUuid ) )
   METHOD getUsarUbicaciones( uuidEmpresa );
                                       INLINE ( ::getLogic( uuidEmpresa, 'empresas', 'usar_ubicaciones', .f. ) )   

   METHOD setEmpresaTarifaDefecto( uAjusteValue, cAjustableUuid );
                                       INLINE ( ::setValue( 'tarifas_defecto', uAjusteValue, 'empresas', cAjustableUuid ) )
   METHOD getEmpresaTarifaDefecto( cCodigo );
                                       INLINE ( padr( ::getValue( cCodigo, 'empresas', 'tarifas_defecto', __tarifa_base__ ), 20 ) )   

   METHOD setCertificado( uAjusteValue, cAjustableUuid );
                                       INLINE ( ::setValue( 'certificado_defecto', uAjusteValue, 'empresas', cAjustableUuid ) )
   METHOD getCertificado( uuidEmpresa );
                                       INLINE ( padr( ::getValue( uuidEmpresa, 'empresas', 'certificado_defecto', space( 200 ) ), 200 ) )   

   METHOD getRolConfirmacionEliminacion( cUuid )                        ;
                                       INLINE ( ::getLogic( cUuid, 'roles', 'confirmacion_eliminacion', .t. ) )   
   METHOD getRolNoConfirmacionEliminacion( cUuid )                      ;
                                       INLINE ( !::getRolConfirmacionEliminacion( cUuid ) )   


END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLAjustableModel

   hset( ::hColumns, "id",             {  "create"    => "INTEGER AUTO_INCREMENT"                  ,;
                                          "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",           {  "create"    => "VARCHAR ( 40 ) NOT NULL"                  ,;
                                          "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "ajuste_uuid",    {  "create"    => "VARCHAR ( 40 ) NOT NULL"                  ,;
                                          "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "ajuste_valor",   {  "create"    => "VARCHAR( 100 )"                          ,;
                                          "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "ajustable_tipo", {  "create"    => "VARCHAR ( 100 ) NOT NULL"                ,;
                                          "default"   => {|| space( 100 ) } }                      )

   hset( ::hColumns, "ajustable_uuid", {  "create"    => "VARCHAR ( 40 ) NOT NULL"                  ,;
                                          "default"   => {|| space( 40 ) } }                       )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD set( cAjusteUuid, uAjusteValue, cAjustableTipo, cAjustableUuid ) CLASS SQLAjustableModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "ajuste_uuid",    cAjusteUuid    )
   hset( hBuffer, "ajuste_valor",   uAjusteValue   )
   hset( hBuffer, "ajustable_tipo", cAjustableTipo )
   hset( hBuffer, "ajustable_uuid", cAjustableUuid )

RETURN ( ::insertOnDuplicate( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD setValue( cAjusteDescripcion, uAjusteValue, cAjustableTipo, cAjustableUuid ) CLASS SQLAjustableModel

   local cAjusteUuid

   if empty( cAjusteDescripcion ) .or. empty( cAjustableTipo ) .or. empty( cAjustableUuid )
      RETURN ( nil )
   endif

   cAjusteUuid       := ::getAjusteModel():getAjusteUuid( cAjusteDescripcion )

   if empty( cAjusteUuid )
      RETURN ( nil )
   endif

RETURN ( ::set( cAjusteUuid, uAjusteValue, cAjustableTipo, cAjustableUuid ) )

//---------------------------------------------------------------------------//

METHOD setLogic( cAjusteDescripcion, lAjusteValue, cAjustableTipo, cAjustableUuid ) CLASS SQLAjustableModel

   local cAjusteUuid    
   local uAjusteValue    

   cAjusteUuid       := ::getAjusteModel():getAjusteUuid( cAjusteDescripcion )

   if empty( cAjusteUuid )
      RETURN ( nil )
   endif

   uAjusteValue      := if( lAjusteValue, '1', '0' )

RETURN ( ::set( cAjusteUuid, uAjusteValue, cAjustableTipo, cAjustableUuid ) )

//---------------------------------------------------------------------------//

METHOD getValue( cUuid, cTipo, cAjuste, uDefault ) CLASS SQLAjustableModel

   local uValue
   local cSentence 

   if empty( cUuid ) .or. empty( cTipo ) .or. empty( cAjuste )
      RETURN ( uDefault )
   end if 

   cSentence         := "SELECT ajustables.ajuste_valor "
   cSentence         +=    "FROM " + ::getTableName() + " AS ajustables "
   cSentence         += "INNER JOIN " + ::getAjusteTableName() + " AS ajustes ON ajustes.ajuste = " + quoted( cAjuste ) + " "
   cSentence         += "WHERE ajustables.ajuste_uuid = ajustes.uuid "
   cSentence         +=    "AND ajustables.ajustable_tipo = " + quoted( cTipo ) + " "
   cSentence         +=    "AND ajustables.ajustable_uuid = " + quoted( cUuid ) 

   uValue            := getSQLDatabase():getValue( cSentence )

   if hb_ischar( uValue ) 
      RETURN ( alltrim( uValue ) )
   endif

RETURN ( uDefault )

//---------------------------------------------------------------------------//

METHOD getLogic( cUuid, cTipo, cajuste, lDefault ) CLASS SQLAjustableModel

   local uValue

   uValue   := ::getValue( cUuid, cTipo, cajuste, lDefault )

   if hb_ischar( uValue ) 
      RETURN ( alltrim( uValue ) == '1' ) 
   endif

RETURN ( lDefault )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

