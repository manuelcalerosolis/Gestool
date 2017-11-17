#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS NumericControlView 

   DATA oController

   DATA oPage
   
   DATA oGetNumeric

   DATA oSayNumeric
   
   METHOD New()

   METHOD createControl( nId, oDialog )

   METHOD getPage()                       INLINE ( ::oPage )

   METHOD setOnChange( bChange )          INLINE ( ::oGetNumeric:bOnChange := bChange )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oController  := oController

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD createControl( nId, oDialog, cFieldName )

   local oError

   if empty( nId ) .or. empty( oDialog )
      RETURN ( Self )
   end if 

   try 

   REDEFINE PAGES ::oPage ;
      ID          nId ;
      OF          oDialog ;
      DIALOGS     "PAGE_NUMERIC_GET_CONTROL"

   REDEFINE SAY   ::oSayNumeric ;
      ID          101 ;
      OF          ::oPage:aDialogs[ 1 ]

   REDEFINE GET   ::oGetNumeric ;
      VAR         ::oController:oModel:hBuffer[ cFieldName ] ;
      ID          100 ;
      SPINNER ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      PICTURE     MasUnd() ;
      OF          ::oPage:aDialogs[ 1 ]

   catch oError

      msgStop( "Imposible crear el control númerico." + CRLF + ErrorMessage( oError ) )

   end

RETURN ( Self )

//---------------------------------------------------------------------------//


