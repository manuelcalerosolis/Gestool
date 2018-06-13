#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS RecibosController FROM SQLNavigatorController

   DATA oCajasController

   DATA oClientesController

   DATA oFormasPagosController

   DATA oAgentesController

   DATA oIncidenciasController

   DATA oDocumentosController

   METHOD New()

   METHOD End()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController ) CLASS RecibosController

   ::Super:New( oSenderController )

   ::cTitle                      := "Recibos"

   ::cName                       := "recibos"

   ::hImage                      := {  "16" => "gc_briefcase2_user_16",;
                                       "32" => "gc_briefcase2_user_32",;
                                       "48" => "gc_briefcase2_user_48" }

   ::nLevel                         := Auth():Level( ::cName )

   ::oModel                         := SQLRecibosModel():New( self )

   ::oBrowseView                    := RecibosBrowseView():New( self )

   ::oDialogView                    := RecibosView():New( self )

   ::oValidator                     := RecibosValidator():New( self, ::oDialogView )

   ::oCajasController               := CajasController():new( self )

   ::oClientesController            := ClientesController():new( self )

   ::oFormasPagosController           := FormasPagosController():new( self )

   ::oAgentesController             := AgentesController():new( self )

   ::oIncidenciasController         := IncidenciasController():new( self )

   ::oDocumentosController          := DocumentosController():new( self )

   ::oRepository                    := RecibosRepository():New( self )

   ::oGetSelector                   := GetSelector():New( self )   

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS RecibosController

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oCajasController:End()

   ::oClientesController:End()

   ::oFormasPagosController:End()

   ::oAgentesController:End()

   ::oIncidenciasController:End()

   ::oDocumentosController:End()

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

CLASS RecibosBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

END CLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS RecibosBrowseView

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
      :cSortOrder          := 'cobrado'
      :cHeader             := ''
      :nWidth              := 50
      :nHeadBmpNo          := 3
      :bEditValue          := {|| ::getRowSet():fieldGet( 'cobrado' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :SetCheck( { "Sel16", "Nil16" } )
      :AddResource( "GC_MONEY2_16" )
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'sesion'
      :cHeader             := 'Sesión'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'sesion' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

     with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'cliente'
      :cHeader             := 'Nombre Cliente'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre_cliente' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

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
      :cSortOrder          := 'fecha_cobro'
      :cHeader             := 'Fecha de cobro'
      :nWidth              := 120
      :bEditValue          := {|| ::getRowSet():fieldGet( 'fecha_cobro' ) }
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

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'cobro'
      :cHeader             := 'Cobrado'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'cobro' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'gastos'
      :cHeader             := 'Gastos'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'gastos' ) }
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

CLASS RecibosView FROM SQLBaseView

   DATA oFechacobro
  
   METHOD Activate()

   METHOD StartActivate()

   METHOD getFechaCobro()

   METHOD addLinksToExplorerBar()

END CLASS

//---------------------------------------------------------------------------//
METHOD getFechaCobro() CLASS RecibosView

   if ::oController:oModel:hBuffer[ "cobrado" ] 
      ::oController:oModel:hBuffer[ "fecha_cobro" ] := hb_date()
   else
      ::oController:oModel:hBuffer[ "fecha_cobro" ] := ctod( "" )
   end if

   ::oFechaCobro:Refresh()

