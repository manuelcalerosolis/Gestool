#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS TipoIvaController FROM SQLNavigatorController

   DATA oCamposExtraValoresController

   METHOD New()

   METHOD End()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController ) CLASS TipoIvaController

   ::Super:New( oSenderController )

   ::cTitle                         := "Tipos de IVA"

   ::cName                          := "tipo_iva"

   ::hImage                         := {  "16" => "gc_moneybag_16",;
                                          "32" => "gc_moneybag_32",;
                                          "48" => "gc_moneybag_48" }

   ::nLevel                         := Auth():Level( ::cName )

   ::oModel                         := SQLTiposIvaModel():New( self )

   ::oBrowseView                    := TipoIvaBrowseView():New( self )

   ::oDialogView                    := TipoIvaView():New( self )

   ::oValidator                     := TipoIvaValidator():New( self, ::oDialogView )

   ::oCamposExtraValoresController  := CamposExtraValoresController():New( self, ::oModel:cTableName )

   ::oRepository                    := TipoIvaRepository():New( self )

   ::oGetSelector                   := GetSelector():New( self )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS TipoIvaController

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oRepository:End()

   ::oCamposExtraValoresController:End()

   ::oGetSelector:End()

   ::Super:End()

RETURN ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TipoIvaBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS TipoIvaBrowseView

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
      :cHeader             := 'C�digo'
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
      :cSortOrder          := 'porcentaje'
      :cHeader             := 'Porcentaje IVA'
      :nWidth              := 130
      :bEditValue          := {|| transform( ::getRowSet():fieldGet( 'porcentaje' ), "@E 999.99" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with
      with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'recargo'
      :cHeader             := 'Recargo equivalencia'
      :nWidth              := 130
      :bEditValue          := {|| transform( ::getRowSet():fieldGet( 'recargo' ), "@E 999.99" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'cuenta_compra'
      :cHeader             := 'Cuenta de compra'
      :nWidth              := 130
      :bEditValue          := {|| ::getRowSet():fieldGet( 'cuenta_compra' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'cuenta_venta'
      :cHeader             := 'Cuenta de venta'
      :nWidth              := 130
      :bEditValue          := {|| ::getRowSet():fieldGet( 'cuenta_venta' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TipoIvaView FROM SQLBaseView

   DATA oSayCamposExtra
  
   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS TipoIvaView

   local oBmpGeneral
   local oSayCamposExtra

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "IVA_TIPO" ;
      TITLE       ::LblTitle() + "tipo de IVA"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog ;

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        getBoldFont() ;
      OF          ::oDialog ;
   
   REDEFINE GET   ::oController:oModel:hBuffer[ "codigo" ] ;
      ID          100 ;
      PICTURE     "@! NNNNNNNNNNNNNNNNNNNN" ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          110 ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "porcentaje" ] ;
      ID          120 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      PICTURE     "@E 999.99" ;
      SPINNER ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "recargo" ] ;
      ID          130 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      PICTURE     "@E 999.99" ;
      SPINNER ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "cuenta_compra" ] ;
      ID          140 ;
      VALID       ( ::oController:validate( "cuenta_compra" ) ) ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "cuenta_venta" ] ;
      ID          150 ;
      VALID       ( ::oController:validate( "cuenta_venta" ) ) ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE SAY   ::oSayCamposExtra ;
      PROMPT      "Campos extra..." ;
      FONT        getBoldFont() ; 
      COLOR       rgb( 10, 152, 234 ) ;
      ID          160 ;
      OF          ::oDialog ;

   ::oSayCamposExtra:lWantClick  := .t.
   ::oSayCamposExtra:OnClick     := {|| ::oController:oCamposExtraValoresController:Edit( ::oController:getUuid() ) }

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

CLASS TipoIvaValidator FROM SQLCompanyValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS TipoIvaValidator

   ::hValidators  := {  "nombre" =>    {  "required"  => "El nombre es un dato requerido",;
                                          "unique"    => "El nombre introducido ya existe" },;
                        "codigo" =>    {  "required"  => "El c�digo es un dato requerido" ,;
                                          "unique"    => "EL c�digo introducido ya existe" } }
RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLTiposIvaModel FROM SQLCompanyModel

   DATA cTableName                              INIT "tipos_iva"

   METHOD getColumns()

   METHOD getPorcentajeWhereCodigo( cCodigo )   INLINE ( ::getField( "porcentaje", "codigo", cCodigo ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLTiposIvaModel

   hset( ::hColumns, "id",                {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;                          
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",              {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"             ,;                                  
                                             "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "codigo",            {  "create"    => "VARCHAR( 20 )"                            ,;
                                             "default"   => {|| space( 20 ) } }                        )

   hset( ::hColumns, "nombre",            {  "create"    => "VARCHAR( 200 )"                          ,;
                                             "default"   => {|| space( 200 ) } }                       )

   hset( ::hColumns, "porcentaje",        {  "create"    => "FLOAT( 5,2 )"                            ,;
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "recargo",           {  "create"    => "FLOAT( 5,2 )"                            ,;
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "cuenta_compra",     {  "create"    => "VARCHAR ( 20 )"                          ,;
                                             "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "cuenta_venta",      {  "create"    => "VARCHAR ( 20 )"                          ,;
                                             "default"   => {|| space( 20 ) } }                       )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TipoIvaRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLTiposIvaModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
