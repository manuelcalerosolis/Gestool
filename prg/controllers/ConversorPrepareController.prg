#include "FiveWin.Ch"
#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS ConversorPrepareController FROM SQLBrowseController

   DATA aSelected

   DATA aDocumentosDestino

   DATA aCreatedDocument               INIT {}

   DATA oDestinoController

   DATA oOrigenController

   DATA oConversorDocumentosController

   DATA oConversorView

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD Run()                        VIRTUAL

   METHOD getDestinoController()       INLINE ( ::oDestinoController )

   METHOD setWhereArray( aSelected )

   //Construcciones tardias----------------------------------------------------

   METHOD getConversorView()           VIRTUAL

   METHOD getModel()                   INLINE ( iif( empty( ::oModel ), ::oModel := SQLAlbaranesVentasConversorModel():New( self ), ), ::oModel ) 

   METHOD getBrowseView()              INLINE ( iif( empty( ::oBrowseView ), ::oBrowseView := OperacionesComercialesBrowseView():New( self ), ), ::oBrowseView )

   METHOD getDialogView()              INLINE ( iif( empty( ::oDialogView ), ::oDialogView := ::oDestinoController:getDialogView(), ), ::oDialogView )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oOrigenController ) CLASS ConversorPrepareController

   ::oOrigenController                 := oOrigenController

   ::oConversorDocumentosController    := ConversorDocumentosController():New( self )

   ::getModel():setLimit( 0 )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD End() CLASS ConversorPrepareController

   if !empty( ::oConversorDocumentosController )
      ::oConversorDocumentosController:End()
   end if

   if !empty( ::oModel )
      ::oModel:End()
   end if 

   if !empty( ::oDialogView )
      ::oDialogView:End()
   end if 

   if !empty( ::oBrowseView )
      ::oBrowseView:End()
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD setWhereArray( aSelected ) CLASS ConversorPrepareController
   
   local cWhere
   
   if empty( aSelected )
      RETURN ( '' )
   end if 
   
   cWhere         := " IN( "

   aeval( aSelected, {| v | cWhere += quotedUuid( v ) + ", " } )

   cWhere         := chgAtEnd( cWhere, ' )', 2 )

RETURN ( cWhere )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
