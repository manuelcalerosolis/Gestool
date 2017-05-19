#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TiposNotasController FROM SQLBaseController

   METHOD   New()

   METHOD   buildSQLModel( this )         	INLINE ( TiposNotasModel():New( this ) )
   
   METHOD   buildSQLView( this )			INLINE ( TiposNotas():New( this ) )
  
   METHOD   buildSQLBrowse( oGet )			INLINE ( TiposNotas():New():buildSQLBrowse( oGet ) )

   METHOD   getFieldFromBrowse()          	INLINE ( ::getRowSet():fieldGet( "tipo" ) )
 
   METHOD   validDialog( oDlg, oGetNombre )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::idUserMap            := "01097"

   ::Super:New()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD validDialog( oDlg, oGetNombre )

   if empty( ::oModel:hBuffer[ "tipo" ] )
      msgStop( "El nombre de la nota no puede estar vacío." )
      oGetNombre:setFocus()
      RETURN ( .f. )
   end if

   if ::getRowSet():find( ::oModel:hBuffer[ "tipo" ], "tipo" ) != 0 .and. ( ::getRowSet():find( ::oModel:hBuffer[ "id" ], "id" ) == 0 .or. ::isDuplicateMode() )
      msgStop( "Esta nota ya existe" )
      oGetNombre:setFocus()
      RETURN ( .f. )
   end if

RETURN ( oDlg:end( IDOK ) )

//----------------------------------------------------------------------------//