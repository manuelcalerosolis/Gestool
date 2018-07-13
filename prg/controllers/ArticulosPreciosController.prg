#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ArticulosPreciosController FROM SQLBrowseController

   METHOD New()

   METHOD End()

   METHOD setPrecioBase( oCol, nPrecioBase )
   
   METHOD setPrecioIVAIncluido( oCol, nPrecioIVAIncluido )

   METHOD setManual( oCol, lManual )

   METHOD UpdatePreciosAndRefresh() 

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

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD UpdatePreciosAndRefresh() 

   ::oRepository:callUpdatePreciosWhereUuidArticulo( ::getRowSet():fieldGet( 'articulo_uuid' ) )

   ::getRowSet():Refresh()

   ::getBrowseView():Refresh() 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD setPrecioBase( oCol, nPrecioBase ) CLASS ArticulosPreciosController

   ::oRepository:callUpdatePrecioBaseWhereUuid( ::getRowSet():fieldGet( 'uuid' ), nPrecioBase )

RETURN ( ::UpdatePreciosAndRefresh() )

//---------------------------------------------------------------------------//

METHOD setPrecioIVAIncluido( oCol, nPrecioIVAIncluido ) CLASS ArticulosPreciosController

   ::oRepository:callUpdatePrecioIvaIncluidoWhereUuid( ::getRowSet():fieldGet( 'uuid' ), nPrecioIVAIncluido )

RETURN ( ::UpdatePreciosAndRefresh() )

//---------------------------------------------------------------------------//

METHOD setManual( oCol, lManual ) CLASS ArticulosPreciosController

   ::oModel:updateFieldWhereUuid( ::getRowSet():fieldGet( 'uuid' ), "manual", lManual )

