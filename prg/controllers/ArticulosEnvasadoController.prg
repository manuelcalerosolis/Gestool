#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ArticulosEnvasadoController FROM SQLNavigatorController

   DATA oImagenesController

   DATA oCamposExtraValoresController

   DATA oGetSelector

   METHOD New()

   METHOD End()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController ) CLASS ArticulosEnvasadoController

   ::Super:New( oSenderController )

   ::cTitle                      := "Envasado"

   ::cName                       := "envasado"

   ::hImage                      := {  "16" => "gc_box_closed_16",;
                                       "32" => "gc_box_closed_32",;
                                       "48" => "gc_box_closed_48" }

   ::nLevel                         := Auth():Level( ::cName )

   ::oModel                         := SQLArticulosEnvasadoModel():New( self )

   ::oBrowseView                    := ArticulosEnvasadoBrowseView():New( self )

   ::oDialogView                    := ArticulosEnvasadoView():New( self )

   ::oValidator                     := ArticulosEnvasadoValidator():New( self, ::oDialogView )

   ::oCamposExtraValoresController  := CamposExtraValoresController():New( self, 'envases_articulos' )

   ::oRepository                    := ArticulosEnvasadoRepository():New( self )

   ::oGetSelector                   := GetSelector():New( self )

   ::oFilterController:setTableToFilter( ::oModel:cTableName )


RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS ArticulosEnvasadoController

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oCamposExtraValoresController:End()

   ::oRepository:End()

   ::oGetSelector:End()

   ::Super:End()

RETURN ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosEnvasadoBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS ArticulosEnvasadoBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'id'
      :cHeader             := 'Id'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'id' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Uuid'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'codigo'
      :cHeader             := 'Código'
      :nWidth              := 80
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

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosEnvasadoView FROM SQLBaseView
  
   METHOD Activate()

   METHOD Activating()

    DATA oSayCamposExtra


END CLASS

//---------------------------------------------------------------------------//

METHOD Activating() CLASS ArticulosEnvasadoView

   if ::oController:isAppendOrDuplicateMode()
      ::oController:oModel:hBuffer()
   end if 

RETURN ( self )
//---------------------------------------------------------------------------//

METHOD Activate() CLASS ArticulosEnvasadoView

   local oSayCamposExtra

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "ARTICULO_ENVASADO" ;
      TITLE       ::LblTitle() + "envasado"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getimage("48")  ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        getBoldFont() ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "codigo" ] ;
      ID          100 ;
      PICTURE     "@! NNN" ;
      WHEN        ( ::oController:isNotZoomMode()  ) ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode()  ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          ::oDialog

   REDEFINE SAY   ::oSayCamposExtra ;
      PROMPT      "Campos extra..." ;
      FONT        getBoldFont() ; 
      COLOR       rgb( 10, 152, 234 ) ;
      ID          120 ;
      OF          ::oDialog

   ::oSayCamposExtra:lWantClick  := .t.
   ::oSayCamposExtra:OnClick     := {|| ::oController:oCamposExtraValoresController:Edit( ::oController:getUuid() ) }

   REDEFINE BUTTON ;
      ID          IDOK ;
      OF          ::oDialog ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ACTION      ( if( validateDialog( ::oDialog ), ::oDialog:End( IDOK ), ) )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          ::oDialog ;
      CANCEL ;
      ACTION      ( ::oDialog:End() )

   if ::oController:isNotZoomMode() 
      ::oDialog:AddFastKey( VK_F5, {|| if( validateDialog( ::oDialog ), ::oDialog:End( IDOK ), ) } )
   end if

   ACTIVATE DIALOG ::oDialog CENTER

  ::oBitmap:End()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosEnvasadoValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS ArticulosEnvasadoValidator

   ::hValidators  := {  "codigo" =>    {  "required"           => "El código es un dato requerido",;
                                          "unique"             => "El código introducido ya existe" } ,;
                        "nombre" =>    {  "required"           => "El nombre es un dato requerido",;
                                          "unique"             => "El nombre introducido ya existe" } }                

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLArticulosEnvasadoModel FROM SQLBaseModel

   DATA cTableName                     INIT "articulos_envasado"

   METHOD getColumns()

   /*METHOD getNombreWhereUuid( uuid )   INLINE ( ::getField( "nombre", "uuid", uuid ) )*/

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLArticulosEnvasadoModel


   hset( ::hColumns, "id",          {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                       "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",        {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;
                                       "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "codigo",      {  "create"    => "VARCHAR( 3 )"                            ,;
                                       "default"   => {|| space( 3 ) } }                        )

   hset( ::hColumns, "nombre",      {  "create"    => "VARCHAR( 100 )"                          ,;
                                       "default"   => {|| space( 100 ) } }                       )

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

CLASS ArticulosEnvasadoRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLArticulosEnvasadoModel():getTableName() ) 

   /*METHOD getNombres()                 

   METHOD getNombreWhereUuid( Uuid )      INLINE ( ::getColumnWhereUuid( Uuid, "nombre" ) )

   METHOD getUuidWhereNombre( cNombre )   INLINE ( ::getUuidWhereColumn( cNombre, "nombre", "" ) )*/

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

/*METHOD getNombres() CLASS ArticulosEnvasadoRepository

   local cSQL
   local aNombres       

   cSQL                 := "SELECT nombre FROM " + ::getTableName() + " "
   cSQL                 +=    "ORDER BY nombre ASC"

   aNombres             := ::getDatabase():selectFetchArrayOneColumn( cSQL )

   ains( aNombres, 1, "", .t. )

RETURN ( aNombres )*/

//---------------------------------------------------------------------------//