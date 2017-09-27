#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TiposImpresorasController FROM SQLBaseController

   METHOD New()

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   msgalert( "New")

   ::cTitle                := "Tipos de impresoras"
msgalert( "1")
   ::cImage                := "gc_printer2_16"
msgalert( "2")
   ::nLevel                := nLevelUsr( "01115" )
msgalert( "3")
   ::oModel                := TiposImpresorasModel():New( self )
msgalert( "4")
   ::oRepository           := TiposImpresorasRepository():New( self )
msgalert( "5")
   ::oDialogView           := TiposImpresorasView():New( self )
msgalert( "6")
   ::oValidator            := TiposImpresorasValidator():New( self )
msgalert( "7")
   ::Super:New()

   msgalert( "super new")

RETURN ( Self )

//---------------------------------------------------------------------------//
