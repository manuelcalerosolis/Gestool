#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS MediosPagoController FROM SQLNavigatorController

   METHOD New() CONSTRUCTOR

   METHOD End()

   //Construcciones tardias----------------------------------------------------

   METHOD getBrowseView()     INLINE ( if( empty( ::oBrowseView ), ::oBrowseView := MediosPagoBrowseView():New( self ), ), ::oBrowseView )

   METHOD getDialogView()     INLINE ( if( empty( ::oDialogView ), ::oDialogView := MediosPagoView():New( self ), ), ::oDialogView )

   METHOD getValidator()      INLINE ( if( empty( ::oValidator ), ::oValidator := MediosPagoValidator():New( self ), ), ::oValidator )

   METHOD getRepository()     INLINE ( if( empty( ::oRepository ), ::oRepository := MediosPagoRepository():New( self ), ), ::oRepository )
   
   METHOD getModel()          INLINE ( if( empty( ::oModel ), ::oModel := SQLMediosPagoModel():New( self ), ), ::oModel )

   METHOD getSelector()       INLINE ( if( empty( ::oGetSelector ), ::oGetSelector := GetSelector():New( self ), ), ::oGetSelector )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS MediosPagoController

   ::Super:New( oController )

   ::cTitle                   := "Medios de pago"

   ::cName                    := "medio_pago"

   ::hImage                   := {  "16" => "gc_credit_cards_16",;
                                    "32" => "gc_credit_cards_32",;
                                    "48" => "gc_credit_cards_48" }

   ::nLevel                   := Auth():Level( ::cName )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS MediosPagoController

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

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS MediosPagoBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS MediosPagoBrowseView

   ::getColumnIdAndUuid()

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
      :cSortOrder          := 'codigo_pago'
      :cHeader             := 'Código pago'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'codigo_pago' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'codigo_edi'
      :cHeader             := 'Código edi'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'codigo_edi' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   ::getColumnsCreatedUpdatedAt()
   
   ::getColumnDeletedAt()

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS MediosPagoView FROM SQLBaseView

   DATA oSayCamposExtra

   DATA hIcono

   DATA oCodigoPago

   DATA oGetCodigo

   METHOD New()

   METHOD Activate()

   METHOD startActivate()

   METHOD addLinksToExplorerBar()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS MediosPagoView

   ::Super:New( oController )

   ::hIcono           := { "Dinero"                => "gc_money2_16",;
                           "Tarjeta de credito"    => "gc_credit_cards_16",;
                           "Bolsa de dinero"       => "gc_moneybag_euro_16",;
                           "Porcentaje"            => "gc_symbol_percent_16",;
                           "Cesta de compra"       => "gc_shopping_cart_16" }

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS MediosPagoView

   local oSayCamposExtra

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "MEDIOS_PAGO" ;
      TITLE       ::LblTitle() + "medio de pago"

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

   REDEFINE COMBOBOX ::oCodigoPago ;
      VAR         ::oController:getModel():hBuffer[ "codigo_pago" ] ;
      ITEMS       FORMASDEPAGO_ITEMS ;
      ID           120 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:getModel():hBuffer[ "codigo_edi" ] ;
      ID          130 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   ::redefineExplorerBar( 500 )

   ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, ::oDialog:end( IDOK ), ) }
   
   if ::oController:isNotZoomMode() 
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5 .and. validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }
   end if

   ::oDialog:bStart  := {|| ::startActivate() }

   ACTIVATE DIALOG ::oDialog CENTER

  ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD startActivate()
   
   ::addLinksToExplorerBar()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD addLinksToExplorerBar() CLASS MediosPagoView

   local oPanel            

   oPanel            := ::oExplorerBar:AddPanel( "Datos relacionados", nil, 1 ) 

   if ::oController:isZoomMode()
      RETURN ( nil )
   end if

   oPanel:AddLink(   "Documentos...",;
                     {||   ::oController:getDocumentosController():activateDialogView( ::oController:getUuid() ) },;
                           ::oController:getDocumentosController():getImage( "16" ) )

   oPanel            := ::oExplorerBar:AddPanel( "Otros", nil, 1 ) 

   oPanel:AddLink(   "Campos extra...",;
                     {||   ::oController:getCamposExtraValoresController():Edit( ::oController:getUuid() ) },;
                           ::oController:getCamposExtraValoresController():getImage( "16" ) )

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS MediosPagoValidator FROM SQLBaseValidator

   METHOD getValidators()

END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS MediosPagoValidator

   ::hValidators  := {  "nombre" =>    {  "required"  => "El nombre es un dato requerido",;
                                          "unique"    => "El nombre introducido ya existe" },;
                        "codigo" =>    {  "required"  => "El código es un dato requerido" ,;
                                          "unique"    => "EL código introducido ya existe" } }
RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLMediosPagoModel FROM SQLCompanyModel

   DATA cTableName               INIT "medios_pago"

   DATA cConstraints             INIT "PRIMARY KEY ( codigo, deleted_at )"

   METHOD getColumns()

   METHOD testCreateMetalico()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLMediosPagoModel

   hset( ::hColumns, "id",                   {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"              ,;                          
                                                "default"   => {|| 0 } }                                    )

   hset( ::hColumns, "uuid",                 {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"              ,;                                  
                                                "default"   => {|| win_uuidcreatestring() } }               )

   hset( ::hColumns, "codigo",               {  "create"    => "VARCHAR( 20 )"                               ,;
                                                "default"   => {|| space( 20 ) } }                           )

   hset( ::hColumns, "nombre",               {  "create"    => "VARCHAR( 200 )"                             ,;
                                                "default"   => {|| space( 200 ) } }                         )

   hset( ::hColumns, "codigo_pago",          {  "create"    => "VARCHAR( 200 )"                             ,;                                  
                                                "default"   => {|| space( 200 ) } }                         )

   hset( ::hColumns, "codigo_edi",           {  "create"    => "VARCHAR( 200 )"                             ,;                                  
                                                "default"   => {|| space( 200 ) } }                         )

   ::getTimeStampColumns()

   ::getDeletedStampColumn()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD testCreateMetalico() CLASS SQLMediosPagoModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "codigo", 0 )
   hset( hBuffer, "nombre", "metalico" )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS MediosPagoRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLMediosPagoModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
