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

   ::setTitle( "Tipos incidencias" )

   ::Super:New()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD validDialog( oDlg, oGetNombre, oGetCodigo )

   local idForNombre

   if empty( ::oModel:hBuffer[ "nombre" ] )
      MsgStop( "El nombre del tipo de incidencia no puede estar vacío." )
      oGetNombre:setFocus()
      Return ( .f. )
   end if    

   idForNombre := ::oModel:ChecksForValid( "nombre" )

   if ( !empty( idForNombre ) )
      if ( idForNombre != ::oModel:hBuffer[ "id" ] .and. !::isDuplicateMode() )
         msgStop( "El nombre de la incidencia ya existe" )
         oGetNombre:setFocus()
         RETURN ( .f. )
      end if

      if ( idForNombre == ::oModel:hBuffer[ "id" ] .and. ::isDuplicateMode() )
         msgStop( "El nombre de la incidencia ya existe" )
         oGetNombre:setFocus()
         RETURN ( .f. )
      end if 
   end if   

RETURN ( oDlg:end( IDOK ) )

//---------------------------------------------------------------------------//