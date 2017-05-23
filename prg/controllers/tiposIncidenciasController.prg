#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TiposIncidenciasController FROM SQLBaseController

   METHOD   New()

   METHOD   buildSQLModel( this )         INLINE ( TiposIncidenciasModel():New( this ) )
   
   METHOD   buildSQLView( this )          INLINE ( TiposIncidencias():New( this ) )
  
   METHOD   getFieldFromBrowse()          INLINE ( ::getRowSet():fieldGet( "codigo" ) )

   METHOD   validDialog( oDlg, oGetNombre )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::idUserMap            := "01089"

   ::Super:New()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD validDialog( oDlg, oGetNombre, oGetCodigo )

   local idForNombre
   local idForCodigo

   if empty( ::oModel:hBuffer[ "nombre_incidencia" ] )
      MsgStop( "El nombre del tipo de incidencia no puede estar vacío." )
      oGetNombre:setFocus()
      Return ( .f. )
   end if    

   idForNombre := ::oModel:ChecksForValid( "nombre_incidencia" )

   if ( !empty( idForNombre ) .and. ;
      ( ( idForNombre != ::oModel:hBuffer[ "id" ] .and. !::isDuplicateMode() ) .or. ;
      ( idForNombre == ::oModel:hBuffer[ "id" ] .and. ::isDuplicateMode() ) ) )
      msgStop( "El nombre de la incidencia ya existe" )
      oGetNombre:setFocus()
      RETURN ( .f. )
   end if

   if empty( ::oModel:hBuffer[ "codigo" ] )
      MsgStop( "El codigo del tipo de incidencia no puede estar vacío." )
      oGetCodigo:setFocus()
      Return ( .f. )
   end if

   idForCodigo := ::oModel:ChecksForValid( "codigo" )

   if ( !empty( idForCodigo ) .and. ;
      ( ( idForCodigo != ::oModel:hBuffer[ "id" ] .and. !::isDuplicateMode() ) .or. ;
      ( idForCodigo == ::oModel:hBuffer[ "id" ] .and. ::isDuplicateMode() ) ) )
      msgStop( "El código de la incidencia ya existe" )
      oGetCodigo:setFocus()
      RETURN ( .f. )
   end if

RETURN ( oDlg:end( IDOK ) )

//---------------------------------------------------------------------------//