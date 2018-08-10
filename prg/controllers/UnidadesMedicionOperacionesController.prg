#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS UnidadesMedicionOperacionesController FROM SQLNavigatorController

   METHOD New()

   METHOD End()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController ) CLASS UnidadesMedicionOperacionesController

   ::Super:New( oSenderController )

   ::cTitle                         := "Unidades operacion"

   ::cName                          := "unidades_medicion_operacion"

   ::hImage                         := {  "16" => "gc_tape_measure2_16",;
                                          "32" => "gc_tape_measure2_32",;
                                          "48" => "gc_tape_measure2_48" }

   ::nLevel                         := Auth():Level( ::cName )

   ::oModel                         := SQLUnidadesMedicionOperacionesModel():New( self )

   ::oBrowseView                    := UnidadesMedicionOperacionesBrowseView():New( self )

   ::oDialogView                    := UnidadesMedicionOperacionesView():New( self )

   ::oValidator                     := UnidadesMedicionOperacionesValidator():New( self, ::oDialogView )

   ::oRepository                    := UnidadesMedicionOperacionesRepository():New( self )

   ::oGetSelector                   := GetSelector():New( self )

<<<<<<< HEAD
   ::setEvent( 'appended',          {|| ::oModel:GetCodigoUnidadWhereNombre( ::oModel:hBuffer["codigo_unidad"] ) } )
=======
   /*::setEvent( 'appended',            {|| ::oModel:GetCodigoUnidadWhereNombre( ::oModel:hBuffer["codigo_unidad"] ) } )*/
>>>>>>> 729bcf5c6a79ea26e3f2441e5eb2828496b14137

RETURN ( Self )

//---------------------------------------------------------------------------//
METHOD End() CLASS UnidadesMedicionOperacionesController

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oRepository:End()

   ::oGetSelector:End()

   ::Super:End()

RETURN ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS UnidadesMedicionOperacionesBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS UnidadesMedicionOperacionesBrowseView

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
      :cSortOrder          := 'codigo_unidad'
      :cHeader             := 'Código Unidad'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'codigo_unidad' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'nombre_unidad'
      :cHeader             := 'Nombre Unidad'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre_unidad' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'operacion'
      :cHeader             := 'Operación'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'operacion' ) }
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

CLASS UnidadesMedicionOperacionesView FROM SQLBaseView

   DATA oUnidades

   DATA hUnidades

   DATA oTipo

   DATA hTipos

   METHOD New()

   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS UnidadesMedicionOperacionesView

   ::Super:New( oController )

   ::hTipos          := {  "Compra"                         => "Compra",;
                           "Venta"                          => "Venta",;
                           "Almacenes"                      => "Almacenes" }         
   

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS UnidadesMedicionOperacionesView

