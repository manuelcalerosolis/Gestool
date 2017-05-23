#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TiposNotasController FROM SQLBaseController

   METHOD   New()

   METHOD   buildSQLModel( this )         	 INLINE ( TiposNotasModel():New( this ) )
   
   METHOD   buildSQLView( this )			       INLINE ( TiposNotas():New( this ) )
   
   METHOD   validDialog( oDlg, oGetNombre )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::idUserMap            := "01097"

   ::Super:New()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD validDialog( oDlg, oGetNombre )

   local idForNombre

   if empty( ::oModel:hBuffer[ "tipo" ] )
      msgStop( "El nombre de la nota no puede estar vacío." )
      oGetNombre:setFocus()
      RETURN ( .f. )
   end if

   idForNombre := ::oModel:ChecksForValid( "tipo" )

   if ( !empty( idForNombre ) )
      if ( idForNombre != ::oModel:hBuffer[ "id" ] .and. !::isDuplicateMode() )
         msgStop( "Esta nota ya existe" )
         oGetNombre:setFocus()
         RETURN ( .f. )
      end if

      if ( idForNombre == ::oModel:hBuffer[ "id" ] .and. ::isDuplicateMode() )
         msgStop( "Esta nota ya existe" )
         oGetNombre:setFocus()
         RETURN ( .f. )      
      end if
   end if

RETURN ( oDlg:end( IDOK ) )

//----------------------------------------------------------------------------//