#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS SerieDocumentoComponent

   DATA oController

   DATA bValue

   DATA oGet

   METHOD New() CONSTRUCTOR

   METHOD End()                     

   METHOD Activate()

   METHOD Validate()

   METHOD bindValue( bValue )       INLINE ( ::bValue := bValue )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS SerieDocumentoComponent

   ::oController  := oController 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS SerieDocumentoComponent

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Activate( idGet, oDlg ) CLASS SerieDocumentoComponent

   ::oGet   := TGet():ReDefine( idGet, ::bValue, oDlg, , "@! XXXXXXXXXXXXXXXXXXXX", {|| ::Validate() }, , , , , , .f., {|| ::oController:isNotZoomMode() }, , .f., .f. )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Validate() CLASS SerieDocumentoComponent

   local cSerie   := alltrim( ::oGet:varGet() )

   if ::oController:getContadoresModel():isSerie( ::oController:cName, cSerie )
      RETURN ( .t. )
   end if

   if !( msgYesNo( "La serie " + cSerie + ", no existe.", "� Desea crear una nueva serie ?" ) )

      msgalert( ::oGet:Original, "ogetOriginal" )

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

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD Activate()

   METHOD Validate()

   METHOD bindValue( bValue )       INLINE ( ::bValue := bValue )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS NumeroDocumentoComponent

   ::oController  := oController 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS NumeroDocumentoComponent

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Activate( idGet, oDlg ) CLASS NumeroDocumentoComponent

   ::oGet   := TGet():ReDefine( idGet, ::bValue, oDlg, , "999999", {|| ::Validate() }, , , , , , .f., {|| ::oController:isNotZoomMode() }, , .f., .f. )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Validate() CLASS NumeroDocumentoComponent

RETURN ( ::oGet:varGet() > 0 )

//---------------------------------------------------------------------------//


