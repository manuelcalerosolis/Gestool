#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS SerieDocumentoComponent

   DATA oSenderController

   DATA bValue

   DATA oGet

   DATA cGet

   METHOD New()

   METHOD End()

   METHOD Activate()

   METHOD Validate()

   METHOD bindValue( bValue )       INLINE ( ::bValue := bValue )

   METHOD evalValue( value )        INLINE ( eval( ::bValue, value ) ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController ) CLASS SerieDocumentoComponent

   ::oSenderController              := oSenderController 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS SerieDocumentoComponent

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Activate( idGet, oDlg ) CLASS SerieDocumentoComponent

   ::cGet         := eval( ::bValue )

   REDEFINE GET   ::oGet ;
      VAR         ::cGet ;
      ID          idGet ;
      PICTURE     "@! XXXXXXXXXXXXXXXXXXXX" ;
      WHEN        ( ::oSenderController:isNotZoomMode() ) ;
      OF          oDlg

   ::oGet:bValid  := {|| ::Validate() }

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Validate() CLASS SerieDocumentoComponent

   local cSerie   := alltrim( ::oGet:varGet() )

   if ::oSenderController:oContadoresModel:isSerie( ::oSenderController:cName, cSerie )
      RETURN ( .t. )
   end if

   if !( msgYesNo( "La serie " + cSerie + ", no existe.", "¿ Desea crear una nueva serie ?" ) )
      RETURN ( .f. )
   end if 

   ::oSenderController:oContadoresModel:insertSerie( ::oSenderController:cName, cSerie ) 

RETURN ( .t. )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS NumeroDocumentoComponent

   DATA oSenderController

   DATA bValue

   DATA oGet

   DATA cGet

   METHOD New()

   METHOD End()

   METHOD Activate()

   METHOD Validate()

   METHOD bindValue( bValue )       INLINE ( ::bValue := bValue )

   METHOD evalValue( value )        INLINE ( eval( ::bValue, value ) ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController ) CLASS NumeroDocumentoComponent

   ::oSenderController              := oSenderController 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS NumeroDocumentoComponent

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Activate( idGet, oDlg ) CLASS NumeroDocumentoComponent

   ::cGet         := eval( ::bValue )

   REDEFINE GET   ::oGet ;
      VAR         ::cGet ;
      ID          idGet ;
      PICTURE     "999999" ;
      WHEN        ( ::oSenderController:isNotZoomMode() ) ;
      OF          oDlg

   ::oGet:bValid  := {|| ::Validate() }

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Validate() CLASS NumeroDocumentoComponent

RETURN ( ::oGet:varGet() > 0 )

//---------------------------------------------------------------------------//


