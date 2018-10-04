#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS CodigosPostalesGestoolController FROM CodigosPostalesController

   METHOD getCodigosPostalesGestoolModel()                            INLINE ( ::oModel := SQLCodigosPostalesGestoolModel():New( self ) )

   METHOD getProvinciasController()             INLINE ( ::oProvinciasController := ProvinciasGestoolController():New( self ) )
   
   METHOD getConfiguracionVistasController()    INLINE ( ::oConfiguracionVistasController := SQLConfiguracionVistasGestoolController():New( self ) )

END CLASS

//---------------------------------------------------------------------------//

CLASS CodigosPostalesController FROM SQLNavigatorController

   DATA oProvinciasController

   METHOD New()

   METHOD End()

   METHOD getCodigosPostalesGestoolModel()                   INLINE ( ::oModel := SQLCodigosPostalesModel():New( self ) )

   METHOD getProvinciasController()    INLINE ( ::oProvinciasController := ProvinciasController():New( self ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS CodigosPostalesController

   ::Super:New( oController )

   ::cTitle                   := "Código postal"

   ::cName                    := "codigos_postales"

   ::hImage                   := {  "16" => "gc_postage_stamp_16",;
                                    "32" => "gc_postage_stamp_32",;
                                    "48" => "gc_postage_stamp_48" }

   if empty( oController )
      ::nLevel                := Auth():Level( ::cName )
   end if 

   ::getCodigosPostalesGestoolModel()                                    

   ::oBrowseView              := CodigosPostalesBrowseView():New( self )

   ::oDialogView              := CodigosPostalesView():New( self )

   ::oValidator               := CodigosPostalesValidator():New( self )

   ::getProvinciasController()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS CodigosPostalesController

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oProvinciasController:End()

   ::Super:End()

RETURN ( nil )

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

   local oGetProvincia

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "CODIGO_POSTAL" ;
      TITLE       ::LblTitle() + "Código postal"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "codigo" ] ;
      ID          100 ;
      PICTURE     "@! NNNNNNNNNNNNNNNNNNNN" ;
      WHEN        ( ::oController:isAppendOrDuplicateMode() ) ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "poblacion" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "poblacion" ) ) ;
      OF          ::oDialog

   REDEFINE GET   oGetProvincia VAR ::oController:oModel:hBuffer[ "provincia" ] ;
      ID          120 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "provincia" ), ::validProvincia() ) ;
      BITMAP      "LUPA" ;
      OF          ::oDialog

      oGetProvincia:bHelp  := {|| ::oController:oProvinciasController:getSelectorProvincia( oGetProvincia ), ::validProvincia() }

   REDEFINE GET ::oSayProvincia VAR ::cSayProvincia ;
      ID          121;
      WHEN        ( .f. );
      OF          ::oDialog

   REDEFINE BUTTON ;
      ID          IDOK ;
      OF          ::oDialog ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ACTION      ( if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          ::oDialog ;
      CANCEL ;
      ACTION      ( ::oDialog:end() )

   if ::oController:isNotZoomMode() 
      ::oDialog:AddFastKey( VK_F5, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) } )
   end if

   ::oDialog:bStart  := {|| ::validProvincia() }

   ACTIVATE DIALOG ::oDialog CENTER

   ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD validProvincia() CLASS CodigosPostalesView

   ::cSayProvincia  := ::oController:oProvinciasController:getModel():getField( "provincia", "codigo", ::oController:oModel:hBuffer[ "provincia" ] )

   if !empty( ::oSayProvincia )
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

CLASS SQLCodigosPostalesGestoolModel FROM SQLCodigosPostalesModel

   METHOD getTableName()         INLINE ( "gestool." + ::cTableName )

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLCodigosPostalesModel FROM SQLCompanyModel

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