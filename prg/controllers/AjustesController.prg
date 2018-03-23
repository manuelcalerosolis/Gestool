#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS AjustesController FROM SQLNavigatorController

   METHOD New()

   METHOD End()

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS AjustesController

   ::Super:New()

   ::cTitle                := "Ajustes"

   ::setName( "ajustes" )

   ::lTransactional        := .t.

   ::hImage                := { "16" => "gc_businesspeople_16" }

   ::nLevel                := Auth():Level( "01052" )

   ::oModel                := SQLAjustesModel():New( self )

   ::oRepository           := AjustesRepository():New( self )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End()

   if !empty(::oModel)
      ::oModel:End()
   endif

   ::Super:End()

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLAjustesModel FROM SQLBaseModel

   DATA cTableName               INIT "ajustes"

   DATA cConstraints             INIT "PRIMARY KEY (id), KEY (ajuste)"

   METHOD getColumns()

   METHOD getInsertAjustesSentence()

   METHOD getAjusteUuidSentence( cAjuste )

   METHOD getAjusteUuid( cAjuste )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLAjustesModel

   hset( ::hColumns, "id",             {  "create"    => "INTEGER AUTO_INCREMENT"                  ,;
                                          "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",           {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"             ,;
                                          "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "ajuste",         {  "create"    => "VARCHAR ( 100 ) NOT NULL UNIQUE"         ,;
                                          "default"   => {|| space( 100 ) } }                      )

   hset( ::hColumns, "sistema",        {  "create"    => "TINYINT ( 1 )"                          ,;
                                          "default"   => {|| "1" } }                    )

   hset( ::hColumns, "tipo_dato",      {  "create"    => "VARCHAR ( 12 )"                          ,;
                                          "default"   => {|| "alphanumeric" } }                    )

   hset( ::hColumns, "valor_minimo",   {  "create"    => "INT"                                     ,;
                                          "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "valor_maximo",   {  "create"    => "INT"                                     ,;
                                          "default"   => {|| 0 } }                                 )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getInsertAjustesSentence()

   local cSentence 

   cSentence  := "INSERT IGNORE INTO " + ::cTableName + " "
   cSentence  +=    "( uuid, ajuste, sistema, tipo_dato, valor_minimo, valor_maximo ) "
   cSentence  += "VALUES "
   cSentence  +=    "( UUID(), 'empresa_exclusiva',         '1',  'alphanumeric', NULL, NULL ), "
   cSentence  +=    "( UUID(), 'caja_exclusiva',            '1',  'alphanumeric', NULL, NULL ), "
   cSentence  +=    "( UUID(), 'pc_en_uso',                 '1',  'alphanumeric', NULL, NULL ), "
   cSentence  +=    "( UUID(), 'empresa_en_uso',            '1',  'alphanumeric', NULL, NULL ), "
   cSentence  +=    "( UUID(), 'mostrar_rentabilidad',      '1',  'boolean',      NULL, NULL ), "
   cSentence  +=    "( UUID(), 'cambiar_precios',           '1',  'boolean',      NULL, NULL ), "
   cSentence  +=    "( UUID(), 'ver_precios_costo',         '1',  'boolean',      NULL, NULL ), "
   cSentence  +=    "( UUID(), 'confirmacion_eliminacion',  '1',  'boolean',      NULL, NULL ), "
   cSentence  +=    "( UUID(), 'fitrar_ventas_por_usuario', '1',  'boolean',      NULL, NULL ),"
   cSentence  +=    "( UUID(), 'abrir_cajon_portamonedas',  '1',  'boolean',      NULL, NULL )"

RETURN ( cSentence )

//---------------------------------------------------------------------------//

METHOD getAjusteUuidSentence( cAjuste )

   local cSentence

   cSentence  := "SELECT uuid FROM " + ::cTableName + " "
   cSentence  +=    "WHERE ajuste = " + quoted( cAjuste )

RETURN ( cSentence )

//---------------------------------------------------------------------------//

METHOD getAjusteUuid( cAjuste )

RETURN ( ::getDatabase():getValue( ::getAjusteUuidSentence( cAjuste ) ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS AjustesRepository FROM SQLBaseRepository

   METHOD getTableName()      INLINE ( SQLAjustesModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
