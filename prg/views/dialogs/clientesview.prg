#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS ClientesView FROM SQLBaseView
  
   DATA oGetDni
   DATA oGetProvincia
   DATA oGetPoblacion
   DATA oGetPais

   METHOD Activate()

   METHOD Activating()

   METHOD getDireccionesController()   INLINE ( ::oController:oDireccionesController )

   METHOD validateFields()

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

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "Cliente" ;
      TITLE       ::LblTitle() + "cliente"

   REDEFINE FOLDER ::oFolder ;
         ID       500 ;
         OF       ::oDialog ;
         PROMPT   "&General";
         DIALOGS  "CLIENTE_GENERAL"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    "gc_user2_48" ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        getBoldFont() ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "codigo" ] ;
      ID          100 ;
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

   REDEFINE GET   ::getDireccionesController():oModel:hBuffer[ "direccion" ] ;
      ID          130 ;
      WHEN        ( ::getDireccionesController():isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   ::getDireccionesController():oModel:hBuffer[ "codigo_postal" ] ;
      ID          140 ;
      WHEN        ( ::getDireccionesController():isNotZoomMode() ) ;
      VALID       ( ::validateFields ) ;
      OF          ::oFolder:aDialogs[1] 

   REDEFINE GET   ::oGetPoblacion VAR ::getDireccionesController():oModel:hBuffer[ "poblacion" ] ;
      ID          150 ;
      WHEN        ( ::getDireccionesController():isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   ::oGetProvincia VAR ::getDireccionesController():oModel:hBuffer[ "provincia" ] ;
      ID          160 ;
      IDTEXT      161 ;
      WHEN        ( ::getDireccionesController():isNotZoomMode() ) ;
      BITMAP      "LUPA" ;
      VALID       ( ::validateFields() ) ;
      OF          ::oFolder:aDialogs[1]

   ::oGetProvincia:bHelp  := {|| ::oController:oProvinciasController:getSelectorProvincia( ::oGetProvincia ), ::validateFields() }

   REDEFINE GET   ::oGetPais VAR ::getDireccionesController():oModel:hBuffer[ "codigo_pais" ] ;
      ID          170 ;
      IDTEXT      171 ;
      WHEN        ( ::getDireccionesController():isNotZoomMode() ) ;
      VALID       ( ::validateFields() ) ;
      BITMAP      "LUPA" ;
      OF          ::oFolder:aDialogs[1]

   ::oGetPais:bHelp  := {|| ::oController:oPaisesController:getSelectorPais( ::oGetPais ), ::validateFields() }

   REDEFINE GET   ::getDireccionesController():oModel:hBuffer[ "telefono" ] ;
      ID          180 ;
      WHEN        ( ::getDireccionesController():isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   ::getDireccionesController():oModel:hBuffer[ "movil" ] ;
      ID          190 ;
      WHEN        ( ::getDireccionesController():isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   ::getDireccionesController():oModel:hBuffer[ "email" ] ;
      ID          200 ;
      WHEN        ( ::getDireccionesController():isNotZoomMode() ) ;
      VALID       ( ::getDireccionesController():validate( "email" ) ) ;
      OF          ::oFolder:aDialogs[1]

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

   ::oDialog:bStart := {|| ::validateFields() }

   ACTIVATE DIALOG ::oDialog CENTER

   ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD validateFields() CLASS ClientesView

   local cPoblacion
   local cCodigoProvincia

   cPoblacion           := SQLCodigosPostalesModel():getField( "poblacion", "codigo", ::getDireccionesController():oModel:hBuffer[ "codigo_postal" ] )

   if !Empty( cPoblacion ) .and. Empty( ::getDireccionesController():oModel:hBuffer[ "poblacion" ] )
      ::oGetPoblacion:cText( cPoblacion )
      ::oGetPoblacion:Refresh()
   end if

   cCodigoProvincia     := SQLCodigosPostalesModel():getField( "provincia", "codigo", ::getDireccionesController():oModel:hBuffer[ "codigo_postal" ] )

   if !Empty( cCodigoProvincia ) .and. Empty( ::getDireccionesController():oModel:hBuffer[ "provincia" ] )
      ::oGetProvincia:cText( cCodigoProvincia )
      ::oGetProvincia:Refresh()
   end if
   
   if !Empty( ::getDireccionesController():oModel:hBuffer[ "provincia" ] )
      ::oGetProvincia:oHelpText:cText( SQLProvinciasModel():getField( "provincia", "codigo", ::getDireccionesController():oModel:hBuffer[ "provincia" ] ) )
      ::oGetProvincia:oHelpText:Refresh()
   end if

   if !Empty( ::getDireccionesController():oModel:hBuffer[ "codigo_pais" ] )
      ::oGetPais:oHelpText:cText( SQLPaisesModel():getField( "nombre", "codigo", ::getDireccionesController():oModel:hBuffer[ "codigo_pais" ] ) )
      ::oGetPais:oHelpText:Refresh()
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//