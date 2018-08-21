#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS EntradaSalidaController FROM SQLNavigatorController

   DATA oCamposExtraValoresController

   DATA oDocumentosController

   DATA oCajasController

   METHOD New()

   METHOD End()

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS EntradaSalidaController

   ::Super:New()

   ::cTitle                      := "Entradas y salidas"

   ::cName                       := "entradas_salidas"

   ::hImage                      := {  "16" => "gc_cash_register_refresh_16",;
                                       "32" => "gc_cash_register_refresh_32",;
                                       "48" => "gc_cash_register_refresh_48" }

   ::nLevel                         := Auth():Level( ::cName )

   ::oModel                         := SQLEntradaSalidaModel():New( self )

   ::oBrowseView                    := EntradaSalidaBrowseView():New( self )

   ::oDialogView                    := EntradaSalidaView():New( self )

   ::oCamposExtraValoresController  := CamposExtraValoresController():New( self, ::oModel:cTableName )

   ::oDocumentosController          := DocumentosController():New( self, ::oModel:cTableName )

   ::oValidator                     := EntradaSalidaValidator():New( self, ::oDialogView )

   ::oCajasController               := CajasController():New( self )

   ::oRepository                    := EntradaSalidaRepository():New( self )

   ::oGetSelector                   := GetSelector():New( self )   

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS EntradaSalidaController

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oCamposExtraValoresController:End()

   ::oDocumentosController:End()

   ::oCajasController:End()

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

CLASS EntradaSalidaBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS EntradaSalidaBrowseView

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
      :cSortOrder          := 'tipo'
      :cHeader             := 'Tipo'
      :nWidth              := 50
      :bEditValue          := {|| ::getRowSet():fieldGet( 'tipo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'sesion'
      :cHeader             := 'Sesión'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'sesion' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'codigo_caja'
      :cHeader             := 'Código Caja'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'codigo_caja' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

  with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'nombre_caja'
      :cHeader             := 'Nombre caja'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre_caja' ) }
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

CLASS EntradaSalidaView FROM SQLBaseView

   DATA oSayCamposExtra

   DATA oTipo

   DATA aTipo INIT { "Entrada", "Salida" }

   METHOD StartActivate()
  
   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS EntradaSalidaView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "ENTRADA_SALIDA" ;
      TITLE       ::LblTitle() + "Entrada o salida de caja"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog ;

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        getBoldFont() ;
      OF          ::oDialog ;

   REDEFINE COMBOBOX ::oTipo ;
      VAR         ::oController:oModel:hBuffer[ "tipo" ] ;
      ID          100 ;
      ITEMS       ::aTipo;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "importe" ] ;
      ID          110 ;
      VALID       ( ::oController:validate( "importe" ) ) ;
      SPINNER ;
      PICTURE     "@E 9999999.999" ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          120 ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "sesion" ] ;
      ID          130 ;
      WHEN        ( .f. ) ;
      OF          ::oDialog ;
   // codigo caja-------------------------------------------------------------------------------------------------------//

   ::oController:oCajasController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "caja_codigo" ] ) )
   
   /*::oController:oCajasController:oGetSelector:setEvent( 'validated', {|| ::CajasControllerValidated() } )*/

   ::oController:oCajasController:oGetSelector:Build( { "idGet" => 140, "idText" => 141, "idSay" => 142, "oDialog" => ::oDialog } )

   // cliente------------------------------------------------------------------------------------------------------------//
  
  REDEFINE GET   ::oController:oModel:hBuffer[ "fecha_hora" ] ;
      ID          150 ;
      SPINNER ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

      ::redefineExplorerBar( 160 )

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

   ::oDialog:bStart  := {|| ::StartActivate() }

   ACTIVATE DIALOG ::oDialog CENTER
   

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD StartActivate() CLASS EntradaSalidaView

   local oPanel                  := ::oExplorerBar:AddPanel( "Datos relacionados", nil, 1 ) 

   oPanel:AddLink(   "Campos extra...",;
                     {|| ::oController:oCamposExtraValoresController:Edit( ::oController:getUuid() ) },;
                     ::oController:oCamposExtraValoresController:getImage( "16" ) )

   oPanel:AddLink(   "Documentos...",;
                     {|| ::oController:oDocumentosController:activateDialogView() },;
                     ::oController:oDocumentosController:getImage( "16" ) )

   ::oController:oCajasController:oGetSelector:Start()

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS EntradaSalidaValidator FROM SQLBaseValidator

   METHOD getValidators()

 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS EntradaSalidaValidator

   ::hValidators  := {  "nombre" =>                {  "required"           => "El nombre es un dato requerido"    ,;
                                                      "unique"             => "El nombre introducido ya existe"   },;
                        "tipos"  =>                {  "required"           => "El tipo es un datos requerido"     },;
                        "Importe"  =>              {  "required"           => "El importe es un datos requerido"  } }
RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLEntradaSalidaModel FROM SQLCompanyModel

   DATA cTableName               INIT "cajas_entradas_salidas"

   METHOD getColumns()

   /*METHOD getCajaUuidAttribute( uValue ) ; 
                                 INLINE ( if( empty( uValue ), space( 40 ), ::oController:oCajasController:oModel():getCodigoWhereUuid( uValue ) ) )

   METHOD setCajaUuidAttribute( uValue ) ;
                                 INLINE ( if( empty( uValue ), "", ::oController:oCajasController:oModel():getUuidWhereCodigo( uValue ) ) )*/

METHOD getGeneralSelect()

END CLASS

//---------------------------------------------------------------------------//

METHOD getGeneralSelect() CLASS SQLEntradaSalidaModel

   local cSelect  := "SELECT cajas_entradas_salidas.id,"                                                               + " " + ;
                        "cajas_entradas_salidas.uuid,"                                                                 + " " + ;
                        "cajas_entradas_salidas.sesion,"                                                               + " " + ;
                        "cajas_entradas_salidas.nombre,"                                                               + " " + ;
                        "cajas_entradas_salidas.fecha_hora,"                                                           + " " + ; 
                        "cajas_entradas_salidas.caja_codigo,"                                                          + " " + ; 
                        "cajas_entradas_salidas.nombre,"                                                               + " " + ;
                        "cajas_entradas_salidas.tipo,"                                                                 + " " + ;
                        "cajas_entradas_salidas.importe,"                                                              + " " + ;   
                        "cajas_entradas_salidas.delegacion_uuid,"                                                      + " " + ;
                        "cajas.codigo AS codigo_caja,"                                                               + " " + ;
                        "cajas.nombre AS nombre_caja"                                                                + " " + ;  
                     "FROM " + ::getTableName() +" AS cajas_entradas_salidas"                                          + " " + ;
                        "INNER JOIN " + SQLCajasModel():getTableName() + " AS cajas ON cajas_entradas_salidas.caja_codigo = cajas.codigo"  + " "

RETURN ( cSelect )

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLEntradaSalidaModel

   hset( ::hColumns, "id",                {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;                          
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",              {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"             ,;                                  
                                             "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "sesion",            {  "create"    => "VARCHAR( 200 )"                          ,;
                                             "default"   => {|| space( 200 ) } }                       )

   hset( ::hColumns, "fecha_hora",        {  "create"    => "TIMESTAMP"                               ,;
                                             "default"   => {|| hb_datetime() } }                      )

   hset( ::hColumns, "caja_codigo",       {  "create"   => "VARCHAR( 20 )"                            ,;
                                             "default"   => {|| space( 20 ) } }                        )

   hset( ::hColumns, "nombre",            {  "create"    => "VARCHAR( 200 )"                          ,;
                                             "default"   => {|| space( 200 ) } }                       )

   hset( ::hColumns, "tipo",              {  "create"     => "ENUM( 'Entrada', 'Salida' )"             ,;
                                             "default"    => {|| 'Entrada' }  }                        )

   hset( ::hColumns, "importe",           {  "create"     => "FLOAT( 10, 3 )"                          ,;
                                             "default"    => {|| 0  } }                                )

   hset( ::hColumns, "delegacion_uuid",   {  "create"   => "VARCHAR( 40 )"                            ,;
                                             "default"   => {|| space( 40 ) } }                        )

   ::getTimeStampColumns()

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

CLASS EntradaSalidaRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLEntradaSalidaModel():getTableName() ) 

   METHOD getNombreWhereUuid( Uuid )      INLINE ( ::getColumnWhereUuid( Uuid, "nombre" ) )

   METHOD getUuidWhereNombre( cNombre )   INLINE ( ::getUuidWhereColumn( cNombre, "nombre", "" ) )

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//