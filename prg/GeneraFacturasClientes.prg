#include "FiveWin.Ch" 
#include "Folder.ch"
#include "Report.ch"
#include "Menu.ch"
#include "Xbrowse.ch"
#include "Factu.ch" 

CLASS GeneraFacturasClientes FROM DialogBuilder
 
   DATA oDlg
   DATA oPag
   DATA oBmp
   DATA oBtnPrv
   DATA oBtnNxt
   DATA oMetMsg
   DATA nMetMsg      INIT 0

   DATA oPeriodo
   DATA oClienteInicio
   DATA oClienteFin
   DATA oGrupoClienteInicio
   DATA oGrupoClienteFin

   METHOD New()

   METHOD Resource()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS GeneraFacturasClientes

   ::Resource()

Return ( self )

//---------------------------------------------------------------------------//

METHOD Resource() CLASS GeneraFacturasClientes

   DEFINE DIALOG ::oDlg RESOURCE "GENERARFACTURA"

   REDEFINE PAGES ::oPag ;
      ID       110 ;
      OF       ::oDlg ;
      DIALOGS  "GENFAC_03"

   REDEFINE BITMAP ::oBmp ;
      ID       600 ;
      RESOURCE "plantillas_automaticas_48_alpha" ;
      TRANSPARENT ;
      OF       ::oDlg 

   

   //::oPeriodo     := GetPeriodo():Build( { "idCombo" => 110, "idFechaInicio" => 120, "idFechaFin" => 130, "oContainer" => Self } )

   // Clientes-----------------------------------------------------------------

   /*::oClienteInicio        := GetCliente():New( 150, 152, 151, Self )
   ::oClienteInicio:SetText( "Desde" )
   ::oClienteInicio:First()

   ::oClienteFin           := GetCliente():New( 160, 162, 161, Self )
   ::oClienteFin:SetText( "Hasta" )
   ::oClienteFin:Last()*/

   // Grupo de cliente---------------------------------------------------------

   /*::oGrupoClienteInicio   := GetGrupoCliente():New( 340, 350, 341, Self )
   ::oGrupoClienteInicio:SetText( "Desde grupo cliente" )
   ::oGrupoClienteInicio:First()

   ::oGrupoClienteFin      := GetGrupoCliente():New( 360, 370, 361, Self )
   ::oGrupoClienteFin:SetText( "Hasta grupo cliente" )
   ::oGrupoClienteFin:Last()*/


   

   ::oMetMsg      := TApoloMeter():ReDefine( 120, { | u | if( pCount() == 0, ::nMetMsg, ::nMetMsg := u ) }, 10, ::oDlg, .f., , , .t., rgb( 255,255,255 ), , rgb( 128,255,0 ) )          

   REDEFINE BUTTON ::oBtnPrv ;
      ID       500;
      OF       ::oDlg ;
      ACTION   ( msginfo( "Anterior" ) )

   REDEFINE BUTTON ::oBtnNxt ;
      ID       501;
      OF       ::oDlg ;
      ACTION   ( msginfo( "Siguiente" ) )

   REDEFINE BUTTON ;
      ID       IDCANCEL ;
      OF       ::oDlg ;
      CANCEL ;
      ACTION   ( ::oDlg:End() )

   ::oDlg:bStart  := {|| aEval( ::aComponents, {| o | o:Resource() } ) } 

   ACTIVATE DIALOG ::oDlg CENTER

Return ( self )

//---------------------------------------------------------------------------//