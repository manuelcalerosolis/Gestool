#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TiposImpresorasController FROM SQLBaseController

   METHOD   New()

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::cTitle                := "Tipos de impresoras"

   ::cImage                := "gc_printer2_16"

   ::nLevel                := nLevelUsr( "01115" )

   ::oModel                := TiposImpresorasModel():New( self )

   ::oDialogView           := TiposImpresorasView():New( self )

   ::oNavigatorView        := SQLNavigatorView():New( self )

   ::oValidator            := TiposImpresorasValidator():New( self )

   ::Super:New()

RETURN ( Self )

//---------------------------------------------------------------------------//
/*
METHOD validNombre( oGet, cColumn )

   local idNombre
   local cErrorText  := ""

   oGet:setColor( Rgb( 0, 0, 0 ), Rgb( 255, 255, 255 ) )

   if empty( ::oModel:hBuffer[ "nombre" ] )
      cErrorText     += "El nombre de la impresora no puede estar vacío." 
   end if

   idNombre          := ::oModel:ChecksForValid( "nombre" )
   
   if ( !empty( idNombre ) )

      if ( idNombre != ::oModel:hBuffer[ "id" ] .and. !::isDuplicateMode() )
         cErrorText  += "El nombre de la impresora ya existe." 
      end if
   
      if ( idNombre == ::oModel:hBuffer[ "id" ] .and. ::isDuplicateMode() )
         cErrorText  += "El nombre de la impresora ya existe."
      end if
   
   end if

   if !empty( cErrorText )
      msgStop( cErrorText )
      oGet:setColor( Rgb( 255, 255, 255 ), Rgb( 255, 102, 102 ) )
      oGet:setFocus()
      RETURN ( .f. )
   end if

RETURN ( .t. )
*/
//---------------------------------------------------------------------------//