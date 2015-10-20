#include "hbclass.ch"

#define CRLF chr( 13 ) + chr( 10 )

//---------------------------------------------------------------------------//

Function Inicio( nView, dbfTikT )

   if ( oUser():cCodigo != '000' )
   	( dbfTikT )->( dbSetFilter( {|| Field->cNcjTik == oUser():cCaja() }, "cNcjTik == oUser():cCaja()" ) )
   end if

Return ( nil )

//---------------------------------------------------------------------------//

