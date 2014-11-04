#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "Xbrowse.ch"

//---------------------------------------------------------------------------//

CLASS TFacturarLineasAlbaranesProveedor FROM DialogBuilder

   DATA cPath

   DATA lPrint

   DATA oProveedor
   DATA oPeriodo

   DATA oFechaInicio
   DATA oFechaFin

   DATA oFecIniPrv
   DATA oFecFinPrv
   DATA dFecIniPrv
   DATA dFecFinPrv

   DATA oPeriodoPrv
   DATA aPeriodoPrv            AS ARRAY INIT {}
   DATA cPeriodoPrv

   DATA cNumFac

   METHOD New( nView )

   METHOD Resource()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( nView ) CLASS TFacturarLineasAlbaranesProveedor

   /*
   Tomamos los valores iniciales-----------------------------------------------
   */

   ::cNumFac   := ""
   ::lPrint    := .f.
   ::nView     := nView

   /*
   Comprobaciones antes de entrar----------------------------------------------
   */

   if ::nView < 1
      msgStop( "La vista creada no es válida" )
      Return .f.
   end if

   /*
   Valores iniciales ----------------------------------------------------------
   */

   ::oProveedor            := GetProveedor():Build( { "idGet" => 130, "idSay" => 140, "oContainer" => Self } )

   ::oPeriodo              := GetPeriodo():Build( { "idCombo" => 100, "idFechaInicio" => 110, "idFechaFin" => 120, "oContainer" => Self } )

   /*
   Creamos los temporales necesarios-------------------------------------------
   */

   //::CreaTemporales()

   /*
   Montamos el recurso---------------------------------------------------------
   */

   ::Resource()

   /*
   Destruimos las temporales---------------------------------------------------
   */

   //::EliminaTemporales()

Return ( ::lPrint )

//---------------------------------------------------------------------------//

METHOD Resource() CLASS TFacturarLineasAlbaranesProveedor

   local oFont       := TFont():New( "Arial", 8, 26, .F., .T. )

   DEFINE DIALOG ::oDlg RESOURCE "FacturaLineasCompletasAlbaranes"

      aEval( ::aComponents, {| o | o:Resource() } )

      /*
      Botones------------------------------------------------------------------
      */

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       ::oDlg ;
         ACTION   ( ::oDlg:End() )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       ::oDlg ;
         CANCEL ;
         ACTION   ( ::oDlg:End() )

      ::oDlg:Activate( , , , .t., , , {|| msginfo( "abriendo el recurso" ) } ) //::InitResource() } )

      //::oBrwLineasAlbaran:CloseData()
      //::oBrwLineasFactura:CloseData()

      oFont:End()

Return ( Self )

//---------------------------------------------------------------------------//

