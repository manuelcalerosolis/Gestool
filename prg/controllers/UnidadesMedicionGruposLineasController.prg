#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS UnidadesMedicionGruposLineasController FROM SQLBrowseController

   DATA oUnidadesMedicionController

   METHOD New()

   METHOD End()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController ) CLASS UnidadesMedicionGruposLineasController

   ::Super:New( oSenderController )

   ::cTitle                         := "Equivalencia de unidades de medición"

   ::cName                          := "unidades_medicion_grupos"

   ::hImage                         := {  "16" => "gc_tape_measure2_16",;
                                          "32" => "gc_tape_measure2_32",;
                                          "48" => "gc_tape_measure2_48" }

   ::nLevel                         := Auth():Level( ::cName )

   ::oModel                         := SQLUnidadesMedicionGruposLineasModel():New( self )

   ::oBrowseView                    := UnidadesMedicionGruposLineasBrowseView():New( self )

   ::oDialogView                    := UnidadesMedicionGruposLineasView():New( self )

   ::oValidator                     := UnidadesMedicionGruposLineasValidator():New( self, ::oDialogView )

   ::oRepository                    := UnidadesMedicionGruposLineasRepository():New( self )

   ::oUnidadesMedicionController    := UnidadesMedicionController():New( self )

   ::oGetSelector                   := GetSelector():New( self )

   ::setEvents( { 'editing', 'deleting' }, {|| if( ::isRowSetSystemRegister(), ( msgStop( "Este registro pertenece al sistema, no se puede alterar." ), .f. ), .t. ) } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS UnidadesMedicionGruposLineasController

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oRepository:End()

   ::oUnidadesMedicionController:End()

   ::oGetSelector:End()

   ::Super:End()

RETURN ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS UnidadesMedicionGruposLineasBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS UnidadesMedicionGruposLineasBrowseView

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
      :cSortOrder          := 'cantidad_alternativa'
      :cHeader             := 'Cantidad'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'cantidad_alternativa' ) }
      :cEditPicture        := "@E 999999999.999999"
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'unidad_alternativa_codigo'
      :cHeader             := 'Código de unidad alternativa'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'unidad_alternativa_codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'unidad_alternativa_nombre'
      :cHeader             := 'Nombre de unidad alternativa'
      :nWidth              := 150
      :bEditValue          := {|| ::getRowSet():fieldGet( 'unidad_alternativa_nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'cantidad_base'
      :cHeader             := 'Cantidad'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'cantidad_base' ) }
      :cEditPicture        := "@E 999999999.999999"
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

      with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'unidad_base_codigo'
      :cHeader             := 'Código de unidad base'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'unidad_base_codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'unidad_base_nombre'
      :cHeader             := 'Nombre de unidad base'
      :nWidth              := 150
      :bEditValue          := {|| ::getRowSet():fieldGet( 'unidad_base_nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'sistema'
      :cHeader             := 'Sistema'
      :nWidth              := 60
      :bEditValue          := {|| if( ::getRowSet():fieldGet( 'sistema' ) == 1, 'Sistema', '' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS UnidadesMedicionGruposLineasView FROM SQLBaseView

   METHOD Activate()

    METHOD StartActivate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS UnidadesMedicionGruposLineasView

   local oDialog
   local cUnidadBaseCodigo := ::oController:oSenderController:getModelBuffer( 'unidad_base_codigo' )
   local cUnidadBaseNombre := SQLUnidadesMedicionModel():getField( 'nombre', 'codigo', cUnidadBaseCodigo )

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "LINEA_GRUPO_UNIDAD_MEDICION" ;
      TITLE       ::LblTitle() + " grupo de unidades de medición"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog ;

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        getBoldFont() ;
      OF          ::oDialog ;

// unidad alternativa-------------------------------------------------------------------------------------------------------//

   ::oController:oUnidadesMedicioncontroller:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "unidad_alternativa_codigo" ] ) )
   
   //::oController:oUnidadesMedicioncontroller:oGetSelector:setEvent( 'validated', {|| ::UnidadesMedicionControllerValidated() } )

   ::oController:oUnidadesMedicioncontroller:oGetSelector:Activate( 120, 122, ::oDialog )

   REDEFINE GET   ::oController:oModel:hBuffer[ "cantidad_alternativa" ] ;
      ID          130 ;
      SPINNER ;
      MIN 1;
      WHEN        ( .f. ) ;
      OF          ::oDialog ;


// unidad base--------------------------------------------------------------------------------------------------------------//

   REDEFINE GET   cUnidadBaseCodigo ;
      ID          140 ;
      WHEN        ( .f. ) ;
      OF          ::oDialog ;

   REDEFINE GET   cUnidadBaseNombre ;
      ID          142 ;
      WHEN        ( .f. ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "cantidad_base" ] ;
      ID          150 ;
      SPINNER ;
      MIN 1.000;
      PICTURE     "@E 999999999.999" ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
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
      ACTION      ( ::oDialog:end() )

   if ::oController:isNotZoomMode() 
      ::oDialog:AddFastKey( VK_F5, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) } )
   end if

   ::oDialog:bStart  := {|| ::StartActivate() }
   
   ACTIVATE DIALOG ::oDialog CENTER

  ::oBitmap:end()
  

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD StartActivate() CLASS UnidadesMedicionGruposLineasView

   ::oController:oUnidadesMedicioncontroller:oGetSelector:Start()

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS UnidadesMedicionGruposLineasValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS UnidadesMedicionGruposLineasValidator

   ::hValidators  := {  "nombre" =>       {  "required"           => "La descripción es un dato requerido",;
                                             "unique"             => "La descripción introducida ya existe" },;
                        "codigo" =>       {  "required"           => "El código es un dato requerido" ,;
                                             "unique"             => "EL código introducido ya existe"  } }
RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLUnidadesMedicionGruposLineasModel FROM SQLCompanyModel

   DATA cTableName                                 INIT "unidades_medicion_grupos_lineas"

   DATA cConstraints                               INIT "FOREIGN KEY (parent_uuid) REFERENCES " + SQLUnidadesMedicionGruposModel():getTableName() + " (uuid) ON DELETE CASCADE"

   METHOD getColumns()

   METHOD getGeneralSelect()

   METHOD getUnidadesMedicionTableName()           INLINE ( SQLUnidadesMedicionModel():getTableName() )
   
   METHOD getUnidadesMedicionGruposTableName()     INLINE ( SQLUnidadesMedicionGruposModel():getTableName() )

   METHOD getSentenceInserLineaUnidadBase( uuidParent, cCodigoBaseUnidad )

   METHOD insertLineaUnidadBase( uuidParent, cCodigoBaseUnidad )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLUnidadesMedicionGruposLineasModel

   hset( ::hColumns, "id",                            {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;                          
                                                         "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",                          {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;                                  
                                                         "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "parent_uuid",                   {  "create"    => "VARCHAR( 40 )"                           ,;
                                                         "default"   => {|| ::getSenderControllerParentUuid() } }  )

   hset( ::hColumns, "unidad_alternativa_codigo",     {  "create"    => "VARCHAR( 20 )"                           ,;
                                                         "default"   => {|| space( 20 ) } }                        )

   hset( ::hColumns, "cantidad_alternativa",          {  "create"    => "INTEGER"                                 ,;
                                                         "default"   => {|| 1 } }                                 )

   hset( ::hColumns, "cantidad_base",                 {  "create"    => "FLOAT( 16, 6 )"                          ,;
                                                         "default"   => {|| 1    } }                              )

   hset( ::hColumns, "sistema",                       {  "create"    => "TINYINT( 1 )"                            ,;
                                                         "default"   => {|| 0 } }                                 )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getGeneralSelect() CLASS SQLUnidadesMedicionGruposLineasModel

   local cSelect  := "SELECT lineas.id,"                                                                          + " " + ;                                                                                                                     
                        "lineas.uuid,"                                                                            + " " + ;                                                                                                                                    
                        "lineas.parent_uuid,"                                                                     + " " + ;
                        "lineas.unidad_alternativa_codigo,"                                                       + " " + ;
                        "lineas.cantidad_alternativa,"                                                            + " " + ;                                               
                        "lineas.cantidad_base,"                                                                   + " " + ;
                        "lineas.sistema,"                                                                         + " " + ;
                        "alternativa.nombre as unidad_alternativa_nombre,"                                        + " " + ;
                        "grupos.unidad_base_codigo as unidad_base_codigo,"                                        + " " + ;
                        "base.nombre as unidad_base_nombre"                                                       + " " + ;
                     "FROM "+ ::getTableName() + " AS lineas"                                                     + " " + ;                                                    
                        "LEFT JOIN " + ::getUnidadesMedicionGruposTableName() + " AS grupos"                      + " " + ;         
                           "ON lineas.parent_uuid = grupos.uuid"                                                  + " " + ;         
                        "LEFT JOIN " + ::getUnidadesMedicionTableName() + " AS alternativa"                       + " " + ;         
                           "ON lineas.unidad_alternativa_codigo = alternativa.codigo"                             + " " + ;
                        "LEFT JOIN " + ::getUnidadesMedicionTableName() + " AS base"                              + " " + ;         
                           "ON grupos.unidad_base_codigo = base.codigo"                                           + " " + ;         
                     "WHERE parent_uuid = " + quoted( ::getSenderControllerParentUuid() )

RETURN ( cSelect )

//---------------------------------------------------------------------------//

METHOD getSentenceInserLineaUnidadBase( uuidParent, cCodigoBaseUnidad ) CLASS SQLUnidadesMedicionGruposLineasModel

   local cSentence   := "INSERT IGNORE INTO " + SQLUnidadesMedicionGruposLineasModel():getTableName()                      + " " + ;
                           "( uuid, parent_uuid, unidad_alternativa_codigo, cantidad_alternativa, cantidad_base, sistema )"   + " " + ;
                        "VALUES"                                                                                              + " " + ;
                           "( UUID(), " + quoted( uuidParent ) + ", " + quoted( cCodigoBaseUnidad ) + ", 1, 1, 1 )"

RETURN ( cSentence )

//---------------------------------------------------------------------------//

METHOD insertLineaUnidadBase( uuidParent, cCodigoBaseUnidad ) CLASS SQLUnidadesMedicionGruposLineasModel

   local cSql  := ::getSentenceInserLineaUnidadBase( uuidParent, cCodigoBaseUnidad )

RETURN ( getSQLDatabase():Exec( cSql ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS UnidadesMedicionGruposLineasRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLUnidadesMedicionGruposLineasModel():getTableName() ) 

   METHOD getSentenceWhereGrupoSistema( cCodigoGrupo )

   METHOD getSentenceWhereEmpresa( cCodigoGrupo )

   METHOD getSentenceWhereCodigoArticulo( cCodigoArticulo )



   METHOD getWhereGrupoSistema( cCodigoGrupo )

   METHOD getWhereEmpresa( cCodigoGrupo )

   METHOD getWhereCodigoArticulo( cCodigoArticulo )

   METHOD getCodigos( cCodigoArticulo )

   METHOD getWhereGrupoSistemaDefault()

   METHOD getWhereEmpresaDefault()

   METHOD getWhereCodigoArticuloDefault( cCodigoArticulo )

   METHOD getCodigoDefault( cCodigoArticulo )

   METHOD getFactorWhereUnidadMedicion( cCodigoArticulo, cCodigoUnidad )

   METHOD getFactorWhereUnidadMedicion( cCodigoArticulo, cCodigoUnidad )

   METHOD getFactorWhereUnidadArticulo( cCodigoArticulo, cCodigoUnidad )

   METHOD getFactorWhereUnidadEmpresa( cCodigoUnidad )

   METHOD getFactorWhereUnidadGrupoSistema( cCodigoUnidad )

END CLASS

//---------------------------------------------------------------------------//

METHOD getSentenceWhereGrupoSistema( cField ) CLASS UnidadesMedicionGruposLineasRepository

   local cSelect

   DEFAULT cField    := "unidad_alternativa_codigo"

   cSelect           := "SELECT lineas." + cField                                                                 + " " + ;
                        "FROM "+ ::getTableName() + " AS lineas"                                                  + " " + ;
                        "LEFT JOIN " + SQLUnidadesMedicionGruposModel():getTableName() + " AS grupos"             + " " + ;         
                           "ON lineas.parent_uuid = grupos.uuid"                                                  + " " + ;         
                        "WHERE grupos.sistema = 1"

RETURN ( cSelect )

//---------------------------------------------------------------------------//

METHOD getSentenceWhereEmpresa( cField ) CLASS UnidadesMedicionGruposLineasRepository

   local cSelect

   DEFAULT cField    := "unidad_alternativa_codigo"

   cSelect           := "SELECT lineas." + cField                                                                 + " " + ;
                           "FROM "+ ::getTableName() + " AS lineas"                                               + " " + ;
                           "LEFT JOIN " + SQLUnidadesMedicionGruposModel():getTableName() + " AS grupos"          + " " + ;         
                              "ON lineas.parent_uuid = grupos.uuid"                                               + " " + ;         
                           "LEFT JOIN " + SQLAjustableModel():getTableName() + " AS ajustables"                   + " " + ;
                              "ON ajustables.ajuste_valor = grupos.codigo"                                        + " " + ;
                           "LEFT JOIN " + SQLAjustesModel():getTableName() + " AS ajustes"                        + " " + ;
                              "ON ajustes.uuid = ajustables.ajuste_uuid"                                          + " " + ;
                           "WHERE ajustes.ajuste = 'unidades_grupo_defecto'"                                      + " " + ;
                              "AND ajustables.ajustable_uuid = " + quoted( Company():uuid() )

RETURN ( cSelect )

//---------------------------------------------------------------------------//

METHOD getSentenceWhereCodigoArticulo( cCodigoArticulo, cField ) CLASS UnidadesMedicionGruposLineasRepository 

   local cSelect

   DEFAULT cField    := "unidad_alternativa_codigo"

   cSelect           := "SELECT lineas." + cField                                                                 + " " + ;
                           "FROM "+ ::getTableName() + " AS lineas"                                               + " " + ;
                           "LEFT JOIN " + SQLUnidadesMedicionGruposModel():getTableName() + " AS grupos"          + " " + ;         
                              "ON lineas.parent_uuid = grupos.uuid"                                               + " " + ;         
                           "LEFT JOIN " + SQLArticulosModel():getTableName() + " AS articulos"                    + " " + ;         
                              "ON articulos.unidades_medicion_grupos_codigo = grupos.codigo"                      + " " + ;
                           "WHERE articulos.codigo = " + quoted( cCodigoArticulo )

RETURN ( cSelect )

//---------------------------------------------------------------------------//

METHOD getWhereGrupoSistema() CLASS UnidadesMedicionGruposLineasRepository

RETURN ( ::getDatabase():selectFetchArrayOneColumn( ::getSentenceWhereGrupoSistema() ) )

//---------------------------------------------------------------------------//

METHOD getWhereEmpresa() CLASS UnidadesMedicionGruposLineasRepository

RETURN ( ::getDatabase():selectFetchArrayOneColumn( ::getSentenceWhereEmpresa() ) )

//---------------------------------------------------------------------------//

METHOD getWhereCodigoArticulo( cCodigoArticulo ) CLASS UnidadesMedicionGruposLineasRepository 

   if Empty( cCodigoArticulo )
      RETURN ( {} )
   end if

RETURN ( ::getDatabase():selectFetchArrayOneColumn( ::getSentenceWhereCodigoArticulo( cCodigoArticulo ) ) )

//---------------------------------------------------------------------------//

METHOD getCodigos( cCodigoArticulo ) CLASS UnidadesMedicionGruposLineasRepository 

   local aResult  := {}

   if !empty( cCodigoArticulo )
      aResult  := ::getWhereCodigoArticulo( cCodigoArticulo )
   end if      

   if empty( aResult )
      aResult  := ::getWhereEmpresa()
   end if

   if empty( aResult )
      aResult  := ::getWhereGrupoSistema()
   end if

RETURN ( aResult )

//---------------------------------------------------------------------------//

METHOD getWhereGrupoSistemaDefault() CLASS UnidadesMedicionGruposLineasRepository

   local cSelect  

   cSelect        := ::getSentenceWhereGrupoSistema()       + " " + ;
                        "AND lineas.sistema = 1"   

RETURN ( ::getDatabase():getValue( cSelect ) )

//---------------------------------------------------------------------------//

METHOD getWhereEmpresaDefault() CLASS UnidadesMedicionGruposLineasRepository

   local cSelect  

   cSelect        := ::getSentenceWhereEmpresa()            + " " + ;
                        "AND lineas.sistema = 1"

RETURN ( ::getDatabase():getValue( cSelect ) )

//---------------------------------------------------------------------------//

METHOD getWhereCodigoArticuloDefault( cCodigoArticulo ) CLASS UnidadesMedicionGruposLineasRepository 

   local cSelect                 := ""

   if Empty( cCodigoArticulo )
      RETURN ( {} )
   end if

   cSelect     := ::getSentenceWhereCodigoArticulo( cCodigoArticulo ) + " " + ;
                     "AND lineas.sistema = 1"

RETURN ( ::getDatabase():getValue( cSelect ) )

//---------------------------------------------------------------------------//

METHOD getCodigoDefault( cCodigoArticulo ) CLASS UnidadesMedicionGruposLineasRepository 

   local cCodigo     := ""

   if !empty( cCodigoArticulo )
      cCodigo        := ::getWhereCodigoArticuloDefault( cCodigoArticulo )
   end if      

   if empty( cCodigo )
      cCodigo        := ::getWhereEmpresaDefault()
   end if

   if empty( cCodigo )
      cCodigo        := ::getWhereGrupoSistemaDefault()
   end if

RETURN ( cCodigo )

//---------------------------------------------------------------------------//

METHOD getFactorWhereUnidadMedicion( cCodigoArticulo, cCodigoUnidad ) CLASS UnidadesMedicionGruposLineasRepository 

   local nFactory := 1

   if !empty( cCodigoArticulo )
      nFactory    := ::getFactorWhereUnidadArticulo( cCodigoArticulo, cCodigoUnidad )
   end if      

   if empty( nFactory )
      nFactory    := ::getFactorWhereUnidadEmpresa( cCodigoUnidad )
   end if

   if empty( nFactory )
      nFactory    := ::getFactorWhereUnidadGrupoSistema( cCodigoUnidad )
   end if

RETURN ( nFactory )

//---------------------------------------------------------------------------//

METHOD getFactorWhereUnidadArticulo( cCodigoArticulo, cCodigoUnidad ) CLASS UnidadesMedicionGruposLineasRepository

   local cSentence := ""

   if Empty( cCodigoArticulo )
      RETURN ( {} )
   end if

   cSentence         := ::getSentenceWhereCodigoArticulo( cCodigoArticulo,  "cantidad_base"  ) + " " + ;
                     "AND lineas.unidad_alternativa_codigo = " + quoted( cCodigoUnidad )

RETURN ( ::getDatabase():getValue( cSentence ) )

//---------------------------------------------------------------------------//

METHOD getFactorWhereUnidadEmpresa( cCodigoUnidad ) CLASS UnidadesMedicionGruposLineasRepository

   local cSentence := ""

   cSentence         := ::getSentenceWhereEmpresa( "cantidad_base" )            + " " + ;
                        "AND lineas.unidad_alternativa_codigo = " + quoted( cCodigoUnidad )

RETURN ( ::getDatabase():getValue( cSentence ) )

//---------------------------------------------------------------------------//

METHOD getFactorWhereUnidadGrupoSistema( cCodigoUnidad ) CLASS UnidadesMedicionGruposLineasRepository

   local cSentence := ""

   cSentence         := ::getSentenceWhereGrupoSistema( "cantidad_base" )       + " " + ;
                        "AND lineas.unidad_alternativa_codigo = " + quoted( cCodigoUnidad )   

RETURN ( ::getDatabase():getValue( cSentence ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//