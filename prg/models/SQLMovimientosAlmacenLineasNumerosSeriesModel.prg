#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLMovimientosAlmacenLineasNumerosSeriesModel FROM SQLBaseModel

   DATA cTableName                  INIT "movimientos_almacen_lineas_numeros_series"

   DATA cConstraints                INIT  "PRIMARY KEY (id), KEY (uuid)"                                      

   DATA aBuffer

   METHOD getColumns()

   METHOD loadCurrentBuffer()
   METHOD updateBuffer()

   METHOD getUnidades()             INLINE ( ::oController:oDialogView:nTotalUnidades )
   METHOD getParentId()             INLINE ( ::oController:cParentId )

   METHOD loadBlankBuffer()
   METHOD loadBlankBufferFromUnits()

   METHOD RollBack()

   METHOD InsertOrUpdate()

   METHOD deleteWhereId( uuid )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns()

   hset( ::hColumns, "id",                {  "create"    => "INTEGER AUTO_INCREMENT"                  ,;
                                             "default"   => {|| 0 } }                                 )   

   hset( ::hColumns, "uuid",              {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;
                                             "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "parent_uuid",       {  "create"    => "VARCHAR( 40 ) NOT NULL "                 ,;
                                             "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "numero_serie",      {  "create"    => "VARCHAR( 30 ) NOT NULL"                  ,;
                                             "default"   => {|| space( 30 ) } }                       )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD loadCurrentBuffer()  

   ::aBuffer            := ::oDatabase:selectFetchHash(  "SELECT * FROM " + ::cTableName + " " +       ;
                                                            "WHERE parent_uuid = " + quoted( ::getParentUuid() ) )

   ::loadBlankBufferFromUnits()

RETURN ( ::aBuffer )

//---------------------------------------------------------------------------//

METHOD loadBlankBufferFromUnits()

   local n
   local nTo

   if hb_isnil( ::aBuffer )
      ::aBuffer   := {}
   end if

   if len( ::aBuffer ) < ::getUnidades()

      nTo         := ::getUnidades() - len( ::aBuffer )

      for n := 1 to nTo
         aAdd( ::aBuffer, ::loadBlankBuffer() )
      next

   else

      aSize( ::aBuffer, ::getUnidades() )

   end if

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD loadBlankBuffer()

   ::super:loadBlankBuffer()

   hset( ::hBuffer, "parent_uuid", ::getParentUuid() )

Return ( ::hBuffer )

//---------------------------------------------------------------------------//

METHOD RollBack()

   local hBuffer
   local cIds     := ""

   aEval( ::aBuffer, {|h| cIds += quoted( hGet( h, "uuid" ) ) + "," } )

   cIds           := chgAtEnd( cIds, "", 1 )

   if !Empty( cIds )
      ::oDataBase:Exec( "DELETE FROM " + ::cTableName + " WHERE uuid NOT IN (" + cIds + ") AND parent_uuid = " + quoted( ::getParentUuid() ) )
   end if

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD updateBuffer()

   local hBuffer

   msgalert( hb_valtoexp( ::aBuffer ), "::aBuffer en ::updateBuffer" )

   for each hBuffer in ::aBuffer
      ::InsertOrUpdate( hBuffer )
   next

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD InsertOrUpdate( hBuffer )

   local cSentence   := "SELECT * FROM " + ::cTableName + " WHERE id = " + quoted( hGet( hBuffer, "id" ) )
   local hResult     := ::oDataBase:selectFetchHash( cSentence )

   msgalert( cSentence, "InsertOrUpdate" )

   msgalert( hResult, "InsertOrUpdate" )

   if hb_isnil( hResult )
      ::super:insertBuffer( hBuffer )
   else
      ::super:updateBuffer( hBuffer )
   end if

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD deleteWhereId( id )

   local cSentence := "DELETE FROM " + ::cTableName + " WHERE parent_id = " + quoted( id )

RETURN ( ::getDatabase():Exec( cSentence ) )

//---------------------------------------------------------------------------//