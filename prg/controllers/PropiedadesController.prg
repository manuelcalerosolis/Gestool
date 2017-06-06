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

   ::ControllerContainer:add( 'lineas', PropiedadesLineasController():New( Self ) )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD validDialog( oDlg, oGetCodigo, oGetNombre )

	local idForNombre
	local idForCodigo

	if empty( ::oModel:hBuffer[ "codigo" ] )
      msgStop( "El código de la propiedad no puede estar vacío." )
      oGetCodigo:setColor( )
      RETURN ( .f. )
   end if

   if empty( ::oModel:hBuffer[ "nombre" ] )
      msgStop( "El nombre de la propiedad no puede estar vacío." )
      RETURN ( .f. )
   end if

   idForCodigo := ::oModel:ChecksForValid( "codigo" )
   
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

   oDlg:end( IDOK )

RETURN ( .t. )

//---------------------------------------------------------------------------//
	