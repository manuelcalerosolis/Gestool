#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ConversorDocumentosController FROM SQLBrowseController

   METHOD getDestinoController()       INLINE ( ::oController:oDestinoController )

   METHOD getOrigenController()        INLINE ( ::oController:oOrigenController )

   METHOD getSelected()                INLINE ( ::oController:aSelected )

   METHOD Convert()

   METHOD insertRelationDocument()     INLINE ( ::getModel():insertRelationDocument( ::uuidDocumentoOrigen, ::getOrigenController():getModel():cTableName, ::uuidDocumentoDestino, ::getDestinoController():getModel():cTableName ) )

   METHOD addConvert()

   //Contrucciones tarias------------------------------------------------------

   METHOD getModel()                   INLINE ( if( empty( ::oModel ), ::oModel := SQLConversorDocumentosModel():New( self ), ), ::oModel ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD Convert() CLASS ConversorDocumentosController

msgalert("convert generico")

  /* if empty( ::getOrigenController() )
      RETURN ( nil )
   end if

   if ::getOrigenController:className() == ::oDestinoController:className()
      msgstop( "No puede seleccionar el mismo tipo de documento" )
      RETURN ( nil )
   end if

   ::uuidDocumentoOrigen     := ::getOrigenController():getRowSet():fieldGet( "uuid" )

   if empty( ::uuidDocumentoOrigen )
      RETURN( nil )
   end if
   
   ::aSelected := ::getSelected()
   msgalert( hb_valtoexp(::aSelected))

   ::runConvertAlbaran( ::aSelected )
   msgalert( hb_valtoexp( ::aConvert ) ,"aConvert")

   //::oController:oDestinoController:Edit( ::idDocumentoDestino )*/

RETURN ( nil )   

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//