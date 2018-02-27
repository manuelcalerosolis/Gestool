#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS EmpresasModel FROM ADSBaseModel

   METHOD getEmpresaTableName()                       INLINE ::getDatosTableName( "Empresa" )

   METHOD UpdateEmpresaCodigoEmpresa()

   METHOD getCodigoActiva()

   METHOD getCodigoGrupo( cCodigoEmpresa )

   METHOD getRegistrosActivos()

   METHOD getPrimera()

   METHOD getCodigoGrupoCliente( cCodigoEmpresa )     INLINE ( ::getCodigoGrupoCampoLogico( cCodigoEmpresa, "lGrpCli" ) )

   METHOD getCodigoGrupoProveedor( cCodigoEmpresa )   INLINE ( ::getCodigoGrupoCampoLogico( cCodigoEmpresa, "lGrpPrv" ) )

   METHOD getCodigoGrupoArticulo( cCodigoEmpresa )    INLINE ( ::getCodigoGrupoCampoLogico( cCodigoEmpresa, "lGrpArt" ) )

   METHOD getCodigoGrupoAlmacen( cCodigoEmpresa )     INLINE ( ::getCodigoGrupoCampoLogico( cCodigoEmpresa, "lGrpAlm" ) )

      METHOD getCodigoGrupoCampoLogico( cCodigoEmpresa, cCampoLogico )

   METHOD scatter( cCodigoEmpresa )

   METHOD DeleteEmpresa( cCodigoEmpresa )

   METHOD aNombres()

END CLASS

//---------------------------------------------------------------------------//

METHOD UpdateEmpresaCodigoEmpresa()

   local cStm
   local cSql  := "UPDATE " + ::getEmpresaTableName() + " " + ;
                  "SET CodEmp = CONCAT( '00', TRIM( CodEmp ) ) WHERE ( LENGTH( CodEmp ) < 4 )"

RETURN ( ::ExecuteSqlStatement( cSql, @cStm ) )

//---------------------------------------------------------------------------//

METHOD getCodigoGrupo( cCodigoEmpresa )

   local cStm
   local cSql  := "SELECT cCodGrp FROM " + ::getEmpresaTableName() + " WHERE CodEmp = '" + alltrim( cCodigoEmpresa ) + "'"

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( ( cStm )->cCodGrp )
   end if 

RETURN ( "" )

//---------------------------------------------------------------------------//

METHOD getCodigoActiva()

   local cStm
   local cSql  := "SELECT CodEmp FROM " + ::getEmpresaTableName() + " WHERE lActiva"

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( ( cStm )->CodEmp )
   end if 

RETURN ( "" )

//---------------------------------------------------------------------------//

METHOD getRegistrosActivos()

   local cStm
   local cSql  := "SELECT Count(*) AS Counter FROM " + ::getEmpresaTableName() 

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( ( cStm )->Counter )
   end if 

RETURN ( 0 )

//---------------------------------------------------------------------------//

METHOD getPrimera()

   local cStm
   local cSql  := "SELECT TOP 1 CodEmp FROM " + ::getEmpresaTableName() + " WHERE NOT lGrupo"

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( ( cStm )->CodEmp )
   end if 

RETURN ( "" )

//---------------------------------------------------------------------------//

METHOD getCodigoGrupoCampoLogico( cCodigoEmpresa, cCampoLogico )

   local cStm
   local cSql              := "SELECT cCodGrp FROM " + ::getEmpresaTableName()   + " " + ;
                                 "WHERE CodEmp = " + quoted( cCodigoEmpresa )    + " " + ;
                                 "AND " + cCampoLogico + " = TRUE"

   if ::ExecuteSqlStatement( cSql, @cStm )
      if !empty( ( cStm )->cCodGrp )
         cCodigoEmpresa    := ( cStm )->cCodGrp
      end if 
   end if 

RETURN ( cCodigoEmpresa )

//---------------------------------------------------------------------------//

METHOD scatter( cCodigoEmpresa )

   local cStm
   local cSql  := "SELECT TOP 1 * FROM " + ::getEmpresaTableName() + " WHERE CodEmp = " + quoted( cCodigoEmpresa )

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( dbScatter( cStm ) )
   end if 

RETURN ( {} )

//---------------------------------------------------------------------------//

METHOD DeleteEmpresa( cCodigoEmpresa )

   local cStm
   local cSql  := "DELETE FROM " + ::getEmpresaTableName() + " " + ;
                  "WHERE CodEmp = " + quoted( cCodigoEmpresa )

RETURN ( ::ExecuteSqlStatement( cSql, @cStm ) )

//---------------------------------------------------------------------------//

METHOD aNombres()

   local cStm
   local aEmp  := {}
   local cSql  := "SELECT * FROM " + ::getEmpresaTableName() 

   if !::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( aEmp )
   endif 

   while !( cStm )->( eof() ) 
      aadd( aEmp, ( cStm )->cNombre )
      ( cStm )->( dbskip() )
   end while

RETURN ( aEmp )

//---------------------------------------------------------------------------//