::hUnidades       := ::oController:oModel:SetUnidadesWhereGrupo( ::oController:oSenderController:getRowSet():fieldGet( 'unidades_medicion_grupos_codigo' ) )

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "UNIDAD_MEDICION_OPERACION" ;
      TITLE       ::LblTitle() + "unidad de operaciones"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getimage("48")  ;
      TRANSPARENT ;
      OF          ::oDialog ;

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        getBoldFont() ;
      OF          ::oDialog ;
   

   REDEFINE COMBOBOX ::oUnidades ;
      VAR         ::oController:oModel:hBuffer[ "uuid_unidad" ] ;
      ID          100 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ITEMS       ( ::hUnidades ) ;
      OF          ::oDialog ;

   REDEFINE COMBOBOX ::oTipo ;
      VAR         ::oController:oModel:hBuffer[ "operacion" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ITEMS       ( hgetValues( ::hTipos ) ) ;
      OF          ::oDialog ;

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

CLASS UnidadesMedicionOperacionesValidator FROM SQLBaseValidator

   METHOD getValidators()

END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS UnidadesMedicionOperacionesValidator

   /*::hValidators  := {  "nombre " =>               {  "required"           => "El nombre es un dato requerido",;
                                                      "unique"             => "El nombre introducido ya existe" },;
                        "codigo" =>                {  "required"           => "El código es un dato requerido" ,;
                                                      "unique"             => "EL código introducido ya existe"  ,;
                                                      "onlyAlphanumeric"   => "EL código no puede contener caracteres especiales" } }*/
RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLUnidadesMedicionOperacionesModel FROM SQLCompanyModel

   DATA cTableName               INIT "unidades_medicion_operacion"

   DATA cConstraints             INIT "PRIMARY KEY ( parent_uuid, uuid_unidad, operacion )"

   DATA aConsulta                INIT {}

   METHOD getUnidadesWhereGrupo( cCodigoGrupo )

   METHOD SetUnidadesWhereGrupo( cCodigoGrupo )

   METHOD setUuidUnidadAttribute( value ) ;
                                 INLINE ( SQLUnidadesMedicionModel():getUuidWhereColumn( Value, "nombre" ) )

   METHOD getInitialSelect()                              

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLUnidadesMedicionOperacionesModel

   hset( ::hColumns, "id",             {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"              ,;                          
                                          "default"   => {|| 0 } }                                    )

   hset( ::hColumns, "uuid",           {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"              ,;                                  
                                          "default"   => {|| win_uuidcreatestring() } }               )

   hset( ::hColumns, "parent_uuid",    {  "create"    => "VARCHAR( 40 ) NOT NULL"                     ,;
                                          "default"   => {|| ::getSenderControllerParentUuid() } }    )

   hset( ::hColumns, "uuid_unidad",    {  "create"    => "VARCHAR( 40 )"                              ,;
                                          "default"   => {|| space( 40 ) } }                          )

   hset( ::hColumns, "operacion",      {  "create"    => "VARCHAR( 200 )"                             ,;
                                          "default"   => {|| space( 200 ) } }                         )
   
   ::getTimeStampColumns()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getUnidadesWhereGrupo( cCodigoGrupo ) CLASS SQLUnidadesMedicionOperacionesModel

   local cSQL

   TEXT INTO cSql

      SELECT 

         unidades_medicion.*     
      
      FROM %1$s AS unidades_medicion_grupos                                               

      INNER JOIN %2$s AS unidades_medicion_grupos_lineas         
         ON unidades_medicion_grupos.uuid = unidades_medicion_grupos_lineas.parent_uuid                             

      INNER JOIN %3$s AS unidades_medicion         
         ON unidades_medicion.codigo = unidades_medicion_grupos_lineas.unidad_alternativa_codigo

      WHERE 
         unidades_medicion_grupos.codigo = %4$s 

   ENDTEXT

   cSql  := hb_strformat( cSql, SQLUnidadesMedicionGruposModel():getTableName(), SQLUnidadesMedicionGruposLineasModel():getTableName(),SQLUnidadesMedicionModel():getTableName() , quoted( cCodigoGrupo ) ) 

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD SetUnidadesWhereGrupo( cCodigoGrupo ) CLASS SQLUnidadesMedicionOperacionesModel

   local cCodigo

   local aUnidades := {}

   ::aConsulta := getSQLDatabase():selectTrimedFetchHash( SQLUnidadesMedicionOperacionesModel():getUnidadesWhereGrupo( cCodigoGrupo ) )  

   aeval( ::aConsulta, {| h | aadd( aUnidades, h["nombre"] ) } )


RETURN ( aUnidades )

//---------------------------------------------------------------------------//
<<<<<<< HEAD

METHOD GetCodigoUnidadWhereNombre( Nombre ) CLASS SQLUnidadesMedicionOperacionesModel
=======
>>>>>>> 729bcf5c6a79ea26e3f2441e5eb2828496b14137

METHOD getInitialSelect() CLASS SQLUnidadesMedicionOperacionesModel

local cSQL

<<<<<<< HEAD
   nPos     := aScan( ::aConsulta, {|h| alltrim(hget(h,"nombre")) ==alltrim(Nombre)  } )
=======
   TEXT INTO cSql
>>>>>>> 729bcf5c6a79ea26e3f2441e5eb2828496b14137

      SELECT 

         unidades_medicion.uuid as uuid,
         unidades_medicion.id as id,
         unidades_medicion.codigo as codigo_unidad,
         unidades_medicion.nombre as nombre_unidad,
         unidades_medicion_operacion.operacion as operacion    
      
      FROM %1$s AS unidades_medicion_operacion
      
      INNER JOIN %2$s AS unidades_medicion
      ON unidades_medicion_operacion.uuid_unidad = unidades_medicion.uuid


      ENDTEXT


   cSql  := hb_strformat( cSql, ::getTableName(), SQLUnidadesMedicionModel():getTableName() ) 

RETURN ( cSql )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS UnidadesMedicionOperacionesRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLUnidadesMedicionOperacionesModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
