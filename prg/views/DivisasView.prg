#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS DivisasView FROM SQLBaseView

   METHOD New()
 
   METHOD createEditControl( hControl )

   METHOD stampCambio()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oController           := oController

Return ( Self )

//---------------------------------------------------------------------------//

METHOD createEditControl( hControl )

   local oError
   local oGetDivisa
   local oBmpDivisa
   local oGetDivisaCambio

   if !hhaskey( hControl, "idGet" )    .or.  ;
      !hhaskey( hControl, "idBmp" )    .or.  ;
      !hhaskey( hControl, "idValue" )  .or.  ;
      !hhaskey( hControl, "dialog" )   
      RETURN ( Self )
   end if 

   try 

      REDEFINE GET   oGetDivisa ;
         VAR         ::oController:oModel:hBuffer[ "divisa" ] ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         PICTURE     "@!" ;
         ID          ( hGet( hControl, "idGet" ) ) ;
         BITMAP      "Lupa" ;
         OF          ( hGet( hControl, "dialog" ) )

      oGetDivisa:bValid       := {|| if( ::oController:validate( "divisa" ), ::stampCambio( oGetDivisaCambio ), .f. ) }
      oGetDivisa:bHelp        := {|| BrwDiv( oGetDivisa, oBmpDivisa, oGetDivisaCambio ) }

      REDEFINE BITMAP oBmpDivisa ;
         RESOURCE    "BAN_EURO" ;
         ID          ( hGet( hControl, "idBmp" ) ) ;
         OF          ( hGet( hControl, "dialog" ) )

      REDEFINE GET   oGetDivisaCambio ;
         VAR         ::oController:oModel:hBuffer[ "divisa_cambio" ] ;
         WHEN        ( .f. ) ;
         ID          ( hGet( hControl, "idValue" ) ) ;
         PICTURE     "@E 999,999.999999" ;
         OF          ( hGet( hControl, "dialog" ) )

   catch oError

      msgStop( "Imposible crear el control de divisas." + CRLF + ErrorMessage( oError ) )

   end

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD stampCambio( oGetDivisaCambio )

   local nCambio  := DivisasModel():getCambio( ::oController:oModel:hBuffer[ "divisa" ] )

   if !empty( nCambio )
      oGetDivisaCambio:setText( nCambio )
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//
