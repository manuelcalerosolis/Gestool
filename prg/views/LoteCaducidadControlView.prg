#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS LoteCaducidadControlView 

   DATA oController

   DATA oPage
   
   DATA oGetLote
   
   DATA oGetCaducidad

   METHOD New()

   METHOD createControl( nId, oDialog, cFieldCodigo, cFieldValor )

   METHOD getPage()                       INLINE ( ::oPage )

   METHOD getLote()                       INLINE ( ::oGetLote )
   METHOD getLoteValue()                  INLINE ( ::oGetLote:varGet() )
   METHOD setLoteValue( cLote )           INLINE ( ::oGetLote:cText( cLote ) )
   METHOD getLoteVisible()                INLINE ( ::oGetLote:lVisible )
   METHOD setLoteOriginal( cLote )        INLINE ( ::oGetLote:setOriginal( cLote ) )
   METHOD isLoteOriginalChanged( cLote )  INLINE ( ::oGetLote:isOriginalChanged( cLote ) )

   METHOD getCaducidad()                  INLINE ( ::oGetCaducidad )
   METHOD getCaducidadValue()             INLINE ( ::oGetCaducidad:varGet() )
   METHOD setCaducidadValue( dCaducidad ) INLINE ( ::oGetCaducidad:cText( dCaducidad ) )
   METHOD getCaducidadVisible()           INLINE ( ::oGetCaducidad:lVisible )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oController  := oController

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD createControl( nId, oDialog )

   local oError

   if empty( nId ) .or. empty( oDialog )
      RETURN ( Self )
   end if 

   try 

   REDEFINE PAGES ::oPage ;
      ID          120 ;
      OF          oDialog ;
      DIALOGS     "PAGE_LOTE_CADUCIDAD_CONTROLS"

   REDEFINE GET   ::oGetLote ;
      VAR         ::oController:oModel:hBuffer[ "lote" ] ;
      ID          100 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oPage:aDialogs[ 1 ]

   ::oGetLote:bValid   := {|| ::oController:validateLote() }

   REDEFINE GET   ::oGetCaducidad ;
      VAR         ::oController:oModel:hBuffer[ "fecha_caducidad" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oPage:aDialogs[ 1 ]

   catch oError

      msgStop( "Imposible crear el control de lote y caducidad." + CRLF + ErrorMessage( oError ) )

   end

RETURN ( Self )

//---------------------------------------------------------------------------//

