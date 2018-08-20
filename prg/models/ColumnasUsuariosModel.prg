#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ColumnasUsuariosModel FROM ADSBaseModel

   DATA cTableName                              INIT "CfgUse"

   METHOD getHeaderTableName()                  INLINE ::getEmpresaTableName()

   METHOD getStruct()

   METHOD getIndexes()

   METHOD set()

   METHOD get()
      METHOD getState( cBrowseName )            

   METHOD exist()

   METHOD insert()

   METHOD update()

   METHOD delete()

END CLASS

//---------------------------------------------------------------------------//

METHOD getStruct()

   local aStruct  := {}

   aAdd( aStruct, { "cCodUse",  "C",  3, 0, "Código usuario"           } )
   aAdd( aStruct, { "cNomCfg",  "C", 30, 0, "Nombre ventana"           } )
   aAdd( aStruct, { "nRecCfg",  "N", 10, 0, "Recno de la ventana"      } )
   aAdd( aStruct, { "nTabCfg",  "N", 10, 0, "Orden de la ventana"      } )
   aAdd( aStruct, { "cOrdCfg",  "C", 60, 0, "Tag de la ventana"        } )
   aAdd( aStruct, { "cBrwCfg",  "M", 10, 0, "Configuración del browse" } )

Return ( aStruct )

//---------------------------------------------------------------------------//

METHOD getIndexes()

   local aIndexes    := {}

   aAdd( aIndexes, { "cCodUse",  "cCodUse + cNomCfg", {|| Field->cCodUse + Field->cNomCfg }, .f. } )

Return ( aIndexes )

//---------------------------------------------------------------------------//

METHOD set( cBrowseName, cBrowseState, nBrowseRecno, nBrowseOrder )

   if ::exist( cBrowseName )
      RETURN ( ::update( cBrowseName, cBrowseState, nBrowseRecno, nBrowseOrder ) )
   end if 

RETURN ( ::insert( cBrowseName, cBrowseState, nBrowseRecno, nBrowseOrder ) )

//---------------------------------------------------------------------------//

METHOD get( cBrowseName )

   local cStm
   local cSql  := "SELECT * " + ;
                     "FROM " + ::getHeaderTableName() + " "             + ;
                     "WHERE cCodUse = " + quoted( Auth():Codigo() ) + " AND " + ;
                           "cNomCfg = " + quoted( cBrowseName )

   if ::ExecuteSqlStatement( cSql, @cStm )

      RETURN ( {  "State"  => ( cStm )->cBrwCfg,;
                  "Recno"  => ( cStm )->nRecCfg,;
                  "Order"  => ( cStm )->nTabCfg } )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getState( cBrowseName )

   local hBrowse  := ::get( cBrowseName ) 

   if empty( hBrowse )
      RETURN ( "" )
   end if 

RETURN ( hget( hBrowse, "State" ) )

//---------------------------------------------------------------------------//

METHOD exist( cBrowseName )

   local cStm
   local cSql  := "SELECT cBrwCfg " + ;
                     "FROM " + ::getHeaderTableName() + " "             + ;
                     "WHERE cCodUse = " + quoted( Auth():Codigo() ) + " AND " + ;
                           "cNomCfg = " + quoted( cBrowseName )

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( ( cStm )->( lastrec() ) > 0 )
   end if 

RETURN ( .f. )

//---------------------------------------------------------------------------//

METHOD insert( cBrowseName, cBrowseState, nBrowseRecno, nBrowseOrder )

   local cStm
   local cSql  

   DEFAULT nBrowseRecno    := 0
   DEFAULT nBrowseOrder    := 0

   cSql                    := "INSERT INTO " + ::getHeaderTableName() + " "      
   cSql                    +=    "( cCodUse, "                                   
   cSql                    +=       "cNomCfg, "   
   if !empty( cBrowseState )                               
      cSql                 +=       "cBrwCfg, "
   endif
   cSql                    +=       "nRecCfg, "                                  
   cSql                    +=       "nTabCfg ) "                                 
   cSql                    += "VALUES "                                          
   cSql                    +=    "( " + quoted( Auth():Codigo() ) + ", "
   cSql                    +=       quoted( cBrowseName ) + ", "
   if !empty( cBrowseState )                               
      cSql                 +=       quoted( cBrowseState ) + ", "
   endif
   cSql                    +=       alltrim( str( nBrowseRecno ) ) + ", "             
   cSql                    +=       alltrim( str( nBrowseOrder ) ) + " )"             

RETURN ( ::ExecuteSqlStatement( cSql, @cStm ) )

//---------------------------------------------------------------------------//

METHOD update( cBrowseName, cBrowseState, nBrowseRecno, nBrowseOrder )

   local cStm
   local cSql

   DEFAULT nBrowseRecno    := 0
   DEFAULT nBrowseOrder    := 0

   cSql                    := "UPDATE " + ::getHeaderTableName() + " "
   cSql                    +=    "SET "
   if !empty(cBrowseState)
      cSql                 +=       "cBrwCfg = " + quoted( cBrowseState ) + ", "
   end if 
   cSql                    +=       "nRecCfg = " + alltrim( str( nBrowseRecno ) ) + ", " 
   cSql                    +=       "nTabCfg = " + alltrim( str( nBrowseOrder ) ) + " "  
   cSql                    +=    "WHERE cCodUse = " + quoted( Auth():Codigo() ) + " AND " 
   cSql                    +=        "cNomCfg = " + quoted( cBrowseName )

RETURN ( ::ExecuteSqlStatement( cSql, @cStm ) )

//---------------------------------------------------------------------------//

METHOD delete( cBrowseName )

   local cStm
   local cSql  := "DELETE FROM " + ::getHeaderTableName() + " "         + ;
                     "WHERE cCodUse = " + quoted( Auth():Codigo() ) + " AND " + ;
                           "cNomCfg = " + quoted( cBrowseName )

RETURN ( ::ExecuteSqlStatement( cSql, @cStm ) )

//---------------------------------------------------------------------------//