RETURN ( ::UpdatePreciosAndRefresh() )

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
      :nDataStrAlign       := 1
      :nHeadStrAlign       := 1
      :bEditValue          := {|| ::getRowSet():fieldGet( 'margen' ) }
      :bEditBlock          := {|| ::getRowSet():fieldGet( 'margen' ) }
      :cEditPicture        := "@E 9999.9999"
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
      :bEditBlock          := {|| msgalert( "manual" ) }
      :nWidth              := 60
      :SetCheck( { "Sel16", "Nil16" }, {|oCol, lManual| ::oController:setManual( oCol, lManual ) } )
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

   METHOD getSQLInsertPrecioWhereTarifa( uuidTarifa )

   METHOD insertPrecioWhereTarifa( uuidTarifa ) ;
                                    INLINE ( ::getDatabase():Exec( ::getSQLInsertPrecioWhereTarifa( uuidTarifa ) ) )

   METHOD getSQLUpdatePrecioWhereTarifa( uuidTarifa, lCosto )

   METHOD updatePrecioWhereTarifa( uuidTarifa ) ;
                                    INLINE ( ::getDatabase():Exec( ::getSQLUpdatePrecioWhereTarifa( uuidTarifa ) ) )

   METHOD updatePrecioWhereArticulo( uuidArticulo ) ;
                                    INLINE ( ::getDatabase():Exec( ::getSQLUpdatePrecioWhereArticulo( uuidArticulo ) ) )

   METHOD getSQLUpdatePrecioWhereArticulo( uuidArticulo ) 

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

   cSelect        +=    "IF( articulos_tarifas_base.nombre IS NULL OR articulos_precios.manual = 1, 'Costo', articulos_tarifas_base.nombre ) AS articulos_tarifas_base_nombre "  

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

   TEXT INTO cSql

   INSERT IGNORE INTO %2$s 
      (  uuid,
         articulo_uuid,
         tarifa_uuid,
         margen,
         precio_base,
         precio_iva_incluido )
      SELECT 
         UUID(),
         articulos.uuid,
         %1$s,
         articulos_tarifas.margen,
         @precioBase :=             
         ( ( @precioSobre :=                
            IF( articulos_tarifas.parent_uuid = '', articulos.precio_costo, articulos_precios_parent.precio_base )                
            * articulos_tarifas.margen / 100 ) + @precioSobre ),
         @precioIVA := ( ( @precioBase * tipos_iva.porcentaje / 100 ) + @precioBase )
      FROM %3$s AS articulos

      LEFT JOIN %2$s AS articulos_precios_parent 
         ON articulos_precios_parent.articulo_uuid = articulos.uuid 
         AND articulos_precios_parent.tarifa_uuid = articulos_tarifas.uuid

      INNER JOIN %4$s AS articulos_tarifas  
         ON articulos_tarifas.uuid = %1$s

      LEFT JOIN %5$s AS tipos_iva
         ON tipos_iva.codigo = articulos.tipo_iva_codigo

   ENDTEXT

   cSql  := hb_strformat( cSql, quoted( uuidTarifa ), ::getTableName(), SQLArticulosModel():getTableName(), SQLArticulosTarifasModel():getTableName(), SQLTiposIvaModel():getTableName() )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getSQLUpdatePrecioWhereTarifa( uuidTarifa ) CLASS SQLArticulosPreciosModel

   local cSQL

   TEXT INTO cSql
   
   UPDATE %2$s AS articulos_precios

      INNER JOIN %4$s AS articulos_tarifas  
         ON articulos_tarifas.uuid = %1$s

      LEFT JOIN %2$s AS articulos_precios_parent 
         ON articulos_precios_parent.tarifa_uuid = articulos_tarifas.parent_uuid
         AND articulos_precios_parent.articulo_uuid = articulos_precios.articulo_uuid

      LEFT JOIN %3$s AS articulos 
        ON articulos.uuid = articulos_precios.articulo_uuid 

      LEFT JOIN %5$s AS tipos_iva
         ON tipos_iva.codigo = articulos.tipo_iva_codigo

      SET 
         articulos_precios.margen = articulos_tarifas.margen, 

         articulos_precios.precio_base = 
            @precioBase :=             
            ( ( @precioSobre :=                
               IF( articulos_tarifas.parent_uuid = '', articulos.precio_costo, articulos_precios_parent.precio_base )                
               * articulos_tarifas.margen / 100 ) + @precioSobre ),

         articulos_precios.precio_iva_incluido = ( ( @precioBase * tipos_iva.porcentaje / 100 ) + @precioBase )

      WHERE 
         (  articulos_precios.manual IS NULL OR articulos_precios.manual != 1 )
            AND articulos_precios.tarifa_uuid = %1$s 

   ENDTEXT

   cSql  := hb_strformat( cSql, quoted( uuidTarifa ), ::getTableName(), SQLArticulosModel():getTableName(), SQLArticulosTarifasModel():getTableName(), SQLTiposIvaModel():getTableName() )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getSQLUpdatePrecioWhereArticulo( uuidArticulo ) CLASS SQLArticulosPreciosModel

   local cSQL

   TEXT INTO cSql
   
   UPDATE %2$s AS articulos_precios

      INNER JOIN %4$s AS articulos_tarifas  
         ON articulos_tarifas.uuid = articulos_precios.tarifa_uuid

      LEFT JOIN %2$s AS articulos_precios_parent 
         ON articulos_precios_parent.tarifa_uuid = articulos_tarifas.parent_uuid
         AND articulos_precios_parent.articulo_uuid = articulos_precios.articulo_uuid

      LEFT JOIN %3$s AS articulos 
        ON articulos.uuid = articulos_precios.articulo_uuid 

      LEFT JOIN %5$s AS tipos_iva
         ON tipos_iva.codigo = articulos.tipo_iva_codigo

      SET 
         articulos_precios.margen = articulos_tarifas.margen, 

         articulos_precios.precio_base = 
            ( ( @precioSobre :=                
               IF( articulos_tarifas.parent_uuid = '',
                  articulos.precio_costo,
                  articulos_precios_parent.precio_base ) )               
               * articulos_tarifas.margen / 100 ) + @precioSobre, 

         articulos_precios.precio_iva_incluido = 
            ( @precioBase * tipos_iva.porcentaje / 100 ) + @precioBase

      WHERE 
         (  articulos_precios.manual IS NULL OR articulos_precios.manual != 1 )
            AND articulos_precios.articulo_uuid = %1$s 

   ENDTEXT

   cSql  := hb_strformat( cSql, quoted( uuidArticulo ), ::getTableName(), SQLArticulosModel():getTableName(), SQLArticulosTarifasModel():getTableName(), SQLTiposIvaModel():getTableName() )

   logwrite( cSql )
   msgalert( cSql, "cSql" )

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
                                                      ::createFunctionUpdatePrecioIvaIncluidoWhereUuid(),;
                                                      ::dropFunctionUpdatePrecioWhereIdPrecio(),;
                                                      ::createFunctionUpdatePrecioWhereIdPrecio(),;
                                                      ::dropFunctionUpdatePreciosWhereUuidArticulo(),;
                                                      ::createFunctionUpdatePreciosWhereUuidArticulo() } )

   METHOD dropFunctionUpdatePrecioBaseWhereUuid()  

   METHOD createFunctionUpdatePrecioBaseWhereUuid()

   METHOD callUpdatePrecioBaseWhereUuid( uuidPrecioArticulo, precioBase )

   METHOD dropFunctionUpdatePrecioIvaIncluidoWhereUuid()

   METHOD callUpdatePrecioIvaIncluidoWhereUuid( uuidPrecioArticulo, precioIvaIncluido ) 

   METHOD createFunctionUpdatePrecioIvaIncluidoWhereUuid()   

   METHOD dropFunctionUpdatePrecioWhereIdPrecio()
   
   METHOD callUpdatePrecioWhereIdPrecio( idPrecioArticulo )
   
   METHOD createFunctionUpdatePrecioWhereIdPrecio()

   METHOD dropFunctionUpdatePreciosWhereUuidArticulo()

   METHOD callUpdatePreciosWhereUuidArticulo( idPrecio )

   METHOD createFunctionUpdatePreciosWhereUuidArticulo()   

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
   cSQL  += "margen = ( articulos_precios.precio_base - articulos.precio_costo ) / precio_costo * 100, " + CRLF
   cSQL  += "margen_real = ( articulos_precios.precio_base - articulos.precio_costo ) / precio_base * 100, " + CRLF
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
   cSQL  += "margen = ( articulos_precios.precio_base - articulos.precio_costo ) / precio_costo * 100, " + CRLF
   cSQL  += "margen_real = ( articulos_precios.precio_base - articulos.precio_costo ) / precio_base * 100, " + CRLF
   cSQL  += "manual = 1 " + CRLF

   cSQL  += "WHERE articulos_precios.uuid = uuid_precio_articulo; " + CRLF

   cSQL  += "END" + CRLF

