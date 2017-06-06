#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS PropiedadesLineasController FROM SQLBaseController

   METHOD   New()

   METHOD   buildSQLModel( this )         INLINE ( PropiedadesLineasModel():New( this ) )
   
   METHOD   buildSQLView( this )				INLINE ( PropiedadesLineas():New( this ) )
  
   METHOD   getFieldFromBrowse()          INLINE ( ::getRowSet():fieldGet( "id" ) )
 
   METHOD   validDialog( oDlg, oGetCodigo )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::setTitle( "Propiedades de lineas" )

   ::Super:New()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD validDialog( oDlg, oGetCodigo )

	local idForCodigo

   if empty( ::oModel:hBuffer[ "codigo" ] )
      msgStop( "El código de la propiedad no puede estar vacío." )
      oGetCodigo:setFocus()
      RETURN ( .f. )
   end if

   idForCodigo := ::oModel:ChecksForValid( "codigo" )
   
   if ( !empty( idForCodigo ) )
   	if ( idForCodigo != ::oModel:hBuffer[ "id" ] .and. !::isDuplicateMode() )
	      msgStop( "El código de la propiedad ya existe" )
	      oGetCodigo:setFocus()
	      RETURN ( .f. )
      end if
      if ( idForCodigo == ::oModel:hBuffer[ "id" ] .and. ::isDuplicateMode() )
         msgStop( "El código de la propiedad ya existe" )
	      oGetCodigo:setFocus()
	      RETURN ( .f. )
      end if
   end if

RETURN ( oDlg:end( IDOK ) )

//---------------------------------------------------------------------------//

/*METHOD UpDet()

   local nOldOrder :=
*/
