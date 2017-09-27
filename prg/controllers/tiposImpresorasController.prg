#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TiposImpresorasController FROM SQLBaseController

   METHOD New()

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::cTitle                := "Tipos de impresoras"

   ::cImage                := "gc_printer2_16"

   ::nLevel                := nLevelUsr( "01115" )

   ::oModel                := TiposImpresorasModel():New( self )

   ::oRepository           := TiposImpresorasRepository():New( self )

   ::oDialogView           := TiposImpresorasView():New( self )

   ::oValidator            := TiposImpresorasValidator():New( self )

   ::Super:New()

RETURN ( Self )

//---------------------------------------------------------------------------//
