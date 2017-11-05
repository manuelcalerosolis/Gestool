#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TiposImpresorasController FROM SQLNavigatorController

   METHOD New()

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::cTitle                := "Tipos de impresoras"

   ::cImage                := "gc_printer2_16"

   ::nLevel                := nLevelUsr( "01115" )

   ::oModel                := SQLTiposImpresorasModel():New( self )

   ::oDialogView           := TiposImpresorasView():New( self )

   ::oValidator            := TiposImpresorasValidator():New( self )

   ::Super:New() 

RETURN ( Self )

//---------------------------------------------------------------------------//
