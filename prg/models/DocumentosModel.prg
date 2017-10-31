#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS DocumentosModel FROM ADSBaseModel

   METHOD getTableName()                  INLINE ::getEmpresaTableName( "Rdocumen" ) 

   METHOD getWhereTipo()

   METHOD getWhereMovimientosAlmacen()    INLINE ( ::getWhereTipo( "RM" ) )

   METHOD getReportWhereCodigo()

   METHOD exist()

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

METHOD getReportWhereCodigo( cCodigo )

   local cStm
   local cSql  := "SELECT mReport "                         + ;
                     "FROM " + ::getTableName() + " "       + ;
                     "WHERE Codigo = " + quoted( cCodigo ) 

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( ( cStm )->mReport )
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


