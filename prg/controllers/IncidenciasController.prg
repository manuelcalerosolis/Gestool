#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS IncidenciasController FROM SQLNavigatorController

   METHOD New()

   METHOD End()

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS IncidenciasController

   ::Super:New()

   ::cTitle                      := "Tarifas"

   ::cName                       := "tarifas"

   ::hImage                      := {  "16" => "gc_money_interest_16",;
                                       "32" => "gc_money_interest_32",;
                                       "48" => "gc_money_interest_48" }

   ::nLevel                         := Auth():Level( ::cName )

   ::oModel                         := SQLIncidenciasModel():New( self )

   ::oBrowseView                    := IncidenciasBrowseView():New( self )

   ::oDialogView                    := IncidenciasView():New( self )

   ::oValidator                     := IncidenciasValidator():New( self, ::oDialogView )

   ::oRepository                    := IncidenciasRepository():New( self )


RETURN ( Self )

//---------------------------------------------------------------------------//
METHOD End() CLASS IncidenciasController

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

CLASS IncidenciasBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS IncidenciasBrowseView

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
      :cSortOrder          := 'codigo'
      :cHeader             := 'Código'
      :nWidth              := 50
      :bEditValue          := {|| ::getRowSet():fieldGet( 'codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'nombre'
      :cHeader             := 'Nombre'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'margen_predefinido'
      :cHeader             := 'Margen predefinido'
      :nWidth              := 130
      :bEditValue          := {|| ::getRowSet():fieldGet( 'margen_predefinido' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'iva_incluido'
      :cHeader             := 'IVA incluido'
      :SetCheck( { "Sel16", "Nil16" } )
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'iva_incluido' ) }
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

CLASS IncidenciasView FROM SQLBaseView
  
   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS IncidenciasView

   local oDialog
   local oBmpGeneral

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "TARIFA" ;
      TITLE       ::LblTitle() + "tarifa"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    "gc_money_interest_48" ;
      TRANSPARENT ;
      OF          ::oDialog ;

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        getBoldFont() ;
      OF          ::oDialog ;
   
   REDEFINE GET   ::oController:oModel:hBuffer[ "codigo" ] ;
      ID          100 ;
      PICTURE     "@! NNN" ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          110 ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "margen_predefinido" ] ;
      ID          120 ;
      SPINNER ;
      PICTURE     "@E 9999.9999" ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

    REDEFINE SAYCHECKBOX ::oController:oModel:hBuffer[ "iva_incluido" ] ;
      ID          130 ;
      IDSAY       132 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

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

   if ::oController:isNotZoomMode() 
      ::oDialog:AddFastKey( VK_F5, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) } )
   end if

   ACTIVATE DIALOG ::oDialog CENTER

  ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS IncidenciasValidator FROM SQLBaseValidator

   METHOD getValidators()

 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS IncidenciasValidator

   ::hValidators  := {  "nombre" =>                {  "required"              => "El nombre es un dato requerido",;
                                                      "unique"                => "El nombre introducido ya existe" },;
                        "codigo" =>                {  "required"              => "El código es un dato requerido" ,;
                                                      "unique"                => "EL código introducido ya existe"  } }
RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLIncidenciasModel FROM SQLCompanyModel

   DATA cTableName               INIT "incidencias"

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLIncidenciasModel

   hset( ::hColumns, "id",                      {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;                          
                                                   "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",                    {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"             ,;                                  
                                                   "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "parent_uuid",             {  "create"    => "VARCHAR( 40 ) NOT NULL"                   ,;
                                                   "default"   => {|| space( 40 ) } }                        )

   hset( ::hColumns, "nombre",                  {  "create"    => "VARCHAR( 200 )"                          ,;
                                                   "default"   => {|| space( 200 ) } }                       )

   hset( ::hColumns, "descripcion",             {  "create"    => "VARCHAR( 200 )"                          ,;
                                                   "default"   => {|| space( 200 ) } }                       )

   hset( ::hColumns, "fecha_hora",              {  "create"    => "TIMESTAMP"                            ,;
                                                   "default"   => {|| 0 } }                                  )

   hset( ::hColumns, "resuelta",                {  "create"    => "BIT"                                      ,;
                                                   "default"   => {|| .f. } }                                )

   hset( ::hColumns, "fecha_hora_resolucion",   {  "create"    => "TIMESTAMP"                            ,;
                                                   "default"   => {|| 0 } }                                  )

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

CLASS IncidenciasRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLIncidenciasModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//