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

   ::Super:New()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD validDialog( oDlg, oGetNombre, oGetCodigo )

   local idForNombre
   local idForCodigo

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

   if empty( ::oModel:hBuffer[ "codigo" ] )
      MsgStop( "El codigo del tipo de venta no puede estar vacío." )
      oGetCodigo:setFocus()
      Return ( .f. )
   end if

   idForCodigo    := ::oModel:ChecksForValid( "codigo" )

   if ( !empty( idForCodigo ) )

      if ( idForCodigo != ::oModel:hBuffer[ "id" ] .and. !::isDuplicateMode() )
         msgStop( "El código de la venta ya existe" )
         oGetCodigo:setFocus()
         RETURN ( .f. )
      end if

      if ( idForCodigo == ::oModel:hBuffer[ "id" ] .and. ::isDuplicateMode() )
         msgStop( "El código de la venta ya existe" )
         oGetCodigo:setFocus()
         RETURN ( .f. )
      end if

   end if

RETURN ( oDlg:end( IDOK ) )

//---------------------------------------------------------------------------//

