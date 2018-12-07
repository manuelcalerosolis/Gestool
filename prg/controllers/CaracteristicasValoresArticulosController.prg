#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS CaracteristicasValoresArticulosController FROM SQLBrowseController

   DATA  uuidArticulo

   METHOD New()

   METHOD End()

   METHOD Activate( uuidArticulo )

   //Contrucciones tardias---------------------------------------------------//

   METHOD getDialogView()              INLINE( if( empty( ::oDialogView ), ::oDialogView := CaracteristicasValoresArticulosView():New( self ), ), ::oDialogView )
   
   METHOD getModel()                   INLINE( if( empty( ::oModel ), ::oModel := SQLCaracteristicasValoresArticulosModel():New( self ), ), ::oModel ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS CaracteristicasValoresArticulosController

   ::Super:New( oController )

   ::cTitle                      := "Características valores artículos"

   ::cName                       := "caracteristicas_valores_articulos"

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS CaracteristicasValoresArticulosController
   
   if !empty( ::oModel )
      ::oModel:End()
   end if

   if !empty( ::oDialogView )
      ::oDialogView:End()
   end if

   ::Super:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Activate( uuidArticulo ) CLASS CaracteristicasValoresArticulosController

   ::uuidArticulo             := uuidArticulo

   ::oModel:getSQLInsertCaracteristicaWhereArticulo()

   ::oRowSet:build( ::oModel:getSentenceRowSetValores() )

   ::oDialogView:Resource()

RETURN ( .t. )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS CaracteristicasValoresArticulosView FROM SQLBaseView

   DATA oCol
   DATA oBrowse

   METHOD Resource()

   METHOD ChangeBrowse()

   METHOD ChangeColValue( uNewValue )

   METHOD ChangeColSeleccionado( uNewValue )

END CLASS

//---------------------------------------------------------------------------//

METHOD Resource() CLASS CaracteristicasValoresArticulosView

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

   ::oBrowse:setRowSet( ::oController:oRowSet )

   ::oBrowse:setName( "Valores características artículos" )

   ::oBrowse:bChange       := {|| ::ChangeBrowse() }

   ::oBrowse:CreateFromResource( 100 )

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Caracteristica'
      :nWidth              := 245
      :bEditValue          := {|| ::oController:oRowSet:fieldGet( 'nombre_caracteristica' ) }
   end with

   with object ( ::oCol    := ::oBrowse:AddCol() )
      :cHeader             := 'Valores'
      :nWidth              := 245
      :bEditValue          := {|| if( ::oController:oRowSet:fieldGet( 'personalizado' ) == 0, ::oController:oRowSet:fieldGet( 'nombre_valor' ), "" ) }
      :bOnPostEdit         := {| oCol, uNewValue, nKey | ::ChangeColValue( uNewValue ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Personalizado'
      :nWidth              := 245
      :nEditType           := EDIT_GET
      :bEditValue          := {|| if( ::oController:oRowSet:fieldGet( 'personalizado' ) == 1, Padr( ::oController:oRowSet:fieldGet( 'nombre_valor' ), 200 ), Space( 200 ) ) }
      :bOnPostEdit         := {| oCol, uNewValue, nKey | ::ChangeColSeleccionado( uNewValue ) }
   end with

   ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oFolder:aDialogs ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )
   
   if ::oController:isNotZoomMode() 
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5 .and. validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }
   else
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, ::oDialog:end( IDOK ), ) }
   end if

   ::oDialog:bStart := {|| ::oBrowse:SetFocus(), ::ChangeBrowse() }

   ACTIVATE DIALOG ::oDialog CENTER

   ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD ChangeBrowse() CLASS CaracteristicasValoresArticulosView

   local aValores    := SQLCaracteristicasLineasModel():getArrayNombreValoresFromUuid( ::oController:oRowSet:fieldGet( 'caracteristica_uuid' ) )

   if len( aValores ) > 0
      ::oCol:nEditType     := EDIT_LISTBOX
      ::oCol:aEditListTxt  := aValores
   else
      ::oCol:nEditType     := 0
      ::oCol:aEditListTxt  := {}
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD ChangeColValue( uNewValue ) CLASS CaracteristicasValoresArticulosView

   ::oController:oModel:updateFieldWhereUuid( ::oController:oRowSet:fieldGet( 'uuid' ), "caracteristica_valor_uuid", SQLCaracteristicasLineasModel():getUuidWhereNombre( uNewValue ) )

   ::oController:oRowSet:Refresh()

   ::oBrowse:Refresh()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD ChangeColSeleccionado( uNewValue )

   local hBuffer

   if Empty( uNewValue )
      Return ( .t. )
   end if

   /*
   Inserto en la tabla de valores
   */

   if Empty( SQLCaracteristicasLineasModel():getUuidWhereNombre( uNewValue ) )

      hBuffer     := SQLCaracteristicasLineasModel():loadBlankBuffer()

      hset( hBuffer, "parent_uuid", ::oController:oRowSet:fieldGet( 'caracteristica_uuid' ) )
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

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLCaracteristicasValoresArticulosModel
   
   hset( ::hColumns, "id",                            {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                                         "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",                          {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;
                                                         "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "articulo_uuid",                 {  "create"    => "VARCHAR( 40 )"                           ,;
                                                         "default"   => {|| Space( 40 ) } }                       )

   hset( ::hColumns, "caracteristica_uuid",           {  "create"    => "VARCHAR( 40 )"                           ,;
                                                         "default"   => {|| Space( 40 ) } }                       )

   hset( ::hColumns, "caracteristica_valor_uuid",     {  "create"    => "VARCHAR( 40 )"                           ,;
                                                         "default"   => {|| Space( 40 ) } }                       )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getSQLInsertCaracteristicaWhereArticulo CLASS SQLCaracteristicasValoresArticulosModel

   local cSQL

   cSQL           := "INSERT IGNORE INTO " + ::getTableName()                                            + " "
   cSQL           +=    "( uuid, articulo_uuid, caracteristica_uuid )"                                   + " "
   cSQL           += "SELECT uuid(), " + quoted( ::oController:uuidArticulo ) + ", caracteristicas.uuid" + " "
   cSQL           +=    "FROM " + SQLCaracteristicasModel():getTableName() + " AS caracteristicas"       + " "
   cSQL           +=    "ORDER BY id"

Return ( getSQLDatabase():Exec( cSQL ) )

//---------------------------------------------------------------------------//

METHOD getSentenceRowSetValores() CLASS SQLCaracteristicasValoresArticulosModel

   local cSentence

   cSentence      := "SELECT caracteristicas_valores_articulos.uuid AS uuid, "
   cSentence      +=    "caracteristicas_valores_articulos.articulo_uuid AS articulo_uuid, "
   cSentence      +=    "caracteristicas_valores_articulos.caracteristica_uuid AS caracteristica_uuid, "
   cSentence      +=    "caracteristicas_valores_articulos.caracteristica_valor_uuid AS caracteristica_valor_uuid, "
   cSentence      +=    "articulos_caracteristicas.nombre AS nombre_caracteristica, "
   cSentence      +=    "articulos_caracteristicas_lineas.nombre AS nombre_valor, "
   cSentence      +=    "articulos_caracteristicas_lineas.personalizado AS personalizado "
   cSentence      += "FROM caracteristicas_valores_articulos "
   cSentence      += "INNER JOIN articulos_caracteristicas ON articulos_caracteristicas.uuid = caracteristicas_valores_articulos.caracteristica_uuid "
   cSentence      += "LEFT JOIN articulos_caracteristicas_lineas ON articulos_caracteristicas_lineas.uuid = caracteristicas_valores_articulos.caracteristica_valor_uuid "
   cSentence      +=    "WHERE caracteristicas_valores_articulos.articulo_uuid = " + quoted( ::oController:uuidArticulo )
   
Return ( cSentence )

//---------------------------------------------------------------------------//

METHOD caracteristicaUuidListFromUuidArticulo( uuidProduct ) 

   local aIds     := {}
   local aResult
   local cSentence

   cSentence      := "SELECT caracteristica_uuid AS uuid "
   cSentence      += "FROM caracteristicas_valores_articulos "
   cSentence      += "WHERE articulo_uuid = " + quoted( uuidProduct )

   aResult     := ::getDatabase():selectFetchArray( cSentence )

   aEval( aResult, {|a| aAdd( aIds, a[1] ) } )

Return ( aIds )

//---------------------------------------------------------------------------//

METHOD caracteristicaValuesUuidListFromUuidArticulo( uuidProduct ) 

   local aIds     := {}
   local aResult
   local cSentence

   cSentence      := "SELECT caracteristica_valor_uuid AS uuid "
   cSentence      += "FROM caracteristicas_valores_articulos "
   cSentence      += "WHERE articulo_uuid = " + quoted( uuidProduct )

   aResult     := ::getDatabase():selectFetchArray( cSentence )

   aEval( aResult, {|a| aAdd( aIds, a[1] ) } )

Return ( aIds )

//---------------------------------------------------------------------------//

METHOD productCaracteristicaValuesUuidHashFromUuidArticulo( uuidProduct ) 

   local cSentence

   cSentence      := "SELECT caracteristica_uuid AS caracteristica, caracteristica_valor_uuid AS valor "
   cSentence      += "FROM caracteristicas_valores_articulos "
   cSentence      += "WHERE articulo_uuid = " + quoted( uuidProduct )

Return ( ::getDatabase():selectFetchHash( cSentence ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//