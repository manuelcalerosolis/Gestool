#include "FiveWin.Ch"
#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS OdooConvertController

   DATA oDialogView

   DATA cDirectory                     INIT space( 200 )

   DATA oClientOdooConvert

   DATA oChkClientes
   DATA oMeterClientes
   DATA nMeterClientes                 INIT 0
   DATA lChkClientes                   INIT .t.

   METHOD New()
   
   METHOD End()
   
   METHOD Run()   

   METHOD Convert()

END CLASS

//----------------------------------------------------------------------------//

METHOD New() CLASS OdooConvertController

   ::oDialogView                       := OdooConverterView():New( self )

   ::oClientOdooConvert                := ClientOdooConvert():New( self )

RETURN ( self )

//----------------------------------------------------------------------------//

METHOD End() CLASS OdooConvertController

   ::oDialogView:End()

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD Run() CLASS OdooConvertController

   ::oDialogView:Activate()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD Convert() CLASS OdooConvertController
   
   ::oClientOdooConvert:Run()

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS OdooConverterView FROM SQLBaseView 

   DATA oDialog

   METHOD Activate()

   METHOD closeActivate()   

ENDCLASS

//----------------------------------------------------------------------------//

METHOD Activate() CLASS OdooConverterView

   local oDirectory

   DEFINE DIALOG     ::oDialog ;
      RESOURCE       "ODOO_IMPORTER" 

      REDEFINE BITMAP ::oBitmap ;
         ID          600 ;
         RESOURCE    "gc_recycle_48" ;
         TRANSPARENT ;
         OF          ::oDialog

      REDEFINE GET   oDirectory ;
         VAR         ::oController:cDirectory ;
         ID          300 ;
         BITMAP      "FOLDER" ;
         OF          ::oDialog

      oDirectory:bHelp  := {|| oDirectory:cText( cGetDir32( "Seleccione destino" ) ) }

      // Checks----------------------------------------------------------------

      REDEFINE CHECKBOX ::oController:oChkClientes ;
         VAR         ::oController:lChkClientes ;
         ID          100 ;
         OF          ::oDialog

      ::oController:oMeterClientes  := TApoloMeter():ReDefine( 200, { | u | if( pCount() == 0, ::oController:nMeterClientes, ::oController:nMeterClientes := u ) }, 10, ::oDialog, .f., , , .t., rgb( 255,255,255 ), , rgb( 128,255,0 ) )

      // Botones generales--------------------------------------------------------

      ApoloBtnFlat():Redefine( IDOK, {|| ::closeActivate() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

      ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, ::closeActivate(), ) }

   ACTIVATE DIALOG ::oDialog CENTER

RETURN ( ::oDialog:nResult == IDOK )

//----------------------------------------------------------------------------//

METHOD closeActivate() CLASS OdooConverterView

   if empty( ::oController:cDirectory )
      
      msgStop( "El directorio no puede estar vacio" )

      RETURN ( nil )

   end if 

   ::oController:Convert()

RETURN ( ::oDialog:End( IDOK ) )

//----------------------------------------------------------------------------//