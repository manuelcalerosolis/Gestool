#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS NumeroDocumentoController

   DATA oSenderController

   DATA oConfiguracionesModel 

   DATA oValidator

   DATA bValue

   DATA oGet

   DATA cGet

   METHOD New()

   METHOD End()

   METHOD Activate()

   METHOD Validate()

   METHOD bindValue( bValue )       INLINE ( ::bValue := bValue )

   METHOD evalValue( value )        INLINE ( eval( ::bValue, value ) ) 

   METHOD Stamp()

   METHOD checkSerie()        

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController ) CLASS NumeroDocumentoController

   ::oSenderController              := oSenderController 

   ::oValidator                     := SQLBaseValidator():New()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS NumeroDocumentoController

   ::oValidator:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Activate( idGet, oDlg ) CLASS NumeroDocumentoController

   ::cGet         := eval( ::bValue )

   REDEFINE GET   ::oGet ;
      VAR         ::cGet ;
      ID          idGet ;
      WHEN        ( ::oSenderController:isNotZoomMode() ) ;
      OF          oDlg

   ::oGet:bValid  := {|| ::Validate() }

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Validate() CLASS NumeroDocumentoController

   if !::oValidator:numeroDocumento( ::cGet )
      RETURN ( .f. )
   end if 
      
   ::Stamp()
      
RETURN ( ::checkSerie() )

//---------------------------------------------------------------------------//

METHOD Stamp() CLASS NumeroDocumentoController

   local nAt
   local cSerie   := ""
   local nNumero
   local cNumero  := alltrim( ::oGet:varGet() )

   nAt            := rat( "/", cNumero )
   if nAt == 0
      cNumero     := padr( rjust( cNumero, "0", 6 ), 50 )
   else 
      cSerie      := upper( substr( cNumero, 1, nAt - 1 ) )
      nNumero     := substr( cNumero, nAt + 1 )
      cNumero     := padr( cSerie + "/" + rjust( nNumero, "0", 6 ), 50 )
   end if 
      
   ::oGet:cText( cNumero )

   ::evalValue( cNumero )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD checkSerie() CLASS NumeroDocumentoController

   local nAt
   local cSerie
   local cNumero  := alltrim( ::oGet:varGet() )

   nAt            := rat( "/", cNumero )
   if nAt == 0
      RETURN ( .t. )
   end if 

   cSerie         := upper( substr( cNumero, 1, nAt - 1 ) )

   if ::oSenderController:oContadoresModel:isSerie( ::oSenderController:cName, cSerie )
      RETURN ( .t. )
   end if

   if msgYesNo( "La serie " + cSerie + ", no existe.", "¿ Desea crear una nueva serie ?" )
      ::oSenderController:oContadoresModel:insertSerie( ::oSenderController:cName, cSerie ) 
   else 
      RETURN ( .f. )
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//