RETURN ( self )

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
      FONT        getBoldFont() ;
      PROMPT      "Recibos";
      OF          ::oDialog ;

   REDEFINE FOLDER ::oFolder ;
      ID          500 ;
      OF          ::oDialog ;
      PROMPT      "&General";
      DIALOGS     "RECIBO_GENERAL";

      ::redefineExplorerBar()

   REDEFINE GET   ::oController:oModel:hBuffer[ "expedicion" ] ;
      ID          100 ;
      SPINNER ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   ::oController:oModel:hBuffer[ "vencimiento" ] ;
      ID          110 ;
      SPINNER ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE SAYCHECKBOX ::oController:oModel:hBuffer[ "no_incluir_en_arqueo" ] ;
      ID          120 ;
      IDSAY       122 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   ::oController:oModel:hBuffer[ "sesion" ] ;
      ID          130 ;
      WHEN         ( .f. );
      OF          ::oFolder:aDialogs[1]

  REDEFINE GET   ::oController:oModel:hBuffer[ "importe" ] ;
      ID          140 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      PICTURE     "@E 999999999999.999";
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   ::oController:oModel:hBuffer[ "cobro" ] ;
      ID          150 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      PICTURE     "@E 999999999999.999";
      OF          ::oFolder:aDialogs[1]

  REDEFINE GET   ::oController:oModel:hBuffer[ "gastos" ] ;
      ID          160 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      PICTURE     "@E 999999999999.999";
      OF          ::oFolder:aDialogs[1]

   REDEFINE SAYCHECKBOX ::oController:oModel:hBuffer[ "cobrado" ] ;
      ID          170 ;
      IDSAY       172 ;
      ON CHANGE      (::getFechaCobro() );
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   ::oFechacobro ; 
      VAR         ::oController:oModel:hBuffer[ "fecha_cobro" ];
      ID          180 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   // codigo caja-------------------------------------------------------------------------------------------------------//

   ::oController:oCajasController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "codigo_caja" ] ) )
   
   ::oController:oCajasController:oGetSelector:setEvent( 'validated', {|| ::CajasControllerValidated() } )

   ::oController:oCajasController:oGetSelector:Activate( 190, 192, ::oFolder:aDialogs[1] )

   // cliente------------------------------------------------------------------------------------------------------------//

   ::oController:oClientesController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "cliente" ] ) )

   ::oController:oClientesController:oGetSelector:Build( { "idGet" => 200, "idText" => 202, "oDialog" => ::oFolder:aDialogs[1] } )

   // Forma de pago-----------------------------------------------------------------------------------------------------//

   ::oController:oFormasPagosController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "forma_pago" ] ) )
   
   ::oController:oFormasPagosController:oGetSelector:setEvent( 'validated', {|| ::FormasPagosControllerValidated() } )

   ::oController:oFormasPagosController:oGetSelector:Activate( 210, 212, ::oFolder:aDialogs[1] )

//Agentes---------------------------------------------------------------------------------------------------------//

   ::oController:oAgentesController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "agente" ] ) )
   
   ::oController:oAgentesController:oGetSelector:setEvent( 'validated', {|| ::AgentesControllerValidated() } )

   ::oController:oAgentesController:oGetSelector:Activate( 220, 222, ::oFolder:aDialogs[1] )

//-----------------------------------------------------------------------------------------------------------------//

   REDEFINE GET   ::oController:oModel:hBuffer[ "concepto" ] ;
      ID          230 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   ::oController:oModel:hBuffer[ "pagado_por" ] ;
      ID          240 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

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

::oDialog:bStart  := {|| ::StartActivate() }

ACTIVATE DIALOG ::oDialog CENTER

   

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD StartActivate() CLASS RecibosView

::addLinksToExplorerBar()

::oController:oCajasController:oGetSelector:Start()

::oController:oClientesController:oGetSelector:Start()

::oController:oFormasPagosController:oGetSelector:Start()

