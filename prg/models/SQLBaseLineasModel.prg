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

<<<<<<< HEAD
   METHOD   buildRowSetWhitForeignKey( id )           INLINE ( ::setForeignKey( id ), ::buildRowSet() )
=======
   METHOD   buildRowSetWithForeignKey( id )           INLINE ( ::setForeignKey( id ), ::buildRowSet() )

   METHOD 	resetTmpIds()										INLINE ( ::aTmpIdsToConfirm := {} )
>>>>>>> SQLite

	METHOD 	getSelectSentence()
   METHOD   getInsertSentence()

   METHOD   insertBuffer()

   METHOD 	confirmIdParentToChildsOf( nId_parent )

<<<<<<< HEAD
   METHOD	deletingUs()

   /*METHOD	deleteChildsOf( nId_parent )
   METHOD	checkIfYourChildsMustDeleteTheirChilds()	VIRTUAL*/
=======
   METHOD	deletingOurTmpIds()

   METHOD 	checksForValid( cColumnToValid )
>>>>>>> SQLite

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::Super:New()

   ::cGeneralSelect 		:= "SELECT * FROM " + ::cTableName + " WHERE " + ::cForeignColumn
<<<<<<< HEAD
=======
   		//Errores con empresas? si es una linea de una tabla de empresa no deberia tener esa columna la tabla de las lineas. Su cabecera ya se filtra por ellas.
>>>>>>> SQLite

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD getSelectSentence()

	local cSQLSelect

<<<<<<< HEAD
	cSQLSelect  		:= ::cGeneralSelect + " = " + toSQLString( ::idForeignKey )
=======
	cSQLSelect  		:= ::cGeneralSelect + " = " + toSQLString( ::idForeignKey ) 

	if !empty( ::aTmpIdsToConfirm )

		cSQLSelect += " OR " + ::cColumnKey + " IN ( "

		aeval( ::aTmpIdsToConfirm, { | nID | cSQLSelect += toSQLString( nID ) + ", " } )

		cSQLSelect        := ChgAtEnd( cSQLSelect, ' )', 2 )

	endif
>>>>>>> SQLite

   cSQLSelect        := ::getSelectByColumn( cSQLSelect )

   cSQLSelect        := ::getSelectByOrder( cSQLSelect )

RETURN ( cSQLSelect )

//---------------------------------------------------------------------------//

METHOD getInsertSentence()

	local cSQLInsert := "INSERT INTO " + ::cTableName + " ( "

	hEval( ::hBuffer, {| k, v | if ( k != ::cColumnKey, cSQLInsert += k + ", ", ) } )

   cSQLInsert        := ChgAtEnd( cSQLInsert, ' ) VALUES ( ', 2 )

<<<<<<< HEAD
   hEval( ::hBuffer, {| k, v | if ( k != ::cColumnKey, if ( k == ::cForeignColumn, cSQLInsert += "null" , cSQLInsert += toSQLString( v ) + ", " ), ) } )
=======
   hEval( ::hBuffer, {| k, v | if ( k != ::cColumnKey, if ( k == ::cForeignColumn, cSQLInsert += "null, " , cSQLInsert += toSQLString( v ) + ", " ), ) } )
>>>>>>> SQLite

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

<<<<<<< HEAD
METHOD deletingUs()

	local cDeleteSentence

=======
METHOD deletingOurTmpIds()

	local cDeleteSentence

	if (empty( ::aTmpIdsToConfirm ) )
		 RETURN ( nil )
	endif

>>>>>>> SQLite
	cDeleteSentence := "DELETE FROM " + ::cTableName + " WHERE "

	aeval( ::aTmpIdsToConfirm, { | v | cDeleteSentence += ::cColumnKey + " = " + toSQLString( v ) + " OR " } )

<<<<<<< HEAD
=======
	cDeleteSentence        := ChgAtEnd( cDeleteSentence, '', 4 )

>>>>>>> SQLite
	getSQLDatabase():Query( cDeleteSentence )

RETURN ( self )

<<<<<<< HEAD
=======
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

>>>>>>> SQLite
//---------------------------------------------------------------------------//