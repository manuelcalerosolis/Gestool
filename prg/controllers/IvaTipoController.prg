#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS TipoIvaController FROM SQLNavigatorController

   METHOD New() CONSTRUCTOR

   METHOD End()

   //Construcciones tardias----------------------------------------------------

   METHOD getBrowseView()              INLINE( if( empty( ::oBrowseView ), ::oBrowseView := TipoIvaBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()              INLINE( if( empty( ::oDialogView ), ::oDialogView := TipoIvaView():New( self ), ), ::oDialogView )

   METHOD getValidator()               INLINE( if( empty( ::oValidator ), ::oValidator := TipoIvaValidator():New( self ), ), ::oValidator )

   METHOD getRepository()              INLINE ( if( empty( ::oRepository ), ::oRepository := TipoIvaRepository():New( self ), ), ::oRepository )
   
   METHOD getModel()                   INLINE ( if( empty( ::oModel ), ::oModel := SQLTiposIvaModel():New( self ), ), ::oModel )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS TipoIvaController

   ::Super:New( oController )

   ::cTitle                            := "Tipos de IVA"

   ::cName                             := "tipo_iva"

   ::hImage                            := {  "16" => "gc_moneybag_16",;
                                             "32" => "gc_moneybag_32",;
                                             "48" => "gc_moneybag_48" }

   ::nLevel                            := Auth():Level( ::cName )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS TipoIvaController

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

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TipoIvaBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS TipoIvaBrowseView

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
      :cSortOrder          := 'porcentaje'
      :cHeader             := 'Porcentaje IVA'
      :nWidth              := 130
      :bEditValue          := {|| transform( ::getRowSet():fieldGet( 'porcentaje' ), "@E 999.99" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with
      with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'recargo'
      :cHeader             := 'Recargo equivalencia'
      :nWidth              := 130
      :bEditValue          := {|| transform( ::getRowSet():fieldGet( 'recargo' ), "@E 999.99" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'cuenta_compra'
      :cHeader             := 'Cuenta de compra'
      :nWidth              := 130
      :bEditValue          := {|| ::getRowSet():fieldGet( 'cuenta_compra' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'cuenta_venta'
      :cHeader             := 'Cuenta de venta'
      :nWidth              := 130
      :bEditValue          := {|| ::getRowSet():fieldGet( 'cuenta_venta' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   ::getColumnDeletedAt()

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TipoIvaView FROM SQLBaseView

   DATA oSayCamposExtra
  
   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS TipoIvaView

   local oBmpGeneral
   local oSayCamposExtra

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "IVA_TIPO" ;
      TITLE       ::LblTitle() + "tipo de IVA"

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

   REDEFINE GET   ::oController:getModel():hBuffer[ "porcentaje" ] ;
      ID          120 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      PICTURE     "@E 999.99" ;
      SPINNER ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:getModel():hBuffer[ "recargo" ] ;
      ID          130 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      PICTURE     "@E 999.99" ;
      SPINNER ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:getModel():hBuffer[ "cuenta_compra" ] ;
      ID          140 ;
      VALID       ( ::oController:validate( "cuenta_compra" ) ) ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:getModel():hBuffer[ "cuenta_venta" ] ;
      ID          150 ;
      VALID       ( ::oController:validate( "cuenta_venta" ) ) ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE SAY   ::oSayCamposExtra ;
      PROMPT      "Campos extra..." ;
      FONT        oFontBold() ; 
      COLOR       rgb( 10, 152, 234 ) ;
      ID          160 ;
      OF          ::oDialog ;

   ::oSayCamposExtra:lWantClick  := .t.
   ::oSayCamposExtra:OnClick     := {|| ::oController:getCamposExtraValoresController():Edit( ::oController:getUuid() ) }

   ApoloBtnFlat():Redefine( IDOK, {|| ::closeActivate() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bKeyDown            := {| nKey | if( nKey == VK_F5, ::closeActivate(), ) }

   ACTIVATE DIALOG ::oDialog CENTER

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TipoIvaValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS TipoIvaValidator

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

CLASS SQLTiposIvaModel FROM SQLCompanyModel

   DATA cTableName                     INIT "tipos_iva"

   DATA cConstraints                   INIT "PRIMARY KEY ( codigo, deleted_at )"

   METHOD getColumns()

   METHOD getPorcentajeWhereCodigo( cCodigo ) ;
                                       INLINE ( ::getField( "porcentaje", "codigo", cCodigo ) )

   METHOD getIvaWhereArticuloCodigo( cCodigoArticulo )

   METHOD CountIvaWherePorcentaje( nPorcentaje )

#ifdef __TEST__

   METHOD test_create_iva_al_21()

   METHOD test_create_iva_al_10()

   METHOD test_create_iva_al_4()

#endif

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLTiposIvaModel

   hset( ::hColumns, "id",             {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;                          
                                          "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",           {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"             ,;                                  
                                          "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "codigo",         {  "create"    => "VARCHAR( 20 )"                            ,;
                                          "default"   => {|| space( 20 ) } }                        )

   hset( ::hColumns, "nombre",         {  "create"    => "VARCHAR( 200 )"                          ,;
                                          "default"   => {|| space( 200 ) } }                       )

   hset( ::hColumns, "porcentaje",     {  "create"    => "FLOAT( 5,2 )"                            ,;
                                          "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "recargo",        {  "create"    => "FLOAT( 5,2 )"                            ,;
                                          "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "cuenta_compra",  {  "create"    => "VARCHAR ( 20 )"                          ,;
                                          "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "cuenta_venta",   {  "create"    => "VARCHAR ( 20 )"                          ,;
                                          "default"   => {|| space( 20 ) } }                       )

   ::getDeletedStampColumn()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getIvaWhereArticuloCodigo( cCodigoArticulo ) CLASS SQLTiposIvaModel

local cSQL

   TEXT INTO cSql

      SELECT tipos_iva.porcentaje

      FROM %1$s AS tipos_iva

      INNER JOIN %2$s AS articulos
         ON tipos_iva.codigo=articulos.tipo_iva_codigo AND articulos.codigo= %3$s

      ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), SQLArticulosModel():getTableName(), quoted( cCodigoArticulo ) ) 


RETURN ( getSQLDatabase():getValue ( cSql ) ) 

//---------------------------------------------------------------------------//

METHOD CountIvaWherePorcentaje( nPorcentaje ) CLASS SQLTiposIvaModel

   local cSql

   TEXT INTO cSql

   SELECT COUNT(*)

   FROM %1$s AS tipos_iva
    
   WHERE tipos_iva.porcentaje = %2$s

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), quoted( nPorcentaje ) )

RETURN ( getSQLDatabase():getValue ( cSql, 0 ) )

//---------------------------------------------------------------------------//

#ifdef __TEST__

METHOD test_create_iva_al_21() CLASS SQLTiposIvaModel

RETURN ( ::insertBuffer( ;
            ::loadBlankBuffer( { "codigo"       => "0",;
                                 "nombre"       => "IVA al 21%",;
                                 "porcentaje"   => 21,;
                                 "recargo"      => 5 } ) ) )

//---------------------------------------------------------------------------//

METHOD test_create_iva_al_10() CLASS SQLTiposIvaModel

RETURN ( ::insertBuffer( ;
            ::loadBlankBuffer( { "codigo"       => "0",;
                                 "nombre"       => "IVA al 10%",;
                                 "porcentaje"   => 10,;
                                 "recargo"      => 1 } ) ) )

//---------------------------------------------------------------------------//

METHOD test_create_iva_al_4() CLASS SQLTiposIvaModel

RETURN ( ::insertBuffer( ;
            ::loadBlankBuffer( { "codigo"       => "0",;
                                 "nombre"       => "IVA al 4%",;
                                 "porcentaje"   => 4,;
                                 "recargo"      => 0.5 } ) ) )

//---------------------------------------------------------------------------//

#endif

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TipoIvaRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLTiposIvaModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
