#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS SesionesController FROM SQLNavigatorController

   DATA oDialogCloseView

   DATA oCajasController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD isNotOpenSessions()

   METHOD CloseSession()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS SesionesController

   ::Super:New( oController )

   ::cTitle                      := "Sesiones"

   ::cName                       := "sesiones"

   ::hImage                      := {  "16" => "gc_clock_16",;
                                       "32" => "gc_clock_32",;
                                       "48" => "gc_clock_48" }

   ::nLevel                      := Auth():Level( ::cName )

   ::oModel                      := SQLSesionesModel():New( self )

   ::oBrowseView                 := SesionesBrowseView():New( self )

   ::oDialogView                 := SesionesView():New( self )

   ::oDialogCloseView            := SesionesCloseView():New( self )

   ::oValidator                  := SesionesValidator():New( self, ::oDialogView )

   ::oRepository                 := SesionesRepository():New( self )

   ::oCajasController            := CajasController():New( self )

   ::setEvent( 'appending',      {|| ::isNotOpenSessions() } )

   ::getNavigatorView():oMenuTreeView:setEvent( 'addedAppendButton',;
      {|| ::getNavigatorView():oMenuTreeView:AddButton( "Cerrar", "gc_clock_stop_16", {|| ::CloseSession() }, , ACC_EDIT, ::oNavigatorView:oMenuTreeView:oButtonMain ) } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS SesionesController

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oDialogCloseView:End()

   ::oValidator:End()

   ::oRepository:End()

   ::oCajasController:End()

   ::oModel             := nil

   ::oBrowseView        := nil

   ::oDialogView        := nil

   ::oDialogCloseView   := nil

   ::oValidator         := nil

   ::oRepository        := nil

   ::oCajasController   := nil

   ::Super:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD isNotOpenSessions() CLASS SesionesController

   if ::oModel:isOpenSessions()
      msgStop( "Ya existe una sesión abierta en esta caja" )
      RETURN ( .f. )
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD CloseSession() CLASS SesionesController

   local nId   := Session():Id()

   if empty( nId )
      RETURN ( nil )
   end if 

   ::beginTransactionalMode()

   ::oModel:loadCurrentBuffer( nId )

   if ::DialogViewActivate( ::oDialogCloseView )
      
      ::oModel:updateBuffer()

      // Proceder al cierre

      ::commitTransactionalMode()

      ::refreshRowSetAndFindId( nId )

      ::refreshBrowseView()

   else

      ::rollbackTransactionalMode()

   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SesionesBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

END CLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS SesionesBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'id'
      :cHeader             := 'Id'
      :nWidth              := 60
      :bEditValue          := {|| ::getRowSet():fieldGet( 'id' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'id'
      :cHeader             := 'Uuid'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'estado'
      :cHeader             := 'Estado'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'estado' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with 

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'numero'
      :cHeader             := 'Número'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'numero' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :cEditPicture        := "99999999"
   end with 

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'caja_codigo'
      :cHeader             := 'Código caja'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'caja_codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with 

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'caja_nombre'
      :cHeader             := 'Nombre caja'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'caja_nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SesionesView FROM SQLBaseView

   METHOD Activate()

   METHOD startActivate() 

   METHOD endActivate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS SesionesView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "SESION_ABRIR" ;
      TITLE       ::LblTitle() + "sesiones"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getimage("48")  ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "numero" ] ;
      ID          100 ;
      PICTURE     "999999999" ;
      WHEN        ( .f. ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "fecha_hora_inicio" ] ;
      ID          110 ;
      PICTURE     "@DT" ;
      WHEN        ( .f. ) ;
      OF          ::oDialog

   ::oController:oCajasController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "caja_codigo" ] ) )
   ::oController:oCajasController:oGetSelector:Build( { "idGet" => 120, "idText" => 121, "idLink" => 122, "oDialog" => ::oDialog } )
   ::oController:oCajasController:oGetSelector:setWhen( {|| .f. } )

   /*REDEFINE GET   ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "codigo" ] ;
      ID          120 ;
      SPINNER  ;
      MIN 0;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

       ::redefineExplorerBar( 200 )*/

   // Botones caja -------------------------------------------------------

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

METHOD startActivate() CLASS SesionesView

   ::oController:oCajasController:oGetSelector:Start()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD endActivate() CLASS SesionesView

   ::oDialog:end( IDOK )

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SesionesCloseView FROM SQLBaseView

   METHOD Activate()

   METHOD startActivate() 

   METHOD endActivate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS SesionesCloseView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "SESION_CERRAR" ;
      TITLE       ::LblTitle() + "sesiones"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getimage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "numero" ] ;
      ID          100 ;
      PICTURE     "999999999" ;
      WHEN        ( .f. ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "fecha_hora_inicio" ] ;
      ID          110 ;
      PICTURE     "@DT" ;
      WHEN        ( .f. ) ;
      OF          ::oDialog

   ::oController:oCajasController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "caja_codigo" ] ) )
   ::oController:oCajasController:oGetSelector:Activate( 120, 121, ::oDialog )
   ::oController:oCajasController:oGetSelector:setWhen( {|| .f. } )

   /*REDEFINE GET   ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "codigo" ] ;
      ID          120 ;
      SPINNER  ;
      MIN 0;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

       ::redefineExplorerBar( 200 )*/

   // Botones caja -------------------------------------------------------

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

