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
 
   METHOD   validDialog( oDlg, oGetCodigo, oGetNombre )

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

METHOD validDialog( oDlg, oGetCodigo, oGetNombre )

   local idForNombre

   if empty( ::oModel:hBuffer[ "codigo" ] )
      msgStop( "El código del tipo de venta no puede estar vacío." )
      oGetCodigo:setFocus()
      RETURN ( .f. )
   end if

   if empty( ::oModel:hBuffer[ "nombre" ] )
      msgStop( "El nombre del tipo de venta no puede estar vacío." )
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
