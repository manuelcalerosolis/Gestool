#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ArticulosPreciosController FROM SQLBrowseController

   METHOD New()

   METHOD End()

   METHOD setMargen( oCol, nMargen )

   METHOD setPrecioBase( oCol, nPrecioBase )
   
   METHOD setPrecioIVAIncluido( oCol, nPrecioIVAIncluido )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS ArticulosPreciosController

   ::Super:New( oController )

   ::lTransactional                 := .t.

   ::cTitle                         := "Precios de artículos"

   ::cName                          := "articulos_precios"

   ::oModel                         := SQLArticulosPreciosModel():New( self )

   ::oBrowseView                    := ArticulosPreciosBrowseView():New( self )

   ::oValidator                     := ArticulosPreciosValidator():New( self )

   ::oRepository                    := ArticulosPreciosRepository():New( self )

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

METHOD setMargen( oCol, nMargen ) CLASS ArticulosPreciosController

   local oCommand

   if ::oValidator:validate( 'margen', nMargen )

      oCommand    := CalculaPrecioCommand():Build( {  'Costo'           => ::oSenderController:getPrecioCosto(),;
                                                      'PorcentajeIVA'   => ::oSenderController:getPorcentajeIVA(),;
                                                      'Margen'          => nMargen } )

      oCommand:caclculaPreciosUsandoMargen()

      ::oModel:updateFieldsCommandWhereUuid( oCommand, ::getRowSet():fieldGet( 'uuid' ) )

      ::getRowSet():Refresh()

   else

      msgalert( "margen no validado" )

   end if 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD setPrecioBase( oCol, nPrecioBase ) CLASS ArticulosPreciosController

   // local oCommand := CalculaPrecioCommand():Build( {  'Costo'           => ::oSenderController:getPrecioCosto(),;
   //                                                    'PorcentajeIVA'   => ::oSenderController:getPorcentajeIVA(),;
   //                                                    'PrecioBase'      => nPrecioBase } )
   
   // oCommand:caclculaPreciosUsandoBase()

   // ::oModel:updateFieldsCommandWhereUuid( oCommand,  )

   ::oRepository:callUpdatePrecioBaseWhereUuid( ::getRowSet():fieldGet( 'uuid' ), nPrecioBase )

   ::getRowSet():Refresh()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD setPrecioIVAIncluido( oCol, nPrecioIVAIncluido ) CLASS ArticulosPreciosController

   // local oCommand := CalculaPrecioCommand():Build( {  'Costo'              => ::oSenderController:getPrecioCosto(),;
   //                                                    'PorcentajeIVA'      => ::oSenderController:getPorcentajeIVA(),;
   //                                                    'PrecioIVAIncluido'  => nPrecioIVAIncluido } )

   // oCommand:caclculaPreciosUsandoIVAIncluido()

   // ::oModel:updateFieldsCommandWhereUuid( oCommand, ::getRowSet():fieldGet( 'uuid' ) )
   
   ::oRepository:callUpdatePrecioIvaIncluidoWhereUuid( ::getRowSet():fieldGet( 'uuid' ), nPrecioIVAIncluido )

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
      :nWidth              := 120
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
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'margen'
      :cHeader             := 'Margen %'
      :nWidth              := 75
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nHeadBmpNo          := 1
      :nDataStrAlign       := 1
      :nHeadStrAlign       := 1
      :addResource( "gc_pencil_16" )
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
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'articulos_tarifas_base_nombre'
      :cHeader             := 'Sobre tarifa'
      :nWidth              := 120
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :bEditValue          := {|| ::getRowSet():fieldGet( 'articulos_tarifas_base_nombre' ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'precio_base'
      :cHeader             := 'Precio'
      :nWidth              := 100
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nHeadBmpNo          := 1
      :nDataStrAlign       := 1
      :nHeadStrAlign       := 1
      :addResource( "gc_pencil_16" )
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

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'manual'
      :cHeader             := "Manual"
      :bStrData            := {|| "" }
      :bEditValue          := {|| ::getRowSet():fieldGet( 'manual' ) == 1 }
      :nWidth              := 60
      :SetCheck( { "Sel16", "Nil16" } )
   end with

RETURN ( nil )

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

CLASS SQLArticulosPreciosModel FROM SQLCompanyModel

   DATA cTableName                  INIT "articulos_precios"

   DATA cConstraints                INIT "PRIMARY KEY ( id ), UNIQUE KEY ( articulo_uuid, tarifa_uuid )"

   METHOD getColumns()

   METHOD getOrderBy()              INLINE ( "id" )

   METHOD addParentUuidWhere( cSQLSelect )    

   METHOD isParentUuidColumn()      INLINE ( hb_hhaskey( ::hColumns, "articulo_uuid" ) )

   METHOD getInitialSelect()

   METHOD getPrecioSobre( nPrecioCosto )

   METHOD getPrecioBase( nPrecioCosto ) ;
                                    INLINE ( "( " + ::getPrecioSobre( nPrecioCosto ) + " * articulos_tarifas.margen / 100 ) + " + ::getPrecioSobre( nPrecioCosto ) )

   METHOD getPrecioIVA( nPrecioCosto ) ;
                                    INLINE ( "( " + ::getPrecioBase( nPrecioCosto ) + " * tipos_iva.porcentaje / 100 ) + " + ::getPrecioBase( nPrecioCosto ) )

   METHOD getInnerJoinArticulosTarifas( uuidTarifa ) INLINE ;
                                    (  "INNER JOIN " + SQLArticulosTarifasModel():getTableName() + " AS articulos_tarifas " + CRLF + ;
                                          "ON articulos_tarifas.uuid = " + quoted( uuidTarifa ) + " " + CRLF )

   METHOD getInnerJoinTiposIva()    INLINE ;
                                    (  "LEFT JOIN " + SQLTiposIvaModel():getTableName() + " AS tipos_iva " + CRLF + ;
                                          "ON tipos_iva.codigo = articulos.tipo_iva_codigo " + CRLF )

   METHOD getSQLInsertPrecioWhereTarifa( uuidTarifa, lCosto )
   METHOD getSQLUpdatePrecioWhereTarifa( uuidTarifa, lCosto )

   METHOD insertUpdatePrecioWhereTarifa( uuidTarifa, lCosto ) ;
                                    INLINE ( ::getDatabase():Exec( ::getSQLInsertPrecioWhereTarifa( uuidTarifa, lCosto ) ),;
                                             ::getDatabase():Exec( ::getSQLUpdatePrecioWhereTarifa( uuidTarifa, lCosto ) ) )

   METHOD updatePrecioWhereTarifaAndArticulo( idPrecio, nPrecioCosto ) ;
                                    INLINE ( ::getDatabase():Exec( ::getSQLUpdatePrecioWhereTarifaAndArticulo( idPrecio, nPrecioCosto ) ) )

   METHOD getSQLUpdatePrecioWhereTarifaAndArticulo( idPrecio, nPrecioCosto )

   METHOD getSQLInsertPreciosWhereTarifa( codigoTarifa )

   METHOD insertPreciosWhereTarifa( codigoTarifa ) ;
                                    INLINE ( ::getDatabase():Execs( ::getSQLInsertPreciosWhereTarifa( codigoTarifa ) ) )

   METHOD getSQLInsertPreciosWhereArticulo( uuidArticulo )

   METHOD insertPreciosWhereArticulo( uuidArticulo ) ;     
                                    INLINE ( ::getDatabase():Execs( ::getSQLInsertPreciosWhereArticulo( uuidArticulo ) ) )

   METHOD updateFieldsCommandWhereUuid( oCommand, uuid ) ;
                                    INLINE ( ::updateBufferWhereUuid( uuid,   {  'margen'                => oCommand:Margen(),; 
                                                                                 'margen_real'           => oCommand:MargenReal(),;
                                                                                 'precio_base'           => oCommand:PrecioBase(),;
                                                                                 'precio_iva_incluido'   => oCommand:PrecioIVAIncluido(),;
                                                                                 'manual'                => 1 } ) )
   
END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLArticulosPreciosModel
   
   hset( ::hColumns, "id",                         {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                                      "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",                       {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;
                                                      "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "articulo_uuid",              {  "create"    => "VARCHAR( 40 )"                           ,;
                                                      "default"   => {|| ::getSenderControllerParentUuid() } } )

   hset( ::hColumns, "tarifa_uuid",                {  "create"    => "VARCHAR( 40 )"                           ,;
                                                      "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "manual",                     {  "create"    => "TINYINT ( 1 )"                           ,;
                                                      "default"   => {|| "0" } }                               )

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

METHOD getInitialSelect() CLASS SQLArticulosPreciosModel

   local cSelect  := "SELECT "
   cSelect        +=   "articulos_precios.id, "                                                                
   cSelect        +=    "articulos_precios.uuid, "                                                                  
   cSelect        +=    "articulos_precios.articulo_uuid, "                                                           
   cSelect        +=    "articulos_precios.tarifa_uuid, "                                                         

   cSelect        +=    "articulos_precios.margen, "
   cSelect        +=    "articulos_precios.margen_real, "                                                           

   cSelect        +=    "articulos_precios.precio_base, "
   cSelect        +=    "articulos_precios.precio_iva_incluido, "                                                   
   cSelect        +=    "articulos_precios.manual, "                                                                

   cSelect        +=    "articulos_tarifas.nombre, "                                                                
   cSelect        +=    "articulos_tarifas.parent_uuid, "                                                           

   cSelect        +=    "IFNULL( articulos_tarifas_base.nombre, 'Costo' ) AS articulos_tarifas_base_nombre "  

   cSelect        += "FROM " + ::getTableName() + " AS articulos_precios "                

   cSelect        +=    "INNER JOIN " + SQLArticulosTarifasModel():getTableName() + " AS articulos_tarifas "        
   cSelect        +=       "ON articulos_tarifas.uuid = articulos_precios.tarifa_uuid "                              

   cSelect        +=    "LEFT JOIN " + SQLArticulosTarifasModel():getTableName() + " AS articulos_tarifas_base "        
   cSelect        +=       "ON articulos_tarifas_base.uuid = articulos_tarifas.parent_uuid "                              

   cSelect        +=    "LEFT JOIN " + ::getTableName() + " AS articulos_precios_parent "        
   cSelect        +=       "ON articulos_precios_parent.articulo_uuid = articulos_precios.articulo_uuid AND articulos_precios_parent.tarifa_uuid = articulos_tarifas.parent_uuid"

RETURN ( cSelect )

//---------------------------------------------------------------------------//

METHOD getPrecioSobre( nPrecioCosto ) 

   if !empty( nPrecioCosto )
      RETURN ( "IF( articulos_tarifas.parent_uuid = '', " + hb_ntos( nPrecioCosto ) + ", articulos_precios_parent.precio_base )" )
   end if 

RETURN ( "IF( articulos_tarifas.parent_uuid = '', articulos.precio_costo, articulos_precios_parent.precio_base )" ) 

//---------------------------------------------------------------------------//

METHOD getSQLInsertPrecioWhereTarifa( uuidTarifa ) CLASS SQLArticulosPreciosModel

   local cSQL

   cSQL  := "INSERT IGNORE INTO " + ::getTableName() + " "  + CRLF  
   
   cSQL  +=    "( uuid, " + CRLF
   cSQL  +=    "articulo_uuid, " + CRLF
   cSQL  +=    "tarifa_uuid, " + CRLF
   cSQL  +=    "margen, " + CRLF
   cSQL  +=    "precio_base, " + CRLF
   cSQL  +=    "precio_iva_incluido ) " + CRLF

   cSQL  += "SELECT " + CRLF

   cSQL  +=    "UUID(), "+ CRLF
   cSQL  +=    "articulos.uuid, "+ CRLF
   cSQL  +=    quoted( uuidTarifa ) + ", " + CRLF
   cSQL  +=    "articulos_tarifas.margen, " + CRLF
   cSQL  +=    "( @precioBase := ( ( @precioSobre := IF( articulos_tarifas.parent_uuid = '', articulos.precio_costo, articulos_precios_parent.precio_base ) ) * articulos_tarifas.margen / 100 ) + @precioSobre ), " + CRLF
   cSQL  +=    "@precioIVA := ( @precioBase * tipos_iva.porcentaje / 100 ) + @precioBase " + CRLF

   cSQL  += "FROM " + SQLArticulosModel():getTableName() + " AS articulos "+ CRLF

   cSQL  += "INNER JOIN " + SQLArticulosTarifasModel():getTableName() + " AS articulos_tarifas " + CRLF 
   cSQL  +=    "ON articulos_tarifas.uuid = " + quoted( uuidTarifa ) + " " + CRLF

   cSQL  += "LEFT JOIN " + SQLTiposIvaModel():getTableName() + " AS tipos_iva " + CRLF 
   cSQL  +=    "ON tipos_iva.codigo = articulos.tipo_iva_codigo " + CRLF

   cSQL  += "LEFT JOIN " + ::getTableName() + " AS articulos_precios_parent "+ CRLF            
   cSQL  +=    "ON articulos_precios_parent.articulo_uuid = articulos.uuid "+ CRLF                
   cSQL  +=    "AND articulos_precios_parent.tarifa_uuid = articulos_tarifas.uuid "+ CRLF

   logwrite( cSQL )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getSQLUpdatePrecioWhereTarifa( uuidTarifa, lCosto ) CLASS SQLArticulosPreciosModel

   local cSQL
   
   cSQL  := "UPDATE " + ::getTableName() + " AS articulos_precios " + CRLF  

   cSQL  += ::getInnerJoinArticulosTarifas( uuidTarifa )

   cSQL  += "LEFT JOIN " + ::getTableName() + " AS articulos_precios_parent " + CRLF    
   cSQL  +=    "ON articulos_precios_parent.tarifa_uuid = articulos_tarifas.parent_uuid " + CRLF
   cSQL  +=    "AND articulos_precios_parent.articulo_uuid = articulos_precios.articulo_uuid " + CRLF

   cSQL  += "LEFT JOIN " + SQLArticulosModel():getTableName() + " AS articulos " + CRLF 
   cSQL  +=    "ON articulos.uuid = articulos_precios.articulo_uuid " + CRLF

   cSQL  += "LEFT JOIN " + SQLTiposIvaModel():getTableName() + " AS tipos_iva " + CRLF 
   cSQL  +=    "ON tipos_iva.codigo = articulos.tipo_iva_codigo " + CRLF

   cSQL  += "SET " + CRLF

   cSQL  +=    "articulos_precios.margen = articulos_tarifas.margen, " + CRLF
   
   //cSQL  +=    "articulos_precios.precio_base = " + ::getPrecioBase( lCosto ) + " ," + CRLF 
   //cSQL  +=    "articulos_precios.precio_iva_incluido = " + ::getPrecioIVA( lCosto ) + " " + CRLF

   cSQL  +=    "articulos_precios.precio_base = ( @precioBase := ( ( @precioSobre := IF( articulos_tarifas.parent_uuid = '', articulos.precio_costo, articulos_precios_parent.precio_base ) ) * articulos_tarifas.margen / 100 ) + @precioSobre ), " + CRLF
   cSQL  +=    "articulos_precios.precio_iva_incluido = ( @precioBase * tipos_iva.porcentaje / 100 ) + @precioBase " + CRLF

   cSQL  += "WHERE " + CRLF
   cSQL  +=    "( articulos_precios.manual IS NULL OR articulos_precios.manual != 1 ) " + CRLF
   cSQL  +=    "AND articulos_precios.tarifa_uuid = " + quoted( uuidTarifa ) + CRLF

   logwrite( cSQL )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getSQLUpdatePrecioWhereTarifaAndArticulo( idPrecio, nPrecioCosto ) CLASS SQLArticulosPreciosModel

   local cSQL
   
   cSQL  := "UPDATE " + ::getTableName() + " AS articulos_precios " + CRLF  

   cSQL  += "INNER JOIN " + SQLArticulosTarifasModel():getTableName() + " AS articulos_tarifas " + CRLF + ;
               "ON articulos_tarifas.uuid = articulos_precios.tarifa_uuid " + CRLF

   cSQL  += "LEFT JOIN " + SQLArticulosModel():getTableName() + " AS articulos " + CRLF 
   cSQL  +=    "ON articulos.uuid = articulos_precios.articulo_uuid " + CRLF

   cSQL  += ::getInnerJoinTiposIva()

   cSQL  += "LEFT JOIN " + ::getTableName() + " AS articulos_precios_parent " + CRLF    
   cSQL  +=    "ON articulos_precios_parent.tarifa_uuid = articulos_tarifas.parent_uuid " + CRLF
   cSQL  +=    "AND articulos_precios_parent.articulo_uuid = articulos_precios.articulo_uuid " + CRLF

   cSQL  += "SET " + CRLF

   cSQL  +=    "articulos_precios.margen = articulos_tarifas.margen, " + CRLF
   cSQL  +=    "articulos_precios.precio_base = " + ::getPrecioBase( nPrecioCosto ) + ", " + CRLF 
   cSQL  +=    "articulos_precios.precio_iva_incluido = ( articulos_precios.precio_base * IFNULL( tipos_iva.porcentaje, 0 ) / 100 ) + articulos_precios.precio_base " + CRLF   

   cSQL  += "WHERE " + CRLF
   cSQL  +=    "( articulos_precios.manual IS NULL OR articulos_precios.manual != 1 ) " + CRLF
   cSQL  +=    "AND articulos_precios.id = " + quoted( idPrecio ) + " " + CRLF

   logwrite( cSQL )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getSQLInsertPreciosWhereTarifa( codigoTarifa ) CLASS SQLArticulosPreciosModel

   local cSQL

   cSQL           := "INSERT IGNORE INTO " + ::getTableName()                                                  + " "  
   cSQL           +=    "( uuid, articulo_uuid, tarifa_uuid )"                                                 + " "  
   cSQL           += "SELECT UUID(), articulos.uuid, articulos_tarifas.uuid"                                   + " "  
   cSQL           +=    "FROM " + SQLArticulosModel():getTableName() + " AS articulos"                         + " "
   cSQL           +=    "INNER JOIN " + SQLArticulosTarifasModel():getTableName() + " AS articulos_tarifas"    + " "
   cSql           +=    "ON articulos_tarifas.codigo = " + quoted( codigoTarifa )

RETURN ( cSQL )

//---------------------------------------------------------------------------//

METHOD getSQLInsertPreciosWhereArticulo( uuidArticulo ) CLASS SQLArticulosPreciosModel

   local cSQL     

   cSQL           := "INSERT IGNORE INTO " + ::getTableName()                                                                 + " "  
   cSQL           +=    "( uuid, articulo_uuid, tarifa_uuid, margen, precio_base, precio_iva_incluido )"                      + " "  
   cSQL           += "SELECT uuid(), " + quoted( uuidArticulo ) + ", articulos_tarifas.uuid, articulos_tarifas.margen, 0, 0"  + " "  
   cSQL           +=    "FROM " + SQLArticulosTarifasModel():getTableName() + " AS articulos_tarifas"                         + " "  
   cSQL           +=    "ORDER BY id"

RETURN ( cSQL )

//---------------------------------------------------------------------------//

METHOD addParentUuidWhere( cSQLSelect ) CLASS SQLArticulosPreciosModel    

   local uuid     := ::oController:getSenderController():getUuid() 

   if !empty( uuid )
      cSQLSelect  += ::getWhereOrAnd( cSQLSelect ) + ::getTableName() + ".articulo_uuid = " + quoted( uuid )
   end if 

RETURN ( cSQLSelect )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosPreciosRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLArticulosPreciosModel():getTableName() ) 

   METHOD getSQLFunctions()               INLINE ( {  ::dropFunctionUpdatePrecioBaseWhereUuid(),;
                                                      ::createFunctionUpdatePrecioBaseWhereUuid(),;
                                                      ::dropFunctionUpdatePrecioIvaIncluidoWhereUuid(),;
                                                      ::createFunctionUpdatePrecioIvaIncluidoWhereUuid() } )

   METHOD dropFunctionUpdatePrecioBaseWhereUuid()  

   METHOD createFunctionUpdatePrecioBaseWhereUuid()

   METHOD callUpdatePrecioBaseWhereUuid( uuidPrecioArticulo, precioBase )

   METHOD dropFunctionUpdatePrecioIvaIncluidoWhereUuid()

   METHOD callUpdatePrecioIvaIncluidoWhereUuid( uuidPrecioArticulo, precioIvaIncluido ) 

   METHOD createFunctionUpdatePrecioIvaIncluidoWhereUuid()   

END CLASS

//---------------------------------------------------------------------------//

METHOD dropFunctionUpdatePrecioBaseWhereUuid() CLASS ArticulosPreciosRepository  

RETURN ( "DROP PROCEDURE IF EXISTS " + Company():getTableName( 'UpdatePrecioBaseWhereUuid' ) + ";" )

//---------------------------------------------------------------------------//

METHOD callUpdatePrecioBaseWhereUuid( uuidPrecioArticulo, precioBase ) CLASS ArticulosPreciosRepository

RETURN ( getSQLDatabase():Exec( "CALL " + Company():getTableName( 'UpdatePrecioBaseWhereUuid' ) + "( " + quoted( uuidPrecioArticulo ) + ", " + hb_ntos( precioBase ) + " )" ) )

//---------------------------------------------------------------------------//

METHOD createFunctionUpdatePrecioBaseWhereUuid() CLASS ArticulosPreciosRepository

   local cSQL

   cSQL  := "DELIMITER $$ " + CRLF

   cSQL  := "CREATE DEFINER=`root`@`localhost` PROCEDURE " + Company():getTableName( 'UpdatePrecioBaseWhereUuid' ) + " ( IN `uuid_precio_articulo` CHAR(40), IN `precio_base` FLOAT(16,6) ) " + CRLF
   cSQL  += "LANGUAGE SQL "+ CRLF
   cSQL  += "NOT DETERMINISTIC "+ CRLF
   cSQL  += "CONTAINS SQL "+ CRLF
   cSQL  += "SQL SECURITY DEFINER "+ CRLF
   cSQL  += "COMMENT '' "+ CRLF
   cSQL  += "BEGIN "+ CRLF

   cSQL  += "UPDATE " + ::getTableName() + " AS articulos_precios " + CRLF

   cSQL  += "INNER JOIN " + SQLArticulosModel():getTableName() + " AS articulos " + CRLF
   cSQL  += "   ON articulos.uuid = articulos_precios.articulo_uuid " + CRLF

   cSQL  += "LEFT JOIN " + SQLTiposIvaModel():getTableName() + " AS tipos_iva " + CRLF
   cSQL  += "   ON tipos_iva.codigo = articulos.tipo_iva_codigo " + CRLF

   cSQL  += "SET " + CRLF

   cSQL  += "articulos_precios.precio_base = precio_base, " + CRLF
   cSQL  += "articulos_precios.precio_iva_incluido = ( precio_base * tipos_iva.porcentaje / 100 ) + ( precio_base ), " + CRLF
   cSQL  += "manual = 1 " + CRLF

   cSQL  += "WHERE articulos_precios.uuid = uuid_precio_articulo; " + CRLF

   cSQL  += "END" + CRLF

RETURN ( cSQL )

//---------------------------------------------------------------------------//

METHOD dropFunctionUpdatePrecioIvaIncluidoWhereUuid() CLASS ArticulosPreciosRepository  

RETURN ( "DROP PROCEDURE IF EXISTS " + Company():getTableName( 'UpdatePrecioIvaIncluidoWhereUuid' ) + ";" )

//---------------------------------------------------------------------------//

METHOD callUpdatePrecioIvaIncluidoWhereUuid( uuidPrecioArticulo, precioIvaIncluido ) CLASS ArticulosPreciosRepository

RETURN ( getSQLDatabase():Exec( "CALL " + Company():getTableName( 'UpdatePrecioIvaIncluidoWhereUuid' ) + "( " + quoted( uuidPrecioArticulo ) + ", " + hb_ntos( precioIvaIncluido ) + " )" ) )

//---------------------------------------------------------------------------//

METHOD createFunctionUpdatePrecioIvaIncluidoWhereUuid() CLASS ArticulosPreciosRepository

   local cSQL

   cSQL  := "DELIMITER $$ " + CRLF

   cSQL  := "CREATE DEFINER=`root`@`localhost` PROCEDURE " + Company():getTableName( 'UpdatePrecioIvaIncluidoWhereUuid' ) + " ( IN `uuid_precio_articulo` CHAR(40), IN `precio_iva_incluido` FLOAT(16,6) ) " + CRLF
   cSQL  += "LANGUAGE SQL "+ CRLF
   cSQL  += "NOT DETERMINISTIC "+ CRLF
   cSQL  += "CONTAINS SQL "+ CRLF
   cSQL  += "SQL SECURITY DEFINER "+ CRLF
   cSQL  += "COMMENT '' "+ CRLF
   cSQL  += "BEGIN "+ CRLF

   cSQL  += "UPDATE " + ::getTableName() + " AS articulos_precios " + CRLF

   cSQL  += "INNER JOIN " + SQLArticulosModel():getTableName() + " AS articulos " + CRLF
   cSQL  +=    "ON articulos.uuid = articulos_precios.articulo_uuid " + CRLF

   cSQL  += "LEFT JOIN " + SQLTiposIvaModel():getTableName() + " AS tipos_iva " + CRLF
   cSQL  +=    "ON tipos_iva.codigo = articulos.tipo_iva_codigo " + CRLF

   cSQL  += "SET "

   cSQL  += "articulos_precios.precio_iva_incluido = precio_iva_incluido, " + CRLF
   cSQL  += "articulos_precios.precio_base = ( precio_iva_incluido / ( 1 + ( tipos_iva.porcentaje / 100 ) ) ), " + CRLF
   cSQL  += "manual = 1 " + CRLF

   cSQL  += "WHERE articulos_precios.uuid = uuid_precio_articulo; " + CRLF

   cSQL  += "END" + CRLF

RETURN ( cSQL )

//---------------------------------------------------------------------------//

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

