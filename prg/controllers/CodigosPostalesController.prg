#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS CodigosPostalesController FROM SQLNavigatorController

   DATA oProvinciasController

   METHOD New()

   METHOD End()

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS CodigosPostalesController

   ::Super:New()

   ::cTitle                   := "Código postal"

   ::cName                    := "codigos_postales"

   ::hImage                   := {  "16" => "gc_postage_stamp_16",;
                                    "32" => "gc_postage_stamp_32",;
                                    "48" => "gc_postage_stamp_48" }

   ::nLevel                   := Auth():Level( ::cName )

   ::oModel                   := SQLCodigosPostalesModel():New( self )

   ::oBrowseView              := CodigosPostalesBrowseView():New( self )

   ::oDialogView              := CodigosPostalesView():New( self )

   ::oValidator               := CodigosPostalesValidator():New( self )

   ::oProvinciasController    := ProvinciasController():New( self )

   ::oFilterController:setTableToFilter( ::oModel:cTableName )

RETURN ( Self )

//---------------------------------------------------------------------------//
METHOD End() CLASS CodigosPostalesController

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oProvinciasController:End()

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

CLASS CodigosPostalesBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS CodigosPostalesBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'id'
      :cHeader             := 'Id'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'id' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'codigo'
      :cHeader             := 'Código'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'poblacion'
      :cHeader             := 'Población'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'poblacion' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with 

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'provincia'
      :cHeader             := 'Provincia'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'provincia' ) }
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

CLASS CodigosPostalesView FROM SQLBaseView
  
   DATA oSayProvincia
   DATA cSayProvincia

   METHOD Activate()

   METHOD validProvincia()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS CodigosPostalesView

   local oDlg
   local oBmpGeneral
   local oGetProvincia

   ::validProvincia()

   DEFINE DIALOG  oDlg ;
      RESOURCE    "CODIGO_POSTAL" ;
      TITLE       ::LblTitle() + "Código postal"

   REDEFINE BITMAP oBmpGeneral ;
      ID          900 ;
      RESOURCE    ::oController:getImage( "48" ) ;
      TRANSPARENT ;
      OF          oDlg

   REDEFINE GET   ::oController:oModel:hBuffer[ "codigo" ] ;
      ID          100 ;
      PICTURE     "@! NNNNNNNNNNNNNNNNNNNN" ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      OF          oDlg

   REDEFINE GET   ::oController:oModel:hBuffer[ "poblacion" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "poblacion" ) ) ;
      OF          oDlg

   REDEFINE GET   oGetProvincia VAR ::oController:oModel:hBuffer[ "provincia" ] ;
      ID          120 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "provincia" ), ::validProvincia() ) ;
      BITMAP      "LUPA" ;
      OF          oDlg

      oGetProvincia:bHelp  := {|| ::oController:oProvinciasController:getSelectorProvincia( oGetProvincia ), ::validProvincia() }

   REDEFINE GET ::oSayProvincia VAR ::cSayProvincia ;
      ID          121;
      WHEN        ( .f. );
      OF          oDlg

   REDEFINE BUTTON ;
      ID          IDOK ;
      OF          oDlg ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ACTION      ( if( validateDialog( oDlg ), oDlg:end( IDOK ), ) )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          oDlg ;
      CANCEL ;
      ACTION      ( oDlg:end() )

   if ::oController:isNotZoomMode() 
      oDlg:AddFastKey( VK_F5, {|| if( validateDialog( oDlg ), oDlg:end( IDOK ), ) } )
   end if

   ACTIVATE DIALOG oDlg CENTER

   oBmpGeneral:end()

RETURN ( oDlg:nResult )

//---------------------------------------------------------------------------//

METHOD validProvincia() CLASS CodigosPostalesView

   ::cSayProvincia  := SQLProvinciasModel():getField( "provincia", "codigo", ::oController:oModel:hBuffer[ "provincia" ] )

   if !Empty( ::oSayProvincia )
      ::oSayProvincia:Refresh()
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS CodigosPostalesValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS CodigosPostalesValidator

   ::hValidators  := {     "codigo"       =>    {  "required"           => "El código es un dato requerido"  } ,;
                           "poblacion"    =>    {  "required"           => "La población es un dato requerido" },;
                           "provincia"    =>    {  "required"           => "La provincia es un campo requerido" } }
RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLCodigosPostalesModel FROM SQLBaseModel

   DATA cTableName               INIT "codigos_postales"

   METHOD getColumns()

   DATA cConstraints             INIT "PRIMARY KEY ( id ), UNIQUE KEY ( codigo, poblacion )"

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLCodigosPostalesModel

   hset( ::hColumns, "id",                {  "create"    => "INTEGER AUTO_INCREMENT"               ,;
                                             "text"      => "Identificador"                        ,;
                                             "default"   => {|| 0 } }                               )

   hset( ::hColumns, "codigo",            {  "create"    => "VARCHAR( 20 )"                        ,;
                                             "default"   => {|| space( 20 ) } }                     )

   hset( ::hColumns, "poblacion",         {  "create"    => "VARCHAR( 100 )"                       ,;
                                             "default"   => {|| space( 100 ) } }                    )

   hset( ::hColumns, "provincia",         {  "create"    => "VARCHAR( 5 )"                         ,;
                                             "default"   => {|| space( 5 ) } }                      )

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

CLASS CodigosPostalesRepository FROM SQLBaseRepository

   METHOD getTableName()         INLINE ( SQLCodigosPostalesModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//