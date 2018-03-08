#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS SQLAjustableModel FROM SQLBaseModel

   DATA cTableName               INIT "ajustables"

   DATA cConstraints             INIT "PRIMARY KEY ( id ), UNIQUE KEY ( ajuste_uuid, ajustable_tipo, ajustable_uuid )"

   METHOD getColumns()

   METHOD set( cAjusteUuid, cAjusteValue, cAjustableTipo, cAjustableUuid )

   METHOD setValue( cAjusteUuid, cAjusteValue, cAjustableTipo, cAjustableUuid )
   METHOD setLogic( cAjusteUuid, lAjusteValue, cAjustableTipo, cAjustableUuid )

   METHOD setUsuarioEmpresaExclusiva( cAjusteValue, cAjustableUuid )    INLINE ( ::setValue( 'empresa_exclusiva', cAjusteValue, 'usuarios', cAjustableUuid ) )
   METHOD setUsuarioCajaExclusiva( cAjusteValue, cAjustableUuid )       INLINE ( ::setValue( 'caja_exclusiva', cAjusteValue, 'usuarios', cAjustableUuid ) )

   METHOD setRolMostrarRentabilidad( cAjusteValue, cAjustableUuid )     INLINE ( ::setLogic( 'mostrar_rentabilidad', cAjusteValue, 'roles', cAjustableUuid ) )
   METHOD setRolCambiarPrecios( cAjusteValue, cAjustableUuid )          INLINE ( ::setLogic( 'cambiar_precios', cAjusteValue, 'roles', cAjustableUuid ) )
   METHOD setRolVerPreciosCosto( cAjusteValue, cAjustableUuid )         INLINE ( ::setLogic( 'ver_precios_costo', cAjusteValue, 'roles', cAjustableUuid ) )

   METHOD getValue( cUuid, cTipo, cAjuste, uDefault )
   METHOD getLogic( cUuid, cTipo, cAjuste, lDefault ) 

   METHOD getUsuarioEmpresaExclusiva( cUuid )                           INLINE ( ::getValue( cUuid, 'usuarios', 'empresa_exclusiva', space( 40 ) ) )   
   METHOD getUsuarioCajaExclusiva( cUuid )                              INLINE ( ::getValue( cUuid, 'usuarios', 'caja_exclusiva', space( 40 ) ) )   
   
   METHOD getRolMostrarRentabilidad( cUuid )                            INLINE ( ::getLogic( cUuid, 'roles', 'mostrar_rentabilidad', .t. ) )   
   METHOD getRolCambiarPrecios( cUuid )                                 INLINE ( ::getLogic( cUuid, 'roles', 'cambiar_precios', .t. ) )   
   METHOD getRolVerPreciosCosto( cUuid )                                INLINE ( ::getLogic( cUuid, 'roles', 'ver_precios_costo', .t. ) )   

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLajustableModel

   hset( ::hColumns, "id",             {  "create"    => "INTEGER AUTO_INCREMENT"                  ,;
                                          "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",           {  "create"    => "VARCHAR( 40 ) NOT NULL"                  ,;
                                          "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "ajuste_uuid",    {  "create"    => "VARCHAR( 40 ) NOT NULL"                  ,;
                                          "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "ajuste_valor",   {  "create"    => "VARCHAR( 100 )"                          ,;
                                          "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "ajustable_tipo", {  "create"    => "VARCHAR ( 100 ) NOT NULL"                ,;
                                          "default"   => {|| space( 100 ) } }                      )

   hset( ::hColumns, "ajustable_uuid", {  "create"    => "VARCHAR( 40 ) NOT NULL"                  ,;
                                          "default"   => {|| space( 40 ) } }                       )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD set( cAjusteUuid, cAjusteValue, cAjustableTipo, cAjustableUuid )

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "ajuste_uuid", cAjusteUuid )
   hset( hBuffer, "ajuste_valor", cAjusteValue )
   hset( hBuffer, "ajustable_tipo", cAjustableTipo )
   hset( hBuffer, "ajustable_uuid", cAjustableUuid )

RETURN ( ::insertOnDuplicate( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD setValue( cAjusteDescripcion, cAjusteValue, cAjustableTipo, cAjustableUuid )

   local cAjusteUuid := SQLAjustesModel():getAjusteUuid( cAjusteDescripcion )

   if empty( cAjusteUuid )
      RETURN ( nil )
   endif

RETURN ( ::set( cAjusteUuid, cAjusteValue, cAjustableTipo, cAjustableUuid ) )

//---------------------------------------------------------------------------//

METHOD setLogic( cAjusteDescripcion, lAjusteValue, cAjustableTipo, cAjustableUuid )

   local cAjusteValue    
   local cAjusteUuid    := SQLAjustesModel():getAjusteUuid( cAjusteDescripcion )

   if empty( cAjusteUuid )
      RETURN ( nil )
   endif

   cAjusteValue         := if( lAjusteValue, '1', '0' )

RETURN ( ::set( cAjusteUuid, cAjusteValue, cAjustableTipo, cAjustableUuid ) )

//---------------------------------------------------------------------------//

METHOD getValue( cUuid, cTipo, cAjuste, uDefault )

   local uValue
   local cSentence   

   if empty( cUuid ) .or. empty( cTipo ) .or. empty( cAjuste )
      RETURN ( uDefault )
   end if 

   cSentence         := "SELECT ajustables.ajuste_valor "
   cSentence         +=    "FROM ajustables AS ajustables "
   cSentence         += "INNER JOIN ajustes AS ajustes ON ajustes.uuid = ajustables.ajuste_uuid "
   cSentence         += "WHERE ajustes.ajuste = " + quoted( cAjuste ) + " "
   cSentence         +=    "AND ajustables.ajustable_tipo = " + quoted( cTipo ) + " "
   cSentence         +=    "AND ajustables.ajustable_uuid = " + quoted( cUuid ) 

   logwrite( cSentence )

   uValue            := ::getDatabase():selectValue( cSentence )

   if hb_ischar( uValue ) 
      RETURN ( uValue ) 
   endif

RETURN ( uDefault )

//---------------------------------------------------------------------------//

METHOD getLogic( cUuid, cTipo, cajuste, lDefault )

   local uValue   := ::getValue( cUuid, cTipo, cajuste, lDefault )

   if hb_ischar( uValue ) 
      RETURN ( uValue == '1' ) 
   endif

RETURN ( lDefault )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS AjustableRepository FROM SQLBaseRepository

   METHOD getTableName()      INLINE ( SQLAjustableModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

