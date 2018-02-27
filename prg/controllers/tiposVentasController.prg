#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TiposVentasController FROM SQLNavigatorController

   METHOD   New()

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::cTitle                := "Tipos de ventas"

   ::hImage                := { "16" => "gc_wallet_16" }

   ::nLevel                := nLevelUsr( "01043" )

   ::oModel                := SQLTiposVentasModel():New( self )

   ::oRepository           := TiposVentasRepository():New( self )

   ::oDialogView           := TiposVentasView():New( self )

   ::oValidator            := TiposVentasValidator():New( self )

   ::Super:New()

Return ( Self ) 

//---------------------------------------------------------------------------//

