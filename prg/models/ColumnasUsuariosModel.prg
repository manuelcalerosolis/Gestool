#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ColumnasUsuariosModel FROM BaseModel

   METHOD getHeaderTableName()                  INLINE ::getEmpresaTableName( "CfgUse" )

   METHOD set()

   METHOD get()
      METHOD getState( cBrowseName )            

   METHOD exist()

   METHOD insert()

   METHOD update()

   METHOD delete()

END CLASS

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
                     "WHERE cCodUse = " + quoted( cCurUsr() ) + " AND " + ;
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
                     "WHERE cCodUse = " + quoted( cCurUsr() ) + " AND " + ;
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
   cSql                    +=    "( " + quoted( cCurUsr() ) + ", "
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
   cSql                    +=    "WHERE cCodUse = " + quoted( cCurUsr() ) + " AND " 
   cSql                    +=        "cNomCfg = " + quoted( cBrowseName )

RETURN ( ::ExecuteSqlStatement( cSql, @cStm ) )

//---------------------------------------------------------------------------//

METHOD delete( cBrowseName )

   local cStm
   local cSql  := "DELETE FROM " + ::getHeaderTableName() + " "         + ;
                     "WHERE cCodUse = " + quoted( cCurUsr() ) + " AND " + ;
                           "cNomCfg = " + quoted( cBrowseName )

RETURN ( ::ExecuteSqlStatement( cSql, @cStm ) )

//---------------------------------------------------------------------------//
