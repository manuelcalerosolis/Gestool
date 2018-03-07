#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS SQLAjustableModel FROM SQLBaseModel

   DATA cTableName               INIT "ajustables"

   DATA cConstraints             INIT "PRIMARY KEY ( id ), UNIQUE KEY ( ajustable_tipo, ajustable_uuid )"

   METHOD getColumns()

   METHOD set( cAjusteUuid, cAjusteValue, cAjustableTipo, cAjustableUuid )

   METHOD setValue( cAjusteUuid, cAjusteValue, cAjustableTipo, cAjustableUuid )

   METHOD setUsuario( cAjusteUuid, cAjusteValue, cAjustableUuid ) ;
                                 INLINE ( ::set( cAjusteUuid, cAjusteValue, 'usuarios', cAjustableUuid ) )

   METHOD getValue()

   METHOD getLogic( cUuid, cTipo, cAjuste, lDefault ) 

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

METHOD setValue( cAjusteUuid, cAjusteValue, cAjustableTipo, cAjustableDescripcion )

   local cAjustableUuid

   cAjustableUuid    := SQLAjustesModel():getAjusteUuid( cAjustableDescripcion )

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

