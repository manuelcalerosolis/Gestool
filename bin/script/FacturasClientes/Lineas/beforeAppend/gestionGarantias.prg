#include "hbclass.ch"

#define CRLF                        chr( 13 ) + chr( 10 )

#define __default_warranty_days__   10
#define __debug_mode__              .f.

//---------------------------------------------------------------------------//

Function gestionGarantiasFacturas( aLine, aHeader, nView, dbfTmpLin )

Return ( TGestionGarantias():New( aLine, aHeader, nView, dbfTmpLin ):Run() )

//---------------------------------------------------------------------------//

// #include "..\..\..\AlbaranesClientes\Lineas\beforeAppend\gestionGarantias.prg"
#include ".\..\gestion.prg"




