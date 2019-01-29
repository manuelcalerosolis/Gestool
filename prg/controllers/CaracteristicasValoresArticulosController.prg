#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS CaracteristicasValoresArticulosController FROM SQLNavigatorController

   DATA  uuidArticulo

   METHOD New()

   METHOD End()

   METHOD Edit( uuidArticulo )

   //Contrucciones tardias---------------------------------------------------//

   METHOD getDialogView()              INLINE( if( empty( ::oDialogView ), ::oDialogView := CaracteristicasValoresArticulosView():New( self ), ), ::oDialogView )
   
   METHOD getModel()                   INLINE( if( empty( ::oModel ), ::oModel := SQLCaracteristicasValoresArticulosModel():New( self ), ), ::oModel ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS CaracteristicasValoresArticulosController

   ::Super:New( oController ) 

   ::cTitle                            := "Características valores artículos"

   ::cName                             := "caracteristicas_valores_articulos"

   ::hImage                            := {  "16" => "gc_tags_16",;
                                             "32" => "gc_tags_32",;
                                             "48" => "gc_tags_48" }

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS CaracteristicasValoresArticulosController
   
   if !empty( ::oModel )
      ::oModel:End()
   end if

   if !empty( ::oDialogView )
      ::oDialogView:End()
   end if

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//

METHOD Edit( uuidArticulo ) CLASS CaracteristicasValoresArticulosController

   if empty( uuidArticulo )
      RETURN .f.
   end if 

   ::uuidArticulo             := uuidArticulo

   ::setEditMode()

   ::getModel():getSQLInsertCaracteristicaWhereArticulo()

   ::getRowSet():build( ::getModel():getSentenceRowSetValores() )

   ::beginTransactionalMode()

   if ::DialogViewActivate()
      
      ::commitTransactionalMode()

   else

      ::rollbackTransactionalMode()

   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS CaracteristicasValoresArticulosView FROM SQLBaseView

   DATA oBrowse

   DATA oColumnValores
   
   DATA oColumnPersonalizado

   METHOD Activate()
      METHOD startActivate() 

   METHOD ChangeBrowse()

   METHOD ChangeColValue( uNewValue )

   METHOD ChangeColSeleccionado( uNewValue )

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS CaracteristicasValoresArticulosView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "CARACTERISTICAS_VAL_ART" ;
      TITLE       "Valores de caracterísicas"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    "gc_tags_48" ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      PROMPT      "Características del artículo" ;
      ID          800 ;
      FONT        oFontBold() ; 
      OF          ::oDialog

   ::oBrowse                  := SQLXBrowse():New( ::oController, ::oDialog )
   ::oBrowse:l2007            := .f.

   ::oBrowse:lRecordSelector  := .t.
   ::oBrowse:lAutoSort        := .t.
   ::oBrowse:lSortDescend     := .f.  

   ::oBrowse:lFooter          := .f.
   ::oBrowse:lFastEdit        := .f.
   ::oBrowse:lMultiSelect     := .f.

   ::oBrowse:nMarqueeStyle    := MARQSTYLE_HIGHLROWRC

   ::oBrowse:bClrStd          := {|| { CLR_BLACK, CLR_WHITE } }
   ::oBrowse:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrowse:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 221, 221, 221 ) } }

   ::oBrowse:setRowSet( ::oController:getRowSet() )

   ::oBrowse:setName( "Valores características artículos" )

   ::oBrowse:bChange       := {|| ::ChangeBrowse() }

   ::oBrowse:CreateFromResource( 100 )

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Caracteristica'
      :nWidth              := 245
      :bEditValue          := {|| ::oController:getRowSet():fieldGet( 'nombre_caracteristica' ) }
   end with

   with object ( ::oColumnValores := ::oBrowse:AddCol() )
      :cHeader             := 'Valores'
      :nWidth              := 245
      :bEditValue          := {|| if( ::oController:getRowSet():fieldGet( 'personalizado' ) == .f., ::oController:getRowSet():fieldGet( 'nombre_valor' ),"" )  }
      :bOnPostEdit         := {| oCol, uNewValue, nKey | ::ChangeColValue( uNewValue ) }
   end with

   with object ( ::oColumnPersonalizado := ::oBrowse:AddCol() )
      :cHeader             := 'Personalizado'
      :nWidth              := 245
      :nEditType           := EDIT_GET
      :bEditValue          := {|| if( ::oController:getRowSet():fieldGet( 'personalizado' ) == .t., Padr( ::oController:getRowSet():fieldGet( 'nombre_valor' ), 200 ), Space( 200 ) ) }
      :bOnPostEdit         := {| oCol, uNewValue, nKey | ::ChangeColSeleccionado( uNewValue ) }
   end with

   ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )
   
   if ::oController:isNotZoomMode() 
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5 .and. validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }
   else
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, ::oDialog:end( IDOK ), ) }
   end if

   ::oDialog:bStart := {|| ::startActivate() }

   ACTIVATE DIALOG ::oDialog CENTER

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD startActivate() CLASS CaracteristicasValoresArticulosView

   ::oBrowse:SetFocus()

   ::changeBrowse()

   ::paintedActivate()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD ChangeBrowse() CLASS CaracteristicasValoresArticulosView

   local aValores    := SQLCaracteristicasLineasModel():getArrayNombreValoresFromUuid( ::oController:getRowSet():fieldGet( 'caracteristica_uuid' ) )

   if len( aValores ) > 0
      ::oColumnValores:nEditType     := EDIT_LISTBOX
      ::oColumnValores:aEditListTxt  := aValores
   else
      ::oColumnValores:nEditType     := 0
      ::oColumnValores:aEditListTxt  := {}
   end if

