#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLMovimientosAlmacenLineasNumerosSeriesModel FROM SQLExportableModel

   DATA cTableName                  INIT "movimientos_almacen_lineas_numeros_series"

   DATA cConstraints                INIT  "PRIMARY KEY (id), KEY (uuid), KEY( parent_uuid )"                                      

   DATA aBuffer

   METHOD getColumns()

   METHOD loadCurrentBuffer()

   METHOD getUpdateSentence()

   METHOD getUnidades()             INLINE ( ::oController:oDialogView:nTotalUnidades )

   METHOD loadBlankBufferFromUnits()

   METHOD RollBack()

   METHOD InsertOrUpdate()

   METHOD getSentenceNotSent( hFetch )

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

   local cSentence   := "SELECT * FROM " + ::cTableName + " " + ;
                          "WHERE parent_uuid = " + quoted( ::oController:getSenderController():getUuid() ) 

   ::aBuffer         := ::oDatabase:selectFetchHash( cSentence )

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
         aadd( ::aBuffer, ::loadBlankBuffer() )
      next

   else

      asize( ::aBuffer, ::getUnidades() )

   end if

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD RollBack()

   local hBuffer
   local cSentence 

   if empty( ::aBuffer )
      RETURN ( self )
   end if 

   cSentence         := "DELETE FROM " + ::cTableName + " " + ;
                           "WHERE uuid NOT IN ("
   
   aEval( ::aBuffer, {|h| cSentence += quoted( hGet( h, "uuid" ) ) + "," } )

   cSentence         := chgAtEnd( cSentence, " ) ", 1 )

   cSentence         +=       "AND parent_uuid = " + quoted( ::oController:getSenderController():getUuid() )

   ::oDatabase:Exec( cSentence )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD getUpdateSentence()

   local hBuffer
   local aSentence   := {}

   aeval( ::aBuffer, {|hBuffer| aadd( aSentence, ::InsertOrUpdate( hBuffer ) ) } )

RETURN ( aSentence )

//---------------------------------------------------------------------------//

METHOD InsertOrUpdate( hBuffer )

   if empty( hGet( hBuffer, "id" ) )
      RETURN ( ::super:getInsertSentence( hBuffer ) )
   end if

RETURN ( ::super:getUpdateSentence( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD getSentenceNotSent( aFetch )

   local cSentence   := "SELECT * FROM " + ::cTableName + " "

   cSentence         +=    "WHERE parent_uuid IN ( " 

   aeval( aFetch, {|h| cSentence += toSQLString( hget( h, "uuid" ) ) + ", " } )

   cSentence         := chgAtEnd( cSentence, ' )', 2 )

RETURN ( cSentence )

//---------------------------------------------------------------------------//