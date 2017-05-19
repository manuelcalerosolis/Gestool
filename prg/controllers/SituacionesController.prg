#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

//---------------------------------------------------------------------------//

CLASS SituacionesController FROM SQLBaseController

   METHOD   New()

   METHOD   buildSQLModel( this )           INLINE ( SituacionesModel():New() )

   METHOD   buildSQLView( this )			INLINE ( Situaciones():New( this ) )

   METHOD   getFieldFromBrowse()          	INLINE ( ::oModel:getRowSet():fieldGet( "situacion" ) )

   METHOD   validDialog( oDlg, oGetNombre )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::idUserMap            := "01096"

   ::Super:New()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD validDialog( oDlg, oGetNombre )

   if empty( ::oModel:hBuffer[ "situacion" ] )
      MsgStop( "El nombre de la situación no puede estar vacío" )
      oGetNombre:setFocus()
      Return ( .f. )
   end if

   if ::getRowSet():find( ::oModel:hBuffer[ "situacion" ], "situacion" ) != 0 .and. ( ::getRowSet():fieldget( "id" ) != ::oModel:hBuffer[ "id" ] .or. ::isDuplicateMode() )
      msgStop( "Esta situación ya existe" )
      oGetNombre:setFocus()
      RETURN ( .f. )
   end if

RETURN ( oDlg:end( IDOK ) )

//--------------------------------------------------------------------------//