RETURN ( .t. ) 

//---------------------------------------------------------------------------//

METHOD ChangeColValue( uNewValue ) CLASS CaracteristicasValoresArticulosView

   ::oController:getModel():updateFieldWhereUuid( ::oController:getRowSet():fieldGet( 'uuid' ), "caracteristica_valor_uuid", SQLCaracteristicasLineasModel():getUuidWhereNombre( uNewValue ) )

   ::oController:getRowSet():Refresh()

   ::oBrowse:Refresh()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD ChangeColSeleccionado( uNewValue )

   local hBuffer

   if empty( uNewValue )
      RETURN ( .t. )
   end if

   /*
   Inserto en la tabla de valores
   */

   if empty( SQLCaracteristicasLineasModel():getUuidWhereNombre( uNewValue ) )

      hBuffer     := SQLCaracteristicasLineasModel():loadBlankBuffer()

      hset( hBuffer, "parent_uuid", ::oController:getRowSet():fieldGet( 'caracteristica_uuid' ) )
      hset( hBuffer, "nombre", AllTrim( uNewValue ) )
      hset( hBuffer, "personalizado", 1 )

      SQLCaracteristicasLineasModel():insertBuffer( hBuffer )

   end if

   ::ChangeColValue( uNewValue )

RETURN ( .t. )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLCaracteristicasValoresArticulosModel FROM SQLCompanyModel

   DATA cTableName               INIT "caracteristicas_valores_articulos" 

   DATA cConstraints             INIT "UNIQUE KEY ( articulo_uuid, caracteristica_uuid )"

   METHOD getColumns()

   METHOD getSQLInsertCaracteristicaWhereArticulo()

   METHOD getSentenceRowSetValores()

   METHOD caracteristicaUuidListFromUuidArticulo( uuidProduct )

   METHOD caracteristicaValuesUuidListFromUuidArticulo( uuidProduct ) 

   METHOD productCaracteristicaValuesUuidHashFromUuidArticulo( uuidProduct ) 

   #ifdef __TEST__

   METHOD testCreateCaracteristicaValor( uuidArticulo, uuidCaracteristica, uuidLinea )

   METHOD testCreateValorSinCaracteristica( uuidArticulo )

   METHOD testCreateValorSinArticulo( uuidCaracteristica, uuidLinea )

   METHOD testCreateSinValor( uuidArticulo, uuidCaracteristica )

   #endif

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLCaracteristicasValoresArticulosModel
   
   hset( ::hColumns, "id",                            {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                                         "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",                          {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;
                                                         "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "articulo_uuid",                 {  "create"    => "VARCHAR( 40 ) NOT NULL"                  ,;
                                                         "default"   => {|| Space( 40 ) } }                       )

   hset( ::hColumns, "caracteristica_uuid",           {  "create"    => "VARCHAR( 40 ) NOT NULL"                  ,;
                                                         "default"   => {|| Space( 40 ) } }                       )

   hset( ::hColumns, "caracteristica_valor_uuid",     {  "create"    => "VARCHAR( 40 ) NOT NULL"                  ,;
                                                         "default"   => {|| Space( 40 ) } }                       )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getSQLInsertCaracteristicaWhereArticulo() CLASS SQLCaracteristicasValoresArticulosModel

   local cSQL

   cSQL           := "INSERT IGNORE INTO " + ::getTableName()                                            + " "
   cSQL           +=    "( uuid, articulo_uuid, caracteristica_uuid )"                                   + " "
   cSQL           += "SELECT uuid(), " + quoted( ::oController:uuidArticulo ) + ", caracteristicas.uuid" + " "
   cSQL           +=    "FROM " + SQLCaracteristicasModel():getTableName() + " AS caracteristicas"       + " "
   cSQL           +=    "ORDER BY id"

RETURN ( getSQLDatabase():Exec( cSQL ) )

//---------------------------------------------------------------------------//

METHOD getSentenceRowSetValores() CLASS SQLCaracteristicasValoresArticulosModel

   local cSql

   TEXT INTO cSql

   SELECT caracteristicas_valores_articulos.uuid AS uuid,
      caracteristicas_valores_articulos.articulo_uuid AS articulo_uuid, 
      caracteristicas_valores_articulos.caracteristica_uuid AS caracteristica_uuid, 
      caracteristicas_valores_articulos.caracteristica_valor_uuid AS caracteristica_valor_uuid, 
      articulos_caracteristicas.nombre AS nombre_caracteristica, 
      articulos_caracteristicas_lineas.nombre AS nombre_valor, 
      articulos_caracteristicas_lineas.personalizado AS personalizado 

   FROM %1$s AS caracteristicas_valores_articulos
 
   INNER JOIN %2$s AS  articulos_caracteristicas
      ON articulos_caracteristicas.uuid = caracteristicas_valores_articulos.caracteristica_uuid AND articulos_caracteristicas.deleted_at = 0

   LEFT JOIN %3$s AS articulos_caracteristicas_lineas
      ON articulos_caracteristicas_lineas.uuid = caracteristicas_valores_articulos.caracteristica_valor_uuid 

   WHERE caracteristicas_valores_articulos.articulo_uuid = %4$s
      

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), SQLCaracteristicasModel():getTableName(), SQLCaracteristicasLineasModel():getTableName(), quoted( ::oController:uuidArticulo ) ) 

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD caracteristicaUuidListFromUuidArticulo( uuidProduct ) CLASS SQLCaracteristicasValoresArticulosModel

   local aIds     := {}
   local aResult
   local cSentence

   cSentence      := "SELECT caracteristica_uuid AS uuid "
   cSentence      += "FROM caracteristicas_valores_articulos "
   cSentence      += "WHERE articulo_uuid = " + quoted( uuidProduct )

   aResult     := ::getDatabase():selectFetchArray( cSentence )

   aeval( aResult, {|a| aadd( aIds, a[1] ) } )

