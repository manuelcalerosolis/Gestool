#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS SituacionesController FROM SQLNavigatorController

   METHOD   New()

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::cTitle                := "Situaciones"

   ::cImage                := "gc_document_attachment_16"

   ::nLevel                := nLevelUsr( "01096" )

   ::oModel                := SituacionesModel():New( self )

   ::oDialogView           := SituacionesView():New( self )

   ::oValidator            := SituacionesValidator():New( self )

   ::Super:New()

RETURN ( Self )

//---------------------------------------------------------------------------//

