#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLNumerosSeriesModel FROM SQLBaseEmpresasModel

   DATA cTableName                  INIT "numeros_series"

   DATA aBuffer

   METHOD New()

   METHOD loadCurrentBuffer()
   METHOD updateCurrentBuffer()     INLINE ( MsgInfo( "Guardo todo" ) ) //::getDatabase():Query( ::getUpdateSentence() ), ::buildRowSetAndFind() )

   METHOD getUnidades()             INLINE ( ::oController:oDialogView:nTotalUnidades )
   METHOD getParentUuid()           INLINE ( ::oController:cParentUUID )

   METHOD loadBlankBuffer()
   METHOD loadBlankBufferFromUnits()

   METHOD RollBack()

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
