#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS CombinacionesPropiedadesController FROM SQLNavigatorController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD insertProperties( aCombination, uuidParent ) ;
                                       INLINE ( ::getModel():insertProperties( aCombination, uuidParent ) )

   //Construcciones tardias----------------------------------------------------
   
   METHOD getModel()                   INLINE ( iif( empty( ::oModel ), ::oModel := SQLCombinacionesPropiedadesModel():New( self ), ), ::oModel )  

   METHOD getBrowseView()              INLINE ( iif( empty( ::oBrowseView ), ::oBrowseView := CombinacionesPropiedadesBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()              INLINE ( iif( empty( ::oDialogView ), ::oDialogView := CombinacionesPropiedadesView():New( self ), ), ::oDialogView )

   METHOD getRepository()              INLINE ( iif( empty( ::oRepository ), ::oRepository := CombinacionesPropiedadesRepository():New( self ), ), ::oRepository )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS CombinacionesPropiedadesController

   ::Super:New( oController )

   ::cTitle                            := "Combinaciones de Propiedades"

   ::cName                             := "combinaciones_propiedades"

   ::hImage                            := {  "16" => "gc_cash_register_refresh_16",;
                                             "32" => "gc_cash_register_refresh_32",;
                                             "48" => "gc_cash_register_refresh_48" }

   ::nLevel                            := Auth():Level( ::cName )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS CombinacionesPropiedadesController

   if !empty( ::oModel )
      ::oModel:End()
   end if 

   if !empty( ::oBrowseView )
      ::oBrowseView:End()
   end if

   if !empty( ::oDialogView )
      ::oDialogView:End()
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

CLASS CombinacionesPropiedadesBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS CombinacionesPropiedadesBrowseView

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
      :cSortOrder          := 'parent_uuid'
      :cHeader             := 'Artículo'
      :nWidth              := 120
      :bEditValue          := {|| ::getRowSet():fieldGet( 'parent_uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'propiedad_uuid'
      :cHeader             := 'Valor propiedad'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'propiedad_uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS CombinacionesPropiedadesView FROM SQLBaseView
  
   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS CombinacionesPropiedadesView

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS CombinacionesPropiedadesValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS CombinacionesPropiedadesValidator

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLCombinacionesPropiedadesModel FROM SQLCompanyModel

   DATA cTableName                     INIT "combinaciones_propiedades"

   DATA cConstraints                   INIT "FOREIGN KEY (parent_uuid) REFERENCES " + SQLCombinacionesModel():getTableName() + " (uuid) ON DELETE CASCADE"

   METHOD getColumns()

   METHOD getPropertyWhereArticuloCodigo( cCodigoArticulo, cHaving )   

   METHOD getPropertyWhereArticuloHaving( cCodigoArticulo, cHaving )
   
   METHOD getPropertyWhereArticuloCombinacion( cCodigoArticulo, cTextoCombinacion )

   METHOD selectPropertyWhereArticuloCombinacion( cCodigoArticulo, cTextoCombinacion ) 

   METHOD insertProperties( aCombination, uuidParent ) 

   METHOD insertProperty( uuidCombination, uuidParent )

   METHOD getUuidOlderParent()         INLINE ( ::olderUuid )

#ifdef __TEST__

   METHOD test_insert_property( uuidCombination, uuidParent )

#endif

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLCombinacionesPropiedadesModel

   hset( ::hColumns, "id",                   {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"              ,;                          
                                                "default"   => {|| 0 } }                                    )

   hset( ::hColumns, "uuid",                 {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"              ,;                                  
                                                "default"   => {|| win_uuidcreatestring() } }               )

   hset( ::hColumns, "parent_uuid",          {  "create"    => "VARCHAR( 40 )"                              ,;
                                                "default"   => {|| space( 40 ) } }                          )

   hset( ::hColumns, "propiedad_uuid",       {  "create"    => "VARCHAR( 40 )"                              ,;
                                                "default"   => { || space ( 40 )  } }                       )

   ::getDeletedStampColumn() 

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getPropertyWhereArticuloCodigo( cCodigoArticulo ) CLASS SQLCombinacionesPropiedadesModel

   local cSql

   TEXT INTO cSql

   SELECT  
      combinaciones.id AS id,
      combinaciones.uuid AS uuid,
      combinaciones.parent_uuid AS parent_uuid,
      combinaciones.incremento_precio AS incremento_precio,
      TRIM( GROUP_CONCAT( " ", articulos_propiedades_lineas.nombre ORDER BY combinaciones_propiedades.id ) ) AS articulos_propiedades_nombre

   FROM %1$s as combinaciones_propiedades

      INNER JOIN %4$s as articulos
         ON articulos.codigo = %5$s
      
      INNER JOIN %2$s as combinaciones
         ON combinaciones.parent_uuid = articulos.uuid
      
      INNER JOIN %3$s AS articulos_propiedades_lineas
         ON articulos_propiedades_lineas.uuid = combinaciones_propiedades.propiedad_uuid

      WHERE combinaciones_propiedades.parent_uuid = combinaciones.uuid
   
      GROUP BY combinaciones.uuid

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), SQLCombinacionesModel():getTableName(), SQLPropiedadesLineasModel():getTableName(), SQLArticulosModel():getTableName(), quoted( cCodigoArticulo ) )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getPropertyWhereArticuloCombinacion( cCodigoArticulo, cTextoCombinacion ) CLASS SQLCombinacionesPropiedadesModel

   local cSql

   cSql     := ::getPropertyWhereArticuloCodigo( cCodigoArticulo )

   cSql     += "HAVING articulos_propiedades_nombre LIKE " + quoted( cTextoCombinacion ) 

RETURN ( cSql )   

//---------------------------------------------------------------------------//

METHOD selectPropertyWhereArticuloCombinacion( cCodigoArticulo, cTextoCombinacion ) CLASS SQLCombinacionesPropiedadesModel

RETURN ( getSQLDatabase():selectTrimedFetchHash( ::getPropertyWhereArticuloCombinacion( cCodigoArticulo, cTextoCombinacion ) ) )  

//---------------------------------------------------------------------------//

METHOD getPropertyWhereArticuloHaving( cCodigoArticulo, cHaving ) CLASS SQLCombinacionesPropiedadesModel

   local cSql

   cSql     := ::getPropertyWhereArticuloCodigo( cCodigoArticulo )

   if !empty( cHaving )
      cSql  += "HAVING " + cHaving
   end if 

RETURN ( cSql )   

//---------------------------------------------------------------------------//

METHOD insertProperties( aCombination, uuidParent ) CLASS SQLCombinacionesPropiedadesModel

RETURN ( aeval( aCombination, {|hCombination| ::insertProperty( hget( hCombination, "propiedad_uuid" ), uuidParent ) } ) ) 

//---------------------------------------------------------------------------//

METHOD insertProperty( uuidProperty, uuidParent ) CLASS SQLCombinacionesPropiedadesModel

   local hBuffer     := ::loadBlankBuffer( { "propiedad_uuid"  => uuidProperty,;
                                             "parent_uuid"     => uuidParent  } )
   
RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

#ifdef __TEST__

METHOD test_insert_property( uuidProperty, uuidParent ) CLASS SQLCombinacionesPropiedadesModel

   local hBuffer  := ::loadBlankBuffer( { "propiedad_uuid"  => uuidProperty,;
                                          "parent_uuid"     => uuidParent } )

RETURN ( ::insertBuffer( hBuffer ) )

#endif

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS CombinacionesPropiedadesRepository FROM SQLBaseRepository

   METHOD getTableName()               INLINE ( SQLCombinacionesPropiedadesModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
