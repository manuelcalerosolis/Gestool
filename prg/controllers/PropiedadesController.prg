#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS PropiedadesController FROM SQLHeaderController

<<<<<<< HEAD
	DATA 		oPropiedadesLineasController

   METHOD   New()

   METHOD   buildSQLModel( this )         INLINE ( PropiedadesModel():New( this ) )
   
   METHOD   buildSQLView( this )				INLINE ( Propiedades():New( this ) )
  
   METHOD   getFieldFromBrowse()          INLINE ( ::getRowSet():fieldGet( "id" ) )
 
   METHOD   validDialog( oDlg, oGetNombre )

   METHOD   initAppendMode()              INLINE ( ::oPropiedadesLineasController:oModel:buildRowSetWhitForeignKey( 0 ) )

   METHOD   initEditMode()                INLINE ( ::oPropiedadesLineasController:oModel:buildRowSetWhitForeignKey( ::oModel:hBuffer[ "id" ] ) )

   METHOD   initZoomMode()                INLINE ( ::oPropiedadesLineasController:oModel:buildRowSetWhitForeignKey( ::oModel:hBuffer[ "id" ] ) )
=======
   METHOD   New()

   METHOD   buildSQLModel( this )                  INLINE ( PropiedadesModel():New( this ) )
   
   METHOD   buildSQLView( this )				         INLINE ( Propiedades():New( this ) )
  
   METHOD   getFieldFromBrowse()                   INLINE ( padr( ::getRowSet():fieldGet( "codigo" ), ::oModel:hColumns[ "codigo" ][ "len" ] ) )
 
   METHOD   validCodigo( oGetCodigo )

   METHOD   validNombre( oGetNombre )

   METHOD   createEditControl( uValue, hControl )  INLINE ( ::oView:createEditControl( @uValue, hControl ) )
>>>>>>> SQLite

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::idUserMap            				:= "01015"

 	::setTitle( "Propiedades" )

   ::Super:New()

<<<<<<< HEAD
   ::oPropiedadesLineasController	:= PropiedadesLineasController():New( Self )
=======
   ::ControllerContainer:add( 'lineas', PropiedadesLineasController():New( Self ) )
>>>>>>> SQLite

Return ( Self )

//---------------------------------------------------------------------------//

<<<<<<< HEAD
METHOD validDialog( oDlg, oGetNombre, oGetCodigo )

	local idForNombre
	local idForCodigo

	if empty( ::oModel:hBuffer[ "codigo" ] )
      msgStop( "El código de la propiedad no puede estar vacío." )
      oGetCodigo:setFocus()
      RETURN ( .f. )
   end if

   idForcodigo := ::oModel:ChecksForValid( "codigo" )
   
   if ( !empty( idForcodigo ) )
   	if ( idForcodigo != ::oModel:hBuffer[ "id" ] .and. !::isDuplicateMode() )
	      msgStop( "El código de la propiedad ya existe" )
	      oGetCodigo:setFocus()
	      RETURN ( .f. )
      end if
      if ( idForcodigo == ::oModel:hBuffer[ "id" ] .and. ::isDuplicateMode() )
         msgStop( "El código de la propiedad ya existe" )
	      oGetCodigo:setFocus()
	      RETURN ( .f. )
      end if
   end if

   if empty( ::oModel:hBuffer[ "nombre" ] )
      msgStop( "El nombre de la propiedad no puede estar vacío." )
      oGetNombre:setFocus()
      RETURN ( .f. )
   end if

   idForNombre := ::oModel:ChecksForValid( "nombre" )
   
   if ( !empty( idForNombre ) )
   	if ( idForNombre != ::oModel:hBuffer[ "id" ] .and. !::isDuplicateMode() )
	      msgStop( "El nombre de la propiedad ya existe" )
	      oGetNombre:setFocus()
	      RETURN ( .f. )
      end if
      if ( idForNombre == ::oModel:hBuffer[ "id" ] .and. ::isDuplicateMode() )
         msgStop( "El nombre de la propiedad ya existe" )
	      oGetNombre:setFocus()
	      RETURN ( .f. )
      end if
   end if

RETURN ( oDlg:end( IDOK ) )

//---------------------------------------------------------------------------//
	
=======
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
>>>>>>> SQLite
