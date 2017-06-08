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

   METHOD   validOrden( oGetOrden )

   METHOD   initAppendMode()

   METHOD   UpDet()

   METHOD   DownDet()

   METHOD   changeOrdenOnUpdate()

   METHOD   changeOrdenOnInsert()

   METHOD   endEditModePreUpdate()         INLINE ( ::changeOrdenOnUpdate() )

   METHOD   endAppendModePreInsert()       INLINE ( ::changeOrdenOnInsert() )

   METHOD   endDeleteModePosDelete()       INLINE ( ::oModel:reOrder() )

   METHOD   addColumnsForBrowse( oCombobox, k, h )

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

METHOD validOrden( oGetOrden )

   local cErrorText  := ""

   oGetOrden:setColor( Rgb( 0, 0, 0 ), Rgb( 255, 255, 255 ) )

   if ( ::oModel:hBuffer[ "orden" ] < 1 )

      cErrorText     += "El orden de la propiedad debe ser mayor que 0"

   else
      if ( ::isDuplicateMode() .or. ::isAppendMode())

         if ( ::oModel:hBuffer[ "orden" ] > ::getRowSet():reccount() +1 )
             
            cErrorText     += "El orden de la propiedad debe ser menor que " + alltrim( str( ::getRowSet():reccount() +2 ) )

         endif

      else

         if ( ::oModel:hBuffer[ "orden" ] > ::getRowSet():reccount() )

            cErrorText     += "El orden de la propiedad debe ser menor que " + alltrim( str( ::getRowSet():reccount() + 1 ) )
             
         endif

      endif
      
   endif
   
   if empty( ::oModel:hBuffer[ "orden" ] )
      cErrorText     += "El orden de la propiedad no puede estar vacío." 
   end if

   if !empty( cErrorText )
      msgStop( cErrorText )
      oGetOrden:setColor( Rgb( 255, 255, 255 ), Rgb( 255, 102, 102 ) )
      oGetOrden:setFocus()
      RETURN ( .f. )
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD   UpDet()

   local newPosition
   local Operation := "orden + 1"

   newPosition := ::getRowSet():fieldget( "orden" ) - 1
   if (newPosition < 1 )
       RETURN ( self )
   endif

   ::oModel:setIdForRecno( ::getIdfromRowset() )

   ::oModel:updateOrden( Operation, newPosition )

   if !empty( ::oView:getoBrowse() )
      ::oView:getoBrowse():refreshCurrent()
      ::oView:getoBrowse():setFocus()
   end if

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD   DownDet()

   local newPosition
   local Operation := "orden - 1"

   newPosition := ::getRowSet():fieldget( "orden" ) + 1
   if (newPosition > ::getRowSet():reccount() )
    RETURN ( self )
   endif

   ::oModel:setIdForRecno( ::getIdfromRowset() )

   ::oModel:updateOrden( Operation, newPosition )

   if !empty( ::oView:getoBrowse() )
      ::oView:getoBrowse():refreshCurrent()
      ::oView:getoBrowse():setFocus()
   end if

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD initAppendMode()

   hset( ::oModel:hBuffer, "orden", ::getRowSet():reccount() + 1 )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD   changeOrdenOnInsert()

   local newPosition := ::oModel:hBuffer[ "orden" ]
   local Operation
   local Conditions

   if ( newPosition > ::getRowSet():reccount() .or. newPosition < 1 )
       RETURN( self )
   endif

   Operation   := "orden + 1"
   Conditions  := " >= " + toSQLString( newPosition )

   ::oModel:largeUpdateOrden( Operation, Conditions )   

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD changeOrdenOnUpdate()

   local Operation
   local Conditions
   local oldPosition := ::getRowSet():fieldget( "orden" )
   local newPosition := ::oModel:hBuffer[ "orden" ]

   if ( newPosition > ::getRowSet():reccount() .or. newPosition < 1 )
       RETURN( self )
   endif

   if ( oldPosition == newPosition )
      RETURN( self )   
   end if 
   
   if ( oldPosition > newPosition )

      Operation   := "orden + 1"
      Conditions  := "BETWEEN " + toSQLString( newPosition ) + " AND " + toSQLString( oldPosition )

   else 

      Operation   := "orden - 1"
      Conditions  := "BETWEEN " + toSQLString( oldPosition ) + " AND " + toSQLString( newPosition ) 

   end if

   ::oModel:largeUpdateOrden( Operation, Conditions )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD addColumnsForBrowse( oCombobox )

   with object ( ::oView:getoBrowse():AddCol() )
      :Adjust()
      :cHeader             := "Color"
      :bFooter             := {|| "" }
      :bStrData            := {|| "" }
      :nWidth              := 16
      :bClrStd             := {|| { ::getRowSet():fieldget("color"), ::getRowSet():fieldget("color") } }
      :bClrSel             := {|| { ::getRowSet():fieldget("color"), ::getRowSet():fieldget("color") } }
      :bClrSelFocus        := {|| { ::getRowSet():fieldget("color"), ::getRowSet():fieldget("color") } }
   end with

RETURN ( self )

//---------------------------------------------------------------------------//

