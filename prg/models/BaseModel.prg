#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Ads.ch"

//---------------------------------------------------------------------------//

CLASS ADSBaseModel

   DATA cTableName

   METHOD getEmpresaTableName( cTableName )     INLINE ( cPatEmp() + if( empty(cTableName), ::cTableName, cTableName ) )

   METHOD getDatosTableName( cTableName )       INLINE ( cPatDat() + if( empty(cTableName), ::cTableName, cTableName ) )

   METHOD getFileName( cPath, cTableName )      INLINE ( cPath + "\" + if( empty(cTableName), ::cTableName, cTableName ) )

   METHOD createFile( cPath )
   
   METHOD createIndex( cPath )

   METHOD executeSqlStatement( cSql, cSqlStatement, hStatement )

   METHOD closeArea( cArea )                    INLINE ( if( select( cArea ) > 0, ( cArea )->( dbclosearea() ), ), dbselectarea( 0 ), .t. )

   METHOD clearFocus( cArea )                   INLINE ( if( select( cArea ) > 0, ( ( cArea )->( ordsetfocus( 0 ) ), ( cArea )->( dbgotop() ) ), ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD executeSqlStatement( cSql, cSqlStatement, hStatement )

   local lOk
   local nError
   local oError
   local oBlock
   local cErrorAds

   DEFAULT cSqlStatement   := "ADSArea" // + trimedSeconds()
   DEFAULT hStatement      := ADS_CDX

   if !( lAIS() )
      RETURN ( .f. )
   end if

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::closeArea( cSqlStatement )

      ADSCacheOpenCursors( 0 )
      
      dbSelectArea( 0 )

      lOk                  := ADSCreateSQLStatement( cSqlStatement, hStatement )
      if lOk
   
         lOk               := ADSExecuteSQLDirect( cSql )
         if !lOk
            nError         := AdsGetLastError( @cErrorAds )
            msgStop( "Error : " + str( nError) + "[" + cErrorAds + "]" + CRLF + CRLF + ;
                     "SQL : " + cSql                                                   ,;
                     'ERROR en ADSCreateSQLStatement' )
         endif
   
      else

         ::closeArea( cSqlStatement )
   
         nError            := AdsGetLastError( @cErrorAds )
         msgStop( "Error : " + str( nError) + "[" + cErrorAds + "]" + CRLF + CRLF +    ;
                  "SQL : " + cSql                                                      ,;
                  'ERROR en ADSCreateSQLStatement' )
   
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

METHOD createFile( cPath )

   if !lExistTable( ::getFileName( cPath ) )
      dbCreate( ::getFileName( cPath ), ::getStruct(), cDriver() )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD createIndex( cPath )

   local cAlias
   local aIndex

   dbUseArea( .t., cDriver(), ::getFileName( cPath ), cCheckArea( "Alias", @cAlias ), .f. )

   if ( cAlias )->( neterr() )
      msgStop( "Imposible abrir en modo exclusivo la tabla : " + ::getFileName( cPath ) )
      RETURN ( Self )
   end if 

   ( cAlias)->( __dbPack() )

   for each aIndex in ::getIndexes
      ( cAlias )->( ordCondSet( "!Deleted()", {|| !Deleted() }, , , , , , , , , aIndex[ 4 ] ) )
      ( cAlias )->( ordCreate( ::getFileName( cPath ), aIndex[ 1 ], aIndex[ 2 ], aIndex[ 3 ] ) )
   next 

   ( cAlias )->( dbCloseArea() )

RETURN ( Self )

//---------------------------------------------------------------------------//

