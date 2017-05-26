#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

//---------------------------------------------------------------------------//

CLASS SituacionesController FROM SQLBaseController

   METHOD   New()

   METHOD   buildSQLModel( this )           INLINE ( SituacionesModel():New() )

   METHOD   buildSQLView( this )			INLINE ( Situaciones():New( this ) )

   METHOD   validDialog( oDlg, oGetNombre )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::idUserMap            := "01096"

   ::setTitle( "Situaciones" )

   ::Super:New()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD validDialog( oDlg, oGetNombre )

   local idForNombre

   if empty( ::oModel:hBuffer[ "nombre" ] )
      MsgStop( "El nombre de la situación no puede estar vacío" )
      oGetNombre:setFocus()
      Return ( .f. )
   end if

   idForNombre := ::oModel:ChecksForValid( "nombre" )

   if ( !empty( idForNombre ) )
      if ( idForNombre != ::oModel:hBuffer[ "id" ] .and. !::isDuplicateMode() )
         msgStop( "Esta situación ya existe" )
         oGetNombre:setFocus()
         RETURN ( .f. )
      endif
      if ( idForNombre == ::oModel:hBuffer[ "id" ] .and. ::isDuplicateMode() )
         msgStop( "Esta situación ya existe" )
         oGetNombre:setFocus()
         RETURN ( .f. )
      endif
   end if

RETURN ( oDlg:end( IDOK ) )

//--------------------------------------------------------------------------//
