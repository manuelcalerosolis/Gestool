#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TiposNotasController FROM SQLBaseController

   METHOD   New()

   METHOD   buildSQLModel( this )         	 INLINE ( TiposNotasModel():New( this ) )
   
   METHOD   buildSQLView( this )			       INLINE ( TiposNotas():New( this ) )
   
   METHOD   validNombre( oGetNombre )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::idUserMap            := "01097"

   ::setTitle( "Tipos de notas" )

   ::Super:New()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD validNombre( oGetNombre )

   local idNombre
   local cErrorText  := ""

   oGetNombre:setColor( Rgb( 0, 0, 0 ), Rgb( 255, 255, 255 ) )

   if empty( ::oModel:hBuffer[ "nombre" ] )
      cErrorText     += "El nombre de la propiedad no puede estar vacío." 
   end if

   idNombre          := ::oModel:ChecksForValid( "nombre" )
   
   if ( !empty( idNombre ) )

      if ( idNombre != ::oModel:hBuffer[ "id" ] .and. !::isDuplicateMode() )
         cErrorText  += "El nombre de la propiedad ya existe." 
      end if
   
      if ( idNombre == ::oModel:hBuffer[ "id" ] .and. ::isDuplicateMode() )
         cErrorText  += "El nombre de la propiedad ya existe."
      end if
   
   end if

   if !empty( cErrorText )
      msgStop( cErrorText )
      oGetNombre:setColor( Rgb( 255, 255, 255 ), Rgb( 255, 102, 102 ) )
      oGetNombre:setFocus()
      RETURN ( .f. )
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//