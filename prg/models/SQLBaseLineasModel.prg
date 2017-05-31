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

   METHOD   buildRowSetWhitForeignKey( id )           INLINE ( ::setForeignKey( id ), ::buildRowSet() )

	METHOD 	getSelectSentence()
   METHOD   getInsertSentence()

   METHOD   insertBuffer()

   METHOD 	confirmIdParentToChildsOf( nId_parent )

   METHOD	deletingOurChilds()

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::Super:New()

   ::cGeneralSelect 		:= "SELECT * FROM " + ::cTableName + " WHERE " + ::cForeignColumn

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD getSelectSentence()

	local cSQLSelect

	cSQLSelect  		:= ::cGeneralSelect + " = " + toSQLString( ::idForeignKey )

   cSQLSelect        := ::getSelectByColumn( cSQLSelect )

   cSQLSelect        := ::getSelectByOrder( cSQLSelect )

RETURN ( cSQLSelect )

//---------------------------------------------------------------------------//

METHOD getInsertSentence()

	local cSQLInsert := "INSERT INTO " + ::cTableName + " ( "

	hEval( ::hBuffer, {| k, v | if ( k != ::cColumnKey, cSQLInsert += k + ", ", ) } )

   cSQLInsert        := ChgAtEnd( cSQLInsert, ' ) VALUES ( ', 2 )

   hEval( ::hBuffer, {| k, v | if ( k != ::cColumnKey, if ( k == ::cForeignColumn, cSQLInsert += "null" , cSQLInsert += toSQLString( v ) + ", " ), ) } )

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

METHOD deletingOurChilds()

	local cDeleteSentence

	cDeleteSentence := "DELETE FROM " + ::cTableName + " WHERE " + ::cForeignColumn + " = null"

	//aeval( ::aTmpIdsToConfirm, { | v | cDeleteSentence += ::cColumnKey + " = " + toSQLString( v ) + " OR " } )

	getSQLDatabase():Query( cDeleteSentence )

RETURN ( self )

//---------------------------------------------------------------------------//