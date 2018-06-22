#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS EnviromentController FROM SQLBaseController

   DATA hCaja

   DATA hSesion

   DATA oCajasController

   DATA oSesionesController

   DATA oAlmacenesController

   DATA aComboCajas
   DATA cComboCaja

   DATA aComboAlmacenes
   DATA cComboAlmacen

   METHOD New()
   METHOD End()

   METHOD isShow()

   METHOD loadData()

   METHOD setData()
   
   METHOD isMultiplesCajas()           INLINE ( if( hb_isarray( ::aComboCajas ), len( ::aComboCajas ) > 1, .f. ) )
   
   METHOD isMultiplesAlmacenes()       INLINE ( if( hb_isarray( ::aComboAlmacenes ), len( ::aComboAlmacenes ) > 1, .f. ) )

   METHOD changeCajas()

   METHOD changeAlmacenes()

   METHOD checkSessions()

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS EnviromentController

   ::Super:New()

   ::cTitle                            := "Enviroment"

   ::cName                             := "enviroment"

   ::hImage                            := {  "16" => "gc_businesspeople_16",;
                                             "48" => "gc_businesspeople_48" }

   ::oDialogView                       := EnviromentView():New( self )

   ::oCajasController                  := CajasController():New( self )

   ::oSesionesController               := SesionesController():New( self )

   ::oAlmacenesController              := AlmacenesController():New( self )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS EnviromentController

   ::oCajasController:End()

   ::oSesionesController:End()

   ::oAlmacenesController:End()
   
   ::Super:End()

   Self                                := nil

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD loadData() CLASS EnviromentController

   ::aComboCajas                       := ::oCajasController:oModel:getArrayNombres()

   ::cComboCaja                        := atail( ::aComboCajas )

   ::aComboAlmacenes                   := ::oAlmacenesController:oModel:getArrayNombres()

   ::cComboAlmacen                     := atail( ::aComboAlmacenes )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD setData() CLASS EnviromentController

   ::hCaja                             := ::oCajasController:oModel:getWhereNombre( ::cComboCaja )

   if !empty( ::hCaja )
      Box( ::hCaja )
   end if 

   ::hSesion                           := ::oSesionesController:oModel:getLastOpenWhereCaja( ::cComboCaja ) 
   if !empty( ::hSesion )
      SessionManager( ::hSesion )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD isShow() CLASS EnviromentController

   ::loadData()

   if ::isMultiplesCajas() .or. ::isMultiplesAlmacenes()
      ::oDialogView:Activate()
   end if 

   ::setData()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD changeCajas() CLASS EnviromentController

   Box():guardWhereNombre( ::oDialogView:oComboCaja:varGet() )

   ::checkSessions()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD changeAlmacenes() CLASS EnviromentController

   msgalert( ::oDialogView:oComboAlmacen:varGet() )

   // ::checkSessions()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD checkSessions() CLASS EnviromentController

   if ::oSesionesController:oModel:isOpenSessions()
      ::oDialogView:hideSaySessiones()
   else
      ::oDialogView:showSaySessiones()
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS EnviromentView FROM SQLBaseView

   DATA oSayCaja

   DATA oSaySessiones

   DATA oComboCaja

   DATA oComboAlmacen

   METHOD Activate()
      METHOD startActivate()
      METHOD Validate()

   METHOD showSaySessiones    INLINE ( ::oSaySessiones:Show() )
   METHOD hideSaySessiones    INLINE ( ::oSaySessiones:Hide() )
   
END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS EnviromentView 

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "ENVIROMENT" ;
      TITLE       "Entorno de trabajo : " + Company():Nombre()

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    "gestool_logo" ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE COMBOBOX ::oComboAlmacen ;
      VAR         ::oController:cComboAlmacen ;
      ID          120 ;
      ITEMS       ::oController:aComboAlmacenes ;
      OF          ::oDialog

   ::oComboAlmacen:bChange    := {|| ::oController:changeAlmacenes() }

   REDEFINE SAY   ::oSayCaja ;
      ID          101 ;
      OF          ::oDialog

   REDEFINE COMBOBOX ::oComboCaja ;
      VAR         ::oController:cComboCaja ;
      ID          100 ;
      ITEMS       ::oController:aComboCajas ;
      OF          ::oDialog

   ::oComboCaja:bChange    := {|| ::oController:changeCajas() }

   REDEFINE SAY   ::oSaySessiones ;
      PROMPT      "Iniciar una sesión de trabajo..." ;
      FONT        getBoldFont() ; 
      COLOR       rgb( 10, 152, 234 ) ;
      ID          110 ;
      OF          ::oDialog ;

   ::oSaySessiones:lWantClick  := .t.
   ::oSaySessiones:OnClick     := {|| ::oController:oSesionesController:Append(), ::oController:checkSessions() }

   REDEFINE BUTTON ;
      ID          IDOK ;
      OF          ::oDialog ;
      ACTION      ( ::Validate() )

   ::oDialog:bStart  := {|| ::startActivate() }

   ::oDialog:AddFastKey( VK_F5, {|| ::Validate() } )

   ::oDialog:Activate( , , , .t. )

   ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD startActivate() CLASS EnviromentView

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Validate() CLASS EnviromentView

   ::oDialog:end( IDOK ) 

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