RETURN ( cSQL )

//---------------------------------------------------------------------------//

METHOD dropFunctionUpdatePrecioWhereIdPrecio() CLASS ArticulosPreciosRepository  

RETURN ( "DROP PROCEDURE IF EXISTS " + Company():getTableName( 'UpdatePrecioWhereIdPrecio' ) + ";" )

//---------------------------------------------------------------------------//

METHOD callUpdatePrecioWhereIdPrecio( idPrecio ) CLASS ArticulosPreciosRepository

RETURN ( getSQLDatabase():Exec( "CALL " + Company():getTableName( 'UpdatePrecioWhereIdPrecio' ) + "( " + quoted( idPrecio ) + " )" ) )

//---------------------------------------------------------------------------//

METHOD createFunctionUpdatePrecioWhereIdPrecio() CLASS ArticulosPreciosRepository

   local cSQL

   cSQL  := "CREATE DEFINER=`root`@`localhost` PROCEDURE " + Company():getTableName( 'UpdatePrecioWhereIdPrecio' ) + " ( IN `id_articulo_precio` INT ) " + CRLF
   cSQL  += "LANGUAGE SQL "+ CRLF
   cSQL  += "NOT DETERMINISTIC "+ CRLF
   cSQL  += "CONTAINS SQL "+ CRLF
   cSQL  += "SQL SECURITY DEFINER "+ CRLF
   cSQL  += "COMMENT '' "+ CRLF
   cSQL  += "BEGIN "+ CRLF

   cSQL  += "DECLARE margen FLOAT;" + CRLF
   cSQL  += "DECLARE margen_real FLOAT;" + CRLF
   cSQL  += "DECLARE precio_costo FLOAT;" + CRLF
   cSQL  += "DECLARE porcentaje_iva FLOAT;" + CRLF
   cSQL  += "DECLARE precio_base FLOAT;" + CRLF
   cSQL  += "DECLARE precio_iva_incluido FLOAT;" + CRLF

   cSQL  += "SELECT " + CRLF
   cSQL  += "articulos_tarifas.margen, " + CRLF
   cSQL  += "IF( articulos_tarifas.parent_uuid = '', articulos.precio_costo, articulos_precios_parent.precio_base )," + CRLF
   cSQL  += "tipos_iva.porcentaje" + CRLF

   cSQL  += "INTO " + CRLF
   cSQL  += "margen, " + CRLF
   cSQL  += "precio_costo, " + CRLF
   cSQL  += "porcentaje_iva " + CRLF

   cSQL  += "FROM " + ::getTableName() + " AS articulos_precios " + CRLF  

   cSQL  += "INNER JOIN " + SQLArticulosTarifasModel():getTableName() + " AS articulos_tarifas " + CRLF + ;
               "ON articulos_tarifas.uuid = articulos_precios.tarifa_uuid " + CRLF

   cSQL  += "LEFT JOIN " + SQLArticulosModel():getTableName() + " AS articulos " + CRLF 
   cSQL  +=    "ON articulos.uuid = articulos_precios.articulo_uuid " + CRLF

   cSQL  += "LEFT JOIN " + SQLTiposIvaModel():getTableName() + " AS tipos_iva " + CRLF
   cSQL  +=    "ON tipos_iva.codigo = articulos.tipo_iva_codigo " + CRLF

   cSQL  += "LEFT JOIN " + ::getTableName() + " AS articulos_precios_parent " + CRLF    
   cSQL  +=    "ON articulos_precios_parent.tarifa_uuid = articulos_tarifas.parent_uuid " + CRLF
   cSQL  +=    "AND articulos_precios_parent.articulo_uuid = articulos_precios.articulo_uuid " + CRLF

   cSQL  += "WHERE " + CRLF
   cSQL  +=    "( articulos_precios.manual IS NULL OR articulos_precios.manual != 1 ) " + CRLF
   cSQL  +=    "AND articulos_precios.id = id_articulo_precio; " + CRLF

   cSQL  += "SET precio_base = ( precio_costo * margen / 100 ) + ( precio_costo );" + CRLF
   cSQL  += "SET precio_iva_incluido = ( precio_base * porcentaje_iva / 100 ) + ( precio_base );" + CRLF
   cSQL  += "SET margen_real = ( ( precio_base - precio_costo ) / precio_base * 100 );" + CRLF

   cSQL  += "UPDATE " + ::getTableName() + " AS articulos_precios " + CRLF  

   cSQL  += "SET " + CRLF

   cSQL  += "articulos_precios.margen = margen, " + CRLF
   cSQL  += "articulos_precios.margen_real = margen_real, " + CRLF
   cSQL  += "articulos_precios.precio_base = precio_base, " + CRLF
   cSQL  += "articulos_precios.precio_iva_incluido = precio_iva_incluido " + CRLF

   cSQL  += "WHERE " + CRLF
   cSQL  +=    "( articulos_precios.manual IS NULL OR articulos_precios.manual != 1 ) " + CRLF
   cSQL  +=    "AND articulos_precios.id = id_articulo_precio; " + CRLF

   cSQL  += "END" + CRLF

