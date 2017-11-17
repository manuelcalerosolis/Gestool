#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS NumericControlView 

   DATA oController

   DATA oPage
   
   DATA oGetNumeric

   DATA oText

   DATA cPicture                          INIT MasUnd()

   DATA cText                             INIT ""

   DATA cFieldName 

   DATA bOnChange                 
   
   METHOD New()

   METHOD createControl( nId, oDialog )

   METHOD getPage()                       INLINE ( ::oPage )

   METHOD setText( cText )                INLINE ( ::cText := cText )

   METHOD setPicture( cPicture )          INLINE ( ::cPicture := cPicture )

   METHOD setOnChange( bChange )          INLINE ( ::bOnChange := bChange )

   METHOD setFieldName( cFieldName )      INLINE ( ::cFieldName := cFieldName )

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

   if empty( ::cPicture )
      RETURN ( Self )
   end if 

   if empty( ::cFieldName )
      RETURN ( Self )
   end if 

   try 

      REDEFINE PAGES ::oPage ;
         ID          nId ;
         OF          oDialog ;
         DIALOGS     "PAGE_NUMERIC_GET_CONTROL"

      REDEFINE SAY   ::oText ;
         PROMPT      ( ::cText ) ;
         ID          101 ;
         OF          ::oPage:aDialogs[ 1 ]

      REDEFINE GET   ::oGetNumeric ;
         VAR         ::oController:oModel:hBuffer[ ::cFieldName ] ;
         ID          100 ;
         SPINNER ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         PICTURE     ( ::cPicture ) ;
         OF          ::oPage:aDialogs[ 1 ]

      if !empty( ::bOnChange )      
         ::oGetNumeric:bChange   := ::bOnChange
      end if 

   catch oError

      msgStop( "Imposible crear el control númerico." + CRLF + ErrorMessage( oError ) )

   end

RETURN ( Self )

//---------------------------------------------------------------------------//


