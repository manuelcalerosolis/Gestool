#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS TiposNotasController FROM SQLBaseController

   METHOD   New()

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::cTitle                := "Tipos de notas"

   ::cImage                := "gc_folder2_16"

   ::nLevel                := nLevelUsr( "01101" )

   ::oModel                := TiposNotasModel():New( self )

   ::oRepository           := TiposNotasRepository():New( self )

   ::oDialogView           := TiposNotasView():New( self )

   ::oValidator            := TiposNotasValidator():New( self )

   ::Super:New()

Return ( Self )

//---------------------------------------------------------------------------//