::oController:oAgentesController:oGetSelector:Start()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD addLinksToExplorerBar() CLASS RecibosView

   local oPanel            

   oPanel            := ::oExplorerBar:AddPanel( "Datos relacionados", nil, 1 ) 

   if ::oController:isZoomMode()
      RETURN ( self )
   end if

   oPanel:AddLink(   "Incidencias...",;
                     {|| ::oController:oIncidenciasController:activateDialogView( ::oController:getUuid() ) },;
                     ::oController:oIncidenciasController:getImage( "16" ) )
   
   oPanel:AddLink(   "Documentos...",;
                     {|| ::oController:oDocumentosController:activateDialogView() },;
                     ::oController:oDocumentosController:getImage( "16" ) )

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS RecibosValidator FROM SQLBaseValidator

   METHOD getValidators()

 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS RecibosValidator

   ::hValidators  := {  "codigo" =>                {  "required"           => "El código es un dato requerido" ,;
                                                      "unique"             => "EL código introducido ya existe" },;
                        "nombre" =>                {  "required"           => "El nombre es un dato requerido"    ,;
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

   METHOD getGeneralSelect()

   METHOD getColumns()


END CLASS

//---------------------------------------------------------------------------//

METHOD getGeneralSelect() CLASS SQLRecibosModel

   local cSelect  := "SELECT factura_recibos.id,"                                                                                         + " " + ;
                        "factura_recibos.uuid,"                                                                                           + " " + ;
                        "factura_recibos.parent_uuid,"                                                                                    + " " + ;
                        "factura_recibos.expedicion,"                                                                                     + " " + ;
                        "factura_recibos.vencimiento,"                                                                                    + " " + ;
                        "factura_recibos.no_incluir_en_arqueo,"                                                                           + " " + ;
                        "factura_recibos.sesion,"                                                                                         + " " + ;
                        "factura_recibos.importe,"                                                                                        + " " + ;
                        "factura_recibos.cobro,"                                                                                          + " " + ;
                        "factura_recibos.gastos,"                                                                                         + " " + ;
                        "factura_recibos.cobrado,"                                                                                        + " " + ;
                        "factura_recibos.fecha_cobro,"                                                                                    + " " + ;
                        "factura_recibos.codigo_caja,"                                                                                    + " " + ;
                        "factura_recibos.cliente,"                                                                                        + " " + ;
                        "factura_recibos.agente,"                                                                                         + " " + ;
                        "factura_recibos.concepto,"                                                                                       + " " + ;
                        "factura_recibos.pagado_por,"                                                                                     + " " + ;
                        "clientes.nombre AS nombre_cliente "                                                                              + " " + ;  
                     "FROM " + ::getTableName() + " AS factura_recibos"                                                                   + " " + ;
                        "INNER JOIN " + SQLClientesModel():getTableName() + " AS clientes ON factura_recibos.cliente = clientes.id"  

RETURN ( cSelect )

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLRecibosModel

   hset( ::hColumns, "id",                         {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"              ,;                          
                                                      "default"   => {|| 0 } }                                    )

   hset( ::hColumns, "uuid",                       {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"                ,;                                  
                                                      "default"   => {|| win_uuidcreatestring() } }               )

   hset( ::hColumns, "parent_uuid",                {  "create"    => "VARCHAR( 40 )"                              ,;
                                                      "default"   => {||::getSenderControllerParentUuid() } }     )

   hset( ::hColumns, "expedicion",                 {  "create"    => "DATE"                                       ,;
                                                      "default"   => {|| hb_date() } }                            )

   hset( ::hColumns, "vencimiento",                {  "create"   => "DATE"                                        ,;
                                                      "default"   => {|| hb_date() } }                            )

   hset( ::hColumns, "no_incluir_en_arqueo",       {  "create"    => "BIT"                                        ,;
                                                      "default"   => {|| .f. } }                                  )

   hset( ::hColumns, "sesion",                     {  "create"    => "VARCHAR( 200 )"                             ,;
                                                      "default"   => {||  space( 200 )  } }                       )

   hset( ::hColumns, "importe",                    {  "create"    => "FLOAT( 15,3 )"                              ,;
                                                      "default"   => {||  0.000  } }                               )

   hset( ::hColumns, "cobro",                      {  "create"    => "FLOAT( 15,3 )"                              ,;
                                                      "default"   => {||  0.000  } }                               )

   hset( ::hColumns, "gastos",                     {  "create"    => "FLOAT( 15,3 )"                              ,;
                                                      "default"   => {||  0.000  } }                               )

   hset( ::hColumns, "cobrado",                    {  "create"    => "TINYINT( 1 )"                                ,;
                                                      "default"   => {|| 0 } }                                  )

   hset( ::hColumns, "fecha_cobro",                {  "create"    => "DATE"                                       ,;
                                                      "default"   => {|| ctod( "" ) } }                            )

   hset( ::hColumns, "codigo_caja",                {  "create"    => "VARCHAR( 20 )"                              ,;
                                                      "default"   => {|| space( 20 ) } }                          )

   hset( ::hColumns, "cliente",                    {  "create"    => "VARCHAR( 20 )"                               ,;
                                                      "default"   => {|| space( 20 ) } }                           )

   hset( ::hColumns, "forma_pago",                 {  "create"    => "VARCHAR( 40 )"                               ,;
                                                      "default"   => {|| space( 40 ) } }                           )

   hset( ::hColumns, "agente",                     {  "create"    => "VARCHAR( 20 )"                               ,;
                                                      "default"   => {|| space( 20 ) } }                           )

   hset( ::hColumns, "concepto",                   {  "create"    => "VARCHAR( 200 )"                              ,;
                                                      "default"   => {|| space( 200 ) } }                          )

   hset( ::hColumns, "pagado_por",                 {  "create"    => "VARCHAR( 200 )"                              ,;
                                                      "default"   => {|| space( 200 ) } }                          )



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

CLASS RecibosRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLRecibosModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//