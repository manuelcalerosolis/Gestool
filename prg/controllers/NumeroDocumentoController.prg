#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS SerieDocumentoComponent

   DATA oController

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

METHOD New( oController ) CLASS SerieDocumentoComponent

   ::oController                    := oController 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS SerieDocumentoComponent

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Activate( idGet, oDlg ) CLASS SerieDocumentoComponent

   ::cGet         := eval( ::bValue )

   REDEFINE GET   ::oGet ;
      VAR         ::cGet ;
      ID          idGet ;
      PICTURE     "@! XXXXXXXXXXXXXXXXXXXX" ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          oDlg

   ::oGet:bValid  := {|| ::Validate() }

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Validate() CLASS SerieDocumentoComponent

   local cSerie   := alltrim( ::oGet:varGet() )

   if ::oController:getContadoresModel():isSerie( ::oController:cName, cSerie )
      RETURN ( .t. )
   end if

   if !( msgYesNo( "La serie " + cSerie + ", no existe.", "¿ Desea crear una nueva serie ?" ) )
      RETURN ( .f. )
   end if 

   ::oController:getContadoresModel():insertSerie( ::oController:cName, cSerie ) 

RETURN ( .t. )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS NumeroDocumentoComponent

   DATA oController

   DATA bValue

   DATA oGet

   DATA cGet

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD Activate()

   METHOD Validate()

   METHOD bindValue( bValue )       INLINE ( ::bValue := bValue )

   METHOD evalValue( value )        INLINE ( eval( ::bValue, value ) ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS NumeroDocumentoComponent

   ::oController                    := oController 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS NumeroDocumentoComponent

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Activate( idGet, oDlg ) CLASS NumeroDocumentoComponent

   ::cGet         := eval( ::bValue )

   REDEFINE GET   ::oGet ;
      VAR         ::cGet ;
      ID          idGet ;
      PICTURE     "999999" ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          oDlg

   ::oGet:bValid  := {|| ::Validate() }

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Validate() CLASS NumeroDocumentoComponent

RETURN ( ::oGet:varGet() > 0 )

//---------------------------------------------------------------------------//


