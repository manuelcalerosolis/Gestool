#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLNumerosSeriesModel FROM SQLBaseEmpresasModel

   DATA cTableName                  INIT "numeros_series"

   DATA aBuffer

   METHOD getColumns()

   METHOD loadCurrentBuffer()
   METHOD updateCurrentBuffer()

   METHOD getUnidades()             INLINE ( ::oController:oDialogView:nTotalUnidades )
   METHOD getParentUuid()           INLINE ( ::oController:cParentUUID )

   METHOD loadBlankBuffer()
   METHOD loadBlankBufferFromUnits()

   METHOD RollBack()

   METHOD InsertOrUpdate()

   METHOD deleteWhereUuid( uuid )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns()

   hset( ::hColumns, "id",                {  "create"    => "INTEGER PRIMARY KEY AUTO_INCREMENT"      ,;
                                             "text"      => "Identificador"                           ,;
                                             "header"    => "Id"                                      ,;
                                             "visible"   => .t.                                       ,;
                                             "width"     => 40 }                                      )   

   hset( ::hColumns, "uuid",              {  "create"    => "VARCHAR(40) NOT NULL"                    ,;
                                             "text"      => "Uuid"                                    ,;
                                             "header"    => "Uuid"                                    ,;
                                             "visible"   => .f.                                       ,;
                                             "width"     => 240                                       ,;
                                             "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "parent_uuid",       {  "create"    => "VARCHAR(40) NOT NULL"                    ,;
                                             "text"      => "parent_uuid"                             ,;
                                             "header"    => "Parent uuid"                             ,;
                                             "visible"   => .f.                                       ,;
                                             "width"     => 240 }                                     )

   hset( ::hColumns, "numero_serie",      {  "create"    => "VARCHAR(30) NOT NULL"                    ,;
                                             "text"      => "Número serie"                            ,;
                                             "header"    => "Número serie"                            ,;
                                             "visible"   => .t.                                       ,;
                                             "width"     => 120                                       ,;
                                             "default"   => Space( 30 ) }                             )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD loadCurrentBuffer()  

   ::aBuffer            := ::oDatabase:selectFetchHash( "SELECT * FROM " + ::cTableName + " WHERE parent_uuid = " + quoted( ::getParentUuid() ) )

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

      nTo   := ::getUnidades() - len( ::aBuffer )

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

METHOD updateCurrentBuffer()

   local h

   for each h in ::aBuffer
      ::InsertOrUpdate( h )
   next

   //aEval( ::aBuffer, {|h| ::InsertOrUpdate( h ) } )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD InsertOrUpdate( hRow )

   if hb_isnil( ::oDataBase:selectFetchHash( "SELECT * FROM " + ::cTableName + " WHERE uuid = " + quoted( hGet( hRow, "uuid" ) ) ) )
      ::insertBuffer( hRow )
   else
      ::updateBuffer( hRow )
   end if

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD deleteWhereUuid( uuid )

   local cSentence := "DELETE FROM " + ::cTableName + " " + ;
                              "WHERE parent_uuid = " + quoted( uuid )

RETURN ( ::getDatabase():Exec( cSentence ) )

//---------------------------------------------------------------------------//