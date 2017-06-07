#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TiposVentasController FROM SQLBaseController

   DATA     oEditControl
   DATA     cEditControl 

   METHOD   New()

   METHOD   buildSQLModel( this )         INLINE ( TiposVentasModel():New( this ) )
   
   METHOD   buildSQLView( this )				INLINE ( TiposVentas():New( this ) )
  
   METHOD   getFieldFromBrowse()          INLINE ( ::getRowSet():fieldGet( "codigo" ) )
 
   METHOD   validCodigo( oGetCodigo )
   METHOD   validNombre( oGetNombre )

   METHOD   createEditControl( hControl )

   METHOD   validEditControl()            INLINE ( if( !empty( ::oEditControl ), ::oEditControl:lValid(), ) )
   METHOD   getIdFromEditControl()        INLINE ( if( !hb_isnil( ::cEditControl ), ::getIdFromCodigo( ::cEditControl ), ) )

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

METHOD createEditControl( hControl )

   if !hhaskey( hControl, "idGet" )
      RETURN ( Self )
   end if 

   if !hhaskey( hControl, "idSay" )
      RETURN ( Self )
   end if 

   if !hhaskey( hControl, "idText" )
      RETURN ( Self )
   end if 

   if !hhaskey( hControl, "dialog" )
      RETURN ( Self )
   end if 

   if !hhaskey( hControl, "value" )
      RETURN ( Self )
   end if 

   if !hhaskey( hControl, "when" )
      RETURN ( Self )
   end if 

   ::cEditControl := ::oModel:getCodigoFromId( hGet( hControl, "value" ) ) 

   REDEFINE GET   ::oEditControl ;
      VAR         ::cEditControl ;
      BITMAP      "Lupa" ;
      ID          ( hGet( hControl, "idGet" ) ) ;
      IDSAY       ( hGet( hControl, "idSay" ) ) ;
      IDTEXT      ( hGet( hControl, "idText" ) ) ;
      OF          ( hGet( hControl, "dialog" ) )

   ::oEditControl:bWhen    := hGet( hControl, "when" ) 
   ::oEditControl:bHelp    := {|| ::assignBrowse( ::oEditControl ) }
   ::oEditControl:bValid   := {|| ::isValidCodigo( ::oEditControl ) }

RETURN ( Self )

//---------------------------------------------------------------------------//
