#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS RecibosController FROM SQLNavigatorController

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

   ::oRepository                    := RecibosRepository():New( self )

   ::oGetSelector                   := GetSelector():New( self )   

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS RecibosController

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

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

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS RecibosBrowseView
/*
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
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with
*/
RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS RecibosView FROM SQLBaseView
  
   METHOD Activate()

END CLASS

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
      OF          ::oDialog ;

   REDEFINE FOLDER ::oFolder ;
      ID          500 ;
      OF          ::oDialog ;
      PROMPT      "&General";
      DIALOGS     "RECIBO_GENERAL";

      ::redefineExplorerBar()

   REDEFINE GET   ::oController:oModel:hBuffer[ "expedicion" ] ;
      ID          100 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   ::oController:oModel:hBuffer[ "vencimiento" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE SAYCHECKBOX ::oController:oModel:hBuffer[ "no_incluir_en_arqueo" ] ;
      ID          120 ;
      IDSAY       122 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   ::oController:oModel:hBuffer[ "sesion" ] ;
      ID          130 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   ::oController:oModel:hBuffer[ "importe" ] ;
      ID          140 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   ::oController:oModel:hBuffer[ "cobro" ] ;
      ID          150 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   ::oController:oModel:hBuffer[ "gastos" ] ;
      ID          160 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE SAYCHECKBOX ::oController:oModel:hBuffer[ "cobrado" ] ;
      ID          170 ;
      IDSAY       172 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]
/*
   REDEFINE COMBOBOX ::oBPS ;
      VAR         ::oController:oModel:hBuffer[ "bits_segundo" ] ;
      ID          130 ;
      ITEMS       ::aBPS;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE COMBOBOX ::oParada ;
      VAR         ::oController:oModel:hBuffer[ "bits_parada" ] ;
      ID          140 ;
      ITEMS       ::aParada;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE COMBOBOX ::oDatos ;
      VAR         ::oController:oModel:hBuffer[ "bits_datos" ] ;
      ID          150 ;
      ITEMS       ::aDatos;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE COMBOBOX ::oParidad ;
      VAR         ::oController:oModel:hBuffer[ "paridad" ] ;
      ID          160 ;
      ITEMS       ::aParidad;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oInicializacion ; 
      VAR         ::oController:oModel:hBuffer[ "inicializacion" ] ;
      ID          170 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "retardo" ] ;
      ID          180 ;
      SPINNER ;
      MIN  0;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "entubamiento" ] ;
      ID          190 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE SAYCHECKBOX ::oController:oModel:hBuffer[ "abrir_puerto" ] ;
      ID          200 ;
      IDSAY       202 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

//Botones text y defecto------------------------------------------------------//

   REDEFINE BUTTON ;
      ID          210 ;
      OF          ::oDialog ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ACTION      ( msgalert("test") )

   REDEFINE BUTTON ;
      ID          220 ;
      OF          ::oDialog ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ACTION      ( ::SetDefault() )


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


   */ACTIVATE DIALOG ::oDialog CENTER

   

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
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

CLASS SQLRecibosModel FROM SQLBaseModel

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
                                                      "default"   => {  0  } }                                    )

   hset( ::hColumns, "cobro",                      {  "create"    => "FLOAT( 15,3 )"                              ,;
                                                      "default"   => {  0  } }                                    )

   hset( ::hColumns, "gastos",                     {  "create"    => "FLOAT( 15,3 )"                              ,;
                                                      "default"   => {  0  } }                                    )

   hset( ::hColumns, "cobrado",                    {  "create"    => "BIT"                                        ,;
                                                      "default"   => {|| .f. } }                                  )

   hset( ::hColumns, "fecha_cobro",                {  "create"    => "DATE"                                       ,;
                                                      "default"   => {  0  } }                                    )

   hset( ::hColumns, "codigo_caja",                {  "create"    => "VARCHAR( 20 )"                              ,;
                                                      "default"   => {|| space( 20 ) } }                          )

   hset( ::hColumns, "cliente",                    {  "create"    => "VARCHAR( 20 )"                               ,;
                                                      "default"   => {|| space( 20 ) } }                           )

   hset( ::hColumns, "forma_pago",                 {  "create"    => "VARCHAR( 20 )"                               ,;
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