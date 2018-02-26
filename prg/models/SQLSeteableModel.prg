#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS SQLSeteableModel FROM SQLBaseModel

   DATA cTableName               INIT "Seteables"

   DATA cConstraints             INIT "PRIMARY KEY (id), KEY (uuid)"

   METHOD getColumns()

   METHOD set( settingUuid, settingValue, seteableType, seteableUuid )

   METHOD setUsuario( settingUuid, settingValue, seteableUuid ) ;
            INLINE ( ::set( settingUuid, settingValue, 'usuarios', seteableUuid ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLSeteableModel

   hset( ::hColumns, "id",             {  "create"    => "INTEGER AUTO_INCREMENT"                  ,;
                                          "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",           {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"             ,;
                                          "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "setting_uuid",   {  "create"    => "VARCHAR(40) NOT NULL"                    ,;
                                          "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "setting_value",  {  "create"    => "VARCHAR(10)"                             ,;
                                          "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "seteable_type",  {  "create"    => "VARCHAR ( 100 ) NOT NULL"                ,;
                                          "default"   => {|| space( 100 ) } }                      )

   hset( ::hColumns, "seteable_uuid",  {  "create"    => "VARCHAR(40) NOT NULL"                    ,;
                                          "default"   => {|| space( 40 ) } }                       )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD set( settingUuid, settingValue, seteableType, seteableUuid )

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "setting_uuid", settingUuid )
   hset( hBuffer, "setting_value", settingValue )
   hset( hBuffer, "seteable_type", seteableType )
   hset( hBuffer, "seteable_uuid", seteableUuid )

RETURN ( ::insertOnDuplicate( hBuffer ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SeteableRepository FROM SQLBaseRepository

   METHOD getTableName()      INLINE ( SQLSeteableModel():getTableName() ) 

   METHOD getValue()

   METHOD getLogic( cUuid, cType, cSetting, lDefault ) 
   
END CLASS

//---------------------------------------------------------------------------//

METHOD getValue( cUuid, cType, cSetting, uDefault )

   local uValue
   local cSentence   

   default cType     := 'usuarios'
   default cSetting  := 'mostrar_rentabilidad'

   cSentence         := "SELECT seteables.setting_value "
   cSentence         +=    "FROM seteables AS seteables "
   cSentence         += "INNER JOIN settings AS settings ON settings.uuid = seteables.setting_uuid "
   cSentence         += "WHERE settings.setting = " + quoted( cSetting ) + " "
   cSentence         +=    "AND seteables.seteable_type = " + quoted( cType ) + " "
   cSentence         +=    "AND seteables.seteable_uuid = " + quoted( cUuid ) 

   uValue            := ::getDatabase():selectValue( cSentence )

RETURN ( uValue )

//---------------------------------------------------------------------------//

METHOD getLogic( cUuid, cType, cSetting, lDefault )

   local uValue   := ::getValue( cUuid, cType, cSetting, lDefault )

   if hb_ischar( uValue ) 
      RETURN ( uValue == '1' ) 
   endif

RETURN ( lDefault )

//---------------------------------------------------------------------------//