RETURN ( aIds )

//---------------------------------------------------------------------------//

METHOD caracteristicaValuesUuidListFromUuidArticulo( uuidProduct ) CLASS SQLCaracteristicasValoresArticulosModel

   local aIds     := {}
   local aResult
   local cSentence

   cSentence      := "SELECT caracteristica_valor_uuid AS uuid "
   cSentence      += "FROM caracteristicas_valores_articulos "
   cSentence      += "WHERE articulo_uuid = " + quoted( uuidProduct )

   aResult     := ::getDatabase():selectFetchArray( cSentence )

   aeval( aResult, {|a| aadd( aIds, a[1] ) } )

RETURN ( aIds )

//---------------------------------------------------------------------------//

METHOD productCaracteristicaValuesUuidHashFromUuidArticulo( uuidProduct ) CLASS SQLCaracteristicasValoresArticulosModel

   local cSentence

   cSentence      := "SELECT caracteristica_uuid AS caracteristica, caracteristica_valor_uuid AS valor "
   cSentence      += "FROM caracteristicas_valores_articulos "
   cSentence      += "WHERE articulo_uuid = " + quoted( uuidProduct )

RETURN ( ::getDatabase():selectFetchHash( cSentence ) )

//---------------------------------------------------------------------------//

#ifdef __TEST__

