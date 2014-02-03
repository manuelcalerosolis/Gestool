#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "Xbrowse.ch"

//---------------------------------------------------------------------------//

CLASS TFacturarLineasAlbaranes

   DATA oDlg

   DATA cPath

   DATA nView

   DATA cNumAlb

   DATA cTmpAlbLin
   DATA cTmpFacLin

   DATA cTemporalLineaAlbaran
   DATA cTemporalLineaFactura

   METHOD FacturarLineas( cNumAlb )

   METHOD CreaTemporales()

   METHOD EliminaTemporales()

   METHOD DividirenPorcentaje()

   METHOD Resource()

   METHOD ActualizarAlbaran()

   METHOD GenerarFactura()

END CLASS

//---------------------------------------------------------------------------//

METHOD FacturarLineas( nView ) CLASS TFacturarLineasAlbaranes

   /*
   Comproba----------------------------------------------------
   */
  




   ::nView     := nView
   ::cNumAlb   := ( TDataView():Get( "AlbCliT", ::nView ) )->cSerAlb + Str( ( TDataView():Get( "AlbCliT", ::nView ) )->nNumAlb ) + ( TDataView():Get( "AlbCliT", ::nView ) )->cSufAlb

   /*
   Creamos los temporales necesarios-------------------------------------------
   */

   ::CreaTemporales()

   /*
   Montamos el recurso---------------------------------------------------------
   */

   ::Resource()

   MsgAlert( "Entro en el método" )
   
   MsgAlert( ::cNumAlb, "Número de albarán" )
   MsgAlert( ::nView, "Vista abierta" )

   ?TDataView():Get( "AlbCliT", ::nView )
   ?TDataView():Get( "AlbCliL", ::nView )
   ?TDataView():Get( "AlbCliP", ::nView )
   ?TDataView():Get( "AlbCliS", ::nView )
   ?TDataView():Get( "AlbCliD", ::nView )
   ?TDataView():Get( "AlbCliI", ::nView )
   ?TDataView():Get( "FacCliT", ::nView )
   ?TDataView():Get( "FacCliL", ::nView )
   ?TDataView():Get( "FacCliP", ::nView )
   ?TDataView():Get( "FacCliS", ::nView )

   /*
   Destruimos las temporales---------------------------------------------------
   */

   ::EliminaTemporales()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD CreaTemporales() CLASS TFacturarLineasAlbaranes

   local cDbfAlbLin     := "ACliL"
   local cDbfFacLin     := "FCliL"

   ::cTmpAlbLin         := cGetNewFileName( cPatTmp() + cDbfAlbLin )
   ::cTmpFacLin         := cGetNewFileName( cPatTmp() + cDbfFacLin )

   /*
   Creamos la base de datos temporal de lineas de albaranes--------------------
   */

   dbCreate( ::cTmpAlbLin, aSqlStruct( aColAlbCli() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), ::cTmpAlbLin, cCheckArea( cDbfAlbLin, @::cTemporalLineaAlbaran ), .f. )

   ( ::cTemporalLineaAlbaran )->( OrdCondSet( "!Deleted()", {|| !Deleted() } ) )
   ( ::cTemporalLineaAlbaran )->( OrdCreate( ::cTmpAlbLin, "nNumAlb", "Str( Recno() )", {|| Str( Recno() ) } ) )

   /*
   Pasamos la información de la tabla definitiva a la temporal-----------------
   */

   if ( TDataView():Get( "AlbCliL", ::nView ) )->( dbSeek( ::cNumAlb ) )
      while ( ( TDataView():Get( "AlbCliL", ::nView ) )->cSerAlb + Str( ( TDataView():Get( "AlbCliL", ::nView ) )->nNumAlb ) + ( TDataView():Get( "AlbCliL", ::nView ) )->cSufAlb ) == ::cNumAlb .and. !( TDataView():Get( "AlbCliL", ::nView ) )->( eof() )
         dbPass( TDataView():Get( "AlbCliL", ::nView ), ::cTemporalLineaAlbaran, .t. )
         ( TDataView():Get( "AlbCliL", ::nView ) )->( dbSkip() )
      end while
      end if

   ( ::cTemporalLineaAlbaran )->( dbGoTop() )

   /*
   Creamos la base de datos temporal de lineas de facturas---------------------
   */

   dbCreate( ::cTmpFacLin, aSqlStruct( aColFacCli() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), ::cTmpFacLin, cCheckArea( cDbfFacLin, @::cTemporalLineaFactura ), .f. )

   ( ::cTemporalLineaFactura )->( OrdCondSet( "!Deleted()", {|| !Deleted() } ) )
   ( ::cTemporalLineaFactura )->( OrdCreate( ::cTmpFacLin, "nNumFac", "Str( Recno() )", {|| Str( Recno() ) } ) )

Return ( Self ) 

//---------------------------------------------------------------------------//

METHOD EliminaTemporales() CLASS TFacturarLineasAlbaranes

   if !Empty( ::cTemporalLineaAlbaran ) .and. ( ::cTemporalLineaAlbaran )->( Used() )
      ( ::cTemporalLineaAlbaran )->( dbCloseArea() )
   end if

   if !Empty( ::cTemporalLineaFactura ) .and. ( ::cTemporalLineaFactura )->( Used() )
      ( ::cTemporalLineaFactura )->( dbCloseArea() )
   end if

   ::cTemporalLineaAlbaran      := nil
   ::cTemporalLineaFactura      := nil

   dbfErase( ::cTmpAlbLin )
   dbfErase( ::cTmpFacLin )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD Resource() CLASS TFacturarLineasAlbaranes

   DEFINE DIALOG ::oDlg RESOURCE "FacturaLineasAlbaranes"

      










      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       ::oDlg ;
         ACTION   ( ::oDlg:End() )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       ::oDlg ;
         CANCEL ;
         ACTION   ( ::oDlg:End() )

   ACTIVATE DIALOG ::oDlg CENTER

Return ( Self )

//---------------------------------------------------------------------------//

METHOD DividirenPorcentaje() CLASS TFacturarLineasAlbaranes

Return ( Self )

//---------------------------------------------------------------------------//

METHOD ActualizarAlbaran() CLASS TFacturarLineasAlbaranes

Return ( Self )

//---------------------------------------------------------------------------//

METHOD GenerarFactura() CLASS TFacturarLineasAlbaranes

Return ( Self )

//---------------------------------------------------------------------------//