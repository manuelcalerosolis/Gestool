#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS TGenMailingDatabaseSATClientes FROM TGenMailingDatabase 

   METHOD New( nView )

   METHOD getAdjunto()                 INLINE ( mailReportSATCli( ::cFormatoDocumento ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( nView ) CLASS TGenMailingDatabaseSATClientes

   ::Create()

   ::Super:New( nView )

   ::setItems( aItmSatCli() )

   ::setWorkArea( D():SATClientes( nView ) )

   ::setTypeDocument( "nSatCli" )

   ::setTypeFormat( "SC" )

   ::setFormatoDocumento( cFirstDoc( "SC", D():Documentos( nView ) ) )

   ::setBmpDatabase( "gc_power_drill_sat_user_48" )

   ::setAsunto( "Envio de nuestro S.A.T. número {Serie de S.A.T.}/{Número de S.A.T.}" )

Return ( Self )

//---------------------------------------------------------------------------//