METHOD testCreateCaracteristicaValor( uuidArticulo, uuidCaracteristica, uuidLinea ) CLASS SQLCaracteristicasValoresArticulosModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "articulo_uuid", uuidArticulo )
   hset( hBuffer, "caracteristica_uuid", uuidCaracteristica )
   hset( hBuffer, "caracteristica_valor_uuid", uuidLinea )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD testCreateValorSinCaracteristica( uuidArticulo ) CLASS SQLCaracteristicasValoresArticulosModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "articulo_uuid", uuidArticulo )
   hset( hBuffer, "caracteristica_uuid",  )
   hset( hBuffer, "caracteristica_valor_uuid",  )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD testCreateValorSinArticulo( uuidCaracteristica, uuidLinea ) CLASS SQLCaracteristicasValoresArticulosModel

local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "articulo_uuid", )
   hset( hBuffer, "caracteristica_uuid", uuidCaracteristica )
   hset( hBuffer, "caracteristica_valor_uuid", uuidLinea )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD testCreateSinValor( uuidArticulo, uuidCaracteristica ) CLASS SQLCaracteristicasValoresArticulosModel

local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "articulo_uuid", uuidArticulo )
   hset( hBuffer, "caracteristica_uuid", uuidCaracteristica )
   hset( hBuffer, "caracteristica_valor_uuid", )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TestCaracteristicasValoresArticulosController FROM TestCase

   METHOD testCreateValor()

   METHOD testCreateSinCaracteristica()

   METHOD testCreateSinArticulo()

   METHOD testCreateSinValor()

   METHOD testCreatePersonlizado()

   METHOD testCreateCaracteristicaCombo()

   METHOD testCreateComboCambio()

   METHOD testCreatePersonalizadoCambio()

END CLASS

//---------------------------------------------------------------------------//

METHOD testCreateValor() CLASS TestCaracteristicasValoresArticulosController

   local uuidCaracteristica   := win_uuidcreatestring()
   local uuidArticulo         := win_uuidcreatestring()
   local uuidLinea            := win_uuidcreatestring()

   SQLArticulosModel():truncateTable()
   SQLCaracteristicasModel():truncateTable() 
   SQLCaracteristicasLineasModel():truncateTable()
   SQLCaracteristicasValoresArticulosModel():truncateTable()

   ::Assert():notEquals( SQLCaracteristicasModel():testCreateCaracteristica( uuidCaracteristica ), 0, "test create caracteristica" )
   
   ::Assert():notEquals( SQLCaracteristicasLineasModel():testCreateCaracteristicaLineaConUuidAndParent( uuidLinea, uuidCaracteristica ), 0, "test create linea" )

   ::Assert():notEquals( SQLArticulosModel():test_create_con_uuid( uuidArticulo ), 0, "test articulo" )

   ::Assert():notEquals( SQLCaracteristicasValoresArticulosModel():testCreateCaracteristicaValor( uuidArticulo, uuidCaracteristica, uuidLinea ), 0, "test caracteristica valor" )

RETURN ( nil ) 

//---------------------------------------------------------------------------//

