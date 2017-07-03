#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Ads.ch"

//---------------------------------------------------------------------------//

CLASS BaseModel

   METHOD getEmpresaTableName( cTableName )     INLINE ( cPatEmp() + cTableName )

   METHOD getDatosTableName( cTableName )       INLINE ( cPatDat() + cTableName )

   METHOD ExecuteSqlStatement( cSql, cSqlStatement, hStatement )

   METHOD CloseArea( cArea )                    INLINE ( if( Select( cArea ) > 0, ( cArea )->( dbCloseArea() ), ), dbSelectArea( 0 ), .t. )

END CLASS

//---------------------------------------------------------------------------//

METHOD ExecuteSqlStatement( cSql, cSqlStatement, hStatement )

   local lOk
   local nError
   local oError
   local oBlock
   local cErrorAds

   DEFAULT cSqlStatement   := "ADS" + trimedSeconds()
   DEFAULT hStatement      := ADS_CDX

   if !( lAIS() )
      RETURN ( .f. )
   end if

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::CloseArea( cSqlStatement )

      dbSelectArea( 0 )

      lOk                  := ADSCreateSQLStatement( cSqlStatement, hStatement )
      if lOk
   
         lOk               := ADSExecuteSQLDirect( cSql )
         if !lOk
            nError         := AdsGetLastError( @cErrorAds )
            msgStop( "Error : " + Str( nError) + "[" + cErrorAds + "]", 'ERROR en AdsExecuteSqlDirect' )
         endif
   
      else
   
         nError            := AdsGetLastError( @cErrorAds )
         msgStop( "Error : " + Str( nError) + "[" + cErrorAds + "]", 'ERROR en ADSCreateSQLStatement' )
   
      end if
   
      if lOk 
         ADSCacheOpenCursors( 0 )
         ADSClrCallBack()
      endif

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Error en sentencia SQL" )
   
   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOk )

//---------------------------------------------------------------------------//



