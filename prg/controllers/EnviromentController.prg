#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS EnviromentController FROM SQLBaseController

   DATA hCaja

   DATA oCajasController

   DATA aComboCajas
   DATA cComboCaja

   METHOD New()
   METHOD End()

   METHOD isShow()

   METHOD loadData()

   METHOD setData()
   
   METHOD isMultiplesCajas()           INLINE ( if( hb_isarray( ::aComboCajas ), len( ::aComboCajas ) > 1, .f. ) )

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

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS EnviromentController

   ::oCajasController:End()
   
   ::Super:End()

   Self                                := nil

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD loadData() CLASS EnviromentController

   ::aComboCajas                       := ::oCajasController:oModel:getArrayNombres()

   ::cComboCaja                        := atail( ::aComboCajas )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD setData() CLASS EnviromentController

   ::hCaja                             := ::oCajasController:oModel:getWhereNombre( ::cComboCaja )

   if !empty( ::hCaja )
      Box( ::hCaja )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD isShow() CLASS EnviromentController

   ::loadData()

   if ::isMultiplesCajas()
      ::oDialogView:Activate()
   end if 

   ::setData()

RETURN ( .t. )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS EnviromentView FROM SQLBaseView

   DATA oSayCaja

   DATA oComboCaja

   METHOD Activate()
      METHOD startActivate()
      METHOD Validate()
   
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

   REDEFINE SAY   ::oSayCaja ;
      ID          101 ;
      OF          ::oDialog

   REDEFINE COMBOBOX ::oComboCaja ;
      VAR         ::oController:cComboCaja ;
      ID          100 ;
      ITEMS       ::oController:aComboCajas ;
      OF          ::oDialog

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

