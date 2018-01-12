#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS DocumentosModel FROM ADSBaseModel

   METHOD getTableName()                     INLINE ::getEmpresaTableName( "Rdocumen" ) 

   METHOD getWhereTipo()

   METHOD getWhereMovimientosAlmacen()       INLINE ( ::getWhereTipo( "RM" ) )

   METHOD getWhereCodigo( cCodigo, cField )

   METHOD getDescripWhereCodigo( cCodigo )   INLINE ( ::getWhereCodigo( cCodigo, 'cDescrip' ) )

   METHOD setReportWhereCodigo( cCodigo, cReport )

   METHOD getReportWhereCodigo( cCodigo )    

   METHOD exist()

   METHOD encodeSemicolons( cText )          INLINE ( SQLDatabase():escapeStr( cText ) )

   METHOD decodeSemicolons( cText )          INLINE ( strtran( cText, "&quot;", "'" ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD getWhereTipo( cTipo )

   local cStm
   local cSql  := "SELECT Codigo, cDescrip "                + ;
                     "FROM " + ::getTableName() + " "       + ;
                     "WHERE cTipo = " + quoted( cTipo ) 

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( fetchHashFromWorkArea( cStm ) )
   end if 

RETURN ( cStm )

//---------------------------------------------------------------------------//

METHOD getWhereCodigo( cCodigo, cField )

   local cStm
   local cSql  := "SELECT " + cField + " "                  + ;
                     "FROM " + ::getTableName() + " "       + ;
                     "WHERE Codigo = " + quoted( cCodigo ) 

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( ( cStm )->( fieldget( fieldpos( cField ) ) ) )
   end if 

RETURN ( "" )

//---------------------------------------------------------------------------//

METHOD exist( cCodigo )

   local cStm  
   local cSql  := "SELECT Codigo "                                      + ;
                     "FROM " + ::getTableName() + " "                   + ;
                     "WHERE Codigo = " + quoted( cCodigo ) 

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( ( cStm )->( lastrec() ) > 0 )
   end if 

RETURN ( .f. )

//---------------------------------------------------------------------------//

METHOD setReportWhereCodigo( cCodigo, cReport )

   local cStm  
   local cSql  := "UPDATE " + ::getTableName() + " "                                         + ;
                     "SET mReport = " + quoted( SQLDatabase():escapeStr( cReport ) )  + " "    + ;   
                     "WHERE Codigo = " + quoted( cCodigo ) 
   
   logwrite( cSql )
   msgalert( cSql, "cSql" )

RETURN ( ::ExecuteSqlStatement( cSql, @cStm ) )

//---------------------------------------------------------------------------//

METHOD getReportWhereCodigo( cCodigo )

   local cStm
   local cSql  := "SELECT mReport "                         + ;
                     "FROM " + ::getTableName() + " "       + ;
                     "WHERE Codigo = " + quoted( cCodigo ) 

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( ( cStm )->( fieldget( fieldpos( 'mReport' ) ) ) ) 
   end if 

RETURN ( "" )

//---------------------------------------------------------------------------//

