#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS MetodosPagosController FROM SQLNavigatorController

   METHOD New() CONSTRUCTOR

   METHOD End()

   //Construcciones tardias----------------------------------------------------

   METHOD getBrowseView()     INLINE ( if( empty( ::oBrowseView ), ::oBrowseView := MetodosPagoBrowseView():New( self ), ), ::oBrowseView )

   METHOD getDialogView()     INLINE ( if( empty( ::oDialogView ), ::oDialogView := MetodosPagoView():New( self ), ), ::oDialogView )

   METHOD getValidator()      INLINE ( if( empty( ::oValidator ), ::oValidator := MetodosPagoValidator():New( self ), ), ::oValidator )

   METHOD getRepository()     INLINE ( if( empty( ::oRepository ), ::oRepository := MetodosPagoRepository():New( self ), ), ::oRepository )
   
   METHOD getModel()          INLINE ( if( empty( ::oModel ), ::oModel := SQLMetodosPagoModel():New( self ), ), ::oModel )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS MetodosPagosController

   ::Super:New( oController )

   ::cTitle                   := "Métodos de pago"

   ::cName                    := "metodo_pago"

   ::hImage                   := {  "16" => "gc_credit_cards_16",;
                                    "32" => "gc_credit_cards_32",;
                                    "48" => "gc_credit_cards_48" }

   ::nLevel                   := Auth():Level( ::cName )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS MetodosPagosController

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

CLASS MetodosPagoBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS MetodosPagoBrowseView

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
      :cSortOrder          := 'cobrado'
      :cHeader             := 'Cobrado'
      :nWidth              := 80
      :nHeadBmpNo          := 3
      :bEditValue          := {|| if( ::getRowSet():fieldGet( 'cobrado' ) == 1, 'Cobrado', 'No cobrado' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'numero_plazos'
      :cHeader             := 'Numero plazos'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'numero_plazos' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'primer_plazo'
      :cHeader             := 'Primer plazo'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'primer_plazo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'entre_plazo'
      :cHeader             := 'Entre plazo'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'entre_plazo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'ultimo_plazo'
      :cHeader             := 'Último plazo'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'ultimo_plazo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
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

CLASS MetodosPagoView FROM SQLBaseView

   DATA oSayCamposExtra

   DATA oTipoPago

   DATA oCobrado
  
   DATA oIcono

   DATA oGenerar

   DATA hIcono

   DATA oCodigoPago

   DATA oGetCodigo

   METHOD New()

   METHOD Activate()

   METHOD startActivate()

   METHOD addLinksToExplorerBar()

   METHOD showMedioPago()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS MetodosPagoView

   ::Super:New( oController )

   ::hIcono := {  "Dinero"                => "gc_money2_16",;
                  "Tarjeta de credito"    => "gc_credit_cards_16",;
                  "Bolsa de dinero"       => "gc_moneybag_euro_16",;
                  "Porcentaje"            => "gc_symbol_percent_16",;
                  "Cesta de compra"       => "gc_shopping_cart_16" }

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS MetodosPagoView

   local oSayCamposExtra

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "METODOS_PAGO" ;
      TITLE       ::LblTitle() + "forma de pago"

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

   REDEFINE RADIO ::oCobrado ;
      VAR         ::oController:getModel():hBuffer[ "cobrado" ] ;
      ID          120, 121;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ON CHANGE   ( ::showMedioPago() ) ;
      OF          ::oDialog ;

   ::oController:getMediosPagoController():getSelector():Bind( bSETGET( ::oController:getModel():hBuffer[ "codigo_medio_pago" ] ) )
   ::oController:getMediosPagoController():getSelector():Build( { "idGet" => 130, "idText" => 131, "idLink" => 132, "oDialog" => ::oDialog } )
  
   REDEFINE GET   ::oController:getModel():hBuffer[ "numero_plazos" ] ;
      ID          140 ;
      SPINNER  ;
      MIN         0;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:getModel():hBuffer[ "primer_plazo" ] ;
      ID          150 ;
      SPINNER  ;
      MIN         0;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:getModel():hBuffer[ "entre_plazo" ] ;
      ID          160 ;
      SPINNER  ;
      MIN         0;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:getModel():hBuffer[ "ultimo_plazo" ] ;
      ID          170 ;
      SPINNER  ;
      MIN         0;
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

METHOD showMedioPago() CLASS MetodosPagoView

   if ::oController:getModel():isCobrado()
      ::oController:getMediosPagoController():getSelector():hide()
   else
      ::oController:getMediosPagoController():getSelector():show() 
   end if
 
RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD startActivate() CLASS MetodosPagoView

   ::oController:getMediosPagoController():oGetSelector():Start()
   
   ::addLinksToExplorerBar()

   ::showMedioPago()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD addLinksToExplorerBar() CLASS MetodosPagoView

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

CLASS MetodosPagoValidator FROM SQLBaseValidator

   METHOD getValidators()

END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS MetodosPagoValidator

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

CLASS SQLMetodosPagoModel FROM SQLCompanyModel

   DATA cTableName               INIT "metodos_pago"

   DATA cConstraints             INIT "PRIMARY KEY ( codigo, deleted_at )"

   METHOD getColumns()

   METHOD isCobrado()            INLINE ( ::getBuffer( 'cobrado' ) == 2 )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLMetodosPagoModel

   hset( ::hColumns, "id",                   {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"              ,;                          
                                                "default"   => {|| 0 } }                                    )

   hset( ::hColumns, "uuid",                 {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"              ,;                                  
                                                "default"   => {|| win_uuidcreatestring() } }               )

   hset( ::hColumns, "codigo",               {  "create"    => "VARCHAR( 20 )"                              ,;
                                                "default"   => {|| space( 20 ) } }                          )

   hset( ::hColumns, "nombre",               {  "create"    => "VARCHAR( 200 )"                             ,;
                                                "default"   => {|| space( 200 ) } }                         )

   hset( ::hColumns, "cobrado",              {  "create"    => "INTEGER( 1 )"                               ,;
                                                "default"   => {|| ( 0 ) } }                                )

   hset( ::hColumns, "codigo_medio_pago",    {  "create"    => "VARCHAR( 20 )"                              ,;
                                                "default"   => {|| space( 20 ) } }                          )

   hset( ::hColumns, "numero_plazos",        {  "create"    => "INTEGER( 5 )"                               ,;
                                                "default"   => {|| ( 0 ) } }                                )

   hset( ::hColumns, "primer_plazo",         {  "create"    => "INTEGER( 5 )"                               ,;
                                                "default"   => {|| ( 0 ) } }                                )

   hset( ::hColumns, "entre_plazo",          {  "create"    => "INTEGER( 5 )"                               ,;
                                                "default"   => {|| ( 0 ) } }                                )

   hset( ::hColumns, "ultimo_plazo",         {  "create"    => "INTEGER( 5 )"                               ,;
                                                "default"   => {|| ( 0 ) } }                                )

   ::getTimeStampColumns()

   ::getDeletedStampColumn()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS MetodosPagoRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLMetodosPagoModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
