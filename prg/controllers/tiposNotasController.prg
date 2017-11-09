#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS TiposNotasController FROM SQLNavigatorController

   METHOD   New()

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::cTitle                := "Tipos de notas"

   ::hImage                := { "16" => "gc_folder2_16" }

   ::nLevel                := nLevelUsr( "01101" )

   ::oModel                := SQLTiposNotasModel():New( self )

   ::oRepository           := TiposNotasRepository():New( self )

   ::oDialogView           := TiposNotasView():New( self )

   ::oValidator            := TiposNotasValidator():New( self )

   ::Super:New()

Return ( Self )

//---------------------------------------------------------------------------//

