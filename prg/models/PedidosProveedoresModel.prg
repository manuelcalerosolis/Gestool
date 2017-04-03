#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS PedidosProveedoresModel FROM BaseModel

   METHOD getHeaderTableName()                  INLINE ::getEmpresaTableName( "PedProvT" )
   METHOD getLineTableName()                    INLINE ::getEmpresaTableName( "PedProvL" )
   METHOD getIncidenceTableName()               INLINE ::getEmpresaTableName( "PedPrvI" )
   METHOD getDocumentsTableName()               INLINE ::getEmpresaTableName( "PedPrvD")

   METHOD deletePedidosProveedoresLineasId( cSerie, nNumero, cSufijo ) ;
                                                INLINE ::deleteDetailsById( cSerie, nNumero, cSufijo, ::getLineTableName() ) 

   METHOD deletePedidosProveedoresIncidenciasId( cSerie, nNumero, cSufijo ) ;
                                                INLINE ::deleteDetailsById( cSerie, nNumero, cSufijo, ::getIncidenceTableName() )

   METHOD deletePedidosProveedoresDocumentosId( cSerie, nNumero, cSufijo ) ;
                                                INLINE :: deleteDetailsById( cSerie, nNumero, cSufijo, ::getDocumentsTableName() )

   METHOD deleteDetailsById( cSerie, nNumero, cSufijo, cTableName )



END CLASS

//---------------------------------------------------------------------------//

METHOD deleteDetailsById( cSerie, nNumero, cSufijo, cTableName )        

   local cSql  := ""

   cSql        := "DELETE FROM " + cTableName + " " + ;
                           "WHERE " + ;
                              "cSerPed = " + quoted( cSerie )  + " AND " + ;
                              "nNumPed = " + quoted( nNumero ) + " AND " + ;
                              "cSufPed = " + quoted( cSufijo )   

   msgalert( cSql )                              

Return ( ::ExecuteSqlStatement( cSql ) )

//---------------------------------------------------------------------------//