RETURN ( cSQL )

//---------------------------------------------------------------------------//

METHOD dropFunctionUpdatePreciosWhereUuidArticulo() CLASS ArticulosPreciosRepository  

RETURN ( "DROP PROCEDURE IF EXISTS " + Company():getTableName( 'UpdatePreciosWhereUuidArticulo' ) + ";" )

//---------------------------------------------------------------------------//

METHOD callUpdatePreciosWhereUuidArticulo( uuidArticulo ) CLASS ArticulosPreciosRepository

RETURN ( getSQLDatabase():Exec( "CALL " + Company():getTableName( 'UpdatePreciosWhereUuidArticulo' ) + "( " + quoted( uuidArticulo ) + " )" ) )

//---------------------------------------------------------------------------//

METHOD createFunctionUpdatePreciosWhereUuidArticulo() CLASS ArticulosPreciosRepository

   local cSql

   TEXT INTO cSql
      CREATE DEFINER = `root`@`localhost` PROCEDURE %1$s ( IN `uuid_articulo_precio` CHAR(40) ) 
      
      LANGUAGE SQL
      NOT DETERMINISTIC
      CONTAINS SQL
      SQL SECURITY DEFINER
      COMMENT ''

      BEGIN

      DECLARE done INT DEFAULT FALSE;
      DECLARE id_articulo_precio INT;

      DECLARE cursor_articulo CURSOR FOR
      SELECT id
         FROM %3$s AS articulos_precios 
         WHERE articulos_precios.articulo_uuid = uuid_articulo_precio   
         ORDER BY articulos_precios.id;

      DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

      OPEN cursor_articulo;

      read_loop: LOOP 
      FETCH cursor_articulo INTO id_articulo_precio;

         IF done THEN
            LEAVE read_loop;
         END IF;

         CALL %2$s( id_articulo_precio );

      END LOOP;

      CLOSE cursor_articulo;

   END

   ENDTEXT

   cSql  := hb_strformat( cSql, Company():getTableName( 'UpdatePreciosWhereUuidArticulo' ), Company():getTableName( 'UpdatePrecioWhereIdPrecio' ), ::getTableName() )

RETURN ( cSql )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

