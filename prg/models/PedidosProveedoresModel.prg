#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS PedidosProveedoresModel FROM BaseModel

   CLASSDATA cHeader                            INIT  "Header"

   METHOD getHeaderTableName()                  INLINE ::getEmpresaTableName( "PedProvT" )
   METHOD getLineTableName()                    INLINE ::getEmpresaTableName( "PedProvL" )
   METHOD getIncidenceTableName()               INLINE ::getEmpresaTableName( "PedPrvI" )
   METHOD getDocumentsTableName()               INLINE ::getEmpresaTableName( "PedPrvD")

   METHOD selectPedidosProveedoresLineasId( cSerie, nNumero, cSufijo )

   METHOD deletePedidosProveedoresLineasId( cSerie, nNumero, cSufijo ) ;
                                                INLINE ::deleteDetailsById( cSerie, nNumero, cSufijo, ::getLineTableName() ) 

   METHOD deletePedidosProveedoresIncidenciasId( cSerie, nNumero, cSufijo ) ;
                                                INLINE ::deleteDetailsById( cSerie, nNumero, cSufijo, ::getIncidenceTableName() )

   METHOD deletePedidosProveedoresDocumentosId( cSerie, nNumero, cSufijo ) ;
                                                INLINE :: deleteDetailsById( cSerie, nNumero, cSufijo, ::getDocumentsTableName() )

   METHOD deleteDetailsById( cSerie, nNumero, cSufijo, cTableName )

   METHOD selectPedidosProveedoresPendientes( idProveedor, cAlias )

   METHOD selectPedidosProveedoresLineasToArray( aPedidos, cAlias )

END CLASS

//---------------------------------------------------------------------------//

METHOD selectPedidosProveedoresLineasId( cSerie, nNumero, cSufijo )

   local cSql  := ""

   cSql        := "SELECT * FROM " + ::getLineTableName() + " " + ;
                           "WHERE " + ;
                              "cSerPed = " + quoted( cSerie )  + " AND " + ;
                              "nNumPed = " + quoted( nNumero ) + " AND " + ;
                              "cSufPed = " + quoted( cSufijo )   

Return ( ::ExecuteSqlStatement( cSql, ::cHeader ) )

//---------------------------------------------------------------------------//

METHOD deleteDetailsById( cSerie, nNumero, cSufijo, cTableName )        

   local cSql  := ""

   cSql        := "DELETE FROM " + cTableName + " " + ;
                           "WHERE " + ;
                              "cSerPed = " + quoted( cSerie )  + " AND " + ;
                              "nNumPed = " + quoted( nNumero ) + " AND " + ;
                              "cSufPed = " + quoted( cSufijo )   

Return ( ::ExecuteSqlStatement( cSql ) )

//---------------------------------------------------------------------------//

METHOD selectPedidosProveedoresPendientes( idProveedor, cAlias )

   local cSql  := "SELECT * FROM " + ::getHeaderTableName() + " " + ;
                           "WHERE " + ;
                              "cCodPrv = " + quoted( idProveedor )  + " AND " + ;
                              "nEstado = 1"

Return ( ::ExecuteSqlStatement( cSql, @cAlias ) )

//---------------------------------------------------------------------------//

METHOD selectPedidosProveedoresLineasToArray( aPedidos, cAlias )

   local cPedido
   local cSql  := "SELECT * FROM " + ::getLineTableName() + " " + ;
                           "WHERE " + ;
                              "cCodPrv = " + quoted( idProveedor )  + " AND " + ;
                              "nEstado = 1"

   for each cPedido in aPedidos

      msgInfo( cPedido, "cPedido" )

   next

   MsgInfo( cSql, "cSql" )

Return .t.

//Return ( ::ExecuteSqlStatement( cSql, @cAlias ) )

//---------------------------------------------------------------------------//