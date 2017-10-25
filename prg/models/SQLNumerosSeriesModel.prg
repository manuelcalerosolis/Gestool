#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLNumerosSeriesModel FROM SQLBaseEmpresasModel

   DATA cTableName                  INIT "numeros_series"

   DATA aBuffer

   METHOD New()

   METHOD loadCurrentBuffer()
   METHOD updateCurrentBuffer()

   METHOD getUnidades()             INLINE ( ::oController:oDialogView:nTotalUnidades )
   METHOD getParentUuid()           INLINE ( ::oController:cParentUUID )

   METHOD loadBlankBuffer()
   METHOD loadBlankBufferFromUnits()

   METHOD RollBack()

   METHOD InsertOrUpdate()

   METHOD InsertRow( h )
   METHOD UpdateRow( h )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::cColumnKey      := "parent_uuid"

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
                                             "width"     => 120 }                                     )

   ::Super:New( oController )

RETURN ( Self )

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
      ::oDataBase:Exec( "DELETE FROM " + ::cTableName + " WHERE uuid NOT IN (" + cIds + ")" )
   end if

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD updateCurrentBuffer()

RETURN ( aEval( ::aBuffer, {|h| ::InsertOrUpdate( h ) } ) )

//---------------------------------------------------------------------------//

METHOD InsertOrUpdate( hRow )

   if hb_isnil( ::oDataBase:selectFetchHash( "SELECT * FROM " + ::cTableName + " WHERE uuid = " + quoted( hGet( hRow, "uuid" ) ) ) )
      ::insertRow( hRow )
   else
      ::updateRow( hRow )
   end if

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD insertRow( hRow )

   local cStatement  := ""

   cStatement        := "INSERT INTO "
   cStatement        += ::cTableName + Space( 1 )
   cStatement        += "( "
   hEval( hRow, {| k, v | if( k != "id", cStatement += k + ", ", ) } )
   cStatement        := chgAtEnd( cStatement, " ) VALUES ( ", 2 )
   hEval( hRow, {| k, v | if( k != "id", cStatement += quoted( v ) + ", ", ) } )
   cStatement        := chgAtEnd( cStatement, " )", 2 )

RETURN ( ::oDataBase:Exec( cStatement ) )

//---------------------------------------------------------------------------//

METHOD updateRow( hRow )

   MsgInfo( hb_valToExp( hRow ), "update" )

RETURN ( self )

//---------------------------------------------------------------------------//