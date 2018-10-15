#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ImpuestosEspecialesController FROM SQLNavigatorController

   METHOD New() CONSTRUCTOR

   METHOD End()

   //Construcciones tardias----------------------------------------------------

   METHOD getBrowseView()                 INLINE( if( empty( ::oBrowseView ), ::oBrowseView := ImpuestosEspecialesBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()                 INLINE( if( empty( ::oDialogView ), ::oDialogView := ImpuestosEspecialesView():New( self ), ), ::oDialogView )

   METHOD getValidator()                  INLINE( if( empty( ::oValidator ), ::oValidator := ImpuestosEspecialesValidator():New( self ), ), ::oValidator )

   METHOD getRepository()                 INLINE ( if( empty( ::oRepository ), ::oRepository := ImpuestosEspecialesRepository():New( self ), ), ::oRepository )
   
   METHOD getModel()                      INLINE ( if( empty( ::oModel ), ::oModel  := SQLImpuestosEspecialesModel():New( self ), ), ::oModel )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenederController ) CLASS ImpuestosEspecialesController

   ::Super:New( oSenederController )

   ::cTitle                      := "Impuestos Especiales"

   ::cName                       := "impuestos_especiales"

   ::hImage                      := {  "16" => "gc_moneybag_euro_16",;
                                       "32" => "gc_moneybag_euro_32",;
                                       "48" => "gc_moneybag_euro_48" }

   ::nLevel                         := Auth():Level( ::cName )

RETURN ( Self )

//---------------------------------------------------------------------------//
METHOD End() CLASS ImpuestosEspecialesController
   
   if !empty( ::oModel )
      ::oModel:End()
   end if

   if !empty( ::oBrowseView )
      ::oBrowseView:End()
   end if

   if !empty( ::oDialogView )
      ::oDialogView:End()
   end if

   if !empty( ::oValidator )
      ::oValidator:End()
   end if

   if !empty( ::oRepository )
      ::oRepository:End()
   end if

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

CLASS ImpuestosEspecialesBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS ImpuestosEspecialesBrowseView

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
      :cSortOrder          := 'importe'
      :cHeader             := 'Importe'
      :nWidth              := 120
      :bEditValue          := {|| ::getRowSet():fieldGet( 'importe' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'subcuenta'
      :cHeader             := 'Subcuenta'
      :nWidth              := 120
      :bEditValue          := {|| ::getRowSet():fieldGet( 'subcuenta' ) }
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

CLASS ImpuestosEspecialesView FROM SQLBaseView

   DATA oSayCamposExtra
  
   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS ImpuestosEspecialesView

   local oBmpGeneral
   local oSayCamposExtra

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "IMPUESTO_ESPECIAL" ;
      TITLE       ::LblTitle() + "impuesto especial"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog ;

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog ;
   
   REDEFINE GET   ::oController:getModel():hBuffer[ "codigo" ] ;
      ID          100 ;
      PICTURE     "@! NNNNNNNNNNNNNNNNNNNN" ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      WHEN        ( ::oController:isAppendOrDuplicateMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:getModel():hBuffer[ "nombre" ] ;
      ID          110 ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:getModel():hBuffer[ "importe" ] ;
      ID          120 ;
      PICTURE     "@! 9999999.999999" ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      SPINNER ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:getModel():hBuffer[ "subcuenta" ] ;
      ID          130 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:getModel():hBuffer[ "subcuenta" ] ;
      ID          131 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE SAYCHECKBOX ::oController:getModel():hBuffer[ "aplicar" ] ;
      ID          140 ;
      IDSAY       142 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE SAY   ::oSayCamposExtra ;
      PROMPT      "Campos extra..." ;
      FONT        oFontBold() ; 
      COLOR       rgb( 10, 152, 234 ) ;
      ID          150 ;
      OF          ::oDialog ;

   ::oSayCamposExtra:lWantClick  := .t.
   ::oSayCamposExtra:OnClick     := {|| ::oController:getCamposExtraValoresController():Edit( ::oController:getUuid() ) }

   ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   if ::oController:isNotZoomMode() 
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5 .and. validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }
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

CLASS ImpuestosEspecialesValidator FROM SQLBaseValidator

   METHOD getValidators()

 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS ImpuestosEspecialesValidator

   ::hValidators  := {  "nombre" =>                {  "required"           => "El nombre es un dato requerido",;
                                                      "unique"             => "El nombre introducido ya existe" },;
                        "codigo" =>                {  "required"           => "El código es un dato requerido" ,;
                                                      "unique"             => "EL código introducido ya existe"  } }
RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLImpuestosEspecialesModel FROM SQLCompanyModel

   DATA cTableName               INIT "impuestos_especiales"

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLImpuestosEspecialesModel

   hset( ::hColumns, "id",                {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;                          
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",              {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"             ,;                                  
                                             "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "codigo",            {  "create"    => "VARCHAR( 20 )"                            ,;
                                             "default"   => {|| space( 20 ) } }                        )

   hset( ::hColumns, "nombre",            {  "create"    => "VARCHAR( 200 )"                          ,;
                                             "default"   => {|| space( 200 ) } }                       )

   hset( ::hColumns, "importe",           {  "create"    => "FLOAT( 14,6 )"                            ,;
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "subcuenta",         {  "create"    => "VARCHAR( 200 )"                          ,;
                                             "default"   => {|| space( 200 ) } }                       )

   hset( ::hColumns, "aplicar",           {  "create"    => "TINYINT( 1 )"                            ,;
                                             "default"   => {|| .f. } }                               )

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

CLASS ImpuestosEspecialesRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLImpuestosEspecialesModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//