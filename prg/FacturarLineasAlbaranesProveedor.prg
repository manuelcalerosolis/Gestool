#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "Xbrowse.ch"

//---------------------------------------------------------------------------//

CLASS TFacturarLineasAlbaranesProveedor

   DATA oDlg

   DATA cPath

   DATA nView

   DATA lPrint

   DATA oFecIniPrv
   DATA oFecFinPrv
   DATA dFecIniPrv
   DATA dFecFinPrv

   DATA oPeriodoPrv
   DATA aPeriodoPrv            AS ARRAY INIT {}
   DATA cPeriodoPrv

   DATA cNumFac

   METHOD FacturarLineasCompletas( nView )

   METHOD ResourceLineasCompleta()

END CLASS

//---------------------------------------------------------------------------//

METHOD FacturarLineasCompletas( nView ) CLASS TFacturarLineasAlbaranesProveedor

   ?"Entro por donde debo"

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

   /*
   Creamos los temporales necesarios-------------------------------------------
   */

   //::CreaTemporales()

   /*
   Montamos el recurso---------------------------------------------------------
   */

   ::ResourceLineasCompleta()

   /*
   Destruimos las temporales---------------------------------------------------
   */

   //::EliminaTemporales()

Return ( ::lPrint )

//---------------------------------------------------------------------------//

METHOD ResourceLineasCompleta() CLASS TFacturarLineasAlbaranesProveedor

   local oFont             := TFont():New( "Arial", 8, 26, .F., .T. )

   DEFINE DIALOG ::oDlg RESOURCE "FacturaLineasCompletasAlbaranes"

      REDEFINE COMBOBOX ::oPeriodoPrv ;
         VAR         ::cPeriodoPrv ;
         ID          100 ;
         ITEMS       ::aPeriodoPrv ;
         ON CHANGE   ( Msginfo( "cambio" ) ); //lRecargaFecha( oFecIniCli, oFecFinCli, cPeriodoCli ), LoadPageClient( aTmp[ _COD ] ) ) ;
         OF          ::oDlg

      REDEFINE GET ::oFecIniPrv VAR ::dFecIniPrv;
         ID          110 ;
         SPINNER ;
         VALID       ( .t. ); //LoadPageClient( aTmp[ _COD ] ) );
         OF          ::oDlg

      REDEFINE GET ::oFecFinPrv VAR ::dFecFinPrv;
         ID          120 ;
         SPINNER ;
         VALID       ( .t. ); //LoadPageClient( aTmp[ _COD ] ) );
         OF          ::oDlg

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

