#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ArticulosPreciosController FROM SQLBrowseController

   METHOD New()

   METHOD End()

   METHOD gettingSelectSentence()

   METHOD setMargen( oCol, nMargen )

   METHOD setPrecioBase( oCol, nPrecioBase )
   
   METHOD setPrecioIVAIncluido( oCol, nPrecioIVAIncluido )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS ArticulosPreciosController

   ::Super:New( oController )

   ::lTransactional                 := .t.

   ::cTitle                         := "Precios de art�culos"

   ::cName                          := "articulos_precios"

   ::oModel                         := SQLArticulosPreciosModel():New( self )

   ::oBrowseView                    := ArticulosPreciosBrowseView():New( self )

   ::oValidator                     := ArticulosPreciosValidator():New( self )

   ::oRepository                    := ArticulosPreciosRepository():New( self )

   ::oModel:setEvent( 'gettingSelectSentence',  {|| ::gettingSelectSentence() } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS ArticulosPreciosController

   ::oModel:End()

   ::oBrowseView:End()

   ::oValidator:End()

   ::oRepository:End()

   ::Super:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD gettingSelectSentence() CLASS ArticulosPreciosController

   local uuid        := ::getSenderController():getUuid() 

   if !empty( uuid )
      ::oModel:setGeneralWhere( "articulo_uuid = " + quoted( uuid ) )
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD setMargen( oCol, nMargen ) CLASS ArticulosPreciosController

   local oCommand

   if ::oValidator:validate( 'margen', nMargen )

      oCommand    := CalculaPrecioCommand():Build( {  'Costo'           => ::oSenderController:getPrecioCosto(),;
                                                      'PorcentajeIVA'   => ::oSenderController:getPorcentajeIVA(),;
                                                      'Margen'          => nMargen } )

      oCommand:caclculaPreciosUsandoMargen()

      ::oModel:updateFieldsCommandWhereUuid( oCommand, ::getRowSet():fieldGet( 'uuid' ) )

      ::getRowSet():Refresh()

   end if 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD setPrecioBase( oCol, nPrecioBase ) CLASS ArticulosPreciosController

   local oCommand := CalculaPrecioCommand():Build( {  'Costo'           => ::oSenderController:getPrecioCosto(),;
                                                      'PorcentajeIVA'   => ::oSenderController:getPorcentajeIVA(),;
                                                      'PrecioBase'      => nPrecioBase } )
   oCommand:caclculaPreciosUsandoBase()

   ::oModel:updateFieldsCommandWhereUuid( oCommand, ::getRowSet():fieldGet( 'uuid' ) )

   ::getRowSet():Refresh()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD setPrecioIVAIncluido( oCol, nPrecioIVAIncluido ) CLASS ArticulosPreciosController

   local oCommand := CalculaPrecioCommand():Build( {  'Costo'              => ::oSenderController:getPrecioCosto(),;
                                                      'PorcentajeIVA'      => ::oSenderController:getPorcentajeIVA(),;
                                                      'PrecioIVAIncluido'  => nPrecioIVAIncluido } )

   oCommand:caclculaPreciosUsandoIVAIncluido()

   ::oModel:updateFieldsCommandWhereUuid( oCommand, ::getRowSet():fieldGet( 'uuid' ) )

   ::getRowSet():Refresh()

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosPreciosBrowseView FROM SQLBrowseView

   DATA lFastEdit             INIT .t.

   DATA lMultiSelect          INIT .f.

   DATA nMarqueeStyle         INIT 3

   METHOD addColumns()                    

ENDCLASS

//---------------------------------------------------------------------------//

METHOD addColumns() CLASS ArticulosPreciosBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'id'
      :cHeader             := 'Id'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'id' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'uuid'
      :cHeader             := 'Uuid'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'nombre'
      :cHeader             := 'Tarifa'
      :nWidth              := 160
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Costo'
      :nWidth              := 80
      :bEditValue          := {|| ::oController:oSenderController:getPrecioCosto() }
      :cEditPicture        := "@E 9999.9999"
      :nDataStrAlign       := 1
      :nHeadStrAlign       := 1
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'margen'
      :cHeader             := 'Margen %'
      :nWidth              := 75
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nHeadBmpNo          := 1
      :nDataStrAlign       := 1
      :nHeadStrAlign       := 1
      :AddResource( "gc_pencil_16" )

      :nEditType           := 1
      :bEditValue          := {|| ::getRowSet():fieldGet( 'margen' ) }
      :bEditBlock          := {|| ::getRowSet():fieldGet( 'margen' ) }
      :cEditPicture        := "@E 9999.9999"
      :bOnPostEdit         := {|oCol, nMargen| ::oController:setMargen( oCol, nMargen ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'margen_real'
      :cHeader             := 'Markup %'
      :nWidth              := 75
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nDataStrAlign       := 1
      :nHeadStrAlign       := 1
      :bEditValue          := {|| ::getRowSet():fieldGet( 'margen_real' ) }
      :cEditPicture        := "@E 9999.9999"
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'precio_base'
      :cHeader             := 'Precio'
      :nWidth              := 100
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nHeadBmpNo          := 1
      :nDataStrAlign       := 1
      :nHeadStrAlign       := 1
      :AddResource( "gc_pencil_16" )

      :nEditType           := 1
      :bEditValue          := {|| ::getRowSet():fieldGet( 'precio_base' ) }
      :bEditBlock          := {|| ::getRowSet():fieldGet( 'precio_base' ) }
      :cEditPicture        := "@E 9999.9999"
      :bOnPostEdit         := {|oCol, nPrecioBase| ::oController:setPrecioBase( oCol, nPrecioBase ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'precio_iva_incluido'
      :cHeader             := 'Precio IVA inc.'
      :nWidth              := 100
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nHeadBmpNo          := 1
      :nDataStrAlign       := 1
      :nHeadStrAlign       := 1
      :AddResource( "gc_pencil_16" )

      :nEditType           := 1
      :bEditValue          := {|| ::getRowSet():fieldGet( 'precio_iva_incluido' ) }
      :bEditBlock          := {|| ::getRowSet():fieldGet( 'precio_iva_incluido' ) }
      :cEditPicture        := "@E 9999.9999"
      :bOnPostEdit         := {|oCol, nPrecioIVAIncluido| ::oController:setPrecioIVAIncluido( oCol, nPrecioIVAIncluido ) }
   end with

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosPreciosValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS ArticulosPreciosValidator

   ::hValidators  := {  "margen" =>    {  "Positive"  => "El valor debe ser mayor o igual a cero" } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLArticulosPreciosModel FROM SQLBaseModel

   DATA cTableName               INIT "articulos_precios"

   DATA cConstraints             INIT "PRIMARY KEY ( id ), UNIQUE KEY ( tarifa_uuid, articulo_uuid )"

   METHOD getInitialSelect()

   METHOD getColumns()

   METHOD getSQLInsertPreciosWhereTarifa( uuidTarifa )

   METHOD insertPreciosWhereTarifa( uuidTarifa )         INLINE ( ::getDatabase():Execs( ::getSQLInsertPreciosWhereTarifa( uuidTarifa ) ) )

   METHOD getSQLInsertPreciosWhereArticulo( uuidArticulo )

   METHOD insertPreciosWhereArticulo( uuidArticulo )     INLINE ( ::getDatabase():Execs( ::getSQLInsertPreciosWhereArticulo( uuidArticulo ) ) )

   METHOD updateFieldsCommandWhereUuid( oCommand, uuid ) INLINE ( ::updateFieldsWhereUuid( uuid,   {  'margen'                => oCommand:Margen(),; 
                                                                                                      'margen_real'           => oCommand:MargenReal(),;
                                                                                                      'precio_base'           => oCommand:PrecioBase(),;
                                                                                                      'precio_iva_incluido'   => oCommand:PrecioIVAIncluido() } ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD getInitialSelect() CLASS SQLArticulosPreciosModel

   local cSelect  := "SELECT articulos_precios.id,"                        + " " + ;
                        "articulos_precios.uuid,"                          + " " + ;
                        "articulos_precios.tarifa_uuid,"                   + " " + ;
                        "articulos_precios.articulo_uuid,"                 + " " + ;
                        "articulos_precios.margen,"                        + " " + ;
                        "articulos_precios.margen_real,"                   + " " + ;
                        "articulos_precios.precio_base,"                   + " " + ;
                        "articulos_precios.precio_iva_incluido,"           + " " + ;
                        "articulos_tarifas.nombre,"                        + " " + ;
                        "articulos_tarifas.margen_predefinido,"            + " " + ;
                        "articulos_tarifas.iva_incluido"                   + " " + ;
                     "FROM articulos_precios"                              + " " + ;
                        "INNER JOIN articulos_tarifas ON articulos_tarifas.uuid = articulos_precios.tarifa_uuid"     + " "

RETURN ( cSelect )

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLArticulosPreciosModel
   
   hset( ::hColumns, "id",                         {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                                      "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",                       {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;
                                                      "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "tarifa_uuid",                {  "create"    => "VARCHAR( 40 )"                           ,;
                                                      "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "articulo_uuid",              {  "create"    => "VARCHAR( 40 )"                           ,;
                                                      "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "margen",                     {  "create"    => "FLOAT( 8, 4 )"                           ,;
                                                      "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "margen_real",                {  "create"    => "FLOAT( 8, 4 )"                           ,;
                                                      "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "precio_base",                {  "create"    => "FLOAT( 16, 6 )"                          ,;
                                                      "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "precio_iva_incluido",        {  "create"    => "FLOAT( 16, 6 )"                          ,;
                                                      "default"   => {|| 0 } }                                 )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getSQLInsertPreciosWhereTarifa( uuidTarifa )

   local cSQL

   cSQL           := "INSERT IGNORE INTO articulos_precios"                                                                + " "  
   cSQL           +=    "( uuid, tarifa_uuid, articulo_uuid, margen, precio_base, precio_iva_incluido )"                   + " "  
   cSQL           += "SELECT uuid(), articulos_tarifas.uuid, articulos.uuid, articulos_tarifas.margen_predefinido, 0, 0"   + " "  
   cSQL           +=    "FROM articulos"                                                                                   + " "  
   cSQL           += "INNER JOIN articulos_tarifas ON articulos_tarifas.empresa_uuid = articulos.empresa_uuid"             + " "  
   cSQL           += "WHERE articulos.empresa_uuid = " + quoted( Company():Uuid() )                                        + " "
   cSQL           +=    "AND articulos_tarifas.uuid = " + quoted( uuidTarifa )

RETURN ( cSQL )

//---------------------------------------------------------------------------//

METHOD getSQLInsertPreciosWhereArticulo( uuidArticulo )

   local cSQL

   cSQL           := "INSERT IGNORE INTO articulos_precios"                                                                + " "  
   cSQL           +=    "( uuid, tarifa_uuid, articulo_uuid, margen, precio_base, precio_iva_incluido )"                   + " "  
   cSQL           += "SELECT uuid(), articulos_tarifas.uuid, " + quoted( uuidArticulo ) + ", articulos_tarifas.margen_predefinido, 0, 0"   + " "  
   cSQL           +=    "FROM articulos_tarifas"                                                                           + " "  
   cSQL           += "WHERE articulos_tarifas.empresa_uuid = " + quoted( Company():Uuid() )                                 

RETURN ( cSQL )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosPreciosRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLArticulosPreciosModel():getTableName() ) 

   METHOD getSQLFunctions()               INLINE ( {  ::dropFunctionPriceUsingMargin(),;
                                                      ::createFunctionPriceUsingMargin(),;
                                                      ::dropFunctionTest(),;
                                                      ::createFunctionTest() } )

   METHOD selectFunctionPriceUsingMargin()
   
   METHOD dropFunctionPriceUsingMargin()  INLINE ( "DROP FUNCTION IF EXISTS CalculatePriceUsingMargin;" )

   METHOD createFunctionPriceUsingMargin()

   METHOD dropFunctionTest()              INLINE ( "DROP FUNCTION IF EXISTS Test;" )

   METHOD createFunctionTest()

END CLASS

//---------------------------------------------------------------------------//

METHOD selectFunctionPriceUsingMargin( precioCosto, porcentajeIVA, Margen, id ) CLASS ArticulosPreciosRepository

   local cSQL  := "SELECT CalculatePriceUsingMargin( "
   cSQL        +=    toSQLString( precioCosto ) + ", "
   cSQL        +=    toSQLString( porcentajeIVA ) + ", "
   cSQL        +=    toSQLString( Margen ) + ", "
   cSQL        +=    toSQLString( id ) + " )"

   logwrite( cSQL )

RETURN ( getSQLDatabase():Exec( cSQL ) )

//---------------------------------------------------------------------------//

METHOD createFunctionPriceUsingMargin() CLASS ArticulosPreciosRepository
   
   local cSQL  := "CREATE FUNCTION CalculatePriceUsingMargin( PrecioCosto INT, PorcentajeIVA INT, Margen INT, idPrecio INT ) RETURNS INT DETERMINISTIC" + space( 1 )
   
   cSQL        += "BEGIN"                                                                                + space( 1 )
   cSQL        +=    "DECLARE PrecioBase INT;"                                                           + space( 1 )
   cSQL        +=    "DECLARE PrecioIVAIncluido INT;"                                                    + space( 1 )
   cSQL        +=    "DECLARE MargenReal INT;"                                                           + space( 1 )
   
   cSQL        +=    "SET PrecioBase = PrecioCosto + ( PrecioCosto * Margen / 100 );"                    + space( 1 )
   cSQL        +=    "SET PrecioIVAIncluido = PrecioBase + ( PrecioBase * PorcentajeIVA / 100 );"        + space( 1 )
   cSQL        +=    "SET MargenReal = ( PrecioBase - PrecioCosto ) / PrecioCosto * 100;"                + space( 1 )

   cSql        +=    "UPDATE " + ::getTableName() + " SET"                                               + space( 1 )
   cSql        +=       "precio_base = PrecioBase,"                                                      + space( 1 )
   cSql        +=       "precio_iva_incluido = PrecioIVAIncluido,"                                       + space( 1 )
   cSql        +=       "margen_real = MargenReal"                                                       + space( 1 )
   cSql        +=    "WHERE id = idPrecio;"                                                              + space( 1 )

   cSQL        +=    "RETURN PrecioBase;"                                                                + space( 1 )
   cSQL        += "END;"                                                                                 + space( 1 )

   logwrite( cSQL )

RETURN ( cSQL )

//---------------------------------------------------------------------------//

METHOD createFunctionTest() CLASS ArticulosPreciosRepository
   
   local cSQL  := "CREATE FUNCTION Test( idPrecio INT ) RETURNS INT DETERMINISTIC" + space( 1 )
   
   cSQL        += "BEGIN"                                                                                + space( 1 )
   cSql        +=    "UPDATE " + ::getTableName() + " SET"                                               + space( 1 )
   cSql        +=       "precio_base = 1234"                                                             + space( 1 )
   cSql        +=    "WHERE id = @idPrecio;"                                                             + space( 1 )
   cSQL        +=    "RETURN 1;"                                                                         + space( 1 )
   cSQL        += "END;"                                                                                 + space( 1 )

   logwrite( cSQL )

RETURN ( cSQL )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