METHOD testCreateSinCaracteristica() CLASS TestCaracteristicasValoresArticulosController

   local uuidArticulo         := win_uuidcreatestring()
   local uuidLinea            := win_uuidcreatestring()

   SQLArticulosModel():truncateTable()
   SQLCaracteristicasModel():truncateTable() 
   SQLCaracteristicasLineasModel():truncateTable()
   SQLCaracteristicasValoresArticulosModel():truncateTable()

   ::Assert():notEquals( SQLArticulosModel():test_create_con_uuid( uuidArticulo ), 0, "test articulo" )

   ::Assert():notEquals( SQLCaracteristicasValoresArticulosModel():testCreateValorSinCaracteristica( uuidArticulo ), 1, "test caracteristica valor" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testCreateSinArticulo() CLASS TestCaracteristicasValoresArticulosController

   local uuidCaracteristica   := win_uuidcreatestring()
   local uuidLinea            := win_uuidcreatestring()

   SQLArticulosModel():truncateTable()
   SQLCaracteristicasModel():truncateTable() 
   SQLCaracteristicasLineasModel():truncateTable()
   SQLCaracteristicasValoresArticulosModel():truncateTable()

   ::Assert():notEquals( SQLCaracteristicasModel():testCreateCaracteristica( uuidCaracteristica ), 0, "test create caracteristica" )
   
   ::Assert():notEquals( SQLCaracteristicasLineasModel():testCreateCaracteristicaLineaConUuidAndParent( uuidLinea, uuidCaracteristica ), 0, "test create linea" )

   ::Assert():notEquals( SQLCaracteristicasValoresArticulosModel():testCreateValorSinArticulo( uuidCaracteristica, uuidLinea ), 1, "test caracteristica valor" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testCreateSinValor() CLASS TestCaracteristicasValoresArticulosController
   
   local uuidCaracteristica   := win_uuidcreatestring()
   local uuidArticulo         := win_uuidcreatestring()

   SQLArticulosModel():truncateTable()
   SQLCaracteristicasModel():truncateTable() 
   SQLCaracteristicasLineasModel():truncateTable()
   SQLCaracteristicasValoresArticulosModel():truncateTable()

   ::Assert():notEquals( SQLCaracteristicasModel():testCreateCaracteristica( uuidCaracteristica ), 0, "test create caracteristica" )

   ::Assert():notEquals( SQLCaracteristicasValoresArticulosModel():testCreateSinValor( uuidArticulo, uuidCaracteristica ), 1, "test caracteristica valor" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testCreatePersonlizado() CLASS TestCaracteristicasValoresArticulosController

   local oController

   local uuidCaracteristica   := win_uuidcreatestring()
   local uuidArticulo         := win_uuidcreatestring()
   local uuidLinea            := win_uuidcreatestring()

   SQLArticulosModel():truncateTable()
   SQLCaracteristicasModel():truncateTable() 
   SQLCaracteristicasLineasModel():truncateTable()
   SQLCaracteristicasValoresArticulosModel():truncateTable()

   ::Assert():notEquals( SQLCaracteristicasModel():testCreateCaracteristica( uuidCaracteristica ), 0, "test create caracteristica" )
   
   ::Assert():notEquals( SQLCaracteristicasLineasModel():testCreateCaracteristicaLineaConUuidAndParent( uuidLinea, uuidCaracteristica ), 0, "test create linea" )

   ::Assert():notEquals( SQLArticulosModel():test_create_con_uuid( uuidArticulo ), 0, "test articulo" )

   oController             := CaracteristicasValoresArticulosController():New()

   oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         testWaitSeconds( 1 ),;
         eval( oController:getDialogView():oColumnPersonalizado:bOnPostEdit, , "Personalizado" ),;
         testWaitSeconds( 3 ),;
         self:getControl( IDOK ):Click() } ) 
          
   ::Assert():true( oController:Edit( uuidArticulo ), "test ::Assert():true with .t." )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testCreateCaracteristicaCombo() CLASS TestCaracteristicasValoresArticulosController

   local oController

   local uuidCaracteristica   := win_uuidcreatestring()
   local uuidArticulo         := win_uuidcreatestring()
   local uuidLinea            := win_uuidcreatestring()

   SQLArticulosModel():truncateTable()
   SQLCaracteristicasModel():truncateTable() 
   SQLCaracteristicasLineasModel():truncateTable()
   SQLCaracteristicasValoresArticulosModel():truncateTable()

   ::Assert():notEquals( SQLCaracteristicasModel():testCreateCaracteristica( uuidCaracteristica ), 0, "test create caracteristica" )
   
   ::Assert():notEquals( SQLCaracteristicasLineasModel():testCreateCaracteristicaLineaConUuidAndParent( uuidLinea, uuidCaracteristica ), 0, "test create linea" )

   ::Assert():notEquals( SQLArticulosModel():test_create_con_uuid( uuidArticulo ), 0, "test articulo" )

   oController             := CaracteristicasValoresArticulosController():New()

   oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         testWaitSeconds( 1 ),;
         eval( oController:getDialogView():oColumnValores:bOnPostEdit, , "linea 1" ),;
         testWaitSeconds( 3 ),;
         self:getControl( IDOK ):Click() } ) 
          
   ::Assert():true( oController:Edit( uuidArticulo ), "test ::Assert():true with .t." )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testCreateComboCambio() CLASS TestCaracteristicasValoresArticulosController

   local oController

   local uuidCaracteristica   := win_uuidcreatestring()
   local uuidArticulo         := win_uuidcreatestring()
   local uuidLinea            := win_uuidcreatestring()

   SQLArticulosModel():truncateTable()
   SQLCaracteristicasModel():truncateTable() 
   SQLCaracteristicasLineasModel():truncateTable()
   SQLCaracteristicasValoresArticulosModel():truncateTable()

   ::Assert():notEquals( SQLCaracteristicasModel():testCreateCaracteristica( uuidCaracteristica ), 0, "test create caracteristica" )
   
   ::Assert():notEquals( SQLCaracteristicasLineasModel():testCreateCaracteristicaLineaConUuidAndParent( uuidLinea, uuidCaracteristica ), 0, "test create linea" )

   ::Assert():notEquals( SQLArticulosModel():test_create_con_uuid( uuidArticulo ), 0, "test articulo" )

   oController             := CaracteristicasValoresArticulosController():New()

   oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         testWaitSeconds( 1 ),;
         eval( oController:getDialogView():oColumnValores:bOnPostEdit, , "linea 1" ),;
         testWaitSeconds( 3 ),;
         eval( oController:getDialogView():oColumnPersonalizado:bOnPostEdit, , "Personalizado" ),;
         testWaitSeconds( 3 ),;
         self:getControl( IDOK ):Click() } ) 
          
   ::Assert():true( oController:Edit( uuidArticulo ), "test ::Assert():true with .t." )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testCreatePersonalizadoCambio() CLASS TestCaracteristicasValoresArticulosController

   local oController

   local uuidCaracteristica   := win_uuidcreatestring()
   local uuidArticulo         := win_uuidcreatestring()
   local uuidLinea            := win_uuidcreatestring()

   SQLArticulosModel():truncateTable()
   SQLCaracteristicasModel():truncateTable() 
   SQLCaracteristicasLineasModel():truncateTable()
   SQLCaracteristicasValoresArticulosModel():truncateTable()

   ::Assert():notEquals( SQLCaracteristicasModel():testCreateCaracteristica( uuidCaracteristica ), 0, "test create caracteristica" )
   
   ::Assert():notEquals( SQLCaracteristicasLineasModel():testCreateCaracteristicaLineaConUuidAndParent( uuidLinea, uuidCaracteristica ), 0, "test create linea" )

   ::Assert():notEquals( SQLArticulosModel():test_create_con_uuid( uuidArticulo ), 0, "test articulo" )

   oController             := CaracteristicasValoresArticulosController():New()

   oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         testWaitSeconds( 1 ),;
         eval( oController:getDialogView():oColumnPersonalizado:bOnPostEdit, , "Personalizado" ),;
         testWaitSeconds( 3 ),;
         eval( oController:getDialogView():oColumnValores:bOnPostEdit, , "linea 1" ),;
         testWaitSeconds( 3 ),;
         self:getControl( IDOK ):Click() } ) 
          
   ::Assert():true( oController:Edit( uuidArticulo ), "test ::Assert():true with .t." )

RETURN ( nil )

#endif

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//