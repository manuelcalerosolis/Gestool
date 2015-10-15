#include "hbclass.ch"

#define CRLF chr( 13 ) + chr( 10 )

//---------------------------------------------------------------------------//

Function Inicio( nView, dbfTikT )

   ( dbfTikT )->( dbSetFilter( {|| Field->cNcjTik == oUser():cCaja() }, "cNcjTik == oUser():cCaja()" ) )

Return ( nil )

//---------------------------------------------------------------------------//