METHOD startActivate() CLASS SesionesCloseView

   ::oController:oCajasController:oGetSelector:Start()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD endActivate() CLASS SesionesCloseView

   ::oDialog:end( IDOK )

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//


CLASS SesionesValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS SesionesValidator

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLSesionesModel FROM SQLCompanyModel

   DATA cTableName               INIT "cajas_sesiones"

   DATA cConstraints             INIT "PRIMARY KEY ( id ), UNIQUE KEY ( numero, caja_codigo )"

   METHOD getColumns()

   METHOD getGeneralSelect() 

   METHOD isOpenSessions()

   METHOD getLastOpenWhereCajaNombre( cCajaNombre )

   METHOD getAllTransactionWhereSessionUuid( uuidSession )

END CLASS

//---------------------------------------------------------------------------//

METHOD getGeneralSelect() CLASS SQLSesionesModel

   local cSelect  := "SELECT sesiones.id AS id, "                                      + ;
                        "sesiones.uuid AS uuid, "                                      + ;
                        "sesiones.numero AS numero, "                                  + ;
                        "sesiones.caja_codigo AS caja_codigo, "                        + ;
                        "sesiones.estado AS estado, "                                  + ;
                        "cajas.nombre AS caja_nombre "                                 + ;
                        "FROM " + ::getTableName()+ " AS sesiones "                    + ;
                     "LEFT JOIN " + SQLCajasModel():getTableName() + " AS cajas "      + ;
                        "ON sesiones.caja_codigo = cajas.codigo"

RETURN ( cSelect )

//---------------------------------------------------------------------------//

METHOD isOpenSessions() CLASS SQLSesionesModel

   local cSelect  := "SELECT COUNT(*) "                                    + ;
                        "FROM " + ::getTableName() + " "                   + ;
                     "WHERE estado = 'Abierta' "                           + ;
                        "AND caja_codigo = " + quoted( Box():Codigo() )    

RETURN ( getSQLDataBase():getValue( cSelect ) > 0 )

//---------------------------------------------------------------------------//
 
METHOD getLastOpenWhereCajaNombre( cCajaNombre ) CLASS SQLSesionesModel

   local aSelect
   local cSelect  := "SELECT sesiones.* "                                           + ;
                        "FROM " + ::getTableName() + " AS sesiones "                + ;
                     "INNER JOIN " + SQLCajasModel():getTableName() + " AS cajas "  + ;
                        "ON sesiones.caja_codigo = cajas.codigo "                   + ;
                     "WHERE sesiones.estado = 'Abierta' "                           + ;
                        "AND cajas.nombre = " + quoted( cCajaNombre )    

   aSelect        := ::getDatabase():selectTrimedFetchHash( cSelect )
   if hb_isarray( aSelect )
      RETURN ( atail( aSelect ) )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getAllTransactionWhereSessionUuid( uuidSession ) CLASS SQLSesionesModel
/*
   local cSelect  := "SELECT sesiones.* "                                           + ;
                        "FROM " + ::getTableName() + " AS sesiones "                + ;
                     "INNER JOIN " + SQLCajasModel():getTableName() + " AS cajas "  + ;
                        "ON sesiones.caja_codigo = cajas.codigo "                   + ;
                     "WHERE sesiones.estado = 'Abierta' "                           + ;
                        "AND cajas.nombre = " + quoted( cCajaNombre )    

   aSelect        := ::getDatabase():selectTrimedFetchHash( cSelect )
   if hb_isarray( aSelect )
      RETURN ( atail( aSelect ) )
   end if 
*/
RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLSesionesModel
   
   hset( ::hColumns, "id",                         {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                                      "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",                       {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;
                                                      "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "numero",                     {  "create"    => "INTEGER UNSIGNED"                        ,;
                                                      "default"   => {|| Box():numeroSesion() } }                                 )

   hset( ::hColumns, "caja_codigo",                {  "create"    => "VARCHAR( 20 )"                           ,;
                                                      "default"   => {|| Box():Codigo() } }                    )

   hset( ::hColumns, "fecha_hora_inicio",          {  "create"    => "TIMESTAMP"                               ,;
                                                      "default"   => {|| hb_datetime() } }                     )

   hset( ::hColumns, "fecha_hora_cierre",          {  "create"    => "TIMESTAMP"                               ,;
                                                      "default"   => {|| ctod( "" ) } }                        )

   hset( ::hColumns, "estado",                     {  "create"     => "ENUM( 'Abierta', 'Cerrada' )"           ,;
                                                      "default"    => {|| 'Abierta' }  }                       )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SesionesRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLSesionesModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//