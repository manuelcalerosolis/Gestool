#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS DelegacionesModel FROM ADSBaseModel

   METHOD getDelegacionTableName()                    INLINE ::getDatosTableName( "Delega" )

   METHOD UpdateDelegacionCodigoEmpresa()

   METHOD DeleteDelegacionesEmpresa( cCodigoEmpresa )

   METHOD arrayDelegaciones( cCodigoEmpresa )

END CLASS

//---------------------------------------------------------------------------//

METHOD UpdateDelegacionCodigoEmpresa()

   local cStm
   local cSql  := "UPDATE " + ::getDelegacionTableName() + " " + ;
                  "SET cCodEmp = CONCAT( '00', TRIM( cCodEmp ) ) WHERE ( LENGTH( cCodEmp ) < 4 )"

Return ( ::ExecuteSqlStatement( cSql, @cStm ) )

//---------------------------------------------------------------------------//

METHOD DeleteDelegacionesEmpresa( cCodigoEmpresa )

   local cStm
   local cSql  := "DELETE FROM " + ::getDelegacionTableName() + " " + ;
                  "WHERE cCodEmp = " + quoted( cCodigoEmpresa )

Return ( ::ExecuteSqlStatement( cSql, @cStm ) )

//---------------------------------------------------------------------------//

METHOD arrayDelegaciones( cCodigoEmpresa )

   local cStm
   local aDlg  := {}
   local cSql  := "SELECT cCodDlg FROM " + ::getDelegacionTableName() + " WHERE cCodEmp = " + quoted( cCodigoEmpresa )

   if ::ExecuteSqlStatement( cSql, @cStm )
      while !( cStm )->( eof() ) 
         aadd( aDlg, ( cStm )->cCodDlg )
         ( cStm )->( dbskip() )
      end while
   end if 

Return ( aDlg )

//---------------------------------------------------------------------------//
