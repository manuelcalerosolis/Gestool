#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS FacturasClientesDescuentosController FROM SQLBrowseController

   METHOD New()

   METHOD End()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController ) CLASS FacturasClientesDescuentosController

   ::Super:New( oSenderController )

   ::cTitle                      := "Facturas clientes descuentos"

   ::cName                       := "facturas_clientes_descuentos"

   ::hImage                      := {  "16" => "gc_symbol_percent_16",;
                                       "32" => "gc_symbol_percent_32",;
                                       "48" => "gc_symbol_percent_48" }

   ::oModel                      := SQLFacturasClientesDescuentosModel():New( self )

   ::oBrowseView                 := FacturasClientesDescuentosBrowseView():New( self )

   ::oDialogView                 := FacturasClientesDescuentosView():New( self )

   ::oValidator                  := FacturasClientesDescuentosValidator():New( self, ::oDialogView )

   ::oRepository                 := FacturasClientesDescuentosRepository():New( self )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS FacturasClientesDescuentosController

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

CLASS FacturasClientesDescuentosBrowseView FROM SQLBrowseView

   DATA lFastEdit          INIT .t.

   DATA lFooter            INIT .t.

   DATA nFreeze            INIT 1

   DATA nMarqueeStyle      INIT 3

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS FacturasClientesDescuentosBrowseView

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
      :cSortOrder          := 'nombre'
      :cHeader             := 'Nombre'
      :nWidth              := 130
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nEditType           := EDIT_GET
      /*:bOnPostEdit         := {|oCol, uNewValue | ::oController:updateField( 'nombre', uNewValue ) }*/
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'descuento'
      :cHeader             := 'Descuento %'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'descuento' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nFootStyle          := :nDataStrAlign               
      :nFooterType         := AGGR_SUM
      :cEditPicture        := "@E 999.9999"
      :cFooterPicture      := :cEditPicture
      :oFooterFont         := getBoldFont()
      :cDataType           := "N"
      :nEditType           := EDIT_GET
      :bOnPostEdit         := {|oCol, uNewValue | ::oController:updateFieldWhereId( ::getRowSet():fieldGet( 'id' ), 'descuento', ::getRowSet():fieldGet( 'descuento' ) ) }
   end with

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS FacturasClientesDescuentosView FROM SQLBaseView
  
   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS FacturasClientesDescuentosView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "DESCUENTOS" ;
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

   REDEFINE GET   ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "descuento" ] ;
      ID          100 ;
      SPINNER ;
      PICTURE     "@E 999.9999" ;
      VALID       ( ::oController:validate( "descuento" ) ) ;
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

CLASS FacturasClientesDescuentosValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS FacturasClientesDescuentosValidator

   ::hValidators  := {  "descuento" =>           {  "required"              => "El porcentaje de descuento es un dato requerido" } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLFacturasClientesDescuentosModel FROM SQLCompanyModel

   DATA cTableName               INIT "facturas_clientes_descuentos"

   METHOD getColumns() 

   METHOD insertWhereClienteCodigo( cCodigoCliente )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLFacturasClientesDescuentosModel

   hset( ::hColumns, "id",             {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;                          
                                          "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",           {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"             ,;                                  
                                          "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "parent_uuid",    {  "create"    => "VARCHAR( 40 ) NOT NULL"                  ,;
                                          "default"   => {|| ::getSenderControllerParentUuid() } } )

   hset( ::hColumns, "nombre",         {  "create"    => "VARCHAR( 200 ) NOT NULL"                 ,;
                                          "default"   => {|| space( 200 ) } }                      )

   hset( ::hColumns, "descuento",      {  "create"    => "FLOAT(7,4)"                              ,;
                                          "default"   => {|| 0 } }                                 )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD insertWhereClienteCodigo( cCodigoCliente ) CLASS SQLFacturasClientesDescuentosModel

   local cSql

   TEXT INTO cSql

      INSERT IGNORE INTO %1$s 
         ( uuid, parent_uuid, nombre, descuento )

      SELECT 
         UUID(), %4$s, descuentos.nombre, descuentos.descuento

      FROM %2$s AS descuentos

      INNER JOIN %3$s AS clientes 
         ON clientes.codigo = %5$s    

      WHERE 
         descuentos.parent_uuid = clientes.uuid
         AND ( descuentos.fecha_fin IS NULL 
               OR descuentos.fecha_fin >= curdate() 
               ) 
         AND ( descuentos.fecha_inicio IS NULL
               OR descuentos.fecha_inicio <= curdate() )

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), SQLDescuentosModel():getTableName(), SQLClientesModel():getTableName(), quoted( ::getSenderControllerParentUuid() ), quoted( cCodigoCliente ) )

RETURN ( getSQLDatabase():Exec ( cSql ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS FacturasClientesDescuentosRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLFacturasClientesDescuentosModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//