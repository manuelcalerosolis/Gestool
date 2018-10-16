#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS UnidadesMedicionGruposLineasController FROM SQLBrowseController

   METHOD New() CONSTRUCTOR

   METHOD End()

   //Construcciones tardias----------------------------------------------------

   METHOD getBrowseView()                 INLINE( if( empty( ::oBrowseView ), ::oBrowseView := UnidadesMedicionGruposLineasBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()                 INLINE( if( empty( ::oDialogView ), ::oDialogView := UnidadesMedicionGruposLineasView():New( self ), ), ::oDialogView )

   METHOD getValidator()                  INLINE( if( empty( ::oValidator ), ::oValidator := UnidadesMedicionGruposLineasValidator():New( self ), ), ::oValidator )

   METHOD getRepository()                 INLINE ( if( empty( ::oRepository ), ::oRepository := UnidadesMedicionGruposLineasRepository():New( self ), ), ::oRepository )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS UnidadesMedicionGruposLineasController

   ::Super:New( oController )

   ::cTitle                         := "Equivalencia de unidades de medición"

   ::cName                          := "unidades_medicion_grupos"

   ::hImage                         := {  "16" => "gc_tape_measure2_16",;
                                          "32" => "gc_tape_measure2_32",;
                                          "48" => "gc_tape_measure2_48" }

   ::nLevel                         := Auth():Level( ::cName )

   ::oModel                         := SQLUnidadesMedicionGruposLineasModel():New( self )

   ::setEvents( { 'editing', 'deleting' }, {|| if( ::isRowSetSystemRegister(), ( msgStop( "Este registro pertenece al sistema, no se puede alterar." ), .f. ), .t. ) } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS UnidadesMedicionGruposLineasController

   ::oModel:End()

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

RETURN ( nil )

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
   local cUnidadBaseCodigo := ::oController:oController:getModelBuffer( 'unidad_base_codigo' )
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
      FONT        oFontBold() ;
      OF          ::oDialog ;

   // unidad alternativa-------------------------------------------------------------------------------------------------------//

   ::oController:getUnidadesMedicioncontroller():getSelector():Bind( bSETGET( ::oController:oModel:hBuffer[ "unidad_alternativa_codigo" ] ) )
   
   //::oController:getUnidadesMedicioncontroller():oGetSelector:setEvent( 'validated', {|| ::UnidadesMedicionControllerValidated() } )

   ::oController:getUnidadesMedicioncontroller():getSelector():Activate( 120, 122, ::oDialog )

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

   ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, ::oDialog:end( IDOK ), ) }
   
   if ::oController:isNotZoomMode() 
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5 .and. validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }
   end if

   ::oDialog:bStart  := {|| ::StartActivate() }
   
   ACTIVATE DIALOG ::oDialog CENTER

  ::oBitmap:end()
  
RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD StartActivate() CLASS UnidadesMedicionGruposLineasView

   ::oController:getUnidadesMedicioncontroller():getSelector():Start()

RETURN ( nil )

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
                                                         "default"   => {|| ::getControllerParentUuid() } }  )

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
                     "WHERE parent_uuid = " + quoted( ::getControllerParentUuid() )

RETURN ( cSelect )

//---------------------------------------------------------------------------//

METHOD getSentenceInserLineaUnidadBase( uuidParent, cCodigoBaseUnidad ) CLASS SQLUnidadesMedicionGruposLineasModel

   local cSentence   := "INSERT IGNORE INTO " + SQLUnidadesMedicionGruposLineasModel():getTableName()                         + " " + ;
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

   METHOD getUnidadDefectoWhereArticulo( cCodigoArticulo )

END CLASS

//---------------------------------------------------------------------------//

METHOD getSentenceWhereGrupoSistema( cField ) CLASS UnidadesMedicionGruposLineasRepository

   local cSelect

   DEFAULT cField    := "unidad_alternativa_codigo"

   cSelect           := "SELECT lineas." + cField                                                                 + " " + ;
                        "FROM " + ::getTableName() + " AS lineas"                                                  + " " + ;
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

RETURN ( ::getDatabase():getValue( ::getSentenceWhereEmpresa() ) )

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

METHOD getUnidadDefectoWhereArticulo( cCodigoArticulo ) CLASS UnidadesMedicionGruposLineasRepository

   local cSql

   TEXT INTO cSql

   SELECT 
      unidades_medicion_grupos_lineas.unidad_alternativa_codigo

      FROM %1$s AS unidades_medicion_grupos_lineas

      INNER JOIN %2$s AS unidades_medicion_grupos
         ON unidades_medicion_grupos_lineas.parent_uuid = unidades_medicion_grupos.uuid 

      INNER JOIN %3$s AS articulos
         ON articulos.unidades_medicion_grupos_codigo = unidades_medicion_grupos.codigo AND articulos.codigo = %4$s

      ORDER BY unidades_medicion_grupos_lineas.cantidad_base ASC
      
      LIMIT 1      

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), SQLUnidadesMedicionGruposModel():getTableName(), SQLArticulosModel():getTableName(), cCodigoArticulo )

RETURN ( getSQLDatabase():getValue( cSql ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//