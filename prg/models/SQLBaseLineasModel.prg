#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Ads.ch"
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLBaseLineasModel From SQLBaseModel

	DATA		idForeignKey
	DATA		cForeignColumn
	DATA		aTmpIdsToConfirm 									INIT {}

   METHOD   New()

   METHOD   setForeignKey( id )                       INLINE ( ::idForeignKey := id )

   METHOD   buildRowSetWithForeignKey( id )           INLINE ( ::setForeignKey( id ), ::buildRowSet() )

   METHOD 	resetTmpIds()										INLINE ( ::aTmpIdsToConfirm := {} )

	METHOD 	getSelectSentence()
   METHOD   getInsertSentence()

   METHOD   insertBuffer()

   METHOD 	confirmIdParentToChildsOf( nId_parent )

   METHOD	deletingOurTmpIds()

   METHOD 	checksForValid( cColumnToValid )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::Super:New()

   ::cGeneralSelect 		:= "SELECT * FROM " + ::cTableName + " WHERE " + ::cForeignColumn
   		//Errores con empresas? si es una linea de una tabla de empresa no deberia tener esa columna la tabla de las lineas. Su cabecera ya se filtra por ellas.

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD getSelectSentence()

	local cSQLSelect

	cSQLSelect  		:= ::cGeneralSelect + " = " + toSQLString( ::idForeignKey ) 

	if !empty( ::aTmpIdsToConfirm )

		cSQLSelect += " OR " + ::cColumnKey + " IN ( "

		aeval( ::aTmpIdsToConfirm, { | nID | cSQLSelect += toSQLString( nID ) + ", " } )

		cSQLSelect        := ChgAtEnd( cSQLSelect, ' )', 2 )

	endif

   cSQLSelect        := ::getSelectByColumn( cSQLSelect )

   cSQLSelect        := ::getSelectByOrder( cSQLSelect )

RETURN ( cSQLSelect )

//---------------------------------------------------------------------------//

METHOD getInsertSentence()

	local cSQLInsert := "INSERT INTO " + ::cTableName + " ( "

	hEval( ::hBuffer, {| k, v | if ( k != ::cColumnKey, cSQLInsert += k + ", ", ) } )

   cSQLInsert        := ChgAtEnd( cSQLInsert, ' ) VALUES ( ', 2 )

   hEval( ::hBuffer, {| k, v | if ( k != ::cColumnKey, if ( k == ::cForeignColumn, cSQLInsert += "null, " , cSQLInsert += toSQLString( v ) + ", " ), ) } )

   cSQLInsert        := ChgAtEnd( cSQLInsert, ' )', 2 )

RETURN ( cSQLInsert )

//---------------------------------------------------------------------------//

METHOD insertBuffer()

   getSQLDatabase():Query( ::getInsertSentence() )

   aadd( ::aTmpIdsToConfirm, getSQLDatabase():LastInsertId() )

   ::buildRowSet()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD confirmIdParentToChildsOf( nId_padre )

	local cUpdateChildsSentence
	local nIdToConfirm

	if empty( ::aTmpIdsToConfirm )
		RETURN( self )		 
	endif

	for each nIdToConfirm in ::aTmpIdsToConfirm

		cUpdateChildsSentence := 	"UPDATE " + ::cTableName + ;
											" SET " + ::cForeignColumn + " = " + toSQLString( nId_padre ) + ;
											" WHERE " + ::cColumnKey + " = " + toSQLString( nIdToConfirm )

		getSQLDatabase():Query( cUpdateChildsSentence )

	next

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD deletingOurTmpIds()

	local cDeleteSentence

	if (empty( ::aTmpIdsToConfirm ) )
		 RETURN ( nil )
	endif

	cDeleteSentence := "DELETE FROM " + ::cTableName + " WHERE "

	aeval( ::aTmpIdsToConfirm, { | v | cDeleteSentence += ::cColumnKey + " = " + toSQLString( v ) + " OR " } )

	cDeleteSentence        := ChgAtEnd( cDeleteSentence, '', 4 )

	getSQLDatabase():Query( cDeleteSentence )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD checksForValid( cColumnToValid )

   local cSentence := "SELECT " + ::cColumnKey + " FROM " + ::cTableName + " WHERE id_cabecera = "+ toSQLString( ::idForeignKey ) + " AND " + cColumnToValid + " = " + toSQLString( ::hBuffer[ cColumnToValid ] )
   local aIDsToValid
   local nIDToValid

   aIDsToValid    := ::selectFetchArray( cSentence )

   if empty( aIDsToValid )
       RETURN ( nil )
   endif
   
   nIDToValid     := aIDsToValid[1]

RETURN ( nIDToValid )

//---------------------------------------------------------------------------//