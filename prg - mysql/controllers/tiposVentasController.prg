#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TiposVentasController FROM SQLBaseController

   METHOD   New()

   METHOD   buildSQLModel( this )         INLINE ( TiposVentasModel():New( this ) )
   
   METHOD   buildSQLView( this )				INLINE ( TiposVentas():New( this ) )
  
   METHOD   getFieldFromBrowse()          INLINE ( ::getRowSet():fieldGet( "codigo" ) )
 
   METHOD   validCodigo( oGetCodigo )
   METHOD   validNombre( oGetNombre )

   METHOD   createEditControl( hControl ) INLINE ( ::oView:createEditControl( hControl ) )

   METHOD   validEditControl()            INLINE ( if( !empty( ::oView:oEditControl ), ::oView:oEditControl:lValid(), ) )
   METHOD   getIdFromEditControl()        INLINE ( if( !hb_isnil( ::oView:cEditControl ), ::getIdFromCodigo( ::oView:cEditControl ), ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::idUserMap            := "01043"

   ::setTitle( "Tipos de ventas" )

   ::Super:New()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD validCodigo( oGetCodigo )

   local idCodigo
   local cErrorText  := ""

   oGetCodigo:setColor( Rgb( 0, 0, 0 ), Rgb( 255, 255, 255 ) )

   if empty( ::oModel:hBuffer[ "codigo" ] )
      cErrorText     += "El código de la propiedad no puede estar vacío." 
   end if

   idCodigo          := ::oModel:ChecksForValid( "codigo" )
   
   if ( !empty( idCodigo ) )

      if ( idCodigo != ::oModel:hBuffer[ "id" ] .and. !::isDuplicateMode() )
         cErrorText  += "El código de la propiedad ya existe." 
      end if
   
      if ( idCodigo == ::oModel:hBuffer[ "id" ] .and. ::isDuplicateMode() )
         cErrorText  += "El código de la propiedad ya existe."
      end if
   
   end if

   if !empty( cErrorText )
      msgStop( cErrorText )
      oGetCodigo:setColor( Rgb( 255, 255, 255 ), Rgb( 255, 102, 102 ) )
      oGetCodigo:setFocus()
      RETURN ( .f. )
   end if

RETURN ( .t. )

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

