#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS SQLUsuarioFavoritosModel FROM SQLBaseModel

   DATA cTableName               INIT "usuario_favoritos"

   DATA cConstraints             INIT "PRIMARY KEY ( id ), UNIQUE KEY ( usuario_uuid, favorito )"

   METHOD getColumns()

   METHOD set( cUsuarioUuid, cFavorito, lVisible )

   METHOD get( cUsuarioUuid, cFavorito )

   METHOD getVisible( cUsuarioUuid, cFavorito, lDefault )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLUsuarioFavoritosModel

   hset( ::hColumns, "id",             {  "create"    => "INTEGER AUTO_INCREMENT"                  ,;
                                          "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",           {  "create"    => "VARCHAR( 40 ) NOT NULL"                  ,;
                                          "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "usuario_uuid",   {  "create"    => "VARCHAR( 40 ) NOT NULL"                  ,;
                                          "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "favorito",       {  "create"    => "VARCHAR( 100 )"                          ,;
                                          "default"   => {|| space( 100 ) } }                      )

   hset( ::hColumns, "visible",        {  "create"    => "TINYINT UNSIGNED NOT NULL"               ,;
                                          "default"   => {|| 0 } }                                 )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD set( cUsuarioUuid, cFavorito, lVisible ) CLASS SQLUsuarioFavoritosModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "usuario_uuid",   cUsuarioUuid )
   hset( hBuffer, "favorito",       cFavorito )
   hset( hBuffer, "visible",        if( lVisible, '1', '0') )
 
RETURN ( ::insertOnDuplicate( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD get( cUsuarioUuid, cFavorito ) CLASS SQLUsuarioFavoritosModel

   local cSql     := "SELECT * FROM " + ::cTableName + " "
   cSql           +=    "WHERE usuario_uuid = " + quoted( cUsuarioUuid ) + " "
   cSql           +=    "AND favorito = " + quoted( cFavorito ) + " "

RETURN ( getSQLDataBase():getValue( cSql ) )

//---------------------------------------------------------------------------//

METHOD getVisible( cUsuarioUuid, cFavorito, lDefault ) CLASS SQLUsuarioFavoritosModel

   local nVisible
   local cSql     := "SELECT visible FROM " + ::cTableName + " "
   cSql           +=    "WHERE usuario_uuid = " + quoted( cUsuarioUuid ) + " "
   cSql           +=    "AND favorito = " + quoted( cFavorito ) + " "

   nVisible       := getSQLDataBase():getValue( cSql )
   if hb_isnil( nVisible )
      RETURN ( lDefault )
   end if 

RETURN ( nVisible == 1 )

//---------------------------------------------------------------------------//