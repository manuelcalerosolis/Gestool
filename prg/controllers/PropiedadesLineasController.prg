#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS PropiedadesLineasController FROM SQLBaseController

   METHOD   New()

   METHOD   buildSQLModel( this )         INLINE ( PropiedadesLineasModel():New( this ) )
   
   METHOD   buildSQLView( this )				INLINE ( PropiedadesLineas():New( this ) )
  
   METHOD   getFieldFromBrowse()          INLINE ( ::getRowSet():fieldGet( "id" ) )
 
   METHOD   validCodigo( oGetCodigo )

   METHOD   validNombre( oGetNombre )

  /* METHOD   UpDet()

   METHOD   DownDet()*/

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::setTitle( "Propiedades de lineas" )

   ::Super:New()

RETURN ( Self )

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

/*METHOD   UpDet()

   local newPosition             := getRowSet()fieldget( "orden" ) + 1

   local SentenceForOthers       := "UPDATE FROM " + ::oModel:cTableName + " SET orden = orden - 1 WHERE orden = " + toSQLString( newPosition )
   local SentenceForMyPosition   := "UPDATE FROM " + ::oModel:cTableName + " SET orden = " + newPosition + " WHERE id = " + toSQLString( getRowSet()[ "id" ] )

   getSQLDatabase():Query( SentenceForOthers )
   getSQLDatabase():Query( SentenceForMyPosition )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD   DownDet()

   local newPosition             := getRowSet()fieldget( "orden" ) - 1

   local SentenceForOthers       := "UPDATE FROM " + ::oModel:cTableName + " SET orden = orden + 1 WHERE orden = " + toSQLString( newPosition )
   local SentenceForMyPosition   := "UPDATE FROM " + ::oModel:cTableName + " SET orden = " + newPosition + " WHERE id = " + toSQLString( getRowSet()[ "id" ] )

   getSQLDatabase():Query( SentenceForOthers )
   getSQLDatabase():Query( SentenceForMyPosition )

 RETURN ( self )*/

//---------------------------------------------------------------------------//