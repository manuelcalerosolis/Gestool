#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS EnviromentController FROM SQLBaseController

   DATA hCaja

   DATA hSesion

   DATA hAlmacen

   DATA oCajasController

   DATA oSesionesController

   DATA oAlmacenesController

   DATA oDelegacionesController

   DATA aComboCajas
   DATA cComboCaja

   DATA aComboAlmacenes
   DATA cComboAlmacen

   DATA aComboDelegaciones
   DATA cComboDelegacion

   METHOD New() CONSTRUCTOR
   METHOD End()

   METHOD Activate()                   

   METHOD isShow()

   METHOD Show()

   METHOD loadData()

   METHOD setData()
   
   METHOD isMultiplesCajas()           INLINE ( if( hb_isarray( ::aComboCajas ), len( ::aComboCajas ) > 1, .f. ) )
   
   METHOD isMultiplesAlmacenes()       INLINE ( if( hb_isarray( ::aComboAlmacenes ), len( ::aComboAlmacenes ) > 1, .f. ) )

   METHOD isMultiplesDelegaciones()    INLINE ( if( hb_isarray( ::aComboDelegaciones ), len( ::aComboDelegaciones ) > 1, .f. ) )
   
   METHOD isEmpyDelegaciones()         INLINE ( if( hb_isarray( ::aComboDelegaciones ), len( ::aComboDelegaciones ) == 0, .f. ) )

   METHOD changeCajas()

   METHOD changeAlmacenes()

   METHOD changeDelegaciones()

   METHOD setSesion()

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

   ::oDelegacionesController           := DelegacionesController():New( self )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS EnviromentController

   if !empty( ::oDialogView )
      ::oDialogView:End()
      ::oDialogView              := nil
   end if 

   if !empty( ::oCajasController )
      ::oCajasController:End()
      ::oCajasController         := nil
   end if 

   if !empty( ::oSesionesController )
      ::oSesionesController:End()
      ::oSesionesController      := nil
   end if 

   if !empty( ::oAlmacenesController )
      ::oAlmacenesController:End()
      ::oAlmacenesController     := nil
   end if 

   if !empty( ::oDelegacionesController )
      ::oDelegacionesController:End()
      ::oDelegacionesController  := nil
   end if 
   
   ::Super:End()

   hb_gcall( .t. )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS EnviromentController

   ::New()

   ::Show()

   ::End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD loadData() CLASS EnviromentController

   ::aComboCajas                       := ::oCajasController:oModel:getNombres()

   ::cComboCaja                        := atail( ::aComboCajas )

   ::aComboAlmacenes                   := ::oAlmacenesController:oModel:getNombres()

   ::cComboAlmacen                     := atail( ::aComboAlmacenes )

   ::aComboDelegaciones                := ::oDelegacionesController:oModel:getNombresWhereParentUuid( Company():Uuid() )

   ::cComboDelegacion                  := atail( ::aComboDelegaciones )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD setData() CLASS EnviromentController

   ::changeCajas()

   ::changeAlmacenes()

   ::changeDelegaciones()

   ::setSesion()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD isShow() CLASS EnviromentController

   ::loadData()

   if ::isMultiplesCajas() .or. ::isMultiplesAlmacenes() .or. ::isMultiplesDelegaciones()
      ::oDialogView:Activate()
   end if 

   ::setData()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD Show() CLASS EnviromentController

   ::loadData()

   ::oDialogView:Activate()

   ::setData()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD changeCajas() CLASS EnviromentController

   Box():guardWhereNombre( ::cComboCaja )

   ::checkSessions()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD setSesion() CLASS EnviromentController

   ::hSesion   := ::oSesionesController:oModel:getLastOpenWhereCajaNombre( ::cComboCaja ) 
   
   if !empty( ::hSesion )
      Session( ::hSesion )
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD changeAlmacenes() CLASS EnviromentController

   Store():guardWhereNombre( ::cComboAlmacen )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD changeDelegaciones() CLASS EnviromentController

   Delegation():guardWhereNombre( ::cComboDelegacion, Company():Uuid() )

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

   DATA oSayDelegaciones

   DATA oSaySessiones

   DATA oComboCaja

   DATA oComboAlmacen

   DATA oComboDelegaciones

   METHOD Activate()
      METHOD startActivate()
      METHOD Validate()

   METHOD showDelegaciones()     INLINE ( if( !empty( ::oSayDelegaciones ),   ::oSayDelegaciones:Show(), ),;
                                          if( !empty( ::oComboDelegaciones ), ::oComboDelegaciones:Show(), ) )
   METHOD hideDelegaciones()     INLINE ( if( !empty( ::oSayDelegaciones ),   ::oSayDelegaciones:Hide(), ),;
                                          if( !empty( ::oComboDelegaciones ), ::oComboDelegaciones:Hide(), ) )

   METHOD showSaySessiones()     INLINE ( if( !empty( ::oSaySessiones ), ::oSaySessiones:Show(), ) )
   METHOD hideSaySessiones()     INLINE ( if( !empty( ::oSaySessiones ), ::oSaySessiones:Hide(), ) )
   
END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS EnviromentView 

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "ENVIROMENT" ;
      TITLE       "Entorno de trabajo : " + Company():Nombre()

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    "gc_desk_128" ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oSayDelegaciones ;
      ID          131 ;
      OF          ::oDialog

   REDEFINE COMBOBOX ::oComboDelegaciones ;
      VAR         ::oController:cComboDelegacion ;
      ID          130 ;
      ITEMS       ::oController:aComboDelegaciones ;
      OF          ::oDialog

   ::oComboDelegaciones:bChange  := {|| ::oController:changeDelegaciones() }

   REDEFINE COMBOBOX ::oComboAlmacen ;
      VAR         ::oController:cComboAlmacen ;
      ID          120 ;
      ITEMS       ::oController:aComboAlmacenes ;
      OF          ::oDialog

   ::oComboAlmacen:bChange       := {|| ::oController:changeAlmacenes() }

   REDEFINE SAY   ::oSayCaja ;
      ID          101 ;
      OF          ::oDialog

   REDEFINE COMBOBOX ::oComboCaja ;
      VAR         ::oController:cComboCaja ;
      ID          100 ;
      ITEMS       ::oController:aComboCajas ;
      OF          ::oDialog

   ::oComboCaja:bChange          := {|| ::oController:changeCajas() }

   REDEFINE SAY   ::oSaySessiones ;
      PROMPT      "Iniciar una sesión de trabajo..." ;
      FONT        oFontBold() ; 
      COLOR       rgb( 10, 152, 234 ) ;
      ID          110 ;
      OF          ::oDialog ;

   ::oSaySessiones:lWantClick    := .t.
   ::oSaySessiones:OnClick       := {|| ::oController:oSesionesController:Append(), ::oController:checkSessions() }

   REDEFINE BUTTON ;
      ID          IDOK ;
      OF          ::oDialog ;
      ACTION      ( ::Validate() )

   ::oDialog:bStart              := {|| ::startActivate() }

   ::oDialog:AddFastKey( VK_F5, {|| ::Validate() } )

   ::oDialog:Activate( , , , .t. )

   ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD startActivate() CLASS EnviromentView

   if ::oController:isEmpyDelegaciones()
      ::oSayDelegaciones:Hide()
      ::oComboDelegaciones:Hide()
   end if 

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

