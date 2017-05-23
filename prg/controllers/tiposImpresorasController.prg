#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TiposImpresorasController FROM SQLBaseController

   METHOD   New()

   METHOD   buildSQLModel( this )         INLINE ( TiposImpresorasModel():New( this ) )
   
   METHOD   buildSQLView( this )				INLINE ( TiposImpresoras():New( this ) )
  
   METHOD   getFieldFromBrowse()          INLINE ( ::getRowSet():fieldGet( "nombre" ) )
 
   METHOD   validDialog( oDlg, oGetNombre )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::idUserMap            := "01115"

   ::Super:New()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD validDialog( oDlg, oGetNombre )

	local idForNombre

   if empty( ::oModel:hBuffer[ "nombre" ] )
      msgStop( "El nombre de la impresora no puede estar vacío." )
      oGetNombre:setFocus()
      RETURN ( .f. )
   end if

   idForNombre := ::oModel:ChecksForValid( "nombre" )
   
   if ( !empty( idForNombre ) .and. ;
      ( ( idForNombre != ::oModel:hBuffer[ "id" ] .and. !::isDuplicateMode() ) .or. ;
      ( idForNombre == ::oModel:hBuffer[ "id" ] .and. ::isDuplicateMode() ) ) )
      msgStop( "El nombre de la impresora ya existe" )
      oGetNombre:setFocus()
      RETURN ( .f. )
   end if

//---------------------------------------------------------------------------//

RETURN ( oDlg:end( IDOK ) )
