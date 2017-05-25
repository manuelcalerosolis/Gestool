#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TiposVentasController FROM SQLBaseController

   METHOD   New()

   METHOD   buildSQLModel( this )         INLINE ( TiposVentasModel():New( this ) )
   
   METHOD   buildSQLView( this )				INLINE ( TiposVentas():New( this ) )
  
   METHOD   getFieldFromBrowse()          INLINE ( ::getRowSet():fieldGet( "id" ) )
 
   METHOD   validDialog( oDlg, oGetNombre, oGetCodigo )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::idUserMap            := "01043"

   ::setTitle( "Tipos de ventas" )

   ::Super:New()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD validDialog( oDlg, oGetNombre, oGetCodigo )

   local idForNombre

   if empty( ::oModel:hBuffer[ "nombre" ] )
      msgStop( "El nombre de la venta no puede estar vacío." )
      oGetNombre:setFocus()
      RETURN ( .f. )
   end if

   idForNombre    := ::oModel:ChecksForValid( "nombre" )

   if ( !empty( idForNombre ) )

      if ( idForNombre != ::oModel:hBuffer[ "id" ] .and. !::isDuplicateMode() )
         msgStop( "El nombre de la venta ya existe" )
         oGetNombre:setFocus()
         RETURN ( .f. )
      end if

      if ( idForNombre == ::oModel:hBuffer[ "id" ] .and. ::isDuplicateMode() )  
         msgStop( "El nombre de la venta ya existe" )
         oGetNombre:setFocus()
         RETURN ( .f. )
      end if

   end if

RETURN ( oDlg:end( IDOK ) )

//---------------------------------------------------------------------------//

