#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Ads.ch"

//---------------------------------------------------------------------------//

CLASS ADSBaseModel

   DATA cTableName

   METHOD getTableName()                        VIRTUAL

   METHOD getEmpresaTableName( cTableName )     INLINE ( cPatEmp() + if( empty(cTableName), ::cTableName, cTableName ) )

   METHOD getDatosTableName( cTableName )       INLINE ( cPatDat() + if( empty(cTableName), ::cTableName, cTableName ) )

   METHOD getFileName( cPath, cTableName )      INLINE ( cPath + "\" + if( empty(cTableName), ::cTableName, cTableName ) )

   METHOD getField( cField, cBy, cId )

   METHOD createFromHash( hFields )

   METHOD getInsertStatement( hFields )

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

METHOD getField( cField, cBy, cId )

   local cStm  
   local cSql  := "SELECT " + cField + " "                              + ;
                     "FROM " + ::getTableName() + " "                   + ;
                     "WHERE " + cBy + " = " + quoted( cId ) 

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( ( cStm )->( fieldget( fieldpos( cField ) ) ) )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getInsertStatement( hFields )

   local cStatement  

   cStatement           := "INSERT INTO " + ::getTableName() + " "  
   cStatement           += "( " 
      hEval( hFields,   {| k, v | cStatement += k + ", " } )
   cStatement           := chgAtEnd( cStatement, " ) VALUES ( ", 2 )

      hEval( hFields,   {| k, v | cStatement += toSqlString( v ) + ", " } )
   cStatement           := chgAtEnd( cStatement, " )", 2 )

RETURN ( cStatement )

//---------------------------------------------------------------------------//

METHOD createFromHash( hFields )

   local cStm
   local cSql  := ::getInsertStatement( hFields )

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( .t. )
   end if 

RETURN ( .f. )

//---------------------------------------------------------------------------//

