#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Xbrowse.Ch" 

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS IvaDetalleView FROM SQLBaseView
  
   METHOD Activate( hHash )

END CLASS

//---------------------------------------------------------------------------//
 
METHOD Activate( hHash ) CLASS IvaDetalleView

msgalert( hb_valtoexp( hHash ),"hash")

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "DETALLE_IVA" ;
      TITLE       "Detalle de IVA"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getTipoIvaController():getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog ;

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog ;


   ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ACTIVATE DIALOG ::oDialog CENTER

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//