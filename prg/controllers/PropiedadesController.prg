#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS PropiedadesController FROM SQLHeaderController

   METHOD   New()

   METHOD   buildSQLModel( this )         INLINE ( PropiedadesModel():New( this ) )
   
   METHOD   buildSQLView( this )				INLINE ( Propiedades():New( this ) )
  
   METHOD   getFieldFromBrowse()          INLINE ( ::getRowSet():fieldGet( "id" ) )
 
   METHOD   validDialog( oDlg, oGetNombre )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::idUserMap            				:= "01015"

 	::setTitle( "Propiedades" )

   ::Super:New()

   hset( ::hControllers, 'lineas', PropiedadesLineasController():New( Self ) )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD validDialog( oDlg, oGetNombre, oGetCodigo )

	local idForNombre
	local idForCodigo

	if empty( ::oModel:hBuffer[ "codigo" ] )
      msgStop( "El código de la propiedad no puede estar vacío." )
      oGetCodigo:setFocus()
      RETURN ( .f. )
   end if

   idForcodigo := ::oModel:ChecksForValid( "codigo" )
   
   if ( !empty( idForcodigo ) )
   	if ( idForcodigo != ::oModel:hBuffer[ "id" ] .and. !::isDuplicateMode() )
	      msgStop( "El código de la propiedad ya existe" )
	      oGetCodigo:setFocus()
	      RETURN ( .f. )
      end if
      if ( idForcodigo == ::oModel:hBuffer[ "id" ] .and. ::isDuplicateMode() )
         msgStop( "El código de la propiedad ya existe" )
	      oGetCodigo:setFocus()
	      RETURN ( .f. )
      end if
   end if

   if empty( ::oModel:hBuffer[ "nombre" ] )
      msgStop( "El nombre de la propiedad no puede estar vacío." )
      oGetNombre:setFocus()
      RETURN ( .f. )
   end if

   idForNombre := ::oModel:ChecksForValid( "nombre" )
   
   if ( !empty( idForNombre ) )
   	if ( idForNombre != ::oModel:hBuffer[ "id" ] .and. !::isDuplicateMode() )
	      msgStop( "El nombre de la propiedad ya existe" )
	      oGetNombre:setFocus()
	      RETURN ( .f. )
      end if
      if ( idForNombre == ::oModel:hBuffer[ "id" ] .and. ::isDuplicateMode() )
         msgStop( "El nombre de la propiedad ya existe" )
	      oGetNombre:setFocus()
	      RETURN ( .f. )
      end if
   end if

RETURN ( oDlg:end( IDOK ) )

//---------------------------------------------------------------------------//
	