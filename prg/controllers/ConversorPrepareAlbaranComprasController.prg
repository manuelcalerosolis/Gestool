#include "FiveWin.Ch"
#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS ConversorPrepareAlbaranComprasController FROM ConversorPrepareController

   DATA aCreatedDocument               INIT {}

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD Run( aSelected )             

   METHOD convertDocument( aConvert )

   METHOD showResume()

   //Construcciones tardias----------------------------------------------------

   METHOD getConversorView()              INLINE ( if( empty( ::oConversorView ), ::oConversorView := ConversorResumenView():New( self ), ), ::oConversorView )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oOrigenController , oDestinoController, aSelected ) CLASS ConversorPrepareAlbaranComprasController

   ::Super:New( oOrigenController )

   ::oDestinoController             := oDestinoController

   ::aSelected                      := aSelected

   ::oConversorDocumentosController := ConversorDocumentosController():New( self )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD End() CLASS ConversorPrepareAlbaranComprasController

   if !empty( ::oConversorDocumentosController )
      ::oConversorDocumentosController:End()
   end if

   if !empty( ::oConversorView )
      ::oConversorView:End()
   end if

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//

METHOD Run() CLASS ConversorPrepareAlbaranComprasController

   ::getConversorDocumentosController():runConvertAlbaran( ::aSelected )

   ::convertDocument()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD convertDocument() CLASS ConversorPrepareAlbaranComprasController

   ::aCreatedDocument := ::getConversorDocumentosController():convertDocument()

   ::showResume()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD showResume() CLASS ConversorPrepareAlbaranComprasController

   if !empty( ::aCreatedDocument )
      ::getConversorView:Activate()
   end if

   ::aCreatedDocument := {}

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ConversorResumenView FROM SQLBaseView
                                          
   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS ConversorResumenView

   DEFINE DIALOG  ::oDialog;
      RESOURCE    "RESUMEN_CONVERSION"; 
      TITLE       "Resumen de la conversión ..."

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    "gc_tags_48" ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      PROMPT      "Resumen de la conversión a facturas" ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog

   ::oController:Activate( 100, ::oDialog )

   // Botones------------------------------------------------------------------

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )
   
   ::oDialog:bStart     := {|| ::paintedActivate() }

   ::oDialog:Activate( , , , .t. )

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
