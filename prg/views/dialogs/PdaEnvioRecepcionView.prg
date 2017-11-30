#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS PdaEnvioRecepcionView FROM SQLBaseView

   DATA oOfficeBar

   DATA oProgress

   DATA nProgress

   METHOD Activate()
      METHOD initActivate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate()

   DEFINE DIALOG ::oDialog RESOURCE "PDA_ENVIO_RECEPCION"

      ::oProgress    := TApoloMeter():ReDefine( 100, { | u | if( pCount() == 0, ::nProgress, ::nProgress := u ) }, 10, ::oDialog, .f., , , .t., rgb( 255,255,255 ), , rgb( 128,255,0 ) )

   ::oDialog:Activate( , , , .t., , , {|| ::initActivate() } ) 

   ::oOfficeBar:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD initActivate()

   local oGrupo
   local oFolder

   ::oOfficeBar               := TDotNetBar():New( 0, 0, ::oDialog:nWidth(), 115, ::oDialog, 1 )

   ::oOfficeBar:lPaintAll     := .f.
   ::oOfficeBar:lDisenio      := .f.

   ::oOfficeBar:SetStyle( 1 )

   ::oDialog:oTop             := ::oOfficeBar

   oFolder                    := TCarpeta():New( ::oOfficeBar, "Acciones" )

   oGrupo                     := TDotNetGroup():New( oFolder, 186, "", .f. )

   TDotNetButton():New( 60, oGrupo, "inbox_out_32", "Exportar información", 1, {|| ::oController:ExportJson() }, , , .f., .f., .f. )

   TDotNetButton():New( 60, oGrupo, "inbox_into_32", "Importar información", 2, {|| msgalert( "Importar") }, , , .f., .f., .f. )

   TDotNetButton():New( 60, oGrupo, "end32", "Salir", 3, {|| ::oDialog:End() }, , , .f., .f., .f. )

RETURN ( Self )

//---------------------------------------------------------------------------//
