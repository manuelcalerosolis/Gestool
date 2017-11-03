#include "fivewin.ch"
#include "factu.ch" 

//---------------------------------------------------------------------------//

CLASS SQLExportableModel FROM SQLBaseModel

   METHOD lCheckEnvioRecepcion()             INLINE ( ConfiguracionEmpresasRepository():getLogic( 'envio_recepcion', .f. ) )

   METHOD CheckFolders()

END CLASS

//---------------------------------------------------------------------------//

METHOD CheckFolders()

   MsgInfo( ::cTableName, "cTableName" )

   MsgInfo( ::lCheckEnvioRecepcion() )

RETURN ( self )

//---------------------------------------------------------------------------//