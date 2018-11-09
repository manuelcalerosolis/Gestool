#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS RecibosController FROM SQLNavigatorController

   METHOD New() CONSTRUCTOR

   METHOD End()

   //Construcciones tardias----------------------------------------------------

   METHOD getBrowseView()        INLINE( if( empty( ::oBrowseView ), ::oBrowseView := RecibosBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()        INLINE( if( empty( ::oDialogView ), ::oDialogView := RecibosView():New( self ), ), ::oDialogView )

   METHOD getRepository()        INLINE( if(empty( ::oRepository ), ::oRepository := RecibosRepository():New( self ), ), ::oRepository )

   METHOD getValidator()         INLINE( if( empty( ::oValidator ), ::oValidator := RecibosValidator():New( self  ), ), ::oValidator ) 
   
   METHOD getModel()             INLINE( if( empty( ::oModel ), ::oModel := SQLRecibosModel():New( self ), ), ::oModel ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS RecibosController

   ::Super:New( oController )

   ::cTitle                      := "Recibos"

   ::cName                       := "recibos"

   ::hImage                      := {  "16" => "gc_briefcase2_user_16",;
                                       "32" => "gc_briefcase2_user_32",;
                                       "48" => "gc_briefcase2_user_48" }

   ::nLevel                         := Auth():Level( ::cName )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS RecibosController

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
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS RecibosBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

END CLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS RecibosBrowseView

   ::getColumnIdAndUuid()


   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'expedicion'
      :cHeader             := 'Expedición'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'expedicion' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'vencimiento'
      :cHeader             := 'Vencimiento'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'vencimiento' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'concepto'
      :cHeader             := 'Concepto'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'concepto' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'importe'
      :cHeader             := 'importe'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'importe' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   ::getColumnDeletedAt()

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS RecibosView FROM SQLBaseView

   DATA oFechaCobro
  
   METHOD Activate()

   METHOD startActivate()

   METHOD getFechaCobro()

   METHOD addLinksToExplorerBar()

END CLASS

//---------------------------------------------------------------------------//

METHOD getFechaCobro() CLASS RecibosView

   if ::oController:getModel():hBuffer[ "cobrado" ] 
      ::oController:getModel():hBuffer[ "fecha_cobro" ] := hb_date()
   else
      ::oController:getModel():hBuffer[ "fecha_cobro" ] := ctod( "" )
   end if

   ::oFechaCobro:Refresh()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS RecibosView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "CONTAINER_MEDIUM_EXTENDED" ;
      TITLE       ::LblTitle() + "recibo"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog ;

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        oFontBold() ;
      PROMPT      "Recibos";
      OF          ::oDialog ;

   REDEFINE FOLDER ::oFolder ;
      ID          500 ;
      OF          ::oDialog ;
      PROMPT      "&General";
      DIALOGS     "RECIBO_GENERAL";

      ::redefineExplorerBar()

   REDEFINE GET   ::oController:getModel():hBuffer[ "expedicion" ] ;
      ID          100 ;
      SPINNER ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   ::oController:getModel():hBuffer[ "vencimiento" ] ;
      ID          110 ;
      SPINNER ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE SAYCHECKBOX ::oController:getModel():hBuffer[ "no_incluir_en_arqueo" ] ;
      ID          120 ;
      IDSAY       122 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   ::oController:getModel():hBuffer[ "sesion" ] ;
      ID          130 ;
      WHEN         ( .f. );
      OF          ::oFolder:aDialogs[1]

  REDEFINE GET   ::oController:getModel():hBuffer[ "importe" ] ;
      ID          140 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      PICTURE     "@E 999999999999.999";
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   ::oController:getModel():hBuffer[ "cobro" ] ;
      ID          150 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      PICTURE     "@E 999999999999.999";
      OF          ::oFolder:aDialogs[1]

  REDEFINE GET   ::oController:getModel():hBuffer[ "gastos" ] ;
      ID          160 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      PICTURE     "@E 999999999999.999";
      OF          ::oFolder:aDialogs[1]

   REDEFINE SAYCHECKBOX ::oController:getModel():hBuffer[ "cobrado" ] ;
      ID          170 ;
      IDSAY       172 ;
      ON CHANGE      (::getFechaCobro() );
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   ::oFechacobro ; 
      VAR         ::oController:getModel():hBuffer[ "fecha_cobro" ];
      ID          180 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   // codigo caja-------------------------------------------------------------------------------------------------------//

   ::oController:getCajasController():getSelector():Bind( bSETGET( ::oController:getModel():hBuffer[ "codigo_caja" ] ) )
   ::oController:getCajasController():getSelector():Build( { "idGet" => 190, "idText" => 191, "idLink" => 192, "oDialog" => ::oFolder:aDialogs[1] } )

   // cliente------------------------------------------------------------------------------------------------------------//

   ::oController:getClientesController():getSelector():Bind( bSETGET( ::oController:getModel():hBuffer[ "cliente" ] ) )
   ::oController:getClientesController():getSelector():Build( { "idGet" => 200, "idText" => 201, "idLink" => 202, "oDialog" => ::oFolder:aDialogs[1] } )

   // Forma de pago-----------------------------------------------------------------------------------------------------//

   ::oController:getFormasPagosController():getSelector():Bind( bSETGET( ::oController:getModel():hBuffer[ "forma_pago" ] ) )
   ::oController:getFormasPagosController():getSelector():Build( { "idGet" => 210, "idText" => 211, "idLink" => 212, "oDialog" => ::oFolder:aDialogs[1] } )

   //Agentes---------------------------------------------------------------------------------------------------------//

   ::oController:getAgentesController():getSelector():Bind( bSETGET( ::oController:getModel():hBuffer[ "agente" ] ) )
   ::oController:getAgentesController():getSelector():Build( { "idGet" => 220, "idText" => 221, "idLink" => 222, "oDialog" => ::oFolder:aDialogs[1] } )

   REDEFINE GET   ::oController:getModel():hBuffer[ "concepto" ] ;
      ID          230 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   ::oController:getModel():hBuffer[ "pagado_por" ] ;
      ID          240 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   if ::oController:isNotZoomMode() 
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5 .and. validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }
   end if

   ::oDialog:bStart  := {|| ::StartActivate() }

   ACTIVATE DIALOG ::oDialog CENTER

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD StartActivate() CLASS RecibosView

   ::addLinksToExplorerBar()

   ::oController:getCajasController():getSelector():Start()

   ::oController:getClientesController():getSelector():Start()

   ::oController:getFormasPagosController():getSelector():Start()

   ::oController:getAgentesController():getSelector():Start()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD addLinksToExplorerBar() CLASS RecibosView

   local oPanel            

   oPanel            := ::oExplorerBar:AddPanel( "Datos relacionados", nil, 1 ) 

   if ::oController:isZoomMode()
      RETURN ( nil )
   end if

   oPanel:AddLink(   "Incidencias...",;
                        {||::oController:getIncidenciasController():activateDialogView( ::oController:getUuid() ) },;
                           ::oController:getIncidenciasController():getImage( "16" ) )
   
   oPanel:AddLink(   "Documentos...",;
                        {||::oController:getDocumentosController():activateDialogView() },;
                           ::oController:getDocumentosController():getImage( "16" ) )

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS RecibosValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS RecibosValidator

   ::hValidators  := {  "codigo" =>    {  "required"           => "El código es un dato requerido" ,;
                                          "unique"             => "EL código introducido ya existe" },;
                        "nombre" =>    {  "required"           => "El nombre es un dato requerido"    ,;
                                          "unique"             => "El nombre introducido ya existe"   }  }
RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLRecibosModel FROM SQLCompanyModel

   DATA cTableName               INIT "factura_recibos"

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLRecibosModel

   hset( ::hColumns, "id",                         {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"              ,;                          
                                                      "default"   => {|| 0 } }                                    )

   hset( ::hColumns, "uuid",                       {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"                ,;                                  
                                                      "default"   => {|| win_uuidcreatestring() } }               )

   hset( ::hColumns, "parent_uuid",                {  "create"    => "VARCHAR( 40 )"                              ,;
                                                      "default"   => {|| ::getControllerParentUuid() } }           )

   hset( ::hColumns, "expedicion",                 {  "create"    => "DATE"                                       ,;
                                                      "default"   => {|| hb_date() } }                            )

   hset( ::hColumns, "vencimiento",                {  "create"   => "DATE"                                        ,;
                                                      "default"   => {|| hb_date() } }                            )

   hset( ::hColumns, "importe",                    {  "create"    => "FLOAT( 16,6 )"                              ,;
                                                      "default"   => {||  0  } }                                  )

   hset( ::hColumns, "concepto",                   {  "create"    => "VARCHAR( 200 )"                              ,;
                                                      "default"   => {|| space( 200 ) } }                          )

   ::getDeletedStampColumn()


RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

/*METHOD insertRecibosSentence()

   local cSql

   TEXT INTO cSql
   INSERT [LOW_PRIORITY | DELAYED | HIGH_PRIORITY] [IGNORE]
      [INTO] tbl_name [(col_name,...)]
      VALUES (\,...),(...),...
      [ ON DUPLICATE KEY UPDATE col_name=expression, ... ]

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), quoted( cCodigoMedioPago ) )

RETURN ( cSql )*/

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS RecibosRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLRecibosModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//