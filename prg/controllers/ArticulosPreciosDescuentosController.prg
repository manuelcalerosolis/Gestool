#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ArticulosPreciosDescuentosController FROM SQLNavigatorController

   METHOD New()

   METHOD gettingSelectSentence()

   METHOD loadBlankBuffer()            INLINE ( ::oModel:loadBlankBuffer() )
   METHOD insertBuffer()               INLINE ( ::oModel:insertBuffer() )

   METHOD loadedCurrentBuffer( uuidEntidad ) 
   METHOD updateBuffer( uuidEntidad )

   METHOD loadedDuplicateCurrentBuffer( uuidEntidad )
   METHOD loadedDuplicateBuffer( uuidEntidad )

   METHOD deleteBuffer( aUuidEntidades )

   METHOD End()

   METHOD activatingDialogModalView()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController ) CLASS ArticulosPreciosDescuentosController

   ::Super:New( oSenderController )

   ::cTitle                         := "Descuentos artículos" 

   ::cName                          := "descuentos_articulos"

   ::hImage                         := {  "16" => "gc_symbol_percent_16",;
                                          "32" => "gc_symbol_percent_32",;
                                          "48" => "gc_symbol_percent_48" }

   ::nLevel                         := Auth():Level( ::cName )

   ::oModel                         := SQLArticulosPreciosDescuentosModel():New( self )

   ::oBrowseView                    := ArticulosPreciosDescuentosBrowseView():New( self )

   ::oDialogView                    := ArticulosPreciosDescuentosView():New( self )

   ::oValidator                     := ArticulosPreciosDescuentosValidator():New( self, ::oDialogView )

   ::oRepository                    := ArticulosPreciosDescuentosRepository():New( self )

   ::oDialogModalView:setEvent( 'activating', {|| ::activatingDialogModalView() } )

   ::setEvent( 'appending',                     {|| ::oBrowseView:Refresh() } )
   ::setEvent( 'edited',                        {|| ::oBrowseView:Refresh() } )
   ::setEvent( 'deletedSelection',              {|| ::oBrowseView:Refresh() } )

   ::oModel:setEvent( 'gettingSelectSentence',  {|| ::gettingSelectSentence() } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS ArticulosPreciosDescuentosController

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oRepository:End()

   ::Super:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD activatingDialogModalView()

   local cTitle 

   cTitle   := "Descuentos artículo : " + alltrim( ::oSenderController:oSenderController:getModelBuffer( "codigo" ) )
   
   cTitle   += " - "

   cTitle   += alltrim( ::oSenderController:oSenderController:getModelBuffer( "nombre" ) )

   cTitle   += ", "

   cTitle   += "sobre tarifa : " + ::oSenderController:getRowSet():fieldGet( 'articulos_tarifas_nombre' )

   ::oDialogModalView:setTitle( cTitle )

RETURN ( nil )

//---------------------------------------------------------------------------//


METHOD gettingSelectSentence() CLASS ArticulosPreciosDescuentosController

   local uuid        := ::getSenderController():getUuid() 

   if !empty( uuid )
      ::oModel:setGeneralWhere( "parent_uuid = " + quoted( uuid ) )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD LoadedCurrentBuffer( uuiddescuento ) CLASS ArticulosPreciosDescuentosController

   local idDescuento     

   if empty( uuiddescuento )
      ::oModel:insertBuffer()
   end if 

   idDescuento          := ::oModel:getIdWhereParentUuid( uuiddescuento )
   if empty( idDescuento )
      idDescuento       := ::oModel:insertBlankBuffer()
   end if 

   ::oModel:loadCurrentBuffer( idDescuento )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD UpdateBuffer( uuidDescuento ) CLASS ArticulosPreciosDescuentosController

   local idDescuento     

   idDescuento          := ::oModel:getIdWhereParentUuid( uuidDescuento )
   if empty( idDescuento )
      ::oModel:insertBuffer()
      RETURN ( self )
   end if 

   ::oModel:updateBuffer()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD loadedDuplicateCurrentBuffer( uuidDescuento ) CLASS ArticulosPreciosDescuentosController

   local idDescuento     

   idDescuento          := ::oModel:getIdWhereParentUuid( uuidDescuento )
   if empty( idDescuento )
      ::oModel:insertBuffer()
      RETURN ( self )
   end if 

   ::oModel:loadDuplicateBuffer( idDescuento )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD loadedDuplicateBuffer( uuidDescuento ) CLASS ArticulosPreciosDescuentosController

   hset( ::oModel:hBuffer, "parent_uuid", uuidDescuento )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD deleteBuffer( aUuidEntidades ) CLASS ArticulosPreciosDescuentosController

   if empty( aUuidEntidades )
      RETURN ( self )
   end if

   ::oModel:deleteWhereParentUuid( aUuidEntidades )

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosPreciosDescuentosBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS ArticulosPreciosDescuentosBrowseView

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
      :cSortOrder          := 'porcentaje'
      :cHeader             := '% Descuento'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'porcentaje' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'cantidad'
      :cHeader             := 'Unidades'
      :nWidth              := 120
      :bEditValue          := {|| ::getRowSet():fieldGet( 'cantidad' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'fecha_inicio'
      :cHeader             := 'Fecha inicio'
      :nWidth              := 120
      :bEditValue          := {|| ::getRowSet():fieldGet( 'fecha_inicio' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'fecha_fin'
      :cHeader             := 'Fecha fin'
      :nWidth              := 120
      :bEditValue          := {|| ::getRowSet():fieldGet( 'fecha_fin' ) }
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

CLASS ArticulosPreciosDescuentosView FROM SQLBaseView
  
   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS ArticulosPreciosDescuentosView

   local oDialog
   local oBmpGeneral

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "ARTICULOS_PRECIOS_DESCUENTOS" ;
      TITLE       ::LblTitle() + "descuento"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        getBoldFont() ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "porcentaje" ] ;
      ID          100 ;
      SPINNER ;
      PICTURE     "@E 999.9999" ;
      VALID       ( ::oController:validate( "porcentaje" ) ) ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "fecha_inicio" ] ;
      ID          110 ;
      SPINNER ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "fecha_fin" ] ;
      ID          120 ;
      SPINNER ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "cantidad" ] ;
      ID          130 ;
      SPINNER ;
      PICTURE     "@E 999999" ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
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
      ACTION     ( ::oDialog:end() )

   if ::oController:isNotZoomMode() 
      ::oDialog:AddFastKey( VK_F5, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) } )
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

CLASS ArticulosPreciosDescuentosValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS ArticulosPreciosDescuentosValidator

   ::hValidators  := {  "porcentaje" =>           {  "required"              => "El porcentaje de descuento es un dato requerido" } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLArticulosPreciosDescuentosModel FROM SQLCompanyModel

   DATA cTableName               INIT "articulos_precios_descuentos"

   DATA cConstraints             INIT "PRIMARY KEY ( porcentaje, cantidad, fecha_inicio )"

   METHOD getColumns()

   METHOD getIdWhereParentUuid( uuid )    INLINE ( ::getField( 'id', 'parent_uuid', uuid ) )

   METHOD getParentUuidAttribute( value )

   METHOD getSentenceDescuentoPorArticulo( articulo_uuid, tarifa_codigo, unidades, fecha_factura )

   METHOD getDescuentoPorArticulo( articulo_uuid, tarifa_codigo, unidades, fecha_factura ) ;
                                          INLINE   ( ::ExecuteSqlStatement(::getSentenceDescuentoPorArticulo( articulo_uuid, tarifa_codigo, unidades, fecha_factura ) ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLArticulosPreciosDescuentosModel

   hset( ::hColumns, "id",                      {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;                          
                                                   "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",                    {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"             ,;                                  
                                                   "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "parent_uuid",             {  "create"    => "VARCHAR( 40 ) NOT NULL"                  ,;
                                                   "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "fecha_inicio",            {  "create"    => "DATE"                                    ,;
                                                   "default"   => {|| getSysDate() } }                        )

   hset( ::hColumns, "fecha_fin",               {  "create"    => "DATE"                                    ,;
                                                   "default"   => {|| ctod( "" ) } }                        )

   hset( ::hColumns, "porcentaje",              {  "create"    => "FLOAT(7,4)"                              ,;
                                                   "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "cantidad",                {  "create"    => "INT UNSIGNED"                            ,;
                                                   "default"   => {|| 0 } }                                 )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getParentUuidAttribute( value ) CLASS SQLArticulosPreciosDescuentosModel

   if empty( ::oController )
      RETURN ( value )
   end if

   if empty( ::oController:oSenderController )
      RETURN ( value )
   end if

RETURN ( ::oController:oSenderController:getUuid() )

//---------------------------------------------------------------------------//

METHOD getSentenceDescuentoPorArticulo( articulo_uuid, tarifa_codigo, unidades, fecha_factura ) CLASS SQLArticulosPreciosDescuentosModel
   
   local cSelect

   cSelect  := "SELECT articulos_precios_descuentos.porcentaje as porcentaje "                                                                                                                                
   cSelect  +=    "FROM "+ ::getTableName() + " AS articulos_precios_descuentos " 

   cSelect  +=    "INNER JOIN "+ SQLArticulosPreciosModel():getTableName() +" as articulos_precios "                                                                  
   cSelect  +=    "ON articulos_precios_descuentos.parent_uuid = articulos_precios.uuid "

   cSelect  +=    "INNER JOIN " + SQLArticulosModel():getTableName() + " as articulos "                                                                  
   cSelect  +=    "ON articulos_precios.articulo_uuid = " + quoted( articulo_uuid ) + " " 

   cSelect  +=    "INNER JOIN " + SQLArticulosTarifasModel():getTableName() + " as articulos_tarifas "                                                                  
   cSelect  +=    "ON articulos_tarifas.codigo = " + tarifa_codigo + " "

   cSelect  +=    "WHERE fecha_inicio <= " + dtoc( fecha_factura ) + " "                                                                  
   cSelect  +=       "( AND fecha_fin >= " + dtoc( fecha_factura ) + " OR fecha_fin IS NULL ) "                                                                  
   cSelect  +=       "AND articulos_precios_descuentos.cantidad >= " + quoted(unidades) + " "                                                                  
   cSelect  +=       "AND articulos_precios.uuid = articulos_precios_descuentos.parent_uuid "                                                                  

   cSelect  +=    "ORDER BY articulos_precios_descuentos.porcentaje desc " 

   cSelect  +=    "LIMIT 1 "

RETURN ( cSelect )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosPreciosDescuentosRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLArticulosPreciosDescuentosModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//