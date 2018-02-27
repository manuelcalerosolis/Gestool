#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS SQLajustableModel FROM SQLBaseModel

   DATA cTableName               INIT "ajustables"

   DATA cConstraints             INIT "PRIMARY KEY (id), KEY (uuid)"

   METHOD getColumns()

   METHOD set( ajusteUuid, ajusteValue, ajustableTipo, ajustableUuid )

   METHOD setUsuario( ajusteUuid, ajusteValue, ajustableUuid ) ;
            INLINE ( ::set( ajusteUuid, ajusteValue, 'usuarios', ajustableUuid ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLajustableModel

   hset( ::hColumns, "id",             {  "create"    => "INTEGER AUTO_INCREMENT"                  ,;
                                          "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",           {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"             ,;
                                          "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "ajuste_uuid",    {  "create"    => "VARCHAR(40) NOT NULL"                    ,;
                                          "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "ajuste_valor",   {  "create"    => "VARCHAR(10)"                             ,;
                                          "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "ajustable_tipo", {  "create"    => "VARCHAR ( 100 ) NOT NULL"                ,;
                                          "default"   => {|| space( 100 ) } }                      )

   hset( ::hColumns, "ajustable_uuid", {  "create"    => "VARCHAR(40) NOT NULL"                    ,;
                                          "default"   => {|| space( 40 ) } }                       )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD set( ajusteUuid, ajusteValue, ajustableTipo, ajustableUuid )

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "ajuste_uuid", ajusteUuid )
   hset( hBuffer, "ajuste_valor", ajusteValue )
   hset( hBuffer, "ajustable_tipo", ajustableTipo )
   hset( hBuffer, "ajustable_uuid", ajustableUuid )

RETURN ( ::insertOnDuplicate( hBuffer ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS AjustableRepository FROM SQLBaseRepository

   METHOD getTableName()      INLINE ( SQLAjustableModel():getTableName() ) 

   METHOD getValue()

   METHOD getLogic( cUuid, cTipo, cajuste, lDefault ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD getValue( cUuid, cTipo, cAjuste, uDefault )

   local uValue
   local cSentence   

   default cTipo     := 'usuarios'
   default cAjuste   := 'mostrar_rentabilidad'

   cSentence         := "SELECT ajustables.ajuste_valor "
   cSentence         +=    "FROM ajustables AS ajustables "
   cSentence         += "INNER JOIN ajustes AS ajustes ON ajustes.uuid = ajustables.ajuste_uuid "
   cSentence         += "WHERE ajustes.ajuste = " + quoted( cajuste ) + " "
   cSentence         +=    "AND ajustables.ajustable_tipo = " + quoted( cTipo ) + " "
   cSentence         +=    "AND ajustables.ajustable_uuid = " + quoted( cUuid ) 

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
