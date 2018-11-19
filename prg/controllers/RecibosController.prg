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
      :cEditPicture        := "999999999999.99"
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
  
   METHOD Activate()

   METHOD startActivate()

   METHOD addLinksToExplorerBar()

   METHOD defaultTitle()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS RecibosView

    DEFINE DIALOG  ::oDialog ;
      RESOURCE    "CONTAINER_MEDIUM_EXTENDED" ;
      TITLE       ::LblTitle() + "recibo"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getimage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      PROMPT      "Recibo" ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog

   ::redefineExplorerBar()

   REDEFINE FOLDER ::oFolder ;
      ID          500 ;
      OF          ::oDialog ;
      PROMPT      "&General" ;
      DIALOGS     "RECIBOS_SQL" 

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

  REDEFINE GET   ::oController:getModel():hBuffer[ "importe" ] ;
      ID          120 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      PICTURE     "@E 999999999999.99";
      OF          ::oFolder:aDialogs[1]


   REDEFINE GET   ::oController:getModel():hBuffer[ "concepto" ] ;
      ID          130 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]


   // Botones------------------------------------------------------------------

   ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, ::oDialog:end( IDOK ), ) }
   
   if ::oController:isNotZoomMode() 
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5 .and. validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }
   end if

   ::oDialog:bStart  := {|| ::startActivate() }

   ACTIVATE DIALOG ::oDialog CENTER

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD StartActivate() CLASS RecibosView

   ::addLinksToExplorerBar()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD addLinksToExplorerBar() CLASS RecibosView

   local oPanel            

   oPanel            := ::oExplorerBar:AddPanel( "Datos relacionados", nil, 1 ) 

   oPanel:AddLink(   "Incidencias...",;
                        {||::oController:getIncidenciasController():activateDialogView( ::oController:getUuid() ) },;
                           ::oController:getIncidenciasController():getImage( "16" ) )
   
   oPanel:AddLink(   "Documentos...",;
                        {||::oController:getDocumentosController():activateDialogView( ::oController:getUuid() ) },;
                           ::oController:getDocumentosController():getImage( "16" ) )

   if ::oController:isNotAppendOrDuplicateMode()

      oPanel:AddLink(   "Factura...",;
                        {||::oController:getFacturasClientesController():ZoomUuid( ::oController:getModelBuffer( "parent_uuid" ) ) },;
                           ::oController:getFacturasClientesController():getImage( "16" ) )

      oPanel:AddLink(   "Pagos...",;
                        {|| msgInfo( "to-do" ) },;
                           ::oController:getFacturasClientesController():getImage( "16" ) )

   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD defaultTitle() CLASS RecibosView

   local cTitle   

   if empty( ::oController:oModel )
      RETURN ( cTitle )
   end if 

   if empty( ::oController:oModel:hBuffer )
      RETURN ( cTitle )
   end if 

   if hhaskey( ::oController:oModel:hBuffer, "concepto" )
      cTitle      :=  alltrim( ::oController:oModel:hBuffer[ "concepto" ] )
   end if

RETURN ( cTitle )

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

   DATA cTableName               INIT "recibos"

   METHOD getColumns()

   METHOD getHashRecibosWhereUuidFactura( uuidFactura )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLRecibosModel

   hset( ::hColumns, "id",                         {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"              ,;                          
                                                      "default"   => {|| 0 } }                                    )

   hset( ::hColumns, "uuid",                       {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"                ,;                                  
                                                      "default"   => {|| win_uuidcreatestring() } }               )

   hset( ::hColumns, "parent_uuid",                {  "create"    => "VARCHAR( 40 )"                              ,;
                                                      "default"   => {|| ::getControllerParentUuid() } }           )

   hset( ::hColumns, "parent_table",               {  "create"    => "VARCHAR( 200 )"                             ,;
                                                      "default"   => {|| space( 200 ) } }                         )

   hset( ::hColumns, "expedicion",                 {  "create"    => "DATE"                                       ,;
                                                      "default"   => {|| hb_date() } }                            )

   hset( ::hColumns, "vencimiento",                {  "create"   => "DATE"                                        ,;
                                                      "default"   => {|| hb_date() } }                            )

   hset( ::hColumns, "importe",                    {  "create"    => "FLOAT( 16,2 )"                              ,;
                                                      "default"   => {||  0  } }                                  )

   hset( ::hColumns, "concepto",                   {  "create"    => "VARCHAR( 200 )"                              ,;
                                                      "default"   => {|| space( 200 ) } }                          )

   ::getDeletedStampColumn()


RETURN ( ::hColumns )

//---------------------------------------------------------------------------//


METHOD getHashRecibosWhereUuidFactura( uuidFactura )

 local cSql

   TEXT INTO cSql

   SELECT uuid

   FROM %1$s AS recibos

   WHERE recibos.parent_uuid= %2$s

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), quoted( uuidFactura ) )

RETURN ( getSQLDatabase():selectTrimedFetchHash( cSql, 0 ) )

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