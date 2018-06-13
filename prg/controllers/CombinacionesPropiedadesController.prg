#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS CombinacionesPropiedadesController FROM SQLNavigatorController

   METHOD New()

   METHOD End()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController ) CLASS CombinacionesPropiedadesController

   ::Super:New( oSenderController )

   ::cTitle                      := "Combinaciones de Propiedades"

   ::cName                       := "combinaciones_propiedades"

   ::hImage                      := {  "16" => "gc_cash_register_refresh_16",;
                                       "32" => "gc_cash_register_refresh_32",;
                                       "48" => "gc_cash_register_refresh_48" }

   ::nLevel                         := Auth():Level( ::cName )

   ::oModel                         := SQLCombinacionesPropiedadesModel():New( self )

   ::oBrowseView                    := CombinacionesPropiedadesBrowseView():New( self )

   ::oDialogView                    := CombinacionesPropiedadesView():New( self )

   ::oValidator                     := CombinacionesPropiedadesValidator():New( self, ::oDialogView )

   ::oRepository                    :=CombinacionesPropiedadesRepository():New( self )

   ::oGetSelector                   := GetSelector():New( self )   

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS CombinacionesPropiedadesController

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oRepository:End()

   ::Super:End()

RETURN ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS CombinacionesPropiedadesBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS CombinacionesPropiedadesBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'id'
      :cHeader             := 'Id'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'id' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Uuid'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'parent_uuid'
      :cHeader             := 'Artículo'
      :nWidth              := 120
      :bEditValue          := {|| ::getRowSet():fieldGet( 'parent_uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'propiedad_uuid'
      :cHeader             := 'Valor propiedad'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'propiedad_uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with


RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS CombinacionesPropiedadesView FROM SQLBaseView
  
   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS CombinacionesPropiedadesView

   /*DEFINE DIALOG  ::oDialog ;
      RESOURCE    "ENTRADA_SALIDA" ;
      TITLE       ::LblTitle() + "Entrada o salida de caja"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog ;

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        getBoldFont() ;
      OF          ::oDialog ;

   REDEFINE COMBOBOX ::oTipo ;
      VAR         ::oController:oModel:hBuffer[ "tipo" ] ;
      ID          100 ;
      ITEMS       ::aTipo;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "importe" ] ;
      ID          110 ;
      VALID       ( ::oController:validate( "importe" ) ) ;
      SPINNER ;
      PICTURE     "@E 9999999.999" ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          120 ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "sesion" ] ;
      ID          130 ;
      WHEN        ( .f. ) ;
      OF          ::oDialog ;
   // codigo caja-------------------------------------------------------------------------------------------------------//

   ::oController:oCajasController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "caja_codigo" ] ) )
   
   ::oController:oCajasController:oGetSelector:setEvent( 'validated', {|| ::CajasControllerValidated() } )

   ::oController:oCajasController:oGetSelector:Activate( 140, 141, ::oDialog )

   // cliente------------------------------------------------------------------------------------------------------------//
  
  REDEFINE GET   ::oController:oModel:hBuffer[ "fecha_hora" ] ;
      ID          150 ;
      SPINNER ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

      ::redefineExplorerBar( 160 )

   REDEFINE BUTTON ;
      ID          IDOK ;
      OF          ::oDialog ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ACTION      ( if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          ::oDialog ;
      CANCEL ;
      ACTION     ( ::oDialog:end() )

   ACTIVATE DIALOG ::oDialog CENTER*/
   

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS CombinacionesPropiedadesValidator FROM SQLBaseValidator

   METHOD getValidators()

 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS CombinacionesPropiedadesValidator

   /*::hValidators  := {  "nombre" =>                {  "required"           => "El nombre es un dato requerido"    ,;
                                                      "unique"             => "El nombre introducido ya existe"   },;
                        "tipos"  =>                {  "required"           => "El tipo es un datos requerido"     },;
                        "Importe"  =>              {  "required"           => "El importe es un datos requerido"  } }*/
RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLCombinacionesPropiedadesModel FROM SQLCompanyModel

   DATA cTableName               INIT "combinaciones_propiedades"

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLCombinacionesPropiedadesModel

   hset( ::hColumns, "id",                   {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"              ,;                          
                                                "default"   => {|| 0 } }                                    )

   hset( ::hColumns, "uuid",                 {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"                ,;                                  
                                                "default"   => {|| win_uuidcreatestring() } }               )

   hset( ::hColumns, "parent_uuid",          {  "create"    => "VARCHAR( 40 )"                              ,;
                                                "default"   => {|| ::getSenderControllerParentUuid() } }    )

   hset( ::hColumns, "propiedad_uuid",       {  "create"    => "VARCHAR( 40 )"                              ,;
                                                "default"   => { || space ( 40 )  } }                       ) 

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS CombinacionesPropiedadesRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLCombinacionesPropiedadesModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//