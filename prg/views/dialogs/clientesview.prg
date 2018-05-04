#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS ClientesView FROM SQLBaseView
  
   DATA oGetDni
   DATA oGetProvincia
   DATA oGetPoblacion
   DATA oGetPais

   DATA oGetAgentes

   METHOD Activate()

   METHOD Activating()

   METHOD getDireccionesController()   INLINE ( ::oController:oDireccionesController )

   METHOD startDialog()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activating() CLASS ClientesView

   if ::oController:isAppendOrDuplicateMode()
      ::oController:oModel:hBuffer()
   end if 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS ClientesView

   local oFld
   local oBtnAppend
   local oBtnEdit
   local oBtnDelete

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "CONTAINER_MEDIUM" ;
      TITLE       ::LblTitle() + "cliente"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    "gc_user2_48" ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      PROMPT      "Clientes" ;
      ID          800 ;
      FONT        getBoldFont() ;
      OF          ::oDialog

   REDEFINE FOLDER ::oFolder ;
      ID          500 ;
      OF          ::oDialog ;
      PROMPT      "&General",;
                  "&Direcciones";
      DIALOGS     "CLIENTE_GENERAL" ,;
                  "CLIENTE_DIRECCIONES"

   /*
   GENERAL---------------------------------------------------------------------
   */

   REDEFINE GET   ::oController:oModel:hBuffer[ "codigo" ] ;
      ID          100 ;
      PICTURE     ( "@! NNNNNNNNNNNN" ) ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   ::oGetDni VAR ::oController:oModel:hBuffer[ "dni" ] ;
      ID          120 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( CheckCif( ::oGetDni ) );
      OF          ::oFolder:aDialogs[1]

   ::oController:oDireccionesController:oDialogView:ExternalRedefine( ::oFolder:aDialogs[1] )

   ::oController:oAgentesController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "agente_uuid" ] ) )
   ::oController:oAgentesController:oGetSelector:Activate( 240, 241, ::oFolder:aDialogs[1] )

   /*
   DIRECCIONES-----------------------------------------------------------------
   */

   REDEFINE BUTTON oBtnAppend ;
      ID          100 ;
      OF          ::oFolder:aDialogs[2] ;
      WHEN        ( ::oController:isNotZoomMode() ) ;

   oBtnAppend:bAction   := {|| ::oController:oDireccionesController:Append() }

   REDEFINE BUTTON oBtnEdit ;
      ID          110 ;
      OF          ::oFolder:aDialogs[2] ;
      WHEN        ( ::oController:isNotZoomMode() ) ;

   oBtnEdit:bAction   := {|| ::oController:oDireccionesController:Edit() }

   REDEFINE BUTTON oBtnDelete ;
      ID          120 ;
      OF          ::oFolder:aDialogs[2] ;
      WHEN        ( ::oController:isNotZoomMode() ) ;

   oBtnDelete:bAction   := {|| ::oController:oDireccionesController:Delete() }

   ::oController:oDireccionesController:Activate( ::oFolder:aDialogs[2], 130 )

   REDEFINE BUTTON ;
      ID          IDOK ;
      OF          ::oDialog ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ACTION      ( if( validateDialog( ::oFolder:aDialogs ), ::oDialog:end( IDOK ), ) )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          ::oDialog ;
      CANCEL ;
      ACTION      ( ::oDialog:end() )

   if ::oController:isNotZoomMode() 
      ::oDialog:AddFastKey( VK_F5, {|| if( validateDialog( ::oFolder:aDialogs ), ::oDialog:end( IDOK ), ) } )
   end if

   ::oDialog:bStart := {|| ::startDialog() }

   ACTIVATE DIALOG ::oDialog CENTER

   ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD startDialog()

   ::oController:oAgentesController:oGetSelector:Start()

   ::oController:oDireccionesController:externalStartDialog()

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//